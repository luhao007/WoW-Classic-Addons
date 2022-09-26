-- AUTO GENERATED - NEEDS UPDATING

local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.Icecrown
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.Icecrown
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 118
local CONTINENT_ID = 113
local ACHIEVEMENT_ID = 40
local LEVEL_RANGE = {25, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 77,
    },
}

Chain.CrusaderBridenbrad = 30801
Chain.TheUnthinkable = 30802
Chain.TeachingTheMeaningOfFear = 30803
Chain.TheHeartOfTheLichKingAlliance = 30804
Chain.TheHeartOfTheLichKingHorde = 30805
Chain.WhatsYoursIsMine01 = 30806
Chain.WhatsYoursIsMine02 = 30807
Chain.SeizingSaronite = 30808
Chain.MalykrissTheVileHold = 30809
Chain.InDefianceOfTheScourge = 30810
Chain.MordretharTheDeathGate01 = 30811
Chain.MordretharTheDeathGate02 = 30812
Chain.AldurtharTheDesolationGate01 = 30813
Chain.AldurtharTheDesolationGate02 = 30814
Chain.CorpretharTheHorrorGate01 = 30815
Chain.CorpretharTheHorrorGate02 = 30816

Chain.Chain01 = 30821
Chain.Chain02 = 30822

Chain.TempChain22 = 30831
Chain.TempChain30 = 30832
Chain.TempChain31 = 30833
Chain.TempChain32 = 30834
Chain.TempChain33 = 30835
Chain.TempChain34 = 30836
Chain.TempChain36 = 30837
Chain.TempChain43 = 30838

Chain.OtherAlliance = 30897
Chain.OtherHorde = 30898
Chain.OtherBoth = 30899

