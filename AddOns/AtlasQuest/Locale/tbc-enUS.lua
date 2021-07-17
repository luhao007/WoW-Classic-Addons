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


------------  TBC CLASSIC  ------------

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




---------------
--- COLOURS ---
---------------

local GREY = "|cff999999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff66cc33";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local YELLOW = "|cffFFd200";   -- Ingame Yellow





--------------- INST40 - Hellfire Ramparts ---------------

Inst40Caption = "Hellfire Ramparts"
Inst40QAA = "3 Quests"
Inst40QAH = "3 Quests"

--Quest 1 Alliance
Inst40Quest1 = "1. Weaken the Ramparts"
Inst40Quest1_Aim = "Slay Watchkeeper Gargolmar, Omor the Unscarred and the drake, Nazan. Return Gargolmar's Hand, Omor's Hoof and Nazan's Head to Gunny at Honor Hold in Hellfire Peninsula."
Inst40Quest1_Location = "Lieutenant Chadwick (Hellfire Peninsula - Honor Hold; "..YELLOW.."56.6, 66.4"..WHITE..")"
Inst40Quest1_Note = "Gargolmar is at "..YELLOW.."[1]"..WHITE..", Omor is at "..YELLOW.."[2]"..WHITE.." and Nazan is at "..YELLOW.."[3]"..WHITE..".  Gunny is at (Hellfire Peninsula - Honor Hold; "..YELLOW.."56.4, 66.6"..WHITE.."). \n\nTo get this quest, you must complete 'Ill Omens', which starts with 'Know your Enemy' from Force Commander Dannath Trollbane (Hellfire Peninsula - Honor Hold; "..YELLOW.."56.6, 66.6"..WHITE..")."
Inst40Quest1_Prequest = "Know your Enemy -> Ill Omens"
Inst40Quest1_Folgequest = "Heart of Rage ("..YELLOW.."HFC: Blood Furnace"..WHITE..")"
--
Inst40Quest1name1 = "Handguards of Precision"
Inst40Quest1name2 = "Jade Warrior Pauldrons"
Inst40Quest1name3 = "Mantle of Magical Might"
Inst40Quest1name4 = "Sure-Step Boots"

--Quest 2 Alliance
Inst40Quest2 = "2. Dark Tidings"
Inst40Quest2_Aim = "Take the Ominous Letter to Force Commander Danath Trollbane at Honor Hold in Hellfire Peninsula."
Inst40Quest2_Location = "Ominous Letter (drops from Vazruden the Herald; "..YELLOW.."[3]"..WHITE..")"
Inst40Quest2_Note = "Force Commander Danath Trollbane is at "..YELLOW.."56.6, 66.6"..WHITE.." in Honor Hold."
Inst40Quest2_Prequest = "None"
Inst40Quest2_Folgequest = "The Blood is Life ("..YELLOW.."HFC: Blood Furnace"..WHITE..")"
-- No Rewards for this quest

--Quest 3 Alliance
Inst40Quest3 = "3. Wanted: Nazan's Riding Crop"
Inst40Quest3_Aim = "Wind Trader Zhareem has asked you to obtain Nazan's Riding Crop. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst40Quest3_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst40Quest3_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nNazan is the final boss."
Inst40Quest3_Prequest = "None"
Inst40Quest3_Folgequest = "None"
--
Inst40Quest3name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance - different NPCs and pre-quest)
Inst40Quest1_HORDE = Inst40Quest1
Inst40Quest1_HORDE_Aim = "Slay Watchkeeper Gargolmar, Omor the Unscarred and the drake, Nazan. Return Gargolmar's Hand, Omor's Hoof and Nazan's Head to Caza'rez at Thrallmar in Hellfire Peninsula."
Inst40Quest1_HORDE_Location = "Stone Guard Stok'ton (Hellfire Peninsula - Thrallmar; "..YELLOW.."55.2, 36.0"..WHITE..")"
Inst40Quest1_HORDE_Note = "Gargolmar is at "..YELLOW.."[1]"..WHITE..", Omor is at "..YELLOW.."[2]"..WHITE.." and Nazan is at "..YELLOW.."[3]"..WHITE..". Caza'rez is at (Hellfire Peninsula - Thrallmar; "..YELLOW.."54.8, 36.0"..WHITE.."). \n\nTo get this quest, you must complete 'Forward Base: Reaver's Fall', which starts with the 'Through the Dark Portal' quest you receive at the Dark Portal in Blasted Lands."
Inst40Quest1_HORDE_Prequest = "Through the Dark Portal -> Forward Base: Reaver's Fall"
Inst40Quest1_HORDE_Folgequest = Inst40Quest1_Folgequest
--
Inst40Quest1name1_HORDE = Inst40Quest1name1
Inst40Quest1name2_HORDE = Inst40Quest1name2
Inst40Quest1name3_HORDE = Inst40Quest1name3
Inst40Quest1name4_HORDE = Inst40Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance - different NPC to turn in)
Inst40Quest2_HORDE = Inst40Quest2
Inst40Quest2_HORDE_Aim = "Take the Ominous Letter to Nazgrel at Thrallmar in Hellfire Peninsula."
Inst40Quest2_HORDE_Location = Inst40Quest2_Location
Inst40Quest2_HORDE_Note = "Nazgrel is at "..YELLOW.."55.0, 36.0"..WHITE.." in Thrallmar."
Inst40Quest2_HORDE_Prequest = Inst40Quest2_Prequest
Inst40Quest2_HORDE_Folgequest = Inst40Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst40Quest3_HORDE = Inst40Quest3
Inst40Quest3_HORDE_Aim = Inst40Quest3_Aim
Inst40Quest3_HORDE_Location = Inst40Quest3_Location
Inst40Quest3_HORDE_Note = Inst40Quest3_Note
Inst40Quest3_HORDE_Prequest = Inst40Quest3_Prequest
Inst40Quest3_HORDE_Folgequest = Inst40Quest3_Folgequest
--
Inst40Quest3name1_HORDE = Inst40Quest3name1



--------------- INST41 - Blood Furnace ---------------

Inst41Caption = "The Blood Furnace"
Inst41QAA = "3 Quests"
Inst41QAH = "3 Quests"

--Quest 1 Alliance
Inst41Quest1 = "1. The Blood is Life"
Inst41Quest1_Aim = "Collect 10 Fel Orc Blood Vials and return them to Gunny at Honor Hold in Hellfire Peninsula."
Inst41Quest1_Location = "Gunny (Hellfire Peninsula - Honor Hold; "..YELLOW.."56,67"..WHITE..")"
Inst41Quest1_Note = "All Orcs in Blood Furnace can drop the Blood Vials."
Inst41Quest1_Prequest = "Dark Tidings ("..YELLOW.."Hellfire Ramparts"..WHITE..")"
Inst41Quest1_Folgequest = "None"
--
Inst41Quest1name1 = "Breastplate of Retribution"
Inst41Quest1name2 = "Deadly Borer Leggings"
Inst41Quest1name3 = "Moonkin Headdress"
Inst41Quest1name4 = "Scaled Legs of Ruination"

--Quest 2 Alliance
Inst41Quest2 = "2. Heart of Rage"
Inst41Quest2_Aim = "Fully investigate the Blood Furnace and then report to Force Commander Danath Trollbane at Honor Hold in Hellfire Peninsula."
Inst41Quest2_Location = "Gunny (Hellfire Peninsula - Honor Hold; "..YELLOW.."56,67"..WHITE..")."
Inst41Quest2_Note = "Quest completes in room with final boss.  Force Commander Danath Trollbane is at "..YELLOW.."57,67"..WHITE.." in Honor Hold."
Inst41Quest2_Prequest = "Weaken the Ramparts ("..YELLOW.."Hellfire Ramparts"..WHITE..")"
Inst41Quest2_Folgequest = "None"
--
Inst41Quest2name1 = "Crimson Pendant of Clarity"
Inst41Quest2name2 = "Holy Healing Band"
Inst41Quest2name3 = "Perfectly Balanced Cape"

--Quest 3 Alliance
Inst41Quest3 = "3. Wanted: Keli'dan's Feathered Stave"
Inst41Quest3_Aim = "Wind Trader Zhareem has asked you to obtain Keli'dan's Feathered Stave. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst41Quest3_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst41Quest3_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nKeli'dan the Breaker is at "..YELLOW.."[3]"..WHITE.."."
Inst41Quest3_Prequest = "None"
Inst41Quest3_Folgequest = "None"
--
Inst41Quest3name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance - different NPC to turn in)
Inst41Quest1_HORDE = Inst41Quest1
Inst41Quest1_HORDE_Aim = "Collect 10 Fel Orc Blood Vials and return them to Centurion Caza'rez at Thrallmar in Hellfire Peninsula."
Inst41Quest1_HORDE_Location = "Caza'rez (Hellfire Peninsula - Thrallmar; "..YELLOW.."55,36"..WHITE..")"
Inst41Quest1_HORDE_Note = Inst41Quest1_Note
Inst41Quest1_HORDE_Prequest = Inst41Quest1_Prequest
Inst41Quest1_HORDE_Folgequest = Inst41Quest1_Folgequest
--
Inst41Quest1name1_HORDE = Inst41Quest1name1
Inst41Quest1name2_HORDE = Inst41Quest1name2
Inst41Quest1name3_HORDE = Inst41Quest1name3
Inst41Quest1name4_HORDE = Inst41Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance - different NPC to turn in)
Inst41Quest2_HORDE = Inst41Quest2
Inst41Quest2_HORDE_Aim = "Fully investigate the Blood Furnace and then report to Nazgrel at Thrallmar in Hellfire Peninsula."
Inst41Quest2_HORDE_Location = "Caza'rez (Hellfire Peninsula - Thrallmar; "..YELLOW.."55,36"..WHITE..")"
Inst41Quest2_HORDE_Note = "Quest completes in room with final boss. Nazgrel is at Hellfire Peninsula - Thrallmar ("..YELLOW.."55,36"..WHITE..")."
Inst41Quest2_HORDE_Prequest = Inst41Quest2_Prequest
Inst41Quest2_HORDE_Folgequest = Inst41Quest2_Folgequest
--
Inst41Quest2name1_HORDE = Inst41Quest2name1
Inst41Quest2name2_HORDE = Inst41Quest2name2
Inst41Quest2name3_HORDE = Inst41Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst41Quest3_HORDE = Inst41Quest3
Inst41Quest3_HORDE_Aim = Inst41Quest3_Aim
Inst41Quest3_HORDE_Location = Inst41Quest3_Location
Inst41Quest3_HORDE_Note = Inst41Quest3_Note
Inst41Quest3_HORDE_Prequest = Inst41Quest3_Prequest
Inst41Quest3_HORDE_Folgequest = Inst41Quest3_Folgequest
--
Inst41Quest3name1_HORDE = Inst41Quest3name1



--------------- INST42 - Shattered Halls ---------------

Inst42Caption = "Shattered Halls"
Inst42QAA = "10 Quests"
Inst42QAH = "9 Quests"

--Quest 1 Alliance
Inst42Quest1 = "1. Fel Embers"
Inst42Quest1_Aim = "Magus Zabraxis at Honor Hold wants you to bring her a Fel Ember"
Inst42Quest1_Location = "Magus Zabraxis (Hellfire Peninsula - Honor Hold; "..YELLOW.."54,66"..WHITE..")"
Inst42Quest1_Note = "After killing Grand Warlock Netherkurse at "..YELLOW.."[2]"..WHITE..", he'll drop an Amulet. Use the amulet at one of the braziers near his throne to get the Fel Ember."
Inst42Quest1_Prequest = "None"
Inst42Quest1_Folgequest = "None"
--
Inst42Quest1name1 = "Curate's Boots"
Inst42Quest1name2 = "Rune-Engraved Belt"
Inst42Quest1name3 = "Gloves of Preservation"
Inst42Quest1name4 = "Expedition Scout's Epaulets"
Inst42Quest1name5 = "Dauntless Handguards"

--Quest 2 Alliance
Inst42Quest2 = "2. Pride of the Fel Horde"
Inst42Quest2_Aim = "Field Commander Romus at Honor Hold wants you to kill 8 Shattered Hand Legionnaires, 4 Shattered Hand Centurions and 4 Shattered Hand Champions."
Inst42Quest2_Location = "Field Commander Romus (Hellfire Peninsula - Honor Hold; "..YELLOW.."57,63"..WHITE..")"
Inst42Quest2_Note = "You'll find the Centurion's in Sparring Hall."
Inst42Quest2_Prequest = "None"
Inst42Quest2_Folgequest = "None"
-- No Rewards for this quest

--Quest 3 Alliance
Inst42Quest3 = "3. Turning the Tide"
Inst42Quest3_Aim = "Bring Warchief Kargath's Fist to Force Commander Danath Trollbane in Honor Hold."
Inst42Quest3_Location = "Force Commander Danath Trollbane (Hellfire Peninsula - Honor Hold; "..YELLOW.."57,67"..WHITE..")"
Inst42Quest3_Note = "Warchief Kargath Bladefist is at "..YELLOW.."[5]"..WHITE.."."
Inst42Quest3_Prequest = "None"
Inst42Quest3_Folgequest = "None"
--
Inst42Quest3name1 = "Nethekurse's Rod of Torment"
Inst42Quest3name2 = "Mantle of Vivification"
Inst42Quest3name3 = "Naliko's Revenge"
Inst42Quest3name4 = "Medallion of the Valiant Guardian"

--Quest 4 Alliance
Inst42Quest4 = "4. Imprisoned in the Citadel"
Inst42Quest4_Aim = "Rescue Captain Alina inside Hellfire Citadel before she is executed."
Inst42Quest4_Location = "Randy Whizzlesprocket (Shattered Halls; "..YELLOW.."Heroic [1]"..WHITE..")"
Inst42Quest4_Note = "Requires Heroic Dungeon Difficulty.\n\nCaptain Alina is at "..YELLOW.."[5]"..WHITE..". Timer with 55 minutes starts at the beginning of the Archer event."
Inst42Quest4_Prequest = "None"
Inst42Quest4_Folgequest = "None"
-- No Rewards for this quest

--Quest 5 Alliance
Inst42Quest5 = "5. Trial of the Naaru: Mercy"
Inst42Quest5_Aim = "A'dal in Shattrath City wants you to recover the Unused Axe of the Executioner from the Shattered Halls of Hellfire Citadel."
Inst42Quest5_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst42Quest5_Note = "Requires Heroic Dungeon Difficulty.\n\nThis quest used to be required to enter Tempest Keep: The Eye, but is no longer necessary."
Inst42Quest5_Prequest = "None"
Inst42Quest5_Folgequest = "None"
-- No Rewards for this quest

--Quest 6 Alliance
Inst42Quest6 = "6. Tear of the Earthmother"
Inst42Quest6_Aim = "Recover the Tear of the Earthmother from Warbringer O'mrogg and return it to David Wayne at Wayne's Refuge."
Inst42Quest6_Location = "David Wayne (Terokkar Forest - Wayne's Refuge; "..YELLOW.."78,39"..WHITE..")."
Inst42Quest6_Note = "Warbringer O'mrogg is at "..YELLOW.."[4]"..WHITE..".\n\nThe item will drop in both Normal and Heroic modes."
Inst42Quest6_Prequest = "Fresh From the Mechanar ("..YELLOW.."The Mechanar"..WHITE..") & The Lexicon Demonica ("..YELLOW.."Shadow Labyrinth"..WHITE..")"
Inst42Quest6_Folgequest = "Bane of the Illidari"
-- No Rewards for this quest

--Quest 7 Alliance
Inst42Quest7 = "7. Kalynna's Request (Heroic)"
Inst42Quest7_Aim = "Kalynna Lathred wants you to retrieve the Tome of Dusk from Grand Warlock Nethekurse in the Shattered Halls of Hellfire Citadel and the Book of Forgotten Names from Darkweaver Syth in the Sethekk Halls in Auchindoun."
Inst42Quest7_Location = "Kalynna Lathred (Netherstorm - Area 52; "..YELLOW.."32,63"..WHITE..")"
Inst42Quest7_Note = "Requires Heroic Dungeon Difficulty.\n\nGrand Warlock Nethekurse is at "..YELLOW.."[2]"..WHITE..". The Book of Forgotten Names drops in Sethekk Halls."
Inst42Quest7_Prequest = "A Colleague's Aid ("..YELLOW.."Karazhan"..WHITE..")"
Inst42Quest7_Folgequest = "Nightbane ("..YELLOW.."Karazhan"..WHITE..")"
-- No Rewards for this quest

--Quest 8 Alliance
Inst42Quest8 = "8. Wanted: Bladefist's Seal"
Inst42Quest8_Aim = "Wind Trader Zhareem has asked you to obtain Bladefist's Seal. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst42Quest8_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst42Quest8_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nWarchief Kargath Bladefist is at "..YELLOW.."[5]"..WHITE.."."
Inst42Quest8_Prequest = "None"
Inst42Quest8_Folgequest = "None"
--
Inst42Quest8name1 = "Badge of Justice"

--Quest 9 Alliance
Inst42Quest9 = "9. Wanted: Shattered Hand Centurions"
Inst42Quest9_Aim = "Nether-Stalker Mah'duun has tasked you with the deaths of 4 Shattered Hand Centurions. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst42Quest9_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst42Quest9_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst42Quest9_Prequest = "None"
Inst42Quest9_Folgequest = "None"
--
Inst42Quest9name1 = "Ethereum Prison Key"

--Quest 10 Alliance
Inst42Quest10 = "10. Entry Into the Citadel"
Inst42Quest10_Aim = "Bring the Primed Key Mold to Force Commander Danath at Honor Hold in Hellfire Peninsula."
Inst42Quest10_Location = "Primed Key Mold  (drops from Smith Gorlunk in Shadowmoon Valley - Ata'mal Terrace; "..YELLOW.."68,36"..WHITE..")"
Inst42Quest10_Note = "The Smith that drops the Primed Key Mold is easily soloable and very easily reachable with a flying mount.\n\nForce Commander Danath is at (Hellfire Peninsula - Honor Hold; "..YELLOW.."57,67"..WHITE.."). He sends you to Grand Master Dumphry for the next part of the quest at (Hellfire Peninsula - Honor Hold; "..YELLOW.."51,60"..WHITE..")..."
Inst42Quest10_Prequest = "None"
Inst42Quest10_Folgequest = "Grand Master Dumphry -> Hotter than Hell"
--
Inst42Quest10name1 = "Shattered Halls Key"


--Quest 1 Horde  (same as Quest 2 Alliance - different NPC to turn in)
Inst42Quest1_HORDE = "1. Pride of the Fel Horde"
Inst42Quest1_HORDE_Aim = "Shadow Hunter Ty'jin at Thrallmar wants you to kill 8 Shattered Hand Legionnaires, 4 Shattered Hand Centurions and 4 Shattered Hand Champions."
Inst42Quest1_HORDE_Location = "Shadow Hunter Ty'jin (Hellfire Peninsula - Thrallmar; "..YELLOW.."55,36"..WHITE..")"
Inst42Quest1_HORDE_Note = Inst42Quest2_Note
Inst42Quest1_HORDE_Prequest = Inst42Quest2_Prequest
Inst42Quest1_HORDE_Folgequest = Inst42Quest2_Folgequest
-- No Rewards for this quest

--Quest 2 Horde
Inst42Quest2_HORDE = "2. The Will of the Warchief"
Inst42Quest2_HORDE_Aim = "Bring Warchief Kargath's Fist to Nazgrel in Thrallmar."
Inst42Quest2_HORDE_Location = "Nazgrel (Hellfire Peninsula - Thrallmar; "..YELLOW.."55,36"..WHITE..")"
Inst42Quest2_HORDE_Note = "Warchief Kargath Bladefist is Located at "..YELLOW.."[5]"..WHITE.."."
Inst42Quest2_HORDE_Prequest = "None"
Inst42Quest2_HORDE_Folgequest = "None"
--
Inst42Quest2name1_HORDE = "Rod of Dire Shadows"
Inst42Quest2name2_HORDE = "Vicar's Cloak"
Inst42Quest2name3_HORDE = "Conquerer's Band"
Inst42Quest2name4_HORDE = "Maimfist's Choker"

--Quest 3 Horde
Inst42Quest3_HORDE = "3. Imprisoned in the Citadel (Heroic)"
Inst42Quest3_HORDE_Aim = "Rescue Captain Boneshatter inside Hellfire Citadel before he is executed."
Inst42Quest3_HORDE_Location = "Drisella (Shattered Halls; "..YELLOW.."Heroic [1]"..WHITE..")"
Inst42Quest3_HORDE_Note = "Requires Heroic Dungeon Difficulty.\n\nDrisella is at "..YELLOW.."[5]"..WHITE..". Timer with 55 minutes starts at the beginning of the Archer event."
Inst42Quest3_HORDE_Prequest = "None"
Inst42Quest3_HORDE_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 5 Alliance)
Inst42Quest4_HORDE = "4. Trial of the Naaru: Mercy (Heroic)"
Inst42Quest4_HORDE_Aim = Inst42Quest5_Aim
Inst42Quest4_HORDE_Location = Inst42Quest5_Location
Inst42Quest4_HORDE_Note = Inst42Quest5_Note
Inst42Quest4_HORDE_Prequest = Inst42Quest5_Prequest
Inst42Quest4_HORDE_Folgequest = Inst42Quest5_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 6 Alliance)
Inst42Quest5_HORDE = "5. Tear of the Earthmother"
Inst42Quest5_HORDE_Aim = Inst42Quest6_Aim
Inst42Quest5_HORDE_Location = Inst42Quest6_Location
Inst42Quest5_HORDE_Note = Inst42Quest6_Note
Inst42Quest5_HORDE_Prequest = Inst42Quest6_Prequest
Inst42Quest5_HORDE_Folgequest = Inst42Quest6_Folgequest
-- No Rewards for this quest

--Quest 6 Alliance  (same as Quest 7 Alliance)
Inst42Quest6_HORDE = "6. Kalynna's Request (Heroic)"
Inst42Quest6_HORDE_Aim = Inst42Quest7_Aim
Inst42Quest6_HORDE_Location = Inst42Quest7_Location
Inst42Quest6_HORDE_Note = Inst42Quest7_Note
Inst42Quest6_HORDE_Prequest = Inst42Quest7_Prequest
Inst42Quest6_HORDE_Folgequest = Inst42Quest7_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 8 Alliance)
Inst42Quest7_HORDE = "7. Wanted: Bladefist's Seal"
Inst42Quest7_HORDE_Aim = Inst42Quest8_Aim
Inst42Quest7_HORDE_Location = Inst42Quest8_Location
Inst42Quest7_HORDE_Note = Inst42Quest8_Note
Inst42Quest7_HORDE_Prequest = Inst42Quest8_Prequest
Inst42Quest7_HORDE_Folgequest = Inst42Quest8_Folgequest
--
Inst42Quest7name1_HORDE = Inst42Quest8name1

