----------------------------------
---Nova Raid Companion Cooldowns--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isCata) then
	return;
end
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

--{cooldownAdjust} is spells that cooldown time can be changed by talents.
--{talentOnly} is for spells that can only be trained by getting talents (like mana tide).
--If there are percentage cooldown reductions on top of a regular seconds reduction talent then the percentage should be in slot 2 "cooldownAdjust2".
--Someday I need to change all these icons to ids..
NRC.cooldowns = {
	--Druid.
	["Rebirth"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_reincarnation",
		cooldown = 600,
		minLevel = 20,
		spellIDs = {
			[20484] = "Rebirth", --Rank 1.
		},
	},
	["Innervate"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_lightning",
		cooldown = 180,
		minLevel = 28,
		spellIDs = {
			[29166] = "Innervate", --Rank 1.
		},
	},
	["Tranquility"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_tranquility",
		cooldown = 480,
		minLevel = 68,
		spellIDs = {
			[740] = "Tranquility", --Rank 1.
		},
	},
	["Survival Instincts"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_druid_tigersroar",
		cooldown = 180,
		minLevel = 47,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 16,
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
		minLevel = 67,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 20,
		},
		spellIDs = {
			[48505] = "Starfall", --Rank 1.
		},
	},
	["Barkskin"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_stoneclawtotem",
		cooldown = 60,
		minLevel = 58,
		spellIDs = {
			[22812] = "Barkskin", --Rank 1.
		},
	},
	["Stampeding Roar"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_druid_stamedingroar",
		cooldown = 120,
		minLevel = 83,
		spellIDs = {
			[77764] = "Stampeding Roar", --Cat form.
			[77761] = "Stampeding Roar", --Bear form.
		},
	},
	--Hunter.
	["Misdirection"] = {
		class = "HUNTER",
		icon = "Interface\\Icons\\ability_hunter_misdirection",
		cooldown = 30,
		minLevel = 76,
		spellIDs = {
			[34477] = "Misdirection", --Rank 1.
		},
	},
	--Mage.
	["Evocation"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_nature_purge",
		cooldown = 240,
		minLevel = 12,
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
		minLevel = 78,
		spellIDs = {
			[66] = "Invisibility", --Rank 1.
		},
	},
	["Time Warp"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\ability_mage_timewarp",
		cooldown = 300,
		minLevel = 85,
		spellIDs = {
			[80353] = "Time Warp", --Rank 1.
		},
	},
	--Paladin.
	["Divine Shield"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_divineintervention",
		cooldown = 300,
		minLevel = 48,
		spellIDs = {
			[642] = "Divine Shield", --Rank 1.
		},
	},
	["Divine Protection"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_restoration",
		cooldown = 60,
		minLevel = 30,
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 17,
			[1] = 15, --Seconds to reduce by for each talent trained.
			[2] = 30,
		},
		spellIDs = {
			[498] = "Divine Protection", --Rank 1.
		},
	},
	["Lay on Hands"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_layonhands",
		cooldown = 600,
		minLevel = 16,
		spellIDs = {
			[633] = "Lay on Hands", --Rank 1.
		},
	},
	["Hand of Protection"] = { --Changed from Blessing of Protection to Hand of Proection in wrath.
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofprotection",
		cooldown = 300,
		minLevel = 18,
		title = "Hand of Prot",
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 60, --Seconds to reduce by for each talent trained.
			[2] = 120,
		},
		spellIDs = {
			[1022] = "Hand of Protection", --Rank 1.
		},
	},
	["Divine Guardian"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_powerwordbarrier",
		cooldown = 120,
		minLevel = 47,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 17,
		},
		spellIDs = {
			[70940] = "Divine Guardian", --Rank 1.
		},
	},
	["Aura Mastery"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_auramastery",
		cooldown = 120,
		minLevel = 47,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 16,
		},
		spellIDs = {
			[31821] = "Aura Mastery", --Rank 1.
		},
	},
	["Hand of Sacrifice"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofsacrifice",
		cooldown = 120,
		minLevel = 80,
		title = "Hand of Sac",
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 17,
			[1] = 15, --Seconds to reduce by for each talent trained.
			[2] = 30,
		},
		cooldownAdjust2 = {
			tabIndex = 1,
			talentIndex = 19,
			[1] = 12, --10%.
			[2] = 24, --20%.
		},
		spellIDs = {
			[6940] = "Hand of Sacrifice", --Rank 1.
		},
	},
	["Hand of Salvation"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofsalvation",
		cooldown = 120,
		minLevel = 66,
		title = "Hand of Salv",
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 19,
			[1] = 12, --10%.
			[2] = 24, --20%.
		},
		spellIDs = {
			[1038] = "Hand of Salvation", --Rank 1.
		},
	},
	["Hand of Freedom"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofvalor",
		cooldown = 25,
		minLevel = 52,
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 19,
			[1] = 2, --10% ish.
			[2] = 5, --20%.
		},
		spellIDs = {
			[1044] = "Hand of Freedom", --Rank 1.
		},
	},
	--Priest.
	["Fear Ward"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_excorcism",
		cooldown = 180,
		minLevel = 54,
		spellIDs = {
			[6346] = "Fear Ward", --Rank 1.
		},
	},
	["Shadowfiend"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_shadow_shadowfiend",
		cooldown = 300,
		minLevel = 66,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 3,
			[1] = 60, --Seconds to reduce by for each talent trained.
			[2] = 120,
		},
		spellIDs = {
			[34433] = "Shadowfiend", --Rank 1.
		},
	},
	["Psychic Scream"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_shadow_psychicscream",
		cooldown = 30,
		minLevel = 12,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 2, --Seconds to reduce by for each talent trained.
			[2] = 4,
		},
		spellIDs = {
			[8122] = "Psychic Scream", --Rank 1.
		},
	},
	["Power Infusion"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_powerinfusion",
		cooldown = 180,
		minLevel = 27,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 9,
		},
		spellIDs = {
			[10060] = "Power Infusion", --Rank 1.
		},
	},
	["Pain Suppression"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_painsupression",
		cooldown = 180,
		minLevel = 47,
		name = "Pain Sup",
		talentOnly = {
			tabIndex = 1,
			talentIndex = 17,
		},
		spellIDs = {
			[33206] = "Pain Suppression", --Rank 1.
		},
	},
	["Divine Hymn"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_divinehymn",
		cooldown = 480,
		minLevel = 78,
		spellIDs = {
			[64843] = "Divine Hymn", --Rank 1.
		},
	},
	["Hymn of Hope"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_symbolofhope",
		cooldown = 360,
		minLevel = 64,
		spellIDs = {
			[64901] = "Hymn of Hope", --Rank 1.
		},
	},
	["Guardian Spirit"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_guardianspirit",
		cooldown = 180,
		minLevel = 67,
		talentOnly = {
			tabIndex = 2,
			talentIndex = 21,
		},
		spellIDs = {
			[47788] = "Guardian Spirit", --Rank 1.
		},
	},
	["Leap of Faith"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\priest_spell_leapoffaith_a",
		cooldown = 90,
		minLevel = 85,
		spellIDs = {
			[73325] = "Leap of Faith", --Rank 1.
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
			talentIndex = 4,
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
		minLevel = 24,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[1856] = "Vanish", --Rank 1.
		},
	},
	["Evasion"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_shadowward",
		cooldown = 180,
		minLevel = 9,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 7,
			[1] = 30,
			[2] = 60,
		},
		spellIDs = {
			[5277] = "Evasion", --Rank 1.
		},
	},
	["Distract"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_rogue_distract",
		cooldown = 30,
		minLevel = 28,
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
		--Filthy Tricks talent cooldown reduction removed in cata.
		spellIDs = {
			[57934] = "Tricks of the Trade", --Rank 1.
		},
	},
	["Cloak of Shadow"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_nethercloak",
		cooldown = 120,
		minLevel = 58,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 15,
			[2] = 50,
		},
		spellIDs = {
			[31224] = "Cloak of Shadow", --Rank 1.
		},
	},
	["Smoke Bomb"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_rogue_smoke",
		cooldown = 180,
		minLevel = 85,
		spellIDs = {
			[76577] = "Smoke Bomb", --Rank 1.
		},
	},
	--Shaman.
	["Earth Elemental"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_nature_earthelemental_totem",
		cooldown = 600,
		minLevel = 56,
		spellIDs = {
			[2062] = "Earth Elemental Totem", --Rank 1.
		},
	},
	["Fire Elemental"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_fire_elemental_totem",
		cooldown = 600,
		minLevel = 66,
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
		cooldown = 180,
		minLevel = 47,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 15,
		},
		spellIDs = {
			[16190] = "Mana Tide", --Rank 1.
		},
	},
	["Spiritwalker Grace"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_shaman_spiritwalkersgrace",
		cooldown = 180,
		minLevel = 85,
		spellIDs = {
			[79206] = "Spiritwalker's Grace", --Rank 1.
		},
	},
	--Warlock.
	["Soulstone"] = { --No cooldown in wrath?
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_soulgem",
		cooldown = 900,
		minLevel = 18,
		spellIDs = { --"Use item" spell ID of the Soulstone item in bag.
			[20707] = "Minor Soulstone", --Rank 1.
		},
	},
	["Soulshatter"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_arcane_arcane01",
		cooldown = 120,
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
		minLevel = 46,
		spellIDs = {
			[1161] = "Challenging Shout", --Rank 1.
		},
	},
	["Intimidating Shout"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_golemthunderclap",
		cooldown = 120,
		minLevel = 42,
		spellIDs = {
			[5246] = "Intimidating Shout", --Rank 1.
		},
	},
	["Recklessness"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_criticalstrike",
		cooldown = 300,
		minLevel = 64,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 17,
			[1] = 30, --10%
			[2] = 60, --20%
		},
		spellIDs = {
			[1719] = "Recklessness", --Rank 1.
		},
	},
	["Shield Wall"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_shieldwall",
		cooldown = 300,
		minLevel = 48,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 5,
			[1] = 60,
			[2] = 120,
			[3] = 180,
		},
		spellIDs = {
			[871] = "Shield Wall", --Rank 1.
		},
	},
	["Bladestorm"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_bladestorm",
		cooldown = 90,
		minLevel = 67,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 20,
		},
		spellIDs = {
			[46924] = "Bladestorm", --Rank 1.
		},
	},
	["Shattering Throw"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_shatteringthrow",
		cooldown = 300,
		minLevel = 74,
		spellIDs = {
			[64382] = "Shattering Throw", --Rank 1.
		},
	},
	["Last Stand"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\spell_holy_ashestoashes",
		cooldown = 180,
		minLevel = 27,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 8,
		},
		spellIDs = {
			[12975] = "Last Stand", --Rank 1.
		},
	},
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
		cooldown = 180,
		minLevel = 62,
		spellIDs = {
			[48792] = "Icebound Fortitude", --Rank 1.
		},
	},
	["Anti Magic Zone"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_deathknight_antimagiczone",
		cooldown = 120,
		minLevel = 47,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 15,
		},
		spellIDs = {
			[51052] = "Anti-Magic Zone", --Rank 1.
		},
	},
	["Unholy Frenzy"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_shadow_unholyfrenzy",
		cooldown = 180,
		minLevel = 40,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 8,
		},
		spellIDs = {
			[49016] = "Unholy Frenzy", --Rank 1.
		},
	},
	["Vampiric Blood"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_shadow_lifedrain",
		cooldown = 60,
		minLevel = 47,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 17,
		},
		spellIDs = {
			[55233] = "Vampiric Blood", --Rank 1.
		},
	},
	["Anti Magic Shell"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_shadow_antimagicshell",
		cooldown = 45,
		minLevel = 68,
		spellIDs = {
			[48707] = "Anti-Magic Shell", --Rank 1.
		},
	},
	["Dark Simulacrum"] = {
		class = "DEATHKNIGHT",
		icon = "Interface\\Icons\\spell_holy_consumemagic",
		cooldown = 60,
		minLevel = 85,
		spellIDs = {
			[77606] = "Dark Simulacrum", --Rank 1.
		},
	},
};

--Add faction specific spells.
if (NRC.faction == "Alliance") then
	NRC.cooldowns["Heroism"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\ability_shaman_heroism",
		cooldown = 300,
		minLevel = 70,
		spellIDs = {
			[32182] = "Heroism", --Rank 1.
		},
	};
else
	NRC.cooldowns["Bloodlust"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_nature_bloodlust",
		cooldown = 300,
		minLevel = 70,
		spellIDs = {
			[2825] = "Bloodlust", --Rank 1.
		},
	};
end