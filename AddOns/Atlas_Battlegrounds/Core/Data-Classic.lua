-- $Id: Data-Classic.lua 1592 2022-08-30 14:35:51Z arithmandar $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert at gmail dot com>
	Copyright 2010 - Lothaer <lothayer at gmail dot com>, Atlas Team
	Copyright 2011 ~ 2022 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]
local _G = getfenv(0)
local select = select
local GetBuildInfo = _G.GetBuildInfo

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local BF = Atlas_GetLocaleLibBabble("LibBabble-Faction-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")

local db = {}
private.db = db

local BLUE = "|cff6666ff"
local GREN = "|cff66cc33"
local LBLU = "|cff33cccc"
local _RED = "|cffcc3333"
local ORNG = "|cffcc9933"
local PINK = "|ccfcc33cc"
local PURP = "|cff9900ff"
local WHIT = "|cffffffff"
local YLOW = "|cffcccc33"
local INDENT = "      "
local BULLET = " - "

db.category = L[private.category]


db.maps = {
	AlteracValleyNorth = {
		ZoneName = { BZ["Alterac Valley"]..ALC["L-Parenthesis"]..ALC["North"]..ALC["Comma"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		Location = { BZ["Alterac Mountains"] },
		LevelRange = "51-60",
		PlayerLimit = { 40 },
		Acronym = L["AV"],
		WorldMapID = 91,
		Faction = "Alliance",
		{ ORNG..REPUTATION..ALC["Colon"]..BF["Stormpike Guard"] },
		{ BLUE.."A) "..ALC["Entrance"], 10001 },
		{ BLUE.."B) "..BZ["Dun Baldar"], 10002 },
		{ GREN..INDENT..L["Vanndar Stormpike <Stormpike General>"] },
		{ GREN..INDENT..L["Prospector Stonehewer"] },
		{ _RED.."1) "..L["Dun Baldar North Bunker"], 10003 },
		{ GREN..INDENT..L["Wing Commander Mulverick"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ _RED.."2) "..L["Dun Baldar South Bunker"], 10004 },
		{ GREN..INDENT..L["Gaelden Hammersmith <Stormpike Supply Officer>"] },
		{ _RED.."3) "..BZ["Icewing Cavern"], 10005 },
		{ GREN..INDENT..L["Stormpike Banner"] },
		{ _RED.."4) "..L["Stormpike Lumber Yard"], 10006 },
		{ GREN..INDENT..L["Wing Commander Jeztor"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ _RED.."5) "..BZ["Icewing Bunker"], 10007 },
		{ GREN..INDENT..L["Wing Commander Guse"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ _RED.."6) "..BZ["Stonehearth Outpost"], 10008 },
		{ GREN..INDENT..L["Captain Balinda Stonehearth <Stormpike Captain>"] },
		{ _RED.."7) "..BZ["Stonehearth Bunker"], 10009 },
		{ _RED.."8) "..L["Western Crater"], 10010 },
		{ GREN..INDENT..L["Vipore's Beacon"] },
		{ GREN..INDENT..L["Jeztor's Beacon"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ _RED.."9) "..L["Eastern Crater"], 10011 },
		{ GREN..INDENT..L["Slidore's Beacon"] },
		{ GREN..INDENT..L["Guse's Beacon"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ GREN.."1) "..BZ["Irondeep Mine"], 10012 },
		{ GREN.."1') "..L["Arch Druid Renferal"], 10013 },
		{ GREN.."2') "..L["Murgot Deepforge"], 10014 },
		{ GREN..INDENT..L["Lana Thunderbrew <Blacksmithing Supplies>"] },
		{ GREN.."3') "..L["Stormpike Stable Master <Stable Master>"], 10015 },
		{ GREN..INDENT..L["Stormpike Ram Rider Commander"] },
		{ GREN..INDENT..L["Svalbrad Farmountain <Trade Goods>"] },
		{ GREN..INDENT..L["Kurdrum Barleybeard <Reagents & Poison Supplies>"] },
		{ GREN.."4') "..L["Stormpike Quartermaster"], 10016 },
		{ GREN..INDENT..L["Jonivera Farmountain <General Goods>"] },
		{ GREN..INDENT..L["Brogus Thunderbrew <Food & Drink>"] },
		{ GREN.."5') "..L["Wing Commander Ichman"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"], 10017 },
		{ GREN..INDENT..L["Wing Commander Slidore"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"] },
		{ GREN..INDENT..L["Wing Commander Vipore"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"] },
		{ GREN.."6') "..L["Stormpike Ram Rider Commander"], 10018 },
		{ GREN.."7') "..L["Ivus the Forest Lord"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"], 10019 },
		{ ORNG.."1) "..L["Stormpike Aid Station"], 10020 },
		{ ORNG.."2) "..BZ["Stormpike Graveyard"], 10021 },
		{ ORNG.."3) "..BZ["Stonehearth Graveyard"], 10022 },
		{ ORNG.."4) "..BZ["Snowfall Graveyard"], 10023 },
		{ GREN..INDENT..L["Ichman's Beacon"] },
		{ GREN..INDENT..L["Mulverick's Beacon"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
	},
	AlteracValleySouth = {
		ZoneName = { BZ["Alterac Valley"]..ALC["L-Parenthesis"]..ALC["South"]..ALC["Comma"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		Location = { BZ["Hillsbrad Foothills"] },
		LevelRange = "51-60",
		PlayerLimit = { 40 },
		Acronym = L["AV"],
		WorldMapID = 91,
		Faction = "Horde",
		{ ORNG..REPUTATION..ALC["Colon"]..BF["Frostwolf Clan"] },
		{ BLUE.."A) "..ALC["Entrance"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"], 10001 },
		{ BLUE.."B) "..BZ["Frostwolf Keep"], 10002 },
		{ GREN..INDENT..L["Drek'Thar <Frostwolf General>"] },
		{ _RED.."1) "..BZ["Iceblood Garrison"], 10003 },
		{ GREN..INDENT..L["Captain Galvangar <Frostwolf Captain>"] },
		{ _RED.."2) "..L["Iceblood Tower"], 10004 },
		{ _RED.."3) "..L["Tower Point"], 10005 },
		{ GREN..INDENT..L["Wing Commander Slidore"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		{ _RED.."4) "..L["West Frostwolf Tower"], 10006 },
		{ GREN..INDENT..L["Wing Commander Ichman"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		{ _RED.."5) "..L["East Frostwolf Tower"], 10007 },
		{ _RED.."6) "..BZ["Wildpaw Cavern"], 10008 },
		{ GREN..INDENT..L["Frostwolf Banner"] },
		{ GREN.."1) "..BZ["Coldtooth Mine"], 10009 },
		{ GREN.."1') "..L["Lokholar the Ice Lord"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"], 10010 },
		{ GREN.."2') "..L["Wing Commander Vipore"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"], 10011 },
		{ GREN..INDENT..L["Jotek"] },
		{ GREN..INDENT..L["Smith Regzar"] },
		{ GREN..INDENT..L["Primalist Thurloga"] },
		{ GREN.."3') "..L["Frostwolf Stable Master <Stable Master>"], 10012 },
		{ GREN..INDENT..L["Frostwolf Wolf Rider Commander"] },
		{ GREN.."4') "..L["Frostwolf Quartermaster"], 10013 },
		{ GREN.."5') "..L["Wing Commander Guse"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"], 10014 },
		{ GREN..INDENT..L["Wing Commander Jeztor"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"] },
		{ GREN..INDENT..L["Wing Commander Mulverick"]..ALC["L-Parenthesis"]..L["Rescued"]..ALC["R-Parenthesis"] },
		{ ORNG.."1) "..BZ["Iceblood Graveyard"], 10015 },
		{ ORNG.."2) "..BZ["Frostwolf Graveyard"], 10016 },
		{ ORNG.."3) "..L["Frostwolf Relief Hut"], 10017 },
	},
	ArathiBasin = {
		ZoneName = { BZ["Arathi Basin"] },
		Location = { BZ["Arathi Highlands"] },
		LevelRange = "20-60",
		PlayerLimit = { 15 },
		Acronym = L["AB"],
		WorldMapID = 93,
		{ ORNG..REPUTATION..ALC["Colon"]..BF["The League of Arathor"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		{ ORNG..REPUTATION..ALC["Colon"]..BF["The Defilers"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ BLUE.."A) "..BZ["Trollbane Hall"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"], 10001 },
		{ BLUE.."B) "..BZ["Defiler's Den"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"], 10002 },
		{ GREN.."1) "..BZ["Stables"], 10003 },
		{ GREN.."2) "..BZ["Gold Mine"], 10004 },
		{ GREN.."3) "..BZ["Blacksmith"], 10005 },
		{ GREN.."4) "..BZ["Lumber Mill"], 10006 },
		{ GREN.."5) "..BZ["Farm"], 10007 },
	},
	WarsongGulch = {
		ZoneName = { BZ["Warsong Gulch"] },
		Location = { BZ["Ashenvale"]..ALC["Slash"]..BZ["Northern Barrens"] },
		LevelRange = "10-60",
		PlayerLimit = { 10 },
		Acronym = L["WSG"],
		WorldMapID = 92,
		{ ORNG..REPUTATION..ALC["Colon"]..BF["Silverwing Sentinels"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		{ ORNG..REPUTATION..ALC["Colon"]..BF["Warsong Outriders"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ BLUE.."A) "..BZ["Silverwing Hold"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"], 10001 },
		{ BLUE.."B) "..BZ["Warsong Lumber Mill"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"], 10002 },
	},
}

db.coords = {
	AlteracValleyNorth = {
		{  "A", 10001, 368, 25 }, -- Entrance
		{  "B", 10002, 166, 65 }, -- Dun Baldar
		{  "1", 10003, 217, 69 }, -- Dun Baldar North Bunker
		{  "2", 10004, 197, 120 }, -- Dun Baldar South Bunker
		{  "3", 10005, 180, 229 }, -- Icewing Cavern
		{  "4", 10006, 371, 218 }, -- Stormpike Lumber Yard
		{  "5", 10007, 315, 268 }, -- Icewing Bunker
		{  "6", 10008, 282, 372 }, -- Stonehearth Outpost
		{  "7", 10009, 350, 427 }, -- Stonehearth Bunker
		{  "8", 10010, 268, 459 }, -- Western Crater
		{  "9", 10011, 294, 482 }, -- Eastern Crater
		{  "1", 10012, 297, 14 }, -- Irondeep Mine
		{ "1'", 10013, 194, 48 }, -- Arch Druid Renferal
		{ "2'", 10014, 186, 83 }, -- Murgot Deepforge
		{ "3'", 10015, 159, 102 }, -- Stormpike Stable Master <Stable Master>
		{ "4'", 10016, 178, 105 }, -- Stormpike Quartermaster
		{ "5'", 10017, 178, 120 }, -- Wing Commander Ichman
		{ "6'", 10018, 301, 353 }, -- Stormpike Ram Rider Commander
		{ "7'", 10019, 309, 445 }, -- Ivus the Forest Lord
		{  "1", 10020, 138, 82 }, -- Stormpike Aid Station
		{  "2", 10021, 318, 73 }, -- Stormpike Graveyard
		{  "3", 10022, 371, 328 }, -- Stonehearth Graveyard
		{  "4", 10023, 144, 428 }, -- Snowfall Graveyard
	},
	AlteracValleySouth = {
		{  "A", 10001, 355, 427 }, -- Entrance
		{  "B", 10002, 220, 426 }, -- Frostwolf Keep
		{  "1", 10003, 197, 65 }, -- Iceblood Garrison
		{  "2", 10004, 237, 81 }, -- Iceblood Tower
		{  "3", 10005, 281, 166 }, -- Tower Point
		{  "4", 10006, 241, 395 }, -- West Frostwolf Tower
		{  "5", 10007, 260, 395 }, -- East Frostwolf Tower
		{  "6", 10008, 323, 436 }, -- Wildpaw Cavern
		{  "1", 10009, 206, 244 }, -- Coldtooth Mine
		{ "1'", 10010, 168, 5 }, -- Lokholar the Ice Lord
		{ "2'", 10011, 276, 366 }, -- Wing Commander Vipore
		{ "3'", 10012, 402, 375 }, -- Frostwolf Stable Master <Stable Master>
		{ "4'", 10013, 204, 390 }, -- Frostwolf Quartermaster
		{ "5'", 10014, 268, 413 }, -- Wing Commander Guse
		{  "1", 10015, 299, 65 }, -- Iceblood Graveyard
		{  "2", 10016, 234, 303 }, -- Frostwolf Graveyard
		{  "3", 10017, 265, 476 }, -- Frostwolf Relief Hut
	},
	ArathiBasin = {
		{ "A", 10001, 95, 93 }, -- Trollbane Hall
		{ "B", 10002, 409, 400 }, -- Defiler's Den
		{ "1", 10003, 164, 156 }, -- Stables
		{ "2", 10004, 340, 157 }, -- Gold Mine
		{ "3", 10005, 255, 248 }, -- Blacksmith
		{ "4", 10006, 164, 336 }, -- Lumber Mill
		{ "5", 10007, 329, 334 }, -- Farm
	},
	WarsongGulch = {
		{ "A", 10001, 238, 96 }, -- Silverwing Hold
		{ "B", 10002, 256, 365 }, -- Warsong Lumber Mill
	},
}

Atlas:RegisterPlugin(private.addon_name, private.db.category, private.db.maps, private.db.coords)
