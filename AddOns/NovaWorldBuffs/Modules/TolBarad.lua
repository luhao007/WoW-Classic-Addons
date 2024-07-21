-------------------
---NovaWorldBuffs--
-------------------

local addonName, addon = ...;
local NWB = addon.a;
if (not NWB.isCata) then
	return;
end
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
--local GetOutdoorPvPWaitTime = C_PvP.GetOutdoorPvPWaitTime;
local GetWorldPvPWaitTime = C_PvP.GetWorldPvPWaitTime;
local lastSendGuild, lastSendPersonal, lastBossMsg = 0, 0, 0;
local lastMinute, lastMinuteChange = 0;
local isRunning, isOCE;
local battlefieldID, battlefieldName = 1116, L["Tol Barad"];

if (NWB.realm == "Arugal" or NWB.realm == "Remulos" or NWB.realm == "Yojamba") then
	isOCE = true;
end

--Fix the pvp queue frame for OCE users since Blizzard won't fix it after multiple reports since wrath launch...
if (isOCE) then
	--[[ origGetWorldPvPWaitTime = C_PvP.GetWorldPvPWaitTime;
	C_PvP.GetWorldPvPWaitTime = function(battlefieldID)
		local minutesLeft = origGetWorldPvPWaitTime(battlefieldID)
		return minutesLeft and minutesLeft % 180;
	end]]
	--Meo had a better suggestion to just alter the text instead of fixing the API func.
	hooksecurefunc("HonorFrame_InitSpecificButton", function(button, elementData)
	    local localizedName = elementData.localizedName;
	    local battleGroundID = elementData.battleGroundID;
	    local startTime = elementData.startTime;
	
	    if startTime and startTime > 0 then
	        startTime = startTime % 180;
	        button.title:SetText(GRAY_FONT_COLOR_CODE .. localizedName .." ("..MinutesToTime(startTime)..")");
	    end
	end)
end

--[[local calcCache;
function NWB:loadTbCache()
	calcCache = NWB.data.tbCalcCache;
end]]

local function getTimeLeft()
	local minutesLeft = GetWorldPvPWaitTime(battlefieldID);
	local running = not minutesLeft;
	--[[if (not firstRun) then
		if (isRunning and not running) then
			--Event ended.
			--This can fire at logon becaus we get a few blank responses from the server while logging on.
			--Needs a fix if we add something for event ended.
			NWB:debug(battlefieldName .. " ended.");
		elseif (running and not isRunning) then
			--Event started.
			NWB:debug(battlefieldName .. " started.");
		end
	end]]
	isRunning = running;
	if (not minutesLeft) then
		return 0, true, 0;
	end
	--if (minutesLeft > 1260) then
	--	NWB:debug("Large Tol Barad timer discrepancy detected:", minutesLeft);
	--end
	local origMinutesLeft = minutesLeft;
	if (minutesLeft > 180) then
		--If we get more than 3h left which happens most of the time on OCE realms (and can maybe happen sometimes on others?).
		--It should still line up with a spawn so just get the remainder after removing the excess 3h chunks.
		minutesLeft = minutesLeft % 180;
	end
	--API only gives minutes so keep track of when it last changed so we can track seconds.
	--Minute change over is not reliably 60 seconds between relogs so this can be not the same as other peoples timer.
	if (lastMinute ~= minutesLeft) then
		if (lastMinute ~= 0) then
			--Don't record a time for the first recording after logon, we only want to use this  after we actually see the minutes tick over.
			lastMinuteChange = GetServerTime();
			--Record next spawn time to calc from, minus a week to avoid certain issues.
			--NWB.data.tbCalcCache = (GetServerTime() + (minutesLeft * 60)) - 604800;
			--NWB:loadTbCache();
		end
		lastMinute = minutesLeft;
	end
	--Using a cache to start TB timer on dot when it should spawn right on the hour doesn't work becaus the timer isn't reliable. :/
	--And we can't just keep a seconds cache between logons becaus it's not reliably 60 seconds once we relog.
	--I think the minute intervals get offset by load time or something random.
	--Just going to launch this first version with it not including seconds until the first API minute tick over.
	--Good enough for now, I'll keep trying to find a way for it to be reliable right after logon before the tick...
	--[[if (calcCache) then
		--If we have a past spawn time calc from that instead, fixes some reliability issues with GetWorldPvPWaitTime between relogs.
		--Round cache to the cloest 30min interval, I think it just rounds to nearest hour in every region?
		local start = calcCache - (calcCache % 1800);
		local utc = GetServerTime();
		local secondsSinceFirstReset = utc - start;
		local timestamp = start + ((math.floor(secondsSinceFirstReset / 10800) + 1) * 10800);
		local timeLeft = timestamp - utc;
		--print("Cache:", origMinutesLeft, minutesLeft, timeLeft)
		return timeLeft, running, timestamp;
	else]]
		local precision = 0;
		if (lastMinuteChange) then
			precision = 60 - (GetServerTime() - lastMinuteChange);
		end
		local timeLeft = (minutesLeft * 60) + precision;
		local timestamp = GetServerTime() + timeLeft;
		--print("API:", origMinutesLeft, minutesLeft, timeLeft, precision)
		return timeLeft, running, timestamp;
	--end
