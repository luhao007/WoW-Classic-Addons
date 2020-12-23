-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mill = TSM.Init("Data.Mill")
local private = {}



-- ============================================================================
-- Mill Data
-- ============================================================================

local DATA = TSM.IsWowClassic() and {} or {
	-- ======================================= Common Pigments =======================================
	["i:39151"] = { -- Alabaster Pigment (Ivory / Moonglow Ink)
		["i:765"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5480}, -- Silverleaf
		["i:2447"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5480}, -- Peacebloom
		["i:2449"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Earthroot
	},
	["i:39334"] = { -- Dusky Pigment (Midnight Ink)
		["i:785"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Mageroyal
		["i:2450"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Briarthorn
		["i:2452"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Swiftthistle
		["i:2453"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Bruiseweed
		["i:3820"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Stranglekelp
	},
	["i:39338"] = { -- Golden Pigment (Lion's Ink)
		["i:3355"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Wild Steelbloom
		["i:3369"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Grave Moss
		["i:3356"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Kingsblood
		["i:3357"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Liferoot
	},
	["i:39339"] = { -- Emerald Pigment (Jadefire Ink)
		["i:3358"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.5000}, -- Goldthorn
		["i:3818"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.5000}, -- Fadeleaf
		["i:3819"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.5000}, -- Dragon's Teeth
		["i:3821"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.5000}, -- Khadgar's Whisker
	},
	["i:39340"] = { -- Violet Pigment (Celestial Ink)
		["i:8836"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Arthas' Tears
		["i:4625"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5450}, -- Firebloom
		["i:8831"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5540}, -- Purple Lotus
		["i:8838"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5600}, -- Sungrass
		["i:8839"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Blindweed
		["i:8845"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Ghost Mushroom
		["i:8846"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Gromsblood
	},
	["i:39341"] = { -- Silvery Pigment (Shimmering Ink)
		["i:13463"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5300}, -- Dreamfoil
		["i:13464"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5480}, -- Golden Sansam
		["i:13465"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Mountain Silversage
		["i:13466"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Sorrowmoss
		["i:13467"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Icecap
	},
	["i:39342"] = { -- Nether Pigment (Ethereal Ink)
		["i:22785"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Felweed
		["i:22786"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Dreaming Glory
		["i:22787"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Ragveil
		["i:22789"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Terocone
		["i:22790"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Ancient Lichen
		["i:22791"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Netherbloom
		["i:22792"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Nightmare Vine
		["i:22793"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Mana Thistle
	},
	["i:39343"] = { -- Azure Pigment (Ink of the Sea)
		["i:36904"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Tiger Lily
		["i:36907"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Talandra's Rose
		["i:36901"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Goldclover
		["i:39970"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Fire Leaf
		["i:37921"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Deadnettle
		["i:36903"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Adder's Tongue
		["i:36905"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Lichbloom
		["i:36906"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Icethorn
	},
	["i:61979"] = { -- Ashen Pigment (Blackfallow Ink)
		["i:52985"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Azshara's Veil
		["i:52983"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Cinderbloom
		["i:52986"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Heartblossom
		["i:52984"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Stormvine
		["i:52987"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Twilight Jasmine
		["i:52988"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Whiptail
	},
	["i:79251"] = { -- Shadow Pigment (Ink of Dreams)
		["i:72234"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Green Tea Leaf
		["i:72235"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Silkweed
		["i:72237"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Rain Poppy
		["i:79010"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Snow Lily
		["i:89639"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.5360}, -- Desecrated Herb
		["i:79011"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Fool's Cap
	},
	["i:114931"] = { -- Cerulean Pigment (Warbinder's Ink)
		["i:109124"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Frostweed
		["i:109125"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Fireweed
		["i:109126"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Gorgrond Flytrap
		["i:109127"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Starflower
		["i:109128"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Nagrand Arrowbloom
		["i:109129"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Talador Orchid
	},
	["i:129032"] = { -- Roseate Pigment (No Legion Ink)
		["i:128304"] = {matRate = 0.9900, minAmount = 1, maxAmount = 1, amountOfMats = 0.1980}, -- Yseralline Seed
		["i:124101"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Aethril
		["i:151565"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Astral Glory
		["i:124102"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Dreamleaf
		["i:124103"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Foxflower
		["i:124106"] = {matRate = 1.0000, minAmount = 2, maxAmount = 3, amountOfMats = 0.4200}, -- Felwort
		["i:124104"] = {matRate = 1.0000, minAmount = 2, maxAmount = 5, amountOfMats = 0.4650}, -- Fjarnskaggl
		["i:124105"] = {matRate = 1.0000, minAmount = 5, maxAmount = 8, amountOfMats = 1.2150}, -- Starlight Rose
	},
	["i:153635"] = { -- Ultramarine Pigment (Ultramarine Ink)
		["i:152505"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Riverbud
		["i:152506"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Star Moss
		["i:152507"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Akunda's Bite
		["i:152508"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Winter's Kiss
		["i:152509"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Siren's Pollen
		["i:152511"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Sea Stalk
		["i:152510"] = {matRate = 1.0000, minAmount = 1, maxAmount = 6, amountOfMats = 0.7468}, -- Anchor Weed
	},
	["i:153636"] = { -- Crimson Pigment (Crimson Ink)
		["i:152505"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Riverbud
		["i:152506"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Star Moss
		["i:152507"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Akunda's Bite
		["i:152508"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Winter's Kiss
		["i:152509"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Siren's Pollen
		["i:152511"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Sea Stalk
		["i:152510"] = {matRate = 0.6600, minAmount = 1, maxAmount = 4, amountOfMats = 0.2720}, -- Anchor Weed
	},
	["i:168662"] = { -- Maroon Pigment (Maroon Ink)
		["i:168487"] = {matRate = 1.0000, minAmount = 2, maxAmount = 4, amountOfMats = 0.6000}, -- Zin'anthid
	},
	["i:173056"] = { -- Umbral Pigment (Umbral ink)
		["i:168586"] = {matRate = 0.3500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1050}, -- Rising Glory
		["i:170554"] = {matRate = 0.3500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1050}, -- Vigil's Torch
		["i:168583"] = {matRate = 0.6500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1950}, -- Widowbloom
		["i:168589"] = {matRate = 0.6500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1950}, -- Marrowroot
		["i:169701"] = {matRate = 0.5000, minAmount = 1, maxAmount = 2, amountOfMats = 0.1500}, -- Death Blossom
		["i:171315"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.2480}, -- Nightshade
	},
	["i:173057"] = { -- Luminous Pigment (Luminous Ink)
		["i:168583"] = {matRate = 0.3500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1050}, -- Widowbloom
		["i:168589"] = {matRate = 0.3500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1050}, -- Marrowroot
		["i:168586"] = {matRate = 0.6500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1950}, -- Rising Glory
		["i:170554"] = {matRate = 0.6500, minAmount = 1, maxAmount = 2, amountOfMats = 0.1950}, -- Vigil's Torch
		["i:169701"] = {matRate = 0.5000, minAmount = 1, maxAmount = 2, amountOfMats = 0.1500}, -- Death Blossom
		["i:171315"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.2480}, -- Nightshade
	},
	-- ======================================= Uncommon Pigments =======================================
	["i:43103"] = { -- Verdant Pigment (Hunter's Ink)
		["i:785"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Mageroyal
		["i:2450"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0765}, -- Briarthorn
		["i:2452"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0765}, -- Swiftthistle
		["i:2453"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Bruiseweed
		["i:3820"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Stranglekelp
	},
	["i:43104"] = { -- Burnt Pigment (Dawnstar Ink)
		["i:3355"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0825}, -- Wild Steelbloom
		["i:3369"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0885}, -- Grave Moss
		["i:3356"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Kingsblood
		["i:3357"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Liferoot
	},
	["i:43105"] = { -- Indigo Pigment (Royal Ink)
		["i:3358"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0645}, -- Goldthorn
		["i:3818"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0745}, -- Fadeleaf
		["i:3819"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Dragon's Teeth
		["i:3821"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Khadgar's Whisker
	},
	["i:43106"] = { -- Ruby Pigment (Fiery Ink)
		["i:8836"] = {matRate = 0.3250, minAmount = 1, maxAmount = 3, amountOfMats = 0.0695}, -- Arthas' Tears
		["i:4625"] = {matRate = 0.3500, minAmount = 1, maxAmount = 3, amountOfMats = 0.0725}, -- Firebloom
		["i:8831"] = {matRate = 0.3750, minAmount = 1, maxAmount = 3, amountOfMats = 0.0795}, -- Purple Lotus
		["i:8838"] = {matRate = 0.4000, minAmount = 1, maxAmount = 3, amountOfMats = 0.0845}, -- Sungrass
		["i:8839"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Blindweed
		["i:8845"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Ghost Mushroom
		["i:8846"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Gromsblood
	},
	["i:43107"] = { -- Sapphire Pigment (Ink of the Sky)
		["i:13463"] = {matRate = 0.3100, minAmount = 1, maxAmount = 3, amountOfMats = 0.0665}, -- Dreamfoil
		["i:13464"] = {matRate = 0.3600, minAmount = 1, maxAmount = 3, amountOfMats = 0.0765}, -- Golden Sansam
		["i:13465"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Mountain Silversage
		["i:13466"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Sorrowmoss
		["i:13467"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Icecap
	},
	["i:43108"] = { -- Ebon Pigment (Darkflame Ink)
		["i:22785"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Felweed
		["i:22786"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Dreaming Glory
		["i:22787"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Ragveil
		["i:22789"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Terocone
		["i:22790"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Ancient Lichen
		["i:22791"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Netherbloom
		["i:22792"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Nightmare Vine
		["i:22793"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Mana Thistle
	},
	["i:43109"] = { -- Icy Pigment (Snowfall Ink)
		["i:36904"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Tiger Lily
		["i:36907"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Talandra's Rose
		["i:36901"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Goldclover
		["i:39970"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Fire Leaf
		["i:37921"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Deadnettle
		["i:36903"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Adder's Tongue
		["i:36905"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Lichbloom
		["i:36906"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Icethorn
	},
	["i:61980"] = { -- Burning Embers (Inferno Ink)
		["i:52985"] = {matRate = 0.3250, minAmount = 1, maxAmount = 3, amountOfMats = 0.0695}, -- Azshara's Veil
		["i:52983"] = {matRate = 0.3500, minAmount = 1, maxAmount = 3, amountOfMats = 0.0745}, -- Cinderbloom
		["i:52986"] = {matRate = 0.3750, minAmount = 1, maxAmount = 3, amountOfMats = 0.0795}, -- Heartblossom
		["i:52984"] = {matRate = 0.4000, minAmount = 1, maxAmount = 3, amountOfMats = 0.0845}, -- Stormvine
		["i:52987"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Twilight Jasmine
		["i:52988"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Whiptail
	},
	["i:79253"] = { -- Misty Pigment (Starlight Ink)
		["i:72234"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Green Tea Leaf
		["i:72235"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Silkweed
		["i:72237"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Rain Poppy
		["i:79010"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Snow Lily
		["i:89639"] = {matRate = 0.3300, minAmount = 1, maxAmount = 3, amountOfMats = 0.0705}, -- Desecrated Herb
		["i:79011"] = {matRate = 0.5000, minAmount = 1, maxAmount = 3, amountOfMats = 0.1075}, -- Fool's Cap
	},
	["i:129034"] = { -- Sallow Pigment (No Legion Ink)
		["i:128304"] = {matRate = 0.0100, minAmount = 1, maxAmount = 1, amountOfMats = 0.0020}, -- Yseralline Seed
		["i:124101"] = {matRate = 0.2200, minAmount = 1, maxAmount = 1, amountOfMats = 0.0440}, -- Aethril
		["i:151565"] = {matRate = 0.2200, minAmount = 1, maxAmount = 1, amountOfMats = 0.0440}, -- Astral Glory
		["i:124102"] = {matRate = 0.2200, minAmount = 1, maxAmount = 1, amountOfMats = 0.0440}, -- Dreamleaf
		["i:124103"] = {matRate = 0.2200, minAmount = 1, maxAmount = 1, amountOfMats = 0.0440}, -- Foxflower
		["i:124105"] = {matRate = 0.2200, minAmount = 1, maxAmount = 1, amountOfMats = 0.0440}, -- Starlight Rose
		["i:124104"] = {matRate = 0.2400, minAmount = 1, maxAmount = 2, amountOfMats = 0.0495}, -- Fjarnskaggl
		["i:124106"] = {matRate = 1.0000, minAmount = 8, maxAmount = 14, amountOfMats = 2.1480}, -- Felwort
	},
	["i:153669"] = { -- Viridescent Pigment (Viridescent Ink)
		["i:152505"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Riverbud
		["i:152506"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Star Moss
		["i:152507"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Akunda's Bite
		["i:152508"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Winter's Kiss
		["i:152509"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Siren's Pollen
		["i:152511"] = {matRate = 0.2750, minAmount = 1, maxAmount = 3, amountOfMats = 0.1100}, -- Sea Stalk
		["i:152510"] = {matRate = 0.9750, minAmount = 1, maxAmount = 4, amountOfMats = 0.3150}, -- Anchor Weed
	},
	["i:175788"] = { -- Tranquil Pigment (Tranquil Ink)
		["i:168583"] = {matRate = 0.0300, minAmount = 1, maxAmount = 1, amountOfMats = 0.0060}, -- Widowbloom
		["i:168589"] = {matRate = 0.0300, minAmount = 1, maxAmount = 1, amountOfMats = 0.0060}, -- Marrowroot
		["i:168586"] = {matRate = 0.0300, minAmount = 1, maxAmount = 1, amountOfMats = 0.0060}, -- Rising Glory
		["i:170554"] = {matRate = 0.0300, minAmount = 1, maxAmount = 1, amountOfMats = 0.0060}, -- Vigil's Torch
		["i:169701"] = {matRate = 0.0300, minAmount = 1, maxAmount = 1, amountOfMats = 0.0060}, -- Death Blossom
		["i:171315"] = {matRate = 1.0000, minAmount = 1, maxAmount = 2, amountOfMats = 0.3000}, -- Nightshade
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mill.TargetItemIterator()
	return private.TableKeyIterator, DATA, nil
end

function Mill.SourceItemIterator(targetItemString)
	return private.TableKeyIterator, DATA[targetItemString], nil
end

function Mill.GetRate(targetItemString, sourceItemString)
	return DATA[targetItemString][sourceItemString].amountOfMats, DATA[targetItemString][sourceItemString].matRate, DATA[targetItemString][sourceItemString].minAmount, DATA[targetItemString][sourceItemString].maxAmount
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TableKeyIterator(tbl, index)
	index = next(tbl, index)
	return index
end
