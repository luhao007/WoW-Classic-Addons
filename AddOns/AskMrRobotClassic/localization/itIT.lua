local L = LibStub("AceLocale-3.0"):NewLocale("AskMrRobotClassic", "itIT", false)

if L then


--[[----------------------------------------------------------------------
General
------------------------------------------------------------------------]]

L.SpecsShort = {
	[1] = "Blood", -- DeathKnightBlood
    [2] = "Frost", -- DeathKnightFrost
    [3] = "Unholy", -- DeathKnightUnholy
	[4] = "Havoc", -- DemonHunterHavoc
	[5] = "Vengeance", -- DemonHunterVengeance
    [6] = "Moon", -- DruidBalance
    [7] = "Feral", -- DruidFeral
    [8] = "Bear", -- DruidGuardian
    [9] = "Resto", -- DruidRestoration
    [10] = "BM", -- HunterBeastMastery
    [11] = "Marks", -- HunterMarksmanship
    [12] = "Survival", -- HunterSurvival
    [13] = "Arcane", -- MageArcane
    [14] = "Fire", -- MageFire
    [15] = "Frost", -- MageFrost
    [16] = "Brew", -- MonkBrewmaster
    [17] = "Mist", -- MonkMistweaver
    [18] = "Wind", -- MonkWindwalker
    [19] = "Holy", -- PaladinHoly
    [20] = "Prot", -- PaladinProtection
    [21] = "Ret", -- PaladinRetribution
    [22] = "Disc", -- PriestDiscipline
    [23] = "Holy", -- PriestHoly
    [24] = "Shadow", -- PriestShadow
    [25] = "Assn", -- RogueAssassination
    [26] = "Outlaw", -- RogueOutlaw
    [27] = "Sub", -- RogueSubtlety
    [28] = "Elem", -- ShamanElemental
    [29] = "Enh", -- ShamanEnhancement
    [30] = "Resto", -- ShamanRestoration
    [31] = "Aff", -- WarlockAffliction
    [32] = "Demo", -- WarlockDemonology
    [33] = "Destro", -- WarlockDestruction
    [34] = "Arms", -- WarriorArms
    [35] = "Fury", -- WarriorFury
    [36] = "Prot", -- WarriorProtection
}

-- stat strings for e.g. displaying gem/enchant abbreviations, make as short as possible without being confusing/ambiguous
L.StatsShort = {
    ["Strength"] = "For",
    ["Agility"] = "Agi",
    ["Intellect"] = "Int",
    ["CriticalStrike"] = "Crit",
    ["Haste"] = "Celerità",
    ["Mastery"] = "Maestria",
    ["Multistrike"] = "Repli",
    ["Versatility"] = "Vers",
    ["BonusArmor"] = "Bonus Armor",
    ["Spirit"] = "Spirito",
    ["Dodge"] = "Schivata",
    ["Parry"] = "Parata",
    ["MovementSpeed"] = "Velocità",
    ["Avoidance"] = "Elusione",
    ["Stamina"] = "Stam",
    ["Armor"] = "Armor",
    ["AttackPower"] = "AP",
    ["SpellPower"] = "SP",
    ["PvpResilience"] = "PvP Res",
    ["PvpPower"] = "PvP Pot",
}

L.InstanceNames = {
	[616] = "Eye of Eternity",
	[615] = "Obsidian Sanctum",
	[603] = "Ulduar",
	[649] = "Trial of the Crusader",
	[631] = "Icecrown Citadel",
	[724] = "Ruby Sanctum",
    [249] = "Onyxia",
    [409] = "Molten Core",
    [469] = "Blackwing Lair",
    [309] = "Zul'Gurub",
    [509] = "Ahn'Qiraj 20",
    [531] = "Ahn'Qiraj 40",
    [533] = "Naxxramas",
    [532] = "Karazhan",
	[548] = "Serpentshrine",
	[550] = "Tempest Keep",
	[534] = "Hyjal",
	[564] = "Black Temple",
	[580] = "Sunwell",
    [565] = "Gruul's Lair",
    [544] = "Magtheridon",
    [568] = "Zul'Aman"
}

