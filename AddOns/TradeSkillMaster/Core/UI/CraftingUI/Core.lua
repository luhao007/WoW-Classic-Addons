-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CraftingUI = TSM.UI:NewPackage("CraftingUI")
local L = TSM.Include("Locale").GetTable()
local FSM = TSM.Include("Util.FSM")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	topLevelPages = {},
	fsm = nil,
	craftOpen = nil,
	tradeSkillOpen = nil,
	defaultUISwitchBtn = nil,
	isVisible = false,
	apiCallbacks = {},
}
local MIN_FRAME_SIZE = { width = 650, height = 587 }
local BEAST_TRAINING_DE = "Bestienausbildung"
local BEAST_TRAINING_ES = "Entrenamiento de bestias"
local BEAST_TRAINING_RUS = "Воспитание питомца"
local IGNORED_PROFESSIONS = {
	[2787] = true, -- Abominable Stitching
	[7620] = true, -- Fishing Skills (shows up as Fishing)
	[53428] = true, -- Runeforging
	[158756] = true, -- Skinning Skills
	[193290] = true, -- Herbalism Skills
	[278910] = true, -- Archaeology
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function CraftingUI.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "craftingUIContext", "showDefault")
		:AddKey("global", "craftingUIContext", "frame")
	private.FSMCreate()
	TSM.Crafting.ProfessionScanner.SetDisabled(private.settings.showDefault)
end

function CraftingUI.OnDisable()
	-- hide the frame
	if private.isVisible then
		TSM.Crafting.ProfessionScanner.SetDisabled(false)
		private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
	end
end

function CraftingUI.RegisterTopLevelPage(name, callback)
	tinsert(private.topLevelPages, { name = name, callback = callback })
end

function CraftingUI.Toggle()
	private.settings.showDefault = false
	TSM.Crafting.ProfessionScanner.SetDisabled(false)
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function CraftingUI.IsProfessionIgnored(name, skillId)
	if TSM.IsWowClassic() then
		if name == GetSpellInfo(5149) or name == BEAST_TRAINING_DE or name == BEAST_TRAINING_ES or name == BEAST_TRAINING_RUS then -- Beast Training
			return true
		elseif name == GetSpellInfo(7620) then -- Fishing
			return true
		elseif name == GetSpellInfo(2366) then -- Herb Gathering
			return true
		elseif name == GetSpellInfo(8613) then -- Skinning
			return true
		end
	end
	for i in pairs(IGNORED_PROFESSIONS) do
		local ignoredName = GetSpellInfo(i)
		if ignoredName == name or IGNORED_PROFESSIONS[skillId] then
			return true
		end
	end
end

function CraftingUI.IsVisible()
	return private.isVisible
end

