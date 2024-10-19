---@diagnostic disable: duplicate-set-field
--[[
-- **************************************************************************
-- * TitanLocation.lua
-- *
-- * 2023 Dec : Merged with Classic versions. Classic map does not include
-- * the quest log so the placement of coord on the map, if selected, is a
-- * bit more work.
-- *
-- * By: The Titan Panel Development Team
-- **************************************************************************
--]]
-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_LOCATION_ID = "Location";
local TITAN_BUTTON = "TitanPanel"..TITAN_LOCATION_ID.."Button"
local TITAN_MAP_FRAME = "TitanMapFrame"
local TITAN_LOCATION_VERSION = TITAN_VERSION;

local addon_conflict = false -- used for addon conflicts
local cachedX = 0;
local cachedY = 0;
local updateTable = {TITAN_LOCATION_ID, TITAN_PANEL_UPDATE_BUTTON};
-- ******************************** Variables *******************************
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local LocationTimer = {};
local LocationTimerRunning = false

local debug_flow = false

---@diagnostic disable-next-line: deprecated
local GetZonePVP = C_PvP.GetZonePVPInfo or GetZonePVPInfo -- For Classic versions

-- ******************************** Functions *******************************
--[[ local
-- **************************************************************************
-- NAME : debug_msg(Message)
-- DESC : Debug function to print message to chat frame
-- VARS : Message = message to print to chat frame
-- **************************************************************************
--]]
local function debug_msg(Message)
	local msg = ""
	local stamp = date("%H:%M:%S") -- date("%m/%d/%y %H:%M:%S")
	local milli = GetTime() -- seconds with millisecond precision (float)
	local milli_str = string.format("%0.2F", milli - math.modf(milli))
	msg = msg..TitanUtils_GetGoldText(stamp..milli_str.." "..TITAN_LOCATION_ID..": ")
	msg = msg..TitanUtils_GetGreenText(Message)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
--		DEFAULT_CHAT_FRAME:AddMessage(TITAN_LOCATION_ID..": " .. Message, 1.00, 0.49, 0.04)
end

--[[ local
-- **************************************************************************
-- NAME : RegEvent()
-- DESC : Check if already registered, register if not
-- **************************************************************************
--]]
local function RegEvent(plugin, event)
	if plugin:IsEventRegistered(event) then
		-- already registered
	else
		plugin:RegisterEvent(event)
	end
end

--[[ local
-- **************************************************************************
-- NAME : Events()
-- DESC : Registers / unregisters events the plugin needs
-- **************************************************************************
--]]
local function Events(action, reason)
--[[
--]]
	local plugin = _G[TITAN_BUTTON]

	if action == "register" then
		RegEvent(plugin, "ZONE_CHANGED")
		RegEvent(plugin, "ZONE_CHANGED_INDOORS")
		RegEvent(plugin, "ZONE_CHANGED_NEW_AREA")
	elseif action == "unregister" then
		plugin:UnregisterEvent("ZONE_CHANGED")
		plugin:UnregisterEvent("ZONE_CHANGED_INDOORS")
		plugin:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		-- action unknown ???
	end

	if debug_flow then
		local msg =
			"Events"
			.." "..tostring(action)..""
			.." "..tostring(reason)..""
		debug_msg(msg)
	else
		-- not requested
	end
end

--[[ local
-- **************************************************************************
-- NAME : GetPlayerMapPosition()
-- DESC : Get the player coordinates
-- VARS : x = location on x axis, y = location on y axis
-- **************************************************************************
--]]
local function GetPlayerMapPosition()
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

--[[
-- **************************************************************************
-- NAME : CheckForPositionUpdate()
-- DESC : Function to throttle down unnecessary updates
-- **************************************************************************
--]]
local function CheckForPositionUpdate()
	local mapID = C_Map.GetBestMapForUnit("player")
	local tempx, tempy = GetPlayerMapPosition();
	if tempx ~= cachedX or tempy ~= cachedY then
		TitanPanelPluginHandle_OnUpdate(updateTable);
	end
end

local function ZoneUpdate(self)

--[==[
print("TLoc ZoneUpdate"
.." c "..tostring(self).." "
.." p "..tostring(self:GetName()).." "
)
--]==]
	local _ = nil
	self.zoneText = GetZoneText();
	self.subZoneText = GetSubZoneText();
	self.pvpType, _, self.factionName = GetZonePVP();

	TitanPanelPluginHandle_OnUpdate(updateTable);
