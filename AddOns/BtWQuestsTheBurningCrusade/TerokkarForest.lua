local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.TerokkarForest;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.TerokkarForest;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1952
local ACHIEVEMENT_ID_ALLIANCE = 1191
local ACHIEVEMENT_ID_HORDE = 1272
local CONTINENT_ID = 1945
local LEVEL_RANGE = {15, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 62,
    },
}

Chain.TheSkettisOffensive = 20301
Chain.RefugeeCaravan = 20302
Chain.ShatariBaseCamp = 20303
Chain.TheWardensSecret = 20304
Chain.AllerianStronghold = 20305
Chain.StonebreakerHold = 20306

Chain.EmbedChain01 = 20311
Chain.EmbedChain02 = 20312
Chain.EmbedChain03 = 20313
Chain.EmbedChain04 = 20314
Chain.EmbedChain05 = 20315
Chain.EmbedChain06 = 20316
Chain.EmbedChain07 = 20317
Chain.EmbedChain08 = 20318
Chain.EmbedChain09 = 20319
Chain.EmbedChain10 = 20320
Chain.EmbedChain11 = 20321
Chain.EmbedChain12 = 20322
Chain.EmbedChain13 = 20323
Chain.EmbedChain14 = 20324
Chain.EmbedChain15 = 20325
Chain.EmbedChain16 = 20326
Chain.EmbedChain17 = 20327
Chain.EmbedChain18 = 20328
Chain.EmbedChain19 = 20329
Chain.EmbedChain20 = 20330
Chain.EmbedChain21 = 20331
Chain.EmbedChain22 = 20332
Chain.EmbedChain23 = 20333
Chain.EmbedChain24 = 20334

Chain.Chain01 = 20335
Chain.Chain02 = 20336
Chain.Chain03 = 20337
Chain.Chain04 = 20338

Chain.EmbedChain25 = 20339
Chain.EmbedChain26 = 20340
Chain.EmbedChain27 = 20341
Chain.EmbedChain28 = 20342
Chain.EmbedChain29 = 20343

Chain.OtherChain = 20344

Chain.TempChain01 = 20345
Chain.TempChain02 = 20346

