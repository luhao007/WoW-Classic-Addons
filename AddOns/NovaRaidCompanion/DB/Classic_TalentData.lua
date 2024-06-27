----------------------------------
---NovaRaidCompanion Talent Data--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isClassic) then
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
			iconPath = "Interface\\Icons\\Interface/Icons/Ability_Marksmanship",
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
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Improved Wrath",
					ranks = 5,
					column = 1,
					icon = 136006,
					row = 1,
					tips = "Reduces the cast time of your Wrath spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [1]
			{
				info = {
					ranks = 1,
					name = "Nature's Grasp",
					icon = 136063,
					column = 2,
					exceptional = 1,
					row = 1,
					tips = "While active, any time an enemy strikes the caster they have a 35%% chance to become afflicted by Entangling Roots (Rank 1).  Only useable outdoors.  1 charge.  Lasts 45 sec.",
					tipValues = {},
				},
			}, -- [2]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 1,
							source = 2,
						}, -- [1]
					},
					name = "Improved Nature's Grasp",
					ranks = 4,
					column = 3,
					icon = 136063,
					row = 1,
					tips = "Increases the chance for your Nature's Grasp to entangle an enemy by %d%%.",
					tipValues = {{15}, {30}, {45}, {65}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Entangling Roots",
					ranks = 3,
					column = 1,
					icon = 136100,
					row = 2,
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting Entangling Roots.",
					tipValues = {{40}, {70}, {100}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Moonfire",
					ranks = 5,
					column = 2,
					icon = 136096,
					row = 2,
					tips = "Increases the damage and critical strike chance of your Moonfire spell by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [5]
			{
				info = {
					name = "Natural Weapons",
					ranks = 5,
					column = 3,
					icon = 135138,
					row = 2,
					tips = "Increases the damage you deal with physical attacks in all forms by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [6]
			{
				info = {
					name = "Natural Shapeshifter",
					ranks = 3,
					column = 4,
					icon = 136116,
					row = 2,
					tips = "Reduces the mana cost of all shapeshifting by %d%%.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [7]
			{
				info = {
					name = "Improved Thorns",
					ranks = 3,
					column = 1,
					icon = 136104,
					row = 3,
					tips = "Increases damage caused by your Thorns spell by %d%%.",
					tipValues = {{25}, {50}, {75}}
				},
			}, -- [8]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 6,
						}, -- [1]
					},
					name = "Omen of Clarity",
					icon = 136017,
					column = 3,
					exceptional = 1,
					row = 3,
					tips = "Imbues the Druid with natural energy.  Each of the Druid's melee attacks has a chance of causing the caster to enter a Clearcasting state.  The Clearcasting state reduces the Mana, Rage or Energy cost of your next damage or healing spell or offensive ability by 100%%.  Lasts 10 min.",
					tipValues = {},
				},
			}, -- [9]
			{
				info = {
					name = "Nature's Reach",
					ranks = 2,
					column = 4,
					icon = 136065,
					row = 3,
					tips = "Increases the range of your Wrath, Entangling Roots, Faerie Fire, Moonfire, Starfire, and Hurricane spells by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [10]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 5,
						}, -- [1]
					},
					name = "Vengeance",
					ranks = 5,
					column = 2,
					icon = 136075,
					row = 4,
					tips = "Increases the critical strike damage bonus of your Starfire, Moonfire, and Wrath spells by %d%%.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Starfire",
					ranks = 5,
					column = 3,
					icon = 135753,
					row = 4,
					tips = "Reduces the cast time of Starfire by %.1f sec and has a %d%% chance to stun the target for 3 sec.",
					tipValues = {{0.1, 3}, {0.2, 6}, {0.3, 9}, {0.4, 12}, {0.5, 15}}, 
				},
			}, -- [12]
			{
				info = {
					name = "Nature's Grace",
					ranks = 1,
					column = 2,
					icon = 136062,
					row = 5,
					tips = "All spell criticals grace you with a blessing of nature, reducing the casting time of your next spell by 0.5 sec.",
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					name = "Moonglow",
					ranks = 3,
					column = 3,
					icon = 136087,
					row = 5,
					tips = "Reduces the Mana cost of your Moonfire, Starfire, Wrath, Healing Touch, Regrowth and Rejuvenation spells by %d%%.",
					tipValues = {{3}, {6}, {9}},
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Moonfury",
					ranks = 5,
					column = 2,
					icon = 136057,
					row = 6,
					tips = "Increases the damage done by your Starfire, Moonfire and Wrath spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					name = "Moonkin Form",
					icon = 136036,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Transforms the Druid into Moonkin Form.  While in this form the armor contribution from items is increased by 360%% and all party members within 30 yards have their spell critical chance increased by 3%%.  The Moonkin can only cast Balance spells while shapeshifted.\r\n\r\nThe act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			name = "Balance",
			background = "DruidBalance",
		},
	}, -- [1]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Ferocity",
					ranks = 5,
					column = 2,
					icon = 132190,
					row = 1,
					tips = "Reduces the cost of your Maul, Swipe, Claw, and Rake abilities by %d Rage or Energy.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [1]
			{
				info = {
					name = "Feral Aggression",
					ranks = 5,
					column = 3,
					icon = 132121,
					row = 1,
					tips = "Increases the Attack Power reduction of your Demoralizing Roar by %d%% and the damage caused by your Ferocious Bite by %d%%.",
					tipValues = {{8, 3}, {16, 6}, {24, 9}, {32, 12}, {40, 15}}, 
				},
			}, -- [2]
			{
				info = {
					name = "Feral Instinct",
					ranks = 5,
					column = 1,
					icon = 132089,
					row = 2,
					tips = "Increases threat caused in Bear and Dire Bear Form by %d%% and reduces the chance enemies have to detect you while Prowling.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [3]
			{
				info = {
					name = "Brutal Impact",
					ranks = 2,
					column = 2,
					icon = 132114,
					row = 2,
					tips = "Increases the stun duration of your Bash and Pounce abilities by %.1f sec.",
					tipValues = {{0.5}, {1.0}}
				},
			}, -- [4]
			{
				info = {
					name = "Thick Hide",
					ranks = 5,
					column = 3,
					icon = 134355,
					row = 2,
					tips = "Increases your Armor contribution from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [5]
			{
				info = {
					name = "Feline Swiftness",
					ranks = 2,
					column = 1,
					icon = 136095,
					row = 3,
					tips = "Increases your movement speed by %d%% while outdoors in Cat Form and increases your chance to dodge while in Cat Form by %d%%.",
					tipValues = {{15, 2}, {30, 4}}
				},
			}, -- [6]
			{
				info = {
					ranks = 1,
					name = "Feral Charge",
					icon = 132183,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Causes you to charge an enemy, immobilizing and interrupting any spell being cast for 4 sec.",
					tipValues = {},
				},
			}, -- [7]
			{
				info = {
					name = "Sharpened Claws",
					ranks = 3,
					column = 3,
					icon = 134297,
					row = 3,
					tips = "Increases your critical strike chance while in Bear, Dire Bear or Cat Form by %d%%.",
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [8]
			{
				info = {
					name = "Improved Shred",
					ranks = 2,
					column = 1,
					icon = 136231,
					row = 4,
					tips = "Reduces the Energy cost of your Shred ability by %d.",
					tipValues = {{6}, {12}}
				},
			}, -- [9]
			{
				info = {
					name = "Predatory Strikes",
					ranks = 3,
					column = 2,
					icon = 132185,
					row = 4,
					tips = "Increases your melee attack power in Cat, Bear and Dire Bear Forms by %d%% of your level.",
					tipValues = {{50}, {100}, {150}}
				},
			}, -- [10]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Blood Frenzy",
					ranks = 2,
					column = 3,
					icon = 132152,
					row = 4,
					tips = "Your critical strikes from Cat Form abilities that add combo points  have a %d%% chance to add an additional combo point.",
					tipValues = {{50}, {100}}
				},
			}, -- [11]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Primal Fury",
					ranks = 2,
					column = 4,
					icon = 132278,
					row = 4,
					tips = "Gives you a %d%% chance to gain an additional 5 Rage anytime you get a critical strike while in Bear and Dire Bear Form.",
					tipValues = {{50}, {100}}
				},
			}, -- [12]
			{
				info = {
					name = "Savage Fury",
					ranks = 2,
					column = 1,
					icon = 132141,
					row = 5,
					tips = "Increases the damage caused by your Claw, Rake, Maul and Swipe abilities by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [13]
			{
				info = {
					ranks = 1,
					name = "Faerie Fire (Feral)",
					icon = 136033,
					column = 3,
					exceptional = 1,
					row = 5,
					tips = "Decrease the armor of the target by 175 for 40 sec.  While affected, the target cannot stealth or turn invisible.",
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 10,
						}, -- [1]
					},
					name = "Heart of the Wild",
					ranks = 5,
					column = 2,
					icon = 135879,
					row = 6,
					tips = "Increases your Intellect by %d%%.  In addition, while in Bear or Dire Bear Form your Stamina is increased by %d%% and while in Cat Form your Strength is increased by %d%%.",
					tipValues = {{4, 4, 4},{8, 8, 8}, {12, 12, 12},{16, 16, 16}, {20, 20, 20}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					name = "Leader of the Pack",
					icon = 136112,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "While in Cat, Bear or Dire Bear Form, the Leader of the Pack increases ranged and melee critical chance of all party members within 45 yards by 3%%.",
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			name = "Feral Combat",
			background = "DruidFeralCombat",
		},
	}, -- [2]
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Improved Mark of the Wild",
					ranks = 5,
					column = 2,
					icon = 136078,
					row = 1,
					tips = "Increases the effects of your Mark of the Wild and Gift of the Wild spells by %d%%.",
					tipValues = {{7}, {14}, {21}, {28}, {35}}
				},
			}, -- [1]
			{
				info = {
					name = "Furor",
					ranks = 5,
					column = 3,
					icon = 135881,
					row = 1,
					tips = "Gives you %d%% chance to gain 10 Rage when you shapeshift into Bear and Dire Bear Form or 40 Energy when you shapeshift into Cat Form.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Healing Touch",
					ranks = 5,
					column = 1,
					icon = 136041,
					row = 2,
					tips = "Reduces the cast time of your Healing Touch spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [3]
			{
				info = {
					name = "Nature's Focus",
					ranks = 5,
					column = 2,
					icon = 136042,
					row = 2,
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting the Healing Touch, Regrowth and Tranquility spells.",
					tipValues = {{14}, {28}, {42}, {56}, {70}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Enrage",
					ranks = 2,
					column = 3,
					icon = 132126,
					row = 2,
					tips = "The Enrage ability now instantly generates %d Rage.",
					tipValues = {{5}, {10}}
				},
			}, -- [5]
			{
				info = {
					name = "Reflection",
					ranks = 3,
					column = 2,
					icon = 135863,
					row = 3,
					tips = "Allows %d%% of your Mana regeneration to continue while casting.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [6]
			{
				info = {
					ranks = 1,
					name = "Insect Swarm",
					icon = 136045,
					column = 3,
					exceptional = 1,
					row = 3,
					tips = "The enemy target is swarmed by insects, decreasing their chance to hit by 2%% and causing 66 Nature damage over 12 sec.",
					tipValues = {},
				},
			}, -- [7]
			{
				info = {
					name = "Subtlety",
					ranks = 5,
					column = 4,
					icon = 132150,
					row = 3,
					tips = "Reduces the threat generated by your Healing spells by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [8]
			{
				info = {
					name = "Tranquil Spirit",
					ranks = 5,
					column = 2,
					icon = 135900,
					row = 4,
					tips = "Reduces the mana cost of your Healing Touch and Tranquility spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Rejuvenation",
					ranks = 3,
					column = 4,
					icon = 136081,
					row = 4,
					tips = "Increases the effect of your Rejuvenation spell by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [10]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 1,
							row = 2,
							source = 3,
						}, -- [1]
					},
					name = "Nature's Swiftness",
					icon = 136076,
					column = 1,
					exceptional = 1,
					row = 5,
					tips = "When activated, your next Nature spell becomes an instant cast spell.",
					tipValues = {},
				},
			}, -- [11]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Gift of Nature",
					ranks = 5,
					column = 3,
					icon = 136074,
					row = 5,
					tips = "Increases the effect of all healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [12]
			{
				info = {
					name = "Improved Tranquility",
					ranks = 2,
					column = 4,
					icon = 136107,
					row = 5,
					tips = "Reduces threat caused by Tranquility by %d%%.",
					tipValues = {{50}, {100}}
				},
			}, -- [13]
			{
				info = {
					name = "Improved Regrowth",
					ranks = 5,
					column = 3,
					icon = 136085,
					row = 6,
					tips = "Increases the critical effect chance of your Regrowth spell by %d%%.",
					tipValues = {{10}, {20}, {30}, {40}, {50}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 9,
						}, -- [1]
					},
					name = "Swiftmend",
					icon = 134914,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Consumes a Rejuvenation or Regrowth effect on a friendly target to instantly heal them an amount equal to 12 sec. of Rejuvenation or 18 sec. of Regrowth.",
					tipValues = {},
				},
			}, -- [15]
		},
		info = {
			name = "Restoration",
			background = "DruidRestoration",
		},
	} -- [3]
};

talents.hunter = {
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Improved Aspect of the Hawk",
					tips = "While Aspect of the Hawk is active, all normal ranged attacks have a %d%% chance of increasing ranged attack speed by 30%% for 12 sec.",
					column = 2,
					row = 1,
					icon = 136076,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [1]
			{
				info = {
					name = "Endurance Training",
					tips = "Increases the Health of your pets by %d%%.",
					column = 3,
					row = 1,
					icon = 136080,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Eyes of the Beast",
					tips = "Increases the duration of your Eyes of the Beast by %d sec.",
					column = 1,
					row = 2,
					icon = 132150,
					ranks = 2,
					tipValues = {{30}, {60}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Aspect of the Monkey",
					tips = "Increases the Dodge bonus of your Aspect of the Monkey by %d%%.",
					column = 2,
					row = 2,
					icon = 132159,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [4]
			{
				info = {
					name = "Thick Hide",
					tips = "Increases the Armor rating of your pets by %d%%.",
					column = 3,
					row = 2,
					icon = 134355,
					ranks = 3,
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Revive Pet",
					tips = "Revive Pet's casting time is reduced by %d sec, mana cost is reduced by %d%%, and increases the health your pet returns with by an additional %d%%.",
					column = 4,
					row = 2,
					icon = 132163,
					ranks = 2,
					tipValues = {{3, 20, 15}, {6, 40, 30}}
					

				},
			}, -- [6]
			{
				info = {
					name = "Pathfinding",
					tips = "Increases the speed bonus of your Aspect of the Cheetah and Aspect of the Pack by %d%%.",
					column = 1,
					row = 3,
					icon = 132242,
					ranks = 2,
					tipValues = {{3}, {6}}
				},
			}, -- [7]
			{
				info = {
					name = "Bestial Swiftness",
					tips = "Increases the outdoor movement speed of your pets by 30%%.",
					column = 2,
					row = 3,
					icon = 132120,
					ranks = 1,
					tipValues = {},
				},
			}, -- [8]
			{
				info = {
					name = "Unleashed Fury",
					tips = "Increases the damage done by your pets by %d%%.",
					column = 3,
					row = 3,
					icon = 132091,
					ranks = 5,
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Mend Pet",
					tips = "Gives the Mend Pet spell a %d%% chance of cleansing 1 Curse, Disease, Magic or Poison effect from the pet each tick.",
					column = 2,
					row = 4,
					icon = 132179,
					ranks = 2,
					tipValues = {{15}, {50}}
				},
			}, -- [10]
			{
				info = {
					name = "Ferocity",
					tips = "Increases the critical strike chance of your pets by %d%%.",
					column = 3,
					row = 4,
					icon = 134297,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [11]
			{
				info = {
					name = "Spirit Bond",
					tips = "While your pet is active, you and your pet will regenerate %d%% of total health every 10 sec.",
					column = 1,
					row = 5,
					icon = 132121,
					ranks = 2,
					tipValues = {{1}, {2}}
				},
			}, -- [12]
			{
				info = {
					tips = "Command your pet to intimidate the target on the next successful melee attack, causing a high amount of threat and stunning the target for 3 sec.",
					name = "Intimidation",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132111,
					ranks = 1,
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					name = "Bestial Discipline",
					tips = "Increases the Focus regeneration of your pets by %d%%.",
					column = 4,
					row = 5,
					icon = 136006,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 11,
						}, -- [1]
					},
					name = "Frenzy",
					tips = "Gives your pet a %d%% chance to gain a 30%% attack speed increase for 8 sec after dealing a critical strike.",
					column = 3,
					row = 6,
					icon = 134296,
					ranks = 5,
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [15]
			{
				info = {
					tips = "Send your pet into a rage causing 50%% additional damage for 18 sec.  While enraged, the beast does not feel pity or remorse or fear and it cannot be stopped unless killed.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Bestial Wrath",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 132127,
					ranks = 1,
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			name = "Beast Mastery",
			background = "HunterBeastMastery",
		},
	}, -- [1]
	{
		numtalents = 14,
		talents = {
			{
				info = {
					name = "Improved Concussive Shot",
					tips = "Gives your Concussive Shot a %d%% chance to stun the target for 3 sec.",
					column = 2,
					row = 1,
					icon = 135860,
					ranks = 5,
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [1]
			{
				info = {
					name = "Efficiency",
					tips = "Reduces the Mana cost of your Shots and Stings by %d%%.",
					column = 3,
					row = 1,
					icon = 135865,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Hunter's Mark",
					tips = "Increases the Ranged Attack Power bonus of your Hunter's Mark spell by %d%%.",
					column = 2,
					row = 2,
					icon = 132212,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [3]
			{
				info = {
					name = "Lethal Shots",
					tips = "Increases your critical strike chance with ranged weapons by %d%%.",
					column = 3,
					row = 2,
					icon = 132312,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [4]
			{
				info = {
					tips = "An aimed shot that increases ranged damage by 70.",
					name = "Aimed Shot",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 135130,
					ranks = 1,
					tipValues = {},
				},
			}, -- [5]
			{
				info = {
					name = "Improved Arcane Shot",
					tips = "Reduces the cooldown of your Arcane Shot by %.1f sec.",
					column = 2,
					row = 3,
					icon = 132218,
					ranks = 5,
					tipValues = {{0.2}, {0.4}, {0.6}, {0.8}, {1.0}}
				},
			}, -- [6]
			{
				info = {
					name = "Hawk Eye",
					tips = "Increases the range of your ranged weapons by %d yards.",
					column = 4,
					row = 3,
					icon = 132327,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [7]
			{
				info = {
					name = "Improved Serpent Sting",
					tips = "Increases the damage done by your Serpent Sting by %d%%.",
					column = 2,
					row = 4,
					icon = 132204,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [8]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 4,
						}, -- [1]
					},
					name = "Mortal Shots",
					tips = "Increases your ranged weapon critical strike damage bonus by %d%%.",
					column = 3,
					row = 4,
					icon = 132271,
					ranks = 5,
					tipValues = {{6}, {12}, {18}, {24}, {30}}
				},
			}, -- [9]
			{
				info = {
					tips = "A short-range shot that deals 50%% weapon damage and disorients the target for 4 sec.  Any damage caused will remove the effect.  Turns off your attack when used.",
					name = "Scatter Shot",
					row = 5,
					column = 1,
					exceptional = 1,
					icon = 132153,
					ranks = 1,
					tipValues = {},
				},
			}, -- [10]
			{
				info = {
					name = "Barrage",
					tips = "Increases the damage done by your Multi-Shot and Volley spells by %d%%.",
					column = 2,
					row = 5,
					icon = 132330,
					ranks = 3,
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Scorpid Sting",
					tips = "Reduces the Stamina of targets affected by your Scorpid Sting by %d%% of the amount of Strength reduced.",
					column = 3,
					row = 5,
					icon = 132169,
					ranks = 3,
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [12]
			{
				info = {
					name = "Ranged Weapon Specialization",
					tips = "Increases the damage you deal with ranged weapons by %d%%.",
					column = 3,
					row = 6,
					icon = 135615,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [13]
			{
				info = {
					tips = "Increases the attack power of party members within 45 yards by 50.  Lasts 30 min.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 11,
						}, -- [1]
					},
					name = "Trueshot Aura",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 132329,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
		},
		info = {
			name = "Marksmanship",
			background = "HunterMarksmanship",
		},
	}, -- [2]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					tips = "Increases all damage caused against Beasts, Giants and Dragonkin targets by %d%% and increases critical damage caused against Beasts, Giants and Dragonkin targets by an additional %d%%.",
					name = "Monster Slaying",
					column = 1,
					row = 1,
					icon = 134154,
					ranks = 3,
					tipValues = {{1, 1}, {2, 2}, {3, 3}}
				},
			}, -- [1]
			{
				info = {
					tips = "Increases all damage caused against Humanoid targets by %d%% and increases critical damage caused against Humanoid targets by an additional %d%%.",
					name = "Humanoid Slaying",
					column = 2,
					row = 1,
					icon = 135942,
					ranks = 3,
					tipValues = {{1, 1}, {2, 2}, {3, 3}}
				},
			}, -- [2]
			{
				info = {
					tips = "Increases your Parry chance by %d%%.",
					name = "Deflection",
					column = 3,
					row = 1,
					icon = 132269,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [3]
			{
				info = {
					tips = "Gives your Immolation Trap, Frost Trap, and Explosive Trap a %d%% chance to entrap the target, preventing them from moving for 5 sec.",
					name = "Entrapment",
					column = 1,
					row = 2,
					icon = 136100,
					ranks = 5,
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [4]
			{
				info = {
					tips = "Increases the critical strike chance of Raptor Strike and Mongoose Bite by %d%%.",
					name = "Savage Strikes",
					column = 2,
					row = 2,
					icon = 132277,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [5]
			{
				info = {
					tips = "Gives your Wing Clip ability a %d%% chance to immobilize the target for 5 sec.",
					name = "Improved Wing Clip",
					column = 3,
					row = 2,
					icon = 132309,
					ranks = 5,
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [6]
			{
				info = {
					tips = "Increases the duration of Freezing and Frost trap effects by %d%% and the damage of Immolation and Explosive trap effects by %d%%.",
					name = "Clever Traps",
					column = 1,
					row = 3,
					icon = 136106,
					ranks = 2,
					tipValues = {{15, 15}, {30, 30}}
				},
			}, -- [7]
			{
				info = {
					tips = "Increases total health by %d%%.",
					name = "Survivalist",
					column = 2,
					row = 3,
					icon = 136223,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [8]
			{
				info = {
					tips = "When activated, increases your Dodge and Parry chance by 25%% for 10 sec.",
					name = "Deterrence",
					exceptional = 1,
					column = 3,
					row = 3,
					icon = 132369,
					ranks = 1,
					tipValues = {},
				},
			}, -- [9]
			{
				info = {
					tips = "Decreases the chance enemies will resist trap effects by %d%%.",
					name = "Trap Mastery",
					column = 1,
					row = 4,
					icon = 132149,
					ranks = 2,
					tipValues = {{5}, {10}}
				},
			}, -- [10]
			{
				info = {
					tips = "Increases hit chance by %d%% and increases the chance movement impairing effects will be resisted by an additional %d%%.",
					name = "Surefooted",
					column = 2,
					row = 4,
					icon = 132219,
					ranks = 3,
					tipValues = {{1, 5}, {2, 10}, {3, 15}}
				},
			}, -- [11]
			{
				info = {
					tips = "Reduces the chance your Feign Death ability will be resisted by %d%%.",
					name = "Improved Feign Death",
					column = 4,
					row = 4,
					icon = 132293,
					ranks = 2,
					tipValues = {{2}, {4}}
				},
			}, -- [12]
			{
				info = {
					tips = "Increases your critical strike chance with all attacks by %d%%.",
					name = "Killer Instinct",
					column = 2,
					row = 5,
					icon = 135881,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [13]
			{
				info = {
					tips = "A strike that becomes active after parrying an opponent's attack.  This attack deals 40 damage and immobilizes the target for 5 sec.  Counterattack cannot be blocked, dodged, or parried.",
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Counterattack",
					exceptional = 1,
					column = 3,
					row = 5,
					icon = 132336,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					tips = "Increases your Agility by %d%%.",
					name = "Lightning Reflexes",
					column = 3,
					row = 6,
					icon = 136047,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [15]
			{
				info = {
					tips = "A stinging shot that puts the target to sleep for 12 sec.  Any damage will cancel the effect.  When the target wakes up, the Sting causes 300 Nature damage over 12 sec.  Only usable out of combat.  Only one Sting per Hunter can be active on the target at a time.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Wyvern Sting",
					exceptional = 1,
					column = 2,
					row = 7,
					icon = 135125,
					ranks = 1,
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			background = "HunterSurvival",
			name = "Survival",
		},
	}, -- [3]
};

talents.mage = {
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Arcane Subtlety",
					tips = "Reduces your target's resistance to all your spells by %d and reduces the threat caused by your Arcane spells by %d%%.",
					column = 1,
					row = 1,
					icon = 135894,
					ranks = 2,
					tipValues = {{5, 20}, {10, 40}}
				},
			}, -- [1]
			{
				info = {
					name = "Arcane Focus",
					tips = "Reduces the chance that the opponent can resist your Arcane spells by %d%%.",
					column = 2,
					row = 1,
					icon = 135892,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Arcane Missiles",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while channeling Arcane Missiles.",
					column = 3,
					row = 1,
					icon = 136096,
					ranks = 5,
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [3]
			{
				info = {
					name = "Wand Specialization",
					tips = "Increases your damage with Wands by %d%%.",
					column = 1,
					row = 2,
					icon = 135463,
					ranks = 2,
					tipValues = {{13}, {25}}
				},
			}, -- [4]
			{
				info = {
					name = "Magic Absorption",
					tips = "Increases all resistances by %d and causes all spells you fully resist to restore %d%% of your total mana.  1 sec. cooldown.",
					column = 2,
					row = 2,
					icon = 136011,
					ranks = 5,
					tipValues = {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}}
				},
			}, -- [5]
			{
				info = {
					name = "Arcane Concentration",
					tips = "Gives you a %d%% chance of entering a Clearcasting state after any damage spell hits a target.  The Clearcasting state reduces the mana cost of your next damage spell by 100%%.",
					column = 3,
					row = 2,
					icon = 136170,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [6]
			{
				info = {
					name = "Magic Attunement",
					tips = "Increases the effect of your Amplify Magic and Dampen Magic spells by %d%%.",
					column = 1,
					row = 3,
					icon = 136006,
					ranks = 2,
					tipValues = {{25}, {50}}
				},
			}, -- [7]
			{
				info = {
					name = "Improved Arcane Explosion",
					tips = "Increases the critical strike chance of your Arcane Explosion spell by an additional %d%%.",
					column = 2,
					row = 3,
					icon = 136116,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [8]
			{
				info = {
					tips = "Increases your armor by an amount equal to 50%% of your Intellect.",
					name = "Arcane Resilience",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 135733,
					ranks = 1,
					tipValues = {},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Mana Shield",
					tips = "Decreases the mana lost per point of damage taken when Mana Shield is active by %d%%.",
					column = 1,
					row = 4,
					icon = 136153,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Counterspell",
					tips = "Gives your Counterspell a %d%% chance to silence the target for 4 sec.",
					column = 2,
					row = 4,
					icon = 135856,
					ranks = 2,
					tipValues = {{50}, {100}}
				},
			}, -- [11]
			{
				info = {
					name = "Arcane Meditation",
					tips = "Allows %d%% of your Mana regeneration to continue while casting.",
					column = 4,
					row = 4,
					icon = 136208,
					ranks = 3,
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, your next Mage spell with a casting time less than 10 sec becomes an instant cast spell.",
					name = "Presence of Mind",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136031,
					ranks = 1,
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Arcane Mind",
					tips = "Increases your maximum Mana by %d%%.",
					column = 3,
					row = 5,
					icon = 136129,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Arcane Instability",
					tips = "Increases your spell damage and critical strike chance by %d%%.",
					column = 2,
					row = 6,
					icon = 136222,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [15]
			{
				info = {
					tips = "When activated, your spells deal 30%% more damage while costing 30%% more mana to cast.  This effect lasts 15 sec.",
					prereqs = {
						{
							column = 2,
							row = 6,
							source = 15,
						}, -- [1]
					},
					name = "Arcane Power",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136048,
					ranks = 1,
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			name = "Arcane",
			background = "MageArcane",
		},
	}, -- [1]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Improved Fireball",
					tips = "Reduces the casting time of your Fireball spell by %.1f sec.",
					column = 2,
					row = 1,
					icon = 135812,
					ranks = 5,
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [1]
			{
				info = {
					name = "Impact",
					tips = "Gives your Fire spells a %d%% chance to stun the target for 2 sec.",
					column = 3,
					row = 1,
					icon = 135821,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [2]
			{
				info = {
					name = "Ignite",
					tips = "Your critical strikes from Fire damage spells cause the target to burn for an additional %d%% of your spell's damage over 4 sec.",
					column = 1,
					row = 2,
					icon = 135818,
					ranks = 5,
					tipValues = {{8}, {16}, {24}, {32}, {40}}
				},
			}, -- [3]
			{
				info = {
					name = "Flame Throwing",
					tips = "Increases the range of your Fire spells by %d yards.",
					column = 2,
					row = 2,
					icon = 135815,
					ranks = 2,
					tipValues = {{3}, {6}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Fire Blast",
					tips = "Reduces the cooldown of your Fire Blast spell by %.1f sec.",
					column = 3,
					row = 2,
					icon = 135807,
					ranks = 3,
					tipValues = {{0.5}, {1.0}, {1.5}}
				},
			}, -- [5]
			{
				info = {
					name = "Incinerate",
					tips = "Increases the critical strike chance of your Fire Blast and Scorch spells by %d%%.",
					column = 1,
					row = 3,
					icon = 135813,
					ranks = 2,
					tipValues = {{2}, {4}}
				},
			}, -- [6]
			{
				info = {
					name = "Improved Flamestrike",
					tips = "Increases the critical strike chance of your Flamestrike spell by %d%%.",
					column = 2,
					row = 3,
					icon = 135826,
					ranks = 3,
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [7]
			{
				info = {
					tips = "Hurls an immense fiery boulder that causes 141 to 187 Fire damage and an additional 56 Fire damage over 12 sec.",
					name = "Pyroblast",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 135808,
					ranks = 1,
					tipValues = {},
				},
			}, -- [8]
			{
				info = {
					name = "Burning Soul",
					tips = "Gives your Fire spells a %d%% chance to not lose casting time when you take damage and reduces the threat caused by your Fire spells by %d%%.",
					column = 4,
					row = 3,
					icon = 135805,
					ranks = 2,
					tipValues = {{35, 15}, {70, 30}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Scorch",
					tips = "Your Scorch spells have a %d%% chance to cause your target to be vulnerable to Fire damage.  This vulnerability increases the Fire damage dealt to your target by 3%% and lasts 30 sec.  Stacks up to 5 times.",
					column = 1,
					row = 4,
					icon = 135827,
					ranks = 3,
					tipValues = {{33}, {66}, {100}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Fire Ward",
					tips = "Causes your Fire Ward to have a %d%% chance to reflect Fire spells while active.",
					column = 2,
					row = 4,
					icon = 135806,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [11]
			{
				info = {
					name = "Master of Elements",
					tips = "Your Fire and Frost spell criticals will refund %d%% of their base mana cost.",
					column = 4,
					row = 4,
					icon = 135820,
					ranks = 3,
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [12]
			{
				info = {
					name = "Critical Mass",
					tips = "Increases the critical strike chance of your Fire spells by %d%%.",
					column = 2,
					row = 5,
					icon = 136115,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [13]
			{
				info = {
					tips = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 154 to 186 Fire damage, and dazing them for 6 sec.",
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Blast Wave",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 135903,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					name = "Fire Power",
					tips = "Increases the damage done by your Fire spells by %d%%.",
					column = 3,
					row = 6,
					icon = 135817,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					tips = "When activated, this spell causes each of your Fire damage spell hits to increase your critical strike chance with Fire damage spells by 10%%.  This effect lasts until you have caused 3 critical strikes with Fire spells.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Combustion",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135824,
					ranks = 1,
					tipValues = {},
				},
			}, -- [16]
		},
		info = {
			name = "Fire",
			background = "MageFire",
		},
	}, -- [2]
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Frost Warding",
					tips = "Increases the armor and resistances given by your Frost Armor and Ice Armor spells by %d%%.  In addition, gives your Frost Ward a %d%% chance to reflect Frost spells and effects while active.",
					column = 1,
					row = 1,
					icon = 135850,
					ranks = 2,
					tipValues = {{15, 10}, {30, 20}}
				},
			}, -- [1]
			{
				info = {
					name = "Improved Frostbolt",
					tips = "Reduces the casting time of your Frostbolt spell by %.1f sec.",
					column = 2,
					row = 1,
					icon = 135846,
					ranks = 5,
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [2]
			{
				info = {
					name = "Elemental Precision",
					tips = "Reduces the chance that the opponent can resist your Frost and Fire spells by %d%%.",
					column = 3,
					row = 1,
					icon = 135989,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [3]
			{
				info = {
					name = "Ice Shards",
					tips = "Increases the critical strike damage bonus of your Frost spells by %d%%.",
					column = 1,
					row = 2,
					icon = 135855,
					ranks = 5,
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [4]
			{
				info = {
					name = "Frostbite",
					tips = "Gives your Chill effects a %d%% chance to freeze the target for 5 sec.",
					column = 2,
					row = 2,
					icon = 135842,
					ranks = 3,
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Frost Nova",
					tips = "Reduces the cooldown of your Frost Nova spell by %d sec.",
					column = 3,
					row = 2,
					icon = 135840,
					ranks = 2,
					tipValues = {{2}, {4}}
				},
			}, -- [6]
			{
				info = {
					name = "Permafrost",
					tips = "Increases the duration of your Chill effects by %d sec and reduces the target's speed by an additional %d%%.",
					column = 4,
					row = 2,
					icon = 135864,
					ranks = 3,
					tipValues = {{1, 4}, {2, 7}, {3, 10}}
				},
			}, -- [7]
			{
				info = {
					name = "Piercing Ice",
					tips = "Increases the damage done by your Frost spells by %d%%.",
					column = 1,
					row = 3,
					icon = 135845,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [8]
			{
				info = {
					tips = "When activated, this spell finishes the cooldown on all of your Frost spells.",
					name = "Cold Snap",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 135865,
					ranks = 1,
					tipValues = {},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Blizzard",
					tips = "Adds a chill effect to your Blizzard spell.  This effect lowers the target's movement speed by %d%%.  Lasts 1.50 sec.",
					column = 4,
					row = 3,
					icon = 135857,
					ranks = 3,
					tipValues = {{30}, {50}, {65}}
				},
			}, -- [10]
			{
				info = {
					name = "Arctic Reach",
					tips = "Increases the range of your Frostbolt and Blizzard spells and the radius of your Frost Nova and Cone of Cold spells by %d%%.",
					column = 1,
					row = 4,
					icon = 136141,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [11]
			{
				info = {
					name = "Frost Channeling",
					tips = "Reduces the mana cost of your Frost spells by %d%% and reduces the threat caused by your Frost spells by %d%%.",
					column = 2,
					row = 4,
					icon = 135860,
					ranks = 3,
					tipValues = {{5, 10}, {10, 20}, {15, 30}}
				},
			}, -- [12]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 6,
						}, -- [1]
					},
					name = "Shatter",
					tips = "Increases the critical strike chance of all your spells against frozen targets by %d%%.",
					column = 3,
					row = 4,
					icon = 135849,
					ranks = 5,
					tipValues = {{10}, {20}, {30}, {40}, {50}}
				},
			}, -- [13]
			{
				info = {
					tips = "You become encased in a block of ice, protecting you from all physical attacks and spells for 10 sec, but during that time you cannot attack, move or cast spells.",
					name = "Ice Block",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 135841,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					name = "Improved Cone of Cold",
					tips = "Increases the damage dealt by your Cone of Cold spell by %d%%.",
					column = 3,
					row = 5,
					icon = 135852,
					ranks = 3,
					tipValues = {{15}, {25}, {35}}
				},
			}, -- [15]
			{
				info = {
					name = "Winter's Chill",
					tips = "Gives your Frost damage spells a %d%% chance to apply the Winter's Chill effect, which increases the chance a Frost spell will critically hit the target by 2%% for 15 sec.  Stacks up to 5 times.",
					column = 3,
					row = 6,
					icon = 135836,
					ranks = 5,
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [16]
			{
				info = {
					tips = "Instantly shields you, absorbing 438 damage.  Lasts 1 min.  While the shield holds, spells will not be interrupted.\r\n",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Ice Barrier",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135988,
					ranks = 1,
					tipValues = {},
				},
			}, -- [17]
		},
		info = {
			name = "Frost",
			background = "MageFrost",
		},
	} -- [3]
};

talents.paladin = {
	{
		numtalents = 14,
		talents = {
			{
				info = {
					name = "Divine Strength",
					ranks = 5,
					column = 2,
					icon = 132154,
					row = 1,
					tips = "Increases your Strength by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [1]
			{
				info = {
					name = "Divine Intellect",
					ranks = 5,
					column = 3,
					icon = 136090,
					row = 1,
					tips = "Increases your total Intellect by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [2]
			{
				info = {
					name = "Spiritual Focus",
					ranks = 5,
					column = 2,
					icon = 135736,
					row = 2,
					tips = "Gives your Flash of Light and Holy Light spells a %d%% chance to not lose casting time when you take damage.",
					tipValues = {{14}, {28}, {42}, {56}, {70}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Seal of Righteousness",
					ranks = 5,
					column = 3,
					icon = 132325,
					row = 2,
					tips = "Increases the damage done by your Seal of Righteousness and Judgement of Righteousness by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [4]
			{
				info = {
					name = "Healing Light",
					ranks = 3,
					column = 1,
					icon = 135920,
					row = 3,
					tips = "Increases the amount healed by your Holy Light and Flash of Light spells by %d%%.",
					tipValues = {{4}, {8}, {12}}
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Consecration",
					icon = 135926,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Consecrates the land beneath Paladin, doing 64 Holy damage over 8 sec to enemies who enter the area.",
				},
			}, -- [6]
			{
				info = {
					name = "Improved Lay on Hands",
					ranks = 2,
					column = 3,
					icon = 135928,
					row = 3,
					tips = "Gives the target of your Lay on Hands spell a %d%% bonus to their armor value from items for 2 min.  In addition, the cooldown for your Lay on Hands spell is reduced by %d min.",
					tipValues = {{15, 10}, {30, 20}}
				},
			}, -- [7]
			{
				info = {
					name = "Unyielding Faith",
					ranks = 2,
					column = 4,
					icon = 135984,
					row = 3,
					tips = "Increases your chance to resist Fear and Disorient effects by an additional %d%%.",
					tipValues = {{5}, {10}}
				},
			}, -- [8]
			{
				info = {
					name = "Illumination",
					ranks = 5,
					column = 2,
					icon = 135913,
					row = 4,
					tips = "After getting a critical effect from your Flash of Light, Holy Light, or Holy Shock heal spell, gives you a %d%% chance to gain Mana equal to the base cost of the spell.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Blessing of Wisdom",
					ranks = 2,
					column = 3,
					icon = 135970,
					row = 4,
					tips = "Increases the effect of your Blessing of Wisdom spell by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [10]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 9,
						}, -- [1]
					},
					name = "Divine Favor",
					icon = 135915,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "When activated, gives your next Flash of Light, Holy Light, or Holy Shock spell a 100%% critical effect chance.",
				},
			}, -- [11]
			{
				info = {
					name = "Lasting Judgement",
					ranks = 3,
					column = 3,
					icon = 135917,
					row = 5,
					tips = "Increases the duration of your Judgement of Light and Judgement of Wisdom by %d sec.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [12]
			{
				info = {
					name = "Holy Power",
					ranks = 5,
					column = 3,
					icon = 135938,
					row = 6,
					tips = "Increases the critical effect chance of your Holy spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [13]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 11,
						}, -- [1]
					},
					name = "Holy Shock",
					icon = 135972,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Blasts the target with Holy energy, causing 204 to 220 Holy damage to an enemy, or 204 to 220 healing to an ally.",
				},
			}, -- [14]
		},
		info = {
			name = "Holy",
			background = "PaladinHoly",
		},
	}, -- [1]
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Improved Devotion Aura",
					ranks = 5,
					column = 2,
					icon = 135893,
					row = 1,
					tips = "Increases the armor bonus of your Devotion Aura by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [1]
			{
				info = {
					name = "Redoubt",
					ranks = 5,
					column = 3,
					icon = 132110,
					row = 1,
					tips = "Increases your chance to block attacks with your shield by %d%% after being the victim of a critical strike.  Lasts 10 sec or 5 blocks.",
					tipValues = {{6}, {12}, {18}, {24}, {30}}
				},
			}, -- [2]
			{
				info = {
					name = "Precision",
					ranks = 3,
					column = 1,
					icon = 132282,
					row = 2,
					tips = "Increases your chance to hit with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [3]
			{
				info = {
					name = "Guardian's Favor",
					ranks = 2,
					column = 2,
					icon = 135964,
					row = 2,
					tips = "Reduces the cooldown of your Blessing of Protection by %d sec and increases the duration of your Blessing of Freedom by %d sec.",
					tipValues = {{60,3 }, {120, 6}}
				},
			}, -- [4]
			{
				info = {
					name = "Toughness",
					ranks = 5,
					column = 4,
					icon = 135892,
					row = 2,
					tips = "Increases your armor value from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Blessing of Kings",
					icon = 135995,
					column = 1,
					exceptional = 1,
					row = 3,
					tips = "Places a Blessing on the friendly target, increasing total stats by 10%% for 5 min.  Players may only have one Blessing on them per Paladin at any one time.",
				},
			}, -- [6]
			{
				info = {
					name = "Improved Righteous Fury",
					ranks = 3,
					column = 2,
					icon = 135962,
					row = 3,
					tips = "Increases the amount of threat generated by your Righteous Fury spell by %d%%.",
					tipValues = {{16}, {33}, {50}}
				},
			}, -- [7]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 1,
							source = 2,
						}, -- [1]
					},
					name = "Shield Specialization",
					ranks = 3,
					column = 3,
					icon = 134952,
					row = 3,
					tips = "Increases the amount of damage absorbed by your shield by %d%%.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [8]
			{
				info = {
					name = "Anticipation",
					ranks = 5,
					column = 4,
					icon = 135994,
					row = 3,
					tips = "Increases your Defense skill by %d.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Hammer of Justice",
					ranks = 3,
					column = 2,
					icon = 135963,
					row = 4,
					tips = "Decreases the cooldown of your Hammer of Justice spell by %d sec.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Concentration Aura",
					ranks = 3,
					column = 3,
					icon = 135933,
					row = 4,
					tips = "Increases the effect of your Concentration Aura by an additional %d%% and gives all group members affected by the aura an additional %d%% chance to resist Silence and Interrupt effects.",
					tipValues = {{5, 5}, {10, 10}, {15, 15}}
				},
			}, -- [11]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Blessing of Sanctuary",
					icon = 136051,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Places a Blessing on the friendly target, reducing damage dealt from all sources by up to 10 for 5 min.  In addition, when the target blocks a melee attack the attacker will take 14 Holy damage.  Players may only have one Blessing on them per Paladin at any one time.",
				},
			}, -- [12]
			{
				info = {
					name = "Reckoning",
					ranks = 5,
					column = 3,
					icon = 135882,
					row = 5,
					tips = "Gives you a %d%% chance to gain an extra attack after being the victim of a critical strike.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [13]
			{
				info = {
					name = "One-Handed Weapon Specialization",
					ranks = 5,
					column = 3,
					icon = 135321,
					row = 6,
					tips = "Increases the damage you deal with one-handed melee weapons by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Holy Shield",
					icon = 135880,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Increases chance to block by 30%% for 10 sec, and deals 65 Holy damage for each attack blocked while active.  Damage caused by Holy Shield causes 20%% additional threat.  Each block expends a charge.  4 charges.",
				},
			}, -- [15]
		},
		info = {
			name = "Protection",
			background = "PaladinProtection",
		},
	}, -- [2]
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Improved Blessing of Might",
					ranks = 5,
					column = 2,
					icon = 135906,
					row = 1,
					tips = "Increases the melee attack power bonus of your Blessing of Might by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [1]
			{
				info = {
					name = "Benediction",
					ranks = 5,
					column = 3,
					icon = 135863,
					row = 1,
					tips = "Reduces the Mana cost of your Judgement and Seal spells by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Judgement",
					ranks = 2,
					column = 1,
					icon = 135959,
					row = 2,
					tips = "Decreases the cooldown of your Judgement spell by %d sec.",
					tipValues = {{1}, {2}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Seal of the Crusader",
					ranks = 3,
					column = 2,
					icon = 135924,
					row = 2,
					tips = "Increases the melee attack power bonus of your Seal of the Crusader and the Holy damage increase of your Judgement of the Crusader by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [4]
			{
				info = {
					name = "Deflection",
					ranks = 5,
					column = 3,
					icon = 132269,
					row = 2,
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [5]
			{
				info = {
					name = "Vindication",
					ranks = 3,
					column = 1,
					icon = 135985,
					row = 3,
					tips = "Gives the Paladin's damaging melee attacks a chance to reduce the target's Strength and Agility by %d%% for 10 sec.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [6]
			{
				info = {
					name = "Conviction",
					ranks = 5,
					column = 2,
					icon = 135957,
					row = 3,
					tips = "Increases your chance to get a critical strike with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Seal of Command",
					icon = 132347,
					column = 3,
					exceptional = 1,
					row = 3,
					tips = "Gives the Paladin a chance to deal additional Holy damage equal to 70%% of normal weapon damage.  Only one Seal can be active on the Paladin at any one time.  Lasts 30 sec.\r\n\r\nUnleashing this Seal's energy will judge an enemy, instantly causing 46 to 51 Holy damage, 93 to 101 if the target is stunned or incapacitated.",
				},
			}, -- [8]
			{
				info = {
					name = "Pursuit of Justice",
					ranks = 2,
					column = 4,
					icon = 135937,
					row = 3,
					tips = "Increases movement and mounted movement speed by %d%%.  This does not stack with other movement speed increasing effects.",
					tipValues = {{4}, {8}}
				},
			}, -- [9]
			{
				info = {
					name = "Eye for an Eye",
					ranks = 2,
					column = 1,
					icon = 135904,
					row = 4,
					tips = "All spell criticals against you cause %d%% of the damage taken to the caster as well.  The damage caused by Eye for an Eye will not exceed 50%% of the Paladin's total health.",
					tipValues = {{15}, {30}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Retribution Aura",
					ranks = 2,
					column = 3,
					icon = 135873,
					row = 4,
					tips = "Increases the damage done by your Retribution Aura by %d%%.",
					tipValues = {{25}, {50}}
				},
			}, -- [11]
			{
				info = {
					name = "Two-Handed Weapon Specialization",
					ranks = 3,
					column = 1,
					icon = 133041,
					row = 5,
					tips = "Increases the damage you deal with two-handed melee weapons by %d%%.",
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Sanctity Aura",
					icon = 135934,
					column = 3,
					exceptional = 1,
					row = 5,
					tips = "Increases Holy damage done by party members within 30 yards by 10%%.  Players may only have one Aura on them per Paladin at any one time.",
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Vengeance",
					ranks = 5,
					column = 2,
					icon = 132275,
					row = 6,
					tips = "Gives you a %d%% bonus to Physical and Holy damage you deal for 8 sec after dealing a critical strike from a weapon swing, spell, or ability.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Repentance",
					icon = 135942,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Puts the enemy target in a state of meditation, incapacitating them for up to 6 sec.  Any damage caused will awaken the target.  Only works against Humanoids.",
				},
			}, -- [15]
		},
		info = {
			name = "Retribution",
			background = "PaladinCombat",
		},
	} -- [3]
};

talents.priest = {
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Unbreakable Will",
					ranks = 5,
					column = 2,
					icon = 135995,
					row = 1,
					tips = "Increases your chance to resist Stun, Fear, and Silence effects by an additional %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [1]
			{
				info = {
					name = "Wand Specialization",
					ranks = 5,
					column = 3,
					icon = 135463,
					row = 1,
					tips = "Increases your damage with Wands by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [2]
			{
				info = {
					name = "Silent Resolve",
					ranks = 5,
					column = 1,
					icon = 136053,
					row = 2,
					tips = "Reduces the threat generated by your spells by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Power Word: Fortitude",
					ranks = 2,
					column = 2,
					icon = 135987,
					row = 2,
					tips = "Increases the effect of your Power Word: Fortitude and Prayer of Fortitude spells by %d%%.",
					tipValues = {{15}, {30}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Power Word: Shield",
					ranks = 3,
					column = 3,
					icon = 135940,
					row = 2,
					tips = "Increases the damage absorbed by your Power Word: Shield by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [5]
			{
				info = {
					name = "Martyrdom",
					ranks = 2,
					column = 4,
					icon = 136107,
					row = 2,
					tips = "Gives you a %d%% chance to gain the Focused Casting effect that lasts for 6 sec after being the victim of a melee or ranged critical strike.  The Focused Casting effect prevents you from losing casting time when taking damage and increases resistance to Interrupt effects by %d%%.",
					tipValues = {{50, 10}, {100, 20}}
				},
			}, -- [6]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Inner Focus",
					icon = 135863,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "When activated, reduces the Mana cost of your next spell by 100%% and increases its critical effect chance by 25%% if it is capable of a critical effect.",
				},
			}, -- [7]
			{
				info = {
					name = "Meditation",
					ranks = 3,
					column = 3,
					icon = 136090,
					row = 3,
					tips = "Allows %d%% of your Mana regeneration to continue while casting.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [8]
			{
				info = {
					name = "Improved Inner Fire",
					ranks = 3,
					column = 1,
					icon = 135926,
					row = 4,
					tips = "Increases the Armor bonus of your Inner Fire spell by %d%%.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [9]
			{
				info = {
					name = "Mental Agility",
					ranks = 5,
					column = 2,
					icon = 132156,
					row = 4,
					tips = "Reduces the mana cost of your instant cast spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Mana Burn",
					ranks = 2,
					column = 4,
					icon = 136170,
					row = 4,
					tips = "Reduces the casting time of your Mana Burn spell by %.2f secs.",
					tipValues = {{0.25}, {0.50}}
				},
			}, -- [11]
			{
				info = {
					name = "Mental Strength",
					ranks = 5,
					column = 2,
					icon = 136031,
					row = 5,
					tips = "Increases your maximum Mana by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Divine Spirit",
					icon = 135898,
					column = 3,
					exceptional = 1,
					row = 5,
					tips = "Holy power infuses the target, increasing their Spirit by 17 for 30 min.",
				},
			}, -- [13]
			{
				info = {
					name = "Force of Will",
					ranks = 5,
					column = 3,
					icon = 136092,
					row = 6,
					tips = "Increases your spell damage by %d%% and the critical strike chance of your offensive spells by %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Power Infusion",
					icon = 135939,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Infuses the target with power, increasing their spell damage and healing by 20%%.  Lasts 15 sec.",
				},
			}, -- [15]
		},
		info = {
			name = "Discipline",
			background = "PriestDiscipline",
		},
	}, -- [1]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Healing Focus",
					ranks = 2,
					column = 1,
					icon = 135918,
					row = 1,
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting any healing spell.",
					tipValues = {{35}, {70}}
				},
			}, -- [1]
			{
				info = {
					name = "Improved Renew",
					ranks = 3,
					column = 2,
					icon = 135953,
					row = 1,
					tips = "Increases the amount healed by your Renew spell by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [2]
			{
				info = {
					name = "Holy Specialization",
					ranks = 5,
					column = 3,
					icon = 135967,
					row = 1,
					tips = "Increases the critical effect chance of your Holy spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [3]
			{
				info = {
					name = "Spell Warding",
					ranks = 5,
					column = 2,
					icon = 135976,
					row = 2,
					tips = "Reduces all spell damage taken by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [4]
			{
				info = {
					name = "Divine Fury",
					ranks = 5,
					column = 3,
					icon = 135971,
					row = 2,
					tips = "Reduces the casting time of your Smite, Holy Fire, Heal and Greater Heal spells by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Holy Nova",
					icon = 135922,
					column = 1,
					exceptional = 1,
					row = 3,
					tips = "Causes an explosion of holy light around the caster, causing 28 to 32 Holy damage to all enemy targets within 10 yards and healing all party members within 10 yards for 52 to 60.  These effects cause no threat.",
				},
			}, -- [6]
			{
				info = {
					name = "Blessed Recovery",
					ranks = 3,
					column = 2,
					icon = 135877,
					row = 3,
					tips = "After being struck by a melee or ranged critical hit, heal %d%% of the damage taken over 6 sec.",
					tipValues = {{8}, {16}, {25}}
				},
			}, -- [7]
			{
				info = {
					name = "Inspiration",
					ranks = 3,
					column = 4,
					icon = 135928,
					row = 3,
					tips = "Increases your target's armor by %d%% for 15 sec after getting a critical effect from your Flash Heal, Heal, Greater Heal, or Prayer of Healing spell.",
					tipValues = {{8}, {16}, {25}}
				},
			}, -- [8]
			{
				info = {
					name = "Holy Reach",
					ranks = 2,
					column = 1,
					icon = 135949,
					row = 4,
					tips = "Increases the range of your Smite and Holy Fire spells and the radius of your Prayer of Healing and Holy Nova spells by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Healing",
					ranks = 3,
					column = 2,
					icon = 135916,
					row = 4,
					tips = "Reduces the Mana cost of your Lesser Heal, Heal, and Greater Heal spells by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [10]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 5,
						}, -- [1]
					},
					name = "Searing Light",
					ranks = 2,
					column = 3,
					icon = 135973,
					row = 4,
					tips = "Increases the damage of your Smite and Holy Fire spells by %d%%.",
					tipValues = {{5}, {10}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Prayer of Healing",
					ranks = 2,
					column = 1,
					icon = 135943,
					row = 5,
					tips = "Reduces the Mana cost of your Prayer of Healing spell by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Spirit of Redemption",
					icon = 132864,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Upon death, the priest becomes the Spirit of Redemption for 10 sec.  The Spirit of Redemption cannot move, attack, be attacked or targeted by any spells or effects.  While in this form the priest can cast any healing spell free of cost.  When the effect ends, the priest dies.",
				},
			}, -- [13]
			{
				info = {
					name = "Spiritual Guidance",
					ranks = 5,
					column = 3,
					icon = 135977,
					row = 5,
					tips = "Increases spell damage and healing by up to %d%% of your total Spirit.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [14]
			{
				info = {
					name = "Spiritual Healing",
					ranks = 5,
					column = 3,
					icon = 136057,
					row = 6,
					tips = "Increases the amount healed by your healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Lightwell",
					icon = 135980,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Creates a holy Lightwell near the priest.  Members of your raid or party can click the Lightwell to restore 800 health over 10 sec.  Being attacked cancels the effect.  Lightwell lasts for 3 min or 5 charges.",
				},
			}, -- [16]
		},
		info = {
			name = "Holy",
			background = "PriestHoly",
		},
	}, -- [2]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Spirit Tap",
					ranks = 5,
					column = 2,
					icon = 136188,
					row = 1,
					tips = "Gives you a %d%% chance to gain a 100%% bonus to your Spirit after killing a target that yields experience.  For the duration, your Mana will regenerate at a 50%% rate while casting.  Lasts 15 sec.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [1]
			{
				info = {
					name = "Blackout",
					ranks = 5,
					column = 3,
					icon = 136160,
					row = 1,
					tips = "Gives your Shadow damage spells a %d%% chance to stun the target for 3 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
				},
			}, -- [2]
			{
				info = {
					name = "Shadow Affinity",
					ranks = 3,
					column = 1,
					icon = 136205,
					row = 2,
					tips = "Reduces the threat generated by your Shadow spells by %d%%.",
					tipValues = {{8}, {16}, {25}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Shadow Word: Pain",
					ranks = 2,
					column = 2,
					icon = 136207,
					row = 2,
					tips = "Increases the duration of your Shadow Word: Pain spell by %d sec.",
					tipValues = {{3}, {6}}
				},
			}, -- [4]
			{
				info = {
					name = "Shadow Focus",
					ranks = 5,
					column = 3,
					icon = 136126,
					row = 2,
					tips = "Reduces your target's chance to resist your Shadow spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Psychic Scream",
					ranks = 2,
					column = 1,
					icon = 136184,
					row = 3,
					tips = "Reduces the cooldown of your Psychic Scream spell by %d sec.",
					tipValues = {{2}, {4}}
				},
			}, -- [6]
			{
				info = {
					name = "Improved Mind Blast",
					ranks = 5,
					column = 2,
					icon = 136224,
					row = 3,
					tips = "Reduces the cooldown of your Mind Blast spell by %.1f sec.",
					tipValues = {{0.5}, {1.0}, {1.5}, {2.0}, {2.5}}
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Mind Flay",
					icon = 136208,
					column = 3,
					exceptional = 1,
					row = 3,
					tips = "Assault the target's mind with Shadow energy, causing 75 Shadow damage over 3 sec and slowing their movement speed by 50%%.",
				},
			}, -- [8]
			{
				info = {
					name = "Improved Fade",
					ranks = 2,
					column = 2,
					icon = 135994,
					row = 4,
					tips = "Decreases the cooldown of your Fade ability by %d sec.",
					tipValues = {{3}, {6}}
				},
			}, -- [9]
			{
				info = {
					name = "Shadow Reach",
					ranks = 3,
					column = 3,
					icon = 136130,
					row = 4,
					tips = "Increases the range of your Shadow damage spells by %d%%.",
					tipValues = {{6}, {13}, {20}}
				},
			}, -- [10]
			{
				info = {
					name = "Shadow Weaving",
					ranks = 5,
					column = 4,
					icon = 136123,
					row = 4,
					tips = "Your Shadow damage spells have a %d%% chance to cause your target to be vulnerable to Shadow damage.  This vulnerability increases the Shadow damage dealt to your target by 3%% and lasts 15 sec.  Stacks up to 5 times.",
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [11]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 1,
							row = 3,
							source = 6,
						}, -- [1]
					},
					name = "Silence",
					icon = 136164,
					column = 1,
					exceptional = 1,
					row = 5,
					tips = "Silences the target, preventing them from casting spells for 5 sec.",
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Vampiric Embrace",
					icon = 136230,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Afflicts your target with Shadow energy that causes all party members to be healed for 20%% of any Shadow spell damage you deal for 1 min.",
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Improved Vampiric Embrace",
					ranks = 2,
					column = 3,
					icon = 136165,
					row = 5,
					tips = "Increases the percentage healed by Vampiric Embrace by an additional %d%%.",
					tipValues = {{5}, {10}}
				},
			}, -- [14]
			{
				info = {
					name = "Darkness",
					ranks = 5,
					column = 3,
					icon = 136223,
					row = 6,
					tips = "Increases your Shadow spell damage by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Shadowform",
					icon = 136200,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Assume a Shadowform, increasing your Shadow damage by 15%% and reducing Physical damage done to you by 15%%.  However, you may not cast Holy spells while in this form.",
				},
			}, -- [16]
		},
		info = {
			name = "Shadow",
			background = "PriestShadow",
		},
	} -- [3]
};

talents.rogue = {
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Improved Eviscerate",
					tips = "Increases the damage done by your Eviscerate ability by %d%%.",
					column = 1,
					row = 1,
					icon = 132292,
					ranks = 3,
					tipValues = {{5}, {10}, {15}},
				},
			}, -- [1]
			{
				info = {
					name = "Remorseless Attacks",
					tips = "After killing an opponent that yields experience or honor, gives you a %d%% increased critical strike chance on your next Sinister Strike, Backstab, Ambush, or Ghostly Strike.  Lasts 20 sec.",
					column = 2,
					row = 1,
					icon = 132151,
					ranks = 2,
					tipValues = {{20}, {40}}
				},
			}, -- [2]
			{
				info = {
					name = "Malice",
					tips = "Increases your critical strike chance by %d%%.",
					column = 3,
					row = 1,
					icon = 132277,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [3]
			{
				info = {
					name = "Ruthlessness",
					tips = "Gives your finishing moves a %d%% chance to add a combo point to your target.",
					column = 1,
					row = 2,
					icon = 132122,
					ranks = 3,
					tipValues = {{20}, {40}, {60}}
				},
			}, -- [4]
			{
				info = {
					name = "Murder",
					tips = "Increases all damage caused against Humanoid, Giant, Beast and Dragonkin targets by %d%%.",
					column = 2,
					row = 2,
					icon = 136147,
					ranks = 2,
					tipValues = {{1}, {2}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Slice and Dice",
					tips = "Increases the duration of your Slice and Dice ability by %d%%.",
					column = 4,
					row = 2,
					icon = 132306,
					ranks = 3,
					tipValues = {{15}, {30}, {45}}
				},
			}, -- [6]
			{
				info = {
					tips = "Your finishing moves have a 20%% chance per combo point to restore 25 energy.",
					name = "Relentless Strikes",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 132340,
					ranks = 1,
					tipValues = {},
				},
			}, -- [7]
			{
				info = {
					name = "Improved Expose Armor",
					tips = "Increases the armor reduced by your Expose Armor ability by %d%%.",
					column = 2,
					row = 3,
					icon = 132354,
					ranks = 2,
					tipValues = {{25}, {50}}
				},
			}, -- [8]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 1,
							source = 3,
						}, -- [1]
					},
					name = "Lethality",
					tips = "Increases the critical strike damage bonus of your Sinister Strike, Gouge, Backstab, Ghostly Strike, and Hemorrhage abilities by %d%%.",
					column = 3,
					row = 3,
					icon = 132109,
					ranks = 5,
					tipValues = {{6}, {12}, {18}, {24}, {30}}
				},
			}, -- [9]
			{
				info = {
					name = "Vile Poisons",
					tips = "Increases the damage dealt by your poisons by %d%% and gives your poisons an additional %d%% chance to resist dispel effects.",
					column = 2,
					row = 4,
					icon = 132293,
					ranks = 5,
					tipValues = {{4, 8}, {8, 16}, {12, 24}, {16, 32}, {20, 40}}

				},
			}, -- [10]
			{
				info = {
					name = "Improved Poisons",
					tips = "Increases the chance to apply poisons to your target by %d%%.",
					column = 3,
					row = 4,
					icon = 132273,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [11]
			{
				info = {
					tips = "When activated, increases the critical strike chance of your next Sinister Strike, Backstab, Ambush, or Eviscerate by 100%%.",
					name = "Cold Blood",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 135988,
					ranks = 1,
					tipValues = {},
				},
			}, -- [12]
			{
				info = {
					name = "Improved Kidney Shot",
					tips = "While affected by your Kidney Shot ability, the target receives an additional %d%% damage from all sources.",
					column = 3,
					row = 5,
					icon = 132298,
					ranks = 3,
					tipValues = {{3}, {6}, {9}}
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Seal Fate",
					tips = "Your critical strikes from abilities that add combo points have a %d%% chance to add an additional combo point.",
					column = 2,
					row = 6,
					icon = 136130,
					ranks = 5,
					tipValues = {{20}, {40}, {60}, {80}, {100}}
				},
			}, -- [14]
			{
				info = {
					name = "Vigor",
					tips = "Increases your maximum Energy by 10.",
					column = 2,
					row = 7,
					icon = 136023,
					ranks = 1,
					tipValues = {},
				},
			}, -- [15]
		},
		info = {
			name = "Assassination",
			background = "RogueAssassination",
		},
	}, -- [1]
	{
		numtalents = 19,
		talents = {
			{
				info = {
					name = "Improved Gouge",
					tips = "Increases the effect duration of your Gouge ability by %.1f sec.",
					column = 1,
					row = 1,
					icon = 132155,
					ranks = 3,
					tipValues = {{0.5}, {1.0}, {1.5}}
				},
			}, -- [1]
			{
				info = {
					name = "Improved Sinister Strike",
					tips = "Reduces the Energy cost of your Sinister Strike ability by %d.",
					column = 2,
					row = 1,
					icon = 136189,
					ranks = 2,
					tipValues = {{3},{5}}
				},
			}, -- [2]
			{
				info = {
					name = "Lightning Reflexes",
					tips = "Increases your Dodge chance by %d%%.",
					column = 3,
					row = 1,
					icon = 136047,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Backstab",
					tips = "Increases the critical strike chance of your Backstab ability by %d%%.",
					column = 1,
					row = 2,
					icon = 132090,
					ranks = 3,
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [4]
			{
				info = {
					name = "Deflection",
					tips = "Increases your Parry chance by %d%%.",
					column = 2,
					row = 2,
					icon = 132269,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [5]
			{
				info = {
					name = "Precision",
					tips = "Increases your chance to hit with melee weapons by %d%%.",
					column = 3,
					row = 2,
					icon = 132222,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [6]
			{
				info = {
					name = "Endurance",
					tips = "Reduces the cooldown of your Sprint and Evasion abilities by %d sec.",
					column = 1,
					row = 3,
					icon = 136205,
					ranks = 2,
					tipValues = {{45}, {90}}
				},
			}, -- [7]
			{
				info = {
					tips = "A strike that becomes active after parrying an opponent's attack.  This attack deals 150%% weapon damage and disarms the target for 6 sec.",
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 5,
						}, -- [1]
					},
					name = "Riposte",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 132336,
					ranks = 1,
					tipValues = {},
				},
			}, -- [8]
			{
				info = {
					name = "Improved Sprint",
					tips = "Gives a %d%% chance to remove all movement impairing effects when you activate your Sprint ability.",
					column = 4,
					row = 3,
					icon = 132307,
					ranks = 2,
					tipValues = {{50}, {100}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Kick",
					tips = "Gives your Kick ability a %d%% chance to silence the target for 2 sec.",
					column = 1,
					row = 4,
					icon = 132219,
					ranks = 2,
					tipValues = {{50}, {100}}
				},
			}, -- [10]
			{
				info = {
					name = "Dagger Specialization",
					tips = "Increases your chance to get a critical strike with Daggers by %d%%.",
					column = 2,
					row = 4,
					icon = 135641,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [11]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 6,
						}, -- [1]
					},
					name = "Dual Wield Specialization",
					tips = "Increases the damage done by your offhand weapon by %d%%.",
					column = 3,
					row = 4,
					icon = 132147,
					ranks = 5,
					tipValues = {{10}, {20}, {30}, {40}, {50}}
				},
			}, -- [12]
			{
				info = {
					name = "Mace Specialization",
					tips = "Increases your skill with Maces by %d, and gives you a %d%% chance to stun your target for 3 sec with a mace.",
					column = 1,
					row = 5,
					icon = 133476,
					ranks = 5,
					tipValues = {{1,1}, {2,2}, {3,3}, {4,4}, {5,6}}
				},
			}, -- [13]
			{
				info = {
					tips = "Increases your attack speed by 20%%.  In addition, attacks strike an additional nearby opponent.  Lasts 15 sec.",
					name = "Blade Flurry",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132350,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					name = "Sword Specialization",
					tips = "Gives you a %d%% chance to get an extra attack on the same target after dealing damage with your Sword.",
					column = 3,
					row = 5,
					icon = 135328,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [15]
			{
				info = {
					name = "Fist Weapon Specialization",
					tips = "Increases your chance to get a critical strike with Fist Weapons by %d%%.",
					column = 4,
					row = 5,
					icon = 132938,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [16]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Weapon Expertise",
					tips = "Increases your skill with Sword, Fist and Dagger weapons by %d.",
					column = 2,
					row = 6,
					icon = 135882,
					ranks = 2,
					tipValues = {{3},{5}}
				},
			}, -- [17]
			{
				info = {
					name = "Aggression",
					tips = "Increases the damage of your Sinister Strike and Eviscerate abilities by %d%%.",
					column = 3,
					row = 6,
					icon = 132275,
					ranks = 3,
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [18]
			{
				info = {
					tips = "Increases your Energy regeneration rate by 100%% for 15 sec.",
					name = "Adrenaline Rush",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136206,
					ranks = 1,
					tipValues = {},
				},
			}, -- [19]
		},
		info = {
			name = "Combat",
			background = "RogueCombat",
		},
	}, -- [2]
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Master of Deception",
					tips = "Reduces the chance enemies have to detect you while in Stealth mode.",
					column = 2,
					row = 1,
					icon = 136129,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Opportunity",
					tips = "Increases the damage dealt when striking from behind with your Backstab, Garrote, or Ambush abilities by %d%%.",
					column = 3,
					row = 1,
					icon = 132366,
					ranks = 5,
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [2]
			{
				info = {
					name = "Sleight of Hand",
					tips = "Reduces the chance you are critically hit by melee and ranged attacks by %d%% and increases the threat reduction of your Feint ability by %d%%.",
					column = 1,
					row = 2,
					icon = 132294,
					ranks = 2,
					tipValues = {{1, 10}, {2, 20}}
				},
			}, -- [3]
			{
				info = {
					name = "Elusiveness",
					tips = "Reduces the cooldown of your Vanish and Blind abilities by %d sec.",
					column = 2,
					row = 2,
					icon = 135994,
					ranks = 2,
					tipValues = {{45}, {90}}
				},
			}, -- [4]
			{
				info = {
					name = "Camouflage",
					tips = "Increases your speed while stealthed by %d%% and reduces the cooldown of your Stealth ability by %d sec.",
					column = 3,
					row = 2,
					icon = 132320,
					ranks = 5,
					tipValues = {{3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}}

				},
			}, -- [5]
			{
				info = {
					name = "Initiative",
					tips = "Gives you a %d%% chance to add an additional combo point to your target when using your Ambush, Garrote, or Cheap Shot ability.",
					column = 1,
					row = 3,
					icon = 136159,
					ranks = 3,
					tipValues = {{25}, {50}, {75}}
				},
			}, -- [6]
			{
				info = {
					tips = "A strike that deals 125%% weapon damage and increases your chance to dodge by 15%% for 7 sec.  Awards 1 combo point.",
					name = "Ghostly Strike",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 136136,
					ranks = 1,
					tipValues = {},
				},
			}, -- [7]
			{
				info = {
					name = "Improved Ambush",
					tips = "Increases the critical strike chance of your Ambush ability by %d%%.",
					column = 3,
					row = 3,
					icon = 132282,
					ranks = 3,
					tipValues = {{15}, {30}, {45}}
				},
			}, -- [8]
			{
				info = {
					name = "Setup",
					tips = "Gives you a %d%% chance to add a combo point to your target after dodging their attack or fully resisting one of their spells.",
					column = 1,
					row = 4,
					icon = 136056,
					ranks = 3,
					tipValues = {{15}, {30}, {45}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Sap",
					tips = "Gives you a %d%% chance to return to stealth mode after using your Sap ability.",
					column = 2,
					row = 4,
					icon = 132310,
					ranks = 3,
					tipValues = {{30}, {60}, {90}}
				},
			}, -- [10]
			{
				info = {
					name = "Serrated Blades",
					tips = "Causes your attacks to ignore 0 of your target's Armor and increases the damage dealt by your Rupture ability by %d%%.  The amount of Armor reduced increases with your level.",
					column = 3,
					row = 4,
					icon = 135315,
					ranks = 3,
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [11]
			{
				info = {
					name = "Heightened Senses",
					tips = "Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by %d%%.",
					column = 1,
					row = 5,
					icon = 132089,
					ranks = 2,
					tipValues = {{2}, {4}}
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, this ability immediately finishes the cooldown on your other Rogue abilities.",
					name = "Preparation",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136121,
					ranks = 1,
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					name = "Dirty Deeds",
					tips = "Reduces the Energy cost of your Cheap Shot and Garrote abilities by %d.",
					column = 3,
					row = 5,
					icon = 136220,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [14]
			{
				info = {
					tips = "An instant strike that damages the opponent and causes the target to hemorrhage, increasing any Physical damage dealt to the target by up to 3.  Lasts 30 charges or 15 sec.  Awards 1 combo point.",
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 11,
						}, -- [1]
					},
					name = "Hemorrhage",
					row = 5,
					column = 4,
					exceptional = 1,
					icon = 136168,
					ranks = 1,
					tipValues = {},
				},
			}, -- [15]
			{
				info = {
					name = "Deadliness",
					tips = "Increases your Attack Power by %d%%.",
					column = 3,
					row = 6,
					icon = 135540,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [16]
			{
				info = {
					tips = "When used, adds 2 combo points to your target.  You must add to or use those combo points within 10 sec or the combo points are lost. ",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Premeditation",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136183,
					ranks = 1,
					tipValues = {},
				},
			}, -- [17]
		},
		info = {
			name = "Subtlety",
			background = "RogueSubtlety",
		},
	} -- [3]
};

talents.shaman = {
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Convection",
					ranks = 5,
					column = 2,
					icon = 136116,
					row = 1,
					tips = "Reduces the mana cost of your Shock, Lightning Bolt and Chain Lightning spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [1]
			{
				info = {
					name = "Concussion",
					ranks = 5,
					column = 3,
					icon = 135807,
					row = 1,
					tips = "Increases the damage done by your Lightning Bolt, Chain Lightning and Shock spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [2]
			{
				info = {
					name = "Earth's Grasp",
					ranks = 2,
					column = 1,
					icon = 136097,
					row = 2,
					tips = "Increases the health of your Stoneclaw Totem by %d%% and the radius of your Earthbind Totem by %d%%.",
					tipValues = {{25, 10}, {50, 20}}
				},
			}, -- [3]
			{
				info = {
					name = "Elemental Warding",
					ranks = 3,
					column = 2,
					icon = 136094,
					row = 2,
					tips = "Reduces damage taken from Fire, Frost and Nature effects by %d%%.",
					tipValues = {{4}, {7}, {10}}
				},
			}, -- [4]
			{
				info = {
					name = "Call of Flame",
					ranks = 3,
					column = 3,
					icon = 135817,
					row = 2,
					tips = "Increases the damage done by your Fire Totems by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Elemental Focus",
					icon = 136170,
					column = 1,
					exceptional = 1,
					row = 3,
					tips = "Gives you a 10%% chance to enter a Clearcasting state after casting any Fire, Frost, or Nature damage spell.  The Clearcasting state reduces the mana cost of your next damage spell by 100%%.",
				},
			}, -- [6]
			{
				info = {
					name = "Reverberation",
					ranks = 5,
					column = 2,
					icon = 135850,
					row = 3,
					tips = "Reduces the cooldown of your Shock spells by %.1f sec.",
					tipValues = {{0.2}, {0.4}, {0.6}, {0.8}, {1.0}}
				},
			}, -- [7]
			{
				info = {
					name = "Call of Thunder",
					ranks = 5,
					column = 3,
					icon = 136014,
					row = 3,
					tips = "Increases the critical strike chance of your Lightning Bolt and Chain Lightning spells by an additional %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {6}}
				},
			}, -- [8]
			{
				info = {
					name = "Improved Fire Totems",
					ranks = 2,
					column = 1,
					icon = 135824,
					row = 4,
					tips = "Reduces the delay before your Fire Nova Totem activates by %d sec. and decreases the threat generated by your Magma Totem by %d%%.",
					tipValues = {{1, 25}, {2, 50}}
				},
			}, -- [9]
			{
				info = {
					name = "Eye of the Storm",
					ranks = 3,
					column = 2,
					icon = 136032,
					row = 4,
					tips = "Gives you a %d%% chance to gain the Focused Casting effect that lasts for 6 sec after being the victim of a melee or ranged critical strike.  The Focused Casting effect prevents you from losing casting time when taking damage.",
					tipValues = {{33}, {66}, {100}}
				},
			}, -- [10]
			{
				info = {
					name = "Elemental Devastation",
					ranks = 3,
					column = 4,
					icon = 135791,
					row = 4,
					tips = "Your offensive spell crits will increase your chance to get a critical strike with melee attacks by %d%% for 10 sec.",
					tipValues = {{3}, {6}, {9}}
				},
			}, -- [11]
			{
				info = {
					name = "Storm Reach",
					ranks = 2,
					column = 1,
					icon = 136099,
					row = 5,
					tips = "Increases the range of your Lightning Bolt and Chain Lightning spells by %d yards.",
					tipValues = {{3}, {6}}
				},
			}, -- [12]
			{
				info = {
					name = "Elemental Fury",
					ranks = 1,
					tipValues = {},
					column = 2,
					icon = 135830,
					row = 5,
					tips = "Increases the critical strike damage bonus of your Searing, Magma, and Fire Nova Totems and your Fire, Frost, and Nature spells by 100%%.",
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Lightning Mastery",
					ranks = 5,
					column = 3,
					icon = 135990,
					row = 6,
					tips = "Reduces the cast time of your Lightning Bolt and Chain Lightning spells by %.1f sec.",
					tipValues = {{0.2}, {0.4}, {0.6}, {0.8}, {1.0}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Elemental Mastery",
					icon = 136115,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "When activated, this spell gives your next Fire, Frost, or Nature damage spell a 100%% critical strike chance and reduces the mana cost by 100%%.",
				},
			}, -- [15]
		},
		info = {
			name = "Elemental",
			background = "ShamanElementalCombat",
		},
	}, -- [1]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Ancestral Knowledge",
					ranks = 5,
					column = 2,
					icon = 136162,
					row = 1,
					tips = "Increases your maximum Mana by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [1]
			{
				info = {
					name = "Shield Specialization",
					ranks = 5,
					column = 3,
					icon = 134952,
					row = 1,
					tips = "Increases your chance to block attacks with a shield by %d%% and increases the amount blocked by %d%%.",
					tipValues = {{1, 5}, {2, 10}, {3, 15}, {4, 20}, {5, 25}}
				},
			}, -- [2]
			{
				info = {
					name = "Guardian Totems",
					ranks = 2,
					column = 1,
					icon = 136098,
					row = 2,
					tips = "Increases the amount of damage reduced by your Stoneskin Totem and Windwall Totem by %d%% and reduces the cooldown of your Grounding Totem by %d sec.",
					tipValues = {{10, 1}, {20, 2}}
				},
			}, -- [3]
			{
				info = {
					name = "Thundering Strikes",
					ranks = 5,
					column = 2,
					icon = 132325,
					row = 2,
					tips = "Improves your chance to get a critical strike with your weapon attacks by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Ghost Wolf",
					ranks = 2,
					column = 3,
					icon = 136095,
					row = 2,
					tips = "Reduces the cast time of your Ghost Wolf spell by %d sec.",
					tipValues = {{1}, {2}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Lightning Shield",
					ranks = 3,
					column = 4,
					icon = 136051,
					row = 2,
					tips = "Increases the damage done by your Lightning Shield orbs by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [6]
			{
				info = {
					name = "Enhancing Totems",
					ranks = 2,
					column = 1,
					icon = 136023,
					row = 3,
					tips = "Increases the effect of your Strength of Earth and Grace of Air Totems by %d%%.",
					tipValues = {{8}, {15}}
				},
			}, -- [7]
			{
				info = {
					name = "Two-Handed Axes and Maces",
					ranks = 1,
					tipValues = {},
					column = 3,
					icon = 132401,
					row = 3,
					tips = "Allows you to use Two-Handed Axes and Two-Handed Maces.",
				},
			}, -- [8]
			{
				info = {
					name = "Anticipation",
					ranks = 5,
					column = 4,
					icon = 136056,
					row = 3,
					tips = "Increases your chance to dodge by an additional %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [9]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 4,
						}, -- [1]
					},
					name = "Flurry",
					ranks = 5,
					column = 2,
					icon = 132152,
					row = 4,
					tips = "Increases your attack speed by %d%% for your next 3 swings after dealing a critical strike.",
					tipValues = {{10}, {15}, {20}, {25}, {30}}
				},
			}, -- [10]
			{
				info = {
					name = "Toughness",
					ranks = 5,
					column = 3,
					icon = 135892,
					row = 4,
					tips = "Increases your armor value from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Weapon Totems",
					ranks = 2,
					column = 1,
					icon = 135792,
					row = 5,
					tips = "Increases the melee attack power bonus of your Windfury Totem by %d%% and increases the damage caused by your Flametongue Totem by %d%%.",
					tipValues = {{15, 6}, {30, 12}}
				},
			}, -- [12]
			{
				info = {
					name = "Elemental Weapons",
					ranks = 3,
					column = 2,
					icon = 135814,
					row = 5,
					tips = "Increases the melee attack power bonus of your Rockbiter Weapon by %d%%, your Windfury Weapon effect by %d%% and increases the damage caused by your Flametongue Weapon and Frostbrand Weapon by %d%%.",
					tipValues = {{7, 13, 5}, {14, 27, 10}, {20, 40, 15}}
				},
			}, -- [13]
			{
				info = {
					name = "Parry",
					ranks = 1,
					tipValues = {},
					column = 3,
					icon = 132269,
					row = 5,
					tips = "Gives a chance to parry enemy melee attacks.",
				},
			}, -- [14]
			{
				info = {
					name = "Weapon Mastery",
					ranks = 5,
					column = 3,
					icon = 132215,
					row = 6,
					tips = "Increases the damage you deal with all weapons by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Stormstrike",
					icon = 135963,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Gives you an extra attack.  In addition, the next 2 sources of Nature damage dealt to the target are increased by 20%%.  Lasts 12 sec.",
				},
			}, -- [16]
		},
		info = {
			name = "Enhancement",
			background = "ShamanEnhancement",
		},
	}, -- [2]
	{
		numtalents = 15,
		talents = {
			{
				info = {
					name = "Improved Healing Wave",
					ranks = 5,
					column = 2,
					icon = 136052,
					row = 1,
					tips = "Reduces the casting time of your Healing Wave spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [1]
			{
				info = {
					name = "Tidal Focus",
					ranks = 5,
					column = 3,
					icon = 135859,
					row = 1,
					tips = "Reduces the Mana cost of your healing spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Reincarnation",
					ranks = 2,
					column = 1,
					icon = 136080,
					row = 2,
					tips = "Reduces the cooldown of your Reincarnation spell by %d min and increases the amount of health and mana you reincarnate with by an additional %d%%.",
					tipValues = {{10, 10}, {20, 20}}
				},
			}, -- [3]
			{
				info = {
					name = "Ancestral Healing",
					ranks = 3,
					column = 2,
					icon = 136109,
					row = 2,
					tips = "Increases your target's armor value by %d%% for 15 sec after getting a critical effect from one of your healing spells.",
					tipValues = {{8}, {16}, {25}}
				},
			}, -- [4]
			{
				info = {
					name = "Totemic Focus",
					ranks = 5,
					column = 3,
					icon = 136057,
					row = 2,
					tips = "Reduces the Mana cost of your totems by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [5]
			{
				info = {
					name = "Nature's Guidance",
					ranks = 3,
					column = 1,
					icon = 135860,
					row = 3,
					tips = "Increases your chance to hit with melee attacks and spells by %d%%.",
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [6]
			{
				info = {
					name = "Healing Focus",
					ranks = 5,
					column = 2,
					icon = 136043,
					row = 3,
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting any healing spell.",
					tipValues = {{14}, {28}, {42}, {56}, {70}}
				},
			}, -- [7]
			{
				info = {
					name = "Totemic Mastery",
					ranks = 1,
					tipValues = {},
					column = 3,
					icon = 136069,
					row = 3,
					tips = "The radius of your totems that affect friendly targets is increased to 30 yd.",
				},
			}, -- [8]
			{
				info = {
					name = "Healing Grace",
					ranks = 3,
					column = 4,
					icon = 136041,
					row = 3,
					tips = "Reduces the threat generated by your healing spells by %d%%.",
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [9]
			{
				info = {
					name = "Restorative Totems",
					ranks = 5,
					column = 2,
					icon = 136053,
					row = 4,
					tips = "Increases the effect of your Mana Spring and Healing Stream Totems by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [10]
			{
				info = {
					name = "Tidal Mastery",
					ranks = 5,
					column = 3,
					icon = 136107,
					row = 4,
					tips = "Increases the critical effect chance of your healing and lightning spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [11]
			{
				info = {
					name = "Healing Way",
					ranks = 3,
					column = 1,
					icon = 136044,
					row = 5,
					tips = "Your Healing Wave spells have a %d%% chance to increase the effect of subsequent Healing Wave spells on that target by 6%% for 15 sec.  This effect will stack up to 3 times.",
					tipValues = {{33}, {66}, {100}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Nature's Swiftness",
					icon = 136076,
					column = 3,
					exceptional = 1,
					row = 5,
					tips = "When activated, your next Nature spell with a casting time less than 10 sec. becomes an instant cast spell.",
				},
			}, -- [13]
			{
				info = {
					name = "Purification",
					ranks = 5,
					column = 3,
					icon = 135865,
					row = 6,
					tips = "Increases the effectiveness of your healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [14]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 10,
						}, -- [1]
					},
					name = "Mana Tide Totem",
					icon = 135861,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 170 mana every 3 seconds to group members within 20 yards.",
				},
			}, -- [15]
		},
		info = {
			name = "Restoration",
			background = "ShamanRestoration",
		},
	} -- [3]
};

talents.warlock = {
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Suppression",
					ranks = 5,
					column = 2,
					icon = 136230,
					row = 1,
					tips = "Reduces the chance for enemies to resist your Affliction spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [1]
			{
				info = {
					name = "Improved Corruption",
					ranks = 5,
					column = 3,
					icon = 136118,
					row = 1,
					tips = "Reduces the casting time of your Corruption spell by %.1f sec.",
					tipValues = {{0.4}, {0.8}, {1.2}, {1.6}, {2.0}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Curse of Weakness",
					ranks = 3,
					column = 1,
					icon = 136138,
					row = 2,
					tips = "Increases the effect of your Curse of Weakness by %d%%.",
					tipValues = {{6}, {13}, {20}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Drain Soul",
					ranks = 2,
					column = 2,
					icon = 136163,
					row = 2,
					tips = "Gives you a %d%% chance to get a 100%% increase to your Mana regeneration for 10 sec if the target is killed by you while you drain its soul.  In addition your Mana may continue to regenerate while casting at 50%% of normal.",
					tipValues = {{50}, {100}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Life Tap",
					ranks = 2,
					column = 3,
					icon = 136126,
					row = 2,
					tips = "Increases the amount of Mana awarded by your Life Tap spell by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Drain Life",
					ranks = 5,
					column = 4,
					icon = 136169,
					row = 2,
					tips = "Increases the Health drained by your Drain Life spell by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [6]
			{
				info = {
					name = "Improved Curse of Agony",
					ranks = 3,
					column = 1,
					icon = 136139,
					row = 3,
					tips = "Increases the damage done by your Curse of Agony by %d%%.",
					tipValues = {{2}, {4}, {6}}
				},
			}, -- [7]
			{
				info = {
					name = "Fel Concentration",
					ranks = 5,
					column = 2,
					icon = 136157,
					row = 3,
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while channeling the Drain Life, Drain Mana, or Drain Soul spell.",
					tipValues = {{14}, {28}, {42}, {56}, {70}}
				},
			}, -- [8]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Amplify Curse",
					icon = 136132,
					column = 3,
					exceptional = 1,
					row = 3,
					tips = "Increases the effect of your next Curse of Weakness or Curse of Agony by 50%%, or your next Curse of Exhaustion by 20%%.  Lasts 30 sec.",
				},
			}, -- [9]
			{
				info = {
					name = "Grim Reach",
					ranks = 2,
					column = 1,
					icon = 136127,
					row = 4,
					tips = "Increases the range of your Affliction spells by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [10]
			{
				info = {
					name = "Nightfall",
					ranks = 2,
					column = 2,
					icon = 136223,
					row = 4,
					tips = "Gives your Corruption and Drain Life spells a %d%% chance to cause you to enter a Shadow Trance state after damaging the opponent.  The Shadow Trance state reduces the casting time of your next Shadow Bolt spell by 100%%.",
					tipValues = {{2}, {4}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Drain Mana",
					ranks = 2,
					column = 4,
					icon = 136208,
					row = 4,
					tips = "Causes %d%% of the Mana drained by your Drain Mana spell to damage the opponent.",
					tipValues = {{15}, {30}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Siphon Life",
					icon = 136188,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Transfers 15 health from the target to the caster every 3 sec.  Lasts 30 sec.",
				},
			}, -- [13]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Curse of Exhaustion",
					icon = 136162,
					column = 3,
					exceptional = 1,
					row = 5,
					tips = "Reduces the target's movement speed by 10%% for 12 sec.  Only one Curse per Warlock can be active on any one target.",
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Improved Curse of Exhaustion",
					ranks = 4,
					column = 4,
					icon = 136162,
					row = 5,
					tips = "Increases the speed reduction of your Curse of Exhaustion by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}}
				},
			}, -- [15]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Shadow Mastery",
					ranks = 5,
					column = 2,
					icon = 136195,
					row = 6,
					tips = "Increases the damage dealt or life drained by your Shadow spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [16]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Dark Pact",
					icon = 136141,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Drains 150 of your pet's Mana, returning 100%% to you.",
				},
			}, -- [17]
		},
		info = {
			name = "Affliction",
			background = "WarlockCurses",
		},
	}, -- [1]
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Improved Healthstone",
					ranks = 2,
					column = 1,
					icon = 135230,
					row = 1,
					tips = "Increases the amount of Health restored by your Healthstone by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [1]
			{
				info = {
					name = "Improved Imp",
					ranks = 3,
					column = 2,
					icon = 136218,
					row = 1,
					tips = "Increases the effect of your Imp's Firebolt, Fire Shield, and Blood Pact spells by %d%%.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [2]
			{
				info = {
					name = "Demonic Embrace",
					ranks = 5,
					column = 3,
					icon = 136172,
					row = 1,
					tips = "Increases your total Stamina by %d%% but reduces your total Spirit by %d%%.",
					tipValues = {{3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Health Funnel",
					ranks = 2,
					column = 1,
					icon = 136168,
					row = 2,
					tips = "Increases the amount of Health transferred by your Health Funnel spell by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Voidwalker",
					ranks = 3,
					column = 2,
					icon = 136221,
					row = 2,
					tips = "Increases the effectiveness of your Voidwalker's Torment, Consume Shadows, Sacrifice and Suffering spells by %d%%.",
					tipValues = {{10}, {20}, {30}}
				},
			}, -- [5]
			{
				info = {
					name = "Fel Intellect",
					ranks = 5,
					column = 3,
					icon = 135932,
					row = 2,
					tips = "Increases the maximum Mana of your Imp, Voidwalker, Succubus, and Felhunter by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [6]
			{
				info = {
					name = "Improved Succubus",
					ranks = 3,
					column = 1,
					icon = 136220,
					row = 3,
					tips = "Increases the effect of your Succubus' Lash of Pain and Soothing Kiss spells by %d%%, and increases the duration of your Succubus' Seduction and Lesser Invisibility spells by %d%%.",
					tipValues = {{10, 10}, {20, 20}, {30, 30}}
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Fel Domination",
					icon = 136082,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Your next Imp, Voidwalker, Succubus, or Felhunter Summon spell has its casting time reduced by 5.5 sec and its Mana cost reduced by 50%%.",
				},
			}, -- [8]
			{
				info = {
					name = "Fel Stamina",
					ranks = 5,
					column = 3,
					icon = 136121,
					row = 3,
					tips = "Increases the maximum Health of your Imp, Voidwalker, Succubus, and Felhunter by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [9]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Master Summoner",
					ranks = 2,
					column = 2,
					icon = 136164,
					row = 4,
					tips = "Reduces the casting time of your Imp, Voidwalker, Succubus, and Felhunter Summoning spells by %d sec and the Mana cost by %d%%.",
					tipValues = {{2, 20}, {4, 40}}
				},
			}, -- [10]
			{
				info = {
					name = "Unholy Power",
					ranks = 5,
					column = 3,
					icon = 136206,
					row = 4,
					tips = "Increases the damage done by your Voidwalker, Succubus, and Felhunter's melee attacks by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Enslave Demon",
					ranks = 5,
					column = 1,
					icon = 136154,
					row = 5,
					tips = "Reduces the Attack Speed and Casting Speed penalty of your Enslave Demon spell by %d%% and reduces the resist chance by %d%%.",
					tipValues = {{2, 2}, {4, 4}, {6, 6}, {8, 8}, {10, 10}}
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Demonic Sacrifice",
					icon = 136184,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "When activated, sacrifices your summoned demon to grant you an effect that lasts 30 min.  The effect is canceled if any Demon is summoned.\r\n\r\nImp: Increases your Fire damage by 15%%.\r\n\r\nVoidwalker: Restores 3%% of total Health every 4 sec.\r\n\r\nSuccubus: Increases your Shadow damage by 15%%.\r\n\r\nFelhunter: Restores 2%% of total Mana every 4 sec.",
				},
			}, -- [13]
			{
				info = {
					name = "Improved Firestone",
					ranks = 2,
					column = 4,
					icon = 132386,
					row = 5,
					tips = "Increases the bonus Fire damage from Firestones and the Firestone effect by %d%%.",
					tipValues = {{15}, {30}}
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 11,
						}, -- [1]
					},
					name = "Master Demonologist",
					ranks = 5,
					column = 3,
					icon = 136203,
					row = 6,
					tips = "Grants both the Warlock and the summoned demon an effect as long as that demon is active.\r\n\r\nImp - Reduces threat caused by %d%%.\r\n\r\nVoidwalker - Reduces physical damage taken by %d%%.\r\n\r\nSuccubus - Increases all damage caused by %d%%.\r\n\r\nFelhunter - Increases all resistances by %.1f per level.",
					tipValues = {{4, 2, 2, 0.2}, {8, 4, 4, 0.4}, {12, 6, 6, 0.6}, {16, 8, 8, 0.8}, {20, 10, 10, 1}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Soul Link",
					icon = 136160,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "When active, 30%% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, or Felhunter demon instead.  In addition, both the demon and master will inflict 3%% more damage.  Lasts as long as the demon is active.",
				},
			}, -- [16]
			{
				info = {
					name = "Improved Spellstone",
					ranks = 2,
					column = 3,
					icon = 134131,
					row = 7,
					tips = "Increases the amount of damage absorbed by your Spellstone by %d%%.",
					tipValues = {{15}, {30}}
				},
			}, -- [17]
		},
		info = {
			name = "Demonology",
			background = "WarlockSummoning",
		},
	}, -- [2]
	{
		numtalents = 16,
		talents = {
			{
				info = {
					name = "Improved Shadow Bolt",
					ranks = 5,
					column = 2,
					icon = 136197,
					row = 1,
					tips = "Your Shadow Bolt critical strikes increase Shadow damage dealt to the target by %d%% until 4 non-periodic damage sources are applied.  Effect lasts a maximum of 12 sec.",
					tipValues = {{4}, {8}, {12}, {16}, {20}}
				},
			}, -- [1]
			{
				info = {
					name = "Cataclysm",
					ranks = 5,
					column = 3,
					icon = 135831,
					row = 1,
					tips = "Reduces the Mana cost of your Destruction spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [2]
			{
				info = {
					name = "Bane",
					ranks = 5,
					column = 2,
					icon = 136146,
					row = 2,
					tips = "Reduces the casting time of your Shadow Bolt and Immolate spells by %.1f sec and your Soul Fire spell by %.1f sec.",
					tipValues = {{0.1, 0.4}, {0.2, 0.8}, {0.3, 1.2}, {0.4, 1.6}, {0.5, 2.0}}
				},
			}, -- [3]
			{
				info = {
					name = "Aftermath",
					ranks = 5,
					column = 3,
					icon = 135805,
					row = 2,
					tips = "Gives your Destruction spells a %d%% chance to daze the target for 5 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Firebolt",
					ranks = 2,
					column = 1,
					icon = 135809,
					row = 3,
					tips = "Reduces the casting time of your Imp's Firebolt spell by %.1f sec.",
					tipValues = {{0.5}, {1.0}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Lash of Pain",
					ranks = 2,
					column = 2,
					icon = 136136,
					row = 3,
					tips = "Reduces the cooldown of your Succubus' Lash of Pain spell by %d sec.",
					tipValues = {{3}, {6}}
				},
			}, -- [6]
			{
				info = {
					name = "Devastation",
					ranks = 5,
					column = 3,
					icon = 135813,
					row = 3,
					tips = "Increases the critical strike chance of your Destruction spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					tipValues = {},
					name = "Shadowburn",
					icon = 136191,
					column = 4,
					exceptional = 1,
					row = 3,
					tips = "Instantly blasts the target for 87 to 99 Shadow damage.  If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.",
				},
			}, -- [8]
			{
				info = {
					name = "Intensity",
					ranks = 2,
					column = 1,
					icon = 135819,
					row = 4,
					tips = "Gives you a %d%% chance to resist interruption caused by damage while channeling the Rain of Fire, Hellfire or Soul Fire spell.",
					tipValues = {{35}, {70}}
				},
			}, -- [9]
			{
				info = {
					name = "Destructive Reach",
					ranks = 2,
					column = 2,
					icon = 136133,
					row = 4,
					tips = "Increases the range of your Destruction spells by %d%%.",
					tipValues = {{10}, {20}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Searing Pain",
					ranks = 5,
					column = 4,
					icon = 135827,
					row = 4,
					tips = "Increases the critical strike chance of your Searing Pain spell by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [11]
			{
				info = {
					prereqs = {
						{
							column = 1,
							row = 4,
							source = 9,
						}, -- [1]
					},
					name = "Pyroclasm",
					ranks = 2,
					column = 1,
					icon = 135830,
					row = 5,
					tips = "Gives your Rain of Fire, Hellfire, and Soul Fire spells a %d%% chance to stun the target for 3 sec.",
					tipValues = {{13}, {26}}
				},
			}, -- [12]
			{
				info = {
					name = "Improved Immolate",
					ranks = 5,
					column = 2,
					icon = 135817,
					row = 5,
					tips = "Increases the initial damage of your Immolate spell by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [13]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Ruin",
					ranks = 1,
					tipValues = {},
					column = 3,
					icon = 136207,
					row = 5,
					tips = "Increases the critical strike damage bonus of your Destruction spells by 100%%.",
				},
			}, -- [14]
			{
				info = {
					name = "Emberstorm",
					ranks = 5,
					column = 3,
					icon = 135826,
					row = 6,
					tips = "Increases the damage done by your Fire spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [15]
			{
				info = {
					ranks = 1,
					tipValues = {},
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Conflagrate",
					icon = 135807,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Ignites a target that is already afflicted by Immolate, dealing 240 to 306 Fire damage and consuming the Immolate spell.",
				},
			}, -- [16]
		},
		info = {
			name = "Destruction",
			background = "WarlockDestruction",
		},
	} -- [3]
};

talents.warrior = {
	{
		numtalents = 18,
		talents = {
			{
				info = {
					name = "Improved Heroic Strike",
					tips = "Reduces the cost of your Heroic Strike ability by %d rage points.",
					column = 1,
					row = 1,
					icon = 132282,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [1]
			{
				info = {
					name = "Deflection",
					tips = "Increases your Parry chance by %d%%.",
					column = 2,
					row = 1,
					icon = 132269,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Rend",
					tips = "Increases the bleed damage done by your Rend ability by %d%%.",
					column = 3,
					row = 1,
					icon = 132155,
					ranks = 3,
					tipValues = {{15}, {25}, {35}}
				},
			}, -- [3]
			{
				info = {
					name = "Improved Charge",
					tips = "Increases the amount of rage generated by your Charge ability by %d.",
					column = 1,
					row = 2,
					icon = 132337,
					ranks = 2,
					tipValues = {{3}, {6}}
				},
			}, -- [4]
			{
				info = {
					name = "Tactical Mastery",
					tips = "You retain up to %d of your rage points when you change stances.",
					column = 2,
					row = 2,
					icon = 136031,
					ranks = 5,
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [5]
			{
				info = {
					name = "Improved Thunder Clap",
					tips = "Reduces the cost of your Thunder Clap ability by %d rage points.",
					column = 4,
					row = 2,
					icon = 132326,
					ranks = 3,
					tipValues = {{1}, {2}, {4}}
				},
			}, -- [6]
			{
				info = {
					name = "Improved Overpower",
					tips = "Increases the critical strike chance of your Overpower ability by %d%%.",
					column = 1,
					row = 3,
					icon = 135275,
					ranks = 2,
					tipValues = {{25}, {50}, {75}}
				},
			}, -- [7]
			{
				info = {
					tips = "Increases the time required for your rage to decay while out of combat by 30%%.",
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 5,
						}, -- [1]
					},
					name = "Anger Management",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 135881,
					ranks = 1,
					tipValues = {},
				},
			}, -- [8]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 1,
							source = 3,
						}, -- [1]
					},
					name = "Deep Wounds",
					tips = "Your critical strikes cause the opponent to bleed, dealing %d%% of your melee weapon's average damage over 12 sec.",
					column = 3,
					row = 3,
					icon = 132090,
					ranks = 3,
					tipValues = {{20}, {40}, {60}}
				},
			}, -- [9]
			{
				info = {
					name = "Two-Handed Weapon Specialization",
					tips = "Increases the damage you deal with two-handed melee weapons by %d%%.",
					column = 2,
					row = 4,
					icon = 132400,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [10]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Impale",
					tips = "Increases the critical strike damage bonus of your abilities in Battle, Defensive, and Berserker stance by %d%%.",
					column = 3,
					row = 4,
					icon = 132312,
					ranks = 2,
					tipValues = {{10}, {20}}
				},
			}, -- [11]
			{
				info = {
					name = "Axe Specialization",
					tips = "Increases your chance to get a critical strike with Axes by %d%%.",
					column = 1,
					row = 5,
					icon = 132397,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [12]
			{
				info = {
					tips = "Your next 5 melee attacks strike an additional nearby opponent.",
					name = "Sweeping Strikes",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132306,
					ranks = 1,
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					name = "Mace Specialization",
					tips = "Gives you a %d%% chance to stun your target for 3 sec with a Mace.",
					column = 3,
					row = 5,
					icon = 133476,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {6}}
				},
			}, -- [14]
			{
				info = {
					name = "Sword Specialization",
					tips = "Gives you a %d%% chance to get an extra attack on the same target after dealing damage with your Sword.",
					column = 4,
					row = 5,
					icon = 135328,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [15]
			{
				info = {
					name = "Polearm Specialization",
					tips = "Increases your chance to get a critical strike with Polearms by %d%%.",
					column = 1,
					row = 6,
					icon = 135562,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [16]
			{
				info = {
					name = "Improved Hamstring",
					tips = "Gives your Hamstring ability a %d%% chance to immobilize the target for 5 sec.",
					column = 3,
					row = 6,
					icon = 132316,
					ranks = 3,
					tipValues = {{5}, {10}, {15}}
				},
			}, -- [17]
			{
				info = {
					tips = "A vicious strike that deals weapon damage plus 85 and wounds the target, reducing the effectiveness of any healing by 50%% for 10 sec.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Mortal Strike",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 132355,
					ranks = 1,
					tipValues = {},
				},
			}, -- [18]
		},
		info = {
			name = "Arms",
			background = "WarriorArms",
		},
	}, -- [1]
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Booming Voice",
					tips = "Increases the area of effect and duration of your Battle Shout and Demoralizing Shout by %d%%.",
					column = 2,
					row = 1,
					icon = 136075,
					ranks = 5,
					tipValues = {{10}, {20}, {30}, {40}, {50}}
				},
			}, -- [1]
			{
				info = {
					name = "Cruelty",
					tips = "Increases your chance to get a critical strike with melee weapons by %d%%.",
					column = 3,
					row = 1,
					icon = 132292,
					ranks = 5,
					tipValues = {{1}, {2}, {3}, {4}, {5}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Demoralizing Shout",
					tips = "Increases the melee attack power reduction of your Demoralizing Shout by %d%%.",
					column = 2,
					row = 2,
					icon = 132366,
					ranks = 5,
					tipValues = {{8}, {16}, {24}, {32}, {40}}
				},
			}, -- [3]
			{
				info = {
					name = "Unbridled Wrath",
					tips = "Gives you a %d%% chance to generate an additional Rage point when you deal melee damage with a weapon.",
					column = 3,
					row = 2,
					icon = 136097,
					ranks = 5,
					tipValues = {{8}, {16}, {24}, {32}, {40}}
				},
			}, -- [4]
			{
				info = {
					name = "Improved Cleave",
					tips = "Increases the bonus damage done by your Cleave ability by %d%%.",
					column = 1,
					row = 3,
					icon = 132338,
					ranks = 3,
					tipValues = {{40}, {80}, {120}}
				},
			}, -- [5]
			{
				info = {
					tips = "Causes all enemies near the warrior to be dazed, reducing movement speed by 50%% for 6 sec.",
					name = "Piercing Howl",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 136147,
					ranks = 1,
					tipValues = {},
				},
			}, -- [6]
			{
				info = {
					name = "Blood Craze",
					tips = "Regenerates %d%% of your total Health over 6 sec after being the victim of a critical strike.",
					column = 3,
					row = 3,
					icon = 136218,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [7]
			{
				info = {
					name = "Improved Battle Shout",
					tips = "Increases the melee attack power bonus of your Battle Shout by %d%%.",
					column = 4,
					row = 3,
					icon = 132333,
					ranks = 5,
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [8]
			{
				info = {
					name = "Dual Wield Specialization",
					tips = "Increases the damage done by your offhand weapon by %d%%.",
					column = 1,
					row = 4,
					icon = 132147,
					ranks = 5,
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Execute",
					tips = "Reduces the Rage cost of your Execute ability by %d.",
					column = 2,
					row = 4,
					icon = 135358,
					ranks = 2,
					tipValues = {{2}, {5}}
				},
			}, -- [10]
			{
				info = {
					name = "Enrage",
					tips = "Gives you a %d%% melee damage bonus for 12 sec up to a maximum of 12 swings after being the victim of a critical strike.",
					column = 3,
					row = 4,
					icon = 136224,
					ranks = 5,
					tipValues = {{5}, {10}, {15}, {20}, {25}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Slam",
					tips = "Decreases the casting time of your Slam ability by %.1f sec.",
					column = 1,
					row = 5,
					icon = 132340,
					ranks = 5,
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}}
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, increases your physical damage by 20%% and makes you immune to Fear effects, but lowers your armor and all resistances by 20%%.  Lasts 30 sec.",
					name = "Death Wish",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136146,
					ranks = 1,
					tipValues = {},
				},
			}, -- [13]
			{
				info = {
					name = "Improved Intercept",
					tips = "Reduces the cooldown of your Intercept ability by %d sec.",
					column = 4,
					row = 5,
					icon = 132307,
					ranks = 2,
					tipValues = {{5}, {10}}
				},
			}, -- [14]
			{
				info = {
					name = "Improved Berserker Rage",
					tips = "The Berserker Rage ability will generate %d rage when used.",
					column = 1,
					row = 6,
					icon = 136009,
					ranks = 2,
					tipValues = {{5}, {10}}
				},
			}, -- [15]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 11,
						}, -- [1]
					},
					name = "Flurry",
					tips = "Increases your attack speed by %d%% for your next 3 swings after dealing a melee critical strike.",
					column = 3,
					row = 6,
					icon = 132152,
					ranks = 5,
					tipValues = {{10}, {15}, {20}, {25}, {30}}
				},
			}, -- [16]
			{
				info = {
					tips = "Instantly attack the target causing damage equal to 45%% of your attack power.  In addition, the next 5 successful melee attacks will restore 10 health.  This effect lasts 8 sec.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Bloodthirst",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136012,
					ranks = 1,
					tipValues = {},
				},
			}, -- [17]
		},
		info = {
			name = "Fury",
			background = "WarriorFury",
		},
	}, -- [2]
	{
		numtalents = 17,
		talents = {
			{
				info = {
					name = "Shield Specialization",
					tips = "Increases your chance to block attacks with a shield by %d%% and has a %d%% chance to generate 1 rage when a block occurs.",
					column = 2,
					row = 1,
					icon = 134952,
					ranks = 5,
					tipValues = {{1, 20}, {2, 40}, {3, 60}, {4, 80}, {5, 100}}
				},
			}, -- [1]
			{
				info = {
					name = "Anticipation",
					tips = "Increases your Defense skill by %d.",
					column = 3,
					row = 1,
					icon = 136056,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [2]
			{
				info = {
					name = "Improved Bloodrage",
					tips = "Increases the instant Rage generated by your Bloodrage ability by %d.",
					column = 1,
					row = 2,
					icon = 132277,
					ranks = 2,
					tipValues = {{2}, {5}}
				},
			}, -- [3]
			{
				info = {
					name = "Toughness",
					tips = "Increases your armor value from items by %d%%.",
					column = 3,
					row = 2,
					icon = 135892,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [4]
			{
				info = {
					name = "Iron Will",
					tips = "Increases your chance to resist Stun and Charm effects by an additional %d%%.",
					column = 4,
					row = 2,
					icon = 135995,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [5]
			{
				info = {
					tips = "When activated, this ability temporarily grants you 30%% of your maximum hit points for 20 seconds.  After the effect expires, the hit points are lost.",
					prereqs = {
						{
							column = 1,
							row = 2,
							source = 3,
						}, -- [1]
					},
					name = "Last Stand",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 135871,
					ranks = 1,
					tipValues = {},
				},
			}, -- [6]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 1,
							source = 1,
						}, -- [1]
					},
					name = "Improved Shield Block",
					tips = "Allows your Shield Block ability to block an additional attack and increases the duration by %.1f second.",
					column = 2,
					row = 3,
					icon = 132110,
					ranks = 3,
					tipValues = {{0.5}, {1.0}, {2.0}}
				},
			}, -- [7]
			{
				info = {
					name = "Improved Revenge",
					tips = "Gives your Revenge ability a %d%% chance to stun the target for 3 sec.",
					column = 3,
					row = 3,
					icon = 132353,
					ranks = 3,
					tipValues = {{15}, {30}, {45}}
				},
			}, -- [8]
			{
				info = {
					name = "Defiance",
					tips = "Increases the threat generated by your attacks by %d%% while in Defensive Stance.",
					column = 4,
					row = 3,
					icon = 132347,
					ranks = 5,
					tipValues = {{3}, {6}, {9}, {12}, {15}}
				},
			}, -- [9]
			{
				info = {
					name = "Improved Sunder Armor",
					tips = "Reduces the cost of your Sunder Armor ability by %d rage points.",
					column = 1,
					row = 4,
					icon = 132363,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [10]
			{
				info = {
					name = "Improved Disarm",
					tips = "Increases the duration of your Disarm ability by %d secs.",
					column = 2,
					row = 4,
					icon = 132343,
					ranks = 3,
					tipValues = {{1}, {2}, {3}}
				},
			}, -- [11]
			{
				info = {
					name = "Improved Taunt",
					tips = "Reduces the cooldown of your Taunt ability by %d sec.",
					column = 3,
					row = 4,
					icon = 136080,
					ranks = 2,
					tipValues = {{1}, {2}}
				},
			}, -- [12]
			{
				info = {
					name = "Improved Shield Wall",
					tips = "Increases the effect duration of your Shield Wall ability by %d secs.",
					column = 1,
					row = 5,
					icon = 132362,
					ranks = 2,
					tipValues = {{3}, {5}}
				},
			}, -- [13]
			{
				info = {
					tips = "Stuns the opponent for 5 sec.",
					name = "Concussion Blow",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132325,
					ranks = 1,
					tipValues = {},
				},
			}, -- [14]
			{
				info = {
					name = "Improved Shield Bash",
					tips = "Gives your Shield Bash ability a %d%% chance to silence the target for 3 sec.",
					column = 3,
					row = 5,
					icon = 132357,
					ranks = 2,
					tipValues = {{50}, {100}}
				},
			}, -- [15]
			{
				info = {
					name = "One-Handed Weapon Specialization",
					tips = "Increases the damage you deal with One-Handed Melee weapons by %d%%.",
					column = 3,
					row = 6,
					icon = 135321,
					ranks = 5,
					tipValues = {{2}, {4}, {6}, {8}, {10}}
				},
			}, -- [16]
			{
				info = {
					tips = "Slam the target with your shield, causing 225 to 235 damage, modified by your shield block value, and has a 50%% chance of dispelling 1 magic effect on the target.  Also causes a high amount of threat.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Shield Slam",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 134951,
					ranks = 1,
					tipValues = {},
				},
			}, -- [17]
		},
		info = {
			name = "Protection",
			background = "WarriorProtection",
		},
	} -- [3]
};

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