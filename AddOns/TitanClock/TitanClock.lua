---@diagnostic disable: duplicate-set-field
--[[
-- **************************************************************************
-- * TitanClock.lua
-- *
-- * By: The Titan Panel Development Team
-- **************************************************************************
--]]

-- ******************************** Constants *******************************
TITAN_CLOCK_ID = "Clock";
local TITAN_BUTTON = "TitanPanel" .. TITAN_CLOCK_ID .. "Button"

local TITAN_CLOCK_FORMAT_12H = "12H";
local TITAN_CLOCK_FORMAT_24H = "24H";
local TITAN_CLOCK_FRAME_SHOW_TIME = 0.5;
local _G = getfenv(0);
-- ******************************** Variables *******************************
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local ClockTimer = {}
local ClockTimerRunning = false
local updateTable = { TITAN_CLOCK_ID, TITAN_PANEL_UPDATE_ALL };
local realmName = GetRealmName();
-- ******************************** Functions *******************************
local function SetColor(text)
	local label = "";
	if (TitanGetVar(TITAN_CLOCK_ID, "ShowColoredText")) then
		label = TitanUtils_GetGreenText(text)
	else
		label = TitanUtils_GetHighlightText(text)
	end
	return label;
end

local function TitanPanelClockButton_GetTime(displaytype, offset)
	-- Calculate the hour/minutes considering the offset
	local hour, minute = GetGameTime();
	local twentyfour = "";
	local offsettime = string.format("%s", offset);
	local offsethour = 0;
	local hour_str = ""
	local offsetmin = 0;
	local min_str = ""
	local s, e, id = string.find(offsettime, '%.5');

	if displaytype == "Server" then
		if (s ~= nil) then
			hour_str = string.sub(offsettime, 1, s);
			min_str = string.sub(offsettime, s + 1);
			if min_str == "" or min_str == nil then min_str = "0"; end
			if hour_str == "" or hour_str == nil then hour_str = "0"; end
			offsethour = tonumber(hour_str);
			if (tonumber(offsettime) < 0) then offsetmin = tonumber("-" .. min_str); end
			minute = minute + (offsetmin * 6);
			if (minute > 59) then
				minute = minute - 60;
				offsethour = offsethour + 1;
			elseif (minute < 0) then
				minute = 60 + minute;
				offsethour = offsethour - 1;
			end
		else
			offsethour = offset;
		end
	else
		-- no offset for local time
		hour, minute = tonumber(date("%H")), tonumber(date("%M"));
		offsethour = 0;
	end

	hour = hour + offsethour;

	if (hour > 23) then
		hour = hour - 24;
	elseif (hour < 0) then
		hour = 24 + hour;
	end

	-- Calculate the display text based on format 12H/24H
	if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_12H) then
		local isAM;
		if (hour >= 12) then
			isAM = false;
			hour = hour - 12;
		else
			isAM = true;
		end
		if (hour == 0) then
			hour = 12;
		end
		if (isAM) then
			return nil, format(TIME_TWELVEHOURAM, hour, minute);
		else
			return nil, format(TIME_TWELVEHOURPM, hour, minute);
		end
	else
		twentyfour = format(TIME_TWENTYFOURHOURS, hour, minute);
		if (hour < 10) then
			twentyfour = "0" .. twentyfour
		end
		return nil, twentyfour;
	end
end

