-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local GoldTracker = TSM.Accounting:NewPackage("GoldTracker")
local L = TSM.Include("Locale").GetTable()
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local TempTable = TSM.Include("Util.TempTable")
local CSV = TSM.Include("Util.CSV")
local Math = TSM.Include("Util.Math")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local private = {
	characterGoldLog = {},
	guildGoldLog = {},
	currentCharacterKey = nil,
	lastDayTemp = {},
	playerLogCount = 0,
}
local CSV_KEYS = { "minute", "copper" }
local CHARACTER_KEY_SEP = " - "
local MAX_COPPER_VALUE = 10 * 1000 * 1000 * COPPER_PER_GOLD - 1
local ERRONEOUS_ZERO_THRESHOLD = 5 * 1000 * COPPER_PER_GOLD



-- ============================================================================
-- Module Functions
-- ============================================================================

function GoldTracker.OnInitialize()
	if not TSM.IsWowClassic() then
		Event.Register("GUILDBANKFRAME_OPENED", private.GuildLogGold)
		Event.Register("GUILDBANK_UPDATE_MONEY", private.GuildLogGold)
	end
	Event.Register("PLAYER_MONEY", private.PlayerLogGold)

	-- load the gold log data
	for realm in TSM.db:GetConnectedRealmIterator("realm") do
		for factionrealm in TSM.db:FactionrealmByRealmIterator(realm) do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local data = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm), "internalData", "goldLog")
				if data then
					local characterKey = character..CHARACTER_KEY_SEP..factionrealm
					private.LoadCharacterGoldLog(characterKey, data)
				end
			end
			local guildData = TSM.db:Get("factionrealm", factionrealm, "internalData", "guildGoldLog")
			if guildData then
				for guild, data in pairs(guildData) do
					local entries = {}
					local decodeContext = CSV.DecodeStart(data, CSV_KEYS)
					if decodeContext then
						for minute, copper in CSV.DecodeIterator(decodeContext) do
							tinsert(entries, { minute = tonumber(minute), copper = tonumber(copper) })
						end
						CSV.DecodeEnd(decodeContext)
					end
					private.guildGoldLog[guild] = entries
				end
			end
		end
	end
	private.currentCharacterKey = UnitName("player")..CHARACTER_KEY_SEP..UnitFactionGroup("player")..CHARACTER_KEY_SEP..GetRealmName()
	assert(private.characterGoldLog[private.currentCharacterKey])
end

function GoldTracker.OnEnable()
	-- Log the current player gold (need to wait for OnEnable, otherwise GetMoney() returns 0 when first logging in)
	private.PlayerLogGold()
end

function GoldTracker.OnDisable()
	private.PlayerLogGold()
	if not TSM.IsWowClassic() then
		private.GuildLogGold()
	end
	TSM.db.sync.internalData.goldLog = CSV.Encode(CSV_KEYS, private.characterGoldLog[private.currentCharacterKey])
	local guild = TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(UnitName("player"))
	if guild and private.guildGoldLog[guild] then
		TSM.db.factionrealm.internalData.guildGoldLog[guild] = CSV.Encode(CSV_KEYS, private.guildGoldLog[guild])
	end
end

function GoldTracker.CharacterGuildIterator()
	return private.CharacterGuildIteratorHelper
end