--Quest 8 Horde  (same as Quest 9 Alliance)
Inst42Quest8_HORDE = "8. Wanted: Shattered Hand Centurions"
Inst42Quest8_HORDE_Aim = Inst42Quest9_Aim
Inst42Quest8_HORDE_Location = Inst42Quest9_Location
Inst42Quest8_HORDE_Note = Inst42Quest9_Note
Inst42Quest8_HORDE_Prequest = Inst42Quest9_Prequest
Inst42Quest8_HORDE_Folgequest = Inst42Quest9_Folgequest
--
Inst42Quest8name1_HORDE = Inst42Quest9name1

--Quest 9 Horde
Inst42Quest9_HORDE = "9. Entry Into the Citadel"
Inst42Quest9_HORDE_Aim = "Bring the Primed Key Mold to Nazgrel at Thrallmar in Hellfire Peninsula."
Inst42Quest9_HORDE_Location = "Primed Key Mold  (drops from Smith Gorlunk in Shadowmoon Valley - Ata'mal Terrace; "..YELLOW.."68,36"..WHITE..")"
Inst42Quest9_HORDE_Note = "The Smith that drops the Primed Key Mold is easily soloable and very easily reachable with a flying mount.\n\nNazgrel is at (Hellfire Peninsula - Thrallmar; "..YELLOW.."55,36"..WHITE.."). He sends you to Grand Master Rohok for the next part of the quest at (Hellfire Peninsula - Thrallmar; "..YELLOW.."53,38"..WHITE..")..."
Inst42Quest9_HORDE_Prequest = "None"
Inst42Quest9_HORDE_Folgequest = "Grand Master Rohok -> Hotter than Hell"
--
Inst42Quest9name1_HORDE = "Shattered Halls Key"



--------------- INST43 - Magtheridon's Lair ---------------

Inst43Caption = "Magtheridon's Lair"
Inst43QAA = "2 Quests"
Inst43QAH = "2 Quests"

--Quest 1 Alliance
Inst43Quest1 = "1. Trial of the Naaru: Magtheridon"
Inst43Quest1_Aim = "A'dal in Shattrath City wants you to slay Magtheridon."
Inst43Quest1_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst43Quest1_Note = "Must have completed Trial of the Naaru Mercy, Trial of the Naaru Strength and Trial of the Naaru Tenacity all available from A'dal.\n\nThis quest used to be required to enter Tempest Keep: The Eye, but is no longer necessary."
Inst43Quest1_Prequest = "Trial of the Naaru: Tenacity, Mercy & Strength quests."
Inst43Quest1_Folgequest = "None"
--
Inst43Quest1name1 = "Phoenix-fire Band"

--Quest 2 Alliance
Inst43Quest2 = "2. The Fall of Magtheridon"
Inst43Quest2_Aim = "Return Magtheridon's Head to Force Commander Danath Trollbane at Honor Hold in Hellfire Peninsula."
Inst43Quest2_Location = "Magtheridon's Head (drops from Magtheridon; "..YELLOW.."[1]"..WHITE..")"
Inst43Quest2_Note = "Only one person in the raid can win the head to start this quest. Force Commander Danath Trollbane is at "..YELLOW.."57,67"..WHITE.."."
Inst43Quest2_Prequest = "No"
Inst43Quest2_Folgequest = "None"
--
Inst43Quest2name1 = "A'dal's Signet of Defense"
Inst43Quest2name2 = "Band of Crimson Fury"
Inst43Quest2name3 = "Naaru Lightwarden's Band"
Inst43Quest2name4 = "Ring of the Recalcitrant"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst43Quest1_HORDE = Inst43Quest1
Inst43Quest1_HORDE_Aim = Inst43Quest1_Aim
Inst43Quest1_HORDE_Location = Inst43Quest1_Location
Inst43Quest1_HORDE_Note = Inst43Quest1_Note
Inst43Quest1_HORDE_Prequest = Inst43Quest1_Prequest
Inst43Quest1_HORDE_Folgequest = Inst43Quest1_Folgequest
--
Inst43Quest1name1_HORDE = Inst43Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance - different NPC to turn in)
Inst43Quest2_HORDE = Inst43Quest2
Inst43Quest2_HORDE_Aim = "Return Magtheridon's Head to Nazgrel at Thrallmar in Hellfire Peninsula."
Inst43Quest2_HORDE_Location = Inst43Quest2_Location
Inst43Quest2_HORDE_Note = "Only one person in the raid can win the head to start this quest. Nazgrel is at "..YELLOW.."55,36"..WHITE.."."
Inst43Quest2_HORDE_Prequest = Inst43Quest2_Prequest
Inst43Quest2_HORDE_Folgequest = Inst43Quest2_Folgequest
--
Inst43Quest2name1_HORDE = Inst43Quest2name1
Inst43Quest2name2_HORDE = Inst43Quest2name2
Inst43Quest2name3_HORDE = Inst43Quest2name3
Inst43Quest2name4_HORDE = Inst43Quest2name4



--------------- INST44 - The Slave Pens ---------------

Inst44Caption = "The Slave Pens"
Inst44QAA = "7 Quests"
Inst44QAH = "7 Quests"

--Quest 1 Alliance
Inst44Quest1 = "1. Lost in Action"
Inst44Quest1_Aim = "Discover what happened to Earthbinder Rayge, Naturalist Bite, Weeder Greenthumb, and Windcaller Claw. Then, return to Watcher Jhang at Coilfang Reservoir in Zangarmarsh."
Inst44Quest1_Location = "Watcher Jhang (Coilfang Reservoir; "..YELLOW.."52,36"..WHITE..")"
Inst44Quest1_Note = "Watcher Jhang is in the underwater cavern at the summoning stone. Weeder Greenthumb is at "..YELLOW.."[3]"..WHITE.." and Naturalist Bite is at "..YELLOW.."[6]"..WHITE..". This quest continues in Underbog. The prequests are optional."
Inst44Quest1_Prequest = "Drain Schematics -> Failed Incursion"
Inst44Quest1_Folgequest = "None"
--
Inst44Quest1name1 = "Cenarion Ring of Casting"
Inst44Quest1name2 = "Goldenvine Wraps"
Inst44Quest1name3 = "Dark Cloak of the Marsh"

--Quest 2 Alliance
Inst44Quest2 = "2. Wanted: The Heart of Quagmirran"
Inst44Quest2_Aim = "Wind Trader Zhareem has asked you to obtain The Heart of Quagmirran. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst44Quest2_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst44Quest2_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nQuagmirran is at "..YELLOW.."[7]"..WHITE.."."
Inst44Quest2_Prequest = "None"
Inst44Quest2_Folgequest = "None"
--
Inst44Quest2name1 = "Badge of Justice"

--Quest 3 Alliance
Inst44Quest3 = "3. The Cudgel of Kar'desh (Heroic)"
Inst44Quest3_Aim = "Skar'this the Heretic in the heroic Slave Pens of Coilfang Reservoir wants you to bring him the Earthen Signet and the Blazing Signet."
Inst44Quest3_Location = "Skar'this the Heretic (Slave Pens; "..YELLOW.."Heroic [4]"..WHITE..")"
Inst44Quest3_Note = "The Earthen Signet drops off Gruul in "..YELLOW.."Gruul's Lair"..WHITE.." and the Blazing Signet drops off Nightbane in "..YELLOW.."Karazhan"..WHITE..".\n\nThis quest used to be required to enter Serpentshrine Cavern, but is no longer necessary."
Inst44Quest3_Prequest = "None"
Inst44Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst44Quest4 = "4. Ahune, the Frost Lord (Seasonal)"
Inst44Quest4_Aim = "Travel to the Slave Pens in Coilfang Reservoir within Zangarmarsh and speak with Numa Cloudsister."
Inst44Quest4_Location = "Earthen Ring Elder (Found at Midsummer Bonfires in all Major Cities)"
Inst44Quest4_Note = "Numa Cloudsister is just inside the entrance to Slave Pens. This quest is not required to summon Ahune. If you just go to the instance at level 65 or higher without having done any of the quests, you will still be able to summon him."
Inst44Quest4_Prequest = "Unusual Activity -> Inform the Elder"
Inst44Quest4_Folgequest = "Ahune is Here!"
-- No Rewards for this quest

--Quest 5 Alliance
Inst44Quest5 = "5. Ahune is Here! (Seasonal)"
Inst44Quest5_Aim = "Find Luma Skymother in the Slave Pens."
Inst44Quest5_Location = "Numa Cloudsister (Slave Pens; "..YELLOW.."Just inside the portal"..WHITE..")"
Inst44Quest5_Note = "Luma Skymother is near "..YELLOW.."[1]"..WHITE..". You don't have to do any of the other seasonal quests to obtain this quest. The prequest is optional."
Inst44Quest5_Prequest = "Ahune, the Frost Lord (Optional)"
Inst44Quest5_Folgequest = "Summon Ahune"
-- No Rewards for this quest

--Quest 6 Alliance
Inst44Quest6 = "6. Summon Ahune (Daily - Seasonal)"
Inst44Quest6_Aim = "Bring the Earthen Ring Magma Totem to the Ice Stone."
Inst44Quest6_Location = "Luma Skymother (Slave Pens; "..YELLOW.."Near [1]"..WHITE..")"
Inst44Quest6_Note = "The Ice Stone is a short distance from Luma Skymother. Completing this quest summons Ahune at "..YELLOW.."[1]"..WHITE..". It can be done once a day per character."
Inst44Quest6_Prequest = "Ahune is Here!"
Inst44Quest6_Folgequest = "None"
-- No Rewards for this quest

--Quest 7 Alliance
Inst44Quest7 = "7. Shards of Ahune (Seasonal)"
Inst44Quest7_Aim = "Bring the Ice Shards to Luma Skymother."
Inst44Quest7_Location = "Shards of Ahune (drops from Ice Chest after Ahune, The Frost Lord is killed)"
Inst44Quest7_Note = "Luma Skymother is at (Slave Pens; "..YELLOW.."Near [1]"..WHITE.."). This item will only drop once a year per character."
Inst44Quest7_Prequest = "None"
Inst44Quest7_Folgequest = "None"
--
Inst44Quest7name1 = "Tabard of Summer Skies"
Inst44Quest7name2 = "Tabard of Summer Flames"
Inst44Quest7name3 = "Burning Blossom"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst44Quest1_HORDE = Inst44Quest1
Inst44Quest1_HORDE_Aim = Inst44Quest1_Aim
Inst44Quest1_HORDE_Location = Inst44Quest1_Location
Inst44Quest1_HORDE_Note = Inst44Quest1_Note
Inst44Quest1_HORDE_Prequest = Inst44Quest1_Prequest
Inst44Quest1_HORDE_Folgequest = Inst44Quest1_Folgequest
--
Inst44Quest1name1_HORDE = Inst44Quest1name1
Inst44Quest1name2_HORDE = Inst44Quest1name2
Inst44Quest1name3_HORDE = Inst44Quest1name3

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst44Quest2_HORDE = Inst44Quest2
Inst44Quest2_HORDE_Aim = Inst44Quest2_Aim
Inst44Quest2_HORDE_Location = Inst44Quest2_Location
Inst44Quest2_HORDE_Note = Inst44Quest2_Note
Inst44Quest2_HORDE_Prequest = Inst44Quest2_Prequest
Inst44Quest2_HORDE_Folgequest = Inst44Quest2_Folgequest
--
Inst44Quest2name1_HORDE = Inst44Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst44Quest3_HORDE = Inst44Quest3
Inst44Quest3_HORDE_Aim = Inst44Quest3_Aim
Inst44Quest3_HORDE_Location = Inst44Quest3_Location
Inst44Quest3_HORDE_Note = Inst44Quest3_Note
Inst44Quest3_HORDE_Prequest = Inst44Quest3_Prequest
Inst44Quest3_HORDE_Folgequest = Inst44Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst44Quest4_HORDE = Inst44Quest4
Inst44Quest4_HORDE_Aim = Inst44Quest4_Aim
Inst44Quest4_HORDE_Location = Inst44Quest4_Location
Inst44Quest4_HORDE_Note = Inst44Quest4_Note
Inst44Quest4_HORDE_Prequest = Inst44Quest4_Prequest
Inst44Quest4_HORDE_Folgequest = Inst44Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst44Quest5_HORDE = Inst44Quest5
Inst44Quest5_HORDE_Aim = Inst44Quest5_Aim
Inst44Quest5_HORDE_Location = Inst44Quest5_Location
Inst44Quest5_HORDE_Note = Inst44Quest5_Note
Inst44Quest5_HORDE_Prequest = Inst44Quest5_Prequest
Inst44Quest5_HORDE_Folgequest = Inst44Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst44Quest6_HORDE = Inst44Quest6
Inst44Quest6_HORDE_Aim = Inst44Quest6_Aim
Inst44Quest6_HORDE_Location = Inst44Quest6_Location
Inst44Quest6_HORDE_Note = Inst44Quest6_Note
Inst44Quest6_HORDE_Prequest = Inst44Quest6_Prequest
Inst44Quest6_HORDE_Folgequest = Inst44Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst44Quest7_HORDE = Inst44Quest7
Inst44Quest7_HORDE_Aim = Inst44Quest7_Aim
Inst44Quest7_HORDE_Location = Inst44Quest7_Location
Inst44Quest7_HORDE_Note = Inst44Quest7_Note
Inst44Quest7_HORDE_Prequest = Inst44Quest7_Prequest
Inst44Quest7_HORDE_Folgequest = Inst44Quest7_Folgequest
--
Inst44Quest7name1_HORDE = Inst44Quest7name1
Inst44Quest7name2_HORDE = Inst44Quest7name2
Inst44Quest7name3_HORDE = Inst44Quest7name3



--------------- INST45 - The Steamvault ---------------

Inst45Caption = "The Steamvault"
Inst45QAA = "7 Quests"
Inst45QAH = "7 Quests"

--Quest 1 Alliance
Inst45Quest1 = "1. The Warlord's Hideout"
Inst45Quest1_Aim = "Watcher Jhang wants you to find and slay Warlord Kalithresh inside Coilfang Reservoir."
Inst45Quest1_Location = "Watcher Jhang (Coilfang Reservoir; "..YELLOW.."52,36"..WHITE..")"
Inst45Quest1_Note = "Watcher Jhang is in the underwater cavern at the summoning stone. Warlord Kalithresh is at "..YELLOW.."[4]"..WHITE..". Make sure to destroy the Tanks when Kalithresh uses them."
Inst45Quest1_Prequest = "None"
Inst45Quest1_Folgequest = "None"
--
Inst45Quest1name1 = "Hydromancer's Headwrap"
Inst45Quest1name2 = "Helm of the Claw"
Inst45Quest1name3 = "Earthwarden's Coif"
Inst45Quest1name4 = "Myrmidon's Headdress"

--Quest 2 Alliance
Inst45Quest2 = "2. Orders from Lady Vashj"
Inst45Quest2_Aim = "Deliver the Orders from Lady Vashj to Ysiel Windsinger at the Cenarion Refuge in Zangarmarsh."
Inst45Quest2_Location = "Orders from Lady Vashj (random drop from Steamvaults)"
Inst45Quest2_Note = "Ysiel Windsinger is at Terrokar Forest - Cenarion Refuge; ("..YELLOW.."78,62"..WHITE.."). The followup quest enables you to turn in Coilfang Armaments for Cenarion Expedition reputation. Coilfang Armaments are randomly dropped from Steamvaults and Serpentshrine Cavern and can be collected (but not turned in) before you do this quest. They do not bind, so they can be traded or bought from other players."
Inst45Quest2_Prequest = "None"
Inst45Quest2_Folgequest = "Preparing for War"
-- No Rewards for this quest

--Quest 3 Alliance
Inst45Quest3 = "3. Trial of the Naaru: Strength (Heroic)"
Inst45Quest3_Aim = "A'dal in Shattrath City wants you to recover Kalithresh's Trident and Murmur's Essence."
Inst45Quest3_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst45Quest3_Note = "Requires Heroic Dungeon Difficulty. Warlord Kalithresh is at "..YELLOW.."[4]"..WHITE..". Murmur's Essence comes from Shadow Labyrinth.\n\nThis quest used to be required to enter Tempest Keep: The Eye, but is no longer necessary."
Inst45Quest3_Prequest = "None"
Inst45Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst45Quest4 = "4. Underworld Loam"
Inst45Quest4_Aim = "Get a Vial of Underworld Loam from Hydromancer Thespia and bring it to David Wayne at Wayne's Refuge."
Inst45Quest4_Location = "David Wayne (Terokkar Forest - Wayne's Refuge; "..YELLOW.."78,39"..WHITE..")"
Inst45Quest4_Note = "Hydromancer Thespia is at "..YELLOW.."[1]"..WHITE..".\n\nThe item will drop in both Normal and Heroic modes."
Inst45Quest4_Prequest = "Fresh From the Mechanar ("..YELLOW.."TK: Mechanar"..WHITE..") & The Lexicon Demonica ("..YELLOW.."Auch: Shadow Labyrinth"..WHITE..")"
Inst45Quest4_Folgequest = "Bane of the Illidari"
-- No Rewards for this quest

--Quest 5 Alliance
Inst45Quest5 = "5. The Second and Third Fragments"
Inst45Quest5_Aim = "Obtain the Second Key Fragment from an Arcane Container inside Coilfang Reservoir and the Third Key Fragment from an Arcane Container inside Tempest Keep. Return to Khadgar in Shattrath City after you've completed this task."
Inst45Quest5_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst45Quest5_Note = "Part of the Karazhan attunement line. The Arcane Container is at "..YELLOW.."[2]"..WHITE..", at the bottom of a pool of water. Opening it will spawn an elemental that must be killed to get the fragment. The Third Key Fragment is in the Arcatraz."
Inst45Quest5_Prequest = "Entry Into Karazhan ("..YELLOW.."Auch: Shadow Labyrinth"..WHITE..")"
Inst45Quest5_Folgequest = "The Master's Touch ("..YELLOW.."CoT: Black Morass"..WHITE..")"
-- No Rewards for this quest

--Quest 6 Alliance
Inst45Quest6 = "6. Wanted: Coilfang Myrmidons"
Inst45Quest6_Aim = "Nether-Stalker Mah'duun has asked you to slay 14 Coilfang Myrmidons. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst45Quest6_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst45Quest6_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst45Quest6_Prequest = "None"
Inst45Quest6_Folgequest = "None"
--
Inst45Quest6name1 = "Ethereum Prison Key"

--Quest 7 Alliance
Inst45Quest7 = "7. Wanted: The Warlord's Treatise"
Inst45Quest7_Aim = "Wind Trader Zhareem has asked you to acquire The Warlord's Treatise. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst45Quest7_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst45Quest7_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nWarlord Kalithresh is at "..YELLOW.."[4]"..WHITE.."."
Inst45Quest7_Prequest = "None"
Inst45Quest7_Folgequest = "None"
--
Inst45Quest7name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst45Quest1_HORDE = Inst45Quest1
Inst45Quest1_HORDE_Aim = Inst45Quest1_Aim
Inst45Quest1_HORDE_Location = Inst45Quest1_Location
Inst45Quest1_HORDE_Note = Inst45Quest1_Note
Inst45Quest1_HORDE_Prequest = Inst45Quest1_Prequest
Inst45Quest1_HORDE_Folgequest = Inst45Quest1_Folgequest
--
Inst45Quest1name1_HORDE = Inst45Quest1name1
Inst45Quest1name2_HORDE = Inst45Quest1name2
Inst45Quest1name3_HORDE = Inst45Quest1name3
Inst45Quest1name4_HORDE = Inst45Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst45Quest2_HORDE = Inst45Quest2
Inst45Quest2_HORDE_Aim = Inst45Quest2_Aim
Inst45Quest2_HORDE_Location = Inst45Quest2_Location
Inst45Quest2_HORDE_Note = Inst45Quest2_Note
Inst45Quest2_HORDE_Prequest = Inst45Quest2_Prequest
Inst45Quest2_HORDE_Folgequest = Inst45Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst45Quest3_HORDE = Inst45Quest3
Inst45Quest3_HORDE_Aim = Inst45Quest3_Aim
Inst45Quest3_HORDE_Location = Inst45Quest3_Location
Inst45Quest3_HORDE_Note = Inst45Quest3_Note
Inst45Quest3_HORDE_Prequest = Inst45Quest3_Prequest
Inst45Quest3_HORDE_Folgequest = Inst45Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst45Quest4_HORDE = Inst45Quest4
Inst45Quest4_HORDE_Aim = Inst45Quest4_Aim
Inst45Quest4_HORDE_Location = Inst45Quest4_Location
Inst45Quest4_HORDE_Note = Inst45Quest4_Note
Inst45Quest4_HORDE_Prequest = Inst45Quest4_Prequest
Inst45Quest4_HORDE_Folgequest = Inst45Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst45Quest5_HORDE = Inst45Quest5
Inst45Quest5_HORDE_Aim = Inst45Quest5_Aim
Inst45Quest5_HORDE_Location = Inst45Quest5_Location
Inst45Quest5_HORDE_Note = Inst45Quest5_Note
Inst45Quest5_HORDE_Prequest = Inst45Quest5_Prequest
Inst45Quest5_HORDE_Folgequest = Inst45Quest5_Folgequest
Inst45Quest5PreQuest_HORDE = Inst45Quest5PreQuest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst45Quest6_HORDE = Inst45Quest6
Inst45Quest6_HORDE_Aim = Inst45Quest6_Aim
Inst45Quest6_HORDE_Location = Inst45Quest6_Location
Inst45Quest6_HORDE_Note = Inst45Quest6_Note
Inst45Quest6_HORDE_Prequest = Inst45Quest6_Prequest
Inst45Quest6_HORDE_Folgequest = Inst45Quest6_Folgequest
--
Inst45Quest6name1_HORDE = Inst45Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst45Quest7_HORDE = Inst45Quest7
Inst45Quest7_HORDE_Aim = Inst45Quest7_Aim
Inst45Quest7_HORDE_Location = Inst45Quest7_Location
Inst45Quest7_HORDE_Note = Inst45Quest7_Note
Inst45Quest7_HORDE_Prequest = Inst45Quest7_Prequest
Inst45Quest7_HORDE_Folgequest = Inst45Quest7_Folgequest
--
Inst45Quest7name1_HORDE = Inst45Quest7name1



--------------- INST46 - The Underbog ---------------

Inst46Caption = "The Underbog"
Inst46QAA = "5 Quests"
Inst46QAH = "5 Quests"

