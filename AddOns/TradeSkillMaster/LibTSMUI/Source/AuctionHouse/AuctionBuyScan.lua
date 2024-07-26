-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUI = select(2, ...).LibTSMUI
local AuctionBuyScan = LibTSMUI:DefineClassType("AuctionBuyScan")
local L = LibTSMUI.Locale.GetTable()
local UIElements = LibTSMUI:Include("Util.UIElements")
local AuctionPostContext = LibTSMUI:From("LibTSMService"):IncludeClassType("AuctionPostContext")
local AuctionScan = LibTSMUI:From("LibTSMService"):Include("AuctionScan")
local ChatMessage = LibTSMUI:From("LibTSMService"):Include("UI.ChatMessage")
local BagTracking = LibTSMUI:From("LibTSMService"):Include("Inventory.BagTracking")
local Mail = LibTSMUI:From("LibTSMService"):Include("Mail")
local TextureAtlas = LibTSMUI:From("LibTSMService"):Include("UI.TextureAtlas")
local AuctionHouse = LibTSMUI:From("LibTSMWoW"):Include("API.AuctionHouse")
local AuctionHouseWrapper = LibTSMUI:From("LibTSMWoW"):Include("API.AuctionHouseWrapper")
local DelayTimer = LibTSMUI:From("LibTSMWoW"):IncludeClassType("DelayTimer")
local DefaultUI = LibTSMUI:From("LibTSMWoW"):Include("UI.DefaultUI")
local ItemString = LibTSMUI:From("LibTSMTypes"):Include("Item.ItemString")
local EnumType = LibTSMUI:From("LibTSMUtil"):Include("BaseType.EnumType")
local Reactive = LibTSMUI:From("LibTSMUtil"):Include("Reactive")
local UIManager = LibTSMUI:From("LibTSMUtil"):IncludeClassType("UIManager")
local Math = LibTSMUI:From("LibTSMUtil"):Include("Lua.Math")
local Log = LibTSMUI:From("LibTSMUtil"):Include("Util.Log")
local private = {
	confirmationVisible = false,
}
local SCAN_TYPE = EnumType.New("AUCTION_BUY_SCAN_TYPE", {
	BROWSE = EnumType.NewValue(),
	SNIPER = EnumType.NewValue(),
})
local RETAIL_FIND_RESULT_PLACEHOLDER = {}
local COPPER_PER_SILVER = 100
local STATE_SCHEMA = Reactive.CreateStateSchema("AUCTION_BUY_SCAN_STATE")
	:AddOptionalEnumField("scanType", SCAN_TYPE)
	:AddStringField("scanTypeName", "")
	:AddOptionalTableField("bottomFrame")
	:AddBooleanField("canSendAuctionQuery", true)
	:AddOptionalTableField("auctionScrollTable")
	:AddNumberField("scanProgress", 0)
	:AddOptionalNumberField("scanNumItems")
	:AddOptionalBooleanField("scanIsPaused")
	:AddOptionalBooleanField("pausePending")
	:AddBooleanField("selectionChanging", false)
	:AddOptionalTableField("selectedAuction")
	:AddBooleanField("selectionCanBid", false)
	:AddBooleanField("selectionCanBuy", false)
	:AddBooleanField("selectionCanCancel", false)
	:AddBooleanField("selectionCanPost", false)
	:AddOptionalTableField("auctionScan")
	:AddOptionalTableField("searchContext")
	:AddOptionalStringField("findHash")
	:AddOptionalTableField("findResult")
	:AddBooleanField("findHashIsSelection", false)
	:AddBooleanField("isSearchingForSelection", false)
	:AddNumberField("numFound", 0)
	:AddNumberField("maxQuantity", 0)
	:AddNumberField("defaultBuyQuantity", 0)
	:AddNumberField("lastBuyQuantity", 0)
	:AddOptionalNumberField("lastBuyIndex")
	:AddOptionalTableField("pendingFuture")
	:AddBooleanField("isConfirming", false)
	:AddNumberField("numCanBuy", 0)
	:AddNumberField("numBought", 0)
	:AddNumberField("numBid", 0)
	:AddNumberField("numBidOrBought", 0)
	:AddNumberField("numConfirmed", 0)
	:AddBooleanField("canPost", false)
	:AddBooleanField("canCancel", false)
	:AddBooleanField("cancelShown", false)
	:AddBooleanField("postDialogShown", false)
	:AddNumberField("postDuration", 2)
	:Commit()



-- ============================================================================
-- Static Class Functions
-- ============================================================================

---Creates a new auction buy scan object for a shopping scan.
---@param scanTypeName string The name of the type of scan to use for locking
---@param isPlayerFunc fun(characterName: string, includeAlts: boolean): boolean Function which checks if a character belongs to the player
---@param alertThresholdFunc fun(itemString: string): number Function to get the confirmation alert threshold for an item
---@return AuctionBuyScan
function AuctionBuyScan.__static.NewBrose(scanTypeName, isPlayerFunc, alertThresholdFunc)
	return AuctionBuyScan(SCAN_TYPE.BROWSE, scanTypeName, isPlayerFunc, alertThresholdFunc)
end

---Creates a new auction buy scan object for a sniper scan.
---@param scanTypeName string The name of the type of scan to use for locking
---@param isPlayerFunc fun(characterName: string, includeAlts: boolean): boolean Function which checks if a character belongs to the player
---@return AuctionBuyScan
function AuctionBuyScan.__static.NewSniper(scanTypeName, isPlayerFunc)
	return AuctionBuyScan(SCAN_TYPE.SNIPER, scanTypeName, isPlayerFunc)
