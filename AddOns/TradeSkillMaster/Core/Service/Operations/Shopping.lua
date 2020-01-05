-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.Operations:NewPackage("Shopping")
local private = {}
local L = TSM.Include("Locale").GetTable()
local CustomPrice = TSM.Include("Service.CustomPrice")
local OPERATION_INFO = {
	restockQuantity = { type = "number", default = 0 },
	maxPrice = { type = "string", default = "dbmarket" },
	evenStacks = { type = "boolean", default = false },
	showAboveMaxPrice = { type = "boolean", default = true },
	restockSources = { type = "table", default = { alts = false, auctions = false, bank = false, guild = false } },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.Operations.Register("Shopping", L["Shopping"], OPERATION_INFO, 1, private.GetOperationInfo)
end

function Shopping.GetMaxPrice(itemString)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return
	end
	return CustomPrice.GetValue(operationSettings.maxPrice, itemString)
end

function Shopping.ShouldShowAboveMaxPrice(itemString)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return
	end
	return operationSettings.showAboveMaxPrice
end

function Shopping.IsFiltered(itemString, stackSize, itemBuyout)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return true, false
	end

	if operationSettings.evenStacks and stackSize % 5 ~= 0 then
		return true, false
	end

	if not operationSettings.showAboveMaxPrice then
		local maxPrice = CustomPrice.GetValue(operationSettings.maxPrice, itemString)
		if not maxPrice or itemBuyout > maxPrice then
			return true, true
		end
	end

	return false, false
end

function Shopping.ShouldScanItem(itemString, minPrice)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return false
	end
	if operationSettings.evenStacks or operationSettings.showAboveMaxPrice then
		return true
	end
	local maxPrice = CustomPrice.GetValue(operationSettings.maxPrice, itemString)
	return minPrice <= (maxPrice or 0)
end

function Shopping.ValidAndGetRestockQuantity(itemString)
	local operationSettings = private.GetOperationSettings(itemString)
	if not operationSettings then
		return false, nil
	end
	local isValid, err = CustomPrice.Validate(operationSettings.maxPrice)
	if not isValid then
		return false, err
	end
	local maxQuantity = nil
	if operationSettings.restockQuantity > 0 then
		-- include mail and bags
		local numHave = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString) + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
		if operationSettings.restockSources.bank then
			numHave = numHave + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
		end
		if operationSettings.restockSources.guild then
			numHave = numHave + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString)
		end
		local _, numAlts, numAuctions = TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
		if operationSettings.restockSources.alts then
			numHave = numHave + numAlts
		end
		if operationSettings.restockSources.auctions then
			numHave = numHave + numAuctions
		end
		if numHave >= operationSettings.restockQuantity then
			return false, nil
		end
		maxQuantity = operationSettings.restockQuantity - numHave
	end
	if not operationSettings.showAboveMaxPrice and not CustomPrice.GetValue(operationSettings.maxPrice, itemString) then
		-- we're not showing auctions above the max price and the max price isn't valid for this item, so skip it
		return false, nil
	end
	return true, maxQuantity
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	if operationSettings.showAboveMaxPrice and operationSettings.evenStacks then
		return format(L["Shopping for even stacks including those above the max price"])
	elseif operationSettings.showAboveMaxPrice then
		return format(L["Shopping for auctions including those above the max price."])
	elseif operationSettings.evenStacks then
		return format(L["Shopping for even stacks with a max price set."])
	else
		return format(L["Shopping for auctions with a max price set."])
	end
end

function private.GetOperationSettings(itemString)
	itemString = TSM.Groups.TranslateItemString(itemString)
	local operationName, operationSettings = TSM.Operations.GetFirstOperationByItem("Shopping", itemString)
	if not operationName then
		return
	end
	return operationSettings
end
