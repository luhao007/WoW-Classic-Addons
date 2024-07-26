-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local Scanner = LibTSMService:Init("AuctionScan.Scanner")
local ItemInfo = LibTSMService:Include("Item.ItemInfo")
local DelayTimer = LibTSMService:From("LibTSMWoW"):IncludeClassType("DelayTimer")
local AuctionHouse = LibTSMService:From("LibTSMWoW"):Include("API.AuctionHouse")
local Event = LibTSMService:From("LibTSMWoW"):Include("Service.Event")
local DefaultUI = LibTSMService:From("LibTSMWoW"):Include("UI.DefaultUI")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local FSM = LibTSMService:From("LibTSMUtil"):Include("FSM")
local Future = LibTSMService:From("LibTSMUtil"):IncludeClassType("Future")
local Log = LibTSMService:From("LibTSMUtil"):Include("Util.Log")
local private = {
	resolveSellers = nil,
	pendingFuture = nil,
	query = nil, ---@type AuctionQuery
	callback = nil,
	browseId = 1,
	browseIsNoScan = false,
	browseIndex = 1,
	browsePendingIndexes = {},
	searchRow = nil,
	useCachedData = nil,
	retryCount = 0,
	requestFuture = Future.New("AUCTION_SCANNER_FUTURE"),
	requestResult = nil,
	fsm = nil,
	retryTimer = nil,
	doneTimer = nil,
	missingItemIds = {},
}
local BROWSE_MISSING_INFO_RETRY_DELAY = 0.5
local SEARCH_NOT_READY_RETRY_DELAY = 0.1
local SEARCH_MISSING_ITEM_INFO_RETRY_DELAY = 0.1
local SEARCH_AH_NOT_READY_RETRY_DELAY = 0.5
local SEARCH_MISSING_INFO_RETRY_DELAY = 0.5
local FUTURE_FAILED_RETRY_DELAY = 0.1
local SORT_RETRY_DELAY = 0.5



-- ============================================================================
-- Module Loading
-- ============================================================================

