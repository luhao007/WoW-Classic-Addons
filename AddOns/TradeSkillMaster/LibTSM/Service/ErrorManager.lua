-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local ErrorManager = TSM.Init("Service.ErrorManager")
local ErrorHandler = TSM.LibTSMService:Include("Debug.ErrorHandler")
local ErrorFrame = TSM.LibTSMUI:IncludeClassType("ErrorFrame")
local private = {
	errorFrame = nil
}



-- ============================================================================
-- Module Functions
-- ============================================================================

ErrorManager:OnModuleLoad(function()
	ErrorHandler.ConfigureUI(private.ShowUI, private.HideUI)
end)



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ShowUI(errorStr, errorInfo, fullErrorInfo, isManual)
	private.errorFrame = private.errorFrame or ErrorFrame.Create()
	private.errorFrame:Show(errorStr, errorInfo, fullErrorInfo, isManual)
end

function private.HideUI()
	if not private.errorFrame then
		return
	end
	private.errorFrame:Hide()
end
