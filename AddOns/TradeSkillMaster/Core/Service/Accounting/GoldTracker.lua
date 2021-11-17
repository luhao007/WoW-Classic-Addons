-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local GoldTracker = TSM.Accounting:NewPackage("GoldTracker")
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local CSV = TSM.Include("Util.CSV")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local Table = TSM.Include("Util.Table")
local TempTable = TSM.Include("Util.TempTable")
local Settings = TSM.Include("Service.Settings")
local PlayerInfo = TSM.Include("Service.PlayerInfo")
local private = {
	truncateGoldLog = {},
	characterGoldLog = {},
	guildGoldLog = {},
	currentCharacterKey = nil,
	playerLogCount = 0,
	searchValueTemp = {},
}
local CSV_KEYS = { "minute", "copper" }
local CHARACTER_KEY_SEP = " - "
local SECONDS_PER_MIN = 60
local SECONDS_PER_DAY = SECONDS_PER_MIN * 60 * 24
local MAX_COPPER_VALUE = 10 * 1000 * 1000 * COPPER_PER_GOLD - 1
local ERRONEOUS_ZERO_THRESHOLD = 5 * 1000 * COPPER_PER_GOLD



-- ============================================================================
-- Module Functions
-- ============================================================================

function GoldTracker.OnInitialize()
	if not TSM.IsWowVanillaClassic() then
		Event.Register("GUILDBANKFRAME_OPENED", private.GuildLogGold)
		Event.Register("GUILDBANK_UPDATE_MONEY", private.GuildLogGold)
	end
	Event.Register("PLAYER_MONEY", private.PlayerLogGold)

	-- get a list of known characters / guilds
	local validCharacterGuilds = TempTable.Acquire()
	for _, character in Settings.CharacterByFactionrealmIterator() do
		validCharacterGuilds[character..CHARACTER_KEY_SEP..UnitFactionGroup("player")..CHARACTER_KEY_SEP..GetRealmName()] = true
		local guild = TSM.db.factionrealm.internalData.characterGuilds[character]
		if guild then
			validCharacterGuilds[guild] = true
		end
	end

	-- load the gold log data
	for realm in TSM.db:GetConnectedRealmIterator("realm") do
		for factionrealm in TSM.db:FactionrealmByRealmIterator(realm) do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local data = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm), "internalData", "goldLog")
				if data then
					local lastUpdate = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm), "internalData", "goldLogLastUpdate") or 0
					local characterKey = character..CHARACTER_KEY_SEP..factionrealm
					private.LoadCharacterGoldLog(characterKey, data, validCharacterGuilds, lastUpdate)
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
					local lastEntryTime = #entries > 0 and entries[#entries].minute * SECONDS_PER_MIN or math.huge
					local lastUpdate = TSM.db:Get("factionrealm", factionrealm, "internalData", "guildGoldLogLastUpdate")
					if not validCharacterGuilds[guild] and max(lastEntryTime, lastUpdate and lastUpdate[guild] or 0) < time() - 30 * SECONDS_PER_DAY then
						-- this guild may not be valid and the last entry is over 30 days old, so truncate the data
						private.truncateGoldLog[guild] = lastEntryTime
					end
				end
			end
		end
	end
	TempTable.Release(validCharacterGuilds)
	private.currentCharacterKey = UnitName("player")..CHARACTER_KEY_SEP..UnitFactionGroup("player")..CHARACTER_KEY_SEP..GetRealmName()
	assert(private.characterGoldLog[private.currentCharacterKey])
end

function GoldTracker.OnEnable()
	-- Log the current player gold (need to wait for OnEnable, otherwise GetMoney() returns 0 when first logging in)
	private.PlayerLogGold()
end

function GoldTracker.OnDisable()
	private.PlayerLogGold()
	TSM.db.sync.internalData.goldLog = CSV.Encode(CSV_KEYS, private.characterGoldLog[private.currentCharacterKey])
	TSM.db.sync.internalData.goldLogLastUpdate = private.characterGoldLog[private.currentCharacterKey].lastUpdate
	local guild = PlayerInfo.GetPlayerGuild(UnitName("player"))
	if guild and private.guildGoldLog[guild] then
		TSM.db.factionrealm.internalData.guildGoldLog[guild] = CSV.Encode(CSV_KEYS, private.guildGoldLog[guild])
		TSM.db.factionrealm.internalData.guildGoldLogLastUpdate[guild] = private.guildGoldLog[guild].lastUpdate
	end
