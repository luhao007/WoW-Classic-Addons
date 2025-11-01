-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local AuctionQuery = LibTSMService:DefineClassType("AuctionQuery")
local AuctionRow = LibTSMService:IncludeClassType("AuctionRow")
local Scanner = LibTSMService:Include("AuctionScan.Scanner")
local ItemInfo = LibTSMService:Include("Item.ItemInfo")
local AuctionHouse = LibTSMService:From("LibTSMWoW"):Include("API.AuctionHouse")
local AuctionHouseWrapper = LibTSMService:From("LibTSMWoW"):Include("API.AuctionHouseWrapper")
local ClientInfo = LibTSMService:From("LibTSMWoW"):Include("Util.ClientInfo")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local TempTable = LibTSMService:From("LibTSMUtil"):Include("BaseType.TempTable")
local String = LibTSMService:From("LibTSMUtil"):Include("Lua.String")
local ObjectPool = LibTSMService:From("LibTSMUtil"):IncludeClassType("ObjectPool")
local private = {
	objectPool = ObjectPool.New("AUCTION_SCAN_QUERY", AuctionQuery, 1),
}
local ITEM_SPECIFIC = newproxy()
local ITEM_BASE = newproxy()
local FILTER_NOT_SET = newproxy()



-- ============================================================================
-- Static Class Functions
-- ============================================================================

---Gets an auction query.
---@return AuctionQuery
function AuctionQuery.__static.Get()
	return private.objectPool:Get()
end



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AuctionQuery:__init()
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
	self._class = FILTER_NOT_SET
	self._subClass = FILTER_NOT_SET
	self._invType = FILTER_NOT_SET
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
	self._resolveSellers = false
	self._callback = nil
	self._browseResults = {} ---@type table<string,AuctionRow>
	self._page = 0
end

function AuctionQuery:_Release()
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
	self._class = FILTER_NOT_SET
	self._subClass = FILTER_NOT_SET
	self._invType = FILTER_NOT_SET
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
	self._resolveSellers = false
	self._callback = nil
	for _, row in pairs(self._browseResults) do
		row:Release()
	end
	wipe(self._browseResults)
	self._page = 0
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

---Release the query.
function AuctionQuery:Release()
	self:_Release()
	private.objectPool:Recycle(self)
end

---Sets the string to query on.
---@param str? string
---@param exact? boolean
---@return AuctionQuery
function AuctionQuery:SetStr(str, exact)
	self._str = str or ""
	self._strLower = strlower(self._str)
	self._strMatch = String.Escape(self._strLower)
	self._exact = exact or false
	return self
end

---Sets the item quality range.
---@param minQuality? number
---@param maxQuality? number
---@return AuctionQuery
function AuctionQuery:SetQualityRange(minQuality, maxQuality)
	self._minQuality = minQuality or -math.huge
	self._maxQuality = maxQuality or math.huge
	return self
end

---Sets the level range.
---@param minLevel? number
---@param maxLevel? number
---@return AuctionQuery
function AuctionQuery:SetLevelRange(minLevel, maxLevel)
	self._minLevel = minLevel or -math.huge
	self._maxLevel = maxLevel or math.huge
	return self
end

---Gets the item level range.
---@param minItemLevel number
---@param maxItemLevel number
---@return AuctionQuery
function AuctionQuery:SetItemLevelRange(minItemLevel, maxItemLevel)
	self._minItemLevel = minItemLevel or -math.huge
	self._maxItemLevel = maxItemLevel or math.huge
	return self
end

---Sets the class filter.
---@param class? number
---@param subClass? number
---@param invType? number
---@return AuctionQuery
function AuctionQuery:SetClass(class, subClass, invType)
	self._class = class or FILTER_NOT_SET
	self._subClass = subClass or FILTER_NOT_SET
	self._invType = invType or FILTER_NOT_SET
	return self
end

---Sets the usable filter.
---@param usable? boolean
---@return AuctionQuery
function AuctionQuery:SetUsable(usable)
	self._usable = usable or false
	return self
end

