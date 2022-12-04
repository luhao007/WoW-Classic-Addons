-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Line = TSM.UI.Views:NewPackage("Line") ---@class TSM.UI.Views.Line
local UIElements = TSM.Include("UI.UIElements")
local DEFAULT_LINE_THICKNESS = 2
local DEFAULT_COLOR = "ACTIVE_BG"



-- ============================================================================
-- Module Functions
-- ============================================================================

---Creates a new vertical line element.
---@param id string The id to assign to the element
---@return Texture @The element
function Line.NewVertical(id, lineThickness, color)
	return UIElements.New("Texture", id)
		:SetWidth(DEFAULT_LINE_THICKNESS)
		:SetColor(DEFAULT_COLOR)
end

---Creates a new horizontal line element.
---@param id string The id to assign to the element
---@return Texture @The element
function Line.NewHorizontal(id)
	return UIElements.New("Texture", id)
		:SetHeight(DEFAULT_LINE_THICKNESS)
		:SetColor(DEFAULT_COLOR)
end
