-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Container Functions
-- @module Container

local _, TSM = ...
local Container = TSM.Init("Util.Container")
local TempTable = TSM.Include("Util.TempTable")
local SlotId = TSM.Include("Util.SlotId")
local NUM_REAL_BAG_SLOTS = not TSM.IsWowClassic() and NUM_BAG_SLOTS + NUM_REAGENTBAG_SLOTS or NUM_BAG_SLOTS



-- ============================================================================
-- Module Functions
-- ============================================================================

function Container.GetBagSlotIterator()
	local result = TempTable.Acquire()
	for bag = 0, NUM_REAL_BAG_SLOTS do
		for slot = 1, Container.GetNumSlots(bag) do
			tinsert(result, SlotId.Join(bag, slot))
		end
	end
	return TempTable.Iterator(result)
end

function Container.GenerateSortedEmptyFamilySlots(bag, itemFamily, emptySlotIds, sortvalue)
	local bagFamily = bag ~= 0 and GetItemFamily(GetInventoryItemLink("player", Container.IDToInventoryID(bag))) or 0
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

--- Returns the total number of bag slots.
-- @treturn number The number of possible bag slots
function Container.GetNumBags()
	return NUM_REAL_BAG_SLOTS
end

--- Returns the indexes for the fist and last bank bag slots.
-- @treturn number The index of the first bank bag
-- @treturn number The index of the last bank bag
function Container.GetBankBagIndexes()
	return NUM_REAL_BAG_SLOTS + 1, NUM_REAL_BAG_SLOTS + NUM_BANKBAGSLOTS
end

--- Returns the total number of slots in the bag specified by the index.
-- @tparam number bag The index of the bag
-- @treturn number The number of slots
function Container.GetNumSlots(bag)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.GetContainerNumSlots(bag)
	else
		return GetContainerNumSlots(bag)
	end
end

--- Returns the number of free slots in a bag.
-- @tparam number bag The index of the bag
-- @treturn number The number of free slots
function Container.GetNumFreeSlots(bag)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.GetContainerNumFreeSlots(bag)
	else
		return GetContainerNumFreeSlots(bag)
	end
end

--- Returns the item ID in a container slot.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
-- @treturn number The item id stored in the bag slot
function Container.GetItemID(bag, slot)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.GetContainerItemID(bag, slot)
	else
		return GetContainerItemID(bag, slot)
	end
end

--- Returns info for an item in a container slot.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
-- @treturn number iconFileID The icon texture
-- @treturn number stackCount The number of items in the bag slot
-- @treturn boolean isLocked Whether the bag slot is locked or not
-- @treturn number quality The quality of the contained item
-- @treturn boolean isReadable Whether the item in the bag slot is readable
-- @treturn boolean hasLoot Whether the item in the bag slot is lootable
-- @treturn string link The itemLink of the item in the bag slot
-- @treturn boolean isFiltered Whether the item in the bag slot is filtered out
-- @treturn boolean hasNoValue Whether the item has no gold value
-- @treturn number itemId The unique identifier for the item in the bag slot
-- @treturn boolean isBound Whether the item is bound of the character
function Container.GetItemInfo(bag, slot)
	local iconFileID, stackCount, isLocked, quality, isReadable, hasLoot, link, isFiltered, hasNoValue, itemId, isBound = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	if TSM.IsWowDragonflightPTR() then
		local info = C_Container.GetContainerItemInfo(bag, slot)
		if info then
			iconFileID, stackCount, isLocked, quality, isReadable, hasLoot, link, isFiltered, hasNoValue, itemId, isBound = info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.HasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
		end
	else
		iconFileID, stackCount, isLocked, quality, isReadable, hasLoot, link, isFiltered, hasNoValue, itemId, isBound = GetContainerItemInfo(bag, slot)
	end
	return iconFileID, stackCount, isLocked, quality, isReadable, hasLoot, link, isFiltered, hasNoValue, itemId, isBound
end

--- Returns a link of the object located in the specified slot of a specified bag.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
-- @treturn string The item link for the object in the given bag slot
function Container.GetItemLink(bag, slot)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.GetContainerItemLink(bag, slot)
	else
		return GetContainerItemLink(bag, slot)
	end
end

--- Returns the mapped inventory index for the given bag index
-- @tparam number bag The index of the bag
-- @treturn number The inventory slot index
function Container.IDToInventoryID(bag)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.ContainerIDToInventoryID(bag)
	else
		return ContainerIDToInventoryID(bag)
	end
end

--- Uses an item from given bag slot.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
function Container.UseItem(bag, slot)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.UseContainerItem(bag, slot)
	else
		return UseContainerItem(bag, slot)
	end
end

--- Pick up an item from given bag slot.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
function Container.PickupItem(bag, slot)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.PickupContainerItem(bag, slot)
	else
		return PickupContainerItem(bag, slot)
	end
end

--- Places part of a stack of items from a container onto the cursor.
-- @tparam number bag The index of the bag
-- @tparam number slot The index of the slot whitin the bag
function Container.SplitItem(bag, slot, count)
	if TSM.IsWowDragonflightPTR() then
		return C_Container.SplitContainerItem(bag, slot, count)
	else
		return SplitContainerItem(bag, slot, count)
	end
end
