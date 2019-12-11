-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SlashCommands = TSM.Init("Service.SlashCommands")
local Log = TSM.Include("Util.Log")
local L = TSM.Include("Locale").GetTable()
local private = {
	commandInfo = {},
	commandOrder = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

SlashCommands:OnModuleLoad(function()
	-- register the TSM slash commands
	SlashCmdList["TSM"] = private.OnChatCommand
	SlashCmdList["TRADESKILLMASTER"] = private.OnChatCommand
	_G["SLASH_TSM1"] = "/tsm"
	_G["SLASH_TRADESKILLMASTER1"] = "/tradeskillmaster"
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function SlashCommands.Register(key, callback, label)
	assert(key and callback)
	local keyLower = strlower(key)
	private.commandInfo[keyLower] = {
		key = key,
		label = label,
		callback = callback,
	}
	tinsert(private.commandOrder, keyLower)
end

function SlashCommands.PrintHelp()
	Log.PrintUser(L["Slash Commands:"])
	for _, key in ipairs(private.commandOrder) do
		local info = private.commandInfo[key]
		if info.label then
			if info.key == "" then
				Log.PrintfUserRaw("|cffffaa00/tsm|r - %s", info.label)
			else
				Log.PrintfUserRaw("|cffffaa00/tsm %s|r - %s", info.key, info.label)
			end
		end
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.OnChatCommand(input)
	local cmd, args = strmatch(strtrim(input), "^([^ ]*) ?(.*)$")
	cmd = strlower(cmd)
	if private.commandInfo[cmd] then
		private.commandInfo[cmd].callback(args)
	else
		-- We weren't able to handle this command so print out the help
		SlashCommands.PrintHelp()
	end
end