Scanner:OnModuleLoad(function()
	private.retryTimer = DelayTimer.New("AUCTION_SCANNER_RETRY", private.RetryHandler)
	private.doneTimer = DelayTimer.New("AUCTION_SCANNER_DONE", private.RequestDoneHandler)
	private.requestFuture:SetScript("OnCleanup", function()
		private.doneTimer:Cancel()
		private.fsm:ProcessEvent("EV_CANCEL")
	end)

	if LibTSMService.IsRetail() then
		Event.Register("COMMODITY_SEARCH_RESULTS_UPDATED", function()
			private.fsm:ProcessEvent("EV_SEARCH_RESULTS_UPDATED")
		end)
		Event.Register("ITEM_SEARCH_RESULTS_UPDATED", function()
			private.fsm:ProcessEvent("EV_SEARCH_RESULTS_UPDATED")
		end)
		Event.Register("ITEM_KEY_ITEM_INFO_RECEIVED", function(_, itemId)
			private.fsm:SetLoggingEnabled(false)
			private.fsm:ProcessEvent("EV_ITEM_KEY_INFO_RECEIVED", itemId)
			private.fsm:SetLoggingEnabled(true)
		end)
	else
		Event.Register("AUCTION_ITEM_LIST_UPDATE", function()
			private.fsm:SetLoggingEnabled(false)
			private.fsm:ProcessEvent("EV_BROWSE_RESULTS_UPDATED")
			private.fsm:SetLoggingEnabled(true)
		end)
	end

	private.fsm = FSM.New("AUCTION_SCANNER_FSM")
		:AddState(FSM.NewState("ST_INIT")
			:SetOnEnter(function()
				private.query = nil
				private.resolveSellers = nil
				private.useCachedData = nil
				private.searchRow = nil
				private.callback = nil
				private.retryCount = 0
				private.retryTimer:Cancel()
				if private.pendingFuture then
					private.pendingFuture:Cancel()
					private.pendingFuture = nil
				end
			end)
			:AddTransition("ST_BROWSE_SORT")
			:AddTransition("ST_BROWSE_CHECKING")
			:AddTransition("ST_SEARCH_GET_KEY")
			:AddEvent("EV_START_BROWSE", function(_, query, resolveSellers, callback)
				assert(not private.query)
				private.query = query
				private.resolveSellers = resolveSellers
				private.browseId = private.browseId + 1
				private.browseIsNoScan = false
				private.callback = callback
				return "ST_BROWSE_SORT"
			end)
			:AddEvent("EV_START_BROWSE_NO_SCAN", function(_, query, itemKeys, callback)
				assert(LibTSMService.IsRetail())
				assert(not private.query)
				private.query = query
				private.browseId = private.browseId + 1
				private.browseIsNoScan = true
				private.callback = callback
				for _, itemKey in ipairs(itemKeys) do
					local baseItemString = ItemString.GetBaseFromItemKey(itemKey)
					private.query:_ProcessBrowseResult(baseItemString, itemKey)
				end
				return "ST_BROWSE_CHECKING"
			end)
			:AddEvent("EV_START_SEARCH", function(_, query, resolveSellers, useCachedData, searchRow, callback)
				assert(LibTSMService.IsRetail())
				assert(not private.query)
				private.query = query
				private.resolveSellers = resolveSellers
				private.useCachedData = useCachedData
				private.searchRow = searchRow
				private.callback = callback
				private.searchRow:SearchReset()
				return "ST_SEARCH_GET_KEY"
			end)
		)
		:AddState(FSM.NewState("ST_BROWSE_SORT")
			:SetOnEnter(function()
				if not private.query:_SetSort() then
					private.retryTimer:RunForTime(SORT_RETRY_DELAY)
					return
				end
				return "ST_BROWSE_SEND"
			end)
			:AddTransition("ST_BROWSE_SORT")
			:AddTransition("ST_BROWSE_SEND")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_RETRY", "ST_BROWSE_SORT")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_BROWSE_SEND")
			:SetOnEnter(function()
				private.HandleAuctionHouseWrapperResult(private.query:_SendWowQuery())
			end)
			:AddTransition("ST_BROWSE_SEND")
			:AddTransition("ST_BROWSE_CHECKING")
			:AddTransition("ST_CANCELING")
			:AddEvent("EV_FUTURE_SUCCESS", function()
				if LibTSMService.IsRetail() then
					for _, result in ipairs(AuctionHouse.GetBrowseResults()) do
						local baseItemString = ItemString.GetBaseFromItemKey(result.itemKey)
						private.query:_ProcessBrowseResult(baseItemString, result.itemKey, result.minPrice, result.totalQuantity)
					end
				else
					private.browseIndex = 1
					wipe(private.browsePendingIndexes)
				end
				return "ST_BROWSE_CHECKING"
			end)
			:AddEventTransition("EV_RETRY", "ST_BROWSE_SEND")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_BROWSE_CHECKING")
			:SetOnEnter(function()
				if not private.query:_BrowseIsPageValid() then
					-- This page isn't valid, so go to the next page
					return "ST_BROWSE_REQUEST_MORE"
				elseif not private.CheckBrowseResults() then
					-- Results aren't valid yet, so check again
					private.retryTimer:RunForTime(BROWSE_MISSING_INFO_RETRY_DELAY)
					return
				end
				-- We're done with this set of browse results
				if private.callback then
					private.callback(private.query)
				end
				if private.browseIsNoScan or private.query:_BrowseIsDone() then
					-- We're done
					return "ST_BROWSE_DONE"
				else
					-- move on to the next page
					return "ST_BROWSE_REQUEST_MORE"
				end
			end)
			:AddTransition("ST_BROWSE_CHECKING")
			:AddTransition("ST_BROWSE_DONE")
			:AddTransition("ST_BROWSE_REQUEST_MORE")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_RETRY", "ST_BROWSE_CHECKING")
			:AddEventTransition("EV_BROWSE_RESULTS_UPDATED", "ST_BROWSE_CHECKING")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
			:AddEvent("EV_ITEM_KEY_INFO_RECEIVED", function(_, itemId)
				if not next(private.missingItemIds) then
					return
				end
				private.missingItemIds[itemId] = nil
				if not next(private.missingItemIds) then
					private.retryTimer:Cancel()
					return "ST_BROWSE_CHECKING"
				end
			end)
		)
		:AddState(FSM.NewState("ST_BROWSE_REQUEST_MORE")
			:SetOnEnter(function(_, isRetry)
				if private.query:_BrowseIsDone(isRetry) then
					return "ST_BROWSE_CHECKING"
				else
					private.HandleAuctionHouseWrapperResult(private.query:_BrowseRequestMore(isRetry))
				end
			end)
			:AddTransition("ST_BROWSE_REQUEST_MORE")
			:AddTransition("ST_BROWSE_CHECKING")
			:AddTransition("ST_CANCELING")
			:AddEvent("EV_FUTURE_SUCCESS", function(_, ...)
				if LibTSMService.IsRetail() then
					local newResults = ...
					for _, result in ipairs(newResults) do
						local baseItemString = ItemString.GetBaseFromItemKey(result.itemKey)
						private.query:_ProcessBrowseResult(baseItemString, result.itemKey, result.minPrice, result.totalQuantity)
					end
				else
					private.browseIndex = 1
					wipe(private.browsePendingIndexes)
				end
				return "ST_BROWSE_CHECKING"
			end)
			:AddEvent("EV_RETRY", function()
				return "ST_BROWSE_REQUEST_MORE", true
			end)
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_BROWSE_DONE")
			:SetOnEnter(function()
				private.HandleRequestDone(true)
				return "ST_INIT"
			end)
			:AddTransition("ST_INIT")
		)
		:AddState(FSM.NewState("ST_SEARCH_GET_KEY")
			:SetOnEnter(function()
				assert(LibTSMService.IsRetail())
				if not private.searchRow:SearchIsReady() then
					private.retryTimer:RunForTime(SEARCH_NOT_READY_RETRY_DELAY)
					return
				end
				return "ST_SEARCH_SEND"
			end)
			:AddTransition("ST_SEARCH_GET_KEY")
			:AddTransition("ST_SEARCH_SEND")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_FUTURE_SUCCESS", "ST_SEARCH_SEND")
			:AddEventTransition("EV_RETRY", "ST_SEARCH_GET_KEY")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_SEARCH_SEND")
			:SetOnEnter(function()
				assert(LibTSMService.IsRetail())
				if not DefaultUI.IsAuctionHouseVisible() then
					return "ST_CANCELING"
				end
				if private.useCachedData and private.searchRow:HasCachedSearchData() then
					return "ST_SEARCH_REQUEST_MORE"
				end
				local future, delayTime = private.searchRow:SearchSend()
				if future then
					private.HandleAuctionHouseWrapperResult(future)
				else
					if not delayTime then
						Log.Err("Failed to send search query - retrying")
						delayTime = SEARCH_AH_NOT_READY_RETRY_DELAY
					end
					-- Try again after a delay
					private.retryTimer:RunForTime(delayTime)
				end
			end)
			:AddTransition("ST_SEARCH_SEND")
			:AddTransition("ST_SEARCH_REQUEST_MORE")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_FUTURE_SUCCESS", "ST_SEARCH_REQUEST_MORE")
			:AddEventTransition("EV_RETRY", "ST_SEARCH_SEND")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_SEARCH_REQUEST_MORE")
			:SetOnEnter(function()
				assert(LibTSMService.IsRetail())
				local baseItemString = private.searchRow:GetBaseItemString()
				-- Get if the item is a commodity or not
				local isCommodity = ItemInfo.IsCommodity(baseItemString)
				if isCommodity == nil then
					private.retryTimer:RunForTime(SEARCH_MISSING_ITEM_INFO_RETRY_DELAY)
					return
				end

				local isDone, future = private.searchRow:SearchCheckStatus()
				if isDone then
					return "ST_SEARCH_CHECKING"
				elseif future then
					private.HandleAuctionHouseWrapperResult(future)
				else
					private.retryTimer:RunForTime(SEARCH_AH_NOT_READY_RETRY_DELAY)
				end
			end)
			:AddTransition("ST_SEARCH_SEND")
			:AddTransition("ST_SEARCH_CHECKING")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_FUTURE_SUCCESS", "ST_SEARCH_CHECKING")
			:AddEventTransition("EV_RETRY", "ST_SEARCH_SEND")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_SEARCH_CHECKING")
			:SetOnEnter(function()
				assert(LibTSMService.IsRetail())
				private.retryTimer:Cancel()
				private.searchRow:PopulateSubRows(private.browseId)

				-- check if all the sub rows have their data
				local missingInfo = false
				for _, subRow in private.searchRow:SubRowIterator(true) do
					if not subRow:HasRawData() or not subRow:HasItemString() then
						missingInfo = true
					elseif private.resolveSellers and not subRow:HasOwners() and not private.query:_IsFiltered(subRow, true) then
						-- Waiting for owner info
						-- Currently can't rely on owner info as of 9.2.7, so limit the retries for it
						if not LibTSMService.IsRetail() or private.retryCount <= 10 then
							missingInfo = true
						end
					end
				end

				if missingInfo and private.retryCount >= 100 then
					-- Out of retries, so give up
					return "ST_SEARCH_DONE", false
				elseif missingInfo then
					-- We'll try again
					private.retryCount = private.retryCount + 1
					private.retryTimer:RunForTime(SEARCH_MISSING_INFO_RETRY_DELAY)
					return
				end

				-- Filter the sub rows we don't care about
				private.searchRow:FilterSubRows(private.query)

				if private.callback then
					private.callback(private.query, private.searchRow)
				end
				if private.searchRow:SearchNext() then
					-- there is more to search
					return "ST_SEARCH_GET_KEY"
				else
					-- scanned everything
					return "ST_SEARCH_DONE", true
				end
			end)
			:AddTransition("ST_SEARCH_GET_KEY")
			:AddTransition("ST_SEARCH_CHECKING")
			:AddTransition("ST_SEARCH_DONE")
			:AddTransition("ST_CANCELING")
			:AddEventTransition("EV_RETRY", "ST_SEARCH_CHECKING")
			:AddEventTransition("EV_SEARCH_RESULTS_UPDATED", "ST_SEARCH_CHECKING")
			:AddEventTransition("EV_CANCEL", "ST_CANCELING")
		)
		:AddState(FSM.NewState("ST_SEARCH_DONE")
			:SetOnEnter(function(_, result)
				assert(LibTSMService.IsRetail())
				private.HandleRequestDone(result)
				return "ST_INIT"
			end)
			:AddTransition("ST_INIT")
		)
		:AddState(FSM.NewState("ST_CANCELING")
			:SetOnEnter(function()
				private.doneTimer:Cancel()
				return "ST_INIT"
			end)
			:AddTransition("ST_INIT")
		)
		:Init("ST_INIT", nil)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Starts a browse scan.
