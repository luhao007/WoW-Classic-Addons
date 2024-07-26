-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local BagTracking = LibTSMService:Init("Inventory.BagTracking")
local ItemInfo = LibTSMService:Include("Item.ItemInfo")
local TempTable = LibTSMService:From("LibTSMUtil"):Include("BaseType.TempTable")
local Database = LibTSMService:From("LibTSMUtil"):Include("Database")
local Table = LibTSMService:From("LibTSMUtil"):Include("Lua.Table")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local AuctionHouse = LibTSMService:From("LibTSMWoW"):Include("API.AuctionHouse")
local Container = LibTSMService:From("LibTSMWoW"):Include("API.Container")
local Item = LibTSMService:From("LibTSMWoW"):Include("API.Item")
local DelayTimer = LibTSMService:From("LibTSMWoW"):IncludeClassType("DelayTimer")
local Event = LibTSMService:From("LibTSMWoW"):Include("Service.Event")
local TooltipScanning = LibTSMService:From("LibTSMWoW"):Include("Service.TooltipScanning")
local SlotId = LibTSMService:From("LibTSMWoW"):Include("Type.SlotId")
local DefaultUI = LibTSMService:From("LibTSMWoW"):Include("UI.DefaultUI")
local ClientInfo = LibTSMService:From("LibTSMWoW"):Include("Util.ClientInfo")
local private = {
	slotDB = nil,
	quantityDB = nil,
	storage = {
		bagQuantity = nil,
		bankQuantity = nil,
		reagentBankQuantity = nil,
	},
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
	isFirstBankOpen = true,
	baseItemQuantityQuery = nil,
	callbackQuery = nil, -- luacheck: ignore 1004 - just stored for GC reasons
	quantityCallbackQuery = nil, -- luacheck: ignore 1004 - just stored for GC reasons
	callbacks = {},
	quantityCallbacks = {},
	bagUpdateTimer = nil,
	bagUpdateDelayedTimer = nil,
	bankSlotUpdateTimer = nil,
	reagentBankSlotUpdateTimer = nil,
	bagTrackingCallbackTimer = nil,
	bagTrackingQuantityCallbackTimer = nil,
	prevQuantities = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

BagTracking:OnModuleLoad(function()
	private.slotDB = Database.NewSchema("BAG_TRACKING_SLOTS")
		:AddUniqueNumberField("slotId")
		:AddNumberField("bag")
		:AddNumberField("slot")
		:AddStringField("itemLink")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
		:AddSmartMapField("levelItemString", ItemString.GetLevelMap(), "itemString")
		:AddNumberField("itemTexture")
		:AddNumberField("quantity")
		:AddBooleanField("isBound")
		:AddIndex("slotId")
		:AddIndex("bag")
		:AddIndex("itemString")
		:AddIndex("baseItemString")
		:AddIndex("levelItemString")
		:Commit()
	private.quantityDB = Database.NewSchema("BAG_TRACKING_QUANTITY")
		:AddUniqueStringField("levelItemString")
		:AddNumberField("bagQuantity")
		:AddNumberField("bankQuantity")
		:AddNumberField("reagentBankQuantity")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "levelItemString")
		:AddIndex("baseItemString")
		:Commit()
	private.baseItemQuantityQuery = private.quantityDB:NewQuery()
		:Select("bagQuantity", "bankQuantity", "reagentBankQuantity")
		:Equal("baseItemString", Database.BoundQueryParam())
	private.callbackQuery = private.slotDB:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)
	private.quantityCallbackQuery = private.quantityDB:NewQuery()
		:SetUpdateCallback(private.OnQuantityCallbackQueryUpdated)
	private.bagUpdateTimer = DelayTimer.New("BAG_TRACKING_BAG_UPDATE", private.BagUpdateDelayedHandler)
	private.bankSlotUpdateTimer = DelayTimer.New("BAG_TRACKING_BANK_SLOT_UPDATE", private.BankSlotUpdateDelayed)
	private.reagentBankSlotUpdateTimer = DelayTimer.New("BAG_TRACKING_REAGENT_BANK_SLOT_UPDATE", private.ReagentBankSlotUpdateDelayed)
	private.bagTrackingCallbackTimer = DelayTimer.New("BAG_TRACKING_CALLBACK", private.DelayedBagTrackingCallback)
	private.bagTrackingQuantityCallbackTimer = DelayTimer.New("BAG_TRACKING_QUANTITY_CALLBACK", private.DelayedBagTrackingQuantityCallback)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Loads and sets the stored data tables.
