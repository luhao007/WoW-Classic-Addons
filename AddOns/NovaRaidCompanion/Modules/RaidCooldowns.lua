-------------------------------------
---NovaRaidCompanion Raid Cooldowns--
-------------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local isDead = {};
local isGhost = {};
local hasResPending = {};
local hpCache = {};
local raidCooldowns, raidCooldownsSubFrames = {}, {};
local testData, testSoulstoneData, testRunning, testRunningTimer;
local trackedSpellsCache, resSpellsCache = {}, {};
local soulstoneSpellIDs = {};
local recycledFrames = {};
local encounterStart;
local units = NRC.units;
local UnitGUID = UnitGUID;
local UnitIsDead = UnitIsDead;
local UnitIsGhost = UnitIsGhost;
local IsInGroup = IsInGroup;
local GetServerTime = GetServerTime;
local GetTime = GetTime;
local UnitAura = UnitAura;
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local UnitName = UnitName;
local GetNormalizedRealmName = GetNormalizedRealmName;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local GetTalentInfo = GetTalentInfo;
local soulstoneDuration = 1800;
if (not NRC.isTBc and not NRC.isClassic) then
	soulstoneDuration = 900;
end
NRC.cooldownList = {};

local resSpellsCache = {};
local function loadResSpellsCache()
	resSpellsCache = {};
	for k, v in pairs(NRC.resurrectionSpells) do
		resSpellsCache[k] = v.name;
	end
end
loadResSpellsCache();

local function hasSpellsAssigned(frame)
	if (frame.lineFrames) then
		for k, v in pairs(frame.lineFrames) do
			if (v:IsShown()) then
				return true;
			end
		end
	end
end

--Create the intial frames at load time.
function NRC:loadRaidCooldownFrames()
	if (not NRC.config.showRaidCooldowns) then
		return;
	end
	local defaultFrameCoords = {
		[1] = {
			x = 0,
			y = 80,
		},
		[2] = {
			x = -180,
			y = 150,
		},
		[3] = {
			x = 180,
			y = 150,
		},
		[4] = {
			x = -180,
			y = 10,
		},
		[5] = {
			x = 180,
			y = 10,
		},
	};
	for i = 1, NRC.config.cooldownFrameCount do
		if (i > NRC.maxCooldownFrameCount) then
			break;
		end
		if (recycledFrames[i] and not raidCooldowns[i]) then
			raidCooldowns[i] = recycledFrames[i];
			raidCooldowns[i]:Show();
		elseif (not raidCooldowns[i]) then
			local frame = NRC:createListFrame("NRCRaidCooldowns" .. i, NRC.db.global.raidCooldownsWidth, NRC.db.global.raidCooldownsHeight, defaultFrameCoords[i].x, defaultFrameCoords[i].y, "Raid Cooldowns" .. i, nil, "");
			if (i == 1) then
				--Only 1 list should run the update func.
				frame.onUpdateFunction = "updateRaidCooldowns";
			end
			frame.updateLayoutFunc = "updateRaidCooldownFramesLayout";
			--frame.displayTab.top.fs:SetText("Cooldown List " .. i);
			frame:SetBackdropColor(0, 0, 0, 0);
			frame:SetBackdropBorderColor(1, 1, 1, 0);
			local point, _, relativePoint, x, y = frame:GetPoint();
			if (point == "CENTER" and x == frame.defaultX and y == frame.defaultY) then
				frame.firstRun = true;
				--frame.displayTab.fs:SetText(L["Hold Shift To Drag"]);
				--frame.updateTooltip("|cFFFFFF00" .. L["NRC Raid Cooldowns Frame"] .. " " .. i);
				--frame.displayTab:Show();
				--frame.displayTab.top:Show();
				NRC:raidCooldownsUnlockFrames();
				--Show frame so it can be dragged if fresh install.
				--frame:SetBackdropColor(0, 0, 0, 0.5);
				--frame:SetBackdropBorderColor(1, 1, 1, 0.2);
			end
			--frame.displayTab.fs:SetText(L["Hold Shift To Drag"]);
			raidCooldowns[i] = frame;
		end
	end
	--If this is first run after version update then convert old position settings for frame 1.
	if (NRC.db.global["NRCRaidCooldowns_point"] and not NRC.db.global["NRCRaidCooldowns1_point"]) then
		local frame = raidCooldowns[1];
		NRC.db.global[frame:GetName() .. "_point"] = NRC.db.global["NRCRaidCooldowns_point"];
		NRC.db.global[frame:GetName() .. "_relativePoint"] = NRC.db.global["NRCRaidCooldowns_relativePoint"];
		NRC.db.global[frame:GetName() .. "_x"] = NRC.db.global["NRCRaidCooldowns_x"];
		NRC.db.global[frame:GetName() .. "_y"] = NRC.db.global["NRCRaidCooldowns_y"];
		--NRC.db.global["NRCRaidCooldowns_point"] = nil;
		--NRC.db.global["NRCRaidCooldowns_relativePoint"] = nil;
		--NRC.db.global["NRCRaidCooldowns_x"] = nil;
		--NRC.db.global["NRCRaidCooldowns_y"] = nil;
		frame.ignoreFramePositionManager = true;
		frame:ClearAllPoints();
		frame:SetPoint(NRC.db.global[frame:GetName() .. "_point"], nil, NRC.db.global[frame:GetName() .. "_relativePoint"],
				NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"]);
		frame:SetUserPlaced(false);
		frame.firstRun = nil
		frame.hasBeenReset = nil
		frame.showTooltip = function() end;
		frame.tooltip.fs:SetText("");
		frame.fs:SetText("");
		frame.tooltip:Hide();
		frame:SetBackdropColor(0, 0, 0, 0);
		frame:SetBackdropBorderColor(1, 1, 1, 0);
	end
	--Hide any no longer used frames if rame count is lowered in config.
	for i = 1, NRC.maxCooldownFrameCount do
		if (i > NRC.config.cooldownFrameCount) then
			if (raidCooldowns[i]) then
				raidCooldowns[i]:Hide();
				--If frame count is lowered in config then store unused frames to get again later if needed.
				--This prevents more frames from being created if a user keeps sliding the frame count config up and down.
				recycledFrames[i] = raidCooldowns[i];
				raidCooldowns[i] = nil;
			end
		end
	end
	NRC:updateRaidCooldownFramesLayout();
	NRC:raidCooldownsUpdateFrameLocks();
end

local function sortCooldowns()
	local sort = NRC.db.global.raidCooldownsSortOrder;
	if (testRunning) then
		if (sort == 1) then
			table.sort(testData, function(a, b) return a.class < b.class end);
		elseif (sort == 2) then
			table.sort(testData, function(a, b) return a.class > b.class end);
		elseif (sort == 3) then
			table.sort(testData, function(a, b) return a.spellName < b.spellName end);
		elseif (sort == 4) then
			table.sort(testData, function(a, b) return a.spellName > b.spellName end);
		elseif (sort == 5) then
			table.sort(testData, function(a, b) return a.cooldown < b.cooldown end);
		elseif (sort == 6) then
			table.sort(testData, function(a, b) return a.cooldown > b.cooldown end);
		end
	else
		--On rare occasions inside a BG I've seen a missing element [1] from this table caus a lua error.
		--Not sure how that's possible but try fix it.
		--I think this was when the last person of a class left and it tried to remove that class spell using the old data format and not table.remove.
		--[[local t = {};
		for k, v in pairs(NRC.cooldownList) do
			tinsert(t, v);
		end
		NRC.cooldownList = {};
		for k, v in ipairs(t) do
			tinsert(NRC.cooldownList, v);
		end]]
		if (sort == 1) then
			--Bug hunting.
			local testDebug;
			--local count = 0;
			--local found;
			--Noticed an entry [1] missing in bgs.
			for k, v in ipairs(NRC.cooldownList) do
				--found = true;
				--count = count + 1;
				if (not v.class) then
					testDebug = true;
				end
			end
			if (testDebug) then
				NRC:debug(NRC.cooldownList);
			end
			table.sort(NRC.cooldownList, function(a, b) return a.class < b.class end);
		elseif (sort == 2) then
			table.sort(NRC.cooldownList, function(a, b) return a.class > b.class end);
		elseif (sort == 3) then
			table.sort(NRC.cooldownList, function(a, b) return a.spellName < b.spellName end);
		elseif (sort == 4) then
			table.sort(NRC.cooldownList, function(a, b) return a.spellName > b.spellName end);
		elseif (sort == 5) then
			table.sort(NRC.cooldownList, function(a, b) return a.cooldown < b.cooldown end);
		elseif (sort == 6) then
			table.sort(NRC.cooldownList, function(a, b) return a.cooldown > b.cooldown end);
		end
	end
end

--[[function NRC:updateRaidCooldownFramesTabs()
	for i = 1, NRC.maxCooldownFrameCount do
		local frame = raidCooldowns[i];
		if (frame) then
			if (testRunning) then
				if (hasSpellsAssigned(frame)) then
					frame.displayTab:Hide();
					frame.displayTab.top:Show();
				else
					frame.displayTab:Show();
					frame.displayTab.top:Show();
				end
			else
				local point, _, _, x, y = frame:GetPoint();
				if (point == "CENTER" and x == frame.defaultX and y == frame.defaultY) then
					frame.displayTab.top:Show();
					frame.displayTab:Show();
				else
					frame.displayTab:Hide();
					frame.displayTab.top:Hide();
				end
			end
			frame.clearAllPoints();
			frame.sortLineFrames();
		end
	end
end]]

local growthDirection;
function NRC:updateRaidCooldownFramesLayout()
	local db = NRC.db.global;
	for i = 1, NRC.config.cooldownFrameCount do
		local frame = raidCooldowns[i];
		frame.clearAllPoints();
		if (frame) then
			--Update borders.
			if (db.raidCooldownsBorderType == 2) then
				for k, v in pairs(frame.lineFrames) do
					v.borderFrame:Show();
					v:SetBackdrop({
						bgFile = "Interface\\Buttons\\WHITE8x8",
						insets = {top = 0, left = 0, bottom = 0, right = 0},
					});
				end
			else
				for k, v in pairs(frame.lineFrames) do
					v.borderFrame:Hide();
					v:SetBackdrop({
						bgFile = "Interface\\Buttons\\WHITE8x8",
						insets = {top = 0, left = 0, bottom = 0, right = 0},
						edgeFile = [[Interface/Buttons/WHITE8X8]], 
						edgeSize = 1,
					});
					v:SetBackdropBorderColor(1, 1, 1, 0.2);
				end
			end
			--Update size.
			frame:SetScale(db.raidCooldownsScale);
			--Update alpha.
			for k, v in pairs(frame.lineFrames) do
				v:SetBackdropColor(0, 0, 0, db.raidCooldownsBackdropAlpha);
				v:SetBackdropBorderColor(1, 1, 1, db.raidCooldownsBorderAlpha);
				v.borderFrame:SetBackdropBorderColor(1, 1, 1, db.raidCooldownsBorderAlpha);
			end
			--Update growth direction.
			frame.growthDirection = db.raidCooldownsGrowthDirection;
			frame.disableMouse = NRC.db.global.raidCooldownsDisableMouse
			if (frame.growthDirection == 1) then
				--Grow down so set info tab to the top.
				frame.displayTab.top:ClearAllPoints();
				frame.displayTab.top:SetPoint("BOTTOM", frame.displayTab, "TOP", 0, -2);
				frame.displayTab.top:SetBackdrop({
					bgFile = "Interface\\Buttons\\WHITE8x8",
					edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoBottom2",
					tileEdge = true,
					edgeSize = 8,
					insets = {top = 3, left = 2, bottom = 2, right = 2},
				});
				frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
			else
				--Grow upwards so set info tab to the bottom.
				frame.displayTab.top:ClearAllPoints();
				frame.displayTab.top:SetPoint("TOP", frame.displayTab, "BOTTOM", 0, 2);
				frame.displayTab.top:SetBackdrop({
					bgFile = "Interface\\Buttons\\WHITE8x8",
					edgeFile = "Interface\\Addons\\NovaRaidCompanion\\Media\\UI-Tooltip-Border-NoTop2",
					tileEdge = true,
					edgeSize = 8,
					insets = {top = 2, left = 2, bottom = 3, right = 2},
				});
				frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
			end
			local text = "|cFFDEDE42Cooldown List " .. i .. "|r\n"
						.. "|cFF9CD6DE" .. L["Drag Me"] .. "|r";
			frame.displayTab:SetAlpha(0.3);
			frame.displayTab.top.fs:SetText(text);
			frame.displayTab.top:SetSize(100, 30);
			
			frame.lineFrameWidth = db.raidCooldownsWidth;
			frame.lineFrameHeight = db.raidCooldownsHeight;
			frame.updateDimensions();
			
			frame.lineFrameFont = db.raidCooldownsFont;
			frame.lineFrameFontNumbers = db.raidCooldownsFontNumbers;
			frame.lineFrameFontSize = db.raidCooldownsFontSize;
			frame.lineFrameFontOutline = db.raidCooldownsFontOutline;
			
			for k, v in pairs(frame.lineFrames) do
				v.fs:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize, db.raidCooldownsFontOutline);
				v.fs2:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize - 1, db.raidCooldownsFontOutline);
				v.fs3:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize - 1, db.raidCooldownsFontOutline);
				v.fs4:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFontNumbers), db.raidCooldownsFontSize + 1, db.raidCooldownsFontOutline);
				if (v.subFrame) then
					v.subFrame.lineFrameWidth = db.raidCooldownsWidth;
					v.subFrame.lineFrameHeight = db.raidCooldownsHeight;
					v.subFrame.updateDimensions();
					for kk, vv in pairs(v.subFrame.lineFrames) do
						vv.fs:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize, db.raidCooldownsFontOutline);
						vv.fs2:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize - 1, db.raidCooldownsFontOutline);
						vv.fs3:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), db.raidCooldownsFontSize - 1, db.raidCooldownsFontOutline);
						vv.fs4:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFontNumbers), db.raidCooldownsFontSize + 1, db.raidCooldownsFontOutline);
					end
				end
				
				--[[v.fs:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 8);
				v.fs2:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 9);
				v.fs3:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 9);
				v.fs4:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFontNumbers), frame.lineFrameHeight - 7);
				if (v.subFrame) then
					for kk, vv in pairs(v.subFrame.lineFrames) do
						vv.fs:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 8);
						vv.fs2:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 9);
						vv.fs3:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFont), frame.lineFrameHeight - 9);
						vv.fs4:SetFont(NRC.LSM:Fetch("font", db.raidCooldownsFontNumbers), frame.lineFrameHeight - 7);
					end
				end]]
			end
		end
	end
	--[[for i = 1, NRC.maxCooldownFrameCount do
		local frame = raidCooldowns[i];
		if (frame) then
			if (testRunning) then
				if (hasSpellsAssigned(frame)) then
					frame.displayTab:Hide();
					frame.displayTab.top:Show();
				else
					frame.displayTab:Show();
					frame.displayTab.top:Show();
				end
			else
				local point, _, _, x, y = frame:GetPoint();
				if (point == "CENTER" and x == frame.defaultX and y == frame.defaultY) then
					frame.displayTab.top:Show();
					frame.displayTab:Show();
				else
					frame.displayTab:Hide();
					frame.displayTab.top:Hide();
				end
			end
			frame.clearAllPoints();
			frame.sortLineFrames();
		end
	end]]
	sortCooldowns();
	NRC:updateRaidCooldowns();
