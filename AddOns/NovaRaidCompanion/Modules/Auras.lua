----------------------------
---NovaRaidCompanion Auras--
----------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
NRC.auraCache = {};
local units = NRC.units;
local UnitBuff = UnitBuff;
local UnitDebuff = UnitDebuff;
local UnitName = UnitName;
local UnitGUID = UnitGUID;
local GetServerTime = GetServerTime;
local GetTime = GetTime;


local function unitAura(...)
	local unit = ...;
	local guid = UnitGUID(unit);
	if (guid and units[unit]) then
		local auras = {};
		local serverTime = GetServerTime();
		for i = 1, 60 do
			local name, icon, _, _, _, expirationTime, source, _, _, spellID = UnitBuff(unit, i);
			if (name) then
				auras[spellID] = {
					name = name,
					--endTime = serverTime + (expirationTime - GetTime()),
					--source = source,
					icon = icon,
					buff = true,
				};
				if (source) then
					auras[spellID].source = UnitName(source);
				end
				local endTime = serverTime + (expirationTime - GetTime());
				if (endTime > serverTime) then
					--If people go out of range it gives an endtime in the past.
					--Only update if it's a valid endtime so we don't overwrite data we already have.
					auras[spellID].endTime = endTime;
				end
				--if (not NRC.auraCache[guid] or not NRC.auraCache[guid][spellID]) then
				--	NRC:buffGained(guid, auras[spellID]);
				--end
			else
				break;
			end
		end
		for i = 1, 60 do
			local name, icon, _, _, _, expirationTime, source, _, _, spellID = UnitDebuff(unit, i);
			if (name) then
				auras[spellID] = {
					name = name,
					--endTime = serverTime + (expirationTime - GetTime()),
					--source = source,
					icon = icon,
					debuff = true,
				};
				if (source) then
					auras[spellID].source = UnitName(source);
				end
				local endTime = serverTime + (expirationTime - GetTime());
				if (endTime > serverTime) then
					--If people go out of range it gives an endtime in the past.
					--Only update if it's a valid endtime so we don't overwrite data we already have.
					auras[spellID].endTime = 0;
				end
				--if (not NRC.auraCache[guid] or not NRC.auraCache[guid][spellID]) then
				--	NRC:debuffGained(guid, auras[spellID]);
				--end
			else
				break;
			end
		end
		--[[if (NRC.auraCache[guid]) then
			for k, v in pairs(NRC.auraCache[guid]) do
				if (not auras[k]) then
					if (v.buff) then
						NRC:buffFaded(guid, v);
					else
						NRC:debuffFaded(guid, v);
					end
				end
			end
		end]]
		NRC.auraCache[guid] = auras;
	end
end

--Scan whole group.
function NRC:aurasScanGroup()
	if (not IsInGroup()) then
		return;
	end
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	local serverTime = GetServerTime();
	for i = 1, GetNumGroupMembers() do
		local unit = unitType .. i;
		local guid = UnitGUID(unit);
		if (guid) then
			for i = 1, 40 do
				local name, icon, _, _, duration, expirationTime, source, _, _, spellID = UnitBuff(unit, i);
				if (name and spellID) then
					if (not NRC.auraCache[guid]) then
						NRC.auraCache[guid] = {};
					end
					NRC.auraCache[guid][spellID] = {
						name = name,
						--endTime = serverTime + (expirationTime - GetTime()),
						--source = source,
						icon = icon,
						buff = true,
					};
					if (source) then
						NRC.auraCache[guid][spellID].source = UnitName(source);
					end
					local endTime = serverTime + (expirationTime - GetTime());
					if (endTime > serverTime) then
						--If people go out of range it gives an endtime in the past.
						--Only update if it's a valid endtime so we don't overwrite data we already have.
						NRC.auraCache[guid][spellID].endTime = endTime;
					end
				end
				local name, icon, _, _, duration, expirationTime, source, _, _, spellID = UnitDebuff(unit, i);
				if (name and spellID) then
					if (not NRC.auraCache[guid]) then
						NRC.auraCache[guid] = {};
					end
					NRC.auraCache[guid][spellID] = {
						name = name,
						--endTime = serverTime + (expirationTime - GetTime()),
						--source = source,
						icon = icon,
						debuff = true,
					};
					if (source) then
						NRC.auraCache[guid][spellID].source = UnitName(source);
					end
					local endTime = serverTime + (expirationTime - GetTime());
					if (endTime > serverTime) then
						--If people go out of range it gives an endtime in the past.
						--Only update if it's a valid endtime so we don't overwrite data we already have.
						NRC.auraCache[guid][spellID].endTime = endTime;
					end
				end
			end
		end
	end
	--Scan ourself too.
	local unit = "player";
	local guid = UnitGUID(unit); 
	for i = 1, 40 do
		local name, icon, _, _, duration, expirationTime, source, _, _, spellID = UnitBuff(unit, i);
		if (name) then
			NRC.auraCache[guid][spellID] = {
				name = name,
				endTime = serverTime + (expirationTime - GetTime()),
				--source = source,
				icon = icon,
				buff = true,
			};
			if (source) then
				NRC.auraCache[guid][spellID].source = UnitName(source);
			end
		end
		local name, icon, _, _, duration, expirationTime, source, _, _, spellID = UnitDebuff(unit, i);
		if (name) then
			NRC.auraCache[guid][spellID] = {
				name = name,
				endTime = serverTime + (expirationTime - GetTime()),
				--source = source,
				icon = icon,
				debuff = true,
			};
			if (source) then
				NRC.auraCache[guid][spellID].source = UnitName(source);
			end
		end
	end
end

--[[function NRC:buffGained()

end

function NRC:debuffGained()

end

function NRC:buffFaded()

end

function NRC:debuffFaded()

end]]

--Keep a cache of all group members buffs.
local f = CreateFrame("Frame", "NRCAuras");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("UNIT_AURA");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "UNIT_AURA") then
		unitAura(...);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		--local isLogon, isReload = ...;
		if (GetNumGroupMembers() > 1) then
			C_Timer.After(1, function()
				NRC:aurasScanGroup();
			end)
		end
	elseif (event == "GROUP_FORMED" or event == "GROUP_JOINED") then
		if (GetNumGroupMembers() > 1) then
			C_Timer.After(1, function()
				NRC:aurasScanGroup();
			end)
			C_Timer.After(10, function()
				NRC:aurasScanGroup();
			end)
		end
	end
end)