--Quest 1 Alliance
Inst46Quest1 = "1. Lost in Action"
Inst46Quest1_Aim = "Discover what happened to Earthbinder Rayge, Naturalist Bite, Weeder Greenthumb, and Windcaller Claw. Then, return to Watcer Jhang at Coilfang Reservoir in Zangarmarsh."
Inst46Quest1_Location = "Watcher Jhang (Coilfang Reservoir; "..YELLOW.."52,36"..WHITE..")"
Inst46Quest1_Note = "Watcher Jhang is in the underwater cavern at the summoning stone. Earthbinder Rayge is at "..YELLOW.."[3]"..WHITE..", Windcaller Claw is at "..YELLOW.."[4]"..WHITE..". The prequests do not appear to be necessary to obtain this quest."
Inst46Quest1_Prequest = "Drain Schematics -> Failed Incursion"
Inst46Quest1_Folgequest = "None"
--
Inst46Quest1name1 = "Cenarion Ring of Casting"
Inst46Quest1name2 = "Goldenvine Wraps"
Inst46Quest1name3 = "Dark Cloak of the Marsh"

--Quest 2 Alliance
Inst46Quest2 = "2. Oh, It's On!"
Inst46Quest2_Aim = "Gather an Underspore Frond and return it to T'shu at Sporeggar in Zangarmarsh."
Inst46Quest2_Location = "T'shu (Zangarmarsh - Sporeggar; "..YELLOW.."19,49"..WHITE..")"
Inst46Quest2_Note = "You must be Neutral with Sporeggar to pick up this quest. The Underspore Frond is just behind Hungarfen, located at "..YELLOW.."[1]"..WHITE.."."
Inst46Quest2_Prequest = "None"
Inst46Quest2_Folgequest = "None"
--
Inst46Quest2name1 = "Everlasting Underspore Frond"

--Quest 3 Alliance
Inst46Quest3 = "3. Stalk the Stalker"
Inst46Quest3_Aim = "Bring the Brain of the Black Stalker to Khn'nix at Sporeggar in Zangarmarsh."
Inst46Quest3_Location = "Khn'nix (Zangarmarsh - Sporeggar; "..YELLOW.."19,49"..WHITE..")"
Inst46Quest3_Note = "You must be Neutral with Sporeggar to pick up this quest. The Black Stalker is the final boss."
Inst46Quest3_Prequest = "None"
Inst46Quest3_Folgequest = "None"
--
Inst46Quest3name1 = "Essence Infused Mushroom"
Inst46Quest3name2 = "Power Infused Mushroom"

--Quest 4 Alliance
Inst46Quest4 = "4. Wanted: A Black Stalker Egg"
Inst46Quest4_Aim = "Wind Trader Zhareem wants you to obtain a Black Stalker Egg. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst46Quest4_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst46Quest4_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nThe Black Stalker is the final boss."
Inst46Quest4_Prequest = "None"
Inst46Quest4_Folgequest = "None"
--
Inst46Quest4name1 = "Badge of Justice"

--Quest 5 Alliance
Inst46Quest5 = "5. Bring Me A Shrubbery!"
Inst46Quest5_Aim = "Collect 5 Sanguine Hibiscus and return them to Gzhun'tt at Sporeggar in Zangarmarsh."
Inst46Quest5_Location = "Gzhun'tt (Zangarmarsh - Sporeggar; "..YELLOW.."19,50"..WHITE..")"
Inst46Quest5_Note = "You must be Friendly with Sporeggar to pick up this quest. The followup is just a repeatable quest that gives Sporeggar Reputation with each turn-in. The Sanguine Hibiscus are scattered throughout Underbog near plants and also drop off of Bog mobs, including those in Steamvault. They are also tradeable and can be found on the Auction House."
Inst46Quest5_Prequest = "None"
Inst46Quest5_Folgequest = "Bring Me Another Shrubbery!"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst46Quest1_HORDE = Inst46Quest1
Inst46Quest1_HORDE_Aim = Inst46Quest1_Aim
Inst46Quest1_HORDE_Location = Inst46Quest1_Location
Inst46Quest1_HORDE_Note = Inst46Quest1_Note
Inst46Quest1_HORDE_Prequest = Inst46Quest1_Prequest
Inst46Quest1_HORDE_Folgequest = Inst46Quest1_Folgequest
--
Inst46Quest1name1_HORDE = Inst46Quest1name1
Inst46Quest1name2_HORDE = Inst46Quest1name2
Inst46Quest1name3_HORDE = Inst46Quest1name3

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst46Quest2_HORDE = Inst46Quest2
Inst46Quest2_HORDE_Aim = Inst46Quest2_Aim
Inst46Quest2_HORDE_Location = Inst46Quest2_Location
Inst46Quest2_HORDE_Note = Inst46Quest2_Note
Inst46Quest2_HORDE_Prequest = Inst46Quest2_Prequest
Inst46Quest2_HORDE_Folgequest = Inst46Quest2_Folgequest
--
Inst46Quest2name1_HORDE = Inst46Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst46Quest3_HORDE = Inst46Quest3
Inst46Quest3_HORDE_Aim = Inst46Quest3_Aim
Inst46Quest3_HORDE_Location = Inst46Quest3_Location
Inst46Quest3_HORDE_Note = Inst46Quest3_Note
Inst46Quest3_HORDE_Prequest = Inst46Quest3_Prequest
Inst46Quest3_HORDE_Folgequest = Inst46Quest3_Folgequest
--
Inst46Quest3name1_HORDE = Inst46Quest3name1
Inst46Quest3name2_HORDE = Inst46Quest3name2

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst46Quest4_HORDE = Inst46Quest4
Inst46Quest4_HORDE_Aim = Inst46Quest4_Aim
Inst46Quest4_HORDE_Location = Inst46Quest4_Location
Inst46Quest4_HORDE_Note = Inst46Quest4_Note
Inst46Quest4_HORDE_Prequest = Inst46Quest4_Prequest
Inst46Quest4_HORDE_Folgequest = Inst46Quest4_Folgequest
--
Inst46Quest4name1_HORDE = Inst46Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst46Quest5_HORDE = Inst46Quest5
Inst46Quest5_HORDE_Aim = Inst46Quest5_Aim
Inst46Quest5_HORDE_Location = Inst46Quest5_Location
Inst46Quest5_HORDE_Note = Inst46Quest5_Note
Inst46Quest5_HORDE_Prequest = Inst46Quest5_Prequest
Inst46Quest5_HORDE_Folgequest = Inst46Quest5_Folgequest
-- No Rewards for this quest



--------------- INST47 - Auchenai Crypts ---------------

Inst47Caption = "Auchenai Crypts"
Inst47QAA = "2 Quests"
Inst47QAH = "4 Quests"

--Quest 1 Alliance
Inst47Quest1 = "1. Everything Will Be Alright"
Inst47Quest1_Aim = "Enter the Auchenai Crypts and destroy Exarch Maladaar so that the spirits trapped inside can finally rest in peace."
Inst47Quest1_Location = "Greatfather Aldrimus (Terokkar Forest; "..YELLOW.."35,65"..WHITE..")"
Inst47Quest1_Note = "Exarch Maladarr is Located at "..YELLOW.."[2]"..WHITE..". The prequest line starts from Ha'lei (Terokkar Forest - Auchindoun; "..YELLOW.."35,65"..WHITE..")."
Inst47Quest1_Prequest = "I See Dead Draenei -> Levixus the Soul Caller"
Inst47Quest1_Folgequest = "None"
--
Inst47Quest1name1 = "Auchenai Anchorite's Robe"
Inst47Quest1name2 = "Auchenai Monk's Tunic"
Inst47Quest1name3 = "Auchenai Tracker's Hauberk"
Inst47Quest1name4 = "The Exarch's Protector"

--Quest 2 Alliance
Inst47Quest2 = "2. Wanted: The Exarch's Soul Gem"
Inst47Quest2_Aim = "Wind Trader Zhareem has asked you to recover The Exarch's Soul Gem. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst47Quest2_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst47Quest2_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nExarch Maladaar is at "..YELLOW.."[2]"..WHITE.."."
Inst47Quest2_Prequest = "None"
Inst47Quest2_Folgequest = "None"
--
Inst47Quest2name1 = "Badge of Justice"


--Quest 1 Horde
Inst47Quest1_HORDE = "1. Auchindoun..."
Inst47Quest1_HORDE_Aim = "Travel to the Auchenai Crypts in the Bone Wastes of Terokkar Forest and slay Exarch Maladaar to free the spirit of D'ore."
Inst47Quest1_HORDE_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst47Quest1_HORDE_Note = "Exarch Maladarr is Located at "..YELLOW.."[2]"..WHITE..". D'ore appears after Exarch Maladarr has been killed."
Inst47Quest1_HORDE_Prequest = "A Visit With the Greatmother -> A Secret Revealed"
Inst47Quest1_HORDE_Folgequest = "What The Soul Sees"
-- No Rewards for this quest

--Quest 2 Horde
Inst47Quest2_HORDE = "2. What the Soul Sees"
Inst47Quest2_HORDE_Aim = "Locate a Soul Mirror somewhere in the Auchenai Crypts and use it to call forth a Darkened Spirit from Ancient Orc Ancestors in Nagrand. Destroy 15 Darkened Spirits so that the ancestors may rest in peace."
Inst47Quest2_HORDE_Location = "D'ore (Auchenai Crypts; "..YELLOW.."[2]"..WHITE..")."
Inst47Quest2_HORDE_Note = "D'ore appears after Exarch Maladarr has been killed. Mother Kashur is at (Nagrand; "..YELLOW.."26,61"..WHITE.."). Get a group of 3 or more people before taking on the Ancient Orc Spirits."
Inst47Quest2_HORDE_Prequest = "Auchindoun"
Inst47Quest2_HORDE_Folgequest = "Return to the Greatmother"
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 1 Alliance)
Inst47Quest3_HORDE = "3. Everything Will Be Alright"
Inst47Quest3_HORDE_Aim = Inst47Quest1_Aim
Inst47Quest3_HORDE_Location = Inst47Quest1_Location
Inst47Quest3_HORDE_Note = Inst47Quest1_Note
Inst47Quest3_HORDE_Prequest = Inst47Quest1_Prequest
Inst47Quest3_HORDE_Folgequest = Inst47Quest1_Folgequest
--
Inst47Quest3name1_HORDE = Inst47Quest1name1
Inst47Quest3name2_HORDE = Inst47Quest1name2
Inst47Quest3name3_HORDE = Inst47Quest1name3
Inst47Quest3name4_HORDE = Inst47Quest1name4

--Quest 4 Horde  (same as Quest 2 Alliance)
Inst47Quest4_HORDE = "4. Wanted: The Exarch's Soul Gem"
Inst47Quest4_HORDE_Aim = Inst47Quest2_Aim
Inst47Quest4_HORDE_Location = Inst47Quest2_Location
Inst47Quest4_HORDE_Note = Inst47Quest2_Note
Inst47Quest4_HORDE_Prequest = Inst47Quest2_Prequest
Inst47Quest4_HORDE_Folgequest = Inst47Quest2_Folgequest
--
Inst47Quest4name1_HORDE = Inst47Quest2name1



--------------- INST48 - Mana Tombs ---------------

Inst48Caption = "Mana Tombs"
Inst48QAA = "5 Quests"
Inst48QAH = "5 Quests"

--Quest 1 Alliance
Inst48Quest1 = "1. Safety Is Job One"
Inst48Quest1_Aim = "Artificer Morphalius wants you to kill 10 Ethereal Crypt Raiders, 5 Ethereal Sorcerers, 5 Nexus Stalkers and 5 Ethereal Spellbinders."
Inst48Quest1_Location = "Artificer Morphalius (Terokkar Forest - Auchindoun; "..YELLOW.."39,58"..WHITE..")"
Inst48Quest1_Note = "Ethereal Transporter Control Panel is at "..YELLOW.."[4]"..WHITE.."."
Inst48Quest1_Prequest = "None"
Inst48Quest1_Folgequest = "Someone Else's Hard Work Pays Off"
-- No Rewards for this quest

--Quest 2 Alliance
Inst48Quest2 = "2. Someone Else's Hard Work Pays Off"
Inst48Quest2_Aim = "Escort Cryo-Engineer Sha'heen safely through the Mana-Tombs so that he can gather the ether held inside Shaffar's ether collectors."
Inst48Quest2_Location = "Cryo-Engineer Sha'heen (Mana Tombs; "..YELLOW.."[4]"..WHITE..")"
Inst48Quest2_Note = "To summon Cryo-Engineer Sha'heen, click on the Ethereal Transporter Control Panel at "..YELLOW.."[4]"..WHITE..". He'll spawn along with several other friendly Consortium NPCs.  The entire instance should be cleared before hand. Leave nothing alive. The escort can only be attempted once per instance."
Inst48Quest2_Prequest = "Safety Is Job One"
Inst48Quest2_Folgequest = "None"
--
Inst48Quest2name1 = "Consortium Prince's Wrap"
Inst48Quest2name2 = "Cryo-mitts"
Inst48Quest2name3 = "Consortium Mantle of Phasing"
Inst48Quest2name4 = "Flesh Beast's Metal Greaves"

--Quest 3 Alliance
Inst48Quest3 = "3. Undercutting the Competition"
Inst48Quest3_Aim = "Nexus-Prince Haramad located outside of the Mana-Tombs wants you to kill Nexus-Prince Shaffar and bring Shaffar's Wrappings back to him."
Inst48Quest3_Location = "Nexus-Prince Haramand (Terrokar Forest - Auchindoun; "..YELLOW.."39,58"..WHITE..")."
Inst48Quest3_Note = "Nexus-Prince Shaffar is at "..YELLOW.."[5]"..WHITE.."."
Inst48Quest3_Prequest = "None"
Inst48Quest3_Folgequest = "None"
--
Inst48Quest3name1 = "Haramad's Leggings of the Third Coin"
Inst48Quest3name2 = "Consortium Plated Legguards"
Inst48Quest3name3 = "Haramad's Leg Wraps"
Inst48Quest3name4 = "Haramad's Linked Chain Pantaloons"

--Quest 4 Alliance
Inst48Quest4 = "4. Stasis Chambers of the Mana-Tombs (Heroic)"
Inst48Quest4_Aim = "The Image of Commander Ameer at Bash'ir's Landing in the Blade's Edge Mountains wants you to use the Mana-Tombs Stasis Chamber Key on the Stasis Chamber inside the Mana-Tombs of Auchindoun."
Inst48Quest4_Location = "Image of Commander Ameer (Blade's Edge Mountains - Bash'ir's Landing; "..YELLOW.."52,15"..WHITE..")."
Inst48Quest4_Note = "Requires Heroic Dungeon Difficulty. There are two Stasis Chambers. The first is just beyond Pandemonius "..YELLOW.."[1]"..WHITE..". The second is in Nexus-Prince Shaffar's room "..YELLOW.."[5]"..WHITE..". You'll need a Mark of the Nexus-King for each."
Inst48Quest4_Prequest = "The Mark of the Nexus-King"
Inst48Quest4_Folgequest = "None"
--
Inst48Quest4name1 = "Badge of Justice"

--Quest 5 Alliance
Inst48Quest5 = "5. Wanted: Shaffar's Wondrous Pendant"
Inst48Quest5_Aim = "Wind Trader Zhareem wants you to obtain Shaffar's Wondrous Amulet. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst48Quest5_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst48Quest5_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nNexus-Prince Shaffar is at "..YELLOW.."[5]"..WHITE.."."
Inst48Quest5_Prequest = "None"
Inst48Quest5_Folgequest = "None"
--
Inst48Quest5name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst48Quest1_HORDE = Inst48Quest1
Inst48Quest1_HORDE_Aim = Inst48Quest1_Aim
Inst48Quest1_HORDE_Location = Inst48Quest1_Location
Inst48Quest1_HORDE_Note = Inst48Quest1_Note
Inst48Quest1_HORDE_Prequest = Inst48Quest1_Prequest
Inst48Quest1_HORDE_Folgequest = Inst48Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst48Quest2_HORDE = Inst48Quest2
Inst48Quest2_HORDE_Aim = Inst48Quest2_Aim
Inst48Quest2_HORDE_Location = Inst48Quest2_Location
Inst48Quest2_HORDE_Note = Inst48Quest2_Note
Inst48Quest2_HORDE_Prequest = Inst48Quest2_Prequest
Inst48Quest2_HORDE_Folgequest = Inst48Quest2_Folgequest
--
Inst48Quest2name1_HORDE = Inst48Quest2name1
Inst48Quest2name2_HORDE = Inst48Quest2name2
Inst48Quest2name3_HORDE = Inst48Quest2name3
Inst48Quest2name4_HORDE = Inst48Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst48Quest3_HORDE = Inst48Quest3
Inst48Quest3_HORDE_Aim = Inst48Quest3_Aim
Inst48Quest3_HORDE_Location = Inst48Quest3_Location
Inst48Quest3_HORDE_Note = Inst48Quest3_Note
Inst48Quest3_HORDE_Prequest = Inst48Quest3_Prequest
Inst48Quest3_HORDE_Folgequest = Inst48Quest3_Folgequest
--
Inst48Quest3name1_HORDE = Inst48Quest3name1
Inst48Quest3name2_HORDE = Inst48Quest3name2
Inst48Quest3name3_HORDE = Inst48Quest3name3
Inst48Quest3name4_HORDE = Inst48Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst48Quest4_HORDE = Inst48Quest4
Inst48Quest4_HORDE_Aim = Inst48Quest4_Aim
Inst48Quest4_HORDE_Location = Inst48Quest4_Location
Inst48Quest4_HORDE_Note = Inst48Quest4_Note
Inst48Quest4_HORDE_Prequest = Inst48Quest4_Prequest
Inst48Quest4_HORDE_Folgequest = Inst48Quest4_Folgequest
--
Inst48Quest4name1_HORDE = Inst48Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst48Quest5_HORDE = Inst48Quest5
Inst48Quest5_HORDE_Aim = Inst48Quest5_Aim
Inst48Quest5_HORDE_Location = Inst48Quest5_Location
Inst48Quest5_HORDE_Note = Inst48Quest5_Note
Inst48Quest5_HORDE_Prequest = Inst48Quest5_Prequest
Inst48Quest5_HORDE_Folgequest = Inst48Quest5_Folgequest
--
Inst48Quest5name1_HORDE = Inst48Quest5name1



--------------- INST49 - Sethekk Halls ---------------

Inst49Caption = "Sethekk Halls"
Inst49QAA = "5 Quests"
Inst49QAH = "5 Quests"

--Quest 1 Alliance
Inst49Quest1 = "1. Brother Against Brother"
Inst49Quest1_Aim = "Kill Darkweaver Syth in the Sethekk halls, then free Lakka from captivity. Return to Isfar outside the Sethekk Halls when you've completed the rescue."
Inst49Quest1_Location = "Isfar (Terokkar Forest - Auchindoun; "..YELLOW.."44,65"..WHITE..")"
Inst49Quest1_Note = "Darkweaver Syth is at "..YELLOW.."[1]"..WHITE..". Lakka is in a cage in the same room. Openning her cage does not spawn enemies."
Inst49Quest1_Prequest = "None"
Inst49Quest1_Folgequest = "None"
--
Inst49Quest1name1 = "Torc of the Sethekk Prophet"
Inst49Quest1name2 = "Sethekk Oracle's Focus"
Inst49Quest1name3 = "Talon Lord's Collar"
Inst49Quest1name4 = "Mark of the Ravenguard"

--Quest 2 Alliance
Inst49Quest2 = "2. Terokk's Legacy"
Inst49Quest2_Aim = "Bring Terokk's Mask, Terokk's Quill, and the Saga of Terokk to Isfar outside the Sethekk Halls."
Inst49Quest2_Location = "Isfar (Terokkar Forest - Auchindoun; "..YELLOW.."44,65"..WHITE..")"
Inst49Quest2_Note = "Terokk's Mask drops off Darkweaver Syth at "..YELLOW.."[1]"..WHITE..", the Saga of Terokk is found at "..YELLOW.."[2]"..WHITE.." and Terokk's Quill drops from Talon King Ikiss at "..YELLOW.."[3]"..WHITE.."."
Inst49Quest2_Prequest = "None"
Inst49Quest2_Folgequest = "None"
--
Inst49Quest2name1 = "The Saga of Terokk"
Inst49Quest2name2 = "Terokk's Mask"
Inst49Quest2name3 = "Terokk's Quill"

--Quest 3 Alliance
Inst49Quest3 = "3. Vanquish the Raven God (Druid - Heroic)"
Inst49Quest3_Aim = "Slay the Raven God and return to Morthis Whisperwing at Cenarion Refuge."
Inst49Quest3_Location = "Morthis Whisperwing (Zangarmarsh - Cenarion Refuge; "..YELLOW.."80,65"..WHITE..")"
Inst49Quest3_Note = "Requires Heroic Dungeon Difficulty. This is the last quest in the Druid Swift Flight Form questline. The Raven God Anzu is summoned at "..YELLOW.."[2]"..WHITE.." with materials provided by the quest giver."
Inst49Quest3_Prequest = "The Eagle's Essence -> Chasing the Moonstone"
Inst49Quest3_Folgequest = "None"
--
Inst49Quest3name1 = "Idol of the Raven Goddess"

--Quest 4 Alliance
Inst49Quest4 = "4. Kalynna's Request (Heroic)"
Inst49Quest4_Aim = "Kalynna Lathred wants you to retrieve the Tome of Dusk from Grand Warlock Nethekurse in the Shattered Halls of Hellfire Citadel and the Book of Forgotten Names from Darkweaver Syth in the Sethekk Halls in Auchindoun."
Inst49Quest4_Location = "Kalynna Lathred (Netherstorm - Area 52; "..YELLOW.."32,63"..WHITE..")"
Inst49Quest4_Note = "Requires Heroic Dungeon Difficulty.\n\nDarkweaver Syth is at "..YELLOW.."[1]"..WHITE..". The Tome of Dusk drops in Shattered Halls."
Inst49Quest4_Prequest = "A Colleague's Aid ("..YELLOW.."Karazhan"..WHITE..")"
Inst49Quest4_Folgequest = "Nightbane ("..YELLOW.."Karazhan"..WHITE..")"
-- No Rewards for this quest

