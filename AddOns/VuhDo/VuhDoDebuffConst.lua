local GetSpellName = C_Spell.GetSpellName or VUHDO_getSpellName;

--
VUHDO_DEBUFF_TYPE_NONE = 0;
VUHDO_DEBUFF_TYPE_POISON = 1;
VUHDO_DEBUFF_TYPE_DISEASE = 2;
VUHDO_DEBUFF_TYPE_MAGIC = 3;
VUHDO_DEBUFF_TYPE_CURSE = 4;
VUHDO_DEBUFF_TYPE_CUSTOM = 6;
VUHDO_DEBUFF_TYPE_MISSING_BUFF = 7;
VUHDO_DEBUFF_TYPE_BLEED = 8;
VUHDO_DEBUFF_TYPE_ENRAGE = 9;



--
VUHDO_INIT_PURGE_ABILITIES = {
	["WARRIOR"] = { },
	["ROGUE"] = {
		[VUHDO_DEBUFF_TYPE_ENRAGE] = { 5938 }, -- VUHDO_SPELL_ID.SHIV
	},
	["HUNTER"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { 19801 }, -- VUHDO_SPELL_ID.TRANQUILIZING_SHOT
		[VUHDO_DEBUFF_TYPE_ENRAGE] = { 19801 }, -- VUHDO_SPELL_ID.TRANQUILIZING_SHOT
	},
	["MAGE"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { 30449 }, -- VUHDO_SPELL_ID.SPELLSTEAL
	},
	["DRUID"] = {
		[VUHDO_DEBUFF_TYPE_ENRAGE] = { 2908 }, -- VUHDO_SPELL_ID.SOOTHE
	},
	["PALADIN"] = { },
	["PRIEST"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { 527 }, -- VUHDO_SPELL_ID.DISPEL_MAGIC
	},
	["SHAMAN"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { 370 }, -- VUHDO_SPELL_ID.PURGE
	},
	["WARLOCK"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { "*" }, -- VUHDO_SPELL_ID.DEVOUR_MAGIC 19505
	},
	["DEATHKNIGHT"] = { },
	["MONK"] = { },
	["DEMONHUNTER"] = { },
	["EVOKER"] = { },
};



--
VUHDO_INIT_DISPEL_ABILITIES = {
	["WARRIOR"] = { },
	["ROGUE"] = { },
	["HUNTER"] = { },
	["MAGE"] = { 
		[VUHDO_DEBUFF_TYPE_CURSE] = { VUHDO_SPELL_ID.REMOVE_LESSER_CURSE },
	},
	["DRUID"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.REMOVE_CORRUPTION, VUHDO_SPELL_ID.NATURES_CURE },
		[VUHDO_DEBUFF_TYPE_CURSE] = { VUHDO_SPELL_ID.REMOVE_CORRUPTION, VUHDO_SPELL_ID.NATURES_CURE },
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.NATURES_CURE },
	},
	["PALADIN"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.PALA_CLEANSE },
		[VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.PALA_CLEANSE },
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.SACRED_CLEANSING },
	},
	["PRIEST"] = {
		[VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.PURIFY },
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.PURIFY },
	},
	["SHAMAN"] = {
		[VUHDO_DEBUFF_TYPE_CURSE] = { VUHDO_SPELL_ID.PURIFY_SPIRIT, VUHDO_SPELL_ID.CLEANSE_SPIRIT }, -- FIXME: OG MoP beta bug?
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.PURIFY_SPIRIT, VUHDO_SPELL_ID.CLEANSE_SPIRIT },
	},
	["WARLOCK"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { "*" },
	},
	["DEATHKNIGHT"] = { },
	["MONK"] ={
                [VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.DETOX },
                [VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.DETOX },
                [VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.INTERNAL_MEDICINE },
	},
	["DEMONHUNTER"] = { },
	["EVOKER"] = { },
};



VUHDO_SPEC_TO_DEBUFF_ABIL = {
	[VUHDO_SPELL_ID.SACRED_CLEANSING] = VUHDO_SPELL_ID.PALA_CLEANSE,
	[VUHDO_SPELL_ID.INTERNAL_MEDICINE] = VUHDO_SPELL_ID.DETOX,
};



