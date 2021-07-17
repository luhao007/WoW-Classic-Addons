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


This file is for storing quest IDs, levels and maybe other data that does not
need to be localized.  I plan to rename it to AtlasQuest_QuestData.lua soon.


Variables use the following format:

Inst[INST #]Quest[QUEST #]_QuestID

Examples: 
Inst1Quest1_QuestID = "quest ID number"
Inst1Quest1_Attain = "level when quest can be picked up"
Inst1Quest1_Level = "level of quest"


--]]

----------------------------------------------
---------------- DUNGEONS --------------------
----------------------------------------------



--------------- INST1 - Blackrock Depths ---------------

Inst1Quest1_QuestID = "3802"
Inst1Quest1_Level = "52"
Inst1Quest1_Attain = "48"

Inst1Quest2_QuestID = "4136"
Inst1Quest2_Level = "53"
Inst1Quest2_Attain = "48"
Inst1Quest2PreQuest = "true"

Inst1Quest3_QuestID = "4201"
Inst1Quest3_Level = "54"
Inst1Quest3_Attain = "50"

Inst1Quest4_QuestID = "4126"
Inst1Quest4_Level = "55"
Inst1Quest4_Attain = "50"
Inst1Quest4PreQuest = "true"

Inst1Quest5_QuestID = "4262"
Inst1Quest5_Level = "52"
Inst1Quest5_Attain = "48"

Inst1Quest6_QuestID = "4263"
Inst1Quest6_Level = "56"
Inst1Quest6_Attain = "48"
Inst1Quest6FQuest = "true"

Inst1Quest7_QuestID = "4123"
Inst1Quest7_Level = "55"
Inst1Quest7_Attain = "50"

Inst1Quest8_QuestID = "4286"
Inst1Quest8_Level = "56"
Inst1Quest8_Attain = "50"

Inst1Quest9_QuestID = "4024"
Inst1Quest9_Level = "58"
Inst1Quest9_Attain = "52"
Inst1Quest9PreQuest = "true"

Inst1Quest10_QuestID = "4341"
Inst1Quest10_Level = "59"
Inst1Quest10_Attain = "50"
Inst1Quest10PreQuest = "true"

Inst1Quest11_QuestID = "4362"
Inst1Quest11_Level = "59"
Inst1Quest11_Attain = "50"
Inst1Quest11FQuest = "true"

Inst1Quest12_QuestID = "7848"
Inst1Quest12_Level = "60"
Inst1Quest12_Attain = "55"

Inst1Quest13_QuestID = "9015"
Inst1Quest13_Level = "60"
Inst1Quest13_Attain = "58"

Inst1Quest14_QuestID = "4083"
Inst1Quest14_Level = "55"
Inst1Quest14_Attain = "40"

Inst1Quest15_QuestID = "4241"
Inst1Quest15_Level = "54"
Inst1Quest15_Attain = "48"
Inst1Quest15PreQuest = "true"

Inst1Quest16_QuestID = "4242"
Inst1Quest16_Level = "54"
Inst1Quest16_Attain = "48"
Inst1Quest16FQuest = "true"

Inst1Quest17_QuestID = "4264"
Inst1Quest17_Level = "58"
Inst1Quest17_Attain = "50"
Inst1Quest17FQuest = "true"

Inst1Quest18_QuestID = "4282"
Inst1Quest18_Level = "58"
Inst1Quest18_Attain = "50"
Inst1Quest18FQuest = "true"

Inst1Quest19_QuestID = "4322"
Inst1Quest19_Level = "58"
Inst1Quest19_Attain = "50"
Inst1Quest19FQuest = "true"


Inst1Quest1_HORDE_QuestID = "3802"
Inst1Quest1_HORDE_Level = Inst1Quest1_Level
Inst1Quest1_HORDE_Attain = Inst1Quest1_Attain

Inst1Quest2_HORDE_QuestID = "4136"
Inst1Quest2_HORDE_Level = Inst1Quest2_Level
Inst1Quest2_HORDE_Attain = Inst1Quest2_Attain
Inst1Quest2PreQuest_HORDE = Inst1Quest2PreQuest

Inst1Quest3_HORDE_QuestID = "4201"
Inst1Quest3_HORDE_Level = Inst1Quest3_Level
Inst1Quest3_HORDE_Attain = Inst1Quest3_Attain

Inst1Quest4_HORDE_QuestID = "4134"
Inst1Quest4_HORDE_Level = "55"
Inst1Quest4_HORDE_Attain = "50"
Inst1Quest4PreQuest_HORDE = "true"

Inst1Quest5_HORDE_QuestID = "4123"
Inst1Quest5_HORDE_Level = Inst1Quest7_Level
Inst1Quest5_HORDE_Attain = Inst1Quest7_Attain

Inst1Quest6_HORDE_QuestID = "4081"
Inst1Quest6_HORDE_Level = "52"
Inst1Quest6_HORDE_Attain = "48"

Inst1Quest7_HORDE_QuestID = "4082"
Inst1Quest7_HORDE_Level = "54"
Inst1Quest7_HORDE_Attain = "50"
Inst1Quest7FQuest_HORDE = "true"

Inst1Quest8_HORDE_QuestID = "4132"
Inst1Quest8_HORDE_Level = "58"
Inst1Quest8_HORDE_Attain = "52"
Inst1Quest8FQuest_HORDE = "true"

Inst1Quest9_HORDE_QuestID = "4063"
Inst1Quest9_HORDE_Level = "58"
Inst1Quest9_HORDE_Attain = "52"
Inst1Quest9PreQuest_HORDE = "true"

Inst1Quest10_HORDE_QuestID = "4024"
Inst1Quest10_HORDE_Level = Inst1Quest9_Level
Inst1Quest10_HORDE_Attain = Inst1Quest9_Attain
Inst1Quest10PreQuest_HORDE = Inst1Quest9PreQuest

Inst1Quest11_HORDE_QuestID = "3906"
Inst1Quest11_HORDE_Level = "52"
Inst1Quest11_HORDE_Attain = "48"

Inst1Quest12_HORDE_QuestID = "3907"
Inst1Quest12_HORDE_Level = "56"
Inst1Quest12_HORDE_Attain = "48"
Inst1Quest12FQuest_HORDE = "true"

Inst1Quest13_HORDE_QuestID = "7201"
Inst1Quest13_HORDE_Level = "54"
Inst1Quest13_HORDE_Attain = "48"
Inst1Quest13PreQuest_HORDE = "true"

Inst1Quest14_HORDE_QuestID = "3981"
Inst1Quest14_HORDE_Level = "52"
Inst1Quest14_HORDE_Attain = "48"
Inst1Quest14PreQuest_HORDE = "true"

Inst1Quest15_HORDE_QuestID = "4003"
Inst1Quest15_HORDE_Level = "59"
Inst1Quest15_HORDE_Attain = "48"
Inst1Quest15FQuest_HORDE = "true"

Inst1Quest16_HORDE_QuestID = "7848"
Inst1Quest16_HORDE_Level = Inst1Quest12_Level
Inst1Quest16_HORDE_Attain = Inst1Quest12_Attain

Inst1Quest17_HORDE_QuestID = "9015"
Inst1Quest17_HORDE_Level = Inst1Quest13_Level
Inst1Quest17_HORDE_Attain = Inst1Quest13_Attain

Inst1Quest18_HORDE_QuestID = "4083"
Inst1Quest18_HORDE_Level = Inst1Quest14_Level
Inst1Quest18_HORDE_Attain = Inst1Quest14_Attain



--------------- INST2 - Blackwing Lair ---------------

Inst2Quest1_QuestID = "8730"
Inst2Quest1_Level = "60"
Inst2Quest1_Attain = "60"

Inst2Quest2_QuestID = "7781"
Inst2Quest2_Level = "60"
Inst2Quest2_Attain = "60"

Inst2Quest3_QuestID = "8288"
Inst2Quest3_Level = "60"
Inst2Quest3_Attain = "60"


Inst2Quest1_HORDE_QuestID = "8730"
Inst2Quest1_HORDE_Level = Inst2Quest1_Level
Inst2Quest1_HORDE_Attain = Inst2Quest1_Attain

Inst2Quest2_HORDE_QuestID = "7783"
Inst2Quest2_HORDE_Level = "60"
Inst2Quest2_HORDE_Attain = "60"

Inst2Quest3_HORDE_QuestID = "8288"
Inst2Quest3_HORDE_Level = Inst2Quest3_Level
Inst2Quest3_HORDE_Attain = Inst2Quest3_Attain



--------------- INST3 - Lower Blackrock Spire ---------------

Inst3Quest1_QuestID = "4788"
Inst3Quest1_Level = "58"
Inst3Quest1_Attain = "40"
Inst3Quest1PreQuest = "true"

Inst3Quest2_QuestID = "4729"
Inst3Quest2_Level = "59"
Inst3Quest2_Attain = "55"

Inst3Quest3_QuestID = "4862"
Inst3Quest3_Level = "59"
Inst3Quest3_Attain = "55"

Inst3Quest4_QuestID = "4866"
Inst3Quest4_Level = "60"
Inst3Quest4_Attain = "55"

Inst3Quest5_QuestID = "4701"
Inst3Quest5_Level = "59"
Inst3Quest5_Attain = "55"

Inst3Quest6_QuestID = "4867"
Inst3Quest6_Level = "60"
Inst3Quest6_Attain = "55"

Inst3Quest7_QuestID = "5001"
Inst3Quest7_Level = "59"
Inst3Quest7_Attain = "55"

Inst3Quest8_QuestID = "5081"
Inst3Quest8_Level = "60"
Inst3Quest8_Attain = "55"
Inst3Quest8FQuest = "true"

Inst3Quest9_QuestID = "4742"
Inst3Quest9_Level = "60"
Inst3Quest9_Attain = "57"

Inst3Quest10_QuestID = "5089"
Inst3Quest10_Level = "60"
Inst3Quest10_Attain = "55"

Inst3Quest11_QuestID = "8966"
Inst3Quest11_Level = "60"
Inst3Quest11_Attain = "58"
Inst3Quest11PreQuest = "true"

Inst3Quest12_QuestID = "8989"
Inst3Quest12_Level = "60"
Inst3Quest12_Attain = "58"
Inst3Quest12PreQuest = "true"

Inst3Quest13_QuestID = "5306"
Inst3Quest13_Level = "60"
Inst3Quest13_Attain = "50"

Inst3Quest14_QuestID = "5103"
Inst3Quest14_Level = "60"
Inst3Quest14_Attain = "55"


Inst3Quest1_HORDE_QuestID = "4788"
Inst3Quest1_HORDE_Level = Inst3Quest1_Level
Inst3Quest1_HORDE_Attain = Inst3Quest1_Attain
Inst3Quest1PreQuest_HORDE = Inst3Quest1PreQuest

Inst3Quest2_HORDE_QuestID = "4729"
Inst3Quest2_HORDE_Level = Inst3Quest2_Level
Inst3Quest2_HORDE_Attain = Inst3Quest2_Attain

Inst3Quest3_HORDE_QuestID = "4862"
Inst3Quest3_HORDE_Level = Inst3Quest3_Level
Inst3Quest3_HORDE_Attain = Inst3Quest3_Attain

Inst3Quest4_HORDE_QuestID = "4866"
Inst3Quest4_HORDE_Level = Inst3Quest4_Level
Inst3Quest4_HORDE_Attain = Inst3Quest4_Attain

Inst3Quest5_HORDE_QuestID = "4724"
Inst3Quest5_HORDE_Level = "59"
Inst3Quest5_HORDE_Attain = "55"

Inst3Quest6_HORDE_QuestID = "4867"
Inst3Quest6_HORDE_Level = Inst3Quest6_Level
Inst3Quest6_HORDE_Attain = Inst3Quest6_Attain

Inst3Quest7_HORDE_QuestID = "4981"
Inst3Quest7_HORDE_Level = "59"
Inst3Quest7_HORDE_Attain = "55"

Inst3Quest8_HORDE_QuestID = "4982"
Inst3Quest8_HORDE_Level = "59"
Inst3Quest8_HORDE_Attain = "55"
Inst3Quest8FQuest_HORDE = "true"

Inst3Quest9_HORDE_QuestID = "4742"
Inst3Quest9_HORDE_Level = Inst3Quest9_Level
Inst3Quest9_HORDE_Attain = Inst3Quest9_Attain

Inst3Quest10_HORDE_QuestID = "4903"
Inst3Quest10_HORDE_Level = "60"
Inst3Quest10_HORDE_Attain = "55"

Inst3Quest11_HORDE_QuestID = "8966"
Inst3Quest11_HORDE_Level = Inst3Quest11_Level
Inst3Quest11_HORDE_Attain = Inst3Quest11_Attain
Inst3Quest11PreQuest_HORDE = Inst3Quest11PreQuest

Inst3Quest12_HORDE_QuestID = "8989"
Inst3Quest12_HORDE_Level = Inst3Quest12_Level
Inst3Quest12_HORDE_Attain = Inst3Quest12_Attain
Inst3Quest12PreQuest_HORDE = Inst3Quest12PreQuest

Inst3Quest13_HORDE_QuestID = "5306"
Inst3Quest13_HORDE_Level = Inst3Quest13_Level
Inst3Quest13_HORDE_Attain = Inst3Quest13_Attain

Inst3Quest14_HORDE_QuestID = "5103"
Inst3Quest14_HORDE_Level = Inst3Quest14_Level
Inst3Quest14_HORDE_Attain = Inst3Quest14_Attain



--------------- INST4 - Upper Blackrock Spire ---------------

Inst4Quest1_QuestID = "5160"
Inst4Quest1_Level = "60"
Inst4Quest1_Attain = "55"

Inst4Quest2_QuestID = "5047"
Inst4Quest2_Level = "60"
Inst4Quest2_Attain = "57"

Inst4Quest3_QuestID = "4734"
Inst4Quest3_Level = "60"
Inst4Quest3_Attain = "57"
Inst4Quest3PreQuest = "true"

Inst4Quest4_QuestID = "6821"
Inst4Quest4_Level = "60"
Inst4Quest4_Attain = "55"
Inst4Quest4PreQuest = "true"

Inst4Quest5_QuestID = "5102"
Inst4Quest5_Level = "60"
Inst4Quest5_Attain = "55"
Inst4Quest5PreQuest = "true"

Inst4Quest6_QuestID = "4764"
Inst4Quest6_Level = "60"
Inst4Quest6_Attain = "57"
Inst4Quest6PreQuest = "true"

Inst4Quest7_QuestID = "7761"
Inst4Quest7_Level = "60"
Inst4Quest7_Attain = "55"

Inst4Quest8_QuestID = "8994"
Inst4Quest8_Level = "60"
Inst4Quest8_Attain = "58"
Inst4Quest8PreQuest = "true"

Inst4Quest9_QuestID = "8995"
Inst4Quest9_Level = "60"
Inst4Quest9_Attain = "58"
Inst4Quest9FQuest = "true"

Inst4Quest10_QuestID = "5127"
Inst4Quest10_Level = "60"
Inst4Quest10_Attain = "55"

Inst4Quest11_QuestID = "4735"
Inst4Quest11_Level = "60"
Inst4Quest11_Attain = "57"
Inst4Quest11PreQuest = "true"

Inst4Quest12_QuestID = "6502"
Inst4Quest12_Level = "60"
Inst4Quest12_Attain = "50"
Inst4Quest12PreQuest = "true"


Inst4Quest1_HORDE_QuestID = "5160"
Inst4Quest1_HORDE_Level = Inst4Quest1_Level
Inst4Quest1_HORDE_Attain = Inst4Quest1_Attain

Inst4Quest2_HORDE_QuestID = "5047"
Inst4Quest2_HORDE_Level = Inst4Quest2_Level
Inst4Quest2_HORDE_Attain = Inst4Quest2_Attain

Inst4Quest3_HORDE_QuestID = "4734"
Inst4Quest3_HORDE_Level = Inst4Quest3_Level
Inst4Quest3_HORDE_Attain = Inst4Quest3_Attain
Inst4Quest3PreQuest_HORDE = Inst4Quest3PreQuest

Inst4Quest4_HORDE_QuestID = "6821"
Inst4Quest4_HORDE_Level = Inst4Quest4_Level
Inst4Quest4_HORDE_Attain = Inst4Quest4_Attain
Inst4Quest4PreQuest_HORDE = Inst4Quest4PreQuest

Inst4Quest5_HORDE_QuestID = "4768"
Inst4Quest5_HORDE_Level = "60"
Inst4Quest5_HORDE_Attain = "57"
Inst4Quest5PreQuest_HORDE = "true"

Inst4Quest6_HORDE_QuestID = "4974"
Inst4Quest6_HORDE_Level = "60"
Inst4Quest6_HORDE_Attain = "55"
Inst4Quest6PreQuest_HORDE = "true"

Inst4Quest7_HORDE_QuestID = "6569"
Inst4Quest7_HORDE_Level = "60"
Inst4Quest7_HORDE_Attain = "55"
Inst4Quest7FQuest_HORDE = "true"

Inst4Quest8_HORDE_QuestID = "6602"
Inst4Quest8_HORDE_Level = "60"
Inst4Quest8_HORDE_Attain = "55"
Inst4Quest8FQuest_HORDE = "true"

Inst4Quest9_HORDE_QuestID = "7761"
Inst4Quest9_HORDE_Level = Inst4Quest7_Level
Inst4Quest9_HORDE_Attain = Inst4Quest7_Attain

Inst4Quest10_HORDE_QuestID = "8994"
Inst4Quest10_HORDE_Level = Inst4Quest8_Level
Inst4Quest10_HORDE_Attain = Inst4Quest8_Attain

Inst4Quest11_HORDE_QuestID = "8995"
Inst4Quest11_HORDE_Level = Inst4Quest9_Level
Inst4Quest11_HORDE_Attain = Inst4Quest9_Attain

Inst4Quest12_HORDE_QuestID = "5127"
Inst4Quest12_HORDE_Level = Inst4Quest10_Level
Inst4Quest12_HORDE_Attain = Inst4Quest10_Attain

Inst4Quest13_HORDE_QuestID = "4735"
Inst4Quest13_HORDE_Level = Inst4Quest11_Level
Inst4Quest13_HORDE_Attain = Inst4Quest11_Attain
Inst4Quest13PreQuest_HORDE = Inst4Quest11PreQuest