function CraftingUI.RegisterApiCallback(addonTag, func)
	if private.apiCallbacks[addonTag] then
		error("Callback already registered for addonTag: "..tostring(addonTag), 3)
	end
	private.apiCallbacks[addonTag] = func
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting")
	local frame = UIElements.New("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetSettingsContext(private.settings, "frame")
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetStrata("HIGH")
		:AddPlayerGold()
		:AddAppStatusIcon()
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
	TSM.UI.AnalyticsRecordClose("crafting")
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.SwitchBtnOnClick(button)
	private.settings.showDefault = button ~= private.defaultUISwitchBtn
	TSM.Crafting.ProfessionScanner.SetDisabled(private.settings.showDefault)
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
	if TSM.IsWowClassic() then
		Event.Register("CRAFT_SHOW", function()
			CloseTradeSkill()
			private.craftOpen = true
			TSM.Crafting.ProfessionState.SetCraftOpen(true)
			private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
		end)
		Event.Register("CRAFT_CLOSE", function()
			private.craftOpen = false
			TSM.Crafting.ProfessionState.SetCraftOpen(false)
			if not private.tradeSkillOpen then
				private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSED")
			end
		end)
	end
	Event.Register("TRADE_SKILL_SHOW", function()
		if TSM.IsWowClassic() then
			CloseCraft()
		end
		private.tradeSkillOpen = true
		private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
	end)
	Event.Register("TRADE_SKILL_CLOSE", function()
		private.tradeSkillOpen = false
		if not private.craftOpen then
			private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSED")
		end
	end)
	-- we'll implement UIParent's event handler directly when necessary for TRADE_SKILL_SHOW
	if TSM.IsWowClassic() then
		UIParent:UnregisterEvent("CRAFT_SHOW")
	end
	UIParent:UnregisterEvent("TRADE_SKILL_SHOW")

	local fsmContext = {
		frame = nil,
	}
	local function UpdateDefaultCraftButton()
		if CraftFrame and CraftCreateButton and private.craftOpen then
			CraftCreateButton:SetParent(CraftFrame)
			CraftCreateButton:ClearAllPoints()
			CraftCreateButton:SetPoint("CENTER", CraftFrame, "TOPLEFT", 224, -422)
			CraftCreateButton:SetFrameLevel(2)
			CraftCreateButton:EnableDrawLayer("BACKGROUND")
			CraftCreateButton:EnableDrawLayer("ARTWORK")
			CraftCreateButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
			CraftCreateButton:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		end
	end
	local function DefaultFrameOnHide()
		private.fsm:ProcessEvent("EV_FRAME_HIDE")
	end
	private.fsm = FSM.New("CRAFTING_UI")
		:AddState(FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not private.settings.showDefault)
				TSM.Crafting.ProfessionScanner.SetDisabled(false)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				TSM.Crafting.ProfessionScanner.SetDisabled(private.settings.showDefault)
				local name, skillId = TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()
				if CraftingUI.IsProfessionIgnored(name, skillId) then
					return "ST_DEFAULT_OPEN", true
				elseif private.settings.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				if private.craftOpen then
					UIParent_OnEvent(UIParent, "CRAFT_SHOW")
					UpdateDefaultCraftButton()
				else
					UIParent_OnEvent(UIParent, "TRADE_SKILL_SHOW")
				end
				local defaultFrame = TSM.IsWowClassic() and TradeSkillFrame or ProfessionsFrame
				if not private.defaultUISwitchBtn then
					private.defaultUISwitchBtn = UIElements.New("ActionButton", "switchBtn")
						:SetSize(60, TSM.IsWowClassic() and 16 or 15)
						:SetFont("BODY_BODY3_MEDIUM")
						:AddAnchor("TOPRIGHT", TSM.IsWowClassic() and -60 or -27, TSM.IsWowClassic() and -16 or -4)
						:SetRelativeLevel(TSM.IsWowClassic() and 3 or 600)
						:DisableClickCooldown()
						:SetText(L["TSM4"])
						:SetScript("OnClick", private.SwitchBtnOnClick)
						:SetScript("OnEnter", private.SwitchButtonOnEnter)
						:SetScript("OnLeave", private.SwitchButtonOnLeave)
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(defaultFrame)
				end
				private.defaultUISwitchBtn:_GetBaseFrame():SetParent(private.craftOpen and CraftFrame or defaultFrame)
				if isIgnored then
					TSM.Crafting.ProfessionScanner.SetDisabled(true)
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
				if private.craftOpen then
					ScriptWrapper.Set(CraftFrame, "OnHide", DefaultFrameOnHide)
				else
					ScriptWrapper.Set(defaultFrame, "OnHide", DefaultFrameOnHide)
				end
				if not TSM.IsWowClassic() then
					local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
					if TSM.Crafting.ProfessionUtil.IsDataStable() and not TSM.Crafting.ProfessionUtil.IsGuildProfession() and (not linked or (linked and linkedName == UnitName("player"))) then
						defaultFrame:OnEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
						defaultFrame:OnEvent("TRADE_SKILL_LIST_UPDATE")
					end
				end
			end)
			:SetOnExit(function(context)
				local defaultFrame = TSM.IsWowClassic() and TradeSkillFrame or ProfessionsFrame
				if private.craftOpen then
					if CraftFrame then
						ScriptWrapper.Clear(CraftFrame, "OnHide")
						HideUIPanel(CraftFrame)
					end
				else
					if defaultFrame then
						ScriptWrapper.Clear(defaultFrame, "OnHide")
						HideUIPanel(defaultFrame)
					end
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill(false, private.craftOpen)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				if CraftingUI.IsProfessionIgnored(TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()) then
					return "ST_DEFAULT_OPEN", true
				else
					if private.settings.showDefault then
						return "ST_DEFAULT_OPEN"
					else
						TSM.Crafting.ProfessionScanner.SetDisabled(private.settings.showDefault)
						return "ST_FRAME_OPEN"
					end
				end
			end)
			:AddEventTransition("EV_TRADE_SKILL_CLOSED", "ST_CLOSED")
			:AddEventTransition("EV_SWITCH_BTN_CLICKED", "ST_FRAME_OPEN")
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				assert(not context.frame)
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				if TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo() then
					context.frame:GetElement("titleFrame.switchBtn"):Show()
				else
					context.frame:GetElement("titleFrame.switchBtn"):Hide()
				end
				context.frame:Draw()
				private.isVisible = true
				for addonTag, func in pairs(private.apiCallbacks) do
					local apiFuncStartTime = debugprofilestop()
					func(true, context.frame:_GetBaseFrame())
					Log.Info("API function (%s) took %d ms", addonTag, floor(debugprofilestop() - apiFuncStartTime + 0.5))
				end
			end)
			:SetOnExit(function(context)
				context.frame:Hide()
				context.frame:Release()
				context.frame = nil
				private.isVisible = false
				if TSM.IsWowClassic() then
					UpdateDefaultCraftButton()
				end
				for addonTag, func in pairs(private.apiCallbacks) do
					local apiFuncStartTime = debugprofilestop()
					func(false)
					Log.Info("API function (%s) took %d ms", addonTag, floor(debugprofilestop() - apiFuncStartTime + 0.5))
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill(true)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				if CraftingUI.IsProfessionIgnored(TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()) then
					return "ST_DEFAULT_OPEN", true
				end
				context.frame:GetElement("titleFrame.switchBtn"):Show()
				context.frame:GetElement("titleFrame"):Draw()
			end)
			:AddEventTransition("EV_TRADE_SKILL_CLOSED", "ST_CLOSED")
			:AddEventTransition("EV_SWITCH_BTN_CLICKED", "ST_DEFAULT_OPEN")
			:AddEventTransition("EV_FRAME_TOGGLE", "ST_CLOSED")
		)
		:Init("ST_CLOSED", fsmContext)
end
