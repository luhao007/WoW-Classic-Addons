--[===[ File
This file contains the global variables and constants used throughout Titan Panel.

Titan_Global is intended to reduce the global namespace through out Titan over time.
All variables in Global_Titan should be declared here even if set elsewhere.
--]===]

---@meta
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)

-- Global variables

Titan_Global = {}                -- begin the slow journey to a smaller _G footprint

Titan_Global.recent_changes = "" -- Titan_History.lua
Titan_Global.config_notes = ""   -- Titan_History.lua

Titan_Global.AdjList = {         -- TODO : localize
	["UIWidgetTopCenterContainerFrame"] = {
		frame_name = "UIWidgetTopCenterContainerFrame",
		purpose = "Status for BG / Dungeon",
	},
}

TITAN_PANEL_DEBUG_ARRAY_MAX = 100
TITAN_PANEL_NONMOVABLE_PLUGINS = {};
TITAN_PANEL_MENU_FUNC_HIDE = "TitanPanelRightClickMenu_Hide";
TitanPlugins = {}; -- Used by plugins
TitanPluginsIndex = {};
TITAN_NOT_REGISTERED = _G["RED_FONT_COLOR_CODE"] .. "Not_Registered_Yet" .. _G["FONT_COLOR_CODE_CLOSE"]
TITAN_REGISTERED = _G["GREEN_FONT_COLOR_CODE"] .. "Registered" .. _G["FONT_COLOR_CODE_CLOSE"]
TITAN_REGISTER_FAILED = _G["RED_FONT_COLOR_CODE"] .. "Failed_to_Register" .. _G["FONT_COLOR_CODE_CLOSE"]

Titan__InitializedPEW = false
Titan__Initialized_Settings = nil

TITAN_AT = "@"

TitanAll = nil;
TitanSettings = nil;
TitanPlayerSettings = nil
TitanPluginSettings = nil; -- Used by plugins
TitanPanelSettings = nil;

Titan_Global.players = ""

TITAN_PANEL_UPDATE_BUTTON = 1;
TITAN_PANEL_UPDATE_TOOLTIP = 2;
TITAN_PANEL_UPDATE_ALL = 3;
TitanTooltipOrigScale = 1;
TitanTooltipScaleSet = 0;

-- Set Titan Version var for backwards compatibility, set later
TITAN_VERSION = ""

-- Various constants
TITAN_PANEL_PLACE_TOP = 1;
TITAN_PANEL_PLACE_BOTTOM = 2;
TITAN_PANEL_PLACE_BOTH = 3;
TITAN_PANEL_MOVING = 0;

TITAN_WOW_SCREEN_TOP = 768
TITAN_WOW_SCREEN_BOT = 0

TITAN_TOP = "Top"
TITAN_BOTTOM = "Bottom"
TITAN_SHORT = "Short"

TITAN_RIGHT = "Right"
TITAN_LEFT = "Left"
TITAN_PANEL_BUTTONS_ALIGN_LEFT = 1;
TITAN_PANEL_BUTTONS_ALIGN_CENTER = 2;

-- Titan plugins are in the form of TitanPanel<id>Button
Titan_Global.plugin = {}
Titan_Global.plugin.PRE = "TitanPanel"
Titan_Global.plugin.POST = "Button"


TITAN_PANEL_CONTROL = "TitanPanelBarButton"
-- New bar vars
TITAN_PANEL_BAR_HEIGHT = 24
TITAN_PANEL_BAR_TEXTURE_HEIGHT = 30
TITAN_PANEL_AUTOHIDE_PREFIX = "TitanPanelAutoHide_"
TITAN_PANEL_AUTOHIDE_SUFFIX = "Button"
TITAN_PANEL_HIDE_PREFIX = "Titan_Bar__Hider_"
TITAN_PANEL_DISPLAY_PREFIX = "Titan_Bar__Display_"
TITAN_PANEL_DISPLAY_MENU = "Menu_"
TITAN_PANEL_BACKGROUND_PREFIX = "TitanPanelBackground_"
TITAN_PANEL_CLICK_MENU_SUFFIX = "RightClickMenu"
TITAN_PANEL_TEXT = "Text"
TITAN_PANEL_TEXTURE_VAR = "Texture"
TITAN_PANEL_BUTTON_TEXT = "Button" .. TITAN_PANEL_TEXT
TITAN_PANEL_CONSTANTS = {
	FONT_SIZE = 10,
	FONT_NAME = "Friz Quadrata TT"
}

