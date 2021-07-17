-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Constants = TSM.Init("Service.SyncClasses.Constants")
Constants.VERSION = 13
Constants.DATA_TYPES = {
	-- new connection types (40-49)
	WHOAMI_ACCOUNT = strchar(40),
	WHOAMI_ACK = strchar(41),
	-- connection status types (50-69)
	CONNECTION_REQUEST = strchar(50),
	CONNECTION_REQUEST_ACK = strchar(51),
	DISCONNECT = strchar(52),
	HEARTBEAT = strchar(53),
	-- data mirroring types (70-99)
	CHARACTER_HASHES_BROADCAST = strchar(70),
	CHARACTER_SETTING_HASHES_REQUEST = strchar(71),
	CHARACTER_SETTING_HASHES_RESPONSE = strchar(72),
	CHARACTER_SETTING_DATA_REQUEST = strchar(73),
	CHARACTER_SETTING_DATA_RESPONSE = strchar(74),
	-- RPC types (100-109)
	RPC_CALL = strchar(100),
	RPC_RETURN = strchar(101),
	RPC_PREAMBLE = strchar(102),
}
