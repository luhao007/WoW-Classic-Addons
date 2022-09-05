local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.HellfirePeninsula;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.HellfirePeninsula;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1944
local ACHIEVEMENT_ID_ALLIANCE = 1189
local ACHIEVEMENT_ID_HORDE = 1271
local CONTINENT_ID = 1945
local LEVEL_RANGE = {10, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 58,
    },
}

Chain.DisruptTheBurningLegionAlliance = 20101
Chain.OverthrowTheOverlord = 20102
Chain.InSearchOfSedai = 20103
Chain.TheExorcismOfColonelJules = 20104
Chain.DrillTheDrillmaster = 20105
Chain.TempleOfTelhamat = 20106
Chain.GreenButNotOrcsAlliance = 20107
Chain.CenarionPostAlliance = 20108

Chain.DisruptTheBurningLegionHorde = 20111
Chain.CruelsIntentions = 20112
Chain.TheHandOfKargath = 20113
Chain.SpinebreakerPost = 20114
Chain.TheMaghar = 20115
Chain.FalconWatch = 20116
Chain.GreenButNotOrcsHorde = 20117
Chain.CenarionPostHorde = 20118

Chain.Chain01 = 20121
Chain.Chain02 = 20122
Chain.Chain03 = 20123
Chain.Chain04 = 20124
Chain.Chain05 = 20125
Chain.Chain06 = 20126
Chain.Chain07 = 20127
Chain.Chain08 = 20128
Chain.Chain09 = 20129

Chain.EmbedChain01 = 20131
Chain.EmbedChain02 = 20132
Chain.EmbedChain03 = 20133
Chain.EmbedChain04 = 20134
Chain.EmbedChain05 = 20135
Chain.EmbedChain06 = 20136
Chain.EmbedChain07 = 20137
Chain.EmbedChain08 = 20138
Chain.EmbedChain09 = 20139
Chain.EmbedChain10 = 20140
Chain.EmbedChain11 = 20141
Chain.EmbedChain12 = 20142
Chain.EmbedChain13 = 20143
Chain.EmbedChain14 = 20144
Chain.EmbedChain15 = 20145
Chain.EmbedChain16 = 20146
Chain.EmbedChain17 = 20147
Chain.EmbedChain18 = 20148
Chain.EmbedChain19 = 20149
Chain.EmbedChain20 = 20150
Chain.EmbedChain21 = 20151
Chain.EmbedChain22 = 20152
Chain.EmbedChain23 = 20153
Chain.EmbedChain24 = 20154
Chain.EmbedChain25 = 20155
Chain.EmbedChain26 = 20156
Chain.EmbedChain27 = 20157
Chain.EmbedChain28 = 20158
Chain.EmbedChain29 = 20159
Chain.EmbedChain30 = 20160
Chain.EmbedChain31 = 20161
Chain.EmbedChain32 = 20162

Chain.UnusedChain01 = 20163
Chain.UnusedChain02 = 20164

