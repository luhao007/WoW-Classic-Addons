local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.Dragonblight
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.Dragonblight
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 115
local CONTINENT_ID = 113
local ACHIEVEMENT_ID_ALLIANCE = 35
local ACHIEVEMENT_ID_HORDE = 1359
local LEVEL_RANGE = {15, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 71,
    },
}

Chain.TheWardensTask = 30301
Chain.TheTaunka = 30302
Chain.RedirectingTheLeyLinesAlliance = 30303
Chain.TraitorsToTheHorde = 30304
Chain.InformingTheQueenAlliance = 30305
Chain.RedirectingTheLeyLinesHorde = 30306
Chain.TheDragonflights = 30307
Chain.ContainingTheRot = 30308
Chain.AngratharTheWrathgateAlliance = 30309
Chain.AngratharTheWrathgateHorde = 30310
Chain.Frostmourne = 30311
Chain.InformingTheQueenHorde = 30312
Chain.StrategicAlliance = 30313
Chain.TheScarletOnslaught = 30314
Chain.Oachanoa = 30315

Chain.Chain01 = 30321
Chain.Chain02 = 30322
Chain.Chain03 = 30323
Chain.Chain04 = 30324
Chain.Chain05 = 30325
Chain.Chain06 = 30326
Chain.Chain07 = 30327

Chain.EmbedChain01 = 30331
Chain.EmbedChain02 = 30332
Chain.EmbedChain03 = 30333
Chain.EmbedChain04 = 30334
Chain.EmbedChain05 = 30335
Chain.EmbedChain06 = 30336
Chain.EmbedChain07 = 30337
Chain.EmbedChain08 = 30338
Chain.EmbedChain09 = 30339
Chain.EmbedChain10 = 30340
Chain.EmbedChain11 = 30341
Chain.EmbedChain12 = 30342
Chain.EmbedChain13 = 30343
Chain.EmbedChain14 = 30344
Chain.EmbedChain15 = 30345
Chain.EmbedChain16 = 30346
Chain.EmbedChain17 = 30347
Chain.EmbedChain18 = 30348
Chain.EmbedChain19 = 30349
Chain.EmbedChain20 = 30350
Chain.EmbedChain21 = 30351

Chain.IgnoreChain01 = 30361

Chain.OtherAlliance = 30397
Chain.OtherHorde = 30398
Chain.OtherBoth = 30399

