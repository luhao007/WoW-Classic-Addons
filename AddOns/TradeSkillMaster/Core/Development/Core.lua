-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
-- only create the TSMDEV table if we're in a dev or test environment
if not TSM.IsDevVersion() and not TSM.IsTestEnvironment() then
	return
end
TSMDEV = {}



-- ============================================================================
-- Global TSMDEV Functions
-- ============================================================================

function TSMDEV.Dump(value)
	LoadAddOn("Blizzard_DebugTools")
	DevTools_Dump(value)
end