--------------- INST5 - Deadmines ---------------

Inst5Quest1_QuestID = "214"
Inst5Quest1_Level = "17"
Inst5Quest1_Attain = "14"
Inst5Quest1PreQuest = "true"

Inst5Quest2_QuestID = "168"
Inst5Quest2_Level = "18"
Inst5Quest2_Attain = "14"

Inst5Quest3_QuestID = "167"
Inst5Quest3_Level = "20"
Inst5Quest3_Attain = "15"

Inst5Quest4_QuestID = "2040"
Inst5Quest4_Level = "20"
Inst5Quest4_Attain = "15"
Inst5Quest4PreQuest = "true"

Inst5Quest5_QuestID = "166"
Inst5Quest5_Level = "22"
Inst5Quest5_Attain = "14"
Inst5Quest5PreQuest = "true"

Inst5Quest6_QuestID = "1654"
Inst5Quest6_Level = "22"
Inst5Quest6_Attain = "20"
Inst5Quest6PreQuest = "true"

Inst5Quest7_QuestID = "373"
Inst5Quest7_Level = "22"
Inst5Quest7_Attain = "16"



--------------- INST6 - Gnomeregan ---------------

Inst6Quest1_QuestID = "2922"
Inst6Quest1_Level = "26"
Inst6Quest1_Attain = "20"
Inst6Quest1PreQuest = "true"

Inst6Quest2_QuestID = "2926"
Inst6Quest2_Level = "27"
Inst6Quest2_Attain = "20"
Inst6Quest2PreQuest = "true"

Inst6Quest3_QuestID = "2962"
Inst6Quest3_Level = "30"
Inst6Quest3_Attain = "20"
Inst6Quest3FQuest = "true"

Inst6Quest4_QuestID = "2928"
Inst6Quest4_Level = "30"
Inst6Quest4_Attain = "20"

Inst6Quest5_QuestID = "2924"
Inst6Quest5_Level = "30"
Inst6Quest5_Attain = "24"
Inst6Quest5PreQuest = "true"

Inst6Quest6_QuestID = "2930"
Inst6Quest6_Level = "30"
Inst6Quest6_Attain = "25"
Inst6Quest6PreQuest = "true"

Inst6Quest7_QuestID = "2904"
Inst6Quest7_Level = "30"
Inst6Quest7_Attain = "20"

Inst6Quest8_QuestID = "2929"
Inst6Quest8_Level = "35"
Inst6Quest8_Attain = "25"

Inst6Quest9_QuestID = "2945"
Inst6Quest9_Level = "34"
Inst6Quest9_Attain = "28"

Inst6Quest10_QuestID = "2947"
Inst6Quest10_Level = "34"
Inst6Quest10_Attain = "28"
Inst6Quest10FQuest = "true"

Inst6Quest11_QuestID = "2951"
Inst6Quest11_Level = "30"
Inst6Quest11_Attain = "25"



Inst6Quest1_HORDE_QuestID = "2843"
Inst6Quest1_HORDE_Level = "35"
Inst6Quest1_HORDE_Attain = "20"
Inst6Quest1PreQuest_HORDE = "true"

Inst6Quest2_HORDE_QuestID = "2904"
Inst6Quest2_HORDE_Level = Inst6Quest7_Level
Inst6Quest2_HORDE_Attain = Inst6Quest7_Attain

Inst6Quest3_HORDE_QuestID = "2841"
Inst6Quest3_HORDE_Level = "35"
Inst6Quest3_HORDE_Attain = "25"

Inst6Quest4_HORDE_QuestID = "2945"
Inst6Quest4_HORDE_Level = Inst6Quest9_Level
Inst6Quest4_HORDE_Attain = Inst6Quest9_Attain

Inst6Quest5_HORDE_QuestID = "2949"
Inst6Quest5_HORDE_Level = "34"
Inst6Quest5_HORDE_Attain = "28"
Inst6Quest5FQuest_HORDE = "true"

Inst6Quest6_HORDE_QuestID = "2951"
Inst6Quest6_HORDE_Level = "30"
Inst6Quest6_HORDE_Attain = "25"



--------------- INST7 - SM: Library  ---------------

Inst7Quest1_QuestID = "1050"
Inst7Quest1_Level = "38"
Inst7Quest1_Attain = "28"

Inst7Quest2_QuestID = "1951"
Inst7Quest2_Level = "40"
Inst7Quest2_Attain = "30"
Inst7Quest2PreQuest = "true"

Inst7Quest3_QuestID = "1053"
Inst7Quest3_Level = "40"
Inst7Quest3_Attain = "34"
Inst7Quest3PreQuest = "true"


Inst7Quest1_HORDE_QuestID = "1113"
Inst7Quest1_HORDE_Level = "33"
Inst7Quest1_HORDE_Attain = "30"
Inst7Quest1PreQuest_HORDE = "true"

Inst7Quest2_HORDE_QuestID = "1160"
Inst7Quest2_HORDE_Level = "36"
Inst7Quest2_HORDE_Attain = "25"
Inst7Quest2PreQuest_HORDE = "true"

Inst7Quest3_HORDE_QuestID = "1049"
Inst7Quest3_HORDE_Level = "38"
Inst7Quest3_HORDE_Attain = "28"

Inst7Quest4_HORDE_QuestID = "1951"
Inst7Quest4_HORDE_Level = Inst7Quest2_Level
Inst7Quest4_HORDE_Attain = Inst7Quest2_Attain
Inst7Quest4PreQuest_HORDE = Inst7Quest2_PreQuest

Inst7Quest5_HORDE_QuestID = "1048"
Inst7Quest5_HORDE_Level = "42"
Inst7Quest5_HORDE_Attain = "33"



--------------- INST8 - SM: Armory ---------------

Inst8Quest1_QuestID = "1053"
Inst8Quest1_Level = Inst7Quest3_Level
Inst8Quest1_Attain = Inst7Quest3_Attain
Inst8Quest1PreQuest = Inst7Quest3PreQuest


Inst8Quest1_HORDE_QuestID = "1113"
Inst8Quest1_HORDE_Level = Inst7Quest1_HORDE_Level
Inst8Quest1_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst8Quest1PreQuest_HORDE = Inst7Quest1Prequest_HORDE

Inst8Quest2_HORDE_QuestID = "1048"
Inst8Quest2_HORDE_Level = Inst7Quest5_HORDE_Level
Inst8Quest2_HORDE_Attain = Inst7Quest5_HORDE_Attain



--------------- INST9 - SM: Cathedral ---------------

Inst9Quest1_QuestID = "1053"
Inst9Quest1_Level = Inst7Quest3_Level
Inst9Quest1_Attain = Inst7Quest3_Attain
Inst9Quest1PreQuest = Inst7Quest3PreQuest


Inst9Quest1_HORDE_QuestID = "1113"
Inst9Quest1_HORDE_Level = Inst7Quest1_HORDE_Level
Inst9Quest1_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst9Quest1PreQuest_HORDE = Inst7Quest1Prequest_HORDE

Inst9Quest2_HORDE_QuestID = "1048"
Inst9Quest2_HORDE_Level = Inst7Quest5_HORDE_Level
Inst9Quest2_HORDE_Attain = Inst7Quest5_HORDE_Attain



--------------- INST10 - SM: Graveyard ---------------

Inst10Quest1_HORDE_QuestID = "1051"
Inst10Quest1_HORDE_Level = "33"
Inst10Quest1_HORDE_Attain = "25"

Inst10Quest2_HORDE_QuestID = "1113"
Inst10Quest2_HORDE_Level = Inst7Quest1_HORDE_Level
Inst10Quest2_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst10Quest2PreQuest_HORDE = Inst7Quest1Prequest_HORDE



--------------- INST11 - Scholomance ---------------

Inst11Quest1_QuestID = "5529"
Inst11Quest1_Level = "58"
Inst11Quest1_Attain = "55"

Inst11Quest2_QuestID = "5582"
Inst11Quest2_Level = "58"
Inst11Quest2_Attain = "55"
Inst11Quest2FQuest = "true"

Inst11Quest3_QuestID = "5382"
Inst11Quest3_Level = "60"
Inst11Quest3_Attain = "55"

Inst11Quest4_QuestID = "5515"
Inst11Quest4_Level = "60"
Inst11Quest4_Attain = "55"
Inst11Quest4FQuest = "true"

Inst11Quest5_QuestID = "5384"
Inst11Quest5_Level = "60"
Inst11Quest5_Attain = "55"
Inst11Quest5FQuest = "true"

Inst11Quest6_QuestID = "5466"
Inst11Quest6_Level = "60"
Inst11Quest6_Attain = "57"
Inst11Quest6PreQuest = "true"

Inst11Quest7_QuestID = "5343"
Inst11Quest7_Level = "60"
Inst11Quest7_Attain = "52"

Inst11Quest8_QuestID = "4771"
Inst11Quest8_Level = "60"
Inst11Quest8_Attain = "57"
Inst11Quest8PreQuest = "true"

Inst11Quest9_QuestID = "7629"
Inst11Quest9_Level = "60"
Inst11Quest9_Attain = "60"
Inst11Quest9PreQuest = "true"

Inst11Quest10_QuestID = "8969"
Inst11Quest10_Level = "60"
Inst11Quest10_Attain = "58"
Inst11Quest10PreQuest = "true"

Inst11Quest11_QuestID = "8992"
Inst11Quest11_Level = "60"
Inst11Quest11_Attain = "58"
Inst11Quest11PreQuest = "true"

Inst11Quest12_QuestID = "7647"
Inst11Quest12_Level = "60"
Inst11Quest12_Attain = "60"
Inst11Quest12PreQuest = "true"


Inst11Quest1_HORDE_QuestID = "5529"
Inst11Quest1_HORDE_Level = Inst11Quest1_Level
Inst11Quest1_HORDE_Attain = Inst11Quest1_Attain

Inst11Quest2_HORDE_QuestID = "5582"
Inst11Quest2_HORDE_Level = Inst11Quest2_Level
Inst11Quest2_HORDE_Attain = Inst11Quest2_Attain
Inst11Quest2FQuest_HORDE = Inst11Quest2FQuest

Inst11Quest3_HORDE_QuestID = "5382"
Inst11Quest3_HORDE_Level = Inst11Quest3_Level
Inst11Quest3_HORDE_Attain = Inst11Quest3_Attain

Inst11Quest4_HORDE_QuestID = "5515"
Inst11Quest4_HORDE_Level = Inst11Quest4_Level
Inst11Quest4_HORDE_Attain = Inst11Quest4_Attain
Inst11Quest4FQuest_HORDE = Inst11Quest4FQuest

Inst11Quest5_HORDE_QuestID = "5384"
Inst11Quest5_HORDE_Level = Inst11Quest5_Level
Inst11Quest5_HORDE_Attain = Inst11Quest5_Attain
Inst11Quest5FQuest_HORDE = Inst11Quest5FQuest

Inst11Quest6_HORDE_QuestID = "5466"
Inst11Quest6_HORDE_Level = Inst11Quest6_Level
Inst11Quest6_HORDE_Attain = Inst11Quest6_Attain
Inst11Quest6PreQuest_HORDE = Inst11Quest6PreQuest

Inst11Quest7_HORDE_QuestID = "5341"
Inst11Quest7_HORDE_Level = "60"
Inst11Quest7_HORDE_Attain = "52"

Inst11Quest8_HORDE_QuestID = "4771"
Inst11Quest8_HORDE_Level = Inst11Quest8_Level
Inst11Quest8_HORDE_Attain = Inst11Quest8_Attain
Inst11Quest8PreQuest_HORDE = Inst11Quest8PreQuest

Inst11Quest9_HORDE_QuestID = "7629"
Inst11Quest9_HORDE_Level = Inst11Quest9_Level
Inst11Quest9_HORDE_Attain = Inst11Quest9_Attain
Inst11Quest9PreQuest_HORDE = Inst11Quest9PreQuest

Inst11Quest10_HORDE_QuestID = "8969"
Inst11Quest10_HORDE_Level = Inst11Quest10_Level
Inst11Quest10_HORDE_Attain = Inst11Quest10_Attain
Inst11Quest10PreQuest_HORDE = Inst11Quest10PreQuest

Inst11Quest11_HORDE_QuestID = "8258"
Inst11Quest11_HORDE_Level = "60"
Inst11Quest11_HORDE_Attain = "58"
Inst11Quest11PreQuest_HORDE = "true"

Inst11Quest12_HORDE_QuestID = "8992"
Inst11Quest12_HORDE_Level = Inst11Quest11_Level
Inst11Quest12_HORDE_Attain = Inst11Quest11_Attain
Inst11Quest12PreQuest_HORDE = Inst11Quest11PreQuest



--------------- INST12 - Shadowfang Keep ---------------

Inst12Quest1_QuestID = "1654"
Inst12Quest1_Level = "22"
Inst12Quest1_Attain = "20"
Inst12Quest1PreQuest = "true"

Inst12Quest2_QuestID = "1740"
Inst12Quest2_Level = "25"
Inst12Quest2_Attain = "20"


Inst12Quest1_HORDE_QuestID = "1098"
Inst12Quest1_HORDE_Level = "25"
Inst12Quest1_HORDE_Attain = "18"

Inst12Quest2_HORDE_QuestID = "1013"
Inst12Quest2_HORDE_Level = "26"
Inst12Quest2_HORDE_Attain = "16"

Inst12Quest3_HORDE_QuestID = "1014"
Inst12Quest3_HORDE_Level = "27"
Inst12Quest3_HORDE_Attain = "18"

Inst12Quest4_HORDE_QuestID = "1740"
Inst12Quest4_HORDE_Level = Inst12Quest2_Level
Inst12Quest4_HORDE_Attain = Inst12Quest2_Attain



--------------- INST13 - The Stockade ---------------

Inst13Quest1_QuestID = "386"
Inst13Quest1_Level = "25"
Inst13Quest1_Attain = "22"

Inst13Quest2_QuestID = "377"
Inst13Quest2_Level = "26"
Inst13Quest2_Attain = "22"

Inst13Quest3_QuestID = "387"
Inst13Quest3_Level = "26"
Inst13Quest3_Attain = "22"

Inst13Quest4_QuestID = "388"
Inst13Quest4_Level = "26"
Inst13Quest4_Attain = "22"

Inst13Quest5_QuestID = "378"
Inst13Quest5_Level = "27"
Inst13Quest5_Attain = "22"
Inst13Quest5PreQuest = "true"

Inst13Quest6_QuestID = "391"
Inst13Quest6_Level = "29"
Inst13Quest6_Attain = "16"
Inst13Quest6PreQuest = "true"



--------------- INST14 - Stratholme ---------------

Inst14Quest1_QuestID = "5212"
Inst14Quest1_Level = "60"
Inst14Quest1_Attain = "55"

Inst14Quest2_QuestID = "5213"
Inst14Quest2_Level = "60"
Inst14Quest2_Attain = "55"
Inst14Quest2FQuest = "true"

Inst14Quest3_QuestID = "5243"
Inst14Quest3_Level = "60"
Inst14Quest3_Attain = "55"

Inst14Quest4_QuestID = "5214"
Inst14Quest4_Level = "60"
Inst14Quest4_Attain = "55"

Inst14Quest5_QuestID = "5282"
Inst14Quest5_Level = "60"
Inst14Quest5_Attain = "55"
Inst14Quest5PreQuest = "true"

Inst14Quest6_QuestID = "5848"
Inst14Quest6_Level = "60"
Inst14Quest6_Attain = "52"
Inst14Quest6PreQuest = "true"

Inst14Quest7_QuestID = "5463"
Inst14Quest7_Level = "60"
Inst14Quest7_Attain = "57"
Inst14Quest7PreQuest = "true"

Inst14Quest8_QuestID = "5125"
Inst14Quest8_Level = "60"
Inst14Quest8_Attain = "56"

Inst14Quest9_QuestID = "5251"
Inst14Quest9_Level = "60"
Inst14Quest9_Attain = "55"

Inst14Quest10_QuestID = "5262"
Inst14Quest10_Level = "60"
Inst14Quest10_Attain = "55"
Inst14Quest10FQuest = "true"

Inst14Quest11_QuestID = "5263"
Inst14Quest11_Level = "60"
Inst14Quest11_Attain = "55"
Inst14Quest11FQuest = "true"

Inst14Quest12_QuestID = "8945"
Inst14Quest12_Level = "60"
Inst14Quest12_Attain = "58"
Inst14Quest12PreQuest = "true"

Inst14Quest13_QuestID = "8968"
Inst14Quest13_Level = "60"
Inst14Quest13_Attain = "58"
Inst14Quest13PreQuest = "true"

Inst14Quest14_QuestID = "8991"
Inst14Quest14_Level = "60"
Inst14Quest14_Attain = "58"
Inst14Quest14PreQuest = "true"

Inst14Quest15_QuestID = "9257"
Inst14Quest15_Level = "60"
Inst14Quest15_Attain = "60"
Inst14Quest15PreQuest = "true"

Inst14Quest16_QuestID = "5307"
Inst14Quest16_Level = "60"
Inst14Quest16_Attain = "50"

Inst14Quest17_QuestID = "5305"
Inst14Quest17_Level = "60"
Inst14Quest17_Attain = "50"

Inst14Quest18_QuestID = "7622"
Inst14Quest18_Level = "60"
Inst14Quest18_Attain = "60"
Inst14Quest18PreQuest = "true"


Inst14Quest1_HORDE_QuestID = "5212"
Inst14Quest1_HORDE_Level = Inst14Quest1_Level
Inst14Quest1_HORDE_Attain = Inst14Quest1_Attain

Inst14Quest2_HORDE_QuestID = "5213"
Inst14Quest2_HORDE_Level = Inst14Quest2_Level
Inst14Quest2_HORDE_Attain = Inst14Quest2_Attain
Inst14Quest2FQuest_HORDE = Inst14Quest2FQuest

Inst14Quest3_HORDE_QuestID = "5243"
Inst14Quest3_HORDE_Level = Inst14Quest3_Level
Inst14Quest3_HORDE_Attain = Inst14Quest3_Attain

Inst14Quest4_HORDE_QuestID = "5214"
Inst14Quest4_HORDE_Level = Inst14Quest4_Level
Inst14Quest4_HORDE_Attain = Inst14Quest4_Attain

