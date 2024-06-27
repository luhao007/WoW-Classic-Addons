-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Publisher = TSM.Init("Util.ReactiveClasses.Publisher") ---@class Util.ReactiveClasses.Publisher
local Environment = TSM.Include("Environment")
local Math = TSM.Include("Util.Math")
local String = TSM.Include("Util.String")
local ObjectPool = TSM.Include("Util.ObjectPool")
local EnumType = TSM.Include("Util.EnumType")
local ReactivePublisher = TSM.Include("LibTSMClass").DefineClass("ReactivePublisher") ---@class ReactivePublisher
local private = {
	publisherObjectPool = ObjectPool.New("PUBLISHER", ReactivePublisher, 1),
	keysTempTable = {},
}
local STATE = EnumType.New("PUBLISHER_STATE", {
	INIT = EnumType.CreateValue(),
	ACQUIRED = EnumType.CreateValue(),
	STEPS = EnumType.CreateValue(),
	HANDLED = EnumType.CreateValue(),
	STORED = EnumType.CreateValue(),
})
local STEP = EnumType.New("PUBLISHER_STEP", {
	MAP_WITH_FUNCTION = EnumType.CreateValue(),
	MAP_WITH_METHOD = EnumType.CreateValue(),
	MAP_WITH_KEY = EnumType.CreateValue(),
	MAP_WITH_KEY_COALESCED = EnumType.CreateValue(),
	MAP_BOOLEAN_WITH_VALUES = EnumType.CreateValue(),
	MAP_BOOLEAN_EQUALS = EnumType.CreateValue(),
	MAP_BOOLEAN_NOT_EQUALS = EnumType.CreateValue(),
	MAP_BOOLEAN_GREATER_THAN_OR_EQUALS = EnumType.CreateValue(),
	MAP_TO_BOOLEAN = EnumType.CreateValue(),
	MAP_TO_VALUE = EnumType.CreateValue(),
	INVERT_BOOLEAN = EnumType.CreateValue(),
	IGNORE_IF_KEY_EQUALS = EnumType.CreateValue(),
	IGNORE_IF_KEY_NOT_EQUALS = EnumType.CreateValue(),
	IGNORE_IF_NOT_KEY_IN_TABLE = EnumType.CreateValue(),
	IGNORE_IF_NOT_EQUALS = EnumType.CreateValue(),
	IGNORE_NIL = EnumType.CreateValue(),
	IGNORE_WITH_FUNCTION = EnumType.CreateValue(),
	IGNORE_DUPLICATES = EnumType.CreateValue(),
	IGNORE_DUPLICATES_WITH_KEYS = EnumType.CreateValue(),
	IGNORE_DUPLICATES_WITH_METHOD = EnumType.CreateValue(),
	PRINT = EnumType.CreateValue(),
	START_PROFILING = EnumType.CreateValue(),
	SHARE = EnumType.CreateValue(),
	CALL_METHOD = EnumType.CreateValue(),
	CALL_METHOD_IF_NOT_NIL = EnumType.CreateValue(),
	CALL_METHOD_FOR_EACH_LIST_VALUE = EnumType.CreateValue(),
	CALL_FUNCTION = EnumType.CreateValue(),
	UNPACK_AND_CALL_FUNCTION = EnumType.CreateValue(),
	UNPACK_AND_CALL_METHOD = EnumType.CreateValue(),
	ASSIGN_TO_TABLE_KEY = EnumType.CreateValue(),
})
local STEP_RESULTING_STATE = {
	[STEP.MAP_WITH_FUNCTION] = STATE.STEPS,
	[STEP.MAP_WITH_METHOD] = STATE.STEPS,
	[STEP.MAP_WITH_KEY] = STATE.STEPS,
	[STEP.MAP_WITH_KEY_COALESCED] = STATE.STEPS,
	[STEP.MAP_BOOLEAN_WITH_VALUES] = STATE.STEPS,
	[STEP.MAP_BOOLEAN_EQUALS] = STATE.STEPS,
	[STEP.MAP_BOOLEAN_NOT_EQUALS] = STATE.STEPS,
	[STEP.MAP_BOOLEAN_GREATER_THAN_OR_EQUALS] = STATE.STEPS,
	[STEP.MAP_TO_BOOLEAN] = STATE.STEPS,
	[STEP.MAP_TO_VALUE] = STATE.STEPS,
	[STEP.INVERT_BOOLEAN] = STATE.STEPS,
	[STEP.IGNORE_IF_KEY_EQUALS] = STATE.STEPS,
	[STEP.IGNORE_IF_KEY_NOT_EQUALS] = STATE.STEPS,
	[STEP.IGNORE_IF_NOT_KEY_IN_TABLE] = STATE.STEPS,
	[STEP.IGNORE_IF_NOT_EQUALS] = STATE.STEPS,
	[STEP.IGNORE_NIL] = STATE.STEPS,
	[STEP.IGNORE_WITH_FUNCTION] = STATE.STEPS,
	[STEP.IGNORE_DUPLICATES] = STATE.STEPS,
	[STEP.IGNORE_DUPLICATES_WITH_KEYS] = STATE.STEPS,
	[STEP.IGNORE_DUPLICATES_WITH_METHOD] = STATE.STEPS,
	[STEP.PRINT] = STATE.STEPS,
	[STEP.START_PROFILING] = STATE.STEPS,
	[STEP.SHARE] = STATE.STEPS,
	[STEP.CALL_METHOD] = STATE.HANDLED,
	[STEP.CALL_METHOD_IF_NOT_NIL] = STATE.HANDLED,
	[STEP.CALL_METHOD_FOR_EACH_LIST_VALUE] = STATE.HANDLED,
	[STEP.CALL_FUNCTION] = STATE.HANDLED,
	[STEP.UNPACK_AND_CALL_FUNCTION] = STATE.HANDLED,
	[STEP.UNPACK_AND_CALL_METHOD] = STATE.HANDLED,
	[STEP.ASSIGN_TO_TABLE_KEY] = STATE.HANDLED,
}
local OPTIMIZATION_IGNORED_STEPS = {
	[STEP.IGNORE_NIL] = true,
	[STEP.PRINT] = true,
	[STEP.START_PROFILING] = true,
	[STEP.MAP_TO_BOOLEAN] = true,
	[STEP.INVERT_BOOLEAN] = true,
	[STEP.SHARE] = true,
	[STEP.CALL_METHOD] = true,
	[STEP.CALL_METHOD_IF_NOT_NIL] = true,
	[STEP.CALL_METHOD_FOR_EACH_LIST_VALUE] = true,
	[STEP.CALL_FUNCTION] = true,
	[STEP.UNPACK_AND_CALL_FUNCTION] = true,
	[STEP.UNPACK_AND_CALL_METHOD] = true,
	[STEP.ASSIGN_TO_TABLE_KEY] = true,
}
local KEYS_SEP = "\001"
local STEP_DATA_SIZE = 3



