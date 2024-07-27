local _, addon = ...;
addon.Data.ExportedCategories = {};
local exportedCategories = addon.Data.ExportedCategories;

local tasks, categories, adjustableCategories, achievements, tabs;
function exportedCategories.RegisterTasks(_categories, _adjustableCategories, _achievements, _tabs)
    categories, adjustableCategories, achievements, tabs = _categories, _adjustableCategories, _achievements, _tabs;
    wipe(adjustableCategories.WatchListCategories);
    wipe(adjustableCategories.CurrentZoneCategories);
    wipe(adjustableCategories.SelectedZoneCategories);
    wipe(adjustableCategories.SearchResultsCategories);
    wipe(adjustableCategories.TrackingAchievementsCategories);
    wipe(adjustableCategories.ExcludedCategories);

    local name = "Categories";
    addon.Data.InjectLoadingDebug(tasks, name);

    tinsert(addon.Data.TasksGroups, 1, tasks);
end

local category = addon.Objects.Category;
local function N(id, ...)
    categories[id] = category:New(id, ...);
end

local function C(cId1, cId2)
    categories[cId1]:AddCategory(categories[cId2]);
end

local function A(cId, aId)
    categories[cId]:AddAchievement(achievements[aId]);
end

local function V(cId)
    categories[cId]:SetAlwaysVisible(true);
end

local function T(cId, tabName)
    categories[cId]:SetTabName(tabName);
    tabs[tabName].Categories = categories[cId].Children;
end

local function F(cId, adjustableCategoryName)
    categories[cId]:SetFlexibleData(true);
    tinsert(adjustableCategories[adjustableCategoryName], categories[cId]);
end

local function S(cId)
    categories[cId]:SetAsSummary(true);
end

-- Saves some characters and file size as we use this a lot in the tasks
local a = addon;

-- [[ Everything after these lines is automatically generated as an export from ]] --
-- [[ an SQLite database and is not meant for manual edit. - AUTOGENTOKEN ]] --

