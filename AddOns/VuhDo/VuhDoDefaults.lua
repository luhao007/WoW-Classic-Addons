local GetSpellName = C_Spell.GetSpellName or VUHDO_getSpellName;
local GetSpecialization = VUHDO_getSpecialization;
local GetSpecializationInfo = VUHDO_getSpecializationInfo;
local pairs = pairs;
local _;

VUHDO_GLOBAL_CONFIG = {
	["PROFILES_VERSION"] = 1;
};


--
local tHotCfg, tHotSlots;
function VUHDO_fixHotSettings()

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		tHotSlots = VUHDO_PANEL_SETUP[tPanelNum]["HOTS"]["SLOTS"];
		tHotCfg = VUHDO_PANEL_SETUP[tPanelNum]["HOTS"]["SLOTCFG"];

		for tCnt2 = 1, 12 do -- VUHDO_MAX_HOTS
			if not tHotCfg["" .. tCnt2]["mine"] and not tHotCfg["" .. tCnt2]["others"] then
				if tHotSlots[tCnt2] then
					tHotCfg["" .. tCnt2]["mine"] = true;
					tHotCfg["" .. tCnt2]["others"] = VUHDO_EXCLUSIVE_HOTS[tHotSlots[tCnt2]];
				end
			end
		end
	end

end



--
local function VUHDO_getVarDescription(aVar)
	local tMessage = "";
	if aVar == nil then
		tMessage = "<nil>";
	elseif "boolean" == type(aVar) then
		if aVar then
			tMessage = "<true>";
		else
			tMessage = "<false>";
		end
	elseif "number" == type(aVar) or "string" == type(aVar) then
		tMessage = aVar .. " (" .. type(aVar) .. ")";
	else
		tMessage = "(" .. type(aVar) .. ")";
	end

	return tMessage;
end



--
local tCreated, tRepaired;
local function _VUHDO_ensureSanity(aName, aValue, aSaneValue)
	if aSaneValue ~= nil then
		if type(aSaneValue) == "table" then
			if aValue ~= nil and type(aValue) == "table" then
				for tIndex, _ in pairs(aSaneValue) do
					aValue[tIndex] = _VUHDO_ensureSanity(aName, aValue[tIndex], aSaneValue[tIndex]);
				end
			else

				if aValue ~= nil then
					tRepaired = tRepaired + 1;
				else
					tCreated = tCreated + 1;
				end

				return VUHDO_deepCopyTable(aSaneValue);
			end
		else
			if aValue == nil or type(aValue) ~= type(aSaneValue) then
				if (type(aSaneValue) ~= "boolean" or (aValue ~= 1 and aValue ~= 0 and aValue ~= nil))
				and (type(aSaneValue) ~= "number" or (aSaneValue ~= 1 and aSaneValue ~= 0)) then

					if (aValue ~= nil) then
						tRepaired = tRepaired + 1;
					else
						tCreated = tCreated + 1;
					end

					return aSaneValue;
				end
			end

			if aValue ~= nil and "string" == type(aValue) then
				aValue = strtrim(aValue);
			end

		end
	end

	return aValue
end



--
local tRepairedArray;
function VUHDO_ensureSanity(aName, aValue, aSaneValue)
	tCreated, tRepaired = 0, 0;

	local tSaneValue = VUHDO_decompressIfCompressed(aSaneValue);
	tRepairedArray = _VUHDO_ensureSanity(aName, aValue, tSaneValue);

	if tCreated + tRepaired > 0 then
		VUHDO_Msg("auto model sanity: " .. aName .. ": created " .. tCreated .. ", repaired " .. tRepaired .. " values.");
	end

	return tRepairedArray;
end



local VUHDO_DEFAULT_MODELS = {
	{ VUHDO_ID_GROUP_1, VUHDO_ID_GROUP_2, VUHDO_ID_GROUP_3, VUHDO_ID_GROUP_4, VUHDO_ID_GROUP_5, VUHDO_ID_GROUP_6, VUHDO_ID_GROUP_7, VUHDO_ID_GROUP_8, VUHDO_ID_PETS },
	{ VUHDO_ID_PRIVATE_TANKS, VUHDO_ID_BOSSES }, 
};



local VUHDO_DEFAULT_RANGE_SPELLS = {
	["WARRIOR"] = {
		["HELPFUL"] = { }, -- FIXME: anything?
		["HARMFUL"] = { VUHDO_SPELL_ID.TAUNT },
	},
	["ROGUE"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.SHADOWSTEP },
		["HARMFUL"] = { VUHDO_SPELL_ID.SHADOWSTEP },
	},
	["HUNTER"] = {
		["HELPFUL"] = { }, -- FIXME: anything?
		["HARMFUL"] = { 193455, 19434, 132031 }, -- VUHDO_SPELL_ID.COBRA_SHOT, VUHDO_SPELL_ID.AIMED_SHOT, VUHDO_SPELL_ID.STEADY_SHOT
	},
	["PALADIN"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.FLASH_OF_LIGHT },
		["HARMFUL"] = { VUHDO_SPELL_ID.HAND_OF_RECKONING },
	},
	["MAGE"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.ARCANE_INTELLECT },
		["HARMFUL"] = { 116, 30451, 133 }, -- VUHDO_SPELL_ID.FROSTBOLT, VUHDO_SPELL_ID.ARCANE_BLAST, VUHDO_SPELL_ID.FIREBALL
	},
	["WARLOCK"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.SOULSTONE },
		["HARMFUL"] = { VUHDO_SPELL_ID.SHADOW_BOLT },
	},
	["SHAMAN"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.HEALING_WAVE },
		["HARMFUL"] = { VUHDO_SPELL_ID.FLAME_SHOCK, VUHDO_SPELL_ID.LIGHTNING_BOLT },
	},
	["DRUID"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.REJUVENATION },
		["HARMFUL"] = { VUHDO_SPELL_ID.MOONFIRE },
	},
	["PRIEST"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.FLASH_HEAL },
		["HARMFUL"] = { VUHDO_SPELL_ID.SHADOW_WORD_PAIN, VUHDO_SPELL_ID.SMITE },
	},
	["DEATHKNIGHT"] = {
		["HELPFUL"] = { 47541 }, -- VUHDO_SPELL_ID.DEATH_COIL
		["HARMFUL"] = { 47541, 49576 }, -- VUHDO_SPELL_ID.DEATH_COIL, VUHDO_SPELL_ID.DEATH_GRIP
	},
	["MONK"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.VIVIFY, VUHDO_SPELL_ID.DETOX },
		["HARMFUL"] = { VUHDO_SPELL_ID.PROVOKE },
	},
	["DEMONHUNTER"] = {
		["HELPFUL"] = { }, -- FIXME: anything?
		["HARMFUL"] = { VUHDO_SPELL_ID.THROW_GLAIVE },
	},
	["EVOKER"] = {
		["HELPFUL"] = { VUHDO_SPELL_ID.EMERALD_BLOSSOM, VUHDO_SPELL_ID.LIVING_FLAME },
		["HARMFUL"] = { VUHDO_SPELL_ID.AZURE_STRIKE, VUHDO_SPELL_ID.LIVING_FLAME },
	},
};



--local VUHDO_DEFAULT_SPELL_ASSIGNMENT = { };
--local VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT = {};
local VUHDO_DEFAULT_SPELLS_KEYBOARD = {};



local VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT = {
	["PALADIN"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.FLASH_OF_LIGHT },
		["2"] = { "", "2", VUHDO_SPELL_ID.HOLY_SHOCK },
		["3"] = { "", "3", "dropdown" },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.HOLY_LIGHT },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.LAY_ON_HANDS },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.LIGHT_OF_DAWN },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.PALA_CLEANSE },
		["shift3"] = { "shift-", "3", "menu" },
	},

	["SHAMAN"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.HEALING_WAVE },
		["2"] = { "", "2", VUHDO_SPELL_ID.CHAIN_HEAL },
		["3"] = { "", "3", "dropdown" },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.BUFF_EARTH_SHIELD },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.GIFT_OF_THE_NAARU },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.RIPTIDE },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.PURIFY_SPIRIT },
		["shift3"] = { "shift-", "3", "menu" },
	},

	["PRIEST"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.FLASH_HEAL },
		["2"] = { "", "2", VUHDO_SPELL_ID.RENEW },
		["3"] = { "", "3", "dropdown" },
		["4"] = { "", "4", VUHDO_SPELL_ID.PRAYER_OF_MENDING },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.PRAYER_OF_HEALING },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.CIRCLE_OF_HEALING },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.POWERWORD_SHIELD },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.PURIFY },
		["shift3"] = { "shift-", "3", "menu" },
	},

	["DRUID"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.REGROWTH },
		["2"] = { "", "2", VUHDO_SPELL_ID.REJUVENATION },
		["3"] = { "", "3", "dropdown" },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.INNERVATE },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.LIFEBLOOM },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.TRANQUILITY },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.NATURES_CURE },
		["shift3"] = { "shift-", "3", "menu" },
	},

	["MONK"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.RENEWING_MIST },
		["2"] = { "", "2", VUHDO_SPELL_ID.ENVELOPING_MIST },
		["3"] = { "", "3", "dropdown" },
		["4"] = { "", "4", VUHDO_SPELL_ID.CHI_WAVE },
		["5"] = { "", "5", VUHDO_SPELL_ID.SOOTHING_MIST },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.REVIVAL },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.LIFE_COCOON },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.VIVIFY },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.DETOX },
		["shift3"] = { "shift-", "3", "menu" },
	},

	["EVOKER"] = {
		["1"] = { "", "1", VUHDO_SPELL_ID.LIVING_FLAME },
		["2"] = { "", "2", VUHDO_SPELL_ID.EMERALD_BLOSSOM },
		["3"] = { "", "3", "dropdown" },
		["4"] = { "", "4", VUHDO_SPELL_ID.ECHO },

		["alt1"] = { "alt-", "1", "target" },
		["alt2"] = { "alt-", "2", "focus" },
		["alt3"] = { "alt-", "3", "menu" },

		["ctrl1"] = { "ctrl-", "1", VUHDO_SPELL_ID.DREAM_BREATH },
		["ctrl2"] = { "ctrl-", "2", VUHDO_SPELL_ID.DREAM_FLIGHT },
		["ctrl3"] = { "ctrl-", "3", "menu" },

		["shift1"] = { "shift-", "1", VUHDO_SPELL_ID.CAUTERIZING_FLAME },
		["shift2"] = { "shift-", "2", VUHDO_SPELL_ID.NATURALIZE },
		["shift3"] = { "shift-", "3", "menu" },
	},
};



