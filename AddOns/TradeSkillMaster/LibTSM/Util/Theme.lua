-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Theme Functions.
-- @module Theme

local _, TSM = ...
local Theme = TSM.Init("Util.Theme")
local FontPaths = TSM.Include("Data.FontPaths")
local Color = TSM.Include("Util.Color")
local Table = TSM.Include("Util.Table")
local FontObject = TSM.Include("Util.FontObject")
local private = {
	callbacks = {},
	names = {},
	colorSets = {},
	currentColorSet = nil,
	fontFrame = nil,
	currentFontSet = nil,
}
local THEME_COLOR_KEYS = {
	"PRIMARY_BG",
	"PRIMARY_BG_ALT",
	"FRAME_BG",
	"ACTIVE_BG",
	"ACTIVE_BG_ALT",
}
local VALID_THEME_COLOR_KEYS = {}
do
	for _, key in ipairs(THEME_COLOR_KEYS) do
		VALID_THEME_COLOR_KEYS[key] = true
	end
end
local STATIC_COLORS = {
	INDICATOR = Color.NewFromHex("#ffd839"),
	INDICATOR_ALT = Color.NewFromHex("#79a2ff"),
	INDICATOR_DISABLED = Color.NewFromHex("#6f5819"),

	TEXT = Color.NewFromHex("#ffffff"),
	TEXT_ALT = Color.NewFromHex("#e2e2e2"),
	TEXT_DISABLED = Color.NewFromHex("#424242"),
}
local FEEDBACK_COLORS = {
	RED = Color.NewFromHex("#f72d20"),
	YELLOW = Color.NewFromHex("#e1f720"),
	GREEN = Color.NewFromHex("#4ff720"),
	BLUE = Color.NewFromHex("#2076f7"),
	ORANGE = Color.NewFromHex("#f77a20"),
}
local STANDARD_COLORS = {
	YELLOW = Color.NewFromHex("#ffff00"),
}
local BLIZZARD_COLOR = Color.NewFromHex("#00b4ff")
local GROUP_COLORS = {
	Color.NewFromHex("#fcf141"),
	Color.NewFromHex("#bdaec6"),
	Color.NewFromHex("#06a2cb"),
	Color.NewFromHex("#ffb85c"),
	Color.NewFromHex("#51b599"),
}
local PROFESSION_DIFFICULTY_COLORS = TSM.IsWowClassic() and {
		optimal = Color.NewFromHex("#ff8040"),
		medium = Color.NewFromHex("#ffff00"),
		easy = Color.NewFromHex("#40c040"),
		trivial = Color.NewFromHex("#808080"),
		header = Color.NewFromHex("#ffd100"),
		subheader = Color.NewFromHex("#ffd100"),
		nodifficulty = Color.NewFromHex("#f5f5f5"),
	} or {
		[Enum.TradeskillRelativeDifficulty.Optimal] = Color.NewFromHex("#ff8040"),
		[Enum.TradeskillRelativeDifficulty.Medium] = Color.NewFromHex("#ffff00"),
		[Enum.TradeskillRelativeDifficulty.Easy] = Color.NewFromHex("#40c040"),
		[Enum.TradeskillRelativeDifficulty.Trivial] = Color.NewFromHex("#808080"),
		header = Color.NewFromHex("#ffd100"),
		subheader = Color.NewFromHex("#ffd100"),
		nodifficulty = Color.NewFromHex("#f5f5f5"),
	}
