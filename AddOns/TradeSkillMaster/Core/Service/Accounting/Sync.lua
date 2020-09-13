-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AccountingSync = TSM.Accounting:NewPackage("Sync")
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local Theme = TSM.Include("Util.Theme")
local Sync = TSM.Include("Service.Sync")
local private = {
	accountLookup = {},
	accountStatus = {},
	pendingChunks = {},
	dataTemp = {},
}
local CHANGE_NOTIFICATION_DELAY = 5
local RETRY_DELAY = 5



-- ============================================================================
-- Module Functions
-- ============================================================================

function AccountingSync.OnInitialize()
	Sync.RegisterConnectionChangedCallback(private.ConnectionChangedHandler)
	Sync.RegisterRPC("ACCOUNTING_GET_PLAYER_HASH", private.RPCGetPlayerHash)
	Sync.RegisterRPC("ACCOUNTING_GET_PLAYER_CHUNKS", private.RPCGetPlayerChunks)
	Sync.RegisterRPC("ACCOUNTING_GET_PLAYER_DATA", private.RPCGetData)
	Sync.RegisterRPC("ACCOUNTING_CHANGE_NOTIFICATION", private.RPCChangeNotification)
end

function AccountingSync.GetStatus(account)
	local status = private.accountStatus[account]
	if not status then
		return Theme.GetFeedbackColor("RED"):ColorText(L["Not Connected"])
	elseif status == "GET_PLAYER_HASH" or status == "GET_PLAYER_CHUNKS" or status == "GET_PLAYER_DATA" or status == "RETRY" then
		return Theme.GetFeedbackColor("YELLOW"):ColorText(L["Updating"])
	elseif status == "SYNCED" then
		return Theme.GetFeedbackColor("GREEN"):ColorText(L["Up to date"])
	else
		error("Invalid status: "..tostring(status))
	end
end

function AccountingSync.OnTransactionsChanged()
	Delay.AfterTime("ACCOUNTING_SYNC_CHANGE", CHANGE_NOTIFICATION_DELAY, private.NotifyChange)
end



-- ============================================================================
-- RPC Functions and Result Handlers
-- ============================================================================

function private.GetPlayerHash(player)
	local account = private.accountLookup[player]
	private.accountStatus[account] = "GET_PLAYER_HASH"
	TSM.Accounting.Transactions.PrepareSyncHashes(player)
	Sync.CallRPC("ACCOUNTING_GET_PLAYER_HASH", player, private.RPCGetPlayerHashResultHandler)
end

function private.RPCGetPlayerHash()
	local player = UnitName("player")
	return player, TSM.Accounting.Transactions.GetSyncHash(player)
end

function private.RPCGetPlayerHashResultHandler(player, hash)
	local account = player and private.accountLookup[player]
	if not account then
		-- request timed out, so try again
		Log.Warn("Getting player hash timed out")
		private.QueueRetriesByStatus("GET_PLAYER_HASH")
		return
	elseif not hash then
		-- the hash isn't ready yet, so try again
		Log.Warn("Sync player hash not ready yet")
		private.QueueRetryByPlayer(player)
		return
	end
	if private.accountStatus[account] == "RETRY" then
		-- There is a race condition where if we tried to issue GET_PLAYER_HASH for two players and one times out,
		-- we would also queue a retry for the other one, so handle that here.
		private.accountStatus[account] = "GET_PLAYER_HASH"
	end
	assert(private.accountStatus[account] == "GET_PLAYER_HASH")

	local currentHash = TSM.Accounting.Transactions.GetSyncHash(player)
	if not currentHash then
		-- don't have our hash yet, so try again
		Log.Warn("Current player hash not ready yet")
		private.QueueRetryByPlayer(player)
		return
	end

	if hash ~= currentHash then
		Log.Info("Need updated transactions data from %s (%s, %s)", player, hash, currentHash)
		private.GetPlayerChunks(player)
	else
		Log.Info("Transactions data for %s already up to date (%s, %s)", player, hash, currentHash)
		private.accountStatus[account] = "SYNCED"
	end
end

function private.GetPlayerChunks(player)
	local account = private.accountLookup[player]
	private.accountStatus[account] = "GET_PLAYER_CHUNKS"
	Sync.CallRPC("ACCOUNTING_GET_PLAYER_CHUNKS", player, private.RPCGetPlayerChunksResultHandler)
end

function private.RPCGetPlayerChunks()
	local player = UnitName("player")
	return player, TSM.Accounting.Transactions.GetSyncHashByDay(player)
end

