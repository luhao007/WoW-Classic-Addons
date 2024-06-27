----------------------------------
---Nova Raid Companion Cooldowns--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isClassic) then
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
		cooldown = 1800,
		minLevel = 20,
		spellIDs = {
			[20484] = "Rebirth", --Rank 1.
			[20739] = "Rebirth", --Rank 2.
			[20742] = "Rebirth", --Rank 3.
			[20747] = "Rebirth", --Rank 4.
			[20748] = "Rebirth", --Rank 5.
		},
	},
	["Innervate"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_lightning",
		cooldown = 360,
		minLevel = 40,
		spellIDs = {
			[29166] = "Innervate", --Rank 1.
		},
	},
	["Tranquility"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\spell_nature_tranquility",
		cooldown = 600,
		minLevel = 30,
		spellIDs = {
			[740] = "Tranquility", --Rank 1.
			[8918] = "Tranquility", --Rank 2.
			[9862] = "Tranquility", --Rank 3.
			[9863] = "Tranquility", --Rank 4.
		},
	},
	--Hunter.
	--No misdirection in classic.
	--Mage.
	["Evocation"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_nature_purge",
		cooldown = 480,
		minLevel = 20,
		spellIDs = {
			[12051] = "Evocation", --Rank 1.
		},
	},
	["Ice Block"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_frost_frost",
		cooldown = 300,
		minLevel = 30,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 14,
		},
		spellIDs = {
			[11958] = "Ice Block", --Rank 1.
		},
	},
	--Paladin.
	["Divine Intervention"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_nature_timestop",
		cooldown = 3600,
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
		spellIDs = {
			[642] = "Divine Shield", --Rank 1.
			[1020] = "Divine Shield", --Rank 2.
		},
	},
	["Lay on Hands"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_layonhands",
		cooldown = 3600,
		minLevel = 10,
		cooldownAdjust = {
			tabIndex = 1,
			talentIndex = 7,
			[1] = 600,
			[2] = 1200,
		},
		spellIDs = {
			[633] = "Lay on Hands", --Rank 1.
			[2800] = "Lay on Hands", --Rank 2.
			[10310] = "Lay on Hands", --Rank 3.
		},
	},
	["Blessing of Protection"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_sealofprotection",
		cooldown = 300,
		minLevel = 10,
		title = "BoP",
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 4,
			[1] = 60,
			[2] = 120,
		},
		spellIDs = {
			[1022] = "Blessing of Protection", --Rank 1.
			[5599] = "Blessing of Protection", --Rank 2.
			[10278] = "Blessing of Protection", --Rank 3.
		},
	},
	--Priest.
	["Fear Ward"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_excorcism",
		cooldown = 30,
		minLevel = 20,
		spellIDs = {
			[6346] = "Fear Ward", --Rank 1.
		},
	},
	["Psychic Scream"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_shadow_psychicscream",
		cooldown = 30,
		minLevel = 14,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 6,
			[1] = 2,
			[2] = 4,
		},
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
		cooldown = 180,
		minLevel = 39,
		talentOnly = {
			tabIndex = 1,
			talentIndex = 15,
		},
		spellIDs = {
			[10060] = "Power Infusion", --Rank 1.
		},
	},
	--Rogue (need to add talent reduction checks later).
	["Blind"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_mindsteal",
		cooldown = 300,
		minLevel = 34,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 45,
			[2] = 90,
		},
		spellIDs = {
			[2094] = "Blind", --Rank 1.
		},
	},
	["Vanish"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_vanish",
		cooldown = 300,
		minLevel = 22,
		cooldownAdjust = {
			tabIndex = 3,
			talentIndex = 4,
			[1] = 45,
			[2] = 90,
		},
		spellIDs = {
			[1856] = "Vanish", --Rank 1.
			[1857] = "Vanish", --Rank 2.
		},
	},
	["Evasion"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\spell_shadow_shadowward",
		cooldown = 300,
		minLevel = 8,
		cooldownAdjust = {
			tabIndex = 2,
			talentIndex = 7,
			[1] = 45,
			[2] = 90,
		},
		spellIDs = {
			[5277] = "Evasion", --Rank 1.
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
	--Shaman.
	["Reincarnation"] = {
		--This can't be tracked via combat log.
		--We just use rank 1 spellID for our own tracking purposes.
		class = "SHAMAN",
		icon = "Interface\\Icons\\inv_jewelry_talisman_06", --Use ahnk icon so it doesn't look like druid rebirth.
		cooldown = 3600,
		minLevel = 30,
		--[[cooldownAdjust = { --Reincarnation talents are detected in other ways.
			tabIndex = 3,
			talentIndex = 5,
			[1] = 600,
			[2] = 1200,
		},]]
		spellIDs = {
			[20608] = "Reincarnation", --Rank 1.
		},
	},
	["Mana Tide"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_frost_summonwaterelemental",
		cooldown = 300,
		minLevel = 40,
		talentOnly = {
			tabIndex = 3,
			talentIndex = 15,
		},
		spellIDs = {
			[16190] = "Mana Tide", --Rank 1.
			[17354] = "Mana Tide", --Rank 2.
			[17359] = "Mana Tide", --Rank 3.
		},
	},
	--Warlock.
	["Soulstone"] = {
		class = "WARLOCK",
		icon = "Interface\\Icons\\spell_shadow_soulgem",
		cooldown = 1800,
		minLevel = 18,
		spellIDs = {
			[20707] = "Minor Soulstone", --Rank 1.
			[20762] = "Lesser Soulstone", --Rank 2.
			[20763] = "Soulstone", --Rank 3.
			[20764] = "Greater Soulstone", --Rank 4.
			[20765] = "Major Soulstone", --Rank 5.
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
		},
	},
	--Warrior.
	["Challenging Shout"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_bullrush",
		cooldown = 600,
		minLevel = 26,
		spellIDs = {
			[1161] = "Challenging Shout", --Rank 1.
		},
	},
	["Intimidating Shout"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_golemthunderclap",
		cooldown = 180,
		minLevel = 22,
		spellIDs = {
			[5246] = "Intimidating Shout", --Rank 1.
		},
	},
	["Mocking Blow"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_punishingblow",
		cooldown = 120,
		minLevel = 16,
		spellIDs = {
			[694] = "Mocking Blow", --Rank 1.
			[7400] = "Mocking Blow", --Rank 2.
			[7402] = "Mocking Blow", --Rank 3.
			[20559] = "Mocking Blow", --Rank 4.
			[20560] = "Mocking Blow", --Rank 5.
		},
	},
	["Recklessness"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_criticalstrike",
		cooldown = 1800,
		minLevel = 50,
		spellIDs = {
			[1719] = "Recklessness", --Rank 1.
		},
	},
	["Shield Wall"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_shieldwall",
		cooldown = 1800,
		minLevel = 28,
		spellIDs = {
			[871] = "Shield Wall", --Rank 1.
		},
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
};

---SoD cast detect spells, mostly just runes that can't be inspected.
--No min level or class detection required for castDetect but minLevel still needs to exist as 1 to not caus errors.

if (not NRC.isSOD) then
	return;
end

--Add spells for SoD that we want to always show even if we don't know if they have the rune (becaus they should have).
NRC.cooldowns["Dispersion"] = {
	class = "PRIEST",
	icon = "Interface\\Icons\\spell_shadow_dispersion",
	cooldown = 120,
	minLevel = 1,
	isBook = true,
	spellIDs = {
		[425294] = "Dispersion", --Rune.
	},
};
NRC.cooldowns["Shadowfiend"] = {
	class = "PRIEST",
	icon = "Interface\\Icons\\spell_shadow_shadowfiend",
	cooldown = 300,
	minLevel = 21, --Min level to enter SM.
	isRune = true,
	spellIDs = {
		[401977] = "Shadowfiend", --Rune.
	},
};
	
--Add spells for SoD where maybe it doesn't matter if they have the rune and we only show the cooldown if we've seen them cast it.
NRC.castDetectCooldowns = {
	--Priest.
	["Pain Suppression"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_painsupression",
		cooldown = 120,
		minLevel = 1,
		name = "Pain Sup",
		isRune = true,
		spellIDs = {
			[402004] = "Pain Suppression", --Rune.
		},
	},
	--Druid.
	["Berserk"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_druid_berserk",
		cooldown = 180,
		minLevel = 1,
		isRune = true,
		spellIDs = {
			[417141] = "Berserk", --Rune.
		},
	},
	["Survival Instincts"] = {
		class = "DRUID",
		icon = "Interface\\Icons\\ability_mount_whitedirewolf",
		cooldown = 180,
		minLevel = 1,
		name = "Surv Ins",
		isRune = true,
		spellIDs = {
			[408024] = "Survival Instincts", --Rune.
		},
	},
	--Mage.
	["Icy Veins"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_frost_coldhearted",
		cooldown =180,
		minLevel = 1,
		isRune = true,
		spellIDs = {
			[425121] = "Icy Veins", --Rune.
		},
	},
	["Arcane Surge"] = {
		class = "MAGE",
		icon = "Interface\\Icons\\spell_arcane_arcanetorrent",
		cooldown = 120,
		minLevel = 1,
		isRune = true,
		spellIDs = {
			[425124] = "Arcane Surge", --Rune.
		},
	},
	--Paladin.
	["Divine Sacrifice"] = {
		class = "PALADIN",
		icon = "Interface\\Icons\\spell_holy_powerwordbarrier",
		cooldown = 120,
		minLevel = 1,
		name = "Div Sac",
		isRune = true,
		spellIDs = {
			[407804] = "Divine Sacrifice", --Rune.
		},
	},
	--Priest.
	["Power Word: Barrier"] = {
		class = "PRIEST",
		icon = "Interface\\Icons\\spell_holy_powerwordbarrier",
		cooldown = 180,
		minLevel = 1,
		name = "PW: Barrier",
		isRune = true,
		spellIDs = {
			[425207] = "Power Word: Barrier", --Rune.
		},
	},
	--Rogue.
	["Shadowstep"] = {
		class = "ROGUE",
		icon = "Interface\\Icons\\ability_rogue_shadowstep",
		cooldown = 30,
		minLevel = 1,
		isRune = true,
		spellIDs = {
			[400029] = "Shadowstep", --Rune.
		},
	},
	--Shaman.
	["Shamanistic Rage"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_nature_shamanrage",
		cooldown = 60,
		minLevel = 1,
		isRune = true,
		name = "Sham Rage",
		spellIDs = {
			[425336] = "Shamanistic Rage", --Rune.
		},
	},
	--Warrior.
	["Rallying Cry"] = {
		class = "WARRIOR",
		icon = "Interface\\Icons\\ability_warrior_rallyingcry",
		cooldown = 180,
		minLevel = 1,
		isRune = true,
		spellIDs = {
			[426490] = "Rallying Cry", --Rune.
		},
	},
};