-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Buy = TSM.Vendoring:NewPackage("Buy")
local Database = TSM.Include("Util.Database")
local Delay = TSM.Include("Util.Delay")
local Event = TSM.Include("Util.Event")
local TempTable = TSM.Include("Util.TempTable")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	merchantDB = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Buy.OnInitialize()
	private.merchantDB = Database.NewSchema("MERCHANT")
		:AddUniqueNumberField("index")
		:AddStringField("itemString")
		:AddNumberField("price")
		:AddStringField("costItemString")
		:AddNumberField("stackSize")
		:AddNumberField("numAvailable")
		:Commit()
	Event.Register("MERCHANT_SHOW", private.MerchantShowEventHandler)
	Event.Register("MERCHANT_CLOSED", private.MerchantClosedEventHandler)
	Event.Register("MERCHANT_UPDATE", private.MerchantUpdateEventHandler)
end

function Buy.CreateMerchantQuery()
	return private.merchantDB:NewQuery()
end

function Buy.NeedsRepair()
	local _, needsRepair = GetRepairAllCost()
	return needsRepair
end

function Buy.CanGuildRepair()
	return Buy.NeedsRepair() and not TSM.IsWowClassic() and CanGuildBankRepair()
end

function Buy.DoGuildRepair()
	RepairAllItems(true)
end

function Buy.DoRepair()
	RepairAllItems()
end

function Buy.BuyItem(itemString, quantity)
	local query = Buy.CreateMerchantQuery()
		:Equal("itemString", itemString)
		:OrderBy("index", true)
	local row = query:GetFirstResultAndRelease()
	if not row then
		return
	end
	local index = row:GetField("index")
	local maxStack = GetMerchantItemMaxStack(index)
	quantity = min(quantity, private.GetMaxCanAfford(index))
	while quantity > 0 do
		BuyMerchantItem(index, min(quantity, maxStack))
		quantity = quantity - maxStack
	end
end

function Buy.BuyItemIndex(index, quantity)
	local maxStack = GetMerchantItemMaxStack(index)
	quantity = min(quantity, private.GetMaxCanAfford(index))
	while quantity > 0 do
		BuyMerchantItem(index, min(quantity, maxStack))
		quantity = quantity - maxStack
	end
end

function Buy.CanBuyItem(itemString)
	local query = Buy.CreateMerchantQuery()
		:Equal("itemString", itemString)
		:OrderBy("index", true)
	local row = query:GetFirstResultAndRelease()
	return row and true or false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MerchantShowEventHandler()
	Delay.AfterFrame("UPDATE_MERCHANT_DB", 1, private.UpdateMerchantDB)
end

function private.MerchantClosedEventHandler()
	Delay.Cancel("UPDATE_MERCHANT_DB")
	Delay.Cancel("RESCAN_MERCHANT_DB")
	private.merchantDB:Truncate()
end

function private.MerchantUpdateEventHandler()
	Delay.AfterFrame("UPDATE_MERCHANT_DB", 1, private.UpdateMerchantDB)
end

function private.UpdateMerchantDB()
	local needsRetry = false
	private.merchantDB:TruncateAndBulkInsertStart()
	for i = 1, GetMerchantNumItems() do
		local itemLink = GetMerchantItemLink(i)
		local itemString = ItemString.Get(itemLink)
		if itemString then
			ItemInfo.StoreItemInfoByLink(itemLink)
			local _, _, price, stackSize, numAvailable, _, _, extendedCost = GetMerchantItemInfo(i)
			local numAltCurrencies = GetMerchantItemCostInfo(i)
			-- bug with big keech vendor returning extendedCost = true for gold only items
			if numAltCurrencies == 0 then
				extendedCost = false
			end
			local costItemsStr = ""
			if extendedCost then
				assert(numAltCurrencies > 0)
				local costItems = TempTable.Acquire()
				for j = 1, numAltCurrencies do
					local _, costNum, costItemLink = GetMerchantItemCostItem(i, j)
					local costItemString = ItemString.Get(costItemLink)
					local texture = nil
					if not costItemLink then
						needsRetry = true
					elseif costItemString then
						texture = ItemInfo.GetTexture(costItemString)
					elseif strmatch(costItemLink, "currency:") then
						local _
						_, _, texture = GetCurrencyInfo(costItemLink)
					else
						error(format("Unknown item cost (%d, %d, %s)", i, costNum, tostring(costItemLink)))
					end
					tinsert(costItems, costNum.." |T"..(texture or "")..":12|t")
				end
				costItemsStr = table.concat(costItems, " ")
				TempTable.Release(costItems)
			end
			private.merchantDB:BulkInsertNewRow(i, itemString, price, costItemsStr, stackSize, numAvailable)
		end
	end
	private.merchantDB:BulkInsertEnd()

	if needsRetry then
		Log.Err("Failed to scan merchant")
		Delay.AfterTime("RESCAN_MERCHANT_DB", 0.2, private.UpdateMerchantDB)
	else
		Delay.Cancel("RESCAN_MERCHANT_DB")
	end
end

function private.GetMaxCanAfford(index)
	local maxCanAfford = math.huge
	local _, _, price, _, _, _, _, extendedCost = GetMerchantItemInfo(index)
	local numAltCurrencies = GetMerchantItemCostInfo(index)
	-- bug with big keech vendor returning extendedCost = true for gold only items
	if numAltCurrencies == 0 then
		extendedCost = false
	end

	-- check the price
	if price > 0 then
		maxCanAfford = min(floor(GetMoney() / price), maxCanAfford)
	end

	-- check the extended cost
	if extendedCost then
		assert(numAltCurrencies > 0)
		for i = 1, numAltCurrencies do
			local _, costNum, costItemLink, currencyName = GetMerchantItemCostItem(index, i)
			local costItemString = ItemString.Get(costItemLink)
			local costNumHave = nil
			if costItemString then
				costNumHave = TSMAPI_FOUR.Inventory.GetBagQuantity(costItemString) + TSMAPI_FOUR.Inventory.GetBankQuantity(costItemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(costItemString)
			elseif currencyName then
				for j = 1, GetCurrencyListSize() do
					local name, isHeader, _, _, _, count = GetCurrencyInfo(j)
					if not isHeader and name == currencyName then
						costNumHave = count
						break
					end
				end
			end
			if costNumHave then
				maxCanAfford = min(floor(costNumHave / costNum), maxCanAfford)
			end
		end
	end

	return maxCanAfford
end
