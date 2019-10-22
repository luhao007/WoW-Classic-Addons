-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Debug Functions
-- @module Debug

local _, TSM = ...
TSM.Debug = {}
local Debug = TSM.Debug
local private = {
	startSystemTimeMs = floor(GetTime() * 1000),
	startTimeMs = time() * 1000 + (floor(GetTime() * 1000) % 1000),
	functionSymbols = {},
	userdataSymbols = {},
	uCache = {},
	fCache = {},
	tCache = {},
	profilingContext = {
		startTime = nil,
		nodes = {},
		nodeRuns = {},
		nodeStart = {},
		nodeTotal = {},
		nodeMaxContext = {},
		nodeMaxTime = {},
	},
	localLinesTemp = {},
}

do
	-- populate private tables with globals
	for k, v in pairs(getfenv(0)) do
		if type(v) == "function" then
			tinsert(private.functionSymbols, k)
		elseif type(v) == "table" then
			if type(rawget(v,0)) == "userdata" then
				tinsert(private.userdataSymbols, k)
			end
		end
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Dumps the contents of a table.
-- @tparam string tbl The table to be dumped
-- @tparam[opt=false] boolean returnResult Return the result as a string rather than printing to chat
-- @within General
function Debug.DumpTable(tbl, returnResult)
	if returnResult then
		local result = {}
		private.Dump(tbl, result)
		return result
	else
		private.Dump(tbl)
	end
end

--- Starts profiling.
-- @within Profiling
function Debug.StartProfiling()
	assert(not private.profilingContext.startTime)
	private.profilingContext.startTime = debugprofilestop()
end

--- Starts profiling of a node.
-- Profiling must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @within Profiling
function Debug.StartProfilingNode(node)
	if not private.profilingContext.startTime then
		-- profiling is not running
		return
	end
	assert(not private.profilingContext.nodeStart[node])
	if not private.profilingContext.nodeTotal[node] then
		tinsert(private.profilingContext.nodes, node)
		private.profilingContext.nodeTotal[node] = 0
		private.profilingContext.nodeRuns[node] = 0
		private.profilingContext.nodeMaxContext[node] = nil
		private.profilingContext.nodeMaxTime[node] = 0
	end
	private.profilingContext.nodeStart[node] = debugprofilestop()
end

--- Ends profiling of a node.
-- Profiling of this node must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @within Profiling
function Debug.EndProfilingNode(node, arg)
	if not private.profilingContext.startTime or not private.profilingContext.nodeStart[node] then
		-- profiling is not running
		return
	end
	local nodeTime = debugprofilestop() - private.profilingContext.nodeStart[node]
	private.profilingContext.nodeRuns[node] = private.profilingContext.nodeRuns[node] + 1
	private.profilingContext.nodeTotal[node] = private.profilingContext.nodeTotal[node] + nodeTime
	private.profilingContext.nodeStart[node] = nil
	if nodeTime > private.profilingContext.nodeMaxTime[node] then
		private.profilingContext.nodeMaxContext[node] = arg
		private.profilingContext.nodeMaxTime[node] = nodeTime
	end
end

--- Ends profiling and prints the results to chat.
-- @within Profiling
function Debug.EndProfiling()
	if not private.profilingContext.startTime then
		-- profiling is not running
		return
	end
	local totalTime = debugprofilestop() - private.profilingContext.startTime
	print(format("Total: %.03f", TSM.Math.Round(totalTime, 0.001)))
	for _, node in ipairs(private.profilingContext.nodes) do
		local nodeTotalTime = TSM.Math.Round(private.profilingContext.nodeTotal[node], 0.001)
		local nodeRuns = private.profilingContext.nodeRuns[node]
		local nodeMaxContext = private.profilingContext.nodeMaxContext[node]
		if nodeMaxContext ~= nil then
			local nodeMaxTime = private.profilingContext.nodeMaxTime[node]
			print(format("  %s: %.03f (%d) | Max %.03f (%s)", node, nodeTotalTime, nodeRuns, nodeMaxTime, tostring(nodeMaxContext)))
		else
			print(format("  %s: %.03f (%d)", node, nodeTotalTime, nodeRuns))
		end
	end
	private.profilingContext.startTime = nil
	wipe(private.profilingContext.nodes)
	wipe(private.profilingContext.nodeRuns)
	wipe(private.profilingContext.nodeStart)
	wipe(private.profilingContext.nodeTotal)
	wipe(private.profilingContext.nodeMaxContext)
	wipe(private.profilingContext.nodeMaxTime)
