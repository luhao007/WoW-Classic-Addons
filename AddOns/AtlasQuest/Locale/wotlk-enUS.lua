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


------------  WOTLK CLASSIC  ------------

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





--------------- INST69 - Caverns of Time: Stratholme Past ---------------

Inst69Story = "Prior to his unthinkable merger with the Lich King, Arthas waged war against the Scourge, bent on eradicating the plague of undeath that had spread throughout Lordaeron. After Arthas watched villages succumb to darkness and saw his fallen subjects transformed into hideous undead creatures, fear and hate engulfed his mind. Upon discovering signs of the plague within Stratholme, he knew it was only a matter of time before the residents of the city were reborn as Scourge agents. For Arthas, there was only one course of action: purge the city. Yet within the Caverns of Time, deceptive magic permeates Stratholme. The infinite dragons and their agents have targeted Arthas and his quest to cull the city, seeking to alter history. Fearing the temporal disruption might jeopardize Azeroth's very existence, the bronze dragonflight has called upon mortals to assist Arthas and ensure that the purge is carried out successfully. Regardless of how vile the event might seem, the keepers of time maintain that what was, must always be."
Inst69Caption = "Culling of Stratholme"
Inst69QAA = "4 Quests"
Inst69QAH = "4 Quests"

--Quest 1 Alliance
Inst69Quest1 = "1. Dispelling Illusions"
Inst69Quest1_Aim = "Chromie wants you to use the Arcane Disruptor on the suspicious crates in Stratholme Past, then speak to her near the entrance to Stratholme."
Inst69Quest1_Location = "Chromie (Stratholme Past; "..GREEN.."[1']"..WHITE..")"
Inst69Quest1_Note = "The crates are found near the houses along the road on the way to Stratholme. After completion, you can turn the quest in to another Chromie at the bridge before you enter the city."
Inst69Quest1_Prequest = "None"
Inst69Quest1_Folgequest = "A Royal Escort"
-- No Rewards for this quest

--Quest 2 Alliance
Inst69Quest2 = "2. A Royal Escort"
Inst69Quest2_Aim = "Chromie has asked you to accompany Arthas in the Culling of Stratholme. You are to speak with her again after Mal'Ganis is defeated."
Inst69Quest2_Location = "Chromie (Stratholme Past; "..GREEN.."[1']"..WHITE..")"
Inst69Quest2_Note = "Mal'Ganis is at "..YELLOW.."[5]"..WHITE..". Chromie will appear there after the event is over."
Inst69Quest2_Prequest = "Dispelling Illusions"
Inst69Quest2_Folgequest = "None"
--
Inst69Quest2name1 = "Gloves of the Time Guardian"
Inst69Quest2name2 = "Handwraps of Preserved History"
Inst69Quest2name3 = "Grips of Chronological Events"
Inst69Quest2name4 = "Gauntlets of The Culling"

--Quest 3 Alliance
Inst69Quest3 = "3. Timear Foresees Infinite Agents in your Future!"
Inst69Quest3_Aim = "Archmage Timear in Dalaran has foreseen that you must slay 4 Infinite Agents."
Inst69Quest3_Location = "Archmage Timear (Dalaran - The Violet Hold; "..YELLOW.."64.2, 54.7"..WHITE..")"
Inst69Quest3_Note = "This is a daily quest. The Infinite Agents are found in the Town Hall Building between the second and third bosses."
Inst69Quest3_Prequest = "None"
Inst69Quest3_Folgequest = "None"
--
Inst69Quest3name1 = "Kirin Tor Commendation Badge"
Inst69Quest3name2 = "Argent Crusade Commendation Badge"
Inst69Quest3name3 = "Ebon Blade Commendation Badge"
Inst69Quest3name4 = "Wyrmrest Commendation Badge"
Inst69Quest3name5 = "Sons of Hodir Commendation Badge"
Inst69Quest3name6 = "Emblem of Conquest"

--Quest 4 Alliance
Inst69Quest4 = "4. Proof of Demise: Mal'Ganis"
Inst69Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Artifact from the Nathrezim Homeworld."
Inst69Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst69Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nMal'Ganis is at "..YELLOW.."[5]"..WHITE.."."
Inst69Quest4_Prequest = "None"
Inst69Quest4_Folgequest = "None"
--
Inst69Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst69Quest1_HORDE = Inst69Quest1
Inst69Quest1_HORDE_Aim = Inst69Quest1_Aim
Inst69Quest1_HORDE_Location = Inst69Quest1_Location
Inst69Quest1_HORDE_Note = Inst69Quest1_Note
Inst69Quest1_HORDE_Prequest = Inst69Quest1_Prequest
Inst69Quest1_HORDE_Folgequest = Inst69Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst69Quest2_HORDE = Inst69Quest2
Inst69Quest2_HORDE_Aim = Inst69Quest2_Aim
Inst69Quest2_HORDE_Location = Inst69Quest2_Location
Inst69Quest2_HORDE_Note = Inst69Quest2_Note
Inst69Quest2_HORDE_Prequest = Inst69Quest2_Prequest
Inst69Quest2_HORDE_Folgequest = Inst69Quest2_Folgequest
--
Inst69Quest2name1_HORDE = Inst69Quest2name1
Inst69Quest2name2_HORDE = Inst69Quest2name2
Inst69Quest2name3_HORDE = Inst69Quest2name3
Inst69Quest2name4_HORDE = Inst69Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst69Quest3_HORDE = Inst69Quest3
Inst69Quest3_HORDE_Aim = Inst69Quest3_Aim
Inst69Quest3_HORDE_Location = Inst69Quest3_Location
Inst69Quest3_HORDE_Note = Inst69Quest3_Note
Inst69Quest3_HORDE_Prequest = Inst69Quest3_Prequest
Inst69Quest3_HORDE_Folgequest = Inst69Quest3_Folgequest
--
Inst69Quest3name1_HORDE = Inst69Quest3name1
Inst69Quest3name2_HORDE = Inst69Quest3name2
Inst69Quest3name3_HORDE = Inst69Quest3name3
Inst69Quest3name4_HORDE = Inst69Quest3name4
Inst69Quest3name5_HORDE = Inst69Quest3name5
Inst69Quest3name6_HORDE = Inst69Quest3name6

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst69Quest4_HORDE = Inst69Quest4
Inst69Quest4_HORDE_Aim = Inst69Quest4_Aim
Inst69Quest4_HORDE_Location = Inst69Quest4_Location
Inst69Quest4_HORDE_Note = Inst69Quest4_Note
Inst69Quest4_HORDE_Prequest = Inst69Quest4_Prequest
Inst69Quest4_HORDE_Folgequest = Inst69Quest4_Folgequest
--
Inst69Quest4name1_HORDE = Inst69Quest4name1



--------------- INST70 - Utgarde Keep: Utgarde Keep ---------------

Inst70Story = "Among the cliffs of the Daggercap Bay in the Howling Fjord stands Utgarde Keep, an impervious fortress occupied by the savage and enigmatic vrykul. With mysterious, foul magic and proto-dragons at their command, the vrykul of Utgarde Keep pose an imminent threat to both the Alliance and the Horde. Only the bravest would dare to strike against Ymiron's faithful and delve into the heart of the vrykul's primeval home."
Inst70Caption = "Utgarde Keep"
Inst70QAA = "3 Quests"
Inst70QAH = "4 Quests"

--Quest 1 Alliance
Inst70Quest1 = "1. Into Utgarde!"
Inst70Quest1_Aim = "Defender Mordun has tasked you with the execution of Ingvar the Plunderer who resides deep in Utgarde. You are then to bring his head to Vice Admiral Keller."
Inst70Quest1_Location = "Defender Mordun (Howling Fjord - Wyrmskull Village; "..YELLOW.."59.3, 48.8"..WHITE..")"
Inst70Quest1_Note = "Ingvar the Plunderer is at "..YELLOW.."[3]"..WHITE..".\n\nThe prequest is optional. The quest turns in to Vice Admiral Keller at (Howling Fjord - Valgarde; "..YELLOW.."60.4, 61.0"..WHITE..")."
Inst70Quest1_Prequest = "Fresh Legs"
Inst70Quest1_Folgequest = "None"
--
Inst70Quest1name1 = "Executioner's Band"
Inst70Quest1name2 = "Ring of Decimation"
Inst70Quest1name3 = "Signet of Swift Judgment"

--Quest 2 Alliance
Inst70Quest2 = "2. Disarmament"
Inst70Quest2_Aim = "Defender Mordun wants you to enter Utgarde Keep and steal 5 Vrykul Weapons"
Inst70Quest2_Location = "Defender Mordun (Howling Fjord - Wyrmskull Village; "..YELLOW.."59.3, 48.8"..WHITE..")"
Inst70Quest2_Note = "The Vrykul Weapons can be found along walls scattered around the instance. The prequest comes from Scout Valory (Howling Fjord - Wyrmskull Village; "..YELLOW.."56.0, 55.8"..WHITE..") and is optional."
Inst70Quest2_Prequest = "None"
Inst70Quest2_Folgequest = "None"
--
Inst70Quest2name1 = "Amulet of the Tranquil Mind"
Inst70Quest2name2 = "Razor-Blade Pendant"
Inst70Quest2name3 = "Necklace of Fragmented Light"
Inst70Quest2name4 = "Woven Steel Necklace"

--Quest 3 Alliance
Inst70Quest3 = "3. Proof of Demise: Ingvar the Plunderer"
Inst70Quest3_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Axe of the Plunderer."
Inst70Quest3_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst70Quest3_Note = "This daily quest can only be completed on Heroic difficulty.\n\nIngvar the Plunderer is at "..YELLOW.."[3]"..WHITE.."."
Inst70Quest3_Prequest = "None"
Inst70Quest3_Folgequest = "None"
--
Inst70Quest3name1 = "Emblem of Triumph"


--Quest 1 Horde
Inst70Quest1_HORDE = "1. A Score to Settle"
Inst70Quest1_HORDE_Aim = "High Executor Anselm wants you to to go into Utgarde and slay Prince Keleseth."
Inst70Quest1_HORDE_Location = "High Executor Anselm (Howling Fjord - Vengeance Landing; "..YELLOW.."78.5, 31.1"..WHITE..")"
Inst70Quest1_HORDE_Note = "Prince Keleseth is at "..YELLOW.."[1]"..WHITE..".\n\nThe prequest line starts at the same NPC."
Inst70Quest1_HORDE_Prequest = "War is Hell -> Report to Anselm"
Inst70Quest1_HORDE_Folgequest = "None"
--
Inst70Quest1name1_HORDE = "Wraps of the San'layn"
Inst70Quest1name2_HORDE = "Vendetta Bindings"
Inst70Quest1name3_HORDE = "Runecaster's Bracers"
Inst70Quest1name4_HORDE = "Vambraces of the Vengeance Bringer"

--Quest 2 Horde
Inst70Quest2_HORDE = "2. Ingvar Must Die!"
Inst70Quest2_HORDE_Aim = "Dark Ranger Marrah has asked you to kill Ingvar the Plunderer in Utgarde Keep, then bring his head to High Executor Anselm at Vengeance Landing."
Inst70Quest2_HORDE_Location = "Dark Ranger Marrah (Utgarde Keep; "..YELLOW.."[A] Entrance"..WHITE..")"
Inst70Quest2_HORDE_Note = "Dark Ranger Marrah will appear just inside the portal a few seconds after you enter the instance.\n\nIngvar the Plunderer is at "..YELLOW.."[3]"..WHITE..".\n\nThe quest turns in to High Executor Anselm at (Howling Fjord - Vengeance Landing; "..YELLOW.."78.5, 31.1"..WHITE..")."
Inst70Quest2_HORDE_Prequest = "None"
Inst70Quest2_HORDE_Folgequest = "None"
--
Inst70Quest2name1_HORDE = "Executioner's Band"
Inst70Quest2name2_HORDE = "Ring of Decimation"
Inst70Quest2name3_HORDE = "Signet of Swift Judgment"

--Quest 3 Horde
Inst70Quest3_HORDE = "3. Disarmament"
Inst70Quest3_HORDE_Aim = "Dark Ranger Marrah wants you to steal 5 Vrykul Weapons from Utgarde Keep and bring them to High Executor Anselm in Vengeance Landing."
Inst70Quest3_HORDE_Location = "Dark Ranger Marrah (Utgarde Keep; "..YELLOW.."[A] Entrance"..WHITE..")"
Inst70Quest3_HORDE_Note = "Dark Ranger Marrah will appear just inside the portal a few seconds after you enter the instance.\n\nThe Vrykul Weapons can be found along walls scattered around the instance.\n\nThe quest turns in to High Executor Anselm at (Howling Fjord - Vengeance Landing; "..YELLOW.."78.5, 31.1"..WHITE..")."
Inst70Quest3_HORDE_Prequest = "None"
Inst70Quest3_HORDE_Folgequest = "None"
--
Inst70Quest3name1_HORDE = "Necklace of Calm Skies"
Inst70Quest3name2_HORDE = "Hundred Tooth Necklace"
Inst70Quest3name3_HORDE = "Amulet of Constrained Power"
Inst70Quest3name4_HORDE = "Tiled-Stone Pendant"

--Quest 4 Horde  (same as Quest 3 Alliance)
Inst70Quest4_HORDE = Inst70Quest3
Inst70Quest4_HORDE_Aim = Inst70Quest3_Aim
Inst70Quest4_HORDE_Location = Inst70Quest3_Location
Inst70Quest4_HORDE_Note = Inst70Quest3_Note
Inst70Quest4_HORDE_Prequest = Inst70Quest3_Prequest
Inst70Quest4_HORDE_Folgequest = Inst70Quest3_Folgequest
--
Inst70Quest4name1_HORDE = Inst70Quest3name1



--------------- INST71 - Utgarde Keep: Utgarde Pinnacle ---------------

Inst71Story = "Among the cliffs of the Daggercap Bay in the Howling Fjord stands Utgarde Keep, an impervious fortress occupied by the savage and enigmatic vrykul. With mysterious, foul magic and proto-dragons at their command, the vrykul of Utgarde Keep pose an imminent threat to both the Alliance and the Horde. Only the bravest would dare to strike against Ymiron's faithful and delve into the heart of the vrykul's primeval home."
Inst71Caption = "Utgarde Pinnacle"
Inst71QAA = "4 Quests"
Inst71QAH = "4 Quests"

--Quest 1 Alliance
Inst71Quest1 = "1. Junk in My Trunk"
Inst71Quest1_Aim = "Brigg in Utgarde Pinnacle wants you to find 5 Untarnished Silver Bars, 3 Shiny Baubles, 2 Golden Goblets, and a Jade Statue."
Inst71Quest1_Location = "Brigg Smallshanks (Utgarde Pinnacle; "..YELLOW.."[A]"..WHITE..")"
Inst71Quest1_Note = "The items can be found scattered around the instance, usually laying on the ground. The Shiny Baubles are not the same that are used as fishing lures."
Inst71Quest1_Prequest = "None"
Inst71Quest1_Folgequest = "None"
--
Inst71Quest1name1 = "Bauble-Woven Gown"
Inst71Quest1name2 = "Exotic Leather Tunic"
Inst71Quest1name3 = "Silver-Plated Battlechest"
Inst71Quest1name4 = "Gilded Ringmail Hauberk"

--Quest 2 Alliance
Inst71Quest2 = "2. Vengeance Be Mine!"
Inst71Quest2_Aim = "Brigg in Utgarde Pinnacle wants you to kill King Ymiron."
Inst71Quest2_Location = "Brigg Smallshanks (Utgarde Pinnacle; "..YELLOW.."[A]"..WHITE..")"
Inst71Quest2_Note = "King Ymiron is at "..YELLOW.."[4]"..WHITE.."."
Inst71Quest2_Prequest = "None"
Inst71Quest2_Folgequest = "None"
--
Inst71Quest2name1 = "Cowl of the Vindictive Captain"
Inst71Quest2name2 = "Headguard of Retaliation"
Inst71Quest2name3 = "Helmet of Just Retribution"
Inst71Quest2name4 = "Faceguard of Punishment"
Inst71Quest2name5 = "Platehelm of Irate Revenge"

--Quest 3 Alliance
Inst71Quest3 = "3. Timear Foresees Ymirjar Berserkers in your Future!"
Inst71Quest3_Aim = "Archmage Timear in Dalaran wants you to slay 7 Ymirjar Berserkers."
Inst71Quest3_Location = "Archmage Timear (Dalaran - The Violet Hold; "..YELLOW.."64.2, 54.7"..WHITE..")"
Inst71Quest3_Note = "This is a daily quest."
Inst71Quest3_Prequest = "None"
Inst71Quest3_Folgequest = "None"
--
Inst71Quest3name1 = "Kirin Tor Commendation Badge"
Inst71Quest3name2 = "Argent Crusade Commendation Badge"
Inst71Quest3name3 = "Ebon Blade Commendation Badge"
Inst71Quest3name4 = "Wyrmrest Commendation Badge"
Inst71Quest3name5 = "Sons of Hodir Commendation Badge"
Inst71Quest3name6 = "Emblem of Conquest"

--Quest 4 Alliance
Inst71Quest4 = "4. Proof of Demise: King Ymiron"
Inst71Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Locket of the Deceased Queen."
Inst71Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst71Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nKing Ymiron is at "..YELLOW.."[4]"..WHITE.."."
Inst71Quest4_Prequest = "None"
Inst71Quest4_Folgequest = "None"
--
Inst71Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst71Quest1_HORDE = Inst71Quest1
Inst71Quest1_HORDE_Aim = Inst71Quest1_Aim
Inst71Quest1_HORDE_Location = Inst71Quest1_Location
Inst71Quest1_HORDE_Note = Inst71Quest1_Note
Inst71Quest1_HORDE_Prequest = Inst71Quest1_Prequest
Inst71Quest1_HORDE_Folgequest = Inst71Quest1_Folgequest
--
Inst71Quest1name1_HORDE = Inst71Quest1name1
Inst71Quest1name2_HORDE = Inst71Quest1name2
Inst71Quest1name3_HORDE = Inst71Quest1name3
Inst71Quest1name4_HORDE = Inst71Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst71Quest2_HORDE = Inst71Quest2
Inst71Quest2_HORDE_Aim = Inst71Quest2_Aim
Inst71Quest2_HORDE_Location = Inst71Quest2_Location
Inst71Quest2_HORDE_Note = Inst71Quest2_Note
Inst71Quest2_HORDE_Prequest = Inst71Quest2_Prequest
Inst71Quest2_HORDE_Folgequest = Inst71Quest2_Folgequest
--
Inst71Quest2name1_HORDE = Inst71Quest2name1
Inst71Quest2name2_HORDE = Inst71Quest2name2
Inst71Quest2name3_HORDE = Inst71Quest2name3
Inst71Quest2name4_HORDE = Inst71Quest2name4
Inst71Quest2name5_HORDE = Inst71Quest2name5

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst71Quest3_HORDE = Inst71Quest3
Inst71Quest3_HORDE_Aim = Inst71Quest3_Aim
Inst71Quest3_HORDE_Location = Inst71Quest3_Location
Inst71Quest3_HORDE_Note = Inst71Quest3_Note
Inst71Quest3_HORDE_Prequest = Inst71Quest3_Prequest
Inst71Quest3_HORDE_Folgequest = Inst71Quest3_Folgequest
--
Inst71Quest3name1_HORDE = Inst71Quest3name1
Inst71Quest3name2_HORDE = Inst71Quest3name2
Inst71Quest3name3_HORDE = Inst71Quest3name3
Inst71Quest3name4_HORDE = Inst71Quest3name4
Inst71Quest3name5_HORDE = Inst71Quest3name5
Inst71Quest3name6_HORDE = Inst71Quest3name6

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst71Quest4_HORDE = Inst71Quest4
Inst71Quest4_HORDE_Aim = Inst71Quest4_Aim
Inst71Quest4_HORDE_Location = Inst71Quest4_Location
Inst71Quest4_HORDE_Note = Inst71Quest4_Note
Inst71Quest4_HORDE_Prequest = Inst71Quest4_Prequest
Inst71Quest4_HORDE_Folgequest = Inst71Quest4_Folgequest
--
Inst71Quest4name1_HORDE = Inst71Quest4name1



