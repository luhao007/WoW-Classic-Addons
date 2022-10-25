----------------------------------
---NovaRaidCompanion Talent Data--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isTBC) then
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
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Starlight Wrath",
					tips = "Reduces the cast time of your Wrath and Starfire spells by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					column = 1,
					row = 1,
					icon = 136006,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					tips = "While active, any time an enemy strikes the caster they have a 35% chance to become afflicted by Entangling Roots (Rank 1).  Only useable outdoors.  1 charge.  Lasts 45 sec.",
					name = "Nature's Grasp",
					row = 1,
					column = 2,
					exceptional = 1,
					icon = 136063,
					ranks = 1,
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
					tips = "Increases the chance for your Nature's Grasp to entangle an enemy by %d%%.",
					tipValues = {{15}, {30}, {45}, {65}},
					column = 3,
					row = 1,
					icon = 136063,
					ranks = 4,
				},
			}, -- [3]
			{
				info = {
					name = "Control of Nature",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting Entangling Roots and Cyclone.",
					tipValues = {{40}, {70}, {100}},
					column = 1,
					row = 2,
					icon = 136100,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					name = "Focused Starlight",
					tips = "Increases the critical strike chance of your Wrath and Starfire spells by %d%%.",
					tipValues = {{2}, {4}},
					column = 2,
					row = 2,
					icon = 135138,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Moonfire",
					tips = "Increases the damage and critical strike chance of your Moonfire spell by %d%%.",
					tipValues = {{5}, {10}},
					column = 3,
					row = 2,
					icon = 136096,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Brambles",
					tips = "Increases damage caused by your Thorns and Entangling Roots spells by %d%%.",
					tipValues = {{25}, {50}, {75}},
					column = 1,
					row = 3,
					icon = 136104,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					tips = "The enemy target is swarmed by insects, decreasing their chance to hit by 2% and causing 108 Nature damage over 12 sec.",
					name = "Insect Swarm",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 136045,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Nature's Reach",
					tips = "Increases the range of your Balance spells and Faerie Fire (Feral) ability by %d%%.",
					tipValues = {{10}, {20}},
					column = 4,
					row = 3,
					icon = 136065,
					ranks = 2,
				},
			}, -- [9]
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
					tips = "Increases the critical strike damage bonus of your Starfire, Moonfire, and Wrath spells by %d%%.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 2,
					row = 4,
					icon = 136075,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					name = "Celestial Focus",
					tips = "Gives your Starfire spell a %d%% chance to stun the target for 3 sec and increases the chance you'll resist spell interruption when casting your Wrath spell by %d%%.",
					tipValues = {{5, 25}, {10, 50}, {15, 70}}, 
					column = 3,
					row = 4,
					icon = 135753,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					name = "Lunar Guidance",
					tips = "Increases your spell damage and healing by %d%% of your total Intellect.",
					tipValues = {{8}, {16}, {25}},
					column = 1,
					row = 5,
					icon = 132132,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Nature's Grace",
					tips = "All spell criticals grace you with a blessing of nature, reducing the casting time of your next spell by 0.5 sec.",
					column = 2,
					row = 5,
					icon = 136062,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					name = "Moonglow",
					tips = "Reduces the Mana cost of your Moonfire, Starfire, Wrath, Healing Touch, Regrowth and Rejuvenation spells by %d%%.",
					tipValues = {{3}, {6}, {9}},
					column = 3,
					row = 5,
					icon = 136087,
					ranks = 3,
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
					tips = "Increases the damage done by your Starfire, Moonfire and Wrath spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 6,
					icon = 136057,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Balance of Power",
					tips = "Increases your chance to hit with all spells and reduces the chance you'll be hit by spells by %d%%.",
					tipValues = {{2}, {4}},
					column = 3,
					row = 6,
					icon = 132113,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					name = "Dreamstate",
					tips = "Regenerate mana equal to %d%% of your Intellect every 5 sec, even while casting.",
					tipValues = {{4}, {7}, {10}},
					column = 1,
					row = 7,
					icon = 132123,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "Shapeshift into Moonkin Form.  While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.  Melee attacks in this form have a chance on hit to regenerate mana based on attack power.  The Moonkin can only cast Balance and Remove Curse spells while shapeshifted.\r\n\r\nThe act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
					name = "Moonkin Form",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136036,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Improved Faerie Fire",
					tips = "Your Faerie Fire spell also increases the chance the target will be hit by melee and ranged attacks by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 3,
					row = 7,
					icon = 136033,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					name = "Wrath of Cenarius",
					tips = "Your Starfire spell gains an additional %d%% and your Wrath gains an additional %d%% of your bonus damage effects.",
					tipValues = {{4, 2}, {8, 4}, {12, 6}, {16, 8}, {20, 10}}, 
					column = 2,
					row = 8,
					icon = 132146,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Summons 3 treants to attack enemy targets for 30 sec.",
					name = "Force of Nature",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132129,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Balance",
			background = "DruidBalance",
		},
	}, -- [1]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Ferocity",
					tips = "Reduces the cost of your Maul, Swipe, Claw, Rake and Mangle abilities by %d Rage or Energy.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 1,
					icon = 132190,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Feral Aggression",
					tips = "Increases the attack power reduction of your Demoralizing Roar by %d%% and the damage caused by your Ferocious Bite by %d%%.",
					tipValues = {{8, 3}, {16, 6}, {24, 9}, {32, 12}, {40, 15}}, 
					column = 3,
					row = 1,
					icon = 132121,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Feral Instinct",
					tips = "Increases threat caused in Bear and Dire Bear Form by %d%% and reduces the chance enemies have to detect you while Prowling.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 2,
					icon = 132089,
					ranks = 3,
				},
			}, -- [3]
			{
				info = {
					name = "Brutal Impact",
					tips = "Increases the stun duration of your Bash and Pounce abilities by %.1f sec.",
					tipValues = {{0.5}, {1.0}},
					column = 2,
					row = 2,
					icon = 132114,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Thick Hide",
					tips = "Increases your Armor contribution from items by %d%%.",
					tipValues = {{4}, {7}, {10}},
					column = 3,
					row = 2,
					icon = 134355,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Feral Swiftness",
					tips = "Increases your movement speed by %d%% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by %d%%.",
					tipValues = {{15, 2}, {30, 4}},
					column = 1,
					row = 3,
					icon = 136095,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					tips = "Causes you to charge an enemy, immobilizing and interrupting any spell being cast for 4 sec.",
					name = "Feral Charge",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 132183,
					ranks = 1,
				},
			}, -- [7]
			{
				info = {
					name = "Sharpened Claws",
					tips = "Increases your critical strike chance while in Bear, Dire Bear or Cat Form by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 3,
					row = 3,
					icon = 134297,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					name = "Shredding Attacks",
					tips = "Reduces the energy cost of your Shred ability by %d and the rage cost of your Lacerate ability by %d.",
					tipValues = {{9, 1}, {18, 2}},
					column = 1,
					row = 4,
					icon = 136231,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Predatory Strikes",
					tips = "Increases your melee attack power in Cat, Bear, Dire Bear and Moonkin Forms by %d%% of your level.",
					tipValues = {{50}, {100}, {150}},
					column = 2,
					row = 4,
					icon = 132185,
					ranks = 3,
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
					name = "Primal Fury",
					tips = "Gives you a %d%% chance to gain an additional 5 Rage anytime you get a critical strike while in Bear and Dire Bear Form and your critical strikes from Cat Form abilities that add combo points  have a %d%% chance to add an additional combo point.",
					tipValues = {{50, 50}, {100, 100}},
					column = 3,
					row = 4,
					icon = 132278,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Savage Fury",
					tips = "Increases the damage caused by your Claw, Rake, and Mangle (Cat) abilities by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 5,
					icon = 132141,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "Decrease the armor of the target by 175 for 40 sec.  While affected, the target cannot stealth or turn invisible.",
					name = "Faerie Fire (Feral)",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 136033,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					name = "Nurturing Instinct",
					tips = "Increases your healing spells by up to %d%% of your Agility, and increases healing done to you by %d%% while in Cat form.",
					tipValues = {{50, 10}, {100, 20}},
					column = 4,
					row = 5,
					icon = 132130,
					ranks = 2,
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
					tips = "Increases your Intellect by %d%%.  In addition, while in Bear or Dire Bear Form your Stamina is increased by %d%% and while in Cat Form your attack power is increased by %d%%.",
					tipValues = {{4, 4, 2}, {8, 8, 4}, {12, 12, 6}, {16, 16, 8}, {20, 20, 10}},
					column = 2,
					row = 6,
					icon = 135879,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Survival of the Fittest",
					tips = "Increases all attributes by %d%% and reduces the chance you'll be critically hit by melee attacks by %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}},
					column = 3,
					row = 6,
					icon = 132126,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					name = "Primal Tenacity",
					tips = "Increases your chance to resist Stun and Fear mechanics by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 7,
					icon = 132139,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "While in Cat, Bear or Dire Bear Form, the Leader of the Pack increases ranged and melee critical chance of all party members within 45 yards by 5%.",
					name = "Leader of the Pack",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136112,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Improved Leader of the Pack",
					tips = "Your Leader of the Pack ability also causes affected targets to have a 100%% chance to heal themselves for %d%% of their total health when they critically hit with a melee or ranged attack.  The healing effect cannot occur more than once every 6 sec.",
					tipValues = {{2}, {4}},
					column = 3,
					row = 7,
					icon = 136112,
					ranks = 2,
				},
			}, -- [19]
			{
				info = {
					name = "Predatory Instincts",
					tips = "While in Cat Form, Bear Form, or Dire Bear Form, increases your damage from melee critical strikes by %d%% and your chance to avoid area effect attacks by %d%%.",
					tipValues = {{2, 3}, {4, 6}, {6, 9}, {8, 12}, {10, 15}},
					column = 3,
					row = 8,
					icon = 132138,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Mangle",
					tips = "Mangle the target, inflicting damage and causing the target to take additional damage from bleed effects for 12 sec.  This ability can be used in Cat Form or Dire Bear Form.",
					column = 2,
					row = 9,
					icon = 132135,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Feral Combat",
			background = "DruidFeralCombat",
		},
	}, -- [2]
	{
		numtalents = 20,
		talents = {
			{
				info = {
					name = "Improved Mark of the Wild",
					tips = "Increases the effects of your Mark of the Wild and Gift of the Wild spells by %d%%.",
					tipValues = {{7}, {14}, {21}, {28}, {35}},
					column = 2,
					row = 1,
					icon = 136078,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Furor",
					tips = "Gives you %d%% chance to gain 10 Rage when you shapeshift into Bear and Dire Bear Form or 40 Energy when you shapeshift into Cat Form.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 3,
					row = 1,
					icon = 135881,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Naturalist",
					tips = "Reduces the cast time of your Healing Touch spell by %.1f sec and increases the damage you deal with physical attacks in all forms by %d%%.",
					tipValues = {{0.1, 2}, {0.2, 4}, {0.3, 6}, {0.4, 8}, {0.5, 10}},
					column = 1,
					row = 2,
					icon = 136041,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Nature's Focus",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting the Healing Touch, Regrowth and Tranquility spells.",
					tipValues = {{14}, {28}, {42}, {56}, {70}},
					column = 2,
					row = 2,
					icon = 136042,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Natural Shapeshifter",
					tips = "Reduces the mana cost of all shapeshifting by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 3,
					row = 2,
					icon = 136116,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Intensity",
					tips = "Allows %d%% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate %d rage.",
					tipValues = {{10, 4}, {20, 7}, {30, 10}},
					column = 1,
					row = 3,
					icon = 135863,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					name = "Subtlety",
					tips = "Reduces the threat generated by your spells by %d%% and reduces the chance your spells will be dispelled by %d%%.",
					tipValues = {{4, 6}, {8, 12}, {12, 18}, {16, 24}, {20, 30}},
					column = 2,
					row = 3,
					icon = 132150,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "Imbues the Druid with natural energy.  Each of the Druid's melee attacks has a chance of causing the caster to enter a Clearcasting state.  The Clearcasting state reduces the Mana, Rage or Energy cost of your next damage or healing spell or offensive ability by 100%.  Lasts 30 min.",
					name = "Omen of Clarity",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 136017,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Tranquil Spirit",
					tips = "Reduces the mana cost of your Healing Touch and Tranquility spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 4,
					icon = 135900,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Rejuvenation",
					tips = "Increases the effect of your Rejuvenation spell by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 3,
					row = 4,
					icon = 136081,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					tips = "When activated, your next Nature spell becomes an instant cast spell.",
					prereqs = {
						{
							column = 1,
							row = 3,
							source = 6,
						}, -- [1]
					},
					name = "Nature's Swiftness",
					row = 5,
					column = 1,
					exceptional = 1,
					icon = 136076,
					ranks = 1,
				},
			}, -- [11]
			{
				info = {
					name = "Gift of Nature",
					tips = "Increases the effect of all healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 5,
					icon = 136074,
					ranks = 5,
				},
			}, -- [12]
			{
				info = {
					name = "Improved Tranquility",
					tips = "Reduces threat caused by Tranquility by %d%%.",
					tipValues = {{50}, {100}},
					column = 4,
					row = 5,
					icon = 136107,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					name = "Empowered Touch",
					tips = "Your Healing Touch spell gains an additional %d%% of your bonus healing effects.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 6,
					icon = 132125,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 10,
						}, -- [1]
					},
					name = "Improved Regrowth",
					tips = "Increases the critical effect chance of your Regrowth spell by %d%%.",
					tipValues = {{10}, {20}, {30}, {40}, {50}},
					column = 3,
					row = 6,
					icon = 136085,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Living Spirit",
					tips = "Increases your total Spirit by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 7,
					icon = 136037,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					tips = "Consumes a Rejuvenation or Regrowth effect on a friendly target to instantly heal them an amount equal to 12 sec. of Rejuvenation or 18 sec. of Regrowth.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Swiftmend",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 134914,
					ranks = 1,
				},
			}, -- [17]
			{
				info = {
					name = "Natural Perfection",
					tips = "Your critical strike chance with all spells is increased by %d%% and critical strikes against you give you the Natural Perfection effect reducing all damage taken by %d%%.  Stacks up to 3 times.  Lasts 8 sec.",
					tipValues = {{1, 2}, {2,3 }, {3, 4}},
					column = 3,
					row = 7,
					icon = 132137,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					name = "Empowered Rejuvenation",
					tips = "The bonus healing effects of your healing over time spells is increased by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 2,
					row = 8,
					icon = 132124,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					tips = "Shapeshift into the Tree of Life.  While in this form you increase healing received by 25% of your total Spirit for all party members within 45 yards, your movement speed is reduced by 20%, and you can only cast Swiftmend, Innervate, Nature's Swiftness, Rebirth, Barkskin, poison removing and healing over time spells, but the mana cost of these spells is reduced by 20%.\r\n\r\nThe act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 19,
						}, -- [1]
					},
					name = "Tree of Life",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132145,
					ranks = 1,
				},
			}, -- [20]
		},
		info = {
			name = "Restoration",
			background = "DruidRestoration",
		},
	}, -- [3]
}

