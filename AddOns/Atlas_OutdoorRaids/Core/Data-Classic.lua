-- $Id: Data-Classic.lua 88 2023-03-20 15:06:02Z arithmandar $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert@gmail.com>
	Copyright 2010 - Lothaer <lothayer@gmail.com>, Atlas Team
	Copyright 2011 ~ 2023 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

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

local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local BF = Atlas_GetLocaleLibBabble("LibBabble-Faction-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")

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

local myCategory = L["Outdoor Raid Encounters"]

local function sBF(key)
	return BF[key] and BF[key] or key
end

local function Atlas_GetBossName(bossname, encounterID, creatureIndex)
	local BB = Atlas_GetLocaleLibBabble("LibBabble-Boss-3.0")

	if (bossname and L[bossname]) then
		bossname = L[bossname]
	elseif (bossname and BB[bossname]) then
		bossname = BB[bossname]
	else
		--bossname = bossname
	end

	return bossname
end

local myData = {
	Azuregos = {
		ZoneName = { Atlas_GetBossName("Azuregos") },
		Location = { BZ["Azshara"]..ALC["Comma"]..BZ["Kalimdor"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		{ WHIT.." 1) "..Atlas_GetBossName("Azuregos") },
	},
	FourDragons = {
		ZoneName = { L["Dragons of Nightmare"] },
		Location = { L["Various"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		{ WHIT.." 1) "..BZ["Twilight Grove"].._RED..ALC["Comma"]..BZ["Duskwood"]..ALC["Comma"]..BZ["Eastern Kingdoms"] },
		{ WHIT.." 2) "..BZ["Seradane"].._RED..ALC["Comma"]..BZ["The Hinterlands"]..ALC["Comma"]..BZ["Eastern Kingdoms"] },
		{ WHIT..INDENT..Atlas_GetBossName("Rothos") },
		{ WHIT..INDENT..Atlas_GetBossName("Dreamtracker") },
		{ WHIT.." 3) "..BZ["Dream Bough"].._RED..ALC["Comma"]..BZ["Feralas"]..ALC["Comma"]..BZ["Kalimdor"] },
		{ WHIT..INDENT..Atlas_GetBossName("Lethlas") },
		{ WHIT..INDENT..Atlas_GetBossName("Dreamroarer") },
		{ WHIT.." 3) "..BZ["Bough Shadow"].._RED..ALC["Comma"]..BZ["Ashenvale"]..ALC["Comma"]..BZ["Kalimdor"] },
		{ WHIT..INDENT..Atlas_GetBossName("Phantim") },
		{ WHIT..INDENT..Atlas_GetBossName("Dreamstalker") },
		{ "" };
		{ WHIT..L["The Dragons"] };
		{ WHIT..INDENT..Atlas_GetBossName("Lethon") };
		{ WHIT..INDENT..Atlas_GetBossName("Emeriss") };
		{ WHIT..INDENT..Atlas_GetBossName("Taerar") };
		{ WHIT..INDENT..Atlas_GetBossName("Ysondre") };
	},


}

local myDB = {

}

Atlas:RegisterPlugin(private.addon_name, myCategory, myData, myDB)