--------------- INST72 - The Nexus: The Nexus ---------------

Inst72Story = "The blue Dragon Aspect, Malygos, has created rifts with his manipulation of raw magical power: tears in the very fabric of the magical dimension. The Kirin Tor, the elite magi of Dalaran, have formed a council with the red dragonflight, who are charged with the preservation of life. To this end, the two groups have begun actively subverting Malygos's devastating campaign. The sides have been chosen; the battle lines have been drawn. The only question that remains now is...Who will win."
Inst72Caption = "The Nexus"
Inst72QAA = "5 Quests"
Inst72QAH = "5 Quests"

--Quest 1 Alliance
Inst72Quest1 = "1. Have They No Shame?"
Inst72Quest1_Aim = "Librarian Serrah wants you to enter the Nexus and recover Berinand's Research."
Inst72Quest1_Location = "Librarian Serrah (Borean Tundra - Transitus Shield; "..YELLOW.."33.4, 34.3"..WHITE..")"
Inst72Quest1_Note = "The Research Book is on the ground in the hall with the frozen NPCs at "..YELLOW.."[4]"..WHITE.."."
Inst72Quest1_Prequest = "None"
Inst72Quest1_Folgequest = "None"
--
Inst72Quest1name1 = "Shoulders of the Northern Lights"
Inst72Quest1name2 = "Cured Mammoth Hide Mantle"
Inst72Quest1name3 = "Tundra Tracker's Shoulderguards"
Inst72Quest1name4 = "Tundra Pauldrons"

--Quest 2 Alliance
Inst72Quest2 = "2. Postponing the Inevitable"
Inst72Quest2_Aim = "Archmage Berinand in the Transitus Shield wants you to use the Interdimensional Refabricator near the rift in the Nexus."
Inst72Quest2_Location = "Archmage Berinand (Borean Tundra - Transitus Shield; "..YELLOW.."32.9, 34.3"..WHITE..")"
Inst72Quest2_Note = "Use the Interdimensional Refabricator on the edge of the platform where Anomalus is, at "..YELLOW.."[2]"..WHITE.."."
Inst72Quest2_Prequest = "Reading the Meters"
Inst72Quest2_Folgequest = "None"
--
Inst72Quest2name1 = "Time-Twisted Wraps"
Inst72Quest2name2 = "Time-Stop Gloves"
Inst72Quest2name3 = "Bindings of Sabotage"
Inst72Quest2name4 = "Gauntlets of the Disturbed Giant"

--Quest 3 Alliance
Inst72Quest3 = "3. Prisoner of War"
Inst72Quest3_Aim = "Raelorasz at the Transitus Shield wants you to enter the Nexus and release Keristrasza."
Inst72Quest3_Location = "Raelorasz (Borean Tundra - Transitus Shield; "..YELLOW.."33.2, 34.4"..WHITE..")"
Inst72Quest3_Note = "Keristrasza is at "..YELLOW.."[5]"..WHITE.."."
Inst72Quest3_Prequest = "Keristrasza -> Springing the Trap"
Inst72Quest3_Folgequest = "None"
--
Inst72Quest3name1 = "Cloak of Azure Lights"
Inst72Quest3name2 = "Mantle of Keristrasza"
Inst72Quest3name3 = "Shroud of Fluid Strikes"

--Quest 4 Alliance
Inst72Quest4 = "4. Quickening"
Inst72Quest4_Aim = "Archmage Berinand in the Transitus Shield wants you to enter the Nexus and collect 5 Arcane Splinters from Crystalline Protectors."
Inst72Quest4_Location = "Archmage Berinand (Borean Tundra - Transitus Shield; "..YELLOW.."32.9, 34.3"..WHITE..")"
Inst72Quest4_Note = "Crystalline Protectors drop the Arcane Splinters. They are found on the way to Ormorok the Tree-Shaper."
Inst72Quest4_Prequest = "Secrets of the Ancients"
Inst72Quest4_Folgequest = "None"
--
Inst72Quest4name1 = "Sandals of Mystical Evolution"
Inst72Quest4name2 = "Treads of Torn Future"
Inst72Quest4name3 = "Spiked Treads of Mutation"
Inst72Quest4name4 = "Invigorating Sabatons"
Inst72Quest4name5 = "Boots of the Unbowed Protector"

--Quest 5 Alliance
Inst72Quest5 = "5. Proof of Demise: Keristrasza"
Inst72Quest5_Aim = "Archmage Lan'dalock in Dalaran wants you to return with Keristrasza's Broken Heart."
Inst72Quest5_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst72Quest5_Note = "This daily quest can only be completed on Heroic difficulty.\n\nKeristrasza is at "..YELLOW.."[5]"..WHITE.."."
Inst72Quest5_Prequest = "None"
Inst72Quest5_Folgequest = "None"
--
Inst72Quest5name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst72Quest1_HORDE = Inst72Quest1
Inst72Quest1_HORDE_Aim = Inst72Quest1_Aim
Inst72Quest1_HORDE_Location = Inst72Quest1_Location
Inst72Quest1_HORDE_Note = Inst72Quest1_Note
Inst72Quest1_HORDE_Prequest = Inst72Quest1_Prequest
Inst72Quest1_HORDE_Folgequest = Inst72Quest1_Folgequest
--
Inst72Quest1name1_HORDE = Inst72Quest1name1
Inst72Quest1name2_HORDE = Inst72Quest1name2
Inst72Quest1name3_HORDE = Inst72Quest1name3
Inst72Quest1name4_HORDE = Inst72Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst72Quest2_HORDE = Inst72Quest2
Inst72Quest2_HORDE_Aim = Inst72Quest2_Aim
Inst72Quest2_HORDE_Location = Inst72Quest2_Location
Inst72Quest2_HORDE_Note = Inst72Quest2_Note
Inst72Quest2_HORDE_Prequest = Inst72Quest2_Prequest
Inst72Quest2_HORDE_Folgequest = Inst72Quest2_Folgequest
--
Inst72Quest2name1_HORDE = Inst72Quest2name1
Inst72Quest2name2_HORDE = Inst72Quest2name2
Inst72Quest2name3_HORDE = Inst72Quest2name3
Inst72Quest2name4_HORDE = Inst72Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst72Quest3_HORDE = Inst72Quest3
Inst72Quest3_HORDE_Aim = Inst72Quest3_Aim
Inst72Quest3_HORDE_Location = Inst72Quest3_Location
Inst72Quest3_HORDE_Note = Inst72Quest3_Note
Inst72Quest3_HORDE_Prequest = Inst72Quest3_Prequest
Inst72Quest3_HORDE_Folgequest = Inst72Quest3_Folgequest
--
Inst72Quest3name1_HORDE = Inst72Quest3name1
Inst72Quest3name2_HORDE = Inst72Quest3name2
Inst72Quest3name3_HORDE = Inst72Quest3name3

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst72Quest4_HORDE = Inst72Quest4
Inst72Quest4_HORDE_Aim = Inst72Quest4_Aim
Inst72Quest4_HORDE_Location = Inst72Quest4_Location
Inst72Quest4_HORDE_Note = Inst72Quest4_Note
Inst72Quest4_HORDE_Prequest = Inst72Quest4_Prequest
Inst72Quest4_HORDE_Folgequest = Inst72Quest4_Folgequest
--
Inst72Quest4name1_HORDE = Inst72Quest4name1
Inst72Quest4name2_HORDE = Inst72Quest4name2
Inst72Quest4name3_HORDE = Inst72Quest4name3
Inst72Quest4name4_HORDE = Inst72Quest4name4
Inst72Quest4name5_HORDE = Inst72Quest4name5

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst72Quest5_HORDE = Inst72Quest5
Inst72Quest5_HORDE_Aim = Inst72Quest5_Aim
Inst72Quest5_HORDE_Location = Inst72Quest5_Location
Inst72Quest5_HORDE_Note = Inst72Quest5_Note
Inst72Quest5_HORDE_Prequest = Inst72Quest5_Prequest
Inst72Quest5_HORDE_Folgequest = Inst72Quest5_Folgequest
--
Inst72Quest5name1_HORDE = Inst72Quest5name1



--------------- INST73 - The Nexus: The Oculus ---------------

Inst73Story = "The blue Dragon Aspect, Malygos, has created rifts with his manipulation of raw magical power: tears in the very fabric of the magical dimension. The Kirin Tor, the elite magi of Dalaran, have formed a council with the red dragonflight, who are charged with the preservation of life. To this end, the two groups have begun actively subverting Malygos's devastating campaign. The sides have been chosen; the battle lines have been drawn. The only question that remains now is...Who will win."
Inst73Caption = "The Oculus"
Inst73QAA = "6 Quests"
Inst73QAH = "6 Quests"

--Quest 1 Alliance
Inst73Quest1 = "1. The Struggle Persists"
Inst73Quest1_Aim = "Raelorasz wants you to enter the Oculus and rescue Belgaristrasz and his companions."
Inst73Quest1_Location = "Raelorasz (Borean Tundra - Transitus Shield; "..YELLOW.."33.2, 34.4"..WHITE..")"
Inst73Quest1_Note = "Belgaristrasz is released from his cage after you defeat Drakos the Interrogator at "..YELLOW.."[1]"..WHITE.."."
Inst73Quest1_Prequest = "None"
Inst73Quest1_Folgequest = "A Unified Front"
--
Inst73Quest1name1 = "Ring of Temerity"
Inst73Quest1name2 = "Flourishing Band"
Inst73Quest1name3 = "Band of Motivation"
Inst73Quest1name4 = "Staunch Signet"

--Quest 2 Alliance
Inst73Quest2 = "2. A Unified Front"
Inst73Quest2_Aim = "Belgaristrasz wants you to destroy 10 Centrifuge Constructs to bring down Varos' shield. You then must defeat Varos Cloudstrider."
Inst73Quest2_Location = "Belgaristrasz (The Nexus: The Oculus; "..YELLOW.."[1]"..WHITE..")"
Inst73Quest2_Note = "Belgaristrasz will appear after you defeat Varos Cloudstrider at "..YELLOW.."[2]"..WHITE.."."
Inst73Quest2_Prequest = "The Struggle Persists"
Inst73Quest2_Folgequest = "Mage-Lord Urom"
-- No Rewards for this quest

--Quest 3 Alliance
Inst73Quest3 = "3. Mage-Lord Urom"
Inst73Quest3_Aim = "Belgaristrasz wants you to defeat Mage-Lord Urom in the Oculus."
Inst73Quest3_Location = "Image of Belgaristrasz (The Nexus: The Oculus; "..YELLOW.."[2]"..WHITE..")"
Inst73Quest3_Note = "Belgaristrasz will appear after you defeat Mage-Lord Urom at "..YELLOW.."[3]"..WHITE.."."
Inst73Quest3_Prequest = "A Unified Front"
Inst73Quest3_Folgequest = "A Wing and a Prayer"
-- No Rewards for this quest

--Quest 4 Alliance
Inst73Quest4 = "4. A Wing and a Prayer"
Inst73Quest4_Aim = "Belgaristrasz wants you to kill Eregos in the Oculus and then report to Raelorasz at the Transitus Shield in Coldarra."
Inst73Quest4_Location = "Image of Belgaristrasz (The Nexus: The Oculus; "..YELLOW.."[3]"..WHITE..")"
Inst73Quest4_Note = "Ley-Guardian Eregos is at "..YELLOW.."[4]"..WHITE..". Raelorasz is at (Borean Tundra - Transitus Shield; "..YELLOW.."33.2, 34.4"..WHITE..")."
Inst73Quest4_Prequest = "Mage-Lord Urom"
Inst73Quest4_Folgequest = "None"
--
Inst73Quest4name1 = "Cuffs of Gratitude"
Inst73Quest4name2 = "Soaring Wristwraps"
Inst73Quest4name3 = "Bindings of Raelorasz"
Inst73Quest4name4 = "Bracers of Reverence"

--Quest 5 Alliance
Inst73Quest5 = "5. Timear Foresees Centrifuge Constructs in your Future!"
Inst73Quest5_Aim = "Archmage Timear in Dalaran has foreseen that you must destroy 10 Centrifuge Constructs."
Inst73Quest5_Location = "Archmage Timear (Dalaran - The Violet Hold; "..YELLOW.."64.2, 54.7"..WHITE..")"
Inst73Quest5_Note = "This is a daily quest. You find the Centrifuge Constructs in six different groups between the first and second bosses, at "..YELLOW.."1'"..WHITE.."."
Inst73Quest5_Prequest = "None"
Inst73Quest5_Folgequest = "None"
--
Inst73Quest5name1 = "Kirin Tor Commendation Badge"
Inst73Quest5name2 = "Argent Crusade Commendation Badge"
Inst73Quest5name3 = "Ebon Blade Commendation Badge"
Inst73Quest5name4 = "Wyrmrest Commendation Badge"
Inst73Quest5name5 = "Sons of Hodir Commendation Badge"
Inst73Quest5name6 = "Emblem of Conquest"

--Quest 6 Alliance
Inst73Quest6 = "6. Proof of Demise: Ley-Guardian Eregos"
Inst73Quest6_Aim = "Archmage Lan'dalock in Dalaran wants you to return with a Ley Line Tuner."
Inst73Quest6_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst73Quest6_Note = "This daily quest can only be completed on Heroic difficulty.\n\nThe Ley Line Tuner comes from the Cache of Eregos at "..YELLOW.."[5]"..WHITE.."."
Inst73Quest6_Prequest = "None"
Inst73Quest6_Folgequest = "None"
--
Inst73Quest6name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst73Quest1_HORDE = Inst73Quest1
Inst73Quest1_HORDE_Aim = Inst73Quest1_Aim
Inst73Quest1_HORDE_Location = Inst73Quest1_Location
Inst73Quest1_HORDE_Note = Inst73Quest1_Note
Inst73Quest1_HORDE_Prequest = Inst73Quest1_Prequest
Inst73Quest1_HORDE_Folgequest = Inst73Quest1_Folgequest
--
Inst73Quest1name1_HORDE = Inst73Quest1name1
Inst73Quest1name2_HORDE = Inst73Quest1name2
Inst73Quest1name3_HORDE = Inst73Quest1name3
Inst73Quest1name4_HORDE = Inst73Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst73Quest2_HORDE = Inst73Quest2
Inst73Quest2_HORDE_Aim = Inst73Quest2_Aim
Inst73Quest2_HORDE_Location = Inst73Quest2_Location
Inst73Quest2_HORDE_Note = Inst73Quest2_Note
Inst73Quest2_HORDE_Prequest = Inst73Quest2_Prequest
Inst73Quest2_HORDE_Folgequest = Inst73Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst73Quest3_HORDE = Inst73Quest3
Inst73Quest3_HORDE_Aim = Inst73Quest3_Aim
Inst73Quest3_HORDE_Location = Inst73Quest3_Location
Inst73Quest3_HORDE_Note = Inst73Quest3_Note
Inst73Quest3_HORDE_Prequest = Inst73Quest3_Prequest
Inst73Quest3_HORDE_Folgequest = Inst73Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst73Quest4_HORDE = Inst73Quest4
Inst73Quest4_HORDE_Aim = Inst73Quest4_Aim
Inst73Quest4_HORDE_Location = Inst73Quest4_Location
Inst73Quest4_HORDE_Note = Inst73Quest4_Note
Inst73Quest4_HORDE_Prequest = Inst73Quest4_Prequest
Inst73Quest4_HORDE_Folgequest = Inst73Quest4_Folgequest
--
Inst73Quest4name1_HORDE = Inst73Quest4name1
Inst73Quest4name2_HORDE = Inst73Quest4name2
Inst73Quest4name3_HORDE = Inst73Quest4name3
Inst73Quest4name4_HORDE = Inst73Quest4name4

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst73Quest5_HORDE = Inst73Quest5
Inst73Quest5_HORDE_Aim = Inst73Quest5_Aim
Inst73Quest5_HORDE_Location = Inst73Quest5_Location
Inst73Quest5_HORDE_Note = Inst73Quest5_Note
Inst73Quest5_HORDE_Prequest = Inst73Quest5_Prequest
Inst73Quest5_HORDE_Folgequest = Inst73Quest5_Folgequest
--
Inst73Quest5name1_HORDE = Inst73Quest5name1
Inst73Quest5name2_HORDE = Inst73Quest5name2
Inst73Quest5name3_HORDE = Inst73Quest5name3
Inst73Quest5name4_HORDE = Inst73Quest5name4
Inst73Quest5name5_HORDE = Inst73Quest5name5
Inst73Quest5name6_HORDE = Inst73Quest5name6

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst73Quest6_HORDE = Inst73Quest6
Inst73Quest6_HORDE_Aim = Inst73Quest6_Aim
Inst73Quest6_HORDE_Location = Inst73Quest6_Location
Inst73Quest6_HORDE_Note = Inst73Quest6_Note
Inst73Quest6_HORDE_Prequest = Inst73Quest6_Prequest
Inst73Quest6_HORDE_Folgequest = Inst73Quest6_Folgequest
--
Inst73Quest6name1_HORDE = Inst73Quest6name1



--------------- INST74 - The Nexus: The Eye of Eternity ---------------

Inst74Story = "From within the safety of his personal domain, the Eye of Eternity, Malygos coordinates a crusade to reestablish his dominance over the arcane energies coursing through Azeroth. In his eyes, the foolish actions of the Kirin Tor and other mortal magi have plunged the world into chaos, and the abuse of their powers will no longer be tolerated. Threatened by the Spell-Weaver's brutal tactics, the Kirin Tor has allied itself with the red dragonflight. Together, the two groups closely observe Malygos, searching for a way to thwart his campaign and strike out at the Aspect of Magic, but thus far the elusive Spell-Weaver has proven difficult to engage.\n\nAt Wyrmrest Temple, the ancient meeting ground of the dragonflights, Alexstrasza and the ambassadors of other flights have discussed Malygos' recklessness and reluctantly concluded that he is beyond the point of salvation. With the red dragons' assistance, Azeroth's heroes may be able to accomplish what has formerly been unthinkable: challenging the Spell-Weaver from inside the Eye of Eternity. Sustaining the safety of Azeroth depends on Malygos' defeat, but his end will also herald a new age: a world of unguarded magic, absent of the Dragon Aspect powerful enough to watch over it."
Inst74Caption = "The Eye of Eternity"
Inst74QAA = "3 Quests"
Inst74QAH = "3 Quests"

--Quest 1 Alliance
Inst74Quest1 = "1. Judgment at the Eye of Eternity"
Inst74Quest1_Aim = "Krasus atop Wyrmrest Temple in the Dragonblight wants you to return with the Heart of Magic."
Inst74Quest1_Location = "Krasus (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst74Quest1_Note = "After Malygos dies, his Heart of Magic can be found in a Red Heart floating near Alexstrasza's Gift."
Inst74Quest1_Prequest = "The Key to the Focusing Iris ("..YELLOW.."Naxxramas"..WHITE..")"
Inst74Quest1_Folgequest = "None"
--
Inst74Quest1name1 = "Chain of the Ancient Wyrm"
Inst74Quest1name2 = "Torque of the Red Dragonflight"
Inst74Quest1name3 = "Pendant of the Dragonsworn"
Inst74Quest1name4 = "Drakescale Collar"

--Quest 2 Alliance
Inst74Quest2 = "2. Heroic Judgment at the Eye of Eternity"
Inst74Quest2_Aim = "Krasus atop Wyrmrest Temple in the Dragonblight wants you to return with the Heart of Magic."
Inst74Quest2_Location = "Krasus (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst74Quest2_Note = "After Malygos dies, his Heart of Magic can be found in a Red Heart floating near Alexstrasza's Gift."
Inst74Quest2_Prequest = "The Heroic Key to the Focusing Iris ("..YELLOW.."Naxxramas"..WHITE..")"
Inst74Quest2_Folgequest = "None"
--
Inst74Quest2name1 = "Wyrmrest Necklace of Power"
Inst74Quest2name2 = "Life-Binder's Locket"
Inst74Quest2name3 = "Favor of the Dragon Queen"
Inst74Quest2name4 = "Nexus War Champion Beads"

