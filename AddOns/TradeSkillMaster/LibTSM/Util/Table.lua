-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Table Functions
-- @module Table

local _, TSM = ...
local Table = TSM.Init("Util.Table")
local TempTable = TSM.Include("Util.TempTable")
local private = {
	filterTemp = {},
	sortValueLookup = nil,
	iterContext = { arg = {}, index = {}, helperFunc = {}, cleanupFunc = {} },
	inwardIteratorContext = {},
}
setmetatable(private.iterContext.arg, { __mode = "k" })
setmetatable(private.iterContext.index, { __mode = "k" })
setmetatable(private.iterContext.helperFunc, { __mode = "k" })
setmetatable(private.iterContext.cleanupFunc, { __mode = "k" })



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Creates an iterator from a table.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @tparam table tbl The table (numerically-indexed) to iterate over
-- @tparam[opt] function helperFunc A helper function which gets passed the current index, value, and user-specified arg
-- and returns nothing if an entry in the table should be skipped or the result of an iteration loop
-- @param[opt] arg A value to be passed to the helper function
-- @tparam[opt] function cleanupFunc A function to be called (passed `tbl`) to cleanup at the end of iterator
-- @return An iterator with fields: `index, value` or the return of `helperFunc`
function Table.Iterator(tbl, helperFunc, arg, cleanupFunc)
	local iterContext = TempTable.Acquire()
	iterContext.data = tbl
	iterContext.arg = arg
	iterContext.index = 0
	iterContext.helperFunc = helperFunc
	iterContext.cleanupFunc = cleanupFunc
	return private.TableIterator, iterContext
end

--- Creates an iterator from the keys of a table.
-- @tparam table tbl The table to iterate over the keys of
-- @return An iterator with fields: `key`
function Table.KeyIterator(tbl)
	return private.TableKeyIterator, tbl, nil
end

--- Uses a function to filter the entries in a table.
-- @tparam table tbl The table to be filtered
-- @tparam function func The filter function which gets passed `key, value, ...` and returns true if that entry should
-- be removed from the table
-- @param[opt] ... Optional arguments to be passed to the filter function
function Table.Filter(tbl, func, ...)
	assert(not next(private.filterTemp))
	for k, v in pairs(tbl) do
		if func(k, v, ...) then
			tinsert(private.filterTemp, k)
		end
	end
	for _, k in ipairs(private.filterTemp) do
		tbl[k] = nil
	end
	wipe(private.filterTemp)
end

--- Removes all occurences of the value in the table.
-- Only the numerically-indexed entries are checked.
-- @tparam table tbl The table to remove the value from
-- @param value The value to remove
-- @treturn number The number of values removed
function Table.RemoveByValue(tbl, value)
	local numRemoved = 0
	for i = #tbl, 1, -1 do
		if tbl[i] == value then
			tremove(tbl, i)
			numRemoved = numRemoved + 1
		end
	end
	return numRemoved
end

--- Gets the table key by value.
-- @tparam table tbl The table to look through
-- @param value The value to get the key of
-- @return The key for the specified value or `nil`
function Table.KeyByValue(tbl, value)
	for k, v in pairs(tbl) do
		if v == value then
			return k
		end
	end
end

--- Gets the number of entries in the table.
-- This can be used when the count of a non-numerically-indexed table is desired (i.e. `#tbl` wouldn't work).
-- @tparam table tbl The table to get the number of entries in
-- @treturn number The number of entries
function Table.Count(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

--- Gets the distinct table key by value.
-- This function will assert if the value is not found in the table or if more than one key is found.
-- @tparam table tbl The table to look through
-- @param value The value to get the key of
-- @return The key for the specified value
function Table.GetDistinctKey(tbl, value)
	local key = nil
	for k, v in pairs(tbl) do
		if v == value then
			assert(not key)
			key = k
		end
	end
	assert(key)
	return key
end

--- Checks if two tables have the same entries (non-recursively).
-- @tparam table tbl1 The first table to check
-- @tparam table tbl2 The second table to check
-- @treturn boolean Whether or not the tables are equal
function Table.Equal(tbl1, tbl2)
	if Table.Count(tbl1) ~= Table.Count(tbl2) then
		return false
	end
	for k, v in pairs(tbl1) do
		if tbl2[k] ~= v then
			return false
		end
	end
	return true
end

--- Does a table sort with an extra value lookup step
-- @tparam table tbl The table to sort
-- @tparam table valueLookup The sort value lookup table
function Table.SortWithValueLookup(tbl, valueLookup)
	assert(not private.sortValueLookup and valueLookup)
	private.sortValueLookup = valueLookup
	sort(tbl, private.TableSortWithValueLookupHelper)
	private.sortValueLookup = nil
end

--- Creates an iterator which iterates through a numerically-indexed table (list) from the ends inward
-- @tparam table tbl The table to iterate over
-- @return An iterator with fields: `index`, `value`, `isAscending`
function Table.InwardIterator(tbl)
	local context = private.inwardIteratorContext
	assert(not context.inUse)
	context.inUse = true
	context.tbl = tbl
	context.leftIndex = 1
	context.rightIndex = #tbl
	context.isAscending = true
	return private.InwardIteratorHelper, context, 0
end

--- Reverses the direction of the current inward iterator
function Table.InwardIteratorReverse()
	local context = private.inwardIteratorContext
	assert(context.inUse)
	context.isAscending = not context.isAscending
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TableKeyIterator(tbl, prevKey)
	local key = next(tbl, prevKey)
	return key
end

function private.TableIterator(iterContext)
	iterContext.index = iterContext.index + 1
	if iterContext.index > #iterContext.data then
		local data = iterContext.data
		local cleanupFunc = iterContext.cleanupFunc
		TempTable.Release(iterContext)
		if cleanupFunc then
			cleanupFunc(data)
		end
		return
	end
	if iterContext.helperFunc then
		local result = TempTable.Acquire(iterContext.helperFunc(iterContext.index, iterContext.data[iterContext.index], iterContext.arg))
		if #result == 0 then
			TempTable.Release(result)
			return private.TableIterator(iterContext)
		end
		return TempTable.UnpackAndRelease(result)
	else
		return iterContext.index, iterContext.data[iterContext.index]
	end
end

function private.TableSortWithValueLookupHelper(a, b)
	local aValue = private.sortValueLookup[a]
	local bValue = private.sortValueLookup[b]
	if aValue == bValue then
		return a < b
	end
	return aValue < bValue
end

function private.InwardIteratorHelper(context)
	if context.leftIndex > context.rightIndex then
		wipe(context)
		return
	end
	local index = nil
	if context.isAscending then
		-- iterating in ascending order
		index = context.leftIndex
		context.leftIndex = context.leftIndex + 1
	else
		-- iterating in descending order
		index = context.rightIndex
		context.rightIndex = context.rightIndex - 1
	end
	return index, context.tbl[index], context.isAscending
end
