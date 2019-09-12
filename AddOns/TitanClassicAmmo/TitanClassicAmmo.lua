--[[
-- **************************************************************************
-- * TitanAmmo.lua
-- *
-- * By: Titan Panel Development Team
-- **************************************************************************
-- 2019 Aug - reverted and updated for Classic
--
-- This will track the count of ammo (bows and guns) or thrown (knives) equipped. 
-- Ammo is placed in the 'ammo' slot where Blizzard counts ALL of that *type of ammo*
-- regardless of where it is in your bags.
-- Thrown is placed in the actual weapon slot where Blizzard counts ALL of that *type of thrown*.
-- This forces a different routine to be used so the ammo must always be checked for type and count.
--]]
-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_AMMO_ID = "Ammo";

local SHOOT_STACK = 250
local ARROW_STACK = 200
local THROW_STACK = 100

local LIM_GOOD = 2
local LIM_OK   = 1.5
local LIM_BAD  = .5

local TITAN_AMMO_THRESHOLD_TABLE = { -- Use ammo stack and threshold limits above to calc colored text
	["INVTYPE_RANGEDRIGHT"] = {
		 Values = { SHOOT_STACK*LIM_BAD, SHOOT_STACK*LIM_OK, SHOOT_STACK*LIM_GOOD }, -- 125,375,500
		 Colors = { RED_FONT_COLOR, ORANGE_FONT_COLOR, NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR },
	 },
	["INVTYPE_RANGED"] = {
		 Values = { ARROW_STACK*LIM_BAD, ARROW_STACK*LIM_OK, ARROW_STACK*LIM_GOOD }, -- 100,150,400
		 Colors = { RED_FONT_COLOR, ORANGE_FONT_COLOR, NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR },
	 },
	["INVTYPE_THROWN"] = {
		 Values = { THROW_STACK*LIM_BAD, THROW_STACK*LIM_OK, THROW_STACK*LIM_GOOD }, -- 50,150,400
		 Colors = { RED_FONT_COLOR, ORANGE_FONT_COLOR, NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR },
	 },
};

-- ******************************** Variables *******************************
local class = select(2, UnitClass("player"))
local ammoSlotID = GetInventorySlotInfo("AmmoSlot")
local rangedSlotID = GetInventorySlotInfo("RangedSlot")
local ammo_count = 0;
local ammo_type  = "";
local ammo_name  = ""
local ammo_link  = "";
local ammo_show  = false -- show plugin based on class

local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)
-- ******************************** Functions *******************************
local function ClrAmmoInfo()
	ammo_count = 0;
	ammo_type  = "";
	ammo_name  = ""
	ammo_link  = "";
	ammo_show  = false
end
local function GetItemLink(rangedSlotID)
	return GetInventoryItemLink("player", rangedSlotID)
end
local function IsThrown(loc)
	local res = false
	if loc == "INVTYPE_THROWN" then
		res = true
	end
	return res
end
local function IsAmmo(loc)
	local res = false
	if loc == "INVTYPE_RANGED" or loc == "INVTYPE_RANGEDRIGHT" then
		res = true
	end
	return res
end
local function GetAmmoItemInfo(rangedSlotID)
	local loc = "";
	local itemlink = GetItemLink(rangedSlotID)

	if itemlink then
		loc = select(9, GetItemInfo(itemlink))
	end
	return itemlink, loc
end
local function GetAmmoCount(ammo_type)
	if IsThrown(ammo_type) then
		ammo_count = GetInventoryItemCount("player", rangedSlotID) or ammo_count
		ammo_name = select(1, GetItemInfo(GetInventoryItemID("player", rangedSlotID))) or _G["UNKNOWN"]
	elseif IsAmmo(ammo_type) then --and GetInventoryItemLink("player", ammoSlotID) 
		ammo_count = GetInventoryItemCount("player", ammoSlotID) or ammo_count
		ammo_name = select(1, GetItemInfo(GetInventoryItemID("player", ammoSlotID))) or _G["UNKNOWN"]
	else
		ClrAmmoInfo()
	end
end


