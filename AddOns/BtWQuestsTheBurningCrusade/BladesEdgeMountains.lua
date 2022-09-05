local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.BladesEdgeMountains;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.BladesEdgeMountains;
local ALLIANCE_RESTRICTIONS, HORDE_RESTRICTIONS = BtWQuests.Constant.Restrictions.Alliance, BtWQuests.Constant.Restrictions.Horde;
local MAP_ID = 1949
local ACHIEVEMENT_ID = 1193
local CONTINENT_ID = 1945
local LEVEL_RANGE = {20, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 65,
    },
}

Chain.Sylvanaar = 20501
Chain.ThunderlordStronghold = 20502
Chain.ToshleysStation = 20503
Chain.Reunion = 20504
Chain.TheGronnThreat = 20505
Chain.TheMoknathal = 20506
Chain.RuuanWeald = 20507

Chain.EmbedChain01 = 20511
Chain.EmbedChain02 = 20512
Chain.EmbedChain03 = 20513
Chain.EmbedChain04 = 20514
Chain.EmbedChain05 = 20515
Chain.EmbedChain06 = 20516
Chain.EmbedChain07 = 20517
Chain.EmbedChain08 = 20518
Chain.EmbedChain09 = 20519
Chain.EmbedChain10 = 20520
Chain.EmbedChain11 = 20521
Chain.EmbedChain12 = 20522
Chain.EmbedChain13 = 20523
Chain.EmbedChain14 = 20524
Chain.EmbedChain15 = 20525

Chain.Chain01 = 20526
Chain.Chain02 = 20527
Chain.Chain03 = 20528

Chain.EmbedChain16 = 20529
Chain.EmbedChain17 = 20530
Chain.EmbedChain18 = 20531
Chain.EmbedChain19 = 20532
Chain.EmbedChain20 = 20533
Chain.EmbedChain21 = 20534
Chain.EmbedChain22 = 20535
Chain.EmbedChain23 = 20536
Chain.EmbedChain24 = 20537
Chain.EmbedChain25 = 20538
Chain.EmbedChain26 = 20539
Chain.EmbedChain27 = 20540

Chain.TempChain01 = 20541
Chain.TempChain02 = 20542
Chain.TempChain03 = 20543

Chain.OtherChain = 20599

