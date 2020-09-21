-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Appearance = TSM.MainUI.Settings:NewPackage("Appearance")
local L = TSM.Include("Locale").GetTable()
local Theme = TSM.Include("Util.Theme")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	colorSetKeys = {},
	colorSetNames = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Appearance.OnInitialize()
	for _, key, name in TSM.UI.Util.ColorSetIterator() do
		tinsert(private.colorSetKeys, key)
		tinsert(private.colorSetNames, name)
	end
	TSM.MainUI.Settings.RegisterSettingPage(L["Appearance"], "middle", private.GetSettingsFrame)
end



-- ============================================================================
-- Appearance Settings UI
-- ============================================================================

function private.GetSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "appearance")
	return UIElements.New("ScrollFrame", "generalSettings")
		:SetPadding(8, 8, 8, 0)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Appearance", "appearance", L["General Options"], L["Some general appearance options are below."])
			:AddChild(UIElements.New("Frame", "content")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Checkbox", "minimapCheckbox")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Hide minimap icon"])
					:SetSettingInfo(TSM.db.global.coreOptions.minimapIcon, "hide")
					:SetScript("OnValueChanged", private.MinimapOnValueChanged)
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
			:AddChild(UIElements.New("Frame", "content")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Checkbox", "taskListLockCheckbox")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Lock task list's background"])
					:SetSettingInfo(TSM.db.global.appearanceOptions, "taskListBackgroundLock")
					:SetScript("OnValueChanged", private.TaskListLockOnValueChanged)
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
			:AddChild(UIElements.New("Frame", "content")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:AddChild(UIElements.New("Checkbox", "showTotalMoneyCheckbox")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Show total gold in header"])
					:SetSettingInfo(TSM.db.global.appearanceOptions, "showTotalMoney")
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
		)
		:AddChild(UIElements.New("Text", "label")
			:SetHeight(24)
			:SetMargin(12, 0, 4, 12)
			:SetFont("BODY_BODY1_BOLD")
			:SetText(L["Themes"])
		)
		:AddChild(UIElements.New("Frame", "theme")
			:SetLayout("FLOW")
			:AddChildrenWithFunction(private.AddTheme)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.MinimapOnValueChanged(_, value)
	if value then
		LibDBIcon:Hide("TradeSkillMaster")
	else
		LibDBIcon:Show("TradeSkillMaster")
	end
end

function private.TaskListLockOnValueChanged(_, value)
	TSM.db.global.appearanceOptions.taskListBackgroundLock = value
	if TSM.UI.TaskListUI.IsVisible() then
		TSM.UI.TaskListUI.UpdateFrame()
	end
end

function private.AddTheme(frame)
	for _, key, name in TSM.UI.Util.ColorSetIterator() do
		frame:AddChild(UIElements.New("Frame", name)
			:SetLayout("VERTICAL")
			:SetSize(198, 140)
			:SetPadding(0, 0, 12, 8)
			:SetMargin(0, 12, 0, 8)
			:SetBackgroundColor(Theme.GetColor("FRAME_BG", key), true)
			:SetBorderColor(Theme.GetColor("ACTIVE_BG_ALT", key))
			:SetContext(key)
			:AddChild(UIElements.New("Frame", "top")
				:SetLayout("HORIZONTAL")
				:SetHeight(36)
				:SetMargin(8, 8, 0, 12)
				:AddChild(UIElements.New("Frame", "left")
					:SetSize(36, 36)
					:SetMargin(0, 12, 0, 0)
					:SetBackgroundColor(Theme.GetColor("ACTIVE_BG_ALT", key), true)
				)
				:AddChild(UIElements.New("Frame", "right")
					:SetLayout("VERTICAL")
					:AddChild(UIElements.New("Frame", "line1")
						:SetHeight(12)
						:SetMargin(0, 0, 0, 12)
						:SetBackgroundColor(Theme.GetColor("ACTIVE_BG", key), true)
					)
					:AddChild(UIElements.New("Frame", "line2")
						:SetHeight(12)
						:SetBackgroundColor(Theme.GetColor("PRIMARY_BG_ALT", key), true)
					)
				)
			)
			:AddChild(UIElements.New("Frame", "line3")
				:SetMargin(8, 8, 0, 12)
				:SetBackgroundColor(Theme.GetColor("PRIMARY_BG", key), true)
			)
			:AddChild(UIElements.New("Texture", "divider")
				:SetHeight(1)
				:SetTexture(Theme.GetColor("ACTIVE_BG_ALT", key))
			)
			:AddChild(UIElements.New("Toggle", "toggle")
				:SetHeight(20)
				:SetMargin(8, 0, 8, 0)
				:SetFont("BODY_BODY2_MEDIUM")
				:AddOption(Theme.GetThemeName(key), TSM.db.global.appearanceOptions.colorSet == key)
				:SetScript("OnValueChanged", private.ThemeButtonOnClick)
			)
			:AddChildNoLayout(UIElements.New("Button", "btn")
				:AddAnchor("TOPLEFT")
				:AddAnchor("BOTTOMRIGHT")
				:SetScript("OnClick", private.ThemeButtonOnClick)
			)
		)
	end
end

function private.ThemeButtonOnClick(buttonToggle)
	local selectedKey = buttonToggle:GetParentElement():GetContext()
	for _, key, name in TSM.UI.Util.ColorSetIterator() do
		local toggle = buttonToggle:GetElement("__parent.__parent."..name..".toggle")
		if key == selectedKey then
			toggle:SetOption(name, true)
		else
			toggle:ClearOption(true)
		end
	end
	TSM.db.global.appearanceOptions.colorSet = selectedKey
	Theme.SetActiveColorSet(selectedKey)
end
