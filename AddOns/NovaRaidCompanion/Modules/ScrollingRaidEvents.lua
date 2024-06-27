--------------------------------------------
---NovaRaidCompanion Scrolling Raid Events--
--------------------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local scrollingRaidEventsFrame, doSRE;
local spellList, resSpellsCache, magePortals = {}, {}, {};
local lineFrameHeight = 15;
local sreEventsFrame = CreateFrame("Frame", "NRCScrollingRaidEvents");
local isEnglish = NRC.isEnglish();
local groupMembersOnly, showSelf;
local testData, testRunning, testRunningTimer, testRunningTimer2;
local strfind = strfind;
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local GetTime = GetTime;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local tinsert = tinsert;
local GetSpellInfo = GetSpellInfo;
local UnitName = UnitName;
local UnitClass = UnitClass;

local function loadResSpellsCache()
	resSpellsCache = {};
	if (NRC.config.sreShowResurrections) then
		for k, v in pairs(NRC.resurrectionSpells) do
			resSpellsCache[k] = {
				name = v.name,
				icon = v.icon,
			};
		end
	end
end

local function loadMagePortalsCache()
	magePortals = {};
	if (NRC.config.sreShowMagePortals) then
		for k, v in pairs(NRC.magePortals) do
			magePortals[k] = {
				name = v.name,
				icon = v.icon,
			};
		end
	end
end

function NRC:loadScrollingRaidEventsFrames()
	if (not NRC.config.sreEnabled) then
		NRC:updateSreState();
		return;
	end
	if (not scrollingRaidEventsFrame) then
		scrollingRaidEventsFrame = NRC:createAutoScrollingFrame("NRCScrollingRaidEvents", 30, NRC.config.sreScrollHeight, -300, 80, NRC.config.sreLineFrameHeight);
		--scrollingRaidEventsFrame:Hide();
		lineFrameHeight = NRC.config.sreLineFrameHeight;
		scrollingRaidEventsFrame.lineFrameHeight = NRC.config.sreLineFrameHeight;
		scrollingRaidEventsFrame:SetBackdropColor(0, 0, 0, 0);
	end
	NRC:updateSreState();
	NRC:sreUpdateSettings();
	NRC:sreLoadSpellList();
	NRC:sreUpdateFrameLocks();
end

function NRC:openScrollingRaidEventsFrame()
	if (not scrollingRaidEventsFrame) then
		NRC:loadScrollingRaidEventsFrames();
	end
	if (scrollingRaidEventsFrame:IsShown()) then
		scrollingRaidEventsFrame:Hide();
	else
		local fontSize = false;
		scrollingRaidEventsFrame:Show();
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame:IsShown()) then
			scrollingRaidEventsFrame:SetFrameStrata("DIALOG");
		else
			scrollingRaidEventsFrame:SetFrameStrata("MEDIUM");
		end
		NRC:sreLoadSpellList();
	end
end

local dpsPotions, manaPotions, healingPotions = {}, {}, {};
function NRC:sreLoadSpellList()
	spellList = {};
	dpsPotions, manaPotions, healingPotions = {}, {}, {};
	--Res spells and mage portals are handled outside of the spellList table.
	loadResSpellsCache();
	loadMagePortalsCache();
	for k, v in pairs(self.config.sreCustomSpells) do
		spellList[k] = {
			spellName = v.name,
			icon = v.icon,
		};
	end
	NRC:sreAddRaidCooldownsToSpellList();
	if (NRC.config.sreShowDpsPotions) then
		for k, v in pairs(NRC.dpsPotions) do
			dpsPotions[k] = {
				spellName = v.name,
				icon = v.icon,
			};
			spellList[k] = {
				spellName = v.name,
				icon = v.icon,
			};
		end
	end
	if (NRC.config.sreShowManaPotions) then
		for k, v in pairs(NRC.manaPotions) do
			manaPotions[k] = {
				spellName = v.name,
				icon = v.icon,
			};
			spellList[k] = {
				spellName = v.name,
				icon = v.icon,
			};
		end
	end
	if (NRC.config.sreShowHealthPotions) then
		for k, v in pairs(NRC.healthstones) do
			healingPotions[k] = {
				spellName = v.spellName,
				icon = v.icon,
			};
			spellList[k] = {
				spellName = v.spellName,
				icon = v.icon,
			};
		end
		for k, v in pairs(NRC.healingPotions) do
			healingPotions[k] = {
				spellName = v.name,
				icon = v.icon,
			};
			spellList[k] = {
				spellName = v.name,
				icon = v.icon,
			};
		end
	end
	--NRC:debug(spellList);