--Quest 3 Alliance
Inst74Quest3 = "3. Malygos Must Die! (Weekly)"
Inst74Quest3_Aim = "Kill Malygos."
Inst74Quest3_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst74Quest3_Note = "Malygos is at "..YELLOW.." [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst74Quest3_Prequest = "None"
Inst74Quest3_Folgequest = "None"
--
Inst74Quest3name1 = "Emblem of Frost"
Inst74Quest3name2 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst74Quest1_HORDE = Inst74Quest1
Inst74Quest1_HORDE_Aim = Inst74Quest1_Aim
Inst74Quest1_HORDE_Location = Inst74Quest1_Location
Inst74Quest1_HORDE_Note = Inst74Quest1_Note
Inst74Quest1_HORDE_Prequest = Inst74Quest1_Prequest
Inst74Quest1_HORDE_Folgequest = Inst74Quest1_Folgequest
--
Inst74Quest1name1_HORDE = Inst74Quest1name1
Inst74Quest1name2_HORDE = Inst74Quest1name2
Inst74Quest1name3_HORDE = Inst74Quest1name3
Inst74Quest1name4_HORDE = Inst74Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst74Quest2_HORDE = Inst74Quest2
Inst74Quest2_HORDE_Aim = Inst74Quest2_Aim
Inst74Quest2_HORDE_Location = Inst74Quest2_Location
Inst74Quest2_HORDE_Note = Inst74Quest2_Note
Inst74Quest2_HORDE_Prequest = Inst74Quest2_Prequest
Inst74Quest2_HORDE_Folgequest = Inst74Quest2_Folgequest
--
Inst74Quest2name1_HORDE = Inst74Quest2name1
Inst74Quest2name2_HORDE = Inst74Quest2name2
Inst74Quest2name3_HORDE = Inst74Quest2name3
Inst74Quest2name4_HORDE = Inst74Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst74Quest3_HORDE = Inst74Quest3
Inst74Quest3_HORDE_Aim = Inst74Quest3_Aim
Inst74Quest3_HORDE_Location = Inst74Quest3_Location
Inst74Quest3_HORDE_Note = Inst74Quest3_Note
Inst74Quest3_HORDE_Prequest = Inst74Quest3_Prequest
Inst74Quest3_HORDE_Folgequest = Inst74Quest3_Folgequest
--
Inst74Quest3name1_HORDE = Inst74Quest3name1
Inst74Quest3name2_HORDE = Inst74Quest3name2



--------------- INST75 - Azjol-Nerub ---------------

Inst75Story = "Azjol-Nerub is a vast underground dungeon hub home to the arachnid-like nerubian. Located in icy Dragonblight, Azjol-Nerub can be divided into two sections: the Old Kingdom and the Upper Kingdom. Many of deepest areas in Azjol-Nerub are held by faceless ones.\n\nAzjol-Nerub: The Upper Kingdom is a mystery waiting to be explored. It once held a powerful and advanced civilization, and many of its treasures still rest here undamaged. Great riches litter the lower halls, not only gems and magic items but art and literature and scholarly tomes. The Scourge infest this place. Forgotten ones seethe below, eager to return to the world above.\n\n"..GREEN.."Quoted from WoWWiki"
Inst75Caption = "Azjol-Nerub"
Inst75QAA = "3 Quests"
Inst75QAH = "3 Quests"

--Quest 1 Alliance
Inst75Quest1 = "1. Don't Forget the Eggs!"
Inst75Quest1_Aim = "Kilix the Unraveler in the Pit of Narjun wants you to enter Azjol-Nerub and destroy 6 Nerubian Scourge Eggs."
Inst75Quest1_Location = "Kilix the Unraveler (Dragonblight - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst75Quest1_Note = "The Nerubian Scourge Eggs are in the room of the first boss, Krik'thir the Gatewatcher at "..YELLOW.."[1]"..WHITE.."."
Inst75Quest1_Prequest = "None"
Inst75Quest1_Folgequest = "None"
--
Inst75Quest1name1 = "Expelling Gauntlets"
Inst75Quest1name2 = "Purging Handguards"
Inst75Quest1name3 = "Wraps of Quelled Bane"
Inst75Quest1name4 = "Gloves of Banished Infliction"

--Quest 2 Alliance
Inst75Quest2 = "2. Death to the Traitor King"
Inst75Quest2_Aim = "Kilix the Unraveler in the Pit of Narjun has tasked you with defeating Anub'arak in Azjol-Nerub. You are to return to Kilix with Anub'arak's Broken Husk."
Inst75Quest2_Location = "Kilix the Unraveler (Dragonblight - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst75Quest2_Note = "Anub'arak is at "..YELLOW.."[3]"..WHITE.."."
Inst75Quest2_Prequest = "None"
Inst75Quest2_Folgequest = "None"
--
Inst75Quest2name1 = "Kilix's Silk Slippers"
Inst75Quest2name2 = "Don Soto's Boots"
Inst75Quest2name3 = "Husk Shard Sabatons"
Inst75Quest2name4 = "Greaves of the Traitor"

--Quest 3 Alliance
Inst75Quest3 = "3. Proof of Demise: Anub'arak"
Inst75Quest3_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Idle Crown of Anub'arak."
Inst75Quest3_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst75Quest3_Note = "This daily quest can only be completed on Heroic difficulty.\n\nAnub'arak is at "..YELLOW.."[3]"..WHITE.."."
Inst75Quest3_Prequest = "None"
Inst75Quest3_Folgequest = "None"
--
Inst75Quest3name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst75Quest1_HORDE = Inst75Quest1
Inst75Quest1_HORDE_Aim = Inst75Quest1_Aim
Inst75Quest1_HORDE_Location = Inst75Quest1_Location
Inst75Quest1_HORDE_Note = Inst75Quest1_Note
Inst75Quest1_HORDE_Prequest = Inst75Quest1_Prequest
Inst75Quest1_HORDE_Folgequest = Inst75Quest1_Folgequest
--
Inst75Quest1name1_HORDE = Inst75Quest1name1
Inst75Quest1name2_HORDE = Inst75Quest1name2
Inst75Quest1name3_HORDE = Inst75Quest1name3
Inst75Quest1name4_HORDE = Inst75Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst75Quest2_HORDE = Inst75Quest2
Inst75Quest2_HORDE_Aim = Inst75Quest2_Aim
Inst75Quest2_HORDE_Location = Inst75Quest2_Location
Inst75Quest2_HORDE_Note = Inst75Quest2_Note
Inst75Quest2_HORDE_Prequest = Inst75Quest2_Prequest
Inst75Quest2_HORDE_Folgequest = Inst75Quest2_Folgequest
--
Inst75Quest2name1_HORDE = Inst75Quest2name1
Inst75Quest2name2_HORDE = Inst75Quest2name2
Inst75Quest2name3_HORDE = Inst75Quest2name3
Inst75Quest2name4_HORDE = Inst75Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst75Quest3_HORDE = Inst75Quest3
Inst75Quest3_HORDE_Aim = Inst75Quest3_Aim
Inst75Quest3_HORDE_Location = Inst75Quest3_Location
Inst75Quest3_HORDE_Note = Inst75Quest3_Note
Inst75Quest3_HORDE_Prequest = Inst75Quest3_Prequest
Inst75Quest3_HORDE_Folgequest = Inst75Quest3_Folgequest
--
Inst75Quest3name1_HORDE = Inst75Quest3name1



--------------- INST76 - Ahn'kahet: The Old Kingdom ---------------

Inst76Story = "Azjol-Nerub is a vast underground dungeon hub home to the arachnid-like nerubian. Located in icy Dragonblight, Azjol-Nerub can be divided into two sections: the Old Kingdom and the Upper Kingdom. Many of deepest areas in Azjol-Nerub are held by faceless ones.\n\nAhn'kahet: The Old Kingdom is the second dungeon located within Azjol-Nerub and is controlled by nerubians.\n\n"..GREEN.."Quoted from WoWWiki"
Inst76Caption = "Ahn'kahet: The Old Kingdom"
Inst76QAA = "4 Quests"
Inst76QAH = "4 Quests"

--Quest 1 Alliance
Inst76Quest1 = "1. All Things in Good Time"
Inst76Quest1_Aim = "Kilix the Unraveler in the Pit of Narjun wants you to obtain an Ahn'kahar Watcher's Corpse and place it upon the Ahn'kahet Brazier in Ahn'kahet."
Inst76Quest1_Location = "Kilix the Unraveler (Dragonblight - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst76Quest1_Note = "This daily quest can only be completed on Heroic difficulty.\n\nThe Ahn'kahet Brazier is behind Herald Volazj at "..YELLOW.."[6]"..WHITE..". The corpse has a 1 hour duration timer and will disappear if you leave the instance while alive."
Inst76Quest1_Prequest = "None"
Inst76Quest1_Folgequest = "None"
-- No Rewards for this quest

--Quest 2 Alliance
Inst76Quest2 = "2. Funky Fungi"
Inst76Quest2_Aim = "You are to collect 6 Grotesque Fungus from Savage Cave Beasts in Ahn'kahet and deliver them to Kilix the Unraveler in The Pit of Narjun."
Inst76Quest2_Location = "Ooze-covered Fungus (drops from Savage Cave Beasts in Ahn'kahet)"
Inst76Quest2_Note = "The Savage Cave Beasts that drop the items for the quest are in the area of the heroic-only boss, Amanitar, at "..YELLOW.."[3]"..WHITE..".\n\nKilix the Unraveler is at (Dragonblight - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")."
Inst76Quest2_Prequest = "None"
Inst76Quest2_Folgequest = "None"
-- No Rewards for this quest

--Quest 3 Alliance
Inst76Quest3 = "3. The Faceless Ones"
Inst76Quest3_Aim = "Kilix the Unraveler in the Pit of Narjun wants you to kill Herald Volazj and the three Forgotten Ones that accompany him in Ahn'Kahet."
Inst76Quest3_Location = "Kilix the Unraveler (Dragonblight - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst76Quest3_Note = "The Forgotten Ones and Herald Volazj can be found at "..YELLOW.."[5]"..WHITE.."."
Inst76Quest3_Prequest = "None"
Inst76Quest3_Folgequest = "None"
--
Inst76Quest3name1 = "Mantle of Thwarted Evil"
Inst76Quest3name2 = "Shoulderpads of Abhorrence"
Inst76Quest3name3 = "Shoulderplates of the Abolished"
Inst76Quest3name4 = "Epaulets of the Faceless Ones"

--Quest 4 Alliance
Inst76Quest4 = "4. Proof of Demise: Herald Volazj"
Inst76Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Faceless One's Withered Brain."
Inst76Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst76Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nHerald Volazj is at "..YELLOW.."[5]"..WHITE.."."
Inst76Quest4_Prequest = "None"
Inst76Quest4_Folgequest = "None"
--
Inst76Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst76Quest1_HORDE = Inst76Quest1
Inst76Quest1_HORDE_Aim = Inst76Quest1_Aim
Inst76Quest1_HORDE_Location = Inst76Quest1_Location
Inst76Quest1_HORDE_Note = Inst76Quest1_Note
Inst76Quest1_HORDE_Prequest = Inst76Quest1_Prequest
Inst76Quest1_HORDE_Folgequest = Inst76Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst76Quest2_HORDE = Inst76Quest2
Inst76Quest2_HORDE_Aim = Inst76Quest2_Aim
Inst76Quest2_HORDE_Location = Inst76Quest2_Location
Inst76Quest2_HORDE_Note = Inst76Quest2_Note
Inst76Quest2_HORDE_Prequest = Inst76Quest2_Prequest
Inst76Quest2_HORDE_Folgequest = Inst76Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst76Quest3_HORDE = Inst76Quest3
Inst76Quest3_HORDE_Aim = Inst76Quest3_Aim
Inst76Quest3_HORDE_Location = Inst76Quest3_Location
Inst76Quest3_HORDE_Note = Inst76Quest3_Note
Inst76Quest3_HORDE_Prequest = Inst76Quest3_Prequest
Inst76Quest3_HORDE_Folgequest = Inst76Quest3_Folgequest
--
Inst76Quest3name1_HORDE = Inst76Quest3name1
Inst76Quest3name2_HORDE = Inst76Quest3name2
Inst76Quest3name3_HORDE = Inst76Quest3name3
Inst76Quest3name4_HORDE = Inst76Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst76Quest4_HORDE = Inst76Quest4
Inst76Quest4_HORDE_Aim = Inst76Quest4_Aim
Inst76Quest4_HORDE_Location = Inst76Quest4_Location
Inst76Quest4_HORDE_Note = Inst76Quest4_Note
Inst76Quest4_HORDE_Prequest = Inst76Quest4_Prequest
Inst76Quest4_HORDE_Folgequest = Inst76Quest4_Folgequest
--
Inst76Quest4name1_HORDE = Inst76Quest4name1



--------------- INST77 - Ulduar: Halls of Stone ---------------

Inst77Story = "In the frigid cliffs of the Storm Peaks, legendary explorer Brann Bronzebeard spent countless hours piecing together clues about a recently discovered titan city known as Ulduar. But far from unearthing the mysteries of the titans, the explorer found the city overrun with iron dwarves. Eager to save the priceless information within the titan city before it was destroyed and lost forever, Brann feared that an even greater evil could be at work behind the fall of Ulduar...."
Inst77Caption = "Halls of Stone"
Inst77QAA = "2 Quests"
Inst77QAH = "2 Quests"

--Quest 1 Alliance
Inst77Quest1 = "1. Halls of Stone"
Inst77Quest1_Aim = "Brann Bronzebeard wants you to accompany him as he uncovers the secrets that lie in the Halls of Stone."
Inst77Quest1_Location = "Brann Bronzebeard (Ulduar: Halls of Stone; "..YELLOW.."[3]"..WHITE..")"
Inst77Quest1_Note = "Follow Brann Bronzebeard into the nearby chamber at "..YELLOW.."[4]"..WHITE.." and protect him from waves of mobs while he works on the stone tablets there. Upon his success, the Tribunal Chest next to the tablets can be opened.\n\nTalk to him again and he'll run to the door outside "..YELLOW.."[5]"..WHITE..". You do not need to follow him, he'll wait for you there. Once defeating Sjonnir the Ironshaper, the quest can be turned into Brahn Bronzebeard."
Inst77Quest1_Prequest = "None"
Inst77Quest1_Folgequest = "None"
--
Inst77Quest1name1 = "Mantle of the Intrepid Explorer"
Inst77Quest1name2 = "Shoulderpads of the Adventurer"
Inst77Quest1name3 = "Spaulders of Lost Secrets"
Inst77Quest1name4 = "Pauldrons of Reconnaissance"

--Quest 2 Alliance
Inst77Quest2 = "2. Proof of Demise: Sjonnir The Ironshaper"
Inst77Quest2_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Curse of Flesh Disc."
Inst77Quest2_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst77Quest2_Note = "This daily quest can only be completed on Heroic difficulty.\n\nSjonnir the Ironshaper is at "..YELLOW.."[5]"..WHITE.."."
Inst77Quest2_Prequest = "None"
Inst77Quest2_Folgequest = "None"
--
Inst77Quest2name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst77Quest1_HORDE = Inst77Quest1
Inst77Quest1_HORDE_Aim = Inst77Quest1_Aim
Inst77Quest1_HORDE_Location = Inst77Quest1_Location
Inst77Quest1_HORDE_Note = Inst77Quest1_Note
Inst77Quest1_HORDE_Prequest = Inst77Quest1_Prequest
Inst77Quest1_HORDE_Folgequest = Inst77Quest1_Folgequest
--
Inst77Quest1name1_HORDE = Inst77Quest1name1
Inst77Quest1name2_HORDE = Inst77Quest1name2
Inst77Quest1name3_HORDE = Inst77Quest1name3
Inst77Quest1name4_HORDE = Inst77Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst77Quest2_HORDE = Inst77Quest2
Inst77Quest2_HORDE_Aim = Inst77Quest2_Aim
Inst77Quest2_HORDE_Location = Inst77Quest2_Location
Inst77Quest2_HORDE_Note = Inst77Quest2_Note
Inst77Quest2_HORDE_Prequest = Inst77Quest2_Prequest
Inst77Quest2_HORDE_Folgequest = Inst77Quest2_Folgequest
--
Inst77Quest2name1_HORDE = Inst77Quest2name1



--------------- INST78 - Ulduar: Halls of Lightning ---------------

Inst78Story = "In the frigid cliffs of the Storm Peaks, legendary explorer Brann Bronzebeard spent countless hours piecing together clues about a recently discovered titan city known as Ulduar. But far from unearthing the mysteries of the titans, the explorer found the city overrun with iron dwarves. Eager to save the priceless information within the titan city before it was destroyed and lost forever, Brann feared that an even greater evil could be at work behind the fall of Ulduar...."
Inst78Caption = "Halls of Lightning"
Inst78QAA = "4 Quests"
Inst78QAH = "4 Quests"

--Quest 1 Alliance
Inst78Quest1 = "1. Whatever it Takes!"
Inst78Quest1_Aim = "King Jokkum in Dun Niffelem wants you to enter the Halls of Lightning and defeat Loken. You are then to return to King Jokkum with Loken's Tongue."
Inst78Quest1_Location = "King Jokkum (The Storm Peaks - Dun Niffelem; "..YELLOW.."65.3, 60.1"..WHITE..")"
Inst78Quest1_Note = "Loken is at "..YELLOW.."[4]"..WHITE..".\n\nThis quest becomes available after an extremely long questline that starts from Gretchen Fizzlespark (Storm Peaks - K3; "..YELLOW.."41.1, 86.1"..WHITE..")."
Inst78Quest1_Prequest = "They Took Our Men! -> The Reckoning"
Inst78Quest1_Folgequest = "None"
Inst78Quest1PreQuest = "true"
--
Inst78Quest1name1 = "Robes of Lightning"
Inst78Quest1name2 = "Hardened Tongue Tunic"
Inst78Quest1name3 = "Lightningbringer's Hauberk"
Inst78Quest1name4 = "Breastplate of Jagged Stone"

--Quest 2 Alliance
Inst78Quest2 = "2. Diametrically Opposed"
Inst78Quest2_Aim = "King Jokkum at Dun Niffelem wants you to enter the Halls of Lightning and defeat Volkhan."
Inst78Quest2_Location = "King Jokkum (The Storm Peaks - Dun Niffelem; "..YELLOW.."65.3, 60.1"..WHITE..")"
Inst78Quest2_Note = "Volkhan is at "..YELLOW.."[2]"..WHITE..".\n\nThis quest becomes available after an extremely long questline that starts from Gretchen Fizzlespark (Storm Peaks - K3; "..YELLOW.."41.1, 86.1"..WHITE..")."
Inst78Quest2_Prequest = "They Took Our Men! -> The Reckoning"
Inst78Quest2_Folgequest = "None"
--
Inst78Quest2name1 = "Lightning Infused Mantle"
Inst78Quest2name2 = "Charred Leather Shoulderguards"
Inst78Quest2name3 = "Stormforged Shoulders"
Inst78Quest2name4 = "Pauldrons of Extinguished Hatred"
Inst78Quest2name5 = "Mantle of Volkhan"

--Quest 3 Alliance
Inst78Quest3 = "3. Timear Foresees Titanium Vanguards in your Future!"
Inst78Quest3_Aim = "Archmage Timear in Dalaran has foreseen that you must slay 7 Titanium Vanguards."
Inst78Quest3_Location = "Archmage Timear (Dalaran - The Violet Hold; "..YELLOW.."64.2, 54.7"..WHITE..")"
Inst78Quest3_Note = "This is a daily quest."
Inst78Quest3_Prequest = "None"
Inst78Quest3_Folgequest = "None"
--
Inst78Quest3name1 = "Kirin Tor Commendation Badge"
Inst78Quest3name2 = "Argent Crusade Commendation Badge"
Inst78Quest3name3 = "Ebon Blade Commendation Badge"
Inst78Quest3name4 = "Wyrmrest Commendation Badge"
Inst78Quest3name5 = "Sons of Hodir Commendation Badge"
Inst78Quest3name6 = "Emblem of Conquest"

