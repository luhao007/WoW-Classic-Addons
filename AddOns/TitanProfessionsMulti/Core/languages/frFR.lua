--[[
  Do you want help us translating to your language?
  Access the project page: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
	Author: Canettieri
  French translator: akirra83, aniceto
  Last update: 07/04/2017
--]]

local _, L = ...;
if GetLocale() == "frFR" then
--- Profissions
L["alchemy"] = "Alchimie"
L["archaeology"] = "Archéologie"
L["blacksmithing"] = "Forge"
L["cooking"] = "Cuisine"
L["enchanting"] = "Enchantement"
L["engineering"] = "Ingénierie"
L["firstAid"] = "Secourisme"
L["fishing"] = "Pêche"
L["herbalism"] = "Herboristerie"
L["herbalismskills"] = "Compétences en Herboristerie"
L["jewelcrafting"] = "Joaillerie"
L["leatherworking"] = "Travail du cuir"
L["mining"] = "Minage"
L["miningskills"] = "Compétences en minage"
L["skinning"] = "Dépeçage"
L["skinningskills"] = "Compétences en Dépeçage"
L["tailoring"] = "Couture"
L["smelting"] = "Fondre"
--- Master
L["masterPlayer"] = "|cFFFFFFFFAffiche tout les métiers de ${player}|r|cFFFFFFFF.|r"
L["masterTutorialBar"] = "|cFF69FF69Mettez votre curseur ici! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUCTION]").."\r\rCe plugin a la fonction de résumer toutes vos professions dans un seul endroit.\rContrairement aux plugins séparés, celui-ci affichera TOUT dans cette info-bulle.\r\r"..TitanUtils_GetHighlightText("[COMMENT UTILISER]").."\r\rPour commencer, cliquez bouton droit sur ce plug-in et sélectionnez l'option\r"..TitanUtils_GetHighlightText("«Cacher Tutorial»")..".\r\rPeut être affiché sur le côté droit du panneau de Titan pour devenir encore plus\ragréable visuellement!"
L["hideTutorial"] = "Masquer le tutoriel"
L["masterHint"] = "|cFFB4EEB4Astuces:|r |cFFFFFFFFClic gauche ouvre la fenêtre du métier\r#1 et clic du milieu ouvre la fenêtre du métier #2.|r\r\r"
L["primprof"] = "Affiche les métiers principaux"
L["bar"] = "Barre"

--- Shared
L["hint"] = "|cFFB4EEB4Astuce:|r |cFFFFFFFFClic gauche ouvre votre\rfenêtre des métiers.|r\r\r"
L["maximum"] = "Max"
L["noprof"] = "Non appris"
L["bonus"] = "(Bonus)"
L["hidemax"] = "Masquer les valeurs Max"
L["session"] = "|rAppris cette session: "
L["noskill"] = "|cFFFF2e2eVouz n'avez pas encore appris cette profession.|r\r\rAllez à l'instructeur le plus proche pour l'apprendre.\rSi vous en avez besoin, vous pouvez oublier toute\rprofession primaire."
L["nosecskill"] = "|cFFFF2e2eVouz n'avez pas encore appris cette profession.|r\r\rAllez à l'instructeur le plus proche pour l'apprendre."
L["showbb"] = "Affiche la balance de la session dans la barre"
L["simpleb"] = "Bonus simpliflié"
L["craftsmanship"] = "\rCompétence: "
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Combine avec]").."\r"
L["info"] = TitanUtils_GetHighlightText("[Information]")
L["maxskill"] = "|rVous avez atteint votre niveau maximum!"
L["warning"] = "\r\r|cFFFF2e2e[Attention!]|r\rVous avez atteint l'expertise\rmaximale et n'apprenez plus!\rVisiter un instructeur ou apprenez\rl'expertise locale." -- Not tested!
L["maxtext"] = "\r|rMaximum actuel (sans bonus): "
L["totalbag"] = "Total dans les sacs: "
L["totalbank"] = "Total en banque: "
L["reagents"] = "Composants"
L["noreagent"] = "Vous n'avez aucun de ces composants."
L["hide"] = "Masquer"
end