end

function NRC:sreIsSpellTracked(spellID)
	if (spellList[spellID]) then
		return true;
	end
end

function NRC:sreAddRaidCooldownsToSpellList()
	if (NRC.config.sreAddRaidCooldownsToSpellList) then
		--[[for k, v in pairs(NRC.cooldownList) do
			--We handle rebirth in the resurrections table.
			if (v.spellName ~= "Rebirth") then
				for spellID, spellName in pairs(v.spellIDs) do
					spellList[spellID] = {
						spellName = spellName,
						icon = v.icon,
					};
				end
			end
		end]]
		for k, v in pairs(NRC.cooldowns) do
			if (NRC.config["raidCooldown" .. string.gsub(k, " ", "")]) then
				local spellName = k;
				local icon = v.icon;
				if (v.spellIDs and next(v.spellIDs)) then
					for id, spellName in pairs(v.spellIDs) do
						spellList[id] = {
							spellName = spellName,
							icon = icon,
						};
					end
				end
			end
		end
	end
end

function NRC:updateSreState()
	if (NRC.config.sreGroupMembersOnly) then
		groupMembersOnly = true;
	else
		groupMembersOnly = false;
	end
	if (NRC.config.sreShowSelf) then
		showSelf = true;
	else
		showSelf = false;
	end
	local enabled;
	if (not NRC.config.sreEnabled) then
		if (scrollingRaidEventsFrame) then
			scrollingRaidEventsFrame:Hide();
		end
		doSRE = false;
		return;
	end
	local instance, instanceType = IsInInstance();
	if (NRC.config.sreEnabledEverywhere) then
		--Pvp config overrides this.
		if (not NRC:isPvp()) then
			enabled = true;
		end
	end
	if (NRC.config.sreEnabledRaid and instance and (instanceType == "party" or instanceType == "raid")
			and not NRC:isPvp()) then
		enabled = true;
	end
	if (NRC.config.sreEnabledPvp and NRC:isPvp()) then
		enabled = true;
	end
	if (testRunning or scrollingRaidEventsFrame.firstRun) then
		enabled = true;
	end
	if (enabled) then
		--Remember to show this for running tests/dragging later.
		if (scrollingRaidEventsFrame) then
			scrollingRaidEventsFrame:Show();
		end
		doSRE = true;
	else
		if (scrollingRaidEventsFrame) then
			scrollingRaidEventsFrame:Hide();
		end
		doSRE = false;
	end
	NRC:sreLoadSpellList();
end

function NRC:sreUpdateSettings()
	if (scrollingRaidEventsFrame) then
		scrollingRaidEventsFrame.updateAnimationSettings(NRC.config.sreGrowthDirection, NRC.config.sreAnimationSpeed, NRC.config.sreAlignment);
		lineFrameHeight = NRC.config.sreLineFrameHeight;
		scrollingRaidEventsFrame.lineFrameHeight = NRC.config.sreLineFrameHeight;
		scrollingRaidEventsFrame.lineFrameFont = NRC.db.global.sreFont;
		scrollingRaidEventsFrame.lineFrameScale = NRC.config.sreLineFrameScale;
		scrollingRaidEventsFrame.lineFrameFontOutline = NRC.db.global.sreFontOutline;
		scrollingRaidEventsFrame:SetHeight(NRC.config.sreScrollHeight);
		scrollingRaidEventsFrame:SetHeight(NRC.config.sreScrollHeight);
		--lineFrameHeight = scrollingRaidEventsFrame.lineFrameHeight;
		scrollingRaidEventsFrame.updateAnimationSettings();
		NRC:sreLoadSpellList();
	end
end