-- ============================================================================
-- Module Functions
-- ============================================================================

---Gets a publisher object.
---@return ReactivePublisher
function Publisher.Get()
	return private.publisherObjectPool:Get()
end

---Releases a publisher object.
---@param publisher ReactivePublisher The publisher object
function Publisher.Release(publisher)
	publisher:_Release()
	private.publisherObjectPool:Recycle(publisher)
end



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function ReactivePublisher:__init()
	self._subject = nil
	self._state = STATE.INIT
	self._shareStep = nil
	self._stepData = {}
	self._numSteps = 0
	self._optimizeKeys = {}
end

function ReactivePublisher:_Acquire(subject)
	self._subject = subject
	self._state = STATE.ACQUIRED
end

function ReactivePublisher:_Release()
	assert(self._state == STATE.STORED)
	self._state = STATE.INIT
	self._subject = nil
	self._numSteps = 0
	self._shareStep = nil
	wipe(self._stepData)
	wipe(self._optimizeKeys)
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

---Map published values to another value using a function.
---@param func fun(value: any, arg: any): any The mapping function which takes the published values and returns the results
---@param arg any An additional argument to pass to the function
---@return ReactivePublisher
function ReactivePublisher:MapWithFunction(func, arg)
	assert(type(func) == "function")
	return self:_AddStepHelper(STEP.MAP_WITH_FUNCTION, func, arg)
end

