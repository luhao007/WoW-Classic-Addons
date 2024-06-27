----------------------------------
---NovaRaidCompanion Talent Data--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isWrath) then
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
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 136006,
				ranks = 5,
				wowTreeIndex = 1,
				column = 2,
				name = "Starlight Wrath",
				talentRankSpellIds = { 16814, 16815, 16816, 16817, 16818 }
			}
		}, {
			info = {
				row = 1,
				icon = 135730,
				ranks = 5,
				wowTreeIndex = 26,
				column = 3,
				name = "Genesis",
				talentRankSpellIds = { 57810, 57811, 57812, 57813, 57814 }
			}
		}, {
			info = {
				row = 2,
				icon = 136087,
				ranks = 3,
				wowTreeIndex = 5,
				column = 1,
				name = "Moonglow",
				talentRankSpellIds = { 16845, 16846, 16847 }
			}
		}, {
			info = {
				row = 2,
				icon = 135138,
				ranks = 2,
				wowTreeIndex = 18,
				column = 2,
				name = "Nature's Majesty",
				talentRankSpellIds = { 35363, 35364 }
			}
		}, {
			info = {
				row = 2,
				icon = 136096,
				ranks = 2,
				wowTreeIndex = 2,
				column = 4,
				name = "Improved Moonfire",
				talentRankSpellIds = { 16821, 16822 }
			}
		}, {
			info = {
				row = 3,
				icon = 136104,
				ranks = 3,
				wowTreeIndex = 4,
				column = 1,
				name = "Brambles",
				talentRankSpellIds = { 16836, 16839, 16840 }
			}
		}, {
			info = {
				row = 3,
				icon = 136062,
				ranks = 3,
				wowTreeIndex = 8,
				column = 2,
				name = "Nature's Grace",
				talentRankSpellIds = { 16880, 61345, 61346 },
				prereqs = { {
					column = 2,
					row = 2,
					source = 4
				} }
			}
		}, {
			info = {
				row = 3,
				icon = 136060,
				ranks = 1,
				wowTreeIndex = 28,
				column = 3,
				name = "Nature's Splendor",
				talentRankSpellIds = { 57865 },
				prereqs = { {
					column = 2,
					row = 2,
					source = 4
				} }
			}
		}, {
			info = {
				row = 3,
				icon = 136065,
				ranks = 2,
				wowTreeIndex = 3,
				column = 4,
				name = "Nature's Reach",
				talentRankSpellIds = { 16819, 16820 }
			}
		}, {
			info = {
				row = 4,
				icon = 136075,
				ranks = 5,
				wowTreeIndex = 10,
				column = 2,
				name = "Vengeance",
				talentRankSpellIds = { 16909, 16910, 16911, 16912, 16913 }
			}
		}, {
			info = {
				row = 4,
				icon = 135753,
				ranks = 3,
				wowTreeIndex = 6,
				column = 3,
				name = "Celestial Focus",
				talentRankSpellIds = { 16850, 16923, 16924 }
			}
		}, {
			info = {
				row = 5,
				icon = 132132,
				ranks = 3,
				wowTreeIndex = 12,
				column = 1,
				name = "Lunar Guidance",
				talentRankSpellIds = { 33589, 33590, 33591 }
			}
		}, {
			info = {
				row = 5,
				icon = 136045,
				ranks = 1,
				wowTreeIndex = 7,
				column = 2,
				name = "Insect Swarm",
				talentRankSpellIds = { 5570 }
			}
		}, {
			info = {
				row = 5,
				icon = 136045,
				ranks = 3,
				wowTreeIndex = 27,
				column = 3,
				name = "Improved Insect Swarm",
				talentRankSpellIds = { 57849, 57850, 57851 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 132123,
				ranks = 3,
				wowTreeIndex = 14,
				column = 1,
				name = "Dreamstate",
				talentRankSpellIds = { 33597, 33599, 33956 }
			}
		}, {
			info = {
				row = 6,
				icon = 136057,
				ranks = 3,
				wowTreeIndex = 9,
				column = 2,
				name = "Moonfury",
				talentRankSpellIds = { 16896, 16897, 16899 }
			}
		}, {
			info = {
				row = 6,
				icon = 132113,
				ranks = 2,
				wowTreeIndex = 13,
				column = 3,
				name = "Balance of Power",
				talentRankSpellIds = { 33592, 33596 }
			}
		}, {
			info = {
				row = 7,
				icon = 136036,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Moonkin Form",
				talentRankSpellIds = { 24858 }
			}
		}, {
			info = {
				row = 7,
				icon = 236156,
				ranks = 3,
				wowTreeIndex = 19,
				column = 3,
				name = "Improved Moonkin Form",
				talentRankSpellIds = { 48384, 48395, 48396 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136033,
				ranks = 3,
				wowTreeIndex = 15,
				column = 4,
				name = "Improved Faerie Fire",
				talentRankSpellIds = { 33600, 33601, 33602 }
			}
		}, {
			info = {
				row = 8,
				icon = 236163,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Owlkin Frenzy",
				talentRankSpellIds = { 48389, 48392, 48393 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 132146,
				ranks = 5,
				wowTreeIndex = 16,
				column = 3,
				name = "Wrath of Cenarius",
				talentRankSpellIds = { 33603, 33604, 33605, 33606, 33607 }
			}
		}, {
			info = {
				row = 9,
				icon = 236151,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Eclipse",
				talentRankSpellIds = { 48516, 48521, 48525 }
			}
		}, {
			info = {
				row = 9,
				icon = 236170,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Typhoon",
				talentRankSpellIds = { 50516 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 132129,
				ranks = 1,
				wowTreeIndex = 17,
				column = 3,
				name = "Force of Nature",
				talentRankSpellIds = { 33831 }
			}
		}, {
			info = {
				row = 9,
				icon = 236154,
				ranks = 2,
				wowTreeIndex = 23,
				column = 4,
				name = "Gale Winds",
				talentRankSpellIds = { 48488, 48514 }
			}
		}, {
			info = {
				row = 10,
				icon = 236150,
				ranks = 3,
				wowTreeIndex = 25,
				column = 2,
				name = "Earth and Moon",
				talentRankSpellIds = { 48506, 48510, 48511 }
			}
		}, {
			info = {
				row = 11,
				icon = 236168,
				ranks = 1,
				wowTreeIndex = 24,
				column = 2,
				name = "Starfall",
				talentRankSpellIds = { 48505 }
			}
		} },
		info = {
			background = "DruidBalance",
			name = "Balance",
			icon = 136096
		}
	}, -- [1]
	{
		numtalents = 30,
		talents = { {
			info = {
				row = 1,
				icon = 132190,
				ranks = 5,
				wowTreeIndex = 3,
				column = 2,
				name = "Ferocity",
				talentRankSpellIds = { 16934, 16935, 16936, 16937, 16938 }
			}
		}, {
			info = {
				row = 1,
				icon = 132121,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Feral Aggression",
				talentRankSpellIds = { 16858, 16859, 16860, 16861, 16862 }
			}
		}, {
			info = {
				row = 2,
				icon = 132089,
				ranks = 3,
				wowTreeIndex = 6,
				column = 1,
				name = "Feral Instinct",
				talentRankSpellIds = { 16947, 16948, 16949 }
			}
		}, {
			info = {
				row = 2,
				icon = 132141,
				ranks = 2,
				wowTreeIndex = 11,
				column = 2,
				name = "Savage Fury",
				talentRankSpellIds = { 16998, 16999 }
			}
		}, {
			info = {
				row = 2,
				icon = 134355,
				ranks = 3,
				wowTreeIndex = 1,
				column = 3,
				name = "Thick Hide",
				talentRankSpellIds = { 16929, 16930, 16931 }
			}
		}, {
			info = {
				row = 3,
				icon = 136095,
				ranks = 2,
				wowTreeIndex = 12,
				column = 1,
				name = "Feral Swiftness",
				talentRankSpellIds = { 17002, 24866 }
			}
		}, {
			info = {
				row = 3,
				icon = 236169,
				ranks = 1,
				wowTreeIndex = 15,
				column = 2,
				name = "Survival Instincts",
				talentRankSpellIds = { 61336 }
			}
		}, {
			info = {
				row = 3,
				icon = 134297,
				ranks = 3,
				wowTreeIndex = 5,
				column = 3,
				name = "Sharpened Claws",
				talentRankSpellIds = { 16942, 16943, 16944 }
			}
		}, {
			info = {
				row = 4,
				icon = 136231,
				ranks = 2,
				wowTreeIndex = 8,
				column = 1,
				name = "Shredding Attacks",
				talentRankSpellIds = { 16966, 16968 }
			}
		}, {
			info = {
				row = 4,
				icon = 132185,
				ranks = 3,
				wowTreeIndex = 9,
				column = 2,
				name = "Predatory Strikes",
				talentRankSpellIds = { 16972, 16974, 16975 }
			}
		}, {
			info = {
				row = 4,
				icon = 132278,
				ranks = 2,
				wowTreeIndex = 7,
				column = 3,
				name = "Primal Fury",
				talentRankSpellIds = { 37116, 37117 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 8
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 236165,
				ranks = 2,
				wowTreeIndex = 22,
				column = 4,
				name = "Primal Precision",
				talentRankSpellIds = { 48409, 48410 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 8
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 132114,
				ranks = 2,
				wowTreeIndex = 4,
				column = 1,
				name = "Brutal Impact",
				talentRankSpellIds = { 16940, 16941 }
			}
		}, {
			info = {
				row = 5,
				icon = 132183,
				ranks = 1,
				wowTreeIndex = 10,
				column = 3,
				name = "Feral Charge",
				talentRankSpellIds = { 49377 }
			}
		}, {
			info = {
				row = 5,
				icon = 132130,
				ranks = 2,
				wowTreeIndex = 16,
				column = 4,
				name = "Nurturing Instinct",
				talentRankSpellIds = { 33872, 33873 }
			}
		}, {
			info = {
				row = 6,
				icon = 132091,
				ranks = 3,
				wowTreeIndex = 29,
				column = 1,
				name = "Natural Reaction",
				talentRankSpellIds = { 57878, 57880, 57881 }
			}
		}, {
			info = {
				row = 6,
				icon = 135879,
				ranks = 5,
				wowTreeIndex = 13,
				column = 2,
				name = "Heart of the Wild",
				talentRankSpellIds = { 17003, 17004, 17005, 17006, 24894 },
				prereqs = { {
					column = 2,
					row = 4,
					source = 10
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 132126,
				ranks = 3,
				wowTreeIndex = 18,
				column = 3,
				name = "Survival of the Fittest",
				talentRankSpellIds = { 33853, 33855, 33856 }
			}
		}, {
			info = {
				row = 7,
				icon = 136112,
				ranks = 1,
				wowTreeIndex = 14,
				column = 2,
				name = "Leader of the Pack",
				talentRankSpellIds = { 17007 }
			}
		}, {
			info = {
				row = 7,
				icon = 136112,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Improved Leader of the Pack",
				talentRankSpellIds = { 34297, 34300 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132139,
				ranks = 3,
				wowTreeIndex = 17,
				column = 4,
				name = "Primal Tenacity",
				talentRankSpellIds = { 33851, 33852, 33957 }
			}
		}, {
			info = {
				row = 8,
				icon = 132117,
				ranks = 3,
				wowTreeIndex = 28,
				column = 1,
				name = "Protector of the Pack",
				talentRankSpellIds = { 57873, 57876, 57877 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 132138,
				ranks = 3,
				wowTreeIndex = 19,
				column = 3,
				name = "Predatory Instincts",
				talentRankSpellIds = { 33859, 33866, 33867 }
			}
		}, {
			info = {
				row = 8,
				icon = 236158,
				ranks = 3,
				wowTreeIndex = 24,
				column = 4,
				name = "Infected Wounds",
				talentRankSpellIds = { 48483, 48484, 48485 }
			}
		}, {
			info = {
				row = 9,
				icon = 236159,
				ranks = 3,
				wowTreeIndex = 26,
				column = 1,
				name = "King of the Jungle",
				talentRankSpellIds = { 48492, 48494, 48495 }
			}
		}, {
			info = {
				row = 9,
				icon = 132135,
				ranks = 1,
				wowTreeIndex = 20,
				column = 2,
				name = "Mangle",
				talentRankSpellIds = { 33917 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 132135,
				ranks = 3,
				wowTreeIndex = 25,
				column = 3,
				name = "Improved Mangle",
				talentRankSpellIds = { 48532, 48489, 48491 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 26
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236164,
				ranks = 5,
				wowTreeIndex = 23,
				column = 2,
				name = "Rend and Tear",
				talentRankSpellIds = { 48432, 48433, 48434, 51268, 51269 }
			}
		}, {
			info = {
				row = 10,
				icon = 132140,
				ranks = 1,
				wowTreeIndex = 30,
				column = 3,
				name = "Primal Gore",
				talentRankSpellIds = { 63503 },
				prereqs = { {
					column = 2,
					row = 10,
					source = 28
				} }
			}
		}, {
			info = {
				row = 11,
				icon = 236149,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Berserk",
				talentRankSpellIds = { 50334 }
			}
		} },
		info = {
			background = "DruidFeralCombat",
			name = "Feral Combat",
			icon = 132276
		}
	}, -- [2]
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 136078,
				ranks = 2,
				wowTreeIndex = 1,
				column = 1,
				name = "Improved Mark of the Wild",
				talentRankSpellIds = { 17050, 17051 }
			}
		}, {
			info = {
				row = 1,
				icon = 136042,
				ranks = 3,
				wowTreeIndex = 3,
				column = 2,
				name = "Nature's Focus",
				talentRankSpellIds = { 17063, 17065, 17066 }
			}
		}, {
			info = {
				row = 1,
				icon = 135881,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Furor",
				talentRankSpellIds = { 17056, 17058, 17059, 17060, 17061 }
			}
		}, {
			info = {
				row = 2,
				icon = 136041,
				ranks = 5,
				wowTreeIndex = 4,
				column = 1,
				name = "Naturalist",
				talentRankSpellIds = { 17069, 17070, 17071, 17072, 17073 }
			}
		}, {
			info = {
				row = 2,
				icon = 132150,
				ranks = 3,
				wowTreeIndex = 12,
				column = 2,
				name = "Subtlety",
				talentRankSpellIds = { 17118, 17119, 17120 }
			}
		}, {
			info = {
				row = 2,
				icon = 136116,
				ranks = 3,
				wowTreeIndex = 6,
				column = 3,
				name = "Natural Shapeshifter",
				talentRankSpellIds = { 16833, 16834, 16835 }
			}
		}, {
			info = {
				row = 3,
				icon = 135863,
				ranks = 3,
				wowTreeIndex = 9,
				column = 1,
				name = "Intensity",
				talentRankSpellIds = { 17106, 17107, 17108 }
			}
		}, {
			info = {
				row = 3,
				icon = 136017,
				ranks = 1,
				wowTreeIndex = 7,
				column = 2,
				name = "Omen of Clarity",
				talentRankSpellIds = { 16864 }
			}
		}, {
			info = {
				row = 3,
				icon = 236161,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Master Shapeshifter",
				talentRankSpellIds = { 48411, 48412 },
				prereqs = { {
					column = 3,
					row = 2,
					source = 6
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 135900,
				ranks = 5,
				wowTreeIndex = 14,
				column = 2,
				name = "Tranquil Spirit",
				talentRankSpellIds = { 24968, 24969, 24970, 24971, 24972 }
			}
		}, {
			info = {
				row = 4,
				icon = 136081,
				ranks = 3,
				wowTreeIndex = 10,
				column = 3,
				name = "Improved Rejuvenation",
				talentRankSpellIds = { 17111, 17112, 17113 }
			}
		}, {
			info = {
				row = 5,
				icon = 136076,
				ranks = 1,
				wowTreeIndex = 11,
				column = 1,
				name = "Nature's Swiftness",
				talentRankSpellIds = { 17116 },
				prereqs = { {
					column = 1,
					row = 3,
					source = 7
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 136074,
				ranks = 5,
				wowTreeIndex = 8,
				column = 2,
				name = "Gift of Nature",
				talentRankSpellIds = { 17104, 24943, 24944, 24945, 24946 }
			}
		}, {
			info = {
				row = 5,
				icon = 136107,
				ranks = 2,
				wowTreeIndex = 13,
				column = 4,
				name = "Improved Tranquility",
				talentRankSpellIds = { 17123, 17124 }
			}
		}, {
			info = {
				row = 6,
				icon = 132125,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Empowered Touch",
				talentRankSpellIds = { 33879, 33880 }
			}
		}, {
			info = {
				row = 6,
				icon = 136085,
				ranks = 5,
				wowTreeIndex = 5,
				column = 3,
				name = "Nature's Bounty",
				talentRankSpellIds = { 17074, 17075, 17076, 17077, 17078 },
				prereqs = { {
					column = 3,
					row = 4,
					source = 11
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136037,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Living Spirit",
				talentRankSpellIds = { 34151, 34152, 34153 }
			}
		}, {
			info = {
				row = 7,
				icon = 134914,
				ranks = 1,
				wowTreeIndex = 15,
				column = 2,
				name = "Swiftmend",
				talentRankSpellIds = { 18562 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132137,
				ranks = 3,
				wowTreeIndex = 18,
				column = 3,
				name = "Natural Perfection",
				talentRankSpellIds = { 33881, 33882, 33883 }
			}
		}, {
			info = {
				row = 8,
				icon = 132124,
				ranks = 5,
				wowTreeIndex = 17,
				column = 2,
				name = "Empowered Rejuvenation",
				talentRankSpellIds = { 33886, 33887, 33888, 33889, 33890 }
			}
		}, {
			info = {
				row = 8,
				icon = 236155,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Living Seed",
				talentRankSpellIds = { 48496, 48499, 48500 }
			}
		}, {
			info = {
				row = 9,
				icon = 236166,
				ranks = 3,
				wowTreeIndex = 25,
				column = 1,
				name = "Revitalize",
				talentRankSpellIds = { 48539, 48544, 48545 }
			}
		}, {
			info = {
				row = 9,
				icon = 132145,
				ranks = 1,
				wowTreeIndex = 19,
				column = 2,
				name = "Tree of Life",
				talentRankSpellIds = { 65139 },
				prereqs = { {
					column = 2,
					row = 8,
					source = 20
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236157,
				ranks = 3,
				wowTreeIndex = 26,
				column = 3,
				name = "Improved Tree of Life",
				talentRankSpellIds = { 48535, 48536, 48537 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 23
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 136097,
				ranks = 2,
				wowTreeIndex = 27,
				column = 1,
				name = "Improved Barkskin",
				talentRankSpellIds = { 63410, 63411 }
			}
		}, {
			info = {
				row = 10,
				icon = 236160,
				ranks = 5,
				wowTreeIndex = 22,
				column = 3,
				name = "Gift of the Earthmother",
				talentRankSpellIds = { 51179, 51180, 51181, 51182, 51183 }
			}
		}, {
			info = {
				row = 11,
				icon = 236153,
				ranks = 1,
				wowTreeIndex = 23,
				column = 2,
				name = "Wild Growth",
				talentRankSpellIds = { 48438 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 23
				} }
			}
		} },
		info = {
			background = "DruidRestoration",
			name = "Restoration",
			icon = 136041
		}
	}, -- [3]
}

talents.hunter = {
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 136076,
				ranks = 5,
				wowTreeIndex = 2,
				column = 2,
				name = "Improved Aspect of the Hawk",
				talentRankSpellIds = { 19552, 19553, 19554, 19555, 19556 }
			}
		}, {
			info = {
				row = 1,
				icon = 136080,
				ranks = 5,
				wowTreeIndex = 8,
				column = 3,
				name = "Endurance Training",
				talentRankSpellIds = { 19583, 19584, 19585, 19586, 19587 }
			}
		}, {
			info = {
				row = 2,
				icon = 132210,
				ranks = 2,
				wowTreeIndex = 14,
				column = 1,
				name = "Focused Fire",
				talentRankSpellIds = { 35029, 35030 }
			}
		}, {
			info = {
				row = 2,
				icon = 132159,
				ranks = 3,
				wowTreeIndex = 1,
				column = 2,
				name = "Improved Aspect of the Monkey",
				talentRankSpellIds = { 19549, 19550, 19551 }
			}
		}, {
			info = {
				row = 2,
				icon = 134355,
				ranks = 3,
				wowTreeIndex = 11,
				column = 3,
				name = "Thick Hide",
				talentRankSpellIds = { 19609, 19610, 19612 }
			}
		}, {
			info = {
				row = 2,
				icon = 132163,
				ranks = 2,
				wowTreeIndex = 15,
				column = 4,
				name = "Improved Revive Pet",
				talentRankSpellIds = { 24443, 19575 }
			}
		}, {
			info = {
				row = 3,
				icon = 132242,
				ranks = 2,
				wowTreeIndex = 3,
				column = 1,
				name = "Pathfinding",
				talentRankSpellIds = { 19559, 19560 }
			}
		}, {
			info = {
				row = 3,
				icon = 236172,
				ranks = 1,
				wowTreeIndex = 23,
				column = 2,
				name = "Aspect Mastery",
				talentRankSpellIds = { 53265 }
			}
		}, {
			info = {
				row = 3,
				icon = 132091,
				ranks = 5,
				wowTreeIndex = 12,
				column = 3,
				name = "Unleashed Fury",
				talentRankSpellIds = { 19616, 19617, 19618, 19619, 19620 }
			}
		}, {
			info = {
				row = 4,
				icon = 132179,
				ranks = 2,
				wowTreeIndex = 4,
				column = 2,
				name = "Improved Mend Pet",
				talentRankSpellIds = { 19572, 19573 }
			}
		}, {
			info = {
				row = 4,
				icon = 134297,
				ranks = 5,
				wowTreeIndex = 10,
				column = 3,
				name = "Ferocity",
				talentRankSpellIds = { 19598, 19599, 19600, 19601, 19602 }
			}
		}, {
			info = {
				row = 5,
				icon = 132121,
				ranks = 2,
				wowTreeIndex = 7,
				column = 1,
				name = "Spirit Bond",
				talentRankSpellIds = { 19578, 20895 }
			}
		}, {
			info = {
				row = 5,
				icon = 132111,
				ranks = 1,
				wowTreeIndex = 6,
				column = 2,
				name = "Intimidation",
				talentRankSpellIds = { 19577 }
			}
		}, {
			info = {
				row = 5,
				icon = 136006,
				ranks = 2,
				wowTreeIndex = 9,
				column = 4,
				name = "Bestial Discipline",
				talentRankSpellIds = { 19590, 19592 }
			}
		}, {
			info = {
				row = 6,
				icon = 132158,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Animal Handler",
				talentRankSpellIds = { 34453, 34454 }
			}
		}, {
			info = {
				row = 6,
				icon = 134296,
				ranks = 5,
				wowTreeIndex = 13,
				column = 3,
				name = "Frenzy",
				talentRankSpellIds = { 19621, 19622, 19623, 19624, 19625 },
				prereqs = { {
					column = 3,
					row = 4,
					source = 11
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132173,
				ranks = 3,
				wowTreeIndex = 17,
				column = 1,
				name = "Ferocious Inspiration",
				talentRankSpellIds = { 34455, 34459, 34460 }
			}
		}, {
			info = {
				row = 7,
				icon = 132127,
				ranks = 1,
				wowTreeIndex = 5,
				column = 2,
				name = "Bestial Wrath",
				talentRankSpellIds = { 19574 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132167,
				ranks = 3,
				wowTreeIndex = 18,
				column = 3,
				name = "Catlike Reflexes",
				talentRankSpellIds = { 34462, 34464, 34465 }
			}
		}, {
			info = {
				row = 8,
				icon = 236184,
				ranks = 2,
				wowTreeIndex = 21,
				column = 1,
				name = "Invigoration",
				talentRankSpellIds = { 53252, 53253 },
				prereqs = { {
					column = 1,
					row = 7,
					source = 17
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 132209,
				ranks = 5,
				wowTreeIndex = 19,
				column = 3,
				name = "Serpent's Swiftness",
				talentRankSpellIds = { 34466, 34467, 34468, 34469, 34470 }
			}
		}, {
			info = {
				row = 9,
				icon = 236186,
				ranks = 3,
				wowTreeIndex = 25,
				column = 1,
				name = "Longevity",
				talentRankSpellIds = { 53262, 53263, 53264 }
			}
		}, {
			info = {
				row = 9,
				icon = 132166,
				ranks = 1,
				wowTreeIndex = 20,
				column = 2,
				name = "The Beast Within",
				talentRankSpellIds = { 34692 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236177,
				ranks = 3,
				wowTreeIndex = 22,
				column = 3,
				name = "Cobra Strikes",
				talentRankSpellIds = { 53256, 53259, 53260 },
				prereqs = { {
					column = 3,
					row = 8,
					source = 21
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236202,
				ranks = 5,
				wowTreeIndex = 26,
				column = 2,
				name = "Kindred Spirits",
				talentRankSpellIds = { 56314, 56315, 56316, 56317, 56318 }
			}
		}, {
			info = {
				row = 11,
				icon = 236175,
				ranks = 1,
				wowTreeIndex = 24,
				column = 2,
				name = "Beast Mastery",
				talentRankSpellIds = { 53270 }
			}
		} },
		info = {
			name = "Beast Mastery",
			background = "HunterBeastMastery"
		}
	}, -- [1]
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 135860,
				ranks = 2,
				wowTreeIndex = 1,
				column = 1,
				name = "Improved Concussive Shot",
				talentRankSpellIds = { 19407, 19412 }
			}
		}, {
			info = {
				row = 1,
				icon = 236179,
				ranks = 3,
				wowTreeIndex = 27,
				column = 2,
				name = "Focused Aim",
				talentRankSpellIds = { 53620, 53621, 53622 }
			}
		}, {
			info = {
				row = 1,
				icon = 132312,
				ranks = 5,
				wowTreeIndex = 4,
				column = 3,
				name = "Lethal Shots",
				talentRankSpellIds = { 19426, 19427, 19429, 19430, 19431 }
			}
		}, {
			info = {
				row = 2,
				icon = 132217,
				ranks = 3,
				wowTreeIndex = 15,
				column = 1,
				name = "Careful Aim",
				talentRankSpellIds = { 34482, 34483, 34484 }
			}
		}, {
			info = {
				row = 2,
				icon = 132212,
				ranks = 3,
				wowTreeIndex = 3,
				column = 2,
				name = "Improved Hunter's Mark",
				talentRankSpellIds = { 19421, 19422, 19423 }
			}
		}, {
			info = {
				row = 2,
				icon = 132271,
				ranks = 5,
				wowTreeIndex = 9,
				column = 3,
				name = "Mortal Shots",
				talentRankSpellIds = { 19485, 19487, 19488, 19489, 19490 }
			}
		}, {
			info = {
				row = 3,
				icon = 132174,
				ranks = 2,
				wowTreeIndex = 18,
				column = 1,
				name = "Go for the Throat",
				talentRankSpellIds = { 34950, 34954 }
			}
		}, {
			info = {
				row = 3,
				icon = 132218,
				ranks = 3,
				wowTreeIndex = 6,
				column = 2,
				name = "Improved Arcane Shot",
				talentRankSpellIds = { 19454, 19455, 19456 }
			}
		}, {
			info = {
				row = 3,
				icon = 135130,
				ranks = 1,
				wowTreeIndex = 5,
				column = 3,
				name = "Aimed Shot",
				talentRankSpellIds = { 19434 },
				prereqs = { {
					column = 3,
					row = 2,
					source = 6
				} }
			}
		}, {
			info = {
				row = 3,
				icon = 132205,
				ranks = 2,
				wowTreeIndex = 19,
				column = 4,
				name = "Rapid Killing",
				talentRankSpellIds = { 34948, 34949 }
			}
		}, {
			info = {
				row = 4,
				icon = 132204,
				ranks = 3,
				wowTreeIndex = 8,
				column = 2,
				name = "Improved Stings",
				talentRankSpellIds = { 19464, 19465, 19466 }
			}
		}, {
			info = {
				row = 4,
				icon = 135865,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Efficiency",
				talentRankSpellIds = { 19416, 19417, 19418, 19419, 19420 }
			}
		}, {
			info = {
				row = 5,
				icon = 135753,
				ranks = 2,
				wowTreeIndex = 10,
				column = 1,
				name = "Concussive Barrage",
				talentRankSpellIds = { 35100, 35102 }
			}
		}, {
			info = {
				row = 5,
				icon = 132206,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Readiness",
				talentRankSpellIds = { 23989 }
			}
		}, {
			info = {
				row = 5,
				icon = 132330,
				ranks = 3,
				wowTreeIndex = 7,
				column = 3,
				name = "Barrage",
				talentRankSpellIds = { 19461, 19462, 24691 }
			}
		}, {
			info = {
				row = 6,
				icon = 132168,
				ranks = 2,
				wowTreeIndex = 14,
				column = 1,
				name = "Combat Experience",
				talentRankSpellIds = { 34475, 34476 }
			}
		}, {
			info = {
				row = 6,
				icon = 135615,
				ranks = 3,
				wowTreeIndex = 13,
				column = 4,
				name = "Ranged Weapon Specialization",
				talentRankSpellIds = { 19507, 19508, 19509 }
			}
		}, {
			info = {
				row = 7,
				icon = 236198,
				ranks = 3,
				wowTreeIndex = 21,
				column = 1,
				name = "Piercing Shots",
				talentRankSpellIds = { 53234, 53237, 53238 }
			}
		}, {
			info = {
				row = 7,
				icon = 132329,
				ranks = 1,
				wowTreeIndex = 12,
				column = 2,
				name = "Trueshot Aura",
				talentRankSpellIds = { 19506 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132330,
				ranks = 3,
				wowTreeIndex = 20,
				column = 3,
				name = "Improved Barrage",
				talentRankSpellIds = { 35104, 35110, 35111 },
				prereqs = { {
					column = 3,
					row = 5,
					source = 15
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 132177,
				ranks = 5,
				wowTreeIndex = 16,
				column = 2,
				name = "Master Marksman",
				talentRankSpellIds = { 34485, 34486, 34487, 34488, 34489 }
			}
		}, {
			info = {
				row = 8,
				icon = 236201,
				ranks = 2,
				wowTreeIndex = 22,
				column = 3,
				name = "Rapid Recuperation",
				talentRankSpellIds = { 53228, 53232 }
			}
		}, {
			info = {
				row = 9,
				icon = 236204,
				ranks = 3,
				wowTreeIndex = 23,
				column = 1,
				name = "Wild Quiver",
				talentRankSpellIds = { 53215, 53216, 53217 }
			}
		}, {
			info = {
				row = 9,
				icon = 132323,
				ranks = 1,
				wowTreeIndex = 17,
				column = 2,
				name = "Silencing Shot",
				talentRankSpellIds = { 34490 },
				prereqs = { {
					column = 2,
					row = 8,
					source = 21
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236182,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Improved Steady Shot",
				talentRankSpellIds = { 53221, 53222, 53224 }
			}
		}, {
			info = {
				row = 10,
				icon = 236173,
				ranks = 5,
				wowTreeIndex = 25,
				column = 2,
				name = "Marked for Death",
				talentRankSpellIds = { 53241, 53243, 53244, 53245, 53246 }
			}
		}, {
			info = {
				row = 11,
				icon = 236176,
				ranks = 1,
				wowTreeIndex = 26,
				column = 2,
				name = "Chimera Shot",
				talentRankSpellIds = { 53209 }
			}
		} },
		info = {
			name = "Marksmanship",
			background = "HunterMarksmanship"
		}
	}, -- [2]
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 236183,
				ranks = 5,
				wowTreeIndex = 14,
				column = 1,
				name = "Improved Tracking",
				talentRankSpellIds = { 52783, 52785, 52786, 52787, 52788 }
			}
		}, {
			info = {
				row = 1,
				icon = 132327,
				ranks = 3,
				wowTreeIndex = 21,
				column = 2,
				name = "Hawk Eye",
				talentRankSpellIds = { 19498, 19499, 19500 }
			}
		}, {
			info = {
				row = 1,
				icon = 132277,
				ranks = 2,
				wowTreeIndex = 12,
				column = 3,
				name = "Savage Strikes",
				talentRankSpellIds = { 19159, 19160 }
			}
		}, {
			info = {
				row = 2,
				icon = 132219,
				ranks = 3,
				wowTreeIndex = 6,
				column = 1,
				name = "Surefooted",
				talentRankSpellIds = { 19290, 19294, 24283 }
			}
		}, {
			info = {
				row = 2,
				icon = 136100,
				ranks = 3,
				wowTreeIndex = 2,
				column = 2,
				name = "Entrapment",
				talentRankSpellIds = { 19184, 19387, 19388 }
			}
		}, {
			info = {
				row = 2,
				icon = 132149,
				ranks = 3,
				wowTreeIndex = 3,
				column = 3,
				name = "Trap Mastery",
				talentRankSpellIds = { 19376, 63457, 63458 }
			}
		}, {
			info = {
				row = 2,
				icon = 132214,
				ranks = 2,
				wowTreeIndex = 16,
				column = 4,
				name = "Survival Instincts",
				talentRankSpellIds = { 34494, 34496 }
			}
		}, {
			info = {
				row = 3,
				icon = 136223,
				ranks = 5,
				wowTreeIndex = 13,
				column = 1,
				name = "Survivalist",
				talentRankSpellIds = { 19255, 19256, 19257, 19258, 19259 }
			}
		}, {
			info = {
				row = 3,
				icon = 132153,
				ranks = 1,
				wowTreeIndex = 20,
				column = 2,
				name = "Scatter Shot",
				talentRankSpellIds = { 19503 }
			}
		}, {
			info = {
				row = 3,
				icon = 132269,
				ranks = 3,
				wowTreeIndex = 7,
				column = 3,
				name = "Deflection",
				talentRankSpellIds = { 19295, 19297, 19298 }
			}
		}, {
			info = {
				row = 3,
				icon = 132293,
				ranks = 2,
				wowTreeIndex = 5,
				column = 4,
				name = "Survival Tactics",
				talentRankSpellIds = { 19286, 19287 }
			}
		}, {
			info = {
				row = 4,
				icon = 133713,
				ranks = 3,
				wowTreeIndex = 28,
				column = 2,
				name = "T.N.T.",
				talentRankSpellIds = { 56333, 56336, 56337 }
			}
		}, {
			info = {
				row = 4,
				icon = 236185,
				ranks = 3,
				wowTreeIndex = 4,
				column = 4,
				name = "Lock and Load",
				talentRankSpellIds = { 56342, 56343, 56344 }
			}
		}, {
			info = {
				row = 5,
				icon = 236180,
				ranks = 3,
				wowTreeIndex = 27,
				column = 1,
				name = "Hunter vs. Wild",
				talentRankSpellIds = { 56339, 56340, 56341 },
				prereqs = { {
					column = 1,
					row = 3,
					source = 8
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 135881,
				ranks = 3,
				wowTreeIndex = 9,
				column = 2,
				name = "Killer Instinct",
				talentRankSpellIds = { 19370, 19371, 19373 }
			}
		}, {
			info = {
				row = 5,
				icon = 132336,
				ranks = 1,
				wowTreeIndex = 8,
				column = 3,
				name = "Counterattack",
				talentRankSpellIds = { 19306 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 10
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 136047,
				ranks = 5,
				wowTreeIndex = 1,
				column = 1,
				name = "Lightning Reflexes",
				talentRankSpellIds = { 19168, 19180, 19181, 24296, 24297 }
			}
		}, {
			info = {
				row = 6,
				icon = 132207,
				ranks = 3,
				wowTreeIndex = 15,
				column = 3,
				name = "Resourcefulness",
				talentRankSpellIds = { 34491, 34492, 34493 }
			}
		}, {
			info = {
				row = 7,
				icon = 132295,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Expose Weakness",
				talentRankSpellIds = { 34500, 34502, 34503 },
				prereqs = { {
					column = 1,
					row = 6,
					source = 17
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135125,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Wyvern Sting",
				talentRankSpellIds = { 19386 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 15
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132216,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Thrill of the Hunt",
				talentRankSpellIds = { 34497, 34498, 34499 }
			}
		}, {
			info = {
				row = 8,
				icon = 132178,
				ranks = 5,
				wowTreeIndex = 19,
				column = 1,
				name = "Master Tactician",
				talentRankSpellIds = { 34506, 34507, 34508, 34838, 34839 }
			}
		}, {
			info = {
				row = 8,
				icon = 236200,
				ranks = 3,
				wowTreeIndex = 22,
				column = 2,
				name = "Noxious Stings",
				talentRankSpellIds = { 53295, 53296, 53297 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236199,
				ranks = 2,
				wowTreeIndex = 23,
				column = 1,
				name = "Point of No Escape",
				talentRankSpellIds = { 53298, 53299 }
			}
		}, {
			info = {
				row = 9,
				icon = 136181,
				ranks = 1,
				wowTreeIndex = 10,
				column = 2,
				name = "Black Arrow",
				talentRankSpellIds = { 3674 }
			}
		}, {
			info = {
				row = 9,
				icon = 236187,
				ranks = 3,
				wowTreeIndex = 24,
				column = 4,
				name = "Sniper Training",
				talentRankSpellIds = { 53302, 53303, 53304 }
			}
		}, {
			info = {
				row = 10,
				icon = 236181,
				ranks = 3,
				wowTreeIndex = 25,
				column = 3,
				name = "Hunting Party",
				talentRankSpellIds = { 53290, 53291, 53292 },
				prereqs = { {
					column = 3,
					row = 7,
					source = 21
				} }
			}
		}, {
			info = {
				row = 11,
				icon = 236178,
				ranks = 1,
				wowTreeIndex = 26,
				column = 2,
				name = "Explosive Shot",
				talentRankSpellIds = { 53301 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 25
				} }
			}
		} },
		info = {
			name = "Survival",
			background = "HunterSurvival"
		}
	}, -- [3]
}

talents.mage = {
	{
		numtalents = 30,
		talents = { {
			info = {
				row = 1,
				icon = 135894,
				ranks = 2,
				wowTreeIndex = 1,
				column = 1,
				name = "Arcane Subtlety",
				talentRankSpellIds = { 11210, 12592 }
			}
		}, {
			info = {
				row = 1,
				icon = 135892,
				ranks = 3,
				wowTreeIndex = 3,
				column = 2,
				name = "Arcane Focus",
				talentRankSpellIds = { 11222, 12839, 12840 }
			}
		}, {
			info = {
				row = 1,
				icon = 136096,
				ranks = 5,
				wowTreeIndex = 5,
				column = 3,
				name = "Arcane Stability",
				talentRankSpellIds = { 11237, 12463, 12464, 16769, 16770 }
			}
		}, {
			info = {
				row = 2,
				icon = 135733,
				ranks = 3,
				wowTreeIndex = 9,
				column = 1,
				name = "Arcane Fortitude",
				talentRankSpellIds = { 28574, 54658, 54659 }
			}
		}, {
			info = {
				row = 2,
				icon = 136011,
				ranks = 2,
				wowTreeIndex = 15,
				column = 2,
				name = "Magic Absorption",
				talentRankSpellIds = { 29441, 29444 }
			}
		}, {
			info = {
				row = 2,
				icon = 136170,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Arcane Concentration",
				talentRankSpellIds = { 11213, 12574, 12575, 12576, 12577 }
			}
		}, {
			info = {
				row = 3,
				icon = 136006,
				ranks = 2,
				wowTreeIndex = 7,
				column = 1,
				name = "Magic Attunement",
				talentRankSpellIds = { 11247, 12606 }
			}
		}, {
			info = {
				row = 3,
				icon = 136116,
				ranks = 3,
				wowTreeIndex = 6,
				column = 2,
				name = "Spell Impact",
				talentRankSpellIds = { 11242, 12467, 12469 }
			}
		}, {
			info = {
				row = 3,
				icon = 236225,
				ranks = 3,
				wowTreeIndex = 25,
				column = 3,
				name = "Student of the Mind",
				talentRankSpellIds = { 44397, 44398, 44399 }
			}
		}, {
			info = {
				row = 3,
				icon = 135754,
				ranks = 1,
				wowTreeIndex = 29,
				column = 4,
				name = "Focus Magic",
				talentRankSpellIds = { 54646 }
			}
		}, {
			info = {
				row = 4,
				icon = 136153,
				ranks = 2,
				wowTreeIndex = 8,
				column = 1,
				name = "Arcane Shielding",
				talentRankSpellIds = { 11252, 12605 }
			}
		}, {
			info = {
				row = 4,
				icon = 135856,
				ranks = 2,
				wowTreeIndex = 12,
				column = 2,
				name = "Improved Counterspell",
				talentRankSpellIds = { 11255, 12598 }
			}
		}, {
			info = {
				row = 4,
				icon = 136208,
				ranks = 3,
				wowTreeIndex = 14,
				column = 3,
				name = "Arcane Meditation",
				talentRankSpellIds = { 18462, 18463, 18464 }
			}
		}, {
			info = {
				row = 4,
				icon = 236226,
				ranks = 3,
				wowTreeIndex = 30,
				column = 4,
				name = "Torment the Weak",
				talentRankSpellIds = { 29447, 55339, 55340 }
			}
		}, {
			info = {
				row = 5,
				icon = 135736,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Improved Blink",
				talentRankSpellIds = { 31569, 31570 }
			}
		}, {
			info = {
				row = 5,
				icon = 136031,
				ranks = 1,
				wowTreeIndex = 10,
				column = 2,
				name = "Presence of Mind",
				talentRankSpellIds = { 12043 }
			}
		}, {
			info = {
				row = 5,
				icon = 136129,
				ranks = 5,
				wowTreeIndex = 4,
				column = 4,
				name = "Arcane Mind",
				talentRankSpellIds = { 11232, 12500, 12501, 12502, 12503 }
			}
		}, {
			info = {
				row = 6,
				icon = 135752,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Prismatic Cloak",
				talentRankSpellIds = { 31574, 31575, 54354 }
			}
		}, {
			info = {
				row = 6,
				icon = 136222,
				ranks = 3,
				wowTreeIndex = 13,
				column = 2,
				name = "Arcane Instability",
				talentRankSpellIds = { 15058, 15059, 15060 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 16
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 135732,
				ranks = 2,
				wowTreeIndex = 17,
				column = 3,
				name = "Arcane Potency",
				talentRankSpellIds = { 31571, 31572 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 16
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136096,
				ranks = 3,
				wowTreeIndex = 19,
				column = 1,
				name = "Arcane Empowerment",
				talentRankSpellIds = { 31579, 31582, 31583 }
			}
		}, {
			info = {
				row = 7,
				icon = 136048,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Arcane Power",
				talentRankSpellIds = { 12042 },
				prereqs = { {
					column = 2,
					row = 6,
					source = 19
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 236219,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Incanter's Absorption",
				talentRankSpellIds = { 44394, 44395, 44396 }
			}
		}, {
			info = {
				row = 8,
				icon = 236223,
				ranks = 2,
				wowTreeIndex = 23,
				column = 2,
				name = "Arcane Flows",
				talentRankSpellIds = { 44378, 44379 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 22
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 135740,
				ranks = 5,
				wowTreeIndex = 20,
				column = 3,
				name = "Mind Mastery",
				talentRankSpellIds = { 31584, 31585, 31586, 31587, 31588 }
			}
		}, {
			info = {
				row = 9,
				icon = 136091,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Slow",
				talentRankSpellIds = { 31589 }
			}
		}, {
			info = {
				row = 9,
				icon = 236221,
				ranks = 5,
				wowTreeIndex = 28,
				column = 3,
				name = "Missile Barrage",
				talentRankSpellIds = { 44404, 54486, 54488, 54489, 54490 }
			}
		}, {
			info = {
				row = 10,
				icon = 236222,
				ranks = 3,
				wowTreeIndex = 26,
				column = 2,
				name = "Netherwind Presence",
				talentRankSpellIds = { 44400, 44402, 44403 }
			}
		}, {
			info = {
				row = 10,
				icon = 135734,
				ranks = 2,
				wowTreeIndex = 22,
				column = 3,
				name = "Spell Power",
				talentRankSpellIds = { 35578, 35581 }
			}
		}, {
			info = {
				row = 11,
				icon = 236205,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Arcane Barrage",
				talentRankSpellIds = { 44425 }
			}
		} },
		info = {
			name = "Arcane",
			background = "MageArcane"
		}
	}, -- [1]
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 135807,
				ranks = 2,
				wowTreeIndex = 5,
				column = 1,
				name = "Improved Fire Blast",
				talentRankSpellIds = { 11078, 11080 }
			}
		}, {
			info = {
				row = 1,
				icon = 135813,
				ranks = 3,
				wowTreeIndex = 15,
				column = 2,
				name = "Incineration",
				talentRankSpellIds = { 18459, 18460, 54734 }
			}
		}, {
			info = {
				row = 1,
				icon = 135812,
				ranks = 5,
				wowTreeIndex = 4,
				column = 3,
				name = "Improved Fireball",
				talentRankSpellIds = { 11069, 12338, 12339, 12340, 12341 }
			}
		}, {
			info = {
				row = 2,
				icon = 135818,
				ranks = 5,
				wowTreeIndex = 12,
				column = 1,
				name = "Ignite",
				talentRankSpellIds = { 11119, 11120, 12846, 12847, 12848 }
			}
		}, {
			info = {
				row = 2,
				icon = 135829,
				ranks = 2,
				wowTreeIndex = 28,
				column = 2,
				name = "Burning Determination",
				talentRankSpellIds = { 54747, 54749 }
			}
		}, {
			info = {
				row = 2,
				icon = 236228,
				ranks = 3,
				wowTreeIndex = 9,
				column = 3,
				name = "World in Flames",
				talentRankSpellIds = { 11108, 12349, 12350 }
			}
		}, {
			info = {
				row = 3,
				icon = 135815,
				ranks = 2,
				wowTreeIndex = 6,
				column = 1,
				name = "Flame Throwing",
				talentRankSpellIds = { 11100, 12353 }
			}
		}, {
			info = {
				row = 3,
				icon = 135821,
				ranks = 3,
				wowTreeIndex = 8,
				column = 2,
				name = "Impact",
				talentRankSpellIds = { 11103, 12357, 12358 }
			}
		}, {
			info = {
				row = 3,
				icon = 135808,
				ranks = 1,
				wowTreeIndex = 7,
				column = 3,
				name = "Pyroblast",
				talentRankSpellIds = { 11366 }
			}
		}, {
			info = {
				row = 3,
				icon = 135805,
				ranks = 2,
				wowTreeIndex = 1,
				column = 4,
				name = "Burning Soul",
				talentRankSpellIds = { 11083, 12351 }
			}
		}, {
			info = {
				row = 4,
				icon = 135827,
				ranks = 3,
				wowTreeIndex = 3,
				column = 1,
				name = "Improved Scorch",
				talentRankSpellIds = { 11095, 12872, 12873 }
			}
		}, {
			info = {
				row = 4,
				icon = 135806,
				ranks = 2,
				wowTreeIndex = 2,
				column = 2,
				name = "Molten Shields",
				talentRankSpellIds = { 11094, 13043 }
			}
		}, {
			info = {
				row = 4,
				icon = 135820,
				ranks = 3,
				wowTreeIndex = 16,
				column = 4,
				name = "Master of Elements",
				talentRankSpellIds = { 29074, 29075, 29076 }
			}
		}, {
			info = {
				row = 5,
				icon = 135823,
				ranks = 3,
				wowTreeIndex = 17,
				column = 1,
				name = "Playing with Fire",
				talentRankSpellIds = { 31638, 31639, 31640 }
			}
		}, {
			info = {
				row = 5,
				icon = 136115,
				ranks = 3,
				wowTreeIndex = 11,
				column = 2,
				name = "Critical Mass",
				talentRankSpellIds = { 11115, 11367, 11368 }
			}
		}, {
			info = {
				row = 5,
				icon = 135903,
				ranks = 1,
				wowTreeIndex = 10,
				column = 3,
				name = "Blast Wave",
				talentRankSpellIds = { 11113 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 9
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 135788,
				ranks = 2,
				wowTreeIndex = 18,
				column = 1,
				name = "Blazing Speed",
				talentRankSpellIds = { 31641, 31642 }
			}
		}, {
			info = {
				row = 6,
				icon = 135817,
				ranks = 5,
				wowTreeIndex = 13,
				column = 3,
				name = "Fire Power",
				talentRankSpellIds = { 11124, 12378, 12398, 12399, 12400 }
			}
		}, {
			info = {
				row = 7,
				icon = 135789,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Pyromaniac",
				talentRankSpellIds = { 34293, 34295, 34296 }
			}
		}, {
			info = {
				row = 7,
				icon = 135824,
				ranks = 1,
				wowTreeIndex = 14,
				column = 2,
				name = "Combustion",
				talentRankSpellIds = { 11129 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 15
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135822,
				ranks = 2,
				wowTreeIndex = 19,
				column = 3,
				name = "Molten Fury",
				talentRankSpellIds = { 31679, 31680 }
			}
		}, {
			info = {
				row = 8,
				icon = 236215,
				ranks = 2,
				wowTreeIndex = 23,
				column = 1,
				name = "Fiery Payback",
				talentRankSpellIds = { 64353, 64357 }
			}
		}, {
			info = {
				row = 8,
				icon = 135812,
				ranks = 3,
				wowTreeIndex = 21,
				column = 3,
				name = "Empowered Fire",
				talentRankSpellIds = { 31656, 31657, 31658 }
			}
		}, {
			info = {
				row = 9,
				icon = 236216,
				ranks = 2,
				wowTreeIndex = 24,
				column = 1,
				name = "Firestarter",
				talentRankSpellIds = { 44442, 44443 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 25
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 134153,
				ranks = 1,
				wowTreeIndex = 22,
				column = 2,
				name = "Dragon's Breath",
				talentRankSpellIds = { 31661 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236218,
				ranks = 3,
				wowTreeIndex = 25,
				column = 3,
				name = "Hot Streak",
				talentRankSpellIds = { 44445, 44446, 44448 }
			}
		}, {
			info = {
				row = 10,
				icon = 236207,
				ranks = 5,
				wowTreeIndex = 26,
				column = 2,
				name = "Burnout",
				talentRankSpellIds = { 44449, 44469, 44470, 44471, 44472 }
			}
		}, {
			info = {
				row = 11,
				icon = 236220,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Living Bomb",
				talentRankSpellIds = { 44457 }
			}
		} },
		info = {
			name = "Fire",
			background = "MageFire"
		}
	}, -- [2]
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 135842,
				ranks = 3,
				wowTreeIndex = 2,
				column = 1,
				name = "Frostbite",
				talentRankSpellIds = { 11071, 12496, 12497 }
			}
		}, {
			info = {
				row = 1,
				icon = 135846,
				ranks = 5,
				wowTreeIndex = 1,
				column = 2,
				name = "Improved Frostbolt",
				talentRankSpellIds = { 11070, 12473, 16763, 16765, 16766 }
			}
		}, {
			info = {
				row = 1,
				icon = 135854,
				ranks = 3,
				wowTreeIndex = 4,
				column = 3,
				name = "Ice Floes",
				talentRankSpellIds = { 31670, 31672, 55094 }
			}
		}, {
			info = {
				row = 2,
				icon = 135855,
				ranks = 3,
				wowTreeIndex = 15,
				column = 1,
				name = "Ice Shards",
				talentRankSpellIds = { 11207, 12672, 15047 }
			}
		}, {
			info = {
				row = 2,
				icon = 135850,
				ranks = 2,
				wowTreeIndex = 12,
				column = 2,
				name = "Frost Warding",
				talentRankSpellIds = { 11189, 28332 }
			}
		}, {
			info = {
				row = 2,
				icon = 135989,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Precision",
				talentRankSpellIds = { 29438, 29439, 29440 }
			}
		}, {
			info = {
				row = 2,
				icon = 135864,
				ranks = 3,
				wowTreeIndex = 7,
				column = 4,
				name = "Permafrost",
				talentRankSpellIds = { 11175, 12569, 12571 }
			}
		}, {
			info = {
				row = 3,
				icon = 135845,
				ranks = 3,
				wowTreeIndex = 3,
				column = 1,
				name = "Piercing Ice",
				talentRankSpellIds = { 11151, 12952, 12953 }
			}
		}, {
			info = {
				row = 3,
				icon = 135838,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Icy Veins",
				talentRankSpellIds = { 12472 }
			}
		}, {
			info = {
				row = 3,
				icon = 135857,
				ranks = 3,
				wowTreeIndex = 5,
				column = 3,
				name = "Improved Blizzard",
				talentRankSpellIds = { 11185, 12487, 12488 }
			}
		}, {
			info = {
				row = 4,
				icon = 136141,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Arctic Reach",
				talentRankSpellIds = { 16757, 16758 }
			}
		}, {
			info = {
				row = 4,
				icon = 135860,
				ranks = 3,
				wowTreeIndex = 8,
				column = 2,
				name = "Frost Channeling",
				talentRankSpellIds = { 11160, 12518, 12519 }
			}
		}, {
			info = {
				row = 4,
				icon = 135849,
				ranks = 3,
				wowTreeIndex = 9,
				column = 3,
				name = "Shatter",
				talentRankSpellIds = { 11170, 12982, 12983 }
			}
		}, {
			info = {
				row = 5,
				icon = 135865,
				ranks = 1,
				wowTreeIndex = 14,
				column = 2,
				name = "Cold Snap",
				talentRankSpellIds = { 11958 }
			}
		}, {
			info = {
				row = 5,
				icon = 135852,
				ranks = 3,
				wowTreeIndex = 6,
				column = 3,
				name = "Improved Cone of Cold",
				talentRankSpellIds = { 11190, 12489, 12490 }
			}
		}, {
			info = {
				row = 5,
				icon = 135851,
				ranks = 3,
				wowTreeIndex = 18,
				column = 4,
				name = "Frozen Core",
				talentRankSpellIds = { 31667, 31668, 31669 }
			}
		}, {
			info = {
				row = 6,
				icon = 236209,
				ranks = 2,
				wowTreeIndex = 19,
				column = 1,
				name = "Cold as Ice",
				talentRankSpellIds = { 55091, 55092 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 135836,
				ranks = 3,
				wowTreeIndex = 10,
				column = 3,
				name = "Winter's Chill",
				talentRankSpellIds = { 11180, 28592, 28593 }
			}
		}, {
			info = {
				row = 7,
				icon = 236224,
				ranks = 2,
				wowTreeIndex = 28,
				column = 1,
				name = "Shattered Barrier",
				talentRankSpellIds = { 44745, 54787 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135988,
				ranks = 1,
				wowTreeIndex = 13,
				column = 2,
				name = "Ice Barrier",
				talentRankSpellIds = { 11426 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135833,
				ranks = 5,
				wowTreeIndex = 20,
				column = 3,
				name = "Arctic Winds",
				talentRankSpellIds = { 31674, 31675, 31676, 31677, 31678 }
			}
		}, {
			info = {
				row = 8,
				icon = 135846,
				ranks = 2,
				wowTreeIndex = 21,
				column = 2,
				name = "Empowered Frostbolt",
				talentRankSpellIds = { 31682, 31683 }
			}
		}, {
			info = {
				row = 8,
				icon = 236227,
				ranks = 2,
				wowTreeIndex = 23,
				column = 3,
				name = "Fingers of Frost",
				talentRankSpellIds = { 44543, 44545 }
			}
		}, {
			info = {
				row = 9,
				icon = 236206,
				ranks = 3,
				wowTreeIndex = 24,
				column = 1,
				name = "Brain Freeze",
				talentRankSpellIds = { 44546, 44548, 44549 }
			}
		}, {
			info = {
				row = 9,
				icon = 135862,
				ranks = 1,
				wowTreeIndex = 22,
				column = 2,
				name = "Summon Water Elemental",
				talentRankSpellIds = { 31687 }
			}
		}, {
			info = {
				row = 9,
				icon = 135862,
				ranks = 3,
				wowTreeIndex = 25,
				column = 3,
				name = "Enduring Winter",
				talentRankSpellIds = { 44557, 44560, 44561 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 25
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236208,
				ranks = 5,
				wowTreeIndex = 26,
				column = 2,
				name = "Chilled to the Bone",
				talentRankSpellIds = { 44566, 44567, 44568, 44570, 44571 }
			}
		}, {
			info = {
				row = 11,
				icon = 236214,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Deep Freeze",
				talentRankSpellIds = { 44572 }
			}
		} },
		info = {
			name = "Frost",
			background = "MageFrost"
		}
	}, -- [3]
}

talents.paladin = {
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 135736,
				ranks = 5,
				wowTreeIndex = 1,
				column = 2,
				name = "Spiritual Focus",
				talentRankSpellIds = { 20205, 20206, 20207, 20209, 20208 }
			}
		}, {
			info = {
				row = 1,
				icon = 132325,
				ranks = 5,
				wowTreeIndex = 10,
				column = 3,
				name = "Seals of the Pure",
				talentRankSpellIds = { 20224, 20225, 20330, 20331, 20332 }
			}
		}, {
			info = {
				row = 2,
				icon = 135920,
				ranks = 3,
				wowTreeIndex = 5,
				column = 1,
				name = "Healing Light",
				talentRankSpellIds = { 20237, 20238, 20239 }
			}
		}, {
			info = {
				row = 2,
				icon = 136090,
				ranks = 5,
				wowTreeIndex = 7,
				column = 2,
				name = "Divine Intellect",
				talentRankSpellIds = { 20257, 20258, 20259, 20260, 20261 }
			}
		}, {
			info = {
				row = 2,
				icon = 135984,
				ranks = 2,
				wowTreeIndex = 14,
				column = 3,
				name = "Unyielding Faith",
				talentRankSpellIds = { 9453, 25836 }
			}
		}, {
			info = {
				row = 3,
				icon = 135872,
				ranks = 1,
				wowTreeIndex = 3,
				column = 1,
				name = "Aura Mastery",
				talentRankSpellIds = { 31821 }
			}
		}, {
			info = {
				row = 3,
				icon = 135913,
				ranks = 5,
				wowTreeIndex = 9,
				column = 2,
				name = "Illumination",
				talentRankSpellIds = { 20210, 20212, 20213, 20214, 20215 }
			}
		}, {
			info = {
				row = 3,
				icon = 135928,
				ranks = 2,
				wowTreeIndex = 4,
				column = 3,
				name = "Improved Lay on Hands",
				talentRankSpellIds = { 20234, 20235 }
			}
		}, {
			info = {
				row = 4,
				icon = 135933,
				ranks = 3,
				wowTreeIndex = 8,
				column = 1,
				name = "Improved Concentration Aura",
				talentRankSpellIds = { 20254, 20255, 20256 }
			}
		}, {
			info = {
				row = 4,
				icon = 135970,
				ranks = 2,
				wowTreeIndex = 6,
				column = 3,
				name = "Improved Blessing of Wisdom",
				talentRankSpellIds = { 20244, 20245 }
			}
		}, {
			info = {
				row = 4,
				icon = 236248,
				ranks = 2,
				wowTreeIndex = 25,
				column = 4,
				name = "Blessed Hands",
				talentRankSpellIds = { 53660, 53661 }
			}
		}, {
			info = {
				row = 5,
				icon = 135948,
				ranks = 2,
				wowTreeIndex = 15,
				column = 1,
				name = "Pure of Heart",
				talentRankSpellIds = { 31822, 31823 }
			}
		}, {
			info = {
				row = 5,
				icon = 135915,
				ranks = 1,
				wowTreeIndex = 2,
				column = 2,
				name = "Divine Favor",
				talentRankSpellIds = { 20216 },
				prereqs = { {
					column = 2,
					row = 3,
					source = 7
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 135917,
				ranks = 3,
				wowTreeIndex = 11,
				column = 3,
				name = "Sanctified Light",
				talentRankSpellIds = { 20359, 20360, 20361 }
			}
		}, {
			info = {
				row = 6,
				icon = 135950,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Purifying Power",
				talentRankSpellIds = { 31825, 31826 }
			}
		}, {
			info = {
				row = 6,
				icon = 135938,
				ranks = 5,
				wowTreeIndex = 13,
				column = 3,
				name = "Holy Power",
				talentRankSpellIds = { 5923, 5924, 5925, 5926, 25829 }
			}
		}, {
			info = {
				row = 7,
				icon = 135931,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Light's Grace",
				talentRankSpellIds = { 31833, 31835, 31836 }
			}
		}, {
			info = {
				row = 7,
				icon = 135972,
				ranks = 1,
				wowTreeIndex = 12,
				column = 2,
				name = "Holy Shock",
				talentRankSpellIds = { 20473 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135876,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Blessed Life",
				talentRankSpellIds = { 31828, 31829, 31830 }
			}
		}, {
			info = {
				row = 8,
				icon = 236261,
				ranks = 3,
				wowTreeIndex = 21,
				column = 1,
				name = "Sacred Cleansing",
				talentRankSpellIds = { 53551, 53552, 53553 }
			}
		}, {
			info = {
				row = 8,
				icon = 135921,
				ranks = 5,
				wowTreeIndex = 19,
				column = 3,
				name = "Holy Guidance",
				talentRankSpellIds = { 31837, 31838, 31839, 31840, 31841 }
			}
		}, {
			info = {
				row = 9,
				icon = 135895,
				ranks = 1,
				wowTreeIndex = 20,
				column = 1,
				name = "Divine Illumination",
				talentRankSpellIds = { 31842 }
			}
		}, {
			info = {
				row = 9,
				icon = 236256,
				ranks = 5,
				wowTreeIndex = 26,
				column = 3,
				name = "Judgements of the Pure",
				talentRankSpellIds = { 53671, 53673, 54151, 54154, 54155 }
			}
		}, {
			info = {
				row = 10,
				icon = 236254,
				ranks = 2,
				wowTreeIndex = 24,
				column = 2,
				name = "Infusion of Light",
				talentRankSpellIds = { 53569, 53576 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236251,
				ranks = 2,
				wowTreeIndex = 22,
				column = 3,
				name = "Enlightened Judgements",
				talentRankSpellIds = { 53556, 53557 }
			}
		}, {
			info = {
				row = 11,
				icon = 236247,
				ranks = 1,
				wowTreeIndex = 23,
				column = 2,
				name = "Beacon of Light",
				talentRankSpellIds = { 53563 }
			}
		} },
		info = {
			name = "Holy",
			background = "PaladinHoly"
		}
	}, -- [1]
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 135883,
				ranks = 5,
				wowTreeIndex = 9,
				column = 2,
				name = "Divinity",
				talentRankSpellIds = { 63646, 63647, 63648, 63649, 63650 }
			}
		}, {
			info = {
				row = 1,
				icon = 132154,
				ranks = 5,
				wowTreeIndex = 18,
				column = 3,
				name = "Divine Strength",
				talentRankSpellIds = { 20262, 20263, 20264, 20265, 20266 }
			}
		}, {
			info = {
				row = 2,
				icon = 135978,
				ranks = 3,
				wowTreeIndex = 13,
				column = 1,
				name = "Stoicism",
				talentRankSpellIds = { 31844, 31845, 53519 }
			}
		}, {
			info = {
				row = 2,
				icon = 135964,
				ranks = 2,
				wowTreeIndex = 4,
				column = 2,
				name = "Guardian's Favor",
				talentRankSpellIds = { 20174, 20175 }
			}
		}, {
			info = {
				row = 2,
				icon = 135994,
				ranks = 5,
				wowTreeIndex = 12,
				column = 3,
				name = "Anticipation",
				talentRankSpellIds = { 20096, 20097, 20098, 20099, 20100 }
			}
		}, {
			info = {
				row = 3,
				icon = 253400,
				ranks = 1,
				wowTreeIndex = 24,
				column = 1,
				name = "Divine Sacrifice",
				talentRankSpellIds = { 64205 }
			}
		}, {
			info = {
				row = 3,
				icon = 135962,
				ranks = 3,
				wowTreeIndex = 10,
				column = 2,
				name = "Improved Righteous Fury",
				talentRankSpellIds = { 20468, 20469, 20470 }
			}
		}, {
			info = {
				row = 3,
				icon = 135892,
				ranks = 5,
				wowTreeIndex = 3,
				column = 3,
				name = "Toughness",
				talentRankSpellIds = { 20143, 20144, 20145, 20146, 20147 }
			}
		}, {
			info = {
				row = 4,
				icon = 253400,
				ranks = 2,
				wowTreeIndex = 25,
				column = 1,
				name = "Divine Guardian",
				talentRankSpellIds = { 53527, 53530 },
				prereqs = { {
					column = 1,
					row = 3,
					source = 6
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 135963,
				ranks = 2,
				wowTreeIndex = 11,
				column = 2,
				name = "Improved Hammer of Justice",
				talentRankSpellIds = { 20487, 20488 }
			}
		}, {
			info = {
				row = 4,
				icon = 135893,
				ranks = 3,
				wowTreeIndex = 2,
				column = 3,
				name = "Improved Devotion Aura",
				talentRankSpellIds = { 20138, 20139, 20140 }
			}
		}, {
			info = {
				row = 5,
				icon = 136051,
				ranks = 1,
				wowTreeIndex = 8,
				column = 2,
				name = "Blessing of Sanctuary",
				talentRankSpellIds = { 20911 }
			}
		}, {
			info = {
				row = 5,
				icon = 135882,
				ranks = 5,
				wowTreeIndex = 5,
				column = 3,
				name = "Reckoning",
				talentRankSpellIds = { 20177, 20179, 20181, 20180, 20182 }
			}
		}, {
			info = {
				row = 6,
				icon = 135896,
				ranks = 2,
				wowTreeIndex = 14,
				column = 1,
				name = "Sacred Duty",
				talentRankSpellIds = { 31848, 31849 }
			}
		}, {
			info = {
				row = 6,
				icon = 135321,
				ranks = 3,
				wowTreeIndex = 6,
				column = 3,
				name = "One-Handed Weapon Specialization",
				talentRankSpellIds = { 20196, 20197, 20198 }
			}
		}, {
			info = {
				row = 7,
				icon = 135958,
				ranks = 2,
				wowTreeIndex = 26,
				column = 1,
				name = "Spiritual Attunement",
				talentRankSpellIds = { 31785, 33776 }
			}
		}, {
			info = {
				row = 7,
				icon = 135880,
				ranks = 1,
				wowTreeIndex = 7,
				column = 2,
				name = "Holy Shield",
				talentRankSpellIds = { 20925 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 12
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135870,
				ranks = 3,
				wowTreeIndex = 15,
				column = 3,
				name = "Ardent Defender",
				talentRankSpellIds = { 31850, 31851, 31852 }
			}
		}, {
			info = {
				row = 8,
				icon = 132110,
				ranks = 3,
				wowTreeIndex = 1,
				column = 1,
				name = "Redoubt",
				talentRankSpellIds = { 20127, 20130, 20135 }
			}
		}, {
			info = {
				row = 8,
				icon = 135986,
				ranks = 3,
				wowTreeIndex = 16,
				column = 3,
				name = "Combat Expertise",
				talentRankSpellIds = { 31858, 31859, 31860 }
			}
		}, {
			info = {
				row = 9,
				icon = 236267,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Touched by the Light",
				talentRankSpellIds = { 53590, 53591, 53592 }
			}
		}, {
			info = {
				row = 9,
				icon = 135874,
				ranks = 1,
				wowTreeIndex = 17,
				column = 2,
				name = "Avenger's Shield",
				talentRankSpellIds = { 31935 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 17
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236252,
				ranks = 2,
				wowTreeIndex = 19,
				column = 3,
				name = "Guarded by the Light",
				talentRankSpellIds = { 53583, 53585 }
			}
		}, {
			info = {
				row = 10,
				icon = 236264,
				ranks = 3,
				wowTreeIndex = 23,
				column = 2,
				name = "Shield of the Templar",
				talentRankSpellIds = { 53709, 53710, 53711 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 22
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236259,
				ranks = 2,
				wowTreeIndex = 22,
				column = 3,
				name = "Judgements of the Just",
				talentRankSpellIds = { 53695, 53696 }
			}
		}, {
			info = {
				row = 11,
				icon = 236253,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Hammer of the Righteous",
				talentRankSpellIds = { 53595 }
			}
		} },
		info = {
			name = "Protection",
			background = "PaladinProtection"
		}
	}, -- [2]
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 132269,
				ranks = 5,
				wowTreeIndex = 3,
				column = 2,
				name = "Deflection",
				talentRankSpellIds = { 20060, 20061, 20062, 20063, 20064 }
			}
		}, {
			info = {
				row = 1,
				icon = 135863,
				ranks = 5,
				wowTreeIndex = 4,
				column = 3,
				name = "Benediction",
				talentRankSpellIds = { 20101, 20102, 20103, 20104, 20105 }
			}
		}, {
			info = {
				row = 2,
				icon = 135959,
				ranks = 2,
				wowTreeIndex = 10,
				column = 1,
				name = "Improved Judgements",
				talentRankSpellIds = { 25956, 25957 }
			}
		}, {
			info = {
				row = 2,
				icon = 135924,
				ranks = 3,
				wowTreeIndex = 8,
				column = 2,
				name = "Heart of the Crusader",
				talentRankSpellIds = { 20335, 20336, 20337 }
			}
		}, {
			info = {
				row = 2,
				icon = 135906,
				ranks = 2,
				wowTreeIndex = 1,
				column = 3,
				name = "Improved Blessing of Might",
				talentRankSpellIds = { 20042, 20045 }
			}
		}, {
			info = {
				row = 3,
				icon = 135985,
				ranks = 2,
				wowTreeIndex = 12,
				column = 1,
				name = "Vindication",
				talentRankSpellIds = { 9452, 26016 }
			}
		}, {
			info = {
				row = 3,
				icon = 135957,
				ranks = 5,
				wowTreeIndex = 6,
				column = 2,
				name = "Conviction",
				talentRankSpellIds = { 20117, 20118, 20119, 20120, 20121 }
			}
		}, {
			info = {
				row = 3,
				icon = 132347,
				ranks = 1,
				wowTreeIndex = 9,
				column = 3,
				name = "Seal of Command",
				talentRankSpellIds = { 20375 }
			}
		}, {
			info = {
				row = 3,
				icon = 135937,
				ranks = 2,
				wowTreeIndex = 13,
				column = 4,
				name = "Pursuit of Justice",
				talentRankSpellIds = { 26022, 26023 }
			}
		}, {
			info = {
				row = 4,
				icon = 135904,
				ranks = 2,
				wowTreeIndex = 11,
				column = 1,
				name = "Eye for an Eye",
				talentRankSpellIds = { 9799, 25988 }
			}
		}, {
			info = {
				row = 4,
				icon = 135924,
				ranks = 3,
				wowTreeIndex = 19,
				column = 3,
				name = "Sanctity of Battle",
				talentRankSpellIds = { 32043, 35396, 35397 }
			}
		}, {
			info = {
				row = 4,
				icon = 135889,
				ranks = 3,
				wowTreeIndex = 14,
				column = 4,
				name = "Crusade",
				talentRankSpellIds = { 31866, 31867, 31868 }
			}
		}, {
			info = {
				row = 5,
				icon = 133041,
				ranks = 3,
				wowTreeIndex = 5,
				column = 1,
				name = "Two-Handed Weapon Specialization",
				talentRankSpellIds = { 20111, 20112, 20113 }
			}
		}, {
			info = {
				row = 5,
				icon = 135934,
				ranks = 1,
				wowTreeIndex = 15,
				column = 3,
				name = "Sanctified Retribution",
				talentRankSpellIds = { 31869 }
			}
		}, {
			info = {
				row = 6,
				icon = 132275,
				ranks = 3,
				wowTreeIndex = 2,
				column = 2,
				name = "Vengeance",
				talentRankSpellIds = { 20049, 20056, 20057 },
				prereqs = { {
					column = 2,
					row = 3,
					source = 7
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 135897,
				ranks = 2,
				wowTreeIndex = 16,
				column = 3,
				name = "Divine Purpose",
				talentRankSpellIds = { 31871, 31872 }
			}
		}, {
			info = {
				row = 7,
				icon = 236246,
				ranks = 2,
				wowTreeIndex = 25,
				column = 1,
				name = "The Art of War",
				talentRankSpellIds = { 53486, 53488 }
			}
		}, {
			info = {
				row = 7,
				icon = 135942,
				ranks = 1,
				wowTreeIndex = 7,
				column = 2,
				name = "Repentance",
				talentRankSpellIds = { 20066 }
			}
		}, {
			info = {
				row = 7,
				icon = 236257,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Judgements of the Wise",
				talentRankSpellIds = { 31876, 31877, 31878 }
			}
		}, {
			info = {
				row = 8,
				icon = 135905,
				ranks = 3,
				wowTreeIndex = 18,
				column = 2,
				name = "Fanaticism",
				talentRankSpellIds = { 31879, 31880, 31881 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 236262,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Sanctified Wrath",
				talentRankSpellIds = { 53375, 53376 }
			}
		}, {
			info = {
				row = 9,
				icon = 236266,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Swift Retribution",
				talentRankSpellIds = { 53379, 53484, 53648 }
			}
		}, {
			info = {
				row = 9,
				icon = 135891,
				ranks = 1,
				wowTreeIndex = 20,
				column = 2,
				name = "Crusader Strike",
				talentRankSpellIds = { 35395 }
			}
		}, {
			info = {
				row = 9,
				icon = 236263,
				ranks = 3,
				wowTreeIndex = 26,
				column = 3,
				name = "Sheath of Light",
				talentRankSpellIds = { 53501, 53502, 53503 }
			}
		}, {
			info = {
				row = 10,
				icon = 236260,
				ranks = 3,
				wowTreeIndex = 23,
				column = 2,
				name = "Righteous Vengeance",
				talentRankSpellIds = { 53380, 53381, 53382 }
			}
		}, {
			info = {
				row = 11,
				icon = 236250,
				ranks = 1,
				wowTreeIndex = 24,
				column = 2,
				name = "Divine Storm",
				talentRankSpellIds = { 53385 }
			}
		} },
		info = {
			name = "Retribution",
			background = "PaladinCombat"
		}
	}, -- [3]
}

talents.priest = {
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 135995,
				ranks = 5,
				wowTreeIndex = 4,
				column = 2,
				name = "Unbreakable Will",
				talentRankSpellIds = { 14522, 14788, 14789, 14790, 14791 }
			}
		}, {
			info = {
				row = 1,
				icon = 135969,
				ranks = 5,
				wowTreeIndex = 25,
				column = 3,
				name = "Twin Disciplines",
				talentRankSpellIds = { 47586, 47587, 47588, 52802, 52803 }
			}
		}, {
			info = {
				row = 2,
				icon = 136053,
				ranks = 3,
				wowTreeIndex = 12,
				column = 1,
				name = "Silent Resolve",
				talentRankSpellIds = { 14523, 14784, 14785 }
			}
		}, {
			info = {
				row = 2,
				icon = 135926,
				ranks = 3,
				wowTreeIndex = 7,
				column = 2,
				name = "Improved Inner Fire",
				talentRankSpellIds = { 14747, 14770, 14771 }
			}
		}, {
			info = {
				row = 2,
				icon = 135987,
				ranks = 2,
				wowTreeIndex = 6,
				column = 3,
				name = "Improved Power Word: Fortitude",
				talentRankSpellIds = { 14749, 14767 }
			}
		}, {
			info = {
				row = 2,
				icon = 136107,
				ranks = 2,
				wowTreeIndex = 1,
				column = 4,
				name = "Martyrdom",
				talentRankSpellIds = { 14531, 14774 }
			}
		}, {
			info = {
				row = 3,
				icon = 136090,
				ranks = 3,
				wowTreeIndex = 8,
				column = 1,
				name = "Meditation",
				talentRankSpellIds = { 14521, 14776, 14777 }
			}
		}, {
			info = {
				row = 3,
				icon = 135863,
				ranks = 1,
				wowTreeIndex = 9,
				column = 2,
				name = "Inner Focus",
				talentRankSpellIds = { 14751 }
			}
		}, {
			info = {
				row = 3,
				icon = 135940,
				ranks = 3,
				wowTreeIndex = 5,
				column = 3,
				name = "Improved Power Word: Shield",
				talentRankSpellIds = { 14748, 14768, 14769 }
			}
		}, {
			info = {
				row = 4,
				icon = 135868,
				ranks = 3,
				wowTreeIndex = 15,
				column = 1,
				name = "Absolution",
				talentRankSpellIds = { 33167, 33171, 33172 }
			}
		}, {
			info = {
				row = 4,
				icon = 132156,
				ranks = 3,
				wowTreeIndex = 3,
				column = 2,
				name = "Mental Agility",
				talentRankSpellIds = { 14520, 14780, 14781 }
			}
		}, {
			info = {
				row = 4,
				icon = 136170,
				ranks = 2,
				wowTreeIndex = 10,
				column = 4,
				name = "Improved Mana Burn",
				talentRankSpellIds = { 14750, 14772 }
			}
		}, {
			info = {
				row = 5,
				icon = 135940,
				ranks = 2,
				wowTreeIndex = 28,
				column = 1,
				name = "Reflective Shield",
				talentRankSpellIds = { 33201, 33202 }
			}
		}, {
			info = {
				row = 5,
				icon = 136031,
				ranks = 5,
				wowTreeIndex = 13,
				column = 2,
				name = "Mental Strength",
				talentRankSpellIds = { 18551, 18552, 18553, 18554, 18555 }
			}
		}, {
			info = {
				row = 5,
				icon = 135948,
				ranks = 1,
				wowTreeIndex = 11,
				column = 3,
				name = "Soul Warding",
				talentRankSpellIds = { 63574 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 9
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 136158,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Focused Power",
				talentRankSpellIds = { 33186, 33190 }
			}
		}, {
			info = {
				row = 6,
				icon = 135740,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Enlightenment",
				talentRankSpellIds = { 34908, 34909, 34910 }
			}
		}, {
			info = {
				row = 7,
				icon = 135737,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Focused Will",
				talentRankSpellIds = { 45234, 45243, 45244 }
			}
		}, {
			info = {
				row = 7,
				icon = 135939,
				ranks = 1,
				wowTreeIndex = 2,
				column = 2,
				name = "Power Infusion",
				talentRankSpellIds = { 10060 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135886,
				ranks = 3,
				wowTreeIndex = 18,
				column = 3,
				name = "Improved Flash Heal",
				talentRankSpellIds = { 63504, 63505, 63506 }
			}
		}, {
			info = {
				row = 8,
				icon = 135923,
				ranks = 2,
				wowTreeIndex = 27,
				column = 1,
				name = "Renewed Hope",
				talentRankSpellIds = { 57470, 57472 }
			}
		}, {
			info = {
				row = 8,
				icon = 237548,
				ranks = 3,
				wowTreeIndex = 23,
				column = 2,
				name = "Rapture",
				talentRankSpellIds = { 47535, 47536, 47537 }
			}
		}, {
			info = {
				row = 8,
				icon = 237537,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Aspiration",
				talentRankSpellIds = { 47507, 47508 }
			}
		}, {
			info = {
				row = 9,
				icon = 237539,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Divine Aegis",
				talentRankSpellIds = { 47509, 47511, 47515 }
			}
		}, {
			info = {
				row = 9,
				icon = 135936,
				ranks = 1,
				wowTreeIndex = 19,
				column = 2,
				name = "Pain Suppression",
				talentRankSpellIds = { 33206 }
			}
		}, {
			info = {
				row = 9,
				icon = 237543,
				ranks = 2,
				wowTreeIndex = 26,
				column = 3,
				name = "Grace",
				talentRankSpellIds = { 47516, 47517 }
			}
		}, {
			info = {
				row = 10,
				icon = 237538,
				ranks = 5,
				wowTreeIndex = 14,
				column = 2,
				name = "Borrowed Time",
				talentRankSpellIds = { 52795, 52797, 52798, 52799, 52800 }
			}
		}, {
			info = {
				row = 11,
				icon = 237545,
				ranks = 1,
				wowTreeIndex = 24,
				column = 2,
				name = "Penance",
				talentRankSpellIds = { 47540 }
			}
		} },
		info = {
			name = "Discipline",
			background = "PriestDiscipline"
		}
	}, -- [1]
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 135918,
				ranks = 2,
				wowTreeIndex = 8,
				column = 1,
				name = "Healing Focus",
				talentRankSpellIds = { 14913, 15012 }
			}
		}, {
			info = {
				row = 1,
				icon = 135953,
				ranks = 3,
				wowTreeIndex = 6,
				column = 2,
				name = "Improved Renew",
				talentRankSpellIds = { 14908, 15020, 17191 }
			}
		}, {
			info = {
				row = 1,
				icon = 135967,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Holy Specialization",
				talentRankSpellIds = { 14889, 15008, 15009, 15010, 15011 }
			}
		}, {
			info = {
				row = 2,
				icon = 135976,
				ranks = 5,
				wowTreeIndex = 9,
				column = 2,
				name = "Spell Warding",
				talentRankSpellIds = { 27900, 27901, 27902, 27903, 27904 }
			}
		}, {
			info = {
				row = 2,
				icon = 135971,
				ranks = 5,
				wowTreeIndex = 12,
				column = 3,
				name = "Divine Fury",
				talentRankSpellIds = { 18530, 18531, 18533, 18534, 18535 }
			}
		}, {
			info = {
				row = 3,
				icon = 135954,
				ranks = 1,
				wowTreeIndex = 11,
				column = 1,
				name = "Desperate Prayer",
				talentRankSpellIds = { 19236 }
			}
		}, {
			info = {
				row = 3,
				icon = 135877,
				ranks = 3,
				wowTreeIndex = 15,
				column = 2,
				name = "Blessed Recovery",
				talentRankSpellIds = { 27811, 27815, 27816 }
			}
		}, {
			info = {
				row = 3,
				icon = 135928,
				ranks = 3,
				wowTreeIndex = 1,
				column = 4,
				name = "Inspiration",
				talentRankSpellIds = { 14892, 15362, 15363 }
			}
		}, {
			info = {
				row = 4,
				icon = 135949,
				ranks = 2,
				wowTreeIndex = 14,
				column = 1,
				name = "Holy Reach",
				talentRankSpellIds = { 27789, 27790 }
			}
		}, {
			info = {
				row = 4,
				icon = 135916,
				ranks = 3,
				wowTreeIndex = 7,
				column = 2,
				name = "Improved Healing",
				talentRankSpellIds = { 14912, 15013, 15014 }
			}
		}, {
			info = {
				row = 4,
				icon = 135973,
				ranks = 2,
				wowTreeIndex = 4,
				column = 3,
				name = "Searing Light",
				talentRankSpellIds = { 14909, 15017 },
				prereqs = { {
					column = 3,
					row = 2,
					source = 5
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 135943,
				ranks = 2,
				wowTreeIndex = 10,
				column = 1,
				name = "Healing Prayers",
				talentRankSpellIds = { 14911, 15018 }
			}
		}, {
			info = {
				row = 5,
				icon = 132864,
				ranks = 1,
				wowTreeIndex = 13,
				column = 2,
				name = "Spirit of Redemption",
				talentRankSpellIds = { 20711 }
			}
		}, {
			info = {
				row = 5,
				icon = 135977,
				ranks = 5,
				wowTreeIndex = 3,
				column = 3,
				name = "Spiritual Guidance",
				talentRankSpellIds = { 14901, 15028, 15029, 15030, 15031 }
			}
		}, {
			info = {
				row = 6,
				icon = 135981,
				ranks = 2,
				wowTreeIndex = 18,
				column = 1,
				name = "Surge of Light",
				talentRankSpellIds = { 33150, 33154 }
			}
		}, {
			info = {
				row = 6,
				icon = 136057,
				ranks = 5,
				wowTreeIndex = 5,
				column = 3,
				name = "Spiritual Healing",
				talentRankSpellIds = { 14898, 15349, 15354, 15355, 15356 }
			}
		}, {
			info = {
				row = 7,
				icon = 135905,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Holy Concentration",
				talentRankSpellIds = { 34753, 34859, 34860 }
			}
		}, {
			info = {
				row = 7,
				icon = 135980,
				ranks = 1,
				wowTreeIndex = 16,
				column = 2,
				name = "Lightwell",
				talentRankSpellIds = { 724 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 135878,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Blessed Resilience",
				talentRankSpellIds = { 33142, 33145, 33146 }
			}
		}, {
			info = {
				row = 8,
				icon = 135982,
				ranks = 2,
				wowTreeIndex = 27,
				column = 1,
				name = "Body and Soul",
				talentRankSpellIds = { 64127, 64129 }
			}
		}, {
			info = {
				row = 8,
				icon = 135913,
				ranks = 5,
				wowTreeIndex = 19,
				column = 2,
				name = "Empowered Healing",
				talentRankSpellIds = { 33158, 33159, 33160, 33161, 33162 }
			}
		}, {
			info = {
				row = 8,
				icon = 237549,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Serendipity",
				talentRankSpellIds = { 63730, 63733, 63737 }
			}
		}, {
			info = {
				row = 9,
				icon = 236254,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Empowered Renew",
				talentRankSpellIds = { 63534, 63542, 63543 }
			}
		}, {
			info = {
				row = 9,
				icon = 135887,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Circle of Healing",
				talentRankSpellIds = { 34861 }
			}
		}, {
			info = {
				row = 9,
				icon = 237550,
				ranks = 3,
				wowTreeIndex = 23,
				column = 3,
				name = "Test of Faith",
				talentRankSpellIds = { 47558, 47559, 47560 }
			}
		}, {
			info = {
				row = 10,
				icon = 237541,
				ranks = 5,
				wowTreeIndex = 25,
				column = 2,
				name = "Divine Providence",
				talentRankSpellIds = { 47562, 47564, 47565, 47566, 47567 }
			}
		}, {
			info = {
				row = 11,
				icon = 237542,
				ranks = 1,
				wowTreeIndex = 26,
				column = 2,
				name = "Guardian Spirit",
				talentRankSpellIds = { 47788 }
			}
		} },
		info = {
			name = "Holy",
			background = "PriestHoly"
		}
	}, -- [2]
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 136188,
				ranks = 3,
				wowTreeIndex = 4,
				column = 1,
				name = "Spirit Tap",
				talentRankSpellIds = { 15270, 15335, 15336 }
			}
		}, {
			info = {
				row = 1,
				icon = 136188,
				ranks = 2,
				wowTreeIndex = 26,
				column = 2,
				name = "Improved Spirit Tap",
				talentRankSpellIds = { 15337, 15338 },
				prereqs = { {
					column = 1,
					row = 1,
					source = 1
				} }
			}
		}, {
			info = {
				row = 1,
				icon = 136223,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Darkness",
				talentRankSpellIds = { 15259, 15307, 15308, 15309, 15310 }
			}
		}, {
			info = {
				row = 2,
				icon = 136205,
				ranks = 3,
				wowTreeIndex = 5,
				column = 1,
				name = "Shadow Affinity",
				talentRankSpellIds = { 15318, 15272, 15320 }
			}
		}, {
			info = {
				row = 2,
				icon = 136207,
				ranks = 2,
				wowTreeIndex = 7,
				column = 2,
				name = "Improved Shadow Word: Pain",
				talentRankSpellIds = { 15275, 15317 }
			}
		}, {
			info = {
				row = 2,
				icon = 136126,
				ranks = 3,
				wowTreeIndex = 3,
				column = 3,
				name = "Shadow Focus",
				talentRankSpellIds = { 15260, 15327, 15328 }
			}
		}, {
			info = {
				row = 3,
				icon = 136184,
				ranks = 2,
				wowTreeIndex = 13,
				column = 1,
				name = "Improved Psychic Scream",
				talentRankSpellIds = { 15392, 15448 }
			}
		}, {
			info = {
				row = 3,
				icon = 136224,
				ranks = 5,
				wowTreeIndex = 6,
				column = 2,
				name = "Improved Mind Blast",
				talentRankSpellIds = { 15273, 15312, 15313, 15314, 15316 }
			}
		}, {
			info = {
				row = 3,
				icon = 136208,
				ranks = 1,
				wowTreeIndex = 10,
				column = 3,
				name = "Mind Flay",
				talentRankSpellIds = { 15407 }
			}
		}, {
			info = {
				row = 4,
				icon = 135994,
				ranks = 2,
				wowTreeIndex = 8,
				column = 2,
				name = "Veiled Shadows",
				talentRankSpellIds = { 15274, 15311 }
			}
		}, {
			info = {
				row = 4,
				icon = 136130,
				ranks = 2,
				wowTreeIndex = 14,
				column = 3,
				name = "Shadow Reach",
				talentRankSpellIds = { 17322, 17323 }
			}
		}, {
			info = {
				row = 4,
				icon = 136123,
				ranks = 3,
				wowTreeIndex = 1,
				column = 4,
				name = "Shadow Weaving",
				talentRankSpellIds = { 15257, 15331, 15332 }
			}
		}, {
			info = {
				row = 5,
				icon = 136164,
				ranks = 1,
				wowTreeIndex = 12,
				column = 1,
				name = "Silence",
				talentRankSpellIds = { 15487 },
				prereqs = { {
					column = 1,
					row = 3,
					source = 7
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 136230,
				ranks = 1,
				wowTreeIndex = 9,
				column = 2,
				name = "Vampiric Embrace",
				talentRankSpellIds = { 15286 }
			}
		}, {
			info = {
				row = 5,
				icon = 136165,
				ranks = 2,
				wowTreeIndex = 15,
				column = 3,
				name = "Improved Vampiric Embrace",
				talentRankSpellIds = { 27839, 27840 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 136035,
				ranks = 3,
				wowTreeIndex = 16,
				column = 4,
				name = "Focused Mind",
				talentRankSpellIds = { 33213, 33214, 33215 }
			}
		}, {
			info = {
				row = 6,
				icon = 237569,
				ranks = 2,
				wowTreeIndex = 19,
				column = 1,
				name = "Mind Melt",
				talentRankSpellIds = { 14910, 33371 }
			}
		}, {
			info = {
				row = 6,
				icon = 252996,
				ranks = 3,
				wowTreeIndex = 27,
				column = 3,
				name = "Improved Devouring Plague",
				talentRankSpellIds = { 63625, 63626, 63627 }
			}
		}, {
			info = {
				row = 7,
				icon = 136200,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Shadowform",
				talentRankSpellIds = { 15473 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136204,
				ranks = 5,
				wowTreeIndex = 17,
				column = 3,
				name = "Shadow Power",
				talentRankSpellIds = { 33221, 33222, 33223, 33224, 33225 }
			}
		}, {
			info = {
				row = 8,
				icon = 136221,
				ranks = 2,
				wowTreeIndex = 21,
				column = 1,
				name = "Improved Shadowform",
				talentRankSpellIds = { 47569, 47570 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 136176,
				ranks = 3,
				wowTreeIndex = 20,
				column = 3,
				name = "Misery",
				talentRankSpellIds = { 33191, 33192, 33193 }
			}
		}, {
			info = {
				row = 9,
				icon = 237568,
				ranks = 1,
				wowTreeIndex = 23,
				column = 1,
				name = "Psychic Horror",
				talentRankSpellIds = { 64044 }
			}
		}, {
			info = {
				row = 9,
				icon = 135978,
				ranks = 1,
				wowTreeIndex = 18,
				column = 2,
				name = "Vampiric Touch",
				talentRankSpellIds = { 34914 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 237567,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Pain and Suffering",
				talentRankSpellIds = { 47580, 47581, 47582 }
			}
		}, {
			info = {
				row = 10,
				icon = 237566,
				ranks = 5,
				wowTreeIndex = 22,
				column = 3,
				name = "Twisted Faith",
				talentRankSpellIds = { 47573, 47577, 47578, 51166, 51167 }
			}
		}, {
			info = {
				row = 11,
				icon = 237563,
				ranks = 1,
				wowTreeIndex = 25,
				column = 2,
				name = "Dispersion",
				talentRankSpellIds = { 47585 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 24
				} }
			}
		} },
		info = {
			name = "Shadow",
			background = "PriestShadow"
		}
	}, -- [3]
}

talents.rogue = {
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 132292,
				ranks = 3,
				wowTreeIndex = 7,
				column = 1,
				name = "Improved Eviscerate",
				talentRankSpellIds = { 14162, 14163, 14164 }
			}
		}, {
			info = {
				row = 1,
				icon = 132151,
				ranks = 2,
				wowTreeIndex = 4,
				column = 2,
				name = "Remorseless Attacks",
				talentRankSpellIds = { 14144, 14148 }
			}
		}, {
			info = {
				row = 1,
				icon = 132277,
				ranks = 5,
				wowTreeIndex = 3,
				column = 3,
				name = "Malice",
				talentRankSpellIds = { 14138, 14139, 14140, 14141, 14142 }
			}
		}, {
			info = {
				row = 2,
				icon = 132122,
				ranks = 3,
				wowTreeIndex = 5,
				column = 1,
				name = "Ruthlessness",
				talentRankSpellIds = { 14156, 14160, 14161 }
			}
		}, {
			info = {
				row = 2,
				icon = 236268,
				ranks = 2,
				wowTreeIndex = 24,
				column = 2,
				name = "Blood Spatter",
				talentRankSpellIds = { 51632, 51633 }
			}
		}, {
			info = {
				row = 2,
				icon = 132090,
				ranks = 3,
				wowTreeIndex = 8,
				column = 4,
				name = "Puncturing Wounds",
				talentRankSpellIds = { 13733, 13865, 13866 }
			}
		}, {
			info = {
				row = 3,
				icon = 136023,
				ranks = 1,
				wowTreeIndex = 14,
				column = 1,
				name = "Vigor",
				talentRankSpellIds = { 14983 }
			}
		}, {
			info = {
				row = 3,
				icon = 132354,
				ranks = 2,
				wowTreeIndex = 9,
				column = 2,
				name = "Improved Expose Armor",
				talentRankSpellIds = { 14168, 14169 }
			}
		}, {
			info = {
				row = 3,
				icon = 132109,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Lethality",
				talentRankSpellIds = { 14128, 14132, 14135, 14136, 14137 },
				prereqs = { {
					column = 3,
					row = 1,
					source = 3
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 132293,
				ranks = 3,
				wowTreeIndex = 15,
				column = 2,
				name = "Vile Poisons",
				talentRankSpellIds = { 16513, 16514, 16515 }
			}
		}, {
			info = {
				row = 4,
				icon = 132273,
				ranks = 5,
				wowTreeIndex = 1,
				column = 3,
				name = "Improved Poisons",
				talentRankSpellIds = { 14113, 14114, 14115, 14116, 14117 }
			}
		}, {
			info = {
				row = 5,
				icon = 132296,
				ranks = 2,
				wowTreeIndex = 19,
				column = 1,
				name = "Fleet Footed",
				talentRankSpellIds = { 31208, 31209 }
			}
		}, {
			info = {
				row = 5,
				icon = 135988,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Cold Blood",
				talentRankSpellIds = { 14177 }
			}
		}, {
			info = {
				row = 5,
				icon = 132298,
				ranks = 3,
				wowTreeIndex = 10,
				column = 3,
				name = "Improved Kidney Shot",
				talentRankSpellIds = { 14174, 14175, 14176 }
			}
		}, {
			info = {
				row = 5,
				icon = 132301,
				ranks = 2,
				wowTreeIndex = 21,
				column = 4,
				name = "Quick Recovery",
				talentRankSpellIds = { 31244, 31245 }
			}
		}, {
			info = {
				row = 6,
				icon = 136130,
				ranks = 5,
				wowTreeIndex = 13,
				column = 2,
				name = "Seal Fate",
				talentRankSpellIds = { 14186, 14190, 14193, 14194, 14195 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 136147,
				ranks = 2,
				wowTreeIndex = 6,
				column = 3,
				name = "Murder",
				talentRankSpellIds = { 14158, 14159 }
			}
		}, {
			info = {
				row = 7,
				icon = 236270,
				ranks = 2,
				wowTreeIndex = 22,
				column = 1,
				name = "Deadly Brew",
				talentRankSpellIds = { 51625, 51626 }
			}
		}, {
			info = {
				row = 7,
				icon = 132205,
				ranks = 1,
				wowTreeIndex = 12,
				column = 2,
				name = "Overkill",
				talentRankSpellIds = { 58426 }
			}
		}, {
			info = {
				row = 7,
				icon = 132286,
				ranks = 3,
				wowTreeIndex = 20,
				column = 3,
				name = "Deadened Nerves",
				talentRankSpellIds = { 31380, 31382, 31383 }
			}
		}, {
			info = {
				row = 8,
				icon = 236274,
				ranks = 3,
				wowTreeIndex = 25,
				column = 1,
				name = "Focused Attacks",
				talentRankSpellIds = { 51634, 51635, 51636 }
			}
		}, {
			info = {
				row = 8,
				icon = 132295,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Find Weakness",
				talentRankSpellIds = { 31234, 31235, 31236 }
			}
		}, {
			info = {
				row = 9,
				icon = 132108,
				ranks = 3,
				wowTreeIndex = 16,
				column = 1,
				name = "Master Poisoner",
				talentRankSpellIds = { 31226, 31227, 58410 }
			}
		}, {
			info = {
				row = 9,
				icon = 132304,
				ranks = 1,
				wowTreeIndex = 18,
				column = 2,
				name = "Mutilate",
				talentRankSpellIds = { 1329 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 19
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236284,
				ranks = 3,
				wowTreeIndex = 23,
				column = 3,
				name = "Turn the Tables",
				talentRankSpellIds = { 51627, 51628, 51629 }
			}
		}, {
			info = {
				row = 10,
				icon = 236269,
				ranks = 5,
				wowTreeIndex = 26,
				column = 2,
				name = "Cut to the Chase",
				talentRankSpellIds = { 51664, 51665, 51667, 51668, 51669 }
			}
		}, {
			info = {
				row = 11,
				icon = 236276,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Hunger For Blood",
				talentRankSpellIds = { 51662 }
			}
		} },
		info = {
			name = "Assassination",
			background = "RogueAssassination"
		}
	}, -- [1]
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 132155,
				ranks = 3,
				wowTreeIndex = 7,
				column = 1,
				name = "Improved Gouge",
				talentRankSpellIds = { 13741, 13793, 13792 }
			}
		}, {
			info = {
				row = 1,
				icon = 136189,
				ranks = 2,
				wowTreeIndex = 6,
				column = 2,
				name = "Improved Sinister Strike",
				talentRankSpellIds = { 13732, 13863 }
			}
		}, {
			info = {
				row = 1,
				icon = 132147,
				ranks = 5,
				wowTreeIndex = 11,
				column = 3,
				name = "Dual Wield Specialization",
				talentRankSpellIds = { 13715, 13848, 13849, 13851, 13852 }
			}
		}, {
			info = {
				row = 2,
				icon = 132306,
				ranks = 2,
				wowTreeIndex = 23,
				column = 1,
				name = "Improved Slice and Dice",
				talentRankSpellIds = { 14165, 14166 }
			}
		}, {
			info = {
				row = 2,
				icon = 132269,
				ranks = 3,
				wowTreeIndex = 5,
				column = 2,
				name = "Deflection",
				talentRankSpellIds = { 13713, 13853, 13854 }
			}
		}, {
			info = {
				row = 2,
				icon = 132222,
				ranks = 5,
				wowTreeIndex = 1,
				column = 4,
				name = "Precision",
				talentRankSpellIds = { 13705, 13832, 13843, 13844, 13845 }
			}
		}, {
			info = {
				row = 3,
				icon = 136205,
				ranks = 2,
				wowTreeIndex = 8,
				column = 1,
				name = "Endurance",
				talentRankSpellIds = { 13742, 13872 }
			}
		}, {
			info = {
				row = 3,
				icon = 132336,
				ranks = 1,
				wowTreeIndex = 15,
				column = 2,
				name = "Riposte",
				talentRankSpellIds = { 14251 },
				prereqs = { {
					column = 2,
					row = 2,
					source = 5
				} }
			}
		}, {
			info = {
				row = 3,
				icon = 135641,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Close Quarters Combat",
				talentRankSpellIds = { 13706, 13804, 13805, 13806, 13807 },
				prereqs = { {
					column = 3,
					row = 1,
					source = 3
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 132219,
				ranks = 2,
				wowTreeIndex = 10,
				column = 1,
				name = "Improved Kick",
				talentRankSpellIds = { 13754, 13867 }
			}
		}, {
			info = {
				row = 4,
				icon = 132307,
				ranks = 2,
				wowTreeIndex = 12,
				column = 2,
				name = "Improved Sprint",
				talentRankSpellIds = { 13743, 13875 }
			}
		}, {
			info = {
				row = 4,
				icon = 136047,
				ranks = 3,
				wowTreeIndex = 4,
				column = 3,
				name = "Lightning Reflexes",
				talentRankSpellIds = { 13712, 13788, 13789 }
			}
		}, {
			info = {
				row = 4,
				icon = 132275,
				ranks = 5,
				wowTreeIndex = 16,
				column = 4,
				name = "Aggression",
				talentRankSpellIds = { 18427, 18428, 18429, 61330, 61331 }
			}
		}, {
			info = {
				row = 5,
				icon = 133476,
				ranks = 5,
				wowTreeIndex = 3,
				column = 1,
				name = "Mace Specialization",
				talentRankSpellIds = { 13709, 13800, 13801, 13802, 13803 }
			}
		}, {
			info = {
				row = 5,
				icon = 132350,
				ranks = 1,
				wowTreeIndex = 13,
				column = 2,
				name = "Blade Flurry",
				talentRankSpellIds = { 13877 }
			}
		}, {
			info = {
				row = 5,
				icon = 135328,
				ranks = 5,
				wowTreeIndex = 14,
				column = 3,
				name = "Hack and Slash",
				talentRankSpellIds = { 13960, 13961, 13962, 13963, 13964 }
			}
		}, {
			info = {
				row = 6,
				icon = 135882,
				ranks = 2,
				wowTreeIndex = 17,
				column = 2,
				name = "Weapon Expertise",
				talentRankSpellIds = { 30919, 30920 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 15
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 132283,
				ranks = 2,
				wowTreeIndex = 19,
				column = 3,
				name = "Blade Twisting",
				talentRankSpellIds = { 31124, 31126 }
			}
		}, {
			info = {
				row = 7,
				icon = 132353,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Vitality",
				talentRankSpellIds = { 31122, 31123, 61329 }
			}
		}, {
			info = {
				row = 7,
				icon = 136206,
				ranks = 1,
				wowTreeIndex = 9,
				column = 2,
				name = "Adrenaline Rush",
				talentRankSpellIds = { 13750 }
			}
		}, {
			info = {
				row = 7,
				icon = 132300,
				ranks = 2,
				wowTreeIndex = 20,
				column = 3,
				name = "Nerves of Steel",
				talentRankSpellIds = { 31130, 31131 }
			}
		}, {
			info = {
				row = 8,
				icon = 236282,
				ranks = 2,
				wowTreeIndex = 24,
				column = 1,
				name = "Throwing Specialization",
				talentRankSpellIds = { 5952, 51679 }
			}
		}, {
			info = {
				row = 8,
				icon = 135673,
				ranks = 5,
				wowTreeIndex = 22,
				column = 3,
				name = "Combat Potency",
				talentRankSpellIds = { 35541, 35550, 35551, 35552, 35553 }
			}
		}, {
			info = {
				row = 9,
				icon = 236285,
				ranks = 2,
				wowTreeIndex = 25,
				column = 1,
				name = "Unfair Advantage",
				talentRankSpellIds = { 51672, 51674 }
			}
		}, {
			info = {
				row = 9,
				icon = 132308,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Surprise Attacks",
				talentRankSpellIds = { 32601 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 132100,
				ranks = 2,
				wowTreeIndex = 26,
				column = 3,
				name = "Savage Combat",
				talentRankSpellIds = { 51682, 58413 }
			}
		}, {
			info = {
				row = 10,
				icon = 236278,
				ranks = 5,
				wowTreeIndex = 27,
				column = 2,
				name = "Prey on the Weak",
				talentRankSpellIds = { 51685, 51686, 51687, 51688, 51689 }
			}
		}, {
			info = {
				row = 11,
				icon = 236277,
				ranks = 1,
				wowTreeIndex = 28,
				column = 2,
				name = "Killing Spree",
				talentRankSpellIds = { 51690 }
			}
		} },
		info = {
			name = "Combat",
			background = "RogueCombat"
		}
	}, -- [2]
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 132340,
				ranks = 5,
				wowTreeIndex = 28,
				column = 1,
				name = "Relentless Strikes",
				talentRankSpellIds = { 14179, 58422, 58423, 58424, 58425 }
			}
		}, {
			info = {
				row = 1,
				icon = 136129,
				ranks = 3,
				wowTreeIndex = 1,
				column = 2,
				name = "Master of Deception",
				talentRankSpellIds = { 13958, 13970, 13971 }
			}
		}, {
			info = {
				row = 1,
				icon = 132366,
				ranks = 2,
				wowTreeIndex = 6,
				column = 3,
				name = "Opportunity",
				talentRankSpellIds = { 14057, 14072 }
			}
		}, {
			info = {
				row = 2,
				icon = 132294,
				ranks = 2,
				wowTreeIndex = 15,
				column = 1,
				name = "Sleight of Hand",
				talentRankSpellIds = { 30892, 30893 }
			}
		}, {
			info = {
				row = 2,
				icon = 132310,
				ranks = 2,
				wowTreeIndex = 7,
				column = 2,
				name = "Dirty Tricks",
				talentRankSpellIds = { 14076, 14094 }
			}
		}, {
			info = {
				row = 2,
				icon = 132320,
				ranks = 3,
				wowTreeIndex = 2,
				column = 3,
				name = "Camouflage",
				talentRankSpellIds = { 13975, 14062, 14063 }
			}
		}, {
			info = {
				row = 3,
				icon = 135994,
				ranks = 2,
				wowTreeIndex = 5,
				column = 1,
				name = "Elusiveness",
				talentRankSpellIds = { 13981, 14066 }
			}
		}, {
			info = {
				row = 3,
				icon = 136136,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Ghostly Strike",
				talentRankSpellIds = { 14278 }
			}
		}, {
			info = {
				row = 3,
				icon = 135315,
				ranks = 3,
				wowTreeIndex = 14,
				column = 3,
				name = "Serrated Blades",
				talentRankSpellIds = { 14171, 14172, 14173 }
			}
		}, {
			info = {
				row = 4,
				icon = 136056,
				ranks = 3,
				wowTreeIndex = 4,
				column = 1,
				name = "Setup",
				talentRankSpellIds = { 13983, 14070, 14071 }
			}
		}, {
			info = {
				row = 4,
				icon = 136159,
				ranks = 3,
				wowTreeIndex = 3,
				column = 2,
				name = "Initiative",
				talentRankSpellIds = { 13976, 13979, 13980 }
			}
		}, {
			info = {
				row = 4,
				icon = 132282,
				ranks = 2,
				wowTreeIndex = 8,
				column = 3,
				name = "Improved Ambush",
				talentRankSpellIds = { 14079, 14080 }
			}
		}, {
			info = {
				row = 5,
				icon = 132089,
				ranks = 2,
				wowTreeIndex = 16,
				column = 1,
				name = "Heightened Senses",
				talentRankSpellIds = { 30894, 30895 }
			}
		}, {
			info = {
				row = 5,
				icon = 136121,
				ranks = 1,
				wowTreeIndex = 10,
				column = 2,
				name = "Preparation",
				talentRankSpellIds = { 14185 }
			}
		}, {
			info = {
				row = 5,
				icon = 136220,
				ranks = 2,
				wowTreeIndex = 9,
				column = 3,
				name = "Dirty Deeds",
				talentRankSpellIds = { 14082, 14083 }
			}
		}, {
			info = {
				row = 5,
				icon = 136168,
				ranks = 1,
				wowTreeIndex = 13,
				column = 4,
				name = "Hemorrhage",
				talentRankSpellIds = { 16511 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 9
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 132299,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Master of Subtlety",
				talentRankSpellIds = { 31221, 31222, 31223 }
			}
		}, {
			info = {
				row = 6,
				icon = 135540,
				ranks = 5,
				wowTreeIndex = 17,
				column = 3,
				name = "Deadliness",
				talentRankSpellIds = { 30902, 30903, 30904, 30905, 30906 }
			}
		}, {
			info = {
				row = 7,
				icon = 132291,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Enveloping Shadows",
				talentRankSpellIds = { 31211, 31212, 31213 }
			}
		}, {
			info = {
				row = 7,
				icon = 136183,
				ranks = 1,
				wowTreeIndex = 12,
				column = 2,
				name = "Premeditation",
				talentRankSpellIds = { 14183 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132285,
				ranks = 3,
				wowTreeIndex = 22,
				column = 3,
				name = "Cheat Death",
				talentRankSpellIds = { 31228, 31229, 31230 }
			}
		}, {
			info = {
				row = 8,
				icon = 132305,
				ranks = 5,
				wowTreeIndex = 19,
				column = 2,
				name = "Sinister Calling",
				talentRankSpellIds = { 31216, 31217, 31218, 31219, 31220 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 236286,
				ranks = 2,
				wowTreeIndex = 23,
				column = 3,
				name = "Waylay",
				talentRankSpellIds = { 51692, 51696 }
			}
		}, {
			info = {
				row = 9,
				icon = 236275,
				ranks = 3,
				wowTreeIndex = 24,
				column = 1,
				name = "Honor Among Thieves",
				talentRankSpellIds = { 51698, 51700, 51701 }
			}
		}, {
			info = {
				row = 9,
				icon = 132303,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Shadowstep",
				talentRankSpellIds = { 36554 }
			}
		}, {
			info = {
				row = 9,
				icon = 236287,
				ranks = 2,
				wowTreeIndex = 25,
				column = 3,
				name = "Filthy Tricks",
				talentRankSpellIds = { 58414, 58415 }
			}
		}, {
			info = {
				row = 10,
				icon = 236280,
				ranks = 5,
				wowTreeIndex = 26,
				column = 2,
				name = "Slaughter from the Shadows",
				talentRankSpellIds = { 51708, 51709, 51710, 51711, 51712 }
			}
		}, {
			info = {
				row = 11,
				icon = 236279,
				ranks = 1,
				wowTreeIndex = 27,
				column = 2,
				name = "Shadow Dance",
				talentRankSpellIds = { 51713 }
			}
		} },
		info = {
			name = "Subtlety",
			background = "RogueSubtlety"
		}
	}, -- [3]
}

talents.shaman = {
	{
		numtalents = 25,
		talents = { {
			info = {
				row = 1,
				icon = 136116,
				ranks = 5,
				wowTreeIndex = 4,
				column = 2,
				name = "Convection",
				talentRankSpellIds = { 16039, 16109, 16110, 16111, 16112 }
			}
		}, {
			info = {
				row = 1,
				icon = 135807,
				ranks = 5,
				wowTreeIndex = 3,
				column = 3,
				name = "Concussion",
				talentRankSpellIds = { 16035, 16105, 16106, 16107, 16108 }
			}
		}, {
			info = {
				row = 2,
				icon = 135817,
				ranks = 3,
				wowTreeIndex = 1,
				column = 1,
				name = "Call of Flame",
				talentRankSpellIds = { 16038, 16160, 16161 }
			}
		}, {
			info = {
				row = 2,
				icon = 136094,
				ranks = 3,
				wowTreeIndex = 11,
				column = 2,
				name = "Elemental Warding",
				talentRankSpellIds = { 28996, 28997, 28998 }
			}
		}, {
			info = {
				row = 2,
				icon = 135791,
				ranks = 3,
				wowTreeIndex = 14,
				column = 3,
				name = "Elemental Devastation",
				talentRankSpellIds = { 30160, 29179, 29180 }
			}
		}, {
			info = {
				row = 3,
				icon = 135850,
				ranks = 5,
				wowTreeIndex = 9,
				column = 1,
				name = "Reverberation",
				talentRankSpellIds = { 16040, 16113, 16114, 16115, 16116 }
			}
		}, {
			info = {
				row = 3,
				icon = 136170,
				ranks = 1,
				wowTreeIndex = 8,
				column = 2,
				name = "Elemental Focus",
				talentRankSpellIds = { 16164 }
			}
		}, {
			info = {
				row = 3,
				icon = 135830,
				ranks = 5,
				wowTreeIndex = 5,
				column = 3,
				name = "Elemental Fury",
				talentRankSpellIds = { 16089, 60184, 60185, 60187, 60188 }
			}
		}, {
			info = {
				row = 4,
				icon = 135824,
				ranks = 2,
				wowTreeIndex = 6,
				column = 1,
				name = "Improved Fire Nova",
				talentRankSpellIds = { 16086, 16544 }
			}
		}, {
			info = {
				row = 4,
				icon = 136213,
				ranks = 3,
				wowTreeIndex = 13,
				column = 4,
				name = "Eye of the Storm",
				talentRankSpellIds = { 29062, 29064, 29065 }
			}
		}, {
			info = {
				row = 5,
				icon = 136099,
				ranks = 2,
				wowTreeIndex = 12,
				column = 1,
				name = "Elemental Reach",
				talentRankSpellIds = { 28999, 29000 }
			}
		}, {
			info = {
				row = 5,
				icon = 136014,
				ranks = 1,
				wowTreeIndex = 2,
				column = 2,
				name = "Call of Thunder",
				talentRankSpellIds = { 16041 },
				prereqs = { {
					column = 2,
					row = 3,
					source = 7
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 136111,
				ranks = 3,
				wowTreeIndex = 15,
				column = 4,
				name = "Unrelenting Storm",
				talentRankSpellIds = { 30664, 30665, 30666 }
			}
		}, {
			info = {
				row = 6,
				icon = 136028,
				ranks = 3,
				wowTreeIndex = 16,
				column = 1,
				name = "Elemental Precision",
				talentRankSpellIds = { 30672, 30673, 30674 }
			}
		}, {
			info = {
				row = 6,
				icon = 135990,
				ranks = 5,
				wowTreeIndex = 10,
				column = 3,
				name = "Lightning Mastery",
				talentRankSpellIds = { 16578, 16579, 16580, 16581, 16582 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 8
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136115,
				ranks = 1,
				wowTreeIndex = 7,
				column = 2,
				name = "Elemental Mastery",
				talentRankSpellIds = { 16166 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 12
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 237588,
				ranks = 3,
				wowTreeIndex = 22,
				column = 3,
				name = "Storm, Earth and Fire",
				talentRankSpellIds = { 51483, 51485, 51486 }
			}
		}, {
			info = {
				row = 8,
				icon = 135782,
				ranks = 2,
				wowTreeIndex = 25,
				column = 1,
				name = "Booming Echoes",
				talentRankSpellIds = { 63370, 63372 }
			}
		}, {
			info = {
				row = 8,
				icon = 237576,
				ranks = 2,
				wowTreeIndex = 19,
				column = 2,
				name = "Elemental Oath",
				talentRankSpellIds = { 51466, 51470 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 16
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 136050,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Lightning Overload",
				talentRankSpellIds = { 30675, 30678, 30679 }
			}
		}, {
			info = {
				row = 9,
				icon = 237572,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Astral Shift",
				talentRankSpellIds = { 51474, 51478, 51479 }
			}
		}, {
			info = {
				row = 9,
				icon = 135829,
				ranks = 1,
				wowTreeIndex = 18,
				column = 2,
				name = "Totem of Wrath",
				talentRankSpellIds = { 30706 }
			}
		}, {
			info = {
				row = 9,
				icon = 237583,
				ranks = 3,
				wowTreeIndex = 21,
				column = 3,
				name = "Lava Flows",
				talentRankSpellIds = { 51480, 51481, 51482 }
			}
		}, {
			info = {
				row = 10,
				icon = 136234,
				ranks = 5,
				wowTreeIndex = 24,
				column = 2,
				name = "Shamanism",
				talentRankSpellIds = { 62097, 62098, 62099, 62100, 62101 }
			}
		}, {
			info = {
				row = 11,
				icon = 237589,
				ranks = 1,
				wowTreeIndex = 23,
				column = 2,
				name = "Thunderstorm",
				talentRankSpellIds = { 51490 }
			}
		} },
		info = {
			name = "Elemental",
			background = "ShamanElementalCombat"
		}
	}, -- [1]
	{
		numtalents = 29,
		talents = { {
			info = {
				row = 1,
				icon = 136023,
				ranks = 3,
				wowTreeIndex = 6,
				column = 1,
				name = "Enhancing Totems",
				talentRankSpellIds = { 16259, 16295, 52456 }
			}
		}, {
			info = {
				row = 1,
				icon = 136097,
				ranks = 2,
				wowTreeIndex = 27,
				column = 2,
				name = "Earth's Grasp",
				talentRankSpellIds = { 16043, 16130 }
			}
		}, {
			info = {
				row = 1,
				icon = 136162,
				ranks = 5,
				wowTreeIndex = 9,
				column = 3,
				name = "Ancestral Knowledge",
				talentRankSpellIds = { 17485, 17486, 17487, 17488, 17489 }
			}
		}, {
			info = {
				row = 2,
				icon = 136098,
				ranks = 2,
				wowTreeIndex = 5,
				column = 1,
				name = "Guardian Totems",
				talentRankSpellIds = { 16258, 16293 }
			}
		}, {
			info = {
				row = 2,
				icon = 132325,
				ranks = 5,
				wowTreeIndex = 8,
				column = 2,
				name = "Thundering Strikes",
				talentRankSpellIds = { 16255, 16302, 16303, 16304, 16305 }
			}
		}, {
			info = {
				row = 2,
				icon = 136095,
				ranks = 2,
				wowTreeIndex = 3,
				column = 3,
				name = "Improved Ghost Wolf",
				talentRankSpellIds = { 16262, 16287 }
			}
		}, {
			info = {
				row = 2,
				icon = 136051,
				ranks = 3,
				wowTreeIndex = 4,
				column = 4,
				name = "Improved Shields",
				talentRankSpellIds = { 16261, 16290, 51881 }
			}
		}, {
			info = {
				row = 3,
				icon = 135814,
				ranks = 3,
				wowTreeIndex = 7,
				column = 1,
				name = "Elemental Weapons",
				talentRankSpellIds = { 16266, 29079, 29080 }
			}
		}, {
			info = {
				row = 3,
				icon = 136027,
				ranks = 1,
				wowTreeIndex = 12,
				column = 3,
				name = "Shamanistic Focus",
				talentRankSpellIds = { 43338 }
			}
		}, {
			info = {
				row = 3,
				icon = 136056,
				ranks = 3,
				wowTreeIndex = 1,
				column = 4,
				name = "Anticipation",
				talentRankSpellIds = { 16254, 16271, 16272 }
			}
		}, {
			info = {
				row = 4,
				icon = 132152,
				ranks = 5,
				wowTreeIndex = 2,
				column = 2,
				name = "Flurry",
				talentRankSpellIds = { 16256, 16281, 16282, 16283, 16284 },
				prereqs = { {
					column = 2,
					row = 2,
					source = 5
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 135892,
				ranks = 5,
				wowTreeIndex = 10,
				column = 3,
				name = "Toughness",
				talentRankSpellIds = { 16252, 16306, 16307, 16308, 16309 }
			}
		}, {
			info = {
				row = 5,
				icon = 136114,
				ranks = 2,
				wowTreeIndex = 15,
				column = 1,
				name = "Improved Windfury Totem",
				talentRankSpellIds = { 29192, 29193 }
			}
		}, {
			info = {
				row = 5,
				icon = 132269,
				ranks = 1,
				wowTreeIndex = 11,
				column = 2,
				name = "Spirit Weapons",
				talentRankSpellIds = { 16268 }
			}
		}, {
			info = {
				row = 5,
				icon = 136012,
				ranks = 3,
				wowTreeIndex = 26,
				column = 3,
				name = "Mental Dexterity",
				talentRankSpellIds = { 51883, 51884, 51885 }
			}
		}, {
			info = {
				row = 6,
				icon = 136110,
				ranks = 3,
				wowTreeIndex = 16,
				column = 1,
				name = "Unleashed Rage",
				talentRankSpellIds = { 30802, 30808, 30809 }
			}
		}, {
			info = {
				row = 6,
				icon = 132215,
				ranks = 3,
				wowTreeIndex = 14,
				column = 3,
				name = "Weapon Mastery",
				talentRankSpellIds = { 29082, 29084, 29086 }
			}
		}, {
			info = {
				row = 6,
				icon = 135776,
				ranks = 2,
				wowTreeIndex = 29,
				column = 4,
				name = "Frozen Power",
				talentRankSpellIds = { 63373, 63374 }
			}
		}, {
			info = {
				row = 7,
				icon = 132148,
				ranks = 3,
				wowTreeIndex = 19,
				column = 1,
				name = "Dual Wield Specialization",
				talentRankSpellIds = { 30816, 30818, 30819 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132147,
				ranks = 1,
				wowTreeIndex = 17,
				column = 2,
				name = "Dual Wield",
				talentRankSpellIds = { 30798 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 14
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 132314,
				ranks = 1,
				wowTreeIndex = 13,
				column = 3,
				name = "Stormstrike",
				talentRankSpellIds = { 17364 }
			}
		}, {
			info = {
				row = 8,
				icon = 237587,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Static Shock",
				talentRankSpellIds = { 51525, 51526, 51527 }
			}
		}, {
			info = {
				row = 8,
				icon = 236289,
				ranks = 1,
				wowTreeIndex = 28,
				column = 2,
				name = "Lava Lash",
				talentRankSpellIds = { 60103 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 237581,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Improved Stormstrike",
				talentRankSpellIds = { 51521, 51522 },
				prereqs = { {
					column = 3,
					row = 7,
					source = 21
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 136055,
				ranks = 3,
				wowTreeIndex = 18,
				column = 1,
				name = "Mental Quickness",
				talentRankSpellIds = { 30812, 30813, 30814 }
			}
		}, {
			info = {
				row = 9,
				icon = 136088,
				ranks = 1,
				wowTreeIndex = 20,
				column = 2,
				name = "Shamanistic Rage",
				talentRankSpellIds = { 30823 }
			}
		}, {
			info = {
				row = 9,
				icon = 136024,
				ranks = 2,
				wowTreeIndex = 23,
				column = 3,
				name = "Earthen Power",
				talentRankSpellIds = { 51523, 51524 }
			}
		}, {
			info = {
				row = 10,
				icon = 237584,
				ranks = 5,
				wowTreeIndex = 24,
				column = 2,
				name = "Maelstrom Weapon",
				talentRankSpellIds = { 51528, 51529, 51530, 51531, 51532 }
			}
		}, {
			info = {
				row = 11,
				icon = 237577,
				ranks = 1,
				wowTreeIndex = 25,
				column = 2,
				name = "Feral Spirit",
				talentRankSpellIds = { 51533 }
			}
		} },
		info = {
			name = "Enhancement",
			background = "ShamanEnhancement"
		}
	}, -- [2]
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 136052,
				ranks = 5,
				wowTreeIndex = 4,
				column = 2,
				name = "Improved Healing Wave",
				talentRankSpellIds = { 16182, 16226, 16227, 16228, 16229 }
			}
		}, {
			info = {
				row = 1,
				icon = 136057,
				ranks = 5,
				wowTreeIndex = 13,
				column = 3,
				name = "Totemic Focus",
				talentRankSpellIds = { 16173, 16222, 16223, 16224, 16225 }
			}
		}, {
			info = {
				row = 2,
				icon = 136080,
				ranks = 2,
				wowTreeIndex = 7,
				column = 1,
				name = "Improved Reincarnation",
				talentRankSpellIds = { 16184, 16209 }
			}
		}, {
			info = {
				row = 2,
				icon = 136041,
				ranks = 3,
				wowTreeIndex = 14,
				column = 2,
				name = "Healing Grace",
				talentRankSpellIds = { 29187, 29189, 29191 }
			}
		}, {
			info = {
				row = 2,
				icon = 135859,
				ranks = 5,
				wowTreeIndex = 11,
				column = 3,
				name = "Tidal Focus",
				talentRankSpellIds = { 16179, 16214, 16215, 16216, 16217 }
			}
		}, {
			info = {
				row = 3,
				icon = 132315,
				ranks = 3,
				wowTreeIndex = 3,
				column = 1,
				name = "Improved Water Shield",
				talentRankSpellIds = { 16180, 16196, 16198 }
			}
		}, {
			info = {
				row = 3,
				icon = 136043,
				ranks = 3,
				wowTreeIndex = 5,
				column = 2,
				name = "Healing Focus",
				talentRankSpellIds = { 16181, 16230, 16232 }
			}
		}, {
			info = {
				row = 3,
				icon = 135845,
				ranks = 1,
				wowTreeIndex = 2,
				column = 3,
				name = "Tidal Force",
				talentRankSpellIds = { 55198 }
			}
		}, {
			info = {
				row = 3,
				icon = 136109,
				ranks = 3,
				wowTreeIndex = 1,
				column = 4,
				name = "Ancestral Healing",
				talentRankSpellIds = { 16176, 16235, 16240 }
			}
		}, {
			info = {
				row = 4,
				icon = 136053,
				ranks = 3,
				wowTreeIndex = 6,
				column = 2,
				name = "Restorative Totems",
				talentRankSpellIds = { 16187, 16205, 16206 }
			}
		}, {
			info = {
				row = 4,
				icon = 136107,
				ranks = 5,
				wowTreeIndex = 12,
				column = 3,
				name = "Tidal Mastery",
				talentRankSpellIds = { 16194, 16218, 16219, 16220, 16221 }
			}
		}, {
			info = {
				row = 5,
				icon = 136044,
				ranks = 3,
				wowTreeIndex = 15,
				column = 1,
				name = "Healing Way",
				talentRankSpellIds = { 29206, 29205, 29202 }
			}
		}, {
			info = {
				row = 5,
				icon = 136076,
				ranks = 1,
				wowTreeIndex = 9,
				column = 3,
				name = "Nature's Swiftness",
				talentRankSpellIds = { 16188 }
			}
		}, {
			info = {
				row = 5,
				icon = 136035,
				ranks = 3,
				wowTreeIndex = 16,
				column = 4,
				name = "Focused Mind",
				talentRankSpellIds = { 30864, 30865, 30866 }
			}
		}, {
			info = {
				row = 6,
				icon = 135865,
				ranks = 5,
				wowTreeIndex = 10,
				column = 3,
				name = "Purification",
				talentRankSpellIds = { 16178, 16210, 16211, 16212, 16213 }
			}
		}, {
			info = {
				row = 7,
				icon = 136060,
				ranks = 5,
				wowTreeIndex = 20,
				column = 1,
				name = "Nature's Guardian",
				talentRankSpellIds = { 30881, 30883, 30884, 30885, 30886 }
			}
		}, {
			info = {
				row = 7,
				icon = 135861,
				ranks = 1,
				wowTreeIndex = 8,
				column = 2,
				name = "Mana Tide Totem",
				talentRankSpellIds = { 16190 },
				prereqs = { {
					column = 2,
					row = 4,
					source = 10
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 236288,
				ranks = 1,
				wowTreeIndex = 26,
				column = 3,
				name = "Cleanse Spirit",
				talentRankSpellIds = { 51886 },
				prereqs = { {
					column = 3,
					row = 6,
					source = 15
				} }
			}
		}, {
			info = {
				row = 8,
				icon = 237573,
				ranks = 2,
				wowTreeIndex = 22,
				column = 1,
				name = "Blessing of the Eternals",
				talentRankSpellIds = { 51554, 51555 }
			}
		}, {
			info = {
				row = 8,
				icon = 136042,
				ranks = 2,
				wowTreeIndex = 18,
				column = 2,
				name = "Improved Chain Heal",
				talentRankSpellIds = { 30872, 30873 }
			}
		}, {
			info = {
				row = 8,
				icon = 136059,
				ranks = 3,
				wowTreeIndex = 17,
				column = 3,
				name = "Nature's Blessing",
				talentRankSpellIds = { 30867, 30868, 30869 }
			}
		}, {
			info = {
				row = 9,
				icon = 237571,
				ranks = 3,
				wowTreeIndex = 23,
				column = 1,
				name = "Ancestral Awakening",
				talentRankSpellIds = { 51556, 51557, 51558 }
			}
		}, {
			info = {
				row = 9,
				icon = 136089,
				ranks = 1,
				wowTreeIndex = 19,
				column = 2,
				name = "Earth Shield",
				talentRankSpellIds = { 974 }
			}
		}, {
			info = {
				row = 9,
				icon = 136089,
				ranks = 2,
				wowTreeIndex = 21,
				column = 3,
				name = "Improved Earth Shield",
				talentRankSpellIds = { 51560, 51561 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 23
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 237590,
				ranks = 5,
				wowTreeIndex = 24,
				column = 2,
				name = "Tidal Waves",
				talentRankSpellIds = { 51562, 51563, 51564, 51565, 51566 }
			}
		}, {
			info = {
				row = 11,
				icon = 252995,
				ranks = 1,
				wowTreeIndex = 25,
				column = 2,
				name = "Riptide",
				talentRankSpellIds = { 61295 }
			}
		} },
		info = {
			name = "Restoration",
			background = "ShamanRestoration"
		}
	}, -- [3]
}

talents.warlock = {
	{
		numtalents = 28,
		talents = { {
			info = {
				row = 1,
				icon = 136139,
				ranks = 2,
				wowTreeIndex = 15,
				column = 1,
				name = "Improved Curse of Agony",
				talentRankSpellIds = { 18827, 18829 }
			}
		}, {
			info = {
				row = 1,
				icon = 136230,
				ranks = 3,
				wowTreeIndex = 5,
				column = 2,
				name = "Suppression",
				talentRankSpellIds = { 18174, 18175, 18176 }
			}
		}, {
			info = {
				row = 1,
				icon = 136118,
				ranks = 5,
				wowTreeIndex = 3,
				column = 3,
				name = "Improved Corruption",
				talentRankSpellIds = { 17810, 17811, 17812, 17813, 17814 }
			}
		}, {
			info = {
				row = 2,
				icon = 136138,
				ranks = 2,
				wowTreeIndex = 6,
				column = 1,
				name = "Improved Curse of Weakness",
				talentRankSpellIds = { 18179, 18180 }
			}
		}, {
			info = {
				row = 2,
				icon = 136163,
				ranks = 2,
				wowTreeIndex = 14,
				column = 2,
				name = "Improved Drain Soul",
				talentRankSpellIds = { 18213, 18372 }
			}
		}, {
			info = {
				row = 2,
				icon = 136126,
				ranks = 2,
				wowTreeIndex = 7,
				column = 3,
				name = "Improved Life Tap",
				talentRankSpellIds = { 18182, 18183 }
			}
		}, {
			info = {
				row = 2,
				icon = 136169,
				ranks = 2,
				wowTreeIndex = 4,
				column = 4,
				name = "Soul Siphon",
				talentRankSpellIds = { 17804, 17805 }
			}
		}, {
			info = {
				row = 3,
				icon = 136183,
				ranks = 2,
				wowTreeIndex = 27,
				column = 1,
				name = "Improved Fear",
				talentRankSpellIds = { 53754, 53759 }
			}
		}, {
			info = {
				row = 3,
				icon = 136157,
				ranks = 3,
				wowTreeIndex = 1,
				column = 2,
				name = "Fel Concentration",
				talentRankSpellIds = { 17783, 17784, 17785 }
			}
		}, {
			info = {
				row = 3,
				icon = 136132,
				ranks = 1,
				wowTreeIndex = 12,
				column = 3,
				name = "Amplify Curse",
				talentRankSpellIds = { 18288 }
			}
		}, {
			info = {
				row = 4,
				icon = 136127,
				ranks = 2,
				wowTreeIndex = 8,
				column = 1,
				name = "Grim Reach",
				talentRankSpellIds = { 18218, 18219 }
			}
		}, {
			info = {
				row = 4,
				icon = 136223,
				ranks = 2,
				wowTreeIndex = 2,
				column = 2,
				name = "Nightfall",
				talentRankSpellIds = { 18094, 18095 }
			}
		}, {
			info = {
				row = 4,
				icon = 136118,
				ranks = 3,
				wowTreeIndex = 21,
				column = 4,
				name = "Empowered Corruption",
				talentRankSpellIds = { 32381, 32382, 32383 }
			}
		}, {
			info = {
				row = 5,
				icon = 136198,
				ranks = 5,
				wowTreeIndex = 20,
				column = 1,
				name = "Shadow Embrace",
				talentRankSpellIds = { 32385, 32387, 32392, 32393, 32394 }
			}
		}, {
			info = {
				row = 5,
				icon = 136188,
				ranks = 1,
				wowTreeIndex = 10,
				column = 2,
				name = "Siphon Life",
				talentRankSpellIds = { 63108 }
			}
		}, {
			info = {
				row = 5,
				icon = 136162,
				ranks = 1,
				wowTreeIndex = 13,
				column = 3,
				name = "Curse of Exhaustion",
				talentRankSpellIds = { 18223 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 10
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 136217,
				ranks = 2,
				wowTreeIndex = 22,
				column = 1,
				name = "Improved Felhunter",
				talentRankSpellIds = { 54037, 54038 }
			}
		}, {
			info = {
				row = 6,
				icon = 136195,
				ranks = 5,
				wowTreeIndex = 11,
				column = 2,
				name = "Shadow Mastery",
				talentRankSpellIds = { 18271, 18272, 18273, 18274, 18275 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 15
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 236295,
				ranks = 3,
				wowTreeIndex = 25,
				column = 1,
				name = "Eradication",
				talentRankSpellIds = { 47195, 47196, 47197 }
			}
		}, {
			info = {
				row = 7,
				icon = 136180,
				ranks = 5,
				wowTreeIndex = 18,
				column = 2,
				name = "Contagion",
				talentRankSpellIds = { 30060, 30061, 30062, 30063, 30064 }
			}
		}, {
			info = {
				row = 7,
				icon = 136141,
				ranks = 1,
				wowTreeIndex = 9,
				column = 3,
				name = "Dark Pact",
				talentRankSpellIds = { 18220 }
			}
		}, {
			info = {
				row = 8,
				icon = 136147,
				ranks = 2,
				wowTreeIndex = 17,
				column = 1,
				name = "Improved Howl of Terror",
				talentRankSpellIds = { 30054, 30057 }
			}
		}, {
			info = {
				row = 8,
				icon = 136137,
				ranks = 3,
				wowTreeIndex = 16,
				column = 3,
				name = "Malediction",
				talentRankSpellIds = { 32477, 32483, 32484 }
			}
		}, {
			info = {
				row = 9,
				icon = 237557,
				ranks = 3,
				wowTreeIndex = 23,
				column = 1,
				name = "Death's Embrace",
				talentRankSpellIds = { 47198, 47199, 47200 }
			}
		}, {
			info = {
				row = 9,
				icon = 136228,
				ranks = 1,
				wowTreeIndex = 19,
				column = 2,
				name = "Unstable Affliction",
				talentRankSpellIds = { 30108 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 20
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 136227,
				ranks = 1,
				wowTreeIndex = 28,
				column = 3,
				name = "Pandemic",
				talentRankSpellIds = { 58435 },
				prereqs = { {
					column = 2,
					row = 9,
					source = 25
				} }
			}
		}, {
			info = {
				row = 10,
				icon = 236296,
				ranks = 5,
				wowTreeIndex = 24,
				column = 2,
				name = "Everlasting Affliction",
				talentRankSpellIds = { 47201, 47202, 47203, 47204, 47205 }
			}
		}, {
			info = {
				row = 11,
				icon = 236298,
				ranks = 1,
				wowTreeIndex = 26,
				column = 2,
				name = "Haunt",
				talentRankSpellIds = { 48181 }
			}
		} },
		info = {
			name = "Affliction",
			background = "WarlockCurses"
		}
	},
	{
		numtalents = 27,
		talents = { {
			info = {
				row = 1,
				icon = 135230,
				ranks = 2,
				wowTreeIndex = 1,
				column = 1,
				name = "Improved Healthstone",
				talentRankSpellIds = { 18692, 18693 }
			}
		}, {
			info = {
				row = 1,
				icon = 136218,
				ranks = 3,
				wowTreeIndex = 2,
				column = 2,
				name = "Improved Imp",
				talentRankSpellIds = { 18694, 18695, 18696 }
			}
		}, {
			info = {
				row = 1,
				icon = 136172,
				ranks = 3,
				wowTreeIndex = 3,
				column = 3,
				name = "Demonic Embrace",
				talentRankSpellIds = { 18697, 18698, 18699 }
			}
		}, {
			info = {
				row = 1,
				icon = 237564,
				ranks = 2,
				wowTreeIndex = 23,
				column = 4,
				name = "Fel Synergy",
				talentRankSpellIds = { 47230, 47231 }
			}
		}, {
			info = {
				row = 2,
				icon = 136168,
				ranks = 2,
				wowTreeIndex = 4,
				column = 1,
				name = "Improved Health Funnel",
				talentRankSpellIds = { 18703, 18704 }
			}
		}, {
			info = {
				row = 2,
				icon = 136221,
				ranks = 3,
				wowTreeIndex = 5,
				column = 2,
				name = "Demonic Brutality",
				talentRankSpellIds = { 18705, 18706, 18707 }
			}
		}, {
			info = {
				row = 2,
				icon = 135932,
				ranks = 3,
				wowTreeIndex = 8,
				column = 3,
				name = "Fel Vitality",
				talentRankSpellIds = { 18731, 18743, 18744 }
			}
		}, {
			info = {
				row = 3,
				icon = 136220,
				ranks = 3,
				wowTreeIndex = 9,
				column = 1,
				name = "Improved Sayaad",
				talentRankSpellIds = { 18754, 18755, 18756 }
			}
		}, {
			info = {
				row = 3,
				icon = 136160,
				ranks = 1,
				wowTreeIndex = 15,
				column = 2,
				name = "Soul Link",
				talentRankSpellIds = { 19028 }
			}
		}, {
			info = {
				row = 3,
				icon = 136082,
				ranks = 1,
				wowTreeIndex = 6,
				column = 3,
				name = "Fel Domination",
				talentRankSpellIds = { 18708 }
			}
		}, {
			info = {
				row = 3,
				icon = 136185,
				ranks = 3,
				wowTreeIndex = 17,
				column = 4,
				name = "Demonic Aegis",
				talentRankSpellIds = { 30143, 30144, 30145 }
			}
		}, {
			info = {
				row = 4,
				icon = 136206,
				ranks = 5,
				wowTreeIndex = 12,
				column = 2,
				name = "Unholy Power",
				talentRankSpellIds = { 18769, 18770, 18771, 18772, 18773 },
				prereqs = { {
					column = 2,
					row = 3,
					source = 9
				} }
			}
		}, {
			info = {
				row = 4,
				icon = 136164,
				ranks = 2,
				wowTreeIndex = 7,
				column = 3,
				name = "Master Summoner",
				talentRankSpellIds = { 18709, 18710 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 10
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 136171,
				ranks = 1,
				wowTreeIndex = 14,
				column = 1,
				name = "Mana Feed",
				talentRankSpellIds = { 30326 },
				prereqs = { {
					column = 2,
					row = 4,
					source = 12
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 132386,
				ranks = 2,
				wowTreeIndex = 11,
				column = 3,
				name = "Master Conjuror",
				talentRankSpellIds = { 18767, 18768 }
			}
		}, {
			info = {
				row = 6,
				icon = 136203,
				ranks = 5,
				wowTreeIndex = 10,
				column = 2,
				name = "Master Demonologist",
				talentRankSpellIds = { 23785, 23822, 23823, 23824, 23825 },
				prereqs = { {
					column = 2,
					row = 4,
					source = 12
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 236301,
				ranks = 3,
				wowTreeIndex = 16,
				column = 3,
				name = "Molten Core",
				talentRankSpellIds = { 47245, 47246, 47247 }
			}
		}, {
			info = {
				row = 7,
				icon = 136149,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Demonic Resilience",
				talentRankSpellIds = { 30319, 30320, 30321 }
			}
		}, {
			info = {
				row = 7,
				icon = 236292,
				ranks = 1,
				wowTreeIndex = 21,
				column = 2,
				name = "Demonic Empowerment",
				talentRankSpellIds = { 47193 },
				prereqs = { {
					column = 2,
					row = 6,
					source = 16
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136165,
				ranks = 3,
				wowTreeIndex = 13,
				column = 3,
				name = "Demonic Knowledge",
				talentRankSpellIds = { 35691, 35692, 35693 }
			}
		}, {
			info = {
				row = 8,
				icon = 136150,
				ranks = 5,
				wowTreeIndex = 19,
				column = 2,
				name = "Demonic Tactics",
				talentRankSpellIds = { 30242, 30245, 30246, 30247, 30248 }
			}
		}, {
			info = {
				row = 8,
				icon = 135808,
				ranks = 2,
				wowTreeIndex = 27,
				column = 3,
				name = "Decimation",
				talentRankSpellIds = { 63156, 63158 }
			}
		}, {
			info = {
				row = 9,
				icon = 236299,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Improved Demonic Tactics",
				talentRankSpellIds = { 54347, 54348, 54349 },
				prereqs = { {
					column = 2,
					row = 8,
					source = 21
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 136216,
				ranks = 1,
				wowTreeIndex = 18,
				column = 2,
				name = "Summon Felguard",
				talentRankSpellIds = { 30146 }
			}
		}, {
			info = {
				row = 9,
				icon = 237561,
				ranks = 3,
				wowTreeIndex = 24,
				column = 3,
				name = "Nemesis",
				talentRankSpellIds = { 63117, 63121, 63123 }
			}
		}, {
			info = {
				row = 10,
				icon = 237562,
				ranks = 5,
				wowTreeIndex = 25,
				column = 2,
				name = "Demonic Pact",
				talentRankSpellIds = { 47236, 47237, 47238, 47239, 47240 }
			}
		}, {
			info = {
				row = 11,
				icon = 237558,
				ranks = 1,
				wowTreeIndex = 26,
				column = 2,
				name = "Metamorphosis",
				talentRankSpellIds = { 59672 }
			}
		} },
		info = {
			name = "Demonology",
			background = "WarlockSummoning"
		}
	},
	{
		numtalents = 26,
		talents = { {
			info = {
				row = 1,
				icon = 136197,
				ranks = 5,
				wowTreeIndex = 3,
				column = 2,
				name = "Improved Shadow Bolt",
				talentRankSpellIds = { 17793, 17796, 17801, 17802, 17803 }
			}
		}, {
			info = {
				row = 1,
				icon = 136146,
				ranks = 5,
				wowTreeIndex = 2,
				column = 3,
				name = "Bane",
				talentRankSpellIds = { 17788, 17789, 17790, 17791, 17792 }
			}
		}, {
			info = {
				row = 2,
				icon = 135805,
				ranks = 2,
				wowTreeIndex = 12,
				column = 1,
				name = "Aftermath",
				talentRankSpellIds = { 18119, 18120 }
			}
		}, {
			info = {
				row = 2,
				icon = 132221,
				ranks = 3,
				wowTreeIndex = 21,
				column = 2,
				name = "Molten Skin",
				talentRankSpellIds = { 63349, 63350, 63351 }
			}
		}, {
			info = {
				row = 2,
				icon = 135831,
				ranks = 3,
				wowTreeIndex = 1,
				column = 3,
				name = "Cataclysm",
				talentRankSpellIds = { 17778, 17779, 17780 }
			}
		}, {
			info = {
				row = 3,
				icon = 135809,
				ranks = 2,
				wowTreeIndex = 13,
				column = 1,
				name = "Demonic Power",
				talentRankSpellIds = { 18126, 18127 }
			}
		}, {
			info = {
				row = 3,
				icon = 136191,
				ranks = 1,
				wowTreeIndex = 5,
				column = 2,
				name = "Shadowburn",
				talentRankSpellIds = { 17877 }
			}
		}, {
			info = {
				row = 3,
				icon = 136207,
				ranks = 5,
				wowTreeIndex = 9,
				column = 3,
				name = "Ruin",
				talentRankSpellIds = { 17959, 59738, 59739, 59740, 59741 }
			}
		}, {
			info = {
				row = 4,
				icon = 135819,
				ranks = 2,
				wowTreeIndex = 14,
				column = 1,
				name = "Intensity",
				talentRankSpellIds = { 18135, 18136 }
			}
		}, {
			info = {
				row = 4,
				icon = 136133,
				ranks = 2,
				wowTreeIndex = 6,
				column = 2,
				name = "Destructive Reach",
				talentRankSpellIds = { 17917, 17918 }
			}
		}, {
			info = {
				row = 4,
				icon = 135827,
				ranks = 3,
				wowTreeIndex = 7,
				column = 4,
				name = "Improved Searing Pain",
				talentRankSpellIds = { 17927, 17929, 17930 }
			}
		}, {
			info = {
				row = 5,
				icon = 135823,
				ranks = 3,
				wowTreeIndex = 20,
				column = 1,
				name = "Backlash",
				talentRankSpellIds = { 34935, 34938, 34939 },
				prereqs = { {
					column = 1,
					row = 4,
					source = 9
				} }
			}
		}, {
			info = {
				row = 5,
				icon = 135817,
				ranks = 3,
				wowTreeIndex = 4,
				column = 2,
				name = "Improved Immolate",
				talentRankSpellIds = { 17815, 17833, 17834 }
			}
		}, {
			info = {
				row = 5,
				icon = 135813,
				ranks = 1,
				wowTreeIndex = 11,
				column = 3,
				name = "Devastation",
				talentRankSpellIds = { 18130 },
				prereqs = { {
					column = 3,
					row = 3,
					source = 8
				} }
			}
		}, {
			info = {
				row = 6,
				icon = 136178,
				ranks = 3,
				wowTreeIndex = 19,
				column = 1,
				name = "Nether Protection",
				talentRankSpellIds = { 30299, 30301, 30302 }
			}
		}, {
			info = {
				row = 6,
				icon = 135826,
				ranks = 5,
				wowTreeIndex = 8,
				column = 3,
				name = "Emberstorm",
				talentRankSpellIds = { 17954, 17955, 17956, 17957, 17958 }
			}
		}, {
			info = {
				row = 7,
				icon = 135807,
				ranks = 1,
				wowTreeIndex = 10,
				column = 2,
				name = "Conflagrate",
				talentRankSpellIds = { 17962 },
				prereqs = { {
					column = 2,
					row = 5,
					source = 13
				} }
			}
		}, {
			info = {
				row = 7,
				icon = 136214,
				ranks = 3,
				wowTreeIndex = 18,
				column = 3,
				name = "Soul Leech",
				talentRankSpellIds = { 30293, 30295, 30296 }
			}
		}, {
			info = {
				row = 7,
				icon = 135830,
				ranks = 3,
				wowTreeIndex = 15,
				column = 4,
				name = "Pyroclasm",
				talentRankSpellIds = { 18096, 18073, 63245 }
			}
		}, {
			info = {
				row = 8,
				icon = 136196,
				ranks = 5,
				wowTreeIndex = 17,
				column = 2,
				name = "Shadow and Flame",
				talentRankSpellIds = { 30288, 30289, 30290, 30291, 30292 }
			}
		}, {
			info = {
				row = 8,
				icon = 236300,
				ranks = 2,
				wowTreeIndex = 23,
				column = 3,
				name = "Improved Soul Leech",
				talentRankSpellIds = { 54117, 54118 },
				prereqs = { {
					column = 3,
					row = 7,
					source = 18
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 236290,
				ranks = 3,
				wowTreeIndex = 22,
				column = 1,
				name = "Backdraft",
				talentRankSpellIds = { 47258, 47259, 47260 },
				prereqs = { {
					column = 2,
					row = 7,
					source = 17
				} }
			}
		}, {
			info = {
				row = 9,
				icon = 136201,
				ranks = 1,
				wowTreeIndex = 16,
				column = 2,
				name = "Shadowfury",
				talentRankSpellIds = { 30283 }
			}
		}, {
			info = {
				row = 9,
				icon = 236294,
				ranks = 3,
				wowTreeIndex = 26,
				column = 3,
				name = "Empowered Imp",
				talentRankSpellIds = { 47220, 47221, 47223 }
			}
		}, {
			info = {
				row = 10,
				icon = 236297,
				ranks = 5,
				wowTreeIndex = 24,
				column = 2,
				name = "Fire and Brimstone",
				talentRankSpellIds = { 47266, 47267, 47268, 47269, 47270 }
			}
		}, {
			info = {
				row = 11,
				icon = 236291,
				ranks = 1,
				wowTreeIndex = 25,
				column = 2,
				name = "Chaos Bolt",
				talentRankSpellIds = { 50796 }
			}
		} },
		info = {
			name = "Destruction",
			background = "WarlockDestruction"
		}
	}
}

talents.warrior = {
	{
        numtalents = 31,
        talents = {
            {
                info = {
                    row = 1,
                    icon = 132282,
                    ranks = 3,
                    wowTreeIndex = 3,
                    column = 1,
                    name = "Improved Heroic Strike",
                    talentRankSpellIds = { 12282, 12663, 12664 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 132269,
                    ranks = 5,
                    wowTreeIndex = 9,
                    column = 2,
                    name = "Deflection",
                    talentRankSpellIds = { 16462, 16463, 16464, 16465, 16466 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 132155,
                    ranks = 2,
                    wowTreeIndex = 6,
                    column = 3,
                    name = "Improved Rend",
                    talentRankSpellIds = { 12286, 12658 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 132337,
                    ranks = 2,
                    wowTreeIndex = 5,
                    column = 1,
                    name = "Improved Charge",
                    talentRankSpellIds = { 12285, 12697 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 135995,
                    ranks = 3,
                    wowTreeIndex = 17,
                    column = 2,
                    name = "Iron Will",
                    talentRankSpellIds = { 12300, 12959, 12960 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 136031,
                    ranks = 3,
                    wowTreeIndex = 7,
                    column = 3,
                    name = "Tactical Mastery",
                    talentRankSpellIds = { 12295, 12676, 12677 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 135275,
                    ranks = 2,
                    wowTreeIndex = 10,
                    column = 1,
                    name = "Improved Overpower",
                    talentRankSpellIds = { 12290, 12963 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 135881,
                    ranks = 1,
                    wowTreeIndex = 16,
                    column = 2,
                    name = "Anger Management",
                    talentRankSpellIds = { 12296 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 132312,
                    ranks = 2,
                    wowTreeIndex = 18,
                    column = 3,
                    name = "Impale",
                    talentRankSpellIds = { 16493, 16494 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 132090,
                    ranks = 3,
                    wowTreeIndex = 1,
                    column = 4,
                    name = "Deep Wounds",
                    talentRankSpellIds = { 12834, 12849, 12867 },
                    prereqs = {
                        {
                            column = 3,
                            row = 3,
                            source = 9
                        }
                    }
                }
            }, {
                info = {
                    row = 4,
                    icon = 132400,
                    ranks = 3,
                    wowTreeIndex = 15,
                    column = 2,
                    name = "Two-Handed Weapon Specialization",
                    talentRankSpellIds = { 12163, 12711, 12712 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 236276,
                    ranks = 3,
                    wowTreeIndex = 29,
                    column = 3,
                    name = "Taste for Blood",
                    talentRankSpellIds = { 56636, 56637, 56638 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132397,
                    ranks = 5,
                    wowTreeIndex = 11,
                    column = 1,
                    name = "Poleaxe Specialization",
                    talentRankSpellIds = { 12700, 12781, 12783, 12784, 12785 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132306,
                    ranks = 1,
                    wowTreeIndex = 12,
                    column = 2,
                    name = "Sweeping Strikes",
                    talentRankSpellIds = { 12328 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 133476,
                    ranks = 5,
                    wowTreeIndex = 4,
                    column = 3,
                    name = "Mace Specialization",
                    talentRankSpellIds = { 12284, 12701, 12702, 12703, 12704 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 135328,
                    ranks = 5,
                    wowTreeIndex = 2,
                    column = 4,
                    name = "Sword Specialization",
                    talentRankSpellIds = { 12281, 12812, 12813, 12814, 12815 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 132367,
                    ranks = 2,
                    wowTreeIndex = 13,
                    column = 1,
                    name = "Weapon Mastery",
                    talentRankSpellIds = { 20504, 20505 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 132316,
                    ranks = 3,
                    wowTreeIndex = 8,
                    column = 3,
                    name = "Improved Hamstring",
                    talentRankSpellIds = { 12289, 12668, 23695 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 236305,
                    ranks = 2,
                    wowTreeIndex = 24,
                    column = 4,
                    name = "Trauma",
                    talentRankSpellIds = { 46854, 46855 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132175,
                    ranks = 2,
                    wowTreeIndex = 21,
                    column = 1,
                    name = "Second Wind",
                    talentRankSpellIds = { 29834, 29838 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132355,
                    ranks = 1,
                    wowTreeIndex = 14,
                    column = 2,
                    name = "Mortal Strike",
                    talentRankSpellIds = { 12294 },
                    prereqs = {
                        {
                            column = 2,
                            row = 5,
                            source = 14
                        }
                    }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132349,
                    ranks = 2,
                    wowTreeIndex = 26,
                    column = 3,
                    name = "Strength of Arms",
                    talentRankSpellIds = { 46865, 46866 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132340,
                    ranks = 2,
                    wowTreeIndex = 30,
                    column = 4,
                    name = "Improved Slam",
                    talentRankSpellIds = { 12862, 12330 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 132335,
                    ranks = 1,
                    wowTreeIndex = 31,
                    column = 1,
                    name = "Juggernaut",
                    talentRankSpellIds = { 64976 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 132355,
                    ranks = 3,
                    wowTreeIndex = 23,
                    column = 2,
                    name = "Improved Mortal Strike",
                    talentRankSpellIds = { 35446, 35448, 35449 },
                    prereqs = {
                        {
                            column = 2,
                            row = 7,
                            source = 21
                        }
                    }
                }
            }, {
                info = {
                    row = 8,
                    icon = 236317,
                    ranks = 2,
                    wowTreeIndex = 25,
                    column = 3,
                    name = "Unrelenting Assault",
                    talentRankSpellIds = { 46859, 46860 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 132346,
                    ranks = 3,
                    wowTreeIndex = 20,
                    column = 1,
                    name = "Sudden Death",
                    talentRankSpellIds = { 29723, 29725, 29724 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 132344,
                    ranks = 1,
                    wowTreeIndex = 19,
                    column = 2,
                    name = "Endless Rage",
                    talentRankSpellIds = { 29623 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 132334,
                    ranks = 2,
                    wowTreeIndex = 22,
                    column = 3,
                    name = "Blood Frenzy",
                    talentRankSpellIds = { 29836, 29859 }
                }
            }, {
                info = {
                    row = 10,
                    icon = 132364,
                    ranks = 5,
                    wowTreeIndex = 28,
                    column = 2,
                    name = "Wrecking Crew",
                    talentRankSpellIds = { 46867, 56611, 56612, 56613, 56614 }
                }
            }, {
                info = {
                    row = 11,
                    icon = 236303,
                    ranks = 1,
                    wowTreeIndex = 27,
                    column = 2,
                    name = "Bladestorm",
                    talentRankSpellIds = { 46924 }
                }
            }
        },
        info = {
            name = "Arms",
            background = "WarriorArms"
        }
    },
    {
        numtalents = 27,
        talents = {
            {
                info = {
                    row = 1,
                    icon = 135053,
                    ranks = 3,
                    wowTreeIndex = 27,
                    column = 1,
                    name = "Armored to the Teeth",
                    talentRankSpellIds = { 61216, 61221, 61222 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 136075,
                    ranks = 2,
                    wowTreeIndex = 5,
                    column = 2,
                    name = "Booming Voice",
                    talentRankSpellIds = { 12321, 12835 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 132292,
                    ranks = 5,
                    wowTreeIndex = 4,
                    column = 3,
                    name = "Cruelty",
                    talentRankSpellIds = { 12320, 12852, 12853, 12855, 12856 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 132366,
                    ranks = 5,
                    wowTreeIndex = 8,
                    column = 2,
                    name = "Improved Demoralizing Shout",
                    talentRankSpellIds = { 12324, 12876, 12877, 12878, 12879 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 136097,
                    ranks = 5,
                    wowTreeIndex = 6,
                    column = 3,
                    name = "Unbridled Wrath",
                    talentRankSpellIds = { 12322, 12999, 13000, 13001, 13002 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 132338,
                    ranks = 3,
                    wowTreeIndex = 10,
                    column = 1,
                    name = "Improved Cleave",
                    talentRankSpellIds = { 12329, 12950, 20496 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 136147,
                    ranks = 1,
                    wowTreeIndex = 7,
                    column = 2,
                    name = "Piercing Howl",
                    talentRankSpellIds = { 12323 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 136218,
                    ranks = 3,
                    wowTreeIndex = 12,
                    column = 3,
                    name = "Blood Craze",
                    talentRankSpellIds = { 16487, 16489, 16492 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 136035,
                    ranks = 5,
                    wowTreeIndex = 1,
                    column = 4,
                    name = "Commanding Presence",
                    talentRankSpellIds = { 12318, 12857, 12858, 12860, 12861 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 132147,
                    ranks = 5,
                    wowTreeIndex = 16,
                    column = 1,
                    name = "Dual Wield Specialization",
                    talentRankSpellIds = { 23584, 23585, 23586, 23587, 23588 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 135358,
                    ranks = 2,
                    wowTreeIndex = 14,
                    column = 2,
                    name = "Improved Execute",
                    talentRankSpellIds = { 20502, 20503 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 136224,
                    ranks = 5,
                    wowTreeIndex = 2,
                    column = 3,
                    name = "Enrage",
                    talentRankSpellIds = { 12317, 13045, 13046, 13047, 13048 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132222,
                    ranks = 3,
                    wowTreeIndex = 18,
                    column = 1,
                    name = "Precision",
                    talentRankSpellIds = { 29590, 29591, 29592 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 136146,
                    ranks = 1,
                    wowTreeIndex = 9,
                    column = 2,
                    name = "Death Wish",
                    talentRankSpellIds = { 12292 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132307,
                    ranks = 2,
                    wowTreeIndex = 15,
                    column = 3,
                    name = "Improved Intercept",
                    talentRankSpellIds = { 29888, 29889 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 136009,
                    ranks = 2,
                    wowTreeIndex = 13,
                    column = 1,
                    name = "Improved Berserker Rage",
                    talentRankSpellIds = { 20500, 20501 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 132152,
                    ranks = 5,
                    wowTreeIndex = 3,
                    column = 3,
                    name = "Flurry",
                    talentRankSpellIds = { 12319, 12971, 12972, 12973, 12974 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132344,
                    ranks = 3,
                    wowTreeIndex = 21,
                    column = 1,
                    name = "Intensify Rage",
                    talentRankSpellIds = { 46908, 46909, 56924 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 136012,
                    ranks = 1,
                    wowTreeIndex = 11,
                    column = 2,
                    name = "Bloodthirst",
                    talentRankSpellIds = { 23881 },
                    prereqs = {
                        {
                            column = 2,
                            row = 5,
                            source = 14
                        }
                    }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132369,
                    ranks = 2,
                    wowTreeIndex = 17,
                    column = 4,
                    name = "Improved Whirlwind",
                    talentRankSpellIds = { 29721, 29776 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 236308,
                    ranks = 2,
                    wowTreeIndex = 22,
                    column = 1,
                    name = "Furious Attacks",
                    talentRankSpellIds = { 46910, 46911 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 132275,
                    ranks = 5,
                    wowTreeIndex = 19,
                    column = 4,
                    name = "Improved Berserker Stance",
                    talentRankSpellIds = { 29759, 29760, 29761, 29762, 29763 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 236171,
                    ranks = 1,
                    wowTreeIndex = 25,
                    column = 1,
                    name = "Heroic Fury",
                    talentRankSpellIds = { 60970 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 132352,
                    ranks = 1,
                    wowTreeIndex = 20,
                    column = 2,
                    name = "Rampage",
                    talentRankSpellIds = { 29801 },
                    prereqs = {
                        {
                            column = 2,
                            row = 7,
                            source = 19
                        }
                    }
                }
            }, {
                info = {
                    row = 9,
                    icon = 236306,
                    ranks = 3,
                    wowTreeIndex = 23,
                    column = 3,
                    name = "Bloodsurge",
                    talentRankSpellIds = { 46913, 46914, 46915 },
                    prereqs = {
                        {
                            column = 2,
                            row = 7,
                            source = 19
                        }
                    }
                }
            }, {
                info = {
                    row = 10,
                    icon = 236310,
                    ranks = 5,
                    wowTreeIndex = 26,
                    column = 2,
                    name = "Unending Fury",
                    talentRankSpellIds = { 56927, 56929, 56930, 56931, 56932 }
                }
            }, {
                info = {
                    row = 11,
                    icon = 236316,
                    ranks = 1,
                    wowTreeIndex = 24,
                    column = 2,
                    name = "Titan's Grip",
                    talentRankSpellIds = { 46917 }
                }
            }
        },
        info = {
            name = "Fury",
            background = "WarriorFury"
        }
    },
    {
        numtalents = 27,
        talents = {
            {
                info = {
                    row = 1,
                    icon = 132277,
                    ranks = 2,
                    wowTreeIndex = 4,
                    column = 1,
                    name = "Improved Bloodrage",
                    talentRankSpellIds = { 12301, 12818 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 134952,
                    ranks = 5,
                    wowTreeIndex = 15,
                    column = 2,
                    name = "Shield Specialization",
                    talentRankSpellIds = { 12298, 12724, 12725, 12726, 12727 }
                }
            }, {
                info = {
                    row = 1,
                    icon = 132326,
                    ranks = 3,
                    wowTreeIndex = 3,
                    column = 3,
                    name = "Improved Thunder Clap",
                    talentRankSpellIds = { 12287, 12665, 12666 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 236309,
                    ranks = 3,
                    wowTreeIndex = 5,
                    column = 2,
                    name = "Incite",
                    talentRankSpellIds = { 50685, 50686, 50687 }
                }
            }, {
                info = {
                    row = 2,
                    icon = 136056,
                    ranks = 5,
                    wowTreeIndex = 1,
                    column = 3,
                    name = "Anticipation",
                    talentRankSpellIds = { 12297, 12750, 12751, 12752, 12753 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 135871,
                    ranks = 1,
                    wowTreeIndex = 13,
                    column = 1,
                    name = "Last Stand",
                    talentRankSpellIds = { 12975 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 132353,
                    ranks = 2,
                    wowTreeIndex = 7,
                    column = 2,
                    name = "Improved Revenge",
                    talentRankSpellIds = { 12797, 12799 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 132360,
                    ranks = 2,
                    wowTreeIndex = 18,
                    column = 3,
                    name = "Shield Mastery",
                    talentRankSpellIds = { 29598, 29599 }
                }
            }, {
                info = {
                    row = 3,
                    icon = 135892,
                    ranks = 5,
                    wowTreeIndex = 2,
                    column = 4,
                    name = "Toughness",
                    talentRankSpellIds = { 12299, 12761, 12762, 12763, 12764 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 132361,
                    ranks = 2,
                    wowTreeIndex = 27,
                    column = 1,
                    name = "Improved Spell Reflection",
                    talentRankSpellIds = { 59088, 59089 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 132343,
                    ranks = 2,
                    wowTreeIndex = 11,
                    column = 2,
                    name = "Improved Disarm",
                    talentRankSpellIds = { 12313, 12804 }
                }
            }, {
                info = {
                    row = 4,
                    icon = 132363,
                    ranks = 3,
                    wowTreeIndex = 6,
                    column = 3,
                    name = "Puncture",
                    talentRankSpellIds = { 12308, 12810, 12811 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132362,
                    ranks = 2,
                    wowTreeIndex = 10,
                    column = 1,
                    name = "Improved Disciplines",
                    talentRankSpellIds = { 12312, 12803 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132325,
                    ranks = 1,
                    wowTreeIndex = 12,
                    column = 2,
                    name = "Concussion Blow",
                    talentRankSpellIds = { 12809 }
                }
            }, {
                info = {
                    row = 5,
                    icon = 132357,
                    ranks = 2,
                    wowTreeIndex = 9,
                    column = 3,
                    name = "Gag Order",
                    talentRankSpellIds = { 12311, 12958 }
                }
            }, {
                info = {
                    row = 6,
                    icon = 135321,
                    ranks = 5,
                    wowTreeIndex = 14,
                    column = 3,
                    name = "One-Handed Weapon Specialization",
                    talentRankSpellIds = { 16538, 16539, 16540, 16541, 16542 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132341,
                    ranks = 2,
                    wowTreeIndex = 16,
                    column = 1,
                    name = "Improved Defensive Stance",
                    talentRankSpellIds = { 29593, 29594 }
                }
            }, {
                info = {
                    row = 7,
                    icon = 236318,
                    ranks = 1,
                    wowTreeIndex = 8,
                    column = 2,
                    name = "Vigilance",
                    talentRankSpellIds = { 50720 },
                    prereqs = {
                        {
                            column = 2,
                            row = 5,
                            source = 14
                        }
                    }
                }
            }, {
                info = {
                    row = 7,
                    icon = 132345,
                    ranks = 3,
                    wowTreeIndex = 19,
                    column = 3,
                    name = "Focused Rage",
                    talentRankSpellIds = { 29787, 29790, 29792 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 133123,
                    ranks = 3,
                    wowTreeIndex = 17,
                    column = 2,
                    name = "Vitality",
                    talentRankSpellIds = { 29140, 29143, 29144 }
                }
            }, {
                info = {
                    row = 8,
                    icon = 236311,
                    ranks = 2,
                    wowTreeIndex = 21,
                    column = 3,
                    name = "Safeguard",
                    talentRankSpellIds = { 46945, 46949 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 236319,
                    ranks = 1,
                    wowTreeIndex = 25,
                    column = 1,
                    name = "Warbringer",
                    talentRankSpellIds = { 57499 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 135291,
                    ranks = 1,
                    wowTreeIndex = 20,
                    column = 2,
                    name = "Devastate",
                    talentRankSpellIds = { 20243 }
                }
            }, {
                info = {
                    row = 9,
                    icon = 236307,
                    ranks = 3,
                    wowTreeIndex = 24,
                    column = 3,
                    name = "Critical Block",
                    talentRankSpellIds = { 47294, 47295, 47296 }
                }
            }, {
                info = {
                    row = 10,
                    icon = 236315,
                    ranks = 3,
                    wowTreeIndex = 22,
                    column = 2,
                    name = "Sword and Board",
                    talentRankSpellIds = { 46951, 46952, 46953 },
                    prereqs = {
                        {
                            column = 2,
                            row = 9,
                            source = 23
                        }
                    }
                }
            }, {
                info = {
                    row = 10,
                    icon = 134976,
                    ranks = 2,
                    wowTreeIndex = 26,
                    column = 3,
                    name = "Damage Shield",
                    talentRankSpellIds = { 58872, 58874 }
                }
            }, {
                info = {
                    row = 11,
                    icon = 236312,
                    ranks = 1,
                    wowTreeIndex = 23,
                    column = 2,
                    name = "Shockwave",
                    talentRankSpellIds = { 46968 }
                }
            }
        },
        info = {
            name = "Protection",
            background = "WarriorProtection"
        }
    }
}

talents.deathknight = {
	{
		numtalents = 28,
		talents = {
			{
				info = {
					talentRankSpellIds = {
						48979, -- [1]
						49483, -- [2]
					},
					name = "Butchery",
					wowTreeIndex = 3,
					column = 1,
					row = 1,
					icon = 132455,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					talentRankSpellIds = {
						48997, -- [1]
						49490, -- [2]
						49491, -- [3]
					},
					name = "Subversion",
					wowTreeIndex = 8,
					column = 2,
					row = 1,
					icon = 237533,
					ranks = 3,
				},
			}, -- [2]
			{
				info = {
					talentRankSpellIds = {
						49182, -- [1]
						49500, -- [2]
						49501, -- [3]
						51789, -- [4]
						55225, -- [5]
					},
					name = "Blade Barrier",
					wowTreeIndex = 21,
					column = 3,
					row = 1,
					icon = 132330,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					talentRankSpellIds = {
						48978, -- [1]
						49390, -- [2]
						49391, -- [3]
						49392, -- [4]
						49393, -- [5]
					},
					name = "Bladed Armor",
					wowTreeIndex = 2,
					column = 1,
					row = 2,
					icon = 135067,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					talentRankSpellIds = {
						49004, -- [1]
						49508, -- [2]
						49509, -- [3]
					},
					name = "Scent of Blood",
					wowTreeIndex = 9,
					column = 2,
					row = 2,
					icon = 132284,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					talentRankSpellIds = {
						12163, -- [1]
						12711, -- [2]
					},
					name = "Two-Handed Weapon Specialization",
					wowTreeIndex = 27,
					column = 3,
					row = 2,
					icon = 135378,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						48982, -- [1]
					},
					name = "Rune Tap",
					wowTreeIndex = 4,
					column = 1,
					row = 3,
					icon = 237529,
					ranks = 1,
				},
			}, -- [7]
			{
				info = {
					talentRankSpellIds = {
						48987, -- [1]
						49477, -- [2]
						49478, -- [3]
						49479, -- [4]
						49480, -- [5]
					},
					name = "Dark Conviction",
					wowTreeIndex = 6,
					column = 2,
					row = 3,
					icon = 237518,
					ranks = 5,
				},
			}, -- [8]
			{
				info = {
					talentRankSpellIds = {
						49467, -- [1]
						50033, -- [2]
						50034, -- [3]
					},
					name = "Death Rune Mastery",
					wowTreeIndex = 25,
					column = 3,
					row = 3,
					icon = 135372,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					talentRankSpellIds = {
						48985, -- [1]
						49488, -- [2]
						49489, -- [3]
					},
					prereqs = {
						{
							column = 1,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Improved Rune Tap",
					wowTreeIndex = 5,
					column = 1,
					row = 4,
					icon = 237529,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					talentRankSpellIds = {
						49145, -- [1]
						49495, -- [2]
						49497, -- [3]
					},
					name = "Spell Deflection",
					wowTreeIndex = 22,
					column = 3,
					row = 4,
					icon = 237531,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					talentRankSpellIds = {
						49015, -- [1]
						50154, -- [2]
						50181, -- [3]
					},
					name = "Vendetta",
					wowTreeIndex = 12,
					column = 4,
					row = 4,
					icon = 237536,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					talentRankSpellIds = {
						48977, -- [1]
						49394, -- [2]
						49395, -- [3]
					},
					name = "Bloody Strikes",
					wowTreeIndex = 20,
					column = 1,
					row = 5,
					icon = 135772,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					talentRankSpellIds = {
						49006, -- [1]
						49526, -- [2]
						50029, -- [3]
					},
					name = "Veteran of the Third War",
					wowTreeIndex = 11,
					column = 3,
					row = 5,
					icon = 136005,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49005, -- [1]
					},
					name = "Mark of Blood",
					wowTreeIndex = 10,
					column = 4,
					row = 5,
					icon = 132205,
					ranks = 1,
				},
			}, -- [15]
			{
				info = {
					talentRankSpellIds = {
						48988, -- [1]
						49503, -- [2]
						49504, -- [3]
					},
					prereqs = {
						{
							column = 2,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Bloody Vengeance",
					wowTreeIndex = 7,
					column = 2,
					row = 6,
					icon = 132090,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					talentRankSpellIds = {
						53137, -- [1]
						53138, -- [2]
					},
					name = "Abomination's Might",
					wowTreeIndex = 26,
					column = 3,
					row = 6,
					icon = 236310,
					ranks = 2,
				},
			}, -- [17]
			{
				info = {
					talentRankSpellIds = {
						49027, -- [1]
						49542, -- [2]
						49543, -- [3]
					},
					name = "Bloodworms",
					wowTreeIndex = 18,
					column = 1,
					row = 7,
					icon = 136211,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49016, -- [1]
					},
					name = "Unholy Frenzy",
					wowTreeIndex = 13,
					column = 2,
					row = 7,
					icon = 237512,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					talentRankSpellIds = {
						50365, -- [1]
						50371, -- [2]
					},
					name = "Improved Blood Presence",
					wowTreeIndex = 1,
					column = 3,
					row = 7,
					icon = 135770,
					ranks = 2,
				},
			}, -- [20]
			{
				info = {
					talentRankSpellIds = {
						62905, -- [1]
						62908, -- [2]
					},
					name = "Improved Death Strike",
					wowTreeIndex = 28,
					column = 1,
					row = 8,
					icon = 237517,
					ranks = 2,
				},
			}, -- [21]
			{
				info = {
					talentRankSpellIds = {
						49018, -- [1]
						49529, -- [2]
						49530, -- [3]
					},
					name = "Sudden Doom",
					wowTreeIndex = 14,
					column = 2,
					row = 8,
					icon = 136181,
					ranks = 3,
				},
			}, -- [22]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						55233, -- [1]
					},
					name = "Vampiric Blood",
					wowTreeIndex = 23,
					column = 3,
					row = 8,
					icon = 136168,
					ranks = 1,
				},
			}, -- [23]
			{
				info = {
					talentRankSpellIds = {
						49189, -- [1]
						50149, -- [2]
						50150, -- [3]
					},
					name = "Will of the Necropolis",
					wowTreeIndex = 17,
					column = 1,
					row = 9,
					icon = 132094,
					ranks = 3,
				},
			}, -- [24]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						55050, -- [1]
					},
					name = "Heart Strike",
					wowTreeIndex = 15,
					column = 2,
					row = 9,
					icon = 135675,
					ranks = 1,
				},
			}, -- [25]
			{
				info = {
					talentRankSpellIds = {
						49023, -- [1]
						49533, -- [2]
						49534, -- [3]
					},
					name = "Might of Mograine",
					wowTreeIndex = 16,
					column = 3,
					row = 9,
					icon = 135771,
					ranks = 3,
				},
			}, -- [26]
			{
				info = {
					talentRankSpellIds = {
						50096, -- [1]
						50108, -- [2]
						50109, -- [3]
						50110, -- [4]
						50111, -- [5]
					},
					name = "Blood Gorged",
					wowTreeIndex = 24,
					column = 2,
					row = 10,
					icon = 136080,
					ranks = 5,
				},
			}, -- [27]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49028, -- [1]
					},
					name = "Dancing Rune Weapon",
					wowTreeIndex = 19,
					column = 2,
					row = 11,
					icon = 135277,
					ranks = 1,
				},
			}, -- [28]
		},
		info = {
			background = "DeathKnightBlood",
			name = "Blood",
			icon = 135770,
		},
	}, -- [1]
	{
		numtalents = 29,
		talents = {
			{
				info = {
					talentRankSpellIds = {
						49175, -- [1]
						50031, -- [2]
						51456, -- [3]
					},
					name = "Improved Icy Touch",
					wowTreeIndex = 19,
					column = 1,
					row = 1,
					icon = 237526,
					ranks = 3,
				},
			}, -- [1]
			{
				info = {
					talentRankSpellIds = {
						49455, -- [1]
						50147, -- [2]
					},
					name = "Runic Power Mastery",
					wowTreeIndex = 15,
					column = 2,
					row = 1,
					icon = 135728,
					ranks = 2,
				},
			}, -- [2]
			{
				info = {
					talentRankSpellIds = {
						12299, -- [1]
						12761, -- [2]
						12762, -- [3]
						12763, -- [4]
						12764, -- [5]
					},
					name = "Toughness",
					wowTreeIndex = 1,
					column = 3,
					row = 1,
					icon = 135892,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					talentRankSpellIds = {
						55061, -- [1]
						55062, -- [2]
					},
					name = "Icy Reach",
					wowTreeIndex = 20,
					column = 2,
					row = 2,
					icon = 135859,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					talentRankSpellIds = {
						49140, -- [1]
						49661, -- [2]
						49662, -- [3]
						49663, -- [4]
						49664, -- [5]
					},
					name = "Black Ice",
					wowTreeIndex = 3,
					column = 3,
					row = 2,
					icon = 136141,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					talentRankSpellIds = {
						49226, -- [1]
						50137, -- [2]
						50138, -- [3]
					},
					name = "Nerves of Cold Steel",
					wowTreeIndex = 16,
					column = 4,
					row = 2,
					icon = 132147,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					talentRankSpellIds = {
						50880, -- [1]
						50882, -- [2]
						50884, -- [3]
						50885, -- [4]
						50886, -- [5]
					},
					prereqs = {
						{
							column = 1,
							row = 1,
							source = 1,
						}, -- [1]
					},
					name = "Icy Talons",
					wowTreeIndex = 22,
					column = 1,
					row = 3,
					icon = 252994,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49039, -- [1]
					},
					name = "Lichborne",
					wowTreeIndex = 26,
					column = 2,
					row = 3,
					icon = 136187,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					talentRankSpellIds = {
						51468, -- [1]
						51472, -- [2]
						51473, -- [3]
					},
					name = "Annihilation",
					wowTreeIndex = 24,
					column = 3,
					row = 3,
					icon = 135609,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					talentRankSpellIds = {
						51123, -- [1]
						51124, -- [2]
						51127, -- [3]
						51128, -- [4]
						51129, -- [5]
					},
					name = "Killing Machine",
					wowTreeIndex = 23,
					column = 2,
					row = 4,
					icon = 135305,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					talentRankSpellIds = {
						49149, -- [1]
						50115, -- [2]
					},
					name = "Chill of the Grave",
					wowTreeIndex = 7,
					column = 3,
					row = 4,
					icon = 135849,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					talentRankSpellIds = {
						49137, -- [1]
						49657, -- [2]
					},
					name = "Endless Winter",
					wowTreeIndex = 2,
					column = 4,
					row = 4,
					icon = 136223,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					talentRankSpellIds = {
						49186, -- [1]
						51108, -- [2]
						51109, -- [3]
					},
					name = "Frigid Dreadplate",
					wowTreeIndex = 9,
					column = 2,
					row = 5,
					icon = 132734,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					talentRankSpellIds = {
						49471, -- [1]
						49790, -- [2]
						49791, -- [3]
					},
					name = "Glacier Rot",
					wowTreeIndex = 18,
					column = 3,
					row = 5,
					icon = 136083,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49796, -- [1]
					},
					name = "Deathchill",
					wowTreeIndex = 6,
					column = 4,
					row = 5,
					icon = 136213,
					ranks = 1,
				},
			}, -- [15]
			{
				info = {
					talentRankSpellIds = {
						55610, -- [1]
					},
					prereqs = {
						{
							column = 1,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Improved Icy Talons",
					wowTreeIndex = 27,
					column = 1,
					row = 6,
					icon = 252994,
					ranks = 1,
				},
			}, -- [16]
			{
				info = {
					talentRankSpellIds = {
						49024, -- [1]
						49538, -- [2]
					},
					name = "Merciless Combat",
					wowTreeIndex = 11,
					column = 2,
					row = 6,
					icon = 135294,
					ranks = 2,
				},
			}, -- [17]
			{
				info = {
					talentRankSpellIds = {
						49188, -- [1]
						56822, -- [2]
						59057, -- [3]
					},
					name = "Rime",
					wowTreeIndex = 10,
					column = 3,
					row = 6,
					icon = 135840,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					talentRankSpellIds = {
						50040, -- [1]
						50041, -- [2]
						50043, -- [3]
					},
					name = "Chilblains",
					wowTreeIndex = 28,
					column = 1,
					row = 7,
					icon = 135864,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49203, -- [1]
					},
					name = "Hungering Cold",
					wowTreeIndex = 14,
					column = 2,
					row = 7,
					icon = 135152,
					ranks = 1,
				},
			}, -- [20]
			{
				info = {
					talentRankSpellIds = {
						50384, -- [1]
						50385, -- [2]
					},
					name = "Improved Frost Presence",
					wowTreeIndex = 17,
					column = 3,
					row = 7,
					icon = 135773,
					ranks = 2,
				},
			}, -- [21]
			{
				info = {
					talentRankSpellIds = {
						65661, -- [1]
						66191, -- [2]
						66192, -- [3]
					},
					name = "Threat of Thassarian",
					wowTreeIndex = 29,
					column = 1,
					row = 8,
					icon = 132148,
					ranks = 3,
				},
			}, -- [22]
			{
				info = {
					talentRankSpellIds = {
						54637, -- [1]
						54638, -- [2]
						54639, -- [3]
					},
					name = "Blood of the North",
					wowTreeIndex = 25,
					column = 2,
					row = 8,
					icon = 135714,
					ranks = 3,
				},
			}, -- [23]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						51271, -- [1]
					},
					name = "Unbreakable Armor",
					wowTreeIndex = 5,
					column = 3,
					row = 8,
					icon = 132388,
					ranks = 1,
				},
			}, -- [24]
			{
				info = {
					talentRankSpellIds = {
						49200, -- [1]
						50151, -- [2]
						50152, -- [3]
					},
					name = "Acclimation",
					wowTreeIndex = 12,
					column = 1,
					row = 9,
					icon = 135791,
					ranks = 3,
				},
			}, -- [25]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						43568, -- [1]
					},
					name = "Frost Strike",
					wowTreeIndex = 4,
					column = 2,
					row = 9,
					icon = 237520,
					ranks = 1,
				},
			}, -- [26]
			{
				info = {
					talentRankSpellIds = {
						50187, -- [1]
						50190, -- [2]
						50191, -- [3]
					},
					name = "Guile of Gorefiend",
					wowTreeIndex = 21,
					column = 3,
					row = 9,
					icon = 132373,
					ranks = 3,
				},
			}, -- [27]
			{
				info = {
					talentRankSpellIds = {
						49202, -- [1]
						50127, -- [2]
						50128, -- [3]
						50129, -- [4]
						50130, -- [5]
					},
					name = "Tundra Stalker",
					wowTreeIndex = 13,
					column = 2,
					row = 10,
					icon = 136107,
					ranks = 5,
				},
			}, -- [28]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49184, -- [1]
					},
					name = "Howling Blast",
					wowTreeIndex = 8,
					column = 2,
					row = 11,
					icon = 135833,
					ranks = 1,
				},
			}, -- [29]
		},
		info = {
			background = "DeathKnightFrost",
			name = "Frost",
			icon = 135773,
		},
	}, -- [2]
	{
		numtalents = 31,
		talents = {
			{
				info = {
					talentRankSpellIds = {
						51745, -- [1]
						51746, -- [2]
					},
					name = "Vicious Strikes",
					wowTreeIndex = 24,
					column = 1,
					row = 1,
					icon = 135774,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					talentRankSpellIds = {
						48962, -- [1]
						49567, -- [2]
						49568, -- [3]
					},
					name = "Virulence",
					wowTreeIndex = 1,
					column = 2,
					row = 1,
					icon = 136126,
					ranks = 3,
				},
			}, -- [2]
			{
				info = {
					talentRankSpellIds = {
						12297, -- [1]
						12750, -- [2]
						12751, -- [3]
						12752, -- [4]
						12753, -- [5]
					},
					name = "Anticipation",
					wowTreeIndex = 27,
					column = 3,
					row = 1,
					icon = 136056,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					talentRankSpellIds = {
						49036, -- [1]
						49562, -- [2]
					},
					name = "Epidemic",
					wowTreeIndex = 5,
					column = 1,
					row = 2,
					icon = 136207,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					talentRankSpellIds = {
						48963, -- [1]
						49564, -- [2]
						49565, -- [3]
					},
					name = "Morbidity",
					wowTreeIndex = 2,
					column = 2,
					row = 2,
					icon = 136144,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					talentRankSpellIds = {
						49588, -- [1]
						49589, -- [2]
					},
					name = "Unholy Command",
					wowTreeIndex = 19,
					column = 3,
					row = 2,
					icon = 237532,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					talentRankSpellIds = {
						48965, -- [1]
						49571, -- [2]
						49572, -- [3]
					},
					name = "Ravenous Dead",
					wowTreeIndex = 3,
					column = 4,
					row = 2,
					icon = 237524,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					talentRankSpellIds = {
						49013, -- [1]
						50304, -- [2]
						55236, -- [3]
					},
					name = "Outbreak",
					wowTreeIndex = 15,
					column = 1,
					row = 3,
					icon = 136182,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					talentRankSpellIds = {
						51459, -- [1]
						51460, -- [2]
						51462, -- [3]
						51463, -- [4]
						51464, -- [5]
					},
					name = "Necrosis",
					wowTreeIndex = 23,
					column = 2,
					row = 3,
					icon = 135695,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						17616, -- [1]
					},
					name = "Corpse Explosion",
					wowTreeIndex = 7,
					column = 3,
					row = 3,
					icon = 132099,
					ranks = 1,
				},
			}, -- [10]
			{
				info = {
					talentRankSpellIds = {
						49146, -- [1]
						51267, -- [2]
					},
					name = "On a Pale Horse",
					wowTreeIndex = 21,
					column = 2,
					row = 4,
					icon = 237534,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					talentRankSpellIds = {
						49219, -- [1]
						49627, -- [2]
						49628, -- [3]
					},
					name = "Blood-Caked Blade",
					wowTreeIndex = 12,
					column = 3,
					row = 4,
					icon = 132109,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					talentRankSpellIds = {
						55620, -- [1]
						55623, -- [2]
					},
					name = "Night of the Dead",
					wowTreeIndex = 29,
					column = 4,
					row = 4,
					icon = 237511,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49194, -- [1]
					},
					name = "Unholy Blight",
					wowTreeIndex = 8,
					column = 1,
					row = 5,
					icon = 136132,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					talentRankSpellIds = {
						49220, -- [1]
						49633, -- [2]
						49635, -- [3]
						49636, -- [4]
						49638, -- [5]
					},
					name = "Impurity",
					wowTreeIndex = 13,
					column = 2,
					row = 5,
					icon = 136196,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					talentRankSpellIds = {
						29699, -- [1]
						49223, -- [2]
					},
					name = "Dirge",
					wowTreeIndex = 17,
					column = 3,
					row = 5,
					icon = 136194,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					talentRankSpellIds = {
						36473, -- [1]
						55666, -- [2]
					},
					name = "Desecration",
					wowTreeIndex = 30,
					column = 1,
					row = 6,
					icon = 136199,
					ranks = 2,
				},
			}, -- [17]
			{
				info = {
					talentRankSpellIds = {
						49224, -- [1]
						49610, -- [2]
						49611, -- [3]
					},
					name = "Magic Suppression",
					wowTreeIndex = 16,
					column = 2,
					row = 6,
					icon = 136120,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					talentRankSpellIds = {
						49208, -- [1]
						56834, -- [2]
						56835, -- [3]
					},
					name = "Reaping",
					wowTreeIndex = 10,
					column = 3,
					row = 6,
					icon = 136195,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					talentRankSpellIds = {
						52143, -- [1]
					},
					prereqs = {
						{
							column = 4,
							row = 4,
							source = 13,
						}, -- [1]
					},
					name = "Master of Ghouls",
					wowTreeIndex = 6,
					column = 4,
					row = 6,
					icon = 136119,
					ranks = 1,
				},
			}, -- [20]
			{
				info = {
					talentRankSpellIds = {
						63583, -- [1]
						66799, -- [2]
						66800, -- [3]
						66801, -- [4]
						66802, -- [5]
					},
					name = "Desolation",
					wowTreeIndex = 31,
					column = 1,
					row = 7,
					icon = 136224,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					isExceptional = 1,
					prereqs = {
						{
							column = 2,
							row = 6,
							source = 18,
						}, -- [1]
					},
					ranks = 1,
					name = "Anti-Magic Zone",
					talentRankSpellIds = {
						50461, -- [1]
					},
					column = 2,
					row = 7,
					icon = 237510,
					wowTreeIndex = 28,
				},
			}, -- [22]
			{
				info = {
					talentRankSpellIds = {
						50391, -- [1]
						50392, -- [2]
					},
					name = "Improved Unholy Presence",
					wowTreeIndex = 18,
					column = 3,
					row = 7,
					icon = 135775,
					ranks = 2,
				},
			}, -- [23]
			{
				info = {
					isExceptional = 1,
					prereqs = {
						{
							column = 4,
							row = 6,
							source = 20,
						}, -- [1]
					},
					ranks = 1,
					name = "Ghoul Frenzy",
					talentRankSpellIds = {
						63560, -- [1]
					},
					column = 4,
					row = 7,
					icon = 132152,
					wowTreeIndex = 25,
				},
			}, -- [24]
			{
				info = {
					talentRankSpellIds = {
						49032, -- [1]
						49631, -- [2]
						49632, -- [3]
					},
					name = "Crypt Fever",
					wowTreeIndex = 4,
					column = 2,
					row = 8,
					icon = 136066,
					ranks = 3,
				},
			}, -- [25]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						27688, -- [1]
					},
					name = "Bone Shield",
					wowTreeIndex = 14,
					column = 3,
					row = 8,
					icon = 132728,
					ranks = 1,
				},
			}, -- [26]
			{
				info = {
					talentRankSpellIds = {
						3436, -- [1]
						3439, -- [2]
						8247, -- [3]
					},
					name = "Wandering Plague",
					wowTreeIndex = 11,
					column = 1,
					row = 9,
					icon = 136127,
					ranks = 3,
				},
			}, -- [27]
			{
				info = {
					talentRankSpellIds = {
						51099, -- [1]
						51160, -- [2]
						51161, -- [3]
					},
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 25,
						}, -- [1]
					},
					name = "Ebon Plaguebringer",
					wowTreeIndex = 22,
					column = 2,
					row = 9,
					icon = 132095,
					ranks = 3,
				},
			}, -- [28]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						28265, -- [1]
					},
					name = "Scourge Strike",
					wowTreeIndex = 26,
					column = 3,
					row = 9,
					icon = 237530,
					ranks = 1,
				},
			}, -- [29]
			{
				info = {
					talentRankSpellIds = {
						50117, -- [1]
						50118, -- [2]
						50119, -- [3]
						50120, -- [4]
						50121, -- [5]
					},
					name = "Rage of Rivendare",
					wowTreeIndex = 20,
					column = 2,
					row = 10,
					icon = 135564,
					ranks = 5,
				},
			}, -- [30]
			{
				info = {
					isExceptional = 1,
					talentRankSpellIds = {
						49206, -- [1]
					},
					name = "Summon Gargoyle",
					wowTreeIndex = 9,
					column = 2,
					row = 11,
					icon = 132182,
					ranks = 1,
				},
			}, -- [31]
		},
		info = {
			background = "DeathKnightUnholy",
			name = "Unholy",
			icon = 135775,
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