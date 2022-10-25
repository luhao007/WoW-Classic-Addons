-----------------------------
---NovaRaidCompanion frames--
-----------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

NRC.framePool = {};

--function NRC:moveAllFrames()

--end

function NRC:createListFrame(name, width, height, x, y, desc, isSubFrame, label)
	if (_G[name]) then
		return;
	end
	--The main frame that each line frame will attach to.
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame.defaultX = x;
	frame.defaultY = y;
	frame.desc = desc or "";
	frame.isSubFrame = isSubFrame;
	--frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	--tinsert(UISpecialFrames, name);
	frame:SetSize(width, height);
	frame:SetPoint("CENTER", UIParent, x or 0, y or 0);
	--frame:SetBackdrop({
	--	bgFile = "Interface\\Buttons\\WHITE8x8",
	--	insets = {top = 0, left = 0, bottom = 0, right = 0},
	--	edgeFile = [[Interface/Buttons/WHITE8X8]], 
	--	edgeSize = 1,
	--});
	--frame:Show();
	--The overlay frame to used for any visuals like mouseovers etc.
	--This is used so it can be hidden/shown without hiding the child frames.
	--[[frame.overlay = CreateFrame("Frame", name .. "Overlay", frame, "BackdropTemplate");
	frame.overlay:SetAllPoints();
	frame.overlay:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},]]
		--edgeFile = [[Interface/Buttons/WHITE8X8]], 
		--[[edgeSize = 1,
	});
	frame.overlay:SetBackdropColor(0, 0, 0, .3);
	frame.overlay:SetBackdropBorderColor(1, 1, 1, 0.5);
	frame.overlay:SetScript("OnEnter", function(self)
		frame:Show();
	end)
	frame.overlay:SetScript("OnLeave", function(self)
		frame:Hide();
	end)
	frame.overlay:Hide();]]
	frame.fs = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fs:SetPoint("CENTER", 0, 0);
	frame.fs:SetFont(NRC.regionFont, frame:GetHeight() - 8);
	frame.tooltip = CreateFrame("Frame", frame:GetName() .. "Tooltip", frame, "TooltipBorderedFrameTemplate");
	frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
	frame.tooltip:SetFrameStrata("TOOLTIP");
	frame.tooltip:SetFrameLevel(999);
	frame.tooltip.fs = frame.tooltip:CreateFontString(frame:GetName() .. "NRCTooltipFS", "ARTWORK");
	frame.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.tooltip.fs:SetFont(NRC.regionFont, 11);
	frame.tooltip.fs:SetJustifyH("LEFT");
	frame.showTooltip = function()
		--Use a function to show tooltip so we can disable showing tooltip if frame isn't being dragged for first install.
		frame.tooltip:Show();
	end
	frame:SetScript("OnEnter", function(self)
		--frame:SetBackdropColor(0, 0, 0, 0.5);
		--frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		if (not frame.disableMouse) then
			--frame.displayTab:Show();
			--frame.displayTab.top:Show();
		end
		local point = frame:GetPoint();
		frame.tooltip:ClearAllPoints();
		if (point == "TOPRIGHT" or point == "TOPLEFT") then
			frame.tooltip:SetPoint("TOP", frame, "BOTTOM", 0, -2);
		else
			frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
		end
		if (frame.tooltip.fs:GetText() and frame.tooltip.fs:GetText() ~= "") then
			frame.showTooltip();
		end
		if (not frame.firstRun) then
			frame.fs:SetText(label or "");
		end
	end)
	frame:SetScript("OnLeave", function(self)
		--if (not frame.firstRun) then
			--frame:SetBackdropColor(0, 0, 0, 0);
			--frame:SetBackdropBorderColor(1, 1, 1, 0);
			--frame.displayTab:Hide();
			--frame.displayTab.top:Hide();
		--end
		--frame.updateTooltip("");
		frame.tooltip:Hide();
		if (not frame.firstRun) then
			frame.fs:SetText("");
		end
	end)
	frame.tooltip:Hide();
	frame.updateTooltip = function(text)
		frame.tooltip.fs:SetText(text);
		frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
		frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
	end
	frame.reset = function(text)
		frame:SetBackdropColor(0, 0, 0, 0.5);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		frame.displayTab.fs:SetText(L["Hold Shift To Drag"]);
		frame.updateTooltip("|cFFFFFF00" .. frame.desc);
		frame.showTooltip = function()
			frame.tooltip:Show();
		end
		--If child frames are showing there's no need for the drag text.
		local frames = {frame:GetChildren()};
		local found;
		for k, v in ipairs(frames) do
			if (v:IsShown()) then
				frame.fs:SetText("");
				break;
			end
		end
	end
	frame.OnMouseUpFunc = function(self, button)
		if (button == "LeftButton" and frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
			if (frame.firstRun) then
				NRC:print("Type /nrc config to lock frames once you're done dragging them.");
			end
			frame.firstRun = nil
			frame.hasBeenReset = nil
			frame.showTooltip = function() end;
			frame.tooltip.fs:SetText("");
			frame.fs:SetText("");
			frame.tooltip:Hide();
			--frame.displayTab:Hide();
		end
	end
	frame.OnMouseDownFunc = function(self, button, shift)
		if (button == "LeftButton" and not frame.isMoving) then
			if (shift or not frame.locked) then
				frame:StartMoving();
				frame.isMoving = true;
			end
		end
	end
	frame.OnHideFunc = function(self, button)
		if (frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
		end
	end
	frame:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame:SetScript("OnHide", function(self)
		frame.OnHideFunc(self);
	end)
	frame.lineFrames = {};
	frame.lineFrameHeight = height;
	frame.lineFrameWidth = width;
	frame.lineFrameFont = "NRC Default";
	frame.lineFrameFontNumbers = "NRC Numbers";
	frame.lineFrameFontSize = 12;
	frame.lineFrameFontOutline = "NONE";
	frame.getLineFrame = function(parent, id)
		for k, v in ipairs(frame.lineFrames) do
			--[[if (not v.enabled) then
				v.enabled = true;
				return v;
			end]]
			if (v.count == id) then
				return v;
			end
		end
		local count = #frame.lineFrames + 1;
		local lineFrame = CreateFrame("Button", parent:GetName().. "LineFrame" .. count, parent, "BackdropTemplate");
		lineFrame:RegisterForClicks("LeftButtonDown", "RightButtonDown");
		lineFrame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", lineFrame, "BackdropTemplate");
		local borderSpacing = 2;
		lineFrame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		lineFrame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		lineFrame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		lineFrame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);
		lineFrame.borderFrame:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tileEdge = true,
			edgeSize = 16,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		--lineFrame.borderFrame:Hide();
		lineFrame.count = count;
		--lineFrame:SetToplevel(true);
		lineFrame:SetMovable(true);
		lineFrame:EnableMouse(true);
		lineFrame:SetSize(10, 10);
		lineFrame:SetPoint("CENTER", lineFrame:GetParent(), x or 0, y or 0);
		lineFrame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
			--edgeFile = [[Interface/Buttons/WHITE8X8]], 
			--edgeSize = 1,
		});
		lineFrame:SetBackdropColor(0, 0, 0, 0.5);
		--lineFrame:SetBackdropBorderColor(1, 1, 1, 0.2);
		lineFrame.fs = lineFrame:CreateFontString(parent:GetName().. "LineFrameFS", "ARTWORK");
		lineFrame.fs:SetPoint("LEFT", parent.lineFrameHeight + 2, 0);
		--lineFrame.fs:SetFont(NRC.regionFont, parent.lineFrameHeight - 8);
		lineFrame.fs:SetJustifyH("LEFT");
		lineFrame.fs2 = lineFrame:CreateFontString(parent:GetName().. "LineFrameFS2", "ARTWORK");
		lineFrame.fs2:SetPoint("RIGHT", -2, 0);
		--lineFrame.fs2:SetFont(NRC.regionFont, parent.lineFrameHeight - 9);
		--lineFrame.fs2:SetFont("Fonts\\FRIZQT__.TTF", parent.lineFrameHeight - 7);
		--lineFrame.fs2:SetFont("Fonts\\ARIALN.TTF", parent.lineFrameHeight - 7);
		--lineFrame.fs2:SetFontObject(SystemFont_OutlineThick_Huge2);
		lineFrame.fs2:SetJustifyH("RIGHT");
		lineFrame.fs3 = lineFrame:CreateFontString(parent:GetName().. "LineFrameFS3", "ARTWORK");
		lineFrame.fs3:SetPoint("RIGHT", 35, 0);
		--lineFrame.fs3:SetFont(NRC.regionFont, parent.lineFrameHeight - 9);
		lineFrame.fs3:SetJustifyH("LEFT");
		lineFrame.fs4 = lineFrame:CreateFontString(parent:GetName().. "LineFrameFS4", "ARTWORK");
		--lineFrame.fs4:SetPoint("RIGHT", -37, 0);
		lineFrame.fs4:SetPoint("RIGHT", lineFrame.fs2, "LEFT",  -5, 0);
		--lineFrame.fs4:SetFont(NRC.regionFont, parent.lineFrameHeight - 7);
		lineFrame.fs4:SetJustifyH("RIGHT");
		
		--[[lineFrame.fs:SetFont(NRC.LSM:Fetch("font", NRC.db.global.raidCooldownsFont), parent.lineFrameHeight - 8);
		lineFrame.fs2:SetFont(NRC.LSM:Fetch("font", NRC.db.global.raidCooldownsFont), parent.lineFrameHeight - 9);
		lineFrame.fs3:SetFont(NRC.LSM:Fetch("font", NRC.db.global.raidCooldownsFont), parent.lineFrameHeight - 9);
		lineFrame.fs4:SetFont(NRC.LSM:Fetch("font", NRC.db.global.raidCooldownsFontNumbers), parent.lineFrameHeight - 7);]]
		
		lineFrame.fs:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), parent.lineFrameFontSize, parent.lineFrameFontOutline);
		lineFrame.fs2:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), parent.lineFrameFontSize - 1, parent.lineFrameFontOutline);
		lineFrame.fs3:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), parent.lineFrameFontSize - 1, parent.lineFrameFontOutline);
		lineFrame.fs4:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFontNumbers), parent.lineFrameFontSize + 1, parent.lineFrameFontOutline);
		
		lineFrame.texture = lineFrame:CreateTexture(nil, "MEDIUM");
		lineFrame.texture:SetTexture("error");
		lineFrame.texture:SetPoint("LEFT", 1, 0);
		lineFrame.texture:SetSize(parent.lineFrameHeight - 2, parent.lineFrameHeight - 2);
		lineFrame.tooltip = CreateFrame("Frame", parent:GetName() .. "Tooltip", frame, "TooltipBorderedFrameTemplate");
		lineFrame.tooltip:SetPoint("CENTER", lineFrame, "CENTER", 0, 0);
		lineFrame.tooltip:SetFrameStrata("TOOLTIP");
		lineFrame.tooltip:SetFrameLevel(9);
		lineFrame.tooltip:SetBackdropColor(0, 0, 0, 1);
		lineFrame.tooltip.fs = lineFrame.tooltip:CreateFontString(parent:GetName() .. "NRCTooltipFS", "ARTWORK");
		lineFrame.tooltip.fs:SetPoint("CENTER", 0, 0);
		lineFrame.tooltip.fs:SetFont(NRC.regionFont, 12);
		lineFrame.tooltip.fs:SetJustifyH("LEFT");
		lineFrame.tooltip:SetScript("OnUpdate", function(self)
			--Keep our custom tooltip at the mouse when it moves.
			local scale, x, y = lineFrame.tooltip:GetEffectiveScale(), GetCursorPosition();
			--lineFrame.tooltip:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 2, y / scale);
			--ClearAllPoints() here to try fix an error with resting frames to default pos, should be cleared up later.
			lineFrame.tooltip:ClearAllPoints();
			lineFrame.tooltip:SetPoint("BOTTOM", nil, "BOTTOMLEFT", (x / scale) - 2, (y / scale) + 5);
		end)
		lineFrame.tooltip:Hide();
		lineFrame.updateTooltip = function(text)
			lineFrame.tooltip.fs:SetText(text);
			lineFrame.tooltip:SetWidth(lineFrame.tooltip.fs:GetStringWidth() + 18);
			lineFrame.tooltip:SetHeight(lineFrame.tooltip.fs:GetStringHeight() + 12);
		end
		lineFrame:Show();
		lineFrame:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and IsShiftKeyDown() and not self:GetParent().isMoving) then
				--Still allow shift movement of this frame if locked.
				frame.OnMouseDownFunc(frame, button, true);
			end
		end)
		lineFrame:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and self:GetParent().isMoving) then
				frame.OnMouseUpFunc(frame, button);
			end
		end)
		lineFrame:SetScript("OnHide", function(self)
			if (self:GetParent().isMoving) then
				frame.OnHideFunc(frame);
			end
		end)
		lineFrame:SetScript("OnEnter", function(self)
			lineFrame.tooltip:Show();
		end)
		--The below 2 handlers are pretty messy but they make the frames act like they need to.
		lineFrame:SetScript("OnLeave", function(self)
			if (frame.isSubFrame) then
				--If it's a tooltip style list check we're not hovering over any other frames in the list before hiding.
				--local frames = {frame:GetChildren()};
				local frames = frame.lineFrames;
				local found;
				for k, v in ipairs(frames) do
					if (MouseIsOver(v)) then
						found = true;
					end
				end
				if (not found) then
					frame:Hide();
				end
			end
			lineFrame.tooltip:Hide();
			if (lineFrame.subFrame) then
				lineFrame.subFrame:Hide();
			end
		end)
		lineFrame.tooltip:SetScript("OnHide", function(self)
			if (frame.isSubFrame) then
				--If it's a tooltip style list check we're not hovering over any other frames in the list before hiding.
				local frames = frame.lineFrames;
				local found;
				for k, v in ipairs(frames) do
					--If our mouse isn't over an actual lineframe and not a hidden tooltip.
					--The tooltip may be bigger than the frame and when our mouse leaves it won't close.
					--This fixes that by checking if mouse is over the right frames.
					if (MouseIsOver(v) and not strfind(v:GetName(), "Tooltip")) then
						found = true;
					end
				end
				if (not found) then
					frame:Hide();
				end
			end
		end)
		lineFrame.enabled = true;
		tinsert(frame.lineFrames, lineFrame);
		--If we add a update func for size/look etc then update if we create a new frame.
		if (frame.updateLayoutFunc) then
			NRC[frame.updateLayoutFunc]();
		end
		return lineFrame;
	end
	frame.growthDirection = 1; --Down, can be changed in options.
	frame.clearAllPoints = function(parent)
		for k, v in ipairs(frame.lineFrames) do
			v:ClearAllPoints();
		end
	end
	frame.sortLineFrames = function(parent)
		local heightOffset = 0;
		local spacing = 0;
		local growDown = (frame.growthDirection == 1);
		local lastFrame;
		for k, v in ipairs(frame.lineFrames) do
			if (v.enabled) then
				v:SetHeight(frame.lineFrameHeight);
				if (growDown) then
					if (k == 1) then
						v:SetPoint("TOPLEFT");
					else
						v:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT");
					end
				else
					if (k == 1) then
						v:SetPoint("BOTTOMLEFT");
					else
						v:SetPoint("BOTTOMLEFT", lastFrame, "TOPLEFT");
					end
				end
				v:SetPoint("RIGHT");
				v:Show();
				lastFrame = v;
				v:SetHeight(frame.lineFrameHeight);
			else
				v:ClearAllPoints();
				v:Hide();
			end
		end
	end
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			frame:sortLineFrames();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	frame.displayTab = CreateFrame("Frame", "$parentDisplayTab", frame, "BackdropTemplate");
	frame.displayTab:SetSize(width, height);
	--frame.displayTab:SetPoint("CENTER", frame, x or 0, y or 0);
	frame.displayTab:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]],
		edgeSize = 1,
	});
	frame.displayTab:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab:SetBackdropBorderColor(1, 1, 1, 1);
	frame.displayTab:SetAllPoints();
	frame.displayTab:SetFrameStrata("MEDIUM");
	frame.displayTab.fs = frame.displayTab:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.fs:SetPoint("CENTER", 0, 0);
	frame.displayTab.fs:SetFont(NRC.regionFont, frame:GetHeight() - 8);
	frame.displayTab:SetMovable(true);
	frame.displayTab:EnableMouse(true);
	frame.displayTab:SetUserPlaced(false);
	frame.displayTab:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame.displayTab:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame.displayTab:SetScript("OnHide", function(self)
		frame.OnHideFunc(self);
	end)
	frame.displayTab.top = CreateFrame("Frame", "$ParentTop", frame, "BackdropTemplate");
	frame.displayTab.top:SetSize(width - 50, 20);
	frame.displayTab.top:SetPoint("BOTTOM", frame.displayTab, "TOP", 0, -4);
	frame.displayTab.top:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom",
		tileEdge = true,
		edgeSize = 16,
		insets = {top = 5, left = 2, bottom = 5, right = 2},
	});
	frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab.top:SetBackdropBorderColor(1, 1, 1, 0.8);
	frame.displayTab.top:SetFrameStrata("HIGH");
	frame.displayTab.top.fs = frame.displayTab.top:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.top.fs:SetPoint("CENTER", 0, 1);
	frame.displayTab.top.fs:SetFont(NRC.regionFont, 12);
	frame.displayTab.top:SetMovable(true);
	frame.displayTab.top:EnableMouse(true);
	frame.displayTab.top:SetUserPlaced(false);
	frame.displayTab.top:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnHide", function(self)
		frame.OnHideFunc(frame);
	end)
	frame.displayTab:Hide();
	frame.displayTab.top:Hide();
	--frame.displayTab.fs:SetJustifyH("LEFT");
	frame.updateDimensions = function(parent)
		local width = frame.lineFrameWidth;
		local height = frame.lineFrameHeight;
		local textureHeight = height;
		if (textureHeight > 22) then
			textureHeight = 22;
		end
		for k, v in ipairs(frame.lineFrames) do
			v:SetWidth(width);
			v:SetHeight(height);
			v.texture:SetSize(textureHeight - 2, textureHeight - 2);
		end
		frame:SetSize(width, height);
		frame.displayTab:SetSize(width, height);
	end
	if (not isSubFrame) then
		NRC.framePool[name] = frame;
	end
	return frame;
end

function NRC:createTextDisplayFrame(name, width, height, x, y, desc)
	if (_G[name]) then
		return;
	end
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame.defaultX = x;
	frame.defaultY = y;
	frame.desc = desc or "";
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetSize(width, height);
	frame:SetPoint("CENTER", UIParent, x or 0, y or 0);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]], 
		edgeSize = 1,
	});
	frame:SetBackdropColor(0, 0, 0, 0.5);
	frame:SetBackdropBorderColor(1, 1, 1, 0.2);
	frame:Show();
	frame.fs = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fs:SetPoint("CENTER", 0, 0);
	frame.fs:SetFont(NRC.regionFont, frame:GetHeight() - 8);
	frame.tooltip = CreateFrame("Frame", frame:GetName() .. "Tooltip", frame, "TooltipBorderedFrameTemplate");
	frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
	frame.tooltip:SetFrameStrata("TOOLTIP");
	frame.tooltip:SetFrameLevel(9);
	frame.tooltip.fs = frame.tooltip:CreateFontString(frame:GetName() .. "NRCTooltipFS", "ARTWORK");
	frame.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.tooltip.fs:SetFont(NRC.regionFont, 11);
	frame.tooltip.fs:SetJustifyH("LEFT");
	frame:SetScript("OnEnter", function(self)
		frame:SetBackdropColor(0, 0, 0, 0.5);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		local point = frame:GetPoint();
		frame.tooltip:ClearAllPoints();
		if (point == "TOPRIGHT" or point == "TOPLEFT") then
			frame.tooltip:SetPoint("TOP", frame, "BOTTOM", 0, -2);
		else
			frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
		end
		if (frame.tooltip.fs:GetText() and frame.tooltip.fs:GetText() ~= "") then
			frame.tooltip:Show();
		end
		if (not frame.hasData) then
			--If no text is set, show what frame is when hovering over.
			frame.fs:SetText("Mob Spawn Time");
		end
	end)
	frame:SetScript("OnLeave", function(self)
		if (not frame.firstRun) then
			frame:SetBackdropColor(0, 0, 0, 0);
			frame:SetBackdropBorderColor(1, 1, 1, 0);
		end
		--frame.tooltip.fs:SetText("");
		frame.tooltip:Hide();
		if (not frame.hasData) then
			frame.fs:SetText("");
		end
	end)
	frame.tooltip:Hide();
	frame.updateTooltip = function(text)
		frame.tooltip.fs:SetText(text);
		frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
		frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
	end
	frame.reset = function(text)
		
	end
	--lineFrame.fs:SetJustifyH("LEFT");
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and IsShiftKeyDown() and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
			frame.firstRun = nil;
			frame.hasBeenReset = nil
			frame.tooltip.fs:SetText("");
			frame.fs:SetText("");
			frame.tooltip:Hide();
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"], 
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	NRC.framePool[name] = frame;
	return frame;