talents.hunter = {
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Improved Aspect of the Hawk",
					tips = "While Aspect of the Hawk is active, all normal ranged attacks have a 10%% chance of increasing ranged attack speed by %d%% for 12 sec.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 2,
					row = 1,
					icon = 136076,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Endurance Training",
					tips = "Increases the Health of your pet by %d%% and your total health by %d%%.",
					tipValues = {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}},
					column = 3,
					row = 1,
					icon = 136080,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Focused Fire",
					tips = "All damage caused by you is increased by %d%% while your pet is active and the critical strike chance of your Kill Command ability is increased by %d%%.",
					tipValues = {{1, 10}, {2, 20}},
					column = 1,
					row = 2,
					icon = 132210,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Aspect of the Monkey",
					tips = "Increases the Dodge bonus of your Aspect of the Monkey by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 2,
					row = 2,
					icon = 132159,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					name = "Thick Hide",
					tips = "Increases the armor rating of your pets by %d%% and your armor contribution from items by %d%%.",
					tipValues = {{7, 4}, {14, 7}, {20, 10}},
					column = 3,
					row = 2,
					icon = 134355,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Revive Pet",
					tips = "Revive Pet's casting time is reduced by %d sec, mana cost is reduced by %d%%, and increases the health your pet returns with by an additional %d%%.",
					tipValues = {{3, 20, 15}, {6, 40, 30}},
					column = 4,
					row = 2,
					icon = 132163,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Pathfinding",
					tips = "Increases the speed bonus of your Aspect of the Cheetah and Aspect of the Pack by %d%%.",
					tipValues = {{4}, {8}},
					column = 1,
					row = 3,
					icon = 132242,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					name = "Bestial Swiftness",
					tips = "Increases the outdoor movement speed of your pets by 30%.",
					column = 2,
					row = 3,
					icon = 132120,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Unleashed Fury",
					tips = "Increases the damage done by your pets by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 3,
					row = 3,
					icon = 132091,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Mend Pet",
					tips = "Reduces the mana cost of your Mend Pet spell by %d%% and gives the Mend Pet spell a %d%% chance of cleansing 1 Curse, Disease, Magic or Poison effect from the pet each tick.",
					tipValues = {{10, 25}, {20, 50}},
					column = 2,
					row = 4,
					icon = 132179,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Ferocity",
					tips = "Increases the critical strike chance of your pet by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 4,
					icon = 134297,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					name = "Spirit Bond",
					tips = "While your pet is active, you and your pet will regenerate %d%% of total health every 10 sec.",
					tipValues = {{1}, {2}},
					column = 1,
					row = 5,
					icon = 132121,
					ranks = 2,
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
				},
			}, -- [13]
			{
				info = {
					name = "Bestial Discipline",
					tips = "Increases the Focus regeneration of your pets by %d%%.",
					tipValues = {{50}, {100}},
					column = 4,
					row = 5,
					icon = 136006,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					name = "Animal Handler",
					tips = "Increases your speed while mounted by %d%% and your pet's chance to hit by %d%%.  The mounted movement speed increase does not stack with other effects.",
					tipValues = {{4, 2}, {8, 4}},
					column = 1,
					row = 6,
					icon = 132158,
					ranks = 2,
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
					name = "Frenzy",
					tips = "Gives your pet a %d%% chance to gain a 30%% attack speed increase for 8 sec after dealing a critical strike.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 3,
					row = 6,
					icon = 134296,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Ferocious Inspiration",
					tips = "When your pet scores a critical hit, all party members have all damage increased by %d%% for 10 sec.",
					tipValues = {{1}, {2}, {3}},
					column = 1,
					row = 7,
					icon = 132173,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "Send your pet into a rage causing 50% additional damage for 18 sec.  While enraged, the beast does not feel pity or remorse or fear and it cannot be stopped unless killed.",
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
				},
			}, -- [18]
			{
				info = {
					name = "Catlike Reflexes",
					tips = "Increases your chance to dodge by %d%% and your pet's chance to dodge by an additional %d%%.",
					tipValues = {{1, 3}, {2, 6}, {3, 9}},
					column = 3,
					row = 7,
					icon = 132167,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					name = "Serpent's Swiftness",
					tips = "Increases ranged combat attack speed by %d%% and your pet's melee attack speed by %d%%.",
					tipValues = {{4, 4}, {8, 8}, {12, 12}, {16, 16}, {20, 20}},
					column = 3,
					row = 8,
					icon = 132209,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "The Beast Within",
					tips = "When your pet is under the effects of Bestial Wrath, you also go into a rage causing 10% additional damage and reducing mana costs of all spells by 20% for 18 sec.  While enraged, you do not feel pity or remorse or fear and you cannot be stopped unless killed.",
					column = 2,
					row = 9,
					icon = 132166,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Beast Mastery",
			background = "HunterBeastMastery",
		},
	}, -- [1]
	{
		numtalents = 20,
		talents = {
			{
				info = {
					name = "Improved Concussive Shot",
					tips = "Gives your Concussive Shot a %d%% chance to stun the target for 3 sec.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 2,
					row = 1,
					icon = 135860,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Lethal Shots",
					tips = "Increases your critical strike chance with ranged weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 1,
					icon = 132312,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Improved Hunter's Mark",
					tips = "Causes %d%% of your Hunter's Mark ability's base attack power to apply to melee attack power as well.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 2,
					row = 2,
					icon = 132212,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Efficiency",
					tips = "Reduces the Mana cost of your Shots and Stings by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 2,
					icon = 135865,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Go for the Throat",
					tips = "Your ranged critical hits cause your pet to generate %d Focus.",
					tipValues = {{25}, {50}},
					column = 1,
					row = 3,
					icon = 132174,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Arcane Shot",
					tips = "Reduces the cooldown of your Arcane Shot by %.1f sec.",
					tipValues = {{0.2}, {0.4}, {0.6}, {0.8}, {1.0}},
					column = 2,
					row = 3,
					icon = 132218,
					ranks = 5,
				},
			}, -- [6]
			{
				info = {
					tips = "An aimed shot that increases ranged damage by 70 and reduces healing done to that target by 50%.  Lasts 10 sec.",
					name = "Aimed Shot",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 135130,
					ranks = 1,
				},
			}, -- [7]
			{
				info = {
					name = "Rapid Killing",
					tips = "Reduces the cooldown of your Rapid Fire ability by %d min.  In addition, after killing an opponent that yields experience or honor, your next Aimed Shot, Arcane Shot or Auto Shot causes %d%% additional damage.  Lasts 20 sec.",
					tipValues = {{1, 10}, {2, 20}},
					column = 4,
					row = 3,
					icon = 132205,
					ranks = 2,
				},
			}, -- [8]
			{
				info = {
					name = "Improved Stings",
					tips = "Increases the damage done by your Serpent Sting and Wyvern Sting by %d%% and the mana drained by your Viper Sting by %d%%.  In addition, reduces the chance your Stings will be dispelled by %d%%.",
					tipValues = {{6, 6, 6}, {12, 12, 12}, {18, 18, 18}, {24, 24, 24}, {30, 30, 30}},
					column = 2,
					row = 4,
					icon = 132204,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 7,
						}, -- [1]
					},
					name = "Mortal Shots",
					tips = "Increases your ranged weapon critical strike damage bonus by %d%%.",
					tipValues = {{6}, {12}, {18}, {24}, {30}},
					column = 3,
					row = 4,
					icon = 132271,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					name = "Concussive Barrage",
					tips = "Your successful Auto Shot attacks have a %d%% chance to Daze the target for 4 sec.",
					tipValues = {{2}, {4}, {6}},
					column = 1,
					row = 5,
					icon = 135753,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					tips = "A short-range shot that deals 50% weapon damage and disorients the target for 4 sec.  Any damage caused will remove the effect.  Turns off your attack when used.",
					name = "Scatter Shot",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132153,
					ranks = 1,
				},
			}, -- [12]
			{
				info = {
					name = "Barrage",
					tips = "Increases the damage done by your Multi-Shot and Volley spells by %d%%.",
					tipValues = {{4}, {8}, {12}},
					column = 3,
					row = 5,
					icon = 132330,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					name = "Combat Experience",
					tips = "Increases your total Agility by %d%% and your total Intellect by %d%%.",
					tipValues = {{1, 3}, {2, 6}},
					column = 1,
					row = 6,
					icon = 132168,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					name = "Ranged Weapon Specialization",
					tips = "Increases the damage you deal with ranged weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 4,
					row = 6,
					icon = 135615,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Careful Aim",
					tips = "Increases your ranged attack power by an amount equal to %d%% of your total Intellect.",
					tipValues = {{15}, {30}, {45}},
					column = 1,
					row = 7,
					icon = 132217,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					tips = "Increases the attack power of party members within 45 yards by 50.  Lasts until cancelled.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Trueshot Aura",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 132329,
					ranks = 1,
				},
			}, -- [17]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Improved Barrage",
					tips = "Increases the critical strike chance of your Multi-Shot ability by %d%% and gives you a %d%% chance to avoid interruption caused by damage while channeling Volley.",
					tipValues = {{4, 33}, {8, 66}, {12, 100}},
					column = 3,
					row = 7,
					icon = 132330,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					name = "Master Marksman",
					tips = "Increases your ranged attack power by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 8,
					icon = 132177,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					tips = "A shot that deals 50% weapon damage and Silences the target for 3 sec.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 19,
						}, -- [1]
					},
					name = "Silencing Shot",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132323,
					ranks = 1,
				},
			}, -- [20]
		},
		info = {
			name = "Marksmanship",
			background = "HunterMarksmanship",
		},
	}, -- [2]
	{
		numtalents = 23,
		talents = {
			{
				info = {
					name = "Monster Slaying",
					tips = "Increases all damage caused against Beasts, Giants and Dragonkin targets by %d%% and increases critical damage caused against Beasts, Giants and Dragonkin targets by an additional %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}},
					column = 1,
					row = 1,
					icon = 134154,
					ranks = 3,
				},
			}, -- [1]
			{
				info = {
					name = "Humanoid Slaying",
					tips = "Increases all damage caused against Humanoid targets by %d%% and increases critical damage caused against Humanoid targets by an additional %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}},
					column = 2,
					row = 1,
					icon = 135942,
					ranks = 3,
				},
			}, -- [2]
			{
				info = {
					name = "Hawk Eye",
					tips = "Increases the range of your ranged weapons by %d yards.",
					tipValues = {{2}, {4}, {6}},
					column = 3,
					row = 1,
					icon = 132327,
					ranks = 3,
				},
			}, -- [3]
			{
				info = {
					name = "Savage Strikes",
					tips = "Increases the critical strike chance of Raptor Strike and Mongoose Bite by %d%%.",
					tipValues = {{10}, {20}},
					column = 4,
					row = 1,
					icon = 132277,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Entrapment",
					tips = "Gives your Immolation Trap, Frost Trap, Explosive Trap, and Snake Trap a %d%% chance to entrap the target, preventing them from moving for 4 sec.",
					tipValues = {{8}, {16}, {25}},
					column = 1,
					row = 2,
					icon = 136100,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Deflection",
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 2,
					icon = 132269,
					ranks = 5,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Wing Clip",
					tips = "Gives your Wing Clip ability a %d%% chance to immobilize the target for 5 sec.",
					tipValues = {{7}, {14}, {20}},
					column = 3,
					row = 2,
					icon = 132309,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					name = "Clever Traps",
					tips = "Increases the duration of Freezing and Frost Trap effects by %d%%, the damage of Immolation and Explosive Trap effects by %d%%, and the number of snakes summoned from Snake Traps by %d%%.",
					tipValues = {{15, 15, 15}, {30, 30, 30}},
					column = 1,
					row = 3,
					icon = 136106,
					ranks = 2,
				},
			}, -- [8]
			{
				info = {
					name = "Survivalist",
					tips = "Increases total health by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 3,
					icon = 136223,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					tips = "When activated, increases your Dodge and Parry chance by 25% for 10 sec.",
					name = "Deterrence",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 132369,
					ranks = 1,
				},
			}, -- [10]
			{
				info = {
					name = "Trap Mastery",
					tips = "Decreases the chance enemies will resist trap effects by %d%%.",
					tipValues = {{5}, {10}},
					column = 1,
					row = 4,
					icon = 132149,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Surefooted",
					tips = "Increases hit chance by %d%% and increases the chance movement impairing effects will be resisted by an additional %d%%.",
					tipValues = {{1, 5}, {2, 10}, {3, 15}},
					column = 2,
					row = 4,
					icon = 132219,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Improved Feign Death",
					tips = "Reduces the chance your Feign Death ability will be resisted by %d%%.",
					tipValues = {{2}, {4}},
					column = 4,
					row = 4,
					icon = 132293,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					name = "Survival Instincts",
					tips = "Reduces all damage taken by %d%% and increases attack power by %d%%.",
					tipValues = {{2, 2}, {4, 4}},
					column = 1,
					row = 5,
					icon = 132214,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					name = "Killer Instinct",
					tips = "Increases your critical strike chance with all attacks by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 2,
					row = 5,
					icon = 135881,
					ranks = 3,
				},
			}, -- [15]
			{
				info = {
					tips = "A strike that becomes active after parrying an opponent's attack.  This attack deals 40 damage and immobilizes the target for 5 sec.  Counterattack cannot be blocked, dodged, or parried.",
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 10,
						}, -- [1]
					},
					name = "Counterattack",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 132336,
					ranks = 1,
				},
			}, -- [16]
			{
				info = {
					name = "Resourcefulness",
					tips = "Reduces the mana cost of all traps and melee abilities by %d%% and reduces the cooldown of all traps by %d sec.",
					tipValues = {{20, 2}, {40, 4}, {60, 6}},
					column = 1,
					row = 6,
					icon = 132207,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					name = "Lightning Reflexes",
					tips = "Increases your Agility by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 6,
					icon = 136047,
					ranks = 5,
				},
			}, -- [18]
			{
				info = {
					name = "Thrill of the Hunt",
					tips = "Gives you a %d%% chance to regain 40%% of the mana cost of any shot when it critically hits.",
					tipValues = {{33}, {66}, {100}},
					column = 1,
					row = 7,
					icon = 132216,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					tips = "A stinging shot that puts the target to sleep for 12 sec.  Any damage will cancel the effect.  When the target wakes up, the Sting causes 300 Nature damage over 12 sec.  Only one Sting per Hunter can be active on the target at a time.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 15,
						}, -- [1]
					},
					name = "Wyvern Sting",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135125,
					ranks = 1,
				},
			}, -- [20]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 6,
							source = 18,
						}, -- [1]
					},
					name = "Expose Weakness",
					tips = "Your ranged criticals have a %d%% chance to apply an Expose Weakness effect to the target. Expose Weakness increases the attack power of all attackers against that target by 25%% of your Agility for 7 sec.",
					tipValues = {{33}, {66}, {100}},
					column = 3,
					row = 7,
					icon = 132295,
					ranks = 3,
				},
			}, -- [21]
			{
				info = {
					name = "Master Tactician",
					tips = "Your successful ranged attacks have a 6%% chance to increase your critical strike chance with all attacks by %d%% for 8 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 8,
					icon = 132178,
					ranks = 5,
				},
			}, -- [22]
			{
				info = {
					tips = "When activated, this ability immediately finishes the cooldown on your other Hunter abilities.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 22,
						}, -- [1]
					},
					name = "Readiness",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132206,
					ranks = 1,
				},
			}, -- [23]
		},
		info = {
			name = "Survival",
			background = "HunterSurvival",
		},
	}, -- [3]
}

