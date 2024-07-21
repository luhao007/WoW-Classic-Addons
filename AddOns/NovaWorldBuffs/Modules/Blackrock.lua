-------------------
---NovaWorldBuffs--
-------------------

local addonName, addon = ...;
local NWB = addon.a;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
local calcStart, lastSendGuild, lastSendGuild30, lastSendPersonal, lastBossMsg = 0, 0, 0, 0, 0;
local isBossShown;
local bossCache = {};
local lastSeenBoss = 0;

--These times are adjusted if DST is active in the getTimeLeft() func.
local isUS;
local region = NWB:GetCurrentRegion();
if (region == 1 and string.match(NWB.realm, "(AU)")) then
	--OCE.
	calcStart = 1707264000; --Date and time (GMT): Wednesday, February 7, 2024 12:00:00 AM
elseif (region == 1) then
	--US.
	isUS = true;
	calcStart = 1707260400; --Date and time (GMT):Wednesday, February 7, 2024 11:00:00 PM; --OCE and US different.
elseif (region == 2) then
	--Korea.
	calcStart = 1707256800; --Date and time (GMT): Tuesday, February 6, 2024 10:00:00 PM --KR starts 1h before OCE/US.
elseif (region == 3) then
	--EU.
	calcStart = 1707217200; --Date and time (GMT): Tuesday, February 6, 2024 11:00:00 AM
elseif (region == 4) then
	--Taiwan.
	calcStart = 1707260400; --TW same as OCE/US.
elseif (region == 5) then
	--China.
	calcStart = 1707260400; --CN same as OCE/US.
end
--calcStart = calcStart - 3600; --Blackrock runs at midnight and 2h cycle instead of 3.
--Trying to fix some issues with the timer not being exact, why is GetServerTime() not accurate?
--calcStart = calcStart + 30;

local function getTimeLeft()
	local timeLeft, type;
	if (calcStart) then
		local start = calcStart;
		local isDST = NWB:isDST();
		if (isDST) then
			if (isUS) then
				start = start + 3600;
			else
				start = start - 3600;
			end
		end
		local utc = GetServerTime();
		local secondsSinceFirstReset = utc - start;
		local timestamp = start + ((math.floor(secondsSinceFirstReset / 7200) + 1) * 7200);
		local timeLeft = timestamp - utc;
		local realTimeLeft = timeLeft;
		if (timeLeft > 3600) then
			--If more than 1h left then it's running, return tim left on current event instead.
			type = "running";
			timeLeft = timeLeft - 3600;
			timestamp = timestamp - 3600;
			NWB.blackrockRunning = true;
		else
			--if (NWB.blackrockRunning and timeLeft > 7620) then
			if (NWB.blackrockRunning) then
				NWB:blackrockEnded();
			end
			NWB.blackrockRunning = false;
		end
		return timeLeft, type, timestamp, realTimeLeft;
	end
end

function NWB:getBlackrockTimeString(isShort, veryShort)
	local text;
	local timeLeft, type, timestamp, realTimeLeft = getTimeLeft();
	if (timeLeft) then
		local timeString = NWB:getTimeString(timeLeft, true, "short");
		if (veryShort) then
			if (type == "running") then
				--For the overlay we don't show it running, so add the time until next start.
				timeString = NWB:getTimeString(timeLeft + 9000, true, "short");
			end
			--if (type == "running") then
			--	text = "|cFF00C800" .. L["Blackrock"] .. ": |cFF9CD6DE" .. timeString .. "|r" .. "|r |cFF9CD6DE" .. L["remaining"] .. "|r";
			--else
				text = L["Blackrock"] .. ": |cFF9CD6DE" .. timeString .. "|r";
			--end
		elseif (isShort) then
			if (type == "running") then
				text = "|cFF00C800" .. string.format(L["blackrockEventRunning"], "|cFF9CD6DE" .. timeString .. "|r") .. "|r |cFF9CD6DE" .. L["remaining"] .. "|r";
			else
				text = string.format(L["startsIn"], "|cFF9CD6DE" .. timeString .. "|r");
			end
		else
			if (type == "running") then
				text = "|cFF00C800" .. string.format(L["blackrockEventRunning"], "|cFF9CD6DE" .. timeString .. "|r") .. "|r |cFF9CD6DE" .. L["remaining"] .. "|r";
			else
				text = string.format(L["blackrockEventStartsIn"], "|cFF9CD6DE" .. timeString .. "|r");
			end
		end
	end
	return text, timeLeft, timestamp, realTimeLeft, type;
end