end

--Callback function for timer bars stop, send it to the right module.
local function LibCandyBar_Stop(callback, bar, type, data)
	if (bar.type == "NRCRaidCooldowns") then
		NRC:RaidCooldowns_LibCandyBar_Stop(bar.guid);
	end
end
NRC.candyBar.RegisterCallback(NRC, "LibCandyBar_Stop", LibCandyBar_Stop);

function NRC:styleTimerBar(bar, duration, maxDuration, name, height, guid, test)
	bar:SetColor(0.41176, 0.14901, 0.42745, 1);
	bar:Start(maxDuration);
	bar:SetDuration(duration);
	bar:SetTimeVisibility(false);
	bar.candyBarBar:SetReverseFill(true);
	bar:SetAlpha(0.7);
	bar.nameString = name;
	if (not bar.texture) then
		bar.texture = bar:CreateTexture(nil, "MEDIUM");
		bar.texture:SetTexture("Interface\\Icons\\spell_shadow_soulgem");
		bar.texture:SetPoint("LEFT", bar, "RIGHT", 0, 0);
		bar.texture:SetSize(height - 2, height - 2);
	end

	bar.candyBarLabel:SetJustifyH("MIDDLE");
	--Custom timer text so we can update it at the same time as the rest of the raid cooldown bars
	--And change the format a little.
	if (not bar.customTimer) then
		bar.customTimer = bar:CreateFontString(nil, "HIGH", GameFontHighlightSmallOutline);
		bar.customTimer:SetFont(GameFontHighlightSmallOutline:GetFont());
		bar.customTimer:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, 0.3)
		bar.customTimer:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 0.3);
		bar.customTimer:SetTextColor(1, 1, 1, 1);
		bar.customTimer:SetJustifyH("LEFT");
		bar.customTimer:SetJustifyV("MIDDLE");
		bar.customTimer:SetAlpha(0.7);
	end
	if (not bar.tooltip) then
		bar.tooltip = CreateFrame("Frame", guid .. "SSNRCTooltip", bar, "TooltipBorderedFrameTemplate");
		bar.tooltip:SetPoint("LEFT", bar.texture, "RIGHT", 0, 0);
		bar.tooltip:SetFrameStrata("TOOLTIP");
		bar.tooltip:SetFrameLevel(120);
		bar.tooltip.fs = bar.tooltip:CreateFontString(guid .. "SSNRCTooltipFS", "ARTWORK");
		bar.tooltip.fs:SetPoint("CENTER", 0, 1);
		bar.tooltip.fs:SetFont(NRC.regionFont, 12);
		bar.tooltip:SetIgnoreParentAlpha(true);
		bar.tooltip:SetAlpha(0.95);
		bar.tooltip:SetClampedToScreen(true);
	end
	bar:SetScript("OnEnter", function(self)
		if (self.source) and (self.tooltip) then
			self.tooltip.fs:SetText("|cFF9CD6DE" .. L["Cast by"] .. " |cFF8788EE" .. self.source .. "|r");
			self.tooltip:SetWidth(self.tooltip.fs:GetStringWidth() + 16);
			self.tooltip:SetHeight(self.tooltip.fs:GetStringHeight() + 10);
			self.tooltip:Show();
		end
	end)
	if (bar.tooltip) then
		bar:SetScript("OnLeave", function(self)
			--Someone got an error stating the tooltip doesn't exist even though we check it above before adding this handler.
			--Maybe another addon sharing the lib uses a tooltip also and removes it or something else.
			--Either way I've added another check at actual run time.
			if (self.tooltip) then
				self.tooltip:Hide();
			end
		end)
	end
	--Put the bar texture behind the custom text.
	bar.candyBarBar:SetFrameLevel(99);
	bar.type = "NRCRaidCooldowns";
	bar.guid = guid;

	bar.candyBarLabel:ClearAllPoints();
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 25, 0.3);
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0.3);

	if (test) then
		bar:SetColor(0.41176, 0.14901, 0.42745, 1);
		bar:Start(maxDuration);
		bar:SetDuration(duration);
		bar:SetTimeVisibility(false);
		bar.candyBarBar:SetReverseFill(true);
		bar:SetAlpha(0.7);
		bar.nameString = name;
		if (not bar.texture) then
			bar.texture = bar:CreateTexture(nil, "MEDIUM");
			bar.texture:SetTexture("Interface\\Icons\\spell_shadow_soulgem");
			bar.texture:SetPoint("LEFT", bar, "RIGHT", 0, 0);
			bar.texture:SetSize(height - 2, height - 2);
		end
		
		bar.candyBarLabel:SetJustifyH("MIDDLE");
		--Custom timer text so we can update it at the same time as the rest of the raid cooldown bars
		--And change the format a little.
		if (not bar.customTimer) then
			bar.customTimer = bar:CreateFontString(nil, "HIGH", GameFontHighlightSmallOutline);
			bar.customTimer:SetFont(GameFontHighlightSmallOutline:GetFont());
			bar.customTimer:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, 0.3)
			bar.customTimer:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 0.3);
			bar.customTimer:SetTextColor(1, 1, 1, 1);
			bar.customTimer:SetJustifyH("LEFT");
			bar.customTimer:SetJustifyV("MIDDLE");
			bar.customTimer:SetAlpha(0.7);
		end
		if (not bar.tooltip) then
			bar.tooltip = CreateFrame("Frame", guid .. "SSNRCTooltip", bar, "TooltipBorderedFrameTemplate");
			bar.tooltip:SetPoint("LEFT", bar.texture, "RIGHT", 0, 0);
			bar.tooltip:SetFrameStrata("TOOLTIP");
			bar.tooltip:SetFrameLevel(120);
			bar.tooltip.fs = bar.tooltip:CreateFontString(guid .. "SSNRCTooltipFS", "ARTWORK");
			bar.tooltip.fs:SetPoint("CENTER", 0, 1);
			bar.tooltip.fs:SetFont(NRC.LSM:Fetch("font", NRC.db.global.raidManaFont), 12);
			--bar.tooltip.fs:SetJustifyH("LEFT");
			bar.tooltip:SetIgnoreParentAlpha(true);
			bar.tooltip:SetAlpha(0.95);
		end
		bar:SetScript("OnEnter", function(self)
			if (self.source) then
				bar.tooltip.fs:SetText("|cFF9CD6DE" .. L["Cast by"] .. " |cFF8788EE" .. self.source .. "|r");
				bar.tooltip:SetWidth(bar.tooltip.fs:GetStringWidth() + 16);
				bar.tooltip:SetHeight(bar.tooltip.fs:GetStringHeight() + 10);
				bar.tooltip:Show();
			end
		end)
		if (bar.tooltip) then
			bar:SetScript("OnLeave", function(self)
				if (bar) then
					bar.tooltip:Hide();
				end
			end)
		end
		--Put the bar texture behind the custom text.
		bar.candyBarBar:SetFrameLevel(99);
		bar.type = "NRCRaidCooldowns";
		bar.guid = guid;
		
		bar.candyBarLabel:ClearAllPoints();
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 25, 0.3);
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0.3);	
	end
end

function NRC:cleanTimerBar(bar)
	--Reset anything we've changed back to lib default.
	if (bar.texture) then
		bar.texture:Hide();
	end
	if (bar.customTimer) then
		bar.customTimer:Hide();
	end
	if (bar.tooltip) then
		bar.tooltip:Hide();
	end
	bar:SetScript("OnEnter", nil)
	bar:SetScript("OnLeave", nil)
	bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0);
	bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0);
	bar.candyBarBar:SetReverseFill(false);
end

function NRC:createTimerBar(width, height, duration, label)
	local bar = NRC.candyBar:New("Interface\\RaidFrame\\Raid-Bar-Hp-Fill", width, height);
	bar:SetLabel(label);
	bar:SetDuration(duration);
	return bar;
end

function NRC:createCooldownFrame(name, width, height, x, y, desc)
	local frame = CreateFrame("Cooldown", name, UIParent, "CooldownFrameTemplate");
end

function NRC:startCooldownFrame()

end

--If borderSpacing is specified it's because we want to add a border.
--So we create another frame slight bigger than the main frame to sit the border on.
--This saves adjusting all the grid lines etc using insets.
function NRC:createGridFrame(name, width, height, x, y, borderSpacing)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	if (borderSpacing) then
		frame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", frame, "BackdropTemplate");
		frame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		frame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		frame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		frame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);
	end
	--frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetToplevel(true);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	frame:SetFrameLevel(10);
	frame:SetPoint("TOP", UIParent, "CENTER", x, y);
	--frame:SetPoint("CENTER", UIParent, x, y);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]], 
		edgeSize = 1,
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	frame:SetBackdropBorderColor(1, 1, 1, 0.2);
	frame.descFrame = CreateFrame("Frame", name .. "Desc", frame, "BackdropTemplate");
	frame.descFrame:SetSize(width, 25);
	frame.descFrame:SetPoint("TOP", frame, "BOTTOM", 0, 0);
	frame.descFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]], 
		edgeSize = 2,
	});
	frame.descFrame:SetBackdropColor(0, 0, 0, 0.9);
	frame.descFrame:SetBackdropBorderColor(1, 1, 1, 0.2);
	frame.descFrame.fs = frame.descFrame:CreateFontString("$parentFS", "MEDIUM");
	--frame.descFrame.fs:SetJustifyH("LEFT");
	--frame.descFrame.fs:SetFont("Fonts\\FRIZQT__.TTF", 13);
	frame.descFrame.fs:SetFontObject(SystemFont_Outline);
	frame.descFrame.fs:SetPoint("CENTER", 0, 0);
	frame.descFrame:Hide();
	--Click button to be used for whatever, set onclick in the frame data func.
	frame.button = CreateFrame("Button", name .. "Button", frame, "NRC_EJButtonTemplate");
	frame.button:SetFrameLevel(15);
	frame.button:Hide();
	--Top right X close button.
	frame.closeButton = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.closeButton:SetPoint("TOPRIGHT", 3.45, 3.2);
	frame.closeButton:SetWidth(20);
	frame.closeButton:SetHeight(20);
	frame.closeButton:SetFrameLevel(15);
	frame.closeButton:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and IsShiftKeyDown() and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	frame.subFrameFont = "NRC Default";
	frame.subFrameFontSize = 12;
	frame.subFrameFontOutline = "NONE";
	frame.subFrames = {};
	frame.updateGridData = function(data, updateLayout)
		--Only update the frame layout if the data size has changed (players join/leave group etc).
		if (updateLayout) then
			local width, height = 0, 0;
			local lastColumn, lastRow;
			if (data.columns and next(data.columns)) then
				frame.hideAllColumns();
				for k, v in ipairs(data.columns) do
					local t = _G[frame:GetName() .. "GridV" .. k] or frame:CreateTexture(frame:GetName() .. "GridV" .. k, "OVERLAY");
					lastColumn = t;
					if (k == 1) then
						t:SetColorTexture(1, 1, 0, 0.5);
						t:SetWidth(2);
						t:ClearAllPoints();
						t:SetPoint('TOP', frame, 'TOPLEFT', data.firstV, 0);
						t:SetPoint('BOTTOM', frame, 'BOTTOMLEFT', data.firstV, 0);
						t:Show();
						width = width + data.firstV;
					else
						t:SetColorTexture(1, 1, 1, 0.5);
						t:SetWidth(1);
						t:ClearAllPoints();
						t:SetPoint('TOP', frame, 'TOPLEFT', data.firstV + (data.spacingV * (k - 1)), 0);
						t:SetPoint('BOTTOM', frame, 'BOTTOMLEFT', data.firstV + (data.spacingV * (k - 1)), 0);
						t:Show();
						width = width + data.spacingV;
					end
				end
			end
			if (data.rows and next(data.rows)) then
				frame.hideAllRows();
				for k, v in ipairs(data.rows) do
					local t = _G[frame:GetName() .. "GridH" .. k] or frame:CreateTexture(frame:GetName() .. "GridH" .. k, "OVERLAY");
					lastRow = t;
					if (k == 1) then
						t:SetColorTexture(1, 1, 0, 0.5);
						t:SetHeight(2);
						t:ClearAllPoints();
						t:SetPoint('LEFT', frame, 'TOPLEFT', 0, -data.firstH);
						t:SetPoint('RIGHT', frame, 'TOPRIGHT', 0, -data.firstH);
						t:Show();
						height = height + data.firstH;
					else
						t:SetColorTexture(1, 1, 1, 0.5);
						t:SetHeight(1);
						t:ClearAllPoints();
						t:SetPoint('LEFT', frame, 'TOPLEFT', 0, -(data.firstH + (data.spacingH * (k - 1))));
						t:SetPoint('RIGHT', frame, 'TOPRIGHT', 0, -(data.firstH + (data.spacingH * (k - 1))));
						t:Show();
						height = height + data.spacingH;
					end
				end
			elseif (_G[frame:GetName() .. "GridH2"]) then
				--If we leave group there's no rows so hide all but the first header row.
				frame.hideAllRows();
			end
			if (data.adjustHeight) then
				--Adjust height to fit rows.
				if (height < data.firstH) then
					--Show atleast 1 row ir none are set.
					frame:SetHeight(data.firstH);
				else
					frame:SetHeight(height);
				end
				--Hide the last row texture sitting on the border.
				if (lastRow) then
					lastRow:Hide();
				end
			else
				if (lastRow) then
					lastRow:Show();
				end
			end
			for k, v in pairs(frame.subFrames) do
				v:Hide();
			end
			local columnCount, maxColumnCount = 0, 1;
			local rowCount, maxRowCount = 1, 1;
			if (data.columns and next(data.columns)) then
				maxColumnCount = #data.columns;
			end
			if (data.rows and next(data.rows)) then
				maxRowCount = #data.rows;
			end
			--local columnCount, maxColumnCount = 0, #data.columns;
			--local rowCount, maxRowCount = 1, #data.rows;
			frame.maxColumnCount = maxColumnCount;
			frame.maxRowCount = maxRowCount;
			local gridCount = maxColumnCount * maxRowCount;
			for i = 1, gridCount do
				if (columnCount == maxColumnCount) then
					--Reset back to first column.
					columnCount = 1;
					rowCount = rowCount + 1;
				else
					columnCount = columnCount + 1;
				end
				local gridName = string.char(96 + rowCount) .. columnCount;
				--Assign a grid name, a1 a2 a3 etc.
				if (not frame.subFrames[gridName]) then
					--The idea was to have frames cliakble to target to buff, but it taints the main frame so it can't be hidden/shown in combat.
					--frame.subFrames[gridName] = CreateFrame("Button", frame:GetName() .. "_" .. gridName, nil, "BackdropTemplate,SecureActionButtonTemplate");
					frame.subFrames[gridName] = CreateFrame("Button", frame:GetName() .. "_" .. gridName, frame, "BackdropTemplate,InsecureActionButtonTemplate");
					frame.subFrames[gridName]:SetAttribute("type", "macro");
					frame.subFrames[gridName]:SetFrameLevel(11);
					frame.subFrames[gridName]:SetBackdrop({
						bgFile = "Interface\\Buttons\\WHITE8x8",
						insets = {top = 0, left = 0, bottom = 0, right = 0},
						edgeFile = [[Interface/Buttons/WHITE8X8]], 
						edgeSize = 1.1,
					});
					frame.subFrames[gridName]:SetBackdropColor(0, 0, 0, 0);
					frame.subFrames[gridName]:SetBackdropBorderColor(1, 1, 1, 0);
					frame.subFrames[gridName].fs = frame.subFrames[gridName]:CreateFontString(frame:GetName().. "FS", "ARTWORK");
					frame.subFrames[gridName].fs:SetPoint("CENTER", 0, 0);
					frame.subFrames[gridName].fs:SetFont(NRC.LSM:Fetch("font", frame.subFrameFont), frame.subFrameFontSize, frame.subFrameFontOutline);
					frame.subFrames[gridName].fs:SetJustifyH("LEFT");
					frame.subFrames[gridName].texture = frame.subFrames[gridName]:CreateTexture(frame:GetName() .. "Texture_" .. gridName, "MEDIUM");
					frame.subFrames[gridName].texture:SetPoint("CENTER", 0, 0);
					frame.subFrames[gridName].texture2 = frame.subFrames[gridName]:CreateTexture(frame:GetName() .. "Texture2_" .. gridName, "MEDIUM");
					frame.subFrames[gridName].texture2:SetPoint("CENTER", 0, 0);
					frame.subFrames[gridName].texture3 = frame.subFrames[gridName]:CreateTexture(frame:GetName() .. "Texture3_" .. gridName, "MEDIUM");
					frame.subFrames[gridName].texture3:SetPoint("CENTER", 0, 0);
					frame.subFrames[gridName].texture4 = frame.subFrames[gridName]:CreateTexture(frame:GetName() .. "Texture4_" .. gridName, "MEDIUM");
					frame.subFrames[gridName].texture4:SetPoint("CENTER", 0, 0);
					if (columnCount == 1) then
						frame.subFrames[gridName].readyCheckTexture = frame.subFrames[gridName]:CreateTexture(frame:GetName() .. "ReadyCheckTexture_" .. gridName, "MEDIUM");
						frame.subFrames[gridName].readyCheckTexture:SetPoint("LEFT", frame.subFrames[gridName], "LEFT", 2, 0);
						frame.subFrames[gridName].readyCheckTexture:SetSize(16, 16);
					end
					frame.subFrames[gridName].tooltip = CreateFrame("Frame", frame:GetName() .. "Tooltip_" .. gridName, frame, "TooltipBorderedFrameTemplate");
					frame.subFrames[gridName].tooltip:SetPoint("BOTTOM", frame.subFrames[gridName], "TOP", 0, 2);
					frame.subFrames[gridName].tooltip:SetFrameStrata("TOOLTIP");
					frame.subFrames[gridName].tooltip:SetFrameLevel(99);
					--frame.subFrames[gridName].tooltip.NineSlice.Background:SetAlpha(1);
					frame.subFrames[gridName].tooltip:SetBackdropColor(0, 0, 0, 1);
					frame.subFrames[gridName].tooltip.fs = frame.subFrames[gridName].tooltip:CreateFontString(frame:GetName() .. "NRCTooltipFS", "ARTWORK");
					frame.subFrames[gridName].tooltip.fs:SetPoint("CENTER", 0, 0);
					frame.subFrames[gridName].tooltip.fs:SetFont(NRC.regionFont, 12);
					frame.subFrames[gridName].tooltip.fs:SetJustifyH("LEFT");
					frame.subFrames[gridName].updateTooltip = function(text)
						if (not text) then
							--Disable tooltip if no text.
							frame.subFrames[gridName].showTooltip = nil;
						else
							local tooltipFrame = frame.subFrames[gridName].tooltip;
							tooltipFrame.fs:SetText(text);
							tooltipFrame:SetWidth(tooltipFrame.fs:GetStringWidth() + 18);
							tooltipFrame:SetHeight(tooltipFrame.fs:GetStringHeight() + 12);
							frame.subFrames[gridName].showTooltip = true;
						end
					end
					frame.subFrames[gridName].showTooltipFunc = function()
						--Use a function to show tooltip so we can disable showing tooltip if frame isn't being dragged for first install.
						if (frame.subFrames[gridName].showTooltip) then
							frame.subFrames[gridName].tooltip:Show();
						end
					end
					frame.subFrames[gridName]:SetScript("OnEnter", function(self)
						if (not self.red) then
							frame.subFrames[gridName]:SetBackdropColor(0, 1, 0, 0.15);
							frame.subFrames[gridName]:SetBackdropBorderColor(1, 1, 1, 0.5);
						end
						frame.subFrames[gridName].showTooltipFunc();
					end)
					frame.subFrames[gridName]:SetScript("OnLeave", function(self)
						if (not self.red) then
							frame.subFrames[gridName]:SetBackdropColor(0, 0, 0, 0);
							frame.subFrames[gridName]:SetBackdropBorderColor(1, 1, 1, 0);
						end
						frame.subFrames[gridName].tooltip:Hide();
					end)
					frame.subFrames[gridName]:SetScript("OnMouseDown", function(self, button)
						if (button == "LeftButton" and IsShiftKeyDown() and not self:GetParent().isMoving) then
							self:GetParent():StartMoving();
							self:GetParent().isMoving = true;
						end
					end)
					frame.subFrames[gridName]:SetScript("OnMouseUp", function(self, button)
						if (button == "LeftButton" and self:GetParent().isMoving) then
							self:GetParent():StopMovingOrSizing();
							self:GetParent().isMoving = false;
							frame:SetUserPlaced(false);
							NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
									NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
						end
					end)
					frame.subFrames[gridName]:SetScript("OnHide", function(self)
						if (self:GetParent().isMoving) then
							self:GetParent():StopMovingOrSizing();
							self:GetParent().isMoving = false;
						end
					end)
					frame.subFrames[gridName].tooltip:Hide();
				end
				local x = data.firstV + (data.spacingV * (columnCount - 1)) - (data.spacingV / 2);
				local y = -(data.firstH + (data.spacingH * (rowCount - 1)) - (data.spacingH / 2));
				frame.subFrames[gridName]:SetWidth(data.spacingV);
				frame.subFrames[gridName]:SetHeight(data.spacingH);
				if (columnCount == 1) then
					frame.subFrames[gridName]:SetWidth(data.firstV);
					x = data.firstV / 2;
					if (not frame.readyCheckRunnig) then
						frame.subFrames[gridName].fs:SetPoint("LEFT", 5, 0);
					end
				end
				if (rowCount == 1) then
					frame.subFrames[gridName]:SetHeight(data.firstH);
					y = -(data.firstH / 2);
					--Add text or icon to the header row.
					local header = data.columns[columnCount];
					if (header.tex) then
						frame.subFrames[gridName].fs:SetText("");
						frame.subFrames[gridName].texture:SetTexture(header.tex);
						frame.subFrames[gridName].texture:SetSize(30, 24);
						--Some stuff for handling resistance icons.
						if (header.texCoords) then
							frame.subFrames[gridName].texture:SetTexCoord(header.texCoords[1], header.texCoords[2],
									header.texCoords[3], header.texCoords[4]);
						end
					else
						frame.subFrames[gridName].texture:SetTexture();
						frame.subFrames[gridName].fs:SetText(header.name);
					end
				end
				frame.subFrames[gridName]:ClearAllPoints();
				frame.subFrames[gridName]:SetPoint("CENTER", frame, "TOPLEFT", x, y);
				--frame.subFrames[gridName].fs:SetText(string.upper(gridName));
				frame.subFrames[gridName]:Show();
			end
			if (data.adjustWidth) then
				--Adjust width to fit columns.
				frame:SetWidth(width);
				--Hide the last column texture sitting on the border.
				lastColumn:Hide();
			else
				lastColumn:Show();
			end
		end
	end
	frame.hideAllRows = function()
		--Don't hide first header row.
		if (frame.maxRowCount and frame.maxRowCount > 0) then
			for i = 1, frame.maxRowCount do
				if (i ~= 1) then
					local t = _G[frame:GetName() .. "GridH" .. i];
					if (t) then
						t:Hide();
					end
				end
			end
		end
	end
	frame.hideAllColumns = function()
		--Don't hide first header row.
		if (frame.maxColumnCount and frame.maxColumnCount > 0) then
			for i = 1, frame.maxColumnCount do
				if (i ~= 1) then
					local t = _G[frame:GetName() .. "GridV" .. i];
					if (t) then
						t:Hide();
					end
				end
			end
		end
	end
	return frame;
