local _;

local huge = math.huge;
local strsub = strsub;
local InCombatLockdown = InCombatLockdown;
local twipe = table.wipe;
local tinsert = tinsert;
local strfind = strfind;
local strsplit = strsplit;
local strbyte = strbyte;
local floor = floor;
local tonumber = tonumber;
local select = select;
local strmatch = strmatch;
local IsInRaid = IsInRaid;
local IsInGroup = IsInGroup;
local UnitInRange = UnitInRange;
local GetRaidRosterInfo = GetRaidRosterInfo;
local IsInInstance = IsInInstance;
local IsSpellInRange = IsSpellInRange;
local GetTime = GetTime;
local GetRealZoneText = GetRealZoneText;
local GetSpellInfo = GetSpellInfo;
local SetMapToCurrentZone = SetMapToCurrentZone;
local UnitPowerBarID = UnitPowerBarID;
local GetUnitPowerBarInfoByID = GetUnitPowerBarInfoByID;
local WorldMapFrame = WorldMapFrame;
local GetMouseFocus = GetMouseFocus;
local GetPlayerFacing = GetPlayerFacing;
local GetSpellBookItemInfo = GetSpellBookItemInfo;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsUnit = UnitIsUnit;
local IsSpellInRange = IsSpellInRange;
local UnitInRange = UnitInRange;
local IsAltKeyDown = IsAltKeyDown;
local IsControlKeyDown = IsControlKeyDown;
local IsShiftKeyDown = IsShiftKeyDown;
local VUHDO_atan2 = math.atan2;
local VUHDO_PI, VUHDO_2_PI = math.pi, math.pi * 2;
local floor = floor;
local pairs = pairs;
local type = type;
local abs = abs;
local GetAuraDataBySlot = C_UnitAuras and C_UnitAuras.GetAuraDataBySlot;
local GetAuraDataBySpellName = C_UnitAuras and C_UnitAuras.GetAuraDataBySpellName;
local GetAuraSlots = C_UnitAuras and C_UnitAuras.GetAuraSlots;
local UnpackAuraData = AuraUtil.UnpackAuraData or VUHDO_unpackAuraData;
local FindAura = AuraUtil.FindAura;
local FindAuraByName = AuraUtil.FindAuraByName;

-- Number of seconds into the future to look for incoming heals
-- This ensures we only include the next incoming tick of HoTs
local VUHDO_INCOMING_HEAL_WINDOW = 4;

-- talent cache maps for new large Dragonflight talent trees
local VUHDO_TALENT_CACHE_SPELL_ID = {
	-- [<spell ID>] = <spell name>,
};

local VUHDO_TALENT_CACHE_SPELL_NAME = {
	-- [<spell name>] = <spell ID>,
};

local sEmpty = { };
setmetatable(sEmpty, { __newindex = function(aTable, aKey, aValue) VUHDO_xMsg("WARNING: newindex on dummy array: ", aKey, aValue); end });

-- Common meta tables

VUHDO_META_EMPTY_ARRAY = {
	__index = function (aTable, aKey)
		return sEmpty;
	end
};

VUHDO_META_NEW_ARRAY = {
	__index = function(aTable, aKey)
		local tValue = { };
		rawset(aTable, aKey, tValue);
		return tValue;
	end
};



-- returns an array of numbers sequentially found in a string
local tNumbers = { };
local tIndex;
local tDigit;
local tIsInNumber;
function VUHDO_getNumbersFromString(aName, aMaxAnz)
	twipe(tNumbers);
	tIndex = 0;
	tIsInNumber = false;

	for tCnt = 1, #aName do
		tDigit = strbyte(aName, tCnt);
		if tDigit >= 48 and tDigit <= 57 then
			if tIsInNumber then
				tNumbers[tIndex] = tNumbers[tIndex] * 10 + tDigit - 48;
			else
				tIsInNumber = true;
				tIndex = tIndex + 1;
				tNumbers[tIndex] = tDigit - 48;
			end
		else
			if tIndex >= aMaxAnz then	return tNumbers; end
			tIsInNumber = false;
		end
	end

	return tNumbers;
end



--
--[[VUHDO_COMBAT_LOG_TRACE = {};
local tEntry;
function VUHDO_traceCombatLog(anArg1, anArg2, anArg3, anArg4, anArg5, anArg6, anArg7, anArg8, anArg9, anArg10, anArg11, anArg12, anArg13, anArg14)
	tEntry = "";
	tEntry = tEntry .. "[1]:" .. (anArg1 or "<nil>") .. ",";
	tEntry = tEntry .. "[2]:" .. (anArg2 or "<nil>") .. ",";
	tEntry = tEntry .. "[3]:" .. (anArg3 or "<nil>") .. ",";
	tEntry = tEntry .. "[4]:" .. (anArg4 or "<nil>") .. ",";
	tEntry = tEntry .. "[5]:" .. (anArg5 or "<nil>") .. ",";
	tEntry = tEntry .. "[6]:" .. (anArg6 or "<nil>") .. ",";
	tEntry = tEntry .. "[7]:" .. (anArg7 or "<nil>") .. ",";
	tEntry = tEntry .. "[8]:" .. (anArg8 or "<nil>") .. ",";
	tEntry = tEntry .. "[9]:" .. (anArg9 or "<nil>") .. ",";
	tEntry = tEntry .. "[10]:" .. (anArg10 or "<nil>") .. ",";
	tEntry = tEntry .. "[11]:" .. (anArg11 or "<nil>") .. ",";
	tEntry = tEntry .. "[12]:" .. (anArg12 or "<nil>") .. ",";
	tEntry = tEntry .. "[13]:" .. (anArg13 or "<nil>") .. ",";
	tEntry = tEntry .. "[14]:" .. (anArg14 or "<nil>") .. ",";
	tEntry = tEntry .. "[15]:" .. (anArg15 or "<nil>") .. ",";
	tEntry = tEntry .. "[16]:" .. (anArg16 or "<nil>") .. ",";
	tinsert(VUHDO_COMBAT_LOG_TRACE, tEntry);
end]]



