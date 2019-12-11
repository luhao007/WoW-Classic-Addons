-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

TSMAPI_FOUR.Auction = {}
local _, TSM = ...
local Auction = TSM:NewPackage("Auction")
local ObjectPool = TSM.Include("Util.ObjectPool")
Auction.classes = {}
local private = {
	auctionFilters = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auction.OnInitialize()
	private.auctionFilters = ObjectPool.New("AUCTION_FILTERS", Auction.classes.AuctionFilter, 1)
end

function Auction.NewAuctionFilter()
	return private.auctionFilters:Get()
end

function Auction.RecycleAuctionFilter(filter)
	private.auctionFilters:Recycle(filter)
end

function Auction.GetRequiredBidByScanResultRow(row)
	local bid, minBid, minIncrement = row:GetFields("bid", "minBid", "minIncrement")
	return bid == 0 and minBid or (bid + minIncrement)
end
