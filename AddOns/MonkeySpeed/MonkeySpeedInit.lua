-- Script array, not saved
MonkeySpeedTemp = {}
MonkeySpeedTemp.deltaTime = 0
MonkeySpeedTemp.currentUnit = "player"
MonkeySpeedTemp.currentSpeed = 0.0
MonkeySpeedTemp.currentColorSpeedLDB = MONKEYSPEED_showLDB_inactive

MonkeySpeed = {};
MonkeySpeed.rate = 0.000001
MonkeySpeed.calibrate = true
MonkeySpeed.m_fSpeedDist = 0.0;
MonkeySpeed.m_vCurrPos = {};
MonkeySpeed.m_vCurrPos.x = 0
MonkeySpeed.m_vCurrPos.y = 0
MonkeySpeed.m_vLastPos = {};
MonkeySpeed.m_vLastPos.x = 0
MonkeySpeed.m_vLastPos.y = 0

function MonkeySpeed_Init()
	
	MonkeySpeedFrame:SetMinResize(20, 20)
	
	if (MonkeySpeedVars == nil) then
	MonkeySpeedVars = {
		shown = true,
		showBorder = true,
		frameLocked = false,
		showPercent = true,
		showBar = true,
		showLDB = true,
		autoCalibration = true,
		maximumSpeed = true,
		rightClickOpensConfig = true,
		frameColour = {
			r = 0,
			g = 0,
			b = 0,
			a = 1,
			},
		borderColour = {
			r = 1,
			g = 0.7,
			b = 0,
			},
		speedColour1 = {
			r = 1,
			g = 0,
			b = 0,
			},
		speedColour2 = {
			r = 1,
			g = 0.5,
			b = 0,
			},
		speedColour3 = {
			r = 1,
			g = 1,
			b = 0,
			},
		speedColour4 = {
			r = 0,
			g = 1,
			b = 0,
			},
		speedColour5 = {
			r = 0,
			g = 1,
			b = 0.5,
			},
		speedColour6 = {
			r = 0,
			g = 1,
			b = 1,
			},
		speedColour7 = {
			r = 1,
			g = 0,
			b = 1,
			},
		speedColour8 = {
			r = 0.5,
			g = 0,
			b = 1,
			},
		speedColour9 = {
			r = 0,
			g = 0,
			b = 1,
			},
		speedColour10 = {
			r = 0,
			g = 0,
			b = .5,
			},
		precision = 1
	}
	end
	
	-- Prevent nil error for previous users
	if (MonkeySpeedVars.precision == nil) then
		MonkeySpeedVars.precision = 1;
		MonkeySpeedVars.showLDB = true;
	end
	
	-- Prevent nil error for previous users
	if (MonkeySpeedVars.maximumSpeed == nil) then
		MonkeySpeedVars.maximumSpeed = true;
	end
    
    -- Prevent nil error for previous users
	if (MonkeySpeedVars.autoCalibration == nil) then
		MonkeySpeedVars.autoCalibration = true;
	end
	
	MonkeySpeedFrame:SetBackdropBorderColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	
	MonkeySpeed_shown_Changed()
	MonkeySpeed_showBorder_Changed()
	MonkeySpeed_frameLocked_Changed()
	MonkeySpeed_showBar_Changed()
	MonkeySpeed_showPercent_Changed()
	
	local MonkeySpeedOptions = CreateFrame("FRAME", "MonkeySpeedOptions")
	MonkeySpeedOptions.name = GetAddOnMetadata("MonkeySpeed", "Title")
	MonkeySpeedOptions.default = function (self) MonkeySpeed_ResetConfig() end
	MonkeySpeedOptions.refresh = function (self) MonkeySpeed_RefreshConfig() end
	InterfaceOptions_AddCategory(MonkeySpeedOptions)
	
	local MonkeySpeedOptionsHeader = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedOptionsHeader:SetFontObject(GameFontNormalLarge)
	MonkeySpeedOptionsHeader:SetPoint("TOPLEFT", 16, -16)
	MonkeySpeedOptionsHeader:SetText(GetAddOnMetadata("MonkeySpeed", "Title") .. " " .. GetAddOnMetadata("MonkeySpeed", "Version"))
	
	local MonkeySpeedGeneral = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedGeneral:SetFontObject(GameFontWhite)
	MonkeySpeedGeneral:SetPoint("TOPLEFT", MonkeySpeedOptionsHeader, "BOTTOMLEFT", 0, -6)
	MonkeySpeedGeneral:SetText(MONKEYSPEED_GENERAL_OPTIONS)
	
	local MonkeySpeedCB1 = CreateFrame("CheckButton", "MonkeySpeedCB1", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB1:SetPoint("TOPLEFT", MonkeySpeedGeneral, "BOTTOMLEFT", 2, -4)
	MonkeySpeedCB1:SetScript("OnClick", function(self) MonkeySpeedVars.shown = (not MonkeySpeedVars.shown) 
																MonkeySpeed_shown_Changed() end)
	MonkeySpeedCB1Text:SetText(MONKEYSPEED_shown_DESC)
	
	MonkeySpeedC1 = CreateFrame("Button", "MonkeySpeedC1" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC1:SetPoint("TOPLEFT", MonkeySpeedGeneral, "BOTTOMLEFT", 175, -8)
	_G["MonkeySpeedC1" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_frameColour_DESC)
	_G["MonkeySpeedC1" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC1:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.frameColour
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.opacityFunc = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.hasOpacity = true
		ColorPickerFrame.opacity = colour.a
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b, a = colour.a}
		ColorPickerFrame:Show()
	end)
	
	local MonkeySpeedCB2 = CreateFrame("CheckButton", "MonkeySpeedCB2", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB2:SetPoint("TOPLEFT", MonkeySpeedCB1, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB2:SetScript("OnClick", function(self) MonkeySpeedVars.showBorder = (not MonkeySpeedVars.showBorder) 
																MonkeySpeed_showBorder_Changed() end)
	MonkeySpeedCB2Text:SetText(MONKEYSPEED_showBorder_DESC)
	
	MonkeySpeedC2 = CreateFrame("Button", "MonkeySpeedC2" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC2:SetPoint("TOPLEFT", MonkeySpeedCB1, "BOTTOMLEFT", 173, -8)
	_G["MonkeySpeedC2" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_borderColour_DESC)
	_G["MonkeySpeedC2" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC2:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.borderColour
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_borderColour_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_borderColour_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	local MonkeySpeedCB3 = CreateFrame("CheckButton", "MonkeySpeedCB3", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB3:SetPoint("TOPLEFT", MonkeySpeedCB2, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB3:SetScript("OnClick", function(self) MonkeySpeedVars.frameLocked = (not MonkeySpeedVars.frameLocked) 
																MonkeySpeed_frameLocked_Changed() end)
	MonkeySpeedCB3Text:SetText(MONKEYSPEED_frameLocked_DESC)

	local MonkeySpeedCB4 = CreateFrame("CheckButton", "MonkeySpeedCB4", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB4:SetPoint("TOPLEFT", MonkeySpeedCB3, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB4:SetScript("OnClick", function(self) MonkeySpeedVars.showBar = (not MonkeySpeedVars.showBar) 
																MonkeySpeed_showBar_Changed() end)
	MonkeySpeedCB4Text:SetText(MONKEYSPEED_showBar_DESC)
	
	local MonkeySpeedCB5 = CreateFrame("CheckButton", "MonkeySpeedCB5", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB5:SetPoint("TOPLEFT", MonkeySpeedCB4, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB5:SetScript("OnClick", function(self) MonkeySpeedVars.showPercent = (not MonkeySpeedVars.showPercent) 
																MonkeySpeed_showPercent_Changed() end)
	MonkeySpeedCB5Text:SetText(MONKEYSPEED_showPercent_DESC)
	
	local MonkeySpeedCB6 = CreateFrame("CheckButton", "MonkeySpeedCB6", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB6:SetPoint("TOPLEFT", MonkeySpeedCB5, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB6:SetScript("OnClick", function(self) MonkeySpeedVars.autoCalibration = (not MonkeySpeedVars.autoCalibration) end)
	MonkeySpeedCB6Text:SetText(MONKEYSPEED_autoCalibration_DESC)
	
	local MonkeySpeedCB9 = CreateFrame("CheckButton", "MonkeySpeedCB9", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB9:SetPoint("TOPLEFT", MonkeySpeedCB6, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB9:SetScript("OnClick", function(self) MonkeySpeedVars.maximumSpeed = (not MonkeySpeedVars.maximumSpeed) end)
	MonkeySpeedCB9Text:SetText(MONKEYSPEED_maximumSpeed_DESC)
	
	local MonkeySpeedCB8 = CreateFrame("CheckButton", "MonkeySpeedCB8", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB8:SetPoint("TOPLEFT", MonkeySpeedCB9, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB8:SetScript("OnClick", function(self) MonkeySpeedVars.showLDB = (not MonkeySpeedVars.showLDB) end)
	MonkeySpeedCB8Text:SetText(MONKEYSPEED_showLDB_DESC)
	if (LibStub == nil) then
		MonkeySpeedCB8:Disable()
		MonkeySpeedCB8Text:SetFontObject(GameFontDisable)
		MonkeySpeedCB8Text:SetText(MONKEYSPEED_showLDB_DESC .. " (".. MONKEYSPEED_showLDB_inactive ..")")
	else
		local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if(ldb == nil) then
			MonkeySpeedCB8:Disable()
			MonkeySpeedCB8Text:SetFontObject(GameFontDisable)
			MonkeySpeedCB8Text:SetText(MONKEYSPEED_showLDB_DESC .. " (".. MONKEYSPEED_showLDB_inactive ..")")
		end
	end

	local MonkeySpeedMisc = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedMisc:SetFontObject(GameFontWhite)
	MonkeySpeedMisc:SetPoint("TOPLEFT", MonkeySpeedCB8, "BOTTOMLEFT", -2, -4)
	MonkeySpeedMisc:SetText(MONKEYSPEED_MISC_OPTIONS)
	
	local MonkeySpeedCB7 = CreateFrame("CheckButton", "MonkeySpeedCB7", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB7:SetPoint("TOPLEFT", MonkeySpeedMisc, "BOTTOMLEFT", 2, -4)
	MonkeySpeedCB7:SetScript("OnClick", function(self) MonkeySpeedVars.rightClickOpensConfig = (not MonkeySpeedVars.rightClickOpensConfig) end)
	MonkeySpeedCB7Text:SetText(MONKEYSPEED_rightClickOpensConfig_DESC)
	
	MonkeySpeedC3 = CreateFrame("Button", "MonkeySpeedC3" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC3:SetPoint("TOPLEFT", MonkeySpeedCB7, "BOTTOMLEFT", 5, -8)
	_G["MonkeySpeedC3" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour1_DESC)
	_G["MonkeySpeedC3" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC3:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour1
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour1_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour1_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC4 = CreateFrame("Button", "MonkeySpeedC4" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC4:SetPoint("TOPLEFT", MonkeySpeedCB7, "BOTTOMLEFT", 160, -8)
	_G["MonkeySpeedC4" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour2_DESC)
	_G["MonkeySpeedC4" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC4:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour2
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour2_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour2_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC5 = CreateFrame("Button", "MonkeySpeedC5" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC5:SetPoint("TOPLEFT", MonkeySpeedC3, "BOTTOMLEFT", 0, -10)
	_G["MonkeySpeedC5" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour3_DESC)
	_G["MonkeySpeedC5" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC5:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour3
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour3_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour3_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC6 = CreateFrame("Button", "MonkeySpeedC6" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC6:SetPoint("TOPLEFT", MonkeySpeedC3, "BOTTOMLEFT", 155, -10)
	_G["MonkeySpeedC6" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour4_DESC)
	_G["MonkeySpeedC6" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC6:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour4
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour4_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour4_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC7 = CreateFrame("Button", "MonkeySpeedC7" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC7:SetPoint("TOPLEFT", MonkeySpeedC5, "BOTTOMLEFT", 0, -10)
	_G["MonkeySpeedC7" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour5_DESC)
	_G["MonkeySpeedC7" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC7:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour5
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour5_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour5_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC8 = CreateFrame("Button", "MonkeySpeedC8" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC8:SetPoint("TOPLEFT", MonkeySpeedC5, "BOTTOMLEFT", 155, -10)
	_G["MonkeySpeedC8" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour6_DESC)
	_G["MonkeySpeedC8" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC8:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour6
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour6_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour6_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC9 = CreateFrame("Button", "MonkeySpeedC9" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC9:SetPoint("TOPLEFT", MonkeySpeedC7, "BOTTOMLEFT", 0, -10)
	_G["MonkeySpeedC9" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour7_DESC)
	_G["MonkeySpeedC9" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC9:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour7
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour7_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour7_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC10 = CreateFrame("Button", "MonkeySpeedC10" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC10:SetPoint("TOPLEFT", MonkeySpeedC7, "BOTTOMLEFT", 155, -10)
	_G["MonkeySpeedC10" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour8_DESC)
	_G["MonkeySpeedC10" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC10:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour8
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour8_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour8_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC11 = CreateFrame("Button", "MonkeySpeedC11" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC11:SetPoint("TOPLEFT", MonkeySpeedC9, "BOTTOMLEFT", 0, -10)
	_G["MonkeySpeedC11" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour9_DESC)
	_G["MonkeySpeedC11" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC11:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour9
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour9_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour9_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC12 = CreateFrame("Button", "MonkeySpeedC12" .. "_ColourBnt", MonkeySpeedOptions, "MonkeySpeedColourButtonTemplate")
	MonkeySpeedC12:SetPoint("TOPLEFT", MonkeySpeedC9, "BOTTOMLEFT", 155, -10)
	_G["MonkeySpeedC12" .. "_ColourBnt_Text"]:SetText(MONKEYSPEED_speedColour10_DESC)
	_G["MonkeySpeedC12" .. "_ColourBnt_BorderTexture"]:SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC12:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour10
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour10_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour10_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedPrecision = CreateFrame("Slider", "MonkeySpeedPrecision", MonkeySpeedOptions, "OptionsSliderTemplate")
	MonkeySpeedPrecision:SetPoint("TOPLEFT", MonkeySpeedC11, "BOTTOMLEFT", 0, -25)
	MonkeySpeedPrecision:SetScript("OnValueChanged", function(self, value) MonkeySpeedVars.precision = math.floor(value)
		getglobal(MonkeySpeedPrecision:GetName() .. 'Text'):SetText(MONKEYSPEED_precision_DESC.. " (" .. MonkeySpeedVars.precision .. ")")
	end)
	MonkeySpeedPrecision:SetWidth(320)
	MonkeySpeedPrecision:SetMinMaxValues(0, 5)
	MonkeySpeedPrecision:SetValueStep(1)
	MonkeySpeedPrecision:SetStepsPerPage(1)
	MonkeySpeedPrecision:SetValue(MonkeySpeedVars.precision)
	MonkeySpeedPrecisionText:SetFontObject(GameFontNormal)
	getglobal(MonkeySpeedPrecision:GetName() .. 'Text'):SetText(MONKEYSPEED_precision_DESC.. " (" .. MonkeySpeedVars.precision .. ")")
	getglobal(MonkeySpeedPrecision:GetName() .. 'Low'):SetText('0')
	getglobal(MonkeySpeedPrecision:GetName() .. 'High'):SetText('5')
end

function MonkeySpeed_ResetConfig()
	MonkeySpeedVars.shown = true
	
	MonkeySpeedVars.frameColour.r = 0
	MonkeySpeedVars.frameColour.g = 0
	MonkeySpeedVars.frameColour.b = 0
	MonkeySpeedVars.frameColour.a = 1
	
	MonkeySpeedVars.showBorder = true
	
	MonkeySpeedVars.borderColour.r = 1
	MonkeySpeedVars.borderColour.g = 0.7
	MonkeySpeedVars.borderColour.b = 0
	
	MonkeySpeedVars.speedColour1.r = 1
	MonkeySpeedVars.speedColour1.g = 0
	MonkeySpeedVars.speedColour1.b = 0
	
	MonkeySpeedVars.speedColour2.r = 1
	MonkeySpeedVars.speedColour2.g = 0.5
	MonkeySpeedVars.speedColour2.b = 0
	
	MonkeySpeedVars.speedColour3.r = 1
	MonkeySpeedVars.speedColour3.g = 1
	MonkeySpeedVars.speedColour3.b = 0
	
	MonkeySpeedVars.speedColour4.r = 0
	MonkeySpeedVars.speedColour4.g = 1
	MonkeySpeedVars.speedColour4.b = 0
	
	MonkeySpeedVars.speedColour5.r = 0
	MonkeySpeedVars.speedColour5.g = 1
	MonkeySpeedVars.speedColour5.b = .5
	
	MonkeySpeedVars.speedColour6.r = 0
	MonkeySpeedVars.speedColour6.g = 1
	MonkeySpeedVars.speedColour6.b = 1
	
	MonkeySpeedVars.speedColour7.r = 1
	MonkeySpeedVars.speedColour7.g = 0
	MonkeySpeedVars.speedColour7.b = 1
	
	MonkeySpeedVars.speedColour8.r = 0.5
	MonkeySpeedVars.speedColour8.g = 0
	MonkeySpeedVars.speedColour8.b = 1
	
	MonkeySpeedVars.speedColour9.r = 0
	MonkeySpeedVars.speedColour9.g = 0
	MonkeySpeedVars.speedColour9.b = 1
	
	MonkeySpeedVars.speedColour10.r = 0
	MonkeySpeedVars.speedColour10.g = 0
	MonkeySpeedVars.speedColour10.b = .5

	MonkeySpeedVars.frameLocked = false
	MonkeySpeedVars.showBar = true
	MonkeySpeedVars.showLDB = true
	MonkeySpeedVars.showPercent = true
	MonkeySpeedVars.autoCalibration = true
	MonkeySpeedVars.maximumSpeed = true
	MonkeySpeedVars.rightClickOpensConfig = true
	
	MonkeySpeedVars.precision = 1
	
	MonkeySpeedFrame:SetHeight(30)
	MonkeySpeedFrame:SetWidth(110)
	MonkeySpeedFrame:ClearAllPoints()
	MonkeySpeedFrame:SetPoint("TOP", nil, "TOP", 0, -50)
	
	MonkeySpeedFrame:SetBackdropBorderColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	
	MonkeySpeed_shown_Changed()
	MonkeySpeed_showBorder_Changed()
	MonkeySpeed_frameLocked_Changed()
	MonkeySpeed_showBar_Changed()
	MonkeySpeed_showPercent_Changed()
end

function MonkeySpeed_RefreshConfig()
	MonkeySpeedCB1:SetChecked(MonkeySpeedVars.shown)
	MonkeySpeedCB2:SetChecked(MonkeySpeedVars.showBorder)
	MonkeySpeedCB3:SetChecked(MonkeySpeedVars.frameLocked)
	MonkeySpeedCB4:SetChecked(MonkeySpeedVars.showBar)
	MonkeySpeedCB5:SetChecked(MonkeySpeedVars.showPercent)
	MonkeySpeedCB6:SetChecked(MonkeySpeedVars.autoCalibration)
	MonkeySpeedCB9:SetChecked(MonkeySpeedVars.maximumSpeed)
	MonkeySpeedCB8:SetChecked(MonkeySpeedVars.showLDB)
	MonkeySpeedCB7:SetChecked(MonkeySpeedVars.rightClickOpensConfig)
	MonkeySpeedPrecision:SetValue(MonkeySpeedVars.precision)
	
	_G["MonkeySpeedC1_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.frameColour.r, MonkeySpeedVars.frameColour.g, MonkeySpeedVars.frameColour.b)
	_G["MonkeySpeedC2_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	_G["MonkeySpeedC3_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour1.r, MonkeySpeedVars.speedColour1.g, MonkeySpeedVars.speedColour1.b)
	_G["MonkeySpeedC4_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour2.r, MonkeySpeedVars.speedColour2.g, MonkeySpeedVars.speedColour2.b)
	_G["MonkeySpeedC5_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour3.r, MonkeySpeedVars.speedColour3.g, MonkeySpeedVars.speedColour3.b)
	_G["MonkeySpeedC6_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour4.r, MonkeySpeedVars.speedColour4.g, MonkeySpeedVars.speedColour4.b)
	_G["MonkeySpeedC7_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour5.r, MonkeySpeedVars.speedColour5.g, MonkeySpeedVars.speedColour5.b)
	_G["MonkeySpeedC8_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour6.r, MonkeySpeedVars.speedColour6.g, MonkeySpeedVars.speedColour6.b)
	_G["MonkeySpeedC9_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour7.r, MonkeySpeedVars.speedColour7.g, MonkeySpeedVars.speedColour7.b)
	_G["MonkeySpeedC10_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour8.r, MonkeySpeedVars.speedColour8.g, MonkeySpeedVars.speedColour8.b)
	_G["MonkeySpeedC11_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour9.r, MonkeySpeedVars.speedColour9.g, MonkeySpeedVars.speedColour9.b)
	_G["MonkeySpeedC12_ColourBnt_SwatchTexture"]:SetVertexColor(MonkeySpeedVars.speedColour10.r, MonkeySpeedVars.speedColour10.g, MonkeySpeedVars.speedColour10.b)
end