talents.mage = {
	{
		numtalents = 23,
		talents = {
			{
				info = {
					name = "Arcane Subtlety",
					tips = "Reduces your target's resistance to all your spells by %d and reduces the threat caused by your Arcane spells by %d%%.",
					tipValues = {{5, 20}, {10, 40}},
					column = 1,
					row = 1,
					icon = 135894,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					name = "Arcane Focus",
					tips = "Reduces the chance that the opponent can resist your Arcane spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 1,
					icon = 135892,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Improved Arcane Missiles",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while channeling Arcane Missiles.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 3,
					row = 1,
					icon = 136096,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Wand Specialization",
					tips = "Increases your damage with Wands by %d%%.",
					tipValues = {{13}, {25}},
					column = 1,
					row = 2,
					icon = 135463,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Magic Absorption",
					tips = "Increases all resistances by %d and causes all spells you fully resist to restore %d%% of your total mana.  1 sec. cooldown.",
					tipValues = {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}},
					column = 2,
					row = 2,
					icon = 136011,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					name = "Arcane Concentration",
					tips = "Gives you a %d%% chance of entering a Clearcasting state after any damage spell hits a target.  The Clearcasting state reduces the mana cost of your next damage spell by 100%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 2,
					icon = 136170,
					ranks = 5,
				},
			}, -- [6]
			{
				info = {
					name = "Magic Attunement",
					tips = "Increases the effect of your Amplify Magic and Dampen Magic spells by %d%%.",
					tipValues = {{25}, {50}},
					column = 1,
					row = 3,
					icon = 136006,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					name = "Arcane Impact",
					tips = "Increases the critical strike chance of your Arcane Explosion and Arcane Blast spells by an additional %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 2,
					row = 3,
					icon = 136116,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					tips = "Increases your armor by an amount equal to 100% of your Intellect.",
					name = "Arcane Fortitude",
					row = 3,
					column = 4,
					exceptional = 1,
					icon = 135733,
					ranks = 1,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Mana Shield",
					tips = "Decreases the mana lost per point of damage taken when Mana Shield is active by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 4,
					icon = 136153,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Improved Counterspell",
					tips = "Gives your Counterspell a %d%% chance to silence the target for 4 sec.",
					tipValues = {{50}, {100}},
					column = 2,
					row = 4,
					icon = 135856,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Arcane Meditation",
					tips = "Allows %d%% of your mana regeneration to continue while casting.",
					tipValues = {{10}, {20}, {30}},
					column = 4,
					row = 4,
					icon = 136208,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Improved Blink",
					tips = "For 4 sec after casting Blink, your chance to be hit by all attacks and spells is reduced by %d%%.",
					tipValues = {{13}, {25}},
					column = 1,
					row = 5,
					icon = 135736,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					tips = "When activated, your next Mage spell with a casting time less than 10 sec becomes an instant cast spell.",
					name = "Presence of Mind",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136031,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					name = "Arcane Mind",
					tips = "Increases your total Intellect by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 4,
					row = 5,
					icon = 136129,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Prismatic Cloak",
					tips = "Reduces all damage taken by %d%%.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 6,
					icon = 135752,
					ranks = 2,
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
					name = "Arcane Instability",
					tips = "Increases your spell damage and critical strike chance by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 2,
					row = 6,
					icon = 136222,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 2,
							source = 6,
						}, -- [1]
					},
					name = "Arcane Potency",
					tips = "Increases the critical strike chance of any spell cast while Clearcasting by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 3,
					row = 6,
					icon = 135732,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					name = "Empowered Arcane Missiles",
					tips = "Your Arcane Missiles spell gains an additional %d%% of your bonus spell damage effects, but mana cost is increased by %d%%.",
					tipValues = {{15, 2}, {30, 4}, {45, 6}},
					column = 1,
					row = 7,
					icon = 136096,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					tips = "When activated, your spells deal 30% more damage while costing 30% more mana to cast.  This effect lasts 15 sec.",
					prereqs = {
						{
							column = 2,
							row = 6,
							source = 17,
						}, -- [1]
					},
					name = "Arcane Power",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136048,
					ranks = 1,
				},
			}, -- [20]
			{
				info = {
					name = "Spell Power",
					tips = "Increases critical strike damage bonus of all spells by %d%%.",
					tipValues = {{25}, {50}},
					column = 3,
					row = 7,
					icon = 135734,
					ranks = 2,
				},
			}, -- [21]
			{
				info = {
					name = "Mind Mastery",
					tips = "Increases spell damage by up to %d%% of your total Intellect.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					column = 2,
					row = 8,
					icon = 135740,
					ranks = 5,
				},
			}, -- [22]
			{
				info = {
					tips = "Reduces target's movement speed by 50%, increases the time between ranged attacks by 50% and increases casting time by 50%.  Lasts 15 sec.  Slow can only affect one target at a time.",
					name = "Slow",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 136091,
					ranks = 1,
				},
			}, -- [23]
		},
		info = {
			name = "Arcane",
			background = "MageArcane",
		},
	}, -- [1]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Fireball",
					tips = "Reduces the casting time of your Fireball spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					column = 2,
					row = 1,
					icon = 135812,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Impact",
					tips = "Gives your Fire spells a %d%% chance to stun the target for 2 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 1,
					icon = 135821,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Ignite",
					tips = "Your critical strikes from Fire damage spells cause the target to burn for an additional %d%% of your spell's damage over 4 sec.",
					tipValues = {{8}, {16}, {24}, {32}, {40}},
					column = 1,
					row = 2,
					icon = 135818,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Flame Throwing",
					tips = "Increases the range of your Fire spells by %d yards.",
					tipValues = {{3}, {6}},
					column = 2,
					row = 2,
					icon = 135815,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Improved Fire Blast",
					tips = "Reduces the cooldown of your Fire Blast spell by %.1f sec.",
					tipValues = {{0.5}, {1.0}, {1.5}},
					column = 3,
					row = 2,
					icon = 135807,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Incineration",
					tips = "Increases the critical strike chance of your Fire Blast and Scorch spells by %d%%.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 3,
					icon = 135813,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Flamestrike",
					tips = "Increases the critical strike chance of your Flamestrike spell by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 2,
					row = 3,
					icon = 135826,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					tips = "Hurls an immense fiery boulder that causes 148 to 195 Fire damage and an additional 56 Fire damage over 12 sec.",
					name = "Pyroblast",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 135808,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Burning Soul",
					tips = "Gives your Fire spells a %d%% chance to not lose casting time when you take damage and reduces the threat caused by your Fire spells by %d%%.",
					tipValues = {{35, 5}, {70, 10}},
					column = 4,
					row = 3,
					icon = 135805,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Scorch",
					tips = "Your Scorch spells have a %d%% chance to cause your target to be vulnerable to Fire damage.  This vulnerability increases the Fire damage dealt to your target by 3%% and lasts 30 sec.  Stacks up to 5 times.",
					tipValues = {{33}, {66}, {100}},
					column = 1,
					row = 4,
					icon = 135827,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					name = "Molten Shields",
					tips = "Causes your Fire Ward to have a %d%% chance to reflect Fire spells while active. In addition, your Molten Armor has a %d%% chance to affect ranged and spell attacks.",
					tipValues = {{10, 50}, {20, 100}},
					column = 2,
					row = 4,
					icon = 135806,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Master of Elements",
					tips = "Your Fire and Frost spell criticals will refund %d%% of their base mana cost.",
					tipValues = {{10}, {20}, {30}},
					column = 4,
					row = 4,
					icon = 135820,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Playing with Fire",
					tips = "Increases all spell damage caused by %d%% and all spell damage taken by %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}},
					column = 1,
					row = 5,
					icon = 135823,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					name = "Critical Mass",
					tips = "Increases the critical strike chance of your Fire spells by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 2,
					row = 5,
					icon = 136115,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					tips = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 160 to 192 Fire damage, and Dazing them for 6 sec.",
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
				},
			}, -- [15]
			{
				info = {
					name = "Blazing Speed",
					tips = "Gives you a %d%% chance when hit by a melee or ranged attack to increase your movement speed by 50%% and dispel all movement impairing effects.  This effect lasts 8 sec.",
					tipValues = {{5}, {10}},
					column = 1,
					row = 6,
					icon = 135788,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					name = "Fire Power",
					tips = "Increases the damage done by your Fire spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 6,
					icon = 135817,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					name = "Pyromaniac",
					tips = "Increases chance to critically hit and reduces the mana cost of all Fire spells by an additional %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 1,
					row = 7,
					icon = 135789,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "When activated, this spell causes each of your Fire damage spell hits to increase your critical strike chance with Fire damage spells by 10%.  This effect lasts until you have caused 3 critical strikes with Fire spells.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Combustion",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135824,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Molten Fury",
					tips = "Increases damage of all spells against targets with less than 20%% health by %d%%.",
					tipValues = {{10}, {20}},
					column = 3,
					row = 7,
					icon = 135822,
					ranks = 2,
				},
			}, -- [20]
			{
				info = {
					name = "Empowered Fireball",
					tips = "Your Fireball spell gains an additional %d%% of your bonus spell damage effects.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 8,
					icon = 135812,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Targets in a cone in front of the caster take 382 to 442 Fire damage and are Disoriented for 3 sec.  Any direct damaging attack will revive targets.  Turns off your attack when used.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 19,
						}, -- [1]
					},
					name = "Dragon's Breath",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 134153,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Fire",
			background = "MageFire",
		},
	}, -- [2]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Frost Warding",
					tips = "Increases the armor and resistances given by your Frost Armor and Ice Armor spells by %d%%.  In addition, gives your Frost Ward a %d%% chance to reflect Frost spells and effects while active.",
					tipValues = {{15, 10}, {30, 20}},
					column = 1,
					row = 1,
					icon = 135850,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					name = "Improved Frostbolt",
					tips = "Reduces the casting time of your Frostbolt spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					column = 2,
					row = 1,
					icon = 135846,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Elemental Precision",
					tips = "Reduces the mana cost and chance targets resist your Frost and Fire spells by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 3,
					row = 1,
					icon = 135989,
					ranks = 3,
				},
			}, -- [3]
			{
				info = {
					name = "Ice Shards",
					tips = "Increases the critical strike damage bonus of your Frost spells by %d%%.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 1,
					row = 2,
					icon = 135855,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Frostbite",
					tips = "Gives your Chill effects a %d%% chance to freeze the target for 5 sec.",
					tipValues = {{5}, {10}, {15}},
					column = 2,
					row = 2,
					icon = 135842,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Frost Nova",
					tips = "Reduces the cooldown of your Frost Nova spell by %d sec.",
					tipValues = {{2}, {4}},
					column = 3,
					row = 2,
					icon = 135840,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Permafrost",
					tips = "Increases the duration of your Chill effects by %d sec and reduces the target's speed by an additional %d%%.",
					tipValues = {{1, 4}, {2, 7}, {3, 10}},
					column = 4,
					row = 2,
					icon = 135864,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					name = "Piercing Ice",
					tips = "Increases the damage done by your Frost spells by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 1,
					row = 3,
					icon = 135845,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					tips = "Hastens your spellcasting, increasing spell casting speed by 20% and gives you 100% chance to avoid interruption caused by damage while casting.  Lasts 20 sec.",
					name = "Icy Veins",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 135838,
					ranks = 1,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Blizzard",
					tips = "Adds a chill effect to your Blizzard spell.  This effect lowers the target's movement speed by %d%%.  Lasts 1.50 sec.",
					tipValues = {{30}, {50}, {65}},
					column = 4,
					row = 3,
					icon = 135857,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					name = "Arctic Reach",
					tips = "Increases the range of your Frostbolt, Ice Lance and Blizzard spells and the radius of your Frost Nova and Cone of Cold spells by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 4,
					icon = 136141,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Frost Channeling",
					tips = "Reduces the mana cost of your Frost spells by %d%% and reduces the threat caused by your Frost spells by %d%%.",
					tipValues = {{5, 4}, {10, 7}, {15, 10}},
					column = 2,
					row = 4,
					icon = 135860,
					ranks = 3,
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
					tipValues = {{10}, {20}, {30}, {40}, {50}},
					column = 3,
					row = 4,
					icon = 135849,
					ranks = 5,
				},
			}, -- [13]
			{
				info = {
					name = "Frozen Core",
					tips = "Reduces the damage taken by Frost and Fire effects by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 1,
					row = 5,
					icon = 135851,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					tips = "When activated, this spell finishes the cooldown on all Frost spells you recently cast.",
					name = "Cold Snap",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 135865,
					ranks = 1,
				},
			}, -- [15]
			{
				info = {
					name = "Improved Cone of Cold",
					tips = "Increases the damage dealt by your Cone of Cold spell by %d%%.",
					tipValues = {{15}, {25}, {35}},
					column = 3,
					row = 5,
					icon = 135852,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					name = "Ice Floes",
					tips = "Reduces the cooldown of your Cone of Cold, Cold Snap, Ice Barrier and Ice Block spells by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 6,
					icon = 135854,
					ranks = 2,
				},
			}, -- [17]
			{
				info = {
					name = "Winter's Chill",
					tips = "Gives your Frost damage spells a %d%% chance to apply the Winter's Chill effect, which increases the chance a Frost spell will critically hit the target by 2%% for 15 sec.  Stacks up to 5 times.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 3,
					row = 6,
					icon = 135836,
					ranks = 5,
				},
			}, -- [18]
			{
				info = {
					tips = "Instantly shields you, absorbing 454 damage.  Lasts 1 min.  While the shield holds, spells will not be interrupted.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 15,
						}, -- [1]
					},
					name = "Ice Barrier",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135988,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Arctic Winds",
					tips = "Increases all Frost damage you cause by %d%% and reduces the chance melee and ranged attacks will hit you by %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}},
					column = 3,
					row = 7,
					icon = 135833,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					name = "Empowered Frostbolt",
					tips = "Your Frostbolt spell gains an additional %d%% of your bonus spell damage effects and an additional %d%% chance to critically strike.",
					tipValues = {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}},
					column = 2,
					row = 8,
					icon = 135846,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Summon a Water Elemental to fight for the caster for 45 sec.",
					name = "Summon Water Elemental",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135862,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Frost",
			background = "MageFrost",
		},
	}, -- [3]
}

talents.paladin = {
	{
		numtalents = 20,
		talents = {
			{
				info = {
					name = "Divine Strength",
					tips = "Increases your total Strength by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 1,
					icon = 132154,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Divine Intellect",
					tips = "Increases your total Intellect by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 1,
					icon = 136090,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Spiritual Focus",
					tips = "Gives your Flash of Light and Holy Light spells a %d%% chance to not lose casting time when you take damage.",
					tipValues = {{14}, {28}, {42}, {56}, {70}},
					column = 2,
					row = 2,
					icon = 135736,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Seal of Righteousness",
					tips = "Increases the damage done by your Seal of Righteousness and Judgement of Righteousness by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 2,
					icon = 132325,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Healing Light",
					tips = "Increases the amount healed by your Holy Light and Flash of Light spells by %d%%.",
					tipValues = {{4}, {8}, {12}},
					column = 1,
					row = 3,
					icon = 135920,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					tips = "Increases the radius of your Auras to 40 yards.",
					name = "Aura Mastery",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 135872,
					ranks = 1,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Lay on Hands",
					tips = "Gives the target of your Lay on Hands spell a %d%% bonus to their armor value from items for 2 min.  In addition, the cooldown for your Lay on Hands spell is reduced by %d min.",
					tipValues = {{15, 10}, {30, 20}},
					column = 3,
					row = 3,
					icon = 135928,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					name = "Unyielding Faith",
					tips = "Increases your chance to resist Fear and Disorient effects by an additional %d%%.",
					tipValues = {{5}, {10}},
					column = 4,
					row = 3,
					icon = 135984,
					ranks = 2,
				},
			}, -- [8]
			{
				info = {
					name = "Illumination",
					tips = "After getting a critical effect from your Flash of Light, Holy Light, or Holy Shock heal spell, gives you a %d%% chance to gain mana equal to 60%% of the base cost of the spell.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 2,
					row = 4,
					icon = 135913,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Blessing of Wisdom",
					tips = "Increases the effect of your Blessing of Wisdom spell by %d%%.",
					tipValues = {{10}, {20}},
					column = 3,
					row = 4,
					icon = 135970,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Pure of Heart",
					tips = "Increases your resistance to Curse and Disease effects by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 5,
					icon = 135948,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					tips = "When activated, gives your next Flash of Light, Holy Light, or Holy Shock spell a 100% critical effect chance.",
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 9,
						}, -- [1]
					},
					name = "Divine Favor",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 135915,
					ranks = 1,
				},
			}, -- [12]
			{
				info = {
					name = "Sanctified Light",
					tips = "Increases the critical effect chance of your Holy Light spell by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 3,
					row = 5,
					icon = 135917,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					name = "Purifying Power",
					tips = "Reduces the mana cost of your Cleanse, Purify and Consecration spells by %d%% and increases the critical strike chance of your Exorcism and Holy Wrath spells by %d%%.",
					tipValues = {{5, 10}, {10, 20}},
					column = 1,
					row = 6,
					icon = 135950,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					name = "Holy Power",
					tips = "Increases the critical effect chance of your Holy spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 6,
					icon = 135938,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Light's Grace",
					tips = "Gives your Holy Light spell a %d%% chance to reduce the cast time of your next Holy Light spell by 0.5 sec.  This effect lasts 15 sec.",
					tipValues = {{33}, {66}, {100}},
					column = 1,
					row = 7,
					icon = 135931,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					tips = "Blasts the target with Holy energy, causing 277 to 299 Holy damage to an enemy, or 351 to 379 healing to an ally.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 12,
						}, -- [1]
					},
					name = "Holy Shock",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135972,
					ranks = 1,
				},
			}, -- [17]
			{
				info = {
					name = "Blessed Life",
					tips = "All attacks against you have a %d%% chance to cause half damage.",
					tipValues = {{4}, {7}, {10}},
					column = 3,
					row = 7,
					icon = 135876,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					name = "Holy Guidance",
					tips = "Increases your spell damage and healing by %d%% of your total Intellect.",
					tipValues = {{7}, {14}, {21}, {28}, {35}},
					column = 2,
					row = 8,
					icon = 135921,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					tips = "Reduces the mana cost of all spells by 50% for 15 sec.",
					name = "Divine Illumination",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135895,
					ranks = 1,
				},
			}, -- [20]
		},
		info = {
			name = "Holy",
			background = "PaladinHoly",
		},
	}, -- [1]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Devotion Aura",
					tips = "Increases the armor bonus of your Devotion Aura by %d%%.",
					tipValues = {{8}, {16}, {24}, {32}, {40}},
					column = 2,
					row = 1,
					icon = 135893,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Redoubt",
					tips = "Damaging melee and ranged attacks against you have a 10%% chance to increase your chance to block by %d%%.  Lasts 10 sec or 5 blocks.",
					tipValues = {{6}, {12}, {18}, {24}, {30}},
					column = 3,
					row = 1,
					icon = 132110,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Precision",
					tips = "Increases your chance to hit with melee weapons and spells by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 1,
					row = 2,
					icon = 132282,
					ranks = 3,
				},
			}, -- [3]
			{
				info = {
					name = "Guardian's Favor",
					tips = "Reduces the cooldown of your Blessing of Protection by %d sec and increases the duration of your Blessing of Freedom by %d sec.",
					tipValues = {{60, 2}, {120, 4}},
					column = 2,
					row = 2,
					icon = 135964,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Toughness",
					tips = "Increases your armor value from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 4,
					row = 2,
					icon = 135892,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					tips = "Places a Blessing on the friendly target, increasing total stats by 10% for 10 min.  Players may only have one Blessing on them per Paladin at any one time.",
					name = "Blessing of Kings",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 135995,
					ranks = 1,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Righteous Fury",
					tips = "While Righteous Fury is active, all damage taken is reduced by %d%% and increases the amount of threat generated by your Righteous Fury spell by %d%%.",
					tipValues = {{2, 16}, {4, 33}, {6, 50}},
					column = 2,
					row = 3,
					icon = 135962,
					ranks = 3,
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
					tips = "Increases the amount of damage absorbed by your shield by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 3,
					row = 3,
					icon = 134952,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					name = "Anticipation",
					tips = "Increases your Defense skill by %d.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 4,
					row = 3,
					icon = 135994,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					name = "Stoicism",
					tips = "Increases your resistance to Stun effects by an additional %d%% and reduces the chance your spells will be dispelled by an additional %d%%.",
					tipValues = {{5, 15}, {10, 30}},
					column = 1,
					row = 4,
					icon = 135978,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Improved Hammer of Justice",
					tips = "Decreases the cooldown of your Hammer of Justice spell by %d sec.",
					tipValues = {{5}, {10}, {15}},
					column = 2,
					row = 4,
					icon = 135963,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					name = "Improved Concentration Aura",
					tips = "Increases the effect of your Concentration Aura by an additional %d%% and reduces the duration of any Silence or Interrupt effect used against an affected group member by %d%%.  The duration reduction does not stack with any other effects.",
					tipValues = {{5, 10}, {10, 20}, {15, 30}},
					column = 3,
					row = 4,
					icon = 135933,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Spell Warding",
					tips = "All spell damage taken is reduced by %d%%.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 5,
					icon = 135925,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					tips = "Places a Blessing on the friendly target, reducing damage dealt from all sources by up to 10 for 10 min.  In addition, when the target blocks a melee attack the attacker will take 14 Holy damage.  Players may only have one Blessing on them per Paladin at any one time.",
					name = "Blessing of Sanctuary",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136051,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					name = "Reckoning",
					tips = "Gives you a %d%% chance after being hit by any damaging attack that the next 4 weapon swings within 8 sec will generate an additional attack.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 5,
					icon = 135882,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Sacred Duty",
					tips = "Increases your total Stamina by %d%%, reduces the cooldown of your Divine Shield spell by %d sec and reduces the attack speed penalty by %d%%.",
					tipValues = {{3, 30, 50}, {6, 60, 100}},
					column = 1,
					row = 6,
					icon = 135896,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					name = "One-Handed Weapon Specialization",
					tips = "Increases all damage you deal when a one-handed melee weapon is equipped by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 6,
					icon = 135321,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 19,
						}, -- [1]
					},
					name = "Improved Holy Shield",
					tips = "Increases damage caused by your Holy Shield by %d%% and increases the number of charges of your Holy Shield by %d.",
					tipValues = {{10, 2}, {20, 4}},
					column = 1,
					row = 7,
					icon = 135880,
					ranks = 2,
				},
			}, -- [18]
			{
				info = {
					tips = "Increases chance to block by 30% for 10 sec and deals 59 Holy damage for each attack blocked while active.  Damage caused by Holy Shield causes 35% additional threat.  Each block expends a charge.  4 charges.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Holy Shield",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135880,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Ardent Defender",
					tips = "When you have less than 35%% health, all damage taken is reduced by %d%%.",
					tipValues = {{6}, {12}, {18}, {24}, {30}},
					column = 3,
					row = 7,
					icon = 135870,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					name = "Combat Expertise",
					tips = "Increases your expertise by %d and your total Stamina by %d%%.",
					tipValues = {{1, 2}, {2, 4}, {3, 6}, {4, 8}, {5, 10}},
					column = 3,
					row = 8,
					icon = 135986,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Hurls a holy shield at the enemy, dealing 270 to 330 Holy damage, Dazing them and then jumping to additional nearby enemies.  Affects 3 total targets.  Lasts 6 sec.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 19,
						}, -- [1]
					},
					name = "Avenger's Shield",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135874,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Protection",
			background = "PaladinProtection",
		},
	}, -- [2]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Blessing of Might",
					tips = "Increases the attack power bonus of your Blessing of Might by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 2,
					row = 1,
					icon = 135906,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Benediction",
					tips = "Reduces the mana cost of your Judgement and Seal spells by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 1,
					icon = 135863,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Improved Judgement",
					tips = "Decreases the cooldown of your Judgement spell by %d sec.",
					tipValues = {{1}, {2}},
					column = 1,
					row = 2,
					icon = 135959,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Seal of the Crusader",
					tips = "In addition to the normal effect, your Judgement of the Crusader spell will also increase the critical strike chance of all attacks made against that target by an additional %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 2,
					row = 2,
					icon = 135924,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					name = "Deflection",
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 2,
					icon = 132269,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					name = "Vindication",
					tips = "Gives the Paladin's damaging melee attacks a chance to reduce the target's attributes by %d%% for 15 sec.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 3,
					icon = 135985,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					name = "Conviction",
					tips = "Increases your chance to get a critical strike with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 3,
					icon = 135957,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "Gives the Paladin a chance to deal additional Holy damage equal to 70% of normal weapon damage.  Only one Seal can be active on the Paladin at any one time.  Lasts 30 sec.\r\n\r\nUnleashing this Seal's energy will judge an enemy, instantly causing 68 to 73 Holy damage, 137 to 146 if the target is stunned or incapacitated.",
					name = "Seal of Command",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 132347,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Pursuit of Justice",
					tips = "Reduces the chance you'll be hit by spells by %d%% and increases movement and mounted movement speed by %d%%.  This does not stack with other movement speed increasing effects.",
					tipValues = {{1, 5}, {2, 10}, {3, 15}},
					column = 4,
					row = 3,
					icon = 135937,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					name = "Eye for an Eye",
					tips = "All spell criticals against you cause %d%% of the damage taken to the caster as well.  The damage caused by Eye for an Eye will not exceed 50%% of the Paladin's total health.",
					tipValues = {{15}, {30}},
					column = 1,
					row = 4,
					icon = 135904,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Improved Retribution Aura",
					tips = "Increases the damage done by your Retribution Aura by %d%%.",
					tipValues = {{25}, {50}},
					column = 3,
					row = 4,
					icon = 135873,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Crusade",
					tips = "Increases all damage caused against Humanoids, Demons, Undead and Elementals by %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 4,
					row = 4,
					icon = 135889,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Two-Handed Weapon Specialization",
					tips = "Increases the damage you deal with two-handed melee weapons by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 1,
					row = 5,
					icon = 133041,
					ranks = 3,
				},
			}, -- [13]
			{
				info = {
					tips = "Increases Holy damage done by party members within 30 yards by 10%.  Players may only have one Aura on them per Paladin at any one time.",
					name = "Sanctity Aura",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 135934,
					ranks = 1,
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
					name = "Improved Sanctity Aura",
					tips = "The amount of damage caused by targets affected by Sanctity Aura is increased by %d%%.",
					tipValues = {{1}, {2}},
					column = 4,
					row = 5,
					icon = 135934,
					ranks = 2,
				},
			}, -- [15]
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
					tips = "Gives you a %d%% bonus to Physical and Holy damage you deal for 30 sec after dealing a critical strike from a weapon swing, spell, or ability.  This effect stacks up to 3 times.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 6,
					icon = 132275,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Sanctified Judgement",
					tips = "Gives your Judgement spell a %d%% chance to return 80%% of the mana cost of the judged seal.",
					tipValues = {{33}, {66}, {100}},
					column = 3,
					row = 6,
					icon = 135959,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					name = "Sanctified Seals",
					tips = "Increases your chance to critically hit with all spells and melee attacks by %d%% and reduces the chance your Seals will be dispelled by %d%%.",
					tipValues = {{1, 33}, {2, 66}, {3, 100}},
					column = 1,
					row = 7,
					icon = 135924,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "Puts the enemy target in a state of meditation, incapacitating them for up to 6 sec.  Any damage caused will awaken the target.  Only works against Humanoids.",
					name = "Repentance",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135942,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Divine Purpose",
					tips = "Melee and ranged critical strikes against you cause %d%% less damage.",
					tipValues = {{4}, {7}, {10}},
					column = 3,
					row = 7,
					icon = 135897,
					ranks = 3,
				},
			}, -- [20]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 19,
						}, -- [1]
					},
					name = "Fanaticism",
					tips = "Increases the critical strike chance of all Judgements capable of a critical hit by %d%% and reduces threat caused by all actions by %d%% except when under the effects of Righteous Fury.",
					tipValues = {{3, 6}, {6, 12}, {9, 18}, {12, 24}, {15, 30}},
					column = 2,
					row = 8,
					icon = 135905,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "An instant strike that causes 110% weapon damage and refreshes all Judgements on the target.",
					name = "Crusader Strike",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135891,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Retribution",
			background = "PaladinCombat",
		},
	}, -- [3]
}