end

function NRC:createSimpleTextFrame(name, width, height, x, y, borderSpacing)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	if (borderSpacing) then
		frame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", frame, "BackdropTemplate");
		frame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		frame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		frame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		frame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 2, bottom = 2, right = 2},
		});
		frame.borderFrame:SetBackdrop({
			--edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-FullTopRight",
			tileEdge = true,
			edgeSize = 16,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
	else
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
			edgeFile = [[Interface/Buttons/WHITE8X8]], 
			edgeSize = 4,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
	end
	--frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetToplevel(true);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	frame:SetFrameLevel(10);
	frame:SetPoint("TOP", UIParent, "CENTER", x, y);
	frame.fs = frame:CreateFontString(name .. "FS", "HIGH");
	frame.fs:SetPoint("TOP", 0, -3);
	frame.fs:SetFont(NRC.regionFont, 14);
	frame.fs2 = frame:CreateFontString(name .. "FS", "HIGH");
	frame.fs2:SetPoint("TOPLEFT", 7, -25);
	frame.fs2:SetFont(NRC.regionFont, 14);
	frame.fs2:SetJustifyH("LEFT");
	--Click button to be used for whatever, set onclick in the frame data func.
	frame.button = CreateFrame("Button", name .. "Button", frame, "NRC_EJButtonTemplate");
	frame.button:SetFrameLevel(15);
	frame.button:Hide();
	--Top right X close button.
	frame.closeButton = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.closeButton:SetPoint("TOPRIGHT", 3.45, 3.2);
	frame.closeButton:SetWidth(26);
	frame.closeButton:SetHeight(26);
	frame.closeButton:SetFrameLevel(15);
	frame.closeButton:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	frame:Hide();
	return frame;
end

--Simple frame, just using fontstrings and not seperate frames for each line, no hover over tooltips etc.
function NRC:createSimpleScrollFrame(name, width, height, x, y, notSpecialFrames)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame.scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", frame, "UIPanelScrollFrameTemplate");
	--frame.scrollFrame:SetAllPoints();
	frame.scrollChild = CreateFrame("Frame", "$parentScrollChild", frame.scrollFrame);
	frame.scrollFrame:SetScrollChild(frame.scrollChild);
	--frame.scrollChild:SetWidth(frame:GetWidth() - 30);
	frame.scrollChild:SetAllPoints();
	frame.scrollChild:SetPoint("RIGHT", -40, 0);
	frame.scrollChild:SetPoint("TOP", 0, -20);
	frame.scrollChild:SetHeight(1);
	frame.scrollChild:SetScript("OnSizeChanged", function(self,event)
		frame.scrollChild:SetWidth(self:GetWidth())
	end)
	frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -8);
	frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 8);
	
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 4, left = 4, bottom = 4, right = 4},
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tileEdge = true,
		edgeSize = 16,
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	frame:SetBackdropBorderColor(1, 1, 1, 0.7);
	frame.scrollFrame.ScrollBar:ClearAllPoints();
	frame.scrollFrame.ScrollBar:SetPoint("TOPRIGHT", -5, -(frame.scrollFrame.ScrollBar.ScrollDownButton:GetHeight()) + 1);
	frame.scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", -5, frame.scrollFrame.ScrollBar.ScrollUpButton:GetHeight());
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	if (not notSpecialFrames) then
		tinsert(UISpecialFrames, frame);
		frame:SetUserPlaced(false);
	end
	frame:SetPoint("CENTER", UIParent, x, y);
	frame:SetSize(width, height);
	frame:SetFrameStrata("HIGH");
	frame:SetFrameLevel(140);
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
			if (notSpecialFrames) then
				self:SetUserPlaced(false);
			end
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	frame.scrollChild:EnableMouse(true);
	frame.scrollChild:SetHyperlinksEnabled(true);
	frame.scrollChild:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
	--Set all fonts in the module using the frame.
	--Header string.
	frame.scrollChild.fs = frame.scrollChild:CreateFontString(name .. "FS", "HIGH");
	frame.scrollChild.fs:SetPoint("TOP", 0, -0);
	--The main display string.
	frame.scrollChild.fs2 = frame.scrollChild:CreateFontString(name .. "FS", "HIGH");
	frame.scrollChild.fs2:SetPoint("TOPLEFT", 10, -24);
	frame.scrollChild.fs2:SetJustifyH("LEFT");
	--Bottom string.
	frame.scrollChild.fs3 = frame.scrollChild:CreateFontString(name .. "FS", "HIGH");
	frame.scrollChild.fs3:SetPoint("BOTTOM", 0, -20);
	--frame.scrollChild.fs3:SetFont(NRC.regionFont, 14);
	--Top right X close button.
	frame.close = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.close:SetPoint("TOPRIGHT", -22, -4);
	frame.close:SetWidth(20);
	frame.close:SetHeight(20);
	frame.close:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.close:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame:Hide();
	return frame;
end

--Simple frame, just using fontstrings and not seperate frames for each line, no hover over tooltips etc.
function NRC:createSimpleInputScrollFrame(name, width, height, x, y, notSpecialFrames)
	local frame = CreateFrame("ScrollFrame", name, UIParent, "BackdropTemplate,InputScrollFrameTemplate");
	--[[frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 4, left = 4, bottom = 4, right = 4},
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tileEdge = true,
		edgeSize = 16,
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	frame:SetBackdropBorderColor(1, 1, 1, 0.7);]]
	frame.CharCount:Hide();
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	if (not notSpecialFrames) then
		tinsert(UISpecialFrames, frame);
	end
	frame:SetPoint("CENTER", UIParent, x, y);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	frame.fs = frame.EditBox:CreateFontString(name .. "FS", "HIGH");
	frame.fs:SetPoint("TOP", 0, -0);
	frame.fs:SetFont(NRC.regionFont, 14);
	frame.EditBox:SetWidth(width);
	--Top right X close button.
	frame.close = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.close:SetPoint("TOPRIGHT", -10, 0);
	frame.close:SetWidth(20);
	frame.close:SetHeight(20);
	frame.close:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.close:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame:Hide();
	return frame;
	--Changing scroll position requires a slight delay.
	--Second delay is a backup.
	--[[C_Timer.After(0.05, function()
		trackedItemsFrame:SetVerticalScroll(0);
	end)
	C_Timer.After(0.3, function()
		trackedItemsFrame:SetVerticalScroll(0);
	end)
	--So interface options and this frame will open on top of each other.
	if (InterfaceOptionsFrame:IsShown()) then
		trackedItemsFrame:SetFrameStrata("DIALOG");
	else
		trackedItemsFrame:SetFrameStrata("HIGH");
	end
	trackedItemsFrame.EditBox:ClearFocus();]]
end

