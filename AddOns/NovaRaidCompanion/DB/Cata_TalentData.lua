----------------------------------
---NovaRaidCompanion Talent Data--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isCata) then
	return;
end

local specData = {
	--classID.
	[1] = {
		name = "WARRIOR",
		icon = 626008,
		iconPath = "Interface\\Icons\\ClassIcon_Warrior",
		--Specs, id is from talent book left to right.
		[1] = {
			name = "Arms",
			icon = 132219,
			iconPath = "Interface\\Icons\\Ability_Kick",
		},
		[2] = {
			name = "Fury",
			icon = 132347,
			iconPath = "Interface\\Icons\\Ability_Warrior_InnerRage",
		},
		[3] = {
			name = "Protection",
			icon = 132341,
			iconPath = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
		},
	},
	[2] = {
		name = "PALADIN",
		icon = 626003,
		iconPath = "Interface\\Icons\\ClassIcon_Paladin",
		[1] = {
			name = "Holy",
			icon = 135920,
			iconPath = "Interface\\Icons\\Spell_Holy_HolyBolt",
		},
		[2] = {
			name = "Protection",
			icon = 135893,
			iconPath = "Interface\\Icons\\SPELL_HOLY_DEVOTIONAURA",
		},
		[3] = {
			name = "Retribution",
			icon = 135873,
			iconPath = "Interface\\Icons\\Spell_Holy_AuraOfLight",
		},
	},
	[3] = {
		name = "HUNTER",
		icon = 626000,
		iconPath = "Interface\\Icons\\ClassIcon_Hunter",
		[1] = {
			name = "Beast Mastery",
			icon = 132164,
			iconPath = "Interface\\Icons\\Ability_Hunter_BeastTaming",
		},
		[2] = {
			name = "Marksmanship",
			icon = 132222,
			iconPath = "Interface\\Icons\\Ability_Marksmanship",
		},
		[3] = {
			name = "Survival",
			icon = 132215,
			iconPath = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
		},
	},
	[4] = {
		name = "ROGUE",
		icon = 626005,
		iconPath = "Interface\\Icons\\ClassIcon_Rogue",
		[1] = {
			name = "Assassination",
			icon = 132292,
			iconPath = "Interface\\Icons\\Ability_Rogue_Eviscerate",
		},
		[2] = {
			name = "Combat",
			icon = 132090,
			iconPath = "Interface\\Icons\\Ability_BackStab",
		},
		[3] = {
			name = "Subtlety",
			icon = 132320,
			iconPath = "Interface\\Icons\\Ability_Stealth",
		},
	},
	[5] = {
		name = "PRIEST",
		icon = 626004,
		iconPath = "Interface\\Icons\\ClassIcon_Priest",
		[1] = {
			name = "Discipline",
			icon = 135940,
			iconPath = "Interface\\Icons\\spell_holy_powerwordshield",
		},
		[2] = {
			name = "Holy",
			--icon = 135920, --Classic/TBC
			--iconPath = "Interface\\Icons\\Spell_Holy_HolyBolt",
			--icon = 237542, --Better holy priest icon but doesn't exist in Classic/TBC.
			--iconPath = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
			--Use addon path for both, should be fine as icon is just for setextures for now.
			icon = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Blizzard\\Spell_Holy_GuardianSpirit",
			iconPath = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Blizzard\\Spell_Holy_GuardianSpirit",
		},
		[3] = {
			name = "Shadow",
			icon = 136207,
			iconPath = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
		},
	},
	[6] = {
		name = "DEATHKNIGHT",
		icon = 135771,
		iconPath = "Interface\\Icons\\ClassIcon_DeathKnight",
		[1] = {
			name = "Blood",
			icon = 135770,
			iconPath = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
		},
		[2] = {
			name = "Frost",
			icon = 135773,
			iconPath = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
		},
		[3] = {
			name = "Unholy",
			icon = 135775,
			iconPath = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
		},
	},
	[7] = {
		name = "SHAMAN",
		icon = 626006,
		iconPath = "Interface\\Icons\\ClassIcon_Shaman",
		[1] = {
			name = "Elemental",
			icon = 136048,
			iconPath = "Interface\\Icons\\Spell_Nature_Lightning",
		},
		[2] = {
			name = "Enhancement",
			icon = 136051,
			iconPath = "Interface\\Icons\\Spell_Nature_LightningShield",
		},
		[3] = {
			name = "Restoration",
			icon = 136052,
			iconPath = "Interface\\Icons\\Spell_Nature_MagicImmunity",
		},
	},
	[8] = {
		name = "MAGE",
		icon = 626001,
		iconPath = "Interface\\Icons\\ClassIcon_Mage",
		[1] = {
			name = "Arcane",
			icon = 135932,
			iconPath = "Interface\\Icons\\Spell_Holy_MagicalSentry",
		},
		[2] = {
			name = "Fire",
			icon = 135810,
			iconPath = "Interface\\Icons\\Spell_Fire_FireBolt02",
		},
		[3] = {
			name = "Frost",
			icon = 135846,
			iconPath = "Interface\\Icons\\Spell_Frost_FrostBolt02",
		},
	},
	[9] = {
		name = "WARLOCK",
		icon = 626007,
		iconPath = "Interface\\Icons\\ClassIcon_Warlock",
		--Specs, id is from talent book left to right.
		[1] = {
			name = "Affliction",
			icon = 136145,
			iconPath = "Interface\\Icons\\Spell_Shadow_DeathCoil",
		},
		[2] = {
			name = "Demonology",
			icon = 136172,
			iconPath = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
		},
		[3] = {
			name = "Destruction",
			icon = 136186,
			iconPath = "Interface\\Icons\\Spell_Shadow_RainOfFire",
		},
	},
	--[[[10] = {
		name = "MONK",
		icon = 136830,
		iconPath = "Interface\\Icons\\ClassIcon_Monk",
		[1] = {
			name = "Windwalker",
			icon = 608953,
			iconPath = "Interface\\Icons\\Spell_Monk_WindWalker_Spec",
		},
		[2] = {
			name = "Brewmaster",
			icon = 608951,
			iconPath = "Interface\\Icons\\Spell_Monk_Brewmaster_Spec",
		},
		[3] = {
			name = "Mistweaver",
			icon = 608952,
			iconPath = "Interface\\Icons\\Spell_Monk_MistWeaver_Spec",
		},
	},]]
	[11] = {
		name = "DRUID",
		icon = 625999,
		iconPath = "Interface\\Icons\\ClassIcon_Druid",
		[1] = {
			name = "Balance",
			icon = 136096,
			iconPath = "Interface\\Icons\\Spell_Nature_StarFall",
		},
		[2] = {
			name = "Feral",
			icon = 132276,
			iconPath = "Interface\\Icons\\Ability_Racial_BearForm",
		},
		--[3] = {
		--	name = "Guardian",
		--	icon = 132276,
			iconPath = "Interface\\Icons\\Ability_Racial_BearForm",
		--},
		[3] = { --Needs changing to 4 once druids gain 4th spec.
			name = "Restoration",
			icon = 136041,
			iconPath = "Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH",
		},
	},
};

function NRC.getSpecData(classID, specID)
	if (specData[classID] and specData[classID][specID]) then
		local name = specData[classID][specID].name;
		local icon = specData[classID][specID].icon;
		local iconPath = specData[classID][specID].iconPath;
		return name, icon, iconPath;
	end
end

--All this class data has come from Talented Classic, a very good talent template addon.
--Permission was given by the author to use it here.
local talents = {};
talents.druid = {
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Nature's Grace",
					["talentRankSpellIds"] = {
						16880, -- [1]
						61345, -- [2]
						61346, -- [3]
					},
					["column"] = 1,
					["icon"] = 136062,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Starlight Wrath",
					["talentRankSpellIds"] = {
						16814, -- [1]
						16815, -- [2]
						16816, -- [3]
					},
					["column"] = 2,
					["icon"] = 136006,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Nature's Majesty",
					["talentRankSpellIds"] = {
						35363, -- [1]
						35364, -- [2]
					},
					["column"] = 3,
					["icon"] = 135138,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Genesis",
					["talentRankSpellIds"] = {
						57810, -- [1]
						57811, -- [2]
						57812, -- [3]
					},
					["column"] = 1,
					["icon"] = 135730,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Moonglow",
					["talentRankSpellIds"] = {
						16845, -- [1]
						16846, -- [2]
						16847, -- [3]
					},
					["column"] = 2,
					["icon"] = 136087,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Balance of Power",
					["talentRankSpellIds"] = {
						33592, -- [1]
						33596, -- [2]
					},
					["column"] = 3,
					["icon"] = 132113,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Euphoria",
					["talentRankSpellIds"] = {
						81061, -- [1]
						81062, -- [2]
					},
					["column"] = 1,
					["icon"] = 341763,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Moonkin Form",
					["talentRankSpellIds"] = {
						24858, -- [1]
					},
					["column"] = 2,
					["icon"] = 136036,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Typhoon",
					["talentRankSpellIds"] = {
						50516, -- [1]
					},
					["column"] = 3,
					["icon"] = 236170,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Shooting Stars",
					["talentRankSpellIds"] = {
						93398, -- [1]
						93399, -- [2]
					},
					["column"] = 4,
					["icon"] = 236205,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Owlkin Frenzy",
					["talentRankSpellIds"] = {
						48389, -- [1]
						48392, -- [2]
						48393, -- [3]
					},
					["column"] = 2,
					["icon"] = 236163,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Gale Winds",
					["talentRankSpellIds"] = {
						48488, -- [1]
						48514, -- [2]
					},
					["column"] = 3,
					["icon"] = 236154,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Solar Beam",
					["talentRankSpellIds"] = {
						78675, -- [1]
					},
					["column"] = 4,
					["icon"] = 252188,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Dreamstate",
					["talentRankSpellIds"] = {
						33597, -- [1]
						33599, -- [2]
					},
					["column"] = 1,
					["icon"] = 132123,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Force of Nature",
					["talentRankSpellIds"] = {
						33831, -- [1]
					},
					["column"] = 2,
					["icon"] = 132129,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Sunfire",
					["talentRankSpellIds"] = {
						93401, -- [1]
					},
					["column"] = 3,
					["icon"] = 236216,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Earth and Moon",
					["talentRankSpellIds"] = {
						48506, -- [1]
					},
					["column"] = 4,
					["icon"] = 236150,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Fungal Growth",
					["talentRankSpellIds"] = {
						78788, -- [1]
						78789, -- [2]
					},
					["column"] = 2,
					["icon"] = 132371,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Lunar Shower",
					["talentRankSpellIds"] = {
						33603, -- [1]
						33604, -- [2]
						33605, -- [3]
					},
					["column"] = 3,
					["icon"] = 236704,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Starfall",
					["talentRankSpellIds"] = {
						48505, -- [1]
					},
					["column"] = 2,
					["icon"] = 236168,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "DruidBalance",
			["name"] = "Balance",
			["icon"] = 136096,
		},
	}, -- [1]
	{
		["numtalents"] = 22,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Feral Swiftness",
					["talentRankSpellIds"] = {
						17002, -- [1]
						24866, -- [2]
					},
					["column"] = 1,
					["icon"] = 136095,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Furor",
					["talentRankSpellIds"] = {
						17056, -- [1]
						17058, -- [2]
						17059, -- [3]
					},
					["column"] = 2,
					["icon"] = 135881,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Predatory Strikes",
					["talentRankSpellIds"] = {
						16972, -- [1]
						16974, -- [2]
					},
					["column"] = 3,
					["icon"] = 132185,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Infected Wounds",
					["talentRankSpellIds"] = {
						48483, -- [1]
						48484, -- [2]
					},
					["column"] = 1,
					["icon"] = 236158,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Fury Swipes",
					["talentRankSpellIds"] = {
						48532, -- [1]
						80552, -- [2]
						80553, -- [3]
					},
					["column"] = 2,
					["icon"] = 132134,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Primal Fury",
					["talentRankSpellIds"] = {
						37116, -- [1]
						37117, -- [2]
					},
					["column"] = 3,
					["icon"] = 132278,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Feral Aggression",
					["talentRankSpellIds"] = {
						16858, -- [1]
						16859, -- [2]
					},
					["column"] = 4,
					["icon"] = 132121,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "King of the Jungle",
					["talentRankSpellIds"] = {
						48492, -- [1]
						48494, -- [2]
						48495, -- [3]
					},
					["column"] = 1,
					["icon"] = 236159,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Feral Charge",
					["talentRankSpellIds"] = {
						49377, -- [1]
					},
					["column"] = 2,
					["icon"] = 132183,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Stampede",
					["talentRankSpellIds"] = {
						78892, -- [1]
						78893, -- [2]
					},
					["column"] = 3,
					["icon"] = 304501,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Thick Hide",
					["talentRankSpellIds"] = {
						16929, -- [1]
						16930, -- [2]
						16931, -- [3]
					},
					["column"] = 4,
					["icon"] = 134355,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Leader of the Pack",
					["talentRankSpellIds"] = {
						17007, -- [1]
					},
					["column"] = 2,
					["icon"] = 136112,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Brutal Impact",
					["talentRankSpellIds"] = {
						16940, -- [1]
						16941, -- [2]
					},
					["column"] = 3,
					["icon"] = 132114,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Nurturing Instinct",
					["talentRankSpellIds"] = {
						33872, -- [1]
						33873, -- [2]
					},
					["column"] = 4,
					["icon"] = 132130,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Primal Madness",
					["talentRankSpellIds"] = {
						80316, -- [1]
						80317, -- [2]
					},
					["column"] = 1,
					["icon"] = 132242,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Survival Instincts",
					["talentRankSpellIds"] = {
						61336, -- [1]
					},
					["column"] = 2,
					["icon"] = 236169,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Endless Carnage",
					["talentRankSpellIds"] = {
						80314, -- [1]
						80315, -- [2]
					},
					["column"] = 3,
					["icon"] = 237513,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Natural Reaction",
					["talentRankSpellIds"] = {
						57878, -- [1]
						57880, -- [2]
					},
					["column"] = 4,
					["icon"] = 132091,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Blood in the Water",
					["talentRankSpellIds"] = {
						80318, -- [1]
						80319, -- [2]
					},
					["column"] = 1,
					["icon"] = 237347,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Rend and Tear",
					["talentRankSpellIds"] = {
						48432, -- [1]
						48433, -- [2]
						48434, -- [3]
					},
					["column"] = 2,
					["icon"] = 236164,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Pulverize",
					["talentRankSpellIds"] = {
						80313, -- [1]
					},
					["column"] = 3,
					["icon"] = 132318,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [21]
			{
				["info"] = {
					["wowTreeIndex"] = 22,
					["name"] = "Berserk",
					["talentRankSpellIds"] = {
						50334, -- [1]
					},
					["column"] = 2,
					["icon"] = 236149,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [22]
		},
		["info"] = {
			["background"] = "DruidFeralCombat",
			["name"] = "Feral Combat",
			["icon"] = 132276,
		},
	}, -- [2]
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Blessing of the Grove",
					["talentRankSpellIds"] = {
						78784, -- [1]
						78785, -- [2]
					},
					["column"] = 1,
					["icon"] = 237586,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Natural Shapeshifter",
					["talentRankSpellIds"] = {
						16833, -- [1]
						16834, -- [2]
					},
					["column"] = 2,
					["icon"] = 136116,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Naturalist",
					["talentRankSpellIds"] = {
						17069, -- [1]
						17070, -- [2]
					},
					["column"] = 3,
					["icon"] = 136041,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Heart of the Wild",
					["talentRankSpellIds"] = {
						17003, -- [1]
						17004, -- [2]
						17005, -- [3]
					},
					["column"] = 4,
					["icon"] = 135879,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Perseverance",
					["talentRankSpellIds"] = {
						78734, -- [1]
						78735, -- [2]
						78736, -- [3]
					},
					["column"] = 1,
					["icon"] = 236740,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Master Shapeshifter",
					["talentRankSpellIds"] = {
						48411, -- [1]
					},
					["column"] = 2,
					["icon"] = 236161,
					["row"] = 2,
					["ranks"] = 1,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Improved Rejuvenation",
					["talentRankSpellIds"] = {
						17111, -- [1]
						17112, -- [2]
						17113, -- [3]
					},
					["column"] = 3,
					["icon"] = 136081,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Living Seed",
					["talentRankSpellIds"] = {
						48496, -- [1]
						48499, -- [2]
						48500, -- [3]
					},
					["column"] = 1,
					["icon"] = 236155,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Revitalize",
					["talentRankSpellIds"] = {
						48539, -- [1]
						48544, -- [2]
					},
					["column"] = 2,
					["icon"] = 236166,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Nature's Swiftness",
					["talentRankSpellIds"] = {
						17116, -- [1]
					},
					["column"] = 3,
					["icon"] = 136076,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Fury of Stormrage",
					["talentRankSpellIds"] = {
						17104, -- [1]
						24943, -- [2]
					},
					["column"] = 4,
					["icon"] = 237472,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Nature's Bounty",
					["talentRankSpellIds"] = {
						17074, -- [1]
						17075, -- [2]
						17076, -- [3]
					},
					["column"] = 2,
					["icon"] = 136085,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Empowered Touch",
					["talentRankSpellIds"] = {
						33879, -- [1]
						33880, -- [2]
					},
					["column"] = 3,
					["icon"] = 132125,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Malfurion's Gift",
					["talentRankSpellIds"] = {
						92363, -- [1]
						92364, -- [2]
					},
					["column"] = 4,
					["icon"] = 237578,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Efflorescence",
					["talentRankSpellIds"] = {
						34151, -- [1]
						81274, -- [2]
						81275, -- [3]
					},
					["column"] = 1,
					["icon"] = 134222,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Wild Growth",
					["talentRankSpellIds"] = {
						48438, -- [1]
					},
					["column"] = 2,
					["icon"] = 236153,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Nature's Cure",
					["talentRankSpellIds"] = {
						88423, -- [1]
					},
					["column"] = 3,
					["icon"] = 236288,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Nature's Ward",
					["talentRankSpellIds"] = {
						33881, -- [1]
						33882, -- [2]
					},
					["column"] = 4,
					["icon"] = 132137,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Gift of the Earthmother",
					["talentRankSpellIds"] = {
						51179, -- [1]
						51180, -- [2]
						51181, -- [3]
					},
					["column"] = 1,
					["icon"] = 236160,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Swift Rejuvenation",
					["talentRankSpellIds"] = {
						33886, -- [1]
					},
					["column"] = 3,
					["icon"] = 132124,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Tree of Life",
					["talentRankSpellIds"] = {
						33891, -- [1]
					},
					["column"] = 2,
					["icon"] = 132145,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "DruidRestoration",
			["name"] = "Restoration",
			["icon"] = 136041,
		},
	}, -- [3]
}

