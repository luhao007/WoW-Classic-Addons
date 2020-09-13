-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- CSV Functions
-- @module CSV

local _, TSM = ...
local CSV = TSM.Init("Util.CSV")
local TempTable = TSM.Include("Util.TempTable")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function CSV.EncodeStart(keys)
	local context = TempTable.Acquire()
	context.keys = keys
	context.lines = TempTable.Acquire()
	context.lineParts = TempTable.Acquire()
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
	local result = table.concat(context.lines, "\n")
	TempTable.Release(context.lineParts)
	TempTable.Release(context.lines)
	TempTable.Release(context)
	return result
end

function CSV.Encode(keys, data)
	local context = CSV.EncodeStart(keys)
	for _, row in ipairs(data) do
		CSV.EncodeAddRowData(context, row)
	end
	return CSV.EncodeEnd(context)
end

function CSV.DecodeStart(str, fields)
	local func = gmatch(str, strrep("([^\n,]+),", #fields - 1).."([^\n,]+)(,?[^\n,]*)")
	if strjoin(",", func()) ~= table.concat(fields, ",").."," then
		return
	end
	local context = TempTable.Acquire()
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
	TempTable.Release(context)
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
