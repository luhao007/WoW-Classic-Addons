-------------------
---NovaWorldBuffs--
-------------------

--Slowly moving all settings and buff data in to this file so things are easier to change around and add new buffs as classic/sod keeps getting changes.

local addonName, addon = ...;
local NWB = addon.a;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
local buffTable = NWB.buffTable;

local NWBbuffListFrame = CreateFrame("ScrollFrame", "NWBbuffListFrame", UIParent, NWB:addBackdrop("NWB_InputScrollFrameTemplate"));
NWBbuffListFrame:Hide();
NWBbuffListFrame:SetToplevel(true);
NWBbuffListFrame:SetMovable(true);
NWBbuffListFrame:EnableMouse(true);
tinsert(UISpecialFrames, "NWBbuffListFrame");
NWBbuffListFrame:SetPoint("CENTER", UIParent, 20, 120);
NWBbuffListFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
NWBbuffListFrame:SetBackdropColor(0,0,0,.6);
NWBbuffListFrame.CharCount:Hide();
--NWBbuffListFrame:SetFrameLevel(128);
NWBbuffListFrame:SetFrameStrata("MEDIUM");
NWBbuffListFrame.EditBox:SetAutoFocus(false);
NWBbuffListFrame.EditBox:SetScript("OnKeyDown", function(self, arg)
	NWBbuffListFrame.EditBox:ClearFocus();
end)
NWBbuffListFrame.EditBox:SetScript("OnShow", function(self, arg)
	NWBbuffListFrame:SetVerticalScroll(0);
end)
local buffUpdateTime = 0;
NWBbuffListFrame:HookScript("OnUpdate", function(self, arg)
	--Only update once per second.
	if (GetServerTime() - buffUpdateTime > 0) then
		NWBbuffListFrame.EditBox:ClearFocus();
		NWB:recalcBuffListFrame();
		buffUpdateTime = GetServerTime();
	end
end)
NWBbuffListFrame.fs = NWBbuffListFrame.EditBox:CreateFontString("NWBbuffListFrameFS", "ARTWORK");
NWBbuffListFrame.fs:SetPoint("TOP", 0, 0);
NWBbuffListFrame.fs:SetFont(NWB.regionFont, 14);
NWBbuffListFrame.fs:SetText("|cffffff00" .. L["Your Current World Buffs"]);
NWBbuffListFrame.fs2 = NWBbuffListFrame.EditBox:CreateFontString("NWBbuffListFrameFS2", "ARTWORK");
NWBbuffListFrame.fs2:SetPoint("TOP", 0, -16);
NWBbuffListFrame.fs2:SetFont(NWB.regionFont, 13);
NWBbuffListFrame.fs2:SetText("|cffffff00" .. L["Mouseover char names for extra info"]);
NWBbuffListFrame.fs3 = NWBbuffListFrame.EditBox:CreateFontString("NWBbuffListFrameFS3", "ARTWORK");
NWBbuffListFrame.fs3:SetPoint("TOPLEFT", 1, -32);
NWBbuffListFrame.fs3:SetFont(NWB.regionFont, 13);
--NWBbuffListFrame.fs3:SetText("");

local NWBbuffListDragFrame = CreateFrame("Frame", "NWBbuffListDragFrame", NWBbuffListFrame);
--NWBbuffListDragFrame:SetToplevel(true);
NWBbuffListDragFrame:EnableMouse(true);
NWBbuffListDragFrame:SetWidth(205);
NWBbuffListDragFrame:SetHeight(38);
NWBbuffListDragFrame:SetPoint("TOP", 0, 4);
NWBbuffListDragFrame:SetFrameLevel(131);
NWBbuffListDragFrame.tooltip = CreateFrame("Frame", "NWBbuffListDragTooltip", NWBbuffListDragFrame, "TooltipBorderedFrameTemplate");
NWBbuffListDragFrame.tooltip:SetPoint("CENTER", NWBbuffListDragFrame, "TOP", 0, 12);
NWBbuffListDragFrame.tooltip:SetFrameStrata("TOOLTIP");
NWBbuffListDragFrame.tooltip:SetFrameLevel(9);
NWBbuffListDragFrame.tooltip:SetAlpha(.8);
NWBbuffListDragFrame.tooltip.fs = NWBbuffListDragFrame.tooltip:CreateFontString("NWBbuffListDragTooltipFS", "ARTWORK");
NWBbuffListDragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
NWBbuffListDragFrame.tooltip.fs:SetFont(NWB.regionFont, 12);
NWBbuffListDragFrame.tooltip.fs:SetText(L["Hold to drag"]);
NWBbuffListDragFrame.tooltip:SetWidth(NWBbuffListDragFrame.tooltip.fs:GetStringWidth() + 16);
NWBbuffListDragFrame.tooltip:SetHeight(NWBbuffListDragFrame.tooltip.fs:GetStringHeight() + 10);
NWBbuffListDragFrame:SetScript("OnEnter", function(self)
	NWBbuffListDragFrame.tooltip:Show();
end)
NWBbuffListDragFrame:SetScript("OnLeave", function(self)
	NWBbuffListDragFrame.tooltip:Hide();
end)
NWBbuffListDragFrame.tooltip:Hide();
NWBbuffListDragFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent().isMoving) then
		self:GetParent().EditBox:ClearFocus();
		self:GetParent():StartMoving();
		self:GetParent().isMoving = true;
		--self:GetParent():SetUserPlaced(false);
	end
