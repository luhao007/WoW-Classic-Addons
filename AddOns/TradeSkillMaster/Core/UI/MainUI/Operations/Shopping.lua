-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.MainUI.Operations:NewPackage("Shopping")
local L = TSM.Include("Locale").GetTable()
local UIElements = TSM.Include("UI.UIElements")
local private = {
	currentOperationName = nil,
}
local RESTOCK_SOURCES = { L["Alts"], L["Auctions"], BANK, GUILD }
local RESTOCK_SOURCES_KEYS = { "alts", "auctions", "bank", "guild" }
local BAD_PRICE_SOURCES = { shoppingopmax = true }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Shopping", private.GetShoppingOperationSettings)
end



-- ============================================================================
-- Shopping Operation Settings UI
-- ============================================================================

function private.GetShoppingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "shopping")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Shopping", private.currentOperationName)
	return UIElements.New("ScrollFrame", "settings")
		:SetPadding(8, 8, 8, 0)
		:SetBackgroundColor("PRIMARY_BG")
		:AddChild(TSM.MainUI.Operations.CreateExpandableSection("Shopping", "generalOptions", L["General Options"], L["Set what items are shown during a Shopping scan."])
			:AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("maxPrice", L["Maximum auction price"], 124, BAD_PRICE_SOURCES))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("showAboveMaxPrice", L["Show auctions above max price"])
				:SetLayout("VERTICAL")
				:SetHeight(48)
				:SetMargin(0, 0, 12, 12)
				:AddChild(UIElements.New("ToggleOnOff", "toggle")
					:SetHeight(18)
					:SetSettingInfo(operation, "showAboveMaxPrice")
					:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "showAboveMaxPrice"))
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restockQuantity", L["Maximum restock quantity"])
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
						:SetSettingInfo(operation, "restockQuantity")
						:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "restockQuantity"))
					)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY3")
						:SetTextColor(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "restockQuantity") and "TEXT_DISABLED" or "TEXT")
						:SetFormattedText(L["Supported range: %d - %d"], TSM.Operations.Shopping.GetRestockRange())
					)
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restockSources", L["Sources to include for restock"])
				:SetLayout("VERTICAL")
				:SetHeight(48)
				:AddChild(UIElements.New("MultiselectionDropdown", "dropdown")
					:SetHeight(24)
					:SetItems(RESTOCK_SOURCES, RESTOCK_SOURCES_KEYS)
					:SetSettingInfo(operation, "restockSources")
					:SetSelectionText(L["No Sources"], L["%d Sources"], L["All Sources"])
					:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "restockSources"))
				)
			)
		)
		:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Shopping", private.currentOperationName))
end
