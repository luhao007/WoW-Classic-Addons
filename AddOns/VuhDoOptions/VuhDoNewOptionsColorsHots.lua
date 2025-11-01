


--
function VUHDO_initHotTimerRadioButton(aButton, aMode)
	VUHDO_lnfSetRadioModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".countdownMode", aMode);
end



--
function VUHDO_initHotTimerCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isFullDuration");
end



--
function VUHDO_initHotClockCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isClock");
end



--
function VUHDO_initHotFadeCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isFadeOut");
	VUHDO_lnfSetTooltip(aButton, VUHDO_I18N_TT.K260);
end



--
function VUHDO_initHotFlashCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isFlashWhenLow");
	VUHDO_lnfSetTooltip(aButton, VUHDO_I18N_TT.K513);
end



--
local tHotName;
function VUHDO_colorsHotsSetSwatchHotName(aTexture, aHotNum)

	-- use first panel's slot assignments as example HoT name
	tHotName = VUHDO_PANEL_SETUP[1]["HOTS"]["SLOTS"][aHotNum] or "";

	if (not VUHDO_strempty(tHotName)) then
		_G[aTexture:GetName() .. "TitleString"]:SetText(gsub(tHotName, "BOUQUET_", ""));
	end
end

