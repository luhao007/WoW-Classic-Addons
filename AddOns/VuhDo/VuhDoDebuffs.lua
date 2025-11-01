local GetSpellName = C_Spell.GetSpellName or VUHDO_getSpellName;



local VUHDO_CUSTOM_DEBUFF_CONFIG = { };
local VUHDO_UNIT_CUSTOM_DEBUFFS = { };
setmetatable(VUHDO_UNIT_CUSTOM_DEBUFFS, VUHDO_META_NEW_ARRAY);
local VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS = { };
local VUHDO_LAST_UNIT_DEBUFFS = { };
local VUHDO_PLAYER_DISPEL_ABILITIES = { };
local VUHDO_PLAYER_PURGE_ABILITIES = { };



local VUHDO_IGNORE_DEBUFFS_BY_CLASS = { };
local VUHDO_IGNORE_DEBUFF_NAMES = { };



--
local VUHDO_DEBUFF_TYPES = {
	["Magic"] = VUHDO_DEBUFF_TYPE_MAGIC,
	["Disease"] = VUHDO_DEBUFF_TYPE_DISEASE,
	["Poison"] = VUHDO_DEBUFF_TYPE_POISON,
	["Curse"] = VUHDO_DEBUFF_TYPE_CURSE,
	[""] = VUHDO_DEBUFF_TYPE_ENRAGE,
};




VUHDO_DEBUFF_BLACKLIST = {
--	[GetSpellName(69127)] = true, -- Chill of the Throne
--	[GetSpellName(57724)] = true, -- Sated (Bloodlust)
--	[GetSpellName(71328)] = true, -- Dungeon Cooldown
--	[GetSpellName(57723)] = true, -- Exhaustion (Heroism)
--	[GetSpellName(80354)] = true, -- Temporal Displacement (Time Warp)
--	[VUHDO_SPELL_ID.DEBUFF_FATIGUED] = true -- Fatigued (Primal Fury)
        [GetSpellName(69127)] = true, -- MOP okay Chill of the Throne (ständiger debuff)
        [GetSpellName(57724)] = true, -- MOP okay Sated
        [GetSpellName(71328)] = true  -- MOP okay Dungeon Cooldown
};





-- BURST CACHE ---------------------------------------------------

local VUHDO_CONFIG;
local VUHDO_RAID;
local VUHDO_PANEL_SETUP;
local VUHDO_DEBUFF_COLORS = { };

local VUHDO_DEBUFF_BLACKLIST = { };

local UnitIsFriend = UnitIsFriend;
local UnitIsEnemy = UnitIsEnemy;
local table = table;
local GetTime = GetTime;
local InCombatLockdown = InCombatLockdown;
local twipe = table.wipe;
local pairs = pairs;
local _;
local tostring = tostring;
local ForEachAura = AuraUtil.ForEachAura or VUHDO_forEachAura;
local GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID;
local VUHDO_shouldScanUnit;


local sIsNotRemovableOnly;
local sIsNotRemovableOnlyIcons;
local sIsUseDebuffIcon;
local sIsUseDebuffIconBossOnly;
local sIsMiBuColorsInFight;
local sStdDebuffSound;
local sCustomDebuffSound;
local sAllDebuffSettings;
local sIsShowOnFriendly;
local sIsShowOnHostile;
local sIsShowHostileMine;
local sIsShowHostileOthers;
local sIsDebuffSoundRemovableOnly;
local sIsShowPurgeableBuffs;
local sEmpty = { };
local sCurChosenColor = { };
--local sColorArray = nil;

function VUHDO_debuffsInitLocalOverrides()

	VUHDO_shouldScanUnit = _G["VUHDO_shouldScanUnit"];

	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_DEBUFF_BLACKLIST = _G["VUHDO_DEBUFF_BLACKLIST"];

	sIsNotRemovableOnly = not VUHDO_CONFIG["DETECT_DEBUFFS_REMOVABLE_ONLY"];
	sIsNotRemovableOnlyIcons = not VUHDO_CONFIG["DETECT_DEBUFFS_REMOVABLE_ONLY_ICONS"];
	sIsUseDebuffIcon = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIcon"];
	sIsUseDebuffIconBossOnly = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIconBossOnly"];
	sIsMiBuColorsInFight = VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_IN_FIGHT"];
	sStdDebuffSound = VUHDO_CONFIG["SOUND_DEBUFF"];

	sCustomDebuffSound = VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"];
	sAllDebuffSettings = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"];
	sIsShowOnFriendly = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowFriendly"];
	sIsShowOnHostile = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isShowHostile"];
	sIsShowHostileMine = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isHostileMine"];
	sIsShowHostileOthers = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isHostileOthers"];

	sIsDebuffSoundRemovableOnly = VUHDO_CONFIG["SOUND_DEBUFF_REMOVABLE_ONLY"];
	sIsShowPurgeableBuffs = not VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_PURGEABLE_BUFFS"];

	VUHDO_DEBUFF_COLORS = {
		[1] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF1"],
		[2] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF2"],
		[3] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF3"],
		[4] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF4"],
		[6] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF6"],
		[8] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF8"],
		[9] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF9"],
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
local sDebuffAuraPool = VUHDO_createTablePool("DebuffAura", 1500);
local sListNodePool = VUHDO_createTablePool("ListNode", 2000, VUHDO_createListNodeDelegate, VUHDO_cleanupListNodeDelegate);
local sIconArrayPool = VUHDO_createTablePool("IconArray", 1000);
local sCustomDebuffInfoPool = VUHDO_createTablePool("DebuffInfo", 2000);



--
local function VUHDO_getPooledAuraData()

	return sDebuffAuraPool:get();

end



--
local function VUHDO_releasePooledAuraData(anAuraData)

	sDebuffAuraPool:release(anAuraData);

end



--
function VUHDO_getDebuffAuraPool()

	return sDebuffAuraPool;

end



--
function VUHDO_getPooledListNode()

	return sListNodePool:get();

end



--
function VUHDO_releasePooledListNode(aNode)

	sListNodePool:release(aNode);

end



--
function VUHDO_getListNodePool()

	return sListNodePool;

end



--
function VUHDO_getPooledIconArray()

	return sIconArrayPool:get();

end



--
function VUHDO_releasePooledIconArray(anIconArray)

	sIconArrayPool:release(anIconArray);

end



--
function VUHDO_getIconArrayPool()

	return sIconArrayPool;

end



--
local function VUHDO_getPooledCustomDebuffInfo()

	return sCustomDebuffInfoPool:get();

end



--
local function VUHDO_releasePooledCustomDebuffInfo(aCustomDebuffInfo)

	sCustomDebuffInfoPool:release(aCustomDebuffInfo);

end



--
function VUHDO_getDebuffInfoPool()

	return sCustomDebuffInfoPool;

end



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

	twipe(tColor);

	if tDebuff and tDebuff > 0 and tDebuff ~= 7 and anInfo["unit"] and sCurChosenColor[anInfo["unit"]] then
		tSourceColor = sCurChosenColor[anInfo["unit"]];

		if tSourceColor["useText"] then
			tColor["useText"], tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"] = true, tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"];
		end

		if tSourceColor["useBackground"] then
			tColor["useBackground"], tColor["R"], tColor["G"], tColor["B"], tColor["O"] = true, tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"];
		end
	end

	if not anInfo["mibucateg"] or not VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]] then
		return tColor;
	end

	tSourceColor = VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]]["missingColor"];

	if not tColor["useText"] and VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_TEXT"] then
		tColor["useText"], tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"] = true, tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"];
	end

	if not tColor["useBackground"] and VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_BACKGROUND"] then
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
local VUHDO_UNIT_DEBUFF_INFOS = { };
setmetatable(VUHDO_UNIT_DEBUFF_INFOS, {
	__index = function(aTable, aKey)
		local tValue = {
			["CHOSEN"] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_POISON] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_DISEASE] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_MAGIC] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_CURSE] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_BLEED] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			[VUHDO_DEBUFF_TYPE_ENRAGE] = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 },
			["listHeads"] = {
--				[<CHOSEN|VUHDO_DEBUFF_TYPE>] = {
--					["auraInstanceId"] = <aura instance ID>,
--					["prev"] = <prev aura>,
--				},
			},
			["typeAuras"] = {
--				[<aura instance ID] = {
--					<aura icon>,
--					<aura time remaining>,
--					<aura stacks>,
--					<aura duration>,
--				},
			},
			["chosenAuras"] = {
--				[<aura instance ID] = {
--					<aura icon>,
--					<aura time remaining>,
--					<aura stacks>,
--					<aura duration>,
--				},
			},
		};

		rawset(aTable, aKey, tValue);
		return tValue;
	end
});

