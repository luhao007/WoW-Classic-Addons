-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Container = TSM.Init("Util.Container") ---@class Util.Container
local Environment = TSM.Include("Environment")
local SlotId = TSM.Include("Util.SlotId")
local private = {
	numBagSlots = nil,
	bankBags = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Container:OnModuleLoad(function()
	private.numBagSlots = NUM_BAG_SLOTS + (Environment.HasFeature(Environment.FEATURES.REAGENT_BAG) and NUM_REAGENTBAG_SLOTS or 0)
	private.bankBags = {}
	for bag = private.numBagSlots + 1, private.numBagSlots + NUM_BANKBAGSLOTS do
		tinsert(private.bankBags, bag)
	end
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
			if not Container.GetItemInfo(bag, slot) then
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

---Returns whether or not the specified bag is a bank bag.
---@param bag number The bag to check
---@return boolean
function Container.IsBankBag(bag)
	return bag >= (private.numBagSlots + 1) and bag <= (private.numBagSlots + NUM_BANKBAGSLOTS)
end

---Iterates over the bank bags.
---@return fun(): number, number
function Container.BankBagIterator()
	return ipairs(private.bankBags)
end

---Returns the total number of slots in the bag specified by the index.
---@param bag number The index of the bag
---@return number
function Container.GetNumSlots(bag)
	return C_Container.GetContainerNumSlots(bag)
end

---Returns the number of free slots in a bag.
---@param bag number The index of the bag
---@return number
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
---@return boolean isLocked Whether the bag slot is locked or not
---@return number quality The quality of the contained item
---@return boolean isReadable Whether the item in the bag slot is readable
---@return boolean hasLoot Whether the item in the bag slot is lootable
---@return string link The itemLink of the item in the bag slot
---@return boolean isFiltered Whether the item in the bag slot is filtered out
---@return boolean hasNoValue Whether the item has no gold value
---@return number itemId The unique identifier for the item in the bag slot
---@return boolean isBound Whether the item is bound of the character
function Container.GetItemInfo(bag, slot)
	local info = C_Container.GetContainerItemInfo(bag, slot)
	if not info then
		return
	end
	return info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
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