--Quest 4 Alliance
Inst78Quest4 = "4. Proof of Demise: Loken"
Inst78Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Celestial Ruby Ring."
Inst78Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst78Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nLoken is at "..YELLOW.."[4]"..WHITE.."."
Inst78Quest4_Prequest = "None"
Inst78Quest4_Folgequest = "None"
--
Inst78Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst78Quest1_HORDE = Inst78Quest1
Inst78Quest1_HORDE_Aim = Inst78Quest1_Aim
Inst78Quest1_HORDE_Location = Inst78Quest1_Location
Inst78Quest1_HORDE_Note = Inst78Quest1_Note
Inst78Quest1_HORDE_Prequest = Inst78Quest1_Prequest
Inst78Quest1_HORDE_Folgequest = Inst78Quest1_Folgequest
--
Inst78Quest1name1_HORDE = Inst78Quest1name1
Inst78Quest1name2_HORDE = Inst78Quest1name2
Inst78Quest1name3_HORDE = Inst78Quest1name3
Inst78Quest1name4_HORDE = Inst78Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst78Quest2_HORDE = Inst78Quest2
Inst78Quest2_HORDE_Aim = Inst78Quest2_Aim
Inst78Quest2_HORDE_Location = Inst78Quest2_Location
Inst78Quest2_HORDE_Note = Inst78Quest2_Note
Inst78Quest2_HORDE_Prequest = Inst78Quest2_Prequest
Inst78Quest2_HORDE_Folgequest = Inst78Quest2_Folgequest
--
Inst78Quest2name1_HORDE = Inst78Quest2name1
Inst78Quest2name2_HORDE = Inst78Quest2name2
Inst78Quest2name3_HORDE = Inst78Quest2name3
Inst78Quest2name4_HORDE = Inst78Quest2name4
Inst78Quest2name5_HORDE = Inst78Quest2name5

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst78Quest3_HORDE = Inst78Quest3
Inst78Quest3_HORDE_Aim = Inst78Quest3_Aim
Inst78Quest3_HORDE_Location = Inst78Quest3_Location
Inst78Quest3_HORDE_Note = Inst78Quest3_Note
Inst78Quest3_HORDE_Prequest = Inst78Quest3_Prequest
Inst78Quest3_HORDE_Folgequest = Inst78Quest3_Folgequest
--
Inst78Quest3name1_HORDE = Inst78Quest3name1
Inst78Quest3name2_HORDE = Inst78Quest3name2
Inst78Quest3name3_HORDE = Inst78Quest3name3
Inst78Quest3name4_HORDE = Inst78Quest3name4
Inst78Quest3name5_HORDE = Inst78Quest3name5
Inst78Quest3name6_HORDE = Inst78Quest3name6

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst78Quest4_HORDE = Inst78Quest4
Inst78Quest4_HORDE_Aim = Inst78Quest4_Aim
Inst78Quest4_HORDE_Location = Inst78Quest4_Location
Inst78Quest4_HORDE_Note = Inst78Quest4_Note
Inst78Quest4_HORDE_Prequest = Inst78Quest4_Prequest
Inst78Quest4_HORDE_Folgequest = Inst78Quest4_Folgequest
--
Inst78Quest4name1_HORDE = Inst78Quest4name1



--------------- INST79 - The Obsidian Sanctum ---------------

Inst79Story = "No information."
Inst79Caption = "The Obsidian Sanctum"
Inst79QAA = "1 Quest"
Inst79QAH = "1 Quest"

--Quest 1 Alliance
Inst79Quest1 = "1. Sartharion Must Die! (Weekly)"
Inst79Quest1_Aim = "Kill Sartharion."
Inst79Quest1_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst79Quest1_Note = "Sartharion is at "..YELLOW.."[4]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst79Quest1_Prequest = "None"
Inst79Quest1_Folgequest = "None"
--
Inst79Quest1name1 = "Emblem of Frost"
Inst79Quest1name2 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst79Quest1_HORDE = Inst79Quest1
Inst79Quest1_HORDE_Aim = Inst79Quest1_Aim
Inst79Quest1_HORDE_Location = Inst79Quest1_Location
Inst79Quest1_HORDE_Note = Inst79Quest1_Note
Inst79Quest1_HORDE_Prequest = Inst79Quest1_Prequest
Inst79Quest1_HORDE_Folgequest = Inst79Quest1_Folgequest
--
Inst79Quest1name1_HORDE = Inst79Quest1name1
Inst79Quest1name2_HORDE = Inst79Quest1name2



--------------- INST80 - Drak'Tharon Keep ---------------

Inst80Story = "Drak'Tharon Keep is located in the icy northlands of Northrend, in the northwestern part of the Grizzly Hills, and is an ancient ice troll stronghold. The Scourge drove the trolls out and took possession, and now the Scourge has a solid garrison there holding the mountain passes. The strange dungeon is filled with dinosaurs and lizards, while teeming with undead. You are sent in to discover the reasoning behind why the trolls are leaving their home of Zul'Drak.\n\n"..GREEN.."Quoted from WoWWiki"
Inst80Caption = "Drak'Tharon Keep"
Inst80QAA = "4 Quests"
Inst80QAH = "4 Quests"

--Quest 1 Alliance
Inst80Quest1 = "1. Cleansing Drak'Tharon"
Inst80Quest1_Aim = "Drakuru wants you to use Drakuru's Elixir at his brazier inside Drak'Tharon. Using Drakuru's Elixir there will require 5 Enduring Mojo."
Inst80Quest1_Location = "Image of Drakuru"
Inst80Quest1_Note = "Drakuru's Brazier is behind The Prophet Tharon'ja at "..YELLOW.."[6]"..WHITE..". Enduring Mojo drops inside Drak'Tharon Keep."
Inst80Quest1_Prequest = "Truce? -> Voices From the Dust"
Inst80Quest1_Folgequest = "None"
--
Inst80Quest1name1 = "Shroud of Temptation"
Inst80Quest1name2 = "Enticing Sabatons"
Inst80Quest1name3 = "Shackles of Dark Whispers"
Inst80Quest1name4 = "Shoulders of the Seducer"

--Quest 2 Alliance
Inst80Quest2 = "2. Search and Rescue"
Inst80Quest2_Aim = "Mack at Granite Springs wants you to go into Drak'Tharon and find out what became of Kurzel."
Inst80Quest2_Location = "Mack Fearsen (Grizzly Hills - Granite Springs; "..YELLOW.."16.6, 48.1"..WHITE..")"
Inst80Quest2_Note = "Kurzel is one of the webbed victims at "..YELLOW.."[2]"..WHITE..". Attack the webbed victims until you find her."
Inst80Quest2_Prequest = "Seared Scourge"
Inst80Quest2_Folgequest = "Head Games"
--
Inst80Quest2name1 = "Kurzel's Angst"
Inst80Quest2name2 = "Kurzel's Rage"
Inst80Quest2name3 = "Kurzel's Warband"

--Quest 3 Alliance
Inst80Quest3 = "3. Head Games"
Inst80Quest3_Aim = "Kurzel wants you to use Kurzel's Blouse Scrap at the corpse of Novos the Summoner, then take the Ichor-Stained Cloth to Mack."
Inst80Quest3_Location = "Kurzel (Drak'Tharon Keep; "..YELLOW.."[2]"..WHITE..")"
Inst80Quest3_Note = "Novos the Summoner is at "..YELLOW.."[3]"..WHITE..". Mack Fearsen is at (Grizzly Hills - Granite Springs; "..YELLOW.."16.6, 48.1"..WHITE..")"
Inst80Quest3_Prequest = "Search and Rescue"
Inst80Quest3_Folgequest = "None"
--
Inst80Quest3name1 = "Shameful Cuffs"
Inst80Quest3name2 = "Scorned Bands"
Inst80Quest3name3 = "Accused Wristguards"
Inst80Quest3name4 = "Disavowed Bracers"

--Quest 4 Alliance
Inst80Quest4 = "4. Proof of Demise: The Prophet Tharon'ja"
Inst80Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Prophet's Enchanted Tiki."
Inst80Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst80Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nThe Prophet Tharon'ja is at "..YELLOW.."[5]"..WHITE.."."
Inst80Quest4_Prequest = "None"
Inst80Quest4_Folgequest = "None"
--
Inst80Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst80Quest1_HORDE = Inst80Quest1
Inst80Quest1_HORDE_Aim = Inst80Quest1_Aim
Inst80Quest1_HORDE_Location = Inst80Quest1_Location
Inst80Quest1_HORDE_Note = Inst80Quest1_Note
Inst80Quest1_HORDE_Prequest = Inst80Quest1_Prequest
Inst80Quest1_HORDE_Folgequest = Inst80Quest1_Folgequest
--
Inst80Quest1name1_HORDE = Inst80Quest1name1
Inst80Quest1name2_HORDE = Inst80Quest1name2
Inst80Quest1name3_HORDE = Inst80Quest1name3
Inst80Quest1name4_HORDE = Inst80Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst80Quest2_HORDE = Inst80Quest2
Inst80Quest2_HORDE_Aim = Inst80Quest2_Aim
Inst80Quest2_HORDE_Location = Inst80Quest2_Location
Inst80Quest2_HORDE_Note = Inst80Quest2_Note
Inst80Quest2_HORDE_Prequest = Inst80Quest2_Prequest
Inst80Quest2_HORDE_Folgequest = Inst80Quest2_Folgequest
--
Inst80Quest2name1_HORDE = Inst80Quest2name1
Inst80Quest2name2_HORDE = Inst80Quest2name2
Inst80Quest2name3_HORDE = Inst80Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst80Quest3_HORDE = Inst80Quest3
Inst80Quest3_HORDE_Aim = Inst80Quest3_Aim
Inst80Quest3_HORDE_Location = Inst80Quest3_Location
Inst80Quest3_HORDE_Note = Inst80Quest3_Note
Inst80Quest3_HORDE_Prequest = Inst80Quest3_Prequest
Inst80Quest3_HORDE_Folgequest = Inst80Quest3_Folgequest
--
Inst80Quest3name1_HORDE = Inst80Quest3name1
Inst80Quest3name2_HORDE = Inst80Quest3name2
Inst80Quest3name3_HORDE = Inst80Quest3name3
Inst80Quest3name4_HORDE = Inst80Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst80Quest4_HORDE = Inst80Quest4
Inst80Quest4_HORDE_Aim = Inst80Quest4_Aim
Inst80Quest4_HORDE_Location = Inst80Quest4_Location
Inst80Quest4_HORDE_Note = Inst80Quest4_Note
Inst80Quest4_HORDE_Prequest = Inst80Quest4_Prequest
Inst80Quest4_HORDE_Folgequest = Inst80Quest4_Folgequest
--
Inst80Quest4name1_HORDE = Inst80Quest4name1



--------------- INST81 - Gundrak ---------------

Inst81Story = "Gundrak is the capital of the Ice Trolls. Located in Zul'Drak, the instance contains three entrances which all lead into a main circle. The Drakkari tribe rule Zul'Drak from here, constantly battling the mighty forces of the Scourge. This dungeon shows the Ice Trolls in all their glory, including the opportunity to fight the Ice Troll leader, and teach us why they have been so successful against the Scourge.\n\n"..GREEN.."Quoted from WoWWiki"
Inst81Caption = "Gundrak"
Inst81QAA = "4 Quests"
Inst81QAH = "4 Quests"

--Quest 1 Alliance
Inst81Quest1 = "1. For Posterity"
Inst81Quest1_Aim = "Chronicler Bah'Kini at Dubra'Jin wants you to enter Gundrak and collect 6 Drakkari History Tablets."
Inst81Quest1_Location = "Chronicler Bah'Kini (Zul'Drak - Dubra'Jin; "..YELLOW.."70.0, 20.9"..WHITE..")"
Inst81Quest1_Note = "The tablets are scattered around the instance. There are enough for a full party to complete the quest. The prequest is optional."
Inst81Quest1_Prequest = "Just Checkin'"
Inst81Quest1_Folgequest = "None"
--
Inst81Quest1name1 = "Lion's Head Ring"
Inst81Quest1name2 = "Ring of Foul Mojo"
Inst81Quest1name3 = "Solid Platinum Band"
Inst81Quest1name4 = "Voodoo Signet"

--Quest 2 Alliance
Inst81Quest2 = "2. Gal'darah Must Pay"
Inst81Quest2_Aim = "Tol'mar at Dubra'Jin wants you to slay Gal'darah in Gundrak."
Inst81Quest2_Location = "Tol'mar (Zul'Drak - Dubra'Jin; "..YELLOW.."69.9, 22.8"..WHITE..")"
Inst81Quest2_Note = "Gal'darah is at "..YELLOW.."[5]"..WHITE.."."
Inst81Quest2_Prequest = "Unfinished Business"
Inst81Quest2_Folgequest = "None"
--
Inst81Quest2name1 = "Sly Mojo Sash"
Inst81Quest2name2 = "Strange Voodoo Belt"
Inst81Quest2name3 = "Ranger's Belt of the Fallen Empire"
Inst81Quest2name4 = "Clasp of the Fallen Demi-God"

--Quest 3 Alliance
Inst81Quest3 = "3. One of a Kind"
Inst81Quest3_Aim = "Chronicler Bah'Kini at Dubra'Jin wants you to enter Gundrak and recover a piece of the Drakkari Colossus."
Inst81Quest3_Location = "Chronicler Bah'Kini (Zul'Drak - Dubra'Jin; "..YELLOW.."70.0, 20.9"..WHITE..")"
Inst81Quest3_Note = "The Drakkari Colossus Fragment drops from Drakkari Colossus at "..YELLOW.."[2]"..WHITE.."."
Inst81Quest3_Prequest = "None"
Inst81Quest3_Folgequest = "None"
--
Inst81Quest3name1 = "Fur-lined Moccasins"
Inst81Quest3name2 = "Rhino Hide Kneeboots"
Inst81Quest3name3 = "Scaled Boots of Fallen Hope"
Inst81Quest3name4 = "Slippers of the Mojo Dojo"
Inst81Quest3name5 = "Trollkickers"

--Quest 4 Alliance
Inst81Quest4 = "4. Proof of Demise: Gal'darah"
Inst81Quest4_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Mojo Remnant of Akali."
Inst81Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst81Quest4_Note = "This daily quest can only be completed on Heroic difficulty.\n\nGal'darah is at "..YELLOW.."[5]"..WHITE.."."
Inst81Quest4_Prequest = "None"
Inst81Quest4_Folgequest = "None"
--
Inst81Quest4name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst81Quest1_HORDE = Inst81Quest1
Inst81Quest1_HORDE_Aim = Inst81Quest1_Aim
Inst81Quest1_HORDE_Location = Inst81Quest1_Location
Inst81Quest1_HORDE_Note = Inst81Quest1_Note
Inst81Quest1_HORDE_Prequest = Inst81Quest1_Prequest
Inst81Quest1_HORDE_Folgequest = Inst81Quest1_Folgequest
--
Inst81Quest1name1_HORDE = Inst81Quest1name1
Inst81Quest1name2_HORDE = Inst81Quest1name2
Inst81Quest1name3_HORDE = Inst81Quest1name3
Inst81Quest1name4_HORDE = Inst81Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst81Quest2_HORDE = Inst81Quest2
Inst81Quest2_HORDE_Aim = Inst81Quest2_Aim
Inst81Quest2_HORDE_Location = Inst81Quest2_Location
Inst81Quest2_HORDE_Note = Inst81Quest2_Note
Inst81Quest2_HORDE_Prequest = Inst81Quest2_Prequest
Inst81Quest2_HORDE_Folgequest = Inst81Quest2_Folgequest
--
Inst81Quest2name1_HORDE = Inst81Quest2name1
Inst81Quest2name2_HORDE = Inst81Quest2name2
Inst81Quest2name3_HORDE = Inst81Quest2name3
Inst81Quest2name4_HORDE = Inst81Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst81Quest3_HORDE = Inst81Quest3
Inst81Quest3_HORDE_Aim = Inst81Quest3_Aim
Inst81Quest3_HORDE_Location = Inst81Quest3_Location
Inst81Quest3_HORDE_Note = Inst81Quest3_Note
Inst81Quest3_HORDE_Prequest = Inst81Quest3_Prequest
Inst81Quest3_HORDE_Folgequest = Inst81Quest3_Folgequest
--
Inst81Quest3name1_HORDE = Inst81Quest3name1
Inst81Quest3name2_HORDE = Inst81Quest3name2
Inst81Quest3name3_HORDE = Inst81Quest3name3
Inst81Quest3name4_HORDE = Inst81Quest3name4
Inst81Quest3name5_HORDE = Inst81Quest3name5

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst81Quest4_HORDE = Inst81Quest4
Inst81Quest4_HORDE_Aim = Inst81Quest4_Aim
Inst81Quest4_HORDE_Location = Inst81Quest4_Location
Inst81Quest4_HORDE_Note = Inst81Quest4_Note
Inst81Quest4_HORDE_Prequest = Inst81Quest4_Prequest
Inst81Quest4_HORDE_Folgequest = Inst81Quest4_Folgequest
--
Inst81Quest4name1_HORDE = Inst81Quest4name1



--------------- INST82 - The Violet Hold ---------------

Inst82Story = "Among the ornate spires and enchanted streets of Dalaran, a dark presence stirs within the mighty walls of the Violet Hold. Long used to restrain threats to the city, the tower holds row upon row of deadly inmates, and it has been diligently watched over by the Kirin Tor. However, a sudden assault has tested the integrity of the hold, putting at risk the safety of everyone outside the prison's walls. Using the dungeon as a means to breach the city, Malygos and his blue dragonflight have begun to chip away at the Violet Hold's defenses, hungry to reclaim arcane dominance over Azeroth. Only the brave souls of those protecting the prison stand between the continued existence of Dalaran and the city's utter annihilation."
Inst82Caption = "The Violet Hold"
Inst82QAA = "3 Quests"
Inst82QAH = "3 Quests"

--Quest 1 Alliance
Inst82Quest1 = "1. Discretion is Key"
Inst82Quest1_Aim = "Rhonin wants you to go to the Violet Hold in Dalaran and speak with Warden Alturas."
Inst82Quest1_Location = "Rhonin (Dalaran - The Violet Citadel; "..YELLOW.."30.5, 48.4"..WHITE..")"
Inst82Quest1_Note = "Warden Alturas is at (Dalaran - The Violet Hold; "..YELLOW.."60.8, 62.7"..WHITE..")"
Inst82Quest1_Prequest = "None"
Inst82Quest1_Folgequest = "Containment"
-- No Rewards for this quest

--Quest 2 Alliance
Inst82Quest2 = "2. Containment"
Inst82Quest2_Aim = "Warden Alturas wants you to enter the Violet Hold and put and end to the blue dragon invasion force. You are to report back to him once Cyanigosa is slain."
Inst82Quest2_Location = "Warden Alturas (Dalaran - The Violet Hold; "..YELLOW.."60.8, 62.7"..WHITE..")"
Inst82Quest2_Note = "Cyanigosa is at "..YELLOW.."[6]"..WHITE.."."
Inst82Quest2_Prequest = "Discretion is Key"
Inst82Quest2_Folgequest = "None"
--
Inst82Quest2name1 = "Tattooed Deerskin Leggings"
Inst82Quest2name2 = "Conferred Pantaloons"
Inst82Quest2name3 = "Labyrinthine Legguards"
Inst82Quest2name4 = "Dalaran Warden's Legplates"