-- [[ Exported at 2024-06-15 17-23-42 ]] --
tasks = {
    {F, 1557, "UncategorizedCategories"},
    {C, 971, 1557},
    {N, 1557, a.L["Uncategorized"]}, -- Uncategorized
    {F, 857, "ExcludedCategories"},
    {C, 971, 857},
    {N, 857, a.L["Excluded"]}, -- Excluded
    function() categories[1367].IsTracking = true; end,
    {F, 1367, "TrackingAchievementsCategories"},
    {C, 971, 1367},
    {N, 1367, a.L["Tracking Achievements"]}, -- Tracking Achievements
    {C, 1346, 1347},
    {N, 1347, a.GetCategoryInfoTitle(15439)}, -- Shadowlands
    {C, 1346, 1348},
    {N, 1348, a.GetCategoryInfoTitle(15305)}, -- Battle for Azeroth
    {C, 1346, 1349},
    {N, 1349, a.GetCategoryInfoTitle(15258)}, -- Legion
    {C, 1346, 1350},
    {N, 1350, a.GetCategoryInfoTitle(15233)}, -- Warlords of Dreanor
    {C, 1346, 1351},
    {N, 1351, a.GetCategoryInfoTitle(15164)}, -- Mists of Pandaria
    {A, 1352, 5449}, -- Rock Lover
    {C, 1346, 1352},
    {N, 1352, a.GetCategoryInfoTitle(15072)}, -- Cataclysm
    {A, 1378, 1956}, -- Higher Learning
    {C, 1346, 1378},
    {N, 1378, a.GetCategoryInfoTitle(14866)}, -- Wrath of the Lich King
    {C, 1346, 1356},
    {N, 1356, a.GetCategoryInfoTitle(15101)}, -- Darkmoon Faire
    {C, 1355, 1357},
    {N, 1357, a.GetCategoryInfoTitle(15117) .. " " .. a.GetCategoryInfoTitle(15272)}, -- Pet Battles Dungeons
    {C, 1346, 1355},
    {N, 1355, a.GetCategoryInfoTitle(168)}, -- Dungeons & Raids
    {C, 1346, 1354},
    {N, 1354, a.GetCategoryInfoTitle(15246)}, -- Collections
    {A, 1353, 5875}, -- Littlest Pet Shop
    {A, 1353, 5877}, -- Menagerie
    {A, 1353, 5876}, -- Petting Zoo
    {A, 1353, 2516}, -- Lil' Game Hunter
    {A, 1353, 1250}, -- "Shop Smart, Shop Pet...Smart"
    {C, 1346, 1353},
    {N, 1353, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {A, 1346, 3478}, -- Pilgrim
    {C, 971, 1346},
    {N, 1346, a.L["Ta's Pet Collection"]}, -- Ta's Pet Collection
    {C, 1566, 1572},
    {N, 1572, a.L["Season"] .. " " .. 4, true}, -- Season 4
    {C, 1566, 1569},
    {N, 1569, a.L["Season"] .. " " .. 3, true}, -- Season 3
    {C, 1566, 1568},
    {N, 1568, a.L["Season"] .. " " .. 2, true}, -- Season 2
    {C, 1566, 1567},
    {N, 1567, a.L["Season"] .. " " .. 1, true}, -- Season 1
    {C, 1565, 1566},
    {N, 1566, a.GetCategoryInfoTitle(15466)}, -- Dragonflight
    {C, 971, 1565},
    {N, 1565, a.L["Mythic+"]}, -- Mythic+
    {C, 1117, 1539},
    {N, 1539, a.L["Warcraft Rumble"], true}, -- Warcraft Rumble
    {C, 1117, 1125},
    {N, 1125, a.L["Warcraft III: Reforged"], true}, -- Warcraft III: Reforged
    {C, 1117, 1124},
    {N, 1124, a.L["Heroes of the Storm"], true}, -- Heroes of the Storm
    {C, 1123, 1563},
    {N, 1563, a.L["10th Anniversary"], true}, -- 10th Anniversary
    {C, 1117, 1123},
    {N, 1123, a.L["Hearthstone"]}, -- Hearthstone
    {A, 1122, 4824}, -- Collector's Edition: Mini Thor
    {C, 1117, 1122},
    {N, 1122, a.L["StarCraft II"], true}, -- StarCraft II
    {C, 1117, 1121},
    {N, 1121, a.L["Overwatch"], true}, -- Overwatch
    {C, 1562, 1400},
    {N, 1400, a.L["Diablo IV"], true}, -- Diablo IV
    {C, 1562, 1120},
    {N, 1120, a.L["Diablo III"], true}, -- Diablo III
    {C, 1117, 1562},
    {N, 1562, a.L["Diablo"]}, -- Diablo
    {A, 1119, 16332}, -- The Perfect Pebble
    {A, 1119, 5377}, -- Collector's Edition: Lil' Deathwing
    {A, 1119, 683}, -- Collector's Edition: Frost Wyrm Whelp
    {A, 1119, 665}, -- Collector's Edition: Netherwhelp
    {A, 1119, 664}, -- Collector's Edition: Zergling
    {A, 1119, 663}, -- Collector's Edition: Panda
    {A, 1119, 662}, -- Collector's Edition: Mini-Diablo
    {C, 1117, 1119},
    {N, 1119, a.L["Collector's Edition"], true}, -- Collector's Edition
    {A, 1118, 6185}, -- Murkablo
    {A, 1118, 5378}, -- Deathy
    {A, 1118, 3536}, -- The Marine Marine
    {A, 1118, 415}, -- Big Blizzard Bear
    {A, 1118, 412}, -- Murloc Costume
    {A, 1118, 411}, -- Murky
    {C, 1117, 1118},
    {N, 1118, a.L["BlizzCon"], true}, -- BlizzCon
    {A, 1117, 414}, -- Tyrael's Hilt
    {C, 971, 1117},
    {N, 1117, a.GetCategoryInfoTitle(15268)}, -- Promotions
    {A, 1115, 4576}, -- Realm First! Fall of the Lich King
    {A, 1115, 4078}, -- Realm First! Grand Crusader
    {A, 1115, 3259}, -- Realm First! Celestial Defender
    {A, 1115, 3117}, -- Realm First! Death's Demise
    {A, 1115, 1400}, -- Realm First! Magic Seeker
    {A, 1115, 456}, -- Realm First! Obsidian Slayer
    {A, 1115, 1402}, -- Realm First! Conqueror of Naxxramas
    {C, 1105, 1115},
    {N, 1115, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1105, 1114},
    {N, 1114, a.GetCategoryInfoTitle(15272), true}, -- Dungeons
    {A, 1116, 1463}, -- Realm First! Northrend Vanguard
    {C, 1105, 1116},
    {N, 1116, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 1112, 5394}, -- Realm First! Illustrious Tailor
    {A, 1112, 5393}, -- Realm First! Illustrious Skinner
    {A, 1112, 5389}, -- Realm First! Illustrious Scribe
    {A, 1112, 5392}, -- Realm First! Illustrious Miner
    {A, 1112, 5386}, -- Realm First! Illustrious First Aid
    {A, 1112, 5391}, -- Realm First! Illustrious Leatherworker
    {A, 1112, 5390}, -- Realm First! Illustrious Jewelcrafter
    {A, 1112, 5388}, -- Realm First! Illustrious Herbalism
    {A, 1112, 5385}, -- Realm First! Illustrious Engineer
    {A, 1112, 5384}, -- Realm First! Illustrious Enchanter
    {A, 1112, 5383}, -- Realm First! Illustrious Cooking
    {A, 1112, 5382}, -- Realm First! Illustrious Blacksmith
    {A, 1112, 5396}, -- Realm First! Illustrious Archaeologist
    {A, 1112, 5387}, -- Realm First! Illustrious Angler
    {A, 1112, 5381}, -- Realm First! Illustrious Alchemist
    {C, 1110, 1112},
    {N, 1112, a.L["525 skill"], true}, -- 525 skill
    {A, 1111, 1427}, -- Realm First! Grand Master Tailor
    {A, 1111, 1426}, -- Realm First! Grand Master Skinner
    {A, 1111, 1422}, -- Realm First! Grand Master Scribe
    {A, 1111, 1425}, -- Realm First! Grand Master Miner
    {A, 1111, 1419}, -- Realm First! First Aid Grand Master
    {A, 1111, 1424}, -- Realm First! Grand Master Leatherworker
    {A, 1111, 1423}, -- Realm First! Grand Master Jewelcrafter
    {A, 1111, 1421}, -- Realm First! Grand Master Herbalist
    {A, 1111, 1418}, -- Realm First! Grand Master Engineer
    {A, 1111, 1417}, -- Realm First! Grand Master Enchanter
    {A, 1111, 1416}, -- Realm First! Cooking Grand Master
    {A, 1111, 1414}, -- Realm First! Grand Master Blacksmith
    {A, 1111, 5395}, -- Realm First! Grand Master Archaeologist
    {A, 1111, 1420}, -- Realm First! Grand Master Angler
    {A, 1111, 1415}, -- Realm First! Grand Master Alchemist
    {C, 1110, 1111},
    {N, 1111, a.L["450 skill"], true}, -- 450 skill
    {C, 1105, 1110},
    {N, 1110, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 1108, 5000}, -- Realm First! Level 85 Druid
    {A, 1108, 5003}, -- Realm First! Level 85 Warlock
    {A, 1108, 5006}, -- Realm First! Level 85 Mage
    {A, 1108, 4998}, -- Realm First! Level 85 Shaman
    {A, 1108, 5005}, -- Realm First! Level 85 Death Knight
    {A, 1108, 5002}, -- Realm First! Level 85 Priest
    {A, 1108, 5008}, -- Realm First! Level 85 Rogue
    {A, 1108, 5004}, -- Realm First! Level 85 Hunter
    {A, 1108, 5001}, -- Realm First! Level 85 Paladin
    {A, 1108, 5007}, -- Realm First! Level 85 Warrior
    {A, 1108, 4999}, -- Realm First! Level 85
    {C, 1106, 1108},
    {N, 1108, a.L["Level 85"], true}, -- Level 85
    {A, 1107, 1406}, -- Realm First! Level 80 Draenei
    {A, 1107, 1405}, -- Realm First! Level 80 Blood Elf
    {A, 1107, 1412}, -- Realm First! Level 80 Troll
    {A, 1107, 1404}, -- Realm First! Level 80 Gnome
    {A, 1107, 1411}, -- Realm First! Level 80 Tauren
    {A, 1107, 1413}, -- Realm First! Level 80 Forsaken
    {A, 1107, 1409}, -- Realm First! Level 80 Night Elf
    {A, 1107, 1407}, -- Realm First! Level 80 Dwarf
    {A, 1107, 1410}, -- Realm First! Level 80 Orc
    {A, 1107, 1408}, -- Realm First! Level 80 Human
    {A, 1107, 466}, -- Realm First! Level 80 Druid
    {A, 1107, 463}, -- Realm First! Level 80 Warlock
    {A, 1107, 460}, -- Realm First! Level 80 Mage
    {A, 1107, 467}, -- Realm First! Level 80 Shaman
    {A, 1107, 461}, -- Realm First! Level 80 Death Knight
    {A, 1107, 464}, -- Realm First! Level 80 Priest
    {A, 1107, 458}, -- Realm First! Level 80 Rogue
    {A, 1107, 462}, -- Realm First! Level 80 Hunter
    {A, 1107, 465}, -- Realm First! Level 80 Paladin
    {A, 1107, 459}, -- Realm First! Level 80 Warrior
    {A, 1107, 457}, -- Realm First! Level 80
    {C, 1106, 1107},
    {N, 1107, a.L["Level 80"], true}, -- Level 80
    {C, 1105, 1106},
    {N, 1106, a.L["Leveling"]}, -- Leveling
    {C, 971, 1105},
    {N, 1105, a.L["Realm First!"]}, -- Realm First!
    {C, 1101, 1104},
    {N, 1104, a.GetCategoryInfoTitle(95)}, -- Player vs. Player
    {C, 1101, 1103},
    {N, 1103, a.GetCategoryInfoTitle(15271)}, -- Raids
    {C, 1101, 1102},
    {N, 1102, a.GetCategoryInfoTitle(15246)}, -- Collections
    {C, 971, 1101},
    {N, 1101, (UnitName("player")) .. " " .. (GetTitleName(334))}, -- Player the Fabulous
    {A, 1099, 5356}, -- High Warlord
    {A, 1099, 5343}, -- Grand Marshal
    {A, 1099, 5342}, -- Warlord
    {A, 1099, 5357}, -- Field Marshal
    {A, 1099, 5355}, -- General
    {A, 1099, 5341}, -- Marshal
    {A, 1099, 5354}, -- Lieutenant General
    {A, 1099, 5340}, -- Commander
    {A, 1099, 5353}, -- Champion
    {A, 1099, 5339}, -- Lieutenant Commander
    {A, 1099, 5338}, -- Centurion
    {A, 1099, 5359}, -- Knight-Champion
    {A, 1099, 5352}, -- Legionnaire
    {A, 1099, 5337}, -- Knight-Captain
    {A, 1099, 5351}, -- Blood Guard
    {A, 1099, 5336}, -- Knight-Lieutenant
    {A, 1099, 5350}, -- Stone Guard
    {A, 1099, 5335}, -- Knight
    {A, 1099, 5349}, -- First Sergeant
    {A, 1099, 5334}, -- Sergeant Major
    {A, 1099, 5348}, -- Senior Sergeant
    {A, 1099, 5333}, -- Master Sergeant
    {A, 1099, 5347}, -- Sergeant
    {A, 1099, 5332}, -- Sergeant
    {A, 1099, 5346}, -- Grunt
    {A, 1099, 5331}, -- Corporal
    {A, 1099, 5345}, -- Scout
    {A, 1099, 5330}, -- Private
    {A, 1099, 5326}, -- Warbringer of the Horde
    {A, 1099, 5329}, -- Warbound Veteran of the Alliance
    {A, 1099, 5325}, -- Veteran of the Horde
    {A, 1099, 5328}, -- Veteran of the Alliance
    {C, 1093, 1099},
    {N, 1099, a.L["Rated"], true}, -- Rated
    {A, 1098, 1175}, -- Battlemaster
    {A, 1098, 230}, -- Battlemaster
    {A, 1098, 714}, -- The Conqueror
    {A, 1098, 907}, -- The Justicar
    {C, 1093, 1098},
    {N, 1098, a.GetCategoryInfoTitle(153), true}, -- Battlegrounds
    {C, 1093, 1097},
    {N, 1097, a.L["Dueler's Guild"], true}, -- Dueler's Guild
    {C, 1093, 1095},
    {N, 1095, a.GetCategoryInfoTitle(15283), true}, -- World
    {A, 1096, 5363}, -- 250000 Honorable Kills
    {A, 1096, 870}, -- 100000 Honorable Kills
    {C, 1093, 1096},
    {N, 1096, a.GetCategoryInfoTitle(15266), true}, -- Honor
    {C, 1084, 1093},
    {N, 1093, a.GetCategoryInfoTitle(95), true}, -- PvP
    {A, 1094, 1691}, -- Merrymaker
    {A, 1094, 1692}, -- Merrymaker
    {A, 1094, 3656}, -- Pilgrim
    {A, 1094, 3478}, -- Pilgrim
    {A, 1094, 1657}, -- Hallowed Be Thy Name
    {A, 1094, 1656}, -- Hallowed Be Thy Name
    {A, 1094, 1683}, -- Brewmaster
    {A, 1094, 1684}, -- Brewmaster
    {A, 1094, 1039}, -- The Flame Keeper
    {A, 1094, 1038}, -- The Flame Warden
    {A, 1094, 1793}, -- For The Children
    {A, 1094, 2798}, -- Noble Gardener
    {A, 1094, 2797}, -- Noble Gardener
    {A, 1094, 1693}, -- Fool For Love
    {A, 1094, 1707}, -- Fool For Love
    {A, 1094, 913}, -- To Honor One's Elders
    {C, 1084, 1094},
    {N, 1094, a.L["Events"], true}, -- Events
    {A, 1092, 1784}, -- Hail to the Chef
    {A, 1092, 1563}, -- Hail to the Chef
    {A, 1092, 4856}, -- It Belongs in a Museum!
    {A, 1092, 4855}, -- What was Briefly Yours is Now Mine
    {A, 1092, 1516}, -- Accomplished Angler
    {C, 1084, 1092},
    {N, 1092, a.GetCategoryInfoTitle(169), true}, -- Professions
    {C, 1084, 1091},
    {N, 1091, a.GetCategoryInfoTitle(15246), true}, -- Collections
    {C, 1084, 1090},
    {N, 1090, a.L["Brawler's Guild"] .. " (" .. a.GetCategoryInfoTitle(15234) .. ")", true}, -- Brawler's Guild
    {C, 1084, 1089},
    {N, 1089, a.GetCategoryInfoTitle(15117), true}, -- Pet Battles
    {A, 1087, 4477}, -- Looking For Many
    {C, 1084, 1087},
    {N, 1087, a.GetCategoryInfoTitle(15272), true}, -- Dungeons
    {A, 1088, 1015}, -- 40 Exalted Reputations
    {C, 1084, 1088},
    {N, 1088, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 1086, 46}, -- World Explorer
    {C, 1084, 1086},
    {N, 1086, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 1085, 1682}, -- The Loremaster
    {A, 1085, 1681}, -- The Loremaster
    {A, 1085, 978}, -- 3000 Quests Completed
    {C, 1084, 1085},
    {N, 1085, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 1043, 1084},
    {N, 1084, a.L["Other"]}, -- Other
    {C, 1053, 1083},
    {N, 1083, a.GetCategoryInfoTitle(15441), true}, -- Covenant Sanctums
    {C, 1053, 1082},
    {N, 1082, a.GetCategoryInfoTitle(15440), true}, -- Torghast
    {C, 1053, 1081},
    {N, 1081, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1053, 1080},
    {N, 1080, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 1043, 1053},
    {N, 1053, a.GetCategoryInfoTitle(15439)}, -- Shadowlands
    {C, 1052, 1079},
    {N, 1079, a.GetCategoryInfoTitle(15426), true}, -- Visions of N'Zoth
    {C, 1052, 1078},
    {N, 1078, a.GetCategoryInfoTitle(15417), true}, -- Heart of Azeroth
    {C, 1052, 1077},
    {N, 1077, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1052, 1076},
    {N, 1076, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 1052, 1075},
    {N, 1075, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 1043, 1052},
    {N, 1052, a.GetCategoryInfoTitle(15305)}, -- Battle for Azeroth
    {C, 1051, 1072},
    {N, 1072, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1051, 1071},
    {N, 1071, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 1051, 1070},
    {N, 1070, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 1051, 1074},
    {N, 1074, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 1043, 1051},
    {N, 1051, a.GetCategoryInfoTitle(15258)}, -- Legion
    {C, 1050, 1069},
    {N, 1069, a.L["Garrison"], true}, -- Garrison
    {C, 1050, 1068},
    {N, 1068, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1050, 1067},
    {N, 1067, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 1050, 1066},
    {N, 1066, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 1043, 1050},
    {N, 1050, a.GetCategoryInfoTitle(15233)}, -- Warlords of Dreanor
    {C, 1049, 1064},
    {N, 1064, a.L["Scenarios"], true}, -- Scenarios
    {C, 1049, 1063},
    {N, 1063, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1049, 1062},
    {N, 1062, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 1049, 1061},
    {N, 1061, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 1043, 1049},
    {N, 1049, a.GetCategoryInfoTitle(15164)}, -- Mists of Pandaria
    {A, 1060, 6116}, -- Heroic: Madness of Deathwing
    {A, 1060, 6177}, -- Destroyer's End
    {A, 1060, 5803}, -- Heroic: Ragnaros
    {A, 1060, 5506}, -- Defender of a Shattered World
    {A, 1060, 5123}, -- Heroic: Al'Akir
    {A, 1060, 5121}, -- Heroic: Sinestra
    {A, 1060, 5116}, -- Heroic: Nefarian
    {C, 1048, 1060},
    {N, 1060, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {A, 1059, 5827}, -- Avengers of Hyjal
    {C, 1048, 1059},
    {N, 1059, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 1058, 5879}, -- Veteran of the Molten Front
    {C, 1048, 1058},
    {N, 1058, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 1048, 5767}, -- Scourer of the Eternal Sands
    {C, 1043, 1048},
    {N, 1048, a.GetCategoryInfoTitle(15072)}, -- Cataclysm
    {A, 1056, 4584}, -- The Light of Dawn
    {A, 1056, 4597}, -- The Frozen Throne (25 player)
    {A, 1056, 4583}, -- Bane of the Fallen King
    {A, 1056, 3037}, -- Observed (25 player)
    {A, 1056, 3036}, -- Observed (10 player)
    {A, 1056, 3316}, -- Herald of the Titans
    {A, 1056, 1658}, -- Champion of the Frozen Wastes
    {A, 1056, 2054}, -- The Twilight Zone (25 player)
    {A, 1056, 2051}, -- The Twilight Zone (10 player)
    {C, 1047, 1056},
    {N, 1056, a.GetCategoryInfoTitle(15271), true}, -- Raids
    {C, 1047, 1057},
    {N, 1057, a.GetCategoryInfoTitle(15272), true}, -- Dungeons
    {A, 1054, 2816}, -- Exalted Argent Champion of the Horde
    {A, 1054, 2817}, -- Exalted Argent Champion of the Alliance
    {A, 1054, 2766}, -- Exalted Champion of Sen'jin
    {A, 1054, 2762}, -- Exalted Champion of Gnomeregan
    {A, 1054, 2767}, -- Exalted Champion of Silvermoon City
    {A, 1054, 2761}, -- Exalted Champion of the Exodar
    {A, 1054, 2768}, -- Exalted Champion of Thunder Bluff
    {A, 1054, 2760}, -- Exalted Champion of Darnassus
    {A, 1054, 2769}, -- Exalted Champion of the Undercity
    {A, 1054, 2763}, -- Exalted Champion of Ironforge
    {A, 1054, 2765}, -- Exalted Champion of Orgrimmar
    {A, 1054, 2764}, -- Exalted Champion of Stormwind
    {A, 1054, 945}, -- The Argent Champion
    {A, 1054, 953}, -- Guardian of Cenarius
    {A, 1054, 4598}, -- The Ashen Verdict
    {A, 1054, 943}, -- The Diplomat
    {A, 1054, 942}, -- The Diplomat
    {C, 1047, 1054},
    {N, 1054, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 1043, 1047},
    {N, 1047, a.GetCategoryInfoTitle(14866)}, -- Wrath of the Lich King
    {A, 1065, 2336}, -- Insane in the Membrane
    {A, 1065, 871}, -- "Avast Ye, Admiral!"
    {A, 1065, 762}, -- Ambassador of the Horde
    {A, 1065, 948}, -- Ambassador of the Alliance
    {C, 1045, 1065},
    {N, 1065, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 1043, 1045},
    {N, 1045, a.GetCategoryInfoTitle(14864)}, -- Classic
    {C, 971, 1043},
    {N, 1043, a.L["The Entitled"] .. " " .. (UnitName("player"))}, -- The Entitled Player
    {C, 972, 1409},
    {N, 1409, a.L["Recruit-a-Friend"]}, -- Recruit-a-Friend
    {A, 988, 4832}, -- Friends In Even Higher Places
    {A, 988, 1436}, -- Friends In High Places
    {C, 972, 988},
    {N, 988, a.L["Recruit-a-Friend"] .. " (" .. a.GetCategoryInfoTitle(15234) .. ")"}, -- Recruit-a-Friend
    {A, 978, 6322}, -- Ruthless Gladiator's Twilight Drake
    {A, 978, 6321}, -- Ruthless Gladiator's Twilight Drake
    {A, 978, 6003}, -- Vicious Gladiator's Twilight Drake
    {A, 978, 4600}, -- Wrathful Gladiator's Frost Wyrm
    {A, 978, 3757}, -- Relentless Gladiator's Frost Wyrm
    {A, 978, 3756}, -- Furious Gladiator's Frost Wyrm
    {A, 978, 3096}, -- Deadly Gladiator's Frost Wyrm
    {A, 978, 2316}, -- Brutal Nether Drake
    {A, 978, 888}, -- Vengeful Nether Drake
    {A, 978, 887}, -- Merciless Nether Drake
    {A, 978, 886}, -- Swift Nether Drake
    {C, 977, 978},
    {N, 978, (select(2, a.GetAchievementInfo(2091))), true}, -- Gladiator
    {C, 972, 977},
    {N, 977, a.GetCategoryInfoTitle(95)}, -- PvP
    {A, 981, 6169}, -- Glory of the Dragon Soul Raider
    {A, 981, 5828}, -- Glory of the Firelands Raider
    {A, 981, 4853}, -- Glory of the Cataclysm Raider
    {A, 981, 4603}, -- Glory of the Icecrown Raider (25 player)
    {A, 981, 4602}, -- Glory of the Icecrown Raider (10 player)
    {A, 981, 2958}, -- Glory of the Ulduar Raider (25 player)
    {A, 981, 2957}, -- Glory of the Ulduar Raider (10 player)
    {C, 982, 981},
    {N, 981, a.L["Glory"], true}, -- Glory
    {A, 984, 4625}, -- Invincible's Reins
    {A, 984, 4626}, -- And I'll Form the Head!
    {A, 984, 2081}, -- Grand Black War Mammoth
    {A, 984, 430}, -- Amani War Bear
    {A, 984, 885}, -- Ashes of Al'ar
    {A, 984, 882}, -- Fiery Warhorse's Reins
    {A, 984, 424}, -- Why? Because It's Red
    {A, 984, 881}, -- Swift Razzashi Raptor
    {A, 984, 880}, -- Swift Zulian Tiger
    {C, 982, 984},
    {N, 984, a.L["Drops"], true}, -- Drops
    {C, 972, 982},
    {N, 982, a.GetCategoryInfoTitle(15271)}, -- Raids
    {A, 980, 4845}, -- Glory of the Cataclysm Hero
    {A, 980, 2136}, -- Glory of the Hero
    {C, 979, 980},
    {N, 980, a.L["Glory"], true}, -- Glory
    {A, 983, 884}, -- Swift White Hawkstrider
    {A, 983, 883}, -- Reins of the Raven Lord
    {A, 983, 729}, -- Deathcharger's Reins
    {C, 979, 983},
    {N, 983, a.L["Drops"], true}, -- Drops
    {C, 972, 979},
    {N, 979, a.GetCategoryInfoTitle(15272)}, -- Dungeons
    {A, 989, 5767}, -- Scourer of the Eternal Sands
    {A, 989, 879}, -- Old School Ride
    {C, 972, 989},
    {N, 989, a.L["Achievements"]}, -- Achievements
    {A, 987, 2145}, -- "What A Long, Strange Trip It's Been"
    {A, 987, 2144}, -- "What A Long, Strange Trip It's Been"
    {A, 987, 4627}, -- X-45 Heartbreaker
    {A, 987, 3496}, -- A Brew-FAST Mount
    {A, 987, 980}, -- The Horseman's Reins
    {A, 987, 416}, -- Scarab Lord
    {C, 972, 987},
    {N, 987, a.L["Events"]}, -- Events
    {A, 986, 5749}, -- Vial of the Sands
    {A, 986, 2097}, -- Get to the Choppa!
    {C, 972, 986},
    {N, 986, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 985, 4888}, -- One Hump or Two?
    {A, 985, 2078}, -- Traveler's Tundra Mammoth
    {A, 985, 2077}, -- Wooly Mammoth
    {A, 985, 2076}, -- Armored Brown Bear
    {C, 972, 985},
    {N, 985, a.L["Vendor"]}, -- Vendor
    {A, 976, 2537}, -- Mountain o' Mounts
    {A, 976, 2536}, -- Mountain o' Mounts
    {A, 976, 2143}, -- Leading the Cavalry
    {A, 976, 2142}, -- Filling Up The Barn
    {A, 976, 2141}, -- Stable Keeper
    {C, 972, 976},
    {N, 976, a.GetCategoryInfoTitle(15246)}, -- Collections
    {A, 972, 3357}, -- Venomhide Ravasaur
    {A, 972, 3356}, -- Winterspring Frostsaber
    {C, 971, 972},
    {N, 972, a.L["Bur's Mount Collection"]}, -- Bur's Mount Collection
    {F, 1396, "SearchResultsCategories"},
    {C, 971, 1396},
    {N, 1396, a.L["Search Results"]}, -- Search Results
    function() categories[850].IsSelectedZone = true; end,
    {F, 850, "SelectedZoneCategories"},
    {C, 971, 850},
    {N, 850, a.L["Selected Zone"]}, -- Selected Zone
    function() categories[433].IsCurrentZone = true; end,
    {F, 433, "CurrentZoneCategories"},
    {C, 971, 433},
    {N, 433, a.L["Current Zone"]}, -- Current Zone
    function() categories[949].IsWatchList = true; end,
    {F, 949, "WatchListCategories"},
    {C, 971, 949},
    {N, 949, a.L["Watch List"]}, -- Watch List
    {S, 1204},
    {V, 1204},
    {C, 971, 1204},
    {N, 1204, a.L["Summary"]}, -- Summary
    {T, 971, "Specials"},
    {N, 971, a.L["Specials"]}, -- TAB - Specials
    {F, 1556, "UncategorizedCategories"},
    {C, 955, 1556},
    {N, 1556, a.L["Uncategorized"]}, -- Uncategorized
    {F, 1227, "ExcludedCategories"},
    {C, 955, 1227},
    {N, 1227, a.L["Excluded"]}, -- Excluded
    function() categories[1368].IsTracking = true; end,
    {F, 1368, "TrackingAchievementsCategories"},
    {C, 955, 1368},
    {N, 1368, a.L["Tracking Achievements"]}, -- Tracking Achievements
    {A, 1197, 6317}, -- Hero of the Horde: Ruthless
    {A, 1197, 6316}, -- Hero of the Alliance: Ruthless
    {A, 1197, 6124}, -- Ruthless Gladiator
    {A, 1197, 5358}, -- Hero of the Horde: Vicious
    {A, 1197, 5344}, -- Hero of the Alliance: Vicious
    {A, 1197, 6002}, -- Vicious Gladiator
    {C, 955, 1197},
    {N, 1197, a.GetCategoryInfoTitle(15072)}, -- Cataclysm
    {A, 1200, 4599}, -- Wrathful Gladiator
    {A, 1200, 3758}, -- Relentless Gladiator
    {A, 1200, 3436}, -- Furious Gladiator
    {A, 1200, 3336}, -- Deadly Gladiator
    {C, 955, 1200},
    {N, 1200, a.GetCategoryInfoTitle(14866)}, -- Wrath of the Lich King
    {A, 1199, 420}, -- Brutal Gladiator
    {A, 1199, 419}, -- Vengeful Gladiator
    {A, 1199, 418}, -- Merciless Gladiator
    {C, 955, 1199},
    {N, 1199, a.GetCategoryInfoTitle(14865)}, -- The Burning Crusade
    {A, 1131, 443}, -- High Warlord
    {A, 1131, 433}, -- Grand Marshal
    {A, 1131, 445}, -- Warlord
    {A, 1131, 434}, -- Field Marshal
    {A, 1131, 446}, -- General
    {A, 1131, 473}, -- Marshal
    {A, 1131, 444}, -- Lieutenant General
    {A, 1131, 435}, -- Commander
    {A, 1131, 447}, -- Champion
    {A, 1131, 436}, -- Lieutenant Commander
    {A, 1131, 448}, -- Centurion
    {A, 1131, 437}, -- Knight-Champion
    {A, 1131, 469}, -- Legionnaire
    {A, 1131, 438}, -- Knight-Captain
    {A, 1131, 449}, -- Blood Guard
    {A, 1131, 472}, -- Knight-Lieutenant
    {A, 1131, 451}, -- Stone Guard
    {A, 1131, 439}, -- Knight
    {A, 1131, 452}, -- First Sergeant
    {A, 1131, 440}, -- Sergeant Major
    {A, 1131, 450}, -- Senior Sergeant
    {A, 1131, 441}, -- Master Sergeant
    {A, 1131, 453}, -- Sergeant
    {A, 1131, 471}, -- Sergeant
    {A, 1131, 468}, -- Grunt
    {A, 1131, 470}, -- Corporal
    {A, 1131, 454}, -- Scout
    {A, 1131, 442}, -- Private
    {C, 955, 1131},
    {N, 1131, a.GetCategoryInfoTitle(14864)}, -- Classic
    {A, 1166, 1174}, -- The Arena Master
    {A, 1166, 409}, -- Last Man Standing
    {A, 1166, 2091}, -- Gladiator
    {A, 1166, 2092}, -- Duelist
    {A, 1166, 2093}, -- Rival
    {A, 1166, 2090}, -- Challenger
    {A, 1166, 1162}, -- Hotter Streak
    {A, 1166, 408}, -- Hot Streak
    {A, 1166, 1161}, -- High Five: 2200
    {A, 1166, 404}, -- High Five: 2000
    {A, 1166, 407}, -- High Five: 1750
    {A, 1166, 406}, -- High Five: 1550
    {A, 1166, 5267}, -- Three's Company: 2700
    {A, 1166, 5266}, -- Three's Company: 2400
    {A, 1166, 1160}, -- Three's Company: 2200
    {A, 1166, 405}, -- Three's Company: 2000
    {A, 1166, 403}, -- Three's Company: 1750
    {A, 1166, 402}, -- Three's Company: 1550
    {A, 1166, 1159}, -- Just the Two of Us: 2200
    {A, 1166, 401}, -- Just the Two of Us: 2000
    {A, 1166, 400}, -- Just the Two of Us: 1750
    {A, 1166, 399}, -- Just the Two of Us: 1550
    {A, 1166, 699}, -- World Wide Winner
    {A, 1166, 876}, -- Brutally Dedicated
    {A, 1166, 875}, -- Vengefully Dedicated
    {A, 1166, 398}, -- Mercilessly Dedicated
    {A, 1166, 397}, -- Step Into The Arena
    {C, 955, 1166},
    {N, 1166, a.GetCategoryInfoTitle(165)}, -- Arena
    {C, 1165, 1032},
    {N, 1032, a.L["Southshore vs. Tarren Mill"] .. " (" .. a.GetCategoryInfoTitle(15234) .. ")"}, -- Southshore vs. Tarren Mill
    {A, 963, 2776}, -- Master of Wintergrasp
    {A, 963, 1752}, -- Master of Wintergrasp
    {A, 963, 1751}, -- Didn't Stand a Chance
    {A, 963, 1727}, -- Leaning Tower
    {A, 963, 1723}, -- Vehicular Gnomeslaughter
    {A, 963, 2476}, -- Destruction Derby
    {A, 963, 1737}, -- Destruction Derby
    {A, 963, 2080}, -- Black War Mammoth
    {A, 963, 2199}, -- Wintergrasp Ranger
    {A, 963, 1755}, -- Within Our Grasp
    {A, 963, 1718}, -- Wintergrasp Veteran
    {A, 963, 1717}, -- Wintergrasp Victory
    {C, 1165, 963},
    {N, 963, a.GetCategoryInfoTitle(14901)}, -- Wintergrasp
    {A, 958, 712}, -- Warsong Outrider
    {A, 958, 713}, -- Silverwing Sentinel
    {A, 958, 1259}, -- Not So Fast
    {A, 958, 1173}, -- Master of Warsong Gulch
    {A, 958, 1172}, -- Master of Warsong Gulch
    {A, 958, 207}, -- Save The Day
    {A, 958, 1252}, -- Supreme Defender
    {A, 958, 206}, -- Supreme Defender
    {A, 958, 1502}, -- Quick Cap
    {A, 958, 202}, -- Quick Cap
    {A, 958, 1251}, -- Not In My House
    {A, 958, 203}, -- Not In My House
    {A, 958, 204}, -- Ironman
    {A, 958, 201}, -- Warsong Expedience
    {A, 958, 168}, -- Warsong Gulch Perfection
    {A, 958, 872}, -- Frenzied Defender
    {A, 958, 200}, -- Persistent Defender
    {A, 958, 199}, -- Capture the Flag
    {A, 958, 167}, -- Warsong Gulch Veteran
    {A, 958, 166}, -- Warsong Gulch Victory
    {C, 1165, 958},
    {N, 958, a.GetCategoryInfoTitle(14804)}, -- Warsong Gulch
    {A, 965, 5259}, -- Master of Twin Peaks
    {A, 965, 5223}, -- Master of Twin Peaks
    {A, 965, 5552}, -- Double Jeopardy
    {A, 965, 5231}, -- Double Jeopardy
    {A, 965, 5230}, -- Twin Peaks Mountaineer
    {A, 965, 5222}, -- "Fire, Walk With Me"
    {A, 965, 5221}, -- "Fire, Walk With Me"
    {A, 965, 5220}, -- I'm in the Black Lodge
    {A, 965, 5219}, -- I'm in the White Lodge
    {A, 965, 5228}, -- Wild Hammering
    {A, 965, 5229}, -- Drag a Maw
    {A, 965, 5227}, -- Cloud Nine
    {A, 965, 5226}, -- Cloud Nine
    {A, 965, 5216}, -- Peak Speed
    {A, 965, 5215}, -- Twin Peaks Perfection
    {A, 965, 5214}, -- Soaring Spirits
    {A, 965, 5213}, -- Soaring Spirits
    {A, 965, 5211}, -- Top Defender
    {A, 965, 5210}, -- Two-Timer
    {A, 965, 5209}, -- Twin Peaks Veteran
    {A, 965, 5208}, -- Twin Peaking
    {C, 1165, 965},
    {N, 965, a.GetCategoryInfoTitle(15074)}, -- Twin Peaks
    {C, 1165, 967},
    {N, 967, a.GetCategoryInfoTitle(15163)}, -- Temple of Kotmogu
    {A, 973, 2195}, -- Master of Strand of the Ancients
    {A, 973, 2194}, -- Master of Strand of the Ancients
    {A, 973, 2200}, -- Defense of the Ancients
    {A, 973, 1757}, -- Defense of the Ancients
    {A, 973, 2191}, -- Ancient Courtyard Protector
    {A, 973, 1766}, -- Ancient Protector
    {A, 973, 2190}, -- Drop It Now!
    {A, 973, 1764}, -- Drop It!
    {A, 973, 2189}, -- Artillery Expert
    {A, 973, 1763}, -- Artillery Veteran
    {A, 973, 2192}, -- Not Even a Scratch
    {A, 973, 1762}, -- Not Even a Scratch
    {A, 973, 2193}, -- Explosives Expert
    {A, 973, 1761}, -- The Dapper Sapper
    {A, 973, 1765}, -- Steady Hands
    {A, 973, 1310}, -- Storm the Beach
    {A, 973, 1309}, -- Strand of the Ancients Veteran
    {A, 973, 1308}, -- Strand of the Ancients Victory
    {C, 1165, 973},
    {N, 973, a.L["Strand of the Ancients"]}, -- Strand of the Ancients
    {C, 1165, 966},
    {N, 966, a.GetCategoryInfoTitle(15162)}, -- Silvershard Mines
    {C, 1165, 968},
    {N, 968, a.GetCategoryInfoTitle(15292)}, -- Seething Shore
    {A, 962, 4176}, -- Resource Glut
    {A, 962, 3846}, -- Resource Glut
    {A, 962, 3845}, -- Isle of Conquest All-Star
    {A, 962, 3957}, -- Master of Isle of Conquest
    {A, 962, 3857}, -- Master of Isle of Conquest
    {A, 962, 3855}, -- Glaive Grave
    {A, 962, 4256}, -- Demolition Derby
    {A, 962, 3856}, -- Demolition Derby
    {A, 962, 3854}, -- Back Door Job
    {A, 962, 3853}, -- All Over the Isle
    {A, 962, 3852}, -- Cut the Blue Wire... No the Red Wire!
    {A, 962, 3850}, -- Mowed Down
    {A, 962, 3849}, -- A-bomb-ination
    {A, 962, 3848}, -- A-bomb-inable
    {A, 962, 3847}, -- Four Car Garage
    {A, 962, 4177}, -- Mine
    {A, 962, 3851}, -- Mine
    {A, 962, 3777}, -- Isle of Conquest Veteran
    {A, 962, 3776}, -- Isle of Conquest Victory
    {C, 1165, 962},
    {N, 962, a.GetCategoryInfoTitle(15003)}, -- Isle of Conquest
    {A, 959, 211}, -- Storm Glory
    {A, 959, 1258}, -- Take a Chill Pill
    {A, 959, 587}, -- Stormy Assassin
    {A, 959, 1171}, -- Master of Eye of the Storm
    {A, 959, 233}, -- Bloodthirsty Berserker
    {A, 959, 216}, -- Bound for Glory
    {A, 959, 212}, -- Storm Capper
    {A, 959, 213}, -- Stormtrooper
    {A, 959, 214}, -- Flurry
    {A, 959, 784}, -- Eye of the Storm Domination
    {A, 959, 783}, -- The Perfect Storm
    {A, 959, 209}, -- Eye of the Storm Veteran
    {A, 959, 208}, -- Eye of the Storm Victory
    {C, 1165, 959},
    {N, 959, a.GetCategoryInfoTitle(14803)}, -- Eye of the Storm
    {C, 1165, 957},
    {N, 957, a.GetCategoryInfoTitle(15218)}, -- Deepwind Gorge
    {A, 964, 5258}, -- Master of the Battle for Gilneas
    {A, 964, 5262}, -- Double Rainbow
    {A, 964, 5257}, -- Battle for Gilneas Assassin
    {A, 964, 5256}, -- Battle for Gilneas All-Star
    {A, 964, 5255}, -- Jugger Not
    {A, 964, 5254}, -- Newbs to Plowshares
    {A, 964, 5253}, -- Full Coverage
    {A, 964, 5252}, -- Don't Get Cocky Kid
    {A, 964, 5251}, -- Not Your Average PUG'er
    {A, 964, 5250}, -- Out of the Fog
    {A, 964, 5249}, -- One Two Three You Don't Know About Me
    {A, 964, 5248}, -- Bustin' Caps to Make It Haps
    {A, 964, 5247}, -- Battle for Gilneas Perfection
    {A, 964, 5246}, -- Battle for Gilneas Veteran
    {A, 964, 5245}, -- Battle for Gilneas Victory
    {C, 1165, 964},
    {N, 964, a.GetCategoryInfoTitle(15073)}, -- Battle for Gilneas
    {C, 1165, 961},
    {N, 961, a.GetCategoryInfoTitle(15414)}, -- Ashran
    {A, 956, 710}, -- The Defiler
    {A, 956, 711}, -- Knight of Arathor
    {A, 956, 1170}, -- Master of Arathi Basin
    {A, 956, 1169}, -- Master of Arathi Basin
    {A, 956, 584}, -- Arathi Basin Assassin
    {A, 956, 583}, -- Arathi Basin All-Star
    {A, 956, 162}, -- We Had It All Along *cough*
    {A, 956, 159}, -- Let's Get This Done
    {A, 956, 156}, -- Territorial Dominance
    {A, 956, 161}, -- Resilient Victory
    {A, 956, 157}, -- To The Rescue!
    {A, 956, 1153}, -- Overly Defensive
    {A, 956, 73}, -- Disgracin' The Basin
    {A, 956, 158}, -- Me and the Cappin' Makin' it Happen
    {A, 956, 165}, -- Arathi Basin Perfection
    {A, 956, 155}, -- Arathi Basin Veteran
    {A, 956, 154}, -- Arathi Basin Victory
    {C, 1165, 956},
    {N, 956, a.GetCategoryInfoTitle(14802)}, -- Arathi Basin
    {A, 960, 708}, -- Hero of the Frostwolf Clan
    {A, 960, 709}, -- Hero of the Stormpike Guard
    {A, 960, 226}, -- The Alterac Blitz
    {A, 960, 1168}, -- Master of Alterac Valley
    {A, 960, 1167}, -- Master of Alterac Valley
    {A, 960, 1166}, -- To the Looter Go the Spoils
    {A, 960, 706}, -- Frostwolf Howler
    {A, 960, 707}, -- Stormpike Battle Charger
    {A, 960, 582}, -- Alterac Valley All-Star
    {A, 960, 873}, -- Frostwolf Perfection
    {A, 960, 220}, -- Stormpike Perfection
    {A, 960, 223}, -- The Sickly Gazelle
    {A, 960, 1164}, -- Everything Counts
    {A, 960, 225}, -- Everything Counts
    {A, 960, 224}, -- Loyal Defender
    {A, 960, 1151}, -- Loyal Defender
    {A, 960, 222}, -- Tower Defense
    {A, 960, 221}, -- Alterac Grave Robber
    {A, 960, 219}, -- Alterac Valley Veteran
    {A, 960, 218}, -- Alterac Valley Victory
    {C, 1165, 960},
    {N, 960, a.GetCategoryInfoTitle(14801)}, -- Alterac Valley
    {A, 1165, 5356}, -- High Warlord
    {A, 1165, 5343}, -- Grand Marshal
    {A, 1165, 5342}, -- Warlord
    {A, 1165, 5357}, -- Field Marshal
    {A, 1165, 5355}, -- General
    {A, 1165, 5341}, -- Marshal
    {A, 1165, 5354}, -- Lieutenant General
    {A, 1165, 5340}, -- Commander
    {A, 1165, 5353}, -- Champion
    {A, 1165, 5339}, -- Lieutenant Commander
    {A, 1165, 5338}, -- Centurion
    {A, 1165, 5359}, -- Knight-Champion
    {A, 1165, 5352}, -- Legionnaire
    {A, 1165, 5337}, -- Knight-Captain
    {A, 1165, 5351}, -- Blood Guard
    {A, 1165, 5336}, -- Knight-Lieutenant
    {A, 1165, 5350}, -- Stone Guard
    {A, 1165, 5335}, -- Knight
    {A, 1165, 5349}, -- First Sergeant
    {A, 1165, 5334}, -- Sergeant Major
    {A, 1165, 5348}, -- Senior Sergeant
    {A, 1165, 5333}, -- Master Sergeant
    {A, 1165, 5347}, -- Sergeant
    {A, 1165, 5332}, -- Sergeant
    {A, 1165, 5346}, -- Grunt
    {A, 1165, 5331}, -- Corporal
    {A, 1165, 5345}, -- Scout
    {A, 1165, 5330}, -- Private
    {A, 1165, 5326}, -- Warbringer of the Horde
    {A, 1165, 5329}, -- Warbound Veteran of the Alliance
    {A, 1165, 5824}, -- Veteran of the Horde II
    {A, 1165, 5823}, -- Veteran of the Alliance II
    {A, 1165, 5325}, -- Veteran of the Horde
    {A, 1165, 5328}, -- Veteran of the Alliance
    {A, 1165, 5324}, -- In Service of the Horde
    {A, 1165, 5327}, -- In Service of the Alliance
    {A, 1165, 5323}, -- In Service of the Horde
    {A, 1165, 5322}, -- In Service of the Alliance
    {A, 1165, 5269}, -- In Service of the Horde
    {A, 1165, 5268}, -- In Service of the Alliance
    {A, 1165, 1175}, -- Battlemaster
    {A, 1165, 230}, -- Battlemaster
    {A, 1165, 231}, -- Wrecking Ball
    {A, 1165, 227}, -- Damage Control
    {A, 1165, 909}, -- Call to Arms!
    {A, 1165, 908}, -- Call to Arms!
    {A, 1165, 714}, -- The Conqueror
    {A, 1165, 907}, -- The Justicar
    {A, 1165, 229}, -- The Grim Reaper
    {C, 955, 1165},
    {N, 1165, a.GetCategoryInfoTitle(153)}, -- Battlegrounds
    {C, 955, 1167},
    {N, 1167, a.GetCategoryInfoTitle(15266)}, -- Honor
    {A, 1162, 700}, -- Freedom of the Horde
    {A, 1162, 701}, -- Freedom of the Alliance
    {A, 1162, 5539}, -- "50,000 Conquest Points"
    {A, 1162, 5540}, -- "25,000 Conquest Points"
    {A, 1162, 5541}, -- 5000 Conquest Points
    {A, 1162, 5542}, -- 1000 Conquest Points
    {A, 1162, 3618}, -- Murkimus the Gladiator
    {A, 1162, 727}, -- Call in the Cavalry
    {A, 1162, 247}, -- "Make Love, Not Warcraft"
    {A, 1162, 1005}, -- Know Thy Enemy
    {A, 1162, 246}, -- Know Thy Enemy
    {A, 1162, 245}, -- That Takes Class
    {A, 1162, 1157}, -- Duel-icious
    {A, 1162, 5363}, -- 250000 Honorable Kills
    {A, 1162, 870}, -- 100000 Honorable Kills
    {A, 1162, 869}, -- 50000 Honorable Kills
    {A, 1162, 239}, -- 25000 Honorable Kills
    {A, 1162, 509}, -- 10000 Honorable Kills
    {A, 1162, 512}, -- 5000 Honorable Kills
    {A, 1162, 516}, -- 1000 Honorable Kills
    {A, 1162, 515}, -- 500 Honorable Kills
    {A, 1162, 513}, -- 100 Honorable Kills
    {A, 1162, 238}, -- An Honorable Kill
    {C, 955, 1162},
    {N, 1162, a.GetCategoryInfoTitle(95)}, -- Player vs. Player
    {F, 1397, "SearchResultsCategories"},
    {C, 955, 1397},
    {N, 1397, a.L["Search Results"]}, -- Search Results
    function() categories[1222].IsSelectedZone = true; end,
    {F, 1222, "SelectedZoneCategories"},
    {C, 955, 1222},
    {N, 1222, a.L["Selected Zone"]}, -- Selected Zone
    function() categories[1215].IsCurrentZone = true; end,
    {F, 1215, "CurrentZoneCategories"},
    {C, 955, 1215},
    {N, 1215, a.L["Current Zone"]}, -- Current Zone
    function() categories[1219].IsWatchList = true; end,
    {F, 1219, "WatchListCategories"},
    {C, 955, 1219},
    {N, 1219, a.L["Watch List"]}, -- Watch List
    {S, 1205},
    {V, 1205},
    {C, 955, 1205},
    {N, 1205, a.L["Summary"]}, -- Summary
    {T, 955, "PvP"},
    {N, 955, a.GetCategoryInfoTitle(95)}, -- TAB - PvP
    {F, 1555, "UncategorizedCategories"},
    {C, 884, 1555},
    {N, 1555, a.L["Uncategorized"]}, -- Uncategorized
    {F, 1226, "ExcludedCategories"},
    {C, 884, 1226},
    {N, 1226, a.L["Excluded"]}, -- Excluded
    function() categories[1369].IsTracking = true; end,
    {F, 1369, "TrackingAchievementsCategories"},
    {C, 884, 1369},
    {N, 1369, a.L["Tracking Achievements"]}, -- Tracking Achievements
    {A, 1174, 2116}, -- Tabard of the Argent Dawn
    {A, 1174, 2079}, -- Tabard of the Protector
    {A, 1174, 1637}, -- Spirit of Competition
    {A, 1174, 1636}, -- Competitor's Tabard
    {C, 884, 1174},
    {N, 1174, a.L["Miscellaneous"]}, -- Miscellaneous
    {A, 1030, 2336}, -- Insane in the Membrane
    {C, 925, 1030},
    {N, 1030, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 925, 6031}, -- Taking the Show on the Road
    {A, 925, 6030}, -- Taking the Show on the Road
    {A, 925, 6020}, -- Step Right Up
    {A, 925, 6022}, -- Quick Shot
    {A, 925, 6025}, -- I Was Promised a Pony
    {A, 925, 6026}, -- Fairegoer's Feast
    {A, 925, 6032}, -- Faire Favors
    {A, 925, 6029}, -- Darkmoon Despoiler
    {A, 925, 6028}, -- Darkmoon Defender
    {A, 925, 6027}, -- Darkmoon Dungeoneer
    {A, 925, 6024}, -- Darkmoon Dominator
    {A, 925, 6023}, -- Darkmoon Duelist
    {A, 925, 6021}, -- Blastenheimer Bullseye
    {A, 925, 6019}, -- "Come One, Come All!"
    {C, 884, 925},
    {N, 925, a.GetCategoryInfoTitle(15101)}, -- Darkmoon Faire
    {A, 1173, 6131}, -- WoW's 8th Anniversary
    {A, 1173, 5863}, -- WoW's 7th Anniversary
    {A, 1173, 5512}, -- WoW's 6th Anniversary
    {A, 1173, 4400}, -- WoW's 5th Anniversary
    {A, 1173, 2398}, -- WoW's 4th Anniversary
    {C, 884, 1173},
    {N, 1173, a.L["WoW's Anniversary"]}, -- WoW's Anniversary
    {A, 950, 6061}, -- Gaudy Winter Veil Sweater
    {A, 950, 6060}, -- MiniZep Controller
    {A, 950, 6059}, -- Red Rider Air Rifle
    {A, 950, 1706}, -- Crashin' Thrashin' Racer
    {A, 950, 1705}, -- Clockwork Rocket Bot
    {C, 917, 950},
    {N, 950, a.L["Gifts"], true}, -- Gifts
    {A, 917, 1691}, -- Merrymaker
    {A, 917, 1692}, -- Merrymaker
    {A, 917, 5854}, -- A-Caroling We Will Go
    {A, 917, 5853}, -- A-Caroling We Will Go
    {A, 917, 4437}, -- BB King
    {A, 917, 4436}, -- BB King
    {A, 917, 1690}, -- A Frosty Shake
    {A, 917, 1689}, -- He Knows If You've Been Naughty
    {A, 917, 1688}, -- The Winter Veil Gourmet
    {A, 917, 1686}, -- Holiday Bromance
    {A, 917, 1685}, -- Holiday Bromance
    {A, 917, 1687}, -- Let It Snow
    {A, 917, 279}, -- Simply Abominable
    {A, 917, 1295}, -- Crashin' & Thrashin'
    {A, 917, 277}, -- 'Tis the Season
    {A, 917, 1282}, -- Fa-la-la-la-Ogri'la
    {A, 917, 1255}, -- Scrooge
    {A, 917, 259}, -- Scrooge
    {A, 917, 252}, -- With a Little Helper from My Friends
    {A, 917, 273}, -- On Metzen!
    {C, 918, 917},
    {N, 917, a.GetCategoryInfoTitle(156)}, -- Winter Veil
    {A, 916, 3656}, -- Pilgrim
    {A, 916, 3478}, -- Pilgrim
    {A, 916, 3559}, -- Turkey Lurkey
    {A, 916, 3578}, -- The Turkinator
    {A, 916, 3582}, -- Terokkar Turkey Time
    {A, 916, 3558}, -- Sharing is Caring
    {A, 916, 3597}, -- Pilgrim's Progress
    {A, 916, 3596}, -- Pilgrim's Progress
    {A, 916, 3581}, -- Pilgrim's Peril
    {A, 916, 3580}, -- Pilgrim's Peril
    {A, 916, 3557}, -- Pilgrim's Paunch
    {A, 916, 3556}, -- Pilgrim's Paunch
    {A, 916, 3577}, -- Now We're Cookin'
    {A, 916, 3576}, -- Now We're Cookin'
    {A, 916, 3579}, -- """FOOD FIGHT!"""
    {C, 918, 916},
    {N, 916, a.GetCategoryInfoTitle(14981)}, -- Pilgrim's Bounty
    {A, 920, 3456}, -- Dead Man's Party
    {C, 918, 920},
    {N, 920, a.L["Day of the Dead"]}, -- Day of the Dead
    {A, 915, 980}, -- The Horseman's Reins
    {A, 915, 1657}, -- Hallowed Be Thy Name
    {A, 915, 1656}, -- Hallowed Be Thy Name
    {A, 915, 5838}, -- Tricks and Treats of the Cataclysm
    {A, 915, 5837}, -- Tricks and Treats of the Cataclysm
    {A, 915, 5835}, -- Tricks and Treats of Northrend
    {A, 915, 5836}, -- Tricks and Treats of Northrend
    {A, 915, 971}, -- Tricks and Treats of Azeroth
    {A, 915, 970}, -- Tricks and Treats of Azeroth
    {A, 915, 968}, -- Tricks and Treats of Outland
    {A, 915, 969}, -- Tricks and Treats of Outland
    {A, 915, 965}, -- Tricks and Treats of Kalimdor
    {A, 915, 963}, -- Tricks and Treats of Kalimdor
    {A, 915, 967}, -- Tricks and Treats of Eastern Kingdoms
    {A, 915, 966}, -- Tricks and Treats of Eastern Kingdoms
    {A, 915, 292}, -- Sinister Calling
    {A, 915, 283}, -- The Masquerade
    {A, 915, 291}, -- Check Your Head
    {A, 915, 1261}, -- G.N.E.R.D. Rage
    {A, 915, 1041}, -- Rotten Hallow
    {A, 915, 1040}, -- Rotten Hallow
    {A, 915, 981}, -- That Sparkling Smile
    {A, 915, 284}, -- A Mask for All Occasions
    {A, 915, 979}, -- The Mask Task
    {A, 915, 289}, -- The Savior of Hallow's End
    {A, 915, 255}, -- Bring Me The Head of... Oh Wait
    {A, 915, 288}, -- Out With It
    {A, 915, 972}, -- Trick or Treat!
    {C, 918, 915},
    {N, 915, a.GetCategoryInfoTitle(158)}, -- Hallow's End
    {A, 914, 1186}, -- Down With The Dark Iron
    {A, 914, 4782}, -- Green Brewfest Stein
    {A, 914, 1293}, -- Blue Brewfest Stein
    {A, 914, 1292}, -- Yellow Brewfest Stein
    {A, 914, 1683}, -- Brewmaster
    {A, 914, 1684}, -- Brewmaster
    {A, 914, 303}, -- "Have Keg, Will Travel"
    {A, 914, 293}, -- Disturbing the Peace
    {A, 914, 295}, -- Direbrewfest
    {A, 914, 1260}, -- Drunken Stupor
    {A, 914, 1183}, -- Brew of the Year
    {A, 914, 2796}, -- Brew of the Month
    {A, 914, 1185}, -- The Brewfest Diet
    {A, 914, 1936}, -- Does Your Wolpertinger Linger?
    {A, 914, 1203}, -- Strange Brew
    {A, 914, 1184}, -- Strange Brew
    {C, 918, 914},
    {N, 914, a.GetCategoryInfoTitle(162)}, -- Brewfest
    {A, 919, 3457}, -- The Captain's Booty
    {C, 918, 919},
    {N, 919, a.L["Pirates' Day"]}, -- Pirates' Day
    {A, 913, 1039}, -- The Flame Keeper
    {A, 913, 1038}, -- The Flame Warden
    {A, 913, 1037}, -- Desecration of the Alliance
    {A, 913, 1035}, -- Desecration of the Horde
    {A, 913, 6014}, -- Extinguishing the Cataclysm
    {A, 913, 6013}, -- Extinguishing the Cataclysm
    {A, 913, 6010}, -- Extinguishing Northrend
    {A, 913, 6007}, -- Extinguishing Northrend
    {A, 913, 1033}, -- Extinguishing Outland
    {A, 913, 1030}, -- Extinguishing Outland
    {A, 913, 1032}, -- Extinguishing Kalimdor
    {A, 913, 1029}, -- Extinguishing Kalimdor
    {A, 913, 1031}, -- Extinguishing Eastern Kingdoms
    {A, 913, 1028}, -- Extinguishing Eastern Kingdoms
    {A, 913, 1036}, -- The Fires of Azeroth
    {A, 913, 1034}, -- The Fires of Azeroth
    {A, 913, 6012}, -- Flame Keeper of Cataclysm
    {A, 913, 6011}, -- Flame Warden of Cataclysm
    {A, 913, 6009}, -- Flame Keeper of Northrend
    {A, 913, 6008}, -- Flame Warden of Northrend
    {A, 913, 1027}, -- Flame Keeper of Outland
    {A, 913, 1024}, -- Flame Warden of Outland
    {A, 913, 1026}, -- Flame Keeper of Kalimdor
    {A, 913, 1023}, -- Flame Warden of Kalimdor
    {A, 913, 1025}, -- Flame Keeper of Eastern Kingdoms
    {A, 913, 1022}, -- Flame Warden of Eastern Kingdoms
    {A, 913, 272}, -- Torch Juggler
    {A, 913, 1145}, -- King of the Fire Festival
    {A, 913, 271}, -- Burning Hot Pole Dance
    {A, 913, 263}, -- Ice the Frost Lord
    {C, 918, 913},
    {N, 913, a.GetCategoryInfoTitle( 161)}, -- Midsummer
    {A, 912, 1793}, -- For The Children
    {A, 912, 275}, -- Veteran Nanny
    {A, 912, 1790}, -- "Hail To The King, Baby"
    {A, 912, 1786}, -- School of Hard Knocks
    {A, 912, 1792}, -- "Aw, Isn't It Cute?"
    {A, 912, 1789}, -- Daily Chores
    {A, 912, 1788}, -- Bad Example
    {A, 912, 1791}, -- Home Alone
    {C, 918, 912},
    {N, 912, a.GetCategoryInfoTitle(163)}, -- Children's Week
    {A, 911, 2798}, -- Noble Gardener
    {A, 911, 2797}, -- Noble Gardener
    {A, 911, 2576}, -- Blushing Bride
    {A, 911, 2436}, -- Desert Rose
    {A, 911, 2422}, -- Shake Your Bunny-Maker
    {A, 911, 2420}, -- Noble Garden
    {A, 911, 2421}, -- Noble Garden
    {A, 911, 2497}, -- Spring Fling
    {A, 911, 2419}, -- Spring Fling
    {A, 911, 2416}, -- Hard Boiled
    {A, 911, 249}, -- Dressed for the Occasion
    {A, 911, 248}, -- Sunday's Finest
    {A, 911, 2418}, -- Chocoholic
    {A, 911, 2417}, -- Chocolate Lover
    {A, 911, 2676}, -- I Found One!
    {C, 918, 911},
    {N, 911, a.GetCategoryInfoTitle(159)}, -- Noblegarden
    {A, 910, 1693}, -- Fool For Love
    {A, 910, 1707}, -- Fool For Love
    {A, 910, 4624}, -- Tough Love
    {A, 910, 1702}, -- Sweet Tooth
    {A, 910, 1188}, -- Shafted!
    {A, 910, 1696}, -- The Rocket's Pink Glare
    {A, 910, 1700}, -- Perma-Peddle
    {A, 910, 1698}, -- Nation of Adoration
    {A, 910, 1697}, -- Nation of Adoration
    {A, 910, 1703}, -- "My Love is Like a Red, Red Rose"
    {A, 910, 1694}, -- Lovely Luck Is On Your Side
    {A, 910, 1291}, -- Lonely?
    {A, 910, 1704}, -- I Pitied The Fool
    {A, 910, 1280}, -- Flirt With Disaster
    {A, 910, 1279}, -- Flirt With Disaster
    {A, 910, 1699}, -- Fistful of Love
    {A, 910, 1695}, -- Dangerous Love
    {A, 910, 260}, -- Charming
    {A, 910, 1701}, -- Be Mine!
    {C, 918, 910},
    {N, 910, a.GetCategoryInfoTitle(187)}, -- Love is in the Air
    {A, 885, 913}, -- To Honor One's Elders
    {A, 885, 910}, -- Elders of the Dungeons
    {A, 885, 6006}, -- Elders of Cataclysm
    {A, 885, 1396}, -- Elders of Northrend
    {A, 885, 911}, -- Elders of Kalimdor
    {A, 885, 912}, -- Elders of Eastern Kingdoms
    {A, 885, 914}, -- Elders of the Horde
    {A, 885, 915}, -- Elders of the Alliance
    {A, 885, 937}, -- Elune's Blessing
    {A, 885, 1552}, -- Frenzied Firecracker
    {A, 885, 1281}, -- The Rocket's Red Glare
    {A, 885, 626}, -- Lunar Festival Finery
    {A, 885, 609}, -- 50 Coins of Ancestry
    {A, 885, 608}, -- 25 Coins of Ancestry
    {A, 885, 607}, -- 10 Coins of Ancestry
    {A, 885, 606}, -- 5 Coins of Ancestry
    {A, 885, 605}, -- A Coin of Ancestry
    {C, 918, 885},
    {N, 885, a.GetCategoryInfoTitle(160)}, -- Lunar Festival
    {A, 918, 2145}, -- "What A Long, Strange Trip It's Been"
    {A, 918, 2144}, -- "What A Long, Strange Trip It's Been"
    {C, 884, 918},
    {N, 918, a.L["Holidays"]}, -- Holidays
    {F, 1398, "SearchResultsCategories"},
    {C, 884, 1398},
    {N, 1398, a.L["Search Results"]}, -- Search Results
    function() categories[1221].IsSelectedZone = true; end,
    {F, 1221, "SelectedZoneCategories"},
    {C, 884, 1221},
    {N, 1221, a.L["Selected Zone"]}, -- Selected Zone
    function() categories[1214].IsCurrentZone = true; end,
    {F, 1214, "CurrentZoneCategories"},
    {C, 884, 1214},
    {N, 1214, a.L["Current Zone"]}, -- Current Zone
    function() categories[1218].IsWatchList = true; end,
    {F, 1218, "WatchListCategories"},
    {C, 884, 1218},
    {N, 1218, a.L["Watch List"]}, -- Watch List
    {S, 1206},
    {V, 1206},
    {C, 884, 1206},
    {N, 1206, a.L["Summary"]}, -- Summary
    {T, 884, "Events"},
    {N, 884, a.L["Events"]}, -- TAB - Events
    {F, 1554, "UncategorizedCategories"},
    {C, 883, 1554},
    {N, 1554, a.L["Uncategorized"]}, -- Uncategorized
    {F, 1225, "ExcludedCategories"},
    {C, 883, 1225},
    {N, 1225, a.L["Excluded"]}, -- Excluded
    function() categories[1370].IsTracking = true; end,
    {F, 1370, "TrackingAchievementsCategories"},
    {C, 883, 1370},
    {N, 1370, a.L["Tracking Achievements"]}, -- Tracking Achievements
    {A, 575, 5376}, -- Hellscream's Reach
    {A, 575, 5375}, -- Baradin's Wardens
    {C, 547, 575},
    {N, 575, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 569, 5486}, -- Tol Barad All-Star
    {A, 569, 5487}, -- Tol Barad Saboteur
    {A, 569, 5488}, -- Towers of Power
    {A, 569, 5415}, -- Tower Plower
    {A, 569, 5417}, -- Tol Barad Veteran
    {A, 569, 5418}, -- Tol Barad Veteran
    {A, 569, 5412}, -- Tol Barad Victory
    {C, 547, 569},
    {N, 569, a.GetCategoryInfoTitle(95), true}, -- PvP
    {A, 563, 5719}, -- Just Another Day in Tol Barad
    {A, 563, 5718}, -- Just Another Day in Tol Barad
    {A, 563, 4874}, -- Breaking Out of Tol Barad
    {C, 547, 563},
    {N, 563, a.GetCategoryInfoTitle(96), true}, -- Quests
    {A, 547, 5490}, -- Master of Tol Barad
    {A, 547, 5489}, -- Master of Tol Barad
    {C, 129, 547},
    {N, 547, a.GetCategoryInfoTitle(15075)}, -- Tol Barad
    {C, 129, 788},
    {N, 788, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {A, 1527, 5480}, -- Preparing for Disaster
    {C, 1153, 1527},
    {N, 1527, a.GetCategoryInfoTitle(15496), true}, -- Tailoring
    {A, 1497, 4917}, -- Illustrious Grand Master Fisherman
    {C, 1153, 1497},
    {N, 1497, a.GetCategoryInfoTitle(171), true}, -- Fishing
    {A, 1480, 5473}, -- The Cataclysmic Gourmet
    {A, 1480, 5472}, -- The Cataclysmic Gourmet
    {A, 1480, 4916}, -- Illustrious Grand Master Cook
    {C, 1153, 1480},
    {N, 1480, a.GetCategoryInfoTitle(170), true}, -- Cooking
    {A, 1471, 5301}, -- The Boy Who Would be King
    {A, 1471, 4923}, -- Illustrious Grand Master in Archaeology
    {C, 1153, 1471},
    {N, 1471, a.GetCategoryInfoTitle(15071), true}, -- Archaeology
    {A, 1153, 4915}, -- More Skills to Pay the Bills
    {A, 1153, 4918}, -- Illustrious Grand Master in First Aid
    {A, 1153, 4914}, -- Working Around the Clock
    {A, 1153, 4924}, -- Professional Illustrious Grand Master
    {C, 129, 1153},
    {N, 1153, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 909, 6116}, -- Heroic: Madness of Deathwing
    {A, 909, 6115}, -- Heroic: Spine of Deathwing
    {A, 909, 6114}, -- Heroic: Warmaster Blackhorn
    {A, 909, 6113}, -- Heroic: Ultraxion
    {A, 909, 6112}, -- Heroic: Hagara the Stormbinder
    {A, 909, 6111}, -- Heroic: Yor'sahj the Unsleeping
    {A, 909, 6110}, -- Heroic: Warlord Zon'ozz
    {A, 909, 6109}, -- Heroic: Morchok
    {C, 151, 909},
    {N, 909, a.L["Heroic"]}, -- Heroic
    {A, 908, 6180}, -- Chromatic Champion
    {A, 908, 6133}, -- Maybe He'll Get Dizzy...
    {A, 908, 6105}, -- Deck Defender
    {A, 908, 6084}, -- Minutes to Midnight
    {A, 908, 6129}, -- Taste the Rainbow!
    {A, 908, 6128}, -- Ping Pong Champion
    {A, 908, 6174}, -- Don't Stand So Close to Me
    {C, 151, 908},
    {N, 908, a.L["Glory"]}, -- Glory
    {A, 151, 6181}, -- Fangs of the Father
    {A, 151, 6177}, -- Destroyer's End
    {A, 151, 6107}, -- Fall of Deathwing
    {A, 151, 6106}, -- Siege of Wyrmrest Temple
    {A, 151, 5518}, -- Stood in the Fire
    {A, 151, 6175}, -- Holding Hands
    {C, 131, 151},
    {N, 151, a.GetInstanceInfoName(187)}, -- Dragon Soul
    {A, 576, 5827}, -- Avengers of Hyjal
    {C, 150, 576},
    {N, 576, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 907, 5803}, -- Heroic: Ragnaros
    {A, 907, 5804}, -- Heroic: Majordomo Fandral Staghelm
    {A, 907, 5805}, -- Heroic: Baleroc
    {A, 907, 5806}, -- Heroic: Shannox
    {A, 907, 5808}, -- Heroic: Lord Rhyolith
    {A, 907, 5809}, -- Heroic: Alysrazor
    {A, 907, 5807}, -- Heroic: Beth'tilac
    {C, 150, 907},
    {N, 907, a.L["Heroic"]}, -- Heroic
    {A, 906, 5799}, -- Only the Penitent...
    {A, 906, 5830}, -- Share the Pain
    {A, 906, 5829}, -- Bucket List
    {A, 906, 5810}, -- Not an Ambi-Turner
    {A, 906, 5813}, -- Do a Barrel Roll!
    {A, 906, 5821}, -- Death from Above
    {C, 150, 906},
    {N, 906, a.L["Glory"]}, -- Glory
    {A, 150, 5839}, -- "Dragonwrath, Tarecgosa's Rest"
    {A, 150, 5802}, -- Firelands
    {A, 150, 5855}, -- Ragnar-O's
    {C, 131, 150},
    {N, 150, a.GetInstanceInfoName(78)}, -- Firelands
    {A, 149, 4851}, -- Throne of the Four Winds
    {A, 149, 5123}, -- Heroic: Al'Akir
    {A, 149, 5122}, -- Heroic: Conclave of Wind
    {A, 149, 5305}, -- Four Play
    {A, 149, 5304}, -- Stay Chill
    {C, 131, 149},
    {N, 149, a.GetInstanceInfoName(74)}, -- Throne of the Four Winds
    {A, 905, 5121}, -- Heroic: Sinestra
    {A, 905, 5120}, -- Heroic: Cho'gall
    {A, 905, 5119}, -- Heroic: Ascendant Council
    {A, 905, 5117}, -- Heroic: Valiona and Theralion
    {A, 905, 5118}, -- Heroic: Halfus Wyrmbreaker
    {C, 148, 905},
    {N, 905, a.L["Heroic"]}, -- Heroic
    {A, 904, 5312}, -- The Abyss Will Gaze Back Into You
    {A, 904, 5311}, -- Elementary
    {A, 904, 4852}, -- Double Dragon
    {A, 904, 5300}, -- The Only Escape
    {C, 148, 904},
    {N, 904, a.L["Glory"]}, -- Glory
    {A, 148, 5313}, -- I Can't Hear You Over the Sound of How Awesome I Am
    {A, 148, 4850}, -- The Bastion of Twilight
    {C, 131, 148},
    {N, 148, a.GetInstanceInfoName(72)}, -- The Bastion of Twilight
    {A, 903, 5116}, -- Heroic: Nefarian
    {A, 903, 5108}, -- Heroic: Maloriak
    {A, 903, 5109}, -- Heroic: Atramedes
    {A, 903, 5115}, -- Heroic: Chimaeron
    {A, 903, 5107}, -- Heroic: Omnotron Defense System
    {A, 903, 5094}, -- Heroic: Magmaw
    {C, 147, 903},
    {N, 903, a.L["Heroic"]}, -- Heroic
    {A, 902, 4849}, -- Keeping it in the Family
    {A, 902, 5310}, -- Aberrant Behavior
    {A, 902, 5308}, -- Silence is Golden
    {A, 902, 5309}, -- Full of Sound and Fury
    {A, 902, 5307}, -- Achieve-a-tron
    {A, 902, 5306}, -- Parasite Evening
    {C, 147, 902},
    {N, 902, a.L["Glory"]}, -- Glory
    {A, 147, 4842}, -- Blackwing Descent
    {C, 131, 147},
    {N, 147, a.GetInstanceInfoName(73)}, -- Blackwing Descent
    {A, 146, 6108}, -- Alizabal
    {A, 146, 6045}, -- Occu'thar
    {A, 146, 5416}, -- Pit Lord Argaloth
    {C, 131, 146},
    {N, 146, a.GetInstanceInfoName(75)}, -- Baradin Hold
    {A, 131, 6169}, -- Glory of the Dragon Soul Raider
    {A, 131, 5828}, -- Glory of the Firelands Raider
    {A, 131, 4853}, -- Glory of the Cataclysm Raider
    {A, 131, 5506}, -- Defender of a Shattered World
    {C, 129, 131},
    {N, 131, a.GetCategoryInfoTitle(15271)}, -- Raids
    {A, 145, 6119}, -- Heroic: Hour of Twilight
    {A, 145, 6132}, -- Eclipse
    {C, 130, 145},
    {N, 145, a.GetInstanceInfoName(186)}, -- Hour of Twilight
    {A, 144, 6118}, -- Heroic: Well of Eternity
    {A, 144, 6070}, -- That's Not Canon!
    {A, 144, 6127}, -- Lazy Eye
    {C, 130, 144},
    {N, 144, a.GetInstanceInfoName(185)}, -- Well of Eternity
    {A, 143, 6117}, -- Heroic: End Time
    {A, 143, 6130}, -- Severed Ties
    {A, 143, 5995}, -- Moon Guard
    {C, 130, 143},
    {N, 143, a.GetInstanceInfoName(184)}, -- End Time
    {A, 142, 5769}, -- Heroic: Zul'Aman
    {A, 142, 5760}, -- Ring Out!
    {A, 142, 5761}, -- Hex Mix
    {A, 142, 5750}, -- Tunnel Vision
    {A, 142, 5858}, -- Bear-ly Made It
    {C, 130, 142},
    {N, 142, a.GetInstanceInfoName(77)}, -- Zul'Aman
    {A, 141, 5768}, -- Heroic: Zul'Gurub
    {A, 141, 5744}, -- Gurubashi Headhunter
    {A, 141, 5759}, -- Spirit Twister
    {A, 141, 5765}, -- "Here, Kitty Kitty..."
    {A, 141, 5762}, -- Ohganot So Fast!
    {A, 141, 5743}, -- It's Not Easy Being Green
    {C, 130, 141},
    {N, 141, a.GetInstanceInfoName(76)}, -- Zul'Gurub
    {A, 140, 4627}, -- X-45 Heartbreaker
    {A, 140, 5093}, -- Heroic: Shadowfang Keep
    {A, 140, 631}, -- Shadowfang Keep
    {A, 140, 5505}, -- Bullet Time
    {A, 140, 5504}, -- To the Ground!
    {A, 140, 5503}, -- Pardon Denied
    {C, 130, 140},
    {N, 140, a.GetInstanceInfoName(64)}, -- Shadowfang Keep
    {A, 139, 5083}, -- Heroic: Deadmines
    {A, 139, 628}, -- Deadmines
    {A, 139, 5371}, -- Vigorous VanCleef Vindicator
    {A, 139, 5370}, -- I'm on a Diet
    {A, 139, 5369}, -- It's Frost Damage
    {A, 139, 5368}, -- Prototype Prodigy
    {A, 139, 5367}, -- Rat Pack
    {A, 139, 5366}, -- Ready for Raiding
    {C, 130, 139},
    {N, 139, a.GetInstanceInfoName(63)}, -- Deadmines
    {A, 138, 5066}, -- Heroic: Lost City of the Tol'vir
    {A, 138, 4848}, -- Lost City of the Tol'vir
    {A, 138, 5292}, -- Headed South
    {A, 138, 5290}, -- Kill It With Fire!
    {A, 138, 5291}, -- Acrocalypse Now
    {C, 130, 138},
    {N, 138, a.GetInstanceInfoName(69)}, -- Lost City of the Tol'vir
    {A, 137, 5065}, -- Heroic: Halls of Origination
    {A, 137, 4841}, -- Halls of Origination
    {A, 137, 5295}, -- Sun of a....
    {A, 137, 5296}, -- Faster Than the Speed of Light
    {A, 137, 5294}, -- Straw That Broke the Camel's Back
    {A, 137, 5293}, -- I Hate That Song
    {C, 130, 137},
    {N, 137, a.GetInstanceInfoName(70)}, -- Halls of Origination
    {A, 136, 5062}, -- Heroic: Grim Batol
    {A, 136, 4840}, -- Grim Batol
    {A, 136, 5298}, -- Don't Need to Break Eggs to Make an Omelet
    {A, 136, 5297}, -- Umbrage for Umbriss
    {C, 130, 136},
    {N, 136, a.GetInstanceInfoName(71)}, -- Grim Batol
    {A, 135, 5064}, -- Heroic: The Vortex Pinnacle
    {A, 135, 4847}, -- The Vortex Pinnacle
    {A, 135, 5288}, -- No Static at All
    {A, 135, 5289}, -- Extra Credit Bonus Stage
    {C, 130, 135},
    {N, 135, a.GetInstanceInfoName(68)}, -- The Vortex Pinnacle
    {A, 134, 5063}, -- Heroic: The Stonecore
    {A, 134, 4846}, -- The Stonecore
    {A, 134, 5287}, -- Rotten to the Core
    {C, 130, 134},
    {N, 134, a.GetInstanceInfoName(67)}, -- The Stonecore
    {A, 133, 5061}, -- Heroic: Throne of the Tides
    {A, 133, 4839}, -- Throne of the Tides
    {A, 133, 5286}, -- Prince of Tides
    {A, 133, 5285}, -- Old Faithful
    {C, 130, 133},
    {N, 133, a.GetInstanceInfoName(65)}, -- Throne of the Tides
    {A, 132, 5060}, -- Heroic: Blackrock Caverns
    {A, 132, 4833}, -- Blackrock Caverns
    {A, 132, 5284}, -- Ascendant Descending
    {A, 132, 5283}, -- Too Hot to Handle
    {A, 132, 5282}, -- Arrested Development
    {A, 132, 5281}, -- Crushing Bones and Cracking Skulls
    {C, 130, 132},
    {N, 132, a.GetInstanceInfoName(66)}, -- Blackrock Caverns
    {A, 130, 4845}, -- Glory of the Cataclysm Hero
    {A, 130, 5506}, -- Defender of a Shattered World
    {A, 130, 4844}, -- Cataclysm Dungeon Hero
    {C, 129, 130},
    {N, 130, a.GetCategoryInfoTitle(15272)}, -- Dungeons
    {A, 556, 5879}, -- Veteran of the Molten Front
    {A, 556, 5873}, -- Ready for Raiding II
    {A, 556, 5874}, -- Death From Above
    {A, 556, 5872}, -- King of the Spider-Hill
    {A, 556, 5871}, -- Master of the Molten Flow
    {A, 556, 5867}, -- Flawless Victory
    {A, 556, 5866}, -- The Molten Front Offensive
    {A, 556, 5859}, -- Legacy of Leyara
    {C, 550, 556},
    {N, 556, a.GetMapName(338)}, -- Molten Front
    {A, 573, 4886}, -- Dragonmaw Clan
    {A, 573, 4885}, -- Wildhammer Clan
    {A, 573, 762}, -- Ambassador of the Horde
    {A, 573, 948}, -- Ambassador of the Alliance
    {C, 555, 573},
    {N, 573, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 568, 4866}, -- Explore Twilight Highlands
    {C, 555, 568},
    {N, 568, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 561, 4958}, -- The First Rule of Ring of Blood is You Don't Talk About Ring of Blood
    {A, 561, 5451}, -- Consumed by Nightmare
    {A, 561, 5321}, -- King of the Mountain
    {A, 561, 5320}, -- King of the Mountain
    {A, 561, 5482}, -- Dragonmaw Tour of Duty
    {A, 561, 5481}, -- Wildhammer Tour of Duty
    {A, 561, 4960}, -- Round Three. Fight!
    {A, 561, 5501}, -- Fading into Twilight
    {A, 561, 4873}, -- Fading into Twilight
    {C, 555, 561},
    {N, 561, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 550, 555},
    {N, 555, a.GetMapName(241)}, -- Twilight Highlands
    {A, 574, 4884}, -- Ramkahen
    {C, 554, 574},
    {N, 574, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 567, 4865}, -- Explore Uldum
    {C, 554, 567},
    {N, 567, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 560, 5317}, -- Help the Bombardier! I'm the Bombardier!
    {A, 560, 4961}, -- In a Thousand Years Even You Might be Worth Something
    {A, 560, 4872}, -- Unearthing Uldum
    {C, 554, 560},
    {N, 560, a.GetCategoryInfoTitle(96), true}, -- Quests
    {A, 554, 4888}, -- One Hump or Two?
    {A, 554, 5767}, -- Scourer of the Eternal Sands
    {C, 550, 554},
    {N, 554, a.GetMapName(249)}, -- Uldum
    {A, 572, 4883}, -- Therazane
    {C, 553, 572},
    {N, 572, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 566, 4864}, -- Explore Deepholm
    {C, 553, 566},
    {N, 566, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 559, 5447}, -- My Very Own Broodmother
    {A, 559, 5450}, -- Fungal Frenzy
    {A, 559, 5449}, -- Rock Lover
    {A, 559, 5446}, -- The Glop Family Line
    {A, 559, 5445}, -- Fungalophobia
    {A, 559, 4871}, -- Deep into Deepholm
    {C, 553, 559},
    {N, 559, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 550, 553},
    {N, 553, a.GetMapName(207)}, -- Deepholm
    {A, 571, 4882}, -- The Guardians of Hyjal
    {C, 552, 571},
    {N, 571, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 565, 4863}, -- Explore Hyjal
    {C, 552, 565},
    {N, 565, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 558, 5879}, -- Veteran of the Molten Front
    {A, 558, 5869}, -- Infernal Ambassadors
    {A, 558, 5865}, -- Have... Have We Met?
    {A, 558, 5864}, -- Gang War
    {A, 558, 5868}, -- And the Meek Shall Inherit Kalimdor
    {A, 558, 5862}, -- Ludicrous Speed
    {A, 558, 5870}, -- Fireside Chat
    {A, 558, 5861}, -- The Fiery Lords of Sethria's Roost
    {A, 558, 5866}, -- The Molten Front Offensive
    {A, 558, 5859}, -- Legacy of Leyara
    {A, 558, 5483}, -- Bounce
    {A, 558, 5860}, -- The 'Unbeatable?' Pterodactyl: BEATEN.
    {A, 558, 4959}, -- Beware of the 'Unbeatable?' Pterodactyl
    {A, 558, 4870}, -- Coming Down the Mountain
    {C, 552, 558},
    {N, 558, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 550, 552},
    {N, 552, a.GetMapName(198)}, -- Mount Hyjal
    {A, 564, 4975}, -- From Hell's Heart I Stab at Thee
    {A, 564, 4825}, -- Explore Vashj'ir
    {C, 551, 564},
    {N, 564, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 557, 5319}, -- "20,000 Leagues Under the Sea"
    {A, 557, 5318}, -- "20,000 Leagues Under the Sea"
    {A, 557, 5452}, -- Visions of Vashj'ir Past
    {A, 557, 4982}, -- Sinking into Vashj'ir
    {A, 557, 4869}, -- Sinking into Vashj'ir
    {C, 551, 557},
    {N, 557, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 550, 551},
    {N, 551, a.GetMapName(203)}, -- Vashj'ir
    {A, 550, 4881}, -- The Earthen Ring
    {A, 550, 4868}, -- Explore Cataclysm
    {A, 550, 5753}, -- Cataclysmically Delicious
    {A, 550, 5754}, -- Drown Your Sorrows
    {A, 550, 5548}, -- To All the Squirrels Who Cared for Me
    {A, 550, 4827}, -- Surveying the Damage
    {A, 550, 4983}, -- Loremaster of Cataclysm
    {A, 550, 4875}, -- Loremaster of Cataclysm
    {C, 129, 550},
    {N, 550, a.L["Zones"]}, -- Zones
    {A, 129, 5538}, -- "50,000 Valor Points"
    {A, 129, 5537}, -- "25,000 Valor Points"
    {A, 129, 5536}, -- 5000 Valor Points
    {A, 129, 5535}, -- 1000 Valor Points
    {A, 129, 4887}, -- Tripping the Rifts
    {C, 883, 129},
    {N, 129, a.GetCategoryInfoTitle(15072)}, -- Cataclysm
    {A, 781, 4596}, -- The Sword in the Skull
    {A, 781, 3677}, -- The Sunreavers
    {A, 781, 3676}, -- A Silver Confidant
    {A, 781, 2816}, -- Exalted Argent Champion of the Horde
    {A, 781, 2817}, -- Exalted Argent Champion of the Alliance
    {A, 781, 2771}, -- Exalted Champion of the Horde
    {A, 781, 2770}, -- Exalted Champion of the Alliance
    {A, 781, 2788}, -- Champion of the Horde
    {A, 781, 2782}, -- Champion of the Alliance
    {A, 781, 2765}, -- Exalted Champion of Orgrimmar
    {A, 781, 2764}, -- Exalted Champion of Stormwind
    {A, 781, 2783}, -- Champion of Orgrimmar
    {A, 781, 2781}, -- Champion of Stormwind
    {A, 781, 2766}, -- Exalted Champion of Sen'jin
    {A, 781, 2763}, -- Exalted Champion of Ironforge
    {A, 781, 2784}, -- Champion of Sen'jin
    {A, 781, 2780}, -- Champion of Ironforge
    {A, 781, 2768}, -- Exalted Champion of Thunder Bluff
    {A, 781, 2762}, -- Exalted Champion of Gnomeregan
    {A, 781, 2786}, -- Champion of Thunder Bluff
    {A, 781, 2779}, -- Champion of Gnomeregan
    {A, 781, 2767}, -- Exalted Champion of Silvermoon City
    {A, 781, 2761}, -- Exalted Champion of the Exodar
    {A, 781, 2785}, -- Champion of Silvermoon City
    {A, 781, 2778}, -- Champion of the Exodar
    {A, 781, 2769}, -- Exalted Champion of the Undercity
    {A, 781, 2760}, -- Exalted Champion of Darnassus
    {A, 781, 2787}, -- Champion of the Undercity
    {A, 781, 2777}, -- Champion of Darnassus
    {A, 781, 3736}, -- Pony Up!
    {A, 781, 2773}, -- It's Just a Flesh Wound
    {A, 781, 2836}, -- Lance a Lot
    {A, 781, 2772}, -- Tilted!
    {A, 781, 2758}, -- Argent Valor
    {A, 781, 2756}, -- Argent Aspiration
    {C, 83, 781},
    {N, 781, a.GetCategoryInfoTitle(14941)}, -- Argent Tournament
    {A, 1138, 1752}, -- Master of Wintergrasp
    {A, 1138, 1751}, -- Didn't Stand a Chance
    {A, 1138, 1727}, -- Leaning Tower
    {A, 1138, 1723}, -- Vehicular Gnomeslaughter
    {A, 1138, 2476}, -- Destruction Derby
    {A, 1138, 1737}, -- Destruction Derby
    {A, 1138, 2080}, -- Black War Mammoth
    {A, 1138, 2199}, -- Wintergrasp Ranger
    {A, 1138, 1755}, -- Within Our Grasp
    {A, 1138, 1718}, -- Wintergrasp Veteran
    {A, 1138, 1717}, -- Wintergrasp Victory
    {C, 83, 1138},
    {N, 1138, a.GetCategoryInfoTitle(14901)}, -- Wintergrasp
    {C, 83, 787},
    {N, 787, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {A, 1526, 137}, -- Stocking Up
    {C, 1152, 1526},
    {N, 1526, a.GetCategoryInfoTitle(15496), true}, -- Tailoring
    {C, 1152, 1506},
    {N, 1506, a.GetCategoryInfoTitle(15493), true}, -- Inscription
    {A, 1498, 2096}, -- The Coin Master
    {A, 1498, 1958}, -- I Smell A Giant Rat
    {A, 1498, 1957}, -- There's Gold In That There Fountain
    {A, 1498, 2095}, -- Silver in the City
    {A, 1498, 2094}, -- A Penny For Your Thoughts
    {A, 1498, 3217}, -- Chasing Marcia
    {A, 1498, 1517}, -- Northrend Angler
    {A, 1498, 130}, -- Grand Master Fisherman
    {C, 1152, 1498},
    {N, 1498, a.GetCategoryInfoTitle(171), true}, -- Fishing
    {A, 1479, 1783}, -- Our Daily Bread
    {A, 1479, 1782}, -- Our Daily Bread
    {A, 1479, 1781}, -- Critter Gitter
    {A, 1479, 1780}, -- Second That Emotion
    {A, 1479, 1779}, -- The Northrend Gourmet
    {A, 1479, 1778}, -- The Northrend Gourmet
    {A, 1479, 1777}, -- The Northrend Gourmet
    {A, 1479, 125}, -- Grand Master Cook
    {C, 1152, 1479},
    {N, 1479, a.GetCategoryInfoTitle(170), true}, -- Cooking
    {A, 1470, 4922}, -- Grand Master in Archaeology
    {C, 1152, 1470},
    {N, 1470, a.GetCategoryInfoTitle(15071), true}, -- Archaeology
    {A, 1152, 730}, -- Skills to Pay the Bills
    {A, 1152, 135}, -- Grand Master in First Aid
    {A, 1152, 735}, -- Working Day and Night
    {A, 1152, 734}, -- Professional Grand Master
    {C, 83, 1152},
    {N, 1152, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 128, 4816}, -- Heroic: The Twilight Destroyer (25 player)
    {A, 128, 4815}, -- The Twilight Destroyer (25 player)
    {C, 126, 128},
    {N, 128, (GetDifficultyInfo(4))}, -- The Ruby Sanctum 25
    {A, 127, 4818}, -- Heroic: The Twilight Destroyer (10 player)
    {A, 127, 4817}, -- The Twilight Destroyer (10 player)
    {C, 126, 127},
    {N, 127, (GetDifficultyInfo(3))}, -- The Ruby Sanctum 10
    {C, 85, 126},
    {N, 126, a.GetInstanceInfoName(761)}, -- The Ruby Sanctum
    {A, 615, 4598}, -- The Ashen Verdict
    {C, 123, 615},
    {N, 615, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 125, 4637}, -- Heroic: Fall of the Lich King (25 player)
    {A, 125, 4584}, -- The Light of Dawn
    {A, 125, 4635}, -- Heroic: The Frostwing Halls (25 player)
    {A, 125, 4634}, -- Heroic: The Crimson Hall (25 player)
    {A, 125, 4633}, -- Heroic: The Plagueworks (25 player)
    {A, 125, 4632}, -- Heroic: Storming the Citadel (25 player)
    {A, 125, 4608}, -- Fall of the Lich King (25 player)
    {A, 125, 4597}, -- The Frozen Throne (25 player)
    {A, 125, 4607}, -- The Frostwing Halls (25 player)
    {A, 125, 4606}, -- The Crimson Hall (25 player)
    {A, 125, 4605}, -- The Plagueworks (25 player)
    {A, 125, 4604}, -- Storming the Citadel (25 player)
    {A, 125, 4622}, -- Neck-Deep in Vile (25 player)
    {A, 125, 4621}, -- Been Waiting a Long Time for This (25 player)
    {A, 125, 4620}, -- All You Can Eat (25 player)
    {A, 125, 4619}, -- Portal Jockey (25 player)
    {A, 125, 4618}, -- "Once Bitten, Twice Shy (25 player)"
    {A, 125, 4617}, -- The Orb Whisperer (25 player)
    {A, 125, 4616}, -- "Nausea, Heartburn, Indigestion... (25 player)"
    {A, 125, 4614}, -- Dances with Oozes (25 player)
    {A, 125, 4615}, -- Flu Shot Shortage (25 player)
    {A, 125, 4613}, -- I've Gone and Made a Mess (25 player)
    {A, 125, 4612}, -- I'm on a Boat (25 player)
    {A, 125, 4611}, -- Full House (25 player)
    {A, 125, 4610}, -- Boned (25 player)
    {C, 123, 125},
    {N, 125, (GetDifficultyInfo(4))}, -- Icecrown Citadel 25
    {A, 124, 4636}, -- Heroic: Fall of the Lich King (10 player)
    {A, 124, 4583}, -- Bane of the Fallen King
    {A, 124, 4631}, -- Heroic: The Frostwing Halls (10 player)
    {A, 124, 4630}, -- Heroic: The Crimson Hall (10 player)
    {A, 124, 4629}, -- Heroic: The Plagueworks (10 player)
    {A, 124, 4628}, -- Heroic: Storming the Citadel (10 player)
    {A, 124, 4532}, -- Fall of the Lich King (10 player)
    {A, 124, 4530}, -- The Frozen Throne (10 player)
    {A, 124, 4527}, -- The Frostwing Halls (10 player)
    {A, 124, 4529}, -- The Crimson Hall (10 player)
    {A, 124, 4528}, -- The Plagueworks (10 player)
    {A, 124, 4531}, -- Storming the Citadel (10 player)
    {A, 124, 4581}, -- Neck-Deep in Vile (10 player)
    {A, 124, 4601}, -- Been Waiting a Long Time for This (10 player)
    {A, 124, 4580}, -- All You Can Eat (10 player)
    {A, 124, 4579}, -- Portal Jockey (10 player)
    {A, 124, 4539}, -- "Once Bitten, Twice Shy (10 player)"
    {A, 124, 4582}, -- The Orb Whisperer (10 player)
    {A, 124, 4578}, -- "Nausea, Heartburn, Indigestion... (10 player)"
    {A, 124, 4538}, -- Dances with Oozes (10 player)
    {A, 124, 4577}, -- Flu Shot Shortage (10 player)
    {A, 124, 4537}, -- I've Gone and Made a Mess (10 player)
    {A, 124, 4536}, -- I'm on a Boat (10 player)
    {A, 124, 4535}, -- Full House (10 player)
    {A, 124, 4534}, -- Boned (10 player)
    {C, 123, 124},
    {N, 124, (GetDifficultyInfo(3))}, -- Icecrown Citadel 10
    {A, 123, 4623}, -- Shadowmourne
    {A, 123, 4625}, -- Invincible's Reins
    {C, 85, 123},
    {N, 123, a.GetInstanceInfoName(758)}, -- Icecrown Citadel
    {A, 122, 4397}, -- Onyxia's Lair (25 player)
    {A, 122, 4407}, -- She Deep Breaths More (25 player)
    {A, 122, 4406}, -- Many Whelps! Handle It! (25 player)
    {A, 122, 4405}, -- More Dots! (25 player)
    {C, 120, 122},
    {N, 122, (GetDifficultyInfo(4))}, -- Onyxia's Lair 25
    {A, 121, 4396}, -- Onyxia's Lair (10 player)
    {A, 121, 4404}, -- She Deep Breaths More (10 player)
    {A, 121, 4403}, -- Many Whelps! Handle It! (10 player)
    {A, 121, 4402}, -- More Dots! (10 player)
    {C, 120, 121},
    {N, 121, (GetDifficultyInfo(3))}, -- Onyxia's Lair 10
    {C, 85, 120},
    {N, 120, a.GetInstanceInfoName(760)}, -- Onyxia's Lair
    {A, 119, 4079}, -- A Tribute to Immortality
    {A, 119, 4156}, -- A Tribute to Immortality
    {A, 119, 3819}, -- A Tribute to Insanity (25 player)
    {A, 119, 3818}, -- A Tribute to Mad Skill (25 player)
    {A, 119, 3817}, -- A Tribute to Skill (25 player)
    {A, 119, 3812}, -- Call of the Grand Crusade (25 player)
    {A, 119, 3916}, -- Call of the Crusade (25 player)
    {A, 119, 3816}, -- The Traitor King (25 player)
    {A, 119, 3815}, -- Salt and Pepper (25 player)
    {A, 119, 3997}, -- Three Sixty Pain Spike (25 player)
    {A, 119, 3937}, -- "Not One, But Two Jormungars (25 player)"
    {A, 119, 3813}, -- Upper Back Pain (25 player)
    {C, 117, 119},
    {N, 119, (GetDifficultyInfo(4))}, -- Trial of the Crusader 25
    {A, 118, 4080}, -- A Tribute to Dedicated Insanity
    {A, 118, 3810}, -- A Tribute to Insanity (10 player)
    {A, 118, 3809}, -- A Tribute to Mad Skill (10 player)
    {A, 118, 3808}, -- A Tribute to Skill (10 player)
    {A, 118, 3918}, -- Call of the Grand Crusade (10 player)
    {A, 118, 3917}, -- Call of the Crusade (10 player)
    {A, 118, 3800}, -- The Traitor King (10 player)
    {A, 118, 3799}, -- Salt and Pepper (10 player)
    {A, 118, 3798}, -- Resilience Will Fix It (10 player)
    {A, 118, 3996}, -- Three Sixty Pain Spike (10 player)
    {A, 118, 3936}, -- "Not One, But Two Jormungars (10 player)"
    {A, 118, 3797}, -- Upper Back Pain (10 player)
    {C, 117, 118},
    {N, 118, (GetDifficultyInfo(3))}, -- Trial of the Crusader 10
    {C, 85, 117},
    {N, 117, a.GetInstanceInfoName(757)}, -- Trial of the Crusader
    {A, 116, 2904}, -- Conqueror of Ulduar
    {A, 116, 3005}, -- He Feeds On Your Tears (25 player)
    {A, 116, 3037}, -- Observed (25 player)
    {A, 116, 2895}, -- The Secrets of Ulduar (25 player)
    {A, 116, 2893}, -- The Descent into Madness (25 player)
    {A, 116, 2891}, -- The Keepers of Ulduar (25 player)
    {A, 116, 2889}, -- The Antechamber of Ulduar (25 player)
    {A, 116, 2887}, -- The Siege of Ulduar (25 player)
    {A, 116, 3002}, -- Supermassive (25 player)
    {A, 116, 3164}, -- Alone in the Darkness (25 player)
    {A, 116, 3163}, -- One Light in the Darkness (25 player)
    {A, 116, 3162}, -- Two Lights in the Darkness (25 player)
    {A, 116, 3161}, -- Three Lights in the Darkness (25 player)
    {A, 116, 3016}, -- In His House He Waits Dreaming (25 player)
    {A, 116, 3017}, -- They're Coming Out of the Walls (25 player)
    {A, 116, 3013}, -- He's Not Getting Any Older (25 player)
    {A, 116, 3010}, -- Drive Me Crazy (25 player)
    {A, 116, 3011}, -- Kiss and Make Up (25 player)
    {A, 116, 3188}, -- I Love the Smell of Saronite in the Morning (25 player)
    {A, 116, 2997}, -- Shadowdodger (25 player)
    {A, 116, 3189}, -- Firefighter (25 player)
    {A, 116, 2995}, -- Not-So-Friendly Fire (25 player)
    {A, 116, 3237}, -- Set Up Us the Bomb (25 player)
    {A, 116, 3187}, -- "Knock, Knock, Knock on Wood (25 player)"
    {A, 116, 3186}, -- "Knock, Knock on Wood (25 player)"
    {A, 116, 3185}, -- Knock on Wood (25 player)
    {A, 116, 2983}, -- Getting Back to Nature (25 player)
    {A, 116, 2984}, -- Deforestation (25 player)
    {A, 116, 2981}, -- Con-speed-atory (25 player)
    {A, 116, 3118}, -- Lumberjacked (25 player)
    {A, 116, 3183}, -- Lose Your Illusion (25 player)
    {A, 116, 2978}, -- Siffed (25 player)
    {A, 116, 2976}, -- Who Needs Bloodlust? (25 player)
    {A, 116, 2974}, -- I'll Take You All On (25 player)
    {A, 116, 2972}, -- Don't Stand in the Lightning (25 player)
    {A, 116, 3184}, -- I Could Say That This Cache Was Rare (25 player)
    {A, 116, 2970}, -- Staying Buffed All Winter (25 player)
    {A, 116, 2968}, -- Getting Cold in Here (25 player)
    {A, 116, 2965}, -- I Have the Coolest Friends (25 player)
    {A, 116, 2962}, -- Cheese the Freeze (25 player)
    {A, 116, 3007}, -- Crazy Cat Lady (25 player)
    {A, 116, 3077}, -- Nine Lives (25 player)
    {A, 116, 2954}, -- Disarmed (25 player)
    {A, 116, 2952}, -- With Open Arms (25 player)
    {A, 116, 2960}, -- Rubble and Roll (25 player)
    {A, 116, 2956}, -- If Looks Could Kill (25 player)
    {A, 116, 2944}, -- "I Choose You, Steelbreaker (25 player)"
    {A, 116, 2943}, -- "I Choose You, Stormcaller Brundir (25 player)"
    {A, 116, 2942}, -- "I Choose You, Runemaster Molgeim (25 player)"
    {A, 116, 2948}, -- Can't Do That While Stunned (25 player)
    {A, 116, 2946}, -- But I'm On Your Side (25 player)
    {A, 116, 3059}, -- Heartbreaker (25 player)
    {A, 116, 2938}, -- Must Deconstruct Faster (25 player)
    {A, 116, 2936}, -- Nerf Gravity Bombs (25 player)
    {A, 116, 2935}, -- Nerf Scrapbots (25 player)
    {A, 116, 2932}, -- Nerf Engineering (25 player)
    {A, 116, 2924}, -- "Iron Dwarf, Medium Rare (25 player)"
    {A, 116, 2921}, -- A Quick Shave (25 player)
    {A, 116, 2929}, -- Stokin' the Furnace (25 player)
    {A, 116, 2928}, -- Hot Pocket (25 player)
    {A, 116, 2926}, -- Shattered (25 player)
    {A, 116, 3057}, -- Orbit-uary (25 player)
    {A, 116, 2917}, -- Nuked from Orbit (25 player)
    {A, 116, 2916}, -- Orbital Devastation (25 player)
    {A, 116, 2918}, -- Orbital Bombardment (25 player)
    {A, 116, 2910}, -- Take Out Those Turrets (25 player)
    {A, 116, 2912}, -- Shutout (25 player)
    {A, 116, 2906}, -- Unbroken (25 player)
    {A, 116, 2908}, -- Three Car Garage (25 player)
    {A, 116, 3098}, -- Dwarfageddon (25 player)
    {C, 114, 116},
    {N, 116, (GetDifficultyInfo(4))}, -- Ulduar 25
    {A, 115, 2903}, -- Champion of Ulduar
    {A, 115, 3004}, -- He Feeds On Your Tears (10 player)
    {A, 115, 3036}, -- Observed (10 player)
    {A, 115, 2894}, -- The Secrets of Ulduar (10 player)
    {A, 115, 2892}, -- The Descent into Madness (10 player)
    {A, 115, 2890}, -- The Keepers of Ulduar (10 player)
    {A, 115, 2888}, -- The Antechamber of Ulduar (10 player)
    {A, 115, 2886}, -- The Siege of Ulduar (10 player)
    {A, 115, 3003}, -- Supermassive (10 player)
    {A, 115, 3159}, -- Alone in the Darkness (10 player)
    {A, 115, 3158}, -- One Light in the Darkness (10 player)
    {A, 115, 3141}, -- Two Lights in the Darkness (10 player)
    {A, 115, 3157}, -- Three Lights in the Darkness (10 player)
    {A, 115, 3015}, -- In His House He Waits Dreaming (10 player)
    {A, 115, 3014}, -- They're Coming Out of the Walls (10 player)
    {A, 115, 3012}, -- He's Not Getting Any Older (10 player)
    {A, 115, 3008}, -- Drive Me Crazy (10 player)
    {A, 115, 3009}, -- Kiss and Make Up (10 player)
    {A, 115, 3181}, -- I Love the Smell of Saronite in the Morning (10 player)
    {A, 115, 2996}, -- Shadowdodger (10 player)
    {A, 115, 3180}, -- Firefighter (10 player)
    {A, 115, 3138}, -- Not-So-Friendly Fire (10 player)
    {A, 115, 2989}, -- Set Up Us the Bomb (10 player)
    {A, 115, 3179}, -- "Knock, Knock, Knock on Wood (10 player)"
    {A, 115, 3178}, -- "Knock, Knock on Wood (10 player)"
    {A, 115, 3177}, -- Knock on Wood (10 player)
    {A, 115, 2982}, -- Getting Back to Nature (10 player)
    {A, 115, 2985}, -- Deforestation (10 player)
    {A, 115, 2980}, -- Con-speed-atory (10 player)
    {A, 115, 2979}, -- Lumberjacked (10 player)
    {A, 115, 3176}, -- Lose Your Illusion (10 player)
    {A, 115, 2977}, -- Siffed (10 player)
    {A, 115, 2975}, -- Who Needs Bloodlust? (10 player)
    {A, 115, 2973}, -- I'll Take You All On (10 player)
    {A, 115, 2971}, -- Don't Stand in the Lightning (10 player)
    {A, 115, 3182}, -- I Could Say That This Cache Was Rare (10 player)
    {A, 115, 2969}, -- Staying Buffed All Winter (10 player)
    {A, 115, 2967}, -- Getting Cold in Here (10 player)
    {A, 115, 2963}, -- I Have the Coolest Friends (10 player)
    {A, 115, 2961}, -- Cheese the Freeze (10 player)
    {A, 115, 3006}, -- Crazy Cat Lady (10 player)
    {A, 115, 3076}, -- Nine Lives (10 player)
    {A, 115, 2953}, -- Disarmed (10 player)
    {A, 115, 2951}, -- With Open Arms (10 player)
    {A, 115, 2959}, -- Rubble and Roll (10 player)
    {A, 115, 2955}, -- If Looks Could Kill (10 player)
    {A, 115, 2941}, -- "I Choose You, Steelbreaker (10 player)"
    {A, 115, 2940}, -- "I Choose You, Stormcaller Brundir (10 player)"
    {A, 115, 2939}, -- "I Choose You, Runemaster Molgeim (10 player)"
    {A, 115, 2947}, -- Can't Do That While Stunned (10 player)
    {A, 115, 2945}, -- But I'm On Your Side (10 player)
    {A, 115, 3058}, -- Heartbreaker (10 player)
    {A, 115, 2937}, -- Must Deconstruct Faster (10 player)
    {A, 115, 2934}, -- Nerf Gravity Bombs (10 player)
    {A, 115, 2933}, -- Nerf Scrapbots (10 player)
    {A, 115, 2931}, -- Nerf Engineering (10 player)
    {A, 115, 2923}, -- "Iron Dwarf, Medium Rare (10 player)"
    {A, 115, 2919}, -- A Quick Shave (10 player)
    {A, 115, 2930}, -- Stokin' the Furnace (10 player)
    {A, 115, 2927}, -- Hot Pocket (10 player)
    {A, 115, 2925}, -- Shattered (10 player)
    {A, 115, 3056}, -- Orbit-uary (10 player)
    {A, 115, 2915}, -- Nuked from Orbit (10 player)
    {A, 115, 2914}, -- Orbital Devastation (10 player)
    {A, 115, 2913}, -- Orbital Bombardment (10 player)
    {A, 115, 2909}, -- Take Out Those Turrets (10 player)
    {A, 115, 2911}, -- Shutout (10 player)
    {A, 115, 2905}, -- Unbroken (10 player)
    {A, 115, 2907}, -- Three Car Garage (10 player)
    {A, 115, 3097}, -- Dwarfageddon (10 player)
    {C, 114, 115},
    {N, 115, (GetDifficultyInfo(3))}, -- Ulduar 10
    {A, 114, 17341}, -- Cutting Edge: Ulduar
    {A, 114, 17340}, -- Ahead of the Curve: Yogg-Saron
    {A, 114, 3316}, -- Herald of the Titans
    {A, 114, 3142}, -- "Val'anyr, Hammer of Ancient Kings"
    {A, 114, 4626}, -- And I'll Form the Head!
    {C, 85, 114},
    {N, 114, a.GetInstanceInfoName(759)}, -- Ulduar
    {A, 113, 623}, -- The Spellweaver's Downfall (25 player)
    {A, 113, 1870}, -- A Poke in the Eye (25 player)
    {A, 113, 1875}, -- You Don't Have an Eternity (25 player)
    {A, 113, 2149}, -- Denyin' the Scion (25 player)
    {C, 111, 113},
    {N, 113, (GetDifficultyInfo(4))}, -- The Eye of Eternity 25
    {A, 112, 622}, -- The Spellweaver's Downfall (10 player)
    {A, 112, 1869}, -- A Poke in the Eye (10 player)
    {A, 112, 1874}, -- You Don't Have an Eternity (10 player)
    {A, 112, 2148}, -- Denyin' the Scion (10 player)
    {C, 111, 112},
    {N, 112, (GetDifficultyInfo(3))}, -- The Eye of Eternity 10
    {C, 85, 111},
    {N, 111, a.GetInstanceInfoName(756)}, -- The Eye of Eternity
    {A, 110, 625}, -- Besting the Black Dragonflight (25 player)
    {A, 110, 1877}, -- Less Is More (25 player)
    {A, 110, 2054}, -- The Twilight Zone (25 player)
    {A, 110, 2053}, -- Twilight Duo (25 player)
    {A, 110, 2052}, -- Twilight Assist (25 player)
    {A, 110, 2048}, -- Gonna Go When the Volcano Blows (25 player)
    {C, 108, 110},
    {N, 110, (GetDifficultyInfo(4))}, -- The Obsidian Sanctum 25
    {A, 109, 1876}, -- Besting the Black Dragonflight (10 player)
    {A, 109, 624}, -- Less Is More (10 player)
    {A, 109, 2051}, -- The Twilight Zone (10 player)
    {A, 109, 2050}, -- Twilight Duo (10 player)
    {A, 109, 2049}, -- Twilight Assist (10 player)
    {A, 109, 2047}, -- Gonna Go When the Volcano Blows (10 player)
    {C, 108, 109},
    {N, 109, (GetDifficultyInfo(3))}, -- The Obsidian Sanctum 10
    {C, 85, 108},
    {N, 108, a.GetInstanceInfoName(755)}, -- The Obsidian Sanctum
    {A, 107, 2186}, -- The Immortal
    {A, 107, 577}, -- The Fall of Naxxramas (25 player)
    {A, 107, 575}, -- Kel'Thuzad's Defeat (25 player)
    {A, 107, 573}, -- Sapphiron's Demise (25 player)
    {A, 107, 569}, -- The Military Quarter (25 player)
    {A, 107, 567}, -- The Plague Quarter (25 player)
    {A, 107, 565}, -- The Construct Quarter (25 player)
    {A, 107, 563}, -- The Arachnid Quarter (25 player)
    {A, 107, 579}, -- The Dedicated Few (25 player)
    {A, 107, 2185}, -- Just Can't Get Enough (25 player)
    {A, 107, 2147}, -- The Hundred Club (25 player)
    {A, 107, 2177}, -- And They Would All Go Down Together (25 player)
    {A, 107, 2183}, -- Spore Loser (25 player)
    {A, 107, 2139}, -- The Safety Dance (25 player)
    {A, 107, 2181}, -- Subtraction (25 player)
    {A, 107, 2179}, -- Shocking! (25 player)
    {A, 107, 1857}, -- Make Quick Werk of Him (25 player)
    {A, 107, 1859}, -- Arachnophobia (25 player)
    {A, 107, 2140}, -- Momma Said Knock You Out (25 player)
    {C, 105, 107},
    {N, 107, (GetDifficultyInfo(4))}, -- Naxxramas 25
    {A, 106, 2187}, -- The Undying
    {A, 106, 576}, -- The Fall of Naxxramas (10 player)
    {A, 106, 574}, -- Kel'Thuzad's Defeat (10 player)
    {A, 106, 572}, -- Sapphiron's Demise (10 player)
    {A, 106, 568}, -- The Military Quarter (10 player)
    {A, 106, 566}, -- The Plague Quarter (10 player)
    {A, 106, 564}, -- The Construct Quarter (10 player)
    {A, 106, 562}, -- The Arachnid Quarter (10 player)
    {A, 106, 578}, -- The Dedicated Few (10 player)
    {A, 106, 2184}, -- Just Can't Get Enough (10 player)
    {A, 106, 2146}, -- The Hundred Club (10 player)
    {A, 106, 2176}, -- And They Would All Go Down Together (10 player)
    {A, 106, 2182}, -- Spore Loser (10 player)
    {A, 106, 1996}, -- The Safety Dance (10 player)
    {A, 106, 2180}, -- Subtraction (10 player)
    {A, 106, 2178}, -- Shocking! (10 player)
    {A, 106, 1856}, -- Make Quick Werk of Him (10 player)
    {A, 106, 1858}, -- Arachnophobia (10 player)
    {A, 106, 1997}, -- Momma Said Knock You Out (10 player)
    {C, 105, 106},
    {N, 106, (GetDifficultyInfo(3))}, -- Naxxramas 10
    {C, 85, 105},
    {N, 105, a.GetInstanceInfoName(754)}, -- Naxxramas
    {A, 104, 4586}, -- Toravon the Ice Watcher (25 player)
    {A, 104, 3837}, -- Koralon the Flame Watcher (25 player)
    {A, 104, 3137}, -- Emalon the Storm Watcher (25 player)
    {A, 104, 1721}, -- Archavon the Stone Watcher (25 player)
    {A, 104, 4017}, -- "Earth, Wind & Fire (25 player)"
    {C, 102, 104},
    {N, 104, (GetDifficultyInfo(4))}, -- Vault of Archavon 25
    {A, 103, 4585}, -- Toravon the Ice Watcher (10 player)
    {A, 103, 3836}, -- Koralon the Flame Watcher (10 player)
    {A, 103, 3136}, -- Emalon the Storm Watcher (10 player)
    {A, 103, 1722}, -- Archavon the Stone Watcher (10 player)
    {A, 103, 4016}, -- "Earth, Wind & Fire (10 player)"
    {C, 102, 103},
    {N, 103, (GetDifficultyInfo(3))}, -- Vault of Archavon 10
    {A, 102, 2081}, -- Grand Black War Mammoth
    {C, 85, 102},
    {N, 102, a.GetInstanceInfoName(753)}, -- Vault of Archavon
    {A, 85, 4316}, -- 2500 Dungeon & Raid Emblems
    {A, 85, 3844}, -- 1000 Dungeon & Raid Emblems
    {A, 85, 2958}, -- Glory of the Ulduar Raider (25 player)
    {A, 85, 2957}, -- Glory of the Ulduar Raider (10 player)
    {A, 85, 4603}, -- Glory of the Icecrown Raider (25 player)
    {A, 85, 4602}, -- Glory of the Icecrown Raider (10 player)
    {A, 85, 2138}, -- Glory of the Raider (25 player)
    {A, 85, 2137}, -- Glory of the Raider (10 player)
    {A, 85, 1658}, -- Champion of the Frozen Wastes
    {C, 83, 85},
    {N, 85, a.GetCategoryInfoTitle(15271)}, -- Raids
    {A, 101, 4521}, -- Heroic: The Halls of Reflection
    {A, 101, 4518}, -- The Halls of Reflection
    {A, 101, 4526}, -- We're Not Retreating; We're Advancing in a Different Direction.
    {C, 84, 101},
    {N, 101, a.GetInstanceInfoName(276)}, -- Halls of Reflection
    {A, 100, 4520}, -- Heroic: The Pit of Saron
    {A, 100, 4517}, -- The Pit of Saron
    {A, 100, 4525}, -- Don't Look Up
    {A, 100, 4524}, -- Doesn't Go to Eleven
    {C, 84, 100},
    {N, 100, a.GetInstanceInfoName(278)}, -- Pit of Saron
    {A, 99, 4519}, -- Heroic: The Forge of Souls
    {A, 99, 4516}, -- The Forge of Souls
    {A, 99, 4523}, -- Three Faced
    {A, 99, 4522}, -- Soul Power
    {C, 84, 99},
    {N, 99, a.GetInstanceInfoName(280)}, -- The Forge of Souls
    {A, 98, 19425}, -- Defense Protocol Gamma: Trial of the Champion
    {A, 98, 19426}, -- Defense Protocol Gamma: Trial of the Champion
    {A, 98, 18678}, -- Defense Protocol Beta: Trial of the Champion
    {A, 98, 18677}, -- Defense Protocol Beta: Trial of the Champion
    {A, 98, 4297}, -- Heroic: Trial of the Champion
    {A, 98, 4298}, -- Heroic: Trial of the Champion
    {A, 98, 3778}, -- Trial of the Champion
    {A, 98, 4296}, -- Trial of the Champion
    {A, 98, 3804}, -- I've Had Worse
    {A, 98, 3802}, -- Argent Confessor
    {A, 98, 3803}, -- The Faceroller
    {C, 84, 98},
    {N, 98, a.GetInstanceInfoName(284)}, -- Trial of the Champion
    {A, 96, 19438}, -- Defense Protocol Gamma: The Culling of Stratholme
    {A, 96, 18601}, -- Defense Protocol Beta: The Culling of Stratholme
    {A, 96, 17302}, -- Defense Protocol Alpha: The Culling of Stratholme
    {A, 96, 500}, -- Heroic: The Culling of Stratholme
    {A, 96, 479}, -- The Culling of Stratholme
    {A, 96, 1817}, -- The Culling of Time
    {A, 96, 1872}, -- Zombiefest!
    {C, 84, 96},
    {N, 96, a.GetInstanceInfoName(279)}, -- The Culling of Stratholme
    {A, 97, 19437}, -- Defense Protocol Gamma: Utgarde Pinnacle
    {A, 97, 18600}, -- Defense Protocol Beta: Utgarde Pinnacle
    {A, 97, 17301}, -- Defense Protocol Alpha: Utgarde Pinnacle
    {A, 97, 499}, -- Heroic: Utgarde Pinnacle
    {A, 97, 488}, -- Utgarde Pinnacle
    {A, 97, 2157}, -- King's Bane
    {A, 97, 2156}, -- My Girl Loves to Skadi All the Time
    {A, 97, 1873}, -- Lodi Dodi We Loves the Skadi
    {A, 97, 2043}, -- The Incredible Hulk
    {C, 84, 97},
    {N, 97, a.GetInstanceInfoName(286)}, -- Utgarde Pinnacle
    {A, 95, 19436}, -- Defense Protocol Gamma: The Oculus
    {A, 95, 18599}, -- Defense Protocol Beta: The Oculus
    {A, 95, 17300}, -- Defense Protocol Alpha: The Oculus
    {A, 95, 498}, -- Heroic: The Oculus
    {A, 95, 487}, -- The Oculus
    {A, 95, 1871}, -- Experienced Drake Rider
    {A, 95, 2044}, -- Ruby Void
    {A, 95, 2045}, -- Emerald Void
    {A, 95, 2046}, -- Amber Void
    {A, 95, 1868}, -- Make It Count
    {C, 84, 95},
    {N, 95, a.GetInstanceInfoName(282)}, -- The Oculus
    {A, 94, 19435}, -- Defense Protocol Gamma: Halls of Lightning
    {A, 94, 18598}, -- Defense Protocol Beta: Halls of Lightning
    {A, 94, 17299}, -- Defense Protocol Alpha: Halls of Lightning
    {A, 94, 497}, -- Heroic: Halls of Lightning
    {A, 94, 486}, -- Halls of Lightning
    {A, 94, 1867}, -- Timely Death
    {A, 94, 2042}, -- Shatter Resistant
    {A, 94, 1834}, -- Lightning Struck
    {C, 84, 94},
    {N, 94, a.GetInstanceInfoName(275)}, -- Halls of Lightning
    {A, 93, 19434}, -- Defense Protocol Gamma: Halls of Stone
    {A, 93, 18597}, -- Defense Protocol Beta: Halls of Stone
    {A, 93, 17297}, -- Defense Protocol Alpha: Halls of Stone
    {A, 93, 496}, -- Heroic: Halls of Stone
    {A, 93, 485}, -- Halls of Stone
    {A, 93, 2155}, -- Abuse the Ooze
    {A, 93, 2154}, -- Brann Spankin' New
    {A, 93, 1866}, -- Good Grief
    {C, 84, 93},
    {N, 93, a.GetInstanceInfoName(277)}, -- Halls of Stone
    {A, 92, 19433}, -- Defense Protocol Gamma: Gundrak
    {A, 92, 18596}, -- Defense Protocol Beta: Gundrak
    {A, 92, 17295}, -- Defense Protocol Alpha: Gundrak
    {A, 92, 495}, -- Heroic: Gundrak
    {A, 92, 484}, -- Gundrak
    {A, 92, 2152}, -- Share The Love
    {A, 92, 1864}, -- What the Eck?
    {A, 92, 2040}, -- Less-rabi
    {A, 92, 2058}, -- Snakes. Why'd It Have To Be Snakes?
    {C, 84, 92},
    {N, 92, a.GetInstanceInfoName(274)}, -- Gundrak
    {A, 91, 19432}, -- Defense Protocol Gamma: The Violet Hold
    {A, 91, 18595}, -- Defense Protocol Beta: The Violet Hold
    {A, 91, 17293}, -- Defense Protocol Alpha: The Violet Hold
    {A, 91, 494}, -- Heroic: The Violet Hold
    {A, 91, 483}, -- The Violet Hold
    {A, 91, 1816}, -- Defenseless
    {A, 91, 2153}, -- A Void Dance
    {A, 91, 2041}, -- Dehydration
    {A, 91, 1865}, -- Lockdown!
    {C, 84, 91},
    {N, 91, a.GetInstanceInfoName(283)}, -- The Violet Hold
    {A, 90, 19431}, -- Defense Protocol Gamma: Drak'Tharon Keep
    {A, 90, 18594}, -- Defense Protocol Beta: Drak'Tharon Keep
    {A, 90, 17292}, -- Defense Protocol Alpha: Drak'Tharon Keep
    {A, 90, 493}, -- Heroic: Drak'Tharon Keep
    {A, 90, 482}, -- Drak'Tharon Keep
    {A, 90, 2039}, -- Better Off Dred
    {A, 90, 2057}, -- Oh Novos!
    {A, 90, 2151}, -- Consumption Junction
    {C, 84, 90},
    {N, 90, a.GetInstanceInfoName(273)}, -- Drak'Tharon Keep
    {A, 89, 19430}, -- Defense Protocol Gamma: Ahn'kahet: The Old Kingdom
    {A, 89, 18593}, -- Defense Protocol Beta: Ahn'kahet: The Old Kingdom
    {A, 89, 17291}, -- Defense Protocol Alpha: Ahn'kahet: The Old Kingdom
    {A, 89, 492}, -- Heroic: Ahn'kahet: The Old Kingdom
    {A, 89, 481}, -- Ahn'kahet: The Old Kingdom
    {A, 89, 1862}, -- Volazj's Quick Demise
    {A, 89, 2056}, -- Volunteer Work
    {A, 89, 2038}, -- Respect Your Elders
    {C, 84, 89},
    {N, 89, a.GetInstanceInfoName(271)}, -- Ahn'kahet: The Old Kingdom
    {A, 88, 19429}, -- Defense Protocol Gamma: Azjol-Nerub
    {A, 88, 18592}, -- Defense Protocol Beta: Azjol-Nerub
    {A, 88, 17285}, -- Defense Protocol Alpha: Azjol-Nerub
    {A, 88, 491}, -- Heroic: Azjol-Nerub
    {A, 88, 480}, -- Azjol-Nerub
    {A, 88, 1860}, -- Gotta Go!
    {A, 88, 1297}, -- Hadronox Denied
    {A, 88, 1296}, -- Watch Him Die
    {C, 84, 88},
    {N, 88, a.GetInstanceInfoName(272)}, -- Azjol-Nerub
    {A, 87, 19428}, -- Defense Protocol Gamma: The Nexus
    {A, 87, 18591}, -- Defense Protocol Beta: The Nexus
    {A, 87, 17283}, -- Defense Protocol Alpha: The Nexus
    {A, 87, 490}, -- Heroic: The Nexus
    {A, 87, 478}, -- The Nexus
    {A, 87, 2036}, -- Intense Cold
    {A, 87, 2037}, -- Chaos Theory
    {A, 87, 2150}, -- Split Personality
    {C, 84, 87},
    {N, 87, a.GetInstanceInfoName(281)}, -- The Nexus
    {A, 86, 19427}, -- Defense Protocol Gamma: Utgarde Keep
    {A, 86, 18590}, -- Defense Protocol Beta: Utgarde Keep
    {A, 86, 17213}, -- Defense Protocol Alpha: Utgarde Keep
    {A, 86, 489}, -- Heroic: Utgarde Keep
    {A, 86, 477}, -- Utgarde Keep
    {A, 86, 1919}, -- On The Rocks
    {C, 84, 86},
    {N, 86, a.GetInstanceInfoName(285)}, -- Utgarde Keep
    {A, 84, 4316}, -- 2500 Dungeon & Raid Emblems
    {A, 84, 3844}, -- 1000 Dungeon & Raid Emblems
    {A, 84, 2089}, -- 1000 Stone Keeper's Shards
    {A, 84, 2088}, -- 500 Stone Keeper's Shards
    {A, 84, 2087}, -- 250 Stone Keeper's Shards
    {A, 84, 2086}, -- 100 Stone Keeper's Shards
    {A, 84, 2085}, -- 50 Stone Keeper's Shards
    {A, 84, 2019}, -- Proof of Demise
    {A, 84, 2018}, -- Timear Foresees
    {A, 84, 2136}, -- Glory of the Hero
    {A, 84, 1658}, -- Champion of the Frozen Wastes
    {A, 84, 19440}, -- Defense Protocol Gamma: Terminated
    {A, 84, 19439}, -- Defense Protocol Gamma: Terminated
    {A, 84, 18688}, -- Defense Protocol Beta: Terminated
    {A, 84, 18614}, -- Defense Protocol Beta: Terminated
    {A, 84, 17304}, -- Defense Protocol Alpha: Terminated
    {A, 84, 1289}, -- Northrend Dungeon Hero
    {A, 84, 1288}, -- Northrend Dungeonmaster
    {C, 83, 84},
    {N, 84, a.GetCategoryInfoTitle(15272)}, -- Dungeons
    {C, 577, 1034},
    {N, 1034, a.GetMapName(123)}, -- Wintergrasp
    {A, 609, 945}, -- The Argent Champion
    {A, 609, 947}, -- The Argent Crusade
    {C, 585, 609},
    {N, 609, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 608, 1270}, -- Explore Icecrown
    {C, 585, 608},
    {N, 608, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 607, 40}, -- Icecrown: The Final Goal
    {C, 585, 607},
    {N, 607, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 585},
    {N, 585, a.GetMapName(118)}, -- Icecrown
    {A, 606, 2083}, -- Grand Ice Mammoth
    {A, 606, 2082}, -- Ice Mammoth
    {C, 584, 606},
    {N, 606, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 612, 1269}, -- Explore Storm Peaks
    {C, 584, 612},
    {N, 612, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 604, 1428}, -- Mine Sweeper
    {A, 604, 38}, -- The Summit of Storm Peaks
    {C, 584, 604},
    {N, 604, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 584},
    {N, 584, a.GetMapName(120)}, -- Storm Peaks
    {A, 610, 1457}, -- Explore Crystalsong Forest
    {C, 577, 610},
    {N, 610, a.GetMapName(127)}, -- Crystalsong Forest
    {A, 603, 952}, -- Mercenary of Sholazar
    {A, 603, 951}, -- The Oracles
    {A, 603, 950}, -- Frenzyheart Tribe
    {C, 583, 603},
    {N, 603, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 602, 1268}, -- Explore Sholazar Basin
    {C, 583, 602},
    {N, 602, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 601, 941}, -- Hemet Nesingwary: The Collected Quests
    {A, 601, 938}, -- The Snows of Northrend
    {A, 601, 962}, -- Savior of the Oracles
    {A, 601, 961}, -- Honorary Frenzyheart
    {A, 601, 39}, -- Into the Basin
    {C, 583, 601},
    {N, 601, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 583},
    {N, 583, a.GetMapName(119)}, -- Sholazar Basin
    {A, 599, 1267}, -- Explore Zul'Drak
    {C, 582, 599},
    {N, 599, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 598, 4958}, -- The First Rule of Ring of Blood is You Don't Talk About Ring of Blood
    {A, 598, 1576}, -- Of Blood and Anguish
    {A, 598, 1596}, -- Guru of Drakuru
    {A, 598, 36}, -- The Empire of Zul'Drak
    {C, 582, 598},
    {N, 598, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 582},
    {N, 582, a.GetMapName(121)}, -- Zul'Drak
    {A, 782, 2017}, -- Grizzled Veteran
    {A, 782, 2016}, -- Grizzled Veteran
    {C, 581, 782},
    {N, 782, a.GetCategoryInfoTitle(95), true}, -- PvP
    {A, 596, 1266}, -- Explore Grizzly Hills
    {C, 581, 596},
    {N, 596, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 595, 1357}, -- Fo' Grizzle My Shizzle
    {A, 595, 37}, -- Fo' Grizzle My Shizzle
    {C, 581, 595},
    {N, 595, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 581},
    {N, 581, a.GetMapName(116)}, -- Grizzly Hills
    {A, 594, 1007}, -- The Wyrmrest Accord
    {C, 580, 594},
    {N, 594, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 593, 1265}, -- Explore Dragonblight
    {C, 580, 593},
    {N, 593, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 592, 1277}, -- Rapid Defense
    {A, 592, 547}, -- Veteran of the Wrathgate
    {A, 592, 1359}, -- Might of Dragonblight
    {A, 592, 35}, -- Might of Dragonblight
    {C, 580, 592},
    {N, 592, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 580},
    {N, 580, a.GetMapName(115)}, -- Dragonblight
    {A, 590, 1254}, -- Friend or Fowl?
    {A, 590, 1263}, -- Explore Howling Fjord
    {C, 579, 590},
    {N, 590, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 589, 1356}, -- I've Toured the Fjord
    {A, 589, 34}, -- I've Toured the Fjord
    {C, 579, 589},
    {N, 589, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 579},
    {N, 579, a.GetMapName(117)}, -- Howling Fjord
    {A, 588, 949}, -- Tuskarrmageddon
    {C, 578, 588},
    {N, 588, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 587, 1264}, -- Explore Borean Tundra
    {C, 578, 587},
    {N, 587, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 586, 561}, -- D.E.H.T.A's Little P.I.T.A.
    {A, 586, 1358}, -- Nothing Boring About Borean
    {A, 586, 33}, -- Nothing Boring About Borean
    {C, 578, 586},
    {N, 586, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 577, 578},
    {N, 578, a.GetMapName(114)}, -- Borean Tundra
    {A, 614, 2078}, -- Traveler's Tundra Mammoth
    {A, 614, 2077}, -- Wooly Mammoth
    {A, 614, 2076}, -- Armored Brown Bear
    {A, 614, 2084}, -- Ring of the Kirin Tor
    {A, 614, 1956}, -- Higher Learning
    {C, 577, 614},
    {N, 614, a.GetMapName(125)}, -- Dalaran
    {A, 577, 1682}, -- The Loremaster
    {A, 577, 1681}, -- The Loremaster
    {A, 577, 2556}, -- Pest Control
    {A, 577, 1012}, -- The Winds of the North
    {A, 577, 1011}, -- The Winds of the North
    {A, 577, 1010}, -- Northrend Vanguard
    {A, 577, 1009}, -- Knights of the Ebon Blade
    {A, 577, 1008}, -- The Kirin Tor
    {A, 577, 45}, -- Explore Northrend
    {A, 577, 2557}, -- To All The Squirrels Who Shared My Life
    {A, 577, 2257}, -- Frostbitten
    {A, 577, 2256}, -- Northern Exposure
    {A, 577, 1360}, -- Loremaster of Northrend
    {A, 577, 41}, -- Loremaster of Northrend
    {C, 83, 577},
    {N, 577, a.L["Zones"]}, -- Zones
    {C, 883, 83},
    {N, 83, a.GetCategoryInfoTitle(14866)}, -- Wrath of the Lich King
    {C, 55, 786},
    {N, 786, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {C, 1151, 1512},
    {N, 1512, a.GetCategoryInfoTitle(15495), true}, -- Leatherworking
    {A, 1499, 1225}, -- Outland Angler
    {A, 1499, 905}, -- Old Man Barlowned
    {A, 1499, 144}, -- The Lurker Above
    {A, 1499, 726}, -- Mr. Pinchy's Magical Crawdad Box
    {A, 1499, 129}, -- Master Fisherman
    {C, 1151, 1499},
    {N, 1499, a.GetCategoryInfoTitle(171), true}, -- Fishing
    {C, 1151, 1570},
    {N, 1570, a.GetCategoryInfoTitle(15492), true}, -- Engineering
    {A, 1478, 1801}, -- Captain Rumsey's Lager
    {A, 1478, 1800}, -- The Outland Gourmet
    {A, 1478, 906}, -- Kickin' It Up a Notch
    {A, 1478, 877}, -- The Cake Is Not A Lie
    {A, 1478, 124}, -- Master Cook
    {C, 1151, 1478},
    {N, 1478, a.GetCategoryInfoTitle(170), true}, -- Cooking
    {A, 1469, 5192}, -- The Harder they Fall
    {A, 1469, 4921}, -- Master in Archaeology
    {C, 1151, 1469},
    {N, 1469, a.GetCategoryInfoTitle(15071), true}, -- Archaeology
    {A, 1151, 134}, -- Master in First Aid
    {A, 1151, 1257}, -- The Scavenger
    {A, 1151, 733}, -- Professional Master
    {C, 55, 1151},
    {N, 1151, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 82, 725}, -- "Thori'dal, the Stars' Fury"
    {A, 82, 698}, -- Sunwell Plateau
    {C, 73, 82},
    {N, 82, a.GetInstanceInfoName(752)}, -- Sunwell Plateau
    {A, 81, 430}, -- Amani War Bear
    {A, 81, 691}, -- Zul'Aman
    {C, 73, 81},
    {N, 81, a.GetInstanceInfoName(77)}, -- Zul'Aman
    {A, 645, 958}, -- Sworn to the Deathsworn
    {C, 80, 645},
    {N, 645, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 80, 426}, -- Warglaives of Azzinoth
    {A, 80, 697}, -- The Black Temple
    {C, 73, 80},
    {N, 80, a.GetInstanceInfoName(751)}, -- Black Temple
    {A, 646, 959}, -- The Scale of the Sands
    {C, 79, 646},
    {N, 646, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 79, 695}, -- The Battle for Mount Hyjal
    {C, 73, 79},
    {N, 79, a.GetInstanceInfoName(750)}, -- The Battle for Mount Hyjal
    {A, 78, 885}, -- Ashes of Al'ar
    {A, 78, 696}, -- Tempest Keep
    {C, 73, 78},
    {N, 78, a.GetInstanceInfoName(749)}, -- The Eye
    {A, 77, 694}, -- Serpentshrine Cavern
    {C, 73, 77},
    {N, 77, a.GetInstanceInfoName(748)}, -- Serpentshrine Cavern
    {A, 76, 693}, -- Magtheridon's Lair
    {C, 73, 76},
    {N, 76, a.GetInstanceInfoName(747)}, -- Magtheridon's Lair
    {A, 75, 692}, -- Gruul's Lair
    {C, 73, 75},
    {N, 75, a.GetInstanceInfoName(746)}, -- Gruul's Lair
    {A, 647, 960}, -- The Violet Eye
    {C, 74, 647},
    {N, 647, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 74, 2456}, -- Vampire Hunter
    {A, 74, 882}, -- Fiery Warhorse's Reins
    {A, 74, 690}, -- Karazhan
    {C, 73, 74},
    {N, 74, a.GetInstanceInfoName(745)}, -- Karazhan
    {A, 73, 431}, -- Hand of A'dal
    {A, 73, 432}, -- Champion of the Naaru
    {A, 73, 1286}, -- Outland Raider
    {C, 55, 73},
    {N, 73, a.GetCategoryInfoTitle(15271)}, -- Raids
    {A, 72, 884}, -- Swift White Hawkstrider
    {A, 72, 682}, -- Heroic: Magister's Terrace
    {A, 72, 661}, -- Magister's Terrace
    {C, 56, 72},
    {N, 72, a.GetInstanceInfoName(249)}, -- Magisters Terrace
    {A, 71, 681}, -- Heroic: The Arcatraz
    {A, 71, 660}, -- The Arcatraz
    {C, 56, 71},
    {N, 71, a.GetInstanceInfoName(254)}, -- The Arcatraz
    {A, 70, 680}, -- Heroic: The Botanica
    {A, 70, 659}, -- The Botanica
    {C, 56, 70},
    {N, 70, a.GetInstanceInfoName(257)}, -- The Botanica
    {A, 69, 679}, -- Heroic: The Mechanar
    {A, 69, 658}, -- The Mechanar
    {C, 56, 69},
    {N, 69, a.GetInstanceInfoName(258)}, -- The Mechanar
    {A, 68, 676}, -- Heroic: Opening of the Dark Portal
    {A, 68, 655}, -- Opening of the Dark Portal
    {C, 56, 68},
    {N, 68, a.GetInstanceInfoName(255)}, -- The Black Morass
    {A, 67, 673}, -- Heroic: The Escape From Durnholde
    {A, 67, 652}, -- The Escape From Durnholde
    {C, 56, 67},
    {N, 67, a.GetInstanceInfoName(251)}, -- Old Hillsbrad Foothills
    {A, 66, 675}, -- Heroic: Shadow Labyrinth
    {A, 66, 654}, -- Shadow Labyrinth
    {C, 56, 66},
    {N, 66, a.GetInstanceInfoName(253)}, -- Shadow Labyrinth
    {A, 65, 883}, -- Reins of the Raven Lord
    {A, 65, 674}, -- Heroic: Sethekk Halls
    {A, 65, 653}, -- Sethekk Halls
    {C, 56, 65},
    {N, 65, a.GetInstanceInfoName(252)}, -- Sethekk Halls
    {A, 64, 672}, -- Heroic: Auchenai Crypts
    {A, 64, 666}, -- Auchenai Crypts
    {C, 56, 64},
    {N, 64, a.GetInstanceInfoName(247)}, -- Auchenai Crypts
    {A, 63, 671}, -- Heroic: Mana-Tombs
    {A, 63, 651}, -- Mana-Tombs
    {C, 56, 63},
    {N, 63, a.GetInstanceInfoName(250)}, -- Mana-Tombs
    {A, 62, 677}, -- Heroic: The Steamvault
    {A, 62, 656}, -- The Steamvault
    {C, 56, 62},
    {N, 62, a.GetInstanceInfoName(261)}, -- The Steamvault
    {A, 61, 670}, -- Heroic: Underbog
    {A, 61, 650}, -- Underbog
    {C, 56, 61},
    {N, 61, a.GetInstanceInfoName(262)}, -- The Underbog
    {A, 60, 669}, -- Heroic: The Slave Pens
    {A, 60, 649}, -- The Slave Pens
    {C, 56, 60},
    {N, 60, a.GetInstanceInfoName(260)}, -- The Slave Pens
    {A, 59, 678}, -- Heroic: The Shattered Halls
    {A, 59, 657}, -- The Shattered Halls
    {C, 56, 59},
    {N, 59, a.GetInstanceInfoName(259)}, -- The Shattered Halls
    {A, 58, 668}, -- Heroic: The Blood Furnace
    {A, 58, 648}, -- The Blood Furnace
    {C, 56, 58},
    {N, 58, a.GetInstanceInfoName(256)}, -- The Blood Furnace
    {A, 57, 667}, -- Heroic: Hellfire Ramparts
    {A, 57, 647}, -- Hellfire Ramparts
    {C, 56, 57},
    {N, 57, a.GetInstanceInfoName(248)}, -- Hellfire Ramparts
    {A, 56, 1287}, -- Outland Dungeon Hero
    {A, 56, 1284}, -- Outland Dungeonmaster
    {C, 55, 56},
    {N, 56, a.GetCategoryInfoTitle(15272)}, -- Dungeons
    {A, 751, 868}, -- Explore Isle of Quel'Danas
    {C, 750, 751},
    {N, 751, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 616, 750},
    {N, 750, a.GetMapName(1957)}, -- Isle of Quel'Danas
    {A, 638, 1638}, -- Skyshattered
    {A, 638, 898}, -- On Wings of Nether
    {C, 623, 638},
    {N, 638, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 637, 864}, -- Explore Shadowmoon Valley
    {C, 623, 637},
    {N, 637, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 630, 1195}, -- Shadow of the Betrayer
    {C, 623, 630},
    {N, 630, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 623},
    {N, 623, a.GetMapName(1948)}, -- Shadowmoon Valley
    {A, 636, 843}, -- Explore Netherstorm
    {C, 622, 636},
    {N, 636, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 629, 1194}, -- Into the Nether
    {C, 622, 629},
    {N, 629, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 622},
    {N, 622, a.GetMapName(1953)}, -- Netherstorm
    {A, 640, 896}, -- A Quest a Day Keeps the Ogres at Bay
    {C, 621, 640},
    {N, 640, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 635, 865}, -- Explore Blade's Edge Mountains
    {C, 621, 635},
    {N, 635, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 628, 1276}, -- Blade's Edge Bomberman
    {A, 628, 1193}, -- On the Blade's Edge
    {C, 621, 628},
    {N, 628, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 621},
    {N, 621, a.GetMapName(1949)}, -- Blade's Edge Mountains
    {A, 641, 943}, -- The Diplomat
    {A, 641, 942}, -- The Diplomat
    {A, 641, 901}, -- Mag'har of Draenor
    {A, 641, 899}, -- "Oh My, Kurenai"
    {C, 620, 641},
    {N, 641, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 634, 866}, -- Explore Nagrand
    {C, 620, 634},
    {N, 634, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 627, 4958}, -- The First Rule of Ring of Blood is You Don't Talk About Ring of Blood
    {A, 627, 1576}, -- Of Blood and Anguish
    {A, 627, 941}, -- Hemet Nesingwary: The Collected Quests
    {A, 627, 939}, -- Hills Like White Elekk
    {A, 627, 1273}, -- Nagrand Slam
    {A, 627, 1192}, -- Nagrand Slam
    {C, 620, 627},
    {N, 627, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 620},
    {N, 620, a.GetMapName(1951)}, -- Nagrand
    {A, 642, 1205}, -- Hero of Shattrath
    {A, 642, 903}, -- Shattrath Divided
    {C, 619, 642},
    {N, 642, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 633, 867}, -- Explore Terokkar Forest
    {C, 619, 633},
    {N, 633, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 626, 1275}, -- Bombs Away
    {A, 626, 1272}, -- Terror of Terokkar
    {A, 626, 1191}, -- Terror of Terokkar
    {C, 619, 626},
    {N, 626, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 619},
    {N, 619, a.GetMapName(1952)}, -- Terokkar Forest
    {A, 643, 943}, -- The Diplomat
    {A, 643, 942}, -- The Diplomat
    {A, 643, 900}, -- The Czar of Sporeggar
    {A, 643, 953}, -- Guardian of Cenarius
    {A, 643, 893}, -- Cenarion War Hippogryph
    {A, 643, 762}, -- Ambassador of the Horde
    {A, 643, 948}, -- Ambassador of the Alliance
    {C, 618, 643},
    {N, 643, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 632, 863}, -- Explore Zangarmarsh
    {C, 618, 632},
    {N, 632, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 625, 1190}, -- Mysteries of the Marsh
    {C, 618, 625},
    {N, 625, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 618},
    {N, 618, a.GetMapName(1946)}, -- Zangarmarsh
    {A, 1011, 762}, -- Ambassador of the Horde
    {A, 1011, 948}, -- Ambassador of the Alliance
    {C, 617, 1011},
    {N, 1011, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 631, 862}, -- Explore Hellfire Peninsula
    {C, 617, 631},
    {N, 631, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 624, 1271}, -- To Hellfire and Back
    {A, 624, 1189}, -- To Hellfire and Back
    {C, 617, 624},
    {N, 624, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 617},
    {N, 617, a.GetMapName(1944)}, -- Hellfire Peninsula
    {A, 1010, 762}, -- Ambassador of the Horde
    {C, 669, 1010},
    {N, 1010, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 733, 858}, -- Explore Ghostlands
    {C, 669, 733},
    {N, 733, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 670, 4908}, -- Ghostlands Quests
    {C, 669, 670},
    {N, 670, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 669},
    {N, 669, a.GetMapName(1942)}, -- Ghostlands
    {A, 1008, 762}, -- Ambassador of the Horde
    {C, 727, 1008},
    {N, 1008, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 728, 859}, -- Explore Eversong Woods
    {C, 727, 728},
    {N, 728, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 616, 727},
    {N, 727, a.GetMapName(1941)}, -- Eversong Woods
    {A, 1000, 948}, -- Ambassador of the Alliance
    {C, 693, 1000},
    {N, 1000, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 763, 861}, -- Explore Bloodmyst Isle
    {C, 693, 763},
    {N, 763, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 694, 4926}, -- Bloodmyst Isle Quests
    {C, 693, 694},
    {N, 694, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 616, 693},
    {N, 693, a.GetMapName(1950)}, -- Bloodmyst Isle
    {A, 998, 948}, -- Ambassador of the Alliance
    {C, 758, 998},
    {N, 998, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 759, 860}, -- Explore Azuremyst Isle
    {C, 758, 759},
    {N, 759, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 616, 758},
    {N, 758, a.GetMapName(1943)}, -- Azuremyst Isle
    {A, 969, 603}, -- Wrath of the Horde
    {A, 969, 619}, -- For The Horde!
    {A, 969, 618}, -- Putting Out the Light
    {C, 616, 969},
    {N, 969, a.GetMapName(1947)}, -- The Exodar
    {A, 924, 604}, -- Wrath of the Alliance
    {A, 924, 614}, -- For The Alliance!
    {A, 924, 613}, -- Killed in Quel'Thalas
    {C, 616, 924},
    {N, 924, a.GetMapName(1954)}, -- Silvermoon City
    {A, 794, 1165}, -- "My Storage is ""Gigantique"""
    {C, 616, 794},
    {N, 794, a.GetMapName(1955)}, -- Shattrath City
    {A, 616, 1682}, -- The Loremaster
    {A, 616, 1681}, -- The Loremaster
    {A, 616, 902}, -- Chief Exalted Officer
    {A, 616, 897}, -- You're So Offensive
    {A, 616, 894}, -- Flying High Over Skettis
    {A, 616, 764}, -- The Burning Crusader
    {A, 616, 763}, -- The Burning Crusader
    {A, 616, 44}, -- Explore Outland
    {A, 616, 1312}, -- Bloody Rare
    {A, 616, 1311}, -- Medium Rare
    {A, 616, 1274}, -- Loremaster of Outland
    {A, 616, 1262}, -- Loremaster of Outland
    {C, 55, 616},
    {N, 616, a.L["Zones"]}, -- Zones
    {C, 883, 55},
    {N, 55, a.GetCategoryInfoTitle(14865)}, -- The Burning Crusade
    {C, 1, 785},
    {N, 785, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {C, 1150, 1529},
    {N, 1529, a.GetCategoryInfoTitle(15496), true}, -- Tailoring
    {C, 1150, 1516},
    {N, 1516, a.GetCategoryInfoTitle(15497), true}, -- Mining
    {C, 1150, 1513},
    {N, 1513, a.GetCategoryInfoTitle(15495), true}, -- Leatherworking
    {A, 1500, 5852}, -- Gone Fishin'
    {A, 1500, 5851}, -- Gone Fishin'
    {A, 1500, 5850}, -- Fish or Cut Bait: Undercity
    {A, 1500, 5849}, -- Fish or Cut Bait: Thunder Bluff
    {A, 1500, 5477}, -- Fish or Cut Bait: Orgrimmar
    {A, 1500, 5476}, -- Fish or Cut Bait: Stormwind
    {A, 1500, 5847}, -- Fish or Cut Bait: Ironforge
    {A, 1500, 5848}, -- Fish or Cut Bait: Darnassus
    {A, 1500, 1837}, -- Old Ironjaw
    {A, 1500, 1836}, -- Old Crafty
    {A, 1500, 878}, -- One That Didn't Get Away
    {A, 1500, 306}, -- Master Angler of Azeroth
    {A, 1500, 150}, -- The Fishing Diplomat
    {A, 1500, 128}, -- Artisan Fisherman
    {A, 1500, 127}, -- Expert Fisherman
    {A, 1500, 126}, -- Journeyman Fisherman
    {C, 1150, 1500},
    {N, 1500, a.GetCategoryInfoTitle(171), true}, -- Fishing
    {A, 1477, 5779}, -- You'll Feel Right as Rain
    {A, 1477, 5846}, -- A Bunch of Lunch
    {A, 1477, 5845}, -- A Bunch of Lunch
    {A, 1477, 5844}, -- Let's Do Lunch: Undercity
    {A, 1477, 5843}, -- Let's Do Lunch: Thunder Bluff
    {A, 1477, 5475}, -- Let's Do Lunch: Orgrimmar
    {A, 1477, 5474}, -- Let's Do Lunch: Stormwind
    {A, 1477, 5841}, -- Let's Do Lunch: Ironforge
    {A, 1477, 5842}, -- Let's Do Lunch: Darnassus
    {A, 1477, 123}, -- Artisan Cook
    {A, 1477, 122}, -- Expert Cook
    {A, 1477, 121}, -- Journeyman Cook
    {C, 1150, 1477},
    {N, 1477, a.GetCategoryInfoTitle(170), true}, -- Cooking
    {C, 1150, 1476},
    {N, 1476, a.GetCategoryInfoTitle(15490), true}, -- Blacksmithing
    {A, 1468, 4859}, -- Kings Under the Mountain
    {A, 1468, 5193}, -- Blue Streak
    {A, 1468, 5191}, -- Tragedy in Three Acts
    {A, 1468, 4858}, -- Seven Scepters
    {A, 1468, 4920}, -- Artisan in Archaeology
    {A, 1468, 4919}, -- Expert in Archaeology
    {A, 1468, 4857}, -- Journeyman in Archaeology
    {C, 1150, 1468},
    {N, 1468, a.GetCategoryInfoTitle(15071), true}, -- Archaeology
    {A, 1150, 133}, -- Artisan in First Aid
    {A, 1150, 132}, -- Expert in First Aid
    {A, 1150, 131}, -- Journeyman in First Aid
    {A, 1150, 732}, -- Professional Artisan
    {A, 1150, 731}, -- Professional Expert
    {A, 1150, 116}, -- Professional Journeyman
    {C, 1, 1150},
    {N, 1150, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 796, 15637}, -- The Immortal (Season of Mastery)
    {A, 796, 15335}, -- Survivor of the Damned (Season of Mastery)
    {A, 796, 425}, -- "Atiesh, Greatstaff of the Guardian"
    {C, 3, 796},
    {N, 796, a.GetInstanceInfoName(754) .. " (" .. a.GetCategoryInfoTitle(15234) .. ")"}, -- Naxxramas
    {A, 780, 956}, -- Brood of Nozdormu
    {C, 30, 780},
    {N, 780, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 30, 15334}, -- Survivor of the Old God (Season of Mastery)
    {A, 30, 424}, -- Why? Because It's Red
    {A, 30, 687}, -- Temple of Ahn'Qiraj
    {C, 3, 30},
    {N, 30, a.GetInstanceInfoName(744)}, -- Temple of Ahn'Qiraj
    {A, 784, 953}, -- Guardian of Cenarius
    {C, 29, 784},
    {N, 784, a.GetCategoryInfoTitle(201)}, -- Reputation
    {A, 29, 689}, -- Ruins of Ahn'Qiraj
    {C, 3, 29},
    {N, 29, a.GetInstanceInfoName(743)}, -- Ruins of Ahn'Qiraj
    {A, 789, 957}, -- Hero of the Zandalar Tribe
    {C, 28, 789},
    {N, 789, a.GetCategoryInfoTitle(201)}, -- Reputation
    {A, 28, 881}, -- Swift Razzashi Raptor
    {A, 28, 880}, -- Swift Zulian Tiger
    {A, 28, 688}, -- Zul'Gurub
    {A, 28, 560}, -- Deadliest Catch
    {C, 3, 28},
    {N, 28, a.GetInstanceInfoName(76)}, -- Zul'Gurub
    {A, 27, 15333}, -- Survivor of the Shadow Flame (Season of Mastery)
    {A, 27, 685}, -- Blackwing Lair
    {C, 3, 27},
    {N, 27, a.GetInstanceInfoName(742)}, -- Blackwing Lair
    {A, 26, 684}, -- Onyxia's Lair (Level 60)
    {C, 3, 26},
    {N, 26, a.GetInstanceInfoName(760) .. " (" .. a.GetCategoryInfoTitle(15234) .. ")"}, -- Onyxia's Lair
    {A, 779, 2496}, -- The Fifth Element
    {A, 779, 955}, -- Hydraxian Waterlords
    {C, 7, 779},
    {N, 779, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 7, 15330}, -- Survivor of the Firelord (Season of Mastery)
    {A, 7, 428}, -- "Thunderfury, Blessed Blade of the Windseeker"
    {A, 7, 429}, -- "Sulfuras, Hand of Ragnaros"
    {A, 7, 686}, -- Molten Core
    {C, 3, 7},
    {N, 7, a.GetInstanceInfoName(741)}, -- Molten Core
    {A, 3, 1285}, -- Classic Raider
    {C, 1, 3},
    {N, 3, a.GetCategoryInfoTitle(15271)}, -- Raids
    {A, 25, 729}, -- Deathcharger's Reins
    {A, 25, 646}, -- Stratholme
    {C, 2, 25},
    {N, 25, a.GetInstanceInfoName(236)}, -- Stratholme
    {A, 1455, 645}, -- Scholomance
    {C, 2, 1455},
    {N, 1455, a.GetInstanceInfoName(246)}, -- Scholomance
    {A, 23, 5788}, -- Agent of the Shen'dralar
    {A, 23, 644}, -- King of Dire Maul
    {C, 2, 23},
    {N, 23, a.GetInstanceInfoName(230)}, -- Dire Maul
    {A, 797, 2188}, -- Leeeeeeeeeeeeeroy!
    {A, 797, 1307}, -- Upper Blackrock Spire
    {C, 2, 797},
    {N, 797, a.GetInstanceInfoName(559)}, -- Upper Blackrock Spire
    {A, 22, 643}, -- Lower Blackrock Spire
    {C, 2, 22},
    {N, 22, a.GetInstanceInfoName(229)}, -- Lower Blackrock Spire
    {A, 21, 3496}, -- A Brew-FAST Mount
    {A, 21, 642}, -- Blackrock Depths
    {C, 2, 21},
    {N, 21, a.GetInstanceInfoName(228)}, -- Blackrock Depths
    {A, 20, 641}, -- Sunken Temple
    {C, 2, 20},
    {N, 20, a.GetInstanceInfoName(237)}, -- The Temple Of Atal'hakkar
    {A, 19, 640}, -- Maraudon
    {C, 2, 19},
    {N, 19, a.GetInstanceInfoName(232)}, -- Maraudon
    {A, 18, 639}, -- Zul'Farrak
    {C, 2, 18},
    {N, 18, a.GetInstanceInfoName(241)}, -- Zul'Farrak
    {A, 17, 638}, -- Uldaman
    {C, 2, 17},
    {N, 17, a.GetInstanceInfoName(239)}, -- Uldaman
    {A, 16, 980}, -- The Horseman's Reins
    {A, 16, 637}, -- Scarlet Monastery
    {C, 2, 16},
    {N, 16, a.GetInstanceInfoName(316)}, -- Scarlet Monastery
    {A, 14, 636}, -- Razorfen Downs
    {C, 2, 14},
    {N, 14, a.GetInstanceInfoName(234)}, -- Razorfen Downs
    {A, 13, 635}, -- Razorfen Kraul
    {C, 2, 13},
    {N, 13, a.GetInstanceInfoName(233)}, -- Razorfen Kraul
    {A, 12, 634}, -- Gnomeregan
    {C, 2, 12},
    {N, 12, a.GetInstanceInfoName(231)}, -- Gnomeregan
    {A, 11, 633}, -- Stormwind Stockade
    {C, 2, 11},
    {N, 11, a.GetInstanceInfoName(238)}, -- The Stockade
    {A, 10, 632}, -- Blackfathom Deeps
    {C, 2, 10},
    {N, 10, a.GetInstanceInfoName(227)}, -- Blackfathom Deeps
    {A, 8, 630}, -- Wailing Caverns
    {C, 2, 8},
    {N, 8, a.GetInstanceInfoName(240)}, -- Wailing Caverns
    {A, 5, 629}, -- Ragefire Chasm
    {C, 2, 5},
    {N, 5, a.GetInstanceInfoName(226)}, -- Ragefire Chasm
    {A, 2, 1283}, -- Classic Dungeonmaster
    {C, 1, 2},
    {N, 2, a.GetCategoryInfoTitle(15272)}, -- Dungeons
    {A, 1031, 2336}, -- Insane in the Membrane
    {C, 719, 1031},
    {N, 1031, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 777, 857}, -- Explore Winterspring
    {C, 719, 777},
    {N, 777, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 720, 5443}, -- E'ko Madness
    {A, 720, 4940}, -- Winterspring Quests
    {C, 719, 720},
    {N, 720, a.GetCategoryInfoTitle(96), true}, -- Quests
    {A, 719, 3356}, -- Winterspring Frostsaber
    {C, 688, 719},
    {N, 719, a.GetMapName(1452)}, -- Winterspring
    {A, 783, 953}, -- Guardian of Cenarius
    {C, 707, 783},
    {N, 783, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 776, 856}, -- Explore Silithus
    {C, 707, 776},
    {N, 776, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 708, 4934}, -- Silithus Quests
    {C, 707, 708},
    {N, 708, a.GetCategoryInfoTitle(96), true}, -- Quests
    {A, 707, 5533}, -- Veteran of the Shifting Sands
    {A, 707, 416}, -- Scarab Lord
    {C, 688, 707},
    {N, 707, a.GetMapName(1451)}, -- Silithus
    {A, 773, 854}, -- Explore Un'Goro Crater
    {C, 717, 773},
    {N, 773, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 718, 4939}, -- Un'Goro Crater Quests
    {C, 717, 718},
    {N, 718, a.GetCategoryInfoTitle(96), true}, -- Quests
    {A, 717, 3357}, -- Venomhide Ravasaur
    {C, 688, 717},
    {N, 717, a.GetMapName(1449)}, -- Un'Goro Crater
    {A, 991, 762}, -- Ambassador of the Horde
    {A, 991, 948}, -- Ambassador of the Alliance
    {C, 701, 991},
    {N, 991, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 772, 853}, -- Explore Felwood
    {C, 701, 772},
    {N, 772, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 702, 4931}, -- Felwood Quests
    {C, 701, 702},
    {N, 702, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 701},
    {N, 701, a.GetMapName(1448)}, -- Felwood
    {A, 992, 2336}, -- Insane in the Membrane
    {A, 992, 762}, -- Ambassador of the Horde
    {A, 992, 948}, -- Ambassador of the Alliance
    {C, 713, 992},
    {N, 992, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 770, 851}, -- Explore Tanaris
    {C, 713, 770},
    {N, 770, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 714, 4935}, -- Tanaris Quests
    {C, 713, 714},
    {N, 714, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 713},
    {N, 713, a.GetMapName(1446)}, -- Tanaris
    {A, 994, 762}, -- Ambassador of the Horde
    {A, 994, 948}, -- Ambassador of the Alliance
    {C, 715, 994},
    {N, 994, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 765, 846}, -- Explore Thousand Needles
    {C, 715, 765},
    {N, 765, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 716, 4938}, -- Thousand Needles Quests
    {C, 715, 716},
    {N, 716, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 715},
    {N, 715, a.GetMapName(1441)}, -- Thousand Needles
    {A, 1004, 948}, -- Ambassador of the Alliance
    {C, 699, 1004},
    {N, 1004, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 768, 850}, -- Explore Dustwallow Marsh
    {C, 699, 768},
    {N, 768, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 700, 4978}, -- Dustwallow Marsh Quests
    {A, 700, 4929}, -- Dustwallow Marsh Quests
    {C, 699, 700},
    {N, 700, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 699},
    {N, 699, a.GetMapName(1445)}, -- Dustwallow Marsh
    {A, 1009, 762}, -- Ambassador of the Horde
    {A, 1009, 948}, -- Ambassador of the Alliance
    {C, 703, 1009},
    {N, 1009, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 769, 849}, -- Explore Feralas
    {C, 703, 769},
    {N, 769, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 704, 4979}, -- Feralas Quests
    {A, 704, 4932}, -- Feralas Quests
    {C, 703, 704},
    {N, 704, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 703},
    {N, 703, a.GetMapName(1444)}, -- Feralas
    {A, 1002, 762}, -- Ambassador of the Horde
    {C, 697, 1002},
    {N, 1002, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 767, 848}, -- Explore Desolace
    {C, 697, 767},
    {N, 767, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 698, 4930}, -- Desolace Quests
    {C, 697, 698},
    {N, 698, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 697},
    {N, 697, a.GetMapName(1443)}, -- Desolace
    {A, 1021, 762}, -- Ambassador of the Horde
    {A, 1021, 948}, -- Ambassador of the Alliance
    {C, 709, 1021},
    {N, 1021, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 766, 847}, -- Explore Stonetalon Mountains
    {C, 709, 766},
    {N, 766, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 710, 4980}, -- Stonetalon Mountains Quests
    {A, 710, 4936}, -- Stonetalon Mountains Quests
    {C, 709, 710},
    {N, 710, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 709},
    {N, 709, a.GetMapName(1442)}, -- Stonetalon Mountains
    {A, 997, 948}, -- Ambassador of the Alliance
    {C, 689, 997},
    {N, 997, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 764, 845}, -- Explore Ashenvale
    {C, 689, 764},
    {N, 764, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 690, 4976}, -- Ashenvale Quests
    {A, 690, 4925}, -- Ashenvale Quests
    {C, 689, 690},
    {N, 690, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 689},
    {N, 689, a.GetMapName(1440)}, -- Ashenvale
    {A, 990, 762}, -- Ambassador of the Horde
    {C, 691, 990},
    {N, 990, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 771, 852}, -- Explore Azshara
    {C, 691, 771},
    {N, 771, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 692, 5547}, -- Glutton for Shadowy Punishment
    {A, 692, 5546}, -- Glutton for Icy Punishment
    {A, 692, 5448}, -- Glutton for Fiery Punishment
    {A, 692, 5454}, -- Joy Ride
    {A, 692, 4927}, -- Azshara Quests
    {C, 691, 692},
    {N, 692, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 691},
    {N, 691, a.GetMapName(1447)}, -- Azshara
    {A, 1001, 948}, -- Ambassador of the Alliance
    {C, 695, 1001},
    {N, 1001, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 762, 844}, -- Explore Darkshore
    {C, 695, 762},
    {N, 762, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 696, 5453}, -- Ghosts in the Dark
    {A, 696, 4928}, -- Darkshore Quests
    {C, 695, 696},
    {N, 696, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 688, 695},
    {N, 695, a.GetMapName(1439)}, -- Darkshore
    {A, 1382, 2336}, -- Insane in the Membrane
    {A, 1382, 762}, -- Ambassador of the Horde
    {C, 1379, 1382},
    {N, 1382, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 1381, 750}, -- Explore Northern Barrens
    {C, 1379, 1381},
    {N, 1381, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 688, 1379},
    {N, 1379, a.GetMapName(1413)}, -- The Barrens
    {A, 775, 855}, -- Explore Moonglade
    {C, 774, 775},
    {N, 775, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 688, 774},
    {N, 774, a.GetMapName(1450)}, -- Moonglade
    {A, 1014, 762}, -- Ambassador of the Horde
    {C, 754, 1014},
    {N, 1014, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 755, 736}, -- Explore Mulgore
    {C, 754, 755},
    {N, 755, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 688, 754},
    {N, 754, a.GetMapName(1412)}, -- Mulgore
    {A, 1003, 762}, -- Ambassador of the Horde
    {C, 752, 1003},
    {N, 1003, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 753, 728}, -- Explore Durotar
    {C, 752, 753},
    {N, 753, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 752, 4790}, -- Zalazane's Fall
    {C, 688, 752},
    {N, 752, a.GetMapName(1411)}, -- Durotar
    {A, 1025, 948}, -- Ambassador of the Alliance
    {C, 756, 1025},
    {N, 1025, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 757, 842}, -- Explore Teldrassil
    {C, 756, 757},
    {N, 757, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 688, 756},
    {N, 756, a.GetMapName(1438)}, -- Teldrassil
    {A, 923, 604}, -- Wrath of the Alliance
    {A, 923, 611}, -- Bleeding Bloodhoof
    {C, 688, 923},
    {N, 923, a.GetMapName(1456)}, -- Thunder Bluff
    {A, 1018, 762}, -- Ambassador of the Horde
    {C, 921, 1018},
    {N, 1018, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 921, 604}, -- Wrath of the Alliance
    {A, 921, 1006}, -- City Defender
    {A, 921, 614}, -- For The Alliance!
    {A, 921, 610}, -- Death to the Warchief!
    {C, 688, 921},
    {N, 921, a.GetMapName(1454)}, -- Orgrimmar
    {A, 975, 603}, -- Wrath of the Horde
    {A, 975, 617}, -- Immortal No More
    {C, 688, 975},
    {N, 975, a.GetMapName(1457)}, -- Darnassus
    {A, 688, 1682}, -- The Loremaster
    {A, 688, 1681}, -- The Loremaster
    {A, 688, 43}, -- Explore Kalimdor
    {A, 688, 1680}, -- Loremaster of Kalimdor
    {A, 688, 1678}, -- Loremaster of Kalimdor
    {C, 648, 688},
    {N, 688, a.GetMapName(1414)}, -- Kalimdor
    {A, 749, 777}, -- Explore Deadwind Pass
    {C, 748, 749},
    {N, 749, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 687, 748},
    {N, 748, a.GetMapName(1430)}, -- Deadwind Pass
    {A, 999, 762}, -- Ambassador of the Horde
    {A, 999, 948}, -- Ambassador of the Alliance
    {C, 660, 999},
    {N, 999, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 744, 766}, -- Explore Blasted Lands
    {C, 660, 744},
    {N, 744, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 662, 4909}, -- Blasted Lands Quests
    {C, 660, 662},
    {N, 662, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 660},
    {N, 660, a.GetMapName(1419)}, -- Blasted Lands
    {A, 745, 775}, -- Explore Burning Steppes
    {C, 663, 745},
    {N, 745, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 664, 4901}, -- Burning Steppes Quests
    {C, 663, 664},
    {N, 664, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 663},
    {N, 663, a.GetMapName(1428)}, -- Burning Steppes
    {A, 1023, 948}, -- Ambassador of the Alliance
    {C, 683, 1023},
    {N, 1023, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 737, 782}, -- Explore Swamp of Sorrows
    {C, 683, 737},
    {N, 737, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 684, 4904}, -- Swamp of Sorrows Quests
    {C, 683, 684},
    {N, 684, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 683},
    {N, 683, a.GetMapName(1435)}, -- Swamp of Sorrows
    {A, 743, 774}, -- Explore Searing Gorge
    {C, 679, 743},
    {N, 743, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 680, 4910}, -- Searing Gorge Quests
    {C, 679, 680},
    {N, 680, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 679},
    {N, 679, a.GetMapName(1427)}, -- Searing Gorge
    {A, 738, 765}, -- Explore Badlands
    {C, 659, 738},
    {N, 738, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 661, 5444}, -- "Ready, Set, Goat!"
    {A, 661, 4900}, -- Badlands Quests
    {C, 659, 661},
    {N, 661, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 659},
    {N, 659, a.GetMapName(1418)}, -- Badlands
    {A, 778, 945}, -- The Argent Champion
    {A, 778, 946}, -- The Argent Dawn
    {C, 667, 778},
    {N, 778, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 747, 771}, -- Explore Eastern Plaguelands
    {C, 667, 747},
    {N, 747, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 668, 5442}, -- Full Caravan
    {A, 668, 4892}, -- Eastern Plaguelands Quests
    {C, 667, 668},
    {N, 668, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 667},
    {N, 667, a.GetMapName(1423)}, -- Eastern Plaguelands
    {A, 1024, 762}, -- Ambassador of the Horde
    {C, 673, 1024},
    {N, 1024, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 742, 773}, -- Explore The Hinterlands
    {C, 673, 742},
    {N, 742, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 674, 4897}, -- Hinterlands Quests
    {C, 673, 674},
    {N, 674, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 673},
    {N, 673, a.GetMapName(1425)}, -- The Hinterlands
    {A, 1027, 762}, -- Ambassador of the Horde
    {A, 1027, 948}, -- Ambassador of the Alliance
    {C, 685, 1027},
    {N, 1027, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 746, 770}, -- Explore Western Plaguelands
    {C, 685, 746},
    {N, 746, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 686, 4893}, -- Western Plaguelands Quests
    {C, 685, 686},
    {N, 686, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 685},
    {N, 685, a.GetMapName(1422)}, -- Western Plaguelands
    {A, 993, 2336}, -- Insane in the Membrane
    {A, 993, 871}, -- "Avast Ye, Admiral!"
    {A, 993, 762}, -- Ambassador of the Horde
    {C, 665, 993},
    {N, 993, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 1164, 396}, -- Gurubashi Arena Grand Master
    {A, 1164, 389}, -- Gurubashi Arena Master
    {C, 665, 1164},
    {N, 1164, a.GetCategoryInfoTitle(95)}, -- Player vs. Player
    {A, 740, 4995}, -- Explore the Cape of Stranglethorn
    {C, 665, 740},
    {N, 740, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 666, 4905}, -- Cape of Stranglethorn Quests
    {C, 665, 666},
    {N, 666, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 665},
    {N, 665, a.GetMapName(210)}, -- The Cape of Stranglethorn
    {A, 1016, 762}, -- Ambassador of the Horde
    {A, 1016, 948}, -- Ambassador of the Alliance
    {C, 675, 1016},
    {N, 1016, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 739, 781}, -- Explore Northern Stranglethorn
    {C, 675, 739},
    {N, 739, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 676, 941}, -- Hemet Nesingwary: The Collected Quests
    {A, 676, 940}, -- The Green Hills of Stranglethorn
    {A, 676, 4906}, -- Northern Stranglethorn Quests
    {C, 675, 676},
    {N, 676, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 675},
    {N, 675, a.GetMapName(50)}, -- Northern Stranglethorn
    {A, 996, 762}, -- Ambassador of the Horde
    {A, 996, 948}, -- Ambassador of the Alliance
    {C, 649, 996},
    {N, 996, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 741, 761}, -- Explore Arathi Highlands
    {C, 649, 741},
    {N, 741, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 650, 4896}, -- Arathi Highlands Quests
    {C, 649, 650},
    {N, 650, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 649},
    {N, 649, a.GetMapName(1417)}, -- Arathi Highlands
    {C, 1383, 1384},
    {N, 1384, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 687, 1383},
    {N, 1383, a.GetMapName(1416)}, -- Alterac Mountains
    {A, 1012, 2336}, -- Insane in the Membrane
    {A, 1012, 762}, -- Ambassador of the Horde
    {C, 671, 1012},
    {N, 1012, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 736, 772}, -- Explore Hillsbrad Foothills
    {C, 671, 736},
    {N, 736, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 672, 4895}, -- Hillsbrad Foothills Quests
    {A, 672, 5365}, -- Bloom and Doom
    {A, 672, 5364}, -- Don't Want No Zombies on My Lawn
    {C, 671, 672},
    {N, 672, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 671},
    {N, 671, a.GetMapName(1424)}, -- Hillsbrad Foothills
    {A, 1029, 948}, -- Ambassador of the Alliance
    {C, 656, 1029},
    {N, 1029, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 731, 841}, -- Explore Wetlands
    {C, 656, 731},
    {N, 731, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 658, 4898}, -- Wetlands Quests
    {C, 656, 658},
    {N, 658, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 656},
    {N, 656, a.GetMapName(1437)}, -- Wetlands
    {A, 1007, 948}, -- Ambassador of the Alliance
    {C, 652, 1007},
    {N, 1007, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 735, 778}, -- Explore Duskwood
    {C, 652, 735},
    {N, 735, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 654, 4907}, -- Duskwood Quests
    {C, 652, 654},
    {N, 654, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 652},
    {N, 652, a.GetMapName(1431)}, -- Duskwood
    {A, 1017, 948}, -- Ambassador of the Alliance
    {C, 678, 1017},
    {N, 1017, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 734, 780}, -- Explore Redridge Mountains
    {C, 678, 734},
    {N, 734, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 677, 4902}, -- Redridge Mountains Quests
    {C, 678, 677},
    {N, 677, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 678},
    {N, 678, a.GetMapName(1433)}, -- Redridge Mountains
    {A, 1020, 762}, -- Ambassador of the Horde
    {C, 681, 1020},
    {N, 1020, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 732, 769}, -- Explore Silverpine Forest
    {C, 681, 732},
    {N, 732, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 682, 4894}, -- Silverpine Forest Quests
    {C, 681, 682},
    {N, 682, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 681},
    {N, 681, a.GetMapName(1421)}, -- Silverpine Forest
    {A, 1013, 948}, -- Ambassador of the Alliance
    {C, 655, 1013},
    {N, 1013, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 729, 779}, -- Explore Loch Modan
    {C, 655, 729},
    {N, 729, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 657, 4899}, -- Loch Modan Quests
    {C, 655, 657},
    {N, 657, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 655},
    {N, 655, a.GetMapName(1432)}, -- Loch Modan
    {A, 1028, 948}, -- Ambassador of the Alliance
    {C, 651, 1028},
    {N, 1028, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 730, 802}, -- Explore Westfall
    {C, 651, 730},
    {N, 730, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 653, 4903}, -- Westfall Quests
    {C, 651, 653},
    {N, 653, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 651},
    {N, 651, a.GetMapName(1436)}, -- Westfall
    {A, 1026, 762}, -- Ambassador of the Horde
    {C, 725, 1026},
    {N, 1026, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 726, 768}, -- Explore Tirisfal Glades
    {C, 725, 726},
    {N, 726, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 725, 1201},
    {N, 1201, a.GetCategoryInfoTitle(96), true}, -- Quests
    {C, 687, 725},
    {N, 725, a.GetMapName(1420)}, -- Tirisfal Glades
    {A, 1006, 948}, -- Ambassador of the Alliance
    {C, 722, 1006},
    {N, 1006, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 724, 776}, -- Explore Elwynn Forest
    {C, 722, 724},
    {N, 724, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {C, 687, 722},
    {N, 722, a.GetMapName(1429)}, -- Elwynn Forest
    {A, 1005, 948}, -- Ambassador of the Alliance
    {C, 721, 1005},
    {N, 1005, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {A, 723, 627}, -- Explore Dun Morogh
    {C, 721, 723},
    {N, 723, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 721, 4786}, -- Operation: Gnomeregan
    {C, 687, 721},
    {N, 721, a.GetMapName(1426)}, -- Dun Morogh
    {A, 974, 604}, -- Wrath of the Alliance
    {A, 974, 612}, -- Downing the Dark Lady
    {C, 687, 974},
    {N, 974, a.GetMapName(1458)}, -- Undercity
    {A, 970, 603}, -- Wrath of the Horde
    {A, 970, 619}, -- For The Horde!
    {A, 970, 616}, -- Overthrow the Council
    {C, 687, 970},
    {N, 970, a.GetMapName(1455)}, -- Ironforge
    {A, 1022, 948}, -- Ambassador of the Alliance
    {C, 922, 1022},
    {N, 1022, a.GetCategoryInfoTitle(201), true}, -- Reputation
    {C, 922, 1033},
    {N, 1033, a.GetCategoryInfoTitle(97), true}, -- Exploration
    {A, 922, 603}, -- Wrath of the Horde
    {A, 922, 388}, -- City Defender
    {A, 922, 615}, -- Storming Stormwind
    {C, 687, 922},
    {N, 922, a.GetMapName(1453)}, -- Stormwind City
    {A, 687, 1682}, -- The Loremaster
    {A, 687, 1681}, -- The Loremaster
    {A, 687, 42}, -- Explore Eastern Kingdoms
    {A, 687, 1677}, -- Loremaster of Eastern Kingdoms
    {A, 687, 1676}, -- Loremaster of Eastern Kingdoms
    {C, 648, 687},
    {N, 687, a.GetMapName(1415)}, -- Eastern Kingdoms
    {A, 648, 943}, -- The Diplomat
    {A, 648, 942}, -- The Diplomat
    {A, 648, 944}, -- They Love Me In That Tunnel
    {A, 648, 1206}, -- To All The Squirrels I've Loved Before
    {C, 1, 648},
    {N, 648, a.L["Zones"]}, -- Zones
    {C, 883, 1},
    {N, 1, a.GetCategoryInfoTitle(14864)}, -- Classic
    {A, 1172, 3896}, -- Onyx Panther
    {A, 1172, 3636}, -- Jade Tiger
    {A, 1172, 4496}, -- It's Over Nine Thousand!
    {C, 1431, 1172},
    {N, 1172, a.GetCategoryInfoTitle(81)}, -- Feats of Strength
    {A, 1171, 5755}, -- Thirty Tabards
    {A, 1171, 1021}, -- Twenty-Five Tabards
    {A, 1171, 1020}, -- Ten Tabards
    {A, 1171, 621}, -- Represent
    {C, 1431, 1171},
    {N, 1171, a.GetCategoryInfoTitle(15246)}, -- Collections
    {C, 1170, 1435},
    {N, 1435, a.GetCategoryInfoTitle(15120), true}, -- Level
    {C, 1170, 1434},
    {N, 1434, a.GetCategoryInfoTitle(15119), true}, -- Battle
    {A, 1433, 5875}, -- Littlest Pet Shop
    {A, 1433, 5877}, -- Menagerie
    {A, 1433, 5876}, -- Petting Zoo
    {A, 1433, 2516}, -- Lil' Game Hunter
    {A, 1433, 1250}, -- "Shop Smart, Shop Pet...Smart"
    {A, 1433, 1248}, -- Plethora of Pets
    {A, 1433, 15}, -- Plenty of Pets
    {A, 1433, 1017}, -- Can I Keep Him?
    {C, 1170, 1433},
    {N, 1433, a.GetCategoryInfoTitle(15118), true}, -- Collect
    {C, 1431, 1170},
    {N, 1170, a.GetCategoryInfoTitle(15117)}, -- Pet Battles
    {A, 1163, 5794}, -- Time Flies When You're Having Fun
    {A, 1163, 5723}, -- 50 Exalted Reputations
    {A, 1163, 5374}, -- 45 Exalted Reputations
    {A, 1163, 1014}, -- 35 Exalted Reputations
    {A, 1163, 518}, -- 30 Exalted Reputations
    {A, 1163, 519}, -- 25 Exalted Reputations
    {A, 1163, 520}, -- 20 Exalted Reputations
    {A, 1163, 521}, -- 15 Exalted Reputations
    {A, 1163, 524}, -- 10 Exalted Reputations
    {A, 1163, 523}, -- 5 Exalted Reputations
    {A, 1163, 522}, -- Somebody Likes Me
    {C, 1431, 1163},
    {N, 1163, a.GetCategoryInfoTitle(201)}, -- Reputation
    {A, 1524, 141}, -- Ultimate Triage
    {C, 1149, 1524},
    {N, 1524, a.GetCategoryInfoTitle(15496)}, -- Tailoring
    {C, 1149, 1510},
    {N, 1510, a.GetCategoryInfoTitle(15495)}, -- Leatherworking
    {C, 1149, 1465},
    {N, 1465, a.GetCategoryInfoTitle(15494)}, -- Jewelcrafting
    {C, 1149, 1464},
    {N, 1464, a.GetCategoryInfoTitle(15493)}, -- Inscription
    {A, 1462, 1516}, -- Accomplished Angler
    {A, 1462, 1561}, -- 1000 Fish
    {A, 1462, 1560}, -- 500 Fish
    {A, 1462, 1559}, -- 250 Fish
    {A, 1462, 1558}, -- 100 Fish
    {A, 1462, 1557}, -- 50 Fish
    {A, 1462, 1556}, -- 25 Fish
    {A, 1462, 3218}, -- Turtles All the Way Down
    {A, 1462, 1243}, -- Fish Don't Leave Footprints
    {A, 1462, 5479}, -- The Oceanographer
    {A, 1462, 5478}, -- The Limnologist
    {A, 1462, 1257}, -- The Scavenger
    {A, 1462, 153}, -- The Old Gnome and the Sea
    {C, 1149, 1462},
    {N, 1462, a.GetCategoryInfoTitle(171)}, -- Fishing
    {C, 1149, 1461},
    {N, 1461, a.GetCategoryInfoTitle(15492)}, -- Engineering
    {C, 1149, 1460},
    {N, 1460, a.GetCategoryInfoTitle(15491)}, -- Enchanting
    {A, 1458, 1784}, -- Hail to the Chef
    {A, 1458, 1563}, -- Hail to the Chef
    {A, 1458, 3296}, -- Cooking with Style
    {A, 1458, 5471}, -- Iron Chef
    {A, 1458, 1799}, -- Chef de Cuisine
    {A, 1458, 1798}, -- Sous Chef
    {A, 1458, 1797}, -- Chef de Partie
    {A, 1458, 1796}, -- Short Order Cook
    {A, 1458, 1795}, -- Lunch Lady
    {A, 1458, 1785}, -- Dinner Impossible
    {A, 1458, 2002}, -- 100 Cooking Awards
    {A, 1458, 2001}, -- 50 Cooking Awards
    {A, 1458, 2000}, -- 25 Cooking Awards
    {A, 1458, 1999}, -- 10 Cooking Awards
    {A, 1458, 1998}, -- Cooking Award
    {C, 1149, 1458},
    {N, 1458, a.GetCategoryInfoTitle(170)}, -- Cooking
    {C, 1149, 1457},
    {N, 1457, a.GetCategoryInfoTitle( 15490)}, -- Blacksmithing
    {A, 1459, 5511}, -- It's Always in the Last Place You Look
    {A, 1459, 4856}, -- It Belongs in a Museum!
    {A, 1459, 4855}, -- What was Briefly Yours is Now Mine
    {A, 1459, 4854}, -- I Had It in My Hand
    {A, 1459, 5470}, -- Diggerest
    {A, 1459, 5469}, -- Diggerer
    {A, 1459, 5315}, -- Digger
    {C, 1149, 1459},
    {N, 1459, a.GetCategoryInfoTitle(15071)}, -- Archaeology
    {C, 1149, 1456},
    {N, 1456, a.GetCategoryInfoTitle(15489)}, -- Alchemy
    {C, 1431, 1149},
    {N, 1149, a.GetCategoryInfoTitle(169)}, -- Professions
    {A, 1169, 4478}, -- Looking For Multitudes
    {A, 1169, 4477}, -- Looking For Many
    {A, 1169, 4476}, -- Looking For More
    {C, 1431, 1169},
    {N, 1169, a.GetCategoryInfoTitle(168)}, -- Dungeons & Raids
    {A, 1161, 1833}, -- It's Happy Hour Somewhere
    {A, 1161, 1832}, -- Tastes Like Chicken
    {A, 1161, 1244}, -- Well Read
    {A, 1161, 964}, -- Going Down?
    {C, 1431, 1161},
    {N, 1161, a.GetCategoryInfoTitle(97)}, -- Exploration
    {A, 1159, 5752}, -- Justly Rewarded
    {A, 1159, 1182}, -- The Bread Winner
    {A, 1159, 4957}, -- 20 Dungeon Quests Completed
    {A, 1159, 4956}, -- 5 Dungeon Quests Completed
    {A, 1159, 31}, -- A Simple Re-Quest
    {A, 1159, 5751}, -- 2500 Daily Quests Complete
    {A, 1159, 977}, -- 1000 Daily Quests Complete
    {A, 1159, 976}, -- 500 Daily Quests Complete
    {A, 1159, 975}, -- 200 Daily Quests Complete
    {A, 1159, 974}, -- 50 Daily Quests Complete
    {A, 1159, 973}, -- 5 Daily Quests Complete
    {A, 1159, 978}, -- 3000 Quests Completed
    {A, 1159, 32}, -- 2000 Quests Completed
    {A, 1159, 508}, -- 1500 Quests Completed
    {A, 1159, 507}, -- 1000 Quests Completed
    {A, 1159, 506}, -- 500 Quests Completed
    {A, 1159, 505}, -- 250 Quests Completed
    {A, 1159, 504}, -- 100 Quests Completed
    {A, 1159, 503}, -- 50 Quests Completed
    {C, 1431, 1159},
    {N, 1159, a.GetCategoryInfoTitle(96)}, -- Quests
    {A, 1432, 2716}, -- Dual Talent Specialization
    {A, 1432, 16}, -- Did Somebody Order a Knuckle Sandwich?
    {A, 1432, 705}, -- Master of Arms
    {A, 1432, 5372}, -- Cataclysmically Epic
    {A, 1432, 5373}, -- Cataclysmically Superior
    {A, 1432, 556}, -- Epic
    {A, 1432, 557}, -- Superior
    {A, 1432, 545}, -- Shave and a Haircut
    {A, 1432, 2359}, -- Swift Flight Form
    {A, 1432, 2358}, -- Charger
    {A, 1432, 2357}, -- Dreadsteed of Xoroth
    {A, 1432, 892}, -- The Right Stuff
    {A, 1432, 5180}, -- Breaking The Sound Barrier
    {A, 1432, 890}, -- Into The Wild Blue Yonder
    {A, 1432, 889}, -- Fast and Furious
    {A, 1432, 891}, -- Giddy Up!
    {A, 1432, 559}, -- Needy
    {A, 1432, 558}, -- Greedy
    {A, 1432, 5456}, -- Got My Mind On My Money
    {A, 1432, 5455}, -- Got My Mind On My Money
    {A, 1432, 1181}, -- Got My Mind On My Money
    {A, 1432, 1180}, -- Got My Mind On My Money
    {A, 1432, 1178}, -- Got My Mind On My Money
    {A, 1432, 1177}, -- Got My Mind On My Money
    {A, 1432, 1176}, -- Got My Mind On My Money
    {A, 1432, 546}, -- Safe Deposit
    {A, 1432, 16433}, -- Soul of Iron (Season of Mastery)
    {A, 1432, 4826}, -- Level 85
    {A, 1432, 13}, -- Level 80
    {A, 1432, 12}, -- Level 70
    {A, 1432, 11}, -- Level 60
    {A, 1432, 10}, -- Level 50
    {A, 1432, 9}, -- Level 40
    {A, 1432, 8}, -- Level 30
    {A, 1432, 7}, -- Level 20
    {A, 1432, 6}, -- Level 10
    {C, 1431, 1432},
    {N, 1432, a.GetCategoryInfoTitle(92)}, -- Character
    {C, 1160, 953},
    {N, 953, (select(2, a.GetAchievementInfo(14222)))}, -- Exile's Reach
    {C, 1431, 1160},
    {N, 1160, a.L["Zones"]}, -- Zones
    {C, 883, 1431},
    {N, 1431, a.L["Cross-Expansion"]}, -- Cross-Expansion
    {F, 1399, "SearchResultsCategories"},
    {C, 883, 1399},
    {N, 1399, a.L["Search Results"]}, -- Search Results
    function() categories[1223].IsSelectedZone = true; end,
    {F, 1223, "SelectedZoneCategories"},
    {C, 883, 1223},
    {N, 1223, a.L["Selected Zone"]}, -- Selected Zone
    function() categories[1213].IsCurrentZone = true; end,
    {F, 1213, "CurrentZoneCategories"},
    {C, 883, 1213},
    {N, 1213, a.L["Current Zone"]}, -- Current Zone
    function() categories[1217].IsWatchList = true; end,
    {F, 1217, "WatchListCategories"},
    {C, 883, 1217},
    {N, 1217, a.L["Watch List"]}, -- Watch List
    {S, 1203},
    {V, 1203},
    {C, 883, 1203},
    {N, 1203, a.L["Summary"]}, -- Summary
    {T, 883, "Expansions"},
    {N, 883, a.L["Expansions"]}, -- TAB - Expansions
    {F, 1553, "UncategorizedCategories"},
    {C, 1100, 1553},
    {N, 1553, a.L["Uncategorized"]}, -- Uncategorized
    {F, 1224, "ExcludedCategories"},
    {C, 1100, 1224},
    {N, 1224, a.L["Excluded"]}, -- Excluded
    function() categories[1371].IsTracking = true; end,
    {F, 1371, "TrackingAchievementsCategories"},
    {C, 1100, 1371},
    {N, 1371, a.L["Tracking Achievements"]}, -- Tracking Achievements
    {F, 1395, "SearchResultsCategories"},
    {C, 1100, 1395},
    {N, 1395, a.L["Search Results"]}, -- Search Results
    function() categories[1220].IsSelectedZone = true; end,
    {F, 1220, "SelectedZoneCategories"},
    {C, 1100, 1220},
    {N, 1220, a.L["Selected Zone"]}, -- Selected Zone
    function() categories[1212].IsCurrentZone = true; end,
    {F, 1212, "CurrentZoneCategories"},
    {C, 1100, 1212},
    {N, 1212, a.L["Current Zone"]}, -- Current Zone
    function() categories[1216].IsWatchList = true; end,
    {F, 1216, "WatchListCategories"},
    {C, 1100, 1216},
    {N, 1216, a.L["Watch List"]}, -- Watch List
    {S, 1202},
    {V, 1202},
    {C, 1100, 1202},
    {N, 1202, a.L["Summary"]}, -- Summary
    {T, 1100, "Achievements"},
    {N, 1100, a.L["Achievements"]}, -- TAB - Achievements
};

function exportedCategories.InjectDynamicOptions()
    local o = a.Options.Layout.InjectDynamicAdjustableCategoryOptions;

    o("WatchList", a.L["Watch List"], 1, "Achievements", a.L["Achievements"], false);
    o("WatchList", a.L["Watch List"], 2, "Expansions", a.L["Expansions"], false);
    o("WatchList", a.L["Watch List"], 3, "Events", a.L["Events"], false);
    o("WatchList", a.L["Watch List"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("WatchList", a.L["Watch List"], 5, "Specials", a.L["Specials"], true);

    o("CurrentZone", a.L["Current Zone"], 1, "Achievements", a.L["Achievements"], false);
    o("CurrentZone", a.L["Current Zone"], 2, "Expansions", a.L["Expansions"], false);
    o("CurrentZone", a.L["Current Zone"], 3, "Events", a.L["Events"], false);
    o("CurrentZone", a.L["Current Zone"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("CurrentZone", a.L["Current Zone"], 5, "Specials", a.L["Specials"], true);

    o("SelectedZone", a.L["Selected Zone"], 1, "Achievements", a.L["Achievements"], false);
    o("SelectedZone", a.L["Selected Zone"], 2, "Expansions", a.L["Expansions"], false);
    o("SelectedZone", a.L["Selected Zone"], 3, "Events", a.L["Events"], false);
    o("SelectedZone", a.L["Selected Zone"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("SelectedZone", a.L["Selected Zone"], 5, "Specials", a.L["Specials"], true);

    o("SearchResults", a.L["Search Results"], 1, "Achievements", a.L["Achievements"], false);
    o("SearchResults", a.L["Search Results"], 2, "Expansions", a.L["Expansions"], false);
    o("SearchResults", a.L["Search Results"], 3, "Events", a.L["Events"], false);
    o("SearchResults", a.L["Search Results"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("SearchResults", a.L["Search Results"], 5, "Specials", a.L["Specials"], true);

    o("TrackingAchievements", a.L["Tracking Achievements"], 1, "Achievements", a.L["Achievements"], false);
    o("TrackingAchievements", a.L["Tracking Achievements"], 2, "Expansions", a.L["Expansions"], false);
    o("TrackingAchievements", a.L["Tracking Achievements"], 3, "Events", a.L["Events"], false);
    o("TrackingAchievements", a.L["Tracking Achievements"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("TrackingAchievements", a.L["Tracking Achievements"], 5, "Specials", a.L["Specials"], true);

    o("Excluded", a.L["Excluded"], 1, "Achievements", a.L["Achievements"], false);
    o("Excluded", a.L["Excluded"], 2, "Expansions", a.L["Expansions"], false);
    o("Excluded", a.L["Excluded"], 3, "Events", a.L["Events"], false);
    o("Excluded", a.L["Excluded"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("Excluded", a.L["Excluded"], 5, "Specials", a.L["Specials"], true);

    o("Uncategorized", a.L["Uncategorized"], 1, "Achievements", a.L["Achievements"], false);
    o("Uncategorized", a.L["Uncategorized"], 2, "Expansions", a.L["Expansions"], false);
    o("Uncategorized", a.L["Uncategorized"], 3, "Events", a.L["Events"], false);
    o("Uncategorized", a.L["Uncategorized"], 4, "PvP", a.GetCategoryInfoTitle(95), false);
    o("Uncategorized", a.L["Uncategorized"], 5, "Specials", a.L["Specials"], true);
end