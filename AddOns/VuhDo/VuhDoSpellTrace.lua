local next = next;
local pairs = pairs;
local tostring = tostring;
local tonumber = tonumber;
local tinsert = table.insert;
local twipe = table.wipe;
local GetSpellInfo = GetSpellInfo or VUHDO_getSpellInfo;
local _;

local VUHDO_ACTIVE_TRACE_SPELLS = { 
	-- [<unit GUID>] = {
	--	["latestHeal"] = <latest trace spell ID>,
	--	["latestIncoming"] = <latest trace spell ID>,
	--	["spells"] = {
	--		[<spell ID>] = {
	--			["icon"] = <spell icon>,
	--			["startTime"] = <epoch time event received>,
	--			["isIncoming"] = <true|false>,
	--			["castTime"] = <spell cast duration>,
	--			["srcGuid"] = <source unit GUID>,
	--		},
	--	},
	-- },
};

local VUHDO_ACTIVE_TRACE_GUIDS = {
	-- [<source unit GUID>] = {
	--	[<spell ID>] = {
	--		["dstGuid"] = <destination unit GUID>,
	--	},
	-- },
};

local VUHDO_SPELL_TRACE_TYPE_INCOMING = -1;
local VUHDO_SPELL_TRACE_TYPE_HEAL = -2;

local VUHDO_TRAIL_OF_LIGHT_SPELL_ID = 200128;
local VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT = { };

local sIsPlayerKnowsTrailOfLight = false;
local sCurrentPlayerTrailOfLight = nil;
local sTrailOfLightIcon = nil;



--
local VUHDO_updateBouquetsForEvent;
local VUHDO_PLAYER_GUID = -1;
local VUHDO_RAID_GUIDS = { };
local VUHDO_INTERNAL_TOGGLES = { };
local sShowSpellTrace = nil;
local sShowTrailOfLight = nil;
local sShowIncomingAll = nil;
local sShowIncomingBossOnly = nil;
local sSpellTraceStoredSettings = nil;
local sSpellTraceDefaultDuration = nil;
function VUHDO_spellTraceInitLocalOverrides()

	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];

	VUHDO_PLAYER_GUID = UnitGUID("player");
	VUHDO_RAID_GUIDS = _G["VUHDO_RAID_GUIDS"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];

	sShowSpellTrace = VUHDO_CONFIG["SHOW_SPELL_TRACE"];
	sSpellTraceStoredSettings = VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"];
	sSpellTraceDefaultDuration = VUHDO_CONFIG["SPELL_TRACE"]["duration"];
	sShowTrailOfLight = VUHDO_CONFIG["SPELL_TRACE"]["showTrailOfLight"];
	sShowIncomingAll = VUHDO_CONFIG["SPELL_TRACE"]["showIncomingAll"];
	sShowIncomingBossOnly = VUHDO_CONFIG["SPELL_TRACE"]["showIncomingBossOnly"];

	VUHDO_setKnowsTrailOfLight(VUHDO_isTalentKnown(VUHDO_SPELL_ID.TRAIL_OF_LIGHT));

end



--
function VUHDO_setKnowsTrailOfLight(aKnowsTrailOfLight)

	sIsPlayerKnowsTrailOfLight = aKnowsTrailOfLight;

	if aKnowsTrailOfLight then
		_, _, sTrailOfLightIcon = GetSpellInfo(VUHDO_TRAIL_OF_LIGHT_SPELL_ID);
	else
		twipe(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT);

		local tPreviousPlayerTrailOfLight = sCurrentPlayerTrailOfLight;
		sCurrentPlayerTrailOfLight = nil;

		if tPreviousPlayerTrailOfLight and VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight] then
			VUHDO_updateBouquetsForEvent(
				VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight],
				VUHDO_UPDATE_SPELL_TRACE
			);
		end

		VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
		VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
	end

end



--
local function VUHDO_updateSpellTraceBouquets(aUnit)

	if not aUnit then
		return;
	end

	VUHDO_updateBouquetsForEvent(aUnit, VUHDO_UPDATE_SPELL_TRACE);

	if UnitIsUnit("target", aUnit) then
		VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
	end

	if UnitIsUnit("focus", aUnit) then
		VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
	end

