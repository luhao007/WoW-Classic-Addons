-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Buy = TSM.Vendoring:NewPackage("Buy")
local Database = TSM.Include("Util.Database")
local Delay = TSM.Include("Util.Delay")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local Theme = TSM.Include("Util.Theme")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Inventory = TSM.Include("Service.Inventory")
local private = {
	merchantDB = nil,
	pendingIndex = nil,
	pendingQuantity = 0,
}
local FIRST_BUY_TIMEOUT = 5
local FIRST_BUY_TIMEOUT_PER_STACK = 1
local CONSECUTIVE_BUY_TIMEOUT = 5



-- ============================================================================
-- Module Functions
-- ============================================================================

function Buy.OnInitialize()
	private.merchantDB = Database.NewSchema("MERCHANT")
		:AddUniqueNumberField("index")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
		:AddNumberField("price")
		:AddStringField("costItemsText")
		:AddStringField("firstCostItemString")
		:AddNumberField("stackSize")
		:AddNumberField("numAvailable")
		:Commit()
	Event.Register("MERCHANT_SHOW", private.MerchantShowEventHandler)
	Event.Register("MERCHANT_CLOSED", private.MerchantClosedEventHandler)
	Event.Register("MERCHANT_UPDATE", private.MerchantUpdateEventHandler)
	Event.Register("CHAT_MSG_LOOT", private.ChatMsgLootEventHandler)
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

function Buy.GetMaxCanAfford(index)
	local maxCanAfford = math.huge
	local _, _, price, stackSize, _, _, _, extendedCost = GetMerchantItemInfo(index)
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
				costNumHave = Inventory.GetBagQuantity(costItemString) + Inventory.GetBankQuantity(costItemString) + Inventory.GetReagentBankQuantity(costItemString)
			elseif currencyName then
				local info = C_CurrencyInfo.GetCurrencyInfoFromLink(costItemLink)
				costNumHave = info.quantity
			end
			if costNumHave then
				maxCanAfford = min(floor(costNumHave / costNum), maxCanAfford)
			end
		end
	end

	return maxCanAfford * stackSize
end

function Buy.BuyItem(itemString, quantity)
	local index = private.GetFirstIndex(itemString)
	if not index then
		return
	end
	private.BuyIndex(index, quantity)
end

function Buy.BuyItemIndex(index, quantity)
	private.BuyIndex(index, quantity)
end

function Buy.CanBuyItem(itemString)
	local index = private.GetFirstIndex(itemString)
	return index and true or false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MerchantShowEventHandler()
	Delay.AfterFrame("UPDATE_MERCHANT_DB", 1, private.UpdateMerchantDB)
end

function private.MerchantClosedEventHandler()
	private.ClearPendingContext()
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
			local costItemsText, firstCostItemString = "", ""
			if extendedCost then
				assert(numAltCurrencies > 0)
				local costItems = TempTable.Acquire()
				for j = 1, numAltCurrencies do
					local _, costNum, costItemLink, currencyName = GetMerchantItemCostItem(i, j)
					local costItemString = ItemString.Get(costItemLink)
					local texture = nil
					if not costItemLink then
						needsRetry = true
					elseif costItemString then
						firstCostItemString = firstCostItemString ~= "" and firstCostItemString or costItemString
						texture = ItemInfo.GetTexture(costItemString)
					elseif not TSM.IsWowVanillaClassic() and strmatch(costItemLink, "currency:") then
						texture = C_CurrencyInfo.GetCurrencyInfoFromLink(costItemLink).iconFileID
						firstCostItemString = strmatch(costItemLink, "(currency:%d+)")
					else
						error(format("Unknown item cost (%d, %d, %s)", i, costNum, tostring(costItemLink)))
					end
					if TSM.Vendoring.Buy.GetMaxCanAfford(i) < stackSize then
						costNum = Theme.GetFeedbackColor("RED"):ColorText(costNum)
					end
					local suffix = (TSM.IsWowWrathClassic() and currencyName == HONOR_POINTS) and ":14:14:00:0:64:64:0:40:0:40|t" or ":12|t"
					tinsert(costItems, costNum.." |T"..(texture or "")..suffix)
				end
				costItemsText = table.concat(costItems, " ")
				TempTable.Release(costItems)
			end
			private.merchantDB:BulkInsertNewRow(i, itemString, price, costItemsText, firstCostItemString, stackSize, numAvailable)
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

