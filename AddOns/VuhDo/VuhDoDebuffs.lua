local huge = math.huge;



local VUHDO_CUSTOM_DEBUFF_CONFIG = { };
local VUHDO_UNIT_CUSTOM_DEBUFFS = { };
setmetatable(VUHDO_UNIT_CUSTOM_DEBUFFS, VUHDO_META_NEW_ARRAY);
local VUHDO_LAST_UNIT_DEBUFFS = { };
local VUHDO_PLAYER_ABILITIES = { };



local VUHDO_IGNORE_DEBUFFS_BY_CLASS = { };
local VUHDO_IGNORE_DEBUFF_NAMES = { };



--
local VUHDO_DEBUFF_TYPES = {
	["Magic"] = VUHDO_DEBUFF_TYPE_MAGIC,
	["Disease"] = VUHDO_DEBUFF_TYPE_DISEASE,
	["Poison"] = VUHDO_DEBUFF_TYPE_POISON,
	["Curse"] = VUHDO_DEBUFF_TYPE_CURSE
};




VUHDO_DEBUFF_BLACKLIST = {
--	[GetSpellInfo(69127)] = true, -- Chill of the Throne
--	[GetSpellInfo(57724)] = true, -- Sated (Bloodlust)
--	[GetSpellInfo(71328)] = true, -- Dungeon Cooldown
--	[GetSpellInfo(57723)] = true, -- Exhaustion (Heroism)
--	[GetSpellInfo(80354)] = true, -- Temporal Displacement (Time Warp)
--	[VUHDO_SPELL_ID.DEBUFF_FATIGUED] = true -- Fatigued (Primal Fury)
};





-- BURST CACHE ---------------------------------------------------

local VUHDO_CONFIG;
local VUHDO_RAID;
local VUHDO_PANEL_SETUP;
local VUHDO_DEBUFF_COLORS = { };

local VUHDO_shouldScanUnit;
local VUHDO_DEBUFF_BLACKLIST = { };

local UnitIsFriend = UnitIsFriend;
local table = table;
local GetTime = GetTime;
local PlaySoundFile = PlaySoundFile;
local InCombatLockdown = InCombatLockdown;
local twipe = table.wipe;
local pairs = pairs;
local _;
local tostring = tostring;
local ForEachAura = AuraUtil.ForEachAura or VUHDO_forEachAura;
local UnpackAuraData = AuraUtil.UnpackAuraData or VUHDO_unpackAuraData;

local sIsNotRemovableOnly;
local sIsNotRemovableOnlyIcons;
local sIsUseDebuffIcon;
local sIsUseDebuffIconBossOnly;
local sIsMiBuColorsInFight;
local sStdDebuffSound;
local sAllDebuffSettings;
local sIsShowOnlyForFriendly;
local sEmpty = { };
--local sColorArray = nil;

function VUHDO_debuffsInitLocalOverrides()
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_DEBUFF_BLACKLIST = _G["VUHDO_DEBUFF_BLACKLIST"];

	VUHDO_shouldScanUnit = _G["VUHDO_shouldScanUnit"];

	sIsNotRemovableOnly = not VUHDO_CONFIG["DETECT_DEBUFFS_REMOVABLE_ONLY"];
	sIsNotRemovableOnlyIcons = not VUHDO_CONFIG["DETECT_DEBUFFS_REMOVABLE_ONLY_ICONS"];
	sIsUseDebuffIcon = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIcon"];
	sIsUseDebuffIconBossOnly = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIconBossOnly"];
	sIsMiBuColorsInFight = VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_IN_FIGHT"];
	sStdDebuffSound = VUHDO_CONFIG["SOUND_DEBUFF"];
	sAllDebuffSettings = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"];
	sIsShowOnlyForFriendly = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowOnlyForFriendly"];

	VUHDO_DEBUFF_COLORS = {
		[1] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF1"],
		[2] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF2"],
		[3] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF3"],
		[4] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF4"],
		[6] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF6"],
	};

	--[[if not sColorArray then
		sColorArray = { };
		for tCnt = 1, 40 do
			sColorArray[tCnt] = { };
		end
	end]]