talents.hunter = {
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Improved Kill Command",
					["talentRankSpellIds"] = {
						35029, -- [1]
						35030, -- [2]
					},
					["column"] = 1,
					["icon"] = 132210,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "One with Nature",
					["talentRankSpellIds"] = {
						82682, -- [1]
						82683, -- [2]
						82684, -- [3]
					},
					["column"] = 2,
					["icon"] = 461117,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Bestial Discipline",
					["talentRankSpellIds"] = {
						19590, -- [1]
						19592, -- [2]
						82687, -- [3]
					},
					["column"] = 3,
					["icon"] = 461112,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Pathfinding",
					["talentRankSpellIds"] = {
						19559, -- [1]
						19560, -- [2]
					},
					["column"] = 1,
					["icon"] = 461118,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Spirit Bond",
					["talentRankSpellIds"] = {
						19578, -- [1]
						20895, -- [2]
					},
					["column"] = 2,
					["icon"] = 132121,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Frenzy",
					["talentRankSpellIds"] = {
						19621, -- [1]
						19622, -- [2]
						19623, -- [3]
					},
					["column"] = 3,
					["icon"] = 134296,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Improved Mend Pet",
					["talentRankSpellIds"] = {
						19572, -- [1]
						19573, -- [2]
					},
					["column"] = 4,
					["icon"] = 132179,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Cobra Strikes",
					["talentRankSpellIds"] = {
						53256, -- [1]
						53259, -- [2]
						53260, -- [3]
					},
					["column"] = 1,
					["icon"] = 236177,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Fervor",
					["talentRankSpellIds"] = {
						82726, -- [1]
					},
					["column"] = 2,
					["icon"] = 132160,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Focus Fire",
					["talentRankSpellIds"] = {
						82692, -- [1]
					},
					["column"] = 3,
					["icon"] = 461846,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Longevity",
					["talentRankSpellIds"] = {
						53262, -- [1]
						53263, -- [2]
						53264, -- [3]
					},
					["column"] = 1,
					["icon"] = 236186,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Killing Streak",
					["talentRankSpellIds"] = {
						82748, -- [1]
						82749, -- [2]
					},
					["column"] = 3,
					["icon"] = 236357,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Crouching Tiger, Hidden Chimera",
					["talentRankSpellIds"] = {
						82898, -- [1]
						82899, -- [2]
					},
					["column"] = 1,
					["icon"] = 236190,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Bestial Wrath",
					["talentRankSpellIds"] = {
						19574, -- [1]
					},
					["column"] = 2,
					["icon"] = 132127,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Ferocious Inspiration",
					["talentRankSpellIds"] = {
						34460, -- [1]
					},
					["column"] = 3,
					["icon"] = 132173,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Kindred Spirits",
					["talentRankSpellIds"] = {
						56314, -- [1]
						56315, -- [2]
					},
					["column"] = 1,
					["icon"] = 236202,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "The Beast Within",
					["talentRankSpellIds"] = {
						34692, -- [1]
					},
					["column"] = 2,
					["icon"] = 132166,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Invigoration",
					["talentRankSpellIds"] = {
						53252, -- [1]
						53253, -- [2]
					},
					["column"] = 3,
					["icon"] = 236184,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Beast Mastery",
					["talentRankSpellIds"] = {
						53270, -- [1]
					},
					["column"] = 2,
					["icon"] = 236175,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "HunterBeastMastery",
			["name"] = "Beast Mastery",
			["icon"] = 461112,
		},
	}, -- [1]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Go for the Throat",
					["talentRankSpellIds"] = {
						34950, -- [1]
						34954, -- [2]
					},
					["column"] = 1,
					["icon"] = 132174,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Efficiency",
					["talentRankSpellIds"] = {
						19416, -- [1]
						19417, -- [2]
						19418, -- [3]
					},
					["column"] = 2,
					["icon"] = 236179,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Rapid Killing",
					["talentRankSpellIds"] = {
						34948, -- [1]
						34949, -- [2]
					},
					["column"] = 3,
					["icon"] = 132205,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Sic 'Em!",
					["talentRankSpellIds"] = {
						83340, -- [1]
						83356, -- [2]
					},
					["column"] = 1,
					["icon"] = 461121,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Improved Steady Shot",
					["talentRankSpellIds"] = {
						53221, -- [1]
						53222, -- [2]
						53224, -- [3]
					},
					["column"] = 2,
					["icon"] = 236182,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Careful Aim",
					["talentRankSpellIds"] = {
						34482, -- [1]
						34483, -- [2]
					},
					["column"] = 3,
					["icon"] = 132217,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Silencing Shot",
					["talentRankSpellIds"] = {
						34490, -- [1]
					},
					["column"] = 1,
					["icon"] = 132323,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Concussive Barrage",
					["talentRankSpellIds"] = {
						35100, -- [1]
						35102, -- [2]
					},
					["column"] = 2,
					["icon"] = 461115,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Piercing Shots",
					["talentRankSpellIds"] = {
						53234, -- [1]
						53237, -- [2]
						53238, -- [3]
					},
					["column"] = 3,
					["icon"] = 236198,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Bombardment",
					["talentRankSpellIds"] = {
						35104, -- [1]
						35110, -- [2]
					},
					["column"] = 1,
					["icon"] = 132222,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Trueshot Aura",
					["talentRankSpellIds"] = {
						19506, -- [1]
					},
					["column"] = 2,
					["icon"] = 132329,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Termination",
					["talentRankSpellIds"] = {
						83489, -- [1]
						83490, -- [2]
					},
					["column"] = 3,
					["icon"] = 132345,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Resistance is Futile",
					["talentRankSpellIds"] = {
						82893, -- [1]
						82894, -- [2]
					},
					["column"] = 4,
					["icon"] = 461120,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Rapid Recuperation",
					["talentRankSpellIds"] = {
						53228, -- [1]
						53232, -- [2]
					},
					["column"] = 1,
					["icon"] = 236201,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Master Marksman",
					["talentRankSpellIds"] = {
						34485, -- [1]
						34486, -- [2]
						34487, -- [3]
					},
					["column"] = 2,
					["icon"] = 132177,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Readiness",
					["talentRankSpellIds"] = {
						23989, -- [1]
					},
					["column"] = 4,
					["icon"] = 132206,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Posthaste",
					["talentRankSpellIds"] = {
						83558, -- [1]
						83560, -- [2]
					},
					["column"] = 1,
					["icon"] = 461119,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Marked for Death",
					["talentRankSpellIds"] = {
						53241, -- [1]
						53243, -- [2]
					},
					["column"] = 3,
					["icon"] = 236173,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Chimera Shot",
					["talentRankSpellIds"] = {
						53209, -- [1]
					},
					["column"] = 2,
					["icon"] = 236176,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "HunterMarksmanship",
			["name"] = "Marksmanship",
			["icon"] = 236179,
		},
	}, -- [2]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Hunter vs. Wild",
					["talentRankSpellIds"] = {
						56339, -- [1]
						56340, -- [2]
						56341, -- [3]
					},
					["column"] = 1,
					["icon"] = 236180,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Pathing",
					["talentRankSpellIds"] = {
						52783, -- [1]
						52785, -- [2]
						52786, -- [3]
					},
					["column"] = 2,
					["icon"] = 236183,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Serpent Sting",
					["talentRankSpellIds"] = {
						19464, -- [1]
						82834, -- [2]
					},
					["column"] = 3,
					["icon"] = 132204,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Survival Tactics",
					["talentRankSpellIds"] = {
						19286, -- [1]
						19287, -- [2]
					},
					["column"] = 1,
					["icon"] = 132293,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Trap Mastery",
					["talentRankSpellIds"] = {
						19376, -- [1]
						63457, -- [2]
						63458, -- [3]
					},
					["column"] = 2,
					["icon"] = 132149,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Entrapment",
					["talentRankSpellIds"] = {
						19184, -- [1]
						19387, -- [2]
					},
					["column"] = 3,
					["icon"] = 136100,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Point of No Escape",
					["talentRankSpellIds"] = {
						53298, -- [1]
						53299, -- [2]
					},
					["column"] = 4,
					["icon"] = 236199,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Thrill of the Hunt",
					["talentRankSpellIds"] = {
						34497, -- [1]
						34498, -- [2]
						34499, -- [3]
					},
					["column"] = 1,
					["icon"] = 132216,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Counterattack",
					["talentRankSpellIds"] = {
						19306, -- [1]
					},
					["column"] = 2,
					["icon"] = 132336,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Lock and Load",
					["talentRankSpellIds"] = {
						56342, -- [1]
						56343, -- [2]
					},
					["column"] = 3,
					["icon"] = 236185,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Resourcefulness",
					["talentRankSpellIds"] = {
						34491, -- [1]
						34492, -- [2]
						34493, -- [3]
					},
					["column"] = 1,
					["icon"] = 132207,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Mirrored Blades",
					["talentRankSpellIds"] = {
						83494, -- [1]
						83495, -- [2]
					},
					["column"] = 2,
					["icon"] = 304583,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "T.N.T.",
					["talentRankSpellIds"] = {
						56333, -- [1]
						56336, -- [2]
					},
					["column"] = 3,
					["icon"] = 133713,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Toxicology",
					["talentRankSpellIds"] = {
						82832, -- [1]
						82833, -- [2]
					},
					["column"] = 1,
					["icon"] = 132378,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Wyvern Sting",
					["talentRankSpellIds"] = {
						19386, -- [1]
					},
					["column"] = 2,
					["icon"] = 135125,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Noxious Stings",
					["talentRankSpellIds"] = {
						53295, -- [1]
						53296, -- [2]
					},
					["column"] = 3,
					["icon"] = 236200,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Hunting Party",
					["talentRankSpellIds"] = {
						53290, -- [1]
					},
					["column"] = 4,
					["icon"] = 236181,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Sniper Training",
					["talentRankSpellIds"] = {
						53302, -- [1]
						53303, -- [2]
						53304, -- [3]
					},
					["column"] = 1,
					["icon"] = 236187,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Serpent Spread",
					["talentRankSpellIds"] = {
						87934, -- [1]
						87935, -- [2]
					},
					["column"] = 3,
					["icon"] = 132209,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Black Arrow",
					["talentRankSpellIds"] = {
						3674, -- [1]
					},
					["column"] = 2,
					["icon"] = 136181,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "HunterSurvival",
			["name"] = "Survival",
			["icon"] = 461113,
		},
	}, -- [3]
}

