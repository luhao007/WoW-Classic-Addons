local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.ShadowmoonValley;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.ShadowmoonValley;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1948
local ACHIEVEMENT_ID = 1195
local CONTINENT_ID = 1945
local LEVEL_RANGE = {25, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 67,
    },
}

Chain.WildhammerStronghold = 20701
Chain.ShadowmoonVillage = 20702
Chain.NetherwingLedge = 20703
Chain.TheFirstDeathKnightAlliance = 20704
Chain.TheFirstDeathKnightHorde = 20705
Chain.BorrowedPower = 20706
Chain.BorrowedPowerAldor = 20707
Chain.BorrowedPowerScryers = 20708
Chain.AkamasPromise = 20709
Chain.AkamasPromiseAldor = 20710
Chain.AkamasPromiseScryers = 20711
Chain.TheCipherOfDamnation = 20712
Chain.AntiDemonWeapons = 20713
Chain.TheDarkConclave = 20714

Chain.EmbedChain01 = 20715
Chain.EmbedChain02 = 20716
Chain.EmbedChain03 = 20717
Chain.EmbedChain04 = 20718
Chain.EmbedChain05 = 20719
Chain.EmbedChain06 = 20720
Chain.EmbedChain07 = 20721
Chain.EmbedChain08 = 20722
Chain.EmbedChain09 = 20723

Chain.EmbedChain10 = 20724
Chain.EmbedChain11 = 20725
Chain.EmbedChain12 = 20726
Chain.EmbedChain13 = 20727
Chain.EmbedChain14 = 20728
Chain.EmbedChain15 = 20729
Chain.EmbedChain16 = 20730

Chain.Chain01 = 20731

Chain.TempChain01 = 20732
Chain.TempChain05 = 20733
Chain.TempChain06 = 20734
Chain.TempChain07 = 20735
Chain.TempChain08 = 20736
Chain.TempChain09 = 20737
Chain.TempChain12 = 20738
Chain.TempChain13 = 20739
Chain.TempChain14 = 20740

Chain.OthersChain = 20799