-- aura icon, aura time remaining, aura stacks, aura duration
local VUHDO_UNIT_DEBUFF_INFO_DEFAULT = { [1] = nil, [2] = nil, [3] = 0, [4] = 0 };



--
local tUnitDebuffInfos;
local tUnitDebuffInfo;
local tUnitDebuffInfoLists;
local tUnitDebuffInfoAuras;
local tUnitDebuffInfoAura;
local tUnitDebuffInfoListHead;
local tUnitDebuffInfoListNew;
local function VUHDO_addUnitDebuffInfo(aUnit, aType, anAuraInstanceId, anIcon, anExpiry, aStacks, aDuration)

	if not aUnit or not anAuraInstanceId or not aType then
		return;
	end

	tUnitDebuffInfos = VUHDO_UNIT_DEBUFF_INFOS[aUnit];

	tUnitDebuffInfo = tUnitDebuffInfos[aType];

	if not tUnitDebuffInfo then
		return;
	end

	tUnitDebuffInfoLists = tUnitDebuffInfos["listHeads"];

	if not tUnitDebuffInfoLists then
		return;
	end

	if aType == "CHOSEN" then
		tUnitDebuffInfoAuras = tUnitDebuffInfos["chosenAuras"];
	else
		tUnitDebuffInfoAuras = tUnitDebuffInfos["typeAuras"];
	end

	if not tUnitDebuffInfoAuras then
		return;
	end

	tUnitDebuffInfoAura = tUnitDebuffInfoAuras[anAuraInstanceId];

	if tUnitDebuffInfoAura then
		if anIcon ~= nil then
			tUnitDebuffInfoAura[1] = anIcon;
			tUnitDebuffInfo[1] = anIcon;
		end

		if anExpiry ~= nil then
			tUnitDebuffInfoAura[2] = anExpiry;
			tUnitDebuffInfo[2] = anExpiry;
		end

		if aStacks ~= nil then
			tUnitDebuffInfoAura[3] = aStacks;
			tUnitDebuffInfo[3] = aStacks;
		end

		if aDuration ~= nil then
			tUnitDebuffInfoAura[4] = aDuration;
			tUnitDebuffInfo[4] = aDuration;
		end

		tUnitDebuffInfoAura[5] = aType;
	else
		tUnitDebuffInfoAura = VUHDO_getPooledAuraData();

		tUnitDebuffInfoAura[1], tUnitDebuffInfoAura[2], tUnitDebuffInfoAura[3],
		tUnitDebuffInfoAura[4], tUnitDebuffInfoAura[5] =
			anIcon or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[1],
			anExpiry or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[2],
			aStacks or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[3],
			aDuration or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[4],
			aType;

		tUnitDebuffInfoAuras[anAuraInstanceId] = tUnitDebuffInfoAura;

		tUnitDebuffInfoListHead = tUnitDebuffInfoLists[aType];

		tUnitDebuffInfoListNew = VUHDO_getPooledListNode();

		tUnitDebuffInfoListNew["auraInstanceId"] = anAuraInstanceId;
		tUnitDebuffInfoListNew["prev"] = tUnitDebuffInfoListHead;

		tUnitDebuffInfoLists[aType] = tUnitDebuffInfoListNew;

		tUnitDebuffInfo[1], tUnitDebuffInfo[2],
		tUnitDebuffInfo[3], tUnitDebuffInfo[4] =
			anIcon or tUnitDebuffInfo[1] or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[1],
			anExpiry or tUnitDebuffInfo[2] or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[2],
			aStacks or tUnitDebuffInfo[3] or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[3],
			aDuration or tUnitDebuffInfo[4] or VUHDO_UNIT_DEBUFF_INFO_DEFAULT[4];
	end

end



--
local tUnitDebuffInfos;
local tUnitDebuffInfo;
local tUnitDebuffInfoLists;
local tUnitDebuffInfoAuras;
local tUnitDebuffInfoAura;
local tListNode;
local tUnitDebuffInfoListCur;
local tUnitDebuffInfoListPrev;
local function VUHDO_removeUnitDebuffInfo(aUnit, aType, anAuraInstanceId)

	if not aUnit or not anAuraInstanceId or not aType then
		return;
	end

	tUnitDebuffInfos = VUHDO_UNIT_DEBUFF_INFOS[aUnit];

	tUnitDebuffInfo = tUnitDebuffInfos[aType];

	if not tUnitDebuffInfo then
		return;
	end

	tUnitDebuffInfoLists = tUnitDebuffInfos["listHeads"];

	if not tUnitDebuffInfoLists then
		return;
	end

	if aType == "CHOSEN" then
		tUnitDebuffInfoAuras = tUnitDebuffInfos["chosenAuras"];
	else
		tUnitDebuffInfoAuras = tUnitDebuffInfos["typeAuras"];
	end

	tUnitDebuffInfoAura = tUnitDebuffInfoAuras and tUnitDebuffInfoAuras[anAuraInstanceId];

	if not tUnitDebuffInfoAura then
		return;
	end

	tUnitDebuffInfoAuras[anAuraInstanceId] = nil;
	VUHDO_releasePooledAuraData(tUnitDebuffInfoAura);

	tUnitDebuffInfoListCur = tUnitDebuffInfoLists[aType];
	tUnitDebuffInfoListPrev = nil;
	tListNode = nil;

	while tUnitDebuffInfoListCur do
		if tUnitDebuffInfoListCur["auraInstanceId"] == anAuraInstanceId then
			tListNode = tUnitDebuffInfoListCur;

			if tUnitDebuffInfoListPrev then
				-- remove middle or tail
				tUnitDebuffInfoListPrev["prev"] = tUnitDebuffInfoListCur["prev"];
			else
				-- remove head
				tUnitDebuffInfoLists[aType] = tUnitDebuffInfoListCur["prev"];
	                end

			break;
		else
			tUnitDebuffInfoListPrev = tUnitDebuffInfoListCur;
			tUnitDebuffInfoListCur = tUnitDebuffInfoListCur["prev"];
		end
	end

	if tListNode then
		VUHDO_releasePooledListNode(tListNode);
	end

end



--
local tUnitDebuffInfos;
local tUnitDebuffInfoLists;
local tUnitDebuffInfoListHead;
local tAuraInstanceId;
local tUnitDebuffInfoAuras;
local function VUHDO_getUnitDebuffInfo(aUnit, aType)

	if not aUnit or not aType then
		return;
	end

	tUnitDebuffInfos = VUHDO_UNIT_DEBUFF_INFOS[aUnit];

	tUnitDebuffInfoLists = tUnitDebuffInfos["listHeads"];
	tUnitDebuffInfoListHead = tUnitDebuffInfoLists and tUnitDebuffInfoLists[aType];

	if not tUnitDebuffInfoListHead or not tUnitDebuffInfoListHead["auraInstanceId"] then
		return;
	end

	tAuraInstanceId = tUnitDebuffInfoListHead["auraInstanceId"];

	if aType == "CHOSEN" then
		tUnitDebuffInfoAuras = tUnitDebuffInfos["chosenAuras"];
	else
		tUnitDebuffInfoAuras = tUnitDebuffInfos["typeAuras"];
	end

	return tUnitDebuffInfoAuras and tUnitDebuffInfoAuras[tAuraInstanceId];

end



