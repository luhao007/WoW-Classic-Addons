---@diagnostic disable: duplicate-set-field
-- **************************************************************************
-- * TitanPerformance.lua
-- *
-- * By: The Titan Panel Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local TITAN_PERFORMANCE_ID = "Performance";
local TITAN_BUTTON = "TitanPanel"..TITAN_PERFORMANCE_ID.."Button"

local TITAN_PERF_FRAME_SHOW_TIME = 0.5;
local updateTable = {TITAN_PERFORMANCE_ID, TITAN_PANEL_UPDATE_ALL};

local APP_MIN = 1
local APP_MAX = 40

---@diagnostic disable-next-line: deprecated
local NumAddons = C_AddOns.GetNumAddOns or GetNumAddOns
---@diagnostic disable-next-line: deprecated
local AddOnInfo = C_AddOns.GetAddOnInfo or GetAddOnInfo
---@diagnostic disable-next-line: deprecated
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local TITAN_FPS_THRESHOLD_TABLE = {
	Values = { 20, 30 },
	Colors = { RED_FONT_COLOR, NORMAL_FONT_COLOR, GREEN_FONT_COLOR },
}

-- #1369 - PERFORMANCEBAR_LOW_LATENCY, PERFORMANCEBAR_MEDIUM_LATENCY no longer defined by WoW
local TITAN_LATENCY_THRESHOLD_TABLE = {
	Values = { 300, 600 }, 
	Colors = { GREEN_FONT_COLOR, NORMAL_FONT_COLOR, RED_FONT_COLOR },
}

local TITAN_MEMORY_RATE_THRESHOLD_TABLE = {
	Values = { 1, 2 },
	Colors = { GREEN_FONT_COLOR, NORMAL_FONT_COLOR, RED_FONT_COLOR },
}

-- ******************************** Variables *******************************
local _G = getfenv(0);
local topAddOns;
local memUsageSinceGC = {};
local counter = 1; --counter for active addons
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local PerfTimer = {}
local PerfTimerRunning = false
-- ******************************** Functions *******************************
local function CalcAppNum(val)
	local new_val = 1 -- always monitor at least one

	if val == nil or val < APP_MIN then
		-- keep the default min
	else
		-- return a value adjusted for the min
		new_val = (APP_MAX + APP_MIN) - TitanUtils_Round(val)
	end
	return new_val
end