Database:AddChain(Chain.TheSkettisOffensive, {
    name = L["THE_SKETTIS_OFFENSIVE"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10908, 10862, 10863, 10847
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10879,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                80650, 78650, 76150, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                285400, 287400, 290000, 298400, 316000, 334400, 352000, 370400, 397200, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 1011,
            amount = 1925,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10908,
                    restrictions = {
                        type = "quest",
                        id = 10908,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 10862,
                    restrictions = {
                        type = "quest",
                        id = 10862,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "quest",
                    id = 10863,
                    restrictions = {
                        type = "quest",
                        id = 10863,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 22292,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10847,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10849,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10839,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10848,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10861,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10874,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10889,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10879,
            x = 0,
        },
    },
})
Database:AddChain(Chain.RefugeeCaravan, {
    name = L["REFUGEE_CARAVAN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10896, 10852, 10878, 10880
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10031, 10878, 10896, 10881},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                108400, 106300, 
            },
            minLevel = 68,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                132000, 140000, 148000, 156000, 164000, 176000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 250,
        },
        {
            type = "reputation",
            id = 1011,
            amount = 2175,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
        },
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
            id = Chain.EmbedChain25,
            embed = true,
            aside = true,
            x = 6,
        },
    },
})
Database:AddChain(Chain.ShatariBaseCamp, {
    name = L["SHATARI_BASE_CAMP"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        ids = {
            10873, 10913, 10922, 10877, 10920
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10873, 10926, 10923, 10930, 10915},
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 132300,
        },
        {
            type = "money",
            amounts = {
                68000, 70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 935,
            amount = 1600,
        },
        {
            type = "reputation",
            id = 1011,
            amount = 1600,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain05,
            embed = true,
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
            id = Chain.EmbedChain08,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = 0,
            y = 4,
        },
    },
})
Database:AddChain(Chain.TheWardensSecret, {
    name = L["THE_WARDENS_SECRET"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9968, 9951
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10005, 9951},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                71300, 63950, 
            },
            minLevel = 68,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                120000, 124000, 132000, 140000, 148000, 156000, 164000, 176000, 
            },
            minLevel = 63,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 1100,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain10,
            embed = true,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
            x = 2,
        },
        {
            variations = {
                {
                    type = "chain",
                    id = Chain.EmbedChain12,
                },
                {
                    type = "chain",
                    id = Chain.EmbedChain13,
                },
            },
            embed = true,
            x = 0,
            y = 6,
        },
    },
})
Database:AddChain(Chain.AllerianStronghold, {
    name = L["ALLERIAN_STRONGHOLD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.StonebreakerHold
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            9992, 9986, 9998, 10016, 10033, 10038, 10869
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {9992, 9986, 10869, 10007, 10012, 10022, 10035, 10042},
        count = 8,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                171250, 169250, 160950, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                529000, 531000, 539000, 561000, 595000, 629000, 663000, 697000, 748000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            embed = true,
            aside = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain17,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            embed = true,
            x = 1,
        },
    },
})
Database:AddChain(Chain.StonebreakerHold, {
    name = L["STONEBREAKER_HOLD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.AllerianStronghold
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        ids = {
            10039, 10868, 9987, 10034, 10018, 9993, 10000, 10008
        },
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10201, 10868, 9987, 10008, 10013, 10791, 10036, 10043},
        count = 8,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                170200, 168200, 162000, 
            },
            minLevel = 67,
            maxLevel = 69,
        },
        {
            type = "money",
            amounts = {
                500000, 502000, 508000, 528000, 560000, 592000, 624000, 656000, 704000, 
            },
            minLevel = 62,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            embed = true,
            x = 2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain21,
            embed = true,
            x = -2,
            y = 4,
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
        {
            type = "chain",
            id = Chain.EmbedChain24,
            embed = true,
            x = 0,
            y = 8,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            embed = true,
            aside = true,
            x = 2,
            y = 2,
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
        id = 10896,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10896,
    },
    items = {
        {
            type = "npc",
            id = 22420,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10896,
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
        ids = {
            10840, 10842, 10852, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10031,
    },
    items = {
        {
            type = "chain",
            id = Chain.TheSkettisOffensive,
            upto = 10849,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "npc",
            id = 22365,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10852,
            x = 0,
        },

        { -- Requires Missing Friends or others
            type = "quest",
            id = 10840,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10842,
            aside = true,
        },
        {
            type = "quest",
            id = 10030,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10031,
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
        id = 10878,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10878,
    },
    items = {
        {
            type = "npc",
            id = 22370,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10878,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10880,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10881,
    },
    items = {
        {
            type = "npc",
            id = 21662,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10880,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10881,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        id = 10873,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10873,
    },
    items = {
        {
            type = "npc",
            id = 22364,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10873,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        id = 10913,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10915,
    },
    items = {
        {
            type = "npc",
            id = 22446,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10913,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10914,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10915,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain07, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        id = 10922,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10930,
    },
    items = {
        {
            type = "npc",
            id = 22458,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10922,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10929,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10930,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        id = 10877,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10923,
    },
    items = {
        {
            type = "npc",
            id = 22456,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10877,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10923,
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
        level = 63,
    },
    active = {
        type = "quest",
        id = 10920,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10926,
    },
    items = {
        {
            type = "npc",
            id = 22462,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10920,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10921,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10926,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            9957, 9960, 9961, 9968, 9971, 39182, 39188, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9990,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 9957,
                    restrictions = {
                        type = "quest",
                        id = 9957,
                        status = {'active', 'completed'}
                    }
                },
                {
                    type = "quest",
                    id = 9960,
                    restrictions = {
                        type = "quest",
                        id = 9960,
                        status = {'active', 'completed'}
                    }
                },
                {
                    type = "quest",
                    id = 9961,
                    restrictions = {
                        type = "quest",
                        id = 9961,
                        status = {'active', 'completed'}
                    }
                },
                {
                    type = "quest",
                    id = 39182,
                    restrictions = {
                        type = "quest",
                        id = 39182,
                        status = {'active', 'completed'}
                    }
                },
                {
                    type = "quest",
                    id = 39188,
                    restrictions = {
                        type = "quest",
                        id = 39188,
                        status = {'active', 'completed'}
                    }
                },
                {
                    type = "npc",
                    id = 18446,
                },
            },
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9968,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 9971,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9978,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9979,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10112,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9990,
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
        id = 9951,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9951,
    },
    items = {
        {
            type = "npc",
            id = 18424,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9951,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 62,
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
        },
    },
    active = {
        type = "quest",
        id = 9995,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10006,
    },
    items = {
        {
            type = "quest",
            id = 9995,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10448,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9997,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10447,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10006,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain28,
            embed = true,
            aside = true,
            y = 1,
            x = 2,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
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
            type = "chain",
            id = BtWQuests.Constant.Chain.TheBurningCrusade.TerokkarForest.EmbedChain10,
        },
    },
    active = {
        type = "quest",
        id = 9994,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10005,
    },
    items = {
        {
            type = "quest",
            id = 9994,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10444,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9996,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10446,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10005,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain29,
            embed = true,
            aside = true,
            y = 1,
            x = 2,
        },
    },
})
Database:AddChain(Chain.EmbedChain14, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9992,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9992,
    },
    items = {
        {
            type = "npc",
            id = 18390,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9992,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10028,
            x = 0,
            aside = true,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9986,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9986,
    },
    items = {
        {
            type = "npc",
            id = 18389,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9986,
            x = 0,
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
        ids = {
            9998, 10016, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10007, 10012, 10022, 
        },
        count = 3,
    },
    items = {
        {
            type = "npc",
            id = 18387,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 9998,
            x = -1,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 10016,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 10002,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 10012,
        },
        {
            type = "quest",
            id = 10007,
        },
        {
            type = "quest",
            id = 10022,
        },
    },
})
Database:AddChain(Chain.EmbedChain17, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10033,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10035,
    },
    items = {
        {
            type = "object",
            id = 182587,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10033,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10035,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
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
            10038, 10869, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10042, 10869, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 18713,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10038,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10869,
        },
        {
            type = "quest",
            id = 10040,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10042,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
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
            10039, 10868, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10043, 10868, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 18712,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10039,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10868,
        },
        {
            type = "quest",
            id = 10041,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10043,
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
        id = 9987,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 9987,
    },
    items = {
        {
            type = "npc",
            id = 18386,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9987,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain21, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10034,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10036,
    },
    items = {
        {
            type = "object",
            id = 182588,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10034,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10036,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain22, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10018,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10791,
    },
    items = {
        {
            type = "npc",
            id = 18384,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10018,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10023,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10791,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 9993,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10201,
    },
    items = {
        {
            type = "npc",
            id = 18385,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 9993,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10201,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10000, 10008, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10008, 10013, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 18383,
            x = -1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10000,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "npc",
            id = 18566,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10013,
            x = -2,
        },
        {
            type = "quest",
            id = 10003,
            aside = true,
        },
        {
            type = "quest",
            id = 10008,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- A'dal
        type = "quest",
        id = 10210,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 60,
    },
    active = {
        type = "quest",
        id = 10210,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10211,
    },
    rewards = {
        {
            type = "experience",
            amount = 11000,
        },
        {
            type = "reputation",
            id = 932,
            amount = 3500,
        },
        {
            type = "reputation",
            id = 934,
            amount = 3500,
        },
        {
            type = "reputation",
            id = 935,
            amount = 10,
        },
    },
    items = {
        {
            type = "npc",
            id = 19684,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10210,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10211,
            x = 0,
            connections = {
                1, 2, 3
            },
        },
        {
            type = "quest",
            id = 10551,
            aside = true,
            visible = {
                type = "quest",
                ids = {10551, 10552},
                status = {'pending'},
            },
            x = -1,
        },
        {
            type = "quest",
            id = 10552,
            aside = true,
            visible = {
                type = "quest",
                ids = {10551, 10552},
                status = {'pending'},
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10551,
                    restrictions = {
                        type = "reputation",
                        id = 932,
                        standing = 4,
                    }
                },
                {
                    type = "quest",
                    id = 10552,
                    restrictions = {
                        type = "reputation",
                        id = 934,
                        standing = 4,
                    }
                },
            },
            aside = true,
            visible = {
                type = "quest",
                ids = {10551, 10552},
            },
            x = 0,
            y = 3,
            connections = {
                1
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 10554,
                    restrictions = {
                        type = "reputation",
                        id = 932,
                        standing = 4,
                    }
                },
                {
                    type = "quest",
                    id = 10553,
                    restrictions = {
                        type = "reputation",
                        id = 934,
                        standing = 4,
                    }
                },
            },
            aside = true,
            visible = {
                type = "quest",
                ids = {10551, 10552},
            },
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- Plucking Plumes
        type = "quest",
        id = 57581,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10917,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10917,
    },
    rewards = {
        {
            type = "experience",
            amount = 11000,
        },
        {
            type = "money",
            amounts = {
                33000, 35000, 37000, 39000, 41000, 44000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 1011,
            amount = 500,
        },
    },
    items = {
        {
            type = "npc",
            id = 22429,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10917,
            x = 0,
            connections = {
                1, 
            },
        },
        { -- Available after doing previous quest and up until honored
            type = "quest",
            id = 10918,
            aside = true,
            active = {
                type = "quest",
                id = 10917,
            },
            completed = {
                {
                    type = "quest",
                    id = 10917,
                },
                {
                    type = "reputation",
                    id = 1011,
                    standing = 6,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        { -- Becomes available at exalted apparently, not worth showing?
            type = "quest",
            id = 57581,
            aside = true,
            visible = false,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Seth
        type = "npc",
        id = 18653,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10037,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10037,
    },
    rewards = {
        {
            type = "experience",
            amount = 10750,
        },
    },
    items = {
        {
            type = "npc",
            id = 18653,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10037,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = { -- Skywing
        type = "quest",
        id = 10898,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 63,
    },
    active = {
        type = "quest",
        id = 10898,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10898,
    },
    rewards = {
        {
            type = "experience",
            amount = 13750,
        },
        {
            type = "money",
            amounts = {
                66000, 70000, 74000, 78000, 82000, 88000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 1011,
            amount = 350,
        },
    },
    items = {
        {
            type = "npc",
            id = 22424,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10898,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain25, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10887,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10887,
    },
    items = {
        {
            type = "npc",
            id = 22377,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10887,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10026,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10026,
    },
    items = {
        {
            type = "npc",
            id = 18252,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10026,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10027,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10027,
    },
    items = {
        {
            type = "npc",
            id = 18383,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10027,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain28, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    restrictions = HORDE_RESTRICTIONS,
    active = {
        type = "quest",
        id = 10052,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10052,
    },
    items = {
        {
            type = "npc",
            id = 18760,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10052,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain29, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    restrictions = ALLIANCE_RESTRICTIONS,
    active = {
        type = "quest",
        id = 10051,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10051,
    },
    items = {
        {
            type = "npc",
            id = 18760,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10051,
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
        { -- Breadcrumb to area, doesnt lead to quests so doesnt really fit properly
            type = "quest",
            id = 9793,
        },
        { -- Breadcrumb to area, doesnt lead to quests so doesnt really fit properly
            type = "quest",
            id = 10104,
        },
        { -- Breadcrumb to area, doesnt lead to quests so doesnt really fit properly
            type = "quest",
            id = 9796,
        },
        { -- @TODO Breadcrumb
            type = "quest",
            id = 10105,
        },
        { -- Zone PvP Quest - Alliance
            type = "quest",
            id = 11505,
        },
        { -- Zone PvP Quest - Horde
            type = "quest",
            id = 11506,
        },
        { --@TODO MIA
            type = "quest",
            id = 10048,
        },
        { --@TODO MIA
            type = "quest",
            id = 10049,
        },
        { --@TODO MIA
            type = "quest",
            id = 10195,
        },
        { --@TODO MIA
            type = "quest",
            id = 10196,
        },

        { -- Removed during Beta apparently, still shows tooltip though
            type = "quest",
            id = 9984,
        },
        { -- Removed during Beta apparently, still shows tooltip though
            type = "quest",
            id = 9985,
        },
        { -- Wowhead says obsolete, seems to be replaced by lower city feather quest
            type = "quest",
            id = 9988,
        },
        { -- Wowhead says obsolete, seems to be replaced by lower city feather quest
            type = "quest",
            id = 9989,
        },
        { -- Wowhead says obsoletem maybe replaced with Vessels of Power
            type = "quest",
            id = 10032,
        },
        { -- Sha'tari Skyguard
            type = "quest",
            id = 11005,
        },
        { -- Sha'tari Skyguard Repeatable
            type = "quest",
            id = 11006,
        },
        { -- Sha'tari Skyguard
            type = "quest",
            id = 11072,
        },
        { -- Sha'tari Skyguard Repeatable?
            type = "quest",
            id = 11073,
        },
        { -- Sha'tari Skyguard quest, starts from mob drop
            type = "quest",
            id = 11074,
        },
        { -- Sha'tari Skyguard Repeatable
            type = "quest",
            id = 11004,
        },
        { -- Sha'tari Skyguard Daily
            type = "quest",
            id = 11008,
        },
        { -- Sha'tari Skyguard Daily
            type = "quest",
            id = 11085,
        },
        { -- Sha'tari Skyguard quest
            type = "quest",
            id = 11093,
        },
        { -- Isle of Quel-'Danas daily
            type = "quest",
            id = 11520,
        },
        { -- Isle of Quel-'Danas daily
            type = "quest",
            id = 11521,
        },
    },
})

-- Shatari quest lines
Database:AddChain(Chain.TempChain01, {
    name = "11024",
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 70,
    },
    completed = {
        type = "quest",
        id = 11024,
    },
    items = {
        {
            type = "quest",
            id = 11021,
            x = 0,
            connections = {
                1, 
            },
            comment = "Sha'tari Skyguard, starts with a drop",
        },
        {
            type = "quest",
            id = 11024,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11028,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11056,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11029,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11885,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TempChain02, {
    name = {
        type = "quest",
        id = 11096,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 70,
    },
    completed = {
        type = "quest",
        id = 11098,
    },
    items = {
        {
            type = "npc",
            id = 23449,
            x = 0,
            connections = {
                1, 
            },
            comment = "Max level small quest line, requires 225 riding, Sha'tari Skyguard start?",
        },
        {
            type = "quest",
            id = 11096,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11098,
            x = 0,
        },
    },
})


Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-TerokkarForest]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.TheSkettisOffensive,
        },
        {
            type = "chain",
            id = Chain.RefugeeCaravan,
        },
        {
            type = "chain",
            id = Chain.ShatariBaseCamp,
        },
        {
            type = "chain",
            id = Chain.TheWardensSecret,
        },
        {
            type = "chain",
            id = Chain.AllerianStronghold,
        },
        {
            type = "chain",
            id = Chain.StonebreakerHold,
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
Database:AddMapRecursive(111, { -- Shattrath
    type = "category",
    id = CATEGORY_ID,
})

if not C_QuestLine then
    Database:AddContinentItems(CONTINENT_ID, {
        {
            type = "chain",
            id = Chain.TheSkettisOffensive,
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
    })
end