---@param query AuctionQuery The query
---@param resolveSellers boolean Whether or not to resolve seller names
---@param callback fun(query: AuctionQuery, row: AuctionRow) A function to call with results
---@return Future
function Scanner.Browse(query, resolveSellers, callback)
	private.requestFuture:Start()
	private.fsm:ProcessEvent("EV_START_BROWSE", query, resolveSellers, callback)
	return private.requestFuture
end

---Starts a browse scan without issuing a new query to the game.
---@param query AuctionQuery The query
---@param itemKeys ItemKey[] The item keys to browse for
---@param callback fun(query: AuctionQuery, row: AuctionRow) A function to call with results
---@return Future
function Scanner.BrowseNoScan(query, itemKeys, callback)
	assert(LibTSMService.IsRetail())
	private.requestFuture:Start()
	private.fsm:ProcessEvent("EV_START_BROWSE_NO_SCAN", query, itemKeys, callback)
	return private.requestFuture
end

---Starts a search.
---@param query AuctionQuery The query
---@param resolveSellers boolean Whether or not to resolve seller names
---@param useCachedData boolean Use cached data
---@param browseRow AuctionRow The auction row to search for
---@param callback fun(query: AuctionQuery, row: AuctionRow) A function to call with results
---@return Future
function Scanner.Search(query, resolveSellers, useCachedData, browseRow, callback)
	assert(LibTSMService.IsRetail())
	private.requestFuture:Start()
	private.fsm:ProcessEvent("EV_START_SEARCH", query, resolveSellers, useCachedData, browseRow, callback)
	return private.requestFuture