talents.mage = {
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Arcane Concentration",
					["talentRankSpellIds"] = {
						11213, -- [1]
						12574, -- [2]
						12575, -- [3]
					},
					["column"] = 1,
					["icon"] = 136170,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Improved Counterspell",
					["talentRankSpellIds"] = {
						11255, -- [1]
						12598, -- [2]
					},
					["column"] = 2,
					["icon"] = 135856,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Netherwind Presence",
					["talentRankSpellIds"] = {
						44400, -- [1]
						44402, -- [2]
						44403, -- [3]
					},
					["column"] = 3,
					["icon"] = 236222,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Torment the Weak",
					["talentRankSpellIds"] = {
						29447, -- [1]
						55339, -- [2]
						55340, -- [3]
					},
					["column"] = 1,
					["icon"] = 135737,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Invocation",
					["talentRankSpellIds"] = {
						84722, -- [1]
						84723, -- [2]
					},
					["column"] = 2,
					["icon"] = 429383,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Improved Arcane Missiles",
					["talentRankSpellIds"] = {
						83513, -- [1]
						83515, -- [2]
					},
					["column"] = 3,
					["icon"] = 136096,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Improved Blink",
					["talentRankSpellIds"] = {
						31569, -- [1]
						31570, -- [2]
					},
					["column"] = 4,
					["icon"] = 135736,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Arcane Flows",
					["talentRankSpellIds"] = {
						44378, -- [1]
						44379, -- [2]
					},
					["column"] = 1,
					["icon"] = 236223,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Presence of Mind",
					["talentRankSpellIds"] = {
						12043, -- [1]
					},
					["column"] = 2,
					["icon"] = 136031,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Missile Barrage",
					["talentRankSpellIds"] = {
						44404, -- [1]
						54486, -- [2]
					},
					["column"] = 3,
					["icon"] = 236221,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Prismatic Cloak",
					["talentRankSpellIds"] = {
						31574, -- [1]
						31575, -- [2]
						54354, -- [3]
					},
					["column"] = 4,
					["icon"] = 135752,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Improved Polymorph",
					["talentRankSpellIds"] = {
						11210, -- [1]
						12592, -- [2]
					},
					["column"] = 1,
					["icon"] = 136071,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Arcane Tactics",
					["talentRankSpellIds"] = {
						82930, -- [1]
					},
					["column"] = 2,
					["icon"] = 429382,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Incanter's Absorption",
					["talentRankSpellIds"] = {
						44394, -- [1]
						44395, -- [2]
					},
					["column"] = 3,
					["icon"] = 236219,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Improved Arcane Explosion",
					["talentRankSpellIds"] = {
						90787, -- [1]
						90788, -- [2]
					},
					["column"] = 4,
					["icon"] = 136116,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Arcane Potency",
					["talentRankSpellIds"] = {
						31571, -- [1]
						31572, -- [2]
					},
					["column"] = 1,
					["icon"] = 135732,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Slow",
					["talentRankSpellIds"] = {
						31589, -- [1]
					},
					["column"] = 2,
					["icon"] = 136091,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Nether Vortex",
					["talentRankSpellIds"] = {
						86181, -- [1]
						86209, -- [2]
					},
					["column"] = 3,
					["icon"] = 135735,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Focus Magic",
					["talentRankSpellIds"] = {
						54646, -- [1]
					},
					["column"] = 1,
					["icon"] = 135754,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Improved Mana Gem",
					["talentRankSpellIds"] = {
						31584, -- [1]
						31585, -- [2]
					},
					["column"] = 3,
					["icon"] = 134104,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Arcane Power",
					["talentRankSpellIds"] = {
						12042, -- [1]
					},
					["column"] = 2,
					["icon"] = 136048,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "MageArcane",
			["name"] = "Arcane",
			["icon"] = 135932,
		},
	}, -- [1]
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Master of Elements",
					["talentRankSpellIds"] = {
						29074, -- [1]
						29075, -- [2]
					},
					["column"] = 1,
					["icon"] = 135820,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Burning Soul",
					["talentRankSpellIds"] = {
						11083, -- [1]
						84253, -- [2]
						84254, -- [3]
					},
					["column"] = 2,
					["icon"] = 429590,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Fire Blast",
					["talentRankSpellIds"] = {
						11078, -- [1]
						11080, -- [2]
					},
					["column"] = 3,
					["icon"] = 135807,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Ignite",
					["talentRankSpellIds"] = {
						11119, -- [1]
						11120, -- [2]
						12846, -- [3]
					},
					["column"] = 1,
					["icon"] = 135818,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Fire Power",
					["talentRankSpellIds"] = {
						18459, -- [1]
						18460, -- [2]
						54734, -- [3]
					},
					["column"] = 2,
					["icon"] = 135817,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Blazing Speed",
					["talentRankSpellIds"] = {
						31641, -- [1]
						31642, -- [2]
					},
					["column"] = 3,
					["icon"] = 135788,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Impact",
					["talentRankSpellIds"] = {
						11103, -- [1]
						12357, -- [2]
					},
					["column"] = 4,
					["icon"] = 135821,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Cauterize",
					["talentRankSpellIds"] = {
						86948, -- [1]
						86949, -- [2]
					},
					["column"] = 1,
					["icon"] = 252268,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Blast Wave",
					["talentRankSpellIds"] = {
						11113, -- [1]
					},
					["column"] = 2,
					["icon"] = 135903,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Hot Streak",
					["talentRankSpellIds"] = {
						44445, -- [1]
					},
					["column"] = 3,
					["icon"] = 236218,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Improved Scorch",
					["talentRankSpellIds"] = {
						11115, -- [1]
						11367, -- [2]
					},
					["column"] = 4,
					["icon"] = 135827,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Molten Shields",
					["talentRankSpellIds"] = {
						11094, -- [1]
					},
					["column"] = 1,
					["icon"] = 135806,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Combustion",
					["talentRankSpellIds"] = {
						11129, -- [1]
					},
					["column"] = 2,
					["icon"] = 135824,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Improved Hot Streak",
					["talentRankSpellIds"] = {
						44446, -- [1]
						44448, -- [2]
					},
					["column"] = 3,
					["icon"] = 236218,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Firestarter",
					["talentRankSpellIds"] = {
						86914, -- [1]
					},
					["column"] = 4,
					["icon"] = 236216,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Improved Flamestrike",
					["talentRankSpellIds"] = {
						84673, -- [1]
						84674, -- [2]
					},
					["column"] = 1,
					["icon"] = 135826,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Dragon's Breath",
					["talentRankSpellIds"] = {
						31661, -- [1]
					},
					["column"] = 2,
					["icon"] = 134153,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Molten Fury",
					["talentRankSpellIds"] = {
						31679, -- [1]
						31680, -- [2]
						86880, -- [3]
					},
					["column"] = 3,
					["icon"] = 135822,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Pyromaniac",
					["talentRankSpellIds"] = {
						34293, -- [1]
						34295, -- [2]
					},
					["column"] = 1,
					["icon"] = 135789,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Critical Mass",
					["talentRankSpellIds"] = {
						11095, -- [1]
						12872, -- [2]
						12873, -- [3]
					},
					["column"] = 3,
					["icon"] = 136115,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Living Bomb",
					["talentRankSpellIds"] = {
						44457, -- [1]
					},
					["column"] = 2,
					["icon"] = 236220,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "MageFire",
			["name"] = "Fire",
			["icon"] = 135810,
		},
	}, -- [2]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Early Frost",
					["talentRankSpellIds"] = {
						83049, -- [1]
						83050, -- [2]
					},
					["column"] = 1,
					["icon"] = 135837,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Piercing Ice",
					["talentRankSpellIds"] = {
						11151, -- [1]
						12952, -- [2]
						12953, -- [3]
					},
					["column"] = 2,
					["icon"] = 135845,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Shatter",
					["talentRankSpellIds"] = {
						11170, -- [1]
						12982, -- [2]
					},
					["column"] = 3,
					["icon"] = 135849,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Ice Floes",
					["talentRankSpellIds"] = {
						31670, -- [1]
						31672, -- [2]
						55094, -- [3]
					},
					["column"] = 1,
					["icon"] = 135854,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Improved Cone of Cold",
					["talentRankSpellIds"] = {
						11190, -- [1]
						12489, -- [2]
					},
					["column"] = 2,
					["icon"] = 135852,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Piercing Chill",
					["talentRankSpellIds"] = {
						83156, -- [1]
						83157, -- [2]
					},
					["column"] = 3,
					["icon"] = 429386,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Permafrost",
					["talentRankSpellIds"] = {
						11175, -- [1]
						12569, -- [2]
						12571, -- [3]
					},
					["column"] = 4,
					["icon"] = 135864,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Ice Shards",
					["talentRankSpellIds"] = {
						11185, -- [1]
						12487, -- [2]
					},
					["column"] = 1,
					["icon"] = 429385,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Icy Veins",
					["talentRankSpellIds"] = {
						12472, -- [1]
					},
					["column"] = 2,
					["icon"] = 135838,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Fingers of Frost",
					["talentRankSpellIds"] = {
						44543, -- [1]
						44545, -- [2]
						83074, -- [3]
					},
					["column"] = 3,
					["icon"] = 236227,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Improved Freeze",
					["talentRankSpellIds"] = {
						86259, -- [1]
						86260, -- [2]
						86314, -- [3]
					},
					["column"] = 4,
					["icon"] = 135861,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Enduring Winter",
					["talentRankSpellIds"] = {
						44561, -- [1]
						86500, -- [2]
						86508, -- [3]
					},
					["column"] = 1,
					["icon"] = 135833,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Cold Snap",
					["talentRankSpellIds"] = {
						11958, -- [1]
					},
					["column"] = 2,
					["icon"] = 135865,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Brain Freeze",
					["talentRankSpellIds"] = {
						44546, -- [1]
						44548, -- [2]
						44549, -- [3]
					},
					["column"] = 3,
					["icon"] = 236206,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Shattered Barrier",
					["talentRankSpellIds"] = {
						44745, -- [1]
						54787, -- [2]
					},
					["column"] = 1,
					["icon"] = 236209,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Ice Barrier",
					["talentRankSpellIds"] = {
						11426, -- [1]
					},
					["column"] = 2,
					["icon"] = 135988,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Reactive Barrier",
					["talentRankSpellIds"] = {
						86303, -- [1]
						86304, -- [2]
					},
					["column"] = 3,
					["icon"] = 135859,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Frostfire Orb",
					["talentRankSpellIds"] = {
						84726, -- [1]
						84727, -- [2]
					},
					["column"] = 3,
					["icon"] = 430840,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Deep Freeze",
					["talentRankSpellIds"] = {
						44572, -- [1]
					},
					["column"] = 2,
					["icon"] = 236214,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "MageFrost",
			["name"] = "Frost",
			["icon"] = 135846,
		},
	}, -- [3]
}

talents.paladin = {
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Arbiter of the Light",
					["talentRankSpellIds"] = {
						20359, -- [1]
						20360, -- [2]
					},
					["column"] = 1,
					["icon"] = 135917,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Protector of the Innocent",
					["talentRankSpellIds"] = {
						20138, -- [1]
						20139, -- [2]
						20140, -- [3]
					},
					["column"] = 2,
					["icon"] = 460690,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Judgements of the Pure",
					["talentRankSpellIds"] = {
						53671, -- [1]
						53673, -- [2]
						54151, -- [3]
					},
					["column"] = 3,
					["icon"] = 236256,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Clarity of Purpose",
					["talentRankSpellIds"] = {
						85462, -- [1]
						85463, -- [2]
						85464, -- [3]
					},
					["column"] = 1,
					["icon"] = 461857,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Last Word",
					["talentRankSpellIds"] = {
						20234, -- [1]
						20235, -- [2]
					},
					["column"] = 2,
					["icon"] = 135921,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Blazing Light",
					["talentRankSpellIds"] = {
						20237, -- [1]
						20238, -- [2]
					},
					["column"] = 3,
					["icon"] = 135920,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Denounce",
					["talentRankSpellIds"] = {
						31825, -- [1]
						85510, -- [2]
					},
					["column"] = 1,
					["icon"] = 135903,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Divine Favor",
					["talentRankSpellIds"] = {
						31842, -- [1]
					},
					["column"] = 2,
					["icon"] = 135895,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Infusion of Light",
					["talentRankSpellIds"] = {
						53569, -- [1]
						53576, -- [2]
					},
					["column"] = 3,
					["icon"] = 236254,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Daybreak",
					["talentRankSpellIds"] = {
						88820, -- [1]
						88821, -- [2]
					},
					["column"] = 4,
					["icon"] = 134909,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Enlightened Judgements",
					["talentRankSpellIds"] = {
						53556, -- [1]
						53557, -- [2]
					},
					["column"] = 1,
					["icon"] = 236251,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Beacon of Light",
					["talentRankSpellIds"] = {
						53563, -- [1]
					},
					["column"] = 2,
					["icon"] = 236247,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Speed of Light",
					["talentRankSpellIds"] = {
						85495, -- [1]
						85498, -- [2]
						85499, -- [3]
					},
					["column"] = 3,
					["icon"] = 460953,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Sacred Cleansing",
					["talentRankSpellIds"] = {
						53551, -- [1]
					},
					["column"] = 4,
					["icon"] = 236261,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Conviction",
					["talentRankSpellIds"] = {
						20049, -- [1]
						20056, -- [2]
						20057, -- [3]
					},
					["column"] = 1,
					["icon"] = 460689,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Aura Mastery",
					["talentRankSpellIds"] = {
						31821, -- [1]
					},
					["column"] = 3,
					["icon"] = 135872,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Paragon of Virtue",
					["talentRankSpellIds"] = {
						93418, -- [1]
						93417, -- [2]
					},
					["column"] = 4,
					["icon"] = 135875,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Tower of Radiance",
					["talentRankSpellIds"] = {
						84800, -- [1]
						85511, -- [2]
						85512, -- [3]
					},
					["column"] = 2,
					["icon"] = 236394,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Blessed Life",
					["talentRankSpellIds"] = {
						31828, -- [1]
						31829, -- [2]
					},
					["column"] = 3,
					["icon"] = 135876,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Light of Dawn",
					["talentRankSpellIds"] = {
						85222, -- [1]
					},
					["column"] = 2,
					["icon"] = 461859,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "PALADINHOLY",
			["name"] = "Holy",
			["icon"] = 135920,
		},
	}, -- [1]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Divinity",
					["talentRankSpellIds"] = {
						63646, -- [1]
						63647, -- [2]
						63648, -- [3]
					},
					["column"] = 1,
					["icon"] = 135883,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Seals of the Pure",
					["talentRankSpellIds"] = {
						20224, -- [1]
						20225, -- [2]
					},
					["column"] = 2,
					["icon"] = 133526,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Eternal Glory",
					["talentRankSpellIds"] = {
						87163, -- [1]
						87164, -- [2]
					},
					["column"] = 3,
					["icon"] = 135433,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Judgements of the Just",
					["talentRankSpellIds"] = {
						53695, -- [1]
						53696, -- [2]
					},
					["column"] = 1,
					["icon"] = 236259,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Toughness",
					["talentRankSpellIds"] = {
						20143, -- [1]
						20144, -- [2]
						20145, -- [3]
					},
					["column"] = 2,
					["icon"] = 135892,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Improved Hammer of Justice",
					["talentRankSpellIds"] = {
						20487, -- [1]
						20488, -- [2]
					},
					["column"] = 3,
					["icon"] = 135963,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Hallowed Ground",
					["talentRankSpellIds"] = {
						84631, -- [1]
						84633, -- [2]
					},
					["column"] = 1,
					["icon"] = 135926,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Sanctuary",
					["talentRankSpellIds"] = {
						20911, -- [1]
						84628, -- [2]
						84629, -- [3]
					},
					["column"] = 2,
					["icon"] = 136051,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Hammer of the Righteous",
					["talentRankSpellIds"] = {
						53595, -- [1]
					},
					["column"] = 3,
					["icon"] = 236253,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Wrath of the Lightbringer",
					["talentRankSpellIds"] = {
						84635, -- [1]
						84636, -- [2]
					},
					["column"] = 4,
					["icon"] = 133562,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Reckoning",
					["talentRankSpellIds"] = {
						20177, -- [1]
						20179, -- [2]
					},
					["column"] = 1,
					["icon"] = 135882,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Shield of the Righteous",
					["talentRankSpellIds"] = {
						53600, -- [1]
					},
					["column"] = 2,
					["icon"] = 236265,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Grand Crusader",
					["talentRankSpellIds"] = {
						75806, -- [1]
						85043, -- [2]
					},
					["column"] = 3,
					["icon"] = 133176,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Vindication",
					["talentRankSpellIds"] = {
						26016, -- [1]
					},
					["column"] = 1,
					["icon"] = 135985,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Holy Shield",
					["talentRankSpellIds"] = {
						20925, -- [1]
					},
					["column"] = 2,
					["icon"] = 135880,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Guarded by the Light",
					["talentRankSpellIds"] = {
						85639, -- [1]
						85646, -- [2]
					},
					["column"] = 3,
					["icon"] = 236252,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Divine Guardian",
					["talentRankSpellIds"] = {
						70940, -- [1]
					},
					["column"] = 4,
					["icon"] = 253400,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Sacred Duty",
					["talentRankSpellIds"] = {
						53709, -- [1]
						53710, -- [2]
					},
					["column"] = 2,
					["icon"] = 135896,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Shield of the Templar",
					["talentRankSpellIds"] = {
						31848, -- [1]
						31849, -- [2]
						84854, -- [3]
					},
					["column"] = 3,
					["icon"] = 236264,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Ardent Defender",
					["talentRankSpellIds"] = {
						31850, -- [1]
					},
					["column"] = 2,
					["icon"] = 135870,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "PALADINPROTECTION",
			["name"] = "Protection",
			["icon"] = 236264,
		},
	}, -- [2]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Eye for an Eye",
					["talentRankSpellIds"] = {
						9799, -- [1]
						25988, -- [2]
					},
					["column"] = 1,
					["icon"] = 135904,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Crusade",
					["talentRankSpellIds"] = {
						31866, -- [1]
						31867, -- [2]
						31868, -- [3]
					},
					["column"] = 2,
					["icon"] = 135889,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Judgement",
					["talentRankSpellIds"] = {
						87174, -- [1]
						87175, -- [2]
					},
					["column"] = 3,
					["icon"] = 236255,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Guardian's Favor",
					["talentRankSpellIds"] = {
						20174, -- [1]
						20175, -- [2]
					},
					["column"] = 1,
					["icon"] = 135964,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Rule of Law",
					["talentRankSpellIds"] = {
						85457, -- [1]
						85458, -- [2]
						87461, -- [3]
					},
					["column"] = 2,
					["icon"] = 134916,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Pursuit of Justice",
					["talentRankSpellIds"] = {
						26022, -- [1]
						26023, -- [2]
					},
					["column"] = 4,
					["icon"] = 135937,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Communion",
					["talentRankSpellIds"] = {
						31876, -- [1]
					},
					["column"] = 1,
					["icon"] = 236257,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "The Art of War",
					["talentRankSpellIds"] = {
						53486, -- [1]
						53488, -- [2]
						87138, -- [3]
					},
					["column"] = 2,
					["icon"] = 236246,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Long Arm of the Law",
					["talentRankSpellIds"] = {
						87168, -- [1]
						87172, -- [2]
					},
					["column"] = 3,
					["icon"] = 236258,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Divine Storm",
					["talentRankSpellIds"] = {
						53385, -- [1]
					},
					["column"] = 4,
					["icon"] = 236250,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Sacred Shield",
					["talentRankSpellIds"] = {
						85285, -- [1]
					},
					["column"] = 1,
					["icon"] = 236249,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Sanctity of Battle",
					["talentRankSpellIds"] = {
						25956, -- [1]
					},
					["column"] = 2,
					["icon"] = 237486,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Seals of Command",
					["talentRankSpellIds"] = {
						85126, -- [1]
					},
					["column"] = 3,
					["icon"] = 132347,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Sanctified Wrath",
					["talentRankSpellIds"] = {
						53375, -- [1]
						90286, -- [2]
						53376, -- [3]
					},
					["column"] = 4,
					["icon"] = 236262,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Selfless Healer",
					["talentRankSpellIds"] = {
						85803, -- [1]
						85804, -- [2]
					},
					["column"] = 1,
					["icon"] = 252269,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Repentance",
					["talentRankSpellIds"] = {
						20066, -- [1]
					},
					["column"] = 2,
					["icon"] = 135942,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Divine Purpose",
					["talentRankSpellIds"] = {
						85117, -- [1]
						86172, -- [2]
					},
					["column"] = 3,
					["icon"] = 135897,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Inquiry of Faith",
					["talentRankSpellIds"] = {
						53380, -- [1]
						53381, -- [2]
						53382, -- [3]
					},
					["column"] = 2,
					["icon"] = 236260,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Acts of Sacrifice",
					["talentRankSpellIds"] = {
						85446, -- [1]
						85795, -- [2]
					},
					["column"] = 3,
					["icon"] = 236248,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Zealotry",
					["talentRankSpellIds"] = {
						85696, -- [1]
					},
					["column"] = 2,
					["icon"] = 237547,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "PALADINCOMBAT",
			["name"] = "Retribution",
			["icon"] = 135873,
		},
	}, -- [3]
}

