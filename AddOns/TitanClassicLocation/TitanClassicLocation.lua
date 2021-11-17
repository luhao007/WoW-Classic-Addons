-- **************************************************************************
-- * TitanLocation.lua
-- *
-- * By: TitanMod, Dark Imakuni, Adsertor and the Titan Panel Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_LOCATION_ID = "Location";
local OFFSET_X = 0.0022  --  0.0022;
local OFFSET_Y = -0.0262  --  -0.0262;
local cachedX = 0;
local cachedY = 0;
local updateTable = {TITAN_LOCATION_ID, TITAN_PANEL_UPDATE_BUTTON};
-- ******************************** Variables *******************************
local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true);
local AceTimer = LibStub("AceTimer-3.0");
local LocationTimer = nil;
-- ******************************** Functions *******************************

-- **************************************************************************
-- NAME : TitanPanelLocationButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelLocationButton_OnLoad(self)
	self.registry = {
		id = TITAN_LOCATION_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_LOCATION_MENU_TEXT"],
		buttonTextFunction = "TitanPanelLocationButton_GetButtonText",
		tooltipTitle = L["TITAN_LOCATION_TOOLTIP"],
		tooltipTextFunction = "TitanPanelLocationButton_GetTooltipText",
		icon = "Interface\\AddOns\\TitanClassicLocation\\TitanClassicLocation",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = false
		},
		savedVariables = {
			ShowZoneText = 1,
            ShowSubZoneText = 1,
			ShowCoordsOnMap = false,
			ShowCursorOnMap = false,
			ShowLocOnMiniMap = 1,
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
			CoordsFormat1 = 1,
			CoordsFormat2 = false,
			CoordsFormat3 = false,
			UpdateWorldmap = false,
			MapLocation = false,
		}
	};

	self:RegisterEvent("ZONE_CHANGED");
	self:RegisterEvent("ZONE_CHANGED_INDOORS");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");

	TitanPanelLocation_CreateMapFrames();
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_OnShow()
-- DESC : Display button when plugin is visible
-- **************************************************************************
function TitanPanelLocationButton_OnShow()
	local mapID = C_Map.GetBestMapForUnit("player");
	if mapID ~= nil and C_Map.MapHasArt(mapID) then
    	WorldMapFrame:SetMapID(mapID);
	end
	TitanPanelLocation_HandleUpdater();
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_OnHide()
-- DESC : Destroy repeating timer when plugin is hidden
-- **************************************************************************
function TitanPanelLocationButton_OnHide()
	AceTimer.CancelTimer("TitanPanelLocation", LocationTimer, true)
	LocationTimer = nil;
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_GetButtonText(id)
-- DESC : Calculate coordinates and then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelLocationButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);

	button.px, button.py = TitanPanelGetPlayerMapPosition();
	-- cache coordinates for update checking later on
	cachedX = button.px;
	cachedY = button.py;
	if button.px == nil then button.px = 0 end
	if button.py == nil then button.py = 0 end
	local locationText = "";
	if (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat1")) then
		locationText = format(L["TITAN_LOCATION_FORMAT"], 100 * button.px, 100 * button.py);
	elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat2")) then
		locationText = format(L["TITAN_LOCATION_FORMAT2"], 100 * button.px, 100 * button.py);
	elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat3")) then
		locationText = format(L["TITAN_LOCATION_FORMAT3"], 100 * button.px, 100 * button.py);
	end

	if button.px == 0 and button.py == 0 then
		locationText = "";
	end

	if (TitanGetVar(TITAN_LOCATION_ID, "ShowZoneText")) then
		if (TitanUtils_ToString(button.subZoneText) == '') then
			if (button.zoneText == '') then
				_, _, button.zoneText = C_Map.GetMapInfo(C_Map.GetBestMapUnit("player"));
			end
            locationText = TitanUtils_ToString(button.zoneText)..' '..locationText;
		else
			if (TitanGetVar(TITAN_LOCATION_ID, "ShowSubZoneText")) then
                locationText = TitanUtils_ToString(button.subZoneText)..' '..locationText;
            else
                locationText = TitanUtils_ToString(button.zoneText..' - '..button.subZoneText)..' '..locationText;
            end
		end
	else
		if button.px == 0 and button.py == 0 then
			locationText = L["TITAN_LOCATION_NO_COORDS"];
		end
	end

	local locationRichText;
	if (TitanGetVar(TITAN_LOCATION_ID, "ShowColoredText")) then
		if (TitanPanelLocationButton.isArena) then
			locationRichText = TitanUtils_GetRedText(locationText);
		elseif (TitanPanelLocationButton.pvpType == "friendly") then
			locationRichText = TitanUtils_GetGreenText(locationText);
		elseif (TitanPanelLocationButton.pvpType == "hostile") then
			locationRichText = TitanUtils_GetRedText(locationText);
		elseif (TitanPanelLocationButton.pvpType == "contested") then
			locationRichText = TitanUtils_GetNormalText(locationText);
		else
			locationRichText = TitanUtils_GetNormalText(locationText);
		end
	else
		locationRichText = TitanUtils_GetHighlightText(locationText);
	end

	return L["TITAN_LOCATION_BUTTON_LABEL"], locationRichText;
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
function TitanPanelLocationButton_GetTooltipText()
	local pvpInfoRichText;

	pvpInfoRichText = "";
	if (TitanPanelLocationButton.pvpType == "sanctuary") then
		pvpInfoRichText = TitanUtils_GetGreenText(SANCTUARY_TERRITORY);
	elseif (TitanPanelLocationButton.pvpType == "arena") then
		TitanPanelLocationButton.subZoneText = TitanUtils_GetRedText(TitanPanelLocationButton.subZoneText);
		pvpInfoRichText = TitanUtils_GetRedText(CONTESTED_TERRITORY);
		elseif (TitanPanelLocationButton.pvpType == "friendly") then
		pvpInfoRichText = TitanUtils_GetGreenText(format(FACTION_CONTROLLED_TERRITORY, TitanPanelLocationButton.factionName));
	elseif (TitanPanelLocationButton.pvpType == "hostile") then
		pvpInfoRichText = TitanUtils_GetRedText(format(FACTION_CONTROLLED_TERRITORY, TitanPanelLocationButton.factionName));
	elseif (TitanPanelLocationButton.pvpType == "contested") then
		pvpInfoRichText = TitanUtils_GetRedText(CONTESTED_TERRITORY);
	else
		--pvpInfoRichText = TitanUtils_GetNormalText(CONTESTED_TERRITORY);
	end

	return ""..
		L["TITAN_LOCATION_TOOLTIP_ZONE"].."\t"..TitanUtils_GetHighlightText(TitanPanelLocationButton.zoneText).."\n"..
		TitanUtils_Ternary((TitanPanelLocationButton.subZoneText == ""), "", L["TITAN_LOCATION_TOOLTIP_SUBZONE"].."\t"..TitanUtils_GetHighlightText(TitanPanelLocationButton.subZoneText).."\n")..
		TitanUtils_Ternary((pvpInfoRichText == ""), "", L["TITAN_LOCATION_TOOLTIP_PVPINFO"].."\t"..pvpInfoRichText.."\n")..
		"\n"..
		TitanUtils_GetHighlightText(L["TITAN_LOCATION_TOOLTIP_HOMELOCATION"]).."\n"..
		L["TITAN_LOCATION_TOOLTIP_INN"].."\t"..TitanUtils_GetHighlightText(GetBindLocation()).."\n"..
		TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_1"]).."\n"..
		TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_2"]);
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_OnEvent()
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
function TitanPanelLocationButton_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") and MinimapBorderTop and MinimapBorderTop:IsShown() then
			TitanPanelLocationButton_LocOnMiniMap()
		end
	end
	if TitanGetVar(TITAN_LOCATION_ID, "UpdateWorldmap") then
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID ~= nil and C_Map.MapHasArt(mapID) then
    		WorldMapFrame:SetMapID(mapID);
		end
	end
	TitanPanelLocationButton_UpdateZoneInfo(self);
	TitanPanelPluginHandle_OnUpdate(updateTable);
	TitanPanelLocation_HandleUpdater();
	if TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") and MinimapBorderTop:IsShown() then
		if not MinimapZoneTextButton:IsShown() then MinimapZoneTextButton:Show() end
		if not MiniMapWorldMapButton:IsShown() then MiniMapWorldMapButton:Show() end
	end
end

-- function to throttle down unnecessary updates
function TitanPanelLocationButton_CheckForUpdate()
	local mapID = C_Map.GetBestMapForUnit("player")
	local tempx, tempy = TitanPanelGetPlayerMapPosition();
	if tempx ~= cachedX or tempy ~= cachedY then
		TitanPanelPluginHandle_OnUpdate(updateTable);
	end
end

-- **************************************************************************
-- NAME : TitanPanelLocation_HandleUpdater()
-- DESC : Check to see if you are inside an instance
-- **************************************************************************
function TitanPanelLocation_HandleUpdater()
	if TitanPanelLocationButton:IsVisible() and not LocationTimer then
		LocationTimer = AceTimer.ScheduleRepeatingTimer("TitanPanelLocation", TitanPanelLocationButton_CheckForUpdate, 0.5)
	end
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_OnClick(button)
-- DESC : Copies coordinates to chat line for shift-LeftClick
-- VARS : button = value of action
-- **************************************************************************
function TitanPanelLocationButton_OnClick(self, button)
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			local activeWindow = ChatEdit_GetActiveWindow();
			if ( activeWindow ) then
				if (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat1")) then
					message = TitanUtils_ToString(self.zoneText).." "..
					format(L["TITAN_LOCATION_FORMAT"], 100 * self.px, 100 * self.py);
				elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat2")) then
					message = TitanUtils_ToString(self.zoneText).." "..
					format(L["TITAN_LOCATION_FORMAT2"], 100 * self.px, 100 * self.py);
				elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat3")) then
					message = TitanUtils_ToString(self.zoneText).." "..
					format(L["TITAN_LOCATION_FORMAT3"], 100 * self.px, 100 * self.py);
				end
				activeWindow:Insert(message);
			end
		else
			ToggleWorldMap();
		end
	end
--[[
-- Works great when map is small. When map is large, Titan stays on top.
-- Sometimes other buttons stay on top of map.
-- Think we'd have to adjust strata of anything touched by TitanMovable
	if (button == "LeftButton") then
		if ( WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE ) then
			if ( WorldMapFrame:IsVisible() ) then
				WorldMapFrame:Hide()
			else
				WorldMapFrame:Show()
			end
		end
	end
--]]
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_UpdateZoneInfo()
-- DESC : Update data on button
-- **************************************************************************
function TitanPanelLocationButton_UpdateZoneInfo(self)
	local _ = nil
	self.zoneText = GetZoneText();
	self.subZoneText = GetSubZoneText();
	--self.minimapZoneText = GetMinimapZoneText();
	self.pvpType, _, self.factionName = GetZonePVPInfo();
end

local function CoordLoc(loc)
	local res = (TitanGetVar(TITAN_LOCATION_ID, "MapLocation") == loc)
	return res
end
-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareLocationMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareLocationMenu()
	local info

	-- level 2
	if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_ZONE_ON_PANEL_TEXT"];
			info.func = TitanPanelLocationButton_ToggleDisplay;
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowZoneText");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_SUBZONE_ON_PANEL_TEXT"];
			info.func = TitanPanelLocationButton_ToggleSubZoneDisplay;
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowSubZoneText");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_COORDS_ON_MAP_TEXT"];
			info.func = TitanPanelLocationButton_ToggleLocationOnMap;
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_LOC_ON_MINIMAP_TEXT"];
			info.func = TitanPanelLocationButton_ToggleLocOnMiniMap;
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap");
			info.disabled = InCombatLockdown()
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_MENU_UPDATE_WORLD_MAP"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			info.disabled = InCombatLockdown()
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			TitanPanelRightClickMenu_AddSpacer(_G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			TitanPanelRightClickMenu_AddTitle(L["TITAN_LOCATION_MENU_MAP_COORDS_TITLE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_MENU_MAP_COORDS_LOC_1"]
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "MapLocation", "TOPLEFT")
			end
			info.checked = CoordLoc("TOPLEFT")
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_MENU_MAP_COORDS_LOC_2"]
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "MapLocation", "TOPRIGHT")
			end
			info.checked = CoordLoc("TOPRIGHT")
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_MENU_MAP_COORDS_LOC_3"]
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "MapLocation", "BOTTOMLEFT")
			end
			info.checked = CoordLoc("BOTTOMLEFT")
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_MENU_MAP_COORDS_LOC_4"]
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "MapLocation", "BOTTOM")
			end
			info.checked = CoordLoc("BOTTOM")
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_MENU_MAP_COORDS_LOC_5"]
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "MapLocation", "BOTTOMRIGHT")
			end
			info.checked = CoordLoc("BOTTOMRIGHT")
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

		end
		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "CoordFormat" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_LOCATION_FORMAT_COORD_LABEL"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {};
			info.text = L["TITAN_LOCATION_FORMAT_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat1", 1);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat2", nil);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat3", nil);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat1");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_FORMAT2_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat1", nil);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat2", 1);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat3", nil);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat2");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_LOCATION_FORMAT3_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat1", nil);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat2", nil);
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat3", 1);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat3");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end
		return
	end

	-- level 1
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_LOCATION_ID].menuText);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_OPTIONS"];
	info.value = "Options"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_LOCATION_FORMAT_COORD_LABEL"];
	info.value = "CoordFormat"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_LOCATION_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_LOCATION_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_LOCATION_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_LOCATION_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_ToggleDisplay()