--Quest 3 Alliance
Inst82Quest3 = "3. Proof of Demise: Cyanigosa"
Inst82Quest3_Aim = "Archmage Lan'dalock in Dalaran wants you to return with the Head of Cyanigosa."
Inst82Quest3_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst82Quest3_Note = "This daily quest can only be completed on Heroic difficulty.\n\nCyanigosa is at "..YELLOW.."[6]"..WHITE.."."
Inst82Quest3_Prequest = "None"
Inst82Quest3_Folgequest = "None"
--
Inst82Quest3name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst82Quest1_HORDE = Inst82Quest1
Inst82Quest1_HORDE_Aim = Inst82Quest1_Aim
Inst82Quest1_HORDE_Location = Inst82Quest1_Location
Inst82Quest1_HORDE_Note = Inst82Quest1_Note
Inst82Quest1_HORDE_Prequest = Inst82Quest1_Prequest
Inst82Quest1_HORDE_Folgequest = Inst82Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst82Quest2_HORDE = Inst82Quest2
Inst82Quest2_HORDE_Aim = Inst82Quest2_Aim
Inst82Quest2_HORDE_Location = Inst82Quest2_Location
Inst82Quest2_HORDE_Note = Inst82Quest2_Note
Inst82Quest2_HORDE_Prequest = Inst82Quest2_Prequest
Inst82Quest2_HORDE_Folgequest = Inst82Quest2_Folgequest
--
Inst82Quest2name1_HORDE = Inst82Quest2name1
Inst82Quest2name2_HORDE = Inst82Quest2name2
Inst82Quest2name3_HORDE = Inst82Quest2name3
Inst82Quest2name4_HORDE = Inst82Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst82Quest3_HORDE = Inst82Quest3
Inst82Quest3_HORDE_Aim = Inst82Quest3_Aim
Inst82Quest3_HORDE_Location = Inst82Quest3_Location
Inst82Quest3_HORDE_Note = Inst82Quest3_Note
Inst82Quest3_HORDE_Prequest = Inst82Quest3_Prequest
Inst82Quest3_HORDE_Folgequest = Inst82Quest3_Folgequest
--
Inst82Quest3name1_HORDE = Inst82Quest3name1




--------------- INST83 - Strand of the Ancients (SotA)  ---------------

Inst83Story = "The Strand of the Ancients is a battleground located off the southern coast of the Dragonblight being introduced in Wrath of the Lich King. This battleground consists of 3 walls which have to be destroyed to continue, capture points and a graveyard after each wall. The overall goal is to be the first team to get through the last wall.\n\n"..GREEN.."Quoted from WoWWiki"
Inst83Caption = "Strand of the Ancients"
Inst83QAA = "1 Quest"
Inst83QAH = "1 Quest"

--Quest 1 Alliance
Inst83Quest1 = "1. Call to Arms: Strand of the Ancients (Daily)"
Inst83Quest1_Aim = "Win a Strand of the Ancients battleground match and return to an Alliance Brigadier General at any Alliance capital city, Wintergrasp, Dalaran or Shattrath."
Inst83Quest1_Location = "Alliance Brigadier General:\n   Wintergrasp: Wintergrasp Fortress - "..YELLOW.."50.0, 14.0"..WHITE.." (patrols)\n   Dalaran: The Silver Enclave - "..YELLOW.."29.8, 75.8"..WHITE.."\n   Shattrath: Lower City - "..YELLOW.."66.6, 34.6"..WHITE.."\n   Stormwind: Stormwind Keep - "..YELLOW.."83.8, 35.4"..WHITE.."\n   Ironforge: Military Ward - "..YELLOW.."69.9, 89.6"..WHITE.."\n   Darnassus: Warrior's Terrace - "..YELLOW.."57.6, 34.1"..WHITE.."\n   Exodar: The Vault of Lights - "..YELLOW.."24.6, 55.4"
Inst83Quest1_Note = "This quest can be done once a day when it is available. It yields varying amounts of experience and gold based on your level."
Inst83Quest1_Prequest = "None"
Inst83Quest1_Folgequest = "None"
-- No Rewards for this quest

--Quest 1 Horde
Inst83Quest1_HORDE = "1. Call to Arms: Strand of the Ancients (Daily)"
Inst83Quest1_HORDE_Aim = "Win a Strand of the Ancients battleground match and return to a Horde Warbringer at any Horde capital city, Wintergrasp, Dalaran or Shattrath."
Inst83Quest1_HORDE_Location = "Horde Warbringer:\n   Wintergrasp: Wintergrasp Fortress - "..YELLOW.."50.0, 14.0"..WHITE.." (patrols)\n   Dalaran: Sunreaver's Sanctuary - "..YELLOW.."58.0, 21.1"..WHITE.."\n   Shattrath: Lower City - "..YELLOW.."67.0, 56.7"..WHITE.."\n   Orgrimmar: Valley of Honor - "..YELLOW.."79.8, 30.3"..WHITE.."\n   Thunder Bluff: The Hunter Rise - "..YELLOW.."55.8, 76.6"..WHITE.."\n   Undercity: The Royal Quarter - "..YELLOW.."60.7, 87.8"..WHITE.."\n   Silvermoon: Farstriders Square - "..YELLOW.."97.0, 38.3"
Inst83Quest1_HORDE_Note = "This quest can be done once a day when it is available. It yields varying amounts of experience and gold based on your level."
Inst83Quest1_HORDE_Prequest = "None"
Inst83Quest1_HORDE_Folgequest = "None"
-- No Rewards for this quest



--------------- INST84 - Naxxramas (Naxx) ---------------

Inst84Caption = "Naxxramas"
Inst84QAA = "6 Quests"
Inst84QAH = "6 Quests"

--Quest 1 Alliance
Inst84Quest1 = "1. The Key to the Focusing Iris"
Inst84Quest1_Aim = "Deliver the Key to the Focusing Iris to Alexstrasza the Life-Binder atop Wyrmrest Temple in the Dragonblight."
Inst84Quest1_Location = "Key to the Focusing Iris (drops from Sapphiron; "..YELLOW.."Frostwyrm Lair [1]"..WHITE..")"
Inst84Quest1_Note = "Alexstrasza is at (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE.."). The reward is required to open up The Nexus: Eye of Eternity for Normal 10-man mode."
Inst84Quest1_Prequest = "None"
Inst84Quest1_Folgequest = "Judgment at the Eye of Eternity ("..YELLOW.."Eye of Eternity"..WHITE..")"
--
Inst84Quest1name1 = "Key to the Focusing Iris"

--Quest 2 Alliance
Inst84Quest2 = "2. The Heroic Key to the Focusing Iris (Heroic)"
Inst84Quest2_Aim = "Deliver the Heroic Key to the Focusing Iris to Alexstrasza the Life-Binder atop Wyrmrest Temple in the Dragonblight."
Inst84Quest2_Location = "Heroic Key to the Focusing Iris (drops from Sapphiron; "..YELLOW.."Frostwyrm Lair [1]"..WHITE..")"
Inst84Quest2_Note = "Alexstrasza is at (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE.."). The reward is required to open up The Nexus: Eye of Eternity for Heroic 25-man mode."
Inst84Quest2_Prequest = "None"
Inst84Quest2_Folgequest = "Judgment at the Eye of Eternity ("..YELLOW.."Eye of Eternity"..WHITE..")"
--
Inst84Quest2name1 = "Heroic Key to the Focusing Iris"

--Quest 3 Alliance
Inst84Quest3 = "3. Anub'Rekhan Must Die! (Weekly)"
Inst84Quest3_Aim = "Kill Anub'Rekhan."
Inst84Quest3_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest3_Note = "Anub'Rekhan is at "..YELLOW.."Arachnid Quarter [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst84Quest3_Prequest = "None"
Inst84Quest3_Folgequest = "None"
--
Inst84Quest3name1 = "Emblem of Frost"
Inst84Quest3name2 = "Emblem of Triumph"

--Quest 4 Alliance
Inst84Quest4 = "4. Instructor Razuvious Must Die! (Weekly)"
Inst84Quest4_Aim = "Kill Instructor Razuvious."
Inst84Quest4_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest4_Note = "Instructor Razuvious is at "..YELLOW.."Military Quarter [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst84Quest4_Prequest = "None"
Inst84Quest4_Folgequest = "None"
--
Inst84Quest4name1 = "Emblem of Frost"
Inst84Quest4name2 = "Emblem of Triumph"

--Quest 5 Alliance
Inst84Quest5 = "5. Noth the Plaguebringer Must Die! (Weekly)"
Inst84Quest5_Aim = "Kill Noth the Plaguebringer."
Inst84Quest5_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest5_Note = "Noth the Plaguebringer is at "..YELLOW.."Plague Quarter [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst84Quest5_Prequest = "None"
Inst84Quest5_Folgequest = "None"
--
Inst84Quest5name1 = "Emblem of Frost"
Inst84Quest5name2 = "Emblem of Triumph"

--Quest 6 Alliance
Inst84Quest6 = "6. Patchwerk Must Die! (Weekly)"
Inst84Quest6_Aim = "Kill Patchwerk."
Inst84Quest6_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest6_Note = "Patchwerk is at "..YELLOW.."Construct Quarter [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst84Quest6_Prequest = "None"
Inst84Quest6_Folgequest = "None"
--
Inst84Quest6name1 = "Emblem of Frost"
Inst84Quest6name2 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst84Quest1_HORDE = Inst84Quest1
Inst84Quest1_HORDE_Aim = Inst84Quest1_Aim
Inst84Quest1_HORDE_Location = Inst84Quest1_Location
Inst84Quest1_HORDE_Note = Inst84Quest1_Note
Inst84Quest1_HORDE_Prequest = Inst84Quest1_Prequest
Inst84Quest1_HORDE_Folgequest = Inst84Quest1_Folgequest
--
Inst84Quest1name1_HORDE = Inst84Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst84Quest2_HORDE = Inst84Quest2
Inst84Quest2_HORDE_Aim = Inst84Quest2_Aim
Inst84Quest2_HORDE_Location = Inst84Quest2_Location
Inst84Quest2_HORDE_Note = Inst84Quest2_Note
Inst84Quest2_HORDE_Prequest = Inst84Quest2_Prequest
Inst84Quest2_HORDE_Folgequest = Inst84Quest2_Folgequest
--
Inst84Quest2name1_HORDE = Inst84Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst84Quest3_HORDE = Inst84Quest3
Inst84Quest3_HORDE_Aim = Inst84Quest3_Aim
Inst84Quest3_HORDE_Location = Inst84Quest3_Location
Inst84Quest3_HORDE_Note = Inst84Quest3_Note
Inst84Quest3_HORDE_Prequest = Inst84Quest3_Prequest
Inst84Quest3_HORDE_Folgequest = Inst84Quest3_Folgequest
--
Inst84Quest3name1_HORDE = Inst84Quest3name1
Inst84Quest3name2_HORDE = Inst84Quest3name2

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst84Quest4_HORDE = Inst84Quest4
Inst84Quest4_HORDE_Aim = Inst84Quest4_Aim
Inst84Quest4_HORDE_Location = Inst84Quest4_Location
Inst84Quest4_HORDE_Note = Inst84Quest4_Note
Inst84Quest4_HORDE_Prequest = Inst84Quest4_Prequest
Inst84Quest4_HORDE_Folgequest = Inst84Quest4_Folgequest
--
Inst84Quest4name1_HORDE = Inst84Quest4name1
Inst84Quest4name2_HORDE = Inst84Quest4name2

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst84Quest5_HORDE = Inst84Quest5
Inst84Quest5_HORDE_Aim = Inst84Quest5_Aim
Inst84Quest5_HORDE_Location = Inst84Quest5_Location
Inst84Quest5_HORDE_Note = Inst84Quest5_Note
Inst84Quest5_HORDE_Prequest = Inst84Quest5_Prequest
Inst84Quest5_HORDE_Folgequest = Inst84Quest5_Folgequest
--
Inst84Quest5name1_HORDE = Inst84Quest5name1
Inst84Quest5name2_HORDE = Inst84Quest5name2

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst84Quest6_HORDE = Inst84Quest6
Inst84Quest6_HORDE_Aim = Inst84Quest6_Aim
Inst84Quest6_HORDE_Location = Inst84Quest6_Location
Inst84Quest6_HORDE_Note = Inst84Quest6_Note
Inst84Quest6_HORDE_Prequest = Inst84Quest6_Prequest
Inst84Quest6_HORDE_Folgequest = Inst84Quest6_Folgequest
--
Inst84Quest6name1_HORDE = Inst84Quest6name1
Inst84Quest6name2_HORDE = Inst84Quest6name2



--------------- INST85 - Vault of Archavon ---------------

Inst85Story = "Overlooking the frozen plains of the Great Dragonblight and the inhospitable wastes of Borean Tundra lies a region known to the denizens of Northrend as Wintergrasp. Seated atop a high plateau, Wintergrasp has remained undisturbed for ages, its icy winds howling unheard amongst the ancient titan fortifications that dot the landscape. However, an abundance of elemental materials and its strategically important titan fortifications are making Wintergrasp the focus of a vicious tug-of-war between the Horde and the Alliance. And then there are the persistent rumors of an ancient titan vault beneath Wintergrasp's keep. One can only marvel at the thought of what treasures may be waiting there...."
Inst85Caption = "Vault of Archavon"
Inst85QAA = "No Quests"
Inst85QAH = "No Quests"



--------------- INST86 - Ulduar ---------------

Inst86Story = "For millennia, Ulduar has remained undisturbed by mortals, far away from their concerns and their struggles. Yet since its recent discovery, many have wondered what the structure's original purpose may have been. Some thought it a city, built to herald the glory of its makers; some thought it a vault containing innumerable treasures, perhaps even relics of the mighty Titans themselves. Such speculations were wrong. Beyond Ulduar's gates lies no city, no treasure vault, no final answer to the Titan's mysteries. All that awaits those who dare set foot in Ulduar is a horror even the Titans could not, would not destroy, an evil they merely... contained. Beneath ancient Ulduar, the Old God of death lies, whispering.... Tread carefully, or its prison will become your tomb."
Inst86Caption = "Ulduar"
Inst86QAA = "20 Quests"
Inst86QAH = "20 Quests"

--Quest 1 Alliance
Inst86Quest1 = "1. Archivum Data Disc"
Inst86Quest1_Aim = "Bring the Archivum Data Disc to the Archivum Console in Ulduar."
Inst86Quest1_Location = "Archivum Data Disc (drops from Assembly of Iron; "..YELLOW.."The Antechamber [5]"..WHITE..")"
Inst86Quest1_Note = "The Data Disc will only drop if you complete the Assembly of Iron encounter on hard mode.  Only one person in the raid will be able to pick up the Data Disc per raid.\n\nAfter the Assembly of Iron is killed, a door opens up.  Turn in the quest at the Archivum Console in the room beyond.  Prospector Doren will give you the following quest."
Inst86Quest1_Prequest = "None"
Inst86Quest1_Folgequest = "The Celestial Planetarium"
-- No Rewards for this quest

--Quest 2 Alliance
Inst86Quest2 = "2. The Celestial Planetarium"
Inst86Quest2_Aim = "Prospector Doren at the Archivum in Ulduar wants you to locate the entrance to the Celestial Planetarium."
Inst86Quest2_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest2_Note = "The Celestial Planetarium is at (Ulduar - The Antechamber; "..YELLOW.."[8]"..WHITE..").\n\nAfter you turn the quest in to Prospector Doren, he will give you four more quests."
Inst86Quest2_Prequest = "Archivum Data Disc"
Inst86Quest2_Folgequest = "Four more quests"
-- No Rewards for this quest

--Quest 3 Alliance
Inst86Quest3 = "3. Hodir's Sigil"
Inst86Quest3_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Hodir's Sigil."
Inst86Quest3_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest3_Note = "Hodir is at "..YELLOW.."The Keepers [10]"..WHITE..".  He must be killed on Hard Mode for the Sigil to drop."
Inst86Quest3_Prequest = "The Celestial Planetarium"
Inst86Quest3_Folgequest = "None"
-- No Rewards for this quest

--Quest 4 Alliance
Inst86Quest4 = "4. Thorim's Sigil"
Inst86Quest4_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Thorim's Sigil."
Inst86Quest4_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest4_Note = "Thorim is at "..YELLOW.."The Keepers [11]"..WHITE..".  He must be killed on Hard Mode for the Sigil to drop."
Inst86Quest4_Prequest = "The Celestial Planetarium"
Inst86Quest4_Folgequest = "None"
-- No Rewards for this quest

--Quest 5 Alliance
Inst86Quest5 = "5. Freya's Sigil"
Inst86Quest5_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Freya's Sigil."
Inst86Quest5_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest5_Note = "Freya is at "..YELLOW.."The Keepers [12]"..WHITE..".  She must be killed on Hard Mode for the Sigil to drop."
Inst86Quest5_Prequest = "The Celestial Planetarium"
Inst86Quest5_Folgequest = "None"
-- No Rewards for this quest

--Quest 6 Alliance
Inst86Quest6 = "6. Mimiron's Sigil"
Inst86Quest6_Aim = "Prospector Doren at the Ulduar Archivum wants you to obtain Mimiron's Sigil."
Inst86Quest6_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest6_Note = "Mimiron is at "..YELLOW.."Spark of Imagination [13]"..WHITE..".  He must be killed on Hard Mode for the Sigil to drop."
Inst86Quest6_Prequest = "The Celestial Planetarium"
Inst86Quest6_Folgequest = "None"
-- No Rewards for this quest

--Quest 7 Alliance
Inst86Quest7 = "7. Algalon"
Inst86Quest7_Aim = "Bring the Sigils of the Watchers to the Archivum Console in Ulduar."
Inst86Quest7_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest7_Note = "Completing this quest allows you to fight Algalon the Observer in the Celestial Planetarium."
Inst86Quest7_Prequest = "The four Sigil quests"
Inst86Quest7_Folgequest = "None"
--
Inst86Quest7name1 = "Celestial Planetarium Key"
Inst86Quest7name2 = "Sack of Ulduar Spoils"

--Quest 8 Alliance
Inst86Quest8 = "8. All Is Well That Ends Well"
Inst86Quest8_Aim = "Take the Reply-Code Alpha to Rhonin in Dalaran."
Inst86Quest8_Location = "Reply-Code Alpha (drops from Algalon the Observer; "..YELLOW.."The Antechamber [7]"..WHITE..")"
Inst86Quest8_Note = "Only one raid member per raid can take the Reply-Code. Rhonin is at Dalaran - The Violet Citadel; "..YELLOW.."30.5, 48.4"..WHITE.."."
Inst86Quest8_Prequest = "None"
Inst86Quest8_Folgequest = "None"
--
Inst86Quest8name1 = "Drape of the Skyherald"
Inst86Quest8name2 = "Sunglimmer Drape"
Inst86Quest8name3 = "Brann's Sealing Ring"
Inst86Quest8name4 = "Starshine Signet"

--Quest 9 Alliance
Inst86Quest9 = "9. Heroic: Archivum Data Disc"
Inst86Quest9_Aim = "Bring the Archivum Data Disc to the Archivum Console in Ulduar."
Inst86Quest9_Location = "Archivum Data Disc (drops from Assembly of Iron; "..YELLOW.."The Antechamber [5]"..WHITE..")"
Inst86Quest9_Note = "The Data Disc will only drop if you complete the Assembly of Iron encounter on Heroic Hard Mode.  Only one person in the raid will be able to pick up the Data Disc per raid.\n\nAfter the Assembly of Iron is killed, a door opens up.  Turn in the quest at the Archivum Console in the room beyond.  Prospector Doren will give you the following quest."
Inst86Quest9_Prequest = "None"
Inst86Quest9_Folgequest = "The Celestial Planetarium"
-- No Rewards for this quest

--Quest 10 Alliance
Inst86Quest10 = "10. Heroic: The Celestial Planetarium"
Inst86Quest10_Aim = "Prospector Doren at the Archivum in Ulduar wants you to locate the entrance to the Celestial Planetarium."
Inst86Quest10_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest10_Note = "The Celestial Planetarium is at (Ulduar - The Antechamber; "..YELLOW.."[8]"..WHITE..").\n\nAfter you turn the quest in to Prospector Doren, he will give you four more quests."
Inst86Quest10_Prequest = "Archivum Data Disc"
Inst86Quest10_Folgequest = "Four more quests"
-- No Rewards for this quest

--Quest 11 Alliance
Inst86Quest11 = "11. Heroic: Hodir's Sigil"
Inst86Quest11_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Hodir's Sigil."
Inst86Quest11_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest11_Note = "Hodir is at "..YELLOW.."The Keepers [10]"..WHITE..".  He must be killed on Heroic Hard Mode for the Sigil to drop."
Inst86Quest11_Prequest = "The Celestial Planetarium"
Inst86Quest11_Folgequest = "None"
-- No Rewards for this quest

--Quest 12 Alliance
Inst86Quest12 = "12. Heroic: Thorim's Sigil"
Inst86Quest12_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Thorim's Sigil."
Inst86Quest12_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest12_Note = "Thorim is at "..YELLOW.."The Keepers [11]"..WHITE..".  He must be killed on Heroic Hard Mode for the Sigil to drop."
Inst86Quest12_Prequest = "The Celestial Planetarium"
Inst86Quest12_Folgequest = "None"
-- No Rewards for this quest