---@param bagQuantityData table<string,number> Bag item quantities
---@param bankQuantityData table<string,number> Bank item quantityes
---@param reagentBankQuantityData table<string,number> Reagent bank item quantities
function BagTracking.Load(bagQuantityData, bankQuantityData, reagentBankQuantityData)
	private.storage.bagQuantity = bagQuantityData
	private.storage.bankQuantity = bankQuantityData
	private.storage.reagentBankQuantity = reagentBankQuantityData
	Table.Filter(private.storage.bagQuantity, private.FilterNonItemLevelStrings)
	Table.Filter(private.storage.bankQuantity, private.FilterNonItemLevelStrings)
	Table.Filter(private.storage.reagentBankQuantity, private.FilterNonItemLevelStrings)
	local items = TempTable.Acquire()
	for levelItemString in pairs(private.storage.bagQuantity) do
		items[levelItemString] = true
	end
	for levelItemString in pairs(private.storage.bankQuantity) do
		items[levelItemString] = true
	end
	for levelItemString in pairs(private.storage.reagentBankQuantity) do
		items[levelItemString] = true
	end
	private.quantityDB:BulkInsertStart()
	for levelItemString in pairs(items) do
		local bagQuantity = private.storage.bagQuantity[levelItemString] or 0
		local bankQuantity = private.storage.bankQuantity[levelItemString] or 0
		local reagentBankQuantity = private.storage.reagentBankQuantity[levelItemString] or 0
		if (bagQuantity + bankQuantity + reagentBankQuantity) > 0 then
			private.quantityDB:BulkInsertNewRow(levelItemString, bagQuantity, bankQuantity, reagentBankQuantity)
		end
	end
	private.quantityDB:BulkInsertEnd()
	TempTable.Release(items)
end

---Starts running the bag tracking code.
function BagTracking.Start()
	Event.Register("BAG_UPDATE", private.BagUpdateHandler)
	if LibTSMService.IsCataClassic() or LibTSMService.IsRetail() then
		-- In Cata 4.4.0 and in Retail 10.0.5, BAG_UPDATE_DELAYED doesnt fire for non-backpack slots, so emulate it
		private.bagUpdateDelayedTimer = DelayTimer.New("BAG_TRACKING_BAG_UPDATE_DELAYED", private.BagUpdateDelayedHandler)
		Event.Register("BAG_UPDATE", function() private.bagUpdateDelayedTimer:RunForFrames(0) end)
	else
		Event.Register("BAG_UPDATE_DELAYED", private.BagUpdateDelayedHandler)
	end
	DefaultUI.RegisterBankVisibleCallback(private.BankVisible, true)
	Event.Register("PLAYERBANKSLOTS_CHANGED", private.BankSlotChangedHandler)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.REAGENT_BANK) then
		Event.Register("PLAYERREAGENTBANKSLOTS_CHANGED", private.ReagentBankSlotChangedHandler)
	end
end