---Maps published values by calling a method on it.
---@param method string The name of the method to call on the published values
---@return ReactivePublisher
function ReactivePublisher:MapWithMethod(method)
	assert(type(method) == "string")
	return self:_AddStepHelper(STEP.MAP_WITH_METHOD, method)
end

---Maps published values by indexing it with the specified key.
---@param key string|number key The key to index the published values with
---@return ReactivePublisher
function ReactivePublisher:MapWithKey(key)
	assert(type(key) == "string" or type(key) == "number")
	return self:_AddStepHelper(STEP.MAP_WITH_KEY, key)
end

---Map published values by indexing it with two keys, keeping the first value one which is non-nil.
---@param key1 string The first key to index the published values with
---@param key2 string The second key to index the published values with
---@return ReactivePublisher
function ReactivePublisher:MapWithKeyCoalesced(key1, key2)
	return self:_AddStepHelper(STEP.MAP_WITH_KEY_COALESCED, key1, key2)
end

---Map published boolean values to the specified true / false values.
---@param trueValue any The value to map to if true
---@param falseValue any The value to map to if false
---@return ReactivePublisher
function ReactivePublisher:MapBooleanWithValues(trueValue, falseValue)
	return self:_AddStepHelper(STEP.MAP_BOOLEAN_WITH_VALUES, trueValue, falseValue)
end

---Map published values to a boolean based on whether or not it equals the specified value.
---@param value any The value to compare with
---@return ReactivePublisher
function ReactivePublisher:MapBooleanEquals(value)
	return self:_AddStepHelper(STEP.MAP_BOOLEAN_EQUALS, value)
end

---Map published values to a boolean based on whether or not it equals the specified value.
---@param value any The value to compare with
---@return ReactivePublisher
function ReactivePublisher:MapBooleanNotEquals(value)
	return self:_AddStepHelper(STEP.MAP_BOOLEAN_NOT_EQUALS, value)
end

---Map published values to a boolean based on whether or not it is greater than or equal to the specified value.
---@param value any The value to compare with
---@return ReactivePublisher
function ReactivePublisher:MapBooleanGreaterThanOrEquals(value)
	return self:_AddStepHelper(STEP.MAP_BOOLEAN_GREATER_THAN_OR_EQUALS, value)
end

---Map published values to a boolean based on whether or not it's truthy.
---@return ReactivePublisher
function ReactivePublisher:MapToBoolean()
	return self:_AddStepHelper(STEP.MAP_TO_BOOLEAN)
end

---Map published values to a specific value.
---@param value any The value to map to
---@return ReactivePublisher
function ReactivePublisher:MapToValue(value)
	return self:_AddStepHelper(STEP.MAP_TO_VALUE, value)
end

---Invert published boolean values.
---@return ReactivePublisher
function ReactivePublisher:InvertBoolean()
	return self:_AddStepHelper(STEP.INVERT_BOOLEAN)
end

---Ignores published values where a specified key equals the specified value.
---@param key string The key to compare at
---@param value any The value to compare with
---@return ReactivePublisher
function ReactivePublisher:IgnoreIfKeyEquals(key, value)
	assert(type(key) == "string" or type(key) == "number")
	return self:_AddStepHelper(STEP.IGNORE_IF_KEY_EQUALS, key, value)
end

---Ignores published values where a specified key does not equal the specified value.
---@param key string The key to compare at
---@param value any The value to compare with
---@return ReactivePublisher
function ReactivePublisher:IgnoreIfKeyNotEquals(key, value)
	assert(type(key) == "string" or type(key) == "number")
	return self:_AddStepHelper(STEP.IGNORE_IF_KEY_NOT_EQUALS, key, value)
end

---Ignores published values which don't exist as a key within the specified table.
---@param tbl table The table to check within
---@return ReactivePublisher
function ReactivePublisher:IgnoreIfNotKeyInTable(tbl)
	assert(type(tbl) == "table")
	return self:_AddStepHelper(STEP.IGNORE_IF_NOT_KEY_IN_TABLE, tbl)
end

---Ignores published values which don't equal the specified value.
---@param value any The value to compare against
---@return ReactivePublisher
function ReactivePublisher:IgnoreIfNotEquals(value)
	return self:_AddStepHelper(STEP.IGNORE_IF_NOT_EQUALS, value)