function NRC:createMainFrame(name, width, height, x, y, tabs)
	local frame = CreateFrame("ScrollFrame", name, UIParent, "ButtonFrameTemplate");
	--Overwrite the Blizzard close button, trying to fix a in combat bug the template has.
	_G[name .. "CloseButton"]:SetScript("OnClick", function(self)
		frame:Hide();
	end)
	frame:Hide();
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	tinsert(UISpecialFrames, frame);
	frame:SetPoint("CENTER", UIParent, 0, 100);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	frame.titleText2 = CreateFrame("Frame", "$parentTitleText2", frame);
	frame.titleText2:SetSize(1, 1);
	frame.titleText2:SetPoint("TOP", 0, -41);
	frame.titleText2.texture = frame.titleText2:CreateTexture("$parentTexture", "ARTWORK");
	frame.titleText2.texture:SetSize(50, 41);
	frame.titleText2.texture:SetScale(0.9);
	frame.titleText2.texture:SetPoint("LEFT", frame.titleText2, "RIGHT", 7, 0);
	--frame.titleText2.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
	--frame.titleText2.texture:SetTexCoord(0, 0.76171875, 0, 0.65625); --Blizards coords.
	frame.titleText2.texture:SetTexCoord(0, 0.76171875, 0.06, 0.60625); --I crop out the top and bottom a little so it has sharper edges.
	frame.titleText2.fs = frame.titleText2:CreateFontString("$parentFS", "MEDIUM");
	frame.titleText2.fs:SetPoint("LEFT", 0, 0);
	frame.titleText2.fs:SetFontObject(QuestFont_Super_Huge);
	frame.titleText2.fs:SetJustifyH("LEFT");
	--Back button.
	frame.backButton = CreateFrame("Button", "$parentBackButton", frame, "UIPanelButtonTemplate");
	frame.backButton:SetPoint("TOPLEFT", 55.5, -0.5);
	frame.backButton:SetSize(100, 20);
	frame.backButton:SetText("<- Back");
	frame.backButton:SetNormalFontObject("GameFontNormal");
	--frame.removeButton:SetScript("OnClick", function(self, arg)
		--Set this in the frame recalc.
	--end)
			
	local icon = frame:CreateTexture("$parentIcon", "OVERLAY", nil, -8);
	icon:SetSize(60, 60);
	icon:SetPoint("TOPLEFT", -5, 7);
	icon:SetTexture("Interface\\AddOns\\NovaRaidCompanion\\Media\\nrc_icon2");
	icon:SetTexCoord(0,1,0,1);
	--local ag = icon:CreateAnimationGroup()
	--local anim = ag:CreateAnimation("Rotation")
	--anim:SetDegrees(360)
	--anim:SetDuration(60)
	--ag:Play()
	--ag:SetLooping("REPEAT")
    frame.icon = icon
    
	--Create the subframe for the scroll frame to sit on.
	local subFrame = CreateFrame("Frame", name .. "SubFrame", frame);
	subFrame:SetPoint("TOPLEFT",10,-65)
    subFrame:SetPoint("BOTTOMRIGHT",-10,30)
    frame.subFrame = subFrame;
    
	local scrollFrame = CreateFrame("ScrollFrame", name .. "ScrollFrame", subFrame, "UIPanelScrollFrameTemplate");
	scrollFrame:SetPoint("TOPLEFT")
	scrollFrame:SetPoint("BOTTOMRIGHT",-27,0)
	frame.scrollFrame = scrollFrame;
	
	--[[local scrollingMessageFrame = CreateFrame("ScrollingMessageFrame", name .. "ScrollingMessageFrame", subFrame);
	scrollingMessageFrame:SetFading(false);
	scrollingMessageFrame:SetFontObject("GameFontNormalSmall");
	scrollingMessageFrame:SetJustifyH("LEFT")
	scrollingMessageFrame:SetMaxLines(5000);
	scrollingMessageFrame:EnableMouse(true);
	scrollingMessageFrame:EnableMouseWheel(true);
	scrollingMessageFrame:SetScript("OnMouseWheel", function(self, delta)
		self:ScrollByAmount(delta * 5);
	end)
	scrollingMessageFrame:SetHyperlinksEnabled(true);
	scrollingMessageFrame:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
	--scrollingMessageFrame:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP)
	--scrollingMessageFrame:SetAllPoints();
	--scrollingMessageFrame:SetPoint("CENTER")
	--scrollingMessageFrame:SetAllPoints();
	--scrollingMessageFrame:Hide();
	scrollingMessageFrame:SetWidth(200)
	scrollingMessageFrame:SetHeight(200)
	scrollingMessageFrame:SetPoint("CENTER")
	frame.scrollingMessageFrame = scrollingMessageFrame;]]
	
	local tex = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-6);
	tex:SetPoint("TOP", scrollFrame);
	tex:SetPoint("RIGHT", scrollFrame, 25.5, 0);
	tex:SetPoint("BOTTOM", scrollFrame);
	tex:SetWidth(26);
	tex:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar");
	tex:SetTexCoord(0,0.45,0.1640625,1);
	tex:SetAlpha(0.5);
	
	local scrollChild = CreateFrame("Frame", nil, scrollFrame);
	scrollChild:SetWidth(scrollFrame:GetWidth());
	scrollChild:SetHeight(1);
	scrollFrame:SetScrollChild(scrollChild);
	scrollChild.fs = scrollChild:CreateFontString("$parentFS", "MEDIUM");
	scrollChild.fs:SetJustifyH("LEFT");
	scrollChild.fs:SetFontObject(Game16Font);
	scrollChild.fs2 = scrollChild:CreateFontString("$parentFS2", "MEDIUM");
	scrollChild.fs2:SetJustifyH("LEFT");
	scrollChild.fs2:SetFont(NRC.regionFont, 14);
	scrollChild.fs3 = scrollChild:CreateFontString("$parentFS3", "MEDIUM");
	scrollChild.fs3:SetJustifyH("LEFT");
	scrollChild.fs3:SetFont(NRC.regionFont, 14);
	scrollChild.fs4 = scrollChild:CreateFontString("$parentFS4", "MEDIUM");
	scrollChild.fs4:SetJustifyH("LEFT");
	scrollChild.fs4:SetFont(NRC.regionFont, 14);
	scrollChild.fs5 = scrollChild:CreateFontString("$parentFS5", "MEDIUM");
	scrollChild.fs5:SetJustifyH("LEFT");
	scrollChild.fs5:SetFont(NRC.regionFont, 14);
	scrollChild.rfs = scrollChild:CreateFontString("$parentRFS", "MEDIUM");
	scrollChild.rfs:SetJustifyH("RIGHT");
	scrollChild.rfs:SetFont(NRC.regionFont, 14);
	frame.bottomfs = frame:CreateFontString("$parentBottomFS", "MEDIUM");
	frame.bottomfs:SetJustifyH("RIGHT");
	frame.bottomfs:SetFont(NRC.regionFont, 14);
	frame.bottomfs:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 8);
	scrollChild:SetScript("OnSizeChanged", function(self,event)
		scrollChild:SetWidth(self:GetWidth())
	end)
	scrollChild:EnableMouse(true);
	scrollChild:SetHyperlinksEnabled(true);
	scrollChild:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
	frame.scrollChild = scrollChild;
	
	frame.scrollChild.normalButton = CreateFrame("Button", "$parentNormalButton", frame.scrollChild, "UIPanelButtonTemplate");
	--frame.scrollChild.normalButton:SetNormalFontObject("NRC_Game10Font");
	frame.scrollChild.normalButton:SetNormalFontObject("GameFontNormalSmall");
	frame.scrollChild.normalButton:Hide();
	--[[Set in module.
	frame.scrollChild.normalButton:SetPoint("TOPLEFT", 55.5, -0.5);
	frame.scrollChild.normalButton:SetSize(100, 20);
	frame.scrollChild.normalButton:SetText(L["Tracked Consumes List"]);]]
	
	frame.scrollChild.exportButton = CreateFrame("Button", "$parentExportButton", frame.scrollChild, "UIPanelButtonTemplate");
	frame.scrollChild.exportButton:SetNormalFontObject("GameFontNormalSmall");
	frame.scrollChild.exportButton:Hide();
	--[[Set in module.
	frame.scrollChild.normalButton:SetPoint("TOPLEFT", 55.5, -0.5);
	frame.scrollChild.normalButton:SetSize(100, 20);
	frame.scrollChild.normalButton:SetText(L["Tracked Consumes List"]);]]
	
	frame.scrollChild.checkbox = CreateFrame("CheckButton", "$parentCheckbox", frame.scrollChild, "ChatConfigCheckButtonTemplate");
	frame.scrollChild.checkbox.Text:SetFont(NRC.regionFont, 13);
	frame.scrollChild.checkbox.Text:SetPoint("LEFT", frame.scrollChild.checkbox, "RIGHT", 0, 0);
	frame.scrollChild.checkbox:SetWidth(23);
	frame.scrollChild.checkbox:SetHeight(23);
	frame.scrollChild.checkbox:SetHitRectInsets(0, 0, -10, 7);
	--Create a more compact tooltip, must be named tooltip2 because tooltip gets overwritten by the frame.
	frame.scrollChild.checkbox.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.scrollChild.checkbox.tooltip2:SetFrameStrata("TOOLTIP");
	frame.scrollChild.checkbox.tooltip2:SetFrameLevel(9);
	frame.scrollChild.checkbox.tooltip2:SetPoint("RIGHT", frame.scrollChild.checkbox, "LEFT", -2, 0);
	frame.scrollChild.checkbox.tooltip2.fs = frame.scrollChild.checkbox.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
	frame.scrollChild.checkbox.tooltip2.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.checkbox.tooltip2.fs:SetFont(NRC.regionFont, 12);
	--frame.scrollChild.checkbox.tooltip2.fs:SetJustifyH("LEFT");
	frame.scrollChild.checkbox.tooltip2:Hide();
	frame.scrollChild.checkbox:SetScript("OnEnter", function(self)
		frame.scrollChild.checkbox.tooltip2:SetWidth(frame.scrollChild.checkbox.tooltip2.fs:GetStringWidth() + 18);
		frame.scrollChild.checkbox.tooltip2:SetHeight(frame.scrollChild.checkbox.tooltip2.fs:GetStringHeight() + 12);
		frame.scrollChild.checkbox.tooltip2:Show();		
	end)
	frame.scrollChild.checkbox:SetScript("OnLeave", function(self)
		frame.scrollChild.checkbox.tooltip2:Hide();
	end)
	--frame.scrollChild.checkbox:SetFrameLevel(6); --One level above the dropdown menu so they can be close together.
	frame.scrollChild.checkbox:Hide();
	frame.scrollChild.checkbox2 = CreateFrame("CheckButton", "$parentCheckbox2", frame.scrollChild, "ChatConfigCheckButtonTemplate");
	frame.scrollChild.checkbox2.Text:SetFont(NRC.regionFont, 13);
	frame.scrollChild.checkbox2.Text:SetPoint("LEFT", frame.scrollChild.checkbox2, "RIGHT", 0, 0);
	frame.scrollChild.checkbox2:SetWidth(23);
	frame.scrollChild.checkbox2:SetHeight(23);
	frame.scrollChild.checkbox2:SetHitRectInsets(0, 0, -10, 7);
	frame.scrollChild.checkbox2:Hide();
	frame.scrollChild.checkbox2.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.scrollChild.checkbox2.tooltip2:SetFrameStrata("TOOLTIP");
	frame.scrollChild.checkbox2.tooltip2:SetFrameLevel(9);
	frame.scrollChild.checkbox2.tooltip2:SetPoint("RIGHT", frame.scrollChild.checkbox, "LEFT", -2, 0);
	frame.scrollChild.checkbox2.tooltip2.fs = frame.scrollChild.checkbox2.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
	frame.scrollChild.checkbox2.tooltip2.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.checkbox2.tooltip2.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.checkbox2.tooltip2:Hide();
	frame.scrollChild.checkbox2:SetScript("OnEnter", function(self)
		frame.scrollChild.checkbox2.tooltip2:SetWidth(frame.scrollChild.checkbox2.tooltip2.fs:GetStringWidth() + 18);
		frame.scrollChild.checkbox2.tooltip2:SetHeight(frame.scrollChild.checkbox2.tooltip2.fs:GetStringHeight() + 12);
		frame.scrollChild.checkbox2.tooltip2:Show();
	end)
	frame.scrollChild.checkbox2:SetScript("OnLeave", function(self)
		frame.scrollChild.checkbox2.tooltip2:Hide();
	end)
	frame.scrollChild.checkbox3 = CreateFrame("CheckButton", "$parentCheckbox3", frame.scrollChild, "ChatConfigCheckButtonTemplate");
	frame.scrollChild.checkbox3.Text:SetFont(NRC.regionFont, 13);
	frame.scrollChild.checkbox3.Text:SetPoint("LEFT", frame.scrollChild.checkbox3, "RIGHT", 0, 0);
	frame.scrollChild.checkbox3:SetWidth(23);
	frame.scrollChild.checkbox3:SetHeight(23);
	frame.scrollChild.checkbox3:SetHitRectInsets(0, 0, -10, 7);
	frame.scrollChild.checkbox3:Hide();
	frame.scrollChild.checkbox3.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.scrollChild.checkbox3.tooltip2:SetFrameStrata("TOOLTIP");
	frame.scrollChild.checkbox3.tooltip2:SetFrameLevel(9);
	frame.scrollChild.checkbox3.tooltip2:SetPoint("RIGHT", frame.scrollChild.checkbox, "LEFT", -2, 0);
	frame.scrollChild.checkbox3.tooltip2.fs = frame.scrollChild.checkbox3.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
	frame.scrollChild.checkbox3.tooltip2.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.checkbox3.tooltip2.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.checkbox3.tooltip2:Hide();
	frame.scrollChild.checkbox3:SetScript("OnEnter", function(self)
		frame.scrollChild.checkbox3.tooltip2:SetWidth(frame.scrollChild.checkbox3.tooltip2.fs:GetStringWidth() + 18);
		frame.scrollChild.checkbox3.tooltip2:SetHeight(frame.scrollChild.checkbox3.tooltip2.fs:GetStringHeight() + 12);
		frame.scrollChild.checkbox3.tooltip2:Show();
	end)
	frame.scrollChild.checkbox3:SetScript("OnLeave", function(self)
		frame.scrollChild.checkbox3.tooltip2:Hide();
	end)
	frame.scrollChild.checkbox4 = CreateFrame("CheckButton", "$parentCheckbox4", frame.scrollChild, "ChatConfigCheckButtonTemplate");
	frame.scrollChild.checkbox4.Text:SetFont(NRC.regionFont, 13);
	frame.scrollChild.checkbox4.Text:SetPoint("LEFT", frame.scrollChild.checkbox4, "RIGHT", 0, 0);
	frame.scrollChild.checkbox4:SetWidth(23);
	frame.scrollChild.checkbox4:SetHeight(23);
	frame.scrollChild.checkbox4:SetHitRectInsets(0, 0, -10, 7);
	frame.scrollChild.checkbox4:Hide();
	frame.scrollChild.checkbox4.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.scrollChild.checkbox4.tooltip2:SetFrameStrata("TOOLTIP");
	frame.scrollChild.checkbox4.tooltip2:SetFrameLevel(9);
	frame.scrollChild.checkbox4.tooltip2:SetPoint("RIGHT", frame.scrollChild.checkbox, "LEFT", -2, 0);
	frame.scrollChild.checkbox4.tooltip2.fs = frame.scrollChild.checkbox4.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
	frame.scrollChild.checkbox4.tooltip2.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.checkbox4.tooltip2.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.checkbox4.tooltip2:Hide();
	frame.scrollChild.checkbox4:SetScript("OnEnter", function(self)
		frame.scrollChild.checkbox4.tooltip2:SetWidth(frame.scrollChild.checkbox4.tooltip2.fs:GetStringWidth() + 18);
		frame.scrollChild.checkbox4.tooltip2:SetHeight(frame.scrollChild.checkbox4.tooltip2.fs:GetStringHeight() + 12);
		frame.scrollChild.checkbox4.tooltip2:Show();
	end)
	frame.scrollChild.checkbox4:SetScript("OnLeave", function(self)
		frame.scrollChild.checkbox4.tooltip2:Hide();
	end)
	frame.scrollChild.checkbox5 = CreateFrame("CheckButton", "$parentCheckbox5", frame.scrollChild, "ChatConfigCheckButtonTemplate");
	frame.scrollChild.checkbox5.Text:SetFont(NRC.regionFont, 13);
	frame.scrollChild.checkbox5.Text:SetPoint("LEFT", frame.scrollChild.checkbox5, "RIGHT", 0, 0);
	frame.scrollChild.checkbox5:SetWidth(23);
	frame.scrollChild.checkbox5:SetHeight(23);
	frame.scrollChild.checkbox5:SetHitRectInsets(0, 0, -10, 7);
	frame.scrollChild.checkbox5:Hide();
	frame.scrollChild.checkbox5.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.scrollChild.checkbox5.tooltip2:SetFrameStrata("TOOLTIP");
	frame.scrollChild.checkbox5.tooltip2:SetFrameLevel(9);
	frame.scrollChild.checkbox5.tooltip2:SetPoint("RIGHT", frame.scrollChild.checkbox, "LEFT", -2, 0);
	frame.scrollChild.checkbox5.tooltip2.fs = frame.scrollChild.checkbox5.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
	frame.scrollChild.checkbox5.tooltip2.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.checkbox5.tooltip2.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.checkbox5.tooltip2:Hide();
	frame.scrollChild.checkbox5:SetScript("OnEnter", function(self)
		frame.scrollChild.checkbox5.tooltip2:SetWidth(frame.scrollChild.checkbox5.tooltip2.fs:GetStringWidth() + 18);
		frame.scrollChild.checkbox5.tooltip2:SetHeight(frame.scrollChild.checkbox5.tooltip2.fs:GetStringHeight() + 12);
		frame.scrollChild.checkbox5.tooltip2:Show();
	end)
	frame.scrollChild.checkbox5:SetScript("OnLeave", function(self)
		frame.scrollChild.checkbox5.tooltip2:Hide();
	end)
	--[[Set all this stuff in the module using the frame.
	frame.scrollChild.checkbox:SetPoint("CENTER", frame.scrollChild, 0, 0);
	frame.scrollChild.checkbox.Text:SetText(L["Groups"]);
	frame.scrollChild.checkbox.tooltip2 = L["sortByGroupsTooltip"];
	frame.scrollChild.checkbox:SetChecked(NRC.config.sortRaidStatusByGroups);
	frame.scrollChild.checkbox.Text:SetText(L["Groups"]);
	frame.scrollChild.checkbox:SetScript("OnClick", function() end)]]
	
	frame.scrollChild.dropdownMenu = NRC.DDM:Create_UIDropDownMenu("$parentDropdownMenu", frame.scrollChild)
	frame.scrollChild.dropdownMenu.tooltip = CreateFrame("Frame", "$parentDropdownMenuTooltip", frame.scrollChild.dropdownMenu, "TooltipBorderedFrameTemplate");
	frame.scrollChild.dropdownMenu.tooltip:SetFrameStrata("TOOLTIP");
	frame.scrollChild.dropdownMenu.tooltip:SetFrameLevel(9);
	frame.scrollChild.dropdownMenu.tooltip:SetPoint("RIGHT", frame.scrollChild.dropdownMenu, "LEFT", 0, 0);
	frame.scrollChild.dropdownMenu.tooltip.fs = frame.scrollChild.dropdownMenu.tooltip:CreateFontString("$parentDropdownMenuTooltipFS", "ARTWORK");
	frame.scrollChild.dropdownMenu.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.dropdownMenu.tooltip.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.dropdownMenu:HookScript("OnEnter", function(self)
		frame.scrollChild.dropdownMenu.tooltip:Show();
	end)
	frame.scrollChild.dropdownMenu:HookScript("OnLeave", function(self)
		frame.scrollChild.dropdownMenu.tooltip:Hide();
	end)
	frame.scrollChild.dropdownMenu.tooltip:Hide();
	
	frame.scrollChild.dropdownMenu2 = NRC.DDM:Create_UIDropDownMenu("$parentDropdownMenu2", frame.scrollChild)
	frame.scrollChild.dropdownMenu2.tooltip = CreateFrame("Frame", "$parentDropdownMenuTooltip2", frame.scrollChild.dropdownMenu2, "TooltipBorderedFrameTemplate");
	frame.scrollChild.dropdownMenu2.tooltip:SetFrameStrata("TOOLTIP");
	frame.scrollChild.dropdownMenu2.tooltip:SetFrameLevel(9);
	frame.scrollChild.dropdownMenu2.tooltip:SetPoint("RIGHT", frame.scrollChild.dropdownMenu2, "LEFT", 0, 0);
	frame.scrollChild.dropdownMenu2.tooltip.fs = frame.scrollChild.dropdownMenu2.tooltip:CreateFontString("$parentDropdownMenuTooltipFS2", "ARTWORK");
	frame.scrollChild.dropdownMenu2.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.dropdownMenu2.tooltip.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.dropdownMenu2:HookScript("OnEnter", function(self)
		frame.scrollChild.dropdownMenu2.tooltip:Show();
	end)
	frame.scrollChild.dropdownMenu2:HookScript("OnLeave", function(self)
		frame.scrollChild.dropdownMenu2.tooltip:Hide();
	end)
	frame.scrollChild.dropdownMenu2.tooltip:Hide();
	
	frame.scrollChild.dropdownMenu3 = NRC.DDM:Create_UIDropDownMenu("$parentDropdownMenu3", frame.scrollChild)
	frame.scrollChild.dropdownMenu3.tooltip = CreateFrame("Frame", "$parentDropdownMenuTooltip3", frame.scrollChild.dropdownMenu3, "TooltipBorderedFrameTemplate");
	frame.scrollChild.dropdownMenu3.tooltip:SetFrameStrata("TOOLTIP");
	frame.scrollChild.dropdownMenu3.tooltip:SetFrameLevel(9);
	frame.scrollChild.dropdownMenu3.tooltip:SetPoint("RIGHT", frame.scrollChild.dropdownMenu3, "LEFT", 0, 0);
	frame.scrollChild.dropdownMenu3.tooltip.fs = frame.scrollChild.dropdownMenu3.tooltip:CreateFontString("$parentDropdownMenuTooltipFS3", "ARTWORK");
	frame.scrollChild.dropdownMenu3.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.scrollChild.dropdownMenu3.tooltip.fs:SetFont(NRC.regionFont, 12);
	frame.scrollChild.dropdownMenu3:HookScript("OnEnter", function(self)
		frame.scrollChild.dropdownMenu3.tooltip:Show();
	end)
	frame.scrollChild.dropdownMenu3:HookScript("OnLeave", function(self)
		frame.scrollChild.dropdownMenu3.tooltip:Hide();
	end)
	frame.scrollChild.dropdownMenu3.tooltip:Hide();
	--[[Set all this stuff in the module using the frame, example from the raid log consumes func.
	frame.scrollChild.dropdownMenu:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -90, -15);
	frame.scrollChild.dropdownMenu.tooltip2.fs:SetText("|Cffffd000" .. L["instanceFrameSelectAltMsg"]);
	frame.scrollChild.dropdownMenu.tooltip:SetWidth(frame.scrollChild.dropdownMenu.tooltip.fs:GetStringWidth() + 18);
	frame.scrollChild.dropdownMenu.tooltip:SetHeight(frame.scrollChild.dropdownMenu.tooltip.fs:GetStringHeight() + 12);
	frame.scrollChild.dropdownMenu.initialize = function(dropdown)
		local options = {
			["Option1"] = 1,
			["Option2"] = 2,
		};
		for k, v in NRC:pairsByKeys(options) do
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = k;
			info.checked = false;
			info.value = v;
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.consumesViewType = v;
				NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
		end
		if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(frame.scrollChild.dropdownMenu)) then
			--If no value set then it's first load, set saved db value.
			NRC.DDM:UIDropDownMenu_SetSelectedValue(frame.scrollChild.dropdownMenu, NRC.config.consumesViewType);
		end
		frame.scrollChild.dropdownMenu:HookScript("OnShow", frame.scrollChild.dropdownMenu.initialize);
	end]]
	
	--Create fontstrings used for displaying long text that exceeds a single fontstring char limit.
	--The text is split up between multiple fontstrings anchored to the bottom of each other.
	scrollChild.splitfs = {};
	for i = 1, 100 do
		scrollChild.splitfs[i] = scrollChild:CreateFontString("$parentSplitFS" .. i, "MEDIUM");
		scrollChild.splitfs[i]:SetJustifyH("LEFT");
		scrollChild.splitfs[i]:SetFont(NRC.regionFont, 14);
	end
	--[[scrollChild.separators = {};
	scrollChild.getSeparator = function(count, data)
		if (not scrollChild.separators[count]) then
			scrollChild.createSeparator(count, data);
		end
		return scrollChild.separators[count];
	end
	scrollChild.createSeparator = function(count, data)
		if (not frame.simpleLineFrames[count]) then
			local obj = scrollChild:CreateTexture(nil, "BORDER");
			obj:SetColorTexture(0.6, 0.6, 0.6, 0.85);
			obj:SetHeight(1);
			obj:Hide();
			scrollChild.separators[count] = obj;
		end
	end
	scrollChild.hideAllSeparators = function()
		for k, v in pairs(frame.separators) do
			v:Hide();
		end
	end]]
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	frame.fs = frame:CreateFontString(name .. "FS", "MEDIUM");
	frame.fs:SetPoint("TOP", 0, -0);
	frame.fs:SetFont(NRC.regionFont, 14);
	frame.fs2 = frame:CreateFontString(name .. "FS", "MEDIUM");
	frame.fs2:SetPoint("TOPLEFT", 0, -14);
	frame.fs2:SetFont(NRC.regionFont, 14);
	frame.fs3 = frame:CreateFontString(name .. "FS", "MEDIUM");
	frame.fs3:SetPoint("BOTTOM", 0, -20);
	frame.fs3:SetFont(NRC.regionFont, 14);
	
	frame.dragFrame = CreateFrame("Frame", name .. "DragFrame", frame);
	frame.dragFrame:SetToplevel(true);
	frame.dragFrame:EnableMouse(true);
	frame.dragFrame:SetWidth(305);
	frame.dragFrame:SetHeight(38);
	frame.dragFrame:SetPoint("TOP", 0, 4);
	frame.dragFrame:SetFrameLevel(131);
	frame.dragFrame.tooltip = CreateFrame("Frame", name .. "DragTooltip", frame.dragFrame, "TooltipBorderedFrameTemplate");
	frame.dragFrame.tooltip:SetPoint("CENTER", frame.dragFrame, "TOP", 0, 12);
	frame.dragFrame.tooltip:SetFrameStrata("TOOLTIP");
	frame.dragFrame.tooltip:SetFrameLevel(9);
	frame.dragFrame.tooltip:SetAlpha(.8);
	frame.dragFrame.tooltip.fs = frame.dragFrame.tooltip:CreateFontString(name .. "DragTooltipFS", "MEDIUM");
	frame.dragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
	frame.dragFrame.tooltip.fs:SetFont(NRC.regionFont, 12);
	frame.dragFrame.tooltip.fs:SetText("Hold to drag");
	frame.dragFrame.tooltip:SetWidth(frame.dragFrame.tooltip.fs:GetStringWidth() + 16);
	frame.dragFrame.tooltip:SetHeight(frame.dragFrame.tooltip.fs:GetStringHeight() + 10);
	frame.dragFrame:SetScript("OnEnter", function(self)
		frame.dragFrame.tooltip:Show();
	end)
	frame.dragFrame:SetScript("OnLeave", function(self)
		frame.dragFrame.tooltip:Hide();
	end)
	frame.dragFrame.tooltip:Hide();
	frame.dragFrame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self:GetParent().isMoving) then
			--self:GetParent().EditBox:ClearFocus();
			self:GetParent():StartMoving();
			self:GetParent().isMoving = true;
			--self:GetParent():SetUserPlaced(false);
		end
	end)
	frame.dragFrame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self:GetParent().isMoving) then
			self:GetParent():StopMovingOrSizing();
			self:GetParent().isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
		end
	end)
	frame.dragFrame:SetScript("OnHide", function(self)
		if (self:GetParent().isMoving) then
			self:GetParent():StopMovingOrSizing();
			self:GetParent().isMoving = false;
		end
	end)
	--Large line frames for the raid log instance entries.
	frame.lineFrames = {};
	frame.getLineFrame = function(count, data)
		if (not frame.lineFrames[count]) then
			frame.createLineFrame(count, data);
		end
		return frame.lineFrames[count];
	end
	frame.createLineFrame = function(count, data)
		if (not frame.lineFrames[count]) then
			--local obj = CreateFrame("Button", name .. "Line" .. count, frame.scrollChild, "UIServiceButtonTemplate");
			local obj = CreateFrame("Button", name .. "Line" .. count, frame.scrollChild);
			obj:RegisterForClicks("LeftButtonDown", "RightButtonDown");
			obj.normalTex = obj:CreateTexture("$parentNormalTexture", "ARTWORK");
			obj.normalTex:SetAlpha(0.5);
			obj.normalTex:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\TrainerTextures2");
			obj.normalTex:SetTexCoord(0.00195313, 0.57421875, 0.65820313, 0.75000000);
			
			--normal:SetColorTexture(1, 1, 1);
			obj.highlightTex = obj:CreateTexture("$parentHighlightTexture", "HIGHLIGHT");
			obj.highlightTex:SetAlpha(0.5);
			--UI-EJ-BossButton-Highlight.
			obj.highlightTex:SetTexture("Interface\\ClassTrainerFrame\\TrainerTextures");
			obj.highlightTex:SetTexCoord(0.00195313, 0.57421875, 0.75390625, 0.84570313);
			obj.count = count;
			--local bg = obj:CreateTexture(nil, "HIGH");
			--bg:SetAllPoints(obj);
			--obj.texture = bg;
			obj.leftTexture = obj:CreateTexture(nil);
			obj.leftTexture:SetSize(50, 41);
			obj.leftTexture:SetScale(0.8);
			obj.leftTexture:SetPoint("LEFT", 42, 0);
			obj.fs = obj:CreateFontString(name .. "LineFS" .. count, "ARTWORK");
			obj.fs:SetPoint("LEFT", 0, 0);
			obj.fs:SetFont(NRC.regionFont, 14);
			--They don't quite line up properly without justify on top of set point left.
			obj.fs:SetJustifyH("LEFT");
			obj.fs2 = obj:CreateFontString(name .. "LineFS2" .. count, "ARTWORK");
			obj.fs2:SetPoint("LEFT", 0, 0);
			obj.fs2:SetFont(NRC.regionFont, 14);
			obj.fs2:SetJustifyH("LEFT");
			obj.fs3 = obj:CreateFontString(name .. "LineFS3" .. count, "ARTWORK");
			obj.fs3:SetPoint("LEFT", 0, 0);
			obj.fs3:SetFont(NRC.regionFont, 14);
			obj.fs3:SetJustifyH("LEFT");
			obj.fs4 = obj:CreateFontString(name .. "LineFS3" .. count, "ARTWORK");
			obj.fs4:SetFont(NRC.regionFont2, 12);
			obj.fs4:SetJustifyH("LEFT");
			obj.fs5 = obj:CreateFontString(name .. "LineFS3" .. count, "ARTWORK");
			obj.fs5:SetFont(NRC.regionFont, 14);
			obj.fs5:SetJustifyH("LEFT");
			obj.fs6 = obj:CreateFontString(name .. "LineFS3" .. count, "ARTWORK");
			obj.fs6:SetFont(NRC.regionFont2, 12);
			obj.fs6:SetJustifyH("LEFT");
			obj.tooltip = CreateFrame("Frame", name .. "LineTooltip" .. count, frame, "TooltipBorderedFrameTemplate");
			obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -46);
			obj.tooltip:SetFrameStrata("MEDIUM");
			obj.tooltip:SetFrameLevel(4);
			obj.tooltip.fs = obj.tooltip:CreateFontString(name .. "LineTooltipFS" .. count, "ARTWORK");
			obj.tooltip.fs:SetPoint("CENTER", 0, 0);
			obj.tooltip.fs:SetFont(NRC.regionFont, 13);
			obj.tooltip.fs:SetJustifyH("LEFT");
			--obj.tooltip.fs:SetText("|CffDEDE42Click to view log " .. count);
			--obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
			--obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
			obj.tooltip:SetScript("OnUpdate", function(self)
				--Keep our custom tooltip at the mouse when it moves.
				if (obj.tooltip.fs:GetText() ~= "" and obj.tooltip.fs:GetText() ~= nil) then
					local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
					obj.tooltip:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 2, y / scale);
				end
			end)
			obj:SetScript("OnEnter", function(self)
				if (obj.tooltip.fs:GetText() ~= "" and obj.tooltip.fs:GetText() ~= nil) then
					obj.tooltip:Show();
					local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
					obj.tooltip:SetPoint("CENTER", nil, "BOTTOMLEFT", x / scale, y / scale);
				end
			end)
			obj:SetScript("OnLeave", function(self)
				obj.tooltip:Hide();
			end)
			obj.tooltip:Hide();
			
			--Remove instance from log button.
			obj.removeButton = CreateFrame("Button", name .. "LineRB" .. count, obj);
			obj.removeButton:SetPoint("LEFT", obj, "RIGHT", -24, 0);
			obj.removeButton:SetWidth(14);
			obj.removeButton:SetHeight(14);
			obj.removeButton:SetNormalFontObject("GameFontNormalSmall");
			obj.removeButton:SetNormalTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\Transmogrify");
			obj.removeButton:GetNormalTexture():SetTexCoord(0.945312, 0.996094, 0.171875, 0.222656);
			obj.removeButton.tooltip = CreateFrame("Frame", name .. "LineTooltipRB" .. count, frame, "TooltipBorderedFrameTemplate");
			obj.removeButton.tooltip:SetPoint("RIGHT", obj.removeButton, "LEFT", -5, 0);
			obj.removeButton.tooltip:SetFrameStrata("MEDIUM");
			obj.removeButton.tooltip:SetFrameLevel(3);
			obj.removeButton.tooltip.fs = obj.removeButton.tooltip:CreateFontString(name .. "LineTooltipRBFS" .. count, "ARTWORK");
			obj.removeButton.tooltip.fs:SetPoint("CENTER", -0, 0);
			obj.removeButton.tooltip.fs:SetFont(NRC.regionFont, 13);
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
			obj.removeButton.tooltip:Hide();
			
			--[[obj.renameButton = CreateFrame("Button", name .. "LineRename" .. count, obj, "UIMenuButtonStretchTemplate");
			obj.renameButton:SetPoint("LEFT", obj, "RIGHT", -114, 0);
			obj.renameButton:SetWidth(64);
			obj.renameButton:SetHeight(18);]]
			
			obj.expandedButton = CreateFrame("Frame", "$parentExpandedButton", obj);
			--obj.expandedButton:SetPoint("CENTER", obj, "CENTER", 0, 0);
			obj.expandedButton:SetSize(20, 20);
			local expanded = obj.expandedButton:CreateTexture("$parentExpanded", "ARTWORK");
			expanded:SetTexture("Interface\\Buttons\\UI-MinusButton-Up");
			expanded:SetAllPoints();
			obj.collapsedButton = CreateFrame("Frame", "$parentCollapsedButton", obj);
			--obj.collapsedButton:SetPoint("CENTER", obj, "CENTER", 0, 0);
			obj.collapsedButton:SetSize(20, 20);
			local collapsed = obj.collapsedButton:CreateTexture("$parentCollapsed", "ARTWORK");
			collapsed:SetTexture("Interface\\Buttons\\UI-PlusButton-Up");
			collapsed:SetAllPoints();
			obj.expandedButton:Hide();
			obj.collapsedButton:Hide();
			--UI-EJ-BossButton-Up.
			--normal:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
			--normal:SetTexCoord(0.00195313, 0.63671875, 0.21386719, 0.26757813);
			frame.lineFrames[count] = obj;
		end
	end
	frame.hideAllLineFrames = function()
		for k, v in pairs(frame.lineFrames) do
			v:Hide();
		end
	end
	--Simple line frames just for lines of text with tooltips.
	frame.simpleLineFrames = {};
	frame.getSimpleLineFrame = function(count, data)
		if (not frame.simpleLineFrames[count]) then
			frame.createSimpleLineFrame(count, data);
		end
		local obj = frame.simpleLineFrames[count];
		--Reset some defaults, these are recycled for different things.
		obj.fs:SetPoint("LEFT", 0, 0);
		obj.fs:SetJustifyH("LEFT");
		obj.fs2:SetPoint("LEFT", 0, 0);
		obj.fs2:SetPoint("RIGHT", 0, 0);
		obj.fs2:SetJustifyH("LEFT");
		obj.borderFrame:Show();
		obj:updateTooltip();
		obj:SetScript("OnClick", nil);
		return obj;
	end
	frame.createSimpleLineFrame = function(count, data)
		if (not frame.simpleLineFrames[count]) then
			--local obj = CreateFrame("Button", name .. "Line" .. count, frame.scrollChild, "UIServiceButtonTemplate");
			local obj = CreateFrame("Button", name .. "SimpleLine" .. count, frame.scrollChild);
			obj.borderFrame = CreateFrame("Frame", "$parentBorderFrame", obj, "BackdropTemplate");
			obj.borderFrame:SetPoint("TOP", 0, 2);
			obj.borderFrame:SetPoint("BOTTOM", 0, -2);
			obj.borderFrame:SetPoint("LEFT", -2, 0);
			obj.borderFrame:SetPoint("RIGHT", 2, 0);
			obj.borderFrame:SetBackdrop({
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tileEdge = true,
				edgeSize = 16,
			});
			obj.borderFrame:SetBackdropBorderColor(1, 1, 1, 0.2);
			obj:RegisterForClicks("LeftButtonDown", "RightButtonDown");
			--[[obj.normalTex = obj:CreateTexture("$parentNormalTexture", "ARTWORK");
			obj.normalTex:SetAlpha(0.5);
			obj.normalTex:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\TrainerTextures2");
			obj.normalTex:SetTexCoord(0.00195313, 0.57421875, 0.65820313, 0.75000000);]]
			
			--normal:SetColorTexture(1, 1, 1);]]
			obj.highlightTex = obj:CreateTexture("$parentHighlightTexture", "HIGHLIGHT");
			obj.highlightTex:SetAlpha(0.5);
			--UI-EJ-BossButton-Highlight.
			obj.highlightTex:SetTexture("Interface\\ClassTrainerFrame\\TrainerTextures");
			obj.highlightTex:SetTexCoord(0.00195313, 0.57421875, 0.75390625, 0.84570313);
			--obj:SetNormalTexture(obj.normalTex);
			obj:SetHighlightTexture(obj.highlightTex);
			obj.count = count;
			--local bg = obj:CreateTexture(nil, "HIGH");
			--bg:SetAllPoints(obj);
			--obj.texture = bg;
			obj.leftTexture = obj:CreateTexture(nil);
			obj.leftTexture:SetSize(50, 41);
			obj.leftTexture:SetScale(0.8);
			obj.leftTexture:SetPoint("LEFT", 42, 0);
			obj.fs = obj:CreateFontString(name .. "LineFS" .. count, "ARTWORK");
			obj.fs:SetPoint("LEFT", 0, 0);
			obj.fs:SetFont(NRC.regionFont, 14);
			--They don't quite line up properly without justify on top of set point left.
			obj.fs:SetJustifyH("LEFT");
			obj.fs2 = obj:CreateFontString(name .. "LineFS2" .. count, "ARTWORK");
			obj.fs2:SetPoint("LEFT", 0, 0);
			obj.fs2:SetPoint("RIGHT", 0, 0);
			obj.fs2:SetFont(NRC.regionFont, 14);
			obj.fs2:SetJustifyH("LEFT");
			obj.fs2:SetWordWrap(false);
			obj:EnableMouse(true);
			obj:SetHyperlinksEnabled(true);
			--obj:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
			--obj:SetScript("OnHyperlinkClick", function(self, link, text, button)
			obj:SetScript("OnHyperlinkClick", function(self, link, text, button, region, left, bottom, width, height)
				if (button == "LeftButton") then
					local linkType, linkArg;
					if (link) then
						linkType, linkArg = strsplit(":", link);
					end
					if (linkType == "NRCItem") then
						if (linkArg) then
							local itemID = tonumber(linkArg);
							if (itemID) then
								GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
								--GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
								GameTooltip:SetItemByID(itemID);
								local scale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition();
								GameTooltip:Show();
								GameTooltip:ClearAllPoints();
								GameTooltip:SetPoint("BOTTOMRIGHT", nil, "BOTTOMLEFT", (x / scale) - 5, y / scale + 14);
							end
						end
					elseif (linkType == "NRCSpell") then
						if (linkArg) then
							local spellID = tonumber(linkArg);
							if (spellID) then
								GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
								--GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
								GameTooltip:SetSpellByID(spellID);
								local scale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition();
								GameTooltip:Show();
								GameTooltip:ClearAllPoints();
								GameTooltip:SetPoint("BOTTOMRIGHT", nil, "BOTTOMLEFT", (x / scale) - 5, y / scale + 14);
							end
						end
					else
						ChatFrame_OnHyperlinkShow(self, link, text, button);
						local scale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition();
						GameTooltip:ClearAllPoints();
						GameTooltip:SetPoint("BOTTOMRIGHT", nil, "BOTTOMLEFT", (x / scale) - 5, y / scale + 14);
					end
				elseif (button == "RightButton") then
					--Mimic behavior of the frame underneath the hyperlink for right click.
					obj:GetScript("OnClick")(self, button);
				end
			end)
			--obj:SetScript("OnHyperlinkLeave", function(self, link, text, button)
			--	GameTooltip:Hide();
			--end)
			obj.tooltip = CreateFrame("Frame", name .. "LineTooltip" .. count, frame, "TooltipBorderedFrameTemplate");
			obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -46);
			obj.tooltip:SetFrameStrata("MEDIUM");
			obj.tooltip:SetFrameLevel(4);
			--Change the alpha.
			obj.tooltip.NineSlice:SetCenterColor(0, 0, 0, 1);
			obj.tooltip.fs = obj.tooltip:CreateFontString(name .. "LineTooltipFS" .. count, "ARTWORK");
			obj.tooltip.fs:SetPoint("CENTER", 0, 0);
			obj.tooltip.fs:SetFont(NRC.regionFont, 13);
			obj.tooltip.fs:SetJustifyH("LEFT");
			obj.updateTooltip = function(text)
				if (text) then
					obj.tooltip.fs:SetText(text);
					obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
					obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
				else
					obj.tooltip.fs:SetText("");
					obj.tooltip:SetWidth(0);
					obj.tooltip:SetHeight(0);
				end
			end
			obj.tooltip:SetScript("OnUpdate", function(self)
				--Keep our custom tooltip at the mouse when it moves.
				if (obj.tooltip.fs:GetText() ~= "" and obj.tooltip.fs:GetText() ~= nil) then
					local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
					obj.tooltip:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 20, (y / scale) + 20);
				end
			end)
			obj:SetScript("OnEnter", function(self)
				if (obj.tooltip.fs:GetText() ~= "" and obj.tooltip.fs:GetText() ~= nil) then
					obj.tooltip:Show();
					local scale, x, y = obj.tooltip:GetEffectiveScale(), GetCursorPosition();
					obj.tooltip:SetPoint("CENTER", nil, "BOTTOMLEFT", x / scale, y / scale);
				end
			end)
			obj:SetScript("OnLeave", function(self)
				obj.tooltip:Hide();
			end)
			obj.tooltip:Hide();
			frame.simpleLineFrames[count] = obj;
		end
	end
	frame.hideAllSimpleLineFrames = function()
		for k, v in pairs(frame.simpleLineFrames) do
			v:Hide();
		end
	end
	frame.updateExpandedFrames = function()
		for k, v in pairs(frame.lineFrames) do
			if (v.expanded) then
				v.expandedButton:Show();
				v.collapsedButton:Hide();
			else
				v.expandedButton:Hide();
				v.collapsedButton:Show();
			end
		end
	end
	frame.hideAllExpandedFrames = function()
		for k, v in pairs(frame.lineFrames) do
			v.expandedButton:Hide();
			v.collapsedButton:Hide();
		end
	end
	--Has to be upppercase to work with Blizzard tab funcs.
	frame.scrollFrame.Tabs = {};
	frame.Tabs = frame.scrollFrame.Tabs;
	frame.getTab = function(count)
		if (not frame.Tabs[count]) then
			frame.createTab(count);
		end
		return frame.Tabs[count];
	end
	frame.createTab = function(count)
		--If a tab is ever created out of numeric order this will error.
		if (not frame.Tabs[count]) then
			local obj = CreateFrame("Button", frame.scrollFrame:GetName() .. "Tab" .. count, frame.scrollFrame, "TabButtonTemplate");
			obj.count = count;
			frame.Tabs[count] = obj;
			PanelTemplates_TabResize(obj, 35);
			obj:HookScript("OnClick", function(self)
				PanelTemplates_SetTab(frame.scrollFrame, obj.count); --setting selectedTab on panel
				--We can't keep hooking this frame when things update or we'll have stacking hooks.
				--So call this func and alter the frame.handleTabClicks func as needed.
				frame.handleTabClicks(obj.count);
		    end)
			if (count == 1) then
				obj:SetPoint("BOTTOMLEFT", frame.scrollFrame, "TOPLEFT", 40, 5);
				frame.scrollFrame.numTabs = 1;
				frame.scrollFrame.selectedTab = 1;
				PanelTemplates_UpdateTabs(frame.scrollFrame);
			else
				obj:SetPoint("LEFT", frame.Tabs[count - 1], "RIGHT", 1, 0);
			end
		end
		frame.scrollFrame.numTabs = #frame.Tabs;
	end
	frame.extraButtons = {};
	frame.getExtraButton = function(count)
		if (not frame.extraButtons[count]) then
			frame.createExtraButton(count);
		end
		return frame.extraButtons[count];
	end
	frame.hideAllExtraButtons = function()
		for k, v in pairs(frame.extraButtons) do
			v:Hide();
			v:ClearAllPoints();
			v.fs2:SetText("");
			v.fs3:SetText("");
		end
	end
	frame.createExtraButton = function(count)
		--If a tab is ever created out of numeric order this will error.
		if (not frame.extraButtons[count]) then
			local obj = CreateFrame("Button", frame.scrollFrame:GetName() .. "EB" .. count, frame.scrollChild, "NRC_EJButtonTemplate");
			obj.count = count;
			obj.fs2 = obj:CreateFontString(frame.scrollFrame:GetName() .. "FS" .. count, "MEDIUM");
			obj.fs2:SetPoint("CENTER", 0, 0);
			obj.fs2:SetFontObject(Game11Font);
			obj.fs3 = obj:CreateFontString(frame.scrollFrame:GetName() .. "FS" .. count, "MEDIUM");
			obj.fs3:SetPoint("LEFT", -28, 0);
			obj.fs3:SetFontObject(Game11Font);
			frame.extraButtons[count] = obj;
		end
		frame.scrollFrame.numExtraButtons = #frame.extraButtons;
	end
	frame.handleTabClicks = function(tabID)
	
	end
	--If tab count is given as frame creation time then make them now.
	if (tabs) then
		for i = 1, tabs do
			if (tabs > 10) then
				break;
			end
			frame.createTab(i);
		end
		frame.scrollFrame.selectedTab = 1;
		PanelTemplates_UpdateTabs(frame.scrollFrame);
	end
	frame.hideAllTabs = function()
		for k, v in pairs(frame.Tabs) do
			v:Hide();
		end
	end
	frame.showAllTabs = function()
		for k, v in pairs(frame.Tabs) do
			v:Show();
		end
	end
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	return frame;
end