--
local tUnitDebuffInfos;
local tUnitDebuffInfo;
local tUnitDebuffInfoHead;
local function VUHDO_updateUnitDebuffInfo(aUnit, aType)

	if not aUnit or not aType then
		return;
	end

	tUnitDebuffInfos = VUHDO_UNIT_DEBUFF_INFOS[aUnit];

	tUnitDebuffInfo = tUnitDebuffInfos[aType];

	if not tUnitDebuffInfo then
		return;
	end

	tUnitDebuffInfoHead = VUHDO_getUnitDebuffInfo(aUnit, aType);

	if tUnitDebuffInfoHead then
		tUnitDebuffInfo[1], tUnitDebuffInfo[2], tUnitDebuffInfo[3], tUnitDebuffInfo[4] =
			tUnitDebuffInfoHead[1], tUnitDebuffInfoHead[2], tUnitDebuffInfoHead[3], tUnitDebuffInfoHead[4];
	else
		tUnitDebuffInfo[1], tUnitDebuffInfo[2], tUnitDebuffInfo[3], tUnitDebuffInfo[4] =
			VUHDO_UNIT_DEBUFF_INFO_DEFAULT[1], VUHDO_UNIT_DEBUFF_INFO_DEFAULT[2],
			VUHDO_UNIT_DEBUFF_INFO_DEFAULT[3], VUHDO_UNIT_DEBUFF_INFO_DEFAULT[4];
	end

end



-- debuff type, aura name, aura spell Id, isStandard: true|false
local VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT = { VUHDO_DEBUFF_TYPE_NONE, "", nil, false };

local sCurChosenInfo = {
	-- [<unit ID>] = {
	--	[<aura instance ID>] = {
	--		VUHDO_DEBUFF_TYPE_<NONE|POISON|DISEASE|MAGIC|CURSE|CUSTOM|MISSING_BUFF|BLEED|ENRAGE>,
	--		<aura spell Id>,
	--		<aura name>,
	--		<isStandard: true|false>,
	--	},
	-- },
};

local sCurChosenListHead = { };
local sCurChosen = { };
local sCurIcons = { };



--
local tUnitCurChosenColor;
local tSourceColor;
local tUnitCurChosen;
local tName;
local tSpellId;
local tSpellIdStr;
local tDebuffSettings;
local tCustomDebuffColor;
local function VUHDO_updateCurChosenColor(aUnit, aType)

	if (aType or 0) == 0 then -- VUHDO_DEBUFF_TYPE_NONE
		return;
	end

	tUnitCurChosenColor = sCurChosenColor[aUnit];

	if aType ~= 6 and VUHDO_DEBUFF_COLORS[aType] then -- VUHDO_DEBUFF_TYPE_<POISON|DISEASE|MAGIC|CURSE|BLEED|ENRAGE>
		tSourceColor = VUHDO_DEBUFF_COLORS[aType];

		if tSourceColor["useBackground"] then
			tUnitCurChosenColor["R"], tUnitCurChosenColor["G"], tUnitCurChosenColor["B"], tUnitCurChosenColor["O"], tUnitCurChosenColor["useBackground"] = tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"], true;
		end

		if tSourceColor["useText"] then
			tUnitCurChosenColor["TR"], tUnitCurChosenColor["TG"], tUnitCurChosenColor["TB"], tUnitCurChosenColor["TO"], tUnitCurChosenColor["useText"] = tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"], true;
		end

		return;
	end

	if aType == 6 then -- VUHDO_DEBUFF_TYPE_CUSTOM
		tUnitCurChosen = sCurChosen[aUnit];

		if not tUnitCurChosen then
			return;
		end

		tName = tUnitCurChosen[2];
		tSpellId = tUnitCurChosen[3];
		tSpellIdStr = tSpellId and tostring(tSpellId);

		tDebuffSettings = sAllDebuffSettings[tName] or sAllDebuffSettings[tSpellIdStr];

		if tDebuffSettings and tDebuffSettings["isColor"] then
			tSourceColor = tDebuffSettings["color"] or VUHDO_DEBUFF_COLORS[6];

			if tSourceColor then
				tCustomDebuffColor = VUHDO_DEBUFF_COLORS[6] or sEmpty;

				if tCustomDebuffColor["useBackground"] then
					tUnitCurChosenColor["R"], tUnitCurChosenColor["G"], tUnitCurChosenColor["B"], tUnitCurChosenColor["O"], tUnitCurChosenColor["useBackground"] = tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"], true;
				end

				if tCustomDebuffColor["useText"] then
					tUnitCurChosenColor["TR"], tUnitCurChosenColor["TG"], tUnitCurChosenColor["TB"], tUnitCurChosenColor["TO"], tUnitCurChosenColor["useText"] = tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"], true;
				end
			end
		end
	end

end



--
local tUnitCurChosenInfo;
local tUnitCurChosenInfoAura;
local tUnitCurChosen;
local tUnitCurChosenListHead;
local tUnitCurChosenListNew;
local function VUHDO_addCurChosen(aUnit, anAuraInstanceId, aType, aName, aSpellId, anIsStandard)

	if not aUnit or not anAuraInstanceId then
		return;
	end

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];
	tUnitCurChosenInfoAura = tUnitCurChosenInfo and tUnitCurChosenInfo[anAuraInstanceId];

	tUnitCurChosen = sCurChosen[aUnit];

	if tUnitCurChosenInfoAura then
		if aType ~= nil then
			tUnitCurChosenInfoAura[1] = aType;
			tUnitCurChosen[1] = aType;
		end

		if aName ~= nil then
			tUnitCurChosenInfoAura[2] = aName;
			tUnitCurChosen[2] = aName;
		end

		if aSpellId ~= nil then
			tUnitCurChosenInfoAura[3] = aSpellId;
			tUnitCurChosen[3] = aSpellId;
		end

		if anIsStandard ~= nil then
			tUnitCurChosenInfoAura[4] = anIsStandard;
			tUnitCurChosen[4] = anIsStandard;
		end
	else
		tUnitCurChosenInfoAura = VUHDO_getPooledAuraData();

		tUnitCurChosenInfoAura[1], tUnitCurChosenInfoAura[2],
		tUnitCurChosenInfoAura[3], tUnitCurChosenInfoAura[4] =
			aType or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1],
			aName or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[2],
			aSpellId or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[3],
			(anIsStandard ~= nil) and anIsStandard or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[4];

		tUnitCurChosenInfo[anAuraInstanceId] = tUnitCurChosenInfoAura;

		tUnitCurChosenListHead = sCurChosenListHead[aUnit];

		tUnitCurChosenListNew = VUHDO_getPooledListNode();

		tUnitCurChosenListNew["auraInstanceId"] = anAuraInstanceId;
		tUnitCurChosenListNew["prev"] = tUnitCurChosenListHead;

		sCurChosenListHead[aUnit] = tUnitCurChosenListNew;

		tUnitCurChosen[1], tUnitCurChosen[2], tUnitCurChosen[3], tUnitCurChosen[4] =
			aType or tUnitCurChosen[1] or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1],
			aName or tUnitCurChosen[2] or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[2],
			aSpellId or tUnitCurChosen[3] or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[3],
			(anIsStandard ~= nil) and anIsStandard or (tUnitCurChosen[4] or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[4]);
	end

	VUHDO_updateCurChosenColor(aUnit, aType or VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1]);

end



--
local tUnitCurChosenInfo;
local tUnitCurChosenInfoAura;
local tUnitCurChosenListCur;
local tUnitCurChosenListPrev;
local tListNode;
local function VUHDO_removeCurChosen(aUnit, anAuraInstanceId)

	if not aUnit or not anAuraInstanceId then
		return;
	end

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];

	tUnitCurChosenInfoAura = tUnitCurChosenInfo and tUnitCurChosenInfo[anAuraInstanceId];

	if not tUnitCurChosenInfoAura then
		return;
	end

	tUnitCurChosenInfo[anAuraInstanceId] = nil;
	VUHDO_releasePooledAuraData(tUnitCurChosenInfoAura);

	tUnitCurChosenListCur = sCurChosenListHead[aUnit];
	tUnitCurChosenListPrev = nil;
	tListNode = nil;

	while tUnitCurChosenListCur do
		if tUnitCurChosenListCur["auraInstanceId"] == anAuraInstanceId then
			tListNode = tUnitCurChosenListCur;

			if tUnitCurChosenListPrev then
				tUnitCurChosenListPrev["prev"] = tUnitCurChosenListCur["prev"];
			else
				sCurChosenListHead[aUnit] = tUnitCurChosenListCur["prev"];
			end

			break;
		else
			tUnitCurChosenListPrev = tUnitCurChosenListCur;
			tUnitCurChosenListCur = tUnitCurChosenListCur["prev"];
		end
	end

	if tListNode then
		VUHDO_releasePooledListNode(tListNode);
	end

