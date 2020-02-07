-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains code for scanning the auction house
local _, TSM = ...
local L = TSM.Include("Locale").GetTable()
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local Database = TSM.Include("Util.Database")
local TempTable = TSM.Include("Util.TempTable")
local Vararg = TSM.Include("Util.Vararg")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local AuctionHouseWrapper = TSM.Include("Service.AuctionHouseWrapper")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Conversions = TSM.Include("Service.Conversions")
local MailTracking = TSM.Include("Service.MailTracking")
local private = {
	recycledScans = {},
	filterId = 1,
	queryUtilContext = { self = nil, maxItemQuantity = nil, targetItem = nil },
	tempItemKey = {
		itemLevel = 0,
		itemSuffix = 0,
		battlePetSpeciesID = 0,
		itemID = 0,
	},
}
-- some constants
local SCAN_RESULT_DELAY = 0.1
local MAX_SOFT_RETRIES = 50
local MAX_SETTLE_TIME = 0.5



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

local AuctionScan = TSM.Include("LibTSMClass").DefineClass("AuctionScan")

function AuctionScan.__init(self)
	self._resolveSellers = nil
	self._ignoreItemLevel = nil
	self._filters = {}
	self._db = nil
	self._filtersScanned = 0
	self._pagesScanned = 0
	self._numPages = 0
	self._progressChanged = true
	self._onProgressUpdateHandler = nil
	self._onFilterDoneHandler = nil
	self._customFilterFunc = nil
	self._findFilter = nil
	self._findResult = {}
	self._cancelled = false
end

function AuctionScan._Acquire(self, db)
	self._db = db
end

function AuctionScan._Release(self)
	self._resolveSellers = nil
	self._ignoreItemLevel = nil
	for _, filter in ipairs(self._filters) do
		filter:_Release()
		TSM.Auction.RecycleAuctionFilter(filter)
	end
	wipe(self._filters)
	if self._findFilter then
		self._findFilter:_Release()
		TSM.Auction.RecycleAuctionFilter(self._findFilter)
		self._findFilter = nil
	end
	self._db = nil
	self._filtersScanned = 0
	self._pagesScanned = 0
	self._numPages = 0
	self._progressChanged = true
	self._onProgressUpdateHandler = nil
	self._onFilterDoneHandler = nil
	self._customFilterFunc = nil
	self._cancelled = false
	wipe(self._findResult)
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AuctionScan.Release(self)
	self:_Release()
	tinsert(private.recycledScans, self)
end

function AuctionScan.CreateDBQuery(self)
	return self._db:NewQuery()
end

function AuctionScan.SetCustomFilterFunc(self, func)
	self._customFilterFunc = func
	return self
end

function AuctionScan.SetResolveSellers(self, resolveSellers)
	self._resolveSellers = resolveSellers
	return self
end

function AuctionScan.SetIgnoreItemLevel(self, ignoreItemLevel)
	self._ignoreItemLevel = ignoreItemLevel
	return self
end

function AuctionScan.SetScript(self, script, handler)
	if script == "OnProgressUpdate" then
		self._onProgressUpdateHandler = handler
	elseif script == "OnFilterDone" then
		self._onFilterDoneHandler = handler
	else
		error("Unknown AuctionScan script: "..tostring(script))
	end
	return self
end

function AuctionScan.GetNumFilters(self)
	return #self._filters
end

function AuctionScan.FilterIterator(self)
	return ipairs(self._filters)
end

function AuctionScan.NewAuctionFilter(self)
	local filter = TSM.Auction.NewAuctionFilter()
	filter:_Acquire(self)
	tinsert(self._filters, filter)
	self._progressChanged = true
	return filter
end

function AuctionScan.AddItemListFiltersThreaded(self, itemList, maxItemQuantity, targetItem)
	assert(Threading.IsThreadContext())
	-- remove duplicates
	local usedItems = TempTable.Acquire()
	for i = #itemList, 1, -1 do
		local itemString = itemList[i]
		if usedItems[itemString] then
			tremove(itemList, i)
		end
		usedItems[itemString] = true
	end
	TempTable.Release(usedItems)
	private.queryUtilContext.self = self
	private.queryUtilContext.maxItemQuantity = maxItemQuantity
	private.queryUtilContext.targetItem = targetItem
	TSM.Auction.QueryUtil.GenerateThreaded(itemList, private.NewQueryFilterCallback)
end

function AuctionScan.AddItemFilterThreaded(self, itemFilter)
	if itemFilter:GetCrafting() then
		local itemList = Threading.AcquireSafeTempTable()
		local targetItem = Conversions.GetTargetItemByName(itemFilter:GetStr())
		assert(targetItem)
		tinsert(itemList, targetItem)
		local conversionInfo = Conversions.GetSourceItems(targetItem)
		for itemString in pairs(conversionInfo) do
			tinsert(itemList, itemString)
		end
		self:AddItemListFiltersThreaded(itemList, nil, targetItem)
		Threading.ReleaseSafeTempTable(itemList)
	elseif itemFilter:GetDisenchant() then
		local targetItem = Conversions.GetTargetItemByName(itemFilter:GetStr())
		assert(targetItem)
		local disenchantInfo = DisenchantInfo.GetInfo(targetItem)
		for _, info in ipairs(disenchantInfo.sourceInfo) do
			self:NewAuctionFilter()
				:SetMinLevel(disenchantInfo.minLevel)
				:SetMaxLevel(disenchantInfo.maxLevel)
				:SetQuality(info.quality)
				:SetClass(info.classId)
				:SetMinItemLevel(info.minItemLevel)
				:SetMaxItemLevel(info.maxItemLevel)
				:SetTargetItem(targetItem)
		end
		local itemList = Threading.AcquireSafeTempTable()
		tinsert(itemList, targetItem)
		self:AddItemListFiltersThreaded(itemList, nil, targetItem)
		Threading.ReleaseSafeTempTable(itemList)
	else
		self:NewAuctionFilter()
			:SetName(itemFilter:GetStr())
			:SetMinLevel(itemFilter:GetMinLevel())
			:SetMaxLevel(itemFilter:GetMaxLevel())
			:SetQuality(itemFilter:GetQuality())
			:SetClass(itemFilter:GetClass())
			:SetSubClass(itemFilter:GetSubClass())
			:SetInvType(itemFilter:GetInvSlotId())
			:SetUncollected(itemFilter:GetUncollected())
			:SetUsable(itemFilter:GetUsableOnly())
			:SetUpgrades(itemFilter:GetUpgrades())
			:SetUnlearned(itemFilter:GetUnlearned())
			:SetCanLearn(itemFilter:GetCanLearn())
			:SetExact(itemFilter:GetExactOnly())
			:SetEvenOnly(itemFilter:GetEvenOnly())
			:SetMinItemLevel(itemFilter:GetMinItemLevel())
			:SetMaxItemLevel(itemFilter:GetMaxItemLevel())
			:SetMinPrice(itemFilter:GetMinPrice())
			:SetMaxPrice(itemFilter:GetMaxPrice())
			:SetGeneralMaxQuantity(itemFilter:GetMaxQuantity())
			:SetItems(itemFilter:GetItem())
	end
