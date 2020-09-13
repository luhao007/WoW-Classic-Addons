-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CraftingSync = TSM.Crafting:NewPackage("Sync")
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local TempTable = TSM.Include("Util.TempTable")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Theme = TSM.Include("Util.Theme")
local Sync = TSM.Include("Service.Sync")
local private = {
	hashesTemp = {},
	spellsTemp = {},
	spellsProfessionLookupTemp = {},
	spellInfoTemp = {
		spellIds = {},
		mats = {},
		itemStrings = {},
		names = {},
		numResults = {},
		hasCDs = {},
	},
	accountLookup = {},
	accountStatus = {},
}
local RETRY_DELAY = 5
local PROFESSION_HASH_FIELDS = { "spellId", "itemString" }



-- ============================================================================
-- Module Functions
-- ============================================================================

function CraftingSync.OnInitialize()
	Sync.RegisterConnectionChangedCallback(private.ConnectionChangedHandler)
	Sync.RegisterRPC("CRAFTING_GET_HASHES", private.RPCGetHashes)
	Sync.RegisterRPC("CRAFTING_GET_SPELLS", private.RPCGetSpells)
	Sync.RegisterRPC("CRAFTING_GET_SPELL_INFO", private.RPCGetSpellInfo)
end

function CraftingSync.GetStatus(account)
	local status = private.accountStatus[account]
	if not status then
		return Theme.GetFeedbackColor("RED"):ColorText(L["Not Connected"])
	elseif status == "UPDATING" or status == "RETRY" then
		return Theme.GetFeedbackColor("YELLOW"):ColorText(L["Updating"])
	elseif status == "SYNCED" then
		return Theme.GetFeedbackColor("GREEN"):ColorText(L["Up to date"])
	else
		error("Invalid status: "..tostring(status))
	end
end



-- ============================================================================
-- RPC Functions and Result Handlers
-- ============================================================================

function private.RPCGetHashes()
	wipe(private.hashesTemp)
	local player = UnitName("player")
	private.GetPlayerProfessionHashes(player, private.hashesTemp)
	return player, private.hashesTemp
end

function private.RPCGetHashesResultHandler(player, data)
	if not player or not private.accountLookup[player] then
		-- request timed out, so try again
		Log.Warn("Getting hashes timed out")
		if private.accountLookup[player] then
			private.accountStatus[private.accountLookup[player]] = "RETRY"
			Delay.AfterTime(RETRY_DELAY, private.RetryGetHashesRPC)
		end
		return
	end
	local currentInfo = TempTable.Acquire()
	private.GetPlayerProfessionHashes(player, currentInfo)
	local requestProfessions = TempTable.Acquire()
	for profession, hash in pairs(data) do
		if hash == currentInfo[profession] then
			Log.Info("%s data for %s already up to date", profession, player)
		else
			Log.Info("Need updated %s data from %s (%s, %s)", profession, player, hash, tostring(currentInfo[hash]))
			requestProfessions[profession] = true
		end
	end
	TempTable.Release(currentInfo)
	if next(requestProfessions) then
		private.accountStatus[private.accountLookup[player]] = "UPDATING"
		Sync.CallRPC("CRAFTING_GET_SPELLS", player, private.RPCGetSpellsResultHandler, requestProfessions)
	else
		private.accountStatus[private.accountLookup[player]] = "SYNCED"
	end
	TempTable.Release(requestProfessions)
end

function private.RPCGetSpells(professions)
	wipe(private.spellsProfessionLookupTemp)
	wipe(private.spellsTemp)
	local player = UnitName("player")
	local query = TSM.Crafting.CreateRawCraftsQuery()
		:Select("spellId", "profession")
		:Custom(private.QueryProfessionFilter, professions)
		:Custom(private.QueryPlayerFilter, player)
		:OrderBy("spellId", true)
	for _, spellId, profession in query:Iterator() do
		private.spellsProfessionLookupTemp[spellId] = profession
		tinsert(private.spellsTemp, spellId)
	end
	query:Release()
	return player, private.spellsProfessionLookupTemp, private.spellsTemp
end