end



--
local tUnitCurChosenListHead;
local tAuraInstanceId;
local tUnitCurChosenInfo;
local function VUHDO_getCurChosenInfo(aUnit)

	if not aUnit then
		return;
	end

	tUnitCurChosenListHead = sCurChosenListHead[aUnit];

	if not tUnitCurChosenListHead or not tUnitCurChosenListHead["auraInstanceId"] then
		return;
	end

	tAuraInstanceId = tUnitCurChosenListHead["auraInstanceId"];

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];

	return tUnitCurChosenInfo and tUnitCurChosenInfo[tAuraInstanceId];

end



--
local tUnitCurChosen;
local tUnitCurChosenColor;
local tUnitCurChosenListCur;
local tUnitCurChosenInfo;
local tUnitCurChosenInfoAura;
local function VUHDO_updateCurChosen(aUnit)

	if not aUnit then
		return;
	end

	tUnitCurChosen = sCurChosen[aUnit];

	tUnitCurChosen[1], tUnitCurChosen[2], tUnitCurChosen[3], tUnitCurChosen[4] =
		VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1], VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[2],
		VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[3], VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[4];

	tUnitCurChosenColor = sCurChosenColor[aUnit];
	twipe(tUnitCurChosenColor);

	tUnitCurChosenListCur = sCurChosenListHead[aUnit];

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];
	tUnitCurChosenInfoAura = nil;

	while tUnitCurChosenListCur and tUnitCurChosenListCur["auraInstanceId"] do
		tUnitCurChosenInfoAura = tUnitCurChosenInfo and tUnitCurChosenInfo[tUnitCurChosenListCur["auraInstanceId"]];

		if tUnitCurChosenInfoAura then
			if tUnitCurChosenInfoAura[1] and tUnitCurChosen[1] == VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1] then
				tUnitCurChosen[1] = tUnitCurChosenInfoAura[1];
			end

			if tUnitCurChosenInfoAura[2] and tUnitCurChosen[2] == VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[2] then
				tUnitCurChosen[2] = tUnitCurChosenInfoAura[2];
			end

			if tUnitCurChosenInfoAura[3] and tUnitCurChosen[3] == VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[3] then
				tUnitCurChosen[3] = tUnitCurChosenInfoAura[3];
			end

			if tUnitCurChosenInfoAura[4] and tUnitCurChosen[4] == VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[4] then
				tUnitCurChosen[4] = tUnitCurChosenInfoAura[4];
			end

			if not tUnitCurChosenColor["useBackground"] or not tUnitCurChosenColor["useText"] then
				VUHDO_updateCurChosenColor(aUnit, tUnitCurChosenInfoAura[1]);
			end
		end

		tUnitCurChosenListCur = tUnitCurChosenListCur["prev"];
	end

	if tUnitCurChosen[1] == 0 then -- VUHDO_DEBUFF_TYPE_NONE
		twipe(tUnitCurChosenColor);
	end

end



