local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.Nagrand;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.Nagrand;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1951
local CONTINENT_ID = 1945
local LEVEL_RANGE = {15, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 64,
    },
}

Chain.TheAdventuresOfCorki = 20401
Chain.BirthOfAWarchief = 20402

Chain.TheRingOfBlood = 20403
Chain.ThroneOfTheElements = 20404

Chain.LantresorOfTheBladeAlliance = 20405
Chain.LantresorOfTheBladeHorde = 20406

Chain.TheMurkbloodAlliance = 20407
Chain.TheMurkbloodHorde = 20408

Chain.ThreatsToNagrandAlliance = 20409
Chain.ThreatsToNagrandHorde = 20410

Chain.TheUltimateBloodsport = 20411
Chain.EncounteringTheEthereals = 20412

Chain.EmbedChain01 = 20421
Chain.EmbedChain02 = 20422
Chain.EmbedChain03 = 20423

Chain.EmbedChain04 = 20424
Chain.EmbedChain05 = 20425

Chain.EmbedChain06 = 20426
Chain.EmbedChain07 = 20427

Chain.EmbedChain08 = 20428
Chain.EmbedChain09 = 20429
Chain.EmbedChain10 = 20430

Chain.EmbedChain11 = 20431
Chain.EmbedChain12 = 20432
Chain.EmbedChain13 = 20433

Chain.EmbedChain14 = 20453
Chain.EmbedChain15 = 20464
Chain.EmbedChain16 = 20465
Chain.EmbedChain17 = 20469
Chain.EmbedChain18 = 20459
Chain.EmbedChain19 = 20460
Chain.EmbedChain20 = 20461

Chain.Chain01 = 20470
Chain.Chain02 = 20471
Chain.Chain03 = 20468
Chain.Chain04 = 20452

Chain.EmbedChain21 = 20462
Chain.EmbedChain22 = 20455
Chain.EmbedChain23 = 20457
Chain.EmbedChain24 = 20458
Chain.EmbedChain25 = 20463
Chain.EmbedChain26 = 20466
Chain.EmbedChain27 = 20451
Chain.EmbedChain28 = 20467

Chain.TempChain06 = 20456