-- **************************************************************************
-- NAME : TitanPanelAmmoButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelAmmoButton_OnLoad(self)
	self.registry = {
			id = TITAN_AMMO_ID,
			--builtIn = 1,
			category = "Built-ins",
			version = TITAN_VERSION,
			menuText = L["TITAN_AMMO_MENU_TEXT"],
			buttonTextFunction = "TitanPanelAmmoButton_GetButtonText", 
			tooltipTitle = L["TITAN_AMMO_TOOLTIP"],
			icon = "Interface\\AddOns\\TitanClassicAmmo\\TitanClassicThrown",
			iconWidth = 16,
			controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = false
		},
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
			ShowAmmoName = false,
		}
	};     

	self:SetScript("OnEvent",  function(_, event, arg1, ...)
		if event == "PLAYER_LOGIN" then
			TitanPanelAmmoButton_PLAYER_LOGIN()
		elseif event == "UNIT_INVENTORY_CHANGED" then
			TitanPanelAmmoButton_UNIT_INVENTORY_CHANGED(arg1, ...)
		elseif event == "UPDATE_INVENTORY_DURABILITY" then
			TitanPanelAmmoButton_UPDATE_INVENTORY_DURABILITY()
		elseif event == "MERCHANT_CLOSED" or event == "PLAYER_ENTERING_WORLD" then
			TitanPanelAmmoButton_MERCHANT_CLOSED()
		elseif event == "ACTIONBAR_HIDEGRID" then -- in case ammo is dropped into char slot
			TitanPanelAmmoButton_ACTIONBAR_HIDEGRID()
		end
	end)

	TitanPanelAmmoButton:RegisterEvent("PLAYER_LOGIN")
end

function TitanPanelAmmoButton_PLAYER_LOGIN()
	-- Class check
	if class ~= "ROGUE" and class ~= "WARRIOR" and class ~= "HUNTER" then
		TitanPanelAmmoButton_PLAYER_LOGIN = nil
		ammo_show = true
		return
	end

	ammo_show = true
	local itemlink, loc = GetAmmoItemInfo(rangedSlotID)
	ammo_link = itemlink;
	ammo_type = loc
	GetAmmoCount(ammo_type)
--[[
TitanDebug("TitanPanelAmmoButton_PLAYER_LOGIN"
.." "..tostring(ammo_type)
.." "..tostring(ammo_count)
.." "..tostring(IsThrown(ammo_type))
.." "..tostring(IsAmmo(ammo_type))
.." "..tostring(TITAN_AMMO_THRESHOLD_TABLE[ammo_type].Values[1])
)
--]]
	if IsThrown(ammo_type) then
		TitanPanelAmmoButton:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	elseif IsAmmo(ammo_type) then
		TitanPanelAmmoButton:RegisterEvent("ACTIONBAR_HIDEGRID")			
	end
	TitanPanelAmmoButton:RegisterEvent("UNIT_INVENTORY_CHANGED")
	TitanPanelAmmoButton:RegisterEvent("MERCHANT_CLOSED")
	TitanPanelAmmoButton:RegisterEvent("PLAYER_ENTERING_WORLD") 
	TitanPanelAmmoButton_PLAYER_LOGIN = nil	
end

function TitanPanelAmmoButton_UNIT_INVENTORY_CHANGED(arg1, ...)
	if arg1 == "player" then
		TitanPanelAmmoUpdateDisplay(); 	
		GetAmmoCount(ammo_type)
		TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
	end
end

function TitanPanelAmmoButton_UPDATE_INVENTORY_DURABILITY()
	ammo_count = GetInventoryItemCount("player", rangedSlotID) or ammo_count    -- GetInventoryItemDurability(rangedSlotID) or ammo_count
	TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
end

function TitanPanelAmmoButton_MERCHANT_CLOSED() 
	GetAmmoCount(ammo_type)
	TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
end

function TitanPanelAmmoButton_ACTIONBAR_HIDEGRID()
	local prev = 0
	TitanPanelAmmoButton:SetScript("OnUpdate", function(_, e)
		prev = prev + e
		if prev > 2 then
			TitanPanelAmmoButton:SetScript("OnUpdate", nil)
			ammo_count = GetInventoryItemCount("player", ammoSlotID) or ammo_count
			TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
		end
	end)
