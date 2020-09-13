-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- FSM Functions.
-- @module FSM

local _, TSM = ...
local FSM = TSM.Init("Util.FSM")
local Machine = TSM.Include("Util.FSMClasses.Machine")
local State = TSM.Include("Util.FSMClasses.State")



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Create a new FSM.
-- @tparam string name The name of the FSM (for debugging purposes)
-- @treturn Machine The FSM object
function FSM.New(name)
	return Machine.Create(name)
end

--- Create a new FSM state.
-- @tparam string state The name of the state
-- @treturn State The State object
function FSM.NewState(state)
	return State.Create(state)
end
