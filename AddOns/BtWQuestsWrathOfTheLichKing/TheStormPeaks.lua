-- AUTO GENERATED - NEEDS UPDATING

local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.TheStormPeaks
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.TheStormPeaks
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 120
local CONTINENT_ID = 113
local ACHIEVEMENT_ID = 38
local LEVEL_RANGE = {25, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 77,
    },
}

Chain.DefendingK3 = 30701
Chain.TheHarpyProblem = 30702
Chain.NorgannonsShell = 30703
Chain.BringingDownTheIronColossus = 30704
Chain.PursuingALegend = 30705
Chain.ForTheFrostbornKing = 30706
Chain.TheStoryOfStormhoof = 30707
Chain.BearlyReady = 30708
Chain.Heartbreak = 30709
Chain.TheSonsOfHodir = 30710
Chain.Loken = 30711

Chain.Chain01 = 30721
Chain.Chain02 = 30722

Chain.EmbedChain01 = 30731
Chain.EmbedChain02 = 30732
Chain.EmbedChain03 = 30733
Chain.EmbedChain04 = 30734
Chain.EmbedChain05 = 30735
Chain.EmbedChain06 = 30736
Chain.EmbedChain07 = 30737
Chain.EmbedChain08 = 30738
Chain.EmbedChain09 = 30739
Chain.EmbedChain10 = 30740
Chain.EmbedChain11 = 30741
Chain.EmbedChain12 = 30742

Chain.OtherAlliance = 30797
Chain.OtherHorde = 30798
Chain.OtherBoth = 30799

