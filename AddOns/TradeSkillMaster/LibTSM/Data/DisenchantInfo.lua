-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DisenchantInfo = TSM.Init("Data.DisenchantInfo")
local private = {}
local DATA = nil



-- ============================================================================
-- Disenchant Rates Data
-- ============================================================================

if TSM.IsWowVanillaClassic() then
	DATA = {
		-- Dust
		["i:10940"] = { -- Strange Dust
			minLevel = 1,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.750, minAmount = 4, maxAmount = 6, amountOfMats = 3.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.150, minAmount = 4, maxAmount = 6, amountOfMats = 0.750},
			},
		},
		["i:11083"] = { -- Soul Dust
			minLevel = 21,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},
		["i:11137"] = { -- Vision Dust
			minLevel = 31,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},
		["i:11176"] = { -- Dream Dust
			minLevel = 41,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},
		["i:16204"] = { -- Illusion Dust
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},

		-- Essences
		["i:10938"] = { -- Lesser Magic Essence
			minLevel = 1,
			maxLevel = 10,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
			},
		},
		["i:10939"] = { -- Greater Magic Essence
			minLevel = 11,
			maxLevel = 15,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:10998"] = { -- Lesser Astral Essence
			minLevel = 16,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.150, minAmount = 1, maxAmount = 2, amountOfMats = 0.200},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11082"] = { -- Greater Astral Essence
			minLevel = 21,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11134"] = { -- Lesser Mystic Essence
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11135"] = { -- Greater Mystic Essence
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11174"] = { -- Lesser Nether Essence
			minLevel = 36,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11175"] = { -- Greater Nether Essence
			minLevel = 41,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.250, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:16202"] = { -- Lesser Eternal Essence
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:16203"] = { -- Greater Eternal Essence
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
			},
		},

		-- Shards
		["i:10978"] = { -- Small Glimmering Shard
			minLevel = 1,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 5, maxItemLevel = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 5, maxItemLevel = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11084"] = { -- Large Glimmering Shard
			minLevel = 21,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 26, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 26, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11138"] = { -- Small Glowing Shard
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 31, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 31, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11139"] = { -- Large Glowing Shard
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 36, maxItemLevel = 40, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 36, maxItemLevel = 40, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11177"] = { -- Small Radiant Shard
			minLevel = 36,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 41, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 40, maxItemLevel = 45, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 41, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 40, maxItemLevel = 45, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:11178"] = { -- Large Radiant Shard
			minLevel = 41,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:14343"] = { -- Small Brilliant Shard
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:14344"] = { -- Large Brilliant Shard
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 99, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 56, maxItemLevel = 60, matRate = 0.995, minAmount = 1, maxAmount = 1, amountOfMats = 0.995},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 61, maxItemLevel = 99, matRate = 0.990, minAmount = 1, maxAmount = 1, amountOfMats = 0.990},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 99, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 56, maxItemLevel = 60, matRate = 0.995, minAmount = 1, maxAmount = 1, amountOfMats = 0.995},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 61, maxItemLevel = 99, matRate = 0.990, minAmount = 1, maxAmount = 1, amountOfMats = 0.990},
			},
		},

		-- Crystals
		["i:20725"] = { -- Nexus Crystal
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 56, maxItemLevel = 60, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 61, maxItemLevel = 99, matRate = 0.010, minAmount = 1, maxAmount = 1, amountOfMats = 0.010},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 56, maxItemLevel = 60, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 61, maxItemLevel = 99, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 56, maxItemLevel = 60, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 61, maxItemLevel = 99, matRate = 0.010, minAmount = 1, maxAmount = 1, amountOfMats = 0.010},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 56, maxItemLevel = 60, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 61, maxItemLevel = 99, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
			},
		},
	}