---Sets the uncollected filter.
---@param uncollected? boolean
---@return AuctionQuery
function AuctionQuery:SetUncollected(uncollected)
	self._uncollected = uncollected or false
	return self
end

---Sets the upgrades filter.
---@param upgrades? boolean
---@return AuctionQuery
function AuctionQuery:SetUpgrades(upgrades)
	self._upgrades = upgrades or false
	return self
end

---Sets the unlearned filter.
---@param unlearned? boolean
---@return AuctionQuery
function AuctionQuery:SetUnlearned(unlearned)
	self._unlearned = unlearned or false
	return self
end

---Sets the can learn filter.
---@param canLearn? boolean
---@return AuctionQuery
function AuctionQuery:SetCanLearn(canLearn)
	self._canLearn = canLearn or false
	return self
end

---Sets the price range.
---@param minPrice? number
---@param maxPrice? number
---@return AuctionQuery
function AuctionQuery:SetPriceRange(minPrice, maxPrice)
	self._minPrice = minPrice or 0
	self._maxPrice = maxPrice or math.huge
	return self
end

---Sets the list of items to query for.
---@param items string[]|string|nil A list of item strings, a single item string, or nil for no items
---@return AuctionQuery
function AuctionQuery:SetItems(items)
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

---Adds a custom filter function.
---@param func fun(query: AuctionQuery, row: AuctionRow|AuctionSubRow, isSubRow: boolean, itemKey: ItemKey): boolean
---@return AuctionQuery
function AuctionQuery:AddCustomFilter(func)
	self._customFilters[func] = true
	return self
end

---Sets a function to call for checking if we're done with a browse query.
---@param func fun(query: AuctionQuery): boolean
---@return AuctionQuery
function AuctionQuery:SetIsBrowseDoneFunction(func)
	self._isBrowseDoneFunc = func
	return self
end

---Sets the page to query for.
---@param page number|string|nil The specific page number or "FIRST"/"LAST" for relative pages
---@return AuctionQuery
function AuctionQuery:SetPage(page)
	if page == nil then
		self._specifiedPage = nil
	elseif type(page) == "number" or page == "FIRST" or page == "LAST" then
		assert(not ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE))
		self._specifiedPage = page
	else
		error("Invalid page: "..tostring(page))
	end
	return self
end

---Sets whether or not to resolve seller names.
---@param resolveSellers boolean
---@return AuctionQuery
function AuctionQuery:SetResolveSellers(resolveSellers)
	self._resolveSellers = resolveSellers
	return self
end

---Sets a callback for the results of the query changing.
---@param callback fun(query: AuctionQuery, row?: AuctionRow)
---@return AuctionQuery
function AuctionQuery:SetCallback(callback)
	self._callback = callback
	return self
end

---Starts the browse query.
---@return Future
function AuctionQuery:Browse()
	local noScan = false
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
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
		assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE))
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
				tinsert(itemKeys, AuctionHouse.MakeItemKey(itemId, battlePetSpeciesId))
			end
		end
		local future = Scanner.BrowseNoScan(self, itemKeys, self._callback)
		TempTable.Release(itemKeys)
		return future
	else
		self._page = 0
		return Scanner.Browse(self, self._resolveSellers, self._callback)
	end
end

---Gets the search progress.
---@return number
function AuctionQuery:GetSearchProgress()
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
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

---Iterates over the sub rows for an item.
---@param itemString string The item string
---@return fun(): number, AuctionSubRow @Iterator with fields: `index`, `subRow`
function AuctionQuery:ItemSubRowIterator(itemString)
	local result = TempTable.Acquire()
	local baseItemString = ItemString.GetBaseFast(itemString)
	local levelItemString = ItemString.ToLevel(itemString)
	local isBaseItemString = itemString == baseItemString
	local isLevelItemString = itemString == levelItemString and not isBaseItemString
	local row = self._browseResults[baseItemString]
	if row then
		for _, subRow in row:SubRowIterator() do
			local subRowBaseItemString = subRow:GetBaseItemString()
			local subRowItemString = subRow:GetItemString()
			if (isBaseItemString and subRowBaseItemString == itemString) or (isLevelItemString and ItemString.ToLevel(subRowItemString) == itemString) or (not isBaseItemString and not isLevelItemString and subRowItemString == itemString) then
				tinsert(result, subRow)
			end
		end
	end
	return TempTable.Iterator(result)