--[[
-- **************************************************************************
-- NAME : GetButtonText()
-- DESC : Display time on button based on set variables
-- **************************************************************************
--]]
local function GetButtonText()
	local clocktime = "";
	local labeltext = "";
	local clocktime2 = nil;
	local labeltext2 = nil;
	local _ = nil
	if TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "Server" then
		_, clocktime = TitanPanelClockButton_GetTime("Server", 0)
		labeltext = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(S) ") or ""
	elseif TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerAdjusted" then
		_, clocktime = TitanPanelClockButton_GetTime("Server", TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"))
		labeltext = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(A) ") or ""
	elseif TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "Local" then
		_, clocktime = TitanPanelClockButton_GetTime("Local", 0)
		labeltext = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(L) ") or ""
	elseif TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerLocal" then
		local _, s = TitanPanelClockButton_GetTime("Server", 0)
		local _, l = TitanPanelClockButton_GetTime("Local", 0)
		local sl = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(S) ") or ""
		local ll = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(L) ") or ""
		clocktime = s
		labeltext = sl
		clocktime2 = l
		labeltext2 = ll
	elseif TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerAdjustedLocal" then
		local _, s = TitanPanelClockButton_GetTime("Server", TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"))
		local _, l = TitanPanelClockButton_GetTime("Local", 0)
		local sl = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(A) ") or ""
		local ll = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(L) ") or ""
		clocktime = s
		labeltext = sl
		clocktime2 = l
		labeltext2 = ll
	elseif TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "Local" then
		_, clocktime = TitanPanelClockButton_GetTime("Local", 0)
		labeltext = TitanGetVar(TITAN_CLOCK_ID, "ShowLabelText") and SetColor("(L) ") or ""
	end
	return labeltext, clocktime, labeltext2, clocktime2
end

--[[
-- **************************************************************************
-- NAME : TitanPanelClock_GetOffsetText(offset)
-- DESC : Get hour offset value and return
-- VARS : offset = hour offset from server time
-- **************************************************************************
--]]
local function TitanPanelClock_GetOffsetText(offset)
	if (offset > 0) then
		return TitanUtils_GetGreenText("+" .. tostring(offset));
	elseif (offset < 0) then
		return TitanUtils_GetRedText(tostring(offset));
	else
		return TitanUtils_GetHighlightText(tostring(offset));
	end
end

--[[
-- **************************************************************************
-- NAME : GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
--]]
local function GetTooltipText()
	local _, clockTimeLocal = TitanPanelClockButton_GetTime("Local", 0)
	local _, clockTimeServer = TitanPanelClockButton_GetTime("Server", 0)
	local _, clockTimeServerAdjusted = TitanPanelClockButton_GetTime("Server", TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"))
	local clockTimeLocalLabel = L["TITAN_CLOCK_TOOLTIP_LOCAL_TIME"] .. "\t" ..
	TitanUtils_GetHighlightText(clockTimeLocal)
	local clockTimeServerLabel = L["TITAN_CLOCK_TOOLTIP_SERVER_TIME"] ..
	"\t" .. TitanUtils_GetHighlightText(clockTimeServer)
	local clockTimeServerAdjustedLabel = "";
	if TitanGetVar(TITAN_CLOCK_ID, "OffsetHour") ~= 0 then
		clockTimeServerAdjustedLabel = L["TITAN_CLOCK_TOOLTIP_SERVER_ADJUSTED_TIME"] ..
		"\t" .. TitanUtils_GetHighlightText(clockTimeServerAdjusted) .. "\n"
	end
	local clockText = TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"));
	return "" ..
		clockTimeLocalLabel .. "\n" ..
		clockTimeServerLabel .. "\n" ..
		clockTimeServerAdjustedLabel ..
		L["TITAN_CLOCK_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(clockText) .. "\n" ..
		TitanUtils_GetGreenText(L["TITAN_CLOCK_TOOLTIP_HINT1"]) .. "\n" ..
		TitanUtils_GetGreenText(L["TITAN_CLOCK_TOOLTIP_HINT2"]) .. "\n" ..
		TitanUtils_GetGreenText(L["TITAN_CLOCK_TOOLTIP_HINT3"]);
end

local function ToggleGameTimeFrameShown()
	TitanToggleVar(TITAN_CLOCK_ID, "HideGameTimeMinimap");
	if GameTimeFrame and GameTimeFrame:GetName() then
		if TitanGetVar(TITAN_CLOCK_ID, "HideGameTimeMinimap") then
			GameTimeFrame:Hide()
		else
			GameTimeFrame:Show()
		end
	end
end

local function ToggleMapTime()
	TitanToggleVar(TITAN_CLOCK_ID, "HideMapTime");
	if TimeManagerClockButton and TimeManagerClockButton:GetName() then
		if TitanGetVar(TITAN_CLOCK_ID, "HideMapTime") then
			TimeManagerClockButton:Hide()
		else
			TimeManagerClockButton:Show()
		end
	else
		print("TitanClock: no time widget")
	end
end

--[[
-- **************************************************************************
-- NAME : CreateMenu()
-- DESC : Generate clock right click menu options
-- **************************************************************************
--]]
local function CreateMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_CLOCK_ID].menuText);

	local info = {};
	info.text = L["TITAN_CLOCK_MENU_LOCAL_TIME"];
	info.func = function()
		TitanSetVar(TITAN_CLOCK_ID, "TimeMode", "Local")
		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function() return TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "Local" end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.text = L["TITAN_CLOCK_MENU_SERVER_TIME"];
	info.func = function()
		TitanSetVar(TITAN_CLOCK_ID, "TimeMode", "Server")
		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function() return TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "Server" end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.text = L["TITAN_CLOCK_MENU_SERVER_ADJUSTED_TIME"];
	info.func = function()
		TitanSetVar(TITAN_CLOCK_ID, "TimeMode", "ServerAdjusted")
		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function() return TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerAdjusted" end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.text = L["TITAN_CLOCK_MENU_SERVER_TIME"] .. " & " .. L["TITAN_CLOCK_MENU_LOCAL_TIME"]
	info.func = function()
		TitanSetVar(TITAN_CLOCK_ID, "TimeMode", "ServerLocal")
		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function() return TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerLocal" end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.text = L["TITAN_CLOCK_MENU_SERVER_ADJUSTED_TIME"] .. " & " .. L["TITAN_CLOCK_MENU_LOCAL_TIME"]
	info.func = function()
		TitanSetVar(TITAN_CLOCK_ID, "TimeMode", "ServerAdjustedLocal")
		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function() return TitanGetVar(TITAN_CLOCK_ID, "TimeMode") == "ServerAdjustedLocal" end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {}; -- 12 or 24 hour format
	info.text = L["TITAN_CLOCK_CHECKBUTTON"]
	info.func = function()
		if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_12H) then
			TitanSetVar(TITAN_CLOCK_ID, "Format", TITAN_CLOCK_FORMAT_24H);
		else
			TitanSetVar(TITAN_CLOCK_ID, "Format", TITAN_CLOCK_FORMAT_12H);
		end
		if (ServerHourFormat[realmName]) then
			ServerHourFormat[realmName] = TitanGetVar(TITAN_CLOCK_ID, "Format");
		end

		TitanPanelButton_UpdateButton(TITAN_CLOCK_ID)
	end
	info.checked = function()
		if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_24H) then
			return true
		else
			return false
		end
	end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	TitanPanelRightClickMenu_AddSpacer();

	info = {};
	info.text = L["TITAN_CLOCK_MENU_HIDE_MAPTIME"];
	info.func = ToggleMapTime;
	info.checked = TitanGetVar(TITAN_CLOCK_ID, "HideMapTime");
	info.keepShownOnClick = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.text = L["TITAN_CLOCK_MENU_HIDE_CALENDAR"];
	info.func = ToggleGameTimeFrameShown;
	info.checked = TitanGetVar(TITAN_CLOCK_ID, "HideGameTimeMinimap");
	info.keepShownOnClick = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	TitanPanelRightClickMenu_AddControlVars(TITAN_CLOCK_ID)