--Quest 5 Alliance
Inst49Quest5 = "5. Wanted: The Headfeathers of Ikiss"
Inst49Quest5_Aim = "Wind Trader Zhareem has asked you to acquire The Headfeathers of Ikiss. Deliver them to him in Shattrath's Lower City to collect the reward."
Inst49Quest5_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst49Quest5_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nTalon King Ikiss is at "..YELLOW.."[3]"..WHITE.."."
Inst49Quest5_Prequest = "None"
Inst49Quest5_Folgequest = "None"
--
Inst49Quest5name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst49Quest1_HORDE = Inst49Quest1
Inst49Quest1_HORDE_Aim = Inst49Quest1_Aim
Inst49Quest1_HORDE_Location = Inst49Quest1_Location
Inst49Quest1_HORDE_Note = Inst49Quest1_Note
Inst49Quest1_HORDE_Prequest = Inst49Quest1_Prequest
Inst49Quest1_HORDE_Folgequest = Inst49Quest1_Folgequest
--
Inst49Quest1name1_HORDE = Inst49Quest1name1
Inst49Quest1name2_HORDE = Inst49Quest1name2
Inst49Quest1name3_HORDE = Inst49Quest1name3
Inst49Quest1name4_HORDE = Inst49Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst49Quest2_HORDE = Inst49Quest2
Inst49Quest2_HORDE_Aim = Inst49Quest2_Aim
Inst49Quest2_HORDE_Location = Inst49Quest2_Location
Inst49Quest2_HORDE_Note = Inst49Quest2_Note
Inst49Quest2_HORDE_Prequest = Inst49Quest2_Prequest
Inst49Quest2_HORDE_Folgequest = Inst49Quest2_Folgequest
--
Inst49Quest2name1_HORDE = Inst49Quest2name1
Inst49Quest2name2_HORDE = Inst49Quest2name2
Inst49Quest2name3_HORDE = Inst49Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst49Quest3_HORDE = Inst49Quest3
Inst49Quest3_HORDE_Aim = Inst49Quest3_Aim
Inst49Quest3_HORDE_Location = Inst49Quest3_Location
Inst49Quest3_HORDE_Note = Inst49Quest3_Note
Inst49Quest3_HORDE_Prequest = Inst49Quest3_Prequest
Inst49Quest3_HORDE_Folgequest = Inst49Quest3_Folgequest
--
Inst49Quest3name1_HORDE = Inst49Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst49Quest4_HORDE = Inst49Quest4
Inst49Quest4_HORDE_Aim = Inst49Quest4_Aim
Inst49Quest4_HORDE_Location = Inst49Quest4_Location
Inst49Quest4_HORDE_Note = Inst49Quest4_Note
Inst49Quest4_HORDE_Prequest = Inst49Quest4_Prequest
Inst49Quest4_HORDE_Folgequest = Inst49Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst49Quest5_HORDE = Inst49Quest5
Inst49Quest5_HORDE_Aim = Inst49Quest5_Aim
Inst49Quest5_HORDE_Location = Inst49Quest5_Location
Inst49Quest5_HORDE_Note = Inst49Quest5_Note
Inst49Quest5_HORDE_Prequest = Inst49Quest5_Prequest
Inst49Quest5_HORDE_Folgequest = Inst49Quest5_Folgequest
--
Inst49Quest5name1_HORDE = Inst49Quest5name1



--------------- INST50 - Shadow Labyrinth ---------------

Inst50Caption = "Shadow Labyrinth"
Inst50QAA = "11 Quests"
Inst50QAH = "11 Quests"

--Quest 1 Alliance
Inst50Quest1 = "1. Find Spy To'gun"
Inst50Quest1_Aim = "Locate Spy To'gun in the Shadow Labyrinth of Auchindoun."
Inst50Quest1_Location = "Spy Grik'tha (Terokkar Forest - Auchindoun; "..YELLOW.."40,72"..WHITE..")"
Inst50Quest1_Note = "To'gun is at "..YELLOW.."[1]"..WHITE..", and also shows on minimap"
Inst50Quest1_Prequest = "None"
Inst50Quest1_Folgequest = "The Soul Devices"
-- No Rewards for this quest

--Quest 2 Alliance
Inst50Quest2 = "2. The Soul Devices"
Inst50Quest2_Aim = "Steal 5 Soul Devices and deliver them to Spymistress Mehlisah Highcrown at the Terrace of the Light in Shattrath City."
Inst50Quest2_Location = "Spy To'gun (Shadow Labyrinth; "..YELLOW.."[1]"..WHITE..")"
Inst50Quest2_Note = "Soul Devices are the dark purple orbs that can be found scattered around the instance. Spymistress Mehlisah Highcrown is at (Shattrath City - Terrace of Light; "..YELLOW.."51,45"..WHITE..")"
Inst50Quest2_Prequest = "Find Spy To'gun"
Inst50Quest2_Folgequest = "None"
--
Inst50Quest2name1 = "Shattrath Wraps"
Inst50Quest2name2 = "Spymistress's Wristguards"
Inst50Quest2name3 = "Auchenai Bracers"
Inst50Quest2name4 = "Sha'tari Wrought Armguards"

--Quest 3 Alliance
Inst50Quest3 = "3. The Book of Fel Names"
Inst50Quest3_Aim = "Venture inside the Shadow Labyrinth in Auchindoun and obtain the Book of Fel Names from Blackheart the Inciter. Return to Altruis in Nagrand once you've completed this task."
Inst50Quest3_Location = "Altruis the Sufferer (Nagrand; "..YELLOW.."27,43"..WHITE..")"
Inst50Quest3_Note = "Blackheart the Inciter is at "..YELLOW.."[3]"..WHITE..". This is the last part of a chain quest that starts in Shadowmoon Valley at "..YELLOW.."61,28"..WHITE.." for Aldor and "..YELLOW.."55,58"..WHITE.." for Scryer"
Inst50Quest3_Prequest = "Illidan's Pupil"
Inst50Quest3_Folgequest = "Return to the Aldor or Return to the Scryers"
-- No Rewards for this quest

--Quest 4 Alliance
Inst50Quest4 = "4. Trouble at Auchindoun"
Inst50Quest4_Aim = "Report to Field Commander Mahfuun at the entrance to the Shadow Labyrinth at Auchindoun in Terokkar Forest."
Inst50Quest4_Location = "Spymistress Mehlisah Highcrown (Shattrath City - Terrace of Light; "..YELLOW.."51,45"..WHITE..")"
Inst50Quest4_Note = "Field Commander Mahfuun is at (Terrokar Forest - Auchindoun; "..YELLOW.."40,72"..WHITE.."), just out the Shadow Labyrinth entrance."
Inst50Quest4_Prequest = "None"
Inst50Quest4_Folgequest = "The Codex of Blood"
-- No Rewards for this quest

--Quest 5 Alliance
Inst50Quest5 = "5. The Codex of Blood"
Inst50Quest5_Aim = "Read from the Codex of Blood in the Shadow Labyrinth of Auchindoun."
Inst50Quest5_Location = "Field Commander Mahfuun (Terrokar Forest - Auchindoun; "..YELLOW.."40,72"..WHITE..")"
Inst50Quest5_Note = "The Codex of Blood is just in front of Grandmaster Vorpil at "..YELLOW.."[4]"..WHITE.."."
Inst50Quest5_Prequest = "Trouble at Auchindoun"
Inst50Quest5_Folgequest = "Into the Heart of the Labyrinth"
-- No Rewards for this quest

--Quest 6 Alliance
Inst50Quest6 = "6. Into the Heart of the Labyrinth"
Inst50Quest6_Aim = "Destroy Murmur and inform Spymistress Mehlisah Highcrown at the Terrace of Light in Shattrath City of the events that have transpired inside the Shadow Labyrinth."
Inst50Quest6_Location = "The Codex of Blood (Shadow Labyrinth; "..YELLOW.."[4]"..WHITE..")"
Inst50Quest6_Note = "Murmur is at "..YELLOW.."[5]"..WHITE..". Spymistress Mehlisah Highcrown is at (Shattrath City - Terrace of Light; "..YELLOW.."51,45"..WHITE..")"
Inst50Quest6_Prequest = "The Codex of Blood"
Inst50Quest6_Folgequest = "None"
--
Inst50Quest6name1 = "Shattrath Jumpers"
Inst50Quest6name2 = "Spymistress's Boots"
Inst50Quest6name3 = "Auchenai Boots"
Inst50Quest6name4 = "Sha'tari Wrought Greaves"

--Quest 7 Alliance
Inst50Quest7 = "7. Trial of the Naaru: Strength (Heroic)"
Inst50Quest7_Aim = "A'dal in Shattrath City wants you to recover Kalithresh's Trident and Murmur's Essence."
Inst50Quest7_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst50Quest7_Note = "Requires Heroic Dungeon Difficulty. Murmur is at "..YELLOW.."[5]"..WHITE..". Kalithresh's Trident comes from The Steamvault.\n\nThis quest used to be required to enter Tempest Keep: The Eye, but is no longer necessary."
Inst50Quest7_Prequest = "None"
Inst50Quest7_Folgequest = "None"
-- No Rewards for this quest

--Quest 8 Alliance
Inst50Quest8 = "8. Entry Into Karazhan"
Inst50Quest8_Aim = "Khadgar wants you to enter the Shadow Labyrinth at Auchindoun and retrieve the First Key Fragment from an Arcane Container hidden there. Return to Khadgar with the fragment."
Inst50Quest8_Location = "Khadgar (Shattrath City - Terrace of Light; "..YELLOW.."54,44"..WHITE..")"
Inst50Quest8_Note = "Part of the Karazhan attunement line. The Arcane Container is next to Murmur at "..YELLOW.."[5]"..WHITE..". Opening it will spawn an elemental that must be killed to get the fragment."
Inst50Quest8_Prequest = "Khadgar"
Inst50Quest8_Folgequest = "Entry into Karazhan"
-- No Rewards for this quest

--Quest 9 Alliance
Inst50Quest9 = "9. The Lexicon Demonica"
Inst50Quest9_Aim = "Obtain the Lexicon Demonica from Grandmaster Vorpil and bring it to David Wayne at Wayne's Refuge."
Inst50Quest9_Location = "David Wayne (Terokkar Forest - Wayne's Refuge; "..YELLOW.."78,39"..WHITE..")."
Inst50Quest9_Note = "Grandmaster Vorpil is at "..YELLOW.."[4]"..WHITE..". Completing this quest along with Fresh from the Mechanar ("..YELLOW.."TK: The Mechanar"..WHITE..") will open up two new quests from David Wayne.\n\nThe item will not drop in Heroic mode."
Inst50Quest9_Prequest = "Additional Materials"
Inst50Quest9_Folgequest = "None"
-- No Rewards for this quest

--Quest 10 Alliance
Inst50Quest10 = "10. Wanted: Murmur's Whisper"
Inst50Quest10_Aim = "Wind Trader Zhareem has asked you to obtain Murmur's Whisper. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst50Quest10_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst50Quest10_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nMurmur is at "..YELLOW.."[5]"..WHITE.."."
Inst50Quest10_Prequest = "None"
Inst50Quest10_Folgequest = "None"
--
Inst50Quest10name1 = "Badge of Justice"

--Quest 11 Alliance
Inst50Quest11 = "11. Wanted: Malicious Instructors"
Inst50Quest11_Aim = "Nether-Stalker Mah'duun wants you to kill 3 Malicious Instructors. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst50Quest11_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst50Quest11_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst50Quest11_Prequest = "None"
Inst50Quest11_Folgequest = "None"
--
Inst50Quest11name1 = "Ethereum Prison Key"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst50Quest1_HORDE = Inst50Quest1
Inst50Quest1_HORDE_Aim = Inst50Quest1_Aim
Inst50Quest1_HORDE_Location = Inst50Quest1_Location
Inst50Quest1_HORDE_Note = Inst50Quest1_Note
Inst50Quest1_HORDE_Prequest = Inst50Quest1_Prequest
Inst50Quest1_HORDE_Folgequest = Inst50Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst50Quest2_HORDE = Inst50Quest2
Inst50Quest2_HORDE_Aim = Inst50Quest2_Aim
Inst50Quest2_HORDE_Location = Inst50Quest2_Location
Inst50Quest2_HORDE_Note = Inst50Quest2_Note
Inst50Quest2_HORDE_Prequest = Inst50Quest2_Prequest
Inst50Quest2_HORDE_Folgequest = Inst50Quest2_Folgequest
--
Inst50Quest2name1_HORDE = Inst50Quest2name1
Inst50Quest2name2_HORDE = Inst50Quest2name2
Inst50Quest2name3_HORDE = Inst50Quest2name3
Inst50Quest2name4_HORDE = Inst50Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst50Quest3_HORDE = Inst50Quest3
Inst50Quest3_HORDE_Aim = Inst50Quest3_Aim
Inst50Quest3_HORDE_Location = Inst50Quest3_Location
Inst50Quest3_HORDE_Note = Inst50Quest3_Note
Inst50Quest3_HORDE_Prequest = Inst50Quest3_Prequest
Inst50Quest3_HORDE_Folgequest = Inst50Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst50Quest4_HORDE = Inst50Quest4
Inst50Quest4_HORDE_Aim = Inst50Quest4_Aim
Inst50Quest4_HORDE_Location = Inst50Quest4_Location
Inst50Quest4_HORDE_Note = Inst50Quest4_Note
Inst50Quest4_HORDE_Prequest = Inst50Quest4_Prequest
Inst50Quest4_HORDE_Folgequest = Inst50Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst50Quest5_HORDE = Inst50Quest5
Inst50Quest5_HORDE_Aim = Inst50Quest5_Aim
Inst50Quest5_HORDE_Location = Inst50Quest5_Location
Inst50Quest5_HORDE_Note = Inst50Quest5_Note
Inst50Quest5_HORDE_Prequest = Inst50Quest5_Prequest
Inst50Quest5_HORDE_Folgequest = Inst50Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst50Quest6_HORDE = Inst50Quest6
Inst50Quest6_HORDE_Aim = Inst50Quest6_Aim
Inst50Quest6_HORDE_Location = Inst50Quest6_Location
Inst50Quest6_HORDE_Note = Inst50Quest6_Note
Inst50Quest6_HORDE_Prequest = Inst50Quest6_Prequest
Inst50Quest6_HORDE_Folgequest = Inst50Quest6_Folgequest
--
Inst50Quest6name1_HORDE = Inst50Quest6name1
Inst50Quest6name2_HORDE = Inst50Quest6name2
Inst50Quest6name3_HORDE = Inst50Quest6name3
Inst50Quest6name4_HORDE = Inst50Quest6name4

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst50Quest7_HORDE = Inst50Quest7
Inst50Quest7_HORDE_Aim = Inst50Quest7_Aim
Inst50Quest7_HORDE_Location = Inst50Quest7_Location
Inst50Quest7_HORDE_Note = Inst50Quest7_Note
Inst50Quest7_HORDE_Prequest = Inst50Quest7_Prequest
Inst50Quest7_HORDE_Folgequest = Inst50Quest7_Folgequest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst50Quest8_HORDE = Inst50Quest8
Inst50Quest8_HORDE_Aim = Inst50Quest8_Aim
Inst50Quest8_HORDE_Location = Inst50Quest8_Location
Inst50Quest8_HORDE_Note = Inst50Quest8_Note
Inst50Quest8_HORDE_Prequest = Inst50Quest8_Prequest
Inst50Quest8_HORDE_Folgequest = Inst50Quest8_Folgequest
Inst50Quest8_HORDE_Level = Inst50Quest8_Level
Inst50Quest8_HORDE_Attain = Inst50Quest8_Attain
Inst50Quest8PreQuest_HORDE = Inst50Quest8PreQuest
-- No Rewards for this quest

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst50Quest9_HORDE = Inst50Quest9
Inst50Quest9_HORDE_Aim = Inst50Quest9_Aim
Inst50Quest9_HORDE_Location = Inst50Quest9_Location
Inst50Quest9_HORDE_Note = Inst50Quest9_Note
Inst50Quest9_HORDE_Prequest = Inst50Quest9_Prequest
Inst50Quest9_HORDE_Folgequest = Inst50Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst50Quest10_HORDE = Inst50Quest10
Inst50Quest10_HORDE_Aim = Inst50Quest10_Aim
Inst50Quest10_HORDE_Location = Inst50Quest10_Location
Inst50Quest10_HORDE_Note = Inst50Quest10_Note
Inst50Quest10_HORDE_Prequest = Inst50Quest10_Prequest
Inst50Quest10_HORDE_Folgequest = Inst50Quest10_Folgequest
--
Inst50Quest10name1_HORDE = Inst50Quest10name1

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst50Quest11_HORDE = Inst50Quest11
Inst50Quest11_HORDE_Aim = Inst50Quest11_Aim
Inst50Quest11_HORDE_Location = Inst50Quest11_Location
Inst50Quest11_HORDE_Note = Inst50Quest11_Note
Inst50Quest11_HORDE_Prequest = Inst50Quest11_Prequest
Inst50Quest11_HORDE_Folgequest = Inst50Quest11_Folgequest
--
Inst50Quest11name1_HORDE = Inst50Quest11name1



--------------- INST51 - Serpentshrine Cavern ---------------

Inst51Caption = "Serpentshrine Cavern"
Inst51QAA = "2 Quests"
Inst51QAH = "2 Quests"

--Quest 1 Alliance
Inst51Quest1 = "1. The Vials of Eternity"
Inst51Quest1_Aim = "Soridormi at Caverns of Time wants you to retrieve Vashj's Vial Remnant from Lady Vashj at Coilfang Reservoir and Kael's Vial Remnant from Kael'thas Sunstrider at Tempest Keep."
Inst51Quest1_Location = "Soridormi (Tanaris - Caverns of Time; "..YELLOW.."58,57"..WHITE.."). NPC walks around the area."
Inst51Quest1_Note = "This quest is needed for attunement for Battle of Mount Hyjal. Lady Vashj is at "..YELLOW.."[6]"..WHITE.."."
Inst51Quest1_Prequest = "None"
Inst51Quest1_Folgequest = "None"
-- No Rewards for this quest

--Quest 2 Alliance
Inst51Quest2 = "2. The Secret Compromised"
Inst51Quest2_Aim = "Travel to the Warden's Cage in Shadowmoon Valley and speak to Akama."
Inst51Quest2_Location = "Seer Olum (Serpentshrine Cavern; "..YELLOW.."[4]"..WHITE..")"
Inst51Quest2_Note = "Akama is at (Shadowmoon Valley - Warden's Cage; "..YELLOW.."58,48"..WHITE..").\n\nThis is part of the Black Temple attunement questline that starts from Anchorite Ceyla (Shadowmoon Valley - Altar of Sha'tar; "..YELLOW.."62,38"..WHITE..") for Aldor and Arcanist Thelis (Shadowmoon Valley - Sanctum of the Stars; "..YELLOW.."56,59"..WHITE..") for Scryers."
Inst51Quest2_Prequest = "Tablets of Baa'ri -> Akama's Promise"
Inst51Quest2_Folgequest = "Ruse of the Ashtongue ("..YELLOW.."The Eye"..WHITE..")"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst51Quest1_HORDE = Inst51Quest1
Inst51Quest1_HORDE_Aim = Inst51Quest1_Aim
Inst51Quest1_HORDE_Location = Inst51Quest1_Location
Inst51Quest1_HORDE_Note = Inst51Quest1_Note
Inst51Quest1_HORDE_Prequest = Inst51Quest1_Prequest
Inst51Quest1_HORDE_Folgequest = Inst51Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst51Quest2_HORDE = Inst51Quest2
Inst51Quest2_HORDE_Aim = Inst51Quest2_Aim
Inst51Quest2_HORDE_Location = Inst51Quest2_Location
Inst51Quest2_HORDE_Note = Inst51Quest2_Note
Inst51Quest2_HORDE_Prequest = Inst51Quest2_Prequest
Inst51Quest2_HORDE_Folgequest = Inst51Quest2_Folgequest
-- No Rewards for this quest



--------------- INST52 - Black Morass ---------------

Inst52Caption = "Black Morass"
Inst52QAA = "7 Quests"
Inst52QAH = "7 Quests"

--Quest 1 Alliance
Inst52Quest1 = "1. The Black Morass"
Inst52Quest1_Aim = "Travel through the Caverns of Time to the Black Morass during the opening of the Dark Portal and speak with Sa'at."
Inst52Quest1_Location = "Andormu (Tanaris - Caverns of Time; "..YELLOW.."58,54"..WHITE..")"
Inst52Quest1_Note = "Must have completed Escape from Durnholde Keep to be attuned for Black Morass. Sa'at is just a little bit inside the instance."
Inst52Quest1_Prequest = "None"
Inst52Quest1_Folgequest = "The Opening of the Dark Portal"
-- No Rewards for this quest

--Quest 2 Alliance
Inst52Quest2 = "2. The Opening of the Dark Portal"
Inst52Quest2_Aim = "Sa'at inside the Black Morass of the Caverns of Time has tasked you with defending Medivh until he succeeds in opening the Dark Portal. Return to Sa'at should you succeed in your task."
Inst52Quest2_Location = "Sa'at (Black Morass; "..YELLOW.."Entrance"..WHITE..")"
Inst52Quest2_Note = "If you fail, you'll have to start the event over from the beginning."
Inst52Quest2_Prequest = "The Black Morass"
Inst52Quest2_Folgequest = "Hero of the Brood"
-- No Rewards for this quest

--Quest 3 Alliance
Inst52Quest3 = "3. Hero of the Brood"
Inst52Quest3_Aim = "Return to the child, Andormu, at the Caverns of Time in the Tanaris desert."
Inst52Quest3_Location = "Andormu (Tanaris - Caverns of Time; "..YELLOW.."58,54"..WHITE..")"
Inst52Quest3_Note = ""
Inst52Quest3_Prequest = "The Opening of the Dark Portal"
Inst52Quest3_Folgequest = "None"
--
Inst52Quest3name1 = "Band of the Guardian"
Inst52Quest3name2 = "Keeper's Ring of Piety"
Inst52Quest3name3 = "Time-bending Gem"
Inst52Quest3name4 = "Andormu's Tear"

--Quest 4 Alliance
Inst52Quest4 = "4. The Master's Touch"
Inst52Quest4_Aim = "Go into the Caverns of Time and convince Medivh to enable your Restored Apprentice's Key"
Inst52Quest4_Location = "Khadgar (Shatrath City - Terrace of Light; "..YELLOW.."54,44"..WHITE..")"
Inst52Quest4_Note = "Part of the Karazhan attunement line. You must be inside the instance when Aeonus dies in order to talk to Medivh."
Inst52Quest4_Prequest = "The Second and Third Fragments"
Inst52Quest4_Folgequest = "Return to Khadgar"
-- No Rewards for this quest

--Quest 5 Alliance
Inst52Quest5 = "5. Master of Elixirs (Alchemy)"
Inst52Quest5_Aim = "Go to the Black Morass in the Caverns of Time and obtain 10 Essences of Infinity from Rift Lords and Rift Keepers. Bring these along with 5 Elixirs of Major Defense, 5 Elixirs of Mastery and 5 Elixirs of Major Agility to Lorokeem in Shattrath's Lower City."
Inst52Quest5_Location = "Lorokeem (Shattrath City - Lower City; "..YELLOW.."46,23"..WHITE..")"
Inst52Quest5_Note = "Alchemy quest. Lorokeem roams the coordinates listed."
Inst52Quest5_Prequest = "Master of Elixirs"
Inst52Quest5_Folgequest = "None"
-- No Rewards for this quest

--Quest 6 Alliance
Inst52Quest6 = "6. Wanted: Aeonus's Hourglass"
Inst52Quest6_Aim = "Wind Trader Zhareem has asked you to acquire Aeonus's Hourglass. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst52Quest6_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst52Quest6_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nAeonus spawns in the last wave."
Inst52Quest6_Prequest = "None"
Inst52Quest6_Folgequest = "None"
--
Inst52Quest6name1 = "Badge of Justice"

