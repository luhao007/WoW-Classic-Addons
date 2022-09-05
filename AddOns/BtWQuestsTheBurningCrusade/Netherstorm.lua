local BtWQuests = BtWQuests;
local Database = BtWQuests.Database;
local L = BtWQuests.L;
local EXPANSION_ID = BtWQuests.Constant.Expansions.TheBurningCrusade;
local CATEGORY_ID = BtWQuests.Constant.Category.TheBurningCrusade.Netherstorm;
local Chain = BtWQuests.Constant.Chain.TheBurningCrusade.Netherstorm;
local MAP_ID = 1953
local ACHIEVEMENT_ID = 1194
local CONTINENT_ID = 1945
local LEVEL_RANGE = {25, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 67,
    },
}

Chain.Socrethar = 20601
Chain.SocretharAldor = 20602
Chain.SocretharScryers = 20603
Chain.TheVioletTower = 20604
Chain.BuildingTheX52NetherRocket = 20605
Chain.ProtectArea52 = 20606
Chain.TheConsortium = 20607
Chain.DestroyingTheAllDevouring = 20608

Chain.EmbedChain01 = 20611
Chain.EmbedChain02 = 20612
Chain.EmbedChain03 = 20613
Chain.EmbedChain04 = 20614
Chain.EmbedChain05 = 20615
Chain.EmbedChain06 = 20616
Chain.EmbedChain07 = 20617
Chain.EmbedChain08 = 20618
Chain.EmbedChain09 = 20619
Chain.EmbedChain10 = 20620

Chain.Chain01 = 20621
Chain.Chain02 = 20622
Chain.Chain03 = 20623
Chain.Chain04 = 20624
Chain.Chain05 = 20625
Chain.Chain06 = 20626
Chain.Chain07 = 20627
Chain.Chain08 = 20628

Chain.EmbedChain11 = 20631
Chain.EmbedChain12 = 20632
Chain.EmbedChain13 = 20633
Chain.EmbedChain14 = 20634
Chain.EmbedChain15 = 20635
Chain.EmbedChain16 = 20636
Chain.EmbedChain17 = 20637
Chain.EmbedChain18 = 20638
Chain.EmbedChain19 = 20639
Chain.EmbedChain20 = 20640
Chain.EmbedChain21 = 20641
Chain.EmbedChain22 = 20642
Chain.EmbedChain23 = 20643
Chain.EmbedChain24 = 20644
Chain.EmbedChain25 = 20645
Chain.EmbedChain26 = 20646
Chain.EmbedChain27 = 20647
Chain.EmbedChain28 = 20648
Chain.EmbedChain29 = 20649
Chain.EmbedChain30 = 20650
Chain.EmbedChain31 = 20651
Chain.EmbedChain32 = 20652
Chain.EmbedChain33 = 20653
Chain.EmbedChain34 = 20654
Chain.EmbedChain35 = 20655
Chain.EmbedChain36 = 20656
Chain.EmbedChain37 = 20657
Chain.EmbedChain38 = 20658

Chain.OtherChain = 20699

