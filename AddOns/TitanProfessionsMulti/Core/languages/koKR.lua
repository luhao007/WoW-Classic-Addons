--[[
  Do you want help us translating to your language?
  Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
  Korean translator: next96
	Last update: 24/08/2016
--]]

local _, L = ...;
if GetLocale() == "koKR" then
--- Profissions
L["alchemy"] = "연금술"
L["archaeology"] = "고고학"
L["blacksmithing"] = "대장기술"
L["cooking"] = "요리"
L["enchanting"] = "마법부여"
L["engineering"] = "기계공학"
L["firstAid"] = "응급치료"
L["fishing"] = "낚시"
L["herbalism"] = "약초채집"
L["smelting"] = "제련술"
L["jewelcrafting"] = "보석세공"
L["leatherworking"] = "가죽 세공"
L["mining"] = "채광"
L["skinning"] = "무두질"
L["tailoring"] = "재봉술"
--- Fragments
L["ready"] = "|cFF69FF69준비완료!  "
L["archfragments"] = "고고학 조각"
L["fragments"] = "조각"
L["fragtooltip"] = "|cFFB4EEB4도움말:|r |cFFFFFFFF마우스 오른쪽 클릭하여 바에 표시할\r플러그인을 선택합니다.|r\r"
L["hidehint"] = "도움말 숨기기"
L["displaynofrag"] = "조각은 제외하고 종족만 표시"
L["inprog"] = "\rIn progress:" -- No translation
L["nofragments"] = "\n조각 없음:\r"
L["tooltip"] = "툴팁"
L["noarchaeology"] = "|cFFFF2e2e아직 고고학 기술을 배우지 않았습니다.|r\r\r기술자에게 고고학을 배우십시오."
--- Master
L["masterPlayer"] = "|cFFFFFFFFDisplaying all ${player}|r|cFFFFFFFF's professions.|r"
L["masterTutorialBar"] = "|cFF69FF69Point your cursor here! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUCTION]").."\r\rThis plugin has the function to summarize all your\rprofessions in one place. Unlike the separate plugins,\rthis one will display EVERYTHING in this tooltip.\r\r"..TitanUtils_GetHighlightText("[HOW TO USE]").."\r\rTo start, right click on this plugin and select the\roption"..TitanUtils_GetHighlightText(" 'Hide Tutorial'")..".\r\rCan be displayed in the right side of the Titan Panel\rto become even more visually pleasing!"
L["hideTutorial"] = "Hide Tutorial"
--- Shared
L["hint"] = "|cFFB4EEB4도움말:|r |cFFFFFFFF마우스 클릭으로 전문기술 창을 엽니다.|r\r\r"
L["maximum"] = "최대"
L["noprof"] = "배우지 않음"
L["bonus"] = "(추가 효과)"
L["hidemax"] = "최대 숙련치를 표시하지 않습니다."
L["session"] = "현재 배운 것: "
L["noskill"] = "|cFFFF2e2e현재 전문기술을 배우지 않았습니다.|r\r\r기술자를 만나 전문기술을 배우십시오.\r다른 전문기술을 취소해야할 수도 있습니다." -- Need test
L["nosecskill"] = "|cFFFF2e2e현재 전문기술을 배우지 않았습니다.|r\r\r기술자를 만나 전문기술을 배우십시오." -- Need test
L["showbb"] = "바에 수입과 지출을 표시합니다."
L["simpleb"] = "간단한 보너스"
L["craftsmanship"] = "\rSkill: " -- No translation
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Combine with]").."\r" -- No translation
L["info"] = TitanUtils_GetHighlightText("[Information]") -- No translation
L["maxskill"] = "|rYou have reached maximum potential!" -- No translation
L["warning"] = "\r\r|cFFFF2e2e[Attention!]|r\rYou have reached the maximum\rexpertise and is not learning\ranymore! Go to a trainer or learn\rthe local expertise." -- No translation
end
