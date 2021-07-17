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
if ( GetLocale() == "frFR" ) then
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

AQOptionsCaptionTEXT = ""..YELLOW.."Options AtlasQuest";
AQ_OK = "OK";

-- Autoshow
AQOptionsAutoshowTEXT = ""..WHITE.."
Afficher le panneau AtlasQuest avec "..RED.."Atlas"..WHITE..".";
AQAtlasAutoON = "Le panneau AtlasQuest s'affiche automatiquement lorsque l'atlas est ouvert."..GREEN.."(défaut)";
AQAtlasAutoOFF = "Le panneau AtlasQuest "..RED.."Aucun"..WHITE.." montrera quand l'atlas est ouvert."

-- Right/Left
AQOptionsLEFTTEXT = ""..WHITE.."Montrez le panneau AtlasQuest au "..RED.."gauche"..WHITE..".";
AQOptionsRIGHTTEXT = ""..WHITE.."Montrez le panneau AtlasQuest au "..RED.."droite"..WHITE..".";
AQShowRight = "Afficher le panneau AtlasQuest sur le côté "..RED.."droite";
AQShowLeft = "Afficher le panneau AtlasQuest sur le côté "..RED.."gauche"..GREEN.."(défaut)";

-- Colour Check
AQOptionsCCTEXT = ""..WHITE.."Colorez les quêtes en fonction de leurs niveaux.";
AQCCON = "AtlasQuest coloriera les quêtes en fonction de leurs niveaux."
AQCCOFF = "AtlasQuest ne colorera pas les quêtes."


-- QuestLog Colour Check
AQQLColourChange = ""..WHITE.."Colorez toutes les quêtes que vous avez dans votre journal de quête "..BLUE.."bleu.";

-- AutoQuery Quest Rewards
AQOptionsAutoQueryTEXT = ""..WHITE.."Recherchez automatiquement sur le serveur les objets que vous n'avez pas vus.";

-- Suppress Server Query text
AQOptionsNoQuerySpamTEXT = ""..WHITE.."Pour le spam de requête du serveur.";

-- Use Comparison Tooltips
AQOptionsCompareTooltipTEXT = ""..WHITE.."DÉSACTIVER la comparaison des récompenses avec l'équipement que vous transportez.";

-- Quest Query text
AQQuestQueryButtonTEXT = ""..WHITE.."Requete";
AQClearQuestAndQueryButtonTEXT = ""..WHITE.."Réinitialiser";
AQQuestQueryTEXT = ""..WHITE.."Vérifiez le serveur pour les quêtes complètes.";
AQClearQuestAndQueryTEXT = ""..WHITE.."Réinitialisez les quêtes complètes et consultez le serveur pour obtenir une liste des quêtes complètes.";
AQQuestQueryStart = "AtlasQuest recherce le serveur pour des quêtes complètes.";
AQQuestQueryDone = "AtlasQuest finit déjà par rechercer le serveur. Les missions complètes doivent être marquées.";


AQAbilities = BLUE .. "Compétence:" .. WHITE;
AQSERVERASKInformation = " Veuillez faire un clic droit jusqu'à ce que vous voyiez le cadre.";
AQSERVERASKAuto = " Déplacez le pointeur sur l'objet en une seconde.";
AQSERVERASK = "AtlasQuest recherce le serveur: ";
AQERRORNOTSHOWN = "Cet objet n'est pas sécurisé !";
AQERRORASKSERVER = "Faites un clic droit pour consulter le serveur. Vous êtes peut-être déconnecté.";
AQOptionB = "Options";
AQNoReward = ""..BLUE.." Il n'y a aucune récompense";
AQDiscription_REWARD = ""..BLUE.." Récompense: ";
AQDiscription_OR = ""..GREY.." ou "..WHITE.."";
AQDiscription_AND = ""..GREY.." et "..WHITE.."";
AQDiscription_ATTAIN = "Requis : ";
AQDiscription_LEVEL = "Niveau : ";
AQDiscription_START = "Début : ";
AQDiscription_AIM = "Objectif : ";
AQDiscription_NOTE = "Remarque : ";
AQDiscription_PREQUEST= "Quête requise : ";
AQDiscription_FOLGEQUEST = "Prochaine quête : ";
AQFinishedTEXT = "Quête terminée : ";


------------------
--- ITEM TYPES ---
------------------

AQITEM_DAGGER = " Dague"
AQITEM_POLEARM = " Arme d'hast"
AQITEM_SWORD = " Epée"
AQITEM_AXE = " Hache"
AQITEM_WAND = "Baguette"
AQITEM_STAFF = "Bâton"
AQITEM_MACE = " Masse"
AQITEM_SHIELD = "Bouclier"
AQITEM_GUN = "Arme à feu"
AQITEM_BOW = "Arc"
AQITEM_CROSSBOW = "Arbalète"
AQITEM_THROWN = "Armes de jet"

AQITEM_WAIST = "Taille,"
AQITEM_SHOULDER = "Épaules,"
AQITEM_CHEST = "Torse,"
AQITEM_LEGS = "Jambes,"
AQITEM_HANDS = "Mains,"
AQITEM_FEET = "Pieds,"
AQITEM_WRIST = "Poignets,"
AQITEM_HEAD = "Tête,"
AQITEM_BACK = "Dos"
AQITEM_TABARD = "Tabard"

AQITEM_CLOTH = " Tissu"
AQITEM_LEATHER = " Cuir"
AQITEM_MAIL = " Mailles"
AQITEM_PLATE = " Plaques"

AQITEM_OFFHAND = "Main gauche"
AQITEM_MAINHAND = "Main droite,"
AQITEM_ONEHAND = "Une main,"
AQITEM_TWOHAND = "Deux mains,"

AQITEM_ITEM = "Objet" -- Use this for those oddball rewards which aren't really anything else.
AQITEM_TRINKET = "Bijou"
AQITEM_RELIC = "Relique"
AQITEM_POTION = "Potion"
AQITEM_OFFHAND = "Tenu(e) en main gauche"
AQITEM_NECK = "Cou"
AQITEM_PATTERN = "Patron"
AQITEM_BAG = "Sac"
AQITEM_RING = "Doigt"
AQITEM_KEY = "Clé"
AQITEM_QUIVER = "Carquois"
AQITEM_AMMOPOUCH = "Giberne"
AQITEM_ENCHANT = "Enchantement"
AQITEM_SPELL = "Sort"




--------------- INST66 - No Instance ---------------

-- Just to display "No Quests" when the map is set to something AtlasQuest does not support.
Inst66Caption = "Il n'y a aucune information"
Inst66QAA = "Pas de quête"
Inst66QAH = "Pas de quête"

end

-- End of File