--Quest 7 Alliance
Inst52Quest7 = "7. Wanted: Rift Lords"
Inst52Quest7_Aim = "Nether-Stalker Mah'duun wants you to kill 4 Rift Lords. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst52Quest7_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst52Quest7_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst52Quest7_Prequest = "None"
Inst52Quest7_Folgequest = "None"
--
Inst52Quest7name1 = "Ethereum Prison Key"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst52Quest1_HORDE = Inst52Quest1
Inst52Quest1_HORDE_Aim = Inst52Quest1_Aim
Inst52Quest1_HORDE_Location = Inst52Quest1_Location
Inst52Quest1_HORDE_Note = Inst52Quest1_Note
Inst52Quest1_HORDE_Prequest = Inst52Quest1_Prequest
Inst52Quest1_HORDE_Folgequest = Inst52Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst52Quest2_HORDE = Inst52Quest2
Inst52Quest2_HORDE_Aim = Inst52Quest2_Aim
Inst52Quest2_HORDE_Location = Inst52Quest2_Location
Inst52Quest2_HORDE_Note = Inst52Quest2_Note
Inst52Quest2_HORDE_Prequest = Inst52Quest2_Prequest
Inst52Quest2_HORDE_Folgequest = Inst52Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst52Quest3_HORDE = Inst52Quest3
Inst52Quest3_HORDE_Aim = Inst52Quest3_Aim
Inst52Quest3_HORDE_Location = Inst52Quest3_Location
Inst52Quest3_HORDE_Note = Inst52Quest3_Note
Inst52Quest3_HORDE_Prequest = Inst52Quest3_Prequest
Inst52Quest3_HORDE_Folgequest = Inst52Quest3_Folgequest
--
Inst52Quest3name1_HORDE = Inst52Quest3name1
Inst52Quest3name2_HORDE = Inst52Quest3name2
Inst52Quest3name3_HORDE = Inst52Quest3name3
Inst52Quest3name4_HORDE = Inst52Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst52Quest4_HORDE = Inst52Quest4
Inst52Quest4_HORDE_Aim = Inst52Quest4_Aim
Inst52Quest4_HORDE_Location = Inst52Quest4_Location
Inst52Quest4_HORDE_Note = Inst52Quest4_Note
Inst52Quest4_HORDE_Prequest = Inst52Quest4_Prequest
Inst52Quest4_HORDE_Folgequest = Inst52Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst52Quest5_HORDE = Inst52Quest5
Inst52Quest5_HORDE_Aim = Inst52Quest5_Aim
Inst52Quest5_HORDE_Location = Inst52Quest5_Location
Inst52Quest5_HORDE_Note = Inst52Quest5_Note
Inst52Quest5_HORDE_Prequest = Inst52Quest5_Prequest
Inst52Quest5_HORDE_Folgequest = Inst52Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst52Quest6_HORDE = Inst52Quest6
Inst52Quest6_HORDE_Aim = Inst52Quest6_Aim
Inst52Quest6_HORDE_Location = Inst52Quest6_Location
Inst52Quest6_HORDE_Note = Inst52Quest6_Note
Inst52Quest6_HORDE_Prequest = Inst52Quest6_Prequest
Inst52Quest6_HORDE_Folgequest = Inst52Quest6_Folgequest
--
Inst52Quest6name1_HORDE = Inst52Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst52Quest7_HORDE = Inst52Quest7
Inst52Quest7_HORDE_Aim = Inst52Quest7_Aim
Inst52Quest7_HORDE_Location = Inst52Quest7_Location
Inst52Quest7_HORDE_Note = Inst52Quest7_Note
Inst52Quest7_HORDE_Prequest = Inst52Quest7_Prequest
Inst52Quest7_HORDE_Folgequest = Inst52Quest7_Folgequest
--
Inst52Quest7name1_HORDE = Inst52Quest7name1



--------------- INST53 - Battle of Mount Hyjal ---------------

Inst53Caption = "Battle of Mount Hyjal"
Inst53QAA = "1 Quest"
Inst53QAH = "1 Quest"

--Quest 1 Alliance
Inst53Quest1 = "1. An Artifact From the Past"
Inst53Quest1_Aim = "Go to the Caverns of Time in Tanaris and gain access to the Battle of Mount Hyjal. Once inside, defeat Rage Winterchill and bring the Time-Phased Phylactery to Akama in Shadowmoon Valley."
Inst53Quest1_Location = "Akama (Shadowmoon Valley - Warden's Cage; "..YELLOW.."58,48"..WHITE..")"
Inst53Quest1_Note = "Part of the Black Temple attunement line. Rage Winterchill is at "..YELLOW.."[1]"..WHITE.."."
Inst53Quest1_Prequest = "Ruse of the Ashtongue ("..YELLOW.."The Eye"..WHITE..")"
Inst53Quest1_Folgequest = "The Hostage Soul"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst53Quest1_HORDE = Inst53Quest1
Inst53Quest1_HORDE_Aim = Inst53Quest1_Aim
Inst53Quest1_HORDE_Location = Inst53Quest1_Location
Inst53Quest1_HORDE_Note = Inst53Quest1_Note
Inst53Quest1_HORDE_Prequest = Inst53Quest1_Prequest
Inst53Quest1_HORDE_Folgequest = Inst53Quest1_Folgequest
-- No Rewards for this quest



--------------- INST54 - Old Hillsbrad ---------------

Inst54Caption = "Old Hillsbrad"
Inst54QAA = "6 Quests"
Inst54QAH = "6 Quests"

--Quest 1 Alliance
Inst54Quest1 = "1. Old Hillsbrad"
Inst54Quest1_Aim = "Andormu at the Caverns of Time has asked that you venture to Old Hillsbrad and speak with Erozion."
Inst54Quest1_Location = "Andormu (Tanaris - Caverns of Time; "..YELLOW.."58,54"..WHITE..")"
Inst54Quest1_Note = "Must have done the attunement quest that starts from the dragon at the entrance to Caverns of Time."
Inst54Quest1_Prequest = "The Caverns of Time"
Inst54Quest1_Folgequest = "Tareth's Diversion"
-- No Rewards for this quest

--Quest 2 Alliance
Inst54Quest2 = "2. Taretha's Diversion"
Inst54Quest2_Aim = "Travel to Durnholde Keep and set 5 incendiary charges at the barrels located inside each of the internment lodges using the Pack of Incendiary Bombs given to you by Erozion. Then speak to Thrall in the basement prison of Durnholde Keep."
Inst54Quest2_Location = "Erozion (Old Hillsbrad; "..YELLOW.."Entrance"..WHITE..")"
Inst54Quest2_Note = "Thrall is at "..YELLOW.."[2]"..WHITE..". Go to Southshore to hear the story of Ashbringer and see some people with familiar names like Kel'Thuzad and Herod the Bully."
Inst54Quest2_Prequest = "Old Hillsbrad"
Inst54Quest2_Folgequest = "Escape from Durnholde"
-- No Rewards for this quest

--Quest 3 Alliance
Inst54Quest3 = "3. Escape from Durnholde"
Inst54Quest3_Aim = "When you are ready to proceed, let Thrall know. Follow Thrall out of Durnholde Keep and help him free Taretha and fulfill his destiny. Speak with Erozion in Old Hillsbrad should you complete this task."
Inst54Quest3_Location = "Thrall (Old Hillsbrad; "..YELLOW.."[2]"..WHITE..")"
Inst54Quest3_Note = "Make sure everyone accepts the quest before anyone tells Thrall to start. Reportedly, the quest can be shared and successfully completed, though. You get 20 tries at rescuing Thrall after that you'll have to reset the instance and you can't kill the last boss without him as Thrall has to make the final blow."
Inst54Quest3_Prequest = "Taretha's Diversion"
Inst54Quest3_Folgequest = "Return to Andormu"
-- No Rewards for this quest

--Quest 4 Alliance
Inst54Quest4 = "4. Return to Andormu"
Inst54Quest4_Aim = "Return to the child Andormu at the Caverns of Time in the Tanaris desert."
Inst54Quest4_Location = "Erozion (Old Hillsbrad; "..YELLOW.."Entrance"..WHITE..")"
Inst54Quest4_Note = "Andormu is at (Tanaris - Caverns of Time; "..YELLOW.."58,54"..WHITE.."). Completing this quest allows you to enter Black Morass."
Inst54Quest4_Prequest = "Escape from Durnholde"
Inst54Quest4_Folgequest = "None"
--
Inst54Quest4name1 = "Tempest's Touch"
Inst54Quest4name2 = "Southshore Sneakers"
Inst54Quest4name3 = "Tarren Mill Defender's Cinch"
Inst54Quest4name4 = "Warchief's Mantle"

--Quest 5 Alliance
Inst54Quest5 = "5. Wanted: The Epoch Hunter's Head"
Inst54Quest5_Aim = "Wind Trader Zhareem has asked you to obtain the Epoch Hunter's Head. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst54Quest5_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst54Quest5_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nEpoch Hunter is at "..YELLOW.."[5]"..WHITE.."."
Inst54Quest5_Prequest = "None"
Inst54Quest5_Folgequest = "None"
--
Inst54Quest5name1 = "Badge of Justice"

--Quest 6 Alliance
Inst54Quest6 = "6. Nice Hat..."
Inst54Quest6_Aim = "Don Carlos has inadvertently challenged you to defeat his younger self in Old Hillsbrad. Afterwards, bring Don Carlos' Hat to him in Tanaris as proof."
Inst54Quest6_Location = "Don Carlos (Tanaris; "..YELLOW.."54,29"..WHITE..")"
Inst54Quest6_Note = "Don Carlos patrols the road near "..YELLOW.."[??]"..WHITE.."."
Inst54Quest6_Prequest = "None"
Inst54Quest6_Folgequest = "None"
--
Inst54Quest6name1 = "Haliscan Brimmed Hat"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst54Quest1_HORDE = Inst54Quest1
Inst54Quest1_HORDE_Aim = Inst54Quest1_Aim
Inst54Quest1_HORDE_Location = Inst54Quest1_Location
Inst54Quest1_HORDE_Note = Inst54Quest1_Note
Inst54Quest1_HORDE_Prequest = Inst54Quest1_Prequest
Inst54Quest1_HORDE_Folgequest = Inst54Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst54Quest2_HORDE = Inst54Quest2
Inst54Quest2_HORDE_Aim = Inst54Quest2_Aim
Inst54Quest2_HORDE_Location = Inst54Quest2_Location
Inst54Quest2_HORDE_Note = Inst54Quest2_Note
Inst54Quest2_HORDE_Prequest = Inst54Quest2_Prequest
Inst54Quest2_HORDE_Folgequest = Inst54Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst54Quest3_HORDE = Inst54Quest3
Inst54Quest3_HORDE_Aim = Inst54Quest3_Aim
Inst54Quest3_HORDE_Location = Inst54Quest3_Location
Inst54Quest3_HORDE_Note = Inst54Quest3_Note
Inst54Quest3_HORDE_Prequest = Inst54Quest3_Prequest
Inst54Quest3_HORDE_Folgequest = Inst54Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst54Quest4_HORDE = Inst54Quest4
Inst54Quest4_HORDE_Aim = Inst54Quest4_Aim
Inst54Quest4_HORDE_Location = Inst54Quest4_Location
Inst54Quest4_HORDE_Note = Inst54Quest4_Note
Inst54Quest4_HORDE_Prequest = Inst54Quest4_Prequest
Inst54Quest4_HORDE_Folgequest = Inst54Quest4_Folgequest
--
Inst54Quest4name1_HORDE = Inst54Quest4name1
Inst54Quest4name2_HORDE = Inst54Quest4name2
Inst54Quest4name3_HORDE = Inst54Quest4name3
Inst54Quest4name4_HORDE = Inst54Quest4name4

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst54Quest5_HORDE = Inst54Quest5
Inst54Quest5_HORDE_Aim = Inst54Quest5_Aim
Inst54Quest5_HORDE_Location = Inst54Quest5_Location
Inst54Quest5_HORDE_Note = Inst54Quest5_Note
Inst54Quest5_HORDE_Prequest = Inst54Quest5_Prequest
Inst54Quest5_HORDE_Folgequest = Inst54Quest5_Folgequest
--
Inst54Quest5name1_HORDE = Inst54Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst54Quest6_HORDE = Inst54Quest6
Inst54Quest6_HORDE_Aim = Inst54Quest6_Aim
Inst54Quest6_HORDE_Location = Inst54Quest6_Location
Inst54Quest6_HORDE_Note = Inst54Quest6_Note
Inst54Quest6_HORDE_Prequest = Inst54Quest6_Prequest
Inst54Quest6_HORDE_Folgequest = Inst54Quest6_Folgequest
--
Inst54Quest6name1_HORDE = Inst54Quest6name1



--------------- INST55 - Gruul's Lair ---------------

Inst55Caption = "Gruul's Lair"
Inst55QAA = "1 Quest"
Inst55QAH = "1 Quest"

--Quest 1 Alliance
Inst55Quest1 = "1. The Cudgel of Kar'desh"
Inst55Quest1_Aim = "Skar'this the Heretic in the heroic Slave Pens of Coilfang Reservoir wants you to bring him the Earthen Signet and the Blazing Signet."
Inst55Quest1_Location = "Skar'this the Heretic  (Slave Pens; "..YELLOW.."Heroic [3]"..WHITE..")"
Inst55Quest1_Note = "The Earthen Signet drops off Gruul at "..YELLOW.."[2]"..WHITE.." and the Blazing Signet drops off Nightbane in "..YELLOW.."Karazhan"..WHITE..".\n\nThis quest used to be required to enter Serpentshrine Cavern, but is no longer necessary."
Inst55Quest1_Prequest = "None"
Inst55Quest1_Folgequest = "None"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst55Quest1_HORDE = Inst55Quest1
Inst55Quest1_HORDE_Aim = Inst55Quest1_Aim
Inst55Quest1_HORDE_Location = Inst55Quest1_Location
Inst55Quest1_HORDE_Note = Inst55Quest1_Note
Inst55Quest1_HORDE_Prequest = Inst55Quest1_Prequest
Inst55Quest1_HORDE_Folgequest = Inst55Quest1_Folgequest
-- No Rewards for this quest



--------------- INST56 - Karazhan ---------------

Inst56Caption = "Karazhan"
Inst56QAA = "15 Quests"
Inst56QAH = "15 Quests"

--Quest 1 Alliance
Inst56Quest1 = "1. Assessing the Situation"
Inst56Quest1_Aim = "Find Koren inside Karazhan."
Inst56Quest1_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest1_Note = "Koren is located inside Karazhan, just past Attumen the Huntsman at "..YELLOW.."[6]"..WHITE.."."
Inst56Quest1_Prequest = "Arcane Disturbances -> The Violet Eye"
Inst56Quest1_Folgequest = "Keanna's Log"
-- No Rewards for this quest

--Quest 2 Alliance
Inst56Quest2 = "2. Keanna's Log"
Inst56Quest2_Aim = "Search the Guest Chambers inside Karazhan for Keanna's Log and bring it to Archmage Alturus outside Karazhan."
Inst56Quest2_Location = "Koren (Karazhan; "..YELLOW.."[6]"..WHITE..")"
Inst56Quest2_Note = "The log is in the second room in the hall leading to Maiden of Virtue at "..YELLOW.."[10]"..WHITE..", on a table. Archmage Alturus is at (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")."
Inst56Quest2_Prequest = "Assessing the Situation"
Inst56Quest2_Folgequest = "A Demonic Presence"
-- No Rewards for this quest

--Quest 3 Alliance
Inst56Quest3 = "3. A Demonic Presence"
Inst56Quest3_Aim = "Archmage Alturus wants you to destroy the Demonic Presence at the top of Karazhan."
Inst56Quest3_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest3_Note = "Prince Malchezaar is at "..YELLOW.."[26]"..WHITE.."."
Inst56Quest3_Prequest = "Keanna's Log"
Inst56Quest3_Folgequest = "The New Directive"
-- No Rewards for this quest

--Quest 4 Alliance
Inst56Quest4 = "4. The New Directive"
Inst56Quest4_Aim = "Speak to Archmage Cedric in the Outskirts of Dalaran."
Inst56Quest4_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest4_Note = "Archmage Cedric is at (Alterac Mountains - Dalaran; "..YELLOW.."15,54"..WHITE..")"
Inst56Quest4_Prequest = "A Demonic Presence"
Inst56Quest4_Folgequest = "None"
--
Inst56Quest4name1 = "Violet Badge"

--Quest 5 Alliance
Inst56Quest5 = "5. Medivh's Journal"
Inst56Quest5_Aim = "Archmage Alturus at Deadwind Pass wants you go into Karazhan and speak to Wravien."
Inst56Quest5_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest5_Note = "Requires Honored with The Violet Eye. Wravien is located in the Guardians Library beyond The Curator at "..YELLOW.."[17]"..WHITE.."."
Inst56Quest5_Prequest = "None"
Inst56Quest5_Folgequest = "In Good Hands"
-- No Rewards for this quest

--Quest 6 Alliance
Inst56Quest6 = "6. In Good Hands"
Inst56Quest6_Aim = "Speak to Gradav at the Guardian's Library in Karazhan."
Inst56Quest6_Location = "Wravien (Karazhan; "..YELLOW.."[17]"..WHITE..")"
Inst56Quest6_Note = "Gradav is in the same room as Wravien at "..YELLOW.."[18]"..WHITE.."."
Inst56Quest6_Prequest = "Medivh's Journal"
Inst56Quest6_Folgequest = "Kamsis"
-- No Rewards for this quest

--Quest 7 Alliance
Inst56Quest7 = "7. Kamsis"
Inst56Quest7_Aim = "Speak to Kamsis at the Guardian's Library in Karazhan."
Inst56Quest7_Location = "Gradav (Karazhan; "..YELLOW.."[18]"..WHITE..")"
Inst56Quest7_Note = "Kamsis is in the same room as Gradav at "..YELLOW.."[19]"..WHITE.."."
Inst56Quest7_Prequest = "In Good Hands"
Inst56Quest7_Folgequest = "The Shade of Aran"
-- No Rewards for this quest

--Quest 8 Alliance
Inst56Quest8 = "8. The Shade of Aran"
Inst56Quest8_Aim = "Obtain Medivh's Journal and return to Kamsis at the Guardian's Library in Karazhan."
Inst56Quest8_Location = "Kamsis (Karazhan; "..YELLOW.."[19]"..WHITE..")"
Inst56Quest8_Note = "Shade of Aran drops the journal at "..YELLOW.."[21]"..WHITE.."."
Inst56Quest8_Prequest = "Kamsis"
Inst56Quest8_Folgequest = "The Master's Terrace"
-- No Rewards for this quest

--Quest 9 Alliance
Inst56Quest9 = "9. The Master's Terrace"
Inst56Quest9_Aim = "Go to the Master's Terrace in Karazhan and read Medivh's Journal. Return to Archmage Alturus with Medivh's Journal after completing this task."
Inst56Quest9_Location = "Kamsis (Karazhan; "..YELLOW.."[19]"..WHITE..")"
Inst56Quest9_Note = "Archmage Alturus is at (Deadwind Pass; "..YELLOW.."47,75"..WHITE.."). No combat involved. Enjoy the show."
Inst56Quest9_Prequest = "The Shade of Aran"
Inst56Quest9_Folgequest = "Digging Up the Past"
-- No Rewards for this quest

--Quest 10 Alliance
Inst56Quest10 = "10. Digging Up the Past"
Inst56Quest10_Aim = "Archmage Alturus wants you to go to the mountains south of Karazhan in Deadwind Pass and retrieve a Charred Bone Fragment."
Inst56Quest10_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest10_Note = "The Charred Bone Fragment is located at "..YELLOW.."44,78"..WHITE.." in Deadwind Pass"
Inst56Quest10_Prequest = "The Master's Terrace"
Inst56Quest10_Folgequest = "A Colleague's Aid"
-- No Rewards for this quest

--Quest 11 Alliance
Inst56Quest11 = "11. A Colleague's Aid"
Inst56Quest11_Aim = "Take the Charred Bone Fragment to Kalynna Lathred at Area 52 in Netherstorm."
Inst56Quest11_Location = "Archmage Alturus (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..")"
Inst56Quest11_Note = "Kalynna Lathred is at (Netherstorm - Area 52; "..YELLOW.."32,63"..WHITE..")."
Inst56Quest11_Prequest = "Digging up the Past"
Inst56Quest11_Folgequest = "Kalynna's Request"
-- No Rewards for this quest

--Quest 12 Alliance
Inst56Quest12 = "12. Kalynna's Request"
Inst56Quest12_Aim = "Kalynna Lathred wants you to retrieve the Tome of Dusk from Grand Warlock Nethekurse in the Shattered Halls of Hellfire Citadel and the Book of Forgotten Names from Darkweaver Syth in the Sethekk Halls in Auchindoun."
Inst56Quest12_Location = "Kalynna Lathred (Netherstorm - Area 52; "..YELLOW.."32,63"..WHITE..")"
Inst56Quest12_Note = "This quest requires you to run Heroic Shattered Halls and Heroic Sethekk Halls"
Inst56Quest12_Prequest = "A Colleague's Aid"
Inst56Quest12_Folgequest = "Nightbane"
-- No Rewards for this quest

--Quest 13 Alliance
Inst56Quest13 = "13. Nightbane"
Inst56Quest13_Aim = "Go to the Master's Terrace in Karazhan and use Kalynna's Urn to summon Nightbane. Retrieve the Faint Arcane Essence from Nightbane's corpse and bring it to Archmage Alturus"
Inst56Quest13_Location = "Kalynna Lathred (Netherstorm - Area 52; "..YELLOW.."32,63"..WHITE..")"
Inst56Quest13_Note = "Nightbane is summoned at "..YELLOW.."[15]"..WHITE..". Return to Archmage Alturus at (Deadwind Pass - Karazhan; "..YELLOW.."47,75"..WHITE..") to turn in."
Inst56Quest13_Prequest = "Kalynna's Request"
Inst56Quest13_Folgequest = "None"
--
Inst56Quest13name1 = "Pulsing Amethyst"
Inst56Quest13name2 = "Soothing Amethyst"
Inst56Quest13name3 = "Infused Amethyst"

--Quest 14 Alliance
Inst56Quest14 = "14. The Cudgel of Kar'desh"
Inst56Quest14_Aim = "Skar'this the Heretic in the heroic Slave Pens of Coilfang Reservoir wants you to bring him the Earthen Signet and the Blazing Signet."
Inst56Quest14_Location = "Skar'this the Heretic  (Slave Pens; "..YELLOW.."Heroic [3]"..WHITE..")"
Inst56Quest14_Note = "The Earthen Signet drops off Gruul in "..YELLOW.."Gruul's Lair"..WHITE.." and the Blazing Signet drops off Nightbane at "..YELLOW.."[15]"..WHITE..".\n\nThis quest used to be required to enter Serpentshrine Cavern, but is no longer necessary."
Inst56Quest14_Prequest = "None"
Inst56Quest14_Folgequest = "None"
-- No Rewards for this quest