--[[
-- **************************************************************************
-- NAME : Stats_UpdateAddonsList(self, watchingCPU)
-- DESC : Execute garbage collection for Leftclick on button
-- **************************************************************************
--]]
local function Stats_UpdateAddonsList(self, watchingCPU)
	if(watchingCPU) then
		UpdateAddOnCPUUsage()
	else
		UpdateAddOnMemoryUsage()
	end

	local total = 0
	local showAddonRate = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowAddonIncRate");
	for i=1, NumAddons() do
		local value = (watchingCPU and GetAddOnCPUUsage(i)) or GetAddOnMemoryUsage(i)
		total = total + value

		for j,addon in ipairs(topAddOns) do
			if(value > addon.value) then
				for k = counter, 1, -1 do
					if(k == j) then
						topAddOns[k].value = value
						topAddOns[k].name = AddOnInfo(i)
						break
					elseif(k ~= 1) then
						topAddOns[k].value = topAddOns[k-1].value
						topAddOns[k].name = topAddOns[k-1].name
					end
				end
				break
			end
		end
	end

	GameTooltip:AddLine(' ')

	if (total > 0) then
		if(watchingCPU) then
			GameTooltip:AddLine('|cffffffff'..L["TITAN_PERFORMANCE_ADDON_CPU_USAGE_LABEL"])
		else
			GameTooltip:AddLine('|cffffffff'..L["TITAN_PERFORMANCE_ADDON_MEM_USAGE_LABEL"])
		end

		if not watchingCPU then
			if (showAddonRate == 1) then
				GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"],LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"].."/"..L["TITAN_PERFORMANCE_ADDON_RATE_LABEL"]..":")
			else
				GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"],LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"]..":")
			end
		end

		if watchingCPU then
			GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"],LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"]..":")
		end

		for _,addon in ipairs(topAddOns) do
			if(watchingCPU) then
				local diff = addon.value/total * 100;
				local incrate = "";
				incrate = format("(%.2f%%)", diff);
				if (showAddonRate == 1) then
					GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format("%.3f",addon.value)..L["TITAN_PANEL_MILLISECOND"].." "..GREEN_FONT_COLOR_CODE..incrate);
				else
					GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format("%.3f",addon.value)..L["TITAN_PANEL_MILLISECOND"]);
				end
			else
				local diff = addon.value - (memUsageSinceGC[addon.name])
				if diff < 0 or memUsageSinceGC[addon.name]== 0 then
					memUsageSinceGC[addon.name] = addon.value;
				end
				local incrate = "";
				if diff > 0 then
					incrate = format("(+%.2f) "..L["TITAN_PANEL_PERFORMANCE_KILOBYTES_PER_SECOND"], diff);
				end
				if (showAddonRate == 1) then
					if TitanGetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType") == 1 then
					GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], addon.value/1000).." "..GREEN_FONT_COLOR_CODE..incrate)
					else
						if addon.value > 1000 then
							GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], addon.value/1000).." "..GREEN_FONT_COLOR_CODE..incrate)
						else
							GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT_KB"], addon.value).." "..GREEN_FONT_COLOR_CODE..incrate)
						end
					end
				else
					if TitanGetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType") == 1 then
					GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], addon.value/1000))
					else
						if addon.value > 1000 then
							GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], addon.value/1000))
						else
							GameTooltip:AddDoubleLine(NORMAL_FONT_COLOR_CODE..addon.name," |cffffffff"..format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT_KB"], addon.value))
						end
					end
				end
			end
		end

		GameTooltip:AddLine(' ')

		if(watchingCPU) then
			GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_TOTAL_CPU_USAGE_LABEL"], format("%.3f",total)..L["TITAN_PANEL_MILLISECOND"])
		else
			if TitanGetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType") == 1 then
			GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"],format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], total/1000))
			else
				if total > 1000 then
					GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"], format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], total/1000))
				else
					GameTooltip:AddDoubleLine(LIGHTYELLOW_FONT_COLOR_CODE..L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"], format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT_KB"], total))
				end
			end
		end
	end
end

