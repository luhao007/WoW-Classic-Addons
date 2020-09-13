-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Event Functions
-- @module Event

local _, TSM = ...
local Event = TSM.Init("Util.Event")
local TempTable = TSM.Include("Util.TempTable")
local Log = TSM.Include("Util.Log")
local private = {
	registry = {
		event = {},
		callback = {},
	},
	eventFrame = nil,
	temp = {},
	eventQueue = {},
	processingEvent = false,
}
local CALLBACK_TIME_WARNING_THRESHOLD_MS = 20



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Registers an event callback.
-- @tparam string event The WoW event to register for (i.e. BAG_UPDATE)
-- @tparam function callback The function to be called from the event handler
function Event.Register(event, callback)
	assert(type(event) == "string" and event == strupper(event) and type(callback) == "function")
	-- make sure this event/callback isn't already registered
	for i = 1, #private.registry.event do
		assert(private.registry.event[i] ~= event or private.registry.callback[i] ~= callback)
	end
	private.eventFrame:RegisterEvent(event)
	tinsert(private.registry.event, event)
	tinsert(private.registry.callback, callback)
end

--- Unregisters an event callback.
-- @tparam string event The WoW event which the callback was registered for
-- @tparam function callback The function which was passed to @{Event.Register} for this event
function Event.Unregister(event, callback)
	assert(type(event) == "string" and event == strupper(event) and type(callback) == "function")
	local index = nil
	local shouldUnregister = true
	for i = 1, #private.registry.event do
		if private.registry.event[i] == event and private.registry.callback[i] == callback then
			assert(not index)
			index = i
		elseif private.registry.event[i] == event then
			shouldUnregister = false
		end
	end
	assert(index)
	tremove(private.registry.event, index)
	tremove(private.registry.callback, index)
	if shouldUnregister then
		private.eventFrame:UnregisterEvent(event)
	end
end



-- ============================================================================
-- Event Frame
-- ============================================================================

function private.ProcessEvent(event, ...)
	-- NOTE: the registered events may change within the callback, so copy them to a temp table
	wipe(private.temp)
	for i = 1, #private.registry.event do
		if private.registry.event[i] == event then
			tinsert(private.temp, private.registry.callback[i])
		end
	end
	for _, callback in ipairs(private.temp) do
		local startTime = debugprofilestop()
		callback(event, ...)
		local timeTaken = debugprofilestop() - startTime
		if timeTaken > CALLBACK_TIME_WARNING_THRESHOLD_MS then
			Log.Warn("Event (%s) callback took %.2fms", event, timeTaken)
		end
	end
end

function private.EventHandler(_, event, ...)
	if private.processingEvent then
		-- we are already in the middle of processing another event, so queue this one up
		tinsert(private.eventQueue, TempTable.Acquire(event, ...))
		assert(#private.eventQueue < 50)
		return
	end
	private.processingEvent = true
	private.ProcessEvent(event, ...)
	-- process queued events
	while #private.eventQueue > 0 do
		local tbl = tremove(private.eventQueue, 1)
		private.ProcessEvent(TempTable.UnpackAndRelease(tbl))
	end
	private.processingEvent = false
end

private.eventFrame = CreateFrame("Frame")
private.eventFrame:SetScript("OnEvent", private.EventHandler)
private.eventFrame:Show()
