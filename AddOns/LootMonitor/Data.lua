local AddonName, Addon = ...

local L = Addon.L

Addon.RaidInstanceID = {
    -- Classic
	[249] = L["Onyxia's Lair"],
	[409] = L["Molten Core"],
	[469] = L["Blackwing Lair"],
    [531] = L["Temple of Ahn'Qiraj"],
    [533] = L["Naxxramas"],
    [309] = L["Zul'Gurub"],
    [509] = L["Ruins of Ahn'Qiraj"],
    -- BCC
    [564] = L["Black Temple"],
    [565] = L["Gruul's Lair"],
    [534] = L["Hyjal Summit"],
    [532] = L["Karazhan"],
    [544] = L["Magtheridon's Lair"],
    [548] = L["Serpentshrine Cavern"],
    [580] = L["Sunwell Plateau"],
    [550] = L["Tempest Keep"],
    [568] = L["Zul'Aman"],
}
Addon.IsRaidBoss = {
    -- Zul'Gurub
    ["14517"] = true, -- Jeklik
    ["14510"] = true, -- Mar'li
    ["11382"] = true, -- Bloodlord
    ["14509"] = true, -- Thekal
    ["14515"] = true, -- Arlok
    ["14507"] = true, -- Venoxis
    ["11380"] = true, -- Jin'do
    ["14834"] = true, -- Hakkar
    ["15114"] = true, -- Gahz'ranka
    ["15082"] = true, -- Gri'lek
    ["15083"] = true, -- Hazza'rah
    ["15084"] = true, -- Renataki
    ["15085"] = true, -- Wushoolay
    -- Ruins of Ahn'Qiraj
    ["15348"] = true, -- Kurinnaxx
    ["15341"] = true, -- General Rajaxx
    ["15340"] = true, -- Moam
    ["15369"] = true, -- Ayamiss the Hunter
    ["15370"] = true, -- Buru the Gorger
    ["15339"] = true, -- Ossirian the Unscarred
    -- Onyxia's Lair
    ["10184"] = true, -- Onyxia
    -- Molten Core
    ["12118"] = true, -- Lucifron
    ["11982"] = true, -- Magmadar
    ["12259"] = true, -- Gehennas
    ["12057"] = true, -- Garr
    ["12056"] = true, -- Baron Geddon
    ["12264"] = true, -- Shazzrah
    ["12098"] = true, -- Sulfuron Harbinger
    ["11988"] = true, -- Golemagg the Incinerator
    ["12018"] = true, -- Majordomo Executus
    ["11502"] = true, -- Ragnaros
    -- Blackwing Lair
    ["12435"] = true, -- Razorgore the Untamed
    ["13020"] = true, -- Vaelastrasz the Corrupt
    ["12017"] = true, -- Broodlord Lashlayer
    ["11983"] = true, -- Firemaw
    ["14601"] = true, -- Ebonroc
    ["11981"] = true, -- Flamegor
    ["14020"] = true, -- Chromaggus
    ["11583"] = true, -- Nefarian
    -- Temple of Ahn'Qiraj
    ["15263"] = true, -- The Prophet Skeram
    ["15511"] = true, -- Lord Kri
    ["15543"] = true, -- Princess Yauj
    ["15544"] = true, -- Vem
    ["15516"] = true, -- Battleguard Sartura
    ["15510"] = true, -- Fankriss the Unyielding
    ["15299"] = true, -- Viscidus
    ["15509"] = true, -- Princess Huhuran
    ["15275"] = true, -- Emperor Vek'nilash
    ["15276"] = true, -- Emperor Vek'lor
    ["15517"] = true, -- Ouro
    ["15727"] = true, -- C'Thun
    -- Naxxramas
    ["15936"] = true, -- Heigan the Unclean
    ["16060"] = true, -- Gothik the Harvester
    ["15954"] = true, -- Noth the Plaguebringer
    ["15930"] = true, -- Feugen
    ["15932"] = true, -- Gluth
    ["15953"] = true, -- Grand Widow Faerlina
    ["16062"] = true, -- Highlord Mograine
    ["16064"] = true, -- Thane Korth'azz
    ["16065"] = true, -- Lady Blaumeux
    ["16028"] = true, -- Patchwerk
    ["15929"] = true, -- Stalagg
    ["16063"] = true, -- Sir Zeliek
    ["15952"] = true, -- Maexxna
    ["15928"] = true, -- Thaddius
    ["16011"] = true, -- Loatheb
    ["15990"] = true, -- Kel'Thuzad
    ["15989"] = true, -- Sapphiron
    ["15931"] = true, -- Grobbulus
    ["16061"] = true, -- Instructor Razuvious
    ["15956"] = true, -- Anub'Rekhan
    -- Black Temple
    ["22948"] = true,
    ["23420"] = true,
    ["22917"] = true,
    ["22949"] = true, 
    ["22950"] = true,
    ["22951"] = true,
    ["22952"] = true,
    ["22887"] = true,
    ["22841"] = true,
    ["22947"] = true,
    ["22898"] = true,
    ["22871"] = true,
    -- Gruul's Lair
    ["18649"] = true,
    ["19044"] = true,
    -- Hyjal Summit
    ["17808"] = true,
    ["17968"] = true,
    ["17842"] = true,
    ["17767"] = true,
    ["17888"] = true,
    -- Karazhan
    ["16151"] = true,
    ["16152"] = true,
    ["17521"] = true,
    ["15691"] = true,
    ["16457"] = true,
    ["15687"] = true,
    ["15689"] = true,
    ["16179"] = true,
    ["16180"] = true,
    ["16181"] = true,
    ["17225"] = true,
    ["15690"] = true,
    ["16524"] = true,
    ["17534"] = true,
    ["17533"] = true,
    ["18168"] = true,
    ["15688"] = true,
    -- Magtheridon's Lair
    ["17257"] = true,
    -- Serpentshrine Cavern
    ["21216"] = true,
    ["21215"] = true,
    ["21213"] = true,
    ["21217"] = true,
    ["21212"] = true,
    ["21214"] = true,
    -- Sunwell Plateau
    ["24882"] = true,
    ["25165"] = true,
    ["25166"] = true,
    ["25038"] = true,
    ["24850"] = true,
    ["25315"] = true,
    ["25741"] = true,
    -- Tempest Keep
    ["19514"] = true,
    ["19622"] = true,
    ["18805"] = true,
    ["19516"] = true,
    -- Zul'Aman
    ["23574"] = true,
    ["23577"] = true,
    ["23578"] = true,
    ["24239"] = true,
    ["23576"] = true,
    ["23863"] = true,
}