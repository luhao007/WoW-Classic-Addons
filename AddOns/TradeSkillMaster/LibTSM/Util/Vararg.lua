-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Vararg Functions
-- @module Vararg

local _, TSM = ...
local Vararg = TSM.Init("Util.Vararg")
local private = {
	iterTemp = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Stores a varag into a table.
-- @tparam table tbl The table to store the values in
-- @param ... Zero or more values to store in the table
function Vararg.IntoTable(tbl, ...)
	for i = 1, select("#", ...) do
		tbl[i] = select(i, ...)
	end
end

--- Creates an iterator from a vararg.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @param ... The values to iterate over
-- @return An iterator with fields: `index, value`
function Vararg.Iterator(...)
	local tbl = private.iterTemp
	assert(not tbl.inUse)
	tbl.inUse = true
	tbl.length = select("#", ...)
	Vararg.IntoTable(private.iterTemp, ...)
	return private.IteratorHelper, private.iterTemp, 0
end

--- Returns whether not the value exists within the vararg.
-- @param value The value to search for
-- @param ... Any number of values to search in
-- @treturn boolean Whether or not the value was found in the vararg
function Vararg.In(value, ...)
	for i = 1, select("#", ...) do
		if value == select(i, ...) then
			return true
		end
	end
	return false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IteratorHelper(tbl, index)
	index = index + 1
	if index > tbl.length then
		wipe(tbl)
		return
	end
	return index, tbl[index]
end
