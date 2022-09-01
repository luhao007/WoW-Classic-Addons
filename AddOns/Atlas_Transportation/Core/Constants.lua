-- $Id: Constants.lua 153 2022-03-19 10:07:32Z arithmandar $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
private.addon_name = "Atlas_Transportation"
private.category = "Transportation Maps"

local constants = {}
private.constants = constants

constants.defaults = {
	profile = {
		all_faction = false,
	},
}

constants.events = {}
