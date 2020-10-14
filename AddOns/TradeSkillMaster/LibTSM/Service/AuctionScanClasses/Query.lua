-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- AuctionQuery Class.
-- A class which is used to build a query to scan the auciton house.
-- @classmod AuctionQuery

local _, TSM = ...
local Query = TSM.Init("Service.AuctionScanClasses.Query")
local String = TSM.Include("Util.String")
local ObjectPool = TSM.Include("Util.ObjectPool")
local ItemString = TSM.Include("Util.ItemString")
local TempTable = TSM.Include("Util.TempTable")
local Table = TSM.Include("Util.Table")
local ItemInfo = TSM.Include("Service.ItemInfo")
local AuctionHouseWrapper = TSM.Include("Service.AuctionHouseWrapper")
local Scanner = TSM.Include("Service.AuctionScanClasses.Scanner")
local LibTSMClass = TSM.Include("LibTSMClass")
local AuctionQuery = LibTSMClass.DefineClass("AuctionQuery")
local private = {
	objectPool = ObjectPool.New("AUCTION_SCAN_QUERY", AuctionQuery),
}
local ITEM_SPECIFIC = newproxy()
local ITEM_BASE = newproxy()
local DEFAULT_SORTS = TSM.IsWowClassic() and
	{ -- classic
		"seller",
		"quantity",
		"unitprice",
	} or
	{ -- retail
		{ sortOrder = Enum.AuctionHouseSortOrder.Price, reverseSort = false },
		{ sortOrder = Enum.AuctionHouseSortOrder.Name, reverseSort = false },
	}
local EMPTY_SORTS = {}
local INV_TYPES = {
	CHEST = TSM.IsShadowlands() and Enum.InventoryType.IndexChestType or LE_INVENTORY_TYPE_CHEST_TYPE,
	ROBE = TSM.IsShadowlands() and Enum.InventoryType.IndexRobeType or LE_INVENTORY_TYPE_ROBE_TYPE,
	NECK = TSM.IsShadowlands() and Enum.InventoryType.IndexNeckType or LE_INVENTORY_TYPE_NECK_TYPE,
	FINGER = TSM.IsShadowlands() and Enum.InventoryType.IndexFingerType or LE_INVENTORY_TYPE_FINGER_TYPE,
	TRINKET = TSM.IsShadowlands() and Enum.InventoryType.IndexTrinketType or LE_INVENTORY_TYPE_TRINKET_TYPE,
	HOLDABLE = TSM.IsShadowlands() and Enum.InventoryType.IndexHoldableType or LE_INVENTORY_TYPE_HOLDABLE_TYPE,
	BODY = TSM.IsShadowlands() and Enum.InventoryType.IndexBodyType or LE_INVENTORY_TYPE_BODY_TYPE,
	CLOAK = TSM.IsShadowlands() and Enum.InventoryType.IndexCloakType or LE_INVENTORY_TYPE_CLOAK_TYPE,
}
assert(Table.Count(INV_TYPES) == 8)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Query.Get()
	return private.objectPool:Get()
end



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AuctionQuery.__init(self)
	self._str = ""
	self._strLower = ""
	self._strMatch = ""
	self._exact = false
	self._minQuality = -math.huge
	self._maxQuality = math.huge
	self._minLevel = -math.huge
	self._maxLevel = math.huge
	self._minItemLevel = -math.huge
	self._maxItemLevel = math.huge
	self._class = nil
	self._subClass = nil
	self._invType = nil
	self._classFilter1 = {}
	self._classFilter2 = {}
	self._usable = false
	self._uncollected = false
	self._upgrades = false
	self._unlearned = false
	self._canLearn = false
	self._minPrice = 0
	self._maxPrice = math.huge
	self._items = {}
	self._customFilters = {}
	self._isBrowseDoneFunc = nil
	self._specifiedPage = nil
	self._getAll = nil
	self._resolveSellers = false
	self._callback = nil
	self._queryTemp = {}
	self._filtersTemp = {}
	self._classFiltersTemp = {}
	self._browseResults = {}
	self._page = 0
end

