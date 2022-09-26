local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.BoreanTundra
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.BoreanTundra
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = 924, 923
local MAP_ID = 114
local CONTINENT_ID = 113
local ACHIEVEMENT_ID_ALLIANCE = 33
local ACHIEVEMENT_ID_HORDE = 1358
local LEVEL_RANGE = {10, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 68,
    },
}

Chain.HidingInPlainSight = 30101
Chain.TheFateOfFarseerGrimwalker = 30102
Chain.ToTheAidOfFarshire = 30103
Chain.ReturnOfTheDreadCitadel = 30104
Chain.DEHTA = 30105
Chain.TheScourgeNecrolord = 30106
Chain.TheBlueDragonflight = 30107
Chain.FriendsFromTheSea = 30108
Chain.HellscreamsChampion = 30109
Chain.ParticipantObservation = 30110
Chain.ToTheAidOfTheTaunka = 30111
Chain.AFamilyReunion = 30112
Chain.SomberRealization = 30113
Chain.LastRites = 30114

Chain.Chain01 = 30121
Chain.Chain02 = 30122
Chain.Chain03 = 30123
Chain.Chain04 = 30124
Chain.Chain05 = 30125
Chain.Chain06 = 30126
Chain.Chain07 = 30127
Chain.Chain08 = 30128
Chain.Chain09 = 30129
Chain.Chain10 = 30130

Chain.EmbedChain01 = 30131
Chain.EmbedChain02 = 30132
Chain.EmbedChain03 = 30133
Chain.EmbedChain04 = 30134
Chain.EmbedChain05 = 30135
Chain.EmbedChain06 = 30136
Chain.EmbedChain07 = 30137
Chain.EmbedChain08 = 30138
Chain.EmbedChain09 = 30139
Chain.EmbedChain10 = 30140
Chain.EmbedChain11 = 30141
Chain.EmbedChain12 = 30142
Chain.EmbedChain13 = 30143
Chain.EmbedChain14 = 30144
Chain.EmbedChain15 = 30145
Chain.EmbedChain16 = 30146
Chain.EmbedChain17 = 30147
Chain.EmbedChain18 = 30148
Chain.EmbedChain19 = 30149
Chain.EmbedChain20 = 30150
Chain.EmbedChain21 = 30151
Chain.EmbedChain22 = 30152
Chain.EmbedChain23 = 30153
Chain.EmbedChain24 = 30154
Chain.EmbedChain25 = 30155
Chain.EmbedChain26 = 30156
Chain.EmbedChain27 = 30157
Chain.EmbedChain28 = 30158
Chain.EmbedChain29 = 30159
Chain.EmbedChain30 = 30160
Chain.EmbedChain31 = 30161
Chain.EmbedChain32 = 30162
Chain.EmbedChain33 = 30163

Chain.TempChain32 = 30171

Chain.IgnoreChain01 = 30181
Chain.IgnoreChain02 = 30182
Chain.IgnoreChain03 = 30183
Chain.IgnoreChain04 = 30184

Chain.OtherAlliance = 30197
Chain.OtherHorde = 30198
Chain.OtherBoth = 30199