function private.RPCGetSpellsResultHandler(player, professionLookup, spells)
	if not player or not private.accountLookup[player] then
		-- request timed out, so try again from the start
		Log.Warn("Getting spells timed out")
		if private.accountLookup[player] then
			private.accountStatus[private.accountLookup[player]] = "RETRY"
			Delay.AfterTime(RETRY_DELAY, private.RetryGetHashesRPC)
		end
		return
	end

	for i = #spells, 1, -1 do
		local spellId = spells[i]
		if TSM.Crafting.HasSpellId(spellId) then
			-- already have this spell so just make sure this player is added
			TSM.Crafting.AddPlayer(spellId, player)
			tremove(spells, i)
		end
	end
	if #spells == 0 then
		Log.Info("Spells up to date for %s", player)
		private.accountStatus[private.accountLookup[player]] = "SYNCED"
	else
		Log.Info("Requesting %d spells from %s", #spells, player)
		Sync.CallRPC("CRAFTING_GET_SPELL_INFO", player, private.RPCGetSpellInfoResultHandler, professionLookup, spells)
	end
end

function private.RPCGetSpellInfo(professionLookup, spells)
	for _, tbl in pairs(private.spellInfoTemp) do
		wipe(tbl)
	end
	for i, spellId in ipairs(spells) do
		private.spellInfoTemp.spellIds[i] = spellId
		private.spellInfoTemp.mats[i] = TSM.db.factionrealm.internalData.crafts[spellId].mats
		private.spellInfoTemp.itemStrings[i] = TSM.db.factionrealm.internalData.crafts[spellId].itemString
		private.spellInfoTemp.names[i] = TSM.db.factionrealm.internalData.crafts[spellId].name
		private.spellInfoTemp.numResults[i] = TSM.db.factionrealm.internalData.crafts[spellId].numResult
		private.spellInfoTemp.hasCDs[i] = TSM.db.factionrealm.internalData.crafts[spellId].hasCD
	end
	Log.Info("Sent %d spells", #private.spellInfoTemp.spellIds)
	return UnitName("player"), professionLookup, private.spellInfoTemp
end

function private.RPCGetSpellInfoResultHandler(player, professionLookup, spellInfo)
	if not player or not professionLookup or not spellInfo or not private.accountLookup[player] then
		-- request timed out, so try again from the start
		Log.Warn("Getting spell info timed out")
		if private.accountLookup[player] then
			private.accountStatus[private.accountLookup[player]] = "RETRY"
			Delay.AfterTime(RETRY_DELAY, private.RetryGetHashesRPC)
		end
		return
	end

	for i, spellId in ipairs(spellInfo.spellIds) do
		TSM.Crafting.CreateOrUpdate(spellId, spellInfo.itemStrings[i], professionLookup[spellId], spellInfo.names[i], spellInfo.numResults[i], player, spellInfo.hasCDs[i] and true or false)
		for itemString in pairs(spellInfo.mats[i]) do
			TSM.db.factionrealm.internalData.mats[itemString] = TSM.db.factionrealm.internalData.mats[itemString] or {}
		end
		TSM.Crafting.SetMats(spellId, spellInfo.mats[i])
	end
	Log.Info("Added %d spells from %s", #spellInfo.spellIds, player)
	private.accountStatus[private.accountLookup[player]] = "SYNCED"
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ConnectionChangedHandler(account, player, connected)
	if connected then
		private.accountLookup[player] = account
		private.accountStatus[account] = "UPDATING"
		-- issue a request for profession info
		Sync.CallRPC("CRAFTING_GET_HASHES", player, private.RPCGetHashesResultHandler)
	else
		private.accountLookup[player] = nil
		private.accountStatus[account] = nil
	end
end

function private.RetryGetHashesRPC()
	for player, account in pairs(private.accountLookup) do
		if private.accountStatus[account] == "RETRY" then
			Sync.CallRPC("CRAFTING_GET_HASHES", player, private.RPCGetHashesResultHandler)
		end
	end
end

function private.QueryProfessionFilter(row, professions)
	return professions[row:GetField("profession")]
end

function private.QueryPlayerFilter(row, player)
	return String.SeparatedContains(row:GetField("players"), ",", player)
end

function private.GetPlayerProfessionHashes(player, resultTbl)
	local query = TSM.Crafting.CreateRawCraftsQuery()
		:Custom(private.QueryPlayerFilter, player)
		:OrderBy("spellId", true)
	query:GroupedHash(PROFESSION_HASH_FIELDS, "profession", resultTbl)
	query:Release()
end
