-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- only create the TSMDEV table if we're in a dev or test environment
local version = GetAddOnMetadata("TradeSkillMaster", "Version")
if strmatch(version, "^@tsm%-project%-version@$") or version == "v4.99.99" then
	TSMDEV = {}
end