Database:AddChain(Chain.DisruptTheBurningLegionAlliance, {
    name = L["DISRUPT_THE_BURNING_LEGION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.DisruptTheBurningLegionHorde,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10141,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10397,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                88625, 85875, 74725, 57035, 39200, 
            },
            minLevel = 65,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                78000, 100000, 135000, 145000, 155000, 165000, 175000, 185000, 195000, 205000, 220000, 
            },
            minLevel = 60,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 2385,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16819,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10141,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10142,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10143,
            x = 3,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain01,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 10144,
            x = 3,
            y = 4,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10146,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10340,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10344,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10163,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10382,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10394,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10396,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10397,
            x = 3,
        },
    },
})
Database:AddChain(Chain.OverthrowTheOverlord, {
    name = L["OVERTHROW_THE_OVERLORD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.CruelsIntentions,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10395,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10399, 10400},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                30200, 27300, 24350, 18300, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                107000, 114000, 116000, 124000, 132000, 140000, 148000, 156000, 164000, 176000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 1000,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "kill",
            id = 19298,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10395,
            x = 3,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10399,
            x = 2,
        },
        {
            type = "quest",
            id = 10400,
        },
    },
})
Database:AddChain(Chain.InSearchOfSedai, {
    name = L["IN_SEARCH_OF_SEDAI"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheHandOfKargath,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        id = 9390,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9545,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                39900, 38900, 30900, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "reputation",
            id = 930,
            amount = 660,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16834,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9390,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9423,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9424,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9543,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9430,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9545,
            x = 3,
        },
    },
})
Database:AddChain(Chain.TheExorcismOfColonelJules, {
    name = L["THE_EXORCISM_OF_COLONEL_JULES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.SpinebreakerPost,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10160,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10935,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                83500, 79450, 75400, 69450, 52800, 38080, 25380, 
            },
            minLevel = 63,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                127000, 160000, 216000, 232000, 248000, 264000, 280000, 296000, 312000, 328000, 352000, 
            },
            minLevel = 60,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 1850,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16819,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10160,
            x = 3,
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
            id = 10482,
            x = 3,
            y = 2,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10483,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10484,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10485,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10903,
            x = 3,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10909,
            x = 2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10916,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10935,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "chain",
            id = Chain.DrillTheDrillmaster,
            aside = true,
            x = 3,
        },
    },
})
Database:AddChain(Chain.DrillTheDrillmaster, {
    name = L["DRILL_THE_DRILLMASTER"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheMaghar,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "chain",
            id = Chain.TheExorcismOfColonelJules,
        },
    },
    active = {
        type = "quest",
        id = 10936,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10937,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                13575, 13375, 10675, 7940, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                54000, 58000, 62000, 66000, 70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 1000,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 22430,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10936,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10937,
            x = 3,
        },
    },
})
Database:AddChain(Chain.TempleOfTelhamat, {
    name = L["TEMPLE_OF_TELHAMAT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.FalconWatch,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        }
    },
    active = {
        type = "quest",
        ids = {9490, 9399, 9426, 9383},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9399, 9490, 9427, 9383},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                63900, 57900, 45100, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                143000, 145000, 155000, 165000, 175000, 185000, 195000, 205000, 220000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 930,
            amount = 1600,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            x = 4,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain05,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain06,
            aside = true,
            x = 0,
            y = 2,
            embed = true,
        },
    },
})
Database:AddChain(Chain.GreenButNotOrcsAlliance, {
    name = L["GREEN_BUT_NOT_ORCS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.GreenButNotOrcsHorde,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9349, 10161, 10236},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {
            9356, 9351, 10630, 
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                88200, 70650, 53100, 35100, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                180000, 243000, 261000, 279000, 297000, 315000, 333000, 351000, 369000, 396000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain07,
            x = 1,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
        },
    },
})
Database:AddChain(Chain.CenarionPostAlliance, {
    name = L["CENARION_POST"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.CenarionPostHorde,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 61,
        },
    },
    active = {
        type = "quest",
        ids = {10134, 10442, 10443, 9372},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10255, 10351},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                73200, 71250, 69300, 54550, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                241000, 248000, 250000, 267200, 284400, 301600, 318800, 336000, 353200, 378400, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1785,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            x = 0,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
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
            id = Chain.EmbedChain14,
            aside = true,
            x = 4,
            y = 3,
            embed = true,
        },
    },
})

