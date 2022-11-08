local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

local _chkMinimap
local _chkAutoGear
local _chkJunk
local _chkAh
local _chkEm
local _txtScale

local function onTextboxEnter(widget)
	local setting = widget:GetUserData("setting")
	local val = widget:GetText()

	val = tonumber(val)
	if not val then
		widget:SetText(Amr.db.profile.options[setting])
	else
		if setting == "uiScale" then
			if val < 0.5 then
				val = 0.5
			elseif val > 1.5 then
				val = 1.5
			end
		end
		
		Amr.db.profile.options[setting] = val
		Amr:RefreshConfig()
	end
end

local function onCheckClick(widget)	
	local setting = widget:GetUserData("setting")
	local val = widget:GetChecked()
	
	if setting == "minimap" then
		Amr.db.profile.minimap.hide = val
	else
		Amr.db.profile.options[setting] = val
	end
	
	Amr:RefreshConfig()
end

local function createCheck(container, setting, text, description)

	local chk = AceGUI:Create("AmrUiCheckBox")
	container:AddChild(chk)
	chk:SetUserData("setting", setting)
	chk:SetText(text)
	chk:SetCallback("OnClick", onCheckClick)
	
	local desc = AceGUI:Create("AmrUiLabel")
	container:AddChild(desc)
	desc:SetWidth(800)
	desc:SetText(description)
	desc:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.TextTan))
	desc:SetPoint("TOPLEFT", chk.frame, "BOTTOMLEFT", 24, -3)
	
	return chk, desc
end

local function createSmallTextbox(container, setting, text, description)

	local txt = AceGUI:Create("AmrUiTextarea")
	txt:SetUserData("setting", setting)
	txt:SetMultiLine(false)
	txt:SetWidth(35)
	txt:SetHeight(24)
	txt:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
	txt:SetCallback("OnEnterPressed", onTextboxEnter)
	container:AddChild(txt)
	
	local lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetWidth(600)
	lbl:SetText(text)
	lbl:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
	lbl:SetPoint("LEFT", txt.frame, "RIGHT", 6, 0)
	
	local desc = AceGUI:Create("AmrUiLabel")
	container:AddChild(desc)
	desc:SetWidth(800)
	desc:SetText(description)
	desc:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.TextTan))
	desc:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 0, -4)
	
	return txt, desc
end

-- renders the main UI for the Combat Log tab
function Amr:RenderTabOptions(container)

	local header = AceGUI:Create("AmrUiLabel")
	container:AddChild(header)
	header:SetWidth(600)
	header:SetText(L.OptionsHeaderGeneral)
	header:SetFont(Amr.CreateFont("Bold", 24, Amr.Colors.TextHeaderActive))
	header:SetPoint("TOPLEFT", container.content, "TOPLEFT", 12, -40)

	local desc, desc2
	
	_chkMinimap, desc = createCheck(container, "minimap", L.OptionsHideMinimapName, L.OptionsHideMinimapDesc)
	_chkMinimap:SetPoint("TOPLEFT", header.frame, "BOTTOMLEFT", 10, -20)
	
	--[[
	_chkAutoGear, desc2 = createCheck(container, "autoGear", L.OptionsAutoGearName, L.OptionsAutoGearDesc)
	_chkAutoGear:SetPoint("TOPLEFT", desc.frame, "BOTTOMLEFT", -24, -20)
	]]

	_chkJunk, desc2 = createCheck(container, "junkVendor", L.OptionsJunkVendorName, L.OptionsJunkVendorDesc)
	_chkJunk:SetPoint("TOPLEFT", desc.frame, "BOTTOMLEFT", -24, -20)

	_chkAh, desc = createCheck(container, "shopAh", L.OptionsShopAhName, L.OptionsShopAhDesc)
	_chkAh:SetPoint("TOPLEFT", desc2.frame, "BOTTOMLEFT", -24, -20)
	
	_chkEm, desc2 = createCheck(container, "disableEm", L.OptionsDisableEmName, L.OptionsDisableEmDesc)
	_chkEm:SetPoint("TOPLEFT", desc.frame, "BOTTOMLEFT", -24, -20)

	_txtScale, desc = createSmallTextbox(container, "uiScale", L.OptionsUiScaleName, L.OptionsUiScaleDesc)
	_txtScale:SetPoint("TOPLEFT", desc2.frame, "BOTTOMLEFT", -43, -20)
	
	-- initialize state of controls
	Amr:RefreshOptionsUi()
end

function Amr:ReleaseTabOptions()
	_chkMinimap = nil
	_chkAutoGear = nil
	_chkJunk = nil
	_chkAh = nil
	_chkEm = nil
	_txtScale = nil
end

function Amr:RefreshOptionsUi()

	if _chkMinimap then
		_chkMinimap:SetChecked(self.db.profile.minimap.hide)
	end
	
	if _chkAutoGear then
		_chkAutoGear:SetChecked(self.db.profile.options.autoGear)
	end

	if _chkJunk then
		_chkJunk:SetChecked(self.db.profile.options.junkVendor)
	end

	if _chkAh then
		_chkAh:SetChecked(self.db.profile.options.shopAh)
	end
	
	if _chkEm then
		_chkEm:SetChecked(self.db.profile.options.disableEm)
	end
	
	if _txtScale then
		_txtScale:SetText(self.db.profile.options.uiScale)
		_txtScale:ClearFocus()
	end
end