end

function AuctionScan.StartScanThreaded(self)
	assert(Threading.IsThreadContext())
	private.ScanQueryThreaded(self)
end

function AuctionScan.FindAuctionThreaded(self, row, noSeller)
	assert(Threading.IsThreadContext())
	wipe(self._findResult)
	if TSM.IsWowClassic() then
		return private.FindAuctionThreaded(self, row, noSeller)
	else
		return private.FindAuctionThreaded83(self, row, noSeller)
	end
end

function AuctionScan.PrepareForBidOrBuyout(self, index, validateRow, noSeller, quantity)
	if TSM.IsWowClassic() then
		return self:_ValidateIndex(index, validateRow, noSeller)
	else
		local itemString = validateRow:GetField("itemString")
		if ItemInfo.IsCommodity(itemString) then
			local itemId = ItemString.ToId(itemString)
			-- get the cheapest auction we can buy
			local itemBuyout, numOwnerItems, stackSize = self._db:NewQuery()
				:Equal("itemString", validateRow:GetField("itemString"))
				:NotEqual("stackSize", Database.OtherFieldQueryParam("numOwnerItems"))
				:OrderBy("itemBuyout", true)
				:Select("itemBuyout", "numOwnerItems", "stackSize")
				:GetFirstResultAndRelease()
			if quantity > stackSize - numOwnerItems then
				-- trying to buy too many
				return false
			end
			if itemBuyout ~= validateRow:GetField("itemBuyout") then
				-- cheapest auction isn't selected
				return false
			end
			local future = AuctionHouseWrapper.StartCommoditiesPurchase(itemId, quantity, itemBuyout)
			if not future then
				return false
			end
			-- TODO: return this future
			future:Cancel()
			return true
		else
			return true
		end
	end
end

function AuctionScan.PlaceBidOrBuyout(self, index, bidBuyout, validateRow, quantity)
	if TSM.IsWowClassic() then
		PlaceAuctionBid("list", index, bidBuyout)
		return true
	else
		local itemString = validateRow:GetField("itemString")
		local future = nil
		if ItemInfo.IsCommodity(itemString) then
			local itemId = ItemString.ToId(itemString)
			future = AuctionHouseWrapper.ConfirmCommoditiesPurchase(itemId, quantity)
		else
			future = AuctionHouseWrapper.PlaceBid(validateRow:GetField("auctionId"), bidBuyout)
			quantity = 1
		end
		if not future then
			return false
		end
		-- TODO: return this future and record the buyout once the future is done
		future:Cancel()
		MailTracking.RecordAuctionBuyout(ItemString.GetBaseFast(itemString), quantity)
		return true
	end
end

function AuctionScan.GetProgress(self)
	return self._filtersScanned, #self._filters, self._pagesScanned, self._numPages
end

function AuctionScan.GetNumCanBuy(self, row)
	local rowFilter = nil
	for _, filter in ipairs(self._filters) do
		if filter:_IncludesResultRow(row:GetUUID()) then
			assert(not rowFilter)
			rowFilter = filter
		end
	end
	assert(rowFilter)
	return rowFilter:_GetNumCanBuy(row)
end

function AuctionScan.DeleteRowFromDB(self, row, numBought)
	local rowFilter = nil
	for _, filter in ipairs(self._filters) do
		if filter:_IncludesResultRow(row:GetUUID()) then
			assert(not rowFilter)
			rowFilter = filter
		end
	end
	assert(rowFilter)
	self._db:SetQueryUpdatesPaused(true)
	local result = rowFilter:_RemoveResultRows(self._db, row, numBought)
	self._db:SetQueryUpdatesPaused(false)
	return result
end

function AuctionScan.Cancel(self)
	self._cancelled = true
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function AuctionScan._IsCancelled(self)
	return self._cancelled
end

function AuctionScan._IsFiltered(self, itemString, itemBuyout, stackSize, itemDisplayedBid)
	if self._customFilterFunc and self._customFilterFunc(itemString, itemBuyout, stackSize, itemDisplayedBid) then
		return true
	end
	return false
end

function AuctionScan._GetAuctionRowHash(self, index, noSeller)
	local _, _, stackSize, _, _, _, _, minBid, minIncrement, buyout, bid, isHighBidder, _, seller, sellerFull = GetAuctionItemInfo("list", index)
	local rawLink = GetAuctionItemLink("list", index)
	local timeLeft = GetAuctionItemTimeLeft("list", index)
	-- this is to get around a bug in Blizzard's code where the minIncrement value will be inconsistent for auctions where the player is the highest bidder
	minIncrement = isHighBidder and 0 or minIncrement
	if noSeller then
		return strjoin("~", tostringall(rawLink, minBid, minIncrement, buyout, bid, timeLeft, stackSize, isHighBidder))
	else
		seller = private.FixSellerName(seller, sellerFull) or "?"
		return strjoin("~", tostringall(rawLink, minBid, minIncrement, buyout, bid, seller, timeLeft, stackSize, isHighBidder))
	end
end

