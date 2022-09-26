local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.HowlingFjord
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.HowlingFjord
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 117
local CONTINENT_ID = 113
local ACHIEVEMENT_ID_ALLIANCE = 34
local ACHIEVEMENT_ID_HORDE = 1356
local LEVEL_RANGE = {10, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 68,
    },
}

Chain.TheIllEquippedPort = 30201
Chain.VisitorsFromTheKeep = 30202
Chain.DescendantsOfTheVrykul = 30203
Chain.AssassinatingBjornHalgurdsson = 30204
Chain.IronRuneConstructs = 30205
Chain.ANewPlagueHorde = 30206
Chain.DoomApproaches = 30207
Chain.TheEndOfJonahSterling = 30208
Chain.TheDebtCollector = 30209
Chain.ANewPlagueAlliance = 30210
Chain.VolatileViscera = 30211
Chain.TheConquerorOfSkornAlliance = 30212
Chain.TheScourgeAndTheVrykulAlliance = 30213
Chain.TheIronDwarvesHorde = 30214
Chain.SistersOfTheFjord = 30215
Chain.TheConquerorOfSkornHorde = 30216
Chain.TheIronDwarvesAlliance = 30217
Chain.TheScourgeAndTheVrykulHorde = 30218
Chain.AlphaWorgAlliance = 30219
Chain.AlphaWorgHorde = 30220

Chain.Chain01 = 30221
Chain.Chain02 = 30222
Chain.Chain03 = 30223
Chain.Chain04 = 30224

Chain.EmbedChain01 = 30231
Chain.EmbedChain02 = 30232
Chain.EmbedChain03 = 30233
Chain.EmbedChain04 = 30234
Chain.EmbedChain05 = 30235
Chain.EmbedChain06 = 30236
Chain.EmbedChain07 = 30237
Chain.EmbedChain08 = 30238
Chain.EmbedChain09 = 30239
Chain.EmbedChain10 = 30240
Chain.EmbedChain11 = 30241
Chain.EmbedChain12 = 30242
Chain.EmbedChain13 = 30243
Chain.EmbedChain14 = 30244
Chain.EmbedChain15 = 30245
Chain.EmbedChain16 = 30246
Chain.EmbedChain17 = 30247
Chain.EmbedChain18 = 30248
Chain.EmbedChain19 = 30249
Chain.EmbedChain20 = 30250
Chain.EmbedChain21 = 30251
Chain.EmbedChain22 = 30252
Chain.EmbedChain23 = 30253
Chain.EmbedChain24 = 30254
Chain.EmbedChain25 = 30255
Chain.EmbedChain26 = 30256
Chain.EmbedChain27 = 30257
Chain.EmbedChain28 = 30258
Chain.EmbedChain29 = 30259
Chain.EmbedChain30 = 30260
Chain.EmbedChain31 = 30261
Chain.EmbedChain32 = 30262
Chain.EmbedChain33 = 30263
Chain.EmbedChain34 = 30264
Chain.EmbedChain35 = 30265
Chain.EmbedChain36 = 30266
Chain.EmbedChain37 = 30267
Chain.EmbedChain38 = 30268
Chain.EmbedChain39 = 30269
Chain.EmbedChain40 = 30270
Chain.EmbedChain41 = 30271
Chain.EmbedChain42 = 30272
Chain.EmbedChain43 = 30273
Chain.EmbedChain44 = 30274
Chain.EmbedChain45 = 30275
Chain.EmbedChain46 = 30276

Chain.OtherAlliance = 30297
Chain.OtherHorde = 30298
Chain.OtherBoth = 30299