Database:AddChain(Chain.WildhammerStronghold, {
    name = L["WILDHAMMER_STRONGHOLD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.ShadowmoonVillage
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10661, 11044, 49550, 10562, 10772
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10678, 10776, 10744},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                323650, 323850, 324000, 324200, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amounts = {
                1184000, 1232000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 935,
            amount = 650,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            aside = true,
            embed = true,
            x = -3,
            y = 4,
        },
    },
})
Database:AddChain(Chain.ShadowmoonVillage, {
    name = L["SHADOWMOON_VILLAGE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.WildhammerStronghold
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10660, 11048, 49532, 10595, 10750
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10673, 10769, 10745},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 326450,
        },
        {
            type = "money",
            amounts = {
                1184000, 1232000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 935,
            amount = 650,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain04,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            aside = true,
            embed = true,
            x = -3,
            y = 4,
        },
    },
})
Database:AddChain(Chain.NetherwingLedge, {
    name = L["NETHERWING_LEDGE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10804,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10870, 11041},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                92050, 93350, 94500, 95700, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amounts = {
                222000, 234000, 246000, 264000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 1015,
            amount = 42500,
        },
    },
    items = {
        {
            type = "npc",
            id = 22113,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10804,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10811,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10814,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10836,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10837,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10854,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10858,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10866,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10870,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11012,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11013,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11019,
            x = -1,
        },
        {
            type = "quest",
            id = 11014,
            connections = {
                1, 
            },
        },
        {
            type = "kill",
            id = 23267,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11041,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheFirstDeathKnightAlliance, {
    name = L["THE_FIRST_DEATH_KNIGHT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheFirstDeathKnightHorde
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11045, 10642
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10645,
    },
    rewards = {
        {
            type = "experience",
            amount = 94150,
        },
        {
            type = "money",
            amounts = {
                82000, 88000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11045,
                    restrictions = {
                        type = "quest",
                        id = 11045,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 21774,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10642,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10643,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10644,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10634,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10635,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10636,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10645,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheFirstDeathKnightHorde, {
    name = L["THE_FIRST_DEATH_KNIGHT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheFirstDeathKnightAlliance
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11046, 10624
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10639,
    },
    rewards = {
        {
            type = "experience",
            amount = 94150,
        },
        {
            type = "money",
            amounts = {
                82000, 88000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11046,
                    restrictions = {
                        type = "quest",
                        id = 11046,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 21772,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10624,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10625,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10633,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10634,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10635,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10636,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10639,
            x = 0,
        },
    },
})
Database:AddChain(Chain.BorrowedPower, {
    name = L["BORROWED_POWER"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.BorrowedPower,
        Chain.BorrowedPowerAldor,
        Chain.BorrowedPowerScryers,
    },
    restrictions = {
        type = "quest",
        ids = {10551, 10552},
        equals = true,
        count = 0,
    },
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
    active = {
        type = "quest",
        id = 10587,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10651,
    },
    items = {
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
})
Database:AddChain(Chain.BorrowedPowerAldor, {
    name = L["BORROWED_POWER"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.BorrowedPower,
        Chain.BorrowedPowerAldor,
        Chain.BorrowedPowerScryers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 932,
            standing = 4,
        },
        {
            type = "quest",
            id = 10551,
        },
    },
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10587,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10651,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                121850, 122100, 122400, 122700, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 932,
            amount = 1650,
        },
    },
    items = {
        {
            type = "npc",
            id = 21860,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10587,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10637,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10640,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10641,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10668,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10669,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10646,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10649,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10650,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10651,
            x = 0,
        },
    },
})
Database:AddChain(Chain.BorrowedPowerScryers, {
    name = L["BORROWED_POWER"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.BorrowedPower,
        Chain.BorrowedPowerAldor,
        Chain.BorrowedPowerScryers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 934,
            standing = 4,
        },
        {
            type = "quest",
            id = 10552,
        },
    },
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10687,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10692,
    },
    rewards = {
        {
            type = "experience",
            amount = 126300,
        },
        {
            type = "reputation",
            id = 934,
            amount = 1650,
        },
    },
    items = {
        {
            type = "npc",
            id = 21954,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10687,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10688,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10689,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10641,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10668,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10669,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10646,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10649,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10691,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10692,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AkamasPromise, {
    name = L["AKAMAS_PROMISE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.AkamasPromise,
        Chain.AkamasPromiseAldor,
        Chain.AkamasPromiseScyers,
    },
    restrictions = {
        type = "quest",
        ids = {10551, 10552},
        equals = true,
        count = 0,
    },
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
    active = {
        type = "quest",
        id = 10587,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10651,
    },
    items = {
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
})
Database:AddChain(Chain.AkamasPromiseAldor, {
    name = L["AKAMAS_PROMISE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.AkamasPromise,
        Chain.AkamasPromiseAldor,
        Chain.AkamasPromiseScyers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 932,
            standing = 4,
        },
        {
            type = "quest",
            id = 10551,
        },
    },
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10568,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {
            11052, 10708, 
        },
    },
    items = {
        {
            type = "npc",
            id = 21402,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10568,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10571,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10574,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10575,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10622,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10628,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10705,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10706,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10707,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            ids = {
                11052, 10708, 
            },
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            aside = true,
            embed = true,
            x = 2,
            y = 0,
        },
        {
            visible = false,
            x = -2,
            y = 0,
        },
    },
})
Database:AddChain(Chain.AkamasPromiseScryers, {
    name = L["AKAMAS_PROMISE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.AkamasPromise,
        Chain.AkamasPromiseAldor,
        Chain.AkamasPromiseScyers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 934,
            standing = 4,
        },
        {
            type = "quest",
            id = 10552,
        },
    },
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10683,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {
            11052, 10708, 
        },
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                124750, 124850, 124950, 125050, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amount = 44000,
        },
        {
            type = "reputation",
            id = 934,
            amount = 1325,
        },
        {
            type = "reputation",
            id = 1012,
            amount = 925,
        },
    },
    items = {
        {
            type = "npc",
            id = 21955,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10683,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10684,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10685,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10686,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10622,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10628,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10705,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10706,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10707,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            ids = {
                11052, 10708, 
            },
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
            aside = true,
            embed = true,
            x = 2,
            y = 0,
        },
        {
            visible = false,
            x = -2,
            y = 0,
        },
    },
})
Database:AddChain(Chain.TheCipherOfDamnation, {
    name = L["THE_CIPHER_OF_DAMNATION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        ids = {
            10680, 10681, 10458
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10588,
    },
    rewards = {
        {
            type = "experience",
            amount = 224900,
        },
        {
            type = "money",
            amount = 132000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10680,
                    restrictions = {
                        type = "quest",
                        id = 10680,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 10681,
                    restrictions = {
                        type = "quest",
                        id = 10681,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 21024,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10458,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10480,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10481,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10513,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10514,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10515,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10519,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10588,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AntiDemonWeapons, {
    name = L["ANTI_DEMON_WEAPONS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10621, 10623
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10679,
    },
    rewards = {
        {
            type = "experience",
            amount = 126100,
        },
        {
            type = "money",
            amounts = {
                214000, 220000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "kill",
            id = 21499,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10621,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "quest",
                    id = 10623,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10626,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "quest",
                    id = 10627,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10662,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "quest",
                    id = 10663,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10664,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10665,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 10666,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10667,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10670,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10676,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10679,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheDarkConclave, {
    name = L["THE_DARK_CONCLAVE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10569, 10760
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10808,
    },
    rewards = {
        {
            type = "experience",
            amount = 64600,
        },
        {
            type = "money",
            amounts = {
                205000, 220000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "npc",
                    id = 22042,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "npc",
                    id = 22043,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10569,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "quest",
                    id = 10760,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10759,
                    restrictions = ALLIANCE_RESTRICTIONS,
                },
                {
                    type = "quest",
                    id = 10761,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10777,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10778,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10780,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10782,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10808,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10661,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10678,
    },
    items = {
        {
            type = "npc",
            id = 21777,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10661,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10677,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10678,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10562, 11044, 49550, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10744,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11044,
                    restrictions = {
                        type = "quest",
                        id = 11044,
                        status = {'active', 'completed'},
                    },
                },
                {
                    type = "quest",
                    id = 49550,
                    restrictions = {
                        type = "quest",
                        id = 49550,
                        status = {'active', 'completed'},
                    },
                },
                {
                    type = "npc",
                    id = 21357,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10562,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10563,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10572,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10564,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10573,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10582,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10583,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10585,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10586,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10589,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10766,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10606,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10612,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10744,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10772,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10776,
    },
    items = {
        {
            type = "npc",
            id = 21773,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10772,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10773,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10774,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10775,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10776,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10660,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10673,
    },
    items = {
        {
            type = "npc",
            id = 21770,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10660,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10672,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10673,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10595, 11048, 49532, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10745,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11048,
                    restrictions = {
                        type = "quest",
                        id = 11048,
                        status = {'active', 'completed'},
                    },
                },
                {
                    type = "quest",
                    id = 49532,
                    restrictions = {
                        type = "quest",
                        id = 49532,
                        status = {'active', 'completed'},
                    },
                },
                {
                    type = "npc",
                    id = 21359,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10595,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10596,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10597,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10598,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10599,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10600,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10601,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10602,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10603,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10604,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10767,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10611,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10613,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10745,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10750,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10769,
    },
    items = {
        {
            type = "npc",
            id = 21769,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10750,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10751,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10765,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10768,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10769,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheCipherOfDamnation,
            upto = 10519,
        },
    },
    active = {
        type = "quest",
        id = 10521,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10523,
    },
    items = {
        {
            type = "quest",
            id = 10521,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10522,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10523,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheCipherOfDamnation,
            upto = 10519,
        },
    },
    active = {
        type = "quest",
        id = 10527,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10541,
    },
    items = {
        {
            type = "quest",
            id = 10527,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10528,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10537,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10540,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10541,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheCipherOfDamnation,
            upto = 10519,
        },
    },
    active = {
        type = "quest",
        id = 10546,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10579,
    },
    items = {
        {
            type = "quest",
            id = 10546,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10547,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10550,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10570,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10576,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10577,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10578,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10579,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10703,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10703,
    },
    items = {
        {
            type = "npc",
            id = 21773,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10703,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10793,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10781,
    },
    items = {
        {
            type = "kill",
            id = 21979,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10793,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10781,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10648,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10648,
    },
    items = {
        {
            type = "object",
            id = 184946,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10648,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10702,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10702,
    },
    items = {
        {
            type = "npc",
            id = 21769,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10702,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain14, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10647,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10647,
    },
    items = {
        {
            type = "object",
            id = 184945,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10647,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10619,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10816,
    },
    items = {
        {
            type = "npc",
            id = 21822,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10619,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10816,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10807,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10817,
    },
    items = {
        {
            type = "npc",
            id = 21953,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10807,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10817,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10451,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10451,
    },
    rewards = {
        {
            type = "experience",
            amount = 15800,
        },
        {
            type = "money",
            amount = 132000,
        },
    },
    items = {
        {
            type = "kill",
            id = 20795,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10451,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TempChain01, {
    name = "10871",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 10871,
    },
    items = {
        {
            type = "quest",
            id = 10872,
            x = 0,
            connections = {
                1, 
            },
            comment = "Different version of the end of the netherwing ledge quest line, Removed?",
        },
        {
            type = "quest",
            id = 10871,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain05, {
    name = "10958",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 10958,
    },
    items = {
        {
            type = "chain",
            id = Chain.AkamasPromiseAldor,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10944,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            name = "...",
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10949,
            x = 0,
            connections = {
                1, 
            },
            comment = "BT Attunement?",
        },
        {
            type = "quest",
            id = 10985,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13429,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10958,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain06, {
    name = "11055",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11055,
    },
    items = {
        {
            type = "quest",
            id = 11054,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge related",
        },
        {
            type = "quest",
            id = 11055,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain07, {
    name = "11108",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11108,
    },
    items = {
        {
            type = "quest",
            id = 11107,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge related",
        },
        {
            type = "quest",
            id = 11108,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain08, {
    name = "11095",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11095,
    },
    items = {
        {
            type = "quest",
            id = 11094,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge scryers?",
        },
        {
            type = "quest",
            id = 11095,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain09, {
    name = "11082",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11082,
    },
    items = {
        {
            type = "quest",
            id = 11081,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge related",
        },
        {
            type = "quest",
            id = 11082,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain12, {
    name = "11076",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11076,
    },
    items = {
        {
            type = "quest",
            id = 11075,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge related",
        },
        {
            type = "quest",
            id = 11076,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain13, {
    name = "11090",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11090,
    },
    items = {
        {
            type = "quest",
            id = 11089,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge related",
        },
        {
            type = "quest",
            id = 11090,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain14, {
    name = "11100",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11100,
    },
    items = {
        {
            type = "quest",
            id = 11099,
            x = 0,
            connections = {
                1, 
            },
            comment = "Netherwing ledge Aldor?",
        },
        {
            type = "quest",
            id = 11100,
            x = 0,
        },
    },
})

Database:AddChain(Chain.OthersChain, {
    name = "Others",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
        { -- Removed?
            type = "quest",
            id = 10815,
        },
        { -- Repeatable Scyers Sunfury Signets
            type = "quest",
            id = 10823,
        },
        { -- Scyers Sunfury Signets
            type = "quest",
            id = 10824,
        },
        { -- Aldor Marks of Sargeras
            type = "quest",
            id = 10826,
        },
        { -- Repeatable Aldor 10 Marks of Sargeras
            type = "quest",
            id = 10827,
        },
        { -- Repeatable Aldor Single Marks of Sargeras
            type = "quest",
            id = 10828,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11015,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11016,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11017,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11018,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11020,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11035,
        },
        { -- Alliance, Breadcrumb to the gryphon vendor in SMV, doesnt really fit anywhere
            type = "quest",
            id = 11043,
        },
        { -- Horde, Breadcrumb to the gryphon vendor in SMV, doesnt really fit anywhere
            type = "quest",
            id = 11047,
        },
        { -- Netherwing related
            type = "quest",
            id = 11049,
        },
        { -- Netherwing related
            type = "quest",
            id = 11050,
        },
        { -- Netherwing related
            type = "quest",
            id = 11053,
        },
        { -- Netherwing related
            type = "quest",
            id = 11063,
        },
        { -- Netherwing related, Alliance?
            type = "quest",
            id = 11064,
        },
        { -- Netherwing related, Alliance?
            type = "quest",
            id = 11067,
        },
        { -- Netherwing related, Alliance?
            type = "quest",
            id = 11068,
        },
        { -- Netherwing related, Alliance?
            type = "quest",
            id = 11069,
        },
        { -- Netherwing related, Alliance?
            type = "quest",
            id = 11070,
        },
        { -- Netherwing related
            type = "quest",
            id = 11071,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11077,
        },
        { -- Netherwing related
            type = "quest",
            id = 11083,
        },
        { -- Netherwing related
            type = "quest",
            id = 11084,
        },
        { -- Netherwing Daily
            type = "quest",
            id = 11086,
        },
        { -- Netherwing related
            type = "quest",
            id = 11092,
        },
        { -- Netherwing Daily, Scyers?
            type = "quest",
            id = 11097,
        },
        { -- Netherwing Daily, Aldor?
            type = "quest",
            id = 11101,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11109,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11110,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11111,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11112,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11113,
        },
        { -- Netherwing Drake quests, requires exalted and [Lord Illidan Stormrage] quest?
            type = "quest",
            id = 11114,
        },
        { -- Unlock flying quest, alliance
            type = "quest",
            id = 11497,
        },
        { -- Unlock flying quest, horde
            type = "quest",
            id = 11498,
        },
        { -- Shattered Sun Offensive daily
            type = "quest",
            id = 11544,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-ShadowmoonValley]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.WildhammerStronghold,
        },
        {
            type = "chain",
            id = Chain.ShadowmoonVillage,
        },
        {
            type = "chain",
            id = Chain.NetherwingLedge,
        },
        {
            type = "chain",
            id = Chain.TheFirstDeathKnightAlliance,
        },
        {
            type = "chain",
            id = Chain.TheFirstDeathKnightHorde,
        },
        {
            type = "chain",
            id = Chain.BorrowedPower,
        },
        {
            type = "chain",
            id = Chain.BorrowedPowerAldor,
        },
        {
            type = "chain",
            id = Chain.BorrowedPowerScryers,
        },
        {
            type = "chain",
            id = Chain.AkamasPromise,
        },
        {
            type = "chain",
            id = Chain.AkamasPromiseAldor,
        },
        {
            type = "chain",
            id = Chain.AkamasPromiseScryers,
        },
        {
            type = "chain",
            id = Chain.TheCipherOfDamnation,
        },
        {
            type = "chain",
            id = Chain.AntiDemonWeapons,
        },
        {
            type = "chain",
            id = Chain.TheDarkConclave,
        },
    },
})

Database:AddExpansionItem(EXPANSION_ID, {
    type = "category",
    id = CATEGORY_ID,
})

Database:AddMapRecursive(MAP_ID, {
    type = "category",
    id = CATEGORY_ID,
})

if not C_QuestLine then
    Database:AddContinentItems(CONTINENT_ID, {
        {
            type = "chain",
            id = Chain.NetherwingLedge,
        },
        {
            type = "chain",
            id = Chain.TheFirstDeathKnightAlliance,
        },
        {
            type = "chain",
            id = Chain.TheFirstDeathKnightHorde,
        },
        {
            type = "chain",
            id = Chain.BorrowedPowerAldor,
        },
        {
            type = "chain",
            id = Chain.BorrowedPowerScryers,
        },
        {
            type = "chain",
            id = Chain.AkamasPromiseAldor,
        },
        {
            type = "chain",
            id = Chain.AkamasPromiseScryers,
        },
        {
            type = "chain",
            id = Chain.TheCipherOfDamnation,
        },
        {
            type = "chain",
            id = Chain.AntiDemonWeapons,
        },
        {
            type = "chain",
            id = Chain.TheDarkConclave,
        },

        {
            type = "chain",
            id = Chain.EmbedChain01,
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
        },
        {
            type = "chain",
            id = Chain.Chain01,
        },
    })
end
