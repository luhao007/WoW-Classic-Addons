-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- UI Functions
-- @module UI

local _, TSM = ...
local UI = TSM:NewPackage("UI")
local Analytics = TSM.Include("Util.Analytics")
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	analyticsPath = {
		auction = "",
		banking = "",
		crafting = "",
		destroying = "",
		mailing = "",
		main = "",
		task_list = "",
		vendoring = "",
	},
}
local TIME_LEFT_STRINGS = {}
do
	-- generate the TIME_LEFT_STRINGS values
	local colors = {
		Theme.GetFeedbackColor("RED"),
		Theme.GetFeedbackColor("RED"),
		Theme.GetFeedbackColor("YELLOW"),
		Theme.GetFeedbackColor("GREEN"),
	}
	local strs = TSM.IsWowClassic() and { "30m", "2h", "8h", "24h" } or { "1h", "2h", "24h", "48h" }
	assert(#colors == #strs)
	for i = 1, #colors do
		TIME_LEFT_STRINGS[i] = colors[i]:ColorText(strs[i])
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Colors an item name based on its quality.
-- @tparam string item The item to retrieve the name and quality of
-- @tparam[opt=0] number tintPct The tintPct to apply to the quality color
-- @treturn string The colored name
function UI.GetColoredItemName(item, tintPct)
	local name = ItemInfo.GetName(item)
	local quality = ItemInfo.GetQuality(item)
	return UI.GetQualityColoredText(name, quality, tintPct)
end

--- Colors an item name based on its quality.
-- @tparam string name The name of the item
-- @tparam number quality The quality of the item
-- @tparam[opt=0] number tintPct The tintPct to apply to the quality color
-- @treturn string The colored name
function UI.GetQualityColoredText(name, quality, tintPct)
	if not name or not quality then
		return
	end
	local color = Theme.GetItemQualityColor(quality)
	return color:GetTint(tintPct or 0):ColorText(name)
end

--- Gets the string representation of an auction time left.
-- @tparam number timeLeft The time left index (i.e. from WoW APIs)
-- @treturn string The localized string representation
function UI.GetTimeLeftString(timeLeft)
	local str = TIME_LEFT_STRINGS[timeLeft]
	assert(str, "Invalid timeLeft: "..tostring(timeLeft))
	return str
end

function UI.AnalyticsRecordPathChange(uiName, ...)
	assert(private.analyticsPath[uiName])
	local path = strjoin("/", uiName, ...)
	if path == private.analyticsPath[uiName] then
		return
	end
	Analytics.Action("UI_NAVIGATION", private.analyticsPath[uiName], path)
	private.analyticsPath[uiName] = path
end

function UI.AnalyticsRecordClose(uiName)
	assert(private.analyticsPath[uiName])
	if private.analyticsPath[uiName] == "" then
		return
	end
	Analytics.Action("UI_NAVIGATION", private.analyticsPath[uiName], "")
	private.analyticsPath[uiName] = ""
end