end

----------------------------------------------------



--
local function VUHDO_copyColorTo(aSource, aDest)
	aDest["R"], aDest["G"], aDest["B"] = aSource["R"], aSource["G"], aSource["B"];
	aDest["TR"], aDest["TG"], aDest["TB"] = aSource["TR"], aSource["TG"], aSource["TB"];
	aDest["O"], aDest["TO"] = aSource["O"], aSource["TO"];
	aDest["useText"], aDest["useBackground"], aDest["useOpacity"] = aSource["useText"], aSource["useBackground"], aSource["useOpacity"];
	return aDest;
end



--
local tSourceColor;
local tDebuffSettings;
local tDebuff;
local tColor = { };
local tEmpty = { };
function _VUHDO_getDebuffColor(anInfo)

	if anInfo["charmed"] then
		return VUHDO_PANEL_SETUP["BAR_COLORS"]["CHARMED"];
	end

	tDebuff = anInfo["debuff"];

	if not anInfo["mibucateg"] and (tDebuff or 0) == 0 then -- VUHDO_DEBUFF_TYPE_NONE
		return tEmpty;
	end

	if (tDebuff or 6) ~= 6 and VUHDO_DEBUFF_COLORS[tDebuff] then -- VUHDO_DEBUFF_TYPE_CUSTOM
		return VUHDO_DEBUFF_COLORS[tDebuff];
	end

	tDebuffSettings = sAllDebuffSettings[anInfo["debuffName"]];

	if tDebuff == 6 and tDebuffSettings ~= nil -- VUHDO_DEBUFF_TYPE_CUSTOM
		and tDebuffSettings["isColor"] then
		if tDebuffSettings["color"] ~= nil then
			tSourceColor = tDebuffSettings["color"];
		else
			tSourceColor = VUHDO_DEBUFF_COLORS[6];
		end

		twipe(tColor);

		if VUHDO_DEBUFF_COLORS[6]["useBackground"] then
			tColor["R"], tColor["G"], tColor["B"], tColor["O"], tColor["useBackground"] = tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"], true;
		end

		if VUHDO_DEBUFF_COLORS[6]["useText"] then
			tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"], tColor["useText"] = tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"], true;
		end

		return tColor;
	end

	if not anInfo["mibucateg"] or not VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]] then	return tEmpty; end

	tSourceColor = VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]]["missingColor"];
	twipe(tColor);
	if VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_TEXT"] then
		tColor["useText"], tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"] = true, tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"];
	end

	if VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_BACKGROUND"] then
		tColor["useBackground"], tColor["R"], tColor["G"], tColor["B"], tColor["O"] = true, tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"];
	end

	return tColor;
end



--
local tCopy = { };
function VUHDO_getDebuffColor(anInfo)
	return VUHDO_copyColorTo(_VUHDO_getDebuffColor(anInfo), tCopy);
end



--
local tNextSoundTime = 0;
local function VUHDO_playDebuffSound(aSound, aDebuffName)
	if (aSound or "") == "" or GetTime() < tNextSoundTime then
		return;
	end

	local tSuccess = VUHDO_playSoundFile(aSound);

	if tSuccess then
		tNextSoundTime = GetTime() + 2;
	else
		if aDebuffName then
			VUHDO_Msg(format(VUHDO_I18N_PLAY_SOUND_FILE_CUSTOM_DEBUFF_ERR, aSound, aDebuffName));
		else
			VUHDO_Msg(format(VUHDO_I18N_PLAY_SOUND_FILE_DEBUFF_ERR, aSound));
		end
	end
end