--
function VUHDO_tableUniqueAdd(aTable, aValue)
	for _, tValue in pairs(aTable) do
		if tValue == aValue then return false; end
	end

	aTable[#aTable + 1] = aValue;
	return true;
end



--
function VUHDO_tableRemoveValue(aTable, aValue)
	for tIndex, tValue in pairs(aTable) do
		if tValue == aValue then tremove(aTable, tIndex); return; end
	end
end



--
function VUHDO_tableGetKeyFromValue(aTable, aValue)
	for tKey, tValue in pairs(aTable) do
		if tValue == aValue then return tKey; end
	end

	return nil;
end


----------------------------------------------------
local VUHDO_RAID_NAMES;
local VUHDO_RAID;
local VUHDO_UNIT_BUTTONS;
local VUHDO_CONFIG;
local VUHDO_GROUPS_BUFFS;
local VUHDO_BOSS_UNITS;
local sRangeSpell;
local sIsHelpfulGuessRange = true;
local sIsHarmfulGuessRange = true;
local sScanRange;
local sZeroRange = "";


--
local VUHDO_updateBouquetsForEvent;
function VUHDO_toolboxInitLocalOverrides()
	VUHDO_RAID_NAMES = _G["VUHDO_RAID_NAMES"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_UNIT_BUTTONS = _G["VUHDO_UNIT_BUTTONS"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_GROUPS_BUFFS = _G["VUHDO_GROUPS_BUFFS"];
	VUHDO_BOSS_UNITS = _G["VUHDO_BOSS_UNITS"];
	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	sScanRange = tonumber(VUHDO_CONFIG["SCAN_RANGE"]);

	-- FIXME: why can't model sanity be run prior to burst cache initialization?
	if type(VUHDO_CONFIG["RANGE_SPELL"]) == "table" and type(VUHDO_CONFIG["RANGE_PESSIMISTIC"]) == "table" then
		sRangeSpell = VUHDO_CONFIG["RANGE_SPELL"];
		sIsHelpfulGuessRange = VUHDO_CONFIG["RANGE_PESSIMISTIC"]["HELPFUL"] or GetSpellInfo(sRangeSpell["HELPFUL"]) == nil;
		sIsHarmfulGuessRange = VUHDO_CONFIG["RANGE_PESSIMISTIC"]["HARMFUL"] or GetSpellInfo(sRangeSpell["HARMFUL"]) == nil;
	end

	sZeroRange = "0.0 " .. VUHDO_I18N_YARDS;
end



local VUHDO_PROFILE_TIMER;

--
function VUHDO_initProfiler()
	VUHDO_PROFILE_TIMER = GetTime() * 1000;
end



--
function VUHDO_seeProfiler()
	VUHDO_xMsg("D: ", floor(GetTime() * 1000 - VUHDO_PROFILE_TIMER));
end



-- Print chat frame line with no "{Vuhdo} prefix
function VUHDO_MsgC(aMessage, aRed, aGreen, aBlue)
	aRed, aGreen, aBlue = aRed or 1, aGreen or 0.7, aBlue or 0.2;
	DEFAULT_CHAT_FRAME:AddMessage(aMessage, aRed, aGreen, aBlue);
end



--
local function VUHDO_arg2Text(anArg)
	if anArg == nil  then return "<nil>";
	elseif "function" == type(anArg) then return "<func>";
	elseif "table" == type(anArg) then return "<table>";
	elseif "boolean" == type(anArg) then return anArg and "<true>" or  "<false>";
	elseif anArg == "" then return " ";
	else return anArg; end
end



-- Print a standard chat frame
function VUHDO_Msg(aMessage, aRed, aGreen, aBlue)
	VUHDO_MsgC("|cffffe566{VuhDo}|r " .. VUHDO_arg2Text(aMessage), aRed, aGreen, aBlue)
end



--
function VUHDO_xMsg(...)
	local tText = "";

	for tCnt = 1, select('#', ...) do
		tText = tText .. tCnt .. "=[" .. VUHDO_arg2Text(select(tCnt, ...)) .. "] ";
	end
	VUHDO_MsgC(tText);
end



--
function VUHDO_getCurrentGroupType()
	return IsInRaid() and 2 or IsInGroup() and 1 or 0;
end
local VUHDO_getCurrentGroupType = VUHDO_getCurrentGroupType;



-- returns unit-prefix, pet-prefix and maximum number of players in a party
function VUHDO_getUnitIds()
	if IsInRaid() then return "raid", "raidpet";
	elseif IsInGroup() then	return "party", "partypet";
	else return "player", "pet"; end
end



-- Extracts unit number from a Unit's name
local tUnitNo;
function VUHDO_getUnitNo(aUnit)
	if not aUnit or VUHDO_isSpecialUnit(aUnit) then return 0; end
	if "player" == aUnit then aUnit = VUHDO_PLAYER_RAID_ID or "player"; end
	return tonumber(strsub(aUnit, -2, -1)) or tonumber(strsub(aUnit, -1)) or 1;
end
local VUHDO_getUnitNo = VUHDO_getUnitNo;



-- returns the units subgroup number, or 0 for pets/focus
function VUHDO_getUnitGroup(aUnit, anIsPet)
	if anIsPet or not aUnit or VUHDO_isSpecialUnit(aUnit) then return 0;
	elseif VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() then
		return select(3, GetRaidRosterInfo(VUHDO_getUnitNo(aUnit))) or 1;
	else return 1; end
end



--
function VUHDO_checkInteractDistance(aUnit, aDistIndex)

	if not InCombatLockdown() then
		return CheckInteractDistance(aUnit, aDistIndex);
	else
		if not sIsHarmfulGuessRange and UnitCanAttack("player", aUnit) then
			return (IsSpellInRange(sRangeSpell["HARMFUL"], aUnit) == 1) and true or false;
		elseif not sIsHelpfulGuessRange then
			return (IsSpellInRange(sRangeSpell["HELPFUL"], aUnit) == 1) and true or false;
		else
			-- default to showing in-range when we don't know any better
			return true;
		end
	end
	
end
local VUHDO_checkInteractDistance = VUHDO_checkInteractDistance;



--
function VUHDO_isTargetInRange(aUnit)

	return UnitIsUnit("player", aUnit) or VUHDO_checkInteractDistance(aUnit, 1);

end
local VUHDO_isTargetInRange = VUHDO_isTargetInRange;



-- FIXME: workaround for Blizzard API bug: https://github.com/Stanzilla/WoWUIBugs/issues/49
function VUHDO_unitPhaseReason(aUnit) 

	if not aUnit then
		return nil;
	end

	if not UnitPhaseReason then
		return nil;
	end

	local tPhaseReason = UnitPhaseReason(aUnit);

	if (tPhaseReason == Enum.PhaseReason.WarMode or tPhaseReason == Enum.PhaseReason.ChromieTime) and UnitIsVisible(aUnit) then
		return nil;
	else
		return tPhaseReason;
	end

end



-- returns whether or not a unit is in range
function VUHDO_isInRange(aUnit)
	
	if "player" == aUnit then 
		return true;
	elseif VUHDO_isSpecialUnit(aUnit) then 
		return VUHDO_isTargetInRange(aUnit);
	elseif VUHDO_unitPhaseReason(aUnit) then
		return false;
	else
		local tIsGuessRange;
		local tRangeSpell;

		if UnitCanAttack("player", aUnit) then
			tIsGuessRange = sIsHarmfulGuessRange;
			tRangeSpell = sRangeSpell["HARMFUL"];
		else
			tIsGuessRange = sIsHelpfulGuessRange;
			tRangeSpell = sRangeSpell["HELPFUL"];
		end

		if tIsGuessRange or not tRangeSpell then
			return UnitInRange(aUnit);
		end

		local tIsSpellInRange = IsSpellInRange(tRangeSpell, aUnit);

		if tIsSpellInRange ~= nil then
			return (tIsSpellInRange == 1) and true or false;
		else
			return UnitInRange(aUnit);
		end
	end

end



-- Parses a aString line into an array of arguments
function VUHDO_textParse(aString)
	aString = strtrim(aString);

	while strfind(aString, "  ", 1, true) do
		aString = gsub(aString, "  ", " ");
	end

	return VUHDO_splitStringQuoted(aString);
end



-- Returns a "deep" copy of a table,
-- which means containing tables will be copies value-wise, not by reference
function VUHDO_deepCopyTable(aTable)
	local tDestTable = { };

	for tKey, tValue in pairs(aTable) do
		tDestTable[tKey] = "table" == type(tValue) and VUHDO_deepCopyTable(tValue) or tValue;
	end

	return tDestTable;
end



-- Tokenizes a String into an array of strings, which were delimited by "aChar"
function VUHDO_splitString(aText, aChar)
	return { strsplit(aChar, aText) };
end



function VUHDO_splitStringQuoted(aText) 

	if VUHDO_strempty(aText) then
		return { "" };
	end

	local tSplit = {};
	local tPrevToken, tQuoteToken; 

	for tToken in string.gmatch(aText, "%S+") do 
		local tStartQuote = string.match(tToken, [[^(['"])]]); 
		local tEndQuote = string.match(tToken, [[(['"])$]]);

		if tStartQuote and not tEndQuote and not tQuoteToken then 
			tPrevToken = tToken; 
			tQuoteToken = tStartQuote; 
		elseif tPrevToken and tQuoteToken == tEndQuote then 
			tToken = tPrevToken .. ' ' .. tToken;

			tPrevToken = nil;
			tQuoteToken = nil;
		elseif tPrevToken then 
			tPrevToken = tPrevToken .. ' ' .. tToken; 
		end 

		if not tPrevToken then
			tToken = string.gsub(tToken, [[^(['"])]], "");
			tToken = string.gsub(tToken, [[(['"])$]], "");

			table.insert(tSplit, tToken); 
		end
	end

	return tSplit;

end

-- returns true if player currently is in a battleground
local tType;
function VUHDO_isInBattleground()
	_, tType = IsInInstance();
	return "pvp" == tType or "arena" == tType;
end
local VUHDO_isInBattleground = VUHDO_isInBattleground;



-- returns the appropriate addon message channel for player
function VUHDO_getAddOnDistribution()
	return VUHDO_isInBattleground() and "BATTLEGROUND"
		or VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() and "RAID" or "PARTY";
end



-- returns the units rank in a raid which is 0 = raid member, 1 = assist, 2 = leader
-- returns 2 if not in raid
local tRank, tIsMl, tGroupType;
function VUHDO_getUnitRank(aUnit)
	tGroupType = VUHDO_getCurrentGroupType();
	if VUHDO_GROUP_TYPE_RAID == tGroupType then
		_, tRank, _, _, _, _, _, _, _, _, tIsMl = GetRaidRosterInfo(VUHDO_getUnitNo(aUnit));
		return tRank, tIsMl;
	elseif VUHDO_GROUP_TYPE_PARTY == tGroupType then return  UnitIsGroupLeader(aUnit) and 2 or 0, true;
	else return 2, true; end
end



-- returns the players rank in a raid which is 0 = raid member, 1 = assist, 2 = leader
-- returns leader if not in raid, and member if solo, as no main tank are needed
function VUHDO_getPlayerRank()
	return VUHDO_getUnitRank("player");
end



-- returns the raid unit of player eg. "raid13" or "party4"
local tRaidUnit;
function VUHDO_getPlayerRaidUnit()
	if VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() then
		for tCnt = 1, 40 do
			tRaidUnit = "raid" .. tCnt;
			if UnitIsUnit("player", tRaidUnit) then return tRaidUnit; end
		end
	end
	return "player";
end
local VUHDO_getPlayerRaidUnit = VUHDO_getPlayerRaidUnit;



--
function VUHDO_getNumGroupMembers(aGroupId)
	return #(VUHDO_GROUPS[aGroupId] or sEmpty);
end



--
local tZone, tIndex, tMap, tMapId, tInfo;
function VUHDO_getUnitZoneName(aUnit)
	tInfo = VUHDO_RAID[aUnit];
	if not tInfo then return; end

	if "player" == aUnit or tInfo["visible"] then 
		tZone = GetRealZoneText();
	elseif VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() then
		tIndex = (VUHDO_RAID[aUnit] or sEmpty)["number"] or 1;
		_, _, _, _, _, _, tZone = GetRaidRosterInfo(tIndex);
	else
		VuhDoScanTooltip:SetOwner(VuhDo, "ANCHOR_NONE");
		VuhDoScanTooltip:ClearLines();
		VuhDoScanTooltip:SetUnit(aUnit);

		if VuhDoScanTooltip:NumLines() > 2 then
			tZone = VuhDoScanTooltipTextLeft3:GetText();
		end
	
		if tZone and tZone == "PvP" and VuhDoScanTooltip:NumLines() > 3 then 
			tZone = VuhDoScanTooltipTextLeft4:GetText();
		end
	end

	-- 8.0.1 build 26567 added restrictions (must be in player's party) on which unit IDs can be queried
	tMapId = C_Map.GetBestMapForUnit(aUnit);
	
	if tMapId then
		tMap = C_Map.GetMapInfo(tMapId);
	end

	return tZone or (tMap and tMap["name"]) or VUHDO_I18N_UNKNOWN, tMap and tMap["name"] or nil;
end



--
local tName, tEnchant;
function VUHDO_getWeaponEnchantName(aSlot)
	VuhDoScanTooltip:SetOwner(VuhDo, "ANCHOR_NONE");
	VuhDoScanTooltip:ClearLines();
	VuhDoScanTooltip:SetInventoryItem("player", aSlot);
	for tCnt = 1, VuhDoScanTooltip:NumLines() do
		tName = strmatch(_G["VuhDoScanTooltipTextLeft" .. tCnt]:GetText(), "^.+ %(%d+%s+.+%)$");
		if tName then
			tEnchant = gsub(tName, " [0-9]+ %(.+%)", "");
			return tEnchant;
		end
	end

	return "*";
end



--
function VUHDO_isInSameZone(aUnit)
	return (VUHDO_RAID[aUnit] or sEmpty)["zone"] == (VUHDO_RAID["player"] or sEmpty)["zone"];
end
local VUHDO_isInSameZone = VUHDO_isInSameZone;



-- Returns health of unit info in Percent
local tHealthMax;
function VUHDO_getUnitHealthPercent(anInfo)
	tHealthMax = anInfo["healthmax"];
	return tHealthMax == 0 and 0
		or anInfo["health"] < tHealthMax and 100 * anInfo["health"] / tHealthMax or 100;
end



--
function VUHDO_isSpellKnown(aSpellName)

	if not aSpellName then
		return false;
	end

	if (type(aSpellName) == "number" and IsSpellKnown(aSpellName))
		or (type(aSpellName) == "number" and IsSpellKnownOrOverridesKnown(aSpellName))
		or (type(aSpellName) == "number" and IsPlayerSpell(aSpellName))
		or GetSpellBookItemInfo(aSpellName) ~= nil
		or VUHDO_NAME_TO_SPELL[aSpellName] ~= nil and GetSpellBookItemInfo(VUHDO_NAME_TO_SPELL[aSpellName]) then
		return true;
	elseif type(aSpellName) ~= "number" then
		_, _, _, _, _, _, tSpellId = GetSpellInfo(aSpellName);

		if tSpellId then
			return IsSpellKnownOrOverridesKnown(tSpellId) or IsSpellKnown(tSpellId) or IsPlayerSpell(tSpellId);
		end
	end

	return false;

end


--
function VUHDO_initTalentSpellCaches()

	if not C_ClassTalents then
		return;
	end

	local tActiveConfigId = C_ClassTalents.GetActiveConfigID();

	-- on initial PLAYER_ENTER_WORLD talents are not yet available
	if not tActiveConfigId then
		return;
	end

	twipe(VUHDO_TALENT_CACHE_SPELL_ID);
	twipe(VUHDO_TALENT_CACHE_SPELL_NAME);

	local tConfigInfo = C_Traits.GetConfigInfo(tActiveConfigId);

	for _, tTreeId in pairs(tConfigInfo.treeIDs) do
		local tTreeNodes = C_Traits.GetTreeNodes(tTreeId);

		for _, tNodeId in pairs(tTreeNodes) do
			local tNodeInfo = C_Traits.GetNodeInfo(tActiveConfigId, tNodeId);

			if tNodeInfo and tNodeInfo.entryIDsWithCommittedRanks then
				for _, tEntryId in ipairs(tNodeInfo.entryIDsWithCommittedRanks) do
					local tEntryInfo = C_Traits.GetEntryInfo(tActiveConfigId, tEntryId);
				
					if tEntryInfo and tEntryInfo.definitionID then
						local tDefinitionInfo = C_Traits.GetDefinitionInfo(tEntryInfo.definitionID);

						if tDefinitionInfo and tDefinitionInfo.spellID then
							local tSpellName = GetSpellInfo(tDefinitionInfo.spellID);

							VUHDO_TALENT_CACHE_SPELL_ID[tDefinitionInfo.spellID] = tSpellName;
							VUHDO_TALENT_CACHE_SPELL_NAME[tSpellName] = tDefinitionInfo.spellID;
						end
					end
				end
			end
		end
	end

	return;

end



--
function VUHDO_getTalentSpellId(aTalentName)

	if type(aTalentName) == "number" then
		return VUHDO_TALENT_CACHE_SPELL_ID[aTalentName] and aTalentName or nil;
	else
		return VUHDO_TALENT_CACHE_SPELL_NAME[aTalentName] or nil;
	end

end



--
function VUHDO_isTalentKnown(aTalentName)
	return VUHDO_getTalentSpellId(aTalentName) and true or false;
end


--
local tDeltaSecs;
function VUHDO_getDurationTextSince(aStartTime)
	if not aStartTime then return ""; end

	tDeltaSecs = GetTime() - aStartTime;
	return tDeltaSecs >= 3600
		and format("(|cffffffff%.0f:%02d %s|r)", tDeltaSecs / 3600, floor(tDeltaSecs / 60) % 60, VUHDO_I18N_HOURS)
		or format("(|cffffffff%d:%02d %s|r)", tDeltaSecs / 60, tDeltaSecs % 60, VUHDO_I18N_MINS);
end



--
local tDistance;
function VUHDO_getDistanceText(aUnit)
	tDistance = VUHDO_getDistanceBetween("player", aUnit);
	return tDistance ~= nil and tDistance or "player" == aUnit and sZeroRange or VUHDO_I18N_UNKNOWN;
end



--
local sTargetUnits = { };
function VUHDO_getTargetUnit(aSourceUnit)
	if not sTargetUnits[aSourceUnit] then
		sTargetUnits[aSourceUnit] = "player" == aSourceUnit and "target" or aSourceUnit .. "target";
	end

	return sTargetUnits[aSourceUnit];
end



--
local tResurrectionSpells;
local tKnownResurrectionSpells;
function VUHDO_getResurrectionSpells()
	tResurrectionSpells = (VUHDO_RESURRECTION_SPELLS[VUHDO_PLAYER_CLASS] or sEmpty)[VUHDO_getSpecialization() or 0];

	if tResurrectionSpells then
		tKnownResurrectionSpells = { };

		for _, tResurrectionSpell in ipairs(tResurrectionSpells) do
			if VUHDO_isSpellKnown(tResurrectionSpell) and IsUsableSpell(tResurrectionSpell) then
				tinsert(tKnownResurrectionSpells, tResurrectionSpell);
			end
		end

		return unpack(tKnownResurrectionSpells);
	else
		return nil;
	end
end



--
local tInfo;
function VUHDO_resolveVehicleUnit(aUnit)
	tInfo = VUHDO_RAID[aUnit] or sEmpty;
	return tInfo["isPet"] and (VUHDO_RAID[tInfo["ownerUnit"]] or sEmpty)["isVehicle"]
		and tInfo["ownerUnit"] or aUnit;
end



--
function VUHDO_getUnitButtons(aUnit)
	return VUHDO_UNIT_BUTTONS[aUnit];
end


function VUHDO_getUnitButtonsSafe(aUnit)
	return VUHDO_UNIT_BUTTONS[aUnit] or sEmpty;
end


--
function VUHDO_getUnitButtonsPanel(aUnit, aPanelNum)
	return (VUHDO_UNIT_BUTTONS_PANEL[aUnit] or sEmpty)[aPanelNum] or sEmpty;
end



--
local tInfo;
function VUHDO_shouldScanUnit(aUnit)
	tInfo = VUHDO_RAID[aUnit] or sEmpty;
	if not tInfo["connected"] or tInfo["dead"] then	return true;
	elseif sScanRange == 1 then	return VUHDO_isInSameZone(aUnit);
	elseif sScanRange == 2 then	return tInfo["visible"];
	elseif sScanRange == 3 then	return tInfo["baseRange"];
	else return true; end
end



--
local tNumChars;
local tNumCut;
local tByte;
function VUHDO_utf8Cut(aString, aNumChars)
	tNumCut = 1;
	tNumChars = 0;
	while tNumCut < #aString and tNumChars < aNumChars do
		tByte = strbyte(aString, tNumCut);

		tNumCut = tNumCut + (
			    tByte < 194 and 1
			 or tByte < 224 and 2
			 or tByte < 240 and 3
			 or tByte < 245 and 4
			 or 1 -- invalid
		);

		tNumChars = tNumChars + 1;
	end

	return strsub(aString, 1, tNumCut - 1);
end



--
function VUHDO_strempty(aString)
	if (aString or "") ~= "" then
		for tCnt = 1, #aString do
			if strbyte(aString, tCnt) ~= 32 then return false; end
		end
	end

	return true;
end



--
function VUHDO_tableAddAllKeys(aDestTable, aTableToAdd)
	for tIndex, tValue in pairs(aTableToAdd) do
		aDestTable[tIndex] = tValue;
	end
end



-- Throttle resetting to current map to avoid conflicts with other addons
local tNextTime = 0;
local tMap;
function VUHDO_setMapToCurrentZone()
	if tNextTime < GetTime() then
		tMap = C_Map.GetBestMapForUnit("player");
		
		if tMap and WorldMapFrame ~= nil then
			WorldMapFrame:SetMapID(tMap);
		end

		tNextTime = GetTime() + 2;
	end
end
local VUHDO_setMapToCurrentZone = VUHDO_setMapToCurrentZone;



--
local tInfo;
function VUHDO_replaceMacroTemplates(aText, aUnit)
	if aUnit then
		aText = gsub(aText, "[Vv][Uu][Hh][Dd][Oo]", aUnit);
		tInfo = VUHDO_RAID[aUnit];
		if tInfo then
			aText = gsub(aText, "[Vv][Dd][Nn][Aa][Mm][Ee]", tInfo["name"]);

			if tInfo["petUnit"] then
				aText = gsub(aText, "[Vv][Dd][Pp][Ee][Tt]", tInfo["petUnit"]);
			end

			if tInfo["targetUnit"] then
				aText = gsub(aText, "[Vv][Dd][Tt][Aa][Rr][Gg][Ee][Tt]", tInfo["targetUnit"]);
			end
		end
	end

	return aText;
end



--
local tActionLowerName;
local tIsMacroKnown;
local tIsSpellKnown; 
local tIsTalentKnown;
local tIsHostileAction, tIsFriendlyAction;
function VUHDO_isActionValid(anActionName, anIsCustom, anIsHostile)

	if (anActionName or "") == "" then
		return nil;
	end

	tIsHostileAction = false;
	tIsFriendlyAction = false;
	tActionLowerName = strlower(anActionName);

	if anIsHostile then
		if (VUHDO_SPELL_KEY_ASSIST == tActionLowerName 
		 or VUHDO_SPELL_KEY_FOCUS == tActionLowerName
		 or VUHDO_SPELL_KEY_TARGET == tActionLowerName 
		 or VUHDO_SPELL_KEY_EXTRAACTIONBUTTON == tActionLowerName 
		 or VUHDO_SPELL_KEY_MOUSELOOK == tActionLowerName) then
			tIsHostileAction = true;
		end
	else
		if VUHDO_SPELL_KEY_ASSIST == tActionLowerName 
		 or VUHDO_SPELL_KEY_FOCUS == tActionLowerName 
		 or VUHDO_SPELL_KEY_MENU == tActionLowerName 
		 or VUHDO_SPELL_KEY_TELL == tActionLowerName 
		 or VUHDO_SPELL_KEY_TARGET == tActionLowerName 
		 or VUHDO_SPELL_KEY_EXTRAACTIONBUTTON == tActionLowerName 
		 or VUHDO_SPELL_KEY_MOUSELOOK == tActionLowerName 
		 or VUHDO_SPELL_KEY_DROPDOWN == tActionLowerName then
			tIsFriendlyAction = true;
		end
	end

	tIsMacroKnown = GetMacroIndexByName(anActionName) ~= 0;

	if tIsHostileAction or tIsFriendlyAction then
		if tIsMacroKnown then
			VUHDO_Msg(format(VUHDO_I18N_AMBIGUOUS_MACRO, anActionName), 1, 0.3, 0.3);
			return VUHDO_I18N_WARNING, 1, 0.3, 0.3, "WRN";
		else
			return VUHDO_I18N_COMMAND, 0.8, 1, 0.8, "CMD";
		end
	end

	tIsSpellKnown = VUHDO_isSpellKnown(anActionName);

	if not tIsSpellKnown then
		tIsTalentKnown = VUHDO_isTalentKnown(anActionName);
	end

	if (tIsSpellKnown or tIsTalentKnown) and tIsMacroKnown then
		VUHDO_Msg(format(VUHDO_I18N_AMBIGUOUS_MACRO, anActionName), 1, 0.3, 0.3);
		return VUHDO_I18N_WARNING, 1, 0.3, 0.3, "WRN";
	elseif tIsMacroKnown then
		return VUHDO_I18N_MACRO, 0.8, 0.8, 1, "MCR";
	elseif (tIsSpellKnown or tIsTalentKnown) then
		return VUHDO_I18N_SPELL, 1, 0.8, 0.8, "SPL";
	elseif IsUsableItem(anActionName) then
		return VUHDO_I18N_ITEM, 1, 1, 0.8, "ITM";
	elseif anIsCustom then
		return "Custom", 0.9, 0.9, 0.2, "CUS";
	elseif tActionLowerName == "13" then
		return VUHDO_I18N_TRINKET_1, 1, 1, 0.8, "TKT1";
	elseif tActionLowerName == "14" then
		return VUHDO_I18N_TRINKET_2, 1, 1, 0.8, "TKT2";
	else
		return nil;
	end

end



--
function VUHDO_isAltPowerActive(aUnit)

	if not UnitPowerBarID or not GetUnitPowerBarInfoByID then
		return false;
	end

	local tBarId = UnitPowerBarID(aUnit);
	local tBarInfo = GetUnitPowerBarInfoByID(tBarId);

	if tBarInfo then 
		return tBarInfo.barType and (not tBarInfo.hideFromOthers or "player" == aUnit);
	else
		return false;
	end

end



--
function VUHDO_decompressStringHuffman(aFile)
	return "string" == type(aFile) and VUHDO_LibCompress:DecompressHuffman(aFile) or aFile;
end



--
function VUHDO_compressStringHuffman(aFile)
	return "string" == type(aFile) and VUHDO_LibCompress:CompressHuffman(aFile) or aFile;
end



--
function VUHDO_decompressIfCompressed(aFile)
	return "string" == type(aFile) and VUHDO_deserializeTable(VUHDO_decompressStringHuffman(aFile)) or aFile;
end



--
function VUHDO_decompressOrCopy(aFile)
	return "string" == type(aFile) and VUHDO_deserializeTable(VUHDO_decompressStringHuffman(aFile)) or VUHDO_deepCopyTable(aFile);
end



--
function VUHDO_compressTable(aTable)
	return type(aTable) == "table" and VUHDO_serializeTable(aTable) or aTable;
end



--
function VUHDO_compressAndPackTable(aTable)
	return type(aTable) == "table" and VUHDO_compressStringHuffman(VUHDO_serializeTable(aTable)) or aTable;
end





--
function VUHDO_compressAllBouquets()
	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		VUHDO_BOUQUETS["STORED"][tName] = VUHDO_compressTable(VUHDO_BOUQUETS["STORED"][tName]);
	end
end



--
function VUHDO_decompressAllBouquets()
	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		VUHDO_BOUQUETS["STORED"][tName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][tName]);
	end
end



--
local tPlayerX, tPlayerY;
local tUnitX, tUnitY;
local tFacing;
local tIsInInstance;
function VUHDO_getUnitDirection(aUnit)
	-- as of patch 7.1 GetPlayerFacing()/GetPlayerMapPosition() do not function inside instances
	tIsInInstance, _ = IsInInstance();

	if tIsInInstance or (WorldMapFrame ~= nil and WorldMapFrame:IsShown())
		or (GetMouseFoci()[1] ~= nil and GetMouseFoci()[1]:GetName() == nil) then
		return nil;
	end

	tPlayerX, tPlayerY = VUHDO_getUnitMapPosition("player");
	if (tPlayerX or 0) + (tPlayerY or 0) <= 0 then
		VUHDO_setMapToCurrentZone();
		tPlayerX, tPlayerY = VUHDO_getUnitMapPosition("player");
		if (tPlayerX or 0) + (tPlayerY or 0) <= 0 then return nil; end
	end

	tUnitX, tUnitY = VUHDO_getUnitMapPosition(aUnit);
	if (tUnitX or 0) + (tUnitY or 0) <= 0 then return nil; end

	tFacing = GetPlayerFacing() or 0;
	tFacing = tFacing < 0 and tFacing + VUHDO_2_PI or tFacing;

	return VUHDO_PI - VUHDO_atan2(tPlayerX - tUnitX, tUnitY - tPlayerY) - tFacing;
end
local VUHDO_getUnitDirection = VUHDO_getUnitDirection;



--
local tDirection;
local tConeFactor = 180 / VUHDO_PI;
function VUHDO_isInConeInFrontOf(aUnit, aDegrees)
	if aDegrees >= 360 or "player" == aUnit then return true; end
	tDirection = VUHDO_getUnitDirection(aUnit);

	if not tDirection then return false;
	elseif tDirection < 0 then tDirection = tDirection + VUHDO_2_PI; end

	return aDegrees * 0.5 >= 180 - abs(180 - tConeFactor * tDirection);
end



--
function VUHDO_forceBooleanValue(aRawValue)
	if aRawValue == nil or aRawValue == 0 or aRawValue == false then return false;
	else return true; end
end



function VUHDO_getCurrentKeyModifierString()
	return format("%s%s%s",
		IsAltKeyDown() and "alt" or "",
		IsControlKeyDown() and "ctrl" or "",
		IsShiftKeyDown() and "shift" or "");
end



-- Helper to serialize a table to a string for pretty printing
-- Taken from Lua Users Wiki: http://lua-users.org/wiki/TableUtils
function VUHDO_tableValueToString(v)
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and VUHDO_tableToString( v ) or
      tostring( v )
  end
end



function VUHDO_tableKeyToString(k)
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. VUHDO_tableValueToString( k ) .. "]"
  end
end



function VUHDO_tableToString(tbl)
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, VUHDO_tableValueToString( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        VUHDO_tableKeyToString( k ) .. "=" .. VUHDO_tableValueToString( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end



function VUHDO_isBossUnit(aUnit) 

	return VUHDO_BOSS_UNITS and VUHDO_BOSS_UNITS[aUnit];

end



function VUHDO_isSpecialUnit(aUnit)

	return aUnit == "focus" or aUnit == "target" or VUHDO_isBossUnit(aUnit);

end



function VUHDO_round(number, digits)

	if digits then
		local shift = 10 ^ digits;

		return floor(number * shift + 0.5) / shift;
	else
		return floor(number + 0.5);
	end

end



--
local function VUHDO_isSpellIdMatch(aMatchSpellId, _, _, _, _, _, _, _, _, _, _, _, aSpellId)

	return aMatchSpellId == aSpellId;

end



--
local tSpellId;
function VUHDO_unitAura(aUnit, aSpell, aFilter)

	if (aFilter == nil) then
		aFilter = "HELPFUL";
	end

	tSpellId = tonumber(aSpell);

	if tSpellId == nil then
		if UnpackAuraData and GetAuraDataBySpellName then
			return UnpackAuraData(GetAuraDataBySpellName(aUnit, aSpell, aFilter));
		else
			return FindAuraByName(aSpell, aUnit, aFilter);
		end
	else
		return FindAura(VUHDO_isSpellIdMatch, aUnit, aFilter, tSpellId);
	end

end



function VUHDO_unitBuff(aUnit, aSpell)

	return VUHDO_unitAura(aUnit, aSpell, "HELPFUL");

end



function VUHDO_unitDebuff(aUnit, aSpell)

	return VUHDO_unitAura(aUnit, aSpell, "HARMFUL");

end



--
local function VUHDO_packAuraDataHelper(aSpellName, anIcon, aCount, aDebuffType, aDuration, aExpirationTime, aSource, anIsStealable, aNameplateShowPersonal, aSpellId, aCanApplyAura, anIsBossDebuff, aNameplateShowAll, aTimeMod, ...)

	return aSpellName, anIcon, aCount, aDebuffType, aDuration, aExpirationTime, aSource, anIsStealable, aNameplateShowPersonal, aSpellId, aCanApplyAura, anIsBossDebuff, aNameplateShowAll, aTimeMod, { ... };

end



--
local function VUHDO_packAuraData(aSpellName, anIcon, aCount, aDebuffType, aDuration, aExpirationTime, aSource, anIsStealable, aNameplateShowPersonal, aSpellId, aCanApplyAura, anIsBossDebuff, aNameplateShowAll, aTimeMod, ...)

	local tAuraData = { };

	tAuraData.name,	tAuraData.icon,	tAuraData.applications,	tAuraData.dispelName, tAuraData.duration, tAuraData.expirationTime, tAuraData.sourceUnit,
		tAuraData.isStealable, tAuraData.nameplateShowPersonal, tAuraData.spellId, tAuraData.canApplyAura, tAuraData.isBossAura, 
		tAuraData.nameplateShowAll, tAuraData.timeMod, tAuraData.points = VUHDO_packAuraDataHelper(
			aSpellName, anIcon, aCount, aDebuffType, aDuration, aExpirationTime, aSource, anIsStealable, aNameplateShowPersonal, aSpellId, 
			aCanApplyAura, anIsBossDebuff, aNameplateShowAll, aTimeMod, ...);

	return tAuraData;

end



--
local function VUHDO_getAuraDataByIndex(aUnit, aIndex, aFilter)

	return VUHDO_packAuraData(UnitAura(aUnit, aIndex, aFilter));


end



--
function VUHDO_unpackAuraData(anAuraData)

	if not anAuraData then
		return nil;
	end

	return anAuraData.name,
		anAuraData.icon,
		anAuraData.applications,
		anAuraData.dispelName,
		anAuraData.duration,
		anAuraData.expirationTime,
		anAuraData.sourceUnit,
		anAuraData.isStealable,
		anAuraData.nameplateShowPersonal,
		anAuraData.spellId,
		anAuraData.canApplyAura,
		anAuraData.isBossAura,
		anAuraData.isFromPlayerOrPlayerPet,
		anAuraData.nameplateShowAll,
		anAuraData.timeMod,
		unpack(anAuraData.points);

end



--
local tMaxCnt;
local tSlot;
local tDone;
local tAuraInfo;
local function VUHDO_forEachAuraHelper(aUnit, aFilter, aPredicate, aUsePackedAura, aContinuationToken, ...)

	tMaxCnt = select('#', ...);

	for tCnt = 1, tMaxCnt do
		tSlot = select(tCnt, ...);

		tAuraInfo = GetAuraDataBySlot(aUnit, tSlot);

		if aUsePackedAura then
			tDone = aPredicate(tAuraInfo);
		else
			tDone = aPredicate(UnpackAuraData(tAuraInfo));
		end

		if tDone then
			return nil;
		end
	end

	return aContinuationToken;

end



--
local tContinuationToken;
local tDone;
function VUHDO_forEachAura(aUnit, aFilter, aMaxCnt, aPredicate, aUsePackedAura)

		if aMaxCnt and aMaxCnt <= 0 then
			return;
		end

		if GetAuraSlots then
			tContinuationToken = nil;

			repeat
				tContinuationToken = VUHDO_forEachAuraHelper(aUnit, aFilter, aPredicate, aUsePackedAura, 
					GetAuraSlots(aUnit, aFilter, aMaxCnt, tContinuationToken));
			until tContinuationToken == nil;
		else
			for tCnt = 1, (aMaxCnt or huge) do
				tAuraInfo = VUHDO_getAuraDataByIndex(aUnit, tCnt, aFilter);

				if not tAuraInfo.icon then
					return nil;
				end

				if aUsePackedAura then
					tDone = aPredicate(tAuraInfo);
				else
					tDone = aPredicate(UnpackAuraData(tAuraInfo));
				end

				if tDone then
					return nil;
				end
			end
		end

end



--
function VUHDO_playSoundFile(aSound)

	if (aSound and (aSound == "Interface\\Quiet.ogg" or aSound == "Interface\\Quiet.mp3")) then
		-- sweep and reset any sound settings referencing the old 'none' LSM default	
		for _, tDebuffInfo in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]) do
			if (tDebuffInfo["SOUND"] and 
				(tDebuffInfo["SOUND"] == "Interface\\Quiet.ogg" or 
					tDebuffInfo["SOUND"] == "Interface\\Quiet.mp3")) then
				tDebuffInfo["SOUND"] = nil;
			end
		end

		-- reset custom debuff default sound if set to old 'none' LSM default
		if (VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] and 
			(VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] == "Interface\\Quiet.ogg" or 
				VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] == "Interface\\Quiet.mp3")) then
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] = nil;
		end

		-- reset standard debuff sound if set to old 'none' LSM default
		if (VUHDO_CONFIG["SOUND_DEBUFF"] and 
		      (VUHDO_CONFIG["SOUND_DEBUFF"] == "Interface\\Quiet.ogg" or 
				VUHDO_CONFIG["SOUND_DEBUFF"] == "Interface\\Quiet.mp3")) then
			VUHDO_CONFIG["SOUND_DEBUFF"] = nil;
		end

		-- return success because we've played nothing as requested (eg. Quiet.ogg)
		return true;
	end

	local tSuccess, tError = pcall(PlaySoundFile, aSound);

	if not tSuccess then
		VUHDO_Msg(format(VUHDO_I18N_PLAY_SOUND_FILE_ERR, aSound, tError));
	end

	return tSuccess;

end



---------------------------------
-- CLASSIC COMPATIBILITY LAYER --
---------------------------------
function VUHDO_getSpecialization()
end



function VUHDO_getSpecializationInfo(aSpecNum, ...)
	local tSpecNum = aSpecNum or VUHDO_getSpecialization();

	return tSpecNum, tSpecNum == 1 and "Primary" or (tSpecNum == 2 and "Secondary" or "Unkown"), _, _, _, GetTalentGroupRole(tSpecNum) or "NONE";
end



function VUHDO_getInspectSpecialization(...)

	if not GetInspectSpecialization then
		return 0;
	else
		return GetInspectSpecialization(...);
	end

end



function VUHDO_getSpecializationRoleByID(...)

	if not GetSpecializationRoleByID then
		return "NONE";
	else
		return GetSpecializationRoleByID(...);
	end

end



function VUHDO_unitGetIncomingHeals(aUnit, aCasterUnit)

	if not aUnit then
		return 0;
	end

	if VUHDO_LibHealComm and VUHDO_CONFIG["SHOW_LIBHEALCOMM_INCOMING"] then
		local tTargetGUID = UnitGUID(aUnit);

		if aCasterUnit then
			local tCasterGUID = UnitGUID(aCasterUnit);


			return (VUHDO_LibHealComm:GetHealAmount(tTargetGUID, VUHDO_LibHealComm.ALL_HEALS, GetTime() + VUHDO_INCOMING_HEAL_WINDOW, tCasterGUID) or 0) * (VUHDO_LibHealComm:GetHealModifier(tTargetGUID) or 1);
		else
			return (VUHDO_LibHealComm:GetHealAmount(tTargetGUID, VUHDO_LibHealComm.ALL_HEALS, GetTime() + VUHDO_INCOMING_HEAL_WINDOW) or 0) * (VUHDO_LibHealComm:GetHealModifier(tTargetGUID) or 1);
		end
	elseif UnitGetIncomingHeals then
		return UnitGetIncomingHeals(aUnit, aCasterUnit);
	else
		return 0;
	end

end



function VUHDO_unitGetTotalAbsorbs(...)

	if not UnitGetTotalAbsorbs then
		return 0;
	else
		return UnitGetTotalAbsorbs(...);
	end

end



function VUHDO_unitGetTotalHealAbsorbs(...)

	if not UnitGetTotalHealAbsorbs then
		return 0;
	else
		return UnitGetTotalHealAbsorbs(...);
	end

end



function VUHDO_unitIsWarModePhased(...)

	if not UnitIsWarModePhased then
		return false;
	else
		return UnitIsWarModePhased(...);
	end

end



function VUHDO_unitHasVehicleUI(...)

	if not UnitHasVehicleUI then
		return false;
	else
		return UnitHasVehicleUI(...);
	end

end



function VUHDO_unitGroupRolesAssigned(...)

	if not UnitGroupRolesAssigned then
		return "NONE";
	else
		return UnitGroupRolesAssigned(...);
	end

end



function VUHDO_unitAlternatePowerInfo(...)

	if not UnitAlternatePowerInfo then 
		return false;
	else
		return UnitAlternatePowerInfo(...);
	end

end



function VUHDO_hasIncomingSummon(...)

	if not C_IncomingSummon or not C_IncomingSummon.HasIncomingSummon then
		return false;
	else
		return C_IncomingSummon.HasIncomingSummon(...);
	end
end



function VUHDO_hasLFGRestrictions()

	return IsInGroup(LE_PARTY_CATEGORY_INSTANCE);

end



function VUHDO_unitTargetsVehicleInRaidUI(...)

	-- for now UnitTargetsVehicleInRaidUI always returns false on WotLK Classic
	-- force to true so we fall back on UnitHasVehicleUI to determine isVehicle
	return true;

end

