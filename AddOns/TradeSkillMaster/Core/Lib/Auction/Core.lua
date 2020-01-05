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
local Database = TSM.Include("Util.Database")
local ItemInfo = TSM.Include("Service.ItemInfo")
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

function Auction.CanBid(row)
	if row:GetField("isHighBidder") then
		return false
	elseif row:GetField("displayedBid") == row:GetField("buyout") then
		return false
	elseif TSM.IsWow83() and ItemInfo.IsCommodity(row:GetField("itemString")) then
		return false
	elseif GetMoney() < Auction.GetRequiredBidByScanResultRow(row) then
		return false
	end
	return true
end

function Auction.CanBuyout(row, db)
	local buyout = row:GetField(TSM.IsWow83() and "itemBuyout" or "buyout")
	if buyout == 0 or GetMoney() < buyout then
		return false
	elseif TSM.IsWow83() and ItemInfo.IsCommodity(row:GetField("itemString")) then
		-- make sure it's the cheapest
		local itemBuyout = db:NewQuery()
			:Equal("itemString", row:GetField("itemString"))
			:NotEqual("stackSize", Database.OtherFieldQueryParam("numOwnerItems"))
			:OrderBy("itemBuyout", true)
			:Select("itemBuyout")
			:GetFirstResultAndRelease()
		if itemBuyout ~= row:GetField("itemBuyout") then
			-- this isn't the cheapest commodity
			return false
		end
	end
	return true
end
