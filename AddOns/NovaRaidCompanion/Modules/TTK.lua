--------------------------
---NovaRaidCompanion TTK--
-------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local hp, maxHP, onePercent = 0, 0, 0;

local function encounterStart(...)
	local encounterID, encounterName, difficultyID, groupSize = ...;
end

local function encounterEnd(...)
	local encounterID, encounterName, difficultyID, groupSize, success = ...;
end

local function calcTimeLeft()

end

local ticker;
local function ticker()
	if (ticker) then
		C_Timer.After(0.01, function()
			calcTimeLeft();
			ticker();
		end)
	end
end

local function startTicker()
	if (ticker) then
		return;
	end
	ticker = true;
	ticker();
end

local function stopTicker()
	ticker = nil;
end

local f = CreateFrame("Frame", "NRCTTK");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		stopTicker();
	elseif (event == "ENCOUNTER_START") then
		--encounterStart(...);
		startTicker();
	elseif (event == "ENCOUNTER_END") then
		--encounterEnd(...);
		stopTicker();
	end
end)