function AuctionQuery.Release(self)
	self._str = ""
	self._strLower = ""
	self._strMatch = ""
	self._exact = false
	self._minQuality = -math.huge
	self._maxQuality = math.huge
	self._minLevel = -math.huge
	self._maxLevel = math.huge
	self._minItemLevel = -math.huge
	self._maxItemLevel = math.huge
	self._class = nil
	self._subClass = nil
	self._invType = nil
	wipe(self._classFilter1)
	wipe(self._classFilter2)
	self._usable = false
	self._uncollected = false
	self._upgrades = false
	self._unlearned = false
	self._canLearn = false
	self._minPrice = 0
	self._maxPrice = math.huge
	wipe(self._items)
	wipe(self._customFilters)
	self._isBrowseDoneFunc = nil
	self._specifiedPage = nil
	self._getAll = nil
	self._resolveSellers = false
	self._callback = nil
	wipe(self._queryTemp)
	wipe(self._filtersTemp)
	wipe(self._classFiltersTemp)
	for _, row in pairs(self._browseResults) do
		row:Release()
	end
	wipe(self._browseResults)
	self._page = 0
	private.objectPool:Recycle(self)
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AuctionQuery.SetStr(self, str, exact)
	self._str = str or ""
	self._strLower = strlower(self._str)
	self._strMatch = String.Escape(self._strLower)
	self._exact = exact or false
	return self
end

function AuctionQuery.SetQualityRange(self, minQuality, maxQuality)
	self._minQuality = minQuality or -math.huge
	self._maxQuality = maxQuality or math.huge
	return self
end

function AuctionQuery.SetLevelRange(self, minLevel, maxLevel)
	self._minLevel = minLevel or -math.huge
	self._maxLevel = maxLevel or math.huge
	return self
end

function AuctionQuery.SetItemLevelRange(self, minItemLevel, maxItemLevel)
	self._minItemLevel = minItemLevel or -math.huge
	self._maxItemLevel = maxItemLevel or math.huge
	return self
end

function AuctionQuery.SetClass(self, class, subClass, invType)
	self._class = class or nil
	self._subClass = subClass or nil
	self._invType = invType or nil
	return self
end

function AuctionQuery.SetUsable(self, usable)
	self._usable = usable or false
	return self
end

function AuctionQuery.SetUncollected(self, uncollected)
	self._uncollected = uncollected or false
	return self
end

function AuctionQuery.SetUpgrades(self, upgrades)
	self._upgrades = upgrades or false
	return self
end

function AuctionQuery.SetUnlearned(self, unlearned)
	self._unlearned = unlearned or false
	return self
end

function AuctionQuery.SetCanLearn(self, canLearn)
	self._canLearn = canLearn or false
	return self
end

function AuctionQuery.SetPriceRange(self, minPrice, maxPrice)
	self._minPrice = minPrice or 0
	self._maxPrice = maxPrice or math.huge
	return self
end

function AuctionQuery.SetItems(self, items)
	wipe(self._items)
	if type(items) == "table" then
		for _, itemString in ipairs(items) do
			local baseItemString = ItemString.GetBaseFast(itemString)
			self._items[itemString] = ITEM_SPECIFIC
			if baseItemString ~= itemString then
				self._items[baseItemString] = self._items[baseItemString] or ITEM_BASE
			end
		end
	elseif type(items) == "string" then
		local itemString = items
		local baseItemString = ItemString.GetBaseFast(itemString)
		self._items[itemString] = ITEM_SPECIFIC
		if baseItemString ~= itemString then
			self._items[baseItemString] = self._items[baseItemString] or ITEM_BASE
		end
	elseif items ~= nil then
		error("Invalid items type: "..tostring(items))
	end
	return self
end

function AuctionQuery.AddCustomFilter(self, func)
	self._customFilters[func] = true
	return self
end

function AuctionQuery.SetIsBrowseDoneFunction(self, func)
	self._isBrowseDoneFunc = func
	return self
end

function AuctionQuery.SetPage(self, page)
	if page == nil then
		self._specifiedPage = nil
	elseif type(page) == "number" or page == "FIRST" or page == "LAST" then
		assert(TSM.IsWowClassic())
		self._specifiedPage = page
	else
		error("Invalid page: "..tostring(page))
	end
	return self
end

function AuctionQuery.SetGetAll(self, getAll)
	-- only currently support GetAll on classic
	assert(not getAll or TSM.IsWowClassic())
	self._getAll = getAll
	return self
end

function AuctionQuery.SetResolveSellers(self, resolveSellers)
	self._resolveSellers = resolveSellers
	return self
end

function AuctionQuery.SetCallback(self, callback)
	self._callback = callback
	return self
end

