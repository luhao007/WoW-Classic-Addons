-- AUTO GENERATED - NEEDS UPDATING

local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.ZulDrak
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.ZulDrak
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 121
local CONTINENT_ID = 113
local ACHIEVEMENT_ID = 36
local LEVEL_RANGE = {20, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 74,
    },
}

Chain.Sseratus = 30501
Chain.Quetzlun = 30502
Chain.Akali = 30503
Chain.TheAmphitheaterOfAnguish = 30504
Chain.FindingAllies = 30505
Chain.TheStormKingsCrusade = 30506
Chain.Betrayal = 30507
Chain.TheArgentPatrol = 30508

Chain.Chain01 = 30511
Chain.Chain02 = 30512
Chain.Chain03 = 30513
Chain.Chain04 = 30514

Chain.EmbedChain01 = 30521
Chain.EmbedChain02 = 30522
Chain.EmbedChain03 = 30523
Chain.EmbedChain04 = 30524

Chain.IgnoreChain01 = 30531
Chain.IgnoreChain02 = 30532

Chain.OtherAlliance = 30597
Chain.OtherHorde = 30598
Chain.OtherBoth = 30599

Database:AddChain(Chain.Sseratus, {
    name = L["SSERATUS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12507,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12516,
    },
    rewards = {
        {
            type = "experience",
            amount = 137500,
        },
        {
            type = "money",
            amount = 387800,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 500,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            aside = true,
            embed = true,
            x = 2,
            y = 0,
        },
        {
            type = "item",
            id = 38321,
            breadcrumb = true,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12507,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12510,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12562,
            aside = true,
        },
        {
            type = "quest",
            id = 12527,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12514,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12516,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Quetzlun, {
    name = L["QUETZLUN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 74,
        },
        {
            type = "chain",
            id = Chain.Sseratus,
        },
    },
    active = {
        type = "quest",
        id = 12623,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12685,
    },
    rewards = {
        {
            type = "experience",
            amount = 414100,
        },
        {
            type = "money",
            amount = 65000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28062,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12623,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 12627,
            x = 0,
            y = 2,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12628,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12632,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12655,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12642,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12646,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12647,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12653,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12665,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12666,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12667,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12672,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12668,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12674,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12675,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12684,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12685,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12707,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12708,
            aside = true,
        },
        {
            type = "quest",
            id = 12709,
            aside = true,
        },
    },
})
Database:AddChain(Chain.Akali, {
    name = L["AKALI"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12712,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12730,
    },
    rewards = {
        {
            type = "experience",
            amount = 112650,
        },
        {
            type = "money",
            amount = 204000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28401,
            locations = {
                [121] = {
                    {
                        x = 0.602567,
                        y = 0.577414,
                    },
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12712,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12721,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12729,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12730,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheAmphitheaterOfAnguish, {
    name = L["THE_AMPHITHEATER_OF_ANGUISH"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 75,
        },
    },
    active = {
        type = "quest",
        ids = {
            12954, 12974, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12948,
    },
    rewards = {
        {
            type = "experience",
            amount = 192900,
        },
        {
            type = "money",
            amount = 1179000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12974,
                    restrictions = {
                        type = "quest",
                        id = 12974,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 30007,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12954,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12933,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12934,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12935,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12936,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12948,
            x = 0,
        },
    },
})
Database:AddChain(Chain.FindingAllies, {
    name = L["FINDING_ALLIES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12859, 12861, 12902, 49534, 49552, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12859,12861,12883
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 130950,
        },
        {
            type = "money",
            amount = 413000,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 25,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 1000,
        },
    },
    items = {
        {
            type = "npc",
            id = 29733,
            x = -2,
            connections = {
                4, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 49534,
                    restrictions = {
                        type = "quest",
                        id = 49534,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 49552,
                    restrictions = {
                        type = "quest",
                        id = 49552,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 29687,
                },
            },
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 29690,
            connections = {
                4, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 12859,
            x = -2,
            y = 1,
        },
        {
            type = "quest",
            id = 12902,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12861,
        },
        {
            type = "quest",
            id = 12883,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12884,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
            comment = "This quest may have alternatives so might need to move this, alternatives and the next quest over to its own chain",
        },
        {
            type = "quest",
            id = 12630,
            aside = true,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheStormKingsCrusade, {
    name = L["THE_STORM_KINGS_CRUSADE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 74,
        },
        {
            type = "chain",
            id = Chain.FindingAllies,
            upto = 12883,
        },
    },
    active = {
        type = "quest",
        id = 12894,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12903,12901,12904,12919
        },
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amount = 139600,
        },
        {
            type = "money",
            amount = 310000,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 1700,
        },
    },
    items = {
        {
            type = "npc",
            id = 29687,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 29455,
            x = -3,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12894,
            x = 0,
            connections = {
                2, 3, 4, 5, 
            },
        },
        {
            type = "npc",
            id = 29647,
            x = 3,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12904,
            x = -3,
        },
        {
            type = "quest",
            id = 12903,
        },
        {
            type = "quest",
            id = 12901,
        },
        {
            type = "quest",
            id = 12912,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12914,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12916,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12919,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Betrayal, {
    name = L["BETRAYAL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12629, 12629, 12629, 12631, 12631, 12631, 12633, 12637, 12637, 12637, 12638, 12643, 12648, 12648, 12648, 12649, 12661, 12663, 12664, 12673, 12686, 12690, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12713,
    },
    rewards = {
        {
            type = "experience",
            amount = 199400,
        },
        {
            type = "money",
            amount = 600000,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 1500,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "item",
                    id = 38660,
                    restrictions = {
                        type = "quest",
                        id = 12631,
                    },
                },
                {
                    type = "item",
                    id = 38660,
                    restrictions = {
                        type = "item",
                        id = 38660,
                    },
                },
                {
                    type = "item",
                    id = 38673,
                    restrictions = {
                        type = "quest",
                        id = 12238,
                    },
                },
                {
                    type = "item",
                    id = 38660,
                },
            },
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12631,
                    restrictions = {
                        type = "quest",
                        id = 12631,
                    },
                },
                {
                    type = "quest",
                    id = 12631,
                    restrictions = {
                        type = "item",
                        id = 38660,
                    },
                },
                {
                    type = "quest",
                    id = 12633,
                    restrictions = {
                        type = "quest",
                        id = 12238,
                    },
                },
                {
                    type = "quest",
                    id = 12631,
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
                    id = 12637,
                    restrictions = {
                        type = "quest",
                        id = 12631,
                    },
                },
                {
                    type = "quest",
                    id = 12637,
                    restrictions = {
                        type = "item",
                        id = 38660,
                    },
                },
                {
                    type = "quest",
                    id = 12638,
                    restrictions = {
                        type = "quest",
                        id = 12238,
                    },
                },
                {
                    type = "quest",
                    id = 12637,
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
                    id = 12629,
                    restrictions = {
                        type = "quest",
                        id = 12631,
                    },
                },
                {
                    type = "quest",
                    id = 12629,
                    restrictions = {
                        type = "item",
                        id = 38660,
                    },
                },
                {
                    type = "quest",
                    id = 12643,
                    restrictions = {
                        type = "quest",
                        id = 12238,
                    },
                },
                {
                    type = "quest",
                    id = 12629,
                },
            },
            x = 0,
            connections = {
                3, 1.2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            aside = true,
            embed = true,
        },
        {
            type = "npc",
            id = 28503,
            x = -2,
            y = 4,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12648,
                    restrictions = {
                        type = "quest",
                        id = 12631,
                    },
                },
                {
                    type = "quest",
                    id = 12648,
                    restrictions = {
                        type = "item",
                        id = 38660,
                    },
                },
                {
                    type = "quest",
                    id = 12649,
                    restrictions = {
                        type = "quest",
                        id = 12238,
                    },
                },
                {
                    type = "quest",
                    id = 12648,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            aside = true,
            ids = {
                12663, 12664, 
            },
            x = -2,
        },
        {
            type = "quest",
            id = 12661,
            x = 0,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 28503,
            aside = true,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 28503,
            aside = true,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12669,
            x = 0,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12673,
            aside = true,
        },
        {
            type = "quest",
            id = 12686,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12677,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 28503,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12676,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12690,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12713,
            x = 0,
        },
        {
            type = "quest",
            id = 12710,
            aside = true,
        },
    },
})
Database:AddChain(Chain.TheArgentPatrol, {
    name = L["THE_ARGENT_PATROL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12503, 12512, 12557, 12597, 12598, 12599, 12740, 12795, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12504, 12506, 12508, 12512, 12554, 12555, 12584, 12596
        },
        count = 8,
    },
    rewards = {
        {
            type = "experience",
            amount = 321500,
        },
        {
            type = "money",
            amount = 927800,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 3585,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12795,
                    restrictions = {
                        type = "quest",
                        id = 12795,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 28059,
                },
            },
            x = 0,
            connections = {
                2, 3, 
            },
        },
        {
            type = "npc",
            id = 28125,
            x = 3,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12503,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12740,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 12512,
            x = 3,
        },
        {
            type = "quest",
            id = 12506,
            x = -2,
        },
        {
            type = "quest",
            id = 12505,
            x = 0,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12596,
        },
        {
            type = "quest",
            id = 12504,
            x = -1,
        },
        {
            type = "quest",
            id = 12508,
        },
        {
            type = "npc",
            id = 28043,
            aside = true,
            x = -3,
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 28042,
            aside = true,
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 28044,
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 28205,
            aside = true,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12599,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 12597,
            aside = true,
        },
        {
            type = "quest",
            id = 12598,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 12557,
            aside = true,
        },
        {
            type = "quest",
            id = 12606,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 12552,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12553,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12554,
            x = -1,
        },
        {
            type = "quest",
            id = 12584,
        },
        {
            type = "quest",
            id = 12583,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12555,
            x = 3,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Siphoning the Spirits
        type = "quest",
        id = 12799,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12799,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12609, 12610 },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 63250,
        },
        {
            type = "money",
            amount = 183000,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 500,
        },
    },
    items = {
        {
            type = "npc",
            id = 28045,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12799,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12609,
            x = -1,
        },
        {
            type = "quest",
            id = 12610,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Bringing Down Heb'Jin
        type = "quest",
        id = 12662,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 74,
        },
        {
            type = "chain",
            id = Chain.Sseratus,
            lowPriority = true,
        },
        {
            type = "chain",
            id = Chain.Quetzlun,
            upto = 12623,
        },
    },
    active = {
        type = "quest",
        id = 12622,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {12659, 12662},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 107000,
        },
        {
            type = "money",
            amount = 325000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28484,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12622,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12640,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12639,
            aside = true,
        },
        {
            type = "quest",
            id = 12659,
            x = -1,
        },
        {
            type = "quest",
            id = 12662,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Tails Up
        type = "quest",
        id = 13549,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 74,
        },
        {
            type = "chain",
            id = Chain.Sseratus,
            lowPriority = true,
        },
        {
            type = "chain",
            id = Chain.Quetzlun,
            upto = 12627,
        },
    },
    active = {
        type = "quest",
        id = 12635,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12650, 13549, },
        count = 2
    },
    rewards = {
        {
            type = "experience",
            amount = 64200,
        },
        {
            type = "money",
            amount = 65000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28527,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12635,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12650,
            x = -1,
        },
        {
            type = "quest",
            id = 13549,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Eggs for Dubra'Jin
        type = "quest",
        id = 13556,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 13556,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13556,
    },
    rewards = {
        {
            type = "experience",
            amount = 21400,
        },
    },
    items = {
        {
            type = "npc",
            id = 33025,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13556,
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
        id = 12514,
    },
    items = {
        {
            type = "npc",
            id = 28062,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12565,
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
        id = 12514,
    },
    items = {
        {
            type = "npc",
            id = 28479,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12615,
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
        id = 12514,
    },
    items = {
        {
            type = "object",
            id = 191728,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12857,
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
        id = 12514,
    },
    items = {
        {
            type = "npc",
            id = 28589,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12652,
            x = 0,
        },
    },
})

Database:AddChain(Chain.IgnoreChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12514,
    },
    items = {
        {
            type = "npc",
            id = 28039,
        },
        {
            type = "quest",
            id = 12792,
            comment = "Kinda breadcrumb, 12793 and 12770 are alternatives. Maybe more",
        },
    },
})
Database:AddChain(Chain.IgnoreChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12514,
    },
    items = {
        {
            type = "npc",
            id = 28479,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12793,
            x = 0,
            comment = "Kinda breadcrumb, 12792 and 12770 are alternatives. Maybe more",
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
        { -- Troll Patrol, Daily, Obsolete
            type = "quest",
            id = 12501,
        },
        { -- Troll Patrol: High Standards, Daily
            type = "quest",
            id = 12502,
        },
        { -- Troll Patrol: Intestinal Fortitude, Daily
            type = "quest",
            id = 12509,
        },
        { -- Troll Patrol: Whatdya Want, a Medal?, Daily
            type = "quest",
            id = 12519,
        },
        { -- Troll Patrol: The Alchemist's Apprentice, Daily
            type = "quest",
            id = 12541,
        },
        { -- Troll Patrol, Obsolete
            type = "quest",
            id = 12563,
        },
        { -- Troll Patrol: Something for the Pain, Daily
            type = "quest",
            id = 12564,
        },
        { -- Blessing of Zim'Abwa, Repeatable
            type = "quest",
            id = 12567,
        },
        { -- Troll Patrol: Done to Death, Daily
            type = "quest",
            id = 12568,
        },
        { -- Troll Patrol: Creature Comforts, Daily
            type = "quest",
            id = 12585,
        },
        { -- Troll Patrol, Daily
            type = "quest",
            id = 12587,
        },
        { -- Troll Patrol: Can You Dig It?, Daily
            type = "quest",
            id = 12588,
        },
        { -- Blahblah[PH], Obsolete
            type = "quest",
            id = 12590,
        },
        { -- Troll Patrol: Throwing Down, Daily
            type = "quest",
            id = 12591,
        },
        { -- Troll Patrol: Couldn't Care Less, Daily
            type = "quest",
            id = 12594,
        },
        { -- Congratulations!, Daily
            type = "quest",
            id = 12604,
        },
        { -- Blessing of Zim'Torga, Repeatable
            type = "quest",
            id = 12618,
        },
        { -- Blessing of Zim'Rhuk, Repeatable
            type = "quest",
            id = 12656,
        },
        { -- Into the Breach!, Breadbrumb to Zul'Drak, doesnt seem to lead to a specific quest,
          -- may always be available too. There are multiple quests that lead to this npc.
          -- 12792, 12793, and 12770 are possible alternatives
            type = "quest",
            id = 12789,
        },
        { -- Zul'Drak, This is a an alternative of 12884 from the adventure journal but was apparently bugged
          -- because you didnt get the item required that came with 12884, might not even be available anymore
            type = "quest",
            id = 39208,
        }
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-ZulDrak]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.Sseratus,
        },
        {
            type = "chain",
            id = Chain.Quetzlun,
        },
        {
            type = "chain",
            id = Chain.Akali,
        },
        {
            type = "chain",
            id = Chain.TheAmphitheaterOfAnguish,
        },
        {
            type = "chain",
            id = Chain.FindingAllies,
        },
        {
            type = "chain",
            id = Chain.TheStormKingsCrusade,
        },
        {
            type = "chain",
            id = Chain.Betrayal,
        },
        {
            type = "chain",
            id = Chain.TheArgentPatrol,
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