--
local tUnitDebuffInfo;
local tUnitDebuffInfoLists;
local tListNodeCur;
local tListNodeNext;
local tUnitDebuffInfoTypeAuras;
local tUnitDebuffInfoChosenAuras;
local tUnitCurChosenInfo;
local tUnitCurChosen;
local tUnitCurChosenColor;
local tUnitCurIcons;
local tUnitCustomDebuffs;
local tUnitCustomDebuffSpells;
local function VUHDO_initDebuffInfos(aUnit)

	if not aUnit then
		return;
	end

	tUnitDebuffInfo = VUHDO_UNIT_DEBUFF_INFOS[aUnit];

	tUnitDebuffInfo["CHOSEN"][1], tUnitDebuffInfo["CHOSEN"][2], tUnitDebuffInfo["CHOSEN"][3], tUnitDebuffInfo["CHOSEN"][4] = nil, nil, 0, 0;
	tUnitDebuffInfo[1][1], tUnitDebuffInfo[1][2], tUnitDebuffInfo[1][3], tUnitDebuffInfo[1][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_POISON
	tUnitDebuffInfo[2][1], tUnitDebuffInfo[2][2], tUnitDebuffInfo[2][3], tUnitDebuffInfo[2][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_DISEASE
	tUnitDebuffInfo[3][1], tUnitDebuffInfo[3][2], tUnitDebuffInfo[3][3], tUnitDebuffInfo[3][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_MAGIC
	tUnitDebuffInfo[4][1], tUnitDebuffInfo[4][2], tUnitDebuffInfo[4][3], tUnitDebuffInfo[4][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_CURSE
	tUnitDebuffInfo[8][1], tUnitDebuffInfo[8][2], tUnitDebuffInfo[8][3], tUnitDebuffInfo[8][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_BLEED
	tUnitDebuffInfo[9][1], tUnitDebuffInfo[9][2], tUnitDebuffInfo[9][3], tUnitDebuffInfo[9][4] = nil, nil, 0, 0; -- VUHDO_DEBUFF_TYPE_ENRAGE

	tUnitDebuffInfoLists = tUnitDebuffInfo["listHeads"];

	if tUnitDebuffInfoLists then
		for tType, tListNodeHead in pairs(tUnitDebuffInfoLists) do
			tListNodeCur = tListNodeHead;

			while tListNodeCur do
				tListNodeNext = tListNodeCur["prev"];

				VUHDO_releasePooledListNode(tListNodeCur);

				tListNodeCur = tListNodeNext;
			end

			tUnitDebuffInfoLists[tType] = nil;
		end
	end

	tUnitDebuffInfoTypeAuras = tUnitDebuffInfo["typeAuras"];

	if tUnitDebuffInfoTypeAuras then
		for tAuraInstanceId, tAuraData in pairs(tUnitDebuffInfoTypeAuras) do
			VUHDO_releasePooledAuraData(tAuraData);

			tUnitDebuffInfoTypeAuras[tAuraInstanceId] = nil;
		end
	end

	tUnitDebuffInfoChosenAuras = tUnitDebuffInfo["chosenAuras"];

	if tUnitDebuffInfoChosenAuras then
		for tAuraInstanceId, tAuraData in pairs(tUnitDebuffInfoChosenAuras) do
			VUHDO_releasePooledAuraData(tAuraData);

			tUnitDebuffInfoChosenAuras[tAuraInstanceId] = nil;
		end
	end

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];

	if tUnitCurChosenInfo then
		for tAuraInstanceId, tAuraData in pairs(tUnitCurChosenInfo) do
			VUHDO_releasePooledAuraData(tAuraData);

			tUnitCurChosenInfo[tAuraInstanceId] = nil;
		end
	else
		sCurChosenInfo[aUnit] = { };
	end

	tListNodeCur = sCurChosenListHead[aUnit];

	while tListNodeCur do
		tListNodeNext = tListNodeCur["prev"];

		VUHDO_releasePooledListNode(tListNodeCur);

		tListNodeCur = tListNodeNext;
	end

	sCurChosenListHead[aUnit] = nil;

	tUnitCurChosen = sCurChosen[aUnit];

	if not tUnitCurChosen then
		tUnitCurChosen = { };

		sCurChosen[aUnit] = tUnitCurChosen;
	end

	tUnitCurChosen[1], tUnitCurChosen[2], tUnitCurChosen[3], tUnitCurChosen[4] =
		VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[1], VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[2],
		VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[3], VUHDO_DEBUFF_CUR_CHOSEN_DEFAULT[4];

	tUnitCurChosenColor = sCurChosenColor[aUnit];

	if tUnitCurChosenColor then
		twipe(tUnitCurChosenColor);
	else
		sCurChosenColor[aUnit] = { };
	end

	tUnitCurIcons = sCurIcons[aUnit];

	if tUnitCurIcons then
		for tAuraInstanceId, tIconArr in pairs(tUnitCurIcons) do
			VUHDO_releasePooledIconArray(tIconArr);

			tUnitCurIcons[tAuraInstanceId] = nil;
		end
	else
		sCurIcons[aUnit] = { };
	end

-- FIXME: Classic flavors still require full debuff icon refresh
--	tUnitCustomDebuffs = VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit];
--
--	if tUnitCustomDebuffs then
--		for tAuraInstanceId, tCustomDebuffInfo in pairs(tUnitCustomDebuffs) do
--			VUHDO_releasePooledCustomDebuffInfo(tCustomDebuffInfo);
--
--			tUnitCustomDebuffs[tAuraInstanceId] = nil;
--		end
--	end

	tUnitCustomDebuffSpells = VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit];

	if tUnitCustomDebuffSpells then
--		twipe(tUnitCustomDebuffSpells);
	else
		VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit] = { };
	end

--	VUHDO_LAST_UNIT_DEBUFFS[aUnit] = nil;

--	VUHDO_removeAllDebuffIcons(aUnit);

	return tUnitDebuffInfo;

end



--
local tUnitCurIcons;
local tIconArray;
local function VUHDO_getOrCreateIconArray(aUnit, anIcon, anExpiry, aStacks, aDuration, anIsBuff, aSpellId, anAuraInstanceId, aName, aCnt)

	tUnitCurIcons = sCurIcons[aUnit];

	if not tUnitCurIcons then
		tUnitCurIcons = { };

		sCurIcons[aUnit] = tUnitCurIcons;
	end

	tIconArray = tUnitCurIcons[anAuraInstanceId];

	if not tIconArray then
		tIconArray = VUHDO_getPooledIconArray();

		tUnitCurIcons[anAuraInstanceId] = tIconArray;
	end

	tIconArray[1], tIconArray[2], tIconArray[3], tIconArray[4], tIconArray[5], tIconArray[6], tIconArray[7], tIconArray[8], tIconArray[9]
		= anIcon, anExpiry, aStacks, aDuration, anIsBuff, aSpellId, anAuraInstanceId, aName, aCnt;

	return tIconArray;

end



--
local sUnit;
local sNow;
local sUnitDebuffInfo;
local sCnt;



do
	--
	local tInfo;
	local tSpellIdStr;
	local tDebuffConfig;
	local tDebuffConfigColor;
	local tDebuffConfigIcon;
	local tDebuffConfigMine;
	local tDebuffConfigOthers;
	local tIsMatchSource;
	local tIsShown;
	local tIsCustomColorShown;
	local tType;
	local tDebuffClassIgnoreList;
	local tIsRelevant;
	local tIsIgnored;
	local tFriend;
	local tHostile;
	local tAbility;
	local function VUHDO_determineDebuffPredicate(anAuraInstanceId, aName, anIcon, aStacks, aTypeString, aDuration, anExpiry, aUnitCaster, aSpellId, anIsBossDebuff, anIsUpdate, aCnt)

		if not anIcon then
			return;
		end

		tInfo = (VUHDO_RAID or sEmpty)[sUnit];

		if not tInfo then
			return;
		end

		if (anExpiry or 0) == 0 then
			anExpiry = (sCurIcons[sUnit] and sCurIcons[sUnit][anAuraInstanceId] or sEmpty)[2] or sNow;
		end

		tSpellIdStr = aSpellId and tostring(aSpellId);

		-- Custom Debuff?
		if tSpellIdStr then
			tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[tSpellIdStr];
		end

		if not tDebuffConfig then
			tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[aName];
		end

		if not tDebuffConfig then
			tDebuffConfig = sEmpty;
		end

		tDebuffConfigColor = tDebuffConfig[1];
		tDebuffConfigIcon = tDebuffConfig[2];
		tDebuffConfigMine = tDebuffConfig[3];
		tDebuffConfigOthers = tDebuffConfig[4];

		tIsMatchSource = (tDebuffConfigMine and aUnitCaster == "player") or (tDebuffConfigOthers and aUnitCaster ~= "player");

		tIsShown, tIsCustomColorShown = false, false;

		-- Color?
		if not anIsUpdate and tDebuffConfigColor and tIsMatchSource then
			VUHDO_addCurChosen(sUnit, anAuraInstanceId, 6, aName, aSpellId, false); -- VUHDO_DEBUFF_TYPE_CUSTOM

			tIsShown, tIsCustomColorShown = true, true;
		end

		aStacks = aStacks or 0;

		if tDebuffConfigIcon and tIsMatchSource then -- Icon?
			sCurIcons[sUnit][anAuraInstanceId] = VUHDO_getOrCreateIconArray(sUnit, anIcon, anExpiry, aStacks, aDuration, false, aSpellId, anAuraInstanceId, aName, aCnt);

			tIsShown = true;
		end

		tType = VUHDO_DEBUFF_BLEED_SPELLS[aSpellId] and VUHDO_DEBUFF_TYPE_BLEED or VUHDO_DEBUFF_TYPES[aTypeString];

		tDebuffClassIgnoreList = VUHDO_IGNORE_DEBUFFS_BY_CLASS[tInfo["class"] or ""] or sEmpty;
		tIsRelevant = not VUHDO_IGNORE_DEBUFF_NAMES[aName] and not tDebuffClassIgnoreList[aName];

		if not anIsUpdate and tType and tIsRelevant then
			VUHDO_addUnitDebuffInfo(sUnit, tType, anAuraInstanceId, anIcon, anExpiry, aStacks, aDuration);
		end

		tIsIgnored = VUHDO_DEBUFF_BLACKLIST[aName] or (tSpellIdStr and VUHDO_DEBUFF_BLACKLIST[tSpellIdStr]);

		if not tIsCustomColorShown and not tIsIgnored and tIsRelevant then
			tFriend = UnitIsFriend("player", sUnit);
			tHostile = UnitIsEnemy("player", sUnit);

			tAbility = VUHDO_PLAYER_DISPEL_ABILITIES[tType] and tFriend and not tHostile;

			if not tIsShown and sIsUseDebuffIcon
				and (anIsBossDebuff or not sIsUseDebuffIconBossOnly) and (sIsNotRemovableOnlyIcons or tAbility ~= nil)
				and ((sIsShowOnFriendly and not tHostile) or (sIsShowOnHostile and (not tFriend or tHostile)))
				and (tFriend or (sIsShowOnHostile and (sIsShowHostileMine and aUnitCaster == "player")
					or (sIsShowHostileOthers and aUnitCaster ~= "player"))) then
				sCurIcons[sUnit][anAuraInstanceId] = VUHDO_getOrCreateIconArray(sUnit, anIcon, anExpiry, aStacks, aDuration, false, aSpellId, anAuraInstanceId, aName, aCnt);

				if not anIsUpdate then
					VUHDO_addCurChosen(sUnit, anAuraInstanceId, nil, nil, nil, true);
				end
			end

			-- Entweder Fähigkeit vorhanden ODER noch keiner gewählt UND auch nicht entfernbare
			-- Either ability available OR none selected AND not removable (DETECT_DEBUFFS_REMOVABLE_ONLY)
			if not anIsUpdate and tType and (tAbility or (sIsNotRemovableOnly and tFriend and not tHostile)) then -- VUHDO_DEBUFF_TYPE_NONE
				VUHDO_addCurChosen(sUnit, anAuraInstanceId, tType, nil, nil, nil);
				VUHDO_addUnitDebuffInfo(sUnit, "CHOSEN", anAuraInstanceId, anIcon, anExpiry, aStacks, aDuration);
			end
		end

	end



	--
	local tSpellIdStr;
	local tDebuffConfig;
	local tDebuffConfigColor;
	local tDebuffConfigIcon;
	local tDebuffConfigMine;
	local tDebuffConfigOthers;
	local tIsMatchSource;
	local tIsShown;
	local tIsCustomColorShown;
	local tType;
	local tFriend;
	local tHostile;
	local tAbility;
	local function VUHDO_determineBuffPredicate(anAuraInstanceId, aName, anIcon, aStacks, aTypeString, aDuration, anExpiry, aUnitCaster, aSpellId, anIsUpdate, aCnt)

		if not anIcon then
			return;
		end

		tSpellIdStr = aSpellId and tostring(aSpellId);

		if tSpellIdStr then
			tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[tSpellIdStr];
		end

		if not tDebuffConfig then
			tDebuffConfig = VUHDO_CUSTOM_DEBUFF_CONFIG[aName];
		end

		if not tDebuffConfig then
			tDebuffConfig = sEmpty;
		end

		tDebuffConfigColor = tDebuffConfig[1];
		tDebuffConfigIcon = tDebuffConfig[2];
		tDebuffConfigMine = tDebuffConfig[3];
		tDebuffConfigOthers = tDebuffConfig[4];

		tIsMatchSource = (tDebuffConfigMine and aUnitCaster == "player") or (tDebuffConfigOthers and aUnitCaster ~= "player");

		tIsShown, tIsCustomColorShown = false, false;

		if not anIsUpdate and tDebuffConfigColor and tIsMatchSource then -- Color?
			VUHDO_addCurChosen(sUnit, anAuraInstanceId, 6, aName, aSpellId, false); -- VUHDO_DEBUFF_TYPE_CUSTOM

			tIsShown, tIsCustomColorShown = true, true;
		end

		aStacks = aStacks or 0;

		if tDebuffConfigIcon and tIsMatchSource then -- Icon?
			sCurIcons[sUnit][anAuraInstanceId] = VUHDO_getOrCreateIconArray(sUnit, anIcon, anExpiry, aStacks, aDuration, true, aSpellId, anAuraInstanceId, aName, aCnt);

			tIsShown = true;
		end

		tType = VUHDO_DEBUFF_BLEED_SPELLS[aSpellId] and VUHDO_DEBUFF_TYPE_BLEED or VUHDO_DEBUFF_TYPES[aTypeString];

		tFriend = UnitIsFriend("player", sUnit);
		tHostile = not tFriend or UnitIsEnemy("player", sUnit);

		tAbility = sIsShowPurgeableBuffs and VUHDO_PLAYER_PURGE_ABILITIES[tType] and tHostile;

		if not tIsCustomColorShown and tType and tAbility then
			if not tIsShown and sIsUseDebuffIcon and (sIsShowOnHostile and tHostile) then
				sCurIcons[sUnit][anAuraInstanceId] = VUHDO_getOrCreateIconArray(sUnit, anIcon, anExpiry, aStacks, aDuration, true, aSpellId, anAuraInstanceId, aName, aCnt);

				if not anIsUpdate then
					VUHDO_addCurChosen(sUnit, anAuraInstanceId, nil, nil, nil, true);
				end
			end

			-- Either ability available OR none selected AND not removable (DETECT_DEBUFFS_REMOVABLE_ONLY)
			if not anIsUpdate and (tAbility or (sIsNotRemovableOnly and tHostile)) then -- VUHDO_DEBUFF_TYPE_NONE
				VUHDO_addCurChosen(sUnit, anAuraInstanceId, tType, nil, nil, nil);
				VUHDO_addUnitDebuffInfo(sUnit, "CHOSEN", anAuraInstanceId, anIcon, anExpiry, aStacks, aDuration);
			end
		end

	end



	--
	local tAuraInstanceId;
	local tName;
	local tIcon;
	local tApplications;
	local tDispelName;
	local tDuration;
	local tExpirationTime;
	local tSourceUnit;
	local tSpellId;
	local tIsBossAura;
	function VUHDO_determineAuraPredicate(anAuraData, anIsUpdate)

		if not anAuraData then
			return;
		end

		tAuraInstanceId = anAuraData.auraInstanceID;
		tName = anAuraData.name;
		tIcon = anAuraData.icon;
		tApplications = anAuraData.applications;
		tDispelName = anAuraData.dispelName;
		tDuration = anAuraData.duration;
		tExpirationTime = anAuraData.expirationTime;
		tSourceUnit = anAuraData.sourceUnit;
		tSpellId = anAuraData.spellId;
		tIsBossAura = anAuraData.isBossAura;

		if anAuraData.isHarmful then
			VUHDO_determineDebuffPredicate(
				tAuraInstanceId,
				tName,
				tIcon,
				tApplications,
				tDispelName,
				tDuration,
				tExpirationTime,
				tSourceUnit,
				tSpellId,
				tIsBossAura,
				anIsUpdate,
				sCnt
			);
		elseif anAuraData.isHelpful then
			VUHDO_determineBuffPredicate(
				tAuraInstanceId,
				tName,
				tIcon,
				tApplications,
				tDispelName,
				tDuration,
				tExpirationTime,
				tSourceUnit,
				tSpellId,
				anIsUpdate,
				sCnt
			);
		end

		VUHDO_updateHotPredicate(
			sUnit,
			sNow,
			tAuraInstanceId,
			tName,
			tIcon,
			tApplications,
			tDuration,
			tExpirationTime,
			tSourceUnit,
			tSpellId,
			anIsUpdate,
			sCnt
		);

		sCnt = sCnt + 1;

	end
end



--
local tCurChosenStoredName;
function VUHDO_getDeterminedDebuffInfo(aUnit, aDoUpdate)

	if not sAllDebuffSettings or not sCurChosen or not sCurChosen[aUnit] or not VUHDO_RAID or not VUHDO_RAID[aUnit] then
		return;
	end

	if aDoUpdate then
		VUHDO_updateCurChosen(aUnit);
	end

	if sCurChosen[aUnit][1] == VUHDO_DEBUFF_TYPE_NONE and VUHDO_RAID[aUnit]["missbuff"] and (sIsMiBuColorsInFight or not InCombatLockdown()) then
		sCurChosen[aUnit][1] = VUHDO_DEBUFF_TYPE_MISSING_BUFF;
	end

	-- we need to return the actual key that the debuff settings are stored under
	-- this key is either the debuff name or the debuff spell ID
	if sAllDebuffSettings[sCurChosen[aUnit][2]] ~= nil then
		tCurChosenStoredName = sCurChosen[aUnit][2];
	elseif sAllDebuffSettings[tostring(sCurChosen[aUnit][3] or -1)] ~= nil then
		tCurChosenStoredName = tostring(sCurChosen[aUnit][3]);
	end

	return sCurChosen[aUnit][1], tCurChosenStoredName;

end



--
local tDoUpdateInfo;
local tUnitCurIcons;
local tIconArray;
local tDebuffType;
local tDoUpdateChosen;
local tUnitCustomDebuffs;
local tUnitCustomDebuffInfo;
local tUnitCustomDebuffSpells;
local tName;
local tSpellCount;
local tSpellId;
local tSpellIdStr;
local function VUHDO_removeDebuff(aUnit, anAuraInstanceId)

	tDoUpdateInfo, tDebuffType, tDoUpdateChosen = false, nil, false;

	tUnitCurIcons = sCurIcons[aUnit];

	if tUnitCurIcons then
		tIconArray = tUnitCurIcons[anAuraInstanceId];

		if tIconArray then
			tUnitCurIcons[anAuraInstanceId] = nil;

			VUHDO_releasePooledIconArray(tIconArray);
		end
	end

	tUnitCurChosenInfo = sCurChosenInfo[aUnit];

	if tUnitCurChosenInfo and tUnitCurChosenInfo[anAuraInstanceId] then
		VUHDO_removeCurChosen(aUnit, anAuraInstanceId);
		tDoUpdateInfo = true;
	end

	if sUnitDebuffInfo and sUnitDebuffInfo["typeAuras"] and sUnitDebuffInfo["typeAuras"][anAuraInstanceId] then
		tDebuffType = sUnitDebuffInfo["typeAuras"][anAuraInstanceId][5];

		VUHDO_removeUnitDebuffInfo(aUnit, tDebuffType, anAuraInstanceId);
	end

	if sUnitDebuffInfo and sUnitDebuffInfo["chosenAuras"] and sUnitDebuffInfo["chosenAuras"][anAuraInstanceId] then
		VUHDO_removeUnitDebuffInfo(aUnit, "CHOSEN", anAuraInstanceId);
		tDoUpdateChosen = true;
	end

	tUnitCustomDebuffs = VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit];

	if tUnitCustomDebuffs and tUnitCustomDebuffs[anAuraInstanceId] then
		tUnitCustomDebuffInfo = tUnitCustomDebuffs[anAuraInstanceId];
		tUnitCustomDebuffs[anAuraInstanceId] = nil;

		VUHDO_releasePooledCustomDebuffInfo(tUnitCustomDebuffInfo);

		tUnitCustomDebuffSpells = VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit];

		if tUnitCustomDebuffSpells and tUnitCustomDebuffInfo then
			tName = tUnitCustomDebuffInfo[5];

			if tName then
				tSpellCount = tUnitCustomDebuffSpells[tName];

				if tSpellCount and tSpellCount > 0 then
					tUnitCustomDebuffSpells[tName] = tSpellCount - 1;
				end
			end

			tSpellId = tUnitCustomDebuffInfo[6];

			if tSpellId then
				tSpellIdStr = tostring(tSpellId);
				tSpellCount = tUnitCustomDebuffSpells[tSpellIdStr];

				if tSpellCount and tSpellCount > 0 then
					tUnitCustomDebuffSpells[tSpellIdStr] = tSpellCount - 1;
				end
			end
		end

	        VUHDO_updateBouquetsForEvent(aUnit, 29);
	end

	VUHDO_removeDebuffIcon(aUnit, anAuraInstanceId);

	return tDoUpdateInfo, tDebuffType, tDoUpdateChosen;

