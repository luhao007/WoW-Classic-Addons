----------------------------------
---NovaRaidCompanion Raid Status--
----------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local raidStatusFrame;
local flaskSlot, foodSlot, scrollSlot, intSlot, fortSlot, spiritSlot, shadowSlot, motwSlot, palSlot, duraSlot;
local armorSlot, holyResSlot, fireResSlot, natureResSlot, frostResSlot, shadowResSlot, arcaneResSlot, weaponEnchantsSlot, talentsSlot;
local slotCount, lastRaidRequest, lastDuraRequest, columCount = 0, 0, 0, 0;
local readyCheckStatus, readyCheckRunning, readyCheckEndedTimer, readyCheckEndedTimer2 = {};
local fadeOutTimer;
local InCombatLockdown = InCombatLockdown;

local f = CreateFrame("Frame", "NRCRaidStatus");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("PLAYER_DEAD");
f:RegisterEvent("UPDATE_INVENTORY_DURABILITY");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("READY_CHECK");
f:RegisterEvent("READY_CHECK_CONFIRM");
f:RegisterEvent("READY_CHECK_FINISHED");
f:RegisterEvent("PLAYER_REGEN_DISABLED");
--f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "GROUP_JOINED" or event == "GROUP_FORMED") then
		if (raidStatusFrame and raidStatusFrame:IsShown()) then
			NRC:updateRaidStatusFrames(true);
		end
	elseif (event == "PLAYER_DEAD") then
		C_Timer.After(1, function()
			NRC:sendDuraThroddled();
		end)
	elseif (event == "UPDATE_INVENTORY_DURABILITY") then
		NRC:updateMyDura();
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isLogon, isReload = ...;
		if (isLogon or isReload) then
			NRC:updateMyDura();
		end
	elseif (event == "READY_CHECK") then
		local startedBy = ...;
		readyCheckStatus = {};
		if (startedBy == UnitName("player")) then
			readyCheckStatus[UnitName("player")] = true; 
		end
		if (readyCheckEndedTimer) then
			readyCheckEndedTimer:Cancel();
			readyCheckEndedTimer = nil;
		end
		if (readyCheckEndedTimer2) then
			readyCheckEndedTimer2:Cancel();
			readyCheckEndedTimer2 = nil;
		end
		readyCheckRunning = true;
		if (NRC.config.raidStatusShowReadyCheck) then
			NRC:openRaidStatusFrame(true);
			if (ReadyCheckListenerFrame) then
				ReadyCheckListenerFrame:SetFrameLevel(30);
			end
		end
		NRC:updateRaidStatusReadyCheckStatus();
	elseif (event == "READY_CHECK_CONFIRM") then
		local unit, isReady = ...;
		local name = UnitName(unit);
		readyCheckStatus[name] = isReady;
		NRC:updateRaidStatusReadyCheckStatus();
	elseif (event == "READY_CHECK_FINISHED") then
		readyCheckEndedTimer = C_Timer.NewTimer(4, function()
			readyCheckRunning = nil;
			readyCheckEndedTimer = nil;
			NRC:updateRaidStatusReadyCheckStatus();
		end)
		if (NRC.config.raidStatusFadeReadyCheck) then
			if (raidStatusFrame and raidStatusFrame:IsShown()) then
				readyCheckEndedTimer2 = C_Timer.NewTimer(4, function()
					if (raidStatusFrame and raidStatusFrame:IsShown()) then
						UIFrameFadeOut(raidStatusFrame, 1, 1, 0);
						fadeOutTimer = C_Timer.NewTimer(1, function()
							raidStatusFrame:Hide();
							raidStatusFrame:SetAlpha(1);
							fadeOutTimer = nil;
							NRC:updateRaidStatusReadyCheckStatus();
						end)
					end
				end)
			end
		end
		NRC:updateRaidStatusReadyCheckStatus();
	elseif (event == "PLAYER_REGEN_DISABLED") then
		if (NRC.config.raidStatusHideCombat and raidStatusFrame) then
			raidStatusFrame:Hide();
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		if (raidStatusFrame and raidStatusFrame:IsShown()) then
			NRC:updateRaidStatusFrames(true);
			NRC:updateRaidStatusReadyCheckStatus();
		end
	end
end)

function NRC:updateRaidStatusReadyCheckStatus()
	if (raidStatusFrame and raidStatusFrame:IsShown()) then
		NRC:updateRaidStatusFrames();
		if (readyCheckRunning) then
			for k, v in pairs(raidStatusFrame.subFrames) do
				if (v.readyCheckTexture and v.name) then
					local name = v.name;
					if (readyCheckStatus[v.name] == true) then
						v.readyCheckTexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready");
					elseif (readyCheckStatus[v.name] == false) then
						v.readyCheckTexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
					else
						if (readyCheckEndedTimer) then
							--If ready check ended.
							v.readyCheckTexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
						else
							v.readyCheckTexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting");
						end
					end
					v.fs:SetPoint("LEFT", 17, 0);
				end
			end
		elseif (not fadeOutTimer) then
			for k, v in pairs(raidStatusFrame.subFrames) do
				if (v.readyCheckTexture) then
					v.readyCheckTexture:SetTexture();
					v.fs:SetPoint("LEFT", 5, 0);
				end
			end
		end
	end
end

function NRC:updateRaidStatusButtonText()
	if (raidStatusFrame) then
		if (raidStatusFrame.showRes) then
			raidStatusFrame.button:SetText(L["Less"]);
			raidStatusFrame.button.arrowRight:Hide();
			raidStatusFrame.button.arrowLeft:Show();
		else
			raidStatusFrame.button:SetText(L["More"]);
			raidStatusFrame.button.arrowLeft:Hide();
			raidStatusFrame.button.arrowRight:Show();
		end
	end
end

function NRC:updateRaidStatusGroupColors()
	if (not raidStatusFrame) then
		return;
	end
	if (NRC.config.sortRaidStatusByGroupsColor) then
		local groupColors = {
			"FFFF00", --Yellow.
			"FFA500", --Orange.
			"00FF00", --Lime.
			"FF00FF", --Fuchsia.
			"00FFFF", --Cyan.
			"FF0000", --Red.
			"0000FF", --Blue.
			"008080", --Teal.
			--"000000", --Black.
			--"FFFFFF", --White.
			--"008080", --Teal.
			--"800000", --Maroon.
			--"800080", --Purple.
			--"EE82EE", --Violet.
		};
		for i = 1, 8 do
			local frame = raidStatusFrame.groupFrames[i];
			local r, g, b = NRC:HexToRGBPerc(groupColors[i]);
			if (NRC.config.sortRaidStatusByGroupsColorBackground) then
				frame:SetBackdropColor(r, g, b, 0.1);
			else
				frame:SetBackdropColor(0, 0, 0, 0);
			end
			frame:SetBackdropBorderColor(r, g, b, 1);
			frame.bg:SetBackdropColor(r, g, b, 0.5);
		end
	else
		for i = 1, 8 do
			local frame = raidStatusFrame.groupFrames[i];
			frame:SetBackdropColor(0, 0, 0, 0);
			frame:SetBackdropBorderColor(1, 1, 1, 1);
			frame.bg:SetBackdropColor(0, 0, 0, 0.9);
		end
	end
end

