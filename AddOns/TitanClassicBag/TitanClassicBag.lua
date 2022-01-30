-- **************************************************************************
-- * TitanBag.lua
-- *
-- * By: TitanMod, Dark Imakuni, Adsertor and the Titan Panel Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_BAG_ID = "Bag";
local TITAN_BAG_THRESHOLD_TABLE = {
	Values = { 0.5, 0.75, 0.9 },
	Colors = { HIGHLIGHT_FONT_COLOR, NORMAL_FONT_COLOR, ORANGE_FONT_COLOR, RED_FONT_COLOR },
}
local updateTable = {TITAN_BAG_ID, TITAN_PANEL_UPDATE_BUTTON};
-- ******************************** Variables *******************************
local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)
local AceTimer = LibStub("AceTimer-3.0")
local BagTimer
-- ******************************** Functions *******************************

--[[
-- **************************************************************************
-- NAME : IsAmmoPouch(name)
-- DESC : Test to see if bag is an ammo pouch
-- VARS : name = item name
-- **************************************************************************
--]]
local function IsAmmoPouch(name)
	local bagType = ""
	local color = {r=1,g=1,b=1}; -- WHITE
	local ammo = false
	if (name) then
		for index, value in pairs(L["TITAN_BAG_AMMO_POUCH_NAMES"]) do
			if (string.find(name, value)) then
				ammo = true
				bagType = "AMMO"
				color = {r=1,g=1,b=1}; -- WHITE
			end
		end
	end
--[[
TitanDebug("IsAmmoPouch"
.." "..tostring(ammo)
.." "..tostring(bagType)
.." "..tostring(used)
)
--]]
	return ammo, bagType, color
end

--[[
-- **************************************************************************
-- NAME : IsShardBag(name)
-- DESC : Test to see if bag is a shard bag
-- VARS : name = item name
-- **************************************************************************
--]]
local function IsShardBag(name)
	local bagType = ""
	local color = {r=1,g=1,b=1}; -- WHITE
	local shard = false
	if (name) then
		for index, value in pairs(L["TITAN_BAG_SHARD_BAG_NAMES"]) do
			if (string.find(name, value)) then
				shard = true
				bagType = "SHARD"
				color = {r=1,g=1,b=1}; -- WHITE
				return bagType, color;
			end
		end
	end
	return shard, bagType, color
end

--[[
-- **************************************************************************
-- NAME : IsProfBag(name)
-- DESC : Test to see if bag is a profession bag
-- VARS : name = item name
-- **************************************************************************
--]]
local function IsProfBag(name)
	local bagType = ""
	local color = {r=1,g=1,b=1}; -- WHITE
	local prof = false
	-- each if returns if bag name is found, cleaner but could be confusing
	if (name) then
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_ENCHANTING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "ENCHANTING";
				color = {r=0,g=0,b=1}; -- BLUE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_ENGINEERING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "ENGINEERING";
				color = {r=1,g=0.49,b=0.04}; -- ORANGE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_HERBALISM"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "HERBALISM";
				color = {r=0,g=1,b=0}; -- GREEN
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_INSCRIPTION"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "INSCRIPTION";
				color = {r=0.58,g=0.51,b=0.79}; -- PURPLE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_JEWELCRAFTING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "JEWELCRAFTING";
				color = {r=1,g=0,b=0}; -- RED
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_LEATHERWORKING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "LEATHERWORKING";
				color = {r=0.78,g=0.61,b=0.43}; -- TAN
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_MINING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "MINING";
				color = {r=1,g=1,b=1}; -- WHITE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_FISHING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "FISHING";
				color = {r=0.41,g=0.8,b=0.94}; -- LIGHT_BLUE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_COOKING"]) do
			if (string.find(name, value, 1, true)) then
				prof = true
				bagType = "COOKING";
				color = {r=0.96,g=0.55,b=0.73}; -- PINK
				return bagType, color;
			end
		end
	end
	return prof, bagType, color
end

