-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Log = TSM.Init("Util.Log")
local Debug = TSM.Include("Util.Debug")
local Theme = TSM.Include("Util.Theme")
local private = {
	severity = {},
	location = {},
	timeStr = {},
	msg = {},
	writeIndex = 1,
	len = 0,
	temp = {},
	logToChat = TSM.__IS_TEST_ENV or false,
	currentThreadNameFunc = nil,
	stackLevel = 3,
	chatFrame = nil,
}
local MAX_ROWS = 200
local MAX_MSG_LEN = 200
local CHAT_LOG_COLOR_KEYS = {
	TRACE = "BLUE",
	INFO = "GREEN",
	WARN = "YELLOW",
	ERR = "RED",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Log.SetChatFrame(chatFrame)
	private.chatFrame = strlower(chatFrame)
end

function Log.SetLoggingToChatEnabled(enabled)
	if TSM.__IS_TEST_ENV then
		enabled = true
	end
	if private.logToChat == enabled then
		return
	end
	private.logToChat = enabled
	if enabled then
		-- dump our buffer
		local len = Log.Length()
		print(format("Printing %d buffered logs:", len))
		for i = 1, len do
			private.LogToChat(Log.Get(i))
		end
	end
end

function Log.SetCurrentThreadNameFunction(func)
	private.currentThreadNameFunc = func
end

function Log.Length()
	return private.len
end

function Log.Get(index)
	assert(index <= private.len)
	local readIndex = (private.writeIndex - private.len + index - 2) % MAX_ROWS + 1
	return private.severity[readIndex], private.location[readIndex], private.timeStr[readIndex], private.msg[readIndex]
end

function Log.RaiseStackLevel()
	private.stackLevel = private.stackLevel + 1
end

function Log.LowerStackLevel()
	private.stackLevel = private.stackLevel - 1
end

function Log.StackTrace()
	Log.RaiseStackLevel()
	Log.Trace("Stack Trace:")
	local level = 2
	local line = Debug.GetStackLevelLocation(level)
	while line do
		Log.Trace("  " .. line)
		level = level + 1
		line = Debug.GetStackLevelLocation(level)
	end
	Log.LowerStackLevel()
end

function Log.Trace(...)
	private.Log("TRACE", ...)
end

function Log.Info(...)
	private.Log("INFO", ...)
end

function Log.Warn(...)
	private.Log("WARN", ...)
end

function Log.Err(...)
	private.Log("ERR", ...)
end

function Log.PrintUserRaw(str)
	private.GetChatFrame():AddMessage(str)
end

function Log.PrintfUserRaw(...)
	Log.PrintUserRaw(format(...))
end

function Log.PrintUser(str)
	Log.PrintUserRaw(Theme.GetColor("INDICATOR"):ColorText("TSM")..": "..str)
end

function Log.PrintfUser(...)
	Log.PrintUser(format(...))
end

function Log.ColorUserAccentText(text)
	return Theme.GetColor("INDICATOR_ALT"):ColorText(text)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetChatFrame()
	for i = 1, NUM_CHAT_WINDOWS do
		local name = strlower(GetChatWindowInfo(i) or "")
		if name ~= "" and name == private.chatFrame then
			return _G["ChatFrame" .. i]
		end
	end
	return DEFAULT_CHAT_FRAME
end

function private.Log(severity, fmtStr, ...)
	assert(type(fmtStr) == "string" and CHAT_LOG_COLOR_KEYS[severity])
	wipe(private.temp)
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		if type(arg) == "boolean" then
			arg = arg and "T" or "F"
		elseif type(arg) ~= "string" and type(arg) ~= "number" then
			arg = tostring(arg)
		end
		private.temp[i] = arg
	end
	-- ignore anything after a newline in the log message
	local msg = strsplit("\n", format(fmtStr, unpack(private.temp)))
	if #msg > MAX_MSG_LEN then
		msg = strsub(msg, 1, -4).."..."
	end
	local location = Debug.GetStackLevelLocation(private.stackLevel)
	location = location and strmatch(location, "([^\\/]+%.lua:[0-9]+)") or "?:?"
	local threadName = private.currentThreadNameFunc and private.currentThreadNameFunc() or nil
	if threadName then
		location = location.."|"..threadName
	end
	local timeMs = Debug.GetTimeMilliseconds()
	local timeStr = format("%s.%03d", date("%H:%M:%S", floor(timeMs / 1000)), timeMs % 1000)

	-- append the log
	private.severity[private.writeIndex] = severity
	private.location[private.writeIndex] = location
	private.timeStr[private.writeIndex] = timeStr
	private.msg[private.writeIndex] = msg
	private.writeIndex = (private.writeIndex < MAX_ROWS) and (private.writeIndex + 1) or 1
	private.len = min(private.len + 1, MAX_ROWS)

	if private.logToChat then
		private.LogToChat(severity, location, timeStr, msg)
	end
end

function private.LogToChat(severity, location, timeStr, msg)
	print(strjoin(" ", timeStr, Theme.GetFeedbackColor(CHAT_LOG_COLOR_KEYS[severity]):ColorText("{"..location.."}"), msg))
end