end

local function SetCoordText(player, cursor)
	local playerLocationText = player or ""
	local cursorLocationText = cursor or ""

	TitanMapPlayerLocation:SetText(cursorLocationText);
	TitanMapCursorLocation:SetText(playerLocationText);

--		local mloc = TitanGetVar(TITAN_LOCATION_ID, "MapLocation") or "TOPRIGHT"
	if TITAN_ID == "TitanClassic" then
		-- Determine where to show the text
		TitanMapPlayerLocation:ClearAllPoints()
		TitanMapCursorLocation:ClearAllPoints()

		TitanMapPlayerLocation:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOM", 0, 10)
		TitanMapCursorLocation:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOM", -10, 10)
	else -- current retail
		-- Position the text
		local anchor = WorldMapFrame.BorderFrame.MaximizeMinimizeFrame
		if WorldMapFrame:IsMaximized() then
			-- map should be 'full' screen
			TitanMapPlayerLocation:ClearAllPoints();
			TitanMapCursorLocation:ClearAllPoints();
			TitanMapPlayerLocation:SetPoint("RIGHT", anchor, "LEFT", 0, 0)
			TitanMapCursorLocation:SetPoint("TOP", TitanMapPlayerLocation, "BOTTOM", 0, -5)
			WorldMapFrame.TitanSize = "large"
		else
			TitanMapPlayerLocation:ClearAllPoints();
			TitanMapCursorLocation:ClearAllPoints();
			TitanMapPlayerLocation:SetPoint("RIGHT", anchor, "LEFT", 0, 0)
			TitanMapCursorLocation:SetPoint("LEFT", WorldMapFrame.BorderFrame.Tutorial, "RIGHT", 0, 0)
			WorldMapFrame.TitanSize = "small"
		end
	end
end

--[[
-- **************************************************************************
-- NAME : LocOnMiniMap()
-- DESC : Show / hide the location above the mini map per user settings
-- **************************************************************************
--]]
local function LocOnMiniMap(reason)
	if TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") then
		MinimapBorderTop:Show()
		MinimapZoneTextButton:Show()
--		MiniMapWorldMapButton:Show()
	else
		MinimapBorderTop:Hide()
		MinimapZoneTextButton:Hide()
		MiniMapWorldMapButton:Hide()
	end

	-- adjust MiniMap frame if needed
	if reason == "config" then
		TitanPanel_AdjustFrames(false, "Location");
	else
		-- 2024 Jan - Do not adjust; allow Titan to handle on PEW
	end
end

--[[
-- **************************************************************************
-- NAME : TitanMapFrame_OnUpdate()
-- DESC : Update coordinates on map
-- **************************************************************************
--]]
local function TitanMapFrame_OnUpdate(self, elapsed)
	-- Determine the text to show for player coords

	local cursorLocationText = ""
	local playerLocationText = ""

	if debug_flow then
		cursorLocationText = "-C-"
		playerLocationText = "-P-"
	else
		-- use default
	end

	if (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap")) then
		self.px, self.py = GetPlayerMapPosition();
		if self.px == nil then self.px = 0 end
		if self.py == nil then self.py = 0 end
		if self.px == 0 and self.py == 0 then
			playerLocationText = L["TITAN_LOCATION_NO_COORDS"]
		else
			playerLocationText = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * self.px, 100 * self.py);
		end
		playerLocationText = (format(L["TITAN_LOCATION_MAP_PLAYER_COORDS_TEXT"], TitanUtils_GetHighlightText(playerLocationText)));

		-- Determine the text to show for cursor coords
		local cx, cy = GetCursorPosition();

		-- use the global cursor position to confirm the cursor is over the map, but then use a normalized cursor position to account for map zooming
		local left, bottom, width, height = WorldMapFrame.ScrollContainer:GetScaledRect();
		if (cx > left and cy > bottom and cx < left + width and cy < bottom+ height) then
			cx, cy = WorldMapFrame:GetNormalizedCursorPosition();
			cx, cy = cx or 0, cy or 0;
		else
			cx, cy = 0, 0
		end

		-- per the user requested format
		cursorLocationText = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * cx, 100 * cy)
		cursorLocationText = (format(L["TITAN_LOCATION_MAP_CURSOR_COORDS_TEXT"],
			TitanUtils_GetHighlightText(cursorLocationText)))
	else
		-- use defaults, saving a few cpu cycles
	end
