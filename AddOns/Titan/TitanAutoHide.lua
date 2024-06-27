--[===[ File
Contains the routines of AutoHide Titan plugin to auto hide a Titan bar.

Auto hide uses a data driven approach. Rather than seperate routines for each bar, auto hide is implemented in a general manner. 
The table TitanBarData hold relevant data needed to control auto hide. 

If auto hide is turned on these routines will show / hide the proper bar (and plugins on the bar).
These routines control the 'push pin' on each bar, if shown.

The hider bar is a 1/2 height bar used to catch the mouse over to show the bar again.

For documentation, this is treated as a Titan plugin
--]===]
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local Dewdrop = nil
if AceLibrary and AceLibrary:HasInstance("Dewdrop-2.0") then Dewdrop = AceLibrary("Dewdrop-2.0") end

-- local routines
--[[ local
NAME: Titan_AutoHide_SetIcon
DESC: Set the icon for the plugin.
VAR: self - The bar
OUT: None
--]]
local function Titan_AutoHide_SetIcon(self)
	local frame_auto_hide = self:GetName()
	local bar = self.bar_name
	local frame_str  = TitanVariables_GetFrameName(bar)

	-- Get the icon of the icon template
	local icon = _G[frame_auto_hide.."Icon"]
	if TitanBarDataVars[frame_str].auto_hide then
		icon:SetTexture("Interface\\AddOns\\Titan\\Artwork\\TitanPanelPushpinOut")
	else
		icon:SetTexture("Interface\\AddOns\\Titan\\Artwork\\TitanPanelPushpinIn")
	end	
end

