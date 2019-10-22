-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Math Functions
-- @module Math

local _, TSM = ...
TSM.Math = {}
local Math = TSM.Math
local private = {
	keysTemp = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Rounds a value to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round to the nearest multiple of
-- @treturn number The rounded value
function Math.Round(value, sig)
	sig = sig or 1
	return floor((value / sig) + 0.5) * sig
end

--- Rounds a value down to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round down to the nearest multiple of
-- @treturn number The rounded value
function Math.Floor(value, sig)
	sig = sig or 1
	return floor(value / sig) * sig
end

--- Rounds a value up to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round up to the nearest multiple of
-- @treturn number The rounded value
function Math.Ceil(value, sig)
	sig = sig or 1
	return ceil(value / sig) * sig
end

--- Scales a value from one range to another.
-- @tparam number value The number to be scaled
-- @tparam number fromStart The start value of the range to scale from
-- @tparam number fromEnd The end value of the range to scale from (can be less than fromStart)
-- @tparam number toStart The start value of the range to scale to
-- @tparam number toEnd The end value of the range to scale to (can be less than toStart)
-- @treturn number The scaled value
function Math.Scale(value, fromStart, fromEnd, toStart, toEnd)
	assert(value >= min(fromStart, fromEnd) and value <= max(fromStart, fromEnd))
	return toStart + ((value - fromStart) / (fromEnd - fromStart)) * (toEnd - toStart)
end

--- Calculates the has of the specified data
-- This data can handle data of type string or number. It can also handle a table being passed as the data assuming
-- all keys and values of the table are also hashable (strings, numbers, or tables with the same restriction). This
-- function uses the [djb2 algorithm](http://www.cse.yorku.ca/~oz/hash.html).
-- @param data The data to be hased
-- @tparam[opt] number hash The initial value of the hash
-- @treturn number The hash value
function Math.CalculateHash(data, hash)
	hash = hash or 5381
	local maxValue = 2 ^ 24
	local dataType = type(data)
	if dataType == "string" then
		-- iterate through 8 bytes at a time
		for i = 1, ceil(#data / 8) do
			local b1, b2, b3, b4, b5, b6, b7, b8 = strbyte(data, (i - 1) * 8 + 1, i * 8)
			hash = (hash * 33 + b1) % maxValue
			if not b2 then break end
			hash = (hash * 33 + b2) % maxValue
			if not b3 then break end
			hash = (hash * 33 + b3) % maxValue
			if not b4 then break end
			hash = (hash * 33 + b4) % maxValue
			if not b5 then break end
			hash = (hash * 33 + b5) % maxValue
			if not b6 then break end
			hash = (hash * 33 + b6) % maxValue
			if not b7 then break end
			hash = (hash * 33 + b7) % maxValue
			if not b8 then break end
			hash = (hash * 33 + b8) % maxValue
		end
	elseif dataType == "number" then
		assert(data == floor(data), "Invalid number")
		if data < 0 then
			data = data * -1
			hash = (hash * 33 + 59) % maxValue
		end
		while data > 0 do
			hash = (hash * 33 + data % 256) % maxValue
			data = floor(data / 256)
		end
	elseif dataType == "table" then
		local keys = nil
		if private.keysTemp.inUse then
			keys = TSM.TempTable.Acquire()
		else
			keys = private.keysTemp
			private.keysTemp.inUse = true
		end
		for k in pairs(data) do
			tinsert(keys, k)
		end
		sort(keys)
		for _, key in ipairs(keys) do
			hash = TSM.Math.CalculateHash(key, hash)
			hash = TSM.Math.CalculateHash(data[key], hash)
		end
		if keys == private.keysTemp then
			wipe(private.keysTemp)
		else
			TSM.TempTable.Release(keys)
		end
	elseif dataType == "boolean" then
		hash = (hash * 33 + (data and 1 or 0)) % maxValue
	elseif dataType == "nil" then
		hash = (hash * 33 + 17) % maxValue
	else
		error("Invalid data")
	end
	return hash
end