--Quest 13 Alliance
Inst86Quest13 = "13. Heroic: Freya's Sigil"
Inst86Quest13_Aim = "Prospector Doren at the Archivum in Ulduar wants you to obtain Freya's Sigil."
Inst86Quest13_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest13_Note = "Freya is at "..YELLOW.."The Keepers [12]"..WHITE..".  She must be killed on Heroic Hard Mode for the Sigil to drop."
Inst86Quest13_Prequest = "The Celestial Planetarium"
Inst86Quest13_Folgequest = "None"
-- No Rewards for this quest

--Quest 14 Alliance
Inst86Quest14 = "14. Heroic: Mimiron's Sigil"
Inst86Quest14_Aim = "Prospector Doren at the Ulduar Archivum wants you to obtain Mimiron's Sigil."
Inst86Quest14_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest14_Note = "Mimiron is at "..YELLOW.."Spark of Imagination [13]"..WHITE..".  He must be killed on Heroic Hard Mode for the Sigil to drop."
Inst86Quest14_Prequest = "The Celestial Planetarium"
Inst86Quest14_Folgequest = "None"
-- No Rewards for this quest

--Quest 15 Alliance
Inst86Quest15 = "15. Heroic: Algalon"
Inst86Quest15_Aim = "Bring the Sigils of the Watchers to the Archivum Console in Ulduar."
Inst86Quest15_Location = "Prospector Doren (Ulduar - The Antechamber; "..YELLOW.."[6]"..WHITE..")"
Inst86Quest15_Note = "Completing this quest allows you to fight Algalon the Observer in the Celestial Planetarium."
Inst86Quest15_Prequest = "The four Sigil quests"
Inst86Quest15_Folgequest = "None"
--
Inst86Quest15name1 = "Heroic Celestial Planetarium Key"
Inst86Quest15name2 = "Sack of Ulduar Spoils"

--Quest 16 Alliance
Inst86Quest16 = "16. Heroic: All Is Well That Ends Well"
Inst86Quest16_Aim = "Take the Reply-Code Alpha to Rhonin in Dalaran."
Inst86Quest16_Location = "Reply-Code Alpha (drops from Algalon the Observer; "..YELLOW.."The Antechamber [7]"..WHITE..")"
Inst86Quest16_Note = "Only one raid member per raid can take the Reply-Code. Rhonin is at Dalaran - The Violet Citadel; "..YELLOW.."30.5, 48.4"..WHITE.."."
Inst86Quest16_Prequest = "None"
Inst86Quest16_Folgequest = "None"
--
Inst86Quest16name1 = "Drape of the Skyborn"
Inst86Quest16name2 = "Sunglimmer Cloak"
Inst86Quest16name3 = "Brann's Signet Ring"
Inst86Quest16name4 = "Starshine Circle"

--Quest 17 Alliance
Inst86Quest17 = "17. Flame Leviathan Must Die! (Weekly)"
Inst86Quest17_Aim = "Kill Flame Leviathan."
Inst86Quest17_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest17_Note = "Flame Leviathan is at "..YELLOW.."The Siege [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst86Quest17_Prequest = "None"
Inst86Quest17_Folgequest = "None"
--
Inst86Quest17name1 = "Emblem of Frost"
Inst86Quest17name2 = "Emblem of Triumph"

--Quest 18 Alliance
Inst86Quest18 = "18. Ignis the Furnace Master Must Die! (Weekly)"
Inst86Quest18_Aim = "Kill Ignis the Furnace Master."
Inst86Quest18_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest18_Note = "Ignis the Furnace Master is at "..YELLOW.."The Siege [2]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst86Quest18_Prequest = "None"
Inst86Quest18_Folgequest = "None"
--
Inst86Quest18name1 = "Emblem of Frost"
Inst86Quest18name2 = "Emblem of Triumph"

--Quest 19 Alliance
Inst86Quest19 = "19. Razorscale Must Die! (Weekly)"
Inst86Quest19_Aim = "Kill Razorscale."
Inst86Quest19_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest19_Note = "Razorscale is at "..YELLOW.."The Siege [3]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst86Quest19_Prequest = "None"
Inst86Quest19_Folgequest = "None"
--
Inst86Quest19name1 = "Emblem of Frost"
Inst86Quest19name2 = "Emblem of Triumph"

--Quest 20 Alliance
Inst86Quest20 = "20. XT-002 Deconstructor Must Die! (Weekly)"
Inst86Quest20_Aim = "Kill XT-002 Deconstructor."
Inst86Quest20_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest20_Note = "XT-002 Deconstructor is at "..YELLOW.."The Siege [4]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst86Quest20_Prequest = "None"
Inst86Quest20_Folgequest = "None"
--
Inst86Quest20name1 = "Emblem of Frost"
Inst86Quest20name2 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst86Quest1_HORDE = Inst86Quest1
Inst86Quest1_HORDE_Aim = Inst86Quest1_Aim
Inst86Quest1_HORDE_Location = Inst86Quest1_Location
Inst86Quest1_HORDE_Note = Inst86Quest1_Note
Inst86Quest1_HORDE_Prequest = Inst86Quest1_Prequest
Inst86Quest1_HORDE_Folgequest = Inst86Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst86Quest2_HORDE = Inst86Quest2
Inst86Quest2_HORDE_Aim = Inst86Quest2_Aim
Inst86Quest2_HORDE_Location = Inst86Quest2_Location
Inst86Quest2_HORDE_Note = Inst86Quest2_Note
Inst86Quest2_HORDE_Prequest = Inst86Quest2_Prequest
Inst86Quest2_HORDE_Folgequest = Inst86Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst86Quest3_HORDE = Inst86Quest3
Inst86Quest3_HORDE_Aim = Inst86Quest3_Aim
Inst86Quest3_HORDE_Location = Inst86Quest3_Location
Inst86Quest3_HORDE_Note = Inst86Quest3_Note
Inst86Quest3_HORDE_Prequest = Inst86Quest3_Prequest
Inst86Quest3_HORDE_Folgequest = Inst86Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst86Quest4_HORDE = Inst86Quest4
Inst86Quest4_HORDE_Aim = Inst86Quest4_Aim
Inst86Quest4_HORDE_Location = Inst86Quest4_Location
Inst86Quest4_HORDE_Note = Inst86Quest4_Note
Inst86Quest4_HORDE_Prequest = Inst86Quest4_Prequest
Inst86Quest4_HORDE_Folgequest = Inst86Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst86Quest5_HORDE = Inst86Quest5
Inst86Quest5_HORDE_Aim = Inst86Quest5_Aim
Inst86Quest5_HORDE_Location = Inst86Quest5_Location
Inst86Quest5_HORDE_Note = Inst86Quest5_Note
Inst86Quest5_HORDE_Prequest = Inst86Quest5_Prequest
Inst86Quest5_HORDE_Folgequest = Inst86Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst86Quest6_HORDE = Inst86Quest6
Inst86Quest6_HORDE_Aim = Inst86Quest6_Aim
Inst86Quest6_HORDE_Location = Inst86Quest6_Location
Inst86Quest6_HORDE_Note = Inst86Quest6_Note
Inst86Quest6_HORDE_Prequest = Inst86Quest6_Prequest
Inst86Quest6_HORDE_Folgequest = Inst86Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst86Quest7_HORDE = Inst86Quest7
Inst86Quest7_HORDE_Aim = Inst86Quest7_Aim
Inst86Quest7_HORDE_Location = Inst86Quest7_Location
Inst86Quest7_HORDE_Note = Inst86Quest7_Note
Inst86Quest7_HORDE_Prequest = Inst86Quest7_Prequest
Inst86Quest7_HORDE_Folgequest = Inst86Quest7_Folgequest
--
Inst86Quest7name1_HORDE = Inst86Quest7name1
Inst86Quest7name2_HORDE = Inst86Quest7name2

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst86Quest8_HORDE = Inst86Quest8
Inst86Quest8_HORDE_Aim = Inst86Quest8_Aim
Inst86Quest8_HORDE_Location = Inst86Quest8_Location
Inst86Quest8_HORDE_Note = Inst86Quest8_Note
Inst86Quest8_HORDE_Prequest = Inst86Quest8_Prequest
Inst86Quest8_HORDE_Folgequest = Inst86Quest8_Folgequest
--
Inst86Quest8name1_HORDE = Inst86Quest8name1
Inst86Quest8name2_HORDE = Inst86Quest8name2
Inst86Quest8name3_HORDE = Inst86Quest8name3
Inst86Quest8name4_HORDE = Inst86Quest8name4

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst86Quest9_HORDE = Inst86Quest9
Inst86Quest9_HORDE_Aim = Inst86Quest9_Aim
Inst86Quest9_HORDE_Location = Inst86Quest9_Location
Inst86Quest9_HORDE_Note = Inst86Quest9_Note
Inst86Quest9_HORDE_Prequest = Inst86Quest9_Prequest
Inst86Quest9_HORDE_Folgequest = Inst86Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst86Quest10_HORDE = Inst86Quest10
Inst86Quest10_HORDE_Aim = Inst86Quest10_Aim
Inst86Quest10_HORDE_Location = Inst86Quest10_Location
Inst86Quest10_HORDE_Note = Inst86Quest10_Note
Inst86Quest10_HORDE_Prequest = Inst86Quest10_Prequest
Inst86Quest10_HORDE_Folgequest = Inst86Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst86Quest11_HORDE = Inst86Quest11
Inst86Quest11_HORDE_Aim = Inst86Quest11_Aim
Inst86Quest11_HORDE_Location = Inst86Quest11_Location
Inst86Quest11_HORDE_Note = Inst86Quest11_Note
Inst86Quest11_HORDE_Prequest = Inst86Quest11_Prequest
Inst86Quest11_HORDE_Folgequest = Inst86Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst86Quest12_HORDE = Inst86Quest12
Inst86Quest12_HORDE_Aim = Inst86Quest12_Aim
Inst86Quest12_HORDE_Location = Inst86Quest12_Location
Inst86Quest12_HORDE_Note = Inst86Quest12_Note
Inst86Quest12_HORDE_Prequest = Inst86Quest12_Prequest
Inst86Quest12_HORDE_Folgequest = Inst86Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst86Quest13_HORDE = Inst86Quest13
Inst86Quest13_HORDE_Aim = Inst86Quest13_Aim
Inst86Quest13_HORDE_Location = Inst86Quest13_Location
Inst86Quest13_HORDE_Note = Inst86Quest13_Note
Inst86Quest13_HORDE_Prequest = Inst86Quest13_Prequest
Inst86Quest13_HORDE_Folgequest = Inst86Quest13_Folgequest
-- No Rewards for this quest

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst86Quest14_HORDE = Inst86Quest14
Inst86Quest14_HORDE_Aim = Inst86Quest14_Aim
Inst86Quest14_HORDE_Location = Inst86Quest14_Location
Inst86Quest14_HORDE_Note = Inst86Quest14_Note
Inst86Quest14_HORDE_Prequest = Inst86Quest14_Prequest
Inst86Quest14_HORDE_Folgequest = Inst86Quest14_Folgequest
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst86Quest15_HORDE = Inst86Quest15
Inst86Quest15_HORDE_Aim = Inst86Quest15_Aim
Inst86Quest15_HORDE_Location = Inst86Quest15_Location
Inst86Quest15_HORDE_Note = Inst86Quest15_Note
Inst86Quest15_HORDE_Prequest = Inst86Quest15_Prequest
Inst86Quest15_HORDE_Folgequest = Inst86Quest15_Folgequest
--
Inst86Quest15name1_HORDE = Inst86Quest15name1
Inst86Quest15name2_HORDE = Inst86Quest15name2

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst86Quest16_HORDE = Inst86Quest16
Inst86Quest16_HORDE_Aim = Inst86Quest16_Aim
Inst86Quest16_HORDE_Location = Inst86Quest16_Location
Inst86Quest16_HORDE_Note = Inst86Quest16_Note
Inst86Quest16_HORDE_Prequest = Inst86Quest16_Prequest
Inst86Quest16_HORDE_Folgequest = Inst86Quest16_Folgequest
--
Inst86Quest16name1_HORDE = Inst86Quest16name1
Inst86Quest16name2_HORDE = Inst86Quest16name2
Inst86Quest16name3_HORDE = Inst86Quest16name3
Inst86Quest16name4_HORDE = Inst86Quest16name4

--Quest 17 Horde  (same as Quest 17 Alliance)
Inst86Quest17_HORDE = Inst86Quest17
Inst86Quest17_HORDE_Aim = Inst86Quest17_Aim
Inst86Quest17_HORDE_Location = Inst86Quest17_Location
Inst86Quest17_HORDE_Note = Inst86Quest17_Note
Inst86Quest17_HORDE_Prequest = Inst86Quest17_Prequest
Inst86Quest17_HORDE_Folgequest = Inst86Quest17_Folgequest
--
Inst86Quest17name1_HORDE = Inst86Quest17name1
Inst86Quest17name2_HORDE = Inst86Quest17name2

--Quest 18 Horde  (same as Quest 18 Alliance)
Inst86Quest18_HORDE = Inst86Quest18
Inst86Quest18_HORDE_Aim = Inst86Quest18_Aim
Inst86Quest18_HORDE_Location = Inst86Quest18_Location
Inst86Quest18_HORDE_Note = Inst86Quest18_Note
Inst86Quest18_HORDE_Prequest = Inst86Quest18_Prequest
Inst86Quest18_HORDE_Folgequest = Inst86Quest18_Folgequest
--
Inst86Quest18name1_HORDE = Inst86Quest18name1
Inst86Quest18name2_HORDE = Inst86Quest18name2

--Quest 19 Horde  (same as Quest 19 Alliance)
Inst86Quest19_HORDE = Inst86Quest19
Inst86Quest19_HORDE_Aim = Inst86Quest19_Aim
Inst86Quest19_HORDE_Location = Inst86Quest19_Location
Inst86Quest19_HORDE_Note = Inst86Quest19_Note
Inst86Quest19_HORDE_Prequest = Inst86Quest19_Prequest
Inst86Quest19_HORDE_Folgequest = Inst86Quest19_Folgequest
--
Inst86Quest19name1_HORDE = Inst86Quest19name1
Inst86Quest19name2_HORDE = Inst86Quest19name2

--Quest 20 Horde  (same as Quest 20 Alliance)
Inst86Quest20_HORDE = Inst86Quest20
Inst86Quest20_HORDE_Aim = Inst86Quest20_Aim
Inst86Quest20_HORDE_Location = Inst86Quest20_Location
Inst86Quest20_HORDE_Note = Inst86Quest20_Note
Inst86Quest20_HORDE_Prequest = Inst86Quest20_Prequest
Inst86Quest20_HORDE_Folgequest = Inst86Quest20_Folgequest
--
Inst86Quest20name1_HORDE = Inst86Quest20name1
Inst86Quest20name2_HORDE = Inst86Quest20name2


--------------- INST87 - Trial of the Champion ---------------

Inst87Story = "The time to strike at the heart of the Scourge is drawing close. Clouds blanket the skies of Azeroth and heroes gather beneath battle-worn banners in preparation for the coming storm. They say that even the darkest cloud has a silver lining. It is this hope that drives the men and women of the Argent Crusade: hope that the Light will see them through these trying times, hope that good will triumph over evil, hope that a hero blessed by the Light will come forth to put an end to the Lich King's dark reign. \n\nSo the Argent Crusade has sent out the call, a call to arms for all heroes far and wide, to meet at the very doorstep of the Lich King's domain and to prove their might in a tournament the likes of which Azeroth has never seen. Of course, a tournament such as this needs a fitting stage. A place where potential candidates are tested to the limits of exhaustion. A place where heroes... become champions. A place called the Crusaders' Coliseum."
Inst87Caption = "Trial of the Champion"
Inst87QAA = "1 Quest"
Inst87QAH = "1 Quest"

--Quest 1 Alliance
Inst87Quest1 = "1. Proof of Demise: The Black Knight"
Inst87Quest1_Aim = "Archmage Lan'dalock in Dalaran wants you to return with a Fragment of the Black Knight's Soul."
Inst87Quest1_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst87Quest1_Note = "This daily quest can only be completed on Heroic difficulty.\n\nThe Black Knight is the final boss in Trial of the Champion."
Inst87Quest1_Prequest = "None"
Inst87Quest1_Folgequest = "None"
--
Inst87Quest1name1 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst87Quest1_HORDE = Inst87Quest1
Inst87Quest1_HORDE_Aim = Inst87Quest1_Aim
Inst87Quest1_HORDE_Location = Inst87Quest1_Location
Inst87Quest1_HORDE_Note = Inst87Quest1_Note
Inst87Quest1_HORDE_Prequest = Inst87Quest1_Prequest
Inst87Quest1_HORDE_Folgequest = Inst87Quest1_Folgequest
--
Inst87Quest1name1_HORDE = Inst87Quest1name1



--------------- INST88 - Trial of the Crusader ---------------

Inst88Story = "The time to strike at the heart of the Scourge is drawing close. Clouds blanket the skies of Azeroth and heroes gather beneath battle-worn banners in preparation for the coming storm. They say that even the darkest cloud has a silver lining. It is this hope that drives the men and women of the Argent Crusade: hope that the Light will see them through these trying times, hope that good will triumph over evil, hope that a hero blessed by the Light will come forth to put an end to the Lich King's dark reign. \n\nSo the Argent Crusade has sent out the call, a call to arms for all heroes far and wide, to meet at the very doorstep of the Lich King's domain and to prove their might in a tournament the likes of which Azeroth has never seen. Of course, a tournament such as this needs a fitting stage. A place where potential candidates are tested to the limits of exhaustion. A place where heroes... become champions. A place called the Crusaders' Coliseum."
Inst88Caption = "Trial of the Crusader"
Inst88QAA = "1 Quest"
Inst88QAH = "1 Quest"

--Quest 1 Alliance
Inst88Quest1 = "1. Lord Jaraxxus Must Die! (Weekly)"
Inst88Quest1_Aim = "Kill Lord Jaraxxus."
Inst88Quest1_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst88Quest1_Note = "Lord Jaraxxus is the second boss.\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst88Quest1_Prequest = "None"
Inst88Quest1_Folgequest = "None"
--
Inst88Quest1name1 = "Emblem of Frost"
Inst88Quest1name2 = "Emblem of Triumph"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst88Quest1_HORDE = Inst88Quest1
Inst88Quest1_HORDE_Aim = Inst88Quest1_Aim
Inst88Quest1_HORDE_Location = Inst88Quest1_Location
Inst88Quest1_HORDE_Note = Inst88Quest1_Note
Inst88Quest1_HORDE_Prequest = Inst88Quest1_Prequest
Inst88Quest1_HORDE_Folgequest = Inst88Quest1_Folgequest
--
Inst88Quest1name1_HORDE = Inst88Quest1name1
Inst88Quest1name2_HORDE = Inst88Quest1name2




--------------- INST89 - Isle of Conquest (IoC)  ---------------

Inst89Story = "An island somewhere off the shores of Northrend. A rock, hardly worth a second look. But as insignificant as it may seem, this is no ordinary place. A sound of thunder as waves crash endlessly against rocky cliffs; a sound of fury as swords clash on the blood-stained fields of this island on the edge of forever.\n\nWelcome to the Isle of Conquest."
Inst89Caption = "Isle of Conquest"
Inst89QAA = "1 Quest"
Inst89QAH = "1 Quest"

--Quest 1 Alliance
Inst89Quest1 = "1. Call to Arms: Isle of Conquest (Daily)"
Inst89Quest1_Aim = "Win an Isle of Conquest battleground match and return to a Alliance Brigadier General at any Alliance capital city, Wintergrasp, Dalaran, or Shattrath."
Inst89Quest1_Location = "Alliance Brigadier General:\n   Wintergrasp: Wintergrasp Fortress - "..YELLOW.."50.0, 14.0"..WHITE.." (patrols)\n   Dalaran: The Silver Enclave - "..YELLOW.."29.8, 75.8"..WHITE.."\n   Shattrath: Lower City - "..YELLOW.."66.6, 34.6"..WHITE.."\n   Stormwind: Stormwind Keep - "..YELLOW.."83.8, 35.4"..WHITE.."\n   Ironforge: Military Ward - "..YELLOW.."69.9, 89.6"..WHITE.."\n   Darnassus: Warrior's Terrace - "..YELLOW.."57.6, 34.1"..WHITE.."\n   Exodar: The Vault of Lights - "..YELLOW.."24.6, 55.4"
Inst89Quest1_Note = "This quest can be done once a day when it is available. It yields varying amounts of experience and gold based on your level."
Inst89Quest1_Prequest = "None"
Inst89Quest1_Folgequest = "None"
-- No Rewards for this quest