L.DifficultyNames = {
	[1] = "Normal 10",
    [2] = "Normal 25",
    [3] = "Heroic 10",
    [4] = "Heroic 25"
}

L.WeaponTypes = {
	None     = "None",
	Axe      = "Ascia",
	Mace     = "Mazza",
	Sword    = "Spada",
	Fist     = "Tirapugni",
	Dagger   = "Pugnale",
	Staff    = "Bastone",
	Polearm  = "Arma ad Asta",
	OffHand  = "Mano Secondaria",
	Shield   = "Scudo",
	Wand     = "Bacchetta",
	Bow      = "Arco",
	Gun      = "Fucile",
	Crossbow = "Balestra"
}

L.ArmorTypes = {
	None    = "None",
	Plate   = "Piastre",
	Mail    = "Maglia",
	Leather = "Cuoio",
	Cloth   = "Stoffa"
}

L.OneHand = "Una Mano"
L.TwoHand = "Due Mani"
L.OffHand = "Mano Secondaria"


--[[----------------------------------------------------------------------
Main UI
------------------------------------------------------------------------]]
L.AlertOk = "OK"
L.CoverCancel = "Annulla"

L.MinimapTooltip = 
[[Clic Sinistro per aprire l'interfaccia di Ask Mr Robot.

Tasto Destro per cambiare spec ed equip collegato.]]

L.MainStatusText = function(version, url)
	return version .. " loaded. Documentazione disponibile su " .. url
end

L.TabExportText = "Esporta"
L.TabGearText = "Equip"
L.TabLogText = "Combat Logs"
L.TabOptionsText = "Opzioni"

L.VersionChatTitle = "Versione Addon AMR:"
L.VersionChatNotInstalled = "NON INSTALLATO"
L.VersionChatNotGrouped = "Non sei in un gruppo o in incursione!"


--[[----------------------------------------------------------------------
Export Tab
------------------------------------------------------------------------]]
L.ExportTitle = "Istruzioni di Esportazione"
L.ExportHelp1 = "1. Copia il testo qui sotto premendo Ctrl+C (o Cmd+C su un Mac)"
L.ExportHelp2 = "2. Vai su https://www.askmrrobot.com/classic e carica il tuo personaggio"
L.ExportHelp3 = "3. Paste into the textbox under the AMR ADDON section" -- TODO

L.ExportSplashTitle = "Per Cominciare"
L.ExportSplashSubtitle = "Questa è la tua prima volta con la nuova versione dell'addon. Esegui queste operazioni per creare il Database del tuo equipaggiamento:"
L.ExportSplash1 = "1. Make sure you have talents selected and appopriate gear equipped for your spec"
L.ExportSplash2 = "2. Apri la tua banca e lasciala aperta almeno per 2 secondi"
L.ExportSplashClose = "Continua"


--[[----------------------------------------------------------------------
Gear Tab
------------------------------------------------------------------------]]
L.GearImportNote = "Clicca Importa per importare i dati dal sito."
L.GearBlank = "Non hai caricato nessun equipaggiamento per questa specializzazione."
L.GearBlank2 = "Vai su askmrrobot.com per ottimizzare l'equipaggiamento, quindi usa il pulsante Importa sulla sinistra."
L.GearButtonEquip = function(spec)
	return string.format("Attiva %s Spec ed Equip", spec)
end
L.GearButtonEquip2 = "Equip Gear"
L.GearButtonJunk = "Show Junk List"
L.GearButtonShop = "Show Shopping List"

