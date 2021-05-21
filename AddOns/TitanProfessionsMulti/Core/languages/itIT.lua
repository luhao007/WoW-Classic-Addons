--[[
  Do you want help us translating to your language?
  Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
  Italian translator: (noboby, translated via wowhead)
--]]

local _, L = ...;
if GetLocale() == "itIT" then
--- Profissions
L["alchemy"] = "Alchimia"
L["archaeology"] = "Archeologia"
L["blacksmithing"] = "Forgiatura"
L["cooking"] = "Cucina"
L["enchanting"] = "Incantamento"
L["engineering"] = "Ingegneria"
L["firstAid"] = "Primo Soccorso"
L["fishing"] = "Pesca"
L["herbalism"] = "Erbalismo"
L["herbalismskills"] = "Erbalismo"
L["jewelcrafting"] = "Oreficeria"
L["leatherworking"] = "Conciatura"
L["mining"] = "Estrazione"
L["miningskills"] = "Estrazione"
L["skinning"] = "Scuoiatura"
L["skinningskills"] = "Scuoiatura"
L["tailoring"] = "Tailoring"
L["smelting"] = "Fonditura"
--- Fragments
L["ready"] = "|cFF69FF69Ready!  "
L["archfragments"] = "Archaeology Fragments"
L["fragments"] = "Fragments"
L["fragtooltip"] = "|cFFB4EEB4Hint:|r |cFFFFFFFFRight-click in the plugin and\rselect which fragment will be\rdisplayed in the bar.|r\r"
L["hidehint"] = "Hide Hint"
L["displaynofrag"] = "Display Races Without Fragments"
L["inprog"] = "\rIn progress:"
L["nofragments"] = "\nNo fragments:\r"
L["tooltip"] = "Tooltip"
L["noarchaeology"] = "|cFFFF2e2eYou didn't learn archaeology yet\ror don't have fragments.|r\r\rGo to the closest trainer to learn it\ror visit an excavation field."
--- Master
L["masterPlayer"] = "|cFFFFFFFFDisplaying all ${player}|r|cFFFFFFFF's professions.|r"
L["masterTutorialBar"] = "|cFF69FF69Point your cursor here! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUCTION]").."\r\rThis plugin has the function to summarize all your\rprofessions in one place. Unlike the separate plugins,\rthis one will display EVERYTHING in this tooltip.\r\r"..TitanUtils_GetHighlightText("[HOW TO USE]").."\r\rTo start, right click on this plugin and select the\roption"..TitanUtils_GetHighlightText(" 'Hide Tutorial'")..".\r\rCan be displayed in the right side of the Titan Panel\rto become even more visually pleasing!"
L["hideTutorial"] = "Hide Tutorial"
--- Shared
L["hint"] = "|cFFB4EEB4Hint:|r |cFFFFFFFFLeft-click opens your\rprofession window.|r\r\r"
L["maximum"] = "Max"
L["noprof"] = "Not learned"
L["bonus"] = "(Bonus)"
L["hidemax"] = "Hide Maximum Values"
L["session"] = "|rLearned this session: "
L["noskill"] = "|cFFFF2e2eYou didn't learn this profession yet.|r\r\rGo to the closest trainer to learn it.\rIf you need, you can forget any\rprimary profession."
L["nosecskill"] = "|cFFFF2e2eYou didn't learn this profession yet.|r\r\rGo to the closest trainer to learn it."
L["showbb"] = "Display Session Balance in Bar"
L["simpleb"] = "Simplified Bonus"
L["craftsmanship"] = "\rSkill: "
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Combine with]").."\r"
L["info"] = TitanUtils_GetHighlightText("[Information]")
L["maxskill"] = "|rYou have reached maximum potential!"
L["warning"] = "\r\r|cFFFF2e2e[Attention!]|r\rYou have reached the maximum\rexpertise and is not learning\ranymore! Go to a trainer or learn\rthe local expertise."
end
