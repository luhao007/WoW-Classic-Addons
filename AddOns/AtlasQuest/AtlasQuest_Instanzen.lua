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


-----------------------------------------------------------------------------
-- This functions returns AQINSTANZ with a number
-- that tells which instance is shown atm for Atlas or AlphaMap
-----------------------------------------------------------------------------
function AtlasQuest_Instanzenchecken()
	AQATLASMAP = AtlasMap:GetTexture()


	-- Classic

	if (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockDepths") then
		AQINSTANZ = 1;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackwingLair") then
		AQINSTANZ = 2;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockSpireLower") then
		AQINSTANZ = 3;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackrockSpireUpper") then
		AQINSTANZ = 4;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheDeadmines") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheDeadminesEnt") then
		AQINSTANZ = 5;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Gnomeregan") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_GnomereganEnt") then
		AQINSTANZ = 6;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMLibrary") then
		AQINSTANZ = 7;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMArmory") then
		AQINSTANZ = 8;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMCathedral") then
		AQINSTANZ = 9;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_SMGraveyard") then
		AQINSTANZ = 10;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Scholomance") then
		AQINSTANZ = 11;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ShadowfangKeep") then
		AQINSTANZ = 12;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheStockade") then
		AQINSTANZ = 13;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Stratholme") then
		AQINSTANZ = 14;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheSunkenTemple") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheSunkenTempleEnt") then
		AQINSTANZ = 15;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Uldaman") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_UldamanEnt") then
		AQINSTANZ = 16;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsA") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsB") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsC") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_BlackfathomDeepsEnt") then
		AQINSTANZ = 17;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulEast") then
		AQINSTANZ = 18;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulNorth") then
		AQINSTANZ = 19;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_DireMaulWest") then
		AQINSTANZ = 20;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Maraudon") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_MaraudonEnt") then
		AQINSTANZ = 21;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RagefireChasm") then
		AQINSTANZ = 22;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RazorfenDowns") then
		AQINSTANZ = 23;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_RazorfenKraul") then
		AQINSTANZ = 24;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_WailingCaverns") or (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_WailingCavernsEnt") then
		AQINSTANZ = 25;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ZulFarrak") then
		AQINSTANZ = 26;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_MoltenCore") then
		AQINSTANZ = 27;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_OnyxiasLair") then
		AQINSTANZ = 28;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_ZulGurub") then
		AQINSTANZ = 29;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheRuinsofAhnQiraj") then
		AQINSTANZ = 30;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_TheTempleofAhnQiraj") then
		AQINSTANZ = 31;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_ClassicWoW\\Images\\CL_Naxxramas") then
		AQINSTANZ = 32;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_Battlegrounds\\Images\\AlteracValleyNorth") then
		AQINSTANZ = 33;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_Battlegrounds\\Images\\AlteracValleySouth") then
		AQINSTANZ = 33;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_Battlegrounds\\Images\\ArathiBasin") then
		AQINSTANZ = 34;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_Battlegrounds\\Images\\WarsongGulch") then
		AQINSTANZ = 35;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_FourDragons")  then
		AQINSTANZ = 36;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_Azuregos")  then
		AQINSTANZ = 37;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_HighlordKruul")  then
		AQINSTANZ = 38;


		
	-- Burning Crusade
	
	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCHellfireRamparts") then
		AQINSTANZ = 40;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCBloodFurnace") then
		AQINSTANZ = 41;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCTheShatteredHalls") then
		AQINSTANZ = 42;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_HCMagtheridonsLair") then
		AQINSTANZ = 43;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheSlavePens") then
		AQINSTANZ = 44;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheSteamvault") then
		AQINSTANZ = 45;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRTheUnderbog") then
		AQINSTANZ = 46;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchAuchenaiCrypts") then
		AQINSTANZ = 47;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchManaTombs") then
		AQINSTANZ = 48;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchSethekkHalls") then
		AQINSTANZ = 49;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_AuchShadowLabyrinth") then
		AQINSTANZ = 50;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CFRSerpentshrineCavern") then
		AQINSTANZ = 51;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CoTBlackMorass") then
		AQINSTANZ = 52;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CoTHyjal") then
		AQINSTANZ = 53;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_CoTOldHillsbrad") then
		AQINSTANZ = 54;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_GruulsLair") then
		AQINSTANZ = 55;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanStart") or (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanEnd") or (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_KarazhanEnt") then
		AQINSTANZ = 56;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepArcatraz") then
		AQINSTANZ = 57;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepBotanica") then
		AQINSTANZ = 58;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepMechanar") then
		AQINSTANZ = 59;

	elseif (AQATLASMAP ==  "Interface\\AddOns\\Atlas_Battlegrounds\\Images\\EyeOfTheStorm") then
		AQINSTANZ = 60;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_TempestKeepTheEye") then
		AQINSTANZ = 61;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleStart") or (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleBasement") or (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_BlackTempleTop") then
		AQINSTANZ = 62;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_OutdoorRaids\\Images\\OR_Skettis")  then
		AQINSTANZ = 65;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_MagistersTerrace") then
		AQINSTANZ = 67;

	elseif (AQATLASMAP == "Interface\\AddOns\\Atlas_BurningCrusade\\Images\\CL_SunwellPlateau") then
		AQINSTANZ = 68;



	-- Default

	else 
		AQINSTANZ = 66;
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