--Quest 1 Horde
Inst89Quest1_HORDE = "1. Call to Arms: Isle of Conquest (Daily)"
Inst89Quest1_HORDE_Aim = "Win an Isle of Conquest battleground match and return to a Horde Warbringer at any Horde capital city, Wintergrasp, Dalaran, or Shattrath."
Inst89Quest1_HORDE_Location = "Horde Warbringer:\n   Wintergrasp: Wintergrasp Fortress - "..YELLOW.."50.0, 14.0"..WHITE.." (patrols)\n   Dalaran: Sunreaver's Sanctuary - "..YELLOW.."58.0, 21.1"..WHITE.."\n   Shattrath: Lower City - "..YELLOW.."67.0, 56.7"..WHITE.."\n   Orgrimmar: Valley of Honor - "..YELLOW.."79.8, 30.3"..WHITE.."\n   Thunder Bluff: The Hunter Rise - "..YELLOW.."55.8, 76.6"..WHITE.."\n   Undercity: The Royal Quarter - "..YELLOW.."60.7, 87.8"..WHITE.."\n   Silvermoon: Farstriders Square - "..YELLOW.."97.0, 38.3"
Inst89Quest1_HORDE_Note = "This quest can be done once a day when it is available. It yields varying amounts of experience and gold based on your level."
Inst89Quest1_HORDE_Prequest = "None"
Inst89Quest1_HORDE_Folgequest = "None"
-- No Rewards for this quest




--------------- INST90 - Forge of Souls (FoS)  ---------------

Inst90Story = "Serving as the first wing in this expansive dungeon, the Forge of Souls will quickly put players to the test of carving through the Scourge stronghold into deeper, more treacherous locations. Jaina will command Alliance forces, and Sylvanas will direct Horde forces. The goal is to ruin the twisted engines known as soul grinders found in this portion of the citadel, and then players can advance -- that is, if the Horde and Alliance forces can overcome the foes who confront them."
Inst90Caption = "Forge of Souls"
Inst90QAA = "3 Quests"
Inst90QAH = "3 Quests"

--Quest 1 Alliance
Inst90Quest1 = "1. Inside the Frozen Citadel"
Inst90Quest1_Aim = "Enter The Forge of Souls from the side of Icecrown Citadel and find Lady Jaina Proudmoore."
Inst90Quest1_Location = "Apprentice Nelphi (Dalaran City - Roams outside South Bank)"
Inst90Quest1_Note = "Lady Jaina Proudmoore is just inside the instance."
Inst90Quest1_Prequest = "None"
Inst90Quest1_Folgequest = "Echoes of Tortured Souls"
-- No Rewards for this quest

--Quest 2 Alliance
Inst90Quest2 = "2. Echoes of Tortured Souls"
Inst90Quest2_Aim = "Kill Bronjahm and the Devourer of Souls to secure access to the Pit of Saron."
Inst90Quest2_Location = "Lady Jaina Proudmoore (Forge of Souls; "..YELLOW.."Entrance"..WHITE..")"
Inst90Quest2_Note = "Turn the quest in to Lady Jaina Proudmoore before at "..YELLOW.."[3]"..WHITE.." before you leave the instance.\n\nCompleting this quest is required to enter the Pit of Saron."
Inst90Quest2_Prequest = "Inside the Frozen Citadel"
Inst90Quest2_Folgequest = "The Pit of Saron ("..YELLOW.."Pit of Saron"..WHITE..")"
--
Inst90Quest2name1 = "Emblem of Frost"

--Quest 3 Alliance
Inst90Quest3 = "3. Tempering The Blade"
Inst90Quest3_Aim = "Temper the Reforged Quel'Delar in the Crucible of Souls."
Inst90Quest3_Location = "Caladis Brightspear (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst90Quest3_Note = "The Crucible of Souls is at "..YELLOW.."[3]"..WHITE..", near the end of the instance."
Inst90Quest3_Prequest = "Reforging The Sword ("..YELLOW.."Pit of Saron"..WHITE..")"
Inst90Quest3_Folgequest = "The Halls Of Reflection ("..YELLOW.."Halls of Reflection"..WHITE..")"
-- No Rewards for this quest


--Quest 1 Horde
Inst90Quest1_HORDE = "1. Inside the Frozen Citadel"
Inst90Quest1_HORDE_Aim = "Enter The Forge of Souls from the side of Icecrown Citadel and locate Lady Sylvanas Windrunner."
Inst90Quest1_HORDE_Location = "Dark Ranger Vorel (Dalaran City - Roams outside North Bank)"
Inst90Quest1_HORDE_Note = "Lady Sylvanas Windrunner is just inside the instance."
Inst90Quest1_HORDE_Prequest = "None"
Inst90Quest1_HORDE_Folgequest = "Echoes of Tortured Souls"
-- No Rewards for this quest

--Quest 2 Horde
Inst90Quest2_HORDE = "2. Echoes of Tortured Souls"
Inst90Quest2_HORDE_Aim = "Kill Bronjahm and the Devourer of Souls to secure access to the Pit of Saron."
Inst90Quest2_HORDE_Location = "Lady Sylvanas Windrunner (Forge of Souls; "..YELLOW.."Entrance"..WHITE..")"
Inst90Quest2_HORDE_Note = "Turn the quest in to Lady Sylvanas Windrunner before at "..YELLOW.."[3]"..WHITE.." before you leave the instance.\n\nCompleting this quest is required to enter the Pit of Saron."
Inst90Quest2_HORDE_Prequest = "Inside the Frozen Citadel"
Inst90Quest2_HORDE_Folgequest = "The Pit of Saron ("..YELLOW.."Pit of Saron"..WHITE..")"
--
Inst90Quest2name1_HORDE = "Emblem of Frost"

--Quest 3 Horde
Inst90Quest3_HORDE = "3. Tempering The Blade"
Inst90Quest3_HORDE_Aim = "Temper the Reforged Quel'Delar in the Crucible of Souls."
Inst90Quest3_HORDE_Location = "Myralion Sunblaze (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst90Quest3_HORDE_Note = "The Crucible of Souls is at "..YELLOW.."[3]"..WHITE..", near the end of the instance."
Inst90Quest3_HORDE_Prequest = "Reforging The Sword ("..YELLOW.."Pit of Saron"..WHITE..")"
Inst90Quest3_HORDE_Folgequest = "The Halls Of Reflection ("..YELLOW.."Halls of Reflection"..WHITE..")"
-- No Rewards for this quest



--------------- INST91 - Pit of Saron (PoS)  ---------------

Inst91Story = "Accessible only to those who have laid waste to the Forge of Souls' unholy operations, the Pit of Saron will bring Horde and Alliance forces deeper into the Lich King's domain. Players who venture here will immediately be confronted by the lord of this lair, Scourgelord Tyrannus. But defeating him will not be as easy as it seems. Before they can present a threat to Tyrannus, the adventurers, instructed by their leaders, will need to free enslaved allies who have been trapped by the Scourge. Until that happens, Tyrannus will leave all adversaries to his minions, workers of the citadel's mines. Perhaps the challenges here will lend clues as to the whereabouts of the Lich King's private chambers outside of the Frozen Throne, deep within the Halls of Reflection."
Inst91Caption = "Pit of Saron"
Inst91QAA = "4 Quests"
Inst91QAH = "4 Quests"

--Quest 1 Alliance
Inst91Quest1 = "1. The Pit of Saron"
Inst91Quest1_Aim = "Meet Lady Jaina Proudmoore just inside the Pit of Saron."
Inst91Quest1_Location = "Lady Jaina Proudmoore (Forge of Souls; "..YELLOW.."[3]"..WHITE..")"
Inst91Quest1_Note = "Lady Jaina Proudmoore is just inside the instance."
Inst91Quest1_Prequest = "Echoes of Tortured Souls ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst91Quest1_Folgequest = "The Path to the Citadel"
-- No Rewards for this quest

--Quest 2 Alliance
Inst91Quest2 = "2. The Path to the Citadel"
Inst91Quest2_Aim = "Free 15 Alliance Slaves and kill Forgemaster Garfrost."
Inst91Quest2_Location = "Lady Jaina Proudmoore (Pit of Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest2_Note = "The slaves are all over the pit. The quest turns in to Martin Victus at "..YELLOW.."[2]"..WHITE.." after Forgemaster Garfrost is slain."
Inst91Quest2_Prequest = "The Pit of Saron"
Inst91Quest2_Folgequest = "Deliverance from the Pit"
-- No Rewards for this quest

--Quest 3 Alliance
Inst91Quest3 = "3. Deliverance from the Pit"
Inst91Quest3_Aim = "Kill Scourgelord Tyrannus."
Inst91Quest3_Location = "Martin Victus (Pit of Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest3_Note = "Scourgelord Tyrannus is at the end of the instance. Completing this quest is required to enter the Halls of Reflection.\n\nRemember to turn the quest in to Lady Jaina Proudmoore before leaving."
Inst91Quest3_Prequest = "The Path to the Citadel"
Inst91Quest3_Folgequest = "Frostmourne ("..YELLOW.."Halls of Reflection"..WHITE..")"
--
Inst91Quest3name1 = "Emblem of Frost"

--Quest 4 Alliance
Inst91Quest4 = "4. Reforging The Sword"
Inst91Quest4_Aim = "Obtain 5 Infused Saronite Bars and the Forgemaster's Hammer and use them to make the Reforged Quel'Delar."
Inst91Quest4_Location = "Caladis Brightspear (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst91Quest4_Note = "The Infused Saronite Bars are spread out around the Pit.  Use the hammer that drops from Forgemaster Garfrost at the anvil near him."
Inst91Quest4_Prequest = "Return To Caladis Brightspear"
Inst91Quest4_Folgequest = "Tempering The Blade ("..YELLOW.."Forge of Souls"..WHITE..")"
-- No Rewards for this quest


--Quest 1 Horde
Inst91Quest1_HORDE = "1. The Pit of Saron"
Inst91Quest1_HORDE_Aim = "Meet Lady Sylvanas Windrunner inside the entrace to the Pit of Saron."
Inst91Quest1_HORDE_Location = "Lady Sylvanas Windrunner (Forge of Souls; "..YELLOW.."[3]"..WHITE..")"
Inst91Quest1_HORDE_Note = "Lady Sylvanas Windrunner is just inside the instance."
Inst91Quest1_HORDE_Prequest = "Echoes of Tortured Souls ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst91Quest1_HORDE_Folgequest = "The Path to the Citadel"
-- No Rewards for this quest

--Quest 2 Horde
Inst91Quest2_HORDE = "2. The Path to the Citadel"
Inst91Quest2_HORDE_Aim = "Free 15 Horde Slaves and kill Forgemaster Garfrost."
Inst91Quest2_HORDE_Location = "Lady Sylvanas Windrunner (Pit of Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest2_HORDE_Note = "The slaves are all over the pit. The quest turns in to Gorkun Ironskull at "..YELLOW.."[2]"..WHITE.." after Forgemaster Garfrost is slain."
Inst91Quest2_HORDE_Prequest = "The Pit of Saron"
Inst91Quest2_HORDE_Folgequest = "Deliverance from the Pit"
-- No Rewards for this quest

--Quest 3 Horde
Inst91Quest3_HORDE = "3. Deliverance from the Pit"
Inst91Quest3_HORDE_Aim = "Kill Scourgelord Tyrannus."
Inst91Quest3_HORDE_Location = "Gorkun Ironskull (Pit of Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest3_HORDE_Note = "Scourgelord Tyrannus is at the end of the instance. Completing this quest is required to enter the Halls of Reflection.\n\nRemember to turn the quest in to Lady Sylvanas Windrunner before leaving."
Inst91Quest3_HORDE_Prequest = "The Path to the Citadel"
Inst91Quest3_HORDE_Folgequest = "Frostmourne ("..YELLOW.."Halls of Reflection"..WHITE..")"
--
Inst91Quest3name1_HORDE = "Emblem of Frost"

--Quest 4 Horde
Inst91Quest4_HORDE = "4. Reforging The Sword"
Inst91Quest4_HORDE_Aim = "Obtain 5 Infused Saronite Bars and the Forgemaster's Hammer, then combine them with the Remnants of Quel'Delar to create the Reforged Quel'Delar."
Inst91Quest4_HORDE_Location = "Myralion Sunblaze (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst91Quest4_HORDE_Note = "The Infused Saronite Bars are spread out around the Pit.  Use the hammer that drops from Forgemaster Garfrost at the anvil near him."
Inst91Quest4_HORDE_Prequest = "Return To Myralion Sunblaze"
Inst91Quest4_HORDE_Folgequest = "Tempering The Blade ("..YELLOW.."Forge of Souls"..WHITE..")"
-- No Rewards for this quest



--------------- INST92 - Halls of Reflection (HoR)  ---------------

Inst92Story = "With Jaina and Sylvanas leading the way, adventurers who make it as far as these frigid halls will quickly recognize the weapon that lies ahead: Frostmourne, the corruptive, legendary device of the Lich King himself. The Lich King's private chambers are within reach, although they may be the death of anyone who ventures there."
Inst92Caption = "Halls of Reflection"
Inst92QAA = "3 Quests"
Inst92QAH = "3 Quests"

--Quest 1 Alliance
Inst92Quest1 = "1. Frostmourne"
Inst92Quest1_Aim = "Meet Lady Jaina Proudmoore at the entrance to the Halls of Reflection."
Inst92Quest1_Location = "Lady Jaina Proudmoore (Pit of Saron; "..YELLOW.."[3]"..WHITE..")"
Inst92Quest1_Note = "You get the quest from Lady Jaina Proudmoore at the end of Pit of Saron and then complete it by entering Halls of Reflection.  Be sure all party members have turned the quest in before proceeding. The followup will be given after the event is completed."
Inst92Quest1_Prequest = "Deliverance from the Pit ("..YELLOW.."Pit of Saron"..WHITE..")"
Inst92Quest1_Folgequest = "Wrath of the Lich King"
-- No Rewards for this quest

--Quest 2 Alliance
Inst92Quest2 = "2. Wrath of the Lich King"
Inst92Quest2_Aim = "Find Lady Jaina Proudmoore and escape the Halls of Reflection."
Inst92Quest2_Location = "Halls of Reflection"
Inst92Quest2_Note = "Lady Jaina Proudmoore is up ahead. You turn the quest into her after the end of the super awesome event."
Inst92Quest2_Prequest = "Frostmourne"
Inst92Quest2_Folgequest = "None"
--
Inst92Quest2name1 = "Emblem of Frost"

--Quest 3 Alliance
Inst92Quest3 = "3. The Halls Of Reflection"
Inst92Quest3_Aim = "Bring your Tempered Quel'Delar to Sword's Rest inside the Halls of Reflection."
Inst92Quest3_Location = "Caladis Brightspear (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst92Quest3_Note = "You can complete the quest just inside the instance."
Inst92Quest3_Prequest = "Tempering The Blade ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst92Quest3_Folgequest = "Journey To The Sunwell"
-- No Rewards for this quest


--Quest 1 Horde
Inst92Quest1_HORDE = "1. Frostmourne"
Inst92Quest1_HORDE_Aim = "Meet Lady Sylvanas Windrunner inside the entrance to the Halls of Reflection."
Inst92Quest1_HORDE_Location = "Lady Sylvanas Windrunner (Pit of Saron; "..YELLOW.."[3]"..WHITE..")"
Inst92Quest1_HORDE_Note = "You get the quest from Lady Sylvanas Windrunner at the end of Pit of Saron and then complete it by entering Halls of Reflection.  Be sure all party members have turned the quest in before proceeding. The followup will be given after the event is completed."
Inst92Quest1_HORDE_Prequest = "Deliverance from the Pit ("..YELLOW.."Pit of Saron"..WHITE..")"
Inst92Quest1_HORDE_Folgequest = "Wrath of the Lich King"
-- No Rewards for this quest

--Quest 2 Horde
Inst92Quest2_HORDE = "2. Wrath of the Lich King"
Inst92Quest2_HORDE_Aim = "Find Lady Sylvanas Windrunner and escape the Halls of Reflection."
Inst92Quest2_HORDE_Location = "Halls of Reflection"
Inst92Quest2_HORDE_Note = "Lady Sylvanas Windrunner is up ahead. You turn the quest into her after the end of the super awesome event."
Inst92Quest2_HORDE_Prequest = "Frostmourne"
Inst92Quest2_HORDE_Folgequest = "None"
--
Inst92Quest2name1_HORDE = "Emblem of Frost"

--Quest 3 Horde
Inst92Quest3_HORDE = "3. The Halls Of Reflection"
Inst92Quest3_HORDE_Aim = "Bring your Tempered Quel'Delar to Sword's Rest inside the Halls of Reflection."
Inst92Quest3_HORDE_Location = "Myralion Sunblaze (Icecrown - Quel'Delar's Rest; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst92Quest3_HORDE_Note = "You can complete the quest just inside the instance."
Inst92Quest3_HORDE_Prequest = "Tempering The Blade ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst92Quest3_HORDE_Folgequest = "Journey To The Sunwell"
-- No Rewards for this quest



--------------- INST93 - Icecrown Citadel (ICC)  ---------------

Inst93Story = "After breaching the fortress, players will face a legion of undead guards directed to repel any invaders. Commanding the defenders is Lord Marrowgar, a monstrosity fused together from the bones of the undead. Supreme Overseer of the Cult of the Damned, Lady Deathwhisper is the next opponent. She bolsters the faith of her followers by promising them the opportunity to give eternal service in undeath.\n\nAs they continue their ascent, the Alliance and Horde heroes ultimately end up outside of the citadel where their hatred for one another erupts into a battle for dominance over the Rampart of Skulls. Players will join in battle alongside High Overlord Saurfang on the Orgrim's Hammer gunship or Muradin Bronzebeard on The Skybreaker in a unique encounter. Each faction will protect its gunship and try to destroy the other one in a back-and-forth battle to see who is truly worthy of facing the Lich King."
Inst93Caption = "Icecrown Citadel"
Inst93QAA = "15 Quests"
Inst93QAH = "15 Quests"

--Quest 1 Alliance
Inst93Quest1 = "1. Lord Marrowgar Must Die! (Weekly)"
Inst93Quest1_Aim = "Kill Lord Marrowgar."
Inst93Quest1_Location = "Archmage Lan'dalock (Dalaran - The Violet Hold; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst93Quest1_Note = "Lord Marrowgar is at "..YELLOW.." [1]"..WHITE..".\n\nRaid Weekly quests can be completed once a week and done on either 10 or 25 man."
Inst93Quest1_Prequest = "None"
Inst93Quest1_Folgequest = "None"
--
Inst93Quest1name1 = "Emblem of Frost"
Inst93Quest1name2 = "Emblem of Triumph"

--Quest 2 Alliance
Inst93Quest2 = "2. Deprogramming (Random Weekly)"
Inst93Quest2_Aim = "Defeat Lady Deathwhisper while ensuring that Darnavan survives."
Inst93Quest2_Location = "Infiltrator Minchar (Icecrown Citadel; "..YELLOW.."Near [1]"..WHITE..")"
Inst93Quest2_Note = "If this quest is available for your raid id, Infiltrator Minchar will appear after you slay Lord Marrowgar.\n\nDuring the Lady Deathwhisper encounter, Darnavan will spawn. He must be kept alive throughout the entire fight to complete the quest."
Inst93Quest2_Prequest = "None"
Inst93Quest2_Folgequest = "None"
--
Inst93Quest2name1 = "Sack of Frosty Treasures"