-- NOTE: there is a global ITEM_QUALITY_COLORS so we need to use another name
local TSM_ITEM_QUALITY_COLORS = {
	[0] = Color.NewFromHex("#9d9d9d"),
	[1] = Color.NewFromHex("#ffffff"),
	[2] = Color.NewFromHex("#1eff00"),
	[3] = Color.NewFromHex("#0070dd"),
	[4] = Color.NewFromHex("#a334ee"),
	[5] = Color.NewFromHex("#ff8000"),
	[6] = Color.NewFromHex("#e6cc80"),
	[7] = Color.NewFromHex("#00ccff"),
	[8] = Color.NewFromHex("#00ccff"),
}
local AUCTION_PCT_COLORS = {
	{ -- blue
		color = "BLUE",
		value = 50,
	},
	{ -- green
		color = "GREEN",
		value = 80,
	},
	{ -- yellow
		color = "YELLOW",
		value = 110,
	},
	{ -- orange
		color = "ORANGE",
		value = 135,
	},
	{ -- red
		color = "RED",
		value = math.huge,
	},
	default = "TEXT",
	bid = "TEXT_ALT",
}
local CONSTANTS = {
	COL_SPACING = 8,
	SCROLLBAR_MARGIN = 4,
	SCROLLBAR_WIDTH = 4,
	MOUSE_WHEEL_SCROLL_AMOUNT = 60,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Theme:OnModuleLoad(function()
	Table.SetReadOnly(STATIC_COLORS)
	Table.SetReadOnly(FEEDBACK_COLORS)
	Table.SetReadOnly(GROUP_COLORS)
	Table.SetReadOnly(PROFESSION_DIFFICULTY_COLORS)
	Table.SetReadOnly(TSM_ITEM_QUALITY_COLORS)
	Table.SetReadOnly(CONSTANTS)

	-- create a frame to load fonts
	private.fontFrame = CreateFrame("Frame", nil, UIParent)
	private.fontFrame.texts = {}
	private.fontFrame:SetAllPoints()
	private.fontFrame:SetScript("OnUpdate", private.FontFrameOnUpdate)

	-- TODO: eventually allow for different font sets?
	private.currentFontSet = {
		HEADING_H5 = FontObject.New(FontPaths.GetBodyRegular(), 20, 28),
		BODY_BODY1 = FontObject.New(FontPaths.GetBodyRegular(), 16, 24),
		BODY_BODY1_BOLD = FontObject.New(FontPaths.GetBodyBold(), 16, 24),
		BODY_BODY2 = FontObject.New(FontPaths.GetBodyRegular(), 14, 20),
		BODY_BODY2_MEDIUM = FontObject.New(FontPaths.GetBodyMedium(), 14, 20),
		BODY_BODY2_BOLD = FontObject.New(FontPaths.GetBodyBold(), 14, 20),
		BODY_BODY3 = FontObject.New(FontPaths.GetBodyRegular(), 12, 20),
		BODY_BODY3_MEDIUM = FontObject.New(FontPaths.GetBodyMedium(), 12, 20),
		ITEM_BODY1 = FontObject.New(FontPaths.GetItem(), 16, 24),
		ITEM_BODY2 = FontObject.New(FontPaths.GetItem(), 14, 20),
		ITEM_BODY3 = FontObject.New(FontPaths.GetItem(), 12, 20),
		TABLE_TABLE1 = FontObject.New(FontPaths.GetTable(), 12, 20),
	}

	-- load the fonts
	for _, obj in pairs(private.currentFontSet) do
		local fontPath = obj:GetWowFont()
		private.QueueFontLoad(fontPath)
	end
end)


-- ============================================================================
-- Module Functions
-- ============================================================================

--- Registers a callback when the theme changes.
-- @tparam function callback The callback function
function Theme.RegisterChangeCallback(callback)
	assert(type(callback) == "function")
	tinsert(private.callbacks, callback)
end

--- Registers a new color set.
-- @tparam string key The key which represents the color set
-- @tparam string name The name of the color set
-- @tparam table colorSet The colors which make up the color set (with keys specified in `THEME_COLOR_KEYS`)
function Theme.RegisterColorSet(key, name, colorSet)
	assert(not private.colorSets[key])
	for _, k in ipairs(THEME_COLOR_KEYS) do
		assert(Color.IsInstance(colorSet[k]))
	end
	private.names[key] = name
	private.colorSets[key] = colorSet
end

--- Sets the active color set.
-- @tparam string key The key which represents the color set
function Theme.SetActiveColorSet(key)
	assert(private.colorSets[key])
	if private.currentColorSet == private.colorSets[key] then
		return
	end
	private.currentColorSet = private.colorSets[key]
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end

--- Replaces a specific color within a theme (for user-generated themes)
-- @tparam string colorSetKey The key of the color set to change
-- @tparam string colorKey The key of the color to change
-- @tparam number r The new red value (0-255)
-- @tparam number g The new green value (0-255)
-- @tparam number b The new blue value (0-255)
function Theme.UpdateColor(colorSetKey, colorKey, r, g, b)
	local colorSet = private.colorSets[colorSetKey]
	assert(VALID_THEME_COLOR_KEYS[colorKey] and colorSet)
	local color = colorSet[colorKey]
	assert(color)
	color:SetRGBA(r, g, b, 255)
	if colorSet == private.currentColorSet then
		for _, callback in ipairs(private.callbacks) do
			callback()
		end
	end
end

--- Gets the color object from the current active color set.
-- @tparam string key The key of the color to get
-- @tparam[opt=nil] string colorSet The key of the color set to get the color for (defaults to the active color set)
-- @treturn Color The color object
function Theme.GetColor(key, colorSetKey)
	local colorKey, tintPct, opacityPct = strmatch(key, "^([A-Z_]+)([%-%+]?[0-9A-Z_]*)%%?([0-9A-Z_]*)$")
	tintPct = tonumber(tintPct) or (tintPct ~= "" and tintPct or nil)
	opacityPct = tonumber(opacityPct) or (opacityPct ~= "" and opacityPct or nil)
	assert(colorKey)
	local color = nil
	if VALID_THEME_COLOR_KEYS[colorKey] then
		color = colorSetKey and private.colorSets[colorSetKey][colorKey] or private.currentColorSet[colorKey]
	else
		color = STATIC_COLORS[colorKey]
	end
	assert(color)
	if tintPct then
		color = color:GetTint(tintPct)
	end
	if opacityPct then
		color = color:GetOpacity(opacityPct)
	end
	return color
end

--- Gets the color object for a given feedback color key.
-- @tparam string key The key of the feedback color to get
-- @treturn Color The color object
function Theme.GetFeedbackColor(key)
	return FEEDBACK_COLORS[key]
end

--- Gets the color object for a given color key.
-- @tparam string key The key of the color to get
-- @treturn Color The color object
function Theme.GetStandardColor(key)
	return STANDARD_COLORS[key]
end

--- Gets the color object for Blizzard GMs.
-- @treturn Color The color object
function Theme.GetBlizzardColor()
	return BLIZZARD_COLOR
end

--- Gets the color object for a given group level.
-- @tparam number level The level of the group (1-based)
-- @treturn Color The color object
function Theme.GetGroupColor(level)
	level = ((level - 1) % #GROUP_COLORS) + 1
	return GROUP_COLORS[level]
end

function Theme.GetProfessionDifficultyColor(difficulty)
	return PROFESSION_DIFFICULTY_COLORS[difficulty]
end

function Theme.GetItemQualityColor(quality)
	return TSM_ITEM_QUALITY_COLORS[quality]
end

function Theme.GetAuctionPercentColor(pct)
	if pct == "BID" then
		return Theme.GetColor(AUCTION_PCT_COLORS.bid)
	end
	for _, info in ipairs(AUCTION_PCT_COLORS) do
		if pct < info.value then
			return Theme.GetFeedbackColor(info.color)
		end
	end
	return Theme.GetColor(AUCTION_PCT_COLORS.default)
end

--- Gets the font object from the current active font set.
-- @tparam string key The key of the font to get
-- @treturn FontObject The font object
function Theme.GetFont(key)
	local fontObj = private.currentFontSet[key]
	assert(fontObj)
	return fontObj
end

--- Gets the column spacing constant value.
-- @treturn number The column spacing
function Theme.GetColSpacing()
	return CONSTANTS.COL_SPACING
end

--- Gets the scrollbar margin constant value.
-- @treturn number The scrollbar margin
function Theme.GetScrollbarMargin()
	return CONSTANTS.SCROLLBAR_MARGIN
end

--- Gets the scrollbar width constant value.
-- @treturn number The scrollbar width
function Theme.GetScrollbarWidth()
	return CONSTANTS.SCROLLBAR_WIDTH
end

--- Gets the scrollbar width constant value.
-- @treturn number The scrollbar width
function Theme.GetMouseWheelScrollAmount()
	return CONSTANTS.MOUSE_WHEEL_SCROLL_AMOUNT
end

function Theme.ThemeColorKeyIterator()
	return ipairs(THEME_COLOR_KEYS)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.QueueFontLoad(path)
	if private.fontFrame.texts[path] then
		return
	end
	local fontString = private.fontFrame:CreateFontString()
	fontString:SetPoint("CENTER")
	fontString:SetWidth(10000)
	fontString:SetHeight(6)
	fontString:SetFont(path, 6, "")
	fontString:SetText("1")
	private.fontFrame.texts[path] = fontString
	private.fontFrame:Show()
end

function private.FontFrameOnUpdate(frame)
	for _, fontString in pairs(frame.texts) do
		if fontString:IsVisible() then
			assert(fontString:GetStringWidth() > 0, "Text not loaded: "..tostring(fontString:GetFont()))
			fontString:Hide()
		end
	end
	frame:Hide()
end
