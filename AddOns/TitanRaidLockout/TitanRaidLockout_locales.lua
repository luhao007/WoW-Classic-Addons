local _, addonTable = ...
L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

-- Addon menu text
L["PanelOptions"] = "Panel options" -- Settings menu option heading
L["ShowAllRaids"] = "Show both locked/unlocked raids" -- Settings menu option
L["ShowLockedHeroics"] = "Show locked heroics" -- Settings menu option
L["TooltipOptions"] = "Tooltip options" -- Settings menu option heading
L["ShowLayoutHint"] = "Show layout hint" -- Settings menu option
L["ShowNonLockedCharacters"] = "Show non-locked characters" -- Settings menu option
L["TooltipShowClassicRaids"] = "Show classic-era raids" -- Settings menu option
L["TooltipShowTBCRaids"] = "Show Burning Crusade-era raids" -- Settings menu option
L["TooltipShowHeroics"] = "Show heroic dungeons" -- Settings menu option
L["TITAN_PANEL_MENU_HIDE"] = "Hide" -- Settings menu option
L["Lockout: "] = "Lockout: " -- Panel label text
L["Instance Name [Bosses]"] = "Instance Name [Bosses]" -- Tooltip legend hint
L["Reset Time"] = "Reset Time" -- Tooltip legend hint
L["All raids and heroics are unlocked"] = "All raids and heroics are unlocked" -- Tooltip

-- Instance raid abbreviations: Classic
L["ZG"] = "ZG" -- Zul'Gurub
L["MC"] = "MC" -- Molten Core
L["BWL"] = "BWL" -- Blackwing Lair
L["AQ20"] = "AQ20" -- Ruins of Ahn'Qiraj
L["AQ40"] = "AQ40" -- Ahn'Qiraj

-- Instance raid abbreviations: TBC
L["KARA"] = "KARA" -- Karazhan
L["HY"] = "HY" -- Hyjal Summit
L["MAG"] = "MAG" -- Magtheridon's Lair
L["SSC"] = "SSC" -- Serpentshrine Cavern
L["TK"] = "TK" -- Tempest Keep
L["BT"] = "BT" -- Black Temple
L["GRU"] = "GRU" -- Gruul's Lair
L["ZA"] = "ZA" -- Zul'Aman
L["SUN"] = "SUN" -- Sunwell Plateau

-- Instance raid abbreviations: WoTLK
L["ONY"] = "ONY" -- Onyxia's Lair
L["NAXX"] = "NAXX" -- Naxxramas
L["ULD"] = "ULD" -- Ulduar
L["OS"] = "OS" -- Obsidian Sanctum
L["EoE"] = "EoE" -- Eye of Eternity
L["VoA"] = "VoA" -- Vault of Archavon
L["ICC"] = "ICC" -- Icecrown Citadel
L["TOC"] = "TOC" -- Trial of the Crusader
L["RS"] = "RS" -- Ruby Sanctum

-- Instance heroic dungeon abbreviations: TBC
L["BM"] = "BM" -- The Black Morass
L["SHH"] = "SHH" -- The Shattered Halls
L["BF"] = "BF" -- The Blood Furnace
L["HR"] = "HR" -- Hellfire Ramparts
L["SV"] = "SV" -- The Steamvault
L["UB"] = "UB" -- The Underbog
L["SP"] = "SP" -- The Slave Pens
L["ARC"] = "ARC" -- The Arcatraz
L["BOT"] = "BOT" -- The Botanica
L["MECH"] = "MECH" -- The Mechanar
L["SL"] = "SL" -- Shadow Labyrinth
L["SEH"] = "SEH" -- Sethekk Halls
L["MT"] = "MT" -- Mana-Tombs
L["AC"] = "AC" -- Auchenai Crypts
L["OHF"] = "OHF" -- Old Hillsbrad Foothills
L["MAT"] = "MAT" -- Magisters' Terrace

-- Instance heroic dungeon abbreviations: WoTLK
L["UK"] = "UK" -- Utgarde Keep
L["UP"] = "UP" -- Utgarde Pinnacle
L["NEX"] = "NEX" -- The Nexus
L["OC"] = "OC" -- The Oculus
L["CoS"] = "CoS" -- The Culling of Stratholme
L["HoS"] = "HoS" -- Halls of Stone
L["DTK"] = "DTK" -- Drak'Tharon Keep
L["AN"] = "AN" -- Azjol-Nerub
L["HoL"] = "HoL" -- Halls of Lightning
L["GUN"] = "GUN" -- Gundrak
L["VH"] = "VH" -- The Violet Hold
L["AK"] = "AK" -- Ahn'kahet: The Old Kingdom
L["FoS"] = "FoS" -- The Forge of Souls
L["ToC5"] = "ToC5" -- Trial of the Champion
L["PoS"] = "PoS" -- Pit of Saron
L["HoR"] = "HoR" -- Halls of Reflection

if GetLocale() == "deDE" then
    -- German localization here
end

if GetLocale() == "esES" or GetLocale() == "esMX" then
    -- Spanish localization here
end

if GetLocale() == "frFR" then
    -- French localization here
end

if GetLocale() == "ruRU" then
    -- Russian localization here
end

if GetLocale() == "itIT" then
    -- Italian localization here
end

if GetLocale() == "koKR" then
    -- Korean localization here
end

if GetLocale() == "ptBR" then
    -- Portuguese (Brazil) localization here
end

if GetLocale() == "zhCN" then
    -- Simplified Chinese (PRC) localization here
end

if GetLocale() == "zhTW" then
    -- Traditional Chinese (Taiwan) localization here
end