VUHDO_INIT_IGNORE_DEBUFFS_BY_CLASS = {
	["WARRIOR"] = {
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["ROGUE"] = {
		[VUHDO_SPELL_ID.DEBUFF_SILENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["HUNTER"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["MAGE"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellName(87923))] = true, -- MOP okay Wind Blast
	},
	["DRUID"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PALADIN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PRIEST"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellName(87923))] = true, -- MOP okay Wind Blast
	},
	["SHAMAN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["WARLOCK"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellName(87923))] = true, -- MOP okay Wind Blast
	},
	["DEATHKNIGHT"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["MONK"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["DEMONHUNTER"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["EVOKER"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
};



--
VUHDO_INIT_IGNORE_DEBUFFS_MOVEMENT = {
	[VUHDO_SPELL_ID.DEBUFF_FROSTBOLT] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
	[VUHDO_SPELL_ID.DEBUFF_SLOW] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_THUNDERCLAP] = true,
	[VUHDO_SPELL_ID.DEBUFF_DAZED] = true,
	[VUHDO_SPELL_ID.DEBUFF_FROST_SHOCK] = true,
	[VUHDO_SPELL_ID.FROSTBOLT_VOLLEY] = true,
	[(GetSpellName(88184))] = true, -- MOP okay Lethargic Poison
	[(GetSpellName(87759))] = true, -- MOP okay Shockwave
	[(GetSpellName(88075))] = true, -- MOP okay Typhoon
	[(GetSpellName(90938))] = true, -- MOP okay Bloodbolt
	[(GetSpellName(92007))] = true, -- MOP okay Swirling Vapor
	[(GetSpellName(88169))] = true, -- MOP okay Frost Blossom
	[(GetSpellName(87861))] = true, -- MOP okay Fists of Frost
	[(GetSpellName(83776))] = true, -- MOP okay Dragon's Breath
	[(GetSpellName(7964))] = true, --  MOP okay Smoke Bomb
	[(GetSpellName(83785))] = true, -- MOP okay Shockwave
	[(GetSpellName(81630))] = true, -- MOP okay Viscous Poison
	[(GetSpellName(82764))] = true, -- MOP okay Wing Clip
	[(GetSpellName(76825))] = true, -- MOP okay Ice Blast
	[(GetSpellName(73963))] = true, -- MOP okay Blinding Toxin
	[(GetSpellName(76508))] = true, -- MOP okay Frostbolt
	[(GetSpellName(76682))] = true, -- MOP okay Frostbomb
	[(GetSpellName(12611))] = true, -- MOP okay Cone of Cold
	[(GetSpellName(76094))] = true, -- MOP okay Curse of Fatigue
	[(GetSpellName(76604))] = true, -- MOP okay Void Rip
};



--
VUHDO_INIT_IGNORE_DEBUFFS_DURATION = {
	[VUHDO_SPELL_ID.DEBUFF_PSYCHIC_HORROR] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_FALTER] = true,
	[(GetSpellName(87759))] = true, -- MOP okay Shockwave
	[(GetSpellName(90938))] = true, -- MOP okay Bloodbolt
	[(GetSpellName(92007))] = true, -- MOP pkay Swirling Vapor
	[(GetSpellName(83776))] = true, -- MOP okay Dragon's Breath
	[(GetSpellName(7964))] = true, -- MOP okay Smoke Bomb
	[(GetSpellName(83785))] = true, -- MOP okay Shockwave
	[(GetSpellName(81630))] = true, -- MOP okay Viscous Poison
	[(GetSpellName(82670))] = true, -- MOP okay Skull Crack
	[(GetSpellName(73963))] = true, -- MOP okay Blinding Toxin
	[(GetSpellName(76508))] = true, -- MOP okay Frostbolt
	[(GetSpellName(76185))] = true, -- MOP okay Stone Blow
};



VUHDO_INIT_IGNORE_DEBUFFS_NO_HARM = {
	[VUHDO_SPELL_ID.DEBUFF_HUNTERS_MARK] = true,
	[VUHDO_SPELL_ID.DEBUFF_ARCANE_CHARGE] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAJOR_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_GREATER_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_DREAMLESS_SLEEP] = true,
	[VUHDO_SPELL_ID.MISDIRECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_DELUSIONS_OF_JINDO] = true,
	[VUHDO_SPELL_ID.DEBUFF_MIND_VISION] = true,
	[VUHDO_SPELL_ID.DEBUFF_MUTATING_INJECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_BANISH] = true,
	[VUHDO_SPELL_ID.DEBUFF_PHASE_SHIFT] = true,
	[(GetSpellName(41425))] = true, -- Hypothermia
	[(GetSpellName(123981))] = true, -- Perdition
	[(GetSpellName(53753))] = true, -- Nightmare Slumber
	[(GetSpellName(78993))] = true, -- Concentration
	[(GetSpellName(105701))] = true, -- Potion of Focus
	[(GetSpellName(57724))] = true, -- Sated
	[(GetSpellName(57723))] = true, -- Exhaustion
	[(GetSpellName(80354))] = true, -- Temporal Displacement
	[VUHDO_SPELL_ID.DEBUFF_FATIGUED] = true,
	[(GetSpellName(95809))] = true, -- Insanity
};