function private.GetFirstIndex(itemString)
	local index = Buy.CreateMerchantQuery()
		:Equal("itemString", itemString)
		:OrderBy("index", true)
		:Select("index")
		:GetFirstResultAndRelease()
	if not index and ItemString.GetBaseFast(itemString) == itemString then
		index = Buy.CreateMerchantQuery()
			:Equal("baseItemString", itemString)
			:OrderBy("index", true)
			:Select("index")
			:GetFirstResultAndRelease()
	end
	return index
end

function private.BuyIndex(index, quantity)
	local maxStack = GetMerchantItemMaxStack(index)
	quantity = min(quantity, Buy.GetMaxCanAfford(index))
	if quantity == 0 then
		return
	end
	private.ClearPendingContext()
	private.pendingIndex = index
	local numStacks = 0
	while quantity > 0 do
		local buyQuantity = min(quantity, maxStack)
		BuyMerchantItem(index, buyQuantity)
		private.pendingQuantity = private.pendingQuantity + buyQuantity
		quantity = quantity - buyQuantity
		numStacks = numStacks + 1
	end
	Log.Info("Buying %d of %d (%d stacks)", private.pendingQuantity, index, numStacks)
	Delay.AfterTime("VENDORING_BUY_TIMEOUT", numStacks * FIRST_BUY_TIMEOUT_PER_STACK + FIRST_BUY_TIMEOUT, private.BuyTimeout)
end

function private.ChatMsgLootEventHandler(_, msg)
	if not private.pendingIndex then
		return
	end
	local link = GetMerchantItemLink(private.pendingIndex)
	if not link then
		Log.Err("Failed to get link (%s)", private.pendingIndex)
		private.ClearPendingContext()
		return
	end
	local msgItemLink, quantity = nil, nil
	for i = 1, GetMerchantItemMaxStack(private.pendingIndex) do
		local itemLink = private.ExtractFormatValue(msg, format(LOOT_ITEM_PUSHED_SELF_MULTIPLE, "%s", i))
		if itemLink then
			msgItemLink = itemLink
			quantity = i
			break
		end
	end
	if not msgItemLink then
		msgItemLink = private.ExtractFormatValue(msg, LOOT_ITEM_PUSHED_SELF)
		quantity = 1
	end
	if not msgItemLink or ItemString.GetBase(msgItemLink) ~= ItemString.GetBase(link) then
		Log.Info("Unknown item link (%s, %s, %s)", msg, tostring(msgItemLink), link)
		return
	end
	Log.Info("Got CHAT_MSG_LOOT(%s) with a quantity of %s (%d pending)", msg, tostring(quantity), private.pendingQuantity)
	private.pendingQuantity = private.pendingQuantity - quantity
	if private.pendingQuantity <= 0 then
		-- we're done
		private.ClearPendingContext()
		return
	end

	-- reset the timeout
	Delay.Cancel("VENDORING_BUY_TIMEOUT")
	Delay.AfterTime("VENDORING_BUY_TIMEOUT", CONSECUTIVE_BUY_TIMEOUT, private.BuyTimeout)
end

function private.ExtractFormatValue(str, fmtStr)
	assert(not strmatch(fmtStr, "\001"))
	local part1, part2 = strsplit("\001", format(fmtStr, "\001"))
	return strmatch(str, "^"..part1.."(.+)"..part2.."$")
end

function private.BuyTimeout()
	Log.Warn("Retrying buying (%d, %d)", private.pendingIndex, private.pendingQuantity)
	Buy.BuyItemIndex(private.pendingIndex, private.pendingQuantity)
end

function private.ClearPendingContext()
	private.pendingIndex = nil
	private.pendingQuantity = 0
	Delay.Cancel("VENDORING_BUY_TIMEOUT")
end
