--[===[ File
This large file contains various utility routines used by
- Titan
- Plugin developers for strings; create menus; and more
- Addon developers that want to know which Titan full bars is on the UI

Nov 2023 : Merge Retail and Classic to minimize versions and maintainence and, hopefully, allow a consistent feature set.
--]===]

local _G = getfenv(0);
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local media = LibStub("LibSharedMedia-3.0")

local drop_down_1 = "" -- changes if using Blizz drop down (retail) or lib (Classic)

--====== Set the default drop down menu routines per retail or Classic
if TITAN_ID == "TitanClassic" then
	drop_down_1 = "L_DropDownList1" -- The LibUIDropDownMenu lib is used over the Blizzard frame
else
	-- The LibUIDropDownMenu lib is used over the Blizzard frame
	drop_down_1 = "DropDownList1" -- Boo!! Per hard-coded Blizz UIDropDownMenu.lua
end

--[===[ Var API Dropdown Menu wrappers
Right click menu routines for plugins
The expected frame name of the plugin is:
"TitanPanelRightClickMenu_Prepare"..<registry.id>.."Menu"

local drop_down_1 = "" -- changes if using Blizz drop down (retail) or lib (Classic)
Blizzard hard-codes the value...

The Titan routines abstract the menu creation built into WoW.

Whenever there is a change to the menu routines, the abstractions :
- Insulate 3rd party Titan plugin authors from Blizz or lib changes.
- Allow better maintainance by updating Utils rather than updating Titan using search & replace.

Titan uses TITAN_ID to determine which version of the abstracted routines to use!

The Ace lib was replaced with the Blizzard drop down routines in Dec 2018.
Then in 8.0.0 (Dec 2023) Titan combined its three versions into a single release.
With the inclusion of Retail and Classic (Wrath) and Classic Era, the Ace drop down wrappers were added back.

Classic:
The L_* routines wrap the drop down menu API from Ace for Titan Classic plugins.
The individual routines are not annotated for the API doc. See TitanUtils for the full list.

Titn handles Retail vs Classic using the TITAN_ID. Only declaring the L_* if Classic.
--]===]
--[[ ====== Classic routines for a drop down menu lib
Messy but declare the lib routines used in the Classic versions
--]]
if TITAN_ID == "TitanClassic" then
	local DDM = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

	--
	-- Wrap the drop down lib 4.0 to look like 2.0 to keep current plugins the same
	-- These need to be global to act like the older version
	--
	-- L_UIDropDownMenuDelegate_OnAttributeChanged -- Different in 4.0
	function L_UIDropDownMenu_InitializeHelper(frame)
		DDM:UIDropDownMenu_InitializeHelper(frame)
	end

	function L_Create_UIDropDownMenu(name, parent)
		local str = ""
		if type(name) == "table" then
			str = name:GetName()
		else
			str = name
		end
		return DDM:Create_UIDropDownMenu(name, parent)
	end

	function L_UIDropDownMenu_Initialize(frame, initFunction, displayMode, level, menuList)
		DDM:UIDropDownMenu_Initialize(frame, initFunction, displayMode, level, menuList)
	end

	function L_UIDropDownMenu_SetInitializeFunction(frame, initFunction)
		DDM:UIDropDownMenu_SetInitializeFunction(frame, initFunction)
	end

	function L_UIDropDownMenu_SetDisplayMode(frame, displayMode)
		DDM:UIDropDownMenu_SetDisplayMode(frame, displayMode)
	end

	function L_UIDropDownMenu_RefreshDropDownSize(self)
		DDM:UIDropDownMenu_RefreshDropDownSize(self)
	end

	--function L_UIDropDownMenu_OnUpdate(self, elapsed) -- Different in 4.0
	function L_UIDropDownMenu_StartCounting(frame)
		DDM:UIDropDownMenu_StartCounting(frame)
	end

	function L_UIDropDownMenu_StopCounting(frame)
		DDM:UIDropDownMenu_StopCounting(frame)
	end

	--function L_UIDropDownMenuButtonInvisibleButton_OnEnter(self)) -- Different in 4.0
	--function L_UIDropDownMenuButtonInvisibleButton_OnLeave(self)) -- Different in 4.0
	--function L_UIDropDownMenuButton_OnEnter(self) -- Different in 4.0
	--function L_UIDropDownMenuButton_OnLeave(self) -- Different in 4.0
	function L_UIDropDownMenu_CreateInfo()
		return DDM:UIDropDownMenu_CreateInfo()
	end

	function L_UIDropDownMenu_CreateFrames(level, index)
		DDM:UIDropDownMenu_CreateFrames(level, index)
	end

	function L_UIDropDownMenu_AddSeparator(level)
		DDM:UIDropDownMenu_AddSeparator(level)
	end

	function L_UIDropDownMenu_AddSpace(level) -- new in 4.0
		DDM:UIDropDownMenu_AddSpace(level)
	end

	function L_UIDropDownMenu_AddButton(info, level)
		DDM:UIDropDownMenu_AddButton(info, level)
	end

	function L_UIDropDownMenu_CheckAddCustomFrame(self, button, info)
		DDM:UIDropDownMenu_CheckAddCustomFrame(self, button, info)
	end

	function L_UIDropDownMenu_RegisterCustomFrame(self, customFrame)
		DDM:UIDropDownMenu_RegisterCustomFrame(self, customFrame)
	end

	function L_UIDropDownMenu_GetMaxButtonWidth(self)
		return DDM:UIDropDownMenu_GetMaxButtonWidth(self)
	end

	function L_UIDropDownMenu_GetButtonWidth(button)
		return DDM:UIDropDownMenu_GetButtonWidth(button)
	end

	function L_UIDropDownMenu_Refresh(frame, useValue, dropdownLevel)
		DDM:UIDropDownMenu_Refresh(frame, useValue, dropdownLevel)
	end

	function L_UIDropDownMenu_RefreshAll(frame, useValue)
		DDM:UIDropDownMenu_RefreshAll(frame, useValue)
	end

	function L_UIDropDownMenu_SetIconImage(icon, texture, info)
		DDM:UIDropDownMenu_SetIconImage(icon, texture, info)
	end

	function L_UIDropDownMenu_SetSelectedName(frame, name, useValue)
		DDM:UIDropDownMenu_SetSelectedName(frame, name, useValue)
	end

	function L_UIDropDownMenu_SetSelectedValue(frame, value, useValue)
		DDM:UIDropDownMenu_SetSelectedValue(frame, value, useValue)
	end

	function L_UIDropDownMenu_SetSelectedID(frame, id, useValue)
		DDM:UIDropDownMenu_SetSelectedID(frame, id, useValue)
	end

	function L_UIDropDownMenu_GetSelectedName(frame)
		return DDM:UIDropDownMenu_GetSelectedName(frame)
	end

	function L_UIDropDownMenu_GetSelectedID(frame)
		return DDM:UIDropDownMenu_GetSelectedID(frame)
	end

	function L_UIDropDownMenu_GetSelectedValue(frame)
		return DDM:UIDropDownMenu_GetSelectedValue(frame)
	end

	--function L_UIDropDownMenuButton_OnClick(self) -- Different in 4.0
	function L_HideDropDownMenu(level)
		DDM:HideDropDownMenu(level)
	end

	function L_ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button,
								  autoHideDelay)
		DDM:ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
	end

	function L_CloseDropDownMenus(level)
		DDM:CloseDropDownMenus(level)
	end

	--function L_UIDropDownMenu_OnHide(self) -- Different in 4.0
	-- 4.0 has 'contains mouse' routines for retail only
	function L_UIDropDownMenu_SetWidth(frame, width, padding)
		DDM:UIDropDownMenu_SetWidth(frame, width, padding)
	end

	function L_UIDropDownMenu_SetButtonWidth(frame, width)
		DDM:UIDropDownMenu_SetButtonWidth(frame, width)
	end

	function L_UIDropDownMenu_SetText(frame, text)
		DDM:UIDropDownMenu_SetText(frame, text)
	end

	function L_UIDropDownMenu_GetText(frame)
		return DDM:UIDropDownMenu_GetText(frame)
	end

	function L_UIDropDownMenu_ClearAll(frame)
		DDM:UIDropDownMenu_ClearAll(frame)
	end

	function L_UIDropDownMenu_JustifyText(frame, justification)
		DDM:UIDropDownMenu_JustifyText(frame, justification)
	end

	function L_UIDropDownMenu_SetAnchor(dropdown, xOffset, yOffset, point, relativeTo, relativePoint)
		DDM:UIDropDownMenu_SetAnchor(dropdown, xOffset, yOffset, point, relativeTo, relativePoint)
	end

	function L_UIDropDownMenu_GetCurrentDropDown()
		return DDM:UIDropDownMenu_GetCurrentDropDown()
	end

	function L_UIDropDownMenuButton_GetChecked(self)
		return DDM:UIDropDownMenuButton_GetChecked(self)
	end

	function L_UIDropDownMenuButton_GetName(self)
		return DDM:UIDropDownMenuButton_GetName(self)
	end

	function L_UIDropDownMenuButton_OpenColorPicker(self, button)
		DDM:UIDropDownMenuButton_OpenColorPicker(self, button)
	end

	function L_UIDropDownMenu_DisableButton(level, id)
		DDM:UIDropDownMenu_DisableButton(level, id)
	end

	function L_UIDropDownMenu_EnableButton(level, id)
		DDM:UIDropDownMenu_EnableButton(level, id)
	end

	function L_UIDropDownMenu_SetButtonText(level, id, text, colorCode)
		DDM:UIDropDownMenu_SetButtonText(level, id, text, colorCode)
	end

	function L_UIDropDownMenu_SetButtonNotClickable(level, id)
		DDM:UIDropDownMenu_SetButtonNotClickable(level, id)
	end

	function L_UIDropDownMenu_SetButtonClickable(level, id)
		DDM:UIDropDownMenu_SetButtonClickable(level, id)
	end

	function L_UIDropDownMenu_DisableDropDown(dropDown)
		DDM:UIDropDownMenu_DisableDropDown(dropDown)
	end

	function L_UIDropDownMenu_EnableDropDown(dropDown)
		DDM:UIDropDownMenu_EnableDropDown(dropDown)
	end

	function L_UIDropDownMenu_IsEnabled(dropDown)
		return DDM:UIDropDownMenu_IsEnabled(dropDown)
	end

	function L_UIDropDownMenu_GetValue(id)
		return DDM:UIDropDownMenu_GetValue(id)
	end

	function L_OpenColorPicker(info)
		DDM:OpenColorPicker(info)
	end

	function L_ColorPicker_GetPreviousValues()
		return DDM:ColorPicker_GetPreviousValues()
	end