Inst14Quest5_HORDE_QuestID = "5282"
Inst14Quest5_HORDE_Level = Inst14Quest5_Level
Inst14Quest5_HORDE_Attain = Inst14Quest5_Attain
Inst14Quest5PreQuest_HORDE = Inst14Quest5PreQuest

Inst14Quest6_HORDE_QuestID = "5848"
Inst14Quest6_HORDE_Level = Inst14Quest6_Level
Inst14Quest6_HORDE_Attain = Inst14Quest6_Attain
Inst14Quest6PreQuest_HORDE = Inst14Quest6PreQuest

Inst14Quest7_HORDE_QuestID = "5463"
Inst14Quest7_HORDE_Level = Inst14Quest7_Level
Inst14Quest7_HORDE_Attain = Inst14Quest7_Attain
Inst14Quest7PreQuest_HORDE = Inst14Quest7PreQuest

Inst14Quest8_HORDE_QuestID = "5125"
Inst14Quest8_HORDE_Level = Inst14Quest8_Level
Inst14Quest8_HORDE_Attain = Inst14Quest8_Attain

Inst14Quest9_HORDE_QuestID = "5251"
Inst14Quest9_HORDE_Level = Inst14Quest9_Level
Inst14Quest9_HORDE_Attain = Inst14Quest9_Attain

Inst14Quest10_HORDE_QuestID = "5262"
Inst14Quest10_HORDE_Level = Inst14Quest10_Level
Inst14Quest10_HORDE_Attain = Inst14Quest10_Attain
Inst14Quest10FQuest_HORDE = Inst14Quest10FQuest

Inst14Quest11_HORDE_QuestID = "5263"
Inst14Quest11_HORDE_Level = Inst14Quest11_Level
Inst14Quest11_HORDE_Attain = Inst14Quest11_Attain
Inst14Quest11FQuest_HORDE = Inst14Quest11FQuest

Inst14Quest12_HORDE_QuestID = "8945"
Inst14Quest12_HORDE_Level = Inst14Quest12_Level
Inst14Quest12_HORDE_Attain = Inst14Quest12_Attain
Inst14Quest12PreQuest_HORDE = Inst14Quest12PreQuest

Inst14Quest13_HORDE_QuestID = "8968"
Inst14Quest13_HORDE_Level = Inst14Quest13_Level
Inst14Quest13_HORDE_Attain = Inst14Quest13_Attain
Inst14Quest13PreQuest_HORDE = Inst14Quest13PreQuest

Inst14Quest14_HORDE_QuestID = "8991"
Inst14Quest14_HORDE_Level = Inst14Quest14_Level
Inst14Quest14_HORDE_Attain = Inst14Quest14_Attain
Inst14Quest14PreQuest_HORDE = Inst14Quest14PreQuest

Inst14Quest15_HORDE_QuestID = "9257"
Inst14Quest15_HORDE_Level = Inst14Quest15_Level
Inst14Quest15_HORDE_Attain = Inst14Quest15_Attain
Inst14Quest15PreQuest_HORDE = Inst14Quest15PreQuest

Inst14Quest16_HORDE_QuestID = "5307"
Inst14Quest16_HORDE_Level = Inst14Quest16_Level
Inst14Quest16_HORDE_Attain = Inst14Quest16_Attain

Inst14Quest17_HORDE_QuestID = "5305"
Inst14Quest17_HORDE_Level = Inst14Quest17_Level
Inst14Quest17_HORDE_Attain = Inst14Quest17_Attain

Inst14Quest18_HORDE_QuestID = "6163"
Inst14Quest18_HORDE_Level = "60"
Inst14Quest18_HORDE_Attain = "56"
Inst14Quest18PreQuest_HORDE = "true"

Inst14Quest19_HORDE_QuestID = "7622"
Inst14Quest19_HORDE_Level = Inst14Quest18_Level
Inst14Quest19_HORDE_Attain = Inst14Quest18_Attain
Inst14Quest19PreQuest_HORDE = Inst14Quest18PreQuest



--------------- INST15 - Sunken Temple ---------------

Inst15Quest1_QuestID = "1475"
Inst15Quest1_Level = "50"
Inst15Quest1_Attain = "38"
Inst15Quest1PreQuest = "true"

Inst15Quest2_QuestID = "3445"
Inst15Quest2_Level = "51"
Inst15Quest2_Attain = "46"

Inst15Quest3_QuestID = "3446"
Inst15Quest3_Level = "51"
Inst15Quest3_Attain = "46"
Inst15Quest3PreQuest = "true"

Inst15Quest4_QuestID = "3447"
Inst15Quest4_Level = "51"
Inst15Quest4_Attain = "46"
Inst15Quest4PreQuest = "true"

Inst15Quest5_QuestID = "4143"
Inst15Quest5_Level = "52"
Inst15Quest5_Attain = "47"
Inst15Quest5PreQuest = "true"

Inst15Quest6_QuestID = "3528"
Inst15Quest6_Level = "53"
Inst15Quest6_Attain = "40"
Inst15Quest6PreQuest = "true"

Inst15Quest7_QuestID = "1446"
Inst15Quest7_Level = "53"
Inst15Quest7_Attain = "38"

Inst15Quest8_QuestID = "3373"
Inst15Quest8_Level = "55"
Inst15Quest8_Attain = "48"

Inst15Quest9_QuestID = "8422"
Inst15Quest9_Level = "52"
Inst15Quest9_Attain = "50"
Inst15Quest9PreQuest = "true"

Inst15Quest10_QuestID = "8425"
Inst15Quest10_Level = "52"
Inst15Quest10_Attain = "50"
Inst15Quest10PreQuest = "true"

Inst15Quest11_QuestID = "9053"
Inst15Quest11_Level = "52"
Inst15Quest11_Attain = "50"
Inst15Quest11PreQuest = "true"

Inst15Quest12_QuestID = "8232"
Inst15Quest12_Level = "52"
Inst15Quest12_Attain = "50"
Inst15Quest12PreQuest = "true"

Inst15Quest13_QuestID = "8253"
Inst15Quest13_Level = "52"
Inst15Quest13_Attain = "50"
Inst15Quest13PreQuest = "true"

Inst15Quest14_QuestID = "8257"
Inst15Quest14_Level = "52"
Inst15Quest14_Attain = "50"
Inst15Quest14PreQuest = "true"

Inst15Quest15_QuestID = "8236"
Inst15Quest15_Level = "52"
Inst15Quest15_Attain = "50"
Inst15Quest15PreQuest = "true"

Inst15Quest16_QuestID = "8418"
Inst15Quest16_Level = "52"
Inst15Quest16_Attain = "50"
Inst15Quest16PreQuest = "true"


Inst15Quest1_HORDE_QuestID = "1445"
Inst15Quest1_HORDE_Level = "50"
Inst15Quest1_HORDE_Attain = "38"
Inst15Quest1PreQuest_HORDE = "true"

Inst15Quest2_HORDE_QuestID = "3380"
Inst15Quest2_HORDE_Level = "51"
Inst15Quest2_HORDE_Attain = "46"

Inst15Quest3_HORDE_QuestID = "3446"
Inst15Quest3_HORDE_Level = Inst15Quest3_Level
Inst15Quest3_HORDE_Attain = Inst15Quest3_Attain
Inst15Quest3PreQuest_HORDE = Inst15Quest3PreQuest

Inst15Quest4_HORDE_QuestID = "3447"
Inst15Quest4_HORDE_Level = Inst15Quest4_Level
Inst15Quest4_HORDE_Attain = Inst15Quest4_Attain
Inst15Quest4PreQuest_HORDE = Inst15Quest4PreQuest

Inst15Quest5_HORDE_QuestID = "4146"
Inst15Quest5_HORDE_Level = "52"
Inst15Quest5_HORDE_Attain = "47"
Inst15Quest5PreQuest_HORDE = "true"

Inst15Quest6_HORDE_QuestID = "3528"
Inst15Quest6_HORDE_Level = Inst15Quest6_Level
Inst15Quest6_HORDE_Attain = Inst15Quest6_Attain
Inst15Quest6PreQuest_HORDE = Inst15Quest6PreQuest

Inst15Quest7_HORDE_QuestID = "1446"
Inst15Quest7_HORDE_Level = Inst15Quest7_Level
Inst15Quest7_HORDE_Attain = Inst15Quest7_Attain

Inst15Quest8_HORDE_QuestID = "3373"
Inst15Quest8_HORDE_Level = Inst15Quest8_Level
Inst15Quest8_HORDE_Attain = Inst15Quest8_Attain

Inst15Quest9_HORDE_QuestID = "8422"
Inst15Quest9_HORDE_Level = Inst15Quest9_Level
Inst15Quest9_HORDE_Attain = Inst15Quest9_Attain
Inst15Quest9PreQuest_HORDE = Inst15Quest9PreQuest

Inst15Quest10_HORDE_QuestID = "8425"
Inst15Quest10_HORDE_Level = Inst15Quest10_Level
Inst15Quest10_HORDE_Attain = Inst15Quest10_Attain
Inst15Quest10PreQuest_HORDE = Inst15Quest10PreQuest

Inst15Quest11_HORDE_QuestID = "9053"
Inst15Quest11_HORDE_Level = Inst15Quest11_Level
Inst15Quest11_HORDE_Attain = Inst15Quest11_Attain
Inst15Quest11PreQuest_HORDE = Inst15Quest11PreQuest

Inst15Quest12_HORDE_QuestID = "8232"
Inst15Quest12_HORDE_Level = Inst15Quest12_Level
Inst15Quest12_HORDE_Attain = Inst15Quest12_Attain
Inst15Quest12PreQuest_HORDE = Inst15Quest12PreQuest

Inst15Quest13_HORDE_QuestID = "8253"
Inst15Quest13_HORDE_Level = Inst15Quest13_Level
Inst15Quest13_HORDE_Attain = Inst15Quest13_Attain
Inst15Quest13PreQuest_HORDE = Inst15Quest13PreQuest

Inst15Quest14_HORDE_QuestID = "8257"
Inst15Quest14_HORDE_Level = Inst15Quest14_Level
Inst15Quest14_HORDE_Attain = Inst15Quest14_Attain
Inst15Quest14PreQuest_HORDE = Inst15Quest14PreQuest

Inst15Quest15_HORDE_QuestID = "8236"
Inst15Quest15_HORDE_Level = Inst15Quest15_Level
Inst15Quest15_HORDE_Attain = Inst15Quest15_Attain
Inst15Quest15PreQuest_HORDE = Inst15Quest15PreQuest

Inst15Quest16_HORDE_QuestID = "8413"
Inst15Quest16_HORDE_Level = "52"
Inst15Quest16_HORDE_Attain = "50"
Inst15Quest16PreQuest_HORDE = "true"



--------------- INST16 - Uldaman ---------------

Inst16Quest1_QuestID = "721"
Inst16Quest1_Level = "35"
Inst16Quest1_Attain = "35"
Inst16Quest1PreQuest = "true"

Inst16Quest2_QuestID = "722"
Inst16Quest2_Level = "40"
Inst16Quest2_Attain = "35"
Inst16Quest2FQuest = "true"

Inst16Quest3_QuestID = "1139"
Inst16Quest3_Level = "45"
Inst16Quest3_Attain = "35"
Inst16Quest3FQuest = "true"

Inst16Quest4_QuestID = "2418"
Inst16Quest4_Level = "36"
Inst16Quest4_Attain = "30"

Inst16Quest5_QuestID = "704"
Inst16Quest5_Level = "38"
Inst16Quest5_Attain = "30"
Inst16Quest5PreQuest = "true"

Inst16Quest6_QuestID = "709"
Inst16Quest6_Level = "40"
Inst16Quest6_Attain = "30"

Inst16Quest7_QuestID = "2398"
Inst16Quest7_Level = "40"
Inst16Quest7_Attain = "35"

Inst16Quest8_QuestID = "2240"
Inst16Quest8_Level = "40"
Inst16Quest8_Attain = "35"
Inst16Quest8FQuest = "true"

Inst16Quest9_QuestID = "2198"
Inst16Quest9_Level = "41"
Inst16Quest9_Attain = "37"

Inst16Quest10_QuestID = "2200"
Inst16Quest10_Level = "42"
Inst16Quest10_Attain = "37"
Inst16Quest10FQuest = "true"

Inst16Quest11_QuestID = "2201"
Inst16Quest11_Level = "43"
Inst16Quest11_Attain = "37"
Inst16Quest11FQuest = "true"

Inst16Quest12_QuestID = "2204"
Inst16Quest12_Level = "44"
Inst16Quest12_Attain = "37"
Inst16Quest12FQuest = "true"

Inst16Quest13_QuestID = "17"
Inst16Quest13_Level = "42"
Inst16Quest13_Attain = "38"
Inst16Quest13PreQuest = "true"

Inst16Quest14_QuestID = "1360"
Inst16Quest14_Level = "43"
Inst16Quest14_Attain = "33"

Inst16Quest15_QuestID = "2278"
Inst16Quest15_Level = "47"
Inst16Quest15_Attain = "40"

Inst16Quest16_QuestID = "1956"
Inst16Quest16_Level = "40"
Inst16Quest16_Attain = "35"
Inst16Quest16PreQuest = "true"

Inst16Quest17_QuestID = "1192"
Inst16Quest17_Level = "42"
Inst16Quest17_Attain = "29"
Inst16Quest17PreQuest = "true"


Inst16Quest1_HORDE_QuestID = "2418"
Inst16Quest1_HORDE_Level = Inst16Quest4_Level
Inst16Quest1_HORDE_Attain = Inst16Quest4_Attain

Inst16Quest2_HORDE_QuestID = "709"
Inst16Quest2_HORDE_Level = Inst16Quest6_Level
Inst16Quest2_HORDE_Attain = Inst16Quest6_Attain

Inst16Quest3_HORDE_QuestID = "2283"
Inst16Quest3_HORDE_Level = "41"
Inst16Quest3_HORDE_Attain = "37"

Inst16Quest4_HORDE_QuestID = "2284"
Inst16Quest4_HORDE_Level = "41"
Inst16Quest4_HORDE_Attain = "37"
Inst16Quest4FQuest_HORDE = "true"

Inst16Quest5_HORDE_QuestID = "2318"
Inst16Quest5_HORDE_Level = "42"
Inst16Quest5_HORDE_Attain = "37"
Inst16Quest5FQuest_HORDE = "true"

Inst16Quest6_HORDE_QuestID = "2339"
Inst16Quest6_HORDE_Level = "44"
Inst16Quest6_HORDE_Attain = "37"
Inst16Quest6FQuest_HORDE = "true"

Inst16Quest7_HORDE_QuestID = "2202"
Inst16Quest7_HORDE_Level = "42"
Inst16Quest7_HORDE_Attain = "36"
Inst16Quest7PreQuest_HORDE = "true"

Inst16Quest8_HORDE_QuestID = "2342"
Inst16Quest8_HORDE_Level = "43"
Inst16Quest8_HORDE_Attain = "33"

Inst16Quest9_HORDE_QuestID = "2278"
Inst16Quest9_HORDE_Level = "47"
Inst16Quest9_HORDE_Attain = "40"

Inst16Quest10_HORDE_QuestID = "1956"
Inst16Quest10_HORDE_Level = Inst16Quest16_Level
Inst16Quest10_HORDE_Attain = Inst16Quest16_Attain
Inst16Quest10PreQuest_HORDE = Inst16Quest16PreQuest

Inst16Quest11_HORDE_QuestID = "1192"
Inst16Quest11_HORDE_Level = Inst16Quest17_Level
Inst16Quest11_HORDE_Attain = Inst16Quest17_Attain
Inst16Quest11PreQuest_HORDE = Inst16Quest17PreQuest



--------------- INST17 - Blackfathom Deeps ---------------

Inst17Quest1_QuestID = "971"
Inst17Quest1_Level = "23"
Inst17Quest1_Attain = "10"

Inst17Quest2_QuestID = "1275"
Inst17Quest2_Level = "24"
Inst17Quest2_Attain = "18"
Inst17Quest2PreQuest = "true"

Inst17Quest3_QuestID = "1198"
Inst17Quest3_Level = "24"
Inst17Quest3_Attain = "18"

Inst17Quest4_QuestID = "1200"
Inst17Quest4_Level = "27"
Inst17Quest4_Attain = "18"
Inst17Quest4FQuest = "true"

Inst17Quest5_QuestID = "1199"
Inst17Quest5_Level = "25"
Inst17Quest5_Attain = "20"

Inst17Quest6_QuestID = "1740"
Inst17Quest6_Level = Inst12Quest2_Level
Inst17Quest6_Attain = Inst12Quest2_Attain


Inst17Quest1_HORDE_QuestID = "6563"
Inst17Quest1_HORDE_Level = "22"
Inst17Quest1_HORDE_Attain = "17"
Inst17Quest1PreQuest_HORDE = "true"

Inst17Quest2_HORDE_QuestID = "6564"
Inst17Quest2_HORDE_Level = "22"
Inst17Quest2_HORDE_Attain = "17"

Inst17Quest3_HORDE_QuestID = "6921"
Inst17Quest3_HORDE_Level = "27"
Inst17Quest3_HORDE_Attain = "21"

Inst17Quest4_HORDE_QuestID = "6561"
Inst17Quest4_HORDE_Level = "27"
Inst17Quest4_HORDE_Attain = "18"

Inst17Quest5_HORDE_QuestID = "1740"
Inst17Quest5_HORDE_Level = Inst17Quest6_Level
Inst17Quest5_HORDE_Attain = Inst17Quest6_Attain



--------------- INST18 - Dire Maul East ---------------

Inst18Quest1_QuestID = "7441"
Inst18Quest1_Level = "58"
Inst18Quest1_Attain = "54"

Inst18Quest2_QuestID = "7488"
Inst18Quest2_Level = "57"
Inst18Quest2_Attain = "54"
Inst18Quest2PreQuest = "true"

Inst18Quest3_QuestID = "5526"
Inst18Quest3_Level = "60"
Inst18Quest3_Attain = "56"
Inst18Quest3PreQuest = "true"

Inst18Quest4_QuestID = "8967"
Inst18Quest4_Level = "60"
Inst18Quest4_Attain = "58"
Inst18Quest4PreQuest = "true"

Inst18Quest5_QuestID = "8990"
Inst18Quest5_Level = "60"
Inst18Quest5_Attain = "58"
Inst18Quest5PreQuest = "true"