end

function NRC:isValidCooldown(spellID)
	for k, v in pairs(NRC.cooldowns) do
		if (v.spellIDs) then
			for id, spellName in pairs(v.spellIDs) do
				if (id == spellID) then
					return true;
				end
			end
		end
	end
end

local function getIconFromCooldownsSpellID(spellID)
	for k, v in pairs(NRC.cooldowns) do
		if (v.spellIDs) then
			for id, spellName in pairs(v.spellIDs) do
				if (id == spellID) then
					return v.icon;
				end
			end
		end
	end
end

function NRC:isCooldownEnabled(spellID)
	for k, v in pairs(NRC.cooldowns) do
		if (v.spellIDs) then
			for id, spellName in pairs(v.spellIDs) do
				if (id == spellID) then
					if (NRC.config["raidCooldown" .. string.gsub(k, " ", "")]) then
						return true;
					end
				end
			end
		end
	end
end

--Add faction specific spells.
if (NRC.faction == "Alliance") then
	NRC.cooldowns["Heroism"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\ability_shaman_heroism",
		cooldown = 600,
		minLevel = 70,
		spellIDs = {
			[32182] = "Heroism", --Rank 1.
		},
	};
else
	NRC.cooldowns["Bloodlust"] = {
		class = "SHAMAN",
		icon = "Interface\\Icons\\spell_nature_bloodlust",
		cooldown = 600,
		minLevel = 70,
		spellIDs = {
			[2825] = "Bloodlust", --Rank 1.
		},
	};
end

--Add texture and localized spell name to our cooldowns.
function NRC:buildCooldownData()
	local localizeNames;
	if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW or LOCALE_ruRU) then
		localizeNames = true;
	end
	for k, v in pairs(NRC.cooldowns) do
		if (v.spellIDs and next(v.spellIDs)) then
			for id, spellName in pairs(v.spellIDs) do
				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(id);
				if (name) then
					--Update table with locale spell names.
					--v.spellIDs[id] = name;
					if (localizeNames) then
						if (k == "Soulstone") then
							local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(20763);
							if (name) then
								v.localizedName = name;
							end
						else
							v.localizedName = name;
						end
					end
					--Add spell to cache for scanning combat log.
					trackedSpellsCache[id] = spellName;
				end
				if (k == "Rebirth") then
					--Add battle res to our res spell cache.
					resSpellsCache[id] = spellName;
				end
				if (k == "Soulstone") then
					soulstoneSpellIDs[id] = spellName;
				end
			end
		end
	end
end

--Check the whole group for any chars with cooldowns to track.
--Used when we join a new group or relog/reload.
function NRC:loadRaidCooldownGroup()
	--Reset table for full group check.
	NRC.cooldownList = {};
	for name, data in pairs(NRC.groupCache) do
		if (data.guid) then
			for k, v in pairs(NRC.cooldowns) do
				if (NRC.config["raidCooldown" .. string.gsub(k, " ", "")] and data.class == v.class
						and (not data.level or data.level >= v.minLevel)) then
					local hasTalent;
					if (v.talentOnly) then
						hasTalent = NRC:hasTalent(name, v.talentOnly.tabIndex, v.talentOnly.talentIndex, 1);
					end
					if (not v.talentOnly or hasTalent) then
						--Create spell data if doesn't already exist.
						local index;
						--Check if cooldown is already in the table.
						for i, cd in pairs(NRC.cooldownList) do
							if (k == cd.spellName) then
								index = i;
								break;
							end
						end
						if (not index) then
							index = #NRC.cooldownList + 1;
							NRC.cooldownList[index] = {
								spellName = k;
								class = v.class,
								cooldown = v.cooldown,
								icon = v.icon,
								spellIDs = {},
								chars = {},
								color = v.color,
								title = v.title,
								localizedName = v.localizedName,
								merged = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"],
								frame = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Frame"],
							};
							--Add id's for each rank of this spell.
							if (v.spellIDs and next(v.spellIDs)) then
								for id, spellName in pairs(v.spellIDs) do
									--Add spell to cache for scanning combat log.
									trackedSpellsCache[id] = spellName;
									--Add spell to the track list for this character.
									NRC.cooldownList[index].spellIDs[id] = spellName;
								end
							end
						end
						--Attach character to this spell for watching.
						if (not NRC.cooldownList[index].chars[data.guid]) then
							NRC.cooldownList[index].chars[data.guid] = {
								name = name,
								class = data.class,
								endTime = 0,
							};
						end
						--Load time from saved data if it exists.
						if (NRC.data.raidCooldowns[data.guid] and NRC.data.raidCooldowns[data.guid][k]) then
							NRC.cooldownList[index].chars[data.guid].endTime = NRC.data.raidCooldowns[data.guid][k].endTime;
							NRC.cooldownList[index].chars[data.guid].destName = NRC.data.raidCooldowns[data.guid][k].destName;
							NRC.cooldownList[index].chars[data.guid].destClass = NRC.data.raidCooldowns[data.guid][k].destClass;
						end
					end
				end
			end
		end
	end
	--NRC:loadRaidCooldownsWhenUsed();
	NRC:loadPartyNeckBuffs();
	NRC:sreAddRaidCooldownsToSpellList();
end

--Check a single character for cooldowns to track when they join group.
--If cooldownName is passed then we track this spell for this player without class checks (for neck buffs etc).
function NRC:loadRaidCooldownChar(name, data, cooldownName)
	--NRC:debug("loading char", name, data, cooldownName);
	for k, v in pairs(NRC.cooldowns) do
		if (NRC.config["raidCooldown" .. string.gsub(k, " ", "")] and (v.class == data.class or cooldownName == k)
				and (not data.level or data.level >= v.minLevel)) then
			local hasTalent;
			if (v.talentOnly) then
				hasTalent = NRC:hasTalent(name, v.talentOnly.tabIndex, v.talentOnly.talentIndex, 1);
			end
			if (not v.talentOnly or hasTalent) then
				--Create spell data if doesn't already exist.
				local index;
				--Check if cooldown is already in the table.
				for i, cd in pairs(NRC.cooldownList) do
					if (k == cd.spellName) then
						index = i;
						break;
					end
				end
				if (not index) then
					index = #NRC.cooldownList + 1;
					NRC.cooldownList[index] = {
						spellName = k;
						class = v.class,
						cooldown = v.cooldown,
						icon = v.icon,
						spellIDs = {},
						chars = {},
						color = v.color,
						title = v.title,
						localizedName = v.localizedName,
						merged = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"],
						frame = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Frame"],
					};
					--Add id's for each rank of this spell.
					if (v.spellIDs and next(v.spellIDs)) then
						for id, spellName in pairs(v.spellIDs) do
							--Add spell to cache for scanning combat log.
							trackedSpellsCache[id] = spellName;
							--Add spell to the track list for this character.
							NRC.cooldownList[index].spellIDs[id] = spellName;
						end
					end
				end
				--Attach character to this spell for watching.
				if (not NRC.cooldownList[index].chars[data.guid]) then
					if (not data.guid) then
						NRC:debug("Cooldown guid missing for:", name);
						--NRC:debug(data);
					else
						NRC.cooldownList[index].chars[data.guid] = {
							name = name,
							class = data.class,
							endTime = 0,
						};
					end
				end
				--Load time from saved data if it exists.
				if (NRC.data.raidCooldowns[data.guid] and NRC.data.raidCooldowns[data.guid][k]) then
					NRC.cooldownList[index].chars[data.guid].endTime = NRC.data.raidCooldowns[data.guid][k].endTime;
					NRC.cooldownList[index].chars[data.guid].destName = NRC.data.raidCooldowns[data.guid][k].destName;
					NRC.cooldownList[index].chars[data.guid].destClass = NRC.data.raidCooldowns[data.guid][k].destClass;
				end
			end
		end
	end
	--NRC:loadRaidCooldownsWhenUsed();
	--NRC:updateRaidCooldowns();
	NRC:sreAddRaidCooldownsToSpellList();
end

--Update all chars from data or single if guid supplied.
function NRC:updateRaidCooldownsFromDatabase(playerGuid)
	for index, cooldownData in pairs(NRC.cooldownList) do
		--spellName is a bit confusing because I named some tables badly.
		--Sometimes it's what the cooldown is called in the table, but in some subtables it's the localized spell name.
		--These 2 different types don't clash but we need to make sure which one we're looking at when creating functions.
		--In this data set it's the table name.
		local tableName = cooldownData.spellName;
		for guid, cooldownStatus in pairs(cooldownData.chars) do
			--If we supply a guid then only update this player.
			if (not playerGuid or playerGuid == guid) then
				--Check the saved database for any cooldowns for this guid.
				if (NRC.data.raidCooldowns[guid]) then
					local cooldownName = NRC.data.raidCooldowns[guid]
					for cooldownName, cooldownData in pairs(NRC.data.raidCooldowns[guid]) do
						if (tableName == cooldownName and cooldownData.endTime and cooldownData.endTime > GetServerTime()) then
							--NRC:debug("Adding cooldown from db:", tableName)
							NRC.cooldownList[index].chars[guid].endTime = cooldownData.endTime;
							NRC.cooldownList[index].chars[guid].destName = cooldownData.destName;
							NRC.cooldownList[index].chars[guid].destClass = cooldownData.destClass;
						end
					end
				end
			end
		end
	end
