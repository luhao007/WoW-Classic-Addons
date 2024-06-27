--[[
	TitanSpeed: A simple speedometer.
	Author: Trentin - > Quel -> tainted -> TotalPackage
--]]

local menutext = "Titan|cffffaa00Spe|r|cffff8800ed|r"
local buttonlabel = "Speed: "
local ID = "Speed"
local elap, speed, prevs = 0, 0, -2
local showtenth = false
local GetUnitSpeed = GetUnitSpeed
local math_cos, floor = math.cos, floor

-- Main button frame and addon base
local f = CreateFrame("Button", "TitanPanelSpeedButton", CreateFrame("Frame", nil, UIParent), "TitanPanelComboTemplate")
f:SetFrameStrata("FULLSCREEN")
f:SetScript("OnEvent", function(this, event, ...) this[event](this, ...) end)
f:RegisterEvent("ADDON_LOADED")

---------------------------
function f:ADDON_LOADED(a1)
---------------------------
	if a1 ~= "TitanSpeed" then return end
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	
	self.registry = {
		id = ID,
		menuText = menutext,
		buttonTextFunction = "TitanPanelSpeedButton_GetButtonText",
		tooltipTitle = ID,
		tooltipTextFunction = "TitanPanelSpeedButton_GetTooltipText",
		frequency = 0.5,
		icon = "Interface\\Icons\\Ability_Rogue_Sprint.blp",
		iconWidth = 16,
		category = "Information",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = false,
			ShowTenth = false,
		},
	}
	self:SetScript("OnUpdate", function(this, a1)
		elap = elap + a1
		if elap < 0.5 then return end
		if not self.runonce then
			self.runonce = 1
			showtenth = TitanGetVar(ID, "ShowTenth")
		end
		speed = GetUnitSpeed("player")

		if speed == prevs then return end
		prevs = speed
		TitanPanelButton_UpdateButton(ID)
		elap = 0
	end)

end

----------------------------------------------
function TitanPanelSpeedButton_GetButtonText()
----------------------------------------------
	local speedtext
	if not speed then
		speedtext = "|cffffffff??%%|r"
	else
		speedtext = speed / 0.07
		if TitanGetVar(ID, "ShowTenth") == 1 then
			speedtext = format("|cffffffff%.1f%%|r", speedtext)
		else
			speedtext = format("|cffffffff%d%%|r", floor(speedtext + 0.5))
		end
	end
	return buttonlabel, speedtext
end

-----------------------------------------------
function TitanPanelSpeedButton_GetTooltipText()
-----------------------------------------------
	return "Displays your moving speed as a \npercent (relative to your normal \nrunning speed).\n|cff00ff00Use: Right-click for options.|r"
end


local function ToggleShowTenth()
	prevs = -2
	TitanToggleVar(ID, "ShowTenth")
	showtenth = TitanGetVar(ID, "ShowTenth")
end

local temp = {}
local function UIDDM_Add(text, func, checked, keepShown)
	temp.text, temp.func, temp.checked, temp.keepShownOnClick = text, func, checked, keepShown
	L_UIDropDownMenu_AddButton(temp)
end
----------------------------------------------------
function TitanPanelRightClickMenu_PrepareSpeedMenu()
----------------------------------------------------
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[ID].menuText)
	
	UIDDM_Add("Show Tenths Digit", ToggleShowTenth, TitanGetVar(ID, "ShowTenth"), 1)
	TitanPanelRightClickMenu_AddToggleIcon(ID)
	TitanPanelRightClickMenu_AddToggleLabelText(ID)
	TitanPanelRightClickMenu_AddSpacer()
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, ID, TITAN_PANEL_MENU_FUNC_HIDE)
end