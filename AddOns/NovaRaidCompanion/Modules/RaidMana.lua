---------------------------------
---NovaRaidCompanion  Raid mana--
---------------------------------

--This module was inspired by a couple of old classic weakauras I saw and people asking me to add something similar.
--This can be healer accurate by using the NRC spec detection.
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local raidManaFrame, raidManaEnabled, showSelf, sortByMana, showRes, resurrectionDir;
local lineFrameHeight = 15;
local testData, manaCacheTestData, testRunning, testRunningTimer, testRunningTimer2;
local manaCache, trackedChars = {}, {};
local updateInterval = 0.5;
local units = NRC.units;
local UnitPowerType = UnitPowerType;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitName = UnitName;
local UnitBuff = UnitBuff;
local strfind = strfind;
local tostring = tostring;
local GetClassColor = GetClassColor;
local floor = floor;
local UnitIsDead = UnitIsDead;
local UnitIsGhost = UnitIsGhost;
local UnitIsConnected = UnitIsConnected;

function NRC:loadRaidManaFrame(loadOnly)
	if (not NRC.config.raidManaEnabled and not testRunning and not loadOnly) then
		NRC:updateRaidManaState();
		return;
	end
	local firstLoad;
	if (not raidManaFrame) then
		raidManaFrame = NRC:createRaidDataFrame("NRCRaidManaFrame", 130, lineFrameHeight, 0, -50);
		raidManaFrame.updateLayoutFunc = "updateRaidManaFramesLayout";
		raidManaFrame.stopDragFunc = "updateRaidManaFramesLayout";
		raidManaFrame:SetBackdropColor(0, 0, 0, 0);
		raidManaFrame:SetBackdropBorderColor(1, 1, 1, 0);
		raidManaFrame.fs2:SetPoint("BOTTOM", raidManaFrame, "TOP", 0, 2);
		raidManaFrame.fs:SetPoint("LEFT", raidManaFrame.fs2, "RIGHT", 2, 0);
		local point, _, relativePoint, x, y = raidManaFrame:GetPoint();
		if (point == "CENTER" and x == raidManaFrame.defaultX and y == raidManaFrame.defaultY) then
			raidManaFrame.firstRun = true;
			NRC:raidManaUnlockFrames();
		else
			NRC:raidManaUpdateFrameLocks();
		end
		raidManaFrame:SetScript("OnUpdate", function(self)
			--Update throddle.
			if (GetTime() - raidManaFrame.lastUpdate > updateInterval) then
				raidManaFrame.lastUpdate = GetTime();
				NRC:updateManaFrame();
			end
		end)
		firstLoad = true;
	end
	if (not loadOnly) then
		NRC:updateRaidManaFramesLayout();
		if (not firstLoad) then
			NRC:raidManaUpdateFrameLocks();
		end
	end
end

function NRC:updateRaidManaState(func)
	raidManaEnabled = false;
	if (not NRC.config.raidManaEnabled) then
		if (raidManaFrame) then
			raidManaFrame:Hide();
		end
		raidManaEnabled = false;
		return;
	end
	local instance, instanceType = IsInInstance();
	if (NRC.config.raidManaEnabledEverywhere) then
		--Pvp config overrides this.
		if (not NRC:isPvp()) then
			raidManaEnabled = true;
		end
	end
	if (NRC.config.raidManaEnabledRaid and instance and (instanceType == "party" or instanceType == "raid")
			and not NRC:isPvp()) then
		raidManaEnabled = true;
	end
	if (NRC.config.raidManaEnabledPvp and NRC:isPvp()) then
		raidManaEnabled = true;
	end
	if (testRunning or raidManaFrame.firstRun or not raidManaFrame.locked) then
		raidManaEnabled = true;
	end
	if (raidManaEnabled) then
		if (not raidManaFrame) then
			NRC:loadRaidManaFrame(true);
		end
		if (raidManaFrame) then
			raidManaFrame:Show();
		end
	else
		if (raidManaFrame) then
			raidManaFrame:Hide();
		end
	end
	NRC:loadTrackedManaChars(func or "updateRaidManaState");