else -- only retail (may change as Blizz expands API to Classic versions)
	---API Return the current setting of the Titan MinimapAdjust option.
	---@return boolean boolean Adjust
	function TitanUtils_GetMinimapAdjust()
		-- Used by addons
		return not TitanPanelGetVar("MinimapAdjust")
	end

	---API Allows an addon to turn on or off whether Titan adjusts mini map (MinimapAdjust).
	---@param bool boolean Adjust
	function TitanUtils_SetMinimapAdjust(bool)
		-- Used by addons
		TitanPanelSetVar("MinimapAdjust", not bool)
	end

	---API Tell Titan to adjust (or not) a frame. Allows an addon to tell Titan it will control adjustment of that frame.
	---@param frame string Frame Titan adjusts
	---@param bool boolean Adjust
	---- Titan will NOT store the adjust value across a log out / exit.
	---- This is a generic way for an addon to tell Titan to not adjust a frame.
	---The addon will take responsibility for adjusting that frame.
	---This is useful for UI style addons so the user can run Titan and a modifed UI.
	---- The list of frames Titan adjusts is specified in TitanMovableData within TitanMovable.lua.
	---- If the frame name is not in TitanMovableData then Titan does not adjust that frame.
	---- The frame list is different across the WoW versions.
	--- TitanMovable_AddonAdjust("MicroButtonAndBagsBar", true)
	function TitanUtils_AddonAdjust(frame, bool)
		-- Used by addons
		TitanMovable_AddonAdjust(frame, bool)
	end
end -- Retail versus retail routines

--====== The routines labeled API are useable by addon developers

---API Get the anchors of the bottom most top bar and the top most bottom bar.
---@return table Top
---@return table Bottom
---Intended for addons that modify the UI so they can adjust for Titan full bars.
---The two anchors are implemented as 2 frames that are moved by Titan depending on which full bars are shown.
function TitanUtils_GetBarAnchors()
	-- Used by addons
	return TitanPanelTopAnchor, TitanPanelBottomAnchor
end

--------------------------------------------------------------
--
-- Plugin button search & manipulation routines
--


---API Create the button name from plugin id.
---@param id string Unique ID of the plugin
---@return string? FrameName
function TitanUtils_ButtonName(id)
	if (id) then
		return Titan_Global.plugin.PRE .. id .. Titan_Global.plugin.POST
	else
		return nil
	end
end

---API Return the actual button frame and the plugin id.
---@param id string Unique ID of the plugin
---@return table? frame Frame of the plugin
---@return string? id Unique ID of the plugin
function TitanUtils_GetButton(id)
	-- API : Used by plugins
	if (id) then
		return _G[Titan_Global.plugin.PRE .. id .. Titan_Global.plugin.POST], id;
	else
		return nil, nil;
	end
end

---API Return whether the plugin is on top (1) or bottom (2) full bar - NOT which bar.
---@param id string Plugin name
---@return number? PluginId
function TitanUtils_GetRealPosition(id)
	-- This will return top / bottom but it is a compromise.
	-- With the introduction of independent bars there is
	-- more than just top / bottom.
	-- This should work in the sense that the plugins using this
	-- would overlap the double bar.
	local bar = TitanUtils_GetWhichBar(id)
	local bar_pos = nil
	for idx, v in pairs(TitanBarData) do
		if bar == TitanBarData[idx].name then
			bar_pos = TitanBarData[idx].vert
		end
	end
	return (bar_pos == TITAN_BOTTOM and TITAN_PANEL_PLACE_BOTTOM or TITAN_PANEL_PLACE_TOP)
end

---API Return the plugin id from the frame name
---@param name string Plugin frame name
---@return string? PluginId
function TitanUtils_GetButtonID(name)
	if name then
		local s, e, id = string.find(name, Titan_Global.plugin.PRE .. "(.*)" .. Titan_Global.plugin.POST);
		return id;
	else
		return nil;
	end
end

---Titan Return the plugin id of the parent of the given name, if it exists.
---@param name string Plugin frame name
---@return string? PluginId
---Used for Titan child templates which may not work...
function TitanUtils_GetParentButtonID(name)
	local frame = TitanUtils_Ternary(name, _G[name], nil);

	if (frame and frame:GetParent()) then
		return TitanUtils_GetButtonID(frame:GetParent():GetName());
	end
end

---Titan Return the plugin id of whatever the mouse is over. Used in the right click menu on load.
---@param self table Plugin frame
---@return string? PluginId could be the Titan ("Bar") or a plugin or nil.
function TitanUtils_GetButtonIDFromMenu(self)
	local ret = nil
	local temp
	if self and self:GetParent() then
		local name = self:GetParent():GetName()
		if name == "UIParent" then
			-- The click was on the Titan bar itself
			ret = "Bar";
		elseif self:GetParent():GetParent():GetName() then
			local pname = self:GetParent():GetParent():GetName()
			-- TitanPanelChildButton
			-- expecting this to be a TitanPanelChildButtonTemplate
			temp = TitanUtils_GetButtonID(pname)
			if temp then
				-- should be ok
				ret = temp
			else
				-- the frame container is expected to be without a name
				-- This trips when the user right clicks a LDB plugin...
			end
		else
			-- TitanPanelButton
			temp = TitanUtils_GetButtonID(self:GetParent():GetName())
			if temp then
				-- should be ok
				ret = temp
			else
				TitanDebug("Could not determine Titan ID for '"
					.. (self:GetParent():GetParent() or "?") .. "'. "
					, "error")
			end
		end
	else
		TitanDebug("Could not determine Titan ID from menu. "
		, "error")
	end

	return ret
end

---Titan Return the plugin itself (table and all).
---@param id string Unique ID of the plugin
---@return table? table plugin data
function TitanUtils_GetPlugin(id)
	if (id) then
		return TitanPlugins[id];
	else
		return nil;
	end
end

---Titan Return the bar the plugin is shown on.
---@param id string?
---@return string? ShortName
---@return string? LocaleName
function TitanUtils_GetWhichBar(id)
	local i = TitanPanel_GetButtonNumber(id);
	if TitanPanelSettings.Location[i] == nil then
		return nil, nil
	else
		local internal = TitanPanelSettings.Location[i]
		local locale = ""
		for _, v in pairs(TitanBarData) do
			if v.name == internal then
				locale = v.locale_name
			else
				-- not the Bar wanted
			end
		end
		return internal, locale
	end
end

---Titan Return the first bar that is shown.
---@return string? Bar
function TitanUtils_PickBar()
	-- Pick the 'first' bar shown per the Titan defined order.
	-- This is used for defaulting where plugins are put
	-- if using the Titan options screen.
	local bar_list = {}
	for _, v in pairs(TitanBarData) do
		bar_list[v.order] = v
	end
	table.sort(bar_list, function(a, b)
		return a.order < b.order
	end)

	for idx = 1, #bar_list do
		local bar_name = bar_list[idx].name
		if TitanBarDataVars[bar_list[idx].frame_name].show then --if TitanPanelGetVar(bar_name.."_Show") then
			return bar_name
		end
	end
	-- fail safe - return something
	return nil
end

---Titan See if the plugin is to be on the right.
---@param id string?
---@return boolean Found
function TitanUtils_ToRight(id)
	--[[
These are the methods to place a plugin on the right:
   1) DisplayOnRightSide saved variable logic (preferred)
   2) Place a plugin in TITAN_PANEL_NONMOVABLE_PLUGINS (NOT preferred)
Using the Titan template TitanPanelIconTemplate used to enforce right side only
but was removed during DragonFlight to give users more flexibility.
--]]
	local found = false
	for index, _ in ipairs(TITAN_PANEL_NONMOVABLE_PLUGINS) do
		if id == TITAN_PANEL_NONMOVABLE_PLUGINS[index] then
			found = true;
		end
	end

	if TitanGetVar(id, "DisplayOnRightSide") then
		found = true
	end

	return found
end

--====== General util routines

---API Return b (a = true) or c (a = false)
---@param a any
---@param b any
---@param c any
---@return any Tern
--- Typically used for saved variables check. Takes 'any' so relies on Lua T/F determination.
function TitanUtils_Ternary(a, b, c)
	if (a) then
		return b;
	else
		return c;
	end
end

---API Toggle value : (true or 1) return nil else return 1
---@param value boolean | number
---@return number? 1 or nil
--- Making this true / false would probably break Titan and a bunch of addons...
function TitanUtils_Toggle(value)
	if (value == 1 or value == true) then
		return nil;
	else
		return 1;
	end
end

---API Return min of a or b
---@param a any
---@param b any
---@return any Min
function TitanUtils_Min(a, b)
	if (a and b) then
		--		return ( a < b ) and a or b
		return TitanUtils_Ternary((a < b), a, b);
	end
end

---API Return max of a or b
---@param a any
---@param b any
---@return any Max
function TitanUtils_Max(a, b)
	if (a and b) then
		return TitanUtils_Ternary((a > b), a, b);
		---		return ( a > b ) and a or b
	end
end

---API Return the rounded up number
---@param v number
---@return number Rounded_value
function TitanUtils_Round(v)
	local f = math.floor(v)
	if v == f then
		return f
	else
		return math.floor(v + 0.5)
	end
end

---local return elapsed time from seconds given - spaces and leaving off the rest
---@param seconds_value number
---@return number days
---@return number hours
---@return number minutes
---@return number seconds
local function GetTimeParts(seconds_value)
	local s = seconds_value
	local days = 0
	local hours = 0
	local minutes = 0
	local seconds = 0
	if not s or (s < 0) then
		seconds = -1
	else
		days = floor(s / 24 / 60 / 60); s = mod(s, 24 * 60 * 60);
		hours = floor(s / 60 / 60); s = mod(s, 60 * 60);
		minutes = floor(s / 60); s = mod(s, 60);
		seconds = s;
	end

	return days, hours, minutes, seconds
end