Database:AddChain(Chain.Socrethar, {
    name = L["SOCRETHAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Socrethar,
        Chain.SocretharAldor,
        Chain.SocretharScyers,
    },
    restrictions = {
        type = "quest",
        ids = {10551, 10552},
        equals = true,
        count = 0,
    },
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
    active = {
        type = "quest",
        id = 10587,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10651,
    },
    items = {
        {
            name = L["CHOOSE_THE_ALDOR_OR_THE_SCRYERS"],
        },
    },
})
Database:AddChain(Chain.SocretharAldor, {
    name = L["SOCRETHAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Socrethar,
        Chain.SocretharAldor,
        Chain.SocretharScyers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 932,
            standing = 4,
        },
        {
            type = "quest",
            id = 10551,
        },
    },
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {11038, 10241},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10409,
    },
    rewards = {
        {
            type = "experience",
            amount = 203850,
        },
        {
            type = "money",
            amounts = {
                456000, 466000, 484000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 932,
            amount = 4075,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11038,
                    restrictions = {
                        type = "quest",
                        id = 11038,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 19466,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 10241,
            x = 0,
            y = 1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10313,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 10243,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10245,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10299,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10321,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 10246,
            aside = true,
        },
        {
            type = "quest",
            id = 10322,
            aside = true,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10328,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10323,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 10431,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10380,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10381,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10407,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10410,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10409,
            x = 0,
        },
    },
})
Database:AddChain(Chain.SocretharScryers, {
    name = L["SOCRETHAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    alternatives = {
        Chain.Socrethar,
        Chain.SocretharAldor,
        Chain.SocretharScyers,
    },
    restrictions = {
        {
            type = "reputation",
            id = 934,
            standing = 4,
        },
        {
            type = "quest",
            id = 10552,
        },
    },
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {11039, 10189},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10507,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                190200, 190700, 191150, 191700, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amounts = {
                506000, 514000, 536000, 572000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 934,
            amount = 4245,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 11039,
                    restrictions = {
                        type = "quest",
                        id = 11039,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 19468,
                },
            },
            x = 0,
            connections = {
                2, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain10,
            aside = true,
            embed = true,
        },
        {
            type = "quest",
            id = 10189,
            x = 0,
            y = 1,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10193,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10204,
        },
        {
            type = "quest",
            id = 10329,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10194,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10652,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10197,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10198,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10330,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10200,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 19469,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10338,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10341,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10365,
            x = -1,
        },
        {
            type = "quest",
            id = 10202,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10432,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10508,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10509,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10507,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheVioletTower, {
    name = L["THE_VIOLET_TOWER"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10173,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10257, 10320, 10223, 10233, 10240},
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 279350,
        },
        {
            type = "money",
            amounts = {
                903000, 911000, 968000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 19217,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10173,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10300,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10174,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10188,
            x = 0,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "chain",
            id = Chain.EmbedChain01,
            embed = true,
            x = -3,
            y = 5,
        },
        {
            type = "chain",
            id = Chain.EmbedChain02,
            embed = true,
            connections = {
                {
                    0.2, 5, 
                }, 
            },
        },
        {
            type = "npc",
            id = 19488,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 10185,
            aside = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain03,
            embed = true,
            x = 1,
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
            x = 1,
            y = 8,
        },
    },
})
Database:AddChain(Chain.BuildingTheX52NetherRocket, {
    name = L["BUILDING_THE_X52_NETHERROCKET"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {10183, 11036, 11037, 11040, 11042, 39201, 39202, 10186},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10221,
    },
    rewards = {
        {
            type = "experience",
            amount = 36300,
        },
        {
            type = "money",
            amounts = {
                119000, 123000, 132000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10183,
                    restrictions = {
                        type = "quest",
                        id = 10183,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11036,
                    restrictions = {
                        type = "quest",
                        id = 11036,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11037,
                    restrictions = {
                        type = "quest",
                        id = 11037,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11040,
                    restrictions = {
                        type = "quest",
                        id = 11040,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 11042,
                    restrictions = {
                        type = "quest",
                        id = 11042,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 39201,
                    restrictions = {
                        type = "quest",
                        id = 39201,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 39202,
                    restrictions = {
                        type = "quest",
                        id = 39202,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 19570,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10186,
            x = 0,
            connections = {
                1,
            },
        },
        {
            type = "quest",
            id = 10203,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10221,
            x = 0,
        },
    },
})
Database:AddChain(Chain.ProtectArea52, {
    name = L["PROTECT_AREA_52"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheConsortium,
            upto = 10265,
        },
    },
    active = {
        type = "quest",
        id = 10206,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10249,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                82400, 82600, 82800, 83050, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amounts = {
                314000, 320000, 328000, 352000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 19645,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10206,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10232,
            aside = true,
            x = -1,
        },
        {
            type = "quest",
            id = 10333,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10234,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10235,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10237,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10247,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10248,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10249,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheConsortium, {
    name = L["THE_CONSORTIUM"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {10263, 10264, 10265, 10270, 10339, 10417},
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        ids = {10440, 10274, 10408, 10276},
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amounts = {
                305600, 306450, 307200, 307850, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "money",
            amounts = {
                1084000, 1092000, 1106000, 1144000, 
            },
            minLevel = 67,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 933,
            amount = 4575,
        },
        {
            type = "reputation",
            id = 935,
            amount = 2000,
        },
    },
    items = {
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
        },
    },
})
Database:AddChain(Chain.DestroyingTheAllDevouring, {
    name = L["DESTROYING_THE_ALLDEVOURING"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10437,
        status = {'active', 'completed'},
    },
    completed = {
        type = "quest",
        id = 10439,
    },
    rewards = {
        {
            type = "experience",
            amount = 44300,
        },
        {
            type = "money",
            amount = 132000,
        },
        {
            type = "reputation",
            id = 933,
            amount = 1000,
        },
    },
    items = {
        {
            type = "npc",
            id = 20907,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10437,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10438,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10439,
            x = 0,
        },
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
            upto = 10188,
        },
    },
    active = {
        type = "quest",
        id = 10343,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10240,
    },
    items = {
        {
            type = "npc",
            id = 19489,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10343,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10239,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10240,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain02, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
            upto = 10188,
        },
    },
    active = {
        type = "quest",
        id = 10192,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10257,
    },
    items = {
        {
            type = "quest",
            id = 10192,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10301,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10209,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10176,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10256,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10257,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain03, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
            upto = 10188,
        },
    },
    active = {
        type = "quest",
        id = 10222,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10223,
    },
    items = {
        {
            type = "quest",
            id = 10222,
            x = 0,
            connections = {
                1,
            },
        },
        {
            type = "quest",
            id = 10223,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain04, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
            upto = 10188,
        },
    },
    active = {
        type = "quest",
        id = 10184,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10320,
    },
    items = {
        {
            type = "quest",
            id = 10184,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10312,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10316,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10314,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10319,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10320,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain05, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
            upto = 10188,
        },
    },
    active = {
        type = "quest",
        id = 10233,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10233,
    },
    items = {
        {
            type = "npc",
            id = 19489,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10233,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain06, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10263, 10264, 10265, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10276,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10263,
                    restrictions = {
                        type = "quest",
                        id = 10263,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "quest",
                    id = 10264,
                    restrictions = {
                        type = "quest",
                        id = 10264,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 19880,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10265,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10262,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10205,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10266,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10267,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10268,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10269,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10275,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10276,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10280,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10704,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10882,
            aside = true,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10270,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10274,
    },
    items = {
        {
            type = "npc",
            id = 20071,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10270,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10271,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10281,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10272,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10273,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10274,
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
        level = 70,
    },
    active = {
        type = "quest",
        id = 10339,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10408,
    },
    items = {
        {
            type = "npc",
            id = 20448,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10339,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10384,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10385,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10405,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10406,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10408,
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
        id = 10417,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10440,
    },
    items = {
        {
            type = "npc",
            id = 20810,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10417,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10418,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10423,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10424,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10430,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10436,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10440,
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
        level = 67,
    },
    active = {
        type = "quest",
        id = 10261,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10261,
    },
    items = {
        {
            type = "object",
            id = 183811,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10261,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = BtWQuests_GetAreaName(3712), -- Area 52
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10225, 10309, 10342, 10701, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10199, 10226, 10309, 10701, 
        },
        count = 4,
    },
    rewards = {
        {
            type = "experience",
            amount = 73200,
        },
        {
            type = "money",
            amounts = {
                273000, 287000, 308000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain11,
            embed = true,
            x = -1,
            y = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain12,
            embed = true,
            x = -3,
            y = 1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain13,
            embed = true,
            x = 1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain14,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = BtWQuests_GetAreaName(3725), -- Ruins of Enkaat
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10190, 10191, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10190, 10191, 
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 26950,
        },
        {
            type = "money",
            amounts = {
                117000, 123000, 132000, 
            },
            minLevel = 68,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain15,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain16,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = BtWQuests_GetAreaName(3877), -- Eco-Dome Midrealm
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10311, 10348, 10433, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10310, 10348, 10435, 
        },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 55200,
        },
        {
            type = "money",
            amounts = {
                211000, 220000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 933,
            amount = 610,
        },
    },
    items = {
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
        },
        {
            type = "chain",
            id = Chain.EmbedChain19,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain04, {
    name = BtWQuests_GetAreaName(3738), -- The Stormspire
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10290, 10335, 10336, 10426, 10855, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10293, 10335, 10336, 10429, 10857, 
        },
        count = 5,
    },
    rewards = {
        {
            type = "experience",
            amount = 130250,
        },
        {
            type = "money",
            amounts = {
                337000, 352000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
        {
            type = "reputation",
            id = 933,
            amount = 1850,
        },
        {
            type = "reputation",
            id = 942,
            amount = 850,
        },
    },
    items = {
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
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain22,
            embed = true,
            x = 3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain23,
            embed = true,
            x = 3,
        },
    },
})
Database:AddChain(Chain.Chain05, {
    name = BtWQuests_GetAreaName(3852), -- Tuluman's landing
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        ids = {
            10315, 10317, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10315, 10318, 
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 37950,
        },
        {
            type = "money",
            amount = 88000,
        },
        {
            type = "reputation",
            id = 933,
            amount = 500,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain24,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain25,
            embed = true,
        },
    },
})
Database:AddChain(Chain.Chain06, {
    name = BtWQuests_GetAreaName(3854), -- Tuluman's landing
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        ids = {
            10345, 10353, 10411, 10413, 10422, 10425, 10969, 10970, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10345, 10353, 10411, 10413, 10422, 10425, 10974, 
        },
        count = 7,
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain26,
            embed = true,
            x = -2,
        },
        {
            type = "chain",
            id = Chain.EmbedChain27,
            embed = true,
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
            x = 0,
        },
        {
            type = "chain",
            id = Chain.EmbedChain30,
            embed = true,
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
        },
    },
})
Database:AddChain(Chain.Chain07, {
    name = BtWQuests_GetAreaName(3724), -- Cosmowrench
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 67,
    },
    active = {
        type = "quest",
        id = 10924,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10924,
    },
    rewards = {
        {
            type = "experience",
            amount = 12300,
        },
        {
            type = "money",
            amounts = {
                41000, 44000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "npc",
            id = 22479,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10924,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain08, {
    name = BtWQuests_GetAreaName(3732), -- Protectorate Watch Post
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10182, 10305, 10306, 10307, 10331, 10334, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10182, 10305, 10306, 10307, 10332, 10337, 
        },
        count = 6,
    },
    rewards = {
        {
            type = "experience",
            amount = 95050,
        },
        {
            type = "money",
            amounts = {
                164000, 176000, 
            },
            minLevel = 69,
            maxLevel = 70,
        },
    },
    items = {
        {
            type = "chain",
            id = Chain.EmbedChain33,
            embed = true,
            x = -1,
        },
        {
            type = "chain",
            id = Chain.EmbedChain34,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain35,
            embed = true,
            x = -3,
        },
        {
            type = "chain",
            id = Chain.EmbedChain36,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain37,
            embed = true,
        },
        {
            type = "chain",
            id = Chain.EmbedChain38,
            embed = true,
        },
    },
})

Database:AddChain(Chain.EmbedChain11, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 67,
        },
        {
            type = "chain",
            id = Chain.BuildingTheX52NetherRocket,
            upto = 10186,
        },
    },
    active = {
        type = "quest",
        id = 10225,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10226,
    },
    items = {
        {
            type = "chain",
            id = Chain.BuildingTheX52NetherRocket,
            connections = {
                1, 
            },
            upto = 10186,
        },
        {
            type = "npc",
            id = 19570,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10225,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10224,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10226,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain12, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10701,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10701,
    },
    items = {
        {
            type = "object",
            id = 183811,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10701,
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
        id = 10342,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10199,
    },
    items = {
        {
            type = "npc",
            id = 19617,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10342,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10199,
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
        id = 10309,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10309,
    },
    items = {
        {
            type = "npc",
            id = 19690,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10309,
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
        id = 10190,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10190,
    },
    items = {
        {
            type = "npc",
            id = 19578,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10190,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain16, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10191,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10191,
    },
    items = {
        {
            type = "npc",
            id = 19589,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10191,
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
        id = 10433,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10435,
    },
    items = {
        {
            type = "npc",
            id = 20921,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10433,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10434,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10435,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10311,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10310,
    },
    items = {
        {
            type = "npc",
            id = 20066,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10311,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10310,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain19, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10348,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10348,
    },
    items = {
        {
            type = "npc",
            id = 20810,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10348,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain20, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10290,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10293,
    },
    items = {
        {
            type = "npc",
            id = 20067,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10290,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10293,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain21, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            10336, 10855, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            10336, 10857, 
        },
        count = 2,
    },
    items = {
        {
            type = "npc",
            id = 20471,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 10855,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 10336,
        },
        {
            type = "quest",
            id = 10856,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10857,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10335,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10335,
    },
    items = {
        {
            type = "npc",
            id = 20470,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10335,
            x = 0,
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
        id = 10426,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10429,
    },
    items = {
        {
            type = "npc",
            id = 20871,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10426,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10427,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10429,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10317,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10318,
    },
    items = {
        {
            type = "npc",
            id = 20112,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10317,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10318,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10315,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10315,
    },
    items = {
        {
            type = "npc",
            id = 20341,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10315,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain26, {
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
            10969, 10970, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10974,
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 10969,
                    restrictions = {
                        type = "quest",
                        id = 10969,
                        status = {'active', 'completed'}
                    },
                },
                {
                    type = "npc",
                    id = 20448,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        { -- Required honored?
            type = "quest",
            id = 10970,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10971,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10973,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10974,
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
        level = 68,
    },
    active = {
        type = "quest",
        id = 10411,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10411,
    },
    items = {
        {
            type = "npc",
            id = 20449,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10411,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain28, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10422,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10422,
    },
    items = {
        {
            type = "npc",
            id = 20450,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10422,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain29, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10425,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10425,
    },
    items = {
        {
            type = "kill",
            id = 20854,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10425,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain30, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10413,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10413,
    },
    items = {
        {
            type = "kill",
            id = 20779,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10413,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain31, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10345,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10345,
    },
    items = {
        {
            type = "npc",
            id = 20551,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10345,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain32, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 68,
    },
    active = {
        type = "quest",
        id = 10353,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10353,
    },
    items = {
        {
            type = "npc",
            id = 20552,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10353,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain33, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 67,
    },
    active = {
        type = "quest",
        id = 10331,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10332,
    },
    items = {
        {
            type = "npc",
            id = 20463,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10331,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10332,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain34, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 67,
    },
    active = {
        type = "quest",
        id = 10334,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10337,
    },
    items = {
        {
            type = "npc",
            id = 20464,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10334,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10337,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain35, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        type = "level",
        level = 67,
    },
    active = {
        type = "quest",
        id = 10182,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10182,
    },
    items = {
        {
            type = "kill",
            id = 19543,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10182,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain36, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10305,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10305,
    },
    items = {
        {
            type = "kill",
            id = 19546,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10305,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain37, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10306,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10306,
    },
    items = {
        {
            type = "kill",
            id = 19544,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10306,
            x = 0,
        },
    },
})
Database:AddChain(Chain.EmbedChain38, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 10307,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 10307,
    },
    items = {
        {
            type = "kill",
            id = 19545,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 10307,
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
        { -- Removed?
            type = "quest",
            id = 10179,
        },
        { -- Removed?
            type = "quest",
            id = 10187,
        },
        { -- Removed?
            type = "quest",
            id = 10441,
        },
        { -- Repeatable A Heap of Ethereals
            type = "quest",
            id = 10308,
        },
        { -- Repeatable rep quest
            type = "quest",
            id = 10972,
        },
        { -- Daily from Shattrath
            type = "quest",
            id = 11877,
        },
        { -- Part of the quest Fel Reavers, No Thanks!"
            type = "quest",
            id = 10850,
        },
    },
})


Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
    buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsTheBurningCrusade\UI-Category-Netherstorm]],
		texCoords = {0,1,0,1},
    },
    items = {
        {
            type = "chain",
            id = Chain.Socrethar,
        },
        {
            type = "chain",
            id = Chain.SocretharAldor,
        },
        {
            type = "chain",
            id = Chain.SocretharScryers,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
        },
        {
            type = "chain",
            id = Chain.BuildingTheX52NetherRocket,
        },
        {
            type = "chain",
            id = Chain.ProtectArea52,
        },
        {
            type = "chain",
            id = Chain.TheConsortium,
        },
        {
            type = "chain",
            id = Chain.DestroyingTheAllDevouring,
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
            id = Chain.SocretharAldor,
        },
        {
            type = "chain",
            id = Chain.SocretharScryers,
        },
        {
            type = "chain",
            id = Chain.TheVioletTower,
        },
        {
            type = "chain",
            id = Chain.BuildingTheX52NetherRocket,
        },
        {
            type = "chain",
            id = Chain.ProtectArea52,
        },
        {
            type = "chain",
            id = Chain.DestroyingTheAllDevouring,
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
            id = Chain.Chain07,
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
        {
            type = "chain",
            id = Chain.EmbedChain33,
        },
        {
            type = "chain",
            id = Chain.EmbedChain34,
        },
        {
            type = "chain",
            id = Chain.EmbedChain35,
        },
        {
            type = "chain",
            id = Chain.EmbedChain36,
        },
        {
            type = "chain",
            id = Chain.EmbedChain37,
        },
        {
            type = "chain",
            id = Chain.EmbedChain38,
        },
    })
end
