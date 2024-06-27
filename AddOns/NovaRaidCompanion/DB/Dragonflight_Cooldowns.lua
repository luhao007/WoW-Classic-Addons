---There is no retail of this addon, probably never will be.
---This is just copy pasted from wrath for now basically.


----------------------------------
---Nova Raid Companion Cooldowns--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isRetail) then
	return;
end
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

--{cooldownAdjust} is spells that cooldown time can be changed by talents.
--{talentOnly} is for spells that can only be trained by getting talents (like mana tide).
NRC.cooldowns = {
	--Druid.
	["Rebirth"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_reincarnation",
		cooldown = 600,
		minLevel = 20,
		spellIDs = {
			[20484] = "Rebirth", --Rank 1.
			[20739] = "Rebirth", --Rank 2.
			[20742] = "Rebirth", --Rank 3.
			[20747] = "Rebirth", --Rank 4.
			[20748] = "Rebirth", --Rank 5.
			[26994] = "Rebirth", --Rank 6.
			[48477] = "Rebirth", --Rank 7.
		},
	},
	["Innervate"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_lightning",
		cooldown = 180,
		minLevel = 40,
		spellIDs = {
			[29166] = "Innervate", --Rank 1.
		},
	},
	["Tranquility"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_tranquility",
		cooldown = 480,
		minLevel = 30,
		spellIDs = {
			[740] = "Tranquility", --Rank 1.
			[8918] = "Tranquility", --Rank 2.
			[9862] = "Tranquility", --Rank 3.
			[9863] = "Tranquility", --Rank 4.
			[26983] = "Tranquility", --Rank 5.
			[48446] = "Tranquility", --Rank 6.
			[48447] = "Tranquility", --Rank 7.
		},
	},
	["Survival Instincts"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_druid_tigersroar",
		cooldown = 60,
		minLevel = 45,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 7,
		},
		spellIDs = {
			[61336] = "Survival Instincts", --Rank 1.
		},
	},
	["Challenging Roar"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_druid_challangingroar",
		cooldown = 180,
		minLevel = 28,
		spellIDs = {
			[5209] = "Challenging Roar", --Rank 1.
		},
	},
	["Starfall"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_druid_starfall",
		cooldown = 90,
		minLevel = 60,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 28,
		},
		spellIDs = {
			[48505] = "Starfall", --Rank 1.
			[53199] = "Starfall", --Rank 2.
			[53200] = "Starfall", --Rank 3.
			[53201] = "Starfall", --Rank 4.
		},
	},
	--Hunter.
	["Misdirection"] = {
		class = "HUNTER",
		icon = "Interface\\Icons\\ability_hunter_misdirection",
		cooldown = 30,
		minLevel = 70,
		spellIDs = {
			[34477] = "Misdirection", --Rank 1.
		},
	},
	--Mage.
	["Evocation"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_nature_purge",
		cooldown = 240,
		minLevel = 20,
		spellIDs = {
			[12051] = "Evocation", --Rank 1.
		},
	},
	["Ice Block"] = { --Casting cold snap needs to reset this cooldown, fix later.
		class = "MAGE",
		icon = "Interface\\Icons\\spell_frost_frost",
		cooldown = 300,
		minLevel = 30,
		spellIDs = {
			[45438] = "Ice Block", --Rank 1.
		},
	},
	["Invisibility"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\ability_mage_invisibility",
		cooldown = 180,
		minLevel = 68,
		spellIDs = {
			[66] = "Invisibility", --Rank 1.
		},
	},
	--Paladin.
	["Divine Intervention"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_nature_timestop",
		cooldown = 600,
		minLevel = 30,
		spellIDs = {
			[19752] = "Divine Intervention", --Rank 1.
		},
	},
	["Divine Shield"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_divineintervention",
		cooldown = 300,
		minLevel = 34,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 14,
			[1] = 30, --Seconds to reduce by for each talent trained.
			[2] = 60,
		},
		spellIDs = {
			[642] = "Divine Shield", --Rank 1.
			--[1020] = "Divine Shield", --Rank 2. --Rank 2 was removed in wrath?
		},
	},
	["Divine Protection"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_restoration",
		cooldown = 180,
		minLevel = 6,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 14,
			[1] = 30, --Seconds to reduce by for each talent trained.
			[2] = 60,
		},
		spellIDs = {
			[498] = "Divine Shield", --Rank 1.
		},
	},
	["Lay on Hands"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_layonhands",
		cooldown = 1200,
		minLevel = 10,
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 8,
			[1] = 120,
			[2] = 240,
		},
		spellIDs = {
			[633] = "Lay on Hands", --Rank 1.
			[2800] = "Lay on Hands", --Rank 2.
			[10310] = "Lay on Hands", --Rank 3.
			[27154] = "Lay on Hands", --Rank 4.
			[48788] = "Lay on Hands", --Rank 5.
		},
	},
	["Hand of Protection"] = { --Changed from Blessing of Protection to Hand of Proection in wrath.
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofprotection",
		cooldown = 300,
		minLevel = 10,
		title = "Hand of Prot",
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 4,
			[1] = 60, --Seconds to reduce by for each talent trained.
			[2] = 120,
		},
		spellIDs = {
			[1022] = "Hand of Protection", --Rank 1.
			[5599] = "Hand of Protection", --Rank 2.
			[10278] = "Hand of Protection", --Rank 3.
			[66009] = "Hand of Protection", --Rank 3 too? Not sure wy 2 spellIDs.
		},
	},
	["Divine Sacrifice"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_powerwordbarrier",
		cooldown = 120,
		minLevel = 20,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 6,
		},
		spellIDs = {
			[64205] = "Divine Sacrifice", --Rank 1.
		},
	},
	["Divine Guardian"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_powerwordbarrier",
		cooldown = 120,
		minLevel = 20,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 9,
		},
		spellIDs = {
			[70940] = "Divine Guardian", --Rank 1.
		},
	},
	["Aura Mastery"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_auramastery",
		cooldown = 120,
		minLevel = 20,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 6,
		},
		spellIDs = {
			[31821] = "Aura Mastery", --Rank 1.
		},
	},
	["Hand of Sacrifice"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofsacrifice",
		cooldown = 120,
		minLevel = 45,
		title = "Hand of Sac",
		spellIDs = {
			[6940] = "Hand of Sacrifice", --Rank 1.
		},
	},
	["Hand of Salvation"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofsalvation",
		cooldown = 120,
		minLevel = 26,
		title = "Hand of Salv",
		spellIDs = {
			[1038] = "Hand of Salvation", --Rank 1.
		},
	},
	--Priest.
	["Fear Ward"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_excorcism",
		cooldown = 180,
		minLevel = 20,
		spellIDs = {
			[6346] = "Fear Ward", --Rank 1.
		},
	},
	["Shadowfiend"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_shadow_shadowfiend",
		cooldown = 300,
		minLevel = 66,
		spellIDs = {
			[34433] = "Shadowfiend", --Rank 1.
		},
	},
	["Psychic Scream"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_shadow_psychicscream",
		cooldown = 30,
		minLevel = 14,
		spellIDs = {
			[8122] = "Psychic Scream", --Rank 1.
			[8124] = "Psychic Scream", --Rank 2.
			[10888] = "Psychic Scream", --Rank 3.
			[10890] = "Psychic Scream", --Rank 4.
		},
	},
	["Power Infusion"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_powerinfusion",
		cooldown = 120,
		minLevel = 39,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 19,
		},
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 23,
			[1] = 12,
			[2] = 24,
		},
		spellIDs = {
			[10060] = "Power Infusion", --Rank 1.
		},
	},
	["Pain Suppression"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_painsupression",
		cooldown = 180,
		minLevel = 49,
		name = "Pain Sup",
		talentOnly = {
			tabIndex = 1,
			talentIndex = 25,
		},
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 23,
			[1] = 18,
			[2] = 36,
		},
		spellIDs = {
			[33206] = "Pain Suppression", --Rank 1.
		},
	},
	["Divine Hymn"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_divinehymn",
		cooldown = 480,
		minLevel = 80,
		spellIDs = {
			[64843] = "Divine Hymn", --Rank 1.
		},
	},
	["Hymn of Hope"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_symbolofhope",
		cooldown = 360,
		minLevel = 80,
		spellIDs = {
			[64901] = "Hymn of Hope", --Rank 1.
		},
	},
	["Guardian Spirit"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_guardianspirit",
		cooldown = 180,
		minLevel = 60,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 27,
		},
		spellIDs = {
			[47788] = "Guardian Spirit", --Rank 1.
		},
	},
	--Rogue.
	["Blind"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_mindsteal",
		cooldown = 180,
		minLevel = 34,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 7,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[2094] = "Blind", --Rank 1.
		},
	},
	["Vanish"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_vanish",
		cooldown = 180,
		minLevel = 22,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 7,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[1856] = "Vanish", --Rank 1.
			[1857] = "Vanish", --Rank 2.
			[26889] = "Vanish", --Rank 3.
		},
	},
	["Evasion"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_shadowward",
		cooldown = 180,
		minLevel = 8,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 7,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[5277] = "Evasion", --Rank 1.
			[26669] = "Evasion", --Rank 2.
		},
	},
	["Distract"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_rogue_distract",
		cooldown = 30,
		minLevel = 22,
		spellIDs = {
			[1725] = "Distract", --Rank 1.
		},
	},
	["Tricks of the Trade"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_rogue_tricksofthetrade",
		cooldown = 30,
		minLevel = 75,
		title = "Tricks",
		spellIDs = {
			[57934] = "Tricks of the Trade", --Rank 1.
		},
	},
	--[[["Cloak of Shadow"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_nethercloak",
		cooldown = 90,
		minLevel = 66,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 7,
			[1] = 15,
			[2] = 30,
		},
		spellIDs = {
			[31224] = "Evasion", --Rank 1.
		},
	},]]
	--Shaman.
	["Earth Elemental"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_nature_earthelemental_totem",
		cooldown = 600,
		minLevel = 66,
		spellIDs = {
			[2062] = "Earth Elemental Totem", --Rank 1.
		},
	},
	["Fire Elemental"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_fire_elemental_totem",
		cooldown = 600,
		minLevel = 68,
		spellIDs = {
			[2894] = "Fire Elemental Totem", --Rank 1.
		},
	},
	["Reincarnation"] = {
		--This can't be tracked via combat log.
		--We just use rank 1 spellID for our own tracking purposes.
		class = "SHAMAN",
		icon = "Interface\\Icons\\inv_jewelry_talisman_06", --Use ahnk icon so it doesn't look like druid rebirth.
		cooldown = 1800,
		minLevel = 30,
		--[[cooldownAdjust = { --Reincarnation talents are detected in other ways.
			tabIndex = 3,
			talentIndex = 3,
			[1] = 420,
			[2] = 900,
		},]]
		spellIDs = {
			[20608] = "Reincarnation", --Rank 1.
		},
	},
	["Mana Tide"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_frost_summonwaterelemental",
		cooldown = 300,
		minLevel = 39,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 17,
		},
		spellIDs = {
			[16190] = "Mana Tide", --Rank 1.
		},
	},
	--Warlock.
	["Soulstone"] = { --No cooldown in wrath?
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_soulgem",
		cooldown = 900,
		minLevel = 18,
		spellIDs = {
			[20707] = "Minor Soulstone", --Rank 1.
			[20762] = "Lesser Soulstone", --Rank 2.
			[20763] = "Soulstone", --Rank 3.
			[20764] = "Greater Soulstone", --Rank 4.
			[20765] = "Major Soulstone", --Rank 5.
			[27239] = "Master Soulstone", --Rank 6.
			[47883] = "Master Soulstone", --Rank 7.
		},
	},
	["Soulshatter"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_arcane_arcane01",
		cooldown = 180,
		minLevel = 66,
		spellIDs = {
			[29858] = "Soulshatter", --Rank 1.
		},
	},
	["Death Coil"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_deathcoil",
		cooldown = 120,
		minLevel = 42,
		spellIDs = {
			[6789] = "Death Coil", --Rank 1.
			[17925] = "Death Coil", --Rank 2.
			[17926] = "Death Coil", --Rank 3.
			[27223] = "Death Coil", --Rank 4.
			[47859] = "Death Coil", --Rank 5.
			[47860] = "Death Coil", --Rank 6.
		},
	},
	--[[["Ritual of Souls"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_shadesofdarkness",
		cooldown = 300,
		minLevel = 68,
		spellIDs = {
			[29893] = "Ritual of Souls", --Rank 1.
		},
	},]]
	--Warrior.
	["Challenging Shout"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_bullrush",
		cooldown = 180,
		minLevel = 26,
		spellIDs = {
			[1161] = "Challenging Shout", --Rank 1.
		},
	},
	["Intimidating Shout"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_golemthunderclap",
		cooldown = 120,
		minLevel = 22,
		spellIDs = {
			[5246] = "Intimidating Shout", --Rank 1.
		},
	},
	["Mocking Blow"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_punishingblow",
		cooldown = 60,
		minLevel = 16,
		spellIDs = { --Only 1 rank in wrath?
			[694] = "Mocking Blow", --Rank 1.
			--[7400] = "Mocking Blow", --Rank 2.
			--[7402] = "Mocking Blow", --Rank 3.
			--[20559] = "Mocking Blow", --Rank 4.
			--[20560] = "Mocking Blow", --Rank 5.
			--[25266] = "Mocking Blow", --Rank 6.
		},
	},
	["Recklessness"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_criticalstrike",
		cooldown = 300,
		minLevel = 50,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 13,
			[1] = 30,
			[2] = 60,
		},
		cooldownAdjust2 = {
			tabIndex = 2,
			talentIndex = 18,
			[1] = 33, --11%
			[2] = 66, --22%
			[3] = 99, --33%
		},
		spellIDs = {
			[1719] = "Recklessness", --Rank 1.
		},
	},
	["Shield Wall"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_shieldwall",
		cooldown = 300,
		minLevel = 28,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 13,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[871] = "Shield Wall", --Rank 1.
		},
	},
	["Bladestorm"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_bladestorm",
		cooldown = 90,
		minLevel = 60,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 31,
		},
		spellIDs = {
			[46924] = "Bladestorm", --Rank 1.
		},
	},
	["Shattering Throw"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_shatteringthrow",
		cooldown = 300,
		minLevel = 71,
		spellIDs = {
			[64382] = "Shattering Throw", --Rank 1.
		},
	},
	
	--Neck group buffs.
	--These only show if someone is on cooldown.
	--[[["Neck Buffs"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_28",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31033] = "Eye of the Night", --34 SP.
			[31035] = "Chain of the Twilight Owl", --2% crit.
			[31025] = "Braided Eternium Chain", --28 crit rating.
			[31023] = "Thick Felsteel Necklace", --20 stam.
			[31024] = "Living Ruby Pendant", --6 HPS.
			[31026] = "Embrace of the Dawn", --10 stats.
			--[0] = "Pendant of Frozen Flame", --900-2700 fire absorb.
			--[0] = "Pendant of Thawing", --900-2700 frost absorb.
			--[0] = "Pendant of Shadow's End", --900-2700 shadow absorb.
			--[0] = "Pendant of the Null Rune", --900-2700 arcane absorb.
			--[0] = "Pendant of Withering", --900-2700 nature absorb.
		},
		color = "FF9CD6DE"
	},]]
	["NeckSP"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_28",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31033] = "Eye of the Night", --34 SP.
		},
		color = "FF9CD6DE",
		title = "Neck (34 SP)",
	},
	["NeckCrit"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_ahnqiraj_02",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31035] = "Chain of the Twilight Owl", --2% crit.
		},
		color = "FF9CD6DE",
		title = "Neck (2% Crit)",
	},
	["NeckCritRating"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_07",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31025] = "Braided Eternium Chain", --28 crit rating.
		},
		color = "FF9CD6DE",
		title = "Neck (28 Crit)",
	},
	["NeckStam"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_17",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31023] = "Thick Felsteel Necklace", --20 stam.
		},
		color = "FF9CD6DE",
		title = "Neck (20 Stam)",
	},
	["NeckHP5"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_15",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31024] = "Living Ruby Pendant", --6 HPS.
		},
		color = "FF9CD6DE",
		title = "Neck (6 HP5)",
	},
	["NeckStats"] = {
		class = "ALL",
		icon = "Interface\\Icons\\inv_jewelry_necklace_29naxxramas",
		cooldown = 3600,
		minLevel = 70,
		spellIDs = {
			[31026] = "Embrace of the Dawn", --10 stats.
		},
		color = "FF9CD6DE",
		title = "Neck (10 Stats)",
	},
	--Used for testing.
	--[[["Fel Armor"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_felarmour",
		cooldown = 30,
		minLevel = 1,
		spellIDs = {
			[28176] = "Fel Armor", --Rank 1.
			[28189] = "Fel Armor", --Rank 2.
		},
	},]]
	--[[["Arcane Intellect"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_holy_magicalsentry",
		cooldown = 30,
		minLevel = 1,
		spellIDs = {
			[10157] = "Arcane Intellect", --Rank 5.
		},
		--onlyLoadWhenUsed = true,
	},]]
	
	---New in wrath.
	
	--Death Knight.
	["Army of the Dead"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_deathknight_armyofthedead",
		cooldown = 600,
		minLevel = 80,
		title = "Army",
		spellIDs = {
			[42650] = "Army of the Dead", --Rank 1.
		},
	},
	["Icebound Fortitude"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_deathknight_iceboundfortitude",
		cooldown = 120,
		minLevel = 62,
		spellIDs = {
			[48792] = "Icebound Fortitude", --Rank 1.
		},
	},
	["Anti Magic Zone"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_deathknight_antimagiczone",
		cooldown = 120,
		minLevel = 40,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 22,
		},
		spellIDs = {
			[51052] = "Anti-Magic Zone", --Rank 1.
		},
	},
	["Unholy Frenzy"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_deathknight_bladedarmor",
		cooldown = 180,
		minLevel = 40,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 19,
		},
		spellIDs = {
			[49016] = "Unholy Frenzy", --Rank 1.
		},
	},
	["Vampiric Blood"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_shadow_lifedrain",
		cooldown = 60,
		minLevel = 45,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 23,
		},
		spellIDs = {
			[55233] = "Vampiric Blood", --Rank 1.
		},
	},
	["Anti Magic Shield"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_shadow_antimagicshell",
		cooldown = 45,
		minLevel = 68,
		spellIDs = {
			[48707] = "Anti-Magic Shield", --Rank 1.
		},
	},
};