Inst18Quest6_QuestID = "7581"
Inst18Quest6_Level = "60"
Inst18Quest6_Attain = "60"


Inst18Quest1_HORDE_QuestID = "7441"
Inst18Quest1_HORDE_Level = Inst18Quest1_Level
Inst18Quest1_HORDE_Attain = Inst18Quest1_Attain

Inst18Quest2_HORDE_QuestID = "7489"
Inst18Quest2_HORDE_Level = "57"
Inst18Quest2_HORDE_Attain = "54"
Inst18Quest2PreQuest_HORDE = "true"

Inst18Quest3_HORDE_QuestID = "5526"
Inst18Quest3_HORDE_Level = Inst18Quest3_Level
Inst18Quest3_HORDE_Attain = Inst18Quest3_Attain
Inst18Quest3PreQuest_HORDE = Inst18Quest3PreQuest

Inst18Quest4_HORDE_QuestID = "8967"
Inst18Quest4_HORDE_Level = Inst18Quest4_Level
Inst18Quest4_HORDE_Attain = Inst18Quest4_Attain
Inst18Quest4PreQuest_HORDE = Inst18Quest4PreQuest

Inst18Quest5_HORDE_QuestID = "8990"
Inst18Quest5_HORDE_Level = Inst18Quest5_Level
Inst18Quest5_HORDE_Attain = Inst18Quest5_Attain
Inst18Quest5PreQuest_HORDE = Inst18Quest5PreQuest

Inst18Quest6_HORDE_QuestID = "7581"
Inst18Quest6_HORDE_Level = Inst18Quest6_Level
Inst18Quest6_HORDE_Attain = Inst18Quest6_Attain



--------------- INST19 - Dire Maul North ---------------

Inst19Quest1_QuestID = "1193"
Inst19Quest1_Level = "60"
Inst19Quest1_Attain = "56"

Inst19Quest2_QuestID = "5518"
Inst19Quest2_Level = "60"
Inst19Quest2_Attain = "56"

Inst19Quest3_QuestID = "5525"
Inst19Quest3_Level = "60"
Inst19Quest3_Attain = "60"

Inst19Quest4_QuestID = "7703"
Inst19Quest4_Level = "60"
Inst19Quest4_Attain = "56"

Inst19Quest5_QuestID = "5528"
Inst19Quest5_Level = "60"
Inst19Quest5_Attain = "56"


Inst19Quest1_HORDE_QuestID = "1193"
Inst19Quest1_HORDE_Level = Inst19Quest1_Level
Inst19Quest1_HORDE_Attain = Inst19Quest1_Attain

Inst19Quest2_HORDE_QuestID = "5518"
Inst19Quest2_HORDE_Level = Inst19Quest2_Level
Inst19Quest2_HORDE_Attain = Inst19Quest2_Attain

Inst19Quest3_HORDE_QuestID = "5525"
Inst19Quest3_HORDE_Level = Inst19Quest3_Level
Inst19Quest3_HORDE_Attain = Inst19Quest3_Attain

Inst19Quest4_HORDE_QuestID = "7703"
Inst19Quest4_HORDE_Level = Inst19Quest4_Level
Inst19Quest4_HORDE_Attain = Inst19Quest4_Attain

Inst19Quest5_HORDE_QuestID = "5528"
Inst19Quest5_HORDE_Level = Inst19Quest5_Level
Inst19Quest5_HORDE_Attain = Inst19Quest5_Attain



--------------- INST20 - Dire Maul West ---------------

Inst20Quest1_QuestID = "7482"
Inst20Quest1_Level = "60"
Inst20Quest1_Attain = "54"

Inst20Quest2_QuestID = "7461"
Inst20Quest2_Level = "60"
Inst20Quest2_Attain = "56"

Inst20Quest3_QuestID = "7877"
Inst20Quest3_Level = "60"
Inst20Quest3_Attain = "56"
Inst20Quest3FQuest = "true"

Inst20Quest4_QuestID = "7631"
Inst20Quest4_Level = "60"
Inst20Quest4_Attain = "60"
Inst20Quest4PreQuest = "true"

Inst20Quest5_QuestID = "7506"
Inst20Quest5_Level = "60"
Inst20Quest5_Attain = "54"

Inst20Quest6_QuestID = "7503"
Inst20Quest6_Level = "60"
Inst20Quest6_Attain = "54"

Inst20Quest7_QuestID = "7500"
Inst20Quest7_Level = "60"
Inst20Quest7_Attain = "54"

Inst20Quest8_QuestID = "7501"
Inst20Quest8_Level = "60"
Inst20Quest8_Attain = "54"

Inst20Quest9_QuestID = "7504"
Inst20Quest9_Level = "60"
Inst20Quest9_Attain = "54"

Inst20Quest10_QuestID = "7498"
Inst20Quest10_Level = "60"
Inst20Quest10_Attain = "54"

Inst20Quest11_QuestID = "7502"
Inst20Quest11_Level = "60"
Inst20Quest11_Attain = "54"

Inst20Quest12_QuestID = "7499"
Inst20Quest12_Level = "60"
Inst20Quest12_Attain = "54"

Inst20Quest13_QuestID = "7484"
Inst20Quest13_Level = "60"
Inst20Quest13_Attain = "54"

Inst20Quest14_QuestID = "7485"
Inst20Quest14_Level = "60"
Inst20Quest14_Attain = "54"

Inst20Quest15_QuestID = "7483"
Inst20Quest15_Level = "60"
Inst20Quest15_Attain = "54"

Inst20Quest16_QuestID = "7507"
Inst20Quest16_Level = "60"
Inst20Quest16_Attain = "60"



Inst20Quest1_HORDE_QuestID = "7481"
Inst20Quest1_HORDE_Level = "60"
Inst20Quest1_HORDE_Attain = "54"

Inst20Quest2_HORDE_QuestID = "7461"
Inst20Quest2_HORDE_Level = Inst20Quest2_Level
Inst20Quest2_HORDE_Attain = Inst20Quest2_Attain

Inst20Quest3_HORDE_QuestID = "7877"
Inst20Quest3_HORDE_Level = Inst20Quest3_Level
Inst20Quest3_HORDE_Attain = Inst20Quest3_Attain
Inst20Quest3FQuest_HORDE = "true"

Inst20Quest4_HORDE_QuestID = "7631"
Inst20Quest4_HORDE_Level = Inst20Quest4_Level
Inst20Quest4_HORDE_Attain = Inst20Quest4_Attain
Inst20Quest4PreQuest_HORDE = "true"

Inst20Quest5_HORDE_QuestID = "7506"
Inst20Quest5_HORDE_Level = Inst20Quest5_Level
Inst20Quest5_HORDE_Attain = Inst20Quest5_Attain

Inst20Quest6_HORDE_QuestID = "7503"
Inst20Quest6_HORDE_Level = Inst20Quest6_Level
Inst20Quest6_HORDE_Attain = Inst20Quest6_Attain

Inst20Quest7_HORDE_QuestID = "7500"
Inst20Quest7_HORDE_Level = Inst20Quest7_Level
Inst20Quest7_HORDE_Attain = Inst20Quest7_Attain

Inst20Quest8_HORDE_QuestID = "7505"
Inst20Quest8_HORDE_Level = "60"
Inst20Quest8_HORDE_Attain = "54"

Inst20Quest9_HORDE_QuestID = "7504"
Inst20Quest9_HORDE_Level = Inst20Quest9_Level
Inst20Quest9_HORDE_Attain = Inst20Quest9_Attain

Inst20Quest10_HORDE_QuestID = "7498"
Inst20Quest10_HORDE_Level = Inst20Quest10_Level
Inst20Quest10_HORDE_Attain = Inst20Quest10_Attain

Inst20Quest11_HORDE_QuestID = "7502"
Inst20Quest11_HORDE_Level = Inst20Quest11_Level
Inst20Quest11_HORDE_Attain = Inst20Quest11_Attain

Inst20Quest12_HORDE_QuestID = "7499"
Inst20Quest12_HORDE_Level = Inst20Quest12_Level
Inst20Quest12_HORDE_Attain = Inst20Quest12_Attain

Inst20Quest13_HORDE_QuestID = "7484"
Inst20Quest13_HORDE_Level = Inst20Quest13_Level
Inst20Quest13_HORDE_Attain = Inst20Quest13_Attain

Inst20Quest14_HORDE_QuestID = "7485"
Inst20Quest14_HORDE_Level = Inst20Quest14_Level
Inst20Quest14_HORDE_Attain = Inst20Quest14_Attain

Inst20Quest15_HORDE_QuestID = "7483"
Inst20Quest15_HORDE_Level = Inst20Quest15_Level
Inst20Quest15_HORDE_Attain = Inst20Quest15_Attain

Inst20Quest16_HORDE_QuestID = "7507"
Inst20Quest16_HORDE_Level = Inst20Quest16_Level
Inst20Quest16_HORDE_Attain = Inst20Quest16_Attain



--------------- INST21 - Maraudon ---------------

Inst21Quest1_QuestID = "7070"
Inst21Quest1_Level = "42"
Inst21Quest1_Attain = "39"

Inst21Quest2_QuestID = "7041"
Inst21Quest2_Level = "47"
Inst21Quest2_Attain = "41"

Inst21Quest3_QuestID = "7028"
Inst21Quest3_Level = "47"
Inst21Quest3_Attain = "41"

Inst21Quest4_QuestID = "7067"
Inst21Quest4_Level = "48"
Inst21Quest4_Attain = "39"

Inst21Quest5_QuestID = "7044"
Inst21Quest5_Level = "49"
Inst21Quest5_Attain = "41"

Inst21Quest6_QuestID = "7046"
Inst21Quest6_Level = "49"
Inst21Quest6_Attain = "41"
Inst21Quest6FQuest = "true"

Inst21Quest7_QuestID = "7065"
Inst21Quest7_Level = "51"
Inst21Quest7_Attain = "45"

Inst21Quest8_QuestID = "7066"
Inst21Quest8_Level = "51"
Inst21Quest8_Attain = "39"
Inst21Quest8FQuest = "true"


Inst21Quest1_HORDE_QuestID = "7068"
Inst21Quest1_HORDE_Level = "42"
Inst21Quest1_HORDE_Attain = "39"

Inst21Quest2_HORDE_QuestID = "7029"
Inst21Quest2_HORDE_Level = "47"
Inst21Quest2_HORDE_Attain = "41"

Inst21Quest3_HORDE_QuestID = "7028"
Inst21Quest3_HORDE_Level = Inst21Quest3_Level
Inst21Quest3_HORDE_Attain = Inst21Quest3_Attain

Inst21Quest4_HORDE_QuestID = "7067"
Inst21Quest4_HORDE_Level = Inst21Quest4_Level
Inst21Quest4_HORDE_Attain = Inst21Quest4_Attain

Inst21Quest5_HORDE_QuestID = "7044"
Inst21Quest5_HORDE_Level = Inst21Quest5_Level
Inst21Quest5_HORDE_Attain = Inst21Quest5_Attain

Inst21Quest6_HORDE_QuestID = "7046"
Inst21Quest6_HORDE_Level = Inst21Quest6_Level
Inst21Quest6_HORDE_Attain = Inst21Quest6_Attain
Inst21Quest6FQuest_HORDE = Inst21Quest6FQuest

Inst21Quest7_HORDE_QuestID = "7064"
Inst21Quest7_HORDE_Level = "51"
Inst21Quest7_HORDE_Attain = "45"

Inst21Quest8_HORDE_QuestID = "7066"
Inst21Quest8_HORDE_Level = Inst21Quest8_Level
Inst21Quest8_HORDE_Attain = Inst21Quest8_Attain
Inst21Quest8FQuest_HORDE = Inst21Quest8FQuest



--------------- INST22 - Ragefire Chasm ---------------

Inst22Quest1_HORDE_QuestID = "5723"
Inst22Quest1_HORDE_Level = "15"
Inst22Quest1_HORDE_Attain = "9"

Inst22Quest2_HORDE_QuestID = "5725"
Inst22Quest2_HORDE_Level = "16"
Inst22Quest2_HORDE_Attain = "9"

Inst22Quest3_HORDE_QuestID = "5722"
Inst22Quest3_HORDE_Level = "16"
Inst22Quest3_HORDE_Attain = "9"

Inst22Quest4_HORDE_QuestID = "5728"
Inst22Quest4_HORDE_Level = "16"
Inst22Quest4_HORDE_Attain = "9"
Inst22Quest4PreQuest_HORDE = "true"

Inst22Quest5_HORDE_QuestID = "5761"
Inst22Quest5_HORDE_Level = "16"
Inst22Quest5_HORDE_Attain = "9"



--------------- INST23 - Razorfen Downs ---------------

Inst23Quest1_QuestID = "6626"
Inst23Quest1_Level = "35"
Inst23Quest1_Attain = "28"

Inst23Quest2_QuestID = "3525"
Inst23Quest2_Level = "37"
Inst23Quest2_Attain = "32"
Inst23Quest2PreQuest = "true"

Inst23Quest3_QuestID = "3636"
Inst23Quest3_Level = "42"
Inst23Quest3_Attain = "39"


Inst23Quest1_HORDE_QuestID = "6626"
Inst23Quest1_HORDE_Level = Inst23Quest1_Level
Inst23Quest1_HORDE_Attain = Inst23Quest1_Attain

Inst23Quest2_HORDE_QuestID = "6521"
Inst23Quest2_HORDE_Level = "36"
Inst23Quest2_HORDE_Attain = "28"
Inst23Quest2PreQuest_HORDE = "true"

Inst23Quest3_HORDE_QuestID = "3525"
Inst23Quest3_HORDE_Level = Inst23Quest2_Level
Inst23Quest3_HORDE_Attain = Inst23Quest2_Attain
Inst23Quest3PreQuest_HORDE = Inst23Quest2PreQuest

Inst23Quest4_HORDE_QuestID = "3341"
Inst23Quest4_HORDE_Level = "42"
Inst23Quest4_HORDE_Attain = "37"



--------------- INST24 - Razorfen Kraul ---------------

Inst24Quest1_QuestID = "1221"
Inst24Quest1_Level = "26"
Inst24Quest1_Attain = "20"

Inst24Quest2_QuestID = "1142"
Inst24Quest2_Level = "30"
Inst24Quest2_Attain = "25"

Inst24Quest3_QuestID = "1144"
Inst24Quest3_Level = "30"
Inst24Quest3_Attain = "22"

Inst24Quest4_QuestID = "1101"
Inst24Quest4_Level = "34"
Inst24Quest4_Attain = "29"
Inst24Quest4PreQuest = "true"

Inst24Quest5_QuestID = "1701"
Inst24Quest5_Level = "28"
Inst24Quest5_Attain = "20"
Inst24Quest5PreQuest = "true"


Inst24Quest1_HORDE_QuestID = "1221"
Inst24Quest1_HORDE_Level = Inst24Quest1_Level
Inst24Quest1_HORDE_Attain = Inst24Quest1_Attain

Inst24Quest2_HORDE_QuestID = "1144"
Inst24Quest2_HORDE_Level = Inst24Quest3_Level
Inst24Quest2_HORDE_Attain = Inst24Quest3_Attain

Inst24Quest3_HORDE_QuestID = "1109"
Inst24Quest3_HORDE_Level = "33"
Inst24Quest3_HORDE_Attain = "30"

Inst24Quest4_HORDE_QuestID = "1102"
Inst24Quest4_HORDE_Level = "34"
Inst24Quest4_HORDE_Attain = "29"

Inst24Quest5_HORDE_QuestID = "1838"
Inst24Quest5_HORDE_Level = "30"
Inst24Quest5_HORDE_Attain = "20"
Inst24Quest5PreQuest_HORDE = "true"



--------------- INST25 - Wailing Caverns ---------------

Inst25Quest1_QuestID = "1486"
Inst25Quest1_Level = "17"
Inst25Quest1_Attain = "13"

Inst25Quest2_QuestID = "959"
Inst25Quest2_Level = "18"
Inst25Quest2_Attain = "14"

Inst25Quest3_QuestID = "1491"
Inst25Quest3_Level = "18"
Inst25Quest3_Attain = "13"
Inst25Quest3PreQuest = "true"

Inst25Quest4_QuestID = "1487"
Inst25Quest4_Level = "21"
Inst25Quest4_Attain = "15"

Inst25Quest5_QuestID = "6981"
Inst25Quest5_Level = "26"
Inst25Quest5_Attain = "15"


Inst25Quest1_HORDE_QuestID = "1486"
Inst25Quest1_HORDE_Level = Inst25Quest1_Level
Inst25Quest1_HORDE_Attain = Inst25Quest1_Attain

Inst25Quest2_HORDE_QuestID = "959"
Inst25Quest2_HORDE_Level = Inst25Quest2_Level
Inst25Quest2_HORDE_Attain = Inst25Quest2_Attain

Inst25Quest3_HORDE_QuestID = "962"
Inst25Quest3_HORDE_Level = "18"
Inst25Quest3_HORDE_Attain = "14"
Inst25Quest3PreQuest_HORDE = "true"

Inst25Quest4_HORDE_QuestID = "1491"
Inst25Quest4_HORDE_Level = Inst25Quest3_Level
Inst25Quest4_HORDE_Attain = Inst25Quest3_Attain
Inst25Quest4PreQuest_HORDE = Inst25Quest3PreQuest

Inst25Quest5_HORDE_QuestID = "1487"
Inst25Quest5_HORDE_Level = Inst25Quest4_Level
Inst25Quest5_HORDE_Attain = Inst25Quest4_Attain

Inst25Quest6_HORDE_QuestID = "914"
Inst25Quest6_HORDE_Level = "22"
Inst25Quest6_HORDE_Attain = "10"
Inst25Quest6PreQuest_HORDE = "true"

Inst25Quest7_HORDE_QuestID = "6981"
Inst25Quest7_HORDE_Level = Inst25Quest5_Level
Inst25Quest7_HORDE_Attain = Inst25Quest5_Attain



--------------- INST26 - Zul'Farrak ---------------

Inst26Quest1_QuestID = "3042"
Inst26Quest1_Level = "45"
Inst26Quest1_Attain = "40"

Inst26Quest2_QuestID = "2865"
Inst26Quest2_Level = "45"
Inst26Quest2_Attain = "40"
Inst26Quest2PreQuest = "true"