end

--[[
-- **************************************************************************
-- NAME : OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
--]]
local function OnLoad(self)
	local notes = ""
		.. "Adds a clock to Titan Panel.\n"
		.. "- Select server time / local time / both server and local time.\n"
	self.registry = {
		id = TITAN_CLOCK_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_CLOCK_MENU_TEXT"],
		menuTextFunction = CreateMenu,
		buttonTextFunction = GetButtonText,
		tooltipTitle = L["TITAN_CLOCK_TOOLTIP"],
		tooltipTextFunction = GetTooltipText,
		notes = notes,
		controlVariables = {
			ShowIcon = false,
			ShowLabelText = true,
			ShowColoredText = true,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			OffsetHour = 0,
			Format = TITAN_CLOCK_FORMAT_12H,
			TimeMode = "Server",
			ShowIcon = true,
			ShowLabelText = false,
			ShowColoredText = false,
			DisplayOnRightSide = 1,
			HideGameTimeMinimap = false,
			HideMapTime = false,
		}
	};
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

--[[
-- **************************************************************************
-- NAME : OnShow()
-- DESC : Create repeating timer when plugin is visible
-- **************************************************************************
--]]
local function OnShow(self)
	if ClockTimerRunning then
		-- Do not create a new one
	else
		ClockTimer = AceTimer:ScheduleRepeatingTimer(TitanPanelPluginHandle_OnUpdate, 30, updateTable)
		ClockTimerRunning = true
	end
