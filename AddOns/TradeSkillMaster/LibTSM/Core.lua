-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This is loaded before anything else and simply sets up the addon table

local _, TSM = ...
TSMAPI_FOUR = {}
local VERSION_RAW = GetAddOnMetadata("TradeSkillMaster", "Version")
local IS_DEV_VERSION = strmatch(VERSION_RAW, "^@tsm%-project%-version@$") and true or false
local private = {
	packages = {},
}



-- ============================================================================
-- Addon Object Functions
-- ============================================================================

function TSM.Init(path)
	assert(not private.packages[path])
	local package = {}
	private.packages[path] = package
	return package
end

function TSM.Include(path)
	local package = private.packages[path]
	assert(package)
	return package
end

function TSM.IsDevVersion()
	return IS_DEV_VERSION
end

function TSM.GetVersion()
	return IS_DEV_VERSION and "Dev" or VERSION_RAW
end
