-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Future Functions.
-- @module Future

local _, TSM = ...
local Future = TSM.Init("Util.Future")
local private = {
	context = {},
}



-- ============================================================================
-- Metatable
-- ============================================================================

local FUTURE_MT = {
	__index = {
		GetName = function(self)
			local context = private.context[self]
			return context.name
		end,
		SetScript = function(self, script, handler)
			assert(type(handler) == "function")
			local context = private.context[self]
			if script == "OnDone" then
				assert(context.state ~= "DONE")
				assert(not context.onDone)
				context.onDone = handler
			elseif script == "OnCleanup" then
				assert(not context.onCleanup)
				context.onCleanup = handler
			else
				error("Unknown script: "..tostring(script))
			end
		end,
		Start = function(self)
			local context = private.context[self]
			assert(context.state == "RESET")
			context.state = "STARTED"
		end,
		Cancel = function(self)
			local context = private.context[self]
			assert(context.state ~= "RESET")
			private.Reset(self)
		end,
		Done = function(self, value)
			local context = private.context[self]
			assert(context.state == "STARTED")
			context.state = "DONE"
			context.value = value
			if context.onDone then
				context.onDone(self)
			end
		end,
		IsDone = function(self)
			local context = private.context[self]
			assert(context.state ~= "RESET")
			return context.state == "DONE"
		end,
		GetValue = function(self)
			local context = private.context[self]
			assert(context.state == "DONE")
			local value = context.value
			private.Reset(self)
			return value
		end,
	},
	__newindex = function(self, key, value) error("Future cannot be modified") end,
	__metatable = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Create a new future.
-- @tparam string name The name of the future for debugging purposes
-- @treturn Future The future object
function Future.New(name)
	local future = setmetatable({}, FUTURE_MT)
	private.context[future] = {
		name = name,
	}
	private.Reset(future)
	return future
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.Reset(future)
	local context = private.context[future]
	context.state = "RESET"
	context.value = nil
	context.onDone = nil
	if context.onCleanup then
		context.onCleanup()
	end
end