--- Performs an initial scan of the bags.
function BagTracking.InitialScan()
	-- We'll scan all the bags right away, so wipe the existing quantities
	wipe(private.storage.bagQuantity)
	private.quantityDB:SetQueryUpdatesPaused(true)
	local query = private.quantityDB:NewQuery()
	for _, row in query:Iterator() do
		local oldBagQuantity = row:GetField("bagQuantity")
		local oldTotalBankQuantity = row:GetField("bankQuantity") + row:GetField("reagentBankQuantity")
		if oldTotalBankQuantity == 0 then
			-- Remove this row
			assert(oldBagQuantity > 0)
			private.quantityDB:DeleteRow(row)
		else
			local updated = false
			if LibTSMService.IsRetail() and oldTotalBankQuantity > 0 then
				-- Update commodity quantities using GetItemCount()
				local levelItemString = row:GetField("levelItemString")
				if levelItemString == ItemString.GetBaseFast(levelItemString) and ItemInfo.IsCommodity(levelItemString) then
					local itemId = ItemString.ToId(levelItemString)
					local _, bankQuantity, reagentBankQuantity = Container.GetItemCount(itemId)
					if reagentBankQuantity ~= row:GetField("reagentBankQuantity") or bankQuantity ~= row:GetField("bankQuantity") then
						updated = true
						if reagentBankQuantity + bankQuantity == 0 then
							private.quantityDB:DeleteRow(row)
						else
							row:SetField("bagQuantity", 0)
								:SetField("bankQuantity", bankQuantity)
								:SetField("reagentBankQuantity", reagentBankQuantity)
								:Update()
						end
					end
				end
			end
			if not updated and oldBagQuantity ~= 0 then
				-- Update this row
				row:SetField("bagQuantity", 0)
					:Update()
			end
		end
	end
	query:Release()
	private.quantityDB:SetQueryUpdatesPaused(false)

	-- WoW does not fire an update event for the backpack when you log in, so trigger one
	private.BagUpdateHandler(nil, 0)
	private.BagUpdateDelayedHandler()
end

---Registers a callback for when the bags change.
---@param callback fun() The callback function
function BagTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

---Registers a callback for when the bag quantities change.
---@param callback fun(updatedItems: table<string,true>) The callback function which is passed a table with the changed base item strings as keys
function BagTracking.RegisterQuantityCallback(callback)
	tinsert(private.quantityCallbacks, callback)
end

