-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Table Functions
-- @module Table

local _, TSM = ...
local Table = TSM.Init("Util.Table")
local TempTable = TSM.Include("Util.TempTable")
local private = {
	filterTemp = {},
	sortValueLookup = nil,
	sortValueReverse = false,
	sortValueUnstable = false,
	iterContext = { arg = {}, index = {}, helperFunc = {}, cleanupFunc = {} },
	inwardIteratorContext = {},
}
setmetatable(private.iterContext.arg, { __mode = "k" })
setmetatable(private.iterContext.index, { __mode = "k" })
setmetatable(private.iterContext.helperFunc, { __mode = "k" })
setmetatable(private.iterContext.cleanupFunc, { __mode = "k" })
local READ_ONLY_TABLE_MT = {
	__index = function(_, key) error(format("Key (%s) does not exist in read-only table", tostring(key)), 2) end,
	__newindex = function(_, key) error(format("Writing (%s) to read-only table", tostring(key)), 2) end,
	__metatable = false,
}



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

--- Returns whether or not the table is currently sorted.
-- @tparam table tbl The table to check
-- @tparam[opt] function sortFunc The helper function to use to determine sort order (same prototype as is used for `sort()`)
-- @tparam[opt=1] number firstIndex The first index to check
-- @tparam[opt=#tbl] number lastIndex The last index to check
-- @treturn boolean Whether or not the table is sorted
function Table.IsSorted(tbl, sortFunc, firstIndex, lastIndex)
	sortFunc = sortFunc or private.DefaultSortFunc
	firstIndex = firstIndex or 1
	lastIndex = lastIndex or #tbl
	local prevValue = tbl[firstIndex]
	for i = firstIndex + 1, lastIndex do
		local value = tbl[i]
		if sortFunc(value, prevValue) then
			return false
		end
		prevValue = value
	end
	return true
end

--- Sorts a table with some optimizations over lua's sort().
-- @tparam table tbl The table to sort
-- @tparam[opt] function sortFunc The helper function to use to determine sort order (same prototype as is used for `sort()`)
function Table.Sort(tbl, sortFunc)
	if Table.IsSorted(tbl, sortFunc) then
		return
	end
	sort(tbl, sortFunc)
end

--- Returns whether or not the table is currently sorted with a value lookup table.
-- @tparam table tbl The table to sort
-- @tparam table valueLookup The sort value lookup table
-- @tparam[opt=1] number firstIndex The first index to check
-- @tparam[opt=#tbl] number lastIndex The last index to check
function Table.IsSortedWithValueLookup(tbl, valueLookup, firstIndex, lastIndex)
	assert(not private.sortValueLookup and valueLookup)
	private.sortValueLookup = valueLookup
	private.sortValueReverse = false
	private.sortValueUnstable = false
	local result = Table.IsSorted(tbl, private.TableSortWithValueLookupHelper, firstIndex, lastIndex)
	private.sortValueLookup = nil
	return result
end

--- Merges two sorted tables with a value lookup table.
-- @tparam table tbl1 The first table to merge
-- @tparam table tbl2 The second table to merge
-- @tparam table result The result table
-- @tparam table valueLookup The sort value lookup table
function Table.MergeSortedWithValueLookup(tbl1, tbl2, result, valueLookup)
	assert(not private.sortValueLookup and valueLookup)
	private.sortValueLookup = valueLookup
	private.sortValueReverse = false
	private.sortValueUnstable = false

	local index1, index2, resultIndex = 1, 1, 1
	while true do
		local value1 = tbl1[index1]
		local value2 = tbl2[index2]
		if value1 == nil and value2 == nil then
			-- we're done
			break
		elseif value1 == nil then
			result[resultIndex] = value2
			index2 = index2 + 1
		elseif value2 == nil then
			result[resultIndex] = value1
			index1 = index1 + 1
		elseif private.TableSortWithValueLookupHelper(value1, value2) then
			result[resultIndex] = value1
			index1 = index1 + 1
		else
			result[resultIndex] = value2
			index2 = index2 + 1
		end
		resultIndex = resultIndex + 1
	end
	private.sortValueLookup = nil
end

--- Does a table sort with an extra value lookup step.
-- @tparam table tbl The table to sort
-- @tparam table valueLookup The sort value lookup table
-- @tparam[opt=false] boolean reverse Reverse the sort order
-- @tparam[opt=false] boolean unstable Don't try to make the sort stable
function Table.SortWithValueLookup(tbl, valueLookup, reverse, unstable)
	assert(not private.sortValueLookup and valueLookup)
	private.sortValueLookup = valueLookup
	private.sortValueReverse = reverse
	private.sortValueUnstable = unstable
	Table.Sort(tbl, private.TableSortWithValueLookupHelper)
	private.sortValueLookup = nil
end

--- Creates an iterator which iterates through a numerically-indexed table (list) from the ends inward.
-- @tparam table tbl The table to iterate over
-- @return An iterator with fields: `index`, `value`, `isAscending`
function Table.InwardIterator(tbl)
	assert(not private.inwardIteratorContext[tbl])
	local context = TempTable.Acquire()
	private.inwardIteratorContext[tbl] = context
	context.inUse = true
	context.tbl = tbl
	context.leftIndex = 1
	context.rightIndex = #tbl
	context.isAscending = true
	return private.InwardIteratorHelper, context, 0
end

--- Reverses the direction of the current inward iterator.
-- @tparam table tbl The table being iterated over
function Table.InwardIteratorReverse(tbl)
	local context = private.inwardIteratorContext[tbl]
	assert(context and context.tbl == tbl)
	context.isAscending = not context.isAscending
end

--- Sets a table as read-only (modifications aren't checked).
-- @tparam table tbl The table to make read-only
function Table.SetReadOnly(tbl)
	setmetatable(tbl, READ_ONLY_TABLE_MT)
end

--- Appends all values passed in to the end of the table.
-- @tparam table tbl The table to insert the data into
-- @param ... The values to insert
function Table.Append(tbl, ...)
	local len = #tbl
	for i = 1, select("#", ...) do
		tbl[len + i] = select(i, ...)
	end
end

--- Performs a binary search on a sorted table and returns the index of the search value.
-- @tparam table tbl The table to search
-- @tparam number|string searchValue The value to search for
-- @tparam[opt=nil] function valueFunc A function to call to get the value to compare
-- @param ... Extra values to pass to valueFunc
-- @treturn ?number The index of the value or nil if it wasn't found
-- @treturn ?number The insert index
function Table.BinarySearch(tbl, searchValue, valueFunc, ...)
	if valueFunc then
		searchValue = valueFunc(searchValue, ...)
	end
	local insertIndex = 1
	local low, mid, high = 1, 0, #tbl
	while low <= high do
		mid = floor((low + high) / 2)
		local value = tbl[mid]
		if valueFunc then
			value = valueFunc(tbl[mid], ...)
		end
		if value == searchValue then
			return mid, mid
		elseif value < searchValue then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
		insertIndex = low
	end
	return nil, insertIndex
end

--- Inserts a value into a sorted table by using the insertIndex returned by Table.BinarySearch().
-- @see Table.BinarySearch
-- @tparam table tbl The table
-- @tparam number|string value The value to insert
-- @tparam[opt=nil] function valueFunc A function to call to get the value to compare
-- @param ... Extra values to pass to valueFunc
function Table.InsertSorted(tbl, value, valueFunc, ...)
	local _, insertIndex = Table.BinarySearch(tbl, value, valueFunc, ...)
	tinsert(tbl, insertIndex, value)
end

--- Gets the common values from two or more sorted tables.
-- @tparam table tbls The tables to compare
-- @tparam table result The result table
-- @tparam[opt=nil] function valueFunc A function to call to get the value to compare
-- @param ... Extra values to pass to valueFunc
function Table.GetCommonValuesSorted(tbls, result, valueFunc, ...)
	local numTbls = #tbls
	if numTbls == 0 then
		return
	elseif numTbls == 1 then
		for i = 1, #tbls[1] do
			result[i] = tbls[1][i]
		end
		return
	end

	-- initialize our iterator indexes
	for i = 1, numTbls do
		local t = tbls[i]
		assert(t._index == nil)
		t._index = 1
	end

	while true do
		-- go through each list and check if the current values are equal and get the max value
		local isDone, isEqual = false, true
		local equalValue, maxValue = nil, nil
		for i = 1, numTbls do
			local t = tbls[i]
			local value = t[t._index]
			value = value and valueFunc and valueFunc(value, ...)
			if not value then
				isDone = true
				break
			elseif i == 1 then
				equalValue = value
				maxValue = value
			else
				if value ~= equalValue then
					isEqual = false
				end
				if value > maxValue then
					maxValue = value
				end
			end
		end
		if isDone then
			break
		end
		if isEqual then
			-- all lists contained the same value, so insert it into our result and advance all the indexes
			tinsert(result, tbls[1][tbls[1]._index])
			for i = 1, numTbls do
				local t = tbls[i]
				t._index = t._index + 1
			end
		else
			-- all lists aren't on the same value, so advanced each one to at least the current max value
			for i = 1, numTbls do
				local t = tbls[i]
				local value = t[t._index]
				value = value and valueFunc and valueFunc(value, ...)
				while value and value < maxValue do
					t._index = t._index + 1
					value = t[t._index]
					value = value and valueFunc and valueFunc(value, ...)
				end
			end
			if isDone then
				break
			end
		end
	end

	-- clear all our iterator indexes
	for i = 1, numTbls do
		tbls[i]._index = nil
	end
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
		if private.sortValueUnstable then
			return false
		else
			return a > b
		end
	end
	if private.sortValueReverse then
		return aValue > bValue
	else
		return aValue < bValue
	end
end

function private.InwardIteratorHelper(context)
	if context.leftIndex > context.rightIndex then
		private.inwardIteratorContext[context.tbl] = nil
		TempTable.Release(context)
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

function private.DefaultSortFunc(a, b)
	return a < b
end