end



--
local tInfo;
local tDoStdSound;
local tUnitCustomDebuffs;
local tUnitCustomDebuffSpells;
local tUnitLastDebuff;
local tUnitCurChosenInfo;
local tCurIcons;
local tIcon;
local tExpiry;
local tStacks;
local tSpellId;
local tSpellIdStr;
local tAuraInstanceId;
local tName;
local tUnitDebuff;
local tDebuffSettings;
local tCurChosenInfo;
local tType;
local tFriend;
local tHostile;
local tAbility;
local tCnt;
local function VUHDO_updateDebuffs(aUnit)

	tInfo = (VUHDO_RAID or sEmpty)[aUnit];

	if not tInfo then
		return;
	end

	tDoStdSound = false;

	tUnitCustomDebuffs = VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit];
	tUnitCustomDebuffSpells = VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit];
	tUnitLastDebuff = VUHDO_LAST_UNIT_DEBUFFS[aUnit];
	tUnitCurChosenInfo = sCurChosenInfo and sCurChosenInfo[aUnit];

	tCurIcons = sCurIcons[aUnit];

	-- Gained new custom debuff?
	-- note we only play sounds for debuff customs with isIcon set to true
	if tCurIcons then
		for tAuraInstanceId, tDebuffInfo in pairs(tCurIcons) do
			-- tDebuffInfo: anIcon, anExpiry, aStacks, aDuration, anIsBuff, aSpellId, anAuraInstanceId, aName
			tIcon = tDebuffInfo[1];
			tExpiry = tDebuffInfo[2];
			tStacks = tDebuffInfo[3];

			tSpellId = tDebuffInfo[6];
			tSpellIdStr = tostring(tSpellId);

			tAuraInstanceId = tDebuffInfo[7];
			tName = tDebuffInfo[8];
			tCnt = tDebuffInfo[9];

			tUnitDebuff = tUnitCustomDebuffs[tAuraInstanceId];

			if not tUnitDebuff then
				tUnitDebuff = VUHDO_getPooledCustomDebuffInfo();

				tUnitDebuff[1], tUnitDebuff[2], tUnitDebuff[3], tUnitDebuff[4], tUnitDebuff[5], tUnitDebuff[6], tUnitDebuff[7] =
					tExpiry, tStacks, tIcon, tAuraInstanceId, tName, tSpellId, tCnt;

				tUnitCustomDebuffs[tAuraInstanceId] = tUnitDebuff;

				tUnitCustomDebuffSpells[tName] = (tUnitCustomDebuffSpells[tName] or 0) + 1;
				tUnitCustomDebuffSpells[tSpellIdStr] = (tUnitCustomDebuffSpells[tSpellIdStr] or 0) + 1;

				VUHDO_addDebuffIcon(aUnit, tIcon, tName, tExpiry, tStacks, tDebuffInfo[4], tDebuffInfo[5], tSpellId, tAuraInstanceId, tCnt);

				if not VUHDO_IS_CONFIG and VUHDO_MAY_DEBUFF_ANIM then
					-- the key used to store the debuff settings is either the debuff name or spell ID
					tDebuffSettings = sAllDebuffSettings[tName] or sAllDebuffSettings[tSpellIdStr];

					if tDebuffSettings then -- particular custom debuff sound?
						VUHDO_playDebuffSound(tDebuffSettings["SOUND"], tName);
					elseif sCustomDebuffSound then -- default custom debuff sound?
						VUHDO_playDebuffSound(sCustomDebuffSound, tName);
					end
				end

				tCurChosenInfo = tUnitCurChosenInfo[tAuraInstanceId];

				if sStdDebuffSound and tCurChosenInfo and tInfo["range"] then
					tType = tCurChosenInfo[1];

					if sIsDebuffSoundRemovableOnly then
						tFriend = UnitIsFriend("player", aUnit);
						tHostile = UnitIsEnemy("player", aUnit);

						tAbility = (VUHDO_PLAYER_DISPEL_ABILITIES[tType] and tFriend and not tHostile) or
							(VUHDO_PLAYER_PURGE_ABILITIES[tType] and (not tFriend or tHostile));

						if tAbility then
							tDoStdSound = true;
						end
					elseif (tType ~= VUHDO_DEBUFF_TYPE_NONE or tCurChosenInfo[4])
						and tType ~= VUHDO_DEBUFF_TYPE_CUSTOM and tType ~= tUnitLastDebuff then
						VUHDO_LAST_UNIT_DEBUFFS[aUnit] = tType;

						tDoStdSound = true;
					end
				end

				VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
			-- update number of stacks?
			elseif tUnitDebuff[1] ~= tExpiry or tUnitDebuff[2] ~= tStacks or tUnitDebuff[3] ~= tIcon
				or tUnitDebuff[4] ~= tAuraInstanceId or tUnitDebuff[5] ~= tName then
				tUnitDebuff[1], tUnitDebuff[2], tUnitDebuff[3], tUnitDebuff[4], tUnitDebuff[5], tUnitDebuff[7] =
					tExpiry, tStacks, tIcon, tAuraInstanceId, tName, tCnt;

				VUHDO_updateDebuffIcon(aUnit, tIcon, tName, tExpiry, tStacks, tDebuffInfo[4], tDebuffInfo[5], tSpellId, tAuraInstanceId, tCnt);

				VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
			end
		end
	end

	-- Play standard debuff sound?
	if sStdDebuffSound and tDoStdSound then
		VUHDO_playDebuffSound(sStdDebuffSound);
	end