end
	
function NWB:getTolBaradTimeString(isShort, veryShort)
	local text;
	local timeLeft, running, timestamp = getTimeLeft();
	if (timeLeft) then
		if (running) then
			text = "|cFF00FF00" .. string.format(L["eventIsRunning"], battlefieldName) .. ".|r";
		else
			local timeString = NWB:getTimeString(timeLeft, true, "short");
			if (veryShort) then
				text = battlefieldName .. ": |cFF9CD6DE" .. timeString .. "|r";
			elseif (isShort) then
				text = string.format(L["startsIn"], "|cFF9CD6DE" .. timeString .. "|r");
			else
				text = battlefieldName .. " " .. strlower(gsub(L["startsIn"], " %%s", "")) ..  ": |cFF9CD6DE" .. timeString .. "|r";
			end
		end
		return text, timeLeft, running, timestamp;
	end
end

function NWB:addTolBaradMinimapString(tooltip, noTopSeperator, noBottomSeperator)
	local text, timeLeft, running, timestamp = NWB:getTolBaradTimeString();
	if (not text) then
		return;
	end
	--Check if previous line is a seperator so we don't double up.
	if (_G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()] and _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()]:GetText() ~= " "
			and not noTopSeperator) then
		tooltip:AddLine(" ");
		if (not tooltip.NWBSeparator7) then
		    tooltip.NWBSeparator7 = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator7:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator7:SetHeight(1);
		    tooltip.NWBSeparator7:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator7:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator7:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator7:Show();
	end
	local dateString = "";
	if (IsShiftKeyDown() and not running) then
		if (NWB.db.global.timeStampFormat == 12) then
			dateString = " (" .. date("%A", timestamp) .. " " .. gsub(date("%I:%M", timestamp), "^0", "")
					.. string.lower(date("%p", timestamp)) .. ")";
		else
			dateString = " (" .. date("%A %H:%M", timestamp) .. ")";
		end
	end
	tooltip:AddLine(text .. dateString);
	if (not noBottomSeperator) then
		tooltip:AddLine(" ");
		if (not tooltip.NWBSeparator8) then
		    tooltip.NWBSeparator8 = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator8:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator8:SetHeight(1);
		    tooltip.NWBSeparator8:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator8:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator8:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator8:Show();
	end
	return true;
end

function NWB:checkTolBaradTimer(test)
	local timeLeft, running, timestamp  = getTimeLeft();
	if (timeLeft and timeLeft <= 600 and timeLeft >= 590 and GetTime() - lastSendGuild > 900) then
		lastSendGuild = GetTime();
		if (NWB.db.global.guildTerok10) then
			local msg = string.format(battlefieldName .. " " .. strlower(gsub(L["startsIn"], " %%s", "")) ..  " 10 " .. L["minutes"]) .. ".";
			if (IsInGuild()) then
				NWB:sendGuildMsg(msg, "guildTerok10", nil, nil, "[NWB]", 2.79);
			else
				NWB:print(msg, nil, "[NWB]");
			end
		end
	end
end




---I was going to use a static time to calc from for OCE realms since the API is broken there.
---But then I figured out that even though the time is wrong it's still a factor of 3 hours and can be used to calc from.
---Leaving the partially unfishing code here just incase it's not reliably a factor of 3 hours and needed later.