Database:AddChain(Chain.DisruptTheBurningLegionHorde, {
    name = L["DISRUPT_THE_BURNING_LEGION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.DisruptTheBurningLegionAlliance,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10121,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10388,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                45425, 42875, 33825, 24720, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                27000, 29000, 31000, 33000, 35000, 37000, 39000, 41000, 44000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 947,
            amount = 1435,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 3230,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10121,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10123,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10124,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10208,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10129,
            x = 3,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10162,
            aside = true,
            x = 2,
        },
        {
            type = "quest",
            id = 10388,
            connections = {
                1, 
            },
        },
        {
            type = "chain",
            id = Chain.CruelsIntentions,
            aside = true,
            x = 3,
        },
    },
})
Database:AddChain(Chain.CruelsIntentions, {
    name = L["CRUELS_INTENTIONS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.OverthrowTheOverlord,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionHorde,
        },
    },
    active = {
        type = "quest",
        id = 10390,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10136, 10389},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                59600, 50850, 42050, 30000, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                167000, 195000, 203000, 217000, 231000, 245000, 259000, 273000, 287000, 308000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 947,
            amount = 1750,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 3230,
            x = 3,
            y = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 10390,
            x = 3,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10391,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10392,
            x = 3,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10136,
            x = 2,
        },
        {
            type = "quest",
            id = 10389,
        },
    },
})
Database:AddChain(Chain.TheHandOfKargath, {
    name = L["THE_HAND_OF_KARGATH"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.InSearchOfSedai,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10450,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10876,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                63650, 58850, 48750, 38550, 25810, 
            },
            minLevel = 65,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                145800, 173600, 214000, 225200, 241000, 256200, 272000, 287200, 303000, 318200, 341600, 
            },
            minLevel = 60,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 947,
            amount = 2200,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 21256,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10450,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10449,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10242,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10538,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10835,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10864,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10838,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10875,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10876,
            x = 3,
        },
    },
})
Database:AddChain(Chain.SpinebreakerPost, {
    name = L["SPINEBREAKER_POST"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheExorcismOfColonelJules,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {10809, 10278, 10229},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10834, 10295, 10258},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                107125, 105225, 89475, 70175, 48440, 
            },
            minLevel = 65,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                195000, 217000, 259000, 276000, 295000, 314000, 333000, 352000, 371000, 390000, 418000, 
            },
            minLevel = 60,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 947,
            amount = 2685,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain16,
            x = 0,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain17,
            x = 4,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            aside = true,
            x = 6,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            x = 6,
            y = 2,
            embed = true,
        },
    },
})
Database:AddChain(Chain.TheMaghar, {
    name = L["THE_MAGHAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.DrillTheDrillmaster,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionHorde,
            upto = 10124,
        },
    },
    active = {
        type = "quest",
        id = 9400,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9406,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                45200, 36200, 27200, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                27000, 29000, 31000, 33000, 35000, 37000, 39000, 41000, 44000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 941,
            amount = 350,
            restrictions = 923,
        },
        {
            type = "reputation",
            id = 947,
            amount = 825,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 3230,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9400,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9401,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9405,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9410,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9406,
            x = 3,
        },
    },
})
Database:AddChain(Chain.FalconWatch, {
    name = L["FALCON_WATCH"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TempleOfTelhamat,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        ids = {9498, 9499, 9340, 9397, 9366, 9374},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9391, 9397, 9472, 9370},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                160500, 141500, 109300, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                404000, 421000, 450000, 479000, 508000, 537000, 566000, 595000, 638000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 911,
            amount = 3625,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain20,
            aside = true,
            x = 0,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain21,
            x = 2,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            x = 4,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            aside = true,
            x = 6,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
            aside = true,
            x = 4,
            y = 2,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
            aside = true,
            x = 6,
            y = 2,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            aside = true,
            x = 0,
            y = 5,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            x = 2,
            y = 5,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
            x = 4,
            y = 5,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain29,
            aside = true,
            x = 6,
            y = 5,
            embed = true,
        },
    },
})
Database:AddChain(Chain.GreenButNotOrcsHorde, {
    name = L["GREEN_BUT_NOT_ORCS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.GreenButNotOrcsAlliance,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9349, 10161, 10236},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9356, 9351, 10630},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                88200, 70650, 53100, 35100, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                180000, 243000, 261000, 279000, 297000, 315000, 333000, 351000, 369000, 396000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain07,
            x = 1,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
        },
    },
})
Database:AddChain(Chain.CenarionPostHorde, {
    name = L["CENARION_POST"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.CenarionPostAlliance,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 61,
        },
    },
    active = {
        type = "quest",
        ids = {10134, 10442, 10443, 9372},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10255, 10351},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                73200, 71250, 69300, 54550, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                241000, 248000, 250000, 267200, 284400, 301600, 318800, 336000, 353200, 378400, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1785,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            x = 0,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
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
            id = Chain.EmbedChain14,
            aside = true,
            x = 4,
            y = 3,
            embed = true,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Through the Dark Portal
        type = "quest",
        id = 10119,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    alternatives = {
        Chain.Chain02,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {10119, 28708, 10288},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10254,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                5750, 5575, 4375, 3280, 2090, 
            },
            minLevel = 65,
            maxLevel = 69,
        },
        {
            type = "reputation",
            id = 946,
            amount = 500,
            restrictions = 924,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10119,
                    restrictions = {
                        type = "quest",
                        id = 10119,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 28708,
                    restrictions = {
                        type = "quest",
                        id = 28708,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 19229,
                },
            },
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10288,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10140,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10254,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Through the Dark Portal
        type = "quest",
        id = 9407
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    alternatives = {
        Chain.Chain01,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {9407, 28705, 10120},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10291,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                9550, 8600, 6650, 4800, 2850, 
            },
            minLevel = 65,
            maxLevel = 69,
        },
        {
            type = "reputation",
            id = 947,
            amount = 500,
            restrictions = 923,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9407,
                    restrictions = {
                        type = "quest",
                        id = 9407,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 28705,
                    restrictions = {
                        type = "quest",
                        id = 28705,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 19253,
                },
            },
            x = 3,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10120,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10289,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10291,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Honor Guard Wesilow
        type = "npc",
        id = 16827,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "quest",
            id = 10483,
        },
    },
    active = {
        type = "quest",
        id = 10050,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10057,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                29400, 23550, 17700, 11700, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                60000, 81000, 87000, 93000, 99000, 105000, 111000, 117000, 123000, 132000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16827,
            x = 3,
            y = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain30,
            aside = true,
            x = 5,
            y = 0,
            embed = true,
        },
        {
            type = "quest",
            id = 10050,
            x = 3,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10057,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = L["FOR_THE_HORDE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10086,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10087,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                19600, 15700, 11800, 7800, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                40000, 54000, 58000, 62000, 66000, 70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 947,
            amount = 500,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 21283,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10086,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10087,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain05, {
    name = { -- Arzeth's Demise
        type = "quest",
        id = 10369,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        ids = {10403, 10367},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10369,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                32700, 26200, 19650, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                54000, 58000, 62000, 66000, 70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10403,
                    restrictions = {
                        type = "quest",
                        id = 10403,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 19361,
                },
            },
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10367,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10368,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10369,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain06, {
    name = { -- Warp-Scryer Kryv
        type = "npc",
        id = 16839,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "quest",
            id = 10483,
        },
    },
    active = {
        type = "quest",
        id = 10047,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10093,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                12400, 10450, 8500, 6000, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "reputation",
            id = 930,
            amount = 250,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16839,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10047,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10093,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain07, {
    name = { -- Foreman Biggums
        type = "npc",
        id = 16837,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "quest",
            id = 10483,
        },
    },
    active = {
        type = "quest",
        ids = {
            9355, 10079, 
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10099,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                29400, 23550, 17700, 11700, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                60000, 81000, 87000, 93000, 99000, 105000, 111000, 117000, 123000, 132000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 750,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 16837,
            x = 3,
            y = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9355,
            x = 2,
            aside = true,
        },
        {
            type = "quest",
            id = 10079,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10099,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain08, {
    name = { -- Grelag
        type = "npc",
        id = 16858,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9345,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10213,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                12200, 9750, 7350, 4850, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "reputation",
            id = 947,
            amount = 250,
            restrictions = 923,
        },
    },
    items = {
        {
            type = "npc",
            id = 16858,
            x = 3,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9345,
            x = 3,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10213,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain09, {
    name = { -- The Longbeards
        type = "quest",
        id = 9558,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {9563, 9558, 9417, 9385},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9420, 9417, 9385},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                51300, 47300, 37000, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                114000, 116000, 124000, 132000, 140000, 148000, 156000, 164000, 176000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 946,
            amount = 1000,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain31,
            x = 0,
            y = 0,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
            x = 2,
            y = 2,
            embed = true,
            aside = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain32,
            x = 4,
            y = 1,
            embed = true,
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
        id = 10895,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10895,
    },
    items = {
        {
            type = "npc",
            id = 19409,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10895,
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
        id = 10055,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10078,
    },
    items = {
        {
            type = "npc",
            id = 21209,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10055,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10078,
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
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        ids = {
            9399, 9490, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            9490, 9399, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 16799,
            x = 1,
            y = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9490,
            x = 0,
        },
        {
            type = "quest",
            id = 9399,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        id = 9426,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9427,
    },
    items = {
        {
            type = "npc",
            id = 16796,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9426,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9427,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 61,
        },
    },
    active = {
        type = "quest",
        id = 9383,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9383,
    },
    items = {
        {
            type = "npc",
            id = 17006,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9383,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 60,
        },
    },
    active = {
        type = "quest",
        id = 9398,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9398,
    },
    items = {
        {
            type = "npc",
            id = 16797,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9398,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9349,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9356,
    },
    items = {
        {
            type = "npc",
            id = 19344,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9349,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9361,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9356,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10161,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9351,
    },
    items = {
        {
            type = "npc",
            id = 19367,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10161,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9351,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10236,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10630,
    },
    items = {
        {
            type = "npc",
            id = 16915,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10236,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10238,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10629,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10630,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        id = 10132,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10132,
    },
    items = {
        {
            type = "npc",
            id = 19293,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10132,
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
        level = 61,
    },
    active = {
        type = "quest",
        id = 10134,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10351,
    },
    items = {
        {
            type = "kill",
            id = 19188,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10134,
            x = 0,
            y = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10349,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10351,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        ids = {
            9372, 10442, 10443, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10255,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10442,
                    restrictions = {
                        type = "quest",
                        id = 10442,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 10443,
                    restrictions = {
                        type = "quest",
                        id = 10443,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 16991,
                },
            },
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9372,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10255,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        id = 10159,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10159,
    },
    items = {
        {
            type = "npc",
            id = 16888,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10159,
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
        id = 9373,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9373,
    },
    items = {
        {
            type = "kill",
            id = 16857,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9373,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 58,
        },
        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionHorde,
        },
    },
    active = {
        type = "quest",
        id = 10393,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10393,
    },
    items = {
        {
            type = "kill",
            id = 20798,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10393,
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
        id = 10809,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10834,
    },
    items = {
        {
            type = "object",
            id = 185166,
            x = 1,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10809,
            x = 1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10792,
            aside = true,
            x = 0,
        },
        {
            type = "quest",
            id = 10813,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10834,
            x = 1,
        },
    },
})
Database:AddChain(Chain.EmbedChain17, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10278,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10295,
    },
    items = {
        {
            type = "npc",
            id = 19683,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10278,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10294,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10295,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10220,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10220,
    },
    items = {
        {
            type = "npc",
            id = 19682,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10220,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10229,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10258,
    },
    items = {
        {
            type = "quest",
            id = 10229,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10230,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10250,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10258,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9466,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9466,
    },
    items = {
        {
            type = "object",
            id = 181638,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9466,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain21, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            9340, 9498, 9499, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9391,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9498,
                    restrictions = {
                        type = "quest",
                        id = 9498,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 9499,
                    restrictions = {
                        type = "quest",
                        id = 9499,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 16789,
                }
            },
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9340,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9391,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        id = 9397,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9397,
    },
    items = {
        {
            type = "npc",
            id = 16790,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9397,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        id = 9396,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9396,
    },
    items = {
        {
            type = "npc",
            id = 16792,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9396,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        id = 9418,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9418,
    },
    items = {
        {
            type = "kill",
            id = 17084,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9418,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        id = 9375,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9376,
    },
    items = {
        {
            type = "npc",
            id = 16993,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9375,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9376,
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
        level = 60,
    },
    active = {
        type = "quest",
        id = 9387,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9387,
    },
    items = {
        {
            type = "npc",
            id = 16794,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9387,
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
        level = 60,
    },
    active = {
        type = "quest",
        id = 9366,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9370,
    },
    items = {
        {
            type = "npc",
            id = 16791,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9366,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9370,
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
        level = 60,
    },
    active = {
        type = "quest",
        id = 9374,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9472,
    },
    items = {
        {
            type = "npc",
            id = 16793,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9374,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10286,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10287,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9472,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain29, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        id = 9381,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9381,
    },
    items = {
        {
            type = "npc",
            id = 16790,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9381,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain30, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10058,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10058,
    },
    items = {
        {
            type = "npc",
            id = 16825,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10058,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain31, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        id = 9563,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9420,
    },
    items = {
        {
            type = "npc",
            id = 16851,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9563,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9420,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain32, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            9385, 9417, 9558, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            9385, 9417, 
        },
        count = 2,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9558,
                    restrictions = {
                        type = "quest",
                        id = 9558,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 16850,
                },
            },
            x = 1,
            y = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9417,
            x = 0,
        },
        {
            type = "quest",
            id = 9385,
        },
    },
})

Database:AddChain(Chain.UnusedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 13408,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13408,
    },
    items = {
        {
            type = "npc",
            id = 18266,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13408,
            x = 0,
        },
    },
})
Database:AddChain(Chain.UnusedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 13409,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 13409,
    },
    items = {
        {
            type = "npc",
            id = 18267,
            x = 0,
            y = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 13409,
            x = 0,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests_GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-HellfirePeninsula]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionAlliance,
        },
        {
            type = "chain",
            id = Chain.OverthrowTheOverlord,
        },
        {
            type = "chain",
            id = Chain.InSearchOfSedai,
        },
        {
            type = "chain",
            id = Chain.TheExorcismOfColonelJules,
        },
        {
            type = "chain",
            id = Chain.DrillTheDrillmaster,
        },
        {
            type = "chain",
            id = Chain.TempleOfTelhamat,
        },
        {
            type = "chain",
            id = Chain.GreenButNotOrcsAlliance,
        },
        {
            type = "chain",
            id = Chain.CenarionPostAlliance,
        },
        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionHorde,
        },
        {
            type = "chain",
            id = Chain.CruelsIntentions,
        },
        {
            type = "chain",
            id = Chain.TheHandOfKargath,
        },
        {
            type = "chain",
            id = Chain.SpinebreakerPost,
        },
        {
            type = "chain",
            id = Chain.TheMaghar,
        },
        {
            type = "chain",
            id = Chain.FalconWatch,
        },
        {
            type = "chain",
            id = Chain.GreenButNotOrcsHorde,
        },
        {
            type = "chain",
            id = Chain.CenarionPostHorde,
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
            id = Chain.DisruptTheBurningLegionAlliance,
        },
        {
            type = "chain",
            id = Chain.OverthrowTheOverlord,
        },
        {
            type = "chain",
            id = Chain.InSearchOfSedai,
        },
        {
            type = "chain",
            id = Chain.TheExorcismOfColonelJules,
        },
        {
            type = "chain",
            id = Chain.DrillTheDrillmaster,
        },
        {
            type = "chain",
            id = Chain.TempleOfTelhamat,
        },
        {
            type = "chain",
            id = Chain.GreenButNotOrcsAlliance,
        },
        {
            type = "chain",
            id = Chain.CenarionPostAlliance,
        },


        {
            type = "chain",
            id = Chain.DisruptTheBurningLegionHorde,
        },
        {
            type = "chain",
            id = Chain.CruelsIntentions,
        },
        {
            type = "chain",
            id = Chain.TheHandOfKargath,
        },
        {
            type = "chain",
            id = Chain.SpinebreakerPost,
        },
        {
            type = "chain",
            id = Chain.TheMaghar,
        },
        {
            type = "chain",
            id = Chain.FalconWatch,
        },
        {
            type = "chain",
            id = Chain.GreenButNotOrcsHorde,
        },
        {
            type = "chain",
            id = Chain.CenarionPostHorde,
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
        {
            type = "chain",
            id = Chain.EmbedChain29,
        },
        {
            type = "chain",
            id = Chain.EmbedChain30,
        },
        {
            type = "chain",
            id = Chain.EmbedChain31,
        },
        {
            type = "chain",
            id = Chain.EmbedChain32,
        },
    })
end
