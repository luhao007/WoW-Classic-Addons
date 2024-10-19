---@diagnostic disable: duplicate-set-field
--[[
-- **************************************************************************
-- * TitanBag.lua
-- *
-- * By: The Titan Panel Development Team
-- **************************************************************************
--]]

local TITAN_VOLUME_ID = "Volume";
local TITAN_VOLUME_BUTTON = "TitanPanel" .. TITAN_VOLUME_ID .. "Button"

local cname = "TitanPanelVolumeControlFrame"

local TITAN_VOLUME_FRAME_SHOW_TIME = 0.5;
local TITAN_VOLUME_ARTWORK_PATH = "Interface\\AddOns\\TitanVolume\\Artwork\\";
local _G = getfenv(0);
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)

local function GetVolumeText(volume)
	return tostring(floor(100 * volume + 0.5)) .. "%";
end

local function IsMuted()
	local mute = false
	local setting = "Sound_EnableAllSound"
	local value = C_CVar.GetCVar(setting)
	if value == nil then
		-- value is invalid - Blizz change??
	elseif value == "0" then
		mute = true
	elseif value == "1" then
		-- not muted
	else
		-- value is invalid - Blizz change??
	end
	return mute
end

local function SetVolumeIcon()
--[[
	local icon = _G["TitanPanelVolumeButtonIcon"];
	local masterVolume = tonumber(GetCVar("Sound_MasterVolume"));
	if (masterVolume <= 0) then
		icon:SetTexture(TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeMute");
	elseif (masterVolume < 0.33) then
		icon:SetTexture(TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeLow");
	elseif (masterVolume < 0.66) then
		icon:SetTexture(TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeMedium");
	else
		icon:SetTexture(TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeHigh");
	end
--]]
	local plugin = TitanUtils_GetPlugin(TITAN_VOLUME_ID)

	if IsMuted() then
		plugin.icon = TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeMute"
	else
		local masterVolume = tonumber(GetCVar("Sound_MasterVolume"));
		if (masterVolume <= 0) then
			plugin.icon = TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeMute"
		elseif (masterVolume < 0.33) then
			plugin.icon = TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeLow"
		elseif (masterVolume < 0.66) then
			plugin.icon = TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeMedium"
		else
			plugin.icon = TITAN_VOLUME_ARTWORK_PATH .. "TitanVolumeHigh"
		end
	end
end

local function OnEvent(self, event, a1, ...)
	if event == "PLAYER_ENTERING_WORLD" and TitanGetVar(TITAN_VOLUME_ID, "OverrideBlizzSettings") then
		-- Override Blizzard's volume CVar settings
		if TitanGetVar(TITAN_VOLUME_ID, "VolumeMaster") then
			SetCVar("Sound_MasterVolume", TitanGetVar(TITAN_VOLUME_ID, "VolumeMaster"))
			SetVolumeIcon()
		end
		if TitanGetVar(TITAN_VOLUME_ID, "VolumeAmbience") then SetCVar("Sound_AmbienceVolume",
				TitanGetVar(TITAN_VOLUME_ID, "VolumeAmbience")) end
		if TitanGetVar(TITAN_VOLUME_ID, "VolumeDialog") then SetCVar("Sound_DialogVolume",
				TitanGetVar(TITAN_VOLUME_ID, "VolumeDialog")) end
		if TitanGetVar(TITAN_VOLUME_ID, "VolumeSFX") then SetCVar("Sound_SFXVolume",
				TitanGetVar(TITAN_VOLUME_ID, "VolumeSFX")) end
		if TitanGetVar(TITAN_VOLUME_ID, "VolumeMusic") then SetCVar("Sound_MusicVolume",
				TitanGetVar(TITAN_VOLUME_ID, "VolumeMusic")) end
		--		if TitanGetVar(TITAN_VOLUME_ID, "VolumeOutboundChat") then SetCVar("OutboundChatVolume", TitanGetVar(TITAN_VOLUME_ID, "VolumeOutboundChat")) end
		--		if TitanGetVar(TITAN_VOLUME_ID, "VolumeInboundChat") then SetCVar("InboundChatVolume", TitanGetVar(TITAN_VOLUME_ID, "VolumeInboundChat")) end
		TitanPanelButton_UpdateButton(TITAN_VOLUME_ID);
	end
end

local function OnShow()
	SetVolumeIcon();
	TitanPanelButton_UpdateButton(TITAN_VOLUME_ID);
end

local function OnEnter()
	-- Confirm master volume value
	TitanPanelMasterVolumeControlSlider:SetValue(1 - GetCVar("Sound_MasterVolume"));
	TitanPanelAmbienceVolumeControlSlider:SetValue(1 - GetCVar("Sound_AmbienceVolume"));
	TitanPanelDialogVolumeControlSlider:SetValue(1 - GetCVar("Sound_DialogVolume"));
	TitanPanelSoundVolumeControlSlider:SetValue(1 - GetCVar("Sound_SFXVolume"));
	TitanPanelMusicVolumeControlSlider:SetValue(1 - GetCVar("Sound_MusicVolume"));
	--	TitanPanelMicrophoneVolumeControlSlider:SetValue(1 - GetCVar("OutboundChatVolume"));
	--	TitanPanelSpeakerVolumeControlSlider:SetValue(1 - GetCVar("InboundChatVolume"));
--	SetVolumeIcon();
end

-- 'Master'
local function MasterSlider_OnEnter(self)
	--	self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_MASTER_VOLUME, GetVolumeText(GetCVar("Sound_MasterVolume")));
	self.tooltipText = ""
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

local function MasterSlider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_VOLUME_FRAME_SHOW_TIME);
end

local function MasterSlider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(GetCVar("Sound_MasterVolume")));
	_G[self:GetName() .. "High"]:SetText(Titan_Global.literals.low);
	_G[self:GetName() .. "Low"]:SetText(Titan_Global.literals.high);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.01);
	self:SetObeyStepOnDrag(true) -- since 5.4.2 (Mists of Pandaria)
	self:SetValue(1 - GetCVar("Sound_MasterVolume"));