--[[
-- **************************************************************************
-- NAME : SetTooltip()
-- DESC : Display tooltip text
-- **************************************************************************
--]]
local function SetTooltip()
	local button = _G["TitanPanelPerformanceButton"];
	local showFPS = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowFPS");
	local showLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowLatency");
	local showWorldLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowWorldLatency")
	local showMemory = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowMemory");
	local showAddonMemory = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowAddonMemory");

	-- Tooltip title
	GameTooltip:SetText(L["TITAN_PERFORMANCE_TOOLTIP"], HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);

	-- FPS tooltip
	if ( showFPS ) then
		local fpsText = format(L["TITAN_PANEL_PERFORMANCE_FPS_FORMAT"], button.fps);
		local avgFPSText = format(L["TITAN_PANEL_PERFORMANCE_FPS_FORMAT"], button.avgFPS);
		local minFPSText = format(L["TITAN_PANEL_PERFORMANCE_FPS_FORMAT"], button.minFPS);
		local maxFPSText = format(L["TITAN_PANEL_PERFORMANCE_FPS_FORMAT"], button.maxFPS);

		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(TitanUtils_GetHighlightText(L["TITAN_PANEL_PERFORMANCE_FPS_TOOLTIP"]));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_FPS_TOOLTIP_CURRENT_FPS"], TitanUtils_GetHighlightText(fpsText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_FPS_TOOLTIP_AVG_FPS"], TitanUtils_GetHighlightText(avgFPSText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_FPS_TOOLTIP_MIN_FPS"], TitanUtils_GetHighlightText(minFPSText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_FPS_TOOLTIP_MAX_FPS"], TitanUtils_GetHighlightText(maxFPSText));
	end

	-- Latency tooltip
	if ( showLatency or showWorldLatency ) then
		local latencyText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_FORMAT"], button.latencyHome);
		local latencyWorldText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_FORMAT"], button.latencyWorld);
		local bandwidthInText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_BANDWIDTH_FORMAT"], button.bandwidthIn);
		local bandwidthOutText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_BANDWIDTH_FORMAT"], button.bandwidthOut);

		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(TitanUtils_GetHighlightText(L["TITAN_PANEL_PERFORMANCE_LATENCY_TOOLTIP"]));
		if showLatency then GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_LATENCY_TOOLTIP_LATENCY_HOME"], TitanUtils_GetHighlightText(latencyText)); end
		if showWorldLatency then GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_LATENCY_TOOLTIP_LATENCY_WORLD"], TitanUtils_GetHighlightText(latencyWorldText)); end
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_LATENCY_TOOLTIP_BANDWIDTH_IN"], TitanUtils_GetHighlightText(bandwidthInText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_LATENCY_TOOLTIP_BANDWIDTH_OUT"], TitanUtils_GetHighlightText(bandwidthOutText));
	end

	-- Memory tooltip
	if ( showMemory ) then
		local memoryText = format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], button.memory/1024);
		local initialMemoryText = format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], button.initialMemory/1024);
		local sessionTime = time() - button.startSessionTime;
		local rateRichText, timeToGCRichText, rate, timeToGC, color;
		if ( sessionTime == 0 ) then
			rateRichText = TitanUtils_GetHighlightText("N/A");
		else
			rate = (button.memory - button.initialMemory) / sessionTime;
			color = TitanUtils_GetThresholdColor(TITAN_MEMORY_RATE_THRESHOLD_TABLE, rate);
			rateRichText = TitanUtils_GetColoredText(format(L["TITAN_PANEL_PERFORMANCE_MEMORY_RATE_FORMAT"], rate), color)
		end
		if ( button.memory == button.initialMemory ) then
			timeToGCRichText = TitanUtils_GetHighlightText("N/A");
		end

		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(TitanUtils_GetHighlightText(L["TITAN_PANEL_PERFORMANCE_MEMORY_TOOLTIP"]));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_MEMORY_TOOLTIP_CURRENT_MEMORY"], TitanUtils_GetHighlightText(memoryText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_MEMORY_TOOLTIP_INITIAL_MEMORY"], TitanUtils_GetHighlightText(initialMemoryText));
		GameTooltip:AddDoubleLine(L["TITAN_PANEL_PERFORMANCE_MEMORY_TOOLTIP_INCREASING_RATE"], rateRichText);
	end

	if ( showAddonMemory == 1 ) then
		for _,i in pairs(topAddOns) do
			i.name = '';
			i.value = 0;
		end
		Stats_UpdateAddonsList(_G[TITAN_BUTTON], GetCVar('scriptProfile') == '1' and not IsModifierKeyDown())
	end

	GameTooltip:AddLine(TitanUtils_GetGreenText(L["TITAN_PERFORMANCE_TOOLTIP_HINT"]));
end

--[[
-- **************************************************************************
-- NAME : UpdateData()
-- DESC : Update button data
-- **************************************************************************
--]]
local function UpdateData()
	local button = _G["TitanPanelPerformanceButton"];
	local showFPS = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowFPS");
	local showLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowLatency");
	local showWorldLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowWorldLatency")
	local showMemory = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowMemory");
	local showAddonMemory = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowAddonMemory");

	-- FPS Data
	if ( showFPS ) then
		button.fps = GetFramerate();
		button.fpsSampleCount = button.fpsSampleCount + 1;
		if (button.fpsSampleCount == 1) then
			button.minFPS = button.fps;
			button.maxFPS = button.fps;
			button.avgFPS = button.fps;
		else
			if (button.fps < button.minFPS) then
				button.minFPS = button.fps;
			elseif (button.fps > button.maxFPS) then
				button.maxFPS = button.fps;
			end
			button.avgFPS = (button.avgFPS * (button.fpsSampleCount - 1) + button.fps) / button.fpsSampleCount;
		end
	end

	-- Latency Data
	if ( showLatency or showWorldLatency ) then
		-- bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats();
		button.bandwidthIn, button.bandwidthOut, button.latencyHome, button.latencyWorld = GetNetStats();
	end

	-- Memory data
	if ( showMemory ) or (showAddonMemory == 1) then
		local previousMemory = button.memory;
		button.memory, button.gcThreshold = gcinfo();
		if ( not button.startSessionTime ) then
			-- Initial data
			local i;
			button.startSessionTime = time();
			button.initialMemory = button.memory;

			for i = 1, NumAddons() do
				memUsageSinceGC[AddOnInfo(i)] = GetAddOnMemoryUsage(i)
			end
		elseif (previousMemory and button.memory and previousMemory > button.memory) then
			-- Reset data after garbage collection
			local k,i;
			button.startSessionTime = time();
			button.initialMemory = button.memory;

			for k in pairs(memUsageSinceGC) do
				memUsageSinceGC[k] = nil
			end

			for i = 1, NumAddons() do
				memUsageSinceGC[AddOnInfo(i)] = GetAddOnMemoryUsage(i)
			end
		end
	end
