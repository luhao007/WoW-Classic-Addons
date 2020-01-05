-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BuyoutSearch = TSM.Sniper:NewPackage("BuyoutSearch")
local Threading = TSM.Include("Service.Threading")
local private = {
	scanThreadId = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function BuyoutSearch.OnInitialize()
	private.scanThreadId = Threading.New("SNIPER_BUYOUT_SEARCH", private.ScanThread)
end

function BuyoutSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan)
	auctionScan:SetCustomFilterFunc(private.ScanFilter)
	local numFilters = auctionScan:GetNumFilters()
	if numFilters == 0 then
		auctionScan:NewAuctionFilter()
			:SetSniper(true)
			:SetShouldScanItemFunction(private.FilterShouldScanItemFunction)
	else
		assert(numFilters == 1)
	end
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(itemString, itemBuyout)
	if itemBuyout == 0 then
		return true
	end

	local belowPrice = TSM.Operations.Sniper.GetBelowPrice(itemString)
	if itemBuyout > (belowPrice or 0) then
		return true
	end

	return false
end

function private.MarketValueFunction(row)
	return TSM.Operations.Sniper.GetBelowPrice(row:GetField("itemString"))
end

function private.FilterShouldScanItemFunction(filter, baseItemString, minPrice)
	if minPrice <= (TSM.Operations.Sniper.GetBelowPrice(baseItemString) or 0) then
		return true
	end
	local result = false
	for _, itemString in TSM.Groups.ItemIterator(nil, baseItemString) do
		if minPrice <= (TSM.Operations.Sniper.GetBelowPrice(itemString) or 0) then
			result = true
		end
	end
	return result
end
