-- AUTO GENERATED - NEEDS UPDATING

local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.GrizzlyHills
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.GrizzlyHills
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 116
local CONTINENT_ID = 113
local ACHIEVEMENT_ID_ALLIANCE = 37
local ACHIEVEMENT_ID_HORDE = 1357
local LEVEL_RANGE = {15, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 73,
    },
}

Chain.UrsocTheBearGodAlliance = 30401
Chain.UrsocTheBearGodHorde = 30402
Chain.TheIronThaneAlliance = 30403
Chain.TheFinalShowdown = 30404
Chain.LokensOrdersAlliance = 30405
Chain.TheIronThaneHorde = 30406
Chain.Revelation = 30407
Chain.LokensOrdersHorde = 30408
Chain.HourOfTheWorg = 30409
Chain.EonsOfMisery = 30410

Chain.Chain01 = 30411
Chain.Chain02 = 30412
Chain.Chain03 = 30413
Chain.Chain04 = 30414
Chain.Chain05 = 30415

Chain.EmbedChain01 = 30421
Chain.EmbedChain02 = 30422
Chain.EmbedChain03 = 30423
Chain.EmbedChain04 = 30424
Chain.EmbedChain05 = 30425
Chain.EmbedChain06 = 30426
Chain.EmbedChain07 = 30427
Chain.EmbedChain08 = 30428
Chain.EmbedChain09 = 30429
Chain.EmbedChain10 = 30430
Chain.EmbedChain11 = 30431

Chain.OtherAlliance = 30497
Chain.OtherHorde = 30498
Chain.OtherBoth = 30499

