-- $Id: Atlas_DungeonLocs.lua 56 2019-09-07 07:44:03Z arith $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbertat gmail dot com>
	Copyright 2010 - Lothaer <lothayerat gmail dot com>, Atlas Team
	Copyright 2011 ~ 2019 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

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
local LibStub = _G.LibStub
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Atlas_DungeonLocs")
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")

local BLUE = "|cff6666ff"
local GREN = "|cff66cc33"
local LBLU = "|cff33cccc"
local _RED = "|cffcc3333"
local ORNG = "|cffcc9933"
local PINK = "|ccfcc33cc"
local PURP = "|cff9900ff"
local WHIT = "|cffffffff"
local GREY = "|cff999999"
local YLOW = "|cffcccc33"
local ALAN = "|cff7babe0" -- Alliance
local HRDE = "|cffda6955" -- Horde
local INDENT = "      "

local myCategory = L["Dungeon Locations"]

local myData = {
	DLEast = {
		ZoneName = { BZ["Eastern Kingdoms"] },
		{ BLUE.." A) "..BZ["Alterac Valley"]..ALC["Comma"].._RED..BZ["Hillsbrad Foothills"], 10020 },
		{ BLUE.." B) "..BZ["Arathi Basin"]..ALC["Comma"].._RED..BZ["Arathi Highlands"], 10021 },
		{ WHIT.." 1) "..BZ["Scarlet Monastery"]..ALC["Comma"].._RED..BZ["Tirisfal Glades"], 10005 },
		{ WHIT.." 2) "..BZ["Stratholme"]..ALC["Comma"].._RED..BZ["Eastern Plaguelands"], 10004 },
		{ WHIT..INDENT..BZ["Naxxramas"]..ALC["Comma"].._RED..BZ["Stratholme"] },
		{ WHIT.." 3) "..BZ["Scholomance"]..ALC["Comma"].._RED..BZ["Western Plaguelands"], 10006 },
		{ WHIT.." 4) "..BZ["Shadowfang Keep"]..ALC["Comma"].._RED..BZ["Silverpine Forest"], 10007 },
		{ WHIT.." 5) "..BZ["Gnomeregan"]..ALC["Comma"].._RED..BZ["Dun Morogh"], 10011 },
		{ WHIT.." 6) "..BZ["Uldaman"]..ALC["Comma"].._RED..BZ["Badlands"], 10013 },
		{ WHIT.." 7) "..BZ["Blackrock Mountain"]..ALC["Comma"].._RED..BZ["Searing Gorge"]..ALC["Slash"]..BZ["Burning Steppes"], 10014 },
		{ WHIT..INDENT..BZ["Blackrock Depths"] },
		{ WHIT..INDENT..BZ["Lower Blackrock Spire"] },
		{ WHIT..INDENT..BZ["Upper Blackrock Spire"] },
		{ WHIT..INDENT..BZ["The Molten Core"]..ALC["Comma"].._RED..BZ["Blackrock Depths"] },
		{ WHIT..INDENT..BZ["Blackwing Lair"]..ALC["Comma"].._RED..BZ["Upper Blackrock Spire"] },
		{ WHIT.." 8) "..BZ["The Stockade"]..ALC["Comma"].._RED..BZ["Stormwind City"], 10015 },
		{ WHIT.." 9) "..BZ["The Deadmines"]..ALC["Comma"].._RED..BZ["Westfall"], 10017 },
		{ WHIT.."10) "..BZ["Zul'Gurub"]..ALC["Comma"].._RED..BZ["Northern Stranglethorn"], 10019 },
		{ WHIT.."11) "..BZ["Karazhan"]..ALC["Comma"].._RED..BZ["Deadwind Pass"], 10018 },
		{ WHIT.."12) "..BZ["Sunken Temple"]..ALC["Comma"].._RED..BZ["Swamp of Sorrows"], 10016 },
		{ "" },
		{ BLUE..L["Blue"]..ALC["Colon"]..ORNG..BATTLEGROUNDS },
		{ WHIT..L["White"]..ALC["Colon"]..ORNG..L["Instances"] },
	},
	DLWest = {
		ZoneName = { BZ["Kalimdor"] },
		{ BLUE.." A) "..BZ["Warsong Gulch"]..ALC["Comma"].._RED..BZ["Ashenvale"], 10017 },
		{ WHIT.." 1) "..BZ["Blackfathom Deeps"]..ALC["Comma"].._RED..BZ["Ashenvale"], 10002 },
		{ WHIT.." 2) "..BZ["Ragefire Chasm"]..ALC["Comma"].._RED..BZ["Orgrimmar"], 10003 },
		{ WHIT.." 3) "..BZ["Wailing Caverns"]..ALC["Comma"].._RED..BZ["Northern Barrens"], 10004 },
		{ WHIT.." 4) "..BZ["Maraudon"]..ALC["Comma"].._RED..BZ["Desolace"], 10005 },
		{ WHIT.." 5) "..BZ["Dire Maul"]..ALC["Comma"].._RED..BZ["Feralas"], 10006 },
		{ WHIT.." 6) "..BZ["Razorfen Kraul"]..ALC["Comma"].._RED..BZ["Southern Barrens"], 10007 },
		{ WHIT.." 7) "..BZ["Razorfen Downs"]..ALC["Comma"].._RED..BZ["Thousand Needles"], 10008 },
		{ WHIT.." 8) "..BZ["Onyxia's Lair"]..ALC["Comma"].._RED..BZ["Dustwallow Marsh"], 10009 },
		{ WHIT.." 9) "..BZ["Zul'Farrak"]..ALC["Comma"].._RED..BZ["Tanaris"], 10010 },
		{ WHIT.."10) "..BZ["Caverns of Time"]..ALC["Comma"].._RED..BZ["Tanaris"], 10011 },
		{ WHIT..INDENT..BZ["The Black Morass"] },
		{ WHIT..INDENT..BZ["Hyjal Summit"] },
		{ WHIT.."11) "..BZ["Ahn'Qiraj"]..ALC["Comma"].._RED..BZ["Ahn'Qiraj: The Fallen Kingdom"], 10012 },
		{ WHIT..INDENT..BZ["Ruins of Ahn'Qiraj"] },
		{ WHIT..INDENT..BZ["Temple of Ahn'Qiraj"] },
		{ "" },
		{ BLUE..L["Blue"]..ALC["Colon"]..ORNG..BATTLEGROUNDS },
		{ WHIT..L["White"]..ALC["Colon"]..ORNG..L["Instances"] },
	},
}

--[[ /////////////////////////////////////////
 Atlas Map NPC Description Data
 zoneID = {
	{ ID or letter mark, encounterID or customizedID, x, y, x_largeMap, y_largeMap, color of the letter mark },
	{ "A", 10001, 241, 460 },
	{ 1, 1694, 373, 339 },
 }
/////////////////////////////////////////////]]
local myDB = {
}

Atlas:RegisterPlugin("Atlas_DungeonLocs", myCategory, myData, myDB)
