-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM:NewPackage("AuctionDB")
local L = TSM.Include("Locale").GetTable()
local Event = TSM.Include("Util.Event")
local Database = TSM.Include("Util.Database")
local CSV = TSM.Include("Util.CSV")
local Table = TSM.Include("Util.Table")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local ItemString = TSM.Include("Util.ItemString")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	region = nil,
	appRealmData = {},
	appRealmTime = nil,
	scanRealmData = {},
	scanRealmTime = nil,
	regionData = nil,
	scanDB = nil,
	scanThreadId = nil,
	ahOpen = false,
	marketValueDB = nil,
	marketValueQuery = nil,
	didScan = false,
	auctionScan = nil,
	lastProgressUpdateTime = 0,
}
local CSV_KEYS = { "itemString", "minBuyout", "marketValue", "numAuctions", "quantity", "lastScan" }



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnInitialize()
	private.scanThreadId = Threading.New("AUCTIONDB_SCAN", private.ScanThread)
	private.scanDB = TSMAPI_FOUR.Auction.NewDatabase("AUCTIONDB_SCAN")
	private.marketValueDB = Database.NewSchema("AUCTIONDB_MARKET_VALUE")
		:AddStringField("itemString")
		:AddNumberField("itemBuyout")
		:AddNumberField("index")
		:AddIndex("itemString")
		:AddIndex("index")
		:Commit()
	private.marketValueQuery = private.marketValueDB:NewQuery()
		:Equal("itemString", Database.BoundQueryParam())
		:GreaterThanOrEqual("index", Database.BoundQueryParam())
		:LessThanOrEqual("index", Database.BoundQueryParam())
		:GreaterThanOrEqual("itemBuyout", Database.BoundQueryParam())
		:LessThanOrEqual("itemBuyout", Database.BoundQueryParam())
		:Select("itemBuyout")
		:OrderBy("index", true)
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
				local regionData, lastUpdate = private.LoadRegionAppData(data)
				if regionData then
					private.regionData = regionData
					downloadTime = SecondsToTime(time() - lastUpdate).." ago"
				end
			elseif TSMAPI.AppHelper:IsCurrentRealm(realm) then
				realmAppData = private.ProcessRealmAppData(data)
				downloadTime = SecondsToTime(time() - realmAppData.downloadTime).." ago"
			end
			Log.Info("Got AppData for %s (isCurrent=%s, %s)", realm, tostring(TSMAPI.AppHelper:IsCurrentRealm(realm)), downloadTime)
		end
	end

	-- check if we can load realm data from the app
	if realmAppData then
		private.appRealmTime = realmAppData.downloadTime
		local auctionCounts = {}
		local baseItems = TempTable.Acquire()
		local fields = realmAppData.fields
		for _, data in ipairs(realmAppData.data) do
			local itemString = nil
			for i, key in ipairs(fields) do
				if i == 1 then
					-- item string must be the first field
					if type(data[i]) == "number" then
						itemString = "i:"..data[i]
					else
						itemString = gsub(data[i], ":0:", "::")
					end
					itemString = ItemString.Get(itemString)
					private.appRealmData[itemString] = {}
				else
					private.appRealmData[itemString][key] = data[i]
				end
			end
			private.appRealmData[itemString].lastScan = realmAppData.downloadTime
			local baseItemString = ItemString.GetBaseFast(itemString)
			if baseItemString ~= itemString then
				baseItems[baseItemString] = true
			end
		end
		for itemString, data in pairs(private.appRealmData) do
			if not baseItems[itemString] then
				auctionCounts[itemString] = data.numAuctions
			end
		end
		TempTable.Release(baseItems)
		TSM.Auction.QueryUtil.SetAuctionCounts(auctionCounts, private.appRealmTime)
	end

	for itemString in pairs(private.appRealmData) do
		ItemInfo.FetchInfo(itemString)
	end
	if TSM.db.factionrealm.internalData.auctionDBScanTime > 0 then
		private.LoadSVRealmData()
	end
	if not next(private.appRealmData) and not next(private.scanRealmData) then
		Log.PrintUser(L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."])
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

function AuctionDB.GetLastCompleteScanTime()
	return private.didScan and (private.scanRealmTime or 0) or (private.appRealmTime or 0)
end

function AuctionDB.LastScanIteratorThreaded()
	local itemNumAuctions = Threading.AcquireSafeTempTable()
	local itemMinBuyout = Threading.AcquireSafeTempTable()
	local baseItems = Threading.AcquireSafeTempTable()

	local realmData = private.didScan and private.scanRealmData or private.appRealmData
	local lastScanTime = AuctionDB.GetLastCompleteScanTime()
	for itemString, data in pairs(realmData) do
		if data.lastScan >= lastScanTime then
			itemString = ItemString.Get(itemString)
			local baseItemString = ItemString.GetBase(itemString)
			if baseItemString ~= itemString then
				baseItems[baseItemString] = true
			end
			itemNumAuctions[itemString] = (itemNumAuctions[itemString] or 0) + data.numAuctions
			if data.minBuyout and data.minBuyout > 0 then
				itemMinBuyout[itemString] = min(itemMinBuyout[itemString] or math.huge, data.minBuyout)
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
	else
		-- use appRealmData if available
		realmData = next(private.appRealmData) and private.appRealmData or private.scanRealmData
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
	Log.PrintUser(L["Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."])
	Threading.Start(private.scanThreadId)
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread()
	-- release the previous scan if needed
	if private.auctionScan then
		private.auctionScan:Release()
	end

	-- clear out any prior results
	private.scanDB:Truncate()

	-- start the new scan
	private.auctionScan = TSMAPI_FOUR.Auction.NewAuctionScan(private.scanDB)
		:SetResolveSellers(false)
		:SetIgnoreItemLevel(true)
		:SetScript("OnProgressUpdate", private.OnProgressUpdate)
		:SetScript("OnFilterDone", private.OnFullScanDone)
	private.auctionScan:NewAuctionFilter()
		:SetGetAll(true)
	private.auctionScan:StartScanThreaded()
end

function private.OnProgressUpdate()
	local _, _, page, totalPages = private.auctionScan:GetProgress()
	if totalPages > 0 and time() - private.lastProgressUpdateTime > 5 then
		Log.PrintfUser(L["Scanning is %d%% complete"], Math.Round(page * 100 / totalPages))
		private.lastProgressUpdateTime = time()
	end
end

function private.OnFullScanDone()
	Log.PrintfUser(L["Processing scan results..."])
	wipe(private.scanRealmData)
	for _, data in pairs(private.scanRealmData) do
		data.minBuyout = 0
		data.numAuctions = 0
		data.quantity = 0
	end
	local scannedItems = Threading.AcquireSafeTempTable()
	private.scanRealmTime = time()
	TSM.db.factionrealm.internalData.auctionDBScanTime = time()
	TSM.db.factionrealm.internalData.csvAuctionDBScan = ""
	private.marketValueDB:TruncateAndBulkInsertStart()
	local scanQuery = private.scanDB:NewQuery()
		:Select("baseItemString", "stackSize", "itemBuyout")
		:OrderBy("itemBuyout", true)
	for _, baseItemString, stackSize, itemBuyout in scanQuery:Iterator() do
		private.ProcessScanResultItem(baseItemString, itemBuyout, stackSize)
		scannedItems[baseItemString] = true
	end
	local numScannedAuctions = scanQuery:Count()
	scanQuery:Release()
	private.scanDB:Truncate()
	private.marketValueDB:BulkInsertEnd()
	Threading.Yield()

	for itemString in pairs(scannedItems) do
		local data = private.scanRealmData[itemString]
		data.marketValue = private.CalculateItemMarketValue(itemString, data.quantity)
		assert(data.minBuyout == 0 or data.marketValue >= data.minBuyout)
		Threading.Yield()
	end
	private.marketValueDB:Truncate()
	Threading.ReleaseSafeTempTable(scannedItems)

	collectgarbage()
	Log.PrintfUser(L["Completed full AH scan (%d auctions)!"], numScannedAuctions)
	private.didScan = true
	CustomPrice.OnSourceChange("DBMinBuyout")
end

function private.ProcessScanResultItem(itemString, itemBuyout, stackSize)
	private.scanRealmData[itemString] = private.scanRealmData[itemString] or { numAuctions = 0, quantity = 0, minBuyout = 0 }
	local data = private.scanRealmData[itemString]
	data.lastScan = time()
	if itemBuyout > 0 then
		data.minBuyout = min(data.minBuyout > 0 and data.minBuyout or math.huge, itemBuyout)
		for _ = 1, stackSize do
			data.quantity = data.quantity + 1
			private.marketValueDB:BulkInsertNewRow(itemString, itemBuyout, data.quantity)
		end
	end
	data.numAuctions = data.numAuctions + 1
end

function private.CalculateItemMarketValue(itemString, quantity)
	if quantity == 0 then
		return 0
	end

	-- calculate the average of the lowest 15-30% of auctions
	local total, num = 0, 0
	local lowBucketNum = max(floor(quantity * 0.15), 1)
	local midBucketNum = max(floor(quantity * 0.30), 1)
	local prevItemBuyout = 0
	private.marketValueQuery:BindParams(itemString, 1, midBucketNum, 0, math.huge)
	for _, itemBuyout in private.marketValueQuery:Iterator() do
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
		private.marketValueQuery:BindParams(itemString, 1, num, 0, math.huge)
		for _, itemBuyout in private.marketValueQuery:Iterator() do
			stdevSum = stdevSum + (itemBuyout - avg) ^ 2
		end
		stdev = sqrt(stdevSum / (num - 1))
	else
		stdev = 0
	end

	-- calculate the market value as the average of all data within 1.5 stdev of our previous average
	private.marketValueQuery:BindParams(itemString, 1, num, avg - stdev * 1.5, avg + stdev * 1.5)
	return floor(private.marketValueQuery:Avg("itemBuyout"))
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
	if not itemString or not tbl then return end
	itemString = ItemString.Filter(itemString)
	local value = nil
	if tbl[itemString] then
		value = tbl[itemString][key]
	else
		local quality = ItemInfo.GetQuality(itemString)
		local itemLevel = ItemInfo.GetItemLevel(itemString)
		local classId = ItemInfo.GetClassId(itemString)
		if quality and quality >= 2 and itemLevel and itemLevel >= TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR) then
			if strmatch(itemString, "^i:[0-9]+:[0-9%-]*:") then return end
		end
		local baseItemString = ItemString.GetBase(itemString)
		if not baseItemString then return end
		value = tbl[baseItemString] and tbl[baseItemString][key]
	end
	if not value or value <= 0 then return end
	return value
