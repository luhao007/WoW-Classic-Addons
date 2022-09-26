-- AUTO GENERATED - NEEDS UPDATING

local BtWQuests = BtWQuests
local L = BtWQuests.L
local Database = BtWQuests.Database
local EXPANSION_ID = BtWQuests.Constant.Expansions.WrathOfTheLichKing
local CATEGORY_ID = BtWQuests.Constant.Category.WrathOfTheLichKing.SholazarBasin
local Chain = BtWQuests.Constant.Chain.WrathOfTheLichKing.SholazarBasin
local MAP_ID = 119
local CONTINENT_ID = 113
local ACHIEVEMENT_ID = 39
local LEVEL_RANGE = {20, 30}
local LEVEL_PREREQUISITES = {
    {
        type = "level",
        level = 76,
    },
}

Chain.HuntingBiggerGame = 30601
Chain.TeethSpikesAndTalons = 30602
Chain.TheWolvar = 30603
Chain.TheOracles = 30604
Chain.TheLifewarden = 30605
Chain.WatchingOverTheBasin = 30606

Chain.Chain01 = 30611
Chain.Chain02 = 30612
Chain.Chain03 = 30613

Chain.EmbedChain01 = 30621
Chain.EmbedChain02 = 30622
Chain.EmbedChain03 = 30623
Chain.EmbedChain04 = 30624
Chain.EmbedChain05 = 30625
Chain.EmbedChain06 = 30626

Chain.OtherAlliance = 30697
Chain.OtherHorde = 30698
Chain.OtherBoth = 30699

