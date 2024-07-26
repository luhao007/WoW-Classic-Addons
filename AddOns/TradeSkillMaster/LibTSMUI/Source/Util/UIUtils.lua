-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUI = select(2, ...).LibTSMUI
local L = LibTSMUI.Locale.GetTable()
local UIUtils = LibTSMUI:Init("Util.UIUtils")
local Analytics = LibTSMUI:From("LibTSMUtil"):Include("Util.Analytics")
local Item = LibTSMUI:From("LibTSMWoW"):Include("API.Item")
local TradeSkill = LibTSMUI:From("LibTSMWoW"):Include("API.TradeSkill")
local ItemInfo = LibTSMUI:From("LibTSMService"):Include("Item.ItemInfo")
local Theme = LibTSMUI:From("LibTSMService"):Include("UI.Theme")
local private = {
	analyticsPath = {},
}
local TIME_LEFT_STRINGS = {}
do
	-- Set the TIME_LEFT_STRINGS values
	local colors = {
		Theme.GetColor("FEEDBACK_RED"),
		Theme.GetColor("FEEDBACK_RED"),
		Theme.GetColor("FEEDBACK_YELLOW"),
		Theme.GetColor("FEEDBACK_GREEN"),
	}
	local hours = {}
	if LibTSMUI.IsRetail() then
		hours = { 1, 2, 24, 48 }
	else
		hours = { 0.5, 2, 8, 24 }
	end
	assert(#hours == #colors)
	for i, color in ipairs(colors) do
		local hourValue = hours[i]
		if hourValue >= 1 then
			TIME_LEFT_STRINGS[i] = color:ColorText(format(L["%dh"], hourValue))
		else
			TIME_LEFT_STRINGS[i] = color:ColorText(format(L["%dm"], hourValue * 60))
		end
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

---Gets an item name formatted for display.
---@param item string The item to display
---@param tintPct? number The tintPct to apply to the quality color
function UIUtils.GetDisplayItemName(item, tintPct)
	local name = ItemInfo.GetName(item)
	local quality = ItemInfo.GetQuality(item)
	local craftedQuality = ItemInfo.GetCraftedQuality(item)
	return UIUtils.GetQualityColoredText(name, quality, craftedQuality, tintPct)
end

---Colors text based on an item quality.
---@param name string The name of the item
---@param quality number The quality of the item
---@param craftedQuality? number The crafted quality of the item
---@param tintPct? number The tintPct to apply to the quality color
---@return string
function UIUtils.GetQualityColoredText(name, quality, craftedQuality, tintPct)
	if not name or not quality then
		return
	end
	local color = Theme.GetItemQualityColor(quality)
	local result = color:GetTint(tintPct or 0):ColorText(name)
	local craftedQualityIcon = craftedQuality and TradeSkill.GetCraftedQualityChatIcon(craftedQuality)
	if craftedQualityIcon then
		result = result.." "..craftedQualityIcon
	end
	return result
end

---Gets the localized string representation of an auction time left.
---@param timeLeft number The time left index (i.e. from WoW APIs)
---@return string
function UIUtils.GetTimeLeftString(timeLeft)
	local str = TIME_LEFT_STRINGS[timeLeft]
	assert(str, "Invalid timeLeft: "..tostring(timeLeft))
	return str
end

---Registers a UI for analytics tracking.
---@param uiName string The name of the UI
function UIUtils.RegisterUIForAnalytics(uiName)
	assert(not private.analyticsPath[uiName])
	private.analyticsPath[uiName] = ""
end

---Logs an analytics action for the UI path changing.
---@param uiName string The name of the UI
---@param ... string The extra path components
function UIUtils.AnalyticsRecordPathChange(uiName, ...)
	assert(private.analyticsPath[uiName])
	local path = strjoin("/", uiName, ...)
	if path == private.analyticsPath[uiName] then
		return
	end
	Analytics.Action("UI_NAVIGATION", private.analyticsPath[uiName], path)
	private.analyticsPath[uiName] = path
end

---Logs an analytics action for a UI being closed.
---@param uiName string The name of the UI
function UIUtils.AnalyticsRecordClose(uiName)
	assert(private.analyticsPath[uiName])
	if private.analyticsPath[uiName] == "" then
		return
	end
	Analytics.Action("UI_NAVIGATION", private.analyticsPath[uiName], "")
	private.analyticsPath[uiName] = ""
end

---Handles a modified item click from a UI.
---@param itemString string The itemString for the item which was clicked on
function UIUtils.HandleModifiedItemClick(itemString)
	local link = ItemInfo.GetLink(itemString)
	if not link then
		return
	end
	Item.HandleModifiedItemClick(link)
end
