-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Scrollbar Functions
-- @module Scrollbar

local _, TSM = ...
local Scrollbar = TSM.UI:NewPackage("Scrollbar")
local Math = TSM.Include("Util.Math")
local Theme = TSM.Include("Util.Theme")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local private = {
	scrollbars = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Scrollbar.OnInitialize()
	Theme.RegisterChangeCallback(private.OnThemeChange)
end

--- Creates a scrollbar.
-- @return The newly-created scrollbar
function Scrollbar.Create(parent, isHorizontal)
	local scrollbar = CreateFrame("Slider", nil, parent, nil)
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
	ScriptWrapper.Set(scrollbar, "OnShow", private.ScrollbarOnLeave)
	ScriptWrapper.Set(scrollbar, "OnHide", private.ScrollbarOnMouseUp)
	ScriptWrapper.Set(scrollbar, "OnUpdate", private.ScrollbarOnUpdate)
	ScriptWrapper.Set(scrollbar, "OnEnter", private.ScrollbarOnEnter)
	ScriptWrapper.Set(scrollbar, "OnLeave", private.ScrollbarOnLeave)
	ScriptWrapper.Set(scrollbar, "OnMouseDown", private.ScrollbarOnMouseDown)
	ScriptWrapper.Set(scrollbar, "OnMouseUp", private.ScrollbarOnMouseUp)

	scrollbar:SetThumbTexture(scrollbar:CreateTexture())
	scrollbar.thumb = scrollbar:GetThumbTexture()
	scrollbar.thumb:SetPoint("CENTER")
	scrollbar.thumb:SetColorTexture(Theme.GetColor("ACTIVE_BG_ALT"):GetFractionalRGBA())
	if isHorizontal then
		scrollbar.thumb:SetHeight(Theme.GetScrollbarWidth())
	else
		scrollbar.thumb:SetWidth(Theme.GetScrollbarWidth())
	end
	tinsert(private.scrollbars, scrollbar)

	return scrollbar
end

function Scrollbar.GetLength(contentLength, visibleLength)
	-- arbitrary minimum length
	local minLength = 25
	-- the maximum length of the scrollbar is half the total visible length
	local maxLength = visibleLength / 2
	if minLength >= maxLength or visibleLength >= contentLength then
		return maxLength
	end

	-- calculate the ratio of our total content length to the visible length (capped at 10)
	local ratio = min(contentLength / visibleLength, 10)
	assert(ratio >= 1)

	-- calculate the appropriate scroll bar length based on the ratio (which is between 1 and 10)
	return Math.Scale(ratio, 1, 10, maxLength, minLength)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ScrollbarOnUpdate(scrollbar)
	scrollbar:SetFrameLevel(scrollbar:GetParent():GetFrameLevel() + 5)
end

function private.ScrollbarOnEnter(scrollbar)
	scrollbar.thumb:SetColorTexture(Theme.GetColor("ACTIVE_BG_ALT+SELECTED_HOVER"):GetFractionalRGBA())
end

function private.ScrollbarOnLeave(scrollbar)
	scrollbar.thumb:SetColorTexture(Theme.GetColor("ACTIVE_BG_ALT"):GetFractionalRGBA())
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
		scrollbar.thumb:SetColorTexture(Theme.GetColor("ACTIVE_BG_ALT"):GetFractionalRGBA())
	end
end