end

local function MasterSlider_OnValueChanged(self, a1)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(1 - self:GetValue()));

	SetCVar("Sound_MasterVolume", 1 - self:GetValue());
	TitanSetVar(TITAN_VOLUME_ID, "VolumeMaster", 1 - self:GetValue())

	SetVolumeIcon();

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_MASTER_VOLUME, GetVolumeText(1 - self:GetValue()));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

local function OnMouseWheel(self, a1)
	local tempval = self:GetValue();

	if a1 < 0 then
		self:SetValue(tempval + 0.01);
	end

	if a1 > 0 then
		self:SetValue(tempval - 0.01);
	end
end


-- 'Music'
local function MusicSlider_OnEnter(self)
	--	self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_MUSIC_VOLUME, GetVolumeText(GetCVar("Sound_MusicVolume")));
	self.tooltipText = ""
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

local function MusicSlider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_VOLUME_FRAME_SHOW_TIME);
end

local function MusicSlider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(GetCVar("Sound_MusicVolume")));
	_G[self:GetName() .. "High"]:SetText(Titan_Global.literals.low);
	_G[self:GetName() .. "Low"]:SetText(Titan_Global.literals.high);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.01);
	self:SetValue(1 - GetCVar("Sound_MusicVolume"));
end

local function MusicSlider_OnValueChanged(self, a1)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(1 - self:GetValue()));

	SetCVar("Sound_MusicVolume", 1 - self:GetValue());
	TitanSetVar(TITAN_VOLUME_ID, "VolumeMusic", 1 - self:GetValue())

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_MUSIC_VOLUME, GetVolumeText(1 - self:GetValue()));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

-- 'Sound Effects'
local function SoundSlider_OnEnter(self)
	--	self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_FX_VOLUME, GetVolumeText(GetCVar("Sound_SFXVolume")));
	self.tooltipText = ""
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

local function SoundSlider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_VOLUME_FRAME_SHOW_TIME);
end

local function SoundSlider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(GetCVar("Sound_SFXVolume")));
	_G[self:GetName() .. "High"]:SetText(Titan_Global.literals.low);
	_G[self:GetName() .. "Low"]:SetText(Titan_Global.literals.high);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.01);
	self:SetValue(1 - GetCVar("Sound_SFXVolume"));