function AuctionScan._GetAuctionRowFields(self, index, filter)
	local rawName, texture, stackSize, _, _, _, _, minBid, minIncrement, buyout, bid, isHighBidder, _, seller, sellerFull = GetAuctionItemInfo("list", index)
	local rawLink = GetAuctionItemLink("list", index)
	local timeLeft = GetAuctionItemTimeLeft("list", index)
	local itemLink = ItemInfo.GeneralizeLink(rawLink)
	local itemString = ItemString.Get(itemLink)
	seller = private.FixSellerName(seller, sellerFull) or "?"
	if not itemString or not buyout or not stackSize or not timeLeft or not ItemInfo.GetName(itemLink) then
		return false
	elseif not ItemInfo.GetItemLevel(itemLink) and not self._ignoreItemLevel then
		return false
	elseif seller == "?" and self._resolveSellers and buyout ~= 0 then
		return false
	end
	-- pet auctions don't give textures so get from our item database
	texture = texture or ItemInfo.GetTexture(itemLink)
	local displayedBid = bid == 0 and minBid or bid
	local itemDisplayedBid = floor(displayedBid / stackSize)
	local itemBuyout = (buyout > 0) and floor(buyout / stackSize) or 0
	-- this is to get around a bug in Blizzard's code where the minIncrement value will be inconsistent for auctions where the player is the highest bidder
	minIncrement = isHighBidder and 0 or minIncrement
	local hash = self:_GetAuctionRowHash(index, false)
	local hashNoSeller = self:_GetAuctionRowHash(index, true)
	local targetItem = filter and filter:_GetTargetItem() or itemString
	local targetItemRate = filter and filter:_GetTargetItemRate(itemString)
	return rawName, rawLink, texture, stackSize, minBid, minIncrement, buyout, bid, isHighBidder,
		seller, timeLeft, displayedBid, itemDisplayedBid, itemBuyout, itemLink,
		itemString, hash, hashNoSeller, private.filterId, targetItem, targetItemRate, 0, 0
end

function AuctionScan._GetAuctionRowFields83(self, isCommodity, itemKey, index, filter)
	local rawName, rawLink, texture, stackSize, minBid, minIncrement, buyout, bid = nil, nil, nil, nil, nil, nil, nil, nil
	local isHighBidder, seller, timeLeft, displayedBid, itemDisplayedBid, itemBuyout = nil, nil, nil, nil, nil, nil
	local itemLink, itemString, hash, hashNoSeller, targetItem, targetItemRate, auctionId, numOwnerItems = nil, nil, nil, nil, nil, nil, nil, nil
	local resultInfo = nil
	if isCommodity then
		resultInfo = C_AuctionHouse.GetCommoditySearchResultInfo(itemKey.itemID, index)
	else
		resultInfo = C_AuctionHouse.GetItemSearchResultInfo(itemKey, index)
	end
	if not resultInfo then
		return nil
	end

	if isCommodity then
		rawLink = ItemInfo.GetLink(itemKey.itemID)
		buyout = resultInfo.unitPrice * resultInfo.quantity
		-- convert the timeLeftSeconds to regular timeLeft
		if resultInfo.timeLeftSeconds < 60 * 60 then
			timeLeft = 1
		elseif resultInfo.timeLeftSeconds < 2 * 60 * 60 then
			timeLeft = 2
		elseif resultInfo.timeLeftSeconds < 12 * 60 * 60 then
			timeLeft = 3
		else
			timeLeft = 4
		end
	else
		-- use the itemKey from the results as it might have more info (i.e. level / suffix) than what we queried for
		itemKey = resultInfo.itemKey
		rawLink = resultInfo.itemLink
		buyout = (resultInfo.buyoutAmount or 0) * resultInfo.quantity
		timeLeft = resultInfo.timeLeft + 1
	end
	itemLink = ItemInfo.GeneralizeLink(rawLink)
	itemString = ItemString.Get(itemLink)

	-- validate the data
	if not itemString or not ItemInfo.GetName(itemLink) then
		return nil
	elseif not ItemInfo.GetItemLevel(itemLink) and not self._ignoreItemLevel then
		return nil
	elseif #resultInfo.owners == 0 and self._resolveSellers and buyout ~= 0 then
		return nil
	end
	for i, owner in ipairs(resultInfo.owners) do
		if owner == "player" then
			resultInfo.owners[i] = UnitName("player")
		elseif owner == "" and self._resolveSellers and buyout ~= 0 then
			return nil
		end
	end

	texture = ItemInfo.GetTexture(itemLink)
	rawName = ItemInfo.GetName(rawLink)
	stackSize = resultInfo.quantity
	itemBuyout = buyout / stackSize
	isHighBidder = resultInfo.bidder and resultInfo.bidder == UnitGUID("player") or false
	minBid = resultInfo.minBid or buyout
	bid = resultInfo.bidAmount or 0
	displayedBid = minBid
	minIncrement = 0 -- not used in 8.3
	itemDisplayedBid = displayedBid / stackSize
	seller = table.concat(resultInfo.owners, ",")
	auctionId = resultInfo.auctionID
	if isCommodity then
		hash = strjoin("~", tostringall(itemKey.itemID, itemBuyout, auctionId, seller))
		hashNoSeller = strjoin("~", tostringall(itemKey.itemID, itemBuyout, auctionId))
	else
		hash = strjoin("~", tostringall(itemKey.itemID, itemKey.itemLevel, itemKey.itemSuffix, itemKey.battlePetSpeciesID, rawLink, itemDisplayedBid, itemBuyout, bid, stackSize, isHighBidder, seller))
		hashNoSeller = strjoin("~", tostringall(itemKey.itemID, itemKey.itemLevel, itemKey.itemSuffix, itemKey.battlePetSpeciesID, rawLink, itemDisplayedBid, itemBuyout, bid, stackSize, isHighBidder))
	end
	targetItem = filter and filter:_GetTargetItem() or itemString
	targetItemRate = filter and filter:_GetTargetItemRate(itemString)
	if isCommodity then
		numOwnerItems = resultInfo.numOwnerItems or 0
	else
		numOwnerItems = resultInfo.containsAccountItem and stackSize or 0
	end
	return rawName, rawLink, texture, stackSize, minBid, minIncrement, buyout, bid, isHighBidder,
		seller, timeLeft, displayedBid, itemDisplayedBid, itemBuyout, itemLink,
		itemString, hash, hashNoSeller, private.filterId, targetItem, targetItemRate, auctionId, numOwnerItems
end

function AuctionScan._NotifyFilterDone(self, filter, numNewResults)
	if self._onFilterDoneHandler then
		self:_onFilterDoneHandler(filter, numNewResults)
	end
end

function AuctionScan._SetFiltersScanned(self, num)
	self._progressChanged = self._progressChanged or num ~= self._filtersScanned
	self._filtersScanned = num
	self:_SetPageProgress(0, 0)
end

function AuctionScan._SetPageProgress(self, pagesScanned, numPages)
	self._progressChanged = self._progressChanged or pagesScanned ~= self._pagesScanned or numPages ~= self._numPages
	self._pagesScanned = pagesScanned
	self._numPages = numPages
	local changed = self._progressChanged
	self._progressChanged = false
	if changed and self._onProgressUpdateHandler then
		self:_onProgressUpdateHandler()
	end