--Create the intial frames at load time.
function NRC:loadRaidStatusFrames()
	if (not raidStatusFrame) then
		raidStatusFrame = NRC:createGridFrame("NRCRaidStatusFrame", 500, 300, 0, 300, 3);
		raidStatusFrame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 2, bottom = 2, right = 2},
		});
		raidStatusFrame.borderFrame:SetBackdrop({
			--edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-FullTopRight",
			tileEdge = true,
			edgeSize = 16,
			insets = {top = 2, left = 2, bottom = 2, right = 2},
		});
		raidStatusFrame.borderFrame:SetFrameLevel(10);
		raidStatusFrame.button:HookScript("OnShow", function(self)
			if (fadeOutTimer) then
				fadeOutTimer:Cancel();
				fadeOutTimer = nil;
			end
			if (UIFrameIsFading(raidStatusFrame)) then
				--Overwrite fade out so it cancels.
				UIFrameFadeOut(raidStatusFrame, 0.1, 1, 1);
			end
			raidStatusFrame:SetAlpha(1);
			NRC:updateRaidStatusReadyCheckStatus();
		end)
		raidStatusFrame.groupFrames = {};
		for i = 1, 8 do
			local frame = CreateFrame("Frame", "$parentGroupFrame" .. i, raidStatusFrame, "BackdropTemplate");
			frame:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8x8",
				insets = {top = 2, left = 2, bottom = 2, right = 2},
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
				edgeSize = 8,
			});
			frame.bg = CreateFrame("Frame", "$parentGroupFrameBG" .. i, frame, "BackdropTemplate");
			frame.bg:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8x8",
				insets = {top = 2, left = 2, bottom = 2, right = 2},
			});
			--local r, g, b = NRC:HexToRGBPerc(groupColors[i]);
			--frame:SetBackdropColor(r, g, b, 0.1);
			--frame:SetBackdropBorderColor(r, g, b, 1);
			--frame.bg:SetBackdropColor(r, g, b, 0.5);
			frame.bg:SetWidth(20);
			frame.bg:SetPoint("TOPLEFT", 1, -1);
			frame.bg:SetPoint("BOTTOMLEFT", 1, 0.5);
			frame.bg.fs = frame.bg:CreateFontString("$parentNRCTooltipFS", "ARTWORK");
			frame.bg.fs:SetPoint("CENTER", 0, 0);
			frame.bg.fs:SetFont(NRC.regionFont, 12);
			frame:Hide();
			raidStatusFrame.groupFrames[i] = frame;
		end
		NRC:updateRaidStatusFramesLayout();
	end
	raidStatusFrame:SetBackdropColor(0, 0, 0, 0.9);
	--raidStatusFrame:SetBackdropBorderColor(1, 1, 1, 0.7);
	raidStatusFrame.descFrame:SetBackdropColor(0, 0, 0, 0.9);
	raidStatusFrame.descFrame:SetBackdropBorderColor(1, 1, 1, 0.7);
	--raidStatusFrame.descFrame:ClearAllPoints();
	--raidStatusFrame.descFrame:SetPoint("BOTTOM", raidStatusFrame, "TOP", 0, 0);
	raidStatusFrame.updateGridData(NRC:createRaidStatusData(true), true);
	raidStatusFrame.onUpdateFunction = "updateRaidStatusFrames";
	tinsert(UISpecialFrames, "NRCRaidStatusFrame");
	raidStatusFrame:HookScript("OnHide", function(self)
		--raidStatusFrame.showRes = nil;
		raidStatusFrame.lastbuttonID = nil;
	end)
	raidStatusFrame.topRight = CreateFrame("Frame", "NRCRaidStatusFrameTopRight", raidStatusFrame, "BackdropTemplate");
	raidStatusFrame.topRight:SetPoint("BOTTOMRIGHT", raidStatusFrame, "TOPRIGHT", 0, -13);
	raidStatusFrame.topRight:SetSize(150.5, 30);
	raidStatusFrame.topRight:SetFrameLevel(9);
	raidStatusFrame.topRight.borderFrame = CreateFrame("Frame", "$parentBorderFrame", raidStatusFrame.topRight, "BackdropTemplate");
	raidStatusFrame.topRight.borderFrame:SetFrameLevel(9);
	raidStatusFrame.topRight.borderFrame:SetPoint("TOP", 0, 3);
	raidStatusFrame.topRight.borderFrame:SetPoint("BOTTOM", 0, -3);
	raidStatusFrame.topRight.borderFrame:SetPoint("LEFT", -2, 0);
	raidStatusFrame.topRight.borderFrame:SetPoint("RIGHT", 3, 0);
	raidStatusFrame.topRight:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 2, left = 2, bottom = 2, right = 2},
	});
	raidStatusFrame.topRight.borderFrame:SetBackdrop({
		edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom",
		tileEdge = true,
		edgeSize = 16,
		insets = {top = 2, left = 2, bottom = -10, right = 2},
	});
	raidStatusFrame.topRight:SetBackdropColor(0, 0, 0, 0.9);
	raidStatusFrame.closeButton:SetPoint("TOPRIGHT", raidStatusFrame.topRight, 3.45, 3.8);
	raidStatusFrame.closeButton:SetSize(24, 24);
	--raidStatusFrame.button:SetPoint("TOPLEFT", raidStatusFrame.topRight, 14, 0);
	--raidStatusFrame.button:SetPoint("TOPRIGHT", raidStatusFrame.topRight, -36, 0);
	raidStatusFrame.button:SetPoint("TOPRIGHT", raidStatusFrame.topRight, -31, 0);
	raidStatusFrame.button:SetWidth(50);
	raidStatusFrame.button:SetHeight(15);
	raidStatusFrame.button:SetScale(1);
	raidStatusFrame.button:SetText("Expand");
	raidStatusFrame.button:Show();
	
	raidStatusFrame.button.arrowRight = CreateFrame("Frame", "$parentArrowRight", raidStatusFrame.button);
	raidStatusFrame.button.arrowRight:SetPoint("RIGHT", 5, -1);
	raidStatusFrame.button.arrowRight:SetSize(16, 16);
	raidStatusFrame.button.arrowRight.texture = raidStatusFrame.button.arrowRight:CreateTexture("$parentArrowRightTex", "OVERLAY");
	raidStatusFrame.button.arrowRight.texture:SetAllPoints();
	raidStatusFrame.button.arrowRight.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Right-Arrow");
	raidStatusFrame.button.arrowRight:Hide();
	
	raidStatusFrame.button.arrowLeft = CreateFrame("Frame", "$parentArrowLeft", raidStatusFrame.button);
	raidStatusFrame.button.arrowLeft:SetPoint("Left", -5, -1);
	raidStatusFrame.button.arrowLeft:SetSize(16, 16);
	raidStatusFrame.button.arrowLeft.texture = raidStatusFrame.button.arrowLeft:CreateTexture("$parentArrowLeftTex", "OVERLAY");
	raidStatusFrame.button.arrowLeft.texture:SetAllPoints();
	raidStatusFrame.button.arrowLeft.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Left-Arrow");
	raidStatusFrame.button.arrowLeft:Hide();
	raidStatusFrame.button:SetScript("OnClick", function(self, arg)
		if (raidStatusFrame.showRes) then
			raidStatusFrame.showRes = nil;
		else
			raidStatusFrame.showRes = true;
		end
		NRC:updateRaidStatusFrames(true);
		NRC:updateRaidStatusButtonText();
	end)
	raidStatusFrame.button.tooltip = CreateFrame("Frame", "$parentTooltip", raidStatusFrame.button, "TooltipBorderedFrameTemplate");
	raidStatusFrame.button.tooltip:SetPoint("BOTTOM", raidStatusFrame.button, "TOP", 0, 2);
	raidStatusFrame.button.tooltip:SetFrameStrata("TOOLTIP");
	raidStatusFrame.button.tooltip:SetFrameLevel(9);
	raidStatusFrame.button.tooltip.fs = raidStatusFrame.button.tooltip:CreateFontString("$parentNRCTooltipFS", "ARTWORK");
	raidStatusFrame.button.tooltip.fs:SetPoint("CENTER", 0, 0);
	raidStatusFrame.button.tooltip.fs:SetFont(NRC.regionFont, 12);
	raidStatusFrame.button.tooltip.fs:SetJustifyH("LEFT");
	raidStatusFrame.button.tooltip.fs:SetText(L["raidStatusExpandTooltip"]);
	raidStatusFrame.button:SetScript("OnEnter", function(self)
		if (raidStatusFrame.button.tooltip.fs:GetText() and raidStatusFrame.button.tooltip.fs:GetText() ~= "") then
			raidStatusFrame.button.tooltip:SetWidth(raidStatusFrame.button.tooltip.fs:GetStringWidth() + 18);
			raidStatusFrame.button.tooltip:SetHeight(raidStatusFrame.button.tooltip.fs:GetStringHeight() + 12);
			raidStatusFrame.button.tooltip:Show();
		end
	end)
	raidStatusFrame.button:SetScript("OnLeave", function(self)
		raidStatusFrame.button.tooltip:Hide();
	end)
	raidStatusFrame.checkbox = CreateFrame("CheckButton", "NRCRaidStatusFrameCheckbox", raidStatusFrame, "ChatConfigCheckButtonTemplate");
	raidStatusFrame.checkbox.Text:SetText(L["Groups"]);
	raidStatusFrame.checkbox.Text:SetFont(NRC.regionFont, 11);
	raidStatusFrame.checkbox.Text:SetPoint("LEFT", raidStatusFrame.checkbox, "RIGHT", -2, 1);
	raidStatusFrame.checkbox.tooltip = L["sortByGroupsTooltip"];
	raidStatusFrame.checkbox:SetFrameStrata("HIGH");
	raidStatusFrame.checkbox:SetFrameLevel(9);
	raidStatusFrame.checkbox:SetWidth(20);
	raidStatusFrame.checkbox:SetHeight(20);
	raidStatusFrame.checkbox:SetPoint("TOPRIGHT", raidStatusFrame.topRight, -130, 2);
	raidStatusFrame.checkbox:SetHitRectInsets(0, 0, -10, 7);
	--raidStatusFrame.checkbox:SetBackdropBorderColor(0, 0, 0, 1);
	raidStatusFrame.checkbox:SetChecked(NRC.config.sortRaidStatusByGroups);
	raidStatusFrame.checkbox:SetScript("OnClick", function()
		local value = raidStatusFrame.checkbox:GetChecked();
		NRC.config.sortRaidStatusByGroups = value;
		NRC:updateRaidStatusFrames(true);
		--NRC.acr:NotifyChange("NovaRaidCompanion");
	end);
	NRC:updateRaidStatusGroupColors();
	NRC:setRaidStatusSize();
	raidStatusFrame:Hide();
end

function NRC:reloadRaidStatusFrames()
	if (not raidStatusFrame) then
		return;
	end
	raidStatusFrame.updateGridData(NRC:createRaidStatusData(true), true);
	NRC:updateRaidStatusFrames(true);
end

function NRC:setRaidStatusSize()
	if (raidStatusFrame) then
		raidStatusFrame:SetScale(NRC.db.global.raidStatusScale);
	end
end

function NRC:updateRaidStatusFramesLayout()
	raidStatusFrame.subFrameFont = NRC.db.global.raidStatusFont;
	raidStatusFrame.subFrameFontSize = NRC.db.global.raidStatusFontSize;
	--raidStatusFrame.subFrameFontOutline = NRC.db.global.raidStatusFontOutline;
	for k, v in pairs(raidStatusFrame.subFrames) do
		v.fs:SetFont(NRC.LSM:Fetch("font", raidStatusFrame.subFrameFont), raidStatusFrame.subFrameFontSize, raidStatusFrame.subFrameFontOutline);
	end
end

local int, fort, spirit, shadow, motw, pal, weaponEnchants = {}, {}, {}, {}, {}, {}, {};
for k, v in pairs(NRC.int) do
	int[k] = v;
end
NRC.int = nil;
for k, v in pairs(NRC.fort) do
	fort[k] = v;
end
NRC.fort = nil;
for k, v in pairs(NRC.spirit) do
	spirit[k] = v;
end
NRC.spirit = nil;
for k, v in pairs(NRC.shadow) do
	shadow[k] = v;
end
NRC.shadow = nil;
for k, v in pairs(NRC.motw) do
	motw[k] = v;
end
NRC.motw = nil;
for k, v in pairs(NRC.pal) do
	pal[k] = v;
end
NRC.pal = nil;
for k, v in pairs(NRC.tempEnchants) do
	weaponEnchants[k] = v;
end
NRC.tempEnchants = nil;

--These are actual "Food" buff you get while eating, these are from buff food so the raid status can display when a player is eating.
local validFoods = {};
if (NRC.isWrath) then
	validFoods = {
		--Remove TBC foods after prepatch.
		[33258] = "Food", --30 stam 20 spirit.
		[33269] = "Food", --44 healing 20 spirit.
		[33264] = "Food", --23 SP 20 spirit.
		[33260] = "Food", --40 AP 20 spirit.
		[33262] = "Food", --20 agi 20 spirit.
		[43763] = "Food", --20 hit 20 spirit.
		[33255] = "Food", --20 str 20 spirit.
		[43706] = "Drink", --20 crit 20 spirit.
		[33266] = "Food", --20 stam 8MP5.
		[45618] = "Food", --8 resistances.
		[43730] = "Electrified", --Zap nearby enemies.
		--Wrath.
		[57292] = "Refreshment", --Attack Power increased by 60, Spell Power increased by 35 and Stamina increased by 30.
		[58067] = "Refreshment", --Attack Power increased by 60, Spell Power increased by 35 and Stamina increased by 30.
		[57398] = "Refreshment", --Attack Power increased by 80, Spell Power increased by 46 and Stamina increased by 40.
		[69560] = "Brewfest Drink", --Resilience rating and Stamina increased by 40.
		[65363] = "Brewfest Drink", --Critical strike rating increased by 40.
		[69561] = "Brewfest Drink", --Critical strike rating increased by 40.
		[59227] = "Refreshment", --You are covered in eel oil!  On the bright side, at least your dodge rating has increased by 40. 
		[64056] = "Food", --Attack power increased by 24 and spell power increased by 14.
		[57110] = "Refreshment", --Attack Power increased by 60 and Stamina increased by 30.
		[58503] = "Refreshment", --Attack Power increased by 60 and Stamina increased by 30. (or this is just a human form buff?)
		[57085] = "Refreshment", --Attack Power increased by 60 and Stamina increased by 40.
		[57324] = "Refreshment", --Attack Power increased by 80 and Stamina increased by 40.
		[57335] = "Refreshment", --Attack Power increased by 80 and Stamina increased by 40.
		[57138] = "Refreshment", --Spell Power increased by 35 and Stamina increased by 30.
		[57096] = "Refreshment", --Spell Power increased by 35 and Stamina increased by 40.
		[57326] = "Refreshment", --Spell Power increased by 46 and Stamina increased by 40.
		[57341] = "Refreshment", --Spell Power increased by 46 and Stamina increased by 40.
		[57287] = "Refreshment", --Haste Rating increased by 30 and Stamina increased by 30.
		[57101] = "Refreshment", --Haste Rating increased by 30 and Stamina increased by 40.
		[57331] = "Refreshment", --Haste Rating increased by 40 and Stamina increased by 40.
		[57344] = "Refreshment", --Haste Rating increased by 40 and Stamina increased by 40.
		[62351] = "Refreshment", --Hit rating increased by 30 and Stamina increased by 40.
		[57359] = "Refreshment", --Hit Rating increased by 40 and Stamina increased by 40.
		[57285] = "Refreshment", --Critical Rating increased by 30 and Stamina increased by 30.
		[57098] = "Refreshment", --Critical Strike Rating increased by 30 and Stamina increased by 40.
		[57328] = "Refreshment", --Critical Strike Rating increased by 40 and Stamina increased by 40.
		[57343] = "Refreshment", --Critical Strike Rating increased by 40 and Stamina increased by 40.
		[57357] = "Refreshment", --Armor penetration rating increased by 40 and Stamina increased by 40.
		[57370] = "Refreshment", --Strength increased by 40 and Stamina increased by 40.
		[57355] = "Refreshment", --Expertise Rating increased by 40 and Stamina increased by 40.
		[57366] = "Refreshment", --Agility increased by 40 and Stamina increased by 40.
		[53283] = "Food", --Stamina and Spirit increased by 25.
		[57364] = "Refreshment", --Spirit increased by 40 and Stamina increased by 40.
		[57106] = "Refreshment", --Mana Regeneration increased by 15 every 5 seconds and Stamina increased by 40.
		[57289] = "Refreshment", --Mana Regeneration increased by 15 every 5 seconds and Stamina increased by 30.
		[57333] = "Refreshment", --Mana Regeneration increased by 20 every 5 seconds and Stamina increased by 40.
		[57354] = "Refreshment", --Mana Regeneration increased by 20 every 5 seconds and Stamina increased by 40.
	};
