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
local private = {
	startTime = nil,
	nodes = {},
	nodeRuns = {},
	nodeStart = {},
	nodeTotal = {},
	nodeMaxContext = {},
	nodeMaxTime = {},
}

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
	assert(not private.nodeStart[node])
	if not private.nodeTotal[node] then
		tinsert(private.nodes, node)
		private.nodeTotal[node] = 0
		private.nodeRuns[node] = 0
		private.nodeMaxContext[node] = nil
		private.nodeMaxTime[node] = 0
	end
	private.nodeStart[node] = debugprofilestop()
end

--- Ends profiling of a node.
-- Profiling of this node must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @param[opt] arg An extra argument which is printed if this invocation represents the max duration for the node
function Profiling.EndNode(node, arg)
	if not private.startTime or not private.nodeStart[node] then
		-- profiling is not running
		return
	end
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
	print(format("Total: %.03f", TSM.Math.Round(totalTime, 0.001)))
	for _, node in ipairs(private.nodes) do
		local nodeTotalTime = TSM.Math.Round(private.nodeTotal[node], 0.001)
		local nodeRuns = private.nodeRuns[node]
		local nodeMaxContext = private.nodeMaxContext[node]
		if nodeMaxContext ~= nil then
			local nodeMaxTime = private.nodeMaxTime[node]
			print(format("  %s: %.03f (%d) | Max %.03f (%s)", node, nodeTotalTime, nodeRuns, nodeMaxTime, tostring(nodeMaxContext)))
		else
			print(format("  %s: %.03f (%d)", node, nodeTotalTime, nodeRuns))
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