end

---Ignores published values if it's nil.
---@return ReactivePublisher
function ReactivePublisher:IgnoreNil()
	return self:_AddStepHelper(STEP.IGNORE_NIL)
end

---Ignores published values if the specified function doesn't return true.
---@param func fun(value: any): boolean The function which takes the published values and returns true/false
---@return ReactivePublisher
function ReactivePublisher:IgnoreWithFunction(func)
	assert(type(func) == "function")
	return self:_AddStepHelper(STEP.IGNORE_WITH_FUNCTION, func)
end

---Ignores duplicate published values.
---@return ReactivePublisher
function ReactivePublisher:IgnoreDuplicates()
	return self:_AddStepHelper(STEP.IGNORE_DUPLICATES)
end

---Ignores duplicate published values by checking the specified keys.
---@param ... string Keys to compare to detect duplicate published values
---@return ReactivePublisher
function ReactivePublisher:IgnoreDuplicatesWithKeys(...)
	local keys = private.ToKeysStr(...)
	assert(keys ~= "")
	return self:_AddStepHelper(STEP.IGNORE_DUPLICATES_WITH_KEYS, keys)
end

---Ignores duplicate published values by calling the specified method.
---@param method string The method to call on the published values
---@return ReactivePublisher
function ReactivePublisher:IgnoreDuplicatesWithMethod(method)
	assert(type(method) == "string")
	return self:_AddStepHelper(STEP.IGNORE_DUPLICATES_WITH_METHOD, method)
end

---Prints published values and passes them through for debugging purposes.
---@param tag? string An optional tag to add to the prints
---@return ReactivePublisher
function ReactivePublisher:Print(tag)
	assert(Environment.IsDev())
	return self:_AddStepHelper(STEP.PRINT, tag)
end

---Wraps all following steps in profiling nodes.
---@param prefix string A prefix to use for the profiling nodes
---@return ReactivePublisher
function ReactivePublisher:StartProfiling(prefix)
	assert(Environment.IsDev())
	return self:_AddStepHelper(STEP.START_PROFILING, prefix)
end

---Shares the result of the publisher at the current point in the chain.
---@param numPublishers number The number of child publisher chains to share with
---@return ReactivePublisher
function ReactivePublisher:Share(numPublishers)
	assert(not self._shareStep and numPublishers > 1)
	self:_AddStepHelper(STEP.SHARE, numPublishers)
	self._shareStep = self._numSteps
	return self
end

---Calls a method with the published values.
---@param obj table The object to call the method on
---@param method string The name of the method to call with the published values
---@return ReactivePublisher
function ReactivePublisher:CallMethod(obj, method)
	assert(type(obj) == "table" and type(method) == "string")
	return self:_AddStepHelper(STEP.CALL_METHOD, obj, method)
end

---Calls a method with the published values if it's non-nil.
---@param obj table The object to call the method on
---@param method string The name of the method to call with the published values
---@return ReactivePublisher
function ReactivePublisher:CallMethodIfNotNil(obj, method)
	assert(type(obj) == "table" and type(method) == "string")
	return self:_AddStepHelper(STEP.CALL_METHOD_IF_NOT_NIL, obj, method)
end

---Calls a method with the published values on each value in a list.
---@param list table The list of objects to call the method on
---@param method string The name of the method to call with the published values
---@return ReactivePublisher
function ReactivePublisher:CallMethodForEachListValue(list, method)
	assert(type(list) == "table" and type(method) == "string")
	return self:_AddStepHelper(STEP.CALL_METHOD_FOR_EACH_LIST_VALUE, list, method)
end

---Calls a function with the published values.
---@param func fun(value: any) The function to call with the published values
---@return ReactivePublisher
function ReactivePublisher:CallFunction(func)
	assert(type(func) == "function")
	return self:_AddStepHelper(STEP.CALL_FUNCTION, func)
end

---Unpacks published values and then calls a function with the result.
---@param func fun(value: any) The function to call with the unpacked published values
---@return ReactivePublisher
function ReactivePublisher:UnpackAndCallFunction(func)
	assert(type(func) == "function")
	return self:_AddStepHelper(STEP.UNPACK_AND_CALL_FUNCTION, func)
end

