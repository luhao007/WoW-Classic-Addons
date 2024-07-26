--[[

	AtlasQuest, a World of Warcraft addon.
	Email me at mystery8@gmail.com

	This file is part of AtlasQuest.

	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

local AQInstances = {
	paths = {
-- Classic
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockDepths"] = 1,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackwingLair"] = 2,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockSpireLower"] = 3,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockSpireUpper"] = 4,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheDeadmines"] = 5,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheDeadminesEnt"] = 5,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Gnomeregan"] = 6,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_GnomereganEnt"] = 6,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMLibrary"] = 7,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMArmory"] = 8,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMCathedral"] = 9,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMGraveyard"] = 10,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Scholomance"] = 11,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ShadowfangKeep"] = 12,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheStockade"] = 13,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Stratholme"] = 14,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheSunkenTemple"] = 15,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheSunkenTempleEnt"] = 15,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Uldaman"] = 16,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_UldamanEnt"] = 16,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsA"] = 17,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsB"] = 17,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsC"] = 17,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsEnt"] = 17,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulEast"] = 18,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulNorth"] = 19,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulWest"] = 20,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Maraudon"] = 21,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_MaraudonEnt"] = 21,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RagefireChasm"] = 22,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RazorfenDowns"] = 23,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RazorfenKraul"] = 24,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_WailingCaverns"] = 25,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_WailingCavernsEnt"] = 25,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ZulFarrak"] = 26,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_MoltenCore"] = 27,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_OnyxiasLair"] = 28,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ZulGurub"] = 29,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheRuinsofAhnQiraj"] = 30,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheTempleofAhnQiraj"] = 31,
		["Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Naxxramas"] = 32,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\AlteracValleyNorth"] = 33,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\AlteracValleySouth"] = 33,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\ArathiBasin"] = 34,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\WarsongGulch"] = 35,
		["Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_FourDragons"] = 36,
		["Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_Azuregos"] = 37,
		["Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_HighlordKruul"] = 38,

-- Burning Crusade
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCHellfireRamparts"] = 40,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCBloodFurnace"] = 41,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCTheShatteredHalls"] = 42,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCMagtheridonsLair"] = 43,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheSlavePens"] = 44,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheSteamvault"] = 45,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheUnderbog"] = 46,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchAuchenaiCrypts"] = 47,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchManaTombs"] = 48,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchSethekkHalls"] = 49,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchShadowLabyrinth"] = 50,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRSerpentshrineCavern"] = 51,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CoTBlackMorass"] = 52,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CoTHyjal"] = 53,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CoTOldHillsbrad"] = 54,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_GruulsLair"] = 55,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanStart"] = 56,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanEnd"] = 56,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanEnt"] = 56,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepArcatraz"] = 57,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepBotanica"] = 58,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepMechanar"] = 59,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\EyeOfTheStorm"] = 60,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepTheEye"] = 61,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleStart"] = 62,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleBasement"] = 62,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleTop"] = 62,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\ZulAman"] = 63,
		["Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_Skettis"] = 65,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_MagistersTerrace"] = 67,
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_SunwellPlateau"] = 68,

-- Wrath of the Lich King Instances
		["Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CoTOldStratholme"] = 69,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UtgardeKeep"] = 70,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UtgardePinnacle"] = 71,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TheNexus"] = 72,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TheOculus"] = 73,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TheEyeOfEternity"] = 74,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\AzjolNerub"] = 75,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\AhnKahet"] = 76,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarHallsofStone"] = 77,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarHallsofLightning"] = 78,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\ObsidianSanctum"] = 79,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\DrakTharonKeep"] = 80,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\Gundrak"] = 81,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\VioletHold"] = 82,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\StrandOfTheAncients"] = 83,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\Naxxramas"] = 84,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\VaultOfArchavon"] = 85,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarA"] = 86,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarB"] = 86,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarC"] = 86,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarD"] = 86,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\UlduarE"] = 86,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TrialOfTheChampion"] = 87,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TrialOfTheCrusader"] = 88,
		["Interface\\AddOns\\Atlas_Battlegrounds\\Images\\IsleOfConquest"] = 89,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\FHTheForgeOfSouls"] = 90,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\TheForgeOfSouls"] = 90,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\FHPitOfSaron"] = 91,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\PitOfSaron"] = 91,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\FHHallsOfReflection"] = 92,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\HallsOfReflection"] = 92,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\IcecrownCitadelA"] = 93,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\IcecrownCitadelB"] = 93,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\IcecrownCitadelC"] = 93,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\IcecrownStart"] = 93,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\IcecrownEnd"] = 93,
		["Interface\\AddOns\\Atlas_WrathoftheLichKing\\Images\\RubySanctum"] = 94,
	},
	ids = {},
}
for path,inst in pairs(AQInstances.paths) do
	local fileId = GetFileIDFromPath(path)
	if fileId then
		AQInstances.ids[fileId] = inst
	end
end

-----------------------------------------------------------------------------
-- This functions returns AQINSTANZ with a number
-- that tells which instance is shown atm for Atlas or AlphaMap
-----------------------------------------------------------------------------
function AtlasQuest_Instanzenchecken()
	AQATLASMAP = AtlasMap:GetTextureFileID()
	if AQATLASMAP then
		AQINSTANZ = AQInstances.ids[AQATLASMAP]
		if not AQINSTANZ then
			AQINSTANZ = 66 -- Default
		end
	end
