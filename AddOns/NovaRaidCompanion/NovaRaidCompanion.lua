-----------------------
--Nova Raid Companion--
--Novaspark-Arugal OCE (classic).
--https://www.curseforge.com/members/venomisto/projects

--local addonName, addon = ...;
--addon.a = LibStub("AceAddon-3.0"):NewAddon("NovaRaidCompanion", "AceComm-3.0");
--local NRC = addon.a;
local addonName, NRC = ...;
_G["NRC"] = NRC;
local GetAddOnMetadata = GetAddOnMetadata or C_AddOns.GetAddOnMetadata;
NRC.expansionNum = 1;
local _, _, _, tocVersion = GetBuildInfo();
if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
	NRC.isClassic = true;
elseif (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	NRC.isTBC = true;
	NRC.expansionNum = 2;
elseif (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
	NRC.isWrath = true;
	NRC.expansionNum = 3;
elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
	if (GetRealmName() ~= "Classic Beta PvE" and GetServerTime() < 1716127200) then --Sun May 19 2024 14:00:00 GMT;
		NRC.isCataPrepatch = true;
	end
	NRC.isCata = true;
	NRC.expansionNum = 4;
elseif (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC) then
	NRC.isMOP = true; --Later expansion project id's will likely need updating once Blizzard decides on the names.
	NRC.expansionNum = 5;
elseif (WOW_PROJECT_ID == WOW_PROJECT_WARLORDS_CLASSIC) then
	NRC.isWOD = true;
	NRC.expansionNum = 6;
elseif (WOW_PROJECT_ID == WOW_PROJECT_LEGION_CLASSIC) then
	NRC.isLegion = true;
	NRC.expansionNum = 7;
elseif (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
	NRC.isRetail = true;
	NRC.expansionNum = 10;
end
if (NRC.isClassic and C_Engraving and C_Engraving.IsEngravingEnabled()) then
	NRC.isSOD = true;
	local sodPhases = {[25]=1,[40]=2,[50]=3,[60]=4};
	NRC.sodPhase = sodPhases[(GetEffectivePlayerMaxLevel())];
end
NRC.comms = LibStub("AceComm-3.0");
NRC.comms:Embed(NRC);
NRC.LSM = LibStub("LibSharedMedia-3.0");
--NRC.dragonLib = LibStub("HereBeDragons-2.0");
--NRC.dragonLibPins = LibStub("HereBeDragons-Pins-2.0");
NRC.candyBar = LibStub("LibCandyBar-3.0-NRC");
NRC.customGlow = LibStub("LibCustomGlow-1.0");
NRC.LibRealmInfo = LibStub("LibRealmInfo");
NRC.DDM = LibStub("LibUIDropDownMenu-4.0");
NRC.commPrefix = "NRC";
NRC.helperCommPrefix = "NRCAH";
NRC.hasAddon = {};
NRC.hasAddonHelper = {};
NRC.realm = GetRealmName();
NRC.playerGUID = UnitGUID("player");
NRC.faction = UnitFactionGroup("player");
NRC.class = select(2, UnitClass("player"));
NRC.loadTime = 0;
NRC.logonTime = 0;
NRC.serializer = LibStub:GetLibrary("LibSerialize");
NRC.libDeflate = LibStub:GetLibrary("LibDeflate");
NRC.acr = LibStub:GetLibrary("AceConfigRegistry-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
NRC.LDBIcon = LibStub("LibDBIcon-1.0");
NRC.dura = LibStub("LibDurability");
NRC.version = GetAddOnMetadata("NovaRaidCompanion", "Version") or 9999;
NRC.version = tonumber(NRC.version);
NRC.latestRemoteVersion = NRC.version;
NRC.prefixColor = "|cFFFF6900";
NRC.groupCache = {};
NRC.groupSettings = {};
NRC.healerCache = {};
NRC.isResurrecting = {};
NRC.unitMap = {};
NRC.durability = {};
NRC.resistances = {};
NRC.weaponEnchants = {};
NRC.talents = {};
NRC.talents2 = {};
NRC.glyphs = {};
--NRC.glyphs2 = {};
NRC_Installed = true;

local function init()
    NRC:loadDatabase();
    NRC:loadExtraOptions();
	NRC.chatColor = "|cff" .. NRC:RGBToHex(NRC.db.global.chatColorR, NRC.db.global.chatColorG, NRC.db.global.chatColorB);
	NRC.prefixColor = "|cff" .. NRC:RGBToHex(NRC.db.global.prefixColorR, NRC.db.global.prefixColorG, NRC.db.global.prefixColorB);
	NRC.mmColor = "|cff" .. NRC:RGBToHex(NRC.db.global.mmColorR, NRC.db.global.mmColorG, NRC.db.global.mmColorB);
	NRC:RegisterComm(NRC.commPrefix);
	NRC:RegisterComm(NRC.helperCommPrefix);
	--NRC:buildRealmFactionData();
	NRC:dataCleanup();
	NRC:buildCooldownData();
	NRC:registerSounds();
	NRC.loadTime = GetServerTime();
	NRC:createBroker();
	NRC:loadRaidCooldownFrames();
	NRC:loadScrollingRaidEventsFrames();
	NRC:raidCooldownsCleanup();
	--NRC:raidCooldownsTicker();
	NRC:loadTargetSpawnTimeFrames();
	NRC:loadRaidManaFrame();
	NRC:updateRaidCooldownsShowDead();
	NRC:checkNewVersion();
	NRC:resetOldLockouts();
	NRC:updateRaidStatusLowDurationTime();
end
local f = CreateFrame("Frame");
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:SetScript("OnEvent", function(self, event, addon)
	if (event == "ADDON_LOADED") then
		if (addon == addonName) then
			init();
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		NRC:setRegionName();
		NRC:loadTalentFrame();
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");
	end
end)

NRC.regionFont = "Fonts\\ARIALN.ttf";
NRC.regionFont2 = "Fonts\\FRIZQT__.TTF";
NRC.regionFontNumbers = "Fonts\\FRIZQT__.ttf";
function NRC:setRegionFont()
	if (LOCALE_koKR) then
     	NRC.regionFont = "Fonts\\2002.TTF";
     	NRC.regionFont2 = "Fonts\\2002.TTF";
     	NRC.regionFontNumbers = "Fonts\\K_Pagetext.ttf";
    elseif (LOCALE_zhCN) then
     	NRC.regionFont = "Fonts\\ARKai_T.ttf";
     	NRC.regionFont2 = "Fonts\\ARKai_T.ttf";
     	NRC.regionFontNumbers = "Fonts\\ARKai_T.ttf";
    elseif (LOCALE_zhTW) then
     	NRC.regionFont = "Fonts\\blei00d.TTF";
     	NRC.regionFont2 = "Fonts\\blei00d.TTF";
     	NRC.regionFontNumbers = "Fonts\\blei00d.ttf";
    elseif (LOCALE_ruRU) then
    	--ARIALN seems to work in RU.
     	--NRC.regionFont = "Fonts\\FRIZQT___CYR.TTF";
     	NRC.regionFont2 = "Fonts\\ARIALN.ttf";
     	NRC.regionFontNumbers = "Fonts\\MORPHEUS_CYR.ttf";
    	NRC.regionFontItalic = "Interface\\Addons\\NovaRaidCompanion\\Media\\ARIALNI.TTF";
    	NRC.regionFontBoldItalic = "Interface\\Addons\\NovaRaidCompanion\\Media\\ARIALNBI.TTF";
    else
    	NRC.regionFontItalic = "Interface\\Addons\\NovaRaidCompanion\\Media\\ARIALNI.TTF";
    	NRC.regionFontBoldItalic = "Interface\\Addons\\NovaRaidCompanion\\Media\\ARIALNBI.TTF";
    end
end
NRC:setRegionFont();
NRC.LSM:Register("font", "NRC Default", NRC.regionFont);
NRC.LSM:Register("font", "NRC Numbers", NRC.regionFontNumbers);

NRC.units = { --Efficiency lookup.
	["player"] = true,
	["party1"] = true,
	["party2"] = true,
	["party3"] = true,
	["party4"] = true,	
};
for i = 1, 40 do
	NRC.units["raid" .. i] = true;
end

local printPrefix;
function NRC:print(msg, prefix, tbcCheck)
	if (prefix) then
		printPrefix = NRC.prefixColor .. prefix .. "|r";
	else
		printPrefix = NRC.prefixColor .. "|HNRCCustomLink:prefix|h[NRC]|h|r";
	end
	print(printPrefix .. " " .. NRC.chatColor .. msg);
end

SLASH_NRCCMD1, SLASH_NRCCMD2 = '/nrc', '/novaraidcompanion';
function SlashCmdList.NRCCMD(msg, editBox)
	if (msg == "options" or msg == "option" or msg == "opt" or msg == "config" or msg == "menu") then
		NRC:openConfig();
	elseif (msg == "reset") then
		NRC:resetData();
	elseif (msg == "raid") then
		NRC:openRaidStatusFrame();
	elseif (msg == "log" or msg == "raidlog") then
		NRC:openRaidLogFrame();
	elseif (msg == "lockouts" or msg == "lockout") then
		NRC:openLockoutsFrame();
	elseif (msg == "loot") then
		NRC:openRaidLogFrame();
		NRC:loadRaidLogInstance(1);
		NRC:loadRaidLogLoot(1);
	elseif (msg == "lock") then
		if (NRC.config.lockAllFrames) then
			NRC:print("Frames are already locked.");
			return;
		end
		NRC.config.lockAllFrames = true;
		NRC:updateFrameLocks(true);
	elseif (msg == "unlock") then
		if (not NRC.config.lockAllFrames) then
			NRC:print("Frames are already unlocked.");
		else
			NRC:print("Unlocking all frames.");
		end
		NRC.config.lockAllFrames = false;
		NRC:updateFrameLocks();
	elseif (msg ~= nil and msg ~= "") then
		NRC:print("Please type /nrc config.");
	else
		NRC:openConfig();
	end
end

function NRC:openConfig()
	if (InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()) then
		InterfaceOptionsFrame:Hide();
	else
		--Opening the frame needs to be run twice to avoid a bug.
		InterfaceOptionsFrame_OpenToCategory("NovaRaidCompanion");
		--Hack to fix the issue of interface options not opening to menus below the current scroll range.
		--This addon name starts with N and will always be closer to the middle so just scroll to the middle when opening.
		local min, max = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues();
		if (min < max) then
			InterfaceOptionsFrameAddOnsListScrollBar:SetValue(math.floor(max/2));
		end
		InterfaceOptionsFrame_OpenToCategory("NovaRaidCompanion");
		NRC.acr:NotifyChange("NovaRaidCompanion");
	end
end

function NRC:resetData(silent)
	NRC.data.raidCooldowns = {};
	--add function to reset local raidCooldown cache data.
	if (not silent) then
		NRC:print("Data has been reset.");
	end
end

local NRCLDB;
function NRC:createBroker()
	local data = {
		type = "launcher",
		label = "NRC",
		text = "NovaRaidCompanion",
		icon = "Interface\\Addons\\NovaRaidCompanion\\Media\\nrc_icon",
		OnClick = function(self, button)
			if (button == "LeftButton" and IsShiftKeyDown()) then
				if (NRCRaidLogFrame and NRCRaidLogFrame:IsShown() and NRCRaidLogFrame.frameType == "allTrades") then
					NRCRaidLogFrame:Hide();
				else
					NRC:updateTradeFrame(true, true);
				end
			elseif (button == "LeftButton" and IsControlKeyDown()) then
				NRC:openRaidLogFrame();
				NRC:loadRaidLogInstance(1);
				NRC:loadRaidLogLoot(1);
			elseif (button == "LeftButton") then
				NRC:openRaidStatusFrame();
			elseif (button == "RightButton" and IsShiftKeyDown()) then
				if (InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()) then
					InterfaceOptionsFrame:Hide();
				else
					NRC:openConfig();
				end
			elseif (button == "RightButton") then
				NRC:openRaidLogFrame();
			end
		end,
		OnEnter = function(self, button)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			NRC:updateMinimapButton(GameTooltip, self);
			GameTooltip:Show()
		end,
		OnLeave = function(self, button)
			GameTooltip:Hide()
			if (GameTooltip.NRCSeparator) then
				GameTooltip.NRCSeparator:Hide();
			end
			if (GameTooltip.NRCSeparator2) then
				GameTooltip.NRCSeparator2:Hide();
			end
		end,
	};
	NRCLDB = LDB:NewDataObject("NRC", data);
	NRC.LDBIcon:Register("NovaRaidCompanion", NRCLDB, NRC.db.global.minimapIcon);
	--Raise the frame level so users can see if it clashes with an existing icon and they can drag it.
	local frame = NRC.LDBIcon:GetMinimapButton("NovaRaidCompanion");
	if (frame) then
		frame:SetFrameLevel(9);
	end
end
    
function NRC:updateMinimapButton(tooltip, frame)
	tooltip = tooltip or GameTooltip;
	if (not tooltip:IsOwned(frame)) then
		if (tooltip.NRCSeparator) then
			tooltip.NRCSeparator:Hide();
		end
		if (tooltip.NRCSeparator2) then
			tooltip.NRCSeparator2:Hide();
		end
		return;
	end
	tooltip:ClearLines();
	tooltip:AddLine("NovaRaidCompanion");
	if (not IsShiftKeyDown()) then
		tooltip:AddLine("|cFFFFAE42(" .. L["holdShitForExtraInfo"] .. ")");
	end
	if (not tooltip.NRCSeparator) then
		tooltip.NRCSeparator = tooltip:CreateTexture(nil, "BORDER");
		tooltip.NRCSeparator:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		tooltip.NRCSeparator:SetHeight(1);
		tooltip.NRCSeparator:SetPoint("LEFT", 10, 0);
		tooltip.NRCSeparator:SetPoint("RIGHT", -10, 0);
		tooltip.NRCSeparator:Hide();
	end
	if (not IsShiftKeyDown()) then
		tooltip:AddLine(L["Raid Lockouts This Char"] .. ":");
	else
		tooltip:AddLine(L["Raid Lockouts (Including Alts)"] .. ":");
	end
	local me = UnitName("player");
	local found, altsFound;
	for k, v in pairs(NRC.data) do
		if (type(v) == "table") then
			if (k == "myChars") then
				for char, charData in NRC:pairsByKeys(v) do
					if (IsShiftKeyDown() or char == me) then
						local found2;
						local _, _, _, classColorHex = GetClassColor(charData.englishClass);
						local text = "|c" .. classColorHex .. char .. "|r";
						if (charData.savedInstances) then
							local instances = {};
							for k, v in pairs(charData.savedInstances) do
								tinsert(instances, v);
							end
							table.sort(instances, function(a, b) return a.name < b.name end);
							for instance, instanceData in ipairs(instances) do
								if (instanceData.locked and instanceData.resetTime and instanceData.resetTime > GetServerTime()) then
									local timeString = "(" .. NRC:getTimeString(instanceData.resetTime - GetServerTime(), true, "short") .. ")";
									local instanceName = instanceData.name;
									if (instanceData.difficultyName) then
										instanceName = NRC:addDiffcultyText(instanceData.name, instanceData.difficultyName, nil, "", "|cFFFFFF00");
									end
									instanceName = string.gsub(instanceName, "Hellfire Citadel: ", "");
									instanceName = string.gsub(instanceName, "Coilfang: ", "");
									instanceName = string.gsub(instanceName, "Auchindoun: ", "");
									instanceName = string.gsub(instanceName, "Tempest Keep: ", "");
									instanceName = string.gsub(instanceName, "Opening of the Dark Portal", "Black Morass");
									text = text .. "\n  |cFFFFFF00-|r|cFFFFAE42" .. instanceName .. "|r |cFF9CD6DE" .. timeString .. "|r";
									found = true;
									found2 = true;
									if (char ~= me) then
										altsFound = true;
									end
								end
							end
						end
						if (found2) then
							tooltip:AddLine(text);
						end
					end
				end
			end
		end
	end
	if (not found) then
		tooltip:AddLine("|cFF9CD6DE" .. L["noCurrentRaidLockouts"] .. "|r");
	end
	if (IsShiftKeyDown() and not altsFound) then
		tooltip:AddLine("|cFF9CD6DE" .. L["noAltLockouts"] .. "|r");
	end
	tooltip:AddLine(" ");
	tooltip.NRCSeparator:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
	tooltip.NRCSeparator:Show();
	local threeDayReset = NRC:getThreeDayReset();
	local weeklyReset = NRC:getWeeklyReset();
	if (threeDayReset) then
		if (not tooltip.NRCSeparator2) then
			tooltip.NRCSeparator2 = tooltip:CreateTexture(nil, "BORDER");
			tooltip.NRCSeparator2:SetColorTexture(0.6, 0.6, 0.6, 0.85);
			tooltip.NRCSeparator2:SetHeight(1);
			tooltip.NRCSeparator2:SetPoint("LEFT", 10, 0);
			tooltip.NRCSeparator2:SetPoint("RIGHT", -10, 0);
			tooltip.NRCSeparator2:Hide();
		end
		local threeDateString, weeklyDateString = "", "";
		if (IsShiftKeyDown()) then
			if (NRC.db.global.timeStampFormat == 12) then
				threeDateString = " (" .. date("%A", threeDayReset) .. " " .. gsub(date("%I:%M", threeDayReset), "^0", "")
						.. string.lower(date("%p", threeDayReset)) .. ")";
				weeklyDateString = " (" .. date("%A", weeklyReset) .. " " .. gsub(date("%I:%M", weeklyReset), "^0", "")
						.. string.lower(date("%p", weeklyReset)) .. ")";
			else
				threeDateString = " (" .. date("%A %H:%M", threeDayReset) .. ")";
				weeklyDateString = " (" .. date("%A %H:%M", weeklyReset) .. ")";
			end
		end
		tooltip:AddLine("|cFF00C8003 day reset:|r |cFF9CD6DE" .. NRC:getTimeString(threeDayReset - GetServerTime(), true, "medium")
				.. threeDateString .. "|r");
		tooltip:AddLine("|cFF00C800Weekly reset:|r |cFF9CD6DE" .. NRC:getTimeString(weeklyReset - GetServerTime(), true, "medium")
				.. weeklyDateString .. "|r");
		tooltip:AddLine(" ");
		tooltip.NRCSeparator2:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NRCSeparator2:Show();
	end
	tooltip:AddLine("|cFF9CD6DE" .. L["leftClickMinimapButton"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["rightClickMinimapButton"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["shiftLeftClickMinimapButton"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["shiftRightClickMinimapButton"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["controlLeftClickMinimapButton"]);
	tooltip:Show();
	C_Timer.After(0.1, function()
		NRC:updateMinimapButton(tooltip, frame);
	end)
end