Inst26Quest3_QuestID = "2846"
Inst26Quest3_Level = "46"
Inst26Quest3_Attain = "40"
Inst26Quest3PreQuest = "true"

Inst26Quest4_QuestID = "2991"
Inst26Quest4_Level = "47"
Inst26Quest4_Attain = "40"
Inst26Quest4PreQuest = "true"

Inst26Quest5_QuestID = "3527"
Inst26Quest5_Level = "47"
Inst26Quest5_Attain = "40"
Inst26Quest5PreQuest = "true"

Inst26Quest6_QuestID = "2768"
Inst26Quest6_Level = "47"
Inst26Quest6_Attain = "40"

Inst26Quest7_QuestID = "2770"
Inst26Quest7_Level = "50"
Inst26Quest7_Attain = "40"
Inst26Quest7PreQuest = "true"


Inst26Quest1_HORDE_QuestID = "2936"
Inst26Quest1_HORDE_Level = "45"
Inst26Quest1_HORDE_Attain = "40"
Inst26Quest1PreQuest_HORDE = "true"

Inst26Quest2_HORDE_QuestID = "3042"
Inst26Quest2_HORDE_Level = Inst26Quest1_Level
Inst26Quest2_HORDE_Attain = Inst26Quest1_Attain

Inst26Quest3_HORDE_QuestID = "2865"
Inst26Quest3_HORDE_Level = Inst26Quest2_Level
Inst26Quest3_HORDE_Attain = Inst26Quest2_Attain
Inst26Quest3PreQuest_HORDE = Inst26Quest2PreQuest

Inst26Quest4_HORDE_QuestID = "2846"
Inst26Quest4_HORDE_Level = Inst26Quest3_Level
Inst26Quest4_HORDE_Attain = Inst26Quest3_Attain

Inst26Quest5_HORDE_QuestID = "3527"
Inst26Quest5_HORDE_Level = Inst26Quest5_Level
Inst26Quest5_HORDE_Attain = Inst26Quest5_Attain
Inst26Quest5PreQuest_HORDE = Inst26Quest5PreQuest

Inst26Quest6_HORDE_QuestID = "2768"
Inst26Quest6_HORDE_Level = Inst26Quest6_Level
Inst26Quest6_HORDE_Attain = Inst26Quest6_Attain

Inst26Quest7_HORDE_QuestID = "2770"
Inst26Quest7_HORDE_Level = Inst26Quest7_Level
Inst26Quest7_HORDE_Attain = Inst26Quest7_Attain



--------------- INST27 - Molten Core ---------------

Inst27Quest1_QuestID = "6822"
Inst27Quest1_Level = "60"
Inst27Quest1_Attain = "55"
Inst27Quest1PreQuest = "true"

Inst27Quest2_QuestID = "6824"
Inst27Quest2_Level = "60"
Inst27Quest2_Attain = "55"
Inst27Quest2FQuest = "true"

Inst27Quest3_QuestID = "7786"
Inst27Quest3_Level = "60"
Inst27Quest3_Attain = "60"
Inst27Quest3PreQuest = "true"

Inst27Quest4_QuestID = "7604"
Inst27Quest4_Level = "60"
Inst27Quest4_Attain = "60"

Inst27Quest5_QuestID = "7632"
Inst27Quest5_Level = "60"
Inst27Quest5_Attain = "60"

Inst27Quest6_QuestID = "8578"
Inst27Quest6_Level = "60"
Inst27Quest6_Attain = "60"
Inst27Quest6PreQuest = "true"

Inst27Quest7_QuestID = "7848"
Inst27Quest7_Level = "60"
Inst27Quest7_Attain = "55"


Inst27Quest1_HORDE_QuestID = "6822"
Inst27Quest1_HORDE_Level = Inst27Quest1_Level
Inst27Quest1_HORDE_Attain = Inst27Quest1_Attain
Inst27Quest1PreQuest_HORDE = Inst27Quest1PreQuest

Inst27Quest2_HORDE_QuestID = "6824"
Inst27Quest2_HORDE_Level = Inst27Quest2_Level
Inst27Quest2_HORDE_Attain = Inst27Quest2_Attain
Inst27Quest2FQuest_HORDE = Inst27Quest2FQuest

Inst27Quest3_HORDE_QuestID = "7786"
Inst27Quest3_HORDE_Level = Inst27Quest3_Level
Inst27Quest3_HORDE_Attain = Inst27Quest3_Attain
Inst27Quest3PreQuest_HORDE = Inst27Quest3PreQuest

Inst27Quest4_HORDE_QuestID = "7604"
Inst27Quest4_HORDE_Level = Inst27Quest4_Level
Inst27Quest4_HORDE_Attain = Inst27Quest4_Attain

Inst27Quest5_HORDE_QuestID = "7632"
Inst27Quest5_HORDE_Level = Inst27Quest5_Level
Inst27Quest5_HORDE_Attain = Inst27Quest5_Attain

Inst27Quest6_HORDE_QuestID = "8578"
Inst27Quest6_HORDE_Level = Inst27Quest6_Level
Inst27Quest6_HORDE_Attain = Inst27Quest6_Attain
Inst27Quest6PreQuest_HORDE = Inst27Quest6PreQuest

Inst27Quest7_HORDE_QuestID = "7848"
Inst27Quest7_HORDE_Level = "60"
Inst27Quest7_HORDE_Attain = "55"



--------------- INST28 - Onyxia's Lair ---------------

Inst28Quest1_QuestID = "7509"
Inst28Quest1_Level = "60"
Inst28Quest1_Attain = "60"
Inst28Quest1PreQuest = "true"

Inst28Quest2_QuestID = "7495"
Inst28Quest2_Level = "60"
Inst28Quest2_Attain = "60"


Inst28Quest1_HORDE_QuestID = "7509"
Inst28Quest1_HORDE_Attain = Inst28Quest1_Attain
Inst28Quest1_HORDE_Level = Inst28Quest1_Level
Inst28Quest1PreQuest_HORDE = Inst28Quest1PreQuest

Inst28Quest2_HORDE_QuestID = "7490"
Inst28Quest2_HORDE_Level = "60"
Inst28Quest2_HORDE_Attain = "60"



--------------- INST29 - Zul'Gurub ---------------

Inst29Quest1_QuestID = "8201"
Inst29Quest1_Level = "60"
Inst29Quest1_Attain = "58"

Inst29Quest2_QuestID = "8183"
Inst29Quest2_Level = "60"
Inst29Quest2_Attain = "58"

Inst29Quest3_QuestID = "8227"
Inst29Quest3_Level = "60"
Inst29Quest3_Attain = "59"

Inst29Quest4_QuestID = "9023"
Inst29Quest4_Level = "60"
Inst29Quest4_Attain = "60"


Inst29Quest1_HORDE_QuestID = "8201"
Inst29Quest1_HORDE_Level = Inst29Quest1_Level
Inst29Quest1_HORDE_Attain = Inst29Quest1_Attain

Inst29Quest2_HORDE_QuestID = "8183"
Inst29Quest2_HORDE_Level = Inst29Quest2_Level
Inst29Quest2_HORDE_Attain = Inst29Quest2_Attain

Inst29Quest3_HORDE_QuestID = "8227"
Inst29Quest3_HORDE_Level = Inst29Quest3_Level
Inst29Quest3_HORDE_Attain = Inst29Quest3_Attain

Inst29Quest4_HORDE_QuestID = "9023"
Inst29Quest4_HORDE_Level = Inst29Quest4_Level
Inst29Quest4_HORDE_Attain = Inst29Quest4_Attain



--------------- INST30 - The Ruins of Ahn'Qiraj ---------------

Inst30Quest1_QuestID = "8791"
Inst30Quest1_Level = "60"
Inst30Quest1_Attain = "60"

Inst30Quest2_QuestID = "9023"
Inst30Quest2_Level = "60"
Inst30Quest2_Attain = "60"


Inst30Quest1_HORDE_QuestID = "8791"
Inst30Quest1_HORDE_Level = Inst30Quest1_Level
Inst30Quest1_HORDE_Attain = Inst30Quest1_Attain

Inst30Quest2_HORDE_QuestID = "9023"
Inst30Quest2_HORDE_Level = Inst30Quest2_Level
Inst30Quest2_HORDE_Attain = Inst30Quest2_Attain



--------------- INST31 - The Temple of Ahn'Qiraj ---------------

Inst31Quest1_QuestID = "8801"
Inst31Quest1_Level = "60"
Inst31Quest1_Attain = "60"

Inst31Quest2_QuestID = "8802"
Inst31Quest2_Level = "60"
Inst31Quest2_Attain = "60"
Inst31Quest2FQuest = "true"

Inst31Quest3_QuestID = "8784"
Inst31Quest3_Level = "60"
Inst31Quest3_Attain = "60"

Inst31Quest4_QuestID = "8579"
Inst31Quest4_Level = "60"
Inst31Quest4_Attain = "60"


Inst31Quest1_HORDE_QuestID = "8801"
Inst31Quest1_HORDE_Level = Inst31Quest1_Level
Inst31Quest1_HORDE_Attain = Inst31Quest1_Attain

Inst31Quest2_HORDE_QuestID = "8802"
Inst31Quest2_HORDE_Level = Inst31Quest2_Level
Inst31Quest2_HORDE_Attain = Inst31Quest2_Attain

Inst31Quest3_HORDE_QuestID = "8784"
Inst31Quest3_HORDE_Level = Inst31Quest3_Level
Inst31Quest3_HORDE_Attain = Inst31Quest3_Attain

Inst31Quest4_HORDE_QuestID = "8579"
Inst31Quest4_HORDE_Level = Inst31Quest4_Level
Inst31Quest4_HORDE_Attain = Inst31Quest4_Attain



--------------- INST32 - Naxxramas ---------------

-- No quests.



--------------- INST33 - Alterac Valley (AV) ---------------

Inst33Quest1_QuestID = "7261"
Inst33Quest1_Level = "60"
Inst33Quest1_Attain = "51"

Inst33Quest2_QuestID = "7162"
Inst33Quest2_Level = "60"
Inst33Quest2_Attain = "51"
Inst33Quest2FQuest = "true"

Inst33Quest3_QuestID = "7141"
Inst33Quest3_Level = "60"
Inst33Quest3_Attain = "51"

Inst33Quest4_QuestID = "7121"
Inst33Quest4_Level = "60"
Inst33Quest4_Attain = "51"

Inst33Quest5_QuestID = "6982"
Inst33Quest5_Level = "60"
Inst33Quest5_Attain = "51"

Inst33Quest6_QuestID = "5892"
Inst33Quest6_Level = "60"
Inst33Quest6_Attain = "51"

Inst33Quest7_QuestID = "7223"
Inst33Quest7_Level = "60"
Inst33Quest7_Attain = "51"

Inst33Quest8_QuestID = "7122"
Inst33Quest8_Level = "60"
Inst33Quest8_Attain = "51"

Inst33Quest9_QuestID = "7102"
Inst33Quest9_Level = "60"
Inst33Quest9_Attain = "51"

Inst33Quest10_QuestID = "7081"
Inst33Quest10_Level = "60"
Inst33Quest10_Attain = "51"

Inst33Quest11_QuestID = "7027"
Inst33Quest11_Level = "60"
Inst33Quest11_Attain = "51"

Inst33Quest12_QuestID = "7026"
Inst33Quest12_Level = "60"
Inst33Quest12_Attain = "51"

Inst33Quest13_QuestID = "7386"
Inst33Quest13_Level = "60"
Inst33Quest13_Attain = "51"

Inst33Quest14_QuestID = "6881"
Inst33Quest14_Level = "60"
Inst33Quest14_Attain = "51"

Inst33Quest15_QuestID = "6942"
Inst33Quest15_Level = "60"
Inst33Quest15_Attain = "51"

Inst33Quest16_QuestID = "6941"
Inst33Quest16_Level = "60"
Inst33Quest16_Attain = "51"

Inst33Quest17_QuestID = "6943"
Inst33Quest17_Level = "60"
Inst33Quest17_Attain = "51"



Inst33Quest1_HORDE_QuestID = "7241"
Inst33Quest1_HORDE_Level = "60"
Inst33Quest1_HORDE_Attain = "51"

Inst33Quest2_HORDE_QuestID = "7161"
Inst33Quest2_HORDE_Level = "60"
Inst33Quest2_HORDE_Attain = "51"
Inst33Quest2FQuest_HORDE = "true"

Inst33Quest3_HORDE_QuestID = "7142"
Inst33Quest3_HORDE_Level = "60"
Inst33Quest3_HORDE_Attain = "51"

Inst33Quest4_HORDE_QuestID = "7123"
Inst33Quest4_HORDE_Level = "60"
Inst33Quest4_HORDE_Attain = "51"

Inst33Quest5_HORDE_QuestID = "5893"
Inst33Quest5_HORDE_Level = "60"
Inst33Quest5_HORDE_Attain = "51"

Inst33Quest6_HORDE_QuestID = "6985"
Inst33Quest6_HORDE_Level = "60"
Inst33Quest6_HORDE_Attain = "51"

Inst33Quest7_HORDE_QuestID = "7224"
Inst33Quest7_HORDE_Level = "60"
Inst33Quest7_HORDE_Attain = "51"

Inst33Quest8_HORDE_QuestID = "7124"
Inst33Quest8_HORDE_Level = "60"
Inst33Quest8_HORDE_Attain = "51"

Inst33Quest9_HORDE_QuestID = "7101"
Inst33Quest9_HORDE_Level = "60"
Inst33Quest9_HORDE_Attain = "51"

Inst33Quest10_HORDE_QuestID = "7082"
Inst33Quest10_HORDE_Level = "60"
Inst33Quest10_HORDE_Attain = "51"

Inst33Quest11_HORDE_QuestID = "7001"
Inst33Quest11_HORDE_Level = "60"
Inst33Quest11_HORDE_Attain = "51"

Inst33Quest12_HORDE_QuestID = "7002"
Inst33Quest12_HORDE_Level = "60"
Inst33Quest12_HORDE_Attain = "51"

Inst33Quest13_HORDE_QuestID = "7385"
Inst33Quest13_HORDE_Level = "60"
Inst33Quest13_HORDE_Attain = "51"

Inst33Quest14_HORDE_QuestID = "6801"
Inst33Quest14_HORDE_Level = "60"
Inst33Quest14_HORDE_Attain = "51"

Inst33Quest15_HORDE_QuestID = "6825"
Inst33Quest15_HORDE_Level = "60"
Inst33Quest15_HORDE_Attain = "51"

Inst33Quest16_HORDE_QuestID = "6826"
Inst33Quest16_HORDE_Level = "60"
Inst33Quest16_HORDE_Attain = "51"

Inst33Quest17_HORDE_QuestID = "6827"
Inst33Quest17_HORDE_Level = "60"
Inst33Quest17_HORDE_Attain = "51"



--------------- INST34 - Arathi Basin (AB) ---------------

Inst34Quest1_QuestID = "8105"
Inst34Quest1_Level = "25"
Inst34Quest1_Attain = "25"

Inst34Quest2_QuestID = "8114"
Inst34Quest2_Level = "60"
Inst34Quest2_Attain = "60"

Inst34Quest3_QuestID = "8115"
Inst34Quest3_Level = "60"
Inst34Quest3_Attain = "60"


Inst34Quest1_HORDE_QuestID = "8120"
Inst34Quest1_HORDE_Level = "25"
Inst34Quest1_HORDE_Attain = "25"

Inst34Quest2_HORDE_QuestID = "8121"
Inst34Quest2_HORDE_Level = "60"
Inst34Quest2_HORDE_Attain = "60"

Inst34Quest3_HORDE_QuestID = "8122"
Inst34Quest3_HORDE_Level = "60"
Inst34Quest3_HORDE_Attain = "60"



--------------- INST35 - Warsong Gulch (WSG) ---------------

-- No quests.



--------------- INST36 - Dragons of Nightmare ---------------

Inst36Quest1_QuestID = "8446"
Inst36Quest1_Level = "60"
Inst36Quest1_Attain = "60"


Inst36Quest1_HORDE_QuestID = "8446"
Inst36Quest1_HORDE_Level = Inst36Quest1_Level
Inst36Quest1_HORDE_Attain = Inst36Quest1_Attain



--------------- INST37 - Azuregos ---------------

Inst37Quest1_QuestID = "7634"
Inst37Quest1_Level = "60"
Inst37Quest1_Attain = "60"
Inst37Quest1PreQuest = "true"


Inst37Quest1_HORDE_QuestID = "7634"
Inst37Quest1_HORDE_Level = Inst37Quest1_Level
Inst37Quest1_HORDE_Attain = Inst37Quest1_Attain
Inst37Quest1PreQuest_HORDE = Inst37Quest1PreQuest



--------------- INST38 - Highlord Kruul ---------------

-- No quests.



--------------- INST40 - Hellfire Ramparts ---------------

Inst40Quest1_QuestID = "9575"
Inst40Quest1_Level = "62"
Inst40Quest1_Attain = "59"
Inst40Quest1PreQuest = "true"

Inst40Quest2_QuestID = "9587"
Inst40Quest2_Level = "62"
Inst40Quest2_Attain = "59"
Inst40Quest2FQuest = "true"

Inst40Quest3_QuestID = "11354"
Inst40Quest3_Level = "70"
Inst40Quest3_Attain = "70"


Inst40Quest1_HORDE_QuestID = "9572"
Inst40Quest1_HORDE_Level = "62"
Inst40Quest1_HORDE_Attain = "59"
Inst40Quest1PreQuest_HORDE = "true"

Inst40Quest2_HORDE_QuestID = "9588"
Inst40Quest2_HORDE_Level = "62"
Inst40Quest2_HORDE_Attain = "59"
Inst40Quest2FQuest_HORDE = "true"

Inst40Quest3_HORDE_QuestID = "11354"
Inst40Quest3_HORDE_Level = "70"
Inst40Quest3_HORDE_Attain = "70"



--------------- INST41 - Blood Furnace ---------------

Inst41Quest1_QuestID = "9589"
Inst41Quest1_Level = "63"
Inst41Quest1_Attain = "59"
Inst41Quest1PreQuest = "true"

Inst41Quest2_QuestID = "9607"
Inst41Quest2_Level = "63"
Inst41Quest2_Attain = "59"
Inst41Quest2PreQuest = "true"