Database:AddChain(Chain.TheIllEquippedPort, {
    name = L["THE_ILL_EQUIPPED_PORT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            49551, 11228, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11291,11436
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 269800,
        },
        {
            type = "money",
            amount = 423000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 3865,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 49551,
                    restrictions = {
                        type = "quest",
                        id = 49551,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 23547,
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
            id = 11228,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11243,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11244,
            x = 0,
            connections = {
                1, 2, 3, 6, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            aside = true,
            embed = true,
            x = -3,
            y = 4,
        },
        {
            type = "quest",
            id = 11255,
            x = -1,
            y = 4,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11288,
            aside = true,
            x = 3,
            y = 4,
        },
        {
            type = "quest",
            id = 11290,
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11291,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
            x = 1,
            y = 4,
        },
    },
})
Database:AddChain(Chain.VisitorsFromTheKeep, {
    name = L["VISITORS_FROM_THE_KEEP"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11270,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11234,
    },
    rewards = {
        {
            type = "experience",
            amount = 140800,
        },
        {
            type = "money",
            amount = 235000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 525,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 1075,
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
            id = 23780,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11270,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11221,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11229,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11230,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11232,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "quest",
            id = 11233,
            x = 0,
            y = 6,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11234,
            x = 0,
        },
    },
})
Database:AddChain(Chain.DescendantsOfTheVrykul, {
    name = L["DESCENDANTS_OF_THE_VRYKUL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheIllEquippedPort,
            upto = 11244,
        }
    },
    active = {
        type = "quest",
        id = 11333,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11344,
    },
    rewards = {
        {
            type = "experience",
            amount = 60300,
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
            id = 23975,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11333,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11343,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11344,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AssassinatingBjornHalgurdsson, {
    name = L["ASSASSINATING_BJORN_HALGURDSSON"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11227,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12481,
    },
    rewards = {
        {
            type = "experience",
            amount = 157900,
        },
        {
            type = "money",
            amount = 376000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 985,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 850,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 23938,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11227,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11253,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11254,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11295,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11282,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11283,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11285,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11303,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12481,
            x = 0,
        },
    },
})
Database:AddChain(Chain.IronRuneConstructs, {
    name = L["IRON_RUNE_CONSTRUCTS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11474, 11475, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11501,
    },
    rewards = {
        {
            type = "experience",
            amount = 221750,
        },
        {
            type = "money",
            amount = 329000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 2865,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 2615,
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
            id = Chain.EmbedChain05,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 11474,
                    restrictions = {
                        type = "quest",
                        id = 11474,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 24807,
                },
            },
            x = 0,
            y = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11475,
            x = 0,
            y = 1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11483,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11484,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11485,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11489,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11491,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11494,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11495,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11501,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ANewPlagueHorde, {
    name = L["A_NEW_PLAGUE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            49533, 11167, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11307,
    },
    rewards = {
        {
            type = "experience",
            amount = 107550,
        },
        {
            type = "money",
            amount = 165000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 250,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 910,
            restrictions = 923,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 49533,
                    restrictions = {
                        type = "quest",
                        id = 49533,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 24126,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11167,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11168,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11170,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11304,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11305,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11306,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11307,
            x = 0,
        },
    },
})
Database:AddChain(Chain.DoomApproaches, {
    name = L["DOOM_APPROACHES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11504, 11573, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11572,
    },
    rewards = {
        {
            type = "experience",
            amount = 213100,
        },
        {
            type = "money",
            amount = 141000,
        },
        {
            type = "reputation",
            id = 1073,
            amount = 3660,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11573,
                    restrictions = {
                        type = "quest",
                        id = 11573,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 23804,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11504,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11507,
            x = 0,
            connections = {
                3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            aside = true,
            embed = true,
            x = -2,
            y = 3,
        },
        {
            type = "quest",
            id = 11508,
            x = 0,
            y = 3,
            connections = {
                1, -1.2, 
            },
        },
        {
            type = "quest",
            id = 11509,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11510,
            x = 0,
            connections = {
                1, 2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 11511,
            x = -3,
            connections = {
                7, 
            },
        },
        {
            type = "quest",
            id = 11512,
            connections = {
                6, 
            },
        },
        {
            type = "quest",
            id = 11519,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11567,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 11527,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11529,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11530, --@TODO Is this required for 11568 or should it be aside?
            x = 0,
        },
        {
            type = "quest",
            id = 11568,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11572,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheEndOfJonahSterling, {
    name = L["THE_END_OF_JONAH_STERLING"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
        {
            type = "chain",
            id = Chain.DoomApproaches,
            upto = 11509,
        }
    },
    active = {
        type = "quest",
        id = 11434,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11471,
    },
    rewards = {
        {
            type = "experience",
            amount = 115700,
        },
        {
            type = "money",
            amount = 47000,
        },
    },
    items = {
        {
            type = "npc",
            id = 24537,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11434,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11455,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11473,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11459,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11476,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11479,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11480,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11471,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheDebtCollector, {
    name = L["THE_DEBT_COLLECTOR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
        {
            type = "chain",
            id = Chain.TheEndOfJonahSterling,
            upto = 11434,
        }
    },
    active = {
        type = "quest",
        id = 11464,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11467,
    },
    rewards = {
        {
            type = "experience",
            amount = 55350,
        },
        {
            type = "money",
            amount = 94000,
        },
    },
    items = {
        {
            type = "npc",
            id = 24541,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11464,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11466,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11467,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ANewPlagueAlliance, {
    name = L["A_NEW_PLAGUE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11157,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11332,
    },
    rewards = {
        {
            type = "experience",
            amount = 250500,
        },
        {
            type = "money",
            amount = 545400,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1975,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain09,
            aside = true,
            embed = true,
            x = -4,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "npc",
            id = 23749,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 11157,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11187,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11188,
            x = 0,
            y = 3,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 11224,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 11199,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11218,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11202,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11240,
            aside = true,
        },
        {
            type = "quest",
            id = 11327,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11328,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11330,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11331,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11332,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11406,
            aside = true,
            x = 0,
            comment = "Is this always available?",
        },
    },
})
Database:AddChain(Chain.VolatileViscera, {
    name = L["VOLATILE_VISCERA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.ANewPlagueHorde,
        }
    },
    active = {
        type = "quest",
        id = 11308,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11310,
    },
    rewards = {
        {
            type = "experience",
            amount = 135750,
        },
        {
            type = "money",
            amount = 282000,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 750,
            restrictions = 923,
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
            id = Chain.EmbedChain12,
            aside = true,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.TheConquerorOfSkornAlliance, {
    name = L["THE_CONQUEROR_OF_SKORN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.ANewPlagueAlliance,
        }
    },
    active = {
        type = "quest",
        id = 11248,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11250,
    },
    rewards = {
        {
            type = "experience",
            amount = 113100,
        },
        {
            type = "money",
            amount = 341000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1460,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 23749,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11248,
            x = 0,
            connections = {
                1.2, 2, 3, 4, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11245,
            x = -3,
            y = 2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 11246,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11247,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11250,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheScourgeAndTheVrykulAlliance, {
    name = L["THE_SCOURGE_AND_THE_VRYKUL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheConquerorOfSkornAlliance,
        }
    },
    active = {
        type = "quest",
        ids = {
            11235, 11231, 11237, 11452, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11452,11236,11239,11432,11238
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 176900,
        },
        {
            type = "money",
            amount = 538000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 2300,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain17,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            embed = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
            x = -3,
        },
    },
})
Database:AddChain(Chain.TheIronDwarvesHorde, {
    name = L["THE_IRON_DWARVES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        id = 11275,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11352,11367
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 186600,
        },
        {
            type = "money",
            amount = 482000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 2100,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain20,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "npc",
            id = 24123,
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
            x = 2,
        },
        {
            type = "quest",
            id = 11275,
            x = 0,
            y = 1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            embed = true,
        },
    },
})
Database:AddChain(Chain.SistersOfTheFjord, {
    name = L["SISTERS_OF_THE_FJORD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11302, 11313, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11428,
    },
    rewards = {
        {
            type = "experience",
            amount = 125650,
        },
        {
            type = "money",
            amount = 329000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11302,
                    restrictions = {
                        type = "quest",
                        id = 11302,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 24117,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11313,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11314,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 11315,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11316,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11319,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11428,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheConquerorOfSkornHorde, {
    name = L["THE_CONQUEROR_OF_SKORN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "quest",
            id = 11281,
        },
    },
    active = {
        type = "quest",
        id = 11256,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11261,
    },
    rewards = {
        {
            type = "experience",
            amount = 113100,
        },
        {
            type = "money",
            amount = 341000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 1460,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 24129,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11256,
            x = 0,
            connections = {
                1.2, 2, 3, 4, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
            aside = true,
            embed = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11257,
            x = -3,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 11258,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11259,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11261,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheIronDwarvesAlliance, {
    name = L["THE_IRON_DWARVES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        id = 11329,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11348,11359
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 221400,
        },
        {
            type = "money",
            amount = 604000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 2000,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain25,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "npc",
            id = 24056,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "quest",
            id = 11329,
            x = 0,
            y = 1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            aside = true,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain29,
            embed = true,
        },
        {
            type = "quest",
            id = 11410,
            aside = true,
        },
    },
})
Database:AddChain(Chain.TheScourgeAndTheVrykulHorde, {
    name = L["THE_SCOURGE_AND_THE_VRYKUL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.TheConquerorOfSkornHorde,
        }
    },
    active = {
        type = "quest",
        ids = {
            11263, 11265, 11266, 11453, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11264,11268,11433,11453,11267
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 176900,
        },
        {
            type = "money",
            amount = 538000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 2300,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain30,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain31,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain32,
            embed = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain33,
            embed = true,
            x = -3,
        },
    },
})
Database:AddChain(Chain.AlphaWorgAlliance, {
    name = L["ALPHA_WORG"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        id = 11322,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11326,
    },
    rewards = {
        {
            type = "experience",
            amount = 167850,
        },
        {
            type = "money",
            amount = 282000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 850,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 510,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain34,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain35,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain36,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.AlphaWorgHorde, {
    name = L["ALPHA_WORG"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = {
            11286, 11287, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11324,
    },
    rewards = {
        {
            type = "experience",
            amount = 145950,
        },
        {
            type = "money",
            amount = 238000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 1100,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain37,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 11287,
                    restrictions = {
                        type = "quest",
                        id = 11287,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 24186,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11286,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11317,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11323,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11415,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11417,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11324,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- It's a Scourge Device
        type = "quest",
        id = 11395,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = { 11393, 11394, 11395 },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 11394, 11396 },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 67350,
        },
        {
            type = "money",
            amount = 188000,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 610,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain38,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain39,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain40,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- It's a Scourge Device
        type = "quest",
        id = 11398,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = { 11397, 11398 },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 11397, 11399 },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 67350,
        },
        {
            type = "money",
            amount = 188000,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 610,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain41,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain42,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain40,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Brains! Brains! Brains!
        type = "quest",
        id = 11301,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = { 11297, 11298, 11301 },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 11298, 11301 },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 40200,
        },
        {
            type = "money",
            amount = 94000,
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
            id = Chain.EmbedChain43,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain44,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Against Nifflevar
        type = "quest",
        id = 12482,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = { 11423, 12482 },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 11423, 12482 },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 40200,
        },
        {
            type = "reputation",
            id = 1052,
            amount = 250,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1067,
            amount = 250,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain45,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain46,
            embed = true,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 23730,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11443,
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
        id = 11474,
    },
    items = {
        {
            type = "quest",
            id = 11273,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11274,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11276,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11277,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11299,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11300,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11278,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11448,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11436,
    },
    items = {
        {
            type = "quest",
            id = 11420,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11426,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11427,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11429,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11430,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11421,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11436,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 23784,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11241,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24811,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            variations = {
                {
                    restrictions = {
                        type = "quest",
                        id = 11448,
                        status = { "notcompleted", },
                    },
                    x = -1,
                },
                {
                    x = 0,
                },
            },
            id = 11477,
        },
        {
            type = "quest",
            id = 11478,
            visible = {
                type = "quest",
                id = 11448,
                status = { "notcompleted", },
            },
            comment = "Cannot be accepted if [11448] is already completed, need to check if other way around is true",
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24750,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11460,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11465,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11468,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11470,
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
        id = 11458,
    },
    items = {
        {
            type = "npc",
            id = 24755,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11456,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11457,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11458,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24784,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11469,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 23773,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11155,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 23770,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11190,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 23870,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11182,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24252,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11424,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24251,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11308,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11309,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11310,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24157,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11279,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11280,
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
        id = 11391,
    },
    items = {
        {
            name = L["KILL_VRYKUL"],
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11249,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11236,
    },
    items = {
        {
            type = "npc",
            id = 23749,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11235,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11236,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain17, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11239,
    },
    items = {
        {
            type = "npc",
            id = 24038,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11231,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11239,
            x = -1,
        },
        {
            type = "quest",
            id = 11432,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11238,
    },
    items = {
        {
            type = "item",
            id = 33289,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11237,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11238,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11452,
    },
    items = {
        {
            type = "item",
            id = 34090,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11452,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24127,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11271,
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
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24256,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11311,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11352,
    },
    items = {
        {
            type = "quest",
            id = 11350,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11351,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11352,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11367,
    },
    items = {
        {
            type = "quest",
            id = 11365,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11366,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11367,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            name = L["KILL_VRYKUL"],
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11260,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24176,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11284,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24131,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11292,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11418,
    },
    items = {
        {
            type = "npc",
            id = 24139,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11269,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11418,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain28, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11348,
    },
    items = {
        {
            type = "quest",
            id = 11346,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11349,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11348,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain29, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11359,
    },
    items = {
        {
            type = "quest",
            id = 11355,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11358,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11359,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain30, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11264,
    },
    items = {
        {
            type = "npc",
            id = 24129,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11263,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11264,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain31, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11268,
    },
    items = {
        {
            type = "npc",
            id = 24135,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11265,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11268,
            x = -1,
        },
        {
            type = "quest",
            id = 11433,
        },
    },
})
Database:AddChain(Chain.EmbedChain32, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11267,
    },
    items = {
        {
            type = "item",
            id = 33347,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11266,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11267,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain33, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11453,
    },
    items = {
        {
            type = "item",
            id = 34091,
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11453,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain34, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24227,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11154,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain35, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24273,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11322,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11325,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11414,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11416,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11326,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain36, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11175,
                    restrictions = {
                        type = "quest",
                        id = 11175,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 23891,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11176,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11390,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11391,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain37, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24209,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11296,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain38, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11393,
                    restrictions = {
                        type = "quest",
                        id = 11393,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 23833,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11394,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain39, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "kill",
            id = 24485,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11395,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11396,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain40, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24544,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11422,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain41, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24359,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11397,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain42, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "kill",
            id = 24485,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11398,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11399,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain43, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11297,
                    restrictions = {
                        type = "quest",
                        id = 11297,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 24152,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11298,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain44, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24218,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11301,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain45, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 24548,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11423,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain46, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11391,
    },
    items = {
        {
            type = "npc",
            id = 27922,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12482,
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
        { -- Break the Blockade, Daily
            type = "quest",
            id = 11153,
        },
        { -- [Temporarily Deprecated Awaiting a New Mob]Finlay Is Gutless, Obsolete
            type = "quest",
            id = 11179,
        },
        { -- Stop the Ascension!
            type = "quest",
            id = 11260,
        },
        { -- Find Sage Mistwalker
            type = "quest",
            id = 11287,
        },
        { -- Guided by Honor, Follows 11288
            type = "quest",
            id = 11289,
        },
        { -- Camp Winterhoof, Obsolete
            type = "quest",
            id = 11411,
        },
        { -- The Way to His Heart..., Daily
            type = "quest",
            id = 11472,
        },
        { -- Help for Camp Winterhoof, Leads to Camp Winterhoof but not to a specific quest
            type = "quest",
            id = 12566,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-HowlingFjord]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.TheIllEquippedPort,
        },
        {
            type = "chain",
            id = Chain.VisitorsFromTheKeep,
        },
        {
            type = "chain",
            id = Chain.DescendantsOfTheVrykul,
        },
        {
            type = "chain",
            id = Chain.AssassinatingBjornHalgurdsson,
        },
        {
            type = "chain",
            id = Chain.IronRuneConstructs,
        },
        {
            type = "chain",
            id = Chain.ANewPlagueHorde,
        },
        {
            type = "chain",
            id = Chain.DoomApproaches,
        },
        {
            type = "chain",
            id = Chain.TheEndOfJonahSterling,
        },
        {
            type = "chain",
            id = Chain.TheDebtCollector,
        },
        {
            type = "chain",
            id = Chain.ANewPlagueAlliance,
        },
        {
            type = "chain",
            id = Chain.VolatileViscera,
        },
        {
            type = "chain",
            id = Chain.TheConquerorOfSkornAlliance,
        },
        {
            type = "chain",
            id = Chain.TheScourgeAndTheVrykulAlliance,
        },
        {
            type = "chain",
            id = Chain.TheIronDwarvesHorde,
        },
        {
            type = "chain",
            id = Chain.SistersOfTheFjord,
        },
        {
            type = "chain",
            id = Chain.TheConquerorOfSkornHorde,
        },
        {
            type = "chain",
            id = Chain.TheIronDwarvesAlliance,
        },
        {
            type = "chain",
            id = Chain.TheScourgeAndTheVrykulHorde,
        },
        {
            type = "chain",
            id = Chain.AlphaWorgAlliance,
        },
        {
            type = "chain",
            id = Chain.AlphaWorgHorde,
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

Database:AddContinentItems(CONTINENT_ID, {})
