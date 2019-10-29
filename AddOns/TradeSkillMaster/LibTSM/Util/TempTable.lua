-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- TempTable Functions
-- @module TempTable

local _, TSM = ...
local TempTable = TSM.Init("Util.TempTable")
local Debug = TSM.Include("Util.Debug")
TSM.TempTable = TempTable
local private = {
	freeTempTables = {},
	tempTableState = {},
}
local NUM_TEMP_TABLES = 100
local RELEASED_TEMP_TABLE_MT = {
	__newindex = function(self, key, value)
		error("Attempt to access temp table after release")
	end,
	__index = function(self, key)
		error("Attempt to access temp table after release")
	end,
}
-- Set this to true to enable better debugging of temp table leaks
local DEBUG_TEMP_TABLE_LEAKS = true



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Acquires a temporary table.
-- Temporary tables are recycled tables which can be used instead of creating a new table every time one is needed for a
-- defined lifecycle. This avoids relying on the garbage collector and improves overall performance.
-- @param ... Any number of valuse to insert into the table initially
-- @treturn table The temporary table
function TempTable.Acquire(...)
	local tbl = tremove(private.freeTempTables, 1)
	assert(tbl, "Could not acquire temp table")
	setmetatable(tbl, nil)
	if DEBUG_TEMP_TABLE_LEAKS then
		private.tempTableState[tbl] = (Debug.GetStackLevelLocation(2) or "?").." -> "..(Debug.GetStackLevelLocation(3) or "?")
	else
		private.tempTableState[tbl] = true
	end
	for i = 1, select("#", ...) do
		tbl[i] = select(i, ...)
	end
	return tbl
end

--- Iterators over a temporary table, releasing it when done.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @tparam table tbl The temporary table to iterator over
-- @return An iterator with fields: `index, value` or the return of `helperFunc`
function TempTable.Iterator(tbl)
	assert(private.tempTableState[tbl])
	return private.TempTableIteratorHelper, tbl, 0
end

--- Releases a temporary table.
-- The temporary table will be returned to the pool and must not be accessed after being released.
-- @tparam table tbl The temporary table to release
function TempTable.Release(tbl)
	private.TempTableReleaseHelper(tbl)
end

--- Releases a temporary table and returns its values.
-- Releases the temporary table (see @{TempTable.Release}) and returns its unpacked values.
-- @tparam table tbl The temporary table to release and unpack
-- @return The result of calling `unpack` on the table
function TempTable.UnpackAndRelease(tbl)
	return private.TempTableReleaseHelper(tbl, unpack(tbl))
end

function TempTable.GetDebugInfo()
	local debugInfo = {}
	local counts = {}
	for _, info in pairs(private.tempTableState) do
		counts[info] = (counts[info] or 0) + 1
	end
	for info, count in pairs(counts) do
		tinsert(debugInfo, format("[%d] %s", count, type(info) == "string" and info or "?"))
	end
	if #debugInfo == 0 then
		tinsert(debugInfo, "<none>")
	end
	return debugInfo
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TempTableIteratorHelper(tbl, index)
	index = (index or 0) + 1
	if index > #tbl then
		TempTable.Release(tbl)
		return
	end
	return index, tbl[index]
end

function private.TempTableReleaseHelper(tbl, ...)
	assert(private.tempTableState[tbl])
	wipe(tbl)
	tinsert(private.freeTempTables, tbl)
	private.tempTableState[tbl] = nil
	setmetatable(tbl, RELEASED_TEMP_TABLE_MT)
	return ...
end



-- ============================================================================
-- Temp Table Setup
-- ============================================================================

do
	for _ = 1, NUM_TEMP_TABLES do
		local tempTbl = setmetatable({}, RELEASED_TEMP_TABLE_MT)
		tinsert(private.freeTempTables, tempTbl)
	end
end
