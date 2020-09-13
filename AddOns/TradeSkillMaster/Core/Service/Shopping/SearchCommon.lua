-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SearchCommon = TSM.Shopping:NewPackage("SearchCommon")
local Delay = TSM.Include("Util.Delay")
local Threading = TSM.Include("Service.Threading")
local private = {
	findThreadId = nil,
	callback = nil,
	isRunning = false,
	pendingStartArgs = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function SearchCommon.OnInitialize()
	-- initialize threads
	private.findThreadId = Threading.New("FIND_SEARCH", private.FindThread)
	Threading.SetCallback(private.findThreadId, private.ThreadCallback)
end

function SearchCommon.StartFindAuction(auctionScan, auction, callback, noSeller)
	wipe(private.pendingStartArgs)
	private.pendingStartArgs.auctionScan = auctionScan
	private.pendingStartArgs.auction = auction
	private.pendingStartArgs.callback = callback
	private.pendingStartArgs.noSeller = noSeller
	Delay.AfterTime("SEARCH_COMMON_THREAD_START", 0, private.StartThread)
end

function SearchCommon.StopFindAuction(noKill)
	wipe(private.pendingStartArgs)
	private.callback = nil
	if not noKill then
		Threading.Kill(private.findThreadId)
	end
end



-- ============================================================================
-- Find Thread
-- ============================================================================


function private.FindThread(auctionScan, row, noSeller)
	return auctionScan:FindAuctionThreaded(row, noSeller)
end

function private.StartThread()
	if not private.pendingStartArgs.auctionScan then
		return
	end
	if private.isRunning then
		Delay.AfterTime("SEARCH_COMMON_THREAD_START", 0.1, private.StartThread)
		return
	end
	private.isRunning = true
	private.callback = private.pendingStartArgs.callback
	Threading.Start(private.findThreadId, private.pendingStartArgs.auctionScan, private.pendingStartArgs.auction, private.pendingStartArgs.noSeller)
	wipe(private.pendingStartArgs)
end

function private.ThreadCallback(...)
	private.isRunning = false
	if private.callback then
		private.callback(...)
	end
end