--[==[
print("TLoc"
.." c "..tostring(cursorLocationText).." "
.." p "..tostring(playerLocationText).." "
)
--]==]
	SetCoordText(playerLocationText, cursorLocationText)

end

--[[
-- Set the coordinates text for player and cursor
-- Used on update to refresh and on hide to clear the text
--]]
local function CoordFrames(action)

	local show_on_map = (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap") and true or false)
	if addon_conflict then
		-- do not attempt coords
	else
		local frame = _G[TITAN_MAP_FRAME]
		if show_on_map then
			if action == "start" then
				local function updateFunc()
					TitanMapFrame_OnUpdate(frame, 0.07);	-- simulating an OnUpdate call
				end
				frame:SetScript("OnShow", function()
					frame.updateTicker = frame.updateTicker or C_Timer.NewTicker(0.07, updateFunc);
					if WorldMapFrame:IsMaximized() then
						WorldMapFrame.TitanSize = "large"
						WorldMapFrame.TitanSizePrev = "none"
					else
						WorldMapFrame.TitanSize = "small"
						WorldMapFrame.TitanSizePrev = "none"
					end
				end);
				frame:SetScript("OnHide", function()
					if (frame.updateTicker) then
						frame.updateTicker:Cancel();
						frame.updateTicker = nil;
					end
				end);
			elseif action == "stop" then
				-- stop timer, hooks are not needed
				frame:SetScript("OnShow", nil)
				frame:SetScript("OnHide", nil)
				SetCoordText("", "") -- cleanup
			else
				-- action unknown ???
			end
		else
			-- user did not request so save a few cycles
		end
	end

	if debug_flow then
		local msg =
			"CoordFrames"
			.." "..tostring(action)..""
			.." "..tostring(show_on_map)..""
			.." "..tostring(addon_conflict)..""
		debug_msg(msg)
	else
		-- not requested
	end
end

--[[
-- **************************************************************************
-- NAME : CreateMapFrames()
-- DESC : Adds player and cursor coords to the WorldMapFrame, unless the player has CT_MapMod
-- VARS : none
-- **************************************************************************
--]]
local function CreateMapFrames()
	if _G[TITAN_MAP_FRAME] then
		return -- if already created
	end

	-- avoid an addon conflict
	if (_G["CT_MapMod"]) then
		addon_conflict = true
		return;
	end

	if debug_flow then
		local msg =
			"CreateMapFrames"
--			.." "..tostring(reason)..""
		debug_msg(msg)
	else
		-- not requested
	end

	-- create the frame to hold the font strings, and simulate an "OnUpdate" script handler using C_Timer for efficiency
	local frame = CreateFrame("FRAME", TITAN_MAP_FRAME, WorldMapFrame)
	frame:SetFrameStrata("DIALOG") -- DF need to raise the strata to be seen

	-- create the font strings and update their position based in minimizing/maximizing the main map
	local playertext = frame:CreateFontString("TitanMapPlayerLocation", "ARTWORK", "GameFontNormal");
	local cursortext = frame:CreateFontString("TitanMapCursorLocation", "ARTWORK", "GameFontNormal");
	playertext:ClearAllPoints();
	cursortext:ClearAllPoints();
	playertext:SetPoint("TOPRIGHT", WorldMapFrameCloseButton, "BOTTOMRIGHT", 0, 0)
	cursortext:SetPoint("TOP", playertext, "BOTTOM", 0, 0)
end

--[[
-- **************************************************************************
-- NAME : OnShow()
-- DESC : Display button when plugin is visible
-- **************************************************************************
--]]
local function OnShow(self)

	if debug_flow then
		local msg =
			"_OnShow"
--			.." "..tostring(reason)..""
		debug_msg(msg)
	else
		-- not requested
	end

	if LocationTimerRunning then
		-- Do not schedule a new one
	else
		LocationTimer = AceTimer:ScheduleRepeatingTimer(CheckForPositionUpdate, 0.5)
	end

	CreateMapFrames() -- as needed
	CoordFrames("start") -- start coords on map, if requested

	Events("register", "_OnShow")

	-- Zone may not be available yet, PEW event should correct
	ZoneUpdate(self);

	TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
end

--[[
-- **************************************************************************
-- NAME : OnHide()
-- DESC : Destroy repeating timer when plugin is hidden
-- **************************************************************************
--]]
local function OnHide(self)
	AceTimer:CancelTimer(LocationTimer)
	LocationTimerRunning = false

	Events("unregister", "_OnHide")
	CoordFrames("stop") -- stop coords on map, if requested
end

--[[
-- **************************************************************************
-- NAME : GetButtonText(id)
-- DESC : Calculate coordinates and then display data on button
-- VARS : id = button ID
-- **************************************************************************
--]]
local function GetButtonText(id)
	local button, id = TitanUtils_GetButton(id);
	local locationText = ""

	-- Coordinates text, if requested
	if button and TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsText") then
		button.px, button.py = GetPlayerMapPosition();
		cachedX = button.px;
		cachedY = button.py;
		if button.px == nil then button.px = 0 end
		if button.py == nil then button.py = 0 end

		if button.px == 0 and button.py == 0 then
			locationText = "";
		else
		locationText = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * button.px, 100 * button.py)
		end
	else
		locationText = "";
	end

	-- Zone text, if requested
	if button and TitanGetVar(TITAN_LOCATION_ID, "ShowZoneText") then
		if (TitanUtils_ToString(button.subZoneText) == '') then
			if (button.zoneText == '') then
				local Map_unit = C_Map.GetBestMapForUnit -- DF change of API
								or C_Map.GetBestMapUnit
				local _
				_, _, button.zoneText = C_Map.GetMapInfo(Map_unit("player"));
			end
			locationText = TitanUtils_ToString(button.zoneText)..' '..locationText;
		else
			locationText = TitanUtils_ToString(button.subZoneText)..' '..locationText;
		end
	else
		if button and button.px == 0 and button.py == 0 then
			locationText = L["TITAN_LOCATION_NO_COORDS"];
		end
	end

	-- Color per type of zone (friendly, contested, hostile)
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