function NRC:createModelFrame(name, width, height, x, y, addCloseButton, transparent)
	--local frame = CreateFrame("PlayerModel", name, UIParent, "BackdropTemplate,ModelWithControlsTemplate,ModelSceneMixinTemplate");
	--local frame = CreateFrame("ModelScene", name, UIParent, "BackdropTemplate,ModelWithControlsTemplate,ModelSceneMixinTemplate");
	local frame = CreateFrame("ModelScene", name, UIParent, "BackdropTemplate,ModelSceneMixinTemplate");
	frame.creature = frame:CreateActor("creature");
	--_G[name .. "ControlFrame"]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, 0);
	if (not transparent) then
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
			edgeFile = [[Interface/Buttons/WHITE8X8]], 
			edgeSize = 1,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
	end
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	tinsert(UISpecialFrames, frame);
	frame:SetPoint("CENTER", UIParent, x, y);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	if (addCloseButton) then
		frame.closeButton = CreateFrame("Button", "$parentClose", frame, "UIPanelCloseButton");
		frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		frame.closeButton:SetWidth(20);
		frame.closeButton:SetHeight(20);
		frame.closeButton:SetFrameLevel(3);
		frame.closeButton:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
		frame.closeButton:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	end
	frame.fs = frame:CreateFontString("$parentFS", "MEDIUM");
	frame.fs:SetJustifyH("LEFT");
	frame.fs:SetFontObject(NRC_Game14Font);
	frame.fs:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -30);
	frame.fs2 = frame:CreateFontString("$parentFS2", "MEDIUM");
	frame.fs2:SetJustifyH("LEFT");
	frame.fs2:SetFont(NRC.regionFont, 13);
	frame.fs2:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -50);
	return frame;
end

