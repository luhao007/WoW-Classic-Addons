-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ObjectPool Functions.
-- @module ObjectPool

local _, TSM = ...
local ObjectPool = TSM.Init("Util.ObjectPool")
local Debug = TSM.Include("Util.Debug")
local private = {
	debugLeaks = TSM.IsTestEnvironment() or false,
	instances = {},
	context = {},
}
local DEBUG_STATS_MIN_COUNT = 1



-- ============================================================================
-- Metatable
-- ============================================================================

local OBJECT_POOL_MT = {
	__index = {
		Get = function(self)
			local context = private.context[self]
			local obj = tremove(context.freeList)
			if not obj then
				context.numCreated = context.numCreated + 1
				obj = context.createFunc()
				assert(obj)
			end
			if private.debugLeaks then
				context.state[obj] = (Debug.GetStackLevelLocation(2 + context.extraStackOffset) or "?").." -> "..(Debug.GetStackLevelLocation(3 + context.extraStackOffset) or "?")
			else
				context.state[obj] = "???"
			end
			return obj
		end,
		Recycle = function(self, obj)
			local context = private.context[self]
			assert(context.state[obj])
			context.state[obj] = nil
			tinsert(context.freeList, obj)
		end,
	},
	__newindex = function(self, key, value) error("Object pool cannot be modified") end,
	__metatable = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Create a new object pool.
-- @tparam string name The name of the object pool for debug purposes
-- @tparam function createFunc The function which is called to create a new object
-- @tparam[opt=0] number extraStackOffset The extra stack offset for tracking where objects are being used from or nil to disable stack info
-- @treturn ObjectPool The object pool object
function ObjectPool.New(name, createFunc, extraStackOffset)
	assert(createFunc)
	assert(not private.instances[name])
	local pool = setmetatable({}, OBJECT_POOL_MT)
	private.context[pool] = {
		createFunc = createFunc,
		extraStackOffset = extraStackOffset or 0,
		freeList = {},
		state = {},
		numCreated = 0,
	}
	private.instances[name] = private.context[pool]
	return pool
end

function ObjectPool.EnableLeakDebug()
	private.debugLeaks = true
end

function ObjectPool.GetDebugInfo()
	local debugInfo = {}
	for name, context in pairs(private.instances) do
		local numCreated, numInUse, info = private.GetDebugStats(context)
		debugInfo[name] = {
			numCreated = numCreated,
			numInUse = numInUse,
			info = info,
		}
	end
	return debugInfo
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetDebugStats(context)
	local counts = {}
	local totalCount = 0
	for _, caller in pairs(context.state) do
		counts[caller] = (counts[caller] or 0) + 1
		totalCount = totalCount + 1
	end
	local debugInfo = {}
	for info, count in pairs(counts) do
		if count > DEBUG_STATS_MIN_COUNT then
			tinsert(debugInfo, format("[%d] %s", count, info))
		end
	end
	if #debugInfo == 0 then
		tinsert(debugInfo, "<none>")
	end
	return context.numCreated, totalCount, debugInfo
end