end

--[[
-- **************************************************************************
-- NAME : GetButtonText(id)
-- DESC : Calculate performance based logic for button text
-- VARS : id = button ID
-- **************************************************************************
--]]
local function GetButtonText(id)
	local button = _G["TitanPanelPerformanceButton"];
	local color, fpsRichText, latencyRichText, memoryRichText;
	local showFPS = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowFPS");
	local showLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowLatency");
	local showWorldLatency = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowWorldLatency")
	local showMemory = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowMemory");

	-- Update real time data
	UpdateData()

	-- FPS text
	if ( showFPS ) then
		local fpsText = format(L["TITAN_PANEL_PERFORMANCE_FPS_FORMAT"], button.fps);
		if ( TitanGetVar(TITAN_PERFORMANCE_ID, "ShowColoredText") ) then
			color = TitanUtils_GetThresholdColor(TITAN_FPS_THRESHOLD_TABLE, button.fps);
			fpsRichText = TitanUtils_GetColoredText(fpsText, color);
		else
			fpsRichText = TitanUtils_GetHighlightText(fpsText);
		end
	end

	-- Latency text
	latencyRichText = ""
	if ( showLatency ) then
		local latencyText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_FORMAT"], button.latencyHome);
		if ( TitanGetVar(TITAN_PERFORMANCE_ID, "ShowColoredText") ) then
			color = TitanUtils_GetThresholdColor(TITAN_LATENCY_THRESHOLD_TABLE, button.latencyHome);
			latencyRichText = TitanUtils_GetColoredText(latencyText, color);
		else
			latencyRichText = TitanUtils_GetHighlightText(latencyText)
		end
	end

	if ( showWorldLatency  ) then
		local latencyWorldText = format(L["TITAN_PANEL_PERFORMANCE_LATENCY_FORMAT"], button.latencyWorld);
		if ( showLatency ) then
			latencyRichText = latencyRichText.."/"
		end
		if ( TitanGetVar(TITAN_PERFORMANCE_ID, "ShowColoredText") ) then
			color = TitanUtils_GetThresholdColor(TITAN_LATENCY_THRESHOLD_TABLE, button.latencyWorld);
			latencyRichText = latencyRichText..TitanUtils_GetColoredText(latencyWorldText, color);
		else
			latencyRichText = latencyRichText..TitanUtils_GetHighlightText(latencyWorldText);
		end
	end

	-- Memory text
	if ( showMemory ) then
		local memoryText = format(L["TITAN_PANEL_PERFORMANCE_MEMORY_FORMAT"], button.memory/1024);
		memoryRichText = TitanUtils_GetHighlightText(memoryText);
	end

	if ( showFPS ) then
		if ( showLatency or showWorldLatency ) then
			if ( showMemory ) then
				return L["TITAN_PANEL_PERFORMANCE_FPS_BUTTON_LABEL"], fpsRichText, L["TITAN_PANEL_PERFORMANCE_LATENCY_BUTTON_LABEL"], latencyRichText, L["TITAN_PANEL_PERFORMANCE_MEMORY_BUTTON_LABEL"], memoryRichText;
			else
				return L["TITAN_PANEL_PERFORMANCE_FPS_BUTTON_LABEL"], fpsRichText, L["TITAN_PANEL_PERFORMANCE_LATENCY_BUTTON_LABEL"], latencyRichText;
			end
		else
			if ( showMemory ) then
				return L["TITAN_PANEL_PERFORMANCE_FPS_BUTTON_LABEL"], fpsRichText, L["TITAN_PANEL_PERFORMANCE_MEMORY_BUTTON_LABEL"], memoryRichText;
			else
				return L["TITAN_PANEL_PERFORMANCE_FPS_BUTTON_LABEL"], fpsRichText;
			end
		end
	else
		if ( showLatency or showWorldLatency ) then
			if ( showMemory ) then
				return L["TITAN_PANEL_PERFORMANCE_LATENCY_BUTTON_LABEL"], latencyRichText, L["TITAN_PANEL_PERFORMANCE_MEMORY_BUTTON_LABEL"], memoryRichText;
			else
				return L["TITAN_PANEL_PERFORMANCE_LATENCY_BUTTON_LABEL"], latencyRichText;
			end
		else
			if ( showMemory ) then
				return L["TITAN_PANEL_PERFORMANCE_MEMORY_BUTTON_LABEL"], memoryRichText;
			else
				return;
			end
		end
	end