end

local function SoundSlider_OnValueChanged(self, a1)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(1 - self:GetValue()));

	SetCVar("Sound_SFXVolume", 1 - self:GetValue());
	TitanSetVar(TITAN_VOLUME_ID, "VolumeSFX", 1 - self:GetValue())

	-- Update GameTooltip
	if (self.tooltipText) then
		self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_FX_VOLUME, GetVolumeText(1 - self:GetValue()));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

-- 'Ambience'
local function AmbienceSlider_OnEnter(self)
	--	self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_AMBIENCE_VOLUME, GetVolumeText(GetCVar("Sound_AmbienceVolume")));
	self.tooltipText = ""
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

local function AmbienceSlider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_VOLUME_FRAME_SHOW_TIME);
end

local function AmbienceSlider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(GetCVar("Sound_AmbienceVolume")));
	_G[self:GetName() .. "High"]:SetText(Titan_Global.literals.low);
	_G[self:GetName() .. "Low"]:SetText(Titan_Global.literals.high);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.01);
	self:SetValue(1 - GetCVar("Sound_AmbienceVolume"));
end

local function AmbienceSlider_OnValueChanged(self, a1)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(1 - self:GetValue()));
	local tempval = self:GetValue();

	SetCVar("Sound_AmbienceVolume", 1 - self:GetValue());
	TitanSetVar(TITAN_VOLUME_ID, "VolumeAmbience", 1 - self:GetValue())

	-- Update GameTooltip
	if (self.tooltipText) then
		--		self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_VOLUME_CONTROL_TOOLTIP"], GetVolumeText(1 - self:GetValue()));
		self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_ENABLE_AMBIENCE,
			GetVolumeText(1 - self:GetValue()));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end

-- 'Dialog'
local function DialogSlider_OnEnter(self)
	--	self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_DIALOG_VOLUME, GetVolumeText(GetCVar("Sound_DialogVolume")));
	self.tooltipText = ""
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(self:GetParent());
end

local function DialogSlider_OnLeave(self)
	self.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(self:GetParent(), TITAN_VOLUME_FRAME_SHOW_TIME);
end

local function DialogSlider_OnShow(self)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(GetCVar("Sound_DialogVolume")));
	_G[self:GetName() .. "High"]:SetText(Titan_Global.literals.low);
	_G[self:GetName() .. "Low"]:SetText(Titan_Global.literals.high);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.01);
	self:SetValue(1 - GetCVar("Sound_DialogVolume"));
end

local function DialogSlider_OnValueChanged(self, a1)
	_G[self:GetName() .. "Text"]:SetText(GetVolumeText(1 - self:GetValue()));
	local tempval = self:GetValue();

	SetCVar("Sound_DialogVolume", 1 - self:GetValue());
	TitanSetVar(TITAN_VOLUME_ID, "VolumeDialog", 1 - self:GetValue())

	-- Update GameTooltip
	if (self.tooltipText) then
		--		self.tooltipText = TitanOptionSlider_TooltipText(L["TITAN_VOLUME_CONTROL_TOOLTIP"], GetVolumeText(1 - self:GetValue()));
		self.tooltipText = TitanOptionSlider_TooltipText(OPTION_TOOLTIP_DIALOG_VOLUME, GetVolumeText(1 - self:GetValue()));
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
	end
end


