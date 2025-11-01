--
local tLayoutPanelHots;
function VUHDO_activateLayoutLoadHotsForPanel(aName, aPanelNum)

	if not aName or not aPanelNum or not VUHDO_SPELL_LAYOUTS or not VUHDO_SPELL_LAYOUTS[aName] or
		not VUHDO_SPELL_LAYOUTS[aName]["HOTS"] or not VUHDO_SPELL_CONFIG or not VUHDO_SPELL_CONFIG["IS_LOAD_HOTS"] then
		return;
	end

	-- support for pre per-panel HoTs
	if type(VUHDO_SPELL_LAYOUTS[aName]["HOTS"]) == "table" then
		tLayoutPanelHots = VUHDO_decompressOrCopy(VUHDO_SPELL_LAYOUTS[aName]["HOTS"][aPanelNum]);

		if VUHDO_SPELL_CONFIG["IS_LOAD_HOTS_ONLY_SLOTS"] then
			VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["SLOTS"] = tLayoutPanelHots["SLOTS"];

			for tSlotNum, tSlotConfig in pairs(tLayoutPanelHots["SLOTCFG"]) do
				VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["SLOTCFG"][tSlotNum]["mine"] = tSlotConfig["mine"];
			end
		else
			VUHDO_PANEL_SETUP[aPanelNum]["HOTS"] = tLayoutPanelHots;
		end
	else
		VUHDO_PANEL_SETUP[aPanelNum]["HOTS"] = VUHDO_decompressOrCopy(VUHDO_SPELL_LAYOUTS[aName]["HOTS"]);
	end

end



--
function VUHDO_activateLayoutNoInit(aName)

	VUHDO_SPELL_ASSIGNMENTS = VUHDO_decompressOrCopy(VUHDO_SPELL_LAYOUTS[aName]["MOUSE"]);
	VUHDO_HOSTILE_SPELL_ASSIGNMENTS = VUHDO_decompressOrCopy(VUHDO_SPELL_LAYOUTS[aName]["HOSTILE_MOUSE"]);

	for tPanelNum = 1, VUHDO_MAX_PANELS do
		VUHDO_activateLayoutLoadHotsForPanel(aName, tPanelNum);
	end

	VUHDO_SPELLS_KEYBOARD = VUHDO_decompressOrCopy(VUHDO_SPELL_LAYOUTS[aName]["KEYS"]);

	if VUHDO_SPELL_LAYOUTS[aName]["FIRE"] then
		VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["T1"];
		VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["T2"];
		VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_1"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I1"];
		VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_2"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I2"];
		VUHDO_SPELL_CONFIG["FIRE_CUSTOM_1_SPELL"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I1N"];
		VUHDO_SPELL_CONFIG["FIRE_CUSTOM_2_SPELL"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I2N"];
		VUHDO_SPELL_CONFIG["IS_FIRE_GLOVES"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["T3"];
		VUHDO_SPELL_CONFIG["custom1Unit"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I1U"];
		VUHDO_SPELL_CONFIG["custom2Unit"] = VUHDO_SPELL_LAYOUTS[aName]["FIRE"]["I2U"];
	end

	VUHDO_SPEC_LAYOUTS["selected"] = aName;
	VUHDO_Msg("Key layout \"" .. aName .. "\" loaded.");

end



--
function VUHDO_activateLayout(aName)

	VUHDO_activateLayoutNoInit(aName);

	VUHDO_loadVariables();
	VUHDO_initAllBurstCaches();
	VUHDO_initFromSpellbook();
	VUHDO_registerAllBouquets(false);
	VUHDO_initBuffs();
	VUHDO_initDebuffs();
	VUHDO_initKeyboardMacros();
	VUHDO_timeReloadUI(1);

end