talents.priest = {
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Improved Power Word: Shield",
					["talentRankSpellIds"] = {
						14748, -- [1]
						14768, -- [2]
					},
					["column"] = 1,
					["icon"] = 135940,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Twin Disciplines",
					["talentRankSpellIds"] = {
						47586, -- [1]
						47587, -- [2]
						47588, -- [3]
					},
					["column"] = 2,
					["icon"] = 135969,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Mental Agility",
					["talentRankSpellIds"] = {
						14520, -- [1]
						14780, -- [2]
						14781, -- [3]
					},
					["column"] = 3,
					["icon"] = 132156,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Evangelism",
					["talentRankSpellIds"] = {
						81659, -- [1]
						81662, -- [2]
					},
					["column"] = 1,
					["icon"] = 135895,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Archangel",
					["talentRankSpellIds"] = {
						87151, -- [1]
					},
					["column"] = 2,
					["icon"] = 458225,
					["row"] = 2,
					["ranks"] = 1,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Inner Sanctum",
					["talentRankSpellIds"] = {
						14747, -- [1]
						14770, -- [2]
						14771, -- [3]
					},
					["column"] = 3,
					["icon"] = 135926,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Soul Warding",
					["talentRankSpellIds"] = {
						63574, -- [1]
						78500, -- [2]
					},
					["column"] = 4,
					["icon"] = 458722,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Renewed Hope",
					["talentRankSpellIds"] = {
						57470, -- [1]
						57472, -- [2]
					},
					["column"] = 1,
					["icon"] = 135923,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Power Infusion",
					["talentRankSpellIds"] = {
						10060, -- [1]
					},
					["column"] = 2,
					["icon"] = 135939,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Atonement",
					["talentRankSpellIds"] = {
						14523, -- [1]
						81749, -- [2]
					},
					["column"] = 3,
					["icon"] = 458720,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Inner Focus",
					["talentRankSpellIds"] = {
						89485, -- [1]
					},
					["column"] = 4,
					["icon"] = 135863,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Rapture",
					["talentRankSpellIds"] = {
						47535, -- [1]
						47536, -- [2]
						47537, -- [3]
					},
					["column"] = 2,
					["icon"] = 237548,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Borrowed Time",
					["talentRankSpellIds"] = {
						52795, -- [1]
						52797, -- [2]
					},
					["column"] = 3,
					["icon"] = 237538,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Reflective Shield",
					["talentRankSpellIds"] = {
						33201, -- [1]
						33202, -- [2]
					},
					["column"] = 4,
					["icon"] = 458412,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Strength of Soul",
					["talentRankSpellIds"] = {
						89488, -- [1]
						89489, -- [2]
					},
					["column"] = 1,
					["icon"] = 135871,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Divine Aegis",
					["talentRankSpellIds"] = {
						47509, -- [1]
						47511, -- [2]
						47515, -- [3]
					},
					["column"] = 2,
					["icon"] = 237539,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Pain Suppression",
					["talentRankSpellIds"] = {
						33206, -- [1]
					},
					["column"] = 3,
					["icon"] = 135936,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Train of Thought",
					["talentRankSpellIds"] = {
						92295, -- [1]
						92297, -- [2]
					},
					["column"] = 4,
					["icon"] = 236225,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Focused Will",
					["talentRankSpellIds"] = {
						45234, -- [1]
						45243, -- [2]
					},
					["column"] = 1,
					["icon"] = 458227,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Grace",
					["talentRankSpellIds"] = {
						47516, -- [1]
						47517, -- [2]
					},
					["column"] = 3,
					["icon"] = 237543,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Power Word: Barrier",
					["talentRankSpellIds"] = {
						62618, -- [1]
					},
					["column"] = 2,
					["icon"] = 253400,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "PriestDiscipline",
			["name"] = "Discipline",
			["icon"] = 135940,
		},
	}, -- [1]
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Improved Renew",
					["talentRankSpellIds"] = {
						14908, -- [1]
						15020, -- [2]
					},
					["column"] = 1,
					["icon"] = 135953,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Empowered Healing",
					["talentRankSpellIds"] = {
						33158, -- [1]
						33159, -- [2]
						33160, -- [3]
					},
					["column"] = 2,
					["icon"] = 135913,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Divine Fury",
					["talentRankSpellIds"] = {
						18530, -- [1]
						18531, -- [2]
						18533, -- [3]
					},
					["column"] = 3,
					["icon"] = 135971,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Desperate Prayer",
					["talentRankSpellIds"] = {
						19236, -- [1]
					},
					["column"] = 2,
					["icon"] = 135954,
					["row"] = 2,
					["ranks"] = 1,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Surge of Light",
					["talentRankSpellIds"] = {
						88687, -- [1]
						88690, -- [2]
					},
					["column"] = 3,
					["icon"] = 135981,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Inspiration",
					["talentRankSpellIds"] = {
						14892, -- [1]
						15362, -- [2]
					},
					["column"] = 4,
					["icon"] = 135928,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Divine Touch",
					["talentRankSpellIds"] = {
						63534, -- [1]
						63542, -- [2]
					},
					["column"] = 1,
					["icon"] = 236254,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Holy Concentration",
					["talentRankSpellIds"] = {
						34753, -- [1]
						34859, -- [2]
					},
					["column"] = 2,
					["icon"] = 135905,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Lightwell",
					["talentRankSpellIds"] = {
						724, -- [1]
					},
					["column"] = 3,
					["icon"] = 135980,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Tome of Light",
					["talentRankSpellIds"] = {
						14898, -- [1]
						81625, -- [2]
					},
					["column"] = 4,
					["icon"] = 133739,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Rapid Renewal",
					["talentRankSpellIds"] = {
						95649, -- [1]
					},
					["column"] = 1,
					["icon"] = 236249,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Spirit of Redemption",
					["talentRankSpellIds"] = {
						20711, -- [1]
					},
					["column"] = 3,
					["icon"] = 132864,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Serendipity",
					["talentRankSpellIds"] = {
						63730, -- [1]
						63733, -- [2]
					},
					["column"] = 4,
					["icon"] = 237549,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Body and Soul",
					["talentRankSpellIds"] = {
						64127, -- [1]
						64129, -- [2]
					},
					["column"] = 1,
					["icon"] = 135982,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Chakra",
					["talentRankSpellIds"] = {
						14751, -- [1]
					},
					["column"] = 2,
					["icon"] = 521584,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Revelations",
					["talentRankSpellIds"] = {
						88627, -- [1]
					},
					["column"] = 3,
					["icon"] = 458721,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Blessed Resilience",
					["talentRankSpellIds"] = {
						33142, -- [1]
						33145, -- [2]
					},
					["column"] = 4,
					["icon"] = 135878,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Test of Faith",
					["talentRankSpellIds"] = {
						47558, -- [1]
						47559, -- [2]
						47560, -- [3]
					},
					["column"] = 1,
					["icon"] = 237550,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Heavenly Voice",
					["talentRankSpellIds"] = {
						87430, -- [1]
						87431, -- [2]
					},
					["column"] = 2,
					["icon"] = 458228,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Circle of Healing",
					["talentRankSpellIds"] = {
						34861, -- [1]
					},
					["column"] = 3,
					["icon"] = 135887,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Guardian Spirit",
					["talentRankSpellIds"] = {
						47788, -- [1]
					},
					["column"] = 2,
					["icon"] = 237542,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "PriestHoly",
			["name"] = "Holy",
			["icon"] = 237542,
		},
	}, -- [2]
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Darkness",
					["talentRankSpellIds"] = {
						15259, -- [1]
						15307, -- [2]
						15308, -- [3]
					},
					["column"] = 1,
					["icon"] = 458226,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Improved Shadow Word: Pain",
					["talentRankSpellIds"] = {
						15275, -- [1]
						15317, -- [2]
					},
					["column"] = 2,
					["icon"] = 136207,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Veiled Shadows",
					["talentRankSpellIds"] = {
						15274, -- [1]
						15311, -- [2]
					},
					["column"] = 3,
					["icon"] = 135994,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Improved Psychic Scream",
					["talentRankSpellIds"] = {
						15392, -- [1]
						15448, -- [2]
					},
					["column"] = 1,
					["icon"] = 136184,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Improved Mind Blast",
					["talentRankSpellIds"] = {
						15273, -- [1]
						15312, -- [2]
						15313, -- [3]
					},
					["column"] = 2,
					["icon"] = 136224,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Improved Devouring Plague",
					["talentRankSpellIds"] = {
						63625, -- [1]
						63626, -- [2]
					},
					["column"] = 3,
					["icon"] = 252996,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Twisted Faith",
					["talentRankSpellIds"] = {
						47573, -- [1]
						47577, -- [2]
					},
					["column"] = 4,
					["icon"] = 237566,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Shadowform",
					["talentRankSpellIds"] = {
						15473, -- [1]
					},
					["column"] = 2,
					["icon"] = 136200,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Phantasm",
					["talentRankSpellIds"] = {
						47569, -- [1]
						47570, -- [2]
					},
					["column"] = 3,
					["icon"] = 237570,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Harnessed Shadows",
					["talentRankSpellIds"] = {
						33191, -- [1]
						78228, -- [2]
					},
					["column"] = 4,
					["icon"] = 134336,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Silence",
					["talentRankSpellIds"] = {
						15487, -- [1]
					},
					["column"] = 1,
					["icon"] = 458230,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Vampiric Embrace",
					["talentRankSpellIds"] = {
						15286, -- [1]
					},
					["column"] = 2,
					["icon"] = 136230,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Masochism",
					["talentRankSpellIds"] = {
						88994, -- [1]
						88995, -- [2]
					},
					["column"] = 3,
					["icon"] = 136176,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Mind Melt",
					["talentRankSpellIds"] = {
						14910, -- [1]
						33371, -- [2]
					},
					["column"] = 4,
					["icon"] = 237569,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Pain and Suffering",
					["talentRankSpellIds"] = {
						47580, -- [1]
						47581, -- [2]
					},
					["column"] = 1,
					["icon"] = 237567,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Vampiric Touch",
					["talentRankSpellIds"] = {
						34914, -- [1]
					},
					["column"] = 2,
					["icon"] = 135978,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Paralysis",
					["talentRankSpellIds"] = {
						87192, -- [1]
						87195, -- [2]
					},
					["column"] = 3,
					["icon"] = 132299,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Psychic Horror",
					["talentRankSpellIds"] = {
						64044, -- [1]
					},
					["column"] = 1,
					["icon"] = 237568,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Sin and Punishment",
					["talentRankSpellIds"] = {
						87099, -- [1]
						87100, -- [2]
					},
					["column"] = 2,
					["icon"] = 135945,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Shadowy Apparition",
					["talentRankSpellIds"] = {
						78202, -- [1]
						78203, -- [2]
						78204, -- [3]
					},
					["column"] = 3,
					["icon"] = 458229,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Dispersion",
					["talentRankSpellIds"] = {
						47585, -- [1]
					},
					["column"] = 2,
					["icon"] = 237563,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "PriestShadow",
			["name"] = "Shadow",
			["icon"] = 136207,
		},
	}, -- [3]
}