--[[
-- **************************************************************************
-- NAME : GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
--]]
local function GetTooltipText()
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
		pvpInfoRichText = ""
	end

	-- build the tool tip
	local zone = TitanUtils_GetHighlightText(TitanPanelLocationButton.zoneText) or ""
	local sub_zone = TitanUtils_Ternary(
			(TitanPanelLocationButton.subZoneText == ""),
			"",
			L["TITAN_LOCATION_TOOLTIP_SUBZONE"].."\t"..TitanUtils_GetHighlightText(TitanPanelLocationButton.subZoneText).."\n"
			)
	local bind_loc = TitanUtils_GetHighlightText(GetBindLocation())

	return ""..
		L["TITAN_LOCATION_TOOLTIP_ZONE"].."\t"..zone.."\n"
		..sub_zone.."\n"
		..TitanUtils_GetHighlightText(L["TITAN_LOCATION_TOOLTIP_HOMELOCATION"]).."\n"
		..L["TITAN_LOCATION_TOOLTIP_INN"].."\t"..bind_loc.."\n"
		..TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_1"]).."\n"
		..TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_2"])
end

--[[
-- **************************************************************************
-- NAME : OnEvent()
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
--]]
local function OnEvent(self, event, ...)
-- DF TODO See if we can turn off zone on minimap
--[=[
--]=]
	if debug_flow then
		local msg =
			"_OnEvent"
			.." "..tostring(event)..""
		debug_msg(msg)
	else
		-- not requested
	end

	if TITAN_ID == "TitanClassic" then
		if event == "PLAYER_ENTERING_WORLD" then
			if not TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap")
				and MinimapBorderTop and MinimapBorderTop:IsShown() then
				LocOnMiniMap("PEW")
			end
		end

		if TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") and MinimapBorderTop:IsShown() then
			if not MinimapZoneTextButton:IsShown() then MinimapZoneTextButton:Show() end
		end
	else
		-- no work needed
	end

	ZoneUpdate(self);
--[[
--]]
end

--[[
-- **************************************************************************
-- NAME : OnClick(button)
-- DESC : Copies coordinates to chat line for shift-LeftClick
-- VARS : button = value of action
-- **************************************************************************
--]]
local function OnClick(self, button)
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			local activeWindow = ChatEdit_GetActiveWindow();
			if ( activeWindow ) then
				local message = TitanUtils_ToString(self.zoneText).." "..
					format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * self.px, 100 * self.py);
				activeWindow:Insert(message);
			end
		else
			ToggleFrame(WorldMapFrame);
		end
	end
end

