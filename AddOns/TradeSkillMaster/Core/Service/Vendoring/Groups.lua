-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.Vendoring:NewPackage("Groups")
local L = TSM.Include("Locale").GetTable()
local Table = TSM.Include("Util.Table")
local Money = TSM.Include("Util.Money")
local SlotId = TSM.Include("Util.SlotId")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local BagTracking = TSM.Include("Service.BagTracking")
local Inventory = TSM.Include("Service.Inventory")
local private = {
	buyThreadId = nil,
	sellThreadId = nil,
	tempGroups = {},
	printedBagsFullMsg = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.buyThreadId = Threading.New("VENDORING_GROUP_BUY", private.BuyThread)
	private.sellThreadId = Threading.New("VENDORING_GROUP_SELL", private.SellThread)
end

function Groups.BuyGroups(groups, callback)
	Groups.StopBuySell()

	wipe(private.tempGroups)
	for _, groupPath in ipairs(groups) do
		tinsert(private.tempGroups, groupPath)
	end
	Threading.SetCallback(private.buyThreadId, callback)
	Threading.Start(private.buyThreadId, private.tempGroups)
end

function Groups.SellGroups(groups, callback)
	Groups.StopBuySell()

	wipe(private.tempGroups)
	for _, groupPath in ipairs(groups) do
		tinsert(private.tempGroups, groupPath)
	end
	Threading.SetCallback(private.sellThreadId, callback)
	Threading.Start(private.sellThreadId, private.tempGroups)
end

function Groups.StopBuySell()
	Threading.Kill(private.buyThreadId)
	Threading.Kill(private.sellThreadId)
end



-- ============================================================================
-- Buy Thread
-- ============================================================================

function private.BuyThread(groups)
	for _, groupPath in ipairs(groups) do
		groups[groupPath] = true
	end

	local itemsToBuy = Threading.AcquireSafeTempTable()
	local itemBuyQuantity = Threading.AcquireSafeTempTable()
	local query = TSM.Vendoring.Buy.CreateMerchantQuery()
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:InnerJoin(TSM.Groups.GetItemDBForJoin(), "itemString")
		:Select("itemString", "groupPath", "numAvailable")
	for _, itemString, groupPath, numAvailable in query:Iterator() do
		if groups[groupPath] then
			local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Vendoring", itemString)
			if operationSettings.enableBuy then
				local numToBuy = private.GetNumToBuy(itemString, operationSettings)
				if numAvailable ~= -1 then
					numToBuy = min(numToBuy, numAvailable)
				end
				if numToBuy > 0 then
					assert(not itemBuyQuantity[itemString])
					tinsert(itemsToBuy, itemString)
					itemBuyQuantity[itemString] = numToBuy
				end
			end
		end
	end
	query:Release()

	for _, itemString in ipairs(itemsToBuy) do
		local numToBuy = itemBuyQuantity[itemString]
		TSM.Vendoring.Buy.BuyItem(itemString, numToBuy)
		Threading.Yield(true)
	end

	Threading.ReleaseSafeTempTable(itemsToBuy)
	Threading.ReleaseSafeTempTable(itemBuyQuantity)
end

function private.GetNumToBuy(itemString, operationSettings)
	local numHave = BagTracking.CreateQueryBagsItem(itemString)
		:VirtualField("autoBaseItemString", "string", TSM.Groups.TranslateItemString, "itemString")
		:Equal("autoBaseItemString", itemString)
		:Equal("isBoA", false)
		:SumAndRelease("quantity") or 0
	if operationSettings.restockSources.bank then
		numHave = numHave + Inventory.GetBankQuantity(itemString) + Inventory.GetReagentBankQuantity(itemString)
	end
	if operationSettings.restockSources.guild then
		numHave = numHave + Inventory.GetGuildQuantity(itemString)
	end
	if operationSettings.restockSources.ah then
		numHave = numHave + Inventory.GetAuctionQuantity(itemString)
	end
	if operationSettings.restockSources.mail then
		numHave = numHave + Inventory.GetMailQuantity(itemString)
	end
	if operationSettings.restockSources.alts or operationSettings.restockSources.alts_ah then
		local _, alts, _, altsAH = Inventory.GetPlayerTotals(itemString)
		numHave = numHave + (operationSettings.restockSources.alts and alts or 0) + (operationSettings.restockSources.alts_ah and altsAH or 0)
	end
	return max(operationSettings.restockQty - numHave, 0)
end



-- ============================================================================
-- Sell Thread
-- ============================================================================

function private.SellThread(groups)
	private.printedBagsFullMsg = false
	local totalValue = 0
	local operationsTemp = Threading.AcquireSafeTempTable()
	for _, groupPath in ipairs(groups) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			wipe(operationsTemp)
			for _, operationName, operationSettings in TSM.Operations.GroupOperationIterator("Vendoring", groupPath) do
				if operationSettings.enableSell then
					tinsert(operationsTemp, operationName)
				end
			end
			for _, operationName in ipairs(operationsTemp) do
				for _, itemString in TSM.Groups.ItemIterator(groupPath) do
					totalValue = totalValue + private.SellItemThreaded(itemString, TSM.Operations.GetSettings("Vendoring", operationName))
				end
			end
		end
	end
	Threading.ReleaseSafeTempTable(operationsTemp)

	if TSM.db.global.vendoringOptions.displayMoneyCollected then
		Log.PrintfUser(L["Sold %s worth of items."], Money.ToString(totalValue))
	end
end

function private.SellItemThreaded(itemString, operationSettings)
	-- calculate the number to sell
	local numHave = BagTracking.CreateQueryBagsItem(itemString)
		:VirtualField("autoBaseItemString", "string", TSM.Groups.TranslateItemString, "itemString")
		:Equal("autoBaseItemString", itemString)
		:Equal("isBoA", false)
		:SumAndRelease("quantity") or 0
	local numToSell = numHave - operationSettings.keepQty
	if numToSell <= 0 then
		return 0
	end

	-- check the expires
	if operationSettings.sellAfterExpired > 0 and TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString) < operationSettings.sellAfterExpired then
		return 0
	end

	-- check the destroy value
	local destroyValue = CustomPrice.GetValue(operationSettings.vsDestroyValue, itemString) or 0
	local maxDestroyValue = CustomPrice.GetValue(operationSettings.vsMaxDestroyValue, itemString) or 0
	if maxDestroyValue > 0 and destroyValue >= maxDestroyValue then
		return 0
	end

	-- check the market value
	local marketValue = CustomPrice.GetValue(operationSettings.vsMarketValue, itemString) or 0
	local maxMarketValue = CustomPrice.GetValue(operationSettings.vsMaxMarketValue, itemString) or 0
	if maxMarketValue > 0 and marketValue >= maxMarketValue then
		return 0
	end

	-- get a list of empty slots which we can use to split items into
	local emptySlotIds = private.GetEmptyBagSlotsThreaded(ItemString.IsItem(itemString) and GetItemFamily(ItemString.ToId(itemString)) or 0)

	-- get a list of slots containing the item we want to sell
	local slotIds = Threading.AcquireSafeTempTable()
	local bagQuery = BagTracking.CreateQueryBagsItem(itemString)
		:VirtualField("autoBaseItemString", "string", TSM.Groups.TranslateItemString, "itemString")
		:Equal("autoBaseItemString", itemString)
		:Select("slotId", "quantity")
		:Equal("isBoA", false)
		:OrderBy("quantity", true)
	if not operationSettings.sellSoulbound then
		bagQuery:Equal("isBoP", false)
	end
	for _, slotId in bagQuery:Iterator() do
		tinsert(slotIds, slotId)
	end
	bagQuery:Release()

	local totalValue = 0
	for _, slotId in ipairs(slotIds) do
		local bag, slot = SlotId.Split(slotId)
		local quantity = BagTracking.GetQuantityBySlotId(slotId)
		if quantity <= numToSell then
			UseContainerItem(bag, slot)
			totalValue = totalValue + ((ItemInfo.GetVendorSell(itemString) or 0) * quantity)
			numToSell = numToSell - quantity
		else
			if #emptySlotIds > 0 then
				local splitBag, splitSlot = SlotId.Split(tremove(emptySlotIds, 1))
				SplitContainerItem(bag, slot, numToSell)
				PickupContainerItem(splitBag, splitSlot)
				-- wait for the stack to be split
				Threading.WaitForFunction(private.BagSlotHasItem, splitBag, splitSlot)
				PickupContainerItem(splitBag, splitSlot)
				UseContainerItem(splitBag, splitSlot)
				totalValue = totalValue + ((ItemInfo.GetVendorSell(itemString) or 0) * quantity)
			elseif not private.printedBagsFullMsg then
				Log.PrintUser(L["Could not sell items due to not having free bag space available to split a stack of items."])
				private.printedBagsFullMsg = true
			end
			-- we're done
			numToSell = 0
		end
		if numToSell == 0 then
			break
		end
		Threading.Yield(true)
	end

	Threading.ReleaseSafeTempTable(slotIds)
	Threading.ReleaseSafeTempTable(emptySlotIds)
	return totalValue
end

function private.GetEmptyBagSlotsThreaded(itemFamily)
	local emptySlotIds = Threading.AcquireSafeTempTable()
	local sortvalue = Threading.AcquireSafeTempTable()
	for bag = 0, NUM_BAG_SLOTS do
		-- make sure the item can go in this bag
		local bagFamily = bag ~= 0 and GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag))) or 0
		if bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0 then
			for slot = 1, GetContainerNumSlots(bag) do
				if not GetContainerItemInfo(bag, slot) then
					local slotId = SlotId.Join(bag, slot)
					tinsert(emptySlotIds, slotId)
					-- use special bags first
					sortvalue[slotId] = slotId + (bagFamily > 0 and 0 or 100000)
				end
			end
		end
		Threading.Yield()
	end
	Table.SortWithValueLookup(emptySlotIds, sortvalue)
	Threading.ReleaseSafeTempTable(sortvalue)
	return emptySlotIds
end

function private.BagSlotHasItem(bag, slot)
	return GetContainerItemInfo(bag, slot) and true or false
end
