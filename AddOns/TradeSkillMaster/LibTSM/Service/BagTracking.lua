-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BagTracking = TSM.Init("Service.BagTracking")
local Database = TSM.Include("Util.Database")
local Delay = TSM.Include("Util.Delay")
local Event = TSM.Include("Util.Event")
local SlotId = TSM.Include("Util.SlotId")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local InventoryInfo = TSM.Include("Service.InventoryInfo")
local Settings = TSM.Include("Service.Settings")
local private = {
	slotDB = nil,
	quantityDB = nil,
	settings = nil,
	bagUpdates = {
		pending = {},
		bagList = {},
		bankList = {},
	},
	bankSlotUpdates = {
		pending = {},
		list = {},
	},
	reagentBankSlotUpdates = {
		pending = {},
		list = {},
	},
	bankOpen = false,
	isFirstBankOpen = true,
	callbackQuery = nil, -- luacheck: ignore 1004 - just stored for GC reasons
	callbacks = {},
}
local BANK_BAG_SLOTS = {}
local BANK_NON_REAGENT_BAG_SLOTS = {}



-- ============================================================================
-- Population of the Static Data
-- ============================================================================

do
	BANK_BAG_SLOTS[BANK_CONTAINER] = true
	BANK_NON_REAGENT_BAG_SLOTS[BANK_CONTAINER] = true
	for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		BANK_BAG_SLOTS[i] = true
		BANK_NON_REAGENT_BAG_SLOTS[i] = true
	end
	if not TSM.IsWowClassic() then
		BANK_BAG_SLOTS[REAGENTBANK_CONTAINER] = true
	end
end



-- ============================================================================
-- Module Loading
-- ============================================================================

BagTracking:OnSettingsLoad(function()
	Event.Register("BAG_UPDATE", private.BagUpdateHandler)
	Event.Register("BAG_UPDATE_DELAYED", private.BagUpdateDelayedHandler)
	Event.Register("BANKFRAME_OPENED", private.BankOpenedHandler)
	Event.Register("BANKFRAME_CLOSED", private.BankClosedHandler)
	Event.Register("PLAYERBANKSLOTS_CHANGED", private.BankSlotChangedHandler)
	if not TSM.IsWowClassic() then
		Event.Register("PLAYERREAGENTBANKSLOTS_CHANGED", private.ReagentBankSlotChangedHandler)
	end
	private.slotDB = Database.NewSchema("BAG_TRACKING_SLOTS")
		:AddUniqueNumberField("slotId")
		:AddNumberField("bag")
		:AddNumberField("slot")
		:AddStringField("itemLink")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
		:AddNumberField("itemTexture")
		:AddNumberField("quantity")
		:AddBooleanField("isBoP")
		:AddBooleanField("isBoA")
		:AddIndex("slotId")
		:AddIndex("bag")
		:AddIndex("itemString")
		:AddIndex("baseItemString")
		:Commit()
	private.quantityDB = Database.NewSchema("BAG_TRACKING_QUANTITY")
		:AddUniqueStringField("itemString")
		:AddNumberField("bagQuantity")
		:AddNumberField("bankQuantity")
		:AddNumberField("reagentBankQuantity")
		:Commit()
	private.callbackQuery = private.slotDB:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)
	private.settings = Settings.NewView()
		:AddKey("sync", "internalData", "bagQuantity")
		:AddKey("sync", "internalData", "bankQuantity")
		:AddKey("sync", "internalData", "reagentBankQuantity")

	local items = TempTable.Acquire()
	local bagQuantity = TempTable.Acquire()
	local bankQuantity = TempTable.Acquire()
	local reagentBankQuantity = TempTable.Acquire()
	for itemString, quantity in pairs(private.settings.bagQuantity) do
		if itemString == ItemString.GetBase(itemString) then
			items[itemString] = true
			bagQuantity[itemString] = quantity
		else
			private.settings.bagQuantity[itemString] = nil
		end
	end
	for itemString, quantity in pairs(private.settings.bankQuantity) do
		if itemString == ItemString.GetBase(itemString) then
			items[itemString] = true
			bankQuantity[itemString] = quantity
		else
			private.settings.bankQuantity[itemString] = nil
		end
	end
	for itemString, quantity in pairs(private.settings.reagentBankQuantity) do
		if itemString == ItemString.GetBase(itemString) then
			items[itemString] = true
			reagentBankQuantity[itemString] = quantity
		else
			private.settings.reagentBankQuantity[itemString] = nil
		end
	end
	private.quantityDB:BulkInsertStart()
	for itemString in pairs(items) do
		local total = (bagQuantity[itemString] or 0) + (bankQuantity[itemString] or 0) + (reagentBankQuantity[itemString] or 0)
		if total > 0 then
			private.quantityDB:BulkInsertNewRow(itemString, bagQuantity[itemString] or 0, bankQuantity[itemString] or 0, reagentBankQuantity[itemString] or 0)
		end
	end
	private.quantityDB:BulkInsertEnd()
	TempTable.Release(items)
	TempTable.Release(bagQuantity)
	TempTable.Release(bankQuantity)
	TempTable.Release(reagentBankQuantity)
