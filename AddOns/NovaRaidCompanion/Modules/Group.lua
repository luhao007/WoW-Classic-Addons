----------------------------------
---NovaRaidCompanion Group Cache--
----------------------------------
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local firstGroupRosterUpdate = true;
local lastSendData = 0;
local units = NRC.units;
local UnitName = UnitName;
local UnitIsDead = UnitIsDead;
local GetNumGroupMembers = GetNumGroupMembers;
local GetRaidRosterInfo = GetRaidRosterInfo;
local strfind = strfind;
local strsplit = strsplit;
local IsInRaid = IsInRaid;
local UnitGUID = UnitGUID;
local pairs = pairs;
local GetNormalizedRealmName = GetNormalizedRealmName;
local tinsert = tinsert;
local cachedGetNormalizedRealmName;

function NRC:updateGroupCache()
	local group = {};
	local updated;
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	local groupMembers = GetNumGroupMembers();
	for i = 1, groupMembers do
		local name, rank, subGroup, level, class, classEnglish, zone, online, isDead, role, loot = GetRaidRosterInfo(i);
		local realm;
		if (name) then
			if (strfind(name, "-")) then
				--Record realm if they're from a different realm than ours.
				name, realm = strsplit(name, "-", 2);
			end
			group[name] = {
				class = classEnglish,
				zone = zone,
				online = online,
				realm = realm,
				subGroup = subGroup,
			};
			if (level > 0) then
				--Level is 0 when offline, don't overwrite the level we already know.
				group[name].level = level;
			elseif (NRC.groupCache[name] and NRC.groupCache[name].level) then
				--Backup data from current cache if nothing returned (offline etc).
				group[name].level = NRC.groupCache[name].level;
			end
			if (zone ~= "Offline") then
				group[name].lastKnownZone = zone;
			end
			if (name == UnitName("player")) then
				group[name].guid = UnitGUID("player");
				group[name].unit = "player";
				--I think it's better to just have player in the unit cache than have seperate lookups for player and group.
				NRC.unitMap[name] = {
					guid = UnitGUID("player"),
					unit = "player",
				};
			else
				for i = 1, groupMembers do
					local nameCheck = UnitName(unitType .. i);
					if (nameCheck == name) then
						local guid = UnitGUID(unitType .. i);
						if (guid) then
							group[name].guid = guid;
							group[name].unit = unitType .. i;
							NRC.unitMap[name] = {
								guid = guid,
								unit = unitType .. i,
							};
						end
						break;
					end
				end
			end
		end
	end
	for k, v in pairs(group) do
		local groupCache = NRC.groupCache[k];
		if (v.level) then
			if (groupCache and groupCache.level ~= v.level) then
				NRC:groupMemberLevelUpdate(k, v);
			end
		end
		if (not groupCache) then
			--Player joined group.
			v.lastOnlineStatus = v.online;
			NRC.groupCache[k] = v;
			NRC:groupMemberJoined(k, v);
			updated = true;
		elseif(groupCache and v.online and not groupCache.lastOnlineStatus) then
			--Player came online.
			v.lastOnlineStatus = true;
			NRC.groupCache[k] = v;
			NRC:groupMemberOnline(k, v);
			updated = true;
		elseif (groupCache and not v.online and groupCache.lastOnlineStatus) then
			--Player went offline.
			v.lastOnlineStatus = nil;
			NRC.groupCache[k] = v;
			NRC:groupMemberOffline(k, v);
			updated = true;
		else
			v.lastOnlineStatus = v.online;
			NRC.groupCache[k] = v;
		end
		--[[if (not NRC.groupCache[k]) then
			--Player joined group.
			v.lastOnlineStatus = v.online;
			NRC.groupCache[k] = v;
			NRC:groupMemberJoined(k, v);
			updated = true;
		elseif(NRC.groupCache[k] and v.online and not NRC.groupCache[k].lastOnlineStatus) then
			--Player came online.
			v.lastOnlineStatus = true;
			NRC.groupCache[k] = v;
			NRC:groupMemberOnline(k, v);
			updated = true;
		elseif (NRC.groupCache[k] and not v.online and NRC.groupCache[k].lastOnlineStatus) then
			--Player went offline.
			v.lastOnlineStatus = nil;
			NRC.groupCache[k] = v;
			NRC:groupMemberOffline(k, v);
			updated = true;
		else
			v.lastOnlineStatus = v.online;
			NRC.groupCache[k] = v;
		end]]
	end
	for k, v in pairs(NRC.groupCache) do
		if (not group[k]) then
			--Player left group.
			NRC.groupCache[k] = nil;
			NRC:groupMemberLeft(k, v);
			updated = true;
		end
	end
	if (updated) then
		NRC:groupRosterChanged();
	end
