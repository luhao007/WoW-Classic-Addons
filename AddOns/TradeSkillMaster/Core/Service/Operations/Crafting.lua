-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.Operations:NewPackage("Crafting")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	minRestock = { type = "number", default = 1 },
	maxRestock = { type = "number", default = 3 },
	minProfit = { type = "string", default = "100g" },
	craftPriceMethod = { type = "string", default = "" },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.Operations.Register("Crafting", L["Crafting"], OPERATION_INFO, 1, private.GetOperationInfo)
	for _, name in TSM.Operations.OperationIterator("Crafting") do
		local operation = TSM.Operations.GetSettings("Crafting", name)
		if operation.craftPriceMethod ~= "" then
			local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(operation.craftPriceMethod, "crafting")
			if not isValid then
				TSM:Printf(L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"], name, err)
				operation.craftPriceMethod = ""
			end
		end
	end
end

function Crafting.HasOperation(itemString)
	return private.GetOperationSettings(itemString) and true or false
end

function Crafting.IsValid(itemString)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
	local operationName, operationSettings = TSM.Operations.GetFirstOperationByItem("Crafting", itemString)
	if not operationSettings then
		return false
	end
	if operationSettings.minRestock > operationSettings.maxRestock then
		-- invalid cause min > max restock quantity (shouldn't happen)
		return false, format(L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."], operationName, operationSettings.minRestock, operationSettings.maxRestock)
	end
	return true
end

function Crafting.GetMinProfit(itemString)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return false
	end
	if operationSettings.minProfit == "" then
		return false
	end
	return true, TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.minProfit, itemString)
end

function Crafting.GetRestockQuantity(itemString, haveQuantity)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return 0
	end
	local neededQuantity = operationSettings.maxRestock - haveQuantity
	if neededQuantity <= 0 then
		-- don't need to queue any
		return 0
	elseif neededQuantity < operationSettings.minRestock then
		-- we're below the min restock quantity
		return 0
	end
	return neededQuantity
end

function Crafting.GetCraftedItemValue(itemString)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return false
	end
	if operationSettings.craftPriceMethod == "" then
		return false
	end
	return true, TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.craftPriceMethod, itemString)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	if operationSettings.minProfit ~= "" then
		return format(L["Restocking to a max of %d (min of %d) with a min profit."], operationSettings.maxRestock, operationSettings.minRestock)
	else
		return format(L["Restocking to a max of %d (min of %d) with no min profit."], operationSettings.maxRestock, operationSettings.minRestock)
	end
end

function private.GetOperationSettings(itemString)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
	local operationName, operationSettings = TSM.Operations.GetFirstOperationByItem("Crafting", itemString)
	if not operationName then
		return
	end
	return operationSettings
end
