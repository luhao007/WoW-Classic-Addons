-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMWoW = select(2, ...).LibTSMWoW
local Item = LibTSMWoW:Init("API.Item")
local ItemClass = LibTSMWoW:Include("Util.ItemClass")
local ClientInfo = LibTSMWoW:Include("Util.ClientInfo")
local MAX_STACK_SIZE = 4000
local MAX_ITEM_LEVEL = 600



-- ============================================================================
-- Module Functions
-- ============================================================================

---Gets item info or queries it if it's not already loaded.
---@param item string The WoW item string
---@return string? name
---@return string? link
---@return Enum.ItemQuality? quality
---@return number? itemLevel
---@return number? minLevel
---@return number? maxStack
---@return number? vendorSell
---@return boolean? isBoP
---@return number? expansionId
---@return boolean? isCraftingReagent
function Item.GetInfo(item)
	local _, name, link, quality, itemLevel, minLevel, maxStack, vendorSell, bindType, expansionId, isCraftingReagent
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_ITEM) then
		name, link, quality, itemLevel, minLevel, _, _, maxStack, _, _, vendorSell, _, _, bindType, expansionId, _, isCraftingReagent = C_Item.GetItemInfo(item)
	else
		name, link, quality, itemLevel, minLevel, _, _, maxStack, _, _, vendorSell, _, _, bindType, expansionId, _, isCraftingReagent = GetItemInfo(item)
	end
	local isBoP = (bindType == LE_ITEM_BIND_ON_ACQUIRE or bindType == LE_ITEM_BIND_QUEST) and 1 or 0
	-- Some items (i.e. "i:117356::1:573") produce an negative min level
	minLevel = minLevel and max(minLevel, 0) or nil
	-- Some items (i.e. "i:40752" produce a very high max stack, so cap it)
	maxStack = maxStack and min(maxStack, MAX_STACK_SIZE) or nil
	return name, link, quality, itemLevel, minLevel, maxStack, vendorSell, isBoP, expansionId, isCraftingReagent
end

---Gets precached item info.
---@param itemId number The item ID
---@return number? texture
---@return number? classId
---@return number? subClassId
---@return number? invSlotId
function Item.GetInfoInstant(itemId)
	local _, classStr, subClassStr, equipSlot, texture, classId, subClassId
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_ITEM) then
		_, classStr, subClassStr, equipSlot, texture, classId, subClassId = C_Item.GetItemInfoInstant(itemId)
	else
		_, classStr, subClassStr, equipSlot, texture, classId, subClassId = GetItemInfoInstant(itemId)
	end
	equipSlot = equipSlot and equipSlot ~= "" and _G[equipSlot] or nil
	if not texture then
		return nil, nil, nil, nil
	end
	-- Some items (such as i:37445) give a classId of -1 for some reason in which case we can look up the classId
	if classId < 0 then
		classId = ItemClass.GetClassIdFromClassString(classStr)
		if not classId and not LibTSMWoW.IsRetail() then
			-- This can happen for items which don't yet exist in classic (i.e. WoW Tokens)
			return nil, nil, nil, nil
		end
		assert(subClassStr == "")
		subClassId = 0
	end
	local invSlotId = equipSlot and ItemClass.GetInventorySlotIdFromInventorySlotString(equipSlot) or 0
	return texture, classId, subClassId, invSlotId
end

---Gets the detailed item level for an item.
---@param item string The WoW item string
---@return number
function Item.GetDetailedItemLevel(item)
	local itemLevel
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_ITEM) then
		itemLevel = C_Item.GetDetailedItemLevelInfo(item)
	else
		itemLevel = GetDetailedItemLevelInfo(item)
	end
	return itemLevel
end