local sentEventCache = {};
function NRC:sreSendEvent(text, icon, name, isNpc, isInterrupt)
	if (doSRE or testRunning) then
		local send;
		local instance, instanceType = IsInInstance();
		if (isInterrupt) then
			--If interrupt or dispel then send no matter the source.
			send = true;
		elseif (isNpc) then
			if (NRC.config.sreNpcsRaidOnly) then
				if (instance and (instanceType == "party" or instanceType == "raid")) then
					send = true;
				end
			elseif (NRC.config.sreNpcs) then
				send = true;
			end
		elseif (NRC.config.sreShowSelf and name == UnitName("player")) then
			if (NRC.config.sreShowSelfRaidOnly) then
				if (instance and (instanceType == "party" or instanceType == "raid")) then
					send = true;
				end
			else
				if (name == UnitName("player")) then
					send = true;
				end
			end
		elseif (name) then
			if (NRC.config.sreAllPlayers) then
				send = true;
			elseif (NRC.config.sreGroupMembers and NRC:inOurGroup(name)) then
				send = true;
			end
			if (not NRC.config.showSelf and UnitName("player") == name) then
				return;
			end
		elseif (not name and not isNpc and not isInterrupt) then
			--If no name or npc or interrupt then just send.
			send = true;
		end
		if (testRunning) then
			send = true;
		end
		if (scrollingRaidEventsFrame and send) then
			--Events almost always include a player name so this text msg should be unique enough to be used as a cooldown check for duplicate events.
			if (not sentEventCache[text] or sentEventCache[text] < GetTime() - 0.5) then
				sentEventCache[text] = GetTime();
				scrollingRaidEventsFrame.addLine("|cFF9CD6DE" .. text, icon);
			end
		end
	end
end

function NRC:sreSpellSuccessEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc)
	local name;
	if (isSourceNpc) then
		name = "|cFFFFAE42" .. sourceName .. "|r";
	else
		local _, _, _, classHex = GetClassColor(sourceClass);
		name = "|c" .. classHex .. sourceName .. "|r";
	end
	local iconText = "";
	if (icon) then
		iconText = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
	end
	local text = iconText .. name;
	if (destName) then
		if (isDestNpc) then
			destName = "|cFFFFAE42" .. destName .. "|r";
		else
			local _, _, _, classHex = GetClassColor(destClass);
			destName = "|c" .. classHex .. destName .. "|r";
		end
		text = text .. " -> " .. destName;
	end
	if (NRC.config.sreShowSpellName) then
		text = text .. " (" .. spellName .. ")";
	end
	NRC:sreSendEvent(text, nil, sourceName, isSourceNpc);
end

function NRC:srePortalEvent(spellID, spellName, icon, sourceName, sourceClass)
	local _, _, _, classHex = GetClassColor(sourceClass);
	local name = "|c" .. classHex .. sourceName .. "|r";
	local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t" .. name;
	local spellName = GetSpellInfo(spellID);
	if (spellName) then
		text = text .. " -> |cFF9CD6DE" .. spellName .. "|r";
	else
		text = text .. " -> |cFF9CD6DE" .. magePortals[spellID].spellName .. "|r";
	end
	NRC:sreSendEvent(text, nil, sourceName);
end

function NRC:sreCooldownResetEvent(spellID, spellName, icon, sourceName, sourceClass)
	local _, _, _, classHex = GetClassColor(sourceClass);
	local name = "|c" .. classHex .. sourceName .. "|r";
	local text = name .. " " .. spellName .. " |cFF9CD6DE" .. L["Ready"] .. "!|r";
	NRC:sreSendEvent(text, icon, sourceName);
end

function NRC:sreOnlineStatusEvent(sourceName, sourceClass, isOnline)
	if (NRC:isPvp() or NRC.isRetail) then
		return;
	end
	local _, _, _, classHex = GetClassColor(sourceClass);
	local name = "|c" .. classHex .. sourceName .. "|r";
	if (GetServerTime() - NRC.logonTime > 10) then
		if (isOnline) then
			NRC:sreSendEvent(name .. " |cFF00C800" .. L["came online"]  .. ".", nil, sourceName);
		else
			NRC:sreSendEvent(name .. " |cFFFF0000" .. L["went offline"]  .. ".", nil, sourceName);
		end
	end
end

function NRC:srePotionEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc)
	local name;
	if (isSourceNpc) then
		name = "|cFFFFAE42" .. sourceName .. "|r";
	else
		local _, _, _, classHex = GetClassColor(sourceClass);
		name = "|c" .. classHex .. sourceName .. "|r";
	end
	if (spellList[spellID] and spellList[spellID].icon) then
		icon = spellList[spellID].icon;
	end
	local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t" .. name;
	if (isEnglish and spellList[spellID] and spellList[spellID].spellName) then
		text = text .. " " .. spellList[spellID].spellName;
	else
		text = text .. " " .. spellName;
	end
	NRC:sreSendEvent(text, nil, sourceName, isSourceNpc);
