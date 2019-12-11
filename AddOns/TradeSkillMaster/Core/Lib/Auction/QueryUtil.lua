-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local QueryUtil = TSM.Auction:NewPackage("QueryUtil")
local TempTable = TSM.Include("Util.TempTable")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	counts = nil,
	countsUpdateTime = 0,
	itemStrings = {},
	isComplete = false,
	lastPopulateAttempt = nil,
	itemListByClass = {},
}
local MAX_SCAN_DATA_AGE = 24 * 60 * 60
local MAX_ITEM_INFO_RETRIES = 30
local MAX_MISSING_ITEM_DATA = 20



-- ============================================================================
-- Module Functions
-- ============================================================================

function QueryUtil.SetAuctionCounts(counts, updateTime)
	private.counts = counts
	private.countsUpdateTime = updateTime
end

function QueryUtil.GenerateThreaded(itemList, callback)
	return private.GenerateQueriesThread(itemList, callback)
end



-- ============================================================================
-- Main Generate Queries Thread
-- ============================================================================

function private.GenerateQueriesThread(itemList, callback)
	-- get all the item info into the game's cache
	for _ = 1, MAX_ITEM_INFO_RETRIES do
		local isMissingItemInfo = false
		for _, itemString in ipairs(itemList) do
			if not private.HasInfo(itemString) then
				isMissingItemInfo = true
			end
			Threading.Yield()
		end
		if not isMissingItemInfo then
			break
		end
		Threading.Sleep(0.1)
	end

	-- remove items we're missing info for
	for i = #itemList, 1, -1 do
		if not private.HasInfo(itemList[i]) then
			Log.Err("Missing item info for %s", itemList[i])
			tremove(itemList, i)
		end
		Threading.Yield()
	end

	if #itemList <= 1 then
		-- short-circuit for searching for a single or no items
		for _, itemString in ipairs(itemList) do
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		return
	end

	if not TSM.IsWowClassic() then
		private.PopulateDataThreaded()
		Threading.Yield()
		if not private.isComplete then
			Log.Err("Auction count database not complete")
		end
	end

	-- if the DB is not fully populated (or we're on classic), we don't have all the item info, just do individual scans
	if not private.isComplete then
		for _, itemString in ipairs(itemList) do
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		return
	end
	Threading.Yield()

	-- organize by class
	for _, tbl in pairs(private.itemListByClass) do
		wipe(tbl)
	end
	for _, itemString in ipairs(itemList) do
		local classId = ItemInfo.GetClassId(itemString)
		if classId and classId ~= LE_ITEM_CLASS_BATTLEPET then
			private.itemListByClass[classId] = private.itemListByClass[classId] or {}
			tinsert(private.itemListByClass[classId], itemString)
		else
			assert(private.HasInfo(itemString), "Invalid item info for "..tostring(itemString))
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		Threading.Yield()
	end
	for classId, items in pairs(private.itemListByClass) do
		if #items > 0 then
			local totalPagesRaw = 0
			local totalPagesClass = 0
			-- calculate the number of pages if we scan items individually
			for _, itemString in ipairs(items) do
				totalPagesRaw = totalPagesRaw + private.NumAuctionsToNumPages(private.GetItemNumAuctions(itemString))
				Threading.Yield()
			end
			local classMinQuality, classMinLevel, classMaxLevel = nil, nil, nil
			if totalPagesRaw > 0 then
				-- calulate the number of pages if we group by class
				classMinQuality, classMinLevel, classMaxLevel = private.GetCommonInfo(items)
				totalPagesClass = private.GetQueryNumPages(classId, classMinLevel, classMaxLevel, classMinQuality)
			end
			totalPagesRaw = totalPagesRaw > 0 and totalPagesRaw or math.huge
			totalPagesClass = totalPagesClass > 0 and totalPagesClass or math.huge

			Log.Info("Scanning %d items by class (%d) would be %d pages instead of %d", #items, classId, totalPagesClass, totalPagesRaw)
			if totalPagesClass < totalPagesRaw then
				Log.Info("Should group by class")
				-- attempt to find a common name to filter by
				local name = private.GetCommonName(items)
				if name then
					Log.Info("Should group by filter: %s", name)
				else
					name = ""
				end
				callback(items, name, classMinLevel, classMaxLevel, classMinQuality, classId, nil)
				Threading.Yield()
			else
				Log.Info("Shouldn't group by anything!")
				for _, itemString in ipairs(items) do
					callback(itemString, private.GetItemQueryInfo(itemString))
				end
			end
			Threading.Yield()
		end
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.PopulateDataThreaded()
	if private.isComplete then
		return true
	end
	if private.lastPopulateAttempt == time() then
		return
	end
	if private.countsUpdateTime < time() - MAX_SCAN_DATA_AGE then
		Log.Warn("Scan data too old to optimize searches")
		return
	end
	private.lastPopulateAttempt = time()
	private.isComplete = false
	wipe(private.itemStrings)
	local orderValueItem = Threading.AcquireSafeTempTable()
	local orderValueCount = Threading.AcquireSafeTempTable()
	local numMissing = 0
	for itemString in pairs(private.counts) do
		local quality = ItemInfo.GetQuality(itemString)
		local level = ItemInfo.GetMinLevel(itemString)
		local classId = ItemInfo.GetClassId(itemString)
		if quality and level and classId then
			assert(quality < 10 and level < 200)
			local orderValue = (classId * 10 + quality) * 200 + level
			orderValueCount[orderValue] = (orderValueCount[orderValue] or 0) + 1
			local count = orderValueCount[orderValue]
			assert(count < 10000)
			orderValue = orderValue * 10000 + count
			assert(not orderValueItem[orderValue])
			orderValueItem[orderValue] = itemString
		else
			numMissing = numMissing + 1
		end
		Threading.Yield()
	end
	if numMissing > 0 then
		Log.Err("Missing %d items worth of data!", numMissing)
	end
	-- allow for some items to be missing data
	private.isComplete = numMissing < MAX_MISSING_ITEM_DATA
	if private.isComplete then
		-- pretty roundabout way of sorting to avoid "script ran too long" errors from a long sort() call
		local orderValueList = Threading.AcquireSafeTempTable()
		wipe(orderValueList)
		for orderValue in pairs(orderValueItem) do
			tinsert(orderValueList, orderValue)
		end
		Threading.Yield(true)
		sort(orderValueList)
		Threading.Yield(true)
		assert(#private.itemStrings == 0)
		for _, orderValue in ipairs(orderValueList) do
			tinsert(private.itemStrings, orderValueItem[orderValue])
		end
		Threading.ReleaseSafeTempTable(orderValueList)
	end
	Threading.ReleaseSafeTempTable(orderValueItem)
	return private.isComplete
end

function private.CompareFunc(itemString, queryClass)
	local class = ItemInfo.GetClassId(itemString) or -1
	return class == queryClass and 0 or (class - queryClass)
end

function private.GetItemNumAuctions(itemString)
	itemString = ItemString.Filter(itemString)
	return private.counts[itemString] or 0
end

function private.GetQueryNumPages(queryClass, queryMinLevel, queryMaxLevel, queryQuality)
	assert(queryClass)
	queryMinLevel = max(queryMinLevel or 0, 0)
	queryMaxLevel = queryMaxLevel and queryMaxLevel >= 1 and queryMaxLevel or math.huge
	queryQuality = queryQuality or 0
	local count = 0
	local startIndex = 1

	-- binary search for starting index
	local low, high = 1, #private.itemStrings
	while low <= high do
		local mid = floor((low + high) / 2)
		local cmpValue = private.CompareFunc(private.itemStrings[mid], queryClass)
		if cmpValue == 0 then
			if mid == 1 or private.CompareFunc(private.itemStrings[mid-1], queryClass) ~= 0 then
				-- we've found the row we want
				startIndex = mid
				break
			else
				-- we're too high
				high = mid - 1
			end
		elseif cmpValue < 0 then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
	end

	for i = startIndex, #private.itemStrings do
		local itemString = private.itemStrings[i]
		local quality = ItemInfo.GetQuality(itemString)
		local class = ItemInfo.GetClassId(itemString)
		local level = ItemInfo.GetMinLevel(itemString)
		if private.CompareFunc(itemString, class) ~= 0 then
			break
		end
		if quality >= queryQuality and class == queryClass and level >= queryMinLevel and level <= queryMaxLevel then
			count = count + private.GetItemNumAuctions(itemString)
		end
	end
	return private.NumAuctionsToNumPages(count)
end

function private.GetItemQueryInfo(itemString)
	local name = ItemInfo.GetName(itemString)
	local level = ItemInfo.GetMinLevel(itemString) or 0
	local quality = ItemInfo.GetQuality(itemString)
	local classId = ItemInfo.GetClassId(itemString) or 0
	local subClassId = ItemInfo.GetSubClassId(itemString) or 0
	-- Ignoring level because level can now vary
	if itemString == ItemString.GetBase(itemString) and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR or (classId == LE_ITEM_CLASS_GEM and subClassId == LE_ITEM_GEM_ARTIFACTRELIC)) then
		level = 0
	end
	return name, level, level, quality, classId, subClassId
end

function private.NumAuctionsToNumPages(num)
	return max(ceil(num / NUM_AUCTION_ITEMS_PER_PAGE), 1)
end

function private.GetCommonInfo(items)
	local minQuality, minLevel, maxLevel = nil, nil, nil
	local filterLevel = true
	for _, itemString in ipairs(items) do
		local _, level, _, quality = private.GetItemQueryInfo(itemString)
		if level == 0 then
			filterLevel = false
		end
		minQuality = min(minQuality or quality, quality)
		minLevel = min(minLevel or level, level)
		maxLevel = max(maxLevel or level, level)
	end
	return minQuality or 0, filterLevel and minLevel or 0, filterLevel and maxLevel or 0
end

function private.GetCommonName(items)
	-- check if we can also group the query by name
	local nameTemp = TempTable.Acquire()
	for _, itemString in ipairs(items) do
		local name = ItemInfo.GetName(itemString)
		if not name then
			TempTable.Release(nameTemp)
			return
		end
		assert(type(name) == "string", "Unexpected item name: "..tostring(name))
		tinsert(nameTemp, name)
	end
	if #nameTemp ~= #items or #nameTemp < 2 then
		TempTable.Release(nameTemp)
		return
	end
	sort(nameTemp)

	-- find common substring with first and last name, and if it's
	-- at least one word long, try and apply it to the rest
	local str1 = nameTemp[1]
	local str2 = nameTemp[#nameTemp]
	local endIndex = 0
	local hasSpace = nil
	for i = 1, min(#str1, #str2) do
		local c = strsub(str1, i, i)
		if c ~= strsub(str2, i, i) then
			break
		elseif c == " " then
			hasSpace = true
		end
		endIndex = i
	end
	-- make sure the common substring has at least one space and is at least 3 characters log
	if not hasSpace or endIndex < 3 then
		TempTable.Release(nameTemp)
		return
	end

	local commonStr = strsub(str1, 1, endIndex)
	for _, name in ipairs(nameTemp) do
		if strsub(name, 1, endIndex) ~= commonStr then
			TempTable.Release(nameTemp)
			return
		end
	end
	TempTable.Release(nameTemp)
	return commonStr
end

function private.HasInfo(itemString)
	return ItemInfo.GetName(itemString) and ItemInfo.GetQuality(itemString)
end
