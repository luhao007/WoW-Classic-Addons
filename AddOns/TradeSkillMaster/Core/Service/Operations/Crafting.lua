-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.Operations:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local Log = TSM.Include("Util.Log")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {}
local OPERATION_INFO = {
	minRestock = { type = "number", default = 1 },
	maxRestock = { type = "number", default = 3 },
	minProfit = { type = "string", default = "100g" },
	craftPriceMethod = { type = "string", default = "" },
}
local BAD_CRAFTING_PRICE_SOURCES = {
	crafting = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.Operations.Register("Crafting", L["Crafting"], OPERATION_INFO, 1, private.GetOperationInfo)
	for _, name in TSM.Operations.OperationIterator("Crafting") do
		local operation = TSM.Operations.GetSettings("Crafting", name)
		if operation.craftPriceMethod ~= "" then
			local isValid, err = CustomPrice.Validate(operation.craftPriceMethod, BAD_CRAFTING_PRICE_SOURCES)
			if not isValid then
				Log.PrintfUser(L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"], name, err)
				operation.craftPriceMethod = ""
			end
		end
	end
end

function Crafting.HasOperation(itemString)
	return private.GetOperationSettings(itemString) and true or false
end

function Crafting.IsValid(itemString)
	itemString = TSM.Groups.TranslateItemString(itemString)
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
	return true, CustomPrice.GetValue(operationSettings.minProfit, itemString)
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
	return true, CustomPrice.GetValue(operationSettings.craftPriceMethod, itemString)
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
	itemString = TSM.Groups.TranslateItemString(itemString)
	local operationName, operationSettings = TSM.Operations.GetFirstOperationByItem("Crafting", itemString)
	if not operationName then
		return
	end
	return operationSettings
end
