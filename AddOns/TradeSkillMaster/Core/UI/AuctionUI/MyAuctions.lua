-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MyAuctions = TSM.UI.AuctionUI:NewPackage("MyAuctions")
local L = TSM.Include("Locale").GetTable()
local FSM = TSM.Include("Util.FSM")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	fsm = nil,
	frame = nil,
	query = nil,
}
local DURATION_LIST = {
	"Short (Under 30m)",
	"Medium (30m to 2h)",
	"Long (2h to 12h)",
	"Very Long (Over 12h)",
}
local SECONDS_PER_MIN = 60
local SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN
local SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR



-- ============================================================================
-- Module Functions
-- ============================================================================

function MyAuctions.OnInitialize()
	private.FSMCreate()
	TSM.UI.AuctionUI.RegisterTopLevelPage(L["My Auctions"], "iconPack.24x24/Auctions", private.GetMyAuctionsFrame, private.OnItemLinked)
end



-- ============================================================================
-- MyAuctions UI
-- ============================================================================

function private.GetMyAuctionsFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "my_auctions")
	private.query = private.query or TSM.MyAuctions.CreateQuery()
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "myAuctions")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#272727")
		:SetStyle("padding", { top = 31 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "headerLabelFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("margin", { left = 8, right = 8, bottom = 4 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "durationLabel")
				:SetStyle("width", 245)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 10)
				:SetText(L["Filter Auctions by Duration"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "keywordLabel")
				:SetStyle("margin", { left = 8, right = 150 })
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 10)
				:SetText(L["Filter Auctions by Keyword"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "headerFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin", { left = 8, right = 8, bottom = 4 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "durationDropdown")
				:SetStyle("width", 245)
				:SetItems(DURATION_LIST)
				:SetHintText(L["Select Duration"])
				:SetScript("OnSelectionChanged", private.FilterChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "keywordInput")
				:SetStyle("margin", { left = 8, right = 8 })
				:SetStyle("background", "#585858")
				:SetStyle("border", "#9d9d9d")
				:SetStyle("borderSize", 2)
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("hintTextColor", "#e2e2e2")
				:SetStyle("justifyH", "LEFT")
				:SetStyle("hintJustifyH", "LEFT")
				:SetHintText(L["Type Something"])
				:SetScript("OnTextChanged", private.FilterChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "clearfilterBtn")
				:SetStyle("width", 142)
				:SetText(L["Clear Filters"])
				:SetScript("OnClick", private.ClearFilterBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ignoreBidCheckbox")
			:SetStyle("height", 24)
			:SetStyle("margin.left", 4)
			:SetStyle("margin.bottom", 4)
			:SetCheckboxPosition("LEFT")
			:SetText(L["Hide auctions with bids"])
			:SetStyle("fontHeight", 12)
			:SetStyle("checkboxSpacing", 1)
			:SetScript("OnValueChanged", private.FilterChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "auctions")
			:SetStyle("headerBackground", "#404040")
			:GetScrollingTableInfo()
				:NewColumn("item")
					:SetTitles(L["Item Name"])
					:SetIconSize(12)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo(nil, private.AuctionsGetItemText)
					:SetIconInfo("itemString", ItemInfo.GetTexture)
					:SetTooltipInfo("itemString", private.AuctionsGetItemTooltip)
					:Commit()
				:NewColumn("stackSize")
					:SetTitles("#")
					:SetWidth(30)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("CENTER")
					:SetTextInfo("stackSize")
					:Commit()
				:NewColumn("timeLeft")
					:SetTitleIcon("iconPack.14x14/Clock")
					:SetWidth(40)
					:SetFont(TSM.UI.Fonts.MontserratRegular)
					:SetFontHeight(12)
					:SetJustifyH("CENTER")
					:SetTextInfo(nil, private.AuctionsGetTimeLeftText)
					:Commit()
				:NewColumn("highbidder")
					:SetTitles(L["High Bidder"])
					:SetWidth(110)
					:SetFont(TSM.UI.Fonts.MontserratRegular)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo(nil, private.AuctionsGetHighBidderText)
					:Commit()
				:NewColumn("group")
					:SetTitles(GROUP)
					:SetWidth(110)
					:SetFont(TSM.UI.Fonts.MontserratRegular)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("itemString", private.AuctionsGetGroupText)
					:Commit()
				:NewColumn("currentBid")
					:SetTitles(BID)
					:SetWidth(100)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo(nil, private.AuctionsGetCurrentBidText)
					:Commit()
				:NewColumn("buyout")
					:SetTitles(BUYOUT)
					:SetWidth(100)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo(nil, private.AuctionsGetCurrentBuyoutText)
					:Commit()
				:Commit()
			:SetQuery(private.query)
			:SetSelectionValidator(private.AuctionsValidateSelection)
			:SetScript("OnSelectionChanged", private.AuctionsOnSelectionChanged)
			:SetScript("OnDataUpdated", private.AuctionsOnDataUpdated)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bottom")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 38)
			:SetStyle("padding.bottom", -2)
			:SetStyle("padding.top", 6)
			:SetStyle("background", "#363636")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ProgressBar", "progressBar")
				:SetStyle("margin.right", 8)
				:SetStyle("height", 28)
				:SetProgress(0)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "labels")
				:SetLayout("VERTICAL")
				:SetStyle("width", 125)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sold")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 11)
					:SetStyle("justifyH", "RIGHT")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "posted")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 11)
					:SetStyle("justifyH", "RIGHT")
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "values")
				:SetLayout("VERTICAL")
				:SetStyle("margin.right", 8)
				:SetStyle("width", 105)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sold")
					:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
					:SetStyle("fontHeight", 11)
					:SetStyle("justifyH", "RIGHT")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "posted")
					:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
					:SetStyle("fontHeight", 11)
					:SetStyle("justifyH", "RIGHT")
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewNamedElement("ActionButton", "cancelBtn", "TSMCancelAuctionBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Close/Circle")
				:SetText(strupper(CANCEL))
				:SetDisabled(true)
				:DisableClickCooldown(true)
				:SetScript("OnClick", private.CancelButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "skipBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 26)
				:SetStyle("iconTexturePack", "iconPack.14x14/Skip")
				:SetText(L["SKIP"])
				:SetDisabled(true)
				:DisableClickCooldown(true)
				:SetScript("OnClick", private.SkipButtonOnClick)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
	private.frame = frame
	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnItemLinked(name)
	private.frame:GetElement("headerFrame.keywordInput")
		:SetText(name)
		:Draw()
	return true
end

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(38)
	private.fsm:ProcessEvent("EV_FRAME_SHOWN", frame)
end

function private.FrameOnHide(frame)
	assert(frame == private.frame)
	private.frame = nil
	frame:GetBaseElement():SetBottomPadding(nil)
	private.fsm:ProcessEvent("EV_FRAME_HIDDEN")
end

function private.FilterChanged(self)
	private.fsm:ProcessEvent("EV_FILTER_UPDATED")
end

function private.ClearFilterBtnOnClick(button)
	button:GetElement("__parent.keywordInput")
		:SetText("")
		:SetFocused(false)
	button:GetElement("__parent.durationDropdown")
		:SetOpen(false)
		:SetSelectedItem()
	button:GetParentElement():GetParentElement():Draw()
	private.fsm:ProcessEvent("EV_FILTER_UPDATED")
end

function private.AuctionsValidateSelection(_, row)
	return row:GetField("saleStatus") == 0
end

function private.AuctionsOnSelectionChanged()
	private.fsm:ProcessEvent("EV_SELECTION_CHANGED")
end

function private.AuctionsOnDataUpdated()
	if not private.frame then
		return
	end

	private.fsm:ProcessEvent("EV_DATA_UPDATED")
end

function private.CancelButtonOnClick(button)
	private.fsm:ProcessEvent("EV_CANCEL_CLICKED")
end

function private.SkipButtonOnClick(button)
	private.fsm:ProcessEvent("EV_SKIP_CLICKED")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		currentSelectionIndex = nil,
		currentSelectionAuctionId = nil,
		durationFilter = nil,
		keywordFilter = "",
		bidFilter = false,
		filterChanged = false,
	}
	local function UpdateFrame(context)
		if not context.frame then
			return
		end

		local auctions = context.frame:GetElement("auctions")
		if context.filterChanged then
			context.filterChanged = false
			private.query:Release()
			private.query = TSM.MyAuctions.CreateQuery()
			if private.durationFilter then
				if TSM.IsWow83() then
					if private.durationFilter == 1 then
						private.query:LessThan("duration", time() + (30 * SECONDS_PER_MIN))
					elseif private.durationFilter == 2 then
						private.query:LessThan("duration", time() + (2 * SECONDS_PER_HOUR))
					elseif private.durationFilter == 3 then
						private.query:LessThanOrEqual("duration", time() + (12 * SECONDS_PER_HOUR))
					else
						private.query:GreaterThan("duration", time() + (12 * SECONDS_PER_HOUR))
					end
				else
					private.query:Equal("duration", private.durationFilter)
				end
			end
			if private.keywordFilter then
				private.query:Matches("itemName", private.keywordFilter)
			end
			if private.bidFilter then
				private.query:Equal("highBidder", "")
			end
			auctions:SetQuery(private.query, true)
		end
		-- select the next row we can cancel (or clear the selection otherwise)
		local selectedRow = nil
		if context.currentSelectionIndex then
			if TSM.IsWow83() and TSM.MyAuctions.CanCancel(context.currentSelectionAuctionId) then
				-- try to select the same row
				for _, row in private.query:Iterator() do
					local auctionId = row:GetFields("auctionId")
					if not selectedRow and auctionId == context.currentSelectionAuctionId then
						selectedRow = row
					end
				end
			end
			-- find the next auction to cancel
			for _, row in private.query:Iterator() do
				local index, auctionId = row:GetFields("index", "auctionId")
				if not selectedRow and TSM.MyAuctions.CanCancel(auctionId) and ((TSM.IsWow83() and index >= context.currentSelectionIndex) or (not TSM.IsWow83() and index <= context.currentSelectionIndex)) then
					selectedRow = row
				end
			end
		end
		if selectedRow then
			context.currentSelectionIndex, context.currentSelectionAuctionId = selectedRow:GetFields("index", "auctionId")
		else
			context.currentSelectionIndex = nil
			context.currentSelectionAuctionId = nil
		end
		auctions:SetSelection(selectedRow and selectedRow:GetUUID() or nil, true)

		context.frame:GetElement("headerFrame.clearfilterBtn")
			:SetDisabled(not private.durationFilter and not private.keywordFilter and not private.bidFilter and not private.soldFilter)
			:Draw()

		local hasSelection = auctions:GetSelection() and true or false
		local numPending = TSM.MyAuctions.GetNumPending()
		local progressText = nil
		if numPending > 0 then
			progressText = format(L["Canceling %d Auctions..."], numPending)
		elseif hasSelection then
			progressText = L["Ready to Cancel"]
		else
			progressText = L["Select Auction to Cancel"]
		end
		local bottomFrame = context.frame:GetElement("bottom")
		bottomFrame:GetElement("cancelBtn")
			:SetDisabled(not hasSelection or (TSM.IsWow83() and numPending > 0) or (not TSM.IsWowClassic() and context.currentSelectionAuctionId and C_AuctionHouse.GetCancelCost(context.currentSelectionAuctionId) > GetMoney()))
			:Draw()
		bottomFrame:GetElement("skipBtn")
			:SetDisabled(not hasSelection)
			:Draw()
		bottomFrame:GetElement("progressBar")
			:SetProgressIconHidden(numPending == 0)
			:SetText(progressText)
			:Draw()
		local numPosted, numSold, postedGold, soldGold = TSM.MyAuctions.GetAuctionInfo()
		bottomFrame:GetElement("labels.sold")
			:SetFormattedText(L["Sold Auctions %s:"], "|cffffd839"..numSold.."|r")
			:Draw()
		bottomFrame:GetElement("labels.posted")
			:SetFormattedText(L["Posted Auctions %s:"], "|cff6ebae6"..numPosted.."|r")
			:Draw()
		bottomFrame:GetElement("values.sold")
			:SetText(Money.ToString(soldGold))
			:Draw()
		bottomFrame:GetElement("values.posted")
			:SetText(Money.ToString(postedGold))
			:Draw()
	end
	private.fsm = FSM.New("MY_AUCTIONS")
		:AddState(FSM.NewState("ST_HIDDEN")
			:SetOnEnter(function(context)
				context.frame = nil
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SHOWNING")
			:AddEventTransition("EV_FRAME_SHOWN", "ST_SHOWNING")
		)
		:AddState(FSM.NewState("ST_SHOWNING")
			:SetOnEnter(function(context, frame)
				context.frame = frame
				context.filterChanged = true
				return "ST_SHOWN"
			end)
			:AddTransition("ST_SHOWN")
		)
		:AddState(FSM.NewState("ST_SHOWN")
			:SetOnEnter(function(context)
				UpdateFrame(context)
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_CANCELING")
			:AddTransition("ST_SKIPPING")
			:AddTransition("ST_CHANGING_SELECTION")
			:AddEventTransition("EV_CANCEL_CLICKED", "ST_CANCELING")
			:AddEventTransition("EV_SKIP_CLICKED", "ST_SKIPPING")
			:AddEventTransition("EV_SELECTION_CHANGED", "ST_CHANGING_SELECTION")
			:AddEventTransition("EV_DATA_UPDATED", "ST_SHOWN")
			:AddEvent("EV_FILTER_UPDATED", function(context)
				local didChange = false
				local durationFilter = context.frame:GetElement("headerFrame.durationDropdown"):GetSelectedItemKey()
				if durationFilter ~= private.durationFilter then
					private.durationFilter = durationFilter
					didChange = true
				end
				local keywordFilter = context.frame:GetElement("headerFrame.keywordInput"):GetText()
				keywordFilter = keywordFilter ~= "" and String.Escape(keywordFilter) or nil
				if keywordFilter ~= private.keywordFilter then
					private.keywordFilter = keywordFilter
					didChange = true
				end
				local bidFilter = context.frame:GetElement("ignoreBidCheckbox"):IsChecked()
				if bidFilter ~= private.bidFilter then
					private.bidFilter = bidFilter
					didChange = true
				end
				if didChange then
					context.filterChanged = true
					context.currentSelectionIndex = nil
					context.currentSelectionAuctionId = nil
					return "ST_SHOWN"
				end
			end)
		)
		:AddState(FSM.NewState("ST_CHANGING_SELECTION")
			:SetOnEnter(function(context)
				local row = context.frame:GetElement("auctions"):GetSelection()
				context.currentSelectionIndex = row and row:GetField("index") or nil
				context.currentSelectionAuctionId = row and row:GetField("auctionId") or nil
				return "ST_SHOWN"
			end)
			:AddTransition("ST_SHOWN")
		)
		:AddState(FSM.NewState("ST_CANCELING")
			:SetOnEnter(function(context)
				local buttonsFrame = context.frame:GetElement("bottom")
				buttonsFrame:GetElement("cancelBtn"):SetDisabled(true)
				buttonsFrame:GetElement("skipBtn"):SetDisabled(true)
				buttonsFrame:Draw()
				local auctionId = context.frame:GetElement("auctions"):GetSelection():GetField("auctionId")
				if TSM.MyAuctions.CanCancel(auctionId) then
					TSM.MyAuctions.CancelAuction(auctionId)
				end
				return "ST_SHOWN"
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SHOWN")
		)
		:AddState(FSM.NewState("ST_SKIPPING")
			:SetOnEnter(function(context)
				local selectedRow = nil
				for _, row in private.query:Iterator() do
					local index, auctionId = row:GetFields("index", "auctionId")
					if not selectedRow and TSM.MyAuctions.CanCancel(auctionId) and (TSM.IsWow83() and index > context.currentSelectionIndex) or (not TSM.IsWow83() and index < context.currentSelectionIndex) then
						selectedRow = row
					end
				end
				if selectedRow then
					context.currentSelectionIndex, context.currentSelectionAuctionId = selectedRow:GetFields("index", "auctionId")
				else
					context.currentSelectionIndex = nil
					context.currentSelectionAuctionId = nil
				end
				context.frame:GetElement("auctions"):SetSelection(selectedRow and selectedRow:GetUUID() or nil)
				return "ST_SHOWN"
			end)
			:AddTransition("ST_SHOWN")
		)
		:AddDefaultEventTransition("EV_FRAME_HIDDEN", "ST_HIDDEN")
		:Init("ST_HIDDEN", fsmContext)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.AuctionsGetItemText(row)
	local multiplier = row:GetField("saleStatus") == 0 and not row:GetField("isPending") and 1 or 0.8
	return TSM.UI.GetQualityColoredText(row:GetField("itemName"), row:GetField("itemQuality"), multiplier)
end

function private.AuctionsGetItemTooltip(itemString)
	return itemString ~= ItemString.GetPetCageItemString() and itemString or nil
end

function private.AuctionsGetTimeLeftText(row)
	local saleStatus, duration, isPending = row:GetFields("saleStatus", "duration", "isPending")
	if saleStatus == 0 and isPending then
		return "..."
	elseif saleStatus == 1 or TSM.IsWow83() then
		local timeLeft = duration - time()
		if timeLeft < SECONDS_PER_MIN then
			return timeLeft.."s"
		elseif timeLeft < SECONDS_PER_HOUR then
			return floor(timeLeft / SECONDS_PER_MIN).."m"
		elseif timeLeft < SECONDS_PER_DAY then
			return floor(timeLeft / SECONDS_PER_HOUR).."h"
		else
			return floor(timeLeft / SECONDS_PER_DAY).."d"
		end
	else
		return TSM.UI.GetTimeLeftString(duration)
	end
end

function private.AuctionsGetHighBidderText(row)
	local saleStatus = row:GetField("saleStatus")
	return saleStatus == 1 and TSM.IsWow83() and "" or row:GetField("highBidder")
end

function private.AuctionsGetGroupText(itemString)
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath then
		return ""
	end
	local groupName = TSM.Groups.Path.GetName(groupPath)
	local level = select('#', strsplit(TSM.CONST.GROUP_SEP, groupPath))
	local color = gsub(TSM.UI.GetGroupLevelColor(level), "#", "|cff")
	return color..groupName.."|r"
end

function private.AuctionsGetCurrentBidText(row)
	local saleStatus = row:GetField("saleStatus")
	if saleStatus == 1 then
		return L["Sold"]
	elseif row:GetField("highBidder") == "" then
		return Money.ToString(row:GetField("currentBid"), nil, "OPT_DISABLE")
	else
		return Money.ToString(row:GetField("currentBid"))
	end
end

function private.AuctionsGetCurrentBuyoutText(row)
	local saleStatus = row:GetField("saleStatus")
	return Money.ToString(row:GetField(saleStatus == 1 and "currentBid" or "buyout"))
end
