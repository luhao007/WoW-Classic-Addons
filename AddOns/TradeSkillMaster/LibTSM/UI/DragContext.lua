-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Drag Functions
-- @module DragContext

local _, TSM = ...
local DragContext = TSM.Init("Util.DragContext")
local private = {
	context = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function DragContext.Get()
	return private.context
end

function DragContext.Set(items)
	private.context = items
end

function DragContext.Clear()
	private.context = nil
end