-- Event handlers
--[[ 
NAME: Titan_AutoHide_OnLoad
DESC: Setup the plugin on the given bar.
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_OnLoad(self)
	local frame = self:GetName()
	local bar = self.bar_name

	self.registry = {
		id = "AutoHide_"..bar,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = "AutoHide_"..bar,
		tooltipTitle = L["TITAN_PANEL_AUTOHIDE_TOOLTIP"],
		tooltipTextFunction = "TitanPanelClockButton_GetTooltipText",
		savedVariables = {
			DisplayOnRightSide = 1,
			ForceBar = bar,
		}
	};
end

function TitanPanelClockButton_GetTooltipText(self)
	local returnstring = ""
--[[
	local bar = self.bar_name
	local frame_str  = TitanVariables_GetFrameName(bar)

	if TitanBarDataVars[frame_str].auto_hide then
		returnstring = L["TITAN_PANEL_MENU_DISABLED"]
	else
		returnstring = L["TITAN_PANEL_MENU_ENABLED"]
	end
--]]
	return returnstring
end

--[[ 
NAME: Titan_AutoHide_OnShow
DESC: Show the plugin on the given bar.
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_OnShow(self)
	Titan_AutoHide_SetIcon(self)	
end

--[[ 
NAME: Titan_AutoHide_OnClick
DESC: Handle button clicks on the given bar.
VAR: self - The bar
VAR: button - The mouse button clicked
OUT:  None
--]]
function Titan_AutoHide_OnClick(self, button)
	if (button == "LeftButton") then
		Titan_AutoHide_ToggleAutoHide(self.bar_name);
	end
end

-- Auto hide routines
--[[ 
NAME: Titan_AutoHide_Timers
DESC: This routine accepts the display bar frame and whether the cursor is entering or leaving. On enter kill the timers that are looking to hide the bar. On leave start the timer to hide the bar.
VAR: frame - The bar
VAR: action - "Enter" | "Leave"
OUT:  None
--]]
function Titan_AutoHide_Timers(frame, action)
	if not frame or not action then
		return
	end
	local bar = TitanBarData[frame].name --(frame.bar_name or nil)
	local hide = TitanBarDataVars[frame].auto_hide -- (bar and TitanPanelGetVar(bar.."_Hide") or nil)
	
	if bar and hide then
		if (action == "Enter") then
				AceTimer.CancelAllTimers(frame)
		end
		if (action == "Leave") then
			-- pass the bar as an arg so we can get it back
			AceTimer.ScheduleRepeatingTimer(frame, Handle_OnUpdateAutoHide, 0.5, frame)
		end
	end
end

--[[ 
NAME: Titan_AutoHide_Init
DESC: Show / hide the given bar per the user requested settings
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_Init(frame)
	if _G[frame] then -- sanity check
		local bar = TitanBarData[frame].name

		-- Make sure the bar should be processed
		if TitanBarDataVars[frame].show then --if (TitanPanelGetVar(bar.."_Show")) then
			-- Hide / show the bar 
			if TitanBarDataVars[frame].auto_hide then
--			if (TitanPanelGetVar(bar.."_Hide")) then
				TitanPanelBarButton_Hide(frame);
			else
				TitanPanelBarButton_Show(frame);
			end
		else
			TitanPanelBarButton_Hide(frame);
		end
		if TitanBarData[frame].hider then
			Titan_AutoHide_SetIcon(_G[AUTOHIDE_PREFIX..bar..AUTOHIDE_SUFFIX])
		else
			-- No auto hide
		end
	else
		-- sanity check, do nothing
	end
end

--[[ 
NAME: Titan_AutoHide_ToggleAutoHide
DESC: Toggle the user requested show / hide setting then show / hide given bar
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_ToggleAutoHide(bar)
	local frame_str  = TitanVariables_GetFrameName(bar)
	
	-- toggle the correct auto hide variable
	TitanBarDataVars[frame_str].auto_hide = 
		not TitanBarDataVars[frame_str].auto_hide --TitanPanelToggleVar(bar.."_Hide")
	-- Hide / show the requested Titan bar
	Titan_AutoHide_Init(frame_str)
end

--[[ 
NAME: Handle_OnUpdateAutoHide
DESC: Hide the bar if the user has auto hide after the cursor leaves the display bar.
VAR: frame - The bar
OUT: None
--]]
function Handle_OnUpdateAutoHide(frame)
	if TitanPanelRightClickMenu_IsVisible() 
	or (Tablet20Frame and Tablet20Frame:IsVisible()) 
	or (Dewdrop and Dewdrop:IsOpen())then
		return
	end
	
	local data = TitanBarData[frame] or nil
	if not data then -- sanity check
		return
	end
--	local bar = (data.name or nil)
	
	local hide = TitanBarDataVars[frame].auto_hide -- TitanPanelGetVar(bar.."_Hide")
	-- 
	if hide then
		AceTimer.CancelAllTimers(frame)
		TitanPanelBarButton_Hide(frame)
	end
end

--
--==========================
-- Routines to handle moving and sizing of short bars
--
local function Create_Hide_Button(bar, f)
	local name = AUTOHIDE_PREFIX..bar..AUTOHIDE_SUFFIX
	local plugin = CreateFrame("Button", name, f, "TitanPanelIconTemplate")
	plugin:SetFrameStrata("FULLSCREEN")
	
	plugin.bar_name = bar -- set the bar name for the .registry

	-- Using SetScript("OnLoad",   does not work
	Titan_AutoHide_OnLoad(plugin);
--	TitanPanelButton_OnLoad(plugin); -- Titan XML template calls this...
	
	plugin:SetScript("OnShow", function(self)
		Titan_AutoHide_OnShow(self) 
	end)
	plugin:SetScript("OnClick", function(self, button)
		Titan_AutoHide_OnClick(self, button);
		TitanPanelButton_OnClick(self, button);
	end)
end

--local function Create_Frames()
function Titan_AutoHide_Create_Frames()
	--====== Titan Auto hide plugin buttons ==============================
	-- general container frame
	local f = CreateFrame("Frame", nil, UIParent)

	Create_Hide_Button("Bar", f)
	Create_Hide_Button("Bar2", f)
	Create_Hide_Button("AuxBar2", f)
	Create_Hide_Button("AuxBar", f)
	
end


Titan_AutoHide_Create_Frames() -- do the work
