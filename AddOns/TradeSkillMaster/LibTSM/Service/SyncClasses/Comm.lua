-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Comm = TSM.Init("Service.SyncClasses.Comm") ---@class Service.SyncClasses.Comm
local Delay = TSM.Include("Util.Delay")
local Table = TSM.Include("Util.Table")
local Log = TSM.Include("Util.Log")
local Settings = TSM.Include("Service.Settings")
local Constants = TSM.Include("Service.SyncClasses.Constants")
local private = {
	disconnectFunc = nil,
	handler = {},
	queuedPacket = {},
	queuedSourceCharacter = {},
	queueTimer = nil,
	versionStr = Constants.VERSION.."_"..GetLocale(),
}
-- Load libraries
LibStub("AceComm-3.0"):Embed(Comm)
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")



-- ============================================================================
-- Module Loading
-- ============================================================================

Comm:OnModuleLoad(function()
	private.queueTimer = Delay.CreateTimer("SYNC_COMM_QUEUE", private.ProcessReceiveQueue)
	Comm:RegisterComm("TSMSyncData", private.OnCommReceived)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Comm.SetDisconnectFunction(func)
	private.disconnectFunc = func
end

function Comm.RegisterHandler(dataType, handler)
	assert(Table.KeyByValue(Constants.DATA_TYPES, dataType) ~= nil)
	assert(not private.handler[dataType])
	private.handler[dataType] = handler
end

function Comm.SendData(dataType, targetCharacter, data)
	assert(type(dataType) == "string" and #dataType == 1)
	local serialized = LibSerialize:Serialize(private.versionStr, dataType, Settings.GetCurrentSyncAccountKey(), data)
	local compressed = LibDeflate:EncodeForWoWAddonChannel(LibDeflate:CompressDeflate(serialized))
	assert(LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(compressed)) == serialized)

	-- Give heartbeats and rpc preambles a higher priority
	local priority = (dataType == Constants.DATA_TYPES.HEARTBEAT or dataType == Constants.DATA_TYPES.RPC_PREAMBLE) and "ALERT" or nil
	-- Send the message
	Comm:SendCommMessage("TSMSyncData", compressed, "WHISPER", targetCharacter, priority)
	return #compressed
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnCommReceived(_, packet, _, sourceCharacter)
	-- Delay the processing to make sure it happens within a debuggable context (this function is called via pcall)
	tinsert(private.queuedPacket, packet)
	tinsert(private.queuedSourceCharacter, sourceCharacter)
	private.queueTimer:RunForFrames(0)
end

function private.ProcessReceiveQueue()
	assert(#private.queuedPacket == #private.queuedSourceCharacter)
	while #private.queuedPacket > 0 do
		local packet = tremove(private.queuedPacket, 1)
		local sourceCharacter = tremove(private.queuedSourceCharacter, 1)
		private.ProcessReceivedPacket(packet, sourceCharacter)
	end
end

function private.ProcessReceivedPacket(msg, sourceCharacter)
	-- Remove realm name from source player
	sourceCharacter = strsplit("-", sourceCharacter)
	sourceCharacter = strtrim(sourceCharacter)
	local sourceCharacterAccountKey = Settings.GetCharacterSyncAccountKey(sourceCharacter)
	if sourceCharacterAccountKey and sourceCharacterAccountKey == Settings.GetCurrentSyncAccountKey() then
		Log.Err("We own the source character")
		Settings.ShowSyncSVCopyError()
		return
	end

	-- In combat, so drop the connection
	if InCombatLockdown() then
		return private.disconnectFunc(sourceCharacter)
	end

	-- Decode and decompress
	msg = LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(msg))
	if not msg then
		Log.Err("Invalid packet")
		return
	end
	local success, versionStr, dataType, sourceAccount, data = LibSerialize:Deserialize(msg)
	if not success then
		Log.Err("Invalid packet")
		return
	end

	-- Validate the packet
	if versionStr ~= private.versionStr or type(dataType) ~= "string" or #dataType ~= 1 or not sourceAccount then
		Log.Info("Invalid message received")
		return
	elseif sourceAccount == Settings.GetCurrentSyncAccountKey() then
		Log.Err("We are the source account (SV copy)")
		Settings.ShowSyncSVCopyError()
		return
	elseif sourceCharacterAccountKey and sourceCharacterAccountKey ~= sourceAccount then
		-- the source player now belongs to a different account than what we expect
		Log.Err("Unexpected source account")
		Settings.ShowSyncSVCopyError()
		return
	end

	if private.handler[dataType] then
		private.handler[dataType](sourceAccount, sourceCharacter, data)
	else
		Log.Info("Received unhandled message of type: "..strbyte(dataType))
	end
end