---API return a elapsed time from seconds given - spaces and leaving off the rest
---@param seconds_value number
---@return string Time that is readable
function TitanUtils_GetEstTimeText(seconds_value)
	local timeText = "";
	local days, hours, minutes, seconds = GetTimeParts(seconds_value)
	local fracdays = days + (hours / 24);
	local frachours = hours + (minutes / 60);
	if seconds == -1 then
		timeText = L["TITAN_PANEL_NA"];
	else
		if (days ~= 0) then
			timeText = timeText .. format("%4.1f" .. L["TITAN_PANEL_DAYS_ABBR"] .. " ", fracdays);
		elseif (days ~= 0 or hours ~= 0) then
			timeText = timeText .. format("%4.1f" .. L["TITAN_PANEL_HOURS_ABBR"] .. " ", frachours);
		elseif (days ~= 0 or hours ~= 0 or minutes ~= 0) then
			timeText = timeText .. format("%d" .. L["TITAN_PANEL_MINUTES_ABBR"] .. " ", minutes);
		else
			timeText = timeText .. format("%d" .. L["TITAN_PANEL_SECONDS_ABBR"], seconds);
		end
	end
	return timeText;
end

---API return a localized time from seconds given - days, hours, minutes, and seconds using commas and including zeroe
---@param seconds_value number
---@return string Time that is readable
function TitanUtils_GetFullTimeText(seconds_value)
	local days, hours, minutes, seconds = GetTimeParts(seconds_value)
	if seconds == L["TITAN_PANEL_NA"] then
		return L["TITAN_PANEL_NA"];
	else
		return format("%d" .. L["TITAN_PANEL_DAYS_ABBR"]
			.. ", %2d" .. L["TITAN_PANEL_HOURS_ABBR"]
			.. ", %2d" .. L["TITAN_PANEL_MINUTES_ABBR"]
			.. ", %2d" .. L["TITAN_PANEL_SECONDS_ABBR"],
			days, hours, minutes, seconds);
	end
end

---API return a terse localized time from seconds given.
---@param seconds_value number
---@return string Time that is readable
function TitanUtils_GetAbbrTimeText(seconds_value)
	local timeText = "";
	local days, hours, minutes, seconds = GetTimeParts(seconds_value)
	if seconds == L["TITAN_PANEL_NA"] then
		timeText = L["TITAN_PANEL_NA"];
	else
		if (days ~= 0) then
			timeText = timeText .. format("%d" .. L["TITAN_PANEL_DAYS_ABBR"] .. " ", days);
		end
		if (days ~= 0 or hours ~= 0) then
			timeText = timeText .. format("%d" .. L["TITAN_PANEL_HOURS_ABBR"] .. " ", hours);
		end
		if (days ~= 0 or hours ~= 0 or minutes ~= 0) then
			timeText = timeText .. format("%d" .. L["TITAN_PANEL_MINUTES_ABBR"] .. " ", minutes);
		end
		timeText = timeText .. format("%d" .. L["TITAN_PANEL_SECONDS_ABBR"], seconds);
	end
	return timeText;
end

---API Get the control frame of the plugin given.
---@param id string Unique ID of the plugin
---@return table? frame Frame of the menu (right click)
function TitanUtils_GetControlFrame(id)
	if (id) then
		return _G["TitanPanel" .. id .. "ControlFrame"];
	else
		return nil;
	end
end

---API Routine that index of the value given.
---@param table table Array to check
---@param value any Value to look for
---@return any index if value found; nil if not
function TitanUtils_TableContainsValue(table, value)
	local res = nil
	if (table and value) then
		for i, v in pairs(table) do
			if (v == value) then
				return i;
			end
		end
	end

	return res -- not found
end

---API Routine that index if found.
---@param table table Array to check
---@param index any Index to look for
---@return any index if found; nil if not
function TitanUtils_TableContainsIndex(table, index)
	local res = nil
	if (table and index and table[index] ~= nil) then
		return index
	end

	return res -- not found
end

---API Routine that index of the value given.
---@param table table Array to check
---@param value any Value to look for
---@return any index if value found; nil if not
function TitanUtils_GetCurrentIndex(table, value)
	return TitanUtils_TableContainsValue(table, value);
end

---API Debug tool that will attempt to output to Chat the top level index and value of the array.
---@param array table Simple array
function TitanUtils_PrintArray(array)
	if (not array) then
		TitanDebug("array is nil");
	else
		TitanDebug("{");
		for i, v in array do
			TitanDebug("array[" .. tostring(i) .. "] = " .. tostring(v));
		end
		TitanDebug("}");
	end
end

---API Routine that returns red string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Red color encoded string
function TitanUtils_GetRedText(text)
	local res = ""
	if (text) then
		res = _G["RED_FONT_COLOR_CODE"] .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns gold string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Gold color encoded string
function TitanUtils_GetGoldText(text)
	local res = ""
	if (text) then
		res = "|cffffd700" .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns green string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Green color encoded string
function TitanUtils_GetGreenText(text)
	local res = ""
	if (text) then
		res = _G["GREEN_FONT_COLOR_CODE"] .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns blue string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Blue color encoded string
function TitanUtils_GetBlueText(text)
	local res = ""
	if (text) then
		res = "|cff0000ff" .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns normal color (gray-white) string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Normal color encoded string
function TitanUtils_GetNormalText(text)
	local res = ""
	if (text) then
		res = _G["NORMAL_FONT_COLOR_CODE"] .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns highlight color (brighter white) string with proper start and end font encoding.
---@param text string Text to wrap
---@return string text Highlight color encoded string
function TitanUtils_GetHighlightText(text)
	local res = ""
	if (text) then
		res = _G["HIGHLIGHT_FONT_COLOR_CODE"] .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns custom color (rbg) string with proper start and end font encoding.