talents.priest = {
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Unbreakable Will",
					tips = "Increases your chance to resist Stun, Fear, and Silence effects by an additional %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 2,
					row = 1,
					icon = 135995,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Wand Specialization",
					tips = "Increases your damage with Wands by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					column = 3,
					row = 1,
					icon = 135463,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Silent Resolve",
					tips = "Reduces the threat generated by your Holy and Discipline spells by %d%% and reduces the chance your spells will be dispelled by %d%%.",
					tipValues = {{4, 4}, {8, 8}, {12, 12}, {16, 16}, {20, 20}},
					column = 1,
					row = 2,
					icon = 136053,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Power Word: Fortitude",
					tips = "Increases the effect of your Power Word: Fortitude and Prayer of Fortitude spells by %d%%.",
					tipValues = {{15}, {30}},
					column = 2,
					row = 2,
					icon = 135987,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Improved Power Word: Shield",
					tips = "Increases the damage absorbed by your Power Word: Shield by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 3,
					row = 2,
					icon = 135940,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Martyrdom",
					tips = "Gives you a %d%% chance to gain the Focused Casting effect that lasts for 6 sec after being the victim of a melee or ranged critical strike.  The Focused Casting effect prevents you from losing casting time when taking damage while casting Priest spells and increases resistance to Interrupt effects by %d%%.",
					tipValues = {{50, 10}, {100, 20}},
					column = 4,
					row = 2,
					icon = 136107,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Absolution",
					tips = "Reduces the mana cost of your Dispel Magic, Cure Disease, Abolish Disease and Mass Dispel spells by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 3,
					icon = 135868,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					tips = "When activated, reduces the mana cost of your next spell by 100% and increases its critical effect chance by 25% if it is capable of a critical effect.",
					name = "Inner Focus",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 135863,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Meditation",
					tips = "Allows %d%% of your mana regeneration to continue while casting.",
					tipValues = {{10}, {20}, {30}},
					column = 3,
					row = 3,
					icon = 136090,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Inner Fire",
					tips = "Increases the armor bonus of your Inner Fire spell by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 1,
					row = 4,
					icon = 135926,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					name = "Mental Agility",
					tips = "Reduces the mana cost of your instant cast spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 4,
					icon = 132156,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					name = "Improved Mana Burn",
					tips = "Reduces the casting time of your Mana Burn spell by %.1f sec.",
					tipValues = {{0.5}, {1.0}},
					column = 4,
					row = 4,
					icon = 136170,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					name = "Mental Strength",
					tips = "Increases your maximum mana by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 5,
					icon = 136031,
					ranks = 5,
				},
			}, -- [13]
			{
				info = {
					tips = "Holy power infuses the target, increasing their Spirit by 17 for 30 min.",
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Divine Spirit",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 135898,
					ranks = 1,
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
					name = "Improved Divine Spirit",
					tips = "Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to %d%% of their total Spirit.",
					tipValues = {{5}, {10}},
					column = 4,
					row = 5,
					icon = 135898,
					ranks = 2,
				},
			}, -- [15]
			{
				info = {
					name = "Focused Power",
					tips = "Your Smite, Mind Blast and Mass Dispel spells have an additional %d%% chance to hit.  In addition, your Mass Dispel cast time is reduced by %.1f sec.",
					tipValues = {{2, 0.5}, {4, 1.0}},
					column = 1,
					row = 6,
					icon = 136158,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					name = "Force of Will",
					tips = "Increases your spell damage by %d%% and the critical strike chance of your offensive spells by %d%%.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}},
					column = 3,
					row = 6,
					icon = 136092,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					name = "Focused Will",
					tips = "After taking a critical hit you gain the Focused Will effect, reducing all damage taken by %d%% and increasing healing effects on you by %d%%.  Stacks up to 3 times.  Lasts 8 sec.",
					tipValues = {{2, 4}, {3, 7}, {4, 10}},
					column = 1,
					row = 7,
					icon = 135737,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "Infuses the target with power, increasing spell casting speed by 20% and reducing the mana cost of all spells by 20%.  Lasts 15 sec.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Power Infusion",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135939,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Reflective Shield",
					tips = "Causes %d%% of the damage absorbed by your Power Word: Shield to reflect back at the attacker.  This damage causes no threat.",
					tipValues = {{10}, {20}, {30}, {40}, {50}},
					column = 3,
					row = 7,
					icon = 135940,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					name = "Enlightenment",
					tips = "Increases your total Stamina, Intellect and Spirit by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 8,
					icon = 135740,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.",
					name = "Pain Suppression",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135936,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Discipline",
			background = "PriestDiscipline",
		},
	}, -- [1]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Healing Focus",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting any healing spell.",
					tipValues = {{35}, {70}},
					column = 1,
					row = 1,
					icon = 135918,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					name = "Improved Renew",
					tips = "Increases the amount healed by your Renew spell by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 2,
					row = 1,
					icon = 135953,
					ranks = 3,
				},
			}, -- [2]
			{
				info = {
					name = "Holy Specialization",
					tips = "Increases the critical effect chance of your Holy spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 1,
					icon = 135967,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Spell Warding",
					tips = "Reduces all spell damage taken by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 2,
					icon = 135976,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Divine Fury",
					tips = "Reduces the casting time of your Smite, Holy Fire, Heal and Greater Heal spells by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					column = 3,
					row = 2,
					icon = 135971,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					tips = "Causes an explosion of holy light around the caster, causing 29 to 34 Holy damage to all enemy targets within 10 yards and healing all party members within 10 yards for 54 to 63.  These effects cause no threat.",
					name = "Holy Nova",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 135922,
					ranks = 1,
				},
			}, -- [6]
			{
				info = {
					name = "Blessed Recovery",
					tips = "After being struck by a melee or ranged critical hit, heal %d%% of the damage taken over 6 sec.",
					tipValues = {{8}, {16}, {25}},
					column = 2,
					row = 3,
					icon = 135877,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					name = "Inspiration",
					tips = "Increases your target's armor by %d%% for 15 sec after getting a critical effect from your Flash Heal, Heal, Greater Heal, Binding Heal, Prayer of Healing, or Circle of Healing spell.",
					tipValues = {{8}, {16}, {25}},
					column = 4,
					row = 3,
					icon = 135928,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					name = "Holy Reach",
					tips = "Increases the range of your Smite and Holy Fire spells and the radius of your Prayer of Healing, Holy Nova and Circle of Healing spells by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 4,
					icon = 135949,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Healing",
					tips = "Reduces the mana cost of your Lesser Heal, Heal, and Greater Heal spells by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 2,
					row = 4,
					icon = 135916,
					ranks = 3,
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
					tips = "Increases the damage of your Smite and Holy Fire spells by %d%%.",
					tipValues = {{5}, {10}},
					column = 3,
					row = 4,
					icon = 135973,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Healing Prayers",
					tips = "Reduces the mana cost of your Prayer of Healing and Prayer of Mending spell by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 5,
					icon = 135943,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.  The Spirit of Redemption cannot move, attack, be attacked or targeted by any spells or effects.  While in this form the priest can cast any healing spell free of cost.  When the effect ends, the priest dies.",
					name = "Spirit of Redemption",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132864,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					name = "Spiritual Guidance",
					tips = "Increases spell damage and healing by up to %d%% of your total Spirit.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					column = 3,
					row = 5,
					icon = 135977,
					ranks = 5,
				},
			}, -- [14]
			{
				info = {
					name = "Surge of Light",
					tips = "Your spell criticals have a %d%% chance to cause your next Smite spell to be instant cast, cost no mana but be incapable of a critical hit.  This effect lasts 10 sec.",
					tipValues = {{25}, {50}},
					column = 1,
					row = 6,
					icon = 135981,
					ranks = 2,
				},
			}, -- [15]
			{
				info = {
					name = "Spiritual Healing",
					tips = "Increases the amount healed by your healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 6,
					icon = 136057,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Holy Concentration",
					tips = "Gives you a %d%% chance to enter a Clearcasting state after casting any Flash Heal, Binding Heal, or Greater Heal spell.  The Clearcasting state reduces the mana cost of your next Flash Heal, Binding Heal, or Greater Heal spell by 100%%.",
					tipValues = {{2}, {4}, {6}},
					column = 1,
					row = 7,
					icon = 135905,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "Creates a Holy Lightwell.  Members of your raid or party can click the Lightwell to restore 801 health over 6 sec.  Any damage taken will cancel the effect.  Lightwell lasts for 3 min or 5 charges.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Lightwell",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135980,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Blessed Resilience",
					tips = "Critical hits made against you have a %d%% chance to prevent you from being critically hit again for 6 sec.",
					tipValues = {{20}, {40}, {60}},
					column = 3,
					row = 7,
					icon = 135878,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					name = "Empowered Healing",
					tips = "Your Greater Heal spell gains an additional %d%% and your Flash Heal and Binding Heal gain an additional %d%% of your bonus healing effects.",
					tipValues = {{4, 2}, {8, 4}, {12, 6}, {16, 8}, {20, 10}},
					column = 2,
					row = 8,
					icon = 135913,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Heals friendly target and that target's party members within 15 yards of the target for 250 to 274.",
					name = "Circle of Healing",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135887,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Holy",
			background = "PriestHoly",
		},
	}, -- [2]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Spirit Tap",
					tips = "Gives you a %d%% chance to gain a 100%% bonus to your Spirit after killing a target that yields experience or honor.  For the duration, your mana will regenerate at a 50%% rate while casting.  Lasts 15 sec.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 2,
					row = 1,
					icon = 136188,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Blackout",
					tips = "Gives your Shadow damage spells a %d%% chance to stun the target for 3 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 1,
					icon = 136160,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Shadow Affinity",
					tips = "Reduces the threat generated by your Shadow spells by %d%%.",
					tipValues = {{8}, {16}, {25}},
					column = 1,
					row = 2,
					icon = 136205,
					ranks = 3,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Shadow Word: Pain",
					tips = "Increases the duration of your Shadow Word: Pain spell by %d sec.",
					tipValues = {{3}, {6}},
					column = 2,
					row = 2,
					icon = 136207,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Shadow Focus",
					tips = "Reduces your target's chance to resist your Shadow spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 2,
					icon = 136126,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Psychic Scream",
					tips = "Reduces the cooldown of your Psychic Scream spell by %d sec.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 3,
					icon = 136184,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Mind Blast",
					tips = "Reduces the cooldown of your Mind Blast spell by %.1f sec.",
					tipValues = {{0.5}, {1.0}, {1.5}, {2.0}, {2.5}},
					column = 2,
					row = 3,
					icon = 136224,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "Assault the target's mind with Shadow energy, causing 75 Shadow damage over 3 sec and slowing their movement speed by 50%.",
					name = "Mind Flay",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 136208,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Improved Fade",
					tips = "Decreases the cooldown of your Fade ability by %d sec.",
					tipValues = {{3}, {6}},
					column = 2,
					row = 4,
					icon = 135994,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Shadow Reach",
					tips = "Increases the range of your offensive Shadow spells by %d%%.",
					tipValues = {{10}, {20}},
					column = 3,
					row = 4,
					icon = 136130,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Shadow Weaving",
					tips = "Your Shadow damage spells have a %d%% chance to cause your target to be vulnerable to Shadow damage.  This vulnerability increases the Shadow damage dealt to your target by 2%% and lasts 15 sec.  Stacks up to 5 times.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 4,
					row = 4,
					icon = 136123,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					tips = "Silences the target, preventing them from casting spells for 5 sec.",
					prereqs = {
						{
							column = 1,
							row = 3,
							source = 6,
						}, -- [1]
					},
					name = "Silence",
					row = 5,
					column = 1,
					exceptional = 1,
					icon = 136164,
					ranks = 1,
				},
			}, -- [12]
			{
				info = {
					tips = "Afflicts your target with Shadow energy that causes all party members to be healed for 15% of any Shadow spell damage you deal for 1 min.",
					name = "Vampiric Embrace",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136230,
					ranks = 1,
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
					tips = "Increases the percentage healed by Vampiric Embrace by an additional %d%%.",
					tipValues = {{5}, {10}},
					column = 3,
					row = 5,
					icon = 136165,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					name = "Focused Mind",
					tips = "Reduces the mana cost of your Mind Blast, Mind Control and Mind Flay spells by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 4,
					row = 5,
					icon = 136035,
					ranks = 3,
				},
			}, -- [15]
			{
				info = {
					name = "Shadow Resilience",
					tips = "Reduces the chance you'll be critically hit by all spells by %d%%.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 6,
					icon = 136162,
					ranks = 2,
				},
			}, -- [16]
			{
				info = {
					name = "Darkness",
					tips = "Increases your Shadow spell damage by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 6,
					icon = 136223,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					tips = "Assume a Shadowform, increasing your Shadow damage by 15% and reducing Physical damage done to you by 15%.  However, you may not cast Holy spells while in this form.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Shadowform",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136200,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Shadow Power",
					tips = "Increases the critical strike chance of your Mind Blast and Shadow Word: Death spells by %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 7,
					icon = 136204,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					name = "Misery",
					tips = "Your Shadow Word: Pain, Mind Flay and Vampiric Touch spells also cause the target to take an additional %d%% spell damage.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 8,
					icon = 136176,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Causes 450 Shadow damage over 15 sec to your target and causes all party members to gain mana equal to 5% of any Shadow spell damage you deal.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Vampiric Touch",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 135978,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Shadow",
			background = "PriestShadow",
		},
	}, -- [3]
}