--
local tIconIndex = 0;
local tIconArray;
local tIconArrayDispenser = { };
local function VUHDO_getOrCreateIconArray(anIcon, aExpiry, aStacks, aDuration, anIsBuff, aSpellId, aCnt)
	tIconIndex = tIconIndex + 1;
	if #tIconArrayDispenser < tIconIndex then
		tIconArray = { anIcon, aExpiry, aStacks, aDuration, anIsBuff, aSpellId, aCnt };
		tIconArrayDispenser[tIconIndex] = tIconArray;
	else
		tIconArray = tIconArrayDispenser[tIconIndex];
		tIconArray[1], tIconArray[2], tIconArray[3], tIconArray[4], tIconArray[5], tIconArray[6], tIconArray[7] 
			= anIcon, aExpiry, aStacks, aDuration, anIsBuff, aSpellId, aCnt;
	end

	return tIconArray;
end



--
function VUHDO_resetDebuffIconDispenser()
	twipe(tIconArrayDispenser);
	tIconIndex = 0;
end



--
local VUHDO_UNIT_DEBUFF_INFOS = { };
setmetatable(VUHDO_UNIT_DEBUFF_INFOS, {
	__index = function(aTable, aKey)
	  local tValue = {
			["CHOSEN"] = { [1] = nil, [2] = 0 },
			[VUHDO_DEBUFF_TYPE_POISON] = { },
			[VUHDO_DEBUFF_TYPE_DISEASE] = { },
			[VUHDO_DEBUFF_TYPE_MAGIC] = { },
			[VUHDO_DEBUFF_TYPE_CURSE] = { },
		};

		rawset(aTable, aKey, tValue);
		return tValue;
	end
});



local sCurChosenType;
local sCurChosenName;
local sCurChosenSpellId;
local sCurIsStandard;
local sCurIcons = { };

local tUnitDebuffInfo;
local function VUHDO_initDebuffInfos(aUnit)
	tUnitDebuffInfo = VUHDO_UNIT_DEBUFF_INFOS[aUnit];
	tUnitDebuffInfo[1][2] = nil; -- VUHDO_DEBUFF_TYPE_POISON
	tUnitDebuffInfo[2][2] = nil; -- VUHDO_DEBUFF_TYPE_DISEASE
	tUnitDebuffInfo[3][2] = nil; -- VUHDO_DEBUFF_TYPE_MAGIC
	tUnitDebuffInfo[4][2] = nil; -- VUHDO_DEBUFF_TYPE_CURSE

	sCurChosenType = VUHDO_DEBUFF_TYPE_NONE;
	sCurChosenName = "";
	sCurChosenSpellId = nil;
	sCurIsStandard = false;
	tIconIndex = 0;
	twipe(sCurIcons);

	return tUnitDebuffInfo;
end



