local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.Zangarmarsh;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.Zangarmarsh;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1946
local ACHIEVEMENT_ID = 1190
local CONTINENT_ID = 1945
local LEVEL_RANGE = {10, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 60,
    },
}

Chain.DraeneiDiplomacy = 20201
Chain.SwampratPost = 20202
Chain.Telredor = 20203
Chain.Zabrajin = 20204
Chain.OreborHarborage = 20205
Chain.TheDefenseOfZabrajin = 20206
Chain.DontEatThoseMushrooms = 20207
Chain.DrainingTheMarsh = 20208
Chain.SavingTheSporeloks = 20209
Chain.ATripWithTheSporelings = 20210
Chain.EmbedChain01 = 20211
Chain.EmbedChain02 = 20212
Chain.EmbedChain03 = 20213
Chain.EmbedChain04 = 20214
Chain.EmbedChain05 = 20215
Chain.EmbedChain06 = 20216
Chain.EmbedChain07 = 20217
Chain.EmbedChain08 = 20218
Chain.EmbedChain09 = 20219
Chain.EmbedChain10 = 20220
Chain.EmbedChain11 = 20221
Chain.EmbedChain12 = 20222
Chain.EmbedChain13 = 20223
Chain.EmbedChain14 = 20224
Chain.EmbedChain15 = 20225

Chain.Chain01 = 20226

Chain.EmbedChain16 = 20227
Chain.EmbedChain17 = 20228
Chain.EmbedChain18 = 20229
Chain.EmbedChain19 = 20230
Chain.EmbedChain20 = 20231
Chain.EmbedChain21 = 20232
Chain.EmbedChain22 = 20233
Chain.EmbedChain23 = 20234
Chain.EmbedChain24 = 20235
Chain.EmbedChain25 = 20236
Chain.EmbedChain26 = 20237
Chain.EmbedChain27 = 20238

Chain.OtherChain = 20239

