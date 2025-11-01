-- $Id: Data.lua 88 2023-03-20 15:06:02Z arithmandar $
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
	return Atlas:GetBossName(bossname, encounterID, creatureIndex, private.module_name)
end

local myData = {
	OR_DragonIsles = {
		ZoneName = { L["Dragon Isles World Bosses"] },
		Location = { BZ["Dragon Isles"] },
		LevelRange = "70+",
		PlayerLimit = "40",
		JournalInstanceID = 1205,
		WorldMapID = 1978,
		ALModule = "Atlas_BattleforAzeroth",
		{ WHIT.." 1) "..Atlas_GetBossName("Strunraan, The Sky's Misery", 2515), 2515 },
		{ WHIT.." 2) "..Atlas_GetBossName("Liskanoth, The Futurebane", 2518), 2518 },
		{ WHIT.." 3) "..Atlas_GetBossName("Bazual, The Dreaded Flame", 2517), 2517 },
		{ WHIT.." 3) "..Atlas_GetBossName("Basrikron, The Shale Wing", 2506), 2506 },
	},
	OR_KulTiras = {
		ZoneName = { L["Kul Tiras World Bosses"] },
		Location = { BZ["Kul Tiras"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		JournalInstanceID = 1028,
		WorldMapID = 876,
		ALModule = "Atlas_BattleforAzeroth",
		{ WHIT.." 1) "..Atlas_GetBossName("Warbringer Yenajz", 2198), 2198 },
		{ WHIT.." 2) "..Atlas_GetBossName("Azurethos, The Winged Typhoon", 2199), 2199 },
		{ WHIT.." 3) "..Atlas_GetBossName("Hailstone Construct", 2197), 2197 },
	},
	OR_Zandalar = {
		ZoneName = { L["Zandalar World Bosses"] },
		Location = { BZ["Zandalar"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		JournalInstanceID = 1028,
		WorldMapID = 875,
		ALModule = "Atlas_BattleforAzeroth",
		{ WHIT.." 1) "..Atlas_GetBossName("Dunegorger Kraulok", 2210), 2210 },
		{ WHIT..INDENT..Atlas_GetBossName("Ravenous Ranishu", 2210, 2) },
		{ WHIT.." 2) "..Atlas_GetBossName("Ji'arak", 2141), 2141 },
		{ WHIT..INDENT..Atlas_GetBossName("Ji'arak Broodling", 2141, 2) },
		{ WHIT.." 3) "..Atlas_GetBossName("T'zane", 2139), 2139 },
	},
	OR_Azeroth = {
		ZoneName = { L["Eastern Kingdoms World Bosses"] },
		Location = { BZ["Eastern Kingdoms"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		JournalInstanceID = 1028,
		WorldMapID = 13,
		ALModule = "Atlas_BattleforAzeroth",
		{ WHIT.." 1) "..Atlas_GetBossName("The Lion's Roar", 2212), 2212 },
		{ WHIT..INDENT..Atlas_GetBossName("Lion's Engineer", 2212, 2) },
		{ WHIT..INDENT..Atlas_GetBossName("Lion's Shieldbearer", 2212, 3) },
		{ WHIT..INDENT..Atlas_GetBossName("Lion's Warcaster", 2212, 4) },
		{ WHIT.." 2) "..Atlas_GetBossName("Doom's Howl", 2213), 2213 },
		{ WHIT..INDENT..Atlas_GetBossName("Doom's Howl Engineer", 2213, 2) },
		{ WHIT..INDENT..Atlas_GetBossName("Doom's Howl Dreadshield", 2213, 3) },
		{ WHIT..INDENT..Atlas_GetBossName("Doom's Howl Warcaster", 2213, 4) },
	},
	OR_Kalimdor = {
		ZoneName = { L["Kalimdor World Bosses"] },
		Location = { BZ["Kalimdor"] },
		LevelRange = "60+",
		PlayerLimit = "40",
		JournalInstanceID = 1028,
		WorldMapID = 12,
		ALModule = "Atlas_BattleforAzeroth",
		{ WHIT.." 1) "..Atlas_GetBossName("Ivus the Forest Lord", 2329), 2329 },
		{ WHIT.." 2) "..Atlas_GetBossName("Ivus the Decayed", 2345), 2345 },
	},
	OR_BrokenIsles = {
		ZoneName = { L["Broken Isles World Bosses"] },
		Location = { BZ["Broken Isles"] },
		LevelRange = "45+",
		PlayerLimit = "40",
		JournalInstanceID = 822,
		WorldMapID = 619,
		LargeMap = "OR_BrokenIsles",
		ALModule = "Atlas_Legion",
		{ WHIT.." 1) "..Atlas_GetBossName("Calamir", 1774)..ORNG..ALC["L-Parenthesis"]..sBF("Court of Farondis")..ALC["R-Parenthesis"], 1774 },		-- (Azsuna)
		{ WHIT.." 2) "..Atlas_GetBossName("Withered J'im", 1796)..ORNG..ALC["L-Parenthesis"]..sBF("The Wardens")..ALC["R-Parenthesis"], 1796 },		-- (Azsuna)
		{ WHIT.." 3) "..Atlas_GetBossName("Levantus", 1769)..ORNG..ALC["L-Parenthesis"]..sBF("Court of Farondis")..ALC["R-Parenthesis"], 1769 },	-- (Azsuna)
		{ WHIT.." 4) "..Atlas_GetBossName("Humongris", 1770), 1770 },				-- (Val'sharah)
		{ WHIT.." 5) "..Atlas_GetBossName("Shar'thos", 1763), 1763 },				-- (Val'sharah)
		{ WHIT.." 6) "..Atlas_GetBossName("Drugon the Frostblood", 1789), 1789 },		-- (Highmountain)
		{ WHIT.." 7) "..Atlas_GetBossName("Flotsam", 1795)..ORNG..ALC["L-Parenthesis"]..sBF("Highmountain Tribe")..ALC["R-Parenthesis"], 1795 },	-- (Highmountain)
		{ WHIT.." 8) "..Atlas_GetBossName("Ana-Mouz", 1790)..ORNG..ALC["L-Parenthesis"]..sBF("The Nightfallen")..ALC["R-Parenthesis"], 1790 },		-- (Stormheim)
		{ WHIT.." 9) "..Atlas_GetBossName("The Soultakers", 1756), 1756 },			-- (Stormheim)
		{ INDENT..WHIT..Atlas_GetBossName("Soultrapper Mevra", 1756, 1), 1756 },
		{ INDENT..WHIT..Atlas_GetBossName("Captain Hring", 1756, 2), 1756 },
		{ INDENT..WHIT..Atlas_GetBossName("Reaver Jdorn", 1756, 3), 1756 },
		{ WHIT.."10) "..Atlas_GetBossName("Nithogg", 1749), 1749 },				-- (Stormheim)
		{ WHIT.."11) "..Atlas_GetBossName("Na'zak the Fiend", 1783), 1783 },			-- (Suramar)
		{ WHIT.."12) "..Atlas_GetBossName("Brutallus", 1883)..ORNG..ALC["L-Parenthesis"]..sBF("Armies of Legionfall")..ALC["R-Parenthesis"], 1883 },
		{ WHIT.."13) "..Atlas_GetBossName("Malificus", 1884)..ORNG..ALC["L-Parenthesis"]..sBF("Armies of Legionfall")..ALC["R-Parenthesis"], 1884 },
		{ WHIT.."14) "..Atlas_GetBossName("Si'vash", 1885)..ORNG..ALC["L-Parenthesis"]..sBF("Armies of Legionfall")..ALC["R-Parenthesis"], 1885 },
		{ WHIT.."15) "..Atlas_GetBossName("Apocron", 1956)..ORNG..ALC["L-Parenthesis"]..sBF("Armies of Legionfall")..ALC["R-Parenthesis"], 1956 },
		{ "" },
		{ LBLU..ACHIEVEMENTS..ALC["Colon"] },
		{ "Unleashed Monstrosities", "ac=11160" },
		{ "Terrors of the Shore", "ac=11786" },
	},
	OR_BrokenShore = {
		ZoneName = { L["Broken Shore World Bosses"] },
		Location = { BZ["Broken Shore"] },
		LevelRange = "45+",
		PlayerLimit = "40",
		JournalInstanceID = 822,
		WorldMapID = 646,
		LargeMap = "OR_BrokenShore",
		ALModule = "Atlas_Legion",
		{ WHIT.."12) "..Atlas_GetBossName("Brutallus", 1883), 1883 },
		{ WHIT.."13) "..Atlas_GetBossName("Malificus", 1884), 1884 },
		{ INDENT..ORNG..ALC["L-Parenthesis"]..sBF("Armies of Legionfall")..ALC["R-Parenthesis"] },
		{ WHIT.."14) "..Atlas_GetBossName("Si'vash", 1885), 1885 },
		{ WHIT.."15) "..Atlas_GetBossName("Apocron", 1956), 1956 },
		{ "" },
		{ LBLU..ACHIEVEMENTS..ALC["Colon"] },
		{ "Terrors of the Shore", "ac=11786" },
	},
	OR_Draenor = {
		ZoneName = { L["Draenor World Bosses"] },
		Location = { BZ["Draenor"] },
		LevelRange = "40+",
		PlayerLimit = "--",
		JournalInstanceID = 557,
		WorldMapID = 572,
		LargeMap = "OR_Draenor",
		ALModule = "Atlas_WarlordsofDraenor",
		{ WHIT.." 1) "..Atlas_GetBossName("Drov the Ruiner", 1291), 1291 },
		{ WHIT..INDENT..Atlas_GetBossName("Frenzied Rumbler", 1291, 2), 1291 },
		{ WHIT.." 2) "..Atlas_GetBossName("Tarlna the Ageless", 1211), 1211 },
		{ WHIT..INDENT..Atlas_GetBossName("Giant Lasher", 1211, 3), 1211 },
		{ WHIT..INDENT..Atlas_GetBossName("Untamed Mandragora", 1211, 2), 1211 },
		{ WHIT.." 3) "..Atlas_GetBossName("Rukhmar", 1262), 1262 },
		{ WHIT.." 4) "..Atlas_GetBossName("Supreme Lord Kazzak", 1452), 1452 },
		{ "" },
		{ LBLU..ACHIEVEMENTS..ALC["Colon"] },
		{ "Goliaths of Gorgrond", "ac=9423" },
		{ "So Grossly Incandescent", "ac=9425" },
		{ "The Legion Will NOT Conquer All", "ac=10071" },
	},
	OR_Pandaria = {
		ZoneName = { L["Pandaria World Bosses"] },
		Location = { BZ["Pandaria"] },
		LevelRange = "35+",
		PlayerLimit = "--",
		JournalInstanceID = 322,
		WorldMapID = 424,
		LargeMap = "OR_Pandaria",
		ALModule = "Atlas_MistsofPandaria",
		{ WHIT.." 1) "..Atlas_GetBossName("Nalak, The Storm Lord", 814), 814 },
		{ WHIT.." 2) "..Atlas_GetBossName("Oondasta", 826), 826 },
		{ WHIT.." 3) "..Atlas_GetBossName("Sha of Anger", 691), 691 },
		{ WHIT.." 4) "..Atlas_GetBossName("Salyis's Warband", 725), 725 },
		{ WHIT..INDENT..Atlas_GetBossName("Galleon", 725, 1), 725 },
		{ WHIT..INDENT..Atlas_GetBossName("Chief Salyis", 725, 2), 725 },
		{ WHIT.." 5) "..Atlas_GetBossName("Ordos, Fire-God of the Yaungol", 861), 861 },
		{ WHIT.." 6) "..sBF("The August Celestials") },
		{ WHIT..INDENT..Atlas_GetBossName("Chi-Ji, The Red Crane", 857), 857 },
		{ WHIT..INDENT..Atlas_GetBossName("Niuzao, The Black Ox", 859), 859 },
		{ WHIT..INDENT..Atlas_GetBossName("Xuen, The White Tiger", 860), 860 },
		{ WHIT..INDENT..Atlas_GetBossName("Yu'lon, The Jade Serpent", 858), 858 },
		{ "" },
		{ LBLU..ACHIEVEMENTS..ALC["Colon"] },
		{ "Praise the Sun!", "ac=8028" },
		{ "Millions of Years of Evolution vs. My Fist", "ac=8123" },
		{ "Settle Down, Bro", "ac=6480" },
		{ "Extinction Event", "ac=6517" },
		{ "Celestial Challenge", "ac=8535" },
	},
	OR_Skettis = {
		ZoneName = { BZ["Skettis"] },
		Location = { BZ["Blackwind Valley"]..", "..BZ["Terokkar Forest"] },
		LevelRange = "30+",
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
		Location = { BZ["Hellfire Peninsula"] },
		LevelRange = "30+",
		PlayerLimit = "40",
		{ WHIT.."1) "..Atlas_GetBossName("Doom Lord Kazzak"), 10001 },
		{ WHIT.."2) "..BZ["Invasion Point: Annihilator"], 10002 },
		{ WHIT.."3) "..BZ["Forge Camp: Rage"], 10003 },
		{ WHIT.."4) "..BZ["Forge Camp: Mageddon"], 10004 },
		{ WHIT.."5) "..BZ["Thrallmar"], 10005 },
	},
	OR_Doomwalker = {
		ZoneName = { Atlas_GetBossName("Doomwalker") },
		Location = { BZ["Shadowmoon Valley"] },
		LevelRange = "30+",
		PlayerLimit = "40",
		{ WHIT.."1) "..Atlas_GetBossName("Doomwalker"), 10001 },
	},
}

local myDB = {
	OR_DragonIsles = {
		{ 1, 2515, 294, 348 },
		{ 2, 2518, 20, 20 },
		{ 3, 2517, 20, 60 },
		{ 3, 2506, 20, 100 },
	},
	OR_KulTiras = {
		{ 1, 2198, 407, 128 },
		{ 2, 2199, 310, 247 },
		{ 3, 2197, 197, 399 },
	},
	OR_Zuldazar = {
		{ 1, 2210, 136, 146 },
		{ 2, 2141, 364, 277 },
		{ 3, 2139, 271, 119 },
	},
	OR_Azeroth = {
		{ 1, 2212, 283, 147 },
		{ 2, 2213, 276, 155 },
	},
	OR_Kalimdor = {
		{ 1, 2329, 223, 102 },
		{ 2, 2345, 213, 113 },
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
	OR_BrokenIsles = {
		{  1, 1774, 114, 378, 327, 499 }, -- Calamir
		{  2, 1796, 152, 375, 374, 502 }, -- Withered J'im
		{  3, 1769, 130, 347, 341, 460 }, -- Levantus
		{  4, 1770,  78, 201, 281, 274 }, -- Humongris
		{  5, 1763, 149, 159, 363, 209 }, -- Shar'thos
		{  6, 1789, 274, 150, 525, 201 }, -- Drugon the Frostblood
		{  7, 1795, 249,  22, 492, 39 }, -- Flotsam
		{  8, 1790, 217, 261, 457, 342 }, -- Ana-Mouz
		{  9, 1756, 405,  98, 689, 132 }, -- The Soultakers
		{ 10, 1749, 323, 133, 605, 177 }, -- Nithogg
		{ 11, 1783, 180, 232, 412, 310 }, -- Na'zak the Fiend
		{ 12, 1883, 315, 340, 580, 441 }, -- Brutallus
		{ 13, 1884, 308, 333, 570, 438 }, -- Malificus
		{ 14, 1885, 363, 338, 639, 442 }, -- Si'vash
		{ 15, 1956, 315, 369, 581, 482 }, -- Apocron
	},
	OR_BrokenShore = {
		{ 12, 1883, 263, 175, 428, 196 }, -- Brutallus
		{ 13, 1884, 251, 168, 415, 192 }, -- Malificus
		{ 14, 1885, 478, 185, 778, 207 }, -- Si'vash
		{ 15, 1956, 269, 333, 441, 452 }, -- Apocron
	},
	OR_Draenor = {
		{ 1, 1291, 271, 119, 517, 153 }, -- Drov the Ruiner
		{ 2, 1211, 286, 207, 537, 282 }, -- Tarlna the Ageless
		{ 3, 1262, 274, 424, 519, 588 }, -- Rukhmar
		{ 4, 1452, 351, 203, 637, 268 }, -- Supreme Lord Kazzak
	},
	OR_Pandaria = {
		{ 1, 814,  58,  81, 217, 91 }, -- Nalak, The Storm Lord
		{ 2, 826, 219,  70, 475, 66 }, -- Oondasta
		{ 3, 691, 240, 211, 513, 295 }, -- Sha of Anger
		{ 4, 725, 270, 324, 552, 482 }, -- Salyis's Warband
		{ 5, 861, 463, 310, 870, 458 }, -- Ordos, Fire-God of the Yaungol
		{ 6, 857, 450, 321, 849, 473 }, -- Chi-Ji, The Red Crane
		{ 6, 859, 464, 321, 864, 473 }, -- Niuzao, The Black Ox
		{ 6, 860, 450, 337, 850, 494 }, -- Xuen, The White Tiger
		{ 6, 858, 464, 337, 864, 494 }, -- Yu'lon, The Jade Serpent
	},
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
}

Atlas:RegisterPlugin(private.addon_name, myCategory, myData, myDB)