end

function NRC:sreResurrectionEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass)
	if (spellList[spellID] and resSpellsCache[spellID] and resSpellsCache[spellID].name == "Rebirth") then
		--Remove duplicate msgs if rebirth from raid cooldowns is already tracked.
		--This will cause it to fire only on spell finished casting not start like other res spells, which is fine.
		return;
	end 
	local _, _, _, classHex = GetClassColor(sourceClass);
	local name = "|c" .. classHex .. sourceName .. "|r";
	local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t" .. name;
	if (destName) then
		local _, _, _, classHex = GetClassColor(destClass);
		destName = "|c" .. classHex .. destName .. "|r";
		text = text .. " -> " .. destName;
	end
	if (NRC.config.sreShowSpellName) then
		text = text .. " (" .. spellName .. ")";
	end
	NRC:sreSendEvent(text, nil, sourceName);
end

function NRC:sreInterruptEvent(spellID, spellName, destSpellName, icon, destIcon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc)
	local name;
	if (isSourceNpc) then
		name = "|cFFFFAE42" .. sourceName .. "|r";
	else
		local _, _, _, classHex = GetClassColor(sourceClass);
		name = "|c" .. classHex .. sourceName .. "|r";
	end
	if (destName) then
		if (isDestNpc) then
			destName = "|cFFFFAE42" .. destName .. "|r";
		else
			local _, _, _, classHex = GetClassColor(destClass);
			destName = "|c" .. classHex .. destName .. "|r";
		end
	end
	local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
	if (destIcon) then
		local targetIconString = "|T" .. destIcon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
		text = text .. name .. " Interrupt-> " .. targetIconString .. " ".. destName;
	else
		text = text .. name .. " Interrupt-> " .. destName;
	end
	--if (NRC.config.sreShowSpellName) then
	--	text = text .. " (" .. L["Interrupt"] .. ")";
	--end
	NRC:sreSendEvent(text, nil, name, nil, true);
end

function NRC:sreDispelEvent(spellID, spellName, destSpellName, icon, destIcon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc)
	local name;
	if (isSourceNpc) then
		name = "|cFFFFAE42" .. sourceName .. "|r";
	else
		local _, _, _, classHex = GetClassColor(sourceClass);
		name = "|c" .. classHex .. sourceName .. "|r";
	end
	if (destName) then
		if (isDestNpc) then
			destName = "|cFFFFAE42" .. destName .. "|r";
		else
			local _, _, _, classHex = GetClassColor(destClass);
			destName = "|c" .. classHex .. destName .. "|r";
		end
	end
	local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
	if (destIcon) then
		local targetIconString = "|T" .. destIcon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
		text = text .. name .. " Dispel-> " .. targetIconString .. " ".. destName;
	else
		text = text .. name .. " Dispel-> " .. destName;
	end
	--if (NRC.config.sreShowSpellName) then
	--	text = text .. " (" .. L["Interrupt"] .. ")";
	--end
	NRC:sreSendEvent(text, nil, name, nil, true);
end

function NRC:sreDeathEvent(destName, destClass)
	local _, _, _, classHex = GetClassColor(destClass);
	local name = "|c" .. classHex .. destName .. "|r";
	local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8";
	local text = name .. " " .. L["has died"] .. ".";
	NRC:sreSendEvent(text, icon, destName);
end

function NRC:sreMisdirectionEvent(sourceName, destName, destClass, total)
	local lineFrameHeight = NRC:sreGetLineFrameHeigt();
	local icon = "|T132180:" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
	local target = destName;
	if (destClass) then
		local _, _, _, classHex = GetClassColor(destClass);
		target = "|c" .. classHex .. target .. "|r";
	end
	local text = "|cFFFFAE42" .. L["Threat"] ..  " " .. NRC:commaValue(total) .. ":|r " .. icon .. " |cFFAAD372" .. sourceName .. "|r -> " .. target;
	NRC:sreSendEvent(text, nil, sourceName);
end

function NRC:sreTricksEvent(sourceName, destName, destClass, total)
	local lineFrameHeight = NRC:sreGetLineFrameHeigt();
	local icon = "|T236283:" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t";
	local target = destName;
	if (destClass) then
		local _, _, _, classHex = GetClassColor(destClass);
		target = "|c" .. classHex .. target .. "|r";
	end
	local text = "|cFFFFAE42" .. L["Threat"] ..  " " .. NRC:commaValue(total) .. ":|r " .. icon .. " |cFFAAD372" .. sourceName .. "|r -> " .. target;
	NRC:sreSendEvent(text, nil, sourceName);
