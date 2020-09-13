-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sniper = TSM.MainUI.Operations:NewPackage("Sniper")
local L = TSM.Include("Locale").GetTable()
local UIElements = TSM.Include("UI.UIElements")
local private = {
	currentOperationName = nil,
}
local BAD_PRICE_SOURCES = { sniperopmax = true }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Sniper.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Sniper", private.GetSniperOperationSettings)
end



-- ============================================================================
-- Sniper Operation Settings UI
-- ============================================================================

function private.GetSniperOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "sniper")
	private.currentOperationName = operationName
	return UIElements.New("ScrollFrame", "settings")
		:SetPadding(8, 8, 8, 0)
		:SetBackgroundColor("PRIMARY_BG")
		:AddChild(TSM.MainUI.Operations.CreateExpandableSection("Sniper", "settings", L["General Options"], L["Set what items are shown during a Sniper scan."])
			:AddChild(TSM.MainUI.Operations.CreateLinkedPriceInput("belowPrice", L["Maximum price"], 124, BAD_PRICE_SOURCES))
		)
		:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Sniper", private.currentOperationName))
end