end

---Gets the cheapest sub row for an item.
---@param itemString string The item string
---@return AuctionSubRow?
function AuctionQuery:GetCheapestSubRow(itemString)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE))
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

---Iteratest over the browse results
---@return fun(): string, AuctionRow @Iterator with fields: `baseItemString`, `row`
function AuctionQuery:BrowseResultsIterator()
	return pairs(self._browseResults)
end

---Removes a row from the results.
---@param row AuctionRow The row to removve
function AuctionQuery:RemoveResultRow(row)
	local baseItemString = row:GetBaseItemString()
	assert(baseItemString and self._browseResults[baseItemString])
	self._browseResults[baseItemString] = nil
	row:Release()
	if self._callback then
		self:_callback()
	end
end

---Searches for an auction row.
---@param row AuctionRow The row to search for
---@param useCachedData boolean Use cached data for the search
---@return Future
function AuctionQuery:Search(row, useCachedData)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE))
	assert(self._browseResults)
	return Scanner.Search(self, self._resolveSellers, useCachedData, row, self._callback)
end

---Cancels the current browse or search.
function AuctionQuery:CancelBrowseOrSearch()
	Scanner.Cancel()
end

---Iterates over the items involved in the query.
---@return fun(): number, string @Iterator with fields: `index`, `itemString`
function AuctionQuery:ItemIterator()
	return private.ItemIteratorHelper, self._items, nil
end

---Wipes the browse results.
function AuctionQuery:WipeBrowseResults()
	for _, row in pairs(self._browseResults) do
		row:Release()
	end
	wipe(self._browseResults)
	if self._callback then
		self:_callback()
	end
end



-- ============================================================================
-- Private Class Methods (Called by the Scanner Code)
-- ============================================================================

function AuctionQuery:_SetSort()
	return AuctionHouseWrapper.SetSort(type(self._specifiedPage) == "string")
end

function AuctionQuery:_SendWowQuery()
	local minLevel = self._minLevel ~= -math.huge and self._minLevel or nil
	local maxLevel = self._maxLevel ~= math.huge and self._maxLevel or nil
	local minQuality = self._minQuality == -math.huge and 0 or self._minQuality
	if self._specifiedPage == "LAST" then
		self._page = max(AuctionHouse.GetNumPages() - 1, 0)
	elseif self._specifiedPage == "FIRST" then
		self._page = 0
	elseif self._specifiedPage then
		self._page = self._specifiedPage
	end
	local class = self._class ~= FILTER_NOT_SET and self._class or nil
	local subClass = self._subClass ~= FILTER_NOT_SET and self._subClass or nil
	local invType = self._invType ~= FILTER_NOT_SET and self._invType or nil
	return AuctionHouseWrapper.SendQuery(self._str, class, subClass, invType, minLevel, maxLevel, minQuality, self._maxQuality, self._uncollected, self._usable, self._upgrades, self._exact, self._page)
end