talents.rogue = {
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Deadly Momentum",
					["talentRankSpellIds"] = {
						79121, -- [1]
						79122, -- [2]
					},
					["column"] = 1,
					["icon"] = 458727,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Coup de Grace",
					["talentRankSpellIds"] = {
						14162, -- [1]
						14163, -- [2]
						14164, -- [3]
					},
					["column"] = 2,
					["icon"] = 132292,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Lethality",
					["talentRankSpellIds"] = {
						14128, -- [1]
						14132, -- [2]
						14135, -- [3]
					},
					["column"] = 3,
					["icon"] = 132109,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Ruthlessness",
					["talentRankSpellIds"] = {
						14156, -- [1]
						14160, -- [2]
						14161, -- [3]
					},
					["column"] = 1,
					["icon"] = 132122,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Quickening",
					["talentRankSpellIds"] = {
						31208, -- [1]
						31209, -- [2]
					},
					["column"] = 2,
					["icon"] = 132301,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Puncturing Wounds",
					["talentRankSpellIds"] = {
						13733, -- [1]
						13865, -- [2]
						13866, -- [3]
					},
					["column"] = 3,
					["icon"] = 132090,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Blackjack",
					["talentRankSpellIds"] = {
						79123, -- [1]
						79125, -- [2]
					},
					["column"] = 4,
					["icon"] = 458797,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Deadly Brew",
					["talentRankSpellIds"] = {
						51625, -- [1]
						51626, -- [2]
					},
					["column"] = 1,
					["icon"] = 236270,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Cold Blood",
					["talentRankSpellIds"] = {
						14177, -- [1]
					},
					["column"] = 2,
					["icon"] = 135988,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Vile Poisons",
					["talentRankSpellIds"] = {
						16513, -- [1]
						16514, -- [2]
						16515, -- [3]
					},
					["column"] = 3,
					["icon"] = 132293,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Deadened Nerves",
					["talentRankSpellIds"] = {
						31380, -- [1]
						31382, -- [2]
						31383, -- [3]
					},
					["column"] = 1,
					["icon"] = 132286,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Seal Fate",
					["talentRankSpellIds"] = {
						14186, -- [1]
						14190, -- [2]
					},
					["column"] = 2,
					["icon"] = 236281,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Murderous Intent",
					["talentRankSpellIds"] = {
						14158, -- [1]
						14159, -- [2]
					},
					["column"] = 1,
					["icon"] = 136147,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Overkill",
					["talentRankSpellIds"] = {
						58426, -- [1]
					},
					["column"] = 2,
					["icon"] = 132205,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Master Poisoner",
					["talentRankSpellIds"] = {
						58410, -- [1]
					},
					["column"] = 3,
					["icon"] = 132108,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Improved Expose Armor",
					["talentRankSpellIds"] = {
						14168, -- [1]
						14169, -- [2]
					},
					["column"] = 4,
					["icon"] = 132354,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Cut to the Chase",
					["talentRankSpellIds"] = {
						51664, -- [1]
						51665, -- [2]
						51667, -- [3]
					},
					["column"] = 2,
					["icon"] = 236269,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Venomous Wounds",
					["talentRankSpellIds"] = {
						79133, -- [1]
						79134, -- [2]
					},
					["column"] = 3,
					["icon"] = 458736,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Vendetta",
					["talentRankSpellIds"] = {
						79140, -- [1]
					},
					["column"] = 2,
					["icon"] = 458726,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "RogueAssassination",
			["name"] = "Assassination",
			["icon"] = 132292,
		},
	}, -- [1]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Improved Recuperate",
					["talentRankSpellIds"] = {
						79007, -- [1]
						79008, -- [2]
					},
					["column"] = 1,
					["icon"] = 457635,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Improved Sinister Strike",
					["talentRankSpellIds"] = {
						13732, -- [1]
						13863, -- [2]
						79004, -- [3]
					},
					["column"] = 2,
					["icon"] = 136189,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Precision",
					["talentRankSpellIds"] = {
						13705, -- [1]
						13832, -- [2]
						13843, -- [3]
					},
					["column"] = 3,
					["icon"] = 132222,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Improved Slice and Dice",
					["talentRankSpellIds"] = {
						14165, -- [1]
						14166, -- [2]
					},
					["column"] = 1,
					["icon"] = 132306,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Improved Sprint",
					["talentRankSpellIds"] = {
						13743, -- [1]
						13875, -- [2]
					},
					["column"] = 2,
					["icon"] = 132307,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Aggression",
					["talentRankSpellIds"] = {
						18427, -- [1]
						18428, -- [2]
						18429, -- [3]
					},
					["column"] = 3,
					["icon"] = 132275,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Improved Kick",
					["talentRankSpellIds"] = {
						13754, -- [1]
						13867, -- [2]
					},
					["column"] = 4,
					["icon"] = 132219,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Lightning Reflexes",
					["talentRankSpellIds"] = {
						13712, -- [1]
						13788, -- [2]
						13789, -- [3]
					},
					["column"] = 1,
					["icon"] = 136047,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Revealing Strike",
					["talentRankSpellIds"] = {
						84617, -- [1]
					},
					["column"] = 2,
					["icon"] = 135407,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Reinforced Leather",
					["talentRankSpellIds"] = {
						79077, -- [1]
						79079, -- [2]
					},
					["column"] = 3,
					["icon"] = 458730,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Improved Gouge",
					["talentRankSpellIds"] = {
						13741, -- [1]
						13793, -- [2]
					},
					["column"] = 4,
					["icon"] = 132155,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Combat Potency",
					["talentRankSpellIds"] = {
						35541, -- [1]
						35550, -- [2]
						35551, -- [3]
					},
					["column"] = 2,
					["icon"] = 135673,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Blade Twisting",
					["talentRankSpellIds"] = {
						31124, -- [1]
						31126, -- [2]
					},
					["column"] = 3,
					["icon"] = 132283,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Throwing Specialization",
					["talentRankSpellIds"] = {
						5952, -- [1]
						51679, -- [2]
					},
					["column"] = 1,
					["icon"] = 236282,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Adrenaline Rush",
					["talentRankSpellIds"] = {
						13750, -- [1]
					},
					["column"] = 2,
					["icon"] = 136206,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Savage Combat",
					["talentRankSpellIds"] = {
						51682, -- [1]
						58413, -- [2]
					},
					["column"] = 3,
					["icon"] = 132100,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Bandit's Guile",
					["talentRankSpellIds"] = {
						84652, -- [1]
						84653, -- [2]
						84654, -- [3]
					},
					["column"] = 1,
					["icon"] = 236278,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Restless Blades",
					["talentRankSpellIds"] = {
						79095, -- [1]
						79096, -- [2]
					},
					["column"] = 3,
					["icon"] = 458731,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Killing Spree",
					["talentRankSpellIds"] = {
						51690, -- [1]
					},
					["column"] = 2,
					["icon"] = 236277,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "RogueCombat",
			["name"] = "Combat",
			["icon"] = 132090,
		},
	}, -- [2]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Nightstalker",
					["talentRankSpellIds"] = {
						13975, -- [1]
						14062, -- [2]
					},
					["column"] = 1,
					["icon"] = 132320,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Improved Ambush",
					["talentRankSpellIds"] = {
						14079, -- [1]
						14080, -- [2]
						84661, -- [3]
					},
					["column"] = 2,
					["icon"] = 132282,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Relentless Strikes",
					["talentRankSpellIds"] = {
						14179, -- [1]
						58422, -- [2]
						58423, -- [3]
					},
					["column"] = 3,
					["icon"] = 132340,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Elusiveness",
					["talentRankSpellIds"] = {
						13981, -- [1]
						14066, -- [2]
					},
					["column"] = 1,
					["icon"] = 135994,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Waylay",
					["talentRankSpellIds"] = {
						51692, -- [1]
						51696, -- [2]
					},
					["column"] = 2,
					["icon"] = 236286,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Opportunity",
					["talentRankSpellIds"] = {
						14057, -- [1]
						14072, -- [2]
						79141, -- [3]
					},
					["column"] = 3,
					["icon"] = 236268,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Initiative",
					["talentRankSpellIds"] = {
						13976, -- [1]
						13979, -- [2]
					},
					["column"] = 4,
					["icon"] = 136159,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Energetic Recovery",
					["talentRankSpellIds"] = {
						79150, -- [1]
						79151, -- [2]
						79152, -- [3]
					},
					["column"] = 1,
					["icon"] = 458734,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Find Weakness",
					["talentRankSpellIds"] = {
						51632, -- [1]
						91023, -- [2]
					},
					["column"] = 2,
					["icon"] = 132295,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Hemorrhage",
					["talentRankSpellIds"] = {
						16511, -- [1]
					},
					["column"] = 3,
					["icon"] = 136168,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Honor Among Thieves",
					["talentRankSpellIds"] = {
						51698, -- [1]
						51700, -- [2]
						51701, -- [3]
					},
					["column"] = 1,
					["icon"] = 236275,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Premeditation",
					["talentRankSpellIds"] = {
						14183, -- [1]
					},
					["column"] = 2,
					["icon"] = 136183,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Enveloping Shadows",
					["talentRankSpellIds"] = {
						31211, -- [1]
						31212, -- [2]
						31213, -- [3]
					},
					["column"] = 4,
					["icon"] = 132291,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Cheat Death",
					["talentRankSpellIds"] = {
						31228, -- [1]
						31229, -- [2]
						31230, -- [3]
					},
					["column"] = 1,
					["icon"] = 132285,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Preparation",
					["talentRankSpellIds"] = {
						14185, -- [1]
					},
					["column"] = 2,
					["icon"] = 460693,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Sanguinary Vein",
					["talentRankSpellIds"] = {
						79146, -- [1]
						79147, -- [2]
					},
					["column"] = 3,
					["icon"] = 457636,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Slaughter from the Shadows",
					["talentRankSpellIds"] = {
						51708, -- [1]
						51709, -- [2]
						51710, -- [3]
					},
					["column"] = 2,
					["icon"] = 236280,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Serrated Blades",
					["talentRankSpellIds"] = {
						14171, -- [1]
						14172, -- [2]
					},
					["column"] = 3,
					["icon"] = 135315,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Shadow Dance",
					["talentRankSpellIds"] = {
						51713, -- [1]
					},
					["column"] = 2,
					["icon"] = 236279,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "RogueSubtlety",
			["name"] = "Subtlety",
			["icon"] = 132320,
		},
	}, -- [3]
}

