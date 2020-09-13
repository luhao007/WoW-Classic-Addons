-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.MainUI.Settings:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local PlayerInfo = TSM.Include("Service.PlayerInfo")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	altCharacters = {},
	altGuilds = {},
}
local BAD_MAT_PRICE_SOURCES = {
	matprice = true,
}
local BAD_CRAFT_VALUE_PRICE_SOURCES = {
	crafting = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Crafting"], "middle", private.GetCraftingSettingsFrame)
end



-- ============================================================================
-- Crafting Settings UI
-- ============================================================================

function private.GetCraftingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "crafting")
	wipe(private.altCharacters)
	wipe(private.altGuilds)
	for _, character in PlayerInfo.CharacterIterator(true) do
		tinsert(private.altCharacters, character)
	end
	for name in PlayerInfo.GuildIterator() do
		tinsert(private.altGuilds, name)
	end

	return UIElements.New("ScrollFrame", "craftingSettings")
		:SetPadding(8, 8, 8, 0)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Crafting", "inventory", L["Inventory Options"], "")
			:AddChild(UIElements.New("Frame", "inventoryOptionsLabels")
				:SetLayout("HORIZONTAL")
				:SetMargin(0, 0, 0, 4)
				:SetHeight(20)
				:AddChild(UIElements.New("Text", "label")
					:SetMargin(0, 12, 0, 0)
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Ignore Characters"])
				)
				:AddChild(UIElements.New("Text", "label")
					:SetFont("BODY_BODY2_MEDIUM")
					:SetText(L["Ignore Guilds"])
				)
			)
			:AddChild(UIElements.New("Frame", "inventoryOptionsDropdowns")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:AddChild(UIElements.New("MultiselectionDropdown", "charDropdown")
					:SetMargin(0, 12, 0, 0)
					:SetItems(private.altCharacters, private.altCharacters)
					:SetSettingInfo(TSM.db.global.craftingOptions, "ignoreCharacters")
					:SetSelectionText(L["No Characters"], L["%d Characters"], L["All Characters"])
				)
				:AddChild(UIElements.New("MultiselectionDropdown", "guildDropdown")
					:SetItems(private.altGuilds, private.altGuilds)
					:SetSettingInfo(TSM.db.global.craftingOptions, "ignoreGuilds")
					:SetSelectionText(L["No Guilds"], L["%d Guilds"], L["All Guilds"])
				)
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Crafting", "price", L["Default price configuration"], "")
			:AddChild(UIElements.New("Text", "matCostLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetTextColor("TEXT_ALT")
				:SetText(L["Default material cost method"])
			)
			:AddChild(UIElements.New("MultiLineInput", "matCostInput")
				:SetHeight(70)
				:SetMargin(0, 0, 0, 12)
				:SetValidateFunc("CUSTOM_PRICE", BAD_MAT_PRICE_SOURCES)
				:SetSettingInfo(TSM.db.global.craftingOptions, "defaultMatCostMethod")
			)
			:AddChild(UIElements.New("Text", "craftValueLabel")
				:SetHeight(20)
				:SetMargin(0, 0, 0, 4)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetTextColor("TEXT_ALT")
				:SetText(L["Default craft value method"])
			)
			:AddChild(UIElements.New("MultiLineInput", "matCostInput")
				:SetHeight(70)
				:SetValidateFunc("CUSTOM_PRICE", BAD_CRAFT_VALUE_PRICE_SOURCES)
				:SetSettingInfo(TSM.db.global.craftingOptions, "defaultCraftPriceMethod")
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Crafting", "cooldowns", L["Ignored Cooldowns"], L["Use this list to manage what cooldowns you'd like TSM to ignore from crafting."])
			:AddChild(UIElements.New("QueryScrollingTable", "items")
				:SetHeight(126)
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitle(L["Cooldown"])
						:SetFont("BODY_BODY3")
						:SetJustifyH("LEFT")
						:SetTextInfo(nil, private.CooldownGetText)
						:DisableHiding()
						:Commit()
					:Commit()
				:SetQuery(TSM.Crafting.CreateIgnoredCooldownQuery())
				:SetAutoReleaseQuery(true)
				:SetSelectionDisabled(true)
				:SetScript("OnRowClick", private.IgnoredCooldownOnRowClick)
			)
		)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CooldownGetText(row)
	return row:GetField("characterKey").." - "..TSM.Crafting.GetName(row:GetField("spellId"))
end

function private.IgnoredCooldownOnRowClick(_, row)
	TSM.Crafting.RemoveIgnoredCooldown(row:GetFields("characterKey", "spellId"))
end
