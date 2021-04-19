local VUHDO_RAID = { };
local VUHDO_RAID_GUIDS = { };
local VUHDO_INTERNAL_TOGGLES = { };

local strsplit = strsplit;
local pairs = pairs;
local select = select;

local VUHDO_updateHealth;
local sCurrentTarget = nil;
local sCurrentFocus = nil;



--
function VUHDO_combatLogInitLocalOverrides()
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_RAID_GUIDS = _G["VUHDO_RAID_GUIDS"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_updateHealth = _G["VUHDO_updateHealth"];
end



--
local tInfo;
local tNewHealth;
local tDeadInfo = { ["dead"] = true };
local function VUHDO_addUnitHealth(aUnit, aDelta, aSrcGUID)
	tInfo = VUHDO_RAID[aUnit] or tDeadInfo;

	if not tInfo["dead"] then
	        -- filter exception data from combat log in classic
		-- sometimes combat log shows 19000+ damage but it's not correct e.g Ragnaros's Melt Weapon
		if aSrcGUID and abs(aDelta) > 10000 then
			local tSrc, _, _, _, _, tNpcId = strsplit("-", aSrcGUID);

			-- 11502 - Ragnaros
			-- 11583 - Nefarian
			if tNpcId and (tNpcId == "11502" or tNpcId == "11583") then
				return;
			end

			-- 18168 - Force Reactive Disk
			if tSrc and tSrc == "Player" and abs(aDelta) == 18168 then
				return;
			end
		end

		-- avoid the calculation to be disturbed by the exception data
		if UnitHealth(aUnit) ~= 0 or tInfo["health"] ~= 0 then
			tNewHealth = tInfo["health"] + aDelta;
		else 
			tNewHealth = tInfo["loghealth"] + aDelta;
		end

		if tNewHealth < 0 then 
			tNewHealth = 0;
		elseif tNewHealth > tInfo["healthmax"] then 
			tNewHealth = tInfo["healthmax"]; 
		end
		
		tInfo["loghealth"] = tNewHealth;
		tInfo["updateTime"] = GetTime();
		
		if tInfo["health"] ~= tNewHealth then
			VUHDO_updateHealth(aUnit, 12); -- VUHDO_UPDATE_HEALTH_COMBAT_LOG
		end
	end
end



--
local tPre, tSuf, tSpec;
local function VUHDO_getTargetHealthImpact(aMsg, aMsg1, aMsg2, aMsg4)
	tPre, tSuf, tSpec = strsplit("_", aMsg);

	if "SPELL" == tPre then
		if ("HEAL" == tSuf or "HEAL" == tSpec) and "MISSED" ~= tSpec then 
			return aMsg4;
		elseif "DAMAGE" == tSuf or "DAMAGE" == tSpec then 
			return -aMsg4; 
		end
	elseif "DAMAGE" == tSuf then
		if "SWING" == tPre then	
			return -aMsg1;
		elseif "RANGE" == tPre then 
			return -aMsg4;
		elseif "ENVIRONMENTAL" == tPre then 
			return -aMsg2;
		end
	elseif "DAMAGE" == tPre and "MISSED" ~= tSpec and "RESISTED" ~= tSpec then 
		return -aMsg4; 
	end

	return 0;
end



--
function VUHDO_clParserSetCurrentTarget(aUnit)
	sCurrentTarget = VUHDO_INTERNAL_TOGGLES[27] and aUnit or "*"; -- VUHDO_UPDATE_PLAYER_TARGET
end



--
function VUHDO_clParserSetCurrentFocus()
	sCurrentFocus = nil;

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if UnitIsUnit("focus", tUnit) and tUnit ~= "focus" and tUnit ~= "target" then
			if tInfo["isPet"] and (VUHDO_RAID[tInfo["ownerUnit"]] or {})["isVehicle"] then
				sCurrentFocus = tInfo["ownerUnit"];
			else
				sCurrentFocus = tUnit;
			end
			break;
		end
	end

end



--
local tUnit;
local tImpact;
function VUHDO_parseCombatLogEvent(aMsg, aDstGUID, aMsg1, aMsg2, aMsg4, aSrcGUID)
	tUnit = VUHDO_RAID_GUIDS[aDstGUID];
	if not tUnit then return; end

	-- as of patch 7.1 we are seeing empty values on health related events
	tImpact = tonumber(VUHDO_getTargetHealthImpact(aMsg, aMsg1, aMsg2, aMsg4)) or 0;

	if tImpact ~= 0 then
		VUHDO_addUnitHealth(tUnit, tImpact, aSrcGUID);
		if tUnit == sCurrentTarget then	VUHDO_addUnitHealth("target", tImpact);	end
		if tUnit == sCurrentFocus then VUHDO_addUnitHealth("focus", tImpact); end
	end
end



--
function VUHDO_getCurrentPlayerFocus()
	return sCurrentFocus;
end