talents.rogue = {
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Improved Eviscerate",
					tips = "Increases the damage done by your Eviscerate ability by %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 1,
					icon = 132292,
					ranks = 3,
				},
			}, -- [1]
			{
				info = {
					name = "Remorseless Attacks",
					tips = "After killing an opponent that yields experience or honor, gives you a %d%% increased critical strike chance on your next Sinister Strike, Hemorrhage, Backstab, Mutilate, Ambush, or Ghostly Strike.  Lasts 20 sec.",
					tipValues = {{20}, {40}},
					column = 2,
					row = 1,
					icon = 132151,
					ranks = 2,
				},
			}, -- [2]
			{
				info = {
					name = "Malice",
					tips = "Increases your critical strike chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 1,
					icon = 132277,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Ruthlessness",
					tips = "Gives your melee finishing moves a %d%% chance to add a combo point to your target.",
					tipValues = {{20}, {40}, {60}},
					column = 1,
					row = 2,
					icon = 132122,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					name = "Murder",
					tips = "Increases all damage caused against Humanoid, Giant, Beast and Dragonkin targets by %d%%.",
					tipValues = {{1}, {2}},
					column = 2,
					row = 2,
					icon = 136147,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					name = "Puncturing Wounds",
					tips = "Increases the critical strike chance of your Backstab ability by %d%%, and the critical strike chance of your Mutilate ability by %d%%.",
					tipValues = {{10, 5}, {20, 10}, {30, 15}},
					column = 4,
					row = 2,
					icon = 132090,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					tips = "Your finishing moves have a 20% chance per combo point to restore 25 energy.",
					name = "Relentless Strikes",
					row = 3,
					column = 1,
					exceptional = 1,
					icon = 132340,
					ranks = 1,
				},
			}, -- [7]
			{
				info = {
					name = "Improved Expose Armor",
					tips = "Increases the armor reduced by your Expose Armor ability by %d%%.",
					tipValues = {{25}, {50}},
					column = 2,
					row = 3,
					icon = 132354,
					ranks = 2,
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
					tips = "Increases the critical strike damage bonus of your Sinister Strike, Gouge, Backstab, Ghostly Strike, Mutilate, Shiv, and Hemorrhage abilities by %d%%.",
					tipValues = {{6}, {12}, {18}, {24}, {30}},
					column = 3,
					row = 3,
					icon = 132109,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					name = "Vile Poisons",
					tips = "Increases the damage dealt by your poisons and Envenom ability by %d%% and gives your poisons an additional %d%% chance to resist dispel effects.",
					tipValues = {{4, 8}, {8, 16}, {12, 24}, {16, 32}, {20, 40}},
					column = 2,
					row = 4,
					icon = 132293,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					name = "Improved Poisons",
					tips = "Increases the chance to apply poisons to your target by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 4,
					icon = 132273,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					name = "Fleet Footed",
					tips = "Increases your chance to resist movement impairing effects by %d%% and increases your movement speed by %d%%.  This does not stack with other movement speed increasing effects.",
					tipValues = {{5, 8}, {10, 15}},
					column = 1,
					row = 5,
					icon = 132296,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, increases the critical strike chance of your next offensive ability by 100%.",
					name = "Cold Blood",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 135988,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					name = "Improved Kidney Shot",
					tips = "While affected by your Kidney Shot ability, the target receives an additional %d%% damage from all sources.",
					tipValues = {{3}, {6}, {9}},
					column = 3,
					row = 5,
					icon = 132298,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					name = "Quick Recovery",
					tips = "All healing effects on you are increased by %d%%.  In addition, your finishing moves cost %d%% less Energy when they fail to hit.",
					tipValues = {{10, 40}, {20, 80}},
					column = 4,
					row = 5,
					icon = 132301,
					ranks = 2,
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
					name = "Seal Fate",
					tips = "Your critical strikes from abilities that add combo points have a %d%% chance to add an additional combo point.",
					tipValues = {{20}, {40}, {60}, {80}, {100}},
					column = 2,
					row = 6,
					icon = 136130,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Master Poisoner",
					tips = "Reduces the chance your poisons will be resisted by %d%% and increases your chance to resist Poison effects by an additional %d%%.",
					tipValues = {{5, 15}, {10, 30}},
					column = 3,
					row = 6,
					icon = 132108,
					ranks = 2,
				},
			}, -- [17]
			{
				info = {
					name = "Vigor",
					tips = "Increases your maximum Energy by 10.",
					column = 2,
					row = 7,
					icon = 136023,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Deadened Nerves",
					tips = "Decreases all physical damage taken by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 7,
					icon = 132286,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					name = "Find Weakness",
					tips = "Your finishing moves increase the damage of all your offensive abilities by %d%% for 10 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 8,
					icon = 132295,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Instantly attacks with both weapons for an additional 44 with each weapon.  Damage is increased by 50% against Poisoned targets.  Must be behind the target.  Awards 2 combo points.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Mutilate",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132304,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Assassination",
			background = "RogueAssassination",
		},
	}, -- [1]
	{
		numtalents = 24,
		talents = {
			{
				info = {
					name = "Improved Gouge",
					tips = "Increases the effect duration of your Gouge ability by %.1f sec.",
					tipValues = {{0.5}, {1.0}, {1.5}},
					column = 1,
					row = 1,
					icon = 132155,
					ranks = 3,
				},
			}, -- [1]
			{
				info = {
					name = "Improved Sinister Strike",
					tips = "Reduces the Energy cost of your Sinister Strike ability by %d.",
					tipValues = {{3}, {5}},
					column = 2,
					row = 1,
					icon = 136189,
					ranks = 2,
				},
			}, -- [2]
			{
				info = {
					name = "Lightning Reflexes",
					tips = "Increases your Dodge chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 1,
					icon = 136047,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Slice and Dice",
					tips = "Increases the duration of your Slice and Dice ability by %d%%.",
					tipValues = {{15}, {30}, {45}},
					column = 1,
					row = 2,
					icon = 132306,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					name = "Deflection",
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 2,
					icon = 132269,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					name = "Precision",
					tips = "Increases your chance to hit with weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 2,
					icon = 132222,
					ranks = 5,
				},
			}, -- [6]
			{
				info = {
					name = "Endurance",
					tips = "Reduces the cooldown of your Sprint and Evasion abilities by %d sec.",
					tipValues = {{45}, {90}},
					column = 1,
					row = 3,
					icon = 136205,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					tips = "A strike that becomes active after parrying an opponent's attack.  This attack deals 150% weapon damage and disarms the target for 6 sec.",
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
				},
			}, -- [8]
			{
				info = {
					name = "Improved Sprint",
					tips = "Gives a %d%% chance to remove all Movement Impairing effects when you activate your Sprint ability.",
					tipValues = {{50}, {100}},
					column = 4,
					row = 3,
					icon = 132307,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Improved Kick",
					tips = "Gives your Kick ability a %d%% chance to silence the target for 2 sec.",
					tipValues = {{50}, {100}},
					column = 1,
					row = 4,
					icon = 132219,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Dagger Specialization",
					tips = "Increases your chance to get a critical strike with Daggers by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 4,
					icon = 135641,
					ranks = 5,
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
					tipValues = {{10}, {20}, {30}, {40}, {50}},
					column = 3,
					row = 4,
					icon = 132147,
					ranks = 5,
				},
			}, -- [12]
			{
				info = {
					name = "Mace Specialization",
					tips = "Increases the damage dealt by your critical strikes with maces by %d%%, and gives you a %d%% chance to stun your target for 3 sec with a mace.",
					tipValues = {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}},
					column = 1,
					row = 5,
					icon = 133476,
					ranks = 5,
				},
			}, -- [13]
			{
				info = {
					tips = "Increases your attack speed by 20%.  In addition, attacks strike an additional nearby opponent.  Lasts 15 sec.",
					name = "Blade Flurry",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 132350,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					name = "Sword Specialization",
					tips = "Gives you a %d%% chance to get an extra attack on the same target after hitting your target with your Sword.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 5,
					icon = 135328,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					name = "Fist Weapon Specialization",
					tips = "Increases your chance to get a critical strike with Fist Weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 4,
					row = 5,
					icon = 132938,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Blade Twisting",
					tips = "Gives your Sinister Strike, Backstab, Gouge and Shiv abilities a %d%% chance to Daze the target for 8 sec.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 6,
					icon = 132283,
					ranks = 2,
				},
			}, -- [17]
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
					tips = "Increases your expertise by %d.",
					tipValues = {{5}, {10}},
					column = 2,
					row = 6,
					icon = 135882,
					ranks = 2,
				},
			}, -- [18]
			{
				info = {
					name = "Aggression",
					tips = "Increases the damage of your Sinister Strike, Backstab, and Eviscerate abilities by %d%%.",
					tipValues = {{2}, {4}, {6}},
					column = 3,
					row = 6,
					icon = 132275,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					name = "Vitality",
					tips = "Increases your total Stamina by %d%% and your total Agility by %d%%.",
					tipValues = {{2, 1}, {4, 2}},
					column = 1,
					row = 7,
					icon = 132353,
					ranks = 2,
				},
			}, -- [20]
			{
				info = {
					tips = "Increases your Energy regeneration rate by 100% for 15 sec.",
					name = "Adrenaline Rush",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136206,
					ranks = 1,
				},
			}, -- [21]
			{
				info = {
					name = "Nerves of Steel",
					tips = "Increases your chance to resist Stun and Fear effects by an additional %d%%.",
					tipValues = {{5}, {10}},
					column = 3,
					row = 7,
					icon = 132300,
					ranks = 2,
				},
			}, -- [22]
			{
				info = {
					name = "Combat Potency",
					tips = "Gives your successful off-hand melee attacks a 20%% chance to generate %d Energy.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
					column = 3,
					row = 8,
					icon = 135673,
					ranks = 5,
				},
			}, -- [23]
			{
				info = {
					tips = "Your finishing moves can no longer be dodged, and the damage dealt by your Sinister Strike, Backstab, Shiv and Gouge abilities is increased by 10%.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 21,
						}, -- [1]
					},
					name = "Surprise Attacks",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132308,
					ranks = 1,
				},
			}, -- [24]
		},
		info = {
			name = "Combat",
			background = "RogueCombat",
		},
	}, -- [2]
	{
		numtalents = 22,
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
					tips = "Increases the damage dealt when striking from behind with your Backstab, Mutilate, Garrote and Ambush abilities by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 3,
					row = 1,
					icon = 132366,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Sleight of Hand",
					tips = "Reduces the chance you are critically hit by melee and ranged attacks by %d%% and increases the threat reduction of your Feint ability by %d%%.",
					tipValues = {{1, 10}, {2, 20}},
					column = 1,
					row = 2,
					icon = 132294,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					name = "Dirty Tricks",
					tips = "Increases the range of your Blind and Sap abilities by %d yards and reduces the energy cost of your Blind and Sap abilities by %d%%.",
					tipValues = {{2, 25}, {5, 50}},
					column = 2,
					row = 2,
					icon = 132310,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Camouflage",
					tips = "Increases your speed while stealthed by %d%% and reduces the cooldown of your Stealth ability by %d sec.",
					tipValues = {{3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}},
					column = 3,
					row = 2,
					icon = 132320,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					name = "Initiative",
					tips = "Gives you a %d%% chance to add an additional combo point to your target when using your Ambush, Garrote, or Cheap Shot ability.",
					tipValues = {{25}, {50}, {75}},
					column = 1,
					row = 3,
					icon = 136159,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					tips = "A strike that deals 125% weapon damage and increases your chance to dodge by 15% for 7 sec.  Awards 1 combo point.",
					name = "Ghostly Strike",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 136136,
					ranks = 1,
				},
			}, -- [7]
			{
				info = {
					name = "Improved Ambush",
					tips = "Increases the critical strike chance of your Ambush ability by %d%%.",
					tipValues = {{15}, {30}, {45}},
					column = 3,
					row = 3,
					icon = 132282,
					ranks = 3,
				},
			}, -- [8]
			{
				info = {
					name = "Setup",
					tips = "Gives you a %d%% chance to add a combo point to your target after dodging their attack or fully resisting one of their spells.",
					tipValues = {{15}, {30}, {45}},
					column = 1,
					row = 4,
					icon = 136056,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					name = "Elusiveness",
					tips = "Reduces the cooldown of your Vanish and Blind abilities by %d sec.",
					tipValues = {{45}, {90}},
					column = 2,
					row = 4,
					icon = 135994,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Serrated Blades",
					tips = "Causes your attacks to ignore %.2f*level of your target's Armor and increases the damage dealt by your Rupture ability by %d%%.  The amount of Armor reduced increases with your level.",
					tipValues = {{2.67, 10}, {5.43, 20}, {8, 30}},
					column = 3,
					row = 4,
					icon = 135315,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					name = "Heightened Senses",
					tips = "Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by %d%%.",
					tipValues = {{2}, {4}},
					column = 1,
					row = 5,
					icon = 132089,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, this ability immediately finishes the cooldown on your Evasion, Sprint, Vanish, Cold Blood, Shadowstep and Premeditation abilities.",
					name = "Preparation",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136121,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					name = "Dirty Deeds",
					tips = "Reduces the Energy cost of your Cheap Shot and Garrote abilities by %d.  Additionally, your special abilities cause %d%% more damage against targets below 35%% health.",
					tipValues = {{10, 10}, {20, 20}},
					column = 3,
					row = 5,
					icon = 136220,
					ranks = 2,
				},
			}, -- [14]
			{
				info = {
					tips = "An instant strike that deals 110% weapon damage and causes the target to hemorrhage, increasing any Physical damage dealt to the target by up to 13.  Lasts 10 charges or 15 sec.  Awards 1 combo point.",
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
				},
			}, -- [15]
			{
				info = {
					name = "Master of Subtlety",
					tips = "Attacks made while stealthed and for 6 seconds after breaking stealth cause an additional %d%% damage.",
					tipValues = {{4}, {7}, {10}},
					column = 1,
					row = 6,
					icon = 132299,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					name = "Deadliness",
					tips = "Increases your attack power by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 6,
					icon = 135540,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					name = "Enveloping Shadows",
					tips = "Increases your chance to avoid area of effect attacks by an additional %d%%.",
					tipValues = {{5}, {10}, {15}},
					column = 1,
					row = 7,
					icon = 132291,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "When used, adds 2 combo points to your target.  You must add to or use those combo points within 10 sec or the combo points are lost.",
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
				},
			}, -- [19]
			{
				info = {
					name = "Cheat Death",
					tips = "You have a %d%% chance that an attack which would otherwise kill you will instead reduce you to 10%% of your maximum health. In addition, all damage taken will be reduced by up to 90%% for 3 sec (modified by resilience).  This effect cannot occur more than once per minute.",
					tipValues = {{33}, {66}, {100}},
					column = 3,
					row = 7,
					icon = 132285,
					ranks = 3,
				},
			}, -- [20]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 19,
						}, -- [1]
					},
					name = "Sinister Calling",
					tips = "Increases your total Agility by %d%% and increases the percentage damage bonus of Backstab and Hemorrhage by an additional %d%%.",
					tipValues = {{3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}},
					column = 2,
					row = 8,
					icon = 132305,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Attempts to step through the shadows and reappear behind your enemy and increases movement speed by 70% for 3 sec.  The damage of your next ability is increased by 20% and the threat caused is reduced by 50%.  Lasts 10 sec.",
					name = "Shadowstep",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 132303,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Subtlety",
			background = "RogueSubtlety",
		},
	}, -- [3]
}

