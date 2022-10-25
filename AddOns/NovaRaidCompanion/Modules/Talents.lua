------------------------------
---NovaRaidCompanion Talents--
------------------------------
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local talentFrame;
local strsplit = strsplit;
local strsub = strsub;
local tonumber = tonumber;

function NRC:loadTalentFrame()
	if (talentFrame) then
		return;
	end
	if (NRC.isWrath) then
		talentFrame = NRC:createTalentFrame("NRCTalentFrame", 870, 540, 0, 200, 3);
	else
		talentFrame = NRC:createTalentFrame("NRCTalentFrame", 870, 480, 0, 200, 3);
	end
	talentFrame.fs:SetText("|cFFFFFF00Nova Raid Companion");
	talentFrame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	talentFrame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			talentFrame:SetUserPlaced(false);
			NRC.db.global[talentFrame:GetName() .. "_point"], _, NRC.db.global[talentFrame:GetName() .. "_relativePoint"], 
					NRC.db.global[talentFrame:GetName() .. "_x"], NRC.db.global[talentFrame:GetName() .. "_y"] = talentFrame:GetPoint();
		end
	end)
	talentFrame:SetScript("OnHide", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	if (NRC.db.global[talentFrame:GetName() .. "_point"]) then
		talentFrame.ignoreFramePositionManager = true;
		talentFrame:ClearAllPoints();
		talentFrame:SetPoint(NRC.db.global[talentFrame:GetName() .. "_point"], nil, NRC.db.global[talentFrame:GetName() .. "_relativePoint"],
				NRC.db.global[talentFrame:GetName() .. "_x"], NRC.db.global[talentFrame:GetName() .. "_y"]);
		talentFrame:SetUserPlaced(false);
	end
end

function NRC:openTalentFrame(name, talentString)
	 NRC:updateTalentFrame(name, talentString);
	 talentFrame:Show();
end

function NRC:updateTalentFrame(name, talentString, frame, talentString2, showOffspec)
	local talentFrame = frame or talentFrame;
	--talentFrame.activeSpec = talentString;
	--talentFrame.offSpec = talentString2;
	local displayTalentString = talentString;
	if (talentString2) then
		if (showOffspec) then
			displayTalentString = talentString2;
			talentFrame.button:SetScript("OnClick", function(self, arg)
				NRC:updateTalentFrame(name, talentString, frame, talentString2);
			end)
			talentFrame.button:SetText("View Active Talents");
		else
			talentFrame.button:SetScript("OnClick", function(self, arg)
				NRC:updateTalentFrame(name, talentString, frame, talentString2, true);
			end)
			talentFrame.button:SetText("View Offspec Talents");
		end
		talentFrame.button:Show();
	else
		talentFrame.button:Hide();
	end
	local classID, trees = strsplit("-", displayTalentString, 2);
	classID = tonumber(classID);
	local class, classEnglish = GetClassInfo(classID);
	talentFrame.setClass(classEnglish, classID);
	local specID, talentCount, specName, specIcon, specIconPath, treeData = NRC:getSpecFromTalentString(displayTalentString);
	trees = {strsplit("-", trees, 4)};
	talentFrame.disableAllTalentFrames();
	local _, _, _, classHex = GetClassColor(classEnglish);
	local text = "|c" .. classHex .. name .. "|r";
	if (not specName) then
		specName = "No Spec"
	end
	text = text .. "  |cFF9CD6DE(" .. treeData[1] .. "/" .. treeData[2] .. "/" .. treeData[3] .. ")|r  |cFF9CD6DE" .. specName .. "|r";
	if (talentString2) then
		if (showOffspec) then
			talentFrame.fs4:SetText("|cFFFF6900(Offspec Talents)");
		else
			talentFrame.fs4:SetText("|cFF3CE13F(Active Talents)");
		end
	else
		talentFrame.fs4:SetText("");
	end
	talentFrame.fs2:SetText(text);
	local totalPointsSpent = NRC:getTotalTalentCount(displayTalentString);
	if (totalPointsSpent == 0) then
		talentFrame.fs3:SetText("|cFFFF2222" .. totalPointsSpent .. " |cFFFFFF00Points Spent");
	else
		talentFrame.fs3:SetText("|cFFFFFF00" .. totalPointsSpent .. " Points Spent");
	end
	talentFrame.titleTexture:SetTexture(specIcon or 134400);
	local talentData = NRC:getTalentData(classEnglish);
	for tree, talents in ipairs(trees) do
		talentFrame.trees[tree].fs:SetText("|cFFFFFF00" .. talentData[tree].info.name .. "|r |cFF9CD6DE(" .. treeData[tree] .. ")|r");
		--Iterate talents in each tree.
		for i = 1, #talents do
			local talent = tonumber(strsub(talents, i, i));
			local frame = talentFrame.talentFrames[tree][i];
			if (talent > 0) then
				frame.currentRank = talent;
				frame.texture:SetDesaturated();
				frame:SetAlpha(1);
				frame.rankTexture:Show();
				frame.rankFS:Show();
				if (talent < frame.maxRank) then
					frame.rankFS:SetText("|c" .. GREEN_FONT_COLOR:GenerateHexColor() .. talent);
					frame.outerTexture:SetVertexColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
				else
					frame.outerTexture:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
					frame.rankFS:SetText("|c" .. NORMAL_FONT_COLOR:GenerateHexColor() .. talent);
				end
			else
				frame:SetAlpha(0.7);
				frame.currentRank = 0;
			end
		end
	end
end

--Get players talents by name and encounter.
function NRC:getTalentsFromEncounter(name, logID, encounterID, attemptID)
	local data = NRC.db.global.instances[logID];
	if (data) then
		--Check if we have an exact match for this encounter and/or attemptID.
		if (data.encounters) then
			local talentCache = {};
			if (attemptID) then
				--If attemptID we want the specific attempt.
				for k, v in ipairs(data.encounters) do
					--Get last recorded talents before this encounter.
					if (k == attemptID) then
						if (v.talentCache and v.talentCache[name]) then
							talentCache = v.talentCache[v.talentCache];
						end
					end
				end
			else
				for k, v in ipairs(data.encounters) do
					--If attemptID not specified then get any talents for this encounter.
					if (v.encounterID == encounterID) then
						if (v.talentCache and v.talentCache[name]) then
							talentCache = v.talentCache[name];
						end
					end
				end
			end
			--Encounter talents are only recorded if they changed so we need to do some checking of other encounters before this one.
			if (not talentCache) then
				--Get last recorded talents before this encounter.
				local backupTalents
				for k, v in ipairs(data.encounters) do
					if (v.talentCache and v.talentCache[name]) then
						backupTalents = v.talentCache[name];
					end
					--Only break if we have talents found because maybe the bosses were killed out of order and we want las known before.
					if (backupTalents) then
						--Only before this attemptID if specified.
						if (attemptID and k == attemptID) then
							break;
						end
						--encounterIDs are in numerical order mostly so we can check before it too if specified.
						if (encounterID and encounterID > v.encounterID) then
							break;
						end
					end
				end
				if (backupTalents) then
					talentCache = backupTalents;
				end
			end
			return talentCache;
		end
	end
end

--Get whole raids talents table by encounter.
function NRC:getAllTalentsFromEncounter(logID, encounterID, attemptID)
	local data = NRC.db.global.instances[logID];
	if (data) then
		--Check if we have an exact match for this encounter and/or attemptID.
		if (data.encounters) then
			local talentCache = {};
			if (attemptID) then
				--If attemptID we want the specific attempt.
				for k, v in ipairs(data.encounters) do
					--Get last recorded talents before this encounter.
					if (k == attemptID) then
						if (v.talentCache) then
							talentCache = v.talentCache;
						end
					end
				end
			else
				for k, v in ipairs(data.encounters) do
					--If attemptID not specified then get any talents for this encounter.
					if (v.encounterID == encounterID) then
						if (v.talentCache) then
							talentCache = v.talentCache;
						end
					end
				end
			end
			--Encounter talents are only recorded if they changed so we need to do some checking of other encounters before this one.
			--Check if any group members are missing because they may only be cached from the first boss if talents haven't changed.
			for k, v in pairs(data.group) do
				local name = v.name;
				if (name) then
					if (not talentCache[name]) then
						local backupTalents;
						--Get last recorded talents before this encounter.
						for k, v in ipairs(data.encounters) do
							if (v.talentCache and v.talentCache[name]) then
								backupTalents = v.talentCache[name];
							end
							--Only break if we have talents found because maybe the bosses were killed out of order and we want las known before.
							if (backupTalents) then
								--Only before this attemptID if specified.
								if (attemptID and k == attemptID) then
									break;
								end
								--encounterIDs are in numerical order mostly so we can check before it too if specified.
								if (encounterID and encounterID > v.encounterID) then
									break;
								end
							end
						end
						if (backupTalents) then
							talentCache[name] = backupTalents
						end
					end
				end
			end
			if (talentCache) then
				return talentCache;
			end
		end
	end
end

function NRC:getSpecFromTalentString(talentString)
	if (talentString) then
		local classID, treeData = strsplit("-", talentString, 2);
		if (not classID) then
			return;
		end
		classID = tonumber(classID);
		local trees = {strsplit("-", treeData, 4)};
		local specID = 0;
		local talentCount = 0;
		local treeData = {};
		for k, v in ipairs(trees) do
			local treeCount = 0;
			--Count talents in each tree.
			for i = 1, #v do
			    local num = tonumber(strsub(v, i, i));
			  	treeCount = treeCount + num;
			end
			if (treeCount > talentCount) then
				talentCount = treeCount;
				specID = k;
			end
			treeData[k] = treeCount;
		end
		local specName, specIcon, specIconPath = NRC.getSpecData(classID, specID);
		local _, className = GetClassInfo(classID)
		return specID, talentCount, specName, specIcon, specIconPath, treeData, className;
	end
end

--In wrath GetTalentInfo() is no longer sorted by index by instead random, so we need to sort it when creating strings.
--So we need to feed this a talent table and sort it for we can create our in order talent string.
function NRC:createTalentStringFromTable(data)
	--Example talent data.
	--[[data = {
		classID = 1,
		[1] = { --Trees.
			[1] = {	--Data as gotten by GetTalentInfo(tree, 1), not in index order anymore for wrath.
				rank = 5,
				row = 2,
				column = 4,
			}
		}
		[2] = {
		[3] = {
	}]]
	--Sort by row and column.
	for k, v in ipairs(data) do
		table.sort(v, function(a, b)
			if (a.row == b.row) then
				return a.column < b.column;
			else
				return a.row < b.row;
			end
		end)
	end
	local talentString = tostring(data.classID);
	local hasTalentData;
	for treeID, treeData in ipairs(data) do
		hasTalentData = true;
		local found;
		local treeString = "";
		for talentID, talentData in ipairs(treeData) do
			treeString = treeString .. talentData.rank;
			if (talentData.rank > 0) then
				found = true;
			end
		end
		treeString = strmatch(treeString, "^(%d-)0*$");
		if (found) then
			talentString = talentString .. "-" .. treeString;
		else
			talentString = talentString .. "-0";
		end
	end
	if (not hasTalentData) then
		return talentString .. "-0-0-0"
	else
		return talentString;
	end
end

function NRC:createTalentString()
	local _, _, classID = UnitClass("player");
	local talentString = tostring(classID);
	if (NRC.isWrath) then
		local data = {
			classID = classID,
		};
		for tab = 1, GetNumTalentTabs() do
			data[tab] = {};
			for i = 1, GetNumTalents(tab) do
				local name, _, row, column, rank = GetTalentInfo(tab, i);
				if (name) then
					data[tab][i] = {
						rank = rank,
						row = row,
						column = column,
					};
				else
					break;
				end
			end
		end
		talentString = NRC:createTalentStringFromTable(data);
	else
		for tab = 1, GetNumTalentTabs() do
			local found;
			local treeString = "";
			for i = 1, GetNumTalents(tab) do
				local name, _, _, _, rank = GetTalentInfo(tab, i);
				treeString = treeString .. rank;
				if (rank and rank > 0) then
					found = true;
				end
			end
			treeString = strmatch(treeString, "^(%d-)0*$");
			if (found) then
				talentString = talentString .. "-" .. treeString;
			else
				talentString = talentString .. "-0";
			end
		end
	end
	return talentString;
end

function NRC:hasTalent(name, tabIndex, talentIndex, count)
	if (name and NRC.talents[name]) then
		local classID, talents = strsplit("-", NRC.talents[name], 2);
		local trees = {strsplit("-", talents, 4)};
		if (trees[tabIndex]) then
			local talent = strsub(trees[tabIndex], talentIndex, talentIndex);
			if (talent and tonumber(talent)) then
				if (tonumber(talent) >= count) then
					return true;
				end
			end
		end
	end
end

function NRC:getTalentCount(name, tabIndex, talentIndex)
	if (name and NRC.talents[name]) then
		local classID, talents = strsplit("-", NRC.talents[name], 2);
		local trees = {strsplit("-", talents, 4)};
		if (trees[tabIndex]) then
			local talent = strsub(trees[tabIndex], talentIndex, talentIndex);
			if (talent) then
				return tonumber(talent);
			end
		end
	end
	return 0;
end

function NRC:getTotalTalentCount(talentString)
	local count = 0;
	local trees = {strsplit("-", talentString, 4)};
	for k, v in ipairs(trees) do
		--First is classID, skip that.
		if (k > 1) then
			for i = 1, #v do
			    local c = strsub(v, i, i);
			    count = count + c;
			end
		end
	end
	return count;
end

--Return a copy of the current raid talents from out talent cache (only current raid members).
function NRC:copyRaidTalents()
	local obj = {};
	for k, v in pairs(NRC.talents) do
		if (NRC:inOurGroup(k)) then
			obj[k] = v;
		end
	end
	if (next(obj)) then
		local talents = NRC:tableCopy(obj);
		return talents;
	end
end