end



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AuctionBuyScan.__private:__init(scanType, scanTypeName, isPlayerFunc, alertThresholdFunc)
	self._isPlayerFunc = isPlayerFunc ---@type fun(characterName: string, includeAlts: boolean): boolean
	self._alertThresholdFunc = alertThresholdFunc

	local state = STATE_SCHEMA:CreateState()
	state.scanType = scanType
	state.scanTypeName = scanTypeName
	self._state = state
	self._manager = UIManager.Create("AUCTION_BUY_"..scanTypeName, state, self:__closure("_ActionHandler"))
		:SuppressActionLog("ACTION_SCAN_PROGRESS_UPDATED")
		:SuppressActionLog("ACTION_BAG_QUANTITY_UPDATED")
		:SuppressActionLog("ACTION_AUCTION_ID_UPDATED")
	self._selectionPostContext = AuctionPostContext.New()
	self._selectionDelayTimer = DelayTimer.New("AUCTION_BUY_SCAN_SELECTION_DELAY_"..scanTypeName, self._manager:CallbackToProcessAction("ACTION_AUCTION_SELECTION_CHANGED_DELAYED"))
	self._restartDelayTimer = DelayTimer.New("AUCTION_BUY_SCAN_RESTART_DELAY_"..scanTypeName, self._manager:CallbackToProcessAction("ACTION_RESTART_DELAYED"))

	BagTracking.RegisterQuantityCallback(self._manager:CallbackToProcessAction("ACTION_BAG_QUANTITY_UPDATED"))
	AuctionHouseWrapper.RegisterAuctionIdUpdateCallback(self._manager:CallbackToProcessAction("ACTION_AUCTION_ID_UPDATED"))
	if not LibTSMUI.IsRetail() then
		AuctionHouseWrapper.RegisterCanSendAuctionQueryCallback(function(canSendAuctionQuery)
			state.canSendAuctionQuery = canSendAuctionQuery
		end)
	end
	DefaultUI.RegisterAuctionHouseVisibleCallback(self._manager:CallbackToProcessAction("ACTION_END_SEARCH"), false)

	self._manager:SetStateFromExpression("numBidOrBought", [[numBid + numBought]])
	self._manager:SetStateFromExpression("isSearchingForSelection", [[selectedAuction ~= nil and not findResult]])
	self._manager:SetStateFromExpression("numCanBuy", [[not findHashIsSelection and 0 or (numFound - numBidOrBought)]])
	self._manager:SetStateFromExpression("isConfirming", [[numConfirmed < numBidOrBought]])
	self._manager:SetStateFromExpression("canPost", [[auctionScan ~= nil and not pausePending and not isSearchingForSelection and selectionCanPost and not isConfirming and (selectedAuction ~= nil or (not scanIsPaused and scanProgress == 1)) or false]])
	self._manager:SetStateFromExpression("canCancel", [[auctionScan ~= nil and pausePending == nil and not isSearchingForSelection and selectionCanCancel]])
	self._manager:SetStateFromExpression("cancelShown", [[canCancel and not pendingFuture and canSendAuctionQuery]])

	self._manager:ProcessActionFromPublisher("ACTION_HIDE_POST_DIALOG", state:PublisherForKeyChange("canPost")
		:IgnoreIfNotEquals(false)
	)
	self._manager:ProcessActionFromPublisher("ACTION_UPDATE_CANCEL_BUTTON", state:PublisherForKeyChange("cancelShown"))
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

---Creates the buttom UI frame element for a browse scan with the state hooked up to the AuctionBuyScan object.
---@return Frame
function AuctionBuyScan:CreateBottomUIFrameForBrowse()
	local bottomFrame = UIElements.New("Frame", "bottom")
		:SetLayout("HORIZONTAL")
		:SetHeight(40)
		:SetPadding(8)
		:SetBackgroundColor("PRIMARY_BG_ALT")
		:SetManager(self._manager)
		:AddChild(UIElements.New("ActionButton", "pauseResumeBtn")
			:SetSize(24, 24)
			:SetMargin(0, 8, 0, 0)
			:SetText(TextureAtlas.GetTextureLink("iconPack.18x18/PlayPause"))
			:SetDisabledPublisher(self._state:PublisherForExpression([[(not scanIsPaused and scanProgress == 1) or pausePending ~= nil]]))
			:SetHighlightLockedPublisher(self._state:PublisherForExpression([[pausePending ~= nil]]))
			:SetAction("OnClick", "ACTION_PAUSE_RESUME_CLICKED")
		)
		:AddChild(UIElements.New("ProgressBar", "progressBar")
			:SetHeight(24)
			:SetMargin(0, 8, 0, 0)
			:SetProgressPublisher(self._state:PublisherForExpression([[((not auctionScan or isSearchingForSelection) and 0) or (selectedAuction and numConfirmed / (numFound > 0 and numFound or 1)) or (scanProgress == 1 and 0) or scanProgress]]))
			:SetTextPublisher(self._state:PublisherForKeys("auctionScan", "isSearchingForSelection", "pausePending", "selectedAuction", "isConfirming", "numCanBuy", "numBidOrBought", "numFound", "numConfirmed", "selectionCanBuy", "pendingFuture", "canPost", "canCancel", "scanIsPaused", "scanProgress", "scanNumItems")
				:MapWithFunction(private.StateToProgressText)
			)
			:SetProgressIconHiddenPublisher(self._state:PublisherForExpression([[auctionScan ~= nil and not pausePending and not isSearchingForSelection and not isConfirming and not pendingFuture and (selectedAuction ~= nil or scanProgress == 1 or scanIsPaused) or false]]))
		)
		:AddChild(UIElements.New("ActionButton", "postBtn")
			:SetSize(107, 24)
			:SetMargin(0, 8, 0, 0)
			:SetText(L["Post"])
			:SetDisabledPublisher(self._state:PublisherForExpression([[not canPost or pendingFuture ~= nil or not canSendAuctionQuery]]))
			:SetAction("OnClick", "ACTION_POST_AUCTION")
		)
		:AddChild(UIElements.New("VerticalLine", "line")
			:SetHeight(24)
			:SetMargin(0, 8, 0, 0)
		)
		:AddChild(UIElements.New("ActionButton", "bidBtn")
			:SetSize(107, 24)
			:SetMargin(0, 8, 0, 0)
			:SetText(BID)
			:SetDisabledPublisher(self._state:PublisherForExpression([[not auctionScan or pausePending ~= nil or isSearchingForSelection or not selectionCanBid or pendingFuture ~= nil or (isConfirming and numCanBuy == 0) or not canSendAuctionQuery]]))
			:SetAction("OnClick", "ACTION_BID_AUCTION")
		)
		:AddChild(UIElements.NewNamed("ActionButton", "buyoutBtn", "TSMShoppingBuyoutBtn")
			:SetSize(107, 24)
			:SetText(BUYOUT)
			:DisableClickCooldown(true)
			:SetDisabledPublisher(self._state:PublisherForExpression([[not auctionScan or pausePending ~= nil or isSearchingForSelection or not selectionCanBuy or pendingFuture ~= nil or (isConfirming and numCanBuy == 0) or not canSendAuctionQuery]]))
			:SetAction("OnClick", "ACTION_BUY_AUCTION")
		)
		:AddChild(UIElements.New("ActionButton", "cancelBtn")
			:SetSize(107, 24)
			:SetText(CANCEL)
			:DisableClickCooldown(true)
			:SetDisabledPublisher(self._state:PublisherForKeyChange("cancelShown"):InvertBoolean())
			:SetAction("OnClick", "ACTION_CANCEL_AUCTION")
		)
		:SetScript("OnUpdate", self._manager:CallbackToProcessAction("ACTION_BOTTOM_FRAME_SHOWN"))
		:SetScript("OnHide", self._manager:CallbackToProcessAction("ACTION_BOTTOM_FRAME_HIDDEN"))
	assert(not self._state.bottomFrame)
	self._state.bottomFrame = bottomFrame
	return bottomFrame