---Iterates over the bag quantities.
---@return fun(): number, number, number, number, number @Iterator with fields: `index`, levelItemString`, `bagQuantity`, `bankQuantity`, `reagentBankQuantity`
function BagTracking.QuantityIterator()
	return private.quantityDB:NewQuery()
		:Select("levelItemString", "bagQuantity", "bankQuantity", "reagentBankQuantity")
		:IteratorAndRelease()
end

---Adds a filter to a DB query to restrict it to just the bags.
---@param query DatabaseQuery the query
---@return DatabaseQuery
function BagTracking.FilterQueryBags(query)
	return query
		:GreaterThanOrEqual("slotId", SlotId.Join(0, 1))
		:LessThanOrEqual("slotId", SlotId.Join(Container.GetNumBags() + 1, 0))
end

---Creates a new query for just the bags.
---@return DatabaseQuery
function BagTracking.CreateQueryBags()
	return BagTracking.FilterQueryBags(private.slotDB:NewQuery())
end

---Creates a new query for the bags and bank.
---@return DatabaseQuery
function BagTracking.CreateQueryBagsBank()
	return private.slotDB:NewQuery()
end

---Creates a new query of auctionable items in the bags.
---@return DatabaseQuery
function BagTracking.CreateQueryBagsAuctionable()
	return BagTracking.CreateQueryBags()
		:Equal("isBound", false)
		:Custom(private.IsAuctionableQueryFilter)
end

---Creates a query of bag slots with the specified item.
---@param itemString string The item string
---@return DatabaseQuery
function BagTracking.CreateQueryBagsItem(itemString)
	local query = BagTracking.CreateQueryBags()
	if itemString == ItemString.GetBaseFast(itemString) then
		query:Equal("baseItemString", itemString)
	elseif ItemString.IsLevel(itemString) then
		query:Equal("levelItemString", itemString)
	else
		query:Equal("itemString", itemString)
	end
	return query
end

---Creates a query of bag slots with the specified item that are auctionable.
---@param itemString string The item string
---@return DatabaseQuery
function BagTracking.CreateQueryBagsItemAuctionable(itemString)
	return BagTracking.CreateQueryBagsItem(itemString)
		:Equal("isBound", false)
		:Custom(private.IsAuctionableQueryFilter)
end

---Gets the mailable quantity for the specified item from the bags.
---@param itemString string The item string
---@return number
function BagTracking.GetNumMailable(itemString)
	return BagTracking.CreateQueryBagsItem(itemString)
		:Equal("isBound", false)
		:SumAndRelease("quantity")
end

---Creates a query of the bank / reagent bank.
---@return DatabaseQuery
function BagTracking.CreateQueryBank()
	return private.slotDB:NewQuery()
		:Function("bag", Container.IsBankOrReagentBank)
end

---Creates a query of the bank / reagent bank for the specified item.
---@param itemString string The item string
---@return DatabaseQuery
function BagTracking.CreateQueryBankItem(itemString)
	local query = BagTracking.CreateQueryBank()
	if itemString == ItemString.GetBaseFast(itemString) then
		query:Equal("baseItemString", itemString)
	elseif ItemString.IsLevel(itemString) then
		query:Equal("levelItemString", itemString)
	else
		query:Equal("itemString", itemString)
	end
	return query
end

---Forces a deduction in the item quantity.
---@param itemString string The item string
---@param quantity number The amount to deduct
function BagTracking.ForceBankQuantityDeduction(itemString, quantity)
	if DefaultUI.IsBankVisible() then
		return
	end
	private.slotDB:SetQueryUpdatesPaused(true)
	local query = private.slotDB:NewQuery()
		:Equal("itemString", itemString)
		:Function("bag", Container.IsBankOrReagentBank)
	local levelItemString = ItemString.ToLevel(itemString)
	for _, row in query:Iterator() do
		if quantity > 0 then
			local rowQuantity, rowBag = row:GetFields("quantity", "bag")
			if rowQuantity <= quantity then
				private.ChangeBagItemTotal(rowBag, levelItemString, -rowQuantity)
				private.slotDB:DeleteRow(row)
				quantity = quantity - rowQuantity
			else
				row:SetField("quantity", rowQuantity - quantity)
					:Update()
				private.ChangeBagItemTotal(rowBag, levelItemString, -quantity)
				quantity = 0
			end
		end
	end
	query:Release()
	private.slotDB:SetQueryUpdatesPaused(false)
end

---Gets the stack size in a given slot.
---@param slotId number The slot ID
---@return number
function BagTracking.GetQuantityBySlotId(slotId)
	return private.slotDB:GetUniqueRowField("slotId", slotId, "quantity")
end

---Gets the number of an item in the bags.
---@param itemString string The item string
---@return number
function BagTracking.GetBagQuantity(itemString)
	if not ItemString.IsLevel(itemString) and itemString == ItemString.GetBaseFast(itemString) then
		return private.baseItemQuantityQuery
			:BindParams(itemString)
			:Sum("bagQuantity")
	else
		local levelItemString = ItemString.ToLevel(itemString)
		return private.quantityDB:GetUniqueRowField("levelItemString", levelItemString, "bagQuantity") or 0
	end
end

---Gets the number of an item in the bank.
---@param itemString string The item string
---@return number
function BagTracking.GetBankQuantity(itemString)
	if not ItemString.IsLevel(itemString) and itemString == ItemString.GetBaseFast(itemString) then
		return private.baseItemQuantityQuery
			:BindParams(itemString)
			:Sum("bankQuantity")
	else
		local levelItemString = ItemString.ToLevel(itemString)
		return private.quantityDB:GetUniqueRowField("levelItemString", levelItemString, "bankQuantity") or 0
	end
end

---Gets the number of an item in the reagent bank.
---@param itemString string The item string
---@return number
function BagTracking.GetReagentBankQuantity(itemString)
	if not ItemString.IsLevel(itemString) and itemString == ItemString.GetBaseFast(itemString) then
		return private.baseItemQuantityQuery
			:BindParams(itemString)
			:Sum("reagentBankQuantity")
	else
		local levelItemString = ItemString.ToLevel(itemString)
		return private.quantityDB:GetUniqueRowField("levelItemString", levelItemString, "reagentBankQuantity") or 0
	end
end

---Gets the bag / bank / reagent bank quantities for the specified item.
---@param itemString string The item string
---@return number bagQuantity
---@return number bankQuantity
---@return number reagentBankQuantity
function BagTracking.GetQuantities(itemString)
	if not ItemString.IsLevel(itemString) and itemString == ItemString.GetBaseFast(itemString) then
		private.baseItemQuantityQuery:BindParams(itemString)
		return private.baseItemQuantityQuery:Sum("bagQuantity"), private.baseItemQuantityQuery:Sum("bankQuantity"), private.baseItemQuantityQuery:Sum("reagentBankQuantity")
	else
		local levelItemString = ItemString.ToLevel(itemString)
		local bagQuantity, bankQuantity, reagentBankQuantity = private.quantityDB:GetUniqueRowFields("levelItemString", levelItemString, "bagQuantity", "bankQuantity", "reagentBankQuantity")
		return bagQuantity or 0, bankQuantity or 0, reagentBankQuantity or 0
	end
end

---Gets the total quantity for the specified item.
---@param itemString string The item string
---@return number
function BagTracking.GetTotalQuantity(itemString)
	local bagQuantity, bankQuantity, reagentBankQuantity = BagTracking.GetQuantities(itemString)
	return bagQuantity + bankQuantity + reagentBankQuantity
end

---Gets the available crafting mat quantity for the specified item.
---@param itemString string The item string
---@return number
function BagTracking.GetCraftingMatQuantity(itemString)
	if LibTSMService.IsRetail() then
		return BagTracking.GetTotalQuantity(itemString)
	else
		return BagTracking.GetBagQuantity(itemString)
	end
end

---Check if an item will go in a bag.
---@param itemString string The item string
---@param bag number The bag index
---@return boolean
function BagTracking.ItemWillGoInBag(itemString, bag)
	if bag == Container.GetBackpackContainer() or bag == Container.GetBankContainer() then
		return true
	elseif bag == Container.GetReagentBankContainer() then
		return Container.HasReagentBank() and ItemInfo.IsCraftingReagent(itemString)
	end
	local itemFamily = Item.GetFamily(ItemInfo.GetLink(itemString), ItemInfo.GetClassId(itemString))
	local _, bagFamily = Container.GetNumFreeSlots(bag)
	if not bagFamily then
		return false
	end
	return bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.BankVisible()
	if private.isFirstBankOpen then
		private.isFirstBankOpen = false
		-- this is the first time opening the bank so we'll scan all the items so wipe our existing quantities
		wipe(private.storage.bankQuantity)
		wipe(private.storage.reagentBankQuantity)
		private.quantityDB:SetQueryUpdatesPaused(true)
		local query = private.quantityDB:NewQuery()
		for _, row in query:Iterator() do
			local oldValue = row:GetField("bankQuantity") + row:GetField("reagentBankQuantity")
			if row:GetField("bagQuantity") == 0 then
				-- remove this row
				assert(oldValue > 0)
				private.quantityDB:DeleteRow(row)
			elseif oldValue ~= 0 then
				-- update this row
				row:SetField("bankQuantity", 0)
					:SetField("reagentBankQuantity", 0)
					:Update()
			end
		end
		query:Release()
		private.quantityDB:SetQueryUpdatesPaused(false)
	end
	private.BagUpdateHandler(nil, Container.GetBankContainer())
	for _, bag in Container.BankBagIterator() do
		private.BagUpdateHandler(nil, bag)
	end
	if Container.HasReagentBank() then
		for slot = 1, Container.GetNumSlots(Container.GetReagentBankContainer()) do
			private.ReagentBankSlotChangedHandler(nil, slot)
		end
	end
	private.BagUpdateDelayedHandler()
	private.BankSlotUpdateDelayed()
	private.ReagentBankSlotUpdateDelayed()
end

function private.BagUpdateHandler(_, bag)
	if private.bagUpdates.pending[bag] then
		return
	end
	private.bagUpdates.pending[bag] = true
	if Container.IsBag(bag) then
		tinsert(private.bagUpdates.bagList, bag)
	elseif Container.IsBank(bag) then
		tinsert(private.bagUpdates.bankList, bag)
	elseif bag ~= Container.GetKeyringContainer() then
		error("Unexpected bag: "..tostring(bag))
	end
end

function private.BagUpdateDelayedHandler()
	private.slotDB:SetQueryUpdatesPaused(true)

	-- Scan any pending bags
	for i, bag in Table.ReverseIPairs(private.bagUpdates.bagList) do
		if private.ScanBagOrBank(bag) then
			private.bagUpdates.pending[bag] = nil
			tremove(private.bagUpdates.bagList, i)
		end
	end
	if #private.bagUpdates.bagList > 0 then
		-- Some failed to scan so try again
		private.bagUpdateTimer:RunForFrames(2)
	end

	if DefaultUI.IsBankVisible() then
		-- Scan any pending bank bags
		for i, bag in Table.ReverseIPairs(private.bagUpdates.bankList) do
			if private.ScanBagOrBank(bag) then
				private.bagUpdates.pending[bag] = nil
				tremove(private.bagUpdates.bankList, i)
			end
		end
		if #private.bagUpdates.bankList > 0 then
			-- Some failed to scan so try again
			private.bagUpdateTimer:RunForFrames(2)
		end
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end

function private.BankSlotChangedHandler(_, slot)
	local numBankContainerSlots = Container.GetNumSlots(Container.GetBankContainer())
	if slot > numBankContainerSlots then
		private.BagUpdateHandler(nil, slot - numBankContainerSlots)
		return
	end
	if private.bankSlotUpdates.pending[slot] then
		return
	end
	private.bankSlotUpdates.pending[slot] = true
	tinsert(private.bankSlotUpdates.list, slot)
	private.bankSlotUpdateTimer:RunForFrames(2)
end

-- This is not a WoW event, but we fake it based on a delay from private.BankSlotChangedHandler
function private.BankSlotUpdateDelayed()
	if not DefaultUI.IsBankVisible() then
		return
	end
	private.slotDB:SetQueryUpdatesPaused(true)

	-- scan any pending slots
	for i, slot in Table.ReverseIPairs(private.bankSlotUpdates.list) do
		if private.ScanBankSlot(slot) then
			private.bankSlotUpdates.pending[slot] = nil
			tremove(private.bankSlotUpdates.list, i)
		end
	end
	if #private.bankSlotUpdates.list > 0 then
		-- some failed to scan so try again
		private.bankSlotUpdateTimer:RunForFrames(2)
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end

function private.ReagentBankSlotChangedHandler(_, slot)
	if private.reagentBankSlotUpdates.pending[slot] then
		return
	end
	private.reagentBankSlotUpdates.pending[slot] = true
	tinsert(private.reagentBankSlotUpdates.list, slot)
	private.reagentBankSlotUpdateTimer:RunForFrames(2)
end

-- This is not a WoW event, but we fake it based on a delay from private.ReagentBankSlotChangedHandler
function private.ReagentBankSlotUpdateDelayed()
	if not DefaultUI.IsBankVisible() then
		return
	end
	private.slotDB:SetQueryUpdatesPaused(true)

	-- Scan any pending slots
	for i, slot in Table.ReverseIPairs(private.reagentBankSlotUpdates.list) do
		if private.ScanReagentBankSlot(slot) then
			private.reagentBankSlotUpdates.pending[slot] = nil
			tremove(private.reagentBankSlotUpdates.list, i)
		end
	end
	if #private.reagentBankSlotUpdates.list > 0 then
		-- Some failed to scan so try again
		private.reagentBankSlotUpdateTimer:RunForFrames(2)
	end

	private.slotDB:SetQueryUpdatesPaused(false)
end



-- ============================================================================
-- Scanning Functions
-- ============================================================================

function private.ScanBagOrBank(bag)
	local numSlots = Container.GetNumSlots(bag)
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
	return private.ScanBagSlot(Container.GetBankContainer(), slot)
end

function private.ScanReagentBankSlot(slot)
	return private.ScanBagSlot(Container.GetReagentBankContainer(), slot)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IsAuctionableQueryFilter(row)
	local bag, slot = row:GetFields("bag", "slot")
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		return AuctionHouse.IsSellable(bag, slot)
	else
		return not TooltipScanning.HasUsedCharges(bag, slot)
	end
end

function private.RemoveExtraSlots(bag, numSlots)
	-- the number of slots of this bag may have changed, in which case we should remove any higher ones from our DB
	local query = private.slotDB:NewQuery()
		:Equal("bag", bag)
		:GreaterThan("slot", numSlots)
	for _, row in query:Iterator() do
		local levelItemString, quantity = row:GetFields("levelItemString", "quantity")
		private.ChangeBagItemTotal(bag, levelItemString, -quantity)
		private.slotDB:DeleteRow(row)
	end
	query:Release()
end

function private.ScanBagSlot(bag, slot)
	local texture, quantity, _, link, itemId, isBound = Container.GetItemInfo(bag, slot)
	if quantity and not itemId then
		-- We are pending item info for this slot so try again later to scan it
		return false
	elseif quantity == 0 then
		-- This item is going away, so try again later to scan it
		return false
	end
	local itemString = ItemString.Get(link)
	local levelItemString = itemString and ItemString.ToLevel(itemString)
	local slotId = SlotId.Join(bag, slot)
	local row = private.slotDB:GetUniqueRow("slotId", slotId)
	if levelItemString then
		if row then
			if row:GetField("itemLink") ~= link then
				row:SetField("itemLink", link)
					:SetField("itemString", ItemString.Get(link))
					:SetField("itemTexture", texture or ItemInfo.GetTexture(link))
					:SetField("isBound", isBound)
			end
			local oldLevelItemString, oldQuantity = row:GetFields("levelItemString", "quantity")
			if levelItemString ~= oldLevelItemString then
				-- Remove the old item and add the new one
				private.ChangeBagItemTotal(bag, oldLevelItemString, -oldQuantity)
				private.ChangeBagItemTotal(bag, levelItemString, quantity)
				row:SetField("quantity", quantity)
			elseif quantity ~= oldQuantity then
				-- Update the quantity
				private.ChangeBagItemTotal(bag, levelItemString, quantity - oldQuantity)
				row:SetField("quantity", quantity)
			end
			row:CreateOrUpdateAndRelease()
		else
			-- There was nothing here previously so create a new row
			private.slotDB:NewRow()
				:SetField("slotId", slotId)
				:SetField("bag", bag)
				:SetField("slot", slot)
				:SetField("itemLink", link)
				:SetField("itemString", ItemString.Get(link))
				:SetField("itemTexture", texture or ItemInfo.GetTexture(link))
				:SetField("quantity", quantity)
				:SetField("isBound", isBound)
				:CreateOrUpdateAndRelease()
			-- Add to the item totals
			private.ChangeBagItemTotal(bag, levelItemString, quantity)
		end
	elseif row then
		-- Nothing here now so delete the row and remove from the item totals
		local oldLevelItemString, oldQuantity = row:GetFields("levelItemString", "quantity")
		private.ChangeBagItemTotal(bag, oldLevelItemString, -oldQuantity)
		private.slotDB:DeleteRow(row)
		row:Release()
	end
	return true
end

function private.DelayedBagTrackingCallback()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end

function private.DelayedBagTrackingQuantityCallback()
	local newQuantities = TempTable.Acquire()
	private.quantityDB:NewQuery()
		:VirtualField("totalQuantity", "number", private.TotalQuantityVirtualField)
		:Select("levelItemString", "totalQuantity")
		:AsTable(newQuantities)
		:Release()
	local updatedItems = TempTable.Acquire()
	Table.GetChangedKeys(private.prevQuantities, newQuantities, updatedItems)
	if next(updatedItems) then
		-- Add the base items
		local baseItemStrings = TempTable.Acquire()
		for levelItemString in pairs(updatedItems) do
			baseItemStrings[ItemString.GetBaseFast(levelItemString)] = true
		end
		for baseItemString in pairs(baseItemStrings) do
			updatedItems[baseItemString] = true
		end
		TempTable.Release(baseItemStrings)
		wipe(private.prevQuantities)
		for levelItemString, quantity in pairs(newQuantities) do
			private.prevQuantities[levelItemString] = quantity
		end
		for _, callback in ipairs(private.quantityCallbacks) do
			callback(updatedItems)
		end
	end
	TempTable.Release(newQuantities)
	TempTable.Release(updatedItems)
end

function private.OnCallbackQueryUpdated()
	private.bagTrackingCallbackTimer:RunForFrames(2)
end

function private.OnQuantityCallbackQueryUpdated(...)
	private.bagTrackingQuantityCallbackTimer:RunForFrames(2)
end

function private.ChangeBagItemTotal(bag, levelItemString, changeQuantity)
	assert(changeQuantity ~= 0)
	local totalsTable = nil
	local field = nil
	if Container.IsBag(bag) then
		totalsTable = private.storage.bagQuantity
		field = "bagQuantity"
	elseif Container.IsBank(bag) then
		totalsTable = private.storage.bankQuantity
		field = "bankQuantity"
	elseif Container.IsReagentBank(bag) then
		totalsTable = private.storage.reagentBankQuantity
		field = "reagentBankQuantity"
	else
		error("Unexpected bag: "..tostring(bag))
	end
	totalsTable[levelItemString] = (totalsTable[levelItemString] or 0) + changeQuantity

	local row = private.quantityDB:GetUniqueRow("levelItemString", levelItemString)
	if row then
		local oldTotalQuantity = row:GetField("bagQuantity") + row:GetField("bankQuantity") + row:GetField("reagentBankQuantity")
		local oldValue = row:GetField(field)
		local newValue = oldValue + changeQuantity
		assert(newValue >= 0)
		if newValue == 0 and oldTotalQuantity == oldValue then
			-- Remove this row
			private.quantityDB:DeleteRow(row)
		else
			-- Update this row
			row:SetField(field, oldValue + changeQuantity)
				:Update()
		end
		row:Release()
	else
		-- Create a new row
		assert(changeQuantity > 0)
		private.quantityDB:NewRow()
			:SetField("levelItemString", levelItemString)
			:SetField("bagQuantity", 0)
			:SetField("bankQuantity", 0)
			:SetField("reagentBankQuantity", 0)
			:SetField(field, changeQuantity)
			:Create()
	end

	assert(totalsTable[levelItemString] >= 0)
	if totalsTable[levelItemString] == 0 then
		totalsTable[levelItemString] = nil
	end
end

function private.FilterNonItemLevelStrings(levelItemString)
	return levelItemString ~= ItemString.ToLevel(levelItemString)
end

function private.TotalQuantityVirtualField(row)
	return row:GetField("bagQuantity") + row:GetField("bankQuantity") + row:GetField("reagentBankQuantity")
end
