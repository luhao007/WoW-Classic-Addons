-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSM.Logger = {}
local Logger = TSM.Logger
local private = {
	startTime = time(),
	temp = {},
}
local MAX_ROWS = 200
local MAX_MSG_LEN = 150
local CHAT_COLORS = {
	TRACE = "|cff0000ff",
	INFO = "|cff00ff00",
	WARN = "|cffffff00",
	ERR = "|cffff0000",
}



-- ============================================================================
-- Logger Methods / Metatable
-- ============================================================================

local LOGGER_METHODS = {
	SetCurrentThreadNameFunction = function(self, func)
		self._currentThreadNameFunc = func
	end,

	SetLoggingToChatEnabled = function(self, enabled)
		self._logToChat = enabled
	end,

	Length = function(self)
		return self._len
	end,

	Get = function(self, index)
		assert(index <= self._len)
		local readIndex = (self._writeIndex - self._len + index - 2) % MAX_ROWS + 1
		return self._severity[readIndex], self._location[readIndex], self._timeStr[readIndex], self._msg[readIndex]
	end,

	Log = function(self, severity, fmtStr, ...)
		assert(type(fmtStr) == "string" and CHAT_COLORS[severity])
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
		local file, line = strmatch(TSM.Debug.GetDebugStackInfo(4) or "", "([^\\/]+%.lua):([0-9]+)")
		file = file or "?"
		line = line or "?"
		local location = nil
		local threadName = self._currentThreadNameFunc and self._currentThreadNameFunc() or nil
		if threadName then
			location = format("%s:%s|%s", file, line, threadName)
		else
			location = format("%s:%s", file, line)
		end
		local timeMs = TSM.Debug.GetTimeMilliseconds()
		local timeStr = format("%s.%03d", date("%H:%M:%S", floor(timeMs / 1000)), timeMs % 1000)

		-- append the log
		self._severity[self._writeIndex] = severity
		self._location[self._writeIndex] = location
		self._timeStr[self._writeIndex] = timeStr
		self._msg[self._writeIndex] = msg
		self._writeIndex = (self._writeIndex < MAX_ROWS) and (self._writeIndex + 1) or 1
		self._len = min(self._len + 1, MAX_ROWS)

		if self._logToChat then
			print(format("%s %s{%s}|r %s", timeStr, CHAT_COLORS[severity], location, msg))
		end
	end,

	Trace = function(self, ...)
		self:Log("TRACE", ...)
	end,

	Info = function(self, ...)
		self:Log("INFO", ...)
	end,

	Warn = function(self, ...)
		self:Log("WARN", ...)
	end,

	Err = function(self, ...)
		self:Log("ERR", ...)
	end,
}

local LOGGER_MT = {
	__index = LOGGER_METHODS,
	__metatable = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Logger.New()
	local obj = {
		_severity = {},
		_location = {},
		_timeStr = {},
		_msg = {},
		_writeIndex = 1,
		_len = 0,
		_logToChat = false,
		_currentThreadNameFunc = nil,
	}
	return setmetatable(obj, LOGGER_MT)
end