--[[ WoW 9.5
Blizzard decided to remove direct Backdrop API in 9.0 (Shadowlands)
so inherit the template (XML)
and set the values in the code (Lua)

9.5 The tooltip template was removed from the GameTooltip.
--]]
local function ControlFrame_OnLoad(self)
	_G[self:GetName() .. "Title"]:SetText(L["TITAN_VOLUME_CONTROL_TITLE"]);         -- VOLUME
	_G[self:GetName() .. "MasterTitle"]:SetText(L["TITAN_VOLUME_MASTER_CONTROL_TITLE"]); --MASTER_VOLUME
	_G[self:GetName() .. "MusicTitle"]:SetText(L["TITAN_VOLUME_MUSIC_CONTROL_TITLE"]);
	_G[self:GetName() .. "SoundTitle"]:SetText(L["TITAN_VOLUME_SOUND_CONTROL_TITLE"]); -- FX_VOLUME
	_G[self:GetName() .. "AmbienceTitle"]:SetText(L["TITAN_VOLUME_AMBIENCE_CONTROL_TITLE"]);
	_G[self:GetName() .. "DialogTitle"]:SetText(L["TITAN_VOLUME_DIALOG_CONTROL_TITLE"]);
	--	_G[self:GetName().."MicrophoneTitle"]:SetText(L["TITAN_VOLUME_MICROPHONE_CONTROL_TITLE"]);
	--	_G[self:GetName().."SpeakerTitle"]:SetText(L["TITAN_VOLUME_SPEAKER_CONTROL_TITLE"]);
	TitanPanelRightClickMenu_SetCustomBackdrop(self)
end

