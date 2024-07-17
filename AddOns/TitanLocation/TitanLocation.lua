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
local TITAN_BUTTON = "TitanPanel" .. TITAN_LOCATION_ID .. "Button"
local TITAN_MAP_FRAME = "TitanMapFrame"
local TITAN_LOCATION_VERSION = TITAN_VERSION;

local addon_conflict = false -- used for addon conflicts
local updateTable = { TITAN_LOCATION_ID, TITAN_PANEL_UPDATE_BUTTON };
-- ******************************** Variables *******************************
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local LocationTimer = {};
local LocationTimerRunning = false

local debug_flow = false

local place = {
	zoneText = "",
	subZoneText = "",
	pvpType = "",
	factionName = "",
	px = 0,
	py = 0,
	}

---@diagnostic disable-next-line: deprecated
local GetZonePVP = C_PvP.GetZonePVPInfo or GetZonePVPInfo -- For Classic versions

-- ******************************** Functions *******************************

local function debug_msg(Message)
	local msg = ""
	local stamp = date("%H:%M:%S") -- date("%m/%d/%y %H:%M:%S")
	local milli = GetTime()     -- seconds with millisecond precision (float)
	local milli_str = string.format("%0.2F", milli - math.modf(milli))
	msg = msg .. TitanUtils_GetGoldText(stamp .. milli_str .. " " .. TITAN_LOCATION_ID .. ": ")
	msg = msg .. TitanUtils_GetGreenText(Message)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
	--		DEFAULT_CHAT_FRAME:AddMessage(TITAN_LOCATION_ID..": " .. Message, 1.00, 0.49, 0.04)
end

---local Register event if not already registered
---@param plugin Button
---@param event string
local function RegEvent(plugin, event)
	if plugin:IsEventRegistered(event) then
		-- already registered
	else
		plugin:RegisterEvent(event)
	end
end

---local Registers / unregisters (action) events the plugin needs
---@param action string
---@param reason string
local function Events(action, reason)
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
			.. " " .. tostring(action) .. ""
			.. " " .. tostring(reason) .. ""
		debug_msg(msg)
	else
		-- not requested
	end
end

---local Get the player coordinates on x,y axis
---@return number | nil X
---@return number | nil Y
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

---local Function to throttle down unnecessary updates
local function CheckForPositionUpdate()
	local mapID = C_Map.GetBestMapForUnit("player")
	local tempx, tempy = GetPlayerMapPosition()

	-- If unknown then use 0,0
	if tempx == nil then
		place.px = 0
		tempx = 0
	end
	if tempy == nil then
		place.py = 0
		tempy = 0
	end

	-- If the same then do not update the text to save a few cycles.
	if tempx ~= place.px or tempy ~= place.py then
		place.px = tempx
		place.py = tempy
		TitanPanelPluginHandle_OnUpdate(updateTable);
	end
end

---local Update zone info of current toon
---@param self Button
local function ZoneUpdate(self)
	local _ = nil
	place.zoneText = GetZoneText();
	place.subZoneText = GetSubZoneText();
	place.pvpType, _, place.factionName = GetZonePVP();

	TitanPanelPluginHandle_OnUpdate(updateTable);
end

---local Set textg coord on map per user selection
---@param player string
---@param cursor string
local function SetCoordText(player, cursor)
	local player_frame = TitanMapPlayerLocation
	local cursor_frame = TitanMapCursorLocation
	local world_frame = WorldMapFrame

	player_frame:SetText(player or "");
	cursor_frame:SetText(cursor or "");

	if TITAN_ID == "TitanClassic" then
		-- Determine where to show the text
		player_frame:ClearAllPoints()
		cursor_frame:ClearAllPoints()

		local mloc = TitanGetVar(TITAN_LOCATION_ID, "CoordsLoc")
		if mloc == "Top" then
			if WorldMapFrame:IsMaximized() then
				TitanMapPlayerLocation:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame, "TOPLEFT", 10, -5)
			else
				TitanMapPlayerLocation:SetPoint("TOPLEFT", WorldMapFrame.MiniBorderFrame, "TOPLEFT", 20, -33)
			end
			TitanMapCursorLocation:SetPoint("RIGHT", WorldMapFrame.MaximizeMinimizeFrame, "LEFT", 0, 0)
		elseif mloc == "Bottom" then
			player_frame:SetPoint("BOTTOMRIGHT", world_frame, "BOTTOM", -10, 10)
			cursor_frame:SetPoint("BOTTOMLEFT", world_frame, "BOTTOM", 0, 10)
		else
			-- Correct to the default of bottom
			TitanSetVar(TITAN_LOCATION_ID, "CoordsLoc", "Bottom")
			player_frame:SetPoint("BOTTOMRIGHT", world_frame, "BOTTOM", -10, 10)
			cursor_frame:SetPoint("BOTTOMLEFT", world_frame, "BOTTOM", 0, 10)
		end
	else -- current retail
		-- Position the text
		local anchor = world_frame.BorderFrame.MaximizeMinimizeFrame
		if world_frame:IsMaximized() then
			-- map should be 'full' screen
			player_frame:ClearAllPoints();
			cursor_frame:ClearAllPoints();
			player_frame:SetPoint("RIGHT", anchor, "LEFT", 0, 0)
			cursor_frame:SetPoint("TOP", player_frame, "BOTTOM", 0, -5)
			world_frame.TitanSize = "large"
		else
			player_frame:ClearAllPoints();
			cursor_frame:ClearAllPoints();
			player_frame:SetPoint("RIGHT", anchor, "LEFT", 0, 0)
			cursor_frame:SetPoint("LEFT", world_frame.BorderFrame.Tutorial, "RIGHT", 0, 0)
			world_frame.TitanSize = "small"
		end
	end