elseif TSM.IsWowBCClassic() then
	DATA = {
		-- Dust
		["i:10940"] = { -- Strange Dust
			minLevel = 1,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 5, maxItemLevel = 15, requiredSkill = 1, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.750, minAmount = 4, maxAmount = 6, amountOfMats = 3.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 5, maxItemLevel = 15, requiredSkill = 1, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.150, minAmount = 4, maxAmount = 6, amountOfMats = 0.750},
			},
		},
		["i:11083"] = { -- Soul Dust
			minLevel = 21,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},
		["i:11137"] = { -- Vision Dust
			minLevel = 31,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
			},
		},
		["i:11176"] = { -- Dream Dust
			minLevel = 41,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.750},
			},
		},
		["i:16204"] = { -- Illusion Dust
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.220, minAmount = 1, maxAmount = 2, amountOfMats = 0.330},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.750},
			},
		},
		["i:22445"] = { -- Arcane Dust
			minLevel = 61,
			maxLevel = 70,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 66, maxItemLevel = 79, requiredSkill = 225, matRate = 0.750, minAmount = 1, maxAmount = 3, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 80, maxItemLevel = 99, requiredSkill = 225, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.800},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 66, maxItemLevel = 79, requiredSkill = 225, matRate = 0.220, minAmount = 1, maxAmount = 3, amountOfMats = 0.440},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 80, maxItemLevel = 99, requiredSkill = 225, matRate = 0.220, minAmount = 2, maxAmount = 3, amountOfMats = 0.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.770},
			},
		},

		-- Essences
		["i:10938"] = { -- Lesser Magic Essence
			minLevel = 1,
			maxLevel = 10,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 5, maxItemLevel = 15, requiredSkill = 1, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 5, maxItemLevel = 15, requiredSkill = 1, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
			},
		},
		["i:10939"] = { -- Greater Magic Essence
			minLevel = 11,
			maxLevel = 15,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:10998"] = { -- Lesser Astral Essence
			minLevel = 16,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.150, minAmount = 1, maxAmount = 2, amountOfMats = 0.220},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11082"] = { -- Greater Astral Essence
			minLevel = 21,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11134"] = { -- Lesser Mystic Essence
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11135"] = { -- Greater Mystic Essence
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11174"] = { -- Lesser Nether Essence
			minLevel = 36,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:11175"] = { -- Greater Nether Essence
			minLevel = 41,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:16202"] = { -- Lesser Eternal Essence
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},
		["i:16203"] = { -- Greater Eternal Essence
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
			},
		},
		["i:22447"] = { -- Lesser Planar Essence
			minLevel = 61,
			maxLevel = 65,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 66, maxItemLevel = 79, requiredSkill = 225, matRate = 0.220, minAmount = 1, maxAmount = 3, amountOfMats = 0.340},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 80, maxItemLevel = 99, requiredSkill = 225, matRate = 0.220, minAmount = 2, maxAmount = 3, amountOfMats = 0.550},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 66, maxItemLevel = 79, requiredSkill = 225, matRate = 0.750, minAmount = 1, maxAmount = 3, amountOfMats = 1.175},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 80, maxItemLevel = 99, requiredSkill = 225, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
			},
		},
		["i:22446"] = { -- Greater Planar Essence
			minLevel = 66,
			maxLevel = 70,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 100, maxItemLevel = 999,  requiredSkill = 275, matRate = 0.220, minAmount = 1, maxAmount = 2, amountOfMats = 0.330},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 100, maxItemLevel = 999,  requiredSkill = 275, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
			},
		},

		-- Shards
		["i:10978"] = { -- Small Glimmering Shard
			minLevel = 1,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 1, maxItemLevel = 25, requiredSkill = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 1, maxItemLevel = 25, requiredSkill = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 16, maxItemLevel = 20, requiredSkill = 1, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 21, maxItemLevel = 25, requiredSkill = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 1, maxItemLevel = 25, requiredSkill = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 1, maxItemLevel = 25, requiredSkill = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11084"] = { -- Large Glimmering Shard
			minLevel = 21,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 26, maxItemLevel = 30, requiredSkill = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11138"] = { -- Small Glowing Shard
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 31, maxItemLevel = 35, requiredSkill = 75, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11139"] = { -- Large Glowing Shard
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 36, maxItemLevel = 40, requiredSkill = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:11177"] = { -- Small Radiant Shard
			minLevel = 36,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 41, maxItemLevel = 45, requiredSkill = 125, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:11178"] = { -- Large Radiant Shard
			minLevel = 41,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 46, maxItemLevel = 50, requiredSkill = 150, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:14343"] = { -- Small Brilliant Shard
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 51, maxItemLevel = 55, requiredSkill = 175, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
			},
		},
		["i:14344"] = { -- Large Brilliant Shard
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 61, maxItemLevel = 65, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:22448"] = { -- Small Prismatic Shard
			minLevel = 61,
			maxLevel = 65,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 66, maxItemLevel = 99, requiredSkill = 225, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 66, maxItemLevel = 99, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 66, maxItemLevel = 99, requiredSkill = 225, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 66, maxItemLevel = 99, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:22449"] = { -- Large Prismatic Shard
			minLevel = 66,
			maxLevel = 70,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.030, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},

		-- Crystals
		["i:20725"] = { -- Nexus Crystal
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 61, maxItemLevel = 99, requiredSkill = 225, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 61, maxItemLevel = 89, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 90, maxItemLevel = 94, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 61, maxItemLevel = 99, requiredSkill = 225, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 56, maxItemLevel = 60, requiredSkill = 200, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 61, maxItemLevel = 89, requiredSkill = 225, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 90, maxItemLevel = 94, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
			},
		},
		["i:22450"] = { -- Void Crystal
			minLevel = 61,
			maxLevel = 70,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 95, maxItemLevel = 104, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 105, maxItemLevel = 999, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 100, maxItemLevel = 999, requiredSkill = 275, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 95, maxItemLevel = 104, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 105, maxItemLevel = 999, requiredSkill = 300, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
			},
		},
	}