function NWB:addBlackrockMinimapString(tooltip, noTopSeperator, noBottomSeperator)
	if (not NWB.isSOD) then
		return;
	end
	local text, timeLeft, timestamp = NWB:getBlackrockTimeString();
	if (not text) then
		return;
	end
	--Check if previous line is a seperator so we don't double up.
	if (_G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()] and _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()]:GetText() ~= " "
			and not noTopSeperator) then
		tooltip:AddLine(" ");
		if (not tooltip.NWBSeparator9) then
		    tooltip.NWBSeparator9 = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator9:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator9:SetHeight(1);
		    tooltip.NWBSeparator9:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator9:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator9:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator9:Show();
	end
	local dateString = "";
	if (IsShiftKeyDown()) then
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
		if (not tooltip.NWBSeparator10) then
		    tooltip.NWBSeparator10 = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator10:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator10:SetHeight(1);
		    tooltip.NWBSeparator10:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator10:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator10:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator10:Show();
	end
	return true;
end

--[[function NWB:checkBlackrockTimer()
	local _, _, _, realTimeLeft = getTimeLeft();
	if (realTimeLeft <= 900 and realTimeLeft >= 899 and GetTime() - lastSendGuild > 900) then
		lastSendGuild = GetTime();
		if (NWB.db.global.guild10) then
			local msg = string.format(L["blackrockStartSoon"], "15 " .. L["minutes"]) .. ".";
			if (IsInGuild()) then
				if (isUS) then
					NWB:sendGuildMsg(msg, "guild10", nil, nil, "[NWB]", 2.69);
				else
					NWB:sendGuildMsg(msg, "guild10", nil, nil, "[NWB]", 2.67);
				end
			else
				NWB:print(msg, nil, "[NWB]");
			end
		end
	end
	if (realTimeLeft <= 1800 and realTimeLeft >= 1799 and GetTime() - lastSendGuild30 > 900) then
		lastSendGuild30 = GetTime();
		local msg = string.format(L["blackrockStartSoon"], "30 " .. L["minutes"]) .. ".";
		--Just tie it to guild10 settings.
		if (NWB.db.global.guild10) then
			if (IsInGuild()) then
				if (isUS) then
					NWB:sendGuildMsg(msg, "guild10", nil, nil, "[NWB]", 2.69);
				else
					NWB:sendGuildMsg(msg, "guild10", nil, nil, "[NWB]", 2.68);
				end
			else
				NWB:print(msg, nil, "[NWB]");
			end
		end
		if (NWB.db.global.sodMiddleScreenWarning) then
			local colorTable = {r = self.db.global.middleColorR, g = self.db.global.middleColorG, b = self.db.global.middleColorB, id = 41, sticky = 0};
			RaidNotice_AddMessage(RaidWarningFrame, NWB:stripColors(msg), colorTable, 5);
		end
	end
end]]

local mapMarkerTypes;
if (NWB.isSOD) then
	mapMarkerTypes = {
		["Alliance"] = {x = 83, y = 84, mapID = 1427, icon = "Interface\\worldstateframe\\alliancetower.blp"},
		["Horde"] = {x = 88, y = 84, mapID = 1427, icon = "Interface\\worldstateframe\\hordetower.blp"},
	};
end

--Update timers for worldmap when the map is open.
function NWB:updateBlackrockMarkers(type)
	local text = NWB:getBlackrockTimeString(true);
	_G["AllianceNWBBlackrockMap"].timerFrame.fs:SetText("|cFFFFFF00" .. text);
end

local function createBlackrockMarkers()
	if (not mapMarkerTypes) then
		return;
	end
	for k, v in pairs(mapMarkerTypes) do
		NWB:createBlackrockMarker(k, v);
	end
	NWB:refreshBlackrockMarkers();
end

