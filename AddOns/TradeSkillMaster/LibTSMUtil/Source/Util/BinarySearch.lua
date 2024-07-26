-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUtil = select(2, ...).LibTSMUtil
local BinarySearch = LibTSMUtil:Init("Util.BinarySearch")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

---Performs a raw binary search.
---@generic V: number|string
---@param numEntries number The total number of entries
---@param searchValue V The value to search for
---@param valueFunc fun(index: number, ...): V A function to call to get a comparable value for the specified index
---@param ... any Extra values to pass to valueFunc
---@return number|nil index
---@return number insertIndex
function BinarySearch.Raw(numEntries, searchValue, valueFunc, ...)
	local insertIndex = 1
	local low, high = 1, numEntries
	while low <= high do
		local mid = floor((low + high) / 2)
		local value = valueFunc(mid, ...)
		if value == searchValue then
			return mid, mid
		elseif value < searchValue then
			-- We're too low
			low = mid + 1
		else
			-- We're too high
			high = mid - 1
		end
		insertIndex = low
	end
	return nil, insertIndex
end

---Performs a binary search on a table.
---@generic V: number|string
---@param tbl V[] The table to search
---@param searchValue V The value to search for
---@return number|nil index
---@return number insertIndex
function BinarySearch.Table(tbl, searchValue)
	return BinarySearch.Raw(#tbl, searchValue, private.TableLookup, tbl)
end




-- ============================================================================
-- Module Functions
-- ============================================================================

function private.TableLookup(index, tbl)
	return tbl[index]
end