Database:AddChain(Chain.TheWardensTask, {
    name = L["THE_WARDENS_TASK"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12166,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12169,
    },
    rewards = {
        {
            type = "experience",
            amount = 68050,
        },
        {
            type = "money",
            amount = 200000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 860,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 26973,
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12166,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "item",
            id = 36958,
            breadcrumb = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12167,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12168,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12169,
            x = 1,
        },
    },
})
Database:AddChain(Chain.TheTaunka, {
    name = L["THE_TAUNKA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11979, 11977, 11978, 11980, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12008,
    },
    rewards = {
        {
            type = "experience",
            amount = 71100,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 400,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 800,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11979,
                    restrictions = {
                        type = "quest",
                        id = 11979,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11977,
                    restrictions = {
                        type = "quest",
                        id = 11977,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 26181,
                },
            },
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 26180,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11978,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11980,
            aside = true,
        },
        {
            type = "quest",
            id = 11983,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12008,
            x = 0,
        },
    },
})
Database:AddChain(Chain.RedirectingTheLeyLinesAlliance, {
    name = L["REDIRECTING_THE_LEY_LINES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11995, 12000, 12440, 39204, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12107,
    },
    rewards = {
        {
            type = "experience",
            amount = 249250,
        },
        {
            type = "money",
            amount = 712000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 500,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1090,
            amount = 2025,
            restrictions = 924,
        },
    },
    items = {
        {
            visible = false,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain01,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 11995,
                    restrictions = {
                        type = "quest",
                        id = 11995,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12440,
                    restrictions = {
                        type = "quest",
                        id = 12440,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 39204,
                    restrictions = {
                        type = "quest",
                        id = 39204,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26673,
                },
            },
            x = -1,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12000,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "item",
            id = 36742,
            breadcrumb = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12004,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12055,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12060,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12065,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12067,
            aside = true,
        },
        {
            type = "quest",
            id = 12083,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12092,
            aside = true,
        },
        {
            type = "quest",
            id = 12098,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12107,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TraitorsToTheHorde, {
    name = L["TRAITORS_TO_THE_HORDE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            name = "Unknown",
            type = "quest",
            id = 12036,
        },
    },
    active = {
        type = "quest",
        id = 12057,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12136,
    },
    rewards = {
        {
            type = "experience",
            amount = 140250,
        },
        {
            type = "money",
            amount = 159000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 1860,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "item",
            id = 36744,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12057,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12115,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12125,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12126,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12127,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12132,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12136,
            x = 0,
        },
    },
})
Database:AddChain(Chain.InformingTheQueenAlliance, {
    name = L["INFORMING_THE_QUEEN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.RedirectingTheLeyLinesAlliance,
        }
    },
    active = {
        type = "quest",
        id = 12119,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12123,
    },
    rewards = {
        {
            type = "experience",
            amount = 88500,
        },
        {
            type = "money",
            amount = 250600,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 10,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 1165,
        },
    },
    items = {
        {
            type = "npc",
            id = 26673,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12119,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12766,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12460,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12416,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12417,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "item",
            id = 37833,
            breadcrumb = true,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12418,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12419,
            aside = true,
        },
        {
            type = "quest",
            id = 12768,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12123,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12435,
            aside = true,
            x = 0,
        },
    },
})
Database:AddChain(Chain.RedirectingTheLeyLinesHorde, {
    name = L["REDIRECTING_THE_LEY_LINES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            39203, 11996, 11999, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12110,
    },
    rewards = {
        {
            type = "experience",
            amount = 203300,
        },
        {
            type = "money",
            amount = 556000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 250,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 250,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1090,
            amount = 2025,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39203,
                    restrictions = {
                        type = "quest",
                        id = 39203,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 11996,
                    restrictions = {
                        type = "quest",
                        id = 11996,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26471,
                },
            },
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11999,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "item",
            id = 36746,
            breadcrumb = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12005,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12059,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12061,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12066,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12096,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12084,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12085,
            aside = true,
        },
        {
            type = "quest",
            id = 12106,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12110,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheDragonflights, {
    name = L["THE_DRAGONFLIGHTS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 72,
        },
    },
    active = {
        type = "quest",
        ids = {
            12470, 12447, 12458, 12454, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12266,12459,12456,13343
        },
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amount = 258950,
        },
        {
            type = "money",
            amount = 1067200,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 3670,
        },
    },
    items = {
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
            id = Chain.EmbedChain04,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            embed = true,
        },
    },
})
Database:AddChain(Chain.ContainingTheRot, {
    name = L["CONTAINING_THE_ROT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateHorde,
            upto = 12034
        }
    },
    active = {
        type = "quest",
        id = 12100,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12111,
    },
    rewards = {
        {
            type = "experience",
            amount = 65400,
        },
        {
            type = "money",
            amount = 53000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 770,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 26504,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12100,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12101,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12102,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12104,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12111,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AngratharTheWrathgateAlliance, {
    name = L["ANGRATHAR_THE_WRATHGATE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12174, 12235, 12251, 12275, 12281, 12298, 12312, 12325, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12499,
    },
    rewards = {
        {
            type = "experience",
            amount = 522050,
        },
        {
            type = "money",
            amount = 106000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 6155,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 360,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12174,
                    restrictions = {
                        type = "quest",
                        id = 12174,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12298,
                    restrictions = {
                        type = "quest",
                        id = 12298,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 27136,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12235,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12237,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12251,
            x = 0,
            connections = {
                1, 2, 5.3, 
            },
        },
        {
            type = "quest",
            id = 12253,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12258,
            aside = true,
        },
        {
            type = "quest",
            id = 12309,
            x = 0,
            connections = {
                1, 3.2, 
            },
        },
        {
            type = "quest",
            id = 12311,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            embed = true,
            x = -2,
            y = 3,
            connections = {
                [4] = {
                    2, 
                }, [7] = {
                    2, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
            x = 2,
            y = 5,
            connections = {
                [5] = {
                    1, 
                }, 
            },
        },
        {
            type = "quest",
            id = 12281,
            x = 0,
            connections = {
                1.2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            x = 0,
            connections = {
                [18] = {
                    1, 
                }, 
            },
        },
        {
            type = "quest",
            id = 12499,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AngratharTheWrathgateHorde, {
    name = L["ANGRATHAR_THE_WRATHGATE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.TheTaunka,
        }
    },
    active = {
        type = "quest",
        ids = {
            12034, 12188, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12500,
    },
    rewards = {
        {
            type = "experience",
            amount = 292300,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 900,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 900,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 900,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 1555,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 360,
        },
    },
    items = {
        {
            type = "npc",
            id = 26379,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12034,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12036,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12063,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12053,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12064,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12071,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12069,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12072,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12140,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = 2,
            y = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12224,
            x = 0,
            y = 8,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12496,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12497,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12498,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12500,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Frostmourne, {
    name = L["FROSTMOURNE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateAlliance,
            upto = 12251
        }
    },
    active = {
        type = "quest",
        id = 12282,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12478,
    },
    rewards = {
        {
            type = "experience",
            amount = 214350,
        },
        {
            type = "money",
            amount = 159000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 2500,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 1000,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
            x = 2,
            y = 5,
        },
        {
            type = "npc",
            id = 27314,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12282,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12287,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12290,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12291,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12301,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12305,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12477,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12475,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12476,
            aside = true,
        },
        {
            type = "quest",
            id = 12478,
            x = 0,
        },
    },
})
Database:AddChain(Chain.InformingTheQueenHorde, {
    name = L["INFORMING_THE_QUEEN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.RedirectingTheLeyLinesHorde,
        }
    },
    active = {
        type = "quest",
        id = 12122,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12124,
    },
    rewards = {
        {
            type = "experience",
            amount = 81150,
        },
        {
            type = "money",
            amount = 235600,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 10,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 805,
        },
    },
    items = {
        {
            type = "npc",
            id = 26471,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12122,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12767,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12461,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12448,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12449,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12450,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12769,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12124,
            x = 0,
        },
    },
})
Database:AddChain(Chain.StrategicAlliance, {
    name = L["STRATEGIC_ALLIANCE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 72,
        },
    },
    active = {
        type = "quest",
        ids = {
            12075, 12112, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12078,12080
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 134900,
        },
        {
            type = "money",
            amount = 448000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12112,
                    restrictions = {
                        type = "quest",
                        id = 12112,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26659,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12075,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12076,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12079,
            aside = true,
        },
        {
            type = "quest",
            id = 12077,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12078,
            x = -1,
        },
        {
            type = "quest",
            id = 12080,
        },
    },
})
Database:AddChain(Chain.TheScarletOnslaught, {
    name = L["THE_SCARLET_ONSLAUGHT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12206, 12234, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12285,
    },
    rewards = {
        {
            type = "experience",
            amount = 388500,
        },
        {
            type = "money",
            amount = 1045000,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 4785,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
            x = -2,
            y = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            aside = true,
            embed = true,
            x = 3,
            y = 0,
        },
        {
            type = "npc",
            id = 27248,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12206,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12211,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12230,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12232,
            aside = true,
            x = -2,
        },
        {
            type = "npc",
            id = 27337,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12240,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12234,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12243,
            aside = true,
        },
        {
            type = "quest",
            id = 12239,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12254,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12260,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12274,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12283,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12285,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Oachanoa, {
    name = L["OACHANOA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
    },
    active = {
        type = "quest",
        ids = {
            11958, 12117, 12118, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12032,
    },
    rewards = {
        {
            type = "experience",
            amount = 200550,
        },
        {
            type = "money",
            amount = 617000,
        },
        {
            type = "reputation",
            id = 1073,
            amount = 2710,
        },
    },
    items = {
        {
            visible = false,
            x = -3,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12117,
                    restrictions = {
                        type = "quest",
                        id = 12117,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12118,
                    restrictions = {
                        type = "quest",
                        id = 12118,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26194,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11958,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11959,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12009,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12028,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12030,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12031,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12032,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Wanted!
        type = "object",
        id = 188418,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12089, 12090, 12091, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12097,
    },
    rewards = {
        {
            type = "experience",
            amount = 152400,
        },
        {
            type = "money",
            amount = 619000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 350,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 1710,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            aside = true,
            embed = true,
            x = 3,
            y = 1,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- The Lost Empire
        type = "quest",
        id = 12041,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.TheTaunka,
            lowPriority = true,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateHorde,
            upto = 12034
        },
    },
    active = {
        type = "quest",
        ids = {12056, 12039, 12040},
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {12056, 12048, 12041},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 96450,
        },
        {
            type = "money",
            amount = 50000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 150,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain17,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Wanted!
        type = "object",
        id = 190020,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 71,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateAlliance,
            upto = 12251
        }
    },
    active = {
        type = "quest",
        ids = {
            12438, 12441, 12442,
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12438, 12441, 12442,
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 77850,
        },
        {
            type = "money",
            amount = 336000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1050,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "object",
            id = 190020,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12438,
            x = -2,
        },
        {
            type = "quest",
            id = 12441,
        },
        {
            type = "quest",
            id = 12442,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = BtWQuests_GetAreaName(4185), -- The Forgotten Shore
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12304, 12303,
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12304, 12303,
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 40600,
        },
        {
            type = "money",
            amount = 100000,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 500,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain05, {
    name = BtWQuests_GetAreaName(4396), -- Nozzlerust Post
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
        ids = {
            12469, 12044, 12045, 12043
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12044, 12043, 12049, 12050, 12052
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 171200,
        },
        {
            type = "money",
            amount = 504000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12469,
                    restrictions = {
                        type = "quest",
                        id = 12469,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 26660,
                },
            },
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 26661,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 26647,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12044,
            x = -2,
        },
        {
            type = "quest",
            id = 12045,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12043,
        },
        {
            type = "quest",
            id = 12046,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12047,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12049,
        },
        {
            type = "quest",
            id = 12050,
            x = -1,
        },
        {
            type = "quest",
            id = 12052,
        },
    },
})
Database:AddChain(Chain.Chain06, {
    name = { -- Disturbing Implications
        type = "quest",
        id = 12146,
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
        ids = {
            12146, 12147, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12151,
    },
    rewards = {
        {
            type = "experience",
            amount = 98100,
        },
        {
            type = "money",
            amount = 386000,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 1200,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "kill",
                    id = 27004,
                    restrictions = {
                        type = "faction",
                        id = BtWQuests.Constant.Faction.Horde,
                    },
                },
                {
                    type = "kill",
                    id = 27005,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            ids = {
                12146, 12147, 
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12148,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12149,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12150,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12151,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain07, {
    name = { -- The Cleansing Of Jintha'kalar
        type = "quest",
        id = 12545,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 74,
        },
    },
    active = {
        type = "quest",
        ids = {
            12542, 12545,
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12545,
    },
    rewards = {
        {
            type = "experience",
            amount = 20750,
        },
        {
            type = "money",
            amount = 56000,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 250,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12542,
                    restrictions = {
                        type = "quest",
                        id = 12542,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 28228,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12545,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26501,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12006,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12013,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 13343,
    },
    items = {
        {
            type = "npc",
            id = 27856,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12470,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13343,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12266,
    },
    items = {
        {
            type = "npc",
            id = 27765,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12447,
            x = 0,
            y = 2,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12262,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12261,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12263,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12264,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12265,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12267,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12266,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12459,
    },
    items = {
        {
            type = "npc",
            id = 27785,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12458,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12459,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12456,
    },
    items = {
        {
            type = "npc",
            id = 27255,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12454,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12456,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12277,
    },
    items = {
        {
            type = "quest",
            id = 12251,
            restrictions = false,
        },
        {
            type = "npc",
            id = 27136,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12275,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12272,
            x = -2,
        },
        {
            type = "quest",
            id = 12276,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12269,
            restrictions = false,
        },
        {
            type = "quest",
            id = 12277,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12320,
    },
    items = {
        {
            type = "object",
            id = 189311,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12312,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12319,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12320,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12321,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12472,
    },
    items = {
        {
            type = "quest",
            id = 12281,
            restrictions = false,
        },
        {
            type = "npc",
            id = 27136,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12325,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12326,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12462,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12455,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12457,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12463,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12465,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12466,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain21,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 12467,
            x = 0,
            y = 8,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12472,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12473,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12474,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12495,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12497,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12498,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12078,
    },
    items = {
        {
            type = "npc",
            id = 27172,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12188,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12200,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12218,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12221,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 27784,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12464,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 27267,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12209,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12214,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "object",
            id = 188649,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12205,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12245,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12252,
            x = -1,
        },
        {
            type = "quest",
            id = 12271,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12273,
            x = 1,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12016,
    },
    items = {
        {
            type = "object",
            id = 188364,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12011,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12016,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12017,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain14, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12097,
    },
    items = {
        {
            type = "object",
            id = 188418,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12089,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12090,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12091,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12095,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12097,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26979,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12144,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12145,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26618,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12056,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain17, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26564,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12039,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12048,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26653,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12040,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12041,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 32599,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12304,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 27267,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12303,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain21, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12013,
    },
    items = {
        {
            type = "npc",
            id = 26978,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12142,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12143,
            x = 0,
        },
    },
})

Database:AddChain(Chain.IgnoreChain01, {
    name = "Of Traitors and Treason",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12171,
    },
    items = {
        -- Breadcrumbs to 12235
        {
            type = "quest",
            id = 12157,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 12171,
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
        { -- Planning for the Future, Daily
            type = "quest",
            id = 11960,
        },
        { -- Message from the West
        -- Following other wowhead comments, and just confirming this tonight, for those of you who never ran any Borean Tundra quests, you must do the following to become eligible for this quest:
        -- Defense of Warsong Hold chain https://www.wowhead.com/?quest=11595
        -- The Wondrous Bloodspore chain https://www.wowhead.com/?quest=11716
            type = "quest",
            id = 12033,
        },
        { -- Rustling Some Feathers, Obsolete
            type = "quest",
            id = 12051,
        },
        { -- Give it a Name, leads to https://www.wowhead.com/quest=12182/to-venomspite which is a breadcrumb to https://www.wowhead.com/quest=12188/the-forsaken-blight-and-you-how-not-to-die
            type = "quest",
            id = 12181,
        },
        { -- To Venomspite!, breadcrumb to https://www.wowhead.com/quest=12188/the-forsaken-blight-and-you-how-not-to-die
            type = "quest",
            id = 12182,
        },
        { -- Of Traitors and Treason
            type = "quest",
            id = 12297,
        },
        { -- Defending Wyrmrest Temple, Daily
            type = "quest",
            id = 12372,
        },
        { -- A Disturbance In The West, Breadcrumb to a Breadcrumb
            type = "quest",
            id = 12439,
        },
        { -- The High Executor Needs You, breadcrmb to Venomspite but doesnt seem to go to a specific quest
            type = "quest",
            id = 12488,
        },
        { -- The Key to the Focusing Iris, Naxx quest
            type = "quest",
            id = 13372,
        },
        { -- The Heroic Key to the Focusing Iris, Naxx quest
            type = "quest",
            id = 13375,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-Dragonblight]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.TheWardensTask,
        },
        {
            type = "chain",
            id = Chain.TheTaunka,
        },
        {
            type = "chain",
            id = Chain.RedirectingTheLeyLinesAlliance,
        },
        {
            type = "chain",
            id = Chain.TraitorsToTheHorde,
        },
        {
            type = "chain",
            id = Chain.InformingTheQueenAlliance,
        },
        {
            type = "chain",
            id = Chain.RedirectingTheLeyLinesHorde,
        },
        {
            type = "chain",
            id = Chain.TheDragonflights,
        },
        {
            type = "chain",
            id = Chain.ContainingTheRot,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateAlliance,
        },
        {
            type = "chain",
            id = Chain.AngratharTheWrathgateHorde,
        },
        {
            type = "chain",
            id = Chain.Frostmourne,
        },
        {
            type = "chain",
            id = Chain.InformingTheQueenHorde,
        },
        {
            type = "chain",
            id = Chain.StrategicAlliance,
        },
        {
            type = "chain",
            id = Chain.TheScarletOnslaught,
        },
        {
            type = "chain",
            id = Chain.Oachanoa,
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
        {
            type = "chain",
            id = Chain.Chain06,
        },
        {
            type = "chain",
            id = Chain.Chain07,
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
