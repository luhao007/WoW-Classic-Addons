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
if ( GetLocale() == "esMX" ) then
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

AQOptionsCaptionTEXT = ""..YELLOW.."Opciones de AtlasQuest";
AQ_OK = "OK";

-- Autoshow
AQOptionsAutoshowTEXT = ""..WHITE.."Mostrar el panel de AtlasQuest con "..RED.."Atlas"..WHITE..".";
AQAtlasAutoON = "El panel de AtlasQuest mostrará automáticamente cuando atlas está abierto."..GREEN.."(predeterminado)";
AQAtlasAutoOFF = "El panel de AtlasQuest "..RED.."Ninguno"..WHITE.." mostrará cuando atlas está abierto."

-- Right/Left
AQOptionsLEFTTEXT = ""..WHITE.."Mostrar el panel de AtlasQuest a la "..RED.."izquierda"..WHITE..".";
AQOptionsRIGHTTEXT = ""..WHITE.."Mostrar el panel de AtlasQuest a la "..RED.."derecha"..WHITE..".";
AQShowRight = "Muestra el panel de AtlasQuest al lado "..RED.."derecho";
AQShowLeft = "Muestra el panel de AtlasQuest al lado "..RED.."izquierdo"..GREEN.."(predeterminado)";

-- Colour Check
AQOptionsCCTEXT = ""..WHITE.."Colorea las misiones dependiendo de sus niveles.";
AQCCON = "AtlasQuest coloreará las misiones depeiendo de sus niveles."
AQCCOFF = "AtlasQuest no coloreará las misiones."


-- QuestLog Colour Check
AQQLColourChange = ""..WHITE.."Colorea todas las misiones que tienes en tu Registro de misión "..BLUE.."azules.";

-- AutoQuery Quest Rewards
AQOptionsAutoQueryTEXT = ""..WHITE.."Consulta el servidor automáticamente para los objetos que no has visto.";

-- Suppress Server Query text
AQOptionsNoQuerySpamTEXT = ""..WHITE.."Para el spam de Consulta del servidor.";

-- Use Comparison Tooltips
AQOptionsCompareTooltipTEXT = ""..WHITE.."DESACTIVADO comparar las recompensas a los equipos que llevas.";

-- Quest Query text
AQQuestQueryButtonTEXT = ""..WHITE.."Consulta";
AQClearQuestAndQueryButtonTEXT = ""..WHITE.."Reiniciar";
AQQuestQueryTEXT = ""..WHITE.."Consulta el servidor para misiones completas.";
AQClearQuestAndQueryTEXT = ""..WHITE.."Reinicia misiones completas y consulta el servidor para una lista de misiones completas.";
AQQuestQueryStart = "AtlasQuest está consultando el servidor para misiones completas.";
AQQuestQueryDone = "AtlasQuest ya termina consultando el servidor. Debe ser marcadas las misiones completas.";


AQAbilities = BLUE .. "Habilidades:" .. WHITE;
AQSERVERASKInformation = " Por favor haga clic derecho hasta que veas el marco.";
AQSERVERASKAuto = " Mueva el puntero sobre el objeto en un segundo.";
AQSERVERASK = "AtlasQuest está consultando el servidor: ";
AQERRORNOTSHOWN = "¡Este objeto no es seguro!";
AQERRORASKSERVER = "Clic-derecho para consultar el servidor. Es posible que desconectarás.";
AQOptionB = "Opciones";
AQNoReward = ""..BLUE.." No hay recompensas";
AQDiscription_REWARD = ""..BLUE.." Recompensa: ";
AQDiscription_OR = ""..GREY.." o "..WHITE.."";
AQDiscription_AND = ""..GREY.." y "..WHITE.."";
AQDiscription_ATTAIN = "Conseguir: ";
AQDiscription_LEVEL = "Nivel: ";
AQDiscription_START = "Empieza: \n";
AQDiscription_AIM = "Objetivo: \n";
AQDiscription_NOTE = "Nota: \n";
AQDiscription_PREQUEST= "Misión previa: ";
AQDiscription_FOLGEQUEST = "Misión siguiente: ";
AQFinishedTEXT = "Misión completa: ";


------------------
--- ITEM TYPES ---
------------------

AQITEM_DAGGER = " Daga"
AQITEM_POLEARM = " Arma de asta"
AQITEM_SWORD = " Espada"
AQITEM_AXE = " Hacha"
AQITEM_WAND = "Varita"
AQITEM_STAFF = "Bastón"
AQITEM_MACE = " Maza"
AQITEM_SHIELD = "Escudo"
AQITEM_GUN = "Arma de fuego"
AQITEM_BOW = "Arco"
AQITEM_CROSSBOW = "Ballesta"
AQITEM_THROWN = "Arma arrojadiza"

AQITEM_WAIST = "Cintura,"
AQITEM_SHOULDER = "Hombro,"
AQITEM_CHEST = "Pecho,"
AQITEM_LEGS = "Piernas,"
AQITEM_HANDS = "Manos,"
AQITEM_FEET = "Pies,"
AQITEM_WRIST = "Muñeca,"
AQITEM_HEAD = "Cabeza,"
AQITEM_BACK = "Atrás"
AQITEM_TABARD = "Tabardo"

AQITEM_CLOTH = " Tela"
AQITEM_LEATHER = " Cuero"
AQITEM_MAIL = " Mallas"
AQITEM_PLATE = " Placas"

AQITEM_OFFHAND = "Mano secundaria"
AQITEM_MAINHAND = "Mano principal,"
AQITEM_ONEHAND = "Una mano,"
AQITEM_TWOHAND = "Dos manos,"

AQITEM_ITEM = "Objeto" -- Use this for those oddball rewards which aren't really anything else.
AQITEM_TRINKET = "Alhaja"
AQITEM_RELIC = "Reliquia"
AQITEM_POTION = "Poción"
AQITEM_OFFHAND = "Sostener con la mano izquierda"
AQITEM_NECK = "Cuello"
AQITEM_PATTERN = "Patrón"
AQITEM_BAG = "Bolsa"
AQITEM_RING = "Dedo"
AQITEM_KEY = "Llave"
AQITEM_QUIVER = "Carcaj"
AQITEM_AMMOPOUCH = "Bolsa de munición"
AQITEM_ENCHANT = "Encanta"
AQITEM_SPELL = "Hechizo"




--------------- INST66 - No Instance ---------------

-- Just to display "No Quests" when the map is set to something AtlasQuest does not support.
Inst66Caption = "No Hay Información"
Inst66QAA = "No Hay Misiones"
Inst66QAH = "No Hay Misiones"

end

-- End of File