talents.shaman = {
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Acuity",
					["talentRankSpellIds"] = {
						17485, -- [1]
						17486, -- [2]
						17487, -- [3]
					},
					["column"] = 1,
					["icon"] = 136011,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Convection",
					["talentRankSpellIds"] = {
						16039, -- [1]
						16109, -- [2]
					},
					["column"] = 2,
					["icon"] = 459025,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Concussion",
					["talentRankSpellIds"] = {
						16035, -- [1]
						16105, -- [2]
						16106, -- [3]
					},
					["column"] = 3,
					["icon"] = 135807,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Call of Flame",
					["talentRankSpellIds"] = {
						16038, -- [1]
						16160, -- [2]
					},
					["column"] = 1,
					["icon"] = 135817,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Elemental Warding",
					["talentRankSpellIds"] = {
						28996, -- [1]
						28997, -- [2]
						28998, -- [3]
					},
					["column"] = 2,
					["icon"] = 136094,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Reverberation",
					["talentRankSpellIds"] = {
						16040, -- [1]
						16113, -- [2]
					},
					["column"] = 3,
					["icon"] = 135850,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Elemental Precision",
					["talentRankSpellIds"] = {
						30672, -- [1]
						30673, -- [2]
						30674, -- [3]
					},
					["column"] = 4,
					["icon"] = 136028,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Rolling Thunder",
					["talentRankSpellIds"] = {
						88756, -- [1]
						88764, -- [2]
					},
					["column"] = 1,
					["icon"] = 136014,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Elemental Focus",
					["talentRankSpellIds"] = {
						16164, -- [1]
					},
					["column"] = 2,
					["icon"] = 136170,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Elemental Reach",
					["talentRankSpellIds"] = {
						28999, -- [1]
						29000, -- [2]
					},
					["column"] = 3,
					["icon"] = 136099,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Elemental Oath",
					["talentRankSpellIds"] = {
						51466, -- [1]
						51470, -- [2]
					},
					["column"] = 2,
					["icon"] = 237576,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Lava Flows",
					["talentRankSpellIds"] = {
						51480, -- [1]
						51481, -- [2]
						51482, -- [3]
					},
					["column"] = 3,
					["icon"] = 237583,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Fulmination",
					["talentRankSpellIds"] = {
						88766, -- [1]
					},
					["column"] = 1,
					["icon"] = 136111,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Elemental Mastery",
					["talentRankSpellIds"] = {
						16166, -- [1]
					},
					["column"] = 2,
					["icon"] = 136115,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Earth's Grasp",
					["talentRankSpellIds"] = {
						51483, -- [1]
						51485, -- [2]
					},
					["column"] = 3,
					["icon"] = 136100,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Totemic Wrath",
					["talentRankSpellIds"] = {
						77746, -- [1]
					},
					["column"] = 4,
					["icon"] = 135829,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Feedback",
					["talentRankSpellIds"] = {
						86183, -- [1]
						86184, -- [2]
						86185, -- [3]
					},
					["column"] = 2,
					["icon"] = 252174,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Lava Surge",
					["talentRankSpellIds"] = {
						77755, -- [1]
						77756, -- [2]
					},
					["column"] = 3,
					["icon"] = 451169,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Earthquake",
					["talentRankSpellIds"] = {
						61882, -- [1]
					},
					["column"] = 2,
					["icon"] = 451165,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "ShamanElementalCombat",
			["name"] = "Elemental",
			["icon"] = 136048,
		},
	}, -- [1]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Elemental Weapons",
					["talentRankSpellIds"] = {
						16266, -- [1]
						29079, -- [2]
					},
					["column"] = 1,
					["icon"] = 135814,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Focused Strikes",
					["talentRankSpellIds"] = {
						77536, -- [1]
						77537, -- [2]
						77538, -- [3]
					},
					["column"] = 2,
					["icon"] = 451166,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Shields",
					["talentRankSpellIds"] = {
						16261, -- [1]
						16290, -- [2]
						51881, -- [3]
					},
					["column"] = 3,
					["icon"] = 136051,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Elemental Devastation",
					["talentRankSpellIds"] = {
						30160, -- [1]
						29179, -- [2]
						29180, -- [3]
					},
					["column"] = 1,
					["icon"] = 135791,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Flurry",
					["talentRankSpellIds"] = {
						16256, -- [1]
						16281, -- [2]
						16282, -- [3]
					},
					["column"] = 2,
					["icon"] = 132152,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Ancestral Swiftness",
					["talentRankSpellIds"] = {
						16262, -- [1]
						16287, -- [2]
					},
					["column"] = 3,
					["icon"] = 348567,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Totemic Reach",
					["talentRankSpellIds"] = {
						86935, -- [1]
						86936, -- [2]
					},
					["column"] = 4,
					["icon"] = 136008,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Toughness",
					["talentRankSpellIds"] = {
						16252, -- [1]
						16306, -- [2]
						16307, -- [3]
					},
					["column"] = 1,
					["icon"] = 135892,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Stormstrike",
					["talentRankSpellIds"] = {
						17364, -- [1]
					},
					["column"] = 2,
					["icon"] = 132314,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Static Shock",
					["talentRankSpellIds"] = {
						51525, -- [1]
						51526, -- [2]
						51527, -- [3]
					},
					["column"] = 3,
					["icon"] = 237587,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Frozen Power",
					["talentRankSpellIds"] = {
						63373, -- [1]
						63374, -- [2]
					},
					["column"] = 1,
					["icon"] = 135776,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Seasoned Winds",
					["talentRankSpellIds"] = {
						16086, -- [1]
						16544, -- [2]
					},
					["column"] = 2,
					["icon"] = 136027,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Searing Flames",
					["talentRankSpellIds"] = {
						77655, -- [1]
						77656, -- [2]
						77657, -- [3]
					},
					["column"] = 3,
					["icon"] = 135825,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Earthen Power",
					["talentRankSpellIds"] = {
						51523, -- [1]
						51524, -- [2]
					},
					["column"] = 1,
					["icon"] = 136024,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Shamanistic Rage",
					["talentRankSpellIds"] = {
						30823, -- [1]
					},
					["column"] = 2,
					["icon"] = 136088,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Unleashed Rage",
					["talentRankSpellIds"] = {
						30802, -- [1]
						30808, -- [2]
					},
					["column"] = 4,
					["icon"] = 136110,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Maelstrom Weapon",
					["talentRankSpellIds"] = {
						51528, -- [1]
						51529, -- [2]
						51530, -- [3]
					},
					["column"] = 2,
					["icon"] = 237584,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Improved Lava Lash",
					["talentRankSpellIds"] = {
						77700, -- [1]
						77701, -- [2]
					},
					["column"] = 3,
					["icon"] = 451168,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Feral Spirit",
					["talentRankSpellIds"] = {
						51533, -- [1]
					},
					["column"] = 2,
					["icon"] = 237577,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "ShamanEnhancement",
			["name"] = "Enhancement",
			["icon"] = 136051,
		},
	}, -- [2]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Ancestral Resolve",
					["talentRankSpellIds"] = {
						77829, -- [1]
						77830, -- [2]
					},
					["column"] = 1,
					["icon"] = 252271,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Tidal Focus",
					["talentRankSpellIds"] = {
						16179, -- [1]
						16214, -- [2]
						16215, -- [3]
					},
					["column"] = 2,
					["icon"] = 135859,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Spark of Life",
					["talentRankSpellIds"] = {
						84846, -- [1]
						84847, -- [2]
						84848, -- [3]
					},
					["column"] = 3,
					["icon"] = 237556,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Resurgence",
					["talentRankSpellIds"] = {
						16180, -- [1]
						16196, -- [2]
					},
					["column"] = 1,
					["icon"] = 132315,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Totemic Focus",
					["talentRankSpellIds"] = {
						16173, -- [1]
						16222, -- [2]
					},
					["column"] = 2,
					["icon"] = 136057,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Focused Insight",
					["talentRankSpellIds"] = {
						77794, -- [1]
						77795, -- [2]
						77796, -- [3]
					},
					["column"] = 3,
					["icon"] = 462651,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Nature's Guardian",
					["talentRankSpellIds"] = {
						30881, -- [1]
						30883, -- [2]
						30884, -- [3]
					},
					["column"] = 4,
					["icon"] = 136060,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Ancestral Healing",
					["talentRankSpellIds"] = {
						16176, -- [1]
						16235, -- [2]
					},
					["column"] = 1,
					["icon"] = 136109,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Nature's Swiftness",
					["talentRankSpellIds"] = {
						16188, -- [1]
					},
					["column"] = 2,
					["icon"] = 136076,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Nature's Blessing",
					["talentRankSpellIds"] = {
						30867, -- [1]
						30868, -- [2]
						30869, -- [3]
					},
					["column"] = 3,
					["icon"] = 136059,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Soothing Rains",
					["talentRankSpellIds"] = {
						16187, -- [1]
						16205, -- [2]
					},
					["column"] = 2,
					["icon"] = 136037,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Improved Cleanse Spirit",
					["talentRankSpellIds"] = {
						77130, -- [1]
					},
					["column"] = 3,
					["icon"] = 236288,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Cleansing Waters",
					["talentRankSpellIds"] = {
						86959, -- [1]
						86962, -- [2]
					},
					["column"] = 4,
					["icon"] = 136079,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Ancestral Awakening",
					["talentRankSpellIds"] = {
						51556, -- [1]
						51557, -- [2]
						51558, -- [3]
					},
					["column"] = 1,
					["icon"] = 237571,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Mana Tide Totem",
					["talentRankSpellIds"] = {
						16190, -- [1]
					},
					["column"] = 2,
					["icon"] = 135861,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Telluric Currents",
					["talentRankSpellIds"] = {
						82984, -- [1]
						82988, -- [2]
					},
					["column"] = 3,
					["icon"] = 135990,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Spirit Link Totem",
					["talentRankSpellIds"] = {
						98008, -- [1]
					},
					["column"] = 4,
					["icon"] = 237586,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Tidal Waves",
					["talentRankSpellIds"] = {
						51562, -- [1]
						51563, -- [2]
						51564, -- [3]
					},
					["column"] = 2,
					["icon"] = 237590,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Blessing of the Eternals",
					["talentRankSpellIds"] = {
						51554, -- [1]
						51555, -- [2]
					},
					["column"] = 3,
					["icon"] = 237573,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Riptide",
					["talentRankSpellIds"] = {
						61295, -- [1]
					},
					["column"] = 2,
					["icon"] = 252995,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "ShamanRestoration",
			["name"] = "Restoration",
			["icon"] = 136052,
		},
	}, -- [3]
}

talents.warlock = {
	{
		["numtalents"] = 18,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Doom and Gloom",
					["talentRankSpellIds"] = {
						18827, -- [1]
						18829, -- [2]
					},
					["column"] = 1,
					["icon"] = 136139,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Improved Life Tap",
					["talentRankSpellIds"] = {
						18182, -- [1]
						18183, -- [2]
					},
					["column"] = 2,
					["icon"] = 136126,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Corruption",
					["talentRankSpellIds"] = {
						17810, -- [1]
						17811, -- [2]
						17812, -- [3]
					},
					["column"] = 3,
					["icon"] = 136118,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Jinx",
					["talentRankSpellIds"] = {
						18179, -- [1]
						85479, -- [2]
					},
					["column"] = 1,
					["icon"] = 460699,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Soul Siphon",
					["talentRankSpellIds"] = {
						17804, -- [1]
						17805, -- [2]
					},
					["column"] = 2,
					["icon"] = 460700,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Siphon Life",
					["talentRankSpellIds"] = {
						63108, -- [1]
						86667, -- [2]
					},
					["column"] = 3,
					["icon"] = 136188,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Curse of Exhaustion",
					["talentRankSpellIds"] = {
						18223, -- [1]
					},
					["column"] = 1,
					["icon"] = 136162,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Improved Fear",
					["talentRankSpellIds"] = {
						53754, -- [1]
						53759, -- [2]
					},
					["column"] = 3,
					["icon"] = 136183,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Eradication",
					["talentRankSpellIds"] = {
						47195, -- [1]
						47196, -- [2]
						47197, -- [3]
					},
					["column"] = 4,
					["icon"] = 236295,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Improved Howl of Terror",
					["talentRankSpellIds"] = {
						30054, -- [1]
						30057, -- [2]
					},
					["column"] = 1,
					["icon"] = 136147,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Soul Swap",
					["talentRankSpellIds"] = {
						86121, -- [1]
					},
					["column"] = 2,
					["icon"] = 460857,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Shadow Embrace",
					["talentRankSpellIds"] = {
						32385, -- [1]
						32387, -- [2]
						32392, -- [3]
					},
					["column"] = 3,
					["icon"] = 136198,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Death's Embrace",
					["talentRankSpellIds"] = {
						47198, -- [1]
						47199, -- [2]
						47200, -- [3]
					},
					["column"] = 1,
					["icon"] = 237557,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Nightfall",
					["talentRankSpellIds"] = {
						18094, -- [1]
						18095, -- [2]
					},
					["column"] = 2,
					["icon"] = 136223,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Soulburn: Seed of Corruption",
					["talentRankSpellIds"] = {
						86664, -- [1]
					},
					["column"] = 3,
					["icon"] = 136193,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Everlasting Affliction",
					["talentRankSpellIds"] = {
						47201, -- [1]
						47202, -- [2]
						47203, -- [3]
					},
					["column"] = 2,
					["icon"] = 236296,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Pandemic",
					["talentRankSpellIds"] = {
						85099, -- [1]
						85100, -- [2]
					},
					["column"] = 3,
					["icon"] = 136166,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Haunt",
					["talentRankSpellIds"] = {
						48181, -- [1]
					},
					["column"] = 2,
					["icon"] = 236298,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [18]
		},
		["info"] = {
			["background"] = "WarlockCurses",
			["name"] = "Affliction",
			["icon"] = 136145,
		},
	}, -- [1]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Demonic Embrace",
					["talentRankSpellIds"] = {
						18697, -- [1]
						18698, -- [2]
						18699, -- [3]
					},
					["column"] = 1,
					["icon"] = 136172,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Dark Arts",
					["talentRankSpellIds"] = {
						18694, -- [1]
						85283, -- [2]
						85284, -- [3]
					},
					["column"] = 2,
					["icon"] = 460697,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Fel Synergy",
					["talentRankSpellIds"] = {
						47230, -- [1]
						47231, -- [2]
					},
					["column"] = 3,
					["icon"] = 237564,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Demonic Rebirth",
					["talentRankSpellIds"] = {
						88446, -- [1]
						88447, -- [2]
					},
					["column"] = 1,
					["icon"] = 136150,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Mana Feed",
					["talentRankSpellIds"] = {
						30326, -- [1]
						85175, -- [2]
					},
					["column"] = 2,
					["icon"] = 136171,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Demonic Aegis",
					["talentRankSpellIds"] = {
						30143, -- [1]
						30144, -- [2]
					},
					["column"] = 3,
					["icon"] = 136185,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Master Summoner",
					["talentRankSpellIds"] = {
						18709, -- [1]
						18710, -- [2]
					},
					["column"] = 4,
					["icon"] = 136164,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Impending Doom",
					["talentRankSpellIds"] = {
						85106, -- [1]
						85107, -- [2]
						85108, -- [3]
					},
					["column"] = 1,
					["icon"] = 136082,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Demonic Empowerment",
					["talentRankSpellIds"] = {
						47193, -- [1]
					},
					["column"] = 2,
					["icon"] = 236292,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Improved Health Funnel",
					["talentRankSpellIds"] = {
						18703, -- [1]
						18704, -- [2]
					},
					["column"] = 3,
					["icon"] = 136168,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Molten Core",
					["talentRankSpellIds"] = {
						47245, -- [1]
						47246, -- [2]
						47247, -- [3]
					},
					["column"] = 1,
					["icon"] = 236301,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Hand of Gul'dan",
					["talentRankSpellIds"] = {
						71521, -- [1]
					},
					["column"] = 2,
					["icon"] = 135265,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Aura of Foreboding",
					["talentRankSpellIds"] = {
						89604, -- [1]
						89605, -- [2]
					},
					["column"] = 3,
					["icon"] = 136192,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Ancient Grimoire",
					["talentRankSpellIds"] = {
						85109, -- [1]
						85110, -- [2]
					},
					["column"] = 1,
					["icon"] = 460694,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Inferno",
					["talentRankSpellIds"] = {
						85105, -- [1]
					},
					["column"] = 2,
					["icon"] = 460698,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Decimation",
					["talentRankSpellIds"] = {
						63156, -- [1]
						63158, -- [2]
					},
					["column"] = 3,
					["icon"] = 135808,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Cremation",
					["talentRankSpellIds"] = {
						85103, -- [1]
						85104, -- [2]
					},
					["column"] = 2,
					["icon"] = 460696,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Demonic Pact",
					["talentRankSpellIds"] = {
						47236, -- [1]
					},
					["column"] = 3,
					["icon"] = 237562,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Metamorphosis",
					["talentRankSpellIds"] = {
						59672, -- [1]
					},
					["column"] = 2,
					["icon"] = 237558,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "WarlockSummoning",
			["name"] = "Demonology",
			["icon"] = 136172,
		},
	}, -- [2]
	{
		["numtalents"] = 19,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Bane",
					["talentRankSpellIds"] = {
						17788, -- [1]
						17789, -- [2]
						17790, -- [3]
					},
					["column"] = 1,
					["icon"] = 136146,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Shadow and Flame",
					["talentRankSpellIds"] = {
						17793, -- [1]
						17796, -- [2]
						17801, -- [3]
					},
					["column"] = 2,
					["icon"] = 136196,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Improved Immolate",
					["talentRankSpellIds"] = {
						17815, -- [1]
						17833, -- [2]
					},
					["column"] = 3,
					["icon"] = 135817,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Aftermath",
					["talentRankSpellIds"] = {
						85113, -- [1]
						85114, -- [2]
					},
					["column"] = 1,
					["icon"] = 135805,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Emberstorm",
					["talentRankSpellIds"] = {
						17954, -- [1]
						17955, -- [2]
					},
					["column"] = 2,
					["icon"] = 135826,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Improved Searing Pain",
					["talentRankSpellIds"] = {
						17927, -- [1]
						17929, -- [2]
					},
					["column"] = 3,
					["icon"] = 135827,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Improved Soul Fire",
					["talentRankSpellIds"] = {
						18119, -- [1]
						18120, -- [2]
					},
					["column"] = 1,
					["icon"] = 135808,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Backdraft",
					["talentRankSpellIds"] = {
						47258, -- [1]
						47259, -- [2]
						47260, -- [3]
					},
					["column"] = 2,
					["icon"] = 236290,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Shadowburn",
					["talentRankSpellIds"] = {
						17877, -- [1]
					},
					["column"] = 3,
					["icon"] = 136191,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Burning Embers",
					["talentRankSpellIds"] = {
						91986, -- [1]
						85112, -- [2]
					},
					["column"] = 1,
					["icon"] = 460952,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Soul Leech",
					["talentRankSpellIds"] = {
						30293, -- [1]
						30295, -- [2]
					},
					["column"] = 2,
					["icon"] = 136214,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Backlash",
					["talentRankSpellIds"] = {
						34935, -- [1]
						34938, -- [2]
						34939, -- [3]
					},
					["column"] = 3,
					["icon"] = 135823,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Nether Ward",
					["talentRankSpellIds"] = {
						91713, -- [1]
					},
					["column"] = 4,
					["icon"] = 135796,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Fire and Brimstone",
					["talentRankSpellIds"] = {
						47266, -- [1]
						47267, -- [2]
						47268, -- [3]
					},
					["column"] = 2,
					["icon"] = 236297,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Shadowfury",
					["talentRankSpellIds"] = {
						30283, -- [1]
					},
					["column"] = 3,
					["icon"] = 136201,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Nether Protection",
					["talentRankSpellIds"] = {
						30299, -- [1]
						30301, -- [2]
					},
					["column"] = 4,
					["icon"] = 136178,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Empowered Imp",
					["talentRankSpellIds"] = {
						47220, -- [1]
						47221, -- [2]
					},
					["column"] = 1,
					["icon"] = 236294,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Bane of Havoc",
					["talentRankSpellIds"] = {
						80240, -- [1]
					},
					["column"] = 3,
					["icon"] = 460695,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Chaos Bolt",
					["talentRankSpellIds"] = {
						50796, -- [1]
					},
					["column"] = 2,
					["icon"] = 236291,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [19]
		},
		["info"] = {
			["background"] = "WarlockDestruction",
			["name"] = "Destruction",
			["icon"] = 136186,
		},
	}, -- [3]
}