end

--Get texture size if sending event from another module.
function NRC:sreGetLineFrameHeigt()
	if (scrollingRaidEventsFrame) then
		return scrollingRaidEventsFrame.lineFrameHeight;
	end
	return 0;
end

local function getCastInfoFromGUID(guid)
	local unit = NRC:getUnitFromGUID(guid);
	if (unit) then
		local spellName, _, _, startTime, endTime, _, _, _, spellID = UnitCastingInfo(unit);
		return spellName, spellID, startTime, endTime;
	end
end

local resCastCache = {};
local function incomingResChanged(unit)
	for k, v in ipairs(resCastCache) do
		--Check if we have a rest cast within the last second.
		--Not sure how this is going to handle 2 res's cast at the same time yet.
		--I think it will be ok if the order of events on Blizzards end works in the right order.
		--We register INCOMING_RESURRECT_CHANGED on a res cast and then wait for the event and Unregister it each time.
		if (v.time > GetTime() - 1) then
			local hasRes = UnitHasIncomingResurrection(unit);
			if (hasRes) then
				if (NRC.config.sreShowResurrections) then
					local _, class  = GetPlayerInfoByGUID(v.sourceGUID);
					local icon = resSpellsCache[v.spellID].icon;
					local destName = UnitName(unit);
					local destClass;
					if (destName) then
						_, destClass  = UnitClass(unit);
					end
					if (v.sourceName) then
						NRC:sreResurrectionEvent(v.spellID, v.spellName, icon, v.sourceName, class, destName, destClass);
						if (NRC.isResurrecting[v.sourceName] and NRC.isResurrecting[v.sourceName].timeout) then
							NRC.isResurrecting[v.sourceName].timeout:Cancel();
						end
						NRC.isResurrecting[v.sourceName] = {
							spellID = v.spellID,
							spellName = v.spellName,
							icon = icon,
							sourceName = v.sourceName,
							class = class,
							destName = destName,
							destClass = destClass,
							startTime = GetTime(),
							--Incase we go out of range while it's being cast or any other reasons the cast ending isn't seen,
							timeout = C_Timer.NewTicker(12, function()
								NRC.isResurrecting[v.sourceName] = nil;
							end, 1)
						};
						local _, spellID, startTime, endTime = getCastInfoFromGUID(v.sourceGUID);
						if (spellID == v.spellID) then
							NRC.isResurrecting[v.sourceName].castStartTime = startTime;
							NRC.isResurrecting[v.sourceName].castEndTime = endTime;
						end
						if (_G["NRCRaidManaFrame"]) then
							NRC:updateManaFrame();
						end
					end
				end
				break;
			end
		end
	end
	resCastCache = {};
	sreEventsFrame:RegisterEvent("INCOMING_RESURRECT_CHANGED");
end

