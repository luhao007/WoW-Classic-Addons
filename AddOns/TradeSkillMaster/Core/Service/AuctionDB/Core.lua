-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local AuctionDB = TSM:NewPackage("AuctionDB")
local L = TSM.Locale.GetTable()
local Log = TSM.LibTSMUtil:Include("Util.Log")
local ChatMessage = TSM.LibTSMService:Include("UI.ChatMessage")
local Table = TSM.LibTSMUtil:Include("Lua.Table")
local TempTable = TSM.LibTSMUtil:Include("BaseType.TempTable")
local ItemString = TSM.LibTSMTypes:Include("Item.ItemString")
local Threading = TSM.LibTSMTypes:Include("Threading")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local CustomString = TSM.LibTSMTypes:Include("CustomString")
local AppHelper = TSM.LibTSMApp:Include("Service.AppHelper")
local private = {
	realmData = {},
	realmUpdateTime = nil,
	regionData = {},
	regionUpdateTime = nil,
	altRealmData = {},
	lastScanTemp = {},
}
local UPDATE_TIME_KEYS = {
	AUCTIONDB_NON_COMMODITY_DATA = true,
	AUCTIONDB_NON_COMMODITY_SCAN_STAT = true,
	AUCTIONDB_REGION_STAT = true,
	AUCTIONDB_REGION_HISTORICAL = true,
	AUCTIONDB_REGION_SALE = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnEnable()
	local realmData, regionData, commodityData, altRealmData = AppHelper.GetAuctionDBData()
	private.realmUpdateTime = private.LoadRegionRealmAppData(private.realmData, realmData)
	private.regionUpdateTime = private.LoadRegionRealmAppData(private.regionData, regionData)
	private.LoadRegionRealmAppData(private.realmData, commodityData)
	private.LoadRegionRealmAppData(private.altRealmData, altRealmData)
	if next(private.altRealmData) then
		private.LoadRegionRealmAppData(private.altRealmData, commodityData)
	end

	-- Pre-fetch item info for items currently on the AH
	if private.realmData.minBuyout then
		for itemString in pairs(private.realmData.minBuyout.itemLookup) do
			ItemInfo.FetchInfo(itemString)
		end
	end

	if private.realmUpdateTime == 0 then
		ChatMessage.PrintfUser(L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from %s to automatically update your AuctionDB data (and auto-backup your TSM settings)."], ChatMessage.ColorUserAccentText("https://tradeskillmaster.com"))
	end

	CustomString.InvalidateCache("DBMarket")
	CustomString.InvalidateCache("DBMinBuyout")
	CustomString.InvalidateCache("DBHistorical")
	CustomString.InvalidateCache("DBRecent")
	CustomString.InvalidateCache("DBRegionMarketAvg")
	CustomString.InvalidateCache("DBRegionHistorical")
	CustomString.InvalidateCache("DBRegionSaleAvg")
	CustomString.InvalidateCache("DBRegionSaleRate")
	CustomString.InvalidateCache("DBRegionSoldPerDay")
	collectgarbage()
end

function AuctionDB.GetAppDataUpdateTimes()
	return private.realmUpdateTime, private.regionUpdateTime
end

function AuctionDB.LastScanIteratorThreaded()
	wipe(private.lastScanTemp)
	local minBuyoutData = private.realmData.minBuyout
	local minBuyoutIndex = minBuyoutData.fieldLookup.minBuyout
	assert(minBuyoutIndex)
	local baseItems = Threading.AcquireSafeTempTable()
	for itemString in pairs(minBuyoutData.itemLookup) do
		local minBuyout = private.UnpackData(minBuyoutData, itemString)[minBuyoutIndex]
		itemString = ItemString.Get(itemString)
		local baseItemString = ItemString.GetBaseFast(itemString)
		if baseItemString ~= itemString then
			baseItems[baseItemString] = true
		end
		if minBuyout and minBuyout > 0 then
			private.lastScanTemp[itemString] = min(private.lastScanTemp[itemString] or math.huge, minBuyout)
		end
		Threading.Yield()
	end

	-- remove the base items since they would be double-counted with the specific variants
	for itemString in pairs(baseItems) do
		private.lastScanTemp[itemString] = nil
	end
	TempTable.Release(baseItems)

	return pairs(private.lastScanTemp)
end

function AuctionDB.GetRealmItemData(itemString, key)
	return private.GetItemDataHelper(private.realmData[key], key, itemString)
end

function AuctionDB.GetRegionItemData(itemString, key)
	local result = private.GetItemDataHelper(private.regionData[key], key, itemString)
	if key == "regionSalePercent" or key == "regionSoldPerDay" then
		result = result and (result / 1000) or nil
	end
	return result
end

function AuctionDB.GetAltRealmItemData(itemString, key)
	return private.GetItemDataHelper(private.altRealmData[key], key, itemString)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadRegionRealmAppData(tbl, appData)
	local maxUpdateTime = 0
	for key, data in pairs(appData) do
		local loadedData, updateTime = private.LoadAppData(data)
		local existing = tbl[next(loadedData.fieldLookup)]
		if existing then
			-- Merge items into existing realmData
			assert(Table.Equal(existing.fieldLookup, loadedData.fieldLookup))
			for itemString, itemData in pairs(loadedData.itemLookup) do
				if existing.itemLookup[itemString] then
					error("Duplicate data for item: "..tostring(itemString))
				end
				existing.itemLookup[itemString] = itemData
			end
		else
			for field in pairs(loadedData.fieldLookup) do
				assert(not tbl[field])
				tbl[field] = loadedData
			end
		end
		Log.Info("Loaded %s data (%s)", key, SecondsToTime(time() - updateTime).." ago")
		if UPDATE_TIME_KEYS[key] then
			maxUpdateTime = max(maxUpdateTime, updateTime)
		end
	end
	return maxUpdateTime
end

function private.LoadAppData(appData)
	-- Extract the metadata from the start of the string
	local metadataEndIndex, dataStartIndex = strfind(appData, ",data={")
	local itemData = strsub(appData, dataStartIndex + 1, -3)
	local metadataStr = strsub(appData, 1, metadataEndIndex - 1).."}"
	local metadata = assert(loadstring(metadataStr))()

	local result = { fieldLookup = {}, itemLookup = {} }
	assert(metadata.fields[1] == "itemString")
	for i = 2, #metadata.fields do
		result.fieldLookup[metadata.fields[i]] = i - 1
	end

	for itemString, otherData in gmatch(itemData, "{\"?([^,\"]+)\"?,([^}]+)}") do
		if tonumber(itemString) then
			itemString = "i:"..itemString
		end
		result.itemLookup[itemString] = otherData
	end

	return result, metadata.downloadTime
end

function private.GetItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then
		return nil
	end
	local fieldIndex = tbl.fieldLookup[key]
	if not fieldIndex then
		return nil
	end
	-- Convert to a level item string
	itemString = ItemString.ToLevel(itemString)
	if not tbl.itemLookup[itemString] then
		-- Try the base item
		itemString = ItemString.GetBaseFast(itemString)
		if not tbl.itemLookup[itemString] then
			return nil
		end
	end
	local data = private.UnpackData(tbl, itemString)
	local value = data and data[fieldIndex] or 0
	return value > 0 and value or nil
end

function private.UnpackData(tbl, itemString)
	local data = tbl.itemLookup[itemString]
	if type(data) ~= "string" then
		return data
	end
	-- Need to unpack the data
	local tblData = {strsplit(",", data)}
	for i = 1, #tblData do
		local val = tblData[i]
		if #val > 6 then
			-- tonumber only works for 32-bit values, so need to cut the value in half
			val = tonumber(strsub(val, -6), 32) + tonumber(strsub(val, 1, -7), 32) * (2 ^ 30)
		else
			val = tonumber(val, 32)
		end
		tblData[i] = val
	end
	tbl.itemLookup[itemString] = tblData
	data = tblData
	return data
end