end

local function updateUnitDeadState(unit)
	if (units[unit]) then
		local name, realm = UnitName(unit);
		if (realm and realm ~= "" and realm ~= NRC.realm) then
			name = name .. "-" .. realm;
		end
		local dead = UnitIsDead(unit);
		if (dead == false) then
			--Replicate GetRaidRosterInfo() behavior.
			dead = nil;
		end
		if (NRC.groupCache[name]) then
			NRC.groupCache[name].isDead = dead;
		end
	end
end

local function removeFromUnitMap(who)
	if (who) then
		for k, v in pairs(NRC.unitMap) do
			if (v.guid == who or k == who) then
				NRC.unitMap[k] = nil;
			end
		end
	end
end

function NRC:groupMemberJoined(name, data)
	if (not data or not data.guid) then
		--There can be no data on certain occasions like BG's etc.
		return;
	end
	--print(name, "joined group")
	NRC.auraCache[data.guid] = {};
	C_Timer.After(5, function()
		NRC:aurasScanGroup();
	end)
	NRC:loadRaidCooldownChar(name, data);
	--Has to be seperately and not inside loadRaidCooldownChar to avoid creating a endless loop.
	--NRC:loadPartyNeckBuffs();
	if (_G["NRCRaidStatusFrame"]) then
		C_Timer.After(0.5, function()
			NRC:updateRaidStatusFrames(true);
		end)
	end
	NRC:throddleEventByFunc("GROUP_ROSTER_UPDATE", 1, "updateHealerCache", "groupMemberJoined");
end

function NRC:groupMemberLeft(name, data)
	if (not data or not data.guid) then
		--There can be no data on certain occasions like BG's etc.
		return;
	end
	--print(name, "left group")
	--NRC.cooldownList[data.guid] = nil;
	NRC.auraCache[data.guid] = nil;
	NRC.durability[name] = nil;
	NRC:removeRaidManaChar(name);
	NRC:removeFromManaCache(name);
	NRC:removeRaidCooldownChar(data.guid);
	NRC:soulstoneRemovedByLeave(name);
	removeFromUnitMap(data.guid);
	NRC:throddleEventByFunc("GROUP_ROSTER_UPDATE", 1, "updateHealerCache", "groupMemberLeft");
	--Has to be seperately and not inside removeRaidCooldownChar to avoid creating a endless loop.
	--NRC:loadPartyNeckBuffs();
	if (_G["NRCRaidStatusFrame"]) then
		C_Timer.After(0.5, function()
			NRC:updateRaidStatusFrames(true);
		end)
		if (_G["NRCRaidStatusFrame"]:IsShown()) then
			C_Timer.After(2, function()
				NRC:updateRaidStatusFrames(true);
			end)
		end
	end
end

function NRC:groupMemberOnline(name, data)
	--print(name, "came online")
	NRC:updateSoulstoneDurations();
	if (NRC.config.sreOnlineStatus) then
		NRC:sreOnlineStatusEvent(name, data.class, true);
	end
end

function NRC:groupMemberOffline(name, data)
	--print(name, "went offline")
	if (NRC.config.sreOnlineStatus) then
		NRC:sreOnlineStatusEvent(name, data.class);
	end
end

function NRC:groupMemberDied(name, data)
	--print(name, "died")