end



--
local function VUHDO_addSpellTrace(aSrcGuid, aDstGuid, aSpellId)

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	if not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] or not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"] then
		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] = {
			["spells"] = { },
		};
	end

	if not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] then
		local tName, _, tIcon, tCastTime = GetSpellInfo(tSpellId);

		if not tName then
			return;
		end

		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] = {
			["icon"] = tIcon,
			["castTime"] = tCastTime,
		};
	end

	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId]["srcGuid"] = aSrcGuid;
	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId]["startTime"] = GetTime();

	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latest"] = tSpellId;

	if not VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid] then
		VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid] = { };
	end

	VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid][tSpellId] = aDstGuid;

end



--
local function VUHDO_removeSpellTrace(aSrcGuid, aDstGuid, aSpellId)

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	if not aDstGuid or not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] or not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"] or 
		not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] then
		return;
	end
	
	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] = nil;

	if VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latest"] == tSpellId then
		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latest"] = nil;
	end

	if VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latestIncoming"] == tSpellId then
		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latestIncoming"] = nil;
	end

	if VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latestHeal"] == tSpellId then
		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latestHeal"] = nil;
	end

	if VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid] and VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid][tSpellId] then
		VUHDO_ACTIVE_TRACE_GUIDS[aSrcGuid][tSpellId] = nil;
	end

end