elseif (NRC.isTBC) then
	validFoods = {
		[33258] = "Food", --30 stam 20 spirit.
		[33269] = "Food", --44 healing 20 spirit.
		[33264] = "Food", --23 SP 20 spirit.
		[33260] = "Food", --40 AP 20 spirit.
		[33262] = "Food", --20 agi 20 spirit.
		[43763] = "Food", --20 hit 20 spirit.
		[33255] = "Food", --20 str 20 spirit.
		[43706] = "Drink", --20 crit 20 spirit.
		[33266] = "Food", --20 stam 8MP5.
		[45618] = "Food", --8 resistances.
		[43730] = "Electrified", --Zap nearby enemies.
	}
else
	validFoods = { --Refine classic era foods here later.
		[33258] = "Food", --30 stam 20 spirit.
		[33269] = "Food", --44 healing 20 spirit.
		[33264] = "Food", --23 SP 20 spirit.
		[33260] = "Food", --40 AP 20 spirit.
		[33262] = "Food", --20 agi 20 spirit.
		[43763] = "Food", --20 hit 20 spirit.
		[33255] = "Food", --20 str 20 spirit.
		[43706] = "Drink", --20 crit 20 spirit.
		[33266] = "Food", --20 stam 8MP5.
		[45618] = "Food", --8 resistances.
		[43730] = "Electrified", --Zap nearby enemies.
	}
end

--Future notes.
--[[if (wrath) then
	--If higher expansion remove max rank notes.
	for k, v in pairs(NRC.flasks) do
		v.maxRank = nil;
	end
	--Insert next expansion spells here.
end]]

function NRC:openRaidStatusFrame(showOnly, fromLog, buttonID)
	if (not fromLog) then
		NRC.raidStatusCache = nil;
	end
	if (not raidStatusFrame) then
		NRC:loadRaidStatusFrames();
	end
	if (not raidStatusFrame:IsShown() or fromLog) then
		if (buttonID and buttonID == raidStatusFrame.lastbuttonID) then
			--If we click the same button in raid log again then hide instead.
			raidStatusFrame.lastbuttonID = nil;
			raidStatusFrame:Hide();
		else
			if (fromLog) then
				--Make frame rise to the top.
				raidStatusFrame:Hide();
			end
			if (NRC.config.raidStatusExpandAlways) then
				raidStatusFrame.showRes = true;
			end
			raidStatusFrame:Show();
			raidStatusFrame.lastbuttonID = buttonID;
			NRC:updateRaidStatusFrames(true);
			if (GetServerTime() - lastRaidRequest > 20 and not fromLog) then
				lastRaidRequest = GetServerTime();
				NRC:requestRaidData();
			end
		end
	elseif (not showOnly) then
		raidStatusFrame.lastbuttonID = nil;
		raidStatusFrame:Hide();
		--raidStatusFrame.showRes = nil;
	end
	NRC:updateRaidStatusReadyCheckStatus();
end

local function updateGridTooltip(frame, localBuffData, buffData)
	local tooltipText = "";
	if (localBuffData.rank) then
		tooltipText = tooltipText .. tooltipText .. "|cFFDEDE42" .. buffData.name .. "|r |cFF9CD6DE(Rank " .. localBuffData.rank .. ")|r";
	else
		tooltipText = tooltipText .. "|cFFDEDE42" .. buffData.name .. "|r";
	end
	if (localBuffData.desc) then
		tooltipText = tooltipText .. "\n|cFF9CD6DE" .. localBuffData.desc .. "|r";
	end
	if (not NRC.raidStatusCache) then
		if (buffData.endTime and buffData.endTime > GetServerTime()) then
				tooltipText = tooltipText .. "\n" .. NRC:getShortTime(buffData.endTime - GetServerTime()) .. "|r";
		else
			tooltipText = tooltipText .. "\nDuration unknown (out of range?)|r";
		end
		if (buffData.source) then
			tooltipText = tooltipText .. " |cFFFF6900Cast by " .. buffData.source .. "|r";
		end
	else
		if (buffData.source) then
			tooltipText = tooltipText .. "\n|cFFFF6900Cast by " .. buffData.source .. "|r";
		end
	end
	if (not localBuffData.maxRank) then
		tooltipText = tooltipText .. "\n|cFFFF0000Not Max Rank|r";
	end
	frame.updateTooltip(tooltipText);
end

local function updateGridTooltipTalents(frame, name, classHex, talentCount, specName, specIcon, treeData)
	local nameString = "|c" .. classHex .. name .. "|r";
	local tooltipText = "|cFFDEDE42" .. nameString .. "|r";
	if (specName and specIcon) then
		tooltipText = tooltipText .. "\n|cFFDEDE42" .. specName .. "|r";
	end
	if (treeData) then
		tooltipText = tooltipText .. "\n|cFF9CD6DE" .. treeData[1] .. " / " .. treeData[2] .. " / " .. treeData[3] .. "|r";
	end
	tooltipText = tooltipText .. "\n|cFFFFAE42-Click To View Talents-|r";
	frame.updateTooltip(tooltipText);
end

local function updateGridTooltipRes(frame, name, classHex, type, amount)
	local nameString = "|c" .. classHex .. name .. "|r";
	local tooltipText = "|cFFDEDE42" .. nameString .. "|r";
	if (type and amount) then
		tooltipText = tooltipText .. "\n" .. type .. " " .. amount .. "|r";
	else
		tooltipText = tooltipText .. "\n|cFF9CD6DEUnknown.|r";
	end
	frame.updateTooltip(tooltipText);
end

local function getMultipleIconsTooltip(buffData)
	local tooltipText = "";
	if (buffData.rank) then
		tooltipText = tooltipText .. tooltipText .. "|cFFDEDE42" .. buffData.name .. "|r |cFF9CD6DE(Rank " .. buffData.rank .. ")|r";
	else
		if (NRC.scrolls[buffData.buffID]) then
			tooltipText = tooltipText .. "|cFFDEDE42" .. NRC.scrolls[buffData.buffID].name .. "|r";
		else
			tooltipText = tooltipText .. "|cFFDEDE42" .. buffData.name .. "|r";
		end
	end
	if (buffData.desc and buffData.desc ~= "") then
		tooltipText = tooltipText .. "\n|cFF9CD6DE" .. buffData.desc .. "|r";
	end
	if (not NRC.raidStatusCache) then
		if (buffData.endTime and buffData.endTime > GetServerTime()) then
				tooltipText = tooltipText .. "\nDuration: " .. NRC:getShortTime(buffData.endTime - GetServerTime()) .. "|r";
		else
			tooltipText = tooltipText .. "\nDuration unknown (out of range?)|r";
		end
		--if (buffData.endTime) then
		--	tooltipText = tooltipText .. "\n" .. NRC:getShortTime(buffData.endTime - GetServerTime()) .. "|r";
		--end
		if (buffData.source) then
			tooltipText = tooltipText .. " |cFFFF6900Cast by " .. buffData.source .. "|r";
		end
	else
		if (buffData.source) then
			tooltipText = tooltipText .. "\n|cFFFF6900Cast by " .. buffData.source .. "|r";
		end
	end
	if (not buffData.maxRank) then
		tooltipText = tooltipText .. "\n|cFFFF0000Not Max Rank|r";
	end
	return tooltipText;
end

local function updateCharacterTooltip(frame, name, charData, auras)
	local _, _, _, classHex = GetClassColor(charData.class);
	local tooltipText = "|c" .. classHex .. name .. "|r";
	local zone = charData.zone or charData.lastKnownZone;
	if (zone) then
		tooltipText = tooltipText .. "\n|cFF9CD6DE" .. zone .. "|r";
	end
	if (charData.level) then
		tooltipText = tooltipText .. "\n|cFFFFFF00" .. charData.level .. "|r";
	end
	if (not charData.online and not NRC.raidStatusCache) then
		tooltipText = tooltipText .. "\n|cFF989898(Offline)|r";
	end
	local found;
	local count = 0;
	if (auras) then
		tooltipText = tooltipText .. "\n";
		for k, v in pairs(auras) do
			count = count + 1;
			found = true;
			tooltipText = tooltipText .. "|T" .. v.icon .. ":16:16|t";
			if (math.fmod(count, 6) == 0) then
				tooltipText = tooltipText .. "\n";
			end
		end
	end
	--Remove any trailing newline if buff counts matches exactly 6/12 etc.
	--tooltipText = string.gsub(tooltipText, "\n$", "");
	if (charData) then
		frame.updateTooltip(tooltipText);
	else
		frame.updateTooltip();
	end
	if (not InCombatLockdown()) then
		frame:SetAttribute("macrotext", "/target " .. name);
	end
end

local function updateDuraTooltip(frame, name, class, coloredDura, broken)
	local _, _, _, classHex = GetClassColor(class);
	local tooltipText = "|c" .. classHex .. name .. "|r";
	tooltipText = tooltipText .. "\n|cFF9CD6DEDurability:|r " .. (coloredDura or "Error");
	if (broken and broken > 0) then
		broken = "|cFFFF2222" .. broken .. "|r";
	end
	tooltipText = tooltipText .. "\n|cFF9CD6DEBroken items:|r " .. (broken or 0);
	frame.updateTooltip(tooltipText);
end

local function colorizeRes(res)
	local color = "|cFF00C800";
	if (res < 1) then
		color = "|cFFFF2222";
	--elseif (res < 100) then
		--color = "|cFF9CD6DE";
		--color = "|cFFFFFFFF";
	elseif (res < 200) then
		--color = "|cFFDEDE42";
		color = "|cFFDEDE42";
	--elseif (res < 300) then
	--	color = "|cFFDEDE42";
	end
	return color .. res .. "|r";
