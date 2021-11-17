-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local VendoringUI = TSM.UI:NewPackage("VendoringUI")
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local Event = TSM.Include("Util.Event")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	topLevelPages = {},
	fsm = nil,
	defaultUISwitchBtn = nil,
	isVisible = false,
}
local MIN_FRAME_SIZE = { width = 560, height = 500 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function VendoringUI.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "vendoringUIContext", "showDefault")
		:AddKey("global", "vendoringUIContext", "frame")
	private.FSMCreate()
end

function VendoringUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function VendoringUI.RegisterTopLevelPage(name, callback)
	tinsert(private.topLevelPages, { name = name, callback = callback })
end

function VendoringUI.IsVisible()
	return private.isVisible
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("vendoring")
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

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide()
	TSM.UI.AnalyticsRecordClose("vendoring")
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
	local function MerchantShowDelayed()
		private.fsm:ProcessEvent("EV_MERCHANT_SHOW")
	end
	local function CurrencyUpdate()
		private.fsm:ProcessEvent("EV_CURRENCY_UPDATE")
	end
	Event.Register("MERCHANT_SHOW", function()
		Delay.AfterFrame("MERCHANT_SHOW_DELAYED", 0, MerchantShowDelayed)
	end)
	Event.Register("MERCHANT_CLOSED", function()
		private.fsm:ProcessEvent("EV_MERCHANT_CLOSED")
	end)

	local fsmContext = {
		frame = nil,
		defaultPoint = nil,
	}
	private.fsm = FSM.New("MERCHANT_UI")
		:AddState(FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not private.settings.showDefault)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_MERCHANT_SHOW", function(context)
				if private.settings.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				if not private.defaultUISwitchBtn then
					private.defaultUISwitchBtn = UIElements.New("ActionButton", "switchBtn")
						:SetSize(60, TSM.IsWowClassic() and 16 or 15)
						:AddAnchor("TOPRIGHT", TSM.IsWowClassic() and -26 or -27, TSM.IsWowClassic() and -3 or -4)
						:SetFont("BODY_BODY3_MEDIUM")
						:DisableClickCooldown()
						:SetText(L["TSM4"])
						:SetScript("OnClick", private.SwitchBtnOnClick)
						:SetScript("OnEnter", private.SwitchButtonOnEnter)
						:SetScript("OnLeave", private.SwitchButtonOnLeave)
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(MerchantFrame)
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
				CloseMerchant()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_MERCHANT_SHOW", MerchantFrame_Update)
			:AddEventTransition("EV_MERCHANT_CLOSED", "ST_CLOSED")
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				assert(not context.frame)
				if not context.defaultPoint then
					context.defaultPoint = { MerchantFrame:GetPoint(1) }
				end
				MerchantFrame:ClearAllPoints()
				MerchantFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100000, 100000)
				OpenAllBags()
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				context.frame:GetElement("titleFrame.switchBtn"):Show()
				context.frame:Draw()
				if not TSM.IsWowClassic() then
					Event.Register("CURRENCY_DISPLAY_UPDATE", CurrencyUpdate)
				end
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				CloseAllBags()
				MerchantFrame:ClearAllPoints()
				local point, region, relativePoint, x, y = unpack(context.defaultPoint)
				if point and region and relativePoint and x and y then
					MerchantFrame:SetPoint(point, region, relativePoint, x, y)
				else
					MerchantFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -116)
				end
				if not TSM.IsWowClassic() then
					Event.Unregister("CURRENCY_DISPLAY_UPDATE", CurrencyUpdate)
				end
				private.isVisible = false
				context.frame:Hide()
				context.frame:Release()
				context.frame = nil
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_CURRENCY_UPDATE", function(context)
				TSM.UI.VendoringUI.Buy.UpdateCurrency(context.frame)
			end)
			:AddEvent("EV_FRAME_HIDE", function(context)
				CloseMerchant()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_MERCHANT_CLOSED", function(context)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_DEFAULT_OPEN"
			end)
		)
		:Init("ST_CLOSED", fsmContext)
end