--
local tCnt = 0;
local tName, tIcon, tStacks, tTypeString, tDuration, tExpiry, tUnitCaster, tSpellId, tIsBossDebuff;
local tNow;
local tDebuffConfig;
local tInfo;
local tUnit;
local tType;
local tAbility;
local tIsRelevant;
local tSchool;
local tRemaining;
local tUnitDebuffInfo;
local function VUHDO_determineDebuffPredicate(anAuraData)

	tName, tIcon, tStacks, tTypeString, tDuration, tExpiry, tUnitCaster, _, _, tSpellId, _, tIsBossDebuff = UnpackAuraData(anAuraData);

	if not tIcon then
		return;
	end

	if (tExpiry or 0) == 0 then
		tExpiry = (sCurIcons[tName] or sEmpty)[2] or tNow;
	end

	-- Custom Debuff?
	tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[tName] or VUHDO_CUSTOM_DEBUFF_CONFIG[tostring(tSpellId)] or sEmpty;

	if tDebuffConfig[1] and ((tDebuffConfig[3] and tUnitCaster == "player") or (tDebuffConfig[4] and tUnitCaster ~= "player")) then -- Color?
		sCurChosenType, sCurChosenName, sCurChosenSpellId = 6, tName, tSpellId; -- VUHDO_DEBUFF_TYPE_CUSTOM
	end

	tStacks = tStacks or 0;

	if sCurIcons[tName] then
		-- if we de-dupe a debuff by name then ensure it is tracked as another "stack"
		-- oddly by default UnitAura returns a "stack" of 0 for un-stackable debuffs
		-- in the common case (no de-dupe by name) we'll retain this default
		if tStacks == 0 then
			tStacks = 1;
		end

		if sCurIcons[tName][3] > 0 then
			tStacks = tStacks + sCurIcons[tName][3];
		else
			tStacks = tStacks + 1;
		end
	end

	if tDebuffConfig[2] and ((tDebuffConfig[3] and tUnitCaster == "player") or (tDebuffConfig[4] and tUnitCaster ~= "player")) then -- Icon?
		sCurIcons[tName] = VUHDO_getOrCreateIconArray(tIcon, tExpiry, tStacks, tDuration, false, tSpellId, tCnt);
	end

	tType = VUHDO_DEBUFF_TYPES[tTypeString];
	tAbility = VUHDO_PLAYER_ABILITIES[tType] and UnitIsFriend("player", tUnit);
	tIsRelevant = not VUHDO_IGNORE_DEBUFF_NAMES[tName]
		and not (VUHDO_IGNORE_DEBUFFS_BY_CLASS[tInfo["class"] or ""] or sEmpty)[tName];

	if tType and tIsRelevant then
		tSchool = tUnitDebuffInfo[tType];
		tRemaining = floor(tExpiry - tNow);

		if (tSchool[2] or 0) < tRemaining then
			tSchool[1], tSchool[2], tSchool[3], tSchool[4] = tIcon, tRemaining, tStacks, tDuration;
		end
	end

	if sCurChosenType ~= 6 -- VUHDO_DEBUFF_TYPE_CUSTOM
		and not VUHDO_DEBUFF_BLACKLIST[tName]
		and not VUHDO_DEBUFF_BLACKLIST[tostring(tSpellId)]
		and tIsRelevant then

		if sIsUseDebuffIcon and (tIsBossDebuff or not sIsUseDebuffIconBossOnly)
			and (sIsNotRemovableOnlyIcons or tAbility ~= nil) then

			sCurIcons[tName] = VUHDO_getOrCreateIconArray(tIcon, tExpiry, tStacks, tDuration, false, tSpellId, tCnt);
			sCurIsStandard = true;
		end

		-- Entweder F�higkeit vorhanden ODER noch keiner gew�hlt UND auch nicht entfernbare
		-- Either ability available OR none selected AND not removable (DETECT_DEBUFFS_REMOVABLE_ONLY)
		if tType and (tAbility or (sCurChosenType == 0 and sIsNotRemovableOnly)) then -- VUHDO_DEBUFF_TYPE_NONE
			sCurChosenType = tType;
			tUnitDebuffInfo["CHOSEN"][1], tUnitDebuffInfo["CHOSEN"][2] = tIcon, tStacks;
		end
	end

	tCnt = tCnt + 1;

end



--
local function VUHDO_determineBuffPredicate(anAuraData)

	tName, tIcon, tStacks, _, tDuration, tExpiry, tUnitCaster, _, _, tSpellId = UnpackAuraData(anAuraData);

	if not tIcon then
		return;
	end

	tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[tName] or VUHDO_CUSTOM_DEBUFF_CONFIG[tostring(tSpellId)] or sEmpty;

	if tDebuffConfig[1] and ((tDebuffConfig[3] and tUnitCaster == "player") or (tDebuffConfig[4] and tUnitCaster ~= "player")) then -- Color?
		sCurChosenType, sCurChosenName, sCurChosenSpellId = 6, tName, tSpellId; -- VUHDO_DEBUFF_TYPE_CUSTOM
	end

	if tDebuffConfig[2] and ((tDebuffConfig[3] and tUnitCaster == "player") or (tDebuffConfig[4] and tUnitCaster ~= "player")) then -- Icon?
		sCurIcons[tName] = VUHDO_getOrCreateIconArray(tIcon, tExpiry, tStacks or 0, tDuration, true, tSpellId, tCnt);
	end

	tCnt = tCnt + 1;

end



