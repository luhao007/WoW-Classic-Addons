-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local ThreadingManager = TSM.Init("Service.ThreadingManager")
local ErrorHandler = TSM.LibTSMService:Include("Debug.ErrorHandler")
local Threading = TSM.LibTSMTypes:Include("Threading")
local ClientInfo = TSM.LibTSMWoW:Include("Util.ClientInfo")
local Log = TSM.LibTSMUtil:Include("Util.Log")
local private = {
	schedulerFrame = nil,
}
local MAX_TIME_USAGE_RATIO = 0.25
local MAX_QUANTUM = 0.01



-- ============================================================================
-- Module Loading
-- ============================================================================

ThreadingManager:OnModuleLoad(function()
	local function EventRegisterFunc(eventName)
		private.schedulerFrame:RegisterEvent(eventName)
	end
	local function SchedulerShouldRunFunc(shouldRun)
		if shouldRun then
			private.schedulerFrame:Show()
		else
			private.schedulerFrame:Hide()
		end
	end
	Threading.Configure(ErrorHandler.ShowForThread, EventRegisterFunc, SchedulerShouldRunFunc)
end)



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ProcessStartStop()
	if private.schedulerFrame:IsVisible() then
		Log.Info("Starting the scheduler")
	else
		Log.Info("Stopped the scheduler")
	end
end

function private.RunScheduler(_, elapsed)
	-- Don't run the scheduler while in combat
	if ClientInfo.IsInCombat() then
		return
	end
	Threading.RunScheduler(min(elapsed * MAX_TIME_USAGE_RATIO, MAX_QUANTUM))
end

function private.ProcessEvent(_, event, ...)
	Threading.HandleEvent(event, ...)
end



-- ============================================================================
-- Driver Frame
-- ============================================================================

do
	private.schedulerFrame = CreateFrame("Frame")
	private.schedulerFrame:Hide()
	private.schedulerFrame:SetScript("OnUpdate", private.RunScheduler)
	private.schedulerFrame:SetScript("OnEvent", private.ProcessEvent)
	private.schedulerFrame:SetScript("OnShow", private.ProcessStartStop)
	private.schedulerFrame:SetScript("OnHide", private.ProcessStartStop)
end