talents.warrior = {
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "War Academy",
					["talentRankSpellIds"] = {
						84570, -- [1]
						84571, -- [2]
						84572, -- [3]
					},
					["column"] = 1,
					["icon"] = 236317,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Field Dressing",
					["talentRankSpellIds"] = {
						84579, -- [1]
						84580, -- [2]
					},
					["column"] = 2,
					["icon"] = 133675,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Blitz",
					["talentRankSpellIds"] = {
						80976, -- [1]
						80977, -- [2]
					},
					["column"] = 3,
					["icon"] = 458970,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Tactical Mastery",
					["talentRankSpellIds"] = {
						12295, -- [1]
						12676, -- [2]
					},
					["column"] = 1,
					["icon"] = 136031,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Second Wind",
					["talentRankSpellIds"] = {
						29834, -- [1]
						29838, -- [2]
					},
					["column"] = 2,
					["icon"] = 132175,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Deep Wounds",
					["talentRankSpellIds"] = {
						12834, -- [1]
						12849, -- [2]
						12867, -- [3]
					},
					["column"] = 3,
					["icon"] = 132090,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Drums of War",
					["talentRankSpellIds"] = {
						12290, -- [1]
						12963, -- [2]
					},
					["column"] = 4,
					["icon"] = 236397,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Taste for Blood",
					["talentRankSpellIds"] = {
						56636, -- [1]
						56637, -- [2]
						56638, -- [3]
					},
					["column"] = 1,
					["icon"] = 236276,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Sweeping Strikes",
					["talentRankSpellIds"] = {
						12328, -- [1]
					},
					["column"] = 2,
					["icon"] = 132306,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Impale",
					["talentRankSpellIds"] = {
						16493, -- [1]
						16494, -- [2]
					},
					["column"] = 3,
					["icon"] = 132312,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Improved Hamstring",
					["talentRankSpellIds"] = {
						12289, -- [1]
						12668, -- [2]
					},
					["column"] = 4,
					["icon"] = 132316,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Improved Slam",
					["talentRankSpellIds"] = {
						86655, -- [1]
						12330, -- [2]
					},
					["column"] = 1,
					["icon"] = 132340,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Deadly Calm",
					["talentRankSpellIds"] = {
						85730, -- [1]
					},
					["column"] = 2,
					["icon"] = 298660,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Blood Frenzy",
					["talentRankSpellIds"] = {
						29836, -- [1]
						29859, -- [2]
					},
					["column"] = 3,
					["icon"] = 132334,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Lambs to the Slaughter",
					["talentRankSpellIds"] = {
						84583, -- [1]
						84587, -- [2]
						84588, -- [3]
					},
					["column"] = 1,
					["icon"] = 458973,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Juggernaut",
					["talentRankSpellIds"] = {
						64976, -- [1]
					},
					["column"] = 2,
					["icon"] = 132335,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Sudden Death",
					["talentRankSpellIds"] = {
						29723, -- [1]
						29725, -- [2]
					},
					["column"] = 4,
					["icon"] = 132346,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Wrecking Crew",
					["talentRankSpellIds"] = {
						46867, -- [1]
						56611, -- [2]
					},
					["column"] = 1,
					["icon"] = 132364,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Throwdown",
					["talentRankSpellIds"] = {
						85388, -- [1]
					},
					["column"] = 3,
					["icon"] = 133542,
					["row"] = 6,
					["ranks"] = 1,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Bladestorm",
					["talentRankSpellIds"] = {
						46924, -- [1]
					},
					["column"] = 2,
					["icon"] = 236303,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "WarriorArms",
			["name"] = "Arms",
			["icon"] = 132355,
		},
	}, -- [1]
	{
		["numtalents"] = 21,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Blood Craze",
					["talentRankSpellIds"] = {
						16487, -- [1]
						16489, -- [2]
						16492, -- [3]
					},
					["column"] = 1,
					["icon"] = 136218,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Battle Trance",
					["talentRankSpellIds"] = {
						12322, -- [1]
						85741, -- [2]
						85742, -- [3]
					},
					["column"] = 2,
					["icon"] = 133074,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Cruelty",
					["talentRankSpellIds"] = {
						12320, -- [1]
						12852, -- [2]
					},
					["column"] = 3,
					["icon"] = 132292,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Executioner",
					["talentRankSpellIds"] = {
						20502, -- [1]
						20503, -- [2]
					},
					["column"] = 1,
					["icon"] = 135358,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Booming Voice",
					["talentRankSpellIds"] = {
						12321, -- [1]
						12835, -- [2]
					},
					["column"] = 2,
					["icon"] = 136075,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Rude Interruption",
					["talentRankSpellIds"] = {
						61216, -- [1]
						61221, -- [2]
					},
					["column"] = 3,
					["icon"] = 132339,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Piercing Howl",
					["talentRankSpellIds"] = {
						12323, -- [1]
					},
					["column"] = 4,
					["icon"] = 136147,
					["row"] = 2,
					["ranks"] = 1,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Flurry",
					["talentRankSpellIds"] = {
						12319, -- [1]
						12971, -- [2]
						12972, -- [3]
					},
					["column"] = 1,
					["icon"] = 132152,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Death Wish",
					["talentRankSpellIds"] = {
						12292, -- [1]
					},
					["column"] = 2,
					["icon"] = 136146,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Enrage",
					["talentRankSpellIds"] = {
						12317, -- [1]
						13045, -- [2]
						13046, -- [3]
					},
					["column"] = 3,
					["icon"] = 136224,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Die by the Sword",
					["talentRankSpellIds"] = {
						81913, -- [1]
						81914, -- [2]
					},
					["column"] = 1,
					["icon"] = 135396,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Raging Blow",
					["talentRankSpellIds"] = {
						85288, -- [1]
					},
					["column"] = 2,
					["icon"] = 132215,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Rampage",
					["talentRankSpellIds"] = {
						29801, -- [1]
					},
					["column"] = 3,
					["icon"] = 132352,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Heroic Fury",
					["talentRankSpellIds"] = {
						60970, -- [1]
					},
					["column"] = 4,
					["icon"] = 460958,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Furious Attacks",
					["talentRankSpellIds"] = {
						46910, -- [1]
					},
					["column"] = 1,
					["icon"] = 236308,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Meat Cleaver",
					["talentRankSpellIds"] = {
						12329, -- [1]
						12950, -- [2]
					},
					["column"] = 3,
					["icon"] = 460959,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Intensify Rage",
					["talentRankSpellIds"] = {
						46908, -- [1]
						46909, -- [2]
					},
					["column"] = 4,
					["icon"] = 458971,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Bloodsurge",
					["talentRankSpellIds"] = {
						46913, -- [1]
						46914, -- [2]
						46915, -- [3]
					},
					["column"] = 2,
					["icon"] = 236306,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Skirmisher",
					["talentRankSpellIds"] = {
						29888, -- [1]
						29889, -- [2]
					},
					["column"] = 3,
					["icon"] = 458975,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Titan's Grip",
					["talentRankSpellIds"] = {
						46917, -- [1]
					},
					["column"] = 2,
					["icon"] = 236316,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
			{
				["info"] = {
					["wowTreeIndex"] = 21,
					["name"] = "Single-Minded Fury",
					["talentRankSpellIds"] = {
						81099, -- [1]
					},
					["column"] = 3,
					["icon"] = 458974,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [21]
		},
		["info"] = {
			["background"] = "WarriorFury",
			["name"] = "Fury",
			["icon"] = 132347,
		},
	}, -- [2]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Incite",
					["talentRankSpellIds"] = {
						50685, -- [1]
						50686, -- [2]
						50687, -- [3]
					},
					["column"] = 1,
					["icon"] = 236309,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Toughness",
					["talentRankSpellIds"] = {
						12299, -- [1]
						12761, -- [2]
						12762, -- [3]
					},
					["column"] = 2,
					["icon"] = 135892,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Blood and Thunder",
					["talentRankSpellIds"] = {
						84614, -- [1]
						84615, -- [2]
					},
					["column"] = 3,
					["icon"] = 460957,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Shield Specialization",
					["talentRankSpellIds"] = {
						12298, -- [1]
						12724, -- [2]
						12725, -- [3]
					},
					["column"] = 1,
					["icon"] = 134952,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Shield Mastery",
					["talentRankSpellIds"] = {
						29598, -- [1]
						84607, -- [2]
						84608, -- [3]
					},
					["column"] = 2,
					["icon"] = 132359,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Hold the Line",
					["talentRankSpellIds"] = {
						84604, -- [1]
						84621, -- [2]
					},
					["column"] = 3,
					["icon"] = 236351,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Gag Order",
					["talentRankSpellIds"] = {
						12311, -- [1]
						12958, -- [2]
					},
					["column"] = 4,
					["icon"] = 132453,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Last Stand",
					["talentRankSpellIds"] = {
						12975, -- [1]
					},
					["column"] = 1,
					["icon"] = 135871,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Concussion Blow",
					["talentRankSpellIds"] = {
						12809, -- [1]
					},
					["column"] = 2,
					["icon"] = 132325,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Bastion of Defense",
					["talentRankSpellIds"] = {
						29593, -- [1]
						29594, -- [2]
					},
					["column"] = 3,
					["icon"] = 132110,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Warbringer",
					["talentRankSpellIds"] = {
						57499, -- [1]
					},
					["column"] = 4,
					["icon"] = 236319,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Improved Revenge",
					["talentRankSpellIds"] = {
						12797, -- [1]
						12799, -- [2]
					},
					["column"] = 1,
					["icon"] = 132353,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Devastate",
					["talentRankSpellIds"] = {
						20243, -- [1]
					},
					["column"] = 3,
					["icon"] = 135291,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Impending Victory",
					["talentRankSpellIds"] = {
						80128, -- [1]
						80129, -- [2]
					},
					["column"] = 4,
					["icon"] = 132342,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Thunderstruck",
					["talentRankSpellIds"] = {
						80979, -- [1]
						80980, -- [2]
					},
					["column"] = 1,
					["icon"] = 458976,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Vigilance",
					["talentRankSpellIds"] = {
						50720, -- [1]
					},
					["column"] = 2,
					["icon"] = 236318,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Heavy Repercussions",
					["talentRankSpellIds"] = {
						86894, -- [1]
						86896, -- [2]
					},
					["column"] = 4,
					["icon"] = 134947,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Safeguard",
					["talentRankSpellIds"] = {
						46945, -- [1]
						46949, -- [2]
					},
					["column"] = 2,
					["icon"] = 236311,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Sword and Board",
					["talentRankSpellIds"] = {
						46951, -- [1]
						46952, -- [2]
						46953, -- [3]
					},
					["column"] = 3,
					["icon"] = 236315,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Shockwave",
					["talentRankSpellIds"] = {
						46968, -- [1]
					},
					["column"] = 2,
					["icon"] = 236312,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "WarriorProtection",
			["name"] = "Protection",
			["icon"] = 132341,
		},
	}, -- [3]
}

