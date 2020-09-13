-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- FSMState Class.
-- This class represents a single state within an @{FSMMachine}.
-- @classmod FSMState

local _, TSM = ...
local State = TSM.Init("Util.FSMClasses.State")
local LibTSMClass = TSM.Include("LibTSMClass")
local TempTable = TSM.Include("Util.TempTable")
local FSMState = LibTSMClass.DefineClass("FSMState")
local private = {
	eventTransitionHandlerCache = {},
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function State.Create(name)
	return FSMState(name)
end

function State.IsInstance(obj)
	return obj:__isa(FSMState)
end



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function FSMState.__init(self, name)
	self._name = name
	self._onEnterHandler = nil
	self._onExitHandler = nil
	self._transitionValid = {}
	self._events = {}
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Set the OnEnter handler.
-- This function is called upon entering the state.
-- @tparam FSMState self The FSM state object
-- @tparam ?function|string handler The handler function or a method name to call on the context object
-- @treturn FSMState The FSM state object
function FSMState.SetOnEnter(self, handler)
	assert(type(handler) == "function" or type(handler) == "string")
	self._onEnterHandler = handler
	return self
end

--- Set the OnExit handler.
-- This function is called upon existing the state.
-- @tparam FSMState self The FSM state object
-- @tparam ?function|string handler The handler function or a method name to call on the context object
-- @treturn FSMState The FSM state object
function FSMState.SetOnExit(self, handler)
	assert(type(handler) == "function" or type(handler) == "string")
	self._onExitHandler = handler
	return self
end

--- Add a transition.
-- @tparam FSMState self The FSM state object
-- @tparam string toState The state this transition goes to
-- @treturn FSMState The FSM state object
function FSMState.AddTransition(self, toState)
	assert(not self._transitionValid[toState], "transition already exists")
	self._transitionValid[toState] = true
	return self
end

--- Add a handled event.
-- @tparam FSMState self The FSM state object
-- @tparam string event The name of the event
-- @tparam function handler The function called when the event occurs
-- @treturn FSMState The FSM state object
function FSMState.AddEvent(self, event, handler)
	assert(not self._events[event], "event already exists")
	self._events[event] = handler
	return self
end

--- Add a simple event-based transition.
-- @tparam FSMState self The FSM state object
-- @tparam string event The event name
-- @tparam string toState The state to transition to
-- @treturn FSMState The FSM state object
function FSMState.AddEventTransition(self, event, toState)
	if not private.eventTransitionHandlerCache[toState] then
		private.eventTransitionHandlerCache[toState] = function(context, ...)
			return toState, ...
		end
	end
	return self:AddEvent(event, private.eventTransitionHandlerCache[toState])
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function FSMState._GetName(self)
	return self._name
end

function FSMState._ToStateIterator(self)
	local temp = TempTable.Acquire()
	for toState in pairs(self._transitionValid) do
		tinsert(temp, toState)
	end
	return TempTable.Iterator(temp)
end

function FSMState._IsTransitionValid(self, toState)
	return self._transitionValid[toState]
end

function FSMState._HasEventHandler(self, event)
	return self._events[event] and true or false
end

function FSMState._ProcessEvent(self, event, context, ...)
	return self:_HandlerHelper(self._events[event], context, ...)
end

function FSMState._Enter(self, context, ...)
	return self:_HandlerHelper(self._onEnterHandler, context, ...)
end

function FSMState._Exit(self, context)
	return self:_HandlerHelper(self._onExitHandler, context)
end

function FSMState._HandlerHelper(self, handler, context, ...)
	if type(handler) == "function" then
		return handler(context, ...)
	elseif type(handler) == "string" then
		return context[handler](context, ...)
	elseif handler ~= nil then
		error("Invalid handler: "..tostring(handler))
	end
end
