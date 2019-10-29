-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- only create the TSMDEV table if we're in a dev environment
if strmatch(GetAddOnMetadata("TradeSkillMaster", "Version"), "^@tsm%-project%-version@$") then
	TSMDEV = {}
end
