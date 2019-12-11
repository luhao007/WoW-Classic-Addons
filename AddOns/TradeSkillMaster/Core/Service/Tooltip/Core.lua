-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Tooltip = TSM:NewPackage("Tooltip")
local L = TSM.Include("Locale").GetTable()
local ItemTooltip = TSM.Include("Service.ItemTooltip")
local Settings = TSM.Include("Service.Settings")
local private = {
	settings = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Tooltip.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "tooltipOptions", "moduleTooltips")
	ItemTooltip.RegisterCallback(TSM.Tooltip.General.LoadTooltip, L["TradeSkillMaster Info"], nil)
end

function Tooltip.Register(module, defaults, callback)
	private.settings.moduleTooltips[module] = private.settings.moduleTooltips[module] or defaults
	ItemTooltip.RegisterCallback(callback, "TSM "..module, private.settings.moduleTooltips[module])
end