L.GearEquipErrorCombat = "Non puoi cambiare spec/eqiup mentre sei in combattimento!"
L.GearEquipErrorEmpty = "Nessun equipaggiamento salvato per questa Spec."
L.GearEquipErrorNotFound = "Un oggetto nel tuo equipaggiamento salvato non può essere indossato."
L.GearEquipErrorNotFound2 = "Prova ad aprire la banca e ad eseguire di nuovo questo comando, oppure controlla la tua Banca Eterea."
L.GearEquipErrorBagFull = "Non c'è abbastanza spazio nel tuo inventario per effettuare il cambio di equipaggiamento."
L.GearEquipErrorSoulbound = function(itemLink)
	return itemLink .. " non può essere indossato perche non è vincolato a te."
end

L.GearButtonImportText = "Importa"
L.GearButtonCleanText = "Pulisci Borse"

L.GearTipTitle = "CONSIGLIO!"
L.GearTipText = 
[[Nelle opzioni, puoi abilitare il cambio automatico di equip quando cambi spec.

Oppure, puoi cliccare con il tasto destro sul pulsante sulla minimappa per cambiare equip e spec.

Oppure! Puoi usare i seguenti comandi:]]

L.GearTipCommands = 
[[/amr equip [1-4]
no arg = cycle]]
-- note to translators: the slash commands are literal and should stay as english


--[[----------------------------------------------------------------------
Import Dialog on Gear Tab
------------------------------------------------------------------------]]
L.ImportHeader = "Premi Ctrl+V (Cmd+V su un Mac) per incollare i dati dal sito nel box qui sotto."
L.ImportButtonOk = "Importa"
L.ImportButtonCancel = "Annulla"

L.ImportErrorEmpty = "La stringa dei dati è vuota."
L.ImportErrorFormat = "La stringa dei dati non è nel formato corretto."
L.ImportErrorVersion = "La stringa dei dati proviene da una vecchia versione dell'addon.  Per piacere, vai sul sito e generane una nuova."
L.ImportErrorChar = function(importChar, yourChar)
	return "La stringa dei dati è relativa a " .. importChar .. ", Ma tu sei " .. yourChar .. "!"
end
L.ImportErrorRace = "Sembra che la tua razza sia cambiata.  Vai sul sito e riottimizza."
L.ImportErrorFaction = "Sembra che la tua fazione sia cambiata.  Vai sul sito e riottimizza."
L.ImportErrorLevel = "Sembra che il tuo livello sia cambiato.  Vai sul sito e riottimizza."

L.ImportOverwolfWait = "Performing Best in Bags optimization.  Please do not press Escape or close the addon until it has completed!"


--[[----------------------------------------------------------------------
Junk List
------------------------------------------------------------------------]]
L.JunkTitle = "Junk List"
L.JunkEmpty = "You have no junk items"
L.JunkScrap = "Click an item to add to the scrapper"
L.JunkVendor = "Click an item to sell"
L.JunkDisenchant = "Click an item to disenchant"
L.JunkBankText = function(count)
	return count .. " junk items are not in your bags"
end
L.JunkMissingText = function(count)
    return "Warning! " .. count .. " junk items could not be found"
end
L.JunkButtonBank = "Retrieve from Bank"
L.JunkOutOfSync = "An item in your junk list could not be found. Try opening your bank for a few seconds, then export to the website, then import again."
L.JunkItemNotFound = "That item could not be found in your bags. Try closing and opening the Junk List to refresh it."


--[[----------------------------------------------------------------------
Shopping List
------------------------------------------------------------------------]]
L.ShopTitle = "Lista della spesa"
L.ShopEmpty = "La lista della spesa è vuota."
L.ShopSpecLabel = "Spec"
L.ShopHeaderGems = "Gemme"
L.ShopHeaderEnchants  = "Incantamenti"
L.ShopHeaderMaterials = "Materiale di Incantamento"


--[[----------------------------------------------------------------------
Combat Log Tab
------------------------------------------------------------------------]]
L.LogChatStart = "Stai registrando il combattimento, e Mr. Robot sta salvando i dati relativi ai componenti della tua incursione."
L.LogChatStop = "La registrazione del combattimento è stata interrotta."