end

---local Show / hide the location above the mini map per user settings
---@param reason string
local function LocOnMiniMap(reason)
	if TitanGetVar(TITAN_LOCATION_ID, "ShowLocOnMiniMap") then
		MinimapBorderTop:Show()
		MinimapZoneTextButton:Show()
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

---local Update coordinates on map
---@param self Button
---@param elapsed number
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

	local player_format = ""
	local cursor_format = ""
	local label = TitanGetVar(TITAN_LOCATION_ID, "CoordsLabel")
	if label then
		player_format = L["TITAN_LOCATION_MAP_PLAYER_COORDS_TEXT"]
		cursor_format = L["TITAN_LOCATION_MAP_CURSOR_COORDS_TEXT"]
	else
		player_format = "%s"
		cursor_format = "%s"
	end

	if (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap")) then
		place.px, place.py = GetPlayerMapPosition();
		if place.px == nil then place.px = 0 end
		if place.py == nil then place.py = 0 end
		if place.px == 0 and place.py == 0 then
			playerLocationText = L["TITAN_LOCATION_NO_COORDS"]
		else
			playerLocationText = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * place.px, 100 * place.py);
		end
		playerLocationText = (format(player_format, TitanUtils_GetHighlightText(playerLocationText)));

		-- Determine the text to show for cursor coords
		local cx, cy = GetCursorPosition();

		-- use the global cursor position to confirm the cursor is over the map, but then use a normalized cursor position to account for map zooming
		local left, bottom, width, height = WorldMapFrame.ScrollContainer:GetScaledRect();
		if (cx > left and cy > bottom and cx < left + width and cy < bottom + height) then
			cx, cy = WorldMapFrame:GetNormalizedCursorPosition();
			cx, cy = cx or 0, cy or 0;
		else
			cx, cy = 0, 0
		end

		-- per the user requested format
		cursorLocationText = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * cx, 100 * cy)
		cursorLocationText = (format(cursor_format, TitanUtils_GetHighlightText(cursorLocationText)))
	else
		-- use defaults, saving a few cpu cycles
	end

	SetCoordText(playerLocationText, cursorLocationText)
end

