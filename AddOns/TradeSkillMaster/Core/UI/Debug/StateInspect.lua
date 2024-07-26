-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local StateInspect = TSM.UI:NewPackage("StateInspect")
local State = TSM.LibTSMUtil:Include("Reactive.Type.State")



-- ============================================================================
-- Module Functions
-- ============================================================================

function StateInspect.Open()
	C_AddOns.LoadAddOn("Blizzard_DebugTools")
	DisplayTableInspectorWindow(State.GetDebugData())
end
