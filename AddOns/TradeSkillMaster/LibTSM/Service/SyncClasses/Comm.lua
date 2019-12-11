-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Comm = TSM.Init("Service.SyncClasses.Comm")
local Delay = TSM.Include("Util.Delay")
local Table = TSM.Include("Util.Table")
local TempTable = TSM.Include("Util.TempTable")
local Log = TSM.Include("Util.Log")
local Settings = TSM.Include("Service.Settings")
local Constants = TSM.Include("Service.SyncClasses.Constants")
local private = {
	handler = {},
	queuedPacket = {},
	queuedSourceCharacter = {},
}
-- load libraries
LibStub("AceComm-3.0"):Embed(Comm)
local AceSerializer = LibStub("AceSerializer-3.0")
local LibCompress = LibStub("LibCompress")
local LibCompressAddonEncodeTable = LibCompress:GetAddonEncodeTable()



-- ============================================================================
-- Module Loading
-- ============================================================================

Comm:OnModuleLoad(function()
	Comm:RegisterComm("TSMSyncData", private.OnCommReceived)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Comm.RegisterHandler(dataType, handler)
	assert(Table.KeyByValue(Constants.DATA_TYPES, dataType) ~= nil)
	assert(not private.handler[dataType])
	private.handler[dataType] = handler
end

function Comm.SendData(dataType, targetCharacter, data)
	assert(type(dataType) == "string" and #dataType == 1)
	local serialized = nil
	if data then
		local packet = TempTable.Acquire()
		packet.dt = dataType
		packet.sa = Settings.GetCurrentSyncAccountKey()
		packet.v = Constants.VERSION
		packet.d = data
		serialized = AceSerializer:Serialize(packet)
		TempTable.Release(packet)
	else
		-- send a more compact version if there's no data
		serialized = "\240"..strjoin(";", dataType, Settings.GetCurrentSyncAccountKey(), UnitName("player"), Constants.VERSION)
	end

	-- We will compress using Huffman, LZW, and no compression separately, validate each one, and pick the shortest valid one.
	-- This is to deal with a bug in the compression code.
	local encodedData = TempTable.Acquire()
	local huffmanCompressed = LibCompress:CompressHuffman(serialized)
	if huffmanCompressed then
		huffmanCompressed = LibCompressAddonEncodeTable:Encode(huffmanCompressed)
		tinsert(encodedData, huffmanCompressed)
	end
	local lzwCompressed = LibCompress:CompressLZW(serialized)
	if lzwCompressed then
		lzwCompressed = LibCompressAddonEncodeTable:Encode(lzwCompressed)
		tinsert(encodedData, lzwCompressed)
	end
	local uncompressed = LibCompressAddonEncodeTable:Encode("\001"..serialized)
	tinsert(encodedData, uncompressed)
	-- verify each compresion and pick the shortest valid one
	local minIndex = -1
	local minLen = math.huge
	for i = #encodedData, 1, -1 do
		local test = LibCompress:Decompress(LibCompressAddonEncodeTable:Decode(encodedData[i]))
		if test and test == serialized and #encodedData[i] < minLen then
			minLen = #encodedData[i]
			minIndex = i
		end
	end
	local minData = encodedData[minIndex]
	TempTable.Release(encodedData)
	assert(minData, "Could not compress packet")

	-- give heartbeats and rpc preambles a higher priority
	local priority = (dataType == Constants.DATA_TYPES.HEARTBEAT or dataType == Constants.DATA_TYPES.RPC_PREAMBLE) and "ALERT" or nil
	-- send the message
	Comm:SendCommMessage("TSMSyncData", minData, "WHISPER", targetCharacter, priority)
	return #minData
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnCommReceived(_, packet, _, sourceCharacter)
	-- delay the processing to make sure it happens within a debuggable context (this function is called via pcall)
	tinsert(private.queuedPacket, packet)
	tinsert(private.queuedSourceCharacter, sourceCharacter)
	Delay.AfterFrame("commReceiveQueue", 0, private.ProcessReceiveQueue)
end

function private.ProcessReceiveQueue()
	assert(#private.queuedPacket == #private.queuedSourceCharacter)
	while #private.queuedPacket > 0 do
		local packet = tremove(private.queuedPacket, 1)
		local sourceCharacter = tremove(private.queuedSourceCharacter, 1)
		private.ProcessReceivedPacket(packet, sourceCharacter)
	end
end

function private.ProcessReceivedPacket(packet, sourceCharacter)
	-- remove realm name from source player
	sourceCharacter = strsplit("-", sourceCharacter)
	sourceCharacter = strtrim(sourceCharacter)
	local sourceCharacterAccountKey = Settings.GetCharacterSyncAccountKey(sourceCharacter)
	if sourceCharacterAccountKey and sourceCharacterAccountKey == Settings.GetCurrentSyncAccountKey() then
		Log.Err("We own the source character")
		Settings.ShowSyncSVCopyError()
		return
	end

	-- decode and decompress
	packet = LibCompressAddonEncodeTable:Decode(packet)
	packet = packet and LibCompress:Decompress(packet)
	if type(packet) ~= "string" then
		Log.Err("Invalid packet")
		return
	end
	if strsub(packet, 1, 1) == "\240" then
		-- original data was a string, so we're done
		packet = strsub(packet, 2)
	else
		-- Deserialize
		local success
		success, packet = AceSerializer:Deserialize(packet)
		if not success or not packet then
			Log.Err("Invalid packet")
			return
		end
	end

	-- validate the packet
	local dataType, sourceAccount, version, data = nil, nil, nil, nil
	if type(packet) == "string" then
		-- if it's a string that means there was no data
		local _
		dataType, sourceAccount, _, version = (";"):split(packet)
		version = tonumber(version)
	else
		dataType = packet.dt
		sourceAccount = packet.sa
		version = packet.v
		data = packet.d
	end
	if type(dataType) ~= "string" or #dataType > 1 or not sourceAccount or version ~= Constants.VERSION then
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
		private.handler[dataType](dataType, sourceAccount, sourceCharacter, data)
	else
		Log.Info("Received unhandled message of type: "..strbyte(dataType))
	end
end
