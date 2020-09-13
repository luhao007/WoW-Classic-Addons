-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Auction scanning functions.
-- @module AuctionScan

local _, TSM = ...
local AuctionScan = TSM.Init("Service.AuctionScan")
local ScanManager = TSM.Include("Service.AuctionScanClasses.ScanManager")



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionScan.GetManager()
	return ScanManager.Get()
end

function AuctionScan.CanBid(subRow)
	if not subRow:IsSubRow() then
		return false
	end
	local _, _, _, isHighBidder = subRow:GetBidInfo()
	local displayedBid = subRow:GetDisplayedBids()
	local buyout = subRow:GetBuyouts()
	if isHighBidder then
		return false
	elseif displayedBid == buyout then
		return false
	elseif not TSM.IsWowClassic() and subRow:IsCommodity() then
		return false
	elseif GetMoney() < subRow:GetRequiredBid() then
		return false
	end
	return true
end

function AuctionScan.CanBuyout(subRow, auctionScan)
	if not subRow:IsSubRow() then
		return false
	end
	local buyout, itemBuyout = subRow:GetBuyouts()
	if not TSM.IsWowClassic() then
		buyout = itemBuyout
	end
	local itemString = subRow:GetItemString()
	if buyout == 0 or GetMoney() < buyout then
		return false
	elseif not TSM.IsWowClassic() and subRow:IsCommodity() then
		-- make sure it's the cheapest
		local isCheapest = false
		for _, query in auctionScan:QueryIterator() do
			isCheapest = isCheapest or subRow == query:GetCheapestSubRow(itemString)
		end
		if not isCheapest then
			return false
		end
	end
	return true
end