function NRC:createTalentFrame(name, width, height, x, y, borderSpacing)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	if (borderSpacing) then
		frame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", frame, "BackdropTemplate");
		frame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		frame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		frame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		frame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 2, bottom = 2, right = 2},
		});
		frame.borderFrame:SetBackdrop({
			--edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-FullTopRight",
			tileEdge = true,
			edgeSize = 16,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		frame:SetBackdropColor(0, 0, 0, 0.8);
	else
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
			edgeFile = [[Interface/Buttons/WHITE8X8]], 
			edgeSize = 4,
		});
		frame:SetBackdropColor(0, 0, 0, 0.8);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
	end
	--frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetToplevel(true);
	frame:SetSize(width, height);
	frame:SetFrameStrata("MEDIUM");
	frame:SetFrameLevel(10);
	if (x and y) then
		frame:SetPoint("TOP", UIParent, "CENTER", x, y);
	end
	frame.fs = frame:CreateFontString("$parentFS", "HIGH");
	frame.fs:SetPoint("TOPLEFT", 5, -5);
	frame.fs:SetFontObject(Game11Font);
	frame.fs2 = frame:CreateFontString("$parentFS2", "HIGH");
	frame.fs2:SetPoint("TOP", -6, -3);
	frame.fs2:SetFontObject(NRC_Game14Font);
	frame.fs3 = frame:CreateFontString("$parentFS3", "HIGH");
	frame.fs3:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -3);
	frame.fs3:SetFontObject(Game13Font);
	frame.titleTexture = frame:CreateTexture(nil, nil);
	frame.titleTexture:SetSize(16, 16);
	--frame.titleTexture:SetPoint("LEFT", frame.fs2, "RIGHT", 8, -1.1);
	frame.titleTexture:SetPoint("RIGHT", frame.fs2, "LEFT", -8, -1.1);
	--frame.fs2:SetJustifyH("LEFT");
	frame.fs4 = frame:CreateFontString("$parentFS4", "HIGH");
	frame.fs4:SetPoint("RIGHT", frame.titleTexture, "LEFT", -8, 1.1);
	frame.fs4:SetFontObject(NRC_Game14Font);
	--Click button to be used for whatever, set onclick in the frame data func.
	frame.button = CreateFrame("Button", "$parentButton", frame, "UIPanelButtonTemplate");
	frame.button:SetFrameLevel(15);
	frame.button:SetPoint("LEFT", frame.fs2, "RIGHT", 10, 0);
	frame.button:SetWidth(150);
	frame.button:SetHeight(18);
	frame.button:Hide();
	--Top right X close button.
	frame.closeButton = CreateFrame("Button", "$parentClose", frame, "UIPanelCloseButton");
	frame.closeButton:SetPoint("TOPRIGHT", 3.45, 3.2);
	frame.closeButton:SetWidth(26);
	frame.closeButton:SetHeight(26);
	frame.closeButton:SetFrameLevel(15);
	frame.closeButton:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	local sliceOne, sliceTwo = width * 0.33333, width * 0.66666;
	frame.trees = {};
	frame.trees[1] = CreateFrame("Frame", "$parentTree1", frame, "BackdropTemplate");
	frame.trees[1]:SetPoint("TOPLEFT", 0, -20);
	frame.trees[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", sliceOne, 0);
	local widthMiddle = frame.trees[1]:GetWidth() / 2;
	local heightMiddle = frame.trees[1]:GetHeight() / 2;
	frame.trees[1]:SetBackdrop({
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-FullTopRight",
		tileEdge = true,
		edgeSize = 16,
		insets = {top = 2, left = 2, bottom = 2, right = 2},
	});
	frame.adjustBackground = function(frame, width, height)
		--Most of this function was taken from Talented to fit the background art to the frrame.
		local width = frame:GetWidth();
		local height = frame:GetHeight();
		local texture_height = height / (256+75);
		local texture_width = width / (256+44);
		local wl, wr, ht, hb = texture_width * 256, texture_width * 64, texture_height * 256, texture_height * 128;
		frame.topLeft:SetSize(wl, ht);
		frame.topRight:SetSize(wr, ht);
		frame.bottomLeft:SetSize(wl, hb);
		frame.bottomRight:SetSize(wr, hb);
	end
	--topleft = 256 256
	--topright = 64 256 (44 256)
	--bottomleft = 256 75
	--bottomright = 100 100 (44 75)
	for i = 1, 3 do
		frame.trees[i] = CreateFrame("Frame", "$parentTree" .. i, frame, "BackdropTemplate");
		frame.trees[i]:SetBackdrop({
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-FullTopRight",
			tileEdge = true,
			edgeSize = 16,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		frame.trees[i].topLeft = frame.trees[i]:CreateTexture(frame.trees[i], "BACKGROUND");
		frame.trees[i].topLeft:SetPoint("TOPLEFT");
		frame.trees[i].topLeft:SetSize(300, 600);
		frame.trees[i].topRight = frame.trees[i]:CreateTexture(frame.trees[i], "BACKGROUND");
		frame.trees[i].topRight:SetPoint("TOPLEFT", frame.trees[i].topLeft, "TOPRIGHT");
		frame.trees[i].bottomLeft = frame.trees[i]:CreateTexture(frame.trees[i], "BACKGROUND");
		frame.trees[i].bottomLeft:SetPoint("TOPLEFT", frame.trees[i].topLeft, "BOTTOMLEFT");
		frame.trees[i].bottomRight = frame.trees[i]:CreateTexture(frame.trees[i], "BACKGROUND");
		frame.trees[i].bottomRight:SetPoint("TOPLEFT", frame.trees[i].topLeft, "BOTTOMRIGHT");
		frame.trees[i].fs = frame.trees[i]:CreateFontString("$parentFS", "HIGH");
		frame.trees[i].fs:SetPoint("TOP", 0, -20);
		frame.trees[i].fs:SetFontObject(Game11Font);
		frame.trees[i].titleTexture = frame.trees[i]:CreateTexture(nil, nil);
		frame.trees[i].titleTexture:SetSize(16, 16);
		frame.trees[i].titleTexture:SetPoint("RIGHT", frame.trees[i].fs, "LEFT", -5, -1.5);
	end
	frame.trees[1]:SetPoint("TOPLEFT", 0, -20);
	frame.trees[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", sliceOne, 0);
	frame.trees[2]:SetPoint("TOPLEFT", sliceOne, -20);
	frame.trees[2]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", sliceTwo, 0);
	frame.trees[3]:SetPoint("TOPLEFT", sliceTwo, -20);
	frame.trees[3]:SetPoint("BOTTOMRIGHT", 0, 0);
	
	frame.adjustBackground(frame.trees[1]);
	frame.adjustBackground(frame.trees[2]);
	frame.adjustBackground(frame.trees[3]);
	local offsetX, offsetY = width * 0.062, height * 0.096; --16.730769230769  --10.869565217391
	if (NRC.isWrath) then
		--Squish them together a bit closer to fit all talents in to the frame for wrath.
		--Our wrath talent frame also has a bit more height.
		offsetY = height * 0.0828;
	end
	frame.setClass = function(class, classID)
		local offset = 24;
		local talentData = NRC:getTalentData(class);
		frame.hideAllTalentFrames();
		if (talentData) then
			for tree, treeData in ipairs(talentData) do
				local treeName = treeData.info.name;
				local treeTexture = treeData.info.background;
				local _, treeIcon = NRC.getSpecData(classID, tree);
				local numTalents = treeData.numtalents;
				local talents = treeData.talents;
				if (frame.trees[tree].background) then
					frame.trees[tree].background.topLeft:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-TopLeft");
					frame.trees[tree].background.topRight:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-TopRight");
					frame.trees[tree].background.bottomLeft:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-BottomLeft");
					frame.trees[tree].background.bottomRight:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-BottomRight");
				else
					frame.trees[tree].topLeft:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-TopLeft");
					frame.trees[tree].topRight:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-TopRight");
					frame.trees[tree].bottomLeft:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-BottomLeft");
					frame.trees[tree].bottomRight:SetTexture("Interface\\TalentFrame\\".. treeTexture .."-BottomRight");
				end
				frame.trees[tree].fs:SetText("|cFFFFFF00" .. treeName);
				frame.trees[tree].titleTexture:SetTexture(treeIcon);
				local count = 0;
				for talent, talentData in ipairs(talents) do
					count = count + 1;
					local talentName = talentData.info.name;
					local tooltip  = talentData.info.tips;
					local tooltipValues = talentData.info.tipValues;
					local row = talentData.info.row;
					local column = talentData.info.column;
					local icon = talentData.info.icon;
					local ranks = talentData.info.ranks;
					local x = column * offsetX;
					local y = row * offsetY;
					local talentFrame = frame.getTalentFrame(tree, count);
					talentFrame:SetPoint("TOPLEFT", frame.trees[tree], "TOPLEFT", x, -y);
					talentFrame.texture:SetTexture(icon);
					talentFrame.talentName = talentName;
					talentFrame.tooltip  = tooltip;
					talentFrame.tooltipValues = tooltipValues;
					talentFrame.maxRank = ranks;
					--Talented data structure changed in wrath because talent spells for other classes can be quieried now.
					--If talentRankSpellIds exists then we query the API for tooltips instead of using local db like TBC.
					--talentRankSpellIds exisiting means it's wrath, if it doesn't exist then we assume older expansion and use local db.
					talentFrame.talentRankSpellIds = talentData.info.talentRankSpellIds;
					talentFrame:SetScript("OnEnter", function(self, arg)
						GameTooltip:SetOwner(talentFrame, "ANCHOR_RIGHT");
						GameTooltip:AddLine(talentFrame.talentName, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
						local currentRank, tooltipRank = 0, 1;
						local tooltipRank = 1
						if (talentFrame.currentRank) then
							currentRank = talentFrame.currentRank;
							if (talentFrame.currentRank > 0) then
								tooltipRank = talentFrame.currentRank;
							end
						end
						GameTooltip:AddLine("Rank " .. currentRank .. "/" .. talentFrame.maxRank, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
						if (NRC.isTBC or NRC.isClassic) then
							if (talentFrame.tooltip) then
								if (talentFrame.tooltipValues and talentFrame.tooltipValues[tooltipRank]) then
									local text = string.format(talentFrame.tooltip, unpack(talentFrame.tooltipValues[tooltipRank]));
									GameTooltip:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
									if (currentRank > 0 and currentRank < talentFrame.maxRank) then
										GameTooltip:AddLine("Next Rank " .. currentRank + 1 .. "/" .. talentFrame.maxRank, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true);
										local text = string.format(talentFrame.tooltip, unpack(talentFrame.tooltipValues[tooltipRank + 1]));
										GameTooltip:AddLine(text, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true);
									end
								else
									GameTooltip:AddLine(talentFrame.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
								end
							end
						else
							if (talentFrame.talentRankSpellIds) then
								local spellID = talentFrame.talentRankSpellIds[tooltipRank];
								if (spellID) then
									local spell = Spell:CreateFromSpellID(spellID)
									spell:ContinueOnSpellLoad(function()
										GameTooltip:AddLine(spell:GetSpellDescription(), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
										GameTooltip:Show();
										if (currentRank > 0 and currentRank < talentFrame.maxRank) then
											local spellID = talentFrame.talentRankSpellIds[tooltipRank + 1];
											if (spellID) then
												local spell = Spell:CreateFromSpellID(spellID)
												spell:ContinueOnSpellLoad(function()
													GameTooltip:AddLine("Next Rank " .. currentRank + 1 .. "/" .. talentFrame.maxRank, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true);
													GameTooltip:AddLine(spell:GetSpellDescription(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true);
													GameTooltip:Show();
												end)
											end
										end
									end)
								end
							else
								--GameTooltip:AddLine(talentFrame.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
							end
						end
						GameTooltip:Show();
					end)
					talentFrame:Show();
				end
			end
		end
	end
	--Create table for each tree talent frames.
	frame.talentFrames = {{},{}, {}};
	frame.getTalentFrame = function(tree, count)
		if (not frame.talentFrames[tree][count]) then
			local talentFrame = CreateFrame("Button", "$parentTalentFrame" .. tree .. "-" .. count, frame.trees[tree]);
			talentFrame:SetSize(37, 37);
	
			talentFrame.texture = talentFrame:CreateTexture(nil, "BORDER");
			talentFrame.texture:SetSize(64, 64);
			talentFrame.texture:SetAllPoints(talentFrame);
			
			talentFrame.normalTexture = talentFrame:CreateTexture(talentFrame, "BORDER");
			talentFrame.normalTexture:SetTexture("Interface\\Buttons\\UI-Quickslot2");
			talentFrame.normalTexture:SetSize(64, 64);
			talentFrame.normalTexture:SetPoint("CENTER", 0, -1);
			talentFrame:SetNormalTexture(talentFrame.normalTexture);
			
			talentFrame.pushedTexture = talentFrame:CreateTexture(talentFrame, nil);
			talentFrame.pushedTexture:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress");
			talentFrame.pushedTexture:SetSize(36, 36);
			talentFrame.pushedTexture:SetPoint("CENTER");
			talentFrame:SetPushedTexture(talentFrame.pushedTexture);
			
			talentFrame.highlightTexture = talentFrame:CreateTexture(talentFrame, "HIGHLIGHT");
			talentFrame.highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
			talentFrame.highlightTexture:SetBlendMode("ADD");
			talentFrame.highlightTexture:SetAllPoints();
			talentFrame:SetHighlightTexture(frame.highlightTexture);
			
			talentFrame.outerTexture = talentFrame:CreateTexture(talentFrame, "BACKGROUND");
			talentFrame.outerTexture:SetTexture("Interface\\Buttons\\UI-EmptySlot-White");
			talentFrame.outerTexture:SetSize(66, 66);
			talentFrame.outerTexture:SetPoint("CENTER", 0, -1);
			
			--Thanks to stpain and GuildBook for this part.
			talentFrame.rankTexture = talentFrame:CreateTexture("$parentRankBackground", "OVERLAY");
			talentFrame.rankTexture:SetTexture(136960);
			talentFrame.rankTexture:SetPoint("BOTTOMRIGHT", 16, -16);
			talentFrame.rankTexture:Hide();
			talentFrame.rankFS = talentFrame:CreateFontString("$parentRankText", "OVERLAY", "GameFontNormalSmall");
			talentFrame.rankFS:SetPoint("CENTER", talentFrame.rankTexture, "CENTER", 0, 0);
			talentFrame.rankFS:Hide();
	
			talentFrame:SetScript("OnLeave", function(self, arg)
				GameTooltip:Hide();
			end)
	
			talentFrame:SetScale(0.96);
			frame.talentFrames[tree][count] = talentFrame;
		end
		return frame.talentFrames[tree][count];
	end
	frame.hideAllTalentFrames = function()
		for k, v in pairs(frame.talentFrames) do
			for k, v in pairs(v) do
				v:Hide();
			end
		end
	end
	frame.disableAllTalentFrames = function()
		for k, v in pairs(frame.talentFrames) do
			for k, v in pairs(v) do
				v.texture:SetDesaturated(1);
				v:SetAlpha(0.8);
				v.outerTexture:SetVertexColor(0.65, 0.65, 0.65);
				v.rankTexture:Hide();
				v.rankFS:Hide();
			end
		end
	end
	frame:Hide();
	return frame;
end

function NRC:createTextInputFrame(name, width, height, parent)
	local frame = CreateFrame("Frame", name, parent, "BackdropTemplate");
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetFrameStrata("HIGH");
	--tinsert(UISpecialFrames, name);
	frame:SetSize(width, height);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		--insets = {top = 0, left = 0, bottom = 0, right = 0},
		--edgeFile = [[Interface/Buttons/WHITE8X8]],
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {top = 4, left = 4, bottom = 4, right = 4},
	});
	frame:SetBackdropColor(0, 0, 0, 1);
	frame:SetBackdropBorderColor(1, 1, 1, 1);
	frame.fs = frame:CreateFontString("$parentFS", "MEDIUM");
	frame.fs:SetFontObject(Game11Font);
	frame.fs:SetPoint("TOP", 0, -6);
	frame.closeButton = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1);
	frame.closeButton:SetWidth(26);
	frame.closeButton:SetHeight(26);
	frame.closeButton:SetFrameLevel(15);
	frame.closeButton:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.setButton = CreateFrame("Button", name .. "Set", frame, "NRC_EJButtonTemplate");
	frame.setButton:SetSize(50, 18);
	frame.setButton:SetFrameLevel(15);
	frame.setButton:Hide();
	frame.setButton:SetScript("OnClick", function(self, arg)
		--Set where frame is used.
	end)
	frame.resetButton = CreateFrame("Button", name .. "Reset", frame, "NRC_EJButtonTemplate");
	frame.resetButton:SetSize(50, 18);
	frame.resetButton:SetFrameLevel(15);
	frame.resetButton:Hide();
	frame.resetButton:SetScript("OnClick", function(self, arg)
		--Set where frame is used.
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			frame:SetUserPlaced(false);
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	frame.input = CreateFrame("EditBox", name .. "Input", frame, "InputBoxTemplate");
	frame.input:SetAutoFocus(false);
	frame.input:SetSize(width - 20, 15);
	--frame.input:SetPoint("BOTTOM", frame, "BOTTOM", 2, 10);
	frame.input:SetPoint("LEFT", 15, 0);
	frame.input:SetPoint("RIGHT", -10, 0);
	frame.input:SetPoint("BOTTOM", 0, 10);
	frame.input.OnEscapePressed = function()
		frame.input:ClearFocus();
	end
	frame.input.OnEnterPressed = function()
		--Set where the frame is used.
	end
	frame.input.OnTextChanged = function()
		--Set where the frame is used.
	end
	frame.input:SetScript("OnEscapePressed", frame.input.OnEscapePressed);
	frame.input:SetScript("OnEnterPressed", frame.input.OnEnterPressed);
	frame.input:SetScript("OnTextChanged", frame.OnTextChanged);
	frame:Hide();
	return frame;
end

function NRC:createTextInputFrameLoot(name, width, height, parent)
	local frame = CreateFrame("Frame", name, parent, "BackdropTemplate");
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetFrameStrata("HIGH");
	frame:SetClampedToScreen(true);
	--tinsert(UISpecialFrames, name);
	frame:SetSize(width, height);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		--insets = {top = 0, left = 0, bottom = 0, right = 0},
		--edgeFile = [[Interface/Buttons/WHITE8X8]],
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {top = 4, left = 4, bottom = 4, right = 4},
	});
	frame:SetBackdropColor(0, 0, 0, 1);
	frame:SetBackdropBorderColor(1, 1, 1, 1);
	frame.fs = frame:CreateFontString("$parentFS", "MEDIUM");
	frame.fs:SetFontObject(Game11Font);
	frame.fs:SetPoint("TOP", 0, -6);
	frame.fs2 = frame:CreateFontString("$parentFS2", "MEDIUM");
	frame.fs2:SetFontObject(Game11Font);
	frame.fs2:SetPoint("TOP", 0, -20);
	frame.fs3 = frame:CreateFontString("$parentFS2", "MEDIUM");
	frame.fs3:SetFontObject(Game11Font);
	frame.fs3:SetPoint("TOP", 0, -30);
	frame.closeButton = CreateFrame("Button", name .. "Close", frame, "UIPanelCloseButton");
	frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1);
	frame.closeButton:SetWidth(26);
	frame.closeButton:SetHeight(26);
	frame.closeButton:SetFrameLevel(15);
	frame.closeButton:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.setButton = CreateFrame("Button", name .. "Set", frame, "NRC_EJButtonTemplate");
	frame.setButton:SetSize(50, 18);
	frame.setButton:SetFrameLevel(15);
	frame.setButton:Hide();
	frame.setButton:SetScript("OnClick", function(self, arg)
		--Set where frame is used.
	end)
	frame.resetButton = CreateFrame("Button", name .. "Reset", frame, "NRC_EJButtonTemplate");
	frame.resetButton:SetSize(50, 18);
	frame.resetButton:SetFrameLevel(15);
	frame.resetButton:Hide();
	frame.resetButton:SetScript("OnClick", function(self, arg)
		--Set where frame is used.
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			frame:SetUserPlaced(false);
		end
	end)
	frame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	--[[frame.input = CreateFrame("EditBox", name .. "Input", frame, "InputBoxTemplate");
	frame.input:SetAutoFocus(false);
	frame.input:SetSize(width - 20, 15);
	--frame.input:SetPoint("BOTTOM", frame, "BOTTOM", 2, 10);
	frame.input:SetPoint("LEFT", 15, 0);
	frame.input:SetPoint("RIGHT", -10, 0);
	frame.input:SetPoint("BOTTOM", 0, 10);
	frame.input.OnEscapePressed = function()
		frame.input:ClearFocus();
	end
	frame.input.OnEnterPressed = function()
		--Set where the frame is used.
	end
	frame.input.OnTextChanged = function()
		--Set where the frame is used.
	end
	frame.input:SetScript("OnEscapePressed", frame.input.OnEscapePressed);
	frame.input:SetScript("OnEnterPressed", frame.input.OnEnterPressed);
	frame.input:SetScript("OnTextChanged", frame.OnTextChanged);]]
	
	frame.dropdownMenu = NRC.DDM:Create_UIDropDownMenu("$parentDropdownMenu", frame);
	frame.dropdownMenu:SetPoint("BOTTOM", 0, 28);
	NRC.DDM:UIDropDownMenu_SetWidth(frame.dropdownMenu, width - 80);
		
	frame:Hide();
	return frame;
end

function NRC:createTextInputOnly(name, width, height, parent)
	local frame = CreateFrame("EditBox", name .. "Input", parent, "InputBoxTemplate");
	frame:SetAutoFocus(false);
	frame:SetSize(width, height);
	frame.tooltip = CreateFrame("Frame", "$parentTooltip", frame, "TooltipBorderedFrameTemplate");
	frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, -20);
	frame.tooltip:SetFrameStrata("TOOLTIP");
	frame.tooltip:SetFrameLevel(9);
	frame.tooltip.fs = frame.tooltip:CreateFontString("$parentNRCTooltipFS", "ARTWORK");
	frame.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.tooltip.fs:SetFont(NRC.regionFont, 11);
	frame.tooltip.fs:SetJustifyH("LEFT");
	frame.OnEscapePressed = function()
		frame:ClearFocus();
	end
	frame.OnEnterPressed = function()
		--Set where the frame is used.
	end
	frame.OnTextChanged = function()
		--Set where the frame is used.
	end
	frame.OnEnter = function()
		if (frame.tooltipText) then
			frame.tooltip.fs:SetText(frame.tooltipText);
			frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
			frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
			frame.tooltip:Show();
		end
	end
	frame.OnLeave = function()
		frame.tooltip.fs:SetText("");
		frame.tooltip:SetWidth(0);
		frame.tooltip:SetHeight(0);
		frame.tooltip:Hide();
	end
	frame:SetScript("OnEscapePressed", frame.OnEscapePressed);
	frame:SetScript("OnEnterPressed", frame.OnEnterPressed);
	frame:SetScript("OnTextChanged", frame.OnTextChanged);
	frame:SetScript("OnEnter", frame.OnEnter);
	frame:SetScript("OnLeave", frame.OnLeave);
	frame.resetButton = CreateFrame("Button", name .. "Reset", frame, "NRC_EJButtonTemplate");
	frame.resetButton:SetSize(50, 18);
	--frame.resetButton:SetFrameLevel(15);
	frame.resetButton:Hide();
	frame.resetButton:SetScript("OnClick", function(self, arg)
		--Set where frame is used.
	end)
	frame.fs = frame:CreateFontString("$parentFS", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs:SetFont(NRC.regionFont, 12);
	end
	frame.fs:SetAlpha(0.3);
	frame.fs:SetPoint("LEFT", 5, 0);
	frame.fs:Hide();
	frame.fs2 = frame:CreateFontString("$parentFS2", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs2:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs2:SetFont(NRC.regionFont, 12);
	end
	frame.fs2:SetAlpha(0.5);
	frame.fs2:SetPoint("LEFT", 15, 0);
	frame.fs2:Hide();
	frame.fs3 = frame:CreateFontString("$parentFS3", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs3:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs3:SetFont(NRC.regionFont, 12);
	end
	frame.fs3:SetAlpha(0.5);
	frame.fs3:SetPoint("LEFT", 25, 0);
	frame.fs3:Hide();
	frame.fs4 = frame:CreateFontString("$parentFS4", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs4:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs4:SetFont(NRC.regionFont, 12);
	end
	frame.fs4:SetAlpha(0.5);
	frame.fs4:SetPoint("LEFT", 35, 0);
	frame.fs4:Hide();
	frame.fs5 = frame:CreateFontString("$parentFS5", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs5:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs5:SetFont(NRC.regionFont, 12);
	end
	frame.fs5:SetAlpha(0.5);
	frame.fs5:SetPoint("LEFT", 45, 0);
	frame.fs5:Hide();
	frame.fs6 = frame:CreateFontString("$parentFS6", "MEDIUM");
	if (NRC.regionFontBoldItalic) then
		frame.fs6:SetFont(NRC.regionFontBoldItalic, 12);
	else
		frame.fs6:SetFont(NRC.regionFont, 12);
	end
	frame.fs6:SetAlpha(0.5);
	frame.fs6:SetPoint("LEFT", 55, 0);
	frame.fs6:Hide();
	frame:Hide();
	return frame;
end

function NRC:createAutoScrollingFrame(name, width, height, x, y, lineFrameHeight)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame.defaultX = x;
	frame.defaultY = y;
	frame.firstRun = true;
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetSize(width, height);
	frame:SetPoint("CENTER", UIParent, x or 0, y or 0);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		--edgeFile = [[Interface/Buttons/WHITE8X8]], 
		--edgeSize = 1,
	});
	frame:SetBackdropColor(0, 0, 0, 0.2);
	--frame:SetBackdropBorderColor(1, 1, 1, 0.5);
	
	frame.lineFrames = {};
	frame.lineFrameHeight = lineFrameHeight;
	frame.lineFrameScale = 1;
	frame.lineFrameFont = "NRC Default";
	frame.lineFrameFontSize = lineFrameHeight - 2;
	frame.lineFrameFontOutline = "NONE";
	frame.createLineFrame = function()
		local count = #frame.lineFrames + 1;
		local lineFrame = CreateFrame("Frame", frame:GetName().. "LineFrame" .. count, frame, "BackdropTemplate");
		--[[lineFrame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", lineFrame, "BackdropTemplate");
		local borderSpacing = 2;
		lineFrame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		lineFrame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		lineFrame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		lineFrame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);]]
		--lineFrame.borderFrame:SetBackdrop({
		--	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		--	tileEdge = true,
		--	edgeSize = 16,
		--	insets = {top = 2, left = 2, bottom = 2, right = 2},
		--});
		--lineFrame.borderFrame:Hide();
		lineFrame.count = count;
		--lineFrame:SetToplevel(true);
		--lineFrame:SetMovable(true);
		--lineFrame:EnableMouse(true);
		lineFrame:SetSize(100, frame.lineFrameHeight);
		if (frame.alignment == 1) then
			--Left.
			lineFrame:SetPoint("LEFT", frame, 1, 0);
		elseif (frame.alignment == 2) then
			--Middle.
			lineFrame:SetPoint("CENTER", frame, 0, 0);
		elseif (frame.alignment == 3) then
			--Right.
			lineFrame:SetPoint("RIGHT", frame, -1, 0);
		end
		lineFrame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
			--edgeFile = [[Interface/Buttons/WHITE8X8]], 
			--edgeSize = 1,
		});
		lineFrame:SetBackdropColor(0, 0, 0, 0.4);
		--lineFrame:SetBackdropBorderColor(1, 1, 1, 0.2);
		lineFrame.fs = lineFrame:CreateFontString(frame:GetName().. "LineFrameFS" .. count, "ARTWORK");
		--lineFrame.fs:SetPoint("CENTER", 0, 0);
		--lineFrame.fs:SetFont(NRC.regionFont, lineFrameHeight - 2);
		lineFrame.fs:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), frame.lineFrameFontSize, frame.lineFrameFontOutline);
		lineFrame.fs:SetJustifyH("LEFT");
		lineFrame.texture = lineFrame:CreateTexture(nil, "MEDIUM");
		lineFrame.texture:SetTexture("error");
		lineFrame.texture:SetPoint("LEFT", 0, 0);
		lineFrame.texture:SetSize(frame.lineFrameHeight - 0, frame.lineFrameHeight - 0);
		lineFrame.fs:SetPoint("LEFT", lineFrame.texture, "RIGHT", 2, 0);
		lineFrame:SetScale(frame.lineFrameScale);
		lineFrame:Hide();
		frame.lineFrames[count] = lineFrame;
		return lineFrame;
	end
	frame.getLineFrame = function()
		local lineFrame;
		for k, v in ipairs(frame.lineFrames) do
			if (not v.enabled) then
				lineFrame = v;
			end
		end
		if (lineFrame) then
			return lineFrame;
		else
			return frame.createLineFrame();
		end
	end
	frame.growthDirection = 1; --Down, can be changed in options.
	frame.clearAllPoints = function()
		for k, v in ipairs(frame.lineFrames) do
			v:ClearAllPoints();
		end
	end
	frame.queue = {};
	frame.addLine = function(text, icon)
		local lineFrame = frame.getLineFrame();
		lineFrame.enabled = true;
		local t = {
			text = text,
			icon = icon,
			lineFrame = lineFrame,
			y = 0,
			elapsed = GetTime(),
		};
		lineFrame.fs:SetText(text);
		lineFrame:SetScale(frame.lineFrameScale);
		if (icon) then
			--if there's an icon specified then show the left texture and move the text right to suit.
			lineFrame.texture:SetTexture(icon);
			lineFrame.texture:Show();
			lineFrame.fs:ClearAllPoints();
			lineFrame.fs:SetPoint("LEFT", lineFrame.texture, "RIGHT", 2, 0);
			lineFrame:SetWidth(lineFrame.texture:GetWidth() + lineFrame.fs:GetWidth() + 4);
		else
			--Otherwise hide the texture and move the text left.
			lineFrame.texture:Hide();
			lineFrame.fs:ClearAllPoints();
			lineFrame.fs:SetPoint("LEFT", 0, 0);
			lineFrame:SetWidth(lineFrame.fs:GetWidth() + 4);
		end
		tinsert(frame.queue, 1, t);
		UIFrameFadeIn(lineFrame, 0.1, 0, 1);
		frame.sortLineFrames();
		lineFrame:Show();
	end
	frame.animationSpeed = 50;
	frame.growthDirection = 1;
	frame.alignment = 1;
	frame.updateAnimationSettings = function(growthDirection, animationSpeed, alignment)
		if (growthDirection) then
			frame.growthDirection = growthDirection;
		end
		if (animationSpeed) then
			frame.animationSpeed = animationSpeed;
		end
		if (alignment) then
			frame.alignment = alignment;
		end
		--Points are set again OnUpdate.
		for k, v in pairs(frame.lineFrames) do
			v:ClearAllPoints();
			v:SetScale(frame.lineFrameScale);
			if (frame.alignment == 1) then
				--Left.
				v:SetPoint("LEFT", frame, "LEFT", 1, 0);
			elseif (frame.alignment == 2) then
				--Middle.
				v:SetPoint("CENTER", frame, 0, 0);
			elseif (frame.alignment == 3) then
				--Right.
				v:SetPoint("RIGHT", frame, -1, 0);
			end
			--v.fs:SetFont(NRC.regionFont, lineFrameHeight - 2);
			v.fs:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), frame.lineFrameFontSize, frame.lineFrameFontOutline);
		end
	end
	frame.sortLineFrames = function()
		for k, v in ipairs(frame.queue) do
			--Check if any frames are overlapping.
			local lineFrame = v.lineFrame;
			local elapsed = GetTime() - v.elapsed;
			local offset = elapsed * frame.animationSpeed;
			--Remove if done animating.
			if (v.y >= frame:GetHeight() - frame.lineFrameHeight) then
				lineFrame.enabled = false;
				UIFrameFadeOut(lineFrame, 0.2, 1, 0);
				C_Timer.After(0.1, function()
					lineFrame:Hide();
				end)
				table.remove(frame.queue, k);
			else
				if (frame.growthDirection == 1) then
					--Grow upwards.
					lineFrame:SetPoint("BOTTOM", frame, 0, offset);
				else
					lineFrame:SetPoint("TOP", frame, 0, -offset);
				end
				v.y = offset;
			end
		end
		for k, v in ipairs(frame.queue) do
			--Check if any frames are overlapping.
			local lineFrame = v.lineFrame;
			local last = frame.queue[k - 1];
			if (last) then
				--If too close to the frame near it in the list then shuffle them up/down depending on direction.
				if (frame.growthDirection == 1) then
					if (v.y - last.y < frame.lineFrameHeight) then
						v.y = last.y + frame.lineFrameHeight + 1;
						lineFrame:SetPoint("BOTTOM", frame, 0, v.y);
					end
				else
					if (v.y - last.y < frame.lineFrameHeight) then
						v.y = last.y + frame.lineFrameHeight + 1;
						lineFrame:SetPoint("TOP", frame, 0, -v.y);
					end
				end
			end
		end
	end
	frame:SetScript("OnUpdate", function(self, button)
		frame.sortLineFrames();
	end)
	frame.OnMouseUpFunc = function(self, button)
		if (button == "LeftButton" and frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			if (frame.firstRun) then
				NRC:print("Type /nrc config to lock frames once you're done dragging them.");
			end
			frame.firstRun = nil
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
		end
	end
	frame.OnMouseDownFunc = function(self, button)
		if (button == "LeftButton" and not frame.isMoving) then
			if (not frame.locked) then
				frame:StartMoving();
				frame.isMoving = true;
			end
		end
	end
	frame.OnHideFunc = function(self, button)
		if (frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.firstRun = nil
			frame.isMoving = false;
		end
	end
	frame:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame:SetScript("OnHide", function(self)
		frame.OnHideFunc(frame);
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"], 
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
		frame.firstRun = nil;
	end
	frame.displayTab = CreateFrame("Frame", "$parentDisplayTab", frame, "BackdropTemplate");
	frame.displayTab:SetSize(width, height);
	--frame.displayTab:SetPoint("CENTER", frame, x or 0, y or 0);
	frame.displayTab:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]],
		edgeSize = 1,
	});
	frame.displayTab:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab:SetBackdropBorderColor(1, 1, 1, 1);
	frame.displayTab:SetAllPoints();
	frame.displayTab:SetFrameStrata("HIGH");
	frame.displayTab.fs = frame.displayTab:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.fs:SetPoint("CENTER", 0, 0);
	frame.displayTab.fs:SetFont(NRC.regionFont, frame:GetHeight() - 8);
	frame.displayTab:SetMovable(true);
	frame.displayTab:EnableMouse(true);
	frame.displayTab:SetUserPlaced(false);
	frame.displayTab:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame.displayTab:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame.displayTab:SetScript("OnHide", function(self)
		frame.OnHideFunc(self);
	end)
	frame.displayTab.top = CreateFrame("Frame", "$ParentTop", frame, "BackdropTemplate");
	frame.displayTab.top:SetSize(width - 50, 20);
	frame.displayTab.top:SetPoint("BOTTOM", frame.displayTab, "TOP", 0, -4);
	frame.displayTab.top:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom",
		tileEdge = true,
		edgeSize = 16,
		insets = {top = 5, left = 2, bottom = 5, right = 2},
	});
	frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab.top:SetBackdropBorderColor(1, 1, 1, 0.8);
	frame.displayTab.top:SetFrameStrata("HIGH");
	frame.displayTab.top.fs = frame.displayTab.top:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.top.fs:SetPoint("CENTER", 0, 1);
	frame.displayTab.top.fs:SetFont(NRC.regionFont, 12);
	frame.displayTab.top:SetMovable(true);
	frame.displayTab.top:EnableMouse(true);
	frame.displayTab.top:SetUserPlaced(false);
	frame.displayTab.top:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnHide", function(self)
		frame.OnHideFunc(frame);
	end)
	frame.displayTab:Hide();
	frame.displayTab.top:Hide();
	NRC.framePool[name] = frame;
	return frame;