--[[
-- **************************************************************************
-- NAME : CountMe(name)
-- DESC : Test to see if bag should be counted
-- VARS : name = item name
-- **************************************************************************
--]]
local function CountMe(bag)
	-- defaults as if bag does not exist
	local name = (GetBagName(bag) or "")
	local size = (GetContainerNumSlots(bag) or 0)
	local bagType = ""
	local color = {r=1,g=1,b=1} -- WHITE
	local used = 0
	local countme = false
	local useme = false
	local bt = ""
	local c = {}

	if name ~= "" then -- a bag is in the slot
		-- check for a special storage bag
		useme, bt, c = IsAmmoPouch(name)
		if useme then
			bagType = bt
			color = c
			if (TitanGetVar(TITAN_BAG_ID, "CountAmmoPouchSlots")) then
				countme = true
			else -- found the bag but do not count any slots
			end
		else -- check next type
		end
		useme, bt, c = IsShardBag(name)
		if useme then
			bagType = bt
			color = c
			if (TitanGetVar(TITAN_BAG_ID, "CountShardBagSlots")) then
				countme = true
			else -- found the bag but do not count any slots
			end
		else -- check next type
		end
		useme, bt, c = IsProfBag(name)
		if useme then
			bagType = bt
			color = c
			if (TitanGetVar(TITAN_BAG_ID, "CountProfBagSlots")) then
				countme = true
			else -- found the bag but do not count any slots
			end
		else -- check next type
		end
		if (bagType == "") then -- not a special bag
			countme = true
			bagType = "NORMAL"
		end
		-- Collect the slots IF we should count it
		if (countme) then
			for slot = 1, size do
				if (GetContainerItemInfo(bag, slot)) then
					used = used + 1;
				end
			end
		else
			-- Should *not* be counted
		end
	end
--[[
TitanDebug("CountMe"
.." "..tostring(bag)
.." '"..tostring(name).."'"
.." "..tostring(bagType)
.." "..tostring(size)
.." "..tostring(used)
.." "..tostring(countme)
)
--]]
	return {countme = countme,
		size = size, 
		used = used, 
		bagType = bagType,
		name = name, 
		color = color}