talents.deathknight = {
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Butchery",
					["talentRankSpellIds"] = {
						48979, -- [1]
						49483, -- [2]
					},
					["column"] = 1,
					["icon"] = 132455,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Blade Barrier",
					["talentRankSpellIds"] = {
						49182, -- [1]
						49500, -- [2]
						49501, -- [3]
					},
					["column"] = 2,
					["icon"] = 132330,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Bladed Armor",
					["talentRankSpellIds"] = {
						48978, -- [1]
						49390, -- [2]
						49391, -- [3]
					},
					["column"] = 3,
					["icon"] = 135067,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Improved Blood Tap",
					["talentRankSpellIds"] = {
						94553, -- [1]
						94555, -- [2]
					},
					["column"] = 1,
					["icon"] = 237515,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Scent of Blood",
					["talentRankSpellIds"] = {
						49004, -- [1]
						49508, -- [2]
						49509, -- [3]
					},
					["column"] = 2,
					["icon"] = 132284,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Scarlet Fever",
					["talentRankSpellIds"] = {
						81131, -- [1]
						81132, -- [2]
					},
					["column"] = 3,
					["icon"] = 458735,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Hand of Doom",
					["talentRankSpellIds"] = {
						85793, -- [1]
						85794, -- [2]
					},
					["column"] = 4,
					["icon"] = 458966,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Blood-Caked Blade",
					["talentRankSpellIds"] = {
						49219, -- [1]
						49627, -- [2]
						49628, -- [3]
					},
					["column"] = 1,
					["icon"] = 132109,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Bone Shield",
					["talentRankSpellIds"] = {
						49222, -- [1]
					},
					["column"] = 2,
					["icon"] = 458717,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Toughness",
					["talentRankSpellIds"] = {
						49042, -- [1]
						49786, -- [2]
						49787, -- [3]
					},
					["column"] = 3,
					["icon"] = 135892,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Abomination's Might",
					["talentRankSpellIds"] = {
						53137, -- [1]
						53138, -- [2]
					},
					["column"] = 4,
					["icon"] = 236310,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Sanguine Fortitude",
					["talentRankSpellIds"] = {
						81125, -- [1]
						81127, -- [2]
					},
					["column"] = 1,
					["icon"] = 458719,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Blood Parasite",
					["talentRankSpellIds"] = {
						49027, -- [1]
						49542, -- [2]
					},
					["column"] = 2,
					["icon"] = 136211,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Improved Blood Presence",
					["talentRankSpellIds"] = {
						50365, -- [1]
						50371, -- [2]
					},
					["column"] = 3,
					["icon"] = 135770,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Will of the Necropolis",
					["talentRankSpellIds"] = {
						52284, -- [1]
						81163, -- [2]
						81164, -- [3]
					},
					["column"] = 1,
					["icon"] = 132094,
					["row"] = 5,
					["ranks"] = 3,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Rune Tap",
					["talentRankSpellIds"] = {
						48982, -- [1]
					},
					["column"] = 2,
					["icon"] = 237529,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Vampiric Blood",
					["talentRankSpellIds"] = {
						55233, -- [1]
					},
					["column"] = 3,
					["icon"] = 136168,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Improved Death Strike",
					["talentRankSpellIds"] = {
						62905, -- [1]
						62908, -- [2]
						81138, -- [3]
					},
					["column"] = 2,
					["icon"] = 237517,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Crimson Scourge",
					["talentRankSpellIds"] = {
						81135, -- [1]
						81136, -- [2]
					},
					["column"] = 3,
					["icon"] = 237513,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Dancing Rune Weapon",
					["talentRankSpellIds"] = {
						49028, -- [1]
					},
					["column"] = 2,
					["icon"] = 135277,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "DeathKnightBlood",
			["name"] = "Blood",
			["icon"] = 135770,
		},
	}, -- [1]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Runic Power Mastery",
					["talentRankSpellIds"] = {
						49455, -- [1]
						50147, -- [2]
						91145, -- [3]
					},
					["column"] = 1,
					["icon"] = 135728,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Icy Reach",
					["talentRankSpellIds"] = {
						55061, -- [1]
						55062, -- [2]
					},
					["column"] = 2,
					["icon"] = 135859,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Nerves of Cold Steel",
					["talentRankSpellIds"] = {
						49226, -- [1]
						50137, -- [2]
						50138, -- [3]
					},
					["column"] = 3,
					["icon"] = 132147,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Annihilation",
					["talentRankSpellIds"] = {
						51468, -- [1]
						51472, -- [2]
						51473, -- [3]
					},
					["column"] = 1,
					["icon"] = 135609,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Lichborne",
					["talentRankSpellIds"] = {
						49039, -- [1]
					},
					["column"] = 2,
					["icon"] = 136187,
					["row"] = 2,
					["ranks"] = 1,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "On a Pale Horse",
					["talentRankSpellIds"] = {
						51983, -- [1]
						51986, -- [2]
					},
					["column"] = 3,
					["icon"] = 132264,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Endless Winter",
					["talentRankSpellIds"] = {
						49137, -- [1]
						49657, -- [2]
					},
					["column"] = 4,
					["icon"] = 136223,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Merciless Combat",
					["talentRankSpellIds"] = {
						49024, -- [1]
						49538, -- [2]
					},
					["column"] = 1,
					["icon"] = 135294,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Chill of the Grave",
					["talentRankSpellIds"] = {
						49149, -- [1]
						50115, -- [2]
					},
					["column"] = 2,
					["icon"] = 135849,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Killing Machine",
					["talentRankSpellIds"] = {
						51123, -- [1]
						51127, -- [2]
						51128, -- [3]
					},
					["column"] = 3,
					["icon"] = 135305,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Rime",
					["talentRankSpellIds"] = {
						49188, -- [1]
						56822, -- [2]
						59057, -- [3]
					},
					["column"] = 1,
					["icon"] = 135840,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Pillar of Frost",
					["talentRankSpellIds"] = {
						51271, -- [1]
					},
					["column"] = 2,
					["icon"] = 458718,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Improved Icy Talons",
					["talentRankSpellIds"] = {
						55610, -- [1]
					},
					["column"] = 3,
					["icon"] = 252994,
					["row"] = 4,
					["ranks"] = 1,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Brittle Bones",
					["talentRankSpellIds"] = {
						81327, -- [1]
						81328, -- [2]
					},
					["column"] = 4,
					["icon"] = 460686,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Chilblains",
					["talentRankSpellIds"] = {
						50040, -- [1]
						50041, -- [2]
					},
					["column"] = 1,
					["icon"] = 135864,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Hungering Cold",
					["talentRankSpellIds"] = {
						49203, -- [1]
					},
					["column"] = 2,
					["icon"] = 135152,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Improved Frost Presence",
					["talentRankSpellIds"] = {
						50384, -- [1]
						50385, -- [2]
					},
					["column"] = 3,
					["icon"] = 135773,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Threat of Thassarian",
					["talentRankSpellIds"] = {
						65661, -- [1]
						66191, -- [2]
						66192, -- [3]
					},
					["column"] = 1,
					["icon"] = 132148,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Might of the Frozen Wastes",
					["talentRankSpellIds"] = {
						81330, -- [1]
						81332, -- [2]
						81333, -- [3]
					},
					["column"] = 3,
					["icon"] = 135303,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Howling Blast",
					["talentRankSpellIds"] = {
						49184, -- [1]
					},
					["column"] = 2,
					["icon"] = 135833,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "DeathKnightFrost",
			["name"] = "Frost",
			["icon"] = 135773,
		},
	}, -- [2]
	{
		["numtalents"] = 20,
		["talents"] = {
			{
				["info"] = {
					["wowTreeIndex"] = 1,
					["name"] = "Unholy Command",
					["talentRankSpellIds"] = {
						49588, -- [1]
						49589, -- [2]
					},
					["column"] = 1,
					["icon"] = 237532,
					["row"] = 1,
					["ranks"] = 2,
				},
			}, -- [1]
			{
				["info"] = {
					["wowTreeIndex"] = 2,
					["name"] = "Virulence",
					["talentRankSpellIds"] = {
						48962, -- [1]
						49567, -- [2]
						49568, -- [3]
					},
					["column"] = 2,
					["icon"] = 136126,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [2]
			{
				["info"] = {
					["wowTreeIndex"] = 3,
					["name"] = "Epidemic",
					["talentRankSpellIds"] = {
						49036, -- [1]
						49562, -- [2]
						81334, -- [3]
					},
					["column"] = 3,
					["icon"] = 136207,
					["row"] = 1,
					["ranks"] = 3,
				},
			}, -- [3]
			{
				["info"] = {
					["wowTreeIndex"] = 4,
					["name"] = "Desecration",
					["talentRankSpellIds"] = {
						55666, -- [1]
						55667, -- [2]
					},
					["column"] = 1,
					["icon"] = 136199,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [4]
			{
				["info"] = {
					["wowTreeIndex"] = 5,
					["name"] = "Resilient Infection",
					["talentRankSpellIds"] = {
						81338, -- [1]
						81339, -- [2]
					},
					["column"] = 2,
					["icon"] = 132102,
					["row"] = 2,
					["ranks"] = 2,
				},
			}, -- [5]
			{
				["info"] = {
					["wowTreeIndex"] = 6,
					["name"] = "Morbidity",
					["talentRankSpellIds"] = {
						48963, -- [1]
						49564, -- [2]
						49565, -- [3]
					},
					["column"] = 4,
					["icon"] = 136144,
					["row"] = 2,
					["ranks"] = 3,
				},
			}, -- [6]
			{
				["info"] = {
					["wowTreeIndex"] = 7,
					["name"] = "Runic Corruption",
					["talentRankSpellIds"] = {
						51459, -- [1]
						51462, -- [2]
					},
					["column"] = 1,
					["icon"] = 252272,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [7]
			{
				["info"] = {
					["wowTreeIndex"] = 8,
					["name"] = "Unholy Frenzy",
					["talentRankSpellIds"] = {
						49016, -- [1]
					},
					["column"] = 2,
					["icon"] = 136224,
					["row"] = 3,
					["ranks"] = 1,
				},
			}, -- [8]
			{
				["info"] = {
					["wowTreeIndex"] = 9,
					["name"] = "Contagion",
					["talentRankSpellIds"] = {
						91316, -- [1]
						91319, -- [2]
					},
					["column"] = 3,
					["icon"] = 136182,
					["row"] = 3,
					["ranks"] = 2,
				},
			}, -- [9]
			{
				["info"] = {
					["wowTreeIndex"] = 10,
					["name"] = "Shadow Infusion",
					["talentRankSpellIds"] = {
						48965, -- [1]
						49571, -- [2]
						49572, -- [3]
					},
					["column"] = 4,
					["icon"] = 136188,
					["row"] = 3,
					["ranks"] = 3,
				},
			}, -- [10]
			{
				["info"] = {
					["wowTreeIndex"] = 11,
					["name"] = "Death's Advance",
					["talentRankSpellIds"] = {
						96269, -- [1]
						96270, -- [2]
					},
					["column"] = 1,
					["icon"] = 237561,
					["row"] = 4,
					["ranks"] = 2,
				},
			}, -- [11]
			{
				["info"] = {
					["wowTreeIndex"] = 12,
					["name"] = "Magic Suppression",
					["talentRankSpellIds"] = {
						49224, -- [1]
						49610, -- [2]
						49611, -- [3]
					},
					["column"] = 2,
					["icon"] = 136120,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [12]
			{
				["info"] = {
					["wowTreeIndex"] = 13,
					["name"] = "Rage of Rivendare",
					["talentRankSpellIds"] = {
						51745, -- [1]
						51746, -- [2]
						91323, -- [3]
					},
					["column"] = 3,
					["icon"] = 135564,
					["row"] = 4,
					["ranks"] = 3,
				},
			}, -- [13]
			{
				["info"] = {
					["wowTreeIndex"] = 14,
					["name"] = "Unholy Blight",
					["talentRankSpellIds"] = {
						49194, -- [1]
					},
					["column"] = 1,
					["icon"] = 136132,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [14]
			{
				["info"] = {
					["wowTreeIndex"] = 15,
					["name"] = "Anti-Magic Zone",
					["talentRankSpellIds"] = {
						51052, -- [1]
					},
					["column"] = 2,
					["icon"] = 237510,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [15]
			{
				["info"] = {
					["wowTreeIndex"] = 16,
					["name"] = "Improved Unholy Presence",
					["talentRankSpellIds"] = {
						50391, -- [1]
						50392, -- [2]
					},
					["column"] = 3,
					["icon"] = 135775,
					["row"] = 5,
					["ranks"] = 2,
				},
			}, -- [16]
			{
				["info"] = {
					["wowTreeIndex"] = 17,
					["name"] = "Dark Transformation",
					["talentRankSpellIds"] = {
						63560, -- [1]
					},
					["column"] = 4,
					["icon"] = 342913,
					["row"] = 5,
					["ranks"] = 1,
				},
			}, -- [17]
			{
				["info"] = {
					["wowTreeIndex"] = 18,
					["name"] = "Ebon Plaguebringer",
					["talentRankSpellIds"] = {
						51099, -- [1]
						51160, -- [2]
					},
					["column"] = 2,
					["icon"] = 132095,
					["row"] = 6,
					["ranks"] = 2,
				},
			}, -- [18]
			{
				["info"] = {
					["wowTreeIndex"] = 19,
					["name"] = "Sudden Doom",
					["talentRankSpellIds"] = {
						49018, -- [1]
						49529, -- [2]
						49530, -- [3]
					},
					["column"] = 3,
					["icon"] = 136181,
					["row"] = 6,
					["ranks"] = 3,
				},
			}, -- [19]
			{
				["info"] = {
					["wowTreeIndex"] = 20,
					["name"] = "Summon Gargoyle",
					["talentRankSpellIds"] = {
						49206, -- [1]
					},
					["column"] = 2,
					["icon"] = 458967,
					["row"] = 7,
					["ranks"] = 1,
				},
			}, -- [20]
		},
		["info"] = {
			["background"] = "DeathKnightUnholy",
			["name"] = "Unholy",
			["icon"] = 135775,
		},
	}, -- [3]
}


function NRC:getTalentData(class)
	class = string.lower(class);
	return talents[class];
end

function NRC:getTabData(class)
	class = string.lower(class);
	if (talents[class]) then
		local tabData = {};
		for k, v in ipairs(talents[class]) do
			tabData[k] = {
				numTalents = v.numtalents;
			};
		end
		return tabData;
	end
end


---Talent data exporter addon I made when cata started.

--_, NTE = ...;
--local talentData = {};
--Created by Venomisto (Novaspark-Arugal)
--Exports the same data structure as earlier versions of the Talented addon.
--Modify the NTE:generateTalentData() func to suit your data structure needs.

--Preloaded with cata talents for all classes.

--If you want a diff expansion:
--Download Talent.csv from wago tools, run this lib https://github.com/geoffleyland/lua-csv.
--Paste the data table below.

--[[
local csv = require("lua-csv/lua/csv")
local f = csv.open("Talent.csv")
print("local data = {")
for row in f:lines() do
    local talentID = row[1];
    local tier1 = row[14];
    local tier2 = row[15];
    local tier3 = row[16];
    local tier4 = row[17];
    local tier5 = row[18];
    print("\t[" .. talentID .. "]={" .. tier1 .. "," .. tier2 .. "," .. tier3 .. "," .. tier4 .. "," .. tier5 .. "},");
end
print("};")
]]

--Cata data.
--[talentID] = {tier1,tier2,tier3,tier4,tier5}
--[[local data = {
	
};

local function updateSavedVariables()
	local count, spellIDs = 0, 0;
	for tab, tabData in pairs(talentData) do
		if (tabData.talents) then
			for k, v in pairs(tabData.talents) do
				count = count + 1;
				if (v.info.talentRankSpellIds) then
					spellIDs = spellIDs + 1;
				end
			end
		end
	end
	NTEdatabase = talentData;
	print("Talent DB exported - Talents recorded with SpellID entries:", spellIDs .. "/" .. count);
end

function NTE:generateTalentData()
	talentData = {};
	for tab = 1, GetNumTalentTabs() do
		talentData[tab] = {};
		talentData[tab].talents = {};
		local count = 0;
		for index = 1, GetNumTalents(tab) do
			local name, icon, row, column, rank, maxRank, isExceptional, available, previewRank, previewAvailable, _,  talentID  = GetTalentInfo(tab, index);
			if (name) then
				talentData[tab].talents[index] = {};
				talentData[tab].talents[index].info = {
					row = row,
					icon = icon,
					ranks = maxRank,
					wowTreeIndex = index,
					column = column,
					name = name,
				};
				if (data[talentID]) then
					local t = {};
					for k, v in pairs(data[talentID]) do
						--Remove 0 entries.
						if (v ~= 0) then
							tinsert(t, v);
						end
					end
					talentData[tab].talents[index].info.talentRankSpellIds = t;
				end
			end
			count = count + 1;
		end
		talentData[tab].numtalents = count;
		local _, name, _, icon, _, background = GetTalentTabInfo(tab);
		talentData[tab].info = {
			background = background,
			name = name,
			icon = icon,
		}
	end
	updateSavedVariables();
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:SetScript("OnEvent", function(self, event, ...)
	NTE:generateTalentData();
	f:UnregisterEvent("PLAYER_ENTERING_WORLD");
end)]]