end

---Cancels any in progress scan.
function Scanner.Cancel()
	private.requestFuture:Done(false)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PendingFutureDoneHandler()
	local result = private.pendingFuture:GetValue()
	private.pendingFuture = nil
	if result then
		private.fsm:ProcessEvent("EV_FUTURE_SUCCESS", result)
	else
		private.retryTimer:RunForTime(FUTURE_FAILED_RETRY_DELAY)
	end
end

function private.RetryHandler()
	private.fsm:SetLoggingEnabled(false)
	private.fsm:ProcessEvent("EV_RETRY")
	private.fsm:SetLoggingEnabled(true)
end

function private.RequestDoneHandler()
	local result = private.requestResult
	private.requestResult = nil
	private.requestFuture:Done(result)
end

function private.HandleAuctionHouseWrapperResult(future)
	if future then
		private.pendingFuture = future
		private.pendingFuture:SetScript("OnDone", private.PendingFutureDoneHandler)
	else
		private.retryTimer:RunForTime(FUTURE_FAILED_RETRY_DELAY)
	end
end

function private.HandleRequestDone(result)
	private.requestResult = result
	-- Delay a bit so that we complete our current FSM transition
	private.doneTimer:RunForTime(0)
end

function private.CheckBrowseResults()
	if not LibTSMService.IsRetail() then
		-- Process as many auctions as we can
		local numAuctions = AuctionHouse.GetNumAuctions()
		for i = #private.browsePendingIndexes, 1, -1 do
			local index = private.browsePendingIndexes[i]
			if private.ProcessBrowseResultClassic(index) then
				tremove(private.browsePendingIndexes, i)
			end
		end
		local index = private.browseIndex
		while index <= numAuctions and #private.browsePendingIndexes < 50 do
			if not private.ProcessBrowseResultClassic(index) then
				tinsert(private.browsePendingIndexes, index)
			end
			index = index + 1
		end
		private.browseIndex = index
		if private.browseIndex <= numAuctions or #private.browsePendingIndexes > 0 then
			return false
		end
	end

	-- Check if there's data still pending
	wipe(private.missingItemIds)
	if private.query:_PopulateBrowseData(private.missingItemIds) then
		return false
	end

	-- Filter the results
	local numRemoved = private.query:_FilterBrowseResults()
	if numRemoved > 0 then
		Log.Info("Removed %d results", numRemoved)
	end

	return true
end

function private.ProcessBrowseResultClassic(index)
	local rawName, itemLink, stackSize, timeLeft, buyout, seller = AuctionHouse.GetBrowseResult(index)
	local baseItemString = ItemString.GetBase(itemLink)
	if not rawName or rawName == "" or not baseItemString or not buyout or not stackSize or not timeLeft or (not seller and private.resolveSellers) then
		return false
	end
	private.query:_ProcessBrowseResult(baseItemString, itemLink)
	local row = private.query:_GetBrowseResults(baseItemString)
	-- Amazingly, GetAuctionItemLink could return nil the next time it's called (within the same frame), so pass through our itemLink
	row:PopulateSubRows(private.browseId, index, itemLink)
	local missingData = false
	for _, subRow in row:SubRowIterator() do
		if not subRow:HasRawData() or not subRow:HasItemString() then
			missingData = true
		end
	end
	return not missingData
end
