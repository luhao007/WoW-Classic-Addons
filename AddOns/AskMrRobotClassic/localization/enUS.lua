--[[-------------------------------------------------------------------------------------------------------------
Master Localization File (English)

Instructions for Translators:
1. Copy this entire file into a new file in the same folder, named with your locale, e.g. deDE.lua for German.
2. At the top, replace "enUS" in the first code line with your locale, and change the next parameter from true to false.
3. Change all the English strings in your file as appropriate.

Note that a couple of the "strings" are functions that are provided variables.  Feel free to modify these
functions as necessary to output an appropriately worded statement in your language (but don't change the parameters).  
If you need assistance with the syntax of any used methods like string.format, please contact Team Robot and we will gladly assist you.
---------------------------------------------------------------------------------------------------------------]]

-- replace enUS with your locale
local L = LibStub("AceLocale-3.0"):NewLocale("AskMrRobotClassic", "enUS", true)

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
    ["Strength"] = "Str",
    ["Agility"] = "Agi",
    ["Intellect"] = "Int",
    ["CriticalStrike"] = "Crit",
    ["Haste"] = "Haste",
    ["Mastery"] = "Mastery",
    ["Multistrike"] = "Multi",
    ["Versatility"] = "Vers",
    ["BonusArmor"] = "Armor",
    ["Spirit"] = "Spirit",
    ["Dodge"] = "Dodge",
    ["Parry"] = "Parry",
    ["MovementSpeed"] = "Speed",
    ["Avoidance"] = "Avoid",
    ["Stamina"] = "Stam",
    ["Armor"] = "Armor",
    ["AttackPower"] = "AP",
    ["SpellPower"] = "SP",
    ["PvpResilience"] = "PvP Res",
    ["PvpPower"] = "PvP Pow",
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
	Axe      = "Axe",
	Mace     = "Mace",
	Sword    = "Sword",
	Fist     = "Fist",
	Dagger   = "Dagger",
	Staff    = "Staff",
	Polearm  = "Polearm",
	OffHand  = "Off Hand",
	Shield   = "Shield",
	Wand     = "Wand",
	Bow      = "Bow",
	Gun      = "Gun",
	Crossbow = "Crossbow",
	Warglaive= "Warglaive"
}

L.ArmorTypes = {
	None    = "None",
	Plate   = "Plate",
	Mail    = "Mail",
	Leather = "Leather",
	Cloth   = "Cloth"
}

L.OneHand = "One-Hand"
L.TwoHand = "Two-Hand"
L.OffHand = "Off Hand"


--[[----------------------------------------------------------------------
Main UI
------------------------------------------------------------------------]]
L.AlertOk = "OK"
L.CoverCancel = "cancel"

L.MinimapTooltip = 
[[Left Click to open the Ask Mr. Robot window.

Right Click to cycle specs and equip your saved gear for that spec.]]

L.MainStatusText = function(version, url)
	return version .. " loaded. Documentation available at " .. url
end

L.TabExportText = "Export"
L.TabGearText = "Gear"
L.TabLogText = "Combat Logs"
L.TabOptionsText = "Options"

L.VersionChatTitle = "AMR Addon Version:"
L.VersionChatNotInstalled = "NOT INSTALLED"
L.VersionChatNotGrouped = "You are not in a group or raid!"


--[[----------------------------------------------------------------------
Export Tab
------------------------------------------------------------------------]]
L.ExportTitle = "Export Instructions"
L.ExportHelp1 = "1. Copy the text below by pressing Ctrl+C (or Cmd+C on a Mac)"
L.ExportHelp2 = "2. Go to https://www.askmrrobot.com/classic and open the character picker"
L.ExportHelp3 = "3. Paste into the textbox under the AMR ADDON section"

L.ExportSplashTitle = "Getting Started"
L.ExportSplashSubtitle = "This is your first time using the new version of the addon. Do the following things to initialize your item database:"
L.ExportSplash1 = "1. Make sure you have talents selected and appopriate gear equipped for your spec"
L.ExportSplash2 = "2. Open your bank and leave it open for at least two seconds"
L.ExportSplashClose = "Continue"


--[[----------------------------------------------------------------------
Gear Tab
------------------------------------------------------------------------]]
L.GearImportNote = "Click Import to paste data from the website."
L.GearBlank = "You have not loaded any gear for this spec yet."
L.GearBlank2 = "Go to askmrrobot.com to optimize your gear, then use the Import button to the left."
L.GearButtonEquip = function(spec)
	return string.format("Activate %s Spec and Equip Gear", spec)
end
L.GearButtonEquip2 = "Equip Gear"
L.GearButtonJunk = "Show Junk List"
L.GearButtonShop = "Show Shopping List"

L.GearEquipErrorCombat = "Cannot change spec/gear while in combat!"
L.GearEquipErrorEmpty = "No saved gear set could be found for the current spec."
L.GearEquipErrorNotFound = "An item in your saved gear set could not be equipped."
L.GearEquipErrorNotFound2 = "Try opening your bank and running this command again."
L.GearEquipErrorBagFull = "There is not enough room in your bags to equip your saved gear set."
L.GearEquipErrorSoulbound = function(itemLink)
	return itemLink .. " could not be equipped because it is not bound to you."
end

L.GearButtonImportText = "Import"
L.GearButtonCleanText = "Clean Bags"