---local Set the coordinates text for player and cursor. Used on update to refresh and on hide to clear the text.
---@param action string Start | Stop
local function CoordFrames(action)
	local show_on_map = (TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsOnMap") and true or false)
	if addon_conflict then
		-- do not attempt coords
	else
		local frame = _G[TITAN_MAP_FRAME]
		if show_on_map then
			if action == "start" then
				local function updateFunc()
					TitanMapFrame_OnUpdate(frame, 0.07); -- simulating an OnUpdate call
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
			.. " " .. tostring(action) .. ""
			.. " " .. tostring(show_on_map) .. ""
			.. " " .. tostring(addon_conflict) .. ""
		debug_msg(msg)
	else
		-- not requested
	end
end

---local Adds player and cursor coords to the WorldMapFrame, unless the player has CT_MapMod
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

---local Display button when plugin is visible
---@param self Button
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

---local Destroy repeating timer when plugin is hidden
---@param self Button
local function OnHide(self)
	AceTimer:CancelTimer(LocationTimer)
	LocationTimerRunning = false

	Events("unregister", "_OnHide")
	CoordFrames("stop") -- stop coords on map, if requested
end

---local Calculate coordinates and then display data on button.
---@param id string
---@return string plugin_label
---@return string plugin_text
local function GetButtonText(id)
	-- Jul 2024 : Made display only; vars assigned per timer or events.
	local button = TitanUtils_GetButton(id);
	local locationRichText = ""

	local zone_text = ""
	local subzone_text = ""
	local xy_text = ""

	if button then -- sanity check
		-- Set in order of display on plugin...

		-- Zone text, if requested
		if TitanGetVar(TITAN_LOCATION_ID, "ShowZoneText") then
			zone_text = TitanUtils_ToString(place.zoneText)
				.." "..TitanUtils_ToString(place.subZoneText)
			-- overwrite with subZone text, if requested
			if TitanGetVar(TITAN_LOCATION_ID, "ShowSubZoneText") then
				if place.subZoneText == "" then
					-- Show the zone instead
				else
					zone_text = TitanUtils_ToString(place.subZoneText)
				end
			else
				-- leave alone
			end
		else
			zone_text = ""
		end

		-- Coordinates text, if requested
		if TitanGetVar(TITAN_LOCATION_ID, "ShowCoordsText") then
			if place.px == 0 and place.py == 0 then
				xy_text = ""
			else
				xy_text = format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * place.px, 100 * place.py)
			end
		else
			xy_text = "";
		end

		-- seperator, if needed
		if ((zone_text:len() > 0) or (xy_text:len() > 0)) then
			zone_text = zone_text .. " "
		else
			-- no seperator needed
		end
	else
		locationRichText = "? id"
	end
	-- Color per type of zone (friendly, contested, hostile)
	locationRichText = zone_text..xy_text
	if (TitanGetVar(TITAN_LOCATION_ID, "ShowColoredText")) then
		if (place.isArena) then
			locationRichText = TitanUtils_GetRedText(locationRichText);
		elseif (place.pvpType == "friendly") then
			locationRichText = TitanUtils_GetGreenText(locationRichText);
		elseif (place.pvpType == "hostile") then
			locationRichText = TitanUtils_GetRedText(locationRichText);
		elseif (place.pvpType == "contested") then
			locationRichText = TitanUtils_GetNormalText(locationRichText);
		else
			locationRichText = TitanUtils_GetNormalText(locationRichText);
		end
	else
		locationRichText = TitanUtils_GetHighlightText(locationRichText);
	end

	return L["TITAN_LOCATION_BUTTON_LABEL"], locationRichText;
end

---local Get tooltip text
---@return string formatted_tooltip
local function GetTooltipText()
	local pvpInfoRichText;

	pvpInfoRichText = "";
	if (place.pvpType == "sanctuary") then
		pvpInfoRichText = TitanUtils_GetGreenText(SANCTUARY_TERRITORY);
	elseif (place.pvpType == "arena") then
		place.subZoneText = TitanUtils_GetRedText(place.subZoneText);
		pvpInfoRichText = TitanUtils_GetRedText(CONTESTED_TERRITORY);
	elseif (place.pvpType == "friendly") then
		pvpInfoRichText = TitanUtils_GetGreenText(format(FACTION_CONTROLLED_TERRITORY,
			place.factionName));
	elseif (place.pvpType == "hostile") then
		pvpInfoRichText = TitanUtils_GetRedText(format(FACTION_CONTROLLED_TERRITORY, place
		.factionName));
	elseif (place.pvpType == "contested") then
		pvpInfoRichText = TitanUtils_GetRedText(CONTESTED_TERRITORY);
	else
		pvpInfoRichText = ""
	end

	-- build the tool tip
	local zone = TitanUtils_GetHighlightText(place.zoneText) or ""
	local sub_zone = TitanUtils_Ternary(
		(place.subZoneText == ""),
		"",
		L["TITAN_LOCATION_TOOLTIP_SUBZONE"] ..
		"\t" .. TitanUtils_GetHighlightText(place.subZoneText) .. "\n"
	)
	local bind_loc = TitanUtils_GetHighlightText(GetBindLocation())

	return "" ..
		L["TITAN_LOCATION_TOOLTIP_ZONE"] .. "\t" .. zone .. "\n"
		.. sub_zone .. "\n"
		.. TitanUtils_GetHighlightText(L["TITAN_LOCATION_TOOLTIP_HOMELOCATION"]) .. "\n"
		.. L["TITAN_LOCATION_TOOLTIP_INN"] .. "\t" .. bind_loc .. "\n"
		.. pvpInfoRichText .. "\n\n"
		.. TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_1"]) .. "\n"
		.. TitanUtils_GetGreenText(L["TITAN_LOCATION_TOOLTIP_HINTS_2"])