---@param text string Text to wrap
---@param color any See color:GetRGB() / color:GetRGBA()
---@return string text Custom color encoded string
--- TitanUtils_GetColoredText(GOLD_PERHOUR_STATUS, TITAN_GOLD_GREEN)
function TitanUtils_GetColoredText(text, color)
	local res = ""
	if (text and color) then
		local redColorCode = format("%02x", color.r * 255);
		local greenColorCode = format("%02x", color.g * 255);
		local blueColorCode = format("%02x", color.b * 255);
		local colorCode = "|cff" .. redColorCode .. greenColorCode .. blueColorCode;
		res = colorCode .. text .. _G["FONT_COLOR_CODE_CLOSE"];
	else
		res = _G["GRAY_FONT_COLOR_CODE"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---API Routine that returns custom color (hex) string with proper start and end font encoding.
---@param text string Text to wrap
---@param hex string
---@return string text Custom color encoded string
---TitanUtils_GetHexText(player.faction, "d42447") -- Horde
function TitanUtils_GetHexText(text, hex)
	local res = ""
	if (text and hex) then
		res = "|cff" .. tostring(hex) .. text .. _G["FONT_COLOR_CODE_CLOSE"]
	else
		res = _G["GRAY_FONT_COLOR"] .. tostring(text) .. _G["FONT_COLOR_CODE_CLOSE"]
	end

	return res
end

---@param ThresholdTable table holding the list of colors and values
---@param value number to check against table ranges (assumes assending values)
---@return string color in table or "GRAY_FONT_COLOR"
function TitanUtils_GetThresholdColor(ThresholdTable, value)
	--[[ example
	local TITAN_FPS_THRESHOLD_TABLE = {
		Values = { 20, 30 },
		Colors = { RED_FONT_COLOR, NORMAL_FONT_COLOR, GREEN_FONT_COLOR },
	}

	TitanUtils_GetThresholdColor(TITAN_FPS_THRESHOLD_TABLE, button.fps)
	--]]
	if (not tonumber(value) or type(ThresholdTable) ~= "table"
			or ThresholdTable.Values == nil or ThresholdTable.Colors == nil
			or table.getn(ThresholdTable.Values) >= table.getn(ThresholdTable.Colors)
		) then
		return _G["GRAY_FONT_COLOR"];
	end

	local n = table.getn(ThresholdTable.Values) + 1;
	for i = 1, n do
		local low = TitanUtils_Ternary(i == 1, nil, ThresholdTable.Values[i - 1]); -- lowest
		local high = TitanUtils_Ternary(i == n, nil, ThresholdTable.Values[i]); -- highest

		if (not low and not high) then
			-- No threshold values
			return ThresholdTable.Colors[i];
		elseif (not low and high) then
			-- Value is smaller than the first threshold
			if (value < high) then return ThresholdTable.Colors[i] end
		elseif (low and not high) then
			-- Value is larger than the last threshold
			if (low <= value) then return ThresholdTable.Colors[i] end
		else
			-- Value is in between 2 adjacent thresholds
			if (low <= value and value < high) then
				return ThresholdTable.Colors[i]
			end
		end
	end

	-- Should never reach here
	return _G["GRAY_FONT_COLOR"];
end

---API Routine that returns the text or an empty string.
---@param text string Text to check
---@return string text or ""
function TitanUtils_ToString(text)
	return TitanUtils_Ternary(text, text, "");
end

--====== Right click menu routines - Retail dropdown menu

---local Add menu button at the given level.
---@param info table Filled in button to add
---@param level number menu level
local function Add_button(info, level)
	if TITAN_ID == "TitanClassic" then
		L_UIDropDownMenu_AddButton(info, level);
	else
		UIDropDownMenu_AddButton(info, level)
	end
end

---API Menu - Get the base frame name of the user selected menu (without level).
---@return string frame_name
function TitanPanelRightClickMenu_GetDropdownFrameBase()
	local res = ""

	if TITAN_ID == "TitanClassic" then
		res = "L_DropDownList" -- The LibUIDropDownMenu lib is used over the Blizzard frame
	else
		-- The LibUIDropDownMenu lib is used over the Blizzard frame
		res = "DropDownList" -- Boo!! Per hard-coded Blizz UIDropDownMenu.lua
	end

	return res
end

---API Menu - Get the frame name of the user selected menu.
---@return string frame_name
function TitanPanelRightClickMenu_GetDropdownFrame()
	local res = ""

	if TITAN_ID == "TitanClassic" then
		res = "L_DropDownList" .. tostring(L_UIDROPDOWNMENU_MENU_LEVEL)
	else
		-- The LibUIDropDownMenu lib is used over the Blizzard frame
		res = "DropDownList" .. tostring(UIDROPDOWNMENU_MENU_LEVEL)
	end

	return res
end

---API Menu - Get the current level of the user selected menu.
---@return number level
function TitanPanelRightClickMenu_GetDropdownLevel()
	--	local res = _G[drop_down_1]
	local res = 1 -- proper typing

	if TITAN_ID == "TitanClassic" then
		res = L_UIDROPDOWNMENU_MENU_LEVEL
	else
		-- The LibUIDropDownMenu lib is used over the Blizzard frame
		res = UIDROPDOWNMENU_MENU_LEVEL
	end

	return res
end

---API Menu - Get the current value of the user selected menu.
---@return any Value <button>.value usually a string; could be table to hold needed info
function TitanPanelRightClickMenu_GetDropdMenuValue()
	local res = nil
	if TITAN_ID == "TitanClassic" then
		res = L_UIDROPDOWNMENU_MENU_VALUE
	else
		res = UIDROPDOWNMENU_MENU_VALUE
	end
	return res
end

---API Menu - add given info (button) at the given menu level.
---@param info table Filled in button to add
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddButton(info, level)
	level = level or 1
	if (info) then
		Add_button(info, level)
	end
end

---API Menu - add a toggle Right Side (localized) command at the given level in the form of a button. Titan will properly control the "DisplayOnRightSide"
---@param id string Plugin id
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddToggleRightSide(id, level)
	level = level or 1
	local plugin = TitanUtils_GetPlugin(id)
	if plugin and plugin.controlVariables and plugin.controlVariables.DisplayOnRightSide then
		-- copy of TitanPanelRightClickMenu_AddToggleVar adding a remove button
		local info = {};
		info.text = L["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"];
		info.value = { id, "DisplayOnRightSide" };
		info.func = function()
			local bar = TitanUtils_GetWhichBar(id)
			TitanPanelRightClickMenu_ToggleVar({ id, "DisplayOnRightSide" })
			TitanPanel_RemoveButton(id);
			TitanUtils_AddButtonOnBar(bar, id)
		end
		info.checked = TitanGetVar(id, "DisplayOnRightSide");
		info.keepShownOnClick = 1;
		Add_button(info, level);
	end
end

---API Menu - add a localized title at the given level in the form of a button.
---@param title string localized title
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddTitle(title, level)
	level = level or 1
	if (title) then
		local info = {};
		info.text = title;
		info.notCheckable = true;
		info.notClickable = true;
		info.isTitle = 1;
		Add_button(info, level);
	end
end

---API Menu - add a toggle variable command at the given level in the form of a button.
---@param text string Localized text to show
---@param value string Internal button name
---@param functionName function | string Function to call on click
---@param level? number menu level
function TitanPanelRightClickMenu_AddCommand(text, value, functionName, level)
	level = level or 1
	local info = {};
	info.notCheckable = true;
	info.text = text;
	info.value = value;
	info.func = function()
		if functionName then
			local callback = functionName

			if type(callback) == 'string' then
				-- Function MUST be in global namespace
				callback = _G[callback]
			elseif type(callback) == 'function' then
				-- Can be global or local to the plugin
			else
				-- silently leave...
			end
			-- Redundant but the given string may not be a function
			if type(callback) == "function" then
				-- No return expected...
				callback(value)
			else
				-- Must be a function - spank developer
			end
		else
			-- Leave, creates an inactive button
		end
	end
	Add_button(info, level);
end

---API Menu - add a line at the given level in the form of an inactive button.
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddSeparator(level)
	level = level or 1
	if TITAN_ID == "TitanClassic" then
		L_UIDropDownMenu_AddSeparator(level)
	else
		UIDropDownMenu_AddSeparator(level)
	end
end

---API Menu - add a blank line at the given level in the form of an inactive button.
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddSpacer(level)
	level = level or 1
	if TITAN_ID == "TitanClassic" then
		L_UIDropDownMenu_AddSpace(level)
	else
		UIDropDownMenu_AddSpace(level)
	end
end

---API This will remove the plugin from whichever Titan bar it is on.
---@param id string Plugin id
function TitanPanelRightClickMenu_Hide(id)
	TitanPanel_RemoveButton(id);
end

---API Menu - add a toggle variable command at the given level in the form of a button.
---@param text string Localized text to show
---@param id string Plugin id
---@param var string the saved variable of the plugin to toggle
---@param toggleTable nil ! NOT USED !
---@param level number menu level
function TitanPanelRightClickMenu_AddToggleVar(text, id, var, toggleTable, level)
	local info = {};
	info.text = text;
	info.value = { id, var, toggleTable };
	info.func = function()
		TitanPanelRightClickMenu_ToggleVar({ id, var, toggleTable })
	end
	info.checked = TitanGetVar(id, var);
	info.keepShownOnClick = 1;
	Add_button(info, level);
end

---API Menu - add a toggle Label (localized) command at the given level in the form of a button. Titan will properly control "ShowIcon"
---@param id string Plugin id
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddToggleIcon(id, level)
	level = level or 1
	local plugin = TitanUtils_GetPlugin(id)
	if plugin and plugin.controlVariables and plugin.controlVariables.ShowIcon then
		TitanPanelRightClickMenu_AddToggleVar(L["TITAN_PANEL_MENU_SHOW_ICON"], id, "ShowIcon", nil, level);
	end
end

---API Menu - add a toggle Label (localized) command at the given level in the form of a button. Titan will properly control "ShowLabelText"
---@param id string Plugin id
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddToggleLabelText(id, level)
	level = level or 1
	local plugin = TitanUtils_GetPlugin(id)
	if plugin and plugin.controlVariables and plugin.controlVariables.ShowLabelText then
		TitanPanelRightClickMenu_AddToggleVar(L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"], id, "ShowLabelText", nil, level);
	end
end

---API Menu - add a toggle Colored Text (localized) command at the given level in the form of a button. Titan will properly control "ShowColoredText"
---@param id string Plugin id
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddToggleColoredText(id, level)
	level = level or 1
	local plugin = TitanUtils_GetPlugin(id)
	if plugin and plugin.controlVariables and plugin.controlVariables.ShowColoredText then
		TitanPanelRightClickMenu_AddToggleVar(L["TITAN_PANEL_MENU_SHOW_COLORED_TEXT"], id, "ShowColoredText", nil, level);
	end
end

---API Menu - add a Hide (localized) command at the given level in the form of a button. When clicked this will remove the plugin from the Titan bar.
---@param id string Plugin id
---@param level? number menu level or 1
function TitanPanelRightClickMenu_AddHide(id, level)
	level = level or 1
	local info = {};
	info.notCheckable = true;
	info.text = L["TITAN_PANEL_MENU_HIDE"];
	info.value = nil -- value; huh - what should this be?
	info.func = function()
		TitanPanelRightClickMenu_Hide(id)
	end
	Add_button(info, level);
end

---API This will toggle the Titan variable and the update the button.
---@param value table Plugin id and var to toggle
--- Example: {TITAN_XP_ID, "ShowSimpleToLevel"}
function TitanPanelRightClickMenu_ToggleVar(value)
	-- Update 2024 Mar - Removed the 'reverse' check.
	-- Not sure it was ever used or even worked.
	--	local id, var, toggleTable = "", nil, {}
	local id, var = "", ""

	-- table expected else do nothing
	if type(value) ~= "table" then return end

	if value and value[1] then id = value[1] end
	if value and value[2] then var = value[2] end
	--	if value and value[3] then toggleTable = value[3] end

	-- Toggle var
	TitanToggleVar(id, var);
	TitanPanelButton_UpdateButton(id);
	--[=[]]
	if ( TitanPanelRightClickMenu_AllVarNil(id, toggleTable) ) then
		-- Undo if all vars in toggle table nil
		TitanToggleVar(id, var);
	else
		-- Otherwise continue and update the button
		TitanPanelButton_UpdateButton(id, 1);
	end
--]=]
end

---API Set backdrop of the plugin. Used for custom created controls (Clock / Volume) to give a consistent look.
---@param frame table Plugin control frame
function TitanPanelRightClickMenu_SetCustomBackdrop(frame)
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileEdge = true,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
		tileSize = 8,
		edgeSize = 8,
	})

	frame:SetBackdropBorderColor(
		TOOLTIP_DEFAULT_COLOR.r,
		TOOLTIP_DEFAULT_COLOR.g,
		TOOLTIP_DEFAULT_COLOR.b);
	frame:SetBackdropColor(
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.b
		, 1);
end

---API Menu - add the set of options per the plugin registry control variables.
---@param id string Plugin id
---@param level? number If not present, default to 1 (top)
function TitanPanelRightClickMenu_AddControlVars(id, level)
	level = level or 1 -- assume top menu
	TitanPanelRightClickMenu_AddSeparator(level)

	TitanPanelRightClickMenu_AddToggleIcon(id, level)
	TitanPanelRightClickMenu_AddToggleLabelText(id, level)
	TitanPanelRightClickMenu_AddToggleColoredText(id, level)
	TitanPanelRightClickMenu_AddToggleRightSide(id, level)

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], id, TITAN_PANEL_MENU_FUNC_HIDE);
end

--------------------------------------------------------------
--
-- Plugin manipulation routines
--


---local This will swap two buttons on the Titan bars. Once swapped then 'reinit' the buttons to show properly. 
--- This is currently used as part of the shift left / right on same bar.
---@param from_id integer Plugin id
---@param to_id integer Plugin id
local function TitanUtils_SwapButtonOnBar(from_id, to_id)
	-- Used as part of the shift L / R to swap the buttons
	local button = TitanPanelSettings.Buttons[from_id]
	local locale = TitanPanelSettings.Location[from_id]

	TitanPanelSettings.Buttons[from_id] = TitanPanelSettings.Buttons[to_id]
	TitanPanelSettings.Location[from_id] = TitanPanelSettings.Location[to_id]
	TitanPanelSettings.Buttons[to_id] = button
	TitanPanelSettings.Location[to_id] = locale
	TitanPanel_InitPanelButtons();
end