end)
NWBbuffListDragFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)
NWBbuffListDragFrame:SetScript("OnHide", function(self)
	if (self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)

--Top right X close button.
local NWBbuffListFrameClose = CreateFrame("Button", "NWBbuffListFrameClose", NWBbuffListFrame, "UIPanelCloseButton");
NWBbuffListFrameClose:SetPoint("TOPRIGHT", -12, 3.75);
NWBbuffListFrameClose:SetWidth(20);
NWBbuffListFrameClose:SetHeight(20);
NWBbuffListFrameClose:SetFrameLevel(3);
NWBbuffListFrameClose:SetScript("OnClick", function(self, arg)
	NWBbuffListFrame:Hide();
end)
--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
--Big thanks to Meorawr for this.
NWBbuffListFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBbuffListFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBbuffListFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBbuffListFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

--Config button.
local NWBbuffListFrameConfButton = CreateFrame("Button", "NWBbuffListFrameConfButton", NWBbuffListFrame.EditBox, "UIPanelButtonTemplate");
NWBbuffListFrameConfButton:SetPoint("TOPRIGHT", -8, 0);
NWBbuffListFrameConfButton:SetWidth(90);
NWBbuffListFrameConfButton:SetHeight(17);
NWBbuffListFrameConfButton:SetText(L["Options"]);
NWBbuffListFrameConfButton:SetNormalFontObject("GameFontNormalSmall");
NWBbuffListFrameConfButton:SetScript("OnClick", function(self, arg)
	NWB:openConfig();
end)
NWBbuffListFrameConfButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBbuffListFrameConfButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBbuffListFrameConfButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

local NWBbuffListFrameTimersButton = CreateFrame("Button", "NWBbuffListFrameTimersButton", NWBbuffListFrameClose, "UIPanelButtonTemplate");
NWBbuffListFrameTimersButton:SetPoint("CENTER", -58, -13);
NWBbuffListFrameTimersButton:SetWidth(90);
NWBbuffListFrameTimersButton:SetHeight(17);
NWBbuffListFrameTimersButton:SetText("Timers");
NWBbuffListFrameTimersButton:SetNormalFontObject("GameFontNormalSmall");
NWBbuffListFrameTimersButton:SetScript("OnClick", function(self, arg)
	NWB:openLayerFrame();
end)
NWBbuffListFrameTimersButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBbuffListFrameTimersButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBbuffListFrameTimersButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBbuffListFrameTimersButton:Hide();

--Wipe data button.
local NWBbuffListFrameWipeButton = CreateFrame("Button", "NWBbuffListFrameWipeButton", NWBbuffListFrame.EditBox, "UIPanelButtonTemplate");
NWBbuffListFrameWipeButton:SetPoint("TOPRIGHT", -8, -16);
NWBbuffListFrameWipeButton:SetWidth(90);
NWBbuffListFrameWipeButton:SetHeight(17);
NWBbuffListFrameWipeButton:SetFrameLevel(3);
NWBbuffListFrameWipeButton:SetText(L["Reset Data"]);
NWBbuffListFrameWipeButton:SetNormalFontObject("GameFontNormalSmall");
NWBbuffListFrameWipeButton:SetScript("OnClick", function(self, arg)
	StaticPopupDialogs["NWB_BUFFDATARESET"] = {
	  text = "Delete buff data?",
	  button1 = "Yes",
	  button2 = "No",
	  OnAccept = function()
	      NWB:resetBuffData();
	  end,
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = true,
	  preferredIndex = 3,
	};
	StaticPopup_Show("NWB_BUFFDATARESET");
end)

NWBbuffListFrameWipeButton.tooltip = CreateFrame("Frame", "NWBbuffListResetButtonTooltip", NWBbuffListFrame, "TooltipBorderedFrameTemplate");
NWBbuffListFrameWipeButton.tooltip:SetPoint("CENTER", NWBbuffListFrameWipeButton, "TOP", 0, 14);
NWBbuffListFrameWipeButton.tooltip.fs = NWBbuffListFrameWipeButton.tooltip:CreateFontString("NWBbuffListDragTooltipFS", "ARTWORK");
NWBbuffListFrameWipeButton.tooltip.fs:SetPoint("CENTER", 0, 0.5);
NWBbuffListFrameWipeButton.tooltip.fs:SetFont(NWB.regionFont, 12);
NWBbuffListFrameWipeButton.tooltip:SetFrameLevel(132);
NWBbuffListFrameWipeButton.tooltip.fs:SetText("|cFFFFFF00" .. L["buffResetButtonTooltip"]);
NWBbuffListFrameWipeButton.tooltip:SetWidth(NWBbuffListFrameWipeButton.tooltip.fs:GetStringWidth() + 16);
NWBbuffListFrameWipeButton.tooltip:SetHeight(NWBbuffListFrameWipeButton.tooltip.fs:GetStringHeight() + 10);
NWBbuffListFrameWipeButton:SetScript("OnEnter", function(self)
	NWBbuffListFrameWipeButton.tooltip:Show();
end)
NWBbuffListFrameWipeButton:SetScript("OnLeave", function(self)
	NWBbuffListFrameWipeButton.tooltip:Hide();
end)
NWBbuffListFrameWipeButton.tooltip:Hide();

function NWB:createBuffsListExtraButtons()
	if (not NWB.showStatsButton) then
		NWB.showStatsButton = CreateFrame("CheckButton", "NWBShowStatsButton", NWBbuffListFrame.EditBox, "ChatConfigCheckButtonTemplate");
		NWB.showStatsButton:SetPoint("TOPLEFT", -1, 1);
		--So strange the way to set text is to append Text to the global frame name.
		NWBShowStatsButtonText:SetText(L["Show Stats"]);
		NWB.showStatsButton.tooltip = L["Show how many times you got each buff."];
		--NWB.showStatsButton:SetFrameStrata("HIGH");
		NWB.showStatsButton:SetFrameLevel(3);
		NWB.showStatsButton:SetWidth(24);
		NWB.showStatsButton:SetHeight(24);
		NWB.showStatsButton:SetChecked(NWB.db.global.showBuffStats);
		NWB.showStatsButton:SetScript("OnClick", function()
			local value = NWB.showStatsButton:GetChecked();
			NWB.db.global.showBuffStats = value;
			--NWB:recalcBuffListFrame(true);
			NWB:recalcBuffListFrame();
			--Refresh the config page.
			NWB.acr:NotifyChange("NovaWorldBuffs");
		end)
	end
	if (not NWB.showStatsAllButton) then
		NWB.showStatsAllButton = CreateFrame("CheckButton", "NWBShowStatsAllButton", NWBbuffListFrame.EditBox, "ChatConfigCheckButtonTemplate");
		NWB.showStatsAllButton:SetPoint("TOPLEFT", 95, 1);
		NWBShowStatsAllButtonText:SetText(L["All"]);
		NWB.showStatsAllButton.tooltip = L["Show all alts that have buff stats? (stats must be enabled)."];
		--NWB.showStatsAllButton:SetFrameStrata("HIGH");
		NWB.showStatsAllButton:SetFrameLevel(4);
		NWB.showStatsAllButton:SetWidth(24);
		NWB.showStatsAllButton:SetHeight(24);
		NWB.showStatsAllButton:SetChecked(NWB.db.global.showBuffAllStats);
		NWB.showStatsAllButton:SetScript("OnClick", function()
			local value = NWB.showStatsAllButton:GetChecked();
			NWB.db.global.showBuffAllStats = value;
			--NWB:recalcBuffListFrame(true);
			NWB:recalcBuffListFrame();
			--Refresh the config page.
			NWB.acr:NotifyChange("NovaWorldBuffs");
		end)
	end
	if (not NWB.charsMinLevelSlider) then
		NWB.charsMinLevelSlider = CreateFrame("Slider", "NWBCharsMinLevelSlider", NWBbuffListFrame.EditBox, "OptionsSliderTemplate");
		NWB.charsMinLevelSlider:SetPoint("TOPRIGHT", 8, -47);
		NWBCharsMinLevelSliderText:SetText(L["Min Level"]);
		--NWB.charsMinLevelSlider.tooltipText = "Minimum level alts to show?";
		--NWB.charsMinLevelSlider:SetFrameStrata("HIGH");
		NWB.charsMinLevelSlider:SetFrameLevel(5);
		NWB.charsMinLevelSlider:SetWidth(120);
		NWB.charsMinLevelSlider:SetHeight(12);
		NWB.charsMinLevelSlider:SetMinMaxValues(1, NWB.maxLevel > 59 and NWB.maxLevel or 60);
	    NWB.charsMinLevelSlider:SetObeyStepOnDrag(true);
	    NWB.charsMinLevelSlider:SetValueStep(1);
	    NWB.charsMinLevelSlider:SetStepsPerPage(1);
		NWB.charsMinLevelSlider:SetValue(NWB.db.global.buffsFrameMinLevel);
		NWBCharsMinLevelSliderLow:SetText("1");
		NWBCharsMinLevelSliderHigh:SetText(NWB.maxLevel > 59 and NWB.maxLevel or 60);
		NWBCharsMinLevelSlider:HookScript("OnValueChanged", function(self, value)
			NWB.db.global.buffsFrameMinLevel = value;
			NWB.charsMinLevelSlider.editBox:SetText(value);
			NWB:recalcBuffListFrame();
		end)
		--Some of this was taken from AceGUI.
		local function EditBox_OnEscapePressed(frame)
			frame:ClearFocus();
		end
		local function EditBox_OnEnterPressed(frame)
			local value = frame:GetText();
			value = tonumber(value);
			if value then
				PlaySound(856);
				NWB.db.global.buffsFrameMinLevel = value;
				NWB.charsMinLevelSlider:SetValue(value);
				frame:ClearFocus();
				NWB:recalcBuffListFrame();
			else
				--If not a valid number reset the box.
				NWB.charsMinLevelSlider.editBox:SetText(NWB.db.global.buffsFrameMinLevel);
				frame:ClearFocus();
			end
		end
		local function EditBox_OnEnter(frame)
			frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		end
		local function EditBox_OnLeave(frame)
			frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8);
		end
		local ManualBackdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
		};
		NWB.charsMinLevelSlider.editBox = CreateFrame("EditBox", nil, NWB.charsMinLevelSlider, NWB:addBackdrop());
		NWB.charsMinLevelSlider.editBox:SetAutoFocus(false);
		NWB.charsMinLevelSlider.editBox:SetFontObject(GameFontHighlightSmall);
		NWB.charsMinLevelSlider.editBox:SetPoint("TOP", NWB.charsMinLevelSlider, "BOTTOM");
		NWB.charsMinLevelSlider.editBox:SetHeight(14);
		NWB.charsMinLevelSlider.editBox:SetWidth(70);
		NWB.charsMinLevelSlider.editBox:SetJustifyH("CENTER");
		NWB.charsMinLevelSlider.editBox:EnableMouse(true);
		NWB.charsMinLevelSlider.editBox:SetBackdrop(ManualBackdrop);
		NWB.charsMinLevelSlider.editBox:SetBackdropColor(0, 0, 0, 0.5);
		NWB.charsMinLevelSlider.editBox:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80);
		NWB.charsMinLevelSlider.editBox:SetScript("OnEnter", EditBox_OnEnter);
		NWB.charsMinLevelSlider.editBox:SetScript("OnLeave", EditBox_OnLeave);
		NWB.charsMinLevelSlider.editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed);
		NWB.charsMinLevelSlider.editBox:SetScript("OnEscapePressed", EditBox_OnEscapePressed);
		NWB.charsMinLevelSlider.editBox:SetText(NWB.db.global.buffsFrameMinLevel);
	end
