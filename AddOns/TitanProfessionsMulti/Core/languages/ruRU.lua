--[[
  Do you want help us translating to your language?
  Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
  Russian translator: PocoMaxa
	Last update: 15/10/2015
--]]

local _, L = ...;
if GetLocale() == "ruRU" then
--- Profissions
L["alchemy"] = "Алхимия"
L["archaeology"] = "Археология"
L["blacksmithing"] = "Кузнечное дело"
L["cooking"] = "Кулинария"
L["enchanting"] = "Наложение чар"
L["engineering"] = "Инженерное дело"
L["firstAid"] = "Первая помощь"
L["fishing"] = "Рыбная ловля"
L["herbalism"] = "Травничество"
L["herbalismskills"] = "Навыки травничества"
L["jewelcrafting"] = "Ювелирное дело"
L["leatherworking"] = "Кожевничество"
L["mining"] = "Горное дело"
L["miningskills"] = "Навыки горного дела"
L["skinning"] = "Снятие шкур"
L["skinningskills"] = "Навыки снятия шкур"
L["tailoring"] = "Портняжное дело"
L["smelting"] = "Выплавка металлов"
--- Fragments
L["ready"] = "|cFF69FF69Собрать!  "
L["archfragments"] = "Фрагменты артефактов"
L["fragments"] = "Фрагменты"
L["fragtooltip"] = "|cFFB4EEB4Подсказка:|r |cFFFFFFFFПКМ чтобы выбрать какой\rфрагмент будет отображаться на панели.|r\r"
L["hidehint"] = "Скрыть подсказку в окне"
L["displaynofrag"] = "Показать расы без фрагментов"
L["inprog"] = "\rПрогресс:"
L["nofragments"] = "\nНет фрагментов:\r"
L["tooltip"] = "Всплывающее окно"
L["noarchaeology"] = "|cFFFF2e2eУ вас не изучена Археология или нет ни\rодного фрагмента.|r\r\rОтправляйтесь к учителю Археологии для\rизучения, или посетите места раскопок."
--- Master
L["masterPlayer"] = "|cFFFFFFFFDisplaying all ${player}|r|cFFFFFFFF's professions.|r"
L["masterTutorialBar"] = "|cFF69FF69Point your cursor here! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUCTION]").."\r\rThis plugin has the function to summarize all your\rprofessions in one place. Unlike the separate plugins,\rthis one will display EVERYTHING in this tooltip.\r\r"..TitanUtils_GetHighlightText("[HOW TO USE]").."\r\rTo start, right click on this plugin and select the\roption"..TitanUtils_GetHighlightText(" 'Hide Tutorial'")..".\r\rCan be displayed in the right side of the Titan Panel\rto become even more visually pleasing!"
L["hideTutorial"] = "Hide Tutorial"
--- Shared
L["hint"] = "|cFFB4EEB4Подсказка:|r |cFFFFFFFFЛевый клик откроет окно профессии.|r\r\r"
L["maximum"] = "Максимум"
L["noprof"] = "Не изучено"
L["bonus"] = "(Бонус)"
L["hidemax"] = "Скрыть максимальные значения"
L["session"] = "Изучено за эту сессию: "
L["noskill"] = "|cFFFF2e2eYou didn't learn this profession yet.|r\r\rGo to the closest trainer to learn it.\rIf you need, you can forget any\rprimary profession." -- No translation
L["nosecskill"] = "|cFFFF2e2eYou didn't learn this profession yet.|r\r\rGo to the closest trainer to learn it." -- No translation
L["showbb"] = "Отображать на панели баланс сессии"
L["simpleb"] = "Simplified Bonus" -- No translation
L["craftsmanship"] = "\rSkill: " -- No translation
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Combine with]").."\r" -- No translation
L["info"] = TitanUtils_GetHighlightText("[Information]") -- No translation
L["maxskill"] = "|rYou have reached maximum potential!" -- No translation
L["warning"] = "\r\r|cFFFF2e2e[Attention!]|r\rYou have reached the maximum\rexpertise and is not learning\ranymore! Go to a trainer or learn\rthe local expertise." -- No translation
end
