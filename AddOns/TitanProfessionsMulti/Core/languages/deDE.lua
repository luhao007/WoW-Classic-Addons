--[[
	Do you want help us translating to your language?
	Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
  German translator: pas06, Wavix, aniceto
	Last update: 07/04/2017
--]]

local _, L = ...;
if GetLocale() == "deDE" then
------ Professions pack
--- Profissions
L["alchemy"] = "Alchimie"
L["archaeology"] = "Archäologie"
L["blacksmithing"] = "Schmiedekunst"
L["cooking"] = "Kochkunst"
L["enchanting"] = "Verzauberkunst"
L["engineering"] = "Ingenieurskunst"
L["firstAid"] = "Erste Hilfe"
L["fishing"] = "Angeln"
L["herbalism"] = "Kräuterkunde"
L["herbalismskills"] = "Kräuterkundefähigkeiten"
L["jewelcrafting"] = "Juwelierskunst"
L["leatherworking"] = "Lederverarbeitung"
L["mining"] = "Bergbau"
L["miningskills"] = "Bergbaufertigkeiten"
L["skinning"] = "Kürschnerei"
L["skinningskills"] = "Kürschnerfertigkeiten"
L["tailoring"] = "Schneiderei"
L["smelting"] = "Verhüttung"
--- Master
L["masterPlayer"] = "|cFFFFFFFFZeige ${player}s|r|cFFFFFFFF Berufe an.|r"
L["masterTutorialBar"] = "|cFF69FF69Bewege deinen Cursor hierher! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[EINFÜHRUNG]").."\r\rDieses Plugin hat die Funktion, alle deine Berufe an einem Ort zusammenzufassen.\rIm Gegensatz zu den separaten Plugins wird diese in dieser Tooltip ALLES angezeigt.\r\r"..TitanUtils_GetHighlightText("[WIE BENUTZEN]").."\r\rZum Starten klicken Sie mit der rechten Maustaste auf dieses Plugin und wählen Sie\rdie Option"..TitanUtils_GetHighlightText(" 'Anleitung ausblenden'").." aus.\r\rKann auf der rechten Seite des Titan Panels angezeigt werden, um noch mehr optisch\rzu erfreuen!"
L["hideTutorial"] = "Anleitung ausblenden"
L["masterHint"] = "|cFFB4EEB4Hinweis:|r |cFFFFFFFFLinksklick öffnet das Fenster des ersten Berufs\rund ein Mittelklick das Fenster des zweiten Berufs.|r\r\r"
L["primprof"] = "Zeige Primäre Berufe an"
L["bar"] = "Panel"

------ Shared with one or more
--- Shared
L["hint"] = "|cFFB4EEB4Hinweis:|r |cFFFFFFFFEin Linksklick öffnet dein Berufe Fenster.|r\r\r"
L["maximum"] = "Max"
L["noprof"] = "Nicht erlernt"
L["bonus"] = "(Bonus)"
L["hidemax"] = "Max. Werte verstecken"
L["session"] = "In dieser Sitzung erlernt: "
L["noskill"] = "|cFFFF2e2eDu hast diesen Beruf noch nicht erlernt.|r\r\rGehe zu dem nächstgelegensten Lehrer,\rum ihn zu erlernen. Du kannst auch\rjeden Hauptberuf wieder verlernen,\rfalls du ihn ersetzen möchtest."
L["nosecskill"] = "|cFFFF2e2eDu hast diesen Beruf noch nicht erlernt.|r\r\rGehe zu dem nächstgelegensten Lehrer,\rum ihn zu erlernen."
L["showbb"] = "Sitzungsbalance in der Leiste anzeigen"
L["simpleb"] = "Vereinfachter Bonus"
L["craftsmanship"] = "\rFähigkeit: "
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Kombinieren mit]").."\r"
L["info"] = TitanUtils_GetHighlightText("[Informationen]")
L["maxskill"] = "|rDu hast das höchste Fähigkeitenlevel erreicht!"
L["warning"] = "\r\r|cFFFF2e2e[Achtung!]|r\rSie haben die maximale Expertise\rerreicht und Lernen nicht mehr!\rGehen Sie zu einem Ausbilder\roder lernen Sie die lokale\rExpertise.." -- Not tested!
L["maxtext"] = "\r|rAktuelles Maximum (ohne Bonus): "
L["totalbag"] = "Insgesamt in Beutel: "
L["totalbank"] = "Insgesamt in Bank: "
L["reagents"] = "Komponenten"
L["noreagent"] = "Sie haben keine dieser Komponenten."
L["hide"] = "Ausblenden"
end
