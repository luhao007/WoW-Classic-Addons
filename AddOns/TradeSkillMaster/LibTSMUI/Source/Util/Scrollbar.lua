-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUI = select(2, ...).LibTSMUI
local Scrollbar = LibTSMUI:Init("Util.Scrollbar")
local WidgetExtensions = LibTSMUI:Include("Util.WidgetExtensions")
local Theme = LibTSMUI:From("LibTSMService"):Include("UI.Theme")
local private = {
	scrollbars = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Scrollbar:OnModuleLoad(function()
	Theme.RegisterChangeCallback(private.OnThemeChange)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Creates a scrollbar.
---@param parent Frame The parent frame
---@param isHorizontal boolean Whether the scrollbar is horizontal or not (vertical)
---@param cancellables? table The cancellables table to use
---@return SliderExtended
function Scrollbar.Create(parent, isHorizontal, cancellables)
	local scrollbar = WidgetExtensions.CreateSlider(parent)
	if cancellables then
		scrollbar:TSMSetCancellablesTable(cancellables)
	end
	scrollbar:ClearAllPoints()
	if isHorizontal then
		scrollbar:SetOrientation("HORIZONTAL")
		scrollbar:SetPoint("BOTTOMLEFT", 4, 0)
		scrollbar:SetPoint("BOTTOMRIGHT", -4, 0)
		scrollbar:SetHitRectInsets(-4, -4, -6, -10)
		scrollbar:SetHeight(Theme.GetScrollbarWidth())
		scrollbar:SetPoint("BOTTOMLEFT", Theme.GetScrollbarMargin(), Theme.GetScrollbarMargin())
		scrollbar:SetPoint("BOTTOMRIGHT", -Theme.GetScrollbarMargin(), Theme.GetScrollbarMargin())
	else
		scrollbar:SetOrientation("VERTICAL")
		scrollbar:SetHitRectInsets(-6, -10, -4, -4)
		scrollbar:SetWidth(Theme.GetScrollbarWidth())
		scrollbar:SetPoint("TOPRIGHT", -Theme.GetScrollbarMargin(), -Theme.GetScrollbarMargin())
		scrollbar:SetPoint("BOTTOMRIGHT", -Theme.GetScrollbarMargin(), Theme.GetScrollbarMargin())
	end
	scrollbar:SetValueStep(1)
	scrollbar:SetObeyStepOnDrag(true)
	scrollbar:TSMSetScript("OnShow", private.ScrollbarOnLeave)
	scrollbar:TSMSetScript("OnHide", private.ScrollbarOnMouseUp)
	scrollbar:TSMSetScript("OnUpdate", private.ScrollbarOnUpdate)
	scrollbar:TSMSetScript("OnEnter", private.ScrollbarOnEnter)
	scrollbar:TSMSetScript("OnLeave", private.ScrollbarOnLeave)
	scrollbar:TSMSetScript("OnMouseDown", private.ScrollbarOnMouseDown)
	scrollbar:TSMSetScript("OnMouseUp", private.ScrollbarOnMouseUp)

	scrollbar:TSMCreateThumbTexture("ACTIVE_BG_ALT")
	tinsert(private.scrollbars, scrollbar)

	return scrollbar
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ScrollbarOnUpdate(scrollbar)
	scrollbar:SetFrameLevel(scrollbar:GetParent():GetFrameLevel() + 5)
end

function private.ScrollbarOnEnter(scrollbar)
	scrollbar:TSMSetThumbColorTexture("ACTIVE_BG_ALT+SELECTED_HOVER")
end

function private.ScrollbarOnLeave(scrollbar)
	scrollbar:TSMSetThumbColorTexture("ACTIVE_BG_ALT")
end

function private.ScrollbarOnMouseDown(scrollbar)
	scrollbar.dragging = true
end

function private.ScrollbarOnMouseUp(scrollbar)
	scrollbar.dragging = nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnThemeChange()
	for _, scrollbar in ipairs(private.scrollbars) do
		scrollbar:TSMSetThumbColorTexture("ACTIVE_BG_ALT")
	end
end