--
local VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT = {
	["1"] = { "", "1", "target" },
	["2"] = { "", "2", "dropdown" },
	["3"] = { "", "3", "focus" },
	["4"] = { "", "4", "menu" },
	["5"] = { "", "5", "assist" },
};



--
VUHDO_DEFAULT_SPELL_CONFIG = {
	["IS_AUTO_FIRE"] = true,
	["IS_FIRE_HOT"] = false,
	["IS_FIRE_OUT_FIGHT"] = false,
	["IS_AUTO_TARGET"] = false,
	["IS_CANCEL_CURRENT"] = false,
	["IS_FIRE_TRINKET_1"] = false,
	["IS_FIRE_TRINKET_2"] = false,
	["IS_FIRE_GLOVES"] = false,
	["IS_FIRE_CUSTOM_1"] = false,
	["FIRE_CUSTOM_1_SPELL"] = "",
	["IS_FIRE_CUSTOM_2"] = false,
	["FIRE_CUSTOM_2_SPELL"] = "",
	["IS_TOOLTIP_INFO"] = false,
	["IS_LOAD_HOTS"] = false,
	["IS_LOAD_HOTS_ONLY_SLOTS"] = false,
	["smartCastModi"] = "all",
	["autoBattleRez"] = true,
	["custom1Unit"] = "@player",
	["custom2Unit"] = "@player",
}


local tDefaultWheelAssignments = {
	["1"] = {"", "-w1", ""},
	["2"] = {"", "-w2", ""},

	["alt1"] = {"ALT-", "-w3", ""},
	["alt2"] = {"ALT-", "-w4", ""},

	["ctrl1"] = {"CTRL-", "-w5", ""},
	["ctrl2"] = {"CTRL-", "-w6", ""},

	["shift1"] = {"SHIFT-", "-w7", ""},
	["shift2"] = {"SHIFT-", "-w8", ""},

	["altctrl1"] = {"ALT-CTRL-", "-w9", ""},
	["altctrl2"] = {"ALT-CTRL-", "-w10", ""},

	["altshift1"] = {"ALT-SHIFT-", "-w11", ""},
	["altshift2"] = {"ALT-SHIFT-", "-w12", ""},

	["ctrlshift1"] = {"CTRL-SHIFT-", "-w13", ""},
	["ctrlshift2"] = {"CTRL-SHIFT-", "-w14", ""},

	["altctrlshift1"] = {"ALT-CTRL-SHIFT-", "-w15", ""},
	["altctrlshift2"] = {"ALT-CTRL-SHIFT-", "-w16", ""},
};



--
local function VUHDO_initDefaultKeySpellAssignments()
	VUHDO_DEFAULT_SPELLS_KEYBOARD = { };

	for tCnt = 1, VUHDO_NUM_KEYBOARD_KEYS do
		VUHDO_DEFAULT_SPELLS_KEYBOARD["SPELL" .. tCnt] = "";
	end

	VUHDO_DEFAULT_SPELLS_KEYBOARD["INTERNAL"] = {	};
	VUHDO_DEFAULT_SPELLS_KEYBOARD["WHEEL"] = VUHDO_deepCopyTable(tDefaultWheelAssignments);
	VUHDO_DEFAULT_SPELLS_KEYBOARD["HOSTILE_WHEEL"] = VUHDO_deepCopyTable(tDefaultWheelAssignments);
end



--
function VUHDO_trimSpellAssignments(anArray)
	local tRemove = { };

	for tKey, tValue in pairs(anArray) do
		if (VUHDO_strempty(tValue[3])) then
			tinsert(tRemove, tKey);
		end
	end

	for _, tKey in pairs(tRemove) do
		anArray[tKey] = nil;
	end
end



--
local tSpecId;
local tClass;
local tDefaultAssignments;
local function VUHDO_assignDefaultSpells()

	tSpecId = GetSpecializationInfo(GetSpecialization() or 0);
	_, tClass = UnitClass("player");

	if tSpecId and VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT[tSpecId] then
		tDefaultAssignments = VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT[tSpecId];
	elseif tClass and VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT[tClass] then
		tDefaultAssignments = VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT[tClass];
	else
		tDefaultAssignments = VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT;
	end

	VUHDO_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(tDefaultAssignments);

	VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT = nil;
	VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT = nil;

end



--
function VUHDO_loadSpellArray()
	-- Maus freundlich
	if (VUHDO_SPELL_ASSIGNMENTS == nil) then
		VUHDO_assignDefaultSpells();
	end
	VUHDO_SPELL_ASSIGNMENTS = VUHDO_ensureSanity("VUHDO_SPELL_ASSIGNMENTS", VUHDO_SPELL_ASSIGNMENTS, {});
	VUHDO_trimSpellAssignments(VUHDO_SPELL_ASSIGNMENTS);

	-- Maus gegnerisch
	if (VUHDO_HOSTILE_SPELL_ASSIGNMENTS == nil) then
		VUHDO_HOSTILE_SPELL_ASSIGNMENTS = { };
	end
	VUHDO_HOSTILE_SPELL_ASSIGNMENTS = VUHDO_ensureSanity("VUHDO_HOSTILE_SPELL_ASSIGNMENTS", VUHDO_HOSTILE_SPELL_ASSIGNMENTS, {});
	VUHDO_trimSpellAssignments(VUHDO_HOSTILE_SPELL_ASSIGNMENTS);

	-- Tastatur
	VUHDO_initDefaultKeySpellAssignments();
	if (VUHDO_SPELLS_KEYBOARD == nil) then
		VUHDO_SPELLS_KEYBOARD = VUHDO_deepCopyTable(VUHDO_DEFAULT_SPELLS_KEYBOARD);
	end
	VUHDO_SPELLS_KEYBOARD = VUHDO_ensureSanity("VUHDO_SPELLS_KEYBOARD", VUHDO_SPELLS_KEYBOARD, VUHDO_DEFAULT_SPELLS_KEYBOARD);
	VUHDO_DEFAULT_SPELLS_KEYBOARD = nil;

	-- Konfiguration
	if (VUHDO_SPELL_CONFIG == nil) then
		VUHDO_SPELL_CONFIG = VUHDO_deepCopyTable(VUHDO_DEFAULT_SPELL_CONFIG);
	end
	VUHDO_SPELL_CONFIG = VUHDO_ensureSanity("VUHDO_SPELL_CONFIG", VUHDO_SPELL_CONFIG, VUHDO_DEFAULT_SPELL_CONFIG);

	if (VUHDO_SPELL_LAYOUTS == nil) then
		VUHDO_SPELL_LAYOUTS = { };
	end

	if (VUHDO_SPEC_LAYOUTS == nil) then
		VUHDO_SPEC_LAYOUTS = {
			["selected"] = "",
			["1"] = "",
			["2"] = "",
			["3"] = "",
			["4"] = ""
		}
	end

	VUHDO_DEFAULT_SPELL_CONFIG = nil;
end



--
local function VUHDO_makeFullColorWoOpacity(...)

	local tColor = VUHDO_makeFullColor(...);
	
	tColor["useOpacity"] = false;
	
	return tColor;

end



--
local function VUHDO_makeHotColor(...)
	
	local tColor = VUHDO_makeFullColor(...);

	tColor["useOpacity"] = tColor["O"] and true or false;

	tColor["isFullDuration"] = false;
	tColor["isClock"] = false;
	tColor["countdownMode"] = 1;
	tColor["isFadeOut"] = false;
	tColor["isFlashWhenLow"] = false;
	
	return tColor;

end