end

function NRC:groupMemberReleased(name, data)
	--print(name, "released")
end

function NRC:groupMemberLevelUpdate(name, data)
	NRC:removeRaidCooldownChar(data.guid);
	NRC:loadRaidCooldownChar(name, data);
	--NRC:debug(name .. " level change")
end

function NRC:groupRosterChanged()
	--print("roster updated")
	NRC:updateRaidCooldowns();
end

local function normalizeNameRealm(msg)
	msg = string.gsub(msg, " ", "");
	msg = string.gsub(msg, "'", "");
	return msg;
end

--Acepts guid or name.
function NRC:inOurGroup(who)
	if (not who) then
		return;
	end
	local isGuid;
	if (strfind(who, "%-.+%-")) then
		isGuid = true;
	end
	if (isGuid) then
		--Check for guid match.
		for k, v in pairs(NRC.groupCache) do
			if (v.guid == who) then
				return true;
			end
		end
	else
		if (NRC.groupCache[who]) then
			return true;
		end
		if (strfind(who, "-")) then
			--Realm was included in the query so attach realms if they don't exist in group cache.
			--No realms means they are on our realm.
			for k, v in pairs(NRC.groupCache) do
				if (not strfind(k, "-")) then
					k = k .. "-" .. (cachedGetNormalizedRealmName or GetNormalizedRealmName());
				end
				if (normalizeNameRealm(k) == normalizeNameRealm(who)) then
					return true;
				end
			end
		else
			--Check for for less reliable name only matches for group members from other realms.
			--Shouldn't ever really be used unless another piece of code isn't including correctly..
			--[[for k, v in pairs(NRC.groupCache) do
				local nameOnly = strsplit(k, "-");
				if (nameOnly == who) then
					return true;
				end
			end]]
		end
	end
end

--Get guid from group member name, accepts name-realm.
--Also accepts just name (less reliable if they ever enable cross realm in tbc, but would be rare to have 2 same names in group).
--Checks class also if no realm is supplied to even further narrow down the right result.
function NRC:getGroupGuidFromName(name, class)
	--Full name.
	if (NRC.groupCache[name]) then
		return NRC.groupCache[name].guid;
	end
	--Check for for less reliable name only matches.
	for k, v in pairs(NRC.groupCache) do
		local nameOnly = strsplit(k, "-");
		if (name == nameOnly and class == v.class) then
			return v.guid;
		end
	end
end

function NRC:getCharDataFromGUID(guid)
	for k, v in pairs(NRC.groupCache) do
		if (guid == v.guid) then
			return v;
		end
	end
end

--[[function NRC:getUnitFromGUID(guid)
	for k, v in pairs(NRC.groupCache) do
		if (guid == v.guid) then
			return v.unit;
		end
	end
end

function NRC:getUnitFromName(name)
	if (NRC.unitMap[name]) then
		return NRC.unitMap[name].unit;
	end
end]]

function NRC:getUnitFromGUID(guid)
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	for i = 1, GetNumGroupMembers() do
		--local name, rank, subGroup, level, class, classEnglish, zone, online, isDead, role, loot = GetRaidRosterInfo(i);
		if (UnitGUID(unitType .. i) == guid) then
			return unitType .. i;
		end
	end
	if (UnitGUID("player") == guid) then
		return "player";
	end
	if (UnitGUID("target") == guid) then
		return "target";
	end
	if (UnitGUID("player") == guid) then
		return "focus";
	end
end

function NRC:getUnitFromName(name)
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	for i = 1, GetNumGroupMembers() do
		if (UnitName(unitType .. i) == name) then
			return unitType .. i;
		end
	end
	if (UnitName("player") == name) then
		return "player";
	end
	if (UnitName("target") == name) then
		return "target";
	end
	if (UnitName("player") == name) then
		return "focus";
	end
end

