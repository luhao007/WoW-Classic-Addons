-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.MainUI.Settings:NewPackage("Shopping")
local L = TSM.Include("Locale").GetTable()
local Sound = TSM.Include("Util.Sound")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	sounds = {},
	soundkeys = {},
}
local MAX_ITEM_LEVEL = 500



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Browse / Sniper"], "middle", private.GetShoppingSettingsFrame)
	for key, name in pairs(Sound.GetSounds()) do
		tinsert(private.sounds, name)
		tinsert(private.soundkeys, key)
	end
end



-- ============================================================================
-- Shopping Settings UI
-- ============================================================================

function private.GetShoppingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "shopping")
	return UIElements.New("ScrollFrame", "shoppingSettings")
		:SetPadding(8, 8, 8, 0)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Shopping", "general", L["General Options"], L["Some general Browse/Sniper options are below."])
			:AddChild(UIElements.New("Frame", "focusFrame")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Checkbox", "checkbox")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Auto-focus browse search input"])
					:SetSettingInfo(TSM.db.global.shoppingOptions, "searchAutoFocus")
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
			:AddChild(TSM.MainUI.Settings.CreateInputWithReset("marketValueSourceField", L["Market value price source"], "global.shoppingOptions.pctSource")
				:SetMargin(0, 0, 0, 12)
			)
			:AddChild(TSM.MainUI.Settings.CreateInputWithReset("buyoutConfirmationAlert", L["Buyout confirmation alert"], "global.shoppingOptions.buyoutAlertSource")
				:SetMargin(0, 0, 0, 12)
			)
			:AddChild(UIElements.New("Frame", "showConfirmFrame")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:AddChild(UIElements.New("Checkbox", "showConfirm")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetCheckboxPosition("LEFT")
					:SetSettingInfo(TSM.db.global.shoppingOptions, "buyoutConfirm")
					:SetText(L["Show confirmation alert if buyout is above the alert price"])
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Shopping", "disenchant", L["Disenchant Search Options"], L["Some options for the Disenchant Search are below."])
			:AddChild(UIElements.New("Text", "minLevelLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetText(L["Minimum disenchant level"])
			)
			:AddChild(UIElements.New("Frame", "minLevelInput")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Input", "input")
					:SetMargin(0, 8, 0, 0)
					:SetBackgroundColor("ACTIVE_BG")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetValidateFunc("NUMBER", "0:"..MAX_ITEM_LEVEL)
					:SetSettingInfo(TSM.db.global.shoppingOptions, "minDeSearchLvl")
				)
				:AddChild(UIElements.New("Text", "rangeText")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY3")
					:SetText(format(L["(minimum 0 - maximum %d)"], MAX_ITEM_LEVEL))
				)
			)
			:AddChild(UIElements.New("Text", "maxLevelLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetText(L["Maximum disenchant level"])
			)
			:AddChild(UIElements.New("Frame", "maxLevelInput")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Input", "input")
					:SetMargin(0, 8, 0, 0)
					:SetBackgroundColor("ACTIVE_BG")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetValidateFunc("NUMBER", "0:"..MAX_ITEM_LEVEL)
					:SetSettingInfo(TSM.db.global.shoppingOptions, "maxDeSearchLvl")
				)
				:AddChild(UIElements.New("Text", "rangeText")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY3")
					:SetText(format(L["(minimum 0 - maximum %d)"], MAX_ITEM_LEVEL))
				)
			)
			:AddChild(UIElements.New("Text", "pctLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetText(L["Maximum disenchant search percent"])
			)
			:AddChild(UIElements.New("Frame", "pctInput")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:AddChild(UIElements.New("Input", "input")
					:SetMargin(0, 8, 0, 0)
					:SetBackgroundColor("ACTIVE_BG")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetValidateFunc("NUMBER", "0:100")
					:SetSettingInfo(TSM.db.global.shoppingOptions, "maxDeSearchPercent")
				)
				:AddChild(UIElements.New("Text", "rangeText")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY3")
					:SetText(format(L["(minimum 0 - maximum %d)"], 100))
				)
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Shopping", "sniper", L["Sniper Options"], L["Options specific to Sniper are below."])
			:AddChild(UIElements.New("Text", "soundLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetText(L["Found auction sound"])
			)
			:AddChild(UIElements.New("SelectionDropdown", "soundDrodown")
				:SetHeight(24)
				:SetItems(private.sounds, private.soundkeys)
				:SetSettingInfo(TSM.db.global.sniperOptions, "sniperSound")
				:SetScript("OnSelectionChanged", private.SoundOnSelectionChanged)
			)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SoundOnSelectionChanged(self)
	Sound.PlaySound(self:GetSelectedItemKey())
end