--Quest 15 Alliance
Inst56Quest15 = "15. Chamber of Secrets"
Inst56Quest15_Aim = "The Argent Dawn Emissary wants you to search the chamber of Tenris Mirkblood within the Servant's Quarters of Karazhan."
Inst56Quest15_Location = "Argent Dawn Emissary  (Capital Cities and Eastern Plaguelands - Light's Hope Chapel)"
Inst56Quest15_Note = "This quest was only available during the Scourge Invasion Event in Late October and Early November of 2008.\n\nTo complete the quest, use the scrolls behind Prince Tenris Mirkblood, who is in the Servants Chambers above Attumen the Huntsmen ("..YELLOW.."[5]"..WHITE.."). As with opening a chest, if another player is using the scrolls your quest might not complete. Try again until it does."
Inst56Quest15_Prequest = "None"
Inst56Quest15_Folgequest = "None"
--
Inst56Quest15name1 = "Monster Slayer's Kit"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst56Quest1_HORDE = Inst56Quest1
Inst56Quest1_HORDE_Aim = Inst56Quest1_Aim
Inst56Quest1_HORDE_Location = Inst56Quest1_Location
Inst56Quest1_HORDE_Note = Inst56Quest1_Note
Inst56Quest1_HORDE_Prequest = Inst56Quest1_Prequest
Inst56Quest1_HORDE_Folgequest = Inst56Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst56Quest2_HORDE = Inst56Quest2
Inst56Quest2_HORDE_Aim = Inst56Quest2_Aim
Inst56Quest2_HORDE_Location = Inst56Quest2_Location
Inst56Quest2_HORDE_Note = Inst56Quest2_Note
Inst56Quest2_HORDE_Prequest = Inst56Quest2_Prequest
Inst56Quest2_HORDE_Folgequest = Inst56Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst56Quest3_HORDE = Inst56Quest3
Inst56Quest3_HORDE_Aim = Inst56Quest3_Aim
Inst56Quest3_HORDE_Location = Inst56Quest3_Location
Inst56Quest3_HORDE_Note = Inst56Quest3_Note
Inst56Quest3_HORDE_Prequest = Inst56Quest3_Prequest
Inst56Quest3_HORDE_Folgequest = Inst56Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst56Quest4_HORDE = Inst56Quest4
Inst56Quest4_HORDE_Aim = Inst56Quest4_Aim
Inst56Quest4_HORDE_Location = Inst56Quest4_Location
Inst56Quest4_HORDE_Note = Inst56Quest4_Note
Inst56Quest4_HORDE_Prequest = Inst56Quest4_Prequest
Inst56Quest4_HORDE_Folgequest = Inst56Quest4_Folgequest
--
Inst56Quest4name1_HORDE = Inst56Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst56Quest5_HORDE = Inst56Quest5
Inst56Quest5_HORDE_Aim = Inst56Quest5_Aim
Inst56Quest5_HORDE_Location = Inst56Quest5_Location
Inst56Quest5_HORDE_Note = Inst56Quest5_Note
Inst56Quest5_HORDE_Prequest = Inst56Quest5_Prequest
Inst56Quest5_HORDE_Folgequest = Inst56Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst56Quest6_HORDE = Inst56Quest6
Inst56Quest6_HORDE_Aim = Inst56Quest6_Aim
Inst56Quest6_HORDE_Location = Inst56Quest6_Location
Inst56Quest6_HORDE_Note = Inst56Quest6_Note
Inst56Quest6_HORDE_Prequest = Inst56Quest6_Prequest
Inst56Quest6_HORDE_Folgequest = Inst56Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst56Quest7_HORDE = Inst56Quest7
Inst56Quest7_HORDE_Aim = Inst56Quest7_Aim
Inst56Quest7_HORDE_Location = Inst56Quest7_Location
Inst56Quest7_HORDE_Note = Inst56Quest7_Note
Inst56Quest7_HORDE_Prequest = Inst56Quest7_Prequest
Inst56Quest7_HORDE_Folgequest = Inst56Quest7_Folgequest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst56Quest8_HORDE = Inst56Quest8
Inst56Quest8_HORDE_Aim = Inst56Quest8_Aim
Inst56Quest8_HORDE_Location = Inst56Quest8_Location
Inst56Quest8_HORDE_Note = Inst56Quest8_Note
Inst56Quest8_HORDE_Prequest = Inst56Quest8_Prequest
Inst56Quest8_HORDE_Folgequest = Inst56Quest8_Folgequest
-- No Rewards for this quest

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst56Quest9_HORDE = Inst56Quest9
Inst56Quest9_HORDE_Aim = Inst56Quest9_Aim
Inst56Quest9_HORDE_Location = Inst56Quest9_Location
Inst56Quest9_HORDE_Note = Inst56Quest9_Note
Inst56Quest9_HORDE_Prequest = Inst56Quest9_Prequest
Inst56Quest9_HORDE_Folgequest = Inst56Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst56Quest10_HORDE = Inst56Quest10
Inst56Quest10_HORDE_Aim = Inst56Quest10_Aim
Inst56Quest10_HORDE_Location = Inst56Quest10_Location
Inst56Quest10_HORDE_Note = Inst56Quest10_Note
Inst56Quest10_HORDE_Prequest = Inst56Quest10_Prequest
Inst56Quest10_HORDE_Folgequest = Inst56Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst56Quest11_HORDE = Inst56Quest11
Inst56Quest11_HORDE_Aim = Inst56Quest11_Aim
Inst56Quest11_HORDE_Location = Inst56Quest11_Location
Inst56Quest11_HORDE_Note = Inst56Quest11_Note
Inst56Quest11_HORDE_Prequest = Inst56Quest11_Prequest
Inst56Quest11_HORDE_Folgequest = Inst56Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst56Quest12_HORDE = Inst56Quest12
Inst56Quest12_HORDE_Aim = Inst56Quest12_Aim
Inst56Quest12_HORDE_Location = Inst56Quest12_Location
Inst56Quest12_HORDE_Note = Inst56Quest12_Note
Inst56Quest12_HORDE_Prequest = Inst56Quest12_Prequest
Inst56Quest12_HORDE_Folgequest = Inst56Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst56Quest13_HORDE = Inst56Quest13
Inst56Quest13_HORDE_Aim = Inst56Quest13_Aim
Inst56Quest13_HORDE_Location = Inst56Quest13_Location
Inst56Quest13_HORDE_Note = Inst56Quest13_Note
Inst56Quest13_HORDE_Prequest = Inst56Quest13_Prequest
Inst56Quest13_HORDE_Folgequest = Inst56Quest13_Folgequest
--
Inst56Quest13name1_HORDE = Inst56Quest13name1
Inst56Quest13name2_HORDE = Inst56Quest13name2
Inst56Quest13name3_HORDE = Inst56Quest13name3

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst56Quest14_HORDE = Inst56Quest14
Inst56Quest14_HORDE_Aim = Inst56Quest14_Aim
Inst56Quest14_HORDE_Location = Inst56Quest14_Location
Inst56Quest14_HORDE_Note = Inst56Quest14_Note
Inst56Quest14_HORDE_Prequest = Inst56Quest14_Prequest
Inst56Quest14_HORDE_Folgequest = Inst56Quest14_Folgequest
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst56Quest15_HORDE = Inst56Quest15
Inst56Quest15_HORDE_Aim = Inst56Quest15_Aim
Inst56Quest15_HORDE_Location = Inst56Quest15_Location
Inst56Quest15_HORDE_Note = Inst56Quest15_Note
Inst56Quest15_HORDE_Prequest = Inst56Quest15_Prequest
Inst56Quest15_HORDE_Folgequest = Inst56Quest15_Folgequest
--
Inst56Quest15name1_HORDE = Inst58Quest13name1



--------------- INST57 - The Arcatraz ---------------

Inst57Caption = "The Arcatraz"
Inst57QAA = "6 Quests"
Inst57QAH = "6 Quests"

--Quest 1 Alliance
Inst57Quest1 = "1. Harbinger of Doom"
Inst57Quest1_Aim = "You have been tasked to go to Tempest Keep's Arcatraz satellite and slay Harbinger Skyriss. Return to A'dal at the Terace of Light in Shattrath City after you have done so."
Inst57Quest1_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst57Quest1_Note = "There is a chain quest that starts in Netherstorm from Nether-Stalker Khay'ji located at (Netherstorm - Area 52; "..YELLOW.."32,64"..WHITE..")."
Inst57Quest1_Prequest = "Warp-Raider Nesaad -> How to Break Into the Arcatraz"
Inst57Quest1_Folgequest = "None"
--
Inst57Quest1name1 = "Potent Sha'tari Pendant"
Inst57Quest1name2 = "A'dal's Recovery Necklace"
Inst57Quest1name3 = "Shattrath Choker of Power"

--Quest 2 Alliance
Inst57Quest2 = "2. Seer Udalo"
Inst57Quest2_Aim = "Find Seer Udalo inside the Arcatraz in Tempest Keep."
Inst57Quest2_Location = "Akama (Shadowmoon Valley - Warden's Cage; "..YELLOW.."58,48"..WHITE..")"
Inst57Quest2_Note = "Seer Udalo is at "..YELLOW.."[5]"..WHITE..", just before the room with the final boss.\n\nThis is part of the Black Temple attunement questline that starts from Anchorite Ceyla (Shadowmoon Valley - Altar of Sha'tar; "..YELLOW.."62,38"..WHITE..") for Aldor and Arcanist Thelis (Shadowmoon Valley - Sanctum of the Stars; "..YELLOW.."56,59"..WHITE..") for Scryers."
Inst57Quest2_Prequest = "Tablets of Baa'ri -> Akama"
Inst57Quest2_Folgequest = "A Mysterious Portent"
-- No Rewards for this quest

--Quest 3 Alliance
Inst57Quest3 = "3. Trial of the Naaru: Tenacity (Heroic)"
Inst57Quest3_Aim = "A'dal in Shattrath City wants you to rescue Millhouse Manastorm from the Arcatraz of Tempest Keep."
Inst57Quest3_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst57Quest3_Note = "This quest must be completed in Heroic dungeon difficulty. Millhouse Manastorm is in the room with Warden Mellichar at "..YELLOW.."[6]"..WHITE..".\n\nThis quest used to be required to enter Tempest Keep: The Eye, but is no longer necessary."
Inst57Quest3_Prequest = "None"
Inst57Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst57Quest4 = "4. The Second and Third Fragments"
Inst57Quest4_Aim = "Obtain the Second Key Fragment from an Arcane Container inside Coilfang Reservoir and the Third Key Fragment from an Arcane Container inside Tempest Keep. Return to Khadgar in Shattrath City after you've completed this task."
Inst57Quest4_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst57Quest4_Note = "Part of the Karazhan attunement line. The Arcane Container is at "..YELLOW.."[2]"..WHITE..". Opening it will spawn an elemental that must be killed to get the fragment. The Second Key Fragment is in The Steamvault."
Inst57Quest4_Prequest = "Entry Into Karazhan ("..YELLOW.."Auch: Shadow Labyrinth"..WHITE..")"
Inst57Quest4_Folgequest = "The Master's Touch ("..YELLOW.."CoT: Black Morass"..WHITE..")"
-- No Rewards for this quest

--Quest 5 Alliance
Inst57Quest5 = "5. Wanted: The Scroll of Skyriss"
Inst57Quest5_Aim = "Wind Trader Zhareem has asked you to obtain The Scroll of Skyriss. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst57Quest5_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst57Quest5_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nHarbinger Skyriss is at "..YELLOW.."[6]"..WHITE.."."
Inst57Quest5_Prequest = "None"
Inst57Quest5_Folgequest = "None"
--
Inst57Quest5name1 = "Badge of Justice"

--Quest 6 Alliance
Inst57Quest6 = "6. Wanted: Arcatraz Sentinels"
Inst57Quest6_Aim = "Nether-Stalker Mah'duun wants you to dismantle 5 Arcatraz Sentinels. Return to him in Shattrath's Lower City once that has been accomplished in order to collect the bounty."
Inst57Quest6_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst57Quest6_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst57Quest6_Prequest = "None"
Inst57Quest6_Folgequest = "None"
--
Inst57Quest6name1 = "Ethereum Prison Key"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst57Quest1_HORDE = Inst57Quest1
Inst57Quest1_HORDE_Aim = Inst57Quest1_Aim
Inst57Quest1_HORDE_Location = Inst57Quest1_Location
Inst57Quest1_HORDE_Note = Inst57Quest1_Note
Inst57Quest1_HORDE_Prequest = Inst57Quest1_Prequest
Inst57Quest1_HORDE_Folgequest = Inst57Quest1_Folgequest
--
Inst57Quest1name1_HORDE = Inst57Quest1name1
Inst57Quest1name2_HORDE = Inst57Quest1name2
Inst57Quest1name3_HORDE = Inst57Quest1name3

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst57Quest2_HORDE = Inst57Quest2
Inst57Quest2_HORDE_Aim = Inst57Quest2_Aim
Inst57Quest2_HORDE_Location = Inst57Quest2_Location
Inst57Quest2_HORDE_Note = Inst57Quest2_Note
Inst57Quest2_HORDE_Prequest = Inst57Quest2_Prequest
Inst57Quest2_HORDE_Folgequest = Inst57Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst57Quest3_HORDE = Inst57Quest3
Inst57Quest3_HORDE_Aim = Inst57Quest3_Aim
Inst57Quest3_HORDE_Location = Inst57Quest3_Location
Inst57Quest3_HORDE_Note = Inst57Quest3_Note
Inst57Quest3_HORDE_Prequest = Inst57Quest3_Prequest
Inst57Quest3_HORDE_Folgequest = Inst57Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst57Quest4_HORDE = Inst57Quest4
Inst57Quest4_HORDE_Aim = Inst57Quest4_Aim
Inst57Quest4_HORDE_Location = Inst57Quest4_Location
Inst57Quest4_HORDE_Note = Inst57Quest4_Note
Inst57Quest4_HORDE_Prequest = Inst57Quest4_Prequest
Inst57Quest4_HORDE_Folgequest = Inst57Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst57Quest5_HORDE = Inst57Quest5
Inst57Quest5_HORDE_Aim = Inst57Quest5_Aim
Inst57Quest5_HORDE_Location = Inst57Quest5_Location
Inst57Quest5_HORDE_Note = Inst57Quest5_Note
Inst57Quest5_HORDE_Prequest = Inst57Quest5_Prequest
Inst57Quest5_HORDE_Folgequest = Inst57Quest5_Folgequest
--
Inst57Quest5name1_HORDE = Inst57Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst57Quest6_HORDE = Inst57Quest6
Inst57Quest6_HORDE_Aim = Inst57Quest6_Aim
Inst57Quest6_HORDE_Location = Inst57Quest6_Location
Inst57Quest6_HORDE_Note = Inst57Quest6_Note
Inst57Quest6_HORDE_Prequest = Inst57Quest6_Prequest
Inst57Quest6_HORDE_Folgequest = Inst57Quest6_Folgequest
--
Inst57Quest6name1_HORDE = Inst57Quest6name1



--------------- INST58 - Botanica ---------------

Inst58Caption = "The Botanica"
Inst58QAA = "5 Quests"
Inst58QAH = "5 Quests"

--Quest 1 Alliance
Inst58Quest1 = "1. How to Break Into the Arcatraz"
Inst58Quest1_Aim = "A'dal has tasked you with the recovery of the Top and Bottom Shards of the Arcatraz Key. Return them to him, and he will fashion them into the Key to the Arcatraz for you."
Inst58Quest1_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst58Quest1_Note = "The Bottom Piece drops off Warp Splinter located at "..YELLOW.."[5]"..WHITE..". The Top piece drops in Mechanar."
Inst58Quest1_Prequest = "Warp-Raider Nesaad -> Special Delivery to Shattrath City"
Inst58Quest1_Folgequest = "Harbinger of Doom ("..YELLOW.."TK: Arcatraz"..WHITE..")"
--
Inst58Quest1name1 = "Sha'tari Anchorite's Cloak"
Inst58Quest1name2 = "A'dal's Gift"
Inst58Quest1name3 = "Naaru Belt of Precision"
Inst58Quest1name4 = "Shattrath's Champion Belt"
Inst58Quest1name5 = "Sha'tari Vindicator's Waistguard"
Inst58Quest1name6 = "Key to the Arcatraz"

--Quest 2 Alliance
Inst58Quest2 = "2. Capturing the Keystone"
Inst58Quest2_Aim = "Venture into Tempest Keep's Botanica and retrieve the Keystone from Commander Sarannis. Bring it to Archmage Vargoth at the Violet Tower."
Inst58Quest2_Location = "Archmage Vargoth (Netherstorm - Kirin'Var Village; "..YELLOW.."58,86"..WHITE..")"
Inst58Quest2_Note = "Commander Sarannis is at "..YELLOW.."[1]"..WHITE..". The keystone will drop on Normal and Heroic."
Inst58Quest2_Prequest = "Finding the Keymaster"
Inst58Quest2_Folgequest = "None"
-- No Rewards for this quest

--Quest 3 Alliance
Inst58Quest3 = "3. Master of Potions (Alchemy)"
Inst58Quest3_Aim = "Lauranna Thar'well wants you to go to the Botanica in Tempest Keep and retrieve the Botanist's Field Guide from High Botanist Freywinn. In addition she also wants you to bring her 5 Super Healing Potions, 5 Super Mana Potions and 5 Major Dreamless Sleep Potions."
Inst58Quest3_Location = "Lauranna Thar'well (Zangarmarsh - Cenarion Refuge; "..YELLOW.."80,64"..WHITE..")"
Inst58Quest3_Note = "Alchemist quest. High Botanist Freywinn is at "..YELLOW.."[2]"..WHITE.."."
Inst58Quest3_Prequest = "Master of Potions"
Inst58Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst58Quest4 = "4. Wanted: A Warp Splinter Clipping"
Inst58Quest4_Aim = "Wind Trader Zhareem has asked you to obtain a Warp Splinter Clipping. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst58Quest4_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst58Quest4_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nWarp Splinter is at "..YELLOW.."[5]"..WHITE.."."
Inst58Quest4_Prequest = "None"
Inst58Quest4_Folgequest = "None"
--
Inst58Quest4name1 = "Badge of Justice"

--Quest 5 Alliance
Inst58Quest5 = "5. Wanted: Sunseeker Channelers"
Inst58Quest5_Aim = "Nether-Stalker Mah'duun wants you to kill 6 Sunseeker Channelers. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst58Quest5_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst58Quest5_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst58Quest5_Prequest = "None"
Inst58Quest5_Folgequest = "None"
--
Inst58Quest5name1 = "Ethereum Prison Key"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst58Quest1_HORDE = Inst58Quest1
Inst58Quest1_HORDE_Aim = Inst58Quest1_Aim
Inst58Quest1_HORDE_Location = Inst58Quest1_Location
Inst58Quest1_HORDE_Note = Inst58Quest1_Note
Inst58Quest1_HORDE_Prequest = Inst58Quest1_Prequest
Inst58Quest1_HORDE_Folgequest = Inst58Quest1_Folgequest
--
Inst58Quest1name1_HORDE = Inst58Quest1name1
Inst58Quest1name2_HORDE = Inst58Quest1name2
Inst58Quest1name3_HORDE = Inst58Quest1name3
Inst58Quest1name4_HORDE = Inst58Quest1name4
Inst58Quest1name5_HORDE = Inst58Quest1name5
Inst58Quest1name6_HORDE = Inst58Quest1name6

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst58Quest2_HORDE = Inst58Quest2
Inst58Quest2_HORDE_Aim = Inst58Quest2_Aim
Inst58Quest2_HORDE_Location = Inst58Quest2_Location
Inst58Quest2_HORDE_Note = Inst58Quest2_Note
Inst58Quest2_HORDE_Prequest = Inst58Quest2_Prequest
Inst58Quest2_HORDE_Folgequest = Inst58Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst58Quest3_HORDE = Inst58Quest3
Inst58Quest3_HORDE_Aim = Inst58Quest3_Aim
Inst58Quest3_HORDE_Location = Inst58Quest3_Location
Inst58Quest3_HORDE_Note = Inst58Quest3_Note
Inst58Quest3_HORDE_Prequest = Inst58Quest3_Prequest
Inst58Quest3_HORDE_Folgequest = Inst58Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst58Quest4_HORDE = Inst58Quest4
Inst58Quest4_HORDE_Aim = Inst58Quest4_Aim
Inst58Quest4_HORDE_Location = Inst58Quest4_Location
Inst58Quest4_HORDE_Note = Inst58Quest4_Note
Inst58Quest4_HORDE_Prequest = Inst58Quest4_Prequest
Inst58Quest4_HORDE_Folgequest = Inst58Quest4_Folgequest
--
Inst58Quest4name1_HORDE = Inst58Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst58Quest5_HORDE = Inst58Quest5
Inst58Quest5_HORDE_Aim = Inst58Quest5_Aim
Inst58Quest5_HORDE_Location = Inst58Quest5_Location
Inst58Quest5_HORDE_Note = Inst58Quest5_Note
Inst58Quest5_HORDE_Prequest = Inst58Quest5_Prequest
Inst58Quest5_HORDE_Folgequest = Inst58Quest5_Folgequest
--
Inst58Quest5name1_HORDE = Inst58Quest5name1



--------------- INST59 - The Mechanar ---------------

Inst59Caption = "The Mechanar"
Inst59QAA = "4 Quests"
Inst59QAH = "4 Quests"

--Quest 1 Alliance
Inst59Quest1 = "1. How to Break Into the Arcatraz"
Inst59Quest1_Aim = "A'dal has tasked you with the recovery of the Top and Bottom Shards of the Arcatraz Key. Return them to him, and he will fashion them into the Key to the Arcatraz for you."
Inst59Quest1_Location = "A'dal (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")"
Inst59Quest1_Note = "The Top Piece drops off Pathaleon the Calculator located at "..YELLOW.."[5]"..WHITE..". The Bottom piece drops in Botanica."
Inst59Quest1_Prequest = "Warp-Raider Nesaad -> Special Delivery to Shattrath City"
Inst59Quest1_Folgequest = "Harbinger of Doom ("..YELLOW.."TK: Arcatraz"..WHITE..")"
--
Inst59Quest1name1 = "Sha'tari Anchorite's Cloak"
Inst59Quest1name2 = "A'dal's Gift"
Inst59Quest1name3 = "Naaru Belt of Precision"
Inst59Quest1name4 = "Shattrath's Champion Belt"
Inst59Quest1name5 = "Sha'tari Vindicator's Waistguard"
Inst59Quest1name6 = "Key to the Arcatraz"

--Quest 2 Alliance
Inst59Quest2 = "2. Fresh from the Mechanar"
Inst59Quest2_Aim = "David Wayne at Wayne's Retreat wants you to bring him an Overcharged Manacell."
Inst59Quest2_Location = "David Wayne (Terokkar Forest - Wayne's Refuge; "..YELLOW.."78,39"..WHITE..")."
Inst59Quest2_Note = "The cell is before Mechano-Lord Capacitus at "..YELLOW.."[3]"..WHITE.." in a box near the wall.\n\nCompleting this quest along with The Lexicon Demonica ("..YELLOW.."Auch: Shadow Labyrinth"..WHITE..") will open up two new quests from David Wayne.\n\nThis quest works in both Normal and Heroic mode."
Inst59Quest2_Prequest = "Additional Materials"
Inst59Quest2_Folgequest = "None"
-- No Rewards for this quest