talents.shaman = {
	{
		numtalents = 20,
		talents = {
			{
				info = {
					tips = "Reduces the mana cost of your Shock, Lightning Bolt and Chain Lightning spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					name = "Convection",
					column = 2,
					row = 1,
					icon = 136116,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					tips = "Increases the damage done by your Lightning Bolt, Chain Lightning and Shock spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Concussion",
					column = 3,
					row = 1,
					icon = 135807,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					tips = "Increases the health of your Stoneclaw Totem by %d%% and the radius of your Earthbind Totem by %d%%.",
					tipValues = {{25, 10}, {50, 20}},
					name = "Earth's Grasp",
					column = 1,
					row = 2,
					icon = 136097,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					tips = "Reduces damage taken from Fire, Frost and Nature effects by %d%%.",
					tipValues = {{4}, {7}, {10}},
					name = "Elemental Warding",
					column = 2,
					row = 2,
					icon = 136094,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					tips = "Increases the damage done by your Fire Totems by %d%%.",
					tipValues = {{5}, {10}, {15}},
					name = "Call of Flame",
					column = 3,
					row = 2,
					icon = 135817,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					tips = "After landing a critical strike with a Fire, Frost, or Nature damage spell, you enter a Clearcasting state.  The Clearcasting state reduces the mana cost of your next 2 damage spells by 40%.",
					name = "Elemental Focus",
					exceptional = 1,
					column = 1,
					row = 3,
					icon = 136170,
					ranks = 1,
				},
			}, -- [6]
			{
				info = {
					tips = "Reduces the cooldown of your Shock spells by %.1f sec.",
					tipValues = {{0.2}, {0.4}, {0.6}, {0.8}, {1.0}},
					name = "Reverberation",
					column = 2,
					row = 3,
					icon = 135850,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "Increases the critical strike chance of your Lightning Bolt and Chain Lightning spells by an additional %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Call of Thunder",
					column = 3,
					row = 3,
					icon = 136014,
					ranks = 5,
				},
			}, -- [8]
			{
				info = {
					tips = "Reduces the delay before your Fire Nova Totem activates by %d sec. and decreases the threat generated by your Magma Totem by %d%%.",
					tipValues = {{1, 25}, {2, 50}},
					name = "Improved Fire Totems",
					column = 1,
					row = 4,
					icon = 135824,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					tips = "Gives you a %d%% chance to gain the Focused Casting effect that lasts for 6 sec after being the victim of a melee or ranged critical strike.  The Focused Casting effect prevents you from losing casting time on Shaman spells when taking damage.",
					tipValues = {{33}, {66}, {100}},
					name = "Eye of the Storm",
					column = 2,
					row = 4,
					icon = 136213,
					ranks = 3,
				},
			}, -- [10]
			{
				info = {
					tips = "Your offensive spell crits will increase your chance to get a critical strike with melee attacks by %d%% for 10 sec.",
					tipValues = {{3}, {6}, {9}},
					name = "Elemental Devastation",
					column = 4,
					row = 4,
					icon = 135791,
					ranks = 3,
				},
			}, -- [11]
			{
				info = {
					tips = "Increases the range of your Lightning Bolt and Chain Lightning spells by %d yards.",
					tipValues = {{3}, {6}},
					name = "Storm Reach",
					column = 1,
					row = 5,
					icon = 136099,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "Increases the critical strike damage bonus of your Searing, Magma, and Fire Nova Totems and your Fire, Frost, and Nature spells by 100%.",
					name = "Elemental Fury",
					column = 2,
					row = 5,
					icon = 135830,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					tips = "Regenerate mana equal to %d%% of your Intellect every 5 sec, even while casting.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					name = "Unrelenting Storm",
					column = 4,
					row = 5,
					icon = 136111,
					ranks = 5,
				},
			}, -- [14]
			{
				info = {
					tips = "Increases your chance to hit with Fire, Frost and Nature spells by %d%% and reduces the threat caused by Fire, Frost and Nature spells by %d%%.",
					tipValues = {{2, 4}, {4, 7}, {6, 10}},
					name = "Elemental Precision",
					column = 1,
					row = 6,
					icon = 136028,
					ranks = 3,
				},
			}, -- [15]
			{
				info = {
					tips = "Reduces the cast time of your Lightning Bolt and Chain Lightning spells by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 8,
						}, -- [1]
					},
					name = "Lightning Mastery",
					column = 3,
					row = 6,
					icon = 135990,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					tips = "When activated, this spell gives your next Fire, Frost, or Nature damage spell a 100% critical strike chance and reduces the mana cost by 100%.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Elemental Mastery",
					exceptional = 1,
					column = 2,
					row = 7,
					icon = 136115,
					ranks = 1,
				},
			}, -- [17]
			{
				info = {
					tips = "Reduces the chance you will be critically hit by melee and ranged attacks by %d%%.",
					tipValues = {{2}, {4}, {6}},
					name = "Elemental Shields",
					column = 3,
					row = 7,
					icon = 136030,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "Gives your Lightning Bolt and Chain Lightning spells a %d%% chance to cast a second, similar spell on the same target at no additional cost that causes half damage and no threat.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					name = "Lightning Overload",
					column = 2,
					row = 8,
					icon = 136050,
					ranks = 5,
				},
			}, -- [19]
			{
				info = {
					tips = "Summons a Totem of Wrath with 5 health at the feet of the caster.  The totem increases the chance to hit and critically strike with spells by 3% for all party members within 20 yards.  Lasts 2 min.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 19,
						}, -- [1]
					},
					name = "Totem of Wrath",
					exceptional = 1,
					column = 2,
					row = 9,
					icon = 135829,
					ranks = 1,
				},
			}, -- [20]
		},
		info = {
			background = "ShamanElementalCombat",
			name = "Elemental",
		},
	}, -- [1]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					tips = "Increases your maximum mana by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Ancestral Knowledge",
					column = 2,
					row = 1,
					icon = 136162,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					tips = "Increases your chance to block attacks with a shield by %d%% and increases the amount blocked by %d%%.",
					tipValues = {{1, 5}, {2, 10}, {3, 15}, {4, 20}, {5, 25}},
					name = "Shield Specialization",
					column = 3,
					row = 1,
					icon = 134952,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					tips = "Increases the amount of damage reduced by your Stoneskin Totem and Windwall Totem by %d%% and reduces the cooldown of your Grounding Totem by %d sec.",
					tipValues = {{10, 1}, {20, 2}},
					name = "Guardian Totems",
					column = 1,
					row = 2,
					icon = 136098,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					tips = "Improves your chance to get a critical strike with your weapon attacks by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Thundering Strikes",
					column = 2,
					row = 2,
					icon = 132325,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					tips = "Reduces the cast time of your Ghost Wolf spell by %d sec.",
					tipValues = {{1}, {2}},
					name = "Improved Ghost Wolf",
					column = 3,
					row = 2,
					icon = 136095,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					tips = "Increases the damage done by your Lightning Shield orbs by %d%%.",
					tipValues = {{5}, {10}, {15}},
					name = "Improved Lightning Shield",
					column = 4,
					row = 2,
					icon = 136051,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					tips = "Increases the effect of your Strength of Earth and Grace of Air Totems by %d%%.",
					tipValues = {{8}, {15}},
					name = "Enhancing Totems",
					column = 1,
					row = 3,
					icon = 136023,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					tips = "After landing a melee critical strike, you enter a Focused state.  The Focused state reduces the mana cost of your next Shock spell by 60%.",
					name = "Shamanistic Focus",
					column = 3,
					row = 3,
					icon = 136027,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					tips = "Increases your chance to dodge by an additional %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Anticipation",
					column = 4,
					row = 3,
					icon = 136056,
					ranks = 5,
				},
			}, -- [9]
			{
				info = {
					tips = "Increases your attack speed by %d%% for your next 3 swings after dealing a critical strike.",
					tipValues = {{10}, {15}, {20}, {25}, {30}},
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 4,
						}, -- [1]
					},
					name = "Flurry",
					column = 2,
					row = 4,
					icon = 132152,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					tips = "Increases your armor value from items by %d%%, and reduces the duration of movement slowing effects on you by %d%%.",
					tipValues = {{2, 10}, {4, 20}, {6, 30}, {8, 40}, {10, 50}},
					name = "Toughness",
					column = 3,
					row = 4,
					icon = 135892,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					tips = "Increases the melee attack power bonus of your Windfury Totem by %d%% and increases the damage caused by your Flametongue Totem by %d%%.",
					tipValues = {{15, 6}, {30, 12}},
					name = "Improved Weapon Totems",
					column = 1,
					row = 5,
					icon = 135792,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					tips = "Gives a chance to parry enemy melee attacks and reduces the threat generated by your melee attacks by 30%.",
					name = "Spirit Weapons",
					column = 2,
					row = 5,
					icon = 132269,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					tips = "Increases the damage caused by your Rockbiter Weapon by %d%%, your Windfury Weapon effect by %d%% and increases the damage caused by your Flametongue Weapon and Frostbrand Weapon by %d%%.",
					tipValues = {{7, 13, 5}, {14, 27, 10}, {20, 40, 15}},
					name = "Elemental Weapons",
					column = 3,
					row = 5,
					icon = 135814,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					tips = "Reduces the mana cost of your instant cast Shaman spells by %d%% and increases your spell damage and healing by an amount equal to %d%% of your attack power.",
					tipValues = {{2, 10}, {4, 20}, {6, 30}},
					name = "Mental Quickness",
					column = 1,
					row = 6,
					icon = 136055,
					ranks = 3,
				},
			}, -- [15]
			{
				info = {
					tips = "Increases the damage you deal with all weapons by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					name = "Weapon Mastery",
					column = 4,
					row = 6,
					icon = 132215,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					tips = "Increases your chance to hit while dual wielding by an additional %d%%.",
					tipValues = {{2}, {4}, {6}},
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Dual Wield Specialization",
					column = 1,
					row = 7,
					icon = 132148,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "Allows one-hand and off-hand weapons to be equipped in the off-hand.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Dual Wield",
					column = 2,
					row = 7,
					icon = 132147,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					tips = "Instantly attack with both weapons.  In addition, the next 2 sources of Nature damage dealt to the target are increased by 20%.  Lasts 12 sec.",
					prereqs = {
						{
							column = 3,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Stormstrike",
					exceptional = 1,
					column = 3,
					row = 7,
					icon = 132314,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					tips = "Causes your critical hits with melee attacks to increase all party members' melee attack power by %d%% if within 20 yards of the Shaman.  Lasts 10 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					name = "Unleashed Rage",
					column = 2,
					row = 8,
					icon = 136110,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 30% of your attack power.  Lasts 15 sec.",
					name = "Shamanistic Rage",
					exceptional = 1,
					column = 2,
					row = 9,
					icon = 136088,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			background = "ShamanEnhancement",
			name = "Enhancement",
		},
	}, -- [2]
	{
		numtalents = 20,
		talents = {
			{
				info = {
					tips = "Reduces the casting time of your Healing Wave spell by %.1f sec.",
					tipValues = {{0.1}, {0.2}, {0.3}, {0.4}, {0.5}},
					name = "Improved Healing Wave",
					column = 2,
					row = 1,
					icon = 136052,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					tips = "Reduces the mana cost of your healing spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Tidal Focus",
					column = 3,
					row = 1,
					icon = 135859,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					tips = "Reduces the cooldown of your Reincarnation spell by %d min and increases the amount of health and mana you reincarnate with by an additional %d%%.",
					tipValues = {{10, 10}, {20, 20}},
					name = "Improved Reincarnation",
					column = 1,
					row = 2,
					icon = 136080,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					tips = "Increases your target's armor value by %d%% for 15 sec after getting a critical effect from one of your healing spells.",
					tipValues = {{8}, {16}, {25}},
					name = "Ancestral Healing",
					column = 2,
					row = 2,
					icon = 136109,
					ranks = 3,
				},
			}, -- [4]
			{
				info = {
					tips = "Reduces the mana cost of your totems by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					name = "Totemic Focus",
					column = 3,
					row = 2,
					icon = 136057,
					ranks = 5,
				},
			}, -- [5]
			{
				info = {
					tips = "Increases your chance to hit with melee attacks and spells by %d%%.",
					tipValues = {{1}, {2}, {3}},
					name = "Nature's Guidance",
					column = 1,
					row = 3,
					icon = 135860,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while casting any Shaman healing spell.",
					tipValues = {{14}, {28}, {42}, {56}, {70}},
					name = "Healing Focus",
					column = 2,
					row = 3,
					icon = 136043,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "The radius of your totems that affect friendly targets is increased to 30 yards.",
					name = "Totemic Mastery",
					column = 3,
					row = 3,
					icon = 136069,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					tips = "Reduces the threat generated by your healing spells by %d%% and reduces the chance your spells will be dispelled by %d%%.",
					tipValues = {{5, 10}, {10, 20}, {15, 30}},
					name = "Healing Grace",
					column = 4,
					row = 3,
					icon = 136041,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					tips = "Increases the effect of your Mana Spring and Healing Stream Totems by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					name = "Restorative Totems",
					column = 2,
					row = 4,
					icon = 136053,
					ranks = 5,
				},
			}, -- [10]
			{
				info = {
					tips = "Increases the critical effect chance of your healing and lightning spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					name = "Tidal Mastery",
					column = 3,
					row = 4,
					icon = 136107,
					ranks = 5,
				},
			}, -- [11]
			{
				info = {
					tips = "Your Healing Wave spells have a %d%% chance to increase the effect of subsequent Healing Wave spells on that target by 6%% for 15 sec.  This effect will stack up to 3 times.",
					tipValues = {{33}, {66}, {100}},
					name = "Healing Way",
					column = 1,
					row = 5,
					icon = 136044,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					tips = "When activated, your next Nature spell with a casting time less than 10 sec. becomes an instant cast spell.",
					name = "Nature's Swiftness",
					exceptional = 1,
					column = 3,
					row = 5,
					icon = 136076,
					ranks = 1,
				},
			}, -- [13]
			{
				info = {
					tips = "Reduces the duration of any Silence or Interrupt effects used against the Shaman by %d%%. This effect does not stack with other similar effects.",
					tipValues = {{10}, {20}, {30}},
					name = "Focused Mind",
					column = 4,
					row = 5,
					icon = 136035,
					ranks = 3,
				},
			}, -- [14]
			{
				info = {
					tips = "Increases the effectiveness of your healing spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					name = "Purification",
					column = 3,
					row = 6,
					icon = 135865,
					ranks = 5,
				},
			}, -- [15]
			{
				info = {
					tips = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 6% of total mana every 3 seconds to group members within 20 yards.",
					prereqs = {
						{
							column = 2,
							row = 4,
							source = 10,
						}, -- [1]
					},
					name = "Mana Tide Totem",
					exceptional = 1,
					column = 2,
					row = 7,
					icon = 135861,
					ranks = 1,
				},
			}, -- [16]
			{
				info = {
					tips = "Whenever a damaging attack is taken that reduces you below 30%% health, you have a %d%% chance to heal 10%% of your total health and reduce your threat level on that target.  5 second cooldown.",
					tipValues = {{10}, {20}, {30}, {40}, {50}},
					name = "Nature's Guardian",
					column = 3,
					row = 7,
					icon = 136060,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					tips = "Increases your spell damage and healing by an amount equal to %d%% of your Intellect.",
					tipValues = {{10}, {20}, {30}},
					name = "Nature's Blessing",
					column = 2,
					row = 8,
					icon = 136059,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "Increases the amount healed by your Chain Heal spell by %d%%.",
					tipValues = {{10}, {20}},
					name = "Improved Chain Heal",
					column = 3,
					row = 8,
					icon = 136042,
					ranks = 2,
				},
			}, -- [19]
			{
				info = {
					tips = "Protects the target with an earthen shield, giving a 30% chance of ignoring spell interruption when damaged and causing attacks to heal the shielded target for 150.  This effect can only occur once every few seconds.  6 charges.  Lasts 10 min.  Earth Shield can only be placed on one target at a time and only one Elemental Shield can be active on a target at a time.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 18,
						}, -- [1]
					},
					name = "Earth Shield",
					exceptional = 1,
					column = 2,
					row = 9,
					icon = 136089,
					ranks = 1,
				},
			}, -- [20]
		},
		info = {
			background = "ShamanRestoration",
			name = "Restoration",
		},
	}, -- [3]
}