end

local raidManaAverage;
function NRC:updateRaidManaFramesLayout()
	raidManaFrame.clearAllPoints();
	raidManaFrame.fs:SetText("");
	raidManaFrame.fs2:SetText("");
	local db = NRC.db.global;
	lineFrameHeight = db.raidManaHeight;
	raidManaAverage = NRC.config.raidManaAverage;
	if (NRC.config.raidManaShowSelf) then
		showSelf = true;
	else
		showSelf = false;
	end
	raidManaFrame.growthDirection = db.growthDirection;
	--Update size.
	raidManaFrame:SetScale(db.raidManaScale);
	--Update alpha.
	raidManaFrame.background:SetBackdropColor(0, 0, 0, db.raidManaBackdropAlpha);
	raidManaFrame.background:SetBackdropBorderColor(1, 1, 1, db.raidManaBorderAlpha);
	--Update growth direction.
	raidManaFrame.growthDirection = db.raidManaGrowthDirection;
	if (raidManaFrame.growthDirection == 1) then
		--Grow down so set info tab to the top.
		raidManaFrame.displayTab.top:ClearAllPoints();
		raidManaFrame.displayTab.top:SetPoint("BOTTOM", raidManaFrame.displayTab, "TOP", 0, -2);
		raidManaFrame.displayTab.top:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom2",
			tileEdge = true,
			edgeSize = 8,
			insets = {top = 3, left = 2, bottom = 2, right = 2},
		});
		raidManaFrame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
		raidManaFrame.fs2:ClearAllPoints();
		raidManaFrame.fs2:SetPoint("BOTTOM", raidManaFrame, "TOP", 0, 2);
	else
		--Grow upwards so set info tab to the bottom.
		raidManaFrame.displayTab.top:ClearAllPoints();
		raidManaFrame.displayTab.top:SetPoint("TOP", raidManaFrame.displayTab, "BOTTOM", 0, 2);
		raidManaFrame.displayTab.top:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoTop2",
			tileEdge = true,
			edgeSize = 8,
			insets = {top = 2, left = 2, bottom = 3, right = 2},
		});
		raidManaFrame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
		raidManaFrame.fs2:ClearAllPoints();
		raidManaFrame.fs2:SetPoint("TOP", raidManaFrame, "BOTTOM", 0, -2);
	end
	raidManaFrame.displayTab:SetAlpha(0.3);
	raidManaFrame.displayTab.top.fs:SetText("|cFFDEDE42Healer Mana|r");
	raidManaFrame.displayTab.top.fs2:SetText("|cFF9CD6DE" .. L["Drag Me"] .. "|r");
	raidManaFrame.displayTab.top:SetSize(100, 30);
	updateInterval = NRC.db.global.raidManaUpdateInterval;
	raidManaFrame:SetScript("OnUpdate", function(self)
		if (GetTime() - raidManaFrame.lastUpdate > updateInterval) then
			raidManaFrame.lastUpdate = GetTime();
			NRC:updateManaFrame();
		end
	end)
	if (db.raidManaResurrectionDir == 1) then
		resurrectionDir = 1;
		local point, _, relativePoint, x, y = raidManaFrame:GetPoint();
		if (point == "RIGHT" or point == "TOPRIGHT" or point == "BOTTOMRIGHT") then
			resurrectionDir = 2;
		else
			resurrectionDir = 1;
		end
	elseif (db.raidManaResurrectionDir == 2) then
		resurrectionDir = 2;
	else
		resurrectionDir = 1;
	end
	showRes = NRC.config.raidManaResurrection;
	raidManaFrame.lineFrameWidth = db.raidManaWidth;
	raidManaFrame.lineFrameHeight = db.raidManaHeight;
	raidManaFrame.padding = db.raidManaPadding;
	raidManaFrame.lineFrameFont = db.raidManaFont;
	raidManaFrame.lineFrameFontNumbers = db.raidManaFontNumbers;
	raidManaFrame.lineFrameFontSize = db.raidManaFontSize;
	raidManaFrame.lineFrameFontOutline = db.raidManaFontOutline;
	raidManaFrame.updateDimensions();
	for k, v in pairs(raidManaFrame.lineFrames) do
		v.fs:SetFont(NRC.LSM:Fetch("font", db.raidManaFontNumbers), db.raidManaFontSize, db.raidManaFontOutline);
		v.fs2:SetFont(NRC.LSM:Fetch("font", db.raidManaFont), db.raidManaFontSize + 2, db.raidManaFontOutline);
		v.fs3:SetFont(NRC.LSM:Fetch("font", db.raidManaFont),db.raidManaFontSize + 2, db.raidManaFontOutline);
		--v.fs2:SetFont(NRC.LSM:Fetch("font", db.raidManaFont), lineFrameHeight - 1);
		--v.fs3:SetFont(NRC.LSM:Fetch("font", db.raidManaFont), lineFrameHeight - 1);
	end
	raidManaFrame:Show();
	NRC:loadTrackedManaChars("updateRaidManaFramesLayout");