end

function AuctionScan._GetFindFilter(self, row)
	if self._findFilter then
		self._findFilter:_Release()
	else
		self._findFilter = TSM.Auction.NewAuctionFilter()
	end
	self._findFilter:_Acquire(self)
	local itemString = row:GetField("itemString")
	local level = ItemInfo.GetMinLevel(itemString)
	self._findFilter
		:SetName(ItemInfo.GetName(itemString))
		:SetMinLevel(level)
		:SetMaxLevel(level)
		:SetQuality(ItemInfo.GetQuality(itemString))
		:SetClass(ItemInfo.GetClassId(itemString))
		:SetSubClass(ItemInfo.GetSubClassId(itemString))
		:SetExact(true)
		:SetItems(itemString)
	return self._findFilter
end

function AuctionScan._ValidateIndex(self, index, validateRow, noSeller)
	return validateRow:GetField(noSeller and "hashNoSeller" or "hash") == self:_GetAuctionRowHash(index, noSeller)
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Auction.NewDatabase(name)
	return Database.NewSchema(name)
		-- raw fields directly from the game
		:AddStringField("rawName")
		:AddStringField("rawLink")
		:AddNumberField("texture")
		:AddNumberField("stackSize")
		:AddNumberField("minBid")
		:AddNumberField("minIncrement")
		:AddNumberField("buyout")
		:AddNumberField("bid")
		:AddBooleanField("isHighBidder")
		:AddStringField("seller")
		:AddNumberField("timeLeft")
		-- calculated fields which we'll use (so want to cache)
		:AddNumberField("displayedBid")
		:AddNumberField("itemDisplayedBid")
		:AddNumberField("itemBuyout")
		:AddStringField("itemLink")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
		:AddStringField("hash")
		:AddStringField("hashNoSeller")
		:AddNumberField("filterId")
		:AddStringField("targetItem")
		:AddNumberField("targetItemRate")
		:AddNumberField("auctionId")
		:AddNumberField("numOwnerItems")
		:Commit()
end

function TSMAPI_FOUR.Auction.NewAuctionScan(db)
	local auctionScan = tremove(private.recycledScans)
	if not auctionScan then
		auctionScan = AuctionScan()
	end
	auctionScan:_Acquire(db)
	return auctionScan
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.NewQueryFilterCallback(items, name, minLevel, maxLevel, quality, class, subClass)
	local auctionFilter = private.queryUtilContext.self:NewAuctionFilter()
		:SetName(name)
		:SetMinLevel(minLevel)
		:SetMaxLevel(maxLevel)
		:SetQuality(quality)
		:SetClass(class)
		:SetSubClass(subClass)
		:SetItems(items)
	for _, itemString in ipairs(auctionFilter:GetItems()) do
		local num = private.queryUtilContext.maxItemQuantity and private.queryUtilContext.maxItemQuantity[itemString]
		if num then
			auctionFilter:SetItemMaxQuantity(itemString, num)
		end
		local targetItem = private.queryUtilContext.targetItem
		if targetItem then
			auctionFilter:SetTargetItem(targetItem)
		end
	end
end

function private.IsAuctionPageValidThreaded(auctionScan)
	local numAuctions, totalAuctions = GetNumAuctionItems("list")
	if totalAuctions <= NUM_AUCTION_ITEMS_PER_PAGE and numAuctions ~= totalAuctions then
		-- there are cases where we get (0, 1) from the API - no idea why and it'll cause bugs later, so we should count it as invalid
		Log.Err("Unexpected number of auctions (%d, %d)", numAuctions, totalAuctions)
		return false
	end

	for i = 1, numAuctions do
		-- checks to make sure all the data has been sent to the client
		-- if not, the data is bad and we'll wait / try again
		if not auctionScan:_GetAuctionRowFields(i) then
			return false
		end
		Threading.Yield()
	end

	return true
end

