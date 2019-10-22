-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local GroupSearch = TSM.Shopping:NewPackage("GroupSearch")
local L = TSM.L
local private = {
	groups = {},
	itemList = {},
	maxQuantity = {},
	scanThreadId = nil,
	seenMaxPrice = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function GroupSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = TSMAPI_FOUR.Thread.New("GROUP_SEARCH", private.ScanThread)
end

function GroupSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, groupList)
	auctionScan:SetCustomFilterFunc(private.ScanFilter)
	wipe(private.seenMaxPrice)

	-- create the list of items, and add filters for them
	wipe(private.itemList)
	wipe(private.maxQuantity)
	for _, groupPath in ipairs(groupList) do
		private.groups[groupPath] = true
		for _, itemString in TSM.Groups.ItemIterator(groupPath) do
			local isValid, maxQuantityOrErr = TSM.Operations.Shopping.ValidAndGetRestockQuantity(itemString)
			if isValid then
				private.maxQuantity[itemString] = maxQuantityOrErr
				tinsert(private.itemList, itemString)
			elseif maxQuantityOrErr then
				TSM:Printf(L["Invalid custom price source for %s. %s"], TSMAPI_FOUR.Item.GetLink(itemString), maxQuantityOrErr)
			end
		end
	end
	if #private.itemList == 0 then
		return false
	end
	auctionScan:AddItemListFiltersThreaded(private.itemList, private.maxQuantity)
	for _, filter in auctionScan:FilterIterator() do
		filter:SetIsDoneFunction(private.FilterIsDoneFunction)
	end

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(itemString, itemBuyout, stackSize)
	if itemBuyout == 0 then
		return true
	end

	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath or not private.groups[groupPath] then
		return true
	end

	local isFiltered, isAboveMaxPrice = TSM.Operations.Shopping.IsFiltered(itemString, stackSize, itemBuyout)
	if isAboveMaxPrice then
		private.seenMaxPrice[itemString] = true
	end
	return isFiltered
end

function private.FilterIsDoneFunction(filter)
	for _, itemString in ipairs(filter:GetItems()) do
		if TSM.Operations.Shopping.ShouldShowAboveMaxPrice(itemString) then
			-- need to scan all the auctions
			return false
		elseif not private.seenMaxPrice[itemString] then
			-- need to keep scanning until we reach the max price
			return false
		end
	end
	return true
end

function private.MarketValueFunction(row)
	return TSM.Operations.Shopping.GetMaxPrice(row:GetField("itemString"))
end