end

---local Handle events registered to plugin
---@param self Button
---@param event string
---@param ... any
local function OnEvent(self, event, ...)
	-- DF TODO See if we can turn off zone on minimap
	--[=[
--]=]
	if debug_flow then
		local msg =
			"_OnEvent"
			.. " " .. tostring(event) .. ""
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

---local Handle events registered to plugin. Copies coordinates to chat line for shift-LeftClick
---@param self Button
---@param button string
local function OnClick(self, button)
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			local activeWindow = ChatEdit_GetActiveWindow();
			if (activeWindow) then
				local message = TitanUtils_ToString(place.zoneText) .. " " ..
					format(TitanGetVar(TITAN_LOCATION_ID, "CoordsFormat"), 100 * place.px, 100 * place.py);
				activeWindow:Insert(message);
			end
		else
			ToggleFrame(WorldMapFrame);
		end
	end
end

---local Create right click menu
local function CreateMenu()
	local info

	-- level 1
	if TitanPanelRightClickMenu_GetDropdownLevel() == 1 then
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

		info = {};
		info.notCheckable = true
		info.text = "WorldMap"
		info.value = "WorldMap"
		info.hasArrow = 1;
		TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

		TitanPanelRightClickMenu_AddControlVars(TITAN_LOCATION_ID)
		-- level 2
	elseif TitanPanelRightClickMenu_GetDropdownLevel() == 2 then
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

--			if TITAN_ID == "TitanClassic" then
				info = {};
				info.text = L["TITAN_LOCATION_MENU_SHOW_SUBZONE_ON_PANEL_TEXT"];
				info.func = function()
					TitanToggleVar(TITAN_LOCATION_ID, "ShowSubZoneText");
					TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
				end
				info.checked = TitanGetVar(TITAN_LOCATION_ID, "ShowSubZoneText");
				TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
--			else
				-- no work needed
--			end

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
			TitanPanelRightClickMenu_AddTitle(L["TITAN_LOCATION_FORMAT_COORD_LABEL"],
				TitanPanelRightClickMenu_GetDropdownLevel());
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

		if TitanPanelRightClickMenu_GetDropdMenuValue() == "WorldMap" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_LOCATION_MENU_TEXT"], TitanPanelRightClickMenu_GetDropdownLevel());
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

			info = {};
			info.text = L["TITAN_LOCATION_MENU_UPDATE_WORLD_MAP"];
			info.func = function()
				TitanToggleVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			end
			info.checked = TitanGetVar(TITAN_LOCATION_ID, "UpdateWorldmap");
			info.disabled = InCombatLockdown()
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			if TITAN_ID == "TitanClassic" then
				info = {};
				info.notCheckable = true
				info.text = L["TITAN_LOCATION_MENU_TEXT"];
				info.value = "CoordsLoc"
				info.hasArrow = 1;
				TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
			else
				-- no work needed
			end
		end

		-- level 3
	elseif TitanPanelRightClickMenu_GetDropdownLevel() == 3 then
		if TitanPanelRightClickMenu_GetDropdMenuValue() == "CoordsLoc" then
			info = {};
			info.text = L["TITAN_PANEL_MENU_BOTTOM"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsLoc", "Bottom");
				--				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = (TitanGetVar(TITAN_LOCATION_ID, "CoordsLoc") == "Bottom")
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

			info = {};
			info.text = L["TITAN_PANEL_MENU_TOP"];
			info.func = function()
				TitanSetVar(TITAN_LOCATION_ID, "CoordsLoc", "Top");
				--				TitanPanelButton_UpdateButton(TITAN_LOCATION_ID);
			end
			info.checked = (TitanGetVar(TITAN_LOCATION_ID, "CoordsLoc") == "Top")
			TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());
		end
	end
end

---local Create the plugin .registry and register startign events
---@param self Button
local function OnLoad(self)
	local notes = ""
	.. "Adds coordinates and location information to Titan Panel.\n"
	.. "Option Show Zone Text shows zone text - or not.\n"
	.. "- Show ONLY Subzone Text removes zone text from plugin.\n"
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
			ShowSubZoneText = false,
			ShowCoordsText = true,
			ShowCoordsOnMap = false,
			ShowCursorOnMap = false,
			ShowLocOnMiniMap = 1,
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
			CoordsFormat = L["TITAN_LOCATION_FORMAT"],
			CoordsLoc = "Bottom",
			CoordsLabel = true,
			UpdateWorldmap = false,
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

---local Create needed frames
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