end

function NRC:updateRaidStatusFrames(updateLayout)
	local data = NRC:createRaidStatusData(updateLayout);
	if (updateLayout) then
		raidStatusFrame.updateGridData(data, updateLayout);
		for i = 1, 20 do
			if (raidStatusFrame.subFrames and raidStatusFrame.subFrames["a" .. i]) then
				local tooltipText;
				if (data.columns[i] and data.columns[i].tooltip) then
					tooltipText = data.columns[i].tooltip;
				end
				--Add tooltip if it's an icon, or clear tooltip if it's not so shift drag can be added.
				raidStatusFrame.subFrames["a" .. i].updateTooltip(tooltipText);
			end
		end
		local tooltipText = "Hold shift to drag";
		--No tooltip for the last 2 slots near the close button.
		for i = 1, slotCount - 2 do
			if (raidStatusFrame.subFrames and raidStatusFrame.subFrames["a" .. i] and not data.columns[i].tooltip) then
				raidStatusFrame.subFrames["a" .. i].updateTooltip(tooltipText);
				raidStatusFrame.subFrames["a" .. i].tooltip:SetPoint("BOTTOM", raidStatusFrame, "TOP", 0, 0);
			end
		end
		--Update resistances button.
		NRC:updateRaidStatusButtonText();
		for i = 1, 8 do
			raidStatusFrame.groupFrames[i]:Hide();
		end
		columCount = #data.columns;
	end
	if (data) then
		local columnCount, maxColumnCount = 0, raidStatusFrame.maxColumnCount;
		local rowCount, maxRowCount = 1, raidStatusFrame.maxRowCount;
		local gridCount = maxColumnCount * maxRowCount;
		--local gridName = string.char(96 + rowCount) .. columnCount;
		local count = 0;
		local subGroups;
		if (data.chars and next(data.chars)) then
			if (NRC.config.sortRaidStatusByGroups) then
				subGroups = {};
				--Check to make sure all members have a subgroup.
				--This also helps with viewing snapshots before recording of subgroups were added.
				for k, v in pairs(data.chars) do
					if (not v.subGroup) then
						subGroups = nil;
					end
				end
				if (subGroups) then
					table.sort(data.chars, function(a, b) return a.subGroup < b.subGroup end);
				else
					table.sort(data.chars, function(a, b) return a.name < b.name end);
				end
			else
				table.sort(data.chars, function(a, b) return a.name < b.name end);
			end
			local usedGroupframes = {};
			for k, v in ipairs(data.chars) do
				local name = v.name;
				count = count + 1;
				rowCount = rowCount + 1;
				local rowName = string.char(96 + rowCount);
				local _, _, _, classHex = GetClassColor(v.class);
				local nameString;
				if (not v.online and not NRC.raidStatusCache) then
					if (subGroups or readyCheckRunning or readyCheckEndedTimer or fadeOutTimer) then
						nameString = "|c" .. classHex .. strsub(name, 1, 6) .. "|r |cFF989898(Offline)|r";
					else
						nameString = count .. ". |c" .. classHex .. strsub(name, 1, 6) .. "|r |cFF989898(Offline)|r";
					end
				else
					if (subGroups or readyCheckRunning or readyCheckEndedTimer or fadeOutTimer) then
						nameString = "|c" .. classHex .. strsub(name, 1, 15) .. "|r";
					else
						nameString = count .. ". |c" .. classHex .. strsub(name, 1, 15) .. "|r";
					end
				end
				if (not raidStatusFrame.subFrames[rowName .. "1"]) then
					--Sometimes bug that happens when joining a group, just delay until the next tick 1 second later.
					return;
				end
				raidStatusFrame.subFrames[rowName .. "1"].fs:SetText(nameString);
				raidStatusFrame.subFrames[rowName .. "1"].name = name;
				if (subGroups) then
					local frame = raidStatusFrame.groupFrames[v.subGroup];
					if (not usedGroupframes[v.subGroup]) then
						frame:SetPoint("TOPRIGHT", raidStatusFrame.subFrames[rowName .. columCount], "TOPRIGHT", 0, 0.6);
						frame:SetPoint("TOPLEFT", raidStatusFrame.subFrames[rowName .. "1"], "TOPLEFT", -20, 0.6);
						frame:SetPoint("BOTTOMRIGHT", raidStatusFrame.subFrames[rowName .. columCount], "BOTTOMRIGHT", 0, -0.6);
						frame:SetPoint("BOTTOMLEFT", raidStatusFrame.subFrames[rowName .. "1"], "BOTTOMLEFT", -20, -0.6);
						frame.bg.fs:SetText("G" .. v.subGroup);
						frame:Show();
						usedGroupframes[v.subGroup] = true;
					else
						frame:SetPoint("BOTTOMRIGHT", raidStatusFrame.subFrames[rowName .. columCount], "BOTTOMRIGHT", 0, -0.6);
						frame:SetPoint("BOTTOMLEFT", raidStatusFrame.subFrames[rowName .. "1"], "BOTTOMLEFT", -20, -0.6);
					end
				end
				local hasFlask, hasBattle, hasGuardian, hasScroll, hasFood, hasInt, hasFort, hasSpirit, hasShadow, hasMotw, hasPal
				local hasWeaponEnchant, hasTalents, auras;
				if (NRC.raidStatusCache) then
					auras = NRC.raidStatusCache.auraCache[v.guid];
				else
					auras = NRC.auraCache[v.guid];
				end
				local elixirs, pallyBuffs, scrollBuffs, enchantBuffs = {}, {}, {}, {};
				local eating;
				if (auras and next(auras) and (v.online or NRC.raidStatusCache)) then
					for buffID, buffData in pairs(auras) do
						if (flaskSlot and NRC.flasks[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. flaskSlot];
							frame.fs:SetText("");
							--frame.fs2:SetText("");
							frame.texture:ClearAllPoints();
							frame.texture2:ClearAllPoints();
							frame.texture2:SetTexture();
							frame.texture:SetPoint("CENTER", 0, 0);
							frame.texture:SetTexture(NRC.flasks[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasFlask = true;
							updateGridTooltip(frame, NRC.flasks[buffID], buffData);
							if (not NRC.flasks[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						elseif (flaskSlot) then
							if (NRC.battleElixirs[buffID]) then
								elixirs[1] = buffData;
								elixirs[1].buffID = buffID;
								hasFlask = true;
							end
							if (NRC.guardianElixirs[buffID]) then
								elixirs[2] = buffData;
								elixirs[2].buffID = buffID;
								hasFlask = true;
							end
						end
						if (scrollSlot and NRC.scrolls[buffID]) then
							tinsert(scrollBuffs, buffData);
							--Merge some db data with our player auras data.
							scrollBuffs[#scrollBuffs].buffID = buffID;
							scrollBuffs[#scrollBuffs].icon = NRC.scrolls[buffID].icon;
							scrollBuffs[#scrollBuffs].rank = NRC.scrolls[buffID].rank;
							scrollBuffs[#scrollBuffs].desc = NRC.scrolls[buffID].desc;
							scrollBuffs[#scrollBuffs].maxRank = NRC.scrolls[buffID].maxRank;
							scrollBuffs[#scrollBuffs].order = NRC.scrolls[buffID].order;
							hasScroll = true;
						end
						if (foodSlot and NRC.foods[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. foodSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(NRC.foods[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasFood = true;
							updateGridTooltip(frame, NRC.foods[buffID], buffData);
							if (not NRC.foods[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						elseif (foodSlot and validFoods[buffID]) then
							eating = buffData.endTime or 0;
						end
						if (intSlot and int[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. intSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(int[buffID].icon);
							frame.texture:SetSize(15, 15);
							hasInt = true;
							updateGridTooltip(frame, int[buffID], buffData);
							if (not int[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						end
						if (fortSlot and fort[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. fortSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(fort[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasFort = true;
							updateGridTooltip(frame, fort[buffID], buffData);
							if (not fort[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						end
						if (spiritSlot and spirit[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. spiritSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(spirit[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasSpirit = true;
							updateGridTooltip(frame, spirit[buffID], buffData);
							if (not spirit[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						end
						if (shadowSlot and shadow[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. shadowSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(shadow[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasShadow = true;
							updateGridTooltip(frame, shadow[buffID], buffData);
							if (not shadow[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						end
						if (motwSlot and motw[buffID]) then
							local frame = raidStatusFrame.subFrames[rowName .. motwSlot];
							frame.fs:SetText("");
							frame.texture:SetTexture(motw[buffID].icon);
							frame.texture:SetSize(16, 16);
							hasMotw = true;
							updateGridTooltip(frame, motw[buffID], buffData);
							if (not motw[buffID].maxRank) then
								frame:SetBackdropColor(1, 0, 0, 0.25);
								frame:SetBackdropBorderColor(1, 0, 0, 0.7);
								frame.red = true;
							else
								frame.red = nil;
								frame:SetBackdropColor(0, 0, 0, 0);
								frame:SetBackdropBorderColor(1, 1, 1, 0);
							end
							if (not InCombatLockdown()) then
								frame:SetAttribute("macrotext", "/target " .. name);
							end
						end
						if (palSlot and pal[buffID]) then
							tinsert(pallyBuffs, buffData);
							--Merge some local data with our player auras data.
							pallyBuffs[#pallyBuffs].buffID = buffID;
							pallyBuffs[#pallyBuffs].icon = pal[buffID].icon;
							pallyBuffs[#pallyBuffs].rank = pal[buffID].rank;
							pallyBuffs[#pallyBuffs].desc = pal[buffID].desc;
							pallyBuffs[#pallyBuffs].maxRank = pal[buffID].maxRank;
							pallyBuffs[#pallyBuffs].order = pal[buffID].order;
							hasPal = true;
						end
					end
				end
				if (duraSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. duraSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					if (NRC.raidStatusCache) then
						local letterCount = count;
						if (count > 27) then
							letterCount = count - 27;
						elseif (count > 18) then
							letterCount = count - 18;
						elseif (count > 9) then
							letterCount = count - 9;
						end
						local letter = strsub("Snapshot ", letterCount, letterCount);
						frame.fs:SetText("|cFFFFFF00" .. letter);
					else
						local data = NRC.durability[name];
						--local data = {};
						--data.percent = math.random(50, 100);
						if (data) then
							local color = "|cFF00C800";
							if (data.percent < 31) then
								color = "|cFFFF2222";
							elseif (data.percent < 70) then
								color = "|cFFDEDE42";
							end
							local coloredDura = color .. data.percent .. "%|r";
							local text = coloredDura;
							if (data.broken and data.broken > 0) then
								text = text .. " |cFFFF0000(" .. data.broken .. ")|r";
							end
							frame.fs:SetText(text);
							updateDuraTooltip(frame, name, v.class, coloredDura, data.broken);
						else
							frame.fs:SetText("--");
							frame.updateTooltip();
						end
					end
				end
				if (shadowResSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. shadowResSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.resCache) then
							data = NRC.raidStatusCache.resCache[name];
						end
					else
						data = NRC.resistances[name];
					end
					if (data) then
						local resString = colorizeRes(data[5]);
						frame.fs:SetText(resString);
						updateGridTooltipRes(frame, name, classHex, "|cffa44aa9Shadow Res:|r", resString);
					elseif (frame) then
						frame.fs:SetText("--");
						frame.updateTooltip();
					end
				end
				if (fireResSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. fireResSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.resCache) then
							data = NRC.raidStatusCache.resCache[name];
						end
					else
						data = NRC.resistances[name];
					end
					if (data) then
						local resString = colorizeRes(data[2]);
						frame.fs:SetText(resString);
						updateGridTooltipRes(frame, name, classHex, "|cffba3434Fire Res:|r", resString);
					elseif (frame) then
						frame.fs:SetText("--");
						frame.updateTooltip();
					end
				end
				if (natureResSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. natureResSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.resCache) then
							data = NRC.raidStatusCache.resCache[name];
						end
					else
						data = NRC.resistances[name];
					end
					if (data) then
						local resString = colorizeRes(data[3]);
						frame.fs:SetText(resString);
						updateGridTooltipRes(frame, name, classHex, "|cff42a229Nature Res:|r", resString);
					elseif (frame) then
						frame.fs:SetText("--");
						frame.updateTooltip();
					end
				end
				if (frostResSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. frostResSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.resCache) then
							data = NRC.raidStatusCache.resCache[name];
						end
					else
						data = NRC.resistances[name];
						frame.updateTooltip();
					end
					if (data) then
						local resString = colorizeRes(data[4]);
						frame.fs:SetText(resString);
						updateGridTooltipRes(frame, name, classHex, "|cff0096FFFrost Res:|r", resString);
					elseif (frame) then
						frame.fs:SetText("--");
					end
				end
				if (arcaneResSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. arcaneResSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.resCache) then
							data = NRC.raidStatusCache.resCache[name];
						end
					else
						data = NRC.resistances[name];
					end
					if (data) then
						local resString = colorizeRes(data[6]);
						frame.fs:SetText(resString);
						updateGridTooltipRes(frame, name, classHex, "|cfff7fbffArcane Res:|r", resString);
					elseif (frame) then
						frame.fs:SetText("--");
						frame.updateTooltip();
					end
				end
				--[[if (armorSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. armorSlot];
					frame.texture:ClearAllPoints();
					frame.texture:SetPoint("CENTER", 0, 0);
					frame.texture:SetTexture();
					frame.texture:SetSize(16, 16);
					local data;
					if (NRC.raidStatusCache) then
						data = NRC.raidStatusCache.resistances[name];
					else
						data = NRC.resistances[name];
					end
					if (data) then
						local color = "|cFFFF2222";
						if (data[0] > 1) then
							color = "|cFF00C800";
						--elseif (data.percent < 70) then
						--	color = "|cFFDEDE42";
						end
						frame.fs:SetText(color .. data[0] .. "|r");
					else
						frame.fs:SetText("--");
						frame.updateTooltip();
					end
				end]]
				if (weaponEnchantsSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. weaponEnchantsSlot];
					local data;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.weaponEnchantCache) then
							data = NRC.raidStatusCache.weaponEnchantCache[name];
						end
					else
						data = NRC.weaponEnchants[name];
					end
					if (data) then
						if (data[1] and (data[2] > GetServerTime() or NRC.raidStatusCache)) then
							--Mainhand.
							if (weaponEnchants[data[1]]) then
								local t = {
									name = weaponEnchants[data[1]].name,
									icon = weaponEnchants[data[1]].icon,
									endTime = data[2],
									maxRank = weaponEnchants[data[1]].maxRank;
									desc = weaponEnchants[data[1]].desc;
									order = 1,
								};
								tinsert(enchantBuffs, t);
								hasWeaponEnchant = true;
								
							else
								NRC:debug("unknown weapon enchant", name, data[1]);
							end
						end
						if (data[3] and (data[4] > GetServerTime() or NRC.raidStatusCache)) then
							--Offhand.
							if (weaponEnchants[data[3]]) then
								local t = {
									name = weaponEnchants[data[3]].name,
									icon = weaponEnchants[data[3]].icon,
									endTime = data[4],
									maxRank = weaponEnchants[data[3]].maxRank;
									desc = weaponEnchants[data[3]].desc;
									order = 2,
								};
								tinsert(enchantBuffs, t);
								hasWeaponEnchant = true;
								
							else
								NRC:debug("unknown weapon2 enchant", data[3]);
							end
						end
					end
					if (frame and not hasWeaponEnchant) then
						frame.updateTooltip();
					end
				end
				if (talentsSlot) then
					local frame = raidStatusFrame.subFrames[rowName .. talentsSlot];
					local talentString;
					if (NRC.raidStatusCache) then
						if (NRC.raidStatusCache.talentCache) then
							talentString = NRC.raidStatusCache.talentCache[name];
							--talentString = NRC:getTalentsFromEncounter(name, NRC.raidStatusCache.logID, NRC.raidStatusCache.encounterID);
						end
					else
						talentString = NRC.talents[name];
					end
					if (talentString) then
						local specID, talentCount, specName, specIcon, specIconPath, treeData = NRC:getSpecFromTalentString(talentString);
						frame.fs:SetText("");
						frame.texture:SetTexture(specIcon);
						frame.texture:SetSize(16, 16);
						hasTalents = true;
						updateGridTooltipTalents(frame, name, classHex, talentCount, specName, specIcon, treeData);
						--We shouldn't have to remove this click onclick handler if the talents colum option is disabled.
						--This is the last column so this column won't be reused for any other type.
						frame:SetScript("OnClick", function(self)
							NRC:openTalentFrame(name, talentString);
						end)
					elseif (frame) then
						frame.fs:SetText("--");
						frame.updateTooltip();
						frame:SetScript("OnClick", function(self)
							
						end)
					end
				end
				if (next(elixirs)) then
					--Sorting for max 2 icons only, and show X in missing slot (elixirs instead of a flask).
					local frame = raidStatusFrame.subFrames[rowName .. flaskSlot];
					frame.fs:SetText("");
					local tooltipText = "";
					if (elixirs[1]) then
						frame.texture:SetPoint("RIGHT", frame, "CENTER", -0.5, 0);
						frame.texture:SetTexture(NRC.battleElixirs[elixirs[1].buffID].icon);
						frame.texture:SetSize(16, 16);
						if (not elixirs[2]) then
							--Has battle but not guardian.
							frame.texture2:SetTexture();
							frame.fs:SetText("|cFFFF0000X|r");
							frame.fs:SetPoint("CENTER", 9, 0);
						end
						tooltipText = tooltipText .. "|cFFFF6900Battle:|r |cFFDEDE42" .. elixirs[1].name .. "|r\n";
						tooltipText = tooltipText .. "|cFF9CD6DE" .. NRC.battleElixirs[elixirs[1].buffID].desc .. "|r\n";
						if (elixirs[1].endTime) then
							tooltipText = tooltipText .. NRC:getShortTime(elixirs[1].endTime - GetServerTime()) .. "|r";
						end
					end
					if (elixirs[2]) then
						frame.texture2:SetPoint("LEFT", frame, "CENTER", 0.5, 0);
						frame.texture2:SetTexture(NRC.guardianElixirs[elixirs[2].buffID].icon);
						frame.texture2:SetSize(16, 16);
						if (not elixirs[1]) then
							--Has guardian but not battle.
							frame.texture:SetTexture();
							frame.fs:SetText("|cFFFF0000X|r");
							frame.fs:SetPoint("CENTER", -9, 0);
						else
							tooltipText = tooltipText .. "\n";
						end
						tooltipText = tooltipText .. "|cFFFF6900Guardian:|r |cFFDEDE42" .. elixirs[2].name .. "|r\n";
						tooltipText = tooltipText .. "|cFF9CD6DE" .. NRC.guardianElixirs[elixirs[2].buffID].desc .. "|r\n";
						if (elixirs[2].endTime) then
							tooltipText = tooltipText .. NRC:getShortTime(elixirs[2].endTime - GetServerTime()) .. "|r";
						end
					end
					frame.updateTooltip(tooltipText);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (next(scrollBuffs)) then
					local frame = raidStatusFrame.subFrames[rowName .. scrollSlot];
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
					NRC:raidStatusSortMultipleIcons(frame, scrollBuffs, 4, true);
				end
				if (next(pallyBuffs)) then
					local frame = raidStatusFrame.subFrames[rowName .. palSlot];
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
					NRC:raidStatusSortMultipleIcons(frame, pallyBuffs, 4, true);
				end
				if (next(enchantBuffs)) then
					local frame = raidStatusFrame.subFrames[rowName .. weaponEnchantsSlot];
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
					NRC:raidStatusSortMultipleIcons(frame, enchantBuffs, 2, true);
				end
				if (flaskSlot and not hasFlask) then
					local frame = raidStatusFrame.subFrames[rowName .. flaskSlot];
					frame.texture:SetTexture();
					frame.texture2:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.fs:SetPoint("CENTER", 0, 0);
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (foodSlot and not hasFood) then
					local frame = raidStatusFrame.subFrames[rowName .. foodSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					if (foodSlot and eating) then
						local eatingString = L["Eating"];
						if (eating > 0 and not LOCALE_koKR and not LOCALE_zhCN and not LOCALE_zhTW) then
							if (not NRC.raidStatusCache) then
								eatingString = eatingString .. " " .. math.floor(eating - GetServerTime()) .. "s";
							end
						end
						frame.fs:SetText(eatingString);
					else
						frame.fs:SetText("|cFFFF0000X|r");
					end
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (scrollSlot and not hasScroll) then
					local frame = raidStatusFrame.subFrames[rowName .. scrollSlot];
					frame.texture:SetTexture();
					frame.texture2:SetTexture();
					frame.texture3:SetTexture();
					frame.texture4:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (intSlot and not hasInt) then
					local frame = raidStatusFrame.subFrames[rowName .. intSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (fortSlot and not hasFort) then
					local frame = raidStatusFrame.subFrames[rowName .. fortSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (spiritSlot and not hasSpirit) then
					local frame = raidStatusFrame.subFrames[rowName .. spiritSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (shadowSlot and not hasShadow) then
					local frame = raidStatusFrame.subFrames[rowName .. shadowSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (motwSlot and not hasMotw) then
					local frame = raidStatusFrame.subFrames[rowName .. motwSlot];
					frame.texture:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (palSlot and not hasPal) then
					local frame = raidStatusFrame.subFrames[rowName .. palSlot];
					frame.texture:SetTexture();
					frame.texture2:SetTexture();
					frame.texture3:SetTexture();
					frame.texture4:SetTexture();
					frame.fs:SetText("|cFFFF0000X|r");
					frame.updateTooltip();
					frame:SetBackdropColor(0, 0, 0, 0);
					frame:SetBackdropBorderColor(1, 1, 1, 0);
					if (not InCombatLockdown()) then
						frame:SetAttribute("macrotext", "/target " .. name);
					end
				end
				if (weaponEnchantsSlot and not hasWeaponEnchant) then
					local frame = raidStatusFrame.subFrames[rowName .. weaponEnchantsSlot];
					--There's a reported lua error here with this frame not existing but I can't reproduce it.
					--Add a check for now, it just happens when the frame is open and someone joins or is moved apparently.
					--I've also added some layout updates with roster_update and an extra one a couple secs later on player join.
					if (frame) then
						frame.texture:SetTexture();
						frame.texture2:SetTexture();
						frame.texture3:SetTexture();
						frame.texture4:SetTexture();
						local fullName;
						if (v.realm) then
							fullName = name .. "-" .. v.realm;
						else
							fullName = name .. "-" .. NRC.realm;
						end
						if (NRC.hasAddon[fullName] or NRC.hasAddonHelper[fullName]) then
							frame.fs:SetText("|cFFFF0000X|r");
						else
							frame.fs:SetText("--");
						end
						frame.updateTooltip();
						frame:SetBackdropColor(0, 0, 0, 0);
						frame:SetBackdropBorderColor(1, 1, 1, 0);
					end
				end
				if (talentsSlot and not hasTalents) then
					local frame = raidStatusFrame.subFrames[rowName .. talentsSlot];
					if (frame) then
						frame.texture:SetTexture();
						frame.texture2:SetTexture();
						frame.texture3:SetTexture();
						frame.texture4:SetTexture();
						local fullName;
						if (v.realm) then
							fullName = name .. "-" .. v.realm;
						else
							fullName = name .. "-" .. NRC.realm;
						end
						if (NRC.hasAddon[fullName] or NRC.hasAddonHelper[fullName]) then
							frame.fs:SetText("|cFFFF0000X|r");
						else
							frame.fs:SetText("--");
						end
						frame.updateTooltip();
						frame:SetBackdropColor(0, 0, 0, 0);
						frame:SetBackdropBorderColor(1, 1, 1, 0);
						frame:SetScript("OnClick", function(self)
							
						end)
					end
				end
				updateCharacterTooltip(raidStatusFrame.subFrames[rowName .. "1"], name, v, auras);
			end
			if (subGroups) then
				for i =1, 8 do
					if (not usedGroupframes[i]) then
						raidStatusFrame.groupFrames[i]:Hide();
					end
				end
			end
		end
	end
	if (NRC.raidStatusCache) then
		local found;
		if (data) then
			local instance = NRC.db.global.instances[data.logID];
			if (instance) then
				local encounterName = NRC.getEncounterNameFromID(data.encounterID, data.logID);
				if (encounterName) then
					local success = "|cFFFF3333Wipe|r";
					if (data.success == 1) then
						success = "|cFF00C800Kill|r";
					end
					raidStatusFrame.descFrame:Show();
					raidStatusFrame.descFrame.fs:SetText("|cFF9CD6DE(Snapshot at Boss Pull)  |cFFFFFF00" ..encounterName .. "|r - " .. success);
					found = true;
				end
			end
		end
		if (not found) then
			raidStatusFrame.descFrame.fs:SetText("Error displaying boss name.");
		end
	else
		raidStatusFrame.descFrame:Hide();
	end
end

function NRC:raidStatusSortMultipleIcons(frame, spellData, maxPossible, checkMaxRank)
	--Sort spells by order.
	local order = true;
	for k, v in pairs(spellData) do
		if (not v.order) then
			order = nil;
		end
	end
	if (order) then
		table.sort(spellData, function(a, b) return a.order < b.order end);
	end
	local tooltipText = "";
	local buffCount = #spellData;
	local missingMaxRank;
	if (buffCount == 1) then
		frame.fs:SetText("");
		frame.texture:ClearAllPoints();
		frame.texture2:ClearAllPoints();
		frame.texture3:ClearAllPoints();
		frame.texture4:ClearAllPoints();
		frame.texture:SetPoint("CENTER", 0, 0);
		frame.texture:SetTexture(spellData[1].icon);
		frame.texture2:SetTexture();
		frame.texture3:SetTexture();
		frame.texture4:SetTexture();
		frame.texture:SetSize(16, 16);
		tooltipText = tooltipText .. getMultipleIconsTooltip(spellData[1]);
		if (not spellData[1].maxRank) then
			missingMaxRank = true;
		end
	elseif (buffCount == 2) then
		frame.fs:SetText("");
		frame.texture:ClearAllPoints();
		frame.texture2:ClearAllPoints();
		frame.texture3:ClearAllPoints();
		frame.texture4:ClearAllPoints();
		frame.texture:SetPoint("CENTER", -8.5, 0);
		frame.texture2:SetPoint("CENTER", 8.5, 0);
		frame.texture:SetTexture(spellData[1].icon);
		frame.texture2:SetTexture(spellData[2].icon);
		frame.texture3:SetTexture();
		frame.texture4:SetTexture();
		frame.texture:SetSize(16, 16);
		frame.texture2:SetSize(16, 16);
		tooltipText = tooltipText .. getMultipleIconsTooltip(spellData[1]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[2]);
		if (not spellData[1].maxRank or not spellData[2].maxRank) then
			missingMaxRank = true;
		end
	elseif (buffCount == 3) then
		frame.fs:SetText("");
		frame.texture:ClearAllPoints();
		frame.texture2:ClearAllPoints();
		frame.texture3:ClearAllPoints();
		frame.texture4:ClearAllPoints();
		frame.texture:SetPoint("RIGHT", frame, "CENTER", -8, 0);
		frame.texture2:SetPoint("CENTER", 0, 0);
		frame.texture3:SetPoint("LEFT", frame, "CENTER", 8, 0);
		frame.texture:SetTexture(spellData[1].icon);
		frame.texture2:SetTexture(spellData[2].icon);
		frame.texture3:SetTexture(spellData[3].icon);
		frame.texture4:SetTexture();
		frame.texture:SetSize(16, 16);
		frame.texture2:SetSize(16, 16);
		frame.texture3:SetSize(16, 16);
		tooltipText = tooltipText .. getMultipleIconsTooltip(spellData[1]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[2]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[3]);
		if (not spellData[1].maxRank or not spellData[2].maxRank or not spellData[3].maxRank) then
			missingMaxRank = true;
		end
	elseif (buffCount == 4) then
		frame.fs:SetText("");
		frame.texture:ClearAllPoints();
		frame.texture2:ClearAllPoints();
		frame.texture3:ClearAllPoints();
		frame.texture4:ClearAllPoints();
		frame.texture:SetPoint("BOTTOMRIGHT", frame, "CENTER", 0, 0);
		frame.texture2:SetPoint("BOTTOMLEFT", frame, "CENTER", 0, 0);
		frame.texture3:SetPoint("TOPRIGHT", frame, "CENTER", 0, 0);
		frame.texture4:SetPoint("TOPLEFT", frame, "CENTER", 0, 0);
		frame.texture:SetTexture(spellData[1].icon);
		frame.texture2:SetTexture(spellData[2].icon);
		frame.texture3:SetTexture(spellData[3].icon);
		frame.texture4:SetTexture(spellData[4].icon);
		frame.texture:SetSize(8, 8);
		frame.texture2:SetSize(8, 8);
		frame.texture3:SetSize(8, 8);
		frame.texture4:SetSize(8, 8);
		tooltipText = tooltipText .. getMultipleIconsTooltip(spellData[1]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[2]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[3]);
		tooltipText = tooltipText .. "\n" .. getMultipleIconsTooltip(spellData[4]);
		if (not spellData[1].maxRank or not spellData[2].maxRank or not spellData[3].maxRank or not spellData[4].maxRank) then
			missingMaxRank = true;
		end
	end
	if (checkMaxRank and missingMaxRank) then
		frame:SetBackdropColor(1, 0, 0, 0.25);
		frame:SetBackdropBorderColor(1, 0, 0, 0.7);
		frame.red = true;
	else
		frame.red = nil;
		frame:SetBackdropColor(0, 0, 0, 0);
		frame:SetBackdropBorderColor(1, 1, 1, 0);
	end
	frame.updateTooltip(tooltipText);
	--if (maxPossible == 2 and count == 1) then
		--If this is a 2 icon slot but only 1 buff then show red X in missing 2nd slot;
	--end
end

local raidStatusShadowRes, raidStatusFireRes, raidStatusNatureRes, raidStatusFrostRes, raidStatusArcaneRes, raidStatusHolyRes, raidStatusArmorRes;
local raidStatusWeaponEnchants, raidStatusTalents;
local function setResColumns()
	raidStatusShadowRes, raidStatusFireRes, raidStatusNatureRes, raidStatusFrostRes, raidStatusArcaneRes, raidStatusHolyRes,
			raidStatusArmorRes, raidStatusWeaponEnchants, raidStatusTalents = nil, nil, nil, nil, nil, nil, nil, nil, nil;
	local config = NRC.config;
	if (config.raidStatusShadowRes) then
		raidStatusShadowRes = true;
	end
	if (config.raidStatusFireRes) then
		raidStatusFireRes = true;
	end
	if (config.raidStatusNatureRes) then
		raidStatusNatureRes = true;
	end
	if (config.raidStatusFrostRes) then
		raidStatusFrostRes = true;
	end
	if (config.raidStatusArcaneRes) then
		raidStatusArcaneRes = true;
	end
	--if (config.raidStatusHolyRes) then
	--	raidStatusHolyRes = true;
	--end
	--if (config.raidStatusArmorRes) then
	--	raidStatusArmorRes = true;
	--end
	if (config.raidStatusWeaponEnchants) then
		raidStatusWeaponEnchants = true;
	end
	if (config.raidStatusTalents) then
		raidStatusTalents = true;
	end
end

local function addChar(v, guid, name)
	--This fixes viewing old snapshots before subgroup was added.
	--if (not v.subgroup) then
	--	v.subgroup = 0;
	--end
	if (NRC.raidStatusCache) then
		return {
			name = name,
			class = v.class,
			guid = guid,
			level = v.level,
			realm = v.realm,
			subGroup = v.subGroup,
			auras = {},
		};
	else
		return {
			name = name,
			class = v.class,
			zone = v.zone,
			lastKnownZone = v.lastKnownZone,
			online = v.online,
			guid = guid,
			level = v.level,
			realm = v.realm,
			subGroup = v.subGroup,
			auras = {},
		};
	end
end

function NRC:createRaidStatusData(updateLayout)
	local data = {};
	data.rows = {};
	data.chars = {};
	if (updateLayout) then
		raidStatusFrame.hideAllRows();
		flaskSlot, foodSlot, scrollSlot, intSlot, fortSlot, spiritSlot = nil, nil, nil, nil, nil, nil;
		shadowSlot, motwSlot, palSlot, duraSlot = nil, nil, nil, nil;
		armorSlot, holyResSlot, fireResSlot, natureResSlot, frostResSlot, shadowResSlot, arcaneResSlot = nil, nil, nil, nil, nil, nil, nil;
		slotCount = 0;
		data.firstH = 25; --Header (first row).
		data.firstV = 100; --Character names (first column).
		data.spacingV = 50;
		data.spacingH = 18;
		data.columns = {
			--Column names, printed in first row (header).
			[1] = {
				name = "|cFFFF6900NRC Raid Status",
			},
		};
		slotCount = slotCount + 1;
		if (NRC.config.raidStatusFlask) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Flask"],
			};
			flaskSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusFood) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Food"],
			};
			foodSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusScroll) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Scroll"],
				};
			scrollSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusInt) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Int"],
			};
			intSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusFort) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Fort"],
			};
			fortSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusSpirit) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Spirit"],
			};
			spiritSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusShadow) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Shadow"],
			};
			shadowSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusMotw) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Motw"],
			};
			motwSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.config.raidStatusPal) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Pal"],
			};
			palSlot = slot;
			slotCount = slotCount + 1;
		end
		if (NRC.raidStatusCache) then
			--Last column is shared between durability and snapshot text.
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = "",
			};
			duraSlot = slot;
			slotCount = slotCount + 1;
		elseif (NRC.config.raidStatusDura) then
			local slot = #data.columns + 1;
			data.columns[slot] = {
				name = L["Durability"],
			};
			duraSlot = slot;
			slotCount = slotCount + 1;
		end
		if (raidStatusFrame.showRes) then
			setResColumns();
			if (raidStatusShadowRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Shadow",
					tex = 136568, --Interface\PaperDollInfoFrame\UI-Character-ResistanceIcons.
					texCoords = {0, 1.0, 0.453125, 0.56640625},
					tooltip = "|cFFDEDE42Shadow Resistance",
				};
				shadowResSlot = slot;
				slotCount = slotCount + 1;
			end
			if (raidStatusFireRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Fire",
					tex = 136568,
					texCoords = {0, 1.0, 0, 0.11328125},
					tooltip = "|cFFDEDE42Fire Resistance",
				};
				fireResSlot = slot;
				slotCount = slotCount + 1;
			end
			if (raidStatusNatureRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Nature",
					tex = 136568,
					texCoords = {0, 1.0, 0.11328125, 0.2265625},
					tooltip = "|cFFDEDE42Nature Resistance",
				};
				natureResSlot = slot;
				slotCount = slotCount + 1;
			end
			if (raidStatusFrostRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Frost",
					tex = 136568,
					texCoords = {0, 1.0, 0.33984375, 0.453125},
					tooltip = "|cFFDEDE42Frost Resistance",
				};
				frostResSlot = slot;
				slotCount = slotCount + 1;
			end
			if (raidStatusArcaneRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Arcane",
					tex = 136568,
					texCoords = {0, 1.0, 0.2265625, 0.33984375},
					tooltip = "|cFFDEDE42Arcane Resistance",
				};
				arcaneResSlot = slot;
				slotCount = slotCount + 1;
			end
			--[[if (raidStatusHolyRes) then --Holy doesn't exist on players? The API exists but there's no gear or textures.
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Holy",
					tex = 136568,
					texCoords = {},
					tooltip = "|cFFDEDE42Holy Resistance",
				};
				holyResSlot = slot;
				slotCount = slotCount + 1;
			end]]
			if (raidStatusWeaponEnchants) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = L["Weapon"],
					tooltip = "|cFFDEDE42Temporary Weapon Enchants",
				};
				weaponEnchantsSlot = slot;
				slotCount = slotCount + 1;
			end
			if (raidStatusTalents) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = L["Talents"],
					tooltip = "|cFFDEDE42Click a players talent icon\nto show full talent tree.",
				};
				talentsSlot = slot;
				slotCount = slotCount + 1;
			end
			--[[if (raidStatusArmorRes) then
				local slot = #data.columns + 1;
				data.columns[slot] = {
					name = "Armor",
				};
				armorSlot = slot;
				slotCount = slotCount + 1;
			end]]
		end
		data.adjustHeight = true;
		data.adjustWidth = true;
	end
	--If we open this from the raid log window then load the cached data instead.
	if (NRC.raidStatusCache) then
		local count = 0;
		data.rows[1] = "Header";
		data.logID = NRC.raidStatusCache.logID;
		data.encounterID = NRC.raidStatusCache.encounterID;
		data.success = NRC.raidStatusCache.success;
		for k, v in pairs(NRC.raidStatusCache.group) do
			local auraCache = NRC.raidStatusCache.auraCache[k];
			if (auraCache) then
				count = count + 1;
				if (count > 60) then
					break;
				end
				data.rows[count + 1] = v.name;
				data.chars[count] = addChar(v, k, v.name);
				for buffID, buffData in NRC:pairsByKeys(auraCache) do
					if (NRC.flasks[buffID]) then
						data.chars[count].flask = buffData;
					end
					if (NRC.foods[buffID]) then
						data.chars[count].food = buffData;
					end
					if (int[buffID]) then
						data.chars[count].int = buffData;
					end
					if (fort[buffID]) then
						data.chars[count].fort = buffData;
					end
					if (spirit[buffID]) then
						data.chars[count].spirit = buffData;
					end
					if (shadow[buffID]) then
						data.chars[count].shadow = buffData;
					end
					if (motw[buffID]) then
						data.chars[count].motw = buffData;
					end
					if (pal[buffID]) then
						data.chars[count].pal = buffData;
					end
				end
			end
			if (NRC.raidStatusCache.resCache) then
				local resCache = NRC.raidStatusCache.resCache[k];
				if (resCache) then
					if (not data.chars[count]) then
						count = count + 1;
						if (count > 60) then
							break;
						end
						data.rows[count + 1] = v.name;
						data.chars[count] = addChar(v, k, v.name);
					end
					data.chars[count].resCache = resCache;
				end
			end
			if (NRC.raidStatusCache.weaponEnchantCache) then
				local weaponEnchantCache = NRC.raidStatusCache.weaponEnchantCache[k];
				if (weaponEnchantCache) then
					if (not data.chars[count]) then
						count = count + 1;
						if (count > 60) then
							break;
						end
						data.rows[count + 1] = v.name;
						data.chars[count] = addChar(v, k, v.name);
					end
					data.chars[count].weaponEnchantCache = weaponEnchantCache;
				end
			end
			if (NRC.raidStatusCache.talentCache) then
				local talentCache;
				local encounters = NRC.db.global.instances[NRC.raidStatusCache.logID].encounters;
				for k, v in ipairs(encounters) do
					--Get last recorded talents before this encounter.
					if (v.talentCache) then
						talentCache = v.talentCache;
					end
					if (v.encounterID == NRC.raidStatusCache.encounterID) then
						break;
					end
				end
				if (talentCache) then
					if (not data.chars[count]) then
						count = count + 1;
						if (count > 60) then
							break;
						end
						data.rows[count + 1] = v.name;
						data.chars[count] = addChar(v, k, v.name);
					end
					data.chars[count].talentCache = talentCache[v.name];
				end
			end
		end
	else
		if (GetNumGroupMembers() > 1) then
			local count = 0;
			data.rows[1] = "Header";
			for k, v in pairs(NRC.groupCache) do
				count = count + 1;
				data.rows[count + 1] = k;
				data.chars[count] = addChar(v, v.guid, k);
				local auraCache = NRC.auraCache[v.guid];
				if (auraCache) then
					for buffID, buffData in NRC:pairsByKeys(auraCache) do
						if (NRC.flasks[buffID]) then
							data.chars[count].flask = buffData;
						end
						if (NRC.foods[buffID]) then
							data.chars[count].food = buffData;
						end
						if (int[buffID]) then
							data.chars[count].int = buffData;
						end
						if (fort[buffID]) then
							data.chars[count].fort = buffData;
						end
						if (spirit[buffID]) then
							data.chars[count].spirit = buffData;
						end
						if (shadow[buffID]) then
							data.chars[count].shadow = buffData;
						end
						if (motw[buffID]) then
							data.chars[count].motw = buffData;
						end
						if (pal[buffID]) then
							data.chars[count].pal = buffData;
						end
					end
				end
			end
		end
	end
	return data;
end


---Raid data sharing---
--Our durabilty system uses part LibDurability and part custom updates when repairing etc.

--[[local myDura, myEnchants;
local function updateDura(percent, broken, sender, channel)
	if (percent) then
		percent = math.floor(percent);
		NRC.durability[sender] = {
			percent = percent,
			broken = broken,
		};
	end
end
NRC.dura:Register("NovaRaidCompanion", updateDura);
NRC.updateDura = updateDura;
--I wish LibDurability had a func to send a single update, this will do for now.
--This is just used upon death and repairing at a vendor.
function NRC:sendDura()
	if (not IsInGroup()) then
		return;
	end
	--NRC:debug("sending dura update");
	local percent, broken = NRC.dura.GetDurability();
	if (IsInRaid()) then
		C_ChatInfo.SendAddonMessage("Durability", string.format("%d, %d", percent, broken), "RAID");
	elseif (IsInGroup()) then
		C_ChatInfo.SendAddonMessage("Durability", string.format("%d, %d", percent, broken), "PARTY");
	end
end

function NRC:sendDuraThroddled()
	NRC:throddleEventByFunc("DURA_UPDATE", 3, "sendDura");
end

function NRC:updateMyDura()
	local percent, broken = NRC.dura.GetDurability();
	if (not myDura) then
		--First run after logon;
		myDura = percent;
		return;
	end
	if (percent and percent > myDura) then
		--Has repaired or swapped a fresh item on.
		--NRC:debug("repaired");
		NRC:sendDuraThroddled();
	end
	updateDura(percent, broken, UnitName("player"));
	myDura = percent;
end

local myRes = {};
local lastGroupJoin, lastRaidDataSent = 0, 0;
local myTalentsChanged;
local f = CreateFrame("Frame");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("GROUP_LEFT");
f:RegisterEvent("UNIT_RESISTANCES");
f:RegisterEvent("UNIT_INVENTORY_CHANGED");
f:RegisterEvent("CHARACTER_POINTS_CHANGED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "GROUP_JOINED" or event == "GROUP_FORMED") then
		--We need a cooldown check if we're first to be invited to a group.
		--Both events fire at once for first invited and we only want to send once.
		if (GetNumGroupMembers() > 1 and GetTime() - lastGroupJoin > 1) then
			lastGroupJoin = GetTime();
			NRC:sendRaidData();
			--NRC:startRaidCacheTicker();
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		NRC:checkMyRes(true);
		NRC:checkMyEnchants(true);
		NRC.checkMyTalents();
		local isLogon, isReload = ...;
		if (isReload) then
			--If reload then group join won't fire so send it here instead.
			NRC:sendRaidData();
			--NRC:startRaidCacheTicker();
		end
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");
	elseif (event == "GROUP_LEFT") then
		NRC.durability = {};
		NRC.resistances = {};
		NRC.weaponEnchants = {};
		--NRC.talents = {};
		--NRC:stopRaidCacheTicker();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		NRC:checkMyRes();
		f:UnregisterEvent("PLAYER_REGEN_ENABLED");
	elseif (event == "UNIT_RESISTANCES") then
		local unit = ...;
		if (unit == "player") then
			NRC:throddleEventByFunc("UNIT_RESISTANCES", 3, "checkMyRes");
		end
	elseif (event == "UNIT_INVENTORY_CHANGED") then
		NRC:throddleEventByFunc("UNIT_INVENTORY_CHANGED", 3, "checkMyEnchants");
	elseif (event == "CHARACTER_POINTS_CHANGED") then
		myTalentsChanged = true;
		NRC:throddleEventByFunc("CHARACTER_POINTS_CHANGED", 10, "sendTalents");
	end
end)

function NRC:sendRes()
	if (not IsInGroup()) then
		return;
	end
	local me = UnitName("player");
	NRC.resistances[me] = myRes;
	--NRC:debug("sending res update");
	local data = NRC.serializer:Serialize(myRes);
	if (IsInRaid()) then
		NRC:sendComm("RAID", "res " .. NRC.version .. " " .. data);
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", "res " .. NRC.version .. " " .. data);
	end
end

function NRC:receivedRes(data, sender, distribution)
	local name, realm = strsplit("-", sender, 2);
	if (realm == NRC.realm) then
		sender = name;
	end
	--NRC:debug("received res update from", sender);
	local deserializeResult, raidData = NRC.serializer:Deserialize(data);
	if (not deserializeResult) then
		NRC:debug("Failed to deserialize res.");
		return;
	end
	if (next(raidData)) then
		NRC.resistances[sender] = raidData;
	else
		NRC.resistances[sender] = nil;
	end
end

function NRC:checkMyRes(setDataOnly)
	if (InCombatLockdown() and not setDataOnly) then
		--Don't clog up comms during combat, wait till combat ends then update others.
		f:RegisterEvent("PLAYER_REGEN_ENABLED");
		return;
	end
	local me = UnitName("player");
	local temp = {};
	for i = 2, 6 do
		--0 = Armor, 1 = Holy, 2 = Fire, 3 = Nature, 4 = Frost, 5 = Shadow, 6 = Arcane,
		local _, total = UnitResistance("player", i);
		temp[i] = total;
	end
	if (setDataOnly) then
		--Just set our data, no sharing.
		myRes = temp;
		if (IsInGroup()) then
			NRC.resistances[me] = myRes;
		end
		return;
	end
	if (not next(myRes)) then
		--First run after logon, create cache and send data if we're in a group.
		myRes = temp;
		if (IsInGroup()) then
			NRC:sendRes();
		end
		return;
	end
	--There is no easy table compare in lua.
	if (myRes[2] ~= temp[2] or myRes[3] ~= temp[3]
			or myRes[4] ~= temp[4] or myRes[5] ~= temp[5] or myRes[6] ~= temp[6]) then
		--Resistances have changed, swapped items or received buff.
		--NRC:debug("resistances changed");
		myRes = temp;
		NRC:sendRes();
	else
		myRes = temp;
		if (IsInGroup()) then
			NRC.resistances[me] = myRes;
		end
	end
end

function NRC:sendEnchants()
	if (not IsInGroup()) then
		return;
	end
	local me = UnitName("player");
	if (next(myEnchants)) then
		NRC.weaponEnchants[me] = myEnchants;
	else
		--Table should always have entries if it gets this far but just incase.
		NRC.weaponEnchants[me] = nil;
	end
	--NRC:debug("sending weapon enchant update");
	local data = NRC.serializer:Serialize(myEnchants);
	if (IsInRaid()) then
		NRC:sendComm("RAID", "ench " .. NRC.version .. " " .. data);
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", "ench " .. NRC.version .. " " .. data);
	end
end

function NRC:receivedEnchants(data, sender, distribution)
	local name, realm = strsplit("-", sender, 2);
	if (realm == NRC.realm) then
		sender = name;
	end
	--NRC:debug("received weapon enchant update from", sender);
	local deserializeResult, raidData = NRC.serializer:Deserialize(data);
	if (not deserializeResult) then
		NRC:debug("Failed to deserialize res.");
		return;
	end
	NRC.weaponEnchants[sender] = raidData;
end

function NRC:checkMyEnchants(setDataOnly)
	local me = UnitName("player");
	local temp = {};
	local mh, mhTime, _, mhID, oh, ohTime, _, ohID = GetWeaponEnchantInfo();
	if (mh) then
		--Ignore windfury totems.
		if (mhID ~= 1783 and mhID ~= 563 and mhID ~= 564 and mhID ~= 2638 and mhID ~= 2639) then
			temp[1] = mhID;
			temp[2] = GetServerTime() + math.floor(mhTime/1000);
		end
	end
	if (oh) then
		if (ohID ~= 1783 and ohID ~= 563 and ohID ~= 564 and ohID ~= 2638 and ohID ~= 2639) then
			temp[3] = ohID;
			temp[4] = GetServerTime() + math.floor(ohTime/1000);
		end
	end
	if (setDataOnly) then
		--Just set our data, no sharing.
		myEnchants = temp;
		if (IsInGroup() and next(myEnchants)) then
			if (next(myEnchants)) then
				NRC.weaponEnchants[me] = myEnchants;
			else
				NRC.weaponEnchants[me] = nil;
			end
		end
		return;
	end
	if (not myEnchants) then
		--First run after logon, create cache and send data if we're in a group.
		myEnchants = temp;
		if (IsInGroup()) then
			NRC:sendEnchants();
		end
		return;
	end
	local changed;
	--Check if enchanted and wasn't previously, or other way around.
	if (myEnchants[1] ~= temp[1] or myEnchants[3] ~= temp[3]) then
		--Weapon enchants have changed.
		--NRC:debug("Weapon enchant changed.");
		changed = true;
	elseif ((myEnchants[2] and temp[2] and temp[2] > myEnchants[2] and temp[2] - myEnchants[2] > 20)
		or(myEnchants[4] and temp[4] and temp[4] > myEnchants[4] and temp[4] - myEnchants[4] > 20)) then
		--Time seems to creep forward every now and then a few seconds so check if weapon actually changed.
		--NRC:debug("Weapon enchant time changed.");
		changed = true;
	end
	if (changed) then
		myEnchants = temp;
		NRC:sendEnchants();
	else
		myEnchants = temp;
		if (IsInGroup()) then
			if (next(myEnchants)) then
				NRC.weaponEnchants[me] = myEnchants;
			else
				NRC.weaponEnchants[me] = nil;
			end
		end
	end
end

function NRC:sendTalents()
	if (not IsInGroup()) then
		return;
	end
	local talents = NRC:createTalentString();
	local me = UnitName("player");
	NRC.talents[me] = talents;
	--NRC:debug("sending talents update");
	local data = NRC.serializer:Serialize(talents);
	if (IsInRaid()) then
		NRC:sendComm("RAID", "tal " .. NRC.version .. " " .. data);
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", "tal " .. NRC.version .. " " .. data);
	end
	if (myTalentsChanged and NRC.groupCache[me]) then
		myTalentsChanged = nil;
		NRC:loadRaidCooldownChar(me, NRC.groupCache[me]);
	end
end

function NRC:receivedTalents(data, sender, distribution)
	local name, realm = strsplit("-", sender, 2);
	if (realm == NRC.realm) then
		sender = name;
	end
	--NRC:debug("received talents update from", sender);
	local deserializeResult, raidData = NRC.serializer:Deserialize(data);
	if (not deserializeResult) then
		NRC:debug("Failed to deserialize res.");
		return;
	end
	NRC.talents[sender] = raidData;
end

function NRC:checkMyTalents()
	if (IsInGroup()) then
		local me = UnitName("player");
		NRC.talents[me] = NRC:createTalentString();
	end
end

function NRC:sendRaidData()
	if (not IsInGroup()) then
		return;
	end
	if (GetServerTime() - lastRaidDataSent < 30) then --Change this time to longer later (once data accuracy is observed properly).
		--If multiple leaders open the status frame we don't need to keep sending data.
		--They should already have it unless they just joined group.
		--Individual stats are sent when they change so data should always be up to date.
		return;
	end
	lastRaidDataSent = GetServerTime();
	NRC:checkMyRes(true);
	NRC:checkMyEnchants(true);
	NRC:checkMyTalents();
	local me = UnitName("player");
	NRC.resistances[me] = myRes;
	--NRC:debug("sending raid update");
	--local data = NRC.serializer:Serialize(myRes);
	local a = {};
	if (myRes) then
		a.a = myRes;
	end
	local b = NRC:createTalentString();
	if (b) then
		a.b = b;
	end
	local c;
	if (myEnchants and next(myEnchants)) then
		a.c = myEnchants;
	end
	local percent, broken = NRC.dura.GetDurability();
	if (percent and broken) then
		a.d = percent;
		a.e = broken;
	end
	--NRC:debug(a);
	a = NRC.serializer:Serialize(a);
	if (IsInRaid()) then
		NRC:sendComm("RAID", "rd " .. NRC.version .. " " .. a);
		--C_ChatInfo.SendAddonMessage("NRCH", "data " .. NRC.version .. " " .. data, "RAID");
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", "rd " .. NRC.version .. " " .. a);
	end
end

function NRC:requestRaidData()
	if (not IsInGroup()) then
		return;
	end
	--Durability is requested seperately because it's a 3rd party lib other addons use too.
	NRC.dura:RequestDurability();
	if (IsInRaid()) then
		NRC:sendComm("RAID", "requestRaidData " .. NRC.version);
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", "requestRaidData " .. NRC.version);
	end
end

function NRC:receivedRaidData(data, sender, distribution)
	local name, realm = strsplit("-", sender, 2);
	if (realm == NRC.realm) then
		sender = name;
	end
	--NRC:debug("received raid update from", sender);
	local deserializeResult, raidData = NRC.serializer:Deserialize(data);
	if (not deserializeResult) then
		NRC:debug("Failed to deserialize res.");
		return;
	end
	if (raidData) then
		--Resistances.
		if (raidData.a) then
			NRC.resistances[sender] = raidData.a;
		end
		if (raidData.b) then
			NRC.talents[sender] = raidData.b;
		end
		if (raidData.c) then
			NRC.weaponEnchants[sender] = raidData.c;
		end
		if (raidData.d and raidData.e) then
			updateDura(raidData.d, raidData.e, sender, channel)
		end
	end
end

function NRC:updateRaidCache()
	for k, v in pairs(NRC.weaponEnchants) do
		--Main hand timer.
		if (v[2] and v[2] < GetServerTime()) then
			NRC.weaponEnchants[k][1] = nil;
			NRC.weaponEnchants[k][2] = nil;
		end
		--Offhand timer.
		if (v[4] and v[4] < GetServerTime()) then
			NRC.weaponEnchants[k][3] = nil;
			NRC.weaponEnchants[k][4] = nil;
		end
		if (not v[1] and not v[3]) then
			NRC.weaponEnchants[k] = nil;
		end
	end
end

--local ticker;
--function NRC:startRaidCacheTicker()
	--Not needed yet.
	--if (ticker) then
	--	return;
	--end
	--ticker = true;
	--NRC:raidCacheTicker();
--end

--function NRC:stopRaidCacheTicker()
--	ticker = nil;
--end

function NRC:raidCacheTicker()
	NRC:updateRaidCache();
	if (ticker) then
		C_Timer.After(5, function()
			NRC:raidCacheTicker();
		end)
	end
end]]

--https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function NRC:tableCopyAuras(orig)
	local data = copy(orig);
	local flasks = NRC.flasks;
	local scrolls = NRC.scrolls;
	local battleElixirs = NRC.battleElixirs;
	local guardianElixirs = NRC.guardianElixirs;
	local foods = NRC.foods;
	for guid, auras in pairs(data) do
		for spellID, spellData in pairs(auras) do
			--Remove any we aren't tracking to save saved variables space.
			if (not int[spellID]
			and not fort[spellID]
			and not spirit[spellID]
			and not shadow[spellID]
			and not motw[spellID]
			and not pal[spellID]
			and not flasks[spellID]
			and not scrolls[spellID]
			and not battleElixirs[spellID]
			and not guardianElixirs[spellID]
			and not foods[spellID]) then
				auras[spellID] = nil;
			end
		end
	end
	return data;
end