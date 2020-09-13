-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mailing = TSM:NewPackage("Mailing")
local Event = TSM.Include("Util.Event")
local private = {
	mailOpen = false,
	frameCallbacks = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mailing.OnInitialize()
	Event.Register("MAIL_SHOW", private.MailShow)
	Event.Register("MAIL_CLOSED", private.MailClosed)
end

function Mailing.RegisterFrameCallback(callback)
	tinsert(private.frameCallbacks, callback)
end

function Mailing.IsOpen()
	return private.mailOpen
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MailShow()
	private.mailOpen = true
	for _, callback in ipairs(private.frameCallbacks) do
		callback(true)
	end
end

function private.MailClosed()
	if not private.mailOpen then
		return
	end
	private.mailOpen = false
	for _, callback in ipairs(private.frameCallbacks) do
		callback(false)
	end
end