TITAN_CUSTOM_PROFILE_POSTFIX = "TitanCustomProfile"
TITAN_PROFILE_NONE = "<>"
TITAN_PROFILE_RESET = "<RESET>"
TITAN_PROFILE_USE = "<USE>"
TITAN_PROFILE_INIT = "<INIT>"

AUTOHIDE_PREFIX = "TitanPanelAutoHide_"
AUTOHIDE_SUFFIX = "Button"

--[===[ Var API Adding Categories to Titan Menu
NAME: TITAN_PANEL_BUTTONS_PLUGIN_CATEGORY and TITAN_PANEL_MENU_CATEGORIES
These two tables hold the list of categories for the Titan menu.
Logically they are category - text string pairs.
Where category is the internal label to be used.
Where text is the localized text.
The category should be unique across the table or the menu navigation may be what the user expects.
Some Titan plugins add to this list to make user navigation easier for their Titan plugins.

Add to these lists by using table insert. Example :
Insert the internal name
table.insert(TITAN_PANEL_BUTTONS_PLUGIN_CATEGORY, "CAT_ZONES")

Then insert the localized string for the user
local categories = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)["TITAN_PANEL_MENU_CATEGORIES"]
table.insert(categories, "Zones")
Titan uses AceLocale to simplify using localized strings.
--]===]
TITAN_PANEL_BUTTONS_PLUGIN_CATEGORY =
{ "Built-ins", "General", "Combat", "Information", "Interface", "Profession" }
---@diagnostic disable-next-line: assign-type-mismatch
L["TITAN_PANEL_MENU_CATEGORIES"] = {
	L["TITAN_PANEL_MENU_CATEGORIES_01"],
	L["TITAN_PANEL_MENU_CATEGORIES_02"],
	L["TITAN_PANEL_MENU_CATEGORIES_03"],
	L["TITAN_PANEL_MENU_CATEGORIES_04"],
	L["TITAN_PANEL_MENU_CATEGORIES_05"],
	L["TITAN_PANEL_MENU_CATEGORIES_06"],
}

-- Bar background types
Titan_Global.SKIN = "skin"
Titan_Global.COLOR = "color"
Titan_Global.NONE = "none"

-- For debug across Titan Panel
Titan_Global.debug = {}
Titan_Global.debug.events = false
Titan_Global.debug.ldb_setup = false
Titan_Global.debug.menu = false
Titan_Global.debug.tool_tips = false
Titan_Global.debug.plugin_text = false
Titan_Global.debug.plugin_register = false
Titan_Global.debug.plugin_register_deep = false
Titan_Global.debug.movable = false

-- For WoW localized strings / literals we are using
Titan_Global.literals = {
	low = LOW,
	high = HIGH,
	yes = YES,
	no = NO,
	help = HELP_LABEL,
	mute = MUTE,
	muted = MUTED,
}

-- type for plugin registry
---@class PluginRegistryType
---@field id string The unique name of the plugin
---@field category? string The Titan menu category where this plugin will be placed
---@field version? string Plugin version
---@field menuText? string Localized string for the menu (right click)
---@field menuTextFunction? string | function Plugin function to call on right click
---@field buttonTextFunction? string | function Function to call when updating button display
---@field tooltipTitle? string Localized string for the menu 
---@field tooltipTextFunction? string | function Function to call for a simple tooltip (OnEnter)
---@field tooltipCustomFunction? function Function to call for a complex tooltip (OnEnter)
---@field icon? string Path to the plugin icon
---@field iconWidth? integer Path to the plugin icon
---@field notes? string Brief description shown in Titan > Config > Plugins when this plugin is selected
---@field controlVariables? table Show or not on menu - set to true or false - ShowIcon ShowLabelText ShowColoredText DisplayOnRightSide
---@field savedVariables? table Initial value of any saved variables for this plugin; should include control variables

---API Return an empty registry - only the id is set.
---@param id string The unique name of the plugin
---@return PluginRegistryType
---This routine was added for use with an IDE with Intellisense that supports Lua.
--- reg = Titan_Global.NewRegistry("MyAddon")
function Titan_Global.NewRegistry(id)
	local reg = { id = id } ---@type PluginRegistryType
	return reg
end