function NWB:createBlackrockMarker(type, data)
	if (not NWB.isSOD) then
		return;
	end
	if (not _G[type .. "NWBBlackrockMap"]) then
		--Worldmap marker.
		local obj = CreateFrame("Frame", type .. "NWBBlackrockMap", WorldMapFrame);
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(data.icon);
		bg:SetTexCoord(0.1, 0.6, 0.1, 0.6);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(20, 20);
		obj.fsTitle = obj:CreateFontString(type .. "NWBBlackrockBuffCmdFSTitle", "ARTWORK");
		obj.fsTitle:SetPoint("TOP", 27, 22);
		obj.fsTitle:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE");
		--obj.fsTitle:SetFontObject(NumberFont_Outline_Med);
		obj.fsBottom = obj:CreateFontString(type .. "NWBBlackrockBuffCmdFSBottom", "ARTWORK");
		obj.fsBottom:SetPoint("BOTTOM", 28, -45);
		obj.fsBottom:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE");
		obj.tooltip = CreateFrame("Frame", type .. "NWBBlackrockDailyMapTextTooltip", obj, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("BOTTOM", obj, "TOP", 0, 35);
		--obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -26);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9999);
		obj.tooltip.fs = obj.tooltip:CreateFontString("NWBBlackrockDailyMapTextTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 14);
		obj.tooltip.fs:SetJustifyH("LEFT")
		obj.tooltip.fs:SetText(L["Blackrock PvP Event"]);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		obj.tooltip:Hide();
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		--New version we don't need resource frames for both factions, just attach timer string to alliance and move it to sit in the middle of both.
		if (type == "Alliance") then
			_G["AllianceNWBBlackrockMap"].fsTitle:SetText("|cFFFFFF00" .. L["Blackrock"]);
			--Timer frame that sits above the icon when an active timer is found.
			obj.timerFrame = CreateFrame("Frame", type .. "BlackrockTimerFrame", obj, "TooltipBorderedFrameTemplate");
			obj.timerFrame:SetPoint("CENTER", obj, "CENTER",  26, -23);
			obj.timerFrame:SetFrameStrata("FULLSCREEN");
			obj.timerFrame:SetFrameLevel(9);
			obj.timerFrame.fs = obj.timerFrame:CreateFontString(type .. "NWBBlackrockTimerFrameFS", "ARTWORK");
			obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
			obj.timerFrame.fs:SetFont("Fonts\\FRIZQT__.ttf", 13);
			obj.timerFrame:SetWidth(54);
			obj.timerFrame:SetHeight(24);
			obj.lastUpdate = 0;
			obj.resetType = L["Blackrock Towers"];
			obj:SetScript("OnUpdate", function(self)
				--Update timer when map is open.
				if (GetServerTime() - obj.lastUpdate > 0) then
					obj.lastUpdate = GetServerTime();
					NWB:updateBlackrockMarkers(type);
					obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 18);
					obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 12);
				end
			end)
			obj.timerFrame:SetScript("OnEnter", function(self)
				obj.tooltip:Show();
			end)
			obj.timerFrame:SetScript("OnLeave", function(self)
				obj.tooltip:Hide();
			end)
			--Make it act like pin is the parent and not WorldMapFrame.
			obj:SetScript("OnHide", function(self)
				obj.timerFrame:Hide();
			end)
			obj:SetScript("OnShow", function(self)
				obj.timerFrame:Show();
			end)
		end
		NWB.extraMapMarkers[obj:GetName()] = true;
	end
end

local hookWorldMap = true;
function NWB:refreshBlackrockMarkers(updateOnly)
	if (not NWB.isSOD) then
		return;
	end
	--If we're looking at the capital city map.
	if (NWB.faction == "Horde" and WorldMapFrame and WorldMapFrame:GetMapID() == 1454) then
		--This is now attached to the ashenvale city markers.
		--[[mapMarkerTypes = {
			["Alliance"] = {x = 15, y = 92, mapID = 1454, icon = "Interface\\worldstateframe\\alliancetower.blp"},
			["Horde"] = {x = 20, y = 92, mapID = 1454, icon = "Interface\\worldstateframe\\hordetower.blp"},
		};
		_G["AllianceNWBBlackrockMap"].fsBottom:ClearAllPoints();
		_G["AllianceNWBBlackrockMap"].fsBottom:SetPoint("BOTTOM", 28, -45);]]
	elseif (NWB.faction == "Alliance" and WorldMapFrame and WorldMapFrame:GetMapID() == 1453) then
		--[[mapMarkerTypes = {
			["Alliance"] = {x = 14, y = 92, mapID = 1453, icon = "Interface\\worldstateframe\\alliancetower.blp"},
			["Horde"] = {x = 19, y = 92, mapID = 1453, icon = "Interface\\worldstateframe\\hordetower.blp"},
		};
		_G["AllianceNWBBlackrockMap"].fsBottom:ClearAllPoints();
		_G["AllianceNWBBlackrockMap"].fsBottom:SetPoint("BOTTOM", 28, -45);]]
	else
		if (WorldMapFrame:GetMapID() == 1427) then
			mapMarkerTypes = {
				["Alliance"] = {x = 83, y = 84, mapID = 1427, icon = "Interface\\worldstateframe\\alliancetower.blp"},
				["Horde"] = {x = 88, y = 84, mapID = 1427, icon = "Interface\\worldstateframe\\hordetower.blp"},
			};
		elseif (WorldMapFrame:GetMapID() == 1428) then
			mapMarkerTypes = {
				["Alliance"] = {x = 83, y = 90, mapID = 1428, icon = "Interface\\worldstateframe\\alliancetower.blp"},
				["Horde"] = {x = 88, y = 90, mapID = 1428, icon = "Interface\\worldstateframe\\hordetower.blp"},
			};
		elseif (WorldMapFrame:GetMapID() == 1415 and GetZoneText() == L["Blackrock Mountain"]) then
			mapMarkerTypes = {
				["Alliance"] = {x = 83, y = 90, mapID = 1415, icon = "Interface\\worldstateframe\\alliancetower.blp"},
				["Horde"] = {x = 88, y = 90, mapID = 1415, icon = "Interface\\worldstateframe\\hordetower.blp"},
			};
		end
		_G["AllianceNWBBlackrockMap"].fsBottom:ClearAllPoints();
		_G["AllianceNWBBlackrockMap"].fsBottom:SetPoint("TOPRIGHT", _G["AllianceNWBBlackrockMap"], "TOPRIGHT", 70, -50);
	end
	if (WorldMapFrame and hookWorldMap) then
		hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
			NWB:refreshBlackrockMarkers();
		end)
		WorldMapFrame:HookScript("OnShow", function()
			NWB:refreshBlackrockMarkers();
		end)
		hookWorldMap = nil;
	end
	for k, v in pairs(mapMarkerTypes) do
		NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBBlackrockMap", _G[k .. "NWBBlackrockMap"]);
		if (NWB.db.global.showWorldMapMarkers and _G[k .. "NWBBlackrockMap"]) then
			NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBBlackrockMap", _G[k .. "NWBBlackrockMap"], v.mapID,
					v.x / 100, v.y / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
		end
	end
	if (not updateOnly) then
		NWB:updateWorldbuffMarkersScale();
	end