end

--[[
-- **************************************************************************
-- NAME : OnHide()
-- DESC : Destroy repeating timer when plugin is hidden
-- **************************************************************************
--]]
local function OnHide(self)
	AceTimer:CancelTimer(ClockTimer)
	ClockTimerRunning = false
end

local function OnEvent(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		-- If the user wants the minimap clock or calendar hidden then hide them
		if TitanGetVar(TITAN_CLOCK_ID, "HideGameTimeMinimap") then
			if GameTimeFrame then GameTimeFrame:Hide() end
		end
		if TimeManagerClockButton and TimeManagerClockButton:GetName() then
			if TitanGetVar(TITAN_CLOCK_ID, "HideMapTime") then
				TimeManagerClockButton:Hide()
			else
				TimeManagerClockButton:Show()
			end
		end
	end
end

local function OnClick(self, button)
	if button == "LeftButton" and IsShiftKeyDown() then
		TitanUtils_CloseAllControlFrames();
		if (TitanPanelRightClickMenu_IsVisible()) then
			TitanPanelRightClickMenu_Close();
		end
		ToggleCalendar()
	elseif button == "LeftButton" then
	else
		TitanPanelButton_OnClick(self, button);
	end
end

--[[
-- **************************************************************************
-- NAME : Slider_OnEnter()
-- DESC : Display slider tooltip
-- **************************************************************************
--]]
local function Slider_OnEnter(self)
	self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_CLOCK_CONTROL_TOOLTIP"],
		TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

--[[
-- **************************************************************************
-- NAME : Slider_OnLeave()
-- DESC : Hide slider tooltip
-- **************************************************************************
--]]
local function Slider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_CLOCK_FRAME_SHOW_TIME);
end

