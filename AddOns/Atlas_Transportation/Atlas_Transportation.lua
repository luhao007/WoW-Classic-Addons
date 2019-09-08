-- $Id: Atlas_Transportation.lua 104 2019-09-07 10:05:34Z arith $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert@gmail.com>
	Copyright 2010 - Lothaer <lothayer@gmail.com>, Atlas Team
	Copyright 2011 ~ 2019 - Arith Hsu, Atlas Team <atlas.addon at gmail.com>

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
local LibStub = _G.LibStub
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local BF = Atlas_GetLocaleLibBabble("LibBabble-Faction-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Atlas_Transportation")
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")

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

local myCategory = L["Transportation Maps"]

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

local myData = {
	FPAllianceEast = {
		ZoneName = { BZ["Eastern Kingdoms"]..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		WorldMapID = 13,
		Faction = "Alliance",
		{ WHIT.."1) "..BZ["Light's Hope Chapel"]..ALC["Comma"].._RED..BZ["Eastern Plaguelands"] },
		{ WHIT.."2) "..BZ["Chillwind Point"]..ALC["Comma"].._RED..BZ["Western Plaguelands"] },
		{ WHIT.."3) "..BZ["Aerie Peak"]..ALC["Comma"].._RED..BZ["The Hinterlands"] },
		{ WHIT.."4) "..BZ["Southshore"]..ALC["Comma"].._RED..BZ["Hillsbrad Foothills"] },
		{ WHIT.."5) "..BZ["Refuge Pointe"]..ALC["Comma"].._RED..BZ["Arathi Highlands"] },
		{ WHIT.."6) "..BZ["Menethil Harbor"]..ALC["Comma"].._RED..BZ["Wetlands"] },
		{ WHIT.."7) "..BZ["Ironforge"]..ALC["Comma"].._RED..BZ["Dun Morogh"] },
		{ WHIT.."8) "..BZ["Thelsamar"]..ALC["Comma"].._RED..BZ["Loch Modan"] },
		{ WHIT.."9) "..BZ["Thorium Point"]..ALC["Comma"].._RED..BZ["Searing Gorge"] },
		{ WHIT.."10) "..BZ["Morgan's Vigil"]..ALC["Comma"].._RED..BZ["Burning Steppes"] },
		{ WHIT.."11) "..BZ["Stormwind"]..ALC["Comma"].._RED..BZ["Elwynn Forest"] },
		{ WHIT.."12) "..BZ["Lakeshire"]..ALC["Comma"].._RED..BZ["Redridge Mountains"] },
		{ WHIT.."13) "..BZ["Sentinel Hill"]..ALC["Comma"].._RED..BZ["Westfall"] },
		{ WHIT.."14) "..BZ["Darkshire"]..ALC["Comma"].._RED..BZ["Duskwood"] },
		{ WHIT.."15) "..BZ["Nethergarde Keep"]..ALC["Comma"].._RED..BZ["Blasted Lands"] },
		{ WHIT.."16) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
	},
	FPHordeEast = {
		ZoneName = { BZ["Eastern Kingdoms"]..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		WorldMapID = 13,
		Faction = "Horde",
		{ WHIT.."1) "..BZ["Light's Hope Chapel"]..ALC["Comma"].._RED..BZ["Eastern Plaguelands"] },
		{ WHIT.."2) "..BZ["Undercity"]..ALC["Comma"].._RED..BZ["Tirisfal Glades"] },
		{ WHIT.."3) "..BZ["The Sepulcher"]..ALC["Comma"].._RED..BZ["Silverpine Forest"] },
		{ WHIT.."4) "..BZ["Tarren Mill"]..ALC["Comma"].._RED..BZ["Hillsbrad Foothills"] },
		{ WHIT.."5) "..BZ["Revantusk Village"]..ALC["Comma"].._RED..BZ["The Hinterlands"] },
		{ WHIT.."6) "..BZ["Hammerfall"]..ALC["Comma"].._RED..BZ["Arathi Highlands"] },
		{ WHIT.."7) "..BZ["Thorium Point"]..ALC["Comma"].._RED..BZ["Searing Gorge"] },
		{ WHIT.."8) "..BZ["Kargathia Keep"]..ALC["Comma"].._RED..BZ["Badlands"] },
		{ WHIT.."9) "..BZ["Flame Crest"]..ALC["Comma"].._RED..BZ["Burning Steppes"] },
		{ WHIT.."10) "..BZ["Stonard"]..ALC["Comma"].._RED..BZ["Swamp of Sorrows"] },
		{ WHIT.."11) "..BZ["Grom'gol Base Camp"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ WHIT.."12) "..BZ["Booty Bay"]..ALC["Comma"].._RED..BZ["Stranglethorn Vale"] },
		{ WHIT.."13) "..BZ["Silvermoon City"]..ALC["Comma"].._RED..BZ["Eversong Woods"] },
		{ WHIT.."14) "..BZ["Tranquillien"]..ALC["Comma"].._RED..BZ["Ghostlands"] },
	},
	FPAllianceWest = {
		ZoneName = { BZ["Kalimdor"]..ALAN..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
		WorldMapID = 12,
		Faction = "Alliance",
		{ WHIT.."1) "..BZ["Rut'theran Village"]..ALC["Comma"].._RED..BZ["Teldrassil"] },
		{ WHIT.."2) "..BZ["Shrine of Remulos"]..ALC["Comma"].._RED..BZ["Moonglade"] },
		{ WHIT.."3) "..BZ["Everlook"]..ALC["Comma"].._RED..BZ["Winterspring"] },
		{ WHIT.."4) "..BZ["Auberdine Refugee Camp"]..ALC["Comma"].._RED..BZ["Darkshore"] },
		{ WHIT.."5) "..BZ["Talonbranch Glade"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.."6) "..BZ["Emerald Sanctuary"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.."7) "..BZ["Stonetalon Peak"]..ALC["Comma"].._RED..BZ["Stonetalon Mountains"] },
		{ WHIT.."8) "..BZ["Astranaar"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."9) "..BZ["Forest Song"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."10) "..BZ["Talrendis Point"]..ALC["Comma"].._RED..BZ["Azshara"] },
		{ WHIT.."11) "..BZ["Nijel's Point"]..ALC["Comma"].._RED..BZ["Desolace"] },
		{ WHIT.."12) "..BZ["Ratchet"]..ALC["Comma"].._RED..L["The Barrens"] },
		{ WHIT.."13) "..BZ["Theramore Isle"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"] },
		{ WHIT.."14) "..BZ["Feathermoon Stronghold"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ WHIT.."15) "..BZ["Thalanaar"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ WHIT.."16) "..BZ["Marshal's Refuge"]..ALC["Comma"].._RED..BZ["Un'Goro Crater"] },
		{ WHIT.."17) "..BZ["Cenarion Hold"]..ALC["Comma"].._RED..BZ["Silithus"] },
		{ WHIT.."18) "..BZ["Gadgetzan"]..ALC["Comma"].._RED..BZ["Tanaris Desert"] },
		{ WHIT.."19) "..BZ["The Exodar"]..ALC["Comma"].._RED..BZ["Azuremyst Isle"] },
		{ WHIT.."20) "..BZ["Blood Watch"]..ALC["Comma"].._RED..BZ["Bloodmyst Isle"] },
	},
	FPHordeWest = {
		ZoneName = { BZ["Kalimdor"]..HRDE..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
		WorldMapID = 12,
		Faction = "Horde",
		{ WHIT.."1) "..BZ["Shrine of Remulos"]..ALC["Comma"].._RED..BZ["Moonglade"] },
		{ WHIT.."2) "..BZ["Everlook"]..ALC["Comma"].._RED..BZ["Winterspring"] },
		{ WHIT.."3) "..BZ["Bloodvenom Post"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.."4) "..BZ["Emerald Sanctuary"]..ALC["Comma"].._RED..BZ["Felwood"] },
		{ WHIT.."5) "..BZ["Zoram'gar Outpost"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."6) "..BZ["Valormok"]..ALC["Comma"].._RED..BZ["Azshara"] },
		{ WHIT.."7) "..BZ["Splintertree Post"]..ALC["Comma"].._RED..BZ["Ashenvale"] },
		{ WHIT.."8) "..BZ["Orgrimmar"]..ALC["Comma"].._RED..BZ["Durotar"] },
		{ WHIT.."9) "..BZ["Sun Rock Retreat"]..ALC["Comma"].._RED..BZ["Stonetalon Mountains"] },
		{ WHIT.."10) "..BZ["Crossroads"]..ALC["Comma"].._RED..L["The Barrens"] },
		{ WHIT.."11) "..BZ["Ratchet"]..ALC["Comma"].._RED..L["The Barrens"] },
		{ WHIT.."12) "..BZ["Shadowprey Village"]..ALC["Comma"].._RED..BZ["Desolace"] },
		{ WHIT.."13) "..BZ["Thunder Bluff"]..ALC["Comma"].._RED..BZ["Mulgore"] },
		{ WHIT.."14) "..L["Camp Taurajo"]..ALC["Comma"].._RED..L["The Barrens"] },
		{ WHIT.."15) "..BZ["Brackenwall Village"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"] },
		{ WHIT.."16) "..BZ["Camp Mojache"]..ALC["Comma"].._RED..BZ["Feralas"] },
		{ WHIT.."17) "..BZ["Freewind Post"]..ALC["Comma"].._RED..BZ["Thousand Needles"] },
		{ WHIT.."18) "..BZ["Marshal's Refuge"]..ALC["Comma"].._RED..BZ["Un'Goro Crater"] },
		{ WHIT.."19) "..BZ["Cenarion Hold"]..ALC["Comma"].._RED..BZ["Silithus"] },
		{ WHIT.."20) "..BZ["Gadgetzan"]..ALC["Comma"].._RED..BZ["Tanaris Desert"] },
	},
}

local myDB = {
}

Atlas:RegisterPlugin("Atlas_Transportation", myCategory, myData, myDB)

