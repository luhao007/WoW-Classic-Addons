-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Auction Filter Class.
-- This class represents an auction filter with regards to a scan of the auction house.
-- @classmod AuctionFilter

local _, TSM = ...
local AuctionFilter = TSM.Include("LibTSMClass").DefineClass("AuctionFilter")
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local TempTable = TSM.Include("Util.TempTable")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Event = TSM.Include("Util.Event")
local ItemString = TSM.Include("Util.ItemString")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Conversions = TSM.Include("Service.Conversions")
TSM.Auction.classes.AuctionFilter = AuctionFilter
local private = {
	gotBrowseResultsUpdate = false,
	gotBrowseResultsAdded = false,
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AuctionFilter.__init(self)
	self._scan = nil
	self._name = nil
	self._nameMatch = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._quality = nil
	self._class = nil
	self._subClass = nil
	self._invType = nil
	self._uncollected = nil
	self._usable = nil
	self._upgrades = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exact = nil
	self._sniperLastPage = nil
	self._page = 0
	self._numPages = 0
	-- custom filters applies after the scan
	self._evenOnly = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._generalMaxQuantity = nil
	self._targetItem = nil
	self._getAll = nil
	self._items = {}
	self._itemMaxQuantities = {}
	self._resultIncludesRow = {}
	self._isDoneFunction = nil
	self._shouldScanItemFunction = nil
end

function AuctionFilter._Acquire(self, scan)
	self._scan = scan
	self._page = 0
	self._numPages = 0
end

function AuctionFilter._Release(self)
	self._scan = nil
	self._name = nil
	self._nameMatch = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._quality = nil
	self._class = nil
	self._subClass = nil
	self._invType = nil
	self._uncollected = nil
	self._usable = nil
	self._upgrades = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exact = nil
	self._sniperLastPage = nil
	self._evenOnly = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._generalMaxQuantity = nil
	self._targetItem = nil
	self._getAll = nil
	wipe(self._items)
	wipe(self._itemMaxQuantities)
	wipe(self._resultIncludesRow)
	self._isDoneFunction = nil
	self._shouldScanItemFunction = nil
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AuctionFilter.SetName(self, name)
	self._name = name
	self._nameMatch = name and String.Escape(strlower(name)) or nil
	return self
end

function AuctionFilter.SetMinLevel(self, minLevel)
	self._minLevel = minLevel ~= 0 and minLevel or nil
	return self
end

function AuctionFilter.SetMaxLevel(self, maxLevel)
	self._maxLevel = maxLevel ~= 0 and maxLevel or nil
	return self
end

function AuctionFilter.SetQuality(self, quality)
	self._quality = quality ~= 0 and quality or nil
	return self
end

function AuctionFilter.SetClass(self, class)
	self._class = class
	return self
end

function AuctionFilter.SetSubClass(self, subClass)
	self._subClass = subClass
	return self
end

function AuctionFilter.SetInvType(self, invType)
	self._invType = invType
	return self
end

function AuctionFilter.SetUncollected(self, uncollected)
	self._uncollected = uncollected
	return self
end

function AuctionFilter.SetUsable(self, usable)
	self._usable = usable
	return self
end

function AuctionFilter.SetUpgrades(self, upgrades)
	self._upgrades = upgrades
	return self
end

function AuctionFilter.SetUnlearned(self, unlearned)
	self._unlearned = unlearned
	return self
end

function AuctionFilter.SetCanLearn(self, canlearn)
	self._canlearn = canlearn
	return self
end

function AuctionFilter.SetExact(self, exact)
	self._exact = exact
	return self
end

function AuctionFilter.SetItems(self, items)
	assert(#self._items == 0)
	if type(items) == "table" then
		assert(#items > 0)
		for _, itemString in ipairs(items) do
			tinsert(self._items, itemString)
		end
	else
		tinsert(self._items, items)
	end
	return self
end

function AuctionFilter.SetEvenOnly(self, evenOnly)
	self._evenOnly = evenOnly
	return self
end

function AuctionFilter.SetMinItemLevel(self, minItemLevel)
	self._minItemLevel = minItemLevel
	return self
end

function AuctionFilter.SetMaxItemLevel(self, maxItemLevel)
	self._maxItemLevel = maxItemLevel
	return self
end

function AuctionFilter.SetMinPrice(self, minPrice)
	self._minPrice = minPrice
	return self
end

function AuctionFilter.SetMaxPrice(self, maxPrice)
	self._maxPrice = maxPrice
	return self
end

function AuctionFilter.SetGeneralMaxQuantity(self, maxQuantity)
	self._generalMaxQuantity = maxQuantity
	return self
end

function AuctionFilter.SetItemMaxQuantity(self, itemString, maxQuantity)
	self._itemMaxQuantities[itemString] = maxQuantity
	return self
end

function AuctionFilter.SetSniper(self, isLastPage)
	assert(not self._getAll)
	assert(type(isLastPage) == "boolean")
	self._sniperLastPage = isLastPage
	return self
end

function AuctionFilter.SetTargetItem(self, itemString)
	assert(not self._getAll)
	self._targetItem = itemString
	return self
end

function AuctionFilter.SetGetAll(self)
	assert(self._name == nil)
	assert(self._minLevel == nil)
	assert(self._maxLevel == nil)
	assert(self._quality == nil)
	assert(self._class == nil)
	assert(self._subClass == nil)
	assert(self._invType == nil)
	assert(self._uncollected == nil)
	assert(self._usable == nil)
	assert(self._upgrades == nil)
	assert(self._unlearned == nil)
	assert(self._canlearn == nil)
	assert(self._exact == nil)
	assert(self._sniperLastPage == nil)
	assert(self._evenOnly == nil)
	assert(self._minItemLevel == nil)
	assert(self._maxItemLevel == nil)
	assert(self._minPrice == nil)
	assert(self._maxPrice == nil)
	assert(self._generalMaxQuantity == nil)
	assert(self._targetItem == nil)
	assert(#self._items == 0)
	assert(next(self._itemMaxQuantities) == nil)
	self._getAll = true
	return self
end

function AuctionFilter.SetIsDoneFunction(self, func)
	self._isDoneFunction = func
	return self
end

function AuctionFilter.SetShouldScanItemFunction(self, func)
	self._shouldScanItemFunction = func
	return self
end

function AuctionFilter.GetItems(self)
	return self._items
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function AuctionFilter._IsSniper(self)
	return self._sniperLastPage ~= nil
end

function AuctionFilter._IsGetAll(self)
	return self._getAll ~= nil
end

function AuctionFilter._GetTargetItem(self)
	return self._targetItem
end

function AuctionFilter._GetPage(self)
	return self._page
end

function AuctionFilter._SetPage(self, page)
	self._page = page
end

function AuctionFilter._SetNumPages(self, numPages)
	self._numPages = numPages
end

function AuctionFilter._ResetPage(self)
	self._page = 0
end

function AuctionFilter._NextPage(self)
	if self:_IsSniper() or self:_IsGetAll() then
		return false
	elseif self._isDoneFunction and self._isDoneFunction(self, self._scan) then
		return false
	end
	self._page = self._page + 1
	return self._page < self._numPages
end

function AuctionFilter._GetPageProgress(self)
	return self._page, self._numPages
end

function AuctionFilter._IsItemFiltered(self, baseItemString, itemString, itemLevel, quality, itemName, totalQuantity, minPrice)
	if #self._items > 0 then
		local found = false
		for _, filterItemString in ipairs(self:GetItems()) do
			if filterItemString == itemString or ItemString.GetBaseFast(filterItemString) == baseItemString then
				found = true
				break
			end
		end
		if not found then
			return true
		end
	end
	if self._nameMatch and itemName then
		local name = strlower(itemName)
		if not strmatch(name, self._nameMatch) or (self._exact and name ~= strlower(self._name)) then
			return true
		end
	end
	if self._minLevel or self._maxLevel then
		local minLevel = ItemInfo.GetMinLevel(baseItemString)
		if minLevel < (self._minLevel or -math.huge) or minLevel > (self._maxLevel or math.huge) then
			return true
		end
	end
	if self._quality and quality and quality < self._quality then
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
	if self._evenOnly and totalQuantity < 5 then
		return true
	end
	if itemLevel and (itemLevel < (self._minItemLevel or 0) or itemLevel > (self._maxItemLevel or math.huge)) then
		return true
	end
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(ItemInfo.GetLink(baseItemString)) then
		return true
	end
	if self._canlearn and not CanIMogIt:CharacterCanLearnTransmog(ItemInfo.GetLink(baseItemString)) then
		return true
	end
	if minPrice > (self._minPrice or math.huge) then
		return true
	end
	return false
end

function AuctionFilter._IsFiltered(self, ignoreItemLevel, rowItemString, rowBuyout, stackSize, targetItemRate)
	if #self._items > 0 then
		local found = false
		local rowBaseItemString = ItemString.GetBaseFast(rowItemString)
		for _, itemString in ipairs(self:GetItems()) do
			if itemString == rowItemString or itemString == rowBaseItemString then
				found = true
			end
		end
		if not found then
			return true
		end
	end
	if self._nameMatch then
		local name = strlower(ItemInfo.GetName(rowItemString))
		if not strmatch(name, self._nameMatch) or (self._exact and name ~= strlower(self._name)) then
			return true
		end
	end
	if self._minLevel or self._maxLevel then
		local minLevel = ItemInfo.GetMinLevel(rowItemString)
		if minLevel < (self._minLevel or -math.huge) or minLevel > (self._maxLevel or math.huge) then
			return true
		end
	end
	if self._quality and ItemInfo.GetQuality(rowItemString) < self._quality then
		return true
	end
	if self._class and ItemInfo.GetClassId(rowItemString) ~= self._class then
		return true
	end
	if self._subClass and ItemInfo.GetSubClassId(rowItemString) ~= self._subClass then
		return true
	end
	if self._invType and ItemInfo.GetInvSlotId(rowItemString) ~= self._invType then
		return true
	end
	if not TSM.IsWowClassic() then
		if self._evenOnly and stackSize < 5 then
			return true
		end
	else
		if self._evenOnly and stackSize % 5 ~= 0 then
			return true
		end
	end
	local itemLevel = ItemInfo.GetItemLevel(rowItemString)
	if not ignoreItemLevel and (itemLevel < (self._minItemLevel or 0) or itemLevel > (self._maxItemLevel or math.huge)) then
		return true
	end
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(ItemInfo.GetLink(rowItemString)) then
		return true
	end
	if self._canlearn and not CanIMogIt:CharacterCanLearnTransmog(ItemInfo.GetLink(rowItemString)) then
		return true
	end
	if self._minPrice or self._maxPrice then
		if not rowBuyout or rowBuyout < (self._minPrice or 0) or rowBuyout > (self._maxPrice or math.huge) then
			return true
		end
	end
	if self._targetItem and targetItemRate == 0 then
		return true
	end
	return false
end

function AuctionFilter._GetTargetItemRate(self, itemString)
	if not self._targetItem then
		return 1
	end
	if itemString == self._targetItem then
		return 1
	end
	if DisenchantInfo.IsTargetItem(self._targetItem) then
		local classId = ItemInfo.GetClassId(itemString)
		local ilvl = ItemInfo.GetItemLevel(itemString)
		local quality = ItemInfo.GetQuality(itemString)
		local amountOfMats = DisenchantInfo.GetTargetItemSourceInfo(self._targetItem, classId, quality, ilvl)
		if amountOfMats then
			return amountOfMats
		end
	end
	local conversionInfo = Conversions.GetSourceItems(self._targetItem)
	return conversionInfo and conversionInfo[itemString] or 0
end

function AuctionFilter._ShouldScanItem(self, baseItemString, itemString, minPrice)
	return not self._shouldScanItemFunction or self._shouldScanItemFunction(self, baseItemString, itemString, minPrice)
end

function AuctionFilter._DoAuctionQueryThreaded(self)
	if not TSM.IsWowClassic() then
		assert(not self:_IsGetAll()) -- GetAll is not supported on >= 8.3

		local query = Threading.AcquireSafeTempTable()
		local sorts = Threading.AcquireSafeTempTable()
		local filters = Threading.AcquireSafeTempTable()
		if self._uncollected then
			tinsert(filters, Enum.AuctionHouseFilter.UncollectedOnly)
		end
		if self._usable then
			tinsert(filters, Enum.AuctionHouseFilter.UsableOnly)
		end
		if self._upgrades then
			tinsert(filters, Enum.AuctionHouseFilter.UpgradesOnly)
		end
		if self._exact then
			tinsert(filters, Enum.AuctionHouseFilter.ExactMatch)
		end
		for i = (self._quality or 0) + Enum.AuctionHouseFilter.PoorQuality, Enum.AuctionHouseFilter.ArtifactQuality do
			tinsert(filters, i)
		end
		local itemClassFilters = Threading.AcquireSafeTempTable()
		if self._class or self._subClass or self._invType then
			local info = Threading.AcquireSafeTempTable()
			info.classID = self._class
			info.subClassID = self._subClass
			info.inventoryType = self._invType
			tinsert(itemClassFilters, info)
		end

		query.searchString = self._name or ""
		query.sorts = sorts
		query.minLevel = self._minLevel or 0
		query.maxLevel = self._maxLevel or 0
		query.filters = filters
		query.itemClassFilters = itemClassFilters
		while true do
			private.gotBrowseResultsUpdate = false
			local result = self._scan:_SendBrowseQuery83(query)
			if result then
				for _ = 1, 50 do
					if private.gotBrowseResultsUpdate then
						break
					end
					Threading.Sleep(0.1)
				end
				if private.gotBrowseResultsUpdate then
					break
				end
				Log.Warn("Retrying browse query which didn't result in an update event")
			else
				Threading.Sleep(0.5)
				Log.Warn("Retrying throttled browse query")
			end
		end
		Threading.ReleaseSafeTempTable(sorts)
		Threading.ReleaseSafeTempTable(filters)
		for i = #itemClassFilters, 1, -1 do
			Threading.ReleaseSafeTempTable(itemClassFilters[i])
			itemClassFilters[i] = nil
		end
		Threading.ReleaseSafeTempTable(itemClassFilters)
		Threading.ReleaseSafeTempTable(query)

		-- wait for the browse results to fully load
		while not C_AuctionHouse.HasFullBrowseResults() do
			if self._scan:_IsCancelled() then
				Log.Info("Stopping cancelled scan")
				return false
			end
			Log.Info("Requesting more...")
			private.gotBrowseResultsAdded = false
			C_AuctionHouse.RequestMoreBrowseResults()
			for _ = 1, 20 do
				if private.gotBrowseResultsAdded then
					break
				end
				Threading.Sleep(0.1)
			end
			if not private.gotBrowseResultsAdded then
				Log.Warn("Timed out waiting for browse results added event")
				return false
			end
		end
	else
		if self:_IsSniper() then
			if self._sniperLastPage then
				-- scan the last page
				local lastPage = max(ceil(select(2, GetNumAuctionItems("list")) / NUM_AUCTION_ITEMS_PER_PAGE) - 1, 0)
				while true do
					-- wait for the AH to be ready
					while not CanSendAuctionQuery() do
						if self._scan:_IsCancelled() then
							Log.Info("Stopping canelled scan")
							return false
						end
						Threading.Yield(true)
					end
					-- query the AH
					QueryAuctionItems(nil, nil, nil, lastPage)
					-- wait for the update event
					Threading.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
					local newLastPage = max(ceil(select(2, GetNumAuctionItems("list")) / NUM_AUCTION_ITEMS_PER_PAGE) - 1, 0)
					if newLastPage == lastPage then
						break
					end
					lastPage = newLastPage
				end
			else
				-- scan the first page
				-- wait for the AH to be ready
				Threading.WaitForFunction(CanSendAuctionQuery)
				-- query the AH
				QueryAuctionItems(nil, nil, nil, 0)
				-- wait for the update event
				Threading.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
			end
		elseif self:_IsGetAll() then
			assert(TSM.IsWowClassic()) -- currently only support GetAll scans on classic
			-- wait for the AH to be ready
			Threading.WaitForFunction(CanSendAuctionQuery)
			if not select(2, CanSendAuctionQuery()) then
				-- can't do a getall scan right now
				return false
			end
			-- query the AH
			QueryAuctionItems(nil, nil, nil, 0, nil, nil, true)
			-- wait for the update event
			Threading.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
		else
			-- wait for the AH to be ready
			Threading.WaitForFunction(CanSendAuctionQuery)
			local classFilterInfo = nil
			if self._class or self._subClass or self._invType then
				classFilterInfo = TempTable.Acquire()
				if self._invType == LE_INVENTORY_TYPE_CHEST_TYPE or self._invType == LE_INVENTORY_TYPE_ROBE_TYPE then
					-- default AH sends in queries for both chest types, we need to mimic this when using a chest filter
					local info1 = TempTable.Acquire()
					info1.classID = self._class
					info1.subClassID = self._subClass
					info1.inventoryType = LE_INVENTORY_TYPE_CHEST_TYPE
					tinsert(classFilterInfo, info1)
					local info2 = TempTable.Acquire()
					info2.classID = self._class
					info2.subClassID = self._subClass
					info2.inventoryType = LE_INVENTORY_TYPE_ROBE_TYPE
					tinsert(classFilterInfo, info2)
				elseif self._invType == LE_INVENTORY_TYPE_NECK_TYPE or self._invType == LE_INVENTORY_TYPE_FINGER_TYPE or self._invType == LE_INVENTORY_TYPE_TRINKET_TYPE or self._invType == LE_INVENTORY_TYPE_HOLDABLE_TYPE or self._invType == LE_INVENTORY_TYPE_BODY_TYPE then
					local info = TempTable.Acquire()
					info.classID = self._class
					info.subClassID = LE_ITEM_ARMOR_GENERIC
					info.inventoryType = self._invType
					tinsert(classFilterInfo, info)
				elseif self._invType == LE_INVENTORY_TYPE_CLOAK_TYPE then
					local info = TempTable.Acquire()
					info.classID = self._class
					info.subClassID = LE_ITEM_ARMOR_CLOTH
					info.inventoryType = LE_INVENTORY_TYPE_CLOAK_TYPE
					tinsert(classFilterInfo, info)
				else
					local info = TempTable.Acquire()
					info.classID = self._class
					info.subClassID = self._subClass
					info.inventoryType = self._invType
					tinsert(classFilterInfo, info)
				end
			end
			QueryAuctionItems(self._name, self._minLevel, self._maxLevel, self._page, self._usable, self._quality, nil, self._exact, classFilterInfo)
			if classFilterInfo then
				for i = #classFilterInfo, 1, -1 do
					TempTable.Release(classFilterInfo[i])
					classFilterInfo[i] = nil
				end
				TempTable.Release(classFilterInfo)
			end
			-- wait for the update event
			Threading.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
		end
	end
	return true
end

function AuctionFilter._AddResultRow(self, uuid)
	self._resultIncludesRow[uuid] = true
end

function AuctionFilter._IncludesResultRow(self, uuid)
	return self._resultIncludesRow[uuid]
end

function AuctionFilter._GetNumCanBuy(self, row)
	local num = nil
	if self._generalMaxQuantity then
		num = min(self._generalMaxQuantity, num or math.huge)
	end
	if self._itemMaxQuantities then
		local itemString, baseItemString = row:GetFields("itemString", "baseItemString")
		if self._itemMaxQuantities[itemString] then
			num = min(self._itemMaxQuantities[itemString], num or math.huge)
		elseif self._itemMaxQuantities[baseItemString] then
			num = min(self._itemMaxQuantities[baseItemString], num or math.huge)
		end
	end
	if num then
		num = ceil(num / row:GetField("stackSize"))
	end
	return num
end

function AuctionFilter._RemoveResultRows(self, db, row, numBought)
	local result = false
	local stackSize, itemString, baseItemString = row:GetFields("stackSize", "itemString", "baseItemString")
	if numBought == 0 or numBought == stackSize then
		self._resultIncludesRow[row:GetUUID()] = nil
		db:DeleteRow(row)
		result = true
		if numBought == 0 then
			return result
		end
	else
		stackSize = stackSize - numBought
		assert(stackSize > 0)
		assert(ItemInfo.IsCommodity(itemString))
		row:SetField("stackSize", stackSize)
			:Update()
	end

	if self._generalMaxQuantity then
		self._generalMaxQuantity = self._generalMaxQuantity - stackSize
		if self._generalMaxQuantity <= 0 then
			-- remove everything
			for uuid in pairs(self._resultIncludesRow) do
				self._resultIncludesRow[uuid] = nil
				db:DeleteRowByUUID(uuid)
				result = true
			end
		end
	end
	if self._itemMaxQuantities then
		if self._itemMaxQuantities[itemString] then
			self._itemMaxQuantities[itemString] = self._itemMaxQuantities[itemString] - stackSize
			if self._itemMaxQuantities[itemString] <= 0 then
				-- remove all of this item
				for uuid in pairs(self._resultIncludesRow) do
					if db:GetRowFieldByUUID(uuid, "itemString") == itemString then
						self._resultIncludesRow[uuid] = nil
						db:DeleteRowByUUID(uuid)
						result = true
					end
				end
			end
		elseif self._itemMaxQuantities[baseItemString] then
			self._itemMaxQuantities[baseItemString] = self._itemMaxQuantities[baseItemString] - stackSize
			if self._itemMaxQuantities[baseItemString] <= 0 then
				-- remove all of this item
				for uuid in pairs(self._resultIncludesRow) do
					if db:GetRowFieldByUUID(uuid, "baseItemString") == baseItemString then
						self._resultIncludesRow[uuid] = nil
						db:DeleteRowByUUID(uuid)
						result = true
					end
				end
			end
		end
	end
	return result
end



-- ============================================================================
-- Initialization Code
-- ============================================================================

do
	if not TSM.IsWowClassic() then
		Event.Register("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", function()
			Log.Info("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
			private.gotBrowseResultsUpdate = true
		end)
		Event.Register("AUCTION_HOUSE_BROWSE_RESULTS_ADDED", function()
			Log.Info("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
			private.gotBrowseResultsAdded = true
		end)
	end
end
