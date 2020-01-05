-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SearchCommon = TSM.Shopping:NewPackage("SearchCommon")
local Threading = TSM.Include("Service.Threading")
local private = {
	findThreadId = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function SearchCommon.OnInitialize()
	-- initialize threads
	private.findThreadId = Threading.New("FIND_SEARCH", private.FindThread)
end

function SearchCommon.StartFindAuction(auctionScan, auction, callback, noSeller)
	Threading.SetCallback(private.findThreadId, callback)
	Threading.Start(private.findThreadId, auctionScan, auction, noSeller)
end

function SearchCommon.StopFindAuction()
	Threading.SetCallback(private.findThreadId, nil)
	Threading.Kill(private.findThreadId)
end



-- ============================================================================
-- Find Thread
-- ============================================================================

function private.FindThread(auctionScan, row, noSeller)
	return auctionScan:FindAuctionThreaded(row, noSeller)
end