end

--Remove single character when they leave group.
function NRC:removeRaidCooldownChar(guid)
	--NRC:debug("removing char", guid);
	for k, v in pairs(NRC.cooldownList) do
		for char, charData in pairs(v.chars) do
			if (char == guid) then
				v.chars[guid] = nil;
			end
		end
	end
	--If no chars are being tracked for this spell then remove it.
	--Iterate in reverse when removing elements.
	for i = #NRC.cooldownList, 1, -1 do
		local data = NRC.cooldownList[i];
		if (not next(data.chars)) then
			table.remove(NRC.cooldownList, i);
		end
	end
	--[[for k, v in pairs(NRC.cooldownList) do
		if (not next(v.chars)) then
			--NRC.cooldownList[k] = nil;
			table.remove(NRC.cooldownList, k);
		end
	end]]
	NRC:soulstoneRemoved(guid);
	NRC:updateRaidCooldowns();
end

--In wrath some cooldowns are reset after boss kill or wipe, if in combat and encounter lasted 30 seconds?
function NRC:removeRaidCooldownsEncounterEnd(success)
	if (NRC.isClassic or NRC.isTBC) then
		return;
	end
	local ignoreList = { --https://us.forums.blizzard.com/en/wow/t/raid-system-adjustments-in-wrath-of-the-lich-king-classic/1307037/235
		["Army of the Dead"] = true,
		["Lay on Hands"] = true,
		["Fire Elemental Totem"] = true,
		["Earth Elemental Totem"] = true,
		["Astral Recall"] = true,
		["Reincarnation"] = true,
		["Ritual of Doom"] = true,
	};
	NRC:debug("removing cooldowns encounter end");
	for k, v in pairs(NRC.cooldownList) do
		if (not ignoreList[v.spellName]) then
			for guid, charData in pairs(v.chars) do
				charData.endTime = 0;
				if (NRC.data.raidCooldowns[guid] and NRC.data.raidCooldowns[guid][v.spellName]) then
					--Spellname recoded to db here is from spellIDs table, not cooldown name.
					NRC.data.raidCooldowns[guid][v.spellName].endTime = 0;
				end
			end
		end
	end
	NRC:updateRaidCooldowns();
end