end

local function sortRaidMana(func)
	local sort = NRC.db.global.raidManaSortOrder;
	sortByMana = false;
	if (testRunning) then
		if (sort == 1) then
			table.sort(testData, function(a, b)
				return a.class < b.class
					or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
			end)
		elseif (sort == 2) then
			table.sort(testData, function(a, b) return a.name < b.name end);
		elseif (sort == 3) then
			table.sort(testData, function(a, b) return a.name > b.name end);
		elseif (sort == 4) then
			sortByMana = 1;
		elseif (sort == 5) then
			sortByMana = 2;
		end
	else
		if (sort == 1) then
			table.sort(trackedChars, function(a, b)
				return a.class < b.class
					or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
			end)
		elseif (sort == 2) then
			table.sort(trackedChars, function(a, b) return a.name < b.name end);
		elseif (sort == 3) then
			table.sort(trackedChars, function(a, b) return a.name > b.name end);
		elseif (sort == 4) then
			sortByMana = 1;
		elseif (sort == 5) then
			sortByMana = 2;
		end
	end
	--NRC:debug("Sort Mana " .. sort .. ":", func);
end

local function isCharTracked(name)
	for k, v in pairs(trackedChars) do
		if (v.name == name) then
			return true;
		end
	end
end

local drink = L["Drink"];
local refreshment = L["Refreshment"];
local function isDrinking(unit)
	for i = 1, 32 do
		local name = UnitBuff(unit, i);
		if (name and (name == drink or name == refreshment)) then
			return true;
		end
	end
end

function NRC:removeFromManaCache(who)
	manaCache[who] = nil;
end