Database:AddChain(Chain.DefendingK3, {
    name = L["DEFENDING_K3"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12827, 12836, 12818, 12831, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12822,12824
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 241900,
        },
        {
            type = "money",
            amount = 761600,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            x = -2,
            y = 1,
            connections = {
                [4] = {
                    3, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            embed = true,
            x = 1,
            y = 0,
            connections = {
                [5] = {
                    2, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
            x = 3,
            y = 1,
            connections = {
                [3] = {
                    1, 
                }, 
            },
        },
        {
            type = "quest",
            id = 12821,
            x = 0,
            y = 5,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12822,
            x = -1,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12823,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12824,
            x = 1,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12862,
                    restrictions = {
                        type = "faction",
                        id = BtWQuests.Constant.Faction.Alliance,
                    },
                },
                {
                    type = "quest",
                    id = 13060,
                },
            },
            aside = true,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheHarpyProblem, {
    name = L["THE_HARPY_PROBLEM"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12863,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12867,12868
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 137150,
        },
        {
            type = "money",
            amount = 482800,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 250,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1126,
            amount = 1360,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain04,
            aside = true,
            embed = true,
            x = 2,
            y = 0,
        },
        {
            type = "npc",
            id = 29743,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12863,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12864,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12865,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12866,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12867,
        },
        {
            type = "quest",
            id = 12868,
            x = -1,
        },
    },
})
Database:AddChain(Chain.NorgannonsShell, {
    name = L["NORGANNONS_SHELL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12854, 12895, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12872,12928
        },
        count = 1,
    },
    rewards = {
        {
            type = "experience",
            amount = 285600,
        },
        {
            type = "money",
            amount = 960800,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 1000,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 520,
            restrictions = 924,
        },
    },
    items = {
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
    },
})
Database:AddChain(Chain.BringingDownTheIronColossus, {
    name = L["BRINGING_DOWN_THE_IRON_COLOSSUS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12885, 12929, 12930, 12979, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12965,12978,13007
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 347300,
        },
        {
            type = "money",
            amount = 1332000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12885,
                    restrictions = {
                        type = "quest",
                        id = 12885,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 12929,
                    restrictions = {
                        type = "quest",
                        id = 12929,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 29801,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12930,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12937,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12931,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12957,
            x = -1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 12964,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12965,
            x = -2,
        },
        {
            type = "npc",
            id = 29380,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12978,
        },
        {
            type = "quest",
            id = 12979,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12980,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12984,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12988,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12991,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12993,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12998,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13007,
            x = 0,
        },
    },
})
Database:AddChain(Chain.PursuingALegend, {
    name = L["PURSUING_A_LEGEND"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.NorgannonsShell,
        },
    },
    active = {
        type = "quest",
        id = 13273,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13285,
    },
    rewards = {
        {
            type = "experience",
            amount = 71650,
        },
        {
            type = "money",
            amount = 296000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 350,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 29579,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13273,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13274,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13285,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ForTheFrostbornKing, {
    name = L["FOR_THE_FROSTBORN_KING"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.NorgannonsShell,
        },
    },
    active = {
        type = "quest",
        id = 12871,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12973,12876
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 194050,
        },
        {
            type = "money",
            amount = 762200,
        },
        {
            type = "reputation",
            id = 1068,
            amount = 510,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1126,
            amount = 1870,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 29579,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12871,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12873,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12874,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12875,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12876,
        },
        {
            type = "quest",
            id = 12877,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12986,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12878,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12879,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12880,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12973,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheStoryOfStormhoof, {
    name = L["THE_STORY_OF_STORMHOOF"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
    },
    active = {
        type = "quest",
        ids = {
            13034, 13426, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13058,
    },
    rewards = {
        {
            type = "experience",
            amount = 137800,
        },
        {
            type = "money",
            amount = 518000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 1350,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 13426,
                    restrictions = {
                        type = "quest",
                        id = 13426,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 30381,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13034,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13037,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 13038,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13048,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13049,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13058,
            x = 0,
        },
    },
})
Database:AddChain(Chain.BearlyReady, {
    name = L["BEARLY_READY"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12843,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12972,
    },
    rewards = {
        {
            type = "experience",
            amount = 154200,
        },
        {
            type = "money",
            amount = 224400,
        },
    },
    items = {
        {
            type = "npc",
            id = 29473,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12843,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12844,
            aside = true,
        },
        {
            type = "quest",
            id = 12846,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12841,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12905,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12906,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12907,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12908,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12921,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12969,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12970,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12971,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12972,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Heartbreak, {
    name = L["HEARTBREAK"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.BearlyReady,
        },
    },
    active = {
        type = "quest",
        id = 12851,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13064,
    },
    rewards = {
        {
            type = "experience",
            amount = 288900,
        },
        {
            type = "money",
            amount = 662200,
        },
    },
    items = {
        {
            type = "npc",
            id = 29592,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12851,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12856,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13063,
            x = 0,
            connections = {
                1, 2, 3, 4, 5, 
            },
        },
        {
            type = "quest",
            id = 12968,
            aside = true,
            x = 3,
        },
        {
            type = "quest",
            id = 12925,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 12900,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 12942,
            aside = true,
        },
        {
            type = "quest",
            id = 12953,
            aside = true,
        },
        {
            type = "quest",
            id = 12989,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12983,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12996,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12997,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13061,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13062,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12886,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13064,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheSonsOfHodir, {
    name = L["THE_SONS_OF_HODIR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.Heartbreak,
        },
    },
    active = {
        type = "quest",
        ids = {
            12915, 12922, 12975, 12985, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12976, 12987, 13001
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 209500,
        },
        {
            type = "money",
            amount = 713400,
        },
        {
            type = "reputation",
            id = 1119,
            amount = 45625,
        },
    },
    items = {
        {
            type = "npc",
            id = 29445,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "kill",
            id = 29375,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12915,
            x = -1,
            connections = {
                3, 4, 5, 
            },
        },
        {
            type = "quest",
            id = 12922,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12956,
            x = 1,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
            x = -2,
        },
        {
            type = "quest",
            id = 12924,
            aside = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            x = 2,
            y = 4,
            connections = {
                [4] = {
                    1, 2, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Loken, {
    name = L["LOKEN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.TheSonsOfHodir,
            upto = 12967, -- @TODO Is this correct or is it 12924?
        }
    },
    active = {
        type = "quest",
        id = 13009,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13047,
    },
    rewards = {
        {
            type = "experience",
            amount = 176450,
        },
        {
            type = "money",
            amount = 777000,
        },
        {
            type = "reputation",
            id = 1119,
            amount = 350,
        },
    },
    items = {
        {
            type = "npc",
            id = 30127,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13009,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13050,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13051,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13010,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13057,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13005,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13035,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13047,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 29863,
            aside = true,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = {
        type = "npc",
        id = 29430,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
        {
            type = "chain",
            id = Chain.DefendingK3,
            upto = 12827,
        },
    },
    active = {
        type = "quest",
        ids = {12829, 12830},
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {12829, 12830},
        count = 2
    },
    rewards = {
        {
            type = "experience",
            amount = 43200,
        },
        {
            type = "money",
            amount = 136000,
        },
    },
    items = {
        {
            type = "npc",
            id = 29430,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12829,
            x = -1,
        },
        {
            type = "quest",
            id = 12830,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- There's Always Time for Revenge
        type = "quest",
        id = 13056,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 13054,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13056,
    },
    rewards = {
        {
            type = "experience",
            amount = 98550,
        },
        {
            type = "money",
            amount = 324000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 825,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            aside = true,
            embed = true,
            x = 2,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12822,
    },
    items = {
        {
            type = "npc",
            id = 29428,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12827,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12836,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12828,
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
        id = 12820,
    },
    items = {
        {
            type = "npc",
            id = 29431,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12818,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12819,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12826,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12820,
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
        id = 12832,
    },
    items = {
        {
            type = "npc",
            id = 29434,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12831,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12832,
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
        id = 12880,
    },
    items = {
        {
            type = "npc",
            id = 29744,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12870,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 12872,
    },
    items = {
        {
            type = "npc",
            id = 29650,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12854,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12855,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12858,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12860,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13415,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12872,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 12928,
    },
    items = {
        {
            type = "npc",
            id = 29651,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12895,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12909,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12910,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12913,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12917,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12920,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12926,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12927,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13416,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12928,
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
        id = 13001,
    },
    items = {
        {
            type = "npc",
            id = 30252,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13001,
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
        id = 12967,
    },
    items = {
        {
            type = "npc",
            id = 30105,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12966,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13011,
            aside = true,
        },
        {
            type = "quest",
            id = 12967,
            x = -2,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12976,
    },
    items = {
        {
            type = "quest",
            id = 12975,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 12976,
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
        id = 12987,
    },
    items = {
        {
            type = "quest",
            id = 12985,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 12987,
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
        id = 12880,
    },
    items = {
        {
            type = "npc",
            id = 30247,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13000,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13054,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13055,
            x = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13056,
            x = 1,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12880,
    },
    items = {
        {
            type = "npc",
            id = 30472,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12882,
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
        { -- Overstock, Daily
            type = "quest",
            id = 12833,
        },
        { -- Luxurious Getaway!, Follows https://www.wowhead.com/quest=49536/warchiefs-command-storm-peaks
            type = "quest",
            id = 12853,
        },
        { -- Pushed Too Farm, Daily
            type = "quest",
            id = 12869,
        },
        { -- SCRAP-E
        -- Engineer only, scap bot recipe
            type = "quest",
            id = 12888,
        },
        { -- The Prototype Console
        -- Follows 12888
            type = "quest",
            id = 12889,
        },
        { -- Blowing Hodir's Horn, Daily
            type = "quest",
            id = 12977,
        },
        { -- Hot and Cold, Daily
            type = "quest",
            id = 12981,
        },
        { -- Spy Hunter, Daily
            type = "quest",
            id = 12994,
        },
        { -- Thrusting Hodir's Spear, Daily
            type = "quest",
            id = 13003,
        },
        { -- Polishing the Helm, Daily
            type = "quest",
            id = 13006,
        },
        { -- Feeding Arngrim, Daily
            type = "quest",
            id = 13046,
        },
        { -- Everfrost
        -- FYI .. you need to be "FRIENDLY" before obtaining this quest. Otherwise, you will only loot dust.
            type = "quest",
            id = 13420,
        },
        { -- Remember Everfrost!, Repeatable of 13420
            type = "quest",
            id = 13421,
        },
        { -- Maintaining Discipline, Daily
            type = "quest",
            id = 13422,
        },
        { -- Defending Your Title, Daily
            type = "quest",
            id = 13423,
        },
        { -- Back to the Pit, Daily
            type = "quest",
            id = 13424,
        },
        { -- The Aberrations Must Die, Daily
            type = "quest",
            id = 13425,
        },
        { -- Hodir's Tribute, Repeatable
            type = "quest",
            id = 13559,
        },
        { -- The Scrapbot Construction Kit
        -- Follows 12889?
            type = "quest",
            id = 13843,
        },
        { -- Warchief's Command: Storm Peaks!, Breadcrumb to K3
            type = "quest",
            id = 49536,
        },
        { -- Hero's Call: Storm Peaks!, Breadcrumb to K3
            type = "quest",
            id = 49554,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-TheStormPeaks]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.DefendingK3,
        },
        {
            type = "chain",
            id = Chain.TheHarpyProblem,
        },
        {
            type = "chain",
            id = Chain.NorgannonsShell,
        },
        {
            type = "chain",
            id = Chain.BringingDownTheIronColossus,
        },
        {
            type = "chain",
            id = Chain.PursuingALegend,
        },
        {
            type = "chain",
            id = Chain.ForTheFrostbornKing,
        },
        {
            type = "chain",
            id = Chain.TheStoryOfStormhoof,
        },
        {
            type = "chain",
            id = Chain.BearlyReady,
        },
        {
            type = "chain",
            id = Chain.Heartbreak,
        },
        {
            type = "chain",
            id = Chain.TheSonsOfHodir,
        },
        {
            type = "chain",
            id = Chain.Loken,
        },
        
        {
            type = "chain",
            id = Chain.Chain01,
        },
        {
            type = "chain",
            id = Chain.Chain02,
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