end

function NRC:createIconFrame(name, width, height, x, y)
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame.defaultX = x;
	frame.defaultY = y;
	frame.firstRun = true;
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetSize(width, height);
	frame:SetPoint("CENTER", UIParent, x or 0, y or 0);
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		--edgeFile = [[Interface/Buttons/WHITE8X8]], 
		--edgeSize = 1,
	});
	frame:SetBackdropColor(0, 0, 0, 0.2);
	--frame:SetBackdropBorderColor(1, 1, 1, 0.5);
	
	frame.fs = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fs:SetPoint("CENTER", 0, 0);
	frame.fs:SetFont(NRC.regionFont, 14);
	frame.fsBottom = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fsBottom:SetPoint("TOP", frame, "BOTTOM", 0, 0);
	frame.fsBottom:SetFont(NRC.regionFont, 14);
	frame.texture = frame:CreateTexture(nil, "BORDER");
	frame.texture:SetAllPoints();
			
	return frame;
end

function NRC:createRaidDataFrame(name, width, height, x, y)
	if (_G[name]) then
		return;
	end
	--The main frame that each line frame will attach to.
	local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate");
	frame:SetFrameLevel(5);
	frame.defaultX = x;
	frame.defaultY = y;
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(false);
	frame:SetSize(width, height);
	frame:SetPoint("CENTER", UIParent, x or 0, y or 0);
	--frame:SetBackdrop({
	--	bgFile = "Interface\\Buttons\\WHITE8x8",
	--	insets = {top = 0, left = 0, bottom = 0, right = 0},
	--	edgeFile = [[Interface/Buttons/WHITE8X8]], 
	--	edgeSize = 1,
	--});
	frame.background = CreateFrame("Frame", name .. "background", frame, "BackdropTemplate");
	--frame.background:SetAllPoints();
	frame.background:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]], 
		edgeSize = 1,
	});
	frame.background:SetBackdropColor(0, 0, 0, 0);
	frame.background:SetBackdropBorderColor(1, 1, 1, 0);
	frame.fs = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fs:SetPoint("CENTER", 0, 0);
	frame.fs:SetFont(NRC.regionFont, frame:GetHeight() - 4);
	frame.fs2 = frame:CreateFontString(frame:GetName().. "FS2", "ARTWORK");
	frame.fs2:SetPoint("CENTER", 0, 0);
	frame.fs2:SetFontObject(NRC_SystemFont15_Outline);
	frame.tooltip = CreateFrame("Frame", frame:GetName() .. "Tooltip", frame, "TooltipBorderedFrameTemplate");
	frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
	frame.tooltip:SetFrameStrata("TOOLTIP");
	frame.tooltip:SetFrameLevel(999);
	frame.tooltip.fs = frame.tooltip:CreateFontString(frame:GetName() .. "NRCTooltipFS", "ARTWORK");
	frame.tooltip.fs:SetPoint("CENTER", 0, 0);
	frame.tooltip.fs:SetFont(NRC.regionFont, 11);
	frame.tooltip.fs:SetJustifyH("LEFT");
	frame.showTooltip = function()
		--Use a function to show tooltip so we can disable showing tooltip if frame isn't being dragged for first install.
		frame.tooltip:Show();
	end
	frame:SetScript("OnEnter", function(self)
		local point = frame:GetPoint();
		frame.tooltip:ClearAllPoints();
		if (point == "TOPRIGHT" or point == "TOPLEFT") then
			frame.tooltip:SetPoint("TOP", frame, "BOTTOM", 0, -2);
		else
			frame.tooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2);
		end
		if (frame.tooltip.fs:GetText() and frame.tooltip.fs:GetText() ~= "") then
			frame.showTooltip();
		end
		if (not frame.firstRun) then
			frame.fs:SetText(label or "");
		end
	end)
	frame:SetScript("OnLeave", function(self)
		frame.tooltip:Hide();
		if (not frame.firstRun) then
			frame.fs:SetText("");
		end
	end)
	frame.tooltip:Hide();
	frame.updateTooltip = function(text)
		frame.tooltip.fs:SetText(text);
		frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
		frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
	end
	frame.OnMouseUpFunc = function(self, button)
		if (button == "LeftButton" and frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
			if (frame.firstRun) then
				NRC:print("Type /nrc config to lock frames once you're done dragging them.");
			end
			frame.firstRun = nil
			frame.hasBeenReset = nil
			frame.showTooltip = function() end;
			frame.tooltip.fs:SetText("");
			frame.fs:SetText("");
			frame.tooltip:Hide();
			--frame.displayTab:Hide();
			if (frame.stopDragFunc) then
				NRC[frame.stopDragFunc]();
			end
		end
	end
	frame.OnMouseDownFunc = function(self, button, shift)
		if (button == "LeftButton" and not frame.isMoving) then
			if (shift or not frame.locked) then
				frame:StartMoving();
				frame.isMoving = true;
			end
		end
	end
	frame.OnHideFunc = function(self, button)
		if (frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			if (frame.stopDragFunc) then
				NRC[frame.stopDragFunc]();
			end
		end
	end
	frame:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame:SetScript("OnHide", function(self)
		frame.OnHideFunc(self);
	end)
	frame.lineFrames = {};
	frame.lineFrameHeight = height;
	frame.lineFrameWidth = width;
	frame.lineFrameFont = "NRC Default";
	frame.lineFrameFontNumbers = "NRC Numbers";
	frame.lineFrameFontSize = height - 1;
	frame.lineFrameFontOutline = "NONE";
	frame.getLineFrame = function(parent, id)
		for k, v in ipairs(frame.lineFrames) do
			--[[if (not v.enabled) then
				v.enabled = true;
				return v;
			end]]
			if (v.count == id) then
				return v;
			end
		end
		local count = #frame.lineFrames + 1;
		local lineFrame = CreateFrame("Frame", parent:GetName().. "LineFrame" .. count, parent, "BackdropTemplate");
		lineFrame.borderFrame = CreateFrame("Frame", "$parentBorderFrame", lineFrame, "BackdropTemplate");
		local borderSpacing = 1;
		lineFrame.borderFrame:SetPoint("TOP", 0, borderSpacing);
		lineFrame.borderFrame:SetPoint("BOTTOM", 0, -borderSpacing);
		lineFrame.borderFrame:SetPoint("LEFT", -borderSpacing, 0);
		lineFrame.borderFrame:SetPoint("RIGHT", borderSpacing, 0);
		lineFrame.borderFrame:SetBackdrop({
			edgeFile = "Interface\\Buttons\\WHITE8x8",
			tileEdge = true,
			edgeSize = 1,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		lineFrame.borderFrame:SetBackdropBorderColor(1, 1, 0, 0.9);
		--lineFrame.castBar.line:SetColorTexture(1, 1, 0, 0.9);
		lineFrame.borderFrame:Hide();
		lineFrame.count = count;
		--lineFrame:SetToplevel(true);
		lineFrame:SetMovable(true);
		lineFrame:EnableMouse(true);
		lineFrame:SetSize(10, 10);
		lineFrame:SetPoint("CENTER", lineFrame:GetParent(), x or 0, y or 0);
		lineFrame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
		});
		lineFrame:SetBackdropColor(0, 0, 0, 0);
		lineFrame.fs = lineFrame:CreateFontString("$parentLineFrameFS", "ARTWORK");
		lineFrame.fs:SetPoint("LEFT", parent.lineFrameHeight + 3, 0);
		lineFrame.fs:SetJustifyH("LEFT");
		lineFrame.fs2 = lineFrame:CreateFontString("$parentLineFrameFS2", "ARTWORK");
		lineFrame.fs2:SetPoint("RIGHT", -2, 0);
		lineFrame.fs2:SetPoint("LEFT", lineFrame, 55, 0);
		lineFrame.fs:SetPoint("RIGHT", lineFrame.fs2, "LEFT", parent.lineFrameHeight - 3, 0);
		--lineFrame.fs:SetFontObject(Game12Font);
		--lineFrame.fs2:SetFont(NRC.regionFont, parent.lineFrameHeight - 1);
		lineFrame.fs2:SetJustifyH("LEFT");
		lineFrame.fs2:SetNonSpaceWrap(false);
		lineFrame.fs3 = lineFrame:CreateFontString("parentLineFrameFS3", "ARTWORK");
		lineFrame.fs3:SetPoint("RIGHT", lineFrame, "LEFT", -10, 0);
		lineFrame.fs3:SetFont(NRC.regionFont, parent.lineFrameHeight - 1);
		lineFrame.fs3:SetJustifyH("RIGHT");
		
		lineFrame.fs:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFontNumbers), frame.lineFrameFontSize, frame.lineFrameFontOutline);
		lineFrame.fs2:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), frame.lineFrameFontSize + 2, frame.lineFrameFontOutline);
		lineFrame.fs3:SetFont(NRC.LSM:Fetch("font", frame.lineFrameFont), frame.lineFrameFontSize + 2, frame.lineFrameFontOutline);
		
		lineFrame.texture = lineFrame:CreateTexture(nil, "MEDIUM");
		lineFrame.texture:SetTexture("error");
		lineFrame.texture:SetPoint("LEFT", 1, 0);
		lineFrame.texture:SetSize(parent.lineFrameHeight - 0, parent.lineFrameHeight - 0);
		lineFrame.tooltip = CreateFrame("Frame", parent:GetName() .. "Tooltip", frame, "TooltipBorderedFrameTemplate");
		lineFrame.tooltip:SetPoint("CENTER", lineFrame, "CENTER", 0, 0);
		lineFrame.tooltip:SetFrameStrata("TOOLTIP");
		lineFrame.tooltip:SetFrameLevel(9);
		lineFrame.tooltip:SetBackdropColor(0, 0, 0, 1);
		lineFrame.tooltip.fs = lineFrame.tooltip:CreateFontString(parent:GetName() .. "NRCTooltipFS", "ARTWORK");
		lineFrame.tooltip.fs:SetPoint("CENTER", 0, 0);
		lineFrame.tooltip.fs:SetFont(NRC.regionFont, 12);
		lineFrame.tooltip.fs:SetJustifyH("LEFT");
		lineFrame.tooltip:SetScript("OnUpdate", function(self)
			--Keep our custom tooltip at the mouse when it moves.
			local scale, x, y = lineFrame.tooltip:GetEffectiveScale(), GetCursorPosition();
			--lineFrame.tooltip:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 2, y / scale);
			--ClearAllPoints() here to try fix an error with resting frames to default pos, should be cleared up later.
			lineFrame.tooltip:ClearAllPoints();
			lineFrame.tooltip:SetPoint("BOTTOM", nil, "BOTTOMLEFT", (x / scale) - 2, (y / scale) + 5);
		end)
		lineFrame.tooltip:Hide();
		lineFrame.updateTooltip = function(text)
			lineFrame.tooltip.fs:SetText(text);
			lineFrame.tooltip:SetWidth(lineFrame.tooltip.fs:GetStringWidth() + 18);
			lineFrame.tooltip:SetHeight(lineFrame.tooltip.fs:GetStringHeight() + 12);
		end
		lineFrame:Show();
		lineFrame:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and IsShiftKeyDown() and not self:GetParent().isMoving) then
				--Still allow shift movement of this frame if locked.
				frame.OnMouseDownFunc(frame, button, true);
			end
		end)
		lineFrame:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and self:GetParent().isMoving) then
				frame.OnMouseUpFunc(frame, button);
			end
		end)
		lineFrame:SetScript("OnHide", function(self)
			if (self:GetParent().isMoving) then
				frame.OnHideFunc(frame);
			end
		end)
		lineFrame:SetScript("OnEnter", function(self)
			lineFrame.tooltip:Show();
		end)
		--The below 2 handlers are pretty messy but they make the frames act like they need to.
		lineFrame:SetScript("OnLeave", function(self)
			if (frame.isSubFrame) then
				--If it's a tooltip style list check we're not hovering over any other frames in the list before hiding.
				--local frames = {frame:GetChildren()};
				local frames = frame.lineFrames;
				local found;
				for k, v in ipairs(frames) do
					if (MouseIsOver(v)) then
						found = true;
					end
				end
				if (not found) then
					frame:Hide();
				end
			end
			lineFrame.tooltip:Hide();
			if (lineFrame.subFrame) then
				lineFrame.subFrame:Hide();
			end
		end)
		lineFrame.tooltip:SetScript("OnHide", function(self)
			if (frame.isSubFrame) then
				--If it's a tooltip style list check we're not hovering over any other frames in the list before hiding.
				local frames = frame.lineFrames;
				local found;
				for k, v in ipairs(frames) do
					--If our mouse isn't over an actual lineframe and not a hidden tooltip.
					--The tooltip may be bigger than the frame and when our mouse leaves it won't close.
					--This fixes that by checking if mouse is over the right frames.
					if (MouseIsOver(v) and not strfind(v:GetName(), "Tooltip")) then
						found = true;
					end
				end
				if (not found) then
					frame:Hide();
				end
			end
		end)
		--lineFrame.spark:SetSize(10, frame.lineFrameHeight);
		--lineFrame.spark:SetVertexColor()
		lineFrame.castBar = CreateFrame("Frame", "$parentSpark", lineFrame, "BackdropTemplate");
		lineFrame.castBar:SetFrameLevel(4);
		lineFrame.castBar:SetAllPoints();
		lineFrame.castBar.line = lineFrame.castBar:CreateTexture(nil, "BACKGROUND");
		lineFrame.castBar.line:SetColorTexture(1, 1, 0, 0.9);
		lineFrame.castBar.line:SetWidth(2);
		lineFrame.castBar.line:SetPoint("TOP");
		lineFrame.castBar.line:SetPoint("BOTTOM");
		--[[lineFrame.castBar.spark = lineFrame.castBar:CreateTexture(nil, "OVERLAY");
		lineFrame.castBar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
		--lineFrame.castBar.spark:SetColorTexture(1, 1, 0, 0.85);
		lineFrame.castBar.spark:SetBlendMode("ADD");
		lineFrame.castBar.spark:SetWidth(20);
		lineFrame.castBar.spark:SetPoint("TOP", lineFrame.castBar.line);
		lineFrame.castBar.spark:SetPoint("BOTTOM", lineFrame.castBar.line);]]
		--lineFrame.castBar.spark:SetPoint("LEFT", lineFrame.castBar.line);
		lineFrame.castStartTime = 0;
		lineFrame.castDuration = 0;
		lineFrame.castBar:Hide();
		lineFrame.castBar:SetScript("OnUpdate", function(self)
			if (GetTime() - lineFrame.castStartTime < lineFrame.castDuration) then
				local percent = ((GetTime() - lineFrame.castStartTime) / lineFrame.castDuration) * 100;
				--Start this much in to the frame, there's usually a texture at the start in the way so start that much in.
				local startOffset = frame.lineFrameHeight + 1;
				local width = lineFrame:GetWidth() - startOffset;
				lineFrame.castBar.line:SetPoint("LEFT", lineFrame, ((percent * width) / 100) + startOffset, 0);
			else
				lineFrame.castBar:Hide();
			end
		end)
		
		--[[lineFrame.arrowFrame = CreateFrame("Frame", "$parentArrowFrame", lineFrame, "BackdropTemplate");
		lineFrame.arrowFrame:SetPoint("TOPLEFT", lineFrame, "TOPRIGHT", 0, 0);
		lineFrame.arrowFrame:SetPoint("BOTTOMLEFT", lineFrame, "BOTTOMRIGHT", 0, 0);
		lineFrame.arrowFrame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},
		});
		lineFrame.arrowFrame:SetBackdropColor(0, 0, 0, 0);
		--lineFrame.castBar.line:SetColorTexture(1, 1, 0, 0.9);
		lineFrame.arrowFrame:SetWidth(28);
		lineFrame.arrowFrame:SetHeight(15);
		--lineFrame.arrowFrame.texture = lineFrame.arrowFrame:CreateTexture(nil, "MEDIUM");
		--lineFrame.arrowFrame.texture:SetPoint("LEFT", frame.titleText2, "RIGHT", 7, 0);
		--lineFrame.arrowFrame.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Yellow-Right-Arrow.tga");
		--lineFrame.arrowFrame.texture:SetAllPoints();
		
		lineFrame.arrowFrame.fs = lineFrame.arrowFrame:CreateFontString("$parentLineFrameFS2", "ARTWORK");
		lineFrame.arrowFrame.fs:SetPoint("LEFT", -2, 0);
		lineFrame.arrowFrame.fs:SetFontObject(Game12Font);
		--lineFrame.arrowFrame.fs:SetText("|cFFFFFF00->");]]
		
		lineFrame.enabled = true;
		tinsert(frame.lineFrames, lineFrame);
		--If we add a update func for size/look etc then update if we create a new frame.
		if (frame.updateLayoutFunc) then
			NRC[frame.updateLayoutFunc]();
		end
		return lineFrame;
	end
	frame.growthDirection = 1; --Down, can be changed in options.
	frame.clearAllPoints = function(parent)
		for k, v in ipairs(frame.lineFrames) do
			v:ClearAllPoints();
		end
	end
	frame.sortLineFrames = function(parent)
		local heightOffset = 0;
		local spacing = 0;
		local growDown = (frame.growthDirection == 1);
		local lastFrame;
		for k, v in ipairs(frame.lineFrames) do
			if (v.enabled) then
				v:SetHeight(frame.lineFrameHeight);
				if (growDown) then
					if (k == 1) then
						v:SetPoint("TOPLEFT");
						frame.background:SetPoint("TOPLEFT", v, "TOPLEFT", -1, 1);
						frame.background:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", 1, -1);
					else
						v:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -3);
						frame.background:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", 1, -1);
					end
				else
					if (k == 1) then
						v:SetPoint("BOTTOMLEFT");
						frame.background:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", 0, 0);
						frame.background:SetPoint("TOPLEFT", v, "TOPLEFT", 0, 0);
					else
						v:SetPoint("BOTTOMLEFT", lastFrame, "TOPLEFT", 0, 3);
						frame.background:SetPoint("TOPLEFT", v, "TOPLEFT", 0, 0);
					end
				end
				v:SetPoint("RIGHT");
				v:Show();
				lastFrame = v;
				v:SetHeight(frame.lineFrameHeight);
			else
				v:ClearAllPoints();
				v:Hide();
			end
		end
		if (not lastFrame) then
			frame.background:Hide();
		elseif (not frame.background:IsShown()) then
			frame.background:Show();
		end
	end
	frame.lastUpdate = 0;
	frame:SetScript("OnUpdate", function(self)
		--Update throddle.
		if (GetTime() - frame.lastUpdate > 1) then
			frame.lastUpdate = GetTime();
			frame:sortLineFrames();
			if (frame.onUpdateFunction) then
				--If we declare an update function for this frame to run when shown.
				NRC[frame.onUpdateFunction]();
			end
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	frame.displayTab = CreateFrame("Frame", "$parentDisplayTab", frame, "BackdropTemplate");
	frame.displayTab:SetSize(width, height);
	--frame.displayTab:SetPoint("CENTER", frame, x or 0, y or 0);
	frame.displayTab:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		edgeFile = [[Interface/Buttons/WHITE8X8]],
		edgeSize = 1,
	});
	frame.displayTab:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab:SetBackdropBorderColor(1, 1, 1, 1);
	frame.displayTab:SetAllPoints();
	frame.displayTab:SetFrameStrata("HIGH");
	frame.displayTab.fs = frame.displayTab:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.fs:SetPoint("CENTER", 0, 0);
	frame.displayTab.fs:SetFont(NRC.regionFont, frame:GetHeight() - 8);
	frame.displayTab:SetMovable(true);
	frame.displayTab:EnableMouse(true);
	frame.displayTab:SetUserPlaced(false);
	frame.displayTab:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(self, button);
	end)
	frame.displayTab:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(self, button);
	end)
	frame.displayTab:SetScript("OnHide", function(self)
		frame.OnHideFunc(self);
	end)
	frame.displayTab.top = CreateFrame("Frame", "$ParentTop", frame, "BackdropTemplate");
	frame.displayTab.top:SetSize(width - 50, 20);
	frame.displayTab.top:SetPoint("BOTTOM", frame.displayTab, "TOP", 0, -4);
	frame.displayTab.top:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom",
		tileEdge = true,
		edgeSize = 16,
		insets = {top = 5, left = 2, bottom = 5, right = 2},
	});
	frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
	frame.displayTab.top:SetBackdropBorderColor(1, 1, 1, 0.8);
	frame.displayTab.top:SetFrameStrata("HIGH");
	frame.displayTab.top.fs = frame.displayTab.top:CreateFontString("$parentFS", "ARTWORK");
	frame.displayTab.top.fs:SetPoint("CENTER", 0, 1);
	frame.displayTab.top.fs:SetFont(NRC.regionFont, 12);
	frame.displayTab.top:SetMovable(true);
	frame.displayTab.top:EnableMouse(true);
	frame.displayTab.top:SetUserPlaced(false);
	frame.displayTab.top:SetScript("OnMouseDown", function(self, button)
		frame.OnMouseDownFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnMouseUp", function(self, button)
		frame.OnMouseUpFunc(frame, button);
	end)
	frame.displayTab.top:SetScript("OnHide", function(self)
		frame.OnHideFunc(frame);
	end)
	frame.displayTab:Hide();
	frame.displayTab.top:Hide();
	--frame.displayTab.fs:SetJustifyH("LEFT");
	frame.updateDimensions = function(parent)
		local width = frame.lineFrameWidth;
		local height = frame.lineFrameHeight;
		local textureHeight = height;
		if (textureHeight > 15) then
			textureHeight = 15;
		end
		for k, v in ipairs(frame.lineFrames) do
			v:SetWidth(width);
			v:SetHeight(height);
			v.texture:SetSize(textureHeight, textureHeight);
		end
		frame:SetSize(width, height);
		frame.displayTab:SetSize(width, height);
	end
	NRC.framePool[name] = frame;
	return frame;