function AuctionQuery.Browse(self, forceNoScan)
	assert(not TSM.IsWowClassic() or not forceNoScan)

	local noScan = forceNoScan or false
	if not TSM.IsWowClassic() then
		local numItems = 0
		for _, itemType in pairs(self._items) do
			if itemType == ITEM_SPECIFIC then
				numItems = numItems + 1
			end
		end
		if numItems > 0 and numItems < 500 then
			-- it's faster to just issue individual item searches instead of a browse query
			noScan = true
		end
	end

	if noScan then
		assert(not TSM.IsWowClassic())
		local itemKeys = TempTable.Acquire()
		for itemString in pairs(self._items) do
			if itemString == ItemString.GetBaseFast(itemString) then
				local itemId, battlePetSpeciesId = nil, nil
				if ItemString.IsPet(itemString) then
					itemId = ItemString.ToId(ItemString.GetPetCage())
					battlePetSpeciesId = ItemString.ToId(itemString)
				else
					itemId = ItemString.ToId(itemString)
					battlePetSpeciesId = 0
				end
				local itemKey = C_AuctionHouse.MakeItemKey(itemId, 0, 0, battlePetSpeciesId)
				-- FIX for 9.0.1 bug where MakeItemKey randomly adds an itemLevel which breaks scanning
				itemKey.itemLevel = 0
				tinsert(itemKeys, itemKey)
			end
		end
		local future = Scanner.BrowseNoScan(self, itemKeys, self._browseResults, self._callback)
		TempTable.Release(itemKeys)
		return future
	else
		self._page = 0
		return Scanner.Browse(self, self._resolveSellers, self._browseResults, self._callback)
	end
end

function AuctionQuery.GetSearchProgress(self)
	if TSM.IsWowClassic() then
		return 1
	end
	local progress, totalNum = 0, 0
	for _, row in pairs(self._browseResults) do
		progress = progress + row:_GetSearchProgress()
		totalNum = totalNum + 1
	end
	if totalNum == 0 then
		return 0
	end
	return progress / totalNum
end

function AuctionQuery.GetBrowseResults(self, baseItemString)
	return self._browseResults[baseItemString]
end

function AuctionQuery.ItemSubRowIterator(self, itemString)
	local result = TempTable.Acquire()
	local baseItemString = ItemString.GetBaseFast(itemString)
	local isBaseItemString = itemString == baseItemString
	local row = self._browseResults[baseItemString]
	if row then
		for _, subRow in row:SubRowIterator() do
			local subRowBaseItemString = subRow:GetBaseItemString()
			local subRowItemString = subRow:GetItemString()
			if (isBaseItemString and subRowBaseItemString == itemString) or (not isBaseItemString and subRowItemString == itemString) then
				tinsert(result, subRow)
			end
		end
	end
	return TempTable.Iterator(result)
end

function AuctionQuery.GetCheapestSubRow(self, itemString)
	assert(not TSM.IsWowClassic())
	local cheapest, cheapestItemBuyout = nil, nil
	for _, subRow in self:ItemSubRowIterator(itemString) do
		local quantity = subRow:GetQuantities()
		local _, numOwnerItems = subRow:GetOwnerInfo()
		local _, itemBuyout = subRow:GetBuyouts()
		if numOwnerItems ~= quantity and itemBuyout < (cheapestItemBuyout or math.huge) then
			cheapest = subRow
			cheapestItemBuyout = itemBuyout
		end
	end
	return cheapest
end

function AuctionQuery.BrowseResultsIterator(self)
	return pairs(self._browseResults)
end

function AuctionQuery.RemoveResultRow(self, row)
	local baseItemString = row:GetBaseItemString()
	assert(baseItemString and self._browseResults[baseItemString])
	self._browseResults[baseItemString] = nil
	row:Release()
	if self._callback then
		self._callback(self)
	end
end

function AuctionQuery.Search(self, row, useCachedData)
	assert(not TSM.IsWowClassic())
	assert(self._browseResults)
	return Scanner.Search(self, self._resolveSellers, useCachedData, row, self._callback)
end

function AuctionQuery.CancelBrowseOrSearch(self)
	Scanner.Cancel()
end

function AuctionQuery.ItemIterator(self)
	return private.ItemIteratorHelper, self._items, nil
end