--Load which chars to track based on config.
--This is called by updateHealerCache() and updateHealerCache() is called by all the roster changing and logon stuff.
--So no need to call this from any of those places.
function NRC:loadTrackedManaChars(func)
	trackedChars = {};
	local config = NRC.config;
	if (raidManaEnabled) then
		local me = UnitName("player");
		if (raidManaFrame) then
			if (config.raidManaHealers) then
				for k, v in pairs(NRC.healerCache) do
					if (showSelf or v.name ~= me) then
						tinsert(trackedChars, v);
					end
				end
			end
			for k, v in pairs(NRC.groupCache) do
				if (not isCharTracked(k) and ((config.raidManaDruid and v.class == "DRUID")
						or (config.raidManaHunter and v.class == "HUNTER")
						or (config.raidManaMage and v.class == "MAGE")
						or (config.raidManaPaladin and v.class == "PALADIN")
						or (config.raidManaPriest and v.class == "PRIEST")
						or (config.raidManaShaman and v.class == "SHAMAN")
						or (config.raidManaWarlock and v.class == "WARLOCK"))) then
					if (showSelf or k ~= me) then
						local specName, specIcon;
						if (NRC.talents[k]) then
							_, _, specName, specIcon = NRC:getSpecFromTalentString(NRC.talents[k]);
						end
						local t = {
							name = k,
							specName = specName,
							icon = specIcon,
							class = v.class,
						};
						tinsert(trackedChars, t);
					end
				end
			end
			if (#trackedChars > 0) then
				raidManaFrame:Show();
			elseif (not testRunning and not raidManaFrame.firstRun and raidManaFrame.locked) then
				raidManaFrame:Hide();
			end
			NRC:updateManaFrame();
		end
	end
	NRC:loadGroupMana();
	sortRaidMana(func or "loadTrackedManaChars");
end

function NRC:removeRaidManaChar(name)
	for k, v in pairs(trackedChars) do
		if (v.name == name) then
			table.remove(trackedChars, k);
			return;
		end
	end
end

--If we get new inspection data update talents.
function NRC:updateTrackedManaCharTalents(name)
	if (name) then
		for k, v in pairs(trackedChars) do
			if (v.name == name) then
				local specName, specIcon;
				if (NRC.talents[k]) then
					_, _, specName, specIcon = NRC:getSpecFromTalentString(NRC.talents[k]);
				end
				if (specName) then
					v.specName = specName;
					v.specIcon = specIcon;
				end
			end
		end
	end
end

local function sortMana()
	--I think this uglyness in sorting is better than iterating the mana cache table table to insert mana amouns every update from a player.
	--Only if sort by mana is enabled we insert the data during sorting, OnUpdate is throddled anyway so it's not too bad.
	local notSafeToSort;
	if (testRunning) then
		for k, v in pairs(testData) do
			if (manaCacheTestData[v.name].mana) then
				v.mana = manaCacheTestData[v.name].mana
			else
				notSafeToSort = true;
			end
		end
		if (not notSafeToSort) then
			if (sortByMana == 1) then
				table.sort(testData, function(a, b) return a.mana > b.mana end);
			else
				table.sort(testData, function(a, b) return a.mana < b.mana end);
			end
		end
	else
		for k, v in pairs(trackedChars) do
			if (manaCache[v.name] and manaCache[v.name].mana) then
				if (manaCache[v.name].mana == 0 or manaCache[v.name].maxMana == 0) then
					--If somehow nan.
					trackedChars[k].percent = 0;
				else
					trackedChars[k].percent = floor(manaCache[v.name].mana / manaCache[v.name].maxMana * 100);
				end
			else
				--If this ever happens there's a bug somewhere with tracking player mana.
				--I can maybe remove this check later if it proves to be 100% reliable.
				--NRC:debug("Not safe for mana sorting:", v.name, manaCache[v.name]);
				notSafeToSort = true;
			end
		end
		if (not notSafeToSort) then
			if (sortByMana == 1) then
				table.sort(trackedChars, function(a, b)
					return a.percent > b.percent
						or a.percent == b.percent and strcmputf8i(a.name, b.name) < 0;
				end)
				--table.sort(trackedChars, function(a, b) return a.percent > b.percent end);
			else
				table.sort(trackedChars, function(a, b)
					return a.percent < b.percent
						or a.percent == b.percent and strcmputf8i(a.name, b.name) < 0;
				end)
			end
		end
	end
end

function NRC:updateManaFrame()
	local count = 0;
	local hasManaCount = 0;
	local total = 0;
	if (sortByMana) then
		--Only sort each update if this is enabled, otherwise we only sort when a player is added/removed.
		sortMana();
	end
	local data, mCache;
	if (testRunning) then
		data = testData;
		mCache = manaCacheTestData;
	else
		data = trackedChars;
		mCache = manaCache;
	end
	local isResurrecting = NRC.isResurrecting;
	if (next(data)) then
		for k, v in ipairs(data) do
			local name = v.name;
			if (mCache[name]) then
				local mana = mCache[name].mana;
				local maxMana = mCache[name].maxMana;
				if (mana and maxMana) then
					local percent = mana / maxMana * 100;
					if (strfind(tostring(percent), "nan")) then
						percent = 0;
					end
					count = count + 1;
					--Create line frame.
					local lineFrame = raidManaFrame:getLineFrame(count);
					local _, _, _, classColorHex = GetClassColor(v.class);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.class == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
					local text = "|c" .. classColorHex .. name;
					local color = "|cFF00C800";
					if (percent < 31) then
						color = "|cFFFF2222";
					elseif (percent < 80) then
						color = "|cFFDEDE42";
					end
					local manaString = color .. floor(percent) .. "%|r";
					lineFrame.enabled = true;
					lineFrame.fs2:SetText(text);
					lineFrame.fs:SetText(manaString);
					local unit = NRC:getUnitFromName(name);
					local drinking, dead, offline;
					local inForm;
					if (unit) then
						if (UnitIsDead(unit) or UnitIsGhost(unit)) then
							dead = true;
						end
						if (isDrinking(unit)) then
							drinking = true;
						end
						if (not UnitIsConnected(unit)) then
							offline = true;
						end
					end
					if (offline) then
						text = "|c" .. classColorHex ..  strsub(name, 1, 3) .. "|r";
						text = text .. "|cFFA1A1A1(" .. L["Offline"] .. ")|r";
					end
					if (dead) then
						manaString = "  |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
					end
					if (drinking) then
						lineFrame.texture:SetTexture(132794);
					else
						lineFrame.texture:SetTexture(v.icon);
					end
					if (not dead and not offline) then
						hasManaCount = hasManaCount + 1;
						total = total + floor(percent);
					end
					lineFrame.fs2:SetText(text);
					lineFrame.fs:SetText(manaString);
					if (showRes and isResurrecting[name]) then
						local data = isResurrecting[name];
						if (data.destClass) then
							local _, _, _, classHex = GetClassColor(data.destClass);
							local destName = "|c" .. classHex .. data.destName .. "|r";
							if (resurrectionDir == 1) then
								lineFrame.fs3:ClearAllPoints();
								lineFrame.fs3:SetPoint("LEFT", lineFrame, "RIGHT", 2, 0);
								lineFrame.fs3:SetJustifyH("RIGHT");
								lineFrame.fs3:SetText("|cFF9CD6DE->|r " .. destName);
							else
								lineFrame.fs3:ClearAllPoints();
								lineFrame.fs3:SetPoint("RIGHT", lineFrame, "LEFT", -2, 0);
								lineFrame.fs3:SetJustifyH("LEFT");
								--lineFrame.fs3:SetText(destName .. " |cFF9CD6DE<-|r");
								lineFrame.fs3:SetText(destName .. " |cFFFFFF00<-|r");
							end
							if (data.castEndTime) then
								--if we have accurate casting data from UnitCastingInfo().
								lineFrame.castStartTime = data.castStartTime / 1000;
								lineFrame.castDuration = (data.castEndTime - data.castStartTime) / 1000;
							else
								--Otherwise call it a 10 second cast like most resurrections without haste.
								lineFrame.castStartTime = data.startTime or 0;
								lineFrame.castDuration = 10;
							end
							lineFrame.castBar:Show();
							lineFrame.borderFrame:Show();
							lineFrame.texture:SetTexture(isResurrecting[name].icon);
						else
							lineFrame.castBar:Hide();
							lineFrame.borderFrame:Hide();
							lineFrame.fs3:SetText("");
						end
					else
						lineFrame.castBar:Hide();
						lineFrame.borderFrame:Hide();
						lineFrame.fs3:SetText("");
					end
				end
			end
		end
		if (raidManaAverage) then
			if (count > 1 and hasManaCount > 0) then
				local averageManaText = "";
				if (total > 0) then
					local averagePercent = total / hasManaCount;
					local color = "|cFF00C800";
					if (averagePercent < 31) then
						color = "|cFFFF2222";
					elseif (averagePercent < 80) then
						color = "|cFFDEDE42";
					end
					averageManaText = color .. floor(averagePercent, 2) .. "%|r";
					raidManaFrame.fs2:SetText(averageManaText);
				end
			else
				raidManaFrame.fs:SetText("");
				raidManaFrame.fs2:SetText("");
			end
		end
		for k, v in pairs(raidManaFrame.lineFrames) do
			if (k > count) then
				v.enabled = false;
			end
		end
	else
		for k, v in pairs(raidManaFrame.lineFrames) do
			v.enabled = false;
		end
	end
	raidManaFrame:sortLineFrames();
end

function NRC:loadGroupMana()
	manaCache = {};
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	for i = 1, GetNumGroupMembers() do
		local unit = unitType .. i;
		if (UnitPowerType(unit) == 0) then
			local name = UnitName(unit);
			local mana = UnitPower(unit, 0);
			local maxMana = UnitPowerMax(unit, 0);
			if (mana and name) then
				manaCache[name] = {
					mana = mana,
					maxMana = maxMana,
				};
			end
		end
	end
	if (UnitPowerType("player") == 0) then
		local name = UnitName("player");
		local mana = UnitPower("player", 0);
		local maxMana = UnitPowerMax("player", 0);
		if (mana and name) then
			manaCache[name] = {
				mana = mana,
				maxMana = maxMana,
			};
		end
	end
end

local f = CreateFrame("Frame", "NRCRaidMana");
f:RegisterEvent("UNIT_POWER_UPDATE");
--f:RegisterEvent("UNIT_POWER_FREQUENT");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("GROUP_LEFT");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "UNIT_POWER_UPDATE") then
		local unit, type = ...;
		--We can't get mana from other players in cat/bear form so check what form they're in.
		if (type == "MANA" and UnitPowerType(unit) == 0) then
			if (units[unit]) then
				manaCache[UnitName(unit)] = {
					mana = UnitPower(unit, 0),
					maxMana = UnitPowerMax(unit, 0),
				};
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		C_Timer.After(1, function()
			NRC:updateRaidManaState();
		end)
		if (_G["NRCRaidManaFrame"]) then
			NRC:loadTrackedManaChars("PLAYER_ENTERING_WORLD");
		end
	elseif (event == "GROUP_FORMED" or event == "GROUP_JOINED") then
		if (GetNumGroupMembers() > 1) then
			NRC:updateRaidManaState();
		end
	elseif (event == "GROUP_LEFT") then
		NRC:updateRaidManaState();
	end
