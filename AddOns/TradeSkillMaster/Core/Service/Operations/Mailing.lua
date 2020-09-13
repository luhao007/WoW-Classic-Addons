-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mailing = TSM.Operations:NewPackage("Mailing")
local private = {}
local L = TSM.Include("Locale").GetTable()
local OPERATION_INFO = {
	maxQtyEnabled = { type = "boolean", default = false },
	maxQty = { type = "number", default = 10 },
	target = { type = "string", default = "" },
	restock = { type = "boolean", default = false },
	restockSources = { type = "table", default = { guild = false, bank = false } },
	keepQty = { type = "number", default = 0 },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mailing.OnInitialize()
	TSM.Operations.Register("Mailing", L["Mailing"], OPERATION_INFO, 50, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	if operationSettings.target == "" then
		return
	end

	if operationSettings.maxQtyEnabled then
		return format(L["Mailing up to %d to %s."], operationSettings.maxQty, operationSettings.target)
	else
		return format(L["Mailing all to %s."], operationSettings.target)
	end
end