talents.warlock = {
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Suppression",
					tips = "Reduces the chance for enemies to resist your Affliction spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 1,
					icon = 136230,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Improved Corruption",
					tips = "Reduces the casting time of your Corruption spell by %.1f sec.",
					tipValues = {{0.4}, {0.8}, {1.2}, {1.6}, {2.0}},
					column = 3,
					row = 1,
					icon = 136118,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Improved Curse of Weakness",
					tips = "Increases the effect of your Curse of Weakness by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 2,
					icon = 136138,
					ranks = 2,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Drain Soul",
					tips = "Returns %d%% of your maximum mana if the target is killed by you while you drain its soul.  In addition, your Affliction spells generate %d%% less threat.",
					tipValues = {{7, 5}, {15, 10}},
					column = 2,
					row = 2,
					icon = 136163,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Improved Life Tap",
					tips = "Increases the amount of Mana awarded by your Life Tap spell by %d%%.",
					tipValues = {{10}, {20}},
					column = 3,
					row = 2,
					icon = 136126,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					name = "Soul Siphon",
					tips = "Increases the amount drained by your Drain Life spell by an additional %d%% for each Affliction effect on the target, up to a maximum of %d%% additional effect.",
					tipValues = {{2, 24}, {4, 60}},
					column = 4,
					row = 2,
					icon = 136169,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Curse of Agony",
					tips = "Increases the damage done by your Curse of Agony by %d%%.",
					tipValues = {{5}, {10}},
					column = 1,
					row = 3,
					icon = 136139,
					ranks = 2,
				},
			}, -- [7]
			{
				info = {
					name = "Fel Concentration",
					tips = "Gives you a %d%% chance to avoid interruption caused by damage while channeling the Drain Life, Drain Mana, or Drain Soul spell.",
					tipValues = {{14}, {28}, {42}, {56}, {70}},
					column = 2,
					row = 3,
					icon = 136157,
					ranks = 5,
				},
			}, -- [8]
			{
				info = {
					tips = "Increases the effect of your next Curse of Doom or Curse of Agony by 50%, or your next Curse of Exhaustion by an additional 20%.  Lasts 30 sec.",
					name = "Amplify Curse",
					row = 3,
					column = 3,
					exceptional = 1,
					icon = 136132,
					ranks = 1,
				},
			}, -- [9]
			{
				info = {
					name = "Grim Reach",
					tips = "Increases the range of your Affliction spells by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 4,
					icon = 136127,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Nightfall",
					tips = "Gives your Corruption and Drain Life spells a %d%% chance to cause you to enter a Shadow Trance state after damaging the opponent.  The Shadow Trance state reduces the casting time of your next Shadow Bolt spell by 100%%.",
					tipValues = {{2}, {4}},
					column = 2,
					row = 4,
					icon = 136223,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Empowered Corruption",
					tips = "Your Corruption spell gains an additional %d%% of your bonus spell damage effects.",
					tipValues = {{12}, {24}, {36}},
					column = 4,
					row = 4,
					icon = 136118,
					ranks = 3,
				},
			}, -- [12]
			{
				info = {
					name = "Shadow Embrace",
					tips = "Your Corruption, Curse of Agony, Siphon Life and Seed of Corruption spells also cause the Shadow Embrace effect, which reduces physical damage caused by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 1,
					row = 5,
					icon = 136198,
					ranks = 5,
				},
			}, -- [13]
			{
				info = {
					tips = "Transfers 15 health from the target to the caster every 3 sec.  Lasts 30 sec.",
					name = "Siphon Life",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136188,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					tips = "Reduces the target's movement speed by 30% for 12 sec.  Only one Curse per Warlock can be active on any one target.",
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Curse of Exhaustion",
					row = 5,
					column = 3,
					exceptional = 1,
					icon = 136162,
					ranks = 1,
				},
			}, -- [15]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Shadow Mastery",
					tips = "Increases the damage dealt or life drained by your Shadow spells by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 2,
					row = 6,
					icon = 136195,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Contagion",
					tips = "Increases the damage of Curse of Agony, Corruption and Seed of Corruption by %d%% and reduces the chance your Affliction spells will be dispelled by an additional %d%%.",
					tipValues = {{1, 6}, {2, 12}, {3, 18}, {4, 24}, {5, 30}},
					column = 2,
					row = 7,
					icon = 136180,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					tips = "Drains 305 of your pet's Mana, returning 100% to you.",
					name = "Dark Pact",
					row = 7,
					column = 3,
					exceptional = 1,
					icon = 136141,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Improved Howl of Terror",
					tips = "Reduces the casting time of your Howl of Terror spell by %.1f sec.",
					tipValues = {{0.8}, {1.5}},
					column = 1,
					row = 8,
					icon = 136147,
					ranks = 2,
				},
			}, -- [19]
			{
				info = {
					name = "Malediction",
					tips = "Increases the damage bonus effect of your Curse of the Elements spell by an additional %d%%.",
					tipValues = {{1}, {2}, {3}},
					column = 3,
					row = 8,
					icon = 136137,
					ranks = 3,
				},
			}, -- [20]
			{
				info = {
					tips = "Shadow energy slowly destroys the target, causing 660 damage over 18 sec.  In addition, if the Unstable Affliction is dispelled it will cause 990 damage to the dispeller and silence them for 5 sec.",
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 17,
						}, -- [1]
					},
					name = "Unstable Affliction",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 136228,
					ranks = 1,
				},
			}, -- [21]
		},
		info = {
			name = "Affliction",
			background = "WarlockCurses",
		},
	}, -- [1]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Healthstone",
					tips = "Increases the amount of Health restored by your Healthstone by %d%%.",
					tipValues = {{10}, {20}},
					column = 1,
					row = 1,
					icon = 135230,
					ranks = 2,
				},
			}, -- [1]
			{
				info = {
					name = "Improved Imp",
					tips = "Increases the effect of your Imp's Firebolt, Fire Shield, and Blood Pact spells by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 2,
					row = 1,
					icon = 136218,
					ranks = 3,
				},
			}, -- [2]
			{
				info = {
					name = "Demonic Embrace",
					tips = "Increases your total Stamina by %d%% but reduces your total Spirit by %d%%.",
					tipValues = {{3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}},
					column = 3,
					row = 1,
					icon = 136172,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Improved Health Funnel",
					tips = "Increases the amount of Health transferred by your Health Funnel spell by %d%% and reduces the initial health cost by %d%%.",
					tipValues = {{10, 10}, {20, 20}},
					column = 1,
					row = 2,
					icon = 136168,
					ranks = 2,
				},
			}, -- [4]
			{
				info = {
					name = "Improved Voidwalker",
					tips = "Increases the effectiveness of your Voidwalker's Torment, Consume Shadows, Sacrifice and Suffering spells by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 2,
					row = 2,
					icon = 136221,
					ranks = 3,
				},
			}, -- [5]
			{
				info = {
					name = "Fel Intellect",
					tips = "Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by %d%% and increases your maximum mana by %d%%.",
					tipValues = {{5, 1}, {10, 2}, {15, 3}},
					column = 3,
					row = 2,
					icon = 135932,
					ranks = 3,
				},
			}, -- [6]
			{
				info = {
					name = "Improved Succubus",
					tips = "Increases the effect of your Succubus' Lash of Pain and Soothing Kiss spells by %d%%, and increases the duration of your Succubus' Seduction and Lesser Invisibility spells by %d%%.",
					tipValues = {{10, 10}, {20, 20}, {30, 30}},
					column = 1,
					row = 3,
					icon = 136220,
					ranks = 3,
				},
			}, -- [7]
			{
				info = {
					tips = "Your next Imp, Voidwalker, Succubus, Felhunter or Felguard Summon spell has its casting time reduced by 5.5 sec and its Mana cost reduced by 50%.",
					name = "Fel Domination",
					row = 3,
					column = 2,
					exceptional = 1,
					icon = 136082,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Fel Stamina",
					tips = "Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by %d%% and increases your maximum health by %d%%.",
					tipValues = {{5, 1}, {10, 2}, {15, 3}},
					column = 3,
					row = 3,
					icon = 136121,
					ranks = 3,
				},
			}, -- [9]
			{
				info = {
					name = "Demonic Aegis",
					tips = "Increases the effectiveness of your Demon Armor and Fel Armor spells by %d%%.",
					tipValues = {{10}, {20}, {30}},
					column = 4,
					row = 3,
					icon = 136185,
					ranks = 3,
				},
			}, -- [10]
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
					tips = "Reduces the casting time of your Imp, Voidwalker, Succubus, Felhunter and Fel Guard Summoning spells by %d sec and the Mana cost by %d%%.",
					tipValues = {{2, 20}, {4, 40}},
					column = 2,
					row = 4,
					icon = 136164,
					ranks = 2,
				},
			}, -- [11]
			{
				info = {
					name = "Unholy Power",
					tips = "Increases the damage done by your Voidwalker, Succubus, Felhunter and Felguard's melee attacks and your Imp's Firebolt by %d%%.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 3,
					row = 4,
					icon = 136206,
					ranks = 5,
				},
			}, -- [12]
			{
				info = {
					name = "Improved Enslave Demon",
					tips = "Reduces the Attack Speed and Casting Speed penalty of your Enslave Demon spell by %d%% and reduces the resist chance by %d%%.",
					tipValues = {{5, 5}, {10, 10}},
					column = 1,
					row = 5,
					icon = 136154,
					ranks = 2,
				},
			}, -- [13]
			{
				info = {
					tips = "When activated, sacrifices your summoned demon to grant you an effect that lasts 30 min.  The effect is canceled if any Demon is summoned.\r\n\r\nImp: Increases your Fire damage by 15%.\r\n\r\nVoidwalker: Restores 2% of total health every 4 sec.\r\n\r\nSuccubus: Increases your Shadow damage by 15%.\r\n\r\nFelhunter: Restores 3% of total mana every 4 sec.\r\n\r\nFelguard: Increases your Shadow damage by 10% and restores 2% of total mana every 4 sec.",
					name = "Demonic Sacrifice",
					row = 5,
					column = 2,
					exceptional = 1,
					icon = 136184,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					name = "Master Conjuror",
					tips = "Increases the bonus Fire damage from Firestones and the Firestone effect by %d%% and increases the spell critical strike rating bonus of your Spellstone by %d%%.",
					tipValues = {{15, 15}, {30, 30}},
					column = 4,
					row = 5,
					icon = 132386,
					ranks = 2,
				},
			}, -- [15]
			{
				info = {
					name = "Mana Feed",
					tips = "When you gain mana from Drain Mana or Life Tap spells, your pet gains %d%% of the mana you gain.",
					tipValues = {{33}, {66}, {100}},
					column = 1,
					row = 6,
					icon = 136171,
					ranks = 3,
				},
			}, -- [16]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 12,
						}, -- [1]
					},
					name = "Master Demonologist",
					tips = "Grants both the Warlock and the summoned demon an effect as long as that demon is active.\r\n\r\nImp - Reduces threat caused by %d%%.\r\n\r\nVoidwalker - Reduces physical damage taken by %d%%.\r\n\r\nSuccubus - Increases all damage caused by %d%%.\r\n\r\nFelhunter - Increases all resistances by %.1f per level.\r\n\r\nFelguard - Increases all damage caused by %d%% and all resistances by %.1f per level.",
					tipValues = {{4, 2, 2, 0.2, 1, 0.1}, {8, 4, 4, 0.4, 2, 0.2}, {12, 6, 6, 0.6, 3, 0.3}, {16, 8, 8, 0.8, 4, 0.4}, {20, 10, 10, 1.0, 5, 0.5}},
					column = 3,
					row = 6,
					icon = 136203,
					ranks = 5,
				},
			}, -- [17]
			{
				info = {
					name = "Demonic Resilience",
					tips = "Reduces the chance you'll be critically hit by melee and spells by %d%% and reduces all damage your summoned demon takes by %d%%.",
					tipValues = {{1, 5}, {2, 10}, {3, 15}},
					column = 1,
					row = 7,
					icon = 136149,
					ranks = 3,
				},
			}, -- [18]
			{
				info = {
					tips = "When active, 20% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter, Felguard, or enslaved demon instead.  That damage cannot be prevented.  In addition, both the demon and master will inflict 5% more damage.  Lasts as long as the demon is active and controlled.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Soul Link",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 136160,
					ranks = 1,
				},
			}, -- [19]
			{
				info = {
					name = "Demonic Knowledge",
					tips = "Increases your spell damage by an amount equal to %d%% of the total of your active demon's Stamina plus Intellect.",
					tipValues = {{4}, {8}, {12}},
					column = 3,
					row = 7,
					icon = 136165,
					ranks = 3,
				},
			}, -- [20]
			{
				info = {
					name = "Demonic Tactics",
					tips = "Increases melee and spell critical strike chance for you and your summoned demon by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 2,
					row = 8,
					icon = 136150,
					ranks = 5,
				},
			}, -- [21]
			{
				info = {
					tips = "Summons a Felguard under the command of the Warlock.",
					name = "Summon Felguard",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 136216,
					ranks = 1,
				},
			}, -- [22]
		},
		info = {
			name = "Demonology",
			background = "WarlockSummoning",
		},
	}, -- [2]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Improved Shadow Bolt",
					tips = "Your Shadow Bolt critical strikes increase Shadow damage dealt to the target by %d%% until 4 non-periodic damage sources are applied.  Effect lasts a maximum of 12 sec.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 2,
					row = 1,
					icon = 136197,
					ranks = 5,
				},
			}, -- [1]
			{
				info = {
					name = "Cataclysm",
					tips = "Reduces the Mana cost of your Destruction spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 1,
					icon = 135831,
					ranks = 5,
				},
			}, -- [2]
			{
				info = {
					name = "Bane",
					tips = "Reduces the casting time of your Shadow Bolt and Immolate spells by %.1f sec and your Soul Fire spell by %.1f sec.",
					tipValues = {{0.1, 0.4}, {0.2, 0.8}, {0.3, 1.2}, {0.4, 1.6}, {0.5, 2.0}},
					column = 2,
					row = 2,
					icon = 136146,
					ranks = 5,
				},
			}, -- [3]
			{
				info = {
					name = "Aftermath",
					tips = "Gives your Destruction spells a %d%% chance to daze the target for 5 sec.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
					column = 3,
					row = 2,
					icon = 135805,
					ranks = 5,
				},
			}, -- [4]
			{
				info = {
					name = "Improved Firebolt",
					tips = "Reduces the casting time of your Imp's Firebolt spell by %.2f sec.",
					tipValues = {{0.25}, {0.5}},
					column = 1,
					row = 3,
					icon = 135809,
					ranks = 2,
				},
			}, -- [5]
			{
				info = {
					name = "Improved Lash of Pain",
					tips = "Reduces the cooldown of your Succubus' Lash of Pain spell by %d sec.",
					tipValues = {{3}, {6}},
					column = 2,
					row = 3,
					icon = 136136,
					ranks = 2,
				},
			}, -- [6]
			{
				info = {
					name = "Devastation",
					tips = "Increases the critical strike chance of your Destruction spells by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
					column = 3,
					row = 3,
					icon = 135813,
					ranks = 5,
				},
			}, -- [7]
			{
				info = {
					tips = "Instantly blasts the target for 91 to 104 Shadow damage.  If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.",
					name = "Shadowburn",
					row = 3,
					column = 4,
					exceptional = 1,
					icon = 136191,
					ranks = 1,
				},
			}, -- [8]
			{
				info = {
					name = "Intensity",
					tips = "Gives you a %d%% chance to resist interruption caused by damage while casting or channeling any Destruction spell.",
					tipValues = {{35}, {70}},
					column = 1,
					row = 4,
					icon = 135819,
					ranks = 2,
				},
			}, -- [9]
			{
				info = {
					name = "Destructive Reach",
					tips = "Increases the range of your Destruction spells by %d%% and reduces threat caused by Destruction spells by %d%%.",
					tipValues = {{10, 5}, {20, 10}},
					column = 2,
					row = 4,
					icon = 136133,
					ranks = 2,
				},
			}, -- [10]
			{
				info = {
					name = "Improved Searing Pain",
					tips = "Increases the critical strike chance of your Searing Pain spell by %d%%.",
					tipValues = {{4}, {7}, {10}},
					column = 4,
					row = 4,
					icon = 135827,
					ranks = 3,
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
					tips = "Gives your Rain of Fire, Hellfire, and Soul Fire spells a %d%% chance to stun the target for 3 sec.",
					tipValues = {{13}, {26}},
					column = 1,
					row = 5,
					icon = 135830,
					ranks = 2,
				},
			}, -- [12]
			{
				info = {
					name = "Improved Immolate",
					tips = "Increases the initial damage of your Immolate spell by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
					column = 2,
					row = 5,
					icon = 135817,
					ranks = 5,
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
					tips = "Increases the critical strike damage bonus of your Destruction spells by 100%.",
					column = 3,
					row = 5,
					icon = 136207,
					ranks = 1,
				},
			}, -- [14]
			{
				info = {
					name = "Nether Protection",
					tips = "After being hit with a Shadow or Fire spell, you have a %d%% chance to become immune to Shadow and Fire spells for 4 sec.",
					tipValues = {{10}, {20}, {30}},
					column = 1,
					row = 6,
					icon = 136178,
					ranks = 3,
				},
			}, -- [15]
			{
				info = {
					name = "Emberstorm",
					tips = "Increases the damage done by your Fire spells by %d%% and reduces the cast time of your Incinerate spell by %d%%.",
					tipValues = {{2, 2}, {4, 4}, {6, 6}, {8, 8}, {10, 10}},
					column = 3,
					row = 6,
					icon = 135826,
					ranks = 5,
				},
			}, -- [16]
			{
				info = {
					name = "Backlash",
					tips = "Increases your critical strike chance with spells by an additional %d%% and gives you a %d%% chance when hit by a physical attack to reduce the cast time of your next Shadow Bolt or Incinerate spell by 100%%.  This effect lasts 8 sec and will not occur more than once every 8 seconds.",
					tipValues = {{1, 8}, {2, 16}, {3, 25}},
					column = 1,
					row = 7,
					icon = 135823,
					ranks = 3,
				},
			}, -- [17]
			{
				info = {
					tips = "Ignites a target that is already afflicted by your Immolate, dealing 249 to 316 Fire damage and consuming the Immolate spell.",
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Conflagrate",
					row = 7,
					column = 2,
					exceptional = 1,
					icon = 135807,
					ranks = 1,
				},
			}, -- [18]
			{
				info = {
					name = "Soul Leech",
					tips = "Gives your Shadow Bolt, Shadowburn, Soul Fire, Incinerate, Searing Pain and Conflagrate spells a %d%% chance to return health equal to 20%% of the damage caused.",
					tipValues = {{10}, {20}, {30}},
					column = 3,
					row = 7,
					icon = 136214,
					ranks = 3,
				},
			}, -- [19]
			{
				info = {
					name = "Shadow and Flame",
					tips = "Your Shadow Bolt and Incinerate spells gain an additional %d%% of your bonus spell damage effects.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
					column = 2,
					row = 8,
					icon = 136196,
					ranks = 5,
				},
			}, -- [20]
			{
				info = {
					tips = "Shadowfury is unleashed, causing 355 to 420 Shadow damage and stunning all enemies within 8 yds for 2 sec.",
					prereqs = {
						{
							column = 2,
							row = 8,
							source = 20,
						}, -- [1]
					},
					name = "Shadowfury",
					row = 9,
					column = 2,
					exceptional = 1,
					icon = 136201,
					ranks = 1,
				}, 
			}, -- [21]
		},
		info = {
			name = "Destruction",
			background = "WarlockDestruction",
		},
	}, -- [3]
}

