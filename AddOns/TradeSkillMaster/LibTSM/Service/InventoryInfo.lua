-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local InventoryInfo = TSM.Init("Service.InventoryInfo")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Event = TSM.Include("Util.Event")
local SlotId = TSM.Include("Util.SlotId")
local ItemString = TSM.Include("Util.ItemString")
local Table = TSM.Include("Util.Table")
local private = {
	slotIdLocked = {},
	slotIdSoulboundCached = {},
	slotIdIsBoP = {},
	slotIdIsBoA = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

InventoryInfo:OnModuleLoad(function()
	Event.Register("ITEM_LOCKED", private.ItemLockedHandler)
	Event.Register("ITEM_UNLOCKED", private.ItemUnlockedHandler)
	Event.Register("BAG_UPDATE", private.BagUpdateHandler)
	Event.Register("PLAYERBANKSLOTS_CHANGED", private.BankSlotChangedHandler)
	if not TSM.IsWowClassic() then
		Event.Register("PLAYERREAGENTBANKSLOTS_CHANGED", private.ReagentBankSlotChangedHandler)
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Check if an item will go in a bag.
-- @tparam string link The item
-- @tparam number bag The bag index
-- @treturn boolean Whether or not the item will go in the bag
function InventoryInfo.ItemWillGoInBag(link, bag)
	if not link or not bag then
		return
	end
	if bag == BACKPACK_CONTAINER or bag == BANK_CONTAINER then
		return true
	elseif bag == REAGENTBANK_CONTAINER then
		return IsReagentBankUnlocked() and ItemInfo.IsCraftingReagent(link)
	end
	local itemFamily = GetItemFamily(link) or 0
	if ItemInfo.GetClassId(link) == LE_ITEM_CLASS_CONTAINER then
		-- bags report their family as what can go inside them, not what they can go inside
		itemFamily = 0
	end
	local _, bagFamily = GetContainerNumFreeSlots(bag)
	if not bagFamily then
		return
	end
	return bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0
end

function InventoryInfo.IsBagSlotLocked(bag, slot)
	return private.slotIdLocked[SlotId.Join(bag, slot)]
end

function InventoryInfo.IsSoulbound(bag, slot)
	local slotId = SlotId.Join(bag, slot)
	if private.slotIdSoulboundCached[slotId] then
		return private.slotIdIsBoP[slotId], private.slotIdIsBoA[slotId]
	end
	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end

	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()

	if GetContainerItemID(bag, slot) == ItemString.ToId(ItemString.GetPetCage()) then
		-- battle pets are never BoP or BoA
		private.slotIdSoulboundCached[slotId] = true
		private.slotIdIsBoP[slotId] = false
		private.slotIdIsBoA[slotId] = false
		return false, false
	end

	-- set TSMScanTooltip to show the inventory item
	if bag == BANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
	elseif bag == REAGENTBANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
	else
		TSMScanTooltip:SetBagItem(bag, slot)
	end

	-- scan the tooltip
	local numLines = TSMScanTooltip:NumLines()
	if numLines < 1 then
		-- the tooltip didn't fully load or there's nothing in this slot
		return nil, nil
	end
	local isBOP, isBOA = false, false
	for id = 2, numLines do
		local text = private.GetTooltipText(_G["TSMScanTooltipTextLeft"..id])
		if text then
			if (text == ITEM_BIND_ON_PICKUP and id < 4) or text == ITEM_SOULBOUND or text == ITEM_BIND_QUEST then
				isBOP = true
				break
			elseif (text == ITEM_ACCOUNTBOUND or text == ITEM_BIND_TO_ACCOUNT or text == ITEM_BIND_TO_BNETACCOUNT or text == ITEM_BNETACCOUNTBOUND) then
				isBOA = true
				break
			end
		end
	end
	private.slotIdSoulboundCached[slotId] = true
	private.slotIdIsBoP[slotId] = isBOP
	private.slotIdIsBoA[slotId] = isBOA
	return isBOP, isBOA
end

function InventoryInfo.HasUsedCharges(bag, slot)
	-- figure out if this item has a max number of charges
	local itemId = GetContainerItemID(bag, slot)
	if not itemId or itemId == ItemString.ToId(ItemString.GetPetCage()) then
		return false
	end
	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end

	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()
	TSMScanTooltip:SetItemByID(itemId)

	local maxCharges = private.GetScanTooltipCharges()
	if not maxCharges then
		return false
	end

	-- set TSMScanTooltip to show the inventory item
	if bag == BANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
	elseif bag == REAGENTBANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
	else
		TSMScanTooltip:SetBagItem(bag, slot)
	end

	-- check if there are used charges
	if maxCharges and private.GetScanTooltipCharges() ~= maxCharges then
		return true
	end
	return false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

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

function private.BagUpdateHandler(_, bag)
	-- clear the soulbound cache for everything in this bag
	Table.Filter(private.slotIdSoulboundCached, private.SlotIdSoulboundCachedFilter, bag)
end

function private.BankSlotChangedHandler(_, slot)
	if slot <= NUM_BANKGENERIC_SLOTS then
		-- one of the slots of the primary bank container changed, so just clear the cache for this slot
		private.slotIdSoulboundCached[SlotId.Join(BANK_CONTAINER, slot)] = nil
	else
		-- one of the extra bank bags changed, so clear the cache for the entire bag
		Table.Filter(private.slotIdSoulboundCached, private.SlotIdSoulboundCachedFilter, slot - NUM_BANKGENERIC_SLOTS)
	end
end

function private.SlotIdSoulboundCachedFilter(slotId, _, bag)
	return SlotId.Split(slotId) == bag
end

function private.ReagentBankSlotChangedHandler(_, slot)
	-- clear the soulbound cache for this slot
	private.slotIdSoulboundCached[SlotId.Join(REAGENTBANK_CONTAINER, slot)] = nil
end

function private.GetTooltipText(text)
	local textStr = strtrim(text and text:GetText() or "")
	if textStr == "" then return end

	local r, g, b = text:GetTextColor()
	return textStr, floor(r * 256), floor(g * 256), floor(b * 256)
end

function private.GetScanTooltipCharges()
	for id = 2, TSMScanTooltip:NumLines() do
		local text = private.GetTooltipText(_G["TSMScanTooltipTextLeft"..id])
		local num = text and strmatch(text, "%d+")
		local chargesStr = gsub(ITEM_SPELL_CHARGES, "%%d", "%%d+")
		if strfind(chargesStr, ":") then
			if num == 1 then
				chargesStr = gsub(chargesStr, "\1244(.+):.+;", "%1")
			else
				chargesStr = gsub(chargesStr, "\1244.+:(.+);", "%1")
			end
		end

		local maxCharges = text and strmatch(text, "^"..chargesStr.."$")

		if maxCharges then
			return maxCharges
		end
	end
end
