--[[
  Oi para você que é brasileiro e está vindo até aqui ler as traduções! HAHA! Se encontrar algum erro, me avise, tá bem?
	Tudo aqui neste arquivo foi traduzido por mim, Paulo Canettieri! (com ajuda do wowhead, ninguém é de ferro!)
--]]

local _, L = ...;
if GetLocale() == "ptBR" then
------ Professions pack
--- Profissions
L["alchemy"] = "Alquimia"
L["archaeology"] = "Arqueologia"
L["blacksmithing"] = "Ferraria"
L["cooking"] = "Culinária"
L["enchanting"] = "Encantamento"
L["engineering"] = "Engenharia"
L["firstAid"] = "Primeiros Socorros"
L["fishing"] = "Pesca"
L["herbalism"] = "Herborismo"
L["herbalismskills"] = "Perícias de Herborismo"
L["jewelcrafting"] = "Joalheria"
L["leatherworking"] = "Couraria"
L["mining"] = "Mineração"
L["miningskills"] = "Perícia em Mineração"
L["skinning"] = "Esfolamento"
L["skinningskills"] = "Habilidades em Esfolamento"
L["tailoring"] = "Alfaiataria"
L["smelting"] = "Fundição"
--- Master
L["masterPlayer"] = "|cFFFFFFFFExibindo todas profissões de ${player}|cFFFFFFFF.|r"
L["masterTutorialBar"] = "|cFF69FF69Passe o cursor aqui! :)|r"
L["masterTutorial"] = TitanUtils_GetHighlightText("\r[INTRODUÇÃO]").."\r\rEste plugin tem a função de resumir todas suas profissões\rem um único lugar. Diferentemente dos plugins avulsos,\reste exibirá TUDO nesta tooltip.\r\r"..TitanUtils_GetHighlightText("[COMO USAR]").."\r\rPara começar, clique com o botão direito no plugin e\rselecione a opção"..TitanUtils_GetHighlightText(" 'Esconder Tutorial'")..".\r\rVocê poderá coloca-lo no canto direito do Painel Titan\rpara ficar ainda mais agradável visualmente!"
L["hideTutorial"] = "Esconder Tutorial"
L["masterHint"] = "|cFFB4EEB4Dica:|r |cFFFFFFFFClique esquerdo abre a janela da profissão nº1\re com o botão do meio abre a janela da profissão nº2.|r\r\r"
L["primprof"] = "Mostrar Profissões Primárias"
L["bar"] = "Barra"

------ Shared with one or more
--- Shared
L["hint"] = "|cFFB4EEB4Dica:|r |cFFFFFFFFClique para abrir a janela da\rprofissão.|r\r\r"
L["maximum"] = "Máx"
L["noprof"] = "Não aprendido"
L["bonus"] = "(Bônus)"
L["hidemax"] = "Esconder Valores Máximos"
L["session"] = "|rAprendido na sessão: "
L["noskill"] = "|cFFFF2e2eVocê não aprendeu esta profissão ainda.|r\r\rVá ao treinador mais próximo para aprende-la.\rSe precisar, poderá esquecer qualquer profissão primária."
L["nosecskill"] = "|cFFFF2e2eVocê não aprendeu esta profissão ainda.|r\r\rVá ao treinador mais próximo para aprende-la."
L["showbb"] = "Exibir Saldo da Sessão na Barra"
L["simpleb"] = "Bônus Simplificado"
L["craftsmanship"] = "\rPerícia: "
L["goodwith"] = "\r\r"..TitanUtils_GetHighlightText("[Combina com]").."\r"
L["info"] = TitanUtils_GetHighlightText("[Informações]")
L["maxskill"] = "|rVocê chegou ao potencial máximo!"
L["warning"] = "\r\r|cFFFF2e2e[Atenção!]|r\rVocê chegou ao máximo de perícia e\rnão está aprendendo mais! Vá a um\rtreinador ou aprenda a perícia local."
L["maxtext"] = "\r|rMáximo atual (sem bônus): "
L["totalbag"] = "Total na Bolsa: "
L["totalbank"] = "Total no Banco: "
L["reagents"] = "Reagentes"
L["rLegion"] = "Reagentes - Legion"
L["rBfA"] = "Reagentes - BfA"
L["noreagent"] = "Você ainda não obteve\rnenhum destes reagentes."
L["hide"] = "Esconder"
end