function NRC:updateHealerCache(func)
	local oldHealerCache = NRC.healerCache;
	local newHealer;
	NRC.healerCache = {};
	for k, v in pairs(NRC.talents) do
		local _, _, specName, specIcon, _, _, class = NRC:getSpecFromTalentString(v);
		if (specName and NRC:inOurGroup(k)) then
			if (NRC.healingSpecs[specName]) then
				local t = {
					name = k,
					specName = specName,
					icon = specIcon,
					class = class,
				};
				tinsert(NRC.healerCache, t);
			end
		end
	end
	for k, v in pairs(NRC.healerCache) do
		local found;
		for kk, vv in pairs(oldHealerCache) do
			if (v.name == vv.name) then
				found = true;
			end
		end
		if (not found) then
			newHealer = true;
			NRC:debug("New healer found:", v.name);
		end
	end
	table.sort(NRC.healingSpecs, function(a, b)
		return a.class < b.class
			or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
	end)
	if (newHealer) then
		NRC:throddleEventByFunc("GROUP_ROSTER_UPDATE", 2, "loadTrackedManaChars", func or "updateHealerCache");
	end
	--NRC:debug("Healer Cache:", func);
end

function NRC:isHealer(name)
	if (NRC.healerCache[name]) then
		return true;
	end
end

---Inspect functions, needed so we can get accurate cooldowns of talented spells like bop, and talent only spells like mana tide.
---This is messy in classic because of very short inspect range but we'll see how it goes...
---If another addon or lib inspects a player it will be removed from our queue.
---Inspect one player every inspectInterval if within inspect range and it's been inspectCooldown since last try on player.
---We wait inspectTimeout if no response from server since last inspect before trying next.
---If we get a response then inspectTimeout is reset and we inspect next.
---inspectInterval time between inspects, even if it's faster than server throddle the timeout will cover it, everyone will still get inspected.

local distanceIndex = 4;
local inspectInterval = 5;
local inspectTimeout = 10;
local inspectCooldown = 60;
local inspectQueue = {};
local lastInspectAttempt = {};
local lastInspect = 0;
local lastAttempt = 0;
local inspectSuccess = {};
local queueRunning;
local inspectingGUID;
local inspectFrameTalents;
local inspectFrameTalentsGUID;

local f = CreateFrame("Frame", "NRCGroup");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("INSPECT_READY");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "UNIT_SPELLCAST_SUCCEEDED") then
		local unit, _, spellID = ...;
		if (strfind(unit, "party") or strfind(unit, "raid")) then
			--Spec change.
			if (spellID == 63644 or spellID == 63645) then
				local guid = UnitGUID(unit);
				if (guid) then
					NRC:inspect(guid);
				end
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isLogon, isReload = ...;
		if (isReload) then
			C_Timer.After(5, function()
				NRC:loadInspectQueue();
			end)
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		if (IsInGroup()) then
			NRC:throddleEventByFunc(event, 3, "loadInspectQueue", ...);
		end
	elseif (event == "INSPECT_READY") then
		local guid = ...;
		NRC:receivedInspect(guid);
	end
end)