end

--[[
-- **************************************************************************
-- NAME : CreateMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
--]]
local function CreateMenu()
	local info

--[[
print("TPref"
.." "..tostring(TitanPanelRightClickMenu_GetDropdownLevel())..""
.." "..tostring(TitanPanelRightClickMenu_GetDropdMenuValue())..""
)
--]]
	-- level 3
	if TitanPanelRightClickMenu_GetDropdownLevel() == 3 and TitanPanelRightClickMenu_GetDropdMenuValue() == "AddonControlFrame" then
		TitanPanelPerfControlFrame:Show()
		return
	end

	-- level 2
	if TitanPanelRightClickMenu_GetDropdownLevel() == 2 then
		if TitanPanelRightClickMenu_GetDropdMenuValue() == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowFPS"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_FPS"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowFPS");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowLatency"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowLatency");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowWorldLatency"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY_WORLD"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowWorldLatency");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowMemory"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_MEMORY"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowMemory");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
		end

		if TitanPanelRightClickMenu_GetDropdMenuValue() == "AddonUsage" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PERFORMANCE_ADDONS"], TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowAddonMemory"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_ADDONS"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowAddonMemory");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			local temptable = {TITAN_PERFORMANCE_ID, "ShowAddonIncRate"};
			info = {};
			info.text = L["TITAN_PERFORMANCE_MENU_SHOW_ADDON_RATE"];
			info.value = temptable;
			info.func = function()
				TitanPanelRightClickMenu_ToggleVar(temptable)
			end
			info.checked = TitanGetVar(TITAN_PERFORMANCE_ID, "ShowAddonIncRate");
			info.keepShownOnClick = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			info = {};
			info.notCheckable = true
			info.text = L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"]
				..LIGHTYELLOW_FONT_COLOR_CODE..tostring(TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons"));
			info.value = "AddonControlFrame"
			info.hasArrow = 1;
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
		end

		if TitanPanelRightClickMenu_GetDropdMenuValue() == "AddonMemoryFormat" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PERFORMANCE_ADDON_MEM_FORMAT_LABEL"], TitanPanelRightClickMenu_GetDropdownLevel());
			info = {};
			info.text = L["TITAN_PANEL_MEGABYTE"];
			info.checked = function() if TitanGetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType") == 1 then return true else return nil end
			end
			info.func = function() TitanSetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType", 1) end
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			info = {};
			info.text = L["TITAN_PANEL_PERFORMANCE_MEMORY_KBMB_LABEL"];
			info.checked = function() if TitanGetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType") == 2 then return true else return nil end
			end
			info.func = function() TitanSetVar(TITAN_PERFORMANCE_ID, "AddonMemoryType", 2) end
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
		end

		if TitanPanelRightClickMenu_GetDropdMenuValue() == "CPUProfiling" then
			if ( GetCVar("scriptProfile") == "1" ) then
				TitanPanelRightClickMenu_AddTitle(L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"]..": "..GREEN_FONT_COLOR_CODE..L["TITAN_PANEL_MENU_ENABLED"], TitanPanelRightClickMenu_GetDropdownLevel());
				info = {};
				info.text = L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_OFF"]..GREEN_FONT_COLOR_CODE..L["TITAN_PANEL_MENU_RELOADUI"];
				info.func = function() SetCVar("scriptProfile", "0") ReloadUI() end
				TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			else
				TitanPanelRightClickMenu_AddTitle(L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"]..": "..RED_FONT_COLOR_CODE..L["TITAN_PANEL_MENU_DISABLED"], TitanPanelRightClickMenu_GetDropdownLevel());
				info = {};
				info.text = L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_ON"]..GREEN_FONT_COLOR_CODE..L["TITAN_PANEL_MENU_RELOADUI"];
				info.func = function() SetCVar("scriptProfile", "1") ReloadUI() end
				TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			end
		end
		return
	end

	-- level 1
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_PERFORMANCE_ID].menuText);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_OPTIONS"];
	info.value = "Options"
	info.hasArrow = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PERFORMANCE_ADDONS"];
	info.value = "AddonUsage"
	info.hasArrow = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PERFORMANCE_ADDON_MEM_FORMAT_LABEL"];
	info.value = "AddonMemoryFormat"
	info.hasArrow = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"];
	info.value = "CPUProfiling"
	info.hasArrow = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	TitanPanelRightClickMenu_AddControlVars(TITAN_PERFORMANCE_ID)
end

--[[
-- **************************************************************************
-- NAME : OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
--]]
local function OnLoad(self)
	local notes = ""
		.."Adds FPS (Frames Per Second) and Garbage collection information to Titan Panel.\n"
--		.."- xxx.\n"
	self.registry = {
		id = TITAN_PERFORMANCE_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_PERFORMANCE_MENU_TEXT"],
		menuTextFunction = CreateMenu,
		buttonTextFunction = GetButtonText;
		tooltipCustomFunction = SetTooltip;
		icon = "Interface\\AddOns\\TitanPerformance\\TitanPerformance",
		iconWidth = 16,
		notes = notes,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			ShowFPS = 1,
			ShowLatency = 1,
			ShowWorldLatency = 1,
			ShowMemory = 1,
			ShowAddonMemory = false,
			ShowAddonIncRate = false,
			NumOfAddons = 5,
			AddonMemoryType = 1,
			ShowIcon = 1,
			ShowLabelText = false,
			ShowColoredText = 1,
			DisplayOnRightSide = false,
		}
	};

	self.fpsSampleCount = 0;
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function OnHide()
	AceTimer:CancelTimer(PerfTimer)
	PerfTimerRunning = false