end

--- Checks whether or not we're currently profiling.
-- @treturn boolean Whether or not we're currently profiling.
-- @within Profiling
function Debug.IsProfiling()
	return private.profilingContext.startTime and true or false
end

--- Gets debug stack info.
-- @tparam number targetLevel The stack level to get info for
-- @tparam[opt] thread thread The thread to get info for
-- @treturn string The stack frame info (file and line number) or `nil`
-- @within Stack
function Debug.GetDebugStackInfo(targetLevel, thread)
	targetLevel = targetLevel + 1
	assert(targetLevel > 0)
	for level = 1, 100 do
		local stackLine = nil
		if thread then
			stackLine = debugstack(thread, level, 1, 0)
		else
			stackLine = debugstack(level, 1, 0)
		end
		if not stackLine then
			return
		end
		stackLine = strmatch(stackLine, "^%.*([^:]+:%d+):")
		-- ignore the class code's wrapper function
		if stackLine and not strmatch(stackLine, "LibTSMClass%.lua:") then
			targetLevel = targetLevel - 1
			if targetLevel == 0 then
				stackLine = gsub(stackLine, "/", "\\")
				stackLine = gsub(stackLine, ".-lMaster\\", "TSM\\")
				return stackLine
			end
		end
	end
end

--- Gets debug information about a given stack level.
-- @tparam number level The stack level to get info for
-- @tparam[opt] thread thread The thread to get info for
-- @tparam[opt] string prevStackFunc The previous level's function
-- @treturn string File path or `nil`
-- @treturn number Line number or `nil`
-- @treturn string Function name or `nil`
-- @treturn string New value of the previous level's function name `nil`
-- @within Stack
function Debug.GetStackLevelInfo(level, thread, prevStackFunc)
	local stackLine = nil
	if thread then
		stackLine = debugstack(thread, level, 1, 0)
	else
		level = level + 1
		stackLine = debugstack(level, 1, 0)
	end
	local locals = debuglocals(level)
	stackLine = gsub(stackLine, "%.%.%.T?r?a?d?e?S?k?i?l?lM?a?ster([_A-Za-z]*)\\", "TradeSkillMaster%1\\")
	stackLine = gsub(stackLine, "%.%.%.", "")
	stackLine = gsub(stackLine, "`", "<", 1)
	stackLine = gsub(stackLine, "'", ">", 1)
	stackLine = strtrim(stackLine)
	if stackLine == "" then
		return
	end

	-- Parse out the file, line, and function name
	local locationStr, functionStr = strmatch(stackLine, "^(.-): in function (<[^\n]*>)")
	if not locationStr then
		locationStr, functionStr = strmatch(stackLine, "^(.-): in (main chunk)")
	end
	if not locationStr then
		return
	end
	locationStr = strsub(locationStr, strfind(locationStr, "TradeSkillMaster") or 1)
	locationStr = gsub(locationStr, "TradeSkillMaster([^%.])", "TSM%1")
	functionStr = functionStr and gsub(gsub(functionStr, ".*\\", ""), "[<>]", "") or ""
	local file, line = strmatch(locationStr, "^(.+):(%d+)$")
	file = file or locationStr
	line = tonumber(line) or 0

	local func = strsub(functionStr, strfind(functionStr, "`") and 2 or 1, -1) or "?"
	func = func ~= "" and func or "?"

	if strfind(locationStr, "LibTSMClass%.lua:") then
		-- ignore stack frames from the class code's wrapper function
		if func ~= "?" and prevStackFunc and not strmatch(func, "^.+:[0-9]+$") and strmatch(prevStackFunc, "^.+:[0-9]+$") then
			-- this stack frame includes the class method we were accessing in the previous one, so go back and fix it up
			local className = locals and strmatch(locals, "\n +str = \"([A-Za-z_0-9]+):[0-9A-F]+\"\n") or "?"
			prevStackFunc = className.."."..func
		end
		return nil, nil, nil, nil, prevStackFunc
	end

	-- add locals for addon functions (debuglocals() doesn't always work - or ever for threads)
	local localsStr = locals and private.ParseLocals(locals, file) or ""
	return file, line, func, localsStr, nil
end

--- Gets the current time in milliseconds since epoch
-- The time returned could be up to a second off absolutely, but relative times are guarenteed to be accurate.
-- @treturn number The current time in milliseconds since epoch
function Debug.GetTimeMilliseconds()
	local systemTimeMs = floor(GetTime() * 1000)
	return private.startTimeMs + (systemTimeMs - private.startSystemTimeMs)
end



-- ============================================================================
-- Local copy of Blizzard's /dump command with some added features
-- ============================================================================

function private.CacheFunction(value, newName)
	if not next(private.fCache) then
		for _, k in ipairs(private.functionSymbols) do
			local v = getglobal(k)
			if type(v) == "function" then
				private.fCache[v] = "["..k.."]"
			end
		end
		for k, v in pairs(getfenv(0)) do
			if type(v) == "function" then
				if not private.fCache[v] then
					private.fCache[v] = "["..k.."]"
				end
			end
		end
	end
	local name = private.fCache[value]
	if not name and newName then
		private.fCache[value] = newName
	end
	return name
end

function private.CacheUserdata(value, newName)
	if not next(private.uCache) then
		for _, k in ipairs(private.userdataSymbols) do
			local v = getglobal(k)
			if type(v) == "table" then
				local u = rawget(v,0)
				if type(u) == "userdata" then
					private.uCache[u] = k.."[0]"
				end
			end
		end
		for k, v in pairs(getfenv(0)) do
			if type(v) == "table" then
				local u = rawget(v, 0)
				if type(u) == "userdata" then
					if not private.uCache[u] then
						private.uCache[u] = k.."[0]"
					end
				end
			end
		end
	end
	local name = private.uCache[value]
	if not name and newName then
		private.uCache[value] = newName
	end
	return name
end

function private.CacheTable(value, newName)
	local name = private.tCache[value]
	if not name and newName then
		private.tCache[value] = newName
	end
	return name
end

function private.Write(msg)
	if private.result then
		tinsert(private.result, msg)
	else
		print(msg)
	end
end

function private.PrepSimple(val)
	local valType = type(val)
	if valType == "nil" then
		return "nil"
	elseif valType == "number" then
		return val
	elseif valType == "boolean" then
		return val and "true" or "false"
	elseif valType == "string" then
		local len = #val
		if len > 200 then
			local more = len - 200
			val = strsub(val, 1, 200)
			return gsub(format("%q...+%s", val, more), "[|]", "||")
		else
			return gsub(format("%q", val), "[|]", "||")
		end
	elseif valType == "function" then
		local fName = private.CacheFunction(val)
		return fName and format("<%s %s>", valType, fName) or format("<%s>", valType)
	elseif valType == "userdata" then
		local uName = private.CacheUserdata(val)
		return uName and format("<%s %s>", valType, uName) or format("<%s>", valType)
	elseif valType == "table" then
		local tName = private.CacheTable(val)
		return tName and format("<%s %s>", valType, tName) or format("<%s>", valType)
	else
		error("Bad type '"..valType.."' to private.PrepSimple")
	end
end

function private.PrepSimpleKey(val)
	if type(val) == "string" and #val <= 200 and strmatch(val, "^[a-zA-Z_][a-zA-Z0-9_]*$") then
		return val
	end
	return format("[%s]", private.PrepSimple(val))
end

function private.DumpTableContents(val, prefix, firstPrefix, key)
	local showCount = 0
	local oldDepth = private.depth
	local oldKey = key

	-- Use this to set the cache name
	private.CacheTable(val, oldKey or "value")

	local iter = pairs(val)
	local nextK, nextV = iter(val, nil)

	while nextK do
		local k,v = nextK, nextV
		nextK, nextV = iter(val, k)
		showCount = showCount + 1
		if showCount <= 30 then
			local prepKey = private.PrepSimpleKey(k)
			if oldKey == nil then
				key = prepKey
			elseif strsub(prepKey, 1, 1) == "[" then
				key = oldKey..prepKey
			else
				key = oldKey.."."..prepKey
			end
			private.depth = oldDepth + 1

			local rp = format("|cff88ccff%s%s|r=", firstPrefix, prepKey)
			firstPrefix = prefix
			private.DumpValue(v, prefix, rp, (nextK and ",") or "", key)
		end
	end
	local cutoff = showCount - 30
	if cutoff > 0 then
		private.Write(format("%s|cffff0000<skipped %s>|r", firstPrefix, cutoff))
	end
	private.depth = oldDepth
end

-- Return the specified value
function private.DumpValue(val, prefix, firstPrefix, suffix, key)
	local valType = type(val)

	if valType == "userdata" then
		local uName = private.CacheUserdata(val, "value")
		if uName then
			private.Write(format("%s|cff88ff88<%s %s>|r%s", firstPrefix, valType, uName, suffix))
		else
			private.Write(format("%s|cff88ff88<%s>|r%s", firstPrefix, valType, suffix))
		end
		return
	elseif valType == "function" then
		local fName = private.CacheFunction(val, "value")
		if fName then
			private.Write(format("%s|cff88ff88<%s %s>|r%s", firstPrefix, valType, fName, suffix))
		else
			private.Write(format("%s|cff88ff88<%s>|r%s", firstPrefix, valType, suffix))
		end
		return
	elseif valType ~= "table" then
		private.Write(format("%s%s%s", firstPrefix, private.PrepSimple(val), suffix))
		return
	end

	local cacheName = private.CacheTable(val)
	if cacheName then
		private.Write(format("%s|cffffcc00%s|r%s", firstPrefix, cacheName, suffix))
		return
	end

	if private.depth >= 10 then
		private.Write(format("%s|cffff0000<table (too deep)>|r%s", firstPrefix, suffix))
		return
	end

	local oldPrefix = prefix
	prefix = prefix.."  "
	private.Write(firstPrefix.."{")
	private.DumpTableContents(val, prefix, prefix, key)
	private.Write(oldPrefix.."}"..suffix)
end

-- Dump the specified list of value
function private.Dump(value, result)
	private.depth = 0
	private.result = result
	wipe(private.uCache)
	wipe(private.fCache)
	wipe(private.tCache)

	if type(value) == "table" and not next(value) then
		private.Write("empty result")
		return
	end

	private.DumpValue(value, "", "", "")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ParseLocals(locals, file)
	if strmatch(file, "^%[") then
		return
	end

	local fileName = strmatch(file, "([A-Za-z]+)%.lua")
	local isBlizzardFile = strmatch(file, "Interface\\FrameXML\\")
	local isPrivateTable, isLocaleTable, isPackageTable, isSelfTable = false, false, false, false
	wipe(private.localLinesTemp)
	locals = gsub(locals, "<([a-z]+)> {[\n\t ]+}", "<%1> {}")
	locals = gsub(locals, " = <function> defined @", "@")
	locals = gsub(locals, "<table> {", "{")

	for localLine in gmatch(locals, "[^\n]+") do
		local shouldIgnoreLine = false
		if strmatch(localLine, "^ *%(") then
			shouldIgnoreLine = true
		elseif strmatch(localLine, "LibTSMClass%.lua:") then
			-- ignore class methods
			shouldIgnoreLine = true
		elseif strmatch(localLine, "<unnamed> {}$") then
			-- ignore internal WoW frame members
			shouldIgnoreLine = true
		end
		if not shouldIgnoreLine then
			local level = #strmatch(localLine, "^ *")
			localLine = strrep("  ", level)..strtrim(localLine)
			localLine = gsub(localLine, "Interface\\[aA]dd[Oo]ns\\TradeSkillMaster", "TSM")
			localLine = gsub(localLine, "\124", "\\124")
			if level > 0 then
				if isBlizzardFile then
					-- for Blizzard stack frames, only include level 0 locals
					shouldIgnoreLine = true
				elseif isPrivateTable and strmatch(localLine, "^ *[A-Z].+@TSM") then
					-- ignore functions within the private table
					shouldIgnoreLine = true
				elseif isLocaleTable then
					-- ignore everything within the locale table
					shouldIgnoreLine = true
				elseif isPackageTable then
					-- ignore the package table completely
					shouldIgnoreLine = true
				elseif (isSelfTable or isPrivateTable) and strmatch(localLine, "^ *[_a-zA-Z0-9]+ = {}") then
					-- ignore empty tables within objects or the private table
					shouldIgnoreLine = true
				end
			end
			if not shouldIgnoreLine then
				tinsert(private.localLinesTemp, localLine)
			end
			if level == 0 then
				isPackageTable = strmatch(localLine, "%s*"..fileName.." = {") and true or false
				isPrivateTable = strmatch(localLine, "%s*private = {") and true or false
				isLocaleTable = strmatch(localLine, "%s*L = {") and true or false
				isSelfTable = strmatch(localLine, "%s*self = {") and true or false
			end
		end
	end

	return #private.localLinesTemp > 0 and table.concat(private.localLinesTemp, "\n") or nil
end