local function inspectTicker()
	if (not IsInGroup()) then
		NRC:stopInspectQueue();
		return;
	end
	if (InspectFrame and InspectFrame:IsShown()) then
		--Pause if InspectFrame open.
		C_Timer.After(2, function()
			inspectTicker();
		end)
		return;
	end
	if (next(inspectQueue)) then
		if (GetTime() - lastInspect > inspectTimeout) then
			NRC:stopCurrentInspect();
			if (not UnitIsDead("player") and not InCombatLockdown()
					and GetTime() - lastAttempt > inspectInterval) then
				inspectingGUID = ni;
				for k, guid in pairs(inspectQueue) do
					local unit = NRC:getUnitFromGUID(guid);
					if (unit and UnitExists(unit) and CheckInteractDistance(unit, distanceIndex) and UnitIsConnected(unit)
							and (not lastInspectAttempt[guid] or GetTime() - lastInspectAttempt[guid] > inspectCooldown)) then
						--Even though we checked range with CheckInteractDistance() it can be a little unreliable.
						--So disable error msgs for a split second while we inspect.
						local registerErrors, enableErrorFilter;
						if (UIErrorsFrame:IsEventRegistered("UI_ERROR_MESSAGE")) then
							registerErrors = true;
							UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE");
						end
						if (ErrorFilter) then
							--If Error Filter installed disable events for a split second and reenable them after NotifyInspect().
							ErrorFilter:UnregisterEvent("UI_ERROR_MESSAGE");
							enableErrorFilter = true;
						end
						--CanInspect() gives UI error feedback to user so run this after errors are disabled.
						if (CanInspect(unit)) then
							lastInspectAttempt[guid] = GetTime();
							lastInspect = GetTime();
							lastAttempt = GetTime(); --This is seperate to lastInspect so it can be reset to 0 for interval reasons.
							inspectingGUID = guid;
							NotifyInspect(unit);
							if (registerErrors) then
								UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
							end
							if (enableErrorFilter) then
								ErrorFilter:UpdateEvents();
							end
							break;
						end
						if (registerErrors) then
							UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
						end
						if (enableErrorFilter) then
							ErrorFilter:UpdateEvents();
						end
					end
				end
			end
		end
		C_Timer.After(1, function()
			inspectTicker();
		end)
	else
		NRC:stopInspectQueue();
	end
end

--Load a queue from group cache.
function NRC:loadInspectQueue()
	if (IsInGroup()) then
		inspectQueue = {};
		local me = UnitName("player");
		for k, v in pairs(NRC.groupCache) do
			--For now we only inspect each player once per session.
			if (v.guid and k ~= me and not inspectSuccess[v.guid]) then
				tinsert(inspectQueue, v.guid);
			end
		end
		if (next(inspectQueue)) then
			NRC:startInspectQueue();
		end
	end
end

function NRC:startInspectQueue()
	if (not queueRunning) then
		--NRC:debug("starting inspect queue");
		queueRunning = true;
		inspectTicker();
	end
end

function NRC:stopInspectQueue()
	--NRC:debug("stopping inspect queue");
	inspectQueue = {};
	queueRunning = false;
end

--Inspect a single player.
function NRC:inspect(guid, priority)
	local me = UnitGUID("player");
	if (guid == me) then
		return;
	end
	lastInspectAttempt[guid] = nil;
	if (priority) then
		tinsert(inspectQueue, guid, 1);
	else
		tinsert(inspectQueue, guid);
	end
	if (next(inspectQueue)) then
		NRC:startInspectQueue();
	end
end

function NRC:getGroupInspectCount()
	local count = 0;
	for k, v in pairs(NRC.groupCache) do
		if (NRC.talents[k]) then
			count = count + 1;
		end
	end
	return count;
end

function NRC:sendInspectData(guid, talentString)

end

function NRC:receivedInspect(guid)
	inspectFrameTalentsGUID = guid;
	if (not NRC:inOurGroup(guid)) then
		return;
	end
	local name = UnitName(guid);
	--local inspected = NRC:getGroupInspectCount() .. "/" .. GetNumGroupMembers();
	--NRC:debug("received inspect", guid, inspected);
	lastAttempt = 0;
	for k, v in pairs(inspectQueue) do
		if (v == guid) then
			inspectQueue[k] = nil;
		end
	end
	local talentString;
	if (guid) then
		inspectSuccess[guid] = GetServerTime();
		talentString = NRC:addTalentStringFromInspect(guid);
		--NRC:buildInventoryFromInspect(guid);
	end
	--If the inspect result is from our queue.
	if (guid == inspectingGUID) then
		if (talentString) then
			NRC:sendInspectData(guid, talentString);
		end
		inspectingGUID = nil;
	end
	NRC:updateHealerCache("receivedInspect");
	NRC:updateTrackedManaCharTalents(name);
end

function NRC:stopCurrentInspect()
	inspectingGUID = nil;
	ClearInspectPlayer();
end