Inst41Quest3_QuestID = "11362"
Inst41Quest3_Level = "70"
Inst41Quest3_Attain = "70"


Inst41Quest1_HORDE_QuestID = "9590"
Inst41Quest1_HORDE_Level = "63"
Inst41Quest1_HORDE_Attain = "59"
Inst41Quest1PreQuest_HORDE = "true"

Inst41Quest2_HORDE_QuestID = "9608"
Inst41Quest2_HORDE_Level = "63"
Inst41Quest2_HORDE_Attain = "59"
Inst41Quest2PreQuest_HORDE = "true"

Inst41Quest3_HORDE_QuestID = "11362"
Inst41Quest3_HORDE_Level = "70"
Inst41Quest3_HORDE_Attain = "70"



--------------- INST42 - Shattered Halls ---------------

Inst42Quest1_QuestID = "9494"
Inst42Quest1_Level = "70"
Inst42Quest1_Attain = "67"

Inst42Quest2_QuestID = "9493"
Inst42Quest2_Level = "70"
Inst42Quest2_Attain = "66"

Inst42Quest3_QuestID = "9492"
Inst42Quest3_Level = "70"
Inst42Quest3_Attain = "67"

Inst42Quest4_QuestID = "9524"
Inst42Quest4_Level = "70"
Inst42Quest4_Attain = "70"

Inst42Quest5_QuestID = "10884"
Inst42Quest5_Level = "70"
Inst42Quest5_Attain = "70"

Inst42Quest6_QuestID = "10670"
Inst42Quest6_Level = "70"
Inst42Quest6_Attain = "67"
Inst42Quest6PreQuest = "true"

Inst42Quest7_QuestID = "9637"
Inst42Quest7_Level = "70"
Inst42Quest7_Attain = "70"
Inst42Quest7PreQuest = "true"

Inst42Quest8_QuestID = "11363"
Inst42Quest8_Level = "70"
Inst42Quest8_Attain = "70"

Inst42Quest9_QuestID = "11364"
Inst42Quest9_Level = "70"
Inst42Quest9_Attain = "70"

Inst42Quest10_QuestID = "10754"
Inst42Quest10_Level = "70"
Inst42Quest10_Attain = "68"


Inst42Quest1_HORDE_QuestID = "9496"
Inst42Quest1_HORDE_Level = "70"
Inst42Quest1_HORDE_Attain = "66"

Inst42Quest2_HORDE_QuestID = "9495"
Inst42Quest2_HORDE_Level = "70"
Inst42Quest2_HORDE_Attain = "67"

Inst42Quest3_HORDE_QuestID = "9525"
Inst42Quest3_HORDE_Level = "70"
Inst42Quest3_HORDE_Attain = "70"

Inst42Quest4_HORDE_QuestID = "10884"
Inst42Quest4_HORDE_Level = "70"
Inst42Quest4_HORDE_Attain = "70"

Inst42Quest5_HORDE_QuestID = "10670"
Inst42Quest5_HORDE_Level = "70"
Inst42Quest5_HORDE_Attain = "67"
Inst42Quest5PreQuest_HORDE = "true"

Inst42Quest6_HORDE_QuestID = "9637"
Inst42Quest6_HORDE_Level = "70"
Inst42Quest6_HORDE_Attain = "70"
Inst42Quest6PreQuest_HORDE = "true"

Inst42Quest7_HORDE_QuestID = "11363"
Inst42Quest7_HORDE_Level = "70"
Inst42Quest7_HORDE_Attain = "70"

Inst42Quest8_HORDE_QuestID = "11364"
Inst42Quest8_HORDE_Level = "70"
Inst42Quest8_HORDE_Attain = "70"

Inst42Quest9_HORDE_QuestID = "10755"
Inst42Quest9_HORDE_Level = "70"
Inst42Quest9_HORDE_Attain = "68"



--------------- INST43 - Magtheridon's Lair ---------------

Inst43Quest1_QuestID = "10888"
Inst43Quest1_Level = "70"
Inst43Quest1_Attain = "70"
Inst43Quest1PreQuest = "true"

Inst43Quest2_QuestID = "11002"
Inst43Quest2_Level = "70"
Inst43Quest2_Attain = "70"


Inst43Quest1_HORDE_QuestID = "10888"
Inst43Quest1_HORDE_Level = "70"
Inst43Quest1_HORDE_Attain = "70"
Inst43Quest1PreQuest_HORDE = "true"

Inst43Quest2_HORDE_QuestID = "11003"
Inst43Quest2_HORDE_Level = "70"
Inst43Quest2_HORDE_Attain = "70"



--------------- INST44 - The Slave Pens ---------------

Inst44Quest1_QuestID = "9738"
Inst44Quest1_Level = "65"
Inst44Quest1_Attain = "62"
Inst44Quest1PreQuest = "true"

Inst44Quest2_QuestID = "11368"
Inst44Quest2_Level = "70"
Inst44Quest2_Attain = "70"

Inst44Quest3_QuestID = "10901"
Inst44Quest3_Level = "70"
Inst44Quest3_Attain = "70"

Inst44Quest4_QuestID = "11955"
Inst44Quest4_Level = "70"
Inst44Quest4_Attain = "65"
Inst44Quest4PreQuest = "true"

Inst44Quest5_QuestID = "11696"
Inst44Quest5_Level = "70"
Inst44Quest5_Attain = "65"
Inst44Quest5FQuest = "true"

Inst44Quest6_QuestID = "11691"
Inst44Quest6_Level = "70"
Inst44Quest6_Attain = "65"
Inst44Quest6FQuest = "true"

Inst44Quest7_QuestID = "11972"
Inst44Quest7_Level = "70"
Inst44Quest7_Attain = "65"


Inst44Quest1_HORDE_QuestID = "9738"
Inst44Quest1_HORDE_Level = Inst44Quest1_Level
Inst44Quest1_HORDE_Attain = Inst44Quest1_Attain
Inst44Quest1PreQuest_HORDE = Inst44Quest1PreQuest

Inst44Quest2_HORDE_QuestID = "11368"
Inst44Quest2_HORDE_Level = Inst44Quest2_Level
Inst44Quest2_HORDE_Attain = Inst44Quest2_Attain

Inst44Quest3_HORDE_QuestID = "10901"
Inst44Quest3_HORDE_Level = Inst44Quest3_Level
Inst44Quest3_HORDE_Attain = Inst44Quest3_Attain

Inst44Quest4_HORDE_QuestID = "11955"
Inst44Quest4_HORDE_Level = Inst44Quest4_Level
Inst44Quest4_HORDE_Attain = Inst44Quest4_Attain
Inst44Quest4PreQuest_HORDE = Inst44Quest4PreQuest

Inst44Quest5_HORDE_QuestID = "11696"
Inst44Quest5_HORDE_Level = Inst44Quest5_Level
Inst44Quest5_HORDE_Attain = Inst44Quest5_Attain
Inst44Quest5FQuest_HORDE = Inst44Quest5FQuest

Inst44Quest6_HORDE_QuestID = "11691"
Inst44Quest6_HORDE_Level = Inst44Quest6_Level
Inst44Quest6_HORDE_Attain = Inst44Quest6_Attain
Inst44Quest6FQuest_HORDE = Inst44Quest6FQuest

Inst44Quest7_HORDE_QuestID = "11972"
Inst44Quest7_HORDE_Level = Inst44Quest7_Level
Inst44Quest7_HORDE_Attain = Inst44Quest7_Attain



--------------- INST45 - The Steamvault ---------------

Inst45Quest1_QuestID = "9763"
Inst45Quest1_Level = "70"
Inst45Quest1_Attain = "67"

Inst45Quest2_QuestID = "9764"
Inst45Quest2_Level = "70"
Inst45Quest2_Attain = "67"

Inst45Quest3_QuestID = "10885"
Inst45Quest3_Level = "70"
Inst45Quest3_Attain = "70"

Inst45Quest4_QuestID = "10667"
Inst45Quest4_Level = "70"
Inst45Quest4_Attain = "67"
Inst45Quest4PreQuest = "true"

Inst45Quest5_QuestID = "9832"
Inst45Quest5_Level = "70"
Inst45Quest5_Attain = "68"
Inst45Quest5PreQuest = "true"

Inst45Quest6_QuestID = "11371"
Inst45Quest6_Level = "70"
Inst45Quest6_Attain = "70"

Inst45Quest7_QuestID = "11370"
Inst45Quest7_Level = "70"
Inst45Quest7_Attain = "70"


Inst45Quest1_HORDE_QuestID = "9763"
Inst45Quest1_HORDE_Level = Inst45Quest1_Level
Inst45Quest1_HORDE_Attain = Inst45Quest1_Attain

Inst45Quest2_HORDE_QuestID = "9764"
Inst45Quest2_HORDE_Level = Inst45Quest2_Level
Inst45Quest2_HORDE_Attain = Inst45Quest2_Attain

Inst45Quest3_HORDE_QuestID = "10885"
Inst45Quest3_HORDE_Level = Inst45Quest3_Level
Inst45Quest3_HORDE_Attain = Inst45Quest3_Attain

Inst45Quest4_HORDE_QuestID = "10667"
Inst45Quest4_HORDE_Level = Inst45Quest4_Level
Inst45Quest4_HORDE_Attain = Inst45Quest4_Attain
Inst45Quest4PreQuest_HORDE = Inst45Quest4PreQuest

Inst45Quest5_HORDE_QuestID = "9832"
Inst45Quest5_HORDE_Level = Inst45Quest5_Level
Inst45Quest5_HORDE_Attain = Inst45Quest5_Attain

Inst45Quest6_HORDE_QuestID = "11371"
Inst45Quest6_HORDE_Level = Inst45Quest6_Level
Inst45Quest6_HORDE_Attain = Inst45Quest6_Attain

Inst45Quest7_HORDE_QuestID = "11370"
Inst45Quest7_HORDE_Level = Inst45Quest7_Level
Inst45Quest7_HORDE_Attain = Inst45Quest7_Attain



--------------- INST46 - The Underbog ---------------

Inst46Quest1_QuestID = "9738"
Inst46Quest1_Level = "65"
Inst46Quest1_Attain = "62"
Inst46Quest1PreQuest = "true"

Inst46Quest2_QuestID = "9717"
Inst46Quest2_Level = "65"
Inst46Quest2_Attain = "63"

Inst46Quest3_QuestID = "9719"
Inst46Quest3_Level = "65"
Inst46Quest3_Attain = "63"

Inst46Quest4_QuestID = "11369"
Inst46Quest4_Level = "70"
Inst46Quest4_Attain = "70"

Inst46Quest5_QuestID = "9715"
Inst46Quest5_Level = "65"
Inst46Quest5_Attain = "63"


Inst46Quest1_HORDE_QuestID = "9738"
Inst46Quest1_HORDE_Level = Inst46Quest1_Level
Inst46Quest1_HORDE_Attain = Inst46Quest1_Attain
Inst46Quest1PreQuest_HORDE = Inst46Quest1PreQuest

Inst46Quest2_HORDE_QuestID = "9717"
Inst46Quest2_HORDE_Level = Inst46Quest2_Level
Inst46Quest2_HORDE_Attain = Inst46Quest2_Attain

Inst46Quest3_HORDE_QuestID = "9719"
Inst46Quest3_HORDE_Level = Inst46Quest3_Level
Inst46Quest3_HORDE_Attain = Inst46Quest3_Attain

Inst46Quest4_HORDE_QuestID = "11369"
Inst46Quest4_HORDE_Level = Inst46Quest4_Level
Inst46Quest4_HORDE_Attain = Inst46Quest4_Attain

Inst46Quest5_HORDE_QuestID = "9715"
Inst46Quest5_HORDE_Level = Inst46Quest5_Level
Inst46Quest5_HORDE_Attain = Inst46Quest5_Attain



--------------- INST47 - Auchenai Crypts ---------------

Inst47Quest1_QuestID = "10164"
Inst47Quest1_Level = "67"
Inst47Quest1_Attain = "64"
Inst47Quest1PreQuest = "true"

Inst47Quest2_QuestID = "11374"
Inst47Quest2_Level = "70"
Inst47Quest2_Attain = "70"


Inst47Quest1_HORDE_QuestID = "10167"
Inst47Quest1_HORDE_Level = "68"
Inst47Quest1_HORDE_Attain = "66"
Inst47Quest1PreQuest_HORDE = "true"

Inst47Quest2_HORDE_QuestID = "10168"
Inst47Quest2_HORDE_Level = "68"
Inst47Quest2_HORDE_Attain = "66"
Inst47Quest2FQuest_HORDE = "true"

Inst47Quest3_HORDE_QuestID = "10164"
Inst47Quest3_HORDE_Level = Inst47Quest1_Level
Inst47Quest3_HORDE_Attain = Inst47Quest1_Attain
Inst47Quest3PreQuest_HORDE = Inst47Quest1PreQuest

Inst47Quest4_HORDE_QuestID = "11374"
Inst47Quest4_HORDE_Level = Inst47Quest2_Level
Inst47Quest4_HORDE_Attain = Inst47Quest2_Attain



--------------- INST48 - Mana Tombs ---------------

Inst48Quest1_QuestID = "10216"
Inst48Quest1_Level = "66"
Inst48Quest1_Attain = "64"

Inst48Quest2_QuestID = "10218"
Inst48Quest2_Level = "66"
Inst48Quest2_Attain = "64"
Inst48Quest2FQuest = "true"

Inst48Quest3_QuestID = "10165"
Inst48Quest3_Level = "66"
Inst48Quest3_Attain = "64"

Inst48Quest4_QuestID = "10977"
Inst48Quest4_Level = "70"
Inst48Quest4_Attain = "70"
Inst48Quest4PreQuest = "true"

Inst48Quest5_QuestID = "11373"
Inst48Quest5_Level = "70"
Inst48Quest5_Attain = "70"


Inst48Quest1_HORDE_QuestID = "10216"
Inst48Quest1_HORDE_Level = Inst48Quest1_Level
Inst48Quest1_HORDE_Attain = Inst48Quest1_Attain

Inst48Quest2_HORDE_QuestID = "10218"
Inst48Quest2_HORDE_Level = Inst48Quest2_Level
Inst48Quest2_HORDE_Attain = Inst48Quest2_Attain
Inst48Quest2FQuest_HORDE = Inst48Quest2FQuest

Inst48Quest3_HORDE_QuestID = "10165"
Inst48Quest3_HORDE_Level = Inst48Quest3_Level
Inst48Quest3_HORDE_Attain = Inst48Quest3_Attain

Inst48Quest4_HORDE_QuestID = "10977"
Inst48Quest4_HORDE_Level = Inst48Quest4_Level
Inst48Quest4_HORDE_Attain = Inst48Quest4_Attain
Inst48Quest4PreQuest_HORDE = Inst48Quest4PreQuest

Inst48Quest5_HORDE_QuestID = "11373"
Inst48Quest5_HORDE_Level = Inst48Quest5_Level
Inst48Quest5_HORDE_Attain = Inst48Quest5_Attain



--------------- INST49 - Sethekk Halls ---------------

Inst49Quest1_QuestID = "10097"
Inst49Quest1_Level = "69"
Inst49Quest1_Attain = "65"

Inst49Quest2_QuestID = "10098"
Inst49Quest2_Level = "69"
Inst49Quest2_Attain = "65"

Inst49Quest3_QuestID = "11001"
Inst49Quest3_Level = "70"
Inst49Quest3_Attain = "70"
Inst49Quest3PreQuest = "true"

Inst49Quest4_QuestID = "9637"
Inst49Quest4_Level = "70"
Inst49Quest4_Attain = "70"
Inst49Quest4PreQuest = "true"

Inst49Quest5_QuestID = "11372"
Inst49Quest5_Level = "70"
Inst49Quest5_Attain = "70"


Inst49Quest1_HORDE_QuestID = "10097"
Inst49Quest1_HORDE_Level = Inst49Quest1_Level
Inst49Quest1_HORDE_Attain = Inst49Quest1_Attain

Inst49Quest2_HORDE_QuestID = "10098"
Inst49Quest2_HORDE_Level = Inst49Quest2_Level
Inst49Quest2_HORDE_Attain = Inst49Quest2_Attain

Inst49Quest3_HORDE_QuestID = "11001"
Inst49Quest3_HORDE_Level = Inst49Quest3_Level
Inst49Quest3_HORDE_Attain = Inst49Quest3_Attain
Inst49Quest3PreQuest_HORDE = Inst49Quest3PreQuest

Inst49Quest4_HORDE_QuestID = "9637"
Inst49Quest4_HORDE_Level = Inst49Quest4_Level
Inst49Quest4_HORDE_Attain = Inst49Quest4_Attain
Inst49Quest4PreQuest_HORDE = Inst49Quest4PreQuest

Inst49Quest5_HORDE_QuestID = "11372"
Inst49Quest5_HORDE_Level = Inst49Quest5_Level
Inst49Quest5_HORDE_Attain = Inst49Quest5_Attain



--------------- INST50 - Shadow Labyrinth ---------------

Inst50Quest1_QuestID = "10178"
Inst50Quest1_Level = "70"
Inst50Quest1_Attain = "68"

Inst50Quest2_QuestID = "10091"
Inst50Quest2_Level = "70"
Inst50Quest2_Attain = "68"
Inst50Quest2FQuest = "true"

Inst50Quest3_QuestID = "10649"
Inst50Quest3_Level = "70"
Inst50Quest3_Attain = "68"

Inst50Quest4_QuestID = "10177"
Inst50Quest4_Level = "70"
Inst50Quest4_Attain = "68"

Inst50Quest5_QuestID = "10094"
Inst50Quest5_Level = "70"
Inst50Quest5_Attain = "68"
Inst50Quest5FQuest = "true"

Inst50Quest6_QuestID = "10095"
Inst50Quest6_Level = "70"
Inst50Quest6_Attain = "68"
Inst50Quest6FQuest = "true"

Inst50Quest7_QuestID = "10885"
Inst50Quest7_Level = "70"
Inst50Quest7_Attain = "70"

Inst50Quest8_QuestID = "9831"
Inst50Quest8_Level = "70"
Inst50Quest8_Attain = "68"
Inst50Quest8PreQuest = "true"

Inst50Quest9_QuestID = "10666"
Inst50Quest9_Level = "69"
Inst50Quest9_Attain = "67"
Inst50Quest9PreQuest = "true"

