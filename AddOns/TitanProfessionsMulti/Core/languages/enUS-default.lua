--[[
  Do you want help us translating to your language?
  Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
--]]

local _, L = ...;
------ Professions pack
--- Profissions (default)
L["alchemy"] = "Alchemy"
L["archaeology"] = "Archaeology"
L["blacksmithing"] = "Blacksmithing"
L["cooking"] = "Cooking"
L["enchanting"] = "Enchanting"
L["engineering"] = "Engineering"
L["firstAid"] = "First Aid"
L["fishing"] = "Fishing"
L["herbalism"] = "Herbalism"
L["herbalismskills"] = "Herbalism Skills"
L["jewelcrafting"] = "Jewelcrafting"
L["leatherworking"] = "Leatherworking"
L["mining"] = "Mining"
L["miningskills"] = "Mining Skills"
L["skinning"] = "Skinning"
L["skinningskills"] = "Skinning Skills"
L["tailoring"] = "Tailoring"
L["smelting"] = "Smelting"
--- Master (default)
L["masterPlayer"] = "|cFFFFFFFFDisplaying all ${player}|r|cFFFFFFFF's professions.|r"
L["masterTutorialBar"] = "|cFF69FF69Point your cursor here! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUCTION]").."\r\rThis plugin has the function to summarize all your\rprofessions in one place. Unlike the separate plugins,\rthis one will display EVERYTHING in this tooltip.\r\r"..TitanUtils_GetHighlightText("[HOW TO USE]").."\r\rTo start, right click on this plugin and select the\roption"..TitanUtils_GetHighlightText(" 'Hide Tutorial'")..".\r\rCan be displayed in the right side of the Titan Panel\rto become even more visually pleasing!"
L["hideTutorial"] = "Hide Tutorial"
L["masterHint"] = "|cFFB4EEB4Hint:|r |cFFFFFFFFLeft click opens the profession #1 window\rand middle click opens the profession #2 window.|r\r\r"
L["primprof"] = "Show Primary Professions"
L["bar"] = "Bar"

------ Shared with one or more
--- Shared (default)
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
L["maxtext"] = "\r|rCurrent maximum (no bonus): "
L["totalbag"] = "Total in Bag: "
L["totalbank"] = "Total in Bank: "
L["reagents"] = "Reagents"
L["rLegion"] = "Reagents - Legion"
L["rBfA"] = "Reagents - BfA"
L["noreagent"] = "You have not got any\rof these reagents."
L["hide"] = "Hide"