--Add talents to cache.
function NRC:addTalentStringFromInspect(guid)
	local talentString, talentString2 = NRC:createTalentStringFromInspect(guid);
	if (talentString) then
		local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
		local nameRealm = name .. "-" ..  realm;
		if (NRC.groupCache[name]) then
			--NRC:debug("added talents from inspect", name);
			NRC.talents[name] = talentString;
			NRC:loadRaidCooldownChar(name, NRC.groupCache[name]);
		elseif (NRC.groupCache[nameRealm]) then
			NRC.talents[nameRealm] = talentString;
			NRC:loadRaidCooldownChar(nameRealm, NRC.groupCache[nameRealm]);
		end
		if (talentString2) then
			if (NRC.groupCache[name]) then
				--NRC:debug("added talents from inspect", name);
				NRC.talents2[name] = talentString2;
			elseif (NRC.groupCache[nameRealm]) then
				NRC.talents2[nameRealm] = talentString2;
			end
		end
		return talentString;
	end
end

--function NRC:buildInventoryFromInspect(guid)
	--Don't use this for now, we don't want to keep inspecting for gear changes so it would be unreliable.
--end

function NRC:createTalentStringFromInspect(guid)
	local talentString, talentString2;
	local unit = NRC:getUnitFromGUID(guid);
	local _, class = GetPlayerInfoByGUID(guid);
	local classID;
	for i = 1, GetNumClasses() do
		local className, classFile, id = GetClassInfo(i);
		if (class == classFile) then
			classID = id;
			break;
		end
	end
	--Fallback just incase, less reliable mapping units to group until I get NRC:getUnitFromGUID() working better.
	if (unit and not classID) then
		_, _, classID = UnitClass(unit);
	end
	if (not classID) then
		return;
	end
	if (NRC.isWrath) then
		if (unit or classID) then
			local data = {
				classID = classID,
			};
			local data2 = {
				classID = classID,
			};
			--Number of talents varies by class, but if we get a rough num for this expansion and add 20 it should cover it.
			--We stop iteration when we reach nil (end of talent tree) anyway.
			local numTalents = GetNumTalents(1) + 20;
			if (classID) then
				talentString = tostring(classID);
				talentString2 = tostring(classID);
				local activeSpec = GetActiveTalentGroup(true);
				local offSpec = (activeSpec == 1 and 2 or 1);
				for tab = 1, GetNumTalentTabs() do
					data[tab] = {};
					data2[tab] = {};
					for i = 1, numTalents do
						local name, _, row, column, rank = GetTalentInfo(tab, i, true, nil, activeSpec);
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
					for i = 1, numTalents do
						local name, _, row, column, rank = GetTalentInfo(tab, i, true, nil, offSpec);
						if (name) then
							data2[tab][i] = {
								rank = rank,
								row = row,
								column = column,
							};
						else
							break;
						end
					end
				end
			end
			talentString = NRC:createTalentStringFromTable(data);
			talentString2 = NRC:createTalentStringFromTable(data2);
		end
		--if (talentString and not strfind(talentString, "0%-0%-0")) then
			return talentString, talentString2;
		--end
	else
		if (unit or classID) then
			--Number of talents varies by class, but if we get a rough num for this expansion and add 20 it should cover it.
			--We stop iteration when we reach nil (end of talent tree) anyway.
			local numTalents = GetNumTalents(1) + 20;
			if (classID) then
				talentString = tostring(classID);
				for tab = 1, GetNumTalentTabs() do
					local found;
					local treeString = "";
					for i = 1, numTalents do
						local name, _, _, _, rank = GetTalentInfo(tab, i, true);
						if (name) then
							treeString = treeString .. rank;
							if (rank and rank > 0) then
								found = true;
							end
						else
							break;
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
		end
		--if (talentString and not strfind(talentString, "0%-0%-0")) then
			return talentString;
		--end
	end
end