--
local function VUHDO_customDebuffsAddDefaultSettings(aBuffName)
	if (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"] = { };
	end

	if (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]	= {
			["isIcon"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isIcon"],
			["isColor"] = false,
			["animate"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["animate"],
			["timer"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["timer"],
			["isStacks"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isStacks"],
			["isMine"] = true,
			["isOthers"] = true,
			["isBarGlow"] = false,
			["isIconGlow"] = false,
		}
	end

	if (not VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isColor"]) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"] = nil;
	elseif (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"]
			= VUHDO_makeFullColor(0.6, 0.3, 0, 1,   0.8, 0.5, 0, 1);
	end
	
	if (not VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isBarGlow"]) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["barGlowColor"] = nil;
	elseif (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["barGlowColor"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["barGlowColor"]
			= VUHDO_makeFullColor(0.95, 0.95, 0.32, 1,   1, 1, 0, 1);
	end

	if (not VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isIconGlow"]) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["iconGlowColor"] = nil;
	elseif (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["iconGlowColor"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["iconGlowColor"]
			= VUHDO_makeFullColor(0.95, 0.95, 0.32, 1,   1, 1, 0, 1);
	end
end



--
local tName;
local function VUHDO_addCustomSpellIds(aVersion, aDebuffs)

	if (VUHDO_CONFIG["CUSTOM_DEBUFF"].version or 0) < aVersion then
		VUHDO_CONFIG["CUSTOM_DEBUFF"].version = aVersion;

		for tSpellId, tIsAddBySpellId in pairs(aDebuffs) do
			if tIsAddBySpellId then
				tName = tostring(tSpellId);
			else
				tName = GetSpellName(tSpellId);
			end

			VUHDO_tableUniqueAdd(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"], tName);
		end
	end

end



--
local function VUHDO_spellTraceAddDefaultSettings(aSpellName)

	if (VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"] == nil) then
		VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"] = { };
	end

	if (VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][aSpellName] == nil) then
		VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][aSpellName] = {
			["isMine"] = VUHDO_CONFIG["SPELL_TRACE"]["isMine"],
			["isOthers"] = VUHDO_CONFIG["SPELL_TRACE"]["isOthers"],
			["duration"] = VUHDO_CONFIG["SPELL_TRACE"]["duration"],
			["isIncoming"] = VUHDO_CONFIG["SPELL_TRACE"]["isIncoming"],
		}
	end

end



--
local function VUHDO_addSpellTraceSpellIds(aVersion, ...)

	if ((VUHDO_CONFIG["SPELL_TRACE"].version or 0) < aVersion) then
		VUHDO_CONFIG["SPELL_TRACE"].version = aVersion;

		local tArg;

		for tCnt = 1, select("#", ...) do
			tArg = select(tCnt, ...);

			if (type(tArg) == "number") then
				-- make sure the spell ID is still added as a string
				-- otherwise getKeyFromValue look-ups w/ spell ID string fail later
				tArg = tostring(tArg);
			end

			VUHDO_tableUniqueAdd(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tArg);
		end
	end

end



--
local VUHDO_DEFAULT_CONFIG = {
	["VERSION"] = 4,

	["SHOW_PANELS"] = true,
	["HIDE_PANELS_SOLO"] = false,
	["HIDE_PANELS_PARTY"] = false,
	["HIDE_PANELS_PET_BATTLE"] = true,
	["LOCK_PANELS"] = false,
	["LOCK_CLICKS_THROUGH"] = false,
	["LOCK_IN_FIGHT"] = true,
	["PARSE_COMBAT_LOG"] = false,
	["HIDE_EMPTY_BUTTONS"] = false,

	["MODE"] = VUHDO_MODE_NEUTRAL,
	["EMERGENCY_TRIGGER"] = 100,
	["MAX_EMERGENCIES"] = 5,

	["SHOW_INCOMING"] = true,
	["SHOW_OVERHEAL"] = true,
	["SHOW_OWN_INCOMING"] = true,
	["SHOW_TEXT_OVERHEAL"] = true,
	["SHOW_SHIELD_BAR"] = true,
	["SHOW_OVERSHIELD_BAR"] = false,
	["SHOW_HEAL_ABSORB_BAR"] = true,

	["RANGE_CHECK_DELAY"] = 260,

	["SOUND_DEBUFF"] = nil,
	["SOUND_DEBUFF_REMOVABLE_ONLY"] = false,
	["DETECT_DEBUFFS_REMOVABLE_ONLY"] = true,
	["DETECT_DEBUFFS_REMOVABLE_ONLY_ICONS"] = true,
	["DETECT_DEBUFFS_IGNORE_BY_CLASS"] = true,
	["DETECT_DEBUFFS_IGNORE_NO_HARM"] = true,
	["DETECT_DEBUFFS_IGNORE_MOVEMENT"] = true,
	["DETECT_DEBUFFS_IGNORE_DURATION"] = true,
	["DETECT_DEBUFFS_IGNORE_PURGEABLE_BUFFS"] = false,

	["SMARTCAST_RESURRECT"] = true,
	["SMARTCAST_CLEANSE"] = false,
	["SMARTCAST_BUFF"] = false,

	["SHOW_PLAYER_TAGS"] = true,
	["OMIT_MAIN_TANKS"] = false,
	["OMIT_MAIN_ASSIST"] = false,
	["OMIT_PLAYER_TARGETS"] = false,
	["OMIT_OWN_GROUP"] = false,
	["OMIT_FOCUS"] = false,
	["OMIT_TARGET"] = false,
	["OMIT_SELF"] = false,
	["OMIT_DFT_MTS"] = false,
	["BLIZZ_UI_HIDE_PLAYER"] = 2,
	["BLIZZ_UI_HIDE_PARTY"] = 2,
	["BLIZZ_UI_HIDE_TARGET"] = 2,
	["BLIZZ_UI_HIDE_PET"] = 2,
	["BLIZZ_UI_HIDE_FOCUS"] = 2,
	["BLIZZ_UI_HIDE_RAID"] = 2,
	["BLIZZ_UI_HIDE_RAID_MGR"] = 2,

	["CURRENT_PROFILE"] = "",
	["IS_ALWAYS_OVERWRITE_PROFILE"] = false,
	["HIDE_EMPTY_PANELS"] = false,
	["ON_MOUSE_UP"] = false,

	["STANDARD_TOOLTIP"] = false,
	["DEBUFF_TOOLTIP"] = true,

	["AUTO_PROFILES"] = {	},

	["RES_ANNOUNCE_TEXT"] = VUHDO_I18N_DEFAULT_RES_ANNOUNCE,
	["RES_ANNOUNCE_MASS_TEXT"] = VUHDO_I18N_DEFAULT_RES_ANNOUNCE_MASS,
	["RES_IS_SHOW_TEXT"] = false,

	["CUSTOM_DEBUFF"] = {
		["scale"] = 0.8,
		["animate"] = false,
		["timer"] = true,
		["max_num"] = 3,
		["isNoRangeFade"] = false,
		["isIcon"] = true,
		["isColor"] = false,
		["isStacks"] = true,
		["isName"] = false, 
		["isShowFriendly"] = true,
		["isShowHostile"] = true,
		["isHostileMine"] = true,
		["isHostileOthers"] = true,
		["blacklistModi"] = "ALT-CTRL-SHIFT",
		["SELECTED"] = "",
		["point"] = "TOPRIGHT",
		["xAdjust"] = -2,
		["yAdjust"] = -34,
		["STORED"] = { },

		["TIMER_TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 20,
			["Y_ADJUST"] = 26,
			["SCALE"] = 85,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   1, 1, 1, 1),
			["USE_SHADOW"] = true,
			["USE_OUTLINE"] = false,
			["USE_MONO"] = false,
		},

		["COUNTER_TEXT"] = {
			["ANCHOR"] = "TOPLEFT",
			["X_ADJUST"] = -10,
			["Y_ADJUST"] = -15,
			["SCALE"] = 70,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   0, 1, 0, 1),
			["USE_SHADOW"] = true,
			["USE_OUTLINE"] = false,
			["USE_MONO"] = false,
		},
	},

	["SPELL_TRACE"] = {
		["isMine"] = true,
		["isOthers"] = false,
		["duration"] = 2,
		["showTrailOfLight"] = false,
		["SELECTED"] = "",
		["STORED"] = { },
		["isIncoming"] = false,
		["showIncomingFriendly"] = false,
		["showIncomingEnemy"] = false,
		["showIncomingAll"] = false,
		["showIncomingBossOnly"] = false,
	},

	["THREAT"] = {
		["AGGRO_REFRESH_MS"] = 300,
		["AGGRO_TEXT_LEFT"] = ">>",
		["AGGRO_TEXT_RIGHT"] = "<<",
		["AGGRO_USE_TEXT"] = false,
		["IS_TANK_MODE"] = false,
	},

	["CLUSTER"] = {
		["REFRESH"] = 500,
		["RANGE"] = 30,
		["RANGE_JUMP"] = 11,
		["BELOW_HEALTH_PERC"] = 85,
		["THRESH_FAIR"] = 3,
		["THRESH_GOOD"] = 5,
		["DISPLAY_SOURCE"] = 2, -- 1=Mine, 2=all
		["DISPLAY_DESTINATION"] = 2, -- 1=Party, 2=Raid
		["MODE"] = 1, -- 1=radial, 2=chained
		["IS_NUMBER"] = true,
		["CHAIN_MAX_JUMP"] = 3,
		["COOLDOWN_SPELL"] = "",
		["CONE_DEGREES"] = 360,
		["ARE_TARGETS_RANDOM"] = true,

		["TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 40,
			["Y_ADJUST"] = 22,
			["SCALE"] = 85,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   1, 1, 1, 1),
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},
	},

	["UPDATE_HOTS_MS"] = 250,
	["SCAN_RANGE"] = "2", -- 0=all, 2=100 yards, 3=40 yards

	["RANGE_SPELL"] = {
		["HELPFUL"] = "",
		["HARMFUL"] = "",
	},
	["RANGE_PESSIMISTIC"] = {
		["HELPFUL"] = true,
		["HARMFUL"] = true,
	},

	["IS_SHOW_GCD"] = false,
	["IS_SCAN_TALENTS"] = true,
	["IS_CLIQUE_COMPAT_MODE"] = false,
	["IS_CLIQUE_PASSTHROUGH"] = false,
	["DIRECTION"] = {
		["enable"] = true,
		["isDistanceText"] = false,
		["isDeadOnly"] = false,
		["isAlways"] = false,
		["scale"] = 75,
	},

	["AOE_ADVISOR"] = {
		["knownOnly"] = true,
		["subInc"] = true,
		["subIncOnlyCastTime"] = true,
		["isCooldown"] = true,
		["animate"] = true,
		["isGroupWise"] = false,
		["refresh"] = 800,

		["config"] = {
			["coh"] = {
				["enable"] = false,
				["thresh"] = 15000,
			},
			["poh"] = {
				["enable"] = false,
				["thresh"] = 20000,
			},
			["ch"] = {
				["enable"] = false,
				["thresh"] = 15000,
			},
			["wg"] = {
				["enable"] = false,
				["thresh"] = 15000,
			},
			["tq"] = {
				["enable"] = false,
				["thresh"] = 15000,
			},
			["lod"] = {
				["enable"] = false,
				["thresh"] = 8000,
			},
			["hr"] = {
				["enable"] = false,
				["thresh"] = 10000,
			},
			["cb"] = {
				["enable"] = false,
				["thresh"] = 10000,
			},
		},

	},

	["IS_DC_SHIELD_DISABLED"] = false,
	["IS_USE_BUTTON_FACADE"] = false,
	["IS_SHARE"] = true,
	["IS_READY_CHECK_DISABLED"] = false,

	["SHOW_SPELL_TRACE"] = false,
};



local VUHDO_DEFAULT_CU_DE_STORED_SETTINGS = {
	["isIcon"] = true,
	["isColor"] = false,
--	["SOUND"] = "",
	["animate"] = false,
	["timer"] = true,
	["isStacks"] = true,
	["isAliveTime"] = false,
	["isFullDuration"] = false,
	["isMine"] = true,
	["isOthers"] = true,
	["isBarGlow"] = false,
	["isIconGlow"] = false,

--	["color"] = {
--		["R"] = 0.6,
--		["G"] = 0.3,
--		["B"] = 0,
--		["O"] = 1,
--		["TR"] = 0.8,
--		["TG"] = 0.5,
--		["TB"] = 0,
--		["TO"] = 1,
--		["useText"] = true,
--		["useBackground"] = true,
--		["useOpacity"] = true,
--	},
};



local VUHDO_DEFAULT_SPELL_TRACE_STORED_SETTINGS = {
	["isMine"] = true,
	["isOthers"] = false,
	["duration"] = 2,
	["isIncoming"] = false,
};



VUHDO_DEFAULT_POWER_TYPE_COLORS = {
	[VUHDO_UNIT_POWER_MANA]         = VUHDO_makeFullColor(0,     0,     1,    1,  0,     0,     1,    1),
	[VUHDO_UNIT_POWER_RAGE]         = VUHDO_makeFullColor(1,     0,     0,    1,  1,     0,     0,    1),
	[VUHDO_UNIT_POWER_FOCUS]        = VUHDO_makeFullColor(1,     0.5,   0.25, 1,  1,     0.5,   0.25, 1),
	[VUHDO_UNIT_POWER_ENERGY]       = VUHDO_makeFullColor(1,     1,     0,    1,  1,     1,     0,    1),
	[VUHDO_UNIT_POWER_COMBO_POINTS] = VUHDO_makeFullColor(0,     1,     1,    1,  0,     1,     1,    1),
	[VUHDO_UNIT_POWER_RUNIC_POWER]  = VUHDO_makeFullColor(0.5,   0.5,   0.5,  1,  0.5,   0.5,   0.5,  1),
	[VUHDO_UNIT_POWER_LUNAR_POWER]  = VUHDO_makeFullColor(0.87,  0.95,  1,    1,  0.87,  0.95,  1,    1),
	[VUHDO_UNIT_POWER_MAELSTROM]    = VUHDO_makeFullColor(0.09,  0.56,  1,    1,  0.09,  0.56,  1,    1),
	[VUHDO_UNIT_POWER_INSANITY]     = VUHDO_makeFullColor(0.15,  0.97,  1,    1,  0.15,  0.97,  1,    1),
	[VUHDO_UNIT_POWER_FURY]         = VUHDO_makeFullColor(0.54,  0.09,  0.69, 1,  0.54,  0.09,  0.69, 1),
	[VUHDO_UNIT_POWER_PAIN]         = VUHDO_makeFullColor(0.54,  0.09,  0.69, 1,  0.54,  0.09,  0.69, 1),
};



--
local function VUHDO_convertToTristate(aBoolean, aTrueVal, aFalseVal)
	if (aBoolean == nil or aBoolean == false) then
		return aFalseVal;
	elseif (aBoolean == true) then
		return aTrueVal;
	else
		return aBoolean;
	end
end



--
function VUHDO_loadDefaultConfig()
	local _, tClass = UnitClass("player");

	if (VUHDO_CONFIG == nil) then
		VUHDO_CONFIG = VUHDO_decompressOrCopy(VUHDO_DEFAULT_CONFIG);
	end
	
	VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"], 3, 2);
	VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"] = VUHDO_convertToTristate(VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"], 3, 2);

	VUHDO_DEFAULT_CONFIG = VUHDO_decompressIfCompressed(VUHDO_DEFAULT_CONFIG);
	VUHDO_CONFIG = VUHDO_ensureSanity("VUHDO_CONFIG", VUHDO_CONFIG, VUHDO_DEFAULT_CONFIG);

	-- deprecate "show only for friendly" option in favor of distinct show on friendly and hostile options
	if VUHDO_CONFIG["CUSTOM_DEBUFF"] and VUHDO_DEFAULT_CONFIG["CUSTOM_DEBUFF"] then
		-- FIXME: VUHDO_ensureSanity() skips creating booleans but fixing this breaks some models
		for tKey, tValue in pairs(VUHDO_DEFAULT_CONFIG["CUSTOM_DEBUFF"]) do
			if type(tValue) == "boolean" and VUHDO_CONFIG["CUSTOM_DEBUFF"][tKey] == nil then
				VUHDO_CONFIG["CUSTOM_DEBUFF"][tKey] = tValue;
			end
		end

		if VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowOnlyForFriendly"] ~= nil then
			if VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowOnlyForFriendly"] then
				VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowHostile"] = false;
			end

			VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowOnlyForFriendly"] = nil;
		end
	end

	VUHDO_DEFAULT_CONFIG = VUHDO_compressAndPackTable(VUHDO_DEFAULT_CONFIG);

	if ((VUHDO_CONFIG["VERSION"] or 1) < 4) then
		VUHDO_CONFIG["IS_SHARE"] = true;
		VUHDO_CONFIG["VERSION"] = 4;
	end

	if (VUHDO_DEFAULT_RANGE_SPELLS[tClass] ~= nil) then
		for tUnitReaction, tRangeSpells in pairs(VUHDO_DEFAULT_RANGE_SPELLS[tClass]) do
			local tIsGuessRange = true;

			if VUHDO_strempty(VUHDO_CONFIG["RANGE_SPELL"][tUnitReaction]) then
				for _, tRangeSpell in pairs(tRangeSpells) do
					if type(tRangeSpell) == "number" then
						tRangeSpell = IsPlayerSpell(tRangeSpell) and GetSpellName(tRangeSpell) or "!";
					end

					if tRangeSpell ~= "!" then
						VUHDO_CONFIG["RANGE_SPELL"][tUnitReaction] = tRangeSpell;
						tIsGuessRange = false;

						break;
					end
				end

				VUHDO_CONFIG["RANGE_PESSIMISTIC"][tUnitReaction] = tIsGuessRange;
			end
		end
	end

	-- 3.4.0 - Wrath of the Lich King Classic - phase 1
	VUHDO_addCustomSpellIds(54, {
		-- [[ Obsidian Sanctum ]]
		[60708] = true,  -- Fade Armor
		[57491] = true,  -- Flame Tsunami
		-- 58766,  -- Gift of Twilight
		-- 60430,  -- Molten Fury
		-- 58105,  -- Power of Shadron
		-- 61248,  -- Power of Tenebron
		-- 61251,  -- Power of Vesperon
		[56910] = true,  -- Tail Lash
		[58957] = true,  -- Tail Lash
		-- 61885,  -- Twilight Residue
		-- 60639,  -- Twilight Revenge
		-- 61254,  -- Will of Sartharion
		[57634] = true,  -- Magma
		-- [[ Eye of Eternity ]]
		[56272] = true,  -- Arcane Breath
		[60072] = true,  -- Arcane Breath
		-- 56438,  -- Arcane Overload
		-- 57060,  -- Haste
		-- 55849,  -- Power Spark
		-- 56152,  -- Power Spark
		[57428] = true,  -- Static Field
		[55849] = true,  -- Surge of Power
		-- 61071,  -- Vortex
		-- 61072,  -- Vortex
		-- 61073,  -- Vortex
		-- 61074,  -- Vortex
		-- 61075,  -- Vortex
		[60936] = true,  -- Surge of Power
		-- [[ Naxxramas ]]
		-- Trash
		[28467] = true,  -- Mortal Wound
		[55334] = true,  -- Strangulate
		[55314] = true,  -- Strangulate
		[54714] = true,  -- Acid Volley
		[29325] = true,  -- Acid Volley
		[54331] = true,  -- Acidic Sludge
		[27891] = true,  -- Acidic Sludge
		[55322] = true,  -- Blood Plague
		[55264] = true,  -- Blood Plague
		[28440] = true,  -- Veil of Shadow
		[53803] = true,  -- Veil of Shadow
		[54708] = true,  -- Rend
		[54703] = true,  -- Rend
		[59899] = true,  -- Poison Charge
		[56674] = true,  -- Poison Charge
		[54326] = true,  -- Bile Vomit
		[27807] = true,  -- Bile Vomit
		[54709] = true,  -- Flesh Rot
		[56674] = true,  -- Flesh Rot
		[56624] = true,  -- Virulent Poison
		[56605] = true,  -- Virulent Poison
		[54772] = true,  -- Putrid Bite
		[30113] = true,  -- Putrid Bite
		[33661] = true,  -- Crush Armor
		[54769] = true,  -- Slime Burst
		[30109] = true,  -- Slime Burst
		[54805] = true,  -- Mind Flay
		[28310] = true,  -- Mind Flay
		[29407] = true,  -- Mind Flay
		[16856] = true,  -- Mortal Strike
		[56427] = true,  -- War Stomp
		[27758] = true,  -- War Stomp
		[30091] = true,  -- Flamestrike
		[56538] = true,  -- Plague Splash
		[54780] = true,  -- Plague Splash
		[55318] = true,  -- Pierce Armor
		[29848] = true,  -- Polymorph
		[6713] = true,   -- Disarm
		[28169] = true,  -- Mutating Injection
		[30080] = true,  -- Retching Plague
		[30081] = true,  -- Retching Plague
		[56444] = true,  -- Retching Plague
		-- Anub'Rekhan
		[56098] = true,  -- Acid Spit
		[28969] = true,  -- Acid Spit
		-- 28783,  -- Impale
		[54022] = true,  -- Locust Swarm
		[28786] = true,  -- Locust Swarm
		-- 28991,  -- Web
		-- Grand Widow Faerlina
		-- 22886,  -- Berserker Charge
		[28796] = true,  -- Poison Bolt Volley
		[54098] = true,  -- Poison Bolt Volley
		-- 28794,  -- Rain of Fire
		-- 30225,  -- Silence
		-- Maexxna
		[54121] = true,  -- Necrotic Poison
		[28776] = true,  -- Necrotic Poison
		-- 29484,  -- Web Spray
		[28622] = true,  -- Web Wrap
		-- Noth the Plaguebringer
		[54814] = true,  -- Cripple
		[29212] = true,  -- Cripple
		[32736] = true,  -- Mortal Strike
		[29213] = true,  -- Curse of the Plaguebringer
		[54835] = true,  -- Curse of the Plaguebringer
		[29214] = true,  -- Wrath of the Plaguebringer
		[54836] = true,  -- Wrath of the Plaguebringer
		-- Heigan the Unclean
		[29998] = true,  -- Decrepit Fever
		[55011] = true,  -- Decrepit Fever
		[29310] = true,  -- Spell Disruption
		-- 29371,  -- Eruption
		[54772] = true,  -- Putrid Bite
		[54769] = true,  -- Slime Burst
		[56538] = true,  -- Plague Splash
		-- Loatheb
		[29204] = true,  -- Inevitable Doom
		[55052] = true,  -- Inevitable Doom
		[55593] = true,  -- Necrotic Aura
		-- 29865,  -- Deathbloom
		-- 55053,  -- Deathbloom
		-- Instructor Razuvious
		[55470] = true,  -- Unbalancing Strike
		[55550] = true,  -- Jagged Knife
		-- Gothik the Harvester
		[27994] = true,  -- Drain Life
		[55646] = true,  -- Drain Life
		[27825] = true,  -- Shadow Mark
		[27993] = true,  -- Stomp
		-- The Four Horsemen
		[28882] = true,  -- Unholy Shadow
		[57369] = true,  -- Unholy Shadow
		-- Patchwerk
		-- Grobbulus
		-- 28153,  -- Disease Cloud
		-- 28206,  -- Mutagen Explosion
		[28169] = true,  -- Mutating Injection
		-- Gluth
		[54378] = true,	-- Mortal Wound
		[29306] = true,  -- Infected Wound
		-- Thaddius
		-- 28059,  -- Positive Charge
		-- 28084,	-- Negative Charge
		-- Sapphiron
		[28542] = true,  -- Life Drain
		[55665] = true,  -- Life Drain
		[15847] = true,  -- Tail Sweep
		[28547] = true,  -- Chill
		[55699] = true,  -- Chill
		[28522] = true,  -- Icebolt
		-- Kel'Thuzad
		-- 29879,  -- Frost Blast
		-- 10187,  -- Blizzard
		-- 28479,  -- Frostbolt
		-- 28478,  -- Frostbolt
		[27819] = true,  -- Detonate Mana
		[27808] = true,  -- Frost Blast
		-- 28408,  -- Chains of Kel'Thuzad
		-- 28409,  -- Chains of Kel'Thuzad
		[28410] = true,  -- Chains of Kel'Thuzad
	} );

	local debuffRemovalList = {};

	for tIndex, tName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		-- I introduced a bug which added some default custom debuffs by spell ID
		-- where spell ID was a number and not a string, this causes all sorts of odd 
		-- bugs in the custom debuff code particularly any getKeyFromValue table lookups
		if (type(tName) == "number") then
			-- if we encounter a custom debuff stored by an actual number flag this key for removal
			debuffRemovalList[tIndex] = tIndex;
		else
			VUHDO_customDebuffsAddDefaultSettings(tName);
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tName] = VUHDO_ensureSanity(
				"CUSTOM_DEBUFF.STORED_SETTINGS",
				VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tName],
				VUHDO_DEFAULT_CU_DE_STORED_SETTINGS
			);
		end
	end

	-- in Lua removal can't be done in place while perserving order properly
	-- so do the removal in a second pass
	for tIndex, _ in pairs(debuffRemovalList) do
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"][tIndex] = nil;
	end

	-- add default spells to track with spell trace
	VUHDO_addSpellTraceSpellIds(1, 
		-- Shaman
		1064,   -- Chain Heal
		-- Priest
		34861,  -- Holy Word: Sanctify
		596,    -- Prayer of Healing
		194509  -- Power Word: Radiance
	);

	for _, tName in pairs(VUHDO_CONFIG["SPELL_TRACE"]["STORED"]) do
		VUHDO_spellTraceAddDefaultSettings(tName);

		VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tName] = VUHDO_ensureSanity(
			"SPELL_TRACE.STORED_SETTINGS",
			VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tName],
			VUHDO_DEFAULT_SPELL_TRACE_STORED_SETTINGS
		);
	end

	if (VUHDO_POWER_TYPE_COLORS == nil) then
		VUHDO_POWER_TYPE_COLORS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_POWER_TYPE_COLORS);
	end
	VUHDO_POWER_TYPE_COLORS = VUHDO_ensureSanity("VUHDO_POWER_TYPE_COLORS", VUHDO_POWER_TYPE_COLORS, VUHDO_DEFAULT_POWER_TYPE_COLORS);
	VUHDO_DEFAULT_POWER_TYPE_COLORS = VUHDO_compressAndPackTable(VUHDO_DEFAULT_POWER_TYPE_COLORS);
end



local VUHDO_DEFAULT_PANEL_SETUP = {
	["RAID_ICON_FILTER"] = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
	},

	["HOTS"] = {
		["VERSION"] = 2,
	},

	["PANEL_COLOR"] = {
		["TEXT"] = {
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true,
		},
		["HEALTH_TEXT"] = {
			["useText"] = false,
			["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
		},
		["BARS"] = {
			["R"] = 0.7, ["G"] = 0.7, ["B"] = 0.7, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},
		["classColorsName"] = false,
		["isSolidGradient"] = false,
		["solidMaxColor"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},
	},

	["BAR_COLORS"] = {

		["TARGET"] = {
			["TR"] = 1,	["TG"] = 1,	["TB"] = 1,	["TO"] = 1,
			["R"] = 0,	["G"] = 1,	["B"] = 0,	["O"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
			["modeText"] = 2, -- 1=enemy, 2=solid, 3=class color, 4=gradient
			["modeBack"] = 1,
		},

		["IRRELEVANT"] =  {
			["R"] = 0, ["G"] = 0, ["B"] = 0.4, ["O"] = 0.2,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
			["useClassColor"] = false,
		},
		["INCOMING"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.33,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = false,	["useOpacity"] = true,
			["useClassColor"] = false,
		},
		["SHIELD"] = {
			["R"] = 0.35, ["G"] = 0.52, ["B"] = 1, ["O"] = 1,
			["TR"] = 0.35, ["TG"] = 0.52, ["TB"] = 1, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = true,	["useOpacity"] = true,
			["useClassColor"] = false,
		},
		["OVERSHIELD"] = {
			["R"] = 0.35, ["G"] = 0.52, ["B"] = 1, ["O"] = 1,
			["TR"] = 0.35, ["TG"] = 0.52, ["TB"] = 1, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = true,	["useOpacity"] = true,
			["useClassColor"] = false,
		},
		["HEAL_ABSORB"] = {
			["R"] = 1, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1,
			["TR"] = 0.35, ["TG"] = 0.52, ["TB"] = 1, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = true,	["useOpacity"] = true,
			["useClassColor"] = false,
		},
		["DIRECTION"] = {
			["R"] = 1, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1,
			["useBackground"] = true,
		},
		["EMERGENCY"] = VUHDO_makeFullColor(1, 0, 0, 1,   1, 0.82, 0, 1),
		["NO_EMERGENCY"] = VUHDO_makeFullColor(0, 0, 0.4, 1,   1, 0.82, 0, 1),
		["OFFLINE"] = VUHDO_makeFullColor(0.298, 0.298, 0.298, 0.21,   0.576, 0.576, 0.576, 0.58),
		["DEAD"] = VUHDO_makeFullColor(0.3, 0.3, 0.3, 0.5,   0.5, 0.5, 0.5, 1),
		["OUTRANGED"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
			["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.5,
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
		},
		["TAPPED"] = VUHDO_makeFullColor(0.4, 0.4, 0.4, 1,   0.4, 0.4, 0.4, 1),
		["TARGET_FRIEND"] = VUHDO_makeFullColor(0, 1, 0, 1,   0, 1, 0, 1),
		["TARGET_NEUTRAL"] = VUHDO_makeFullColor(1, 1, 0, 1,   1, 1, 0, 1),
		["TARGET_ENEMY"] = VUHDO_makeFullColor(1, 0, 0, 1,   1, 0, 0, 1),

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_NONE] =  {
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = false,
		},
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_POISON] = VUHDO_makeFullColor(0, 0.592, 0.8, 1,   0, 1, 0.686, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_DISEASE] = VUHDO_makeFullColor(0.8, 0.4, 0.4, 1,   1, 0, 0, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_CURSE] = VUHDO_makeFullColor(0.7, 0, 0.7, 1,   1, 0, 1, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_MAGIC] = VUHDO_makeFullColor(0.4, 0.4, 0.8, 1,   0.329, 0.957, 1, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_CUSTOM] = VUHDO_makeFullColor(0.6, 0.3, 0, 1,   0.8, 0.5, 0, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_BLEED] = VUHDO_makeFullColor(1, 0.2, 0, 1,   1, 0.2, 0.4, 1),
		["DEBUFF" .. VUHDO_DEBUFF_TYPE_ENRAGE] = VUHDO_makeFullColor(0.95, 0.95, 0.32, 1,   1, 1, 0, 1),
		["DEBUFF_BAR_GLOW"] = VUHDO_makeFullColor(0.95, 0.95, 0.32, 1,   1, 1, 0, 1),
		["DEBUFF_ICON_GLOW"] = VUHDO_makeFullColor(0.95, 0.95, 0.32, 1,   1, 1, 0, 1),
		["CHARMED"] = VUHDO_makeFullColor(0.51, 0.082, 0.263, 1,   1, 0.31, 0.31, 1),

		["BAR_FRAMES"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["OVERHEAL_TEXT"] = {
			["TR"] = 0.8, ["TG"] = 1, ["TB"] = 0.8, ["TO"] = 1,
			["useText"] = true, ["useOpacity"] = true,
		},

		["HOTS"] = {
			["useColorText"] = false,
			["useColorBack"] = false,
			["isFadeOut"] = false,
			["isFlashWhenLow"] = false,
			["showShieldAbsorb"] = true,
			["isPumpDivineAegis"] = false,
			["WARNING"] = {
				["R"] = 0.5, ["G"] = 0.2,	["B"] = 0.2, ["O"] = 1,
				["TR"] = 1,	["TG"] = 0.6,	["TB"] = 0.6,	["TO"] = 1,
				["useText"] = true,	["useBackground"] = true,
				["lowSecs"] = 3, ["enabled"] = false,
			},
		},

		["HOT1"] = VUHDO_makeHotColor(1, 0.3, 0.3, 1,   1, 0.6, 0.6, 1),
		["HOT2"] = VUHDO_makeHotColor(1, 1, 0.3, 1,   1, 1, 0.6, 1),
		["HOT3"] = VUHDO_makeHotColor(1, 1, 1, 1,   1, 1, 1, 1),
		["HOT4"] = VUHDO_makeHotColor(0.3, 0.3, 1, 1,   0.6, 0.6, 1, 1),
		["HOT5"] = VUHDO_makeHotColor(1, 0.3, 1, 1,   1, 0.6, 1, 1),

		["HOT6"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT7"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT8"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT9"] = VUHDO_makeHotColor(0.3, 1, 1, 1,   0.6, 1, 1, 1),
		["HOT10"] = VUHDO_makeHotColor(0.3, 1, 0.3, 1,   0.6, 1, 0.3, 1),
		["HOT11"] = VUHDO_makeHotColor(0.890, 0.408, 0.133, 1,   0.992, 0.443, 0.063, 1),
		["HOT12"] = VUHDO_makeHotColor(0.2, 0.576, 0.498, 1,   0.3, 0.676, 0.598, 1),

		["HOT_CHARGE_2"] = VUHDO_makeFullColorWoOpacity(1, 1, 0.3, 1,   1, 1, 0.6, 1),
		["HOT_CHARGE_3"] = VUHDO_makeFullColorWoOpacity(0.3, 1, 0.3, 1,   0.6, 1, 0.6, 1),
		["HOT_CHARGE_4"] = VUHDO_makeFullColorWoOpacity(0.8, 0.8, 0.8, 1,   1, 1, 1, 1),

		["useDebuffIcon"] = false,
		["useDebuffIconBossOnly"] = true,

		["RAID_ICONS"] = {
			["enable"] = false,
			["filterOnly"] = false,

			["1"] = VUHDO_makeFullColorWoOpacity(1, 0.976, 0.305, 1,   0.980,	1, 0.607, 1),
			["2"] = VUHDO_makeFullColorWoOpacity(1, 0.513, 0.039, 1,   1, 0.827, 0.419, 1),
			["3"] = VUHDO_makeFullColorWoOpacity(0.788, 0.290, 0.8, 1,   1, 0.674, 0.921, 1),
			["4"] = VUHDO_makeFullColorWoOpacity(0, 0.8, 0.015, 1,   0.698, 1, 0.698, 1),
			["5"] = VUHDO_makeFullColorWoOpacity(0.466, 0.717, 0.8, 1,   0.725, 0.870, 1, 1),
			["6"] = VUHDO_makeFullColorWoOpacity(0.121, 0.690, 0.972, 1,   0.662, 0.831, 1, 1),
			["7"] = VUHDO_makeFullColorWoOpacity(0.8, 0.184, 0.129, 1,   1, 0.627, 0.619, 1),
			["8"] = VUHDO_makeFullColorWoOpacity(0.847, 0.866, 0.890, 1,   0.231, 0.231, 0.231, 1),
		},

		["CLUSTER_FAIR"] = VUHDO_makeFullColorWoOpacity(0.8, 0.8, 0, 1,   1, 1, 0, 1),
		["CLUSTER_GOOD"] = VUHDO_makeFullColorWoOpacity(0, 0.8, 0, 1,   0, 1, 0, 1),

		["GCD_BAR"] = {
			["R"] = 0.4, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 0.5,
			["useBackground"] = true,
		},

		["LIFE_LEFT"] = {
			["LOW"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
			["FAIR"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
			["GOOD"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
		},

		["THREAT"] = {
			["HIGH"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 1, ["O"] = 1,
				["useBackground"] = true,
			},
			["LOW"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["useBackground"] = true,
			},
		},
	}, -- BAR_COLORS
};



--
local VUHDO_DEFAULT_PER_PANEL_SETUP = {
	["HOTS"] = {
		["size"] = 40,
		["radioValue"] = 13,
		["iconRadioValue"] = 1,
		["stacksRadioValue"] = 2,

		["TIMER_TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 25,
			["Y_ADJUST"] = 0,
			["SCALE"] = 60,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},

		["COUNTER_TEXT"] = {
			["ANCHOR"] = "TOP",
			["X_ADJUST"] = -25,
			["Y_ADJUST"] = 0,
			["SCALE"] = 66,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},

		["SLOTS"] = {
			["firstFlood"] = true,
		},

		["SLOTCFG"] = {
			["firstFlood"] = true,
			["1"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["2"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["3"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["4"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["5"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["6"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["7"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["8"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["9"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["10"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["11"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["12"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
		},

		["BARS"] = {
			["radioValue"] = 1,
			["width"] = 25,
		},
	},
	["MODEL"] = {
		["ordering"] = VUHDO_ORDERING_STRICT,
		["sort"] = VUHDO_SORT_RAID_UNITID,
		["isReverse"] = false,
		["isPetsLast"] = false,
	},
--[[
	["POSITION"] = {
		["x"] = 100,
		["y"] = 668,
		["relativePoint"] = "BOTTOMLEFT",
		["orientation"] = "TOPLEFT",
		["growth"] = "TOPLEFT",
		["width"] = 200,
		["height"] = 200,
		["scale"] = 1,
	};
]]--

	["SCALING"] = {
		["columnSpacing"] = 5,
		["rowSpacing"] = 2,

		["borderGapX"] = 5,
		["borderGapY"] = 5,

		["barWidth"] = 80,
		["barHeight"] = 40,

		["showHeaders"] = true,
		["headerHeight"] = 12,
		["headerWidth"] = 100,
		["headerSpacing"] = 5,

		["manaBarHeight"] = 6,
		["sideLeftWidth"] = 6,
		["sideRightWidth"] = 6,

		["maxColumnsWhenStructured"] = 10,
		["maxRowsWhenLoose"] = 5,
		["ommitEmptyWhenStructured"] = true,
		["isPlayerOnTop"] = true,

		["showTarget"] = false,
		["targetSpacing"] = 3,
		["targetWidth"] = 30,

		["showTot"] = false,
		["totSpacing"] = 3,
		["totWidth"] = 30,
		["targetOrientation"] = 1,

		["isTarClassColText"] = true,
		["isTarClassColBack"] = false,

		["arrangeHorizontal"] = false,
		["alignBottom"] = false,

		["scale"] = 1,

		["isDamFlash"] = true,
		["damFlashFactor"] = 0.75,
	},

	["LIFE_TEXT"] = {
		["show"] = true,
		["mode"] = VUHDO_LT_MODE_PERCENT,
		["position"] = VUHDO_LT_POS_ABOVE,
		["verbose"] = false,
		["hideIrrelevant"] = false,
		["showTotalHp"] = false,
		["showEffectiveHp"] = false,
	},

	["ID_TEXT"] = {
		["showName"] = true, 
		["showNickname"] = false,
		["showClass"] = false,
		["showTags"] = true,
		["showPetOwners"] = true,
		["position"] = "CENTER+CENTER",
		["xAdjust"] = 0.000001,
		["yAdjust"] = 0.000001,
	},

	["PANEL_COLOR"] = {
		["barTexture"] = "VuhDo - Polished Wood",

		["BACK"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.35,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["BORDER"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.46,
			["useBackground"] = true, ["useOpacity"] = true,
			["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
			["edgeSize"] = 8,
			["insets"] = 1,
		},

		["TEXT"] = {
			["useText"] = true, ["useOpacity"] = true,
			["textSize"] = 10,
			["textSizeLife"] = 8,
			["maxChars"] = 0,
			["outline"] = false,
			["USE_SHADOW"] = true,
			["USE_MONO"] = false,
		},

		["HEADER"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.4,
			["TR"] = 1, ["TG"] = 0.859, ["TB"] = 0.38, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true,
			["barTexture"] = "LiteStepLite",
			["textSize"] = 10,
		},
	},

	["TOOLTIP"] = {
		["show"] = true,
		["position"] = 2, -- Standard-Pos
		["inFight"] = false,
		["showBuffs"] = false,
		["x"] = 100,
		["y"] = -100,
		["point"] = "TOPLEFT",
		["relativePoint"] = "TOPLEFT",
		["SCALE"] = 1,

		["BACKGROUND"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["BORDER"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},
	},

	["PRIVATE_AURA"] = {
		["show"] = true,
		["scale"] = 0.8,
		["point"] = "LEFT",
		["xAdjust"] = 5,
		["yAdjust"] = 0,
	},

	["RAID_ICON"] = {
		["show"] = true,
		["scale"] = 1,
		["point"] = "TOP",
		["xAdjust"] = 0,
		["yAdjust"] = -20,
	},

	["OVERHEAL_TEXT"] = {
		["show"] = true,
		["scale"] = 1,
		["point"] = "LEFT",
		["xAdjust"] = 0,
		["yAdjust"] = 0,
	},

	["frameStrata"] = "MEDIUM",
};



--
function VUHDO_loadDefaultPanelSetup()
	local tAktPanel;

	if not VUHDO_PANEL_SETUP then
		VUHDO_PANEL_SETUP = VUHDO_decompressOrCopy(VUHDO_DEFAULT_PANEL_SETUP);
	end

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if not VUHDO_PANEL_SETUP[tPanelNum] then
			VUHDO_PANEL_SETUP[tPanelNum] = VUHDO_decompressOrCopy(VUHDO_DEFAULT_PER_PANEL_SETUP);

			tAktPanel = VUHDO_PANEL_SETUP[tPanelNum];
			tAktPanel["MODEL"]["groups"] = VUHDO_DEFAULT_MODELS[tPanelNum];

			if VUHDO_DEFAULT_MODELS[tPanelNum] and VUHDO_ID_PRIVATE_TANKS == VUHDO_DEFAULT_MODELS[tPanelNum][1] then
				tAktPanel["SCALING"]["ommitEmptyWhenStructured"] = false;
			end

			if GetLocale() == "zhCN" or GetLocale() == "zhTW" or GetLocale() == "koKR" then
				tAktPanel["PANEL_COLOR"]["TEXT"]["font"] = "";
				tAktPanel["PANEL_COLOR"]["HEADER"]["font"] = "";
			else
				tAktPanel["PANEL_COLOR"]["TEXT"]["font"] = VUHDO_LibSharedMedia:Fetch('font', "Emblem");
				tAktPanel["PANEL_COLOR"]["HEADER"]["font"] = VUHDO_LibSharedMedia:Fetch('font', "Emblem");
			end

			if VUHDO_DEFAULT_MODELS[tPanelNum] and VUHDO_ID_MAINTANKS == VUHDO_DEFAULT_MODELS[tPanelNum][1] then
				tAktPanel["PANEL_COLOR"]["TEXT"]["textSize"] = 12;
			end
		end

		if not VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] and tPanelNum == 1 then
			VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] = {
				["x"] = 130,
				["y"] = 650,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["growth"] = "TOPLEFT",
				["width"] = 200,
				["height"] = 200,
				["scale"] = 1,
			};
		elseif not VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] and tPanelNum == 2 then
			VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] = {
				["x"] = 130,
				["y"] = 885,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["growth"] = "TOPLEFT",
				["width"] = 200,
				["height"] = 200,
				["scale"] = 1,
			};
		elseif not VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] then
			VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] = {
				["x"] = 130 + 75 * tPanelNum,
				["y"] = 650 - 75 * tPanelNum,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["growth"] = "TOPLEFT",
				["width"] = 200,
				["height"] = 200,
				["scale"] = 1,
			};
		end

		if VUHDO_PANEL_SETUP["HOTS"] and not VUHDO_PANEL_SETUP["HOTS"]["VERSION"] then
			local tHotSize;

			tAktPanel = VUHDO_PANEL_SETUP[tPanelNum];

			if tAktPanel["HOTS"] and tAktPanel["HOTS"]["size"] then
				tHotSize = tAktPanel["HOTS"]["size"];
			end

			tAktPanel["HOTS"] = VUHDO_decompressOrCopy(VUHDO_PANEL_SETUP["HOTS"]);

			if tHotSize then
				tAktPanel["HOTS"]["size"] = tHotSize;
			end
		end

		VUHDO_PANEL_SETUP[tPanelNum] = VUHDO_ensureSanity("VUHDO_PANEL_SETUP[" .. tPanelNum .. "]", VUHDO_PANEL_SETUP[tPanelNum], VUHDO_DEFAULT_PER_PANEL_SETUP);
	end

	if VUHDO_PANEL_SETUP["HOTS"] and not VUHDO_PANEL_SETUP["HOTS"]["VERSION"] then
		VUHDO_PANEL_SETUP["HOTS"] = nil;
	end

	VUHDO_PANEL_SETUP = VUHDO_ensureSanity("VUHDO_PANEL_SETUP", VUHDO_PANEL_SETUP, VUHDO_DEFAULT_PANEL_SETUP);
	VUHDO_DEFAULT_PANEL_SETUP = VUHDO_compressAndPackTable(VUHDO_DEFAULT_PANEL_SETUP);
	VUHDO_DEFAULT_PER_PANEL_SETUP = VUHDO_compressAndPackTable(VUHDO_DEFAULT_PER_PANEL_SETUP);

	VUHDO_fixHotSettings();
end



local VUHDO_DEFAULT_BUFF_CONFIG = {
  ["VERSION"] = 4,
	["SHOW"] = true,
	["COMPACT"] = true,
	["SHOW_LABEL"] = false,
	["BAR_COLORS_TEXT"] = true,
	["BAR_COLORS_BACKGROUND"] = true,
	["BAR_COLORS_IN_FIGHT"] = false,
	["HIDE_CHARGES"] = false,
	["REFRESH_SECS"] = 2,
	["POSITION"] = {
		["x"] = 130,
		["y"] = -130,
		["point"] = "TOPLEFT",
		["relativePoint"] = "TOPLEFT",
	},
	["SCALE"] = 1,
	["PANEL_MAX_BUFFS"] = 5,
	["PANEL_BG_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 0.5,
		["useBackground"] = true,
	},
	["PANEL_BORDER_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 0.5,
		["useBackground"] = true,
	},
	["SWATCH_BG_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 1,
		["useBackground"] = true,
	},
	["SWATCH_BORDER_COLOR"] = {
		["R"] = 0.8, ["G"] = 0.8,	["B"] = 0.8, ["O"] = 0,
		["useBackground"] = true,
	},
	["REBUFF_AT_PERCENT"] = 25,
	["REBUFF_MIN_MINUTES"] = 3,
	["HIGHLIGHT_COOLDOWN"] = true,
	["WHEEL_SMART_BUFF"] = false,

	["SWATCH_COLOR_BUFF_OKAY"]     = VUHDO_makeFullColor(0,   0,   0,   1,   0,   0.8, 0,   1),
	["SWATCH_COLOR_BUFF_LOW"]      = VUHDO_makeFullColor(0,   0,   0,   1,   1,   0.7, 0,   1),
	["SWATCH_COLOR_BUFF_OUT"]      = VUHDO_makeFullColor(0,   0,   0,   1,   0.8, 0,   0,   1),
	["SWATCH_COLOR_BUFF_COOLDOWN"] = VUHDO_makeFullColor(0.3, 0.3, 0.3, 1,   0.6, 0.6, 0.6, 1),
}



VUHDO_DEFAULT_USER_CLASS_COLORS = {
	[VUHDO_ID_DRUIDS]        = VUHDO_makeFullColor(1,    0.49, 0.04, 1,   1,    0.6,  0.04, 1),
	[VUHDO_ID_HUNTERS]       = VUHDO_makeFullColor(0.67, 0.83, 0.45, 1,   0.77, 0.93, 0.55, 1),
	[VUHDO_ID_MAGES]         = VUHDO_makeFullColor(0.41, 0.8,  0.94, 1,   0.51, 0.9,  1,    1),
	[VUHDO_ID_PALADINS]      = VUHDO_makeFullColor(0.96, 0.55, 0.73, 1,   1,    0.65, 0.83, 1),
	[VUHDO_ID_PRIESTS]       = VUHDO_makeFullColor(0.9,  0.9,  0.9,  1,   1,    1,    1,    1),
	[VUHDO_ID_ROGUES]        = VUHDO_makeFullColor(1,    0.96, 0.41, 1,   1,    1,    0.51, 1),
	[VUHDO_ID_SHAMANS]       = VUHDO_makeFullColor(0.14, 0.35, 1,    1,   0.24, 0.45, 1,    1),
	[VUHDO_ID_WARLOCKS]      = VUHDO_makeFullColor(0.58, 0.51, 0.79, 1,   0.68, 0.61, 0.89, 1),
	[VUHDO_ID_WARRIORS]      = VUHDO_makeFullColor(0.78, 0.61, 0.43, 1,   0.88, 0.71, 0.53, 1),
	[VUHDO_ID_DEATH_KNIGHT]  = VUHDO_makeFullColor(0.77, 0.12, 0.23, 1,   0.87, 0.22, 0.33, 1),
	[VUHDO_ID_MONKS]         = VUHDO_makeFullColor(0,    1,    0.59, 1,   0,    1,    0.69, 1),
	[VUHDO_ID_DEMON_HUNTERS] = VUHDO_makeFullColor(0.54, 0.09, 0.69, 1,   0.64, 0.19, 0.79, 1),
	[VUHDO_ID_EVOKERS]       = VUHDO_makeFullColor(0.10, 0.48, 0.40, 1,   0.20, 0.58, 0.50, 1),
	[VUHDO_ID_PETS]          = VUHDO_makeFullColor(0.4,  0.6,  0.4,  1,   0.5,  0.9,  0.5,  1),
	["petClassColor"] = false,
}

-- Gradient Color "min":

-- DK: 0.498, 0.075, 0.149
-- DH: 0.365, 0.137, 0.573
-- DD: 1, 0.239, 0.008
-- EV: 0.196, 0.467, 0.537
-- HU: 0.404, 0.537, 0.224
-- MA: 0, 0.333, 0.537
-- MO: 0.016, 0.608, 0.369
-- PA: 1, 0.267, 0.537
-- PR: 0.357, 0.357, 0.357
-- SH: 0, 0.259, 0.51
-- WA: 0.263, 0.267, 0.467
-- WR: 0.427, 0.137, 0.09
-- RO: 1, 0.686, 0

-- Gradient Color 'max":

-- DK: 1, 0.184, 0.239
-- DH: 0.745, 0.192, 1
-- DD: 1, 0.486, 0.039
-- EV: 0.2, 0.576, 0.498
-- HU: 0.671, 0.929, 0.31
-- MA: 0.49, 0.871, 1
-- MO: 0, 1, 0.588
-- PA: 0.957, 0.549, 0.729
-- PR: 0.988, 0.988, 0.988
-- SH: 0, 0.439, 0.871
-- WA: 0.663, 0.392, 0.784
-- WR: 0.565, 0.431, 0.247
-- RO: 1, 0.831, 0.255

VUHDO_DEFAULT_USER_CLASS_GRADIENT_COLORS = {
	[VUHDO_ID_DRUIDS] = {
		["min"] = VUHDO_makeFullColor(1,    0.24, 0.01, 1,   1,    0.6,  0.04, 1),
		["max"] = VUHDO_makeFullColor(1,    0.49, 0.04, 1,   1,    0.6,  0.04, 1),
	},
	[VUHDO_ID_HUNTERS] = {
		["min"] = VUHDO_makeFullColor(0.40, 0.54, 0.22, 1,   0.77, 0.93, 0.55, 1),
		["max"] = VUHDO_makeFullColor(0.67, 0.93, 0.31, 1,   0.77, 0.93, 0.55, 1),
	},
	[VUHDO_ID_MAGES] = {
		["min"] = VUHDO_makeFullColor(0,    0.33, 0.54, 1,   0.51, 0.9,  1,    1),
		["max"] = VUHDO_makeFullColor(0.49, 0.87, 1,    1,   0.51, 0.9,  1,    1),
	},
	[VUHDO_ID_PALADINS] = {
		["min"] = VUHDO_makeFullColor(1,    0.28, 0.54, 1,   1,    0.65, 0.83, 1),
		["max"] = VUHDO_makeFullColor(0.96, 0.55, 0.73, 1,   1,    0.65, 0.83, 1),
	},
	[VUHDO_ID_PRIESTS] = {
		["min"] = VUHDO_makeFullColor(0.36, 0.36, 0.36, 1,   1,    1,    1,    1),
		["max"] = VUHDO_makeFullColor(0.99, 0.99, 0.99, 1,   1,    1,    1,    1),
	},
	[VUHDO_ID_ROGUES] = {
		["min"] = VUHDO_makeFullColor(1,    0.69, 0,    1,   1,    1,    0.51, 1),
		["max"] = VUHDO_makeFullColor(1,    0.83, 0.26, 1,   1,    1,    0.51, 1),
	},
	[VUHDO_ID_SHAMANS] = {
		["min"] = VUHDO_makeFullColor(0,    0.26, 0.51, 1,   0.24, 0.45, 1,    1),
		["max"] = VUHDO_makeFullColor(0,    0.44, 0.87, 1,   0.24, 0.45, 1,    1),
	},
	[VUHDO_ID_WARLOCKS] = {
		["min"] = VUHDO_makeFullColor(0.26, 0.27, 0.47, 1,   0.68, 0.61, 0.89, 1),
		["max"] = VUHDO_makeFullColor(0.66, 0.39, 0.78, 1,   0.68, 0.61, 0.89, 1),
	},
	[VUHDO_ID_WARRIORS] = {
		["min"] = VUHDO_makeFullColor(0.43, 0.14, 0.09, 1,   0.88, 0.71, 0.53, 1),
		["max"] = VUHDO_makeFullColor(0.57, 0.43, 0.25, 1,   0.88, 0.71, 0.53, 1),
	},
	[VUHDO_ID_DEATH_KNIGHT] = {
		["min"] = VUHDO_makeFullColor(0.5,  0.08, 0.15, 1,   0.87, 0.22, 0.33, 1),
		["max"] = VUHDO_makeFullColor(1,    0.18, 0.24, 1,   0.87, 0.22, 0.33, 1),
	},
	[VUHDO_ID_MONKS] = {
		["min"] = VUHDO_makeFullColor(0.02, 0.61, 0.37, 1,   0,    1,    0.69, 1),
		["max"] = VUHDO_makeFullColor(0,    1,    0.59, 1,   0,    1,    0.69, 1),
	},
	[VUHDO_ID_DEMON_HUNTERS] = {
		["min"] = VUHDO_makeFullColor(0.37, 0.14, 0.57, 1,   0.64, 0.19, 0.79, 1),
		["max"] = VUHDO_makeFullColor(0.75, 0.19, 1,    1,   0.64, 0.19, 0.79, 1),
	},
	[VUHDO_ID_EVOKERS] = {
		["min"] = VUHDO_makeFullColor(0.2,  0.47, 0.54, 1,   0.20, 0.58, 0.50, 1),
		["max"] = VUHDO_makeFullColor(0.2,  0.58, 0.5,  1,   0.20, 0.58, 0.50, 1),
	},
	[VUHDO_ID_PETS] = {
		["min"] = VUHDO_makeFullColor(0.4,  0.6,  0.4,  1,   0.5,  0.9,  0.5,  1),
		["max"] = VUHDO_makeFullColor(0.4,  0.6,  0.4,  1,   0.5,  0.9,  0.5,  1),
	},
	["isClassGradient"] = false,
};



--
function VUHDO_initClassColors()

	if not VUHDO_USER_CLASS_COLORS then
		VUHDO_USER_CLASS_COLORS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_USER_CLASS_COLORS);
	end

	VUHDO_USER_CLASS_COLORS = VUHDO_ensureSanity("VUHDO_USER_CLASS_COLORS", VUHDO_USER_CLASS_COLORS, VUHDO_DEFAULT_USER_CLASS_COLORS);
	VUHDO_DEFAULT_USER_CLASS_COLORS = VUHDO_compressAndPackTable(VUHDO_DEFAULT_USER_CLASS_COLORS);

	if not VUHDO_USER_CLASS_GRADIENT_COLORS then
		VUHDO_USER_CLASS_GRADIENT_COLORS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_USER_CLASS_GRADIENT_COLORS);
	end

	VUHDO_USER_CLASS_GRADIENT_COLORS = VUHDO_ensureSanity("VUHDO_USER_CLASS_GRADIENT_COLORS", VUHDO_USER_CLASS_GRADIENT_COLORS, VUHDO_DEFAULT_USER_CLASS_GRADIENT_COLORS);
	VUHDO_DEFAULT_USER_CLASS_GRADIENT_COLORS = VUHDO_compressAndPackTable(VUHDO_DEFAULT_USER_CLASS_GRADIENT_COLORS);

end



--
local function VUHDO_getFirstFreeBuffOrder()
	for tCnt = 1, 10000 do
		if not VUHDO_tableGetKeyFromValue(VUHDO_BUFF_ORDER, tCnt) then
			return tCnt;
		end
	end

	return nil;
end



--
local function VUHDO_fixBuffOrder()
	local _, tPlayerClass = UnitClass("player");
	local tAllBuffs = VUHDO_CLASS_BUFFS[tPlayerClass];
	local tSortArray = {};

	-- Order ohne buff?
	for tCategName, _ in pairs(VUHDO_BUFF_ORDER) do
		if not tAllBuffs[tCategName] then
			VUHDO_BUFF_ORDER[tCategName] = nil;
		end
	end

	-- Buffs ohne order?
	for tCategName, _ in pairs(tAllBuffs) do
		if not VUHDO_BUFF_ORDER[tCategName] then
			VUHDO_BUFF_ORDER[tCategName] = VUHDO_getFirstFreeBuffOrder();
		end

		tinsert(tSortArray, tCategName);
	end

	table.sort(tSortArray, function(aCateg, anotherCateg) return VUHDO_BUFF_ORDER[aCateg] < VUHDO_BUFF_ORDER[anotherCateg] end);
	table.wipe(VUHDO_BUFF_ORDER);
	for tIndex, tCateg in ipairs(tSortArray) do
		VUHDO_BUFF_ORDER[tCateg] = tIndex;
	end

end



--
function VUHDO_initBuffSettings()
	if not VUHDO_BUFF_SETTINGS["CONFIG"] then
		VUHDO_BUFF_SETTINGS["CONFIG"] = VUHDO_decompressOrCopy(VUHDO_DEFAULT_BUFF_CONFIG);
	end

	VUHDO_BUFF_SETTINGS["CONFIG"] = VUHDO_ensureSanity("VUHDO_BUFF_SETTINGS.CONFIG", VUHDO_BUFF_SETTINGS["CONFIG"], VUHDO_DEFAULT_BUFF_CONFIG);
	VUHDO_DEFAULT_BUFF_CONFIG = VUHDO_compressAndPackTable(VUHDO_DEFAULT_BUFF_CONFIG);

	local _, tPlayerClass = UnitClass("player");
	for tCategSpec, _ in pairs(VUHDO_CLASS_BUFFS[tPlayerClass]) do

		if not VUHDO_BUFF_SETTINGS[tCategSpec] then
			VUHDO_BUFF_SETTINGS[tCategSpec] = {
				["enabled"] = false,
				["missingColor"] = {
					["show"] = false,
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				}
			};
		end

		if not VUHDO_BUFF_SETTINGS[tCategSpec]["filter"] then
			VUHDO_BUFF_SETTINGS[tCategSpec]["filter"] = { [VUHDO_ID_ALL] = true };
		end
	end

	VUHDO_fixBuffOrder();
end
