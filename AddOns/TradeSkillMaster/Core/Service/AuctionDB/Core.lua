-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM:NewPackage("AuctionDB")
local L = TSM.Include("Locale").GetTable()
local Event = TSM.Include("Util.Event")
local CSV = TSM.Include("Util.CSV")
local Table = TSM.Include("Util.Table")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Wow = TSM.Include("Util.Wow")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local AuctionScan = TSM.Include("Service.AuctionScan")
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
	scanRealmData = {},
	scanRealmTime = nil,
	scanThreadId = nil,
	ahOpen = false,
	didScan = false,
	auctionScan = nil,
	isScanning = false,
}
local CSV_KEYS = { "itemString", "minBuyout", "marketValue", "numAuctions", "quantity", "lastScan" }



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnInitialize()
	private.scanThreadId = Threading.New("AUCTIONDB_SCAN", private.ScanThread)
	Threading.SetCallback(private.scanThreadId, private.ScanThreadCleanup)
	Event.Register("AUCTION_HOUSE_SHOW", private.OnAuctionHouseShow)
	Event.Register("AUCTION_HOUSE_CLOSED", private.OnAuctionHouseClosed)
end

function AuctionDB.OnEnable()
	private.region = TSM.GetRegion()

	local realmAppData = nil
	local appData = TSMAPI.AppHelper and TSMAPI.AppHelper:FetchData("AUCTIONDB_MARKET_DATA") -- get app data from TSM_AppHelper if it's installed
	if appData then
		for _, info in ipairs(appData) do
			local realm, data = unpack(info)
			local downloadTime = "?"
			-- try switching around "Classic-[US|EU]" to match the addon's "[US|EU]-Classic" format for classic region data
			if realm == private.region or gsub(realm, "Classic-%-([A-Z]+)", "%1-Classic") == private.region then
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
					end
					itemString = ItemString.Get(itemString)
					private.realmAppData.itemOffset[itemString] = nextItmeOffset
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
	if TSM.db.factionrealm.internalData.auctionDBScanTime > 0 then
		private.LoadSVRealmData()
	end
	if not private.realmAppData.numFields and not next(private.scanRealmData) then
		Log.PrintfUser(L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from %s to automatically update your AuctionDB data (and auto-backup your TSM settings)."], Log.ColorUserAccentText("https://tradeskillmaster.com"))
	end

	CustomPrice.OnSourceChange("DBMarket")
	CustomPrice.OnSourceChange("DBMinBuyout")
	CustomPrice.OnSourceChange("DBHistorical")
	CustomPrice.OnSourceChange("DBRegionMinBuyoutAvg")
	CustomPrice.OnSourceChange("DBRegionMarketAvg")
	CustomPrice.OnSourceChange("DBRegionHistorical")
	CustomPrice.OnSourceChange("DBRegionSaleAvg")
	CustomPrice.OnSourceChange("DBRegionSaleRate")
	CustomPrice.OnSourceChange("DBRegionSoldPerDay")
	collectgarbage()
end

function AuctionDB.OnDisable()
	if not private.didScan then
		return
	end

	local encodeContext = CSV.EncodeStart(CSV_KEYS)
	for itemString, data in pairs(private.scanRealmData) do
		CSV.EncodeAddRowDataRaw(encodeContext, itemString, data.minBuyout, data.marketValue, data.numAuctions, data.quantity, data.lastScan)
	end
	TSM.db.factionrealm.internalData.csvAuctionDBScan = CSV.EncodeEnd(encodeContext)
	TSM.db.factionrealm.internalData.auctionDBScanHash = Math.CalculateHash(TSM.db.factionrealm.internalData.csvAuctionDBScan)
end

function AuctionDB.GetAppDataUpdateTimes()
	return private.realmAppData.scanTime or 0, private.regionUpdateTime or 0
end

function AuctionDB.GetLastCompleteScanTime()
	local result = private.didScan and (private.scanRealmTime or 0) or (private.realmAppData.scanTime or 0)
	return result ~= 0 and result or nil
end

function AuctionDB.LastScanIteratorThreaded()
	local itemNumAuctions = Threading.AcquireSafeTempTable()
	local itemMinBuyout = Threading.AcquireSafeTempTable()
	local baseItems = Threading.AcquireSafeTempTable()

	local lastScanTime = AuctionDB.GetLastCompleteScanTime()
	for itemString, data in pairs(private.didScan and private.scanRealmData or private.realmAppData.itemOffset) do
		if not private.didScan or data.lastScan >= lastScanTime then
			itemString = ItemString.Get(itemString)
			local baseItemString = ItemString.GetBaseFast(itemString)
			if baseItemString ~= itemString then
				baseItems[baseItemString] = true
			end
			local numAuctions, minBuyout = nil, nil
			if private.didScan then
				numAuctions = data.numAuctions
				minBuyout = data.minBuyout
			else
				numAuctions = private.realmAppData.data[data * private.realmAppData.numFields + private.realmAppData.fieldOffset.numAuctions]
				minBuyout = private.realmAppData.data[data * private.realmAppData.numFields + private.realmAppData.fieldOffset.minBuyout]
			end
			itemNumAuctions[itemString] = (itemNumAuctions[itemString] or 0) + numAuctions
			if minBuyout and minBuyout > 0 then
				itemMinBuyout[itemString] = min(itemMinBuyout[itemString] or math.huge, minBuyout)
			end
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
	local realmData = nil
	if private.didScan and (key == "minBuyout" or key == "numAuctions" or key == "lastScan") then
		-- always use scanRealmData for minBuyout/numAuctions/lastScan if we've done a scan
		realmData = private.scanRealmData
	elseif private.realmAppData.numFields then
		-- use app data
		return private.GetRealmAppItemDataHelper(private.realmAppData, key, itemString)
	else
		realmData = private.scanRealmData
	end
	return private.GetItemDataHelper(realmData, key, itemString)
end

function AuctionDB.GetRegionItemData(itemString, key)
	return private.GetRegionItemDataHelper(private.regionData, key, itemString)
end

function AuctionDB.GetRegionSaleInfo(itemString, key)
	-- need to divide the result by 100
	local result = private.GetRegionItemDataHelper(private.regionData, key, itemString)
	return result and (result / 100) or nil
end

function AuctionDB.RunScan()
	if private.isScanning then
		return
	end
	if not private.ahOpen then
		Log.PrintUser(L["ERROR: The auction house must be open in order to do a scan."])
		return
	end
	local canScan, canGetAllScan = CanSendAuctionQuery()
	if not canScan then
		Log.PrintUser(L["ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."])
		return
	elseif not canGetAllScan then
		Log.PrintUser(L["ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."])
		return
	end
	if not TSM.UI.AuctionUI.StartingScan("FULL_SCAN") then
		return
	end
	Log.PrintUser(L["Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."])
	Threading.Start(private.scanThreadId)
	private.isScanning = true
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread()
	assert(not private.auctionScan)

	-- run the scan
	local auctionScan = AuctionScan.GetManager()
		:SetResolveSellers(false)
	private.auctionScan = auctionScan
	local query = auctionScan:NewQuery()
		:SetGetAll(true)
	if not auctionScan:ScanQueriesThreaded() then
		Log.PrintUser(L["Failed to run full AH scan."])
		return
	end

	-- process the results
	Log.PrintfUser(L["Processing scan results..."])
	wipe(private.scanRealmData)
	private.scanRealmTime = time()
	TSM.db.factionrealm.internalData.auctionDBScanTime = time()
	TSM.db.factionrealm.internalData.csvAuctionDBScan = ""
	local numScannedAuctions = 0
	local subRows = Threading.AcquireSafeTempTable()
	local subRowSortValue = Threading.AcquireSafeTempTable()
	local itemBuyouts = Threading.AcquireSafeTempTable()
	for baseItemString, row in query:BrowseResultsIterator() do
		wipe(subRows)
		wipe(subRowSortValue)
		for _, subRow in row:SubRowIterator() do
			local _, itemBuyout = subRow:GetBuyouts()
			tinsert(subRows, subRow)
			subRowSortValue[subRow] = itemBuyout
		end
		Table.SortWithValueLookup(subRows, subRowSortValue, false, true)

		wipe(itemBuyouts)
		for _, subRow in ipairs(subRows) do
			local _, itemBuyout = subRow:GetBuyouts()
			local quantity, numAuctions = subRow:GetQuantities()
			numScannedAuctions = numScannedAuctions + numAuctions
			for _ = 1, numAuctions do
				private.ProcessScanResultItem(baseItemString, itemBuyout, quantity)
			end
			if itemBuyout > 0 then
				for _ = 1, quantity * numAuctions do
					tinsert(itemBuyouts, itemBuyout)
				end
			end
		end

		local data = private.scanRealmData[baseItemString]
		data.marketValue = private.CalculateItemMarketValue(itemBuyouts, data.quantity)
		assert(data.minBuyout == 0 or data.marketValue >= data.minBuyout)
		Threading.Yield()
	end
	Threading.ReleaseSafeTempTable(subRows)
	Threading.ReleaseSafeTempTable(subRowSortValue)
	Threading.ReleaseSafeTempTable(itemBuyouts)
	Threading.Yield()

	collectgarbage()
	Log.PrintfUser(L["Completed full AH scan (%d auctions)!"], numScannedAuctions)
	private.didScan = true
	CustomPrice.OnSourceChange("DBMinBuyout")
end

function private.ScanThreadCleanup()
	private.isScanning = false
	if private.auctionScan then
		private.auctionScan:Release()
		private.auctionScan = nil
	end
	TSM.UI.AuctionUI.EndedScan("FULL_SCAN")
end

function private.ProcessScanResultItem(itemString, itemBuyout, stackSize)
	private.scanRealmData[itemString] = private.scanRealmData[itemString] or { numAuctions = 0, quantity = 0, minBuyout = 0 }
	local data = private.scanRealmData[itemString]
	data.lastScan = time()
	if itemBuyout > 0 then
		data.minBuyout = min(data.minBuyout > 0 and data.minBuyout or math.huge, itemBuyout)
		data.quantity = data.quantity + stackSize
	end
	data.numAuctions = data.numAuctions + 1
end

function private.CalculateItemMarketValue(itemBuyouts, quantity)
	assert(#itemBuyouts == quantity)
	if quantity == 0 then
		return 0
	end

	-- calculate the average of the lowest 15-30% of auctions
	local total, num = 0, 0
	local lowBucketNum = max(floor(quantity * 0.15), 1)
	local midBucketNum = max(floor(quantity * 0.30), 1)
	local prevItemBuyout = 0
	for i = 1, midBucketNum do
		local itemBuyout = itemBuyouts[i]
		if num < lowBucketNum or itemBuyout < prevItemBuyout * 1.2 then
			num = num + 1
			total = total + itemBuyout
		end
		prevItemBuyout = itemBuyout
	end
	local avg = total / num

	-- calculate the stdev of the auctions we used in the average
	local stdev = nil
	if num > 1 then
		local stdevSum = 0
		for i = 1, num do
			local itemBuyout = itemBuyouts[i]
			stdevSum = stdevSum + (itemBuyout - avg) ^ 2
		end
		stdev = sqrt(stdevSum / (num - 1))
	else
		stdev = 0
	end

	-- calculate the market value as the average of all data within 1.5 stdev of our previous average
	local minItemBuyout = avg - stdev * 1.5
	local maxItemBuyout = avg + stdev * 1.5
	local avgTotal, avgCount = 0, 0
	for i = 1, num do
		local itemBuyout = itemBuyouts[i]
		if itemBuyout >= minItemBuyout and itemBuyout <= maxItemBuyout then
			avgTotal = avgTotal + itemBuyout
			avgCount = avgCount + 1
		end
	end
	return avgTotal > 0 and floor(avgTotal / avgCount) or 0
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadSVRealmData()
	local decodeContext = CSV.DecodeStart(TSM.db.factionrealm.internalData.csvAuctionDBScan, CSV_KEYS)
	if not decodeContext then
		Log.Err("Failed to decode records")
		return
	end
	for itemString, minBuyout, marketValue, numAuctions, quantity, lastScan in CSV.DecodeIterator(decodeContext) do
		private.scanRealmData[itemString] = {
			minBuyout = tonumber(minBuyout),
			marketValue = tonumber(marketValue),
			numAuctions = tonumber(numAuctions),
			quantity = tonumber(quantity),
			lastScan = tonumber(lastScan),
		}
	end
	if not CSV.DecodeEnd(decodeContext) then
		Log.Err("Failed to decode records")
	end
	private.scanRealmTime = TSM.db.factionrealm.internalData.auctionDBScanTime
end

function private.ProcessRealmAppData(rawData)
	if #rawData < 3500000 then
		-- we can safely just use loadstring() for strings below 3.5M
		return assert(loadstring(rawData)())
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

function private.GetItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then
		return nil
	end
	itemString = ItemString.Filter(itemString)
	local value = nil
	if not tbl[itemString] and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- for items with random enchants or for pets, get data for the base item
		itemString = private.GetBaseItemHelper(itemString)
	end
	if not itemString or not tbl[itemString] then
		return nil
	end
	value = tbl[itemString][key]
	return (value or 0) > 0 and value or nil
end

function private.GetRegionItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then
		return nil
	end
	itemString = ItemString.Filter(itemString)
	local fieldIndex = tbl.fieldLookup[key] - 1
	assert(fieldIndex and fieldIndex > 0)
	local data = tbl.itemLookup[itemString]
	if not data and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- for items with random enchants or for pets, get data for the base item
		itemString = private.GetBaseItemHelper(itemString)
		itemString = ItemString.GetBase(itemString)
		if not itemString then
			return nil
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
		-- for items with random enchants or for pets, get data for the base item
		itemString = private.GetBaseItemHelper(itemString)
		if not itemString then
			return nil
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

function private.OnAuctionHouseShow()
	private.ahOpen = true
	if not TSM.IsWowClassic() or not select(2, CanSendAuctionQuery()) then
		return
	elseif (AuctionDB.GetLastCompleteScanTime() or 0) > time() - 60 * 60 * 2 then
		-- the most recent scan is from the past 2 hours
		return
	elseif (TSM.db.factionrealm.internalData.auctionDBScanTime or 0) > time() - 60 * 60 * 24 then
		-- this user has contributed a scan within the past 24 hours
		return
	end
	StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] = StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] or {
		text = L["TSM does not have recent AuctionDB data. Would you like to run a full AH scan?"],
		button1 = YES,
		button2 = NO,
		timeout = 0,
		OnAccept = AuctionDB.RunScan,
	}
	Wow.ShowStaticPopupDialog("TSM_AUCTIONDB_SCAN")
end

function private.OnAuctionHouseClosed()
	private.ahOpen = false
end