Database:AddChain(Chain.DraeneiDiplomacy, {
    name = L["DRAENEI_DIPLOMACY"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.SwampratPost,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9786,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9803,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                42750, 34250, 25700, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                108000, 116000, 124000, 132000, 140000, 148000, 156000, 164000, 176000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 930,
            amount = 1000,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "npc",
            id = 18003,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9786,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9787,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9801,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9803,
            x = 0,
        },
    },
})
Database:AddChain(Chain.SwampratPost, {
    name = L["SWAMPRAT_POST"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.DraeneiDiplomacy,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        ids = {
            9769, 9770, 9773, 9774, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {9899, 9898, 9772},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                90200, 88250, 70300, 52300, 
            },
            minLevel = 66,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                209000, 216000, 232000, 248000, 264000, 280000, 296000, 312000, 328000, 352000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 530,
            amount = 2250,
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
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
            x = 2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            aside = true,
            embed = true,
            x = -1,
        },
    },
})
Database:AddChain(Chain.Telredor, {
    name = L["TELREDOR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Zabrajin,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9791, 9781, 9782, 9901
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9790, 9780, 9896, 9783},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                110550, 88550, 66550, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                297000, 319000, 341000, 363000, 385000, 407000, 429000, 451000, 484000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 47,
            amount = 500,
        },
        {
            type = "reputation",
            id = 930,
            amount = 2250,
            restrictions = 924,
        },
    },
    items = {
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
            aside = true,
            embed = true,
            x = 2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain17,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Zabrajin, {
    name = L["ZABRAJIN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Telredor,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            9814, 9841, 9846, 9845
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9847, 9842, 9816, 9904},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                96050, 94050, 92050, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                275000, 277000, 279000, 297000, 315000, 333000, 351000, 369000, 396000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 530,
            amount = 2250,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
            x = 0,
        },
    },
})
Database:AddChain(Chain.OreborHarborage, {
    name = L["OREBOR_HARBORAGE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheDefenseOfZabrajin,
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        ids = {
            9848, 9835, 10115, 9830, 9833, 9902, 9834
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9839, 10115, 9848, 9905, 9830, 9833, 9902},
        count = 7,
    },
    rewards = {
        {
            type = "experience",
            amount = 110100,
        },
        {
            type = "money",
            amounts = {
                341000, 363000, 385000, 407000, 429000, 451000, 484000, 
            },
            minLevel = 64,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 72,
            amount = 250,
        },
        {
            type = "reputation",
            id = 978,
            amount = 2250,
            restrictions = 924,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain12,
            embed = true,
            x = -3,
            y = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            embed = true,
            x = 0,
            y = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            aside = true,
            embed = true,
            x = 3,
            y = 0,
        },
        {
            type = "reputation",
            id = 978,
            x = 0,
            y = 3,
            connections = {
                1, 2, 
            },
            standing = 4,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
            x = -1,
            y = 4,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
            x = 3,
        },
    },
})
Database:AddChain(Chain.TheDefenseOfZabrajin, {
    name = L["THE_DEFENSE_OF_ZABRAJIN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.OreborHarborage,
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        id = 9820,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9823, 10118},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 58950,
        },
        {
            type = "money",
            amounts = {
                217000, 231000, 245000, 259000, 273000, 287000, 308000, 
            },
            minLevel = 64,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 530,
            amount = 1000,
        },
    },
    items = {
        {
            type = "object",
            id = 182165,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9820,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9822,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9823,
            x = -1,
        },
        {
            type = "quest",
            id = 10118,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            embed = true,
            aside = true,
            x = 2,
            y = 0,
        }
    },
})
Database:AddChain(Chain.DontEatThoseMushrooms, {
    name = L["DONT_EAT_THOSE_MUSHROOMS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        ids = {
            9697, 9701
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 9709,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                55650, 51450, 
            },
            minLevel = 68,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                182000, 186000, 198000, 210000, 222000, 234000, 246000, 264000, 
            },
            minLevel = 63,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1350,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9697,
                    restrictions = {
                        type = "quest",
                        id = 9697,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 17831,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9701,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9702,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9708,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9709,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
            aside = true,
            x = 2,
            y = 1,
        },
        {
            visible = false,
            x = -2,
            y = 1,
        },
    },
})
Database:AddChain(Chain.DrainingTheMarsh, {
    name = L["DRAINING_THE_MARSH"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 59,
    },
    active = {
        type = "quest",
        ids = {
            9716, 9731, 9912, 39180, 39181, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9732,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                57750, 49900, 
            },
            minLevel = 68,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                105000, 109000, 116000, 123000, 130000, 137000, 144000, 154000, 
            },
            minLevel = 63,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1325,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39180,
                    restrictions = {
                        type = "quest",
                        id = 39180,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 39181,
                    restrictions = {
                        type = "quest",
                        id = 39181,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 9912,
                    restrictions = {
                        type = "quest",
                        id = 9912,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 17841,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9716,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9718,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9720,
            aside = true,
            x = -1,
        },
        {
            type = "kill",
            id = 18340,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9731,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9724,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9732,
            x = 0,
        },
    },
})
Database:AddChain(Chain.SavingTheSporeloks, {
    name = L["SAVING_THE_SPORELOKS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9747,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10096, 9894, 9788},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                50600, 42600, 32500, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                137000, 145000, 155000, 165000, 175000, 185000, 195000, 205000, 220000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1250,
        },
    },
    items = {
        {
            type = "npc",
            id = 17956,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9747,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 9788,
            x = -2,
        },
        {
            type = "quest",
            id = 9894,
        },
        {
            type = "quest",
            id = 10096,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            aside = true,
            embed = true,
            x = 2,
            y = 0,
        },
    },
})
Database:AddChain(Chain.ATripWithTheSporelings, {
    name = L["A_TRIP_WITH_THE_SPORELINGS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            9726, 9729, 9739, 9743, 9806, 9808, 9919, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {9729, 9919, 9726},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                79800, 79850, 79900, 79900, 79900, 80000, 80000, 80000, 77900, 78000, 
            },
            minLevel = 61,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 970,
            amount = 3100,
        },
    },
    items = {
        {
            type = "reputation",
            id = 970,
            x = 0,
            connections = {
                1,
            },
            standing = 3,
        },
        {
            type = "npc",
            id = 17923,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 9739,
            aside = true,
            x = -1,
            connections = {
                2,
            },
        },
        {
            type = "quest",
            id = 9743,
            aside = true,
            connections = {
                2,
            },
        },
        {
            type = "quest",
            id = 9742,
            aside = true,
            x = -1,
            active = {
                type = "quest",
                id = 9739,
            },
            completed = {
                type = "reputation",
                id = 970,
                standing = 5,
            },
        },
        {
            type = "quest",
            id = 9744,
            aside = true,
            active = {
                type = "quest",
                id = 9743,
            },
            completed = {
                type = "reputation",
                id = 970,
                standing = 5,
            },
        },


        
        {
            type = "reputation",
            id = 970,
            x = 0,
            connections = {
                1, 2, 3
            },
            standing = 4,
        },
        {
            type = "npc",
            id = 17923,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 17924,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 17925,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 9919,
            x = -2,
        },
        { -- This quest becomes unavailable after hitting friendly,
          -- marking it as a breadcrumb will show it as completed at that time
            type = "quest",
            id = 9808,
            breadcrumb = true,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9806,
            aside = true,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9809,
            aside = true,
            x = 0,
            active = {
                type = "quest",
                id = 9808,
            },
            completed = {
                type = "reputation",
                id = 970,
                standing = 5,
            },
        },
        {
            type = "quest",
            id = 9807,
            aside = true,
            active = {
                type = "quest",
                id = 9806,
            },
            completed = {
                type = "reputation",
                id = 970,
                standing = 7,
            },
        },


        {
            type = "reputation",
            id = 970,
            x = 0,
            connections = {
                1,
            },
            standing = 5,
        },
        {
            type = "npc",
            id = 17856,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9726,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9727,
            x = 0,
            aside = true,
        },


        {
            type = "reputation",
            id = 970,
            x = 0,
            connections = {
                1,
            },
            standing = 8,
        },
        {
            type = "npc",
            id = 17877,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9729,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 59,
    },
    active = {
        type = "quest",
        id = 9774,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9772,
    },
    items = {
        {
            type = "npc",
            id = 18011,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9774,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9771,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9772,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9770,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9898,
    },
    items = {
        {
            type = "npc",
            id = 18012,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9770,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9898,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        ids = {
            9769, 9773, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9899,
    },
    items = {
        {
            type = "npc",
            id = 18016,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9773,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9769,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9899,
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
        id = 9791,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9780,
    },
    items = {
        {
            type = "npc",
            id = 18006,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9791,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9780,
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
        id = 9781,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9790,
    },
    items = {
        {
            type = "npc",
            id = 18005,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9781,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9790,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9782,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9783,
    },
    items = {
        {
            type = "npc",
            id = 18004,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9782,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9783,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9901,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9896,
    },
    items = {
        {
            type = "npc",
            id = 18295,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9901,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9896,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        id = 9814,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9816,
    },
    items = {
        {
            type = "npc",
            id = 18014,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9814,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9816,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        id = 9841,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9842,
    },
    items = {
        {
            type = "npc",
            id = 18015,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9841,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9842,
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
        id = 9846,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9847,
    },
    items = {
        {
            type = "npc",
            id = 18017,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9846,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9847,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        id = 9845,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9904,
    },
    items = {
        {
            type = "npc",
            id = 18018,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9845,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 9904,
            x = -1,
        },
        {
            type = "quest",
            id = 9903,
            aside = true,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        id = 9848,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9848,
    },
    items = {
        {
            type = "npc",
            id = 18019,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9848,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        ids = {
            9835, 10115, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            9839, 10115, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 18008,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9835,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10115,
        },
        {
            type = "quest",
            id = 9839,
            x = -1,
        },
    },
})
Database:AddChain(Chain.EmbedChain14, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 62,
        },
        {
            type = "reputation",
            id = 978,
            standing = 4,
        }
    },
    active = {
        type = "quest",
        ids = {
            9830, 9833, 9902, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            9830, 9833, 9902, 
        },
        count = 3,
    },
    items = {
        {
            type = "npc",
            id = 18009,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 9830,
            x = -2,
        },
        {
            type = "quest",
            id = 9833,
        },
        {
            type = "quest",
            id = 9902,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 62,
        },
        {
            type = "reputation",
            id = 978,
            standing = 4,
        }
    },
    active = {
        type = "quest",
        id = 9834,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9905,
    },
    items = {
        {
            type = "npc",
            id = 18010,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9834,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9905,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = BtWQuests_GetAreaName(3565), -- Cenarion Refuge
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        ids = {9778, 9728, 9730, 9817, 9895, 9802, 9785},
        status = {'active', 'completed'}
    },
    completed = {
        type = "quest",
        ids = {9728, 9730, 9817, 9895, 9802, 9785},
        count = 6
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                68050, 65550, 58300, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                178000, 180000, 186000, 198000, 210000, 222000, 234000, 246000, 264000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 2375,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain21,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain24,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
            embed = true,
        },
    },
})

Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9777,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9777,
    },
    items = {
        {
            type = "npc",
            id = 18007,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9777,
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
        id = 9827,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10355,
    },
    items = {
        {
            type = "kill",
            id = 18124,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9827,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10355,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        id = 10116,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10116,
    },
    items = {
        {
            type = "object",
            id = 183284,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10116,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        id = 9911,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9911,
    },
    items = {
        {
            type = "kill",
            id = 18285,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9911,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9752,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9752,
    },
    items = {
        {
            type = "npc",
            id = 17969,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9752,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain21, {
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
            9728, 9778, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9728,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9778,
                    restrictions = {
                        type = "quest",
                        id = 9778,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 17858,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9728,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        ids = {
            9730, 9817, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            9730, 9817, 
        },
        count = 2,
    },
    items = {
        {
            type = "object",
            id = 182115,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9730,
            x = -1,
        },
        {
            type = "quest",
            id = 9817,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9895,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9895,
    },
    items = {
        {
            type = "npc",
            id = 17834,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9895,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9802,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9802,
    },
    items = {
        {
            type = "npc",
            id = 17909,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9802,
            x = 0,
            connections = {
                1, 
            },
        },
        { -- Available after doing previous quest and up until honored
            type = "quest",
            id = 9784,
            aside = true,
            completed = {
                {
                    type = "quest",
                    id = 9802,
                },
                {
                    type = "reputation",
                    id = 942,
                    standing = 6,
                },
            },
            x = 0,
            connections = {
                1, 
            },
            active = {
                type = "quest",
                id = 9802,
            },
        },
        { -- Can be looted from the bags rewarded by previous quests
            type = "quest",
            id = 9875,
            aside = true,
            completed = {
                --[[
                    We mark this as completed when:
                      Completed the Plants of Zangarmarsh quest,
                      and have reached Honored rep,
                      and have reached exalted rep IF we have more of the items that start this quest.
                    This is because those are BOP and only available from the previous quest which is
                    only up to honored rep
                ]]
                {
                    type = "quest",
                    id = 9802,
                },
                {
                    type = "reputation",
                    id = 942,
                    standing = 6,
                },
                {
                    type = "reputation",
                    id = 942,
                    standing = 8,
                    restrictions = {
                        type = "item",
                        id = 24407,
                    }
                },
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 59,
    },
    active = {
        type = "quest",
        id = 9785,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9785,
    },
    items = {
        {
            type = "reputation",
            id = 942,
            x = 0,
            connections = {
                1, 
            },
            standing = 5,
        },
        {
            type = "npc",
            id = 18070,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9785,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9828,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9828,
    },
    items = {
        {
            type = "kill",
            id = 18124,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9828,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 58,
    },
    active = {
        type = "quest",
        id = 10117,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10117,
    },
    items = {
        {
            type = "object",
            id = 182165,
            x = 0,
            connections = {
                1
            }
        },
        {
            type = "quest",
            id = 10117,
            x = 0,
        },
    },
})
Database:AddChain(Chain.OtherChain, {
    name = "Others",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    items = {
        { -- Report to Shadow Hunter Denjai. Breadcrumb that doesnt block any quests so cant really fit it into a chain
            type = "quest",
            id = 9775,
        },
        { -- Report to Zurai. Breadcrumb that doesnt block any quests so cant really fit it into a chain
            type = "quest",
            id = 10103,
        },
        { -- The Orebor Harborage. Breadcrumb that doesnt block any quests so cant really fit it into a chain
            type = "quest",
            id = 9776,
        },
        {
            type = "quest",
            id = 10459,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-Zangarmarsh]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.DraeneiDiplomacy,
        },
        {
            type = "chain",
            id = Chain.Telredor,
        },
        {
            type = "chain",
            id = Chain.OreborHarborage,
        },
        {
            type = "chain",
            id = Chain.DontEatThoseMushrooms,
        },
        {
            type = "chain",
            id = Chain.DrainingTheMarsh,
        },
        {
            type = "chain",
            id = Chain.SavingTheSporeloks,
        },
        {
            type = "chain",
            id = Chain.ATripWithTheSporelings,
        },
        {
            type = "chain",
            id = Chain.SwampratPost,
        },
        {
            type = "chain",
            id = Chain.Zabrajin,
        },
        {
            type = "chain",
            id = Chain.TheDefenseOfZabrajin,
        },
        {
            type = "chain",
            id = Chain.Chain01,
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
            id = Chain.DraeneiDiplomacy,
        },
        {
            type = "chain",
            id = Chain.TheDefenseOfZabrajin,
        },
        {
            type = "chain",
            id = Chain.DontEatThoseMushrooms,
        },
        {
            type = "chain",
            id = Chain.DrainingTheMarsh,
        },
        {
            type = "chain",
            id = Chain.SavingTheSporeloks,
        },
        {
            type = "chain",
            id = Chain.ATripWithTheSporelings,
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
    })
end