end

---Creates the buttom UI frame element with the state hooked up to the AuctionBuyScan object.
---@param showBuyoutButton boolean Whether to show the buyout button (vs. the bid button)
---@return Frame
function AuctionBuyScan:CreateBottomUIFrameForSniper(showBuyoutButton)
	local bottomFrame = UIElements.New("Frame", "bottom")
		:SetLayout("HORIZONTAL")
		:SetHeight(40)
		:SetPadding(8)
		:SetBackgroundColor("PRIMARY_BG_ALT")
		:SetManager(self._manager)
		:AddChild(UIElements.New("ActionButton", "pauseResumeBtn")
			:SetSize(24, 24)
			:SetMargin(0, 8, 0, 0)
			:SetText(TextureAtlas.GetTextureLink("iconPack.18x18/PlayPause"))
			:SetHighlightLockedPublisher(self._state:PublisherForExpression([[pausePending ~= nil]]))
			:SetAction("OnClick", "ACTION_PAUSE_RESUME_CLICKED")
		)
		:AddChild(UIElements.New("ProgressBar", "progressBar")
			:SetHeight(24)
			:SetMargin(0, 8, 0, 0)
			:SetProgressPublisher(self._state:PublisherForExpression([[((not auctionScan or isSearchingForSelection) and 0) or (selectedAuction and numConfirmed / (numFound > 0 and numFound or 1)) or (scanProgress == 1 and 0) or scanProgress]]))
			:SetTextPublisher(self._state:PublisherForKeys("auctionScan", "isSearchingForSelection", "pausePending", "selectedAuction", "isConfirming", "numCanBuy", "numBidOrBought", "numFound", "numConfirmed", "selectionCanBuy", "pendingFuture", "canPost", "canCancel", "scanIsPaused", "scanProgress", "scanNumItems")
				:MapWithFunction(private.StateToProgressText)
			)
			:SetProgressIconHiddenPublisher(self._state:PublisherForExpression([[auctionScan ~= nil and not pausePending and not isSearchingForSelection and not isConfirming and not pendingFuture and (selectedAuction ~= nil or scanProgress == 1 or scanIsPaused) or false]]))
		)
		:AddChild(UIElements.NewNamed("ActionButton", showBuyoutButton and "buyoutBtn" or "bidBtn", "TSMSniperBtn")
			:SetSize(165, 24)
			:SetText(showBuyoutButton and BUYOUT or BID)
			:SetDisabledPublisher(self._state:PublisherForExpression([[not auctionScan or pausePending ~= nil or isSearchingForSelection or not selectionCanBuy or pendingFuture ~= nil or (isConfirming and numCanBuy == 0) or not canSendAuctionQuery]]))
			:SetAction("OnClick", showBuyoutButton and "ACTION_BUY_AUCTION" or "ACTION_BID_AUCTION")
		)
		:SetScript("OnUpdate", self._manager:CallbackToProcessAction("ACTION_BOTTOM_FRAME_SHOWN"))
		:SetScript("OnHide", self._manager:CallbackToProcessAction("ACTION_BOTTOM_FRAME_HIDDEN"))
	assert(not self._state.bottomFrame)
	self._state.bottomFrame = bottomFrame
	return bottomFrame
end

---Attempts to prepare to start a search and returns whether or not it was successful.
---@return boolean
function AuctionBuyScan:PrepareStartSearch()
	return AuctionScan.AcquireLock(self._state.scanTypeName)
end

---Sets a new search.
---@param searchContext AuctionSearchContext The search context
function AuctionBuyScan:StartSearch(searchContext)
	self._manager:ProcessAction("ACTION_START_SEARCH", searchContext)
end

---Ends the current search.
function AuctionBuyScan:EndSearch()
	self._manager:ProcessAction("ACTION_END_SEARCH")