---local Find the next button index that is on the same bar and is on the same side.
---@param bar string Short bar name to look through
---@param id string Plugin id to look for
---@param side string TITAN_RIGHT("Right") or TITAN_Left("Left")
---@return integer? NextIndex nil means id is last
-- Buttons on Left are placed L to R; buttons on Right are placed R to L. Next and prev depend on which side we need to check.
local function TitanUtils_GetNextButtonOnBar(bar, id, side)
	-- find the next button that is on the same bar and is on the same side
	-- return nil if not found
	local index = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, id);

	for i, id in pairs(TitanPanelSettings.Buttons) do
		if TitanUtils_GetWhichBar(id) == bar
			and i > index
			and TitanPanel_GetPluginSide(id) == side
			and TitanUtils_IsPluginRegistered(id) then
			return i;
		end
	end
end

---local Find the previous button index that is on the same bar and is on the same side.
---@param bar string Short bar name to look through
---@param id string Plugin id to look for
---@param side string TITAN_RIGHT("Right") or TITAN_Left("Left")
---@return integer? PrevIndex nil means id is first
-- Buttons on Left are placed L to R; buttons on Right are placed R to L. Next and prev depend on which side we need to check.
local function TitanUtils_GetPrevButtonOnBar(bar, id, side)
	-- find the prev button that is on the same bar and is on the same side
	-- return nil if not found
	local index = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, id);
	local prev_idx = nil

	for i, id in pairs(TitanPanelSettings.Buttons) do
		if TitanUtils_GetWhichBar(id) == bar
			and i < index
			and TitanPanel_GetPluginSide(id) == side
			and TitanUtils_IsPluginRegistered(id) then
			prev_idx = i; -- this might be the previous button
		end
		if i == index then
			return prev_idx;
		end
	end
end

---Titan Add the given plugin to the given bar. Then reinit the plugins to show it properly.
---@param bar string Bar name to use
---@param id string Plugin to add
function TitanUtils_AddButtonOnBar(bar, id)
	local frame_str = TitanVariables_GetFrameName(bar)
	-- Add the button to the requested bar, if shown
	if (not bar)
		or (not id)
		or (not TitanPanelSettings)
		or (not TitanBarDataVars[frame_str].show)
	then
		return;
	end

	local i = TitanPanel_GetButtonNumber(id)
	-- The _GetButtonNumber returns +1 if not found so it is 'safe' to
	-- update / add to the Location
	TitanPanelSettings.Buttons[i] = (id or "?")
	TitanPanelSettings.Location[i] = (bar or "Bar")
	TitanPanel_InitPanelButtons();
end

---Titan Find the first button that is on the given bar and is on the given side.
--- buttons on Left are placed L to R; buttons on Right are placed R to L. Next and prev depend on which side we need to check.
--- buttons on Right are placed R to L
---@param bar string Bar name to search
---@param side string TITAN_RIGHT("Right") or TITAN_Left("Left")
function TitanUtils_GetFirstButtonOnBar(bar, side)
	-- find the first button that is on the same bar and is on the same side
	-- return nil if not found
	local index = 0

	for i, id in pairs(TitanPanelSettings.Buttons) do
		if TitanUtils_GetWhichBar(id) == bar
			and i > index
			and TitanPanel_GetPluginSide(id) == side
			and TitanUtils_IsPluginRegistered(id) then
			return i;
		end
	end
end

---Titan Find the button that is on the bar and is on the side and left of the given button
---@param name string Plugin id name
function TitanUtils_ShiftButtonOnBarLeft(name)
	-- Find the button to the left. If there is one, swap it in the array
	local from_idx = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, name)
	local side = TitanPanel_GetPluginSide(name)
	local bar = TitanUtils_GetWhichBar(name)
	local to_idx = nil

	-- buttons on Left are placed L to R;
	-- buttons on Right are placed R to L
	if side and side == TITAN_LEFT then
		to_idx = TitanUtils_GetPrevButtonOnBar(TitanUtils_GetWhichBar(name), name, side)
	elseif side and side == TITAN_RIGHT then
		to_idx = TitanUtils_GetNextButtonOnBar(TitanUtils_GetWhichBar(name), name, side)
	end

	if to_idx then
		TitanUtils_SwapButtonOnBar(from_idx, to_idx);
	else
		return
	end
end

--Titan Find the button that is on the bar and is on the side and right of the given button
---@param name string Plugin id name
function TitanUtils_ShiftButtonOnBarRight(name)
	-- Find the button to the right. If there is one, swap it in the array
	local from_idx = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, name)
	local to_idx = nil
	local side = TitanPanel_GetPluginSide(name)
	local bar = TitanUtils_GetWhichBar(name)

	-- buttons on Left are placed L to R;
	-- buttons on Right are placed R to L
	if side and side == TITAN_LEFT then
		to_idx = TitanUtils_GetNextButtonOnBar(bar, name, side)
	elseif side and side == TITAN_RIGHT then
		to_idx = TitanUtils_GetPrevButtonOnBar(bar, name, side)
	end

	if to_idx then
		TitanUtils_SwapButtonOnBar(from_idx, to_idx);
	else
		return
	end
end

--------------------------------------------------------------
--
-- Control Frame check & manipulation routines
--

---Titan: Check the frame - expected to be a control / menu frame. Close if timer has expired. Used in plugin OnUpdate
---@param frame table control / menu frame
---@param elapsed number portion of second since last OnUpdate
function TitanUtils_CheckFrameCounting(frame, elapsed)
	if (frame:IsVisible()) then
		if (not frame.frameTimer or not frame.isCounting) then
			return;
		elseif (frame.frameTimer < 0) then
			frame:Hide();
			frame.frameTimer = nil;
			frame.isCounting = nil;
		else
			frame.frameTimer = frame.frameTimer - elapsed;
		end
	end
end

---Titan Set the max time the control frame could be open once cursor has left frame. Used in plugin OnLeave
---@param frame table control / menu frame
---@param frameShowTime number time to wait
function TitanUtils_StartFrameCounting(frame, frameShowTime)
	frame.frameTimer = frameShowTime;
	frame.isCounting = 1;
end

---Titan Remove timer flag once cursor has entered frame. Used in plugin OnEnter
---@param frame table control / menu frame
function TitanUtils_StopFrameCounting(frame)
	frame.isCounting = nil;
end

---Titan Remove all timer flags on plugin control frames. Used for plugin Shift+Left and within Titan
--- Used for Plugins AND Titan
function TitanUtils_CloseAllControlFrames()
	for index, value in pairs(TitanPlugins) do
		local frame = _G["TitanPanel" .. index .. "ControlFrame"];
		if (frame and frame:IsVisible()) then
			frame:Hide();
		end
	end
end

--[[ 2024 Mar commented out - not used by Titan
function TitanUtils_IsAnyControlFrameVisible() -- need?
	for index, value in TitanPlugins do
		local frame = _G["TitanPanel" .. index .. "ControlFrame"];
		if (frame:IsVisible()) then
			return true;
		end
	end
	return false;
end
--]]

---Titan Check if the control frame is on screen.
--- Used for Plugins AND Titan
---@param frame table Frame name likely tooltip
---@return number off_X -1 off left; 0 = ok; 1 off right
---@return number off_Y -1 off top; 0 = ok; 1 off bottom
function TitanUtils_GetOffscreen(frame)
	local offscreenX, offscreenY;
	local ui_scale = UIParent:GetEffectiveScale()
	if not frame then
		return 0, 0 -- ??
	end
	local fr_scale = frame:GetEffectiveScale()

	if (frame and frame:GetLeft()
			and frame:GetLeft() * fr_scale < UIParent:GetLeft() * ui_scale) then
		offscreenX = -1;
	elseif (frame and frame:GetRight()
			and frame:GetRight() * fr_scale > UIParent:GetRight() * ui_scale) then
		offscreenX = 1;
	else
		offscreenX = 0;
	end

	if (frame and frame:GetTop()
			and frame:GetTop() * fr_scale > UIParent:GetTop() * ui_scale) then
		offscreenY = -1;
	elseif (frame and frame:GetBottom()
			and frame:GetBottom() * fr_scale < UIParent:GetBottom() * ui_scale) then
		offscreenY = 1;
	else
		offscreenY = 0;
	end

	return offscreenX, offscreenY;
end

--------------------------------------------------------------
--
-- Plugin registration routines
--

---Titan Wrapper to get meta data from the addon
---@param name string Addon name
---@param field string Attribute to get
function TitanUtils_GetAddOnMetadata(name, field)
	-- As of May 2023 (10.1) the routine moved and no longer dies silently so it is wrapped here...
	---@diagnostic disable-next-line: deprecated
	local GetMeta = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

	local call_success, ret_val

	-- Just in case, catch any errors
	call_success, -- needed for pcall
	ret_val =  -- actual return values
		pcall(GetMeta, name, field)
	if call_success then
		-- all is good
		return ret_val
	else
		-- Some error.. for our use return nil
		return nil
	end
end

---Titan Store the plugin to be registered later by Titan
--- See comments in the routine for more details.
---@param self table Plugin frame
---@param isChildButton boolean? !! Not Used !!
function TitanUtils_PluginToRegister(self, isChildButton)
	-- 2024 Mar -- removed isChildButton since it has not been used in years to my knowledge :)
	--[[
- .registry is part of 'self' (the Titan plugin frame) which works great for Titan specific plugins.
  Titan plugins create the registry as part of the frame _OnLoad.
  But this does not work for LDB buttons. The frame is created THEN the registry is added to the frame.
- Any read of the registry must assume it may not exist. Also assume the registry could be updated after this routine.
- This is called when a Titan plugin frame is created. Normally these are held until the player 'enters world' then the plugin is registered.
  Sometimes plugin frames are created after this process. Right now only LDB plugins are handled. If someone where to start creating Titan frames after the registration process were complete then it would fail to be registered...
-!For LDB plugins the 'registry' is attached to the frame AFTER the frame is created...
- The fields put into "Attempted" are defaulted here in preperation of being registered.
	--]]
	TitanPluginToBeRegisteredNum = TitanPluginToBeRegisteredNum + 1
	local cat = ""
	local notes = ""
	local name = ""
	if self and self.registry then
		cat = (self.registry.category or "")
		notes = (self.registry.notes or "")
		name = (self.registry.id or "")
	end
	-- Some of the fields in this record are displayed in the "Attempts"
	-- so they are defaulted here.
	TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum] = {
		self = self,
		button = ((self and self:GetName()
			or "Nyl" .. "_" .. TitanPluginToBeRegisteredNum)),
		isChild = false, -- (isChildButton and true or false),
		-- fields below are updated when registered
		name = "?",
		issue = "",
		status = TITAN_NOT_REGISTERED,
		category = cat,
		plugin_type = "",
		notes = notes,
	}

	-- Debug
	if Titan_Global.debug.plugin_register then
		TitanDebug("Queue Plugin"
			--			.." '"..tostring(self:GetName()).."'"
			.. " '" .. tostring(TitanUtils_GetButtonID(self:GetName())) .. "'"
			.. " " .. tostring(TITAN_NOT_REGISTERED) .. ""
		)
	end
