-------------------
---NovaWorldBuffs--
-------------------

--Changed to this after wrath classic ended, no longer using timer from the NPC and data sharing.

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
local battlefieldID, battlefieldName = 1089, L["Wintergrasp"];

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
		end
		lastMinute = minutesLeft;
	end
	--Using a cache to start TB timer on dot when it should spawn right on the hour doesn't work becaus the ingame start time isn't reliable and can be up to 3mins off the hour. :/
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
	
function NWB:getWintergraspTimeString(isShort, veryShort)
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

function NWB:addWintergraspMinimapString(tooltip, noTopSeperator, noBottomSeperator)
	local text, timeLeft, running, timestamp = NWB:getWintergraspTimeString();
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

--This isn't used in cata, no need to announce wintergrasp to guild chat.
--[[function NWB:checkWintergraspTimer()
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
end]]