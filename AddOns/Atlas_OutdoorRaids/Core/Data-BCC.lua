-- $Id: Data-BCC.lua 88 2023-03-20 15:06:02Z arithmandar $
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
	HighlordKruul = {
		ZoneName = { Atlas_GetBossName("Highlord Kruul") };
		Location = { BZ["Blasted Lands"]..ALC["Comma"]..BZ["Eastern Kingdoms"] };
		LevelRange = "60+";
		MinLevel = "--";
		PlayerLimit = "40";
		{ WHIT.."1) "..Atlas_GetBossName("Highlord Kruul") };
		{ WHIT.."2) "..BZ["Nethergarde Keep"] };
	},
	OR_Skettis = {
		ZoneName = { BZ["Skettis"] },
		Location = { BZ["Blackwind Valley"]..ALC["Comma"]..BZ["Terokkar Forest"]..ALC["Comma"]..BZ["Outland"] },
		LevelRange = "70+",
		PlayerLimit = "40",
		{ WHIT.."1) "..BZ["Blackwind Landing"], 10001 },
		{ WHIT..INDENT..L["Sky Commander Adaris"] },
		{ WHIT..INDENT..L["Sky Sergeant Doryn"] },
		{ WHIT..INDENT..L["Skyguard Handler Deesak"] },
		{ WHIT..INDENT..L["Severin <Skyguard Medic>"] },
		{ WHIT..INDENT..L["Grella <Skyguard Quartermaster>"] },
		{ WHIT..INDENT..L["Hazzik"] },
		{ WHIT.."2) "..L["Ancient Skull Pile"], 10002 },
		{ WHIT..INDENT..L["Terokk"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"] },
		{ WHIT.."3) "..L["Sahaak <Keeper of Scrolls>"], 10003 },
		{ WHIT.."4) "..L["Skyguard Prisoner"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["R-Parenthesis"], 10004 },
		{ WHIT.."5) "..L["Talonpriest Ishaal"], 10005 },
		{ WHIT.."6) "..L["Talonpriest Skizzik"], 10006 },
		{ WHIT.."7) "..L["Talonpriest Zellek"], 10007 },
		{ WHIT.."8) "..L["Hazzik's Package"], 10008 },
		{ WHIT.."9) "..ALC["Graveyard"], 10009 },
		{ GREN.."1') "..L["Skull Pile"], 10010 },
		{ GREN..INDENT..L["Darkscreecher Akkarai"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"] },
		{ GREN..INDENT..L["Gezzarak the Huntress"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"] },
		{ GREN..INDENT..L["Karrog"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"] },
		{ GREN..INDENT..L["Vakkiz the Windrager"]..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"] },
	},
	OR_DoomLordKazzak = {
		ZoneName = { Atlas_GetBossName("Doom Lord Kazzak") },
		Location = { BZ["Hellfire Peninsula"]..ALC["Comma"]..BZ["Outland"] },
		LevelRange = "70+",
		PlayerLimit = "40",
		{ WHIT.."1) "..Atlas_GetBossName("Doom Lord Kazzak"), 10001 },
		{ WHIT.."2) "..BZ["Invasion Point: Annihilator"], 10002 },
		{ WHIT.."3) "..BZ["Forge Camp: Rage"], 10003 },
		{ WHIT.."4) "..BZ["Forge Camp: Mageddon"], 10004 },
		{ WHIT.."5) "..BZ["Thrallmar"], 10005 },
	},
	OR_Doomwalker = {
		ZoneName = { Atlas_GetBossName("Doomwalker") },
		Location = { BZ["Shadowmoon Valley"]..ALC["Comma"]..BZ["Outland"] },
		LevelRange = "70+",
		PlayerLimit = "40",
		{ WHIT.."1) "..Atlas_GetBossName("Doomwalker"), 10001 },
	},
}

local myDB = {
	OR_Skettis = { 
		{ 1, 10001, 187, 67 },
		{ 2, 10002, 244, 270 },
		{ 3, 10003, 264, 308 },
		{ 4, 10004, 113, 235 },
		{ 4, 10004, 305, 211 },
		{ 4, 10004, 477, 428 },
		{ 5, 10005, 322, 286 },
		{ 6, 10006, 335, 345 },
		{ 7, 10007, 345, 213 },
		{ 8, 10008, 463, 316 },
		{ 9, 10009, 148, 339 },
		{ "1'", 10010, 137, 223 },
		{ "1'", 10010, 119, 284 },
		{ "1'", 10010, 337, 226 },
		{ "1'", 10010, 347, 307 },
		{ "1'", 10010, 349, 375 },
		{ "1'", 10010, 433, 329 },
		{ "1'", 10010, 401, 457 },
		{ "1'", 10010, 479, 337 },
		{ "1'", 10010, 466, 447 },
	},
	OR_DoomLordKazzak = {
		{ 1, 10001, 296, 206 },
		{ 2, 10002, 139, 334 },
		{ 3, 10003, 234, 369 },
		{ 4, 10004, 326, 357 },
		{ 5, 10005, 158, 430 },
	},
	OR_Doomwalker = {
		{ 1, 10001, 271, 247 },
	},
}

Atlas:RegisterPlugin(private.addon_name, myCategory, myData, myDB)