Database:AddChain(Chain.Sylvanaar, {
    name = L["SYLVANAAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.ThunderlordStronghold
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10455, 10502, 10516, 39199, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {10457, 10518, 10504},
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 181400,
        },
        {
            type = "money",
            amounts = {
                564000, 566000, 592000, 624000, 656000, 704000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain16,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            x = -2,
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
            id = Chain.EmbedChain17,
            aside = true,
            embed = true,
            x = -3,
            y = 7,
        },
        {
            type = "chain",
            id = Chain.EmbedChain18,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain20,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.ThunderlordStronghold, {
    name = L["THUNDERLORD_STRONGHOLD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Sylvanaar
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10486, 10503, 10542, 39198, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {10488, 10544, 10545, 10505},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amount = 130050,
        },
        {
            type = "money",
            amounts = {
                455000, 457000, 481000, 507000, 533000, 572000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain21,
            aside = true,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain04,
            embed = true,
            x = -3,
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
            id = Chain.EmbedChain22,
            aside = true,
            embed = true,
        },
    },
})

Database:AddChain(Chain.ToshleysStation, {
    name = L["TOSHLEYS_STATION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Reunion
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 62,
    },
    active = {
        type = "quest",
        ids = {
            10557, 10580, 10581, 10584, 10608, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {10675, 10712, 10594, 10671},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amount = 141550,
        },
        {
            type = "money",
            amounts = {
                490000, 495400, 500000, 505400, 528000, 555400, 595200, 
            },
            minLevel = 64,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain08,
            embed = true,
            x = -1,
            connections = {
                [6] = {
                    0.8, 1.4, 
                }, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain09,
            embed = true,
            x = 3,
            y = 1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain07,
            embed = true,
            x = -1,
            y = 6,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            aside = true,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Reunion, {
    name = L["REUNION"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.ToshleysStation
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10524,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10526, 10742},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 160700,
        },
        {
            type = "money",
            amounts = {
                541000, 543000, 561000, 583000, 616000, 
            },
            minLevel = 66,
            maxLevel = 70,
        },
    },
    items = {
        {
            name = L["KILL_BLADESPIRE_ORGRES"],
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10524,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10525,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10526,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10718,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10614,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10709,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10714,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10783,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10715,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10749,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 10784,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 10720,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10721,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10785,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 10723,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10786,
            aside = true,
        },
        {
            type = "quest",
            id = 10724,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10742,
            x = 0,
        },
    },
})

Database:AddChain(Chain.TheGronnThreat, {
    name = L["THE_GRONN_THREAT"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheMoknathal
    },
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10797,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10806,
    },
    rewards = {
        {
            type = "experience",
            amount = 88450,
        },
        {
            type = "money",
            amounts = {
                397000, 405000, 419000, 440000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "kill",
            id = 20753,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10797,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10798,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10799,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10800,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 10801,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10803,
            aside = true,
        },
        {
            type = "quest",
            id = 10802,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10818,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10805,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10806,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheMoknathal, {
    name = L["THE_MOKNATHAL"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.TheGronnThreat
    },
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        type = "level",
        level = 61,
    },
    active = {
        type = "quest",
        id = 10565,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10615, 10867},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 140300,
        },
        {
            type = "money",
            amounts = {
                444000, 446000, 452000, 468000, 492000, 528000, 
            },
            minLevel = 65,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain24,
            aside = true,
            embed = true,
            x = -2,
        },
        {
            type = "npc",
            id = 21496,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 10565,
            x = 0,
            y = 1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain26,
            aside = true,
            embed = true,
            x = -3,
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
        },
        {
            visible = false,
        },
    },
})

Database:AddChain(Chain.RuuanWeald, {
    name = L["RUUAN_WEALD"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10567, 10682, 10770, 10771, 10810, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {10607, 10771, 10821, 10912, 10748},
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 236250,
        },
        {
            type = "money",
            amounts = {
                739000, 752000, 790800, 848400, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 942,
            amount = 4470,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            embed = true,
            aside = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            embed = true,
            x = 1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            embed = true,
            x = 3,
            y = 5,
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
        ids = {
            10455, 39199, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10457,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39199,
                    restrictions = {
                        type = "quest",
                        id = 39199,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 21066,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10455,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10456,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10457,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10506,
            aside = true,
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
        id = 10502,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10504,
    },
    items = {
        {
            type = "npc",
            id = 21158,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10502,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10504,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10516,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10518,
    },
    items = {
        {
            type = "npc",
            id = 21277,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10516,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10517,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10518,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10486, 39198, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10488,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 39198,
                    restrictions = {
                        type = "quest",
                        id = 39198,
                        status = {
                            "active",
                            "completed",
                        },
                    },
                },
                {
                    type = "npc",
                    id = 21117,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10486,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10487,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10488,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10503,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10505,
    },
    items = {
        {
            type = "npc",
            id = 21147,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10503,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10505,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10542,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10544,
    },
    items = {
        {
            type = "npc",
            id = 21349,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10542,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10545,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10543,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10544,
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
        id = 10608,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10594,
    },
    items = {
        {
            type = "npc",
            id = 21755,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10608,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10594,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain08, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10580, 10581, 10584, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10671, 10675, 
        },
        count = 2,
    },
    items = {
        {
            type = "quest",
            id = 10580,
            visible = {
                type = "quest",
                id = 10580,
                status = { "active", "completed", },
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
                    id = 10581,
                    restrictions = {
                        type = "quest",
                        id = 10580,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 21691,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10584,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10632,
            aside = true,
            x = -2,
        },
        {
            type = "quest",
            id = 10620,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10657,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10671,
            x = 0,
        },
        {
            type = "quest",
            id = 10674,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10675,
            x = 2,
        },
    },
})
Database:AddChain(Chain.EmbedChain09, {
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
        id = 10557,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10712,
    },
    items = {
        {
            type = "npc",
            id = 21460,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10557,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10710,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10711,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10712,
            x = 0,
            comment = "Unknown exact requirements",
        },
    },
})
Database:AddChain(Chain.EmbedChain10, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = {
        {
            type = "level",
            level = 61,
        },
        {
            type = "chain",
            id = Chain.TheMoknathal,
            upto = 10565,
        },
    },
    active = {
        type = "quest",
        id = 10566,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10615,
    },
    items = {
        {
            type = "quest",
            id = 10566,
            x = 0,
            connections = {
                1,
            },
        },
        {
            type = "quest",
            id = 10615,
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
        {
            type = "level",
            level = 65,
        },
        {
            type = "chain",
            id = Chain.TheMoknathal,
            upto = 10565,
        },
    },
    active = {
        type = "quest",
        id = 10846,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10867,
    },
    items = {
        {
            type = "quest",
            id = 10846,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10843,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10845,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "npc",
            id = 22312,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10851,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10853,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10859,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10865,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10867,
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
        level = 66,
    },
    active = {
        type = "quest",
        id = 10567,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10607,
    },
    items = {
        {
            type = "npc",
            id = 21782,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10567,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10607,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain13, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10682,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10748,
    },
    items = {
        {
            type = "npc",
            id = 22007,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10682,
            x = 0,
            connections = {
                1, 2, 3
            },
        },
        {
            type = "quest",
            id = 10719,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10717,
            aside = true,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10713,
            aside = true,
        },
        {
            type = "quest",
            id = 10894,
            x = -2,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10747,
            aside = true,
        },
        {
            type = "quest",
            id = 10893,
            x = -2,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10722,
            x = -2,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10748,
            x = -2,
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
        id = 10810,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10912,
    },
    items = {
        {
            type = "kill",
            id = 21300,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10810,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10812,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10819,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10820,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10821,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10910,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10904,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10911,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10912,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain15, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10771,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10771,
    },
    items = {
        {
            type = "npc",
            id = 22053,
            x = 0,
            connections = {
                1, 2
            },
        },
        {
            type = "quest",
            id = 10770,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 10771,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- Exorcising the Trees
        type = "quest",
        id = 10830,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10825,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10830,
    },
    rewards = {
        {
            type = "experience",
            amount = 17350,
        },
        {
            type = "money",
            amounts = {
                78000, 82000, 88000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
    },
    items = {
        {
            name = L["KILL_GRISHNATH_ARAKKOA"],
            breadcrumb = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10825,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10829,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10830,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- A Date with Dorgok
        type = "quest",
        id = 10795,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {10795, 10796},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10795, 10796},
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 23300,
        },
        {
            type = "money",
            amounts = {
                74000, 78000, 82000, 88000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 22149,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 22150,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10795,
            x = -1,
        },
        {
            type = "quest",
            id = 10796,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = { -- Mog'dorg the Wizened
        type = "quest",
        id = 10983,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 70,
    },
    active = {
        type = "quest",
        ids = {
            10983, 10983, 10984, 10989, 10995, 10996, 10997, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 11009,
    },
    items = {
        {
            variations = {
                {
                    type = "npc",
                    id = 22995,
                    restrictions = {
                        type = "quest",
                        id = 10989,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 23053,
                    restrictions = {
                        type = "quest",
                        id = 11022,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 10984,
                    restrictions = {
                        type = "quest",
                        id = 10984,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 22940,
                    restrictions = {
                        type = "quest",
                        id = 10983,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 22995,
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
                    id = 10983,
                    restrictions = {
                        {
                            type = "quest",
                            id = 10984,
                            status = { "active", "completed", },
                        },
                        {
                            type = "quest",
                            id = 10989,
                            status = { "pending", },
                        },
                    },
                },
                {
                    type = "quest",
                    id = 10983,
                    restrictions = {
                        type = "quest",
                        id = 10983,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 11022,
                    restrictions = {
                        type = "quest",
                        id = 11022,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 10989,
                },
            },
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10995,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 10996,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10997,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10998,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11000,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11009,
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
        id = 10927,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10927,
    },
    items = {
        {
            type = "npc",
            id = 22488,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10927,
            x = 0,
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
        id = 10555,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10556,
    },
    items = {
        {
            type = "npc",
            id = 21469,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10555,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10556,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain18, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10511,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10512,
    },
    items = {
        {
            type = "npc",
            id = 21151,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10511,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10512,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10510,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10510,
    },
    items = {
        {
            type = "npc",
            id = 21197,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10510,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10690,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10690,
    },
    items = {
        {
            type = "object",
            id = 185035,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10690,
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
        id = 10928,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10928,
    },
    items = {
        {
            type = "npc",
            id = 22489,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10928,
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
        id = 10489,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10489,
    },
    items = {
        {
            type = "object",
            id = 184660,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10489,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain23, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = ALLIANCE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10609,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10609,
    },
    items = {
        {
            type = "npc",
            id = 21110,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10609,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain24, {
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
        id = 10617,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10617,
    },
    items = {
        {
            type = "npc",
            id = 21895,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10617,
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
        id = 10618,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10618,
    },
    items = {
        {
            type = "npc",
            id = 21896,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10618,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    restrictions = HORDE_RESTRICTIONS,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10860,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10860,
    },
    items = {
        {
            type = "npc",
            id = 21088,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10860,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain27, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10753,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10753,
    },
    items = {
        {
            type = "npc",
            id = 22133,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10753,
            x = 0,
        },
    },
})

-- Stuff to move outside of zone
Database:AddChain(Chain.TempChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11080,
    },
    items = {
        {
            type = "npc",
            id = 23233,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11025,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 11058,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11030,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 11080,
            x = -2,
        },
        {
            type = "quest",
            id = 11061,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11062,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 11079,
            x = 0,
        },
        {
            type = "chain",
            id = Chain.TempChain02,
        },
    },
})
Database:AddChain(Chain.TempChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    completed = {
        type = "quest",
        id = 11023,
    },
    items = {
        {
            type = "quest",
            id = 11062,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            variations = {
                {
                    type = "quest",
                    id = 11010,
                    restrictions = {
                        type = "class",
                        id = BtWQuests.Constant.Class.Druid,
                    },
                },
                {
                    type = "quest",
                    id = 11102,
                },
            },
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 11023,
            x = -2,
        },
        {
            type = "quest",
            id = 11119,
        },
        {
            type = "quest",
            id = 11065,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 11066,
            x = 1,
        },
    },
})
Database:AddChain(Chain.TempChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 25,
    },
    completed = {
        type = "quest",
        id = 10977,
    },
    items = {
        {
            type = "quest",
            id = 10976,
            x = 0,
            connections = {
                1, 
            },
            comment = "Consortum stuff",
        },
        {
            type = "quest",
            id = 10977,
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
        { -- Breadcrumb to Sylvanaar but doesnt actually lead to a quest
            type = "quest",
            id = 9794,
        },
        { -- Breadcrumb to area, Horde
            type = "quest",
            id = 9795,
        },

        { -- The Consortium quest
            type = "quest",
            id = 10974,
        },
        { -- The Consortium quest
            type = "quest",
            id = 10975,
        },
        { -- "you must be exalted with "The Consortium" to get this quest"
            type = "quest",
            id = 10982,
        },

        { -- Ogri'la quest, requires honored?
            type = "quest",
            id = 11026,
        },
        { -- Ogri'la Daily
            type = "quest",
            id = 11051,
        },
        { -- Ogri'la intro quest @TODO
            type = "quest",
            id = 11057,
        },
        { -- Ogri'la quest
            type = "quest",
            id = 11059,
        },
        { -- Ogri'la quest
            type = "quest",
            id = 11078,
        },
        { -- One time friendly with Ogri'la
            type = "quest",
            id = 11091,
        },
        { -- Daily for Shattered Sun Offensive
            type = "quest",
            id = 11513,
        },
        { -- Daily from Shattrath
            type = "quest",
            id = 11514,
        },
        { -- Doug Test - Completable Quest4
            type = "quest",
            id = 50384,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-BladesEdgeMountains]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.Sylvanaar,
        },
        {
            type = "chain",
            id = Chain.ThunderlordStronghold,
        },
        {
            type = "chain",
            id = Chain.ToshleysStation,
        },
        {
            type = "chain",
            id = Chain.Reunion,
        },
        {
            type = "chain",
            id = Chain.TheGronnThreat,
        },
        {
            type = "chain",
            id = Chain.TheMoknathal,
        },
        {
            type = "chain",
            id = Chain.RuuanWeald,
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
            id = Chain.Reunion,
        },
        {
            type = "chain",
            id = Chain.TheGronnThreat,
        },
        {
            type = "chain",
            id = Chain.TheMoknathal,
        },
        {
            type = "chain",
            id = Chain.RuuanWeald,
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