--Quest 3 Alliance
Inst59Quest3 = "3. Wanted: Pathaleon's Projector"
Inst59Quest3_Aim = "Wind Trader Zhareem has asked you to acquire Pathaleon's Projector. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst59Quest3_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst59Quest3_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nPathaleon the Calculator is at "..YELLOW.."[5]"..WHITE.."."
Inst59Quest3_Prequest = "None"
Inst59Quest3_Folgequest = "None"
--
Inst59Quest3name1 = "Badge of Justice"

--Quest 4 Alliance
Inst59Quest4 = "4. Wanted: Tempest-Forge Destroyers"
Inst59Quest4_Aim = "Nether-Stalker Mah'duun wants you to destroy 5 Tempest-Forge Destroyers. Return to him in Shattrath's Lower City once they all lie dead in order to collect the bounty."
Inst59Quest4_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst59Quest4_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst59Quest4_Prequest = "None"
Inst59Quest4_Folgequest = "None"
--
Inst59Quest4name1 = "Ethereum Prison Key"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst59Quest1_HORDE = Inst59Quest1
Inst59Quest1_HORDE_Aim = Inst59Quest1_Aim
Inst59Quest1_HORDE_Location = Inst59Quest1_Location
Inst59Quest1_HORDE_Note = Inst59Quest1_Note
Inst59Quest1_HORDE_Prequest = Inst59Quest1_Prequest
Inst59Quest1_HORDE_Folgequest = Inst59Quest1_Folgequest
--
Inst59Quest1name1_HORDE = Inst59Quest1name1
Inst59Quest1name2_HORDE = Inst59Quest1name2
Inst59Quest1name3_HORDE = Inst59Quest1name3
Inst59Quest1name4_HORDE = Inst59Quest1name4
Inst59Quest1name5_HORDE = Inst59Quest1name5
Inst59Quest1name6_HORDE = Inst59Quest1name6

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst59Quest2_HORDE = Inst59Quest2
Inst59Quest2_HORDE_Aim = Inst59Quest2_Aim
Inst59Quest2_HORDE_Location = Inst59Quest2_Location
Inst59Quest2_HORDE_Note = Inst59Quest2_Note
Inst59Quest2_HORDE_Prequest = Inst59Quest2_Prequest
Inst59Quest2_HORDE_Folgequest = Inst59Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst59Quest3_HORDE = Inst59Quest3
Inst59Quest3_HORDE_Aim = Inst59Quest3_Aim
Inst59Quest3_HORDE_Location = Inst59Quest3_Location
Inst59Quest3_HORDE_Note = Inst59Quest3_Note
Inst59Quest3_HORDE_Prequest = Inst59Quest3_Prequest
Inst59Quest3_HORDE_Folgequest = Inst59Quest3_Folgequest
--
Inst59Quest3name1_HORDE = Inst59Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst59Quest4_HORDE = Inst59Quest4
Inst59Quest4_HORDE_Aim = Inst59Quest4_Aim
Inst59Quest4_HORDE_Location = Inst59Quest4_Location
Inst59Quest4_HORDE_Note = Inst59Quest4_Note
Inst59Quest4_HORDE_Prequest = Inst59Quest4_Prequest
Inst59Quest4_HORDE_Folgequest = Inst59Quest4_Folgequest
--
Inst59Quest4name1_HORDE = Inst59Quest4name1



--------------- INST61 - The Eye ---------------

Inst61Caption = "The Eye"
Inst61QAA = "3 Quests"
Inst61QAH = "3 Quests"

--Quest 1 Alliance
Inst61Quest1 = "1. Ruse of the Ashtongue"
Inst61Quest1_Aim = "Travel into Tempest Keep and slay Al'ar while wearing the Ashtongue Cowl. Return to Akama in Shadowmoon Valley once you've completed this task."
Inst61Quest1_Location = "Akama (Shadowmoon Valley - Warden's Cage; "..YELLOW.."58,48"..WHITE..")"
Inst61Quest1_Note = "This is part of the Black Temple attunement line."
Inst61Quest1_Prequest = "The Secret Compromised ("..YELLOW.."Serpentshrine Cavern"..WHITE..")"
Inst61Quest1_Folgequest = "An Artifact From the Past ("..YELLOW.."Battle of Mount Hyjal"..WHITE..")"
-- No Rewards for this quest

--Quest 2 Alliance
Inst61Quest2 = "2. Kael'thas and the Verdant Sphere"
Inst61Quest2_Aim = "Take the Verdant Sphere to A'dal in Shattrath City."
Inst61Quest2_Location = "Verdant Sphere (drops from Kael'thas Sunstrider at "..YELLOW.."[4]"..WHITE..")"
Inst61Quest2_Note = "A'dal is at (Shattrath City - Terrace of Light; "..YELLOW.."53,43"..WHITE..")."
Inst61Quest2_Prequest = "None"
Inst61Quest2_Folgequest = "None"
--
Inst61Quest2name1 = "The Sun King's Talisman"
Inst61Quest2name2 = "The Darkener's Grasp"
Inst61Quest2name3 = "Lord Sanguinar's Claim"
Inst61Quest2name4 = "Telonicus's Pendant of Mayhem"

--Quest 3 Alliance
Inst61Quest3 = "3. The Vials of Eternity"
Inst61Quest3_Aim = "Soridormi at Caverns of Time wants you to retrieve Vashj's Vial Remnant from Lady Vashj at Coilfang Reservoir and Kael's Vial Remnant from Kael'thas Sunstrider at Tempest Keep."
Inst61Quest3_Location = "Soridormi (Tanaris - Caverns of Time; "..YELLOW.."58,57"..WHITE.."). NPC walks around the area."
Inst61Quest3_Note = "This quest is needed for attunement for Battle of Mount Hyjal. Kael'thas Sunstrider is at "..YELLOW.."[4]"..WHITE.."."
Inst61Quest3_Prequest = "None"
Inst61Quest3_Folgequest = "None"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst61Quest1_HORDE = Inst61Quest1
Inst61Quest1_HORDE_Aim = Inst61Quest1_Aim
Inst61Quest1_HORDE_Location = Inst61Quest1_Location
Inst61Quest1_HORDE_Note = Inst61Quest1_Note
Inst61Quest1_HORDE_Prequest = Inst61Quest1_Prequest
Inst61Quest1_HORDE_Folgequest = Inst61Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst61Quest2_HORDE = Inst61Quest2
Inst61Quest2_HORDE_Aim = Inst61Quest2_Aim
Inst61Quest2_HORDE_Location = Inst61Quest2_Location
Inst61Quest2_HORDE_Note = Inst61Quest2_Note
Inst61Quest2_HORDE_Prequest = Inst61Quest2_Prequest
Inst61Quest2_HORDE_Folgequest = Inst61Quest2_Folgequest
--
Inst61Quest2name1_HORDE = Inst61Quest2name1
Inst61Quest2name2_HORDE = Inst61Quest2name2
Inst61Quest2name3_HORDE = Inst61Quest2name3
Inst61Quest2name4_HORDE = Inst61Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst61Quest3_HORDE = Inst61Quest3
Inst61Quest3_HORDE_Aim = Inst61Quest3_Aim
Inst61Quest3_HORDE_Location = Inst61Quest3_Location
Inst61Quest3_HORDE_Note = Inst61Quest3_Note
Inst61Quest3_HORDE_Prequest = Inst61Quest3_Prequest
Inst61Quest3_HORDE_Folgequest = Inst61Quest3_Folgequest
-- No Rewards for this quest



--------------- INST62 - Black Temple ---------------

Inst62Caption = "Black Temple"
Inst62QAA = "3 Quests"
Inst62QAH = "3 Quests"

--Quest 1 Alliance
Inst62Quest1 = "1. Seek Out the Ashtongue"
Inst62Quest1_Aim = "Find Akama's Deathsworn inside the Black Temple."
Inst62Quest1_Location = "Xi'ri (Shadowmoon Valley; "..YELLOW.."65,44"..WHITE..")."
Inst62Quest1_Note = "Spirit of Olum is up and to your left once you enter the Black Temple at "..YELLOW.."[1]"..WHITE..". He will teleport you to Seer Kanai once you've High Warlord Naj'entus at "..YELLOW.."[2]"..WHITE.." and Supremus at "..YELLOW.."[3]"..WHITE.."."
Inst62Quest1_Prequest = "The Secret Compromised -> A Distraction for Akama"
Inst62Quest1_Folgequest = "Redemption of the Ashtongue"
-- No Rewards for this quest

--Quest 2 Alliance
Inst62Quest2 = "2. Redemption of the Ashtongue"
Inst62Quest2_Aim = "Help Akama wrest control back of his soul by defeating the Shade of Akama inside the Black Temple. Return to Seer Kanai when you've completed this task."
Inst62Quest2_Location = "Seer Kanai (Black Temple; "..YELLOW.."[5]"..WHITE..")."
Inst62Quest2_Note = "Shade of Akama is at "..YELLOW.."[4]"..WHITE.."."
Inst62Quest2_Prequest = "Seek Out the Ashtongue"
Inst62Quest2_Folgequest = "The Fall of the Betrayer"
-- No Rewards for this quest

--Quest 3 Alliance
Inst62Quest3 = "3. The Fall of the Betrayer"
Inst62Quest3_Aim = "Seer Kanai wants you to defeat Illidan inside the Black Temple."
Inst62Quest3_Location = "Seer Kanai (Black Temple; "..YELLOW.."[5]"..WHITE..")."
Inst62Quest3_Note = "Illidan Stormrage is at "..YELLOW.."[11]"..WHITE.."."
Inst62Quest3_Prequest = "Redemption of the Ashtongue"
Inst62Quest3_Folgequest = "None"
--
Inst62Quest3name1 = "Blessed Medallion of Karabor"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst62Quest1_HORDE = Inst62Quest1
Inst62Quest1_HORDE_Aim = Inst62Quest1_Aim
Inst62Quest1_HORDE_Location = Inst62Quest1_Location
Inst62Quest1_HORDE_Note = Inst62Quest1_Note
Inst62Quest1_HORDE_Prequest = Inst62Quest1_Prequest
Inst62Quest1_HORDE_Folgequest = Inst62Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst62Quest2_HORDE = Inst62Quest2
Inst62Quest2_HORDE_Aim = Inst62Quest2_Aim
Inst62Quest2_HORDE_Location = Inst62Quest2_Location
Inst62Quest2_HORDE_Note = Inst62Quest2_Note
Inst62Quest2_HORDE_Prequest = Inst62Quest2_Prequest
Inst62Quest2_HORDE_Folgequest = Inst62Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst62Quest3_HORDE = Inst62Quest3
Inst62Quest3_HORDE_Aim = Inst62Quest3_Aim
Inst62Quest3_HORDE_Location = Inst62Quest3_Location
Inst62Quest3_HORDE_Note = Inst62Quest3_Note
Inst62Quest3_HORDE_Prequest = Inst62Quest3_Prequest
Inst62Quest3_HORDE_Folgequest = Inst62Quest3_Folgequest
--
Inst62Quest3name1_HORDE = Inst62Quest3name1



--------------- INST63 - Zul'Aman ---------------

Inst63Caption = "Zul'Aman"
Inst63QAA = "8 Quests"
Inst63QAH = "8 Quests"

--Quest 1 Alliance
Inst63Quest1 = "1. Promises, Promises..."
Inst63Quest1_Aim = "Budd Nedreck in Hatchet Hills wants you to retrieve his map from High Priest Nalorakk's terrace in Zul'Aman."
Inst63Quest1_Location = "Budd Nedreck (Ghostlands - Hatchet Hills; "..YELLOW.."70,67"..WHITE..")"
Inst63Quest1_Note = "Found on the right ramp near High Priest Nalorakk at "..YELLOW.."[1]"..WHITE..". The prequest is optional and starts from Griftah at (Shattrath City - Lower City; "..YELLOW.."65,69"..WHITE..")."
Inst63Quest1_Prequest = "Oooh, Shinies!"
Inst63Quest1_Folgequest = "X Marks... Your Doom!"
--
Inst63Quest1name1 = "Tattered Hexcloth Sack"

--Quest 2 Alliance
Inst63Quest2 = "2. X Marks... Your Doom!"
Inst63Quest2_Aim = "Enter Zul'Aman and visit Halazzi's Chamber, Jan'alai's Platform, and Akil'zon's Platform. Report the details of those areas to Budd, at his camp in the Ghostlands."
Inst63Quest2_Location = "Budd Nedreck (Ghostlands - Hatchet Hills; "..YELLOW.."70,67"..WHITE..")"
Inst63Quest2_Note = "Halazzi's Chamber is at "..YELLOW.."[4]"..WHITE..", Jan'alai's Platform is at "..YELLOW.."[3]"..WHITE.." and Akil'zon's Platform is at "..YELLOW.."[2]"..WHITE..". \n\nReportedly, the bosses do not need to be faught in order to get quest credit. Just get near them without aggroing." 
Inst63Quest2_Prequest = "Promises, Promises..."
Inst63Quest2_Folgequest = "Hex Lord? Hah!"
-- No Rewards for this quest

--Quest 3 Alliance
Inst63Quest3 = "3. Hex Lord? Hah!"
Inst63Quest3_Aim = "Budd Nedreck in Hatchet Hills wants you to kill Hex Lord Malacrass in Zul'Aman."
Inst63Quest3_Location = "Budd Nedreck (Ghostlands - Hatchet Hills; "..YELLOW.."70,67"..WHITE..")"
Inst63Quest3_Note = "Hex Lord Malacrass is at "..YELLOW.."[6]"..WHITE.."."
Inst63Quest3_Prequest = "X Marks... Your Doom!"
Inst63Quest3_Folgequest = "None"
--
Inst63Quest3name1 = "Badge of Justice"

--Quest 4 Alliance
Inst63Quest4 = "4. Tuskin' Raiders"
Inst63Quest4_Aim = "Prigmon needs you to collect 10 Forest Troll Tusks from the trolls in Zul'Aman. Bring them to him at Budd's camp in the Ghostlands."
Inst63Quest4_Location = "Prigmon (Ghostlands - Hatchet Hills; "..YELLOW.."71,68"..WHITE..")"
Inst63Quest4_Note = "The Forest Troll Tusks drop from Amani'shi mobs inside Zul'Aman."
Inst63Quest4_Prequest = "None"
Inst63Quest4_Folgequest = "A Troll Among Trolls"
-- No Rewards for this quest

--Quest 5 Alliance
Inst63Quest5 = "5. A Troll Among Trolls"
Inst63Quest5_Aim = "Prigmon has tasked you with locating and assisting his cousin Zungam, somewhere within Zul'Aman."
Inst63Quest5_Location = "Prigmon (Ghostlands - Hatchet Hills; "..YELLOW.."71,68"..WHITE..")"
Inst63Quest5_Note = "Zungam is in a hut at "..YELLOW.."[5]"..WHITE..". After you release him, he gives you the followup quest."
Inst63Quest5_Prequest = "Tuskin' Raiders"
Inst63Quest5_Folgequest = "Playin' With Dolls"
-- No Rewards for this quest

--Quest 6 Alliance
Inst63Quest6 = "6. Playin' With Dolls"
Inst63Quest6_Aim = "Take the Tattered Voodoo Doll to Griftah in Shattrath City."
Inst63Quest6_Location = "Zungam (Zul'Aman; "..YELLOW.."[5]"..WHITE..")"
Inst63Quest6_Note = "Griftah is at (Shattrath City - Lower City; "..YELLOW.."65,69"..WHITE..")."
Inst63Quest6_Prequest = "A Troll Among Trolls"
Inst63Quest6_Folgequest = "None"
--
Inst63Quest6name1 = "Charmed Amani Jewel"

--Quest 7 Alliance
Inst63Quest7 = "7. Blood of the Warlord"
Inst63Quest7_Aim = "Bring the Blood of Zul'jin to Budd at his camp in the Ghostlands, outside Zul'Aman."
Inst63Quest7_Location = "Blood of Zul'jin (drops from Zul'jin; "..YELLOW.."[7]"..WHITE..")"
Inst63Quest7_Note = "Only one person in the raid can loot this item and the quest can only be done one time."
Inst63Quest7_Prequest = "None"
Inst63Quest7_Folgequest = "Undercover Sister"
-- No Rewards for this quest

--Quest 8 Alliance
Inst63Quest8 = "8. Undercover Sister"
Inst63Quest8_Aim = "Report to Donna Brascoe to collect a reward for your heroism in Zul'Aman. Donna is currently stationed in the Ghostlands, just outside Zul'aman."
Inst63Quest8_Location = "Donna Brascoe (Ghostlands - Hatchet Hills; "..YELLOW.."70,68"..WHITE..")"
Inst63Quest8_Note = ""
Inst63Quest8_Prequest = "Blood of the Warlord"
Inst63Quest8_Folgequest = "None"
--
Inst63Quest8name1 = "Badge of Justice"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst63Quest1_HORDE = Inst63Quest1
Inst63Quest1_HORDE_Aim = Inst63Quest1_Aim
Inst63Quest1_HORDE_Location = Inst63Quest1_Location
Inst63Quest1_HORDE_Note = Inst63Quest1_Note
Inst63Quest1_HORDE_Prequest = Inst63Quest1_Prequest
Inst63Quest1_HORDE_Folgequest = Inst63Quest1_Folgequest
--
Inst63Quest1name1_HORDE = Inst63Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst63Quest2_HORDE = Inst63Quest2
Inst63Quest2_HORDE_Aim = Inst63Quest2_Aim
Inst63Quest2_HORDE_Location = Inst63Quest2_Location
Inst63Quest2_HORDE_Note = Inst63Quest2_Note
Inst63Quest2_HORDE_Prequest = Inst63Quest2_Prequest
Inst63Quest2_HORDE_Folgequest = Inst63Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst63Quest3_HORDE = Inst63Quest3
Inst63Quest3_HORDE_Aim = Inst63Quest3_Aim
Inst63Quest3_HORDE_Location = Inst63Quest3_Location
Inst63Quest3_HORDE_Note = Inst63Quest3_Note
Inst63Quest3_HORDE_Prequest = Inst63Quest3_Prequest
Inst63Quest3_HORDE_Folgequest = Inst63Quest3_Folgequest
--
Inst63Quest3name1_HORDE = Inst63Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst63Quest4_HORDE = Inst63Quest4
Inst63Quest4_HORDE_Aim = Inst63Quest4_Aim
Inst63Quest4_HORDE_Location = Inst63Quest4_Location
Inst63Quest4_HORDE_Note = Inst63Quest4_Note
Inst63Quest4_HORDE_Prequest = Inst63Quest4_Prequest
Inst63Quest4_HORDE_Folgequest = Inst63Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst63Quest5_HORDE = Inst63Quest5
Inst63Quest5_HORDE_Aim = Inst63Quest5_Aim
Inst63Quest5_HORDE_Location = Inst63Quest5_Location
Inst63Quest5_HORDE_Note = Inst63Quest5_Note
Inst63Quest5_HORDE_Prequest = Inst63Quest5_Prequest
Inst63Quest5_HORDE_Folgequest = Inst63Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst63Quest6_HORDE = Inst63Quest6
Inst63Quest6_HORDE_Aim = Inst63Quest6_Aim
Inst63Quest6_HORDE_Location = Inst63Quest6_Location
Inst63Quest6_HORDE_Note = Inst63Quest6_Note
Inst63Quest6_HORDE_Prequest = Inst63Quest6_Prequest
Inst63Quest6_HORDE_Folgequest = Inst63Quest6_Folgequest
--
Inst63Quest6name1_HORDE = Inst63Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst63Quest7_HORDE = Inst63Quest7
Inst63Quest7_HORDE_Aim = Inst63Quest7_Aim
Inst63Quest7_HORDE_Location = Inst63Quest7_Location
Inst63Quest7_HORDE_Note = Inst63Quest7_Note
Inst63Quest7_HORDE_Prequest = Inst63Quest7_Prequest
Inst63Quest7_HORDE_Folgequest = Inst63Quest7_Folgequest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst63Quest8_HORDE = Inst63Quest8
Inst63Quest8_HORDE_Aim = Inst63Quest8_Aim
Inst63Quest8_HORDE_Location = Inst63Quest8_Location
Inst63Quest8_HORDE_Note = Inst63Quest8_Note
Inst63Quest8_HORDE_Prequest = Inst63Quest8_Prequest
Inst63Quest8_HORDE_Folgequest = Inst63Quest8_Folgequest
--
Inst63Quest8name1_HORDE = Inst63Quest8name1



--------------- INST67 - Magisters' Terrace ---------------

Inst67Caption = "Magisters' Terrace"
Inst67QAA = "5 Quests"
Inst67QAH = "5 Quests"

--Quest 1 Alliance
Inst67Quest1 = "1. Wanted: Sisters of Torment"
Inst67Quest1_Aim = "Nether-Stalker Mah'duun wants you to slay 4 Sisters of Torment. Return to him in Shattrath's Lower City once you have done so in order to collect the bounty."
Inst67Quest1_Location = "Nether-Stalker Mah'duun (Shattrath City - Lower City; "..YELLOW.."75.2, 37.6"..WHITE..")"
Inst67Quest1_Note = "One of many Daily Quests that can be available each day from this NPC.  It can be completed on any difficulty."
Inst67Quest1_Prequest = "None"
Inst67Quest1_Folgequest = "None"
--
Inst67Quest1name1 = "Ethereum Prison Key"

--Quest 2 Alliance
Inst67Quest2 = "2. Wanted: The Signet Ring of Prince Kael'thas"
Inst67Quest2_Aim = "Wind Trader Zhareem has asked you to obtain The Signet Ring of Prince Kael'thas. Deliver it to him in Shattrath's Lower City to collect the reward."
Inst67Quest2_Location = "Wind Trader Zhareem (Shattrath City - Lower City; "..YELLOW.."75.0, 36.8"..WHITE..")"
Inst67Quest2_Note = "One of many Daily Quests that can be available each day from this NPC.  Requires Heroic Difficulty.\n\nPrince Kael'thas Sunstrider is at "..YELLOW.."[6]"..WHITE.."."
Inst67Quest2_Prequest = "None"
Inst67Quest2_Folgequest = "None"
--
Inst67Quest2name1 = "Badge of Justice"