end)

--Keep changing mana values as the test runs.
local function testRaidMana()
	for k, v in pairs(testData) do
		local direction = math.random(1, 2);
		manaCacheTestData[v.name] = {
			maxMana = v.maxMana,
		};
		if (direction == 1) then
			manaCacheTestData[v.name].mana = math.random(v.mana, v.mana + 3);
		else
			manaCacheTestData[v.name].mana = math.random(v.mana - 3, v.mana);
		end
		if (manaCacheTestData[v.name].mana > 100) then
			manaCacheTestData[v.name].mana = 100;
		elseif (manaCacheTestData[v.name].mana < 0) then
			manaCacheTestData[v.name].mana = 0;
		end
	end
end

function NRC:startRaidManaTest(quiet)
	if (not NRC.config.raidManaEnabled) then
		NRC:print("Raid mana tracking is not enabled.");
		return;
	end
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	testRunningTimer = C_Timer.NewTicker(30, function()
		NRC:stopRaidManaTest();
	end, 1)
	if (not quiet) then
		NRC:print("|cFF00C800Started raid mana test for 30 seconds.");
	end
	testData = {
		[1] = {
			name = "Player1",
			class = "DRUID",
			specName = "Restoration",
			icon = 136041,
			mana = 72,
			maxMana = 100,
		},
		[2] = {
			name = "Player2",
			class = "PALADIN",
			specName = "Holy",
			icon = 135920,
			mana = 100,
			maxMana = 100,
		},
		[3] = {
			name = "Player3",
			class = "PRIEST",
			specName = "Holy",
			icon = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Blizzard\\Spell_Holy_GuardianSpirit", --Proper holy icon from future expansions.
			mana = 55,
			maxMana = 100,
		},
		[4] = {
			name = "Player4",
			class = "PRIEST",
			specName = "Discipline",
			icon = 135987,
			mana = 13,
			maxMana = 100,
		},
		[5] = {
			name = "Player5",
			class = "SHAMAN",
			specName = "Restoration",
			icon = 136052,
			mana = 46,
			maxMana = 100,
		},
		[6] = {
			name = "Player6",
			class = "SHAMAN",
			specName = "Restoration",
			icon = 136052,
			mana = 82,
			maxMana = 100,
		},
	};
	manaCacheTestData = {};
	for k, v in pairs(testData) do
		local direction = math.random(1, 2);
		manaCacheTestData[v.name] = {
			mana = v.mana,
			maxMana = v.maxMana,
		};
	end
	testRaidMana();
	if (testRunningTimer2) then
		testRunningTimer2:Cancel();
	end
	testRunningTimer2 = C_Timer.NewTicker(1, function()
		testRaidMana();
	end, 29)
	testRunning = true;
	NRC:raidManaUnlockFrames();
	NRC:updateRaidManaState();
	NRC:updateRaidManaFramesLayout();
	NRC:updateManaFrame();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:stopRaidManaTest()
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	if (testRunningTimer2) then
		testRunningTimer2:Cancel();
	end
	if (not NRC.allFramesTestRunning) then
		NRC:print("|cFF00C800Stopped Raid Mana Test.");
	end
	testData = nil;
	testRunning = nil;
	manaCacheTestData = nil;
	NRC:updateRaidManaFramesLayout();
	NRC:updateRaidManaState();
	NRC:updateManaFrame();
	NRC:raidManaUpdateFrameLocks();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:getRaidManaTestState()
	return testRunning;