end

function private.GetRegionItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then
		return
	end
	itemString = ItemString.Filter(itemString)
	local fieldIndex = tbl.fieldLookup[key] - 1
	assert(fieldIndex and fieldIndex > 0)
	local data = tbl.itemLookup[itemString]
	if not data and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- for items with random enchants or for pets, get data for the base item
		local quality = ItemInfo.GetQuality(itemString)
		local itemLevel = ItemInfo.GetItemLevel(itemString)
		local classId = ItemInfo.GetClassId(itemString)
		if quality and quality >= 2 and itemLevel and itemLevel >= TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR) then
			if strmatch(itemString, "^i:[0-9]+:[0-9%-]*:") then
				return
			end
		end
		itemString = ItemString.GetBase(itemString)
		if not itemString then return end
		data = tbl.itemLookup[itemString]
	end
	if not data then
		return
	end
	if type(data) == "string" then
		local tblData = {strsplit(",", data)}
		for i = 1, #tblData do
			tblData[i] = tonumber(tblData[i])
		end
		tbl.itemLookup[itemString] = tblData
		data = tblData
	end
	local value = data[fieldIndex]
	if not value or value <= 0 then
		return
	end
	return value
end

function private.OnAuctionHouseShow()
	private.ahOpen = true
	if not TSM.IsWowClassic() or not select(2, CanSendAuctionQuery()) then
		return
	elseif (AuctionDB.GetLastCompleteScanTime() or 0) > time() - 60 * 60 * 6 then
		return
	end
	StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] = StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] or {
		text = L["TSM does not have recent AuctionDB data. You can run '/tsm scan' to manually scan the AH."],
		button1 = OKAY,
		timeout = 0,
		whileDead = true,
	}
	TSM.Wow.ShowStaticPopupDialog("TSM_AUCTIONDB_SCAN")
end

function private.OnAuctionHouseClosed()
	private.ahOpen = false
end