--[[
-- **************************************************************************
-- NAME : Slider_OnShow()
-- DESC : Display slider tooltip options
-- **************************************************************************
--]]
local function Slider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
	_G[self:GetName() .. "High"]:SetText(L["TITAN_CLOCK_CONTROL_LOW"]);
	_G[self:GetName() .. "Low"]:SetText(L["TITAN_CLOCK_CONTROL_HIGH"]);
	--	self:SetThumbTexture("Interface\Buttons\UI-SliderBar-Button-Vertical")
	self:SetMinMaxValues(-12, 12);
	self:SetValueStep(0.5);
	self:SetObeyStepOnDrag(true) -- since 5.4.2 (Mists of Pandaria)
	self:SetValue(0 - TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"));
end

--[[
-- **************************************************************************
-- NAME : Slider_OnValueChanged(arg1)
-- DESC : Display slider tooltip text
-- VARS : arg1 = positive or negative change to apply
-- **************************************************************************
--]]
local function Slider_OnValueChangedWheel(self, a1)
	_G[self:GetName() .. "Text"]:SetText(TitanPanelClock_GetOffsetText(0 - self:GetValue()));
	local tempval = self:GetValue();

	if a1 == -1 then
		self:SetValue(tempval + 0.5);
	end

	if a1 == 1 then
		self:SetValue(tempval - 0.5);
	end

	TitanSetVar(TITAN_CLOCK_ID, "OffsetHour", 0 - self:GetValue());
	if (ServerTimeOffsets[realmName]) then
		ServerTimeOffsets[realmName] = TitanGetVar(TITAN_CLOCK_ID, "OffsetHour");
	end
	TitanPanelButton_UpdateButton(TITAN_CLOCK_ID);

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_CLOCK_CONTROL_TOOLTIP"],
			TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end


local function Slider_OnValueChanged(self, a1)
	local step = self:GetValue()
	_G[self:GetName() .. "Text"]:SetText(TitanPanelClock_GetOffsetText(0 - step));
	TitanSetVar(TITAN_CLOCK_ID, "OffsetHour", 0 - step);
	if (ServerTimeOffsets[realmName]) then
		ServerTimeOffsets[realmName] = TitanGetVar(TITAN_CLOCK_ID, "OffsetHour");
	end
	TitanPanelButton_UpdateButton(TITAN_CLOCK_ID);

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_CLOCK_CONTROL_TOOLTIP"],
			TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

--[[
-- **************************************************************************
-- NAME : TitanPanelClockControlFrame_OnLoad()
-- DESC : Create clock option frame
-- **************************************************************************
--]]
local function TitanPanelClockControlFrame_OnLoad(self)
	_G[self:GetName() .. "Title"]:SetText(L["TITAN_CLOCK_CONTROL_TITLE"]);
	--[[
Blizzard decided to remove direct Backdrop API in 9.0 (Shadowlands)
so inherit the template (XML)
and set the values in the code (Lua)

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
	TitanUtils_CheckFrameCounting(self, elapsed);
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
	local window = CreateFrame("Button", TITAN_BUTTON, f, "TitanPanelTextTemplate")
	window:SetFrameStrata("FULLSCREEN")
	-- Using SetScript("OnLoad",   does not work
	OnLoad(window);
	--	TitanPanelButton_OnLoad(window); -- Titan XML template calls this...

	window:SetScript("OnShow", function(self)
		OnShow(self)
		TitanPanelButton_OnShow(self)
	end)
	window:SetScript("OnHide", function(self)
		OnHide(self)
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
	local cname = "TitanPanelClockControlFrame"
	local config = CreateFrame("Frame", cname, f, BackdropTemplateMixin and "BackdropTemplate")
	config:SetFrameStrata("FULLSCREEN") -- FULLSCREEN
	config:Hide()                    --
	config:SetWidth(90)
	config:SetHeight(200)

	config:SetScript("OnShow", function(self)
	end)
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
	str = config:CreateFontString(cname .. "Title", "ARTWORK", style)
	str:SetPoint("TOP", config, 0, -10)

	-- Config slider sections
	local slider = nil

	-- Hours offset
	local inherit = "TitanOptionsSliderTemplate"
	local offset = CreateFrame("Slider", "TitanPanelClockControlSlider", config, inherit)
	offset:SetPoint("TOP", config, 0, -40)
	offset:SetScript("OnShow", function(self)
		Slider_OnShow(self)
	end)
	offset:SetScript("OnValueChanged", function(self, value, userInput)
		Slider_OnValueChanged(self, value)
	end)
	offset:SetScript("OnMouseWheel", function(self, delta)
		Slider_OnValueChangedWheel(self, delta)
	end)
	offset:SetScript("OnEnter", function(self)
		Slider_OnEnter(self)
	end)
	offset:SetScript("OnLeave", function(self)
		Slider_OnLeave(self)
	end)

	-- Now that the parts exist, initialize
	TitanPanelClockControlFrame_OnLoad(config)

	--]===]
end

Create_Frames() -- do the work