local function combatLogEventUnfiltered(...)
	if (doSRE) then
		local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
				destName, destFlags, destRaidFlags, spellID, spellName = ...;
		if (subEvent == "SPELL_CAST_START") then
			if (resSpellsCache[spellID]) then
				--Target isn't included with cast start so we need to look for the INCOMING_RESURRECT_CHANGED event.
				local t = {
					time = GetTime(),
					sourceGUID = sourceGUID,
					sourceName = sourceName,
					spellName = spellName,
					spellID = spellID,
				}
				tinsert(resCastCache, 1, t);
				sreEventsFrame:RegisterEvent("INCOMING_RESURRECT_CHANGED");
				--NRC:sreSendEvent(text);
			end
		elseif (subEvent == "SPELL_CAST_SUCCESS") then
			if (spellList[spellID]) then
				local _, sourceClass  = GetPlayerInfoByGUID(sourceGUID);
				local icon
				if (spellList[spellID]) then
					icon = spellList[spellID].icon;
				else
					_, _, icon = GetSpellInfo(spellID);
				end
				local isSourceNpc, isDestNpc;
				if (sourceGUID and strfind(sourceGUID, "Creature")) then
					isSourceNpc = true;
				end
				if (destGUID and strfind(destGUID, "Creature")) then
					isDestNpc = true;
				end
				local destClass;
				if (destGUID and strfind(destGUID, "Player")) then
					_, destClass = GetPlayerInfoByGUID(destGUID);
				end
				--Config for these are done when the spellList{} table is created.
				if (dpsPotions[spellID] or manaPotions[spellID] or healingPotions[spellID]) then
					NRC:srePotionEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
				else
					NRC:sreSpellSuccessEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
				end
			end
			if (resSpellsCache[spellID]) then
				if (NRC.isResurrecting[sourceName] and NRC.isResurrecting[sourceName].timeout) then
					NRC.isResurrecting[sourceName].timeout:Cancel();
				end
				NRC.isResurrecting[sourceName] = nil;
				if (_G["NRCRaidManaFrame"]) then
					NRC:updateManaFrame();
				end
			end
		--This is handled in the raid log, it's much more reliable.
		--[[elseif (subEvent == "UNIT_DIED") then
			if (destGUID and strfind(destGUID, "Player")) then
				local _, classEnglish  = GetPlayerInfoByGUID(destGUID);
				local _, _, _, classHex = GetClassColor(classEnglish);
				destName = "|c" .. classHex .. destName .. "|r";
				local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8";
				local text = "|T" .. icon .. ":" .. lineFrameHeight .. ":" .. lineFrameHeight .. "|t" .. destName .. " has died.";
				NRC:sreSendEvent(text, nil, destName);
			end]]
		elseif (subEvent == "SPELL_INTERRUPT") then --Non player guids happened during Malygos somehow? Drake guid maybe?
			if (NRC.config.itemUseShowInterrupts and sourceGUID and string.find(sourceGUID, "Player")) then
				local _, sourceClass = GetPlayerInfoByGUID(sourceGUID);
				local isSourceNpc, isDestNpc;
				if (sourceGUID and strfind(sourceGUID, "Creature")) then
					isSourceNpc = true;
				end
				if (destGUID and strfind(destGUID, "Creature")) then
					isDestNpc = true;
				end
				local destClass;
				if (destGUID and strfind(destGUID, "Player")) then
					_, destClass = GetPlayerInfoByGUID(destGUID);
				end
				local destSpellID, destSpellName = select(15, ...);
				local _, _, icon = GetSpellInfo(spellID);
				local _, _, destIcon = GetSpellInfo(destSpellID);
				NRC:sreInterruptEvent(spellID, spellName, destSpellName, icon, destIcon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
			end
		elseif (subEvent == "SPELL_CAST_FAILED") then
			if (resSpellsCache[spellID]) then
				if (NRC.isResurrecting[sourceName] and NRC.isResurrecting[sourceName].timeout) then
					NRC.isResurrecting[sourceName].timeout:Cancel();
				end
				NRC.isResurrecting[sourceName] = nil;
				if (_G["NRCRaidManaFrame"]) then
					NRC:updateManaFrame();
				end
			end
		end
	end
end

local function unitSpellcastSucceeded(...)
	local unit, castGUID, spellID = ...;
	if (magePortals[spellID]) then
		if (NRC.config.sreShowMagePortals) then
			local sourceName = UnitName(unit);
			local _, sourceClass  = UnitClass(unit);
			local icon = magePortals[spellID].icon
			local spellName = GetSpellInfo(spellID);
			NRC:srePortalEvent(spellID, spellName, icon, sourceName, sourceClass);
		end
	end
end

local function unitSpellcastInterrupted(...)
	local unit, castGUID, spellID = ...;
	if (resSpellsCache[spellID]) then
		local sourceName = UnitName(unit);
		if (NRC.isResurrecting[sourceName] and NRC.isResurrecting[sourceName].timeout) then
			NRC.isResurrecting[sourceName].timeout:Cancel();
		end
		NRC.isResurrecting[sourceName] = nil;
		if (_G["NRCRaidManaFrame"]) then
			NRC:updateManaFrame();
		end
	end
end

sreEventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
sreEventsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
sreEventsFrame:RegisterEvent("GROUP_FORMED");
sreEventsFrame:RegisterEvent("GROUP_JOINED");
sreEventsFrame:RegisterEvent("GROUP_LEFT");
sreEventsFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
sreEventsFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
sreEventsFrame:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(CombatLogGetCurrentEventInfo());
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		unitSpellcastSucceeded(...);
	elseif (event == "UNIT_SPELLCAST_INTERRUPTED") then
		unitSpellcastInterrupted(...);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		sentEventCache = {};
		C_Timer.After(1, function()
			NRC:updateSreState();
		end)
		NRC.isResurrecting = {};
	elseif (event == "INCOMING_RESURRECT_CHANGED") then
		local unit = ...;
		incomingResChanged(unit);
	elseif (event == "GROUP_FORMED" or event == "GROUP_JOINED") then
		if (GetNumGroupMembers() > 1) then
			NRC:updateSreState();
		end
	elseif (event == "GROUP_LEFT") then
		NRC:updateSreState();
	end
end)

