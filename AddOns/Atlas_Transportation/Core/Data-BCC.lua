-- $Id: Data-BCC.lua 188 2022-08-20 13:58:26Z arithmandar $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert@gmail.com>
	Copyright 2010 - Lothaer <lothayer@gmail.com>, Atlas Team
	Copyright 2011 ~ 2022 - Arith Hsu, Atlas Team <atlas.addon at gmail.com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 2 of the License, or
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

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub

local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local BF = Atlas_GetLocaleLibBabble("LibBabble-Faction-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local data = {}
local alliance = {}
local horde = {}
private.data = data
private.alliance = alliance
private.horde = horde

local BLUE = "|cff6666ff"
local GREN = "|cff66cc33"
local _RED = "|cffcc3333"
local ORNG = "|cffcc9933"
local PURP = "|cff9900ff"
local WHIT = "|cffffffff"
local LBLU = "|cff33cccc"
local CYAN = "|cff00ffff"
local GREY = "|cff999999"
local ALAN = "|cff7babe0" -- Alliance's taxi node
local HRDE = "|cffda6955" -- Horde's taxi node
local NUTL = "|cfffee570" -- Nutral taxi node
local INDENT = "      "

local CL = {
	["HUNTER"] 	= "|cffabd473",
	["WARLOCK"] 	= "|cff8788ee",
	["PRIEST"] 	= "|cffffffff",
	["PALADIN"] 	= "|cfff58cba",
	["MAGE"] 	= "|cff3fc7eb",
	["ROGUE"] 	= "|cfffff569",
	["DRUID"] 	= "|cffff7d0a",
	["SHAMAN"] 	= "|cff0070de",
	["WARRIOR"] 	= "|cffc79c6e",
	["DEATHKNIGHT"]	= "|cffc41f3b",
	["MONK"] 	= "|cff00ff96",
	["DEMONHUNTER"]	= "|cffa330c9",
}


alliance.maps = {
	TransAllianceCosmos_BCC = {
		ZoneName = { WORLD..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		{ BLUE..BZ["Kalimdor"] },
		{ WHIT.." 1) "..BZ["Darnassus"]..ALC["Comma"].._RED..BZ["Teldrassil"], 10001 },
		{ WHIT.." 2) "..BZ["Rut'theran Village"]..ALC["Comma"].._RED..BZ["Teldrassil"], 10002 },
		{ WHIT.." 3) "..BZ["Auberdine"]..ALC["Comma"].._RED..BZ["Darkshore"], 10003 },
		{ WHIT.." 4) "..BZ["The Exodar"]..ALC["Comma"].._RED..BZ["Azuremyst Isle"], 10004 },
		{ WHIT.." 5) "..BZ["Nighthaven"]..ALC["Comma"].._RED..BZ["Moonglade"], 10005 },
		{ NUTL.." 6) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"], 10006 },
		{ WHIT.." 7) "..BZ["Theramore"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"], 10007 },
		{ "" },
		{ BLUE..BZ["Eastern Kingdoms"] },
		{ WHIT.." 8) "..BZ["Menethil Harbor"]..ALC["Comma"].._RED..BZ["Wetlands"], 10008 },
		{ WHIT.." 9) "..BZ["Ironforge"]..ALC["Comma"].._RED..BZ["Dun Morogh"], 10009 },
		{ WHIT.."10) "..BZ["Stormwind"]..ALC["Comma"].._RED..BZ["Elwynn Forest"], 10010 },
		{ NUTL.."11) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"], 10011 },
		{ WHIT.."12) "..BZ["Shattered Beachhead"]..ALC["Comma"].._RED..BZ["Blasted Lands"], 10012 },
		{ WHIT.."13) "..BZ["Shattered Sun Staging Area"]..ALC["Comma"].._RED..BZ["Isle of Quel'Danas"], 10013 },
		{ "" },
		{ BLUE..BZ["Outland"] },
		{ WHIT.."14) "..BZ["The Stair of Destiny"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"], 10014 },
		{ NUTL.."15) "..BZ["Shattrath City"]..ALC["Comma"].._RED..BZ["Terokkar Forest"], 10015 },
	},
	TransAllianceEast_BCC = {
		ZoneName = { BZ["Eastern Kingdoms"]..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		WorldMapID = 13,
		Faction = "Alliance",
		{ BLUE.." A) "..BZ["Auberdine"]..ALC["Comma"].._RED..BZ["Darkshore"]..ALC["Comma"]..BZ["Kalimdor"] };
		{ BLUE.." B) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"]..ALC["Comma"]..BZ["Kalimdor"] };
		{ BLUE.." C) "..BZ["Theramore Isle"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"]..ALC["Comma"]..BZ["Kalimdor"] };
		{ PURP.." A) "..BZ["The Dark Portal"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"]..ALC["Comma"]..BZ["Outland"] };
		{ };
		{ WHIT.." 1) "..BZ["Shattered Sun Staging Area"]..ALC["Comma"].._RED..BZ["Isle of Quel'Danas"] };
		{ WHIT.." 2) "..BZ["Hatchet Hills"]..ALC["Comma"].._RED..BZ["Ghostlands"] };
		{ WHIT.." 3) "..BZ["Light's Hope Chapel"]..ALC["Comma"].._RED..BZ["Eastern Plaguelands"] },
		{ WHIT.." 4) "..BZ["Chillwind Point"]..ALC["Comma"].._RED..BZ["Western Plaguelands"] },
		{ WHIT.." 5) "..BZ["Aerie Peak"]..ALC["Comma"].._RED..BZ["The Hinterlands"] },
		{ WHIT.." 6) "..BZ["Southshore"]..ALC["Comma"].._RED..BZ["Hillsbrad Foothills"] },
		{ WHIT.." 7) "..BZ["Refuge Pointe"]..ALC["Comma"].._RED..BZ["Arathi Highlands"] },
		{ WHIT.." 8) "..BZ["Menethil Harbor"]..ALC["Comma"].._RED..BZ["Wetlands"] },
		{ WHIT.." 9) "..BZ["Ironforge"]..ALC["Comma"].._RED..BZ["Dun Morogh"] },
		{ WHIT.."10) "..BZ["Thelsamar"]..ALC["Comma"].._RED..BZ["Loch Modan"] },
		{ WHIT.."11) "..BZ["Thorium Point"]..ALC["Comma"].._RED..BZ["Searing Gorge"] },
		{ WHIT.."12) "..BZ["Morgan's Vigil"]..ALC["Comma"].._RED..BZ["Burning Steppes"] },
		{ WHIT.."13) "..BZ["Stormwind"]..ALC["Comma"].._RED..BZ["Elwynn Forest"] },
		{ WHIT.."14) "..BZ["Lakeshire"]..ALC["Comma"].._RED..BZ["Redridge Mountains"] },
		{ WHIT.."15) "..BZ["Sentinel Hill"]..ALC["Comma"].._RED..BZ["Westfall"] },
		{ WHIT.."16) "..BZ["Darkshire"]..ALC["Comma"].._RED..BZ["Duskwood"] },
		{ WHIT.."17) "..BZ["Nethergarde Keep"]..ALC["Comma"].._RED..BZ["Blasted Lands"] },
		{ WHIT.."18) "..BZ["Rebel Camp"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] };
		{ WHIT.."19) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ "" },
		{ _RED..L["Legend"] },
		{ BLUE.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
	},
	TransAllianceWest_BCC = {
		ZoneName = { BZ["Kalimdor"]..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		WorldMapID = 12,
		Faction = "Alliance",
		{ BLUE.." A) "..BZ["Menethil Harbor"]..ALC["Comma"].._RED..BZ["Wetlands"]..ALC["Comma"]..BZ["Eastern Kingdoms"] };
		{ BLUE.." B) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"]..ALC["Comma"]..BZ["Eastern Kingdoms"] };
		{ };
		{ WHIT.." 1) "..BZ["Rut'theran Village"]..ALC["Comma"].._RED..BZ["Teldrassil"] },
		{ WHIT.." 2) "..BZ["Nighthaven"]..ALC["Comma"].._RED..BZ["Moonglade"]..GREN..ALC["L-Parenthesis"]..L["Druid Only"]..ALC["R-Parenthesis"] };
		{ WHIT.." 3) "..BZ["Nighthaven"]..ALC["Comma"].._RED..BZ["Moonglade"] },
		{ WHIT.." 4) "..BZ["Everlook"]..ALC["Comma"].._RED..BZ["Winterspring"] },
		{ WHIT.." 5) "..BZ["Auberdine"]..ALC["Comma"].._RED..BZ["Darkshore"] },
		{ WHIT.." 6) "..BZ["Talonbranch Glade"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.." 7) "..BZ["Emerald Sanctuary"]..ALC["Comma"].._RED..BZ["Felwood"] };
		{ WHIT.." 8) "..BZ["Stonetalon Peak"]..ALC["Comma"].._RED..BZ["Stonetalon Mountains"] },
		{ WHIT.." 9) "..BZ["Astranaar"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."10) "..BZ["Forest Song"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."11) "..BZ["Talrendis Point"]..ALC["Comma"].._RED..BZ["Azshara"] },
		{ WHIT.."12) "..BZ["Nijel's Point"]..ALC["Comma"].._RED..BZ["Desolace"] },
		{ NUTL.."13) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"] },
		{ WHIT.."14) "..BZ["Theramore"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"] },
		{ WHIT.."15) "..BZ["Theramore Isle"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"] };
		{ WHIT.."16) "..BZ["Feathermoon"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ WHIT.."17) "..BZ["Thalanaar"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ NUTL.."18) "..BZ["Marshal's Refuge"]..ALC["Comma"].._RED..BZ["Un'Goro Crater"] },
		{ WHIT.."19) "..BZ["Cenarion Hold"]..ALC["Comma"].._RED..BZ["Silithus"] },
		{ WHIT.."20) "..BZ["Gadgetzan"]..ALC["Comma"].._RED..BZ["Tanaris"] },
		{ WHIT.."21) "..BZ["Blood Watch"]..ALC["Comma"].._RED..BZ["Bloodmyst Isle"] };
		{ WHIT.."22) "..BZ["Valaar's Berth"]..ALC["Comma"].._RED..BZ["Azuremyst Isle"] };
		{ "" },
		{ _RED..L["Legend"] },
		{ NUTL..L["Yellow"]..ALC["Colon"]..L["Taxi Nodes"]..ALC["Hyphen"]..L["Nutral"] },
		{ BLUE.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
	},
	TransAllianceOutland_BCC = {
		ZoneName = { BZ["Outland"]..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		WorldMapID = 101,
		Faction = "Alliance",
		{ WHIT.." 1) "..BZ["The Dark Portal"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.." 2) "..BZ["Shatter Point"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.." 3) "..BZ["Honor Hold"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.." 4) "..BZ["Temple of Telhamat"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.." 5) "..BZ["Telredor"]..ALC["Comma"].._RED..BZ["Zangarmarsh"] },
		{ WHIT.." 6) "..BZ["Orebor Harborage"]..ALC["Comma"].._RED..BZ["Zangarmarsh"] },
		{ WHIT.." 7) "..BZ["Telaar"]..ALC["Comma"].._RED..BZ["Nagrand"] },
		{ WHIT.." 8) "..BZ["Shattrath City"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ WHIT.." 9) "..BZ["Allerian Stronghold"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ WHIT.."10) "..BZ["Wildhammer Stronghold"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"] },
		{ WHIT.."11) "..BZ["Altar of Sha'tar"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"]..ALC["L-Parenthesis"]..BF["The Aldor"]..ALC["R-Parenthesis"] },
		{ WHIT.."12) "..BZ["Sanctum of the Stars"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"]..ALC["L-Parenthesis"]..BF["The Scryers"]..ALC["R-Parenthesis"] },
		{ WHIT.."13) "..BZ["Sylvanaar"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."14) "..BZ["Evergrove"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."15) "..BZ["Toshley's Station"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."16) "..BZ["Area 52"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ WHIT.."17) "..BZ["The Stormspire"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ WHIT.."18) "..BZ["Cosmowrench"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ GREN.."1') "..BZ["Blackwind Landing"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ GREN.."2') "..BZ["Skyguard Outpost"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ GREN..INDENT..L["Honored with Sha'tari Skyguard"] },
	},
}
alliance.coords = {
	TransAllianceCosmos_BCC = {
		{ 1, 10001, 72, 176 },
		{ 2, 10002, 95, 193 },
		{ 3, 10003, 102, 223 },
		{ 4, 10004, 18, 226 },
		{ 5, 10005, 146, 202 },
		{ 6, 10006, 163, 334 },
		{ 7, 10007, 177, 376 },
		{ 8, 10008, 401, 304 },
		{ 9, 10009, 395, 322 },
		{10, 10010, 374, 369 },
		{11, 10011, 380, 451 },
		{12, 10012, 434, 412 },
		{13, 10013, 454, 107 },
		{14, 10014, 294, 62 },
		{15, 10015, 256, 82 },
	},
}
horde.maps = {
	TransHordeCosmos_BCC = {
		ZoneName = { WORLD..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		{ BLUE..BZ["Kalimdor"] },
		{ WHIT.." 1) "..BZ["Orgrimmar"]..ALC["Comma"].._RED..BZ["Durotar"], 10001 },
		{ WHIT.." 2) "..BZ["Thunder Bluff"]..ALC["Comma"].._RED..BZ["Mulgore"], 10002 },
		{ NUTL.." 3) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"], 10003 },
		{ WHIT.." 4) "..BZ["Shrine of Remulos"]..ALC["Comma"].._RED..BZ["Moonglade"], 10004 },
		{ "" },
		{ BLUE..BZ["Eastern Kingdoms"] },
		{ WHIT.." 5) "..BZ["Undercity"]..ALC["Comma"].._RED..BZ["Tirisfal Glades"], 10005 },
		{ WHIT.." 6) "..BZ["Grom'gol"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"], 10006 },
		{ NUTL.." 7) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"], 10007 },
		{ WHIT.." 8) "..BZ["Shattered Beachhead"]..ALC["Comma"].._RED..BZ["Blasted Lands"], 10008 },
		{ WHIT.." 9) "..BZ["Silvermoon City"]..ALC["Comma"].._RED..BZ["Eversong Woods"], 10009 },
		{ WHIT.."10) "..BZ["Shattered Sun Staging Area"]..ALC["Comma"].._RED..BZ["Isle of Quel'Danas"], 10010 },
		{ "" },
		{ BLUE..BZ["Outland"] },
		{ WHIT.."11) "..BZ["The Stair of Destiny"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"], 10011 },
		{ NUTL.."12) "..BZ["Shattrath City"]..ALC["Comma"].._RED..BZ["Terokkar Forest"], 10012 },
	},
	TransHordeEast_BCC = {
		ZoneName = { BZ["Eastern Kingdoms"]..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		WorldMapID = 13,
		Faction = "Horde",
		{ BLUE.." A) "..BZ["Orgrimmar"]..ALC["Comma"].._RED..BZ["Durotar"] },
		{ BLUE.." B) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"] },
		{ PURP.." A) "..BZ["The Dark Portal"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] };
		{ };
		{ WHIT.." 1) "..BZ["Shattered Sun Staging Area"]..ALC["Comma"].._RED..BZ["Isle of Quel'Danas"] };
		{ WHIT.." 2) "..BZ["Silvermoon City"]..ALC["Comma"].._RED..BZ["Eversong Woods"] };
		{ WHIT.." 3) "..BZ["Tranquillien"]..ALC["Comma"].._RED..BZ["Ghostlands"] };
		{ WHIT.." 4) "..BZ["Hatchet Hills"]..ALC["Comma"].._RED..BZ["Ghostlands"] };
		{ WHIT.." 5) "..BZ["Light's Hope Chapel"]..ALC["Comma"].._RED..BZ["Eastern Plaguelands"] },
		{ WHIT.." 6) "..BZ["Undercity"]..ALC["Comma"].._RED..BZ["Tirisfal Glades"] },
		{ WHIT.." 7) "..BZ["The Sepulcher"]..ALC["Comma"].._RED..BZ["Silverpine Forest"] },
		{ WHIT.." 8) "..BZ["Tarren Mill"]..ALC["Comma"].._RED..BZ["Hillsbrad Foothills"] },
		{ WHIT.." 9) "..BZ["Revantusk Village"]..ALC["Comma"].._RED..BZ["The Hinterlands"] },
		{ WHIT.."10) "..BZ["Hammerfall"]..ALC["Comma"].._RED..BZ["Arathi Highlands"] },
		{ WHIT.."11) "..BZ["Thorium Point"]..ALC["Comma"].._RED..BZ["Searing Gorge"] },
		{ WHIT.."12) "..BZ["Kargath"]..ALC["Comma"].._RED..BZ["Badlands"] },
		{ WHIT.."13) "..BZ["Flame Crest"]..ALC["Comma"].._RED..BZ["Burning Steppes"] },
		{ WHIT.."14) "..BZ["Stonard"]..ALC["Comma"].._RED..BZ["Swamp of Sorrows"] },
		{ WHIT.."15) "..BZ["Grom'gol"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ WHIT.."16) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ "" },
		{ _RED..L["Legend"] },
		{ PURP.."-- : "..L["Portal / Waygate Path to the destination"] },
		{ BLUE.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
		{ NUTL.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
	},
	TransHordeWest_BCC = {
		ZoneName = { BZ["Kalimdor"]..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		WorldMapID = 12,
		Faction = "Horde",
		{ BLUE.." A) "..BZ["Undercity"]..ALC["Comma"].._RED..BZ["Tirisfal Glades"] },
		{ BLUE.." B) "..BZ["Grom'gol"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ BLUE.." C) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ };
		{ WHIT.." 1) "..BZ["Nighthaven"]..ALC["Comma"].._RED..BZ["Moonglade"]..GREN..ALC["L-Parenthesis"]..L["Druid Only"]..ALC["R-Parenthesis"] };
		{ WHIT.." 2) "..BZ["Shrine of Remulos"]..ALC["Comma"].._RED..BZ["Moonglade"] },
		{ WHIT.." 3) "..BZ["Everlook"]..ALC["Comma"].._RED..BZ["Winterspring"] },
		{ WHIT.." 4) "..BZ["Bloodvenom Post"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.." 6) "..BZ["Zoram'gar Outpost"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.." 7) "..BZ["Valormok"]..ALC["Comma"].._RED..BZ["Azshara"] },
		{ WHIT.." 8) "..BZ["Splintertree Post"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.." 9) "..BZ["Orgrimmar"]..ALC["Comma"].._RED..BZ["Durotar"] },
		{ WHIT.."10) "..BZ["Sun Rock Retreat"]..ALC["Comma"].._RED..BZ["Stonetalon Mountains"] },
		{ WHIT.."11) "..BZ["Crossroads"]..ALC["Comma"].._RED..BZ["The Barrens"] },
		{ NUTL.."12) "..BZ["Ratchet"]..ALC["Comma"].._RED..BZ["The Barrens"] },
		{ WHIT.."13) "..BZ["Shadowprey Village"]..ALC["Comma"].._RED..BZ["Desolace"] },
		{ WHIT.."14) "..BZ["Thunder Bluff"]..ALC["Comma"].._RED..BZ["Mulgore"] },
		{ WHIT.."15) "..BZ["Camp Taurajo"]..ALC["Comma"].._RED..BZ["The Barrens"] },
		{ WHIT.."16) "..BZ["Brackenwall Village"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"] },
		{ WHIT.."17) "..BZ["Camp Mojache"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ WHIT.."18) "..BZ["Freewind Post"]..ALC["Comma"].._RED..BZ["Thousand Needles"] },
		{ NUTL.."19) "..BZ["Marshal's Refuge"]..ALC["Comma"].._RED..BZ["Un'Goro Crater"] },
		{ WHIT.."20) "..BZ["Cenarion Hold"]..ALC["Comma"].._RED..BZ["Silithus"] },
		{ WHIT.."21) "..BZ["Gadgetzan"]..ALC["Comma"].._RED..BZ["Tanaris"] },
		{ "" },
		{ _RED..L["Legend"] },
		{ NUTL..L["Yellow"]..ALC["Colon"]..L["Taxi Nodes"]..ALC["Hyphen"]..L["Nutral"] },
		{ BLUE.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
		{ NUTL.."-- : "..L["Ship / Zeppelin sailing path to destination"] },
	},
	TransHordeOutland_BCC = {
		ZoneName = { BZ["Outland"]..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		WorldMapID = 101,
		Faction = "Horde",
		{ WHIT.."1) "..BZ["The Dark Portal"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.."2) "..BZ["Thrallmar"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.."3) "..BZ["Spinebreaker Post"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.."4) "..BZ["Falcon Watch"]..ALC["Comma"].._RED..BZ["Hellfire Peninsula"] },
		{ WHIT.."5) "..BZ["Swamprat Post"]..ALC["Comma"].._RED..BZ["Zangarmarsh"] },
		{ WHIT.."6) "..BZ["Zabra'jin"]..ALC["Comma"].._RED..BZ["Zangarmarsh"] },
		{ WHIT.."7) "..BZ["Garadar"]..ALC["Comma"].._RED..BZ["Nagrand"] },
		{ WHIT.."8) "..BZ["Shattrath City"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ WHIT.."9) "..BZ["Stonebreaker Hold"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ WHIT.."10) "..BZ["Shadowmoon Village"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"] },
		{ WHIT.."11) "..BZ["Altar of Sha'tar"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"]..ALC["L-Parenthesis"]..BF["The Aldor"]..ALC["R-Parenthesis"] },
		{ WHIT.."12) "..BZ["Sanctum of the Stars"]..ALC["Comma"].._RED..BZ["Shadowmoon Valley"]..ALC["L-Parenthesis"]..BF["The Scryers"]..ALC["R-Parenthesis"] },
		{ WHIT.."13) "..BZ["Thunderlord Stronghold"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."14) "..BZ["Evergrove"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."15) "..BZ["Mok'Nathal Village"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ WHIT.."16) "..BZ["Area 52"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ WHIT.."17) "..BZ["The Stormspire"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ WHIT.."18) "..BZ["Cosmowrench"]..ALC["Comma"].._RED..BZ["Netherstorm"] },
		{ GREN.."1') "..BZ["Blackwind Landing"]..ALC["Comma"].._RED..BZ["Terokkar Forest"] },
		{ GREN.."2') "..BZ["Skyguard Outpost"]..ALC["Comma"].._RED..BZ["Blade's Edge Mountains"] },
		{ GREN..INDENT..L["Honored with Sha'tari Skyguard"] },
	}
}
horde.coords = {
	TransHordeCosmos_BCC = {
		{ 1, 10001, 173, 288 },
		{ 2, 10002, 112, 337 },
		{ 3, 10003, 163, 334 },
		{ 4, 10004, 146, 202 },
		{ 5, 10005, 389, 218 },
		{ 6, 10006, 389, 420 },
		{ 7, 10007, 382, 451 },
		{ 8, 10008, 436, 414 },
		{ 9, 10009, 456, 145 },
		{10, 10010, 456, 108 },
		{11, 10011, 294, 62 },
		{12, 10012, 256, 82 },
	}
}
data.maps = {
}
data.coords = {
}



