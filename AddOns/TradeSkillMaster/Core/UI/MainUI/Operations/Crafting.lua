-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.MainUI.Operations:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local UIElements = TSM.Include("UI.UIElements")
local private = {
	currentOperationName = nil,
}
local BAD_CRAFT_VALUE_PRICE_SOURCES = {
	crafting = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Crafting", private.GetCraftingOperationSettings)
end



-- ============================================================================
-- Crafting Operation Settings UI
-- ============================================================================

function private.GetCraftingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "crafting")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	local frame = UIElements.New("ScrollFrame", "settings")
		:SetPadding(8, 8, 8, 0)
		:AddChild(TSM.MainUI.Operations.CreateExpandableSection("Crafting", "restockQuantity", L["Restock Options"], L["Adjust how crafted items are restocked."])
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("minRestock", L["Min restock quantity"])
				:SetLayout("VERTICAL")
				:SetHeight(48)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Frame", "content")
					:SetLayout("HORIZONTAL")
					:SetHeight(24)
					:AddChild(UIElements.New("Input", "input")
						:SetMargin(0, 8, 0, 0)
						:SetBackgroundColor("ACTIVE_BG")
						:SetValidateFunc("CUSTOM_PRICE")
						:SetSettingInfo(operation, "minRestock")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "minRestock"))
					)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY3")
						:SetTextColor(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "minRestock") and "TEXT_DISABLED" or "TEXT")
						:SetFormattedText(L["Supported range: %d - %d"], TSM.Operations.Crafting.GetRestockRange())
					)
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("maxRestock", L["Max restock quantity"])
				:SetLayout("VERTICAL")
				:SetHeight(48)
				:SetMargin(0, 0, 0, 12)
				:AddChild(UIElements.New("Frame", "content")
					:SetLayout("HORIZONTAL")
					:SetHeight(24)
					:AddChild(UIElements.New("Input", "input")
						:SetMargin(0, 8, 0, 0)
						:SetBackgroundColor("ACTIVE_BG")
						:SetValidateFunc("CUSTOM_PRICE")
						:SetSettingInfo(operation, "maxRestock")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "maxRestock"))
					)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY3")
						:SetTextColor(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "maxRestock") and "TEXT_DISABLED" or "TEXT")
						:SetFormattedText(L["Supported range: %d - %d"], TSM.Operations.Crafting.GetRestockRange())
					)
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("minProfit", L["Set min profit"], nil, "minProfitToggle")
				:SetLayout("VERTICAL")
				:SetHeight(42)
				:AddChild(UIElements.New("ToggleOnOff", "toggle")
					:SetHeight(18)
					:SetValue(operation.minProfit ~= "")
					:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "minProfit"))
					:SetScript("OnValueChanged", private.MinProfitToggleOnValueChanged)
				)
			)
		)
		:AddChild(TSM.MainUI.Operations.CreateExpandableSection("Crafting", "priceSettings", L["Crafting Value"], L["Adjust how TSM values crafted items when calculating profit."])
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("craftPriceMethod", L["Override default craft value"], nil, "craftPriceMethodToggle")
				:SetLayout("VERTICAL")
				:SetHeight(42)
				:AddChild(UIElements.New("ToggleOnOff", "toggle")
					:SetHeight(18)
					:SetValue(operation.craftPriceMethod ~= "")
					:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "craftPriceMethod"))
					:SetScript("OnValueChanged", private.CraftPriceToggleOnValueChanged)
				)
			)
		)
		:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Crafting", private.currentOperationName))

	if operation.minProfit ~= "" then
		frame:GetElement("restockQuantity.content.minProfitToggle"):SetMargin(0, 0, 0, 12)
		frame:GetElement("restockQuantity"):AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("minProfit", L["Min profit amount"], 80))
	end
	if operation.craftPriceMethod ~= "" then
		frame:GetElement("priceSettings.content.craftPriceMethodToggle"):SetMargin(0, 0, 0, 12)
		frame:GetElement("priceSettings"):AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("craftPriceMethod", L["Craft Value"], 80, BAD_CRAFT_VALUE_PRICE_SOURCES, TSM.db.global.craftingOptions.defaultCraftPriceMethod))
	end

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.MinProfitToggleOnValueChanged(toggle, value)
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	local defaultValue = TSM.Operations.GetSettingDefault("Crafting", "minProfit")
	operation.minProfit = value and defaultValue or ""
	local settingsFrame = toggle:GetParentElement():GetParentElement()
	if value then
		settingsFrame:GetElement("minProfitToggle"):SetMargin(0, 0, 0, 12)
		settingsFrame:GetParentElement():AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("minProfit", L["Min profit amount"], 80))
	else
		settingsFrame:GetElement("minProfitToggle"):SetMargin(0, 0, 0, 0)
		local linkedPriceLine = settingsFrame:GetElement("minProfit")
		settingsFrame:RemoveChild(linkedPriceLine)
		linkedPriceLine:Release()
	end
	settingsFrame:GetParentElement():GetParentElement():Draw()
end

function private.CraftPriceToggleOnValueChanged(toggle, value)
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	operation.craftPriceMethod = value and TSM.db.global.craftingOptions.defaultCraftPriceMethod or ""
	local settingsFrame = toggle:GetParentElement():GetParentElement()
	if value then
		settingsFrame:GetElement("craftPriceMethodToggle"):SetMargin(0, 0, 0, 12)
		settingsFrame:GetParentElement():AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("craftPriceMethod", L["Craft Value"], 80, BAD_CRAFT_VALUE_PRICE_SOURCES, TSM.db.global.craftingOptions.defaultCraftPriceMethod))
	else
		settingsFrame:GetElement("craftPriceMethodToggle"):SetMargin(0, 0, 0, 0)
		local linkedPriceLine = settingsFrame:GetElement("craftPriceMethod")
		settingsFrame:RemoveChild(linkedPriceLine)
		linkedPriceLine:Release()
	end
	settingsFrame:GetParentElement():GetParentElement():Draw()
end