function private.ScanAuctionPageThreaded(auctionScan, filter)
	if TSM.IsWowClassic() then
		-- scan the results
		local scanResult, numInsertedRows = private.ProcessScanResultsThreaded(auctionScan, filter)
		if not scanResult then
			return false
		end
		return true, numInsertedRows
	else
		local results = C_AuctionHouse.GetBrowseResults()
		local origNumResults = #results
		for i = #results, 1, -1 do
			local itemKey = results[i].itemKey
			local minPrice = results[i].minPrice
			local totalQuantity = results[i].totalQuantity
			local baseItemString = ItemString.GetBaseFromItemKey(itemKey)
			if filter:_IsItemFiltered(baseItemString, nil, nil, nil, nil, totalQuantity, minPrice) or not filter:_ShouldScanItem(baseItemString, nil, minPrice) then
				tremove(results, i)
			else
				local itemKeyInfo = private.GetItemKeyInfo(auctionScan, itemKey)
				if not itemKeyInfo then
					Log.Info("Stopping cancelled scan")
					return false
				end
				local itemLevel = nil
				if not auctionScan._ignoreItemLevel then
					itemLevel = itemKeyInfo.battlePetLink and ItemInfo.GetItemLevel(itemKeyInfo.battlePetLink) or itemKey.itemLevel
					if itemLevel == 0 then
						itemLevel = nil
					end
					if not itemLevel and not ItemString.HasNonBase(baseItemString) then
						while not ItemInfo.GetItemLevel(baseItemString) do
							Threading.Yield(true)
						end
						itemLevel = ItemInfo.GetItemLevel(baseItemString)
					end
				end
				local itemString = nil
				if itemKeyInfo.battlePetLink then
					itemString = ItemString.Get(itemKeyInfo.battlePetLink)
				elseif not ItemString.HasNonBase(baseItemString) then
					itemString = baseItemString
				end
				local itemName = itemKeyInfo.itemName
				local quality = itemKeyInfo.quality
				assert(baseItemString and minPrice and itemName and quality and totalQuantity)
				while not ItemInfo.GetMinLevel(baseItemString) do
					Threading.Yield(true)
				end
				if filter:_IsItemFiltered(baseItemString, itemString, itemLevel, quality, itemName, totalQuantity, minPrice) or not filter:_ShouldScanItem(baseItemString, itemString, minPrice) then
					tremove(results, i)
				end
			end
			Threading.Yield()
		end
		local numRemoved = origNumResults - #results
		if numRemoved > 0 then
			Log.Info("Removed %d/%d results", numRemoved, origNumResults)
		end

		filter:_SetNumPages(#results)
		local numInsertedRows = 0
		for i = 1, #results do
			local itemKey = results[i].itemKey

			-- check if the item is a commodity or not
			local isCommodity = ItemInfo.IsCommodity(itemKey.itemID)
			while isCommodity == nil do
				Threading.Yield(true)
				isCommodity = ItemInfo.IsCommodity(itemKey.itemID)
				if auctionScan:_IsCancelled() then
					Log.Info("Stopping cancelled scan")
					return false
				end
			end

			local success, scanNumInsertedRows = private.ScanItemKey83(auctionScan, filter, isCommodity, itemKey, false)
			if not success then
				return false
			end
			numInsertedRows = numInsertedRows + scanNumInsertedRows

			-- update the "page"
			filter:_SetPage(i)
			auctionScan:_SetPageProgress(filter:_GetPageProgress())
			Threading.Yield()
		end
		return true, numInsertedRows
	end
end

function private.ScanItemKey83(auctionScan, filter, isCommodity, itemKey, sellQuery)
	-- send the query for this item
	if not private.SendSearchQuery83(itemKey, auctionScan, isCommodity, sellQuery) then
		return false
	end

	-- scan the results
	local scanResult, scanNumInsertedRows = private.ProcessScanResultsThreaded(auctionScan, filter, isCommodity, itemKey)
	if not scanResult then
		return false
	end
	return true, scanNumInsertedRows
end

function private.ProcessScanResultsThreaded(auctionScan, filter, isCommodity, itemKey)
	local numInsertedRows = 0
	local startTime = GetTime()
	local lastSuccessTime = GetTime()
	local index = 1
	while true do
		local numAuctions = nil
		local prevIndex = index
		local numNewInsertedRows = nil
		if not TSM.IsWowClassic() then
			if isCommodity then
				numAuctions = C_AuctionHouse.GetNumCommoditySearchResults(itemKey.itemID)
			else
				numAuctions = C_AuctionHouse.GetNumItemSearchResults(itemKey)
			end
			index, numNewInsertedRows = private.ProcessAuctionRows(auctionScan, filter, index, numAuctions, isCommodity, itemKey)
		else
			local totalAuctions = nil
			numAuctions, totalAuctions = GetNumAuctionItems("list")
			if totalAuctions <= NUM_AUCTION_ITEMS_PER_PAGE and numAuctions ~= totalAuctions then
				-- there are cases where we get (0, 1) from the API - no idea why and it'll cause bugs later, so we should count it as invalid
				Log.Err("Unexpected number of auctions (%d, %d)", numAuctions, totalAuctions)
				return false
			elseif filter:_IsGetAll() and totalAuctions <= NUM_AUCTION_ITEMS_PER_PAGE then
				-- we're no longer on the GetAll results
				Log.Err("Switched off GetAll results")
				return false
			end
			index, numNewInsertedRows = private.ProcessAuctionRows(auctionScan, filter, index, min(numAuctions, index + NUM_AUCTION_ITEMS_PER_PAGE))
			if filter:_IsGetAll() then
				-- update the "page"
				filter:_SetPage(index)
				filter:_SetNumPages(numAuctions)
			elseif not filter:_IsSniper() then
				filter:_SetNumPages(ceil(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE))
			end
			auctionScan:_SetPageProgress(filter:_GetPageProgress())
		end

		if not index then
			return false
		end
		if index ~= prevIndex then
			lastSuccessTime = GetTime()
		end
		numInsertedRows = numInsertedRows + numNewInsertedRows

		if index > numAuctions then
			break
		elseif GetTime() > startTime + 300 then
			Log.Err("Timed out on entire scan")
			return false
		elseif GetTime() > lastSuccessTime + 30 then
			Log.Err("Timed out on index (%d)", index)
			return false
		end
		Threading.Sleep(0.01)
		if auctionScan:_IsCancelled() then
			Log.Info("Stopping cancelled scan")
			return false
		end
	end
	return true, numInsertedRows
end

function private.ProcessAuctionRows(auctionScan, filter, index, maxIndex, isCommodity, itemKey)
	auctionScan._db:BulkInsertStart()
	local firstInvalidIndex = nil
	for i = index, maxIndex do
		local isValid = nil
		if TSM.IsWowClassic() then
			isValid = private.ProcessAuctionRow(auctionScan, filter, not firstInvalidIndex, auctionScan:_GetAuctionRowFields(i, filter))
		else
			isValid = private.ProcessAuctionRow(auctionScan, filter, not firstInvalidIndex, auctionScan:_GetAuctionRowFields83(isCommodity, itemKey, i, filter))
		end
		if not isValid then
			firstInvalidIndex = firstInvalidIndex or i
		end
	end
	if firstInvalidIndex then
		index = firstInvalidIndex
	else
		index = maxIndex + 1
	end

	local numInsertedRows = 0
	if filter:_IsSniper() then
		-- don't store any rows for failed sniper queries
		if index <= maxIndex then
			Log.Err("Failed to validate sniper results")
			auctionScan._db:BulkInsertAbort()
			return nil
		end
		local newUUIDs = TempTable.Acquire()
		for _, uuid in auctionScan._db:BulkInsertUUIDIterator() do
			tinsert(newUUIDs, uuid)
			filter:_AddResultRow(uuid)
		end
		auctionScan._db:SetQueryUpdatesPaused(true)
		auctionScan._db:BulkInsertEnd()
		for _, uuid in ipairs(newUUIDs) do
			local hashNoSeller = auctionScan._db:GetRowFieldByUUID(uuid, "hashNoSeller")
			-- remove existing duplicates from previous filters
			local query = auctionScan._db:NewQuery()
				:Equal("hashNoSeller", hashNoSeller)
				:LessThan("filterId", private.filterId)
			local removedOld = false
			for _, oldRow in query:Iterator() do
				removedOld = true
				auctionScan:DeleteRowFromDB(oldRow, 0)
			end
			query:Release()
			if not removedOld then
				local newQuery = auctionScan._db:NewQuery()
					:Equal("hashNoSeller", hashNoSeller)
					:Equal("filterId", private.filterId)
				if newQuery:Count() == 1 then
					numInsertedRows = numInsertedRows + 1
				end
				newQuery:Release()
			end
		end
		TempTable.Release(newUUIDs)
		auctionScan._db:SetQueryUpdatesPaused(false)
	else
		for _, uuid in auctionScan._db:BulkInsertUUIDIterator() do
			filter:_AddResultRow(uuid)
			numInsertedRows = numInsertedRows + 1
		end
		auctionScan._db:BulkInsertEnd()
	end

	return index, numInsertedRows
end

function private.ProcessAuctionRow(auctionScan, filter, shouldInsert, rawName, rawLink, texture, stackSize, minBid, minIncrement, buyout, bid, isHighBidder, seller, timeLeft, displayedBid, itemDisplayedBid, itemBuyout, itemLink, itemString, hash, hashNoSeller, filterId, targetItem, targetItemRate, auctionId, numOwnerItems)
	if not rawName then
		return false
	end
	if not filter:_IsFiltered(auctionScan._ignoreItemLevel, itemString, itemBuyout, stackSize, targetItemRate) and not auctionScan:_IsFiltered(itemString, itemBuyout, stackSize, itemDisplayedBid) then
		if shouldInsert then
			auctionScan._db:BulkInsertNewRow(rawName, rawLink, texture, stackSize, minBid, minIncrement, buyout, bid, isHighBidder, seller, timeLeft, displayedBid, itemDisplayedBid, itemBuyout, itemLink, itemString, hash, hashNoSeller, filterId, targetItem, targetItemRate, auctionId, numOwnerItems)
		end
	end
	return true
end

function private.ValidateThreaded(auctionScan)
	-- wait a bit for things to settle
	local settleStartTime = GetTime()
	while not CanSendAuctionQuery() and GetTime() < settleStartTime + MAX_SETTLE_TIME do
		if auctionScan:_IsCancelled() then
			return false
		end
		Threading.Yield(true)
	end
	Log.Info("Took %d seconds for AH to settle", GetTime() - settleStartTime)
	-- check the result
	local tryNum = 0
	while tryNum < MAX_SOFT_RETRIES do
		if auctionScan:_IsCancelled() then
			Log.Info("Stopping cancelled scan")
			return false
		end
		-- wait a small delay and then try and get the result
		Threading.Sleep(SCAN_RESULT_DELAY)
		-- get result
		if private.IsAuctionPageValidThreaded(auctionScan) then
			-- result is valid, so we're done
			Log.Info("Took %d soft retries", tryNum)
			return true
		end
		-- only count tries if we're ready to send the next query
		if CanSendAuctionQuery() then
			tryNum = tryNum + 1
		end
	end
	Log.Info("Exhausted soft retries")
	return false
end

function private.SetAuctionSort(...)
	local numCols = select("#", ...)
	if GetAuctionSort("list", numCols + 1) == nil then
		local properlySorted = true
		for i = 1, numCols do
			local col = select(i, ...)
			local sortCol, sortReversed = GetAuctionSort("list", numCols - i + 1)
			-- we never care to reverse a sort so if it's reversed then it's not properly sorted
			if sortCol ~= col or sortReversed then
				properlySorted = false
				break
			end
		end
		if properlySorted then
			-- already sorted
			return
		end
	end

	SortAuctionClearSort("list")
	for _, col in Vararg.Iterator(...) do
		SortAuctionItems("list", col)
	end
	SortAuctionApplySort("list")
end

function private.ScanQueryThreaded(auctionScan)
	-- loop through each filter to perform
	auctionScan:_SetFiltersScanned(0)
	auctionScan._cancelled = false
	local allSuccess = true
	for i, filter in ipairs(auctionScan._filters) do
		if TSM.IsWowClassic() then
			-- update the sort for this filter
			if filter:_IsSniper() or filter:_IsGetAll() then
				private.SetAuctionSort()
			else
				private.SetAuctionSort("seller", "quantity", "unitprice")
			end
		end
		-- give some time for the AH to update
		Threading.Yield(true)
		filter:_ResetPage()
		local numNewResults = 0
		local hasMorePages = true
		local filterSuccess = true
		-- loop through each page of this filter and scan it
		while hasMorePages and not auctionScan:_IsCancelled() do
			local scanSuccess, numInsertedRows = nil, nil
			private.filterId = private.filterId + 1
			if not TSM.IsWowClassic() and #filter:GetItems() > 0 and not filter._shouldScanItemFunction then
				scanSuccess, numInsertedRows = private.DoItemScanThreaded(auctionScan, filter)
			else
				-- query the AH
				if not filter:_DoAuctionQueryThreaded() then
					filterSuccess = false
					break
				end
				-- we've made the query, now store the results
				scanSuccess, numInsertedRows = private.ScanAuctionPageThreaded(auctionScan, filter)
			end
			if not scanSuccess then
				-- don't store results for a failed filter
				Log.Err("Failed to scan filter")
				filterSuccess = false
				break
			elseif auctionScan:_IsCancelled() then
				Log.Info("Stopping cancelled scan")
				break
			end
			numNewResults = numNewResults + numInsertedRows
			hasMorePages = filter:_NextPage()
			auctionScan:_SetPageProgress(filter:_GetPageProgress())
		end
		if filterSuccess then
			auctionScan:_NotifyFilterDone(filter, numNewResults)
		elseif not filter:_IsSniper() then
			allSuccess = false
		end
		auctionScan:_SetFiltersScanned(i)
		if auctionScan:_IsCancelled() then
			break
		end
	end
	if not allSuccess then
		Log.PrintUser(L["TSM failed to scan some auctions. Please rerun the scan."])
	end
end

function private.DoItemScanThreaded(auctionScan, filter)
	private.tempItemKey.itemLevel = 0
	private.tempItemKey.itemSuffix = 0
	local numInsertedRows = 0
	local items = Threading.AcquireSafeTempTable()
	for _, itemString in ipairs(filter:GetItems()) do
		itemString = ItemString.GetBaseFast(itemString)
		if not items[itemString] then
			items[itemString] = true
			tinsert(items, itemString)
		end
	end
	filter:_SetNumPages(#items)
	for i, itemString in ipairs(items) do
		local isPet = ItemString.IsPet(itemString)
		local isCommodity = nil
		if isPet then
			isCommodity = false
			private.tempItemKey.itemID = ItemString.ToId(ItemString.GetPetCageItemString())
			private.tempItemKey.battlePetSpeciesID = ItemString.ToId(itemString)
		else
			isCommodity = ItemInfo.IsCommodity(itemString)
			while isCommodity == nil do
				Threading.Yield(true)
				isCommodity = ItemInfo.IsCommodity(itemString)
				if auctionScan:_IsCancelled() then
					Log.Info("Stopping cancelled scan")
					Threading.ReleaseSafeTempTable(items)
					return false
				end
			end
			private.tempItemKey.itemID = ItemString.ToId(itemString)
			private.tempItemKey.battlePetSpeciesID = 0
		end

		local scanSuccess, scanNumInsertedRows = private.ScanItemKey83(auctionScan, filter, isCommodity, private.tempItemKey, not isCommodity and not isPet)
		if not scanSuccess then
			Threading.ReleaseSafeTempTable(items)
			return false
		end
		numInsertedRows = numInsertedRows + scanNumInsertedRows

		-- update the "page"
		filter:_SetPage(i)
		auctionScan:_SetPageProgress(filter:_GetPageProgress())
		Threading.Yield()
	end
	Threading.ReleaseSafeTempTable(items)
	return true, numInsertedRows
end

function private.FindAuctionThreaded(auctionScan, row, noSeller)
	auctionScan._cancelled = false
	-- make sure we're not in the middle of a query where the results are going to change on us
	Threading.WaitForFunction(CanSendAuctionQuery)
	local timeout = 5
	while not private.IsAuctionPageValidThreaded(auctionScan) and timeout > 0 do
		Threading.Sleep(0.2)
		timeout = timeout - 0.2
	end

	-- search the current page for the auction
	if private.FindAuctionOnCurrentPage(auctionScan, row, noSeller) then
		Log.Info("Found on current page")
		return auctionScan._findResult
	end

	-- Sort the auction house
	private.SetAuctionSort("seller", "quantity", "unitprice")

	-- try to predict the auction index within the query we will be doing below
	local query = auctionScan._db:NewQuery()
		:Equal("baseItemString", row:GetField("baseItemString"))
		:GreaterThan("itemBuyout", 0)
		:OrderBy("itemBuyout", true)
		:OrderBy("stackSize", true)
		:OrderBy("seller", true)
	local predictionPage = nil
	if row:GetField("itemBuyout") == 0 then
		-- bid-only auctions will be on the last page so start there
		predictionPage = ceil(query:Count() / NUM_AUCTION_ITEMS_PER_PAGE) - 1
		Log.Info("Predicting auction is on page %d (bid-only)", predictionPage)
	else
		local index = 1
		for _, dbRow in query:Iterator() do
			if dbRow == row then
				-- this row shouldn't show up multiple times in the query
				assert(not predictionPage)
				predictionPage = ceil(index / NUM_AUCTION_ITEMS_PER_PAGE) - 1
				Log.Info("Predicting auction is on page %d (found in DB)", predictionPage)
			end
			index = index + 1
		end
	end
	query:Release()

	-- search for the item
	local filter = auctionScan:_GetFindFilter(row)
	filter:_SetPage(predictionPage)
	local minPage, maxPage, direction, retriesLeft = 0, nil, "UP", 1
	while true do
		-- query the AH
		if not filter:_DoAuctionQueryThreaded() then
			break
		end
		-- check the result
		private.ValidateThreaded(auctionScan)
		-- search this page for the row
		if private.FindAuctionOnCurrentPage(auctionScan, row, noSeller) then
			Log.Info("Found auction (%d)", filter:_GetPage())
			return auctionScan._findResult
		elseif auctionScan:_IsCancelled() then
			break
		end

		-- check if we can go to the next page
		local page, numPages = filter:_GetPageProgress()
		local canBeLater = private.FindAuctionCanBeOnLaterPage(row)
		local canBeEarlier = private.FindAuctionCanBeOnEarlierPage(row)
		maxPage = maxPage or numPages - 1
		if not canBeLater and page < maxPage then
			maxPage = page
		end
		if not canBeEarlier and page > minPage then
			minPage = page
		end
		while true do
			if direction == "UP" then
				if canBeLater and page < maxPage then
					Log.Info("Trying next page (%d)", page + 1)
					filter:_SetPage(page + 1)
					break
				else
					direction = "DOWN"
				end
			end
			if direction == "DOWN" then
				if canBeEarlier and page > minPage then
					Log.Info("Trying previous page (%d)", page - 1)
					filter:_SetPage(page - 1)
					break
				else
					if retriesLeft == 0 then
						-- give up
						Log.Info("Giving up (%d,%d,%d,%d)", minPage, maxPage, page, numPages)
						return
					end
					retriesLeft = retriesLeft - 1
					direction = "UP"
				end
			end
		end
	end
end

function private.FindAuctionCanBeOnLaterPage(row)
	local pageAuctions = GetNumAuctionItems("list")
	if pageAuctions == 0 then
		-- there are no auctions on this page, so it cannot be on a later one
		return false
	end
	local _, _, stackSize, _, _, _, _, _, _, buyout, _, _, _, seller, sellerFull = GetAuctionItemInfo("list", pageAuctions)

	local itemBuyout = (buyout > 0) and floor(buyout / stackSize) or 0
	local rowItemBuyout = row:GetField("itemBuyout")
	if rowItemBuyout > itemBuyout then
		-- item must be on a later page since it would be sorted after the last auction on this page
		return true
	elseif rowItemBuyout < itemBuyout then
		-- item cannot be on a later page since it would be sorted before the last auction on this page
		return false
	end

	local rowStackSize = row:GetField("stackSize")
	if rowStackSize > stackSize then
		-- item must be on a later page since it would be sorted after the last auction on this page
		return true
	elseif rowStackSize < stackSize then
		-- item cannot be on a later page since it would be sorted before the last auction on this page
		return false
	end

	seller = private.FixSellerName(seller, sellerFull) or "?"
	local rowSeller = row:GetField("seller")
	if rowSeller > seller then
		-- item must be on a later page since it would be sorted after the last auction on this page
		return true
	elseif rowSeller < seller then
		-- item cannot be on a later page since it would be sorted before the last auction on this page
		return false
	end

	-- all the things we are sorting on are the same, so the auction could be on a later page
	return true
end

function private.FindAuctionCanBeOnEarlierPage(row)
	local pageAuctions = GetNumAuctionItems("list")
	if pageAuctions == 0 then
		-- there are no auctions on this page, so it can be on an earlier one
		return true
	end
	local _, _, stackSize, _, _, _, _, _, _, buyout, _, _, _, seller, sellerFull = GetAuctionItemInfo("list", 1)

	local itemBuyout = (buyout > 0) and floor(buyout / stackSize) or 0
	local rowItemBuyout = row:GetField("itemBuyout")
	if rowItemBuyout < itemBuyout then
		-- item must be on an earlier page since it would be sorted before the first auction on this page
		return true
	elseif rowItemBuyout > itemBuyout then
		-- item cannot be on an earlier page since it would be sorted after the first auction on this page
		return false
	end

	local rowStackSize = row:GetField("stackSize")
	if rowStackSize < stackSize then
		-- item must be on an earlier page since it would be sorted before the last auction on this page
		return true
	elseif rowStackSize > stackSize then
		-- item cannot be on an earlier page since it would be sorted after the last auction on this page
		return false
	end

	seller = private.FixSellerName(seller, sellerFull) or "?"
	local rowSeller = row:GetField("seller")
	if rowSeller < seller then
		-- item must be on an earlier page since it would be sorted before the last auction on this page
		return true
	elseif rowSeller > seller then
		-- item cannot be on an earlier page since it would be sorted after the last auction on this page
		return false
	end

	-- all the things we are sorting on are the same, so the auction could be on an earlier page
	return true
end

function private.FindAuctionOnCurrentPage(auctionScan, row, noSeller)
	local found = false
	for i = 1, GetNumAuctionItems("list") do
		if auctionScan:_ValidateIndex(i, row, noSeller) then
			tinsert(auctionScan._findResult, i)
			found = true
		end
	end
	return found
end

function private.FindAuctionThreaded83(auctionScan, row, noSeller)
	auctionScan._cancelled = false
	local itemId, itemLevel, itemSuffix, battlePetSpeciesID = strsplit("~", row:GetField("hash"))
	local isCommodity = ItemInfo.IsCommodity(row:GetField("itemString"))
	noSeller = noSeller or isCommodity
	itemId = tonumber(itemId)
	itemLevel = tonumber(itemLevel)
	itemSuffix = tonumber(itemSuffix)
	battlePetSpeciesID = tonumber(battlePetSpeciesID)
	private.tempItemKey.itemID = itemId
	private.tempItemKey.itemLevel = isCommodity and 0 or itemLevel
	private.tempItemKey.itemSuffix = isCommodity and 0 or itemSuffix
	private.tempItemKey.battlePetSpeciesID = isCommodity and 0 or battlePetSpeciesID
	-- send the query for this item
	if not private.SendSearchQuery83(private.tempItemKey, auctionScan, isCommodity, false) then
		return nil
	end

	-- search the results for the auction
	local numItemResults = nil
	if isCommodity then
		numItemResults = C_AuctionHouse.GetNumCommoditySearchResults(private.tempItemKey.itemID)
	else
		numItemResults = C_AuctionHouse.GetNumItemSearchResults(private.tempItemKey)
	end
	local result = nil
	for i = 1, numItemResults do
		local _, _, _, stackSize, _, _, _, _, _, _, _, _, _, _, _, _, hash, hashNoSeller = auctionScan:_GetAuctionRowFields83(isCommodity, private.tempItemKey, i)
		if (noSeller and hashNoSeller or hash) == row:GetField(noSeller and "hashNoSeller" or "hash") then
			result = (result or 0) + stackSize
		end
	end
	if not result then
		Log.Err("Failed to find auction (%d, %s)", numItemResults, row:GetField(noSeller and "hashNoSeller" or "hash"))
		for i = 1, numItemResults do
			local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, hash, hashNoSeller = auctionScan:_GetAuctionRowFields83(isCommodity, private.tempItemKey, i)
			Log.Err("%d = %s (%d)", i, noSeller and hashNoSeller or hash)
		end
	end
	return result
end

function private.FixSellerName(seller, sellerFull)
	local realm = GetRealmName()
	if sellerFull and strjoin("-", seller, realm) ~= sellerFull then
		return sellerFull
	else
		return seller
	end
end

function private.GetItemKeyInfo(auctionScan, itemKey)
	while true do
		if auctionScan:_IsCancelled() then
			Log.Info("Stopping cancelled scan")
			return nil
		end
		local future = AuctionHouseWrapper.GetItemKeyInfo(itemKey, true)
		if future then
			local itemKeyInfo = Threading.WaitForFuture(future)
			if itemKeyInfo then
				return itemKeyInfo
			end
			Log.Warn("Timed out waiting for item key info - will retry")
		else
			Log.Err("Failed to request item key info - will retry")
			Threading.Sleep(0.5)
		end
	end
end

function private.SendSearchQuery83(itemKey, auctionScan, isCommodity, sellQuery)
	-- send the query for this item
	while true do
		-- if the client doesn't have the itemKeyInfo cached, our search query will fail, so request that first
		local itemKeyInfo = private.GetItemKeyInfo(auctionScan, itemKey)
		if not itemKeyInfo then
			Log.Info("Stopping cancelled scan")
			return false
		end
		local future, delayTime = AuctionHouseWrapper.SendSearchQuery(itemKey, sellQuery)
		if future then
			if Threading.WaitForFuture(future) then
				if private.LoadFullSearchResults83(auctionScan, isCommodity, itemKey) then
					return true
				end
				Log.Err("Failed to load full results - retrying query")
			else
				Log.Warn("Retrying search query which timed-out")
			end
		elseif delayTime then
			-- try again after a delay
			Threading.Sleep(delayTime)
		else
			Log.Err("Failed to send search query - retrying")
			Threading.Sleep(0.5)
		end
	end
end

function private.LoadFullSearchResults83(auctionScan, isCommodity, itemKey)
	for i = 1, 20 do
		local numResults = nil
		local hasFullResults = nil
		if isCommodity then
			numResults = C_AuctionHouse.GetNumCommoditySearchResults(itemKey.itemID)
			hasFullResults = C_AuctionHouse.HasFullCommoditySearchResults(itemKey.itemID)
		else
			numResults = C_AuctionHouse.GetNumItemSearchResults(itemKey)
			hasFullResults = C_AuctionHouse.HasFullItemSearchResults(itemKey)
		end
		if hasFullResults then
			if i ~= 1 then
				Log.Info("Successful after %d retries (numResults=%d)", i - 1, numResults)
			end
			return true
		end
		if auctionScan:_IsCancelled() then
			Log.Info("Stopping cancelled scan")
			return false
		end
		local future = nil
		if isCommodity then
			future = AuctionHouseWrapper.RequestMoreCommoditySearchResults(itemKey.itemID)
		else
			future = AuctionHouseWrapper.RequestMoreItemSearchResults(itemKey)
		end
		if future then
			Threading.WaitForFuture(future)
		else
			Log.Err("Failed to request more results - will try again")
			Threading.Sleep(0.5)
		end
	end
	Log.Err("Failed to load full search results")
	return false
end
