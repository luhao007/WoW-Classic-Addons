-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MailingUI = TSM.UI:NewPackage("MailingUI")
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local Event = TSM.Include("Util.Event")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	topLevelPages = {},
	frame = nil,
	fsm = nil,
	defaultUISwitchBtn = nil,
	isVisible = false,
}
local MIN_FRAME_SIZE = { width = 575, height = 400 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function MailingUI.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "mailingUIContext", "showDefault")
		:AddKey("global", "mailingUIContext", "frame")
	private.FSMCreate()
end

function MailingUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function MailingUI.RegisterTopLevelPage(name, callback)
	tinsert(private.topLevelPages, { name = name, callback = callback })
end

function MailingUI.IsVisible()
	return private.isVisible
end

function MailingUI.SetSelectedTab(buttonText, redraw)
	private.frame:SetSelectedNavButton(buttonText, redraw)
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing")
	-- Always show the Inbox first
	private.settings.frame.page = 1
	local frame = UIElements.New("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetSettingsContext(private.settings, "frame")
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetStrata("HIGH")
		:AddSwitchButton(private.SwitchBtnOnClick)
		:SetScript("OnHide", private.BaseFrameOnHide)

	for _, info in ipairs(private.topLevelPages) do
		frame:AddNavButton(info.name, info.callback)
	end

	private.frame = frame

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide()
	TSM.UI.AnalyticsRecordClose("mailing")
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.SwitchBtnOnClick(button)
	private.settings.showDefault = button ~= private.defaultUISwitchBtn
	private.fsm:ProcessEvent("EV_SWITCH_BTN_CLICKED")
end

function private.SwitchButtonOnEnter(button)
	button:SetTextColor("TEXT")
		:Draw()
end

function private.SwitchButtonOnLeave(button)
	button:SetTextColor("TEXT_ALT")
		:Draw()
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local function MailShowDelayed()
		private.fsm:ProcessEvent("EV_MAIL_SHOW")
	end
	Event.Register("MAIL_SHOW", function()
		Delay.AfterFrame("MAIL_SHOW_DELAYED", 0, MailShowDelayed)
	end)
	Event.Register("MAIL_CLOSED", function()
		private.fsm:ProcessEvent("EV_MAIL_CLOSED")
	end)

	MailFrame:UnregisterEvent("MAIL_SHOW")
	CancelEmote()

	local fsmContext = {
		frame = nil,
	}

	ScriptWrapper.Set(MailFrame, "OnHide", function()
		private.fsm:ProcessEvent("EV_FRAME_HIDE")
	end)

	private.fsm = FSM.New("MAILING_UI")
		:AddState(FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not private.settings.showDefault)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_MAIL_SHOW", function(context)
				if private.settings.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				MailFrame_OnEvent(MailFrame, "MAIL_SHOW")

				if not private.defaultUISwitchBtn then
					private.defaultUISwitchBtn = UIElements.New("ActionButton", "switchBtn")
						:SetSize(60, TSM.IsWowClassic() and 16 or 15)
						:SetFont("BODY_BODY3")
						:AddAnchor("TOPRIGHT", TSM.IsWowClassic() and -26 or -27, TSM.IsWowClassic() and -3 or -4)
						:DisableClickCooldown()
						:SetText(L["TSM4"])
						:SetScript("OnClick", private.SwitchBtnOnClick)
						:SetScript("OnEnter", private.SwitchButtonOnEnter)
						:SetScript("OnLeave", private.SwitchButtonOnLeave)
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(MailFrame)
				end

				if isIgnored then
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				OpenMailFrame:Hide()
				CloseMail()

				return "ST_CLOSED"
			end)
			:AddEventTransition("EV_MAIL_CLOSED", "ST_CLOSED")
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				OpenMailFrame:Hide()
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				OpenAllBags()
				CheckInbox()
				DoEmote("READ", nil, true)
				HideUIPanel(MailFrame)

				assert(not context.frame)
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				context.frame:Draw()
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				private.isVisible = false
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				CancelEmote()
				CloseAllBags()
				CloseMail()

				return "ST_CLOSED"
			end)
			:AddEvent("EV_MAIL_SHOW", function(context)
				OpenAllBags()
				CheckInbox()

				if not context.frame then
					DoEmote("READ", nil, true)
					context.frame = private.CreateMainFrame()
					context.frame:Draw()
					private.isVisible = true
				end
			end)
			:AddEvent("EV_MAIL_CLOSED", function(context)
				CancelEmote()
				CloseAllBags()

				return "ST_CLOSED"
			end)
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_DEFAULT_OPEN"
			end)
		)
		:Init("ST_CLOSED", fsmContext)
end
