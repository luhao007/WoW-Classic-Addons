-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMWoW = select(2, ...).LibTSMWoW
local Merchant = LibTSMWoW:Init("API.Merchant")
local ClientInfo = LibTSMWoW:Include("Util.ClientInfo")



-- ============================================================================
-- Module Functions
-- ============================================================================

---Gets all currencies (by ID) used by the merchant.
---@return number ...
function Merchant.GetCurrencies()
	return GetMerchantCurrencies()
end

---Gets the number of available merchant items.
---@return number
function Merchant.GetNumItems()
	return GetMerchantNumItems()
end

---Gets the item link.
---@param index number The index
---@return string?
function Merchant.GetItemLink(index)
	return GetMerchantItemLink(index)
end

---Gets info about a merchant item.
---@param index number The index
---@return number price
---@return number stackSize
---@return number numAvailable
function Merchant.GetItemInfo(index)
	local _, _, price, stackSize, numAvailable = GetMerchantItemInfo(index)
	return price, stackSize, numAvailable
end

---Gets the max stack size that can be bought of an item.
---@return number
function Merchant.GetItemMaxStack(index)
	return GetMerchantItemMaxStack(index)
end

---Gets the number of extended cost items.
---@param index number The index
---@return number
function Merchant.GetNumCostItems(index)
	return GetMerchantItemCostInfo(index)
end

---Gets info about an extended cost item.
---@param index number The index
---@param costIndex number The cost index
---@return string? itemLink
---@return number quantity
function Merchant.GetCostItemInfo(index, costIndex)
	local _, quantity, itemLink = GetMerchantItemCostItem(index, costIndex)
	return itemLink, quantity
end

---Purchase an item from the merchant.
---@param index number The index
---@param quantity number Quantity to buy
function Merchant.BuyItem(index, quantity)
	BuyMerchantItem(index, quantity)
end

---Register a secure hook function for when an item is bought.
---@param func function
function Merchant.SecureHookBuyItem(func)
	hooksecurefunc("BuyMerchantItem", func)
end

---Gets the number of buyback items.
---@return number
function Merchant.GetNumBuybackItems()
	return GetNumBuybackItems()
end

---Gets info about a buyback item.
---@param index number The index
---@return number price
---@return number quantity
function Merchant.GetBuybackItemInfo(index)
	local _, _, price, quantity = GetBuybackItemInfo(index)
	return price, quantity
end

---Gets the buyback item link.
---@param index number The index
---@return string?
function Merchant.GetBuybackItemLink(index)
	return GetBuybackItemLink(index)
end

---Buys back an item from the merchant.
---@param index number The index
function Merchant.BuybackItem(index)
	BuybackItem(index)
end

---Register a secure hook function for when a buyback item is bought.
---@param func function
function Merchant.SecureHookBuybackItem(func)
	hooksecurefunc("BuybackItem", func)
end

---Returns whether or not the merchant can repair.
---@return boolean
function Merchant.CanRepair()
	return CanMerchantRepair() and true or false
end

---Returns whether or not the merchant can repair from the guild bank.
---@return boolean
function Merchant.CanGuildBankRepair()
	return ClientInfo.HasFeature(ClientInfo.FEATURES.GUILD_BANK) and CanGuildBankRepair() and true or false
end

---Gets the repair all cost and whether or not the player needs to repair.
---@return number cost
---@return boolean needsRepair
function Merchant.GetRepairAllCost()
	return GetRepairAllCost()
end

---Performs a repair.
---@param fromGuildBank? boolean Repair from the guild bank
function Merchant.RepairAllItems(fromGuildBank)
	RepairAllItems(fromGuildBank)
end