Inst50Quest10_QuestID = "11375"
Inst50Quest10_Level = "70"
Inst50Quest10_Attain = "70"

Inst50Quest11_QuestID = "11376"
Inst50Quest11_Level = "70"
Inst50Quest11_Attain = "70"


Inst50Quest1_HORDE_QuestID = "10178"
Inst50Quest1_HORDE_Level = Inst50Quest1_Level
Inst50Quest1_HORDE_Attain = Inst50Quest1_Attain

Inst50Quest2_HORDE_QuestID = "10091"
Inst50Quest2_HORDE_Level = Inst50Quest2_Level
Inst50Quest2_HORDE_Attain = Inst50Quest2_Attain
Inst50Quest2FQuest_HORDE = Inst50Quest2FQuest

Inst50Quest3_HORDE_QuestID = "10649"
Inst50Quest3_HORDE_Level = Inst50Quest3_Level
Inst50Quest3_HORDE_Attain = Inst50Quest3_Attain

Inst50Quest4_HORDE_QuestID = "10177"
Inst50Quest4_HORDE_Level = Inst50Quest4_Level
Inst50Quest4_HORDE_Attain = Inst50Quest4_Attain

Inst50Quest5_HORDE_QuestID = "10094"
Inst50Quest5_HORDE_Level = Inst50Quest5_Level
Inst50Quest5_HORDE_Attain = Inst50Quest5_Attain
Inst50Quest5FQuest_HORDE = Inst50Quest5FQuest

Inst50Quest6_HORDE_QuestID = "10095"
Inst50Quest6_HORDE_Level = Inst50Quest6_Level
Inst50Quest6_HORDE_Attain = Inst50Quest6_Attain
Inst50Quest6FQuest_HORDE = Inst50Quest6FQuest

Inst50Quest7_HORDE_QuestID = "10885"
Inst50Quest7_HORDE_Level = Inst50Quest7_Level
Inst50Quest7_HORDE_Attain = Inst50Quest7_Attain

Inst50Quest8_HORDE_QuestID = "9831"
Inst50Quest8_HORDE_Level = Inst50Quest8_Level
Inst50Quest8_HORDE_Attain = Inst50Quest8_Attain
Inst50Quest8PreQuest_HORDE = Inst50Quest8PreQuest

Inst50Quest9_HORDE_QuestID = "10666"
Inst50Quest9_HORDE_Level = Inst50Quest9_Level
Inst50Quest9_HORDE_Attain = Inst50Quest9_Attain
Inst50Quest9PreQuest_HORDE = Inst50Quest8PreQuest

Inst50Quest10_HORDE_QuestID = "11375"
Inst50Quest10_HORDE_Level = Inst50Quest10_Level
Inst50Quest10_HORDE_Attain = Inst50Quest10_Attain

Inst50Quest11_HORDE_QuestID = "11376"
Inst50Quest11_HORDE_Level = Inst50Quest11_Level
Inst50Quest11_HORDE_Attain = Inst50Quest11_Attain



--------------- INST51 - Serpentshrine Cavern ---------------

Inst51Quest1_QuestID = "10445"
Inst51Quest1_Level = "70"
Inst51Quest1_Attain = "70"

Inst51Quest2_QuestID = "10944"
Inst51Quest2_Level = "70"
Inst51Quest2_Attain = "70"
Inst51Quest2PreQuest = "true"


Inst51Quest1_HORDE_QuestID = "10445"
Inst51Quest1_HORDE_Level = Inst51Quest1_Level
Inst51Quest1_HORDE_Attain = Inst51Quest1_Attain

Inst51Quest2_HORDE_QuestID = "10944"
Inst51Quest2_HORDE_Level = Inst51Quest2_Level
Inst51Quest2_HORDE_Attain = Inst51Quest2_Attain
Inst51Quest2PreQuest_HORDE = Inst51Quest2PreQuest



--------------- INST52 - Black Morass ---------------

Inst52Quest1_QuestID = "10296"
Inst52Quest1_Level = "70"
Inst52Quest1_Attain = "66"

Inst52Quest2_QuestID = "10297"
Inst52Quest2_Level = "70"
Inst52Quest2_Attain = "66"
Inst52Quest2FQuest = "true"

Inst52Quest3_QuestID = "10298"
Inst52Quest3_Level = "70"
Inst52Quest3_Attain = "66"
Inst52Quest3FQuest = "true"

Inst52Quest4_QuestID = "9836"
Inst52Quest4_Level = "70"
Inst52Quest4_Attain = "68"
Inst52Quest4PreQuest = "true"

Inst52Quest5_QuestID = "10902"
Inst52Quest5_Level = "70"
Inst52Quest5_Attain = "68"
Inst52Quest5PreQuest = "true"

Inst52Quest6_QuestID = "11382"
Inst52Quest6_Level = "70"
Inst52Quest6_Attain = "70"

Inst52Quest7_QuestID = "11383"
Inst52Quest7_Level = "70"
Inst52Quest7_Attain = "70"


Inst52Quest1_HORDE_QuestID = "10296"
Inst52Quest1_HORDE_Level = Inst52Quest1_Level
Inst52Quest1_HORDE_Attain = Inst52Quest1_Attain

Inst52Quest2_HORDE_QuestID = "10297"
Inst52Quest2_HORDE_Level = Inst52Quest2_Level
Inst52Quest2_HORDE_Attain = Inst52Quest2_Attain
Inst52Quest2FQuest_HORDE = Inst52Quest2FQuest

Inst52Quest3_HORDE_QuestID = "10298"
Inst52Quest3_HORDE_Level = Inst52Quest3_Level
Inst52Quest3_HORDE_Attain = Inst52Quest3_Attain
Inst52Quest3FQuest_HORDE = Inst52Quest3FQuest

Inst52Quest4_HORDE_QuestID = "9836"
Inst52Quest4_HORDE_Level = Inst52Quest4_Level
Inst52Quest4_HORDE_Attain = Inst52Quest4_Attain
Inst52Quest4PreQuest_HORDE = Inst52Quest4PreQuest

Inst52Quest5_HORDE_QuestID = "10902"
Inst52Quest5_HORDE_Level = Inst52Quest5_Level
Inst52Quest5_HORDE_Attain = Inst52Quest5_Attain
Inst52Quest5PreQuest_HORDE = Inst52Quest5PreQuest

Inst52Quest6_HORDE_QuestID = "11382"
Inst52Quest6_HORDE_Level = Inst52Quest6_Level
Inst52Quest6_HORDE_Attain = Inst52Quest6_Attain

Inst52Quest7_HORDE_QuestID = "11383"
Inst52Quest7_HORDE_Level = Inst52Quest7_Level
Inst52Quest7_HORDE_Attain = Inst52Quest7_Attain



--------------- INST53 - Battle of Mount Hyjal ---------------

Inst53Quest1_QuestID = "10947"
Inst53Quest1_Level = "70"
Inst53Quest1_Attain = "70"
Inst53Quest1PreQuest = "true"


Inst53Quest1_HORDE_QuestID = "10947"
Inst53Quest1_HORDE_Level = Inst53Quest1_Level
Inst53Quest1_HORDE_Attain = Inst53Quest1_Attain
Inst53Quest1PreQuest_HORDE = Inst53Quest1PreQuest



--------------- INST54 - Old Hillsbrad ---------------

Inst54Quest1_QuestID = "10282"
Inst54Quest1_Level = "68"
Inst54Quest1_Attain = "66"
Inst54Quest1PreQuest = "true"

Inst54Quest2_QuestID = "10283"
Inst54Quest2_Level = "68"
Inst54Quest2_Attain = "66"
Inst54Quest2FQuest = "true"

Inst54Quest3_QuestID = "10284"
Inst54Quest3_Level = "68"
Inst54Quest3_Attain = "66"
Inst54Quest3FQuest = "true"

Inst54Quest4_QuestID = "10285"
Inst54Quest4_Level = "68"
Inst54Quest4_Attain = "66"
Inst54Quest4FQuest = "true"

Inst54Quest5_QuestID = "11378"
Inst54Quest5_Level = "70"
Inst54Quest5_Attain = "70"

Inst54Quest6_QuestID = "12513"
Inst54Quest6_Level = "68"
Inst54Quest6_Attain = "66"


Inst54Quest1_HORDE_QuestID = "10282"
Inst54Quest1_HORDE_Level = Inst54Quest1_Level
Inst54Quest1_HORDE_Attain = Inst54Quest1_Attain
Inst54Quest1PreQuest_HORDE = Inst54Quest1PreQuest

Inst54Quest2_HORDE_QuestID = "10283"
Inst54Quest2_HORDE_Level = Inst54Quest2_Level
Inst54Quest2_HORDE_Attain = Inst54Quest2_Attain
Inst54Quest2FQuest_HORDE = Inst54Quest2FQuest

Inst54Quest3_HORDE_QuestID = "10284"
Inst54Quest3_HORDE_Level = Inst54Quest3_Level
Inst54Quest3_HORDE_Attain = Inst54Quest3_Attain
Inst54Quest3FQuest_HORDE = Inst54Quest3FQuest

Inst54Quest4_HORDE_QuestID = "10285"
Inst54Quest4_HORDE_Level = Inst54Quest4_Level
Inst54Quest4_HORDE_Attain = Inst54Quest4_Attain
Inst54Quest4FQuest_HORDE = Inst54Quest4FQuest

Inst54Quest5_HORDE_QuestID = "11378"
Inst54Quest5_HORDE_Level = Inst54Quest5_Level
Inst54Quest5_HORDE_Attain = Inst54Quest5_Attain

Inst54Quest6_HORDE_QuestID = "12513"
Inst54Quest6_HORDE_Level = Inst54Quest6_Level
Inst54Quest6_HORDE_Attain = Inst54Quest6_Attain



--------------- INST55 - Gruul's Lair ---------------

Inst55Quest1_QuestID = "10901"
Inst55Quest1_Level = "70"
Inst55Quest1_Attain = "70"

Inst55Quest1_HORDE_QuestID = "10901"
Inst55Quest1_HORDE_Level = Inst55Quest1_Level
Inst55Quest1_HORDE_Attain = Inst55Quest1_Attain



--------------- INST56 - Karazhan ---------------

Inst56Quest1_QuestID = "9840"
Inst56Quest1_Level = "70"
Inst56Quest1_Attain = "68"
Inst56Quest1PreQuest = "true"

Inst56Quest2_QuestID = "9843"
Inst56Quest2_Level = "70"
Inst56Quest2_Attain = "68"
Inst56Quest2FQuest = "true"

Inst56Quest3_QuestID = "9844"
Inst56Quest3_Level = "70"
Inst56Quest3_Attain = "68"
Inst56Quest3FQuest = "true"

Inst56Quest4_QuestID = "9860"
Inst56Quest4_Level = "70"
Inst56Quest4_Attain = "68"
Inst56Quest4FQuest = "true"

Inst56Quest5_QuestID = "9630"
Inst56Quest5_Level = "70"
Inst56Quest5_Attain = "70"

Inst56Quest6_QuestID = "9638"
Inst56Quest6_Level = "70"
Inst56Quest6_Attain = "70"
Inst56Quest6FQuest = "true"

Inst56Quest7_QuestID = "9639"
Inst56Quest7_Level = "70"
Inst56Quest7_Attain = "70"
Inst56Quest7FQuest = "true"

Inst56Quest8_QuestID = "9640"
Inst56Quest8_Level = "70"
Inst56Quest8_Attain = "70"
Inst56Quest8FQuest = "true"

Inst56Quest9_QuestID = "9645"
Inst56Quest9_Level = "70"
Inst56Quest9_Attain = "70"
Inst56Quest9FQuest = "true"

Inst56Quest10_QuestID = "9680"
Inst56Quest10_Level = "70"
Inst56Quest10_Attain = "70"
Inst56Quest10FQuest = "true"

Inst56Quest11_QuestID = "9631"
Inst56Quest11_Level = "70"
Inst56Quest11_Attain = "70"
Inst56Quest11FQuest = "true"

Inst56Quest12_QuestID = "9637"
Inst56Quest12_Level = "70"
Inst56Quest12_Attain = "70"
Inst56Quest12FQuest = "true"

Inst56Quest13_QuestID = "9644"
Inst56Quest13_Level = "70"
Inst56Quest13_Attain = "70"
Inst56Quest13FQuest = "true"

Inst56Quest14_QuestID = "10901"
Inst56Quest14_Level = "70"
Inst56Quest14_Attain = "70"

Inst56Quest15_QuestID = "12616"
Inst56Quest15_Level = "70"
Inst56Quest15_Attain = "70"


Inst56Quest1_HORDE_QuestID = "9840"
Inst56Quest1_HORDE_Level = Inst56Quest1_Level
Inst56Quest1_HORDE_Attain = Inst56Quest1_Attain
Inst56Quest1PreQuest_HORDE = Inst56Quest1PreQuest

Inst56Quest2_HORDE_QuestID = "9843"
Inst56Quest2_HORDE_Level = Inst56Quest2_Level
Inst56Quest2_HORDE_Attain = Inst56Quest2_Attain
Inst56Quest2FQuest_HORDE = Inst56Quest2FQuest

Inst56Quest3_HORDE_QuestID = "9844"
Inst56Quest3_HORDE_Level = Inst56Quest3_Level
Inst56Quest3_HORDE_Attain = Inst56Quest3_Attain
Inst56Quest3FQuest_HORDE = Inst56Quest3FQuest

Inst56Quest4_HORDE_QuestID = "9860"
Inst56Quest4_HORDE_Level = Inst56Quest4_Level
Inst56Quest4_HORDE_Attain = Inst56Quest4_Attain
Inst56Quest4FQuest_HORDE = Inst56Quest4FQuest

Inst56Quest5_HORDE_QuestID = "9630"
Inst56Quest5_HORDE_Level = Inst56Quest5_Level
Inst56Quest5_HORDE_Attain = Inst56Quest5_Attain

Inst56Quest6_HORDE_QuestID = "9638"
Inst56Quest6_HORDE_Level = Inst56Quest6_Level
Inst56Quest6_HORDE_Attain = Inst56Quest6_Attain
Inst56Quest6FQuest_HORDE = Inst56Quest6FQuest

Inst56Quest7_HORDE_QuestID = "9639"
Inst56Quest7_HORDE_Level = Inst56Quest7_Level
Inst56Quest7_HORDE_Attain = Inst56Quest7_Attain
Inst56Quest7FQuest_HORDE = Inst56Quest7FQuest

Inst56Quest8_HORDE_QuestID = "9640"
Inst56Quest8_HORDE_Level = Inst56Quest8_Level
Inst56Quest8_HORDE_Attain = Inst56Quest8_Attain
Inst56Quest8FQuest_HORDE = Inst56Quest8FQuest

Inst56Quest9_HORDE_QuestID = "9645"
Inst56Quest9_HORDE_Level = Inst56Quest9_Level
Inst56Quest9_HORDE_Attain = Inst56Quest9_Attain
Inst56Quest9FQuest_HORDE = Inst56Quest9FQuest

Inst56Quest10_HORDE_QuestID = "9680"
Inst56Quest10_HORDE_Level = Inst56Quest10_Level
Inst56Quest10_HORDE_Attain = Inst56Quest10_Attain
Inst56Quest10FQuest_HORDE = Inst56Quest10FQuest

Inst56Quest11_HORDE_QuestID = "9631"
Inst56Quest11_HORDE_Level = Inst56Quest11_Level
Inst56Quest11_HORDE_Attain = Inst56Quest11_Attain
Inst56Quest11FQuest_HORDE = Inst56Quest11FQuest

Inst56Quest12_HORDE_QuestID = "9637"
Inst56Quest12_HORDE_Level = Inst56Quest12_Level
Inst56Quest12_HORDE_Attain = Inst56Quest12_Attain
Inst56Quest12FQuest_HORDE = Inst56Quest12FQuest

Inst56Quest13_HORDE_QuestID = "9644"
Inst56Quest13_HORDE_Level = Inst56Quest13_Level
Inst56Quest13_HORDE_Attain = Inst56Quest13_Attain
Inst56Quest13FQuest_HORDE = Inst56Quest13FQuest

Inst56Quest14_HORDE_QuestID = "10901"
Inst56Quest14_HORDE_Level = Inst56Quest14_Level
Inst56Quest14_HORDE_Attain = Inst56Quest14_Attain

Inst56Quest15_HORDE_QuestID = "12616"
Inst56Quest15_HORDE_Level = Inst56Quest15_Level
Inst56Quest15_HORDE_Attain = Inst56Quest15_Attain



--------------- INST57 - The Arcatraz ---------------

Inst57Quest1_QuestID = "10882"
Inst57Quest1_Level = "70"
Inst57Quest1_Attain = "67"
Inst57Quest1PreQuest = "true"

Inst57Quest2_QuestID = "10705"
Inst57Quest2_Level = "70"
Inst57Quest2_Attain = "68"
Inst57Quest2PreQuest = "true"

Inst57Quest3_QuestID = "10886"
Inst57Quest3_Level = "70"
Inst57Quest3_Attain = "70"

Inst57Quest4_QuestID = "9832"
Inst57Quest4_Level = "70"
Inst57Quest4_Attain = "68"
Inst57Quest4PreQuest = "true"

Inst57Quest5_QuestID = "11388"
Inst57Quest5_Level = "70"
Inst57Quest5_Attain = "70"

Inst57Quest6_QuestID = "11389"
Inst57Quest6_Level = "70"
Inst57Quest6_Attain = "70"


Inst57Quest1_HORDE_QuestID = "10882"
Inst57Quest1_HORDE_Level = Inst57Quest1_Level
Inst57Quest1_HORDE_Attain = Inst57Quest1_Attain
Inst57Quest1PreQuest_HORDE = Inst57Quest1PreQuest

Inst57Quest2_HORDE_QuestID = "10705"
Inst57Quest2_HORDE_Level = Inst57Quest2_Level
Inst57Quest2_HORDE_Attain = Inst57Quest2_Attain
Inst57Quest2PreQuest_HORDE = Inst57Quest2PreQuest

Inst57Quest3_HORDE_QuestID = "10886"
Inst57Quest3_HORDE_Level = Inst57Quest3_Level
Inst57Quest3_HORDE_Attain = Inst57Quest3_Attain