--[[local region = NWB:GetCurrentRegion();
if (NWB.realm == "Arugal" or NWB.realm == "Remulos" or NWB.realm == "Yojamba") then
	--OCE.
	calcStart = 1707267600; --Date and time (GMT): Wednesday, February 7, 2024 12:00:00 AM
	isOCE = true;
end

calcStart = calcStart + 3600; --TB runs 1 hour after WG..
--Trying to fix some issues with the timer not being exact, why is GetServerTime() not accurate?
calcStart = calcStart + 20;

local getTimeLeft;
if (isOCEe) then
	--Using our own timestamps like how stv/ashenvale works in sod.
	--OCE can't use the API thanks to it being broken for OCE since Wrath launch and ignored by Blizzard.
	--Starts at 20.5h left and counts down over the course a day, then resets back to 20.5h.
	function getTimeLeft()
		local timeLeft, type;
		--Even though this is broken on OCE it can still be used to tell if it's running as it still returns nil at the right time.
		local running = not GetWorldPvPWaitTime(battlefieldID);
		if (isRunning and not running) then
			--Event ended.
			NWB:debug(battlefieldName .. " ended.");
		elseif (running and not isRunning) then
			--Event started.
			NWB:debug(battlefieldName .. " started.");
		end
		isRunning = running;
		if (calcStart) then
			local start = calcStart;
			--I don't think this will change server times with DST like sod events do?
			--local isDST = NWB:isDST();
			--if (isDST) then
				--start = start - 3600;
			--end
			local utc = GetServerTime();
			local secondsSinceFirstReset = utc - start;
			local timestamp = start + ((math.floor(secondsSinceFirstReset / 10800) + 1) * 10800);
			local timeLeft = timestamp - utc;
			if (running) then
				type = "running";
			end
			return timeLeft, type, timestamp;
		end
	end
else
	--Using the API for other regions that hopefully aren't bugged, I know US at least works.
	local lastGoodCache, lastGoodCacheTime;
	function getTimeLeft()
		local type;
		local minutesLeft = GetWorldPvPWaitTime(battlefieldID);
		local running = not minutesLeft;
		if (isRunning and not running) then
			--Event ended.
			--This can fire at logon becaus we get a few blank responses from the server while logging on.
			--Needs a fix if we add something for event ended.
			NWB:debug(battlefieldName .. " ended.");
		elseif (running and not isRunning) then
			--Event started.
			NWB:debug(battlefieldName .. " started.");
		end
		isRunning = running;
		if (not minutesLeft) then
			return 0, true, 0;
		end
		if (minutesLeft > 180) then
			--If we get more than 3h left which happens most of the time on OCE realms (and can maybe happen sometimes on others?).
			--It should still line up with a spawn so just get the remainder after removing the excess 3h chunks.
			minutesLeft = minutesLeft % 180;
		end
		--API only gives minutes so keep track of when it last changed so we can track seconds.
		if (lastMinute ~= minutesLeft) then
			if (lastMinute ~= 0) then
				--Don't record a time for the first recording after logon, we only want to use this  after we actually see the minutes tick over.
				lastMinuteChange = GetServerTime();
				--Record last known minute tick over time to use a cache.
				NWB.data.tbPrecisionCache = GetServerTime();
			end
			lastMinute = minutesLeft;
		end
		local precision;
		if (not lastMinuteChange) then
			--No seconds precision right after logging on can caus issues with timers and guild msgs.
			--If guild announcer logs on less than 1 minute before spawn then their timestamp will already be below the announce time threshold without the seconds being added.
			--Possible solution one, add no precision after logging and extend the announce window to 1 minute instead of 1 second.
			--Should always be below that threshold when logging on as announcer, and someone else would announced it before you logged on?
			--What happens when it ticks over and we start adding seconds though..?
			--Second possible solution, don't add precision for the first 60 seconds after logon?
			--Third is just keep a cache last time a minute ticked over to calc seconds from for a short while after logon.
			--Third is probably not accurate if been offline a long time or if the cycle isn't exactly 2.5h not running and 30mins running but we'll go with it for now and see.
			if (NWB.data.tbPrecisionCache) then
				--print("using cache")
				precision = 60 - ((GetServerTime() - NWB.data.tbPrecisionCache) - 60 % 60);
			else
				precision = 0;
			end
		else
			precision = 60 - (GetServerTime() - lastMinuteChange);
		end
		local timeLeft = (minutesLeft * 60) + precision;
		local timestamp = GetServerTime() + timeLeft;
		--print(2, timeLeft, precision, running)
		return timeLeft, running, timestamp;
	end
	
	
	--Another iteration, now changing it to use a cache instead since GetWorldPvPWaitTime() isn't reliably 1 minute intervals between relogs.
	local function getTimeLeft()
	local type;
	local minutesLeft = GetWorldPvPWaitTime(battlefieldID);
	local running = not minutesLeft;
	if (isRunning and not running) then
		--Event ended.
		--This can fire at logon becaus we get a few blank responses from the server while logging on.
		--Needs a fix if we add something for event ended.
		NWB:debug(battlefieldName .. " ended.");
	elseif (running and not isRunning) then
		--Event started.
		NWB:debug(battlefieldName .. " started.");
	end
	isRunning = running;
	if (not minutesLeft) then
		return 0, true, 0;
	end
	if (minutesLeft > 1260) then
		NWB:debug("Large Tol Barad timer discrepancy detected:", minutesLeft);
	end
	local origMinutesLeft = minutesLeft;
	local usingCache;
	if (minutesLeft > 180) then
		--If we get more than 3h left which happens most of the time on OCE realms (and can maybe happen sometimes on others?).
		--It should still line up with a spawn so just get the remainder after removing the excess 3h chunks.
		minutesLeft = minutesLeft % 180;
	end
	if (not NWB.data.lastCacheRecord) then
		NWB.data.lastCacheRecord = GetTime();
	end
	--API only gives minutes so keep track of when it last changed so we can track seconds.
	--Minute change over is not reliably 60 seconds between relogs.
	if (lastMinute ~= minutesLeft) then
		if (lastMinute ~= 0) then
			--Don't record a time for the first recording after logon, we only want to use this  after we actually see the minutes tick over.
			lastMinuteChange = GetServerTime();
			--Record last known minute tick over time to use a cache.
			NWB.data.tbPrecisionCache = GetServerTime();
			--print("recording cache", GetTime() - NWB.data.lastCacheRecord);
			NWB.data.lastCacheRecord = GetTime();
		end
		lastMinute = minutesLeft;
	end
	local precision;
	if (not lastMinuteChange) then
		--No seconds precision right after logging on can caus issues with timers and guild msgs.
		--If guild announcer logs on less than 1 minute before spawn then their timestamp will already be below the announce time threshold without the seconds being added.
		--Possible solution one, add no precision after logging and extend the announce window to 1 minute instead of 1 second.
		--Should always be below that threshold when logging on as announcer, and someone else would announced it before you logged on?
		--What happens when it ticks over and we start adding seconds though..?
		--Second possible solution, don't add precision for the first 60 seconds after logon?
		--Third is just keep a cache last time a minute ticked over to calc seconds from for a short while after logon.
		--Third is probably not accurate if been offline a long time or if the cycle isn't exactly 2.5h not running and 30mins running but we'll go with it for now and see.
		if (NWB.data.tbPrecisionCache) then
			--print("using cache")
			precision = 60 - ((GetServerTime() - NWB.data.tbPrecisionCache) % 60);
			usingCache = true;
		else
			precision = 0;
		end
	else
		precision = 60 - (GetServerTime() - lastMinuteChange);
	end
	local timeLeft = (minutesLeft * 60) + precision;
	local timestamp = GetServerTime() + timeLeft;
	--print(origMinutesLeft, minutesLeft, timeLeft, precision, usingCache)
	return timeLeft, running, timestamp;
end
end



--Trying to find a rare issue with timer data not working times until the frame is opened.
--Just run everything the frame does when it opens and see if it still happens..
--After checking more I think maybe this was a clashing issue with the wintergrasp time cache not being seperate during testing, fixed that too but stll leaving this here for now.
RequestRatedInfo();
PVPFrame_Update();
RequestPVPRewards();
RequestPVPOptionsEnabled();]]