Database:AddChain(Chain.HuntingBiggerGame, {
    name = L["HUNTING_BIGGER_GAME"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        ids = {
            12522, 12524, 12624, 12688, 49535, 49553, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12595,
    },
    rewards = {
        {
            type = "experience",
            amount = 360650,
        },
        {
            type = "money",
            amount = 1181000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 49535,
                    restrictions = {
                        type = "quest",
                        id = 49535,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "quest",
                    id = 49553,
                    restrictions = {
                        type = "quest",
                        id = 49553,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 28160,
                },
            },
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12521,
            aside = true,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12489,
            aside = true,
            x = 0,
        },
        {
            type = "npc",
            id = 28032,
            x = -1,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 28033,
            connections = {
                3, 
            },
        },
        {
            type = "npc",
            id = 28497,
            aside = true,
            x = -3,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12522,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12524,
            connections = {
                4, 
            },
        },
        {
            type = "npc",
            id = 28787,
            aside = true,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12624,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 12523,
            connections = {
                3, 4, 
            },
        },
        {
            type = "quest",
            id = 12525,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12688,
            aside = true,
        },
        {
            type = "quest",
            id = 12549,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12520,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12550,
            x = -2,
            connections = {
                6, 
            },
        },
        {
            type = "quest",
            id = 12551,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12526,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12560,
            x = 0,
            connections = {
                4, 
            },
        },
        {
            type = "quest",
            id = 12543,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12544,
            x = 2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12558,
            x = -2,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12569,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12556,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12595,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TeethSpikesAndTalons, {
    name = L["TEETH_SPIKES_AND_TALONS"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 76,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12558,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12569,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12556,
        },
    },
    active = {
        type = "quest",
        ids = {
            12683, 12603, 12605, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12614,
    },
    rewards = {
        {
            type = "experience",
            amount = 149800,
        },
        {
            type = "money",
            amount = 506000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28771,
            aside = true,
            x = -3,
            connections = {
                2, 
            },
        },
        {
            type = "npc",
            id = 28376,
            x = 0,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12683,
            aside = true,
            x = -3,
        },
        {
            type = "quest",
            id = 12603,
            connections = {
                2, 3, 4, 
            },
        },
        {
            type = "quest",
            id = 12605,
            connections = {
                1, 2, 3, 
            },
        },
        {
            type = "quest",
            id = 12607,
            x = -1,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12681,
            aside = true,
        },
        {
            type = "quest",
            id = 12658,
            aside = true,
        },
        {
            type = "quest",
            id = 12614,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheWolvar, {
    name = L["THE_WOLVAR"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = LEVEL_PREREQUISITES,
    active = {
        type = "quest",
        id = 12528,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12540,
    },
    rewards = {
        {
            type = "experience",
            amount = 246100,
        },
        {
            type = "money",
            amount = 748200,
        },
        {
            type = "reputation",
            id = 1104,
            amount = 4800,
        },
    },
    items = {
        {
            type = "kill",
            id = 28097,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12528,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12529,
            x = -1,
            connections = {
                2, 3, 
            },
        },
        {
            type = "quest",
            id = 12530,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12533,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12534,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12532,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12531,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12535,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12536,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12537,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12538,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12539,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12540,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheOracles, {
    name = L["THE_ORACLES"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 76,
        },
        {
            type = "chain",
            id = Chain.TheWolvar,
            upto = 12540,
        },
    },
    active = {
        type = "quest",
        id = 12570,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12581,
    },
    rewards = {
        {
            type = "experience",
            amount = 235400,
        },
        {
            type = "money",
            amount = 814000,
        },
        {
            type = "reputation",
            id = 1105,
            amount = 3550,
        },
    },
    items = {
        {
            type = "npc",
            id = 28217,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12570,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12572,
            x = -1,
            connections = {
                3, 
            },
        },
        {
            type = "quest",
            id = 12571,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12573,
            x = 1,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12574,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12575,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12576,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12577,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12578,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12580,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12579,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12581,
            x = 0,
        },
    },
})
Database:AddChain(Chain.TheLifewarden, {
    name = L["THE_LIFEWARDEN"],
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    major = true,
    prerequisites = {
        {
            type = "level",
            level = 77,
        },
    },
    active = {
        type = "quest",
        ids = {
            12561, 12803, 
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = {
            12805,12561
        },
        count = 2,
    },
    rewards = {
        {
            type = "experience",
            amount = 69550,
        },
        {
            type = "money",
            amount = 260000,
        },
    },
    items = {
        {
            variations = {
                {
                    type = "quest",
                    id = 12803,
                    restrictions = {
                        type = "quest",
                        id = 12803,
                        status = { "active", "completed", },
                    },
                },
                {
                    type = "npc",
                    id = 27801,
                },
            },
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12561,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12611,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12805,
            x = 0,
        },
    },
})
Database:AddChain(Chain.WatchingOverTheBasin, {
    name = L["WATCHING_OVER_THE_BASIN"],
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
            id = Chain.TheLifewarden,
            upto = 12611,
        },
    },
    active = {
        type = "quest",
        id = 12612,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12546,
    },
    rewards = {
        {
            type = "experience",
            amount = 238750,
        },
        {
            type = "money",
            amount = 693000,
        },
    },
    items = {
        {
            type = "npc",
            id = 27801,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12612,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12608,
            x = 0,
            connections = {
                1, 2, 
            },
        },
        {
            type = "quest",
            id = 12617,
            x = -1,
            connections = {
                2, 
            },
        },
        {
            type = "quest",
            id = 12660,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12620,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12621,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12559,
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
        },
        {
            type = "quest",
            id = 12613,
            x = 0,
            y = 7,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12548,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12547,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12797,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12546,
            x = 0,
        },
    },
})

Database:AddChain(Chain.Chain01, {
    name = { -- The Great Hunter's Challenge
        type = "quest",
        id = 12592,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 76,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12525,
            comment = "Maybe requires https://www.wowhead.com/quest=12523 too",
        },
    },
    active = {
        type = "quest",
        id = 12589,
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        id = 12592,
    },
    rewards = {
        {
            type = "experience",
            amount = 28550,
        },
        {
            type = "money",
            amount = 124000,
        },
    },
    items = {
        {
            type = "npc",
            id = 28328,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12589,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12592,
            x = 0,
        },
    },
})
Database:AddChain(Chain.Chain02, {
    name = { -- The Taste Test
        type = "quest",
        id = 12645,
    },
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 76,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12549,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12520,
        },
    },
    active = {
        type = "quest",
        ids = {
            12634, 12804,
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12645, 12804 },
        count = 2
    },
    rewards = {
        {
            type = "experience",
            amount = 84600,
        },
        {
            type = "money",
            amount = 296000,
        },
    },
    items = {
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
        },
    },
})
Database:AddChain(Chain.Chain03, {
    name = BtWQuests_GetAreaName(4290), -- River's Heart
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    prerequisites = {
        {
            type = "level",
            level = 76,
        },
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
            upto = 12523,
        },
    },
    active = {
        type = "quest",
        ids = {
            12696, 12699, 12654
        },
        status = { "active", "completed", },
    },
    completed = {
        type = "quest",
        ids = { 12696, 12671, 12654 },
        count = 3,
    },
    rewards = {
        {
            type = "experience",
            amount = 69300,
        },
        {
            type = "money",
            amount = 192000,
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
    },
})

Database:AddChain(Chain.EmbedChain01, {
    category = CATEGORY_ID,
    expansion = EXPANSION_ID,
    range = LEVEL_RANGE,
    completed = {
        type = "quest",
        id = 12558,
    },
    items = {
        {
            type = "object",
            id = 190768,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12691,
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
        id = 12645,
    },
    items = {
        {
            type = "npc",
            id = 29157,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12634,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12644,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12645,
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
        id = 12558,
    },
    items = {
        {
            type = "npc",
            id = 28046,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12804,
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
        id = 12696,
    },
    items = {
        {
            type = "npc",
            id = 28266,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12696,
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
        id = 12671,
    },
    items = {
        {
            type = "npc",
            id = 28746,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12699,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12671,
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
        id = 12558,
    },
    items = {
        {
            type = "npc",
            id = 28568,
            x = 0,
            connections = {
                1, 
            },
        },
        {
            type = "quest",
            id = 12654,
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
        { -- Frenzyheart Champion, Daily, Alliance
            type = "quest",
            id = 12582,
        },
        { -- Hand of the Oracles, Daily, Alliance
            type = "quest",
            id = 12689,
        },
        { -- Return of the Lich Hunter, Seems to be a return quest for a Daily, maybe just first time?
            type = "quest",
            id = 12692,
        },
        { -- Return of the Friendly Dryskin, Seems to be a return quest for a Daily, maybe just first time?
            type = "quest",
            id = 12695,
        },
        { -- Chicken Party!, Daily
            type = "quest",
            id = 12702,
        },
        { -- Kartak's Rampage, Daily
            type = "quest",
            id = 12703,
        },
        { -- Appeasing the Great Rain Stone, Daily
            type = "quest",
            id = 12704,
        },
        { -- Will of the Titans, Daily
            type = "quest",
            id = 12705,
        },
        { -- Song of Wind and Water, Daily
            type = "quest",
            id = 12726,
        },
        { -- The Heartblood's Strength, Daily
            type = "quest",
            id = 12732,
        },
        { -- Rejek: First Blood, Daily
            type = "quest",
            id = 12734,
        },
        { -- A Cleansing Song, Daily
            type = "quest",
            id = 12735,
        },
        { -- Song of Reflection, Daily
            type = "quest",
            id = 12736,
        },
        { -- Song of Fecundity, Daily
            type = "quest",
            id = 12737,
        },
        { -- Strength of the Tempest, Daily
            type = "quest",
            id = 12741,
        },
        { -- A Hero's Headgear, Daily
            type = "quest",
            id = 12758,
        },
        { -- Tools of War, Daily
            type = "quest",
            id = 12759,
        },
        { -- Secret Strength of the Frenzyheart, Daily
            type = "quest",
            id = 12760,
        },
        { -- Mastery of the Crystals, Daily
            type = "quest",
            id = 12761,
        },
        { -- Power of the Great Ones, Daily
            type = "quest",
            id = 12762,
        },
        { -- Sholazar Basin
            type = "quest",
            id = 39209,
        },
        { -- Sholazar Basin
            type = "quest",
            id = 39212,
        },
    },
})

Database:AddCategory(CATEGORY_ID, {
    name = BtWQuests.GetMapName(MAP_ID),
    expansion = EXPANSION_ID,
	buttonImage = {
        texture = [[Interface\AddOns\BtWQuestsWrathOfTheLichKing\UI-Category-SholazarBasin]],
		texCoords = {0,1,0,1},
	},
    items = {
        {
            type = "chain",
            id = Chain.HuntingBiggerGame,
        },
        {
            type = "chain",
            id = Chain.TeethSpikesAndTalons,
        },
        {
            type = "chain",
            id = Chain.TheWolvar,
        },
        {
            type = "chain",
            id = Chain.TheOracles,
        },
        {
            type = "chain",
            id = Chain.TheLifewarden,
        },
        {
            type = "chain",
            id = Chain.WatchingOverTheBasin,
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

Database:AddContinentItems(CONTINENT_ID, {})
