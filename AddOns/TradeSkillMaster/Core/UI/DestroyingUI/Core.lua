-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DestroyingUI = TSM.UI:NewPackage("DestroyingUI")
local L = TSM.Include("Locale").GetTable()
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local FSM = TSM.Include("Util.FSM")
local ItemString = TSM.Include("Util.ItemString")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local Theme = TSM.Include("Util.Theme")
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Conversions = TSM.Include("Service.Conversions")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	enterWorldTime = nil,
	settings = nil,
	fsm = nil,
	query = nil,
}
local MIN_FRAME_SIZE = { width = 280, height = 280 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function DestroyingUI.OnInitialize()
	Event.Register("PLAYER_ENTERING_WORLD", function()
		private.enterWorldTime = GetTime()
	end)
	private.settings = Settings.NewView()
		:AddKey("global", "destroyingUIContext", "frame")
		:AddKey("global", "destroyingUIContext", "itemsScrollingTable")
		:AddKey("global", "destroyingOptions", "autoShow")
		:AddKey("global", "destroyingOptions", "autoStack")
	private.FSMCreate()
end

function DestroyingUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function DestroyingUI.Toggle()
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("destroying")
	local frame = UIElements.New("ApplicationFrame", "base")
		:SetParent(UIParent)
		:SetSettingsContext(private.settings, "frame")
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetStrata("HIGH")
		:SetTitle(L["Destroying"])
		:SetScript("OnHide", private.FrameOnHide)
		:SetContentFrame(UIElements.New("Frame", "content")
			:SetLayout("VERTICAL")
			:SetBackgroundColor("PRIMARY_BG_ALT")
			:AddChild(UIElements.New("Frame", "item")
				:SetLayout("VERTICAL")
				:SetHeight(82)
				:SetMargin(8)
				:SetBackgroundColor("PRIMARY_BG_ALT", true)
				:SetBorderColor("FRAME_BG")
				:AddChild(UIElements.New("Frame", "header")
					:SetLayout("HORIZONTAL")
					:SetPadding(8, 8, 8, 4)
					:SetHeight(32)
					:SetBackgroundColor("FRAME_BG", true)
					:AddChild(UIElements.New("Button", "icon")
						:SetSize(20, 20)
						:SetMargin(0, 5, 0, 0)
					)
					:AddChild(UIElements.New("Text", "name")
						:SetHeight(20)
						:SetFont("ITEM_BODY2")
					)
				)
				-- draw a line along the bottom to hide the rounded corners at the bottom of the header frame
				:AddChildNoLayout(UIElements.New("Texture", "line")
					:AddAnchor("BOTTOMLEFT", "header")
					:AddAnchor("BOTTOMRIGHT", "header")
					:SetHeight(4)
					:SetTexture("FRAME_BG")
				)
				:AddChild(UIElements.New("Frame", "container")
					:SetLayout("VERTICAL")
					:SetPadding(0, 0, 4, 4)
					:AddChild(UIElements.New("ScrollFrame", "scroll")
						:SetPadding(8, 8, 0, 0)
					)
				)
			)
			:AddChild(UIElements.New("QueryScrollingTable", "items")
				:SetSettingsContext(private.settings, "itemsScrollingTable")
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitle(L["Item"])
						:SetIconSize(12)
						:SetFont("ITEM_BODY3")
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetIconInfo("itemString", ItemInfo.GetTexture)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:SetTooltipLinkingDisabled(true)
						:SetActionIconInfo(1, 12, private.GetHideIcon)
						:SetActionIconClickHandler(private.OnHideIconClick)
						:DisableHiding()
						:Commit()
					:NewColumn("num")
						:SetTitle("Qty")
						:SetFont("TABLE_TABLE1")
						:SetJustifyH("CENTER")
						:SetTextInfo("quantity")
						:SetSortInfo("quantity")
						:Commit()
					:Commit()
				:SetQuery(private.query)
				:SetScript("OnSelectionChanged", private.ItemsOnSelectionChanged)
			)
			:AddChild(UIElements.New("Texture", "lineBottom")
				:SetHeight(2)
				:SetTexture("ACTIVE_BG")
			)
			:AddChild(UIElements.New("ActionButton", "combineBtn")
				:SetHeight(26)
				:SetMargin(12, 12, 12, 0)
				:SetText(L["Combine Partial Stacks"])
				:SetScript("OnClick", private.CombineButtonOnClick)
			)
			:AddChild(UIElements.NewNamed("SecureMacroActionButton", "destroyBtn", "TSMDestroyBtn")
				:SetHeight(26)
				:SetMargin(12, 12, 8, 12)
				:SetText(L["Destroy Next"])
				:SetScript("PreClick", private.DestroyButtonPreClick)
			)
		)
	frame:GetElement("titleFrame.closeBtn"):SetScript("OnClick", private.CloseButtonOnClick)
		:Draw()
	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnHide()
	TSM.UI.AnalyticsRecordClose("destroying")
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function private.GetHideIcon(self, data, iconIndex, isMouseOver)
	assert(iconIndex == 1)
	-- TODO: needs a new texture for the icon
	return true, isMouseOver and TSM.UI.TexturePacks.GetColoredKey("iconPack.12x12/Hide", "TEXT_ALT") or "iconPack.12x12/Hide", true, L["Click to hide this item for the current session. Hold shift to hide this item permanently."]
end

function private.OnHideIconClick(self, data, iconIndex, mouseButton)
	assert(iconIndex == 1)
	if mouseButton ~= "LeftButton" then
		return
	end
	local row = self._query:GetResultRowByUUID(data)
	local itemString = row:GetField("itemString")
	if IsShiftKeyDown() then
		Log.PrintfUser(L["Destroying will ignore %s permanently. You can remove it from the ignored list in the settings."], ItemInfo.GetName(itemString))
		TSM.Destroying.IgnoreItemPermanent(itemString)
	else
		Log.PrintfUser(L["Destroying will ignore %s until you log out."], ItemInfo.GetName(itemString))
		TSM.Destroying.IgnoreItemSession(itemString)
	end
	if self._query:Count() == 0 then
		private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
	end
end

function private.GetDestroyInfo(itemString)
	local quality = ItemInfo.GetQuality(itemString)
	local ilvl = ItemInfo.GetItemLevel(ItemString.GetBase(itemString))
	local classId = ItemInfo.GetClassId(itemString)
	local info = TempTable.Acquire()
	local targetItems = TempTable.Acquire()
	for targetItemString in DisenchantInfo.TargetItemIterator() do
		local amountOfMats, matRate, minAmount, maxAmount = DisenchantInfo.GetTargetItemSourceInfo(targetItemString, classId, quality, ilvl)
		if amountOfMats then
			local name = ItemInfo.GetName(targetItemString)
			local color = ItemInfo.GetQualityColor(targetItemString)
			if name and color then
				matRate = matRate and matRate * 100
				matRate = matRate and matRate.."% " or ""
				local range = (minAmount and maxAmount) and Theme.GetFeedbackColor("YELLOW"):ColorText(minAmount ~= maxAmount and (" ["..minAmount.."-"..maxAmount.."]") or (" ["..minAmount.."]")) or ""
				tinsert(info, color..matRate..name.." x"..amountOfMats.."|r"..range)
				tinsert(targetItems, targetItemString)
			end
		end
	end
	for targetItemString, amountOfMats, matRate, minAmount, maxAmount in Conversions.TargetItemsByMethodIterator(itemString, Conversions.METHOD.PROSPECT) do
		local name = ItemInfo.GetName(targetItemString)
		local color = ItemInfo.GetQualityColor(targetItemString)
		if name and color then
			matRate = matRate and matRate * 100
			matRate = matRate and matRate.."% " or ""
			local range = (minAmount and maxAmount) and Theme.GetFeedbackColor("YELLOW"):ColorText(minAmount ~= maxAmount and (" ["..minAmount.."-"..maxAmount.."]") or (" ["..minAmount.."]")) or ""
			tinsert(info, color..matRate..name.." x"..amountOfMats.."|r"..range)
			tinsert(targetItems, targetItemString)
		end
	end
	for targetItemString, rate in Conversions.TargetItemsByMethodIterator(itemString, Conversions.METHOD.MILL) do
		local name = ItemInfo.GetName(targetItemString)
		local color = ItemInfo.GetQualityColor(targetItemString)
		if name and color then
			tinsert(info, color..ItemInfo.GetName(targetItemString).." x"..rate.."|r")
			tinsert(targetItems, targetItemString)
		end
	end
	return info, targetItems
end

function private.ItemsOnSelectionChanged(self)
	if not self:GetSelection() then
		return
	end

	local itemString = self:GetSelection():GetField("itemString")
	local itemFrame = self:GetElement("__parent.item")
	itemFrame:GetElement("header.icon")
		:SetBackground(ItemInfo.GetTexture(itemString))
		:SetTooltip(itemString)
		itemFrame:GetElement("header.name")
		:SetText(TSM.UI.GetColoredItemName(itemString) or "")

	local info, targetItems = private.GetDestroyInfo(itemString)
	local scrollFrame = itemFrame:GetElement("container.scroll")
	scrollFrame:ReleaseAllChildren()
	for i, text in ipairs(info) do
		scrollFrame:AddChild(UIElements.New("Button", "row"..i)
			:SetHeight(14)
			:SetFont("ITEM_BODY3")
			:SetJustifyH("LEFT")
			:SetText(text)
			:SetTooltip(targetItems[i])
		)
	end
	TempTable.Release(info)
	TempTable.Release(targetItems)
	itemFrame:Draw()
end

function private.CloseButtonOnClick(button)
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function private.CombineButtonOnClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_COMBINE_BUTTON_CLICKED")
end

function private.DestroyButtonPreClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_DESTROY_BUTTON_PRE_CLICK")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSM.Destroying.SetBagUpdateCallback(private.FSMBagUpdate)
	local fsmContext = {
		frame = nil,
		combineFuture = nil,
		destroyFuture = nil,
		didShowOnce = false,
		didAutoCombine = false,
	}
	local function UpdateDestroyingFrame(context, noDraw)
		if not context.frame then
			return
		end

		local combineBtn = context.frame:GetElement("content.combineBtn")
		combineBtn:SetText(context.combineFuture and L["Combining..."] or L["Combine Partial Stacks"])
		combineBtn:SetDisabled(context.combineFuture or context.destroyFuture or not TSM.Destroying.CanCombine())
		local destroyBtn = context.frame:GetElement("content.destroyBtn")
		destroyBtn:SetText(context.destroyFuture and L["Destroying..."] or L["Destroy Next"])
		destroyBtn:SetDisabled(context.combineFuture or context.destroyFuture or private.query:Count() == 0)
		if not noDraw then
			context.frame:Draw()
		end
	end
	private.fsm = FSM.New("DESTROYING")
		:AddState(FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				if context.combineFuture then
					context.combineFuture:Cancel()
					context.combineFuture = nil
				end
				if context.destroyFuture then
					context.destroyFuture:Cancel()
					context.destroyFuture = nil
				end
				context.didAutoCombine = false
			end)
			:AddTransition("ST_FRAME_OPENING")
			:AddEventTransition("EV_FRAME_TOGGLE", "ST_FRAME_OPENING")
			:AddEvent("EV_BAG_UPDATE", function(context)
				if not context.didShowOnce and private.settings.autoShow then
					return "ST_FRAME_OPENING"
				end
			end)
		)
		:AddState(FSM.NewState("ST_FRAME_OPENING")
			:SetOnEnter(function(context)
				private.query = private.query or TSM.Destroying.CreateBagQuery()
				private.query:ResetOrderBy()
				private.query:OrderBy("name", true)
				if (not private.settings.autoStack or not TSM.Destroying.CanCombine()) and private.query:Count() == 0 then
					-- nothing to destroy or combine, so bail
					return "ST_FRAME_CLOSED"
				end
				context.didShowOnce = true
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				private.ItemsOnSelectionChanged(context.frame:GetElement("content.items"))
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_CLOSED")
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				UpdateDestroyingFrame(context)
				if not context.frame:GetElement("content.items"):GetSelection() then
					-- select the first row
					local result = private.query:GetFirstResult()
					context.frame:GetElement("content.items"):SetSelection(result and result:GetUUID() or nil)
				end
				if private.settings.autoStack and not context.didAutoCombine and TSM.Destroying.CanCombine() then
					context.didAutoCombine = true
					context.frame:GetElement("content.combineBtn")
						:SetPressed(true)
						:Draw()
					return "ST_COMBINING_STACKS"
				elseif not TSM.Destroying.CanCombine() and private.query:Count() == 0 then
					-- nothing left to destroy or combine
					return "ST_FRAME_CLOSED"
				end
				context.didAutoCombine = true
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_COMBINING_STACKS")
			:AddTransition("ST_DESTROYING")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEventTransition("EV_COMBINE_BUTTON_CLICKED", "ST_COMBINING_STACKS")
			:AddEventTransition("EV_DESTROY_BUTTON_PRE_CLICK", "ST_DESTROYING")
			:AddEventTransition("EV_BAG_UPDATE", "ST_FRAME_OPEN")
			:AddEventTransition("EV_FRAME_HIDE", "ST_FRAME_CLOSED")
		)
		:AddState(FSM.NewState("ST_COMBINING_STACKS")
			:SetOnEnter(function(context)
				assert(not context.combineFuture)
				context.combineFuture = TSM.Destroying.StartCombine()
				context.combineFuture:SetScript("OnDone", private.FSMCombineFutureOnDone)
				UpdateDestroyingFrame(context, true)
			end)
			:AddTransition("ST_COMBINING_DONE")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEventTransition("EV_COMBINE_DONE", "ST_COMBINING_DONE")
			:AddEventTransition("EV_FRAME_HIDE", "ST_FRAME_CLOSED")
		)
		:AddState(FSM.NewState("ST_COMBINING_DONE")
			:SetOnEnter(function(context)
				-- don't care what the result was
				context.combineFuture:GetValue()
				context.combineFuture = nil
				context.frame:GetElement("content.combineBtn")
					:SetPressed(false)
					:Draw()
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
		)
		:AddState(FSM.NewState("ST_DESTROYING")
			:SetOnEnter(function(context)
				assert(not context.destroyFuture)
				context.destroyFuture = TSM.Destroying.StartDestroy(context.frame:GetElement("content.destroyBtn"), context.frame:GetElement("content.items"):GetSelection())
				context.destroyFuture:SetScript("OnDone", private.FSMDestroyFutureOnDone)
				UpdateDestroyingFrame(context, true)
			end)
			:AddTransition("ST_DESTROYING_DONE")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEventTransition("EV_DESTROY_DONE", "ST_DESTROYING_DONE")
			:AddEventTransition("EV_FRAME_HIDE", "ST_FRAME_CLOSED")
		)
		:AddState(FSM.NewState("ST_DESTROYING_DONE")
			:SetOnEnter(function(context)
				-- don't care what the result was
				context.destroyFuture:GetValue()
				context.destroyFuture = nil
				context.isDestroying = false
				context.frame:GetElement("content.destroyBtn")
					:SetPressed(false)
					:Draw()
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
		)
		:AddDefaultEventTransition("EV_FRAME_TOGGLE", "ST_FRAME_CLOSED")
		:Init("ST_FRAME_CLOSED", fsmContext)
end

function private.FSMBagUpdate()
	if not private.enterWorldTime or private.enterWorldTime == GetTime() then
		-- delay for another frame as wow closes special frames in its PLAYER_ENTERING_WORLD handler
		Delay.AfterTime("DESTROYING_BAG_UPDATE_DELAY", 0, private.FSMBagUpdate)
		return
	end
	private.fsm:ProcessEvent("EV_BAG_UPDATE")
end

function private.FSMCombineFutureOnDone()
	private.fsm:ProcessEvent("EV_COMBINE_DONE")
end

function private.FSMDestroyFutureOnDone()
	private.fsm:ProcessEvent("EV_DESTROY_DONE")
end