end
--]]

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelBagButton_OnLoad(self)
	self.registry = {
		id = TITAN_BAG_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_BAG_MENU_TEXT"],
		buttonTextFunction = "TitanPanelBagButton_GetButtonText",
		tooltipTitle = L["TITAN_BAG_TOOLTIP"],
		tooltipTextFunction = "TitanPanelBagButton_GetTooltipText",
		icon = "Interface\\AddOns\\TitanClassicBag\\TitanClassicBag",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			ShowUsedSlots = 1,
			ShowDetailedInfo = false,
			CountAmmoPouchSlots = false,
			CountShardBagSlots = false,
			CountProfBagSlots = false,
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
			DisplayOnRightSide = false,
		}
	};

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnEvent()
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
function TitanPanelBagButton_OnEvent(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") and (not self:IsEventRegistered("BAG_UPDATE")) then
		self:RegisterEvent("BAG_UPDATE");
	end

	if event == "BAG_UPDATE" then
		-- Create only when the event is active
		self:SetScript("OnUpdate", TitanPanelBagButton_OnUpdate)
	end
end

function TitanPanelBagButton_OnUpdate(self)
	-- update the button
	TitanPanelPluginHandle_OnUpdate(updateTable)
	-- remove until the next bag event
	self:SetScript("OnUpdate", nil)
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnClick(button)
-- DESC : Opens all bags on a LeftClick
-- VARS : button = value of action
-- **************************************************************************
function TitanPanelBagButton_OnClick(self, button)
	if (button == "LeftButton") then
		ToggleAllBags();
	end
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_GetButtonText(id)
-- DESC : Calculate bag space logic then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelBagButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);
	local totalBagSlots, usedBagSlots, availableBagSlots, bag, bagText, bagRichText, color;
	local totalProfBagSlots = {0,0,0,0,0};
	local usedProfBagSlots = {0,0,0,0,0};
	local availableProfBagSlots = {0,0,0,0,0};
	local bagRichTextProf = {"","","","",""};
	local bagInfo = {}

	totalBagSlots = 0;
	usedBagSlots = 0;
	bagRichText = ""
	for bag = 0, 4 do
		local info = CountMe(bag)
		if info.countme then
			if info.bagType == "NORMAL" then
				usedBagSlots = usedBagSlots + info.used
				totalBagSlots = totalBagSlots + info.size
			else -- process special storage bag
				totalProfBagSlots[bag+1] = info.size
				usedProfBagSlots[bag+1] = info.used
				availableProfBagSlots[bag+1] = info.size - info.used
				-- prepare text for the special bag
				if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
					bagText = "  [" .. format(L["TITAN_BAG_FORMAT"], usedProfBagSlots[bag+1], totalProfBagSlots[bag+1]) .. "]";
				else
					bagText = "  [" .. format(L["TITAN_BAG_FORMAT"], availableProfBagSlots[bag+1], totalProfBagSlots[bag+1]) .. "]";
				end
				if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
					bagRichTextProf[bag+1] = TitanUtils_GetColoredText(bagText, info.color);
				else
					bagRichTextProf[bag+1] = TitanUtils_GetHighlightText(bagText);
				end
			end
		else
			-- no bag in slot
		end
	end
	-- process normal bags as one set
	availableBagSlots = totalBagSlots - usedBagSlots;

	if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
		bagText = format(L["TITAN_BAG_FORMAT"], usedBagSlots, totalBagSlots);
	else
		bagText = format(L["TITAN_BAG_FORMAT"], availableBagSlots, totalBagSlots);
	end

	if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
		color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, usedBagSlots / totalBagSlots);
		bagRichText = TitanUtils_GetColoredText(bagText, color);
	else
		bagRichText = TitanUtils_GetHighlightText(bagText);
	end

	bagRichText = bagRichText..bagRichTextProf[1]..bagRichTextProf[2]..bagRichTextProf[3]..bagRichTextProf[4]..bagRichTextProf[5];
	return L["TITAN_BAG_BUTTON_LABEL"], bagRichText;
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
function TitanPanelBagButton_GetTooltipText()
	local totalSlots, usedSlots, availableSlots;
	local returnstring = "";

	if TitanGetVar(TITAN_BAG_ID, "ShowDetailedInfo") then
		returnstring = "\n";
		if TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots") then
			returnstring = returnstring..TitanUtils_GetNormalText(L["TITAN_BAG_MENU_TEXT"])
				..":\t"..TitanUtils_GetNormalText(L["TITAN_BAG_USED_SLOTS"])..":\n";
		else
			returnstring = returnstring..TitanUtils_GetNormalText(L["TITAN_BAG_MENU_TEXT"])
				..":\t"..TitanUtils_GetNormalText(L["TITAN_BAG_FREE_SLOTS"])..":\n";
		end

		for bag = 0, 4 do
			totalSlots = GetContainerNumSlots(bag) or 0;
			availableSlots = GetContainerNumFreeSlots(bag) or 0;
			usedSlots = totalSlots - availableSlots;
			local itemlink  = bag > 0 and GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) 
				or TitanUtils_GetHighlightText(L["TITAN_BAG_BACKPACK"]).. FONT_COLOR_CODE_CLOSE;

			if itemlink then
				itemlink = string.gsub( itemlink, "%[", "" );
				itemlink = string.gsub( itemlink, "%]", "" );
			end

			if bag > 0 and not GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) then
				itemlink = nil;
			end

			local bagText, bagRichText, color;
			if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
				bagText = format(L["TITAN_BAG_FORMAT"], usedSlots, totalSlots);
			else
				bagText = format(L["TITAN_BAG_FORMAT"], availableSlots, totalSlots);
			end

			if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
				if totalSlots == 0 then
					color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, 1 );
				else
					color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, usedSlots / totalSlots);
				end
				bagRichText = TitanUtils_GetColoredText(bagText, color);
			else
				bagRichText = TitanUtils_GetHighlightText(bagText);
			end

			if itemlink then
				returnstring = returnstring..itemlink.."\t"..bagRichText.."\n";
			end
		end
		returnstring = returnstring.."\n";
	end
	return returnstring..TitanUtils_GetGreenText(L["TITAN_BAG_TOOLTIP_HINTS"]);