--
function VUHDO_parseCombatLogSpellTrace(aMessage, aSrcGuid, aDstGuid, aSpellName, aSpellId, anAmount)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or 
		(--aMessage ~= "SPELL_CAST_START" and aMessage ~= "SPELL_CAST_SUCCESS" and aMessage ~= "SPELL_CAST_FAILED" and 
		aMessage ~= "SPELL_HEAL" and aMessage ~= "SPELL_PERIODIC_HEAL") then
		return;
	end

	-- special tracking for Holy Priest "Trail of Light"
	if sShowTrailOfLight and sIsPlayerKnowsTrailOfLight and 
		aSrcGuid == VUHDO_PLAYER_GUID and 
		(aSpellName == VUHDO_SPELL_ID.FLASH_HEAL or aSpellName == VUHDO_SPELL_ID.HEAL) then
		if not VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] or 
			(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] and VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1][2] ~= aDstGuid) then
			tinsert(
				VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT, 
				{
					anAmount,
					aDstGuid
				}
			);

			if VUHDO_RAID_GUIDS[aDstGuid] then
				VUHDO_updateBouquetsForEvent(VUHDO_RAID_GUIDS[aDstGuid], VUHDO_UPDATE_SPELL_TRACE);
			end

			VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
			VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
		end

		local flashHeal1 = VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1];
		local flashHeal2 = VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[2];

		if flashHeal1 and flashHeal2 then
			local tPreviousPlayerTrailOfLight = sCurrentPlayerTrailOfLight;

			sCurrentPlayerTrailOfLight = flashHeal1[2];

			tremove(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT, 2);
			VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] = flashHeal2;

			if VUHDO_RAID_GUIDS[sCurrentPlayerTrailOfLight] then
				VUHDO_updateBouquetsForEvent(
					VUHDO_RAID_GUIDS[sCurrentPlayerTrailOfLight], 
					VUHDO_UPDATE_SPELL_TRACE
				);
			end

			if tPreviousPlayerTrailOfLight and 
				tPreviousPlayerTrailOfLight ~= sCurrentPlayerTrailOfLight and 
				VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight] then
				VUHDO_updateBouquetsForEvent(
					VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight],
					VUHDO_UPDATE_SPELL_TRACE
				);
			end

			VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
			VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
		end
	end

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	-- spells can be traced by name or spell ID
	if not tSpellId or not sSpellTraceStoredSettings[tSpellId] then
		tSpellId = aSpellName;

		if not sSpellTraceStoredSettings[tSpellId] then
			return;
		end
	end

	-- incoming casts cannot be tracked via CLEU because the payload does not include  
	if sSpellTraceStoredSettings[tSpellId]["isIncoming"] then
		return;
	end

	if not aDstGuid or not VUHDO_RAID_GUIDS[aDstGuid] or 
		(aSrcGuid ~= VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isOthers"]) or 
		(aSrcGuid == VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isMine"]) then
		return;
	end

	VUHDO_addSpellTrace(aSrcGuid, aDstGuid, tSpellId);

	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latestHeal"] = tSpellId;

	VUHDO_updateSpellTraceBouquets(VUHDO_RAID_GUIDS[aDstGuid]);

end



--
function VUHDO_addIncomingSpellTrace(aSrcUnit, aCastGuid, aSpellId)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace then
		return;
	end

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	-- incoming spells can only be traced by spell ID
	if not tSpellId or ((not sSpellTraceStoredSettings[tSpellId] or not sSpellTraceStoredSettings[tSpellId]["isIncoming"]) and 
		not sShowIncomingAll) then
		return;
	end

	if sShowIncomingAll and sShowIncomingBossOnly and not VUHDO_isBossUnit(aSrcUnit) then
		return;
	end

	local tSrcGuid = UnitGUID(aSrcUnit);

	if not tSrcGuid then
		return;
	end

	local tSpellName, _, _, tCastStart, tCastEnd, _, _, _, tCastInfoSpellId = UnitCastingInfo(aSrcUnit);

	if not tSpellName then
		tSpellName, _, _, tCastStart, tCastEnd, _, _, tCastInfoSpellId = UnitChannelInfo(aSrcUnit);
	end

	if tSpellName and tCastInfoSpellId then
		-- ensure table keys are always strings
		tSpellId = tostring(tCastInfoSpellId);
	else
		return;
	end

	local tDstUnit = aSrcUnit .. "target";
	local tUnit;

	if UnitExists(tDstUnit) then
		for tRaidUnit, _ in pairs(VUHDO_RAID) do
			if UnitIsUnit(tDstUnit, tRaidUnit) then
				tUnit = tRaidUnit;

				break;
			end
		end
	end

	if not tUnit then
		return;
	end

	local tDstGuid = UnitGUID(tUnit);

	if not tDstGuid or not VUHDO_RAID_GUIDS[tDstGuid] or 
		(not sShowIncomingAll and ((tSrcGuid ~= VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isOthers"]) or 
		(tSrcGuid == VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isMine"]))) then
		return;
	end

	VUHDO_addSpellTrace(tSrcGuid, tDstGuid, tSpellId);

	VUHDO_ACTIVE_TRACE_SPELLS[tDstGuid]["spells"][tSpellId]["isIncoming"] = true;
	VUHDO_ACTIVE_TRACE_SPELLS[tDstGuid]["spells"][tSpellId]["castTime"] = tCastEnd - tCastStart;
	
	VUHDO_ACTIVE_TRACE_SPELLS[tDstGuid]["latestIncoming"] = tSpellId;

	VUHDO_updateSpellTraceBouquets(VUHDO_RAID_GUIDS[tDstGuid]);

end



--
function VUHDO_removeIncomingSpellTrace(aSrcUnit, aCastGuid, aSpellId)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace then
		return;
	end

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	-- spells can only be traced by spell ID
	if not tSpellId or not sSpellTraceStoredSettings[tSpellId] or not sSpellTraceStoredSettings[tSpellId]["isIncoming"] then
		return;
	end

	local tSrcGuid = UnitGUID(aSrcUnit);
	local tDstGuid;

	if tSrcGuid and VUHDO_ACTIVE_TRACE_GUIDS[tSrcGuid] then
		tDstGuid = VUHDO_ACTIVE_TRACE_GUIDS[tSrcGuid][tSpellId];
	end

	if not tDstGuid or not VUHDO_RAID_GUIDS[tDstGuid] or 
		(tSrcGuid ~= VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isOthers"]) or 
		(tSrcGuid == VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isMine"]) then
		return;
	end

	VUHDO_removeSpellTrace(tSrcGuid, tDstGuid, tSpellId);
	
	VUHDO_updateSpellTraceBouquets(VUHDO_RAID_GUIDS[tDstGuid]);

end



--
function VUHDO_updateSpellTrace()

	for tUnitGuid, tActiveTrace in pairs(VUHDO_ACTIVE_TRACE_SPELLS) do
		local tActiveTraceSpells = tActiveTrace["spells"];
		local tCurrentTime = GetTime();

		for tSpellId, tActiveTraceSpell in pairs(tActiveTraceSpells) do
			if tActiveTraceSpell then
				local tDuration;

				if tActiveTraceSpell["isIncoming"] then
					-- castTime is in ms but GetTime() returns seconds
					tDuration = tActiveTraceSpell["castTime"] / 1000;
				else 
					tDuration = tonumber(sSpellTraceStoredSettings[tSpellId]["duration"] or sSpellTraceDefaultDuration) or sSpellTraceDefaultDuration;
				end

				local tRemaining = tDuration - (tCurrentTime - tActiveTraceSpell["startTime"]);

				if tRemaining <= 0 then
					VUHDO_removeSpellTrace(tActiveTraceSpell["srcGuid"], tUnitGuid, tSpellId);

					VUHDO_updateSpellTraceBouquets(VUHDO_RAID_GUIDS[tUnitGuid]);
				end
			end
		end

		if next(VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"]) == nil then
			VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid] = nil;
		end
	end

	for tSrcGuid, tActiveTraceSpells in pairs(VUHDO_ACTIVE_TRACE_GUIDS) do
		if next(tActiveTraceSpells) == nil then
			VUHDO_ACTIVE_TRACE_GUIDS[tSrcGuid] = nil;
		end
	end

end



--
function VUHDO_getSpellTraceForUnit(aUnit, aSpell)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or not aUnit then
		return;
	end

	local tUnitGuid = UnitGUID(aUnit);

	if not tUnitGuid or not VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid] then
		return;
	end
	
	if aSpell and aSpell ~= VUHDO_SPELL_TRACE_TYPE_INCOMING and aSpell ~= VUHDO_SPELL_TRACE_TYPE_HEAL then	
		if VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"] and VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"][aSpell] then
			return VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"][aSpell];
		end
	else
		local tLatestTraceSpellId;

		if aSpell then
			if aSpell == VUHDO_SPELL_TRACE_TYPE_INCOMING then
				tLatestTraceSpellId = VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["latestIncoming"];
			elseif aSpell == VUHDO_SPELL_TRACE_TYPE_HEAL then
				tLatestTraceSpellId = VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["latestHeal"];
			end
		else
			tLatestTraceSpellId = VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["latest"];
		end

		if tLatestTraceSpellId then
			return VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"][tLatestTraceSpellId];
		end
	end

	return;

end



--
function VUHDO_getSpellTraceIncomingForUnit(aUnit)

	return VUHDO_getSpellTraceForUnit(aUnit, VUHDO_SPELL_TRACE_TYPE_INCOMING);

end



--
function VUHDO_getSpellTraceHealForUnit(aUnit)

	return VUHDO_getSpellTraceForUnit(aUnit, VUHDO_SPELL_TRACE_TYPE_HEAL);

end



--
function VUHDO_getActiveSpellTraceSpells()

	return VUHDO_ACTIVE_TRACE_SPELLS;

end



--
function VUHDO_getActiveSpellTraceGuids()

	return VUHDO_ACTIVE_TRACE_GUIDS;

end



--
function VUHDO_getSpellTraceTrailOfLight()

	return VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT;

end



--
function VUHDO_getSpellTraceTrailOfLightForUnit(aUnit)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or 
		not sShowTrailOfLight or not sIsPlayerKnowsTrailOfLight or 
		not aUnit then
		return;
	end

	local tUnitGuid = UnitGUID(aUnit);

	if not tUnitGuid or tUnitGuid ~= sCurrentPlayerTrailOfLight then
		return;
	end

	return { ["icon"] = sTrailOfLightIcon, };

end



--
local tUnitGuid;
local tTrailOfLight;
function VUHDO_isSpellTraceTrailOfLightNextUnit(aUnit)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or
		not sShowTrailOfLight or not sIsPlayerKnowsTrailOfLight or
		not aUnit then
		return;
	end

	tTrailOfLight = VUHDO_getSpellTraceTrailOfLight();

	if not tTrailOfLight[1] then
		return false;
	end

	tUnitGuid = UnitGUID(aUnit);

	if not tUnitGuid or tUnitGuid ~= tTrailOfLight[1][2] then
		return false;
	else
		return true;
	end

end
