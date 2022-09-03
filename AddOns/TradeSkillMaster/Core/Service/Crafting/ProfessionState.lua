-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ProfessionState = TSM.Crafting:NewPackage("ProfessionState")
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local Log = TSM.Include("Util.Log")
local private = {
	fsm = nil,
	updateCallbacks = {},
	isClosed = true,
	craftOpen = nil,
	tradeSkillOpen = nil,
	professionName = nil,
}
local WAIT_FRAME_DELAY = 5



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionState.OnInitialize()
	private.CreateFSM()
end

function ProfessionState.RegisterUpdateCallback(callback)
	tinsert(private.updateCallbacks, callback)
end

function ProfessionState.GetIsClosed()
	return private.isClosed
end

function ProfessionState.IsClassicCrafting()
	return TSM.IsWowVanillaClassic() and private.craftOpen
end

function ProfessionState.SetCraftOpen(open)
	private.craftOpen = open
end

function ProfessionState.GetCurrentProfession()
	return private.professionName
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.CreateFSM()
	if TSM.IsWowClassic() and not IsAddOnLoaded("Blizzard_CraftUI") then
		LoadAddOn("Blizzard_CraftUI")
	end
	Event.Register("TRADE_SKILL_SHOW", function()
		private.tradeSkillOpen = true
		private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
		private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGING")
		private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGED")
	end)
	Event.Register("TRADE_SKILL_CLOSE", function()
		private.tradeSkillOpen = false
		if not private.craftOpen then
			private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSE")
		end
	end)
	if not TSM.IsWowClassic() then
		Event.Register("GARRISON_TRADESKILL_NPC_CLOSED", function()
			private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSE")
		end)
		Event.Register("TRADE_SKILL_DATA_SOURCE_CHANGED", function()
			private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGED")
		end)
		Event.Register("TRADE_SKILL_DATA_SOURCE_CHANGING", function()
			private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGING")
		end)
	else
		Event.Register("CRAFT_SHOW", function()
			private.craftOpen = true
			private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
			private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGING")
			private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGED")
		end)
		Event.Register("CRAFT_CLOSE", function()
			private.craftOpen = false
			if not private.tradeSkillOpen then
				private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSE")
			end
		end)
		Event.Register("CRAFT_UPDATE", function()
			private.fsm:ProcessEvent("EV_TRADE_SKILL_DATA_SOURCE_CHANGED")
		end)
	end
	local function ToggleDefaultCraftButton()
		if not CraftCreateButton then
			return
		end
		if private.craftOpen then
			CraftCreateButton:Show()
		else
			CraftCreateButton:Hide()
		end
	end
	local function FrameDelayCallback()
		private.fsm:ProcessEvent("EV_FRAME_DELAY")
	end
	private.fsm = FSM.New("PROFESSION_STATE")
		:AddState(FSM.NewState("ST_CLOSED")
			:SetOnEnter(function()
				private.isClosed = true
				private.RunUpdateCallbacks()
			end)
			:SetOnExit(function()
				private.isClosed = false
				private.RunUpdateCallbacks()
			end)
			:AddTransition("ST_WAITING_FOR_DATA")
			:AddEventTransition("EV_TRADE_SKILL_SHOW", "ST_WAITING_FOR_DATA")
		)
		:AddState(FSM.NewState("ST_WAITING_FOR_DATA")
			:AddTransition("ST_WAITING_FOR_READY")
			:AddTransition("ST_CLOSED")
			:AddEventTransition("EV_TRADE_SKILL_DATA_SOURCE_CHANGED", "ST_WAITING_FOR_READY")
			:AddEventTransition("EV_TRADE_SKILL_CLOSE", "ST_CLOSED")
		)
		:AddState(FSM.NewState("ST_WAITING_FOR_READY")
			:SetOnEnter(function()
				Delay.AfterFrame("PROFESSION_STATE_TIME", WAIT_FRAME_DELAY, FrameDelayCallback, WAIT_FRAME_DELAY)
			end)
			:SetOnExit(function()
				Delay.Cancel("PROFESSION_STATE_TIME")
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_DATA_CHANGING")
			:AddTransition("ST_CLOSED")
			:AddEvent("EV_FRAME_DELAY", function()
				if TSM.Crafting.ProfessionUtil.IsDataStable() then
					return "ST_SHOWN"
				end
			end)
			:AddEventTransition("EV_TRADE_SKILL_DATA_SOURCE_CHANGING", "ST_DATA_CHANGING")
			:AddEventTransition("EV_TRADE_SKILL_CLOSE", "ST_CLOSED")
		)
		:AddState(FSM.NewState("ST_SHOWN")
			:SetOnEnter(function()
				local name = TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()
				assert(name)
				Log.Info("Showing profession: %s", name)
				private.professionName = name
				if TSM.IsWowVanillaClassic() then
					ToggleDefaultCraftButton()
				end
				private.RunUpdateCallbacks()
			end)
			:SetOnExit(function()
				private.professionName = nil
				private.RunUpdateCallbacks()
			end)
			:AddTransition("ST_DATA_CHANGING")
			:AddTransition("ST_CLOSED")
			:AddEventTransition("EV_TRADE_SKILL_DATA_SOURCE_CHANGING", "ST_DATA_CHANGING")
			:AddEventTransition("EV_TRADE_SKILL_CLOSE", "ST_CLOSED")
		)
		:AddState(FSM.NewState("ST_DATA_CHANGING")
			:AddTransition("ST_WAITING_FOR_READY")
			:AddTransition("ST_CLOSED")
			:AddEventTransition("EV_TRADE_SKILL_DATA_SOURCE_CHANGED", "ST_WAITING_FOR_READY")
			:AddEventTransition("EV_TRADE_SKILL_CLOSE", "ST_CLOSED")
		)
		:Init("ST_CLOSED")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RunUpdateCallbacks()
	for _, callback in ipairs(private.updateCallbacks) do
		callback(private.professionName)
	end
end