L.LogChatWipe = function(wipeTime)
	return "Ricevuto comando WIPE alle " .. wipeTime .. "."
end
L.LogChatUndoWipe = function(wipeTime)
	return "Il comando WIPE ricevuto alle " .. wipeTime .. " è stato rimosso."
end
L.LogChatNoWipes = "Non c'è nessun comando WIPE da rimuovere."

L.LogButtonStartText = "Inizia Registrazione"
L.LogButtonStopText = "Ferma Registrazione"
L.LogButtonReloadText = "Ricarica IU"
L.LogButtonWipeText = "Wipe!"
L.LogButtonUndoWipeText = "Rimuovi Wipe"

L.LogNote = "Stai registrando il combattimento e i dati dell'equipaggiamento."
L.LogReloadNote = "Puoi uscire da wow completamente, oppure ricaricare la IU prima di caricare i file di log."
L.LogWipeNote = "La persona incaricata di caricare il log deve essere la stessa ad utilizzare il comando wipe."
L.LogWipeNote2 = function(cmd)
	return "'" .. cmd .. "' deve fare anche questo."
end
L.LogUndoWipeNote = "Ultimo wipe chiamato:"
L.LogUndoWipeDate = function(day, timeOfDay)
	return day .. " alle " .. timeOfDay
end

L.LogAutoTitle = "Auto-Logging"
L.LogAutoAllText = "Disabilita Tutto"

L.LogInstructionsTitle = "Istruzioni!"
L.LogInstructions = 
[[1.) Clicca su Inizia Registrazione o abilita Auto-Logging per le Incursioni desiderate.

2.) Quando sei pronto a fare l'upload, esci da World of Warcraft* oppure ricarica la IU.**

3.) Lancia il client di AMR per effettuare l'upload.


*Non è necessario uscire da Wow ma è altamente raccomandato. Questo permette al client di AMR di evitare che il tuo file diventi di dimensioni troppo grosse.

**L'addon di AMR colleziona dati relativi a tutti i giocatori nella tua incursione con l'addon AMR. Gli altri giocatori non devono abilitare la registrazione! Devono solo avere l'addon installato ed abilitato. Questi dati vengono salvati su disco solo se esci da Wow o ricarichi la IU prima di caricarli.
]]


--[[----------------------------------------------------------------------
Options Tab
------------------------------------------------------------------------]]
L.OptionsHeaderGeneral = "General Options"

L.OptionsHideMinimapName = "Nascondi icona della minimappa"
L.OptionsHideMinimapDesc = "L'icona della minimappa è per convenienza, tutte le azioni possono essere eseguite tramite comandi da tastiera o IU."

L.OptionsAutoGearName = "Equipaggia automaticamente al cambio spec"
L.OptionsAutoGearDesc = "Ogni volta che cambi spec (tramite l'interfaccia di gioco, addon o AMR.), i tuoi set importati su AMR saranno equipaggiati automaticamente."

L.OptionsJunkVendorName = "Automatically show junk list at vendors and scrapper"
L.OptionsJunkVendorDesc = "Whenever you open the scrapper or a vendor, automatically show the junk list window if your list is not empty."

L.OptionsShopAhName = "Mostra automaticamente la lista della spesa quando sei all'asta"
L.OptionsShopAhDesc = "Ogni volta che apri l'asta, mostra automaticamente la lista della spesa. Puoi cliccare sugli oggetti nella lista della spesa per cercarli velocemente all'asta."

L.OptionsUiScaleName = "Ask Mr. Robot dimensione IU"
L.OptionsUiScaleDesc = "Inserisci un valore tra 0.5 e 1.5 per cambiare la dimensione del l'interfaccia di Ask Mr. Robot, premi Invio, quindi chiudi e riapri la finestra. se non riesci ad interagire con la finestra, usa il comando /amr reset."

end