talents.warrior = {
	{
		numtalents = 23,
		talents = {
			{
				info = {
					name = "Improved Heroic Strike",
					ranks = 3,
					column = 1,
					icon = 132282,
					row = 1,
					tips = "Reduces the cost of your Heroic Strike ability by %d rage point%s.",
					tipValues = {{1, ''}, {2, 's'}, {3, 's'}},
				},
			}, -- [1]
			{
				info = {
					name = "Deflection",
					ranks = 5,
					column = 2,
					icon = 132269,
					row = 1,
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [2]
			{
				info = {
					name = "Improved Rend",
					ranks = 3,
					column = 3,
					icon = 132155,
					row = 1,
					tips = "Increases the bleed damage done by your Rend ability by %d%%.",
					tipValues = {{25}, {50}, {75}},
				},
			}, -- [3]
			{
				info = {
					name = "Improved Charge",
					ranks = 2,
					column = 1,
					icon = 132337,
					row = 2,
					tips = "Increases the amount of rage generated by your Charge ability by %d.",
					tipValues = {{3}, {6}},
				},
			}, -- [4]
			{
				info = {
					name = "Iron Will",
					ranks = 5,
					column = 2,
					icon = 135995,
					row = 2,
					tips = "Increases your chance to resist Stun and Charm effects by an additional %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
				},
			}, -- [5]
			{
				info = {
					name = "Improved Thunder Clap",
					ranks = 3,
					column = 3,
					icon = 132326,
					row = 2,
					tips = "Reduces the cost of your Thunder Clap ability by %d rage point%s and increases the damage by %d%% and the slowing effect by an additional %d%%.",
					tipValues = {{1, '', 40, 4}, {2, 's', 70, 7}, {4, 's', 100, 10}},
				},
			}, -- [6]
			{
				info = {
					name = "Improved Overpower",
					ranks = 2,
					column = 1,
					icon = 135275,
					row = 3,
					tips = "Increases the critical strike chance of your Overpower ability by %d%%.",
					tipValues = {{25}, {50}},
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					name = "Anger Management",
					icon = 135881,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Generates 1 rage per 3 seconds while in combat.",
				},
			}, -- [8]
			{
				info = {
					name = "Deep Wounds",
					ranks = 3,
					column = 3,
					icon = 132090,
					row = 3,
					tips = "Your critical strikes cause the opponent to bleed, dealing %d%% of your melee weapon's average damage over 12 sec.",
					tipValues = {{20}, {40}, {60}},
				},
			}, -- [9]
			{
				info = {
					name = "Two-Handed Weapon Specialization",
					ranks = 5,
					column = 2,
					icon = 132400,
					row = 4,
					tips = "Increases the damage you deal with two-handed melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
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
					ranks = 2,
					column = 3,
					icon = 132312,
					row = 4,
					tips = "Increases the critical strike damage bonus of your abilities in Battle, Defensive, and Berserker stance by %d%%.",
					tipValues = {{10}, {20}},
				},
			}, -- [11]
			{
				info = {
					name = "Poleaxe Specialization",
					ranks = 5,
					column = 1,
					icon = 132397,
					row = 5,
					tips = "Increases your chance to get a critical strike with Axes and Polearms by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					name = "Death Wish",
					icon = 136146,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%.  Lasts 30 sec.",
				},
			}, -- [13]
			{
				info = {
					name = "Mace Specialization",
					ranks = 5,
					column = 3,
					icon = 133476,
					row = 5,
					tips = "Gives your melee attacks a chance to stun your target for 3 sec and generate 7 rage when using a Mace.",
				},
			}, -- [14]
			{
				info = {
					name = "Sword Specialization",
					ranks = 5,
					column = 4,
					icon = 135328,
					row = 5,
					tips = "Gives you a %d%% chance to get an extra attack on the same target after hitting your target with your Sword.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [15]
			{
				info = {
					name = "Improved Intercept",
					ranks = 2,
					column = 1,
					icon = 132307,
					row = 6,
					tips = "Reduces the cooldown of your Intercept ability by %d sec.",
					tipValues = {{5}, {10}},
				},
			}, -- [16]
			{
				info = {
					name = "Improved Hamstring",
					ranks = 3,
					column = 3,
					icon = 132316,
					row = 6,
					tips = "Gives your Hamstring ability a %d%% chance to immobilize the target for 5 sec.",
					tipValues = {{5}, {10}, {15}},
				},
			}, -- [17]
			{
				info = {
					name = "Improved Disciplines",
					ranks = 3,
					column = 4,
					icon = 132346,
					row = 6,
					tips = "Reduces the cooldown of your Retaliation, Recklessness and Shield Wall abilities by %d min and increases their duration by %d sec.",
					tipValues = {{4, 2}, {7, 4}, {10, 6}},
				},
			}, -- [18]
			{
				info = {
					name = "Blood Frenzy",
					ranks = 2,
					column = 1,
					icon = 132334,
					row = 7,
					tips = "Your Rend and Deep Wounds abilities also increase all physical damage caused to that target by %d%%.",
					tipValues = {{2}, {4}},
				},
			}, -- [19]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Mortal Strike",
					icon = 132355,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "A vicious strike that deals weapon damage plus 85 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.",
				},
			}, -- [20]
			{
				info = {
					name = "Second Wind",
					ranks = 2,
					column = 3,
					icon = 132175,
					row = 7,
					tips = "Whenever you are struck by a Stun or Immobilize effect you will generate %d rage and %d%% of your total health over 10 sec.",
					tipValues = {{10, 5}, {20, 10}},
				},
			}, -- [21]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 20,
						}, -- [1]
					},
					name = "Improved Mortal Strike",
					ranks = 5,
					column = 2,
					icon = 132355,
					row = 8,
					tips = "Reduces the cooldown of your Mortal Strike ability by %.1f sec and increases the damage it causes by %d%%.",
					tipValues = {{0.2, 1}, {0.4, 2}, {0.6, 3}, {0.8, 4}, {1.0, 5}},
				},
			}, -- [22]
			{
				info = {
					ranks = 1,
					name = "Endless Rage",
					icon = 132344,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "You generate 25% more rage from damage dealt.",
				},
			}, -- [23]
		},
		info = {
			name = "Arms",
			background = "WarriorArms",
		},
	}, -- [1]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Booming Voice",
					ranks = 5,
					column = 2,
					icon = 136075,
					row = 1,
					tips = "Increases the area of effect and duration of your Battle Shout, Demoralizing Shout and Commanding Shout by %d%%.",
					tipValues = {{10}, {20}, {30}, {40}, {50}},
				},
			}, -- [1]
			{
				info = {
					name = "Cruelty",
					ranks = 5,
					column = 3,
					icon = 132292,
					row = 1,
					tips = "Increases your chance to get a critical strike with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [2]
			{
				info = {
					name = "Improved Demoralizing Shout",
					ranks = 5,
					column = 2,
					icon = 132366,
					row = 2,
					tips = "Increases the melee attack power reduction of your Demoralizing Shout by %d%%.",
					tipValues = {{8}, {16}, {24}, {32}, {40}},
				},
			}, -- [3]
			{
				info = {
					name = "Unbridled Wrath",
					ranks = 5,
					column = 3,
					icon = 136097,
					row = 2,
					tips = "Gives you a chance to generate an additional rage point when you deal melee damage with a weapon.",
				},
			}, -- [4]
			{
				info = {
					name = "Improved Cleave",
					ranks = 3,
					column = 1,
					icon = 132338,
					row = 3,
					tips = "Increases the bonus damage done by your Cleave ability by %d%%.",
					tipValues = {{40}, {80}, {120}},
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					name = "Piercing Howl",
					icon = 136147,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Causes all enemies within 10 yards to be Dazed, reducing movement speed by 50% for 6 sec.",
				},
			}, -- [6]
			{
				info = {
					name = "Blood Craze",
					ranks = 3,
					column = 3,
					icon = 136218,
					row = 3,
					tips = "Regenerates %d%% of your total Health over 6 sec after being the victim of a critical strike.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [7]
			{
				info = {
					name = "Commanding Presence",
					ranks = 5,
					column = 4,
					icon = 136035,
					row = 3,
					tips = "Increases the melee attack power bonus of your Battle Shout and the health bonus of your Commanding Shout by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [8]
			{
				info = {
					name = "Dual Wield Specialization",
					ranks = 5,
					column = 1,
					icon = 132147,
					row = 4,
					tips = "Increases the damage done by your offhand weapon by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Execute",
					ranks = 2,
					column = 2,
					icon = 135358,
					row = 4,
					tips = "Reduces the rage cost of your Execute ability by %d.",
					tipValues = {{2}, {5}},
				},
			}, -- [10]
			{
				info = {
					name = "Enrage",
					ranks = 5,
					column = 3,
					icon = 136224,
					row = 4,
					tips = "Gives you a %d%% melee damage bonus for 12 sec up to a maximum of 12 swings after being the victim of a critical strike.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [11]
			{
				info = {
					name = "Improved Slam",
					ranks = 2,
					column = 1,
					icon = 132340,
					row = 5,
					tips = "Decreases the casting time of your Slam ability by %.1f sec.",
					tipValues = {{0.5}, {1.0}},
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					name = "Sweeping Strikes",
					icon = 132306,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Your next 10 melee attacks strike an additional nearby opponent.",
				},
			}, -- [13]
			{
				info = {
					name = "Weapon Mastery",
					ranks = 2,
					column = 4,
					icon = 132367,
					row = 5,
					tips = "Reduces the chance for your attacks to be dodged by %d%% and reduces the duration of all Disarm effects used against you by %d%%.  This does not stack with other Disarm duration reducing effects.",
					tipValues = {{1, 25}, {2, 50}},
				},
			}, -- [14]
			{
				info = {
					name = "Improved Berserker Rage",
					ranks = 2,
					column = 1,
					icon = 136009,
					row = 6,
					tips = "The Berserker Rage ability will generate %d rage when used.",
					tipValues = {{5}, {10}},
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
					ranks = 5,
					column = 3,
					icon = 132152,
					row = 6,
					tips = "Increases your attack speed by %d%% for your next 3 swings after dealing a melee critical strike.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [16]
			{
				info = {
					name = "Precision",
					ranks = 3,
					column = 1,
					icon = 132222,
					row = 7,
					tips = "Increases your chance to hit with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [17]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Bloodthirst",
					icon = 136012,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Instantly attack the target causing 275 damage.  In addition, the next 5 successful melee attacks will restore 10 health.  This effect lasts 8 sec.  Damage is based on your attack power.",
				},
			}, -- [18]
			{
				info = {
					name = "Improved Whirlwind",
					ranks = 2,
					column = 3,
					icon = 132369,
					row = 7,
					tips = "Reduces the cooldown of your Whirlwind ability by %d sec.",
					tipValues = {{1}, {2}},
				},
			}, -- [19]
			{
				info = {
					name = "Improved Berserker Stance",
					ranks = 5,
					column = 3,
					icon = 132275,
					row = 8,
					tips = "Increases attack power by %d%% and reduces threat caused by %d%% while in Berserker Stance.",
					tipValues = {{2, 2}, {4, 4}, {6, 6}, {8, 8}, {10, 10}},
				},
			}, -- [20]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Rampage",
					icon = 132352,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "Warrior goes on a rampage, increasing attack power by 30 and causing most successful melee attacks to increase attack power by an additional 30.  This effect will stack up to 5 times.  Lasts 30 sec.  This ability can only be used after scoring a critical hit.",
				},
			}, -- [21]
		},
		info = {
			name = "Fury",
			background = "WarriorFury",
		},
	}, -- [2]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Bloodrage",
					ranks = 2,
					column = 1,
					icon = 132277,
					row = 1,
					tips = "Increases the instant rage generated by your Bloodrage ability by %d.",
					tipValues = {{3}, {6}},
				},
			}, -- [1]
			{
				info = {
					name = "Tactical Mastery",
					ranks = 3,
					column = 2,
					icon = 136031,
					row = 1,
					tips = "You retain up to an additional %d of your rage points when you change stances.  Also greatly increases the threat generated by your Bloodthirst and Mortal Strike abilities when you are in Defensive Stance.",
					tipValues = {{5}, {10}, {15}},
				},
			}, -- [2]
			{
				info = {
					name = "Anticipation",
					ranks = 5,
					column = 3,
					icon = 136056,
					row = 1,
					tips = "Increases your Defense skill by %d.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
				},
			}, -- [3]
			{
				info = {
					name = "Shield Specialization",
					ranks = 5,
					column = 2,
					icon = 134952,
					row = 2,
					tips = "Increases your chance to block attacks with a shield by %d%% and has a %d%% chance to generate 1 rage when a block occurs.",
					tipValues = {{1, 20}, {2, 40}, {3, 60}, {4, 80}, {5, 100}},
				},
			}, -- [4]
			{
				info = {
					name = "Toughness",
					ranks = 5,
					column = 3,
					icon = 135892,
					row = 2,
					tips = "Increases your armor value from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					name = "Last Stand",
					icon = 135871,
					column = 1,
					exceptional = 1,
					row = 3,
					tips = "When activated, this ability temporarily grants you 30% of your maximum health for 20 sec.  After the effect expires, the health is lost.",
				},
			}, -- [6]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 4,
						}, -- [1]
					},
					name = "Improved Shield Block",
					ranks = 1,
					column = 2,
					icon = 132110,
					row = 3,
					tips = "Allows your Shield Block ability to block an additional attack and increases the duration by 1 second.",
				},
			}, -- [7]
			{
				info = {
					name = "Improved Revenge",
					ranks = 3,
					column = 3,
					icon = 132353,
					row = 3,
					tips = "Gives your Revenge ability a %d%% chance to stun the target for 3 sec.",
					tipValues = {{15}, {30}, {45}},
				},
			}, -- [8]
			{
				info = {
					name = "Defiance",
					ranks = 3,
					column = 4,
					icon = 132347,
					row = 3,
					tips = "Increases the threat generated by your attacks by %d%% while in Defensive Stance and increases your expertise by %d.",
					tipValues = {{5, 2}, {10, 4}, {15, 6}},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Sunder Armor",
					ranks = 3,
					column = 1,
					icon = 132363,
					row = 4,
					tips = "Reduces the cost of your Sunder Armor and Devastate abilities by %d rage point.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [10]
			{
				info = {
					name = "Improved Disarm",
					ranks = 3,
					column = 2,
					icon = 132343,
					row = 4,
					tips = "Increases the duration of your Disarm ability by %d secs.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [11]
			{
				info = {
					name = "Improved Taunt",
					ranks = 2,
					column = 3,
					icon = 136080,
					row = 4,
					tips = "Reduces the cooldown of your Taunt ability by %d sec.",
					tipValues = {{1}, {2}},
				},
			}, -- [12]
			{
				info = {
					name = "Improved Shield Wall",
					ranks = 2,
					column = 1,
					icon = 132362,
					row = 5,
					tips = "Increases the effect duration of your Shield Wall ability by %d secs.",
					tipValues = {{3}, {5}},
				},
			}, -- [13]
			{
				info = {
					ranks = 1,
					name = "Concussion Blow",
					icon = 132325,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Stuns the opponent for 5 sec.",
				},
			}, -- [14]
			{
				info = {
					name = "Improved Shield Bash",
					ranks = 2,
					column = 3,
					icon = 132357,
					row = 5,
					tips = "Gives your Shield Bash ability a %d%% chance to silence the target for 3 sec.",
					tipValues = {{50}, {100}},
				},
			}, -- [15]
			{
				info = {
					name = "Shield Mastery",
					ranks = 3,
					column = 1,
					icon = 132360,
					row = 6,
					tips = "Increases the amount of damage absorbed by your shield by %d%%.",
					tipValues = {{10}, {20}, {30}},
				},
			}, -- [16]
			{
				info = {
					name = "One-Handed Weapon Specialization",
					ranks = 5,
					column = 3,
					icon = 135321,
					row = 6,
					tips = "Increases physical damage you deal when a one-handed melee weapon is equipped by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
				},
			}, -- [17]
			{
				info = {
					name = "Improved Defensive Stance",
					ranks = 3,
					column = 1,
					icon = 132341,
					row = 7,
					tips = "Reduces all spell damage taken while in Defensive Stance by %d%%.",
					tipValues = {{2}, {4}, {6}},
				},
			}, -- [18]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Shield Slam",
					icon = 134951,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Slam the target with your shield, causing 225 to 235 damage, modified by your shield block value, and dispels 1 magic effect on the target.  Also causes a high amount of threat.",
				},
			}, -- [19]
			{
				info = {
					name = "Focused Rage",
					ranks = 3,
					column = 3,
					icon = 132345,
					row = 7,
					tips = "Reduces the rage cost of your offensive abilities by %d.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [20]
			{
				info = {
					name = "Vitality",
					ranks = 5,
					column = 2,
					icon = 133123,
					row = 8,
					tips = "Increases your total Stamina by %d%% and your total Strength by %d%%.",
					tipValues = {{1, 2}, {2, 4}, {3, 6}, {4, 8}, {5, 10}},
				},
			}, -- [21]
			{
				info = {
					ranks = 1,
					name = "Devastate",
					icon = 135291,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "Sunder the target's armor causing the Sunder Armor effect.  In addition, causes 50% of weapon damage plus 15 for each application of Sunder Armor on the target.  The Sunder Armor effect can stack up to 5 times.",
				},
			}, -- [22]
		},
		info = {
			name = "Protection",
			background = "WarriorProtection",
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