function AuctionQuery.WipeBrowseResults(self)
	for _, row in pairs(self._browseResults) do
		row:Release()
	end
	wipe(self._browseResults)
	if self._callback then
		self._callback(self)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function AuctionQuery._SetSort(self)
	if not TSM.IsWowClassic() then
		return true
	end

	local sorts = (type(self._specifiedPage) == "string" or self._getAll) and EMPTY_SORTS or DEFAULT_SORTS

	if GetAuctionSort("list", #sorts + 1) == nil then
		local properlySorted = true
		for i, col in ipairs(sorts) do
			local sortCol, sortReversed = GetAuctionSort("list", #sorts - i + 1)
			-- we never care to reverse a sort so if it's reversed then it's not properly sorted
			if sortCol ~= col or sortReversed then
				properlySorted = false
				break
			end
		end
		if properlySorted then
			return true
		end
	end

	SortAuctionClearSort("list")
	for _, col in ipairs(sorts) do
		SortAuctionSetSort("list", col, false)
	end
	SortAuctionApplySort("list")

	return false
end

function AuctionQuery._SendWowQuery(self)
	-- build the class filters
	wipe(self._classFiltersTemp)
	wipe(self._classFilter1)
	wipe(self._classFilter2)
	if self._invType == INV_TYPES.CHEST or self._invType == INV_TYPES.ROBE then
		-- default AH only sends in queries for robe chest type, we need to mimic this when using a chest filter
		self._classFilter1.classID = LE_ITEM_CLASS_ARMOR
		self._classFilter1.subClassID = self._subClass
		self._classFilter1.inventoryType = INV_TYPES.CHEST
		tinsert(self._classFiltersTemp, self._classFilter1)
		self._classFilter2.classID = LE_ITEM_CLASS_ARMOR
		self._classFilter2.subClassID = self._subClass
		self._classFilter2.inventoryType = INV_TYPES.ROBE
		tinsert(self._classFiltersTemp, self._classFilter2)
	elseif self._invType == INV_TYPES.NECK or self._invType == INV_TYPES.FINGER or self._invType == INV_TYPES.TRINKET or self._invType == INV_TYPES.HOLDABLE or self._invType == INV_TYPES.BODY then
		self._classFilter1.classID = LE_ITEM_CLASS_ARMOR
		self._classFilter1.subClassID = LE_ITEM_ARMOR_GENERIC
		self._classFilter1.inventoryType = self._invType
		tinsert(self._classFiltersTemp, self._classFilter1)
	elseif self._invType == INV_TYPES.CLOAK then
		self._classFilter1.classID = LE_ITEM_CLASS_ARMOR
		self._classFilter1.subClassID = LE_ITEM_ARMOR_CLOTH
		self._classFilter1.inventoryType = self._invType
		tinsert(self._classFiltersTemp, self._classFilter1)
	elseif self._class then
		self._classFilter1.classID = self._class
		self._classFilter1.subClassID = self._subClass
		self._classFilter1.inventoryType = self._invType
		tinsert(self._classFiltersTemp, self._classFilter1)
	end

	-- build the query
	local minLevel = self._minLevel ~= -math.huge and self._minLevel or nil
	local maxLevel = self._maxLevel ~= math.huge and self._maxLevel or nil
	if TSM.IsWowClassic() then
		if self._specifiedPage == "LAST" then
			self._page = max(ceil(select(2, GetNumAuctionItems("list")) / NUM_AUCTION_ITEMS_PER_PAGE) - 1, 0)
		elseif self._specifiedPage == "FIRST" then
			self._page = 0
		elseif self._specifiedPage then
			self._page = self._specifiedPage
		end
		local minQuality = self._minQuality == -math.huge and 0 or self._minQuality
		return AuctionHouseWrapper.QueryAuctionItems(self._str, minLevel, maxLevel, self._page, self._usable, minQuality, self._getAll, self._exact, self._classFiltersTemp)
	else
		wipe(self._filtersTemp)
		if self._uncollected then
			tinsert(self._filtersTemp, Enum.AuctionHouseFilter.UncollectedOnly)
		end
		if self._usable then
			tinsert(self._filtersTemp, Enum.AuctionHouseFilter.UsableOnly)
		end
		if self._upgrades then
			tinsert(self._filtersTemp, Enum.AuctionHouseFilter.UpgradesOnly)
		end
		if self._exact then
			tinsert(self._filtersTemp, Enum.AuctionHouseFilter.ExactMatch)
		end
		local minQuality = self._minQuality == -math.huge and 0 or self._minQuality
		for i = minQuality + Enum.AuctionHouseFilter.PoorQuality, min(self._maxQuality + Enum.AuctionHouseFilter.PoorQuality, Enum.AuctionHouseFilter.ArtifactQuality) do
			tinsert(self._filtersTemp, i)
		end
		wipe(self._queryTemp)
		self._queryTemp.searchString = self._str
		self._queryTemp.minLevel = minLevel
		self._queryTemp.maxLevel = maxLevel
		self._queryTemp.sorts = DEFAULT_SORTS
		self._queryTemp.filters = self._filtersTemp
		self._queryTemp.itemClassFilters = self._classFiltersTemp
		return AuctionHouseWrapper.SendBrowseQuery(self._queryTemp)
	end
end

function AuctionQuery._IsFiltered(self, row, isSubRow, itemKey)
	local baseItemString = row:GetBaseItemString()
	local itemString = row:GetItemString()
	assert(baseItemString)
	local name, quality, itemLevel, maxItemLevel = row:GetItemInfo(itemKey)
	local _, itemBuyout, minItemBuyout = row:GetBuyouts(itemKey)
	if row:IsSubRow() and itemBuyout == 0 then
		_, itemBuyout = row:GetBidInfo()
	end

	if next(self._items) then
		if not self._items[baseItemString] then
			return true
		end
		if isSubRow and itemString and self._items[itemString] ~= ITEM_SPECIFIC and self._items[baseItemString] ~= ITEM_SPECIFIC then
			return true
		elseif not isSubRow and itemString and not self._items[itemString] then
			return true
		end
	end
	if self._str ~= "" and name then
		name = strlower(name)
		if not strmatch(name, self._strMatch) or (self._exact and name ~= self._strLower) then
			return true
		end
	end
	if self._minLevel ~= -math.huge or self._maxLevel ~= math.huge then
		local minLevel = TSM.IsShadowlands() and ItemString.IsPet(baseItemString) and (itemLevel or maxItemLevel) or ItemInfo.GetMinLevel(baseItemString)
		if minLevel < self._minLevel or minLevel > self._maxLevel then
			return true
		end
	end
	if itemLevel and (itemLevel < self._minItemLevel or itemLevel > self._maxItemLevel) then
		return true
	end
	if maxItemLevel and maxItemLevel < self._minItemLevel then
		return true
	end
	if quality and (quality < self._minQuality or quality > self._maxQuality) then
		return true
	end
	if self._class and ItemInfo.GetClassId(baseItemString) ~= self._class then
		return true
	end
	if self._subClass and ItemInfo.GetSubClassId(baseItemString) ~= self._subClass then
		return true
	end
	if self._invType and ItemInfo.GetInvSlotId(baseItemString) ~= self._invType then
		return true
	end
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(ItemInfo.GetLink(baseItemString)) then
		return true
	end
	if self._canLearn and not CanIMogIt:CharacterCanLearnTransmog(ItemInfo.GetLink(baseItemString)) then
		return true
	end
	if itemBuyout and (itemBuyout < self._minPrice or itemBuyout > self._maxPrice) then
		return true
	end
	if minItemBuyout and minItemBuyout > self._maxPrice then
		return true
	end
	for func in pairs(self._customFilters) do
		if func(self, row, isSubRow, itemKey) then
			return true
		end
	end
	return false
end

function AuctionQuery._BrowseIsDone(self, isRetry)
	if TSM.IsWowClassic() then
		local numAuctions, totalAuctions = GetNumAuctionItems("list")
		if totalAuctions <= NUM_AUCTION_ITEMS_PER_PAGE and numAuctions ~= totalAuctions then
			-- there are cases where we get (0, 1) from the API - no idea why so just assume we're not done
			return false
		end
		local numPages = ceil(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE)
		if self._getAll then
			return true
		end
		if self._specifiedPage then
			if isRetry then
				return false
			end
			-- check if we're on the right page
			local specifiedPage = (self._specifiedPage == "FIRST" and 0) or (self._specifiedPage == "LAST" and numPages - 1) or self._specifiedPage
			return self._page == specifiedPage
		elseif self._isBrowseDoneFunc and self._isBrowseDoneFunc(self) then
			return true
		else
			return self._page >= numPages
		end
	else
		if self._isBrowseDoneFunc and self._isBrowseDoneFunc(self) then
			return true
		end
		return C_AuctionHouse.HasFullBrowseResults()
	end
end

function AuctionQuery._BrowseIsPageValid(self)
	if TSM.IsWowClassic() then
		if self._specifiedPage then
			return self:_BrowseIsDone()
		else
			return true
		end
	else
		return true
	end
end

function AuctionQuery._BrowseRequestMore(self, isRetry)
	if TSM.IsWowClassic() then
		assert(not self._getAll)
		if self._specifiedPage then
			return self:_SendWowQuery()
		end
		if not isRetry then
			self._page = self._page + 1
		end
		return self:_SendWowQuery()
	else
		return AuctionHouseWrapper.RequestMoreBrowseResults()
	end
end

function AuctionQuery._OnSubRowRemoved(self, row)
	local baseItemString = row:GetBaseItemString()
	assert(row == self._browseResults[baseItemString])
	if row:GetNumSubRows() == 0 then
		self._browseResults[baseItemString] = nil
		row:Release()
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ItemIteratorHelper(items, index)
	while true do
		local itemString, itemType = next(items, index)
		if not itemString then
			return
		elseif itemType == ITEM_SPECIFIC then
			return itemString
		end
		index = itemString
	end
end