Database:AddChain(Chain.TheAdventuresOfCorki, {
    name = L["THE_ADVENTURES_OF_CORKI"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.BirthOfAWarchief
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 64,
        },
        {
            type = "reputation",
            id = 978,
            standing = 4,
        },
    },
    active = {
        type = "quest",
        id = 9923,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9955,
    },
    rewards = {
        {
            type = "experience",
            amount = 48550,
        },
        {
            type = "money",
            amounts = {
                173000, 179000, 185000, 195000, 205000, 220000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 978,
            amount = 1100,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 18369,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9923,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9924,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9954,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9955,
            x = 0,
        },
    },
})
Database:AddChain(Chain.BirthOfAWarchief, {
    name = L["BIRTH_OF_A_WARCHIEF"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheAdventuresOfCorki
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 66,
        },
        {
            type = "chain",
            id = Chain.LantresorOfTheBladeHorde,
        },
        {
            type = "chain",
            id = Chain.ThreatsToNagrandAlliance,
            upto = 10011,
        },
        {
            type = "chain",
            id = Chain.TheMurkbloodHorde,
            upto = 9868,
        },
    },
    active = {
        type = "quest",
        id = 10044,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10172,
    },
    rewards = {
        {
            type = "experience",
            amount = 109750,
        },
        {
            type = "reputation",
            id = 935,
            amount = 1200,
        },
        {
            type = "reputation",
            id = 941,
            amount = 2130,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 18063,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10044,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10045,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10081,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10082,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10085,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10101,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10102,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10167,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10168,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10170,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10171,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10172,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TheRingOfBlood, {
    name = L["THE_RING_OF_BLOOD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        id = 9962,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9977,
    },
    rewards = {
        {
            type = "experience",
            amount = 105200,
        },
        {
            type = "money",
            amounts = {
                672000, 702000, 738000, 792000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 18471,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9962,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9967,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9970,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9972,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9973,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9977,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ThroneOfTheElements, {
    name = L["THRONE_OF_THE_ELEMENTS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9815, 9800, 9818, 9861},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9862, 9810, 9853},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 136100,
        },
        {
            type = "money",
            amounts = {
                70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            embed = true,
            x = 1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
            x = 3,
        },
    },
})

Database:AddChain(Chain.LantresorOfTheBladeAlliance, {
    name = L["LANTRESOR_OF_THE_BLADE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.LantresorOfTheBladeHorde
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9917,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9933,
    },
    rewards = {
        {
            type = "experience",
            amount = 115050,
        },
        {
            type = "money",
            amounts = {
                315000, 333000, 351000, 369000, 396000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 978,
            amount = 1860,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 18353,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9917,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9918,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9920,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9921,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9922,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10108,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9928,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 9927,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9931,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9932,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9933,
            x = 0,
        },
    },
})
Database:AddChain(Chain.LantresorOfTheBladeHorde, {
    name = L["LANTRESOR_OF_THE_BLADE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.LantresorOfTheBladeAlliance
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9888,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9934,
    },
    rewards = {
        {
            type = "experience",
            amount = 132850,
        },
        {
            type = "money",
            amounts = {
                315000, 333000, 351000, 369000, 396000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 941,
            amount = 2610,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 18106,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9888,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9889,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9890,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9891,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 9906,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
            aside = true,
        },
        {
            type = "quest",
            id = 9907,
            x = -1,
            y = 6,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10107,
            x = 0,
            y = 7,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9928,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 9927,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9931,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9932,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9934,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TheMurkbloodAlliance, {
    name = L["THE_MURKBLOOD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheMurkbloodHorde
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9871, 9879},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9879, 9873},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 61200,
        },
        {
            type = "reputation",
            id = 978,
            amount = 1350,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain23,
            embed = true,
            aside = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
            embed = true,
            aside = true,
        },
    },
})
Database:AddChain(Chain.TheMurkbloodHorde, {
    name = L["THE_MURKBLOOD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheMurkbloodAlliance
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 64,
        },
        {
            type = "reputation",
            id = 941,
            x = 0,
            connections = {
                1, 2, 
            },
            standing = 4,
        },
    },
    active = {
        type = "quest",
        ids = {9864, 9868},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9866, 9868},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 58250,
        },
        {
            type = "reputation",
            id = 941,
            amount = 1200,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
            aside = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
            aside = true,
        },
    },
})

Database:AddChain(Chain.ThreatsToNagrandAlliance, {
    name = L["THREATS_TO_NAGRAND"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.ThreatsToNagrandHorde
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9936, 9940, 9982, 9983, 9991},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9938, 10011},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 115050,
        },
        {
            type = "money",
            amounts = {
                442000, 452000, 468000, 492000, 528000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 978,
            amount = 850,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = 2,
        },
    },
})
Database:AddChain(Chain.ThreatsToNagrandHorde, {
    name = L["THREATS_TO_NAGRAND"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.ThreatsToNagrandAlliance
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9935, 9939, 9982, 9983, 9991},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9937, 10011},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 115050,
        },
        {
            type = "money",
            amounts = {
                442000, 452000, 468000, 492000, 528000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 941,
            amount = 850,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = 2,
        },
    },
})

Database:AddChain(Chain.TheUltimateBloodsport, {
    name = L["THE_ULTIMATE_BLOODSPORT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9789, 9854, 9857, 10113, 10114, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9852,
    },
    rewards = {
        {
            type = "experience",
            amount = 129200,
        },
        {
            type = "money",
            amounts = {
                545000, 549000, 561000, 585000, 615000, 660000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            embed = true,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            embed = true,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9852,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EncounteringTheEthereals, {
    name = L["ENCOUNTERING_THE_ETHEREALS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9900, 9925},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {
            9900, 9925, 
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 57200,
        },
        {
            type = "money",
            amounts = {
                182800, 188800, 199000, 209200, 224400, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 933,
            amount = 2000,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain17,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            aside = true,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            aside = true,
            embed = true,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9800, 9815, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9810,
    },
    items = {
        {
            type = "npc",
            id = 18073,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9815,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 9800,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9804,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9805,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9810,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9818,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9853,
    },
    items = {
        {
            type = "npc",
            id = 18071,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9818,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9819,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9821,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9849,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9853,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9861,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9862,
    },
    items = {
        {
            type = "kill",
            id = 17158,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9861,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9862,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9871,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9873,
    },
    items = {
        {
            type = "kill",
            id = 18238,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9871,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9873,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9879,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9879,
    },
    items = {
        {
            type = "npc",
            id = 18209,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9879,
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
        {
            type = "level",
            level = 64,
        },
        {
            type = "reputation",
            id = 941,
            standing = 4,
        },
    },
    active = {
        type = "quest",
        id = 9864,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9866,
    },
    items = {
        {
            type = "npc",
            id = 18067,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9864,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9865,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9866,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 64,
        },
        {
            type = "reputation",
            id = 941,
            standing = 4,
        },
    },
    active = {
        type = "quest",
        id = 9868,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9868,
    },
    items = {
        {
            type = "npc",
            id = 18210,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9868,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9936, 9940, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9938,
    },
    items = {
        {
            type = "object",
            id = 182393,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9936,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9940,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9938,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 66,
    },
    active = {
        type = "quest",
        ids = {
            9982, 9983, 9991, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10011,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9982,
                    restrictions = {
                        type = "quest",
                        id = 9982,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 9983,
                    restrictions = {
                        type = "quest",
                        id = 9983,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 18417,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9991,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9999,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10001,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10004,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10009,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10010,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10011,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9935, 9939, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9937,
    },
    items = {
        {
            type = "object",
            id = 182392,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9935,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9939,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9937,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9854, 10114, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9856,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10114,
                    restrictions = {
                        type = "quest",
                        id = 10114,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 18200,
                }
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9854,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9855,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9856,
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
        ids = {
            9789, 10113, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9851,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10113,
                    restrictions = {
                        type = "quest",
                        id = 10113,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 18180,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9789,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9850,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9851,
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
        id = 9857,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9859,
    },
    items = {
        {
            type = "npc",
            id = 18218,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9857,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9858,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9859,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain14, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 64,
        },
        {
            type = "chain",
            id = Chain.LantresorOfTheBladeHorde,
            upto = 9891,
        }
    },
    active = {
        type = "quest",
        id = 9910,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9916,
    },
    items = {
        {
            type = "quest",
            id = 9910,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9916,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9867,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9867,
    },
    items = {
        {
            type = "npc",
            id = 18068,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9867,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9872,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9872,
    },
    items = {
        {
            type = "kill",
            id = 18238,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9872,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain17, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9900, 9925},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {
            9900, 9925, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 18276,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9900,
            x = -1,
        },
        {
            type = "quest",
            id = 9925,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9913, 9882},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9882,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9913,
                    restrictions = {
                        type = "quest",
                        id = 9913,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 18265,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9882,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9883,
            aside = true,
            active = {
                type = "quest",
                id = 9882,
            },
            completed = {
                type = "reputation",
                id = 933,
                standing = 5,
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9914,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9914,
    },
    items = {
        {
            type = "npc",
            id = 18333,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9914,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9915,
            aside = true,
            active = {
                type = "quest",
                id = 9914,
            },
            completed = {
                type = "reputation",
                id = 933,
                standing = 5,
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 64,
    },
    active = {
        type = "quest",
        id = 9893,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9893,
    },
    items = {
        {
            type = "reputation",
            id = 933,
            x = 0,
            connections = {
                1, 
            },
            standing = 5,
        },
        {
            type = "npc",
            id = 18265,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9893,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9892,
            aside = true,
            active = {
                type = "quest",
                id = 9893,
            },
            completed = {
                {
                    type = "quest",
                    id = 9893,
                },
                {
                    type = "reputation",
                    id = 933,
                    standing = 8,
                },
            },
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = BtWQuests_GetAreaName(3626), -- Telaar
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        ids = {9956, 39197, 10476},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {9956, 10476},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 23300,
        },
        {
            type = "money",
            amounts = {
                37000, 39000, 41000, 44000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 978,
            amount = 850,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain21,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = BtWQuests_GetAreaName(3613), -- Garadar
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9863, 10479},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {9863, 10479},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 22950,
        },
        {
            type = "reputation",
            id = 941,
            amount = 750,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain25,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = BtWQuests_GetAreaName(3672), -- Mag'hari Procession
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        ids = {9944, 9945, 9948},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {9946, 9948},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 37900,
        },
        {
            type = "money",
            amounts = {
                148000, 156000, 164000, 176000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 941,
            amount = 950,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain27,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Bring Me The Egg!
        type = "quest",
        id = 10111,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10109,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 10111,
    },
    rewards = {
        {
            type = "experience",
            amount = 25450,
        },
        {
            type = "money",
            amounts = {
                105000, 111000, 117000, 123000, 132000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 19035,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10109,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10111,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain21, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        id = 9956,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9956,
    },
    items = {
        {
            type = "npc",
            id = 18416,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9956,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        ids = {39197, 10476},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 10476,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39197,
                    restrictions = {
                        type = "quest",
                        id = 39197,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 18408,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10476,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10477,
            aside = true,
            active = {
                type = "quest",
                id = 10477,
            },
            completed = {
                {
                    type = "quest",
                    id = 10477,
                },
                {
                    type = "reputation",
                    id = 978,
                    standing = 8,
                },
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9874,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9874,
    },
    items = {
        {
            type = "npc",
            id = 18222,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9874,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9878,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9878,
    },
    items = {
        {
            type = "npc",
            id = 18224,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9878,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9863,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9863,
    },
    items = {
        {
            type = "npc",
            id = 18066,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9863,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        id = 10479,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 10479,
    },
    items = {
        {
            type = "npc",
            id = 18407,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10479,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10478,
            aside = true,
            active = {
                type = "quest",
                id = 10479,
            },
            completed = {
                {
                    type = "quest",
                    id = 10479,
                },
                {
                    type = "reputation",
                    id = 941,
                    standing = 8,
                },
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        ids = {9944, 9945},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9946,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9944,
                    restrictions = {
                        type = "quest",
                        id = 9944,
                        status = { "active", "compelted", },
                    },
                },
                {
                    type = "npc",
                    id = 18414,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9945,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9946,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain28, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 65,
    },
    active = {
        type = "quest",
        id = 9948,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 9948,
    },
    items = {
        {
            type = "npc",
            id = 18415,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9948,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TempChain06, {
    name = "Others",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
        { -- Breadcrumb to Talaar but doesnt directly lead to a quest
            type = "quest",
            id = 9792,
        },
        { -- Breadcrumb to Garadar but doesnt directly lead to a quest
            type = "quest",
            id = 9797,
        },
        { -- Breadcrumb that doesnt really fit anywhere
            type = "quest",
            id = 9869,
        },
        { -- Breadcrumb that doesnt really fit anywhere
            type = "quest",
            id = 9870,
        },
        { -- Membership Benefits
            type = "quest",
            id = 9884,
        },
        { -- Membership Benefits
            type = "quest",
            id = 9885,
        },
        { -- Membership Benefits
            type = "quest",
            id = 9886,
        },
        { -- Membership Benefits
            type = "quest",
            id = 9887,
        },
        { -- Kind of a strange quest, not sure what to do with it
            type = "quest",
            id = 9897,
        },
        { -- Halaa daily, Horde
            type = "quest",
            id = 10074,
        },
        { -- Halaa daily, Horde
            type = "quest",
            id = 10075,
        },
        { -- Halaa daily, Alliance
            type = "quest",
            id = 10076,
        },
        { -- Halaa daily, Alliance
            type = "quest",
            id = 10077,
        },
        { -- Maybe not available?
            type = "quest",
            id = 10375,
        },
        { -- Halaa daily, Alliance
            type = "quest",
            id = 11502,
        },
        { -- Halaa daily, Horde
            type = "quest",
            id = 11503,
        },
        { -- Daily starting from Shattrath
            type = "quest",
            id = 11880,
        },
        { -- Warchief's Command: Nagrand!
            type = "quest",
            id = 39189,
        },
        { -- Warchief's Command: Nagrand!
            type = "quest",
            id = 39196,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-Nagrand]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.TheAdventuresOfCorki,
        },
        {
            type = "chain",
            id = Chain.BirthOfAWarchief,
        },

        {
            type = "chain",
            id = Chain.TheRingOfBlood,
        },
        {
            type = "chain",
            id = Chain.ThroneOfTheElements,
        },

        {
            type = "chain",
            id = Chain.LantresorOfTheBladeAlliance,
        },
        {
            type = "chain",
            id = Chain.LantresorOfTheBladeHorde,
        },

        {
            type = "chain",
            id = Chain.TheMurkbloodAlliance,
        },
        {
            type = "chain",
            id = Chain.TheMurkbloodHorde,
        },

        {
            type = "chain",
            id = Chain.ThreatsToNagrandAlliance,
        },
        {
            type = "chain",
            id = Chain.ThreatsToNagrandHorde,
        },

        {
            type = "chain",
            id = Chain.TheUltimateBloodsport,
        },
        {
            type = "chain",
            id = Chain.EncounteringTheEthereals,
        },

        {
            type = "chain",
            id = Chain.Chain01,
        },
        {
            type = "chain",
            id = Chain.Chain02,
        },
        {
            type = "chain",
            id = Chain.Chain03,
        },
        {
            type = "chain",
            id = Chain.Chain04,
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
            id = Chain.TheAdventuresOfCorki,
        },
        {
            type = "chain",
            id = Chain.BirthOfAWarchief,
        },
        {
            type = "chain",
            id = Chain.TheRingOfBlood,
        },
        {
            type = "chain",
            id = Chain.LantresorOfTheBladeAlliance,
        },
        {
            type = "chain",
            id = Chain.LantresorOfTheBladeHorde,
        },
        {
            type = "chain",
            id = Chain.EncounteringTheEthereals,
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
            id = Chain.EmbedChain17,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
        },
        {
            type = "chain",
            id = Chain.Chain04,
        },
        {
            type = "chain",
            id = Chain.EmbedChain21,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
        },
    })
end
