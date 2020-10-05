-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sync = TSM.Init("Service.Sync")
local Connection = TSM.Include("Service.SyncClasses.Connection")
local RPC = TSM.Include("Service.SyncClasses.RPC")
local Mirror = TSM.Include("Service.SyncClasses.Mirror")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Sync.RegisterConnectionChangedCallback(callback)
	Connection.RegisterConnectionChangedCallback(callback)
end

function Sync.RegisterRPC(name, func)
	RPC.Register(name, func)
end

function Sync.CallRPC(name, targetPlayer, handler, ...)
	return RPC.Call(name, targetPlayer, handler, ...)
end

function Sync.GetConnectionStatus(account)
	return Connection.GetStatus(account)
end

function Sync.GetConnectedCharacterByAccount(account)
	return Connection.GetConnectedCharacterByAccount(account)
end

function Sync.GetMirrorStatus(account)
	return Mirror.GetStatus(account)
end

function Sync.RegisterMirrorCallback(callback)
	Mirror.RegisterCallback(callback)
end

function Sync.EstablishConnection(character)
	return Connection.Establish(character)
end

function Sync.GetNewAccountStatus()
	return Connection.GetNewAccountStatus()
end

function Sync.RemoveAccount(account)
	Connection.Remove(account)
end