function private.RPCGetPlayerChunksResultHandler(player, chunks)
	local account = player and private.accountLookup[player]
	if not account then
		-- request timed out, so try again from the start
		Log.Warn("Getting chunks timed out")
		private.QueueRetriesByStatus("GET_PLAYER_CHUNKS")
		return
	elseif not chunks then
		-- the hashes have been invalidated, so try again from the start
		Log.Warn("Sync player chunks not ready yet")
		private.QueueRetryByPlayer(player)
		return
	end
	assert(private.accountStatus[account] == "GET_PLAYER_CHUNKS")

	local currentChunks = TSM.Accounting.Transactions.GetSyncHashByDay(player)
	if not currentChunks then
		-- our hashes have been invalidated, so try again from the start
		Log.Warn("Local hashes are invalid")
		private.QueueRetryByPlayer(player)
		return
	end
	for day in pairs(currentChunks) do
		if not chunks[day] then
			-- remove day which no longer exists
			TSM.Accounting.Transactions.RemovePlayerDay(player, day)
		end
	end

	-- queue up all the pending chunks
	private.pendingChunks[player] = private.pendingChunks[player] or TempTable.Acquire()
	wipe(private.pendingChunks[player])
	for day, hash in pairs(chunks) do
		if currentChunks[day] ~= hash then
			tinsert(private.pendingChunks[player], day)
		end
	end

	local requestDay = private.GetNextPendingChunk(player)
	if requestDay then
		Log.Info("Requesting transactions data (%s, %s, %s, %s)", player, requestDay, tostring(currentChunks[requestDay]), chunks[requestDay])
		private.GetPlayerData(player, requestDay)
	else
		Log.Info("All chunks are up to date (%s)", player)
		private.accountStatus[account] = "SYNCED"
	end
end

function private.GetPlayerData(player, requestDay)
	local account = private.accountLookup[player]
	private.accountStatus[account] = "GET_PLAYER_DATA"
	Sync.CallRPC("ACCOUNTING_GET_PLAYER_DATA", player, private.RPCGetDataResultHandler, requestDay)
end

function private.RPCGetData(day)
	local player = UnitName("player")
	wipe(private.dataTemp)
	TSM.Accounting.Transactions.GetSyncData(player, day, private.dataTemp)
	return player, day, private.dataTemp
end

function private.RPCGetDataResultHandler(player, day, data)
	local account = player and private.accountLookup[player]
	if not account then
		-- request timed out, so try again from the start
		Log.Warn("Getting transactions data timed out")
		private.QueueRetriesByStatus("GET_PLAYER_DATA")
		return
	elseif #data % 9 ~= 0 then
		-- invalid data - just silently give up
		Log.Warn("Got invalid transactions data")
		return
	end
	assert(private.accountStatus[account] == "GET_PLAYER_DATA")

	Log.Info("Received transactions data (%s, %s, %s)", player, day, #data)
	TSM.Accounting.Transactions.HandleSyncedData(player, day, data)

	local requestDay = private.GetNextPendingChunk(player)
	if requestDay then
		-- request the next chunk
		Log.Info("Requesting transactions data (%s, %s)", player, requestDay)
		private.GetPlayerData(player, requestDay)
	else
		-- request chunks again to check for other chunks we need to sync
		private.GetPlayerChunks(player)
	end
end

function private.RPCChangeNotification(player)
	if private.accountStatus[private.accountLookup[player]] == "SYNCED" then
		-- request the player hash
		Log.Info("Got change notification - requesting player hash")
		private.GetPlayerHash(player)
	else
		Log.Info("Got change notification - dropping (%s)", tostring(private.accountStatus[private.accountLookup[player]]))
	end
end

function private.RPCChangeNotificationResultHandler()
	-- nop
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ConnectionChangedHandler(account, player, connected)
	if connected then
		private.accountLookup[player] = account
		private.GetPlayerHash(player)
	else
		private.accountLookup[player] = nil
		private.accountStatus[account] = nil
		if private.pendingChunks[player] then
			TempTable.Release(private.pendingChunks[player])
			private.pendingChunks[player] = nil
		end
	end
end

function private.GetNextPendingChunk(player)
	if not private.pendingChunks[player] then
		return nil
	end
	local result = tremove(private.pendingChunks[player])
	if not result then
		TempTable.Release(private.pendingChunks[player])
		private.pendingChunks[player] = nil
	end
	return result
end

function private.QueueRetriesByStatus(statusFilter)
	for player, account in pairs(private.accountLookup) do
		if private.accountStatus[account] == statusFilter then
			private.QueueRetryByPlayer(player)
		end
	end
end

function private.QueueRetryByPlayer(player)
	local account = private.accountLookup[player]
	Log.Info("Retrying (%s, %s, %s)", player, account, private.accountStatus[account])
	private.accountStatus[account] = "RETRY"
	Delay.AfterTime(RETRY_DELAY, private.RetryGetPlayerHashRPC)
end

function private.RetryGetPlayerHashRPC()
	for player, account in pairs(private.accountLookup) do
		if private.accountStatus[account] == "RETRY" then
			private.GetPlayerHash(player)
		end
	end
end

function private.NotifyChange()
	for player, account in pairs(private.accountLookup) do
		if private.accountStatus[account] == "SYNCED" then
			-- notify the other account that our data has changed and request the other account's latest hash ourselves
			private.GetPlayerHash(player)
			Sync.CallRPC("ACCOUNTING_CHANGE_NOTIFICATION", player, private.RPCChangeNotificationResultHandler, UnitName("player"))
		end
	end
end
