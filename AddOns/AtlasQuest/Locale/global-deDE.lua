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


------------  GLOBALS  ------------


This file is for storing global strings as well as some things that don't fit
very well in the other localization files.


--]]



if ( GetLocale() == "deDE" ) then

---------------
--- COLOURS ---
---------------

local GREY = "|cff999999";
local RED = "|cffff0000";
local ATLAS_RED = "|cffcc3333";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff66cc33";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local DARKYELLOW = "|cffcc9933";  -- Atlas uses this color for some things.
local YELLOW = "|cffFFd200";   -- Ingame Yellow



---------------
--- OPTIONS ---
---------------

AQOptionsCaptionTEXT = ""..YELLOW.."AtlasQuest-Optionen";
AQ_OK = "OK";

-- Autoshow
AQOptionsAutoshowTEXT = ""..WHITE.."Zeige AtlasQuest-Panel mit "..RED.."Atlas"..WHITE..".";
AQAtlasAutoON = "Das AtlasQuest-Panel wird jetzt mit Atlas angezeigt "..GREEN.."(Standard)"
AQAtlasAutoOFF = "Das AtlasQuest-Panel wird jetzt "..RED.."nicht"..WHITE.." mehr beim Öffnen von Atlas angezeigt"

-- Right/Left
AQOptionsLEFTTEXT = ""..WHITE.."Zeige das AtlasQuest-Panel "..RED.."links"..WHITE..".";
AQOptionsRIGHTTEXT = ""..WHITE.."Zeige das AtlasQuest-Panel "..RED.."rechts"..WHITE..".";
AQShowRight = "Das AtlasQuest-Panel wird nun auf der "..RED.."rechten"..WHITE.." Seite angezeigt";
AQShowLeft = "Das AtlasQuest-Panel wird nun auf der "..RED.."linken"..WHITE.." Seite angezeigt "..GREEN.."(Standard)";

-- Colour Check
AQOptionsCCTEXT = ""..WHITE.."Die Quests nach dem Questlevel färben."
AQCCON = "Die Quests werden jetzt nach dem Questlevel gefärbt."
AQCCOFF = "Die Quests werden jetzt nicht mehr nach dem Questlevel gefärbt."

-- QuestLog Colour Check
AQQLColourChange = ""..WHITE.."Alle Quests, die in deinem Questlog sind "..BLUE.."blau"..WHITE.." färben."

-- AutoQuery Quest Rewards
AQOptionsAutoQueryTEXT = ""..WHITE.."Den Server automatisch nach den Gegenständen abfragen, die man noch nicht gesehen hat."

-- Suppress Server Query text
AQOptionsNoQuerySpamTEXT = ""..WHITE.."Die Textmeldungen bei der Serverabfrage unterdrücken."

-- Use Comparison Tooltips
AQOptionsCompareTooltipTEXT = ""..WHITE.."Die Belohnungen mit den derzeit angelegten Gegenständen vergleichen."

-- Quest Query text
AQQuestQueryButtonTEXT = ""..WHITE.."Quest Abfrage";
AQClearQuestAndQueryButtonTEXT = ""..WHITE.."Questreset";
AQQuestQueryTEXT = ""..WHITE.."Abfrage des Servers nach abgeschlossenen Quests.";
AQClearQuestAndQueryTEXT = ""..WHITE.."Zurücksetzen der abgeschlossenen Quests und Serverabfrage.";
AQQuestQueryStart = "AtlasQuest fragt den Server nach abgeschlossenen Quests ab. Dies wird einen kurzen Moment dauern.";
AQQuestQueryDone = "AtlasQuest hat die Anfrage beendet. Abgeschlossene Quests sind nun markiert." ;


AQAbilities = BLUE.."Fähigkeiten:".. WHITE;
AQSERVERASKInformation = "Bitte rechtsklicken bis der Gegenstand angezeigt wird."
AQSERVERASKAuto = "Versuche den Mauszeiger in einer Sekunde über den Gegenstand zu bewegen.";
AQSERVERASK = "AtlasQuest fragt den Server nach folgendem Gegenstand ab:";
AQERRORNOTSHOWN = "Dieser Gegenstand ist nicht sicher!";
AQERRORASKSERVER = "Klicke rechts um den Server nach diesem Gegenstand abzufragen. Es kann passieren, dass die Verbindung unterbrochen wird.";
AQOptionB = "Optionen";
AQNoReward = ""..BLUE.."Keine Belohnung"
AQDiscription_REWARD = ""..BLUE.."Belohnung:";
AQDiscription_OR = ""..GREY.." oder "..WHITE.."";
AQDiscription_AND = ""..GREY.." und "..WHITE.."";
AQDiscription_ATTAIN = "Benötigte Stufe:";
AQDiscription_LEVEL = "Stufe:";
AQDiscription_START = "Beginnt bei/in: \n";
AQDiscription_AIM = "Ziel: \n";
AQDiscription_NOTE = "Informationen: \n";
AQDiscription_PREQUEST = "Vorquest:";
AQDiscription_FOLGEQUEST = "Folgequest:";
AQFinishedTEXT = "Abgeschlossen:";


------------------
--- ITEM TYPES ---
------------------

AQITEM_DAGGER = "Dolch"
AQITEM_POLEARM = "Stangenwaffe"
AQITEM_SWORD = "Schwert"
AQITEM_AXE = "Axt"
AQITEM_WAND = "Zauberstab"
AQITEM_STAFF = "Stab"
AQITEM_MACE = "Streitkolben"
AQITEM_SHIELD = "Schild"
AQITEM_GUN = "Schusswaffe"
AQITEM_BOW = "Bogen"
AQITEM_CROSSBOW = "Armbrust"
AQITEM_THROWN = "Wurfwaffe"

AQITEM_WAIST = "Taille,"
AQITEM_SHOULDER = "Schultern,"
AQITEM_CHEST = "Brust,"
AQITEM_LEGS = "Beine,"
AQITEM_HANDS = "Hände,"
AQITEM_FEET = "Füße,"
AQITEM_WRIST = "Handgelenke,"
AQITEM_HEAD = "Kopf,"
AQITEM_BACK = "Rücken"
AQITEM_TABARD = "Wappenrock"

AQITEM_CLOTH = "Stoff"
AQITEM_LEATHER = "Leder"
AQITEM_MAIL = "Schwere Rüstung"
AQITEM_PLATE = "Platte"

AQITEM_OFFHAND = "Nebenhand"
AQITEM_MAINHAND = "Waffenhand,"
AQITEM_ONEHAND = "Einhändig,"
AQITEM_TWOHAND = "Zweihändig,"

AQITEM_ITEM = "Gegenstand" -- Use this for those oddball rewards which aren't really anything else.
AQITEM_PET = "Haustier"
AQITEM_TRINKET = "Schmuck"
AQITEM_POTION = "Trank"
AQITEM_NECK = "Hals"
AQITEM_PATTERN = "Muster"
AQITEM_BAG = "Tasche"
AQITEM_RING = "Ring"
AQITEM_ENCHANT = "Verzauberung"
AQITEM_SPELL = "Zauber"




--------------- INST66 - No Instance ---------------

-- Just to display "No Quests" when the map is set to something AtlasQuest does not support.
Inst66Caption = "Keine Informationen verfügbar"
Inst66QAA = "Keine Quests"
Inst66QAH = "Keine Quests"


end
-- End of File