local inspectTalentsCheckBox, inspectTalentsFrame;
local function openInspectTalentsFrame()
	if (not InspectFrame) then
		return;
	end
	if (not inspectTalentsFrame) then
		if (NRC.isWrath) then
			inspectTalentsFrame = NRC:createTalentFrame("NRCInspectTalentFrame", 870, 540, 0, 0, 3);
		else
			inspectTalentsFrame = NRC:createTalentFrame("NRCInspectTalentFrame", 870, 480, 0, 0, 3);
		end
		inspectTalentsFrame.closeButton:SetScript("OnClick", function(self, arg)
			inspectTalentsFrame:Hide();
			if (InspectFrameCloseButton and InspectFrame and InspectFrame:IsShown()) then
				InspectFrameCloseButton:Click();
			end
		end)
		inspectTalentsFrame.fs:SetText("|cFFFFFF00Nova Raid Companion");
		inspectTalentsFrame:ClearAllPoints();
	end
	local guid = inspectFrameTalentsGUID;
	if (guid) then
		if (InspectFrameCloseButton) then
			inspectTalentsFrame:SetPoint("TOPLEFT", InspectFrameCloseButton, "TOPRIGHT", 20, -8);
		else
			inspectTalentsFrame:SetPoint("TOPLEFT", InspectFrame, "TOPRIGHT", 20, -8);
		end
		local _, classEnglish, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
		--[[local classID;
		for i = 1, GetNumClasses() do
			local className, classFile, id = GetClassInfo(i);
			if (classEnglish == classFile) then
				classID = id;
				break;
			end
		end]]
		local talentString, talentString2 = NRC:createTalentStringFromInspect(guid);
		if (talentString) then
			NRC:updateTalentFrame(name, talentString, inspectTalentsFrame, talentString2);
			inspectTalentsFrame:SetScale(0.875);
			inspectTalentsFrame:Show();
		end
	end
end

function NRC:hookTalentsFrame()
	if (inspectTalentsCheckBox or not InspectFrame) then
		return;
	end
	inspectTalentsCheckBox = CreateFrame("CheckButton", "NRCRaidStatusFrameCheckbox", InspectFrame, "ChatConfigCheckButtonTemplate");
	inspectTalentsCheckBox.Text:SetText("|cFFFFFF00" .. L["NRC Talents"]);
	inspectTalentsCheckBox.Text:SetFont(NRC.regionFont, 11);
	inspectTalentsCheckBox.Text:SetPoint("LEFT", inspectTalentsCheckBox, "RIGHT", -2, 1);
	inspectTalentsCheckBox.tooltip = L["inspectTalentsCheckBoxTooltip"];
	inspectTalentsCheckBox:SetFrameStrata("HIGH");
	inspectTalentsCheckBox:SetFrameLevel(9);
	inspectTalentsCheckBox:SetWidth(20);
	inspectTalentsCheckBox:SetHeight(20);
	inspectTalentsCheckBox:SetPoint("TOPRIGHT", InspectFrame, -105, -53);
	inspectTalentsCheckBox:SetHitRectInsets(0, 0, -10, 7);
	--inspectTalentsCheckBox:SetBackdropBorderColor(0, 0, 0, 1);
	inspectTalentsCheckBox:SetChecked(NRC.config.showInspectTalents);
	inspectTalentsCheckBox:SetScript("OnClick", function()
		local value = inspectTalentsCheckBox:GetChecked();
		NRC.config.showInspectTalents = value;
		if (not value) then
			if (inspectTalentsFrame) then
				inspectTalentsFrame:Hide();
			end
		else
			if (InspectFrame and InspectFrame:IsShown()) then
				openInspectTalentsFrame();
			end
		end
		NRC.acr:NotifyChange("NovaRaidCompanion");
	end);
	InspectFrame:HookScript("OnShow", function(self)
		if (NRC.config.showInspectTalents) then
			openInspectTalentsFrame();
		end
	end)
	InspectFrame:HookScript("OnHide", function(self)
		inspectFrameTalentsGUID = nil;
		if (_G["NRCInspectTalentFrame"]) then
			inspectTalentsFrame:Hide();
		end
	end)
	--Move checkbox depending on which tab is shown.
	InspectPaperDollFrame:HookScript("OnShow", function(self)
		inspectTalentsCheckBox:SetPoint("TOPRIGHT", InspectFrame, -105, -53);
	end)
	InspectPVPFrame:HookScript("OnShow", function(self)
		inspectTalentsCheckBox:SetPoint("TOPRIGHT", InspectFrame, -105, -38);
	end)
	InspectTalentFrame:HookScript("OnShow", function(self)
		inspectTalentsCheckBox:SetPoint("TOPRIGHT", InspectFrame, -105, -34);
	end)