end

--[[
-- **************************************************************************
-- NAME : TitanPanelPerformanceButton_OnUpdate(elapsed)
-- DESC : Update button data
-- VARS : elapsed = <research>
-- **************************************************************************
--]]
function TitanPanelPerformanceButtonHandle_OnUpdate()
	TitanPanelPluginHandle_OnUpdate(updateTable);
	if not (TitanPanelRightClickMenu_IsVisible()) and _G["TitanPanelPerfControlFrame"]:IsVisible() and not (MouseIsOver(_G["TitanPanelPerfControlFrame"])) then
		_G["TitanPanelPerfControlFrame"]:Hide();
	end
end

local function OnShow()
	if PerfTimerRunning then
		-- Do not create a new one
	else
		PerfTimer = AceTimer:ScheduleRepeatingTimer(TitanPanelPerformanceButtonHandle_OnUpdate, 1.5 )
		PerfTimerRunning = true
	end
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local i;
		topAddOns = {}
		-- scan how many addons are active
		local count = NumAddons();
		local ActiveAddons = 0;
		local NumOfAddons = TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons");
--[[
Urnati - This was a kludge as I believe there was a conflict with other addons loading Ace3
libraries as TitanGetVar is misbehaving.  As such, I added the local NumOfAddons above
and added the following four lines of code looking for a nil when it shouldn't return
as the value defaults to 5.
I also added NumOfAddons below the TitanDebug to avoid the problem later on.
]]
		if NumOfAddons == nil then
			NumOfAddons = 5;
			TitanSetVar(TITAN_PERFORMANCE_ID, "NumOfAddons", 5);
		end
		for i=1, count do
			if IsAddOnLoaded(i) then
				ActiveAddons = ActiveAddons + 1;
			end
		end

		if ActiveAddons < NumOfAddons then
			counter = ActiveAddons;
		else
			counter = NumOfAddons;
		end
		--set the counter to the proper number of active addons that are being monitored
		for i=1, counter do
			topAddOns[i] = {name = '', value = 0}
		end
	end
end

--[[
-- **************************************************************************
-- NAME : TitanPanelPerformanceButton_ResetMemory()
-- DESC : Reset the memory monitoring values
-- **************************************************************************
--function TitanPanelPerformanceButton_ResetMemory()
	-- local button = _G["TitanPanelPerformanceButton"];
	--button.memory, button.gcThreshold = gcinfo();
	--button.initialMemory = button.memory;
	--button.startSessionTime = time();
--end
--]]