L.GearTipTitle = "TIP!"
L.GearTipText = 
[[In Options, you can enable automatic equipping of your gear sets whenever you change spec.

Or, you can right click the minimap icon to switch spec and equip gear.

OR! You can use slash commands:]]

L.GearTipCommands = 
[[/amr equip [1-4]
no arg = cycle]]
-- note to translators: the slash commands are literal and should stay as english


--[[----------------------------------------------------------------------
Import Dialog on Gear Tab
------------------------------------------------------------------------]]
L.ImportHeader = "Press Ctrl+V (Cmd+V on a Mac) to paste data from the website into the box below."
L.ImportButtonOk = "Import"
L.ImportButtonCancel = "Cancel"

L.ImportErrorEmpty = "The data string is empty."
L.ImportErrorFormat = "The data string is not in the correct format."
L.ImportErrorVersion = "The data string is from an old version of the addon.  Please go to the website and generate a new one."
L.ImportErrorChar = function(importChar, yourChar)
	return "The data string is for " .. importChar .. ", but you are " .. yourChar .. "!"
end
L.ImportErrorRace = "It looks your race may have changed.  Please go the website and re-optimize."
L.ImportErrorFaction = "It looks your faction may have changed.  Please go the website and re-optimize."
L.ImportErrorLevel = "It looks your level may have changed.  Please go the website and re-optimize."

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
L.ShopTitle = "Shopping List"
L.ShopEmpty = "There is no shopping list data for this player."
L.ShopSpecLabel = "Spec"
L.ShopHeaderGems = "Gems"
L.ShopHeaderEnchants  = "Enchants"
L.ShopHeaderMaterials = "Enchanting Materials"


--[[----------------------------------------------------------------------
Combat Log Tab
------------------------------------------------------------------------]]
L.LogChatStart = "You are now logging combat." -- , and Mr. Robot is logging character data for your raid
L.LogChatStop = "Combat logging has been stopped."

L.LogChatWipe = function(wipeTime)
	return "Manual wipe called at " .. wipeTime .. "."
end
L.LogChatUndoWipe = function(wipeTime)
	return "Manual wipe at " .. wipeTime .. " was removed."
end
L.LogChatNoWipes = "There is no recent manual wipe to remove."

L.LogButtonStartText = "Start Logging"
L.LogButtonStopText = "Stop Logging"
L.LogButtonReloadText = "Reload UI"
L.LogButtonWipeText = "Wipe!"
L.LogButtonUndoWipeText = "Undo Wipe"

L.LogNote = "You are currently logging combat data."
L.LogReloadNote = "Either exit WoW entirely, or reload your UI just before uploading a log file."
L.LogWipeNote = "The person uploading the log must be the one to use this wipe command."
L.LogWipeNote2 = function(cmd)
	return "'" .. cmd .. "' will also do this."
end
L.LogUndoWipeNote = "Last wipe called:"
L.LogUndoWipeDate = function(day, timeOfDay)
	return day .. " at " .. timeOfDay
end

L.LogAutoTitle = "Auto-Logging"
L.LogAutoAllText = "Toggle All"

L.LogInstructionsTitle = "Instructions!"
L.LogInstructions = 
[[1.) Click Start Logging or enable Auto-Logging for your desired raids.

2.) When you are ready to upload, exit World of Warcraft* or reload your UI.**

3.) Launch the AMR Client to upload your log.


*It is not necessary to exit WoW, but it is highly recommended. This will allow the AMR client to prevent your log file from getting very large.

**The AMR addon collects extra data at the start of each encounter for all players in your raid with the AMR addon. Other players do not need to enable logging! They just need to have the addon installed and enabled. This data is only saved to disk if you exit WoW or reload your UI before uploading.
]]


--[[----------------------------------------------------------------------
Options Tab
------------------------------------------------------------------------]]
L.OptionsHeaderGeneral = "General Options"

L.OptionsHideMinimapName = "Hide minimap icon"
L.OptionsHideMinimapDesc = "The minimap icon is for convenience, all actions can also be performed via slash commands or the UI."

L.OptionsAutoGearName = "Automatically equip gear on spec change"
L.OptionsAutoGearDesc = "Whenever you change spec (via the in-game UI, another addon, etc.), your imported AMR gear sets (on the Gear tab) will be automatically equipped."

L.OptionsJunkVendorName = "Automatically show junk list at vendors and scrapper"
L.OptionsJunkVendorDesc = "Whenever you open the scrapper or a vendor, automatically show the junk list window if your list is not empty."

L.OptionsShopAhName = "Automatically show shopping list at auction house"
L.OptionsShopAhDesc = "Whenever you open the auction house, automatically show the shopping list window.  You can click on items in the shopping list to quickly search for them in the auction house."

L.OptionsDisableEmName = "Disable creating Equipment Manager sets"
L.OptionsDisableEmDesc = "A Blizzard Equipment Manager set is created whenever you equip an AMR gear set, useful for marking items in your optimized sets. Check to disable this behavior if desired."

L.OptionsUiScaleName = "Ask Mr. Robot UI scale"
L.OptionsUiScaleDesc = "Enter a value between 0.5 and 1.5 to change the scale of the Ask Mr. Robot user interface, press Enter, then close/open the window for it take effect. If the positioning gets messed up, use the /amr reset command."

end