end)

BagTracking:OnGameDataLoad(function()
	-- we'll scan all the bags and reagent bank right away, so wipe the existing quantities
	wipe(private.settings.bagQuantity)
	wipe(private.settings.reagentBankQuantity)
	private.quantityDB:SetQueryUpdatesPaused(true)
	local query = private.quantityDB:NewQuery()
	for _, row in query:Iterator() do
		local oldValue = row:GetField("bagQuantity") + row:GetField("reagentBankQuantity")
		if row:GetField("bankQuantity") == 0 then
			-- remove this row
			assert(oldValue > 0)
			private.quantityDB:DeleteRow(row)
		elseif oldValue ~= 0 then
			-- update this row
			row:SetField("bagQuantity", 0)
				:SetField("reagentBankQuantity", 0)
				:Update()
		end
	end
	query:Release()
	private.quantityDB:SetQueryUpdatesPaused(false)

	-- WoW does not fire an update event for the backpack when you log in, so trigger one
	private.BagUpdateHandler(nil, 0)
	private.BagUpdateDelayedHandler()
	-- trigger an update event for all bank (initial container) and reagent bank slots since we won't get one otherwise on login
	assert(GetContainerNumSlots(BANK_CONTAINER) == NUM_BANKGENERIC_SLOTS)
	for slot = 1, GetContainerNumSlots(BANK_CONTAINER) do
		private.BankSlotChangedHandler(nil, slot)
	end
	if not TSM.IsWowClassic() and IsReagentBankUnlocked() then
		for slot = 1, GetContainerNumSlots(REAGENTBANK_CONTAINER) do
			private.ReagentBankSlotChangedHandler(nil, slot)
		end
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function BagTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function BagTracking.BaseItemIterator()
	return private.quantityDB:NewQuery()
		:Select("itemString")
		:IteratorAndRelease()
end

function BagTracking.FilterQueryBags(query)
	return query
		:GreaterThanOrEqual("slotId", SlotId.Join(0, 1))
		:LessThanOrEqual("slotId", SlotId.Join(NUM_BAG_SLOTS + 1, 0))
end

function BagTracking.CreateQueryBags()
	return BagTracking.FilterQueryBags(private.slotDB:NewQuery())
end

function BagTracking.CreateQueryBagsAuctionable()
	return BagTracking.CreateQueryBags()
		:Equal("isBoP", false)
		:Equal("isBoA", false)
		:Custom(private.NoUsedChargesQueryFilter)
end

function BagTracking.CreateQueryBagsItem(itemString)
	local query = BagTracking.CreateQueryBags()
	if itemString == ItemString.GetBaseFast(itemString) then
		query:Equal("baseItemString", itemString)
	else
		query:Equal("itemString", itemString)
	end
	return query
end

function BagTracking.CreateQueryBagsItemAuctionable(itemString)
	return BagTracking.CreateQueryBagsItem(itemString)
		:Equal("isBoP", false)
		:Equal("isBoA", false)
		:Custom(private.NoUsedChargesQueryFilter)
end

function BagTracking.GetNumMailable(itemString)
	return BagTracking.CreateQueryBagsItem(itemString)
		:Equal("isBoP", false)
		:SumAndRelease("quantity") or 0
end

function BagTracking.CreateQueryBank()
	return private.slotDB:NewQuery()
		:InTable("bag", BANK_BAG_SLOTS)
end

function BagTracking.CreateQueryBankItem(itemString)
	local query = BagTracking.CreateQueryBank()
	if itemString == ItemString.GetBaseFast(itemString) then
		query:Equal("baseItemString", itemString)
	else
		query:Equal("itemString", itemString)
	end
	return query
end

function BagTracking.ForceBankQuantityDeduction(itemString, quantity)
	if private.bankOpen then
		return
	end
	private.slotDB:SetQueryUpdatesPaused(true)
	local query = private.slotDB:NewQuery()
		:Equal("itemString", itemString)
		:InTable("bag", BANK_NON_REAGENT_BAG_SLOTS)
	local baseItemString = ItemString.GetBaseFast(itemString)
	for _, row in query:Iterator() do
		if quantity > 0 then
			local rowQuantity, rowBag = row:GetFields("quantity", "bag")
			if rowQuantity <= quantity then
				private.ChangeBagItemTotal(rowBag, baseItemString, -rowQuantity)
				private.slotDB:DeleteRow(row)
				quantity = quantity - rowQuantity
			else
				row:SetField("quantity", rowQuantity - quantity)
					:Update()
				private.ChangeBagItemTotal(rowBag, baseItemString, -quantity)
				quantity = 0
			end
		end
	end
	query:Release()
	private.slotDB:SetQueryUpdatesPaused(false)
end

function BagTracking.GetQuantityBySlotId(slotId)
	return private.slotDB:GetUniqueRowField("slotId", slotId, "quantity")
end

function BagTracking.GetBagsQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "bagQuantity") or 0
end

