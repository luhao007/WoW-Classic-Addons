-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

if not TSMDEV then return end

local _, TSM = ...
TSMDEV.Profiling = {}
local Profiling = TSMDEV.Profiling
local Math = TSM.Include("Util.Math")
local private = {
	startTime = nil,
	nodes = {},
	nodeRuns = {},
	nodeStart = {},
	nodeTotal = {},
	nodeMaxContext = {},
	nodeMaxTime = {},
	nodeParent = {},
	nodeStack = {},
}
local NODE_PATH_SEP = "`"



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Starts profiling.
function Profiling.Start()
	assert(not private.startTime)
	private.startTime = debugprofilestop()
end

--- Starts profiling of a node.
-- Profiling must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
function Profiling.StartNode(node)
	if not private.startTime then
		-- profiling is not running
		return
	end
	local nodeStackLen = #private.nodeStack
	local parentNode = nodeStackLen > 0 and table.concat(private.nodeStack, NODE_PATH_SEP) or nil
	private.nodeStack[nodeStackLen + 1] = node
	node = table.concat(private.nodeStack, NODE_PATH_SEP)
	if private.nodeStart[node] then
		error("Node already started")
	end
	if not private.nodeTotal[node] then
		tinsert(private.nodes, node)
		private.nodeTotal[node] = 0
		private.nodeRuns[node] = 0
		private.nodeMaxContext[node] = nil
		private.nodeMaxTime[node] = 0
		private.nodeParent[node] = parentNode
	elseif private.nodeParent[node] ~= parentNode then
		error("Node changed parents")
	end
	private.nodeStart[node] = debugprofilestop()
end

--- Ends profiling of a node.
-- Profiling of this node must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @param[opt] arg An extra argument which is printed if this invocation represents the max duration for the node
function Profiling.EndNode(node, arg)
	if not private.startTime then
		-- profiling is not running
		return
	end
	local nodeStackLen = #private.nodeStack
	if node ~= private.nodeStack[nodeStackLen] then
		error("Node isn't at the top of the stack")
	end
	node = table.concat(private.nodeStack, NODE_PATH_SEP)
	if not private.nodeStart[node] then
		error("Node hasn't been started")
	end
	private.nodeStack[nodeStackLen] = nil
	local nodeTime = debugprofilestop() - private.nodeStart[node]
	private.nodeRuns[node] = private.nodeRuns[node] + 1
	private.nodeTotal[node] = private.nodeTotal[node] + nodeTime
	private.nodeStart[node] = nil
	if nodeTime > private.nodeMaxTime[node] then
		private.nodeMaxContext[node] = arg
		private.nodeMaxTime[node] = nodeTime
	end
end

--- Ends profiling and prints the results to chat.
function Profiling.End()
	if not private.startTime then
		-- profiling is not running
		return
	end
	local totalTime = debugprofilestop() - private.startTime
	print(format("Total: %.03f", Math.Round(totalTime, 0.001)))
	for _, node in ipairs(private.nodes) do
		local parentNode = private.nodeParent[node]
		local parentTotalTime = nil
		if parentNode then
			parentTotalTime = private.nodeTotal[parentNode]
		else
			parentTotalTime = totalTime
		end
		local nodeTotalTime = Math.Round(private.nodeTotal[node], 0.001)
		local pctTime = Math.Round(nodeTotalTime * 100 / parentTotalTime)
		local nodeRuns = private.nodeRuns[node]
		local nodeMaxContext = private.nodeMaxContext[node]
		local level = private.GetLevel(node)
		local name = strmatch(node, NODE_PATH_SEP.."?([^"..NODE_PATH_SEP.."]+)$")
		if nodeMaxContext ~= nil then
			local nodeMaxTime = private.nodeMaxTime[node]
			print(format("%s%s | %d%% | %.03f | %d | %.03f | %s", strrep("  ", level), name, pctTime, nodeTotalTime, nodeRuns, nodeMaxTime, tostring(nodeMaxContext)))
		else
			print(format("%s%s | %d%% | %.03f | %d", strrep("  ", level), name, pctTime, nodeTotalTime, nodeRuns))
		end
	end
	private.startTime = nil
	wipe(private.nodes)
	wipe(private.nodeRuns)
	wipe(private.nodeStart)
	wipe(private.nodeTotal)
	wipe(private.nodeMaxContext)
	wipe(private.nodeMaxTime)
end

--- Checks whether or not we're currently profiling.
-- @treturn boolean Whether or not we're currently profiling.
function Profiling.IsActive()
	return private.startTime and true or false
end

--- Gets the total memory used by TSM.
-- @treturn number The amount of memory being used in bytes
function Profiling.GetMemoryUsage()
	collectgarbage()
	UpdateAddOnMemoryUsage("TradeSkillMaster")
	return GetAddOnMemoryUsage("TradeSkillMaster") * 1024
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetLevel(node)
	local level = 0
	while node do
		level = level + 1
		node = private.nodeParent[node]
	end
	return level
end
