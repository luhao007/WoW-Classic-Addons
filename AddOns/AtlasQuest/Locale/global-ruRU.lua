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
very well in the other localization files, such as Battlegrounds, Outdoor
Raids, etc.


--]]




if ( GetLocale() == "ruRU" ) then

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

AQOptionsCaptionTEXT = ""..YELLOW.."AtlasQuest Настройки";
AQ_OK = "Готово"

-- Autoshow
AQOptionsAutoshowTEXT = "Показывать панель AtlasQuest вместе с Атласом.";
AQAtlasAutoON = "Панель AtlasQuest будет показана когда вы откроете Атлас."..GREEN.." (по умолчанию)"
AQAtlasAutoOFF = "Панель AtlasQuest "..RED.."не будет"..WHITE.." показана когда вы откроете Атлас."

-- Right/Left
AQOptionsLEFTTEXT = "Показать панель AtlasQuest "..RED.."слева.";
AQOptionsRIGHTTEXT = "Показать панель AtlasQuest "..RED.."справа.";
AQShowRight = "Теперь панель AtlasQuest "..RED.."справа.";
AQShowLeft = "Теперь панель AtlasQuest "..RED.."слева."..GREEN.." (по умолчанию)";

-- Colour Check
AQOptionsCCTEXT = "Подкрасить задания в соответствии с их уровнем."
AQCCON = "Теперь AtlasQuest будет подкрашивать задания в соответствии с уровнем."
AQCCOFF = "AtlasQuest не будет подкрашивать задания."

-- QuestLog Colour Check
AQQLColourChange = "Подкрашивать все задания, имеющиеся в журнале "..BLUE.."синим."

-- AutoQuery Quest Rewards
AQOptionsAutoQueryTEXT = "Автоматически запрашивать у сервера предметы которые вы не видели."

-- Suppress Server Query text
AQOptionsNoQuerySpamTEXT = "Подавление спама запросов к серверу."

-- Use Comparison Tooltips
AQOptionsCompareTooltipTEXT = "Сравнение награды с надетыми вещами."

-- Quest Query text
AQQuestQueryButtonTEXT = ""..WHITE.."Quest Query";
AQClearQuestAndQueryButtonTEXT = ""..WHITE.."Reset Quests";
AQQuestQueryTEXT = ""..WHITE.."Query Server for completed quests.";
AQClearQuestAndQueryTEXT = ""..WHITE.."Reset completed quests and query server for list of completed quests.";
AQQuestQueryStart = "AtlasQuest is now querying server for completed quests. This may take a minute";
AQQuestQueryDone = "AtlasQuest has finished querying the server. Completed quests should now be marked.";

AQAbilities = BLUE .. "Способности:"
AQSERVERASKInformation = " Пожалуйста нажимайте правую кнопку мыши, пока не увидите окно предмета."
AQSERVERASKAuto = " Попробуйте задержать курсор мыши над предметом на секунду."
AQSERVERASK = "AtlasQuest запрашивает сервер о: "
AQERRORNOTSHOWN = "Этот предмет небезопасен!"
AQERRORASKSERVER = "Вы можете щелкнуть правой кнопкой, чтобы попытаться запросить информацию о предмете. Имеется риск отсоединения от сервера."
AQOptionB = "Настройки"
AQNoReward = BLUE.." Нет наград"
AQDiscription_REWARD = BLUE.."Награда: "
AQDiscription_OR = GREY.." или "
AQDiscription_AND = GREY.." и "
AQDiscription_ATTAIN = "Доступно: "
AQDiscription_LEVEL = "Уровень: "
AQDiscription_START = "Начинается у: \n"
AQDiscription_AIM = "Цель: \n"
AQDiscription_NOTE = "Заметка: \n"
AQDiscription_PREQUEST= "Предыдущее задание: "
AQDiscription_FOLGEQUEST = "Следующее задание: "
AQFinishedTEXT = "Задание сделано ";


------------------
--- ITEM TYPES ---
------------------

AQITEM_DAGGER = " Кинжал"
AQITEM_POLEARM = " Древковое"
AQITEM_SWORD = " Меч"
AQITEM_AXE = " Топор"
AQITEM_WAND = "Жезл"
AQITEM_STAFF = "Посох"
AQITEM_MACE = " Дробящее"
AQITEM_SHIELD = "Щит"
AQITEM_GUN = "Огнестрельное"
AQITEM_BOW = "Лук"
AQITEM_CROSSBOW = "Арбалет"
AQITEM_THROWN = "Метательное"

AQITEM_WAIST = "Пояс,"
AQITEM_SHOULDER = "Плечо,"
AQITEM_CHEST = "Грудь,"
AQITEM_LEGS = "Ноги,"
AQITEM_HANDS = "Кисти рук,"
AQITEM_FEET = "Ступни,"
AQITEM_WRIST = "Запястья,"
AQITEM_HEAD = "Голова,"
AQITEM_BACK = "Спина"
AQITEM_TABARD = "Гербовая накидка"

AQITEM_CLOTH = " Ткань"
AQITEM_LEATHER = " Кожа"
AQITEM_MAIL = " Кольчуга"
AQITEM_PLATE = " Латы"
AQITEM_COSMETIC = " Cosmetic"

AQITEM_OFFHAND = "Левая рука"
AQITEM_MAINHAND = "Правая рука,"
AQITEM_ONEHAND = "Одноручное,"
AQITEM_TWOHAND = "Двуручное,"

AQITEM_ITEM = "Предмет" -- Use this for those oddball rewards which aren't really anything else.
AQITEM_TOY = "Toy"
AQITEM_PET = "Pet"
AQITEM_TRINKET = "Аксессуар"
AQITEM_POTION = "Зелье"
AQITEM_NECK = "Шея"
AQITEM_PATTERN = "Выкройка"
AQITEM_BAG = "Сумка"
AQITEM_RING = "Палец"
AQITEM_GEM = "Gem"
AQITEM_ENCHANT = "Чары"
AQITEM_SPELL = "Spell"




--------------- INST66 - No Instance ---------------

-- Just to display "No Quests" when the map is set to something AtlasQuest does not support.
Inst66Caption = "No Information Available"
Inst66QAA = "No Quests"
Inst66QAH = "No Quests"


end

-- End of File