---Unpacks published values and then calls a method with the result.
---@param obj table The object to call the method on
---@param method string The name of the method to call with the unpacked published values
---@return ReactivePublisher
function ReactivePublisher:UnpackAndCallMethod(obj, method)
	assert(type(obj) == "table" and type(method) == "string")
	return self:_AddStepHelper(STEP.UNPACK_AND_CALL_METHOD, obj, method)
end

---Assigns published values to the specified key in the table.
---@param tbl table The table to assign the published values into
---@param key string The key to assign the published values at
---@return ReactivePublisher
function ReactivePublisher:AssignToTableKey(tbl, key)
	assert(type(tbl) == "table" and type(key) == "string")
	return self:_AddStepHelper(STEP.ASSIGN_TO_TABLE_KEY, tbl, key)
end

---Stores the publisher in a table for later cancelling.
---@param tbl table The table to assign the published values into
---@param key string The key to assign the published values at
function ReactivePublisher:StoreIn(tbl)
	assert(type(tbl) == "table")
	tinsert(tbl, self)
	self:_Commit()
end

---Marks a publisher as stored manually by the caller.
---@return ReactivePublisher
function ReactivePublisher:Stored()
	self:_Commit()
	return self
end

---Cancels and releases a publisher.
function ReactivePublisher:Cancel()
	assert(self._state == STATE.STORED)
	self._subject:_HandlePublisherEvent(self, "OnCancel")
	self:_Release()
	private.publisherObjectPool:Recycle(self)
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ReactivePublisher:_AddStepHelper(stepType, arg1, arg2)
	local newState = STEP_RESULTING_STATE[stepType]
	assert(newState == STATE.STEPS or newState == STATE.HANDLED)
	assert(self._state == STATE.ACQUIRED or self._state == STATE.STEPS)
	if newState == STATE.HANDLED and self._shareStep then
		-- The first arg of the share step contains the number of publishers we're sharing with
		local numPublishersIndex = (self._shareStep - 1) * STEP_DATA_SIZE + 2
		self._stepData[numPublishersIndex] = self._stepData[numPublishersIndex] - 1
		assert(self._stepData[numPublishersIndex] >= 0)
		if self._stepData[numPublishersIndex] > 0 then
			-- There are still more handlers to be added
			newState = STATE.STEPS
		end
	end
	self._state = newState
	assert(STEP_DATA_SIZE == 3)
	self._stepData[self._numSteps * STEP_DATA_SIZE + 1] = stepType
	self._stepData[self._numSteps * STEP_DATA_SIZE + 2] = arg1
	self._stepData[self._numSteps * STEP_DATA_SIZE + 3] = arg2
	self._numSteps = self._numSteps + 1
	if self._state == STATE.HANDLED then
		self._subject:_HandlePublisherEvent(self, "OnHandled")
	end
	return self
end

function ReactivePublisher:_Commit()
	assert(self._state == STATE.HANDLED)
	self._state = STATE.STORED

	-- Perform optimizations
	assert(not next(self._optimizeKeys))
	local didOptimize = false

	for step = 1, self._numSteps do
		local stepType, arg1, arg2 = unpack(self._stepData, (step - 1) * STEP_DATA_SIZE + 1, step * STEP_DATA_SIZE)
		if stepType == STEP.MAP_WITH_KEY or stepType == STEP.IGNORE_IF_KEY_EQUALS or stepType == STEP.IGNORE_IF_KEY_NOT_EQUALS then
			self._optimizeKeys[arg1] = true
		elseif stepType == STEP.MAP_WITH_KEY_COALESCED then
			self._optimizeKeys[arg1] = true
			self._optimizeKeys[arg2] = true
		elseif stepType == STEP.IGNORE_DUPLICATES or stepType == STEP.MAP_TO_VALUE or stepType == STEP.IGNORE_DUPLICATES_WITH_METHOD then
			didOptimize = true
			break
		elseif stepType == STEP.IGNORE_DUPLICATES_WITH_KEYS then
			for key in String.SplitIterator(arg1, KEYS_SEP) do
				self._optimizeKeys[key] = true
			end
			didOptimize = true
			break
		elseif OPTIMIZATION_IGNORED_STEPS[stepType] then
			-- Ignore these steps for optimizations
		elseif stepType == STEP.MAP_WITH_FUNCTION or stepType == STEP.MAP_WITH_METHOD or stepType == STEP.MAP_BOOLEAN_WITH_VALUES or stepType == STEP.MAP_BOOLEAN_EQUALS or stepType == STEP.MAP_BOOLEAN_NOT_EQUALS or stepType == STEP.MAP_BOOLEAN_GREATER_THAN_OR_EQUALS or stepType == STEP.IGNORE_IF_NOT_KEY_IN_TABLE or stepType == STEP.IGNORE_IF_NOT_EQUALS or stepType == STEP.IGNORE_WITH_FUNCTION then
			-- Not able to optimize
			didOptimize = false
			break
		else
			error("Invalid stepType: "..tostring(stepType))
		end
	end
	if not didOptimize then
		wipe(self._optimizeKeys)
	end

	self._subject:_HandlePublisherEvent(self, "OnCommit", didOptimize)
