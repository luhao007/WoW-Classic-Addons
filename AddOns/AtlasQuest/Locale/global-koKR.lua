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

if ( GetLocale() == "koKR" ) then

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

AQOptionsCaptionTEXT = ""..YELLOW.."AtlasQuest 옵션";
AQ_OK = "확인";

-- Autoshow
AQOptionsAutoshowTEXT = ""..WHITE.."AtlasQuest 패널과 "..RED.."Atlas"..WHITE.." 함께 표시.";
AQAtlasAutoON = "Atlas가 열리면 AtlasQuest 패널이 자동으로 표시됩니다."..GREEN.."(기본)";
AQAtlasAutoOFF = "Atlas를 열면 "..RED.."AtlasQuest 패널이"..WHITE.." 표시되지 않습니다.";

-- Right/Left
AQOptionsLEFTTEXT = ""..WHITE.."AtlasQuest 패널 "..RED.."왼쪽"..WHITE.."표시.";
AQOptionsRIGHTTEXT = ""..WHITE.."AtlasQuest 패널 "..RED.."오른쪽"..WHITE.."표시.";
AQShowRight = "이제 AtlasQuest 패널이 "..RED.."오른쪽"..WHITE.."에 표시됩니다.";
AQShowLeft = "이제 AtlasQuest 패널이 "..RED.."왼쪽"..WHITE.."에 표시됩니다. "..GREEN.."(기본)";

-- Colour Check
AQOptionsCCTEXT = ""..WHITE.."레벨에 따라 퀘스트를 다시 확인하십시오.";
AQCCON = "AtlasQuest는 레벨에 따라 퀘스트를 다시 확인합니다.";
AQCCOFF = "AtlasQuest는 퀘스트를 재현하지 않습니다."

-- QuestLog Colour Check
AQQLColourChange = ""..WHITE.."모든 퀘스트 색상이 퀘스트로그에 "..BLUE.."파란색으로"..WHITE.."표시됩니다.";

-- Use Comparison Tooltips
AQOptionsCompareTooltipTEXT = ""..WHITE.."현재 장비가 갖추어 진 아이템에 보상을 비교하십시오.";

-- Quest Query text
AQQuestQueryButtonTEXT = ""..WHITE.."퀘스트 검색";
AQClearQuestAndQueryButtonTEXT = ""..WHITE.."퀘스트 재설정";
AQQuestQueryTEXT = ""..WHITE.."완료된 퀘스트에 대한 서버 검색.";
AQClearQuestAndQueryTEXT = ""..WHITE.."완료된 퀘스트 및 서버 검색을 다시 설정하여 완료된 퀘스트 목록을 확인합니다.";
AQQuestQueryStart = "AtlasQuest가 이제 서버에 완료된 퀘스트를 검색하고 있습니다. 몇분 정도 걸릴 수 있습니다.";
AQQuestQueryDone = "AtlasQuest가 서버 검색을 완료했습니다. 완료된 퀘스트가 표시됩니다.";


AQAbilities = BLUE .. "능력:" .. WHITE;
AQSERVERASKInformation = " 아이템창이 나타날 떄까지 오늘쪽 클릭 하십시오.";
AQSERVERASKAuto = " 잠시 후 아이템 위로 커서를 이동합니다.";
AQSERVERASK = "AtlasQuest가 서버를 검색하고 있습니다.: ";
AQERRORNOTSHOWN = "이 아이템은 안전하지 않습니다!";
AQERRORASKSERVER = "서버에서 이 아이템을 검색하려면 오른쪽 \n클릭하십시오. 연결이 끊어질 수 있습니다.";
AQOptionB = "설정";
AQNoReward = ""..BLUE.." 보상 없음";
AQDiscription_REWARD = ""..BLUE.." 보상: ";
AQDiscription_OR = ""..GREY.." 또는 "..WHITE.."";
AQDiscription_AND = ""..GREY.." 와 "..WHITE.."";
AQDiscription_ATTAIN = "달성: ";
AQDiscription_LEVEL = "레벨: ";
AQDiscription_START = "시작 지점: ";
AQDiscription_AIM = "목표: ";
AQDiscription_NOTE = "내용: ";
AQDiscription_PREQUEST= "선행 퀘스트: ";
AQDiscription_FOLGEQUEST = "퀘스트는 다음과 연퀘입니다: ";
AQFinishedTEXT = "퀘스트 완료: ";


------------------
--- ITEM TYPES ---
------------------

AQITEM_DAGGER = " 단검"
AQITEM_POLEARM = " 장창"
AQITEM_SWORD = " 도검"
AQITEM_AXE = " 도끼"
AQITEM_WAND = "마법봉"
AQITEM_STAFF = " 지팡이"
AQITEM_MACE = " 둔기"
AQITEM_SHIELD = "방패"
AQITEM_GUN = "총"
AQITEM_BOW = "활"
AQITEM_CROSSBOW = "석궁"
AQITEM_THROWN = "투척"

AQITEM_WAIST = "허리,"
AQITEM_SHOULDER = "어깨,"
AQITEM_CHEST = "가슴,"
AQITEM_LEGS = "다리,"
AQITEM_HANDS = "손,"
AQITEM_FEET = "발,"
AQITEM_WRIST = "손목,"
AQITEM_HEAD = "머리,"
AQITEM_BACK = "등"
AQITEM_TABARD = "휘장"

AQITEM_CLOTH = " 천"
AQITEM_LEATHER = " 가죽"
AQITEM_MAIL = " 사슬"
AQITEM_PLATE = " 판금"

AQITEM_OFFHAND = "보조 무기"
AQITEM_MAINHAND = "주 무기,"
AQITEM_ONEHAND = "한손 무기,"
AQITEM_TWOHAND = "양손 무기,"

AQITEM_ITEM = "아이템" -- Use this for those oddball rewards which aren't really anything else.
AQITEM_PET = "Pet"
AQITEM_TRINKET = "장신구"
AQITEM_POTION = "물약"
AQITEM_NECK = "목"
AQITEM_PATTERN = "도안"
AQITEM_BAG = "가방"
AQITEM_RING = "손가락"
AQITEM_ENCHANT = "마법 부여"
AQITEM_SPELL = "주문"




--------------- INST66 - No Instance ---------------

-- Just to display "No Quests" when the map is set to something AtlasQuest does not support.
Inst66Caption = "사용 가능한 정보 없음"
Inst66QAA = "퀘스트 없음"
Inst66QAH = "퀘스트 없음"


end
-- End of File