local testTicker;
local function testSre(testID)
	local events = {
		[2] = {
			spellID = 29166,
			spellName = "Innervate",
			icon = 136048,
			sourceName = "Player1",
			sourceClass = "DRUID",
			destName = "Player2",
			destClass = "MAGE",
			type = "spell",
		},
		[5] = {
			spellID = 20608,
			spellName ="Reincarnation",
			icon = 133439,
			sourceName = "Player3",
			sourceClass = "SHAMAN",
			type = "cooldown",
		},
		[7] = {
			spellID = 38768,
			spellName = "Kick",
			icon = 132219,
			sourceName = "Player4",
			sourceClass = "ROGUE",
			destName = "Creature1",
			destClass = "",
			isDestNpc = true,
			type = "interrupt",
		},
		[10] = {
			sourceName = "Player4",
			sourceClass = "PALADIN",
			isOnline = true,
			type = "online",
		},
		[14] = {
			spellID = 28508,
			spellName = "Destruction Potion",
			icon = 134729,
			sourceName = "Player5",
			sourceClass = "WARLOCK",
			type = "potion",
		},
		[17] = {
			sourceName = "Player6",
			destName = "Player7",
			destClass = "WARRIOR",
			total = 3725,
			type = "misdirection",
		},
		[19] = {
			destName = "Player7",
			destClass = "MAGE",
			type = "death",
		},
		[21] = {
			spellID = 25435,
			spellName = "Resurrection",
			icon = 135955,
			sourceName = "Player8",
			sourceClass = "PRIEST",
			destName = "Player7",
			destClass = "MAGE",
			type = "resurrection",
		},
	};
	if (NRC.faction == "Horde") then
		events[23] = {
			spellID = 2825,
			spellName = "Bloodlust",
			icon = 136012,
			sourceName = "Player10",
			sourceClass = "SHAMAN",
			type = "spell",
		};
		events[26] = {
			spellID = 35717,
			spellName = "Portal: Shattrath",
			icon = 135745,
			sourceName = "Player11",
			sourceClass = "MAGE",
			type = "portal",
		};
	else
		events[23] = {
			spellID = 32182,
			spellName = "Heroism",
			icon = 132313,
			sourceName = "Player10",
			sourceClass = "SHAMAN",
			type = "spell",
		};
		events[26] = {
			spellID = 33691,
			spellName = "Portal: Shattrath",
			icon = 135745,
			sourceName = "Player11",
			sourceClass = "MAGE",
			type = "portal",
		};
	end
	local data = events[testID];
	if (data) then
		local spellID = data.spellID;
		local spellName = data.spellName;
		local destSpellName = data.destSpellName;
		local icon = data.icon;
		local destIcon = data.destIcon;
		local sourceName = data.sourceName;
		local sourceClass = data.sourceClass;
		local destName = data.destName;
		local destClass = data.destClass;
		local isSourceNpc = data.isSourceNpc;
		local isDestNpc = data.isDestNpc;
		local isOnline = data.isOnline;
		local total = data.total;
		local type = data.type;
		if (type == "spell") then
			NRC:sreSpellSuccessEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
		elseif (type == "cooldown") then
			NRC:sreCooldownResetEvent(spellID, spellName, icon, sourceName, sourceClass);
		elseif (type == "online") then
			NRC:sreOnlineStatusEvent(sourceName, sourceClass, isOnline);
		elseif (type == "potion") then
			NRC:srePotionEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
		elseif (type == "resurrection") then
			NRC:sreResurrectionEvent(spellID, spellName, icon, sourceName, sourceClass, destName, destClass);
		elseif (type == "interrupt") then
			NRC:sreInterruptEvent(spellID, spellName, destSpellName, icon, destIcon, sourceName, sourceClass, destName, destClass, isSourceNpc, isDestNpc);
		elseif (type == "death") then
			NRC:sreDeathEvent(destName, destClass);
		elseif (type == "misdirection") then
			NRC:sreMisdirectionEvent(sourceName, destName, destClass, total);
		elseif (type == "portal") then
			NRC:srePortalEvent(spellID, spellName, icon, sourceName, sourceClass);
		end
	end
