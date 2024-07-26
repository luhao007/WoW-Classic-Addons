-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMWoW = select(2, ...).LibTSMWoW
local ChatFrame = LibTSMWoW:Init("API.ChatFrame")
local private = {
	active = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

---Sets the active chat frame to add messages to.
---@param name string The name of the chat frame
function ChatFrame.SetActive(name)
	private.active = strlower(name)
end

---Adds a message to the active chat frame.
---@param str string The message
function ChatFrame.AddMessage(str)
	local frame = DEFAULT_CHAT_FRAME
	for i = 1, NUM_CHAT_WINDOWS do
		local name = strlower(GetChatWindowInfo(i) or "")
		if name ~= "" and name == private.active then
			frame = _G["ChatFrame" .. i]
			break
		end
	end
	frame:AddMessage(str)
end