end

function NRC:raidManaUpdateFrameLocks()
	if (raidManaFrame) then
		raidManaFrame.locked = NRC.config.lockAllFrames;
		NRC:raidManaUpdateFrameLocksLayout();
	end
end
	
function NRC:raidManaUpdateFrameLocksLayout()
	if (raidManaFrame) then
		if (raidManaFrame.locked and not raidManaFrame.firstRun) then
			raidManaFrame.displayTab:Hide();
			raidManaFrame.displayTab.top:Hide();
		else
			local text = "|cFFDEDE42Healer Mana|r\n"
				.. "|cFF9CD6DE" .. L["Drag Me"] .. "|r";
			raidManaFrame.displayTab:SetAlpha(0.3);
			raidManaFrame.displayTab.top.fs:SetText(text);
			raidManaFrame.displayTab.top:SetSize(100, 30);
			raidManaFrame.displayTab:Show();
			raidManaFrame.displayTab.top:Show();
		end
		NRC:updateRaidManaFramesLayout();
	end
	--NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:raidManaLockFrames()
	if (raidManaFrame) then
		raidManaFrame.locked = true;
	end
	NRC:raidManaUpdateFrameLocksLayout();
end

function NRC:raidManaUnlockFrames()
	if (raidManaFrame) then
		raidManaFrame.locked = false;
	end
	NRC:raidManaUpdateFrameLocksLayout();
end

function NRC:raidManaGetLockState()
	if (raidManaFrame) then
		return raidManaFrame.locked;
	end
end