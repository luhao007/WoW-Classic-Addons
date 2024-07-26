-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMWoW = select(2, ...).LibTSMWoW
local Container = LibTSMWoW:Init("API.Container")
local Event = LibTSMWoW:Include("Service.Event")
local SlotId = LibTSMWoW:Include("Type.SlotId")
local ClientInfo = LibTSMWoW:Include("Util.ClientInfo")
local private = {
	numBagSlots = nil,
	minBankSlot = nil,
	maxBankSlot = nil,
	bankBags = nil,
	slotIdLocked = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Container:OnModuleLoad(function()
	private.numBagSlots = NUM_BAG_SLOTS + (ClientInfo.HasFeature(ClientInfo.FEATURES.REAGENT_BAG) and NUM_REAGENTBAG_SLOTS or 0)
	private.minBankSlot = private.numBagSlots + 1
	private.maxBankSlot = private.numBagSlots + NUM_BANKBAGSLOTS + (ClientInfo.HasFeature(ClientInfo.FEATURES.WARBAND_BANK) and 5 or 0)
	private.bankBags = {}
	 -- FIXME: Upvalue to work around a bug in luacheck
	local minBankSlot = private.minBankSlot
	local maxBankSlot = private.maxBankSlot
	for bag = minBankSlot, maxBankSlot do
		tinsert(private.bankBags, bag)
	end
	Event.Register("ITEM_LOCKED", private.ItemLockedHandler)
	Event.Register("ITEM_UNLOCKED", private.ItemUnlockedHandler)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Iterates over all bag slots
---@return fun(): number, number @An iterator with fields: `index`, `slotId`
function Container.GetBagSlotIterator()
	return private.BagSlotIterator, nil, SlotId.Join(0, 0)
end

---Gets the item family for items that can fit in the specified bag.
---@param bag number The bag
---@return number
function Container.GetBagItemFamily(bag)
	if bag == BACKPACK_CONTAINER then
		return 0
	end
	local inventoryId = C_Container.ContainerIDToInventoryID(bag)
	local inventoryLink = GetInventoryItemLink("player", inventoryId)
	return inventoryLink and GetItemFamily(inventoryLink) or 0
end

---Gets a list of empty slotIds and their sort values.
---@param bag number The bag to check
---@param itemFamily number The item family to check for
---@param emptySlotIds number[] A table to store the list of empty slotIds in
---@param sortvalue table<number, number> A table to store the sort values in
function Container.GenerateSortedEmptyFamilySlots(bag, itemFamily, emptySlotIds, sortvalue)
	local bagFamily = Container.GetBagItemFamily(bag)
	if bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0 then
		for slot = 1, Container.GetNumSlots(bag) do
			if not Container.GetItemLink(bag, slot) then
				local slotId = SlotId.Join(bag, slot)
				tinsert(emptySlotIds, slotId)
				sortvalue[slotId] = slotId + (bagFamily > 0 and 0 or 100000)
			end
		end
	end
end

---Returns the total number of bag slots.
---@return number
function Container.GetNumBags()
	return private.numBagSlots
end

---Returns whether or not the specified bag index is a character bag.
---@param bag number The bag to check
---@return boolean
function Container.IsBag(bag)
	return bag >= BACKPACK_CONTAINER and bag <= private.numBagSlots
end

---Returns whether or not the specified bag index is a bank bag (or base container).
---@param bag number The bag to check
---@return boolean
function Container.IsBank(bag)
	return bag == BANK_CONTAINER or bag >= private.minBankSlot and bag <= private.maxBankSlot
end

---Returns whether or not the specified bag index is a bank bag, the base bank container, or the reagent bank container.
---@param bag number The bag to check
---@return boolean
function Container.IsBankOrReagentBank(bag)
	return Container.IsBank(bag) or Container.IsReagentBank(bag)
end

---Returns whether or not the specified bag index is the reagent bank container.
---@param bag number The bag to check
---@return boolean
function Container.IsReagentBank(bag)
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.REAGENT_BANK) then
		return false
	end
	return bag == Container.GetReagentBankContainer()
end

---Iterates over the bank bags.
---@return fun(): number, number
function Container.BankBagIterator()
	return ipairs(private.bankBags)
end

---Gets the reagent bank container index.
---@return number
function Container.GetKeyringContainer()
	return KEYRING_CONTAINER
end

---Gets the backpack container index.
---@return number
function Container.GetBackpackContainer()
	return BACKPACK_CONTAINER
end

---Gets the bank container index.
---@return number
function Container.GetBankContainer()
	return BANK_CONTAINER
end

---Gets the reagent bank container index.
---@return number
function Container.GetReagentBankContainer()
	return ClientInfo.HasFeature(ClientInfo.FEATURES.REAGENT_BANK) and REAGENTBANK_CONTAINER or nil
end

---Returns whether or not the reagent bank is available for the current character.
---@return boolean
function Container.HasReagentBank()
	return ClientInfo.HasFeature(ClientInfo.FEATURES.REAGENT_BANK) and IsReagentBankUnlocked() and true or false
end

---Returns the total number of slots in the bag specified by the index.
---@param bag number The index of the bag
---@return number
function Container.GetNumSlots(bag)
	if bag == BANK_CONTAINER then
		return NUM_BANKGENERIC_SLOTS
	end
	return C_Container.GetContainerNumSlots(bag)
end

---Returns the number of free slots in a bag.
---@param bag number The index of the bag
---@return number numFreeSlots
---@return number? bagFamily
function Container.GetNumFreeSlots(bag)
	return C_Container.GetContainerNumFreeSlots(bag)
end

---Returns the item ID in a container slot.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@return number
function Container.GetItemId(bag, slot)
	return C_Container.GetContainerItemID(bag, slot)
end

---Returns info for an item in a container slot.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@return number iconFileID The icon texture
---@return number stackCount The number of items in the bag slot
---@return number quality The quality of the contained item
---@return string link The itemLink of the item in the bag slot
---@return number itemId The unique identifier for the item in the bag slot
---@return boolean isBound Whether the item is bound of the character
function Container.GetItemInfo(bag, slot)
	local info = C_Container.GetContainerItemInfo(bag, slot)
	if not info then
		return
	end
	return info.iconFileID, info.stackCount, info.quality, info.hyperlink, info.itemID, info.isBound
end

---Returns the size of the stack in a container slot.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@return number
function Container.GetStackCount(bag, slot)
	local _, stackCount = Container.GetItemInfo(bag, slot)
	return stackCount
end

---Returns whether or not an item is bound.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@return boolean
function Container.IsBound(bag, slot)
	local _, _, _, _, _, isBound = Container.GetItemInfo(bag, slot)
	return isBound
end

---Returns a link of the object located in the specified slot of a specified bag.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@return string
function Container.GetItemLink(bag, slot)
	return C_Container.GetContainerItemLink(bag, slot)
end

---Uses an item from given bag slot.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
function Container.UseItem(bag, slot)
	C_Container.UseContainerItem(bag, slot)
end

---Pick up an item from given bag slot.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
function Container.PickupItem(bag, slot)
	C_Container.PickupContainerItem(bag, slot)
end

---Places part of a stack of items from a container onto the cursor.
---@param bag number The index of the bag
---@param slot number The index of the slot whitin the bag
---@param count number The quantity to split
function Container.SplitItem(bag, slot, count)
	C_Container.SplitContainerItem(bag, slot, count)
end

---Register a secure hook function for when a container item is used.
---@param func function
function Container.SecureHookUseItem(func)
	hooksecurefunc(C_Container, "UseContainerItem", func)
end

---Queries the game for how many of an item the character owns.
---@param itemId number The item ID
---@return number bagQuantity
---@return number bankQuantity
---@return number reagentBankQuantity
function Container.GetItemCount(itemId)
	-- GetItemCount() is a bit buggy and not all combinations of arguments work, so carefully call it to calculate the quantities
	local bagQuantity = GetItemCount(itemId, false, false, false)
	local reagentBankQuantity = GetItemCount(itemId, false, false, true) - bagQuantity
	local bankQuantity = GetItemCount(itemId, true, false, true) - bagQuantity - reagentBankQuantity
	return bagQuantity, bankQuantity, reagentBankQuantity
end

---Returns if a bag slot is locked.
---@param bag number The index of the bag
---@param slot number The index of the slot within the bag
---@return boolean
function Container.IsBagSlotLocked(bag, slot)
	return private.slotIdLocked[SlotId.Join(bag, slot)] or false
end

---Gets the total number of free bag slots.
---@return number
function Container.GetTotalFreeBagSlots()
	return CalculateTotalNumberOfFreeBagSlots()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.BagSlotIterator(_, slotId)
	local bag, slot = SlotId.Split(slotId)
	while bag <= private.numBagSlots do
		slot = slot + 1
		if slot <= Container.GetNumSlots(bag) then
			return SlotId.Join(bag, slot)
		end
		bag = bag + 1
		slot = 0
	end
end

function private.ItemLockedHandler(_, bag, slot)
	if not slot then
		return
	end
	private.slotIdLocked[SlotId.Join(bag, slot)] = true
end

function private.ItemUnlockedHandler(_, bag, slot)
	if not slot then
		return
	end
	private.slotIdLocked[SlotId.Join(bag, slot)] = nil
end