--
local tDebuffSettings;
local tCurChosenStoredName;
function VUHDO_determineDebuff(aUnit)

	tInfo = (VUHDO_RAID or sEmpty)[aUnit];

	if not tInfo then
		return 0, ""; -- VUHDO_DEBUFF_TYPE_NONE
	elseif VUHDO_CONFIG_SHOW_RAID then
		return tInfo["debuff"], tInfo["debuffName"];
	end

	tUnitDebuffInfo = VUHDO_initDebuffInfos(aUnit);

	if VUHDO_shouldScanUnit(aUnit) then
		tUnit = aUnit;
		tNow = GetTime();

		tCnt = 1;
		ForEachAura(aUnit, "HARMFUL", nil, VUHDO_determineDebuffPredicate, true);

		tCnt = 1;
		ForEachAura(aUnit, "HELPFUL", nil, VUHDO_determineBuffPredicate, true);

		-- Gained new custom debuff?
		-- note we only play sounds for debuff customs with isIcon set to true
		for tName, tDebuffInfo in pairs(sCurIcons) do
			if not VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] or not VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][5] then 
				if not sIsShowOnlyForFriendly or UnitIsFriend("player", aUnit) then
					-- tExpiry, tStacks, tIcon
					if not VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] then
						VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] = { tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[1], tDebuffInfo[7], true };
					else
						VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][1], VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][2],
							VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][3], VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][4],
							VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][5] = tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[1],
							tDebuffInfo[7], true;
					end

					VUHDO_addDebuffIcon(aUnit, tDebuffInfo[1], tName, tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4], tDebuffInfo[5], tDebuffInfo[6], tDebuffInfo[7]);

					if not VUHDO_IS_CONFIG and VUHDO_MAY_DEBUFF_ANIM then
						-- the key used to store the debuff settings is either the debuff name or spell ID
						tDebuffSettings = sAllDebuffSettings[tName] or sAllDebuffSettings[tostring(tDebuffInfo[6])];

						if tDebuffSettings then -- particular custom debuff sound?
							VUHDO_playDebuffSound(tDebuffSettings["SOUND"], tName);
						elseif VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] then -- default custom debuff sound?
							VUHDO_playDebuffSound(VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"], tName);
						end
					end

					VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
				end
			-- update number of stacks?
			elseif VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][5] and (VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][1] ~= tDebuffInfo[2]
				or VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][2] ~= tDebuffInfo[3] 
				or VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][3] ~= tDebuffInfo[1]
				or VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][4] ~= tDebuffInfo[7]) then

				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][1] = tDebuffInfo[2];
				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][2] = tDebuffInfo[3];
				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][3] = tDebuffInfo[1];
				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][4] = tDebuffInfo[7];

				VUHDO_updateDebuffIcon(aUnit, tDebuffInfo[1], tName, tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4], tDebuffInfo[5], tDebuffInfo[6], tDebuffInfo[7]);

				VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
			end
		end

		-- Play standard debuff sound?
		if sStdDebuffSound
			and (sCurChosenType ~= VUHDO_DEBUFF_TYPE_NONE or sCurIsStandard)
			and sCurChosenType ~= VUHDO_DEBUFF_TYPE_CUSTOM
			and sCurChosenType ~= VUHDO_LAST_UNIT_DEBUFFS[aUnit]
			and tInfo["range"] then

				VUHDO_playDebuffSound(sStdDebuffSound);
				VUHDO_LAST_UNIT_DEBUFFS[aUnit] = sCurChosenType;
		end
	end -- shouldScanUnit

	-- Lost old custom debuff?
	for tName, _ in pairs(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit]) do
		if not sCurIcons[tName] then
			VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][5] = false;
			VUHDO_removeDebuffIcon(aUnit, tName);
			VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
		end
	end

	if sCurChosenType == VUHDO_DEBUFF_TYPE_NONE and tInfo["missbuff"] and (sIsMiBuColorsInFight or not InCombatLockdown()) then
		sCurChosenType = VUHDO_DEBUFF_TYPE_MISSING_BUFF;
	end

	-- we need to return the actual key that the debuff settings are stored under
	-- this key is either the debuff name or the debuff spell ID
	if sAllDebuffSettings[sCurChosenName] ~= nil then
		tCurChosenStoredName = sCurChosenName;
	elseif sAllDebuffSettings[tostring(sCurChosenSpellId)] ~= nil then
		tCurChosenStoredName = tostring(sCurChosenSpellId);
	end

	return sCurChosenType, tCurChosenStoredName;

