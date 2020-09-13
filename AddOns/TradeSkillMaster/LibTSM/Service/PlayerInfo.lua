-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- PlayerInfo Functions
-- @module PlayerInfo

local _, TSM = ...
local PlayerInfo = TSM.Init("Service.PlayerInfo")
local String = TSM.Include("Util.String")
local Settings = TSM.Include("Service.Settings")
local private = {
	connectedAlts = {},
	settings = nil,
	isPlayerCache = {},
}
local PLAYER_NAME = UnitName("player")
local PLAYER_LOWER = strlower(PLAYER_NAME)
local FACTION_LOWER = strlower(UnitFactionGroup("player"))
local REALM_LOWER = strlower(GetRealmName())
local PLAYER_REALM_LOWER = PLAYER_LOWER.." - "..REALM_LOWER



-- ============================================================================
-- Module Loading
-- ============================================================================

PlayerInfo:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("factionrealm", "internalData", "guildVaults")
		:AddKey("factionrealm", "coreOptions", "ignoreGuilds")
		:AddKey("factionrealm", "internalData", "characterGuilds")
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Return all connected realm alternative characters.
-- @return table The populated alternative characters.
function PlayerInfo.GetConnectedAlts()
	wipe(private.connectedAlts)
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			local realm = strmatch(factionrealm, ".+ %- (.+)")
			character = Ambiguate(gsub(strmatch(character, "(.*) ?"..String.Escape("-").."?").."-"..gsub(realm, String.Escape("-"), ""), " ", ""), "none")
			if character ~= UnitName("player") then
				tinsert(private.connectedAlts, character)
			end
		end
	end
	sort(private.connectedAlts)
	return private.connectedAlts
end

--- Iterate over all characters on this factionrealm.
-- @tparam[opt=false] boolean currentAccountOnly If true, will only include the current account
-- @return An iterator with the following fields: `index, name`
function PlayerInfo.CharacterIterator(currentAccountOnly)
	if currentAccountOnly then
		return Settings.CharacterByAccountFactionrealmIterator()
	else
		return Settings.FactionrealmCharacterIterator()
	end
end

--- Iterate over all guilds on this factionrealm.
-- @tparam[opt=false] boolean includeIgnored If true, will include guilds which have been set to be ignored
-- @return An iterator with the following fields: `index, guildName`
function PlayerInfo.GuildIterator(includeIgnored)
	if includeIgnored then
		return private.GuildIteratorIgnoreIncluded, private.settings.guildVaults
	else
		return private.GuildIterator, private.settings.guildVaults
	end
end

--- Get the player's guild.
-- @tparam string player The name of the player
-- @treturn ?string The name of the player's guilde or nil if it's not in one
function PlayerInfo.GetPlayerGuild(player)
	return player and private.settings.characterGuilds[player] or nil
end

--- Check whether or not a player belongs to the user.
-- @tparam string target The name of the player
-- @tparam boolean includeAlts Whether or not to include alts
-- @tparam boolean includeOtherFaction Whether or not to include players on the other faction
-- @tparam boolean includeOtherAccounts Whether or not to include connected accounts
-- @treturn boolean Whether or not the player belongs to the user
function PlayerInfo.IsPlayer(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	local cacheKey = strjoin("%", target, includeAlts and "1" or "0", includeOtherFaction and "1" or "0", includeOtherAccounts and "1" or "0")
	if private.isPlayerCache.lastUpdate ~= GetTime() then
		wipe(private.isPlayerCache)
		private.isPlayerCache.lastUpdate = GetTime()
	end
	if private.isPlayerCache[cacheKey] == nil then
		private.isPlayerCache[cacheKey] = private.IsPlayerHelper(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	end
	return private.isPlayerCache[cacheKey]
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IsPlayerHelper(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	target = strlower(target)
	if not strfind(target, " %- ") then
		target = gsub(target, "%-", " - ", 1)
	end
	if target == PLAYER_LOWER then
		return true
	elseif strfind(target, " %- ") and target == PLAYER_REALM_LOWER then
		return true
	end
	if not strfind(target, " %- ") then
		target = target.." - "..REALM_LOWER
	end
	if includeAlts then
		local result = false
		for _, factionrealm, character in Settings.ConnectedFactionrealmAltCharacterIterator() do
			local factionKey, realm = strmatch(factionrealm, "(.+) %- (.+)")
			factionKey = strlower(factionKey)
			if not result and target == strlower(character).." - "..strlower(realm) and (includeOtherFaction or factionKey == FACTION_LOWER) and (includeOtherAccounts or Settings.IsCurrentAccountOwner(character)) then
				result = true
			end
		end
		return result
	end
	return false
end

function private.GuildIterator(tbl, prevName)
	while true do
		local name = next(tbl, prevName)
		if not name then
			return nil
		end
		if not private.settings.ignoreGuilds[name] then
			return name
		end
		prevName = name
	end
end

function private.GuildIteratorIgnoreIncluded(tbl, prevName)
	local name = next(tbl, prevName)
	return name
end
