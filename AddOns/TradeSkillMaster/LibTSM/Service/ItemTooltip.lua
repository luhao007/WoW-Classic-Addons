-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ItemTooltip = TSM.Init("Service.ItemTooltip")
local Builder = TSM.Include("Service.ItemTooltipClasses.Builder")



-- ============================================================================
-- Module Functions
-- ============================================================================

function ItemTooltip.RegisterCallback(callback, headingTextLeft, context)
	Builder.RegisterInfo(callback, headingTextLeft, context)
end