end



--
local tInfo;
local tAura;
local tDoUpdate;
local tDoUpdateIter;
local tDoUpdateDebuffType;
local tDoUpdateDebuffChosen;
local tDoUpdateUnitDebuffInfo = { };
local tUnitCustomDebuffs;
local tUnitCurIcons;
local tUnitCustomDebuffSpells;
local tName;
local tSpellCount;
local tSpellId;
local tSpellIdStr;
function VUHDO_determineDebuff(aUnit, aUpdateInfo)

	tInfo = (VUHDO_RAID or sEmpty)[aUnit];

	if not tInfo then
		return 0, ""; -- VUHDO_DEBUFF_TYPE_NONE
	end

	sUnit = aUnit;
	sNow = GetTime();

	if (not aUpdateInfo and VUHDO_shouldScanUnit(aUnit)) or (aUpdateInfo and aUpdateInfo.isFullUpdate) then
		VUHDO_initHots(aUnit);

		sUnitDebuffInfo = VUHDO_initDebuffInfos(aUnit);

		sCnt = 1;
		ForEachAura(aUnit, "HARMFUL", nil, VUHDO_determineAuraPredicate, true);

		sCnt = 1;
		ForEachAura(aUnit, "HELPFUL", nil, VUHDO_determineAuraPredicate, true);
	elseif aUpdateInfo then
		sUnitDebuffInfo = (sCurIcons[aUnit] and sCurChosen[aUnit]) and VUHDO_UNIT_DEBUFF_INFOS[aUnit] or VUHDO_initDebuffInfos(aUnit);

		if aUpdateInfo.addedAuras then
			for _, tAuraData in pairs(aUpdateInfo.addedAuras) do
				VUHDO_determineAuraPredicate(tAuraData);
			end
		end

		if aUpdateInfo.updatedAuraInstanceIDs then
			for _, tAuraInstanceId in pairs(aUpdateInfo.updatedAuraInstanceIDs) do
				tAura = GetAuraDataByAuraInstanceID(aUnit, tAuraInstanceId);

				if tAura then
					VUHDO_determineAuraPredicate(tAura, true);
				end
			end
		end

		if aUpdateInfo.removedAuraInstanceIDs then
			tDoUpdate = false;

			tDoUpdateUnitDebuffInfo["CHOSEN"], tDoUpdateUnitDebuffInfo[1], tDoUpdateUnitDebuffInfo[2],
			tDoUpdateUnitDebuffInfo[3], tDoUpdateUnitDebuffInfo[4], tDoUpdateUnitDebuffInfo[8], tDoUpdateUnitDebuffInfo[9] =
				false, false, false, false, false, false, false;

			tDoUpdateIter, tDoUpdateDebuffType, tDoUpdateDebuffChosen = false, nil, false;

			for _, tAuraInstanceId in pairs(aUpdateInfo.removedAuraInstanceIDs) do
				VUHDO_removeHot(aUnit, tAuraInstanceId);

				tDoUpdateIter, tDoUpdateDebuffType, tDoUpdateDebuffChosen = VUHDO_removeDebuff(aUnit, tAuraInstanceId);

				if tDoUpdateIter then
					tDoUpdate = true;
				end

				if tDoUpdateDebuffType then
					tDoUpdateUnitDebuffInfo[tDoUpdateDebuffType] = true;
				end

				if tDoUpdateDebuffChosen then
					tDoUpdateUnitDebuffInfo["CHOSEN"] = true;
				end
			end

			if tDoUpdate then
				VUHDO_updateCurChosen(aUnit);
			end

			for tUpdateType, tDoUpdateType in pairs(tDoUpdateUnitDebuffInfo) do
				if tDoUpdateType then
					VUHDO_updateUnitDebuffInfo(aUnit, tUpdateType);
				end
			end
		end
	end

	VUHDO_updateHots(aUnit, tInfo);

	VUHDO_updateDebuffs(aUnit);

	tUnitCustomDebuffs = VUHDO_UNIT_CUSTOM_DEBUFFS and VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit];

	-- Lost old custom debuff?
	tUnitCustomDebuffs = VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit];
	tUnitCurIcons = sCurIcons[aUnit];

	if tUnitCustomDebuffs then
		for tAuraInstanceId, tUnitCustomDebuff in pairs(tUnitCustomDebuffs) do
			if tUnitCustomDebuff and (not tUnitCurIcons or not tUnitCurIcons[tAuraInstanceId]) then
				VUHDO_removeDebuff(aUnit, tAuraInstanceId);
			end
		end
	end

	return VUHDO_getDeterminedDebuffInfo(aUnit);