--Quest 3 Alliance
Inst93Quest3 = "3. Securing the Ramparts (Random Weekly)"
Inst93Quest3_Aim = "Slay the Rotting Frost Giant."
Inst93Quest3_Location = "Skybreaker Lieutenant (Icecrown Citadel; "..GREEN.."[3']"..WHITE..")"
Inst93Quest3_Note = "If this quest is available for your raid id, the Skybreaker Lieutenant will appear when you kill the first trash pull after Lady Deathwhisper.\n\nThe Rotting Frost giant can be found patroling the rampart."
Inst93Quest3_Prequest = "None"
Inst93Quest3_Folgequest = "None"
--
Inst93Quest3name1 = "Sack of Frosty Treasures"

--Quest 4 Alliance
Inst93Quest4 = "4. Residue Rendezvous (Random Weekly)"
Inst93Quest4_Aim = "Return to Alchemist Adrianna while infected with Orange and Green Blight."
Inst93Quest4_Location = "Alchemist Adrianna (Icecrown Citadel; "..GREEN.."[4']"..WHITE..")"
Inst93Quest4_Note = "If this quest is available for your raid id, Alchemist Adrianna will appear after you activate the teleporter past Deathbringer Saurfang.\n\nTo complete the quest at least one raid member must obtain the debuffs from both Festergut and Rotface and return to Alchemist Adrianna within 30 minutes of obtaining the first debuff. All raid members with the quest will receive credit."
Inst93Quest4_Page = {2, "The debuffs go away upon death, logging out, divine intervention and divine shield and possibly other abilities. Hunters who use feign death and survive will retain the debuffs.", };
Inst93Quest4_Prequest = "None"
Inst93Quest4_Folgequest = "None"
--
Inst93Quest4name1 = "Sack of Frosty Treasures"

--Quest 5 Alliance
Inst93Quest5 = "5. Blood Quickening (Random Weekly)"
Inst93Quest5_Aim = "Rescue Infiltrator Minchar before he is executed."
Inst93Quest5_Location = "Alrin the Agile (Icecrown Citadel; Entrance to Crimson Halls)"
Inst93Quest5_Note = "If this quest is available for your raid id, Alrin the Agile will appear at the entrance to the Crimson Halls.\n\nThe 30 minute timer begins upon entering Crimson Halls. You must clear all trash, defeat the Blood Princes and Blood Queen Lana'thel before the timer runs out to complete the quest."
Inst93Quest5_Prequest = "None"
Inst93Quest5_Folgequest = "None"
--
Inst93Quest5name1 = "Sack of Frosty Treasures"

--Quest 6 Alliance
Inst93Quest6 = "6. Respite for a Tormented Soul (Random Weekly)"
Inst93Quest6_Aim = "Use the Life Crystals to preserve Sindragosa's Essence."
Inst93Quest6_Location = "Valithria Dreamwalker (Icecrown Citadel; "..YELLOW.."[11]"..WHITE..")"
Inst93Quest6_Note = "If this quest is available for your raid id, Valithria Dreamwalker will give you the quest after you complete that encounter.\n\nTo complete the quest, raid members must use the provided item to stack debuffs (30 on 10 player, 75 on 25 player) on Sindragosa when she is at 20% health or lower. If successful and Sindragosa gets an aura of Soul Preservation before she dies, the quest is completed."
Inst93Quest6_Prequest = "None"
Inst93Quest6_Folgequest = "None"
--
Inst93Quest6name1 = "Sack of Frosty Treasures"

--Quest 7 Alliance
Inst93Quest7 = "7. The Sacred and the Corrupt"
Inst93Quest7_Aim = "Place Light's Vengeance, 25 Primordial Saronite, Rotface's Acidic Blood, and Festergut's Acidic Blood in Highlord Mograine's runeforge in Icecrown Citadel."
Inst93Quest7_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest7_Note = "This questline is only available to Warriors, Paladins and Death Knights. Highlord Mograine's runeforge is in the entrance of Icecrown Citadel.\n\nRotface's Acidic Blood and Festergut's Acidic Blood only drop from the 25-player version and can only be looted by one player per raid lockout."
Inst93Quest7_Prequest = "None"
Inst93Quest7_Folgequest = "Shadow's Edge"
-- No Rewards for this quest

--Quest 8 Alliance
Inst93Quest8 = "8. Shadow's Edge"
Inst93Quest8_Aim = "Wait for Mograine to forge your weapon."
Inst93Quest8_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest8_Note = "Watch as Mograine forges your weapon, and collect it when he's done."
Inst93Quest8_Prequest = "The Sacred and the Corrupt"
Inst93Quest8_Folgequest = "A Feast of Souls"
--
Inst93Quest8name1 = "Shadow's Edge"

--Quest 9 Alliance
Inst93Quest9 = "9. A Feast of Souls"
Inst93Quest9_Aim = "Highlord Darion Mograine wants you to use Shadow's Edge to slay 1000 of the Lich King's minions in Icecrown Citadel. Souls can be obtained in 10 or 25 person difficulty."
Inst93Quest9_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest9_Note = "You've got a lot of killing to do. Only kills in Icecrown Citadel count towards the 1000."
Inst93Quest9_Prequest = "Shadow's Edge"
Inst93Quest9_Folgequest = "Unholy Infusion"
-- No Rewards for this quest

--Quest 10 Alliance
Inst93Quest10 = "10. Unholy Infusion"
Inst93Quest10_Aim = "Highlord Darion Mograine wants you to infuse Shadow's Edge with Unholy power and slay Professor Putricide."
Inst93Quest10_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest10_Note = "This quest can only be completed in 25-player mode.\n\nTo infuse Shadow's Edge you must take control of the Abomination during the Professor Putricide encounter and use the special ability called Shadow Infusion."
Inst93Quest10_Prequest = "A Feast of Souls"
Inst93Quest10_Folgequest = "Blood Infusion"
-- No Rewards for this quest

--Quest 11 Alliance
Inst93Quest11 = "11. Blood Infusion"
Inst93Quest11_Aim = "Highlord Darion Mograine wants you to infuse Shadow's Edge with blood and defeat Queen Lana'thel."
Inst93Quest11_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest11_Note = "This quest can only be completed in 25-player mode.\n\nTo complete the quest, get the Blood Mirror debuff. Then, assuming you're not bitten first, have the first person bitten bite you. Bite three more people and survive the encounter to complete the quest. Info from hobbesmarcus on WoWhead.com"
Inst93Quest11_Prequest = "Unholy Infusion"
Inst93Quest11_Folgequest = "Frost Infusion"
-- No Rewards for this quest

--Quest 12 Alliance
Inst93Quest12 = "12. Frost Infusion"
Inst93Quest12_Aim = "Highlord Darion Mograine has instructed you to slay Sindragosa after subjecting yourself to 4 of her breath attacks while wielding Shadow's Edge."
Inst93Quest12_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest12_Note = "This quest can only be completed in 25-player mode.\n\nAfter receiving the Frost-Imbued Blade buff from the 4 breath attacks, you must kill Sindragosa within 6 minutes to complete the quest. "
Inst93Quest12_Prequest = "Blood Infusion"
Inst93Quest12_Folgequest = "The Splintered Throne"
-- No Rewards for this quest

--Quest 13 Alliance
Inst93Quest13 = "13. The Splintered Throne"
Inst93Quest13_Aim = "Highlord Darion Mograine wants you to collect 50 Shadowfrost Shards."
Inst93Quest13_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest13_Note = "This quest can only be completed in 25-player mode.\n\nThe Shadowfrost Shards are rare drops from bosses."
Inst93Quest13_Prequest = "Frost Infusion"
Inst93Quest13_Folgequest = "Shadowmourne..."
-- No Rewards for this quest

--Quest 14 Alliance
Inst93Quest14 = "14. Shadowmourne..."
Inst93Quest14_Aim = "Highlord Darion Mograine wants you to bring him Shadow's Edge."
Inst93Quest14_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest14_Note = "This quest upgrades your Shadow's Edge to Shadowmourne."
Inst93Quest14_Prequest = "The Splintered Throne"
Inst93Quest14_Folgequest = "The Lich King's Last Stand"
--
Inst93Quest14name1 = "Shadowmourne"

--Quest 15 Alliance
Inst93Quest15 = "15. The Lich King's Last Stand"
Inst93Quest15_Aim = "Highlord Darion Mograine in Icecrown Citadel wants you to kill the Lich King."
Inst93Quest15_Location = "Highlord Darion Mograine (Icecrown Citadel; "..GREEN.."[1']"..WHITE..")"
Inst93Quest15_Note = "This quest can only be completed in 25-player mode."
Inst93Quest15_Prequest = "Shadowmourne..."
Inst93Quest15_Folgequest = "None"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst93Quest1_HORDE = Inst93Quest1
Inst93Quest1_HORDE_Aim = Inst93Quest1_Aim
Inst93Quest1_HORDE_Location = Inst93Quest1_Location
Inst93Quest1_HORDE_Note = Inst93Quest1_Note
Inst93Quest1_HORDE_Prequest = Inst93Quest1_Prequest
Inst93Quest1_HORDE_Folgequest = Inst93Quest1_Folgequest
--
Inst93Quest1name1_HORDE = Inst93Quest1name1
Inst93Quest1name2_HORDE = Inst93Quest1name2

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst93Quest2_HORDE = Inst93Quest2
Inst93Quest2_HORDE_Aim = Inst93Quest2_Aim
Inst93Quest2_HORDE_Location = Inst93Quest2_Location
Inst93Quest2_HORDE_Note = Inst93Quest2_Note
Inst93Quest2_HORDE_Prequest = Inst93Quest2_Prequest
Inst93Quest2_HORDE_Folgequest = Inst93Quest2_Folgequest
--
Inst93Quest2name1_HORDE = Inst93Quest2name1

--Quest 3 Horde
Inst93Quest3_HORDE = "3. Securing the Ramparts (Weekly)"
Inst93Quest3_HORDE_Aim = "Slay the Rotting Frost Giant."
Inst93Quest3_HORDE_Location = "Kor'kron Lieutenant (Icecrown Citadel; "..GREEN.."[3']"..WHITE..")"
Inst93Quest3_HORDE_Note = "This is one of five random quests that are available in Icecrown Citadel. If this is the quest for your raid id, the Kor'kron Lieutenant will appear when you kill the first trash pull after Lady Deathwhisper.\n\nThe Rotting Frost giant can be found patroling the rampart."
Inst93Quest3_HORDE_Prequest = "None"
Inst93Quest3_HORDE_Folgequest = "None"
--
Inst93Quest3name1_HORDE = "Sack of Frosty Treasures"

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst93Quest4_HORDE = Inst93Quest4
Inst93Quest4_HORDE_Aim = Inst93Quest4_Aim
Inst93Quest4_HORDE_Location = Inst93Quest4_Location
Inst93Quest4_HORDE_Note = Inst93Quest4_Note
Inst93Quest4_HORDE_Page = Inst93Quest4_Page
Inst93Quest4_HORDE_Prequest = Inst93Quest4_Prequest
Inst93Quest4_HORDE_Folgequest = Inst93Quest4_Folgequest
--
Inst93Quest4name1_HORDE = Inst93Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst93Quest5_HORDE = Inst93Quest5
Inst93Quest5_HORDE_Aim = Inst93Quest5_Aim
Inst93Quest5_HORDE_Location = Inst93Quest5_Location
Inst93Quest5_HORDE_Note = Inst93Quest5_Note
Inst93Quest5_HORDE_Prequest = Inst93Quest5_Prequest
Inst93Quest5_HORDE_Folgequest = Inst93Quest5_Folgequest
--
Inst93Quest5name1_HORDE = Inst93Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst93Quest6_HORDE = Inst93Quest6
Inst93Quest6_HORDE_Aim = Inst93Quest6_Aim
Inst93Quest6_HORDE_Location = Inst93Quest6_Location
Inst93Quest6_HORDE_Note = Inst93Quest6_Note
Inst93Quest6_HORDE_Prequest = Inst93Quest6_Prequest
Inst93Quest6_HORDE_Folgequest = Inst93Quest6_Folgequest
--
Inst93Quest6name1_HORDE = Inst93Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst93Quest7_HORDE = Inst93Quest7
Inst93Quest7_HORDE_Aim = Inst93Quest7_Aim
Inst93Quest7_HORDE_Location = Inst93Quest7_Location
Inst93Quest7_HORDE_Note = Inst93Quest7_Note
Inst93Quest7_HORDE_Prequest = Inst93Quest7_Prequest
Inst93Quest7_HORDE_Folgequest = Inst93Quest7_Folgequest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst93Quest8_HORDE = Inst93Quest8
Inst93Quest8_HORDE_Aim = Inst93Quest8_Aim
Inst93Quest8_HORDE_Location = Inst93Quest8_Location
Inst93Quest8_HORDE_Note = Inst93Quest8_Note
Inst93Quest8_HORDE_Prequest = Inst93Quest8_Prequest
Inst93Quest8_HORDE_Folgequest = Inst93Quest8_Folgequest
--
Inst93Quest8name1_HORDE = Inst93Quest8name1

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst93Quest9_HORDE = Inst93Quest9
Inst93Quest9_HORDE_Aim = Inst93Quest9_Aim
Inst93Quest9_HORDE_Location = Inst93Quest9_Location
Inst93Quest9_HORDE_Note = Inst93Quest9_Note
Inst93Quest9_HORDE_Prequest = Inst93Quest9_Prequest
Inst93Quest9_HORDE_Folgequest = Inst93Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst93Quest10_HORDE = Inst93Quest10
Inst93Quest10_HORDE_Aim = Inst93Quest10_Aim
Inst93Quest10_HORDE_Location = Inst93Quest10_Location
Inst93Quest10_HORDE_Note = Inst93Quest10_Note
Inst93Quest10_HORDE_Prequest = Inst93Quest10_Prequest
Inst93Quest10_HORDE_Folgequest = Inst93Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst93Quest11_HORDE = Inst93Quest11
Inst93Quest11_HORDE_Aim = Inst93Quest11_Aim
Inst93Quest11_HORDE_Location = Inst93Quest11_Location
Inst93Quest11_HORDE_Note = Inst93Quest11_Note
Inst93Quest11_HORDE_Prequest = Inst93Quest11_Prequest
Inst93Quest11_HORDE_Folgequest = Inst93Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst93Quest12_HORDE = Inst93Quest12
Inst93Quest12_HORDE_Aim = Inst93Quest12_Aim
Inst93Quest12_HORDE_Location = Inst93Quest12_Location
Inst93Quest12_HORDE_Note = Inst93Quest12_Note
Inst93Quest12_HORDE_Prequest = Inst93Quest12_Prequest
Inst93Quest12_HORDE_Folgequest = Inst93Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst93Quest13_HORDE = Inst93Quest13
Inst93Quest13_HORDE_Aim = Inst93Quest13_Aim
Inst93Quest13_HORDE_Location = Inst93Quest13_Location
Inst93Quest13_HORDE_Note = Inst93Quest13_Note
Inst93Quest13_HORDE_Prequest = Inst93Quest13_Prequest
Inst93Quest13_HORDE_Folgequest = Inst93Quest13_Folgequest
-- No Rewards for this quest

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst93Quest14_HORDE = Inst93Quest14
Inst93Quest14_HORDE_Aim = Inst93Quest14_Aim
Inst93Quest14_HORDE_Location = Inst93Quest14_Location
Inst93Quest14_HORDE_Note = Inst93Quest14_Note
Inst93Quest14_HORDE_Prequest = Inst93Quest14_Prequest
Inst93Quest14_HORDE_Folgequest = Inst93Quest14_Folgequest
--
Inst93Quest14name1_HORDE = Inst93Quest14name1
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst93Quest15_HORDE = Inst93Quest15
Inst93Quest15_HORDE_Aim = Inst93Quest15_Aim
Inst93Quest15_HORDE_Location = Inst93Quest15_Location
Inst93Quest15_HORDE_Note = Inst93Quest15_Note
Inst93Quest15_HORDE_Prequest = Inst93Quest15_Prequest
Inst93Quest15_HORDE_Folgequest = Inst93Quest15_Folgequest
-- No Rewards for this quest



--------------- INST94 - Ruby Sanctum (RS)  ---------------

Inst94Story = "A powerful war party of the Black Dragonflight, led by the fearsome Twilight dragon, Halion, have launched an assault upon the Ruby Sanctum beneath Wyrmrest Temple. By destroying the sanctum, the Black Dragonflight look to crush those that would stand in the way of their masters reemergence into Azeroth and to ultimately shatter the Wyrmrest Accord  the sacred bond that unites the dragonflights.\n\nThe battle that is to come will surely deal a crippling blow to the Red Dragonflight, however, it is up to you to stop this unprecedented offensive and defend the Ruby Sanctum. First you must face the assault of Halion's servants, Saviana Ragefire, Baltharus the Warborn, and General Zarithrian, before squaring off against Halion the Twilight Destroyer, a new and deadly force in this realm."
Inst94Caption = "Ruby Sanctum"
Inst94QAA = "3 Quests"
Inst94QAH = "3 Quests"

--Quest 1 Alliance
Inst94Quest1 = "1. Trouble at Wyrmrest"
Inst94Quest1_Aim = "Speak with Krasus at Wyrmrest Temple in Dragonblight."
Inst94Quest1_Location = "Rhonin (Dalaran - The Violet Citadel; "..YELLOW.."30.5, 48.4"..WHITE..")"
Inst94Quest1_Note = "Krasus is at (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE..")."
Inst94Quest1_Prequest = "None"
Inst94Quest1_Folgequest = "Assault on the Sanctum"
-- No Rewards for this quest

--Quest 2 Alliance
Inst94Quest2 = "2. Assault on the Sanctum"
Inst94Quest2_Aim = "Investigate the Ruby Sanctum beneath Wyrmrest Temple."
Inst94Quest2_Location = "Krasus (Dragonblight - Wyrmrest Temple; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst94Quest2_Note = "Sanctum Guardian Xerestrasza is inside the Ruby Sanctum and appears after you slay the second sub-boss, Baltharius the Warborn at "..YELLOW.."[4]"..WHITE.."."
Inst94Quest2_Prequest = "Trouble at Wyrmrest (optional)"
Inst94Quest2_Folgequest = "The Twilight Destroyer"
-- No Rewards for this quest

--Quest 3 Alliance
Inst94Quest3 = "3. The Twilight Destroyer"
Inst94Quest3_Aim = "Defeat Halion and repel the invasion of the Ruby Sanctum."
Inst94Quest3_Location = "Sanctum Guardian Xerestrasza (Ruby Sanctum; "..YELLOW.."[A] Entrance"..WHITE..")"
Inst94Quest3_Note = "Halion is the main boss, located at "..YELLOW.."[1]"..WHITE.."."
Inst94Quest3_Prequest = "Trouble at Wyrmrest"
Inst94Quest3_Folgequest = "None"
--
Inst94Quest3name1 = "Emblem of Frost"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst94Quest1_HORDE = Inst94Quest1
Inst94Quest1_HORDE_Aim = Inst94Quest1_Aim
Inst94Quest1_HORDE_Location = Inst94Quest1_Location
Inst94Quest1_HORDE_Note = Inst94Quest1_Note
Inst94Quest1_HORDE_Prequest = Inst94Quest1_Prequest
Inst94Quest1_HORDE_Folgequest = Inst94Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst94Quest2_HORDE = Inst94Quest2
Inst94Quest2_HORDE_Aim = Inst94Quest2_Aim
Inst94Quest2_HORDE_Location = Inst94Quest2_Location
Inst94Quest2_HORDE_Note = Inst94Quest2_Note
Inst94Quest2_HORDE_Prequest = Inst94Quest2_Prequest
Inst94Quest2_HORDE_Folgequest = Inst94Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst94Quest3_HORDE = Inst94Quest3
Inst94Quest3_HORDE_Aim = Inst94Quest3_Aim
Inst94Quest3_HORDE_Location = Inst94Quest3_Location
Inst94Quest3_HORDE_Note = Inst94Quest3_Note
Inst94Quest3_HORDE_Prequest = Inst94Quest3_Prequest
Inst94Quest3_HORDE_Folgequest = Inst94Quest3_Folgequest
--
Inst94Quest3name1_HORDE = Inst94Quest3name1






-- End of File