Inst57Quest4_HORDE_QuestID = "9832"
Inst57Quest4_HORDE_Level = Inst57Quest4_Level
Inst57Quest4_HORDE_Attain = Inst57Quest4_Attain
Inst57Quest4PreQuest_HORDE = Inst57Quest4PreQuest

Inst57Quest5_HORDE_QuestID = "11388"
Inst57Quest5_HORDE_Level = Inst57Quest5_Level
Inst57Quest5_HORDE_Attain = Inst57Quest5_Attain

Inst57Quest6_HORDE_QuestID = "11389"
Inst57Quest6_HORDE_Level = Inst57Quest6_Level
Inst57Quest6_HORDE_Attain = Inst57Quest6_Attain



--------------- INST58 - Botanica ---------------

Inst58Quest1_QuestID = "10704"
Inst58Quest1_Level = "70"
Inst58Quest1_Attain = "67"
Inst58Quest1PreQuest = "true"

Inst58Quest2_QuestID = "10257"
Inst58Quest2_Level = "70"
Inst58Quest2_Attain = "67"
Inst58Quest2PreQuest = "true"

Inst58Quest3_QuestID = "10897"
Inst58Quest3_Level = "70"
Inst58Quest3_Attain = "68"
Inst58Quest3PreQuest = "true"

Inst58Quest4_QuestID = "11384"
Inst58Quest4_Level = "70"
Inst58Quest4_Attain = "70"

Inst58Quest5_QuestID = "11385"
Inst58Quest5_Level = "70"
Inst58Quest5_Attain = "70"


Inst58Quest1_HORDE_QuestID = "10704"
Inst58Quest1_HORDE_Level = Inst58Quest1_Level
Inst58Quest1_HORDE_Attain = Inst58Quest1_Attain
Inst58Quest1PreQuest_HORDE = Inst58Quest1PreQuest

Inst58Quest2_HORDE_QuestID = "10257"
Inst58Quest2_HORDE_Level = Inst58Quest2_Level
Inst58Quest2_HORDE_Attain = Inst58Quest2_Attain
Inst58Quest2PreQuest_HORDE = Inst58Quest2PreQuest

Inst58Quest3_HORDE_QuestID = "10897"
Inst58Quest3_HORDE_Level = Inst58Quest3_Level
Inst58Quest3_HORDE_Attain = Inst58Quest3_Attain
Inst58Quest3PreQuest_HORDE = Inst58Quest3PreQuest

Inst58Quest4_HORDE_QuestID = "11384"
Inst58Quest4_HORDE_Level = Inst58Quest4_Level
Inst58Quest4_HORDE_Attain = Inst58Quest4_Attain

Inst58Quest5_HORDE_QuestID = "11385"
Inst58Quest5_HORDE_Level = Inst58Quest5_Level
Inst58Quest5_HORDE_Attain = Inst58Quest5_Attain



--------------- INST59 - The Mechanar ---------------

Inst59Quest1_QuestID = "10704"
Inst59Quest1_Level = "70"
Inst59Quest1_Attain = "67"
Inst59Quest1PreQuest = "true"

Inst59Quest2_QuestID = "10665"
Inst59Quest2_Level = "69"
Inst59Quest2_Attain = "67"
Inst59Quest2PreQuest = "true"

Inst59Quest3_QuestID = "11386"
Inst59Quest3_Level = "70"
Inst59Quest3_Attain = "70"

Inst59Quest4_QuestID = "11387"
Inst59Quest4_Level = "70"
Inst59Quest4_Attain = "70"


Inst59Quest1_HORDE_QuestID = "10704"
Inst59Quest1_HORDE_Level = Inst59Quest1_Level
Inst59Quest1_HORDE_Attain = Inst59Quest1_Attain
Inst59Quest1PreQuest_HORDE = Inst59Quest1PreQuest

Inst59Quest2_HORDE_QuestID = "10665"
Inst59Quest2_HORDE_Level = Inst59Quest2_Level
Inst59Quest2_HORDE_Attain = Inst59Quest2_Attain
Inst59Quest2PreQuest_HORDE = Inst59Quest2PreQuest

Inst59Quest3_HORDE_QuestID = "11386"
Inst59Quest3_HORDE_Level = Inst59Quest3_Level
Inst59Quest3_HORDE_Attain = Inst59Quest3_Attain

Inst59Quest4_HORDE_QuestID = "11387"
Inst59Quest4_HORDE_Level = Inst59Quest4_Level
Inst59Quest4_HORDE_Attain = Inst59Quest4_Attain



--------------- INST60 - Eye of the Storm ---------------

Inst60Quest1_QuestID = "11337"
Inst60Quest1_Level = "61"
Inst60Quest1_Attain = "61"

Inst60Quest1_HORDE_QuestID = "11341"
Inst60Quest1_HORDE_Level = "61"
Inst60Quest1_HORDE_Attain = "61"



--------------- INST61 - The Eye ---------------

Inst61Quest1_QuestID = "10946"
Inst61Quest1_Level = "70"
Inst61Quest1_Attain = "70"
Inst61Quest1PreQuest = "true"

Inst61Quest2_QuestID = "11007"
Inst61Quest2_Level = "70"
Inst61Quest2_Attain = "70"

Inst61Quest3_QuestID = "10445"
Inst61Quest3_Level = "70"
Inst61Quest3_Attain = "70"


Inst61Quest1_HORDE_QuestID = "10946"
Inst61Quest1_HORDE_Level = Inst61Quest1_Level
Inst61Quest1_HORDE_Attain = Inst61Quest1_Attain
Inst61Quest1PreQuest_HORDE = Inst61Quest1PreQuest

Inst61Quest2_HORDE_QuestID = "11007"
Inst61Quest2_HORDE_Level = Inst61Quest2_Level
Inst61Quest2_HORDE_Attain = Inst61Quest2_Attain

Inst61Quest3_HORDE_QuestID = "10445"
Inst61Quest3_HORDE_Level = Inst61Quest3_Level
Inst61Quest3_HORDE_Attain = Inst61Quest3_Attain



--------------- INST62 - Black Temple ---------------

Inst62Quest1_QuestID = "10958"
Inst62Quest1_Level = "70"
Inst62Quest1_Attain = "70"
Inst62Quest1PreQuest = "true"

Inst62Quest2_QuestID = "10957"
Inst62Quest2_Level = "70"
Inst62Quest2_Attain = "70"
Inst62Quest2FQuest = "true"

Inst62Quest3_QuestID = "10959"
Inst62Quest3_Level = "70"
Inst62Quest3_Attain = "70"
Inst62Quest3FQuest = "true"


Inst62Quest1_HORDE_QuestID = "10958"
Inst62Quest1_HORDE_Level = Inst62Quest1_Level
Inst62Quest1_HORDE_Attain = Inst62Quest1_Attain
Inst62Quest1PreQuest_HORDE = Inst62Quest1PreQuest

Inst62Quest2_HORDE_QuestID = "10957"
Inst62Quest2_HORDE_Level = Inst62Quest2_Level
Inst62Quest2_HORDE_Attain = Inst62Quest2_Attain
Inst62Quest2FQuest_HORDE = Inst62Quest2FQuest

Inst62Quest3_HORDE_QuestID = "10959"
Inst62Quest3_HORDE_Level = Inst62Quest3_Level
Inst62Quest3_HORDE_Attain = Inst62Quest3_Attain
Inst62Quest3FQuest_HORDE = Inst62Quest3FQuest



--------------- INST63 - Zul'Aman ---------------

Inst63Quest1_QuestID = "11132"
Inst63Quest1_Level = "70"
Inst63Quest1_Attain = "70"
Inst63Quest1PreQuest = "true"

Inst63Quest2_QuestID = "11166"
Inst63Quest2_Level = "70"
Inst63Quest2_Attain = "70"
Inst63Quest2FQuest = "true"

Inst63Quest3_QuestID = "11171"
Inst63Quest3_Level = "70"
Inst63Quest3_Attain = "70"
Inst63Quest3FQuest = "true"

Inst63Quest4_QuestID = "11164"
Inst63Quest4_Level = "70"
Inst63Quest4_Attain = "70"

Inst63Quest5_QuestID = "11165"
Inst63Quest5_Level = "70"
Inst63Quest5_Attain = "70"
Inst63Quest5FQuest = "true"

Inst63Quest6_QuestID = "11195"
Inst63Quest6_Level = "70"
Inst63Quest6_Attain = "70"
Inst63Quest6FQuest = "true"

Inst63Quest7_QuestID = "11178"
Inst63Quest7_Level = "70"
Inst63Quest7_Attain = "70"

Inst63Quest8_QuestID = "11163"
Inst63Quest8_Level = "70"
Inst63Quest8_Attain = "70"
Inst63Quest8FQuest = "true"


Inst63Quest1_HORDE_QuestID = "11132"
Inst63Quest1_HORDE_Level = Inst63Quest1_Level
Inst63Quest1_HORDE_Attain = Inst63Quest1_Attain
Inst63Quest1PreQuest_HORDE = Inst63Quest1PreQuest

Inst63Quest2_HORDE_QuestID = "11166"
Inst63Quest2_HORDE_Level = Inst63Quest2_Level
Inst63Quest2_HORDE_Attain = Inst63Quest2_Attain
Inst63Quest2FQuest_HORDE = Inst63Quest2FQuest

Inst63Quest3_HORDE_QuestID = "11171"
Inst63Quest3_HORDE_Level = Inst63Quest3_Level
Inst63Quest3_HORDE_Attain = Inst63Quest3_Attain
Inst63Quest3FQuest_HORDE = Inst63Quest3FQuest

Inst63Quest4_HORDE_QuestID = "11164"
Inst63Quest4_HORDE_Level = Inst63Quest4_Level
Inst63Quest4_HORDE_Attain = Inst63Quest4_Attain

Inst63Quest5_HORDE_QuestID = "11165"
Inst63Quest5_HORDE_Level = Inst63Quest5_Level
Inst63Quest5_HORDE_Attain = Inst63Quest5_Attain
Inst63Quest5FQuest_HORDE = Inst63Quest5FQuest

Inst63Quest6_HORDE_QuestID = "11195"
Inst63Quest6_HORDE_Level = Inst63Quest6_Level
Inst63Quest6_HORDE_Attain = Inst63Quest6_Attain
Inst63Quest6FQuest_HORDE = Inst63Quest6FQuest

Inst63Quest7_HORDE_QuestID = "11178"
Inst63Quest7_HORDE_Level = Inst63Quest7_Level
Inst63Quest7_HORDE_Attain = Inst63Quest7_Attain

Inst63Quest8_HORDE_QuestID = "11163"
Inst63Quest8_HORDE_Level = Inst63Quest8_Level
Inst63Quest8_HORDE_Attain = Inst63Quest8_Attain
Inst63Quest8FQuest_HORDE = Inst63Quest8FQuest



--------------- INST65 - Skettis ---------------

Inst65Quest1_QuestID = "11098"
Inst65Quest1_Level = "70"
Inst65Quest1_Attain = "70"
Inst65Quest1PreQuest = "true"

Inst65Quest2_QuestID = "11008"
Inst65Quest2_Level = "70"
Inst65Quest2_Attain = "70"
Inst65Quest2PreQuest = "true"

Inst65Quest3_QuestID = "11085"
Inst65Quest3_Level = "70"
Inst65Quest3_Attain = "70"

Inst65Quest4_QuestID = "11093"
Inst65Quest4_Level = "70"
Inst65Quest4_Attain = "70"

Inst65Quest5_QuestID = "11004"
Inst65Quest5_Level = "70"
Inst65Quest5_Attain = "70"

Inst65Quest6_QuestID = "11005"
Inst65Quest6_Level = "70"
Inst65Quest6_Attain = "70"
Inst65Quest6PreQuest = "true"

Inst65Quest7_QuestID = "11021"
Inst65Quest7_Level = "70"
Inst65Quest7_Attain = "70"

Inst65Quest8_QuestID = "11024"
Inst65Quest8_Level = "70"
Inst65Quest8_Attain = "70"
Inst65Quest8FQuest = "true"

Inst65Quest9_QuestID = "11028"
Inst65Quest9_Level = "70"
Inst65Quest9_Attain = "70"
Inst65Quest9FQuest = "true"

Inst65Quest10_QuestID = "11056"
Inst65Quest10_Level = "70"
Inst65Quest10_Attain = "70"
Inst65Quest10FQuest = "true"

Inst65Quest11_QuestID = "11029"
Inst65Quest11_Level = "70"
Inst65Quest11_Attain = "70"
Inst65Quest11FQuest = "true"

Inst65Quest12_QuestID = "11885"
Inst65Quest12_Level = "70"
Inst65Quest12_Attain = "70"
Inst65Quest12FQuest = "true"

Inst65Quest13_QuestID = "11073"
Inst65Quest13_Level = "70"
Inst65Quest13_Attain = "70"
Inst65Quest13PreQuest = "true"


Inst65Quest1_HORDE_QuestID = "11098"
Inst65Quest1_HORDE_Level = Inst65Quest1_Level
Inst65Quest1_HORDE_Attain = Inst65Quest1_Attain
Inst65Quest1PreQuest_HORDE = Inst65Quest1PreQuest

Inst65Quest2_HORDE_QuestID = "11008"
Inst65Quest2_HORDE_Level = Inst65Quest2_Level
Inst65Quest2_HORDE_Attain = Inst65Quest2_Attain
Inst65Quest2PreQuest_HORDE = Inst65Quest2PreQuest

Inst65Quest3_HORDE_QuestID = "11085"
Inst65Quest3_HORDE_Level = Inst65Quest3_Level
Inst65Quest3_HORDE_Attain = Inst65Quest3_Attain

Inst65Quest4_HORDE_QuestID = "11093"
Inst65Quest4_HORDE_Level = Inst65Quest4_Level
Inst65Quest4_HORDE_Attain = Inst65Quest4_Attain

Inst65Quest5_HORDE_QuestID = "11004"
Inst65Quest5_HORDE_Level = Inst65Quest5_Level
Inst65Quest5_HORDE_Attain = Inst65Quest5_Attain

Inst65Quest6_HORDE_QuestID = "11005"
Inst65Quest6_HORDE_Level = Inst65Quest6_Level
Inst65Quest6_HORDE_Attain = Inst65Quest6_Attain
Inst65Quest6PreQuest_HORDE = Inst65Quest6PreQuest

Inst65Quest7_HORDE_QuestID = "11021"
Inst65Quest7_HORDE_Level = Inst65Quest7_Level
Inst65Quest7_HORDE_Attain = Inst65Quest7_Attain

Inst65Quest8_HORDE_QuestID = "11024"
Inst65Quest8_HORDE_Level = Inst65Quest8_Level
Inst65Quest8_HORDE_Attain = Inst65Quest8_Attain
Inst65Quest8FQuest_HORDE = Inst65Quest8FQuest

Inst65Quest9_HORDE_QuestID = "11028"
Inst65Quest9_HORDE_Level = Inst65Quest9_Level
Inst65Quest9_HORDE_Attain = Inst65Quest9_Attain
Inst65Quest9FQuest_HORDE = Inst65Quest9FQuest

Inst65Quest10_HORDE_QuestID = "11056"
Inst65Quest10_HORDE_Level = Inst65Quest10_Level
Inst65Quest10_HORDE_Attain = Inst65Quest10_Attain
Inst65Quest10FQuest_HORDE = Inst65Quest10FQuest

Inst65Quest11_HORDE_QuestID = "11029"
Inst65Quest11_HORDE_Level = Inst65Quest11_Level
Inst65Quest11_HORDE_Attain = Inst65Quest11_Attain
Inst65Quest11FQuest_HORDE = Inst65Quest11FQuest

Inst65Quest12_HORDE_QuestID = "11885"
Inst65Quest12_HORDE_Level = Inst65Quest12_Level
Inst65Quest12_HORDE_Attain = Inst65Quest12_Attain
Inst65Quest12FQuest_HORDE = Inst65Quest12FQuest

Inst65Quest13_HORDE_QuestID = "11073"
Inst65Quest13_HORDE_Level = Inst65Quest13_Level
Inst65Quest13_HORDE_Attain = Inst65Quest13_Attain
Inst65Quest13FQuest_HORDE = Inst65Quest13FQuest



--------------- INST67 - Magisters' Terrace ---------------

Inst67Quest1_QuestID = "11500"
Inst67Quest1_Level = "70"
Inst67Quest1_Attain = "70"

Inst67Quest2_QuestID = "11499"
Inst67Quest2_Level = "70"
Inst67Quest2_Attain = "70"

Inst67Quest3_QuestID = "11488"
Inst67Quest3_Level = "70"
Inst67Quest3_Attain = "70"
Inst67Quest3PreQuest = "true"

Inst67Quest4_QuestID = "11490"
Inst67Quest4_Level = "70"
Inst67Quest4_Attain = "70"
Inst67Quest4FQuest = "true"

Inst67Quest5_QuestID = "11492"
Inst67Quest5_Level = "70"
Inst67Quest5_Attain = "70"
Inst67Quest5FQuest = "true"


Inst67Quest1_HORDE_QuestID = "11500"
Inst67Quest1_HORDE_Level = Inst67Quest1_Level
Inst67Quest1_HORDE_Attain = Inst67Quest1_Attain

Inst67Quest2_HORDE_QuestID = "11499"
Inst67Quest2_HORDE_Level = Inst67Quest2_Level
Inst67Quest2_HORDE_Attain = Inst67Quest2_Attain

Inst67Quest3_HORDE_QuestID = "11488"
Inst67Quest3_HORDE_Level = Inst67Quest3_Level
Inst67Quest3_HORDE_Attain = Inst67Quest3_Attain
Inst67Quest3PreQuest_HORDE = Inst67Quest3PreQuest

Inst67Quest4_HORDE_QuestID = "11490"
Inst67Quest4_HORDE_Level = Inst67Quest4_Level
Inst67Quest4_HORDE_Attain = Inst67Quest4_Attain
Inst67Quest4FQuest_HORDE = Inst67Quest4FQuest

Inst67Quest5_HORDE_QuestID = "11492"
Inst67Quest5_HORDE_Level = Inst67Quest5_Level
Inst67Quest5_HORDE_Attain = Inst67Quest5_Attain
Inst67Quest5FQuest_HORDE = Inst67Quest5FQuest



--------------- INST68 - Sunwell Plateau ---------------

-- No quests.










-- Its the end of the file as we know it.  And I feel fine!