end

function ReactivePublisher:_HandleData(data, optimizeKey)
	if self._state ~= STATE.STORED then
		error("Invalid publisher state")
	end
	if optimizeKey and next(self._optimizeKeys) and not self._optimizeKeys[optimizeKey] then
		return
	end
	local profilingPrefix = nil
	local step = 0
	while true do
		step = step + 1
		if step > self._numSteps then
			error("Publisher did not terminate")
		end
		local stepType, arg1, arg2 = unpack(self._stepData, (step - 1) * STEP_DATA_SIZE + 1, step * STEP_DATA_SIZE)
		local arg2Index = step * STEP_DATA_SIZE
		local stepProfilingNode = profilingPrefix and profilingPrefix.."_"..stepType or nil
		if stepProfilingNode then
			TSMDEV.Profiling.StartNode(stepProfilingNode)
		end
		local ignoreValue = false
		if stepType == STEP.MAP_WITH_FUNCTION then
			data = arg1(data, arg2)
		elseif stepType == STEP.MAP_WITH_METHOD then
			data = data[arg1](data)
		elseif stepType == STEP.MAP_WITH_KEY then
			data = data[arg1]
		elseif stepType == STEP.MAP_WITH_KEY_COALESCED then
			local newData = data[arg1]
			if newData == nil then
				newData = data[arg2]
			end
			data = newData
		elseif stepType == STEP.MAP_BOOLEAN_WITH_VALUES then
			if data then
				data = arg1
			else
				data = arg2
			end
		elseif stepType == STEP.MAP_BOOLEAN_EQUALS then
			data = data == arg1
		elseif stepType == STEP.MAP_BOOLEAN_NOT_EQUALS then
			data = data ~= arg1
		elseif stepType == STEP.MAP_BOOLEAN_GREATER_THAN_OR_EQUALS then
			data = data >= arg1
		elseif stepType == STEP.MAP_TO_BOOLEAN then
			data = data and true or false
		elseif stepType == STEP.MAP_TO_VALUE then
			data = arg1
		elseif stepType == STEP.INVERT_BOOLEAN then
			if type(data) ~= "boolean" then
				error("Invalid data type: "..tostring(data))
			end
			data = not data
		elseif stepType == STEP.IGNORE_IF_KEY_EQUALS then
			if data[arg1] == arg2 then
				ignoreValue = true
			end
		elseif stepType == STEP.IGNORE_IF_KEY_NOT_EQUALS then
			if data[arg1] ~= arg2 then
				ignoreValue = true
			end
		elseif stepType == STEP.IGNORE_IF_NOT_KEY_IN_TABLE then
			if arg1[data] == nil then
				ignoreValue = true
			end
		elseif stepType == STEP.IGNORE_IF_NOT_EQUALS then
			if data ~= arg1 then
				ignoreValue = true
			end
		elseif stepType == STEP.IGNORE_NIL then
			if data == nil then
				ignoreValue = true
			end
		elseif stepType == STEP.IGNORE_WITH_FUNCTION then
			local result = arg1(data)
			if result == false then
				ignoreValue = true
			elseif result ~= true then
				error("Invalid IgnoreWithFunction result: "..tostring(result))
			end
		elseif stepType == STEP.IGNORE_DUPLICATES then
			local value = data
			if type(value) == "table" then
				value = tostring(value)
			end
			local hash = Math.CalculateHash(value)
			-- We use stepArg2 to store the previous hash
			if hash == arg2 then
				ignoreValue = true
			else
				self._stepData[arg2Index] = hash
			end
		elseif stepType == STEP.IGNORE_DUPLICATES_WITH_KEYS then
			local hash = nil
			for key in String.SplitIterator(arg1, KEYS_SEP) do
				local value = data[key]
				if type(value) == "table" then
					value = tostring(value)
				end
				hash = Math.CalculateHash(value, hash)
			end
			-- We use stepArg2 to store the previous hash
			if hash == arg2 then
				ignoreValue = true
			else
				self._stepData[arg2Index] = hash
			end
		elseif stepType == STEP.IGNORE_DUPLICATES_WITH_METHOD then
			local hash = data[arg1](data)
			-- We use stepArg2 to store the previous hash
			if hash == arg2 then
				ignoreValue = true
			else
				self._stepData[arg2Index] = hash
			end
		elseif stepType == STEP.PRINT then
			if arg1 then
				print(format("Published value (%s):", tostring(arg1)))
			else
				print("Published value:")
			end
			TSMDEV.Dump(data)
		elseif stepType == STEP.START_PROFILING then
			assert(not profilingPrefix)
			profilingPrefix = arg1
			TSMDEV.Profiling.StartNode(profilingPrefix)
		elseif stepType == STEP.SHARE then
			if step ~= self._shareStep then
				error("Invalid share step")
			end
			-- Store the shared value in stepArg2
			self._stepData[arg2Index] = data
		elseif stepType == STEP.CALL_METHOD then
			arg1[arg2](arg1, data)
		elseif stepType == STEP.CALL_METHOD_IF_NOT_NIL then
			local func = arg1[arg2]
			if func ~= nil then
				func(arg1, data)
			end
		elseif stepType == STEP.CALL_METHOD_FOR_EACH_LIST_VALUE then
			for j = 1, #arg1 do
				local obj = arg1[j]
				obj[arg2](obj, data)
			end
		elseif stepType == STEP.CALL_FUNCTION then
			arg1(data)
		elseif stepType == STEP.UNPACK_AND_CALL_FUNCTION then
			arg1(unpack(data))
		elseif stepType == STEP.UNPACK_AND_CALL_METHOD then
			arg1[arg2](arg1, unpack(data))
		elseif stepType == STEP.ASSIGN_TO_TABLE_KEY then
			arg1[arg2] = data
		else
			error("Invalid stepType: "..tostring(stepType))
		end
		if stepProfilingNode then
			TSMDEV.Profiling.EndNode(stepProfilingNode)
		end
		if ignoreValue then
			if self._shareStep and step < self._shareStep then
				-- Ignoring before the share step, so we're done
				break
			elseif self._shareStep then
				-- Advance past the current handler to the next child publisher chain with the shared value
				while true do
					local newStepType = self._stepData[step * STEP_DATA_SIZE + 1]
					step = step + 1
					if not newStepType then
						error("Could not find handling step")
					elseif STEP_RESULTING_STATE[newStepType] == STATE.HANDLED then
						step = step + 1
						break
					end
				end
				if step > self._numSteps then
					-- No more child publisher chains, so we're done
					break
				end
				data = self._stepData[self._shareStep * STEP_DATA_SIZE]
			else
				break
			end
		elseif STEP_RESULTING_STATE[stepType] == STATE.HANDLED then
			if step == self._numSteps then
				-- We're done
				break
			elseif self._shareStep then
				-- Replace the current data with the shared value and continue
				data = self._stepData[self._shareStep * STEP_DATA_SIZE]
			else
				error("Extra steps")
			end
		end
	end
	if profilingPrefix then
		TSMDEV.Profiling.EndNode(profilingPrefix)
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ToKeysStr(...)
	assert(not next(private.keysTempTable))
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		assert(type(key) == "string" and key ~= "" and not strfind(key, KEYS_SEP))
		private.keysTempTable[i] = key
	end
	local result = table.concat(private.keysTempTable, KEYS_SEP)
	wipe(private.keysTempTable)
	return result
end