end

--Update checkbox if we change via addon config.
function NRC:updateInspectTalentsCheckBoxFromConfig(value)
	if (InspectFrame and InspectFrame:IsShown()) then
		inspectTalentsCheckBox:SetChecked(value);
	end
	if (not value) then
		if (inspectTalentsFrame) then
			inspectTalentsFrame:Hide();
		end
	else
		if (InspectFrame and InspectFrame:IsShown()) then
			openInspectTalentsFrame();
		end
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("GROUP_LEFT");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("UNIT_FLAGS");
f:RegisterEvent("UNIT_CONNECTION");
f:RegisterEvent("ADDON_LOADED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "UNIT_FLAGS") then
		local unit = ...;
		--if (strfind(unit, "party") or strfind(unit, "raid")) then
		--	NRC:throddleEventByFunc(event, 1, "updateGroupCache", ...);
		--end
		updateUnitDeadState(unit);
	elseif (event == "GROUP_ROSTER_UPDATE" or event == "GROUP_FORMED" or event == "GROUP_JOINED"
		or event == "PLAYER_ENTERING_WORLD") then
		firstGroupRosterUpdate = nil;
		C_Timer.After(0.5, function()
			NRC:updateGroupCache();
		end);
		if (event == "PLAYER_ENTERING_WORLD") then
			local isLogon, isReload = ...;
			if (isReload and IsInGroup()) then
				NRC:throddleEventByFunc(event, 1, "loadGroupMana", ...);
				NRC:throddleEventByFunc(event, 2, "updateHealerCache", "PLAYER_ENTERING_WORLD");
			end
			if (not cachedGetNormalizedRealmName and GetNormalizedRealmName()) then
				cachedGetNormalizedRealmName = GetNormalizedRealmName();
			end
		end
		if (event == "GROUP_FORMED" or event == "GROUP_JOINED") then
			--Note: These events don't trigger on reload only login and when joining a group.
			--Sometimes we get both these events so have a cooldown to not send data twice.
			if (GetTime() - lastSendData > 2 and GetNumGroupMembers() > 1) then
				lastSendData = GetTime();
				--NRC:throddleEventByFunc(event, 5, "requestData", ...);
				NRC:throddleEventByFunc(event, 1, "loadGroupMana", ...);
				NRC:throddleEventByFunc(event, 2, "updateHealerCache", "GROUP_JOINED");
			end
		end
		if (event == "GROUP_ROSTER_UPDATE") then
			if (_G["NRCRaidStatusFrame"] and _G["NRCRaidStatusFrame"]:IsShown()) then
				C_Timer.After(1, function()
					NRC:updateRaidStatusFrames(true);
				end)
			end
		end
	elseif (event == "PLAYER_LOGIN") then
		--Roster data seems to be unreliable at logon, run it again after a short while.
		C_Timer.After(20, function()
			NRC:updateGroupCache();
		end);
		NRC.logonTime = GetServerTime();
	elseif (event == "UNIT_CONNECTION") then
		local unit = ...;
		if (strfind(unit, "party") or strfind(unit, "raid")) then
			C_Timer.After(0.5, function()
				NRC:updateGroupCache();
			end);
		end
	elseif (event == "ADDON_LOADED") then
		local addon = ...;
		if (addon == "Blizzard_InspectUI") then
			NRC:hookTalentsFrame();
		end
	elseif (event == "GROUP_LEFT") then
		NRC.groupCache = {};
		NRC.unitMap = {};
		--NRC.healerCache = {};
		NRC:updateHealerCache();
	end
end)