end

local VUHDO_determineDebuff = VUHDO_determineDebuff;



--
function VUHDO_updateAllCustomDebuffs(anIsEnableAnim)
	twipe(VUHDO_UNIT_CUSTOM_DEBUFFS);
	VUHDO_MAY_DEBUFF_ANIM = false;
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		VUHDO_removeAllDebuffIcons(tUnit);
		tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(tUnit);
	end
	VUHDO_MAY_DEBUFF_ANIM = anIsEnableAnim;
end



-- Remove debuffing abilities individually not known to the player
function VUHDO_initDebuffs()
	local tAbility;

	local _, tClass = UnitClass("player");
	twipe(VUHDO_PLAYER_ABILITIES);

	for tDebuffType, tAbilities in pairs(VUHDO_INIT_DEBUFF_ABILITIES[tClass] or sEmpty) do
		for tCnt = 1, #tAbilities do
			tAbility = tAbilities[tCnt];

--			VUHDO_Msg("check: " .. tAbility);
			if VUHDO_isSpellKnown(tAbility) or tAbility == "*" then
				if VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility] then
					tAbility = VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility];
				elseif type(tAbility) == "number" then
					tAbility = GetSpellInfo(tAbility);
				end

				VUHDO_PLAYER_ABILITIES[tDebuffType] = tAbility;

--				VUHDO_Msg("KEEP: Type " .. tDebuffType .. " because of spell " .. VUHDO_PLAYER_ABILITIES[tDebuffType]);
				break;
			end
		end
	end
--	VUHDO_Msg("---");

	if not VUHDO_CONFIG then VUHDO_CONFIG = _G["VUHDO_CONFIG"]; end

	twipe(VUHDO_CUSTOM_DEBUFF_CONFIG);

	for _, tDebuffName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		if not VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName] then
			VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName] = { };
		end

		VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName][1] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isColor"];
		VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName][2] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isIcon"];

		if VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isMine"] == nil then
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isMine"] = true;
		end

		VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName][3] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isMine"];

		if VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isOthers"] == nil then
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isOthers"] = true;
		end

		VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName][4] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isOthers"];
	end

	for tDebuffName, _ in pairs(VUHDO_CUSTOM_DEBUFF_CONFIG) do
		if not VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName] then
			VUHDO_CUSTOM_DEBUFF_CONFIG[tDebuffName] = nil;
		end
	end

	twipe(VUHDO_IGNORE_DEBUFF_NAMES);

	if VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_NO_HARM"] then
		VUHDO_IGNORE_DEBUFFS_BY_CLASS = VUHDO_INIT_IGNORE_DEBUFFS_BY_CLASS;
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_NO_HARM);
	else
		VUHDO_IGNORE_DEBUFFS_BY_CLASS = sEmpty;
	end

	if VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_MOVEMENT"] then
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_MOVEMENT);
	end

	if VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_DURATION"] then
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_DURATION);
	end
end



--
function VUHDO_getDebuffAbilities()
	return VUHDO_PLAYER_ABILITIES;
end



--
function VUHDO_getUnitDebuffSchoolInfos(aUnit, aDebuffSchool)
	return VUHDO_UNIT_DEBUFF_INFOS[aUnit][aDebuffSchool];
end


--
function VUHDO_getChosenDebuffInfo(aUnit)
	return VUHDO_UNIT_DEBUFF_INFOS[aUnit]["CHOSEN"];
end



--
function VUHDO_resetDebuffsFor(aUnit)
	VUHDO_initDebuffInfos(aUnit);
	twipe(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit]);
end



--
function VUHDO_getUnitCustomDebuffs()
	
	return VUHDO_UNIT_CUSTOM_DEBUFFS;

end

