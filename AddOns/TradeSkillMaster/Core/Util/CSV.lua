-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- CSV Functions
-- @module CSV

local _, TSM = ...
TSM.CSV = {}
local CSV = TSM.CSV
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function CSV.EncodeStart(keys)
	local context = { keys = keys, lines = {}, lineParts = {} }
	tinsert(context.lines, table.concat(keys, ","))
	return context
end

function CSV.EncodeAddRowData(context, data)
	wipe(context.lineParts)
	for _, key in ipairs(context.keys) do
		tinsert(context.lineParts, data[key] or "")
	end
	tinsert(context.lines, table.concat(context.lineParts, ","))
end

function CSV.EncodeAddRowDataRaw(context, ...)
	tinsert(context.lines, strjoin(",", ...))
end

function CSV.EncodeEnd(context)
	return table.concat(context.lines, "\n")
end

function CSV.Encode(keys, data)
	local context = CSV.EncodeStart(keys)
	for _, row in ipairs(data) do
		CSV.EncodeAddRowData(context, row)
	end
	return CSV.EncodeEnd(context)
end

function CSV.Decode(str)
	local keys = nil
	local result = {}
	local numResult = 0
	for line in gmatch(str, "[^\n]+") do
		if not keys then
			keys = { strsplit(",", line) }
		else
			local entry = {}
			local lineParts = { strsplit(",", line) }
			for i, key in ipairs(keys) do
				local linePart = lineParts[i]
				if linePart ~= "" then
					entry[key] = tonumber(linePart) or linePart
				end
			end
			numResult = numResult + 1
			result[numResult] = entry
		end
	end
	return keys, result
end

function CSV.DecodeStart(str, fields)
	local func = gmatch(str, strrep("([^\n,]+),", #fields - 1).."([^\n,]+)(,?[^\n,]*)")
	if strjoin(",", func()) ~= table.concat(fields, ",").."," then
		return
	end
	local context = TSM.TempTable.Acquire()
	context.func = func
	context.extraArgPos = #fields + 1
	context.result = true
	return context
end

function CSV.DecodeIterator(context)
	return private.DecodeIteratorHelper, context
end

function CSV.DecodeEnd(context)
	local result = context.result
	TSM.TempTable.Release(context)
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DecodeIteratorHelper(context)
	return private.DecodeIteratorHelper2(context, context.func())
end

function private.DecodeIteratorHelper2(context, v1, ...)
	if not v1 then
		return
	end
	if select(context.extraArgPos, v1, ...) ~= "" then
		context.result = false
		return
	end
	return v1, ...
end
