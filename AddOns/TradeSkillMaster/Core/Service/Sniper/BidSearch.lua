-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BidSearch = TSM.Sniper:NewPackage("BidSearch")
local Threading = TSM.Include("Service.Threading")
local private = {
	scanThreadId = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function BidSearch.OnInitialize()
	private.scanThreadId = Threading.New("SNIPER_BID_SEARCH", private.ScanThread)
end

function BidSearch.GetScanContext()
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
			:SetSniper(false)
	else
		assert(numFilters == 1)
	end
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(itemString, _, _, itemDisplayedBid)
	if itemDisplayedBid == 0 then
		return true
	end

	local maxPrice = TSM.Operations.Sniper.GetBelowPrice(itemString)
	if not maxPrice or itemDisplayedBid > maxPrice then
		return true
	end

	return false
end

function private.MarketValueFunction(row)
	return TSM.Operations.Sniper.GetBelowPrice(row:GetField("itemString"))
end
