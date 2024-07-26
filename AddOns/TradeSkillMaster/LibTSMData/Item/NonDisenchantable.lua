-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMData = select(2, ...).LibTSMData
local NonDisenchantable = LibTSMData:Init("NonDisenchantable")



-- ============================================================================
-- All Game Versions
-- ============================================================================

-- URLs for non-disenchantable items:
-- 	http://www.wowhead.com/items=2?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
-- 	http://www.wowhead.com/items=4?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
NonDisenchantable.All = {
	["i:11287"] = true,
	["i:11288"] = true,
	["i:11289"] = true,
	["i:11290"] = true,
	["i:20406"] = true,
	["i:20407"] = true,
	["i:20408"] = true,
	["i:21766"] = true,
	["i:52252"] = true,
	["i:52485"] = true,
	["i:52486"] = true,
	["i:52487"] = true,
	["i:52488"] = true,
	["i:60223"] = true,
	["i:75274"] = true,
	["i:84661"] = true,
	["i:89586"] = true,
	["i:97826"] = true,
	["i:97827"] = true,
	["i:97828"] = true,
	["i:97829"] = true,
	["i:97830"] = true,
	["i:97831"] = true,
	["i:97832"] = true,
	["i:109262"] = true,
	["i:186056"] = true,
	["i:186058"] = true,
	["i:186163"] = true,
}