end
local VUHDO_determineDebuff = VUHDO_determineDebuff;



--
function VUHDO_updateAllCustomDebuffs(anIsEnableAnim)

	twipe(VUHDO_UNIT_CUSTOM_DEBUFFS);

	VUHDO_MAY_DEBUFF_ANIM = false;

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		-- FIXME: Classic flavors still require full debuff icon refresh
		VUHDO_removeAllDebuffIcons(tUnit);

		tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(tUnit);
	end

	VUHDO_MAY_DEBUFF_ANIM = anIsEnableAnim;

end



-- Remove debuffing abilities individually not known to the player
function VUHDO_initDebuffs()

	local tAbility;

	local _, tClass = UnitClass("player");

	twipe(VUHDO_PLAYER_DISPEL_ABILITIES);
	twipe(VUHDO_PLAYER_PURGE_ABILITIES);

	for tDebuffType, tAbilities in pairs(VUHDO_INIT_DISPEL_ABILITIES[tClass] or sEmpty) do
		for tCnt = 1, #tAbilities do
			tAbility = tAbilities[tCnt];

--			VUHDO_Msg("check: " .. tAbility);
			if VUHDO_isSpellKnown(tAbility) or tAbility == "*" then
				if VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility] then
					tAbility = VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility];
				elseif type(tAbility) == "number" then
					tAbility = GetSpellName(tAbility);
				end

				VUHDO_PLAYER_DISPEL_ABILITIES[tDebuffType] = tAbility;

--				VUHDO_Msg("KEEP: Type " .. tDebuffType .. " because of spell " .. VUHDO_PLAYER_DISPEL_ABILITIES[tDebuffType]);
				break;
			end
		end
	end
--	VUHDO_Msg("---");

	for tDebuffType, tAbilities in pairs(VUHDO_INIT_PURGE_ABILITIES[tClass] or sEmpty) do
		for tCnt = 1, #tAbilities do
			tAbility = tAbilities[tCnt];

			if VUHDO_isSpellKnown(tAbility) or tAbility == "*" then
				if VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility] then
					tAbility = VUHDO_SPEC_TO_DEBUFF_ABIL[tAbility];
				elseif type(tAbility) == "number" then
					tAbility = GetSpellName(tAbility);
				end

				VUHDO_PLAYER_PURGE_ABILITIES[tDebuffType] = tAbility;

				break;
			end
		end
	end

	if not VUHDO_CONFIG then
		VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	end

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
function VUHDO_getDispelAbilities()

	return VUHDO_PLAYER_DISPEL_ABILITIES;

end



--
function VUHDO_getPurgeAbilities()

	return VUHDO_PLAYER_PURGE_ABILITIES;

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
function VUHDO_getUnitDebuffInfos(aUnit)

	return VUHDO_UNIT_DEBUFF_INFOS[aUnit];

end



--
function VUHDO_resetDebuffsFor(aUnit)
	VUHDO_initDebuffInfos(aUnit);

	-- FIXME: Classic flavors still require full debuff icon refresh
	twipe(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit]);
end



--
function VUHDO_getUnitCustomDebuffs()
	
	return VUHDO_UNIT_CUSTOM_DEBUFFS;

end



--
function VUHDO_getDebuffCurIcons()

	return sCurIcons;

end



--
function VUHDO_getDebuffCurChosenInfo()

	return sCurChosenInfo;

end



--
function VUHDO_getDebuffCurChosenListHead()

	return sCurChosenListHead;

end



--
function VUHDO_getDebuffCurChosen()

	return sCurChosen;

end



--
function VUHDO_getDebuffCurChosenColor()

	return sCurChosenColor;

end



--
function VUHDO_getUnitCustomDebuffSpells()

	return VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS;

end



--
function VUHDO_hasUnitDebuff(aUnit, aSpell)

	if not aUnit or not aSpell then
		return;
	end

	if type(aSpell) == "number" then
		aSpell = tostring(aSpell);
	end

	if VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit] and (VUHDO_UNIT_CUSTOM_DEBUFF_SPELLS[aUnit][aSpell] or 0) > 0 then
		return true;
	else
		return false;
	end

end