end

NWBbuffListFrame.fsCalc = NWBbuffListFrame:CreateFontString("NWBBufflistCalcFS", "ARTWORK");
NWBbuffListFrame.fsCalc:SetFont(NWB.regionFont, 13);

local lineFrameCount = 0;
function NWB:createBuffsLineFrame(type, data)
	if (not _G[type .. "NWBBuffsLine"]) then
		local obj = CreateFrame("Frame", type .. "NWBBuffsLine", NWBbuffListFrame.EditBox);
		obj.id = type;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj.fs = obj:CreateFontString(type .. "NWBBuffsLineFS", "ARTWORK");
		obj.fs:SetPoint("LEFT", 0, 0);
		obj.fs:SetFont(NWB.regionFont, 14);
		--They don't quite line up properly without justify on top of set point left.
		obj.fs:SetJustifyH("LEFT");
		obj.tooltip = CreateFrame("Frame", type .. "NWBBuffsLineTooltip", NWBbuffListFrame, "TooltipBorderedFrameTemplate");
		--obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -46);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(256);
		obj.tooltip.fs = obj.tooltip:CreateFontString(type .. "NWBBuffsLineTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 13);
		obj.tooltip.fs:SetJustifyH("LEFT");
		obj.tooltip.fs:SetText("|CffDEDE42Frame " .. type);
		obj.tooltip.fsCalc = obj.tooltip:CreateFontString(type .. "NWBBuffsLineTooltipFS", "ARTWORK");
		obj.tooltip.fsCalc:SetFont(NWB.regionFont, 13);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		obj.tooltip.updateTime = 0;
		obj.tooltip:SetScript("OnUpdate", function(self)
			obj.tooltip:SetFrameStrata("TOOLTIP");
			--Keep our custom tooltip at the mouse when it moves.
			local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
			obj.tooltip:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 2, y / scale);
			--Only update once per second.
			if (GetServerTime() - obj.tooltip.updateTime > 0) then
				obj.tooltip.updateTime = GetServerTime();
				NWB:recalcBuffsLineFramesTooltip(obj);
			end
		end)
		obj:SetScript("OnEnter", function(self)
			if (obj.tooltipData) then
				obj.tooltip:Show();
				NWB:recalcBuffsLineFramesTooltip(obj);
				obj.tooltip:SetFrameStrata("TOOLTIP");
				local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
				obj.tooltip:SetPoint("CENTER", nil, "BOTTOMLEFT", x / scale, y / scale);
			end
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		--obj:SetScript("OnMouseDown", function(self)
			--Maybe add a mouse event here later.
		--end)
		
		--[[obj.removeButton = CreateFrame("Button", type .. "NWBBuffsLineRB", obj, "UIPanelButtonTemplate");
		obj.removeButton:SetPoint("LEFT", obj, "RIGHT", 34, 0);
		obj.removeButton:SetWidth(13);
		obj.removeButton:SetHeight(13);
		obj.removeButton:SetNormalFontObject("GameFontNormalSmall");
		--obj.removeButton:SetScript("OnClick", function(self, arg)

		--end)
		obj.removeButton:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_7");
		obj.removeButton.tooltip = CreateFrame("Frame", type .. "NWBBuffsLineTooltipRB", NWBBuffListFrame, "TooltipBorderedFrameTemplate");
		obj.removeButton.tooltip:SetPoint("RIGHT", obj.removeButton, "LEFT", -5, 0);
		obj.removeButton.tooltip:SetFrameStrata("HIGH");
		obj.removeButton.tooltip:SetFrameLevel(3);
		obj.removeButton.tooltip.fs = obj.removeButton.tooltip:CreateFontString(type .. "NWBBuffsLineTooltipRBFS", "ARTWORK");
		obj.removeButton.tooltip.fs:SetPoint("CENTER", -0, 0);
		obj.removeButton.tooltip.fs:SetFont(NWB.regionFont, 13);
		obj.removeButton.tooltip.fs:SetJustifyH("LEFT");
		obj.removeButton.tooltip.fs:SetText("|CffDEDE42" .. L["deleteEntry"] .. " " .. count);
		obj.removeButton.tooltip:SetWidth(obj.removeButton.tooltip.fs:GetStringWidth() + 18);
		obj.removeButton.tooltip:SetHeight(obj.removeButton.tooltip.fs:GetStringHeight() + 12);
		obj.removeButton:SetScript("OnEnter", function(self)
			obj.removeButton.tooltip:Show();
		end)
		obj.removeButton:SetScript("OnLeave", function(self)
			obj.removeButton.tooltip:Hide();
		end)
		obj.removeButton.tooltip:Hide();]]
		lineFrameCount = lineFrameCount + 1;
	end
end

function NWB:openBuffListFrame()
	if (not NWB.showStatsButton) then
		NWB:createBuffsListExtraButtons();
	end
	NWBbuffListFrame.fs:SetFont(NWB.regionFont, 14);
	if (NWBbuffListFrame:IsShown()) then
		NWBbuffListFrame:Hide();
	else
		--if (NWB.isLayered) then
		--	NWBbuffListFrameTimersButton:Show();
		--end
		NWB:syncBuffsWithCurrentDuration();
		NWBbuffListFrame:SetHeight(NWB.db.global.buffWindowHeight);
		NWBbuffListFrame:SetWidth(NWB.db.global.buffWindowWidth);
		local fontSize = false;
		NWBbuffListFrame.EditBox:SetFont(NWB.regionFont, 14, "");
		NWBbuffListFrame.EditBox:SetWidth(NWBbuffListFrame:GetWidth() - 30);
		NWBbuffListFrame:Show();
		--Changing scroll position requires a slight delay.
		--Second delay is a backup.
		C_Timer.After(0.05, function()
			NWBbuffListFrame:SetVerticalScroll(0);
		end)
		C_Timer.After(0.3, function()
			NWBbuffListFrame:SetVerticalScroll(0);
		end)
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame:IsShown()) then
			NWBbuffListFrame:SetFrameStrata("DIALOG");
		else
			NWBbuffListFrame:SetFrameStrata("HIGH");
		end
		NWB:recalcBuffListFrame();
	end
