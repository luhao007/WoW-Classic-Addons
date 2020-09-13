-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Util = TSM.UI:NewPackage("Util")
local L = TSM.Include("Locale").GetTable()
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local private = {}
local THEME_COLOR_SETS = {
	{
		key = "midnight",
		name = L["Midnight"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#000000"),
			PRIMARY_BG_ALT = Color.NewFromHex("#121212"),
			FRAME_BG = Color.NewFromHex("#232323"),
			ACTIVE_BG = Color.NewFromHex("#404046"),
			ACTIVE_BG_ALT = Color.NewFromHex("#a0a0a0"),
		},
	},
	{
		key = "duskwood",
		name = L["Duskwood"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#000000"),
			PRIMARY_BG_ALT = Color.NewFromHex("#2e2e2e"),
			FRAME_BG = Color.NewFromHex("#404040"),
			ACTIVE_BG = Color.NewFromHex("#585858"),
			ACTIVE_BG_ALT = Color.NewFromHex("#9d9d9d"),
		},
	},
	{
		key = "dalaran",
		name = L["Dalaran"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#15141f"),
			PRIMARY_BG_ALT = Color.NewFromHex("#262537"),
			FRAME_BG = Color.NewFromHex("#35334d"),
			ACTIVE_BG = Color.NewFromHex("#4a476c"),
			ACTIVE_BG_ALT = Color.NewFromHex("#958fd9"),
		},
	},
	{
		key = "swampOfSorrows",
		name = L["Swamp of Sorrows"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#151e1b"),
			PRIMARY_BG_ALT = Color.NewFromHex("#273430"),
			FRAME_BG = Color.NewFromHex("#364942"),
			ACTIVE_BG = Color.NewFromHex("#567551"),
			ACTIVE_BG_ALT = Color.NewFromHex("#B5B28C"),
		},
	},
	{
		key = "orgrimmar",
		name = L["Orgrimmar"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#120908"),
			PRIMARY_BG_ALT = Color.NewFromHex("#40221b"),
			FRAME_BG = Color.NewFromHex("#6F3A2F"),
			ACTIVE_BG = Color.NewFromHex("#A25B3E"),
			ACTIVE_BG_ALT = Color.NewFromHex("#E1D4C4"),
		},
	},
	{
		key = "stormwind",
		name = L["Stormwind"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#191a1a"),
			PRIMARY_BG_ALT = Color.NewFromHex("#2b3131"),
			FRAME_BG = Color.NewFromHex("#4C585C"),
			ACTIVE_BG = Color.NewFromHex("#6B7673"),
			ACTIVE_BG_ALT = Color.NewFromHex("#D9DCD3"),
		},
	},
	{
		key = "winamp",
		name = L["Winamp"],
		colors = {
			PRIMARY_BG = Color.NewFromHex("#000000"),
			PRIMARY_BG_ALT = Color.NewFromHex("#1B1B2A"),
			FRAME_BG = Color.NewFromHex("#383858"),
			ACTIVE_BG = Color.NewFromHex("#6a6a7a"),
			ACTIVE_BG_ALT = Color.NewFromHex("#bdced6"),
		},
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Util.OnInitialize()
	-- register themes
	local foundCurrentColorSet = false
	for _, info in ipairs(THEME_COLOR_SETS) do
		Theme.RegisterColorSet(info.key, info.name, info.colors)
		foundCurrentColorSet = foundCurrentColorSet or info.key == TSM.db.global.appearanceOptions.colorSet
	end
	if not foundCurrentColorSet then
		TSM.db.global.appearanceOptions.colorSet = TSM.db:GetDefaultReadOnly("global", "appearanceOptions", "colorSet")
	end
	Theme.SetActiveColorSet(TSM.db.global.appearanceOptions.colorSet)
end

function Util.ColorSetIterator()
	return private.ColorSetIterator, THEME_COLOR_SETS, 0
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ColorSetIterator(tbl, index)
	index = index + 1
	if not tbl[index] then
		return
	end
	return index, tbl[index].key, tbl[index].name
end
