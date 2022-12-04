-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local SlotId = TSM.Init("Util.SlotId") ---@class Util.SlotId
local SLOT_ID_MULTIPLIER = 1000



-- ============================================================================
-- Module Functions
-- ============================================================================

---Combines a container and slot into a slotId.
---@param container number The container
---@param slot number The slot
---@return number @The slotId
function SlotId.Join(container, slot)
	return container * SLOT_ID_MULTIPLIER + slot
end

---Splits a slotId into a container and slot
---@param slotId number The slotId
---@return number @container The container
---@return number @slot The slot
function SlotId.Split(slotId)
	local container = floor(slotId / SLOT_ID_MULTIPLIER)
	local slot = slotId % SLOT_ID_MULTIPLIER
	return container, slot
end