Database:AddChain(Chain.HidingInPlainSight, {
    name = L["HIDING_IN_PLAIN_SIGHT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11790, 11920, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11794,
    },
    rewards = {
        {
            type = "experience",
            amount = 62350,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 685,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            aside = true,
            x = -2,
        },
        {
            type = "object",
            id = 187851,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            ids = { 11920, 11790, },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11791,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11792,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11793,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11794,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheFateOfFarseerGrimwalker, {
    name = L["THE_FATE_OF_FARSEER_GRIMWALKER"],
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
            11624, 12486, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11638,
    },
    rewards = {
        {
            type = "experience",
            amount = 132050,
        },
        {
            type = "money",
            amount = 335000,
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
            amount = 870,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12486,
                    restrictions = {
                        type = "quest",
                        id = 12486,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 25339,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11624,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11627,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11649,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11629,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11631,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11635,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11639,
            aside = true,
        },
        {
            type = "quest",
            id = 11637,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11638,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ToTheAidOfFarshire, {
    name = L["TO_THE_AID_OF_FARSHIRE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11928, 11901, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11913,12035,11965
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 150850,
        },
        {
            type = "money",
            amount = 141000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1675,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11928,
                    restrictions = {
                        type = "quest",
                        id = 11928,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 26083,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11901,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11902,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            embed = true,
            x = -2,
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
    },
})
Database:AddChain(Chain.ReturnOfTheDreadCitadel, {
    name = L["RETURN_OF_THE_DREAD_CITADEL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11585, 11586, 11595, 11596, 11597, 28711, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11652,
    },
    rewards = {
        {
            type = "experience",
            amount = 202000,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 2555,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 28711,
                    restrictions = {
                        type = "quest",
                        id = 28711,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 25273,
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
                    id = 11586,
                    restrictions = {
                        type = "quest",
                        id = 11586,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 11585,
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
                11596, 11595, 11597, 
            },
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "quest",
            id = 11598,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11611,
            aside = true,
        },
        {
            type = "quest",
            id = 11602,
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
        },
        {
            type = "quest",
            id = 11634,
            x = 0,
            y = 5,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11636,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11642,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11643,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11644,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11651,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11652,
            x = 0,
        },
    },
})
Database:AddChain(Chain.DEHTA, {
    name = L["DEHTA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 70,
        },
    },
    active = {
        type = "quest",
        ids = {
            11864, 11892, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11892,
    },
    rewards = {
        {
            type = "experience",
            amount = 242700,
        },
        {
            type = "money",
            amount = 100000,
        },
        {
            type = "reputation",
            id = 942,
            amount = 3120,
        },
    },
    items = {
        {
            type = "npc",
            id = 25809,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11864,
            x = 0,
            connections = {
                1, 2, 3, 4, 5, 
            },
        },
        {
            type = "quest",
            id = 11866,
            aside = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
            x = -3,
            connections = {
                [2] = {
                    4, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            connections = {
                [3] = {
                    3, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            connections = {
                [5] = {
                    2, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            embed = true,
            connections = {
                [4] = {
                    1, 
                }, 
            },
        },
        {
            type = "quest",
            id = 11892,
            x = 0,
            y = 8,
        },
    },
})
Database:AddChain(Chain.TheScourgeNecrolord, {
    name = L["THE_SCOURGE_NECROLORD"],
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
            id = Chain.ReturnOfTheDreadCitadel,
            upto = 11598,
        },
    },
    active = {
        type = "quest",
        id = 11614,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11705,
    },
    rewards = {
        {
            type = "experience",
            amount = 169950,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 2020,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25394,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11614,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11615,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11616,
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
            x = -3,
        },
        {
            type = "quest",
            id = 11618,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11686,
            x = -1,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 11676,
            aside = true,
        },
        {
            visible = false,
        },
        {
            type = "quest",
            id = 11703,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11705,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11709,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11711,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11714,
            aside = true,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheBlueDragonflight, {
    name = L["THE_BLUE_DRAGONFLIGHT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = {
            11576, 11587, 11912, 11918, 11910, 11900, 11941, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12728,11733,11969,11931,11914
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 458400,
        },
        {
            type = "money",
            amount = 1270400,
        },
        {
            type = "reputation",
            id = 1090,
            amount = 3070,
            restrictions = 924,
        },
        {
            type = "reputation",
            id = 1091,
            amount = 2710,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain12,
            embed = true,
        },
        {
            type = "npc",
            id = 26110,
            x = -3,
            connections = {
                3, 4, 
            },
        },
        {
            type = "npc",
            id = 26117,
            x = 0,
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 25314,
            x = 2,
            connections = {
                4, 5, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            aside = true,
            embed = true,
            x = -4,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
        },
        {
            type = "quest",
            id = 11910,
            aside = true,
        },
        {
            type = "quest",
            id = 11900,
            x = 2,
            aside = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
            x = 0,
            y = 17,
        },
    },
})
Database:AddChain(Chain.FriendsFromTheSea, {
    name = L["FRIENDS_FROM_THE_SEA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11613, 11949, 12141, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11626,11968
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 201650,
        },
        {
            type = "money",
            amount = 136000,
        },
        {
            type = "reputation",
            id = 1073,
            amount = 2300,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain17,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
        },
    },
})
Database:AddChain(Chain.HellscreamsChampion, {
    name = L["HELLSCREAMS_CHAMPION"],
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
            id = Chain.ReturnOfTheDreadCitadel,
        },
        {
            type = "chain",
            id = Chain.TheScourgeNecrolord,
        },
        {
            type = "chain",
            id = Chain.Chain01,
        },
    },
    active = {
        type = "quest",
        id = 11916,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11916,
    },
    rewards = {
        {
            type = "experience",
            amount = 30150,
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
            id = 25237,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11916,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ParticipantObservation, {
    name = L["PARTICIPANT_OBSERVATION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 69,
        },
    },
    active = {
        type = "quest",
        ids = {
            11571, 11702, 11704, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11570,11569,11566,11564,11561
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 190200,
        },
        {
            type = "money",
            amount = 476000,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1110,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11704,
                    restrictions = {
                        type = "quest",
                        id = 11704,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 11702,
                    restrictions = {
                        type = "quest",
                        id = 11702,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 25197,
                }
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11571,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11559,
            x = 0,
            connections = {
                1, 2, 3, 4, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain21,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            embed = true,
        },
    },
})
Database:AddChain(Chain.ToTheAidOfTheTaunka, {
    name = L["TO_THE_AID_OF_THE_TAUNKA"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11674, 11888, 11890, 11684, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            11689,11906,11907,11909,11706
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 344250,
        },
        {
            type = "money",
            amount = 902000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 4410,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain24,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            embed = true,
            x = 3,
        },
    },
})
Database:AddChain(Chain.AFamilyReunion, {
    name = L["A_FAMILY_REUNION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            28709, 11672, 11599, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12088,
    },
    rewards = {
        {
            type = "experience",
            amount = 175400,
        },
        {
            type = "money",
            amount = 94000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1770,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 28709,
                    restrictions = {
                        type = "quest",
                        id = 28709,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 25307,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11672,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11727,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11797,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11889,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11897,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 11927,
                    restrictions = {
                        type = "quest",
                        id = 11927,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 25251,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11599,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11600,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11601,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11603,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11604,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11932,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12086,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11944,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12088,
            x = 0,
        },
    },
})
Database:AddChain(Chain.SomberRealization, {
    name = L["SOMBER_REALIZATION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11881, 11628, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11930,
    },
    rewards = {
        {
            type = "experience",
            amount = 254750,
        },
        {
            type = "money",
            amount = 629000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 2360,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 260,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25849,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 11881,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11893,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11894,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "npc",
            id = 24703,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11628,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11630,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11633,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 11641,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 11640,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11647,
            aside = true,
        },
        {
            type = "quest",
            id = 11898,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11929,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11930,
            x = 0,
        },
    },
})
Database:AddChain(Chain.LastRites, {
    name = L["LAST_RITES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11956,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12019,
    },
    rewards = {
        {
            type = "experience",
            amount = 91150,
        },
        {
            type = "money",
            amount = 200000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1250,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 26170,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11956,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11938,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11942,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12019,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Trophies of Gammoth
        type = "quest",
        id = 11722,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11716,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 11722,
    },
    rewards = {
        {
            type = "experience",
            amount = 79400,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 920,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25381,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11716,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11717,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11719,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11720,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11721,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11722,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Into the Mist
        type = "quest",
        id = 11655,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11655, 11660, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {11661, 11656},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 105550,
        },
        {
            type = "money",
            amount = 141000,
        },
        {
            type = "reputation",
            id = 1073,
            amount = 1000,
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
            visible = false,
            x = -3,
        },
        {
            type = "npc",
            id = 25476,
            x = 0,
            connections = {
                2, 3
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
            embed = true,
            aside = true,
            x = 3,
        },
        {
            type = "quest",
            id = 11660,
            x = -1,
            y = 1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11655,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11661,
            x = -1,
            -- connections = {
            --     2, 
            -- },
        },
        {
            type = "quest",
            id = 11656,
            -- connections = {
            --     1, 
            -- },
        },
        -- @TODO Might be a breadcrumb to the other area
        -- {
        --     type = "quest",
        --     id = 11662,
        --     x = 0,
        -- },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- The Gearmaster
        type = "quest",
        id = 11798,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            11707, 11708, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11798,
    },
    rewards = {
        {
            type = "experience",
            amount = 99800,
        },
        {
            type = "money",
            amount = 335000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1320,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11707,
                    restrictions = {
                        type = "quest",
                        id = 11707,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 25590,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11708,
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain29,
            embed = true,
            aside = true,
            x = 2,
        },
        {
            type = "quest",
            id = 11712,
            x = 0,
            y = 2,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11788,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11798,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Might As Well Wipe Out the Scourge
        type = "quest",
        id = 11698,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.Chain03,
            upto = 11708,
        },
    },
    active = {
        type = "quest",
        id = 11710,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 11701,
    },
    rewards = {
        {
            type = "experience",
            amount = 149950,
        },
        {
            type = "money",
            amount = 282000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1870,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25702,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11710,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11692,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11693,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11694,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11697,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11698,
            aside = true,
        },
        {
            type = "quest",
            id = 11699,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11700,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11701,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain05, {
    name = { -- Dirty, Stinkin' Snobolds!
        type = "quest",
        id = 11645,
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
        {
            type = "chain",
            id = Chain.Chain03,
            upto = 11708,
        },
    },
    active = {
        type = "quest",
        id = 11645,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11670,
    },
    rewards = {
        {
            type = "experience",
            amount = 131200,
        },
        {
            type = "money",
            amount = 388000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1700,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25477,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11645,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11650,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11653,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11658,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain30,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 11670,
            x = -1,
            y = 5,
        },
    },
})
Database:AddChain(Chain.Chain06, {
    name = { -- Finding Pilot Tailspin
        type = "quest",
        id = 11725,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.Chain03,
            upto = 11712,
        },
    },
    active = {
        type = "quest",
        id = 11725,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 11873,
    },
    rewards = {
        {
            type = "experience",
            amount = 107550,
        },
        {
            type = "money",
            amount = 282000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1360,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25590,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11725,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11726,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11728,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11795,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11796,
            x = 0,
            connections = {
                1,
            },
        },
        {
            type = "quest",
            id = 11873,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain07, {
    name = { -- Deploy the Shake-n-Quake!
        type = "quest",
        id = 11723,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 68,
        },
        {
            type = "chain",
            id = Chain.Chain03,
            upto = 11712,
            lowPriority = true,
        },
        {
            type = "chain",
            id = Chain.Chain06,
            upto = 11796,
        },
    },
    active = {
        type = "quest",
        id = 11713,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 11723,
    },
    rewards = {
        {
            type = "experience",
            amount = 85450,
        },
        {
            type = "money",
            amount = 282000,
        },
        {
            type = "reputation",
            id = 1050,
            amount = 1100,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 25780,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11713,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11715,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11718,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11723,
            x = 0,
        },
    }
})
Database:AddChain(Chain.Chain08, {
    name = { -- The Honored Ancestors
        type = "quest",
        id = 11605,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {11612, 11605},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {11623, 11610},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 147200,
        },
        {
            type = "money",
            amount = 400000,
        },
        {
            type = "reputation",
            id = 1073,
            amount = 1950,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain31,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain32,
            embed = true,
        },
    }
})
Database:AddChain(Chain.Chain09, {
    name = BtWQuests_GetAreaName(4127), -- Steeljaw's Caravan
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {11591, 11592, 11593, 11594},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {11592, 11593, 11594},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 65600,
        },
        {
            type = "money",
            amount = 194000,
        },
        {
            type = "reputation",
            id = 1064,
            amount = 350,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 1085,
            amount = 850,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11591,
                    restrictions = {
                        type = "quest",
                        id = 11591,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 25336,
                },
            },
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "npc",
            id = 25335,
            x = 2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 11593,
            x = -2,
        },
        {
            type = "quest",
            id = 11594,
        },
        {
            type = "quest",
            id = 11592,
        },
    }
})
Database:AddChain(Chain.Chain10, {
    name = { -- Massive Moth Omelet?
        type = "quest",
        id = 11724,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 11724,
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        id = 11724,
    },
    rewards = {
        {
            type = "experience",
            amount = 20100,
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
            id = 187905,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11724,
            x = 0,
        },
    }
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25825,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11789,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11913,
    },
    items = {
        {
            type = "quest",
            id = 11913,
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
        id = 12035,
    },
    items = {
        {
            type = "quest",
            id = 11903,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11904,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11962,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11963,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11965,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11965,
    },
    items = {
        {
            type = "quest",
            id = 11908,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12035,
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
        id = 11608,
    },
    items = { -- Apparently requires 11596
        {
            type = "quest",
            id = 11606,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11608,
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
        id = 29309,
    },
    items = {
        {
            type = "kill",
            id = 25453,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11632,
            x = 0,
        },
    }
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25812,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11884,
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
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25811,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11865,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11868,
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
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25810,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11869,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11870,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11871,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11872,
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
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25809,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11876,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11878,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11879,
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
        id = 11690,
    },
    items = {
        {
            type = "npc",
            id = 25607,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11688,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11690,
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
        id = 12728,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11575,
                    restrictions = {
                        type = "quest",
                        id = 11575,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11574,
                    restrictions = {
                        type = "quest",
                        id = 11574,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 25262,
                }
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain33,
            embed = true,
        },
        {
            type = "quest",
            id = 11587,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11590,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11646,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11648,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11663,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11671,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11679,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11680,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11681,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11682,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11733,
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
        id = 29309,
    },
    items = {
        {
            type = "quest",
            id = 13412,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13413,
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
        id = 11733,
    },
    items = {
        {
            type = "quest",
            id = 11912,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11914,
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
        id = 11969,
    },
    items = {
        {
            type = "quest",
            id = 11918,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11936,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11919,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11931,
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
        id = 11931,
    },
    items = {
        {
            type = "kill",
            id = 25719,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11941,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11943,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11946,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11951,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11957,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11967,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11969,
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
        id = 29309,
    },
    items = {
        {
            type = "kill",
            id = 25636,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12471,
            x = 0,
        },
    }
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11626,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12141,
                    restrictions = {
                        type = "quest",
                        id = 12141,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 25435,
                }
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11613,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11619,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11620,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11625,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11626,
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
        id = 11968,
    },
    items = {
        {
            type = "npc",
            id = 26169,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11949,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11950,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11961,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11968,
            x = 0,
            connections = {
                
            },
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11561,
    },
    items = {
        {
            type = "npc",
            id = 25208,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11570,
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
        id = 11570,
    },
    items = {
        {
            type = "npc",
            id = 25199,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11561,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11566,
    },
    items = {
        {
            type = "npc",
            id = 25197,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11560,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11562,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11563,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11564,
        },
        {
            type = "quest",
            id = 11565,
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11566,
            x = -1,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11564,
    },
    items = {
        {
            type = "npc",
            id = 28375,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11569,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11689,
    },
    items = {
        {
            type = "npc",
            id = 25602,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11674,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11675,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11677,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11678,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11687,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11689,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11907,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11888,
                },
                {
                    type = "npc",
                    id = 25982,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11890,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11895,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 11906,
            x = 0,
        },
        {
            type = "quest",
            id = 11899,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11896,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11909,
            x = -1,
        },
        {
            type = "quest",
            id = 11907,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 11706,
    },
    items = {
        {
            type = "npc",
            id = 24702,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11684,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11685,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11695,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11706,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25984,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11887,
            x = 0,
        },
    }
})
Database:AddChain(Chain.EmbedChain28, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25504,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11664,
            x = 0,
        },
    }
})
Database:AddChain(Chain.EmbedChain29, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11730,
    },
    items = {
        {
            type = "kill",
            id = 25758,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11729,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11730,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain30, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "npc",
            id = 25589,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11673,
            x = 0,
        },
    }
})
Database:AddChain(Chain.EmbedChain31, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11623,
    },
    items = {
        {
            type = "npc",
            id = 25292,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11612,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11617,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11623,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain32, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11610,
    },
    items = {
        {
            type = "object",
            id = 187565,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11605,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11607,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11609,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11610,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain33, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11914,
    },
    items = {
        {
            type = "npc",
            id = 25291,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11576,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11582,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12728,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TempChain32, {
    name = "Shatter the Orbs!",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 11659,
    },
    items = {
        {
            type = "quest",
            id = 11654,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 11659,
            x = 0,
        },
    },
})

Database:AddChain(Chain.IgnoreChain01, {
    name = "The Stuff of Legends",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29309,
    },
    items = {
        {
            type = "quest",
            id = 29308,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 29309,
            x = 0,
        },
    },
})
Database:AddChain(Chain.IgnoreChain02, {
    name = "The Stuff of Legends",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29312,
    },
    items = {
        {
            type = "quest",
            id = 29307,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 29312,
            x = 0,
        },
    },
})
Database:AddChain(Chain.IgnoreChain03, {
    name = "Alignment",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29285,
    },
    items = {
        {
            type = "quest",
            id = 29270,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 29285,
            x = 0,
        },
    },
})
Database:AddChain(Chain.IgnoreChain04, {
    name = "Actionable Intelligence",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 29225,
    },
    items = {
        {
            type = "quest",
            id = 29194,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 29225,
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
        { -- The Tablet of Leviroth, Obsolete
            type = "quest",
            id = 11621,
        },
        { -- Secrets of Riplash, Obsolete
            type = "quest",
            id = 11622,
        },
        { -- Fallen Necropolis, apparently requires chain starting from 11674, lacks room
            type = "quest",
            id = 11683,
        },
        { -- Can't Get Ear-nough..., repeatable
            type = "quest",
            id = 11867,
        },
        { -- ?????, obsolete
            type = "quest",
            id = 11939,
        },
        { -- Drake Hunt, Daily
            type = "quest",
            id = 11940,
        },
        { -- Preparing for the Worst, Daily
            type = "quest",
            id = 11945,
        },
        { -- Veehja's Revenge, obsolete
            type = "quest",
            id = 12490,
        },
        { -- Aces High!, Dungeon Daily
            type = "quest",
            id = 13414,
        },
        { -- Nordrassil's Bough, Dragonwrath, Tarecgosa's Rest.
            type = "quest",
            id = 29239,
        },
        { -- Emergency Extraction, Dragonwrath, Tarecgosa's Rest.
            type = "quest",
            id = 29240,
        },
        { -- At One, Dragonwrath, Tarecgosa's Rest.
            type = "quest",
            id = 29269,
        },
        { -- A Gift From Your Tadpole, Weekly
            type = "quest",
            id = 46049,
        },
        { -- Adopt a Tadpole, Micro holiday
            type = "quest",
            id = 46061,
        },
        { -- A Tadpole's Request, Micro holiday
            type = "quest",
            id = 46062,
        },
        { -- The Ways of the World, Micro holiday
            type = "quest",
            id = 46064,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-BoreanTundra]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.HidingInPlainSight,
        },
        {
            type = "chain",
            id = Chain.TheFateOfFarseerGrimwalker,
        },
        {
            type = "chain",
            id = Chain.ToTheAidOfFarshire,
        },
        {
            type = "chain",
            id = Chain.ReturnOfTheDreadCitadel,
        },
        {
            type = "chain",
            id = Chain.DEHTA,
        },
        {
            type = "chain",
            id = Chain.TheScourgeNecrolord,
        },
        {
            type = "chain",
            id = Chain.TheBlueDragonflight,
        },
        {
            type = "chain",
            id = Chain.FriendsFromTheSea,
        },
        {
            type = "chain",
            id = Chain.HellscreamsChampion,
        },
        {
            type = "chain",
            id = Chain.ParticipantObservation,
        },
        {
            type = "chain",
            id = Chain.ToTheAidOfTheTaunka,
        },
        {
            type = "chain",
            id = Chain.AFamilyReunion,
        },
        {
            type = "chain",
            id = Chain.SomberRealization,
        },
        {
            type = "chain",
            id = Chain.LastRites,
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
        {
            type = "chain",
            id = Chain.Chain08,
        },
        {
            type = "chain",
            id = Chain.Chain09,
        },
        {
            type = "chain",
            id = Chain.Chain10,
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

-- Database:AddContinentItems(CONTINENT_ID, {})