end

local testID = 0;
function NRC:startSreTicker()
	if (testTicker) then
		return;
	end
	testID = 0;
	testTicker = true;
	NRC:sreTicker();
end

function NRC:stopSreTicker()
	testTicker = nil;
end

function NRC:sreTicker()
	if (testTicker) then
		testID = testID + 1;
		testSre(testID);
		C_Timer.After(1, function()
			NRC:sreTicker();
		end)
	end
end

function NRC:startSreTest(quiet)
	if (not NRC.config.sreEnabled) then
		NRC:print("Scrolling Raid Events are not enabled.");
		return;
	end
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	testRunningTimer = C_Timer.NewTicker(30, function()
		NRC:stopSreTest();
	end, 1)
	if (not quiet) then
		NRC:print("|cFF00C800Started Scrolling Raid Events test for 30 seconds.");
	end
	testRunning = true;
	NRC:sreUnlockFrames();
	NRC:startSreTicker();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:stopSreTest()
	if (testRunningTimer) then
		testRunningTimer:Cancel();
	end
	if (not NRC.allFramesTestRunning) then
		NRC:print("|cFF00C800Stopped Scrolling Raid Events test.");
	end
	testRunning = nil;
	NRC:stopSreTicker();
	NRC:sreUpdateFrameLocks();
	NRC.acr:NotifyChange("NovaRaidCompanion");
end

function NRC:getSreTestState()
	return testRunning;
end

function NRC:sreUpdateFrameLocks()
	if (scrollingRaidEventsFrame) then
		scrollingRaidEventsFrame.locked = NRC.config.lockAllFrames;
	end
	NRC:sreUpdateFrameLocksLayout();
end
	
function NRC:sreUpdateFrameLocksLayout()
	NRC:updateSreState();
	if (scrollingRaidEventsFrame) then
		local frame = scrollingRaidEventsFrame;
		if (frame) then
			--if (frame.locked and not frame.firstRun) then
			if (frame.locked) then
				frame.displayTab:Hide();
				frame.displayTab.top:Hide();
				frame:EnableMouse(false);
			else
				frame.displayTab.top:ClearAllPoints();
				frame.displayTab.top:SetPoint("BOTTOM", frame, "TOP", 0, -1.5);
				frame.displayTab.top:SetBackdrop({
					bgFile = "Interface\\Buttons\\WHITE8x8",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
					tileEdge = true,
					edgeSize = 8,
					insets = {top = 3, left = 3, bottom = 3, right = 3},
				});
				frame.displayTab.top:SetBackdropColor(0, 0, 0, 0.8);
				frame.displayTab:SetAlpha(0.3);
				frame.displayTab.top.fs:SetText("|cFFDEDE42NRC Scrolling Events|r");
				frame.displayTab.top.fs2:SetText("|cFF9CD6DE" .. L["Drag Me"] .. "|r");
				frame.displayTab.top:SetSize(120, 30);
				--raidCooldowns:EnableMouse(true);
				frame.displayTab:Show();
				frame.displayTab.top:Show();
				frame:EnableMouse(true);
			end
		end
	end
	--NRC.acr:NotifyChange("NovaRaidCompanion");
end

--[[function NRC:sreUpdateFrameLocks()
	if (scrollingRaidEventsFrame) then
		if (scrollingRaidEventsFrame.locked) then
			scrollingRaidEventsFrame:SetBackdropColor(0, 0, 0, 0);
			scrollingRaidEventsFrame:EnableMouse(false);
		else
			scrollingRaidEventsFrame:SetBackdropColor(0, 0, 0, 0.5);
			scrollingRaidEventsFrame:EnableMouse(true);
		end
	end
	--NRC.acr:NotifyChange("NovaRaidCompanion");
end]]

function NRC:sreLockFrames()
	scrollingRaidEventsFrame.locked = true;
	NRC:sreUpdateFrameLocksLayout();
end

function NRC:sreUnlockFrames()
	scrollingRaidEventsFrame.locked = nil;
	NRC:sreUpdateFrameLocksLayout();
end

function NRC:sreGetLockState()
	if (scrollingRaidEventsFrame) then
		return scrollingRaidEventsFrame.locked;
	end
end