local function CreateMenu()
	local info

	-- level 2
	if TitanPanelRightClickMenu_GetDropdownLevel() == 2 then
		if TitanPanelRightClickMenu_GetDropdMenuValue() == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], TitanPanelRightClickMenu_GetDropdownLevel());
			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_ZONE_ON_PANEL_TEXT"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "ShowZoneText");
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowZoneText");
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			if TITAN_ID == "TitanClassic" then
				info = {};
				info.text = L["TITAN_LOCATION_MENU_SHOW_SUBZONE_ON_PANEL_TEXT"];
				info.func = function()
					TitanToggleVar(TITAN_LOCATION_ID, "ShowSubZoneText");
					TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
				end
				info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowSubZoneText");
				TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			else
				-- no work needed
			end

			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_COORDS_ON_PANEL_TEXT"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "ShowCoordsText");
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsText");
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_COORDS_ON_MAP_TEXT"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "ShowCoordsOnMap");
				if (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap")) then
					CoordFrames("start")
				else
					CoordFrames("stop")
				end
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap");
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			if TITAN_ID == "TitanClassic" then
			info = {};
			info.text = L["TITAN_LOCATION_MENU_SHOW_LOC_ON_MINIMAP_TEXT"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap");
				LocOnMiniMap("config")
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap");
			info.disabled = InCombatLockdown()
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			else
				-- no work needed
			end
			info = {};
			info.text = L["TITAN_LOCATION_MENU_UPDATE_WORLD_MAP"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			info.disabled = InCombatLockdown()
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

		end

		if TitanPanelRightClickMenu_GetDropdMenuValue() == "CoordFormat" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_LOCATION_FORMAT_COORD_LABEL"], TitanPanelRightClickMenu_GetDropdownLevel());
			info = {};
			info.text = L["TITAN_LOCATION_FORMAT_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat", L["TITAN_LOCATION_FORMAT"]);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat") == L["TITAN_LOCATION_FORMAT"])
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			info = {};
			info.text = L["TITAN_LOCATION_FORMAT2_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat", L["TITAN_LOCATION_FORMAT2"]);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat") == L["TITAN_LOCATION_FORMAT2"])
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			info = {};
			info.text = L["TITAN_LOCATION_FORMAT3_LABEL"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsFormat", L["TITAN_LOCATION_FORMAT3"]);
				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = (TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat") == L["TITAN_LOCATION_FORMAT3"])
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
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
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_LOCATION_FORMAT_COORD_LABEL"];
	info.value = "CoordFormat"
	info.hasArrow = 1;
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	TitanPanelRightClickMenu_AddControlVars(TITAN_LOCATION_ID)
end

--[[
-- **************************************************************************
-- NAME : OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
--]]
local function OnLoad(self)
	local notes = ""
		.."Adds coordinates and location information to Titan Panel.\n"
--		.."- xxx.\n"
	self.registry = {
		id = TITAN_LOCATION_ID,
		category = "Built-ins",
		version = TITAN_LOCATION_VERSION,
		menuText = L["TITAN_LOCATION_MENU_TEXT"],
		menuTextFunction = CreateMenu,
		buttonTextFunction = GetButtonText,
		tooltipTitle = L["TITAN_LOCATION_TOOLTIP"],
		tooltipTextFunction = GetTooltipText,
		icon = "Interface\\AddOns\\TitanLocation\\TitanLocation",
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
			ShowZoneText = 1,
            ShowSubZoneText = true,
			ShowCoordsText = true,
			ShowCoordsOnMap = false,
			ShowCursorOnMap = false,
			ShowLocOnMiniMap = 1,
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
			CoordsFormat = L["TITAN_LOCATION_FORMAT"],
			UpdateWorldmap = false,
			MapLocation = "TOPRIGHT",
			DisplayOnRightSide = false,
		}
	};

	RegEvent(self, "PLAYER_ENTERING_WORLD")

	if debug_flow then
		local msg =
			"_OnLoad"
--			.." "..tostring(reason)..""
		debug_msg(msg)
	else
		-- not requested
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
		OnShow(self);
		TitanPanelButton_OnShow(self);
	end)
	window:SetScript("OnHide", function(self)
		OnHide(self)
	end)
	window:SetScript("OnEvent", function(self, event, ...)
		OnEvent(self, event, ...)
	end)
	window:SetScript("OnClick", function(self, button)
		OnClick(self, button);
		TitanPanelButton_OnClick(self, button);
	end)
end


Create_Frames()