function BagTracking.GetBankQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "bankQuantity") or 0
end

function BagTracking.GetReagentBankQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "reagentBankQuantity") or 0
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.BankOpenedHandler()
	if private.isFirstBankOpen then
		private.isFirstBankOpen = false
		-- this is the first time opening the bank so we'll scan all the items so wipe our existing quantities
		wipe(private.settings.bankQuantity)
		private.quantityDB:SetQueryUpdatesPaused(true)
		local query = private.quantityDB:NewQuery()
		for _, row in query:Iterator() do
			local oldValue = row:GetField("bankQuantity")
			if row:GetField("bagQuantity") + row:GetField("reagentBankQuantity") == 0 then
				-- remove this row
				assert(oldValue > 0)
				private.quantityDB:DeleteRow(row)
			elseif oldValue ~= 0 then
				-- update this row
				row:SetField("bankQuantity", 0)
					:Update()
			end
		end
		query:Release()
		private.quantityDB:SetQueryUpdatesPaused(false)
	end
	private.bankOpen = true
	private.BagUpdateDelayedHandler()
	private.BankSlotUpdateDelayed()
end

function private.BankClosedHandler()
	private.bankOpen = false
end

function private.BagUpdateHandler(_, bag)
	if private.bagUpdates.pending[bag] then
		return
	end
	private.bagUpdates.pending[bag] = true
	if bag >= BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS then
		tinsert(private.bagUpdates.bagList, bag)
	elseif bag == BANK_CONTAINER or (bag > NUM_BAG_SLOTS and bag <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		tinsert(private.bagUpdates.bankList, bag)
	elseif bag ~= KEYRING_CONTAINER then
		error("Unexpected bag: "..tostring(bag))
	end
end

function private.BagUpdateDelayedHandler()
	private.slotDB:SetQueryUpdatesPaused(true)

	-- scan any pending bags
	for i = #private.bagUpdates.bagList, 1, -1 do
		local bag = private.bagUpdates.bagList[i]
		if private.ScanBagOrBank(bag) then
			private.bagUpdates.pending[bag] = nil
			tremove(private.bagUpdates.bagList, i)
		end
	end
	if #private.bagUpdates.bagList > 0 then
		-- some failed to scan so try again
		Delay.AfterFrame("bagBankScan", 2, private.BagUpdateDelayedHandler)
	end

	if private.bankOpen then
		-- scan any pending bank bags
		for i = #private.bagUpdates.bankList, 1, -1 do
			local bag = private.bagUpdates.bankList[i]
			if private.ScanBagOrBank(bag) then
				private.bagUpdates.pending[bag] = nil
				tremove(private.bagUpdates.bankList, i)
			end
		end
		if #private.bagUpdates.bankList > 0 then
			-- some failed to scan so try again
			Delay.AfterFrame("bagBankScan", 2, private.BagUpdateDelayedHandler)
		end
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end

function private.BankSlotChangedHandler(_, slot)
	if slot > NUM_BANKGENERIC_SLOTS then
		private.BagUpdateHandler(nil, slot - NUM_BANKGENERIC_SLOTS)
		return
	end
	if private.bankSlotUpdates.pending[slot] then
		return
	end
	private.bankSlotUpdates.pending[slot] = true
	tinsert(private.bankSlotUpdates.list, slot)
	Delay.AfterFrame("bankSlotScan", 2, private.BankSlotUpdateDelayed)
end

-- this is not a WoW event, but we fake it based on a delay from private.BankSlotChangedHandler
function private.BankSlotUpdateDelayed()
	if not private.bankOpen then
		return
	end
	private.slotDB:SetQueryUpdatesPaused(true)

	-- scan any pending slots
	for i = #private.bankSlotUpdates.list, 1, -1 do
		local slot = private.bankSlotUpdates.list[i]
		if private.ScanBankSlot(slot) then
			private.bankSlotUpdates.pending[slot] = nil
			tremove(private.bankSlotUpdates.list, i)
		end
	end
	if #private.bankSlotUpdates.list > 0 then
		-- some failed to scan so try again
		Delay.AfterFrame("bankSlotScan", 2, private.BankSlotUpdateDelayed)
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end

function private.ReagentBankSlotChangedHandler(_, slot)
	if private.reagentBankSlotUpdates.pending[slot] then
		return
	end
	private.reagentBankSlotUpdates.pending[slot] = true
	tinsert(private.reagentBankSlotUpdates.list, slot)
	Delay.AfterFrame("reagentBankSlotScan", 2, private.ReagentBankSlotUpdateDelayed)
end

-- this is not a WoW event, but we fake it based on a delay from private.ReagentBankSlotChangedHandler
function private.ReagentBankSlotUpdateDelayed()
	private.slotDB:SetQueryUpdatesPaused(true)

	-- scan any pending slots
	for i = #private.reagentBankSlotUpdates.list, 1, -1 do
		local slot = private.reagentBankSlotUpdates.list[i]
		if private.ScanReagentBankSlot(slot) then
			private.reagentBankSlotUpdates.pending[slot] = nil
			tremove(private.reagentBankSlotUpdates.list, i)
		end
	end
	if #private.reagentBankSlotUpdates.list > 0 then
		-- some failed to scan so try again
		Delay.AfterFrame("reagentBankSlotScan", 2, private.ReagentBankSlotUpdateDelayed)
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end



-- ============================================================================
-- Scanning Functions
-- ============================================================================

function private.ScanBagOrBank(bag)
	local numSlots = GetContainerNumSlots(bag)
	private.RemoveExtraSlots(bag, numSlots)
	local result = true
	for slot = 1, numSlots do
		if not private.ScanBagSlot(bag, slot) then
			result = false
		end
	end
	return result
end

function private.ScanBankSlot(slot)
	return private.ScanBagSlot(BANK_CONTAINER, slot)
end

function private.ScanReagentBankSlot(slot)
	return private.ScanBagSlot(REAGENTBANK_CONTAINER, slot)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.NoUsedChargesQueryFilter(row)
	return not InventoryInfo.HasUsedCharges(row:GetFields("bag", "slot"))
end

function private.RemoveExtraSlots(bag, numSlots)
	-- the number of slots of this bag may have changed, in which case we should remove any higher ones from our DB
	local query = private.slotDB:NewQuery()
		:Equal("bag", bag)
		:GreaterThan("slot", numSlots)
	for _, row in query:Iterator() do
		local baseItemString, quantity = row:GetFields("baseItemString", "quantity")
		private.ChangeBagItemTotal(bag, baseItemString, -quantity)
		private.slotDB:DeleteRow(row)
	end
	query:Release()
end

function private.ScanBagSlot(bag, slot)
	local texture, quantity, _, _, _, _, link, _, _, itemId = GetContainerItemInfo(bag, slot)
	if quantity and not itemId then
		-- we are pending item info for this slot so try again later to scan it
		return false
	elseif quantity == 0 then
		-- this item is going away, so try again later to scan it
		return false
	end
	local baseItemString = link and ItemString.GetBase(link)
	local slotId = SlotId.Join(bag, slot)
	local row = private.slotDB:GetUniqueRow("slotId", slotId)
	if baseItemString then
		local isBoP, isBoA = nil, nil
		if row then
			if row:GetField("itemLink") == link then
				-- the item didn't change, so use the previous values
				isBoP, isBoA = row:GetFields("isBoP", "isBoA")
			else
				isBoP, isBoA = InventoryInfo.IsSoulbound(bag, slot)
				if isBoP == nil then
					Log.Err("Failed to get soulbound info for %d,%d (%s)", bag, slot, link or "?")
					return false
				end
			end
			-- remove the old row from the item totals
			local oldBaseItemString, oldQuantity = row:GetFields("baseItemString", "quantity")
			private.ChangeBagItemTotal(bag, oldBaseItemString, -oldQuantity)
		else
			isBoP, isBoA = InventoryInfo.IsSoulbound(bag, slot)
			if isBoP == nil then
				Log.Err("Failed to get soulbound info for %d,%d (%s)", bag, slot, link or "?")
				return false
			end
			-- there was nothing here previously so create a new row
			row = private.slotDB:NewRow()
				:SetField("slotId", slotId)
				:SetField("bag", bag)
				:SetField("slot", slot)
		end
		-- update the row
		row:SetField("itemLink", link)
			:SetField("itemString", ItemString.Get(link))
			:SetField("itemTexture", texture or ItemInfo.GetTexture(link))
			:SetField("quantity", quantity)
			:SetField("isBoP", isBoP)
			:SetField("isBoA", isBoA)
			:CreateOrUpdateAndRelease()
		-- add to the item totals
		private.ChangeBagItemTotal(bag, baseItemString, quantity)
	elseif row then
		-- nothing here now so delete the row and remove from the item totals
		local oldBaseItemString, oldQuantity = row:GetFields("baseItemString", "quantity")
		private.ChangeBagItemTotal(bag, oldBaseItemString, -oldQuantity)
		private.slotDB:DeleteRow(row)
		row:Release()
	end
	return true
end

function private.OnCallbackQueryUpdated()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end

function private.ChangeBagItemTotal(bag, itemString, changeQuantity)
	local totalsTable = nil
	local field = nil
	if bag >= BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS then
		totalsTable = private.settings.bagQuantity
		field = "bagQuantity"
	elseif bag == BANK_CONTAINER or (bag > NUM_BAG_SLOTS and bag <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		totalsTable = private.settings.bankQuantity
		field = "bankQuantity"
	elseif bag == REAGENTBANK_CONTAINER then
		totalsTable = private.settings.reagentBankQuantity
		field = "reagentBankQuantity"
	else
		error("Unexpected bag: "..tostring(bag))
	end
	totalsTable[itemString] = (totalsTable[itemString] or 0) + changeQuantity
	private.UpdateQuantity(itemString, field, changeQuantity)
	assert(totalsTable[itemString] >= 0)
	if totalsTable[itemString] == 0 then
		totalsTable[itemString] = nil
	end
end

function private.UpdateQuantity(itemString, field, quantity)
	assert(itemString and field and quantity)
	assert(quantity ~= 0)
	if not private.quantityDB:HasUniqueRow("itemString", itemString) then
		-- create a new row
		private.quantityDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("bagQuantity", 0)
			:SetField("bankQuantity", 0)
			:SetField("reagentBankQuantity", 0)
			:Create()
	end

	local row = private.quantityDB:GetUniqueRow("itemString", itemString)
	local totalQuantity = row:GetField("bagQuantity") + row:GetField("bankQuantity") + row:GetField("reagentBankQuantity")
	local oldValue = row:GetField(field)
	local newValue = oldValue + quantity
	assert(newValue >= 0)
	if newValue == 0 and totalQuantity == oldValue then
		-- remove this row
		private.quantityDB:DeleteRow(row)
	else
		-- update this row
		row:SetField(field, oldValue + quantity)
			:Update()
	end
	row:Release()
end
