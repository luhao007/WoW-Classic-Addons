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
	talentFrame.player = name;
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
	if (showOffspec or NRC.isClassic) then
		--Not displaying glyphs for offspec yet, maybe in later version.
		--The data sync will need to rewritten to include offspec glyphs and keep track of which is the active spec since it can't be inspected.
		frame.glyphs:Hide();
	else
		--local glyphText = "|cFF9CD6DEMajor:|r\n";
		--[[glyphText = glyphText .. "(1) Glyph of Test\n";
		glyphText = glyphText .. "(2) Glyph of Test2\n";
		glyphText = glyphText .. "(3) Empty Slot\n";
		glyphText = glyphText .. "|cFF9CD6DEMinor:|r\n";
		glyphText = glyphText .. "(1) Glyph of Test\n";
		glyphText = glyphText .. "(2) Glyph of Test2\n";
		glyphText = glyphText .. "(3) Empty Slot";]]
		if (NRC.glyphs[name]) then
			local data = NRC:createGlyphDataFromString(NRC.glyphs[name]);
			NRC:updateGlyphFrame(data, talentFrame);
			C_Timer.After(0.1, function()
				NRC:updateGlyphFrame(data, talentFrame);
			end)
			talentFrame.glyphs:Show();
		else
			talentFrame.glyphs:Hide();
		end
	end
end

function NRC:updateGlyphFrame(data, frame, name)
	if (not frame) then
		return;
	end
	for i = 1, 6 do
		frame.glyphs["fs" .. i]:SetText("");
	end
	local width = 50;
	if (data) then
		for i = 1, 6 do
			if (data[i] and data[i] > 0) then
				local spell = Spell:CreateFromSpellID(data[i])
				if (spell and not spell:IsSpellEmpty()) then
					spell:ContinueOnSpellLoad(function()
						local name = (spell:GetSpellName() or "Unknown Glyph");
						local _, class = GetClassInfo(data.class);
						--local icon = GetSpellTexture(data[i]);
						local icon;
						if (class) then
							if (i < 4) then
								icon = "Interface\\Icons\\Inv_glyph_major" .. strlower(class);
							else
								icon = "Interface\\Icons\\Inv_glyph_minor" .. strlower(class);
							end
						end
						local texture = "|T134400:0|t";
						if (icon) then
							texture = "|T" .. icon .. ":0|t";
						end
						local itemLink = GetSpellLink(data[i]);
						frame.glyphs["fs" .. i]:SetText(texture .. " " .. (itemLink or "[" .. name .. "]"));
						local w = frame.glyphs["fs" .. i]:GetWidth();
						if (w > width) then
							width = w;
						end
					end)
				else
					frame.glyphs["fs" .. i]:SetText("Error");
				end
			else
				frame.glyphs["fs" .. i]:SetText("|T134400:0|t [Empty Slot]");
			end
		end
	else
		frame.glyphs.fs1:SetText("No glyph data found.");
	end
	frame.glyphs:SetSize(width + 20, 190);
	if (frame:GetName() == "NRCInspectTalentFrame") then
		frame.glyphs:SetScale(0.9);
	else
		frame.glyphs:SetScale(0.8);
	end
	--If name is included then it's a data update and we should check if talent inspect is open waiting for glyph data.
	if (name) then
		--If inspect frame or supplied frame is open then show new glyph data.
		if (NRCInspectTalentFrame and NRCInspectTalentFrame:IsShown() and NRCInspectTalentFrame.player == name) then
			NRCInspectTalentFrame.glyphs:Show();
		end
		if (frame and frame:IsShown() and frame.frame == name) then
			frame.glyphs:Show();
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
	if (NRC.isRetail) then
		local talentString = "0-0-0";
		return talentString;
	else
		local _, _, classID = UnitClass("player");
		local talentString = tostring(classID);
		--Seems all 3 clients are using the new out of order system now.
		--if (NRC.isWrath or NRC.isTBC or NRC.isClassic) then
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
		--[[else
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
		end]]
		return talentString;
	end
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

--First 3 major, second 3 minor.
function NRC:createGlyphString(f)
	if (NRC.isRetail or not GetNumGlyphSockets) then
		return "";
	end
	local _, _, classID = UnitClass("player");
	local glyphString, glyphString2 = classID, classID;
	local activeSpec = GetActiveTalentGroup();
	local offSpec = (activeSpec == 1 and 2 or 1);
	local temp = {};
	local count = 0;
	---Active spec.
	for i = 1, GetNumGlyphSockets() do
		local enabled, type, spellID, icon = GetGlyphSocketInfo(i, activeSpec);
		if (type == 1) then
			count = count + 1;
			temp[count] = spellID or 0;
		end
	end
	table.sort(temp, function(a, b) return a > b end);
	--Make sure filled slots are first.
	for i = 1, 3 do
		glyphString = glyphString .. "-" .. (temp[i] or 0);
	end
	temp = {};
	count = 0;
	for i = 1, GetNumGlyphSockets() do
		local enabled, type, spellID, texture = GetGlyphSocketInfo(i, activeSpec);
		if (type == 2) then
			count = count + 1;
			temp[count] = spellID or 0;
		end
	end
	table.sort(temp, function(a, b) return a > b end);
	for i = 1, 3 do
		glyphString = glyphString .. "-" .. (temp[i] or 0);
	end
	---Offspec.
	temp = {};
	count = 0;
	--Active spec.
	for i = 1, GetNumGlyphSockets() do
		local enabled, type, spellID, icon = GetGlyphSocketInfo(i, offSpec);
		if (type == 1) then
			count = count + 1;
			temp[count] = spellID or 0;
		end
	end
	table.sort(temp, function(a, b) return a > b end);
	--Make sure filled slots are first.
	for i = 1, 3 do
		glyphString2 = glyphString2 .. "-" .. (temp[i] or 0);
	end
	temp = {};
	count = 0;
	for i = 1, GetNumGlyphSockets() do
		local enabled, type, spellID, texture = GetGlyphSocketInfo(i, offSpec);
		if (type == 2) then
			count = count + 1;
			temp[count] = spellID or 0;
		end
	end
	table.sort(temp, function(a, b) return a > b end);
	for i = 1, 3 do
		glyphString2 = glyphString2 .. "-" .. (temp[i] or 0);
	end
	--We're only using current spec glyph string atm, probably add dual spec support later.
	--glyphString2 isn't used by any funcs yet.
	--Glyph data can't be inspected and only gets sent others with the addon so mainspec will always be sent.
	--Mainspec glyphs should always be updated by others with the addon so inspecting main spec should always be in sync.
	--On the inspect frame we only display glyphs for main spec.
	return glyphString, glyphString2;
end

function NRC:createGlyphDataFromString(glyphString)
	local temp = {strsplit("-", glyphString)};
	local data = {};
	for k, v in pairs(temp) do
		if (k == 1) then
			data.class = tonumber(v);
		else
			data[k - 1] = tonumber(v);
		end
	end
	return data;
end