---Gets info on a pet.
---@param speciesId speciesId The pet species ID
---@return string? name
---@return texture? number
---@return petTypeId? number
function Item.GetPetInfo(speciesId)
	local name, texture, petTypeId = C_PetJournal.GetPetInfoBySpeciesID(speciesId)
	if not texture or not petTypeId then
		return nil, nil, nil
	end
	return name, texture, petTypeId
end

---Returns whether or not items of a class can have variations (potentially only with a specific sub class ID).
---@param classId number The class ID
---@return boolean canHaveVariations
---@return number? specificSubClassId
function Item.ClassCanHaveVariations(classId)
	if classId == Enum.ItemClass.Armor or classId == Enum.ItemClass.Weapon or classId == Enum.ItemClass.Battlepet then
		return true, nil
	elseif classId == Enum.ItemClass.Gem then
		return true, Enum.ItemGemSubclass.Artifactrelic
	else
		return false, nil
	end
end

---Returns whether or not the variation impacts the quality of the item for a given class.
---@param classId number The class ID
---@return boolean
function Item.VariationImpactsQualityByClass(classId)
	return classId == Enum.ItemClass.Armor or classId == Enum.ItemClass.Weapon
end

---Returns whether or not items of a class are disenchantable.
---@param classId number The class ID
---@return boolean
function Item.IsClassDisenchantable(classId)
	return classId == Enum.ItemClass.Armor or classId == Enum.ItemClass.Weapon or classId == Enum.ItemClass.Profession
end

---Returns whether or not items of an inventory slot are disenchantable.
---@param invSlotId number The inventory slot ID
---@return boolean
function Item.IsInventorySlotDisenchantable(invSlotId)
	return invSlotId ~= Enum.InventoryType.IndexBodyType and invSlotId ~= Enum.InventoryType.IndexTabardType
end

---Returns whether or not items of a quality are disenchantable.
---@param quality number The quality
---@return boolean
function Item.IsQualityDisenchantable(quality)
	return quality >= (Enum.ItemQuality.Good or Enum.ItemQuality.Uncommon) and quality < Enum.ItemQuality.Legendary
end

---Gets the color prefix string for a given item quality.
---@param quality number The quality
---@return string?
function Item.GetQualityColor(quality)
	return ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].hex
end

---Gets the item family.
---@param link string The item link
---@param classId number The class ID
---@return number
function Item.GetFamily(link, classId)
	if classId == Enum.ItemClass.Container then
		-- Bags report their family as what can go inside them, not what they can go inside
		return 0
	end
	return GetItemFamily(link) or 0
end

---Installs a hook for an item being linked.
---@param hookFunc fun(link: string): boolean The hook function
function Item.HookLink(hookFunc)
	local origHandleModifiedItemClick = HandleModifiedItemClick
	HandleModifiedItemClick = function(link, ...)
		return origHandleModifiedItemClick(link, ...) or hookFunc(link)
	end
	local origChatEdit_InsertLink = ChatEdit_InsertLink
	ChatEdit_InsertLink = function(link, ...)
		return origChatEdit_InsertLink(link, ...) or hookFunc(link)
	end
end

---Handles a modified item click from a UI.
---@param link string The link of the item which was clicked on
function Item.HandleModifiedItemClick(link)
	if not link then
		return
	end
	if IsShiftKeyDown() then
		Item.ShowRef(link)
	elseif IsControlKeyDown() then
		DressUpItemLink(link)
	end
end

---Sets the WoW item ref frame to the specified link.
---@param link string The itemLink to show the item ref frame for
function Item.ShowRef(link)
	if type(link) ~= "string" then
		return
	end
	-- Extract the Blizzard itemString for both items and pets
	local blizzItemString = strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(item:[^\124]+)\124.+$")
	blizzItemString = blizzItemString or strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(battlepet:[^\124]+)\124.+$")
	if blizzItemString then
		SetItemRef(blizzItemString, link, "LeftButton")
	end
end

---Gets the max item level.
---@return number
function Item.GetMaxItemLevel()
	return MAX_ITEM_LEVEL
end