--[[
-- **************************************************************************
-- NAME : TitanPanelPerformanceButton_OnClick()
-- DESC : Execute garbage collection for Leftclick on button
-- **************************************************************************
--]]
local function OnClick(self, button)
	if button == "LeftButton" then
		collectgarbage('collect');
	end
end

--[[
-- **************************************************************************
-- NAME : Slider_OnEnter()
-- DESC : Display tooltip on entering slider
-- **************************************************************************
--]]
local function Slider_OnEnter(self)
	self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"], TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons"));
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
end

--[[
-- **************************************************************************
-- NAME : Slider_OnLeave()
-- DESC : Hide tooltip after leaving slider
-- **************************************************************************
--]]
local function Slider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
end

--[[
-- **************************************************************************
-- NAME : Slider_OnShow()
-- DESC : Display slider tooltip
-- **************************************************************************
--]]
local function Slider_OnShow(self)
	
	_G[self:GetName().."Text"]:SetText(TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons"));
	_G[self:GetName().."High"]:SetText(L["TITAN_PERFORMANCE_CONTROL_LOW"]);
	_G[self:GetName().."Low"]:SetText(L["TITAN_PERFORMANCE_CONTROL_HIGH"]);
	self:SetMinMaxValues(APP_MIN, APP_MAX);
	self:SetValueStep(1);
	self:SetObeyStepOnDrag(true) -- since 5.4.2 (Mists of Pandaria)
	self:SetValue(CalcAppNum(TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons")));

	local lev = TitanPanelRightClickMenu_GetDropdownLevel() - 1
	local dds = TitanPanelRightClickMenu_GetDropdownFrameBase()..tostring(lev)
	local drop_down = _G[dds]
--	local scale = TitanPanelPerfControlFrame:GetScale()
	TitanPanelPerfControlFrame:ClearAllPoints();
	TitanPanelPerfControlFrame:SetPoint("LEFT", drop_down, "RIGHT", 0, 0);
	local offscreenX, offscreenY = TitanUtils_GetOffscreen(TitanPanelPerfControlFrame);
	if offscreenX == -1 or offscreenX == 0 then
		TitanPanelPerfControlFrame:ClearAllPoints();
		TitanPanelPerfControlFrame:SetPoint("LEFT", drop_down, "RIGHT", 0, 0);
	else
		TitanPanelPerfControlFrame:ClearAllPoints();
		TitanPanelPerfControlFrame:SetPoint("RIGHT", drop_down, "LEFT", 0, 0);
	end

--[[
	local top_point, top_rel_to, top_rel_point, top_x, top_y = 
		TitanPanelPerfControlFrame:GetPoint(TitanPanelPerfControlFrame:GetNumPoints())
print("TPref"
.." "..tostring(drop_down:GetName())..""
.." "..tostring(offscreenX)..""
.." "..tostring(offscreenY)..""
)
print("TPref"
.." "..tostring(top_point)..""
.." "..tostring(top_rel_to:GetName())..""
.." "..tostring(top_rel_point)..""
.." "..tostring(top_x)..""
.." "..tostring(top_y)..""
)
--]]
end

--[[
-- **************************************************************************
-- NAME : Slider_OnValueChanged(arg1)
-- DESC : Display slider tooltip text
-- VARS : arg1 = positive or negative change to apply
-- **************************************************************************
--]]
local function Slider_OnValueChanged(self, a1)
	local val = CalcAppNum(self:GetValue()) -- grab new value

	_G[self:GetName().."Text"]:SetText(val);
--[[
	if a1 == -1 then
		self:SetValue(self:GetValue() + 1);
	end

	if a1 == 1 then
		self:SetValue(self:GetValue() - 1);
	end
--]]
	TitanSetVar(TITAN_PERFORMANCE_ID, "NumOfAddons", val);

	local i;
	topAddOns = {};
	-- scan how many addons are active
	local count = NumAddons();
	local ActiveAddons = 0;
	for i=1, count do
		if IsAddOnLoaded(i) then
			ActiveAddons = ActiveAddons + 1;
		end
	end

	if ActiveAddons < TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons") then
		counter = ActiveAddons;
	else
		counter = TitanGetVar(TITAN_PERFORMANCE_ID, "NumOfAddons");
	end

	--set the counter to the proper number of active addons that are being monitored
	for i=1, counter do
		topAddOns[i] = {name = '', value = 0}
	end

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"], tostring(val))
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

--[[
-- **************************************************************************
-- NAME : Control_OnLoad()
-- DESC : Create performance option frame
-- **************************************************************************
--]]
local function Control_OnLoad(self)
	_G[self:GetName().."Title"]:SetText(L["TITAN_PERFORMANCE_CONTROL_TITLE"]);
--[[
Blizzard decided to remove direct Backdrop API in 9.0 (Shadowlands)
so inherit the template (XML) and set the values in the code (Lua)

9.5 The tooltip template was removed from the GameTooltip.
--]]
	TitanPanelRightClickMenu_SetCustomBackdrop(self)
end

--[[
-- **************************************************************************
-- NAME : Control_OnUpdate(elapsed)
-- DESC : If dropdown is visible, see if its timer has expired.  If so, hide frame
-- VARS : elapsed = <research>
-- **************************************************************************
--]]
local function Control_OnUpdate(self, elapsed)
	local drop_down = TitanPanelRightClickMenu_GetDropdownFrame()
	
	if not MouseIsOver(_G["TitanPanelPerfControlFrame"])
--	and not MouseIsOver (_G[drop_down.."2Button4"])
--	and not MouseIsOver (_G[drop_down.."2Button4ExpandArrow"]) 
	then
		TitanUtils_CheckFrameCounting(self, elapsed);
	end
end

-- ====== Create needed frames
local function Create_Frames()
	if _G[TITAN_BUTTON] then
		return -- if already created
	end
	
	-- general container frame
	local f = CreateFrame("Frame", nil, UIParent)
--	f:Hide()

	-- Titan plugin button
	local window = CreateFrame("Button", TITAN_BUTTON, f, "TitanPanelComboTemplate")
	window:SetFrameStrata("FULLSCREEN")
	-- Using SetScript("OnLoad",   does not work
	OnLoad(window);
--	TitanPanelButton_OnLoad(window); -- Titan XML template calls this...
	
	window:SetScript("OnShow", function(self)
		OnShow()
		TitanPanelButton_OnShow(self)
	end)
	window:SetScript("OnHide", function(self)
		OnHide()
	end)
	window:SetScript("OnEvent", function(self, event, ...)
		OnEvent(self, event, ...) 
	end)
	window:SetScript("OnClick", function(self, button)
		OnClick(self, button)
		TitanPanelButton_OnClick(self, button)
	end)


---[===[
	-- Config screen
	local cname = "TitanPanelPerfControlFrame"
	local config = CreateFrame("Frame", cname, f, BackdropTemplateMixin and "BackdropTemplate")
	config:SetFrameStrata("FULLSCREEN")
	config:Hide()
	config:SetWidth(120)
	config:SetHeight(170)

	config:SetScript("OnEnter", function(self)
		TitanUtils_StopFrameCounting(self)
	end)
	config:SetScript("OnLeave", function(self)
		TitanUtils_StartFrameCounting(self, 0.5)
	end)
	config:SetScript("OnUpdate", function(self, elapsed)
		Control_OnUpdate(self, elapsed)
	end)
	
	-- Config Title
	local str = nil
	local style = "GameFontNormalSmall"
	str = config:CreateFontString(cname.."Title", "ARTWORK", style)
	str:SetPoint("TOP", config, 0, -10)

	-- Config slider sections
	local slider = nil

	-- Hours offset
	local inherit = "TitanOptionsSliderTemplate"
	local offset = CreateFrame("Slider", "TitanPanelPerfControlSlider", config, inherit)
	offset:SetPoint("TOP", config, 0, -40)
	offset:SetScript("OnShow", function(self)
		Slider_OnShow(self)
	end)
	offset:SetScript("OnValueChanged", function(self, value)
		Slider_OnValueChanged(self, value)
	end)
	offset:SetScript("OnMouseWheel", function(self, delta)
		Slider_OnValueChanged(self, delta)
	end)
	offset:SetScript("OnEnter", function(self)
		Slider_OnEnter(self)
	end)
	offset:SetScript("OnLeave", function(self)
		Slider_OnLeave(self)
	end)

	-- Now that the parts exist, initialize
	Control_OnLoad(config)

--]===]
end


if TITAN_ID then -- it exists
	Create_Frames() -- do the work
end