local function GetTooltipText()
	local mute = Titan_Global.literals.muted

	if IsMuted() then
		mute = mute .. "\t" .. TitanUtils_GetRedText(Titan_Global.literals.yes) .. "\n\n"
	else
		mute = mute .. "\t" .. TitanUtils_GetGreenText(Titan_Global.literals.no) .. "\n\n"
	end
	local text = ""

	local volumeMasterText = GetVolumeText(GetCVar("Sound_MasterVolume"));
	local volumeSoundText = GetVolumeText(GetCVar("Sound_SFXVolume"));
	local volumeMusicText = GetVolumeText(GetCVar("Sound_MusicVolume"));
	local volumeAmbienceText = GetVolumeText(GetCVar("Sound_AmbienceVolume"));
	local volumeDialogText = GetVolumeText(GetCVar("Sound_DialogVolume"));
	--	local volumeMicrophoneText = GetVolumeText(GetCVar("OutboundChatVolume"));
	--	local volumeSpeakerText = GetVolumeText(GetCVar("InboundChatVolume"));

	text = ""..
	mute ..
	L["TITAN_VOLUME_MASTER_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(volumeMasterText) .. "\n" ..
	L["TITAN_VOLUME_SOUND_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(volumeSoundText) .. "\n" ..
	L["TITAN_VOLUME_MUSIC_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(volumeMusicText) .. "\n" ..
	L["TITAN_VOLUME_AMBIENCE_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(volumeAmbienceText) .. "\n" ..
	L["TITAN_VOLUME_DIALOG_TOOLTIP_VALUE"] .. "\t" .. TitanUtils_GetHighlightText(volumeDialogText) .. "\n" ..
	--		L["TITAN_VOLUME_MICROPHONE_TOOLTIP_VALUE"].."\t"..TitanUtils_GetHighlightText(volumeMicrophoneText).."\n"..
	--		L["TITAN_VOLUME_SPEAKER_TOOLTIP_VALUE"].."\t"..TitanUtils_GetHighlightText(volumeSpeakerText).."\n"..
	TitanUtils_GetGreenText(L["TITAN_VOLUME_TOOLTIP_HINT1"]) .. "\n" ..
	TitanUtils_GetGreenText(L["TITAN_VOLUME_TOOLTIP_HINT2"]) .. "\n" ..
	""
	
	return text
end

function CreateMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_VOLUME_ID].menuText);

	local info = {};
	info.notCheckable = true
	info.text = L["TITAN_VOLUME_MENU_AUDIO_OPTIONS_LABEL"];
	info.func = function()
		ShowUIPanel(VideoOptionsFrame);
	end
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	info.text = L["TITAN_VOLUME_MENU_OVERRIDE_BLIZZ_SETTINGS"];
	info.notCheckable = false
	info.func = function()
		TitanToggleVar(TITAN_VOLUME_ID, "OverrideBlizzSettings");
	end
	info.checked = TitanGetVar(TITAN_VOLUME_ID, "OverrideBlizzSettings");
	TitanPanelRightClickMenu_AddButton(info, TitanPanelRightClickMenu_GetDropdownLevel());

	TitanPanelRightClickMenu_AddControlVars(TITAN_VOLUME_ID)
end

local function OnDoubleClick(self, button)
	if button == "LeftButton" then
		-- Toggle mute value
		if IsMuted() then
			SetCVar("Sound_EnableAllSound","1")
		else
			SetCVar("Sound_EnableAllSound","0")
		end
		SetVolumeIcon()
		_G[cname]:Hide()
		TitanPanelButton_UpdateButton(TITAN_VOLUME_ID);
	else
		-- No action
	end
end

local function OnLoad(self)
	local notes = ""
	.. "Adds a volume control icon on your Titan Bar.\n"
	.. L["TITAN_VOLUME_TOOLTIP_HINT1"] .. "\n"
	.. L["TITAN_VOLUME_TOOLTIP_HINT2"] .. "\n"
	--		.."- xxx.\n"
	self.registry = {
		id = TITAN_VOLUME_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_VOLUME_MENU_TEXT"],
		menuTextFunction = CreateMenu,
		tooltipTitle = VOLUME, --L["TITAN_VOLUME_TOOLTIP"],
		tooltipTextFunction = GetTooltipText,
		iconWidth = 32,
		iconButtonWidth = 18,
		notes = notes,
		controlVariables = {
			ShowIcon = false,
			ShowLabelText = false,
			ShowColoredText = false,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			OverrideBlizzSettings = false,
			VolumeMaster = 1,
			VolumeAmbience = 0.5,
			VolumeDialog = 0.5,
			VolumeSFX = 0.5,
			VolumeMusic = 0.5,
			--			VolumeOutboundChat = 1,
			--			VolumeInboundChat = 1,
			DisplayOnRightSide = 1,
		}
	};
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- ====== Create needed frames
local function Create_Frames()
	if _G[TITAN_VOLUME_BUTTON] then
		return -- if already created
	end

	-- general container frame
	local f = CreateFrame("Frame", nil, UIParent)
	--	f:Hide()

	-- Titan plugin button
	local window = CreateFrame("Button", TITAN_VOLUME_BUTTON, f, "TitanPanelIconTemplate")
	window:SetFrameStrata("FULLSCREEN")
	-- Using SetScript("OnLoad",   does not work
	OnLoad(window);
	--	TitanPanelButton_OnLoad(window); -- Titan XML template calls this...w

	window:SetScript("OnShow", function(self)
		OnShow()
		TitanPanelButton_OnShow(self)
	end)
	window:SetScript("OnEnter", function(self)
		OnEnter()
		TitanPanelButton_OnEnter(self)
	end)
	window:SetScript("OnEvent", function(self, event, ...)
		OnEvent(self, event, ...)
		-- ... not allowed here so grab the potential args that may be needed
		--		OnEvent(self, event, arg1, arg2, arg3, arg4)
	end)


	---[===[
	-- Config screen
	local config = CreateFrame("Frame", cname, f, BackdropTemplateMixin and "BackdropTemplate")
	config:SetFrameStrata("FULLSCREEN") --
	config:Hide()
	config:SetWidth(400)
	config:SetHeight(200)

	config:SetScript("OnEnter", function(self)
		TitanUtils_StopFrameCounting(self)
	end)
	config:SetScript("OnLeave", function(self)
		TitanUtils_StartFrameCounting(self, 0.5)
	end)
	config:SetScript("OnUpdate", function(self, elapsed)
		TitanUtils_CheckFrameCounting(self, elapsed)
	end)
	window:SetScript("OnDoubleClick", function(self, button)
		OnDoubleClick(self, button)
--		TitanPanelButton_OnClick(self, button)
	end)

	-- Config font sections
	local str = nil
	local style = "GameFontNormalSmall"
	str = config:CreateFontString(cname .. "Title", "ARTWORK", style)
	str:SetPoint("TOP", config, 0, -10)

	str = config:CreateFontString(cname .. "MasterTitle", "ARTWORK", style)
	str:SetPoint("TOP", config, -160, -30)

	str = config:CreateFontString(cname .. "SoundTitle", "ARTWORK", style)
	str:SetPoint("TOP", config, -90, -30)

	str = config:CreateFontString(cname .. "MusicTitle", "ARTWORK", style)
	str:SetPoint("TOP", config, -20, -30)

	str = config:CreateFontString(cname .. "AmbienceTitle", "ARTWORK", style)
	str:SetPoint("TOP", config, 50, -30)

	str = config:CreateFontString(cname .. "DialogTitle", "ARTWORK", style)
	str:SetPoint("TOP", config, 130, -30)

	-- Config slider sections
	local slider = nil

	-- Master
	local inherit = "TitanOptionsSliderTemplate"
	local master = CreateFrame("Slider", "TitanPanelMasterVolumeControlSlider", config, inherit)
	master:SetPoint("TOP", config, -160, -60)
	master:SetScript("OnShow", function(self)
		MasterSlider_OnShow(self)
	end)
	master:SetScript("OnValueChanged", function(self, value)
		MasterSlider_OnValueChanged(self, value)
	end)
	master:SetScript("OnMouseWheel", function(self, delta)
		OnMouseWheel(self, delta)
	end)
	master:SetScript("OnEnter", function(self)
		MasterSlider_OnEnter(self)
	end)
	master:SetScript("OnLeave", function(self)
		MasterSlider_OnLeave(self)
	end)

	-- Sound
	local sound = CreateFrame("Slider", "TitanPanelSoundVolumeControlSlider", config, inherit)
	sound:SetPoint("TOP", config, -90, -60)
	sound:SetScript("OnShow", function(self)
		SoundSlider_OnShow(self)
	end)
	sound:SetScript("OnValueChanged", function(self, value)
		SoundSlider_OnValueChanged(self, value)
	end)
	sound:SetScript("OnMouseWheel", function(self, delta)
		OnMouseWheel(self, delta)
	end)
	sound:SetScript("OnEnter", function(self)
		SoundSlider_OnEnter(self)
	end)
	sound:SetScript("OnLeave", function(self)
		SoundSlider_OnLeave(self)
	end)

	-- Music
	local music = CreateFrame("Slider", "TitanPanelMusicVolumeControlSlider", config, inherit)
	music:SetPoint("TOP", config, -20, -60)
	music:SetScript("OnShow", function(self)
		MusicSlider_OnShow(self)
	end)
	music:SetScript("OnValueChanged", function(self, value)
		MusicSlider_OnValueChanged(self, value)
	end)
	music:SetScript("OnMouseWheel", function(self, delta)
		OnMouseWheel(self, delta)
	end)
	music:SetScript("OnEnter", function(self)
		MusicSlider_OnEnter(self)
	end)
	music:SetScript("OnLeave", function(self)
		MusicSlider_OnLeave(self)
	end)

	-- Ambience
	local ambience = CreateFrame("Slider", "TitanPanelAmbienceVolumeControlSlider", config, inherit)
	ambience:SetPoint("TOP", config, 50, -60)
	ambience:SetScript("OnShow", function(self)
		AmbienceSlider_OnShow(self)
	end)
	ambience:SetScript("OnValueChanged", function(self, value)
		AmbienceSlider_OnValueChanged(self, value)
	end)
	ambience:SetScript("OnMouseWheel", function(self, delta)
		OnMouseWheel(self, delta)
	end)
	ambience:SetScript("OnEnter", function(self)
		AmbienceSlider_OnEnter(self)
	end)
	ambience:SetScript("OnLeave", function(self)
		AmbienceSlider_OnLeave(self)
	end)

	-- Dialog
	local dialog = CreateFrame("Slider", "TitanPanelDialogVolumeControlSlider", config, inherit)
	dialog:SetPoint("TOP", config, 130, -60)
	dialog:SetScript("OnShow", function(self)
		DialogSlider_OnShow(self)
	end)
	dialog:SetScript("OnValueChanged", function(self, value)
		DialogSlider_OnValueChanged(self, value)
	end)
	dialog:SetScript("OnMouseWheel", function(self, delta)
		OnMouseWheel(self, delta)
	end)
	dialog:SetScript("OnEnter", function(self)
		DialogSlider_OnEnter(self)
	end)
	dialog:SetScript("OnLeave", function(self)
		DialogSlider_OnLeave(self)
	end)

	-- Now that the parts exist, initialize
	ControlFrame_OnLoad(config)

	--]===]
end

Create_Frames() -- do the work