end

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareBagMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareBagMenu()
	local info
	-- level 2
	if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"])
			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_USED_SLOTS"];
			info.func = TitanPanelBagButton_ShowUsedSlots;
			info.checked = TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS"];
			info.func = TitanPanelBagButton_ShowAvailableSlots;
			info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots"));
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_DETAILED"];
			info.func = TitanPanelBagButton_ShowDetailedInfo;
			info.checked = TitanGetVar(TITAN_BAG_ID, "ShowDetailedInfo");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end
--[[
		if _G["UIDROPDOWNMENU_MENU_VALUE"] == "IgnoreCont" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_BAG_MENU_IGNORE_SLOTS"], _G["UIDROPDOWNMENU_MENU_LEVEL"])
			info = {};
			info.text = L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"];
			info.func = TitanPanelBagButton_ToggleIgnoreProfBagSlots;
			info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "CountProfBagSlots"));
			UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);
		end
--]]
		return
	end
	
	-- level 1
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_BAG_ID].menuText);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_OPTIONS"];
	info.value = "Options"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);
--[[
	info = {};
	info.notCheckable = true
	info.text = L["TITAN_BAG_MENU_IGNORE_SLOTS"];
	info.value = "IgnoreCont"
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);
--]]
	TitanPanelRightClickMenu_AddSpacer();
	info = {};
	info.text = L["TITAN_BAG_MENU_IGNORE_AMMO_POUCH_SLOTS"];
	info.func = TitanPanelBagButton_ToggleIgnoreAmmoPouchSlots;
	info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "CountAmmoPouchSlots"));
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

	info = {};
	info.text = L["TITAN_BAG_MENU_IGNORE_SHARD_BAGS_SLOTS"];
	info.func = TitanPanelBagButton_ToggleIgnoreShardBagSlots;
	info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "CountShardBagSlots"));
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

	info = {};
	info.text = L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"];
	info.func = TitanPanelBagButton_ToggleIgnoreProfBagSlots;
	info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "CountProfBagSlots"));
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddToggleRightSide(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_BAG_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ShowUsedSlots()
-- DESC : Set option to show used slots
-- **************************************************************************
function TitanPanelBagButton_ShowUsedSlots()
	TitanSetVar(TITAN_BAG_ID, "ShowUsedSlots", 1);
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ShowAvailableSlots()
-- DESC : Set option to show available slots
-- **************************************************************************
function TitanPanelBagButton_ShowAvailableSlots()
	TitanSetVar(TITAN_BAG_ID, "ShowUsedSlots", nil);
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ToggleIgnoreAmmoPouchSlots()
-- DESC : Set option to count ammo pouch slots
-- **************************************************************************
function TitanPanelBagButton_ToggleIgnoreAmmoPouchSlots()
	TitanToggleVar(TITAN_BAG_ID, "CountAmmoPouchSlots");
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ToggleIgnoreShardBagSlots()
-- DESC : Set option to count shard bag slots
-- **************************************************************************
function TitanPanelBagButton_ToggleIgnoreShardBagSlots()
	TitanToggleVar(TITAN_BAG_ID, "CountShardBagSlots");
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ToggleIgnoreProfBagSlots()
-- DESC : Set option to count profession bag slots
-- **************************************************************************
function TitanPanelBagButton_ToggleIgnoreProfBagSlots()
	TitanToggleVar(TITAN_BAG_ID, "CountProfBagSlots");
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

function TitanPanelBagButton_ShowDetailedInfo()
	TitanToggleVar(TITAN_BAG_ID, "ShowDetailedInfo");
end