else
	DATA = {
		-- Dust
		["i:10940"] = { -- Strange Dust
			minLevel = 1,
			maxLevel = 12,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 1, maxItemLevel = 8, matRate = 0.800, minAmount = 1, maxAmount = 6, amountOfMats = 1.222},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 9, maxItemLevel = 12, matRate = 0.800, minAmount = 2, maxAmount = 8, amountOfMats = 2.025},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 13, maxItemLevel = 16, matRate = 1.000, minAmount = 4, maxAmount = 10, amountOfMats = 5.008},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 5, maxItemLevel = 16, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 1, maxItemLevel = 8, matRate = 0.200, minAmount = 1, maxAmount = 4, amountOfMats = 0.302},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 9, maxItemLevel = 12, matRate = 0.200, minAmount = 2, maxAmount = 6, amountOfMats = 0.507},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 13, maxItemLevel = 16, matRate = 0.150, minAmount = 4, maxAmount = 8, amountOfMats = 0.753},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 5, maxItemLevel = 16, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
			},
		},
		["i:16204"] = { -- Light Illusion Dust
			minLevel = 11,
			maxLevel = 21,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.750, minAmount = 1, maxAmount = 6, amountOfMats = 1.155},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.344},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
			},
		},
		["i:156930"] = { -- Rich Illusion Dust
			minLevel = 20,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.750, minAmount = 1, maxAmount = 6, amountOfMats = 1.155},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 0.200, minAmount = 3, maxAmount = 6, amountOfMats = 0.900},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.220, minAmount = 1, maxAmount = 6, amountOfMats = 0.344},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 0.200, minAmount = 3, maxAmount = 6, amountOfMats = 0.900},
			},
		},
		["i:22445"] = { -- Arcane Dust
			minLevel = 24,
			maxLevel = 27,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.750, minAmount = 2, maxAmount = 7, amountOfMats = 1.933},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.750, minAmount = 2, maxAmount = 9, amountOfMats = 2.655},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.220, minAmount = 2, maxAmount = 7, amountOfMats = 0.787},
			},
		},
		["i:34054"] = { -- Infinite Dust
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.750, minAmount = 2, maxAmount = 7, amountOfMats = 1.933},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.750, minAmount = 4, maxAmount = 11, amountOfMats = 4.155},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.220, minAmount = 4, maxAmount = 9, amountOfMats = 1.200},
			},
		},
		["i:52555"] = { -- Hypnotic Dust
			minLevel = 29,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 36, matRate = 0.750, minAmount = 1, maxAmount = 8, amountOfMats = 1.556},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 37, maxItemLevel = 37, matRate = 0.750, minAmount = 1, maxAmount = 10, amountOfMats = 2.628},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 36, matRate = 0.250, minAmount = 1, maxAmount = 6, amountOfMats = 0.510},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 37, maxItemLevel = 37, matRate = 0.250, minAmount = 1, maxAmount = 10, amountOfMats = 0.864},
			},
		},
		["i:74249"] = { -- Spirit Dust
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 38, maxItemLevel = 38, matRate = 0.850, minAmount = 1, maxAmount = 9, amountOfMats = 2.285},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 39, maxItemLevel = 39, matRate = 0.850, minAmount = 2, maxAmount = 10, amountOfMats = 3.135},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 38, maxItemLevel = 38, matRate = 0.850, minAmount = 1, maxAmount = 8, amountOfMats = 2.245},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 39, maxItemLevel = 39, matRate = 0.850, minAmount = 3, maxAmount = 10, amountOfMats = 3.560},
			},
		},
		["i:109693"] = { -- Draenic Dust
			minLevel = 35,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 40, maxItemLevel = 44, matRate = 1.000, minAmount = 1, maxAmount = 4, amountOfMats = 2.600},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.750, minAmount = 5, maxAmount = 12, amountOfMats = 5.810},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 40, maxItemLevel = 44, matRate = 1.000, minAmount = 1, maxAmount = 4, amountOfMats = 2.600},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.800, minAmount = 5, maxAmount = 12, amountOfMats = 6.220},
			},
		},
		["i:124440"] = { -- Arkhana
			minLevel = 40,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 45, maxItemLevel = 48, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 4.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 45, maxItemLevel = 48, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 4.750},
			},
		},
		["i:152875"] = { -- Gloom Dust
			minLevel = 45,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 49, maxItemLevel = 52, matRate = 1.000, minAmount = 1, maxAmount = 6, amountOfMats = 3.600},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 53, maxItemLevel = 58, matRate = 1.000, minAmount = 4, maxAmount = 9, amountOfMats = 6.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 0.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.425},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 0.200, minAmount = 4, maxAmount = 6, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 49, maxItemLevel = 52, matRate = 1.000, minAmount = 1, maxAmount = 6, amountOfMats = 3.600},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 53, maxItemLevel = 58, matRate = 1.000, minAmount = 4, maxAmount = 9, amountOfMats = 6.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 1.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.425},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 1.200, minAmount = 4, maxAmount = 6, amountOfMats = 1.000},
			},
		},
		["i:172230"] = { -- Soul Dust
			minLevel = 50,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 2.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.400},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 2.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.400},
			},
		},

		-- Essences
		["i:10938"] = { -- Lesser Magic Essence
			minLevel = 1,
			maxLevel = 7,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 1, maxItemLevel = 8, matRate = 0.200, minAmount = 1, maxAmount = 6, amountOfMats = 0.303},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 1, maxItemLevel = 8, matRate = 0.800, minAmount = 1, maxAmount = 5, amountOfMats = 1.218},
			},
		},
		["i:10939"] = { -- Greater Magic Essence
			minLevel = 8,
			maxLevel = 11,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 9, maxItemLevel = 16, matRate = 0.200, minAmount = 1, maxAmount = 5, amountOfMats = 0.307},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 5, maxItemLevel = 16, matRate = 1.000, minAmount = 2, maxAmount = 2, amountOfMats = 2.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 9, maxItemLevel = 16, matRate = 0.200, minAmount = 1, maxAmount = 4, amountOfMats = 1.217},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 5, maxItemLevel = 16, matRate = 1.000, minAmount = 2, maxAmount = 2, amountOfMats = 2.000},
			},
		},
		["i:16202"] = { -- Lesser Eternal Essence
			minLevel = 12,
			maxLevel = 20,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 0.220, minAmount = 1, maxAmount = 3, amountOfMats = 0.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.750, minAmount = 1, maxAmount = 4, amountOfMats = 1.302},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 0.750},
			},
		},
		["i:16203"] = { -- Greater Eternal Essence
			minLevel = 20,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.650},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 0.800, minAmount = 2, maxAmount = 5, amountOfMats = 2.800},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.182},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.650},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 0.800, minAmount = 2, maxAmount = 5, amountOfMats = 2.800},
			},
		},
		["i:22447"] = { -- Lesser Planar Essence
			minLevel = 24,
			maxLevel = 27,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
			},
		},
		["i:22446"] = { -- Greater Planar Essence
			minLevel = 24,
			maxLevel = 27,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.170},
			},
		},
		["i:34056"] = { -- Lesser Cosmic Essence
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
			},
		},
		["i:34055"] = { -- Greater Cosmic Essence
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.170},
			},
		},
		["i:52718"] = { -- Lesser Celestial Essence
			minLevel = 29,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 36, maxItemLevel = 36, matRate = 0.250, minAmount = 2, maxAmount = 5, amountOfMats = 0.655},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 36, maxItemLevel = 36, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
			},
		},
		["i:52719"] = { -- Greater Celestial Essence
			minLevel = 29,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 37, maxItemLevel = 37, matRate = 0.250, minAmount = 1, maxAmount = 5, amountOfMats = 0.412},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 37, maxItemLevel = 37, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.157},
			},
		},
		["i:74250"] = { -- Mysterious Essence
			minLevel = 31,
			maxLevel = 34,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 38, maxItemLevel = 38, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.178},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 39, maxItemLevel = 39, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.244},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 38, maxItemLevel = 38, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.178},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 39, maxItemLevel = 39, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.333},
			},
		},

		-- Shards
		["i:14343"] = { -- Small Brilliant Shard
			minLevel = 12,
			maxLevel = 21,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 17, maxItemLevel = 24, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 17, maxItemLevel = 24, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
			},
		},
		["i:14344"] = { -- Large Brilliant Shard
			minLevel = 20,
			maxLevel = 25,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 1.000, minAmount = 2, maxAmount = 5, amountOfMats = 3.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 25, maxItemLevel = 29, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 25, maxItemLevel = 29, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 29, maxItemLevel = 30, matRate = 1.000, minAmount = 2, maxAmount = 5, amountOfMats = 3.500},
			},
		},
		["i:22448"] = { -- Small Prismatic Shard
			minLevel = 23,
			maxLevel = 27,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 30, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.030},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 30, maxItemLevel = 30, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 30, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.030},
			},
		},
		["i:22449"] = { -- Large Prismatic Shard
			minLevel = 23,
			maxLevel = 27,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 31, maxItemLevel = 31, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.03},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 31, maxItemLevel = 31, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 31, maxItemLevel = 31, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.03},
			},
		},
		["i:34053"] = { -- Small Dream Shard
			minLevel = 27,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 32, maxItemLevel = 33, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 32, maxItemLevel = 33, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 32, maxItemLevel = 33, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:34052"] = { -- Dream Shard
			minLevel = 27,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 34, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 2, minItemLevel = 34, maxItemLevel = 35, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 34, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:52720"] = { -- Small Heavenly Shard
			minLevel = 29,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 36, maxItemLevel = 36, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 36, maxItemLevel = 36, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:52721"] = { -- Heavenly Shard
			minLevel = 29,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 37, maxItemLevel = 37, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 37, maxItemLevel = 37, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:74252"] = { -- Small Ethereal Shard
			minLevel = 32,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 38, maxItemLevel = 38, matRate = 0.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 39, maxItemLevel = 39, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 38, maxItemLevel = 38, matRate = 0.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 39, maxItemLevel = 39, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
			},
		},
		["i:74247"] = { -- Ethereal Shard
			minLevel = 32,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 38, maxItemLevel = 38, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 39, maxItemLevel = 39, matRate = 0.950, minAmount = 1, maxAmount = 1, amountOfMats = 0.950},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 38, maxItemLevel = 38, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 39, maxItemLevel = 39, matRate = 0.950, minAmount = 1, maxAmount = 1, amountOfMats = 0.950},
			},
		},
		["i:115502"] = { -- Small Luminous Shard
			minLevel = 35,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 42, maxItemLevel = 44, matRate = 0.100, minAmount = 3, maxAmount = 6, amountOfMats = 0.430},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 42, maxItemLevel = 44, matRate = 0.100, minAmount = 3, maxAmount = 6, amountOfMats = 0.430},
			},
		},
		["i:111245"] = { -- Luminous Shard
			minLevel = 35,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 42, maxItemLevel = 44, matRate = 0.220, minAmount = 1, maxAmount = 1, amountOfMats = 0.220},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 42, maxItemLevel = 44, matRate = 0.220, minAmount = 1, maxAmount = 1, amountOfMats = 0.220},
			},
		},
		["i:124441"] = { -- Leylight Shard
			minLevel = 40,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 45, maxItemLevel = 46, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 45, maxItemLevel = 46, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:152876"] = { -- Umbra Shard
			minLevel = 45,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 0.400, minAmount = 1, maxAmount = 2, amountOfMats = 0.600},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 0.400, minAmount = 1, maxAmount = 2, amountOfMats = 0.600},
			},
		},
		["i:172231"] = { -- Sacred Shard
			minLevel = 50,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 101, maxItemLevel = 999, matRate = 0.350, minAmount = 1, maxAmount = 1, amountOfMats = 0.350},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 85, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 101, maxItemLevel = 999, matRate = 0.350, minAmount = 1, maxAmount = 1, amountOfMats = 0.350},
			},
		},

		-- Crystals
		["i:22450"] = { -- Void Crystal
			minLevel = 26,
			maxLevel = 26,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 30, maxItemLevel = 34, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 1.530},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 30, maxItemLevel = 34, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 1.530},
			},
		},
		["i:34057"] = { -- Abyss Crystal
			minLevel = 30,
			maxLevel = 30,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 35, maxItemLevel = 36, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 35, maxItemLevel = 36, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:52722"] = { -- Maelstrom Crystal
			minLevel = 32,
			maxLevel = 32,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 37, maxItemLevel = 38, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 37, maxItemLevel = 38, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:74248"] = { -- Sha Crystal
			minLevel = 32,
			maxLevel = 35,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 39, maxItemLevel = 42, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 39, maxItemLevel = 42, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:115504"] = { -- Fractured Temporal Crystal
			minLevel = 35,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.100, minAmount = 3, maxAmount = 3, amountOfMats = 0.300},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 43, maxItemLevel = 47, matRate = 0.250, minAmount = 3, maxAmount = 3, amountOfMats = 0.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.050, minAmount = 3, maxAmount = 3, amountOfMats = 0.150},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 43, maxItemLevel = 47, matRate = 0.250, minAmount = 3, maxAmount = 3, amountOfMats = 0.750},
			},
		},
		["i:113588"] = { -- Temporal Crystal
			minLevel = 35,
			maxLevel = 40,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 43, maxItemLevel = 47, matRate = 0.750, minAmount = 1, maxAmount = 1, amountOfMats = 0.750},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 40, maxItemLevel = 44, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 43, maxItemLevel = 47, matRate = 0.750, minAmount = 1, maxAmount = 1, amountOfMats = 0.750},
			},
		},
		["i:124442"] = { -- Chaos Crystal
			minLevel = 40,
			maxLevel = 45,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 50, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 50, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:152877"] = { -- Veiled Crystal
			minLevel = 45,
			maxLevel = 50,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 3, minItemLevel = 51, maxItemLevel = 84, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 58, maxItemLevel = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
		["i:172232"] = { -- Eternal Crystal
			minLevel = 50,
			maxLevel = 60,
			sourceInfo = {
				{classId = LE_ITEM_CLASS_ARMOR, quality = 4, minItemLevel = 101, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				{classId = LE_ITEM_CLASS_WEAPON, quality = 4, minItemLevel = 101, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
			},
		},
	}
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function DisenchantInfo.TargetItemIterator()
	return private.TargetItemIteratorHelper
end

function DisenchantInfo.GetInfo(targetItemString)
	return DATA[targetItemString]
end

function DisenchantInfo.IsTargetItem(itemString)
	return DATA[itemString] and true or false
end

function DisenchantInfo.GetTargetItemSourceInfo(targetItemString, classId, quality, ilvl)
	local amountOfMats, matRate, minAmount, maxAmount, requiredSkill = nil, nil, nil, nil, nil
	for _, info in ipairs(DATA[targetItemString].sourceInfo) do
		if info.classId == classId and info.quality == quality and ilvl >= info.minItemLevel and ilvl <= info.maxItemLevel then
			assert(not amountOfMats)
			amountOfMats = info.amountOfMats
			matRate = info.matRate
			minAmount = info.minAmount
			maxAmount = info.maxAmount
			requiredSkill = info.requiredSkill
		end
	end
	return amountOfMats, matRate, minAmount, maxAmount, requiredSkill
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TargetItemIteratorHelper(_, index)
	index = next(DATA, index)
	return index
end