end

function NWB:loadBlackrock()
	if (not NWB.isSOD) then
		return;
	end
	createBlackrockMarkers();
end

local lastHonor, honorCount, killCount = 0, 0, 0;
local function honorLooted(amount)
	--if (not NWB.blackrockRunning) then
	--	return;
	--end
	--if (NWB.sodPhase < 4) then
	--	return;
	--end
	--local x, y, zone = NWB.dragonLib:GetPlayerZonePosition();
	--if (zone == 1427 or zone == 1428 or GetZoneText() == L["Blackrock Mountain"]) then
		--local eruptionData = C_UnitAuras.GetPlayerAuraBySpellID(461197);
		local hotBloodedData = C_UnitAuras.GetPlayerAuraBySpellID(461196);
		if (hotBloodedData) then --Slightly less than an hour so no chance of overalap between events.
			if (GetTime() - lastHonor > 3540) then
				--If last honor was seen too long ago then reset to start, it's a new event.
				honorCount = 0;
				killCount = 0;
			end
			honorCount = honorCount + amount;
			killCount = killCount + 1;
			--C_Timer.After(0.1, function()
			--	NWB:print("|cFFFFFFFF" .. L["Total honor this event"] .. ":|r " .. honorCount, nil, "[NWB]");
			--end);
			NWB:throddleEventByFunc("blackrockHonorDisplay", 1, "printBlackrockHonorCount");
			lastHonor = GetTime();
		end
	--end
end

function NWB:printBlackrockHonorCount()
	if (NWB.db.global.printBlackrockHonor) then
		--NWB:print("|cFFFFFFFF" .. L["Total honor this event"] .. ":|r " .. honorCount, nil, "[NWB]");
		NWB:print("|cFFFFFFFF" .. L["Total honor this event"] .. ":|r " .. honorCount .. " |cFFFFFFFF(Kills:|r " .. killCount .. "|cFFFFFFFF)|r", nil, "[NWB]");
	end
end

local function chatMsgCombatHonorGain(...)
	local text = ...;
	local honorGained;
	if (string.match(text, "%d+%.%d+")) then
		honorGained = string.match(text, "%d+%.%d+");
	else
		honorGained = string.match(text, "%d+");
	end
	if (not honorGained) then
		NIT:debug("Honor error:", text);
		return;
	end
	honorLooted(honorGained);
end

function NWB:blackrockEnded()
	NWB:debug("Blackock event ended.");
	--Disabled for now, we'll see how accurate the timer is first.
	--Probably won't start right on the hour like other events so this may need a delay to be sure it ended.
	--Or just swap this to widgets to get real ending.
	--[[if (GetTime() - lastHonor > 3600) then
		--If last honor was seen too long ago then reset to start, it's a new event.
		honorCount = 0;
	end
	if (honorCount > 0) then
		NWB:print("|cFFFFFFFFBlackrock event ended - " .. L["Total honor this event"] .. ":|r " .. honorCount, nil, "[NWB]");
	end]]
end

local f = CreateFrame("Frame");
f:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
		chatMsgCombatHonorGain(...);
	end
end)