end

---------------------------
--- AQ Instance Numbers ---
---------------------------

-- These numbers have been re-organized from the Non-Classic version of AtlasQuest for sanity's sake.

-- 66  = default.  Nothing shown.

-- 1  = Blackrock Depths
-- 2  = Blackwing Lair
-- 3  = Lower Blackrock Spire
-- 4  = Upper Blackrock Spire
-- 5  = Deadmines
-- 6  = Gnomeregan
-- 7  = Scarlet Monastery: Library
-- 8  = Scarlet Monastery: Armory
-- 9  = Scarlet Monastery: Cathedral
-- 10 = Scarlet Monastery: Graveyard
-- 11 = Scholomance
-- 12 = Shadowfang Keep
-- 13 = The Stockade
-- 14 = Stratholme
-- 15 = Sunken Temple
-- 16 = Uldaman

-- 17 = Blackfathom Deeps
-- 18 = Dire Maul East
-- 19 = Dire Maul North
-- 20 = Dire Maul West
-- 21 = Maraudon
-- 22 = Ragefire Chasm
-- 23 = Razorfen Downs
-- 24 = Razorfen Kraul
-- 25 = Wailing Caverns
-- 26 = Zul'Farrak

-- 27 = Molten Core
-- 28 = Onyxia's Lair
-- 29 = Zul'Gurub
-- 30 = The Ruins of Ahn'Qiraj
-- 31 = The Temple of Ahn'Qiraj
-- 32 = Naxxramas (level 60)

-- 33 = Alterac Valley
-- 34 = Arathi Basin
-- 35 = Warsong Gulch

-- 36 = Four Dragons
-- 37 = Azuregos
-- 38 = Highlord Kruul


-- Burning Crusade Dungeons & Raids  

-- 40 = DUNGEON: Hellfire Ramparts
-- 41 = DUNGEON: Blood Furnace
-- 42 = DUNGEON: Shattered Halls
-- 43 = RAID: Magtheridon's Lair
-- 44 = DUNGEON: The Slave Pens
-- 45 = DUNGEON: The Steamvault
-- 46 = DUNGEON: The Underbog
-- 47 = DUNGEON: Auchenai Crypts
-- 48 = DUNGEON: Mana Tombs
-- 49 = DUNGEON: Sethekk Halls
-- 50 = DUNGEON: Shadow Labyrinth
-- 51 = RAID: Serpentshrine Cavern
-- 52 = DUNGEON: Black Morass
-- 53 = RAID: Battle of Mount Hyjal
-- 54 = DUNGEON: Old Hillsbrad
-- 55 = RAID: Gruul's Lair
-- 56 = RAID: Karazhan
-- 57 = DUNGEON: The Arcatraz
-- 58 = DUNGEON: Botanica
-- 59 = DUNGEON: The Mechanar
-- 60 = BATTLEGROUND: Eye of the Storm
-- 61 = RAID: The Eye
-- 62 = RAID: Black Temple
-- 63 = RAID: Zul'Aman
-- 65 = OUTDOOR: Skettis
-- 67 = DUNGEON: Magisters' Terrace
-- 68 = RAID: Sunwell Plateau


-- Wrath of the Lich King Dungeons & Raids

-- 69 = DUNGEON: Caverns of Time: Stratholme Past
-- 70 = DUNGEON: Utgarde Keep: Utgarde Keep
-- 71 = DUNGEON: Utgarde Keep: Utgarde Pinnacle
-- 72 = DUNGEON: The Nexus: The Nexus
-- 73 = DUNGEON: The Nexus: The Oculus
-- 74 = RAID: The Nexus: The Eye of Eternity
-- 75 = DUNGEON: Azjol-Nerub: The Upper Kingdom
-- 76 = DUNGEON: Azjol-Nerub: Ahn'kahet: The Old Kingdom
-- 77 = DUNGEON: Ulduar: Halls of Stone
-- 78 = DUNGEON: Ulduar: Halls of Lightning
-- 79 = RAID: The Obsidian Sanctum
-- 80 = DUNGEON: Drak'Tharon Keep
-- 81 = DUNGEON: Zul'Drak: Gundrak
-- 82 = DUNGEON: The Violet Hold
-- 83 = BATTLEGROUND: Strand of the Ancients (SotA)
-- 84 = RAID: Naxxramas (Naxx)
-- 85 = RAID: Vault of Archavon (VoA)
-- 86 = RAID: Ulduar
-- 87 = DUNGEON: Trial of the Champion (ToC)
-- 88 = RAID: Trial of the Crusader (ToC)
-- 89 = BATTLEGROUND: Isle of Conquest (IoC)
-- 90 = DUNGEON: Forge of Souls (FoS)
-- 91 = DUNGEON: Pit of Saron (PoS)
-- 92 = DUNGEON: Halls of Reflection (HoR)
-- 93 = RAID: Icecrown Citadel (ICC)
-- 94 = RAID: Ruby Sanctum (RS)