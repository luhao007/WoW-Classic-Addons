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


------------  CLASSIC / VANILLA  ------------

-- 66  = default.  Nothing shown.

-- 1  = Blackrock Depths 검은바위 나락
-- 2  = Blackwing Lair 검은바위 산:검은날개 둥지
-- 3  = Lower Blackrock Spire 검은바위 첨탑 하층
-- 4  = Upper Blackrock Spire 검은바위 첨탑 상층
-- 5  = Deadmines 죽음의 폐광
-- 6  = Gnomeregan 놈리건
-- 7  = Scarlet Monastery: Library 붉은십자군 수도원:도서관
-- 8  = Scarlet Monastery: Armory 붉은십자군 수도원:무기고
-- 9  = Scarlet Monastery: Cathedral 붉은십자군 수도원:예배당
-- 10 = Scarlet Monastery: Graveyard 붉은십자군 수도원:묘지
-- 11 = Scholomance 스칼로맨스
-- 12 = Shadowfang Keep 그림자송곳니 성채
-- 13 = The Stockade 스톰윈드 지하감옥
-- 14 = Stratholme 스트라솔름
-- 15 = Sunken Temple 가라앉은 사원
-- 16 = Uldaman 울다만

-- 17 = Blackfathom Deeps 검은심연 나락
-- 18 = Dire Maul East 혈투의 전장 동쪽
-- 19 = Dire Maul North 현투의 전장 북쪽
-- 20 = Dire Maul West 혈투의 전장 서쪽
-- 21 = Maraudon 마라우돈
-- 22 = Ragefire Chasm 성난불길 협곡
-- 23 = Razorfen Downs 가시덩굴 구릉
-- 24 = Razorfen Kraul 가시덩굴 우리
-- 25 = Wailing Caverns 통곡의 동굴
-- 26 = Zul'Farrak 줄파락

-- 27 = Molten Core 화산 심장부
-- 28 = Onyxia's Lair 오닉시아 둥지
-- 29 = Zul'Gurub 줄구룹
-- 30 = The Ruins of Ahn'Qiraj 안퀴라즈 폐허
-- 31 = The Temple of Ahn'Qiraj 안퀴라즈 사원
-- 32 = Naxxramas (level 60) 낙스라마스

-- 33 = Alterac Valley 알터랙 계곡
-- 34 = Arathi Basin 아라시 분지
-- 35 = Warsong Gulch

-- 36 = Four Dragons
-- 37 = Azuregos 아주어고스
-- 38 = Highlord Kruul 대군주 크룰

-- Last update: 2020-06-14

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




--------------- INST1 - Blackrock Depths 검은바위 나락 (BRD) ---------------

Inst1Caption = "검은바위 나락"
Inst1QAA = "19 퀘스트"
Inst1QAH = "18 퀘스트"

--Quest 1 Alliance
Inst1Quest1 = "1. 검은무쇠단 유물" -- Dark Iron Legacy
Inst1Quest1_Aim = "파이너스 다크바이어를 처치하고 거대한 망치, 무쇠지옥을 회수해야 합니다. 무쇠지옥을 타우릿산의 제단으로 가져가서 프랑클론 포지라이트의 석상에 두어야 합니다."
Inst1Quest1_Location = "프랑클론 포지라이트 (검은바위 산; "..GREEN.."[1'] 지도 입구에"..WHITE..")"
Inst1Quest1_Note = "프랑클론 포지라이트는 검은바위 산 떠다니는 섬 한가운데 있으며, 만남의 돌 근처 던전 바깥에 있습니다.  그를 만나려면 죽어야합니다.  그는 또한 당신에게 그의 이야기를 듣도록 요구하는 사전 임무를 줍니다.\n파이너스 다크바이어는 "..YELLOW.."[9]"..WHITE.." 에 있다. 경기장 옆에있는 신사 "..YELLOW.."[7]"..WHITE.."."
Inst1Quest1_Prequest = "검은무쇠단 유물"
Inst1Quest1_Folgequest = "없음"
--
Inst1Quest1name1 = "어둠괴철로단 열쇠"

--Quest 2 Alliance
Inst1Quest2 = "2. 리블리 스크류스피곳" -- Ribbly Screwspigot
Inst1Quest2_Aim = "리블리를 처치하고 그 증거로 그의 머리카락을 불타는 평원에 있는 유카 스크류스피곳에게 가져가야 합니다."
Inst1Quest2_Location = "유카 스크류스피곳 (불타는 평원 - 화염 마루; "..YELLOW.."66.0, 22.0"..WHITE..")"
Inst1Quest2_Note = "선행 퀘스트 요르바 스크류스피곳에게 받았습니다. (타나리스 - 스팀휘들 항구; "..YELLOW.."67.0, 24.0"..WHITE..").\n리블리 스크류스피곳은 "..YELLOW.."[15]"..WHITE.." 에 있다."
Inst1Quest2_Prequest = "유카 스크류스피곳"
Inst1Quest2_Folgequest = "없음"
--
Inst1Quest2name1 = "원한의 장화"
Inst1Quest2name2 = "고행의 어깨갑옷"
Inst1Quest2name3 = "강철미늘 갑옷"

--Quest 3 Alliance
Inst1Quest3 = "3. 사랑의 묘약" -- The Love Potion
Inst1Quest3_Aim = "검은바위 나락에 있는 지배인 나그마라에게 그롬의 피 4개, 거대한 은 광석 10개, 가득 찬 나그마라의 약병을 가져가야 합니다."
Inst1Quest3_Location = "지배인 나그마라 (검은바위 나락; "..YELLOW.."[15]"..WHITE..")"
Inst1Quest3_Note = "아즈샤라에 있는 거인에게서 거대한 은 광석을 얻을 수 있습니다.  그롬의 피는 약초채집 또는 경매장에서 얻을 수 있습니다.  가득 찬 나그마라의 약병 (운고로 분화구 - 골락카 간헐천; "..YELLOW.."31.0, 50.0"..WHITE..").\n퀘스트를 완료한 후, 팔란스를 죽이는 대신 뒷문을 사용할 수 있습니다."
Inst1Quest3_Prequest = "없음"
Inst1Quest3_Folgequest = "없음"
--
Inst1Quest3name1 = "속박의 소매장식"
Inst1Quest3name2 = "나그마라의 채찍 허리띠"

--Quest 4 Alliance
Inst1Quest4 = "4. 헐레이 블랙브레스" -- Hurley Blackbreath
Inst1Quest4_Aim = "카라노스에 있는 라그나르 썬더브루에게 잃어버린 썬더브루 제조법을 가져가야 합니다."
Inst1Quest4_Location = "라그나르 썬더브루  (던 모로 - 카라노스; "..YELLOW.."46.8, 52.4"..WHITE..")"
Inst1Quest4_Note = "이 선행 퀘스트는 에노하르 썬더브루에서 시작 됩니다. (저주받은 땅 - 네더가드 요새; "..YELLOW.."63.6, 20.6"..WHITE..").\n당신은 험상궂은 주정뱅이 선술집에서 썬더브루 맥주통은 파괴하면 나타나는 경비원중 한 명으로부터 제조법을 얻을 수 있습니다. "..YELLOW.."[15]"..WHITE.."."
Inst1Quest4_Prequest = "라그나르 썬더브루"
Inst1Quest4_Folgequest = "없음"
--
Inst1Quest4name1 = "검은 드워프 맥주잔"
Inst1Quest4name2 = "일격의 곤봉"
Inst1Quest4name3 = "절단의 클레버"

--Quest 5 Alliance  
Inst1Quest5 = "5. 멸망의 파이론" -- Overmaster Pyron
Inst1Quest5_Aim = "멸망의 파이론을 처치해야 합니다.잘린다가 말하기를 파이론은 채석장을 지키고 있다고 하니 그곳을 수색해야 할 것 같습니다."
Inst1Quest5_Location = "잘린다 스프리그 (불타는 평원 - 모건의 망루; "..YELLOW.."85.4, 70.0"..WHITE..")"
Inst1Quest5_Note = "멸망의 파이론은 던전 외부의 불 정령입니다.  그는 검은바위 나락 "..YELLOW.."[24]"..WHITE.." 지도와 검은바위 산 입구 지도에서 "..YELLOW.."[3]"..WHITE.." 포털 근처를 순찰 합니다."
Inst1Quest5_Prequest = "없음"
Inst1Quest5_Folgequest = "인센디우스!"
-- No Rewards for this quest

--Quest 6 Alliance
Inst1Quest6 = "6. 인센디우스!" -- Incendius!
Inst1Quest6_Aim = "검은바위 나락에서 불의군주 인센디우스를 찾아 처치해야 합니다."
Inst1Quest6_Location = "잘린다 스프리그 (불타는 평원 - 모건의 망루; "..YELLOW.."85.4, 70.0"..WHITE..")"
Inst1Quest6_Note = "선행 퀘스트는 잘린다 스프리그에서도 나온다.  뷸의군주 인센디우스는 검은 모루 "..YELLOW.."[10]"..WHITE.." 에서 찾을 수 있습니다."
Inst1Quest6_Prequest = "멸망의 파이론"
Inst1Quest6_Folgequest = "없음"
--
Inst1Quest6name1 = "해무리 단망토"
Inst1Quest6name2 = "땅거미 장갑"
Inst1Quest6name3 = "지하 악마의 팔보호구"
Inst1Quest6name4 = "튼튼한 벨트"

--Quest 7 Alliance
Inst1Quest7 = "7. 산의 정수" -- The Heart of the Mountain
Inst1Quest7_Aim = "불타는 평원에 있는 맥스워트 우버글린트에게 산의 정수를 가져가야 합니다."
Inst1Quest7_Location = "맥스워트 우버글린트 (불타는 평원 - 화염 마루; "..YELLOW.."65.2, 23.8"..WHITE..")"
Inst1Quest7_Note = "금고에서 산의 정수 "..YELLOW.."[8]"..WHITE.." 를 찾을 수 있습니다.  그 금고의 열쇠를 획득하려면 먼저 던전 전체에 떨어지는 유물 금고 열쇠 키를 사용하여 모든 작은 금고를 열어야 합니다.  모든 작은 금고가 열리면, 보초 둠그립과 그의 친구들이 나타납니다. 그들을 처치하여 열쇠를 회수하십시오."
Inst1Quest7_Prequest = "없음"
Inst1Quest7_Folgequest = "없음"
-- No Rewards for this quest

--Quest 8 Alliance
Inst1Quest8 = "8. 좋은 물건" -- The Good Stuff
Inst1Quest8_Aim = "검은바위 나락으로 가서 검은무쇠단 벨트주머니 20개를 얻어야 합니다. 이 임무를 완수하면 랄리우스에게 돌아가십시오. 검은바위 나락 안에 사는 검은무쇠단 드워프들이 이 \'벨트주머니\'라는 물건을 지니고 다닐 것입니다."
Inst1Quest8_Location = "랄리우스 (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.6"..WHITE..")"
Inst1Quest8_Note = "모든 드워프는 검은무쇠단 벨트주머니 드랍함니다."
Inst1Quest8_Prequest = "없음"
Inst1Quest8_Folgequest = "없음"
--
Inst1Quest8name1 = "때묻은 자루"

--Quest 9 Alliance
Inst1Quest9 = "9. 화염의 맛" -- A Taste of Flame
Inst1Quest9_Aim = "검은바위 나락으로 가서 밸가르를 처치하십시오. "..YELLOW.."[...]"..WHITE.." 이 거인이 검은바위 나락 내에 살고 있다는 것만 알고 있으며 밸가르의 시체에 변형된 검은용군단 허물을 사용해 불의 정수를 추출해야만 합니다.키루스 테레펜터스에게 담겨진 불의 정수를 가져가야 합니다."
Inst1Quest9_Location = "키루스 테레펜터스 (불타는 평원 - 뱀갈퀴 바위굴; "..YELLOW.."94.8, 31.6"..WHITE..")"
Inst1Quest9_Note = "퀘스트 라인은 칼라란 윈드블레이드에서 시작됩니다. (이글거리는 협곡; "..YELLOW.."39.0, 38.8"..WHITE..").  그가 패배한 후 그에게 '변형된 검은용군단 허물'를 사용하여 퀘스트를 완료하십시오."
Inst1Quest9_Prequest = "완전무결한 불꽃 -> 화염의 맛"
Inst1Quest9_Folgequest = "없음"
--
Inst1Quest9name1 = "혈암 단망토"
Inst1Quest9name2 = "고룡가죽 어깨갑옷"
Inst1Quest9name3 = "떡갈나무 장식띠"

--Quest 10 Alliance
Inst1Quest10 = "10. 카란 마이트해머" -- Kharan Mighthammer
Inst1Quest10_Aim = "검은바위 나락으로 가서 카란 마이트해머를 찾아야 합니다. 국왕은 카란이 그곳에 포로로 잡혀 있을 것이라고 말했습니다. 그곳 감옥을 찾아보는 것이 좋겠습니다."
Inst1Quest10_Location = "국왕 마그니 브론즈비어드 (아이언포지; "..YELLOW.."39.4, 55.8"..WHITE..")"
Inst1Quest10_Note = "이 선행 퀘스트는 왕실사학자 아케소누스에서 시작됩니다. (아이언포지; "..YELLOW.."38.6, 55.4"..WHITE..").  \n카란 마이트해머는 "..YELLOW.."[2]"..WHITE.." 에 있다."
Inst1Quest10_Prequest = "불타는 타우릿산의 폐허 (2)"
Inst1Quest10_Folgequest = "나쁜 소식 전달"
-- No Rewards for this quest

--Quest 11 Alliance
Inst1Quest11 = "11. 왕국의 운명" -- The Fate of the Kingdom
Inst1Quest11_Aim = "검은바위 나락으로 돌아가 제왕 다그란 타우릿산의 사악한 손아귀에서 공주 모이라 브론즈비어드를 구출해야 합니다."
Inst1Quest11_Location = "국왕 마그니 브론즈비어드 (아이언포지; "..YELLOW.."39.4, 55.8"..WHITE..")"
Inst1Quest11_Note = "공주 모이라 브론즈비어드는 "..YELLOW.."[21]"..WHITE.." 에 있다.  당신은 다그란 타우릿산 물리 치고 퀘스트를 완료 하기 위해 공주가 살아있어야 합니다.  공주가 죽으면 던전 전체를 초기화하고 다시 시도해야 합니다.  만약 성공한다면, 당신은 공주에게 퀘스트를 완료 할수 있습니다. 그녀는 당신의 보상을 위해 아이언포지에 국왕 마그니 브론즈비어드 보낼 것입니다."
Inst1Quest11_Prequest = "나쁜 소식 전달"
Inst1Quest11_Folgequest = "브론즈비어드 공주"
--
Inst1Quest11name1 = "마그니의 결의"
Inst1Quest11name2 = "아이언포지의 노랫돌"

--Quest 12 Alliance
Inst1Quest12 = "12. 심장부와의 조화!" -- Attunement to the Core
Inst1Quest12_Aim = "검은바위 나락의 화산 심장부 입구에 있는 차원의 문으로 가서 핵 조각을 하나 찾아야 합니다. 핵 조각을 가지고 검은바위 산에 있는 로소스 리프트웨이커에게로 돌아가십시오."
Inst1Quest12_Location = "로소스 리프트웨이커 (검은바위 산; "..YELLOW.."[E] 입구 지도에"..WHITE..")"
Inst1Quest12_Note = "이는 화산 심장부 퀘스트 입니다.  핵 조각 "..YELLOW.."[23]"..WHITE.." 은, 화산 심장부 포털과 매우 가깝습니다.  이 퀘스트를 완료한 후, 로소스 리프트웨이커와 이야기하거나 옆에 있는 창문을 통해 점프해 화산 심장부로 들어갈 수 있습니다."
Inst1Quest12_Prequest = "없음"
Inst1Quest12_Folgequest = "없음"
-- No Rewards for this quest

--Quest 13 Alliance
Inst1Quest13 = "13. 도전" -- The Challenge
Inst1Quest13_Aim = "검은바위 나락의 법의 심판장으로 가서 대법관 그림스톤에 의해 선고받은대로 한가운데에 도전의 깃발을 설치해야 합니다. 텔드렌과 그의 검투사들을 해치운 후 군주 발타라크의 첫 번째 아뮬렛 조각을 가지고 동부 역병지대에 있는 안시온 하몬에게 가야 합니다."
Inst1Quest13_Location = "팔린 트리셰이퍼 (혈투의 전장 서쪽; "..YELLOW.."[1] 도서관"..WHITE..")"
Inst1Quest13_Note = "던전 세트 퀘스트 라인.  법의 심판장은 "..YELLOW.."[6]"..WHITE.." 에 있다."
Inst1Quest13_Prequest = "없음"
Inst1Quest13_Folgequest = "안시온의 작별 인사"
-- No Rewards for this quest

--Quest 14 Alliance
Inst1Quest14 = "14. 유령의 성배" -- The Spectral Chalice
Inst1Quest14_Aim = "그늘의 문지기가 원하는 재료를 유령의 성배에 놓으세요."
Inst1Quest14_Location = "그늘의 문지기 (검은바위 나락; "..YELLOW.."[18]"..WHITE..")"
Inst1Quest14_Note = "이것은 채광 퀘스트 이며 검은무쇠 주괴 제련 하는 법을 배우기 위해 230 이상의 채광 숙련이 필요합니다. 2개의 별루비, 20개의 금괴 그리고 10개의 진은 주괴가 필요합니다.  그 후에, 검은 무쇠 광석이 있으면 "..YELLOW.."[22]"..WHITE.." 검은 가열로에서 제련 할 수 있습니다.  \n이곳은 제련이 가능한 유일한 장소입니다."
Inst1Quest14_Prequest = "없음"
Inst1Quest14_Folgequest = "없음"
-- No Rewards for this quest

--Quest 15 Alliance
Inst1Quest15 = "15. 치안대장 윈저" -- Marshal Windsor
Inst1Quest15_Aim = "북서쪽에 있는 검은바위 산으로 가서 검은바위 나락으로 들어가십시오. 치안대장 윈저에게 무슨 일이 있었는지 알아내야 합니다. 털보 존은 윈저가 감옥으로 끌려갔다고 했습니다."
Inst1Quest15_Location = "치안대장 맥스웰 (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.8"..WHITE..")"
Inst1Quest15_Note = "오닉시아 입장 퀘스트 라인.  \n헬렌디스 리버혼에서 시작됩니다. (불타는 평원 - 모건의 망루; "..YELLOW.."85.6, 68.8"..WHITE..").\n치안대장 윈저 "..YELLOW.."[4]"..WHITE.." 에 있다."
Inst1Quest15_Prequest = "용혈족의 위협 -> 진정한 지도자"
Inst1Quest15_Folgequest = "실망"
-- No Rewards for this quest

--Quest 16 Alliance
Inst1Quest16 = "16. 실망" -- Abandoned Hope
Inst1Quest16_Aim = "치안대장 맥스웰에게 나쁜 소식을 전해줘야 합니다."
Inst1Quest16_Location = "치안대장 윈저 (검은바위 나락; "..YELLOW.."[4]"..WHITE..")"
Inst1Quest16_Note = "오닉시아 입장 퀘스트 라인.  치안대장 맥스웰은 (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.8"..WHITE..")에 있다.  다음 퀘스트는 검은바위 나락에서 무작위 드랍합니다."
Inst1Quest16_Prequest = "치안대장 윈저"
Inst1Quest16_Folgequest = "없음"
--
Inst1Quest16name1 = "보호자의 투구"
Inst1Quest16name2 = "강철 판금 발덮개"
Inst1Quest16name3 = "칼바람 다리보호구"

--Quest 17 Alliance
Inst1Quest17 = "17. 꼬깃꼬깃한 쪽지" -- A Crumpled Up Note
Inst1Quest17_Aim = "방금 우연히 치안대장 윈저가 보고 싶어할 듯한 물건을 찾은 것 같습니다. 어쩌면 희망이 있을지도 모릅니다."
Inst1Quest17_Location = "꼬깃꼬깃한 쪽지 (검은바위 나락 무작위 드랍)"
Inst1Quest17_Note = "오닉시아 입장 퀘스트 라인.  치안대장 윈저 "..YELLOW.."[4]"..WHITE.." 에 있다. 드랍 가능성이 가장 높은 것은 채석장 주변의 검은 무쇠단 폭도 인 것 같습니다."
Inst1Quest17_Prequest = "실망"
Inst1Quest17_Folgequest = "잔존하는 희망"
-- No Rewards for this quest

--Quest 18 Alliance
Inst1Quest18 = "18. 잔존하는 희망" -- A Shred of Hope
Inst1Quest18_Aim = "치안대장 윈저의 잃어버린 단서를 가져 와야 합니다. 치안대장 윈저는 골렘 군주 아젤마크와 사령관 앵거포지가 이 정보를 가지고 있을 것이라 생각합니다."
Inst1Quest18_Location = "치안대장 윈저 (검은바위 나락; "..YELLOW.."[4]"..WHITE..")"
Inst1Quest18_Note = "오닉시아 입장 퀘스트 라인.  잃어버린 단서는 골렘 군주 아젤마크 "..YELLOW.."[14]"..WHITE.." 와 그리고 사령관 앵거포지 "..YELLOW.."[13]"..WHITE.." 에서 드랍합니다."
Inst1Quest18_Prequest = "꼬깃꼬깃한 쪽지"
Inst1Quest18_Folgequest = "탈옥!"
-- No Rewards for this quest

--Quest 19 Alliance
Inst1Quest19 = "19. 탈옥!" -- Jail Break!
Inst1Quest19_Aim = "치안대장 윈저가 자신의 장비를 되찾고 갇힌 동료들을 풀어 주는 것을 도와야 합니다. 성공하면 치안대장 맥스웰에게 돌아가십시오."
Inst1Quest19_Location = "치안대장 윈저 (검은바위 나락; "..YELLOW.."[4]"..WHITE..")"
Inst1Quest19_Note = "오닉시아 입장 퀘스트 라인.  이건 호위 퀘스트.  시작하기 전에 모든 사람이 같은 단계에 있는지 확인하십시오.  이벤트를 시작하기 전에 법의 심판장("..YELLOW.."[6]"..WHITE..")과 입구로 가는 길을 정리하면 퀘스트가 더 쉬워집니다. \n불타는 평원 - 모건의 망루에서 치안대장 맥스웰을 찾을 수 있습니다. ("..YELLOW.."84.6, 68.8"..WHITE..")."
Inst1Quest19_Prequest = "잔존하는 희망"
Inst1Quest19_Folgequest = "스톰윈드 회합"
--
Inst1Quest19name1 = "정기의 수호물"
Inst1Quest19name2 = "징벌의 검"
Inst1Quest19name3 = "숙련의 전투 단도"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst1Quest1_HORDE = Inst1Quest1
Inst1Quest1_HORDE_Aim = Inst1Quest1_Aim
Inst1Quest1_HORDE_Location = Inst1Quest1_Location
Inst1Quest1_HORDE_Note = Inst1Quest1_Note
Inst1Quest1_HORDE_Prequest = Inst1Quest1_Prequest
Inst1Quest1_HORDE_Folgequest = Inst1Quest1_Folgequest
--
Inst1Quest1name1_HORDE = Inst1Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst1Quest2_HORDE = Inst1Quest2
Inst1Quest2_HORDE_Aim = Inst1Quest2_Aim
Inst1Quest2_HORDE_Location = Inst1Quest2_Location
Inst1Quest2_HORDE_Note = Inst1Quest2_Note
Inst1Quest2_HORDE_Prequest = Inst1Quest2_Prequest
Inst1Quest2_HORDE_Folgequest = Inst1Quest2_Folgequest
--
Inst1Quest2name1_HORDE = Inst1Quest2name1
Inst1Quest2name2_HORDE = Inst1Quest2name2
Inst1Quest2name3_HORDE = Inst1Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst1Quest3_HORDE = Inst1Quest3
Inst1Quest3_HORDE_Aim = Inst1Quest3_Aim
Inst1Quest3_HORDE_Location = Inst1Quest3_Location
Inst1Quest3_HORDE_Note = Inst1Quest3_Note
Inst1Quest3_HORDE_Prequest = Inst1Quest3_Prequest
Inst1Quest3_HORDE_Folgequest = Inst1Quest3_Folgequest
--
Inst1Quest3name1_HORDE = Inst1Quest3name1
Inst1Quest3name2_HORDE = Inst1Quest3name2

--Quest 4 Horde
Inst1Quest4_HORDE = "4. 잃어버린 썬더브루 제조법" -- Lost Thunderbrew Recipe
Inst1Quest4_HORDE_Aim = "카르가스에 있는 비비안 라그레이브에게 잃어버린 썬더브루 제조법을 가져가야 합니다."
Inst1Quest4_HORDE_Location = "어둠마법사 비비안 라그레이브 (황야의 땅 - 카르가스; "..YELLOW.."3.0, 47.6"..WHITE..")"
Inst1Quest4_HORDE_Note = "선행 퀘스트는 언더시티 - 연금술 실험실 연금술사 진게에게 시작 됩니다. ("..YELLOW.."49.8 68.2"..WHITE..").\n당신은 험상궂은 주정뱅이 선술집에서 썬더브루 맥주통은 파괴하면 나타나는 경비원중 한 명으로부터 제조법을 얻을 수 있습니다. "..YELLOW.."[15]"..WHITE.."."
Inst1Quest4_HORDE_Prequest = "비비안 라그레이브"
Inst1Quest4_HORDE_Folgequest = "없음"
--
Inst1Quest4name1_HORDE = "최상급 치유 물약"
Inst1Quest4name2_HORDE = "상급 마나 물약"
Inst1Quest4name3_HORDE = "일격의 곤봉"
Inst1Quest4name4_HORDE = "절단의 클레버"

--Quest 5 Horde  (same as Quest 7 Alliance)
Inst1Quest5_HORDE = "5. 산의 정수" -- The Heart of the Mountain
Inst1Quest5_HORDE_Aim = Inst1Quest7_Aim
Inst1Quest5_HORDE_Location = Inst1Quest7_Location
Inst1Quest5_HORDE_Note = Inst1Quest7_Note
Inst1Quest5_HORDE_Prequest = Inst1Quest7_Prequest
Inst1Quest5_HORDE_Folgequest = Inst1Quest7_Folgequest
-- No Rewards for this quest

--Quest 6 Horde
Inst1Quest6_HORDE = "6. 죽음의 본보기: 검은무쇠단 드워프" -- KILL ON SIGHT: Dark Iron Dwarves
Inst1Quest6_HORDE_Aim = "검은바위 나락으로 가서 사악한 침략자들을 쳐부수십시오! 장군 고어투스가 성난모루단 보초 15명, 성난모루단 교도관 10명, 성난모루단 보병 5명을 처치해 달라고 부탁했습니다. 임무를 완수하면 장군 고어투스에게 돌아가십시오."
Inst1Quest6_HORDE_Location = "현상수배 계시판 (황야의 땅 - 카르가스; "..YELLOW.."3.8, 47.5"..WHITE..")"
Inst1Quest6_HORDE_Note = "검은바위 나락 첫 번째 부분에서 드워프를 찾을 수 있습니다. \n퀘스트는 장군 고어투스에게 완료 하세요. (황야의 땅 - 카르가스, "..YELLOW.."5.8, 47.6"..WHITE..")."
Inst1Quest6_HORDE_Prequest = "없음"
Inst1Quest6_HORDE_Folgequest = "죽음의 본보기: 검은무쇠단 고위 관리"
-- No Rewards for this quest

--Quest 7 Horde
Inst1Quest7_HORDE = "7. 죽음의 본보기: 검은무쇠단 고위 관리" -- KILL ON SIGHT: High Ranking Dark Iron Officials
Inst1Quest7_HORDE_Aim = "검은바위 나락으로 가서 사악한 침략자들을 쳐부수십시오! 장군 고어투스가 성난모루단 간호병 10명, 성난모루단 병사 10명, 그리고 성난모루단 장교 10명을 처치해 달라고 부탁했습니다. 임무를 완수하면 고어투스에게 돌아가십시오."
Inst1Quest7_HORDE_Location = "현상수배 계시판 (황야의 땅 - 카르가스; "..YELLOW.."3.8, 47.5"..WHITE..")"
Inst1Quest7_HORDE_Note = "당신이 죽여야 할 드워프는 밸가르 근처에 있습니다. "..YELLOW.."[11]"..WHITE..". \n퀘스트는 장군 고어투스에게 완료 하세요. (황야의 땅 - 카르가스, "..YELLOW.."5.8, 47.6"..WHITE..")."
Inst1Quest7_HORDE_Prequest = "죽음의 본보기: 검은무쇠단 드워프"
Inst1Quest7_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 8 Horde
Inst1Quest8_HORDE = "8. 앵거포지 척살 작전" -- Operation: Death to Angerforge
Inst1Quest8_HORDE_Aim = "검은바위 나락으로 가서 사령관 앵거포지를 처치한 후 장군 고어투스에게 돌아가야 합니다."
Inst1Quest8_HORDE_Location = "장군 고어투스 (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE..")"
Inst1Quest8_HORDE_Note = "이 퀘스트를 받으려면 이전 죽음의 본보기 퀘스트를 모두 완료 한 다음 렉스로트에게 그랄크 로크럽 퀘스트를 시작해야 합니다. (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE.."). \n사령관 앵거포지는 "..YELLOW.."[13]"..WHITE.." 에 있다."
Inst1Quest8_HORDE_Prequest = "그랄크 로크럽 -> 곤경"
Inst1Quest8_HORDE_Folgequest = "없음"
--
Inst1Quest8name1_HORDE = "정복자의 메달"

--Quest 9 Horde
Inst1Quest9_HORDE = "9. 기계들의 봉기 (3)" -- The Rise of the Machines
Inst1Quest9_HORDE_Aim = "골렘 군주 아젤마크를 찾아 처치하고 그 증거로 그의 머리카락을 로트윌에게 가져가야 합니다. 그리고 아젤마크를 호위하는 재앙의 피조물과 맹위의 전투골렘들에게서 온전한 원소핵 10개도 모아야 합니다."
Inst1Quest9_HORDE_Location = "로트윌 베리아투스 (황야의 땅; "..YELLOW.."26.0, 45.0"..WHITE..")"
Inst1Quest9_HORDE_Note = "선행 퀘스트는 제사장 테오도라 뮬바다니아에게 받습니다. (황야의 땅 - 카르가스; "..YELLOW.."3.0, 47.8"..WHITE..").\n골렘군주 아젤마크는 "..YELLOW.."[14]"..WHITE.." 에 있다."
Inst1Quest9_HORDE_Prequest = "기계들의 봉기"
Inst1Quest9_HORDE_Folgequest = "없음"
--
Inst1Quest9name1_HORDE = "푸른달 아미스"
Inst1Quest9name2_HORDE = "기우제 망토"
Inst1Quest9name3_HORDE = "현무암 미늘 갑옷"
Inst1Quest9name4_HORDE = "용암 판금 건틀릿"

--Quest 10 Horde  (same as Quest 9 Alliance)
Inst1Quest10_HORDE = "10. 화염의 맛" -- A Taste of Flame
Inst1Quest10_HORDE_Aim = Inst1Quest9_Aim
Inst1Quest10_HORDE_Location = Inst1Quest9_Location
Inst1Quest10_HORDE_Note = Inst1Quest9_Note
Inst1Quest10_HORDE_Prequest = Inst1Quest9_Prequest
Inst1Quest10_HORDE_Folgequest = Inst1Quest9_Folgequest
--
Inst1Quest10name1_HORDE = Inst1Quest9name1
Inst1Quest10name2_HORDE = Inst1Quest9name2
Inst1Quest10name3_HORDE = Inst1Quest9name3

--Quest 11 Horde
Inst1Quest11_HORDE = "11. 화염의 부조화" -- Disharmony of Flame
Inst1Quest11_HORDE_Aim = "검은바위 산에 있는 채석장으로 가서 멸망의 파이론을 처치해야 합니다. 이 임무를 완수한 후 썬더하트에게 돌아가십시오."
Inst1Quest11_HORDE_Location = "썬더하트 (황야의 땅 - 카르가스; "..YELLOW.."3.4, 48.2"..WHITE..")"
Inst1Quest11_HORDE_Note = "멸망의 파이론은 던전 외부의 불 정령입니다.  그는 검은바위 나락 "..YELLOW.."[24]"..WHITE.." 지도와 검은바위 산 입구 지도에서 "..YELLOW.."[3]"..WHITE.." 포털 근처를 순찰 합니다."
Inst1Quest11_HORDE_Prequest = "없음"
Inst1Quest11_HORDE_Folgequest = "불의 부조화"
-- No Rewards for this quest

--Quest 12 Horde
Inst1Quest12_HORDE = "12. 불의 부조화" -- Disharmony of Fire
Inst1Quest12_HORDE_Aim = "검은바위 나락에 들어가 불의군주 인센디우스를 찾아, 그를 처치한 후 얻게 되는 모든 정보를 썬더하트에게 가져가야 합니다."
Inst1Quest12_HORDE_Location = "썬더하트 (황야의 땅 - 카르가스; "..YELLOW.."3.4, 48.2"..WHITE..")"
Inst1Quest12_HORDE_Note = "선행 퀘스트는 썬더하트에게 받습니다.  뷸의군주 인센디우스는 검은 모루 "..YELLOW.."[10]"..WHITE.." 에서 찾을 수 있습니다."
Inst1Quest12_HORDE_Prequest = "화염의 부조화"
Inst1Quest12_HORDE_Folgequest = "없음"
--
Inst1Quest12name1_HORDE = "해무리 단망토"
Inst1Quest12name2_HORDE = "땅거미 장갑"
Inst1Quest12name3_HORDE = "지하 악마의 팔보호구"
Inst1Quest12name4_HORDE = "튼튼한 벨트"

--Quest 13 Horde
Inst1Quest13_HORDE = "13. 마지막 원소" -- The Last Element
Inst1Quest13_HORDE_Aim = "검은바위 나락으로 가서 원소의 정수 10개를 회수해야 합니다. 먼저 골렘이나 골렘 제조자부터 찾아보십시오. 비비안 라그레이브가 정령에 대해 중얼거리듯 얘기한 것도 기억이 납니다."
Inst1Quest13_HORDE_Location = "어둠마법사 비비안 라그레이브 (황야의 땅 - 카르가스; "..YELLOW.."3.0, 47.6"..WHITE..")"
Inst1Quest13_HORDE_Note = "선행 퀘스트는 썬더하트에게 받습니다. (황야의 땅 - 카르가스; "..YELLOW.."3.4, 48.2"..WHITE..").\n 모든 정령은 원소의 정수를 드랍합니다."
Inst1Quest13_HORDE_Prequest = "화염의 부조화"
Inst1Quest13_HORDE_Folgequest = "없음"
--
Inst1Quest13name1_HORDE = "라그레이브의 인장"

--Quest 14 Horde
Inst1Quest14_HORDE = "14. 사령관 고르샤크" -- Commander Gor'shak
Inst1Quest14_HORDE_Aim = "검은바위 나락에서 사령관 고르샤크를 찾아야 합니다. 조잡하게 그려진 오크 그림에 쇠창살이 그려져 있던 것이 생각납니다. 감옥 같은 곳을 찾아봐야 할 것 같습니다."
Inst1Quest14_HORDE_Location = "명사수 갈라마브 (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE..")"
Inst1Quest14_HORDE_Note = "선행 퀘스트 썬더하트에게 받습니다. (황야의 땅 - 카르가스; "..YELLOW.."3.4, 48.2"..WHITE..").\n사령관 고르샤크는 "..YELLOW.."[3]"..WHITE.." 에 있다.  감옥을 열 수 있는 열쇠는 대심문관 게르스탄에게서 드랍합니다. "..YELLOW.."[5]"..WHITE..".  그와 대화하고 다음 퀘스트를 시작하면 적들이 나타납니다."
Inst1Quest14_HORDE_Prequest = "화염의 부조화"
Inst1Quest14_HORDE_Folgequest = "사태 파악"

--Quest 15 Horde
Inst1Quest15_HORDE = "15. 공주 구출" -- The Royal Rescue
Inst1Quest15_HORDE_Aim = "제왕 다그란 타우릿산을 처치하고 그의 사악한 마법에서 공주 모이라 브론즈비어드를 해방시켜야 합니다."
Inst1Quest15_HORDE_Location = "스랄 (오그리마 - 지혜의 골짜기; "..YELLOW.."32.0, 37.8"..WHITE..")"
Inst1Quest15_HORDE_Note = "당신은 제왕 다그란 타우릿산 "..YELLOW.."[21]"..WHITE.." 찾는다.   당신은 다그란 타우릿산 물리 치고 퀘스트를 완료 하기 위해 공주는 살아있어야 합니다.  공주가 죽으면 던전 전체를 초기화하고 다시 시도해야 합니다.  만약 성공한다면, 당신은 공주에게 퀘스트를 완료 할수 있습니다. 그녀는 당신의 보상을 위해 오그리마에 대족장 스랄에게 보낼 것입니다."
Inst1Quest15_HORDE_Prequest = "사령관 고르샤크 -> 동부 왕국"
Inst1Quest15_HORDE_Folgequest = "구출된 공주?"
--
Inst1Quest15name1_HORDE = "스랄의 결의"
Inst1Quest15name2_HORDE = "오그리마의 눈"

--Quest 16 Horde  (same as Quest 12 Alliance)
Inst1Quest16_HORDE = "16. 심장부와의 조화" -- Attunement to the Core
Inst1Quest16_HORDE_Aim = Inst1Quest12_Aim
Inst1Quest16_HORDE_Location = Inst1Quest12_Location
Inst1Quest16_HORDE_Note = Inst1Quest12_Note
Inst1Quest16_HORDE_Prequest = Inst1Quest12_Prequest
Inst1Quest16_HORDE_Folgequest = Inst1Quest12_Folgequest
-- No Rewards for this quest

--Quest 17 Horde  (same as Quest 13 Alliance)
Inst1Quest17_HORDE = "17. 도전" -- The Challenge
Inst1Quest17_HORDE_Aim = Inst1Quest13_Aim
Inst1Quest17_HORDE_Location = Inst1Quest13_Location
Inst1Quest17_HORDE_Note = Inst1Quest13_Note
Inst1Quest17_HORDE_Prequest = Inst1Quest13_Prequest
Inst1Quest17_HORDE_Folgequest = Inst1Quest13_Folgequest
-- No Rewards for this quest

--Quest 18 Horde  (same as Quest 14 Alliance)
Inst1Quest18_HORDE = "18. 유령의 성배" -- The Spectral Chalice
Inst1Quest18_HORDE_Aim = Inst1Quest14_Aim
Inst1Quest18_HORDE_Location = Inst1Quest14_Location
Inst1Quest18_HORDE_Note = Inst1Quest14_Note
Inst1Quest18_HORDE_Prequest = Inst1Quest14_Prequest
Inst1Quest18_HORDE_Folgequest = Inst1Quest14_Folgequest
-- No Rewards for this quest



--------------- INST2 - Blackwing Lair 검은바위 산:검은날개 둥지 ---------------

Inst2Caption = "검은날개 둥지"
Inst2QAA = "3 퀘스트"
Inst2QAH = "3 퀘스트"

--Quest 1 Alliance
Inst2Quest1 = "1. 네파리우스의 타락" -- Nefarius's Corruption
Inst2Quest1_Aim = "네파리안을 처치하고 붉은색 홀 파편을 되찾아 타나리스의 시간의 동굴에 있는 아나크로노스에게 돌아가십시오. 5시간 내에 임무를 완수해야 합니다."
Inst2Quest1_Location = "타락한 밸라스트라즈 (검은날개 둥지; "..YELLOW.."[2]"..WHITE..")"
Inst2Quest1_Note = "오직 한 사람만이 파편을 획득 할 수 있다.  아나크로노스는 (타나리스 - 시간의 동굴; "..YELLOW.."65, 49"..WHITE..") 에 있다"
Inst2Quest1_Prequest = "없음"
Inst2Quest1_Folgequest = "없음"
--
Inst2Quest1name1 = "마노 장식 다리보호구"
Inst2Quest1name2 = "그림자 보호의 아뮬렛"

--Quest 2 Alliance
Inst2Quest2 = "2. 검은바위부족의 군주" -- The Lord of Blackrock
Inst2Quest2_Aim = "스톰윈드에 있는 국왕 바리안 린에게 네파리안의 머리를 가져가야 합니다."
Inst2Quest2_Location = "네파리안의 머리 (네파리안에서 드랍; "..YELLOW.."[8]"..WHITE..")"
Inst2Quest2_Note = "대영주 볼바르 폴드라곤은 (스톰윈드 - 스톰윈드 왕궁; "..YELLOW.."78.0, 18.0"..WHITE..")에 있다. \n다음 퀘스트는 야전사령관 아프라샤비에게 (스톰윈드 - 영웅의 계곡; "..YELLOW.."66.9, 72.38"..WHITE..") 보상을 요청합니다."
Inst2Quest2_Prequest = "없음"
Inst2Quest2_Folgequest = "검은바위부족의 군주 (2)"
--
Inst2Quest2name1 = "용사냥꾼의 메달"
Inst2Quest2name2 = "용사냥꾼의 수정구"
Inst2Quest2name3 = "용사냥꾼의 반지"

--Quest 3 Alliance
Inst2Quest3 = "3. 최후의 한 명" -- Only One May Rise
Inst2Quest3_Aim = "실리더스의 세나리온 요새에 있는 흐르는 모래의 바리스톨스에게 용기대장 래쉬레이어의 머리를 가져가야 합니다."
Inst2Quest3_Location = "용기대장 래쉬레이어의 머리 (용기대장 래쉬레이어에서 드랍; "..YELLOW.."[3]"..WHITE..")"
Inst2Quest3_Note = "오직 한 사람만이 머리를 획득 할 수 있습니다."
Inst2Quest3_Prequest = "없음"
Inst2Quest3_Folgequest = "정의의 길"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst2Quest1_HORDE = Inst2Quest1
Inst2Quest1_HORDE_Aim = Inst2Quest1_Aim
Inst2Quest1_HORDE_Location = Inst2Quest1_Location
Inst2Quest1_HORDE_Note = Inst2Quest1_Note
Inst2Quest1_HORDE_Prequest = Inst2Quest1_Prequest
Inst2Quest1_HORDE_Folgequest = Inst2Quest1_Folgequest
--
Inst2Quest1name1_HORDE = Inst2Quest1name1
Inst2Quest1name2_HORDE = Inst2Quest1name2

--Quest 2 Horde
Inst2Quest2_HORDE = "2. 검은바위부족의 군주" -- The Lord of Blackrock
Inst2Quest2_HORDE_Aim = "오그리마에 있는 스랄에게 네파리안의 머리를 가져가야 합니다."
Inst2Quest2_HORDE_Location = "네파리안의 머리 (네파리안 드랍; "..YELLOW.."[8]"..WHITE..")"
Inst2Quest2_HORDE_Note = "다음 퀘스트는 대군주 사울팽에게 (오그리마 - 힘의 골짜기; "..YELLOW.."51.6, 76.0"..WHITE..") 보상을 요청합니다."
Inst2Quest2_HORDE_Prequest = "없음"
Inst2Quest2_HORDE_Folgequest = "검은바위부족의 군주 (2)"
--
Inst2Quest2name1_HORDE = "용사냥꾼의 메달"
Inst2Quest2name2_HORDE = "용사냥꾼의 수정구"
Inst2Quest2name3_HORDE = "용사냥꾼의 반지"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst2Quest3_HORDE = Inst2Quest3
Inst2Quest3_HORDE_Aim = Inst2Quest3_Aim
Inst2Quest3_HORDE_Location = Inst2Quest3_Location
Inst2Quest3_HORDE_Note = Inst2Quest3_Note
Inst2Quest3_HORDE_Prequest = Inst2Quest3_Prequest
Inst2Quest3_HORDE_Folgequest = Inst2Quest3_Folgequest
-- No Rewards for this quest



--------------- INST3 - Lower Blackrock Spire 검은바위 산:검은바위 첨탑 하층 ---------------

Inst3Caption = "검은바위 첨탑 (하층)"
Inst3QAA = "14 퀘스트"
Inst3QAH = "14 퀘스트"

--Quest 1 Alliance
Inst3Quest1 = "1. 마지막 서판" -- The Final Tablets
Inst3Quest1_Aim = "다섯 번째와 여섯 번째 모쉬아루 서판을 타나리스에 있는 발굴조사단장 아이언부트에게 갖다주어야 합니다."
Inst3Quest1_Location = "발굴조사단장 아이언부트 (타나리스 - 스팀휘들 항구; "..YELLOW.."66.8, 24.0"..WHITE..")"
Inst3Quest1_Note = "서판은 어둠사냥꾼 보쉬가진 "..YELLOW.."[7]"..WHITE.." 그리고 대장군 부네 "..YELLOW.."[9]"..WHITE.." 에서 찾을 수 있습니다.\n보상은 다음 퀘스트에서 주어집니다.  퀘스트 라인은 타나리스의 예킨야에서 시작됩니다. ("..YELLOW.."67.0, 22.4"..WHITE..")."
Inst3Quest1_Prequest = "계곡천둥매의 영혼 -> 모쉬아루의 잃어버린 서판"
Inst3Quest1_Folgequest = "예킨야와의 대면"
--
Inst3Quest1name1 = "빛 바랜 학카리 망토"
Inst3Quest1name2 = "너덜너덜한 학카리 단망토"

--Quest 2 Alliance
Inst3Quest2 = "2. 키블러의 진귀한 애완동물" -- Kibler's Exotic Pets
Inst3Quest2_Aim = "검은바위 첨탑으로 가서 새끼 도끼부대 검은늑대를 찾아야 합니다. 우리를 사용하여 이 사나운 야수들을 운반하여 키블러에게 사로잡은 새끼 검은늑대를 가져가야 합니다."
Inst3Quest2_Location = "키블러 (불타는 평원 - 화염마루; "..YELLOW.."65.8, 22.0"..WHITE..")"
Inst3Quest2_Note = "할리콘 근처에서 새끼 검은늑대를 찾을 수 있습니다. "..YELLOW.."[17]"..WHITE.."."
Inst3Quest2_Prequest = "없음"
Inst3Quest2_Folgequest = "없음"
--
Inst3Quest2name1 = "검은늑대 우리"

--Quest 3 Alliance
Inst3Quest3 = "3. 더러운 거미알" -- En-Ay-Es-Tee-Why
Inst3Quest3_Aim = "검은바위 첨탑으로 가서 키블러를 위해 첨탑 거미알 15개를 수집해야 합니다. \n\n들리는 소문으로는 그 알들은 거미들이 서식하는 근처에서 찾을 수 있다고 합니다."
Inst3Quest3_Location = "키블러 (불타는 평원 - 화염마루; "..YELLOW.."65.8, 22.0"..WHITE..")"
Inst3Quest3_Note = "여왕 불그물거미 근처에서 첨탑 거미알을 찾을 수 있습니다. "..YELLOW.."[13]"..WHITE.."."
Inst3Quest3_Prequest = "없음"
Inst3Quest3_Folgequest = "없음"
--
Inst3Quest3name1 = "불그물거미 알주머니"

--Quest 4 Alliance
Inst3Quest4 = "4. 여왕 거미의 독" -- Mother's Milk
Inst3Quest4_Aim = "검은바위 첨탑 중심부에서 여왕 불그물거미를 찾을 수 있습니다. 여왕 불그물거미를 공격하거나 접근하여 그 독에 중독되어야 합니다. 독에 걸릴 확률을 높이기 위해서는 거미를 죽여야 할 수도 있습니다. 중독되면 털보 존에게 돌아가서 그가 그 독을 추출하게 해야 합니다."
Inst3Quest4_Location = "털보 존 (불타는 평원 - 화염마루; "..YELLOW.."65.0, 23.6"..WHITE..")"
Inst3Quest4_Note = "여왕 불그물거미는 "..YELLOW.."[13]"..WHITE.." 에 있다. 독 효과는 근처 플레이어에게도 영향을줍니다. 제거되거나 해제되면 퀘스트에 실패합니다."
Inst3Quest4_Prequest = "없음"
Inst3Quest4_Folgequest = "없음"
--
Inst3Quest4name1 = "털보 존의 마법 술잔"

--Quest 5 Alliance
Inst3Quest5 = "5. 검은늑대 위협의 근원 파괴" -- Put Her Down
Inst3Quest5_Aim = "검은바위 첨탑으로 가서 검은늑대 위협의 근원을 파괴해야 합니다. 헬렌디스를 떠날 때 헬렌디스가 오크들이 특정한 검은늑대를 부르는 말인 할리콘이라는 이름을 외치는 것을 들었습니다."
Inst3Quest5_Location = "헬렌디스 리버혼 (불타는 평원 - 모건의 망루; "..YELLOW.."85.6, 68.8"..WHITE..")"
Inst3Quest5_Note = "할리콘은 "..YELLOW.."[17]"..WHITE.." 에서 찾을 수 있습니다."
Inst3Quest5_Prequest = "없음"
Inst3Quest5_Folgequest = "없음"
--
Inst3Quest5name1 = "아스토리아 로브"
Inst3Quest5name2 = "올가미 웃옷"
Inst3Quest5name3 = "바취비늘 흉갑"

--Quest 6 Alliance
Inst3Quest6 = "6. 우로크 둠하울" -- Urok Doomhowl
Inst3Quest6_Aim = "와로쉬의 두루마리를 읽어야 합니다. 와로쉬에게 그의 부적을 가져가야 합니다."
Inst3Quest6_Location = "와로쉬 (검은바위 첨탑; "..YELLOW.."[2]"..WHITE..")"
Inst3Quest6_Note = "와로쉬의 모조를 얻으려면 우로크 둠하울을 불러 처치해야한다. "..YELLOW.."[15]"..WHITE..".  그를 소환을 위해 날카로운 장창 "..YELLOW.."[3]"..WHITE.." 그리고 오모크의 머리 "..YELLOW.."[5]"..WHITE.." 가 필요합니다.  소환하는 동안 우로크 둠하울이 당신을 공격하기 전에 몇차례의 오우거가 나타납니다.  전투중에 창을 사용하여 오우거에게 데미지를 입힐 수 있습니다."
Inst3Quest6_Prequest = "없음"
Inst3Quest6_Folgequest = "없음"
--
Inst3Quest6name1 = "오색 부적"

--Quest 7 Alliance
Inst3Quest7 = "7. 비쥬의 소지품!" -- Bijou's Belongings
Inst3Quest7_Aim = "비쥬의 소지품을 찾아 그녀에게 돌려줘야 합니다!"
Inst3Quest7_Location = "비쥬 (검은바위 첨탑; "..YELLOW.."[8]"..WHITE..")"
Inst3Quest7_Note = "여왕 불그물거미로 "..YELLOW.."[13]"..WHITE.." 가는 길에 비쥬의 소지품 찾을 수 있습니다.\n다음은 치안대장 맥스웰에게 이어집니다. (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.8"..WHITE..")."
Inst3Quest7_Prequest = "없음"
Inst3Quest7_Folgequest = "멕스웰에게의 전보"
-- No Rewards for this quest

--Quest 8 Alliance
Inst3Quest8 = "8. 맥스웰의 임무" -- Maxwell's Mission
Inst3Quest8_Aim = "검은바위 첨탑으로 가서 대장군 부네와 대군주 오모크, 그리고 요새의 대군주 웜타라크를 처치해야 합니다. 임무를 완수하면 맥스웰 치안 대장에게 돌아가십시오."
Inst3Quest8_Location = "치안대장 맥스웰 (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.8"..WHITE..")"
Inst3Quest8_Note = "대장군 부네는 "..YELLOW.."[9]"..WHITE..", 대군주 오모크는 "..YELLOW.."[5]"..WHITE.." 그리고 대군주 웜타라크는 "..YELLOW.."[19]"..WHITE.." 에서 찾을 수 있습니다."
Inst3Quest8_Prequest = "멕스웰에게의 전보"
Inst3Quest8_Folgequest = "없음"
--
Inst3Quest8name1 = "윔타라크의 족쇄"
Inst3Quest8name2 = "오모크의 허리죔쇠"
Inst3Quest8name3 = "할리콘의 재갈"
Inst3Quest8name4 = "보쉬가진의 허리끈"
Inst3Quest8name5 = "부네의 사술 장갑"

--Quest 9 Alliance
Inst3Quest9 = "9. 승천의 인장" -- Seal of Ascension
Inst3Quest9_Aim = "사령관의 세 가지 보석인 가시불꽃부족 보석, 뾰족바위일족 보석, 도끼부대 보석을 찾아, 가공하지 않은 승천의 인장과 함께 밸란에게 가져가야 합니다.밸란이 말한 장군들은 가시불꽃부족의 대장군 부네, 뾰족바위일족의 대군주 오모크와 도끼부대의 대군주 웜타라크입니다."
Inst3Quest9_Location = "밸란 (검은바위 첨탑; "..YELLOW.."[1]"..WHITE..")"
Inst3Quest9_Note = "이것은 검은바위 첨탐 상층 열쇠 퀘스트 입니다.  대군주 오모크에게 뾰족바위일족 보석을 "..YELLOW.."[5]"..WHITE..", 대장군 부네에게 가시불꽃부족 보석을 "..YELLOW.."[9]"..WHITE.." 그리고 대군주 웜타라크에게 도끼부대 보석을 "..YELLOW.."[19]"..WHITE.." 얻습니다.  가공하지 않은 승천의 인장은 검은바위 첨탐 하층 모든 몬스터나 던전 밖에서도 드랍할 수 있습니다."
Inst3Quest9_Prequest = "없음"
Inst3Quest9_Folgequest = "승천의 인장 (2)"
-- No Rewards for this quest

--Quest 10 Alliance
Inst3Quest10 = "10. 사령관 드라키사스의 명령서" -- General Drakkisath's Command
Inst3Quest10_Aim = "불타는 평원에 있는 치안대장 맥스웰에게 사령관 드라키사스의 명령서를 가져가야 합니다."
Inst3Quest10_Location = "사령관 드라키사스의 명령서 (대군주 웜타라크에서 드랍; "..YELLOW.."[19]"..WHITE..")"
Inst3Quest10_Note = "치안대장 맥스웰은 불타는 평원 - 모건의 망루에 있습니다; ("..YELLOW.."84.6, 68.8"..WHITE..")."
Inst3Quest10_Prequest = "없음"
Inst3Quest10_Folgequest = "사령관 드라키사스 처치 ("..YELLOW.."검은바위 첨탐 상층"..WHITE..")"
-- No Rewards for this quest

--Quest 11 Alliance
Inst3Quest11 = "11. 군주 발타라크의 아뮬렛 왼쪽 조각" -- The Left Piece of Lord Valthalak's Amulet
Inst3Quest11_Aim = "부름의 화로를 사용하여 모르 그레이후프 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst3Quest11_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst3Quest11_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n모르 그레이후프는 "..YELLOW.."[9]"..WHITE.." 에서 소환 된다."
Inst3Quest11_Prequest = "중요한 요소"
Inst3Quest11_Folgequest = "예언속의 알카즈 섬"
-- No Rewards for this quest

--Quest 12 Alliance
Inst3Quest12 = "12. 군주 발타라크의 아뮬렛 오른쪽 조각" -- The Right Piece of Lord Valthalak's Amulet
Inst3Quest12_Aim = "부름의 화로를 사용하여 모르 그레이후프 영혼을 소환한 후 처치하십시오. 완성된 군주 발타라크의 아뮬렛과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst3Quest12_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst3Quest12_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n모르 그레이후프는 "..YELLOW.."[9]"..WHITE.." 에서 소환 된다."
Inst3Quest12_Prequest = "또 다른 중요한 요소"
Inst3Quest12_Folgequest = "마지막 준비 ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
-- No Rewards for this quest

--Quest 13 Alliance
Inst3Quest13 = "13. 어둠사냥꾼의 뱀돌" -- Snakestone of the Shadow Huntress
Inst3Quest13_Aim = "검은바위 첨탑으로 가서 어둠사냥꾼 보쉬가진을 처치하고 보쉬가진의 뱀돌을 킬램에게 갖다주어야 합니다."
Inst3Quest13_Location = "킬램 (여명의 설원 - 눈망루 마을; "..YELLOW.."61.2, 37.0"..WHITE..")"
Inst3Quest13_Note = "대장기술 퀘스트.  어둠사냥꾼 보쉬가진은 "..YELLOW.."[7]"..WHITE.." 에 있다."
Inst3Quest13_Prequest = "없음"
Inst3Quest13_Folgequest = "없음"
--
Inst3Quest13name1 = "도면: 여명의 도끼"

--Quest 14 Alliance
Inst3Quest14 = "14. 뜨거운 화형" -- Hot Fiery Death
Inst3Quest14_Aim = "아제로스 어딘가에 누군가가 이 건틀릿으로 뭘 해야 하는지 알고 있을 겁니다. 행운을 빕니다!"
Inst3Quest14_Location = "인간 해골 (검은바위 첨탐 하층; "..YELLOW.."[11]"..WHITE..")"
Inst3Quest14_Note = "대장기술 퀘스트.  인간의 유해 근처에 불타지 않은 판금 건틀릿을 주워야 합니다. "..YELLOW.."[11]"..WHITE..". 말리퍼스 다크해머에게 이어집니다. (여명의 설원 - 눈망루 마을; "..YELLOW.."61.0, 38.6"..WHITE..").  다음은 후속 퀘스트에 대한 보상입니다."
Inst3Quest14_Prequest = "없음"
Inst3Quest14_Folgequest = "불꽃의 판금 건틀릿"
--
Inst3Quest14name1 = "도면: 불꽃의 판금 건틀릿"
Inst3Quest14name2 = "불꽃의 판금 건틀릿"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst3Quest1_HORDE = Inst3Quest1
Inst3Quest1_HORDE_Aim = Inst3Quest1_Aim
Inst3Quest1_HORDE_Location = Inst3Quest1_Location
Inst3Quest1_HORDE_Note = Inst3Quest1_Note
Inst3Quest1_HORDE_Prequest = Inst3Quest1_Prequest
Inst3Quest1_HORDE_Folgequest = Inst3Quest1_Folgequest
--
Inst3Quest1name1_HORDE = Inst3Quest1name1
Inst3Quest1name2_HORDE = Inst3Quest1name2

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst3Quest2_HORDE = Inst3Quest2
Inst3Quest2_HORDE_Aim = Inst3Quest2_Aim
Inst3Quest2_HORDE_Location = Inst3Quest2_Location
Inst3Quest2_HORDE_Note = Inst3Quest2_Note
Inst3Quest2_HORDE_Prequest = Inst3Quest2_Prequest
Inst3Quest2_HORDE_Folgequest = Inst3Quest2_Folgequest
--
Inst3Quest2name1_HORDE = Inst3Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst3Quest3_HORDE = Inst3Quest3
Inst3Quest3_HORDE_Aim = Inst3Quest3_Aim
Inst3Quest3_HORDE_Location = Inst3Quest3_Location
Inst3Quest3_HORDE_Note = Inst3Quest3_Note
Inst3Quest3_HORDE_Prequest = Inst3Quest3_Prequest
Inst3Quest3_HORDE_Folgequest = Inst3Quest3_Folgequest
--
Inst3Quest3name1_HORDE = Inst3Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst3Quest4_HORDE = Inst3Quest4
Inst3Quest4_HORDE_Aim = Inst3Quest4_Aim
Inst3Quest4_HORDE_Location = Inst3Quest4_Location
Inst3Quest4_HORDE_Note = Inst3Quest4_Note
Inst3Quest4_HORDE_Prequest = Inst3Quest4_Prequest
Inst3Quest4_HORDE_Folgequest = Inst3Quest4_Folgequest
--
Inst3Quest4name1_HORDE = Inst3Quest4name1

--Quest 5 Horde
Inst3Quest5_HORDE = "5. 검은늑대 무리의 어미" -- The Pack Mistress
Inst3Quest5_HORDE_Aim = "도끼부대 검은늑대 무리의 어미, 할리콘을 처치해야 합니다."
Inst3Quest5_HORDE_Location = "명사수 갈라마브 (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE..")"
Inst3Quest5_HORDE_Note = "당신이 할리콘을 찾는다면 "..YELLOW.."[17]"..WHITE.."."
Inst3Quest5_HORDE_Prequest = "없음"
Inst3Quest5_HORDE_Folgequest = "없음"
--
Inst3Quest5name1_HORDE = "아스토리아 로브"
Inst3Quest5name2_HORDE = "올가미 웃옷"
Inst3Quest5name3_HORDE = "비취비늘 흉갑"

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst3Quest6_HORDE = Inst3Quest6
Inst3Quest6_HORDE_Aim = Inst3Quest6_Aim
Inst3Quest6_HORDE_Location = Inst3Quest6_Location
Inst3Quest6_HORDE_Note = Inst3Quest6_Note
Inst3Quest6_HORDE_Prequest = Inst3Quest6_Prequest
Inst3Quest6_HORDE_Folgequest = Inst3Quest6_Folgequest
--
Inst3Quest6name1_HORDE = Inst3Quest6name1

--Quest 7 Horde
Inst3Quest7_HORDE = "7. 요원 비쥬" -- Operative Bijou
Inst3Quest7_HORDE_Aim = "검은바위 첨탑으로 가서 비쥬에게 무슨 일이 생겼는지 알아봐야 합니다."
Inst3Quest7_HORDE_Location = "렉스로트 (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE..")"
Inst3Quest7_HORDE_Note = "비쥬는 "..YELLOW.."[8]"..WHITE.." 에서 찾을 수 있습니다."
Inst3Quest7_HORDE_Prequest = "없음"
Inst3Quest7_HORDE_Folgequest = "비쥬의 물건들"
-- No Rewards for this quest

--Quest 8 Horde
Inst3Quest8_HORDE = "8. 비쥬의 물건들" -- Bijou's Belongings
Inst3Quest8_HORDE_Aim = "비쥬의 소지품을 찾아서 그녀에게 돌아가야 합니다. 비쥬가 도시의 바닥에 소지품을 숨겼다고 했습니다."
Inst3Quest8_HORDE_Location = "비쥬 (검은바위 첨탐; "..YELLOW.."[8]"..WHITE..")"
Inst3Quest8_HORDE_Note = "여왕 불그물거미로 "..YELLOW.."[13]"..WHITE.." 가는 길에 비쥬의 소지품 찾을 수 있습니다.\n아래 보상은 렉스로트에게 돌아가는 후속 퀘스트에 대한 것입니다. (황야의 땅 - 카르가스; "..YELLOW.."5.8, 47.6"..WHITE..")."
Inst3Quest8_HORDE_Prequest = "요원 비쥬"
Inst3Quest8_HORDE_Folgequest = "비쥬의 정찰 보고"
--
Inst3Quest8name1_HORDE = "높새바람 장갑"
Inst3Quest8name2_HORDE = "바다말뚝 허리띠"

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst3Quest9_HORDE = Inst3Quest9
Inst3Quest9_HORDE_Aim = Inst3Quest9_Aim
Inst3Quest9_HORDE_Location = Inst3Quest9_Location
Inst3Quest9_HORDE_Note = Inst3Quest9_Note
Inst3Quest9_HORDE_Prequest = Inst3Quest9_Prequest
Inst3Quest9_HORDE_Folgequest = Inst3Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde
Inst3Quest10_HORDE = "10. 장군의 명령" -- Warlord's Command
Inst3Quest10_HORDE_Aim = "대군주 오모크와 대장군 부네, 대군주 웜타라크를 처단해야 합니다. 검은바위의 중요한 문서들을 확보해야 합니다. 임무를 완수하는 대로 카르가스의 장군 고어투스에게로 돌아가야 합니다."
Inst3Quest10_HORDE_Location = "장군 고어투스 (황야의 땅 - 카르가스; "..YELLOW.."65,22"..WHITE..")"
Inst3Quest10_HORDE_Note = "오닉시아 퀘스트 라인.  대군주 오모크는 "..YELLOW.."[5]"..WHITE..", 대장군 부네는 "..YELLOW.."[9]"..WHITE.." 그리고 대군주 웜타라크는 "..YELLOW.."[19]"..WHITE.." 에서 찾을 수 있습니다.  중요한 검은바위 문서는 이 3명의 보스 중 한명 옆에 나타납니다."
Inst3Quest10_HORDE_Prequest = "없음"
Inst3Quest10_HORDE_Folgequest = "아이트리그의 지혜 -> 호드를 위하여! ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
--
Inst3Quest10name1_HORDE = "윔타라크의 족쇄"
Inst3Quest10name2_HORDE = "오모크의 허리죔쇠"
Inst3Quest10name3_HORDE = "할리콘의 재갈"
Inst3Quest10name4_HORDE = "보쉬가진의 허리끈"
Inst3Quest10name5_HORDE = "부네의 사술 장갑"

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst3Quest11_HORDE = Inst3Quest11
Inst3Quest11_HORDE_Aim = Inst3Quest11_Aim
Inst3Quest11_HORDE_Location = Inst3Quest11_Location
Inst3Quest11_HORDE_Note = Inst3Quest11_Note
Inst3Quest11_HORDE_Prequest = Inst3Quest11_Prequest
Inst3Quest11_HORDE_Folgequest = Inst3Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst3Quest12_HORDE = Inst3Quest12
Inst3Quest12_HORDE_Aim = Inst3Quest12_Aim
Inst3Quest12_HORDE_Location = Inst3Quest12_Location
Inst3Quest12_HORDE_Note = Inst3Quest12_Note
Inst3Quest12_HORDE_Prequest = Inst3Quest12_Prequest
Inst3Quest12_HORDE_Folgequest = Inst3Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst3Quest13_HORDE = Inst3Quest13
Inst3Quest13_HORDE_Aim = Inst3Quest13_Aim
Inst3Quest13_HORDE_Location = Inst3Quest13_Location
Inst3Quest13_HORDE_Note = Inst3Quest13_Note
Inst3Quest13_HORDE_Prequest = Inst3Quest13_Prequest
Inst3Quest13_HORDE_Folgequest = Inst3Quest13_Folgequest
--
Inst3Quest13name1_HORDE = Inst3Quest13name1

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst3Quest14_HORDE = Inst3Quest14
Inst3Quest14_HORDE_Aim = Inst3Quest14_Aim
Inst3Quest14_HORDE_Location = Inst3Quest14_Location
Inst3Quest14_HORDE_Note = Inst3Quest14_Note
Inst3Quest14_HORDE_Prequest = Inst3Quest14_Prequest
Inst3Quest14_HORDE_Folgequest = Inst3Quest14_Folgequest
--
Inst3Quest14name1_HORDE = Inst3Quest14name1
Inst3Quest14name2_HORDE = Inst3Quest14name2



--------------- INST4 - Upper Blackrock Spire 검은바위 첨탑 상층 ---------------

Inst4Caption = "검은바위 첨탑 (상층)"
Inst4QAA = "12 퀘스트"
Inst4QAH = "13 퀘스트"

--Quest 1 Alliance
Inst4Quest1 = "1. 대섭정" -- The Matron Protectorate
Inst4Quest1_Aim = "여명의 설원으로 가서 헬레를 찾아 그녀에게 아우비의 비늘을 전해야 합니다."
Inst4Quest1_Location = "아우비 (검은바위 첨탑; "..YELLOW.."[7]"..WHITE..")"
Inst4Quest1_Note = "투기장 뒤의 방에서 아우비를 찾을 수 있습니다. "..YELLOW.."[7]"..WHITE..".  그녀는 돌출부 위에 쓰러져 있다.\n헬레는 여명의 설원에 있습니다. ("..YELLOW.."54.4, 51.2"..WHITE..").  좌표에서 시작하는 동굴이 있습니다. "..YELLOW.."57.0, 50.0"..WHITE..".  그 동굴의 끝에는 당신을 헬레로 순간 이동시키는 포털이 있습니다."
Inst4Quest1_Prequest = "없음"
Inst4Quest1_Folgequest = "푸른용군단의 분노"
-- No Rewards for this quest

--Quest 2 Alliance
Inst4Quest2 = "2. 핀클 에인혼, 명을 받듭니다!" -- Finkle Einhorn, At Your Service!
Inst4Quest2_Aim = "눈망루 마을에 있는 말리퍼스 다크해머와 대화해야 합니다."
Inst4Quest2_Location = "핀클 에인혼 (검은바위 첨탑; "..YELLOW.."[8]"..WHITE..")"
Inst4Quest2_Note = "핀클 에인혼은 괴수를 무두질하게 되면 나타납니다.  말리퍼스 다크해머는 (여명의 설원 - 눈망루 마을; "..YELLOW.."61.0, 38.6"..WHITE..") 에서 찾을 수 있습니다."
Inst4Quest2_Prequest = "없음"
Inst4Quest2_Folgequest = "아카나의 다리보호구, 붉은 학자의 모자, 핏빛갈증의 흉갑"
-- No Rewards for this quest

--Quest 3 Alliance
Inst4Quest3 = "3. 알껍질 냉동" -- Egg Freezing
Inst4Quest3_Aim = "알껍질급속냉각기 견본을 둥지에 있는 알에 사용해야 합니다."
Inst4Quest3_Location = "팅키 스팀보일 (블타는 평원 - 화염마루; "..YELLOW.."65.2, 23.8"..WHITE..")"
Inst4Quest3_Note = "태초의 불꽃 방에서 알을 찾을 수 있습니다. "..YELLOW.."[2]"..WHITE.."."
Inst4Quest3_Prequest = "새끼용의 정수 -> 팅키 스팀보일"
Inst4Quest3_Folgequest = "알 수집"
--
Inst4Quest3name1 = "알껍질급속냉각기"

--Quest 4 Alliance
Inst4Quest4 = "4. 엠버시어의 눈" -- Eye of the Emberseer
Inst4Quest4_Aim = "아즈샤라에 있는 군주 히드락시스에게 엠버시어의 눈을 가져가야 합니다."
Inst4Quest4_Location = "군주 히드락시스 (아즈샤라; "..YELLOW.."79.2, 73.6"..WHITE..")"
Inst4Quest4_Note = "불의수호자 엠버시어는 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다.  이 퀘스트는 결국 화산 심장부 공격대에 필요한 물의 정기를 제공합니다."
Inst4Quest4_Prequest = "독이 든 물"
Inst4Quest4_Folgequest = "화산 심장부"
-- No Rewards for this quest

--Quest 5 Alliance
Inst4Quest5 = "5. 사령관 드라키사스 처치" -- General Drakkisath's Demise
Inst4Quest5_Aim = "검은바위 첨탑으로 가서 사령관 드라키사스를 처치해야 합니다."
Inst4Quest5_Location = "치안대장 맥스웰 (불타는 평원 - 모건의 망루; "..YELLOW.."84.6, 68.8"..WHITE..")"
Inst4Quest5_Note = "사령관 드라키사스는 "..YELLOW.."[9]"..WHITE.." 에서 찾을 수 있습니다."
Inst4Quest5_Prequest = "사령관 드라키사스의 명령서 ("..YELLOW.."검은바위 첨탑 하층"..WHITE..")"
Inst4Quest5_Folgequest = "없음"
--
Inst4Quest5name1 = "폭정의 징표"
Inst4Quest5name2 = "괴수의 눈"
Inst4Quest5name3 = "불랙핸드의 팔찌"

--Quest 6 Alliance
Inst4Quest6 = "6. 파멸의 기념물" -- Doomrigger's Clasp
Inst4Quest6_Aim = "불타는 평원에 있는 마야라 브라이트윙에게 파멸의 기념물을 가져가야 합니다."
Inst4Quest6_Location = "마야라 브라이트윙 (불타는 평원 - 모건의 망루; "..YELLOW.."84.8, 69.0"..WHITE..")"
Inst4Quest6_Note = "선행 퀘스트는 백작 레밍턴 리지웰에서 받습니다. (스톰윈드 - 스톰윈드 왕궁; "..YELLOW.."74.0, 30.0"..WHITE..").\n\n파멸의 기념물은 "..YELLOW.."[3]"..WHITE.." 상자안에 있습니다.  나열된 보상은 후속 퀘스트에 대한 것입니다."
Inst4Quest6_Prequest = "마야라 브라이트윙"
Inst4Quest6_Folgequest = "리지웰에게 가져가기"
--
Inst4Quest6name1 = "날쌘발 정화"
Inst4Quest6name2 = "명멸의 손목보호대"

--Quest 7 Alliance
Inst4Quest7 = "7. 블랙핸드의 명령서" -- Blackhand's Command
Inst4Quest7_Aim = "아주 멍청한 오크로군요. 지배의 보주를 사용하려면 드라키사스의 낙인을 찾아 드라키사스의 징표를 받아야 할 거 같습니다.\n\n이 편지에 따르면 드라키사스 사령관이 낙인을 지키고 있다고 하니 조사해 보는 것이 좋겠습니다."
Inst4Quest7_Location = "블랙핸드의 명령서 (방패부대 병참장교에서 드랍; "..YELLOW.."[7] 입구지도"..WHITE..")"
Inst4Quest7_Note = "검은날개 둥지 입장 퀘스트. 검은바위 첨탑 포털 바로 앞에서 오른쪽으로 돌면 방패부대 병참장교를 발견할 수 있습니다.\n\n사령관 드라키사스는 "..YELLOW.."[9]"..WHITE.." 에 있다. 낙인은 그의 뒤에 있습니다."
Inst4Quest7_Prequest = "없음"
Inst4Quest7_Folgequest = "없음"
-- No Rewards for this quest

--Quest 8 Alliance
Inst4Quest8 = "8. 마지막 준비" -- Final Preparations
Inst4Quest8_Aim = "검은바위 팔보호구 40개와 강력한 마력의 영약을 구한 후, 검은바위 산에 있는 보들리에게 가져가야 합니다."
Inst4Quest8_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst4Quest8_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.  검은바위 팔보호구 검은바위 첨탑 상하층 던전과 바깥쪽 몬스터들도 드랍합니다.  '검은손'이란 이름을 가진 몬스터들은 팔보호구를 드랍할 확률이 높습니다.  강력한 마력의 영약은 연금술사에 의해 만들어집니다.  검은바위 첨탑 하층, 혈투의 전장, 스트라솔름 및 스칼로맨스의 선행 퀘스트에서 재료를 얻습니다."
Inst4Quest8_Prequest = "군주 발타라크의 아뮬렛 오른쪽 조각"
Inst4Quest8_Folgequest = "군주 발타라크여, 내 탓이오."
-- No Rewards for this quest

--Quest 9 Alliance
Inst4Quest9 = "9. 군주 발타라크여, 내 탓이오." -- Mea Culpa, Lord Valthalak
Inst4Quest9_Aim = "부름의 화로를 사용하여 군주 발타라크를 소환하십시오. 군주 발타라크를 처치하고 그의 시체에 군주 발타라크의 아뮬렛을 사용한 후, 군주 발타라크의 영혼에게 군주 발타라크의 아뮬렛을 돌려줘야 합니다."
Inst4Quest9_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst4Quest9_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.  군주 발타라크는 "..YELLOW.."[8]"..WHITE.." 에서 소환 된다.  나열된 보상은 후속 퀘스트에 대한 것입니다."
Inst4Quest9_Prequest = "마지막 준비"
Inst4Quest9_Folgequest = "보들리에게 돌아가기"
--
Inst4Quest9name1 = "기원의 화로"
Inst4Quest9name2 = "기원의 화로: 설명서"

--Quest 10 Alliance
Inst4Quest10 = "10. 악마의 룬" -- The Demon Forge
Inst4Quest10_Aim = "검은바위 첨탑으로 가서 고랄루크 앤빌크랙을 찾아 처치한 후, 핏물이 깃든 창을 그의 심장에 꽂으십시오. 창이 그의 영혼을 흡수하면 영혼이 깃든 창으로 변합니다. 벼려지지 않은 룬문자 흉갑도 찾아야 합니다. 꺼져 가는 심장에 이 창을 꽂아라. 그는 영혼을 내게 팔았으니 내가 가지겠다. 내 창과 그 도둑놈이 훔쳐간 흉갑을 가져오면 그자에게 주기로 한 가르침을 너에게 주겠다."
Inst4Quest10_Location = "로락스 (여명의 설원; "..YELLOW.."63.8, 73.6"..WHITE..")"
Inst4Quest10_Note = "대장기술 퀘스트.  고랄루크 앤빌크랙은 "..YELLOW.."[5]"..WHITE.." 에 있다."
Inst4Quest10_Prequest = "로락스의 이야기"
Inst4Quest10_Folgequest = "없음"
--
Inst4Quest10name1 = "도면: 악마의 룬 흉갑"
Inst4Quest10name2 = "악마의 가방"
Inst4Quest10name3 = "악마 사냥 전문화의 비약"

--Quest 11 Alliance
Inst4Quest11 = "11. 알 수집" -- Egg Collection
Inst4Quest11_Aim = "불타는 평원의 화염 마루에 있는 팅키 스팀보일에게 수집한 용의 알 8개를 가져가야 합니다."
Inst4Quest11_Location = "팅키 스팀보일 (불타는 평원 - 화염마루; "..YELLOW.."65.2, 23.8"..WHITE..")"
Inst4Quest11_Note = "태초의 불꽃 방에서 알을 찾을 수 있습니다. "..YELLOW.."[2]"..WHITE.."."
Inst4Quest11_Prequest = "알껍질 냉동"
Inst4Quest11_Folgequest = "리어니드 바돌로매 -> 여명의 계략 ("..YELLOW.."스칼로맨스"..WHITE..")"
-- No Rewards for this quest

--Quest 12 Alliance
Inst4Quest12 = "12. 비룡불꽃 아뮬렛" -- Drakefire Amulet
Inst4Quest12_Aim = "사령관 드라키사스에게서 검은용 용사의 피를 가져와야 합니다. 드라키사스는 검은바위 첨탑의 승천의 전당 뒤에 있는 알현실에 있습니다."
Inst4Quest12_Location = "Haleh (Winterspring; "..YELLOW.."54.4, 51.2"..WHITE..")"
Inst4Quest12_Note = "이것은 오닉시아 입장에 대한 마지막 퀘스트입니다.  퀘스트 라인을 시작하는 방법에 대한 자세한 정보는 검은바위 나락 퀘스트 '치안대장 윈저'에 있습니다.  사령관 드라키사스는 "..YELLOW.."[9]"..WHITE.." 에 있다."
Inst4Quest12_Prequest = "대단한 가장무도회 -> 용의 눈"
Inst4Quest12_Folgequest = "없음"
--
Inst4Quest12name1 = "비룡불꽃 아뮬렛"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst4Quest1_HORDE = Inst4Quest1
Inst4Quest1_HORDE_Aim = Inst4Quest1_Aim
Inst4Quest1_HORDE_Location = Inst4Quest1_Location
Inst4Quest1_HORDE_Note = Inst4Quest1_Note
Inst4Quest1_HORDE_Prequest = Inst4Quest1_Prequest
Inst4Quest1_HORDE_Folgequest = Inst4Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst4Quest2_HORDE = Inst4Quest2
Inst4Quest2_HORDE_Aim = Inst4Quest2_Aim
Inst4Quest2_HORDE_Location = Inst4Quest2_Location
Inst4Quest2_HORDE_Note = Inst4Quest2_Note
Inst4Quest2_HORDE_Prequest = Inst4Quest2_Prequest
Inst4Quest2_HORDE_Folgequest = Inst4Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst4Quest3_HORDE = Inst4Quest3
Inst4Quest3_HORDE_Aim = Inst4Quest3_Aim
Inst4Quest3_HORDE_Location = Inst4Quest3_Location
Inst4Quest3_HORDE_Note = Inst4Quest3_Note
Inst4Quest3_HORDE_Prequest = Inst4Quest3_Prequest
Inst4Quest3_HORDE_Folgequest = Inst4Quest3_Folgequest
--
Inst4Quest3name1_HORDE = Inst4Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst4Quest4_HORDE = Inst4Quest4
Inst4Quest4_HORDE_Aim = Inst4Quest4_Aim
Inst4Quest4_HORDE_Location = Inst4Quest4_Location
Inst4Quest4_HORDE_Note = Inst4Quest4_Note
Inst4Quest4_HORDE_Prequest = Inst4Quest4_Prequest
Inst4Quest4_HORDE_Folgequest = Inst4Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde
Inst4Quest5_HORDE = "5. 다크스톤 서판" -- The Darkstone Tablet
Inst4Quest5_HORDE_Aim = "카르가스에 있는 어둠마법사 비비안 라그레이브에게 다크스톤 서판을 가져가야 합니다."
Inst4Quest5_HORDE_Location = "비비안 라그레이브 (황야의 땅 - 카르가스; "..YELLOW.."3.0, 47.6"..WHITE..")"
Inst4Quest5_HORDE_Note = "선행 퀘스트는 연금술사 진게에게 받습니다. 언더시티 - 연금술 실험실 ("..YELLOW.."50.0, 68.6"..WHITE..").\n\n다크 스톤 서판은 "..YELLOW.."[3]"..WHITE.." 에서 찾을 수 있습니다."
Inst4Quest5_HORDE_Prequest = "비비안 라그레이브와 다크스톤 서판"
Inst4Quest5_HORDE_Folgequest = "없음"
--
Inst4Quest5name1_HORDE = "날쌘발 장화"
Inst4Quest5name2_HORDE = "명멸의 손목보호대"

--Quest 6 Horde
Inst4Quest6_HORDE = "6. 호드를 위하여!" -- For The Horde!
Inst4Quest6_HORDE_Aim = "검은바위 첨탑으로 가서 대족장 렌드 블랙핸드를 처치하십시오. 그 증거로 그의 머리카락을 가지고 오그리마로 돌아와야 합니다."
Inst4Quest6_HORDE_Location = "스랄 (오그리마; "..YELLOW.."32, 37.8"..WHITE..")"
Inst4Quest6_HORDE_Note = "오닉시아 입장 퀘스트 라인.  대족장 렌드 블랙핸드는 "..YELLOW.."[6]"..WHITE.." 에서 찾을 수 있습니다."
Inst4Quest6_HORDE_Prequest = "장군의 명령 -> 아이트리그의 지혜"
Inst4Quest6_HORDE_Folgequest = "바람이 전해 온 소식"
--
Inst4Quest6name1_HORDE = "폭정의 징표"
Inst4Quest6name2_HORDE = "괴수의 눈"
Inst4Quest6name3_HORDE = "불랙핸드의 팔찌"

--Quest 7 Horde
Inst4Quest7_HORDE = "7. 눈동자의 환영" -- Oculus Illusions
Inst4Quest7_HORDE_Aim = "먼지진흙 습지대에 있는 용의 둥지로 가서 엠버스트라이프의 굴을 찾아야 합니다. 안으로 들어가서 용족 파멸의 아뮬렛을 착용하고 엠버스트라이프와 대화해야 합니다."
Inst4Quest7_HORDE_Location = "노파 미란다 (서부 역병지대 - 슬픔의 언덕; "..YELLOW.."50.8, 77.8"..WHITE..")"
Inst4Quest7_HORDE_Note = "오닉시아 입장 퀘스트 라인.  검은 용혈족의 눈동자는 용족 몬스터에서 드랍합니다."
Inst4Quest7_HORDE_Prequest = "바람이 전해 온 소식 -> 속임수의 대가"
Inst4Quest7_HORDE_Folgequest = "엠버스트라이프"
-- No Rewards for this quest

--Quest 8 Horde
Inst4Quest8_HORDE = "8. 검은용 용사의 피" -- Blood of the Black Dragon Champion
Inst4Quest8_HORDE_Aim = "검은바위 첨탑으로 가서 드라키사스를 처치해야 합니다. 그의 피를 렉사르에게 가져가십시오."
Inst4Quest8_HORDE_Location = "렉사르 (돌발톱 산맥에서 페랄라스까지 이동함)"
Inst4Quest8_HORDE_Note = "오닉시아 입장 퀘스트 라인의 마지막 부분.  렉사르는 톨발톱 산맥 사이에 경계에서 리젠되어 잊혀진 땅을 지나 페랄라스로 이동 합니다.  그를 찾는 가장 좋은 방법은 페랄라스에서 시작합니다. "..YELLOW.."48.2, 24.8"..WHITE.." 그리고 그를 찾기 위해 북쪽으로 이동합니다.   사령관 드라키사스는 "..YELLOW.."[9]"..WHITE.." 에서 찾을 수 있습니다."
Inst4Quest8_HORDE_Prequest = "해골 시험 - 악트로즈 -> 진급"
Inst4Quest8_HORDE_Folgequest = "없음"
--
Inst4Quest8name1_HORDE = "비룡불꽃 아뮬렛"

--Quest 9 Horde  (same as Quest 7 Alliance)
Inst4Quest9_HORDE = "9. 블랙핸드의 명령서" -- Blackhand's Command
Inst4Quest9_HORDE_Aim = Inst4Quest7_Aim
Inst4Quest9_HORDE_Location = Inst4Quest7_Location
Inst4Quest9_HORDE_Note = Inst4Quest7_Note
Inst4Quest9_HORDE_Prequest = Inst4Quest7_Prequest
Inst4Quest9_HORDE_Folgequest = Inst4Quest7_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 8 Alliance)
Inst4Quest10_HORDE = "10. 마지막 준비" -- Final Preparations
Inst4Quest10_HORDE_Aim = Inst4Quest8_Aim
Inst4Quest10_HORDE_Location = Inst4Quest8_Location
Inst4Quest10_HORDE_Note = Inst4Quest8_Note
Inst4Quest10_HORDE_Prequest = Inst4Quest8_Prequest
Inst4Quest10_HORDE_Folgequest = Inst4Quest8_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 9 Alliance)
Inst4Quest11_HORDE = "11. 군주 발타라크여, 내 탓이오." -- Mea Culpa, Lord Valthalak
Inst4Quest11_HORDE_Aim = Inst4Quest9_Aim
Inst4Quest11_HORDE_Location = Inst4Quest9_Location
Inst4Quest11_HORDE_Note = Inst4Quest9_Note
Inst4Quest11_HORDE_Prequest = Inst4Quest9_Prequest
Inst4Quest11_HORDE_Folgequest = Inst4Quest9_Folgequest
--
Inst4Quest11name1_HORDE = Inst4Quest9name1
Inst4Quest11name2_HORDE = Inst4Quest9name2

--Quest 12 Horde  (same as Quest 10 Alliance)
Inst4Quest12_HORDE = "12. 악마의 룬" -- The Demon Forge
Inst4Quest12_HORDE_Aim = Inst4Quest10_Aim
Inst4Quest12_HORDE_Location = Inst4Quest10_Location
Inst4Quest12_HORDE_Note = Inst4Quest10_Note
Inst4Quest12_HORDE_Prequest = Inst4Quest10_Prequest
Inst4Quest12_HORDE_Folgequest = Inst4Quest10_Folgequest
--
Inst4Quest12name1_HORDE = Inst4Quest10name1
Inst4Quest12name2_HORDE = Inst4Quest10name2
Inst4Quest12name3_HORDE = Inst4Quest10name3

--Quest 13 Horde  (same as Quest 11 Alliance)
Inst4Quest13_HORDE = "13. 알 수집" -- Egg Collection
Inst4Quest13_HORDE_Aim = Inst4Quest11_Aim
Inst4Quest13_HORDE_Location = Inst4Quest11_Location
Inst4Quest13_HORDE_Note = Inst4Quest11_Note
Inst4Quest13_HORDE_Prequest = Inst4Quest11_Prequest
Inst4Quest13_HORDE_Folgequest = Inst4Quest11_Folgequest
-- No Rewards for this quest



--------------- INST5 - Deadmines 죽음의 폐광 ---------------

Inst5Caption = "죽음의 폐광"
Inst5QAA = "7 퀘스트" 
Inst5QAH = "퀘스트 없음" 

--Quest 1 Alliance
Inst5Quest1 = "1. 붉은 비단 복면" -- Red Silk Bandanas
Inst5Quest1_Aim = "감시의 언덕 탑의 정찰병 리엘이 붉은 비단 복면 10개를 가져다 달라고 부탁했습니다."
Inst5Quest1_Location = "정찰병 리엘 (서부 몰락지대 - 감시의 언덕; "..YELLOW.."56.6, 47.4"..WHITE..")"
Inst5Quest1_Note = "죽음의 폐광 던전 마을 광부에게 붉은 비단 복면을 얻을 수 있다.  에드윈 밴클리프를 처치하는 부분까지 데피아즈단 퀘스트를 완료한 후 퀘스트를 받을 수 있다."
Inst5Quest1_Prequest = "데피아즈단"
Inst5Quest1_Folgequest = "없음"
--
Inst5Quest1name1 = "튼튼한 쇼트소드"
Inst5Quest1name2 = "수공예 단검"
Inst5Quest1name3 = "예리한 도끼"

--Quest 2 Alliance
Inst5Quest2 = "2. 기억을 더듬어..." -- Collecting Memories
Inst5Quest2_Aim = "스톰윈드에 있는 빌더 시슬네틀에게 광부 조합의 명함 4장을 가져가야 합니다."
Inst5Quest2_Location = "빌더 시슬네틀 (스톰윈드 - 드워프 지구; "..YELLOW.."65.2, 21.2"..WHITE..")"
Inst5Quest2_Note = "카드는 던전 근처 지역의 언데드 몬스터가 드랍합니다. "..YELLOW.."[3]"..WHITE.." 입구 지도에 있습니다."
Inst5Quest2_Prequest = "없음"
Inst5Quest2_Folgequest = "없음"
--
Inst5Quest2name1 = "채굴꾼 장화"
Inst5Quest2name2 = "잿빛 채광용 장갑"

--Quest 3 Alliance
Inst5Quest3 = "3. 형제여..." -- Oh Brother. . .
Inst5Quest3_Aim = "스톰윈드에 있는 빌더 시슬네틀에게 시슬네틀의 배지를 가져가야 합니다."
Inst5Quest3_Location = "빌더 시슬네틀 (스톰윈드 - 드워프 지구; "..YELLOW.."65.2, 21.2"..WHITE..")"
Inst5Quest3_Note = "현장 감독 시스네틀은 던전 밖 언데드 지역에서 발견됩니다. "..YELLOW.."[3]"..WHITE.." 입구 지도에 있습니다."
Inst5Quest3_Prequest = "없음"
Inst5Quest3_Folgequest = "없음"
--
Inst5Quest3name1 = "광부의 곡괭이"

--Quest 4 Alliance
Inst5Quest4 = "4. 지하 공격" -- Underground Assault
Inst5Quest4_Aim = "죽음의 폐광에서 노암 톱니구동장치를 찾아 스톰윈드에 있는 쇼니에게 가져가야 합니다."
Inst5Quest4_Location = "소리없는 쇼니 (스톰윈드 - 드워프 지구; "..YELLOW.."62.6, 34.1"..WHITE..")"
Inst5Quest4_Note = "선택적인 선행 퀘스트는 노아른에게 받을 수 있습니다. (아이언포지 - 땜장이 마을; "..YELLOW.."69.4, 50.6"..WHITE..").\n스니드의 벌목기에서 노암 톱니구동장치를 드랍합니다. "..YELLOW.."[3]"..WHITE.."."
Inst5Quest4_Prequest = "쇼니와의 대화"
Inst5Quest4_Folgequest = "없음"
--
Inst5Quest4name1 = "북극의 건틀릿"
Inst5Quest4name2 = "칠흑의 마법봉"

--Quest 5 Alliance
Inst5Quest5 = "5. 데피아즈단" -- The Defias Brotherhood
Inst5Quest5_Aim = "에드윈 밴클리프를 처치하고 그 증거로 그의 가면을 그라이언 스타우트맨틀에게 가져가야 합니다."
Inst5Quest5_Location = "그라이언 스타우트맨틀 (서부몰락 지대 - 감시의 언덕; "..YELLOW.."56.2, 47.6"..WHITE..")"
Inst5Quest5_Note = "그라이언 스타우트맨틀에게 이 퀘스트 라인을 시작 합니다.\n에드윈 밴클리프는 죽음의 폐광 마지막 보스입니다. 그는 배 꼭대기에서 그를 찾을 수 있다. "..YELLOW.."[6]"..WHITE.."."
Inst5Quest5_Prequest = "데피아즈단"
Inst5Quest5_Folgequest = "없음"
--
Inst5Quest5name1 = "서부 몰락지대 다리보호구"
Inst5Quest5name2 = "서부 몰락지대 튜닉"
Inst5Quest5name3 = "서부 몰락지대 지팡이"

--Quest 6 Alliance
Inst5Quest6 = "6. 정의의 시험 (2)" -- The Test of Righteousness
Inst5Quest6_Aim = "조던의 쪽지를 참고해 흰돌참나무 재목, 조던의 제련된 광석 상자, 조던의 대장장이 망치, 그리고 코르석을 찾아 아이언포지에 있는 조던 스틸웰에게 가져가야 합니다."
Inst5Quest6_Location = "조던 스틸웰 (던 모로 - 아이언포지 입구; "..YELLOW.."52,36"..WHITE..")"
Inst5Quest6_Note = "성기사 퀘스트.  고블린 목공에게 흰돌참나무 재목을 얻습니다.  "..YELLOW.."[3]"..WHITE..".\n\n나머지 아이템은 "..YELLOW.."[그림자송곳니 성채]"..WHITE..", 모단 호수, 어둠의 해안과 챗빛 골짜기.  일부는 사이드 퀘스트를 수행해야합니다.  자세한 내용은 Wowhead에서 찾아 보는 것이 좋습니다."
Inst5Quest6_Prequest = "용맹의 고서 -> 정의의 시험 (1)"
Inst5Quest6_Folgequest = "정의의 시험 (3)"
--
Inst5Quest6name1 = "베리간의 망치"

--Quest 7 Alliance
Inst5Quest7 = "7. 부치지 않은 편지" -- The Unsent Letter
Inst5Quest7_Aim = "스톰윈드에 있는 도시 건축가 바로스 알렉스턴에게 편지를 전달해야 합니다."
Inst5Quest7_Location = "부치지 않은 편지 (에드윈 밴클리프 드랍; "..YELLOW.."[6]"..WHITE..")"
Inst5Quest7_Note = "바로스 알렉스턴은 스톰윈드에 있으면, 빛의 대성당 옆에 있습니다.  "..YELLOW.."49.0, 30.2"..WHITE.."."
Inst5Quest7_Prequest = "없음"
Inst5Quest7_Folgequest = "바질 스레드"
-- No Rewards for this quest



--------------- INST6 - Gnomeregan 놈리건 ---------------

Inst6Caption = "놈리건"
Inst6QAA = "11 퀘스트"
Inst6QAH = "6 퀘스트"

--Quest 1 Alliance
Inst6Quest1 = "1. 고장난 첨단로봇 수리" -- Save Techbot's Brain!
Inst6Quest1_Aim = "아이언포지에 있는 수석땜장이 오버스파크에게 첨단로봇의 기억회로를 가져가야 합니다."
Inst6Quest1_Location = "수석땜장이 오버스파크 (아이언포지 - 땜장이 마을; "..YELLOW.."69.8, 50.4"..WHITE..")"
Inst6Quest1_Note = "수사 세르노에게 선택적인 선행 퀘스트를 받을 수 있습니다. (스톰윈드 - 대성당 광장; "..YELLOW.."40.6, 30.8"..WHITE..").\n첨단로봇은 던전의 입구 근처 밖에 있습니다. "..YELLOW.."[4] 입구지도"..WHITE.."."
Inst6Quest1_Prequest = "수석땜장이 오버스파크"
Inst6Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst6Quest2 = "2. 폐기물 수집" -- Gnogaine
Inst6Quest2_Aim = "빈 가연채집병에 오염된 침략꾼이나 오염된 약탈자에게서 얻은 방사성 폐기물을 담아야 합니다. 채집병이 가득 차면 카라노스에 있는 오지 토글볼트에게 가지고 가야 합니다."
Inst6Quest2_Location = "오지 토글볼트 (던 모로 - 카라노스; "..YELLOW.."45.8, 49.2"..WHITE..")"
Inst6Quest2_Note = "선행 퀘스트는 노아른에서 받습니다. (아이언포지 - 땜장이 마을; "..YELLOW.."69.4, 50.6"..WHITE..").\n페기물을 채집하려면 "..RED.."살아있는"..WHITE.." 오염된 침략꾼이나 오염된 약탈자에게 빈 가연채집병을 사용해야 합니다.  그들은 던전의 시작 부분 근처에서 발견된다"
Inst6Quest2_Prequest = "그날 이후"
Inst6Quest2_Folgequest = "유일한 치료법"
-- No Rewards for this quest

--Quest 3 Alliance
Inst6Quest3 = "3. 유일한 치료법" -- The Only Cure is More Green Glow
Inst6Quest3_Aim = "놈리건으로 가서 고농축 방사성 폐기물을 가져와야 합니다. 이 폐기물은 불안정하여 성분이 금방 변할 수 있으니 주의하십시오.임무를 완수한 후 빈 대형 가연채집병을 오지에게 돌려줘야 합니다."
Inst6Quest3_Location = "오지 토글볼트 (던 모로 - 카라노스; "..YELLOW.."45.8, 49.2"..WHITE..")"
Inst6Quest3_Note = "페기물을 채집하려면 "..RED.."살아있는"..WHITE.." 오염된 진흙괴물, 오염된 폐기물에게 빈 대형 가연채집병을 사용해야 합니다.  그들은 방사성 폐기물 보스 근처에서 발견됩니다. "..YELLOW.."[4]"..WHITE.."."
Inst6Quest3_Prequest = "폐기물 수집"
Inst6Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst6Quest4 = "4. 회전천공식 발굴기" -- Gyrodrillmatic Excavationators
Inst6Quest4_Aim = "스톰윈드에 있는 쇼니에게 기계장치 부속품 24개를 가져가야 합니다."
Inst6Quest4_Location = "소리없는 쇼니 (스톰윈드 - 드워프 지구; "..YELLOW.."55.4, 12.6"..WHITE..")"
Inst6Quest4_Note = "모든 로봇은 기계장치 부속품을 드랍할 수 있습니다."
Inst6Quest4_Prequest = "없음"
Inst6Quest4_Folgequest = "없음"
--
Inst6Quest4name1 = "쇼니의 작업용 연장"
Inst6Quest4name2 = "망설임의 장갑"

--Quest 5 Alliance
Inst6Quest5 = "5. 필수 인공장치" -- Essential Artificials
Inst6Quest5_Aim = "아이언포지에 있는 클락몰트 스패너스판에게 필수 인공장치 12개를 가져가야 합니다."
Inst6Quest5_Location = "클락몰트 스패너스판 (아이언포지 - 땜장이마을; "..YELLOW.."68.0, 46.8"..WHITE..")"
Inst6Quest5_Note = "선택적인 선행 퀘스트는 메시엘에게 받을 수 있습니다. (다르나서스 - 전사의 정원; "..YELLOW.."59.2, 45.2"..WHITE..").\n필수 인공장치는 던전 주변에 흩어져 있는 기계에서 나옵니다."
Inst6Quest5_Prequest = "클락몰트에게 꼭 필요한 것"
Inst6Quest5_Folgequest = "없음"
-- No Rewards for this quest

--Quest 6 Alliance
Inst6Quest6 = "6. 자료 회수" -- Data Rescue
Inst6Quest6_Aim = "아이언포지에 있는 수석수리공 캐스트파이프에게 오색 천공 카드를 가져가야 합니다."
Inst6Quest6_Location = "수석수리공 캐스트파이프 (아이언포지 - 땜장이마을; "..YELLOW.."70.2, 48.4"..WHITE..")"
Inst6Quest6_Note = "선택적인 선행 퀘스트는 각심 러스트피즐에게 받을 수 있습니다. (돌발톱 산맥; "..YELLOW.."59.6, 67.0"..WHITE..").\n흰색 카드는 무작위 드랍 입니다. 던전에 들어가기 전에 뒷문 옆에 첫 번째 터미널이 있습니다. "..YELLOW.."[C] 입구지도"..WHITE..". 행렬천공기록기3005-B는  "..YELLOW.."[3]"..WHITE..", 행렬천공기록기3005-C는 "..YELLOW.."[5]"..WHITE.." 그리고 행렬천공기록기3005-D는 "..YELLOW.."[6]"..WHITE.."."
Inst6Quest6_Prequest = "캐스트파이프의 임무"
Inst6Quest6_Folgequest = "없음"
--
Inst6Quest6name1 = "수리공의 단망토"
Inst6Quest6name2 = "수리공의 파이프망치"

--Quest 7 Alliance
Inst6Quest7 = "7. 곤경에 빠진 케르노비" -- A Fine Mess
Inst6Quest7_Aim = "태엽장치 통로 입구까지 케르노비를 호위한 후 무법항에 있는 스쿠티에게 가서 보고해야 합니다."
Inst6Quest7_Location = "케르노비 (놈리건; "..YELLOW.."[3]"..WHITE..")"
Inst6Quest7_Note = "호위 퀘스트! 가시덤블 골짜기 - 무법항에서 스쿠티를 찾으십시오. ("..YELLOW.."27.6, 77.4"..WHITE..")."
Inst6Quest7_Prequest = "없음"
Inst6Quest7_Folgequest = "없음"
--
Inst6Quest7name1 = "용접 팔보호구"
Inst6Quest7name2 = "요정날개 어깨보호대"

--Quest 8 Alliance
Inst6Quest8 = "8. 대배반" -- The Grand Betrayal
Inst6Quest8_Aim = "놈리건으로 가서 기계박사 텔마플러그를 처치해야 합니다. 임무가 끝나면 땜장이왕 멕카토크에게 돌아와야 합니다."
Inst6Quest8_Location = "땜장이왕 멕카토크 (아이언포지 - 땜장이 마을; "..YELLOW.."69.0, 49.0"..WHITE..")"
Inst6Quest8_Note = "멕기니어 텔마플러그를 "..YELLOW.."[8]"..WHITE.." 찾을 수 있습니다. 그는 놈리건의 마지막 보스입니다.\n전투 중에 측면의 버튼을 눌러 기둥을 무력화 시켜야 한다."
Inst6Quest8_Prequest = "없음"
Inst6Quest8_Folgequest = "없음"
--
Inst6Quest8name1 = "선민의 로브"
Inst6Quest8name2 = "출장용 작업복"
Inst6Quest8name3 = "이중 강화 다리보호구"

--Quest 9 Alliance
Inst6Quest9 = "9. 꼬질꼬질한 반지" -- Grime-Encrusted Ring
Inst6Quest9_Aim = "꼬질꼬질한 반지에서 찌꺼기를 제거할 방법을 찾아야 합니다."
Inst6Quest9_Location = "꼬질꼬질한 반지 (놈리건 검은무쇠단 드워프에게 무작위 드랍)"
Inst6Quest9_Note = "정화 지역에서 빤질빤질세척기 5200에서 반지를 청소할 수 있습니다. "..YELLOW.."[2]"..WHITE.."."
Inst6Quest9_Prequest = "없음"
Inst6Quest9_Folgequest = "반지의 귀환"
-- No Rewards for this quest

--Quest 10 Alliance
Inst6Quest10 = "10. 반지의 귀환" -- Return of the Ring
Inst6Quest10_Aim = "반지를 그냥 가지거나, 반지 안쪽 부분에 새겨진 인장 자국의 주인을 찾아야 합니다."
Inst6Quest10_Location = "반짝이는 금반지 (꼬질꼬질한 반지 퀘스트에서 획득)"
Inst6Quest10_Note = "탈바쉬 델 키젤에게 돌아간다. (아이언포지 - 마법 지구; "..YELLOW.."36.0, 4.0"..WHITE.."). 반지를 향상시키기 위한 다음 작업은 선택 사항입니다."
Inst6Quest10_Prequest = "꼬질꼬질한 반지"
Inst6Quest10_Folgequest = "노그의 반지 수리"
--
Inst6Quest10name1 = "반짝이는 금반지"

--Quest 11 Alliance
Inst6Quest11 = "11. 삐까뻔쩍세척기 5200!" -- The Sparklematic 5200!
Inst6Quest11_Aim = "삐까뻔쩍세척기 5200에 꼬질꼬질한 물건을 넣으십시오. 3실버를 투입하면 작동할 것입니다."
Inst6Quest11_Location = "삐까뻔쩍세척기 5200 (놈리건 - 정화 지역; "..YELLOW.."[2]"..WHITE..")"
Inst6Quest11_Note = "당신이 가진 모든 꼬질꼬질한 물건 항목에 대해 퀘스트를 반복 할 수 있습니다."
Inst6Quest11_Prequest = "없음"
Inst6Quest11_Folgequest = "없음"
--
Inst6Quest11name1 = "삐까뻔쩍세척기 포장 상자"


--Quest 1 Horde
Inst6Quest1_HORDE = "1. 놈리거어어어언!" -- Gnomer-gooooone!
Inst6Quest1_HORDE_Aim = "스쿠티가 고블린 응답장치를 조절하는 동안 기다려야 합니다."
Inst6Quest1_HORDE_Location = "스쿠티 (가시덤블 골짜기 - 무법항; "..YELLOW.."27.6, 77.4"..WHITE..")"
Inst6Quest1_HORDE_Note = "선행 퀘스트는 소빅에게 받을 수 있습니다. (오그리마 - 명예의 골짜기; "..YELLOW.."75.6, 25.2"..WHITE..").\n이 퀘스트를 완료하면 무법항의 응답장치를 사용하여 놈리건으로 순간 이동할 수 있습니다."
Inst6Quest1_HORDE_Prequest = "선임기술자 스쿠티"
Inst6Quest1_HORDE_Folgequest = "없음"
--
Inst6Quest1name1_HORDE = "고블린 응답장치"

--Quest 2 Horde  (same as Quest 7 Alliance)
Inst6Quest2_HORDE = "2. 곤경에 빠진 케르노비" -- A Fine Mess
Inst6Quest2_HORDE_Aim = Inst6Quest7_Aim
Inst6Quest2_HORDE_Location = Inst6Quest7_Location
Inst6Quest2_HORDE_Note = Inst6Quest7_Note
Inst6Quest2_HORDE_Prequest = Inst6Quest7_Prequest
Inst6Quest2_HORDE_Folgequest = Inst6Quest7_Folgequest
--
Inst6Quest2name1_HORDE = Inst6Quest7name1
Inst6Quest2name2_HORDE = Inst6Quest7name2

--Quest 3 Horde
Inst6Quest3_HORDE = "3. 기술 전쟁" -- Rig Wars
Inst6Quest3_HORDE_Aim = "놈리건에서 장치 설계도와 텔마플러그의 금고 암호를 찾아서 오그리마에 있는 노그에게 가져다주어야 합니다."
Inst6Quest3_HORDE_Location = "노그 (오그리마 - 명예의 골짜기; "..YELLOW.."75.8, 25.2"..WHITE..")"
Inst6Quest3_HORDE_Note = "멕기니어 텔마플러그를 "..YELLOW.."[8]"..WHITE.." 찾을 수 있습니다. 그는 놈리건의 마지막 보스입니다.\n전투 중에 측면의 버튼을 눌러 기둥을 무력화 시켜야 한다."
Inst6Quest3_HORDE_Prequest = "없음"
Inst6Quest3_HORDE_Folgequest = "없음"
--
Inst6Quest3name1_HORDE = "선민의 로브"
Inst6Quest3name2_HORDE = "출장용 작업복"
Inst6Quest3name3_HORDE = "이중 강화 다리보호구"

--Quest 4 Horde  (same as Quest 9 Alliance)
Inst6Quest4_HORDE = "4. 꼬질꼬질한 반지" -- Grime-Encrusted Ring
Inst6Quest4_HORDE_Aim = Inst6Quest9_Aim
Inst6Quest4_HORDE_Location = Inst6Quest9_Location
Inst6Quest4_HORDE_Note = Inst6Quest9_Note
Inst6Quest4_HORDE_Prequest = Inst6Quest9_Prequest
Inst6Quest4_HORDE_Folgequest = Inst6Quest9_Folgequest
-- No Rewards for this quest

--Quest 5 Horde
Inst6Quest5_HORDE = "5. 반지의 귀환!" -- Return of the Ring
Inst6Quest5_HORDE_Aim = "반지를 그냥 가지거나, 반지 안쪽 부분에 새겨진 인장 자국의 주인을 찾아야 합니다."
Inst6Quest5_HORDE_Location = "반짝이는 금반지 (꼬질꼬질한 반지 퀘스트에서 획득)"
Inst6Quest5_HORDE_Note = "노그에게 돌아간다. (오그리마 - 명예의 골짜기; "..YELLOW.."75.8, 25.2"..WHITE.."). 반지를 향상시키기 위한 다음 작업은 선택 사항입니다."
Inst6Quest5_HORDE_Prequest = "꼬질꼬질한 반지"
Inst6Quest5_HORDE_Folgequest = "노그의 반지 수리"
--
Inst6Quest5name1_HORDE = "반짝이는 금반지"

--Quest 6 Horde
Inst6Quest6_HORDE = "6. 삐까뻔쩍세척기 5200!" -- The Sparklematic 5200!
Inst6Quest6_HORDE_Aim = "삐까뻔쩍세척기 5200에 꼬질꼬질한 물건을 넣으십시오. 3실버를 투입하면 작동할 것입니다."
Inst6Quest6_HORDE_Location = "삐까뻔쩍세척기 (놈리건 - 정화 지역; "..YELLOW.."[2]"..WHITE..")"
Inst6Quest6_HORDE_Note = "당신이 가진 모든 꼬질꼬질한 물건 항목에 대해 퀘스트를 반복 할 수 있습니다."
Inst6Quest6_HORDE_Prequest = "없음"
Inst6Quest6_HORDE_Folgequest = "없음"
--
Inst6Quest6name1_HORDE = "삐까뻔쩍세척기 포장 상자"



--------------- INST7 - Scarlet Monastery: Library 붉은십자군 수도원:도서관 ---------------

Inst7Caption = "붉은십자군 수도원: 도서관"
Inst7QAA = "3 퀘스트"
Inst7QAH = "5 퀘스트"

--Quest 1 Alliance
Inst7Quest1 = "1. 티탄 신화" -- Mythology of the Titans
Inst7Quest1_Aim = "수도원에서 티탄 신화라는 책을 찾아 아이언포지에 있는 사서 메이 페일더스트에게 가져가야 합니다."
Inst7Quest1_Location = "사서 메이 페일더스트 (아이언포지 - 탐험가의 전당; "..YELLOW.."74.6, 12.6"..WHITE..")"
Inst7Quest1_Note = "이 책은 신비술사 도안으로 이어지는 복도 중 하나의 왼쪽 바닥에 있습니다. ("..YELLOW.."[2]"..WHITE..").  플레이어가 그것을 집고 나면 사라집니다.  1~2분 후에 다시 젠 됩니다."
Inst7Quest1_Prequest = "없음"
Inst7Quest1_Folgequest = "없음"
--
Inst7Quest1name1 = "탐험가 연맹 증표"

--Quest 2 Alliance
Inst7Quest2 = "2. 마력의 의식" -- Rituals of Power
Inst7Quest2_Aim = "먼지진흙 습지대에 있는 타베사에게 마력의 의식을 가져가야 합니다."
Inst7Quest2_Location = "학자 틸스 (버섯구름 봉우리 - 소금 평원; "..YELLOW.."78.2, 75.8"..WHITE..")"
Inst7Quest2_Note = "마법사 퀘스트.  선행 퀘스트는 대도시 상급 마법사에게 제공됩니다.  신비술사 도안으로 이어지는 마지막 복도에서 책을 찾을 수 있습니다. ("..YELLOW.."[2]"..WHITE..").  그것은 선반에 꽂혀 있습니다.\n\n퀘스트는 타베사에게 이어 집니다. (먼지진흙 습지대; "..YELLOW.."46.0, 57.0"..WHITE..").  \n다음은 그것에 대한 보상입니다."
Inst7Quest2_Prequest = "습지대로의 여행 -> 주문 알아오기"
Inst7Quest2_Folgequest = "마법사의 마법봉"
--
Inst7Quest2name1 = "맹위의 얼음마법봉"
Inst7Quest2name2 = "황천의 마법봉"
Inst7Quest2name3 = "맹위의 화염마법봉"

--Quest 3 Alliance
Inst7Quest3 = "3. 빛의 이름으로!" -- In the Name of the Light
Inst7Quest3_Aim = "종교재판관 화이트메인, 붉은십자군 사령관 모그레인, 붉은십자군 용사 헤로드와 사냥개조련사 록시를 처치한 후 사우스쇼어에 있는 경건한 신자 랄레이에게 돌아가 보고하십시오."
Inst7Quest3_Location = "경건한 신자 랄레이 (힐스브레드 구릉지 - 사우스쇼어; "..YELLOW.."51.4, 58.4"..WHITE..")"
Inst7Quest3_Note = "이 퀘스트 라인은 스톰윈드 - 빛의 대성당 수사 크롤리에서 시작됩니다. ("..YELLOW.."42.4, 24.4"..WHITE..").\n종교재판관 화이트메인과 붉은십자군 사령관 모그레인은 "..YELLOW.."붉은십자군 수도원: 대성당 [2]"..WHITE..", \n헤로드는 "..YELLOW.."붉은십자군 수도원: 무기고 [1]"..WHITE.." 그리고 사냥개조련사 록시는 "..YELLOW.."붉은십자군 수도원: 도서관 [1]"..WHITE.." 에서 찾을 수 있습니다."
Inst7Quest3_Prequest = "수사 안톤 -> 붉은십자군의 길"
Inst7Quest3_Folgequest = "없음"
--
Inst7Quest3name1 = "평온의 검"
Inst7Quest3name2 = "각골의 도끼"
Inst7Quest3name3 = "검은 위협"
Inst7Quest3name4 = "로리카의 보주"


--Quest 1 Horde
Inst7Quest1_HORDE = "1. 열정의 증거" -- Hearts of Zeal
Inst7Quest1_HORDE_Aim = "언더시티에 있는 수석 연금술사 파라넬에게 열정의 증거 20개를 가져가야 합니다."
Inst7Quest1_HORDE_Location = "수석 연금술사 파라넬 (언더시티 - 연금술 실험실; "..YELLOW.."48.6, 69.4"..WHITE..")"
Inst7Quest1_HORDE_Note = "붉은십자군 수도원 안에 있는 모든 몬스터는 열정의 증거를 드랍 할 수 있습니다.  여기는 포털 근처 던전 외부의 몬스터들도 포함됩니다."
Inst7Quest1_HORDE_Prequest = "조분석을 나에게! ("..YELLOW.."[가시덩굴 우리]"..WHITE..")"
Inst7Quest1_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Horde
Inst7Quest2_HORDE = "2. 지혜의 시험!!" -- Test of Lore
Inst7Quest2_HORDE_Aim = "언데드 위협의 기원을 찾아 언더시티에 있는 파쿠알 핀탈라스에게 가져가야 합니다."
Inst7Quest2_HORDE_Location = "파쿠알 핀탈라스 (언더시티 - 연금술 실험실; "..YELLOW.."57.8, 65.0"..WHITE..")"
Inst7Quest2_HORDE_Note = "퀘스트 라인은 도른 플레인스토커에서 시작됩니다. (버섯구름 봉우리; "..YELLOW.."53.8, 41.6"..WHITE..").  그 책은 '보물 갤러리'라고 불리는 도서관의 한 부분에 있는 탁자 위에 있다.  그것은 던전의 중간쯤에 있습니다.\n\n다음은 그것에 대한 보상입니다."
Inst7Quest2_HORDE_Prequest = "믿음의 시험 -> 지혜의 시험"
Inst7Quest2_HORDE_Folgequest = "지혜의 시험"
--
Inst7Quest2name1_HORDE = "폭풍 해머"
Inst7Quest2name2_HORDE = "춤추는 불꽃"

--Quest 3 Horde
Inst7Quest3_HORDE = "3. 타락의 개요" -- Compendium of the Fallen
Inst7Quest3_HORDE_Aim = "티리스팔 숲의 붉은십자군 수도원에서 타락의 개요를 찾아 썬더 블러프에 있는 현자 트루스시커에게 가져가야 합니다."
Inst7Quest3_HORDE_Location = "현자 트루스시커 (썬더 블러프; "..YELLOW.."34.6, 47.2"..WHITE..")"
Inst7Quest3_HORDE_Note = "이 책은 '아테니움' 이라는 도서관 구역의 선반에 있습니다.   언데드 플레이어는 이 퀘스트를 할 수 없습니다."
Inst7Quest3_HORDE_Prequest = "없음"
Inst7Quest3_HORDE_Folgequest = "없음"
--
Inst7Quest3name1_HORDE = "암흑의 수호방패"
Inst7Quest3name2_HORDE = "마력석 버클러"
Inst7Quest3name3_HORDE = "최후의 보주"

--Quest 4 Horde  (same as Quest 2 Alliance)
Inst7Quest4_HORDE = "4. 아나스타샤에게 보고" -- Rituals of Power
Inst7Quest4_HORDE_Aim = Inst7Quest2_Aim
Inst7Quest4_HORDE_Location = Inst7Quest2_Location
Inst7Quest4_HORDE_Note = Inst7Quest2_Note
Inst7Quest4_HORDE_Prequest = Inst7Quest2_Prequest
Inst7Quest4_HORDE_Folgequest = Inst7Quest2_Folgequest
--
Inst7Quest4name1_HORDE = Inst7Quest2name1
Inst7Quest4name2_HORDE = Inst7Quest2name2
Inst7Quest4name3_HORDE = Inst7Quest2name3

--Quest 5 Horde
Inst7Quest5_HORDE = "5. 붉은십자군 수도원으로" -- Into The Scarlet Monastery
Inst7Quest5_HORDE_Aim = "종교재판관 화이트메인, 붉은십자군 사령관 모그레인, 붉은십자군 용사 헤로드와 사냥개조련사 록시를 처치한 후 언더시티에 있는 바리마트라스에게 돌아가 보고해야 합니다."
Inst7Quest5_HORDE_Location = "바리마트라스 (언더시티 - 왕실; "..YELLOW.."56.2, 92.6"..WHITE..")"
Inst7Quest5_HORDE_Note = "종교재판관 화이트메인과 붉은십자군 사령관 모그레인은 "..YELLOW.."붉은십자군 수도원: 대성당 [2]"..WHITE..", 헤로드는 "..YELLOW.."붉은십자군 수도원: 무기고 [1]"..WHITE.." 그리고 사냥개조련사 록시는 "..YELLOW.."붉은십자군 수도원: 도서관 [1]"..WHITE.."."
Inst7Quest5_HORDE_Prequest = "없음"
Inst7Quest5_HORDE_Folgequest = "없음"
--
Inst7Quest5name1_HORDE = "징조의 검"
Inst7Quest5name2_HORDE = "예언의 지팡이"
Inst7Quest5name3_HORDE = "용의 피 목걸이"



--------------- INST8 - Scarlet Monastery: Armory 붉은십자군 수도원: 무기고---------------

Inst8Caption = "붉은십자군: 무기고"
Inst8QAA = "1 퀘스트"
Inst8QAH = "2 퀘스트"

--Quest 1 Alliance  (same quest as SM Library Quest 3 Alliance)
Inst8Quest1 = "1. 빛의 이름으로!" -- In the Name of the Light
Inst8Quest1_Aim = Inst7Quest3_Aim
Inst8Quest1_Location = Inst7Quest3_Location
Inst8Quest1_Note = Inst7Quest3_Note
Inst8Quest1_Prequest = Inst7Quest3_Prequest
Inst8Quest1_Folgequest = Inst7Quest3_Folgequest
--
Inst8Quest1name1 = Inst7Quest3name1
Inst8Quest1name2 = Inst7Quest3name2
Inst8Quest1name3 = Inst7Quest3name3
Inst8Quest1name4 = Inst7Quest3name4


--Quest 1 Horde  (same quest as SM Library Quest 1 Horde)
Inst8Quest1_HORDE = Inst7Quest1_HORDE
Inst8Quest1_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst8Quest1_HORDE_Location = Inst7Quest1_HORDE_Location
Inst8Quest1_HORDE_Note = Inst7Quest1_HORDE_Note
Inst8Quest1_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst8Quest1_HORDE_Folgequest = Inst7Quest1_HORDE_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same quest as SM Library Quest 5 Horde)
Inst8Quest2_HORDE = "2. 붉은십자군 수도원으로" -- 2. Into The Scarlet Monastery
Inst8Quest2_HORDE_Aim = Inst7Quest5_HORDE_Aim
Inst8Quest2_HORDE_Location = Inst7Quest5_HORDE_Location
Inst8Quest2_HORDE_Note = Inst7Quest5_HORDE_Note
Inst8Quest2_HORDE_Prequest = Inst7Quest5_HORDE_Prequest
Inst8Quest2_HORDE_Folgequest = Inst7Quest5_HORDE_Folgequest
--
Inst8Quest2name1_HORDE = Inst7Quest5name1_HORDE
Inst8Quest2name2_HORDE = Inst7Quest5name2_HORDE
Inst8Quest2name3_HORDE = Inst7Quest5name3_HORDE



--------------- INST9 - Scarlet Monastery: Cathedral 붉은십자군 수도원: 예배당 ---------------

Inst9Caption = "붉은십자군 수도원: 예배당"
Inst9QAA = "1 퀘스트"
Inst9QAH = "2 퀘스트"

--Quest 1 Alliance  (same quest as SM Library Quest 3 Alliance)
Inst9Quest1 = "1. 빛의 이름으로!" -- In the Name of the Light
Inst9Quest1_Aim = Inst7Quest3_Aim
Inst9Quest1_Location = Inst7Quest3_Location
Inst9Quest1_Note = Inst7Quest3_Note
Inst9Quest1_Prequest = Inst7Quest3_Prequest
Inst9Quest1_Folgequest = Inst7Quest3_Folgequest
--
Inst9Quest1name1 = Inst7Quest3name1
Inst9Quest1name2 = Inst7Quest3name2
Inst9Quest1name3 = Inst7Quest3name3
Inst9Quest1name4 = Inst7Quest3name4


--Quest 1 Horde  (same quest as SM Library Quest 1 Horde)
Inst9Quest1_HORDE = Inst7Quest1_HORDE
Inst9Quest1_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst9Quest1_HORDE_Location = Inst7Quest1_HORDE_Location
Inst9Quest1_HORDE_Note = Inst7Quest1_HORDE_Note
Inst9Quest1_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst9Quest1_HORDE_Folgequest = Inst7Quest1_HORDE_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same quest as SM Library Quest 5 Horde)
Inst9Quest2_HORDE = "2. 붉은십자군 수도원으로" -- Into The Scarlet Monastery
Inst9Quest2_HORDE_Aim = Inst7Quest5_HORDE_Aim
Inst9Quest2_HORDE_Location = Inst7Quest5_HORDE_Location
Inst9Quest2_HORDE_Note = Inst7Quest5_HORDE_Note
Inst9Quest2_HORDE_Prequest = Inst7Quest5_HORDE_Prequest
Inst9Quest2_HORDE_Folgequest = Inst7Quest5_HORDE_Folgequest
--
Inst9Quest2name1_HORDE = Inst7Quest5name1_HORDE
Inst9Quest2name2_HORDE = Inst7Quest5name2_HORDE
Inst9Quest2name3_HORDE = Inst7Quest5name3_HORDE



--------------- INST10 - Scarlet Monastery: Graveyard 붉은십자군 수도원: 무덤---------------

Inst10Caption = "붉은십자군 수도원: 무덤"
Inst10QAA = "퀘스트 없음"
Inst10QAH = "2 퀘스트"


--Quest 1 Horde
Inst10Quest1_HORDE = "1. 보렐의 복수" -- Vorrel's Revenge
Inst10Quest1_HORDE_Aim = "타렌 밀농장에 있는 모니카 센구츠에게 보렐의 결혼반지를 가져가야 합니다."
Inst10Quest1_HORDE_Location = "보렐 센구츠 (붉은십자군 수도원 - 무덤; "..YELLOW.."[1]"..WHITE..")"
Inst10Quest1_HORDE_Note = "붉은십자군 수도원 무덤 시작 부분에 보렐 센구츠 찾을 수 있습니다.  이 퀘스트에 필요한 반지 드랍은 낸시 비샤스가 하는데 알터랙 산맥 근처 집에서 찾을 수 있습니다. (힐스브래드 구릉지 - 타렌 밀농장; "..YELLOW.."62.6, 19.0"..WHITE..")."
Inst10Quest1_HORDE_Prequest = "없음"
Inst10Quest1_HORDE_Folgequest = "없음"
--
Inst10Quest1name1_HORDE = "보렐의 장화"
Inst10Quest1name2_HORDE = "비애의 어깨보호대"
Inst10Quest1name3_HORDE = "한철 단망토"

--Quest 2 Horde  (same quest as SM Library Quest 1 Horde)
Inst10Quest2_HORDE = "2. 열정의 증거" -- Hearts of Zeal
Inst10Quest2_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst10Quest2_HORDE_Location = Inst7Quest1_HORDE_Location
Inst10Quest2_HORDE_Note = Inst7Quest1_HORDE_Note
Inst10Quest2_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst10Quest2_HORDE_Folgequest = Inst7Quest1_HORDE_Folgequest
-- No Rewards for this quest



--------------- INST11 - Scholomance 스칼로맨스 ---------------

Inst11Caption = "스칼로맨스"
Inst11QAA = "12 퀘스트"
Inst11QAH = "12 퀘스트"

--Quest 1 Alliance
Inst11Quest1 = "1. 역병 걸린 작은 새끼용" -- Plagued Hatchlings
Inst11Quest1_Aim = "역병 걸린 작은 새끼용 20마리를 처치한 후 희망의 빛 예배당에 있는 베티나 비글징크에게 돌아가야 합니다."
Inst11Quest1_Location = "베티나 비글징크 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.6"..WHITE..")"
Inst11Quest1_Note = "역병 걸린 작은 새끼용은 대형 납골당에서 들창어금니로 가는 길에 있습니다."
Inst11Quest1_Prequest = "없음"
Inst11Quest1_Folgequest = "생기 있는 용비늘"
-- No Rewards for this quest

--Quest 2 Alliance
Inst11Quest2 = "2. 생기 있는 용비늘" -- Healthy Dragon Scale
Inst11Quest2_Aim = "동부 역병지대의 희망의 빛 예배당에 있는 베티나 비글징크에게 생기 있는 용비늘을 가져가야 합니다."
Inst11Quest2_Location = "생기 있는 용비늘 (스칼로맨스에서 무작위 드랍)"
Inst11Quest2_Note = "역병 걸린 작은 새끼용은 생기 있는 용비늘을 드랍합니다.  베티나 비글징크은 동부 역병지대 - 희망의 빛 예배당 ("..YELLOW.."81.4, 59.6"..WHITE..") 에 있다."
Inst11Quest2_Prequest = "역병 걸린 작은 새끼용 "
Inst11Quest2_Folgequest = "없음"
-- No Rewards for this quest

--Quest 3 Alliance
Inst11Quest3 = "3. 도살자, 테올렌 크라스티노브" -- Doctor Theolen Krastinov, the Butcher
Inst11Quest3_Aim = "스칼로맨스 내에서 학자 테올렌 크라스티노브를 찾아 처치한 후 에바 사크호프의 유해와 루시엔 사크호프의 유해를 불태우십시오. 임무를 완수하면 에바 사크호프에게 돌아가야 합니다."
Inst11Quest3_Location = "에바 사크호프 (서부 역병지대 - 카엘 다로우; "..YELLOW.."70.2, 73.8"..WHITE..")"
Inst11Quest3_Note = "학자 테올렌 크라스티노브, 에바 사크호프의 유해 그리고 루시엔 사크호프의 유해는 "..YELLOW.."[9]"..WHITE.." 에서 찾을 수 있습니다."
Inst11Quest3_Prequest = "없음"
Inst11Quest3_Folgequest = "소름끼치는 크라스티노브의 가방"
-- No Rewards for this quest

--Quest 4 Alliance
Inst11Quest4 = "4. 소름끼치는 크라스티노브의 가방" -- Krastinov's Bag of Horrors
Inst11Quest4_Aim = "스칼로맨스에서 잔다이스 바로브를 찾아 처치해야 합니다. 그녀의 시체에서 소름끼치는 크라스티노브의 가방을 찾은 후 에바 사크호프에게 가져가야 합니다."
Inst11Quest4_Location = "에바 사크호프 (서부 역병지대 - 카엘 다로우; "..YELLOW.."70.2, 73.8"..WHITE..")"
Inst11Quest4_Note = "잔다이스 바로브는 "..YELLOW.."[3]"..WHITE.." 에서 찾을 수 있습니다."
Inst11Quest4_Prequest = "도살자, 테올렌 크라스티노브"
Inst11Quest4_Folgequest = "사자 키르토노스"
-- No Rewards for this quest

--Quest 5 Alliance
Inst11Quest5 = "5. 사자 키르토노스" -- Kirtonos the Herald
Inst11Quest5_Aim = "순결한 피를 가지고 스칼로맨스로 돌아가야 합니다. 사자의 창을 찾아 사자의 화롯불에 순결한 피를 올려놓으면 키르토노스가 영혼을 차지하기 위해 나타납니다.\n용맹하게 싸우고 단 한 발짝도 물러서지 마십시오! 키르토노스를 처치한 후 에바 사크호프에게 돌아가야 합니다."
Inst11Quest5_Location = "에바 사크호프 (서부 역병지대 - 카엘 다로우; "..YELLOW.."70.2, 73.8"..WHITE..")"
Inst11Quest5_Note = "베란다는 "..YELLOW.."[2]"..WHITE.." 에 있다."
Inst11Quest5_Prequest = "소름끼치는 크라스티노브의 가방"
Inst11Quest5_Folgequest = "라스 프로스트위스퍼"
--
Inst11Quest5name1 = "영혼의 정수"
Inst11Quest5name2 = "페넬로프의 장미"
Inst11Quest5name3 = "미라의 노래"

--Quest 6 Alliance
Inst11Quest6 = "6. 리치, 라스 프로스트위스퍼" -- The Lich, Ras Frostwhisper
Inst11Quest6_Aim = "스칼로맨스에서 라스 프로스트위스퍼를 찾아야 합니다. 영혼이 쓰인 유품을 언데드 상태인 라스의 얼굴에 사용하십시오. 그를 산 자로 되돌리는 데 성공하면 그를 쓰러뜨리고 사람이 된 라스 프로스트위스퍼의 머리카락을 가지고 집정관 마르듀크에게 가야 합니다."
Inst11Quest6_Location = "집정관 마르듀크 (서부 역병지대 - 카엘 다로우; "..YELLOW.."70.4, 74.0"..WHITE..")"
Inst11Quest6_Note = "라스 프로스트위스퍼는  "..YELLOW.."[7]"..WHITE.." 에서 찾을 수 있습니다."
Inst11Quest6_Prequest = "라스 프로스트위스퍼 -> 영혼이 씌인 유품"
Inst11Quest6_Folgequest = "없음"
--
Inst11Quest6name1 = "다로우샤이어 수호방패"
Inst11Quest6name2 = "카엘 다로우의 전투검"
Inst11Quest6name3 = "카엘 다로우의 관"
Inst11Quest6name4 = "다로우의 쐐기"

--Quest 7 Alliance
Inst11Quest7 = "7. 바로브 가의 유산!" -- Barov Family Fortune
Inst11Quest7_Aim = "스칼로맨스로 가서 바로브 가의 유산을 회수해야 합니다. 이 유산은 카엘 다로우 증서, 브릴 증서, 타렌 밀농장 증서, 사우스쇼어 증서의 4개 땅문서로 이루어져 있습니다. 이 임무를 완수한 후 웰던 바로브에게 돌아가야 합니다."
Inst11Quest7_Location = "웰던 바로브 (서부 역병지대 - 서리바람 야영지; "..YELLOW.."43.4, 83.8"..WHITE..")"
Inst11Quest7_Note = "카엘 다로우 증서는 "..YELLOW.."[12]"..WHITE..", 브릴 증서는 "..YELLOW.."[7]"..WHITE..", 타렌 밀농장 증서는 "..YELLOW.."[4]"..WHITE.." 그리고 사우스쇼어 증서는 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다.\n다음은 그거에 대한 보상입니다."
Inst11Quest7_Prequest = "없음"
Inst11Quest7_Folgequest = "최후의 바로브"
--
Inst11Quest7name1 = "바로브의 종"

--Quest 8 Alliance
Inst11Quest8 = "8. 여명의 계략" -- Dawn's Gambit
Inst11Quest8_Aim = "스칼로맨스의 스칼로맨스 강당 문에 여명의 계략을 놓아두고 벡투스를 처치한 후 베티나 비글징크에게 돌아가야 합니다."
Inst11Quest8_Location = "베티나 비글징크 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.6"..WHITE..")"
Inst11Quest8_Note = "새끼용의 정수의 시작은 팅키 스팀보일에서 (불타는 평원 - 화염 마루; "..YELLOW.."65.2, 23.8"..WHITE.."). 강당은 "..YELLOW.."[6]"..WHITE.." 에 있다."
Inst11Quest8_Prequest = "새끼용의 정수 -> 베티나 비글징크"
Inst11Quest8_Folgequest = "없음"
--
Inst11Quest8name1 = "바람도끼"
Inst11Quest8name2 = "춤추는 은마법봉"

--Quest 9 Alliance
Inst11Quest9 = "9. 임프 배달" -- Imp Delivery
Inst11Quest9_Aim = "단지 안에 든 임프를 스칼로맨스에 있는 연금술 실험대로 가져가야 합니다. 양피지가 완성되면 단지를 고르지키 와일드아이즈에게 되돌려 주십시오."
Inst11Quest9_Location = "고르지키 와일드아이즈 (불타는 평원; "..YELLOW.."12.6, 31.6"..WHITE..")"
Inst11Quest9_Note = "흑마법사 영웅 탈것 퀘스트 라인.  연금술 실험실은 "..YELLOW.."[7]"..WHITE.." 에서 찾을 수 있습니다."
Inst11Quest9_Prequest = "모르줄 블러드브링어 -> 소로시안 별가루"
Inst11Quest9_Folgequest = "소로스의 공포마 ("..YELLOW.."혈투의 전장 서쪽"..WHITE..")"
-- No Rewards for this quest

--Quest 10 Alliance
Inst11Quest10 = "10. 군주 발타라크의 아뮬렛 왼쪽 조각" -- The Left Piece of Lord Valthalak's Amulet
Inst11Quest10_Aim = "부름의 화로를 사용하여 크로모크의 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst11Quest10_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst11Quest10_Note = "보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 퀘스트에서 얻을 수 있습니다.\n\n코르모크는 "..YELLOW.."[7]"..WHITE.." 에서 소환 된다."
Inst11Quest10_Prequest = "중요한 요소"
Inst11Quest10_Folgequest = "예언속의 알카즈 섬"
-- No Rewards for this quest

--Quest 11 Alliance
Inst11Quest11 = "11. 군주 발타라크의 아뮬렛 오른쪽 조각" -- The Right Piece of Lord Valthalak's Amulet
Inst11Quest11_Aim = "부름의 화로를 사용하여 코르모크의 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 돌아가야 합니다."
Inst11Quest11_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst11Quest11_Note = "보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 퀘스트에서 얻을 수 있습니다.\n\n코르모크는 "..YELLOW.."[7]"..WHITE.." 에서 소환 된다."
Inst11Quest11_Prequest = "또 다른 중요한 요소"
Inst11Quest11_Folgequest = "마지막 준비 ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
-- No Rewards for this quest

--Quest 12 Alliance
Inst11Quest12 = "12. 심판과 구원의 손길" -- Judgment and Redemption
Inst11Quest12_Aim = "스칼로맨스에 있는 대형 납골당 지하의 중심부로 가서 예언의 탐지기를 사용해야 합니다. 그러면 영혼들이 나타날 것이니 그들을 해치우십시오. 그들을 해치우면 죽음의 기사 다크리버가 나타날 것이니 그를 물리친 다음 군마의 영혼의 잃어버린 영혼을 되찾아야 합니다.\n\n구원된 군마의 영혼과 축복받은 아케이나이트 마갑을 다크리버 군마의 영혼에게 돌려줘야 합니다."
Inst11Quest12_Location = "그레이슨 섀도브레이커 경 (스톰윈드 - 대성당; "..YELLOW.."37.6, 32.6"..WHITE..")"
Inst11Quest12_Note = "성기사 영웅 탈것 퀘스트 라인.  이 퀘스트 라인은 길고 많은 단계가 있습니다.  WoWhead.com 에는 이를 완료하는 방법에 대해 자세히 설명한 훌륭한 안내서가 있습니다.  대형 납골당 지하실은 "..YELLOW.."[5]"..WHITE.." 에 있다."
Inst11Quest12_Prequest = "그레이슨 섀도브레이커 경 -> 예언의 탐지기"
Inst11Quest12_Folgequest = "다시 대형 납골당으로"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst11Quest1_HORDE = Inst11Quest1
Inst11Quest1_HORDE_Aim = Inst11Quest1_Aim
Inst11Quest1_HORDE_Location = Inst11Quest1_Location
Inst11Quest1_HORDE_Note = Inst11Quest1_Note
Inst11Quest1_HORDE_Prequest = Inst11Quest1_Prequest
Inst11Quest1_HORDE_Folgequest = Inst11Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst11Quest2_HORDE = Inst11Quest2
Inst11Quest2_HORDE_Aim = Inst11Quest2_Aim
Inst11Quest2_HORDE_Location = Inst11Quest2_Location
Inst11Quest2_HORDE_Note = Inst11Quest2_Note
Inst11Quest2_HORDE_Prequest = Inst11Quest2_Prequest
Inst11Quest2_HORDE_Folgequest = Inst11Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst11Quest3_HORDE = Inst11Quest3
Inst11Quest3_HORDE_Aim = Inst11Quest3_Aim
Inst11Quest3_HORDE_Location = Inst11Quest3_Location
Inst11Quest3_HORDE_Note = Inst11Quest3_Note
Inst11Quest3_HORDE_Prequest = Inst11Quest3_Prequest
Inst11Quest3_HORDE_Folgequest = Inst11Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst11Quest4_HORDE = Inst11Quest4
Inst11Quest4_HORDE_Aim = Inst11Quest4_Aim
Inst11Quest4_HORDE_Location = Inst11Quest4_Location
Inst11Quest4_HORDE_Note = Inst11Quest4_Note
Inst11Quest4_HORDE_Prequest = Inst11Quest4_Prequest
Inst11Quest4_HORDE_Folgequest = Inst11Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst11Quest5_HORDE = Inst11Quest5
Inst11Quest5_HORDE_Aim = Inst11Quest5_Aim
Inst11Quest5_HORDE_Location = Inst11Quest5_Location
Inst11Quest5_HORDE_Note = Inst11Quest5_Note
Inst11Quest5_HORDE_Prequest = Inst11Quest5_Prequest
Inst11Quest5_HORDE_Folgequest = Inst11Quest5_Folgequest
--
Inst11Quest5name1_HORDE = Inst11Quest5name1
Inst11Quest5name2_HORDE = Inst11Quest5name2
Inst11Quest5name3_HORDE = Inst11Quest5name3

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst11Quest6_HORDE = Inst11Quest6
Inst11Quest6_HORDE_Aim = Inst11Quest6_Aim
Inst11Quest6_HORDE_Location = Inst11Quest6_Location
Inst11Quest6_HORDE_Note = Inst11Quest6_Note
Inst11Quest6_HORDE_Prequest = Inst11Quest6_Prequest
Inst11Quest6_HORDE_Folgequest = Inst11Quest6_Folgequest
--
Inst11Quest6name1_HORDE = Inst11Quest6name1
Inst11Quest6name2_HORDE = Inst11Quest6name2
Inst11Quest6name3_HORDE = Inst11Quest6name3
Inst11Quest6name4_HORDE = Inst11Quest6name4

--Quest 7 Horde
Inst11Quest7_HORDE = "7. 바로브 가의 유산" -- Barov Family Fortune
Inst11Quest7_HORDE_Aim = "스칼로맨스로 가서 바로브 가의 유산을 회수해야 합니다. 이 재산은 카엘 다로우 증서, 브릴 증서, 타렌 밀농장 증서, 사우스쇼어 증서의 4개 땅문서로 이루어져 있습니다. 임무를 완수한 후 알렉시 바로브에게 돌아가야 합니다."
Inst11Quest7_HORDE_Location = "알렉시 바로브 (티리스팔 숲 - 보루; "..YELLOW.."83.0, 71.4"..WHITE..")"
Inst11Quest7_HORDE_Note = "카엘 다로우 증서는 "..YELLOW.."[12]"..WHITE..", 브릴 증서는 "..YELLOW.."[7]"..WHITE..", 타렌 밀농장 증서는 "..YELLOW.."[4]"..WHITE.." 그리고 사우스쇼어 증서는 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다..\n다음은 그것에 대한 보상입니다."
Inst11Quest7_HORDE_Prequest = "없음"
Inst11Quest7_HORDE_Folgequest = "최후의 상속자"
--
Inst11Quest7name1_HORDE = "바로브의 종"

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst11Quest8_HORDE = Inst11Quest8
Inst11Quest8_HORDE_Aim = Inst11Quest8_Aim
Inst11Quest8_HORDE_Location = Inst11Quest8_Location
Inst11Quest8_HORDE_Note = Inst11Quest8_Note
Inst11Quest8_HORDE_Prequest = Inst11Quest8_Prequest
Inst11Quest8_HORDE_Folgequest = Inst11Quest8_Folgequest
--
Inst11Quest8name1_HORDE = Inst11Quest8name1
Inst11Quest8name2_HORDE = Inst11Quest8name2

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst11Quest9_HORDE = Inst11Quest9
Inst11Quest9_HORDE_Aim = Inst11Quest9_Aim
Inst11Quest9_HORDE_Location = Inst11Quest9_Location
Inst11Quest9_HORDE_Note = Inst11Quest9_Note
Inst11Quest9_HORDE_Prequest = Inst11Quest9_Prequest
Inst11Quest9_HORDE_Folgequest = Inst11Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst11Quest10_HORDE = Inst11Quest10
Inst11Quest10_HORDE_Aim = Inst11Quest10_Aim
Inst11Quest10_HORDE_Location = Inst11Quest10_Location
Inst11Quest10_HORDE_Note = Inst11Quest10_Note
Inst11Quest10_HORDE_Prequest = Inst11Quest10_Prequest
Inst11Quest10_HORDE_Folgequest = Inst11Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde
Inst11Quest11_HORDE = "11. 다크리버의 위협" -- The Darkreaver Menace
Inst11Quest11_HORDE_Aim = "스칼로맨스 대형 납골당 지하실 가운데에 예언의 탐지기를 놓으십시오. 그러면 영혼들이 나타날 것입니다. 모두 물리치면 죽음의 기사 다크리버가 나타납니다. 그를 쓰러뜨리십시오.\n\n오그리마 지혜의 골짜기에 있는 사고른 크레스트스트라이더에게 다크리버가 죽었다는 증거로 그의 머리카락을 가져가야 합니다."
Inst11Quest11_HORDE_Location = "사고른 크레스트스트라이더 (오그리마 - 지혜의 골짜기; "..YELLOW.."38.6, 36.2"..WHITE..")"
Inst11Quest11_HORDE_Note = "주술사 퀘스트.  선행 퀘스트는 동일한 NPC에서 받습니다.\n\n죽음의 기사 다크리버는 "..YELLOW.."[5]"..WHITE.." 소환됩니다."
Inst11Quest11_HORDE_Prequest = "물질적인 부탁"
Inst11Quest11_HORDE_Folgequest = "없음"
--
Inst11Quest11name1_HORDE = "성난하늘 투구"

--Quest 12 Horde  (same as Quest 11 Alliance)
Inst11Quest12_HORDE = "12. 군주 발타라크의 아뮬렛 오른쪽 조각" -- The Right Piece of Lord Valthalak's Amulet
Inst11Quest12_HORDE_Aim = Inst11Quest11_Aim
Inst11Quest12_HORDE_Location = Inst11Quest11_Location
Inst11Quest12_HORDE_Note = Inst11Quest11_Note
Inst11Quest12_HORDE_Prequest = Inst11Quest11_Prequest
Inst11Quest12_HORDE_Folgequest = Inst11Quest11_Folgequest
-- No Rewards for this quest



--------------- INST12 - Shadowfang Keep 그림자송곳니 성채 ---------------

Inst12Caption = "그림자송곳니 성채"
Inst12QAA = "2 퀘스트"
Inst12QAH = "4 퀘스트"

--Quest 1 Alliance
Inst12Quest1 = "1. 정의의 시험" -- The Test of Righteousness
Inst12Quest1_Aim = Inst5Quest6_Aim
Inst12Quest1_Location = Inst5Quest6_Location
Inst12Quest1_Note = "성기사 퀘스트.  조던의 대장장이 망치는 "..YELLOW.."[9]"..WHITE.." 에 있다.\n\n나머지 아이템은 "..YELLOW.."[죽음의 폐광]"..WHITE..", 모단 호수, 어둠의 해안과 잿빛골짜기.  일부는 사이드 퀘스트를 수행해야합니다.  자세한 내용은 Wowhead에서 찾아 보는 것이 좋습니다."
Inst12Quest1_Prequest = Inst5Quest6_Prequest
Inst12Quest1_Folgequest = Inst5Quest6_Folgequest
--
Inst12Quest1name1 = Inst5Quest6name1

--Quest 2 Alliance
Inst12Quest2 = "2. 소랜루크 수정구" -- The Orb of Soran'ruk
Inst12Quest2_Aim = "소랜루크 조각 3개와 큰 소랜루크 조각 1개를 찾아 불모의 땅에 있는 도안 카르한에게 가져가야 합니다."
Inst12Quest2_Location = "도안 카르한 (불모의 땅; "..YELLOW.."49.2, 57.2"..WHITE..")"
Inst12Quest2_Note = "흑마법사 퀘스트.  \n황혼의 망치단 수행사제에게 소랜루크 조각 3개  "..YELLOW.."[검은심연 나락]"..WHITE..". \n그림자송곳니일족 검은영혼에게 큰 소랜루크 조각은 1개  "..YELLOW.."[그림자송곳니 성채]"..WHITE.." 를 얻을 수 있다."
Inst12Quest2_Prequest = "없음"
Inst12Quest2_Folgequest = "없음"
--
Inst12Quest2name1 = "소랜루크 수정구"
Inst12Quest2name2 = "소랜루크의 지팡이"



--Quest 1 Horde
Inst12Quest1_HORDE = "1. 그림자송곳니 성채의 죽음의추적자" -- Deathstalkers in Shadowfang
Inst12Quest1_HORDE_Aim = "죽음의추적자 아다만트와 죽음의추적자 빈센트를 찾아야 합니다."
Inst12Quest1_HORDE_Location = "고위집행관 하드렉 (은빛소나무 숲 - 공동묘지; "..YELLOW.."43.4, 40.8"..WHITE..")"
Inst12Quest1_HORDE_Note = "죽음의추적자 아다만트는 "..YELLOW.."[1]"..WHITE.." 에 있다. 당신이 안뜰에 갈 때 죽음의추적자 빈센트는 오른쪽에 있습니다."
Inst12Quest1_HORDE_Prequest = "없음"
Inst12Quest1_HORDE_Folgequest = "없음"
--
Inst12Quest1name1_HORDE = "유령의 어깨보호대"

--Quest 2 Horde
Inst12Quest2_HORDE = "2. 우르의 책" -- The Book of Ur
Inst12Quest2_HORDE_Aim = "언더시티의 연금술 실험실에 있는 관리인 벨두거에게 우르의 책을 가져가야 합니다."
Inst12Quest2_HORDE_Location = "관리인 벨두거 (언더시티 - 연금술 실험실; "..YELLOW.."53.6, 54.0"..WHITE..")"
Inst12Quest2_HORDE_Note = "방에 들어가면 왼쪽에 책이 "..YELLOW.."[6]"..WHITE.." 있습니다."
Inst12Quest2_HORDE_Prequest = "없음"
Inst12Quest2_HORDE_Folgequest = "없음"
--
Inst12Quest2name1_HORDE = "불곰 장화"
Inst12Quest2name2_HORDE = "강철죔쇠 팔보호구"

--Quest 3 Horde
Inst12Quest3_HORDE = "3. 아루갈의 최후" -- Arugal Must Die
Inst12Quest3_HORDE_Aim = "아루갈을 처치하고 그 증거로 그의 머리카락을 공동묘지에 있는 달라 돈위버에게 가져가야 합니다."
Inst12Quest3_HORDE_Location = "달라 던위버 (은빛소나무 숲 - 공동묘지; "..YELLOW.."44.2, 39.8"..WHITE..")"
Inst12Quest3_HORDE_Note = "대마법사 아루갈은 "..YELLOW.."[8]"..WHITE.." 에서 찾을 수 있습니다."
Inst12Quest3_HORDE_Prequest = "없음"
Inst12Quest3_HORDE_Folgequest = "없음"
--
Inst12Quest3name1_HORDE = "실바나스의 인장"

--Quest 4 Horde  (same as Quest 2 Alliance)
Inst12Quest4_HORDE = "4. 소랜루크 수정구" -- The Orb of Soran'ruk
Inst12Quest4_HORDE_Aim = Inst12Quest2_Aim
Inst12Quest4_HORDE_Location = Inst12Quest2_Location
Inst12Quest4_HORDE_Note = Inst12Quest2_Note
Inst12Quest4_HORDE_Prequest = Inst12Quest2_Prequest
Inst12Quest4_HORDE_Folgequest = Inst12Quest2_Folgequest
--
Inst12Quest4name1_HORDE = Inst12Quest2name1
Inst12Quest4name2_HORDE = Inst12Quest2name1



--------------- INST13 - The Stockade 스톰윈드 지하감옥 ---------------

Inst13Caption = "스톰윈드 지하감옥"
Inst13QAA = "6 퀘스트"
Inst13QAH = "퀘스트 없음"

--Quest 1 Alliance
Inst13Quest1 = "1. 사필귀정" -- What Comes Around...
Inst13Quest1_Aim = "흉악범 타고르를 처치한 후 그 증거로 그의 머리카락을 레이크샤이어에 있는 경비병 베르턴에게 가져가야 합니다."
Inst13Quest1_Location = "경비병 베르턴 (붉은마루 산맥 - 레이크샤이어; "..YELLOW.."26.4, 46.6"..WHITE..")"
Inst13Quest1_Note = "타고르를 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다."
Inst13Quest1_Prequest = "없음"
Inst13Quest1_Folgequest = "없음"
--
Inst13Quest1name1 = "약탈의 롱소드"
Inst13Quest1name2 = "단단한 뿌리 지팡이"

--Quest 2 Alliance
Inst13Quest2 = "2. 죄와 벌" -- Crime and Punishment
Inst13Quest2_Aim = "다크샤이어의 원로 밀스타이프가 덱스트렌 워드를 처치한 후 그의 장갑을 가져다 달라고 부탁했습니다."
Inst13Quest2_Location = "Millstipe (그늘숲 - 다크샤이어; "..YELLOW.."72.0, 47.8"..WHITE..")"
Inst13Quest2_Note = "덱스트렌은 "..YELLOW.."[5]"..WHITE.." 에서 찾을 수 있습니다."
Inst13Quest2_Prequest = "없음"
Inst13Quest2_Folgequest = "없음"
--
Inst13Quest2name1 = "대사의 장화"
Inst13Quest2name2 = "다크샤이어 쇠사슬 다리보호구"

--Quest 3 Alliance
Inst13Quest3 = "3. 폭동 진압" -- Quell The Uprising
Inst13Quest3_Aim = "스톰윈드에 있는 교도소장 델워터가 지하감옥에서 데피아즈단 복역수 10명, 데피아즈단 무기징역수 8명, 데피아즈단 반역자 8명을 처치해 달라고 부탁했습니다."
Inst13Quest3_Location = "교도소장 델워터 (스톰윈드 - 지하감옥; "..YELLOW.."41.2, 58.0"..WHITE..")"
Inst13Quest3_Note = "때로는 퀘스트를 완료하기에 충분한 몬스터가 없으며 일부는 리젠될 때까지 기다려야 할 수도 있습니다."
Inst13Quest3_Prequest = "없음"
Inst13Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst13Quest4 = "4. 피의 색" -- The Color of Blood
Inst13Quest4_Aim = "스톰윈드에 있는 니코바 라스콜이 붉은 양모 복면을 10개를 모아 달라고 부탁했습니다."
Inst13Quest4_Location = "니코바 라스콜 (스톰윈드 - 구 시가지; "..YELLOW.."66.8, 46.4"..WHITE..")"
Inst13Quest4_Note = "니코바 라스콜은 구 시가지를 돌아다닌다. 던전 내부에 있는 모든 몬스터들은 붉은 양모 복면을 드랍 할 수 있습니다."
Inst13Quest4_Prequest = "없음"
Inst13Quest4_Folgequest = "없음"
-- No Rewards for this quest

--Quest 5 Alliance
Inst13Quest5 = "5. 격노" -- The Fury Runs Deep
Inst13Quest5_Aim = "딥퓨리를 처치하고 그 증거로 그의 머리카락을 던 모드르에 있는 모틀리 가마슨에게 가져가야 합니다."
Inst13Quest5_Location = "모틀리 가마슨 (저습지 - 던 모드르; "..YELLOW.."49.6, 18.2"..WHITE..")"
Inst13Quest5_Note = "이전 퀘스트도 모틀리 가마슨에서 받을 수 있습니다. 캄 딥퓨리는 "..YELLOW.."[2]"..WHITE.." 에서 찾을 수 있습니다."
Inst13Quest5_Prequest = "검은무쇠단과의 전투"
Inst13Quest5_Folgequest = "없음"
--
Inst13Quest5name1 = "지지의 허리띠"
Inst13Quest5name2 = "산산조각 철퇴"

--Quest 6 Alliance
Inst13Quest6 = "6. 감옥 폭동" -- The Stockade Riots
Inst13Quest6_Aim = "바질 스레드를 처치하고 그 증거로 그의 머리카락을 감옥에 있는 교도소장 델워터에게 가져가야 합니다."
Inst13Quest6_Location = "교도소장 델워터 (스톰윈드 - 지하감옥; "..YELLOW.."41.2, 58.0"..WHITE..")"
Inst13Quest6_Note = "바질 스레드는 "..YELLOW.."[4]"..WHITE.." 에서 찾을 수 있습니다."
Inst13Quest6_Prequest = "데피아즈단 -> 바질 스레드"
Inst13Quest6_Folgequest = "수상한 면회인"
-- No Rewards for this quest



--------------- INST14 - Stratholme 스트라솔름 ---------------

Inst14Caption = "스트라솔름"
Inst14QAA = "18 퀘스트"
Inst14QAH = "19 퀘스트"

--Quest 1 Alliance
Inst14Quest1 = "1. 거짓말하지 않는 육체" -- The Flesh Does Not Lie
Inst14Quest1_Aim = "스트라솔름에서 10개의 역병 걸린 살덩어리 견본을 베티나 비글징크에게 가져다주어야 합니다. 스트라솔름의 어떤 생물에서든 살덩어리 견본을 구할 수 있을 것 같습니다."
Inst14Quest1_Location = "베티나 비글징크 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.6"..WHITE..")"
Inst14Quest1_Note = "스트라솔름에 있는 대부분의 몬스터들은 역병 걸린 상덩어리 견본을 드랍하지만, 드랍률은 낮은 것 같습니다."
Inst14Quest1_Prequest = "없음"
Inst14Quest1_Folgequest = "활성 역병 인자"
-- No Rewards for this quest

--Quest 2 Alliance
Inst14Quest2 = "2. 활성 역병 인자" -- The Active Agent
Inst14Quest2_Aim = "스트라솔름으로 가서 지구라트를 조사해야 합니다. 스컬지 자료를 찾아 베티나 비글징크에게 돌아가야 합니다."
Inst14Quest2_Location = "베티나 비글징크 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.6"..WHITE..")"
Inst14Quest2_Note = "스컬지 자료는 3개의 타워 "..YELLOW.."[15]"..WHITE..", "..YELLOW.."[16]"..WHITE.." 과 "..YELLOW.."[17]"..WHITE.." 중 하나에 있습니다.."
Inst14Quest2_Prequest = "거짓말하지 않는 육체"
Inst14Quest2_Folgequest = "없음"
--
Inst14Quest2name1 = "여명의 문장"
Inst14Quest2name2 = "여명의 룬"

--Quest 3 Alliance
Inst14Quest3 = "3. 성스러운 집" -- Houses of the Holy
Inst14Quest3_Aim = "북쪽에 있는 스트라솔름으로 가서 도시 어딘가에 흩어진 보급품 상자를 찾아 스트라솔름 성수 5병을 가져와야 합니다. 성수를 충분히 모으고 나면 존경받는 리어니드 바돌로매에게 돌아가야 합니다."
Inst14Quest3_Location = "존경받는 리어니드 바돌로매 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.6, 57.8"..WHITE..")"
Inst14Quest3_Note = "성수는 스트라솔름의 모든 곳에 있는 상자들에서 찾을 수 있다. 일부 상자는 당신을 공격하는 벌레가 나올 수 있습니다.."
Inst14Quest3_Prequest = "없음"
Inst14Quest3_Folgequest = "없음"
--
Inst14Quest3name1 = "최상급 치유 물약"
Inst14Quest3name2 = "상급 마나 물약"
Inst14Quest3name3 = "참회의 관"
Inst14Quest3name4 = "참회의 띠"

--Quest 4 Alliance
Inst14Quest4 = "4. 위대한 프라스 샤비" -- The Great Fras Siabi
Inst14Quest4_Aim = "스트라솔름에서 샤비의 최고급 담배를 회수하여 스모키 라루에게 가져가야 합니다."
Inst14Quest4_Location = "스모키 라루 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."80.6, 58.0"..WHITE..")"
Inst14Quest4_Note = "최고급 담배는 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다.  상자를 열면 프라스 샤비가 나타납니다."
Inst14Quest4_Prequest = "없음"
Inst14Quest4_Folgequest = "없음"
--
Inst14Quest4name1 = "스모키의 라이터"

--Quest 5 Alliance
Inst14Quest5 = "5. 잠 못 드는 영혼 (2)" -- The Restless Souls
Inst14Quest5_Aim = "스트라솔름 시민의 영혼과 원혼들에게 에간의 제령포를 사용해야 합니다. 원혼들이 그들을 가두고 있던 감옥에서 풀려나면 다시 총을 사용하여 그들에게 자유를 선사하십시오!15명의 잠 못드는 영혼을 자유롭게 하고 에간에게 돌아가야 합니다."
Inst14Quest5_Location = "에간 (동부 역병지대 - 테러데일; "..YELLOW.."14.4, 33.6"..WHITE..")"
Inst14Quest5_Note = "선행 퀘스트는 관리인 알렌에서 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."79.4, 63.8"..WHITE..") 받습니다.  시민의 유령은 스트라솔름 거리를 걸어 다닙니다."
Inst14Quest5_Prequest = "잠 못 드는 영혼"
Inst14Quest5_Folgequest = "없음"
--
Inst14Quest5name1 = "희망의 유언"

--Quest 6 Alliance
Inst14Quest6 = "6. 가족과 사랑 (2)" -- Of Love and Family
Inst14Quest6_Aim = "역병지대의 북쪽, 스트라솔름에 있는 붉은십자군 성채로 가서 쌍둥이 달 그림을 찾으십시오.그 뒤에 숨겨진 '가족과 사랑'이라는 그림을 찾아 티리온 폴드링에게 가져가야 합니다."
Inst14Quest6_Location = "화가 렌프레이 (서부 역병지대 - 카엘 다로우; "..YELLOW.."65.6, 75.4"..WHITE..")"
Inst14Quest6_Note = "사전 퀘스트는 티리온 폴드링에서 (서부 역병지대; "..YELLOW.."7.4, 43.6"..WHITE..") 받습니다.  근처에서 사진을 "..YELLOW.."[10]"..WHITE.." 찾을 수 있습니다."
Inst14Quest6_Prequest = "구원 -> 가족과 사랑"
Inst14Quest6_Folgequest = "미란다 찾기"
-- No Rewards for this quest

--Quest 7 Alliance
Inst14Quest7 = "7. 메네실의 선물!" -- Menethil's Gift
Inst14Quest7_Aim = "스트라솔름으로 가서 메네실의 선물을 찾아서 그 부정한 땅 위에 추억의 유품을 두어야 합니다."
Inst14Quest7_Location = "존경받는 리어니드 바돌로 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.6, 57.8"..WHITE..")"
Inst14Quest7_Note = "선행 퀘스트는 집정관 마르듀크에서 (서부 역병지대 - 카엘 다로우; "..YELLOW.."70.4, 74.0"..WHITE..") 받습니다.  부정한 땅은 "..YELLOW.."[19]"..WHITE.." 에 있다."
Inst14Quest7_Prequest = "라스 프로스트위스퍼 -> 망자, 라스 프로스트위스퍼"
Inst14Quest7_Folgequest = "메네실의 선물! (2)"
-- No Rewards for this quest

--Quest 8 Alliance
Inst14Quest8 = "8. 아우리우스의 복수" -- Aurius' Reckoning
Inst14Quest8_Aim = "남작 리븐데어를 처치하라"
Inst14Quest8_Location = "아우리우스 (스트라솔름; "..YELLOW.."[13]"..WHITE..")"
Inst14Quest8_Note = "요새의 첫 방에 있는 상자에서 (말로의 금고 "..YELLOW.."[7]"..WHITE..") 메달을 얻습니다. (길이 갈라지기 전에). 귀속되지 않으므로 다른 플레이어와 교환하거나 별도로 실행할 수 있습니다.\n\n아우리우스에게 메달을 준 후 남작 리븐데어와 싸울 때 그는 당신을 도울 것입니다. "..YELLOW.."[19]"..WHITE..". 남작이 죽은 후 아우리우스도 죽습니다. 그의 시체와 대화하여 보상을 받으세요."
Inst14Quest8_Prequest = "없음"
Inst14Quest8_Folgequest = "없음"
--
Inst14Quest8name1 = "순교자의 결의"
Inst14Quest8name2 = "순교자의 피"

--Quest 9 Alliance
Inst14Quest9 = "9. 기록관" -- The Archivist
Inst14Quest9_Aim = "스트라솔름으로 가서 붉은십자군의 기록관, 갈포드를 찾아서 그를 처치하고 붉은십자군 기록을 불태워 버려야 합니다."
Inst14Quest9_Location = "공작 니콜라스 즈바른호프 (서부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.8"..WHITE..")"
Inst14Quest9_Note = "기록관과 기록은 "..YELLOW.."[10]"..WHITE.." 에서 찾을 수 있습니다."
Inst14Quest9_Prequest = "없음"
Inst14Quest9_Folgequest = "밝혀지는 진실"
-- No Rewards for this quest

--Quest 10 Alliance
Inst14Quest10 = "10. 밝혀지는 진실" -- The Truth Comes Crashing Down
Inst14Quest10_Aim = "동부 역병지대에 있는 공작 니콜라스 즈바른호프에게 발나자르의 혼을 가져가야 합니다."
Inst14Quest10_Location = "발나자르 (스트라솔름; "..YELLOW.."[11]"..WHITE..")"
Inst14Quest10_Note = "동부 역병지대 - 희망의 빛 예배당에서 공작 니콜라스 즈바른호프 ("..YELLOW.."81.4, 59.8"..WHITE..") 찾을 수 있습니다."
Inst14Quest10_Prequest = "기록관"
Inst14Quest10_Folgequest = "뛰어난 존재"
-- No Rewards for this quest

--Quest 11 Alliance
Inst14Quest11 = "11. 뛰어난 존재" -- Above and Beyond
Inst14Quest11_Aim = "스트라솔름으로 가서 남작 리븐데어를 처치하고 그의 혼을 공작 니콜라스 즈바른호프에게 가져가야 합니다."
Inst14Quest11_Location = "공작 니콜라스 즈바른호프 (동부 역병지대 - 희망의 빛 예배당; "..YELLOW.."81.4, 59.8"..WHITE..")"
Inst14Quest11_Note = "남작 리븐데어는 "..YELLOW.."[19]"..WHITE.." 에 있다.\n\n다음은 그것에 대한 보상입니다."
Inst14Quest11_Prequest = "밝혀지는 진실"
Inst14Quest11_Folgequest = "맥스웰 티로서스 경 -> 여명회의 궤"
--
Inst14Quest11name1 = "은빛의 수호자"
Inst14Quest11name2 = "은빛의 십자군"
Inst14Quest11name3 = "은빛의 복수자"

--Quest 12 Alliance
Inst14Quest12 = "12. 죽은 자의 부탁" -- Dead Man's Plea
Inst14Quest12_Aim = "스트라솔름으로 가서 남작 리븐데어로부터 이시다 하몬을 구출해야 합니다."
Inst14Quest12_Location = "안시온 하몬 (동부 역병지대 - 스트라솔름)"
Inst14Quest12_Note = "안시온 하몬은 스트라솔름 정문 포털 바로 밖에 서 있습니다. 그를 보려면 4차원 유령탐색기가 필요합니다. 유령탐색기는 선행 퀘스트에서 나옵니다. 퀘스트라인은 단지 보상으로 시작합니다. 얼라이언스는 아이언포지의 델리아나 ("..YELLOW.."43, 52"..WHITE.."), 호드는 오그리마의 모크바르 ("..YELLOW.."38, 37"..WHITE..").\n이것은 악명 높은 '45분' 남작 최단시간 클리어 입니다."
Inst14Quest12_Prequest = "안시온을 찾아서"
Inst14Quest12_Folgequest = "생존의 증거"
--
Inst14Quest12name1 = "이시다의 가방"

--Quest 13 Alliance
Inst14Quest13 = "13. 군주 발타라크의 아뮬렛 왼쪽 조각" -- The Left Piece of Lord Valthalak's Amulet
Inst14Quest13_Aim = "부름의 화로를 사용하여 자리엔과 소도스의 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst14Quest13_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst14Quest13_Note = "보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n자리엔과 소도스는 "..YELLOW.."[11]"..WHITE.." 에서 소환 된다."
Inst14Quest13_Prequest = "중요한 요소"
Inst14Quest13_Folgequest = "예언속의 알카즈 섬"
-- No Rewards for this quest

--Quest 14 Alliance
Inst14Quest14 = "14. 군주 발타라크의 아뮬렛 오른쪽 조각" -- The Right Piece of Lord Valthalak's Amulet
Inst14Quest14_Aim = "부름의 화로를 사용하여 자리엔과 소도스의 영혼을 소환한 후 처치하십시오. 완성된 군주 발타라크의 아뮬렛과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst14Quest14_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst14Quest14_Note = "보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n자리엔과 소도스는 "..YELLOW.."[11]"..WHITE.." 에서 소환 된다."
Inst14Quest14_Prequest = "또 다른 중요한 요소"
Inst14Quest14_Folgequest = "마지막 준비 ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
-- No Rewards for this quest

--Quest 15 Alliance
Inst14Quest15 = "15. Atiesh, Greatstaff of the Guardian" -- Atiesh, Greatstaff of the Guardian
Inst14Quest15_Aim = "Anachronos at the Caverns of Time in Tanaris wants you to take Atiesh, Greatstaff of the Guardian to Stratholme and use it on Consecrated Earth. Defeat the entity that is exorcised from the staff and return to him."
Inst14Quest15_Location = "Anachronos (Tanaris - Caverns of Time; "..YELLOW.."65, 49"..WHITE..")"
Inst14Quest15_Note = "Atiesh is summoned at "..YELLOW.."[2]"..WHITE..".\n\nAs of October 2019 this quest is not available in WoW Classic yet.  I'll update this when it is added."
Inst14Quest15_Prequest = "Yes"
Inst14Quest15_Folgequest = "None"
--
Inst14Quest15name1 = "아티쉬 - 수호자의 지팡이"
Inst14Quest15name2 = "아티쉬 - 수호자의 지팡이"
Inst14Quest15name3 = "아티쉬 - 수호자의 지팡이"
Inst14Quest15name4 = "아티쉬 - 수호자의 지팡이"

--Quest 16 Alliance
Inst14Quest16 = "16. 부패의 검" -- Corruption
Inst14Quest16_Aim = "스트라솔름에서 검은호위대 검제작자를 찾아 그를 처치하고 검은호위대 휘장을 회수한 후, 세릴 스컬지베인에게 갖다주어야 합니다."
Inst14Quest16_Location = "세릴 스컬지베인 (여명의 설원 - 눈망루 마을; "..YELLOW.."61.2, 37.2"..WHITE..")"
Inst14Quest16_Note = "대장기술 퀘스트.  검은호위대 검제작자는 "..YELLOW.."[15]"..WHITE.." 근처에서 소환됩니다."
Inst14Quest16_Prequest = "없음"
Inst14Quest16_Folgequest = "없음"
--
Inst14Quest16name1 = "도면: 불타는 레이피어"

--Quest 17 Alliance
Inst14Quest17 = "17. 진홍십자군 작업복" -- Sweet Serenity
Inst14Quest17_Aim = "스트라솔름으로 가서 진홍십자군 대장장이를 처치하고 진홍십자군 대장장이의 작업복을 가지고 릴리스에게 돌아가야 합니다."
Inst14Quest17_Location = "호리호리한 릴리스 (여명의 설원 - 눈망루 마을; "..YELLOW.."61.2, 37.2"..WHITE..")"
Inst14Quest17_Note = "대장기술 퀘스트.  진홍십자군 대장장이는 "..YELLOW.."[8]"..WHITE.." 에서 소환됩니다."
Inst14Quest17_Prequest = "없음"
Inst14Quest17_Folgequest = "없음"
--
Inst14Quest17name1 = "도면: 바력 깃든 전투망치"

--Quest 18 Alliance
Inst14Quest18 = "18. 빛과 어둠의 균형" -- The Balance of Light and Shadow
Inst14Quest18_Aim = "15명이 살해 당하기 전에 인부 50명을 구해야 합니다. 이 임무를 완수하면 에리스 헤븐파이어와 대화하십시오.살해 당한 농부의 수를 보려면 죽음의 말뚝을 보십시오."
Inst14Quest18_Location = "에리스 헤븐파이어 (동부 역병지대; "..YELLOW.."20.8, 18.2"..WHITE..")"
Inst14Quest18_Note = "사제 퀘스트.  에리스 헤븐파이어에게 이 퀘스트와 사전 퀘스트를 받으려면 신앙의 눈이 필요합니다. (불의 군주의 보물에서 나옴 "..YELLOW.."[화산 심장부]"..WHITE..").\n\n이 퀘스트 보상은, 신앙의 눈과 어둠의 눈을 결합했을 때 (여명의 설원 또는 저주받은 땅 악마에게서 드랍합니다.) 축복의 지팡이가 생성됩니다."
Inst14Quest18_Prequest = "경고"
Inst14Quest18_Folgequest = "없음"
--
Inst14Quest18name1 = "놀드랏실의 파편"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst14Quest1_HORDE = Inst14Quest1
Inst14Quest1_HORDE_Aim = Inst14Quest1_Aim
Inst14Quest1_HORDE_Location = Inst14Quest1_Location
Inst14Quest1_HORDE_Note = Inst14Quest1_Note
Inst14Quest1_HORDE_Prequest = Inst14Quest1_Prequest
Inst14Quest1_HORDE_Folgequest = Inst14Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst14Quest2_HORDE = Inst14Quest2
Inst14Quest2_HORDE_Aim = Inst14Quest2_Aim
Inst14Quest2_HORDE_Location = Inst14Quest2_Location
Inst14Quest2_HORDE_Note = Inst14Quest2_Note
Inst14Quest2_HORDE_Prequest = Inst14Quest2_Prequest
Inst14Quest2_HORDE_Folgequest = Inst14Quest2_Folgequest
--
Inst14Quest2name1_HORDE = Inst14Quest2name1
Inst14Quest2name2_HORDE = Inst14Quest2name2

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst14Quest3_HORDE = Inst14Quest3
Inst14Quest3_HORDE_Aim = Inst14Quest3_Aim
Inst14Quest3_HORDE_Location = Inst14Quest3_Location
Inst14Quest3_HORDE_Note = Inst14Quest3_Note
Inst14Quest3_HORDE_Prequest = Inst14Quest3_Prequest
Inst14Quest3_HORDE_Folgequest = Inst14Quest3_Folgequest
--
Inst14Quest3name1_HORDE = Inst14Quest3name1
Inst14Quest3name2_HORDE = Inst14Quest3name2
Inst14Quest3name3_HORDE = Inst14Quest3name3
Inst14Quest3name4_HORDE = Inst14Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst14Quest4_HORDE = Inst14Quest4
Inst14Quest4_HORDE_Aim = Inst14Quest4_Aim
Inst14Quest4_HORDE_Location = Inst14Quest4_Location
Inst14Quest4_HORDE_Note = Inst14Quest4_Note
Inst14Quest4_HORDE_Prequest = Inst14Quest4_Prequest
Inst14Quest4_HORDE_Folgequest = Inst14Quest4_Folgequest
--
Inst14Quest4name1_HORDE = Inst14Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst14Quest5_HORDE = Inst14Quest5
Inst14Quest5_HORDE_Aim = Inst14Quest5_Aim
Inst14Quest5_HORDE_Location = Inst14Quest5_Location
Inst14Quest5_HORDE_Note = Inst14Quest5_Note
Inst14Quest5_HORDE_Prequest = Inst14Quest5_Prequest
Inst14Quest5_HORDE_Folgequest = Inst14Quest5_Folgequest
--
Inst14Quest5name1_HORDE = Inst14Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst14Quest6_HORDE = Inst14Quest6
Inst14Quest6_HORDE_Aim = Inst14Quest6_Aim
Inst14Quest6_HORDE_Location = Inst14Quest6_Location
Inst14Quest6_HORDE_Note = Inst14Quest6_Note
Inst14Quest6_HORDE_Prequest = Inst14Quest6_Prequest
Inst14Quest6_HORDE_Folgequest = Inst14Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst14Quest7_HORDE = Inst14Quest7
Inst14Quest7_HORDE_Aim = Inst14Quest7_Aim
Inst14Quest7_HORDE_Location = Inst14Quest7_Location
Inst14Quest7_HORDE_Note = Inst14Quest7_Note
Inst14Quest7_HORDE_Prequest = Inst14Quest7_Prequest
Inst14Quest7_HORDE_Folgequest = Inst14Quest7_Folgequest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst14Quest8_HORDE = Inst14Quest8
Inst14Quest8_HORDE_Aim = Inst14Quest8_Aim
Inst14Quest8_HORDE_Location = Inst14Quest8_Location
Inst14Quest8_HORDE_Note = Inst14Quest8_Note
Inst14Quest8_HORDE_Prequest = Inst14Quest8_Prequest
Inst14Quest8_HORDE_Folgequest = Inst14Quest8_Folgequest
--
Inst14Quest8name1_HORDE = Inst14Quest8name1
Inst14Quest8name2_HORDE = Inst14Quest8name2

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst14Quest9_HORDE = Inst14Quest9
Inst14Quest9_HORDE_Aim = Inst14Quest9_Aim
Inst14Quest9_HORDE_Location = Inst14Quest9_Location
Inst14Quest9_HORDE_Note = Inst14Quest9_Note
Inst14Quest9_HORDE_Prequest = Inst14Quest9_Prequest
Inst14Quest9_HORDE_Folgequest = Inst14Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst14Quest10_HORDE = Inst14Quest10
Inst14Quest10_HORDE_Aim = Inst14Quest10_Aim
Inst14Quest10_HORDE_Location = Inst14Quest10_Location
Inst14Quest10_HORDE_Note = Inst14Quest10_Note
Inst14Quest10_HORDE_Prequest = Inst14Quest10_Prequest
Inst14Quest10_HORDE_Folgequest = Inst14Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst14Quest11_HORDE = Inst14Quest11
Inst14Quest11_HORDE_Aim = Inst14Quest11_Aim
Inst14Quest11_HORDE_Location = Inst14Quest11_Location
Inst14Quest11_HORDE_Note = Inst14Quest11_Note
Inst14Quest11_HORDE_Prequest = Inst14Quest11_Prequest
Inst14Quest11_HORDE_Folgequest = Inst14Quest11_Folgequest
--
Inst14Quest11name1_HORDE = Inst14Quest11name1
Inst14Quest11name2_HORDE = Inst14Quest11name2
Inst14Quest11name3_HORDE = Inst14Quest11name3

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst14Quest12_HORDE = Inst14Quest12
Inst14Quest12_HORDE_Aim = Inst14Quest12_Aim
Inst14Quest12_HORDE_Location = Inst14Quest12_Location
Inst14Quest12_HORDE_Note = Inst14Quest12_Note
Inst14Quest12_HORDE_Prequest = Inst14Quest12_Prequest
Inst14Quest12_HORDE_Folgequest = Inst14Quest12_Folgequest
--
Inst14Quest12name1_HORDE = Inst14Quest12name1

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst14Quest13_HORDE = Inst14Quest13
Inst14Quest13_HORDE_Aim = Inst14Quest13_Aim
Inst14Quest13_HORDE_Location = Inst14Quest13_Location
Inst14Quest13_HORDE_Note = Inst14Quest13_Note
Inst14Quest13_HORDE_Prequest = Inst14Quest13_Prequest
Inst14Quest13_HORDE_Folgequest = Inst14Quest13_Folgequest
-- No Rewards for this quest

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst14Quest14_HORDE = Inst14Quest14
Inst14Quest14_HORDE_Aim = Inst14Quest14_Aim
Inst14Quest14_HORDE_Location = Inst14Quest14_Location
Inst14Quest14_HORDE_Note = Inst14Quest14_Note
Inst14Quest14_HORDE_Prequest = Inst14Quest14_Prequest
Inst14Quest14_HORDE_Folgequest = Inst14Quest14_Folgequest
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst14Quest15_HORDE = Inst14Quest15
Inst14Quest15_HORDE_Aim = Inst14Quest15_Aim
Inst14Quest15_HORDE_Location = Inst14Quest15_Location
Inst14Quest15_HORDE_Note = Inst14Quest15_Note
Inst14Quest15_HORDE_Prequest = Inst14Quest15_Prequest
Inst14Quest15_HORDE_Folgequest = Inst14Quest15_Folgequest
--
Inst14Quest15name1_HORDE = Inst14Quest15name1
Inst14Quest15name2_HORDE = Inst14Quest15name2
Inst14Quest15name3_HORDE = Inst14Quest15name3
Inst14Quest15name4_HORDE = Inst14Quest15name4

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst14Quest16_HORDE = Inst14Quest16
Inst14Quest16_HORDE_Aim = Inst14Quest16_Aim
Inst14Quest16_HORDE_Location = Inst14Quest16_Location
Inst14Quest16_HORDE_Note = Inst14Quest16_Note
Inst14Quest16_HORDE_Prequest = Inst14Quest16_Prequest
Inst14Quest16_HORDE_Folgequest = Inst14Quest16_Folgequest
--
Inst14Quest16name1_HORDE = Inst14Quest16name1

--Quest 17 Horde  (same as Quest 17 Alliance)
Inst14Quest17_HORDE = Inst14Quest17
Inst14Quest17_HORDE_Aim = Inst14Quest17_Aim
Inst14Quest17_HORDE_Location = Inst14Quest17_Location
Inst14Quest17_HORDE_Note = Inst14Quest17_Note
Inst14Quest17_HORDE_Prequest = Inst14Quest17_Prequest
Inst14Quest17_HORDE_Folgequest = Inst14Quest17_Folgequest
--
Inst14Quest17name1_HORDE = Inst14Quest17name1

--Quest 18 Horde
Inst14Quest18_HORDE = "18. 람스타인" -- Ramstein
Inst14Quest18_HORDE_Aim = "스트라솔름으로 가서 먹보 람스타인을 처치하고 그 증거로 그의 머리카락을 나타노스에게 가져가야 합니다."
Inst14Quest18_HORDE_Location = "나타노스 블라이트콜러 (동부 역병지대; "..YELLOW.."26.6, 74.8"..WHITE..")"
Inst14Quest18_HORDE_Note = "선행 퀘스트는 나타노스 블라이트콜러에게 받습니다.  먹보 람스타인은 "..YELLOW.."[18]"..WHITE.." 에서 찾을 수 있습니다."
Inst14Quest18_HORDE_Prequest = "순찰대장의 명령 -> 혐오스런 그늘날개"
Inst14Quest18_HORDE_Folgequest = "없음"
--
Inst14Quest18name1_HORDE = "알렉시스의 결혼반지"
Inst14Quest18name2_HORDE = "정기의 고리"

--Quest 19 Horde  (same as Quest 18 Alliance)
Inst14Quest19_HORDE = "19. 빛과 어둠의 균형 (사제)" -- The Balance of Light and Shadow (Priest)
Inst14Quest19_HORDE_Aim = Inst14Quest18_Aim
Inst14Quest19_HORDE_Location = Inst14Quest18_Location
Inst14Quest19_HORDE_Note = Inst14Quest18_Note
Inst14Quest19_HORDE_Prequest = Inst14Quest18_Prequest
Inst14Quest19_HORDE_Folgequest = Inst14Quest18_Folgequest
--
Inst14Quest19name1_HORDE = Inst14Quest18name1



--------------- INST15 - Sunken Temple 가라앉은 사원 ---------------

Inst15Caption = "가라앉은 사원"
Inst15QAA = "16 퀘스트"
Inst15QAH = "16 퀘스트"

--Quest 1 Alliance
Inst15Quest1 = "1. 아탈학카르 신전으로" -- Into The Temple of Atal'Hakkar
Inst15Quest1_Aim = "스톰윈드에 있는 브로한 캐스크벨리에게 아탈라이 서판 10개를 가져가야 합니다."
Inst15Quest1_Location = "브로한 캐스크벨리 (스톰윈드- 드워프 지구; "..YELLOW.."64.2, 20.8"..WHITE..")"
Inst15Quest1_Note = "선행 퀘스트 라인은 동일한 NPC에서 제공되며 꽤 많은 단계가 있습니다.\n\n던전 안밖으로, 사원의 모든 곳에서 서판을 찾을 수 있습니다."
Inst15Quest1_Prequest = "신전을 찾아서 -> 랩소디의 이야기"
Inst15Quest1_Folgequest = "없음"
--
Inst15Quest1name1 = "수호 부적"

--Quest 2 Alliance
Inst15Quest2 = "2. 가라앉은 사원!" -- The Sunken Temple
Inst15Quest2_Aim = "타나리스에서 마본 리벳시커를 찾아야 합니다."
Inst15Quest2_Location = "안젤라스 문브리즈 (페랄라스 - 페더문 요새; "..YELLOW.."31.8, 45.6"..WHITE..")"
Inst15Quest2_Note = "마본 리벳시커는 "..YELLOW.."52.6, 45.8"..WHITE..".에서 찾을 수 있습니다."
Inst15Quest2_Prequest = "없음"
Inst15Quest2_Folgequest = "돌무리"
-- No Rewards for this quest

--Quest 3 Alliance
Inst15Quest3 = "3. 심연의 늪" -- Into the Depths
Inst15Quest3_Aim = "슬픔의 늪에 있는 가라앉은 사원에서 학카르 제단을 찾아야 합니다."
Inst15Quest3_Location = "마본 리벳시커 (타나리스; "..YELLOW.."52.6, 45.8"..WHITE..")"
Inst15Quest3_Note = "제단은 "..YELLOW.."[1]"..WHITE.." 에 있다."
Inst15Quest3_Prequest = "가라앉은 사원 -> 돌무리"
Inst15Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst15Quest4 = "4. 돌무리의 비밀" -- Secret of the Circle
Inst15Quest4_Aim = "가라앉은 사원으로 가서 원 모양으로 서 있는 석상들에 감춰진 비밀을 알아내야 합니다."
Inst15Quest4_Location = "마본 리벳시커 (타나리스; "..YELLOW.."52.6, 45.8"..WHITE..")"
Inst15Quest4_Note = "석상은 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다. 활성화 순서는 지도를 참조하십시오."
Inst15Quest4_Prequest = "가라앉은 사원 -> 돌무리"
Inst15Quest4_Folgequest = "없음"
--
Inst15Quest4name1 = "학카르의 단지"

--Quest 5 Alliance
Inst15Quest5 = "5. 악의 아지랑이" -- Haze of Evil
Inst15Quest5_Aim = "아탈라이 아지랑이 5개를 모은 후 운고로 분화구에 있는 무이긴에게 돌아가야 합니다."
Inst15Quest5_Location = "그레간 브루스퓨 (페랄라스; "..YELLOW.."45.0, 25.4"..WHITE..")"
Inst15Quest5_Note = "선행 퀘스트는 '무이긴과 라라온' 무이긴에서 시작 됩니다. (운고로 분화구 - 마샬의 야영지; "..YELLOW.."43.0, 9.6"..WHITE.."). 사원의 지하껍질괴물, 진흙미늘벌레 또는 괴물에서 아지랑이를 얻을 수 있습니다."
Inst15Quest5_Prequest = "무이긴과 라리온 -> 그레간 방문 "
Inst15Quest5_Folgequest = "없음"
-- No Rewards for this quest

--Quest 6 Alliance
Inst15Quest6 = "6. 학카르의 화신" -- The God Hakkar
Inst15Quest6_Aim = "타나리스에 있는 예킨야에게 충만한 학카르의 알을 가져가야 합니다."
Inst15Quest6_Location = "예킨야 (타나리스 - 스팀휘들 항구; "..YELLOW.."67.0, 22.4"..WHITE..")"
Inst15Quest6_Note = "퀘스트 라인은 같은 NPC에 '계곡천둥매의 영혼' 으로 시작됩니다. ("..YELLOW.."[줄파락]"..WHITE.." 참조).\n이벤트를 시작하려면 알을 "..YELLOW.."[3]"..WHITE.." 사용해야 합니다.  그것이 시작되면 적들이 소환 되어 공격합니다.  그들 중 일부는 학카르의 피를 떨어뜨린다.  이 피를 사용하면 원 주위에 횃불을 끌수 있습니다.  이 후 학카르의 화신이 소환 됩니다.  그를 죽이고 알을 채울수 있는 '학카르의 정수'를 획득합니다."
Inst15Quest6_Prequest = "계곡천둥매의 영혼 -> 고대의 알"
Inst15Quest6_Folgequest = "없음"
--
Inst15Quest6name1 = "아방가드 투구"
Inst15Quest6name2 = "생명력의 단검"
Inst15Quest6name3 = "금은보석 머리장식"
Inst15Quest6name4 = "학카르의 정수"

--Quest 7 Alliance
Inst15Quest7 = "7. 예언자 잠말란" -- Jammal'an the Prophet
Inst15Quest7_Aim = "잠말란을 처치하고 그 증거로 그의 머리카락을 동부 내륙지에 있는 추방된 아탈라이트롤에게 가져가야 합니다."
Inst15Quest7_Location = "추방된 아탈라이트롤 (동부 내륙지; "..YELLOW.."33.6, 75.2"..WHITE..")"
Inst15Quest7_Note = "잠말란은 "..YELLOW.."[4]"..WHITE.." 에서 찾을 수 있습니다."
Inst15Quest7_Prequest = "없음"
Inst15Quest7_Folgequest = "없음"
--
Inst15Quest7name1 = "폭우의 다리보호구"
Inst15Quest7name2 = "추방자의 투구"

--Quest 8 Alliance
Inst15Quest8 = "8. 에라니쿠스의 정수!" -- The Essence of Eranikus
Inst15Quest8_Aim = "슬픔의 늪에 있는 이타리우스에게 이세라 용군단의 서약의 돌과 속박된 에라니쿠스의 정수를 가져가야 합니다. 이세라의 용군단을 도울 것인지 돕지 않을 것인지는 그곳에서 결정하게 됩니다."
Inst15Quest8_Location = "에라니쿠스의 정수 (에라니쿠스의 사령; "..YELLOW.."[6]"..WHITE..")"
Inst15Quest8_Note = "에라니쿠스의 사령 옆에 정수의 샘을 찾을 수 있습니다. "..YELLOW.."[6]"..WHITE.."."
Inst15Quest8_Prequest = "없음"
Inst15Quest8_Folgequest = "에라니쿠스의 정수"
--
Inst15Quest8name1 = "속박된 에라니쿠스의 정수"

--Quest 9 Alliance
Inst15Quest9 = "9. 트롤의 깃털" -- Trolls of a Feather
Inst15Quest9_Aim = "가라앉은 사원에 있는 트롤의 부두 깃털 6개를 가져가야 합니다."
Inst15Quest9_Location = "임프시 (악령의 숲; "..YELLOW.."41.6, 45.0"..WHITE..")"
Inst15Quest9_Note = "흑마법사 퀘스트.  중앙에 구멍이 있는 큰 방이 내려다 보이는 난간에 이름이 있는 트롤에서 각각 깃털이 드랍합니다."
Inst15Quest9_Prequest = "임프의 부탁 -> 인형 재료"
Inst15Quest9_Folgequest = "없음"
--
Inst15Quest9name1 = "영혼 수확기"
Inst15Quest9name2 = "나락의 조각"
Inst15Quest9name3 = "예속의 로브"

--Quest 10 Alliance
Inst15Quest10 = "10. 부두 깃털" -- Voodoo Feathers
Inst15Quest10_Aim = "호드 영웅의 넋에게 가라앉은 사원에 있는 트롤들에게서 황색 부두 깃털, 청색 부두 깃털, 녹색 부두 깃털을 빼앗아 각 2개씩 가져가야 합니다."
Inst15Quest10_Location = "호드 영웅의 넋 (슬픔의 늪; "..YELLOW.."34.2, 66.0"..WHITE..")"
Inst15Quest10_Note = "전사 퀘스트.  중앙에 구멍이 있는 큰 방이 내려다 보이는 난간에 이름이 있는 트롤에서 각각 깃털이 드랍합니다."
Inst15Quest10_Prequest = "영혼이 된 영웅의 고통 -> 어둠의혈맹과의 전쟁"
Inst15Quest10_Folgequest = "없음"
--
Inst15Quest10name1 = "맹위의 면갑"
Inst15Quest10name2 = "다이아몬드 물통"
Inst15Quest10name3 = "서승강철 어깨보호구"

--Quest 11 Alliance
Inst15Quest11 = "11. 더욱 강력한 재료" -- A Better Ingredient
Inst15Quest11_Aim = "가라앉은 사원 하층부의 수호병으로부터 썩은 덩굴을 찾은 후 토르와 패스파인더에게 돌아가야 합니다."
Inst15Quest11_Location = "토르와 패스파인더 (운고로 분화구; "..YELLOW.."71.6, 76.0"..WHITE..")"
Inst15Quest11_Note = "드루이드 퀘스트.  썩은 덩굴은 지도에 "..YELLOW.."[1]"..WHITE.." 나열된 순서대로 석상을 활성화하여 소환 된 아탈알라리온에서 드랍합니다."
Inst15Quest11_Prequest = "붉은꽃잎 독 -> 독성 테스트"
Inst15Quest11_Folgequest = "없음"
--
Inst15Quest11name1 = "불곰 모피 조끼"
Inst15Quest11name2 = "숲의 은총"
Inst15Quest11name3 = "달그림자 지팡이"

--Quest 12 Alliance
Inst15Quest12 = "12. 녹색 비룡 몰파즈" -- The Green Drake
Inst15Quest12_Aim = "아즈샤라에 엘다라스 폐허의 북동쪽 절벽 꼭대기에 있는 오그틴크에게 몰파즈의 이빨을 가져가야 합니다."
Inst15Quest12_Location = "Ogtinc (아즈샤라; "..YELLOW.."42.2, 42.6"..WHITE..")"
Inst15Quest12_Note = "사냥꾼 퀘스트.  몰파즈는 "..YELLOW.."[5]"..WHITE.." 에 있다."
Inst15Quest12_Prequest = "순록 뿔 -> 폭풍히드라 사냥"
Inst15Quest12_Folgequest = "없음"
--
Inst15Quest12name1 = "사냥용 창"
Inst15Quest12name2 = "데빌사우루스 눈"
Inst15Quest12name3 = "데빌사우루스 이빨"

--Quest 13 Alliance
Inst15Quest13 = "13. 몰파즈 처치" -- Destroy Morphaz
Inst15Quest13_Aim = "몰파즈에게서 신비의 결정을 되찾아 대마법사 실렘에게 가져가야 합니다."
Inst15Quest13_Location = "대마법사 실렘 (아즈샤라; "..YELLOW.."29.6, 40.6"..WHITE..")"
Inst15Quest13_Note = "마법사 퀘스트.  몰파즈는 "..YELLOW.."[5]"..WHITE.." 에 있다."
Inst15Quest13_Prequest = "마법의 티끌 -> 세이렌의 산호"
Inst15Quest13_Folgequest = "없음"
--
Inst15Quest13name1 = "혹한의 쐐기"
Inst15Quest13name2 = "신비의 수정 목걸이"
Inst15Quest13name3 = "화염 루비"

--Quest 14 Alliance
Inst15Quest14 = "14. 몰파즈의 피" -- Blood of Morphaz
Inst15Quest14_Aim = "아탈학카르 신전에서 몰파즈를 처치하고 그의 피를 악령의 숲에 있는 그레타 모스후프에게 가져다주어야 합니다. 가라앉은 신전의 입구는 슬픔의 늪에 있습니다."
Inst15Quest14_Location = "오그틴크 (아즈샤라; "..YELLOW.."42.2, 42.6"..WHITE..")"
Inst15Quest14_Note = "사제 퀘스트.  몰파즈는 "..YELLOW.."[5]"..WHITE.." 에 있다.  그레타 모스후프에 있다. (악령의 숲 - 에메랄드 성소; "..YELLOW.."51.2, 82.2"..WHITE..")."
Inst15Quest14_Prequest = "순록을 찾아서 -> 불사의 영액"
Inst15Quest14_Folgequest = "없음"
--
Inst15Quest14name1 = "축복받은 기원의 묵주"
Inst15Quest14name2 = "재앙의 마법봉"
Inst15Quest14name3 = "희망의 고리"

--Quest 15 Alliance
Inst15Quest15 = "15. 하늘색 열쇠" -- The Azure Key
Inst15Quest15_Aim = "조라크 라벤홀트 경에게 하늘색 열쇠를 가져가야 합니다."
Inst15Quest15_Location = "대마법사 실렘 (아즈샤라; "..YELLOW.."29.6, 40.6"..WHITE..")"
Inst15Quest15_Note = "도적 퀘스트.  몰파즈에서 "..YELLOW.."[5]"..WHITE.." 하늘색 열쇠가 드랍합니다.  조라크 라벤홀트 경은 알터랙 산맥 - 라벤홀트 장원에 있다. ("..YELLOW.."86.0, 79.0"..WHITE..")."
Inst15Quest15_Prequest = "봉인된 하늘색 자루 -> 암호화된 페이지"
Inst15Quest15_Folgequest = "없음"
--
Inst15Quest15name1 = "흑단 복면"
Inst15Quest15name2 = "침묵의 장화"
Inst15Quest15name3 = "그늘박쥐 망토"

--Quest 16 Alliance
Inst15Quest16 = "16. 퇴마석 만들기" -- Forging the Mightstone
Inst15Quest16_Aim = "부두 깃털을 아쉬람 발러피스트에게 가져 가십시오."
Inst15Quest16_Location = "사령관 아쉬람 발러피스트 (서부 역병지대 - 서리바람 야영지; "..YELLOW.."42.8, 84.0"..WHITE..")"
Inst15Quest16_Note = "성기사 퀘스트.  중앙에 구멍이 있는 큰 방이 내려다 보이는 난간에 이름이 있는 트롤에서 각각 깃털이 드랍합니다."
Inst15Quest16_Prequest = "악마 퇴치 -> 마력을 잃은 스컬지석"
Inst15Quest16_Folgequest = "없음"
--
Inst15Quest16name1 = "신성한 퇴마석"
Inst15Quest16name2 = "빛의 검"
Inst15Quest16name3 = "축성의 보주"
Inst15Quest16name4 = "기사단 인장"


--Quest 1 Horde
Inst15Quest1_HORDE = "1. 아탈학카르 신전" -- The Temple of Atal'Hakkar
Inst15Quest1_HORDE_Aim = "스토나드에 있는 펠제룰에게 학카르의 우상 20개를 가져가야 합니다."
Inst15Quest1_HORDE_Location = "펠제룰 (슬픔의 늪 - 스토나드; "..YELLOW.."48.0, 55.0"..WHITE..")"
Inst15Quest1_HORDE_Note = "사원의 모든 몬스터들은 우상을 드랍합니다."
Inst15Quest1_HORDE_Prequest = "눈물의 연못 -> 펠제룰에게 돌아가기"
Inst15Quest1_HORDE_Folgequest = "없음"
--
Inst15Quest1name1_HORDE = "수호 부적"

--Quest 2 Horde
Inst15Quest2_HORDE = "2. 가라앉은 사원" -- The Sunken Temple
Inst15Quest2_HORDE_Aim = "타나리스에서 마본 리벳시커를 찾아야 합니다."
Inst15Quest2_HORDE_Location = "의술사 우제리 (페랄라스; "..YELLOW.."74.4, 43.4"..WHITE..")"
Inst15Quest2_HORDE_Note = "마본 리벳시커는 "..YELLOW.."52.6, 45.8"..WHITE.." 에서 찾을 수 있습니다."
Inst15Quest2_HORDE_Prequest = "없음"
Inst15Quest2_HORDE_Folgequest = "돌무리"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst15Quest3_HORDE = Inst15Quest3
Inst15Quest3_HORDE_Aim = Inst15Quest3_Aim
Inst15Quest3_HORDE_Location = Inst15Quest3_Location
Inst15Quest3_HORDE_Note = Inst15Quest3_Note
Inst15Quest3_HORDE_Prequest = Inst15Quest3_Prequest
Inst15Quest3_HORDE_Folgequest = Inst15Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst15Quest4_HORDE = Inst15Quest4
Inst15Quest4_HORDE_Aim = Inst15Quest4_Aim
Inst15Quest4_HORDE_Location = Inst15Quest4_Location
Inst15Quest4_HORDE_Note = Inst15Quest4_Note
Inst15Quest4_HORDE_Prequest = Inst15Quest4_Prequest
Inst15Quest4_HORDE_Folgequest = Inst15Quest4_Folgequest
--
Inst15Quest4name1_HORDE = Inst15Quest4name1

--Quest 5 Horde
Inst15Quest5_HORDE = "5. 구제장치 연료" -- Zapper Fuel
Inst15Quest5_HORDE_Aim = "마샬의 야영지에 있는 라리온에게 충전 안된 구제장치와 아탈라이 아지랑이 5개를 가져가야 합니다."
Inst15Quest5_HORDE_Location = "리브 리즐픽스 (불모의 땅; "..YELLOW.."62.4, 38.6"..WHITE..")"
Inst15Quest5_HORDE_Note = "선행 퀘스트는 '무이긴과 라라온' 라리온에서 시작 됩니다. (운고로 분화구; "..YELLOW.."45.6, 8.6"..WHITE..").  사원의 지하껍질괴물, 진흙미늘벌레 또는 괴물에서 아지랑이를 얻을 수 있습니다."
Inst15Quest5_HORDE_Prequest = "라리온과 무이긴 -> 마본의 작업장"
Inst15Quest5_HORDE_Folgequest = "없음"

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst15Quest6_HORDE = Inst15Quest6
Inst15Quest6_HORDE_Aim = Inst15Quest6_Aim
Inst15Quest6_HORDE_Location = Inst15Quest6_Location
Inst15Quest6_HORDE_Note = Inst15Quest6_Note
Inst15Quest6_HORDE_Prequest = Inst15Quest6_Prequest
Inst15Quest6_HORDE_Folgequest = Inst15Quest6_Folgequest
--
Inst15Quest6name1_HORDE = Inst15Quest6name1
Inst15Quest6name2_HORDE = Inst15Quest6name2
Inst15Quest6name3_HORDE = Inst15Quest6name3
Inst15Quest6name4_HORDE = Inst15Quest6name4

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst15Quest7_HORDE = Inst15Quest7
Inst15Quest7_HORDE_Aim = Inst15Quest7_Aim
Inst15Quest7_HORDE_Location = Inst15Quest7_Location
Inst15Quest7_HORDE_Note = Inst15Quest7_Note
Inst15Quest7_HORDE_Prequest = Inst15Quest7_Prequest
Inst15Quest7_HORDE_Folgequest = Inst15Quest7_Folgequest
--
Inst15Quest7name1_HORDE = Inst15Quest7name1
Inst15Quest7name2_HORDE = Inst15Quest7name2

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst15Quest8_HORDE = Inst15Quest8
Inst15Quest8_HORDE_Aim = Inst15Quest8_Aim
Inst15Quest8_HORDE_Location = Inst15Quest8_Location
Inst15Quest8_HORDE_Note = Inst15Quest8_Note
Inst15Quest8_HORDE_Prequest = Inst15Quest8_Prequest
Inst15Quest8_HORDE_Folgequest = Inst15Quest8_Folgequest
--
Inst15Quest8name1_HORDE = Inst15Quest8name1

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst15Quest9_HORDE = Inst15Quest9
Inst15Quest9_HORDE_Aim = Inst15Quest9_Aim
Inst15Quest9_HORDE_Location = Inst15Quest9_Location
Inst15Quest9_HORDE_Note = Inst15Quest9_Note
Inst15Quest9_HORDE_Prequest = Inst15Quest9_Prequest
Inst15Quest9_HORDE_Folgequest = Inst15Quest9_Folgequest
--
Inst15Quest9name1_HORDE = Inst15Quest9name1
Inst15Quest9name2_HORDE = Inst15Quest9name2
Inst15Quest9name3_HORDE = Inst15Quest9name3

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst15Quest10_HORDE = Inst15Quest10
Inst15Quest10_HORDE_Aim = Inst15Quest10_Aim
Inst15Quest10_HORDE_Location = Inst15Quest10_Location
Inst15Quest10_HORDE_Note = Inst15Quest10_Note
Inst15Quest10_HORDE_Prequest = Inst15Quest10_Prequest
Inst15Quest10_HORDE_Folgequest = Inst15Quest10_Folgequest
--
Inst15Quest10name1_HORDE = Inst15Quest10name1
Inst15Quest10name2_HORDE = Inst15Quest10name2
Inst15Quest10name3_HORDE = Inst15Quest10name3

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst15Quest11_HORDE = Inst15Quest11
Inst15Quest11_HORDE_Aim = Inst15Quest11_Aim
Inst15Quest11_HORDE_Location = Inst15Quest11_Location
Inst15Quest11_HORDE_Note = Inst15Quest11_Note
Inst15Quest11_HORDE_Prequest = Inst15Quest11_Prequest
Inst15Quest11_HORDE_Folgequest = Inst15Quest11_Folgequest
--
Inst15Quest11name1_HORDE = Inst15Quest11name1
Inst15Quest11name2_HORDE = Inst15Quest11name2
Inst15Quest11name3_HORDE = Inst15Quest11name3

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst15Quest12_HORDE = Inst15Quest12
Inst15Quest12_HORDE_Aim = Inst15Quest12_Aim
Inst15Quest12_HORDE_Location = Inst15Quest12_Location
Inst15Quest12_HORDE_Note = Inst15Quest12_Note
Inst15Quest12_HORDE_Prequest = Inst15Quest12_Prequest
Inst15Quest12_HORDE_Folgequest = Inst15Quest12_Folgequest
--
Inst15Quest12name1_HORDE = Inst15Quest12name1
Inst15Quest12name2_HORDE = Inst15Quest12name2
Inst15Quest12name3_HORDE = Inst15Quest12name3

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst15Quest13_HORDE = Inst15Quest13
Inst15Quest13_HORDE_Aim = Inst15Quest13_Aim
Inst15Quest13_HORDE_Location = Inst15Quest13_Location
Inst15Quest13_HORDE_Note = Inst15Quest13_Note
Inst15Quest13_HORDE_Prequest = Inst15Quest13_Prequest
Inst15Quest13_HORDE_Folgequest = Inst15Quest13_Folgequest
--
Inst15Quest13name1_HORDE = Inst15Quest13name1
Inst15Quest13name2_HORDE = Inst15Quest13name2
Inst15Quest13name3_HORDE = Inst15Quest13name3

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst15Quest14_HORDE = Inst15Quest14
Inst15Quest14_HORDE_Aim = Inst15Quest14_Aim
Inst15Quest14_HORDE_Location = Inst15Quest14_Location
Inst15Quest14_HORDE_Note = Inst15Quest14_Note
Inst15Quest14_HORDE_Prequest = Inst15Quest14_Prequest
Inst15Quest14_HORDE_Folgequest = Inst15Quest14_Folgequest
--
Inst15Quest14name1_HORDE = Inst15Quest14name1
Inst15Quest14name2_HORDE = Inst15Quest14name2
Inst15Quest14name3_HORDE = Inst15Quest14name3

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst15Quest15_HORDE = Inst15Quest15
Inst15Quest15_HORDE_Aim = Inst15Quest15_Aim
Inst15Quest15_HORDE_Location = Inst15Quest15_Location
Inst15Quest15_HORDE_Note = Inst15Quest15_Note
Inst15Quest15_HORDE_Prequest = Inst15Quest15_Prequest
Inst15Quest15_HORDE_Folgequest = Inst15Quest15_Folgequest
--
Inst15Quest15name1_HORDE = Inst15Quest15name1
Inst15Quest15name2_HORDE = Inst15Quest15name2
Inst15Quest15name3_HORDE = Inst15Quest15name3

--Quest 16 Horde
Inst15Quest16_HORDE = "16. 부두교 마법" -- Da Voodoo
Inst15Quest16_HORDE_Aim = "바람의감시자 바스라에게 부두 깃털들을 가져가야 합니다.알터랙 산맥의 서리바람 거점에 있는 바람의감시자 바스라에게 가야 합니다."
Inst15Quest16_HORDE_Location = "바람의감시자 바스라 (알터랙 산맥; "..YELLOW.."80.4, 66.8"..WHITE..")"
Inst15Quest16_HORDE_Note = "주술사 퀘스트.  중앙에 구멍이 있는 큰 방이 내려다 보이는 난간에 이름이 있는 트롤에서 각각 깃털이 드랍합니다."
Inst15Quest16_HORDE_Prequest = "원소에 대한 깨달음 -> 정기의 토템"
Inst15Quest16_HORDE_Folgequest = "없음"
--
Inst15Quest16name1_HORDE = "아주라이트 장갑"
Inst15Quest16name2_HORDE = "사로잡힌 물의 정령"
Inst15Quest16name3_HORDE = "광야의 지팡이"



--------------- INST16 - Uldaman 울다만 ---------------

Inst16Caption = "울다만"
Inst16QAA = "17 퀘스트"
Inst16QAH = "11 퀘스트"

--Quest 1 Alliance
Inst16Quest1 = "1. 희망의 전조 (2)" -- A Sign of Hope
Inst16Quest1_Aim = "울다만에서 해머토 그레즈를 찾아야 합니다."
Inst16Quest1_Location = "발굴조사단장 라이돌 (황야의 땅; "..YELLOW.."53.4, 43.2"..WHITE..")"
Inst16Quest1_Note = "선행 퀘스트는 구겨진 지도에서 시작됩니다. (황야의 땅; "..YELLOW.."53.0, 34.1"..WHITE..").\n던전의 정문에 들어가기 전에 입구 지도 지역에서 해머토 그레즈를 "..YELLOW.."[1]"..WHITE.." 찾을 수 있습니다."
Inst16Quest1_Prequest = "희망의 전조"
Inst16Quest1_Folgequest = "비밀의 아뮬렛"
-- No Rewards for this quest

--Quest 2 Alliance
Inst16Quest2 = "2. 비밀의 아뮬렛" -- Amulet of Secrets
Inst16Quest2_Aim = "해머토의 아뮬렛을 찾아 울다만에 있는 해머토에게 가져가야 합니다."
Inst16Quest2_Location = "해머토 그레즈 (울다만; "..YELLOW.."입구 공간[1]"..WHITE..")."
Inst16Quest2_Note = "던전의 정문에 들어가기 전에 해당 지역에 있는 마그레간 딥섀도가 "..YELLOW.."[2 이동함]"..WHITE.." 아뮬렛을 드랍합니다."
Inst16Quest2_Prequest = "희망의 전조 (2)"
Inst16Quest2_Folgequest = "돈독한 믿음"
-- No Rewards for this quest

--Quest 3 Alliance
Inst16Quest3 = "3. 잃어버린 결의의 서판" -- The Lost Tablets of Will
Inst16Quest3_Aim = "결의의 서판을 찾아 아이언포지에 있는 조언자 벨그룸에게 가져가야 합니다."
Inst16Quest3_Location = "조언자 벨그룸 (아이언포지 - 탐험가의 전당; "..YELLOW.."77.2, 10.0"..WHITE..")"
Inst16Quest3_Note = "서판은 "..YELLOW.."[8]"..WHITE.." 에 있다."
Inst16Quest3_Prequest = "비밀의 아뮬렛 -> 악의 사자"
Inst16Quest3_Folgequest = "없음"
--
Inst16Quest3name1 = "용맹의 메달"

--Quest 4 Alliance
Inst16Quest4 = "4. 마법석" -- Power Stones
Inst16Quest4_Aim = "황야의 땅에 있는 리글퍼즈에게 덴트리움 마법석 8개와 안알레움 마법석 8개를 가져가야 합니다."
Inst16Quest4_Location = "리글퍼즈 (황야의 땅; "..YELLOW.."42.4, 52.8"..WHITE..")"
Inst16Quest4_Note = "마법석은 던전 입구와 던전안에 있는 모든 어둠괴철로단에게서 얻을 수 있습니다."
Inst16Quest4_Prequest = "없음"
Inst16Quest4_Folgequest = "없음"
--
Inst16Quest4name1 = "활력의 돌버클러"
Inst16Quest4name2 = "듀라신 팔보호구"
Inst16Quest4name3 = "불변의 장화"

--Quest 5 Alliance
Inst16Quest5 = "5. 아그몬드의 운명" -- Agmond's Fate
Inst16Quest5_Aim = "모단 호수에 있는 발굴조사단장 아이언밴드에게 돌조각 단지 4개를 가져가야 합니다."
Inst16Quest5_Location = "발굴조사단장 아이언밴드 (모단 호수 - 아이언밴드의 발굴현장; "..YELLOW.."65.8, 65.6"..WHITE..")"
Inst16Quest5_Note = "선행 퀘스트는 발굴조사단장 스톰파이크에서 시작됩니다. (아이언포지 - 탐험가의 전당; "..YELLOW.."74.4, 12.0"..WHITE..").\n돌조각 단지는 던전내, 외부 동굴 전체에 흩어져 있습니다."
Inst16Quest5_Prequest = "아이언밴드의 호출 -> 멀달록"
Inst16Quest5_Folgequest = "없음"
--
Inst16Quest5name1 = "불굴조사단장의 장갑"

--Quest 6 Alliance
Inst16Quest6 = "6. 멸망의 해결책" -- Solution to Doom
Inst16Quest6_Aim = "실성한 텔두린에게 류네의 서판을 가져가야 합니다."
Inst16Quest6_Location = "실성한 텔두린 (황야의 땅; "..YELLOW.."51.4, 76.8"..WHITE..")"
Inst16Quest6_Note = "서판은 동굴 북쪽에, 터널의 동쪽 끝에, 던전 앞에 있다."..YELLOW.."[3]"..WHITE..""
Inst16Quest6_Prequest = "없음"
Inst16Quest6_Folgequest = "야그인의 법전을 찾아서"
--
Inst16Quest6name1 = "종말론자의 로브"

--Quest 7 Alliance
Inst16Quest7 = "7. 길 잃은 드워프" -- The Lost Dwarves
Inst16Quest7_Aim = "울다만에서 밸로그를 찾아야 합니다"
Inst16Quest7_Location = "발굴조사단장 스톰파이크 (아이언포지 - 탐험가의 전당; "..YELLOW.."74.4, 12.0"..WHITE..")"
Inst16Quest7_Note = "밸로그는 "..YELLOW.."[1]"..WHITE.." 에 있다."
Inst16Quest7_Prequest = "없음"
Inst16Quest7_Folgequest = "비밀 석실"
-- No Rewards for this quest

--Quest 8 Alliance
Inst16Quest8 = "8. 비밀 석실" -- The Hidden Chamber
Inst16Quest8_Aim = "밸로그의 일지를 읽고 비밀 석실을 조사한 후 발굴조사단장 스톰파이크에게 보고해야 합니다."
Inst16Quest8_Location = "밸로그 (울다만; "..YELLOW.."[1]"..WHITE..")"
Inst16Quest8_Note = "비밀 석실은 "..YELLOW.."[4]"..WHITE.." 에 있다.  비밀 석실을 열려면 레벨로쉬 티솔의 자루와 "..YELLOW.."[3]"..WHITE.." 그리고 밸로그의 궤짝에서 그니키브의 메달 "..YELLOW.."[1]"..WHITE.." 이 필요합니다.  이 두 아이템을 합치면 잃어버린 역사의 지팡이 만들수 있습니다.  지팡이는 지도방 "..YELLOW.."[3] 그리고 [4]"..WHITE.." 에서 아이로나야를 소환하는 데 사용 됩니다.  그녀를 죽인 후, 그녀가 나온 방 안으로 들어가면 퀘스트가 완료됩니다."
Inst16Quest8_Prequest = "길 잃은 드워프"
Inst16Quest8_Folgequest = "없음"
--
Inst16Quest8name1 = "드워프족 돌격 도끼"
Inst16Quest8name2 = "탐험가 조합 등불"

--Quest 9 Alliance
Inst16Quest9 = "9. 부서진 목걸이" -- The Shattered Necklace
Inst16Quest9_Aim = "부서진 목걸이의 잠재적 가치를 알아내기 위해 원 제작자를 찾아야 합니다."
Inst16Quest9_Location = "부서진 목걸이 (울다만에서 무작위 드랍)"
Inst16Quest9_Note = "목걸이를 탈바쉬 델 키젤에게 가져 가십시오. (아이언포지 - 마법 지구; "..YELLOW.."36.0, 4.0"..WHITE..")."
Inst16Quest9_Prequest = "없음"
Inst16Quest9_Folgequest = "정보의 대가"
-- No Rewards for this quest

--Quest 10 Alliance
Inst16Quest10 = "10. 울다만으로 돌아가기" -- Back to Uldaman
Inst16Quest10_Aim = "울다만 안에서 탈바쉬의 목걸이의 행방에 대한 단서를 찾아야 합니다. 탈바쉬가 말했던 성기사가 그 단서를 가진 최후의 인물일 것입니다."
Inst16Quest10_Location = "탈바쉬 델 키젤 (아이언포지 - 마법 지구; "..YELLOW.."36.0, 4.0"..WHITE..")"
Inst16Quest10_Note = "성기사는 "..YELLOW.."[2]"..WHITE.." 에 있다."
Inst16Quest10_Prequest = "정보의 대가"
Inst16Quest10_Folgequest = "보석 찾기"
-- No Rewards for this quest

--Quest 11 Alliance
Inst16Quest11 = "11. 보석 찾기" -- Find the Gems
Inst16Quest11_Aim = "울다만에 흩어져 있는 루비, 사파이어, 토파즈를 찾아야 합니다. 모두 찾으면 탈바쉬가 준 수정점 유리병을 사용하여 그에게 연락해야 합니다.일지에 의하면... 루비는 어둠괴철로단 드워프들이 있는 지역에 숨겨져 있습니다.토파즈는 얼라이언스 드워프들이 있는 곳 근처에 트로그 지역에 있는 항아리 중 하나에 숨겨져 있습니다.사파이어는 트로그 대장인 그림로크가 가지고 있습니다."
Inst16Quest11_Location = "성기사의 유해 (울다만; "..YELLOW.."[2]"..WHITE..")"
Inst16Quest11_Note = "보석은 "..YELLOW.."[1]"..WHITE.." 눈에 띄는 항아리에, "..YELLOW.."[8]"..WHITE.." 어둠괴철로단 금고에서, 그리고 "..YELLOW.."[9]"..WHITE.." 그림로크 \n참고: 어둠괴철로단 금고를 열 때 몇명의 몬스터가 소환 됩니다.  탈바쉬의 수정점 유리병을 사용하여 퀘스트를 시작하고 다음 임무를 수행합니다."
Inst16Quest11_Prequest = "울다만으로 돌아가기"
Inst16Quest11_Folgequest = "목걸이 복원"
-- No Rewards for this quest

--Quest 12 Alliance
Inst16Quest12 = "12. 목걸이 복원" -- Restoring the Necklace
Inst16Quest12_Aim = "울다만에서 가장 강력한 피조물을 찾아 부서진 목걸이의 마력원천을 손에 넣은 다음, 아이언포지에 있는 탈바쉬 델 키젤에게 목걸이와 함께 가져가야 합니다."
Inst16Quest12_Location = "탈바쉬의 수정점 그릇"
Inst16Quest12_Note = "부서진 목걸이의 마력원천은 아카에다스에서 드랍합니다. "..YELLOW.."[10]"..WHITE..".  탈바쉬 델 키젤는 (아이언포지 - 마법 지구; "..YELLOW.."36.0, 4.0"..WHITE..") 에 있다."
Inst16Quest12_Prequest = "보석 찾기"
Inst16Quest12_Folgequest = "없음"
--
Inst16Quest12name1 = "탈바쉬의 마법 목걸이"

--Quest 13 Alliance
Inst16Quest13 = "13. 울다만에서 재료 찾기" -- Uldaman Reagent Run
Inst16Quest13_Aim = "텔사마에 있는 가크 힐터치에게 자홍버섯 12개를 가져가야 합니다."
Inst16Quest13_Location = "가크 힐터치 (모단 호수 - 텔사마; "..YELLOW.."37.0, 49.2"..WHITE..")"
Inst16Quest13_Note = "버섯은 던전 전체에 흩어져 있습니다.  약초채집가가 약초 찾기 켜고 있고 퀘스트를 가지고 있다면 미니맵에서 그것을 볼 수 있습니다.  선행 퀘스트는 동일한 NPC에서 받습니다."
Inst16Quest13_Prequest = "황야의 땅에서 재료 찾기"
Inst16Quest13_Folgequest = "없음"
--
Inst16Quest13name1 = "복원의 물약"

--Quest 14 Alliance
Inst16Quest14 = "14. 보물 찾기" -- Reclaimed Treasures
Inst16Quest14_Aim = "울다만의 북쪽 대전당에 있는 궤짝에서 크롬 스타우트암의 보물을 찾아서 아이언포지에 있는 크롬 스타우트암에게 가져다주어야 합니다."
Inst16Quest14_Location = "크롬 스타우트암 (아이언포지 - 탐험가의 전당; "..YELLOW.."74.2, 9.8"..WHITE..")"
Inst16Quest14_Note = "던전에 들어가기 전에 보물을 찾을 수 있습니다.  그것은 동굴의 북쪽, 첫 번째 터널의 남동쪽 끝에 있습니다. "..YELLOW.."[4]"..WHITE.."."
Inst16Quest14_Prequest = "없음"
Inst16Quest14_Folgequest = "없음"
-- No Rewards for this quest

--Quest 15 Alliance
Inst16Quest15 = "15. 백금 원반" -- The Platinum Discs
Inst16Quest15_Aim = "바위감시자와 대화하고 그가 알고 있는 고대의 지식을 배우십시오. 지식을 배운 후에는 노르간논의 원반을 가동하십시오. -> 노르간논의 소형 백금 원반을 아이언포지 탐험가의 전당으로 가져 가십시오."
Inst16Quest15_Location = "노르간논의 원반 (울다만; "..YELLOW.."[11]"..WHITE..")"
Inst16Quest15_Note = "퀘스트를 받은 후, 디스크 왼쪽에 있는 돌 관찰자에게 말하십시오.  그런 다음 백금 원반을 다시 사용하여 소형 원반을 받으십시오.  소형 원반을 선임탐험가 마겔라스에게 가져가야 합니다. (아이언포지 - 탐험가의 전당; "..YELLOW.."69.8, 18.4"..WHITE..").  다음은 근처에 있는 다른 NPC에게 시작합니다."
Inst16Quest15_Prequest = "없음"
Inst16Quest15_Folgequest = "울둠의 전조"
--
Inst16Quest15name1 = "완화의 자루"
Inst16Quest15name2 = "최상급 치유 물약"
Inst16Quest15name3 = "상급 마나 물약"

--Quest 16 Alliance
Inst16Quest16 = "16. 울다만의 마력원천" -- Power in Uldaman
Inst16Quest16_Aim = "흑요석 마력원천을 구해서 먼지진흙 습지대에 있는 타베사에게 가져가야 합니다."
Inst16Quest16_Location = "타베사 (먼지진흙 습지대; "..YELLOW.."46.0, 57.0"..WHITE..")"
Inst16Quest16_Note = "마법사 퀘스트.  흑요석 마력원천은 흑요석 파수꾼 "..YELLOW.."[5]"..WHITE.." 에서 드랍합니다."
Inst16Quest16_Prequest = "악마 퇴치"
Inst16Quest16_Folgequest = "마력의 폭풍"
-- No Rewards for this quest

--Quest 17 Alliance
Inst16Quest17 = "17. 인듀리움 광석" -- Indurium Ore
Inst16Quest17_Aim = "황야의 땅에 있는 망명자 마르텍에게 인듀리움 조각 10개를 가져가야 합니다."
Inst16Quest17_Location = "포직 (버섯구름 봉우리 - 신기루 경주장; "..YELLOW.."80.0, 75.8"..WHITE..")"
Inst16Quest17_Note = "선행 퀘스트를 완료후 반복 가능한 퀘스트입니다.  그것은 평판이나 경험치를 주지 않고, 단지 적은 양의 돈을 준다.  인듀리움 광석은 울다만 안에서 채굴하거나 다른 플레이어에게 구입할 수 있습니다. \n참고: 망명자 마르텍 퀘스트를 받으려면 위즐 블라스볼츠가 주는 단단한 등껍질 퀘스트를 완료 해야 합니다."
Inst16Quest17_Prequest = "소금기 있는 전갈 독 -> 망명자 마르텍"
Inst16Quest17_Folgequest = "없음"
-- No Rewards for this quest



--Quest 1 Horde  (same as Quest 4 Alliance)
Inst16Quest1_HORDE = "1. 마법석" -- Power Stones
Inst16Quest1_HORDE_Aim = Inst16Quest4_Aim
Inst16Quest1_HORDE_Location = Inst16Quest4_Location
Inst16Quest1_HORDE_Note = Inst16Quest4_Note
Inst16Quest1_HORDE_Prequest = Inst16Quest4_Prequest
Inst16Quest1_HORDE_Folgequest = Inst16Quest4_Folgequest
--
Inst16Quest1name1_HORDE = Inst16Quest4name1
Inst16Quest1name2_HORDE = Inst16Quest4name2
Inst16Quest1name3_HORDE = Inst16Quest4name3

--Quest 2 Horde  (same as Quest 6 Alliance - different followup)
Inst16Quest2_HORDE = "2. 멸망의 해결책" -- Solution to Doom
Inst16Quest2_HORDE_Aim = Inst16Quest6_Aim
Inst16Quest2_HORDE_Location = Inst16Quest6_Location
Inst16Quest2_HORDE_Note = Inst16Quest6_Note
Inst16Quest2_HORDE_Prequest = Inst16Quest6_Prequest
Inst16Quest2_HORDE_Folgequest = "야그인의 법전을 찾아서"
--
Inst16Quest2name1_HORDE = Inst16Quest6name1

--Quest 3 Horde
Inst16Quest3_HORDE = "3. 목걸이 회수" -- Necklace Recovery
Inst16Quest3_HORDE_Aim = "울다만 발굴 현장에서 값진 목걸이를 찾아 오그리마에 있는 드란 드로퍼스에게 가져다주어야 합니다. 목걸이는 파손된 것이라도 괜찮습니다."
Inst16Quest3_HORDE_Location = "드란 드로퍼스 (오그리마 - 골목길; "..YELLOW.."59.4, 36.8"..WHITE..")"
Inst16Quest3_HORDE_Note = "목걸이는 던전에서 무작위로 드랍합니다."
Inst16Quest3_HORDE_Prequest = "없음"
Inst16Quest3_HORDE_Folgequest = "목걸이 회수 (2)"
-- No Rewards for this quest

--Quest 4 Horde
Inst16Quest4_HORDE = "4. 목걸이 회수 (2)" -- Necklace Recovery, Take 2
Inst16Quest4_HORDE_Aim = "울다만 깊은 곳에서 보석의 행방에 대한 단서를 찾아야 합니다."
Inst16Quest4_HORDE_Location = "드란 드로퍼스 (오그리마 - 골목길; "..YELLOW.."59.4, 36.8"..WHITE..")"
Inst16Quest4_HORDE_Note = "성기사는 "..YELLOW.."[2]"..WHITE.." 에 있다."
Inst16Quest4_HORDE_Prequest = "목걸이 회수"
Inst16Quest4_HORDE_Folgequest = "일지 번역"
-- No Rewards for this quest

--Quest 5 Horde
Inst16Quest5_HORDE = "5. 일지 번역" -- Translating the Journal
Inst16Quest5_HORDE_Aim = "성기사의 일지를 번역할 수 있는 이를 찾아야 합니다. 그런 자가 있을만한 가장 가까운 곳은 황야의 땅에 있는 카르가스입니다."
Inst16Quest5_HORDE_Location = "성기사의 유해 (울다만; "..YELLOW.."[2]"..WHITE..")"
Inst16Quest5_HORDE_Note = "자칼 모스멜드는  (황야의 땅 - 카르가스; "..YELLOW.."2.6, 46.0"..WHITE..") 에 있다."
Inst16Quest5_HORDE_Prequest = "목걸이 회수 (2)"
Inst16Quest5_HORDE_Folgequest = "보석과 마력원천 찾기"
-- No Rewards for this quest

--Quest 6 Horde
Inst16Quest6_HORDE = "6. 보석과 마력원천 찾기" -- Find the Gems and Power Source
Inst16Quest6_HORDE_Aim = "울다만에서 목걸이에 필요한 보석 3개와 마력원천을 회수한 후 카르가스에 있는 자칼 모스멜드에게 가져다주어야 합니다. 자칼의 말에 의하면 울다만에서 가장 강한 피조물을 처치하면 마력원천을 얻을 수 있다고 합니다.일지의 내용을 보니 루비는 어둠괴철로단의 방어진에 숨겨져 있습니다.토파즈는 얼라이언스 드워프 근처에 있는..."
Inst16Quest6_HORDE_Location = "자칼 모스멜드 (황야의 땅 - 카르가스; "..YELLOW.."2.6, 46.0"..WHITE..")"
Inst16Quest6_HORDE_Note = "보석은 "..YELLOW.."[1]"..WHITE.." 눈에 띄는 항아리에, "..YELLOW.."[8]"..WHITE.." 어둠괴철로단 금고에서, 그리고 "..YELLOW.."[9]"..WHITE.." 그림로크.  \n참고: 어둠괴철로단 금고를 열 때 몇명의 몬스터가 소환 됩니다.  부서진 목걸이의 마력원천은 아카에다스에서 드랍합니다. "..YELLOW.."[10]"..WHITE.."."
Inst16Quest6_HORDE_Prequest = "일지 번역"
Inst16Quest6_HORDE_Folgequest = "보석 전달"
--
Inst16Quest6name1_HORDE = "자킬의 마법 목걸이"

--Quest 7 Horde
Inst16Quest7_HORDE = "7. 울다만에서 재료 찾기" -- Uldaman Reagent Run
Inst16Quest7_HORDE_Aim = "카르가스에 있는 자칼 모스멜드에게 자홍버섯 12개를 가져가야 합니다."
Inst16Quest7_HORDE_Location = "자칼 모스멜드 (황야의 땅 - 카르가스; "..YELLOW.."2.6, 46.0"..WHITE..")"
Inst16Quest7_HORDE_Note = "선행 퀘스트는 자칼 모스멜드에게 받습니다.\n버섯은 던전 전체에 흩어져 있습니다.  약초채집가가 약초 찾기 켜고 있고 퀘스트를 가지고 있다면 미니맵에서 그것을 볼 수 있습니다.  선행 퀘스트는 동일한 NPC에서 받습니다."
Inst16Quest7_HORDE_Prequest = "황야의 땅에서 재료 찾기"
Inst16Quest7_HORDE_Folgequest = "황야의 땅에서 재료 찾기 (2)"
--
Inst16Quest7name1_HORDE = "복원의 물약"

--Quest 8 Horde
Inst16Quest8_HORDE = "8. 보물 되찾기" -- Reclaimed Treasures
Inst16Quest8_HORDE_Aim = "울다만의 남쪽 대전당에 있는 궤짝에서 가레트가의 보물을 찾아 언더시티에 있는 그에게 가져가야 합니다."
Inst16Quest8_HORDE_Location = "패트릭 가레트 (언더시티; "..YELLOW.."62.6, 48.4"..WHITE..")"
Inst16Quest8_HORDE_Note = "던전에 들어가기 전에 보물을 찾을 수 있습니다. 남쪽 터널 끝에 있습니다. 입구지도에 "..YELLOW.."[5]"..WHITE.."."
Inst16Quest8_HORDE_Prequest = "없음"
Inst16Quest8_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 9 Horde
Inst16Quest9_HORDE = "9. 백금 원반" -- The Platinum Discs
Inst16Quest9_HORDE_Aim = "바위감시자와 대화하고 그가 알고 있는 고대의 지식을 배우십시오. 지식을 배운 후에는 노르간논의 원반을 가동하십시오. -> 썬더 블러프에 있는 현자 중 하나에게 노르간논의 소형 원반을 가져가야 합니다."
Inst16Quest9_HORDE_Location = "노르간논의 원반 (울다만; "..YELLOW.."[11]"..WHITE..")"
Inst16Quest9_HORDE_Note = "퀘스트를 받은 후, 디스크 왼쪽에 있는 돌 감시자에게 말하십시오.  그런 다음 백금 원반을 다시 사용하여 소형 원반을 받으십시오. 소형 원반을 썬더 블러프 현자 트루스시커에게 가져가야 합니다. ("..YELLOW.."34.8, 47.8"..WHITE..").  다음은 근처에 있는 다른 NPC에게 시작합니다."
Inst16Quest9_HORDE_Prequest = "없음"
Inst16Quest9_HORDE_Folgequest = "울둠의 전조"
--
Inst16Quest9name1_HORDE = "완화의 자루"
Inst16Quest9name2_HORDE = "최상급 치유 물약"
Inst16Quest9name3_HORDE = "상급 마나 물약"

--Quest 10 Horde  (same as Quest 4 Alliance)
Inst16Quest10_HORDE = "10. 울다만의 마력원천" -- Power in Uldaman
Inst16Quest10_HORDE_Aim = Inst16Quest16_Aim
Inst16Quest10_HORDE_Location = Inst16Quest16_Location
Inst16Quest10_HORDE_Note = Inst16Quest16_Note
Inst16Quest10_HORDE_Prequest = Inst16Quest16_Prequest
Inst16Quest10_HORDE_Folgequest = Inst16Quest16_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 17 Alliance)
Inst16Quest11_HORDE = "11. 인듀리움 광석" -- Indurium Ore
Inst16Quest11_HORDE_Aim = Inst16Quest17_Aim
Inst16Quest11_HORDE_Location = Inst16Quest17_Location
Inst16Quest11_HORDE_Note = Inst16Quest17_Note
Inst16Quest11_HORDE_Prequest = Inst16Quest17_Prequest
Inst16Quest11_HORDE_Folgequest = Inst16Quest17_Folgequest
-- No Rewards for this quest



--------------- INST17 - Blackfathom Deeps 검은심연 나락 ---------------

Inst17Caption = "검은심연 나락"
Inst17QAA = "6 퀘스트"
Inst17QAH = "5 퀘스트"

--Quest 1 Alliance
Inst17Quest1 = "1. 심연의 지식" -- Knowledge in the Deeps
Inst17Quest1_Aim = "아이언포지, 쓸쓸한 뒷골목에 있는 게릭 본그립에게 로르갈리스 초본을 가져가야 합니다."
Inst17Quest1_Location = "게릭 본그립 (아이언포지 - 쓸쓸한 뒷골목; "..YELLOW.."50.4, 6.0"..WHITE..")"
Inst17Quest1_Note = "물 속에서 초본을 "..YELLOW.."[2]"..WHITE.." 찾을 수 있습니다."
Inst17Quest1_Prequest = "없음"
Inst17Quest1_Folgequest = "없음"
--
Inst17Quest1name1 = "지탱의 반지"

--Quest 2 Alliance
Inst17Quest2 = "2. 타락에 대한 연구" -- Researching the Corruption
Inst17Quest2_Aim = "아우버다인에 있는 게르샬라 나이트위스퍼가 변이된 뇌간 8개를 가져다 달라고 부탁했습니다."
Inst17Quest2_Location = "게르샬라 나이트위스퍼 (어둠의 해안 - 아우버다인; "..YELLOW.."38.4, 43.0"..WHITE..")"
Inst17Quest2_Note = "선행 퀘스트는 선택 사항입니다.  아르고스 나이트위스퍼에서 받을 수 있습니다. (스톰윈드 - 공원; "..YELLOW.."21.4, 55.6"..WHITE..").  던전 포털 입구 외부에서 나가의 변이된 뇌간을 드랍합니다."
Inst17Quest2_Prequest = "먼 곳에 퍼진 타락"
Inst17Quest2_Folgequest = "없음"
--
Inst17Quest2name1 = "딱정벌레 팔보호구"
Inst17Quest2name2 = "고위성직자의 단망토"

--Quest 3 Alliance
Inst17Quest3 = "3. 타엘리드 찾기" -- In Search of Thaelrid
Inst17Quest3_Aim = "검은심연의 나락에서 은빛경비병 타엘리드를 찾아야 합니다."
Inst17Quest3_Location = "새벽감시자 섀드라스 (다르나서스 - 장인의 정원; "..YELLOW.."55.4, 24.6"..WHITE..")"
Inst17Quest3_Note = "당신은 은빛경비병 타엘리드를 "..YELLOW.."[4]"..WHITE.." 에서 찾을 수 있습니다."
Inst17Quest3_Prequest = "없음"
Inst17Quest3_Folgequest = "검은심연의 음모!"
-- No Rewards for this quest

--Quest 4 Alliance
Inst17Quest4 = "4. 검은심연의 음모!" -- Blackfathom Villainy
Inst17Quest4_Aim = "황혼의 군주 켈리스를 처치하고 그 증거로 머리카락을 다르나서스에 있는 새벽감시자에게 가져가야 합니다."
Inst17Quest4_Location = "은빛경비병 타엘리드 (검은심연 나락; "..YELLOW.."[4]"..WHITE..")"
Inst17Quest4_Note = "황혼의 군주 켈리스는 "..YELLOW.."[8]"..WHITE.." 에 있다.  새벽감시자 셀고름은 (다르나서스 - 장인의 정원; "..YELLOW.."55.8, 24.2"..WHITE..") 에서 찾을 수 있습니다."
Inst17Quest4_Prequest = "타엘리드 찾기"
Inst17Quest4_Folgequest = "없음"
--
Inst17Quest4name1 = "묘비의 홀"
Inst17Quest4name2 = "북극의 버클러"

--Quest 5 Alliance
Inst17Quest5 = "5. 황혼의망치단의 몰락" -- Twilight Falls
Inst17Quest5_Aim = "다르나서스에 있는 은빛경비병 마나도스에게 황혼의 펜던트 10개를 가져가야 합니다."
Inst17Quest5_Location = "은빛경비병 마나도스 (다르나서스 - 장인의 정원; "..YELLOW.."55.2, 23.6"..WHITE..")"
Inst17Quest5_Note = "던전 전체의 모든 황혼의망치단은 황혼의 펜던트를 드랍합니다."
Inst17Quest5_Prequest = "없음"
Inst17Quest5_Folgequest = "없음"
--
Inst17Quest5name1 = "빛구름 장화"
Inst17Quest5name2 = "심재 벨트"

--Quest 6 Alliance   (using data from Shadowfang Keep Alliance Quest 2 since its the same quest.)
Inst17Quest6 = "6. 소랜루크 수정구" -- The Orb of Soran'ruk
Inst17Quest6_Aim = Inst12Quest2_Aim
Inst17Quest6_Location = Inst12Quest2_Location
Inst17Quest6_Note = Inst12Quest2_Note
Inst17Quest6_Prequest = Inst12Quest2_Prequest
Inst17Quest6_Folgequest = Inst12Quest2_Folgequest
--
Inst17Quest6name1 = Inst12Quest2name1
Inst17Quest6name2 = Inst12Quest2name2


--Quest 1 Horde
Inst17Quest1_HORDE = "1. 아쿠마이의 정수" -- The Essence of Aku'Mai
Inst17Quest1_HORDE_Aim = "잿빛 골짜기에 있는 제네우 생크리에게 아쿠마이의 사파이어 20개를 가져가야 합니다."
Inst17Quest1_HORDE_Location = "제네우 생크리 (잿빛 골짜기 - 조람가르 전초기지; "..YELLOW.."11.6, 34.2"..WHITE..")"
Inst17Quest1_HORDE_Note = "선행 퀘스트인 검은심연의 나락으로는 츄나만에게 받을 수 있습니다. (돌발톱 산맥 - 해바위 야영지; "..YELLOW.."47.2, 64.2"..WHITE..").  사파이어는 던전 입구 이전의 터널에서 찾을 수 있습니다."
Inst17Quest1_HORDE_Prequest = "검은심연의 나락으로..."
Inst17Quest1_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Horde
Inst17Quest2_HORDE = "2. 고대 신들에 대한 충성" -- Allegiance to the Old Gods
Inst17Quest2_HORDE_Aim = "축축한 메모를 잿빛 골짜기의 제네우 생크리에게 가져가십시오. -> 검은심연의 나락에 있는 로구스 제트를 처치한 후 잿빛 골짜기의 제네우 생크리에게 돌아가십시오."
Inst17Quest2_HORDE_Location = "축축한 쪽지 (드랍 - 참고 참조)"
Inst17Quest2_HORDE_Note = "검은심연의 바다여사제에게 축축한 쪽지를 얻을 수 있습니다.  그다음 제네우 생크리에게 가져 가십시오. (잿빛 골짜기 - 조람가르 전초기지; "..YELLOW.."11.6, 34.2"..WHITE..").  로구스 제트는 "..YELLOW.."[6]"..WHITE.."에 있다.  나열된 보상은 후속 퀘스트를 위한 것입니다."
Inst17Quest2_HORDE_Prequest = "없음"
Inst17Quest2_HORDE_Folgequest = "고대 신들에 대한 충성"
--
Inst17Quest2name1_HORDE = "완력의 고리"
Inst17Quest2name2_HORDE = "밤나무 어깨보호대"

--Quest 3 Horde
Inst17Quest3_HORDE = "3. 폐허 사이로!" -- Amongst the Ruins
Inst17Quest3_HORDE_Aim = "잿빛 골짜기 서부 조람가르 전초기지에 있는 제네우 생크리는 고대정령의 비밀을 간직하고 있는심연의 핵을 가지고 돌아오라고 한다."
Inst17Quest3_HORDE_Location = "제네우 생크리 (잿빛 골짜기 - 조람가르 전초기지; "..YELLOW.."11.6, 34.2"..WHITE..")"
Inst17Quest3_HORDE_Note = "물 속에서 심연의 핵 "..YELLOW.."[7]"..WHITE.." 을 찾을 수 있습니다.  당신이 심연의 핵을 얻으면 군주 아쿠아니스가 당신을 공격합니다.  그는 퀘스트 아이템을 드랍 합니다. 당신은 그걸 가지고 제네우 생크리에게 돌아가야 합니다."
Inst17Quest3_HORDE_Prequest = "없음"
Inst17Quest3_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Horde
Inst17Quest4_HORDE = "4. 검은심연의 음모!" -- Blackfathom Villainy
Inst17Quest4_HORDE_Aim = "검은 심연의 나락 인스턴스 던전 내부의 엔피씨 [은빛 경비병 타엘리드]로 부터 시작되는 퀘스트이다.은빛 경비병 타엘리드는 검은심연의 나락의 아스카르 연못의 남서쪽에 위치해 있다.황혼의 군주 켈리스를 처치하고 그 증거로 그의 머리카락을 썬더 블러프에 있는 바샤나 룬토템에게 가져가야 합니다."
Inst17Quest4_HORDE_Location = "은빛경비병 타엘리드 (검은심연 나락; "..YELLOW.."[4]"..WHITE..")"
Inst17Quest4_HORDE_Note = "황혼의 군주 켈리스가 "..YELLOW.."[8]"..WHITE.." 에 있습니다. 바샤나 룬토템을 (썬더 블러프 - 장로의 봉우리; "..YELLOW.."70.8, 33.8"..WHITE..") 찾을 수 있습니다."
Inst17Quest4_HORDE_Prequest = "없음"
Inst17Quest4_HORDE_Folgequest = "없음"
--
Inst17Quest4name1_HORDE = "묘비의 홀"
Inst17Quest4name2_HORDE = "북극의 버클러"

--Quest 5 Horde  (same as Quest 6 Alliance)
Inst17Quest5_HORDE = "5. 소랜루크 수정구" -- The Orb of Soran'ruk
Inst17Quest5_HORDE_Aim = Inst17Quest6_Aim
Inst17Quest5_HORDE_Location = Inst17Quest6_Location
Inst17Quest5_HORDE_Note = Inst17Quest6_Note
Inst17Quest5_HORDE_Prequest = Inst17Quest6_Prequest
Inst17Quest5_HORDE_Folgequest = Inst17Quest6_Folgequest
--
Inst17Quest5name1_HORDE = Inst17Quest6name1
Inst17Quest5name2_HORDE = Inst17Quest6name2



--------------- INST18 - Dire Maul East 혈투의 전장 동쪽---------------

Inst18Caption = "혈투의 전장 (동쪽)"
Inst18QAA = "6 퀘스트"
Inst18QAH = "6 퀘스트"

--Quest 1 Alliance
Inst18Quest1 = "1. 푸실린과 노쇠한 아즈토르딘" -- Pusillin and the Elder Azj'Tordin
Inst18Quest1_Aim = "혈투의 전장으로 가서 푸실린이라는 임프를 찾으십시오. 어떤 수단을 써서라도 아즈토르딘의 마법서를 돌려받아야 합니다.마법서를 회수하면 페랄라스의 라리스 정자에 있는 아즈토르딘에게 돌아가야 합니다."
Inst18Quest1_Location = "아즈토르딘 (페랄라스 - 라리스의 정자; "..YELLOW.."76.8, 37.4"..WHITE..")"
Inst18Quest1_Note = "푸실린은 "..YELLOW.."[1]"..WHITE.." 에 있다.  네가 말을 걸면 도망가지만, 더이상 움직이지 않게 되면 전투가 시작됩니다. "..YELLOW.."[2]"..WHITE..".  그는 혈투의 전장 북쪽과 서쪽에서 사용되는 초승달 열쇠를 드랍합니다."
Inst18Quest1_Prequest = "없음"
Inst18Quest1_Folgequest = "없음"
--
Inst18Quest1name1 = "생기의 장화"
Inst18Quest1name2 = "전력의 검"

--Quest 2 Alliance
Inst18Quest2 = "2. 레스텐드리스의 그물!" -- Lethtendris's Web
Inst18Quest2_Aim = "페랄라스의 모자케 야영지에 있는 탈로 쏜후프에게 레스텐드리스의 그물을 가져가야 합니다."
Inst18Quest2_Location = "라트로니쿠스 문스피어 (페랄라스 - 페더문 요새; "..YELLOW.."30.4, 46.0"..WHITE..")"
Inst18Quest2_Note = "레스텐드리스는 "..YELLOW.."[3]"..WHITE.." 에 있다.  선행 퀘스트는 아이언포지의 급사 해머풀에서 나옵니다.  그는 도시 전체를 돌아 다닙니다."
Inst18Quest2_Prequest = "페더문 요새"
Inst18Quest2_Folgequest = "없음"
--
Inst18Quest2name1 = "지식의 단검"

--Quest 3 Alliance
Inst18Quest3 = "3. 악령덩굴 조각" -- Shards of the Felvine
Inst18Quest3_Aim = "혈투의 전장에서 악령덩굴 조각을 채취하십시오. 칼날바람 알진을 물리쳐야만 얻을 수 있을 것입니다. 정화의 성물함에 단단히 봉인한 후, 달의 숲의 나이트헤이븐에 있는 라빈 사투르나에게 돌아가야 합니다."
Inst18Quest3_Location = "라빈 사투르나 (달의 숲 - 나이트 헤이븐; "..YELLOW.."51.6, 44.8"..WHITE..")"
Inst18Quest3_Note = "칼날바람 알진은 "..YELLOW.."[5]"..WHITE.." 에서 찾을 수 있습니다.  선행 퀘스트는 라빈 사투르나에서 그리고 당신을 정화의 성물함을 (실리더스; "..YELLOW.."63.2, 55.2"..WHITE..") 회수하도록 보냅니다."
Inst18Quest3_Prequest = "정화의 성물함"
Inst18Quest3_Folgequest = "없음"
--
Inst18Quest3name1 = "밀리의 방패"
Inst18Quest3name2 = "밀리의 고서"

--Quest 4 Alliance
Inst18Quest4 = "4. 군주 발타라크의 아뮬렛 왼쪽 조각" -- The Left Piece of Lord Valthalak's Amulet
Inst18Quest4_Aim = "부름의 화로를 사용하여 이살리엔 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst18Quest4_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst18Quest4_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n이살리엔은 "..YELLOW.."[5]"..WHITE.." 에서 소환 된다."
Inst18Quest4_Prequest = "중요한 요소"
Inst18Quest4_Folgequest = "예언속의 알카즈 섬"
-- No Rewards for this quest

--Quest 5 Alliance
Inst18Quest5 = "5. 군주 발타라크의 아뮬렛 오른쪽 조각" -- The Right Piece of Lord Valthalak's Amulet
Inst18Quest5_Aim = "부름의 화로를 사용하여 이살리엔 영혼을 소환한 후 처치하십시오. 군주 발타라크의 아뮬렛 왼쪽 조각과 부름의 화로를 가지고 검은바위 산 안에 있는 보들리에게 가야 합니다."
Inst18Quest5_Location = "보들리 (검은바위 산; "..YELLOW.."[D] 입구지도"..WHITE..")"
Inst18Quest5_Note = "던전 방어구 세트 퀘스트 라인.  보들리를 보기 위해서는 4차원 유령 탐색기가 필요합니다. 선행 퀘스트는 '안시온을 찾아서' 에서 얻을 수 있습니다.\n\n이살리엔은 "..YELLOW.."[5]"..WHITE.." 에서 소환 된다."
Inst18Quest5_Prequest = "또 다른 중요한 요소"
Inst18Quest5_Folgequest = "마지막 준비 ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
-- No Rewards for this quest

--Quest 6 Alliance
Inst18Quest6 = "6. 감옥벽의 재료" -- The Prison's Bindings
Inst18Quest6_Aim = "페랄라스에 있는 혈투의 전장으로 간 다음 굽이나무 지구에 서식하는 야생혈족 사티르로부터 사티르의 피 15개를 회수한 후 타락의 흉터에 있는 다이오에게 돌아가야 합니다."
Inst18Quest6_Location = "노쇠한 다이오 (저주받은 땅 - 타락의 흉터; "..YELLOW.."34.2, 50.0"..WHITE..")"
Inst18Quest6_Note = "이것은 노쇠한 다이오가 준 또 다른 퀘스트와 함께 파멸의 의식 주문에 대한 흑마법사 전용 퀘스트 입니다.  '푸실린과 노쇠한 아즈토르딘' 퀘스트에서 제공하는 초승달 열쇠가 있다면, 라리스 정자 뒷문을 통해 혈투의 전장 동쪽으로 들어갈 수 있습니다. (페랄라스; "..YELLOW.."77, 37"..WHITE..")."
Inst18Quest6_Prequest = "없음"
Inst18Quest6_Folgequest = "없음"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst18Quest1_HORDE = Inst18Quest1
Inst18Quest1_HORDE_Aim = Inst18Quest1_Aim
Inst18Quest1_HORDE_Location = Inst18Quest1_Location
Inst18Quest1_HORDE_Note = Inst18Quest1_Note
Inst18Quest1_HORDE_Prequest = Inst18Quest1_Prequest
Inst18Quest1_HORDE_Folgequest = Inst18Quest1_Folgequest
--
Inst18Quest1name1_HORDE = Inst18Quest1name1
Inst18Quest1name2_HORDE = Inst18Quest1name2

--Quest 2 Horde
Inst18Quest2_HORDE = "2. 레스텐드리스의 그물!" -- Lethtendris's Web
Inst18Quest2_HORDE_Aim = "페랄라스의 모자케 야영지에 있는 탈로 쏜후프에게 레스텐드리스의 그물을 가져가야 합니다."
Inst18Quest2_HORDE_Location = "탈로 쏜후프 (페랄라스 - 모자케 야영지; "..YELLOW.."76.0, 43.8"..WHITE..")"
Inst18Quest2_HORDE_Note = "레스텐드리스는 혈투의 전장 "..YELLOW.."동쪽"..WHITE.." 에 "..YELLOW.."[3]"..WHITE.." 있습니다.  선행 퀘스트는 오그리마의 징집관 고를라취에서 나온다.  그는 도시 전체를 돌아 다닙니다."
Inst18Quest2_HORDE_Prequest = "모자케 야영지"
Inst18Quest2_HORDE_Folgequest = "없음"
--
Inst18Quest2name1_HORDE = "지식의 단검"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst18Quest3_HORDE = Inst18Quest3
Inst18Quest3_HORDE_Aim = Inst18Quest3_Aim
Inst18Quest3_HORDE_Location = Inst18Quest3_Location
Inst18Quest3_HORDE_Note = Inst18Quest3_Note
Inst18Quest3_HORDE_Prequest = Inst18Quest3_Prequest
Inst18Quest3_HORDE_Folgequest = Inst18Quest3_Folgequest
--
Inst18Quest3name1_HORDE = Inst18Quest3name1
Inst18Quest3name2_HORDE = Inst18Quest3name2

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst18Quest4_HORDE = Inst18Quest4
Inst18Quest4_HORDE_Aim = Inst18Quest4_Aim
Inst18Quest4_HORDE_Location = Inst18Quest4_Location
Inst18Quest4_HORDE_Note = Inst18Quest4_Note
Inst18Quest4_HORDE_Prequest = Inst18Quest4_Prequest
Inst18Quest4_HORDE_Folgequest = Inst18Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst18Quest5_HORDE = Inst18Quest5
Inst18Quest5_HORDE_Aim = Inst18Quest5_Aim
Inst18Quest5_HORDE_Location = Inst18Quest5_Location
Inst18Quest5_HORDE_Note = Inst18Quest5_Note
Inst18Quest5_HORDE_Prequest = Inst18Quest5_Prequest
Inst18Quest5_HORDE_Folgequest = Inst18Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst18Quest6_HORDE = Inst18Quest6
Inst18Quest6_HORDE_Aim = Inst18Quest6_Aim
Inst18Quest6_HORDE_Location = Inst18Quest6_Location
Inst18Quest6_HORDE_Note = Inst18Quest6_Note
Inst18Quest6_HORDE_Prequest = Inst18Quest6_Prequest
Inst18Quest6_HORDE_Folgequest = Inst18Quest6_Folgequest
-- No Rewards for this quest



--------------- INST19 - Dire Maul North 혈투의 전장 북쪽 ---------------

Inst19Caption = "혈투의 전장 (북쪽)"
Inst19QAA = "5 퀘스트"
Inst19QAH = "5 퀘스트"

--Quest 1 Alliance
Inst19Quest1 = "1. 부서진 함정" -- A Broken Trap
Inst19Quest1_Aim = "함정을 수리합니다."
Inst19Quest1_Location = "부서진 함정 (혈투의 전장; "..YELLOW.."북쪽"..WHITE..")"
Inst19Quest1_Note = "반복 가능한 퀘스트. 함정을 수리하려면 [토륨 부품] 과 [냉기 오일]을 사용해야 합니다."
Inst19Quest1_Prequest = "없음"
Inst19Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst19Quest2 = "2. 고르독 오우거 위장복" -- The Gordok Ogre Suit
Inst19Quest2_Aim = "룬무늬 두루마리 4개, 튼튼한 가죽 8장, 룬문자 실타래 2개, 그리고 오우거 타닌을 노트 팀블잭에게 가져가야 합니다. 노트 팀블잭은 혈투의 전장에 있는 고르독일족 은신처 구석에 족쇄에 묶여 있습니다."
Inst19Quest2_Location = "노트 팀블잭 (혈투의 전장; "..YELLOW.."북쪽, [4]"..WHITE..")"
Inst19Quest2_Note = "반복 가능한 퀘스트.  오우거 타닌은 "..YELLOW.."[4] (위에)"..WHITE.." 근처에서 볼 수 있습니다.  룬무늬 두루마리는 재봉술, 튼튼한 가죽은 무두질, 룬문자 실타래는 재봉용품 상인에서 나옵니다."
Inst19Quest2_Prequest = "없음"
Inst19Quest2_Folgequest = "없음"
--
Inst19Quest2name1 = "고르독 오우거 위장복"

--Quest 3 Alliance
Inst19Quest3 = "3. 노트 구출 대작전!" -- Free Knot!
Inst19Quest3_Aim = "노트 팀블잭을 위해 고르독 족쇄 열쇠를 수집합니다."
Inst19Quest3_Location = "노트 팀블잭 (혈투의 전장; "..YELLOW.."북쪽, [4]"..WHITE..")"
Inst19Quest3_Note = "반복 가능한 퀘스트.  모든 경비원은 열쇠를 드랍할 수 있습니다."
Inst19Quest3_Prequest = "없음"
Inst19Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst19Quest4 = "4. 고르독 일 마무리!" -- Unfinished Gordok Business
Inst19Quest4_Aim = "권력의 고르독 건틀릿을 찾아 혈투의 전장에 있는 대장 크롬크러쉬에게 가져가야 합니다.\n크롬크러쉬의 '옛날 얘기'에 따르면 자칭 왕자라는 토르텔드린이라는 이름의 '기분 나쁜' 엘프가 고르독 왕에게서 빼앗아갔다고 합니다."
Inst19Quest4_Location = "대장 크롬크러쉬 (혈투의 전장; "..YELLOW.."북쪽, [5]"..WHITE..")"
Inst19Quest4_Note = "왕자 토르텔드린은 "..YELLOW.."서쪽"..WHITE.." 과 "..YELLOW.."[7]"..WHITE.." 에 있습니다.  건틀릿은 근처 상자안에 있습니다.  공물 실행 후 이 퀘스트를 얻을 수 있으며 '왕이 되는 것이 좋다!' 버프를 가질 수 있습니다."
Inst19Quest4_Prequest = "없음"
Inst19Quest4_Folgequest = "없음"
--
Inst19Quest4name1 = "고르독의 손장갑"
Inst19Quest4name2 = "고르독의 장갑"
Inst19Quest4name3 = "고르독의 건틀릿"
Inst19Quest4name4 = "고르독의 손보호대"

--Quest 5 Alliance
Inst19Quest5 = "5. 고르독 술 맛보기" -- The Gordok Taste Test
Inst19Quest5_Aim = "무료 술."
Inst19Quest5_Location = "천둥발 크리그 (혈투의 전장; "..YELLOW.."북쪽, [2]"..WHITE..")"
Inst19Quest5_Note = "NPC에 이야기하여 동시에 퀘스트를 수락하고 완료하기만 하면 됩니다."
Inst19Quest5_Prequest = "없음"
Inst19Quest5_Folgequest = "없음"
--
Inst19Quest5name1 = "고르독 그린그로그주"
Inst19Quest5name2 = "그리그의 스타우트 맥주"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst19Quest1_HORDE = Inst19Quest1
Inst19Quest1_HORDE_Aim = Inst19Quest1_Aim
Inst19Quest1_HORDE_Location = Inst19Quest1_Location
Inst19Quest1_HORDE_Note = Inst19Quest1_Note
Inst19Quest1_HORDE_Prequest = Inst19Quest1_Prequest
Inst19Quest1_HORDE_Folgequest = Inst19Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst19Quest2_HORDE = Inst19Quest2
Inst19Quest2_HORDE_Aim = Inst19Quest2_Aim
Inst19Quest2_HORDE_Location = Inst19Quest2_Location
Inst19Quest2_HORDE_Note = Inst19Quest2_Note
Inst19Quest2_HORDE_Prequest = Inst19Quest2_Prequest
Inst19Quest2_HORDE_Folgequest = Inst19Quest2_Folgequest
--
Inst19Quest2name1_HORDE = Inst19Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst19Quest3_HORDE = Inst19Quest3
Inst19Quest3_HORDE_Aim = Inst19Quest3_Aim
Inst19Quest3_HORDE_Location = Inst19Quest3_Location
Inst19Quest3_HORDE_Note = Inst19Quest3_Note
Inst19Quest3_HORDE_Prequest = Inst19Quest3_Prequest
Inst19Quest3_HORDE_Folgequest = Inst19Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst19Quest4_HORDE = Inst19Quest4
Inst19Quest4_HORDE_Aim = Inst19Quest4_Aim
Inst19Quest4_HORDE_Location = Inst19Quest4_Location
Inst19Quest4_HORDE_Note = Inst19Quest4_Note
Inst19Quest4_HORDE_Prequest = Inst19Quest4_Prequest
Inst19Quest4_HORDE_Folgequest = Inst19Quest4_Folgequest
--
Inst19Quest4name1_HORDE = Inst19Quest4name1
Inst19Quest4name2_HORDE = Inst19Quest4name2
Inst19Quest4name3_HORDE = Inst19Quest4name3
Inst19Quest4name4_HORDE = Inst19Quest4name4

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst19Quest5_HORDE = Inst19Quest5
Inst19Quest5_HORDE_Aim = Inst19Quest5_Aim
Inst19Quest5_HORDE_Location = Inst19Quest5_Location
Inst19Quest5_HORDE_Note = Inst19Quest5_Note
Inst19Quest5_HORDE_Prequest = Inst19Quest5_Prequest
Inst19Quest5_HORDE_Folgequest = Inst19Quest5_Folgequest
--
Inst19Quest5name1_HORDE = Inst19Quest5name1
Inst19Quest5name2_HORDE = Inst19Quest5name2



--------------- INST20 - Dire Maul West 혈투의 전장 서쪽---------------

Inst20Caption = "혈투의 전장 (서쪽)"
Inst20QAA = "16 퀘스트"
Inst20QAH = "16 퀘스트"

--Quest 1 Alliance
Inst20Quest1 = "1. 엘프의 전설!" -- Elven Legends
Inst20Quest1_Aim = "혈투의 전장을 뒤져 카리엘 윈탈루스를 찾으십시오. 찾을 수 있는 정보는 모두 찾아 페더문 요새에 있는 학자 룬쏜에게 돌아가야 합니다."
Inst20Quest1_Location = "학자 룬쏜 (페랄라스 - 페더문 요새; "..YELLOW.."31.2, 43.4"..WHITE..")"
Inst20Quest1_Note = "카리엘 윈탈루스의 유해는 "..GREEN.."[1'] 도서관"..WHITE.." 에서 찾을 수 있습니다."
Inst20Quest1_Prequest = "없음"
Inst20Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst20Quest2 = "2. 내면의 광기" -- The Madness Within
Inst20Quest2_Aim = "이몰타르의 감옥에 힘을 공급하는 다섯 개의 수정탑을 둘러싼 수호자들을 처치해야 합니다. 수정탑의 마력이 약해지면 이몰타르를 둘러싼 마법진도 분산될 것입니다.\n이몰타르의 감옥에 들어가 그 심장부에 서 있는 사악한 이몰타르를 처치하고, 마지막으로 도서관에 있는 토르텔드린 왕자와 맞서 싸우십시오.\n이 임무를 완수하면 안마당에 있는 셴드랄라 고대인에게 돌아가야 합니다."
Inst20Quest2_Location = "셴드랄라 고대인 (혈투의 전장; "..YELLOW.."서쪽, [1] (위에)"..WHITE..")"
Inst20Quest2_Note = "수정탑은 "..BLUE.."[B]"..WHITE.." 에 있다. 이몰타르는 "..YELLOW.."[6]"..WHITE..", 왕자 토르텔드린는 "..YELLOW.."[7]"..WHITE.." 에 있다."
Inst20Quest2_Prequest = "없음"
Inst20Quest2_Folgequest = "셴드랄라의 보물!"
-- No Rewards for this quest

--Quest 3 Alliance
Inst20Quest3 = "3. 셴드랄라의 보물!" -- The Treasure of the Shen'dralar
Inst20Quest3_Aim = "도서관으로 되돌아가 셴드랄라의 보물을 찾아야 합니다. 임무 완수에 대한 보상을 받으십시오!"
Inst20Quest3_Location = "셴드랄라 고대인 (혈투의 전장; "..YELLOW.."서쪽, [1]"..WHITE..")"
Inst20Quest3_Note = "근처 계단 아래에 보물을 찾을 수 있습니다. "..YELLOW.."[7]"..WHITE.."."
Inst20Quest3_Prequest = "내면의 광기"
Inst20Quest3_Folgequest = "없음"
--
Inst20Quest3name1 = "이삭 장화"
Inst20Quest3name2 = "등나무 투구"
Inst20Quest3name3 = "해골 파쇄기"

--Quest 4 Alliance
Inst20Quest4 = "4. 소로스의 공포마" -- Dreadsteed of Xoroth
Inst20Quest4_Aim = "모르줄의 지시서를 잘 읽으십시오. 소로시안 공포마를 소환해 물리친 후 그 영혼을 결속시켜야 합니다."
Inst20Quest4_Location = "모르줄 블러드브링어 (불타는 평원; "..YELLOW.."12,31"..WHITE..")"
Inst20Quest4_Note = "흑마법사 퀘스트.  흑마법사 영웅 탈것 퀘스트 라인의 최종 퀘스트.  먼저 표시된 모든 수정탑을 멈추게 해야 합니다. "..BLUE.."[B]"..WHITE.." 그리고 이몰타르를 처지 "..YELLOW.."[6]"..WHITE..".  그 후, 소환 의식을 시작할 수 있습니다.  약 20개의 영혼의 조각을 준비하고 데스무라의 종, 심판의 양초, 어둠의 물레를 유지하기 위해 특별히 지정된 흑마법사가 있어야 합니다.  공포의 수호병은 지배를 할수 있습니다.  완료 후, 공포마 영홍과 대화하여 퀘스트를 완료하십시오."
Inst20Quest4_Prequest = "임프 배달 ("..YELLOW.."스칼로맨스"..WHITE..")"
Inst20Quest4_Folgequest = "없음"
-- No Rewards for this quest

--Quest 5 Alliance
Inst20Quest5 = "5. 에메랄드의 꿈..." -- The Emerald Dream...
Inst20Quest5_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest5_Location = "에메랄드의 꿈 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest5_Note = "드루이드 퀘스트.  책을 현자 야본에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest5_Prequest = "없음"
Inst20Quest5_Folgequest = "없음"
--
Inst20Quest5name1 = "엘드레탈라스 옥새"

--Quest 6 Alliance
Inst20Quest6 = "6. 사냥꾼의 위대한 혈통" -- The Greatest Race of Hunters
Inst20Quest6_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest6_Location = "사냥꾼의 위대한 혈통 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest6_Note = "사냥꾼 퀘스트.  책을 현자 마이코스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest6_Prequest = "없음"
Inst20Quest6_Folgequest = "없음"
--
Inst20Quest6name1 = "엘드레탈라스 옥새"

--Quest 7 Alliance
Inst20Quest7 = "7. 신비술사의 요리책" -- The Arcanist's Cookbook
Inst20Quest7_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest7_Location = "신비술사의 요리책 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest7_Note = "마법사 퀘스트.  책을 현자 킬드라스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest7_Prequest = "없음"
Inst20Quest7_Folgequest = "없음"
--
Inst20Quest7name1 = "엘드레탈라스 옥새"

--Quest 8 Alliance
Inst20Quest8 = "8. 빛과 정의에 관하여" -- The Light and How To Swing It
Inst20Quest8_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest8_Location = "빛과 정의에 관하여 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest8_Note = "성기사 퀘스트.  책을 현자 마이코스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest8_Prequest = "없음"
Inst20Quest8_Folgequest = "없음"
--
Inst20Quest8name1 = "엘드레탈라스 옥새"

--Quest 9 Alliance
Inst20Quest9 = "9. 성스러운 볼로냐: 빛이 알려주지 않는 것들" -- Holy Bologna: What the Light Won't Tell You
Inst20Quest9_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest9_Location = "성스러운 볼로냐 : 빛이 알려주지 않는 것들 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest9_Note = "사제 퀘스트.  책을 현자 야본에게 넘겨주십시오 "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest9_Prequest = "없음"
Inst20Quest9_Folgequest = "없음"
--
Inst20Quest9name1 = "엘드레탈라스 옥새"

--Quest 10 Alliance
Inst20Quest10 = "10. 가로나: 은신과 기만에 대한 연구" -- Garona: A Study on Stealth and Treachery
Inst20Quest10_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest10_Location = "가로나 : 은신과 기만에 대한 연구 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest10_Note = "도적 퀘스트.  책을 현자 킬드라스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest10_Prequest = "없음"
Inst20Quest10_Folgequest = "없음"
--
Inst20Quest10name1 = "엘드레탈라스 옥새"

--Quest 11 Alliance
Inst20Quest11 = "11. 지배의 그림자" -- Harnessing Shadows
Inst20Quest11_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest11_Location = "지배의 그림자 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest11_Note = "흑마법사 퀘스트.  책을 현자 마이코스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest11_Prequest = "없음"
Inst20Quest11_Folgequest = "없음"
--
Inst20Quest11name1 = "엘드레탈라스 옥새"

--Quest 12 Alliance
Inst20Quest12 = "12. 방어의 고서" -- Codex of Defense
Inst20Quest12_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest12_Location = "방어의 고서 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest12_Note = "전사 퀘스트.  책을 현자 킬드라스에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest12_Prequest = "없음"
Inst20Quest12_Folgequest = "없음"
--
Inst20Quest12name1 = "엘드레탈라스 옥새"

--Quest 13 Alliance
Inst20Quest13 = "13. 집중의 성서" -- Libram of Focus
Inst20Quest13_Aim = "집중의 성서, 온전한 검은 다이아몬드 1개, 눈부신 큰 결정 4개, 그리고 어둠의 허물 2개를 혈투의 전장에 있는 현자 리드로스에게 갖다 주고 집중의 영석을 받아야 합니다."
Inst20Quest13_Location = "현자 리드로스 (혈투의 전장 서쪽; "..GREEN.."[1'] 도서관"..WHITE..")"
Inst20Quest13_Note = "선행 퀘스트는 아니지만, 이 퀘스트를 시작하기 전에 엘프의 전설을 완료해야 합니다.\n\n성서는 혈투의 전장에서 무작위로 드랍하며 거래가 가능하므로 경매장에서 찾을 수 있습니다.  어둠의 허물은 획득 시 귀속이며, 일부 보스에서 드랍할 수 있습니다. 되살아난 피조물과 되살아난 해골문지기는 "..YELLOW.."스칼로맨스"..WHITE.." 에 있다."
Inst20Quest13_Prequest = "없음"
Inst20Quest13_Folgequest = "없음"
--
Inst20Quest13name1 = "집중의 영석"

--Quest 14 Alliance
Inst20Quest14 = "14. 보호의 성서" -- Libram of Protection
Inst20Quest14_Aim = "보호의 성서, 온전한 검은 다이아몬드 1개, 눈부신 큰 결정 2개, 그리고 닳아해진 누더기골렘 조각 1개를 혈투의 전장에 있는 현자 리드로스에게 갖다 주고 보호의 영석을 받아야 합니다."
Inst20Quest14_Location = "현자 리드로스 (혈투의 전장 서쪽; "..GREEN.."[1'] 도서관"..WHITE..")"
Inst20Quest14_Note = "선행 퀘스트는 아니지만, 이 퀘스트를 시작하기 전에 엘프의 전설을 완료해야 합니다.\n\n성서는 혈투의 전장에서 무작위로 드랍하며 거래가 가능하므로 경매장에서 찾을 수 있습니다.  닳아해진 누더기골렘 조각은 획득 시 귀속이며 먹보 람스타인, 독고름 누더기골렘, 썩은담즙 누더기골렘과 기워붙인 누더기골렘에서 드랍합니다. "..YELLOW.."스트라솔름"..WHITE.."."
Inst20Quest14_Prequest = "없음"
Inst20Quest14_Folgequest = "없음"
--
Inst20Quest14name1 = "보호의 영석"

--Quest 15 Alliance
Inst20Quest15 = "15. 신속의 성서" -- Libram of Rapidity
Inst20Quest15_Aim = "신속의 성서, 온전한 검은 다이아몬드 1개, 눈부신 큰 결정 2개, 그리고 영웅의 피 2개를 혈투의 전장에 있는 현자 리드로스에게 갖다 주고 신속의 영석을 받아야 합니다."
Inst20Quest15_Location = "현자 리드로스 (혈투의 전장 서쪽; "..GREEN.."[1'] 도서관"..WHITE..")"
Inst20Quest15_Note = "선행 퀘스트는 아니지만, 이 퀘스트를 시작하기 전에 엘프의 전설을 완료해야 합니다.\n\n성서는 혈투의 전장에서 무작위로 드랍하며 거래가 가능하므로 경매장에서 찾을 수 있습니다.  영웅의 피는 획득 시 귀속이며 서부와 동부 역병지대 무작위로 땅에서 찾을 수 있습니다."
Inst20Quest15_Prequest = "없음"
Inst20Quest15_Folgequest = "없음"
--
Inst20Quest15name1 = "신속의 영석"

--Quest 16 Alliance
Inst20Quest16 = "16. 폴로르의 용사냥 개론!" -- Foror's Compendium
Inst20Quest16_Aim = "폴로르의 용사냥 개론을 도서관에 되돌려주어야 합니다."
Inst20Quest16_Location = "폴로르의 용사냥 개론 (무작위 보스 드랍 "..YELLOW.."혈투의 전장"..WHITE..")"
Inst20Quest16_Note = "전사 또는 성기사 퀘스트.  현자 리드로스에게 갑니다. (혈투의 전장 서쪽; "..GREEN.."[1'] 도서관"..WHITE..").  이것을 바꾸면 쿠엘 세라에 대한 퀘스트를 시작할 수 있습니다."
Inst20Quest16_Prequest = "없음"
Inst20Quest16_Folgequest = "쿠엘세라 검 만들기"
-- No Rewards for this quest


--Quest 1 Horde
Inst20Quest1_HORDE = "1. 엘프의 전설!" -- Elven Legends
Inst20Quest1_HORDE_Aim = "혈투의 전장을 뒤져 카리엘 윈탈루스를 찾으십시오. 찾을 수 있는 정보는 모두 찾아 모자케 야영지에 있는 현자 코로루스크에게 돌아가야 합니다."
Inst20Quest1_HORDE_Location = "현자 코로루스크 (페랄라스 - 모자케 야영지; "..YELLOW.."75.0, 43.8"..WHITE..")"
Inst20Quest1_HORDE_Note = "카리엘 윈탈루스의 유해는 "..GREEN.."[1'] 도서관"..WHITE.." 에서 찾을 수 있습니다."
Inst20Quest1_HORDE_Prequest = "없음"
Inst20Quest1_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst20Quest2_HORDE = Inst20Quest2
Inst20Quest2_HORDE_Aim = Inst20Quest2_Aim
Inst20Quest2_HORDE_Location = Inst20Quest2_Location
Inst20Quest2_HORDE_Note = Inst20Quest2_Note
Inst20Quest2_HORDE_Prequest = Inst20Quest2_Prequest
Inst20Quest2_HORDE_Folgequest = Inst20Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst20Quest3_HORDE = Inst20Quest3
Inst20Quest3_HORDE_Aim = Inst20Quest3_Aim
Inst20Quest3_HORDE_Location = Inst20Quest3_Location
Inst20Quest3_HORDE_Note = Inst20Quest3_Note
Inst20Quest3_HORDE_Prequest = Inst20Quest3_Prequest
Inst20Quest3_HORDE_Folgequest = Inst20Quest3_Folgequest
--
Inst20Quest3name1_HORDE = Inst20Quest3name1
Inst20Quest3name2_HORDE = Inst20Quest3name2
Inst20Quest3name3_HORDE = Inst20Quest3name3

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst20Quest4_HORDE = Inst20Quest4
Inst20Quest4_HORDE_Aim = Inst20Quest4_Aim
Inst20Quest4_HORDE_Location = Inst20Quest4_Location
Inst20Quest4_HORDE_Note = Inst20Quest4_Note
Inst20Quest4_HORDE_Prequest = Inst20Quest4_Prequest
Inst20Quest4_HORDE_Folgequest = Inst20Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst20Quest5_HORDE = Inst20Quest5
Inst20Quest5_HORDE_Aim = Inst20Quest5_Aim
Inst20Quest5_HORDE_Location = Inst20Quest5_Location
Inst20Quest5_HORDE_Note = Inst20Quest5_Note
Inst20Quest5_HORDE_Prequest = Inst20Quest5_Prequest
Inst20Quest5_HORDE_Folgequest = Inst20Quest5_Folgequest
--
Inst20Quest5name1_HORDE = Inst20Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst20Quest6_HORDE = Inst20Quest6
Inst20Quest6_HORDE_Aim = Inst20Quest6_Aim
Inst20Quest6_HORDE_Location = Inst20Quest6_Location
Inst20Quest6_HORDE_Note = Inst20Quest6_Note
Inst20Quest6_HORDE_Prequest = Inst20Quest6_Prequest
Inst20Quest6_HORDE_Folgequest = Inst20Quest6_Folgequest
--
Inst20Quest6name1_HORDE = Inst20Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst20Quest7_HORDE = Inst20Quest7
Inst20Quest7_HORDE_Aim = Inst20Quest7_Aim
Inst20Quest7_HORDE_Location = Inst20Quest7_Location
Inst20Quest7_HORDE_Note = Inst20Quest7_Note
Inst20Quest7_HORDE_Prequest = Inst20Quest7_Prequest
Inst20Quest7_HORDE_Folgequest = Inst20Quest7_Folgequest
--
Inst20Quest7name1_HORDE = Inst20Quest7name1

--Quest 8 Horde
Inst20Quest8_HORDE = "8. 냉기 충격과 주술 (주술사)" -- Frost Shock and You (Shaman)
Inst20Quest8_HORDE_Aim = "주인에게 책을 되돌려주십시오."
Inst20Quest8_HORDE_Location = "냉기 충격과 주술 (모든 혈투의 전장에서 무작위로 보스에서 드랍합니다.)"
Inst20Quest8_HORDE_Note = "주술사 퀘스트. 책을 현자 야본에게 넘겨주십시오. "..GREEN.."[1'] 도서관"..WHITE.."."
Inst20Quest8_HORDE_Prequest = "없음"
Inst20Quest8_HORDE_Folgequest = "없음"
--
Inst20Quest8name1_HORDE = "엘드레탈라스 옥새"

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst20Quest9_HORDE = Inst20Quest9
Inst20Quest9_HORDE_Aim = Inst20Quest9_Aim
Inst20Quest9_HORDE_Location = Inst20Quest9_Location
Inst20Quest9_HORDE_Note = Inst20Quest9_Note
Inst20Quest9_HORDE_Prequest = Inst20Quest9_Prequest
Inst20Quest9_HORDE_Folgequest = Inst20Quest9_Folgequest
--
Inst20Quest9name1_HORDE = Inst20Quest9name1

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst20Quest10_HORDE = Inst20Quest10
Inst20Quest10_HORDE_Aim = Inst20Quest10_Aim
Inst20Quest10_HORDE_Location = Inst20Quest10_Location
Inst20Quest10_HORDE_Note = Inst20Quest10_Note
Inst20Quest10_HORDE_Prequest = Inst20Quest10_Prequest
Inst20Quest10_HORDE_Folgequest = Inst20Quest10_Folgequest
--
Inst20Quest10name1_HORDE = Inst20Quest10name1

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst20Quest11_HORDE = Inst20Quest11
Inst20Quest11_HORDE_Aim = Inst20Quest11_Aim
Inst20Quest11_HORDE_Location = Inst20Quest11_Location
Inst20Quest11_HORDE_Note = Inst20Quest11_Note
Inst20Quest11_HORDE_Prequest = Inst20Quest11_Prequest
Inst20Quest11_HORDE_Folgequest = Inst20Quest11_Folgequest
--
Inst20Quest11name1_HORDE = Inst20Quest11name1

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst20Quest12_HORDE = Inst20Quest12
Inst20Quest12_HORDE_Aim = Inst20Quest12_Aim
Inst20Quest12_HORDE_Location = Inst20Quest12_Location
Inst20Quest12_HORDE_Note = Inst20Quest12_Note
Inst20Quest12_HORDE_Prequest = Inst20Quest12_Prequest
Inst20Quest12_HORDE_Folgequest = Inst20Quest12_Folgequest
--
Inst20Quest12name1_HORDE = Inst20Quest12name1

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst20Quest13_HORDE = Inst20Quest13
Inst20Quest13_HORDE_Aim = Inst20Quest13_Aim
Inst20Quest13_HORDE_Location = Inst20Quest13_Location
Inst20Quest13_HORDE_Note = Inst20Quest13_Note
Inst20Quest13_HORDE_Prequest = Inst20Quest13_Prequest
Inst20Quest13_HORDE_Folgequest = Inst20Quest13_Folgequest
--
Inst20Quest13name1_HORDE = Inst20Quest13name1

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst20Quest14_HORDE = Inst20Quest14
Inst20Quest14_HORDE_Aim = Inst20Quest14_Aim
Inst20Quest14_HORDE_Location = Inst20Quest14_Location
Inst20Quest14_HORDE_Note = Inst20Quest14_Note
Inst20Quest14_HORDE_Prequest = Inst20Quest14_Prequest
Inst20Quest14_HORDE_Folgequest = Inst20Quest14_Folgequest
--
Inst20Quest14name1_HORDE = Inst20Quest14name1

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst20Quest15_HORDE = Inst20Quest15
Inst20Quest15_HORDE_Aim = Inst20Quest15_Aim
Inst20Quest15_HORDE_Location = Inst20Quest15_Location
Inst20Quest15_HORDE_Note = Inst20Quest15_Note
Inst20Quest15_HORDE_Prequest = Inst20Quest15_Prequest
Inst20Quest15_HORDE_Folgequest = Inst20Quest15_Folgequest
--
Inst20Quest15name1_HORDE = Inst20Quest15name1

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst20Quest16_HORDE = Inst20Quest16
Inst20Quest16_HORDE_Aim = Inst20Quest16_Aim
Inst20Quest16_HORDE_Location = Inst20Quest16_Location
Inst20Quest16_HORDE_Note = Inst20Quest16_Note
Inst20Quest16_HORDE_Prequest = Inst20Quest16_Prequest
Inst20Quest16_HORDE_Folgequest = Inst20Quest16_Folgequest
--
Inst20Quest16name1_HORDE = Inst20Quest16name1



--------------- INST21 - Maraudon 마라우돈 ---------------

Inst21Caption = "마라우돈"
Inst21QAA = "8 퀘스트"
Inst21QAH = "8 퀘스트"

--Quest 1 Alliance
Inst21Quest1 = "1. 음영석 조각!" -- Shadowshard Fragments
Inst21Quest1_Aim = "마라우돈에서 음영석 조각 10개를 모아서 먼지진흙 습지대의 해안에 위치한 테라모어에 있는 대마법사 테르보쉬에게 가져가야 합니다."
Inst21Quest1_Location = "대마법사 테르보쉬 (먼지진흙 습지대 - 테라모어 섬; "..YELLOW.."66.4, 49.2"..WHITE..")"
Inst21Quest1_Note = "던전 밖에 보라색 쪽에 '우레의 음영석정령' 또는 '분쇄의 음영석정령' 에서 음영석 조각을 얻습니다."
Inst21Quest1_Prequest = "없음"
Inst21Quest1_Folgequest = "없음"
--
Inst21Quest1name1 = "열정의 음영석 목걸이"
Inst21Quest1name2 = "마력의 음영석 목걸이"

--Quest 2 Alliance
Inst21Quest2 = "2. 바일텅의 타락!" -- Vyletongue Corruption
Inst21Quest2_Aim = "마라우돈에 있는 주황색 수정 웅덩이에서 빈 감청석 약병을 채워야 합니다.\n오염된 녹시온의 후예가 나타나게 하려면 바일줄기 덩굴나무 위에 감청색 약병에 담긴 액체를 부어야 합니다.\n녹시온의 후예를 죽이는 방법으로 8개의 식물을 치료한 다음 나이젤의 야영지에 있는 탈렌드리아에게 돌아가야 합니다."
Inst21Quest2_Location = "탈렌드리아 (잊혀진 땅 - 나이젤의 야영지; "..YELLOW.."68.4, 8.8"..WHITE..")"
Inst21Quest2_Note = "던전 외부의 주황색 쪽 웅덩이에서 약병을 채울 수 있습니다. 식물은 던전 내부의 주황색과 보라색 지역에 있습니다."
Inst21Quest2_Prequest = "없음"
Inst21Quest2_Folgequest = "없음"
--
Inst21Quest2name1 = "나무씨앗 고리"
Inst21Quest2name2 = "산쑥 벨트"
Inst21Quest2name3 = "가지갈퀴 건틀릿"

--Quest 3 Alliance
Inst21Quest3 = "3. 뒤틀린 악마" -- Twisted Evils
Inst21Quest3_Aim = "트라드릭 수정 조각상 25개를 모아서 잊혀진 땅에 있는 윌로우에게 가져가야 합니다."
Inst21Quest3_Location = "윌로우 (잊혀진 땅; "..YELLOW.."62.2, 39.6"..WHITE..")"
Inst21Quest3_Note = "마라우돈의 대부분의 몬스터들은 조각상을 드랍합니다."
Inst21Quest3_Prequest = "없음"
Inst21Quest3_Folgequest = "없음"
--
Inst21Quest3name1 = "총면의 로브"
Inst21Quest3name2 = "가지뿌리 투구"
Inst21Quest3name3 = "가혹의 사슬 갑옷"
Inst21Quest3name4 = "기암석 어깨갑옷"

--Quest 4 Alliance
Inst21Quest4 = "4. 추방자의 지시서" -- The Pariah's Instructions
Inst21Quest4_Aim = "추방자의 지시서를 읽은 다음 마라우돈에서 결속의 아뮬렛을 획득해서 잊혀진 땅 남부에 있는 켄타우로스 추방자에게 가져가야 합니다."
Inst21Quest4_Location = "켄타우로스 추방자 (잊혀진 땅;  주변을 돌아다님 "..YELLOW.."50.4, 86.6"..WHITE..")"
Inst21Quest4_Note = "이름 없는 예언자를 쳐치 하고 ("..YELLOW.."[A] 입구지도"..WHITE..") 칸5명을 처치하세요.  첫 번째는 근처의 중간 경로에 있습니다. ("..YELLOW.."[1] 입구지도"..WHITE..").  두 번째는 마라우돈의 보라색 부분이지만 던전에 들어가기 전에 ("..YELLOW.."[2] 입구지도"..WHITE..").  세 번째는 던전에 들어가기 전에 주황색 부분에 있습니다. ("..YELLOW.."[3] 입구지도"..WHITE..").  네 번째는 가깝고 "..YELLOW.."[4]"..WHITE.." 그리고 다섯 번째도 가깝습니다.  "..YELLOW.."[1]"..WHITE.."."
Inst21Quest4_Prequest = "없음"
Inst21Quest4_Folgequest = "없음"
--
Inst21Quest4name1 = "선택받은 자의 징표"
Inst21Quest4name2 = "영혼의 아뮬렛"

--Quest 5 Alliance
Inst21Quest5 = "5. 마라우돈의 전설" -- Legends of Maraudon
Inst21Quest5_Aim = "셀레브라스의 홀 조각인 셀레브리안 마법봉과 셀레브리안 다이아몬드를 찾아야 합니다. \n셀레브라스와 대화를 나눌 방법을 찾아야 합니다."
Inst21Quest5_Location = "카빈드라 (잊혀진 땅 - 마라우돈; "..YELLOW.."[4] 입구지도"..WHITE..")"
Inst21Quest5_Note = "던전에 들어가기 전에 주황색 시작 부분에 카빈드라를 찾을 수 있습니다.\n녹시온에서 셀레브리안 마법봉을 "..YELLOW.."[2]"..WHITE..", 군주 바일텅에서 셀레브리안 다이아몬드를 "..YELLOW.."[5]"..WHITE.." 얻습니다. 셀레브라스는 "..YELLOW.."[7]"..WHITE.." 에 있다. 그와 대화 하려면 그를 처치해야 합니다."
Inst21Quest5_Prequest = "없음"
Inst21Quest5_Folgequest = "셀레브라스의 홀"
-- No Rewards for this quest

--Quest 6 Alliance
Inst21Quest6 = "6. 셀레브라스의 홀" -- The Scepter of Celebras
Inst21Quest6_Aim = "회복된 셀레브라스가 셀레브라스의 홀을 만드는 동안 그를 도와야 합니다.\n의식을 마친 후 그와 대화하십시오."
Inst21Quest6_Location = "회복된 셀레브라스 (마라우돈; "..YELLOW.."[7]"..WHITE..")"
Inst21Quest6_Note = "셀레브라스가 홀을 만듭니다. 그게 끝난 후에 그와 이야기하십시오."
Inst21Quest6_Prequest = "마라우돈의 전설"
Inst21Quest6_Folgequest = "없음"
--
Inst21Quest6name1 = "셀레브라스의 홀"

--Quest 7 Alliance
Inst21Quest7 = "7. 대지와 씨앗의 오염!" -- Corruption of Earth and Seed
Inst21Quest7_Aim = "공주 테라드라스를 해치우고 잊혀진 땅의 나이젤의 야영지에 있는 수호자 마란디스를 찾아가야 합니다."
Inst21Quest7_Location = "수호자 마란디스 (잊혀진 땅 - 나이젤의 야영지; "..YELLOW.."63.8, 10.6"..WHITE..")"
Inst21Quest7_Note = "공주 테라드라스는 "..YELLOW.."[11]"..WHITE.." 에서 찾을 수 있습니다."
Inst21Quest7_Prequest = "없음"
Inst21Quest7_Folgequest = "생명의 씨앗"
--
Inst21Quest7name1 = "도리깨 검"
Inst21Quest7name2 = "회생의 마법막대"
Inst21Quest7name3 = "푸른 수호자의 활"

--Quest 8 Alliance
Inst21Quest8 = "8. 생명의 씨앗" -- Seed of Life
Inst21Quest8_Aim = "마라우돈 공주 테라드라스를 처치하고 나타난 재타르의 영혼은 생명의 씨앗을 주며 달의 숲에 있는 수호자 레물로스에게 전해주라고 한다."
Inst21Quest8_Location = "재타르의 영혼 (마라우돈; "..YELLOW.."[11]"..WHITE..")"
Inst21Quest8_Note = "공주 테라드라스를 처치하고 재타르의 영혼이 나타납니다. "..YELLOW.."[11]"..WHITE..". 수호자 레물로스는 (달의 숲 - 레물로스의 제단; "..YELLOW.."36.2, 41.8"..WHITE..") 에서 찾을 수 있습니다."
Inst21Quest8_Prequest = "대지와 씨앗의 오염!"
Inst21Quest8_Folgequest = "없음"
-- No Rewards for this quest


--Quest 1 Horde
Inst21Quest1_HORDE = "1. 음영석 조각!" -- Shadowshard Fragments
Inst21Quest1_HORDE_Aim = "마라우돈에서 음영석 조각 10개를 모아서 오그리마에 있는 우텔나이에게 가져가야 합니다."
Inst21Quest1_HORDE_Location = "우텔나이 (오그리마 - 정기의 골짜기; "..YELLOW.."39.0, 86.0"..WHITE..")"
Inst21Quest1_HORDE_Note = "던전 밖에 보라색 쪽에 '우레의 음영석정령' 또는 '분쇄의 음영석정령' 에서 음영석 조각을 얻습니다."
Inst21Quest1_HORDE_Prequest = "없음"
Inst21Quest1_HORDE_Folgequest = "없음"
--
Inst21Quest1name1_HORDE = "열정의 음영석 목걸이"
Inst21Quest1name2_HORDE = "마력의 음영석 목걸이"

--Quest 2 Horde
Inst21Quest2_HORDE = "2. 바일텅의 타락" -- Vyletongue Corruption
Inst21Quest2_HORDE_Aim = "마라우돈에 있는 주황색 수정 웅덩이에서 빈 감청석 약병을 채워야 합니다.\n오염된 녹시온의 후예가 나타나게 하려면 바일줄기 덩굴나무 위에 감청색 약병에 담긴 액체를 부어야 합니다.\n녹시온의 후예를 죽이는 방법으로 8개의 식물을 치료한 다음 그늘수렵 마을에 있는 바르크 배틀스카에게 돌아가야 합니다."
Inst21Quest2_HORDE_Location = "바르크 배틀스카 (잊혀진 땅 - 그늘수렵 마을; "..YELLOW.."23.2, 70.2"..WHITE..")"
Inst21Quest2_HORDE_Note = "던전 외부의 주황색 쪽 웅덩이에서 약병을 채울 수 있습니다. 식물은 던전 내부의 주황색과 보라색 지역에 있습니다."
Inst21Quest2_HORDE_Prequest = "없음"
Inst21Quest2_HORDE_Folgequest = "없음"
--
Inst21Quest2name1_HORDE = "나무씨앗 고리"
Inst21Quest2name2_HORDE = "산쑥 벨트"
Inst21Quest2name3_HORDE = "가지갈퀴 건틀릿"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst21Quest3_HORDE = Inst21Quest3
Inst21Quest3_HORDE_Aim = Inst21Quest3_Aim
Inst21Quest3_HORDE_Location = Inst21Quest3_Location
Inst21Quest3_HORDE_Note = Inst21Quest3_Note
Inst21Quest3_HORDE_Prequest = Inst21Quest3_Prequest
Inst21Quest3_HORDE_Folgequest = Inst21Quest3_Folgequest
--
Inst21Quest3name1_HORDE = Inst21Quest3name1
Inst21Quest3name2_HORDE = Inst21Quest3name2
Inst21Quest3name3_HORDE = Inst21Quest3name3
Inst21Quest3name4_HORDE = Inst21Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst21Quest4_HORDE = Inst21Quest4
Inst21Quest4_HORDE_Aim = Inst21Quest4_Aim
Inst21Quest4_HORDE_Location = Inst21Quest4_Location
Inst21Quest4_HORDE_Note = Inst21Quest4_Note
Inst21Quest4_HORDE_Prequest = Inst21Quest4_Prequest
Inst21Quest4_HORDE_Folgequest = Inst21Quest4_Folgequest
--
Inst21Quest4name1_HORDE = Inst21Quest4name1
Inst21Quest4name2_HORDE = Inst21Quest4name2

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst21Quest5_HORDE = Inst21Quest5
Inst21Quest5_HORDE_Aim = Inst21Quest5_Aim
Inst21Quest5_HORDE_Location = Inst21Quest5_Location
Inst21Quest5_HORDE_Note = Inst21Quest5_Note
Inst21Quest5_HORDE_Prequest = Inst21Quest5_Prequest
Inst21Quest5_HORDE_Folgequest = Inst21Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst21Quest6_HORDE = Inst21Quest6
Inst21Quest6_HORDE_Aim = Inst21Quest6_Aim
Inst21Quest6_HORDE_Location = Inst21Quest6_Location
Inst21Quest6_HORDE_Note = Inst21Quest6_Note
Inst21Quest6_HORDE_Prequest = Inst21Quest6_Prequest
Inst21Quest6_HORDE_Folgequest = Inst21Quest6_Folgequest
Inst21Quest6FQuest_HORDE = Inst21Quest6FQuest
--
Inst21Quest6name1_HORDE = Inst21Quest6name1

--Quest 7 Horde
Inst21Quest7_HORDE = "7. 대지와 씨앗의 오염" -- Corruption of Earth and Seed
Inst21Quest7_HORDE_Aim = "공주 테라드라스를 처치하고 잊혀진 땅의 그늘수렵 마을 근처에 있는 셀렌드라에게 돌아가야 합니다."
Inst21Quest7_HORDE_Location = "셀렌드라 (잊혀진 땅; "..YELLOW.."26.8, 77.6"..WHITE..")"
Inst21Quest7_HORDE_Note = "공주 테라드라스는 "..YELLOW.."[11]"..WHITE.." 에서 찾을 수 있습니다."
Inst21Quest7_HORDE_Prequest = "없음"
Inst21Quest7_HORDE_Folgequest = "생명의 씨앗"
--
Inst21Quest7name1_HORDE = "도리깨 검"
Inst21Quest7name2_HORDE = "회생의 마법막대"
Inst21Quest7name3_HORDE = "푸른 소호자의 활"

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst21Quest8_HORDE = Inst21Quest8
Inst21Quest8_HORDE_Aim = Inst21Quest8_Aim
Inst21Quest8_HORDE_Location = Inst21Quest8_Location
Inst21Quest8_HORDE_Note = Inst21Quest8_Note
Inst21Quest8_HORDE_Prequest = Inst21Quest8_Prequest
Inst21Quest8_HORDE_Folgequest = Inst21Quest8_Folgequest
-- No Rewards for this quest



--------------- INST22 - Ragefire Chasm 성난불길 협곡 ---------------

Inst22Caption = "성난불길 협곡"
Inst22QAA = "퀘스트 없음"
Inst22QAH = "5 퀘스트"

--Quest 1 Horde
Inst22Quest1_HORDE = "1. 성난불길 협곡의 트로그" -- Testing an Enemy's Strength
Inst22Quest1_HORDE_Aim = "오그리마에 있는 성난불길 협곡을 찾아 성난불길 트로그 8마리와 성난불길일족 주술사 8마리를 처치하고 썬더 블러프에 있는 라하우로에게 돌아가야 합니다."
Inst22Quest1_HORDE_Location = "라하우로 (썬더 블러프 - 장로의 봉우리; "..YELLOW.."70.4, 32.2"..WHITE..")"
Inst22Quest1_HORDE_Note = "던전 시작 부분에서 트로그를 찾을 수 있습니다."
Inst22Quest1_HORDE_Prequest = "없음"
Inst22Quest1_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Horde
Inst22Quest2_HORDE = "2. 파괴해야 할 힘" -- The Power to Destroy...
Inst22Quest2_HORDE_Aim = "언더시티에 있는 바리마트라스에게 어둠의 주문서와 황천의 마법서를 가져가야 합니다."
Inst22Quest2_HORDE_Location = "바리마트라스 (언더시티 - 왕실; "..YELLOW.."56.2, 92.6"..WHITE..")"
Inst22Quest2_HORDE_Note = "이 책들은 불타는칼날단 이교도, 이글거리는 칼날단 흑마법사에 의해 드랍 할 수 있습니다."
Inst22Quest2_HORDE_Prequest = "없음"
Inst22Quest2_HORDE_Folgequest = "없음"
--
Inst22Quest2name1_HORDE = "유령 반바지"
Inst22Quest2name2_HORDE = "진창늪 다리보호구"
Inst22Quest2name3_HORDE = "가고일 다리보호구"

--Quest 3 Horde
Inst22Quest3_HORDE = "3. 잃어버린 가방 찾기" -- Searching for the Lost Satchel
Inst22Quest3_HORDE_Aim = "성난불길 협곡에서 마우르 그림토템의 시체를 찾아 도움이 될 만한 것들을 찾아야 합니다."
Inst22Quest3_HORDE_Location = "라하우로 (썬더 블러프 - 장로의 봉우리; "..YELLOW.."70.4, 32.2"..WHITE..")"
Inst22Quest3_HORDE_Note = "마우르 그림토템은 "..YELLOW.."[1]"..WHITE.." 에서 찾을 수 있습니다.  가방을 얻은 후 당신은 썬더 블러프에 라하우로에게 가져가야 합니다.  보상은 후속 퀘스트를 위한 것입니다."
Inst22Quest3_HORDE_Prequest = "없음"
Inst22Quest3_HORDE_Folgequest = "잃어버린 가방 돌려주기"
--
Inst22Quest3name1_HORDE = "깃털구슬 팔보호구"
Inst22Quest3name2_HORDE = "열대초원 팔보호구"

--Quest 4 Horde
Inst22Quest4_HORDE = "4. 내부의 배신자" -- Hidden Enemies
Inst22Quest4_HORDE_Aim = "바잘란과 기원사 제로쉬를 제거한 다음 오그리마에 있는 스랄에게 돌아가야 합니다."
Inst22Quest4_HORDE_Location = "스랄 (오그리마 - 지혜의 골짜기; "..YELLOW.."32.0, 37.8"..WHITE..")"
Inst22Quest4_HORDE_Note = "당신은 바잘란 "..YELLOW.."[4]"..WHITE.." 과 기원사 제로쉬 "..YELLOW.."[3]"..WHITE.." 를 찾을 수 있습니다.  선행 퀘스트는 오그리마 스랄에서 시작됩니다."
Inst22Quest4_HORDE_Prequest = "내부의 배신자"
Inst22Quest4_HORDE_Folgequest = "내부의 배신자"
--
Inst22Quest4name1_HORDE = "오그리마의 크리스"
Inst22Quest4name2_HORDE = "오그리마의 망치"
Inst22Quest4name3_HORDE = "오그리마의 도끼"
Inst22Quest4name4_HORDE = "오그리마의 지팡이"

--Quest 5 Horde
Inst22Quest5_HORDE = "5. 야수 처단" -- Slaying the Beast
Inst22Quest5_HORDE_Aim = "성난불길 협곡으로 가서 욕망의 타라가만을 제거한 다음 그의 심장을 오그리마에 있는 네루 파이어블레이드에게 가져가야 합니다."
Inst22Quest5_HORDE_Location = "네루 파이어블레이드 (오그리마 - 어둠의 틈; "..YELLOW.."49.6, 50.4"..WHITE..")"
Inst22Quest5_HORDE_Note = "당신은 욕망의 타라가만를 "..YELLOW.."[2]"..WHITE.." 에서 찾을 수 있습니다."
Inst22Quest5_HORDE_Prequest = "없음"
Inst22Quest5_HORDE_Folgequest = "없음"
-- No Rewards for this quest



--------------- INST23 - Razorfen Downs 가시덩굴 구릉---------------

Inst23Caption = "가시덩굴 구릉"
Inst23QAA = "3 퀘스트"
Inst23QAH = "4 퀘스트"

--Quest 1 Alliance
Inst23Quest1 = "1. 악의 무리" -- A Host of Evil
Inst23Quest1_Aim = "가시덩굴일족 전투호위병과 가시덩굴일족 가시마술사, 그리고 죽음의 머리교 신도를 각각 8마리씩 죽인 후 가시덩굴 구릉 입구 근처에 있는 미리암 문싱어에게 돌아가야 합니다."
Inst23Quest1_Location = "미리암 문싱어 (불모의 땅; "..YELLOW.."49.0, 94.8"..WHITE..")"
Inst23Quest1_Note = "던전 입구 바로 전에 이 지역에서 퀘스트와 몬스터를 찾을 수 있습니다."
Inst23Quest1_Prequest = "없음"
Inst23Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst23Quest2 = "2. 우상 진화" -- Extinguishing the Idol
Inst23Quest2_Aim = "가시덩굴 구릉에 있는 가시멧돼지의 우상까지 벨리스트라즈를 호위해야 합니다. 우상을 진화하는 의식을 수행하는 동안 벨리스트라즈를 보호해야 합니다."
Inst23Quest2_Location = "벨리스트라즈 (가시덩굴 구릉; "..YELLOW.."[2]"..WHITE..")"
Inst23Quest2_Note = "선행 퀘스트는 당신이 그를 도울 것에 동의하는 것입니다.  벨리스트라즈 우상을 닫으려고 시도 할때 몇몇 몬스터들이 소환되어 공격합니다.  퀘스트를 완료한 후, 우상 앞의 화로에서 퀘스트를 완료 할 수 있습니다."
Inst23Quest2_Prequest = "가시덩굴 구릉의 스컬지"
Inst23Quest2_Folgequest = "없음"
--
Inst23Quest2name1 = "용발톱 반지"

--Quest 3 Alliance
Inst23Quest3 = "3. 빛의 힘" -- Bring the Light
Inst23Quest3_Aim = "대주교 베네딕투스가 가시덩굴 구릉에 있는 혹한의 암네나르를 처치해달라고 부탁했습니다."
Inst23Quest3_Location = "대주교 베네딕투스 (스톰윈드 - 빛의 대성당; "..YELLOW.."39.6, 27.4"..WHITE..")"
Inst23Quest3_Note = "혹한의 암네나르는 가시덩굴 구릉의 마지막 보스입니다. 당신은 "..YELLOW.."[6]"..WHITE.." 에서 찾을 수 있다."
Inst23Quest3_Prequest = "없음"
Inst23Quest3_Folgequest = "없음"
--
Inst23Quest3name1 = "정복자의 검"
Inst23Quest3name2 = "적열의 부적"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst23Quest1_HORDE = Inst23Quest1
Inst23Quest1_HORDE_Aim = Inst23Quest1_Aim
Inst23Quest1_HORDE_Location = Inst23Quest1_Location
Inst23Quest1_HORDE_Note = Inst23Quest1_Note
Inst23Quest1_HORDE_Prequest = Inst23Quest1_Prequest
Inst23Quest1_HORDE_Folgequest = Inst23Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde
Inst23Quest2_HORDE = "2. 사악한 동맹" -- An Unholy Alliance
Inst23Quest2_HORDE_Aim = "사절 말킨을 처치한 다음 언더시티에 있는 브라고르 블러드피스트에게 그의 머리카락을 증거로 가져가야 합니다."
Inst23Quest2_HORDE_Location = "바리마트라스 (언더시티 - 왕실; "..YELLOW.."56.2, 92.6"..WHITE..")"
Inst23Quest2_HORDE_Note = "이전 퀘스트는 가시덩굴 우리의 마지막 보스에서 얻을 수 있습니다.  던전 밖에서 사절 말킨을 발견할 수 있습니다. (불모의 땅; "..YELLOW.."48.0, 92.4"..WHITE..")."
Inst23Quest2_HORDE_Prequest = "사악한 동맹"
Inst23Quest2_HORDE_Folgequest = "없음"
--
Inst23Quest2name1_HORDE = "검은해골 곤봉"
Inst23Quest2name2_HORDE = "강철가시 소총"
Inst23Quest2name3_HORDE = "광신도의 로브"

--Quest 3 Horde  (same as Quest 2 Alliance)
Inst23Quest3_HORDE = "3. 우상 진화" -- Extinguishing the Idol
Inst23Quest3_HORDE_Aim = Inst23Quest2_Aim
Inst23Quest3_HORDE_Location = Inst23Quest2_Location
Inst23Quest3_HORDE_Note = Inst23Quest2_Note
Inst23Quest3_HORDE_Prequest = Inst23Quest2_Prequest
Inst23Quest3_HORDE_Folgequest = Inst23Quest2_Folgequest
--
Inst23Quest3name1_HORDE = Inst23Quest2name1

--Quest 4 Horde
Inst23Quest4_HORDE = "4. 암네나르 처치" -- Bring the End
Inst23Quest4_HORDE_Aim = "앤드류 브로넬이 혹한의 암네나르를 처치하고 혹한의 해골을 가져다 달라고 부탁했습니다."
Inst23Quest4_HORDE_Location = "앤드류 브로넬 (언더시티 - 마법 지구; "..YELLOW.."74.0, 32.8"..WHITE..")"
Inst23Quest4_HORDE_Note = "혹한의 암네나르는 가시덩굴 구릉의 마지막 보스입니다.  당신은 "..YELLOW.."[6]"..WHITE.." 에서 찾을 수 있다."
Inst23Quest4_HORDE_Prequest = "없음"
Inst23Quest4_HORDE_Folgequest = "없음"
--
Inst23Quest4name1_HORDE = "정복자의 검"
Inst23Quest4name2_HORDE = "적열의 부적"



--------------- INST24 - Razorfen Kraul 가시덩굴 우리 ---------------

Inst24Caption = "가시덩굴 우리"
Inst24QAA = "5 퀘스트"
Inst24QAH = "5 퀘스트"

--Quest 1 Alliance
Inst24Quest1 = "1. 청엽수 줄기" -- Blueleaf Tubers
Inst24Quest1_Aim = "가시덩굴 우리에서 구멍 난 상자를 사용해 땅다람쥐를 소환하고 지휘봉을 사용해 땅다람쥐에게 청엽수 줄기를 찾아내도록 해야 합니다. 톱니항에 있는 메보크 미지릭스에게 청엽수 줄기 6개와 사용한 땅다람쥐 지휘봉과 구멍 난 상자를 가져가야 합니다."
Inst24Quest1_Location = "메보크 미지릭스 (불모의 땅 - 톱니항; "..YELLOW.."62.4, 37.6"..WHITE..")"
Inst24Quest1_Note = "상자, 지휘봉 및 설명서는 모두 메보크 미지릭스 근처에 있습니다."
Inst24Quest1_Prequest = "없음"
Inst24Quest1_Folgequest = "없음"
--
Inst24Quest1name1 = "보석 상자"

--Quest 2 Alliance
Inst24Quest2 = "2. 꺼져가는 생명의 불씨" -- Mortality Wanes
Inst24Quest2_Aim = "트레샬라의 펜던트를 찾아 다르나서스에 있는 트레샬라 팰로우브룩에게 돌려주어야 합니다."
Inst24Quest2_Location = "헤랄라스 팰로우브룩 (가시덩굴 우리; "..YELLOW.."[8]"..WHITE..")"
Inst24Quest2_Note = "펜던트는 무작위 드랍 입니다.  트레샬라 팰로우브룩에게 펜던트를 가져가야 합니다. (다르나서스 - 상인의 정원; "..YELLOW.."69.4, 67.4"..WHITE..")."
Inst24Quest2_Prequest = "없음"
Inst24Quest2_Folgequest = "없음"
--
Inst24Quest2name1 = "애도의 망토"
Inst24Quest2name2 = "창기병 장화"

--Quest 3 Alliance
Inst24Quest3 = "3. 수입업자 윌릭스" -- Willix the Importer
Inst24Quest3_Aim = "수입업자 윌릭스를 호위해 가시덩굴 우리에서 나가야 합니다."
Inst24Quest3_Location = "수입업자 윌릭스 (가시덩굴 우리; "..YELLOW.."[8]"..WHITE..")"
Inst24Quest3_Note = "수입업자 윌릭스를 던전 입구로 호위해야 합니다.  퀘스트가 완료되면 그에게 완료해야 합니다."
Inst24Quest3_Prequest = "없음"
Inst24Quest3_Folgequest = "없음"
--
Inst24Quest3name1 = "원숭이 반지"
Inst24Quest3name2 = "뱀고리"
Inst24Quest3name3 = "호랑이 고리"

--Quest 4 Alliance
Inst24Quest4 = "4. 가시덩굴 우리의 대모" -- The Crone of the Kraul
Inst24Quest4_Aim = "탈라나르에 있는 팔핀델 웨이워더에게 차를가의 메달을 가져가야 합니다."
Inst24Quest4_Location = "팔핀델 웨이워더 (페랄라스 - 탈라나르; "..YELLOW.."89.6, 46.4"..WHITE..")"
Inst24Quest4_Note = "서슬깃 차를가 "..YELLOW.."[7]"..WHITE.." 이 퀘스트에 필요한 메달을 드랍합니다."
Inst24Quest4_Prequest = "론브로우의 일지"
Inst24Quest4_Folgequest = "없음"
--
Inst24Quest4name1 = "˝백발백중˝ 나팔총"
Inst24Quest4name2 = "담녹색 어깨보호대"
Inst24Quest4name3 = "돌주먹 벨트"
Inst24Quest4name4 = "대리석 버클러"

--Quest 5 Alliance
Inst24Quest5 = "5. 불에 달궈 만든 갑옷" -- Fire Hardened Mail
Inst24Quest5_Aim = "스톰윈드에 있는 푸렌 롱비어드에게 그가 필요로 하는 재료들을 모아서 가져가야 합니다."
Inst24Quest5_Location = "푸렌 롱비어드 (스톰윈드 - 드워프 지구; "..YELLOW.."58.0, 16.8"..WHITE..")"
Inst24Quest5_Note = "전사 퀘스트.  루구르에게 "..YELLOW.."[1]"..WHITE.." 연소 약병을 얻을 수 있습니다.\n\n 다음 연퉤는 각 종족마다 다릅니다. 인간을 위한 불타는 혈액, 드워프와 노움은 위한 철산호 그리고 나이트 엘프를 위한 바짝 마른 알껍질로 이어 집니다."
Inst24Quest5_Prequest = "방패 상인"
Inst24Quest5_Folgequest = "(참고 참조)"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst24Quest1_HORDE = Inst24Quest1
Inst24Quest1_HORDE_Aim = Inst24Quest1_Aim
Inst24Quest1_HORDE_Location = Inst24Quest1_Location
Inst24Quest1_HORDE_Note = Inst24Quest1_Note
Inst24Quest1_HORDE_Prequest = Inst24Quest1_Prequest
Inst24Quest1_HORDE_Folgequest = Inst24Quest1_Folgequest
--
Inst24Quest1name1_HORDE = Inst24Quest1name1

--Quest 2 Horde  (same as Quest 3 Alliance)
Inst24Quest2_HORDE = "2. 수입업자 윌릭스" -- Willix the Importer
Inst24Quest2_HORDE_Aim = Inst24Quest3_Aim
Inst24Quest2_HORDE_Location = Inst24Quest3_Location
Inst24Quest2_HORDE_Note = Inst24Quest3_Note
Inst24Quest2_HORDE_Prequest = Inst24Quest3_Prequest
Inst24Quest2_HORDE_Folgequest = Inst24Quest3_Folgequest
--
Inst24Quest2name1_HORDE = Inst24Quest3name1
Inst24Quest2name2_HORDE = Inst24Quest3name2
Inst24Quest2name3_HORDE = Inst24Quest3name3

-- Quest 3 Horde
Inst24Quest3_HORDE = "3. 조분석을 나에게!" -- Going, Going, Guano!
Inst24Quest3_HORDE_Aim = "언더시티에 있는 수석 연금술사 파라넬에게 가시덩굴 조분석을 가져가야 합니다."
Inst24Quest3_HORDE_Location = "수석 연금술사 파라넬 (언더시티 - 연금술 실험실; "..YELLOW.."48.4, 69.4 "..WHITE..")"
Inst24Quest3_HORDE_Note = "가시덩굴 조분석 던전에서 발견되는 박쥐에 의해 드랍됩니다."
Inst24Quest3_HORDE_Prequest = "없음"
Inst24Quest3_HORDE_Folgequest = "열정의 증거 ("..YELLOW.."[붉은십자군 수도원]"..WHITE..")"
-- No Rewards for this quest

--Quest 4 Horde
Inst24Quest4_HORDE = "4. 운명의 복수" -- A Vengeful Fate
Inst24Quest4_HORDE_Aim = "썬더 블러프에 있는 아울드 스톤스파이어에게 차를가의 심장을 가져가야 합니다."
Inst24Quest4_HORDE_Location = "아울드 스톤스파이어 (썬더 블러프; "..YELLOW.."36.2, 59.8"..WHITE..")"
Inst24Quest4_HORDE_Note = "서슬깃 차를가는 "..YELLOW.."[7]"..WHITE.." 에서 찾을 수 있습니다."
Inst24Quest4_HORDE_Prequest = "없음"
Inst24Quest4_HORDE_Folgequest = "없음"
--
Inst24Quest4name1_HORDE = "담녹색 어깨보호대"
Inst24Quest4name2_HORDE = "돌주먹 벨트"
Inst24Quest4name3_HORDE = "대리석 버클러"

--Quest 5 Horde
Inst24Quest5_HORDE = "5. 투사의 방어구" -- Brutal Armor
Inst24Quest5_HORDE_Aim = "툰그림 파이어게이즈에게 연기나는 철제 주괴 15개, 아주라이트 가루 10개, 철 주괴 10개, 연소 약병 1개를 가져가야 합니다."
Inst24Quest5_HORDE_Location = "툰그림 파이어게이즈 (불모의 땅; "..YELLOW.."57.2, 30.2"..WHITE..")"
Inst24Quest5_HORDE_Note = "전사 퀘스트.  루구르에게 "..YELLOW.."[1]"..WHITE.." 연소 약병을 얻을 수 있습니다..\n\n이 퀘스트를 완료하면 동일한 NPC에서 4개의 새로운 퀘스트를 시작할 수 있습니다."
Inst24Quest5_HORDE_Prequest = "툰그림과의 대화"
Inst24Quest5_HORDE_Folgequest = "(참고 참조)"
-- No Rewards for this quest



--------------- INST25 - Wailing Caverns 통곡의 동굴 ---------------

Inst25Caption = "통곡의 동굴"
Inst25QAA = "5 퀘스트"
Inst25QAH = "7 퀘스트"

--Quest 1 Alliance
Inst25Quest1 = "1. 돌연변이 통가죽" -- Deviate Hides
Inst25Quest1_Aim = "통곡의 동굴에 있는 날팍이 돌연변이 통가죽 20개를 가져다 달라고 부탁했습니다."
Inst25Quest1_Location = "날팍 (불모의 땅 - 통곡의 동굴; "..YELLOW.."47, 36"..WHITE..")"
Inst25Quest1_Note = "던전 입구에 앞에 모든 몬스터들은 가죽을 드랍 할수 있습니다.\n날팍은 실제 동굴 입구 위의 숨겨진 동굴에서 찾을 수 있습니다.  그에게 가는 쉬운 방법은 입구 외부와 뒤에 언덕을 올라 동굴 입구 위의 약간 난간으로 떨어 지는것 같습니다."
Inst25Quest1_Prequest = "없음"
Inst25Quest1_Folgequest = "없음"
--
Inst25Quest1name1 = "돌연변이 가죽 다리보호구"
Inst25Quest1name2 = "돌연변이 통가죽 배낭"

--Quest 2 Alliance
Inst25Quest2 = "2. 99년 묵은 와인" -- Trouble at the Docks
Inst25Quest2_Aim = "톱니항에 있는 기중기 기사 비글퍼즈가 통곡의 동굴에 숨어 있는 광기의 매글리시에게서 99년 숙성된 포트 와인을 되찾아 달라고 부탁했습니다."
Inst25Quest2_Location = "기중기 기사 비글퍼즈 (불모의 땅 - 톱니항; "..YELLOW.."63.0, 37.6"..WHITE..")"
Inst25Quest2_Note = "던전 들어가기 전 입구에서 광기의 매글리쉬는 처치하고 와인을 얻을 수 있습니다.  동굴에 처음 들어가면 통로 끝에서 그를 찾을 수 있고 선점 하세요. 그는 벽쪽에 은신하고 있다."
Inst25Quest2_Prequest = "없음"
Inst25Quest2_Folgequest = "없음"
-- No Rewards for this quest

--Quest 3 Alliance
Inst25Quest3 = "3. 영리해지는 음료" -- Smart Drinks
Inst25Quest3_Aim = "톱니항에 있는 메보크 미지릭스에게 통곡의 정수 6병을 가져가야 합니다."
Inst25Quest3_Location = "메보크 미지릭스 (불모의 땅 - 톱니항; "..YELLOW.."62.4, 37.6"..WHITE..")"
Inst25Quest3_Note = "선행 퀘스트는 메보크 미지릭스에게 받을 수 있습니다.\n던전 안팎의 모든 외형질 생물은 정수를 드랍 합니다."
Inst25Quest3_Prequest = "랩터 뿔"
Inst25Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst25Quest4 = "4. 돌연변이 짐승 섬멸" -- Deviate Eradication
Inst25Quest4_Aim = "통곡의 동굴에 있는 에브루가 돌연변이 약탈자랩터 7마리, 돌연변이 독사 7마리, 돌연변이 늪괴물 7마리, 돌연변이 송곳니천둥매 7마리를 처치해 달라고 했습니다."
Inst25Quest4_Location = "에브루 (불모의 땅 - 통곡의 동굴; "..YELLOW.."47, 36"..WHITE..")"
Inst25Quest4_Note = "에브루는 동굴 입구 위의 숨겨진 동굴에 있습니다.  그에게 가는 쉬운 방법은 입구 외부와 뒤에 언덕을 올라 동굴 입구 위의 약간 난간으로 떨어 지는것 같습니다."
Inst25Quest4_Prequest = "없음"
Inst25Quest4_Folgequest = "없음"
--
Inst25Quest4name1 = "도안: 돌연변이 비늘 허리띠"
Inst25Quest4name2 = "불타는 나뭇가지"
Inst25Quest4name3 = "수렁늪 건틀릿"

--Quest 5 Alliance
Inst25Quest5 = "5. 빛나는 조각" -- The Glowing Shard
Inst25Quest5_Aim = "톱니항으로 가서 빛나는 조각에 대해 자세히 얘기해 줄 수 있는 이를 찾으십시오. 그에게 지시를 받아, 빛나는 조각을 전달해야 합니다."
Inst25Quest5_Location = "빛나는 조각 (걸신들린 무타누스로 부터 드랍; "..YELLOW.."[9]"..WHITE..")"
Inst25Quest5_Note = "4명의 지도자 드루이드를 죽이고 입구에 있는 타우렌 드루이드를 호위해야 걸신들린 무타누스가 나타납니다. \n조각을 가지게 되면, 당신은 그것을 톱니항에 은행으로 가져오고, 그런 다음 통곡의 동굴 언덕 위에 팔라 세이지윈드에게 가져가야 합니다. (불모의 땅; "..YELLOW.."48.2, 32.8"..WHITE..")."
Inst25Quest5_Prequest = "없음"
Inst25Quest5_Folgequest = "악몽"
--
Inst25Quest5name1 = "탈바르 어깨보호대"
Inst25Quest5name2 = "습지대 장화"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst25Quest1_HORDE = Inst25Quest1
Inst25Quest1_HORDE_Aim = Inst25Quest1_Aim
Inst25Quest1_HORDE_Location = Inst25Quest1_Location
Inst25Quest1_HORDE_Note = Inst25Quest1_Note
Inst25Quest1_HORDE_Prequest = Inst25Quest1_Prequest
Inst25Quest1_HORDE_Folgequest = Inst25Quest1_Folgequest
--
Inst25Quest1name1_HORDE = Inst25Quest1name1
Inst25Quest1name2_HORDE = Inst25Quest1name2

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst25Quest2_HORDE = Inst25Quest2
Inst25Quest2_HORDE_Aim = Inst25Quest2_Aim
Inst25Quest2_HORDE_Location = Inst25Quest2_Location
Inst25Quest2_HORDE_Note = Inst25Quest2_Note
Inst25Quest2_HORDE_Prequest = Inst25Quest2_Prequest
Inst25Quest2_HORDE_Folgequest = Inst25Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde
Inst25Quest3_HORDE = "3. 불뱀꽃" -- Serpentbloom
Inst25Quest3_HORDE_Aim = "썬더 블러프에 있는 연금술사 자마가 불뱀꽃 10개를 모아 달라고 부탁했습니다."
Inst25Quest3_HORDE_Location = "연금술사 자마 (썬더 블러프 - 정기의 봉우리; "..YELLOW.."23.0, 21.0"..WHITE..")"
Inst25Quest3_HORDE_Note = "연금술사 자마는 정기의 봉우리 아래 동굴에 있습니다.  선행 퀘스트는 연금술사 헬브림에게 받을 수 있습니다. (불모의 땅 - 크로스로드; "..YELLOW.."51.4, 30.2"..WHITE..").\n던전 입구와 던전 내부의 동굴에서 불뱀꽃이 있습니다.  약초채집을 가진 플레이어는 미니맵에서 식물을 볼 수 있습니다."
Inst25Quest3_HORDE_Prequest = "버섯 포자 -> 연금술사 자마"
Inst25Quest3_HORDE_Folgequest = "없음"
--
Inst25Quest3name1_HORDE = "약제사 장갑"

--Quest 4 Horde  (same as Quest 3 Alliance)
Inst25Quest4_HORDE = "4. 영리해지는 음료" --Smart Drinks
Inst25Quest4_HORDE_Aim = Inst25Quest3_Aim
Inst25Quest4_HORDE_Location = Inst25Quest3_Location
Inst25Quest4_HORDE_Note = Inst25Quest3_Note
Inst25Quest4_HORDE_Prequest = Inst25Quest3_Prequest
Inst25Quest4_HORDE_Folgequest = Inst25Quest3_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 4 Alliance)
Inst25Quest5_HORDE = "5. 돌연변이 짐승 섬멸" -- 5. Deviate Eradication
Inst25Quest5_HORDE_Aim = Inst25Quest4_Aim
Inst25Quest5_HORDE_Location = Inst25Quest4_Location
Inst25Quest5_HORDE_Note = Inst25Quest4_Note
Inst25Quest5_HORDE_Prequest = Inst25Quest4_Prequest
Inst25Quest5_HORDE_Folgequest = Inst25Quest4_Folgequest
--
Inst25Quest5name1_HORDE = Inst25Quest4name1
Inst25Quest5name2_HORDE = Inst25Quest4name2
Inst25Quest5name3_HORDE = Inst25Quest4name3

--Quest 6 Horde
Inst25Quest6_HORDE = "6. 송곳니의 드루이드 우두머리" -- Leaders of the Fang
Inst25Quest6_HORDE_Aim = "코브란, 아나콘드라, 피타스, 서펜티스의 보석을 모아 썬더 블러프에 있는 나라 와일드메인에게 돌아가야 합니다."
Inst25Quest6_HORDE_Location = "나라 와일드메인 (썬더 블러프 - 장로의 봉우리; "..YELLOW.."75.6, 31.2"..WHITE..")"
Inst25Quest6_HORDE_Note = "퀘스트 라인은 대드루이드 하뮬 룬토템에서 시작 됩니다. (썬더 블러프 - 장로의 봉우리; "..YELLOW.."78.4, 28.4"..WHITE..")\n4명의 드루이드 보스가 보석을 드랍 - 군주 코브란 "..YELLOW.."[2]"..WHITE..", 여군주 아나콘드라 "..YELLOW.."[3]"..WHITE..", 군주 피타스 "..YELLOW.."[5]"..WHITE.." 와 군주 서펜티스 "..YELLOW.."[7]"..WHITE.."."
Inst25Quest6_HORDE_Prequest = "푸른 오아시스 -> 나라 와일드메인"
Inst25Quest6_HORDE_Folgequest = "없음"
--
Inst25Quest6name1_HORDE = "초승달 지팡이"
Inst25Quest6name2_HORDE = "날개검"

--Quest 7 Horde  (same as Quest 5 Alliance)
Inst25Quest7_HORDE = "7. 빛나는 조각" -- The Glowing Shard
Inst25Quest7_HORDE_Aim = Inst25Quest5_Aim
Inst25Quest7_HORDE_Location = Inst25Quest5_Location
Inst25Quest7_HORDE_Note = Inst25Quest5_Note
Inst25Quest7_HORDE_Prequest = Inst25Quest5_Prequest
Inst25Quest7_HORDE_Folgequest = Inst25Quest5_Folgequest
--
Inst25Quest7name1_HORDE = Inst25Quest5name1
Inst25Quest7name2_HORDE = Inst25Quest5name2



--------------- INST26 - Zul'Farrak 줄파락 ---------------

Inst26Caption = "줄파락"
Inst26QAA = "7 퀘스트"
Inst26QAH = "7 퀘스트"

--Quest 1 Alliance
Inst26Quest1 = "1. 트롤 경화제" -- Troll Temper
Inst26Quest1_Aim = "가젯잔에 있는 트렌튼 라이트해머에게 트롤 경화제 20병을 가져가야 합니다."
Inst26Quest1_Location = "트렌튼 라이트해머 (타나리스 - 가젯잔; "..YELLOW.."51.4, 28.6"..WHITE..")"
Inst26Quest1_Note = "모든 트롤은 트롤 경화제를 드랍 할 수 있습니다."
Inst26Quest1_Prequest = "없음"
Inst26Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst26Quest2 = "2. 왕쇠똥구리 껍질" -- Scarab Shells
Inst26Quest2_Aim = "가젯잔에 있는 트란렉에게 온전한 왕쇠똥구리 껍질 5개를 가져가야 합니다."
Inst26Quest2_Location = "트란렉 (타나리스 - 가젯잔; "..YELLOW.."51.6, 26.8"..WHITE..")"
Inst26Quest2_Note = "선행 퀘스트는 크라젝에서 시작됩니다. (가시덤불 골짜기 - 무법항; "..YELLOW.."27.0, 77.2"..WHITE..").\n모든 쇠똥구리는 껍질을 드랍 할 수 있습니다.  당신은 많은 쇠똥구리를 "..YELLOW.."[2]"..WHITE.." 찾을 수 있습니다."
Inst26Quest2_Prequest = "트란렉"
Inst26Quest2_Folgequest = "없음"
-- No Rewards for this quest

--Quest 3 Alliance
Inst26Quest3 = "3. 심연의 티아라" -- Tiara of the Deep
Inst26Quest3_Aim = "먼지진흙 습지대에 있는 타베사에게 심연의 티아라를 가져가야 합니다."
Inst26Quest3_Location = "타베사 (먼지진흙 습지대; "..YELLOW.."46.0, 57.0"..WHITE..")"
Inst26Quest3_Note = "선행 퀘스트는 빙크에게 받을 수 있습니다. (아이언포지 - 마법사 지구; "..YELLOW.."27.0, 8.2"..WHITE..").\n유체술사 벨라타는 "..YELLOW.."[6]"..WHITE.." 심연의 티아라를 드랍합니다.."
Inst26Quest3_Prequest = "Tabetha's Task"
Inst26Quest3_Folgequest = "없음"
--
Inst26Quest3name1 = "주술 마법봉"
Inst26Quest3name2 = "혈암 어깨갑옷"

--Quest 4 Alliance
Inst26Quest4 = "4. 네크룸의 메달" -- Nekrum's Medallion
Inst26Quest4_Aim = "네크룸의 메달을 저주받은 땅에 있는 샤디우스 그림셰이드에게 가져가야 합니다."
Inst26Quest4_Location = "샤디우스 그림섀이드 (저주받은 땅 - 너더가드 요새; "..YELLOW.."67.0, 19.4"..WHITE..")"
Inst26Quest4_Note = "퀘스트 라인은 그리핀 조련사 탈론액스에서 시작 됩니다. (동부 내륙지 - 와일드해머 요새; "..YELLOW.."9.8, 44.4"..WHITE..").\n네크룸 거트츄어는 "..YELLOW.."[4]"..WHITE.." 사원 행사 마지막에 싸우는 군중과 함께 나타납니다."
Inst26Quest4_Prequest = "마른나무껍질부족 우리 -> 샤디우스 그림섀이드"
Inst26Quest4_Folgequest = "점치기"
-- No Rewards for this quest

--Quest 5 Alliance
Inst26Quest5 = "5. 모쉬아루의 예언" -- The Prophecy of Mosh'aru
Inst26Quest5_Aim = "타나리스에 있는 예킨야에게 첫번째 모쉬아루 서판과 두번째 모쉬아루 서판을 가져가야 합니다."
Inst26Quest5_Location = "예킨야 (타나리스 - 스팀휘들 항구; "..YELLOW.."67.0, 22.4"..WHITE..")"
Inst26Quest5_Note = "동일한 NPC에서 선행 퀘스트를 받습니다.\n서판은 순교자 데카 "..YELLOW.."[2]"..WHITE.." 그리고 유체술사 벨라타 "..YELLOW.."[6]"..WHITE.." 에서 드랍합니다."
Inst26Quest5_Prequest = "계곡천둥매의 영혼"
Inst26Quest5_Folgequest = "고대의 알"
-- No Rewards for this quest

--Quest 6 Alliance
Inst26Quest6 = "6. 자동 탐사막대" -- Divino-matic Rod
Inst26Quest6_Aim = "가젯잔에 있는 선임기술자 빌지위즐에게 자동 탐사막대를 가져가야 합니다."
Inst26Quest6_Location = "선임기술자 빌지위즐 (타나리스 - 가젯잔; "..YELLOW.."52.4, 28.4"..WHITE..")"
Inst26Quest6_Note = "하사관 블라이에게서 막대를 얻습니다.  사원 행사 후에 "..YELLOW.."[4]"..WHITE.." 그것을 찾을 수 있습니다."
Inst26Quest6_Prequest = "없음"
Inst26Quest6_Folgequest = "없음"
--
Inst26Quest6name1 = "석공 조합 반지"
Inst26Quest6name2 = "기술자 조합 모자"

--Quest 7 Alliance
Inst26Quest7 = "7. 가즈릴라" -- Gahz'rilla
Inst26Quest7_Aim = "소금 평원에 있는 위즐 브라스볼츠에게 가즈릴라의 전기 비늘을 가져가야 합니다."
Inst26Quest7_Location = "위즐 브라스볼츠 (버섯구름 봉우리 - 신기루 경주장; "..YELLOW.."78.0, 77.0"..WHITE..")"
Inst26Quest7_Note = "선택적인 선행 퀘스트는 클락몰트 스패너스판에서 받을 수 있습니다. (아이언포지 - 땜장이 마을; "..YELLOW.."68.2, 46.2"..WHITE..").\n가즈릴라는 "..YELLOW.."[6]"..WHITE.." 징을 두드리면 소환됩니다.  파티원에게 줄파락의 나무망치가 있어야 합니다."
Inst26Quest7_Prequest = "브라스볼츠 형제"
Inst26Quest7_Folgequest = "없음"
--
Inst26Quest7name1 = "당근 달린 지팡이"


--Quest 1 Horde
Inst26Quest1_HORDE = "1. 거미 신" -- The Spider God
Inst26Quest1_HORDE_Aim = "데카의 서판을 읽고 마른나무껍질부족 거미 신의 이름을 알아낸 후, 가드린 장로에게 돌아가십시오."
Inst26Quest1_HORDE_Location = "장로 가드린 (듀로타 - 센진 마을; "..YELLOW.."56.0, 74.6"..WHITE..")"
Inst26Quest1_HORDE_Note = "퀘스트 라인은 독병에서 시작 됩니다. 동부 내륙지의 트롤 마을 테이블에서 발견됩니다.\n서판은 "..YELLOW.."[2]"..WHITE.." 에서 찾을 수 있습니다."
Inst26Quest1_HORDE_Prequest = "독병 -> 가드린 장로와 상의"
Inst26Quest1_HORDE_Folgequest = "샤드라 소환"
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 1 Alliance)
Inst26Quest2_HORDE = "2. 트롤 경화제" -- Troll Temper
Inst26Quest2_HORDE_Aim = Inst26Quest1_Aim
Inst26Quest2_HORDE_Location = Inst26Quest1_Location
Inst26Quest2_HORDE_Note = Inst26Quest1_Note
Inst26Quest2_HORDE_Prequest = Inst26Quest1_Prequest
Inst26Quest2_HORDE_Folgequest = Inst26Quest1_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 2 Alliance)
Inst26Quest3_HORDE = "3. 왕쇠똥구리 껍질" -- Scarab Shells
Inst26Quest3_HORDE_Aim = Inst26Quest2_Aim
Inst26Quest3_HORDE_Location = Inst26Quest2_Location
Inst26Quest3_HORDE_Note = Inst26Quest2_Note
Inst26Quest3_HORDE_Prequest = Inst26Quest2_Prequest
Inst26Quest3_HORDE_Folgequest = Inst26Quest2_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 3 Alliance - no prequest)
Inst26Quest4_HORDE = "4. 심연의 티아라" -- Tiara of the Deep
Inst26Quest4_HORDE_Aim = Inst26Quest3_Aim
Inst26Quest4_HORDE_Location = Inst26Quest3_Location
Inst26Quest4_HORDE_Note = "유체술사 벨라타는 "..YELLOW.."[6]"..WHITE.." 심연의 티아라를 드랍합니다."
Inst26Quest4_HORDE_Prequest = "없음"
Inst26Quest4_HORDE_Folgequest = Inst26Quest3_Folgequest
--
Inst26Quest4name1_HORDE = Inst26Quest3name1
Inst26Quest4name2_HORDE = Inst26Quest3name2

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst26Quest5_HORDE = Inst26Quest5
Inst26Quest5_HORDE_Aim = Inst26Quest5_Aim
Inst26Quest5_HORDE_Location = Inst26Quest5_Location
Inst26Quest5_HORDE_Note = Inst26Quest5_Note
Inst26Quest5_HORDE_Prequest = Inst26Quest5_Prequest
Inst26Quest5_HORDE_Folgequest = Inst26Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst26Quest6_HORDE = Inst26Quest6
Inst26Quest6_HORDE_Aim = Inst26Quest6_Aim
Inst26Quest6_HORDE_Location = Inst26Quest6_Location
Inst26Quest6_HORDE_Note = Inst26Quest6_Note
Inst26Quest6_HORDE_Prequest = Inst26Quest6_Prequest
Inst26Quest6_HORDE_Folgequest = Inst26Quest6_Folgequest
--
Inst26Quest6name1_HORDE = Inst26Quest6name1
Inst26Quest6name2_HORDE = Inst26Quest6name2

--Quest 7 Horde  (same as Quest 7 Alliance - no prequest)
Inst26Quest7_HORDE = Inst26Quest7
Inst26Quest7_HORDE_Aim = Inst26Quest7_Aim
Inst26Quest7_HORDE_Location = Inst26Quest7_Location
Inst26Quest7_HORDE_Note = "가즈릴라는 "..YELLOW.."[6]"..WHITE.." 징을 두드리면 소환됩니다.  파티원에게 줄파락의 나무망치가 있어야 합니다."
Inst26Quest7_HORDE_Prequest = "없음"
Inst26Quest7_HORDE_Folgequest = Inst26Quest7_Folgequest
--
Inst26Quest7name1_HORDE = Inst26Quest7name1



--------------- INST27 - Molten Core 화산 심장부 ---------------

Inst27Caption = "화산 심장부"
Inst27QAA = "7 퀘스트"
Inst27QAH = "7 퀘스트"

--Quest 1 Alliance
Inst27Quest1 = "1. 화산 심장부" -- The Molten Core
Inst27Quest1_Aim = "불의 군주 1마리, 용암거인 1마리, 고대의 심장부 사냥개 1마리, 굽이치는 용암 정령 1마리를 처치한 후 아즈샤라에 있는 군주 히드락시스에게 돌아가야 합니다."
Inst27Quest1_Location = "군주 히드락시스 (아즈샤라; "..YELLOW.."79.2, 73.6"..WHITE..")"
Inst27Quest1_Note = "이들은 화산 심장부 내부에서 발견되는 정예 몬스터 입니다."
Inst27Quest1_Prequest = "엠버시어의 눈 ("..YELLOW.."검은바위 첨탑 상층"..WHITE..")"
Inst27Quest1_Folgequest = "히드락시스의 하수인"
-- No Rewards for this quest

--Quest 2 Alliance
Inst27Quest2 = "2. 적의 손" -- Hands of the Enemy
Inst27Quest2_Aim = "아즈샤라에 있는 군주 히드락시스에게 루시프론, 설퍼론, 게헨나스, 샤즈라의 손을 가져가야 합니다."
Inst27Quest2_Location = "군주 히드락시스 (아즈샤라; "..YELLOW.."79.2, 73.6"..WHITE..")"
Inst27Quest2_Note = "루시프론은 "..YELLOW.."[1]"..WHITE..", 설퍼론은 "..YELLOW.."[8]"..WHITE..", 게헨나스는 "..YELLOW.."[3]"..WHITE.." 그리고 샤즈라는 "..YELLOW.."[5]"..WHITE..".  다음의 퀘스트에 대한 보상이 제공됩니다."
Inst27Quest2_Prequest = "엠버시어의 눈 -> 히드락시스의 하수인"
Inst27Quest2_Folgequest = "영웅의 보상"
--
Inst27Quest2name1 = "대양의 바람"
Inst27Quest2name2 = "해일의 고리"

--Quest 3 Alliance
Inst27Quest3 = "3. 바람추적자 썬더란" -- Thunderaan the Windseeker
Inst27Quest3_Aim = "바람추적자 썬더란을 감옥에서 해방시키려면 실리더스에 있는 대영주 데미트리안에게 바람추적자의 족쇄의 오른쪽 조각과 왼쪽 조각, 엘레멘티움 주괴 10개, 그리고 불의 군주의 정수를 가져가야 합니다."
Inst27Quest3_Location = "대영주 데미트리안 (실리더스; "..YELLOW.."21.8, 8.6"..WHITE..")"
Inst27Quest3_Note = "우레폭풍 - 바람추적자의 성검 퀘스트라인.  가르 또는 남작 게돈에서 바람추적자의 족쇄 왼쪽 또는 오른쪽을 조각을 얻은 후 시작됩니다. 가르 "..YELLOW.."[4]"..WHITE.." 남작 게돈 "..YELLOW.."[6]"..WHITE..".  그런 다음 대영주 데이트리안에게 이야기하여 퀘스트를 시작하십시오.  라그라노스에서 불의 군주의 정수가 드랍합니다. "..YELLOW.."[10]"..WHITE..".  이후 재료를 합치면, 왕자 썬더란이 소환되며 그를 처치해야 합니다. 그는 40인 공격대 보스입니다."
Inst27Quest3_Prequest = "결정 조사"
Inst27Quest3_Folgequest = "일어나라, 우레폭풍이여!"
-- No Rewards for this quest

--Quest 4 Alliance
Inst27Quest4 = "4. 대장조합 계약서" -- A Binding Contract
Inst27Quest4_Aim = "설퍼론 도면을 받으려면 설퍼론 주괴와 토륨 대장조합 계약서를 로크토스 다크바게이너에게 가져가야 합니다."
Inst27Quest4_Location = "로크토스 다크바게이너 (검은바위 나락; "..YELLOW.."[15]"..WHITE..")"
Inst27Quest4_Note = "로크토스로 부터 계약을 받으려면 설퍼론 주괴가 필요합니다. 화산 심장부의 초열의 골레마그에서 드랍합니다. "..YELLOW.."[7]"..WHITE.."."
Inst27Quest4_Prequest = "없음"
Inst27Quest4_Folgequest = "없음"
--
Inst27Quest4name1 = "도면: 설퍼론 망치"

--Quest 5 Alliance
Inst27Quest5 = "5. 고대의 잎사귀" -- The Ancient Leaf
Inst27Quest5_Aim = "단단한 고대의 잎사귀의 주인을 찾아야 합니다. 행운을 빕니다. 세상은 아주 넓으니까요."
Inst27Quest5_Location = "단단한 고대의 잎사귀 (불의 군주의 보물에서 드랍합니다.; "..YELLOW.."[9]"..WHITE..")"
Inst27Quest5_Note = "고대정령 바르투스로 바뀝니다. (악령의 숲 - 강철나무 숲; "..YELLOW.."48.8, 24.2"..WHITE..")."
Inst27Quest5_Prequest = "없음"
Inst27Quest5_Folgequest = "힘줄 감긴 고대의 잎주머니 ("..YELLOW.."아주어고스"..WHITE..")"
-- No Rewards for this quest

--Quest 6 Alliance
Inst27Quest6 = "6. 수정점 고글? 문제 없어요!" -- Scrying Goggles? No Problem!
Inst27Quest6_Aim = "나라인의 수정점 고글을 찾은 후, 타나리스에 있는 나라인 수스팬시에게 돌아가야 한다."
Inst27Quest6_Location = "눈에 잘 띄지 않는 상자 (은빛소나무 숲 - 그레이메인 성벽; "..YELLOW.."46.2, 86.6"..WHITE..")"
Inst27Quest6_Note = "퀘스트는 나라인 수스팬시로 변경되며 (타나리스; "..YELLOW.."65.2, 18.6"..WHITE.."), 선행 퀘스트를 획득할 수 있습니다."
Inst27Quest6_Prequest = "가장 절친했던 친구 스튜불"
Inst27Quest6_Folgequest = "없음"
--
Inst27Quest6name1 = "일급 회복 물약"

--Quest 7 Alliance   (same as BRD Quest 12)
Inst27Quest7 = "7. 심장부와의 조화" -- Attunement to the Core
Inst27Quest7_Aim = Inst1Quest12_Aim
Inst27Quest7_Location = Inst1Quest12_Location
Inst27Quest7_Note = "이는 화산 심장부 퀘스트 입니다.  핵 조각은 "..YELLOW.."검은바위 나락"..WHITE.." 에 "..YELLOW.."[23]"..WHITE..", 화산 심장부 포털과 매우 가깝습니다.  이 퀘스트를 완료한 후, 로소스 리프트웨이커와 이야기하거나 옆에 있는 창문을 통해 점프해 화산 심장부로 들어갈 수 있습니다."
Inst27Quest7_Prequest = Inst1Quest12_Prequest
Inst27Quest7_Folgequest = Inst1Quest12_Folgequest
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst27Quest1_HORDE = Inst27Quest1
Inst27Quest1_HORDE_Aim = Inst27Quest1_Aim
Inst27Quest1_HORDE_Location = Inst27Quest1_Location
Inst27Quest1_HORDE_Note = Inst27Quest1_Note
Inst27Quest1_HORDE_Prequest = Inst27Quest1_Prequest
Inst27Quest1_HORDE_Folgequest = Inst27Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst27Quest2_HORDE = Inst27Quest2
Inst27Quest2_HORDE_Aim = Inst27Quest2_Aim
Inst27Quest2_HORDE_Location = Inst27Quest2_Location
Inst27Quest2_HORDE_Note = Inst27Quest2_Note
Inst27Quest2_HORDE_Prequest = Inst27Quest2_Prequest
Inst27Quest2_HORDE_Folgequest = Inst27Quest2_Folgequest
--
Inst27Quest2name1_HORDE = Inst27Quest2name1
Inst27Quest2name2_HORDE = Inst27Quest2name2

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst27Quest3_HORDE = Inst27Quest3
Inst27Quest3_HORDE_Aim = Inst27Quest3_Aim
Inst27Quest3_HORDE_Location = Inst27Quest3_Location
Inst27Quest3_HORDE_Note = Inst27Quest3_Note
Inst27Quest3_HORDE_Prequest = Inst27Quest3_Prequest
Inst27Quest3_HORDE_Folgequest = Inst27Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst27Quest4_HORDE = Inst27Quest4
Inst27Quest4_HORDE_Aim = Inst27Quest4_Aim
Inst27Quest4_HORDE_Location = Inst27Quest4_Location
Inst27Quest4_HORDE_Note = Inst27Quest4_Note
Inst27Quest4_HORDE_Prequest = Inst27Quest4_Prequest
Inst27Quest4_HORDE_Folgequest = Inst27Quest4_Folgequest
--
Inst27Quest4name1_HORDE = Inst27Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst27Quest5_HORDE = Inst27Quest5
Inst27Quest5_HORDE_Aim = Inst27Quest5_Aim
Inst27Quest5_HORDE_Location = Inst27Quest5_Location
Inst27Quest5_HORDE_Note = Inst27Quest5_Note
Inst27Quest5_HORDE_Prequest = Inst27Quest5_Prequest
Inst27Quest5_HORDE_Folgequest = Inst27Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst27Quest6_HORDE = Inst27Quest6
Inst27Quest6_HORDE_Aim = Inst27Quest6_Aim
Inst27Quest6_HORDE_Location = Inst27Quest6_Location
Inst27Quest6_HORDE_Note = Inst27Quest6_Note
Inst27Quest6_HORDE_Prequest = Inst27Quest6_Prequest
Inst27Quest6_HORDE_Folgequest = Inst27Quest6_Folgequest
--
Inst27Quest6name1_HORDE = Inst27Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst27Quest7_HORDE = Inst27Quest7
Inst27Quest7_HORDE_Aim = Inst27Quest7_Aim
Inst27Quest7_HORDE_Location = Inst27Quest7_Location
Inst27Quest7_HORDE_Note = Inst27Quest7_Note
Inst27Quest7_HORDE_Prequest = Inst27Quest7_Prequest
Inst27Quest7_HORDE_Folgequest = Inst27Quest7_Folgequest



--------------- INST28 - Onyxia's Lair 오닉시아의 둥지 ---------------

Inst28Caption = "오닉시아의 둥지"
Inst28QAA = "2 퀘스트"
Inst28QAH = "2 퀘스트"

--Quest 1 Alliance
Inst28Quest1 = "1. 쿠엘세라 검 만들기" -- The Forging of Quel'Serrar
Inst28Quest1_Aim = "오닉시아가 달궈지지 않은 고대의 검에 화염 숨결을 내뿜도록 한 후, 달궈진 고대의 검을 뽑으십시오. 달궈진 고대의 검은 언제까지나 달구어져 있지 않으니 서둘러야 합니다.\n마지막 단계로 오닉시아의 시체에 달궈진 고대의 검을 꽂으십시오.\n이렇게 하면 쿠엘세라 검을 가질 수 있습니다."
Inst28Quest1_Location = "현자 리드로스 (혈투의 전장 서쪽; "..YELLOW.."[1] 도서관"..WHITE..")"
Inst28Quest1_Note = "체력이 10% ~ 15% 일 때 오닉시아 앞에 검을 사용해 꽂는다. 그녀가 브레스를 사용하면 검이 달궈집니다.  오닉시아를 처치하고 검을 루팅해서 습득하고 시체를 클릭해 검을 사용하십시오. 그러면 다음 퀘스트를 시작할 준비가 되었습니다."
Inst28Quest1_Prequest = "폴로르의 용사냥 개론 ("..YELLOW.."혈투의 전장 서쪽"..WHITE..") -> 쿠엘세라 검 만들기"
Inst28Quest1_Folgequest = "없음"
--
Inst28Quest1name1 = "쿠엘세라"

--Quest 2 Alliance
Inst28Quest2 = "2. 얼라이언스의 승리" -- Victory for the Alliance
Inst28Quest2_Aim = "오닉시아의 머리를 스톰윈드로 갖고 가서 국왕 바리안 린에게 보여주어야 합니다."
Inst28Quest2_Location = "오닉시아의 머리 (오닉시아에서 드랍; "..YELLOW.."[3]"..WHITE..")"
Inst28Quest2_Note = "대영주 볼바르 폴드라곤 (스톰윈드 - 스톰윈드 왕궁; "..YELLOW.."78.0, 18.0"..WHITE..") 에 있다. 공격대 한 명만이 아이템을 루팅 할 수 있으며 퀘스트는 캐릭터 당 한 번만 수행 할 수 있습니다.\n\n다음은 그것에 대한 보상입니다."
Inst28Quest2_Prequest = "없음"
Inst28Quest2_Folgequest = "대축제 -> 모험은 이제부터"
--
Inst28Quest2name1 = "오닉시아 피 부적"
Inst28Quest2name2 = "용사냥꾼의 인장"
Inst28Quest2name3 = "오닉시아 이빨 펜던트"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst28Quest1_HORDE = Inst28Quest1
Inst28Quest1_HORDE_Aim = Inst28Quest1_Aim
Inst28Quest1_HORDE_Location = Inst28Quest1_Location
Inst28Quest1_HORDE_Note = Inst28Quest1_Note
Inst28Quest1_HORDE_Prequest = Inst28Quest1_Prequest
Inst28Quest1_HORDE_Folgequest = Inst28Quest1_Folgequest
--
Inst28Quest1name1_HORDE = Inst28Quest1name1

--Quest 2 Horde
Inst28Quest2_HORDE = "2. 호드의 승리" -- Victory for the Horde
Inst28Quest2_HORDE_Aim = "오그리마에 있는 대족장 스랄에게 오닉시아의 머리를 보여줘야 합니다."
Inst28Quest2_HORDE_Location = "오닉시아의 머리 (오닉시아에서 드랍; "..YELLOW.."[3]"..WHITE..")"
Inst28Quest2_HORDE_Note = "스랄은 (오그리마 - 지혜의 골짜기; "..YELLOW.."32.0, 37.8"..WHITE..") 에 있다. 공격대 한 명만이 아이템을 루팅 할 수 있으며 퀘스트는 캐릭터 당 한 번만 수행 할 수 있습니다.\n\n다음은 그것에 대한 보상입니다."
Inst28Quest2_HORDE_Prequest = "없음"
Inst28Quest2_HORDE_Folgequest = "승리의 축제 -> 모험은 이제부터"
--
Inst28Quest2name1_HORDE = "오닉시아 피 부적"
Inst28Quest2name2_HORDE = "용사냥꾼의 인장"
Inst28Quest2name3_HORDE = "오닉시아 이빨 펜던트"



--------------- INST29 - Zul'Gurub 줄구룹 ---------------

Inst29Caption = "줄구룹"
Inst29QAA = "4 퀘스트"
Inst29QAH = "4 퀘스트"

--Quest 1 Alliance
Inst29Quest1 = "1. 머리카락 수집" -- A Collection of Heads
Inst29Quest1_Aim = "역술사의 머리카락 5개를 신성한 굴레에 묶은 후, 요잠바 섬에 있는 엑잘에게 구루바시 부족 머리카락으로된 전리품을 가져가야 합니다."
Inst29Quest1_Location = "엑잘 (가시덤블 골짜기 - 요잠바 섬; "..YELLOW.."15.2, 15.4"..WHITE..")"
Inst29Quest1_Note = "모든 사제를 루팅하세요."
Inst29Quest1_Prequest = "없음"
Inst29Quest1_Folgequest = "없음"
--
Inst29Quest1name1 = "쭈그러든 해골 허리띠"
Inst29Quest1name2 = "주름진 해골 허리띠"
Inst29Quest1name3 = "보존된 해골 허리띠"
Inst29Quest1name4 = "작은 해골 허리띠"

--Quest 2 Alliance
Inst29Quest2 = "2. 학카르의 심장" -- The Heart of Hakkar
Inst29Quest2_Aim = "요잠바 섬에 있는 몰소르에게 학카르의 심장을 가져가야 합니다."
Inst29Quest2_Location = "학카르의 심장 (학카르에서 드랍; "..YELLOW.."[11]"..WHITE..")"
Inst29Quest2_Note = "몰소르 (가시덤불 골짜기 - 요잠바 섬; "..YELLOW.."15.0, 15.2"..WHITE..")"
Inst29Quest2_Prequest = "없음"
Inst29Quest2_Folgequest = "없음"
--
Inst29Quest2name1 = "잔달라의 영웅 휘장"
Inst29Quest2name2 = "잔달라의 영웅 부적"
Inst29Quest2name3 = "잔달라의 영웅 메달"

--Quest 3 Alliance
Inst29Quest3 = "3. 내트의 줄자" -- Nat's Measuring Tape
Inst29Quest3_Aim = "먼지진흙 습지대에 있는 내트 페이글에게 내트의 줄자를 돌려줘야 합니다."
Inst29Quest3_Location = "찌그러진 낚시상자 (줄구룹 - 학카르 섬 북동쪽 물가)"
Inst29Quest3_Note = "내트 페이글은 먼지진흙 습지대 ("..YELLOW.."59, 60"..WHITE..") 에 있다. 퀘스트를 진행하면 내트페이글에게 진흙노린재 미끼를 구매하여 줄구룹에서 가즈란카를 소환할 수 있습니다."
Inst29Quest3_Prequest = "없음"
Inst29Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst29Quest4 = "4. 완벽한 독" -- The Perfect Poison
Inst29Quest4_Aim = "세나리온 요새에 있는 더크 썬더우드가 베녹시스의 독주머니와 쿠린낙스의 독주머니를 가져다달라고 부탁했습니다."
Inst29Quest4_Location = "더크 썬더우드 (실리더스 - 세나리온 요새; "..YELLOW.."52, 39"..WHITE..")"
Inst29Quest4_Note = "대사제 베녹시스에서 베녹시스의 독주머니 드랍 "..YELLOW.."줄구룹"..WHITE.." 에서 "..YELLOW.."[2]"..WHITE..". 쿠린낙스에서 쿠린낙스의 독주머니 드랍 "..YELLOW.."안퀴라즈 폐허"..WHITE.." 에서 "..YELLOW.."[1]"..WHITE.."."
Inst29Quest4_Prequest = "없음"
Inst29Quest4_Folgequest = "없음"
--
Inst29Quest4name1 = "라벤홀트 학살자"
Inst29Quest4name2 = "쉬브스프로켓의 비수"
Inst29Quest4name3 = "썬더우드 천둥검"
Inst29Quest4name4 = "루날의 습기망치"
Inst29Quest4name5 = "파라드의 연발 석궁"
Inst29Quest4name6 = "시몬의 교화 망치"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst29Quest1_HORDE = Inst29Quest1
Inst29Quest1_HORDE_Aim = Inst29Quest1_Aim
Inst29Quest1_HORDE_Location = Inst29Quest1_Location
Inst29Quest1_HORDE_Note = Inst29Quest1_Note
Inst29Quest1_HORDE_Prequest = Inst29Quest1_Prequest
Inst29Quest1_HORDE_Folgequest = Inst29Quest1_Folgequest
--
Inst29Quest1name1_HORDE = Inst29Quest1name1
Inst29Quest1name2_HORDE = Inst29Quest1name2
Inst29Quest1name3_HORDE = Inst29Quest1name3
Inst29Quest1name4_HORDE = Inst29Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst29Quest2_HORDE = Inst29Quest2
Inst29Quest2_HORDE_Aim = Inst29Quest2_Aim
Inst29Quest2_HORDE_Location = Inst29Quest2_Location
Inst29Quest2_HORDE_Note = Inst29Quest2_Note
Inst29Quest2_HORDE_Prequest = Inst29Quest2_Prequest
Inst29Quest2_HORDE_Folgequest = Inst29Quest2_Folgequest
--
Inst29Quest2name1_HORDE = Inst29Quest2name1
Inst29Quest2name2_HORDE = Inst29Quest2name2
Inst29Quest2name3_HORDE = Inst29Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst29Quest3_HORDE = Inst29Quest3
Inst29Quest3_HORDE_Aim = Inst29Quest3_Aim
Inst29Quest3_HORDE_Location = Inst29Quest3_Location
Inst29Quest3_HORDE_Note = Inst29Quest3_Note
Inst29Quest3_HORDE_Prequest = Inst29Quest3_Prequest
Inst29Quest3_HORDE_Folgequest = Inst29Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst29Quest4_HORDE = Inst29Quest4
Inst29Quest4_HORDE_Aim = Inst29Quest4_Aim
Inst29Quest4_HORDE_Location = Inst29Quest4_Location
Inst29Quest4_HORDE_Note = Inst29Quest4_Note
Inst29Quest4_HORDE_Prequest = Inst29Quest4_Prequest
Inst29Quest4_HORDE_Folgequest = Inst29Quest4_Folgequest
--
Inst29Quest4name1_HORDE = Inst29Quest4name1
Inst29Quest4name2_HORDE = Inst29Quest4name2
Inst29Quest4name3_HORDE = Inst29Quest4name3
Inst29Quest4name4_HORDE = Inst29Quest4name4
Inst29Quest4name5_HORDE = Inst29Quest4name5
Inst29Quest4name6_HORDE = Inst29Quest4name6



--------------- INST30 - The Ruins of Ahn'Qiraj (AQ20) 안퀴라즈 폐허 ---------------

Inst30Caption = "안퀴라즈 폐허"
Inst30QAA = "2 퀘스트"
Inst30QAH = "2 퀘스트"

--Quest 1 Alliance
Inst30Quest1 = "1. 오시리안 처치" -- The Fall of Ossirian
Inst30Quest1_Aim = "실리더스의 세나리온 요새에 있는 지휘관 마랄리스에게 무적의 오시리안의 머리를 가져가야 합니다."
Inst30Quest1_Location = "무적의 오시리안의 머리 (무적의 오시리안에서 드랍; "..YELLOW.."[6]"..WHITE..")"
Inst30Quest1_Note = "지휘관 마랄리스 (실리더스 - 세나리온 요새; "..YELLOW.."49, 34"..WHITE..")"
Inst30Quest1_Prequest = "없음"
Inst30Quest1_Folgequest = "없음"
--
Inst30Quest1name1 = "흐르는 모래의 부적"
Inst30Quest1name2 = "흐르는 모래의 아뮬렛"
Inst30Quest1name3 = "흐르는 모래의 목걸이"
Inst30Quest1name4 = "흐르는 모래의 펜던트"

--Quest 2 Alliance
Inst30Quest2 = "2. 완벽한 독" -- The Perfect Poison
Inst30Quest2_Aim = "세나리온 요새에 있는 더크 썬더우드가 베녹시스의 독주머니와 쿠린낙스의 독주머니를 가져다 달라고 했습니다."
Inst30Quest2_Location = "더크 썬더우드 (실리더스 - 세나리온 요새; "..YELLOW.."52, 39"..WHITE..")"
Inst30Quest2_Note = "대사제 베녹시스에서 베녹시스의 독주머니 드랍 "..YELLOW.."줄구룹"..WHITE.." at "..YELLOW.."[2]"..WHITE..". 쿠린낙스에서 쿠린낙스의 독주머니 드랍 "..YELLOW.."안퀴라즈 폐허"..WHITE.." 에 "..YELLOW.."[1]"..WHITE.."."
Inst30Quest2_Prequest = "없음"
Inst30Quest2_Folgequest = "없음"
--
Inst30Quest2name1 = "라벤홀트 학살자"
Inst30Quest2name2 = "쉬브스프로켓의 비수"
Inst30Quest2name3 = "썬더우드 천둥검"
Inst30Quest2name4 = "루날의 습기망치"
Inst30Quest2name5 = "파라드의 연발 석궁"
Inst30Quest2name6 = "시몬의 교화 망치"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst30Quest1_HORDE = Inst30Quest1
Inst30Quest1_HORDE_Aim = Inst30Quest1_Aim
Inst30Quest1_HORDE_Location = Inst30Quest1_Location
Inst30Quest1_HORDE_Note = Inst30Quest1_Note
Inst30Quest1_HORDE_Prequest = Inst30Quest1_Prequest
Inst30Quest1_HORDE_Folgequest = Inst30Quest1_Folgequest
--
Inst30Quest1name1_HORDE = Inst30Quest1name1
Inst30Quest1name2_HORDE = Inst30Quest1name2
Inst30Quest1name3_HORDE = Inst30Quest1name3
Inst30Quest1name4_HORDE = Inst30Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst30Quest2_HORDE = Inst30Quest2
Inst30Quest2_HORDE_Aim = Inst30Quest2_Aim
Inst30Quest2_HORDE_Location = Inst30Quest2_Location
Inst30Quest2_HORDE_Note = Inst30Quest2_Note
Inst30Quest2_HORDE_Prequest = Inst30Quest2_Prequest
Inst30Quest2_HORDE_Folgequest = Inst30Quest2_Folgequest
--
Inst30Quest2name1_HORDE = Inst30Quest2name1
Inst30Quest2name2_HORDE = Inst30Quest2name2
Inst30Quest2name3_HORDE = Inst30Quest2name3
Inst30Quest2name4_HORDE = Inst30Quest2name4
Inst30Quest2name5_HORDE = Inst30Quest2name5
Inst30Quest2name6_HORDE = Inst30Quest2name6



--------------- INST31 - The Temple of Ahn'Qiraj (AQ40) 안퀴라즈 사원 ---------------

Inst31Caption = "안퀴라즈 사원"
Inst31QAA = "4 퀘스트"
Inst31QAH = "4 퀘스트"

--Quest 1 Alliance
Inst31Quest1 = "1. 쑨의 유물" -- C'Thun's Legacy
Inst31Quest1_Aim = "안퀴라즈 사원에 있는 캘레스트라즈에게 쑨의 눈을 가져가야 합니다."
Inst31Quest1_Location = "쑨의 눈 (쑨에서 드랍; "..YELLOW.."[9]"..WHITE..")"
Inst31Quest1_Note = "캘레스트라즈 (안퀴라즈 사원; "..YELLOW.."2'"..WHITE..")"
Inst31Quest1_Prequest = "없음"
Inst31Quest1_Folgequest = "칼림도어의 구세주"
-- No Rewards for this quest

--Quest 2 Alliance
Inst31Quest2 = "2. 칼림도어의 구세주" -- The Savior of Kalimdor
Inst31Quest2_Aim = "시간의 동굴에 있는 아나크로노스에게 쑨의 눈을 가져가야 합니다."
Inst31Quest2_Location = "쑨의 눈 (쑨에서 드랍; "..YELLOW.."[9]"..WHITE..")"
Inst31Quest2_Note = "아나크로노스 (타나리스 - 시간의 동굴; "..YELLOW.."65, 49"..WHITE..")"
Inst31Quest2_Prequest = "쑨의 유물"
Inst31Quest2_Folgequest = "없음"
--
Inst31Quest2name1 = "죽은 신의 목걸이"
Inst31Quest2name2 = "죽은 신의 망토"
Inst31Quest2name3 = "죽은 신의 반지"

--Quest 3 Alliance
Inst31Quest3 = "3. 퀴라지의 비밀" -- Secrets of the Qiraji
Inst31Quest3_Aim = "신전 입구 근처에 숨어 있는 용족에게 고대 퀴라지 유물을 가져가야 합니다."
Inst31Quest3_Location = "고대 퀴라지 유물 (안퀴라즈 사원에서 무작위 드랍)"
Inst31Quest3_Note = "안도르고스로 변신 (안퀴라즈 사원; "..YELLOW.."1'"..WHITE..")."
Inst31Quest3_Prequest = "없음"
Inst31Quest3_Folgequest = "없음"
-- No Rewards for this quest

--Quest 4 Alliance
Inst31Quest4 = "4. 필멸의 영웅" -- Mortal Champions
Inst31Quest4_Aim = "안퀴라즈 사원에 있는 칸드로스트라즈에게 퀴라지 군주의 휘장을 가져 가십시오."
Inst31Quest4_Location = "칸드로스트라즈 (안퀴라즈 사원; "..YELLOW.."[1']"..WHITE..")"
Inst31Quest4_Note = "노즈도르무 혈족, 세나리온 의회 평판을 얻는 반복 퀘스트입니다. 퀴라지 군주의 휘장은 던전 내부의 모든 보스에게서 드랍합니다. 칸드로스트라즈는 첫 번째 보스 뒤 방에 있습니다."
Inst31Quest4_Prequest = "없음"
Inst31Quest4_Folgequest = "없음"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst31Quest1_HORDE = Inst31Quest1
Inst31Quest1_HORDE_Aim = Inst31Quest1_Aim
Inst31Quest1_HORDE_Location = Inst31Quest1_Location
Inst31Quest1_HORDE_Note = Inst31Quest1_Note
Inst31Quest1_HORDE_Prequest = Inst31Quest1_Prequest
Inst31Quest1_HORDE_Folgequest = Inst31Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst31Quest2_HORDE = Inst31Quest2
Inst31Quest2_HORDE_Aim = Inst31Quest2_Aim
Inst31Quest2_HORDE_Location = Inst31Quest2_Location
Inst31Quest2_HORDE_Note = Inst31Quest2_Note
Inst31Quest2_HORDE_Prequest = Inst31Quest2_Prequest
Inst31Quest2_HORDE_Folgequest = Inst31Quest2_Folgequest
Inst31Quest2FQuest_HORDE = Inst31Quest2FQuest
--
Inst31Quest2name1_HORDE = Inst31Quest2name1
Inst31Quest2name2_HORDE = Inst31Quest2name2
Inst31Quest2name3_HORDE = Inst31Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst31Quest3_HORDE = Inst31Quest3
Inst31Quest3_HORDE_Aim = Inst31Quest3_Aim
Inst31Quest3_HORDE_Location = Inst31Quest3_Location
Inst31Quest3_HORDE_Note = Inst31Quest3_Note
Inst31Quest3_HORDE_Prequest = Inst31Quest3_Prequest
Inst31Quest3_HORDE_Folgequest = Inst31Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst31Quest4_HORDE = Inst31Quest4
Inst31Quest4_HORDE_Aim = Inst31Quest4_Aim
Inst31Quest4_HORDE_Location = Inst31Quest4_Location
Inst31Quest4_HORDE_Note = Inst31Quest4_Note
Inst31Quest4_HORDE_Prequest = Inst31Quest4_Prequest
Inst31Quest4_HORDE_Folgequest = Inst31Quest4_Folgequest
-- No Rewards for this quest



--------------- INST32 - Naxxramas 낙스라마스 ---------------

Inst32Caption = "낙스라마스"
Inst32QAA = "퀘스트 없음"
Inst32QAH = "퀘스트 없음"




---------------------------------------------------
---------------- BATTLEGROUNDS --------------------
---------------------------------------------------



--------------- INST33 - Alterac Valley 알터랙 계곡 ---------------

Inst33Caption = "알터랙 계곡"
Inst33QAA = "17 퀘스트"
Inst33QAH = "17 퀘스트"

--Quest 1 Alliance
Inst33Quest1 = "1. 칙명" -- The Sovereign Imperative
Inst33Quest1_Aim = "힐스브래드 구릉지에 있는 알터랙 계곡으로 가야 합니다. 알터랙 계곡으로 들어서는 입구 터널 밖에 있는 부관 해거딘을 찾아 대화하십시오.\n\n브론즈비어드의 영광을 위하여!"
Inst33Quest1_Location = "부관 로티메르 (아이언포지 - 광장; "..YELLOW.."30,62"..WHITE..")"
Inst33Quest1_Note = "부관 해거딘은 (알터랙 산맥; "..YELLOW.."39,81"..WHITE..") 에 있다."
Inst33Quest1_Prequest = "없음"
Inst33Quest1_Folgequest = "신병 계급장"
-- No Rewards for this quest

--Quest 2 Alliance
Inst33Quest2 = "2. 신병 계급장" -- Proving Grounds
Inst33Quest2_Aim = "알터랙 계곡에 있는 던 발다르에서 남서쪽에 위치한 얼음날개 동굴로 가서 스톰파이크 깃발을 찾아 알터랙 산맥에 있는 부관 해거딘에게 돌아가야 합니다."
Inst33Quest2_Location = "부관 해거딘 (알터랙 산맥; "..YELLOW.."39,81"..WHITE..")"
Inst33Quest2_Note = "스톰파이크 깃발은 얼음날개 동굴 "..YELLOW.."[11]"..WHITE.." 에 알터랙 계곡 - 북쪽지도. 계급장은 평판이 상승됨에 따라 NPC와 대화하여 상위 계급장으로 교체할 수 있습니다.\n\n이 퀘스트를 받기 위해 선행 퀘스트는 필요하지 않습니다."
Inst33Quest2_Prequest = "칙명"
Inst33Quest2_Folgequest = "없음"
--
Inst33Quest2name1 = "스톰파이크 1급 계급장"
Inst33Quest2name2 = "서리늑대 엉겅퀴"

--Quest 3 Alliance
Inst33Quest3 = "3. 알터랙의 전투" -- The Battle of Alterac
Inst33Quest3_Aim = "알터랙 계곡으로 진입하여 호드 사령관인 드렉타르를 처치하고, 알터랙 산맥에 있는 발굴조사단장 스톤휴어에게 돌아가야 합니다."
Inst33Quest3_Location = "발굴조사단장 스톤휴어 (알터랙 산맥; "..YELLOW.."41,80"..WHITE..") and\n(알터랙 계곡 - 북쪽; "..YELLOW.."[B]"..WHITE..")"
Inst33Quest3_Note = "드렉타르는 (알터랙 계곡 - 남쪽; "..YELLOW.."[B]"..WHITE..") 에 있다. 퀘스트를 완료하기 위해 실제로 처치 할 필요는 없습니다. 전장은 어떤 식으로든 우리편이 승리해야합니다.\n이 퀘스트를 시작한 후, 보상을 위해 다시 NPC에 이야기하십시오."
Inst33Quest3_Prequest = "없음"
Inst33Quest3_Folgequest = "스톰파이크의 영웅"
--
Inst33Quest3name1 = "피의 추적자"
Inst33Quest3name2 = "얼음가시 창"
Inst33Quest3name3 = "매서운 추위의 마법봉"
Inst33Quest3name4 = "냉기철로 망치"

--Quest 4 Alliance
Inst33Quest4 = "4. 병참장교" -- The Quartermaster
Inst33Quest4_Aim = "스톰파이크 병참장교와 대화해야 합니다."
Inst33Quest4_Location = "산악경비대 붐벨로 (알터랙 계곡 - 북쪽; "..YELLOW.."Near [3] Before Bridge"..WHITE..")"
Inst33Quest4_Note = "스톰파이크 병참장교는 (알터랙 계곡 - 북쪽; "..YELLOW.."[7]"..WHITE..") 더 많은 퀘스트를 제공합니다."
Inst33Quest4_Prequest = "없음"
Inst33Quest4_Folgequest = "없음"
-- No Rewards for this quest

--Quest 5 Alliance
Inst33Quest5 = "5. 얼음이빨 광산 보급품" -- Coldtooth Supplies
Inst33Quest5_Aim = "던 발다르에 있는 얼라이언스 병참장교에게 얼음이빨 광산 보급품 10개를 가져가야 합니다."
Inst33Quest5_Location = "스톰파이크 병참장교 (알터랙 계곡 - 북쪽; "..YELLOW.."[7]"..WHITE..")"
Inst33Quest5_Note = "보급품은 얼음이빨 광산 (알터랙 계곡 - 남쪽; "..YELLOW.."[6]"..WHITE..") 에서 찾을 수 있습니다."
Inst33Quest5_Prequest = "없음"
Inst33Quest5_Folgequest = "없음"
-- No Rewards for this quest

--Quest 6 Alliance
Inst33Quest6 = "6. 깊은무쇠 광산 보급품" -- Irondeep Supplies
Inst33Quest6_Aim = "던 발다르에 있는 얼라이언스 병참장교에게 깊은무쇠 광산 보급품 10개를 가져가야 합니다."
Inst33Quest6_Location = "스톰파이크 병참장교 (알터랙 계곡 - 북쪽; "..YELLOW.."[7]"..WHITE..")"
Inst33Quest6_Note = "보급품은 검은무쇠 광산 (알터랙 계곡 - 북쪽; "..YELLOW.."[1]"..WHITE..") 에서 찾을 수 있습니다."
Inst33Quest6_Prequest = "없음"
Inst33Quest6_Folgequest = "없음"
-- No Rewards for this quest

--Quest 7 Alliance
Inst33Quest7 = "7. 방어구 조각" -- Armor Scraps
Inst33Quest7_Aim = "던 발다르에 있는 멀고트 딥포지에게 방어구 조각 20개를 가져가야 합니다."
Inst33Quest7_Location = "멀고트 딥포지 (알터랙 계곡 - 북쪽; "..YELLOW.."[4]"..WHITE..")"
Inst33Quest7_Note = "적 플레이어 시체를 클릭해 조각을 획득합니다. 후속 조치는 동일한 퀘스트이지만 반복 가능합니다."
Inst33Quest7_Prequest = "없음"
Inst33Quest7_Folgequest = "방어구 조각 (2)"
-- No Rewards for this quest

--Quest 8 Alliance
Inst33Quest8 = "8. 광산 점령" -- Capture a Mine
Inst33Quest8_Aim = "스톰파이크 경비대가 점령하지 않은 광산을 점령한 후 알터랙 산맥에 있는 하사관 두르겐 스톰파이크에게 돌아가야 합니다."
Inst33Quest8_Location = "하사관 두르겐 스톰파이크 (알터랙 산맥; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest8_Note = "퀘스트를 완료하려면, 호드가 점령하는 동안 둘중 하나 깊은무쇠 광산에 모를로취나 (알터랙 계곡 - 북쪽; "..YELLOW.."[1]"..WHITE..") 얼음이빨 광산에 작업반장 스니블을 (알터랙 계곡 - 남쪽; "..YELLOW.."[6]"..WHITE..") 처치해야 합니다."
Inst33Quest8_Prequest = "없음"
Inst33Quest8_Folgequest = "없음"
-- No Rewards for this quest

--Quest 9 Alliance
Inst33Quest9 = "9. 보초탑과 참호" -- Towers and Bunkers
Inst33Quest9_Aim = "적군의 보초탑이나 참호에 있는 깃발을 파괴한 후 알터랙 산맥에 있는 하사관 두르겐 스톰파이크에게 돌아가야 합니다."
Inst33Quest9_Location = "하사관 두르겐 스톰파이크 (알터랙 산맥; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest9_Note = "보고에 따르면, 보초탑과 참호는 실제로 퀘스트를 완료하기 위해 파괴 할 필요가 없고, 단지 점령만 하면 된다."
Inst33Quest9_Prequest = "없음"
Inst33Quest9_Folgequest = "없음"
-- No Rewards for this quest

--Quest 10 Alliance
Inst33Quest10 = "10. 알터랙 계곡의 무덤" -- Alterac Valley Graveyards
Inst33Quest10_Aim = "호드의 무덤을 공격한 다음 알터랙 산맥에 있는 하사관 두르겐 스톰파이크에게 돌아가야 합니다."
Inst33Quest10_Location = "하사관 두르겐 스톰파이크 (알터랙 산맥; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest10_Note = "보고에 따르면 호드가 공격할 때 묘지 근처에 있는 것 외에는 아무것도 할 필요가 없다고 한다. 그것을 처치할 필요는 없고, 단지 점령만 하면 된다."
Inst33Quest10_Prequest = "없음"
Inst33Quest10_Folgequest = "없음"
-- No Rewards for this quest

--Quest 11 Alliance
Inst33Quest11 = "11. 빈 우리" -- Empty Stables
Inst33Quest11_Aim = "알터랙 계곡에 돌아다니는 알터랙 산양을 찾아야 합니다. 알터랙 산양을 찾으면 그 근처에서 스톰파이크 조련용 목줄을 사용해 산양을 길들이십시오. 그러면 야수 관리인에게 돌아갈 때 따라올 것입니다. 알터랙 산양 포획을 인정받기 위해서는 야수 관리인과 대화해야 합니다."
Inst33Quest11_Location = "스톰파이크 야수관리인 (알터랙 계곡 - 북쪽; "..YELLOW.."[6]"..WHITE..")"
Inst33Quest11_Note = "기지 밖에서 산양을 찾을 수 있습니다. 길들이기 과정은 사냥꾼이 애완 동물을 길들이는 것과 같습니다. 이 퀘스트는 동일한 플레이어(들)에 의해 전장 당 총 25회까지 반복 가능합니다. 25마리의 산양이 길들여진 후, 스톰파이크 기병대가 도착하여 전투를 돕습니다."
Inst33Quest11_Prequest = "없음"
Inst33Quest11_Folgequest = "없음"
-- No Rewards for this quest

--Quest 12 Alliance
Inst33Quest12 = "12. 산양 통가죽 고삐" -- Ram Riding Harnesses
Inst33Quest12_Aim = "스톰파이크 기병대가 안장도 없이 전투에 나설 수는 없지! 탈것에 쓸 고삐가 있어야 하오. 우리가 야만인은 아니지 않겠소.\n\n기지 근처에 돌아다니는 산양을 잡아 그 가죽으로 고삐를 만든다면야 일은 간단하겠지만 우리가 탈것으로 부리는 산양을 죽인다는 건 멍청한 짓이 아닐 수 없소.\n\n그러니 당신이 적의 기지를 쳐서 놈들이 탈것으로 쓰는 서리늑대를 잡아 그 통가죽을 가지고 오시오. 그 통가죽을 가지고 오면 우리 기병대가 쓸 고삐를 만들 수 있을 거요. 자, 어서 가시오!"
Inst33Quest12_Location = "스톰파이크 산양기병대 지휘관 (알터랙 계곡 - 북쪽; "..YELLOW.."[6]"..WHITE..")"
Inst33Quest12_Note = "서리 늑대는 알터랙 계곡의 남쪽 지역에서 찾을 수 있습니다."
Inst33Quest12_Prequest = "없음"
Inst33Quest12_Folgequest = "없음"
-- No Rewards for this quest

--Quest 13 Alliance
Inst33Quest13 = "13. 폭풍 수정 묶음" -- Crystal Cluster
Inst33Quest13_Aim = "이 알터랙 계곡에선 때론 며칠이나 몇 주간 전투를 치러야 하는 경우도 있답니다. 그 기간 동안 서리늑대부족의 폭풍 수정을 잔뜩 모으게 될 수도 있지요.\n\n세나리온 의회에서는 그러한 폭풍 수정도 받고 있으니 가져다주시기 바랍니다."
Inst33Quest13_Location = "대드루이드 렌퍼럴 (알터랙 계곡 - 북쪽; "..YELLOW.."[2]"..WHITE..")"
Inst33Quest13_Note = "200개 정도의 수정을 반납하면, 대드루이드 렌퍼럴 걷기 시작합니다. (알터랙 계곡 - 북쪽; "..YELLOW.."[19]"..WHITE.."). 그곳에 도착하면 그녀는 소환 의식을 시작하며 10명이 도와야합니다. 성공하면, 숲군주 이부스가 소환되어 전투를 돕습니다."
Inst33Quest13_Prequest = "없음"
Inst33Quest13_Folgequest = "없음"
-- No Rewards for this quest

--Quest 14 Alliance
Inst33Quest14 = "14. 숲군주 이부스" -- Ivus the Forest Lord
Inst33Quest14_Aim = "서리늑대 부족은 오염된 원소의 힘에 의해 보호받고 있어요. 녀석들의 주술사가 그냥 내버려두었다가는 틀림없이 우리 모두를 파괴해 버리게 될 마력을 갖고 장난하고 있죠.\n\n세나리온 의회에서 진압하기에는 그 피해가 너무 커져 버렸어요! 이부스 님의 도움을 받아야만 합니다.\n\n서리늑대 병사들은 폭풍 수정이라는 자연 원소 부적을 가지고 다니는데, 그 부적들을 사용해 이부스 님을 소환할 수 있답니다. 가서 그 수정들을 빼앗아 오세요!"
Inst33Quest14_Location = "대드루이드 렌퍼럴 (알터랙 계곡 - 북쪽; "..YELLOW.."[2]"..WHITE..")"
Inst33Quest14_Note = "200개 정도의 수정을 반납하면, 대드루이드 렌퍼럴 걷기 시작합니다. (알터랙 계곡 - 북쪽; "..YELLOW.."[19]"..WHITE.."). 그곳에 도착하면 그녀는 소환 의식을 시작하며 10명이 도와야합니다. 성공하면, 숲군주 이부스가 소환되어 전투를 돕습니다."
Inst33Quest14_Prequest = "없음"
Inst33Quest14_Folgequest = "없음"
-- No Rewards for this quest

--Quest 15 Alliance
Inst33Quest15 = "15. 바람의 부름 - 실도르의 편대" -- Call of Air - Slidore's Fleet
Inst33Quest15_Aim = "우리 그리핀 부대가 최전방에 공습을 가할 준비가 됐는데, 적의 수가 줄어들기 전에는 출격할 수가 없다.\n\n최전방을 지키는 임무를 맡은 서리늑대부족 전사들은 가슴에 견장을 자랑스럽게 달고 다니는데, 녀석들을 쓰러뜨리고 견장을 빼앗아서 여기로 가져오도록 해라.\n\n최전방에서 녀석들의 수가 충분히 줄어들면 공습을 개시하겠다! 창공에서 죽음을 선사하리라!"
Inst33Quest15_Location = "편대사령관 실도르 (알터랙 계곡 - 북쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest15_Note = "서리늑대 병사의 견장을 위해 호드 NPC를 처치하십시오."
Inst33Quest15_Prequest = "없음"
Inst33Quest15_Folgequest = "없음"
-- No Rewards for this quest

--Quest 16 Alliance
Inst33Quest16 = "16. 바람의 부름 - 비포르의 편대" -- Call of Air - Vipore's Fleet
Inst33Quest16_Aim = "전선을 수비하고 있는 서리늑대부족 정예 부대를 쓰러뜨려야 하네! 그 야만족 무리의 숫자를 줄이는 임무를 그대에게 맡기겠네. 녀석들의 부관과 부대원의 견장을 가져오도록 하게. 그 쓰레기 같은 녀석들의 수가 충분히 줄어들었다고 판단될 때 공습을 개시하겠네."
Inst33Quest16_Location = "편대사령관 비포르 (알터랙 계곡 - 북쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest16_Note = "서리늑대 부관의 견장을 위해 호드 NPC를 처치하십시오."
Inst33Quest16_Prequest = "없음"
Inst33Quest16_Folgequest = "없음"
-- No Rewards for this quest

--Quest 17 Alliance
Inst33Quest17 = "17. 바람의 부름 - 이크만의 편대" -- Call of Air - Ichman's Fleet
Inst33Quest17_Aim = "그리핀들의 사기가 저하되어 있소. 호드에게 가했던 지난 번 공습이 실패한 후 비행을 거부하고 있소이다! 그들의 사기를 고무시키는 것이 귀관의 임무요.\n\n전투 지역으로 돌아가서 서리늑대부족 사령부의 심장부를 공격하도록 하시오. 놈들의 사령관과 수호병들을 쓰러뜨리고 귀관의 배낭 안에 넣을 수 있는 만큼 많은 견장을 가지고 돌아오도록 하시오! 분명히 우리 그리핀들이 그 견장들을 보고 적의 피 냄새를 맡게 되면 다시 날아오를 것이오! 즉시 임무를 수행하시오!"
Inst33Quest17_Location = "편대사령관 이크만 (알터랙 계곡 - 북쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest17_Note = "서리늑대 지휘관의 견장을 위해 호드 NPC를 처치하십시오. 50번 반납 후, Wing Commander Ichman will either send a gryphon to attack the Horde base or give you a beacon to plant in the Snowfall Graveyard. 봉화가 오랫동안 보호된다면 그리폰이 그것을 방어하기 위해 올 것입니다."
Inst33Quest17_Prequest = "없음"
Inst33Quest17_Folgequest = "없음"
-- No Rewards for this quest


--Quest 1 Horde
Inst33Quest1_HORDE = "1. 서리늑대부족 수호" -- In Defense of Frostwolf
Inst33Quest1_HORDE_Aim = "알터랙 산맥에 있는 알터랙 계곡으로 가십시오. 입구 바깥에 서 있는 전투대장 락그론드를 찾아 서리늑대부족 병사로서의 경력을 쌓도록 하십시오. 알터랙 계곡은 타렌 밀농장 북쪽의 알터랙 산맥 기슭에 있습니다."
Inst33Quest1_HORDE_Location = "서리늑대 사절 로크스트롬 (오그리마 - 힘의 골짜기 "..YELLOW.."50,71"..WHITE..")"
Inst33Quest1_HORDE_Note = "Warmaster Laggrond is at (알터랙 산맥; "..YELLOW.."62,59"..WHITE..")."
Inst33Quest1_HORDE_Prequest = "없음"
Inst33Quest1_HORDE_Folgequest = "신병 계급장"
-- No Rewards for this quest

--Quest 2 Horde
Inst33Quest2_HORDE = "2. 신병 계급장" -- Proving Grounds
Inst33Quest2_HORDE_Aim = "알터랙 계곡의 서리늑대 요새 남동쪽에 위치한 자갈발 동굴로 가서 서리늑대부족 깃발을 찾아 전투대장 락그론드에게 가져가야 합니다."
Inst33Quest2_HORDE_Location = "전투대장 락그론드 (알터랙 산맥; "..YELLOW.."62,59"..WHITE..")"
Inst33Quest2_HORDE_Note = "The Frostwolf Banner is in the Wildpaw Cavern at (알터랙 계곡 - 남쪽; "..YELLOW.."[15]"..WHITE.."). Talk to the same NPC each time you gain a new Reputation level for an upgraded Insignia.\n\nThe prequest is not necessary to obtain this quest."
Inst33Quest2_HORDE_Prequest = "서리늑대부족 수호"
Inst33Quest2_HORDE_Folgequest = "없음"
--
Inst33Quest2name1_HORDE = "서리늑대 1급 계급장"
Inst33Quest2name2_HORDE = "양파 껍질 벗기기"

--Quest 3 Horde
Inst33Quest3_HORDE = "3. 알터랙의 전투" -- The Battle for Alterac
Inst33Quest3_HORDE_Aim = "알터랙 계곡으로 진입하여 얼라이언스 사령관인 반다르 스톰파이크를 처치하고, 알터랙 산맥에 있는 보그가 데스그립에게 돌아가야 합니다."
Inst33Quest3_HORDE_Location = "보그가 데스그립 (알터랙 산맥; "..YELLOW.."64,60"..WHITE..")"
Inst33Quest3_HORDE_Note = "Vanndar Stormpike is at (알터랙 계곡 - 남쪽; "..YELLOW.."[B]"..WHITE.."). He does not actually need to be killed to complete the quest. The battleground just has to be won by your side in any manner.\nAfter turning this quest in, talk to the NPC again for the reward."
Inst33Quest3_HORDE_Prequest = "없음"
Inst33Quest3_HORDE_Folgequest = "서리늑대의 영웅"
--
Inst33Quest3name1_HORDE = "피의 추적자"
Inst33Quest3name2_HORDE = "얼음가시 창"
Inst33Quest3name3_HORDE = "매서운 추위의 마법봉"
Inst33Quest3name4_HORDE = "냉기철로 망치"

--Quest 4 Horde
Inst33Quest4_HORDE = "4. 병참장교와의 대화" -- Speak with our Quartermaster
Inst33Quest4_HORDE_Aim = "서리늑대 병참장교와 대화하십시오."
Inst33Quest4_HORDE_Location = "조테크 (알터랙 계곡 - 남쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest4_HORDE_Note = "The Frostwolf Quartermaster is at "..YELLOW.."[10]"..WHITE.." and provides more quests."
Inst33Quest4_HORDE_Prequest = "없음"
Inst33Quest4_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 5 Horde
Inst33Quest5_HORDE = "5. 얼음이빨 광산 보급품" -- Coldtooth Supplies
Inst33Quest5_HORDE_Aim = "서리늑대 요새에 있는 서리늑대 병참장교에게 얼음이빨 광산 보급품 10개를 가져가야 합니다."
Inst33Quest5_HORDE_Location = "서리늑대 병참장교 (알터랙 계곡 - 남쪽; "..YELLOW.."[10]"..WHITE..")"
Inst33Quest5_HORDE_Note = "The supplies can be found in the Coldtooth Mine at (알터랙 계곡 - 남쪽; "..YELLOW.."[6]"..WHITE..")."
Inst33Quest5_HORDE_Prequest = "없음"
Inst33Quest5_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 6 Horde
Inst33Quest6_HORDE = "6. 깊은무쇠 광산 보급품" -- Irondeep Supplies
Inst33Quest6_HORDE_Aim = "서리늑대 요새에 있는 서리늑대 병참장교에게 깊은무쇠 광산 보급품 10개를 가져가야 합니다."
Inst33Quest6_HORDE_Location = "서리늑대 병참장교 (알터랙 계곡 - 남쪽; "..YELLOW.."[10]"..WHITE..")"
Inst33Quest6_HORDE_Note = "The supplies can be found in the Irondeep Mine at (알터랙 계곡 - 남쪽; "..YELLOW.."[1]"..WHITE..")."
Inst33Quest6_HORDE_Prequest = "없음"
Inst33Quest6_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 7 Horde
Inst33Quest7_HORDE = "7. 전리품" -- Enemy Booty
Inst33Quest7_HORDE_Aim = "서리늑대 마을에 있는 대장장이 렉자르에게 방어구 조각 20개를 가져가야 합니다."
Inst33Quest7_HORDE_Location = "대장장이 렉자르 (알터랙 계곡 - 남쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest7_HORDE_Note = "Loot the corpse of enemy players for scraps. The followup is just the same, quest, but repeatable."
Inst33Quest7_HORDE_Prequest = "없음"
Inst33Quest7_HORDE_Folgequest = "추가 전리품!"
-- No Rewards for this quest

--Quest 8 Horde
Inst33Quest8_HORDE = "8. 광산 점령" -- Capture a Mine
Inst33Quest8_HORDE_Aim = "광산 하나를 점령한 후 알터랙 산맥에 있는 하사관 티카 블러드스날에게 돌아가야 합니다."
Inst33Quest8_HORDE_Location = "하사관 티카 블러드스날 (알터랙 산맥; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest8_HORDE_Note = "To complete the quest, you must kill either Morloch in the Irondeep Mine at (Alterac Valley - North; "..YELLOW.."[1]"..WHITE..") or Taskmaster Snivvle in the Coldtooth Mine at (Alterac Valley - South; "..YELLOW.."[6]"..WHITE..") while the Alliance control it."
Inst33Quest8_HORDE_Prequest = "없음"
Inst33Quest8_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 9 Horde
Inst33Quest9_HORDE = "9. 보초탑과 참호" -- Towers and Bunkers
Inst33Quest9_HORDE_Aim = "적군의 보초탑을 점령한 다음 알터랙 산맥에 있는 하사관 티카 블러드스날에게 돌아가야 합니다."
Inst33Quest9_HORDE_Location = "하사관 티카 블러드스날 (알터랙 산맥; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest9_HORDE_Note = "Reportedly, the Tower or Bunker need not actually be destroyed to complete the quest, just assaulted."
Inst33Quest9_HORDE_Prequest = "없음"
Inst33Quest9_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 10 Horde
Inst33Quest10_HORDE = "10. 알터랙 계곡의 무덤" -- The Graveyards of Alterac
Inst33Quest10_HORDE_Aim = "얼라이언스가 점령하고 있는 무덤을 공격한 다음 알터랙 산맥에 있는 하사관 티카 블러드스날에게 돌아가야 합니다."
Inst33Quest10_HORDE_Location = "하사관 티카 블러드스날 (알터랙 산맥; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest10_HORDE_Note = "Reportedly you do not need to do anything but be near a graveyard when the Horde assaults it. It does not need to be captured, just assaulted."
Inst33Quest10_HORDE_Prequest = "없음"
Inst33Quest10_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 11 Horde
Inst33Quest11_HORDE = "11. 빈 우리" -- Empty Stables
Inst33Quest11_HORDE_Aim = "알터랙 계곡에서 서리늑대를 찾아야 합니다. 발견한 서리늑대 근처에서 서리늑대 재갈을 사용하십시오. 그러면 서리늑대는 당신을 따라다니기 시작할 것입니다. 서리늑대부족 야수관리인에게 돌아가 서리늑대를 포획한 공로를 인정받으십시오."
Inst33Quest11_HORDE_Location = "서리늑대부족 야수관리인 (알터랙 계곡 - 남쪽; "..YELLOW.."[9]"..WHITE..")"
Inst33Quest11_HORDE_Note = "You can find a Frostwolf outside the base. The taming process is just like that of a Hunter taming a pet. The quest is repeatable up to a total of 25 times per battleground by the same player or players. After 25 Rams have been tamed, the Frostwolf Cavalry will arrive to assist in the battle."
Inst33Quest11_HORDE_Prequest = "없음"
Inst33Quest11_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 12 Horde
Inst33Quest12_HORDE = "12. 산양 통가죽 고삐" -- Ram Hide Harnesses
Inst33Quest12_HORDE_Aim = "일부 병사들이 바쁘게 움직이며 야수 관리인에게 늑대를 잡아다 주는 동안 다른 병사들은 단순한 것이지만 기병들에게 꼭 필요한 물건을 공급해 주어야 하지. 바로 고삐를 말일세.\n\n이 지역 토종 산양을 잡아야 하네. 스톰파이크 기병대가 타고 다니는 것과 똑같은 산양으로...\n\n산양을 처치하고 그 통가죽을 가지고 오게나. 통가죽이 충분히 모이면 기병들이 사용할 고삐를 만들 것이라네. 서리늑대부족 기병대가 다시 한번 전장에 출격할 수 있도록!"
Inst33Quest12_HORDE_Location = "서리늑대 늑대기병대 지휘관 (알터랙 계곡 - 남쪽; "..YELLOW.."[9]"..WHITE..")"
Inst33Quest12_HORDE_Note = "The Rams can be found in the northern area of Alterac Valley."
Inst33Quest12_HORDE_Prequest = "없음"
Inst33Quest12_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 13 Horde
Inst33Quest13_HORDE = "13. 한 사발의 피" -- A Gallon of Blood
Inst33Quest13_HORDE_Aim = "적에게서 더 많은 피를 제물로 바칠 수도 있습니다. 당신이 원한다면... , 한 사발 정도라면 흡족하겠습니다."
Inst33Quest13_HORDE_Location = "원시술사 투를로가 (알터랙 계곡 - 남쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest13_HORDE_Note = "After turning in 150 or so Blood, Primalist Thurloga will begin walking towards (Alterac Valley - South; "..YELLOW.."[1]"..WHITE.."). Once there, she will begin a summoning ritual which will require 10 people to assist. If successful, Lokholar the Ice Lord will be summoned to kill Alliance players."
Inst33Quest13_HORDE_Prequest = "없음"
Inst33Quest13_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 14 Horde
Inst33Quest14_HORDE = "14. 얼음군주 로크홀라" -- Lokholar the Ice Lord
Inst33Quest14_HORDE_Aim = "나는 썬더 블러프에서 왔소. 이 험난한 시기에 서리늑대부족을 도와주라면서 케른님이 몸소 보내셨지.\n\n하지만 시간 낭비는 그만두도록 하지. 당신은 우리 적을 물리치고 녀석들의 피를 가져와야 하오. 피를 충분히 모으면 소환 의식을 거행할 수 있소.\n\n정령의 군주를 소환해 스톰파이크 군대를 치면 반드시 승리할 거요."
Inst33Quest14_HORDE_Location = "원시술사 투를로가 (알터랙 계곡 - 남쪽; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest14_HORDE_Note = "After turning in 150 or so Blood, Primalist Thurloga will begin walking towards (Alterac Valley - South; "..YELLOW.."[1]"..WHITE.."). Once there, she will begin a summoning ritual which will require 10 people to assist. If successful, Lokholar the Ice Lord will be summoned to kill Alliance players."
Inst33Quest14_HORDE_Prequest = "없음"
Inst33Quest14_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 15 Horde
Inst33Quest15_HORDE = "15. Call of Air - Guse's Fleet" -- Call of Air - Guse's Fleet
Inst33Quest15_HORDE_Aim = "우리는 새로운 전투 와이번 편대를 준비해야 한다! 내 편대는 전장의 중심부를 공격할 준비는 됐지만 그 전에 먼저 와이번의 식욕부터 돋구어줘야 해.\n\n편대 전체의 배를 채워줄 수 있는 스톰파이크 병사의 전투식량이 필요하다! 수백 개는 되어야 할 것이다! 그 정도는 문제 없겠지? 어서 가도록!"
Inst33Quest15_HORDE_Location = "편대사령관 구스 (알터랙 계곡 - 남쪽; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest15_HORDE_Note = "Kill Alliance NPCs for the Stormpike Soldier's Flesh. Reportedly 90 flesh are needed to make the Wing Commander do whatever she does."
Inst33Quest15_HORDE_Prequest = "없음"
Inst33Quest15_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 16 Horde
Inst33Quest16_HORDE = "16. 바람의 부름 - 제즈톨의 편대" -- Call of Air - Jeztor's Fleet
Inst33Quest16_HORDE_Aim = "그대는 지금까지 열심히 해왔지만 우리는 이제 겨우 시작일뿐이다!\n\n내 와이번은 목표가 될 녀석들의 전투식량 맛을 봐야 한다. 그래야 힘을 내서 적에게 치명타를 입힐 수가 있거든!\n\n내 편대는 우리 공군 중에서도 두 번째로 강하고 따라서 적들 중에서도 가장 강한 놈들과 싸우게 될 것이다. 그런고로 우리 전투 와이번에게는 스톰파이크 부관의 전투식량이 필요하다."
Inst33Quest16_HORDE_Location = "편대사령관 제즈톨 (알터랙 산맥 - 남쪽; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest16_HORDE_Note = "Kill Alliance NPCs for the Stormpike Lieutenant's Flesh."
Inst33Quest16_HORDE_Prequest = "없음"
Inst33Quest16_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 17 Horde
Inst33Quest17_HORDE = "17. 바람의 부름 - 멀베릭의 편대" -- Call of Air - Mulverick's Fleet
Inst33Quest17_HORDE_Aim = "드워프 소굴에 며칠 동안이나 갇혀 있었으니 그에 걸맞은 복수를 해줘야지!\n\n신중하게 계획을 세워야 한다.\n\n먼저 전투 와이번에게 목표를 정해줘야 한다. 가장 우선수위가 높은 목표들로 말이지. 따라서 와이번에게 먹일 스톰파이크 사령관의 전투식량이 필요하다. 유감스럽게도 녀석들은 적진 후방 깊숙한 곳에 숨어 있지! 아주 고된 일이 될 것이다, 병사."
Inst33Quest17_HORDE_Location = "편대사령관 멀베릭 (알터랙 계곡 - 남쪽; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest17_HORDE_Note = "Kill Alliance NPCs for the Stormpike Commander's Flesh."
Inst33Quest17_HORDE_Prequest = "없음"
Inst33Quest17_HORDE_Folgequest = "없음"
-- No Rewards for this quest



--------------- INST34 - Arathi Basin ---------------

Inst34Caption = "아라시 분지"
Inst34QAA = "3 퀘스트"
Inst34QAH = "3 퀘스트"

--Quest 1 Alliance
Inst34Quest1 = "1. 아라시 분지의 전투" -- The Battle for Arathi Basin!
Inst34Quest1_Aim = "금광, 제재소, 대장간, 그리고 농장을 공격한 후 임시 주둔지에 있는 야전사령관 오슬라이트에게 돌아가십시오."
Inst34Quest1_Location = "야전사령관 오슬라이트 (아라시 고원 - 임시 주둔지; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest1_Note = "The locations to be assaulted are marked on the map as 2 through 5."
Inst34Quest1_Prequest = "없음"
Inst34Quest1_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Alliance
Inst34Quest2 = "2. Control Four Bases" -- Control Four Bases
Inst34Quest2_Aim = "Enter Arathi Basin, capture and control four bases at the same time, and then return to Field Marshal Oslight at Refuge Pointe."
Inst34Quest2_Location = "Field Marshal Oslight (Arathi Highlands - Refuge Pointe; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest2_Note = "You need to be Friendly with the League of Arathor to get this quest."
Inst34Quest2_Prequest = "없음"
Inst34Quest2_Folgequest = "없음"
-- No Rewards for this quest

--Quest 3 Alliance
Inst34Quest3 = "3. Control Five Bases" -- Control Five Bases
Inst34Quest3_Aim = "Control 5 bases in Arathi Basin at the same time, then return to Field Marshal Oslight at Refuge Pointe."
Inst34Quest3_Location = "Field Marshal Oslight (Arathi Highlands - Refuge Pointe; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest3_Note = "You need to be Exalted with the League of Arathor to get this quest."
Inst34Quest3_Prequest = "없음"
Inst34Quest3_Folgequest = "없음"
--
Inst34Quest3name1 = "Arathor Battle Tabard"


--Quest 1 Horde
Inst34Quest1_HORDE = "1. 아라시 분지의 전투" -- The Battle for Arathi Basin!
Inst34Quest1_HORDE_Aim = "아라시 분지의 금광, 제재소, 대장간, 그리고 마구간을 공격한 다음 해머폴에 있는 죽음의경비대장 드와이어에게 돌아가십시오."
Inst34Quest1_HORDE_Location = "죽음의경비대장 드와이어 (아라시 고원 - 해머폴; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest1_HORDE_Note = "The locations to be assaulted are marked on the map as 1 through 4."
Inst34Quest1_HORDE_Prequest = "없음"
Inst34Quest1_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 2 Horde
Inst34Quest2_HORDE = "2. Take Four Bases" -- Take Four Bases
Inst34Quest2_HORDE_Aim = "Hold four bases at the same time in Arathi Basin, and then return to Deathmaster Dwire in Hammerfall."
Inst34Quest2_HORDE_Location = "Deathmaster Dwire (Arathi Highlands - Hammerfall; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest2_HORDE_Note = "You need to be Friendly with The Defilers to get this quest."
Inst34Quest2_HORDE_Prequest = "없음"
Inst34Quest2_HORDE_Folgequest = "없음"
-- No Rewards for this quest

--Quest 3 Horde
Inst34Quest3_HORDE = "3. Take Five Bases" -- Take Five Bases
Inst34Quest3_HORDE_Aim = "Hold five bases in Arathi Basin at the same time, then return to Deathmaster Dwire in Hammerfall."
Inst34Quest3_HORDE_Location = "Deathmaster Dwire (Arathi Highlands - Hammerfall; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest3_HORDE_Note = "You need to be Exalted with The Defilers to get this quest."
Inst34Quest3_HORDE_Prequest = "없음"
Inst34Quest3_HORDE_Folgequest = "없음"
--
Inst34Quest3name1_HORDE = "Battle Tabard of the Defilers"



--------------- INST35 - Warsong Gulch ---------------

Inst35Caption = "전쟁노래 협곡"
Inst35QAA = "퀘스트 없음"
Inst35QAH = "퀘스트 없음"




---------------------------------------------------
---------------- OUTDOOR RAIDS --------------------
---------------------------------------------------



--------------- INST36 - Dragons of Nightmare ---------------

Inst36Caption = "Dragons of Nightmare"
Inst36QAA = "1 퀘스트"
Inst36QAH = "1 퀘스트"

--Quest 1 Alliance
Inst36Quest1 = "1. Shrouded in Nightmare"
Inst36Quest1_Aim = "Find someone capable of deciphering the meaning behind the Nightmare Engulfed Object.\n\nPerhaps a druid of great power could assist you."
Inst36Quest1_Location = "Nightmare Engulfed Object (drops from Emeriss, Taerar, Lethon or Ysondre)"
Inst36Quest1_Note = "Quest turns in to Keeper Remulos at (Moonglade - Shrine of Remulos; "..YELLOW.."36,41"..WHITE.."). Reward listed is for the followup."
Inst36Quest1_Prequest = "None"
Inst36Quest1_Folgequest = "Waking Legends"
--
Inst36Quest1name1 = "Malfurion's Signet Ring"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst36Quest1_HORDE = Inst36Quest1
Inst36Quest1_HORDE_Aim = Inst36Quest1_Aim
Inst36Quest1_HORDE_Location = Inst36Quest1_Location
Inst36Quest1_HORDE_Note = Inst36Quest1_Note
Inst36Quest1_HORDE_Prequest = Inst36Quest1_Prequest
Inst36Quest1_HORDE_Folgequest = Inst36Quest1_Folgequest
--
Inst36Quest1name1_HORDE = Inst36Quest1name1



--------------- INST37 - Azuregos ---------------

Inst37Caption = "Azuregos"
Inst37QAA = "1 퀘스트"
Inst37QAH = "1 퀘스트"

--Quest 1 Alliance
Inst37Quest1 = "1. Ancient Sinew Wrapped Lamina (Hunter)"
Inst37Quest1_Aim = "Hastat the Ancient has asked that you bring him a Mature Blue Dragon Sinew. Should you find this sinew, return it to Hastat in Felwood."
Inst37Quest1_Location = "Hastat the Ancient (Felwood - Irontree Woods; "..YELLOW.."48,24"..WHITE..")"
Inst37Quest1_Note = "Kill Azuregos to get the Mature Blue Dragon Sinew. He walks around the middle of the southern peninsula in Azshara near "..YELLOW.."[1]"..WHITE.."."
Inst37Quest1_Prequest = "The Ancient Leaf ("..YELLOW.."Molten Core"..WHITE..")"
Inst37Quest1_Folgequest = "None"
--
Inst37Quest1name1 = "Ancient Sinew Wrapped Lamina"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst37Quest1_HORDE = Inst37Quest1
Inst37Quest1_HORDE_Aim = Inst37Quest1_Aim
Inst37Quest1_HORDE_Location = Inst37Quest1_Location
Inst37Quest1_HORDE_Note = Inst37Quest1_Note
Inst37Quest1_HORDE_Prequest = Inst37Quest1_Prequest
Inst37Quest1_HORDE_Folgequest = Inst37Quest1_Folgequest
--
Inst37Quest1name1_HORDE = Inst37Quest1name1



--------------- INST38 - Highlord Kruul ---------------

Inst38Caption = "Highlord Kruul"
Inst38QAA = "퀘스트 없음"
Inst38QAH = "퀘스트 없음"


end
-- End of File