end

---local Handle a Titan plugin that could not be registered.
--- See comments in the routine for more details.
---@param plugin table Plugin frame - Titan template
function TitanUtils_PluginFail(plugin)
	--[[
--- This is called when a plugin is unsupported. Curently this is used if a LDB data object is not supported.
--- See SupportedDOTypes in LDBToTitan.lua for more detail.
--- It is intended mainly for developers. It is a place to put relevant info for debug and so users can supply troubleshooting info.
--- The key is set the status to 'fail' so there is no further attempt to register the plugin.
--- The results will show in "Attempted" so the developer has a shot at figuring out what was wrong.
--- plugin is expected to hold as much relevant info as possible...
--]]
	TitanPluginToBeRegisteredNum = TitanPluginToBeRegisteredNum + 1
	TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum] =
	{
		self = plugin.self,
		button = (plugin.button and plugin.button:GetName() or ""),
		isChild = (plugin.isChild and true or false),
		name = (plugin.name or "?"),
		issue = (plugin.issue or "?"),
		status = (plugin.status or "?"),
		category = (plugin.category or ""),
		plugin_type = (plugin.plugin_type or ""),
	}

	local message = ""
		.. " '" .. tostring(TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum].status) .. "'"
		.. " '" .. tostring(TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum].name) .. "'"
		.. " '" .. tostring(TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum].category) .. "'"
		.. " '" .. tostring(TitanPluginToBeRegistered[TitanPluginToBeRegisteredNum].issue) .. "'"
	TitanPrint(message, "error")
end

---local Strip the WoW color string(s) from the given string
---@param name string 
---@return string NoColor 
local function NoColor(name)
	local no_color = name

	-- Remove any color formatting from the name in the list
	no_color = string.gsub(no_color, "|c........", "")
	no_color = string.gsub(no_color, "|r", "")

	return no_color
end

---local This routine is a protected manner (pcall) by Titan when it attempts to register a plugin.
---@param plugin table Plugin frame - Titan template
---@return table Results of the registration - pass (TitanPlugins) or fail
--- See routine for output table values
local function TitanUtils_RegisterPluginProtected(plugin)
--[[ 
OUT:
	.issue	: Show the user what prevented the plugin from registering
	.result	: Used so we know which plugins were processed
	.id		: The name used to lookup the plugin
	.cat		: The 'bucket' to use off the main Titan menu
	.ptype	: For now just Titan or LDB type
NOTE:
- We try to anticipate the various ways a plugin could fail to register or just plain fail.
  The intent is to keep Titan whole so a plugin does not prevent Titan from loading.
  And attempt to tell the user / developer what went wrong.
- If successful the plugin will be in TitanPlugins as a registered plugin and will be available for display on the Titan bars.
--]]
local result = ""
	local issue = ""
	local id = ""
	local cat = ""
	local ptype = ""
	local notes = ""
	local str = ""

	local self = plugin.self
	--	local isChildButton = (plugin.isChild and true or false)

	if self and self:GetName() then
		--		if (isChildButton) then
		--			-- This is a button within a button
		--			self:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");
		--			self:RegisterForDrag("LeftButton")
		--			TitanPanelDetectPluginMethod(self:GetName(), true);
		--			result = TITAN_REGISTERED
		-- give some indication that this is valid...
		--			id = (self:GetName() or "") .. "<child>"
		--		else
		-- Check for the .registry where all the Titan plugin info is expected
		if (self.registry and self.registry.id) then
			id = self.registry.id
			if TitanUtils_IsPluginRegistered(id) then
				-- We have already registered this plugin!
				issue = "Plugin '" .. tostring(id) .. "' already loaded. "
					.. "Please see if another plugin (Titan or LDB) is also loading "
					.. "with the same name.\n"
					.. "<Titan>.registry.id or <LDB>.label"
			else
				-- A sanity check just in case it was already in the list
				if TitanUtils_TableContainsValue(TitanPluginsIndex, id) then
					str = "In List ??"
				else
					str = "Save .registry"
					-- Herein lies any special per plugin variables Titan wishes to control
					-- These will be overwritten from saved vars, if any
					--
					-- Sanity check
					if self.registry.savedVariables then
						-- Custom labels
						self.registry.savedVariables.CustomLabelTextShow = false
						self.registry.savedVariables.CustomLabelText = ""
						self.registry.savedVariables.CustomLabel2TextShow = false
						self.registry.savedVariables.CustomLabel2Text = ""
						self.registry.savedVariables.CustomLabel3TextShow = false
						self.registry.savedVariables.CustomLabel3Text = ""
						self.registry.savedVariables.CustomLabel4TextShow = false
						self.registry.savedVariables.CustomLabel4Text = ""
					end

					-- Assign and Sort the list of plugins
					TitanPlugins[id] = self.registry;
					-- Set the name used for menus
					if TitanPlugins[id].menuText == nil then
						TitanPlugins[id].menuText = TitanPlugins[id].id;
					end
					TitanPlugins[id].menuText = NoColor(TitanPlugins[id].menuText)

					table.insert(TitanPluginsIndex, self.registry.id);
					table.sort(TitanPluginsIndex,
						function(a, b)
							return string.lower(TitanPlugins[a].menuText)
								< string.lower(TitanPlugins[b].menuText);
						end
					);
				end
			end
			if issue ~= "" then
				result = TITAN_REGISTER_FAILED
			else
				-- We are almost done-
				-- Allow mouse clicks on the plugin
				local pluginID = TitanUtils_GetButtonID(self:GetName());
				local plugin_id = TitanUtils_GetPlugin(pluginID);
				if (plugin_id) then
					self:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");
					self:RegisterForDrag("LeftButton")
					if (plugin_id.id) then
						TitanPanelDetectPluginMethod(plugin_id.id);
					end
				end
				result = TITAN_REGISTERED
				-- determine the plugin category
				cat = (self.registry.category or "General")
				ptype = TITAN_ID -- Assume it is created for Titan
				if self.registry.ldb then
					-- Override the type with the LDB type
					ptype = "LDB: '" .. self.registry.ldb .. "'"
				end
				-- === Right click menu
				local f = CreateFrame("Frame",
					self:GetName() .. TITAN_PANEL_CLICK_MENU_SUFFIX,
					self or nil,
					"UIDropDownMenuTemplate")
			end
			notes = (self.registry.notes or "")
		else
			-- There could be a couple reasons the .registry was not found
			result = TITAN_REGISTER_FAILED
			if (not self.registry) then
				issue = "Can not find registry for plugin (self.registry)"
			end
			if (self.registry and not self.registry.id) then
				issue = "Can not determine plugin name (self.registry.id)"
			end
		end
		--		end
	else
		-- The button could not be determined - the plugin is hopeless
		result = TITAN_REGISTER_FAILED
		issue = "Can not determine plugin button name"
	end

	-- Debug
	if Titan_Global.debug.plugin_register then
		TitanDebug("Plugin RegProt"
			--			.." '"..tostring(self:GetName()).."'"
			.. " '" .. tostring(id) .. "'"
			.. " '" .. tostring(result) .. "'"
			.. " '" .. tostring(str) .. "'"
			.. " '" .. tostring(TitanPlugins[id].id) .. "'"
		)
	end
	-- create and return the results
	local ret_val = {}
	ret_val.issue = (issue or "")
	ret_val.result = (result or TITAN_REGISTER_FAILED)
	ret_val.id = (id or "")
	ret_val.cat = (cat or "General")
	ret_val.ptype = ptype
	ret_val.notes = notes
	return ret_val
end

---Titan Attempt to register a plugin that has requested to be registered
--- Lets be extremely paranoid here because registering plugins that do not play nice can cause real headaches...
---@param plugin table Plugin frame - Titan template
function TitanUtils_RegisterPlugin(plugin)
	local call_success, ret_val
	-- Ensure we have a glimmer of a plugin and that the plugin has not
	-- already been registered.
	if plugin and plugin.status == TITAN_NOT_REGISTERED then
		-- See if the request to register has a shot at success
		if plugin.self then
			-- Just in case, catch any errors
			call_success, -- needed for pcall
			ret_val = -- actual return values
				pcall(TitanUtils_RegisterPluginProtected, plugin)
			-- pcall does not allow errors to propagate out. Any error
			-- is returned as text with the success / fail.
			-- Think of it as a try - catch block
			if call_success then
				-- all is good so write the return values to the plugin
				plugin.status = ret_val.result
				plugin.issue = ret_val.issue
				plugin.name = ret_val.id
				plugin.category = ret_val.cat
				plugin.notes = ret_val.notes
				plugin.plugin_type = ret_val.ptype
			else
				-- write enough to the plugin so the user or developer
				-- can see Titan at least tried...
				plugin.status = TITAN_REGISTER_FAILED
				plugin.issue = (ret_val.issue or "Unknown error")
				plugin.name = "?"
				plugin.notes = ret_val.notes or ""
			end
		else
			-- write enough to the plugin so the user or developer can see something
			plugin.status = TITAN_REGISTER_FAILED
			plugin.issue = "Can not determine plugin button name"
			plugin.name = "?"
		end

		-- If there was an error tell the user.
		if not plugin.issue == ""
			or plugin.status ~= TITAN_REGISTERED then
			TitanPrint(TitanUtils_GetRedText("Error Registering Plugin")
				.. TitanUtils_GetGreenText(
					": "
					.. "name: '" .. (plugin.name or "?_") .. "' "
					.. "issue: '" .. (plugin.issue or "?_") .. "' "
					.. "button: '" .. plugin.button .. "' "
				)
				, "error")
		end

		-- Debug
		if Titan_Global.debug.plugin_register then
			local status = plugin.status
			if plugin.status == TITAN_REGISTER_FAILED then
				status = TitanUtils_GetRedText(status)
			else
				status = TitanUtils_GetGreenText(status)
			end
			TitanDebug("Registering Plugin"
				.. " " .. tostring(plugin.name) .. ""
				.. " " .. tostring(status) .. ""
			)
		end
	end