end

local framesUsed = {};
local usedLineFrameCount = 0;
local offset = 40;
function NWB:recalcBuffListFrame()
	if (not NWB.showStatsButton) then
		--Frame hasn't been opened since logon, no need to recalc.
		return;
	end
	framesUsed = {};
	usedLineFrameCount = 0;
	offset = 40; --Start offset, per line offset.
	if (NWB.isDmfUp or NWB.isAlwaysDMF) then
		offset = 57;
		local dmfCooldown, noMsgs = NWB:getDmfCooldown();
		if (dmfCooldown > 0 and not noMsgs) then
			NWBbuffListFrame.fs3:SetText(string.format("|cFF69CCF0" .. L["dmfBuffCooldownMsg2"] .. "|r",  NWB:getTimeString(dmfCooldown, true)));
	    elseif (NWB.isDmfUp) then
	    	NWBbuffListFrame.fs3:SetText("|cFF69CCF0" .. L["dmfBuffReady"] .. "|r");
	    end
	end
	local count = 0;
	local foundChars;
	local maxWidth = 0;
	local printRealm;
	local buffsFrameMinLevel = NWB.db.global.buffsFrameMinLevel;
	for k, v in NWB:pairsByKeys(NWB.db.global) do --Iterate realms.
		if (type(v) == "table" and k ~= "minimapIcon" and k ~= "versions") then --The only tables in db.global are realm names.
			local realm = k;
			for k, v in NWB:pairsByKeys(v) do --Iterate factions.
				local faction = k;
				--local coloredFaction = "";
				--if (k == "Horde") then
				--	coloredFaction = "|cffe50c11" .. k .. "|r";
				--else
				--	coloredFaction = "|cff4954e8" .. k .. "|r";
				--end
				local realmString = "|cff00ff00[" .. realm .. "]|r\n";
				printRealm = false;
				--Have to check if the myChars table exists here.
				--There was a lua error when much older versions upgraded to the buff tracking version.
				--They had realmdata in thier db file without the myChars table and it won't create it until they log on that realm.
				if (v.myChars) then
					local foundActiveBuff, foundStoredBuff, foundChrono, foundChronoCooldown;
					for k, v in NWB:pairsByKeys(v.myChars) do --Iterate characters.
						if (v.level >= buffsFrameMinLevel) then
							foundActiveBuff = nil;
							foundStoredBuff = nil;
							foundChrono = nil;
							foundChronoCooldown = nil;
							local nameString = "";
							local _, _, _, classColor = GetClassColor(v.englishClass);
							--Some other addon is breaking the shaman class hex, so now we have to check if it exists.
							if (not classColor) then
								classColor = "ff696969";
							end
							local pvpFlagMsg = "";
							local chronoCountMsg = "";
							local chronoCooldownMsg = "";
							local buffString = "";
							local buffStrings = {};
							local storedBuffString = "";
							local storedBuffStrings = {};
							local statsBuffString = "";
							local statsBuffStrings = {};
							local charData = v;
							if (v.pvpFlag) then
								local texture = "";
								if (v.faction and v.faction == "Horde") then
									texture = "|TInterface\\AddOns\\NovaWorldBuffs\\Media\\hordepvp:13:13:-1:0|t";
								else
									texture = "|TInterface\\AddOns\\NovaWorldBuffs\\Media\\alliancepvp:13:13:-1:0|t";
								end
								pvpFlagMsg = " " .. texture;
							end
							if (v.chronoCooldown and v.chronoCooldown > GetServerTime()) then
								chronoCooldownMsg = " |cFFA0A0A0(" .. L["Cooldown"] .. ": " .. NWB:getTimeString(v.chronoCooldown - GetServerTime(),
										true, NWB.db.global.timeStringType, nil, true) .. ")|r";
								foundChronoCooldown = true;
							end
							if (v.chronoCount and (v.chronoCount > 0 or foundChronoCooldown)) then
								local texture = "|TInterface\\Icons\\inv_misc_enggizmos_21:12:12:-1:0|t"
								chronoCountMsg = " " .. texture .. "|cffffff00" .. v.chronoCount .. "|r";
								foundChrono = true;
							end
							if (foundChrono) then
								nameString = "  -|c" .. classColor .. k .. "|r" .. pvpFlagMsg .. " " .. chronoCountMsg .. chronoCooldownMsg;
							else
								nameString = "  -|c" .. classColor .. k .. "|r" .. pvpFlagMsg;
							end
							if (k == UnitName("player")) then
								nameString = nameString .. " |cFF00C800(" .. L["Online"] .. ")|r";
							elseif (NWB.isDmfUp and v.lo and v.dmfCooldown and v.dmfCooldown > 0) then
								local resting = "";
								if (v.resting) then
									resting = " " .. L["Rested"] .. "";
								else
									resting = " " .. L["Not Rested"] .. "";
								end
								nameString = nameString .. " |cFFA0A0A0(" .. L["Offline"] .. " for " .. NWB:getTimeString(GetServerTime() - v.lo, true, "short") .. resting .. ")|r";
								foundActiveBuff = true;
							end
							local charName = k;
							local foundBuffs = {};
							local storedBuffs = {};
							for k, v in NWB:pairsByKeys(v.buffs) do --Iterate buffs.
								buffString = "";
								if (v.track and v.timeLeft > 0) then
									local icon = "";
									if (buffTable[v.type]) then
										icon = buffTable[v.type].icon;
									end
									local buffName = k;
									if (k == "Supreme Power") then
										buffName = "Flask of Supreme Power";
									elseif (k == "Distilled Wisdom") then
										buffName = "Flask of Distilled Wisdom";
									end
									if (k == L["Sayge's Dark Fortune of Damage"] and v.dmfPercent) then
										buffString = buffString .. "        " .. icon .. " |cFFFFAE42" .. buffName .. " (" .. v.dmfPercent .. "%) ";
									else
										buffString = buffString .. "        " .. icon .. " |cFFFFAE42" .. buffName .. "  ";
									end
									if (storedBuffs[k]) then
										buffString = buffString .. "|cFF9CD6DE(Inactive due to Chronoboon stored buff)|r"
									else
										if (NWB.db.global.showBuffStats and NWB.data.myChars[charName]
												and NWB.data.myChars[charName][v.type .. "Count"] and NWB.data.myChars[charName][v.type .. "Count"] > 0) then
											buffString = buffString .. "|cFF9CD6DE" .. NWB:getTimeString(v.timeLeft, true) .. "|r";
											local buffCount = NWB.data.myChars[charName][v.type .. "Count"];
											if (v.type == "ony" or v.type == "nef") then
												--If ony or nef then add them together, same buff.
												local onyBuffCount, nefBuffCount = 0, 0;
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["onyCount"]) then
													onyBuffCount = NWB.db.global[realm][faction].myChars[charName]["onyCount"];
												end
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["nefCount"]) then
													nefBuffCount = NWB.db.global[realm][faction].myChars[charName]["nefCount"];
												end
												buffCount = onyBuffCount + nefBuffCount;
											end
											if (buffCount == 1) then
												buffString = buffString .. " |cFFA0A0A0" .. string.format(L["time"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											else
												buffString = buffString .. " |cFFA0A0A0" .. string.format(L["times"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											end
										else
											buffString = buffString .. "|cFF9CD6DE" .. NWB:getTimeString(v.timeLeft, true) .. ".|r\n";
										end
									end
									foundActiveBuff = true;
									foundBuffs[v.type] = true;
									table.insert(buffStrings, buffString);
								end
							end
							if (v.storedBuffs and next(v.storedBuffs)) then
								for k, v in NWB:pairsByKeys(v.storedBuffs) do --Iterate buffs.
									storedBuffString = "";
									if (v.track and v.timeLeft > 0) then
										storedBuffs[k] = true;
										local icon = "";
										if (buffTable[v.type]) then
											icon = buffTable[v.type].icon;
										end
										local buffName = k;
										if (k == "Supreme Power") then
											buffName = "Flask of Supreme Power";
										elseif (k == "Distilled Wisdom") then
											buffName = "Flask of Distilled Wisdom";
										end
										storedBuffString = storedBuffString .. "        |cffffff00--|r" .. icon .. " |cFFFFAE42" .. buffName .. "  ";
										if (NWB.db.global.showBuffStats and NWB.data.myChars[charName]
												and NWB.data.myChars[charName][v.type .. "Count"] and NWB.data.myChars[charName][v.type .. "Count"] > 0) then
											storedBuffString = storedBuffString .. "|cFF9CD6DE" .. NWB:getTimeString(v.timeLeft, true) .. "|r";
											local buffCount = NWB.data.myChars[charName][v.type .. "Count"];
											if (v.type == "ony" or v.type == "nef") then
												--If ony or nef then add them together, same buff.
												local onyBuffCount, nefBuffCount = 0, 0;
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["onyCount"]) then
													onyBuffCount = NWB.db.global[realm][faction].myChars[charName]["onyCount"];
												end
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["nefCount"]) then
													nefBuffCount = NWB.db.global[realm][faction].myChars[charName]["nefCount"];
												end
												buffCount = onyBuffCount + nefBuffCount;
											end
											if (buffCount == 1) then
												storedBuffString = storedBuffString .. " |cFFA0A0A0" .. string.format(L["time"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											else
												storedBuffString = storedBuffString .. " |cFFA0A0A0" .. string.format(L["times"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											end
										else
											storedBuffString = storedBuffString .. "|cFF9CD6DE" .. NWB:getTimeString(v.timeLeft, true) .. ".|r\n";
										end
										foundStoredBuff = true;
										foundBuffs[v.type] = true;
										table.insert(storedBuffStrings, storedBuffString);
									end
								end
							end
							if (NWB.db.global.showBuffStats and NWB.db.global.showBuffAllStats) then
								local onyCalc;
								for k, v in NWB:pairsByKeys(v) do
									statsBuffString = "";
									local key = string.gsub(k, "%Count", "")
									if (buffTable[key] and not foundBuffs[key] and tonumber(v) and v > 0) then
										if (not foundActiveBuff and not NWB.db.global.showUnbuffedAlts) then
											foundActiveBuff = true;
										end
										local buffName = buffTable[key].fullName;
										if (buffName == "Supreme Power") then
											buffName = "Flask of Supreme Power";
										elseif (buffName == "Distilled Wisdom") then
											buffName = "Flask of Distilled Wisdom";
										end
										local icon = buffTable[key].icon;
										local buffCount = v;
										local skip;
										if (key == "ony" or key == "nef") then
											if (not onyCalc and not foundBuffs["ony"] and not foundBuffs["nef"]) then
												--If ony or nef then add them together, same buff.
												local onyBuffCount, nefBuffCount = 0, 0;
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["onyCount"]) then
													onyBuffCount = NWB.db.global[realm][faction].myChars[charName]["onyCount"];
												end
												if (NWB.db.global[realm][faction].myChars[charName]
														and NWB.db.global[realm][faction].myChars[charName]["nefCount"]) then
													nefBuffCount = NWB.db.global[realm][faction].myChars[charName]["nefCount"];
												end
												buffCount = onyBuffCount + nefBuffCount;
												onyCalc = true;
											else
												skip = true;
											end
										end
										if (not skip) then
											statsBuffString = statsBuffString .. "        " .. icon .. " |cFFA0A0A0" .. buffName .. "  ";
											if (v == 1) then
												statsBuffString = statsBuffString .. " |cFFA0A0A0" .. string.format(L["time"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											else
												statsBuffString = statsBuffString .. " |cFFA0A0A0" .. string.format(L["times"], buffCount) .. "|r|cFF9CD6DE.|r\n";
											end
											foundChars = true;
									 		foundStoredBuff = true;
											table.insert(statsBuffStrings, statsBuffString);
								 		end
									end
								end
							end
							if (foundActiveBuff or foundStoredBuff or foundStoredBuff or NWB.db.global.showUnbuffedAlts) then
								if (not printRealm) then
									--Realm gold count disabled for now.
									--NWB:insertBuffsLineFrameString(realmString, realm, "realm");
									NWB:insertBuffsLineFrameString(realmString);
									printRealm = true;
								end
								NWB:insertBuffsLineFrameString(nameString, charData, "char");
								if (next(buffStrings)) then
									for k, v in ipairs(buffStrings) do
										NWBbuffListFrame.fsCalc:SetText(v);
										local width = NWBbuffListFrame.fsCalc:GetWidth() + 60;
										if (width > maxWidth) then
											maxWidth = width;
										end
										--if (charData.playerName) then
										--	NWB:insertBuffsLineFrameString(v, charData, "char");
										--else
											NWB:insertBuffsLineFrameString(v);
										--end
									end
								end
								if (next(storedBuffStrings)) then
									NWB:insertBuffsLineFrameString("        |cffffff00" .. L["Chronoboon Displacer"] .. " " .. L["Buffs"] .. "|r");
									for k, v in ipairs(storedBuffStrings) do
										NWBbuffListFrame.fsCalc:SetText(v);
										local width = NWBbuffListFrame.fsCalc:GetWidth() + 60;
										if (width > maxWidth) then
											maxWidth = width;
										end
										NWB:insertBuffsLineFrameString(v);
									end
								end
								if (next(statsBuffStrings)) then
									for k, v in ipairs(statsBuffStrings) do
										NWBbuffListFrame.fsCalc:SetText(v);
										local width = NWBbuffListFrame.fsCalc:GetWidth() + 60;
										if (width > maxWidth) then
											maxWidth = width;
										end
										NWB:insertBuffsLineFrameString(v);
									end
								end
							 	foundChars = true;
							end
						end
					end
				end
			end
		end
	end
	if (not foundChars) then
		NWBbuffListFrame.fs2:SetText("");
		NWB:insertBuffsLineFrameString("|cffffff00No characters with buffs found.");
	else
		NWBbuffListFrame.fs2:SetText("|cffffff00" .. L["Mouseover char names for extra info"]);
	end
	if (NWB.db.global.showBuffStats) then
		--A little wider to fit the buff count.
		maxWidth = maxWidth + 20;
		if ((maxWidth) > NWBbuffListFrame:GetWidth()) then
			NWBbuffListFrame:SetWidth(maxWidth);
		end
	else
		NWBbuffListFrame:SetWidth(NWB.db.global.buffWindowWidth);
	end
	--Hide any no longer is use lines frames from the bottom.
	for i = 1, lineFrameCount do
		if (_G[i .. "NWBBuffsLine"] and not framesUsed[i]) then
			_G[i .. "NWBBuffsLine"]:Hide();
			_G[i .. "NWBBuffsLine"].tooltipData = nil;
			_G[i .. "NWBBuffsLine"].tooltipType = nil;
		end
	end
end

function NWB:insertBuffsLineFrameString(text, data, type)
	usedLineFrameCount = usedLineFrameCount + 1;
	NWB:createBuffsLineFrame(usedLineFrameCount);
	if (_G[usedLineFrameCount .. "NWBBuffsLine"]) then
		--count = count + 1;
		if (usedLineFrameCount > 9999) then
			if (_G[usedLineFrameCount .. "NWBBuffsLine"]) then
				_G[count .. "NWBBuffsLine"]:Hide();
			end
		else
			_G[usedLineFrameCount .. "NWBBuffsLine"].tooltipData = data;
			_G[usedLineFrameCount .. "NWBBuffsLine"].tooltipType = type;
			framesUsed[usedLineFrameCount] = true;
			_G[usedLineFrameCount .. "NWBBuffsLine"]:Show();
			_G[usedLineFrameCount .. "NWBBuffsLine"]:ClearAllPoints();
			--Line the left side of this frame up with the exact same as a normal InputScrollFrameTemplate editbox left side.
			_G[usedLineFrameCount .. "NWBBuffsLine"]:SetPoint("LEFT", NWBbuffListFrame.EditBox, "TOPLEFT", 1.4, -offset);
			offset = offset + 14;
			local line = text;
			--if (usedLineFrameCount < 00) then
				--Offset the text for single digit numbers so the date comlumn lines up.
			--	_G[usedLineFrameCount .. "NWBBuffsLine"].fs:SetPoint("LEFT", 7, 0);
			--else
			--	_G[usedLineFrameCount .. "NWBBuffsLine"].fs:SetPoint("LEFT", 0, 0);
			--end
			_G[usedLineFrameCount .. "NWBBuffsLine"].fs:SetText(line);
			--Leave enough room on the right of frame to not overlap the scroll bar (-20) and remove button (-20).
			_G[usedLineFrameCount .. "NWBBuffsLine"]:SetWidth(NWBbuffListFrame:GetWidth() - 120);
			_G[usedLineFrameCount .. "NWBBuffsLine"]:SetHeight(_G[usedLineFrameCount .. "NWBBuffsLine"].fs:GetHeight());
			--_G[usedLineFrameCount .. "NWBBuffsLine"].removeButton.usedLineFrameCount = usedLineFrameCount;
			--_G[usedLineFrameCount .. "NWBBuffsLine"].removeButton:SetScript("OnClick", function(self, arg)
				--Open delete confirmation box to delete table id (k), but display it as matching log number (usedLineFrameCount).
				--NWB:openDeleteConfirmFrame(k, self.count);
			--end)
			_G[usedLineFrameCount .. "NWBBuffsLine"].id = usedLineFrameCount;
		end
	end
end

function NWB:hideAllLineFrames()
	for i = 1, lineFrameCount do
		if (_G[i .. "NWBBuffsLine"]) then
			_G[i .. "NWBBuffsLine"]:Hide();
		end
	end
end

function NWB:recalcBuffsLineFramesTooltip(obj)
	local data = obj.tooltipData;
	local type = obj.tooltipType;
	if (data and type) then
		if (type == "realm") then
			local text = "";
			local total = 0;
			if (NWB.db.global[data]) then
				for realm, faction in pairs(NWB.db.global[data]) do
					for k, v in pairs(faction.myChars) do
						if (v.gold) then
							local _, _, _, classColor = GetClassColor(v.englishClass);
							if (not classColor) then
								classColor = "ff696969";
							end
							total = total + v.gold;
							local line = "\n|c" .. classColor .. k .. "|r";
							obj.tooltip.fsCalc:SetText(line);
							--Trim string if multiple columns.
							while obj.tooltip.fsCalc:GetWidth() > 80 do
								line = string.sub(line, 1, -2);
								obj.tooltip.fsCalc:SetText(line);
							end
							obj.tooltip.fsCalc:SetText(line);
							while obj.tooltip.fsCalc:GetWidth() < 90 do
								line = line .. " ";
								obj.tooltip.fsCalc:SetText(line);
							end
							text = text .. line .. " " .. GetCoinTextureString(v.gold, 10);
							--text = text .. "\n|c" .. classColor .. k .. "|r " .. GetCoinTextureString(v.gold, 10);
						end
					end
				end
			end
			text = "|cFFFFAE42" .. L["realmGold"] .. " |cff00ff00[" .. data .. "]|r" .. text;
			local line = "\n\n|cFFFFAE42" .. L["total"] .. ": |r";
			obj.tooltip.fsCalc:SetText(line);
			while obj.tooltip.fsCalc:GetWidth() < 90 do
				line = line .. " ";
				obj.tooltip.fsCalc:SetText(line);
			end
			line = line .. " " .. GetCoinTextureString(total, 10);
			obj.tooltip.fs:SetText(text .. line);
		elseif (type == "char") then
			if (data.playerName) then
				local color1, color2 = "|cFFFFAE42", "|cFF9CD6DE";
				local player = data.playerName;
				local _, _, _, classColorHex = GetClassColor(data.englishClass);
				if (not classColorHex) then
					classColorHex = "ff696969";
				end
				local online;
				if (player == UnitName("player")) then
					online = true;
				end
				local timeOffline;
				if (data.time) then
					timeOffline = GetServerTime() - data.time;
				end
				local text = "";
				--Some of the data exists checks are here to be compatible with older versions that didn't record some data.
				if (data.realm) then
					text = "|c" .. classColorHex .. player .. "|r |cff00ff00[" .. data.realm .. "]|r";
				else
					text = "|c" .. classColorHex .. player .. "|r";
				end
				local guildString;
				if (data.guild) then
					if (data.guild == "No guild") then
						guildString = L["No guild"];
					else
						guildString = data.guild;
					end
				else
					guildString = "unknown";
				end
				text = text .. "\n" .. color1 .. L["guild"] .. ":|r " .. color2 .. guildString .. "|r";
				text = text .. "\n" .. color1 .. L["level"] .. ":|r " .. color2 .. data.level .. "|r";
				if (data.freeBagSlots and data.totalBagSlots) then
					local displayFreeSlots = color2 .. data.freeBagSlots .. "|r";
					if (data.freeBagSlots < (data.totalBagSlots * 0.10)) then
						--Display in red when less than 10% of bag space left.
						displayFreeSlots = "|cffff0000" .. data.freeBagSlots .. "|r";
					end
					text = text .. "\n" .. color1 .. L["bagSlots"] .. ":|r " .. displayFreeSlots .. "|r" .. color1 .. "\|r"
							.. color2 .. data.totalBagSlots .. "|r";
				end
				if (data.gold) then
					text = text .. "\n" .. color1 .. L["Gold"] .. ":|r " .. color2 .. GetCoinTextureString(data.gold, 10) .. "|r";
				end
				local durabilityAverage = data.durabilityAverage or 100;
				local displayDurability;
				if (durabilityAverage < 10) then
					displayDurability = "|cffff0000" .. NWB:round(durabilityAverage) .. "%|r";
				elseif (durabilityAverage < 30) then
					displayDurability = "|cffffa500" .. NWB:round(durabilityAverage) .. "%|r";
				else
					displayDurability = color2 .. NWB:round(durabilityAverage) .. "%|r";
				end
				text = text .. "\n" .. color1 .. L["durability"] .. ": " .. displayDurability;
				if (data.chronoCooldown and data.chronoCooldown > GetServerTime()) then
					text = text .. "\n" .. color1 .. L["Chronoboon CD"] .. ":|r " .. color2 .. NWB:getTimeString(data.chronoCooldown - GetServerTime(),
							true, NWB.db.global.timeStringType, nil, true) .. ".|r";
				else
					text = text .. "\n" .. color1 .. L["Chronoboon CD"] .. ":|r " .. color2 .. L["Ready"] .. ".|r";
				end
				if (data.pvpFlag) then
					local texture = "";
					if (data.faction and data.faction == "Horde") then
						texture = "|TInterface\\AddOns\\NovaWorldBuffs\\Media\\hordepvp:13:13:-1:0|t";
					else
						texture = "|TInterface\\AddOns\\NovaWorldBuffs\\Media\\alliancepvp:13:13:-1:0|t";
					end
					text = text .. "\n" .. texture .. " ".. color1 .. L["PvP enabled"] .. "|r";
				end
				local itemString = "\n\n|cFFFFFF00" .. L["items"] .. "|r";
				itemString = itemString .. "\n  |TInterface\\Icons\\inv_misc_enggizmos_21:12:12:0:0|t|c"
						.. classColorHex .. " " .. L["Chronoboon"] .. ":|r " .. color2 .. (data.chronoCount or 0) .. "|r";
				if (data.englishClass == "PRIEST" or data.englishClass == "MAGE" or data.englishClass == "DRUID"
						or data.englishClass == "WARLOCK" or data.englishClass == "SHAMAN" or data.englishClass == "PALADIN"
								or data.englishClass == "HUNTER") then
					local foundItems;
					--local itemString = "\n\n|cFFFFFF00" .. L["items"] .. "|r";
					if (data.englishClass == "HUNTER" and data.ammo) then
						local ammoTypeString = "";
						if (data.ammoType) then
							local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(data.ammoType);
			    			if (itemName) then
			    				local ammoTexture = "|T" .. itemTexture .. ":12:12:0:0|t";
								ammoTypeString = " (" .. itemName .. " " .. ammoTexture .. ")";
							end
						end
						itemString = itemString .. "\n  |c" .. classColorHex .. L["ammunition"] .. ":|r "
								.. color2 .. (data.ammo or 0) .. ammoTypeString .. "|r";
						foundItems = true;
					end
					if (NWB["trackItems" .. data.englishClass]) then
						for k, v in ipairs(NWB["trackItems" .. data.englishClass]) do
							if (not v.minLvl or v.minLvl < data.level) then
								local texture = "";
								if (v.texture) then
									texture = "|T" .. v.texture .. ":12:12:0:0|t ";
								end
								local itemName = v.name;
								--Try and get localization for the item name.
								local itemName = GetItemInfo(v.id);
								if (not itemName) then
									itemName = v.name;
								end
								itemString = itemString .. "\n  " .. texture .. "|c" .. classColorHex .. itemName .. ":|r "
										.. color2 .. (data[tostring(v.id)] or 0) .. "|r";
								foundItems = true;
							end
						end
					end
					--if (foundItems) then
					--	text = text .. itemString;
					--end
				end
				text = text .. itemString;
				local attunements = "\n\n|cFFFFFF00" .. L["attunements"] .. "|r";
				local foundAttune;
				if (data.mcAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Molten Core|r";
					foundAttune = true;
				end
				if (data.onyAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Onyxia's Lair|r";
					foundAttune = true;
				end
				if (data.bwlAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Blackwing Lair|r";
					foundAttune = true;
				end
				if (data.naxxAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Naxxramas|r";
					foundAttune = true;
				end
				if (data.karaAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Karazhan|r";
					foundAttune = true;
				end
				if (data.shatteredHallsAttune) then
					attunements = attunements .. "\n  " .. color1 .. "The Shattered Halls|r"; --Key.
					foundAttune = true;
				end
				if (data.serpentshrineAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Serpentshrine Cavern|r";
					foundAttune = true;
				end
				if (data.arcatrazAttune) then
					attunements = attunements .. "\n  " .. color1 .. "The Arcatraz|r"; --Key.
					foundAttune = true;
				end
				if (data.blackMorassAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Black Morass|r";
					foundAttune = true;
				end
				if (data.hyjalAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Battle of Mount Hyjal|r";
					foundAttune = true;
				end
				if (data.blackTempleAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Black Temple|r";
					foundAttune = true;
				end
				if (data.hellfireCitadelAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Hellfire Citadel|r"; --Key.
					foundAttune = true;
				end
				if (data.coilfangAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Coilfang Reservoir|r"; --Key.
					foundAttune = true;
				end
				if (data.shadowLabAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Shadow Labyrinth|r"; --Key.
					foundAttune = true;
				end
				if (data.auchindounAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Auchindoun|r"; --Key.
					foundAttune = true;
				end
				if (data.tempestKeepAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Tempest Keep|r"; --Key
					foundAttune = true;
				end
				if (data.cavernAttune) then
					attunements = attunements .. "\n  " .. color1 .. "Caverns of Time|r"; --Key.
					foundAttune = true;
				end
				if (foundAttune) then
					text = text .. attunements;
				end
				text = text .. "\n\n|cFFFFFF00" .. L["currentRaidLockouts"] .. "|r";
				local foundLockout;
				local lockoutString = "";
				if (data.savedInstances and next(data.savedInstances)) then
					for k, v in pairs(data.savedInstances) do
						if (not tonumber(k)) then
							--Remove any non-numbered entries such as "NOT SAVED" from other addons that were recorded in older versions.
							data.savedInstances[k] = nil;
						end
					end
					for k, v in NWB:pairsByKeys(data.savedInstances) do
						if (v.locked and v.resetTime and v.resetTime > GetServerTime()) then
							local timeString = "(" .. NWB:getTimeString(v.resetTime - GetServerTime(), true, NWB.db.global.timeStringType) .. " " .. L["left"] .. ")";
							lockoutString = lockoutString .. "\n  " .. color1 .. v.name .. "|r " .. color2 .. timeString .. "|r";
							foundLockout = true;
						end
					end
				end
				if (not foundLockout) then
					text = text .. "\n  " .. color2 .. L["none"] .. "|r";
				else
					text = text .. lockoutString;
				end
				if (data.playerName ~= UnitName("player") and NWB.isDmfUp and data.lo and data.dmfCooldown and data.dmfCooldown > 0) then
					text = text .. "\n\n|cFFFFFF00" .. L["dmfOfflineStatusTooltip"] .. "|r";
					local resting = "";
					if (data.resting) then
						resting = " " .. L["Rested"] .. "";
					else
						resting = " " .. L["Not Rested"] .. "";
					end
					text = text .. "\n  |cFFA0A0A0(" .. L["Offline"] .. " for " .. NWB:getTimeString(GetServerTime() - data.lo, true, "short") .. resting .. ")|r";
				end
				obj.tooltip.fs:SetText(text);
			else
				obj.tooltip.fs:SetText("|CffDEDE42No data found for this character yet.\nMaybe not logged on since addon install?|r");
			end
		else
			obj.tooltip.fs:SetText("|CffDEDE42No data found for this tooltip.|r");
		end
	else
		obj.tooltip.fs:SetText("");
	end
	obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
	obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
end

--Reset data if name changes, server xfer etc.
--This only resets current "has buff" data and not overall buff count stats.
function NWB:resetBuffData()
	for k, v in NWB:pairsByKeys(NWB.db.global) do --Iterate realms.
		local msg = "";
		if (type(v) == "table" and k ~= "minimapIcon" and k ~= "versions") then --The only tables in db.global are realm names.
			local realm = k;
			for k, v in NWB:pairsByKeys(v) do --Iterate factions.
				local f = k;
				if (v.myChars) then
					for k, v in NWB:pairsByKeys(v.myChars) do --Iterate characters.
						NWB.db.global[realm][f].myChars[k].buffs = {};
						NWB.db.global[realm][f].myChars[k].storedBuffs = {};
					end
				end
			end
		end
	end
	NWB:print(L["trimDataMsg1"]);
	C_Timer.After(3, function()
		NWB:syncBuffsWithCurrentDuration();
	end)
end

--Delete full data for characters under a certain level.
--This removes the entire character and all buff stats data from this addon.
--For removing old alts from other servers and lvl 1 deleted chars etc.
function NWB:removeCharsBelowLevel()
	local level = NWB.db.global.trimDataBelowLevel;
	NWB:print(string.format(L["trimDataMsg2"], level));
	local found;
	local count = 0;
	for realm, v in NWB:pairsByKeys(NWB.db.global) do --Iterate realms.
		local msg = "";
		if (type(v) == "table" and realm ~= "minimapIcon" and realm ~= "versions") then --The only tables in db.global are realm names.
			for k, v in NWB:pairsByKeys(v) do --Iterate factions.
				local f = k;
				if (v.myChars) then
					for k, v in NWB:pairsByKeys(v.myChars) do --Iterate characters.
						if (v.level and v.level <= level) then
							NWB.db.global[realm][f].myChars[k] = nil;
							count = count + 1;
							print(NWB.chatColor .. string.format(L["trimDataMsg3"], k .. "-" .. realm));
							found = true;
						end
					end
				end
			end
		end
	end
	if (not found) then
		NWB:print(L["trimDataMsg4"]);
	else
		NWB:print(string.format(L["trimDataMsg5"], count));
	end
	C_Timer.After(3, function()
		NWB:syncBuffsWithCurrentDuration();
	end)
end

function NWB:removeSingleChar(name)
	if (not name or type(name) ~= "string" or name == "") then
		NWB:print(L["trimDataMsg6"]);
		return;
	end
	if (not string.match(name, "-")) then
		NWB:print(string.format(L["trimDataMsg7"], name));
		return;
	end
	--Normalize the realm name, removing spaces and '.
	--local nomalizedName = string.gsub(name, " ", "");
	--nomalizedName = string.gsub(nomalizedName, "'", "");
	local found;
	for realm, v in NWB:pairsByKeys(NWB.db.global) do --Iterate realms.
		local msg = "";
		if (type(v) == "table" and realm ~= "minimapIcon" and realm ~= "versions") then --The only tables in db.global are realm names.
			for k, v in NWB:pairsByKeys(v) do --Iterate factions.
				local f = k;
				if (v.myChars) then
					for k, v in NWB:pairsByKeys(v.myChars) do --Iterate characters.
						if ((k .. "-" .. realm) == name) then
							NWB.db.global[realm][f].myChars[k] = nil;
							found = true;
						end
					end
				end
			end
		end
	end
	if (not found) then
		NWB:print(string.format(L["trimDataMsg8"], name));
	else
		NWB:print(string.format(L["trimDataMsg9"], name));
	end
	if (name ==  UnitName("player") .. "-" .. GetRealmName()) then
		NWB:buildRealmFactionData();
	end
	C_Timer.After(3, function()
		NWB:syncBuffsWithCurrentDuration();
	end)
end

SLASH_NWBDMFBUFFSCMD1, SLASH_NWBDMFBUFFSCMD2 = '/buff', '/buffs';
function SlashCmdList.NWBDMFBUFFSCMD(msg, editBox)
	NWB:openBuffListFrame();
end