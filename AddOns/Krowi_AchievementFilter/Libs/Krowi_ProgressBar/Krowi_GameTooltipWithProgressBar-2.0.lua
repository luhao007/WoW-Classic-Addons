--[[
	Krowi's Progress Bar License
		Copyright ©2020 The contents of this library, excluding third-party resources, are
		copyrighted to their authors with all rights reserved.

		This library is free to use and the authors hereby grants you the following rights:

		1. 	You may make modifications to this library for private use only, you
			may not publicize any portion of this library. The only exception being you may
			upload to the github website.

		2. 	Do not modify the name of this library, including the library folders.

		3. 	This copyright notice shall be included in all copies or substantial
			portions of the Software.

		All rights not explicitly addressed in this license are reserved by
		the copyright holders.
]]

local lib = LibStub:NewLibrary("Krowi_GameTooltipWithProgressBar-2.0", 1);

if not lib then
	return;
end

lib.ProgressBar = LibStub("Krowi_ProgressBar-2.0"):GetNew(GameTooltip);
local progressBar = lib.ProgressBar

hooksecurefunc(GameTooltip, "Hide", function()
	if progressBar then
		progressBar:Hide();
	end
end);

function lib:Show(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text)
	progressBar:SetParent(gameTooltip);
	progressBar:Reset();
	progressBar:Add(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text);
	progressBar:Show();
end

function progressBar:Add(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text)
	GameTooltip_AddBlankLinesToTooltip(gameTooltip, 1);
	local numLines = gameTooltip:NumLines();
	if not text then
		text = "";
	end
	self:SetPoint("LEFT", gameTooltip:GetName() .. "TextLeft" .. numLines, "LEFT", 0, -2);
	self:SetPoint("RIGHT", gameTooltip, "RIGHT", -9, 0);
	self:SetHeight(25);
	self.TextLeft:SetText(text);
	self:SetMinMaxValues(min, max);
	self:SetValues(value1, value2, value3, value4);
	self:SetColors(color1, color2, color3, color4);
	self:UpdateTextures();
end