function AuctionQuery:_IsFiltered(row, isSubRow, itemKey)
	local baseItemString = row:GetBaseItemString()
	local itemString = row:GetItemString()
	assert(baseItemString)
	local name, quality, itemLevel = row:GetItemInfo(itemKey)
	local _, itemBuyout, minItemBuyout = row:GetBuyouts(itemKey)
	if row:IsSubRow() and itemBuyout == 0 then
		_, itemBuyout = row:GetBidInfo()
	end

	if next(self._items) then
		if not self._items[baseItemString] then
			return true
		end
		local levelItemString = itemString and ItemString.ToLevel(itemString)
		if isSubRow and itemString and self._items[itemString] ~= ITEM_SPECIFIC and self._items[levelItemString] ~= ITEM_SPECIFIC and self._items[baseItemString] ~= ITEM_SPECIFIC then
			-- this is a sub row and we're not looking for this item
			return true
		elseif not isSubRow and itemString and not self._items[itemString] then
			-- this is a base row but the base item doesn't match any item we're interested in
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
		local minLevel = ItemString.IsPet(baseItemString) and itemLevel or ItemInfo.GetMinLevel(baseItemString)
		if minLevel < self._minLevel or minLevel > self._maxLevel then
			return true
		end
	end
	if itemLevel and (itemLevel < self._minItemLevel or itemLevel > self._maxItemLevel) then
		return true
	end
	if quality and (quality < self._minQuality or quality > self._maxQuality) then
		return true
	end
	if self._class ~= FILTER_NOT_SET and ItemInfo.GetClassId(baseItemString) ~= self._class then
		return true
	end
	if self._subClass ~= FILTER_NOT_SET and ItemInfo.GetSubClassId(baseItemString) ~= self._subClass then
		return true
	end
	if self._invType ~= FILTER_NOT_SET and ItemInfo.GetInvSlotId(baseItemString) ~= self._invType then
		return true
	end
	-- luacheck: globals CanIMogIt
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

function AuctionQuery:_BrowseIsDone(isRetry)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		if self._isBrowseDoneFunc and self:_isBrowseDoneFunc() then
			return true
		end
		return AuctionHouse.HasFullBrowseResults()
	else
		local numPages = AuctionHouse.GetNumPages()
		if self._specifiedPage then
			if isRetry then
				return false
			end
			-- check if we're on the right page
			local specifiedPage = (self._specifiedPage == "FIRST" and 0) or (self._specifiedPage == "LAST" and numPages - 1) or self._specifiedPage
			return self._page == specifiedPage
		elseif self._isBrowseDoneFunc and self:_isBrowseDoneFunc() then
			return true
		else
			return self._page >= numPages
		end
	end
end

function AuctionQuery:_BrowseIsPageValid()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		return true
	end
	if self._specifiedPage then
		return self:_BrowseIsDone()
	else
		return true
	end
end

function AuctionQuery:_BrowseRequestMore(isRetry)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		return AuctionHouseWrapper.RequestMoreBrowseResults()
	else
		if self._specifiedPage then
			return self:_SendWowQuery()
		end
		if not isRetry then
			self._page = self._page + 1
		end
		return self:_SendWowQuery()
	end
end

function AuctionQuery:_OnSubRowRemoved(row)
	local baseItemString = row:GetBaseItemString()
	assert(row == self._browseResults[baseItemString])
	if row:GetNumSubRows() == 0 then
		self._browseResults[baseItemString] = nil
		row:Release()
		row = nil
	end
	if self._callback then
		self:_callback(row)
	end
end

---@private
---@return AuctionRow
function AuctionQuery:_GetBrowseResults(baseItemString)
	return self._browseResults[baseItemString]
end

---@private
function AuctionQuery:_ProcessBrowseResult(baseItemString, ...)
	if self._browseResults[baseItemString] then
		self._browseResults[baseItemString]:Merge(...)
	else
		self._browseResults[baseItemString] = AuctionRow.Get(self, ...)
	end
end

---@private
function AuctionQuery:_FilterBrowseResults()
	local numRemoved = 0
	for baseItemString, row in pairs(self._browseResults) do
		-- Filter the itemKeys we don't care about and rows which don't match the query
		if row:IsFiltered(self) or (not ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) and row:FilterSubRows(self)) then
			self._browseResults[baseItemString]:Release()
			self._browseResults[baseItemString] = nil
			numRemoved = numRemoved + 1
		end
	end
	return numRemoved
end

---@private
function AuctionQuery:_PopulateBrowseData(missingItemIds)
	local success = true
	local numRemoved = 0
	for baseItemString, row in pairs(self._browseResults) do
		local hasInfo, giveUp = row:PopulateBrowseData(missingItemIds)
		if not hasInfo and giveUp then
			-- Remove this row completely
			self._browseResults[baseItemString]:Release()
			self._browseResults[baseItemString] = nil
			numRemoved = numRemoved + 1
		elseif not hasInfo then
			success = false
			-- Keep going so we issue requests for all pending rows
		end
	end
	return success, numRemoved
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