function NRC:loadPartyNeckBuffs()
	--Wipe current party list.
	NRC.cooldownList["NeckSP"] = nil;
	NRC.cooldownList["NeckCrit"] = nil;
	NRC.cooldownList["NeckCritRating"] = nil;
	NRC.cooldownList["NeckStam"] = nil;
	NRC.cooldownList["NeckHP5"] = nil;
	NRC.cooldownList["NeckStats"] = nil;
	if (NRC.config.raidCooldownsNecksRaidOnly and not IsInRaid()) then
		return;
	end
	if (GetNumGroupMembers() < 2) then
		return;
	end
	for i = 1, 5 do
		local name = UnitName("party" .. i);
		local data = NRC.groupCache[name];
		if (data) then
			if (NRC.config["raidCooldownNeckSP"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckSP");
			end
			if (NRC.config["raidCooldownNeckCrit"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckCrit");
			end
			if (NRC.config["raidCooldownNeckCritRating"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckCritRating");
			end
			if (NRC.config["raidCooldownNeckStam"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckStam");
			end
			if (NRC.config["raidCooldownNeckHP5"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckHP5");
			end
			if (NRC.config["raidCooldownNeckStats"]) then
				NRC:loadRaidCooldownChar(name, data, "NeckStats");
			end
		end
	end
	local name = UnitName("player");
	local data = NRC.groupCache[name];
	if (data) then
		if (NRC.config["raidCooldownNeckSP"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckSP");
		end
		if (NRC.config["raidCooldownNeckCrit"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckCrit");
		end
		if (NRC.config["raidCooldownNeckCritRating"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckCritRating");
		end
		if (NRC.config["raidCooldownNeckStam"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckStam");
		end
		if (NRC.config["raidCooldownNeckHP5"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckHP5");
		end
		if (NRC.config["raidCooldownNeckStats"]) then
			NRC:loadRaidCooldownChar(name, data, "NeckStats");
		end
	end
	NRC:sreAddRaidCooldownsToSpellList();
end

--Check spells currently on CD for any that need to be shown only when on CD.
--[[function NRC:loadRaidCooldownsWhenUsed()
	--NRC:debug("loading only show when used");
	for guid, v in pairs(NRC.data.raidCooldowns) do
		for spellName, spellData in pairs(v) do
			if (NRC.cooldowns[spellName] and NRC.cooldowns[spellName].onlyLoadWhenUsed) then
				NRC:reloadRaidCooldownsWhenUsed(spellData.spellID, guid);
			end
		end
	end
end

--Reload a spell that only shows when on CD.
function NRC:reloadRaidCooldownsWhenUsed(spellID, guid)
	--NRC:debug("reloading only show when used", spellID, guid);
	local data = NRC:getCharDataFromGUID(guid);
	if (data) then
		for k, v in pairs(NRC.cooldowns) do
			if (v.onlyLoadWhenUsed and NRC.config["raidCooldown" .. string.gsub(k, " ", "")] and (not data.level or data.level >= v.minLevel)) then
				--Create spell data if doesn't already exist.
				if (not NRC.cooldownList[k]) then
					NRC.cooldownList[k] = {
						class = v.class,
						cooldown = v.cooldown,
						icon = v.icon,
						spellIDs = {},
						chars = {},
						color = v.color,
						title = v.title,
						localizedName = v.localizedName,
						merged = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"],
						frame = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Frame"],
					};
					--Add id's for each rank of this spell.
					if (v.spellIDs and next(v.spellIDs)) then
						for id, spellName in pairs(v.spellIDs) do
							--Add spell to cache for scanning combat log.
							trackedSpellsCache[id] = spellName;
							--Add spell to the track list for this character.
							NRC.cooldownList[k].spellIDs[id] = spellName;
						end
					end
				end
				--Attach character to this spell for watching.
				if (not NRC.cooldownList[k].chars[data.guid]) then
					NRC.cooldownList[k].chars[data.guid] = {
						name = name,
						class = data.class,
						endTime = 0,
					};
				end
				--Load time from saved data if it exists.
				if (NRC.data.raidCooldowns[data.guid] and NRC.data.raidCooldowns[data.guid][k]) then
					NRC.cooldownList[k].chars[data.guid].endTime = NRC.data.raidCooldowns[data.guid][k].endTime;
					NRC.cooldownList[k].chars[data.guid].destName = NRC.data.raidCooldowns[data.guid][k].destName;
					NRC.cooldownList[k].chars[data.guid].destClass = NRC.data.raidCooldowns[data.guid][k].destClass;
				end
			end
		end
	end
	--NRC:updateRaidCooldowns();
end]]

--Get cooldown name and spellName from spellID.
function NRC:getCooldownFromSpellID(spellID)
	for k, v in pairs(NRC.cooldowns) do
		if (v.spellIDs and next(v.spellIDs)) then
			for id, spellName in pairs(v.spellIDs) do
				if (id == spellID) then
					--Return cooldown name and actual spell name.
					--They can be different for things like soulstone.
					--k is spellTableName.
					return k, spellName, v.cooldown, k;
				end
			end
		end
	end
end

--Adjust cooldown time if a player has talents that change it.
--spell arg is the name of the spell in cooldowns table not the display name.
--This is only used when updating cooldowns being used so by table name is the most efficiant.
--Another func iterating the cooldowns table and checking spellIDs should be made later.
function NRC:adjustCooldownFromTalents(spell, name, timestamp)
	if (NRC.cooldowns[spell]) then
		local data = NRC.cooldowns[spell].cooldownAdjust;
		if (data) then
			local talentCount = NRC:getTalentCount(name, data.tabIndex, data.talentIndex);
			if (data[talentCount]) then
				timestamp = timestamp - data[talentCount];
			end
		end
		--In wrath some spells have 2 talents that can effect cooldown.
		local data2 = NRC.cooldowns[spell].cooldownAdjust2;
		if (data2) then
			local talentCount = NRC:getTalentCount(name, data.tabIndex, data.talentIndex);
			if (data[talentCount]) then
				timestamp = timestamp - data[talentCount];
			end
		end
	end
	return timestamp;
end

--If a cooldown is used then update our data.
--This should probably use some kind of neater cache later on.
--cooldownTime arg is only used by spells that have talents effecting cooldown time (like reincarnation).
function NRC:updateCooldownList(sourceGUID, sourceName, destGUID, destName, destClass, spellID, cooldownTime)
	local update;
	for spell, spellData in pairs(NRC.cooldownList) do
		if (spellData.spellIDs and next(spellData.spellIDs)) then
			for trackedSpellID, spellName in pairs(spellData.spellIDs) do
				if (trackedSpellID == spellID) then
					for char, charData in pairs(spellData.chars) do
						if (char == sourceGUID) then
							if (cooldownTime) then
								--If we supplied a cooldown arg then use that instead.
								charData.endTime = GetServerTime() + cooldownTime;
							else
								charData.endTime = GetServerTime() + spellData.cooldown;
							end
							charData.endTime = NRC:adjustCooldownFromTalents(spellData.spellName, sourceName, charData.endTime);
							charData.destName = destName;
							charData.destClass = destClass;
							local cooldownName, spellName = NRC:getCooldownFromSpellID(spellID);
							if (cooldownName) then
								if (not NRC.data.raidCooldowns[sourceGUID]) then
									NRC.data.raidCooldowns[sourceGUID] = {};
								end
								if (not NRC.data.raidCooldowns[sourceGUID][cooldownName]) then
									NRC.data.raidCooldowns[sourceGUID][cooldownName] = {};
								end
								NRC.data.raidCooldowns[sourceGUID][cooldownName].endTime = charData.endTime;
								NRC.data.raidCooldowns[sourceGUID][cooldownName].spellName = spellName;
								NRC.data.raidCooldowns[sourceGUID][cooldownName].spellID = spellID;
								NRC.data.raidCooldowns[sourceGUID][cooldownName].destName = destName;
								NRC.data.raidCooldowns[sourceGUID][cooldownName].destClass = destClass;
							end
							update = true;
							break;
						end
					end
				end
			end
		end
	end
	--NRC:reloadRaidCooldownsWhenUsed(spellID, sourceGUID);
	if (update) then
		NRC:updateRaidCooldowns();
	else
		--If the spell was not being tracked then we need to add it to the DB incase it's enabled after.
		local cooldownName, spellName, cooldown, spellTableName = NRC:getCooldownFromSpellID(spellID);
		local endTime = 0;
		if (cooldownName) then
			if (cooldownTime) then
				--If we supplied a cooldown arg then use that instead.
				endTime = GetServerTime() + cooldownTime;
			else
				endTime = GetServerTime() + cooldown;
			end
			endTime = NRC:adjustCooldownFromTalents(spellTableName, sourceName, endTime);
			if (not NRC.data.raidCooldowns[sourceGUID]) then
				NRC.data.raidCooldowns[sourceGUID] = {};
			end
			if (not NRC.data.raidCooldowns[sourceGUID][cooldownName]) then
				NRC.data.raidCooldowns[sourceGUID][cooldownName] = {};
			end
			NRC.data.raidCooldowns[sourceGUID][cooldownName].endTime = endTime;
			NRC.data.raidCooldowns[sourceGUID][cooldownName].spellName = spellName;
			NRC.data.raidCooldowns[sourceGUID][cooldownName].spellID = spellID;
			NRC.data.raidCooldowns[sourceGUID][cooldownName].destName = destName;
			NRC.data.raidCooldowns[sourceGUID][cooldownName].destClass = destClass;
		end
	end
end

local disabled;
function NRC:updateRaidCooldownsVisibility()
	for i = 1, NRC.config.cooldownFrameCount do
		local frame = raidCooldowns[i];
		if (frame) then
			if (not NRC.config.showRaidCooldowns) then
				frame:Hide();
			else
				frame:Show();
			end
		end
	end
	disabled = nil;
	if (GetNumGroupMembers() < 2 or not NRC.config.showRaidCooldowns) then
		disabled = true;
	end
	if (not NRC.config.showRaidCooldownsInRaid and IsInRaid()) then
		disabled = true;
	end
	if (not NRC.config.showRaidCooldownsInParty and IsInGroup() and not IsInRaid()) then
		disabled = true;
	end
	if (not NRC.config.showRaidCooldownsInBG and (UnitInBattleground("player") or NRC:isInArena())) then
		disabled = true;
	end
	NRC:updateRaidCooldowns();
	NRC:updateSoulstoneFrame();
end

local function sendClick(button, name, class, timeLeft, spell)
	local spellID;
	for k, v in pairs(NRC.cooldowns) do
		if (k == spell and v.spellIDs) then
			--Get last spellID in table.
			for id, _ in NRC:pairsByKeys(v.spellIDs) do
				spellID = id;
			end
		end
	end
	local ignoreList = {
		["Divine Shield"] = true,
	};
	if (spellID and class) then
		if (not ignoreList[spell]) then
			local type;
			local _, _, _, classHex = GetClassColor(class);
			local colorizedName = "|c" .. classHex .. name .. "|r";
			if (button == "LeftButton") then
				if (IsShiftKeyDown()) then
					type = NRC.config.raidCooldownsShiftLeftClick;
				else
					type = NRC.config.raidCooldownsLeftClick;
				end
			elseif (button == "RightButton") then
				if (IsShiftKeyDown()) then
					type = NRC.config.raidCooldownsShiftRightClick;
				else
					type = NRC.config.raidCooldownsRightClick;
				end
			end
			local spellLink = GetSpellLink(spellID);
			if (type == 2) then
				if (name ~= UnitName("player")) then
					if (timeLeft > 0) then
						local minutes = string.format("%02.f", math.floor(timeLeft / 60));
						local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
						print("|cFFFFFF00" .. string.format(L["cooldownNotReadyMsg"], colorizedName, spellLink, "|cFF9CD6DE(" .. minutes .. ":" .. seconds .. ")|r"));
					else
						SendChatMessage(string.format(L["raidCooldownsClickWhisperCastOnMe"], spellLink), "WHISPER", nil, name);
					end
				end
			elseif (type == 3) then
				if (timeLeft > 0) then
					local minutes = string.format("%02.f", math.floor(timeLeft / 60));
					local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
					NRC:sendGroup(string.format(L["raidCooldownsClickGroupChatNotReady"], name, spellLink, minutes .. ":" .. seconds));
				else
					NRC:sendGroup(string.format(L["raidCooldownsClickGroupChatReady"], name, spellLink));
				end
			end
		else
			print("|cFFFFFF00" .. L["selfOnlyCooldownMsg"]);
		end
	end
end
--Refresh the cooldown frames.
--This can be made much more efficient with the way it handles updating frames later.
local soulstoneBars = {};
function NRC:updateRaidCooldowns()
	if (disabled) then
		if (not testData) then
			if (not NRC.config.showRaidCooldownsInBG and (UnitInBattleground("player") or NRC:isInArena())) then
				--Wait until we zone out to re-enable the frame, register event on one frame only.
				if (raidCooldowns[1]) then
					raidCooldowns[1]:RegisterEvent("PLAYER_ENTERING_WORLD");
					raidCooldowns[1]:SetScript('OnEvent', function(self, event, ...)
						if (event == "PLAYER_ENTERING_WORLD") then
							C_Timer.After(1, function()
								raidCooldowns[1]:UnregisterEvent("PLAYER_ENTERING_WORLD");
								NRC:updateRaidCooldownsVisibility();
								NRC:updateRaidCooldowns();
							end)
						end
					end)
				end
			end
			--IsInGroup() won't work as a check here, you are in a group when inviting someone but they haven't joined yet.
			--If GetNumGroupMembers() is below 2 then IsInGroup() can be true but we're not actually in a group.
			for frameID, frame in ipairs(raidCooldowns) do
				for k, v in ipairs(frame.lineFrames) do
					--Hide all frames if we're not in a group.
					v.enabled = false;
				end
				frame:sortLineFrames();
			end
			NRC:updateSoulstoneFrame();
			return;
		end
	end
	--Load full cooldown list if this is a group join.
	--This shouldn't run unless there's a problem or a /reload, chars are added as they are found in the group roster.
	local cooldownList;
	if (testRunning and next(testData)) then
		cooldownList = testData;
	else
		if (not next(NRC.cooldownList)) then
			NRC:loadRaidCooldownGroup();
		end
		cooldownList = NRC.cooldownList;
	end
	local count = {};
	for i = 1, NRC.config.cooldownFrameCount do
		count[i] = 0;
	end
	local lastLineFrame = {};
	--raidCooldowns.fs:SetText("");
	for spell, spellData in NRC:pairsByKeys(cooldownList) do
	--for spell, spellData in ipairs(cooldownList) do
		--if (NRC.config.mergeRaidCooldowns) then
		local frameNum = spellData.frame;
		if (raidCooldowns[frameNum]) then
			if (spellData.merged) then
				local lowestCD = 9999999999;
				--Merged cooldown list.
				--Show a list of cooldowns, and a list of players if you hover over it.
				count[frameNum] = count[frameNum] + 1;
				--Create line frame.
				local lineFrame = raidCooldowns[spellData.frame]:getLineFrame(count[frameNum]);
				lineFrame.enabled = true;
				--Create subframes.
				local subFrameCount, readyCount = 0, 0;
				local lineSubFrame;
				for guid, charData in NRC:pairsByKeys(spellData.chars) do
					subFrameCount = subFrameCount +1;
					--Create a new line frames parent if it doesn't exist.
					if (not lineFrame.subFrame) then
						--NRC:debug("created sub frame", count);
						lineFrame.subFrame = NRC:createListFrame("NRCRaidCooldownsSF" .. frameNum .. count[frameNum], 150, 20, 0, 0, nil, true);
						lineFrame.subFrame:SetParent(lineFrame);
						lineFrame.subFrame:SetFrameStrata("HIGH");
						lineFrame.subFrame:SetFrameLevel(9);
						lineFrame.subFrame:ClearAllPoints();
						lineFrame.subFrame.isSubFrame = true;
						lineFrame.subFrame:Hide();
					end
					local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
					--Sometimes this fails, just set name unknown it will fix in a later iteration.
					if (not name) then
						name, realm = "Unknown", "Unknown";
					end
					if (testRunning) then
						name = charData.name;
						realm = NRC.realm;
					end
					local rawName = name;
					lineSubFrame = lineFrame.subFrame:getLineFrame(subFrameCount);
					lineSubFrame:SetBackdropColor(0, 0, 0, 1);
					lineSubFrame:SetBackdropBorderColor(1, 1, 1, 8);
					lineSubFrame.enabled = true;
					--Shorten name if it's long.
					if (LOCALE_koKR) then
						name = strsub(name, 1, 30);
					else
						name = strsub(name, 1, 12);
					end
					if (charData.class) then
						local _, _, _, classHex = GetClassColor(charData.class);
						name = "|c" .. classHex .. name .. "|r";
					end
					lineSubFrame.fs:SetText(name);
					local endTime = charData.endTime or 0;
					if (endTime < lowestCD) then
						lowestCD = endTime;
					end
					local timeLeft = endTime - GetServerTime();
					if (timeLeft > 0) then
						local minutes = string.format("%02.f", math.floor(timeLeft / 60));
						local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
						lineSubFrame.fs2:SetText(minutes .. ":" .. seconds);
					else
						readyCount = readyCount + 1;
						lineSubFrame.fs2:SetText("|cFF00C800" .. L["Ready"]);
					end
					lineSubFrame.texture:SetTexture(spellData.icon);
					local text = name;
					--if (NRC.groupCache[rawName] and NRC.groupCache[rawName].level and NRC.groupCache[rawName].level > 0) then
					--	text = text .. " " .. NRC.groupCache[rawName].level .. "|r"
					--end
					if (NRC.groupCache[rawName] and NRC.groupCache[rawName].zone) then
						if (NRC.groupCache[rawName].zone == "Offline" and NRC.groupCache[rawName].lastKnownZone) then
							text = text .. "\n" .. NRC.groupCache[rawName].lastKnownZone .. "|r";
							text = text .. "\n(" .. PLAYER_OFFLINE .. ")";
						elseif (not NRC.groupCache[rawName].online) then
							text = text .. "\n(" .. PLAYER_OFFLINE .. ")";
						else
							text = text .. "\n" .. NRC.groupCache[rawName].zone .. "|r"
						end
					end
					if (timeLeft > 0) then
						local destName;
						if (charData.destName) then
							destName = charData.destName;
							local _, _, _, classHex = GetClassColor(charData.destClass);
							destName = "|c" .. classHex .. destName .. "|r";
						elseif (NRC.data.raidCooldowns[guid] and NRC.data.raidCooldowns[guid][spell]
								and NRC.data.raidCooldowns[guid][spell].destName) then
							destName = NRC.data.raidCooldowns[guid][spell].destName;
							local _, _, _, classHex = GetClassColor(NRC.data.raidCooldowns[guid][spell].destClass);
							destName = "|c" .. classHex .. destName .. "|r";
						end
						if (destName) then
							text = text .. "\n|cFFDEDE42" .. L["Cast on"] .. " ->|r " .. destName .. "|r";
						end
					end
					if (charData.class == "WARLOCK" and next(NRC.data.hasSoulstone)) then
						text = text .. "\n|cFF9CD6DE" .. L["Current active soulstones"] .. ":|r";
						for ssGuid, ssTime in pairs(NRC.data.hasSoulstone) do
							local _, classEnglish, _, _, _, name = GetPlayerInfoByGUID(ssGuid);
							if (name) then
								local _, _, _, classHex = GetClassColor(classEnglish);
								name = "|c" .. classHex .. name .. "|r";
								local timeLeft = NRC:getTimeString(ssTime - GetServerTime(), true, "short");
								text = text .. "\n" .. name .. " " .. timeLeft .. " " .. L["left"] .. ".";
							end
						end
					end
					lineSubFrame.updateTooltip(text);
					for k, v in ipairs(lineFrame.subFrame.lineFrames) do
						if (v.count > subFrameCount and v.enabled) then
							v.enabled = false;
						end
					end
					lineSubFrame:SetScript("OnClick", function(self, button)
						sendClick(button, rawName, charData.class, timeLeft, spellData.spellName);
					end)
				end
				--raidCooldowns:SetPoint("BOTTOM", lineSubFrame);
				--Shorten name if it's long.
				--local spellName = strsub(spell, 1, 15);
				local spellName = strsub(spellData.spellName, 1, 15);
				local classHex = spellData.color or select(4, GetClassColor(spellData.class));
				--local _, _, _, classHex = GetClassColor(spellData.class);
				if (spellData.title) then
					spellName = strsub(spellData.title, 1, 15);
				elseif (spellData.localizedName and spellData.localizedName ~= "Soulstone Resurrection") then
					if (LOCALE_koKR) then
						spellName = strsub(spellData.localizedName, 1, 18) .. "|r";
					else
						spellName = strsub(spellData.localizedName, 1, 12) .. "|r";
					end
				end
				spellName = "|c" .. classHex .. spellName .. "|r";
				--local readyCountText = "|cFFFFA500" .. readyCount .. "|r";
				local readyCountText = "";
				if (readyCount == 0) then
					if (NRC.db.global.raidCooldownsNumType == 2) then
						readyCountText = "|cFFFF2222" .. readyCount .. "|r|cFF00C800/" .. subFrameCount .. "|r";
					else
						readyCountText = "|cFFFF2222" .. readyCount .. "|r";
					end
				elseif (readyCount < subFrameCount) then
					if (NRC.db.global.raidCooldownsNumType == 2) then
						readyCountText = "|cFFFFA500" .. readyCount .. "|r|cFF00C800/" .. subFrameCount .. "|r";
					else
						readyCountText = "|cFFFFA500" .. readyCount .. "|r";
					end
				else
					if (NRC.db.global.raidCooldownsNumType == 2) then
						readyCountText = "|cFF00C800" .. readyCount .. "|r|cFF00C800/" .. subFrameCount .. "|r";
					else
						readyCountText = "|cFF00C800" .. readyCount .. "|r";
					end
				end
				lineFrame.texture:SetTexture(spellData.icon);
				local endTime = lowestCD or 0;
				local timeLeft = endTime - GetServerTime();
				if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
					lineFrame.fs2:SetPoint("RIGHT", -6, 0);
					if (timeLeft > 0) then
						local timeLeft = endTime - GetServerTime();
						local minutes = string.format("%02.f", math.floor(timeLeft / 60));
						local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
						lineFrame.fs2:SetText(minutes .. ":" .. seconds);
					else
						lineFrame.fs2:SetText(readyCountText);
					end
				else
					lineFrame.fs4:SetText(readyCountText);
					if (timeLeft > 0) then
						local timeLeft = endTime - GetServerTime();
						local minutes = string.format("%02.f", math.floor(timeLeft / 60));
						local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
						lineFrame.fs2:SetText(minutes .. ":" .. seconds);
					else
						lineFrame.fs2:SetText("|cFF00C800" .. L["Ready"]);
					end
				end
				--lineFrame.fs:SetText(spellName .. "  " .. readyCountText);
				lineFrame.fs:SetText(spellName);
				lineFrame:SetScript("OnEnter", function(self)
					--TODO: Check if anchor frame is close to top or bottom of screen and offset the tooptip frames accordingly.
					--Check which part of the screen our cooldowns frame is.
					local point = lineFrame:GetParent():GetPoint();
					lineFrame.subFrame:ClearAllPoints();
					if (point == "RIGHT" or point == "TOPRIGHT" or point == "BOTTOMRIGHT") then
						--If right of the screen then open the tooltip frames on the left.
						if (subFrameCount > 1) then
							--If more than one tooltip frame then spread them evenly above and below.
							local offset = (subFrameCount * lineFrame.subFrame:GetHeight()) / 4;
							lineFrame.subFrame:SetPoint("RIGHT", lineFrame, "LEFT", 0, offset);
						else
							--If only one tooltip frame then center it.
							lineFrame.subFrame:SetPoint("RIGHT", lineFrame, "LEFT", 0, 5);
						end
					else
						--Else open them on the right.
						if (subFrameCount > 1) then
							local offset = (subFrameCount * lineFrame.subFrame:GetHeight()) / 4;
							lineFrame.subFrame:SetPoint("LEFT", lineFrame, "RIGHT", 0, offset);
						else
							lineFrame.subFrame:SetPoint("LEFT", lineFrame, "RIGHT", 0, 5);
						end
					end
					--local scale, x, y = lineFrame.subFrame:GetEffectiveScale(), GetCursorPosition();
					--lineFrame.subFrame:SetPoint("RIGHT", nil, "BOTTOMLEFT", (x / scale) - 2, y / scale);
					--lineFrame.subFrame:SetPoint("CENTER", lineFrame, 100, 0);
					--local middle = 
					--lineFrame.subFrame:SetPoint("RIGHT", lineFrame, "LEFT", 0, 0);
					lineFrame.subFrame:Show();
				end)
				lineFrame:SetScript("OnLeave", function(self)
					local frames = lineFrame.subFrame.lineFrames;
					local found;
					for k, v in ipairs(frames) do
						if (MouseIsOver(v)) then
							found = true;
						end
					end
					if (not found) then
						lineFrame.subFrame:Hide();
					end
				end)
				lineFrame:SetScript("OnClick", function(self, button) end);
				lastLineFrame[frameNum] = lineFrame;
			else
				--Unmerged, show a list of all players cooldowns.
				for guid, charData in NRC:pairsByKeys(spellData.chars) do
					count[frameNum] = count[frameNum] +1;
					local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
					if (not name) then
						name, realm = "Unknown", "Unknown";
					end
					if (testRunning) then
						name = charData.name;
						realm = NRC.realm;
					end
					local rawName = name;
					local lineFrame = raidCooldowns[frameNum]:getLineFrame(count[frameNum]);
					--lineFrame.fs2:SetFont(NRC.regionFont, lineFrame:GetParent().lineFrameHeight - 9);
					lineFrame.enabled = true;
					--Shorten name if it's long.
					if (LOCALE_koKR) then
						name = strsub(name, 1, 30);
					else
						name = strsub(name, 1, 12);
					end
					local classHex;
					if (charData.class) then
						_, _, _, classHex = GetClassColor(charData.class);
						name = "|c" .. classHex .. name .. "|r";
					end
					lineFrame.fs:SetText(name);
					local endTime = charData.endTime or 0;
					local timeLeft = endTime - GetServerTime();
					if (timeLeft > 0) then
						local minutes = string.format("%02.f", math.floor(timeLeft / 60));
						local seconds = string.format("%02.f", math.floor(timeLeft - minutes * 60));
						lineFrame.fs2:SetText(minutes .. ":" .. seconds);
					else
						lineFrame.fs2:SetText("|cFF00C800" .. L["Ready"]);
					end
					lineFrame:SetScript("OnEnter", function(self)
						lineFrame.tooltip:Show();
					end)
					lineFrame:SetScript("OnLeave", function(self)
						lineFrame.tooltip:Hide();
					end)
					lineFrame.texture:SetTexture(spellData.icon);
					lineFrame.fs4:SetText("");
					--local spellName = strsub(spell, 1, 15);
					local spellName = strsub(spellData.spellName, 1, 15);
					if (spellData.title) then
						spellName = strsub(spellData.title, 1, 15);
					elseif (spellData.localizedName and spellData.localizedName ~= "Soulstone Resurrection") then
						if (LOCALE_koKR) then
							spellName = strsub(spellData.localizedName, 1, 18) .. "|r";
						else
							spellName = strsub(spellData.localizedName, 1, 12) .. "|r";
						end
					end
					spellName = "|c" .. (classHex or "") .. spellName .. "|r";
					local text = name .. " |cFF9CD6DE(|r" .. spellName .. "|cFF9CD6DE)|r";
					--if (NRC.groupCache[rawName] and NRC.groupCache[rawName].level and NRC.groupCache[rawName].level > 0) then
					--	text = text .. " " .. NRC.groupCache[rawName].level .. "|r"
					--end
					if (NRC.groupCache[rawName] and NRC.groupCache[rawName].zone) then
						if (NRC.groupCache[rawName].zone == "Offline" and NRC.groupCache[rawName].lastKnownZone) then
							text = text .. "\n" .. NRC.groupCache[rawName].lastKnownZone .. "|r";
							text = text .. "\n(" .. PLAYER_OFFLINE .. ")";
						elseif (not NRC.groupCache[rawName].online) then
							text = text .. "\n(" .. PLAYER_OFFLINE .. ")";
						else
							text = text .. "\n" .. NRC.groupCache[rawName].zone .. "|r"
						end
					end
					if (timeLeft > 0) then
						local destName;
						if (charData.destName) then
							destName = charData.destName;
							local _, _, _, classHex = GetClassColor(charData.destClass);
							destName = "|c" .. classHex .. destName .. "|r";
						elseif (NRC.data.raidCooldowns[guid] and NRC.data.raidCooldowns[guid][spell]
								and NRC.data.raidCooldowns[guid][spell].destName) then
							destName = NRC.data.raidCooldowns[guid][spell].destName;
							local _, _, _, classHex = GetClassColor(NRC.data.raidCooldowns[guid][spell].destClass);
							destName = "|c" .. classHex .. destName .. "|r";
						end
						if (destName) then
							text = text .. "\n|cFFDEDE42" .. L["Cast on"] .. " ->|r " .. destName .. "|r";
						end
					end
					if (charData.class == "WARLOCK" and next(NRC.data.hasSoulstone)) then
						text = text .. "\n|cFF9CD6DE" .. L["Current active soulstones"] .. ":|r";
						for ssGuid, ssTime in pairs(NRC.data.hasSoulstone) do
							local _, classEnglish, _, _, _, name = GetPlayerInfoByGUID(ssGuid)
							if (name) then
								local _, _, _, classHex = GetClassColor(classEnglish);
								name = "|c" .. classHex .. name .. "|r";
								local timeLeft = NRC:getTimeString(ssTime - GetServerTime(), true, "short");
								text = text .. "\n" .. name .. " " .. timeLeft .. " " .. L["left"] .. ".";
							end
						end
					end
					lineFrame.updateTooltip(text);
					lastLineFrame[frameNum] = lineFrame;
					lineFrame:SetScript("OnClick", function(self, button)
						sendClick(button, rawName, charData.class, timeLeft, spellData.spellName);
					end)
				end
			end
		end
	end
	for frameID, frame in ipairs(raidCooldowns) do
		for k, v in ipairs(frame.lineFrames) do
			if (v.count and count[frameID] and v.count > count[frameID] and v.enabled) then
				v.enabled = false;
			end
		end
		if (frameID == NRC.config.raidCooldownsSoulstonesPosition) then
			if (testRunning) then
				NRC:updateSoulstoneFrameTest(lastLineFrame[frameID])
			else
				NRC:updateSoulstoneFrame(lastLineFrame[frameID]);
			end
		end
		frame:sortLineFrames();
	end
end

function NRC:updateSoulstoneFrame(lineFrame)
	if (disabled) then
		NRC:stopAllSoulstoneBars();
		return;
	end
	if (NRC.config.raidCooldownsSoulstones and IsInGroup()) then
		if (lineFrame and NRC.data.hasSoulstone) then
			local count, offset, startOffset = 0, 0, 5;
			local height = lineFrame:GetHeight() - 2;
			local lastBar;
			for guid, time in pairs(NRC.data.hasSoulstone) do
				local _, classEnglish, _, _, _, name = GetPlayerInfoByGUID(guid);
				if (name) then
					count = count + 1;
					local _, _, _, classHex = GetClassColor(classEnglish);
					name = "|c" .. classHex .. name .. "|r";
					local duration = time - GetServerTime();
					if (duration > 0) then
						-- local timeLeft = NRC:getTimeString(duration, true, "short");
						if (not soulstoneBars[guid]) then
							soulstoneBars[guid] = NRC:createTimerBar(lineFrame:GetWidth(), height, duration, name);
							NRC:styleTimerBar(soulstoneBars[guid], duration, soulstoneDuration, name, height, guid);
						end
						--Only set source if no source has been set yet (/reload), or it's a new soulstone incase someone gets 2 put on them.
						if (not soulstoneBars[guid].source or duration > 1770) then
							for spellID, _ in pairs(NRC.cooldowns.Soulstone.spellIDs) do
								if (NRC.auraCache[guid]) then
									for k, v in pairs(NRC.auraCache[guid]) do
										if (k == spellID) then
											if (v.source == "player") then
												soulstoneBars[guid].source = UnitName("player");
												--soulstoneBars[guid].sourceGUID = UnitGUID("player");
											else
												soulstoneBars[guid].source = v.source;
												--soulstoneBars[guid].sourceGUID = ;
											end
											break;
										end
									end
								end
							end
						end
						soulstoneBars[guid]:SetHeight(height);
						soulstoneBars[guid].texture:SetSize(height - 2, height - 2);
						soulstoneBars[guid]:ClearAllPoints();
						soulstoneBars[guid]:SetPoint("LEFT", lineFrame);
						soulstoneBars[guid]:SetPoint("RIGHT", lineFrame, -soulstoneBars[guid].texture:GetSize(), 0);
						if (lineFrame:GetParent().growthDirection == 1) then
							if (count == 1) then
								soulstoneBars[guid]:SetPoint("TOP", lineFrame, "BOTTOM", 0, -startOffset);
							else
								soulstoneBars[guid]:SetPoint("TOP", lastBar, "BOTTOM", 0, -offset);
							end
						else
							if (count == 1) then
								soulstoneBars[guid]:SetPoint("BOTTOM", lineFrame, "TOP", 0, startOffset);
							else
								soulstoneBars[guid]:SetPoint("BOTTOM", lastBar, "TOP", 0, offset);
							end
						end
						local minutes = string.format("%02.f", math.floor(duration / 60));
						local seconds = string.format("%02.f", math.floor(duration - minutes * 60));
						local timerText = "";
						if (duration >= 60) then
							soulstoneBars[guid].customTimer:SetFormattedText("%d:%02d", minutes, seconds);
						else
							soulstoneBars[guid].customTimer:SetFormattedText("%.0f", seconds);
						end
						lastBar = soulstoneBars[guid];
						soulstoneBars[guid].texture:Show();
						soulstoneBars[guid].customTimer:Show();
					end
				end
			end
			--On rare occasions a soulstone bar doesn't get removed, temp fix till I work out why.
			for k, v in pairs(soulstoneBars) do
				if (not NRC.data.hasSoulstone[k]) then
					v:Stop();
				end
			end
		end
	else
		for k, v in pairs (soulstoneBars) do
			v:Stop();
		end
	end
end

--We use a different func for soulstone frame test runs from config.
--Too much is different to use the same func.
function NRC:updateSoulstoneFrameTest(lineFrame)
	NRC:stopAllSoulstoneBars();
	if (NRC.config.raidCooldownsSoulstones) then
		if (lineFrame) then
			local count, offset, startOffset = 0, 0, 5;
			local height = lineFrame:GetHeight() - 2;
			local lastBar;
			for guid, time in pairs(testSoulstoneData) do
				local name, classEnglish = strsplit("-", guid);
				if (name) then
					count = count + 1;
					local _, _, _, classHex = GetClassColor(classEnglish);
					name = "|c" .. classHex .. name .. "|r";
					local duration = time - GetServerTime();
					if (duration > 0) then
						local timeLeft = NRC:getTimeString(duration, true, "short");
						if (not soulstoneBars[guid]) then
							soulstoneBars[guid] = NRC:createTimerBar(lineFrame:GetWidth(), height, duration, name);
							NRC:styleTimerBar(soulstoneBars[guid], duration, soulstoneDuration, name, height, guid, true);
						end
						--Only set source if no source has been set yet (/reload), or it's a new soulstone incase someone gets 2 put on them.
						if (not soulstoneBars[guid].source or duration > 1770) then
							for spellID, _ in pairs(NRC.cooldowns.Soulstone.spellIDs) do
								if (NRC.auraCache[guid]) then
									for k, v in pairs(NRC.auraCache[guid]) do
										if (k == spellID) then
											if (v.source == "player") then
												soulstoneBars[guid].source = UnitName("player");
												--soulstoneBars[guid].sourceGUID = UnitGUID("player");
											else
												soulstoneBars[guid].source = v.source;
												--soulstoneBars[guid].sourceGUID = ;
											end
											break;
										end
									end
								end
							end
						end
						soulstoneBars[guid]:SetHeight(height);
						soulstoneBars[guid].texture:SetSize(height - 2, height - 2);
						soulstoneBars[guid]:ClearAllPoints();
						soulstoneBars[guid]:SetPoint("LEFT", lineFrame);
						soulstoneBars[guid]:SetPoint("RIGHT", lineFrame, -soulstoneBars[guid].texture:GetSize(), 0);
						if (lineFrame:GetParent().growthDirection == 1) then
							if (count == 1) then
								soulstoneBars[guid]:SetPoint("TOP", lineFrame, "BOTTOM", 0, -startOffset);
							else
								soulstoneBars[guid]:SetPoint("TOP", lastBar, "BOTTOM", 0, -offset);
							end
						else
							if (count == 1) then
								soulstoneBars[guid]:SetPoint("BOTTOM", lineFrame, "TOP", 0, startOffset);
							else
								soulstoneBars[guid]:SetPoint("BOTTOM", lastBar, "TOP", 0, offset);
							end
						end
						local minutes = string.format("%02.f", math.floor(duration / 60));
					    local seconds = string.format("%02.f", math.floor(duration - minutes * 60));
						local timerText = "";
						if (duration >= 60) then
							soulstoneBars[guid].customTimer:SetFormattedText("%d:%02d", minutes, seconds);
						else
							soulstoneBars[guid].customTimer:SetFormattedText("%.0f", seconds);
						end
						soulstoneBars[guid].texture:Show();
						lastBar = soulstoneBars[guid];
					end
				end
			end
		end
	end
end

function NRC:stopAllSoulstoneBars()
	for k, v in pairs (soulstoneBars) do
		v:Stop();
	end
end

--Remove soulstones being tracked from old group.
function NRC:removeUngroupedSoulstones()
	for k, v in pairs(NRC.data.hasSoulstone) do
		if (not NRC:inOurGroup(k)) then
			NRC:soulstoneRemoved(k);
		end
	end
end

function NRC:RaidCooldowns_LibCandyBar_Stop(guid)
	local bar = soulstoneBars[guid]
	if (bar) then
		NRC:cleanTimerBar(bar);
	end
	soulstoneBars[guid] = nil;
end

function NRC:soulstoneRemoved(guid)
	if (guid) then
		NRC.data.hasSoulstone[guid] = nil;
		if (soulstoneBars[guid]) then
			soulstoneBars[guid]:Stop();
		end
	end
end

--If the warlock leaves the group.
function NRC:soulstoneRemovedByLeave(name)
	for k, v in pairs(soulstoneBars) do
		if (name == v.source) then
			NRC:debug(name .. " left group with soulstone casted");
			NRC.data.hasSoulstone[k] = nil;
			soulstoneBars[k]:Stop();
		end
	end
end

local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, spellID, spellName = CombatLogGetCurrentEventInfo();
	local selfOnly;
	if (not IsInGroup()) then
		--Proccess our own spells even when not in group just for our database.
		if (sourceGUID == UnitGUID("player")) then
			selfOnly = true;
		else
			return;
		end
	end
	--print(CombatLogGetCurrentEventInfo())
	if (subEvent == "SPELL_CAST_SUCCESS") then
		if (trackedSpellsCache[spellID]) then
			--If in a group update our local cache for cooldown frames.
			local destClass;
			if (destGUID == "" and sourceGUID == UnitGUID("player")) then
				--If there's no guid then it's most likely a spell we cast on ourself.
				destGUID = UnitGUID("player");
				destName = UnitName("player") .. "-" .. GetNormalizedRealmName();
			end
			if (destGUID and destGUID ~= "") then
				 _, destClass = GetPlayerInfoByGUID(destGUID);
			end
			if (not selfOnly) then
				NRC:updateCooldownList(sourceGUID, sourceName, destGUID, destName, destClass, spellID);
			end
			--If we cast this spell then upate raid members not in range with this cooldown usage.
			--Note: Shaman reincarnation is not in the combat log in TBC, but is on retail?
			if (sourceGUID == UnitGUID("player")) then
				--Add our self to db even if not in group so our timer can be shared if we join one later.
				local cooldownName, _, cooldownTime = NRC:getCooldownFromSpellID(spellID);
				if (trackedSpellsCache[spellID] == "Reincarnation") then
					--If shaman battle res then check talents for cooldown reduction.
					--3rd talent in 3rd tree.
					--local msg = spellID;
					local name, texture, _, _, chosen, max;
					if (NRC.isWrath) then
						--Talents are not in index order in wrath.
						name, texture, _, _, chosen, max = GetTalentInfo(3, 7);
					else
						name, texture, _, _, chosen, max = GetTalentInfo(3, 3);
					end
					--Attach a different cooldown if talents are trained.
					if (NRC.isWrath) then
						if (chosen == 1) then
							cooldownTime = 1380;
						elseif (chosen == 2) then
							cooldownTime = 900;
						else
							cooldownTime = 1800;
						end
					else
						if (chosen == 1) then
							cooldownTime = 3000;
						elseif (chosen == 2) then
							cooldownTime = 2400;
						else
							cooldownTime = 3600;
						end
					end
					--NRC:sendSpellUsed(spellID, cooldownTime, UnitName("player"), "SHAMAN");
					NRC:sendSpellUsed(spellID, cooldownTime);
				else
					NRC:sendSpellUsed(spellID, cooldownTime, destName, destClass);
				end
				--If this is our own spell add it to database for sharing later.
				if (not NRC.data.raidCooldowns[sourceGUID]) then
					NRC.data.raidCooldowns[sourceGUID] = {};
				end
				if (not NRC.data.raidCooldowns[sourceGUID][cooldownName]) then
					NRC.data.raidCooldowns[sourceGUID][cooldownName] = {};
				end
				if (destName == "") then
					destName = nil;
				end
				NRC.data.raidCooldowns[sourceGUID][cooldownName].endTime = GetServerTime() + cooldownTime;
				NRC.data.raidCooldowns[sourceGUID][cooldownName].spellName = spellName;
				NRC.data.raidCooldowns[sourceGUID][cooldownName].spellID = spellID;
				NRC.data.raidCooldowns[sourceGUID][cooldownName].destName = destName;
				NRC.data.raidCooldowns[sourceGUID][cooldownName].destClass = destClass;
			end
			if (soulstoneSpellIDs[spellID] and NRC:inOurGroup(destGUID)) then
				--Keep track of who has soul stone so we can guess reincarnation usage.
				NRC.data.hasSoulstone[destGUID] = GetServerTime() + soulstoneDuration;
			end
		end
		if (resSpellsCache[spellID] and NRC:inOurGroup(destGUID)) then
			--Keep track of who has res pending so we can guess reincarnation usage.
			hasResPending[destGUID] = GetServerTime() + 360;
		end
	end
end

local function raidCooldownsUnitAura(...)
	local unit = ...;
	if (not IsInGroup()) then
		return;
	end
	if (units[unit]) then
		for i = 1, 40 do
			local _, _, _, _, _, expirationTime, _, _, _, spellID = UnitAura(unit, i);
			if (spellID and soulstoneSpellIDs[spellID]) then
				local guid = UnitGUID(unit);
				if (guid) then
    				NRC.data.hasSoulstone[guid] = GetServerTime() + (expirationTime - GetTime());
				end
			end
		end
	end
end

local function raidCooldownsUnitFlags(...)
	local unit = ...;
	--if (not IsInGroup()) then
	--	return;
	--end
	if (units[unit]) then
		local guid = UnitGUID(unit); 
		--local name = UnitName(unit);
		if (UnitIsGhost(unit) and not isGhost[guid]) then
			--UnitIsDead(unit) is false when a ghost so set both if unit is a ghost.
			isGhost[guid] = true;
			isDead[guid] = true;
			NRC:soulstoneRemoved(guid);
			--NRC:debug(name, "has released")
		elseif (UnitIsDead(unit) and not isDead[guid]) then
			--Else if not a ghost then set dead flag only.
			--NRC:debug(name, "has died")
			isGhost[guid] = nil;
			isDead[guid] = true;
		elseif (isDead[guid] and not UnitIsDead(unit) and not UnitIsGhost(unit)) then
			--NRC:debug(name, "has ressed")
			--Needs more testing, not finished yet, priest spirit of redemption makes things tricky.
			--[[if (NRC.data.hasSoulstone[guid]) then
				local _, class  = GetPlayerInfoByGUID(guid);
				if (class == "PRIEST") then
					C_Timer.After(1, function()
						local isSpirit = NRC:hasBuff(unit, 35618);
						if (not isSpirit) then
							local _, _, _, classHex = GetClassColor(class);
							local sourceName = "|c" .. classHex .. name .. "|r";
							local text = sourceName .. " -> |cFF9CD6DEUsed Soulstone|r";
							if (NRC.config.sreShowSoulstoneRes) then
								NRC:sreSendEvent(text, 27827, name);
							end
						end
					end)
				else
					local _, _, _, classHex = GetClassColor(class);
					local sourceName = "|c" .. classHex .. name .. "|r";
					local text = sourceName .. " -> |cFF9CD6DEUsed Soulstone|r";
					if (NRC.config.sreShowSoulstoneRes) then
						NRC:sreSendEvent(text, 134336, name);
					end
				end
			end]]
			C_Timer.After(0.1, function()
				isDead[guid] = nil;
				isGhost[guid] = nil;
				hasResPending[guid] = nil;
				NRC:soulstoneRemoved(guid);
			end)
		end
	end
end

--Scan whole group for ghost/dead status when joining.
function NRC:raidCooldownsScanGroup()
	if (not IsInGroup()) then
		return;
	end
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	for i = 1, GetNumGroupMembers() do
		local unit = unitType .. i;
		local guid = UnitGUID(unit); 
		local name = UnitName(unit);
		if (UnitIsGhost(unit) and not isGhost[guid]) then
			isGhost[guid] = true;
			isDead[guid] = true;
			NRC:soulstoneRemoved(guid);
			--NRC:debug(name, "has released")
		elseif (UnitIsDead(unit) and not isDead[guid]) then
			NRC:debug(name, "has died")
			isGhost[guid] = nil;
			isDead[guid] = true;
		elseif (isDead[guid]) then
			--NRC:debug(name, "has ressed")
			isDead[guid] = nil;
			isGhost[guid] = nil;
			hasResPending[guid] = nil;
			NRC:soulstoneRemoved(guid);
		end
	end
	--Scan ourself too.
	local unit = "player";
	local guid = UnitGUID(unit); 
	local name = UnitName(unit);
	if (UnitIsGhost(unit) and not isGhost[guid]) then
		isGhost[guid] = true;
		isDead[guid] = true;
		NRC:soulstoneRemoved(guid);
		--NRC:debug(name, "has released")
	elseif (UnitIsDead(unit) and not isDead[guid]) then
		NRC:debug(name, "has died")
		isGhost[guid] = nil;
		isDead[guid] = true;
	elseif (isDead[guid]) then
		--NRC:debug(name, "has ressed")
		isDead[guid] = nil;
		isGhost[guid] = nil;
		hasResPending[guid] = nil;
		NRC:soulstoneRemoved(guid);
	end
end

local function raidCooldownsUnitHealth(...)
	local unit = ...;
	local selfOnly;
	--If it's us then still process it if not in group so we can record our reincarnation timer to database.
	if (not IsInGroup()) then
		if (unit == "player") then
			selfOnly = true;
		else
			return;
		end
	end
	local _, class = UnitClass(unit);
	if (class ~= "SHAMAN") then
		return;
	end
	local guid = UnitGUID(unit); 
	local name = UnitName(unit);
	local hp = UnitHealth(unit);
	local hpMax = UnitHealthMax(unit);
	local percent20 = math.floor(0.2 * hpMax);
	local percent30 = math.floor(0.3 * hpMax);
	local percent40 = math.floor(0.4 * hpMax);
	--If offline we can't divide by zero.
	local hpPercent;
	if (not hp or not hpMax or hp == 0 or hpMax == 0) then
		hpPercent = 0;
	else
		hpPercent = hp / hpMax * 100;
	end
	local hpPercent = hp / hpMax * 100;
	--NRC:debug("hp", hpPercent, hp, hpMax, percent20, percent30, percent40)
	if (isDead[guid] and not isGhost[guid] and not hasResPending[guid]
			and not NRC.data.hasSoulstone[guid]) then
		local usedReincarnation;
		if (NRC.isWrath) then
			if (hp == percent20) then
				--Reincarnation used, no talent points in Improved Reincarnation, 30min cd.
				usedReincarnation = 1800;
			elseif (hp == percent30) then
				--Reincarnation used, 1 talent point in Improved Reincarnation, 23min cd.
				usedReincarnation = 1380;
			elseif (hp == percent40) then
				--Reincarnation used, 2 talent points in Improved Reincarnation, 15min cd.
				usedReincarnation = 900;
			end
		else
			if (hp == percent20) then
				--Reincarnation used, no talent points in Improved Reincarnation, 60min cd.
				usedReincarnation = 3600;
			elseif (hp == percent30) then
				--Reincarnation used, 1 talent point in Improved Reincarnation, 50min cd.
				usedReincarnation = 3000;
			elseif (hp == percent40) then
				--Reincarnation used, 2 talent points in Improved Reincarnation, 40min cd.
				usedReincarnation = 2400;
			end
		end
		if (usedReincarnation) then
			NRC:debug("used reincarnation", usedReincarnation);
		end
		--UNIT_HEALTH may not tick until they have natural regen or a heal go off so the res health won't be accurate.
		--Try some less accurate backup checks here.
		--It should still work ok since we're checking if they have res pending or are a ghost anyway.
		--And we check if last known hp was 0.
		if (not usedReincarnation and hpCache[guid] and hpCache[guid] == 0) then
			--This should be changed later to check talents before checking percent now we're scanning group.
			if (NRC.isWrath) then
				if (hpPercent > 18 and hpPercent < 22) then
					--Reincarnation used, no talent points in Improved Reincarnation, 60min cd.
					usedReincarnation = 1800;
				elseif (hpPercent > 28 and hpPercent < 32) then
					--Reincarnation used, 1 talent point in Improved Reincarnation, 50min cd.
					usedReincarnation = 1380;
				elseif (hpPercent > 38 and hpPercent < 42) then
					--Reincarnation used, 2 talent points in Improved Reincarnation, 40min cd.
					usedReincarnation = 900;
				end
			else
				if (hpPercent > 18 and hpPercent < 22) then
					--Reincarnation used, no talent points in Improved Reincarnation, 60min cd.
					usedReincarnation = 3600;
				elseif (hpPercent > 28 and hpPercent < 32) then
					--Reincarnation used, 1 talent point in Improved Reincarnation, 50min cd.
					usedReincarnation = 3000;
				elseif (hpPercent > 38 and hpPercent < 42) then
					--Reincarnation used, 2 talent points in Improved Reincarnation, 40min cd.
					usedReincarnation = 2400;
				end
			end
			if (usedReincarnation) then
				NRC:debug("used reincarnation backup", usedReincarnation);
			end
		end
		if (usedReincarnation) then
			if (selfOnly) then
				--If this is our own spell add it to database for sharing later.
				if (not NRC.data.raidCooldowns[guid]) then
					NRC.data.raidCooldowns[guid] = {};
				end
				if (not NRC.data.raidCooldowns[guid]["Reincarnation"]) then
					NRC.data.raidCooldowns[guid]["Reincarnation"] = {};
				end
				NRC.data.raidCooldowns[guid]["Reincarnation"].endTime = GetServerTime() + usedReincarnation;
				NRC.data.raidCooldowns[guid]["Reincarnation"].spellName = "Reincarnation";
				NRC.data.raidCooldowns[guid]["Reincarnation"].spellID = 20608;
				--NRC.data.raidCooldowns[guid]["Reincarnation"].destName = UnitName("player");
				--NRC.data.raidCooldowns[guid]["Reincarnation"].destClass = "SHAMAN";
				--NRC:sendSpellUsed(20608, usedReincarnation, UnitName("player"), "SHAMAN");
				NRC:sendSpellUsed(20608, usedReincarnation);
			else
				--NRC:updateCooldownList(guid, name, guid, name, "SHAMAN", 20608, 3600);
				if (guid == UnitGUID("player")) then
					--Only send to group if it's my reincarnation.
					NRC:sendSpellUsed(20608, usedReincarnation);
				end
				NRC:updateCooldownList(guid, name, nil, nil, nil, 20608, usedReincarnation);
			end
			local _, classEnglish  = UnitClass(unit);
			local _, _, _, classHex = GetClassColor(classEnglish);
			local name = "|c" .. classHex .. name .. "|r";
			NRC:sreSendEvent(name .. " " .. L["has reincarnated"] .. ".", 133439, name);
		end
	end
	--Update cache after our reincarnation checks, we want last known hp for that.
	hpCache[guid] = hp;
end

--Scan group for soulstone buffs, only works if they're in range or expirationTime is above 0.
function NRC:updateSoulstoneDurations()
	if (not IsInGroup()) then
		return;
	end
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	for char = 1, GetNumGroupMembers() do
		for i = 1, 40 do
			local name, _, _, _, duration, expirationTime, source, _, _, spellID = UnitAura(unitType .. char, i);
			if (name and soulstoneSpellIDs[spellID] and expirationTime > 0) then
				local secondsLeft = expirationTime - GetTime();
				--if (secondsLeft > duration - 3) then
					local guid = UnitGUID(unitType .. char);
					NRC.data.hasSoulstone[guid] = GetServerTime() + secondsLeft;
					--NRC:debug("tracked spell resynced", name, secondsLeft);
				--end
			end
		end
	end
	--Update ourself.
	for i = 1, 40 do
		local name, _, _, _, duration, expirationTime, source, _, _, spellID = UnitAura("player", i);
		if (name and soulstoneSpellIDs[spellID] and expirationTime > 0) then
			local secondsLeft = expirationTime - GetTime();
			--if (secondsLeft > duration - 3) then
				local guid = UnitGUID("player");
				NRC.data.hasSoulstone[guid] = GetServerTime() + secondsLeft;
				--NRC:debug("tracked spell resynced", name, secondsLeft);
			--end
		end
	end
end

--[[function NRC:updateSoulstoneDurationUnit(unit)
	for i = 1, 40 do
		local name, _, _, _, duration, expirationTime, source, _, _, spellID = UnitAura(unit, i);
		if (name and soulstoneSpellIDs[spellID] and expirationTime > 0) then
			local secondsLeft = expirationTime - GetTime();
			local guid = UnitGUID(unit);
			if (guid) then
				NRC.data.hasSoulstone[guid] = GetServerTime() + secondsLeft;
			end
		end
	end
end]]

--Check cache for expired data and remeove it.
function NRC:raidCooldownsCleanup()
	--Do this seperately from the rest, it's only really needed after relog or reload.
	for k, v in pairs(NRC.data.raidCooldowns) do
		for kk, vv in pairs(v) do
			if (not vv.endTime or vv.endTime < GetServerTime()) then
				NRC.data.raidCooldowns[k][kk] = nil;
			end
		end
	end
end

local cooldownReadyCache = {};
local function raidCooldownsCleanupTicker()
	--If no spells are being tracked for this char then remove it.
	for guid, cooldowns in pairs(NRC.data.raidCooldowns) do
		if (NRC.config.showRaidCooldowns and NRC.config.sreShowCooldownReset) then
			for spellName, spellData in pairs(cooldowns) do
				local cache = cooldownReadyCache[guid .. "_" .. spellData.spellID];
				if (spellData.endTime == GetServerTime() and NRC:isCooldownEnabled(spellData.spellID)
						and (not cache or cache > GetTime() - 3)) then
					--Cooldown has just finished?
					local _, sourceClass, _, _, _, sourceName  = GetPlayerInfoByGUID(guid);
					local icon = getIconFromCooldownsSpellID(spellData.spellID);
					--Sometimes 1 second tickers are smaller than 1 second and can get the same GetServerTime() timestamp 2 times in a row.
					--So use a cache to avoid duplicate msgs.
					cache = GetTime();
					if (sourceName and NRC:inOurGroup(guid)) then
						NRC:sreCooldownResetEvent(spellData.spellID, spellName, icon, sourceName, sourceClass);
					end
				end
			end
		end
		if (not next(cooldowns)) then
			NRC.data.raidCooldowns[guid] = nil;
		end
	end
	--Clean up soulstone cache.
	for k, v in pairs(NRC.data.hasSoulstone) do
		if (v < GetServerTime()) then
			NRC.data.hasSoulstone[k] = nil;
		end
	end
	--Res stays pending for 6 mins?
	for k, v in pairs(hasResPending) do
		if (v < GetServerTime()) then
			hasResPending[k] = nil;
		end
	end
end

local ticker;
function NRC:startRaidCooldownsTicker()
	if (ticker) then
		return;
	end
	ticker = true;
	NRC:raidCooldownsTicker();
end

function NRC:stopRaidCooldownsTicker()
	ticker = nil;
end

function NRC:raidCooldownsTicker()
	if (ticker) then
		raidCooldownsCleanupTicker();
		C_Timer.After(1, function()
			NRC:raidCooldownsTicker();
		end)
	end
end

local function testRaidCooldowns()
	local group;
	if (NRC.isTBC or NRC.isClassic) then
		group = {
			["Player1"] = {data = {class = "DRUID", level = 70}},
			["Player2"] = {data = {class = "DRUID", level = 70}},
			["Player3"] = {data = {class = "HUNTER", level = 70}},
			["Player4"] = {data = {class = "HUNTER", level = 70}},
			["Player5"] = {data = {class = "MAGE", level = 70}},
			["Player6"] = {data = {class = "MAGE", level = 70}},
			["Player7"] = {data = {class = "PALADIN", level = 70}},
			["Player8"] = {data = {class = "PALADIN", level = 70}},
			["Player9"] = {data = {class = "PRIEST", level = 70}},
			["Player10"] = {data = {class = "PRIEST", level = 70}},
			["Player11"] = {data = {class = "ROGUE", level = 70}},
			["Player12"] = {data = {class = "ROGUE", level = 70}},
			["Player13"] = {data = {class = "SHAMAN", level = 70}},
			["Player14"] = {data = {class = "SHAMAN", level = 70}},
			["Player15"] = {data = {class = "WARLOCK", level = 70}},
			["Player16"] = {data = {class = "WARLOCK", level = 70}},
			["Player17"] = {data = {class = "WARRIOR", level = 70}},
			["Player18"] = {data = {class = "WARRIOR", level = 70}},
		};
	else
		group = {
			["Player1"] = {data = {class = "DRUID", level = 200}},
			["Player2"] = {data = {class = "DRUID", level = 200}},
			["Player3"] = {data = {class = "HUNTER", level = 200}},
			["Player4"] = {data = {class = "HUNTER", level = 200}},
			["Player5"] = {data = {class = "MAGE", level = 200}},
			["Player6"] = {data = {class = "MAGE", level = 200}},
			["Player7"] = {data = {class = "PALADIN", level = 200}},
			["Player8"] = {data = {class = "PALADIN", level = 200}},
			["Player9"] = {data = {class = "PRIEST", level = 200}},
			["Player10"] = {data = {class = "PRIEST", level = 200}},
			["Player11"] = {data = {class = "ROGUE", level = 200}},
			["Player12"] = {data = {class = "ROGUE", level = 200}},
			["Player13"] = {data = {class = "SHAMAN", level = 200}},
			["Player14"] = {data = {class = "SHAMAN", level = 200}},
			["Player15"] = {data = {class = "WARLOCK", level = 200}},
			["Player16"] = {data = {class = "WARLOCK", level = 200}},
			["Player17"] = {data = {class = "WARRIOR", level = 200}},
			["Player18"] = {data = {class = "WARRIOR", level = 200}},
			["Player19"] = {data = {class = "DEATHKNIGHT", level = 200}},
			["Player20"] = {data = {class = "DEATHKNIGHT", level = 200}},
		};
	end
	--Add fake guids, last number of the name, it works because each class is unique in the table.
	for k, v in pairs(group) do
		v.data.guid = "Player-0000-0000000" .. strsub(k, string.len(k));
	end
	testData = {};
	local function loadChar(name, data, cooldownName)
		for k, v in pairs(NRC.cooldowns) do
			if (NRC.config["raidCooldown" .. string.gsub(k, " ", "")] and (v.class == data.class or cooldownName == k)
					and (not data.level or data.level >= v.minLevel)) then
				local hasTalent;
				if (v.talentOnly) then
					hasTalent = true;
				end
				if (not v.talentOnly or hasTalent) then
					local index;
					--Check if cooldown is already in the table.
					for i, cd in pairs(testData) do
						if (k == cd.spellName) then
							index = i;
							break;
						end
					end
					if (not index) then
						index = #testData + 1;
						testData[index] = {
							spellName = k;
							class = v.class or data.class,
							cooldown = v.cooldown,
							icon = v.icon,
							spellIDs = {},
							chars = {},
							color = v.color,
							title = v.title,
							localizedName = v.localizedName,
							merged = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"],
							frame = NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Frame"],
						};
						--Add id's for each rank of this spell.
						if (v.spellIDs and next(v.spellIDs)) then
							for id, spellName in pairs(v.spellIDs) do
								--Add spell to cache for scanning combat log.
								trackedSpellsCache[id] = spellName;
								--Add spell to the track list for this character.
								testData[index].spellIDs[id] = spellName;
							end
						end
					end
					--Attach character to this spell for watching.
					if (not testData[index].chars[data.guid]) then
						testData[index].chars[data.guid] = {
							name = name,
							class = data.class,
							endTime = 0,
						};
					end
					--Load time from saved data if it exists.
					if (NRC.data.raidCooldowns[data.guid] and NRC.data.raidCooldowns[data.guid][k]) then
						NRC.cooldownList[index].chars[data.guid].endTime = NRC.data.raidCooldowns[data.guid][k].endTime;
						NRC.cooldownList[index].chars[data.guid].destName = NRC.data.raidCooldowns[data.guid][k].destName;
						NRC.cooldownList[index].chars[data.guid].destClass = NRC.data.raidCooldowns[data.guid][k].destClass;
					end
				end
			end
		end
	end
	for k, v in pairs(group) do
		local name = k;
		local data = v.data;
		local cooldownName = "not needed";
		--A copy paste of the NRC:loadRaidCooldownChar() func with small changes.
		--hasTalent always true to show all sells.
		--NRC.cooldownList changed to testData.
		loadChar(name, data);
		if (name == "Player1") then
			loadChar(name, data, "NeckSP");
		elseif (name == "Player2") then
			loadChar(name, data, "NeckCrit");
		elseif (name == "Player3") then
			loadChar(name, data, "NeckCritRating");
		elseif (name == "Player4") then
			loadChar(name, data, "NeckStam");
		elseif (name == "Player5") then
			loadChar(name, data, "NeckHP5");
		elseif (name == "Player5") then
			loadChar(name, data, "NeckStats");
		end
	end
	testSoulstoneData = {
		--If test data then just put anme and class in guid spot and parse it in the update.
		["Player7-PRIEST"] = GetServerTime() + 1224,
		["Player9-PALADIN"] = GetServerTime() + 410,
	};
end

function NRC:startRaidCooldownsTest(quiet)
	if (not NRC.config.showRaidCooldowns) then
		NRC:print("Raid cooldowns are not enabled.");
		return;
	end
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	testRunningTimer = C_Timer.NewTicker(30, function()
		NRC:stopRaidCooldownsTest();
	end, 1)
	if (not quiet) then
		NRC:print("|cFF00C800Started raid cooldown test for 30 seconds.");
	end
	testRaidCooldowns();
	testRunning = true;
	for i = 1, NRC.maxCooldownFrameCount do
		local frame = raidCooldowns[i];
		if (frame) then
			if (hasSpellsAssigned(frame)) then
				--If spells are shown part of the display frame covering the top spell.
				frame.displayTab:Hide();
				frame.displayTab.top:Show();
			else
				frame.displayTab:Show();
				frame.displayTab.top:Show();
			end
			local point, _, relativePoint, x, y = frame:GetPoint();
			if (point == "CENTER" and x == frame.defaultX and y == frame.defaultY) then
				frame.fs:SetText("");
			end
		end
	end
	NRC:raidCooldownsUnlockFrames();
	NRC:updateRaidCooldowns();
	NRC:updateRaidCooldownFramesLayout();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:stopRaidCooldownsTest()
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	if (NRC.allFramesTestRunning) then
		local text = "|cFF00C800Stopped layout test";
		if (not NRC.config.lockAllFrames) then
			text = text .. " (Remember to lock frames when done)"
		end
		NRC:print(text .. ".");
	else
		NRC:print("|cFF00C800Stopped Raid Cooldowns Test.");
	end
	testData = nil;
	testSoulstoneData = nil;
	testRunning = nil;
	NRC:stopAllSoulstoneBars();
	NRC:updateRaidCooldownFramesLayout();
	NRC:updateRaidCooldowns();
	NRC:raidCooldownsUpdateFrameLocks();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:getRaidCooldownsTestState()
	return testRunning;
end

function NRC:raidCooldownsUpdateFrameLocks()
	if (next(raidCooldowns)) then
		for i = 1, NRC.config.cooldownFrameCount do
			if (i > NRC.maxCooldownFrameCount) then
				break;
			end
			local frame = raidCooldowns[i];
			if (frame) then
				frame.locked = NRC.config.lockAllFrames;
			end
		end
	end
	NRC:raidCooldownsUpdateFrameLocksLayout();
end
	
function NRC:raidCooldownsUpdateFrameLocksLayout()
	if (next(raidCooldowns)) then
		for i = 1, NRC.config.cooldownFrameCount do
			if (i > NRC.maxCooldownFrameCount) then
				break;
			end
			local frame = raidCooldowns[i];
			if (frame) then
				--if (frame.locked and not frame.firstRun) then
				if (frame.locked) then
					frame.displayTab:Hide();
					frame.displayTab.top:Hide();
				else
					frame.displayTab:Show();
					frame.displayTab.top:Show();
				end
			end
		end
	end
	--NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:raidCooldownsLockFrames()
	for i = 1, NRC.config.cooldownFrameCount do
		if (i > NRC.maxCooldownFrameCount) then
			break;
		end
		local frame = raidCooldowns[i];
		if (frame) then
			frame.locked = true;
		end
	end
	NRC:raidCooldownsUpdateFrameLocksLayout();
end

function NRC:raidCooldownsUnlockFrames()
	for i = 1, NRC.config.cooldownFrameCount do
		if (i > NRC.maxCooldownFrameCount) then
			break;
		end
		local frame = raidCooldowns[i];
		if (frame) then
			frame.locked = false;
		end
	end
	NRC:raidCooldownsUpdateFrameLocksLayout();
end

function NRC:raidCooldownsGetLockState()
	if (raidCooldowns[1]) then
		return raidCooldowns[1].locked;
	end
end

function NRC:reloadRaidCooldowns()
	if (testRunning) then
		testRaidCooldowns();
	end
	NRC:loadRaidCooldownGroup();
	NRC:loadPartyNeckBuffs();
	NRC:updateRaidCooldowns();
	NRC:updateRaidCooldownFramesLayout();
	NRC:raidCooldownsUpdateFrameLocks();
end

local f = CreateFrame("Frame", "NRCRaidCooldowns");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("GROUP_LEFT");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("UNIT_AURA");
f:RegisterEvent("UNIT_FLAGS");
f:RegisterEvent("PLAYER_FLAGS_CHANGED");
--f:RegisterEvent("UNIT_HEALTH"); --UNIT_HEALTH api was broken in the phase 4 ZA TBC patch, UnitHealth() shows last tick not current tick.
f:RegisterEvent("UNIT_HEALTH_FREQUENT"); --Using UNIT_HEALTH_FREQUENT until Blizzard fix it.
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(...);
	elseif (event == "UNIT_AURA") then
		raidCooldownsUnitAura(...);
		--Update soulstone durations here.
	elseif (event == "UNIT_FLAGS" or event == "PLAYER_FLAGS_CHANGED") then
		raidCooldownsUnitFlags(...);
		--Update soulstone durations here.
	--elseif (event == "UNIT_HEALTH") then
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		raidCooldownsUnitHealth(...);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		NRC:updateRaidCooldownsVisibility();
		local isLogon, isReload = ...;
		if (isReload) then
			NRC:updateSoulstoneDurations();
			if (GetNumGroupMembers() > 1) then
				NRC:startRaidCooldownsTicker();
			end
		end
		C_Timer.After(1, function()
			NRC:raidCooldownsScanGroup();
			NRC:loadPartyNeckBuffs();
		end)
	elseif (event == "ENCOUNTER_START") then
		encounterStart = GetTime();
	elseif (event == "ENCOUNTER_END") then
		local _, _, _, _, success = ...;
		local encounterLength = 0;
		--Incase of DC during boss fight we need to check.
		if (encounterStart) then
			encounterLength = GetTime() - encounterStart;
		end
		if (encounterLength > 30) then
			local instance, instanceType = IsInInstance();
			if (instance and instanceType == "raid") then
				NRC:removeRaidCooldownsEncounterEnd();
			end
		end
	elseif (event == "GROUP_FORMED" or event == "GROUP_JOINED") then
		C_Timer.After(2, function()
			NRC:raidCooldownsScanGroup();
		end)
		C_Timer.After(5, function()
			NRC:removeUngroupedSoulstones();
			NRC:updateSoulstoneDurations();
		end)
		C_Timer.After(1, function()
			NRC:loadPartyNeckBuffs();
		end)
		--NRC:updateRaidCooldowns();
		if (GetNumGroupMembers() > 1) then
			NRC:startRaidCooldownsTicker();
		end
	elseif (event == "GROUP_LEFT") then
		NRC.cooldownList = {};
		isDead = {};
		isGhost = {};
		hpCache = {};
		hasResPending = {};
		NRC:updateRaidCooldowns();
		C_Timer.After(1, function()
			NRC:loadPartyNeckBuffs();
		end)
		NRC:stopRaidCooldownsTicker();
	elseif (event == "GROUP_ROSTER_UPDATE") then
		NRC:updateRaidCooldownsVisibility();
		NRC:updateSoulstoneDurations();
		C_Timer.After(1, function()
			NRC:loadPartyNeckBuffs();
		end)
	end
end)