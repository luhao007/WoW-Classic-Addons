-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM:NewPackage("AuctionDB")
local L = TSM.Include("Locale").GetTable()
local Table = TSM.Include("Util.Table")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	region = nil,
	realmAppData = {
		scanTime = nil,
		data = {},
		itemOffset = {},
		fieldOffset = {},
		numFields = nil,
	},
	regionData = nil,
	regionUpdateTime = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnEnable()
	private.region = TSM.GetRegion()

	local realmAppData = nil
	local appData = TSMAPI.AppHelper and TSMAPI.AppHelper:FetchData("AUCTIONDB_MARKET_DATA") -- get app data from TSM_AppHelper if it's installed
	if appData then
		for _, info in ipairs(appData) do
			local realm, data = unpack(info)
			local downloadTime = "?"
			-- try switching around "Classic-[US|EU]" to match the addon's "[US|EU]-[Classic|BCC]" format for classic/BCC region data
			if realm == private.region or gsub(realm, "Classic-%-([A-Z]+)", "%1-Classic") == private.region or gsub(realm, "BCC-%-([A-Z]+)", "%1-BCC") == private.region then
				private.regionData, private.regionUpdateTime = private.LoadRegionAppData(data)
				downloadTime = SecondsToTime(time() - private.regionUpdateTime).." ago"
			elseif TSMAPI.AppHelper:IsCurrentRealm(realm) then
				realmAppData = private.ProcessRealmAppData(data)
				downloadTime = SecondsToTime(time() - realmAppData.downloadTime).." ago"
			end
			Log.Info("Got AppData for %s (isCurrent=%s, %s)", realm, tostring(TSMAPI.AppHelper:IsCurrentRealm(realm)), downloadTime)
		end
	end

	-- check if we can load realm data from the app
	if realmAppData then
		private.realmAppData.scanTime = realmAppData.downloadTime
		for i = 2, #realmAppData.fields do
			private.realmAppData.fieldOffset[realmAppData.fields[i]] = i - 1
		end
		private.realmAppData.numFields = #realmAppData.fields - 1
		local numRawFields = #realmAppData.fields
		local nextItmeOffset, nextDataOffset = 0, 1
		for _, data in ipairs(realmAppData.data) do
			for i = 1, numRawFields do
				local value = data[i]
				if i == 1 then
					-- item string must be the first field
					local itemString = nil
					if type(value) == "number" then
						itemString = "i:"..value
					else
						itemString = gsub(value, ":0:", "::")
						-- TODO: remove once the data is fixed
						itemString = gsub(value, ":i([%+%-])", ":%1")
					end
					itemString = ItemString.Get(itemString)
					if itemString then
						private.realmAppData.itemOffset[itemString] = nextItmeOffset
					end
					nextItmeOffset = nextItmeOffset + 1
				else
					private.realmAppData.data[nextDataOffset] = value
					nextDataOffset = nextDataOffset + 1
				end
			end
		end
	end

	for itemString in pairs(private.realmAppData.itemOffset) do
		ItemInfo.FetchInfo(itemString)
	end
	if not private.realmAppData.numFields then
		Log.PrintfUser(L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from %s to automatically update your AuctionDB data (and auto-backup your TSM settings)."], Log.ColorUserAccentText("https://tradeskillmaster.com"))
	end

	CustomPrice.OnSourceChange("DBMarket")
	CustomPrice.OnSourceChange("DBMinBuyout")
	CustomPrice.OnSourceChange("DBHistorical")
	CustomPrice.OnSourceChange("DBRegionMarketAvg")
	CustomPrice.OnSourceChange("DBRegionHistorical")
	CustomPrice.OnSourceChange("DBRegionSaleAvg")
	CustomPrice.OnSourceChange("DBRegionSaleRate")
	CustomPrice.OnSourceChange("DBRegionSoldPerDay")
	collectgarbage()
end

function AuctionDB.GetAppDataUpdateTimes()
	return private.realmAppData.scanTime or 0, private.regionUpdateTime or 0
end

function AuctionDB.GetLastCompleteScanTime()
	local result = private.realmAppData.scanTime or 0
	return result ~= 0 and result or nil
end

function AuctionDB.LastScanIteratorThreaded()
	local itemNumAuctions = Threading.AcquireSafeTempTable()
	local itemMinBuyout = Threading.AcquireSafeTempTable()
	local baseItems = Threading.AcquireSafeTempTable()

	for itemString, data in pairs(private.realmAppData.itemOffset) do
		itemString = ItemString.Get(itemString)
		local baseItemString = ItemString.GetBaseFast(itemString)
		if baseItemString ~= itemString then
			baseItems[baseItemString] = true
		end
		local numAuctions = private.realmAppData.data[data * private.realmAppData.numFields + private.realmAppData.fieldOffset.numAuctions]
		local minBuyout = private.realmAppData.data[data * private.realmAppData.numFields + private.realmAppData.fieldOffset.minBuyout]
		itemNumAuctions[itemString] = (itemNumAuctions[itemString] or 0) + numAuctions
		if minBuyout and minBuyout > 0 then
			itemMinBuyout[itemString] = min(itemMinBuyout[itemString] or math.huge, minBuyout)
		end
		Threading.Yield()
	end

	-- remove the base items since they would be double-counted with the specific variants
	for itemString in pairs(baseItems) do
		itemNumAuctions[itemString] = nil
		itemMinBuyout[itemString] = nil
	end
	Threading.ReleaseSafeTempTable(baseItems)

	-- convert the remaining items into a list
	local itemList = Threading.AcquireSafeTempTable()
	itemList.numAuctions = itemNumAuctions
	itemList.minBuyout = itemMinBuyout
	for itemString in pairs(itemNumAuctions) do
		tinsert(itemList, itemString)
	end
	return Table.Iterator(itemList, private.LastScanIteratorHelper, itemList, private.LastScanIteratorCleanup)
end

function AuctionDB.GetRealmItemData(itemString, key)
	return private.GetRealmAppItemDataHelper(private.realmAppData, key, itemString)
end

function AuctionDB.GetRegionItemData(itemString, key)
	return private.GetRegionItemDataHelper(private.regionData, key, itemString)
end

function AuctionDB.GetRegionSaleInfo(itemString, key)
	-- need to divide the result by 100
	local result = private.GetRegionItemDataHelper(private.regionData, key, itemString)
	return result and (result / 100) or nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ProcessRealmAppData(rawData)
	if #rawData < 3500000 then
		-- we can safely just use loadstring() for strings below 3.5M
		return assert(assert(loadstring(rawData))())
	end
	-- load the data in chunks
	local leader, itemData, trailer = strmatch(rawData, "^(.+)data={({.+})}(.+)$")
	local resultData = {}
	local chunkStart, chunkEnd, nextChunkStart = 1, nil, nil
	while chunkStart do
		chunkEnd, nextChunkStart = strfind(itemData, "},{", chunkStart + 3400000)
		local chunkData = assert(loadstring("return {"..strsub(itemData, chunkStart, chunkEnd).."}")())
		for _, data in ipairs(chunkData) do
			tinsert(resultData, data)
		end
		chunkStart = nextChunkStart
	end
	__AUCTIONDB_IMPORT_TEMP = resultData
	local result = assert(loadstring(leader.."data=__AUCTIONDB_IMPORT_TEMP"..trailer)())
	__AUCTIONDB_IMPORT_TEMP = nil
	return result
end

function private.LoadRegionAppData(appData)
	local metaDataEndIndex, dataStartIndex = strfind(appData, ",data={")
	local itemData = strsub(appData, dataStartIndex + 1, -3)
	local metaDataStr = strsub(appData, 1, metaDataEndIndex - 1).."}"
	local metaData = assert(loadstring(metaDataStr))()
	local result = { fieldLookup = {}, itemLookup = {} }
	for i, field in ipairs(metaData.fields) do
		result.fieldLookup[field] = i
	end

	for itemString, otherData in gmatch(itemData, "{([^,]+),([^}]+)}") do
		if tonumber(itemString) then
			itemString = "i:"..itemString
		else
			itemString = gsub(strsub(itemString, 2, -2), ":0:", "::")
			-- TODO: remove once the data is fixed
			itemString = gsub(itemString, ":i([%+%-])", ":%1")
		end
		result.itemLookup[itemString] = otherData
	end

	return result, metaData.downloadTime
end

function private.LastScanIteratorHelper(index, itemString, tbl)
	return index, itemString, tbl.numAuctions[itemString], tbl.minBuyout[itemString]
end

function private.LastScanIteratorCleanup(tbl)
	Threading.ReleaseSafeTempTable(tbl.numAuctions)
	Threading.ReleaseSafeTempTable(tbl.minBuyout)
	Threading.ReleaseSafeTempTable(tbl)
end

function private.GetRegionItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl or not tbl.fieldLookup[key] then
		return nil
	end
	itemString = ItemString.Filter(itemString)
	local fieldIndex = tbl.fieldLookup[key] - 1
	assert(fieldIndex and fieldIndex > 0)
	local data = tbl.itemLookup[itemString]
	if not data and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- first try to get the data for the level itemString (if there is an explicit one)
		local levelItemString = ItemString.ToLevel(itemString)
		levelItemString = ItemString.IsLevel(levelItemString) and levelItemString or nil
		if levelItemString and tbl.itemLookup[levelItemString] then
			itemString = levelItemString
		else
			-- try the base item
			itemString = private.GetBaseItemHelper(itemString)
			if not itemString then
				return nil
			end
		end
		data = tbl.itemLookup[itemString]
	end
	if type(data) == "string" then
		local tblData = {strsplit(",", data)}
		for i = 1, #tblData do
			tblData[i] = tonumber(tblData[i])
		end
		tbl.itemLookup[itemString] = tblData
		data = tblData
	end
	if not data then
		return nil
	end
	local value = data[fieldIndex]
	return (value or 0) > 0 and value or nil
end

function private.GetRealmAppItemDataHelper(appData, key, itemString)
	if not itemString or not appData.numFields then
		return nil
	elseif key == "lastScan" then
		return appData.scanTime
	end
	itemString = ItemString.Filter(itemString)
	if not appData.itemOffset[itemString] and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- first try to get the data for the level itemString (if there is an explicit one)
		local levelItemString = ItemString.ToLevel(itemString)
		levelItemString = ItemString.IsLevel(levelItemString) and levelItemString or nil
		if levelItemString and appData.itemOffset[levelItemString] then
			itemString = levelItemString
		else
			-- try the base item
			itemString = private.GetBaseItemHelper(itemString)
			if not itemString then
				return nil
			end
		end
	end
	if not appData.itemOffset[itemString] then
		return nil
	end
	local value = appData.data[appData.itemOffset[itemString] * appData.numFields + appData.fieldOffset[key]]
	return (value or 0) > 0 and value or nil
end

function private.GetBaseItemHelper(itemString)
	local quality = ItemInfo.GetQuality(itemString)
	local itemLevel = ItemInfo.GetItemLevel(itemString)
	local classId = ItemInfo.GetClassId(itemString)
	if quality and quality >= 2 and itemLevel and itemLevel >= TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR) then
		if strmatch(itemString, "^i:[0-9]+:[0-9%-]*:") then
			return nil
		end
	end
	return ItemString.GetBaseFast(itemString)
end
