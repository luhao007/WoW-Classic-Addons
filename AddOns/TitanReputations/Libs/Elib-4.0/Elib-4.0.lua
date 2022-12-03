--[[
	Description: Titan Panel Lib. Be careful editing it, all plugins can stop working.
	Author: Eliote
--]]

local MAJOR, MINOR = "Elib-4.0", 12
local Elib = LibStub:NewLibrary(MAJOR, MINOR)
if not Elib then return end

local AceLocale = LibStub("AceLocale-3.0")
local Titan_L = AceLocale:GetLocale(TITAN_ID, true)

---@type ElioteDropDownMenu
local EDDM = LibStub("ElioteDropDownMenu-1.0")
local menuFrame = EDDM.UIDropDownMenu_GetOrCreate("ElibDropDown")

-- TBC Classic compatibility
local CreateColorFromHexString = CreateColorFromHexString
if not CreateColorFromHexString then
	local function ExtractColorValueFromHex(str, index)
		return tonumber(str:sub(index, index + 1), 16) / 255;
	end

	function CreateColorFromHexString(hexColor)
		if #hexColor == 8 then
			local a, r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3), ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
			return CreateColor(r, g, b, a);
		else
			GMError("CreateColorFromHexString input must be hexadecimal digits in this format: AARRGGBB.");
		end
	end
end


local function createTitanOption(id, text, var)
	return {
		text = text,
		func = function()
			TitanPanelRightClickMenu_ToggleVar({ id, var, nil })
		end,
		checked = TitanGetVar(id, var),
		keepShownOnClick = 1
	}
end

local function setDefaultSavedVariables(sv, menus)
	if sv.ShowIcon == nil then sv.ShowIcon = 1 end
	sv.ShowLabelText = sv.ShowLabelText or false
	if sv.ShowRegularText == nil then sv.ShowRegularText = 1 end

	if menus then
		for k, v in ipairs(menus) do
			if v.var then sv[v.var] = v.def or sv[v.var] or false
			elseif v.type == "rightSideToggle" then sv.DisplayOnRightSide = v.def or false
			end
		end
	end
end

local function initMenu(self, level, menuList, id)
	for k, v in ipairs(menuList) do
		local info = {}
		info.text = v.text
		info.arg1 = v.arg1
		info.arg2 = v.arg2
		info.notCheckable = true
		info.func = v.func

		if v.menuList then
			info.hasArrow = true
			info.menuList = v.menuList
		end

		if v.type == "toggle" then
			info.notCheckable = false
			info.func = v.func or function()
				TitanToggleVar(id, v.var);
				TitanPanelButton_UpdateButton(id)
			end
			info.checked = TitanGetVar(id, v.var)
			info.keepShownOnClick = v.keepShown
			EDDM.UIDropDownMenu_AddButton(info, level)
		elseif v.type == "space" then
			EDDM.UIDropDownMenu_AddSpace(level)
		elseif v.type == "button" then
			EDDM.UIDropDownMenu_AddButton(info, level)
		elseif v.type == "title" then
			info.isTitle = true
			EDDM.UIDropDownMenu_AddButton(info, level)
		elseif v.type == "color" then
			local colorHex = TitanGetVar(id, v.var) or v.def or "FF000000"
			info.r, info.g, info.b = CreateColorFromHexString(colorHex):GetRGB()
			info.swatchFunc = v.swatchFunc or function()
				local color = CreateColor(ColorPickerFrame:GetColorRGB())
				TitanSetVar(id, v.var, color:GenerateHexColor())
				TitanPanelButton_UpdateButton(id)
			end
			info.cancelFunc = v.cancelFunc or function(previousValues)
				if previousValues then
					TitanSetVar(id, v.var, CreateColor(previousValues.r, previousValues.g, previousValues.b):GenerateHexColor())
				end
			end
			info.hasColorSwatch = true
			EDDM.UIDropDownMenu_AddButton(info, level)
		end
	end
end