end

---Sets the auction scroll table element
---@param auctionScrollTable AuctionScrollTable
function AuctionBuyScan:SetAuctionScrollTable(auctionScrollTable)
	self._manager:ProcessAction("ACTION_SET_SCROLL_TABLE", auctionScrollTable)
end

---Show the posting dialog to post an auction.
function AuctionBuyScan:PostAuction()
	self._manager:ProcessAction("ACTION_POST_AUCTION")
end

---Gets the current search context.
---@return AuctionSearchContext
function AuctionBuyScan:GetSearchContext()
	return self._state.searchContext
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

---@param manager UIManager
---@param state AuctionBuyScanState
function AuctionBuyScan.__private:_ActionHandler(manager, state, action, ...)
	if action == "ACTION_START_SEARCH" then
		local searchContext = ...
		local resolveSellers = nil
		if state.scanType == SCAN_TYPE.BROWSE then
			resolveSellers = not LibTSMUI.IsRetail()
		elseif state.scanType == SCAN_TYPE.SNIPER then
			resolveSellers = false
		else
			error("Invalid scan type: "..tostring(state.scanType))
		end
		manager:ProcessAction("ACTION_RESET_STATE")
		state.searchContext = searchContext
		assert(not state.auctionScan)
		state.auctionScan = AuctionScan.GetManager()
			:SetUIManager(manager)
			:SetResolveSellers(resolveSellers)
			:SetAction("OnProgressUpdate", "ACTION_SCAN_PROGRESS_UPDATED")
			:SetAction("OnNumItemsChanged", "ACTION_SCAN_NUM_ITEMS_CHANGED")
		searchContext:StartThread(manager:CallbackToProcessAction("ACTION_SCAN_COMPLETE"), state.auctionScan)
		searchContext:OnStateChanged("SCANNING")
	elseif action == "ACTION_RESET_STATE" then
		if state.searchContext then
			state.searchContext:KillThread()
			state.searchContext:OnStateChanged("DONE")
			state.searchContext = nil
		end
		if state.pendingFuture then
			manager:CancelFuture("pendingFuture")
		end
		state.findHash = nil
		state.findResult = nil
		state.scanNumItems = nil
		state.scanProgress = 0
		state.scanIsPaused = false
		state.pausePending = nil
		state.numFound = 0
		state.maxQuantity = 0
		state.defaultBuyQuantity = 0
		state.lastBuyQuantity = 0
		state.lastBuyIndex = nil
		state.numBought = 0
		state.numBid = 0
		state.numConfirmed = 0
		if state.auctionScan then
			state.auctionScan:Release()
			state.auctionScan = nil
		end
		manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
	elseif action == "ACTION_SET_SCROLL_TABLE" then
		local auctionScrollTable = ...
		state.auctionScrollTable = auctionScrollTable
		if not auctionScrollTable then
			return manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
		end
		auctionScrollTable
			:SetAuctionScan(state.auctionScan)
			:SetMarketValueFunction(state.searchContext:GetMarketValueFunc())
			:SetPctTooltip(state.searchContext:GetPctTooltip())
			:SetSelectionDisabledPublisher(state:PublisherForKeyChange("isConfirming"))
			:SetManager(manager)
			:SetAction("OnSelectionChanged", "ACTION_AUCTION_SELECTION_CHANGED")
		if state.scanType == SCAN_TYPE.SNIPER then
			auctionScrollTable:SetAction("OnRowRemoved", "ACTION_AUCTION_ROW_REMOVED")
		end
		if state.scanProgress == 1 then
			auctionScrollTable:ExpandSingleResult()
		end
		if state.selectedAuction and not auctionScrollTable:GetSelectedRow() then
			auctionScrollTable:SetSelectedRow(state.selectedAuction)
		end
	elseif action == "ACTION_SCAN_PROGRESS_UPDATED" then
		local scanProgress, scanIsPaused = state.auctionScan:GetProgress()
		if state.scanType == SCAN_TYPE.SNIPER then
			-- Ignore scan progress for sniper scans
			scanProgress = 0
		end
		state.scanProgress = scanProgress
		state.scanIsPaused = scanIsPaused
		if state.pausePending ~= nil and state.scanIsPaused == state.pausePending then
			state.pausePending = nil
			if state.scanIsPaused and state.selectedAuction then
				manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
			end
		end
	elseif action == "ACTION_SCAN_NUM_ITEMS_CHANGED" then
		state.scanNumItems = state.auctionScan:GetNumItems()
	elseif action == "ACTION_PAUSE_RESUME_CLICKED" then
		if state.selectedAuction then
			state.auctionScan:Cancel()
			AuctionScan.StopFindThread(true)
			state.findHash = nil
			manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
			if state.auctionScrollTable then
				state.auctionScrollTable:SetSelectedRow(nil)
			end
		end
		manager:ProcessAction(state.scanIsPaused and "ACTION_RESUME_SCAN" or "ACTION_PAUSE_SCAN")
	elseif action == "ACTION_PAUSE_SCAN" then
		assert(state.pausePending == nil)
		state.pausePending = true
		state.auctionScan:SetPaused(true)
	elseif action == "ACTION_RESUME_SCAN" then
		assert(state.pausePending == nil)
		state.pausePending = false
		state.auctionScan:SetPaused(false)
	elseif action == "ACTION_SCAN_COMPLETE" then
		local success = ...
		assert(state.scanType == SCAN_TYPE.BROWSE)
		AuctionScan.ReleaseLock(state.scanTypeName)
		state.searchContext:OnStateChanged("RESULTS")
		local postContext = self:_GetPostContext()
		if postContext then
			postContext:UpdateFromScan(state.auctionScan)
			state.selectionCanPost = postContext:CanPost() or false
		end
		if success and state.auctionScrollTable then
			state.auctionScrollTable:ExpandSingleResult()
		end
	elseif action == "ACTION_RESTART_DELAYED" then
		if state.selectedAuction or not state.auctionScan then
			return
		end
		state.searchContext:StartThread(manager:CallbackToProcessAction("ACTION_SCAN_COMPLETE"), state.auctionScan)
		state.searchContext:OnStateChanged("SCANNING")
	elseif action == "ACTION_BOTTOM_FRAME_SHOWN" then
		local frame = ...
		frame:SetScript("OnUpdate", nil)
		if not state.cancelShown and state.bottomFrame:HasChildById("cancelBtn") then
			state.bottomFrame:GetElement("cancelBtn"):Hide()
			state.bottomFrame:Draw()
		end
	elseif action == "ACTION_BOTTOM_FRAME_HIDDEN" then
		state.bottomFrame = nil
	elseif action == "ACTION_UPDATE_CANCEL_BUTTON" then
		if state.cancelShown then
			AuctionHouseWrapper.AutoQueryOwnedAuctions()
		end
		if state.bottomFrame and state.bottomFrame:HasChildById("cancelBtn") then
			state.bottomFrame:GetElement("buyoutBtn"):SetShown(not state.cancelShown)
			state.bottomFrame:GetElement("cancelBtn"):SetShown(state.cancelShown)
			state.bottomFrame:Draw()
		end
	elseif action == "ACTION_AUCTION_ROW_REMOVED" then
		local row = ...
		if not row:IsSubRow() then
			return
		end
		row:GetResultRow():RemoveSubRow(row)
	elseif action == "ACTION_AUCTION_SELECTION_CHANGED" then
		-- Delay selection updates so we can completely cancel find queries before starting new ones
		state.selectionChanging = true
		self._selectionDelayTimer:RunForFrames(0)
	elseif action == "ACTION_AUCTION_SELECTION_CHANGED_DELAYED" then
		state.selectionChanging = false
		if not state.auctionScrollTable then
			return
		end
		local selection = state.auctionScrollTable:GetSelectedRow()
		state.numBid = 0
		state.numBought = 0
		state.numConfirmed = 0
		if not selection then
			if state.selectedAuction then
				AuctionScan.StopFindThread(true)
				manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
			end
			return
		end
		manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", selection)
		if state.scanProgress < 1 then
			if state.pausePending ~= nil then
				-- Wait for the pause / resume to complete
				return
			end
			if not selection:IsSubRow() then
				-- Just wait until we scan this row
				if state.scanIsPaused then
					-- Resume the scan
					manager:ProcessAction("ACTION_RESUME_SCAN")
				end
			elseif state.scanIsPaused then
				-- Scan already paused, so just find the new selection
				manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
			else
				-- Pause the scan first
				manager:ProcessAction("ACTION_PAUSE_SCAN")
			end
		else
			assert(selection:IsSubRow())
			-- Find the auction
			manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
		end
	elseif action == "ACTION_SET_SELECTED_AUCTION" then
		local selection = ... ---@type AuctionRow|AuctionSubRow|nil
		if selection and selection:IsSubRow() then
			local ownerStr = selection:GetOwnerInfo()
			local isPlayerOrAlt = self._isPlayerFunc(ownerStr, true)
			state.selectedAuction = selection
			state.selectionCanBid = not isPlayerOrAlt and state.auctionScan:CanBid(selection)
			state.selectionCanBuy = not isPlayerOrAlt and state.auctionScan:CanBuy(selection)
			state.selectionCanCancel = LibTSMUI.IsRetail() and self._isPlayerFunc(ownerStr, false)
			state.findHashIsSelection = state.findHash == selection:GetHashes()
		else
			state.selectedAuction = selection
			state.selectionCanBid = false
			state.selectionCanBuy = false
			state.selectionCanCancel = false
			state.findHashIsSelection = false
			state.findResult = nil
		end
		local postContext = self:_GetPostContext()
		state.selectionCanPost = postContext and postContext:CanPost() or false
	elseif action == "ACTION_FIND_SELECTED_AUCTION" then
		if not AuctionScan.AcquireLock(state.scanTypeName) then
			return
		end
		assert(state.selectedAuction and state.selectedAuction:IsSubRow())
		state.findHash = state.selectedAuction:GetHashes()
		state.findHashIsSelection = true
		state.findResult = nil
		state.auctionScan:FindAuction(state.selectedAuction, manager:CallbackToProcessAction("ACTION_HANDLE_FIND_RESULT"), false)
	elseif action == "ACTION_HANDLE_FIND_RESULT" then
		local result = ...
		AuctionScan.ReleaseLock(state.scanTypeName)
		if not state.selectedAuction then
			assert(not state.selectedAuction)
			return
		end
		-- Update the selection in case the result rows changed
		if state.findHash ~= state.selectedAuction:GetHashes() then
			-- Find the new selected auction
			return manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
		end
		if result then
			local itemString = state.selectedAuction:GetItemString()
			local maxQuantity = state.searchContext:GetMaxCanBuy(itemString)
			if LibTSMUI.IsRetail() then
				local maxCommodity = state.selectedAuction:IsCommodity() and state.selectedAuction:GetResultRow():GetMaxQuantities()
				local numCanBuy = min(maxCommodity or result, maxQuantity or math.huge)
				state.findResult = numCanBuy > 0 and RETAIL_FIND_RESULT_PLACEHOLDER or nil
				state.numFound = numCanBuy
				state.maxQuantity = maxCommodity or 1
				state.defaultBuyQuantity = maxQuantity and min(numCanBuy, maxQuantity) or 1
			else
				state.findResult = result
				state.numFound = min(#result, maxQuantity and Math.Ceil(maxQuantity / state.selectedAuction:GetQuantities()) or math.huge)
				state.maxQuantity = maxQuantity or 1
				state.defaultBuyQuantity = state.numFound
			end
			assert(state.numBidOrBought == 0 and state.numConfirmed == 0)
		else
			if state.selectedAuction:IsSubRow() then
				-- Failed to find this auction, so remove it
				local _, rawLink = state.selectedAuction:GetLinks()
				state.selectedAuction:GetResultRow():RemoveSubRow(state.selectedAuction)
				ChatMessage.PrintfUser(L["Failed to find auction for %s, so removing it from the results."], rawLink)
			elseif state.scanIsPaused then
				-- Clear the selection and resume the scan
				state.findHash = nil
				if state.auctionScrollTable then
					state.auctionScrollTable:SetSelectedRow(nil)
				end
				manager:ProcessAction("ACTION_RESUME_SCAN")
			end
		end
	elseif action == "ACTION_BAG_QUANTITY_UPDATED" then
		if not state.searchContext then
			return
		end
		local postContext = self:_GetPostContext()
		state.selectionCanPost = postContext and postContext:CanPost() or false
	elseif action == "ACTION_AUCTION_ID_UPDATED" then
		if state.selectionChanging then
			return
		end
		local oldAuctionId, newAuctionId, newResultInfo = ...
		if not state.selectedAuction or select(2, state.selectedAuction:GetListingInfo()) ~= oldAuctionId then
			return
		end
		state.selectedAuction:UpdateResultInfo(newAuctionId, newResultInfo)
		state.findHash = state.selectedAuction:GetHashes()
		state.findHashIsSelection = true
	elseif action == "ACTION_BUY_AUCTION" then
		local selection = state.auctionScrollTable:GetSelectedRow()
		if not self:_ShowConfirmation(true) then
			-- No confirmation needed
			local numToBuy = selection:GetQuantities()
			manager:ProcessAction("ACTION_BUY_AUCTION_CONFIRMED", numToBuy)
		end
	elseif action == "ACTION_BUY_AUCTION_CONFIRMED" then
		local quantity = ...
		state.lastBuyQuantity = 0
		state.lastBuyIndex = nil
		local index = not LibTSMUI.IsRetail() and tremove(state.findResult, #state.findResult) or nil
		if not LibTSMUI.IsRetail() and not index then
			-- Didn't find the full amount
			return manager:ProcessAction("ACTION_BUYOUT_FUTURE_DONE", false)
		end
		-- Buy the auction
		local buyout = state.selectedAuction:GetBuyouts()
		if not LibTSMUI.IsRetail() and buyout ~= select(5, AuctionHouse.GetBrowseResult(index)) then
			-- The list of auctions changed
			return manager:ProcessAction("ACTION_BUYOUT_FUTURE_DONE", false)
		end
		local future = state.auctionScan:PlaceBidOrBuyout(index, buyout, state.selectedAuction, quantity)
		if not future then
			return manager:ProcessAction("ACTION_BUYOUT_FUTURE_DONE", false)
		end
		state.lastBuyQuantity = quantity
		state.lastBuyIndex = index
		state.numBought = state.numBought + (LibTSMUI.IsRetail() and quantity or 1)
		manager:ManageFuture("pendingFuture", future, "ACTION_BUYOUT_FUTURE_DONE")
	elseif action == "ACTION_BUYOUT_FUTURE_DONE" then
		local result = ...
		if result then
			Mail.HandleAuctionPurchase(ItemString.ToLevel(state.selectedAuction:GetItemString()), state.lastBuyQuantity)
			state.numConfirmed = state.numConfirmed + (LibTSMUI.IsRetail() and state.lastBuyQuantity or 1)
			manager:ProcessAction("ACTION_REMOVE_BOUGHT_AUCTIONS", state.lastBuyQuantity)
			if state.numConfirmed == state.numFound then
				state.numBid = 0
				state.numBought = 0
				state.numConfirmed = 0
			end
		else
			local _, rawLink = state.selectedAuction:GetLinks()
			ChatMessage.PrintfUser(L["Failed to buy auction of %s."], rawLink)
			if state.lastBuyQuantity > 0 then
				state.numBought = state.numBought - (LibTSMUI.IsRetail() and state.lastBuyQuantity or 1)
				if not LibTSMUI.IsRetail() then
					tinsert(state.findResult, state.lastBuyIndex)
				end
				state.lastBuyQuantity = 0
				state.lastBuyIndex = nil
			end
			-- Rescan for this item
			if state.auctionScrollTable and state.auctionScrollTable:GetSelectedRow() then
				manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
			end
		end
	elseif action == "ACTION_REMOVE_BOUGHT_AUCTIONS" then
		local quantity = ...
		-- Remove the one we just bought
		assert(quantity > 0)
		local itemString = state.selectedAuction:GetItemString()
		assert(itemString)
		state.selectedAuction:DecrementQuantity(quantity)
		state.searchContext:OnBuy(itemString, state.lastBuyQuantity)
		state.auctionScrollTable:UpdateData() -- TODO: Remove this
		local selection = state.auctionScrollTable:GetSelectedRow()
		if selection and not selection:IsSubRow() then
			state.findHash = nil
			manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
		else
			local maxQuantity = state.searchContext:GetMaxCanBuy(itemString)
			if maxQuantity then
				if not LibTSMUI.IsRetail() and selection then
					maxQuantity = maxQuantity / selection:GetQuantities()
				end
				state.defaultBuyQuantity = min(state.defaultBuyQuantity, maxQuantity)
			end
		end
	elseif action == "ACTION_BID_AUCTION" then
		local selection = state.auctionScrollTable:GetSelectedRow()
		if not self:_ShowConfirmation(false) then
			-- No confirmation needed
			local numToBuy = selection:GetQuantities()
			manager:ProcessAction("ACTION_BID_AUCTION_CONFIRMED", numToBuy)
		end
	elseif action == "ACTION_BID_AUCTION_CONFIRMED" then
		local quantity = ...
		state.lastBuyQuantity = 0
		state.lastBuyIndex = nil
		local index = not LibTSMUI.IsRetail() and tremove(state.findResult, #state.findResult) or nil
		assert(LibTSMUI.IsRetail() or index)
		-- Bid on the auction
		local result, future = state.auctionScan:PrepareForBidOrBuyout(index, state.selectedAuction, false, quantity)
		assert(not future)
		future = result and state.auctionScan:PlaceBidOrBuyout(index, state.selectedAuction:GetRequiredBid(), state.selectedAuction, quantity)
		if not future then
			return manager:ProcessAction("ACTION_BID_FUTURE_DONE", false)
		end
		state.lastBuyQuantity = quantity
		state.lastBuyIndex = index
		state.numBid = state.numBid + (LibTSMUI.IsRetail() and quantity or 1)
		manager:ManageFuture("pendingFuture", future, "ACTION_BID_FUTURE_DONE")
	elseif action == "ACTION_BID_FUTURE_DONE" then
		local result = ...
		if result then
			state.numConfirmed = state.numConfirmed + 1
			if state.numConfirmed == state.numFound then
				state.numBid = 0
				state.numBought = 0
				state.numConfirmed = 0
			end
			state.selectedAuction:ProcessBid()
			state.auctionScrollTable:UpdateData() -- TODO: Remove this
			state.auctionScrollTable:SetSelectedRow(nil)
			manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
		else
			local _, rawLink = state.selectedAuction:GetLinks()
			ChatMessage.PrintfUser(L["Failed to bid on auction of %s."], rawLink)
			if state.lastBuyQuantity > 0 then
				state.numBid = state.numBid - 1
				state.lastBuyQuantity = 0
				state.lastBuyIndex = nil
			end
			-- Rescan for this item
			if state.auctionScrollTable and state.auctionScrollTable:GetSelectedRow() then
				manager:ProcessAction("ACTION_FIND_SELECTED_AUCTION")
			end
		end
	elseif action == "ACTION_CANCEL_AUCTION" then
		assert(LibTSMUI.IsRetail() and state.selectedAuction and state.selectedAuction:IsSubRow())
		local _, auctionId = state.selectedAuction:GetListingInfo()
		Log.Info("Canceling (auctionId=%d)", auctionId)
		local future = AuctionHouseWrapper.CancelAuction(auctionId)
		if future then
			manager:ManageFuture("pendingFuture", future, "ACTION_CANCEL_FUTURE_DONE")
		else
			manager:ProcessAction("ACTION_CANCEL_FUTURE_DONE", false)
		end
	elseif action == "ACTION_CANCEL_FUTURE_DONE" then
		local result = ...
		if result then
			state.selectedAuction:GetResultRow():RemoveSubRow(state.selectedAuction)
			state.auctionScrollTable:SetSelectedRow(nil)
			manager:ProcessAction("ACTION_SET_SELECTED_AUCTION", nil)
		else
			ChatMessage.PrintUser(L["Failed to cancel auction due to the auction house being busy. Ensure no other addons are scanning the AH and try again."])
		end
	elseif action == "ACTION_POST_AUCTION" then
		local postContext = self:_GetPostContext()
		local itemString, itemDisplayedBid, itemBuyout, quantity, ownerStr = postContext:GetInfo()
		if not itemString then
			-- Should never get here
			return
		end

		local undercut = (LibTSMUI.IsRetail() or self._isPlayerFunc(ownerStr, true)) and 0 or 1
		local bid = itemDisplayedBid - undercut
		local buyout = itemBuyout - undercut
		if LibTSMUI.IsRetail() then
			bid = Math.Round(bid, COPPER_PER_SILVER)
			buyout = Math.Round(buyout, COPPER_PER_SILVER)
		end
		bid = Math.Bound(bid, 1, MAXIMUM_BID_PRICE)
		buyout = Math.Bound(buyout, 0, MAXIMUM_BID_PRICE)

		state.auctionScrollTable:GetBaseElement():ShowDialogFrame(UIElements.New("ShoppingPostDialog", "dialog")
			:SetSize(326, LibTSMUI.IsRetail() and 344 or 380)
			:AddAnchor("CENTER")
			:SetAuction(itemString, bid, buyout, quantity, undercut, state.postDuration)
			:SetManager(manager)
			:SetAction("OnPostClicked", "ACTION_POST_AUCTION_CONFIRMED")
			:SetScript("OnHide", manager:CallbackToProcessAction("ACITON_HANDLE_POST_DIALOG_HIDDEN"))
		)
		state.postDialogShown = true
	elseif action == "ACTION_POST_AUCTION_CONFIRMED" then
		local itemString, duration, stackSize, numStacks, bid, buyout = ...
		state.postDuration = duration
		local postBag, postSlot = BagTracking.CreateQueryBagsAuctionable()
			:OrderBy("slotId", true)
			:Select("bag", "slot")
			:Equal("itemString", itemString)
			:GetFirstResultAndRelease()
		if not postBag or not postSlot then
			return
		end
		if LibTSMUI.IsRetail() then
			numStacks = 1
		elseif ItemString.IsPet(itemString) then
			stackSize = 1
			numStacks = 1
		end
		local future = AuctionHouseWrapper.PostAuction(postBag, postSlot, duration, stackSize, numStacks, bid, buyout)
		if future then
			manager:ManageFuture("pendingFuture", future, "ACTION_POST_FUTURE_DONE")
		else
			manager:ProcessAction("ACTION_POST_FUTURE_DONE", false)
		end
	elseif action == "ACTION_POST_FUTURE_DONE" then
		local result = ...
		if result then
			AuctionHouseWrapper.AutoQueryOwnedAuctions()
		else
			ChatMessage.PrintUser(L["Failed to post auction due to the auction house being busy. Ensure no other addons are scanning the AH and try again."])
		end
	elseif action == "ACITON_HANDLE_POST_DIALOG_HIDDEN" then
		state.postDialogShown = false
	elseif action == "ACTION_HIDE_POST_DIALOG" then
		if state.postDialogShown then
			state.auctionScrollTable:GetBaseElement():HideDialog()
		end
	elseif action == "ACTION_END_SEARCH" then
		manager:ProcessAction("ACTION_RESET_STATE")
		AuctionScan.ReleaseLock(state.scanTypeName)
	else
		error("Unknown action: "..tostring(action))
	end
end

---@return AuctionPostContext
function AuctionBuyScan.__private:_GetPostContext()
	if self._state.selectedAuction and self._state.selectedAuction:IsSubRow() then
		self._selectionPostContext:PopulateForRow(self._state.selectedAuction)
		return self._selectionPostContext
	else
		return self._state.searchContext and self._state.searchContext:GetPostContext()
	end
end

function AuctionBuyScan.__private:_ShowConfirmation(isBuy)
	local alertThreshold = self._alertThresholdFunc and self._alertThresholdFunc(self._state.selectedAuction:GetItemString()) or nil
	local result, dialogFrame = private.GetConfirmationDialog(self._state, isBuy, alertThreshold)
	if dialogFrame then
		self._state.auctionScrollTable:GetBaseElement():ShowDialogFrame(dialogFrame
			:SetManager(self._manager)
			:SetAction("OnBuyoutClicked", isBuy and "ACTION_BUY_AUCTION_CONFIRMED" or "ACTION_BID_AUCTION_CONFIRMED")
			:SetScript("OnHide", private.ConfirmationDialogOnHide)
		)
	end
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

---@param state AuctionBuyScanState
function private.StateToProgressText(state)
	if not state.auctionScan then
		return L["Starting Scan..."]
	elseif state.isSearchingForSelection then
		return L["Finding Selected Auction"]
	elseif state.pausePending ~= nil then
		return state.pausePending and L["Pausing Scan..."] or L["Resuming Scan..."]
	elseif state.selectedAuction then
		local progressText = nil
		if state.isConfirming and state.numCanBuy > 0 then
			-- We can buy more while confirming
			progressText = format(L["Buy %d / %d (Confirming %d / %d)"], state.numBidOrBought + 1, state.numFound, state.numConfirmed + 1, state.numFound)
		elseif state.isConfirming then
			-- We're just confirming
			progressText = format(L["Confirming %d / %d"], state.numConfirmed + 1, state.numFound)
		elseif state.selectionCanBuy then
			progressText = format(L["Buy %d / %d"], state.numBidOrBought + 1, state.numFound)
		elseif state.pendingFuture then
			progressText = L["Confirming..."]
		else
			progressText = (state.canPost and state.canCancel and L["Cancel or Post"]) or (state.canPost and L["Post"]) or (state.canCancel and L["Cancel Auction"]) or L["Scan Complete"]
		end
		if state.scanIsPaused then
			return L["Scan Paused"].." | "..progressText
		else
			return progressText
		end
	elseif state.scanIsPaused then
		return L["Scan Paused"]
	elseif state.scanProgress ~= 1 then
		return state.scanNumItems and format(L["Scanning (%d Items)"], state.scanNumItems) or L["Scanning"]
	else
		return L["Scan Complete"]
	end
end

---@param state AuctionBuyScanState
function private.GetConfirmationDialog(state, isBuy, alertThreshold)
	local buyout = state.selectedAuction:GetBuyouts()
	if not isBuy then
		buyout = state.selectedAuction:GetRequiredBid(state.selectedAuction)
	end
	local quantity = state.selectedAuction:GetQuantities()
	local itemString = state.selectedAuction:GetItemString()
	local _, _, _, isHighBidder = state.selectedAuction:GetBidInfo()
	local isCommodity = LibTSMUI.IsRetail() and state.selectedAuction:IsCommodity()
	assert(not isCommodity or isBuy)
	local marketValueFunc = state.searchContext:GetMarketValueFunc()
	if not isCommodity and (not isBuy or not isHighBidder) and (not alertThreshold or ceil(buyout / quantity) < alertThreshold) then
		-- Don't need to confirm this
		return false, nil
	elseif private.confirmationVisible then
		-- Already showing a confirmation
		return true, nil
	end

	local dialogFrame = nil
	if isCommodity then
		local gatheringResultsFunction = state.searchContext:GetGatheringResultsFunc()
		local defaultQuantity, marketThreshold = state.defaultBuyQuantity, nil
		if gatheringResultsFunction then
			defaultQuantity = gatheringResultsFunction(state.auctionScan, marketValueFunc, itemString, defaultQuantity, state.maxQuantity)
			marketThreshold = marketValueFunc(state.selectedAuction) or 0
		end
		dialogFrame = UIElements.New("AuctionCommodityBuyConfirmationDialog", "frame")
			:SetSize(600, 272)
			:AddAnchor("CENTER")
			:Configure(state.auctionScan, state.selectedAuction, defaultQuantity, state.maxQuantity, marketValueFunc, marketThreshold, alertThreshold)
	else
		local auctionNum = min(state.numConfirmed + 1, state.defaultBuyQuantity)
		dialogFrame = UIElements.New("AuctionItemBuyConfirmationDialog", "frame")
			:SetSize(340, 262)
			:AddAnchor("CENTER")
			:Configure(isBuy, state.selectedAuction, quantity, auctionNum, state.defaultBuyQuantity, marketValueFunc(state.selectedAuction))
	end
	private.confirmationVisible = true
	return true, dialogFrame
end

function private.ConfirmationDialogOnHide()
	private.confirmationVisible = false
end