end

---Titan Attempt to register the list of plugins that have requested to be registered
--- Tell the user when this starts and ends only on the first time.
--- This could be called if a plugin requests to be registered after the first loop through.
function TitanUtils_RegisterPluginList()
	-- Loop through the plugins that have requested to be loaded into Titan.
	local result = ""
	local issue = ""
	local id
	local cnt = 0
	if TitanPluginToBeRegisteredNum > 0 then
		if not Titan__InitializedPEW and TitanAllGetVar("Registered") then
			TitanDebug(L["TITAN_PANEL_REGISTER_START"], "normal")
		end
		for index, value in ipairs(TitanPluginToBeRegistered) do
			if TitanPluginToBeRegistered[index] then
				TitanUtils_RegisterPlugin(TitanPluginToBeRegistered[index])
			end
			cnt = cnt + 1
		end
		if not Titan__InitializedPEW and TitanAllGetVar("Registered") then
			TitanDebug((L["TITAN_PANEL_REGISTER_END"] .. " " .. cnt), "normal")
		end
	end
end

---API See if the given plugin was registered successfully.
---@param id string Plugin id
---@return boolean registered True if registered; False if not
function TitanUtils_IsPluginRegistered(id)
	if (id and TitanPlugins[id]) then
		return true;
	else
		return false;
	end
end

--====== Right click menu routines for Titan Panel bars and plugins

---Titan Close the right click menu of any plugin, if it was open. Only one can be open at a time.
function TitanUtils_CloseRightClickMenu()
	if (_G["DropDownList1"]:IsVisible()) then
		_G["DropDownList1"]:Hide();
	end
end

---local Prepare the plugin right click menu using the function given by the plugin OR Titan bar.
---@param self table Titan Bar or Plugin frame
--- See the routine for details on determining the menu function.
--- UIDropDownMenu_Initialize will place (part of) the error in the menu - it is not progagated out.
--- Set Titan_Global.debug.menu to output the error to Chat.
local function TitanRightClickMenu_OnLoad(self)
--[[
- The function to create the menu is either
1. set in registry in .menuTextFunction
: New in 2024 Feb to make the routine explicit (UIDropDownMenu_Initialize appears to be 'safe')
: If a function then the routine can be local or in the global namespace
: If a string then the routine MUST be in the global namespace.
2. assumed to be "TitanPanelRightClickMenu_Prepare"..plugin_id.."Menu" : This is the way Titan was written
- TitanUtils_GetButtonIDFromMenu returns a generic "Bar" when the user clicks on a Titan bar.
  This works because every Titan bar uses the same menu allowing one routine to be reused.
--]]
	local id = TitanUtils_GetButtonIDFromMenu(self) -- "Bar" if self is any Titan bar
	local err = ""
	if id then
		local frame = TitanUtils_GetPlugin(id) -- get plugin frame
		local prepareFunction -- function to call

		if frame and frame.menuTextFunction then
			prepareFunction = frame.menuTextFunction -- Newer method 2024 Feb
		else
			-- If 'bar' then routine for ALL Titan bars
			prepareFunction = "TitanPanelRightClickMenu_Prepare" .. id .. "Menu"
		end

		if type(prepareFunction) == 'string' then
			-- Function MUST be in global namespace
			-- Becomes nil if not found
			prepareFunction = _G[prepareFunction]
		elseif type(prepareFunction) == 'function' then
			-- Can be global or local to the plugin
		else
			-- Invalid type, do not even try...
			prepareFunction = nil
		end

		if prepareFunction then
			UIDropDownMenu_Initialize(self, prepareFunction, "MENU")
		else
			err = "Could not display tooltip. "
				.. "No function for '" .. tostring(id) .. "' "
				.. "[" .. tostring(type(prepareFunction)) .. "] "
				.. "[" .. tostring(prepareFunction) .. "] "
				.. ". "
		end
	else
		err = "Could not display tooltip. "
			.. "Unknown Titan ID for "
			.. "'" .. (self:GetName() or "?") .. "'. "
	end

	if Titan_Global.debug.menu then
		if err == "" then
			-- all is good
		else
			TitanDebug(err, "error")
		end
	end
	-- Under the cover the menu is built as DropDownList1
	return DropDownList1, DropDownList1:GetHeight(), DropDownList1:GetWidth()
end

---Titan Call the routine to build the plugin menu then place it properly.
--- This routine is for Titan plugins. There is a similar routine for the Titan bar.
---@param self table Plugin frame
function TitanPanelRightClickMenu_Toggle(self)
	-- Mar 2023 : Rewritten to place menu relative to the passed in frame (button)
	-- There are two places for the menu creation routine
	-- 1) Titan bar - creates same menu
	-- 2) Plugin creation via the .registry
	local frame = self:GetName()
	local menu = _G[self:GetName() .. TITAN_PANEL_CLICK_MENU_SUFFIX]
	--[[
print("_ toggle R menu"
.." "..tostring(frame)..""
)
--]]
	-- Create menu based on the frame's routine for right click menu
	local drop_menu, menu_height, menu_width = TitanRightClickMenu_OnLoad(menu)

	-- Adjust the Y offset as needed
	local rel_y = _G[frame]:GetTop() - menu_height
	if rel_y > 0 then
		menu.point = "TOP";
		menu.relativePoint = "BOTTOM";
	else
		-- too close to bottom of screen
		menu.point = "BOTTOM";
		menu.relativePoint = "TOP";
	end

	-- Adjust the X offset as needed
	local x_offset = 0
	local left = 0
	if TitanBarData[frame] then
		-- on a Titan bar so use cursor for the 'left'
		left = GetCursorPosition() -- get x; ignore y
		left = left / UIParent:GetEffectiveScale()
		-- correct for beginning of Titan bar
		left = left - _G[frame]:GetLeft()
	else
		-- a plugin
		left = _G[frame]:GetLeft()
	end
	local rel_x = left + menu_width
	if (rel_x < GetScreenWidth()) then
		-- menu will fit
		menu.point = menu.point .. "LEFT";
		menu.relativePoint = menu.relativePoint .. "LEFT";

		if TitanBarData[frame] then
			x_offset = left
		else
			-- a plugin
			x_offset = 0
		end
	else
		-- Menu would go off right side of the screen
		menu.point = menu.point .. "RIGHT";
		menu.relativePoint = menu.relativePoint .. "RIGHT";

		if TitanBarData[frame] then
			-- correct is on Titan bar (bottom, far right)
			-- flip calc since we flipped the anchor to right
			x_offset = GetScreenWidth() - left
		else
			-- a plugin
			x_offset = 0
		end
	end
	--[[
print("RCM"
.." "..tostring(frame)..""
.." "..tostring(format("%0.1f", menu_height))..""
.." "..tostring(format("%0.1f", menu_width))..""
.." "..tostring(format("%0.1f", _G[frame]:GetLeft()))..""
.." "..tostring(menu.point)..""
.." "..tostring(menu.relativePoint)..""
.." "..tostring(format("%0.1f", left))..""
)
--]]
	if TITAN_ID == "TitanClassic" then
		L_ToggleDropDownMenu(1, nil, menu, frame, TitanUtils_Max(x_offset - 40, 0), 0, nil, self)
	else
		ToggleDropDownMenu(1, nil, menu, frame, x_offset, 0, nil, self);
	end
end

---Titan Determine if a right click menu is shown. There can only be one.
---@return boolean IsVisible
function TitanPanelRightClickMenu_IsVisible()
	local res = false
	if _G[drop_down_1] and _G[drop_down_1]:IsVisible() then
		res = true
	else
		res = false
	end
	return res
end

---Titan Close the right click menu if shown. There can only be one.
function TitanPanelRightClickMenu_Close()
	if _G[drop_down_1] and _G[drop_down_1]:IsVisible() then
		_G[drop_down_1]:Hide()
	end
end

--====== Titan utility routines

---Titan Parse the Titan player / profile name and return the parts.
---@param name string Titan player / profile name
---@return string player_name or ""
---@return string server_name or ""
function TitanUtils_ParseName(name)
	local server = ""
	local player = ""
	if name and name ~= TITAN_PROFILE_NONE then
		local s, e, ident = string.find(name, TITAN_AT);
		if s ~= nil then
			server = string.sub(name, s + 1);
			player = string.sub(name, 1, s - 1);
		end
	else
	end
	return player, server
end

---Titan Given the player name and server and return the Titan player name; also used as profile name.
---@param player string
---@param realm string realm name or default
---@return string toon <player>@<realm>
function TitanUtils_CreateName(player, realm)
	local p1 = player or "?"
	local p2 = realm or "?"

	return p1 .. TITAN_AT .. p2
end

---Titan Create the character name / toon being played and return the parts.
---@return string toon name or "<>"
---@return string player_name or ""
---@return string server_name or ""
function TitanUtils_GetPlayer()
	local playerName = UnitName("player");
	local serverName = GetRealmName();
	local toon = "<>"

	if (playerName == nil
			or serverName == nil
			or playerName == UKNOWNBEING) then
		-- Do nothing if player name is not available
	else
		toon = playerName .. TITAN_AT .. serverName
	end

	return toon, playerName, serverName
end

---Titan Return the global profile setting and the global profile name, if any.
---@return boolean global_in_use
---@return string profile name or "<>"
---@return string player_name or ""
---@return string server_name or ""
function TitanUtils_GetGlobalProfile()
	local playerName = ""
	local serverName = ""
	local glob = TitanAllGetVar("GlobalProfileUse")
	local toon = TitanAllGetVar("GlobalProfileName")

	if not toon then
		-- this is a new install or toon
		toon = TITAN_PROFILE_NONE
		TitanAllSetVar("GlobalProfileName", TITAN_PROFILE_NONE)
	end
	if (toon == TITAN_PROFILE_NONE) then
		--
	else
		-- If the profile name is not the default then split the name
		playerName, serverName = TitanUtils_ParseName(toon)
	end

	return glob, toon, playerName, serverName
end