function Elib.Register(easyObject)
	local function initializeMenu(self, level, menuList)
		local id = easyObject.id

		if easyObject.prepareMenu then
			return easyObject.prepareMenu(EDDM, self, easyObject.id, level, menuList)
		end

		if level and level > 1 then
			return initMenu(self, level, menuList, id)
		end

		EDDM.UIDropDownMenu_AddButton({
			text = TitanPlugins[id].menuText,
			hasArrow = false,
			isTitle = true,
			isUninteractable = true,
			notCheckable = true
		})

		EDDM.UIDropDownMenu_AddButton(createTitanOption(id, Titan_L["TITAN_PANEL_MENU_SHOW_ICON"], "ShowIcon"))
		EDDM.UIDropDownMenu_AddButton(createTitanOption(id, Titan_L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"], "ShowLabelText"))
		EDDM.UIDropDownMenu_AddButton(createTitanOption(id, Titan_L["TITAN_PANEL_MENU_SHOW_PLUGIN_TEXT"], "ShowRegularText"))

		local menus = easyObject.menus
		if menus then
			for k, v in ipairs(menus) do
				if v.type == "rightSideToggle" then
					local info = {}
					info.text = Titan_L["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"]
					info.func = function()
						TitanToggleVar(id, "DisplayOnRightSide");
						TitanPanel_InitPanelButtons()
					end
					info.checked = TitanGetVar(id, "DisplayOnRightSide")
					EDDM.UIDropDownMenu_AddButton(info)
				end
			end
		end

		EDDM.UIDropDownMenu_AddSeparator()

		if menus then
			initMenu(self, level, menus, id)
			EDDM.UIDropDownMenu_AddButton({ text = "", notCheckable = true, notClickable = true, disabled = 1 })
		end

		EDDM.UIDropDownMenu_AddButton({
			notCheckable = true,
			text = Titan_L["TITAN_PANEL_MENU_HIDE"],
			func = function() TitanPanelRightClickMenu_Hide(id) end
		})
		EDDM.UIDropDownMenu_AddSeparator()
		EDDM.UIDropDownMenu_AddButton({ notCheckable = true, text = CANCEL, keepShownOnClick = false })
	end

	-- Main button frame and addon base
	local frame = CreateFrame("Button", "TitanPanel" .. easyObject.id .. "Button", CreateFrame("Frame", nil, UIParent), "TitanPanelComboTemplate")
	frame:SetFrameStrata("FULLSCREEN")
	frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnClick", function(self, button, ...)
		local handled = easyObject.onClick and easyObject.onClick(self, button, ...)
		if not handled and button == "RightButton" then
			EDDM.UIDropDownMenu_Initialize(menuFrame, initializeMenu, "MENU")
			EDDM.ToggleDropDownMenu(1, nil, menuFrame, "cursor", 3, -3)
		end
	end)

	if easyObject.eventsTable then
		for event, func in pairs(easyObject.eventsTable) do
			frame[event] = func
			frame:RegisterEvent(event)
		end
	end

	function frame:ADDON_LOADED()
		self:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil

		if easyObject.onLoad then easyObject.onLoad(self, easyObject.id) end

		local sv = easyObject.savedVariables or {}
		setDefaultSavedVariables(sv, easyObject.menus)

		self.registry = {
			id = easyObject.id,
			menuText = easyObject.name .. "|r",
			buttonTextFunction = easyObject.getButtonText and "TitanPanelButton_Get" .. easyObject.id .. "ButtonText",
			tooltipTitle = easyObject.tooltip,
			tooltipTextFunction = easyObject.getTooltipText and "TitanPanelButton_Get" .. easyObject.id .. "TooltipText",
			frequency = (easyObject.onUpdate and easyObject.frequency) or 1,
			icon = easyObject.icon,
			iconWidth = 16,
			category = easyObject.category,
			version = easyObject.version,
			tooltipCustomFunction = easyObject.customTooltip,
			savedVariables = sv
		}

		if easyObject.onUpdate then
			local elap = 0
			self:SetScript("OnUpdate", function(this, a1)
				elap = elap + a1
				if elap < 1 then return end

				if easyObject.onUpdate(self, easyObject.id) then elap = 0 end
			end)
		end

		if easyObject.afterLoad then easyObject.afterLoad(self, easyObject.id) end
	end

	if easyObject.getButtonText then
		_G["TitanPanelButton_Get" .. easyObject.id .. "ButtonText"] = function(...)
			local returns = { easyObject.getButtonText(frame, easyObject.id, ...) }
			if (returns[2] and not TitanGetVar(easyObject.id, "ShowRegularText")) then
				returns[2] = ""
			end
			return unpack(returns)
		end
	end

	if easyObject.getTooltipText then
		_G["TitanPanelButton_Get" .. easyObject.id .. "TooltipText"] = function(...)
			return easyObject.getTooltipText(frame, easyObject.id, ...)
		end
	end

	return frame
end
