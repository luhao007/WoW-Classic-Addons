-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SlotId Functions
-- @module SlotId

local _, TSM = ...
TSM.SlotId = {}
local SlotId = TSM.SlotId
local SLOT_ID_MULTIPLIER = 1000



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Combines a container and slot into a slotId.
-- @tparam number container The container
-- @tparam number slot The slot
-- @treturn number The slotId
function SlotId.Join(container, slot)
	return container * SLOT_ID_MULTIPLIER + slot
end

--- Splits a slotId into a container and slot
-- @tparam number The slotId
-- @treturn number container The container
-- @treturn number slot The slot
function SlotId.Split(slotId)
	local container = floor(slotId / SLOT_ID_MULTIPLIER)
	local slot = slotId % SLOT_ID_MULTIPLIER
	return container, slot
end