-- DESC : Set option to show zone text
-- **************************************************************************
function TitanPanelLocationButton_ToggleDisplay()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowZoneText");
	TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_ToggleSubZoneDisplay()
-- DESC : Set option to show only subzone text
-- **************************************************************************
function TitanPanelLocationButton_ToggleSubZoneDisplay()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowSubZoneText");
	TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_ToggleLocationOnMap()
-- DESC : Set option to show player coordinates on map
-- **************************************************************************
function TitanPanelLocationButton_ToggleLocationOnMap()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowCoordsOnMap");
	if (TitanMapPlayerLocation~=nil) then
		if (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap")) then
			TitanMapPlayerLocation:Show();
		else
			TitanMapPlayerLocation:Hide();
		end
	end
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_ToggleCursorLocationOnMap()
-- DESC : Set option to show cursor coordinates on map
-- **************************************************************************
function TitanPanelLocationButton_ToggleCursorLocationOnMap()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowCursorOnMap");
	if (TitanGetVar(TITAN_LOCATION_ID, "ShowCursorOnMap")) then
		TitanMapCursorLocation:Show();
	else
		TitanMapCursorLocation:Hide();
	end
end

function TitanPanelLocationButton_ToggleLocOnMiniMap()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap");
	TitanPanelLocationButton_LocOnMiniMap()
end

function TitanPanelLocationButton_LocOnMiniMap()
	if TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") then
		MinimapBorderTop:Show()
		MinimapZoneTextButton:Show()
		MiniMapWorldMapButton:Show()
	else
		MinimapBorderTop:Hide()
		MinimapZoneTextButton:Hide()
		MiniMapWorldMapButton:Hide()
	end
	-- adjust MiniMap frame if needed
	TitanPanel_AdjustFrames(false);
end

-- **************************************************************************
-- NAME : TitanPanelLocationButton_ToggleColor()
-- DESC : Set option to show colored text
-- **************************************************************************
function TitanPanelLocationButton_ToggleColor()
	TitanToggleVar(TITAN_LOCATION_ID, "ShowColoredText");
	TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
end

-- **************************************************************************
-- NAME : TitanMapFrame_OnUpdate()
-- DESC : Update coordinates on map
-- **************************************************************************
function TitanMapFrame_OnUpdate(self, elapsed)
	-- using :Hide / :Show prevents coords from running
	-- TitanMapFrame:Hide() -- hide parent

	-- Determine the text to show for player coords

		self.px, self.py = TitanPanelGetPlayerMapPosition();
		if self.px == nil then self.px = 0 end
		if self.py == nil then self.py = 0 end
		if self.px == 0 and self.py == 0 then
			playerLocationText = L["TITAN_LOCATION_NO_COORDS"]
		else
			if (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat1")) then
				playerLocationText = format(L["TITAN_LOCATION_FORMAT"], 100 * self.px, 100 * self.py);
			elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat2")) then
				playerLocationText = format(L["TITAN_LOCATION_FORMAT2"], 100 * self.px, 100 * self.py);
			elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat3")) then
				playerLocationText = format(L["TITAN_LOCATION_FORMAT3"], 100 * self.px, 100 * self.py);
			end
		end
		TitanMapPlayerLocation:SetText(format(L["TITAN_LOCATION_MAP_PLAYER_COORDS_TEXT"], TitanUtils_GetHighlightText(playerLocationText)));

	-- Determine the text to show for cursor coords

		-- calc cursor position on the map
		local cursorLocationText, playerLocationText;
		local x, y = GetCursorPosition();
		--[[if WorldMapFrame:IsMaximized() then
			x, y = WorldMapFrame:GetNormalizedCursorPosition();
		else
			x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition();
		end]]
		x = x / WorldMapFrame:GetEffectiveScale();
		y = y / WorldMapFrame:GetEffectiveScale();

		local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter();
		local width = WorldMapFrame.ScrollContainer:GetWidth();
		local height = WorldMapFrame.ScrollContainer:GetHeight();
		local cx = ((x - (centerX - (width/2))) / width) -- OFFSET_X
		local cy = ((centerY + (height/2) - y ) / height) --  OFFSET_Y
		-- cut off if the cursor coords are beyond the map, show 0,0
		if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
			cx = 0
			cy = 0
		end
		-- per the user requested format
		if (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat1")) then
			cursorLocationText = format(L["TITAN_LOCATION_FORMAT"], 100 * cx, 100 * cy);
		elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat2")) then
			cursorLocationText = format(L["TITAN_LOCATION_FORMAT2"], 100 * cx, 100 * cy);
		elseif (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat3")) then
			cursorLocationText = format(L["TITAN_LOCATION_FORMAT3"], 100 * cx, 100 * cy);
		end
		if (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap")) then
			TitanMapCursorLocation:SetText(format(L["TITAN_LOCATION_MAP_CURSOR_COORDS_TEXT"],
				TitanUtils_GetHighlightText(cursorLocationText)));
		else
			TitanMapPlayerLocation:SetText("");
			TitanMapCursorLocation:SetText("");
		end

	-- Determine where to show the text

	-- *
	TitanMapPlayerLocation:ClearAllPoints()
	TitanMapCursorLocation:ClearAllPoints()

	local xbuff = 10 -- to get away from the frame border
	local buff  = 5  -- between the player and cursor frames
	local mloc = TitanGetVar(TITAN_LOCATION_ID, "MapLocation") or "TOPRIGHT"

	if (mloc == "TOPRIGHT") then
		TitanMapPlayerLocation:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", -10, -28)
		TitanMapCursorLocation:SetPoint("TOPRIGHT", TitanMapPlayerLocation, "BOTTOMRIGHT", 0, 0)
	elseif (mloc == "TOPLEFT") then
		TitanMapPlayerLocation:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 10, -28)
		TitanMapCursorLocation:SetPoint("TOPLEFT", TitanMapPlayerLocation, "BOTTOMLEFT", 0, 0)
	elseif (mloc == "BOTTOMLEFT") then
		TitanMapPlayerLocation:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 10, 10)
		TitanMapCursorLocation:SetPoint("BOTTOMLEFT", TitanMapPlayerLocation, "BOTTOMRIGHT", buff, 0)
	elseif (mloc == "BOTTOMRIGHT") then
		TitanMapPlayerLocation:SetPoint("BOTTOMRIGHT", TitanMapCursorLocation, "BOTTOMLEFT", -buff, 0)
		TitanMapCursorLocation:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -xbuff, 10)
	elseif (mloc == "BOTTOM") then
		TitanMapPlayerLocation:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOM", -buff, 10)
		TitanMapCursorLocation:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOM", 0, 10)
	end
end

-- **************************************************************************
-- NAME : TitanPanelGetPlayerMapPosition()
-- DESC : Get the player coordinates
-- VARS : x = location on x axis, y = location on y axis
-- **************************************************************************
function TitanPanelGetPlayerMapPosition()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID == nil then
        return nil, nil
    end

    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if position == nil then
        return nil, nil
    else
    	return position:GetXY()
	end
end


-- **************************************************************************
-- NAME : TitanPanelLocation_CreateMapFrames()
-- DESC : Delays creating frames until the WorldMapFrame is ready
-- VARS : none
-- **************************************************************************
local TPL_CMF_IsFirstTime = true;
function TitanPanelLocation_CreateMapFrames()
	WorldMapFrame:HookScript("OnShow", function(self)
		if (TPL_CMF_IsFirstTime and not _G["CT_MapMod"]) then
			TPL_CMF_IsFirstTime = false;
			local frame = CreateFrame("FRAME", "TitanMapFrame", WorldMapFrame.BorderFrame)
			local playertext = frame:CreateFontString("TitanMapPlayerLocation", "ARTWORK", "GameFontNormal");
			playertext:SetPoint("TOPRIGHT",WorldMapFrame,"TOPRIGHT",0,0);
			local cursortext = frame:CreateFontString("TitanMapCursorLocation", "ARTWORK", "GameFontNormal");
			cursortext:SetPoint("TOPRIGHT",WorldMapFrame,"TOPRIGHT",0,0);
			frame:HookScript("OnUpdate",TitanMapFrame_OnUpdate);
		end
	end);

end
