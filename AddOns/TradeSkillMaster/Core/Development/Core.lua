-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

-- only create the TSMDEV table if we're in a dev or test environment
local version = GetAddOnMetadata("TradeSkillMaster", "Version")
if not strmatch(version, "^@tsm%-project%-version@$") and version ~= "v4.99.99" then
	return
end

TSMDEV = {}

function TSMDEV.Dump(value)
	LoadAddOn("Blizzard_DebugTools")
	DevTools_Dump(value)
end