end

function GoldTracker.CharacterGuildIterator()
	return private.CharacterGuildIteratorHelper
end

function GoldTracker.GetGoldAtTime(timestamp, ignoredCharactersGuilds)
	local value = 0
	for character, logEntries in pairs(private.characterGoldLog) do
		if #logEntries > 0 and not ignoredCharactersGuilds[character] and (private.truncateGoldLog[character] or math.huge) > timestamp then
			value = value + private.GetValueAtTime(logEntries, timestamp)
		end
	end
	for guild, logEntries in pairs(private.guildGoldLog) do
		if #logEntries > 0 and not ignoredCharactersGuilds[guild] and (private.truncateGoldLog[guild] or math.huge) > timestamp then
			value = value + private.GetValueAtTime(logEntries, timestamp)
		end
	end
	return value
end

function GoldTracker.GetGraphTimeRange(ignoredCharactersGuilds)
	local minTime = Math.Floor(time(), SECONDS_PER_MIN)
	for character, logEntries in pairs(private.characterGoldLog) do
		if #logEntries > 0 and not ignoredCharactersGuilds[character] then
			minTime = min(minTime, logEntries[1].minute * SECONDS_PER_MIN)
		end
	end
	for guild, logEntries in pairs(private.guildGoldLog) do
		if #logEntries > 0 and not ignoredCharactersGuilds[guild] then
			minTime = min(minTime, logEntries[1].minute * SECONDS_PER_MIN)
		end
	end
	return minTime, Math.Floor(time(), SECONDS_PER_MIN), SECONDS_PER_MIN
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadCharacterGoldLog(characterKey, data, validCharacterGuilds, lastUpdate)
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

	entries.lastUpdate = lastUpdate
	private.characterGoldLog[characterKey] = entries
	local lastEntryTime = #entries > 0 and entries[#entries].minute * SECONDS_PER_MIN or math.huge
	if not validCharacterGuilds[characterKey] and max(lastEntryTime, lastUpdate) < time() - 30 * SECONDS_PER_DAY then
		-- this character may not be valid and the last entry is over 30 days old, so truncate the data
		private.truncateGoldLog[characterKey] = lastEntryTime
	end
end

function private.UpdateGoldLog(goldLog, copper)
	copper = Math.Round(copper, COPPER_PER_GOLD * (TSM.IsWowClassic() and 1 or 1000))
	local currentMinute = floor(time() / SECONDS_PER_MIN)
	local prevRecord = goldLog[#goldLog]

	-- store the last update time
	goldLog.lastUpdate = time()

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
	local isGuildLeader = IsGuildLeader()
	if guildName and not isGuildLeader then
		-- check if our alt is the guild leader
		for i = 1, GetNumGuildMembers() do
			local name, _, rankIndex = GetGuildRosterInfo(i)
			if name and rankIndex == 0 and PlayerInfo.IsPlayer(gsub(name, "%-", " - "), true) then
				isGuildLeader = true
			end
		end
	end
	if guildName and isGuildLeader then
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
	TSM.db.sync.internalData.money = money
end

function private.GetValueAtTime(logEntries, timestamp)
	local minute = floor(timestamp / SECONDS_PER_MIN)
	if logEntries[1].minute > minute then
		-- timestamp is before we had any data
		return 0
	end
	private.searchValueTemp.minute = minute
	local index, insertIndex = Table.BinarySearch(logEntries, private.searchValueTemp, private.GetEntryMinute)
	-- if we didn't find an exact match, the index is the previous one (compared to the insert index)
	-- as that point's gold value is true up until the next point
	index = index or (insertIndex - 1)
	return logEntries[index].copper
end

function private.GetEntryMinute(entry)
	return entry.minute
end

function private.CharacterGuildIteratorHelper(_, lastKey)
	local result, isGuild = nil, nil
	if not lastKey or private.characterGoldLog[lastKey] then
		result = next(private.characterGoldLog, lastKey)
		isGuild = false
		if not result then
			lastKey = nil
		end
	end
	if not result then
		result = next(private.guildGoldLog, lastKey)
		isGuild = result and true or false
	end
	return result, isGuild
end