--Quest 3 Alliance
Inst67Quest3 = "3. Magisters' Terrace"
Inst67Quest3_Aim = "Exarch Larethor at the Shattered Sun Staging Area wants you to search Magisters' Terrace and find Tyrith, a blood elf spy."
Inst67Quest3_Location = "Exarch Larethor (Isle of Quel'Danas - Shattered Sun Staging Area; "..YELLOW.."47,31"..WHITE..")"
Inst67Quest3_Note = "Tyrith is inside the instance at "..YELLOW.."[2]"..WHITE..". This questline unlocks heroic mode.\n\nThe prequest is available from either Adyen the Lightwarden (Shattrath City - Aldor Rise; "..YELLOW.."35,36"..WHITE..") or Dathris Sunstriker (Shattrath City - Scryers Tier; "..YELLOW.."55,80"..WHITE..")."
Inst67Quest3_Prequest = "Crisis at the Sunwell or Duty Calls"
Inst67Quest3_Folgequest = "The Scryer's Scryer"
-- No Rewards for this quest

--Quest 4 Alliance
Inst67Quest4 = "4. The Scryer's Scryer"
Inst67Quest4_Aim = "Tyrith wants you to use the orb on the balcony in Magisters' Terrace."
Inst67Quest4_Location = "Tyrith (Magisters' Terrace; "..YELLOW.."[2]"..WHITE..")"
Inst67Quest4_Note = "The Scrying Orb is at "..YELLOW.."[4]"..WHITE..". After the 'movie' clip, Kalecgos will appear to start the next quest."
Inst67Quest4_Prequest = "Magisters' Terrace"
Inst67Quest4_Folgequest = "Hard to Kill"
-- No Rewards for this quest

--Quest 5 Alliance
Inst67Quest5 = "5. Hard to Kill"
Inst67Quest5_Aim = "Kalecgos has asked you to defeat Kael'thas in Magisters' Terrace. You are to take Kael's head and report back to Larethor at the Shattered Sun Staging Area."
Inst67Quest5_Location = "Kalecgos (Magisters' Terrace; "..YELLOW.."[4]"..WHITE..")"
Inst67Quest5_Note = "Prince Kael'thas Sunstrider is at "..YELLOW.."[6]"..WHITE..". Completing this quest also enables you to do Magisters' Terrace on Heroic mode.\n\nLarethor is at (Isle of Quel'Danas - Shattered Sun Staging Area; "..YELLOW.."47,31"..WHITE..")."
Inst67Quest5_Prequest = "The Scryer's Scryer"
Inst67Quest5_Folgequest = "None"
--
Inst67Quest5name1 = "Bright Crimson Spinel"
Inst67Quest5name2 = "Runed Crimson Spinel"
Inst67Quest5name3 = "Teardrop Crimson Spinel"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst67Quest1_HORDE = Inst67Quest1
Inst67Quest1_HORDE_Aim = Inst67Quest1_Aim
Inst67Quest1_HORDE_Location = Inst67Quest1_Location
Inst67Quest1_HORDE_Note = Inst67Quest1_Note
Inst67Quest1_HORDE_Prequest = Inst67Quest1_Prequest
Inst67Quest1_HORDE_Folgequest = Inst67Quest1_Folgequest
--
Inst67Quest1name1_HORDE = Inst67Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst67Quest2_HORDE = Inst67Quest2
Inst67Quest2_HORDE_Aim = Inst67Quest2_Aim
Inst67Quest2_HORDE_Location = Inst67Quest2_Location
Inst67Quest2_HORDE_Note = Inst67Quest2_Note
Inst67Quest2_HORDE_Prequest = Inst67Quest2_Prequest
Inst67Quest2_HORDE_Folgequest = Inst67Quest2_Folgequest
--
Inst67Quest2name1_HORDE = Inst67Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst67Quest3_HORDE = Inst67Quest3
Inst67Quest3_HORDE_Aim = Inst67Quest3_Aim
Inst67Quest3_HORDE_Location = Inst67Quest3_Location
Inst67Quest3_HORDE_Note = Inst67Quest3_Note
Inst67Quest3_HORDE_Prequest = Inst67Quest3_Prequest
Inst67Quest3_HORDE_Folgequest = Inst67Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst67Quest4_HORDE = Inst67Quest4
Inst67Quest4_HORDE_Aim = Inst67Quest4_Aim
Inst67Quest4_HORDE_Location = Inst67Quest4_Location
Inst67Quest4_HORDE_Note = Inst67Quest4_Note
Inst67Quest4_HORDE_Prequest = Inst67Quest4_Prequest
Inst67Quest4_HORDE_Folgequest = Inst67Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst67Quest5_HORDE = Inst67Quest5
Inst67Quest5_HORDE_Aim = Inst67Quest5_Aim
Inst67Quest5_HORDE_Location = Inst67Quest5_Location
Inst67Quest5_HORDE_Note = Inst67Quest5_Note
Inst67Quest5_HORDE_Prequest = Inst67Quest5_Prequest
Inst67Quest5_HORDE_Folgequest = Inst67Quest5_Folgequest
--
Inst67Quest5name1_HORDE = Inst67Quest5name1
Inst67Quest5name2_HORDE = Inst67Quest5name2
Inst67Quest5name3_HORDE = Inst67Quest5name3



--------------- INST68 - Sunwell Plateau ---------------

Inst68Caption = "Sunwell Plateau"
Inst68QAA = "No Quests"
Inst68QAH = "No Quests"



--------------- INST60 - Eye of the Storm ---------------

Inst60Caption = "Eye of the Storm"
Inst60QAA = "1 Quest"
Inst60QAH = "1 Quest"

--Quest 1 Alliance
Inst60Quest1 = "1. Call to Arms: Eye of the Storm"
Inst60Quest1_Aim = "Win an Eye of the Storm battleground match and return to an Alliance Brigadier General at any Alliance capital city or Shattrath."
Inst60Quest1_Location = "Alliance Brigadier General:\n   Shattrath: Lower City - "..YELLOW.."66.6, 34.6"..WHITE.."\n   Stormwind: Stormwind Keep - "..YELLOW.."79.4, 18.0"..WHITE.."\n   Ironforge: Military Ward - "..YELLOW.."69.8, 90.0"..WHITE.."\n   Darnassus: Warrior's Terrace - "..YELLOW.."57.8, 34.6"..WHITE.."\n   Exodar: The Vault of Lights - "..YELLOW.."24.6, 55.4"
Inst60Quest1_Note = "This quest can be done once a day after reaching level 61. It yields varying amounts of experience and gold based on your level."
Inst60Quest1_Prequest = "None"
Inst60Quest1_Folgequest = "None"
-- No Rewards for this quest

--Quest 1 Horde
Inst60Quest1_HORDE = "1. Call to Arms: Eye of the Storm"
Inst60Quest1_HORDE_Aim = "Win an Eye of the Storm battleground match and return to a Horde Warbringer at any Horde capital city or Shattrath."
Inst60Quest1_HORDE_Location = "Horde Warbringer:\n   Shattrath: Lower City - "..YELLOW.."67.0, 56.7"..WHITE.."\n   Orgrimmar: Valley of Honor - "..YELLOW.."79.8, 30.3"..WHITE.."\n   Thunder Bluff: The Hunter Rise - "..YELLOW.."55.8, 76.6"..WHITE.."\n   Undercity: The Royal Quarter - "..YELLOW.."60.7, 87.8"..WHITE.."\n   Silvermoon: Farstriders Square - "..YELLOW.."97.0, 38.3"
Inst60Quest1_HORDE_Note = "This quest can be done once a day after reaching level 61. It yields varying amounts of experience and gold based on your level."
Inst60Quest1_HORDE_Prequest = "None"
Inst60Quest1_HORDE_Folgequest = "None"
-- No Rewards for this quest





--------------- INST65 - Skettis ---------------

Inst65Caption = "Skettis"
Inst65QAA = "13 Quests"
Inst65QAH = "13 Quests"

--Quest 1 Alliance
Inst65Quest1 = "1. To Skettis!"
Inst65Quest1_Aim = "Take the Explosives Package to Sky Sergeant Doryn at Blackwind Landing outside Skettis."
Inst65Quest1_Location = "Yuula (Shattrath City; "..YELLOW.."65,42"..WHITE..")"
Inst65Quest1_Note = "The prequest is also obtained from the same NPC.  Blackwind Landing is at "..YELLOW.."[1]"..WHITE.."."
Inst65Quest1_Prequest = "Threat from Above"
Inst65Quest1_Folgequest = "Fires Over Skettis"
-- No Rewards for this quest

--Quest 2 Alliance
Inst65Quest2 = "2. Fires Over Skettis"
Inst65Quest2_Aim = "Seek out Monstrous Kaliri Eggs on the tops of Skettis dwellings and use the Skyguard Blasting Charges on them. Return to Sky Sergeant Doryn."
Inst65Quest2_Location = "Sky Sergeant Doryn (Terrokar Forest - Blackwing Landing; "..YELLOW.."65,66"..WHITE..")"
Inst65Quest2_Note = "Daily Quest.  The eggs can be bombed while on your flying mount from the air.  Watch out for the Monstrous Kaliri birds flying around as they can dismount you if you aggro.  The quest can be done as a group."
Inst65Quest2_Prequest = "To Skettis!"
Inst65Quest2_Folgequest = "None"
-- No Rewards for this quest

--Quest 3 Alliance
Inst65Quest3 = "3. Escape from Skettis"
Inst65Quest3_Aim = "Escort the Skyguard Prisoner to safety and report to Sky Sergeant Doryn."
Inst65Quest3_Location = "Skyguard Prisoner (Terrokar Forest - Skettis; "..YELLOW.."[4]"..WHITE..")"
Inst65Quest3_Note = "Daily Quest.  It will become available after completing 'To Skettis!'.\nThe Skyguard Prisoner randomly spawns at one of the three locations marked as "..YELLOW.."[4]"..WHITE..".  The quest can be done as a group."
Inst65Quest3_Prequest = "None"
Inst65Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst65Quest4 = "4. Hungry Nether Rays"
Inst65Quest4_Aim = "Use the Nether Ray Cage in the woods south of Blackwind Landing and slay Blackwind Warp Chasers near the Hungry Nether Ray. Return to Skyguard Handler Deesak when you've completed your task."
Inst65Quest4_Location = "Skyguard Handler Deesak (Terrokar Forest - Blackwing Landing; "..YELLOW.."63,66"..WHITE..")"
Inst65Quest4_Note = "The Blackwing Warp Chasers (make sure you kill Chasers, not Stalkers) can be found along the southern edge of Skettis. The Hungry Nether Ray must be close to the Chaser when it is killed. Don't move away from the corpse until you get quest credit, it usually takes a few seconds."
Inst65Quest4_Prequest = "None"
Inst65Quest4_Folgequest = "None"
--
Inst65Quest4name1 = "Elixir of Major Agility"
Inst65Quest4name2 = "Adept's Elixir"

--Quest 5 Alliance
Inst65Quest5 = "5. World of Shadows"
Inst65Quest5_Aim = "Severin wants you to venture into Skettis and retrieve 6 Shadow Dusts from the arakkoa that dwell there."
Inst65Quest5_Location = "Severin (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest5_Note = "Repeatable quest.  Any of the Arakkoa can drop the Shadow Dust."
Inst65Quest5_Prequest = "None"
Inst65Quest5_Folgequest = "None"
--
Inst65Quest5name1 = "Elixir of Shadows"

--Quest 6 Alliance
Inst65Quest6 = "6. Secrets of the Talonpriests"
Inst65Quest6_Aim = "Obtain an Elixir of Shadows from Severin and use it to find and slay Talonpriest Ishaal, Talonpriest Skizzik and Talonpriest Zellek in Skettis. Return to Commander Adaris after completing this task."
Inst65Quest6_Location = "Sky Commander Adaris (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest6_Note = "You must complete World of Shadows to obtain the Elixir of Shadows before you can do this quest.\n\nTalonpriest Ishaal is at "..YELLOW.."[5]"..WHITE..", Talonpriest Skizzik is at "..YELLOW.."[6]"..WHITE.." and Talonpriest Zellek is at "..YELLOW.."[7]"..WHITE.."."
Inst65Quest6_Prequest = "World of Shadows"
Inst65Quest6_Folgequest = "None"
-- No Rewards for this quest

--Quest 7 Alliance
Inst65Quest7 = "7. Ishaal's Almanac"
Inst65Quest7_Aim = "Bring Ishaal's Almanac to Sky Commander Adaris north of Skettis."
Inst65Quest7_Location = "Ishaal's Almanac (drops from Talonpriest Ishaal; "..YELLOW.."[5]"..WHITE..")"
Inst65Quest7_Note = "Sky Commander Adaris is at Terrokar Forest - Blackwing Landing ("..YELLOW.."64,66"..WHITE..")."
Inst65Quest7_Prequest = "None"
Inst65Quest7_Folgequest = "An Ally in Lower City"
-- No Rewards for this quest

--Quest 8 Alliance
Inst65Quest8 = "8. An Ally in Lower City"
Inst65Quest8_Aim = "Bring Ishaal's Almanac to Rilak the Redeemed in Lower City inside Shattrath."
Inst65Quest8_Location = "Sky Commander Adaris (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest8_Note = "Rilak the Redeemed is at Shattrath City - Lower City ("..YELLOW.."52,20"..WHITE..")."
Inst65Quest8_Prequest = "Ishaal's Almanac"
Inst65Quest8_Folgequest = "Countdown to Doom"
-- No Rewards for this quest

--Quest 9 Alliance
Inst65Quest9 = "9. Countdown to Doom"
Inst65Quest9_Aim = "Return to Sky Commander Adaris with the news about Terokk's return."
Inst65Quest9_Location = "Rilak the Redeemed (Shattrath City - Lower City; "..YELLOW.."52,20"..WHITE..")"
Inst65Quest9_Note = "Sky Commander Adaris is at Terrokar Forest - Blackwing Landing ("..YELLOW.."64,66"..WHITE.."). Hazzik, who is nearby, will give you the followup quest."
Inst65Quest9_Prequest = "An Ally in Lower City"
Inst65Quest9_Folgequest = "Hazzik's Bargain"
-- No Rewards for this quest

--Quest 10 Alliance
Inst65Quest10 = "10. Hazzik's Bargain"
Inst65Quest10_Aim = "Obtain Hazzik's Package at his dwelling in eastern Skettis and return to him with it."
Inst65Quest10_Location = "Hazzik (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest10_Note = "Hazzik's Package is in a hut at "..YELLOW.."[8]"..WHITE.."."
Inst65Quest10_Prequest = "Countdown to Doom"
Inst65Quest10_Folgequest = "A Shabby Disguise"
-- No Rewards for this quest

--Quest 11 Alliance
Inst65Quest11 = "11. A Shabby Disguise"
Inst65Quest11_Aim = "Use the Shabby Arakkoa Disguise to obtain the Adversarial Bloodlines from Sahaak and return to Hazzik."
Inst65Quest11_Location = "Hazzik (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest11_Note = "Sahaak is at "..YELLOW.."[3]"..WHITE..". If any Arakkoa other than Sahaak see you with the disguise, they will attack you."
Inst65Quest11_Prequest = "Hazzik's Bargain"
Inst65Quest11_Folgequest = "Adversarial Blood"
-- No Rewards for this quest

--Quest 12 Alliance
Inst65Quest12 = "12. Adversarial Blood"
Inst65Quest12_Aim = "Find the Skull Piles in the middle of the summoning circles of Skettis. Summon and defeat each of the descendants by using 10 Time-Lost Scrolls at the Skull Pile. Return to Hazzik at Blackwind Landing with a token from each."
Inst65Quest12_Location = "Hazzik (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest12_Note = "The skull piles are at "..GREEN.."[1']"..WHITE..". Only one quest item per group drops for each kill. So each group member who needs the quest will need 10 Scrolls to summon the descendants for their item. The quest item is green quality, so it will have to be rolled for if group loot is on. This quest is repeatable."
Inst65Quest12_Prequest = "A Shabby Disguise"
Inst65Quest12_Folgequest = "None"
--
Inst65Quest12name1 = "Time-Lost Offering"

--Quest 13 Alliance
Inst65Quest13 = "13. Terokk's Downfall"
Inst65Quest13_Aim = "Take the Time-Lost Offering prepared by Hazzik to the Skull Pile at the center of Skettis and summon and defeat Terokk. Return to Sky Commander Adaris when you've completed this task."
Inst65Quest13_Location = "Sky Commander Adaris (Terrokar Forest - Blackwing Landing; "..YELLOW.."64,66"..WHITE..")"
Inst65Quest13_Note = "Terokk is summoned at "..YELLOW.."[2]"..WHITE..". Tip from fissi0nx on Wowhead:\nAt 20% Terokk becomes immune to all attacks, and you'll see a blue flare shortly afterward, where a bomb will drop down. Drag Terokk into the flame to break his shield. He'll become enraged but you'll be able to kill him."
Inst65Quest13_Prequest = "Adversarial Blood"
Inst65Quest13_Folgequest = "None"
--
Inst65Quest13name1 = "Jeweled Rod"
Inst65Quest13name2 = "Scout's Throwing Knives"
Inst65Quest13name3 = "Severin's Cane"
Inst65Quest13name4 = "Windcharger's Lance"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst65Quest1_HORDE = Inst65Quest1
Inst65Quest1_HORDE_Aim = Inst65Quest1_Aim
Inst65Quest1_HORDE_Location = Inst65Quest1_Location
Inst65Quest1_HORDE_Note = Inst65Quest1_Note
Inst65Quest1_HORDE_Prequest = Inst65Quest1_Prequest
Inst65Quest1_HORDE_Folgequest = Inst65Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst65Quest2_HORDE = Inst65Quest2
Inst65Quest2_HORDE_Aim = Inst65Quest2_Aim
Inst65Quest2_HORDE_Location = Inst65Quest2_Location
Inst65Quest2_HORDE_Note = Inst65Quest2_Note
Inst65Quest2_HORDE_Prequest = Inst65Quest2_Prequest
Inst65Quest2_HORDE_Folgequest = Inst65Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst65Quest3_HORDE = Inst65Quest3
Inst65Quest3_HORDE_Aim = Inst65Quest3_Aim
Inst65Quest3_HORDE_Location = Inst65Quest3_Location
Inst65Quest3_HORDE_Note = Inst65Quest3_Note
Inst65Quest3_HORDE_Prequest = Inst65Quest3_Prequest
Inst65Quest3_HORDE_Folgequest = Inst65Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst65Quest4_HORDE = Inst65Quest4
Inst65Quest4_HORDE_Aim = Inst65Quest4_Aim
Inst65Quest4_HORDE_Location = Inst65Quest4_Location
Inst65Quest4_HORDE_Note = Inst65Quest4_Note
Inst65Quest4_HORDE_Prequest = Inst65Quest4_Prequest
Inst65Quest4_HORDE_Folgequest = Inst65Quest4_Folgequest
--
Inst65Quest4name1_HORDE = Inst65Quest4name1
Inst65Quest4name2_HORDE = Inst65Quest4name2

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst65Quest5_HORDE = Inst65Quest5
Inst65Quest5_HORDE_Aim = Inst65Quest5_Aim
Inst65Quest5_HORDE_Location = Inst65Quest5_Location
Inst65Quest5_HORDE_Note = Inst65Quest5_Note
Inst65Quest5_HORDE_Prequest = Inst65Quest5_Prequest
Inst65Quest5_HORDE_Folgequest = Inst65Quest5_Folgequest
--
Inst65Quest5name1_HORDE = Inst65Quest5name1
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst65Quest6_HORDE = Inst65Quest6
Inst65Quest6_HORDE_Aim = Inst65Quest6_Aim
Inst65Quest6_HORDE_Location = Inst65Quest6_Location
Inst65Quest6_HORDE_Note = Inst65Quest6_Note
Inst65Quest6_HORDE_Prequest = Inst65Quest6_Prequest
Inst65Quest6_HORDE_Folgequest = Inst65Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst65Quest7_HORDE = Inst65Quest7
Inst65Quest7_HORDE_Aim = Inst65Quest7_Aim
Inst65Quest7_HORDE_Location = Inst65Quest7_Location
Inst65Quest7_HORDE_Note = Inst65Quest7_Note
Inst65Quest7_HORDE_Prequest = Inst65Quest7_Prequest
Inst65Quest7_HORDE_Folgequest = Inst65Quest7_Folgequest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst65Quest8_HORDE = Inst65Quest8
Inst65Quest8_HORDE_Aim = Inst65Quest8_Aim
Inst65Quest8_HORDE_Location = Inst65Quest8_Location
Inst65Quest8_HORDE_Note = Inst65Quest8_Note
Inst65Quest8_HORDE_Prequest = Inst65Quest8_Prequest
Inst65Quest8_HORDE_Folgequest = Inst65Quest8_Folgequest
-- No Rewards for this quest

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst65Quest9_HORDE = Inst65Quest9
Inst65Quest9_HORDE_Aim = Inst65Quest9_Aim
Inst65Quest9_HORDE_Location = Inst65Quest9_Location
Inst65Quest9_HORDE_Note = Inst65Quest9_Note
Inst65Quest9_HORDE_Prequest = Inst65Quest9_Prequest
Inst65Quest9_HORDE_Folgequest = Inst65Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst65Quest10_HORDE = Inst65Quest10
Inst65Quest10_HORDE_Aim = Inst65Quest10_Aim
Inst65Quest10_HORDE_Location = Inst65Quest10_Location
Inst65Quest10_HORDE_Note = Inst65Quest10_Note
Inst65Quest10_HORDE_Prequest = Inst65Quest10_Prequest
Inst65Quest10_HORDE_Folgequest = Inst65Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst65Quest11_HORDE = Inst65Quest11
Inst65Quest11_HORDE_Aim = Inst65Quest11_Aim
Inst65Quest11_HORDE_Location = Inst65Quest11_Location
Inst65Quest11_HORDE_Note = Inst65Quest11_Note
Inst65Quest11_HORDE_Prequest = Inst65Quest11_Prequest
Inst65Quest11_HORDE_Folgequest = Inst65Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst65Quest12_HORDE = Inst65Quest12
Inst65Quest12_HORDE_Aim = Inst65Quest12_Aim
Inst65Quest12_HORDE_Location = Inst65Quest12_Location
Inst65Quest12_HORDE_Note = Inst65Quest12_Note
Inst65Quest12_HORDE_Prequest = Inst65Quest12_Prequest
Inst65Quest12_HORDE_Folgequest = Inst65Quest12_Folgequest
--
Inst65Quest12name1_HORDE = Inst65Quest12name1

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst65Quest13_HORDE = Inst65Quest13
Inst65Quest13_HORDE_Aim = Inst65Quest13_Aim
Inst65Quest13_HORDE_Location = Inst65Quest13_Location
Inst65Quest13_HORDE_Note = Inst65Quest13_Note
Inst65Quest13_HORDE_Prequest = Inst65Quest13_Prequest
Inst65Quest13_HORDE_Folgequest = Inst65Quest13_Folgequest
--
Inst65Quest13name1_HORDE = Inst65Quest13name1
Inst65Quest13name2_HORDE = Inst65Quest13name2
Inst65Quest13name3_HORDE = Inst65Quest13name3
Inst65Quest13name4_HORDE = Inst65Quest13name4





-- End of File