Database:AddChain(Chain.UrsocTheBearGodAlliance, {
    name = L["URSOC_THE_BEAR_GOD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12292, 12307, 12511, 39207, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12249,
    },
    rewards = {
        {
            type = "experience",
            amount = 353200,
        },
        {
            type = "money",
            amount = 442000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 3375,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 400,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39207,
                    restrictions = {
                        type = "quest",
                        id = 39207,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12511,
                    restrictions = {
                        type = "quest",
                        id = 12511,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26875,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain01,
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "quest",
            id = 12292,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12293,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12294,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12295,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 27545,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12299,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12307,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12300,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12302,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12308,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12310,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12219,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12220,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12246,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12247,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12248,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12250,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12249,
            x = 0,
        },
    },
})
Database:AddChain(Chain.UrsocTheBearGodHorde, {
    name = L["URSOC_THE_BEAR_GOD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12468, 12487, 39206, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12236,
    },
    rewards = {
        {
            type = "experience",
            amount = 301750,
        },
        {
            type = "money",
            amount = 389000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 3400,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39206,
                    restrictions = {
                        type = "quest",
                        id = 39206,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12487,
                    restrictions = {
                        type = "quest",
                        id = 12487,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26860,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12468,
            x = 0,
            connections = {
                2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 12257,
            x = -1,
            y = 2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12256,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12259,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12412,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12413,
            x = 0,
            connections = {
                2, 3, 4, 
            },
        },
        {
            visible = false,
            x = -3,
        },
        {
            type = "quest",
            id = 12207,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 12213,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12453,
            aside = true,
        },
        {
            type = "quest",
            id = 12229,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12231,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12241,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12242,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12236,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheIronThaneAlliance, {
    name = L["THE_IRON_THANE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11998,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12153,
    },
    rewards = {
        {
            type = "experience",
            amount = 342350,
        },
        {
            type = "money",
            amount = 869000,
        },
    },
    items = {
        {
            type = "npc",
            id = 26212,
            x = 0,
            connections = {
                3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            aside = true,
            embed = true,
            x = -2,
            y = 1,
        },
        {
            type = "quest",
            id = 11998,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12002,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 12003,
            x = 0,
            y = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12010,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12014,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12128,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12129,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12130,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12131,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12138,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12153,
            x = -1,
        },
        {
            type = "quest",
            id = 12154,
            aside = true,
        },
    },
})
Database:AddChain(Chain.TheFinalShowdown, {
    name = L["THE_FINAL_SHOWDOWN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 73,
        },
        {
            type = "chain",
            id = Chain.Chain01,
        },
        {
            type = "chain",
            id = Chain.UrsocTheBearGodHorde,
            upto = 12413,
        },
    },
    active = {
        type = "quest",
        id = 12427,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12431,
    },
    rewards = {
        {
            type = "experience",
            amount = 140750,
        },
        {
            type = "money",
            amount = 802000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 500,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 27719,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12427,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12428,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12429,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12430,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12431,
            x = 0,
        },
    },
})
Database:AddChain(Chain.LokensOrdersAlliance, {
    name = L["LOKENS_ORDERS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 73,
        },
        {
            type = "chain",
            id = Chain.TheIronThaneAlliance,
            upto = 12014,
        },
    },
    active = {
        type = "quest",
        id = 12180,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12185,
    },
    rewards = {
        {
            type = "experience",
            amount = 83800,
        },
        {
            type = "money",
            amount = 236000,
        },
    },
    items = {
        {
            type = "quest",
            id = 12180,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12183,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12184,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12185,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheIronThaneHorde, {
    name = L["THE_IRON_THANE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12195,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12199,
    },
    rewards = {
        {
            type = "experience",
            amount = 151900,
        },
        {
            type = "money",
            amount = 472000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 1850,
            restrictions = 923,
        },
    },
    items = {
        {
            visible = false,
            x = -2,
        },
        {
            type = "npc",
            id = 27221,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "quest",
            id = 12195,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12165,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12196,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12197,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12198,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12199,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Revelation, {
    name = L["REVELATION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11984, 12208, 12210, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12068,
    },
    rewards = {
        {
            type = "experience",
            amount = 223350,
        },
        {
            type = "money",
            amount = 412400,
        },
    },
    items = {
        {
            visible = false,
            x = -2,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12208,
                    restrictions = {
                        type = "quest",
                        id = 12208,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12210,
                    restrictions = {
                        type = "quest",
                        id = 12210,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26424,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11984,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11989,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11990,
            x = 0,
            connections = {
                1.2, 2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11991,
            x = 0,
            y = 4,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12007,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12042,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12802,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12068,
            x = 0,
        },
    },
})
Database:AddChain(Chain.LokensOrdersHorde, {
    name = L["LOKENS_ORDERS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12026,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12203,
    },
    rewards = {
        {
            type = "experience",
            amount = 162350,
        },
        {
            type = "money",
            amount = 459000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 750,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 250,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "object",
            id = 188261,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12026,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12054,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12058,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12073,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12204,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12201,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12202,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12203,
            x = 0,
        },
    },
})
Database:AddChain(Chain.HourOfTheWorg, {
    name = L["HOUR_OF_THE_WORG"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {12105, 12423},
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12164,
    },
    rewards = {
        {
            type = "experience",
            amount = 115300,
        },
        {
            type = "money",
            amount = 236000,
        },
    },
    items = {
        {
            type = "chain",
            ids = {
                Chain.EmbedChain08, Chain.EmbedChain09, 
            },
            embed = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12328,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12327,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12329,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12134,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12330,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12411,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12164,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EonsOfMisery, {
    name = L["EONS_OF_MISERY"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12116,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12152,
    },
    rewards = {
        {
            type = "experience",
            amount = 172850,
        },
        {
            type = "money",
            amount = 472000,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
            x = -3,
        },
        {
            type = "npc",
            id = 26886,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "quest",
            id = 12116,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12120,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12121,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12137,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12152,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Delivery to Krenna
        type = "quest",
        id = 12178,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12175,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12178,
    },
    rewards = {
        {
            type = "experience",
            amount = 62300,
        },
        {
            type = "money",
            amount = 56000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 650,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 27037,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12175,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12176,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12177,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12178,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Replenishing the Storehouse
        type = "quest",
        id = 12212,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = { 12212, 12215, },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12217, 12215, },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 77800,
        },
        {
            type = "money",
            amount = 212000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 900,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 27277,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12212,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12215,
        },
        {
            type = "quest",
            id = 12216,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12217,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = BtWQuests_GetAreaName(4207), -- Voldrune
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 73,
        },
        {
            type = "chain",
            id = Chain.UrsocTheBearGodAlliance,
            upto = 12294,
        },
    },
    active = {
        type = "quest",
        ids = { 12222, 12223, },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12255,
    },
    rewards = {
        {
            type = "experience",
            amount = 62250,
        },
        {
            type = "money",
            amount = 168000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 27391,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12222,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12223,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12255,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Free at Last
        type = "quest",
        id = 12099,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 72,
        },
    },
    active = {
        type = "quest",
        ids = { 12074, 11981, 11982, },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12099,
    },
    rewards = {
        {
            type = "experience",
            amount = 133050,
        },
        {
            type = "money",
            amount = 413000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12074,
                    restrictions = {
                        type = "quest",
                        id = 12074,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 11981,
                    restrictions = {
                        type = "quest",
                        id = 11981,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26260,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11982,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12070,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11985,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12081,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12093,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12094,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12099,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain05, {
    name = { -- A Bear of an Appetite
        type = "quest",
        id = 12279,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 72,
        },
    },
    active = {
        type = "quest",
        id = 12279,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12279,
    },
    rewards = {
        {
            type = "experience",
            amount = 20950,
        },
        {
            type = "money",
            amount = 59000,
        },
    },
    items = {
        {
            type = "npc",
            id = 26484,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12279,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "object",
            id = 188667,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12225,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12226,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12227,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26868,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12436,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26588,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12027,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "object",
            id = 188261,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11986,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11988,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11993,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26377,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12414,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26944,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12415,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26519,
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12484,
            x = -1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12483,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12029,
        },
        {
            type = "quest",
            id = 12190,
            x = -1,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "item",
            id = 36940,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12105,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12109,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12158,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12159,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12160,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12161,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "item",
            id = 37830,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12423,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12424,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12422,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "npc",
            id = 27102,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12425,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26884,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12113,
            x = -1,
        },
        {
            type = "quest",
            id = 12114,
        },
    },
})
Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
    },
    items = {
        {
            type = "npc",
            id = 26814,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12082,
            x = 0,
        },
    },
})

Database:AddChain(Chain.OtherAlliance, {
    name = "Other Alliance",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
    },
})
Database:AddChain(Chain.OtherHorde, {
    name = "Other Horde",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
    },
})
Database:AddChain(Chain.OtherBoth, {
    name = "Other Both",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
        { -- Seared Scourge, Daily
            type = "quest",
            id = 12038,
        },
        { -- Blackriver Brawl, Daily
            type = "quest",
            id = 12170,
        },
        { -- [Depricated]Sewing Your Seed, Obsolete
            type = "quest",
            id = 12233,
        },
        { -- Shredder Repair, Daily
            type = "quest",
            id = 12244,
        },
        { -- Pieces Parts, Daily
            type = "quest",
            id = 12268,
        },
        { -- Shred the Alliance, Daily
            type = "quest",
            id = 12270,
        },
        { -- Making Repairs, Daily
            type = "quest",
            id = 12280,
        },
        { -- Keep 'Em on Their Heels, Daily
            type = "quest",
            id = 12284,
        },
        { -- Overwhelmed!, Daily
            type = "quest",
            id = 12288,
        },
        { -- Kick 'Em While They're Down, Daily
            type = "quest",
            id = 12289,
        },
        { -- Life or Death, Daily
            type = "quest",
            id = 12296,
        },
        { -- Down With Captain Zorna!, Daily
            type = "quest",
            id = 12314,
        },
        { -- Crush Captain Brightwater!, Daily
            type = "quest",
            id = 12315,
        },
        { -- Keep Them at Bay!, Daily
            type = "quest",
            id = 12316,
        },
        { -- Keep Them at Bay, Daily
            type = "quest",
            id = 12317,
        },
        { -- Smoke 'Em Out, Daily
            type = "quest",
            id = 12323,
        },
        { -- Smoke 'Em Out, Daily
            type = "quest",
            id = 12324,
        },
        { -- Riding the Red Rocket, Daily
            type = "quest",
            id = 12432,
        },
        { -- Seeking Solvent
            type = "quest",
            id = 12433,
        },
        { -- Always Seeking Solvent, Repeatable
            type = "quest",
            id = 12434,
        },
        { -- Riding the Red Rocket, Daily
            type = "quest",
            id = 12437,
        },
        { -- Seeking Solvent
            type = "quest",
            id = 12443,
        },
        { -- Blackriver Skirmish, Daily
            type = "quest",
            id = 12444,
        },
        { -- Always Seeking Solvent, Repeatable
            type = "quest",
            id = 12446,
        },
        { -- Onward to Camp Oneqwah, Doesnt seem to lead to a specific quest
            type = "quest",
            id = 12451,
        },
        { -- Shifting Priorities, Breadcrumb to Zul'Drak?
            type = "quest",
            id = 12763,
        },
        { -- Reallocating Resources, Breadcrumb to Zul'Drak?
            type = "quest",
            id = 12770,
        },
        { -- Glimmerfin Scale, Intro to the murloc mini event?
            type = "quest",
            id = 60605,
        },
        { -- Glimmerfin Welcome, Part of the murloc mini event?
            type = "quest",
            id = 60606,
        },
        { -- A Big Horkin' Task, Part of the murloc mini event?
            type = "quest",
            id = 60614,
        },
        { -- Seer of the Waves, Part of the murloc mini event?
            type = "quest",
            id = 60615,
        },
        { -- Pearl in the Deeps, Part of the murloc mini event?
            type = "quest",
            id = 60616,
        },
        { -- Trainer's Test, Part of the murloc mini event?
            type = "quest",
            id = 60617,
        },
        { -- Wrap it Up, Part of the murloc mini event?
            type = "quest",
            id = 60619,
        },
        { -- Guardian of the Smallest, Part of the murloc mini event?
            type = "quest",
            id = 60620,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-GrizzlyHills]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.UrsocTheBearGodAlliance,
        },
        {
            type = "chain",
            id = Chain.UrsocTheBearGodHorde,
        },
        {
            type = "chain",
            id = Chain.TheIronThaneAlliance,
        },
        {
            type = "chain",
            id = Chain.TheFinalShowdown,
        },
        {
            type = "chain",
            id = Chain.LokensOrdersAlliance,
        },
        {
            type = "chain",
            id = Chain.TheIronThaneHorde,
        },
        {
            type = "chain",
            id = Chain.Revelation,
        },
        {
            type = "chain",
            id = Chain.LokensOrdersHorde,
        },
        {
            type = "chain",
            id = Chain.HourOfTheWorg,
        },
        {
            type = "chain",
            id = Chain.EonsOfMisery,
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
        {
            type = "chain",
            id = Chain.Chain05,
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

Database:AddContinentItems(CONTINENT_ID, {})