Database:AddChain(Chain.CrusaderBridenbrad, {
    name = L["CRUSADER_BRIDENBRAD"],
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
            id = Chain.InDefianceOfTheScourge,
            upto = 13141,
        },
    },
    active = {
        type = "quest",
        id = 13068,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13083,
    },
    rewards = {
        {
            type = "experience",
            amount = 221650,
        },
        {
            type = "money",
            amount = 862200,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 1980,
        },
    },
    items = {
        {
            type = "npc",
            id = 31044,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13068,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13072,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13073,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13074,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13075,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13076,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13077,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13078,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13079,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13080,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13081,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13082,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13083,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheUnthinkable, {
    name = L["THE_UNTHINKABLE"],
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
            id = Chain.WhatsYoursIsMine01,
        },
        {
            type = "chain",
            id = Chain.WhatsYoursIsMine02,
        },
    },
    active = {
        type = "quest",
        id = 12938,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13219,
    },
    rewards = {
        {
            type = "reputation",
            id = 1098,
            amount = 3070,
        },
    },
    items = {
        {
            type = "npc",
            id = 29343,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12938,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12955,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12999,
            x = 0,
            connections = {
                2, 3, 4, 5, 
            },
        },
        {
            type = "npc",
            id = 30406,
            x = 3,
            aside = true,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 13042,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 13092,
            aside = true,
        },
        {
            type = "quest",
            id = 13043,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13059,
            aside = true
        },
        {
            type = "quest",
            id = 13091,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13121,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13133,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13137,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13142,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13213,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13214,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13215,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13216,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13217,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13218,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13219,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TeachingTheMeaningOfFear, {
    name = L["TEACHING_THE_MEANING_OF_FEAR"],
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
            id = Chain.WhatsYoursIsMine01,
            upto = 12896,
        },
        {
            type = "chain",
            id = Chain.WhatsYoursIsMine02,
            upto = 12897,
        },
    },
    active = {
        type = "quest",
        ids = {
            13106, 13117, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13235,
    },
    rewards = {
        {
            type = "experience",
            amount = 60650,
        },
        {
            type = "money",
            amount = 206000,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 2250,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 1250,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 13106,
                    restrictions = {
                        type = "quest",
                        id = 13106,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 30631,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13117,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13119,
            x = -1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13120,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13136,
            x = -2,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 13221,
            aside = true,
        },
        {
            type = "quest",
            id = 13134,
            connections = {
                4, 5, 
            },
        },
        {
            type = "quest",
            id = 13138,
            x = -3,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 13140,
            connections = {
                2, 3, 
            },
        },
        {
            visible = false,
            x = 3,
        },
        {
            type = "quest",
            id = 13211,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13152,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13144,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13212,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13220,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13235,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheHeartOfTheLichKingAlliance, {
    name = L["THE_HEART_OF_THE_LICH_KING"],
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
            id = Chain.WhatsYoursIsMine01,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate01,
            upto = 13225,
        },
    },
    active = {
        type = "quest",
        id = 13386,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13403,
    },
    rewards = {
        {
            type = "reputation",
            id = 1050,
            amount = 1225,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 500,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 500,
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
            id = 29799,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13386,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13387,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13388,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13389,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13390,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13391,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13392,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13393,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13394,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13395,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13396,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13397,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13398,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13399,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13400,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13401,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13402,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13403,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheHeartOfTheLichKingHorde, {
    name = L["THE_HEART_OF_THE_LICH_KING"],
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
            id = Chain.WhatsYoursIsMine02,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate02,
            upto = 13224,
        },
    },
    active = {
        type = "quest",
        id = 13258,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13364,
    },
    rewards = {
        {
            type = "reputation",
            id = 1050,
            amount = 575,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 900,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 500,
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
            id = 29795,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13258,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13259,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13262,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13263,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13271,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13275,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13282,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13304,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13305,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13236,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13348,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13349,
            x = -1,
        },
        {
            type = "quest",
            id = 13359,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13360,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13361,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13362,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13363,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13364,
            x = 0,
        },
    },
})
Database:AddChain(Chain.WhatsYoursIsMine01, {
    name = L["WHATS_YOURS_IS_MINE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12887,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12898,
    },
    rewards = {
        {
            type = "experience",
            amount = 22050,
        },
        {
            type = "money",
            amount = 74000,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 860,
        },
    },
    items = {
        {
            type = "npc",
            id = 29799,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12887,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12891,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12893,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12896,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12898,
            x = 0,
        },
    },
})
Database:AddChain(Chain.WhatsYoursIsMine02, {
    name = L["WHATS_YOURS_IS_MINE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12892,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12899,
    },
    rewards = {
        {
            type = "experience",
            amount = 22050,
        },
        {
            type = "money",
            amount = 74000,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 860,
        },
    },
    items = {
        {
            type = "npc",
            id = 29795,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12892,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12891,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12893,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12897,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12899,
            x = 0,
        },
    },
})
Database:AddChain(Chain.SeizingSaronite, {
    name = L["SEIZING_SARONITE"],
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
            id = Chain.TheHeartOfTheLichKingAlliance,
            upto = 13389,
        },
        {
            type = "chain",
            id = Chain.TheHeartOfTheLichKingHorde,
            upto = 13263,
        },
    },
    active = {
        type = "quest",
        id = 13168,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            13172,13174
        },
        count = 2,
    },
    rewards = {
        {
            type = "reputation",
            id = 1098,
            amount = 1260,
        },
    },
    items = {
        {
            type = "npc",
            id = 30946,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13168,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13171,
            x = -2,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 13169,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 13170,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13172,
            x = -1,
        },
        {
            type = "quest",
            id = 13174,
        },
    },
})
Database:AddChain(Chain.MalykrissTheVileHold, {
    name = L["MALYKRISS_THE_VILE_HOLD"],
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
            id = Chain.SeizingSaronite,
        },
    },
    active = {
        type = "quest",
        id = 13155,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13164,
    },
    rewards = {
        {
            type = "reputation",
            id = 1098,
            amount = 2875,
        },
    },
    items = {
        {
            type = "npc",
            id = 30946,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13155,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13143,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13145,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13146,
            x = -2,
            connections = {
                3, 4, 5, 
            },
        },
        {
            type = "quest",
            id = 13147,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13160,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13161,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13162,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13163,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13164,
            x = 0,
        },
    },
})
Database:AddChain(Chain.InDefianceOfTheScourge, {
    name = L["IN_DEFIANCE_OF_THE_SCOURGE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            13036, 13226, 13227, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13157,
    },
    rewards = {
        {
            type = "experience",
            amount = 348050,
        },
        {
            type = "money",
            amount = 550000,
        },
        {
            type = "reputation",
            id = 1037,
            amount = 10,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 1000,
        },
        {
            type = "reputation",
            id = 1106,
            amount = 4360,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 13226,
                    restrictions = {
                        type = "quest",
                        id = 13226,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 13227,
                    restrictions = {
                        type = "quest",
                        id = 13227,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 28179,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13036,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13040,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13008,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13039,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13044,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13045,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13070,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13086,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            ids = {
                13104, 13105, 
            },
            x = 0,
            connections = {
                1, 2, 3, 4, 6, 
            },
        },
        {
            type = "quest",
            id = 13118,
            x = -3,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 13122,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13130,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 13135,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13125,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13110,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13139,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13141,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13157,
            x = 0,
        },
    },
})
Database:AddChain(Chain.MordretharTheDeathGate01, {
    name = L["MORDRETHAR_THE_DEATH_GATE"],
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
            id = Chain.InDefianceOfTheScourge,
        },
    },
    active = {
        type = "quest",
        id = 13225,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {13295, 13298},
        count = 2
    },
    rewards = {
        {
            type = "experience",
            amount = 5450,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 60,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 31241,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13225,
            x = 0,
            connections = {
                1, 2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13341,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 13296,
            aside = true,
        },
        {
            type = "quest",
            id = 13231,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 13232,
            aside = true,
        },
        {
            type = "quest",
            id = 13290,
            aside = true,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13286,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13291,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13287,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13294,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13295,
            x = -1,
        },
        {
            type = "quest",
            id = 13298,
        },
    },
})
Database:AddChain(Chain.MordretharTheDeathGate02, {
    name = L["MORDRETHAR_THE_DEATH_GATE"],
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
            id = Chain.InDefianceOfTheScourge,
        },
    },
    active = {
        type = "quest",
        id = 13224,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {13278, 13279},
        count = 2
    },
    rewards = {
        {
            type = "experience",
            amount = 5450,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 60,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 31240,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13224,
            x = 0,
            connections = {
                1, 2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13340,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 13293,
            aside = true,
        },
        {
            type = "quest",
            id = 13228,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 13230,
            aside = true,
        },
        {
            type = "quest",
            id = 13238,
            aside = true,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13260,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13239,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13237,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13277,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13278,
            x = -1,
        },
        {
            type = "quest",
            id = 13279,
        },
    },
})
Database:AddChain(Chain.AldurtharTheDesolationGate01, {
    name = L["ALDURTHAR_THE_DESOLATION_GATE"],
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
            id = Chain.MordretharTheDeathGate01,
            upto = 13287,
        },
    },
    active = {
        type = "quest",
        id = 13288,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13346,
    },
    rewards = {
    },
    items = {
        {
            visible = false,
            x = -3,
        },
        {
            type = "npc",
            id = 29799,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13288,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13315,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13319,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 13318,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 13320,
            aside = true,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13342,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13345,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13321,
            aside = true,
        },
        {
            type = "quest",
            id = 13346,
            x = 0,
        },
    },
})
Database:AddChain(Chain.AldurtharTheDesolationGate02, {
    name = L["ALDURTHAR_THE_DESOLATION_GATE"],
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
            id = Chain.MordretharTheDeathGate02,
            upto = 13237,
        },
    },
    active = {
        type = "quest",
        id = 13264,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13367,
    },
    rewards = {
    },
    items = {
        {
            type = "npc",
            id = 29795,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13264,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13351,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 13354,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 13352,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 13355,
            aside = true,
            connections = {
                4, 
            },
        },
        {
            visible = false,
            x = -3,
        },
        {
            type = "quest",
            id = 13358,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 13366,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13356,
            aside = true,
        },
        {
            type = "quest",
            id = 13367,
            x = 0,
        },
    },
})
Database:AddChain(Chain.CorpretharTheHorrorGate01, {
    name = L["CORPRETHAR_THE_HORROR_GATE"],
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
            id = Chain.AldurtharTheDesolationGate01,
            upto = 13345,
        },
    },
    active = {
        type = "quest",
        ids = {
            13332, 13346, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {13338, 13339},
        count = 2
    },
    rewards = {
        {
            type = "reputation",
            id = 1050,
            amount = 250,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 1800,
        },
    },
    items = {
        {
            type = "npc",
            id = 29799,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13332,
            x = -1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13346,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13334,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13314,
            aside = true,
        },
        {
            type = "quest",
            id = 13337,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13335,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13338,
            x = -1,
        },
        {
            type = "quest",
            id = 13339,
        },
    },
})
Database:AddChain(Chain.CorpretharTheHorrorGate02, {
    name = L["CORPRETHAR_THE_HORROR_GATE"],
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
            id = Chain.AldurtharTheDesolationGate02,
            upto = 13366,
        },
    },
    active = {
        type = "quest",
        ids = {
            13306, 13367, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {13316, 13328},
        count = 2
    },
    rewards = {
        {
            type = "reputation",
            id = 1085,
            amount = 250,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1098,
            amount = 1800,
        },
    },
    items = {
        {
            type = "npc",
            id = 29795,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13306,
            x = -1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 13367,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13307,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 13313,
            aside = true,
        },
        {
            type = "quest",
            id = 13312,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13329,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 13316,
            x = -1,
        },
        {
            type = "quest",
            id = 13328,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- The Admiral Revealed
        type = "quest",
        id = 12852,
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
            id = Chain.WhatsYoursIsMine01,
        },
        {
            type = "chain",
            id = Chain.WhatsYoursIsMine02,
        },
    },
    active = {
        type = "quest",
        id = 12938,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12814, 12852, },
        count = 2,
    },
    rewards = {
        {
            type = "reputation",
            id = 1098,
            amount = 3495,
        },
    },
    items = {
        {
            type = "npc",
            id = 29343,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12938,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12939,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12943,
            aside = true,
            x = -1,
        },
        {
            type = "npc",
            id = 30056,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12949,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12951,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12992,
            aside = true,
            x = -2,
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 13085,
                    restrictions = {
                        type = "quest",
                        id = 13085,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 30218,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 13084,
            aside = true,
        },
        {
            type = "quest",
            id = 12982,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 12806,
                    restrictions = {
                        type = "quest",
                        id = 12806,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 29344,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12807,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12810,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12838,
            breadcrumb = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12814,
            x = -1,
        },
        {
            type = "quest",
            id = 12839,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12840,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12847,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12852,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Mind Tricks
        type = "quest",
        id = 13308,
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
            id = Chain.InDefianceOfTheScourge,
            lowPriority = true,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate01,
            upto = 13225,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate02,
            upto = 13224,
        },
    },
    active = {
        type = "quest",
        id = 13308,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13308,
    },
    rewards = {
    },
    items = {
        {
            type = "npc",
            id = 31892,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13308,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TempChain22, {
    name = "The Sunreaver Plan",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 14457,
    },
    items = { -- Battered Hilt, Dungeon Chain
        {
            type = "quest",
            id = 14443,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 14444,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 14457,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain30, {
    name = "Preparations for War",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 13419,
    },
    items = {
        { -- Warchief's Command: Icecrown!, Horde Breadcrumb to zone? Requires cold weather flying
            type = "quest",
            id = 49537,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 13419,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain31, {
    name = "Preparations for War",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 13418,
    },
    items = {
        { -- Hero's Call: Icecrown!, Alliance breadcrumb to zone? Requires cold weather flying
            type = "quest",
            id = 49555,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 13418,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain32, {
    name = "The Halls Of Reflection",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 24561,
    },
    items = {
        { -- Dungeon/Raid quest
            type = "quest",
            id = 24560,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24561,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain33, {
    name = "Return To Myralion Sunblaze",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 24558,
    },
    items = {
        { -- Battered Hilt quest
            type = "quest",
            id = 24556,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24451,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24558,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain34, {
    name = "The Silver Covenant's Scheme",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 24557,
    },
    items = {
        { -- Battered Hilt quest
            type = "quest",
            id = 24554,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24555,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24557,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain36, {
    name = "Return To Caladis Brightspear",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 24454,
    },
    items = { -- Battered Hilt
        {
            type = "quest",
            id = 20438,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 20439,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24454,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain43, {
    name = "The Halls Of Reflection",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 24480,
    },
    items = {
        { -- Dungeon/Raid quest
            type = "quest",
            id = 24476,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 24480,
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
        { -- From Their Corpses, Rise!, Daily
            type = "quest",
            id = 12813,
        },
        { -- No Fly Zone, Daily
            type = "quest",
            id = 12815,
        },
        { -- Intelligence Gathering, Daily
            type = "quest",
            id = 12838,
        },
        { -- Leave Our Mark, Daily
            type = "quest",
            id = 12995,
        },
        { -- Shoot 'Em Up, Daily
            type = "quest",
            id = 13069,
        },
        { -- Reading the Bones, Repeatable, Follows 13092
            type = "quest",
            id = 13093,
        },
        { -- I'm Not Dead Yet!, possibly alternative to 13229
        -- requiures https://www.wowhead.com/?quest=13120 and/or https://www.wowhead.com/?quest=13119
            type = "quest",
            id = 13229,
        },
        { -- No Mercy!, Daily PvP
            type = "quest",
            id = 13233,
        },
        { -- Make Them Pay!, Daily PvP
            type = "quest",
            id = 13234,
        },
        { -- Volatility, Daily
            type = "quest",
            id = 13261,
        },
        { -- That's Abominable!, Daily Group
            type = "quest",
            id = 13276,
        },
        { -- Neutralizing the Plague, Daily
            type = "quest",
            id = 13281,
        },
        { -- Assault by Ground, Daily
            type = "quest",
            id = 13284,
        },
        { -- That's Abominable!, Daily
            type = "quest",
            id = 13289,
        },
        { -- The Solution Solution, Daily
            type = "quest",
            id = 13292,
        },
        { -- Neutralizing the Plague, Daily Group
            type = "quest",
            id = 13297,
        },
        { -- Slaves to Saronite, Daily
            type = "quest",
            id = 13300,
        },
        { -- Assault by Ground, Daily
            type = "quest",
            id = 13301,
        },
        { -- Slaves to Saronite, Daily
            type = "quest",
            id = 13302,
        },
        { -- Assault by Air, Daily
            type = "quest",
            id = 13309,
        },
        { -- Assault by Air, Daily
            type = "quest",
            id = 13310,
        },
        { -- Retest Now, Daily
            type = "quest",
            id = 13322,
        },
        { -- Drag and Drop, Daily
            type = "quest",
            id = 13323,
        },
        { -- Blood of the Chosen, Daily
            type = "quest",
            id = 13330,
        },
        { -- Keeping the Alliance Blind, Daily
            type = "quest",
            id = 13331,
        },
        { -- Capture More Dispatches, Daily
            type = "quest",
            id = 13333,
        },
        { -- Blood of the Chosen, Daily
            type = "quest",
            id = 13336,
        },
        { -- Not a Bug, Daily
            type = "quest",
            id = 13344,
        },
        { -- No Rest For The Wicked, Daily
            type = "quest",
            id = 13350,
        },
        { -- Drag and Drop, Daily
            type = "quest",
            id = 13353,
        },
        { -- Retest Now, Daily
            type = "quest",
            id = 13357,
        },
        { -- Not a Bug, Daily
            type = "quest",
            id = 13365,
        },
        { -- No Rest For The Wicked, Daily
            type = "quest",
            id = 13368,
        },
        { -- Amped for Revolt!, Repeatable
            type = "quest",
            id = 13374,
        },
        { -- Watts My Target, Repeatable
            type = "quest",
            id = 13381,
        },
        { -- Let's Get Out of Here!
        -- This quest is mutually exclusive with I'm Not Dead Yet! https://www.wowhead.com/?quest=13229
        -- Which quest you get will depend on which "phase" the area is in when you encounter Father Kamaros.
        -- Replaces 13229 after completing https://www.wowhead.com/?quest=13144?
            type = "quest",
            id = 13481,
        },
        { -- Let's Get Out of Here
        -- Not sure if this quest is missed mark as alliance or if there are 2 different quests depending
        -- on what stage your at for the invasion but I can't get this quest. Instead I got
        -- I'm not dead yet which I did before the invasion started.
            type = "quest",
            id = 13482,
        },
        { -- Takes One to Know One, Maybe alternative to 13260?
            type = "quest",
            id = 14447,
        },
        { -- Takes One to Know One, Maybe alternative to 13260?
            type = "quest",
            id = 14448,
        },
        { -- Battle Plans Of The Kvaldir, Argent Tournament
            type = "quest",
            id = 24442,
        },
        { -- A Victory For The Silver Covenant, Follows https://www.wowhead.com/quest=24595/the-purification-of-queldelar
            type = "quest",
            id = 24795,
        },
        { -- A Victory For The Silver Covenant, Follows https://www.wowhead.com/quest=24553/the-purification-of-queldelar
            type = "quest",
            id = 24796,
        },
        { -- A Victory For The Sunreavers, Follows https://www.wowhead.com/quest=24596/the-purification-of-queldelar
            type = "quest",
            id = 24798,
        },
        { -- A Victory For The Sunreavers, Follows https://www.wowhead.com/quest=24598/the-purification-of-queldelar
            type = "quest",
            id = 24799,
        },
        { -- A Victory For The Sunreavers, Follows https://www.wowhead.com/quest=24594/the-purification-of-queldelar
            type = "quest",
            id = 24800,
        },
        { -- A Victory For The Sunreavers, Follows https://www.wowhead.com/quest=24564/the-purification-of-queldelar
            type = "quest",
            id = 24801,
        },
        { -- Pitch Black Scourgestones, Shadowlands Prepatch
            type = "quest",
            id = 62292,
        },
        { -- Darkened Scourgestones, Shadowlands Prepatch
            type = "quest",
            id = 62293,
        },
        { -- King of the Mountain, Daily PvP
            type = "quest",
            id = 13280,
        },
        { -- King of the Mountain, Daily PvP
            type = "quest",
            id = 13283,
        },
        { -- Vile Like Fire!, Daily
            type = "quest",
            id = 13071,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-Icecrown]],
    items = {
        {
            type = "chain",
            id = Chain.CrusaderBridenbrad,
        },
        {
            type = "chain",
            id = Chain.TheUnthinkable,
        },
        {
            type = "chain",
            id = Chain.Chain01,
        },
        {
            type = "chain",
            id = Chain.TeachingTheMeaningOfFear,
        },
        {
            type = "chain",
            id = Chain.TheHeartOfTheLichKingAlliance,
        },
        {
            type = "chain",
            id = Chain.TheHeartOfTheLichKingHorde,
        },
        {
            type = "chain",
            id = Chain.WhatsYoursIsMine01,
        },
        {
            type = "chain",
            id = Chain.WhatsYoursIsMine02,
        },
        {
            type = "chain",
            id = Chain.SeizingSaronite,
        },
        {
            type = "chain",
            id = Chain.MalykrissTheVileHold,
        },
        {
            type = "chain",
            id = Chain.InDefianceOfTheScourge,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate01,
        },
        {
            type = "chain",
            id = Chain.MordretharTheDeathGate02,
        },
        {
            type = "chain",
            id = Chain.AldurtharTheDesolationGate01,
        },
        {
            type = "chain",
            id = Chain.AldurtharTheDesolationGate02,
        },
        {
            type = "chain",
            id = Chain.CorpretharTheHorrorGate01,
        },
        {
            type = "chain",
            id = Chain.CorpretharTheHorrorGate02,
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