end

function NRC:createExportFrame(name, width, height, x, y, notSpecialFrames)
	local frame = CreateFrame("ScrollFrame", name, UIParent, "BackdropTemplate,InputScrollFrameTemplate");
	--_G[name .. "Close"]:Hide();
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		--edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		--tileEdge = true,
		--edgeSize = 16,
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	--frame:SetBackdropBorderColor(1, 1, 1, 0.7);
	frame.CharCount:Hide();
	frame.EditBox:SetFont(NRC.regionFont, 14);
	frame:SetToplevel(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetFrameLevel(5);
	if (not notSpecialFrames) then
		tinsert(UISpecialFrames, frame);
	end
	frame:SetPoint("CENTER", UIParent, x, y);
	frame:SetSize(width, height);
	frame:SetFrameStrata("HIGH");
	frame.EditBox:SetWidth(width - 15);
	
	frame.topFrame = CreateFrame("Frame", "$parentTopFrame", frame, "BackdropTemplate");
	frame.topFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 2, left = 2, bottom = 18, right = 2},
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom",
		tileEdge = true,
		edgeSize = 16,
	});
	frame.topFrame:SetBackdropColor(0, 0, 0, 0.9);
	frame.topFrame:SetBackdropBorderColor(1, 1, 1, 0.7);
	frame.topFrame:SetToplevel(true);
	frame.topFrame:EnableMouse(true);
	frame.topFrame:SetWidth(width + 12);
	frame.topFrame:SetHeight(100);
	frame.topFrame:SetPoint("BOTTOM", frame, "TOP", 0, -13);
	frame.topFrame:SetFrameLevel(4);
	frame.topFrame.fs = frame.topFrame:CreateFontString("$parentFS", "HIGH");
	frame.topFrame.fs:SetPoint("TOP", -10, -4);
	frame.topFrame.fs:SetFont(NRC.regionFont, 15);
	--Click button to be used for whatever, set onclick in the frame data func.
	frame.topFrame.button = CreateFrame("Button", "$parentButton", frame.topFrame, "UIPanelButtonTemplate");
	frame.topFrame.button:SetFrameLevel(15);
	frame.topFrame.button:SetPoint("TOPRIGHT", frame.topFrame, "TOPRIGHT", -34, -42);
	frame.topFrame.button:SetWidth(200);
	frame.topFrame.button:SetHeight(22);
	frame.topFrame.button:Hide();
	frame.topFrame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not frame.isMoving) then
			--frame.EditBox:ClearFocus();
			frame:StartMoving();
			frame.isMoving = true;
			--frame:SetUserPlaced(false);
		end
	end)
	frame.topFrame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			frame:SetUserPlaced(false);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
		end
	end)
	frame.topFrame:SetScript("OnHide", function(self)
		if (frame.isMoving) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
		end
	end)
	if (NRC.db.global[frame:GetName() .. "_point"]) then
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
	end
	
	for i = 1, 5 do
		local checkbox = CreateFrame("CheckButton", "$parentCheckbox" .. i, frame.topFrame, "ChatConfigCheckButtonTemplate");
		checkbox.Text:SetFont(NRC.regionFont, 13);
		checkbox.Text:SetPoint("LEFT", checkbox, "RIGHT", 0, 0);
		checkbox:SetWidth(23);
		checkbox:SetHeight(23);
		checkbox:SetHitRectInsets(0, 0, -10, 7);
		--Create a more compact tooltip, must be named tooltip2 because tooltip gets overwritten by the frame.
		checkbox.tooltip2 = CreateFrame("Frame", "$parentCheckboxTooltip", frame.checkbox, "TooltipBorderedFrameTemplate");
		checkbox.tooltip2:SetFrameStrata("TOOLTIP");
		checkbox.tooltip2:SetFrameLevel(9);
		checkbox.tooltip2:SetPoint("RIGHT", frame.checkbox, "LEFT", -2, 0);
		checkbox.tooltip2.fs = checkbox.tooltip2:CreateFontString("$parentCheckboxTooltipFS", "ARTWORK");
		checkbox.tooltip2.fs:SetPoint("CENTER", 0, 0);
		checkbox.tooltip2.fs:SetFont(NRC.regionFont, 12);
		checkbox.tooltip2:Hide();
		checkbox:SetScript("OnEnter", function(self)
			if (checkbox.tooltip2.fs:GetText() and checkbox.tooltip2.fs:GetText() ~= "") then
				checkbox.tooltip2:SetWidth(checkbox.tooltip2.fs:GetStringWidth() + 18);
				checkbox.tooltip2:SetHeight(checkbox.tooltip2.fs:GetStringHeight() + 12);
				checkbox.tooltip2:Show();
			end
		end)
		checkbox:SetScript("OnLeave", function(self)
			checkbox.tooltip2:Hide();
		end)
		--checkbox.scrollChild.checkbox:SetFrameLevel(6); --One level above the dropdown menu so they can be close together.
		checkbox:Hide();
		frame["checkbox" .. i] = checkbox;
	end
	
	for i = 1, 1 do
		local dropdownMenu = NRC.DDM:Create_UIDropDownMenu("$parentDropdownMenu" .. i, frame.topFrame);
		dropdownMenu.tooltip = CreateFrame("Frame", "$parentDropdownMenuTooltip", dropdownMenu, "TooltipBorderedFrameTemplate");
		dropdownMenu.tooltip:SetFrameStrata("TOOLTIP");
		dropdownMenu.tooltip:SetFrameLevel(9);
		dropdownMenu.tooltip:SetPoint("RIGHT", dropdownMenu, "LEFT", 0, 0);
		dropdownMenu.tooltip.fs = dropdownMenu.tooltip:CreateFontString("$parentDropdownMenuTooltipFS", "ARTWORK");
		dropdownMenu.tooltip.fs:SetPoint("CENTER", 0, 0);
		dropdownMenu.tooltip.fs:SetFont(NRC.regionFont, 12);
		dropdownMenu:HookScript("OnEnter", function(self)
			dropdownMenu.tooltip:Show();
		end)
		dropdownMenu:HookScript("OnLeave", function(self)
			dropdownMenu.tooltip:Hide();
		end)
		--NRC.DDM:UIDropDownMenu_SetWidth(dropdownMenu, 100);
		dropdownMenu.tooltip:Hide();
		frame["dropdownMenu" .. i] = dropdownMenu;
	end
	
	frame:SetClampedToScreen(true);
	frame.topFrame:SetClampedToScreen(true);
	
	--Top right X close button.
	frame.close = CreateFrame("Button", name .. "Close", frame.topFrame, "UIPanelCloseButton");
	frame.close:SetPoint("TOPRIGHT", -3, -3);
	frame.close:SetWidth(20);
	frame.close:SetHeight(20);
	frame.close:SetFrameLevel(5);
	frame.close:SetScript("OnClick", function(self, arg)
		frame:Hide();
	end)
	frame.close:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	frame.close:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	
	frame:Hide();
	return frame;
end

function NRC:createStaticPopupAttachment(name, width, height, x, y, notSpecialFrames)
	local frame = CreateFrame("ScrollFrame", name, UIParent, "BackdropTemplate");
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 13, left = 3, bottom = 3, right = 3},
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoTop",
		tileEdge = true,
		edgeSize = 16,
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	frame:SetBackdropBorderColor(1, 1, 1, 0.7);
	frame:SetSize(width, height);
	frame:EnableMouse(false);
	frame.fs = frame:CreateFontString(frame:GetName().. "FS", "ARTWORK");
	frame.fs:SetPoint("TOPLEFT", 6, -17);
	frame.fs:SetFont(NRC.regionFont, 8);
	frame.fs2 = frame:CreateFontString(frame:GetName().. "FS2", "ARTWORK");
	frame.fs2:SetPoint("BOTTOM", 0, 7);
	frame.fs2:SetFont(NRC.regionFont, 13);
	
	frame:Hide();
	return frame;
end