end

function TitanPanelAmmoUpdateDisplay()
	-- Manual Display update in case the rangedSlot it switched
	local itemlink, loc = GetAmmoItemInfo(rangedSlotID)

	if itemlink == ammo_link then
		return
	else
		ammo_link = itemlink
	end

	ammo_type = loc
	GetAmmoCount(ammo_type)
	
	-- Setup the events based on ammo type
	if IsThrown(ammo_type) then
		if not TitanPanelAmmoButton:IsEventRegistered("UPDATE_INVENTORY_DURABILITY") then
			TitanPanelAmmoButton:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
		end						
		if TitanPanelAmmoButton:IsEventRegistered("ACTIONBAR_HIDEGRID") then
			TitanPanelAmmoButton:UnregisterEvent("ACTIONBAR_HIDEGRID")
			TitanPanelAmmoButton:SetScript("OnUpdate", nil)				
		end
	elseif IsAmmo(ammo_type) then
		if TitanPanelAmmoButton:IsEventRegistered("UPDATE_INVENTORY_DURABILITY") then			
			TitanPanelAmmoButton:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
		end
		if not TitanPanelAmmoButton:IsEventRegistered("ACTIONBAR_HIDEGRID") then					
			TitanPanelAmmoButton:RegisterEvent("ACTIONBAR_HIDEGRID")				
		end
	end		
		
	TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
end

-- **************************************************************************
-- NAME : TitanPanelAmmoButton_GetButtonText(id)
-- DESC : Calculate ammo/thrown logic then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelAmmoButton_GetButtonText(id)
     
	local labelText, ammoText, ammoRichText, color;

	if not ammo_count then -- safeguard to prevent malformed labels
		ClrAmmoInfo() 
	end

	if (IsThrown(ammo_type)) then		          
		labelText = L["TITAN_AMMO_BUTTON_LABEL_THROWN"];
		ammoText = format(L["TITAN_AMMO_FORMAT"], ammo_count);
		if TitanGetVar(TITAN_AMMO_ID, "ShowAmmoName") and ammo_name ~= "" then
			ammoText = ammoText.."|cffffff9a".." ("..ammo_name..")".."|r"
		end
	elseif (IsAmmo(ammo_type)) then          
		labelText = L["TITAN_AMMO_BUTTON_LABEL_AMMO"];
		ammoText = format(L["TITAN_AMMO_FORMAT"], ammo_count);
		if TitanGetVar(TITAN_AMMO_ID, "ShowAmmoName") and ammo_name ~= "" then
			ammoText = ammoText.."|cffffff9a".." ("..ammo_name..")".."|r"
		end
	else
		ClrAmmoInfo();
		labelText = L["TITAN_AMMO_BUTTON_LABEL_AMMO_THROWN"];
		ammoText = L["TITAN_AMMO_BUTTON_NOAMMO"];
	end

	if (TitanGetVar(TITAN_AMMO_ID, "ShowColoredText")) then     
		color = TitanUtils_GetThresholdColor(TITAN_AMMO_THRESHOLD_TABLE[ammo_type], ammo_count);
		ammoRichText = TitanUtils_GetColoredText(ammoText, color);
	else
		ammoRichText = TitanUtils_GetHighlightText(ammoText);
	end

	return labelText, ammoRichText;
end

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareAmmoMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareAmmoMenu()
	local info = {};
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_AMMO_ID].menuText);
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_AMMO_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_AMMO_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_AMMO_ID);

	info.text = L["TITAN_AMMO_BULLET_NAME"];
	info.func = function() TitanPanelRightClickMenu_ToggleVar({TITAN_AMMO_ID, "ShowAmmoName"})
		TitanPanelButton_UpdateButton(TITAN_AMMO_ID);
	end
	info.checked = TitanUtils_Ternary(TitanGetVar(TITAN_AMMO_ID, "ShowAmmoName"), 1, nil);
	L_UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_AMMO_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end