function GoldTracker.PopulateGraphData(xData, xDataValue, yData, xUnit, numXUnits, selectedCharacterGuild)
	local timeTable = TempTable.Acquire()
	local numPoints = numXUnits
	if xUnit == "halfMonth" then
		assert(numXUnits % 24 == 0)
		timeTable.year = tonumber(date("%Y")) - numXUnits / 24
		timeTable.month = tonumber(date("%m"))
		timeTable.day = tonumber(date("%d")) >= 15 and 15 or 1
		private.AddXUnit(timeTable, xUnit)
		if timeTable.day == 15 then
			-- need to start on the first day of a month, so add another point
			private.AddXUnit(timeTable, xUnit)
			numPoints = numPoints - 1
		end
	elseif xUnit == "month" then
		assert(numXUnits % 30 == 0)
		timeTable.year = tonumber(date("%Y"))
		timeTable.month = tonumber(date("%m")) - numXUnits / 30
		timeTable.day = tonumber(date("%d")) + 1
		private.AddXUnit(timeTable, xUnit)
	elseif xUnit == "sevenDays" then
		assert(numXUnits % 24 == 0)
		timeTable.year = tonumber(date("%Y"))
		timeTable.month = tonumber(date("%m"))
		timeTable.day = tonumber(date("%d")) - 6
		timeTable.hour = tonumber(date("%H")) - numXUnits / 24
		private.AddXUnit(timeTable, xUnit)
	elseif xUnit == "hour" then
		assert(numXUnits % 24 == 0)
		timeTable.year = tonumber(date("%Y"))
		timeTable.month = tonumber(date("%m"))
		timeTable.day = tonumber(date("%d")) - numXUnits / 24
		timeTable.hour = tonumber(date("%H")) + 1
		private.AddXUnit(timeTable, xUnit)
	else
		error("Invalid xUnit: "..tostring(xUnit))
	end
	for i = 1, numPoints do
		tinsert(xData, i)
		tinsert(xDataValue, time(timeTable))
		tinsert(yData, 0)
		private.AddXUnit(timeTable, xUnit)
	end
	TempTable.Release(timeTable)

	for character, logEntries in pairs(private.characterGoldLog) do
		if strmatch(character, "^"..String.Escape(selectedCharacterGuild)) or selectedCharacterGuild == L["All Characters and Guilds"] then
			for i, timestamp in ipairs(xDataValue) do
				yData[i] = yData[i] + private.GetGoldValueAtTime(logEntries, timestamp)
			end
		end
	end
	for guild, logEntries in pairs(private.guildGoldLog) do
		if selectedCharacterGuild == guild or selectedCharacterGuild == L["All Characters and Guilds"] then
			for i, timestamp in ipairs(xDataValue) do
				yData[i] = yData[i] + private.GetGoldValueAtTime(logEntries, timestamp)
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadCharacterGoldLog(characterKey, data)
	assert(not private.characterGoldLog[characterKey])
	local decodeContext = CSV.DecodeStart(data, CSV_KEYS)
	if not decodeContext then
		Log.Err("Failed to decode (%s, %d)", characterKey, #data)
		private.characterGoldLog[characterKey] = {}
		return
	end

	local entries = {}
	for minute, copper in CSV.DecodeIterator(decodeContext) do
		tinsert(entries, { minute = tonumber(minute), copper = tonumber(copper) })
	end
	CSV.DecodeEnd(decodeContext)

	-- clean up any erroneous 0 entries, entries which are too high, and duplicate entries
	local didChange = true
	while didChange do
		didChange = false
		for i = #entries - 1, 2, -1 do
			local prevValue = entries[i-1].copper
			local value = entries[i].copper
			local nextValue = entries[i+1].copper
			if prevValue > ERRONEOUS_ZERO_THRESHOLD and value == 0 and nextValue > ERRONEOUS_ZERO_THRESHOLD then
				-- this is likely an erroneous 0 value
				didChange = true
				tremove(entries, i)
			end
		end
		for i = #entries, 2, -1 do
			local prevValue = entries[i-1].copper
			local value = entries[i].copper
			if prevValue == value or value > MAX_COPPER_VALUE then
				-- this is either a duplicate or invalid value
				didChange = true
				tremove(entries, i)
			end
		end
	end

	private.characterGoldLog[characterKey] = entries
end

function private.UpdateGoldLog(goldLog, copper)
	copper = Math.Round(copper, COPPER_PER_GOLD * (TSM.IsWowClassic() and 1 or 1000))
	local currentMinute = floor(time() / 60)
	local prevRecord = goldLog[#goldLog]

	if prevRecord and copper == prevRecord.copper then
		-- amount of gold hasn't changed, so nothing to do
		return
	elseif prevRecord and prevRecord.minute == currentMinute then
		-- gold has changed and the previous record is for the current minute so just modify it
		prevRecord.copper = copper
	else
		-- amount of gold changed and we're in a new minute, so insert a new record
		while prevRecord and prevRecord.minute > currentMinute - 1 do
			-- their clock may have changed - just delete everything that's too recent
			tremove(goldLog)
			prevRecord = goldLog[#goldLog]
		end
		tinsert(goldLog, {
			minute = currentMinute,
			copper = copper
		})
	end
end

function private.GuildLogGold()
	local guildName = GetGuildInfo("player")
	if guildName and IsGuildLeader() then
		if not private.guildGoldLog[guildName] then
			private.guildGoldLog[guildName] = {}
		end
		private.UpdateGoldLog(private.guildGoldLog[guildName], GetGuildBankMoney())
	end
end

function private.PlayerLogGold()
	-- GetMoney sometimes returns 0 for a while after login, so keep trying for 30 seconds before recording a 0
	local money = GetMoney()
	if money == 0 and private.playerLogCount < 30 then
		private.playerLogCount = private.playerLogCount + 1
		Delay.AfterTime(1, private.PlayerLogGold)
		return
	end
	private.playerLogCount = 0
	private.UpdateGoldLog(private.characterGoldLog[private.currentCharacterKey], money)
end

function private.AddXUnit(timeTable, xUnit)
	if xUnit == "halfMonth" then
		if timeTable.day == 1 then
			timeTable.day = 15
		else
			timeTable.day = 1
			if timeTable.month == 12 then
				timeTable.month = 1
				timeTable.year = timeTable.year + 1
			else
				timeTable.month = timeTable.month + 1
			end
		end
	elseif xUnit == "month" then
		if timeTable.day == private.GetMonthLastDay(timeTable) then
			timeTable.day = 1
			if timeTable.month == 12 then
				timeTable.month = 1
				timeTable.year = timeTable.year + 1
			else
				timeTable.month = timeTable.month + 1
			end
		else
			timeTable.day = timeTable.day + 1
		end
	elseif xUnit == "sevenDays" then
		if timeTable.hour == 23 then
			timeTable.hour = 0
			if timeTable.day == private.GetMonthLastDay(timeTable) then
				timeTable.day = 1
				if timeTable.month == 12 then
					timeTable.month = 1
					timeTable.year = timeTable.year + 1
				else
					timeTable.month = timeTable.month + 1
				end
			else
				timeTable.day = timeTable.day + 1
			end
		else
			timeTable.hour = timeTable.hour + 6
		end
	elseif xUnit == "hour" then
		if timeTable.hour == 23 then
			timeTable.hour = 0
			timeTable.day = timeTable.day + 1
		else
			timeTable.hour = timeTable.hour + 1
		end
	end
end

function private.GetMonthLastDay(timeTable)
	private.lastDayTemp.year = timeTable.year
	private.lastDayTemp.month = timeTable.month + 1
	private.lastDayTemp.day = 0
	return tonumber(date("%d", time(private.lastDayTemp)))
end

function private.GetGoldValueAtTime(logEntries, timestamp)
	if #logEntries == 0 then
		-- timestamp is before we had any data
		return 0
	end
	local minuteTimestamp = floor(timestamp / 60)
	for i = 1, #logEntries do
		if logEntries[i].minute > minuteTimestamp then
			if i == 1 then
				-- timestamp is before we had any data
				return 0
			end
			return Math.Round(logEntries[i-1].copper / (COPPER_PER_GOLD * (TSM.IsWowClassic() and 1 or 1000)))
		end
	end
	-- we're on the most recent entry
	return Math.Round(logEntries[#logEntries].copper / (COPPER_PER_GOLD * (TSM.IsWowClassic() and 1 or 1000)))
end

function private.CharacterGuildIteratorHelper(_, lastKey)
	local result = nil
	if not lastKey or private.characterGoldLog[lastKey] then
		result = next(private.characterGoldLog, lastKey)
		if not result then
			lastKey = nil
		end
	end
	if not result then
		result = next(private.guildGoldLog, lastKey)
	end
	return result
end