---Titan Return the global profile setting and the global profile name, if any.
---@param glob boolean Use global profile
---@param toon string? Global profile name or default
function TitanUtils_SetGlobalProfile(glob, toon)
	TitanAllSetVar("GlobalProfileUse", glob)
	if glob then
		-- The user asked for global
		if toon == nil or toon == TITAN_PROFILE_NONE then
			-- nothing was set before so use current player
			toon = TitanUtils_GetPlayer()
		end
	end
	TitanAllSetVar("GlobalProfileName", toon or TITAN_PROFILE_NONE)
end

---Titan Return the screen size after scaling
---@return table screenXY { x | y | scaled_x | scaled_y } all numbers
function TitanUtils_ScreenSize()
	local screen = {}
	screen.x = UIParent:GetRight()
	screen.y = UIParent:GetTop()
	screen.scaled_x = UIParent:GetRight() * UIParent:GetEffectiveScale()
	screen.scaled_y = UIParent:GetTop() * UIParent:GetEffectiveScale()

	--[[
	if output then
		local x = UIParent:GetRight()
		local y = UIParent:GetTop()
		local s = UIParent:GetEffectiveScale()
		local px, py = GetPhysicalScreenSize()
		print("_ScreenSize"
			.. "\n"
			.. " UI - x:" .. tostring(format("%0.1f", x)) .. ""
			.. " X y:" .. tostring(format("%0.1f", y)) .. ""
			.. "\n"
			.. " UI scaled - x:" .. tostring(format("%0.1f", screen.x * UIParent:GetEffectiveScale())) .. ""
			.. " X y:" .. tostring(format("%0.1f", screen.y * UIParent:GetEffectiveScale())) .. ""
			.. "\n"
			.. " Scale: UI" .. tostring(format("%0.6f", s)) .. ""
			.. " Titan " .. tostring(format("%0.1f", TitanPanelGetVar("Scale"))) .. ""
			.. "\n"
			.. " screen - x:" .. tostring(format("%0.1f", px)) .. ""
			.. " X y:" .. tostring(format("%0.1f", py)) .. ""
		)
	end
--]]

	return screen
end

--------------------------------------------------------------
-- Various debug routines
--[[
local function Debug_array(message)
local idx = TitanDebugArray.index
	TitanDebugArray.index = mod(TitanDebugArray.index + 1, TITAN_PANEL_DEBUG_ARRAY_MAX)
	TitanDebugArray.lines[TitanDebugArray.index] = (date("%m/%d/%y %H:%M:%S".." : ")..message)
end
--]]

---Titan Get the Titan version as a string.
---@return string version
function TitanPanel_GetVersion()
	return tostring(TitanUtils_GetAddOnMetadata(TITAN_ID, "Version")) or L["TITAN_PANEL_NA"];
end

---Titan: Output a message safely to the user in a consistent format.
---@param message string Message to output ot Chat
---@param msg_type string? "info" | "warning" | "error" | "plain" | nil
function TitanPrint(message, msg_type)
	local dtype = ""
	local pre = TitanUtils_GetGoldText(L["TITAN_PANEL_PRINT"] .. ": ")
	local msg = ""
	if msg_type == "error" then
		dtype = TitanUtils_GetRedText("Error: ")
	elseif msg_type == "warning" then
		dtype = "|cFFFFFF00" .. "Warning: " .. _G["FONT_COLOR_CODE_CLOSE"]
	elseif msg_type == "plain" then
		pre = ""
	elseif msg_type == "header" then
		local ver = TitanPanel_GetVersion()
		pre = TitanUtils_GetGoldText(L["TITAN_PANEL"])
			.. TitanUtils_GetGreenText(" " .. ver)
			.. TitanUtils_GetGoldText(L["TITAN_PANEL_VERSION_INFO"]
			)
	end

	msg = pre .. dtype .. TitanUtils_GetGreenText(tostring(message))
	DEFAULT_CHAT_FRAME:AddMessage(msg)
	--	Debug_array(msg)
end

---Titan: Output a debug message safely in a consistent format.
---@param debug_message string Message to output to Chat
---@param debug_type string? "warning" | "error" | "normal" | nil
function TitanDebug(debug_message, debug_type)
	local dtype = ""
	local time_stamp = ""
	local msg = ""
	if debug_type == "error" then
		dtype = TitanUtils_GetRedText("Error: ")
	elseif debug_type == "warning" then
		dtype = TitanUtils_GetHighlightText("Warning: ")
	end
	if debug_type == "normal" then
		time_stamp = ""
	else
		time_stamp = TitanUtils_GetGoldText(date("%H:%M:%S") .. ": ")
	end
	if debug_message == true then
		debug_message = "<true>";
	end
	if debug_message == false then
		debug_message = "<false>";
	end
	if debug_message == nil then
		debug_message = "<nil>";
	end

	msg =
		TitanUtils_GetGoldText(L["TITAN_PANEL_DEBUG"] .. " ")
		.. tostring(time_stamp)
		.. tostring(dtype)
		--		..TitanUtils_GetBlueText(debug_message)
		.. TitanUtils_GetHexText(tostring(debug_message), "1DA6C5")

	if not TitanAllGetVar("Silenced") then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(msg)
	end
	--	Debug_array(msg)
	--date("%m/%d/%y %H:%M:%S")
end

---API: Output a debug message in a consistent format.
---@param id string Plugin id
---@param debug_message string Message to output to Chat
function TitanPluginDebug(id, debug_message)
	local msg =
		TitanUtils_GetGoldText("<" .. tostring(id) .. "> " .. date("%H:%M:%S"))
		.. " " .. TitanUtils_GetHexText(tostring(debug_message), "1DA6C5")

	_G["DEFAULT_CHAT_FRAME"]:AddMessage(msg)
end

---Titan: Output the current list of registered plugins.
function TitanDumpPluginList()
	-- Just dump the current list of plugins
	local plug_in = {}
	for idx, value in pairs(TitanPluginsIndex) do
		plug_in = TitanUtils_GetPlugin(TitanPluginsIndex[idx])
		if plug_in then
			TitanDebug("TitanDumpPluginList "
				.. "'" .. tostring(idx) .. "'"
				.. ": '" .. tostring(plug_in.id) .. "'"
				.. ": '" .. tostring(plug_in.version) .. "'"
			)
		end
	end
end

---Titan: Output the current list of known characters / toons.
function TitanDumpPlayerList()
	local cnt = 0
	TitanDebug("TitanDumpPlayerList ==== start")
	if TitanSettings.Players then
		for idx, value in pairs(TitanSettings.Players) do
			TitanDebug("-- "
				.. "'" .. tostring(idx) .. "'"
			)
			cnt = cnt + 1
		end
	else
		TitanDebug("No player list found!!! "
		)
	end
	TitanDebug("TitanDumpPlayerList ==== done " .. cnt)
end

---Titan: Output the frame name, if known,and its parent name.
---@param self table Any frame
function TitanDumpFrameName(self)
	local frame
	local parent
	if self then
		frame = self:GetName()
	else
		frame = "?"
	end
	if frame == "?" then
		parent = "?"
	else
		parent = self:GetParent():GetName()
	end
	--[
	TitanDebug("_GetFrameName "
		.. tostring(self and "T" or "F") .. " "
		.. tostring(frame) .. " "
		.. tostring(parent) .. " "
	)
	--]]
end

---Titan: Output the value of Titan timer saved variables.TODO : (Needs Classic update!!)
function TitanDumpTimers()
	local str = "Titan-timers: "
		.. "'" .. tostring(TitanAllGetVar("TimerLDB")) .. "' "
	TitanPrint(str, "plain")
end

---Titan: Output an event and args 1 - 6.
---@param event string
---@param a1 any Argument 1
---@param a2 any Argument 2
---@param a3 any Argument 3
---@param a4 any Argument 4
---@param a5 any Argument 5
---@param a6 any Argument 6
function TitanArgConvert(event, a1, a2, a3, a4, a5, a6)
	local t1 = type(a1)
	local t2 = type(a2)
	local t3 = type(a3)
	local t4 = type(a4)
	local t5 = type(a5)
	local t6 = type(a6)
	TitanDebug(tostring(event) .. " "
		.. "1: " .. tostring(a1) .. "(" .. tostring(t1) .. ") "
		.. "2: " .. tostring(a2) .. "(" .. tostring(t2) .. ") "
		.. "3: " .. tostring(a3) .. "(" .. tostring(t3) .. ") "
		.. "4: " .. tostring(a4) .. "(" .. tostring(t4) .. ") "
		.. "5: " .. tostring(a5) .. "(" .. tostring(t5) .. ") "
		.. "6: " .. tostring(a6) .. "(" .. tostring(t6) .. ") "
	)
end

---Titan: Output a given table; up to a depth of 8 levels.
---@param tb table
---@param level integer? 1 or defaults to 1
function TitanDumpTable(tb, level)
	level = level or 1
	local spaces = string.rep(' ', level * 2)
	for k, v in pairs(tb) do
		if type(v) ~= "table" then
			print("[" .. level .. "]v'" .. spaces .. "[" .. tostring(k) .. "]='" .. tostring(v) .. "'")
		else
			print("[" .. level .. "]t'" .. spaces .. "[" .. tostring(k) .. "]")
			level = level + 1
			if level <= 8 then
				TitanDumpTable(v, level)
			end
		end
	end
end

--====== Deprecated routines
-- These routines will be commented out for a couple releases then deleted.
--
--[===[

Below 2024 Mar

This routine is really broken... unlikely it worked.
--[[   API
NAME: TitanPanelRightClickMenu_AddToggleColoredText
DESC: This will toggle the "ShowColoredText" Titan variable then update the button
VAR: id - id of the plugin
VAR: level - level to put the line
OUT:  None
--]]
function TitanPanelRightClickMenu_ToggleColoredText(value)
	TitanToggleVar(value, "ShowColoredText");
	TitanPanelButton_UpdateButton(value, 1);
end

---API Check if all the variables in the table are nil/false.
---@param id string Plugin id
---@param toggleTable table {}
---@return boolean all_nil true (1) or nil
function TitanPanelRightClickMenu_AllVarNil(id, toggleTable)
	if ( toggleTable ) and type(toggleTable)== "table" then
		for i, v in toggleTable do
			if ( TitanGetVar(id, v) ) then
				return nil;
			end
		end
		return 1;
	end
end

--]===]
