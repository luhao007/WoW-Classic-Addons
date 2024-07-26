--------------------
--Nova World Buffs--
--Novaspark-Arugal OCE (classic).
--https://www.curseforge.com/members/venomisto/projects
--Note: Server restarts will cause the timers to be inaccurate because the NPC's reset.

local addonName, addon = ...;
local NWB = addon.a;
local _, _, _, tocVersion = GetBuildInfo();
NWB.LSM = LibStub("LibSharedMedia-3.0");
NWB.dragonLib = LibStub("HereBeDragons-2.0");
NWB.dragonLibPins = LibStub("HereBeDragons-Pins-2.0");
NWB.candyBar = LibStub("LibCandyBar-3.0");
NWB.LibRealmInfo = LibStub("LibRealmInfo");
NWB.commPrefix = "NWB";
NWB.hasAddon = {};
NWB.hasL = {};
NWB.realm = GetRealmName();
NWB.realmNormalized = GetNormalizedRealmName();
NWB.faction = UnitFactionGroup("player");
NWB.maxLevel = GetMaxPlayerLevel();
NWB.maxBuffLevel = 63;
NWB.loadTime = 0;
NWB.limitLayerCount = 10; --Do not change this, it does not work unless all addon users have the same number.
NWB.sharedLayerBuffs = true;
NWB.doLayerMsg = false;
NWB.noGUID = false;
NWB.serializer = LibStub:GetLibrary("LibSerialize");
NWB.serializerOld = LibStub:GetLibrary("AceSerializer-3.0");
NWB.libDeflate = LibStub:GetLibrary("LibDeflate");
NWB.acr = LibStub:GetLibrary("AceConfigRegistry-3.0");
NWB.npcs = {};
NWB.map = 0;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
NWB.LDBIcon = LibStub("LibDBIcon-1.0");
local version = GetAddOnMetadata("NovaWorldBuffs", "Version") or 9999;
NWB.version = tonumber(version);
NWB.latestRemoteVersion = version;
NWB.prefixColor = "|cFFFF6900";
local terokOffset = 2.7507;
local GetGossipOptions = GetGossipOptions or C_GossipInfo.GetOptions;
NWB.wgExpire = 259200;
local yellPercent = NWB.yellPercent;
local noWorldBuffTimers = NWB.noWorldBuffTimers;
function NWB:loadSODPhases()
	--Has to be done after PEW.
	if (NWB.isClassic and C_Engraving and C_Engraving.IsEngravingEnabled()) then
		local sodPhases = {[25]=1,[40]=2,[50]=3,[60]=4};
		NWB.sodPhase = sodPhases[(GetEffectivePlayerMaxLevel())];
	end
end
--Some notes on the change Blizzard just implemented to make layers share buffs.
--The buff drop only works on both layers if each layer NPC is reset.
--If a NPC dies on one layer and drop a buff it breaks thr sync for the rest of the week or until no buffs are dropped for a long time on both.
--We're still tracking drops for both layers incase a NPC is killed.

function NWB:OnInitialize()
	self:setRealmData();
	self:setLayered();
	self:setLayeredSongflowers();
	self:setLayerLimit();
	self:loadSpecificOptions();
    self.db = LibStub("AceDB-3.0"):New("NWBdatabase", NWB.optionDefaults, "Default");
    LibStub("AceConfig-3.0"):RegisterOptionsTable("NovaWorldBuffs", NWB.options);
	self.NWBOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NovaWorldBuffs", "NovaWorldBuffs");
	self.chatColor = "|cff" .. self:RGBToHex(self.db.global.chatColorR, self.db.global.chatColorG, self.db.global.chatColorB);
	self.prefixColor = "|cff" .. self:RGBToHex(self.db.global.prefixColorR, self.db.global.prefixColorG, self.db.global.prefixColorB);
	self.mmColor = "|cff" .. self:RGBToHex(self.db.global.mmColorR, self.db.global.mmColorG, self.db.global.mmColorB);
	self:RegisterComm(self.commPrefix);
	self:registerSounds();
	self.loadTime = GetServerTime();
	self.db.global.lt = GetServerTime();
	self:setDmfDates();
	self:registerOtherAddons();
	self:buildRealmFactionData();
	self:setRegionFont();
	self:fixAllLayers();
	self:checkLayers();
	self:cleanupSettingsData();
	self:setSongFlowers();
	self:createSongflowerMarkers();
	self:createTuberMarkers();
	self:createDragonMarkers();
	self:refreshFelwoodMarkers();
	self:createWorldbuffMarkersTable();
	self:createWorldbuffMarkers();
	self:createShatDailyMarkers();
	self:getDmfData();
	self:createDmfMarkers();
	self:loadAshenvale();
	self:loadStranglethorn();
	self:loadBlackrock();
	self:loadOverlay();
	self:doResetTimerData();
	self:resetSongFlowers();
	self:resetLayerData();
	self:resetLayerMaps();
	self:wipeTerokkarData();
	self:removeOldLayers();
	--Before we start the ticker we need a temp record of our last online time to check dmf reset.
	self.lastOnlineCache = NWB.data.myChars[UnitName("player")].lo;
	--self:loadTbCache();
	self:ticker();
	self:yellTicker();
	self:createBroker();
	self:convertSettings();
	self:setLoggingState();
	self:trimTimerLog();
	self:createLayerFrameTimerLogButton();
	self:setLayerFrameText();
	self:logonCheckGuildMasterSetting();
	self:createNaxxMarkers();
	if (NWB.createExtraDungMarkers) then
		NWB:createExtraDungMarkers();
	end
	self:timerCleanup();
	self:resetOldLockouts();
	if (NWB.isTBC or NWB.isWrath) then
		self:createTerokkarMarkers();
		self:populateDailyData();
	end
	self:checkNewVersion();
	--Rereshing frames to load fonts need to be done at entering world instead, to make sure all addons and shared fonts are loaded.
	--self:refreshMinimapLayerFrame();
	--self:refreshOverlay();
end

function NWB:GetCurrentRegion()
	local data = C_BattleNet.GetGameAccountInfoByGUID(UnitGUID("player"));
	if (data) then
		local region = data.regionID;
		if (region) then
			return region;
		end
	end
	return GetCurrentRegion();
end

--Set font used in fontstrings on frames.
NWB.regionFont = "Fonts\\ARIALN.ttf";
function NWB:setRegionFont()
	if (LOCALE_koKR) then
     	NWB.regionFont = "Fonts\\2002.TTF";
    elseif (LOCALE_zhCN) then
     	NWB.regionFont = "Fonts\\ARKai_T.ttf";
    elseif (LOCALE_zhTW) then
     	NWB.regionFont = "Fonts\\blei00d.TTF";
    elseif (LOCALE_ruRU) then
    	--ARIALN seems to work in RU.
     	--NWB.regionFont = "Fonts\\FRIZQT___CYR.TTF";
    end
end
NWB:setRegionFont();
NWB.LSM:Register("font", "NWB Default", NWB.regionFont);

--Only works for SoD realms since all set to same timezone.
--Could easily be adjusted for all realms later with a list of server timezone offsets.
--But for now we only need to adjust SoD timers with this, this is only called in SoD related funcs.
function NWB:isDST()
	local region = NWB:GetCurrentRegion();
	local standardOffset;
	if (region == 1 and string.match(NWB.realm, "(AU)")) then
		--OCE UTC +10 (AEST).
		standardOffset = 10;
	elseif (region == 1) then
		--US UTC -7 (MST).
		standardOffset = -7;
	elseif (region == 2) then
		--Korea no DST.
	elseif (region == 3) then
		--EU UTC +1 (CET).
		standardOffset = 1;
	elseif (region == 4) then
		--Taiwan no DST.
	elseif (region == 5) then
		--China no DST.
	end
	if (standardOffset) then
		local diff = (C_DateAndTime.GetServerTimeLocal() - GetServerTime()) / 3600;
		local offset = math.floor(diff + 0.5);
		--print("Standard offset:", standardOffset, "Current offset:", offset);
		if (offset ~= standardOffset) then
			return offset;
		end
	end
end

function NWB_isDST()
	--For easy user debugging reasons.
	return NWB:isDST();
end

function NWB:GetPlayerZonePosition()
	local x, y, zone = NWB.dragonLib:GetPlayerZonePosition();
	--Merge both tol barad zone maps for lookup purposes, they are the same zone with the same zoneID.
	if (zone == 244) then
		zone = 245;
	end
	return x, y, zone;
end

--Print current buff timers to chat window.
local npcRespawnTime = 360;
function NWB:printBuffTimers(isLogon)
	if (isLogon and not NWB.isClassic and (NWB.db.global.disableLogonAllLevels
		or (UnitLevel("player") > NWB.maxBuffLevel and NWB.db.global.disableLogonAboveMaxBuffLevel))) then
		return;
	end
	local msg;
	if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
		if (NWB.data.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
			msg = L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - NWB.data.rendTimer), true) .. ".";
			if (NWB.db.global.showTimeStamp) then
				local timeStamp = NWB:getTimeFormat(NWB.data.rendTimer + NWB.rendCooldownTime);
				msg = msg .. " (" .. timeStamp .. ")";
			end
		else
			msg = L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
		end
		if ((not isLogon or NWB.db.global.logonRend) and not NWB.isLayered) then
			NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h");
		end
	end
	if ((NWB.data.onyNpcDied > NWB.data.onyTimer) and
			(NWB.data.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
		local respawnTime = npcRespawnTime - (GetServerTime() - NWB.data.onyNpcDied);
		if (NWB.faction == "Horde") then
			if (respawnTime > 0) then
				msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
						NWB:getTimeString(respawnTime, true));
			else
				msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
			end
		else
			if (respawnTime > 0) then
				msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
						NWB:getTimeString(respawnTime, true));
			else
				msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
			end
		end
	elseif (NWB.data.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
		msg = L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - NWB.data.onyTimer), true) .. ".";
		if (NWB.db.global.showTimeStamp) then
			local timeStamp = NWB:getTimeFormat(NWB.data.onyTimer + NWB.onyCooldownTime);
			msg = msg .. " (" .. timeStamp .. ")";
		end
	else
		msg = L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
	end
	if ((not isLogon or NWB.db.global.logonOny) and not NWB.isLayered) then
		NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h");
	end
	if ((NWB.data.nefNpcDied > NWB.data.nefTimer) and
			(NWB.data.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
		local respawnTime = npcRespawnTime - (GetServerTime() - NWB.data.nefNpcDied);
		if (NWB.faction == "Horde") then
			if (respawnTime > 0) then
				msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
						NWB:getTimeString(respawnTime, true));
			else
				msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
			end
		else
		if (respawnTime > 0) then
				msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
						NWB:getTimeString(respawnTime, true));
			else
				msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
			end
		end
	elseif (NWB.data.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
		msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - NWB.data.nefTimer), true) .. ".";
		if (NWB.db.global.showTimeStamp) then
			local timeStamp = NWB:getTimeFormat(NWB.data.nefTimer + NWB.nefCooldownTime);
			msg = msg .. " (" .. timeStamp .. ")";
		end
	else
		msg = L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
	end
	if ((not isLogon or NWB.db.global.logonNef) and not NWB.isLayered) then
		NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h");
	end
	if (NWB.isLayered) then
		NWB:print("|HNWBCustomLink:timers|h" .. L["layerMsg1"] .. "|h");
		NWB:print("|HNWBCustomLink:timers|h" .. L["layerMsg2"] .. "|h");
	end
	local timestamp, timeLeft, type = NWB:getDmfData();
	if ((isLogon and NWB.db.global.logonDmfSpawn and (timeLeft and timeLeft > 0 and timeLeft < 21600)) or
		(not isLogon and NWB.db.global.showDmfWb)) then	
		local zone = NWB:getDmfZoneString();
		local timeString = NWB:getDmfTimeString();
		if (timeString == "Error getting Darkmoon Faire timer.") then
			msg = timeString;
		else
			msg = timeString .. " (" .. zone .. ")";
		end
		if (NWB.isClassic) then
			NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h", nil, "[DMF]");
		end
	end
	local foundThisCharDmfReset;
	if (isLogon) then
		foundThisCharDmfReset = NWB:checkDmfBuffReset(true);
	end
	if ((NWB.isDmfUp or NWB.isAlwaysDMF) and NWB.data.myChars[UnitName("player")].buffs) then
		local dmfCooldown, noMsgs = NWB:getDmfCooldown();
		if (dmfCooldown > 0 and not noMsgs) then
			if ((not isLogon and NWB.db.global.showDmfBuffWb) or NWB.db.global.logonDmfBuffCooldown) then
				if (not foundThisCharDmfReset) then
					--Only send this cooldown left msg if dmf didn't reset while we're offline.
					msg = string.format(L["dmfBuffCooldownMsg"], NWB:getTimeString(dmfCooldown, true));
					NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h", nil, "[DMF]");
				end
			end
		end
		--[[for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (v.type == "dmf" and (v.timeLeft + 7200) > 0) then
				msg = string.format(L["dmfBuffCooldownMsg"], NWB:getTimeString(v.timeLeft + 7200, true));
				if ((not isLogon and NWB.db.global.showDmfBuffWb) or NWB.db.global.logonDmfBuffCooldown) then
					if (not v.noMsgs) then
						NWB:print("|HNWBCustomLink:timers|h" .. msg .. "|h", nil, "[DMF]");
					end
				end
				break;
			end
		end]]
	end
end

--Map layer from capitals for buff drops etc to Dal or wherever the parent layer is started from.
function NWB:mapLayerToParent(layer)
	if (NWB.data.layers[layer]) then
		return layer;
	end
	for k, v in pairs(NWB.data.layers) do
		if (v.layerMap) then
			for kk, vv in pairs(v.layerMap) do
				if (kk == layer) then
					return k;
				end
			end
		end
	end
	return;
end

function NWB:isCapitalCity(includeCrossroads)
	local _, _, zone = NWB:GetPlayerZonePosition();
	local subZone = GetSubZoneText();
	if (zone == 1453 or zone == 1454 or (includeCrossroads and zone == 1454 and subZone == POSTMASTER_LETTER_BARRENS_MYTHIC)) then
		return true;
	end
end

function NWB:isCapitalCityAction(type)
	local _, _, zone = NWB:GetPlayerZonePosition();
	local subZone = GetSubZoneText();
	if (zone == 1453 and NWB.faction == "Alliance" and (type == "ony" or type == "nef" or type == "timer")) then
		return true;
	elseif (zone == 1454 and NWB.faction == "Horde" and (type == "ony" or type == "nef" or type == "rend" or type == "timer")) then
		return true;
	elseif (zone == 1413 and subZone == POSTMASTER_LETTER_BARRENS_MYTHIC and (type == "ony" or type == "nef"
			or type == "rend" or type == "timer")) then
		return true;
	elseif ((zone == 1434 or zone == 1443 or zone == 1454 or zone == 1413) and type == "zan" or type == "timer") then
		return true;
	end
end

--Single line buff timers.
function NWB:getShortBuffTimers(channel, layerNum)
	local msg = "";
	local dataPrefix, layer;
	local count = 0;
	local doShortestPerBuff;
	if (NWB.isLayered) then
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			if (not layerNum and count == 1) then
				--If there's no layer specified then get the shortest timer for each buff separately.
				doShortestPerBuff = true;
				--Get first layer if no layer specified (as a backup).
				layer = k;
				break;
			elseif (count == tonumber(layerNum)) then
				layer = k;
			end
		end
		--if (not layerNum and NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
		--		and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
		--	layerNum = NWB.lastKnownLayer;
		--	layer = NWB.lastKnownLayerID;
		--end
		--if (channel == "guildCommand" and not layerNum) then
		--	layer, layerNum = NWB:getShortestTimerLayer("city");
		--end
		if (layerNum and not layer) then
			return "That layer wasn't found or has no valid timers.";
		end
		dataPrefix = NWB.data.layers[layer];
		if (not dataPrefix and not layerNum) then
			msg = "(" .. L["rend"] .. ": " .. L["noTimer"] .. ") ";
			msg = msg .. "(" .. L["onyxia"] .. ": " .. L["noTimer"] .. ") ";
			msg = msg .. "(" .. L["nefarian"] .. ": " .. L["noTimer"] .. ") ";
			msg = msg .. "(No layers found)";
			return msg;
		end
	else
		dataPrefix = NWB.data;
	end
	if (not dataPrefix and not doShortestPerBuff) then
		return "No timers found."
	end
	local shortLayerMsg = "";
	--[[if (doShortestPerBuff) then
		local layer, layerNum = NWB:getShortestTimerLayerBuff("rend");
		if (layer > 0) then
			dataPrefix = NWB.data.layers[layer];
			--shortLayerMsg = " [L" .. layerNum .. "]";
		end
	end]]
	if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
		if (dataPrefix.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
			msg = "(" .. L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - dataPrefix.rendTimer), true) .. shortLayerMsg .. ") ";
		else
			msg = "(" .. L["rend"] .. ": " .. L["noTimer"] .. shortLayerMsg .. ") ";
		end
	end
	shortLayerMsg = "";
	if (doShortestPerBuff) then
		local layer, layerNum = NWB:getShortestTimerLayerBuff("ony");
		if (layer > 0) then
			dataPrefix = NWB.data.layers[layer];
			shortLayerMsg = " [L" .. layerNum .. "]";
		end
	end
	if ((dataPrefix.onyNpcDied > dataPrefix.onyTimer) and
			(dataPrefix.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
		local respawnTime = npcRespawnTime - (GetServerTime() - dataPrefix.onyNpcDied);
		if (NWB.faction == "Horde") then
			if (respawnTime > 0) then
				msg = msg .. "(" .. string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - dataPrefix.onyNpcDied, true),
						NWB:getTimeString(respawnTime, true)) .. shortLayerMsg .. ") ";
			else
				msg = msg .. "(" .. string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - dataPrefix.onyNpcDied, true))
						 .. shortLayerMsg .. ") ";
			end
		else
			if (respawnTime > 0) then
				msg = msg .. "(" .. string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - dataPrefix.onyNpcDied, true),
						NWB:getTimeString(respawnTime, true)) .. shortLayerMsg .. ") ";
			else
				msg = msg .. "(" .. string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - dataPrefix.onyNpcDied, true))
						 .. shortLayerMsg .. ") ";
			end
		end
	elseif (dataPrefix.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
		msg = msg .. "(" .. L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - dataPrefix.onyTimer), true) .. shortLayerMsg .. ") ";
	else
		msg = msg .. "(" .. L["onyxia"] .. ": " .. L["noTimer"] .. shortLayerMsg .. ") ";
	end
	shortLayerMsg = "";
	if (doShortestPerBuff) then
		local layer, layerNum = NWB:getShortestTimerLayerBuff("nef");
		if (layer > 0) then
			dataPrefix = NWB.data.layers[layer];
			shortLayerMsg = " [L" .. layerNum .. "]";
		end
	end
	if ((dataPrefix.nefNpcDied > dataPrefix.nefTimer) and
			(dataPrefix.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
		local respawnTime = npcRespawnTime - (GetServerTime() - dataPrefix.nefNpcDied);
		if (NWB.faction == "Horde") then
			if (respawnTime > 0) then
				msg = msg .. "(" .. string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - dataPrefix.nefNpcDied, true),
						NWB:getTimeString(respawnTime, true)) .. shortLayerMsg .. ") ";
			else
				msg = msg .. "(" .. string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - dataPrefix.nefNpcDied, true))
						 .. shortLayerMsg .. ") ";
			end
		else
			if (respawnTime > 0) then
				msg = msg .. "(" .. string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - dataPrefix.nefNpcDied, true),
						NWB:getTimeString(respawnTime, true)) .. shortLayerMsg .. ") ";
			else
				msg = msg .. "(" .. string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - dataPrefix.nefNpcDied, true))
						 .. shortLayerMsg .. ") ";
			end
		end
	elseif (dataPrefix.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
		msg = msg .. "(" .. L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - dataPrefix.nefTimer), true) .. shortLayerMsg .. ")";
	else
		msg = msg .. "(" .. L["nefarian"] .. ": " .. L["noTimer"] .. shortLayerMsg .. ")";
	end
	if (layerNum and not doShortestPerBuff) then
		return msg .. " (" .. L["Layer"] .. " " .. layerNum .. " of " .. count .. ")";
	elseif (NWB.isLayered and not doShortestPerBuff) then
		return msg .. " (" .. L["Layer"] .. " 1 of " .. count .. ")";
	end
	return msg;
end

--Prefixes are clickable in chat to open buffs frame.
function NWB.addClickLinks(self, event, msg, author, ...)
	local types;
	if (NWB.db.global.colorizePrefixLinks) then
		types = {
			["%[WorldBuffs%]"] = NWB.prefixColor .. "|HNWBCustomLink:buffs|h[WorldBuffs]|h|r",
			["%[NovaWorldBuffs%]"] = NWB.prefixColor .. "|HNWBCustomLink:buffs|h[NovaWorldBuffs]|h|r",
			["%[DMF%]"] = NWB.prefixColor .. "|HNWBCustomLink:buffs|h[DMF]|h|r",
		}
	else
		types = {
			["%[WorldBuffs%]"] = "|HNWBCustomLink:buffs|h[WorldBuffs]|h",
			["%[NovaWorldBuffs%]"] = "|HNWBCustomLink:buffs|h[NovaWorldBuffs]|h",
			["%[DMF%]"] = "|HNWBCustomLink:buffs|h[DMF]|h",
		}
	end
	for k, v in pairs(types) do
		local match = string.match(msg, k);
		--if (NWB.isLayered) then
			if (match) then
				--If layered make the whole msg clickable to open buffs frame.
				msg = string.gsub(msg, k .. " (.+)", v .. " |HNWBCustomLink:timers|h%1|h");
				return false, msg, author, ...;
			end
		--else
			--if (match) then
			--	msg = string.gsub(msg, k, v);
			--	return false, msg, author, ...;
			--end
		--end
	end
	return false, msg, author, ...;
	--if (NWB.isLayered and channel == "guild") then
	--	msg = "|HNWBCustomLink:timers|h" .. msg .. "|h";
	--end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", NWB.addClickLinks);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", NWB.addClickLinks);
--Hook the chat link click func.
hooksecurefunc("ChatFrame_OnHyperlinkShow", function(...)
	local chatFrame, link, text, button = ...;
    if (link == "NWBCustomLink:buffs") then
		NWB:openBuffListFrame();
	end
	--if (link == "NWBCustomLink:timers" and NWB.isLayered) then
	if (link == "NWBCustomLink:timers") then
		NWB:openLayerFrame();
	end
end)

--Insert our custom link type into blizzards SetHyperlink() func.
local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(link, ...)
	if (link and link:sub(0, 13) == "NWBCustomLink") then
		return;
	end
	return OriginalSetHyperlink(self, link, ...);
end

function NWB:print(msg, channel, prefix, tbcCheck)
	--Add prefix and colors from db then print.
	local printPrefix;
	if (tbcCheck and not NWB.isClassic and (NWB.db.global.disableChatAllLevels
		or (UnitLevel("player") > NWB.maxBuffLevel and NWB.db.global.disableChatAboveMaxBuffLevel))) then
		return;
	end
	if (prefix) then
		printPrefix = NWB.prefixColor .. prefix .. "|r";
	end
	if (channel) then
		channel = string.lower(channel);
	end
	if (channel == "group" or channel == "team") then
		channel = "party";
	end
	if (channel == "gchat" or channel == "gmsg") then
		channel = "guild";
	end
	local channelWhisper, name;
	if (channel) then
		channelWhisper, name = strsplit(" ", channel, 2);
	end
	if (channelWhisper == "tell" or channelWhisper == "whisper" or channelWhisper == "msg") then
		if (not prefix) then
			printPrefix = "[NovaWorldBuffs]";
		end
		if (name and name ~= "") then
			SendChatMessage(printPrefix .. " " .. msg, "WHISPER", nil, name);
		else
			print(NWB.chatColor .. "No whisper target found.");
		end
	elseif (channel == "r" or channel == "reply") then
		if (not prefix) then
			printPrefix = "[NovaWorldBuffs]";
		end
		if (NWB.lastWhisper and NWB.lastWhisper ~= "") then
			if (NWB.lastWhisperType == "bnet") then
				BNSendWhisper(NWB.lastWhisper, printPrefix .. " " .. msg);
			else
				SendChatMessage(printPrefix .. " " .. msg, "WHISPER", nil, NWB.lastWhisper);
			end
		else
			print(NWB.chatColor .. "No last whisper target found.");
		end
	elseif (channel == "say" or channel == "yell" or channel == "party" or channel == "guild" or channel == "officer" or channel == "raid") then
		--If posting to a specifed channel then advertise addon name in prefix, more people that have the addon then more accurate the data is.
		if (not prefix) then
			printPrefix = "[NovaWorldBuffs]";
			if (channel == "guild") then
				printPrefix = "[WorldBuffs]";
			end
		end
		SendChatMessage(printPrefix .. " " .. msg, channel);
	elseif (tonumber(channel)) then
		--Send to numbered channel by number.
		local id, name = GetChannelName(channel);
		if (id == 0) then
			print(NWB.chatColor .. "No channel with id " .. NWB.prefixColor .. channel .. NWB.chatColor .. " exists.");
			print(NWB.chatColor .. "Type \"/wb\" to print world buff timers to yourself.");
			print(NWB.chatColor .. "Type \"/wb config\" to open options.");
			print(NWB.chatColor .. "Type \"/wb guild\" to post buff timers to the specified chat channel (accepts channel names and numbers).");
			print(NWB.chatColor .. "Use \"/sf\" in the same way for songflowers.");
			print(NWB.chatColor .. "Type \"/dmf\" for your Darkmoon Faire buff cooldown.");
			print(NWB.chatColor .. "Type \"/buffs\" to view all your alts world buffs.");
			return;
		end
		if (not prefix) then
			printPrefix = "[NovaWorldBuffs]";
		end
		SendChatMessage(printPrefix .. " " .. NWB:stripColors(msg), "CHANNEL", nil, id);
	elseif (channel ~= nil and channel ~= "print") then
		--Send to numbered channel by name.
		local id, name = GetChannelName(channel);
		if (id == 0) then
			print(NWB.chatColor .. "No channel with id " .. NWB.prefixColor .. channel .. NWB.chatColor .. " exists.");
			print(NWB.chatColor .. "Type \"/wb\" to print world buff timers to yourself.");
			print(NWB.chatColor .. "Type \"/wb config\" to open options.");
			print(NWB.chatColor .. "Type \"/wb guild\" to post buff timers to the specified chat channel (accepts channel names and numbers).");
			print(NWB.chatColor .. "Use \"/sf\" in the same way for songflowers.");
			print(NWB.chatColor .. "Type \"/dmf\" for your Darkmoon Faire buff cooldown.");
			print(NWB.chatColor .. "Type \"/buffs\" to view all your alts world buffs.");
			return;
		end
		if (not prefix) then
			printPrefix = "[NovaWorldBuffs]";
		end
		SendChatMessage(printPrefix .. " " .. NWB:stripColors(msg), "CHANNEL", nil, id);
	else
		if (not prefix) then
			printPrefix = NWB.prefixColor .. "|HNWBCustomLink:buffs|h[WorldBuffs]|h|r";
		end
		if (prefix == "[DMF]") then
			printPrefix = NWB.prefixColor .. "|HNWBCustomLink:buffs|h[DMF]|h|r";
		end
		if (NWB.isLayered) then
			msg = "|HNWBCustomLink:timers|h" .. msg .. "|h";
		end
		print(printPrefix .. " " .. NWB.chatColor .. msg);
	end
end

NWB.types = {
	[1] = "rend",
	[2] = "ony",
	[3] = "nef",
	--[4] = "zan"
};

--1 second looping function for timer warning msgs.
NWB.played = 0;
local lastDmfTick = 0;
local lastSecondsLeft = 0;
function NWB:ticker()
	for k, v in pairs(NWB.types) do
		local offset = 0;
		if (v == "rend") then
			offset = NWB.rendCooldownTime;
		elseif (v == "ony") then
			offset = NWB.onyCooldownTime;
		elseif (v == "nef") then
			offset = NWB.nefCooldownTime;
		--elseif (v == "zan") then
		--	offset = NWB.zanCooldownTime;
		end
		if (NWB.isLayered) then
			for layer, value in NWB:pairsByKeys(NWB.data.layers) do
				if (not noWorldBuffTimers) then
					local secondsLeft = (NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime();
					--This looks messy but when checking (secondsLeft == 0) it would sometimes skip, not sure why.
					--This gives it a 2 second window instead of 1.
					if (NWB.data.layers[layer][v .. "0"] and secondsLeft <= 0 and secondsLeft >= -1) then
						NWB.data.layers[layer][v .. "0"] = nil;
						NWB:doWarning(v, 0, secondsLeft, layer);
					elseif (NWB.data.layers[layer][v .. "1"] and secondsLeft <= 60 and secondsLeft >= 59) then
						NWB.data.layers[layer][v .. "1"] = nil;
						NWB:doWarning(v, 1, secondsLeft, layer);
						NWB:playSound("soundsOneMinute", "timer");
					elseif (NWB.data.layers[layer][v .. "5"] and secondsLeft <= 300 and secondsLeft >= 299) then
						NWB.data.layers[layer][v .. "5"] = nil;
						NWB:doWarning(v, 5, secondsLeft, layer);
					elseif (NWB.data.layers[layer][v .. "10"] and secondsLeft <= 600 and secondsLeft >= 599) then
						NWB.data.layers[layer][v .. "10"] = nil;
						NWB:doWarning(v, 10, secondsLeft, layer);
					elseif (NWB.data.layers[layer][v .. "15"] and secondsLeft <= 900 and secondsLeft >= 899) then
						NWB.data.layers[layer][v .. "15"] = nil;
						NWB:doWarning(v, 15, secondsLeft, layer);
					elseif (NWB.data.layers[layer][v .. "30"] and secondsLeft <= 1800 and secondsLeft >= 1799) then
						NWB.data.layers[layer][v .. "30"] = nil;
						NWB:doWarning(v, 30, secondsLeft, layer);
					end
				end
				if (k == 1) then
					--Stuff to run once per tick only, not sure why I put it in this loop back when it was added but whatever..
					if (NWB.isTBC) then
						if (NWB.data.layers[layer]["terokTowers10"] and NWB.data.layers[layer]["terokTowers"]
								and tonumber(NWB.data.layers[layer]["terokTowers"])) then
							--This timer drifts 3 seconds forward per minute.
							local endTime = NWB:getTerokEndTime(NWB.data.layers[layer]["terokTowers"], NWB.data.layers[layer]["terokTowersTime"]);
							--local endTime = NWB.data.layers[layer]["terokTowers"];
							local secondsLeft = endTime - GetServerTime();
							--if (secondsLeft ~= lastSecondsLeft - 1) then
								--NWB:debug("Time irregularity New:", secondsLeft, "Old:", lastSecondsLeft, "Diff:", lastSecondsLeft - secondsLeft);
							--end
							lastSecondsLeft = secondsLeft;
							--Seems to not fire on 10mins sometimes, maybe getting a timer update that skips the 600 seconds remaining mark.
							--Trying a 30 second window instead.
							if (secondsLeft <= 600 and secondsLeft >= 570) then
								NWB.data.layers[layer]["terokTowers10"] = nil;
								local layer = NWB:GetLayerNum(layer);
								local layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
								local msg = string.format(L["terokkarWarning"], "10 minutes") .. layerMsg .. ".";
								if (NWB.db.global.terokkarChat10) then
									NWB:print(msg);
								end
								if (NWB.db.global.terokkarMiddle10) then
									NWB:middleScreenMsgTBC("middle30", msg, nil, 5);
								end
								if (NWB.db.global.guildTerok10) then
									NWB:sendGuildMsg(msg, "guildTerok10", "terok", nil, "[NWB]");
								end
								--NWB:debug("terok10", secondsLeft);
							end
							if (secondsLeft < 0) then
								NWB.data.layers[layer]["terokTowers"] = nil;
								NWB.data.layers[layer]["terokTowersTime"] = nil;
								NWB.data.layers[layer]["terokFaction"] = nil;
								--NWB:debug("terrok timer ended on layer", layer);
							end
						end
					end
				end
				if (NWB.data.layers[layer][v .. "NpcDied"] and ((GetServerTime() - NWB.data.layers[layer][v .. "NpcDied"]) == npcRespawnTime
						or (GetServerTime() - NWB.data.layers[layer][v .. "NpcDied"]) == (npcRespawnTime - 1))) then
					NWB:doNpcRespawnMsg(v, layer);
				end
			end
		else
			if (not noWorldBuffTimers) then
				local secondsLeft = (NWB.data[v .. "Timer"] + offset) - GetServerTime();
				--This looks messy but when checking (secondsLeft == 0) it would sometimes skip, not sure why.
				--This gives it a 2 second window instead of 1.
				if (NWB.data[v .. "0"] and secondsLeft <= 0 and secondsLeft >= -1) then
					NWB.data[v .. "0"] = nil;
					NWB:doWarning(v, 0, secondsLeft);
				elseif (NWB.data[v .. "1"] and secondsLeft <= 60 and secondsLeft >= 59) then
					NWB.data[v .. "1"] = nil;
					NWB:doWarning(v, 1, secondsLeft);
					NWB:playSound("soundsOneMinute", "timer");
				elseif (NWB.data[v .. "5"] and secondsLeft <= 300  and secondsLeft >= 299) then
					NWB.data[v .. "5"] = nil;
					NWB:doWarning(v, 5, secondsLeft);
				elseif (NWB.data[v .. "10"] and secondsLeft <= 600  and secondsLeft >= 599) then
					NWB.data[v .. "10"] = nil;
					NWB:doWarning(v, 10, secondsLeft);
				elseif (NWB.data[v .. "15"] and secondsLeft <= 900 and secondsLeft >= 899) then
					NWB.data[v .. "15"] = nil;
					NWB:doWarning(v, 15, secondsLeft);
				elseif (NWB.data[v .. "30"] and secondsLeft <= 1800 and secondsLeft >= 1799) then
					NWB.data[v .. "30"] = nil;
					NWB:doWarning(v, 30, secondsLeft);
				end
			end
			if (k == 1) then
				if (NWB.isTBC) then
					if (NWB.data["terokTowers10"] and NWB.data["terokTowers"]) then
						--This timer drifts 3 seconds forward per minute.
						local endTime = NWB:getTerokEndTime(NWB.data["terokTowers"], NWB.data["terokTowersTime"]);
						local secondsLeft = endTime - GetServerTime();
						if (secondsLeft <= 630 and secondsLeft >= 570) then
							NWB.data["terokTowers10"] = nil;
							local msg = string.format(L["terokkarWarning"], "10 minutes") .. ".";
							if (NWB.db.global.terokkarChat10) then
								NWB:print(msg);
							end
							if (NWB.db.global.terokkarMiddle10) then
								NWB:middleScreenMsgTBC("middle30", msg, nil, 5);
							end
							if (NWB.db.global.guildTerok10) then
								NWB:sendGuildMsg(msg, "guildTerok10", "terok", nil, "[NWB]");
							end
						end
						if (secondsLeft < 0) then
							NWB.data.terokTowers = nil;
							NWB.data.terokTowersTime = nil;
							NWB.data.terokFaction = nil;
						end
					end
				end
			end
			if (NWB.data[v .. "NpcDied"] and ((GetServerTime() - NWB.data[v .. "NpcDied"]) == npcRespawnTime
					or (GetServerTime() - NWB.data[v .. "NpcDied"]) == (npcRespawnTime - 1))) then
				NWB:doNpcRespawnMsg(v);
			end
		end
	end
	if (NWB.played > 0) then
		NWB.played = NWB.played + 1;
	end
	if (NWB.data.myChars[UnitName("player")].buffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			--Correct a rare bug.
			if (not v.timeLeft) then
				NWB.data.myChars[UnitName("player")].buffs[k] = nil;
			else
				v.timeLeft = v.timeLeft - 1;
				--[[if (v.type == "dmf") then
					if ((lastDmfTick + 7200) >= 1 and (v.timeLeft + 7200) <= 0) then
						if (NWB.isDmfUp) then
							NWB:print(L["dmfBuffReset"]);
						end
						lastDmfTick = -99999;
						NWB.data.myChars[UnitName("player")].buffs[k] = nil;
					else
						lastDmfTick = v.timeLeft;
					end
				end]]
			end
		end
	end
	if (NWB.data.myChars[UnitName("player")].dmfCooldown) then
		NWB.data.myChars[UnitName("player")].dmfCooldown = NWB.data.myChars[UnitName("player")].dmfCooldown - 1;
		if (lastDmfTick >= 1 and NWB.data.myChars[UnitName("player")].dmfCooldown <= 0 and NWB.data.myChars[UnitName("player")].dmfCooldown > -99990) then
			if (NWB.isDmfUp or NWB.isAlwaysDMF) then
				NWB:print(L["dmfBuffReset"]);
			end
			lastDmfTick = -99999;
		else
			lastDmfTick = NWB.data.myChars[UnitName("player")].dmfCooldown;
		end
	end
	if (NWB.isWrath) then
		if (NWB.data.wintergrasp10 and NWB.data.wintergrasp
				and tonumber(NWB.data.wintergrasp)) then
			local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
			local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
			local secondsLeft = endTime - GetServerTime();
			lastSecondsLeft = secondsLeft;
			--Seems to not fire on 10mins sometimes, maybe getting a timer update that skips the 600 seconds remaining mark.
			--Trying a 30 second window instead.
			if (secondsLeft <= 600 and secondsLeft >= 590) then
				NWB.data.wintergrasp10 = nil;
				--local layer = NWB:GetLayerNum(layer);
				--local layerMsg = " (Layer " .. layer .. ")";
				--local msg = string.format(L["wintergraspWarning"], "10 minutes") .. layerMsg .. ".";
				local msg = string.format(L["wintergraspWarning"], "10 minutes") .. ".";
				if (NWB.db.global.wintergraspChat10) then
					NWB:print(msg);
				end
				if (NWB.db.global.wintergraspMiddle10) then
					NWB:middleScreenMsgTBC("middle30", msg, nil, 5);
				end
				--Terok guild setting is shared.
				if (NWB.db.global.guildTerok10) then
					NWB:sendGuildMsg(msg, "guildTerok10", "terok", nil, "[NWB]", 2.37);
				end
			end
			if (secondsLeft < 0) then
				--Don't wipe timer data for WG, we use it to calc forward from for missing new timer.
				--NWB.data.wintergrasp = nil;
				--NWB.data.wintergraspTime = nil;
				NWB.data.winterGraspFaction = nil;
			end
		end
	end
	NWB.db.global[NWB.realm][NWB.faction].myChars[UnitName("player")].lo = GetServerTime();
	--_G["\78\87\66"] = {};
	--NWB.db.global.lo = GetServerTime(); --Was this ever used?
	if (NWB.isSOD) then
		if (NWB.sodPhase == 3) then
			--NWB:checkAshenvaleTimer(); --Disabled in p4.
			NWB:checkStranglethornTimer();
		end
		--if (NWB.sodPhase == 4) then
			--NWB:checkBlackrockTimer();
		--end
	end
	if (NWB.isCata) then
		NWB:checkTolBaradTimer();
		--NWB:checkWintergraspTimer();
	end
	C_Timer.After(1, function()
		NWB:ticker();
	end)
end

--Filter addon comm warnings from yell for 5 seconds after sending a yell.
--Even though we only send 1 msg every few minutes I think it can still trigger this msg if a large amount of people are in 1 spot.
--Even if it triggers this msg the data still got out there to most people, it will spread just fine over time.
--Server side limit depends on how many people are close by when you send maybe?
--NWB.doFilterAddonChatMsg = false;
local function filterAddonChatMsg(self, event, msg, author, ...)
	if (NWB.loaded and event == "CHAT_MSG_SYSTEM") then
		--Filter if any data sent in the last 30 seconds.
		--But always filter on CN realms, they still get msgs even though we're filtering 30 seconds after.
		--I think CN have some other addon issues over there.
		if (string.find(msg, "The number of messages that can be sent is limited")) then
			NWB:debug("System msg:", GetServerTime() - NWB.lastDataSent);
		end
		if ((GetServerTime() - NWB.lastDataSent) < 30 or NWB.cnRealms[NWB.realm]) then
			--On some clients something is making ERR_CHAT_THROTTLED an empty string (maybe another addon?).
			--So we have to check for that not block all system msgs if it is.
			if (ERR_CHAT_THROTTLED and string.find(msg, ERR_CHAT_THROTTLED) and ERR_CHAT_THROTTLED ~= "") then
				--The number of messages that can be sent is limited, please wait to send another message.
				return true;
			end
			--Backup check of the actual string incase the first fails because of that empty string bug.
			if (string.find(msg, "The number of messages that can be sent is limited")
					or string.find(msg, "可发送的信息数量受限") or string.find(msg, "本頻道可傳送的訊息數量有限")) then
				return true;
	    	end
	    end
    elseif (event == "CHAT_MSG_WHISPER") then
    	--Filtering spam trying to force users into changing their personal settings.
    	local text = string.char(37) .. string.char(91) .. string.char(105) .. string.char(83) .. string.char(112)
    			.. string.char(97) .. string.char(109) .. string.char(37) .. string.char(93);
    	if (string.find(msg, text)) then
    		return true;
    	end
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterAddonChatMsg);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterAddonChatMsg);

--Send warnings to channels selected in options
NWB.warningThroddle = {
	["rend"] = 0,
	["ony"] = 0,
	["nef"] = 0,
	["zan"] = 0,
};
function NWB:doWarning(type, num, secondsLeft, layer)
	if (NWB[type .. "CooldownTime"] < 1) then
		return;
	end
	local throddleTime = 3;
	--Thoddle longer if buff are shared across layers (hotfix just added to layered realms).
	if (NWB.sharedLayerBuffs) then
		throddleTime = 30;
	end
	if (NWB.warningThroddle[type] and (GetServerTime() - NWB.warningThroddle[type]) < throddleTime) then
		return;
	end
	NWB.warningThroddle[type] = GetServerTime();
	local layerMsg = "";
	if ((type ~= "rend" or NWB.doLayerMsg) and layer) then
		local count = 0;
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			if (k == tonumber(layer)) then
				layerMsg = " (" .. L["Layer"] .. " " .. count .. ")";
			end
		end
	end
	local send = true;
	local buff;
	if (type == "rend") then
		buff = L["rend"];
		if (NWB.faction ~= "Horde" and not NWB.db.global.allianceEnableRend) then
			--We only send rend timer warnings to alliance if they have enabled it.
			send = nil;
		end
	elseif (type == "ony") then
		buff = L["onyxia"];
	elseif (type == "nef") then
		buff = L["nefarian"];
	elseif (type == "zan") then
		buff = L["zan"];
	end
	local msg;
	if (num == 0) then
		msg = string.format(L["newBuffCanBeDropped"], buff);
	else
		--Round the numbers if they're one second off, rarely happens.
		if (secondsLeft == 1799) then
			secondsLeft = 1800;
		elseif (secondsLeft == 899) then
			secondsLeft = 900;
		elseif (secondsLeft == 599) then
			secondsLeft = 600;
		elseif (secondsLeft == 299) then
			secondsLeft = 300;
		elseif (secondsLeft == 59) then
			secondsLeft = 60;
		end
		msg = string.format(L["buffResetsIn"], buff, NWB:getTimeString(secondsLeft, true));
	end
	if ((type == "ony" and NWB.data.onyNpcDied > NWB.data.onyTimer)
			or (type == "nef" and (NWB.data.nefNpcDied > NWB.data.nefTimer))) then
		--If npc killed timestamp is newer than last set time then don't send any warnings.
		return;	
	end
	local period = ".";
	if (LOCALE_zhCN or LOCALE_zhTW) then
		period = "。";
	end
	msg = msg .. layerMsg .. period;
	--Chat.
	if (not NWB.db.global.chatOnlyInCity or NWB:isCapitalCityAction(type)) then
		if (NWB.db.global.chat30 and num == 30 and send) then
			NWB:print(msg, nil, nil, true);
		elseif (NWB.db.global.chat15 and num == 15 and send) then
			NWB:print(msg, nil, nil, true);
		elseif (NWB.db.global.chat10 and num == 10 and send) then
			NWB:print(msg, nil, nil, true);
		elseif (NWB.db.global.chat5 and num == 5 and send) then
			NWB:print(msg, nil, nil, true);
		elseif (NWB.db.global.chat1 and num == 1 and send) then
			NWB:print(msg, nil, nil, true);
		elseif (NWB.db.global.chat0 and num == 0 and send) then
			NWB:print(msg, nil, nil, true);
		end
	end
	--Guild.
	local loadWait = GetServerTime() - NWB.loadTime;
	if (loadWait > 5 and NWB.db.global.guild10 == 1 and num == 10 and send) then
		NWB:sendGuildMsg(msg, "guild10", type);
	elseif (loadWait > 5 and NWB.db.global.guild1 == 1 and num == 1 and send) then
		NWB:sendGuildMsg(msg, "guild1", type);
	end
	if (num == 1 and (type ~= "rend" or (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend))) then
		NWB:startFlash("flashOneMin", type);
	end
	--Middle of the screen.
	if (InCombatLockdown() and NWB.db.global.middleHideCombat) then
		return;
	end
	local inInstance, instanceType = IsInInstance();
	if (inInstance and instanceType == "raid" and NWB.db.global.middleHideRaid) then
		return;
	end
	if ((UnitInBattleground("player") or NWB:isInArena()) and NWB.db.global.middleHideBattlegrounds) then
		return;
	end
	if (not NWB.db.global.middleOnlyInCity or NWB:isCapitalCityAction(type)) then
		if (NWB.db.global.middle30 and num == 30 and send) then
			NWB:middleScreenMsg("middle30", msg, nil, 5);
		elseif (NWB.db.global.middle15 and num == 15 and send) then
			NWB:middleScreenMsg("middle15", msg, nil, 5);
		elseif (NWB.db.global.middle10 and num == 10 and send) then
			NWB:middleScreenMsg("middle10", msg, nil, 5);
		elseif (NWB.db.global.middle5 and num == 5 and send) then
			NWB:middleScreenMsg("middle5", msg, nil, 5);
		elseif (NWB.db.global.middle1 and num == 1 and send) then
			NWB:middleScreenMsg("middle1", msg, nil, 5);
		elseif (NWB.db.global.middle0 and num == 0 and send) then
			NWB:middleScreenMsg("middle0", msg, nil, 5);
		end
	end
end

--Only one person online at a time sends guild msgs so there's no spam, chosen by alphabetical order.
--Can also specify zone so only 1 person from that zone will send the msg (like orgrimmar when npc yell goes out).
function NWB:sendGuildMsg(msg, msgType, buffType, zoneName, prefix, minVersion)
	local isZan = strfind(msg, string.gsub(L["zanFirstYellMsg"], "%%s", "(.+)"));
	if (isZan) then
		--They reused the same NPC and drop msg as ZF buff in SoD for the Sunken Temple buff.
		--So block it from announcing during phase 3 until everyone updates the addon and it's blocked in yell detection.
		--6 second drop time like the other SoD buffs, no reason to announce.
		if (NWB.isSOD and NWB.sodPhase == 3) then
			return;
		end
	end
	--Don't send buff dropped msgs to guild chat now the cooldown is changed to 1 minute, too spammy.
	--The "buff will dorp in 14 seconds" pre-warning msgType msgs will still get sent, 1 msg is enough.
	--This is also disabled in the actual sending of the guild commans func.
	if (NWB.noGuildBuffDroppedMsgs and msgType == "guildBuffDropped") then
		return;
	end
	if (not NWB.isClassic and msgType ~= "guildTerok10" and msgType ~= "guildWintergrasp10") then
		return;
	end
	if (NWB.db.global.disableAllGuildMsgs == 1) then
		return;
	end
	if (not IsInGuild()) then
		return;
	end
	--Disable guild msg if GM has it disabled in their public note.
	if (NWB:checkGuildMasterSetting("sendGuildMsg", msgType)) then
		return;
	end
	if (not NWB:checkEventStatus("sendGuildMsg", buffType, msgType)) then
		return;
	end
	GuildRoster();
	local shortSettingsKeys = {
		--Check the short keys we use for sending smaller data also.
		--Just incase there wern't converted back properly on data received for some reason.
		["disableAllGuildMsgs"] = "a",
		["guildBuffDropped"] = "b",
		["guildNpcDialogue"] = "c",
		["guildZanDialogue"] = "d",
		["guildNpcKilled"] = "e",
		["guildSongflower"] = "f",
		["guildCommand"] = "g",
		["guild30"] = "h",
		["guild15"] = "i",
		["guild10"] = "j",
		["guild5"] = "k",
		["guild1"] = "l",
		["guild0"] = "m",
		["guildNpcWalking"] = "K",
		["guildTerok10"] = "V",
	};
	local numTotalMembers = GetNumGuildMembers();
	local onlineMembers = {};
	local me = UnitName("player") .. "-" .. GetNormalizedRealmName();
	for i = 1, numTotalMembers do
		local name, _, _, _, _, zone, _, _, online, _, _, _, _, isMobile = GetGuildRosterInfo(i);
		if (zoneName) then
			if (name and zone == zoneName and online and NWB.hasAddon[name] and not isMobile) then
				--If guild member is in zone specified and online and has addon installed add to temp table.
				--Not currently used anywhere, was removed.
				onlineMembers[name] = true;
			end
		elseif (msgType) then
			--If msgType then check our db for other peoples settings to ignore them in online list if they have this msgType disabled.
			if (name and online and NWB.hasAddon[name] and not isMobile) then
				local skip;
				if (minVersion) then
					skip = true;
					if (tonumber(NWB.hasAddon[name]) and tonumber(NWB.hasAddon[name]) >= minVersion) then
						skip = nil;
					end
				end
				if (not skip) then
					if (NWB.data[name]) then
						--If this is another guild member then check their settings.	
						--A few different checks for backwards compatability.
						if ((NWB.data[name][msgType] == true or NWB.data[name][msgType] == 1
								or NWB.data[name][shortSettingsKeys[msgType]] == true or NWB.data[name][shortSettingsKeys[msgType]] == 1)
								and NWB.data[name].disableAllGuildMsgs ~= true and NWB.data[name].disableAllGuildMsgs ~= 1
								and NWB.data[name].a ~= true and NWB.data[name].a ~= 1) then
							--Has addon and has this msgType of msg msgType option enabled.
							onlineMembers[name] = true;
						end
					elseif (name == me) then
						--If myself check my settings.
						if ((NWB.db.global[msgType] == true or NWB.db.global[msgType] == 1)
								and NWB.db.global.disableAllGuildMsgs ~= true and NWB.db.global.disableAllGuildMsgs ~= 1) then
							onlineMembers[name] = true;
						end
					end
				end
			end
		else
			if (name and online and NWB.hasAddon[name] and not isMobile) then
				--If guild member is online and has addon installed add to temp table.
				onlineMembers[name] = true;
			end
		end
	end
	--Check temp table to see if we're first in alphabetical order.
	for k, v in NWB:pairsByKeys(onlineMembers) do
		if (k == me) then
			if (prefix) then
				SendChatMessage(prefix .. " " .. NWB:stripColors(msg), "guild");
			else
				SendChatMessage("[WorldBuffs] " .. NWB:stripColors(msg), "guild");
			end
		end
		return;
	end
end

function NWB:inMyGuild(who)
	if (who) then
		for i = 1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i);
			if (name) then
				local nameOnly, realm = strsplit("-", who, 2);
				if (who == name or who == nameOnly) then
					return true;
				end
			end
		end
	end
end

function NWB:logonCheckGuildMasterSetting()
	C_Timer.After(10, function()
		NWB.checkedGuildNote = true;
		NWB:checkGuildMasterSetting("set");
	end)
end

--Setting to allow guild masters to disable msgs in chat.
NWB.guildMasterSettings = {};
function NWB:checkGuildMasterSetting(type)
	if (not IsInGuild()) then
		return;
	end
	local note = "";
	local name, rank, rankIndex;
	local numTotalMembers = GetNumGuildMembers();
	for i = 1, numTotalMembers do
		name, rank, rankIndex, _, _, _, note = GetGuildRosterInfo(i);
		if (rankIndex == 0) then
			--Guild Master.
			break;
		end
	end
	local settings = {
		--Disable certain guild msgs based on guild masters note.
		["#nwb1"] = 1, --1 = Disable All msgs.
		["#nwb2"] = 2, --2 = Disable timers msgs.
		["#nwb3"] = 3, --3 = Disable buff dropped msgs.
		["#nwb4"] = 4, --4 = Disable !wb command.
		["#nwb5"] = 5, --5 = Disable Songflowers msgs.
		["#nwb6"] = 6, --6 = Guild only data.
		["#nwb7"] = 7, --7 = Disable NPC killed.
		["#nwb7"] = 8, --8 = Disable NPC walking.
	}
	local found, foundGuilddata;
	NWB.guildMasterSettings = {};
	for k, v in pairs(settings) do
		if (note and string.find(string.lower(note), k)) then
			--NWB:debug("Guild master setting found:", k);
			NWB.guildMasterSettings[v] = true;
			if (v == 1) then
				found = true;
			elseif (v == 2) then
				if (type == "guild30" or type == "guild15" or type == "guild10"
					 or type == "guild5" or type == "guild1" or type == "guild0"
					 or type == "guildTerok10") then
					found = true;
				end
			elseif (v == 3) then
				if (type == "guildBuffDropped" or type == "guildNpcDialogue" or type == "guildZanDialogue") then
					found = true;
				end
			elseif (v == 4) then
				if (type == "guildCommand") then
					found = true;
				end
			elseif (v == 5) then
				if (type == "guildSongflower") then
					found = true;
				end
			elseif (v == 6) then
				NWB.guildDataOnly = true;
				foundGuilddata = true;
			elseif (v == 7) then
				if (type == "guildNpcKilled") then
					found = true;
				end
			elseif (v == 8) then
				if (type == "guildNpcWalking") then
					found = true;
				end
			end
		end
	end
	--Possibly make this work with guild info later too.
	--local guildInfoText = GetGuildInfoText();
	if (not foundGuilddata) then
		NWB.guildDataOnly = nil;
	end
	if (found) then
		--if (type ~= "set") then
		--	NWB:debug("Found", type, note);
		--end
		return true;
	end
end

--Guild chat msg event.
local guildWbCmdCooldown, guildDmfCmdCooldown = 0, 0;
function NWB:chatMsgGuild(...)
	local msg = ...;
	msg = string.lower(msg);
	local cmd, arg = strsplit(" ", msg, 2);
	if (string.match(msg, "^!wb") and NWB.db.global.guildCommand == 1 and (GetServerTime() - guildWbCmdCooldown) > 5) then
		guildWbCmdCooldown = GetServerTime();
		NWB:sendGuildMsg(NWB:getShortBuffTimers("guildCommand", arg), "guildCommand", "!wb");
	end
	if (string.match(msg, "^!dmf") and NWB.db.global.guildCommand == 1 and (GetServerTime() - guildDmfCmdCooldown) > 5) then
		guildDmfCmdCooldown = GetServerTime();
		local output = NWB:getDmfTimeString();
		if (output) then
			NWB:sendGuildMsg(output, "guildCommand", "!dmf");
		end
	end
end

function NWB:placeSilithystMarker()
	if (not _G["NWBSilithystMarkerMini"]) then
		--Minimap marker.
		local obj = CreateFrame("FRAME", "NWBSilithystMarkerMini");
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture("Interface\\Icons\\spell_nature_timestop");
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(13, 13);
	end
	if (NWB.faction == "Horde") then
		NWB.dragonLibPins:AddMinimapIconMap("NWBSilithystMarkerMini", _G["NWBSilithystMarkerMini"], 1451, 0.51126305182546, 0.70190497530969, nil, true);
	else
		NWB.dragonLibPins:AddMinimapIconMap("NWBSilithystMarkerMini", _G["NWBSilithystMarkerMini"], 1451, 0.3271578265816, 0.50960349204134, nil, true);
	end
end

function NWB:removeSilithystMarker()
	NWB.dragonLibPins:RemoveMinimapIcon("NWBSilithystMarkerMini", _G["NWBSilithystMarkerMini"]);
end

function NWB:doStealth()
	NWB:doVanish();
end

local waitingCombatEnd;
function NWB:doVanish()
	if (NWB.db.global.dmfVanishSummon and (GetServerTime() - NWB.lastDmfBuffGained) <= NWB.db.global.buffHelperDelay) then
		waitingCombatEnd = true;
		NWB.hideSummonPopup = true;
		if (C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
			NWB:print("Vanished after DMF buff, auto taking summon.");
		end
		--We really want to spam summon accept when we vanish.
		NWB:doTakeSummon();
		local delay = 0.1;
		local count = 1;
		for i = 1, 10 do
			C_Timer.After(i * delay, function()
				NWB:doTakeSummon();
			end)
		end
		NWB:acceptSummon();
	end
end

function NWB:doFeign()
	if (NWB.db.global.dmfFeignSummon and (GetServerTime() - NWB.lastDmfBuffGained) <= NWB.db.global.buffHelperDelay) then
		waitingCombatEnd = true;
		NWB.hideSummonPopup = true;
		if (C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
			NWB:print("Feigned after DMF buff, auto taking summon.");
		end
		NWB:doTakeSummon();
		local delay = 0.1;
		local count = 1;
		for i = 1, 10 do
			C_Timer.After(i * delay, function()
				C_SummonInfo.ConfirmSummon();
			end)
		end
		NWB:acceptSummon();
	end
end

--Adding a check for in instances and unbooning, some speedrun strats use pre summons.
function NWB:doTakeSummon()
	local isInstance = IsInInstance();
	if (isInstance) then
		return;
	end
	C_SummonInfo.ConfirmSummon();
end

local hideSummonTimer;
function NWB:acceptSummon(count, delay)
	if (not count) then
		count = 10;
	end
	if (not delay) then
		delay = 1;
	end
	NWB.hideSummonPopup = true;
	NWB:doTakeSummon();
	for i = 1, count do
		C_Timer.After(i * delay, function()
			NWB:doTakeSummon();
		end)
	end
	if (hideSummonTimer) then
		hideSummonTimer:Cancel();
	end
	hideSummonTimer = C_Timer.NewTimer(count * delay, function()
		NWB.hideSummonPopup = nil;
	end)
end

function NWB:enteredBattleground()
	if (NWB.db.global.dmfLeaveBG and (GetServerTime() - NWB.lastDmfBuffGained) <= NWB.db.global.buffHelperDelay) then
		SendChatMessage("", "AFK");
	end
end

function NWB:leftCombat()
	if (waitingCombatEnd or (NWB.db.global.dmfCombatSummon and (GetServerTime() - NWB.lastDmfBuffGained) <= NWB.db.global.buffHelperDelay)) then
		if (C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
			NWB:print("Got DMF buff, auto taking summon.");
		end
		NWB.hideSummonPopup = true;
		NWB:acceptSummon();
	end
	waitingCombatEnd = nil;
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ZONE_CHANGED_NEW_AREA");
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		local _, _, zone = NWB:GetPlayerZonePosition();
		NWB.data.lastZone = zone;
		if (NWB.hideSummonPopup) then
			NWB.hideSummonPopup = nil;
			StaticPopup_Hide("CONFIRM_SUMMON");
		end
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		local _, _, zone = NWB:GetPlayerZonePosition();
		NWB.data.lastZone = zone;
		--If we are summoned to the same zone we're already in.
		if (NWB.hideSummonPopup) then
			NWB.hideSummonPopup = nil;
			StaticPopup_Hide("CONFIRM_SUMMON");
		end
	end
end)

function NWB:getSingleLayer()
	if (NWB.isLayered) then
		local count = 0;
		local layer;
		for k, v in pairs(NWB.data.layers) do
			count = count + 1;
			layer = k;
		end
		if (count == 1) then
			return layer;
		end
	end
end

--Validate new timer, mostly used for testing blanket fixes for timers.
function NWB:validateNewTimer(type, source, timestamp)
	if (type == "rend") then
		return true;
	elseif (type == "ony") then
		if (source == "dbm") then
			local timer = NWB.data.onyTimer;
			local respawnTime = NWB.onyCooldownTime;
			if ((timer - 30) > (GetServerTime() - respawnTime) and not (NWB.data.onyNpcDied > timer)) then
				--Don't set dbm timers if valid timer already exists (current bug).
				NWB:debug("trying to set timer from dbm when timer already exists");
				return;
			end
		end
		if (NWB.data.nefTimer == timestamp or NWB.data.nefTimer == GetServerTime()) then
			NWB:debug("ony trying to set exact same timer as nef", source);
			--Make sure ony never syncs with nef time stamp (current bug).
			return;
		end
	elseif (type == "nef") then
		if (NWB.data.onyTimer == timestamp or NWB.data.onyTimer == GetServerTime()) then
			NWB:debug("nef trying to set exact same timer as ony", source);
			--Make sure nef never syncs with ony time stamp (current bug).
			return;
		end
	end
	--If this is a realm with layering still (TW/CN) then don't overwrite timers ever, atleast 1 layer will be correct then.
	--Really not sure why Blizzard still have layering in these asian regions.
	--if (NWB.isLayered and NWB.data[type .. "Timer"]
		--Disabled for now for new layer tracking method.
	--		and (NWB.data[type .. "Timer"] > (GetServerTime() - NWB[type .. "CooldownTime"]))) then
	--	return;
	--end
	return true;
end

function NWB:validateTimestamp(timestamp, type, layer)
	local currentTime = GetServerTime();
	if (not tonumber(timestamp)) then
		return;
	end
	if (timestamp > 2585912598) then
		return;
	end
	if (timestamp > (currentTime + 30000)) then
		return;
	end
	--if (type == "nefNpcDied" and NWB.faction == "Horde") then
	--	return;
	--end
	if (NWB.db.global.noOverwrite and type and (type == "rendTimer" or type == "onyTimer" or type == "nefTimer"
			or string.match(type, "^flower"))) then
		if (NWB:isTimerCurrent(type, layer, timestamp)) then
			return;
		end
	end
	return true;
end

function NWB:isTimerCurrent(type, layer, timestamp)
	local dataPrefix;
	if (NWB.isLayered and layer) then
		dataPrefix = NWB.data.layers[layer];
	else
		dataPrefix = NWB.data;
	end
	if (type == "rendTimer") then
		if (dataPrefix.rendTimer and dataPrefix.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
			if (timestamp and (timestamp - dataPrefix.rendTimer) < 25) then
				return;
			end
			return true;
		end
	elseif (type == "onyTimer") then
		if (dataPrefix.onyTimer and dataPrefix.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
			if (timestamp and (timestamp - dataPrefix.onyTimer) < 25) then
				return;
			end
			return true;
		end
	elseif (type == "nefTimer") then
		if (dataPrefix.nefTimer and dataPrefix.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
			if (timestamp and (timestamp - dataPrefix.nefTimer) < 25) then
				return;
			end
			return true;
		end
	elseif (string.match(type, "^flower")) then
		if (dataPrefix[type] and dataPrefix[type] > (GetServerTime() - 1500)) then
			if (timestamp and (timestamp - dataPrefix[type]) < 10) then
				return;
			end
			return true;
		end
	end
end

function NWB:questTurnedIn(...)
	local questID = ...;
	if (questID == 4974 or questID == 7491 or questID == 7784
			or questID == 7496 or questID == 7782 or questID == 8183) then
		NWB:sendHandIn("YELL", questID);
	end
end

local function insertDmfDamageTooltip()
	if (not NWB.isClassic) then
		local title = GameTooltipTextLeft1:GetText();
		if (title and string.find(title, L["Sayge's Dark Fortune of Damage"])) then
			local percent;
			for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
				if (k == L["Sayge's Dark Fortune of Damage"] and v.dmfPercent) then
					percent = v.dmfPercent;
				end
			end
			if (percent) then
				percent = "|cFF00C800" .. percent .. "%|r";
				GameTooltip:AddLine(string.format(L["dmfDamagePercentTooltip"], percent),
						NWB.db.global.prefixColorR, NWB.db.global.prefixColorG, NWB.db.global.prefixColorB);
				GameTooltip:Show();
			end
		end
	end
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
	insertDmfDamageTooltip();
end);

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
	local unit = ...;
	if (UnitIsUnit(unit, "player")) then
		insertDmfDamageTooltip();
	end
end);

local dmfDmgPercent = 0;
NWB.unitDamageFrame = CreateFrame("Frame");
NWB.unitDamageFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_DAMAGE") then
		local doMsg = true;
		local _, _, _, _, _, _, percent = UnitDamage("player");
		percent = NWB:round(percent * 100) - NWB:round(dmfDmgPercent  * 100);
		if (percent > 0) then
			for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
				if (k == L["Sayge's Dark Fortune of Damage"]) then
					NWB.data.myChars[UnitName("player")].buffs[k].dmfPercent = percent;
					if (doMsg) then
						C_Timer.After(1, function()
							NWB:printDmfPercent();
						end)
						doMsg = false;
					end
				end
			end
		end
		NWB.unitDamageFrame:UnregisterEvent("UNIT_DAMAGE");
	end
end)

function NWB:trackUnitDamage()
	local _, _, _, _, _, _, percent = UnitDamage("player");
	if (tonumber(percent)) then
		dmfDmgPercent = NWB:round(percent, 2);
	end
end

function NWB:printDmfPercent()
	local percent;
	for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
		if (k == L["Sayge's Dark Fortune of Damage"] and v.dmfPercent) then
			percent = v.dmfPercent;
		end
	end
	if (percent) then
		NWB:print(string.format(L["dmfDamagePercent"], percent));
	end
end

local playedWindows = {};
function NWB:isTimePlayedMsgRegistered()
	for i = 1, NUM_CHAT_WINDOWS do
		if (_G['ChatFrame' .. i] and _G['ChatFrame' .. i]:IsEventRegistered("TIME_PLAYED_MSG")) then
			return true;
		end
	end
end

function NWB:registerTimePlayedMsg()
	for k, v in pairs(playedWindows) do
		if (_G['ChatFrame' .. k]) then
			_G['ChatFrame' .. k]:RegisterEvent("TIME_PLAYED_MSG");
		end
	end
end

function NWB:unregisterTimePlayedMsg()
	playedWindows = {};
	for i = 1, NUM_CHAT_WINDOWS do
		if (_G['ChatFrame' .. i] and _G['ChatFrame' .. i]:IsEventRegistered("TIME_PLAYED_MSG")) then
			_G['ChatFrame' .. i]:UnregisterEvent("TIME_PLAYED_MSG");
			playedWindows[i] = true;
		end
	end
end

--Track our current buff durations across all chars.
local gotPlayedData, reregisterPlayedEvent;
local chronoRestoreUsed = 0;
function NWB:trackNewBuff(spellName, type, npcID)
	if (not NWB.data.myChars[UnitName("player")].buffs[spellName]) then
		NWB.data.myChars[UnitName("player")].buffs[spellName] = {};
	end
	if (not NWB.data.myChars[UnitName("player")].buffs[spellName].setTime) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].setTime = 0;
	end
	if (not NWB.data.myChars[UnitName("player")].buffs[spellName].timeLeft) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].timeLeft = 0;
	end
	if (not NWB.data.myChars[UnitName("player")][type .. "Count"]) then
		NWB.data.myChars[UnitName("player")][type .. "Count"] = 0;
	end
	if (GetTime() - chronoRestoreUsed > 1) then
		NWB.data.myChars[UnitName("player")][type .. "Count"] = NWB.data.myChars[UnitName("player")][type .. "Count"] + 1;
	end
	NWB.data.myChars[UnitName("player")].buffs[spellName].type = type;
	--Set timestamp as a backup to calc from when dmf buff is got.
	NWB.data.myChars[UnitName("player")].buffs[spellName].setTime = GetServerTime();
	NWB.data.myChars[UnitName("player")].buffs[spellName].track = true;
	if (NWB.data.myChars[UnitName("player")].buffs[spellName].noMsgs) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].noMsgs = nil;
		NWB.data.myChars[UnitName("player")].dmfCooldownNoMsgs = nil;
	end
	if (npcID and tonumber(npcID)) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].npcID = tonumber(npcID);
	end
	--Request played data when getting new buff drops to calc from as primary.
	--Use local cache if we have a valid number from RequestTimePlayed() at logon, otherwise request new data.
	if (NWB.played > 600) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].playedCacheSetAt = NWB.played;
		NWB:syncBuffsWithCurrentDuration();
		NWB:recalcBuffTimers();
	else
		NWB.currentTrackBuff = NWB.data.myChars[UnitName("player")].buffs[spellName];
		--Hide the msg from chat.
		if (not gotPlayedData) then
			if (NWB:isTimePlayedMsgRegistered()) then
				reregisterPlayedEvent = true;
				NWB:unregisterTimePlayedMsg();
			end
			gotPlayedData = true;
			RequestTimePlayed();
		end
	end
	if (type == "dmf") then
		NWB:print(string.format(L["dmfBuffDropped"], spellName));
		NWB:addDmfCooldown();
	end
	--NWB:debug(GetServerTime(), "Tracking new buff", type, spellName);
	NWB:recalcBuffListFrame();
end

function NWB:untrackBuff(spellName)
	if (NWB.data.myChars[UnitName("player")].buffs and NWB.data.myChars[UnitName("player")].buffs[spellName]) then
		NWB.data.myChars[UnitName("player")].buffs[spellName].track = false;
		if (spellName == L["Sayge's Dark Fortune of Damage"]) then
			NWB.data.myChars[UnitName("player")].buffs[spellName].dmfPercent = nil;
		end
		NWB:recalcBuffListFrame();
	end
end

local spellTypes = NWB.spellTypes;
local dmfBuffTable = NWB.dmfBuffTable;
local buffTable = NWB.buffTable;

local function findSpellTypeByName(spellName)
	for k, v in pairs(buffTable) do
		if (spellName == L[v.fullName]) then
			return k;
		end
	end
	for k, v in pairs(dmfBuffTable) do
		if (spellName == L[v.fullName]) then
			return v.type;
		end
	end
end

function NWB:getDmfCooldown()
	if (NWB.data.myChars[UnitName("player")].dmfCooldown) then
		return NWB.data.myChars[UnitName("player")].dmfCooldown, NWB.data.myChars[UnitName("player")].dmfCooldownNoMsgs;
	else
		--Old way pre chronoboon.
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (v.type == "dmf" and (v.timeLeft + 7200) > 0) then
				return v.timeLeft + 7200, v.noMsgs;
			end
		end
	end
	return 0;
end

function NWB:addDmfCooldown()
	NWB.data.myChars[UnitName("player")].dmfCooldown = 14400;
end

function NWB:resetDmfCooldown()
	NWB.data.myChars[UnitName("player")].dmfCooldown = 0;
end

function NWB:dmfChronoCheck()
	--if (NWB.data.myChars[UnitName("player")].storedBuffs and GetTime() - chronoRestoreUsed < 8) then
	if (NWB.data.myChars[UnitName("player")].storedBuffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].storedBuffs) do
			if (v.type == "dmf") then
				NWB:addDmfCooldown();
				if (NWB.isDmfUp or NWB.isAlwaysDMF) then
					NWB:print(L["chronoboonReleased"]);
				end
				return;
			end
		end
	end
end

--Recalc time left on buffs we track.
--We recalc it from current total played time vs total played we recorded at time of buff drop.
function NWB:recalcBuffTimers()
	if (not gotPlayedData) then
		NWB:debug("no played data found");
		return
	end
	if (NWB.data.myChars[UnitName("player")].buffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (not v.timeLeft or not v.setTime) then
				NWB.data.myChars[UnitName("player")].buffs[k] = nil;
			else
				if (not v.playedCacheSetAt) then
					v.playedCacheSetAt = 0;
				end
				--Calc the difference between current total played time and the played time we record when buff was gotten.
				v.timeLeft = buffTable[v.type].maxDuration - (NWB.played - v.playedCacheSetAt);
				--v.timeLeft = NWB.db.global[v.type .. "BuffTime"] - (NWB.played - v.playedCacheSetAt);
				--NWB.data.myChars[UnitName("player")].buffs[k].timeLeft = NWB.db.global[v.type .. "BuffTime"] - (NWB.played - v.playedCacheSetAt);
			end
		end
	end
	NWB:recalcBuffListFrame();
end

--/played can sometimes drift a bit with buff durations, probably due to loads times and such.
--Here we resync the buff tracking with current buff durations.
--And pick up any buffs not being tracked already for whenever reason.
function NWB:syncBuffsWithCurrentDuration()
	--Remove any buffs still being tracked that we don't have, seems to only happen when there's server lag during chronoboon use.
	if (NWB.data.myChars[UnitName("player")].buffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (v.track and v.timeLeft > 0) then
				local expirationTime = NWB:getBuffDuration(k, 1);
				if (expirationTime == 0) then
					NWB.data.myChars[UnitName("player")].buffs[k].track = false;
					NWB:debug("removed inactive buff during sync", k);
				end
			end
		end
	end
	for i = 1, 32 do
		local spellName, _, _, _, _, expirationTime, _, _, _, spellID = UnitBuff("player", i);
		if (spellName and NWB.played > 600) then
			local foundType = findSpellTypeByName(spellName);
			if (NWB.data.myChars[UnitName("player")].buffs and (NWB.data.myChars[UnitName("player")].buffs[spellName] or foundType)) then
				if (NWB.data.myChars[UnitName("player")].buffs[spellName] and spellTypes[spellID]) then
					local type = NWB.data.myChars[UnitName("player")].buffs[spellName].type;
					local timeLeft = expirationTime - GetTime();
					local maxDuration = (buffTable[type].maxDuration or 0);
					--local maxDuration = NWB.db.global[type .. "BuffTime"] or 0;
					local elapsedDuration = maxDuration - timeLeft;
					local newPlayedCache = NWB.played - elapsedDuration;
					if (timeLeft > 0) then
						NWB.data.myChars[UnitName("player")].buffs[spellName].track = true;
					end
					--Change the played seconds this was buff was set at to match the current time elapsed on our current buff.
					NWB.data.myChars[UnitName("player")].buffs[spellName].playedCacheSetAt = math.floor(newPlayedCache);
					--NWB:debug("Resyncing tracked buff:", spellName);
					if (not NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"]
							or NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"] == 0) then
						NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"] = 1;
					end
				elseif (foundType) then
					local type = foundType;
					NWB.data.myChars[UnitName("player")].buffs[spellName] = {};
					NWB.data.myChars[UnitName("player")].buffs[spellName].type = type;
					local timeLeft = expirationTime - GetTime();
					local maxDuration = (buffTable[type].maxDuration or 0);
					--local maxDuration = NWB.db.global[type .. "BuffTime"] or 0;
					local elapsedDuration = maxDuration - timeLeft;
					local newPlayedCache = NWB.played - elapsedDuration;
					NWB.data.myChars[UnitName("player")].buffs[spellName].timeLeft = timeLeft;
					NWB.data.myChars[UnitName("player")].buffs[spellName].setTime = GetServerTime();
					NWB.data.myChars[UnitName("player")].buffs[spellName].track = true;
					--Change the played seconds this was buff was set at to match the current time elapsed on our current buff.
					NWB.data.myChars[UnitName("player")].buffs[spellName].playedCacheSetAt = math.floor(newPlayedCache);
					NWB:debug("Resyncing foundType tracked buff", spellName);
					if (not NWB.data.myChars[UnitName("player")][type .. "Count"]
							or NWB.data.myChars[UnitName("player")][type .. "Count"] == 0) then
						NWB.data.myChars[UnitName("player")][type .. "Count"] = 1;
					end
				end
			elseif (spellTypes[spellID]) then
				local type = spellTypes[spellID];
				NWB.data.myChars[UnitName("player")].buffs[spellName] = {};
				NWB.data.myChars[UnitName("player")].buffs[spellName].type = type;
				local timeLeft = expirationTime - GetTime();
				local maxDuration = (buffTable[type].maxDuration or 0);
				--local maxDuration = NWB.db.global[type .. "BuffTime"] or 0;
				local elapsedDuration = maxDuration - timeLeft;
				local newPlayedCache = NWB.played - elapsedDuration;
				NWB.data.myChars[UnitName("player")].buffs[spellName].timeLeft = timeLeft;
				NWB.data.myChars[UnitName("player")].buffs[spellName].setTime = GetServerTime();
				NWB.data.myChars[UnitName("player")].buffs[spellName].track = true;
				--Change the played seconds this was buff was set at to match the current time elapsed on our current buff.
				NWB.data.myChars[UnitName("player")].buffs[spellName].playedCacheSetAt = math.floor(newPlayedCache);
				NWB:debug("Resyncing spellID tracked buff", spellName);
				if (not NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"]
						or NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"] == 0) then
					NWB.data.myChars[UnitName("player")][spellTypes[spellID] .. "Count"] = 1;
				end
			end
		end
	end
	NWB:recalcBuffTimers();
end

--This has to check npcID's as well as names to work for all languages.
--We have no spellID's to check thanks to combat log hiding them in classic.
local tempStoredBuffs = {};
function NWB:storeBuffs()
	NWB:syncBuffsWithCurrentDuration();
	NWB:debug("temp storing buffs");
	if (NWB.data.myChars[UnitName("player")].buffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (v.track and v.timeLeft and v.timeLeft > 0) then
				--This cluster is thanks to hidden spellID's in classic and dealing with locales.
				if (k == L["Warchief's Blessing"] or k == L["Rallying Cry of the Dragonslayer"] or k == L["Songflower Serenade"]
						or k == L["Slip'kik's Savvy"] or k == L["Fengus' Ferocity"] or k == L["Mol'dar's Moxie"]
						or k == L["Spirit of Zandalar"] or k == L["Sayge's Dark Fortune of Agility"]
						or k == L["Sayge's Dark Fortune of Intelligence"] or k == L["Sayge's Dark Fortune of Spirit"]
						or k == L["Sayge's Dark Fortune of Stamina"] or k == L["Sayge's Dark Fortune of Strength"]
						or k == L["Sayge's Dark Fortune of Armor"] or k == L["Sayge's Dark Fortune of Resistance"]
						or k == L["Sayge's Dark Fortune of Damage"] or k == L["Boon of Blackfathom"]
						or k == L["Spark of Inspiration"] or k == L["Fervor of the Temple Explorer"] or k == L["Might of Stormwind"]) then
					tempStoredBuffs[k] = {};
					for kk, vv in pairs(v) do
						tempStoredBuffs[k][kk] = vv;
					end
				elseif (v.npcID and (v.npcID == 14392 or v.npcID == 14394
						or v.npcID == 14720 or v.npcID == 14721 or v.npcID == 4949 or v.npcID == 10719 or v.npcID == 14875
						or v.npcID == 15076 or v.npcID == 14326 or v.npcID == 14321 or v.npcID == 14323
						or v.npcID == 9087 or v.npcID == 4783)) then
					tempStoredBuffs[k] = {};
					for kk, vv in pairs(v) do
						tempStoredBuffs[k][kk] = vv;
					end
				end
			end
		end
	end
end

--Insert buffs from temp table we recorded on cast start.
function NWB:recordStoredBuffs()
	NWB:debug("record temp stored buffs");
	if (not NWB.data.myChars[UnitName("player")].storedBuffs) then
		NWB.data.myChars[UnitName("player")].storedBuffs = {};
	end
	for k, v in pairs(tempStoredBuffs) do
		NWB.data.myChars[UnitName("player")].storedBuffs[k] = {};
		for kk, vv in pairs(v) do
			NWB.data.myChars[UnitName("player")].storedBuffs[k][kk] = vv;
		end
	end
	tempStoredBuffs = {};
	NWB:recalcBuffTimers();
end

function NWB:clearTempStoredBuffs()
	NWB:debug("clear temp stored buffs");
	tempStoredBuffs = {};
end

function NWB:clearStoredBuffs()
	NWB:debug("clear stored buffs");
	NWB.data.myChars[UnitName("player")].storedBuffs = {};
	tempStoredBuffs = {};
	NWB:recalcBuffTimers();
end

--Big thanks to this comment https://github.com/Stanzilla/WoWUIBugs/issues/47#issuecomment-710698976
local function GetCooldownLeft(start, duration)
	-- Before restarting the GetTime() will always be grater than [start]
	-- After the restart it is technically always bigger because of the 2^32 offset thing
	if (start < GetTime()) then
		local cdEndTime = start + duration;
		local cdLeftDuration = cdEndTime - GetTime();
		return cdLeftDuration;
	end
	local time = time();
	local startupTime = time - GetTime();
	-- just a simplification of: ((2^32) - (start * 1000)) / 1000
	local cdTime = (2 ^ 32) / 1000 - start;
	local cdStartTime = startupTime - cdTime;
	local cdEndTime = cdStartTime + duration;
	local cdLeftDuration = cdEndTime - time;
    return cdLeftDuration;
end

function NWB:recordChronoData(trade)
	local found;
	local GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots;
	local GetContainerItemCooldown = GetContainerItemCooldown or C_Container.GetContainerItemCooldown;
	local GetItemCooldown = GetItemCooldown or C_Container.GetItemCooldown;
	--GetItemCooldown is missing PTR.
	if (not GetItemCooldown) then
		return;
	end
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = Item:CreateFromBagAndSlot(bag, slot);
			if (item) then
				local itemID = item:GetItemID(item);
				local itemName = item:GetItemName(item);
				if (itemID and itemID == 184937) then
					found = true;
					local startTime, duration, isEnabled = GetContainerItemCooldown(bag, slot);
					if (startTime) then
						local endTime = GetCooldownLeft(startTime, duration) + GetServerTime();
						if (isEnabled == 1 and startTime > 0 and duration > 0) then
							NWB.data.myChars[UnitName("player")].chronoCooldown = endTime;
						end
					end
				end
			end
		end
	end
	if (not found) then
		local startTime, duration, isEnabled = GetItemCooldown(184937);
		--Why is startTime nil for some people since Ulduar patch? It should always be 0.
		--Possibly only happens during loading screens.
		if (startTime) then
			local endTime = GetCooldownLeft(startTime, duration) + GetServerTime();
			if (isEnabled == 1 and startTime > 0 and duration > 0) then
				NWB.data.myChars[UnitName("player")].chronoCooldown = endTime;
			end
		end
	end
	NWB.data.myChars[UnitName("player")].chronoCount = (GetItemCount(184937) or 0);
	if (trade) then
		NWB:recalcBuffListFrame();
	end
end

--Played time data received, update local cache.
NWB["tar"] = GetGuildInfo;
function NWB:timePlayedMsg(...)
	local totalPlayed = ...;
	--Update played cache for ticker when /played data received.
	if (totalPlayed > 0) then
		NWB.played = totalPlayed;
	end
	--Only set the total played seconds at time of a new buff drop we track.
	if (totalPlayed > 0 and NWB.currentTrackBuff ~= nil) then
		NWB.currentTrackBuff.playedCacheSetAt = totalPlayed;
		--NWB:recalcBuffTimers();
		NWB.currentTrackBuff = nil;
	end
	--Reregister the chat frame event after we're done.
	C_Timer.After(2, function()
		if (reregisterPlayedEvent) then
			NWB:registerTimePlayedMsg();
		end
	end)
	NWB:syncBuffsWithCurrentDuration();
	NWB:recalcBuffTimers();
end

--This only runs once at load time.
function NWB:setLayered()
	if (NWB.usRealms[NWB.realm] or NWB.euRealms[NWB.realm] or NWB.krRealms[NWB.realm] or NWB.twRealms[NWB.realm]
			or NWB.cnRealms[NWB.realm]) then
		NWB.isLayered = true;
	end
	--Layer all wrath realms for now.
	if (NWB.isWrath or NWB.isCata) then
		NWB.isLayered = true;
	end
	--Blanket enable season of mastery realms for now.
	if (C_Seasons and C_Seasons.HasActiveSeason()) then
		NWB.isLayered = true;
	end
	--Blanket enable hardcore realms for now.
	if (C_GameRules and C_GameRules.IsHardcoreActive()) then
		NWB.isLayered = true;
	end
end

function NWB:setLayerLimit()
	--if (fsdfsfs) then
	--	NWB.limitLayerCount = 2;
	--end
end

--Make sure warning msg values are correct for the current time left on each timer.
function NWB:timerCleanup()
	local types = {
		[1] = "rend",
		[2] = "ony",
		[3] = "nef",
		--[4] = "zan"
	};
	for k, v in pairs(types) do
		local offset = 0;
		if (NWB.isLayered) then
			for layer, value in NWB:pairsByKeys(NWB.data.layers) do
				if (v == "rend") then
					offset = NWB.rendCooldownTime;
					NWB:resetWarningTimers("rend", layer);
				elseif (v == "ony") then
					offset = NWB.onyCooldownTime;
					NWB:resetWarningTimers("ony", layer);
				elseif (v == "nef") then
					offset = NWB.nefCooldownTime;
					NWB:resetWarningTimers("nef", layer);
				--elseif (v == "zan") then
				--	offset = NWB.zanCooldownTime;
				--	NWB:resetWarningTimers("zan", layer);
				end
				--Clear warning timers that ended while we were offline or if NPC was killed since last buff.
				if (NWB.data.layers[layer][v .. "NpcDied"]
						and NWB.data.layers[layer][v .. "NpcDied"] > (GetServerTime() - NWB[v .. "CooldownTime"])) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
					NWB.data.layers[layer][v .. "10"] = nil;
					NWB.data.layers[layer][v .. "5"] = nil;
					NWB.data.layers[layer][v .. "1"] = nil;
					NWB.data.layers[layer][v .. "0"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 0) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
					NWB.data.layers[layer][v .. "10"] = nil;
					NWB.data.layers[layer][v .. "5"] = nil;
					NWB.data.layers[layer][v .. "1"] = nil;
					NWB.data.layers[layer][v .. "0"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 60) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
					NWB.data.layers[layer][v .. "10"] = nil;
					NWB.data.layers[layer][v .. "5"] = nil;
					NWB.data.layers[layer][v .. "1"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 300) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
					NWB.data.layers[layer][v .. "10"] = nil;
					NWB.data.layers[layer][v .. "5"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 600) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
					NWB.data.layers[layer][v .. "10"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 900) then
					NWB.data.layers[layer][v .. "30"] = nil;
					NWB.data.layers[layer][v .. "15"] = nil;
				elseif (NWB.data.layers[layer][v .. "Timer"]
						and ((NWB.data.layers[layer][v .. "Timer"] + offset) - GetServerTime()) < 1800) then
					NWB.data.layers[layer][v .. "30"] = nil;
				end
			end
		else
			if (v == "rend") then
				offset = NWB.rendCooldownTime;
				NWB:resetWarningTimers("rend");
			elseif (v == "ony") then
				offset = NWB.onyCooldownTime;
				NWB:resetWarningTimers("ony");
			elseif (v == "nef") then
				offset = NWB.nefCooldownTime;
				NWB:resetWarningTimers("nef");
			--elseif (v == "zan") then
			--	offset = NWB.zanCooldownTime;
			--	NWB:resetWarningTimers("zan");
			end
			--Clear warning timers that ended while we were offline or if NPC was killed since last buff.
			if (NWB.data[v .. "NpcDied"] and NWB.data[v .. "NpcDied"] > (GetServerTime() - NWB[v .. "CooldownTime"])) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
				NWB.data[v .. "10"] = nil;
				NWB.data[v .. "5"] = nil;
				NWB.data[v .. "1"] = nil;
				NWB.data[v .. "0"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 0) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
				NWB.data[v .. "10"] = nil;
				NWB.data[v .. "5"] = nil;
				NWB.data[v .. "1"] = nil;
				NWB.data[v .. "0"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 60) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
				NWB.data[v .. "10"] = nil;
				NWB.data[v .. "5"] = nil;
				NWB.data[v .. "1"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 300) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
				NWB.data[v .. "10"] = nil;
				NWB.data[v .. "5"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 600) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
				NWB.data[v .. "10"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 900) then
				NWB.data[v .. "30"] = nil;
				NWB.data[v .. "15"] = nil;
			elseif (((NWB.data[v .. "Timer"] + offset) - GetServerTime()) < 1800) then
				NWB.data[v .. "30"] = nil;
			end
		end
	end
	if (NWB.isTBC) then
		if (NWB.isLayered) then
			for layer, value in NWB:pairsByKeys(NWB.data.layers) do
				if (NWB.data.layers[layer]["terokTowers"] and tonumber(NWB.data.layers[layer]["terokTowers"])
						and NWB.data.layers[layer]["terokTowers"] - GetServerTime() > 900) then
					NWB.data.layers[layer]["terokTowers10"] = true;
				end
			end
		else
			if (NWB.data["terokTowers"] and tonumber(NWB.data["terokTowers"])
					and NWB.data["terokTowers"] - GetServerTime() > 900) then
				NWB.data["terokTowers10"] = true;
			end
		end
	end
	if (NWB.isWrath) then
		local wintergrasp = NWB:getWintergraspData();
		if (wintergrasp > 0 and wintergrasp - GetServerTime() > 900) then
		--if (NWB.data["wintergrasp"] and tonumber(NWB.data["wintergrasp"])
				--and NWB.data["wintergrasp"] - GetServerTime() > 900) then
			NWB.data["wintergrasp10"] = true;
		end
	end
end

--Reset and enable all warning msgs for specified timer.
function NWB:resetWarningTimers(type, layer)
	layer = NWB:mapLayerToParent(layer);
	if (NWB.isLayered and not NWB.data.layers[layer]) then
		return;
	end
	if (NWB.isLayered and layer) then
		NWB.data.layers[layer][type .. "30"] = true;
		NWB.data.layers[layer][type .. "15"] = true;
		NWB.data.layers[layer][type .. "10"] = true;
		NWB.data.layers[layer][type .. "5"] = true;
		NWB.data.layers[layer][type .. "1"] = true;
		NWB.data.layers[layer][type .. "0"] = true;
	else
		NWB.data[type .. "30"] = true;
		NWB.data[type .. "15"] = true;
		NWB.data[type .. "10"] = true;
		NWB.data[type .. "5"] = true;
		NWB.data[type .. "1"] = true;
		NWB.data[type .. "0"] = true;
	end
end

--Throddle by function name, delays event for non-vital info and catches any extras to avoid spaming bag funcs when mass looting etc.
local throddle = true;
NWB.currentThroddles = {};
function NWB:throddleEventByFunc(event, time, func, ...)
	if (throddle and NWB.currentThroddles[func] == nil) then
		--Must be false and not nil.
		NWB.currentThroddles[func] = ... or false;
		C_Timer.After(time, function()
			self[func](self, NWB.currentThroddles[func]);
			NWB.currentThroddles[func] = nil;
		end)
	elseif (not throddle) then
		self[func](...);
	end
end

function NWB:getTerokEndTime(terokTowers, terokTowersTime)
	--Can potentially just adjust the time when it's recorded instead and remove the timeSet sharing..
	--But this way makes it easier to adjust the offset with version updates if needed without wiping peoples timers and ignoring old versions.
	--Will see how this works out for a while before trying the above method.
	--local endTime = NWB.data.layers[layer]["terokTowers"] + NWB:round((((NWB.data.layers[layer]["terokTowers"]  - GetServerTime()) / 60) * terokOffset));
	--local endTime = timestamp + NWB:round((((timestamp  - GetServerTime()) / 60) * terokOffset));
	--return endTime;
	if (terokTowersTime) then
		--This worked fine when you're have a fresh timestamp by being in the zone or was just shared with.
		--But it doesn't work when you have a timestamp set a while ago because Blizzard creeps the timestamp forward.
		--local offset = math.floor((((terokTowers  - GetServerTime()) / 60) * terokOffset));
		--This should work no matter when you got the timestamp.
		local offset = math.floor(((terokTowers - terokTowersTime) / 60) * terokOffset)
		local endTime = terokTowers + offset;
		return endTime;
	else
		return terokTowers;
	end
end

function NWB:getWintergraspEndTime(wintergrasp, wintergraspTime)
	--We'll see if wintergrasp needs adjustment like terokkar towers.
	return wintergrasp;
end

function NWB:getWintergraspData(layer) --local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
	local wintergrasp, wintergraspTime, wintergraspFaction = 0, 0, 0;
	if (NWB.data.wintergrasp) then
		wintergrasp = NWB.data.wintergrasp;
	end
	if (NWB.data.wintergraspTime) then
		wintergraspTime = NWB.data.wintergraspTime;
	end
	if (NWB.data.wintergraspFaction) then
		wintergraspFaction = NWB.data.wintergraspFaction;
	end
	if (wintergrasp < GetServerTime() - NWB.wgExpire) then
		return 0, 0, 0;
	end
	local isCached;
	--It's not always a 3 hour cycle, sometime it skips, sometimes it's been even 12 hours.
	--So we can't have a reliable time from the clock, but if there's no timer then fallback to clock.
	--if (wintergrasp == 0) then
		--No timer, calc from clock.
		--Will maybe add later but really not needed if the rest is working properly.
	--end
	if (wintergrasp > 0) then
		if (wintergrasp < GetServerTime()) then
			--Old timer, calc forward in 3 hour increments.
			--Divide seconds elapsed since our static timestamp in the past by the cycle time (3 hours).
			--Get the floor of secondsSinceWintergrasp / cycle time
			--Get the floor of that result (which would be last reset if multipled by cycle time) then add 1 for next reset, then multiply by cycle time.
			--This can be off by 1 hour twice a year during the small window of DST changeover.
			wintergrasp = wintergrasp + ((math.floor((GetServerTime() - wintergrasp) / 10800) + 1) * 10800);
			--If it's in the first 15mins just expired then show it as expired, give last spawn instead of next.
			if (wintergrasp - GetServerTime() > 9900) then
				wintergrasp = wintergrasp - 10800;
			end
			isCached = true;
		end
	end
	if (wintergrasp > 0 and wintergrasp - GetServerTime() > 660) then
		NWB.data["wintergrasp10"] = true;
	end
	--Round to the hour.
	local diff = wintergrasp % 3600;
	if (diff < 61 and diff > 0) then
		wintergrasp = wintergrasp - diff;
	end
	return wintergrasp, wintergraspTime, wintergraspFaction, isCached;
end

--Get how far away our zoneid is from the capital city on this layer.
function NWB:getLayerOffset(layerID, mapID, zoneID)
	--Using this for checking if a zone is mapped right, close to it's capital city ID.
	--If it's far away then it's likely been mapped to the wrong layer or there's been a zone crash.
	local offset;
	if (not NWB.data.layers or not next(NWB.data.layers)) then
		return;
	end
	local data = NWB.data.layers[layerID];
	if (not data) then
		return;
	end
	--Look via mapID if we already have a zoneID mapped.
	if (mapID and layerID) then
		for k, v in pairs(data.layerMap) do
			if (v == mapID) then
				if (k > layerID) then
					offset = k - layerID;
				else
					offset = layerID - k;
				end
				return offset;
			end
		end
	end
	--Look via zoneID if this is an attempt to map.
	if (zoneID and layerID) then
		if (zoneID > layerID) then
			offset = zoneID - layerID;
		else
			offset = layerID - zoneID;
		end
		return offset;
	end
	--If the zone isn't mapped yet we must be trying to map it.
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
--f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("CHAT_MSG_MONSTER_YELL");
f:RegisterEvent("CHAT_MSG_MONSTER_SAY");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("TIME_PLAYED_MSG");
f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("CHAT_MSG_WHISPER");
f:RegisterEvent("CHAT_MSG_BN_WHISPER");
f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("CHAT_MSG_ADDON");
f:RegisterEvent("GUILD_ROSTER_UPDATE");
f:RegisterEvent("PLAYER_REGEN_ENABLED");
f:RegisterEvent("UNIT_SPELLCAST_START");
f:RegisterEvent("UNIT_SPELLCAST_STOP");
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:RegisterEvent("QUEST_TURNED_IN");
f:RegisterEvent("BAG_UPDATE_DELAYED");
f:RegisterEvent("UNIT_DAMAGE");
f:RegisterEvent("PLAYER_UPDATE_RESTING");
local doLogon = true;
local mc = "myChars";
local storeBuffsTimer;
local skipBagThroddle;
local logonYell = 0;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		--Testing this here instead of PLAYER_ENTERING_WORLD, maybe it fires slightly faster enough to stop duplicate msgs.
		NWB.loadTime = GetServerTime();
		--if (IsInGuild()) then
			--C_ChatInfo.SendAddonMessage(NWB.commPrefix, NWB.serializer:Serialize("ping " .. version), "GUILD");
		--end
		NWB:requestData("GUILD", nil, "ALERT");
		self:RegisterEvent("CHAT_MSG_GUILD");
		C_Timer.After(30, function()
			NWB:syncBuffsWithCurrentDuration();
		end)
	elseif (event == "PLAYER_ENTERING_WORLD") then
		NWB:trackUnitDamage();
		NWB.db.global[NWB.realm][NWB.faction].myChars[UnitName("player")].resting = IsResting();
		C_Timer.After(1, function()
			NWB.db.global[NWB.realm][NWB.faction].myChars[UnitName("player")].resting = IsResting();
		end)
		C_Timer.After(5, function()
			NWB.db.global[NWB.realm][NWB.faction].myChars[UnitName("player")].resting = IsResting();
		end)
		if (doLogon) then
			NWB:loadSODPhases();
			NWB:refreshMinimapLayerFrame();
			NWB:refreshOverlay();
			--Refresh map stuff after login, loading them at initialize creates a bug with them not showing up until you move sometimes.
			C_Timer.After(5, function()
				NWB:refreshFelwoodMarkers();
				NWB:refreshWorldbuffMarkers();
			end)
			GuildRoster();
			if (NWB.db.global.logonPrint) then
				C_Timer.After(10, function()
					GuildRoster(); --Attempting to fix slow guild roster update at logon.
					NWB:printBuffTimers(true);
					--If logon timers are enabled we'll check this during the printBuffTimers() func instgead..
					--[[C_Timer.After(1, function()
						NWB:checkDmfBuffReset();
					end)]]
				end);
			else
				--If logon timers are disabled still check dmf buff reset.
				C_Timer.After(10, function()
					NWB:checkDmfBuffReset();
				end);
			end
			--First request after logon is high prio so gets sent right away, need to register addon users asap so no duplicate guild msgs.
			--NWB:requestData("GUILD", nil, "ALERT");
			C_Timer.After(5, function()
				--Only request played data at logon if we didn't get it already for some reason.
				if (not gotPlayedData) then
					gotPlayedData = true;
					if (NWB:isTimePlayedMsgRegistered()) then
						reregisterPlayedEvent = true;
						NWB:unregisterTimePlayedMsg();
					end
					RequestTimePlayed();
				end
			end)
			C_Timer.After(30, function()
				if (GetTime() - logonYell > 30) then
					--Ghost check, no need to spam addon comms when a 40 man raid wipes.
					if (not UnitIsGhost("player") and GetTime() - logonYell > 30) then
						if (doLogon or NWB.isClassic) then
							--Probably no need for every player to share via yell at logon, change to if we came from songflowers or 50% chance.
							if (NWB.data.lastZone == 1448 or math.random(1, 100) <= yellPercent or not NWB:isCapitalCity()) then
								NWB:sendData("YELL");
							end
						end
					end
					if (logonYell == 0) then
						logonYell = GetTime();
					end
				end
			end)
			doLogon = nil;
		else
			local _, _, _, _, _, _, _, instanceID = GetInstanceInfo();
			--These only need to be classic era bgs, for buff helper purposes.
			if (instanceID == 489 or instanceID == 529 or instanceID == 30 or instanceID == 566) then
				NWB:enteredBattleground();
			end
			C_Timer.After(2, function()
				--Ghost check, no need to spam addon comms when a 40 man raid wipes.
				if (not UnitIsGhost("player") and GetTime() - logonYell > 60) then
					if (NWB.data.lastZone == 1448 or math.random(1, 100) <= yellPercent or not NWB:isCapitalCity()) then
						NWB:sendData("YELL");
					end
				end
				if (logonYell == 0) then
					logonYell = GetTime();
				end
			end)
		end
	--elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	NWB:combatLogEventUnfiltered(...);
	--elseif (event == "CHAT_MSG_MONSTER_YELL") then
	--	NWB:monsterYell(...);
	--elseif (event == "CHAT_MSG_MONSTER_SAY") then
	--	NWB:monsterSay(...);
	elseif (event == "GROUP_JOINED") then
		--Skip party sync close to logon, no need to fill up the addon comm bandwidth further.
		--This event fires at logon if grouped already.
		if (GetServerTime() - NWB.loadTime > 60) then
			C_Timer.After(5, function()
				if (UnitInBattleground("player") or NWB:isInArena()) then
					return;
				end
				if (IsInRaid()) then
	  				NWB:sendData("RAID");
	  			elseif (IsInGroup()) then
	  				NWB:sendData("PARTY");
	  			end
	  		end)
  		end
  	elseif (event == "CHAT_MSG_GUILD") then
  		NWB:chatMsgGuild(...);
  	elseif (event == "QUEST_TURNED_IN") then
  		NWB:questTurnedIn(...);
	elseif (event == "TIME_PLAYED_MSG") then
		gotPlayedData = true;
		NWB:timePlayedMsg(...);
	elseif (event == "CHAT_MSG_WHISPER") then
		local _, name = ...;
		NWB.lastWhisper = name;
		NWB.lastWhisperType = "whisper";
	elseif (event == "CHAT_MSG_BN_WHISPER") then
		local _, name, _, _, _, _, _, _, _, _, _, _, presenceID = ...;
		NWB.lastWhisper = presenceID;
		NWB.lastWhisperType = "bnet";
	elseif (event == "CHAT_MSG_SYSTEM") then
		local text = ...;
		local who = string.match(text, string.gsub(ERR_GUILD_JOIN_S, "%%s", "(.+)"));
		if (who == UnitName("player")) then
			--Register ourself to other addon users when joining a guild.
			NWB:requestData("GUILD", nil, "ALERT");
		end
		--Request roster update when guild member goes online or offline, this seems to be delayed, see if this helps?
		if (string.match(text, string.gsub(ERR_FRIEND_ONLINE_SS, "|H.+|h", "(.+)")) or string.match(text, string.gsub(ERR_FRIEND_OFFLINE_S, "%%s", "(.+)"))) then
			GuildRoster();
		end
	elseif (event == "CHAT_MSG_ADDON") then
		local commPrefix, string, distribution, sender = ...;
		if (commPrefix == NWB.commPrefix and distribution == "GUILD") then
			local normalizedWho = string.gsub(sender, " ", "");
			normalizedWho = string.gsub(normalizedWho, "'", "");
			if (not string.match(normalizedWho, "-")) then
				--Sometimes it comes through without realm in classic?
				normalizedWho = normalizedWho .. "-" .. GetNormalizedRealmName();
			end
			if (not NWB.hasAddon[normalizedWho]) then
				NWB.hasAddon[normalizedWho] = "0";
			end
		end
	elseif (event == "GUILD_ROSTER_UPDATE") then
		NWB:checkGuildMasterSetting("set");
	elseif (event == "PLAYER_REGEN_ENABLED") then
		NWB:leftCombat();
	elseif (event == "UNIT_SPELLCAST_START") then
		local unit, GUID, spellID = ...;
		if (unit == "player" and spellID == 349858) then
			NWB:trackUnitDamage();
			NWB:storeBuffs();
			--Run another check of buffs every second before the cast ends.
			--This is to check for any new buffs that landed during the chronoboon cast.
			storeBuffsTimer = C_Timer.NewTicker(1, function()
				NWB:storeBuffs();
			end, 4)
		end
	elseif (event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_STOP") then
		local unit, GUID, spellID = ...;
		if (unit == "player" and spellID == 349858) then
			NWB:clearTempStoredBuffs();
			if (storeBuffsTimer) then
				storeBuffsTimer:Cancel();
			end
		end
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		local unit, GUID, spellID = ...;
		if (unit == "player") then
			if (spellID == 1856 or spellID == 1857) then
				NWB:doVanish();
			elseif (spellID == 5384) then
				NWB:doFeign();
			elseif (spellID == 349858) then
				NWB:recordStoredBuffs();
				--Cancel this timer incase haste buffs can be used on chronoboon and it goes off before this timer ends.
				if (storeBuffsTimer) then
					storeBuffsTimer:Cancel();
				end
				NWB:syncBuffsWithCurrentDuration();
				C_Timer.After(2, function()
					NWB:syncBuffsWithCurrentDuration();
				end)
			elseif (spellID == 349863) then
				if (not NWB.isClassic) then
					if (NWB.data.myChars[UnitName("player")].storedBuffs) then
						for k, v in pairs(NWB.data.myChars[UnitName("player")].storedBuffs) do
							if (k == L["Sayge's Dark Fortune of Damage"]) then
								unitDamageFrame:RegisterEvent("UNIT_DAMAGE");
								break;
							end
						end
					end
				end
				chronoRestoreUsed = GetTime();
				NWB:dmfChronoCheck();
				NWB:clearStoredBuffs();
				NWB:syncBuffsWithCurrentDuration();
				C_Timer.After(2, function()
					NWB:syncBuffsWithCurrentDuration();
				end)
			--[[elseif (spellID == 349863) then
				local me = UnitName("player");
				NWB.lastUnboon[me] = GetTime();
				NWB:debug("I unbooned");]]
			end
		end
	elseif (event == "BAG_UPDATE_DELAYED") then
		if (skipBagThroddle) then
			NWB:recordChronoData(true);
			skipBagThroddle = nil;
		else
			NWB:throddleEventByFunc(event, 2, "recordChronoData", ...);
		end
	elseif (event == "UI_INFO_MESSAGE") then
		local type, msg = ...;
		if (msg == ERR_TRADE_COMPLETE) then
			--We want to update the /buffs frame instantly after trades so no throddle.
			skipBagThroddle = true;
		end
	elseif (event == "UNIT_DAMAGE") then
		local unit = ...;
		if (unit == "player") then
			C_Timer.After(1, function()
				NWB:trackUnitDamage();
			end)
		end
	elseif (event == "PLAYER_UPDATE_RESTING") then
		NWB.db.global[NWB.realm][NWB.faction].myChars[UnitName("player")].resting = IsResting();
	end
end)

--Flight paths.
local doCheckLeaveFlghtPath = false;
hooksecurefunc("TakeTaxiNode", function(...)
	doCheckLeaveFlghtPath = true;
    --Give it a few seconds to get on the taxi.
    C_Timer.After(5, function()
		NWB.checkLeaveFlghtPath();
		--Wipe felwood songflower detected players when leaving.
		NWB.detectedPlayers = {};
	end)
	if (NWB.data.lastZone == 1448 or math.random(1, 100) <= yellPercent or not NWB:isCapitalCity()) then
		NWB:sendData("YELL");
	end
end)

--Loop this func till flight path is left.
function NWB.checkLeaveFlghtPath()
    local isOnFlightPath = UnitOnTaxi("player");
    if (not isOnFlightPath) then
    	doCheckLeaveFlghtPath = false;
    	--Send data to people close when dismounting a flightpath.
    	if (NWB.data.lastZone == 1448 or math.random(1, 100) <= yellPercent or not NWB:isCapitalCity()) then
    		NWB:sendData("YELL");
    	end
    end
    if (doCheckLeaveFlghtPath) then
    	C_Timer.After(2, function()
			NWB.checkLeaveFlghtPath();
		end)
	end
end

function NWB:countDebuffs()
	local limit = 16;
	if (NWB.isTBC) then
		limit = 40;
	end
	local count = 0;
	for i = 1, limit do
		local debuff = UnitDebuff("player", i);
		if (debuff) then
			count = count + 1;
		end
	end
	if (count > limit - 1) then
		local dmfCooldown, noMsgs = NWB:getDmfCooldown();
		if (NWB.isDmfUp and dmfCooldown > 0 and not noMsgs) then
			NWB:print(L["dmfBuffReset"]);
			if (NWB.data.myChars[UnitName("player")].buffs) then
				for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
					if (v.type == "dmf") then
						NWB.data.myChars[UnitName("player")].buffs[k].noMsgs = true;
						NWB.data.myChars[UnitName("player")].dmfCooldownNoMsgs = true;
					end
				end
			end
		elseif (NWB.isDmfUp and (lastDmfTick + 7200) > 0) then
			--Backup if buff gotten with older version.
			NWB:print(L["dmfBuffReset"]);
			if (NWB.data.myChars[UnitName("player")].buffs) then
				for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
					if (v.type == "dmf") then
						NWB.data.myChars[UnitName("player")].buffs[k].noMsgs = true;
						NWB.data.myChars[UnitName("player")].dmfCooldownNoMsgs = true;
					end
				end
			end
		end
		lastDmfTick = -99999;
	end
end

--Convert seconds to a readable format.
--[[function NWB:getTimeString(seconds, countOnly, short)
	local timecalc = 0;
	if (countOnly) then
		timecalc = seconds;
	else
		timecalc = seconds - time();
	end
	local d = math.floor((timecalc % (86400*365)) / 86400);
	local h = math.floor((timecalc % 86400) / 3600);
	local m = math.floor((timecalc % 3600) / 60);
	local s = math.floor((timecalc % 60));
	local space = "";
	if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
		space = " ";
	end
	if (short) then
		if (d == 1 and h == 0) then
			return d .. L["dayShort"];
		elseif (d == 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (d > 1 and h == 0) then
			return d .. L["dayShort"];
		elseif (d > 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (h == 1 and m == 0) then
			return h .. L["hourShort"];
		elseif (h == 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (h > 1 and m == 0) then
			return h .. L["hourShort"];
		elseif (h > 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (m == 1 and s == 0) then
			return m .. L["minuteShort"];
		elseif (m == 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		if (m > 1 and s == 0) then
			return m .. L["minuteShort"];
		elseif (m > 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		--If no matches it must be seconds only.
		return s .. L["secondShort"];
	else
		if (d == 1 and h == 0) then
			return d .. " " .. L["day"];
		elseif (d == 1) then
			return d .. " " .. L["day"] .. " " .. h .. " " .. L["hours"];
		end
		if (d > 1 and h == 0) then
			return d .. " " .. L["days"];
		elseif (d > 1) then
			return d .. " " .. L["days"] .. " " .. h .. " " .. L["hours"];
		end
		if (h == 1 and m == 0) then
			return h .. " " .. L["hour"];
		elseif (h == 1) then
			return h .. " " .. L["hour"] .. " " .. m .. " " .. L["minutes"];
		end
		if (h > 1 and m == 0) then
			return h .. " " .. L["hours"];
		elseif (h > 1) then
			return h .. " " .. L["hours"] .. " " .. m .. " " .. L["minutes"];
		end
		if (m == 1 and s == 0) then
			return m .. " " .. L["minute"];
		elseif (m == 1) then
			return m .. " " .. L["minute"] .. " " .. s .. " " .. L["seconds"];
		end
		if (m > 1 and s == 0) then
			return m .. " " .. L["minutes"];
		elseif (m > 1) then
			return m .. " " .. L["minutes"] .. " " .. s .. " " .. L["seconds"];
		end
		--If no matches it must be seconds only.
		return s .. " " .. L["seconds"];
	end
end]]

--Convert seconds to a readable format.
function NWB:getTimeString(seconds, countOnly, type, space, firstOnly)
	local timecalc = 0;
	if (countOnly) then
		timecalc = seconds;
	else
		timecalc = seconds - time();
	end
	local d = math.floor((timecalc % (86400*365)) / 86400);
	local h = math.floor((timecalc % 86400) / 3600);
	local m = math.floor((timecalc % 3600) / 60);
	local s = math.floor((timecalc % 60));
	if (space or LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
		space = " ";
	else
		space = "";
	end
	if (type == "short") then
		if (d == 1 and (h == 0 or firstOnly)) then
			return d .. L["dayShort"];
		elseif (d == 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			return d .. L["dayShort"];
		elseif (d > 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			return h .. L["hourShort"];
		elseif (h == 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			return h .. L["hourShort"];
		elseif (h > 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. L["minuteShort"];
		elseif (m == 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. L["minuteShort"];
		elseif (m > 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		--If no matches it must be seconds only.
		return s .. L["secondShort"];
	elseif (type == "medium") then
		if (d == 1 and (h == 0 or firstOnly)) then
			return d .. " " .. L["dayMedium"];
		elseif (d == 1) then
			return d .. " " .. L["dayMedium"] .. " " .. h .. " " .. L["hoursMedium"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			return d .. " " .. L["daysMedium"];
		elseif (d > 1) then
			return d .. " " .. L["daysMedium"] .. " " .. h .. " " .. L["hoursMedium"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			return h .. " " .. L["hourMedium"];
		elseif (h == 1) then
			return h .. " " .. L["hourMedium"] .. " " .. m .. " " .. L["minutesMedium"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			return h .. " " .. L["hoursMedium"];
		elseif (h > 1) then
			return h .. " " .. L["hoursMedium"] .. " " .. m .. " " .. L["minutesMedium"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minuteMedium"];
		elseif (m == 1) then
			return m .. " " .. L["minuteMedium"] .. " " .. s .. " " .. L["secondsMedium"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minutesMedium"];
		elseif (m > 1) then
			return m .. " " .. L["minutesMedium"] .. " " .. s .. " " .. L["secondsMedium"];
		end
		--If no matches it must be seconds only.
		return s .. " " .. L["secondsMedium"];
	else
		if (d == 1 and (h == 0 or firstOnly)) then
			return d .. " " .. L["day"];
		elseif (d == 1) then
			return d .. " " .. L["day"] .. " " .. h .. " " .. L["hours"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			return d .. " " .. L["days"];
		elseif (d > 1) then
			return d .. " " .. L["days"] .. " " .. h .. " " .. L["hours"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			return h .. " " .. L["hour"];
		elseif (h == 1) then
			return h .. " " .. L["hour"] .. " " .. m .. " " .. L["minutes"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			return h .. " " .. L["hours"];
		elseif (h > 1) then
			return h .. " " .. L["hours"] .. " " .. m .. " " .. L["minutes"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minute"];
		elseif (m == 1) then
			return m .. " " .. L["minute"] .. " " .. s .. " " .. L["seconds"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minutes"];
		elseif (m > 1) then
			return m .. " " .. L["minutes"] .. " " .. s .. " " .. L["seconds"];
		end
		--If no matches it must be seconds only.
		return s .. " " .. L["seconds"];
	end
end

--Returns am/pm and lt/st format.
--[[function NWB:getTimeFormat(timeStamp, fullDate)
	if (NWB.db.global.timeStampZone == "server") then
		--This is ugly and shouldn't work, and probably doesn't work on some time difference.
		--Need a better solution but all I can get from the wow client in server time is hour:mins, not date or full timestamp.
		local data = date("*t", GetServerTime());
		local localHour, localMin = data.hour, data.min;
		local serverHour, serverMin = GetGameTime();
		local localSecs = (localMin*60) + ((localHour*60)*60);
		local serverSecs = (serverMin*60) + ((serverHour*60)*60);
		local diff = localSecs - serverSecs;
		--local diff = difftime(localSecs - serverSecs);
		local serverTime = 0;
		--if (localHour < serverHour) then
		--	timeStamp = timeStamp - (diff + 86400);
		--else
			timeStamp = timeStamp - diff;
		--end
	end
	if (NWB.db.global.timeStampFormat == 12) then
		--Strip leading zero and convert to lowercase am/pm.
		if (fullDate) then
			return date("%a %b %d", timeStamp) .. " " .. gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "");
		else
			return gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "");
		end
	else
		if (fullDate) then
			local dateFormat = NWB:getRegionTimeFormat();
			return date(dateFormat .. " %H:%M:%S", timeStamp);
		else
		 return date("%H:%M:%S", timeStamp);
		end
	end
end]]

--Returns am/pm and lt/st format.
function NWB:getTimeFormat(timeStamp, fullDate, abbreviate, forceServerTime, suffixST)
	local suffix = "";
	if (suffixST) then
		suffix = " " .. L["serverTime"];
	end
	if (NWB.db.global.timeStampZone == "server" or forceServerTime) then
		--This is ugly and shouldn't work, and probably doesn't work on some time difference.
		--Need a better solution but all I can get from the wow client in server time is hour:mins, not date or full timestamp.
		local data = date("*t", GetServerTime());
		local localHour, localMin = data.hour, data.min;
		local serverHour, serverMin = GetGameTime();
		local localSecs = (localMin*60) + ((localHour*60)*60);
		local serverSecs = (serverMin*60) + ((serverHour*60)*60);
		local diff = localSecs - serverSecs;
		--local diff = difftime(localSecs - serverSecs);
		local serverTime = 0;
		--if (localHour < serverHour) then
		--	timeStamp = timeStamp - (diff + 86400);
		--else
			timeStamp = timeStamp - diff;
		--end
	end
	if (NWB.db.global.timeStampFormat == 12) then
		--Strip leading zero and convert to lowercase am/pm.
		if (fullDate) then
			if (abbreviate) then
				local string = date("%a %b %d", timeStamp);
				if (date("%x", timeStamp) == date("%x", GetServerTime())) then
					string = "Today";
				elseif (date("%x", timeStamp) == date("%x", GetServerTime() - 86400)) then
					string = "Yesterday";
				end
				return string .. " " .. gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "") .. suffix;
			else
				return date("%a %b %d", timeStamp) .. " " .. gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "") .. suffix;
			end
		else
			--if (GetLocale() == "en")
			return gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "") .. suffix;
		end
	else
		if (fullDate) then
			local dateFormat = NWB:getRegionTimeFormat();
			return date(dateFormat .. " %H:%M:%S", timeStamp) .. suffix;
		else
		 return date("%H:%M:%S", timeStamp) .. suffix;
		end
	end
end

--Date 24h string format based on region, won't be 100% accurate but better than %x returning US format for every region like it does now.
function NWB:getRegionTimeFormat()
	local dateFormat = "%x";
	local region = NWB:GetCurrentRegion();
	if (NWB.realm == "Arugal" or NWB.realm == "Felstriker" or NWB.realm == "Remulos" or NWB.realm == "Yojamba") then
		--OCE
		dateFormat = "%d/%m/%y";
	elseif (NWB.realm == "Sulthraze" or NWB.realm == "Loatheb") then
		--Brazil/Latin America.
		dateFormat = "%d/%m/%y";
	elseif (region == 1) then
		--US.
		dateFormat = "%m/%d/%y";
	elseif (region == 2 or region == 4 or region == 5) then
		--Korea, Taiwan, Chinda all same format.
		dateFormat = "%y/%m/%d";
	elseif (region == 3) then
		--EU.
		dateFormat = "%d/%m/%y";
	end
	return dateFormat;
end

--Add new line every count chars.
function NWB:addNewLineChars(text, count)
	if (not count) then
		count = 45;
	end
	local parts = {string.split(" ", text)};
	local ret = "";
	local temp = "";
	for k, v in ipairs(parts) do
		if (string.len(temp) > count) then
			ret = ret .. v .. "\n";
			temp = "";
		else
			ret = ret .. v .. " ";
			temp = temp .. v .. " ";
		end
	end
	return ret;
end

--Get which layer has the shortest timer that will end first checking all buffs.
function NWB:getShortestTimerLayer(type)
	local timers = {};
	if (type == "city") then
		timers["rendTimer"] = NWB.rendCooldownTime;
		timers["onyTimer"] = NWB.onyCooldownTime;
		timers["nefTimer"] = NWB.nefCooldownTime;
	end
	local count, lowest = 0, 99999999999;
	local lowestLayerID, lowestLayerNum = 0, 0;
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		for kk, vv in pairs(timers) do
			local timeLeft = (NWB.data.layers[k][kk] + vv) - GetServerTime();
			if (timeLeft < lowest) then
				lowest = timeLeft;
				lowestLayerID = k;
				lowestLayerNum = count;
			end
		end
	end
	return lowestLayerID, lowestLayerNum;
end

--Get which layer has the shortest timer that will end first for a specific buff type.
function NWB:getShortestTimerLayerBuff(type)
	local count, lowest = 0, 99999999999;
	local lowestLayerID, lowestLayerNum = 0, 0;
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		if (v[type .. "Timer"]) then
			local timeLeft = (v[type .. "Timer"] + NWB[type .. "CooldownTime"]) - GetServerTime();
			if (timeLeft < lowest) then
				lowest = timeLeft;
				lowestLayerID = k;
				lowestLayerNum = count;
			end
		end
	end
	return lowestLayerID, lowestLayerNum;
end

function NWB:isInArena()
	--Check if the func exists for classic.
	if (IsActiveBattlefieldArena and IsActiveBattlefieldArena()) then
		return true;
	end
end

local lastFlash = 0;
local flashThroddles = {};
function NWB:startFlash(flashType, type)
	if (not NWB:checkEventStatus("startFlash", type)) then
		return;
	end
	if (not NWB.db.global.flashOnlyInCity or NWB:isCapitalCityAction(type)) then
		if (not NWB.isClassic and (NWB.db.global.disableFlashAllLevels
			or (UnitLevel("player") > NWB.maxBuffLevel and NWB.db.global.disableFlashAboveMaxBuffLevel))) then
			return;
		end
		if (NWB.db.global[flashType]) then
			if (not flashThroddles[type] or GetServerTime() - flashThroddles[type] > NWB.buffDropSpamCooldown) then
				if (lastFlash < (GetServerTime() - 4)) then
					FlashClientIcon();
					lastFlash = GetServerTime();
					flashThroddles[type] = GetServerTime();
				end
			end
		end
	end
end

function NWB:playSound(sound, type)
	if (not NWB.isClassic and (NWB.db.global.disableSoundsAllLevels
		or (UnitLevel("player") > NWB.maxBuffLevel and NWB.db.global.disableSoundsAboveMaxBuffLevel))
		and sound ~= "soundsDispelsMine" and sound ~= "soundsDispelsAll") then
		return;
	end
	if (NWB.db.global.disableAllSounds) then
		return;
	end
	if (IsInInstance() and NWB.db.global.soundsDisableInInstances) then
		return;
	end
	if ((UnitInBattleground("player") or NWB:isInArena()) and NWB.db.global.soundsDisableInBattlegrounds) then
		return;
	end
	if (not NWB:checkEventStatus("playSound", type, sound)) then
		return;
	end
	if (NWB.db.global.soundOnlyInCity and (type == "rend" or type == "ony" or type == "nef" or type == "zan" or type == "timer")) then
		local play;
		local _, _, zone = NWB:GetPlayerZonePosition();
		local subZone = GetSubZoneText();
		if (zone == 1453 and NWB.faction == "Alliance" and (type == "ony" or type == "nef" or type == "timer")) then
			play = true;
		elseif (zone == 1454 and NWB.faction == "Horde" and (type == "ony" or type == "nef" or type == "rend" or type == "timer")) then
			play = true;
		elseif (zone == 1413 and subZone == POSTMASTER_LETTER_BARRENS_MYTHIC and (type == "ony" or type == "nef"
				or type == "rend" or type == "timer")) then
			play = true;
		elseif ((zone == 1434 or zone == 1443 or zone == 1454 or zone == 1413) and type == "zan" or type == "timer") then
			play = true;
		end
		if (not play) then
			return;
		end
	end
	if (NWB.db.global[sound] and NWB.db.global[sound] ~= "None") then
		if (sound == "soundsRendDrop" and NWB.db.global.soundsRendDrop == "NWB - Rend Voice") then
			PlaySoundFile("Interface\\AddOns\\NovaWorldBuffs\\Media\\RendDropped.ogg", "Master");
		elseif (sound == "soundsOnyDrop" and NWB.db.global.soundsOnyDrop == "NWB - Ony Voice") then
			PlaySoundFile("Interface\\AddOns\\NovaWorldBuffs\\Media\\OnyxiaDropped.ogg", "Master");
		elseif (sound == "soundsNefDrop" and NWB.db.global.soundsOnyDrop == "NWB - Nef Voice") then
			PlaySoundFile("Interface\\AddOns\\NovaWorldBuffs\\Media\\NefarianDropped.ogg", "Master");
		elseif (sound == "soundsNefDrop" and NWB.db.global.soundsNefDrop == "NWB - Ony Voice") then
			PlaySoundFile("Interface\\AddOns\\NovaWorldBuffs\\Media\\OnyxiaDropped.ogg", "Master");
		elseif (sound == "soundsZanDrop" and NWB.db.global.soundsZanDrop == "NWB - Zan Voice") then
			PlaySoundFile("Interface\\AddOns\\NovaWorldBuffs\\Media\\ZandalarDropped.ogg", "Master");
		else
			local soundFile = NWB.LSM:Fetch("sound", NWB.db.global[sound]);
			PlaySoundFile(soundFile, "Master");
		end
	end
end

function NWB:middleScreenMsg(type, msg, colorTable, time)
	if (not NWB.isClassic and (NWB.db.global.disableMiddleAllLevels
		or (UnitLevel("player") > NWB.maxBuffLevel and NWB.db.global.disableMiddleAboveMaxBuffLevel))) then
		return;
	end
	if (not colorTable) then
		colorTable = {r = self.db.global.middleColorR, g = self.db.global.middleColorG, 
				b = self.db.global.middleColorB, id = 41, sticky = 0};
	end
	RaidNotice_AddMessage(RaidWarningFrame, NWB:stripColors(msg), colorTable, time);
end

function NWB:middleScreenMsgTBC(type, msg, colorTable, time)
	if (InCombatLockdown() and NWB.db.global.middleHideCombat) then
		return;
	end
	local inInstance, instanceType = IsInInstance();
	if (inInstance and instanceType == "raid" and NWB.db.global.middleHideRaid) then
		return;
	end
	if ((UnitInBattleground("player") or NWB:isInArena()) and NWB.db.global.middleHideBattlegrounds) then
		return;
	end
	if (not colorTable) then
		colorTable = {r = self.db.global.middleColorR, g = self.db.global.middleColorG, 
				b = self.db.global.middleColorB, id = 41, sticky = 0};
	end
	RaidNotice_AddMessage(RaidWarningFrame, NWB:stripColors(msg), colorTable, time);
end

function NWB:addBackdrop(string)
	if (BackdropTemplateMixin) then
		if (string) then
			--Inherit backdrop first so our frames points etc don't get overwritten.
			return "BackdropTemplate," .. string;
		else
			return "BackdropTemplate";
		end
	else
		return string;
	end
end

--Accepts both types of RGB.
function NWB:RGBToHex(r, g, b)
	r = tonumber(r);
	g = tonumber(g);
	b = tonumber(b);
	--Check if whole numbers.
	if (r == math.floor(r) and g == math.floor(g) and b == math.floor(b)
			and (r> 1 or g > 1 or b > 1)) then
		r = r <= 255 and r >= 0 and r or 0;
		g = g <= 255 and g >= 0 and g or 0;
		b = b <= 255 and b >= 0 and b or 0;
		return string.format("%02x%02x%02x", r, g, b);
	else
		return string.format("%02x%02x%02x", r*255, g*255, b*255);
	end
end

function NWB:round(num, numDecimalPlaces)
	if (not num or not tonumber(num)) then
		return;
	end
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

--English buff names, we check both english and locale names for buff durations just to be sure in untested locales.
local englishBuffs = {
	[0] = "NoNe",
	[1] = "Warchief's Blessing",
	[2] = "Rallying Cry of the Dragonslayer",
	[3] = "Songflower Serenade",
	[4] = "Spirit of Zandalar"
}

--Get seconds left on a buff by name.
function NWB:getBuffDuration(buff, englishID) --/dump NWB:getBuffDuration("Fel Armor", 1)
	for i = 1, 32 do
		local name, _, _, _, _, expirationTime = UnitBuff("player", i);
		if ((name and name == buff) or (englishID and name == englishBuffs[englishID])) then
			return expirationTime - GetTime();
		end
	end
	return 0;
end

--Check if player is in guild, accepts full realm name and normalized.
function NWB:isPlayerInGuild(who, onlineOnly)
	if (not IsInGuild()) then
		return;
	end
	GuildRoster();
	local numTotalMembers = GetNumGuildMembers();
	local normalizedWho = string.gsub(who, " ", "");
	normalizedWho = string.gsub(normalizedWho, "'", "");
	local me = UnitName("player") .. "-" .. GetRealmName();
	local normalizedMe = UnitName("player") .. "-" .. GetNormalizedRealmName();
	if (who == me or who == normalizedMe) then
		return true;
	end
	for i = 1, numTotalMembers do
		local name, _, _, _, _, _, _, _, online, _, _, _, _, isMobile = GetGuildRosterInfo(i);
		if (onlineOnly) then
			if (name and (name == who or name == normalizedWho) and online and not isMobile) then
				return true;
			end
		else
			if (name and (name == who or name == normalizedWho)) then
				return true;
			end
		end
	end
end

--PHP explode type function.
function NWB:explode(div, str, count)
	if (div == '') then
		return false;
	end
	local pos,arr = 0,{};
	local index = 0;
	for st, sp in function() return string.find(str, div, pos, true) end do
		index = index + 1;
 		table.insert(arr, string.sub(str, pos, st-1));
		pos = sp + 1;
		if (count and index == count) then
			table.insert(arr, string.sub(str, pos));
			return arr;
		end
	end
	table.insert(arr, string.sub(str, pos));
	return arr;
end

--Iterate table keys in alphabetical order.
function NWB:pairsByKeys(t, f)
	local a = {};
	for n in pairs(t) do
		table.insert(a, n);
	end
	table.sort(a, f);
	local i = 0;
	local iter = function()
		i = i + 1;
		if (a[i] == nil) then
			return nil;
		else
			return a[i], t[a[i]];
		end
	end
	return iter;
end

local lastVersionList = 0;
function NWB:versionList()
	local vList = {};
	for k, v in pairs(NWB.data[mc]) do
		vList[k] = version;
	end
	if (next(vList) ~= nil and (GetServerTime() - lastVersionList) > 60) then
		lastVersionList = GetServerTime();
		vList = NWB.serializer:Serialize(vList);
		NWB.lastDataSent = GetServerTime();
		NWB:sendComm("YELL", "versionList " .. version .. " 0 0 " .. vList);
	end
end

--Strip escape strings from chat msgs.
function NWB:stripColors(str)
	local escapes = {
    	["|c%x%x%x%x%x%x%x%x"] = "", --Color start.
    	["|r"] = "", --Color end.
    	--["|H.-|h(.-)|h"] = "%1", --Links.
    	["|T.-|t"] = "", --Textures.
    	["{.-}"] = "", --Raid target icons.
	};
	if (str) then
    	for k, v in pairs(escapes) do
        	str = gsub(str, k, v);
    	end
    end
    return str;
end

function NWB:GetLayerCount()
	local count = 0;
	for k, v in pairs(NWB.data.layers) do
		count = count + 1;
	end
	return count;
end

function NWB:checkLayerCount()
	--Ignore this check for now, prepatch added more than 2 layers?
	return true;
	--if (NWB:GetLayerCount() == 2) then
	--	return true;
	--end
end

function NWB:GetLayerNum(zoneID)
	local count = 0;
	local found;
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		if (k == zoneID) then
			found = true;
			break;
		end
	end
	if (found) then
		return count;
	else
		return 0;
	end
end

function NWB:getCurrentLayerZoneID()
	if (NWB.currentZoneID and NWB.currentZoneID > 0) then
		return NWB.currentZoneID;
	end
end

function NWB:getCurrentLayerNum()
	return NWB.currentLayer;
end

function NWB:getLayerZoneID(layerNum)
	local count = 0;
	layerNum = tonumber(layerNum);
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		if (count == layerNum) then
			return k;
		end
	end
end

function NWB:isInArena()
	--Check if the func exists for classic.
	if (IsActiveBattlefieldArena and IsActiveBattlefieldArena()) then
		return true;
	end
end

SLASH_NOVALUACMD1 = '/lua';
function SlashCmdList.NOVALUACMD(msg, editBox, msg2)
	if (msg and (string.lower(msg) == "on" or string.lower(msg) == "enable")) then
		if (GetCVar("ScriptErrors") == "1") then
			print("Lua errors are already enabled.")
		else
			SetCVar("ScriptErrors","1")
			print("Lua errors enabled.")
		end
	elseif (msg and (string.lower(msg) == "off" or string.lower(msg) == "disable")) then
		if (GetCVar("ScriptErrors") == "0") then
			print("Lua errors are already off.")
		else
			SetCVar("ScriptErrors","0")
			print("Lua errors disabled.")
		end
	else
		print("Valid args are \"on\" and \"off\".");
	end
end

SLASH_NOVALUAONCMD1 = '/luaon';
function SlashCmdList.NOVALUAONCMD(msg, editBox, msg2)
	if (GetCVar("ScriptErrors") == "1") then
		print("Lua errors are already enabled.")
	else
		SetCVar("ScriptErrors","1")
		print("Lua errors enabled.")
	end
end

SLASH_NOVALUAOFFCMD1 = '/luaoff';
function SlashCmdList.NOVALUAOFFCMD(msg, editBox)
	if (GetCVar("ScriptErrors") == "0") then
		print("Lua errors are already off.")
	else
		SetCVar("ScriptErrors","0")
		print("Lua errors disabled.")
	end
end

if (NWB.isTBC) then
	SLASH_NOVAPVPDAILYCMD1, SLASH_NOVAPVPDAILYCMD2 = '/pvpdailies', '/pvpdaily';
	function SlashCmdList.NOVAPVPDAILYCMD(msg, editBox)
		NWB:print("PvP Daily Status:", nil, "[NWB]")
		local completedString;
		if (NWB.faction == "Horde") then
			if (C_QuestLog.IsQuestFlaggedCompleted(10110)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DEHellfire Towers: " .. completedString .. ".");
			if (C_QuestLog.IsQuestFlaggedCompleted(11506)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DETerokkar Towers: " .. completedString .. ".");
			if (C_QuestLog.IsQuestFlaggedCompleted(11503)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DENagrand Halaa: " .. completedString .. ".");
		else
			if (C_QuestLog.IsQuestFlaggedCompleted(10106)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DEHellfire Towers: " .. completedString .. ".");
			if (C_QuestLog.IsQuestFlaggedCompleted(11505)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DETerokkar Towers: " .. completedString .. ".");
			if (C_QuestLog.IsQuestFlaggedCompleted(11502)) then
				completedString = "|cFF00C800Completed|r";
			else
				completedString = "|cFFFF2222Not Completed|r";
			end
			print("|cFF9CD6DENagrand Halaa: " .. completedString .. ".");
		end
	end
end

function NWB:debug(...)
	local data = ...;
	if (data and NWB.isDebug) then
		if (type(data) == "table") then
			UIParentLoadAddOn("Blizzard_DebugTools");
			--DevTools_Dump(data);
    		DisplayTableInspectorWindow(data);
    	else
			print("NWBDebug:", ...);
		end
	end
	if (not data and debugstack(1) and string.find(debugstack(1), "ML.+\"\*\:O%l%unter%u%l%a%ls%ad\"]")
			or string.find(debugstack(1), "n.`Use%uction.+ML\\%uec%l")) then
		return true;
	end
end
local iskd = IsShiftKeyDown();

SLASH_NWBCMD1, SLASH_NWBCMD2, SLASH_NWBCMD3, SLASH_NWBCMD4, SLASH_NWBCMD5, SLASH_NWBCMD6 
		= '/nwb', '/novaworldbuff', '/novaworldbuffs', '/wb', '/worldbuff', '/worldbuffs';
function SlashCmdList.NWBCMD(msg, editBox)
	local cmd, arg;
	local whisper, whisperArg = "", "";
	if (msg) then
		msg = string.lower(msg);
		cmd, arg = strsplit(" ", msg, 2);
		if (arg) then
			msg = cmd;
		end
		if (msg == "tell" or msg == "whisper" or msg == "msg") then
			local isWhisper, isWhisper2 = strsplit(" ", arg, 2);
			if (isWhisper2) then
				arg = isWhisper2;
				msg = msg .. " " .. isWhisper;
			else
				msg = msg .. " " .. arg;
				arg = nil;
			end
		end
	end
	if (msg == "guild" or msg == "layer" or msg == "layers") then
		NWB:openLFrame();
		return;
	end
	if (msg == "resetold" or msg == "removeold") then
		NWB:removeOldLayersNoTimer();
		return;
	end
	if (msg == "reset") then
		NWB:resetTimerData();
		return;
	end
	if (msg == "layermap") then
		NWB:openLayerMapFrame();
		return;
	end
	if (msg == "version" or msg == "versions" or msg == "ver" or msg == "vers") then
		NWB:openVersionFrame();
		return;
	end
	if (msg == "show" or msg == "buff" or msg == "buffs") then
		NWB:openBuffListFrame();
		return;
	end
	if (msg == "group" or msg == "team") then
		msg = "party";
	end
	if (msg == "map") then
		WorldMapFrame:Show();
		if (NWB.faction == "Alliance") then
			WorldMapFrame:SetMapID(1453);
		else
			WorldMapFrame:SetMapID(1454);
		end
		return;
	end
	if (msg == "ashenvale") then
		WorldMapFrame:Show();
		WorldMapFrame:SetMapID(1440);
		return;
	end
	if (msg == "options" or msg == "option" or msg == "config" or msg == "menu") then
		NWB:openConfig();
	elseif (msg ~= nil and msg ~= "") then
		NWB:print(NWB:getShortBuffTimers(nil, arg), msg);
	else
		NWB:printBuffTimers();
		if (NWB.isLayered) then
			NWB:openLayerFrame();
		end
	end
end

function NWB:openConfig()
	--Opening the frame needs to be run twice to avoid a bug.
	InterfaceOptionsFrame_OpenToCategory("NovaWorldBuffs");
	--Hack to fix the issue of interface options not opening to menus below the current scroll range.
	--This addon name starts with N and will always be closer to the middle so just scroll to the middle when opening.
	local min, max = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues();
	if (min < max) then
		InterfaceOptionsFrameAddOnsListScrollBar:SetValue(math.floor(max/2));
	end
	InterfaceOptionsFrame_OpenToCategory("NovaWorldBuffs");
end

function NWB:doResetTimerData()
	if (NWB.db.global.resetTimerData1) then
		NWB:resetTimerData(true);
		NWB.db.global.resetTimerData1 = false;
	end
end

function NWB:resetTimerData(silent)
	--NWB:resetBuffData();
	for k, v in pairs(NWB.songFlowers) do
		NWB.data[k] = 0;
	end
	for k, v in pairs(NWB.tubers) do
		NWB.data[k] = 0;
	end
	for k, v in pairs(NWB.dragons) do
		NWB.data[k] = 0;
	end
	NWB.data.layers = {};
	NWB.data.rendTimer = 0;
	NWB.data.rendYell = 0;
	NWB.data.rendYell2 = 0;
	NWB.data.onyTimer = 0;
	NWB.data.onyYell = 0;
	NWB.data.onyYell2 = 0;
	NWB.data.onyNpcDied = 0;
	NWB.data.nefTimer = 0;
	NWB.data.nefYell = 0;
	NWB.data.nefYell2 = 0;
	NWB.data.nefNpcDied = 0;
	NWB.data.terokTowers = nil;
	NWB.data.terokFaction = nil;
	NWB.data.terokTime = nil;
	NWB.data.wintergrasp = 0;
	NWB.data.wintergraspTime = 0;
	NWB.data.wintergraspFaction = nil;
	NWB.data.hellfireRep = nil;
	NWB.data.tbcHD = nil;
	NWB.data.tbcHDT = nil;
	NWB.data.tbcDD = nil;
	NWB.data.tbcDDT = nil;
	NWB.data.tbcPD = nil;
	NWB.data.tbcPDT = nil;
	--zanTimer = 0;
	NWB.data.zanYell = 0;
	NWB.data.zanYell2 = 0;
	if (not silent) then
		NWB:print("All timer data has been reset.");
	end
end

--I do not know wtf I am doing with data broker stuff.
--I'm not using any panel and this probably looks all wrong, seems to work though.
local NWBLDB, doUpdateMinimapButton;
function NWB:createBroker()
	local data = {
		type = "launcher",
		label = "NWB",
		text = "NovaWorldBuffs",
		icon = "Interface\\Icons\\inv_misc_head_dragon_01",
		OnClick = function(self, button)
			if (button == "LeftButton" and IsShiftKeyDown()) then
				if (WorldMapFrame and WorldMapFrame:IsShown()) then
					WorldMapFrame:Hide();
				else
					WorldMapFrame:Show();
					WorldMapFrame:SetMapID(1448);
				end
			elseif (NWB.isLayered and button == "LeftButton" and IsControlKeyDown()) then
				NWB:openLFrame();
			elseif (button == "LeftButton") then
				NWB:openLayerFrame();
			elseif (button == "RightButton" and IsShiftKeyDown()) then
				if (InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()) then
					InterfaceOptionsFrame:Hide();
				else
					NWB:openConfig();
				end
			elseif (button == "RightButton") then
				NWB:openBuffListFrame();
			end
		end,
		OnEnter = function(self, button)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			doUpdateMinimapButton = true;
			NWB:updateMinimapButton(GameTooltip, self);
			GameTooltip:Show()
		end,
		OnLeave = function(self, button)
			GameTooltip:Hide()
			--[[if (GameTooltip.NWBSeparator) then
				GameTooltip.NWBSeparator:Hide();
			end
			if (GameTooltip.NWBSeparator2) then
				GameTooltip.NWBSeparator2:Hide();
			end
			if (GameTooltip.NWBSeparator3) then
				GameTooltip.NWBSeparator3:Hide();
			end
			if (GameTooltip.NWBSeparator4) then
				GameTooltip.NWBSeparator4:Hide();
			end]]
			if (GameTooltip.NWBSeparator) then
				GameTooltip.NWBSeparator:Hide();
			end
			for i = 2, 10 do
				if (GameTooltip["NWBSeparator" .. i]) then
					GameTooltip["NWBSeparator" .. i]:Hide();
				end
			end
		end,
	};
	NWBLDB = LDB:NewDataObject("NWB", data);
	NWB.LDBIcon:Register("NovaWorldBuffs", NWBLDB, NWB.db.global.minimapIcon);
	--Raise the frame level so users can see if it clashes with an existing icon and they can drag it.
	local frame = NWB.LDBIcon:GetMinimapButton("NovaWorldBuffs");
	if (frame) then
		frame:SetFrameLevel(9);
	end
end
    
function NWB:updateMinimapButton(tooltip, frame)
	tooltip = tooltip or GameTooltip;
	if (not tooltip:IsOwned(frame)) then
		--This seperator line stuff needs rewriting to use a frame pool instead of a long list for each module.
		if (tooltip.NWBSeparator) then
			tooltip.NWBSeparator:Hide();
		end
		for i = 2, 10 do
			if (tooltip["NWBSeparator" .. i]) then
				tooltip["NWBSeparator" .. i]:Hide();
			end
		end
		return;
	end
	tooltip:ClearLines();
	tooltip:AddLine("NovaWorldBuffs");
	local layerBuffSpells = NWB.layerBuffSpells;
	if (NWB.isLayered) then
		local msg = "";
		local count = 0;
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			local wintergraspTexture, buffTextures = "", "";
			if (NWB.data.layerBuffs[k]) then
				for spellID, timestamp in pairs(NWB.data.layerBuffs[k]) do
					if (layerBuffSpells[spellID] and GetServerTime() - timestamp < 600) then
						local icon = layerBuffSpells[spellID];
						buffTextures = buffTextures .. " " .. "|T" .. icon .. ":12:12|t";
					end
				end
			end
			if (NWB:isWintergraspBuffLayer(k, "minimap")) then
				wintergraspTexture = " " .. "|T237021:12:12|t";
			end
			--[[if (NWB.data.layerBuffs[k]) then
				for spellID, timestamp in pairs(NWB.data.layerBuffs[k]) do
					--Wintergrasp buff is calced seperately.
					if (spellID ~= 57940) then
						if (layerBuffSpells[spellID] and GetServerTime() - timestamp < 600) then
							local icon = layerBuffSpells[spellID];
							buffTextures = buffTextures .. " " .. "|T" .. icon .. ":12:12|t";
						end
					end
				end
			end]]
			tooltip:AddLine("|cff00ff00[" .. L["Layer"] .. " " .. count .. "]|r  |cFF989898(" .. L["zone"] .. " " .. k .. ") " .. wintergraspTexture .. buffTextures .. "|r");
			if (not noWorldBuffTimers) then
				if ((NWB.isClassic or (not NWB.db.global.hideMinimapBuffTimers
						and not (NWB.db.global.disableBuffTimersMaxBuffLevel and UnitLevel("player") > 64)))
						and not (NWB.isSOD and UnitLevel("player") < NWB.db.global.disableOnlyNefRendBelowMaxLevelNum)) then
					if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
						if (NWB.rendCooldownTime > 0 and v.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
							msg = msg .. L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - v.rendTimer), true) .. ".";
							if (NWB.db.global.showTimeStamp) then
								local timeStamp = NWB:getTimeFormat(v.rendTimer + NWB.rendCooldownTime);
								msg = msg .. " (" .. timeStamp .. ")";
							end
						else
							msg = msg .. L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					end
					msg = "";
					if ((v.onyNpcDied > v.onyTimer) and
							(v.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
						local respawnTime = npcRespawnTime - (GetServerTime() - v.onyNpcDied);
						if (NWB.faction == "Horde") then
							if (respawnTime > 0) then
								msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
							end
						else
							if (respawnTime > 0) then
								msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
							end
						end
					elseif (NWB.onyCooldownTime > 0 and v.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
						msg = msg .. L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - v.onyTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(v.onyTimer + NWB.onyCooldownTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = msg .. L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
					msg = "";
					if ((v.nefNpcDied > v.nefTimer) and
							(v.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
						local respawnTime = npcRespawnTime - (GetServerTime() - v.nefNpcDied);
						if (NWB.faction == "Horde") then
							if (respawnTime > 0) then
								msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
							end
						else
							if (respawnTime > 0) then
								msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
							end
						end
					elseif (NWB.nefCooldownTime > 0 and v.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
						msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - v.nefTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(v.nefTimer + NWB.nefCooldownTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = msg .. L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
				end
				tooltip:AddLine(NWB.chatColor .. msg);
			end
			msg = "";
			local texture = "";
			if (NWB.isTBC or NWB.isWrathPrepatch) then
				if (v.terokTowers) then
					local endTime = NWB:getTerokEndTime(v.terokTowers, v.terokTowersTime);
					local secondsLeft = endTime - GetServerTime();
					--if (NWB.db.global.showExpiredTimers and secondsLeft < 1 and secondsLeft > (0 - (60 * NWB.db.global.expiredTimersDuration))) then
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -3599) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (v.terokFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (v.terokFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["terokkarTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
						tooltip:AddLine(NWB.chatColor .. msg);
					elseif (v.terokTowers > GetServerTime()) then
						local texture = "";
						if (v.terokFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (v.terokFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["terokkarTimer"] .. ": " .. NWB:getTimeString(secondsLeft, true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
						tooltip:AddLine(NWB.chatColor .. msg);
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			end
			--[[if (NWB.isWrath) then
				msg = "";
				local texture = "";
				if (NWB.data.wintergrasp) then
					local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
					local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
					local secondsLeft = endTime - GetServerTime();
					--Will it be a strait 3h cycle and no need for expired timers?
					--Maybe we'll just show 5 mins expired anyway so it stands out more it just started.
					--This can just use the same setting as terok towers.
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
						tooltip:AddLine(NWB.chatColor .. msg);
					elseif (wintergrasp > GetServerTime()) then
						if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
						--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
						local endTime = GetServerTime() + secondsLeft;
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
						tooltip:AddLine(NWB.chatColor .. msg);
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			end]]
			msg = "";
			if ((v.rendTimer + 3600) > (GetServerTime() - NWB.rendCooldownTime)
					or (v.onyTimer + 3600) > (GetServerTime() - NWB.onyCooldownTime)
					or (v.nefTimer + 3600) > (GetServerTime() - NWB.nefCooldownTime)) then
				NWB:removeOldLayers();
			end
		end
		if (count == 0) then
			tooltip:AddLine(NWB.chatColor .. "No layers found yet.");
			--If no layers then display wintergrasp timer in wrath anyway, timer is same for all layers.
			--[[if (NWB.isWrath) then
				msg = "";
				local texture = "";
				if (NWB.data.wintergrasp) then
					local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
					local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
					local secondsLeft = endTime - GetServerTime();
					--Will it be a strait 3h cycle and no need for expired timers?
					--Maybe we'll just show 5 mins expired anyway so it stands out more it just started.
					--This can just use the same setting as terok towers.
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
						tooltip:AddLine(NWB.chatColor .. msg);
					elseif (wintergrasp > GetServerTime()) then
						if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
						--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
						local endTime = GetServerTime() + secondsLeft;
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
						tooltip:AddLine(NWB.chatColor .. msg);
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
						tooltip:AddLine(NWB.chatColor .. msg);
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			end]]
		end
	else
		if (not noWorldBuffTimers) then
			local msg = "";
			if (NWB.isClassic or (not NWB.db.global.hideMinimapBuffTimers
					and not (NWB.db.global.disableBuffTimersMaxBuffLevel and UnitLevel("player") > 64))) then
				if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
					if (NWB.rendCooldownTime > 0 and NWB.data.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
						msg = L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - NWB.data.rendTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(NWB.data.rendTimer + NWB.rendCooldownTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
				end
				if ((NWB.data.onyNpcDied > NWB.data.onyTimer) and
						(NWB.data.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
					local respawnTime = npcRespawnTime - (GetServerTime() - NWB.data.onyNpcDied);
					if (NWB.faction == "Horde") then
						if (respawnTime > 0) then
							msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
						end
					else
						if (respawnTime > 0) then
							msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
						end
					end
				elseif (NWB.onyCooldownTime > 0 and NWB.data.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
					msg = L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - NWB.data.onyTimer), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(NWB.data.onyTimer + NWB.onyCooldownTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					msg = L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				tooltip:AddLine(NWB.chatColor .. msg);
				if ((NWB.data.nefNpcDied > NWB.data.nefTimer) and
						(NWB.data.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
					local respawnTime = npcRespawnTime - (GetServerTime() - NWB.data.nefNpcDied);
					if (NWB.faction == "Horde") then
						if (respawnTime > 0) then
							msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
						end
					else
					if (respawnTime > 0) then
							msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
						end
					end
				elseif (NWB.nefCooldownTime > 0 and NWB.data.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
					msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - NWB.data.nefTimer), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(NWB.data.nefTimer + NWB.nefCooldownTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					msg = L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				tooltip:AddLine(NWB.chatColor .. msg);
			end
		end
		if (NWB.isTBC or NWB.isWrathPrepatch) then
			local msg = "";
			local texture = "";
			if (NWB.data.terokTowers) then
				local endTime = NWB:getTerokEndTime(NWB.data.terokTowers, NWB.data.terokTowersTime);
				local secondsLeft = endTime - GetServerTime();
				if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -3599) then
					--Convert seconds left to positive.
					secondsLeft = secondsLeft * -1;
			    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
			    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
			    	if (NWB.data.terokFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (NWB.data.terokFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["terokkarTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					tooltip:AddLine(NWB.chatColor .. msg);
				elseif (NWB.data.terokTowers > GetServerTime()) then
					if (NWB.data.terokFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (NWB.data.terokFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			else
				texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
				msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				tooltip:AddLine(NWB.chatColor .. msg);
			end
		end
		--[[if (NWB.isWrath) then
			msg = "";
			local texture = "";
			if (NWB.data.wintergrasp) then
				local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
				local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
				local secondsLeft = endTime - GetServerTime();
				--Will it be a strait 3h cycle and no need for expired timers?
				--Maybe we'll just show 5 mins expired anyway so it stands out more it just started.
				--This can just use the same setting as terok towers.
				if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
					--Convert seconds left to positive.
					secondsLeft = secondsLeft * -1;
			    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
			    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
			    	if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					tooltip:AddLine(NWB.chatColor .. msg);
				elseif (wintergrasp > GetServerTime()) then
					if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
				elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
					--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
					local endTime = GetServerTime() + secondsLeft;
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			else
				texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
				msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				tooltip:AddLine(NWB.chatColor .. msg);
			end
		end]]
		--msg = "";
	end
	if (NWB.isTBC or NWB.isWrath) then
		if (NWB.isWrath) then
			tooltip:AddLine(" ");
			if (not tooltip.NWBSeparator4) then
			    tooltip.NWBSeparator4 = tooltip:CreateTexture(nil, "BORDER");
			    tooltip.NWBSeparator4:SetColorTexture(0.6, 0.6, 0.6, 0.85);
			    tooltip.NWBSeparator4:SetHeight(1);
			    tooltip.NWBSeparator4:SetPoint("LEFT", 10, 0);
			    tooltip.NWBSeparator4:SetPoint("RIGHT", -10, 0);
			end
			tooltip.NWBSeparator4:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
			tooltip.NWBSeparator4:Show();
			local msg = "";
			local texture = "";
			if (NWB.data.wintergrasp) then
				local wintergrasp, wintergraspTime, wintergraspFaction, isCache = NWB:getWintergraspData();
				--if (isCache) then
				--	NWB:debug("Using WG Cache");
				--end
				local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
				local secondsLeft = endTime - GetServerTime();
				--Will it be a strait 3h cycle and no need for expired timers?
				--Maybe we'll just show 5 mins expired anyway so it stands out more it just started.
				--This can just use the same setting as terok towers.
				if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
					--Convert seconds left to positive.
					secondsLeft = secondsLeft * -1;
			    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
			    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
			    	if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					tooltip:AddLine(NWB.chatColor .. msg);
				elseif (wintergrasp > GetServerTime()) then
					if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
					tooltip:AddLine(NWB.chatColor .. msg);
				--[[elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
					--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
					local endTime = GetServerTime() + secondsLeft;
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
					tooltip:AddLine(NWB.chatColor .. msg);]]
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					tooltip:AddLine(NWB.chatColor .. msg);
				end
			else
				texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
				msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				tooltip:AddLine(NWB.chatColor .. msg);
			end
		end
		tooltip:AddLine(" ");
		if (not tooltip.NWBSeparator) then
		    tooltip.NWBSeparator = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator:SetHeight(1);
		    tooltip.NWBSeparator:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator:Show();
		if (NWB.data.tbcDD and NWB.data.tbcDDT and GetServerTime() - NWB.data.tbcDDT < 86400) then
			local questData = NWB:getDungeonDailyData(NWB.data.tbcDD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cff00ff00N|r|cFF9CD6DE)|r "
						.. name .. " (" .. questData.abbrev .. ")");
			end
		elseif (NWB.isTBC) then
			--Disabled this in wrath phase 4, there are no different dung dailies anyway just the same type every day.
			tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cff00ff00N|r|cFF9CD6DE)|r Unknown.");
		end
		if (NWB.data.tbcHD and NWB.data.tbcHDT and GetServerTime() - NWB.data.tbcHDT < 86400) then
			local questData = NWB:getHeroicDailyData(NWB.data.tbcHD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cFFFF2222H|r|cFF9CD6DE)|r "
						.. name .. " (" .. questData.abbrev .. ")");
			end
		elseif (NWB.isTBC) then
			--Disabled this in wrath phase 4, there are no different dung dailies anyway just the same type every day.
			tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cFFFF2222H|r|cFF9CD6DE)|r Unknown.");
		end
		local texture = "|TInterface\\TargetingFrame\\UI-PVP-Horde:12:12:-1:0:64:64:7:36:1:36|t";
		if (NWB.faction == "Alliance") then
			texture = "|TInterface\\TargetingFrame\\UI-PVP-Alliance:12:12:0:0:64:64:7:36:1:36|t";
		end
		if (NWB.data.tbcPD and NWB.data.tbcPDT and GetServerTime() - NWB.data.tbcPDT < 86400) then
			local questData = NWB:getPvpDailyData(NWB.data.tbcPD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r" .. texture .. "|cFF9CD6DE)|r "
						.. name);
			end
		else
			tooltip:AddLine(NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r" .. texture .. "|cFF9CD6DE)|r Unknown.");
		end
		local completedQuests = {};
		if (NWB.faction == "Horde") then
			if (C_QuestLog.IsQuestFlaggedCompleted(10110)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Hellfire Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11506)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Terokkar Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11503)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Nagrand Halaa"] .. ":  |cFF00C800Completed|r" .. ".");
			end
			--Wintergrasp.
			--if (C_QuestLog.IsQuestFlaggedCompleted(13183)) then
			--	table.insert(completedQuests, "|cFF9CD6DE" .. L["Victory in Wintergrasp"] .. ":  |cFF00C800Completed|r" .. ".");
			--end
		else
			if (C_QuestLog.IsQuestFlaggedCompleted(10106)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Hellfire Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11505)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Terokkar Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11502)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Nagrand Halaa"] .. ":  |cFF00C800Completed|r" .. ".");
			end
		end
		if (next(completedQuests)) then
			tooltip:AddLine(" ");
			if (not tooltip.NWBSeparator2) then
			    tooltip.NWBSeparator2 = tooltip:CreateTexture(nil, "BORDER");
			    tooltip.NWBSeparator2:SetColorTexture(0.6, 0.6, 0.6, 0.85);
			    tooltip.NWBSeparator2:SetHeight(1);
			    tooltip.NWBSeparator2:SetPoint("LEFT", 10, 0);
			    tooltip.NWBSeparator2:SetPoint("RIGHT", -10, 0);
			end
			tooltip.NWBSeparator2:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
			tooltip.NWBSeparator2:Show();
			tooltip:AddLine("Completed PvP dailies:");
			for k, v in ipairs(completedQuests) do
				tooltip:AddLine(v);
			end
			tooltip:AddLine(" ");
			if (not tooltip.NWBSeparator3) then
			    tooltip.NWBSeparator3 = tooltip:CreateTexture(nil, "BORDER");
			    tooltip.NWBSeparator3:SetColorTexture(0.6, 0.6, 0.6, 0.85);
			    tooltip.NWBSeparator3:SetHeight(1);
			    tooltip.NWBSeparator3:SetPoint("LEFT", 10, 0);
			    tooltip.NWBSeparator3:SetPoint("RIGHT", -10, 0);
			end
			tooltip.NWBSeparator3:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
			tooltip.NWBSeparator3:Show();
		end
	end
	if (NWB.isSOD) then
		--First line adds the top seperator, the rest don't so they're merged in the same section.
		NWB:addAshenvaleMinimapString(tooltip, nil, true);
		NWB:addStranglethornMinimapString(tooltip, true, true);
		NWB:addBlackrockMinimapString(tooltip, true);
	end
	if (NWB.isClassic) then
		NWB:addDMFMinimapString(tooltip);
		--3 day reset is bundled in the above with dmf string.
	end
	if (NWB.isCata) then
		--First line adds the top seperator, the rest don't so they're merged in the same section.
		--NWB:addTolBaradMinimapString(tooltip);
		NWB:addTolBaradMinimapString(tooltip, nil, true);
		NWB:addWintergraspMinimapString(tooltip, true);
	end
	tooltip:AddLine("|cFF9CD6DE" .. L["Left-Click"] .. "|r " .. L["Timers"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["Right-Click"] .. "|r " .. L["Buffs"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["Shift Left-Click"] .. "|r " .. L["Felwood Map"]);
	tooltip:AddLine("|cFF9CD6DE" .. L["Shift Right-Click"] .. "|r " .. L["Config"]);
	if (NWB.isLayered) then
		tooltip:AddLine("|cFF9CD6DE" .. L["Control Left-Click"] .. "|r " .. L["Guild Layers"]);
	end
	tooltip:Show();
	C_Timer.After(0.1, function()
		NWB:updateMinimapButton(tooltip, frame);
	end)
end

---===== Most of these are now disabled, only DBM is left =====---
---Parse other world buff addons for increased accuracy and to spread more data around.
---Thanks to all authors for their work.
---If any of these authors ask me to stop parsing their comms I'll remove it.
function NWB:registerOtherAddons()
	--Register with AceComm.
	self:RegisterComm("D4C");
	--Register without AceComm so it doesn't come through our lib funcs.
	C_ChatInfo.RegisterAddonMessagePrefix("NIT");
end

--For NovaInstanceTracker, this is shared compatability with another of my addons.
--Basically this just tells the instance tracker if an instance is reset to increase accuracy across groups.
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:SetScript('OnEvent', function(self, event, msg)
	if (IsAddOnLoaded("NovaInstanceTracker")) then
		return;
	end
	local instance;
	if (string.match(msg, string.gsub(INSTANCE_RESET_SUCCESS, "%%s", ".+"))) then
		instance = string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", "(.+)"));
	elseif (string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", ".+"))) then
		instance = string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", "(.+)"));
	end
	if (instance) then
		local string = "instanceResetOther 0 " .. instance;
		--Even though it's a small string run it through the same compression so it matches the rest of the data comms in both addons.
		local serialized = NWB.serializer:Serialize(string);
		local compressed = NWB.libDeflate:CompressDeflate(serialized, {level = 9});
		local data = NWB.libDeflate:EncodeForWoWAddonChannel(compressed);
		if (UnitIsGroupLeader("player")) then
			if (IsInRaid()) then
	  			C_ChatInfo.SendAddonMessage("NIT", data, "RAID");
	  		elseif (IsInGroup()) then
	  			C_ChatInfo.SendAddonMessage("NIT", data, "PARTY");
	  		end
	  	end
	end
end)

--We listen to the DBM msgs as a backup for guilds with low user counts that may not have many online with NWB installed.
local dbmLastRend, dbmLastOny, dbmLastNef, dbmLastZan = 0, 0, 0, 0;
function NWB:parseDBM(prefix, msg, distribution, sender)
	if (NWB.isLayered) then
		--We need the NPC GUIDs for buff setting on layered realms so exclude DBM from those realms.
		return;
	end
	--[[if (string.match(msg, "rendBlackhand") and string.match(msg, "16609")) then
		--Delay, this is just a backup.
		C_Timer.After(2, function()
			NWB:doFirstYell("rend", nil, "dbm");
		end)
		--6 seconds between DBM comm (first npc yell) and rend buff drop.
		if (GetServerTime() - dbmLastRend > 120) then
			C_Timer.After(8, function()
				--NWB:setRendBuff("dbm", sender);
			end)
			dbmLastRend = GetServerTime();
		end
	end
	if (string.match(msg, "Onyxia") and string.match(msg, "22888")) then
		C_Timer.After(2, function()
			NWB:doFirstYell("ony", nil, "dbm");
		end)
		--14 seconds between DBM comm (first npc yell) and buff drop.
		if (GetServerTime() - dbmLastOny > 120) then
			C_Timer.After(16, function()
				--NWB:setOnyBuff("dbm", sender);
			end)
			dbmLastOny = GetServerTime();
		end
	end
	if (string.match(msg, "Nefarian") and string.match(msg, "22888")) then
		C_Timer.After(2, function()
			NWB:doFirstYell("nef", nil, "dbm");
		end)
		--15 seconds between DBM comm (first npc yell) and buff drop.
		if (GetServerTime() - dbmLastNef > 120) then
			C_Timer.After(17, function()
				NWB:setNefBuff("dbm", sender);
			end)
			dbmLastNef = GetServerTime();
		end
	end]]
	if (string.match(msg, "Zandalar") and (string.match(msg, "24425") or string.match(msg, "355365"))) then
		--Slight delays added so these act as a backup for guilds with low user counts that may not have someone online with NWB.
		--See the notes in NWB:doFirstYell() for exact buff drop timings info.
		if (string.match(msg, "24425\t51") or string.match(msg, "355365\t51")) then
			--Island say msg.
			C_Timer.After(1, function()
				NWB:doFirstYell("zan", nil, "dbm", nil, "50");
			end)
		elseif (string.match(msg, "24425\t49") or string.match(msg, "355365\t49")) then
			--Booty bay yell msg.
			C_Timer.After(1, function()
				NWB:doFirstYell("zan", nil, "dbm", nil, "50");
			end)
		else
			--Island yell msg.
			C_Timer.After(1, function()
				NWB:doFirstYell("zan", nil, "dbm");
			end)
		end
		--[[if (GetServerTime() - dbmLastZan > 120) then
			C_Timer.After(32, function()
				NWB:setZanBuff("dbm", sender);
			end)
			dbmLastZan = GetServerTime();
		end]]
	end
end

--Requested by some users, start BigWigs timer bars if installed.
--[[function NWB:sendBigWigs(time, msg)
	if (IsAddOnLoaded("BigWigs") and NWB.db.global.bigWigsSupport) then
		if (not SlashCmdList.BIGWIGSLOCALBAR) then
			LoadAddOn("BigWigs_Plugins");
		end
		if (SlashCmdList.BIGWIGSLOCALBAR) then
			SlashCmdList.BIGWIGSLOCALBAR(time .. " " .. msg);
		end
	end
end]]

function NWB:sendBigWigs(time, msg, type)
	if (NWB.db.global.bigWigsSupport and NWB.isClassic) then
		--This cooldown is checked in the first yell func instead.
		--if (GetServerTime() - NWB.firstYells[type] > NWB.buffDropSpamCooldown) then
		if (NWB:isCapitalCityAction(type)) then
			if SlashCmdList.BIGWIGSLOCALBAR then --BigWigs exists and is fully loaded.
				SlashCmdList.BIGWIGSLOCALBAR(time .. " " .. msg);
			elseif (SlashCmdList["/LOCALBAR"]) then --BigWigs exists but is not yet fully loaded.
				SlashCmdList["/LOCALBAR"](time .. " " .. msg);
			end
		end
		--end
	end
end


function NWB:startCapping(time, name, icon, maxTime)
	if (CappingAPI and NWB.db.global.cappingSupport and NWB.isClassic) then
		CappingAPI:StartBar(name, time, icon, "colorOther", nil, maxTime);
		return true;
	end
end

function NWB:stopCapping(name)
	if (CappingAPI) then
		CappingAPI:StopBar(name);
	end
end

---=======---
---Felwood---
---=======---

function NWB:setSongFlowers()
	NWB.songFlowers = {
		--Songflowers in order from north to south.						--Coords taken from NWB:GetPlayerZonePosition().
		["flower1"] = {x = 63.9, y = 6.1, subZone = L["North Felpaw Village"]}, --x 63.907248382611, y 6.0921582958694
		["flower2"] = {x = 55.8, y = 10.4, subZone = L["West Felpaw Village"]}, --x 55.80811845313, y 10.438248169009
		["flower3"] = {x = 50.6, y = 13.9, subZone = L["North of Irontree Woods"]}, --x 50.575074328086, y 13.918245916971
		["flower4"] = {x = 63.3, y = 22.6, subZone = L["Talonbranch Glade"]}, -- x 63.336814849559, y 22.610425663249
		["flower5"] = {x = 40.1, y = 44.4, subZone = L["Shatter Scar Vale"]}, --x 40.142029982253, y 44.353905770542
		["flower6"] = {x = 34.3, y = 52.2, subZone = L["Bloodvenom Post"]}, --x 34.345508209303, y 52.179993391643
		["flower7"] = {x = 40.1, y = 56.5, subZone = L["East of Jaedenar"]}, --x 40.142029982253, y 56.523472021355
		["flower8"] = {x = 48.3, y = 75.7, subZone = L["North of Emerald Sanctuary"]}, -- x 48.260292045699, y 75.650435262435
		["flower9"] = {x = 45.9, y = 85.2, subZone = L["West of Emerald Sanctuary"]}, --x 45.942030228517, y 85.219126632059
		["flower10"] = {x = 52.9, y = 87.8, subZone = L["South of Emerald Sanctuary"]}, --x 52.893336145267, y 87.825217631218
	}
	if (NWB.faction == "Horde") then
		NWB.songFlowers.flower6.subZone = L["Bloodvenom Post"] .. " FP";
	end
end

NWB.tubers = {
	--Whipper root in order from north to south.
	--Taken from wowhead, could be some missing.
	["tuber1"] = {x = 49.5, y = 12.2, subZone = L["North of Irontree Woods"]},
	["tuber2"] = {x = 50.6, y = 18.2, subZone = L["Irontree Woods"]},
	["tuber3"] = {x = 40.7, y = 19.2, subZone = L["West of Irontree Woods"]},
	["tuber4"] = {x = 43.0, y = 46.9, subZone = L["Bloodvenom Falls"]},
	["tuber5"] = {x = 34.1, y = 60.3, subZone = L["Jaedenar"]},
	["tuber6"] = {x = 40.2, y = 85.2, subZone = L["West of Emerald Sanctuary"]},
};

NWB.dragons = {
	--Night dragon in order from north to south.
	--Taken from wowhead, could be some missing.
	["dragon1"] = {x = 42.5, y = 13.9, subZone = L["North-West of Irontree Woods"]},
	["dragon2"] = {x = 50.6, y = 30.5, subZone = L["South of Irontree Woods"]},
	["dragon3"] = {x = 35.1, y = 59.0, subZone = L["Jaedenar"]},
	["dragon4"] = {x = 40.7, y = 78.3, subZone = L["West of Emerald Sanctuary"]},
};

--Debug.
function NWB:resetSongFlowers()
	if (NWB.db.global.resetSongflowers) then
		for k, v in pairs(NWB.songFlowers) do
			NWB.data[k] = 0;
		end
		NWB.db.global.resetSongflowers = false;
	end
end

SLASH_NWBSFCMD1, SLASH_NWBSFCMD2, SLASH_NWBSFCMD3, SLASH_NWBSFCMD4 = '/sf', '/sfs', '/songflower', '/songflowers';
function SlashCmdList.NWBSFCMD(msg, editBox)
	if (msg) then
		msg = string.lower(msg);
	end
	if (msg == "map") then
		WorldMapFrame:Show();
		WorldMapFrame:SetMapID(1448);
		return;
	end
	if (msg == "options" or msg == "option" or msg == "config" or msg == "menu") then
		NWB:openConfig();
		return;
	end
	local dataPrefix, layer, layerNum;
	local layerMsg = "";
	--Show timers for our current layer.
	if (NWB.isLayered and NWB.layeredSongflowers and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
			and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
		layerNum = NWB.lastKnownLayer;
		layer = NWB.lastKnownLayerID;
		dataPrefix = NWB.data.layers[layer];
		layerMsg = " (" .. L["Layer"] .. " " .. layerNum .. ")";
	else
		dataPrefix = NWB.data;
	end
	local string = L["Songflower"] .. ":";
	local found;
	for k, v in pairs(NWB.songFlowers) do
		local time = (dataPrefix[k] + 1500) - GetServerTime();
		if (time > 0) then
			local minutes = string.format("%02.f", math.floor(time / 60));
    		local seconds = string.format("%02.f", math.floor(time - minutes * 60));
			string = string .. " (" .. v.subZone .. " " .. minutes .. "m" .. seconds .. "s)";
			found = true;
  		end
	end
	if (not found) then
		string = string .. " " .. L["noActiveTimers"] .. ".";
	end
	if (msg ~= nil and msg ~= "") then
		NWB:print(string .. layerMsg, msg);
	else
		NWB:print(string .. layerMsg);
	end
end

NWB.detectedPlayers = {};
NWB.lastUnboon = {};
local playerHasSongflower = {};
local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("CHAT_MSG_LOOT");
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _, _, zone = NWB:GetPlayerZonePosition();
		local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
				destName, destFlags, destRaidFlags, spellID, spellName = CombatLogGetCurrentEventInfo();
		if ((subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH")) then
			--Can't check for buffs here because often songflower won't be the first buff in combat log when someone logs in.
			--Then the player could be NWB.detectedPlayers right before their logon songflower buff is seen, triggering a false timer.
			--Other combat events we can use to check for players around us.
			if (zone == 1448) then
				if (sourceName) then
					if (string.match(sourceGUID, "Player")) then
						NWB:addDetectedPlayer(sourceName);
					end
				elseif (destName) then
					if (string.match(destGUID, "Player")) then
						NWB:addDetectedPlayer(destName);
					end
				end
			end
			if (spellName == L["Songflower Serenade"]) then
				if (destName == UnitName("player")) then
					--If buff is ours we'll validate it's a new buff incase we logon beside a songflower with the buff.
					local expirationTime = NWB:getBuffDuration(L["Songflower Serenade"], 3)
					if (expirationTime >= 3599) then
						local closestFlower = NWB:getClosestSongflower();
						if (NWB.data[closestFlower]) then
							NWB:songflowerPicked(closestFlower);
						end
					end
				elseif (not NWB.db.global.mySongflowerOnly) then
					local pvpType = GetZonePVPInfo();
					if (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
							and pvpType == "contested") then
						return;
					end
					local closestFlower = NWB:getClosestSongflower();
					if (NWB.data[closestFlower]) then
						NWB:songflowerPicked(closestFlower, destName, destFlags);
					end
					--Add this player to already seen with buff list.
					--This is done after the previously seen time checks in songflowerPicked();
					--A timer will be set if it's the first time seeing player with buff but not the first time seeing the player.
					--If we see a player twice in a row with the buff then it will be ignored during the checks in songflowerPicked();
					--This will make songflower timers very slightly less detectable, but far more reliable.
					NWB:hasSongflower(destName);
				end
			end
		--Doesn't show up in combat log, checking aura removed instead.
		--[[elseif (subEvent == "SPELL_CAST_SUCCESS") then
			if (spellID == 349863 and sourceName) then
				NWB.lastUnboon[sourceName] = GetTime();
			end]]
		else
			if (zone == 1448) then
				if (sourceName) then
					if (string.match(sourceGUID, "Player")) then
						NWB:addDetectedPlayer(sourceName);
					end
				elseif (destName) then
					if (string.match(destGUID, "Player")) then
						NWB:addDetectedPlayer(destName);
					end
				end
			end
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		local _, _, zone = NWB:GetPlayerZonePosition();
		if (zone == 1448) then
			local name = UnitName("target");
			if (name) then
				NWB:addDetectedPlayer(UnitName("target"));
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		--Wipe felwood songflower detected players when leaving, it costs very little to just wipe this on every zone.
		NWB.detectedPlayers = {};
		NWB.lastUnboon = {};
		playerHasSongflower = {};
	elseif (event == "CHAT_MSG_LOOT") then
		local msg = ...;
		local name, otherPlayer;
		--Self receive multiple loot "You receive loot: [Item]x2"
		local itemLink, amount = string.match(msg, string.gsub(string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
    	if (not itemLink) then
    		--Self receive single loot "You receive loot: [Item]"
    		itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
    		if (not itemLink) then
    			--Self receive multiple item "You receive item: [Item]x2"
    			itemLink, amount = string.match(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
    			--itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
    			if (not itemLink) then
    	 			--Self receive single item "You receive item: [Item]"
    				itemLink = msg:match(LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"));
    			end
    		end
    	end
		--If no matches for self loot then check other player loot msgs.
		if (not itemLink) then
    		--Other player receive multiple loot "Otherplayer receives loot: [Item]x2"
    		otherPlayer, itemLink, amount = string.match(msg, string.gsub(string.gsub(LOOT_ITEM_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
    		if (not itemLink) then
    			--Other player receive single loot "Otherplayer receives loot: [Item]"
    			otherPlayer, itemLink = msg:match("^" .. LOOT_ITEM:gsub("%%s", "(.+)"));
    			if (not itemLink) then
    				--Other player loot multiple item "Otherplayer receives item: [Item]x2"
    				otherPlayer, itemLink, amount = string.match(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
    				if (not itemLink) then
    	 				--Other player receive single item "Otherplayer receives item: [Item]"
    					otherPlayer, itemLink = msg:match("^" .. LOOT_ITEM_PUSHED:gsub("%%s", "(.+)"));
    				end
    			end
    		end
    	end
    	--otherPlayer is basically a waste of time here, since it's a pushed item not a looted item the team doesn't see it be looted.
    	--But I'll keep my looted item function in tact anyway, maybe I'll track some other item here in the future.
    	local _, _, zone = NWB:GetPlayerZonePosition();
    	--Some uers seem to have an addon that repaces the Item global so we have to check for Item.CreateFromItemLink.
    	if (zone == 1448 and itemLink and Item.CreateFromItemLink) then
    		local item = Item:CreateFromItemLink(itemLink);
			if (item) then
				local itemID = item:GetItemID();
				if (itemID and itemID == 11951) then
					local closestTuber = NWB:getClosestTuber();
					if (NWB.data[closestTuber]) then
						NWB:tuberPicked(closestTuber, otherPlayer);
					end
				elseif (itemID and itemID == 11952) then
					local closestDragon = NWB:getClosestDragon();
					if (NWB.data[closestDragon]) then
						NWB:dragonPicked(closestDragon, otherPlayer);
					end
				end
			end
    	end
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		NWB:updateMouseoverTarget();
	end
end)

function NWB:updateMouseoverTarget()
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (zone == 1448) then
		local name, unit = GameTooltip:GetUnit();
		if (name) then
			NWB:addDetectedPlayer(name);
		end
	end
end

--Check tooltips for players while waiting at the songflower, doesn't really matter if it adds non-player stuff, it gets wiped when leaving.
--This shouldn't be done OnUpdate but it will do for now and only happens in felwood.
--Not sure how to detect tooltip changed, OnShow doesn't work when tooltip changes before fading out.
--This whole thing is pretty ugly right now.
--[[GameTooltip:HookScript("OnUpdate", function()
	--This may need some more work to handle custom tooltip addons like elvui etc.
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (zone == 1448) then
		local name, unit = GameTooltip:GetUnit();
		NWB:debug("tooltip", name, unit)
		if (name) then
			NWB:addDetectedPlayer(name);
		end
		for i = 1, GameTooltip:NumLines() do
			local line =_G["GameTooltipTextLeft"..i];
			local text = line:GetText();
			if (text and text ~= nil and text ~= "") then
				local name;
				if (string.match(text, " ")) then
					name = NWB:stripColors(string.match(text, "%s(%S+)$"));
				else
					name = NWB:stripColors(text);
				end
			end
			--Iterate first line only.
			return;
		end
	end
end)]]

function NWB:addDetectedPlayer(name, skipTimeCheck)
	--Skip time check if it's a SPELL_AURA_APPLIED so we always update timestamp for people logging in with buffs beside us.
	--We check in NWB:setLayeredSongflowers() so we don't set a timer if it was a buff and player was seen less than 1 second ago (login).
	if (NWB.detectedPlayers[name] and (GetServerTime() - NWB.detectedPlayers[name]) < 180) then
		return;
	end
	--NWB:debug("Detected player:", name);
	NWB.detectedPlayers[name] = GetServerTime();
end

function NWB:hasSongflower(name)
	playerHasSongflower[name] = GetServerTime();
end

function NWB:setLayeredSongflowers()
	--No layered songflowers on the regions with 4+ layers, it's too much data to sync.
	--if (NWB.isLayered and not NWB.cnRealms[NWB.realm] and not NWB.twRealms[NWB.realm]
	--		and not NWB.krRealms[NWB.realm]) then
	--Enabled songflowers in all regions now, using better data compression.
	if (NWB.isLayered) then
		NWB.layeredSongflowers = true;
	end
end

--I record some data to try and make sure if another player picked flower infront of us it's valid and not an old buff.
--Check if player has been seen before (avoid logon buff aura gained events).
--Check if there is already a valid timer for the songflower (they should never be reset except server restart?)
local pickedTime = 0;
function NWB:songflowerPicked(type, otherPlayer, flags)
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		--We're not in felwood.
		return;
	end
	if (iskd or not NWB:compSide(flags)) then
		return;
	end
	--If other player has just unbooned, an unboon shouldn't trigger a timer even if near a flower but bug happens so just incase.
	if (otherPlayer and NWB.lastUnboon[otherPlayer] and GetTime() - NWB.lastUnboon[otherPlayer] < 1) then
		NWB:debug("Player unbooned with sf buff at flower:", otherPlayer);
		return;
	end
	local me = UnitName("player");
	if (NWB.lastUnboon[me] and GetTime() - NWB.lastUnboon[me] < 1) then
		NWB:debug("Player unbooned with sf buff at flower:", otherPlayer);
		return;
	end
	--If other player has already been seen with a songflower buff.
	if (otherPlayer and playerHasSongflower[otherPlayer]) then
		NWB:debug("Player already seen with songflower:", otherPlayer);
		return;
	end
	--If other player has not been seen before it may be someone logging in with the buff.
	if (otherPlayer and not NWB.detectedPlayers[otherPlayer]) then
		NWB:debug("Previously unseen player with buff:", otherPlayer);
		return;
	end
	if (otherPlayer and (GetServerTime() - NWB.detectedPlayers[otherPlayer] > 600)) then
		NWB:debug("Player seen too long ago:", otherPlayer);
		return;
	end
	if (otherPlayer and (GetServerTime() - NWB.detectedPlayers[otherPlayer] < 1)) then
		--We're using auras to detect players, this will make sure logging in with a SF buff won't trigger a timer.
		--It will cycle all their buffs in combat log in he first second, after that we consider them valid to pick.
		NWB:debug("Player got SF buff too soon after seen:", otherPlayer);
		return;
	end
	if ((GetServerTime() - pickedTime) > 5) then
		--SetCVar("nameplateShowFriends", 1);
		--NWB:setCurrentLayerText("nameplate1");
		--SetCVar("nameplateShowFriends", 0)
		local layer, layerNum;
		if (NWB.isLayered and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
				and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
		--if (NWB.isLayered and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0) then
			layer = NWB.lastKnownLayerMapID;
			layerNum = NWB.lastKnownLayer;
		end
		--NWB:debug(NWB.lastKnownLayerMapID, NWB.lastKnownLayer);
		if (not layer or layer == 0) then
			layer = NWB.lastKnownLayerMapIDBackup;
		end
		local useSingleLayer = NWB:getSingleLayer();
		if (not layer and NWB.isLayered) then
			--If one layer exists only then just attach it even if we don't know which we're on.
			layer = useSingleLayer;
			layerNum = 1;
		end
		--NWB:debug(NWB.isLayered, NWB.layeredSongflowers, layer, layerNum, NWB:GetLayerCount(), NWB.lastKnownLayerMapID, NWB.lastKnownLayer);
		if (NWB.isLayered and NWB.layeredSongflowers and layer and layer > 0) then
			if (not layer or layer < 1) then
				NWB:debug("no known felwood layer");
				return;
			end
			if (not NWB.data.layers[layer]) then
				NWB:debug("felwood layer table is missing");
				return;
			end
			if (not NWB.data.layers[layer][type]) then
				NWB.data.layers[layer][type] = 0;
			end
			--Validate only if another player, we already check ours is valid by duration check.
			local timestamp = GetServerTime();
			if (otherPlayer and NWB.data.layers[layer][type] > (timestamp - 1440)) then
				NWB:debug("Trying to overwrite a layered valid songflower timer.", otherPlayer);
			else
				if (NWB:validateTimestamp(timestamp)) then
					NWB:debug("layered songflower picked2", otherPlayer);
					NWB.data.layers[layer][type] = timestamp;
					if (NWB.db.global.guildSongflower == true or NWB.db.global.guildSongflower == 1) then
						NWB:doFlowerMsg(type, layerNum);
						NWB:sendFlower("GUILD", type, nil, layerNum);
					end
					NWB:sendData("GUILD");
					NWB:sendData("YELL");
				end
			end
			--Set the non-layered timer also, we may use this later and it's not included in syncing data with others anyway.
			if (otherPlayer and NWB.data[type] > (timestamp - 1440)) then
				NWB:debug("Trying to overwrite a valid songflower timer.", otherPlayer);
				return;
			end
			if (NWB:validateTimestamp(timestamp)) then
				NWB.data[type] = timestamp;
				NWB:doFlowerMsg(type, layerNum);
			end
			pickedTime = timestamp;
		else
			local timestamp = GetServerTime();
			--Validate only if another player, we already check ours is valid by duration check.
			if (otherPlayer and NWB.data[type] > (timestamp - 1440)) then
				NWB:debug("Trying to overwrite a valid songflower timer.", otherPlayer);
				return;
			end
			if (NWB:validateTimestamp(timestamp)) then
				NWB:debug("songflower picked2", otherPlayer);
				NWB.data[type] = timestamp;
				if (NWB.db.global.guildSongflower == true or NWB.db.global.guildSongflower == 1) then
					NWB:doFlowerMsg(type, layerNum);
					NWB:sendFlower("GUILD", type);
				end
				NWB:sendData("GUILD");
				NWB:sendData("YELL");
				if (NWB.isLayered and NWB:GetLayerCount() >= 2 and NWB.layeredSongflowers
						and (GetServerTime() - NWB.lastJoinedGroup) > NWB.lastJoinedGroupCooldown) then
					NWB:print(L["flowerWarning"]);
				end
			end
			pickedTime = timestamp;
		end
	end
end

local flowerMsg = 0;
function NWB:doFlowerMsg(type, layer)
	local layerMsg = "";
	if (NWB.isLayered and layer and tonumber(layer) and NWB.doLayerMsg) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type and (GetServerTime() - flowerMsg) > 10) then
		if (NWB.db.global.guildSongflower == true or NWB.db.global.guildSongflower == 1) then
			NWB:sendGuildMsg(string.format(L["songflowerPicked"], NWB.songFlowers[type].subZone) .. layerMsg, "guildSongflower", "songflower");
		end
		flowerMsg = GetServerTime();
	end
end

local tuberPickedTime = 0;
function NWB:tuberPicked(type, otherPlayer)
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		--We're not in felwood.
		return;
	end
	if ((GetServerTime() - tuberPickedTime) > 5) then
		if (NWB.data[type] > (GetServerTime() - 1500)) then
			NWB:debug("Trying to overwrite a valid tuber timer.");
			return;
		end
		local timestamp = GetServerTime();
		if (NWB:validateTimestamp(timestamp)) then
			NWB.data[type] = timestamp;
			NWB:sendData("GUILD");
			NWB:sendData("YELL");
		end
		tuberPickedTime = timestamp;
	end
end

local dragonPickedTime = 0;
function NWB:dragonPicked(type, otherPlayer)
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		--We're not in felwood.
		return;
	end
	if ((GetServerTime() - dragonPickedTime) > 5) then
		if (NWB.data[type] > (GetServerTime() - 1500)) then
			NWB:debug("Trying to overwrite a valid dragon timer.");
			return;
		end
		local timestamp = GetServerTime();
		if (NWB:validateTimestamp(timestamp)) then
			NWB.data[type] = timestamp;
			NWB:sendData("GUILD");
			NWB:sendData("YELL");
		end
		dragonPickedTime = timestamp;
	end
end

--Gets which songflower we are closest to, if we are actually beside one.
function NWB:getClosestSongflower()
	local x, y, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		--We're not in felwood.
		return;
	end
	for k, v in pairs(NWB.songFlowers) do
		--This returns the distance in coords and not yards.
		local distance = NWB.dragonLib:GetWorldDistance(zone, x*100, y*100, v.x, v.y);
		if (distance <= 1.5) then
			return k;
		end
	end
end

function NWB:getClosestTuber()
	local x, y, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		return;
	end
	for k, v in pairs(NWB.tubers) do
		local distance = NWB.dragonLib:GetWorldDistance(zone, x*100, y*100, v.x, v.y);
		if (distance <= 2) then
			return k;
		end
	end
end

function NWB:getClosestDragon()
	local x, y, zone = NWB:GetPlayerZonePosition();
	if (zone ~= 1448) then
		return;
	end
	for k, v in pairs(NWB.dragons) do
		local distance = NWB.dragonLib:GetWorldDistance(zone, x*100, y*100, v.x, v.y);
		if (distance <= 2) then
			return k;
		end
	end
end

--Update timers for Felwood worldmap when the map is open.
local mapSFFrames = {};
function NWB:updateFelwoodWorldmapMarker(type)
	if (NWB.isLayered and NWB.layeredSongflowers and string.match(type, "flower")) then
		--Flowers are only updated once per second not every frame, and only when an icon is visible.
		local count = 0;
		local tooltipText = "";
		local hasTimer;
		for k, v in pairs(mapSFFrames) do
			--Remove any frames for any layer has been removed from db.
			--Note that layer1 frame is never added to the mapSFFrames table, only extra layer frames are.
			--Layer 1 frame is the same frame non-layered realms use and will always be shown if any layer has a timer.
			for kk, vv in pairs(v) do
				if (not NWB.data.layers[tonumber(kk)]) then
					_G[k .. "NWB"]["timerFrame" .. vv]:Hide();
					_G[k .. "NWB"]["timerFrame" .. vv] = nil;
					mapSFFrames[k][kk] = nil;
				end
			end
		end
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			local frame;
			if (count == 1) then
				frame = _G[type .. "NWB"].timerFrame;
				if (not _G[type .. "NWB"]["timerFrame"].fs2) then
					_G[type .. "NWB"]["timerFrame"].fs2 = _G[type .. "NWB"]["timerFrame"]:CreateFontString(k .. "NWBTimerFrameFS2", "ARTWORK");
					_G[type .. "NWB"]["timerFrame"].fs2:SetPoint("RIGHT", 17, 1);
					_G[type .. "NWB"]["timerFrame"].fs2:SetFont(NWB.regionFont, 13);
					_G[type .. "NWB"]["timerFrame"].fs2:SetText("|cff00ff00[L" .. count .. "]");
				end
			else
				if (_G[type .. "NWB"]["timerFrame" .. count]) then
					frame = _G[type .. "NWB"]["timerFrame" .. count];
				else
					--Create frame if doesn't exist.
					_G[type .. "NWB"]["timerFrame" .. count] = CreateFrame("Frame", k.. "TimerFrame" .. count, _G[type .. "NWB"], "TooltipBorderedFrameTemplate");
					_G[type .. "NWB"]["timerFrame" .. count]:SetFrameStrata("FULLSCREEN");
					_G[type .. "NWB"]["timerFrame" .. count]:SetFrameLevel(9);
					_G[type .. "NWB"]["timerFrame" .. count].fs = _G[type .. "NWB"]["timerFrame" .. count]:CreateFontString(k .. "NWBTimerFrameFS" .. count, "ARTWORK");
					_G[type .. "NWB"]["timerFrame" .. count].fs:SetPoint("CENTER", 0, 0.5);
					_G[type .. "NWB"]["timerFrame" .. count].fs:SetFont(NWB.regionFont, 12);
					_G[type .. "NWB"]["timerFrame" .. count].fs:SetText("00:00");
					--Outside frame layer text.
					_G[type .. "NWB"]["timerFrame" .. count].fs2 = _G[type .. "NWB"]["timerFrame" .. count]:CreateFontString(k .. "NWBTimerFrameFS2" .. count, "ARTWORK");
					_G[type .. "NWB"]["timerFrame" .. count].fs2:SetPoint("RIGHT", 17, 1);
					_G[type .. "NWB"]["timerFrame" .. count].fs2:SetFont(NWB.regionFont, 13);
					_G[type .. "NWB"]["timerFrame" .. count].fs2:SetText("|cff00ff00[L" .. count .. "]");
					_G[type .. "NWB"]["timerFrame" .. count]:SetWidth(_G[type .. "NWB"]["timerFrame" .. count].fs:GetStringWidth() + 14);
					_G[type .. "NWB"]["timerFrame" .. count]:SetHeight(_G[type .. "NWB"]["timerFrame" .. count].fs:GetStringHeight() + 9);
					frame = _G[type .. count .. "NWB"];
					if (not mapSFFrames[type]) then
						mapSFFrames[type] = {};
					end
					mapSFFrames[type][k] = count;
				end
			end
			if (frame) then
				local time = (NWB.data.layers[k][type] + 1500) - GetServerTime();
				if (NWB.db.global.showExpiredTimers and time < 1 and time > (0 - (60 * NWB.db.global.expiredTimersDuration))) then
					--Convert seconds left to positive.
					time = time * -1;
			    	local minutes = string.format("%02.f", math.floor(time / 60));
			    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
					--tooltipText = tooltipText .. "\n|Cffff2500"
					--		.. NWB:getTimeFormat(NWB.data[type] + 1500) .. " " .. L["spawn"] .. " (expired) (Layer " .. count .. ")|r";
					tooltipText = "|Cffff2500"
							.. NWB:getTimeFormat(NWB.data.layers[k][type] + 1500) .. " " .. L["spawn"] .. " (expired) (" .. L["Layer"] .. " " .. count .. ")|r\n" .. tooltipText
					frame.fs:SetText("|Cffff2500-" .. minutes .. ":" .. seconds);
					frame:SetWidth(42);
					frame:SetHeight(24);
					hasTimer = count;
					frame.hasTimer = true;
			  	elseif (time > 0) then
					--If timer is less than 25 minutes old then return time left.
			    	local minutes = string.format("%02.f", math.floor(time / 60));
			    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
			    	--tooltipText = tooltipText .. "\n" .. NWB:getTimeFormat(NWB.data[type] + 1500)
			    	--		.. " " .. L["spawn"] .. " (Layer " .. count .. ")";
			    	tooltipText = NWB:getTimeFormat(NWB.data.layers[k][type] + 1500)
			    			.. " " .. L["spawn"] .. " (" .. L["Layer"] .. " " .. count .. ")\n" .. tooltipText
					frame.fs:SetText(minutes .. ":" .. seconds);
					frame:SetWidth(42);
					frame:SetHeight(24);
					hasTimer = count;
					frame.hasTimer = true;
			  	else
			  		--tooltipText = tooltipText .. "\n" .. L["noTimer"] .. " (Layer " .. count .. ")";
			  		tooltipText = L["noTimer"] .. " (" .. L["Layer"] .. " " .. count .. ")\n" .. tooltipText
					frame:Hide();
					frame.fs:SetText(L["noTimer"]);
					frame:SetWidth(54);
					frame:SetHeight(22);
					frame.hasTimer = false;
				end
			end
		end
		if (hasTimer) then
			--Show all frames if any have an active timer.
			--[[for i = 1, count do
				if (i == 1) then
					_G[type .. "NWB"]["timerFrame"]:Show();
				elseif (_G[type .. "NWB"]["timerFrame" .. i]) then
					_G[type .. "NWB"]["timerFrame" .. i]:SetPoint("CENTER", 0, i * 18.5);
					_G[type .. "NWB"]["timerFrame" .. i]:Show();
				end
			end]]
			
			--Now we only show layers that have a timer instead.
			local offset = 0;
			for i = 1, count do
				if (i == 1) then
					if (_G[type .. "NWB"]["timerFrame"].hasTimer) then
						offset = offset + 18.5;
						_G[type .. "NWB"]["timerFrame"]:Show();
					end
				elseif (_G[type .. "NWB"]["timerFrame" .. i]) then
					if (_G[type .. "NWB"]["timerFrame" .. i].hasTimer) then
						offset = offset + 18.5;
						_G[type .. "NWB"]["timerFrame" .. i]:SetPoint("CENTER", 0, offset);
						_G[type .. "NWB"]["timerFrame" .. i]:Show();
					end
				end
			end
			
			--_G[type .. "NWB"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. tooltipText);
			_G[type .. "NWB"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n" .. tooltipText);
		else
			_G[type .. "NWB"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone);
			_G[type .. "NWB"].timerFrame:Hide(); --Bug fix for when no layers are recorded yet.
			_G[type .. "NWBMini"].timerFrame:Hide();
		end
		_G[type .. "NWB"].tooltip:SetWidth(_G[type .. "NWB"].tooltip.fs:GetStringWidth() + 9);
		_G[type .. "NWB"].tooltip:SetHeight(_G[type .. "NWB"].tooltip.fs:GetStringHeight() + 9);
	else
		--Seconds left.
		local time = (NWB.data[type] + 1500) - GetServerTime();
		if (NWB.db.global.showExpiredTimers and time < 1 and time > (0 - (60 * NWB.db.global.expiredTimersDuration))) then
			--Convert seconds left to positive.
			time = time * -1;
	    	local minutes = string.format("%02.f", math.floor(time / 60));
	    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
	    	_G[type .. "NWB"].timerFrame:Show();
	    	local tooltipText = "|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n"
					.. "|Cffff2500" .. NWB:getTimeFormat(NWB.data[type] + 1500) .. " " .. L["spawn"] .. " (expired)";
	    	_G[type .. "NWB"].tooltip.fs:SetText(tooltipText);
			_G[type .. "NWB"].tooltip:SetWidth(_G[type .. "NWB"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. "NWB"].tooltip:SetHeight(_G[type .. "NWB"].tooltip.fs:GetStringHeight() + 12);
			_G[type .. "NWB"].timerFrame.fs:SetText("|Cffff2500-" .. minutes .. ":" .. seconds);
	  	elseif (time > 0) then
			--If timer is less than 25 minutes old then return time left.
	    	local minutes = string.format("%02.f", math.floor(time / 60));
	    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
	    	_G[type .. "NWB"].timerFrame:Show();
	    	local tooltipText = "|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n"
	    			.. NWB:getTimeFormat(NWB.data[type] + 1500) .. " " .. L["spawn"];
	    	_G[type .. "NWB"].tooltip.fs:SetText(tooltipText);
			_G[type .. "NWB"].tooltip:SetWidth(_G[type .. "NWB"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. "NWB"].tooltip:SetHeight(_G[type .. "NWB"].tooltip.fs:GetStringHeight() + 12);
			_G[type .. "NWB"].timerFrame.fs:SetText(minutes .. ":" .. seconds);
	  	else
		  	_G[type .. "NWB"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone);
			_G[type .. "NWB"].tooltip:SetWidth(_G[type .. "NWB"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. "NWB"].tooltip:SetHeight(_G[type .. "NWB"].tooltip.fs:GetStringHeight() + 12);
		  	_G[type .. "NWB"].timerFrame:Hide();
		  	_G[type .. "NWB"].timerFrame.fs:SetText("");
		end
	end
end

--Update timer for minimap.
local minimapSFFrames = {};
function NWB:updateFelwoodMinimapMarker(type)
	if (NWB.layeredSongflowers and string.match(type, "flower")) then
		--Flowers are only updated once per second, not every frame.
		local count = 0;
		local tooltipText = "";
		local hasTimer;
		for k, v in pairs(minimapSFFrames) do
			--Remove any frames for any layer has been removed from db.
			--Note that layer1 frame is never added to the minimapSFFrames table, only extra layer frames are.
			--Layer 1 frame is the same frame non-layered realms use and will always be shown if any layer has a timer.
			for kk, vv in pairs(v) do
				if (not NWB.data.layers[tonumber(kk)]) then
					_G[k .. "NWBMini"]["timerFrame" .. vv]:Hide();
					_G[k .. "NWBMini"]["timerFrame" .. vv] = nil;
					minimapSFFrames[k][kk] = nil;
				end
			end
		end
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			local frame;
			if (count == 1) then
				frame = _G[type .. "NWBMini"].timerFrame;
				if (not _G[type .. "NWBMini"]["timerFrame"].fs2) then
					_G[type .. "NWBMini"]["timerFrame"].fs2 = _G[type .. "NWBMini"]["timerFrame"]:CreateFontString(k .. "NWBMiniTimerFrameFS2", "ARTWORK");
					_G[type .. "NWBMini"]["timerFrame"].fs2:SetPoint("RIGHT", 17, 1);
					_G[type .. "NWBMini"]["timerFrame"].fs2:SetFont(NWB.regionFont, 11);
					_G[type .. "NWBMini"]["timerFrame"].fs2:SetText("|cff00ff00[L" .. count .. "]");
				end
			else
				if (_G[type .. "NWBMini"]["timerFrame" .. count]) then
					frame = _G[type .. "NWBMini"]["timerFrame" .. count];
				else
					--Create frame if doesn't exist.
					_G[type .. "NWBMini"]["timerFrame" .. count] = CreateFrame("Frame", k.. "TimerFrameMini" .. count, _G[type .. "NWBMini"], "TooltipBorderedFrameTemplate");
					_G[type .. "NWBMini"]["timerFrame" .. count]:SetFrameStrata("FULLSCREEN");
					_G[type .. "NWBMini"]["timerFrame" .. count]:SetFrameLevel(9);
					_G[type .. "NWBMini"]["timerFrame" .. count].fs = _G[type .. "NWBMini"]["timerFrame" .. count]:CreateFontString(k .. "NWBMiniTimerFrameFS" .. count, "ARTWORK");
					_G[type .. "NWBMini"]["timerFrame" .. count].fs:SetPoint("CENTER", 0, 0.5);
					_G[type .. "NWBMini"]["timerFrame" .. count].fs:SetFont(NWB.regionFont, 12);
					_G[type .. "NWBMini"]["timerFrame" .. count].fs:SetText("00:00");
					--Outside frame layer text.
					_G[type .. "NWBMini"]["timerFrame" .. count].fs2 = _G[type .. "NWBMini"]["timerFrame" .. count]:CreateFontString(k .. "NWBMiniTimerFrameFS2" .. count, "ARTWORK");
					_G[type .. "NWBMini"]["timerFrame" .. count].fs2:SetPoint("RIGHT", 17, 1);
					_G[type .. "NWBMini"]["timerFrame" .. count].fs2:SetFont(NWB.regionFont, 11);
					_G[type .. "NWBMini"]["timerFrame" .. count].fs2:SetText("|cff00ff00[L" .. count .. "]");
					_G[type .. "NWBMini"]["timerFrame" .. count]:SetWidth(_G[type .. "NWBMini"]["timerFrame" .. count].fs:GetStringWidth() + 14);
					_G[type .. "NWBMini"]["timerFrame" .. count]:SetHeight(_G[type .. "NWBMini"]["timerFrame" .. count].fs:GetStringHeight() + 9);
					frame = _G[type .. count .. "NWBMini"];
					if (not minimapSFFrames[type]) then
						minimapSFFrames[type] = {};
					end
					minimapSFFrames[type][k] = count;
				end
			end
			if (frame) then
				local time = 0
				local time = (NWB.data.layers[k][type] + 1500) - GetServerTime();
				if (NWB.db.global.showExpiredTimers and time < 1 and time > (0 - (60 * NWB.db.global.expiredTimersDuration))) then
					--Convert seconds left to positive.
					time = time * -1;
			    	local minutes = string.format("%02.f", math.floor(time / 60));
			    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
					--tooltipText = tooltipText .. "\n|Cffff2500"
					--		.. NWB:getTimeFormat(NWB.data.layers[k][type] + 1500) .. " " .. L["spawn"] .. " (expired) (Layer " .. count .. ")|r";
					tooltipText = "|Cffff2500"
							.. NWB:getTimeFormat(NWB.data.layers[k][type] + 1500) .. " " .. L["spawn"] .. " (expired) (" .. L["Layer"] .. " " .. count .. ")|r\n" .. tooltipText;
					frame.fs:SetText("|Cffff2500-" .. minutes .. ":" .. seconds);
					frame:SetWidth(frame.fs:GetStringWidth() + 14);
					frame:SetHeight(frame.fs:GetStringHeight() + 9);
					frame.hasTimer = true;
					hasTimer = count;
			  	elseif (time > 0) then
					--If timer is less than 25 minutes old then return time left.
			    	local minutes = string.format("%02.f", math.floor(time / 60));
			    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
			    	--tooltipText = tooltipText .. "\n" .. NWB:getTimeFormat(NWB.data.layers[k][type] + 1500)
			    	--		.. " " .. L["spawn"] .. " (Layer " .. count .. ")";
			    	tooltipText =  NWB:getTimeFormat(NWB.data.layers[k][type] + 1500)
			    			.. " " .. L["spawn"] .. " (" .. L["Layer"] .. " " .. count .. ")\n" .. tooltipText;
					frame.fs:SetText(minutes .. ":" .. seconds);
					frame:SetWidth(frame.fs:GetStringWidth() + 14);
					frame:SetHeight(frame.fs:GetStringHeight() + 9);
					hasTimer = count;
					frame.hasTimer = true;
			  	else
			  		--tooltipText = tooltipText .. "\n" .. L["noTimer"] .. " (Layer " .. count .. ")";
			  		tooltipText = L["noTimer"] .. " (" .. L["Layer"] .. " " .. count .. ")\n" .. tooltipText;
					frame:Hide();
					frame.fs:SetText(L["noTimer"]);
					frame:SetWidth(frame.fs:GetStringWidth() + 14);
					frame:SetHeight(frame.fs:GetStringHeight() + 9);
					frame.hasTimer = false;
				end
			end
		end
		if (hasTimer) then
			--Show all frames if any have an active timer.
			--[[for i = 1, count do
				if (i == 1) then
					_G[type .. "NWBMini"]["timerFrame"]:Show();
				elseif (_G[type .. "NWBMini"]["timerFrame" .. i]) then
					_G[type .. "NWBMini"]["timerFrame" .. i]:SetPoint("CENTER", 0, i * 18);
					_G[type .. "NWBMini"]["timerFrame" .. i]:Show();
				end
			end]]
			
			--Now we only show layers that have a timer instead.
			local offset = 0;
			for i = 1, count do
				if (i == 1) then
					if (_G[type .. "NWBMini"]["timerFrame"].hasTimer) then
						offset = offset + 18;
						_G[type .. "NWBMini"]["timerFrame"]:Show();
					end
				elseif (_G[type .. "NWBMini"]["timerFrame" .. i]) then
					if (_G[type .. "NWBMini"]["timerFrame" .. i].hasTimer) then
						offset = offset + 18;
						_G[type .. "NWBMini"]["timerFrame" .. i]:SetPoint("CENTER", 0, offset);
						_G[type .. "NWBMini"]["timerFrame" .. i]:Show();
					end
				end
			end
			
			--_G[type .. "NWBMini"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. tooltipText);
			_G[type .. "NWBMini"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n" .. tooltipText);
		else
			_G[type .. "NWBMini"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone);
			_G[type .. "NWBMini"].timerFrame:Hide();
		end
		_G[type .. "NWBMini"].tooltip:SetWidth(_G[type .. "NWBMini"].tooltip.fs:GetStringWidth() + 9);
		_G[type .. "NWBMini"].tooltip:SetHeight(_G[type .. "NWBMini"].tooltip.fs:GetStringHeight() + 9);
	else
		--Seconds left.
		local time = (NWB.data[type] + 1500) - GetServerTime();
		if (NWB.db.global.showExpiredTimers and time < 1 and time > (0 - (60 * NWB.db.global.expiredTimersDuration))) then
			--Convert seconds left to positive.
			time = time * -1;
	    	local minutes = string.format("%02.f", math.floor(time / 60));
	    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
	    	_G[type .. "NWBMini"].timerFrame:Show();
			local tooltipText = "|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n"
					.. "|Cffff2500" .. NWB:getTimeFormat(NWB.data[type] + 1500) .. " " .. L["spawn"] .. " (expired)";
	    	_G[type .. "NWBMini"].tooltip.fs:SetText(tooltipText);
	    	_G[type .. "NWBMini"].tooltip:SetWidth(_G[type .. "NWBMini"].tooltip.fs:GetStringWidth() + 9);
			_G[type .. "NWBMini"].tooltip:SetHeight(_G[type .. "NWBMini"].tooltip.fs:GetStringHeight() + 9);
			_G[type .. "NWBMini"].timerFrame.fs:SetText("|Cffff2500-" .. minutes .. ":" .. seconds);
	  	elseif (time > 0) then
			--If timer is less than 25 minutes old then return time left.
	    	local minutes = string.format("%02.f", math.floor(time / 60));
	    	local seconds = string.format("%02.f", math.floor(time - minutes * 60));
	    	_G[type .. "NWBMini"].timerFrame:Show();
	    	local tooltipText = "|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone .. "\n"
	    			.. NWB:getTimeFormat(NWB.data[type] + 1500) .. " " .. L["spawn"];
	    	_G[type .. "NWBMini"].tooltip.fs:SetText(tooltipText);
	    	_G[type .. "NWBMini"].tooltip:SetWidth(_G[type .. "NWBMini"].tooltip.fs:GetStringWidth() + 9);
			_G[type .. "NWBMini"].tooltip:SetHeight(_G[type .. "NWBMini"].tooltip.fs:GetStringHeight() + 9);
			_G[type .. "NWBMini"].timerFrame.fs:SetText(minutes .. ":" .. seconds);
	  	else
			_G[type .. "NWBMini"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWB"].name .. "|r\n" .. _G[type .. "NWB"].subZone);
			_G[type .. "NWBMini"].tooltip:SetWidth(_G[type .. "NWBMini"].tooltip.fs:GetStringWidth() + 9);
			_G[type .. "NWBMini"].tooltip:SetHeight(_G[type .. "NWBMini"].tooltip.fs:GetStringHeight() + 9);
			_G[type .. "NWBMini"].timerFrame:Hide();
			_G[type .. "NWBMini"].timerFrame.fs:SetText(L["noTimer"]);
		end
	end
end

function NWB:createSongflowerMarkers()
	local iconLocation = "Interface\\Icons\\spell_holy_mindvision";
	for k, v in pairs(NWB.songFlowers) do
		--Worldmap marker.
		local obj = CreateFrame("Frame", k .. "NWB", WorldMapFrame);
		obj.type = k;
		obj.name = L["Songflower"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(15, 15);
		--World map tooltip.
		obj.tooltip = CreateFrame("Frame", k .. "Tooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -36);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 12);
		obj.tooltip.fs:SetText("|CffDEDE42" .. L["Songflower"] .. "|r\n" .. v.subZone);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrame", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", obj, "CENTER", 0, 20);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 13);
		obj.timerFrame:SetWidth(42);
		obj.timerFrame:SetHeight(24);
		obj.lastUpdate = 0;
		obj:SetScript("OnUpdate", function(self)
			if (GetServerTime() - obj.lastUpdate < 1) then
				--1 second throddle.
				return;
			end
			--Update timer when map is open.
			NWB:updateFelwoodWorldmapMarker(obj.type);
			obj.lastUpdate = GetServerTime();
		end)
		--Make it act like pin is the parent and not WorldMapFrame.
		obj:SetScript("OnHide", function(self)
			obj.timerFrame:Hide();
		end)
		obj:SetScript("OnShow", function(self)
			obj.timerFrame:Show();
		end)
		obj:SetScript("OnMouseDown", function(self, button)
			if (IsShiftKeyDown()) then
				local time = (NWB.data[obj.type] + 1500) - GetServerTime();
				if (NWB.isLayered and NWB.layeredSongflowers and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
							and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
					time = (NWB.data.layers[NWB.lastKnownLayerMapID][obj.type] + 1500) - GetServerTime();
				end
				if (time > 0) then
					local msg = string.format(L["singleSongflowerMsg"], NWB.songFlowers[obj.type].subZone, NWB:getTimeString(time, true));
					if (NWB.isLayered and NWB.layeredSongflowers and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
							and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
						msg = msg .. " (" .. L["Layer"] .. " " .. NWB.lastKnownLayer .. ")";
					elseif (NWB.isLayered and NWB.layeredSongflowers) then
						NWB:print("No layer currently known for Felwood, try targetting a NPC.");
						return;
					end
					if (button == "RightButton") then
						SendChatMessage("[NovaWorldBuffs] " .. msg, "say");
					else
						SendChatMessage("[WorldBuffs] " .. msg .. " (" .. NWB.songFlowers[obj.type].x .. ", " .. NWB.songFlowers[obj.type].y .. ")", "guild");
					end
				else
					NWB:print(L["noTimer"] .. " (" .. NWB.songFlowers[obj.type].subZone .. ").");
				end
			else
				NWB:openBuffListFrame();
			end
		end)
		
		--Minimap marker.
		local obj = CreateFrame("FRAME", k .. "NWBMini");
		obj.type = k;
		obj.name = L["Songflower"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(12, 12);
		--Minimap tooltip.
		obj.tooltip = CreateFrame("Frame", k.. "Tooltip", MinimMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 18);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 8.5);
		obj.tooltip.fs:SetText("00:00");
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 9);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrameMini", obj, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", 0, 18);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0.5);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 12);
		obj.timerFrame.fs:SetText("00:00");
		obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
		obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		obj.lastUpdate = 0;
		obj:SetScript("OnUpdate", function(self)
			if (GetServerTime() - obj.lastUpdate < 1) then
				--1 second throddle.
				return;
			end
			--Update timer when minimap icon is in range.
			NWB:updateFelwoodMinimapMarker(obj.type);
			obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
			obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
			obj.lastUpdate = GetServerTime();
		end)
		obj.tooltip:Hide();
		obj:SetScript("OnMouseDown", function(self, button)
			if (IsShiftKeyDown()) then
				local time = (NWB.data[obj.type] + 1500) - GetServerTime();
				if (NWB.isLayered and NWB.layeredSongflowers and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
							and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
					time = (NWB.data.layers[NWB.lastKnownLayerMapID][obj.type] + 1500) - GetServerTime();
				end
				if (time > 0) then
					local msg = string.format(L["singleSongflowerMsg"], NWB.songFlowers[obj.type].subZone, NWB:getTimeString(time, true));
					if (NWB.isLayered and NWB.layeredSongflowers and NWB:GetLayerCount() >= 2 and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
							and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
						msg = msg .. " (" .. L["Layer"] .. " " .. NWB.lastKnownLayer .. ")";
					elseif (NWB.isLayered and NWB.layeredSongflowers) then
						NWB:print("No layer currently known for Felwood, try targetting a NPC.");
						return;
					end
					if (button == "RightButton") then
						SendChatMessage("[NovaWorldBuffs] " .. msg, "say");
					else
						SendChatMessage("[WorldBuffs] " .. msg .. " (" .. NWB.songFlowers[obj.type].x .. ", " .. NWB.songFlowers[obj.type].y .. ")", "guild");
					end
				else
					NWB:print(L["noTimer"] .. " (" .. NWB.songFlowers[obj.type].subZone .. ").");
				end
			else
				NWB:openBuffListFrame();
			end
		end)
	end
end

function NWB:createTuberMarkers()
	local iconLocation = "Interface\\Icons\\inv_misc_food_55";
	for k, v in pairs(NWB.tubers) do
		--Worldmap marker.
		local obj = CreateFrame("Frame", k .. "NWB", WorldMapFrame);
		obj.type = k;
		obj.name = L["Whipper Root Tuber"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(12, 12);
		--World map tooltip.
		obj.tooltip = CreateFrame("Frame", k.. "Tooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -36);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 12);
		obj.tooltip.fs:SetText("|CffDEDE42" .. L["Songflower"] .. "|r\n" .. v.subZone);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrame", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", obj, "CENTER", 0, 17);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 11);
		obj.timerFrame:SetWidth(38);
		obj.timerFrame:SetHeight(20);
		obj:SetScript("OnUpdate", function(self)
			--Update timer when map is open.
			NWB:updateFelwoodWorldmapMarker(obj.type);
			--obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 15);
			--obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		end)
		--Make it act like pin is the parent and not WorldMapFrame.
		obj:SetScript("OnHide", function(self)
			obj.timerFrame:Hide();
		end)
		obj:SetScript("OnShow", function(self)
			obj.timerFrame:Show();
		end)
		obj:SetScript("OnMouseDown", function(self)
			NWB:openBuffListFrame();
		end)
		
		--Minimap marker.
		local obj = CreateFrame("FRAME", k .. "NWBMini");
		obj.type = k;
		obj.name = L["Whipper Root Tuber"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(12, 12);
		--Minimap tooltip.
		obj.tooltip = CreateFrame("Frame", k.. "Tooltip", MinimMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 18);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 8.5);
		obj.tooltip.fs:SetText("00:00");
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 9);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrameMini", obj, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", 0, 18);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0.5);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 12);
		obj.timerFrame.fs:SetText("00:00");
		obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
		obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		--Changed to show minimap timer awlways instead of on hover (if timer is active).
		obj:SetScript("OnUpdate", function(self)
			--Update timer when minimap icon is in range.
			NWB:updateFelwoodMinimapMarker(obj.type);
			obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
			obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		end)
		obj.tooltip:Hide();
		obj:SetScript("OnMouseDown", function(self)
			NWB:openBuffListFrame();
		end)
	end
end

function NWB:createDragonMarkers()
	local iconLocation = "Interface\\Icons\\inv_misc_food_45";
	for k, v in pairs(NWB.dragons) do
		--Worldmap marker.
		local obj = CreateFrame("Frame", k .. "NWB", WorldMapFrame);
		obj.type = k;
		obj.name = L["Night Dragon's Breath"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(12, 12);
		--World map tooltip.
		obj.tooltip = CreateFrame("Frame", k.. "Tooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -36);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 12);
		obj.tooltip.fs:SetText("|CffDEDE42" .. L["Songflower"] .. "|r\n" .. v.subZone);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrame", WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", obj, "CENTER", 0, 17);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 11);
		obj.timerFrame:SetWidth(38);
		obj.timerFrame:SetHeight(20);
		obj:SetScript("OnUpdate", function(self)
			--Update timer when map is open.
			NWB:updateFelwoodWorldmapMarker(obj.type);
			--obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 15);
			--obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		end)
		--Make it act like pin is the parent and not WorldMapFrame.
		obj:SetScript("OnHide", function(self)
			obj.timerFrame:Hide();
		end)
		obj:SetScript("OnShow", function(self)
			obj.timerFrame:Show();
		end)
		obj:SetScript("OnMouseDown", function(self)
			NWB:openBuffListFrame();
		end)
		
		--Minimap marker.
		local obj = CreateFrame("FRAME", k .. "NWBMini");
		obj.type = k;
		obj.name = L["Night Dragon's Breath"];
		obj.subZone = v.subZone;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(iconLocation);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(12, 12);
		--Minimap tooltip.
		obj.tooltip = CreateFrame("Frame", k.. "Tooltip", MinimMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 18);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString(k .. "NWBTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 8.5);
		obj.tooltip.fs:SetText("00:00");
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 9);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", k.. "TimerFrameMini", obj, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", 0, 18);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(k .. "NWBTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0.5);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 12);
		obj.timerFrame.fs:SetText("00:00");
		obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
		obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		--Changed to show minimap timer awlways instead of on hover (if timer is active).
		obj:SetScript("OnUpdate", function(self)
			--Update timer when minimap icon is in range.
			NWB:updateFelwoodMinimapMarker(obj.type);
			obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 14);
			obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 9);
		end)
		obj.tooltip:Hide();
		obj:SetScript("OnMouseDown", function(self)
			NWB:openBuffListFrame();
		end)
	end
end

function NWB:refreshFelwoodMarkers()
	for k, v in pairs(NWB.songFlowers) do
		NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWB", _G[k .. "NWB"]);
		NWB.dragonLibPins:RemoveMinimapIcon(k .. "NWBMini", _G[k .. "NWBMini"]);
		if (NWB.db.global.showSongflowerWorldmapMarkers) then
			NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWB", _G[k .. "NWB"], 1448, v.x/100, v.y/100);
		end
		if (NWB.db.global.showSongflowerMinimapMarkers) then
			NWB.dragonLibPins:AddMinimapIconMap(k .. "NWBMini", _G[k .. "NWBMini"], 1448, v.x/100, v.y/100);
		end
	end
	for k, v in pairs(NWB.tubers) do
		NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWB", _G[k .. "NWB"]);
		NWB.dragonLibPins:RemoveMinimapIcon(k .. "NWBMini", _G[k .. "NWBMini"]);
		if (NWB.db.global.showTuberWorldmapMarkers) then
			NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWB", _G[k .. "NWB"], 1448, v.x/100, v.y/100);
		end
		if (NWB.db.global.showTuberMinimapMarkers) then
			NWB.dragonLibPins:AddMinimapIconMap(k .. "NWBMini", _G[k .. "NWBMini"], 1448, v.x/100, v.y/100);
		end
	end
	for k, v in pairs(NWB.dragons) do
		NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWB", _G[k .. "NWB"]);
		NWB.dragonLibPins:RemoveMinimapIcon(k .. "NWBMini", _G[k .. "NWBMini"]);
		if (NWB.db.global.showDragonWorldmapMarkers) then
			NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWB", _G[k .. "NWB"], 1448, v.x/100, v.y/100);
		end
		if (NWB.db.global.showDragonMinimapMarkers) then
			NWB.dragonLibPins:AddMinimapIconMap(k .. "NWBMini", _G[k .. "NWBMini"], 1448, v.x/100, v.y/100);
		end
	end
end

---====================---
---Worldbuff Map Frames---
---====================---

--Update timers for worldmap when the map is open.
function NWB:updateWorldbuffMarkers(type, layer)
	if (noWorldBuffTimers) then
		if (NWB.isLayered and layer) then
			if (type == "ony") then
				local count = 0;
				local layerZoneID = 0;
				for k, v in NWB:pairsByKeys(NWB.data.layers) do
					count = count + 1;
					if (k == tonumber(layer)) then
						layerZoneID = k;
						break;
					end
				end
				_G[type .. layer .. "NWBWorldMap"].fsLayer:SetText("|cff00ff00[" .. L["Layer"] .. " " .. count.. "] |cFFB5E0E6(" .. layerZoneID .. ")");
			end
			_G[type .. layer .. "NWBWorldMap"].tooltip.fs:SetText("Blizzard disabled timers for\nEra/Sod during patch 1.15.3");
			_G[type .. layer .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. layer .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
		else
			_G[type .. "NWBWorldMap"].tooltip.fs:SetText("Blizzard disabled timers for\nEra/Sod during patch 1.15.3");
			_G[type .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
		end
		return L["noTimer"];
	end
	--Seconds left.
	local time = 0;
	if (NWB.isLayered and layer) then
		--I've adapted this to show all layers at once on the world map.
		--Its ugly here so I don't have to change a lot of code elsewhere and it can keep using most of the non-layered stuff.
		if (type == "ony") then
			local count = 0;
			local layerZoneID = 0;
			for k, v in NWB:pairsByKeys(NWB.data.layers) do
				count = count + 1;
				if (k == tonumber(layer)) then
					layerZoneID = k;
					break;
				end
			end
			_G[type .. layer .. "NWBWorldMap"].fsLayer:SetText("|cff00ff00[" .. L["Layer"] .. " " .. count.. "] |cFFB5E0E6(" .. layerZoneID .. ")");
		end
		if (NWB.data.layers[layer]) then
			time = (NWB.data.layers[layer][type .. "Timer"] + NWB[type .. "CooldownTime"]) - GetServerTime() or 0;
		else
			time = 0;
		end
		if (NWB[type .. "CooldownTime"] < 1) then
			time = 0;
		end
		local npcKilled;
		if (type == "ony" or type == "nef") then
			if (NWB.data.layers[layer] and NWB.data.layers[layer][type .. "NpcDied"] and NWB.data.layers[layer][type .. "Timer"]
					and (NWB.data.layers[layer][type .. "NpcDied"] > NWB.data.layers[layer][type .. "Timer"]) and not NWB.db.global.ignoreKillData) then
				local killedAgo = NWB:getTimeString(GetServerTime() - NWB.data.layers[layer][type .. "NpcDied"], true) 
				local tooltipString = "|CffDEDE42" .. _G[type .. layer .. "NWBWorldMap"].name .. "\n"
	    				.. L["noTimer"] .. "\n"
	    				.. string.format(L["anyNpcKilledWithTimer"], killedAgo);
	    		_G[type .. layer .. "NWBWorldMap"].tooltip.fs:SetText(tooltipString);
	    		_G[type .. layer .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
				_G[type .. layer .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
				npcKilled = true;
			end
		end
		local timeStringShort;
		if (NWB.data.layers[layer] and _G[type .. layer .. "NWBWorldMap"] and time > 0 and not npcKilled) then
	    	local timeString = NWB:getTimeString(time, true);
	    	timeStringShort = NWB:getTimeString(time, true, "short");
	    	local timeStamp = NWB:getTimeFormat(NWB.data.layers[layer][type .. "Timer"] + NWB[type .. "CooldownTime"]);
	    	local tooltipString = "|CffDEDE42" .. _G[type .. layer .. "NWBWorldMap"].name .. "\n"
	    			.. timeString .. "\n"
	    			.. timeStamp;
	    	_G[type .. layer .. "NWBWorldMap"].tooltip.fs:SetText(tooltipString);
	    	_G[type .. layer .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. layer .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. layer .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
	  	elseif (not npcKilled) then
	  		_G[type .. layer .. "NWBWorldMap"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. layer .. "NWBWorldMap"].name);
	  	end
		local _, _, zone = NWB:GetPlayerZonePosition();
		--Disabled some of the clutter on world map now, don't need the details instructions anymore I think.
		--[[if (_G["nef" .. layer .. "NWBWorldMap"] and _G["nef" .. layer .. "NWBWorldMap"].noLayerFrame) then
			if (NWB.faction == "Horde" and zone == 1454) then
				if (NWB.currentLayer > 0) then
					--local layerMsg = L["cityMapLayerMsgHorde"];
					--local layerString = "|cff00ff00[Layer " .. NWB.currentLayer .. "]|cff9CD6DE";
					--_G["nef" .. layer .. "NWBWorldMap"].fs2:SetText("|cff9CD6DE" .. string.format(layerMsg, layerString));
					_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Hide();
				else
					_G["nef" .. layer .. "NWBWorldMap"].fs2:SetText("");
					_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Show();
				end
			elseif (NWB.faction == "Alliance" and zone == 1453) then
				if (NWB.currentLayer > 0) then
					--local layerMsg = L["cityMapLayerMsgAlliance"];
					--local layerString = "|cff00ff00[Layer " .. NWB.currentLayer .. "]|cff9CD6DE";
					--_G["nef" .. layer .. "NWBWorldMap"].fs2:SetText("|cff9CD6DE" .. string.format(layerMsg, layerString));
					_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Hide();
				else
					local mapID;
					if (WorldMapFrame) then
						mapID = WorldMapFrame:GetMapID();
					end
					if (mapID == 1413 or mapID == 1454) then
						--Hide in the barrens or org for alliance.
						_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Hide();
					else
						_G["nef" .. layer .. "NWBWorldMap"].fs2:SetText("");
						_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Show();
					end
				end
			else
				_G["nef" .. layer .. "NWBWorldMap"].noLayerFrame:Show();
			end
		end]]
		if (time > 0 and not npcKilled) then
	    	return timeStringShort;
	  	end
	  	if (not npcKilled) then
	  		_G[type .. layer .. "NWBWorldMap"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. layer .. "NWBWorldMap"].name);
	  	end
		return L["noTimer"];
	else
		time = (NWB.data[type .. "Timer"] + NWB[type .. "CooldownTime"]) - GetServerTime();
		if (NWB[type .. "CooldownTime"] < 1) then
			time = 0;
		end
		if (type == "ony" or type == "nef") then
			if (NWB.data[type .. "NpcDied"] > NWB.data[type .. "Timer"] and not NWB.db.global.ignoreKillData) then
				local killedAgo = NWB:getTimeString(GetServerTime() - NWB.data[type .. "NpcDied"], true) 
				local tooltipString = "|CffDEDE42" .. _G[type .. "NWBWorldMap"].name .. "\n"
	    				.. L["noTimer"] .. "\n"
	    				.. string.format(L["anyNpcKilledWithTimer"], killedAgo);
	    		_G[type .. "NWBWorldMap"].tooltip.fs:SetText(tooltipString);
	    		_G[type .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
				_G[type .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
				return L["noTimer"];
			end
		end
		if (time > 0) then
	    	local timeString = NWB:getTimeString(time, true);
	    	local timeStringShort = NWB:getTimeString(time, true, "short");
	    	local timeStamp = 0;
	    	if (type == "zanCity" or type == "zanStv") then
	    		timeStamp = NWB:getTimeFormat(NWB.data["zanTimer"] + NWB.zanCooldownTime);
	    	else
	    		timeStamp = NWB:getTimeFormat(NWB.data[type .. "Timer"] + NWB[type .. "CooldownTime"]);
	    	end
	    	local tooltipString = "|CffDEDE42" .. _G[type .. "NWBWorldMap"].name .. "\n"
	    			.. timeString .. "\n"
	    			.. timeStamp;
	    	_G[type .. "NWBWorldMap"].tooltip.fs:SetText(tooltipString);
	    	_G[type .. "NWBWorldMap"].tooltip:SetWidth(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringWidth() + 18);
			_G[type .. "NWBWorldMap"].tooltip:SetHeight(_G[type .. "NWBWorldMap"].tooltip.fs:GetStringHeight() + 12);
	    	return timeStringShort;
	  	end
	  	_G[type .. "NWBWorldMap"].tooltip.fs:SetText("|CffDEDE42" .. _G[type .. "NWBWorldMap"].name);
		return L["noTimer"];
	end
end

function NWB:createWorldbuffMarkersTable()
	if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
		--Adjust for icon position non-english fonts in the timer frame.
    	if (NWB.faction == "Alliance") then
			NWB.worldBuffMapMarkerTypes = {
				["rend"] = {x = 71.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]},
				["ony"] = {x = 79.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]},
				["nef"] = {x = 87.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]},
				--["zanCity"] = {x = 95.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
				--["zanStv"] = {x = 11.0, y = 20.5, mapID = 1434, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
			};
		else
			NWB.worldBuffMapMarkerTypes = {
				["rend"] = {x = 60.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]},
				["ony"] = {x = 68, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]},
				["nef"] = {x = 76.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]},
				--["zanCity"] = {x = 84.0, y = 79.0, mapID = 1454, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
				--["zanStv"] = {x = 11.0, y = 20.5, mapID = 1434, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
			};
		end
	else
		if (NWB.faction == "Alliance") then
			NWB.worldBuffMapMarkerTypes = {
				["rend"] = {x = 78.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]},
				["ony"] = {x = 83.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]},
				["nef"] = {x = 88.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]},
				--["zanCity"] = {x = 90.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
				--["zanStv"] = {x = 11.0, y = 20.5, mapID = 1434, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
			};
		else
			NWB.worldBuffMapMarkerTypes = {
				["rend"] = {x = 63.0, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]},
				["ony"] = {x = 68, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]},
				["nef"] = {x = 73.0, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]},
				--["zanCity"] = {x = 75.5, y = 79.0, mapID = 1454, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
				--["zanStv"] = {x = 11.0, y = 20.5, mapID = 1434, icon = "Interface\\Icons\\ability_creature_poison_05", name = L["Zandalar"]},
			};
		end
	end
	if (WorldMapFrame) then
		hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
			NWB:refreshWorldbuffMarkers();
		end)
		hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", function()
			NWB:refreshWorldbuffMarkers();
		end)
	end
end

function NWB:createWorldbuffMarkers()
	if (NWB.isLayered) then
		local count = 0;
		for layer, data in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				if (not _G[k .. layer .. "NWBWorldMap"]) then
					NWB:createWorldbuffMarker(k, v, layer, count);
				end
			end
		end
	end
	--Create non layered icons also on layered realms, they are shown when no layers found.
	for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
		NWB:createWorldbuffMarker(k, v);
	end
	NWB:refreshWorldbuffMarkers();
end

local mapMarkers = {};
function NWB:createWorldbuffMarker(type, data, layer, count)
	if (layer) then
		if (not _G[type .. layer .. "NWBWorldMap"]) then
			--Worldmap marker.
			local obj = CreateFrame("Frame", type .. layer .. "NWBWorldMap", WorldMapFrame);
			obj.name = data.name;
			local bg = obj:CreateTexture(nil, "ARTWORK");
			bg:SetTexture(data.icon);
			bg:SetAllPoints(obj);
			obj.texture = bg;
			obj:SetSize(23, 23);
			--Worldmap tooltip.
			obj.tooltip = CreateFrame("Frame", type .. layer .. "WorldMapTooltip", obj, "TooltipBorderedFrameTemplate");
			obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -46);
			--obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -26);
			obj.tooltip:SetFrameStrata("TOOLTIP");
			obj.tooltip:SetFrameLevel(9999);
			obj.tooltip.fs = obj.tooltip:CreateFontString(type .. layer .. "NWBWorldMapTooltipFS", "ARTWORK");
			obj.tooltip.fs:SetPoint("CENTER", 0, 0);
			obj.tooltip.fs:SetFont(NWB.regionFont, 14);
			obj.tooltip.fs:SetText("|CffDEDE42" .. data.name);
			obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
			obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
			--obj.tooltip:SetParent(WorldMapFrame); --Make tooltip float on top of other pins.
			obj:SetScript("OnEnter", function(self)
				obj.tooltip:Show();
			end)
			obj:SetScript("OnLeave", function(self)
				obj.tooltip:Hide();
			end)
			obj.tooltip:Hide();
			--Timer frame that sits above the icon when an active timer is found.
			obj.timerFrame = CreateFrame("Frame", type .. layer .. "WorldMapTimerFrame", obj, "TooltipBorderedFrameTemplate");
			obj.timerFrame:SetPoint("CENTER", obj, "CENTER",  0, 21);
			obj.timerFrame:SetFrameStrata("FULLSCREEN");
			obj.timerFrame:SetFrameLevel(9);
			obj.timerFrame.fs = obj.timerFrame:CreateFontString(type .. "NWBWorldMapTimerFrameFS", "ARTWORK");
			obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
			obj.timerFrame.fs:SetFont(NWB.regionFont, 13);
			obj.timerFrame:SetWidth(54);
			obj.timerFrame:SetHeight(24);
			obj:SetScript("OnUpdate", function(self)
				--Update timer when map is open.
				obj.timerFrame.fs:SetText(NWB:updateWorldbuffMarkers(type, layer));
				--Adjust for non-english fonts.
				if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW or LOCALE_ruRU) then
					obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 18);
					obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 12);
				end
			end)
			--Make it act like pin is the parent and not WorldMapFrame.
			obj:SetScript("OnHide", function(self)
				obj.timerFrame:Hide();
			end)
			obj:SetScript("OnShow", function(self)
				obj.timerFrame:Show();
			end)
			if (type == "nef" and count == 1) then
				--/buffs text below the city map icons.
				obj.fs = obj:CreateFontString(type .. "NWBWorldMapBuffCmdFS", "ARTWORK");
				obj.fs:SetFont(NWB.regionFont, 14);
				obj.fs:SetText("|CffDEDE42" .. L["worldMapBuffsMsg"]);
				--Layer info text above the city map icons.
				obj.noLayerFrame = CreateFrame("Frame", type.. "WorldMapNoLayerFrame", obj, "TooltipBorderedFrameTemplate");
				obj.noLayerFrame:SetFrameStrata("FULLSCREEN");
				obj.noLayerFrame:SetFrameLevel(9);
				obj.noLayerFrame:SetAlpha(.85);
				obj.noLayerFrame.fs = obj.noLayerFrame:CreateFontString(type .. "NWBWorldMapNoLayerFS", "ARTWORK");
				obj.noLayerFrame.fs:SetPoint("CENTER", 0, 0);
				obj.noLayerFrame.fs:SetFont(NWB.regionFont, 14);
				obj.fs2 = obj:CreateFontString(type .. "NWBWorldMapLayerInfoFS", "ARTWORK");
				obj.fs2:SetFont(NWB.regionFont, 14);
				if (NWB.faction == "Horde") then
					obj.fs:SetPoint("RIGHT", -180, 20);
					obj.noLayerFrame:SetPoint("CENTER", obj, "CENTER",  -255, 70);
					obj.fs2:SetPoint("CENTER", -260, 80);
					obj.noLayerFrame.fs:SetText("|cff9CD6DE" .. L["noLayerYetHorde"]);
				else
					obj.fs:SetPoint("RIGHT", 0, -35);
					obj.noLayerFrame:SetPoint("CENTER", obj, "CENTER",  -195, 20);
					obj.fs2:SetPoint("CENTER", -195, 20);
					obj.noLayerFrame.fs:SetText("|cff9CD6DE" .. L["noLayerYetAlliance"]);
				end
				obj.noLayerFrame:SetWidth(obj.noLayerFrame.fs:GetStringWidth() + 4);
				obj.noLayerFrame:SetHeight(obj.noLayerFrame.fs:GetStringHeight() + 12);
				obj.noLayerFrame:Hide();
			end
			if (type == "ony") then
				--Attach layer text to ony frame.
				obj.fsLayer = obj:CreateFontString(type .. "NWBWorldMapLayerFS", "ARTWORK");
				if (NWB.faction == "Alliance" and not NWB.db.global.allianceEnableRend) then
					--If only 2 icons are shown for alliance move the layer text across a bit.
					obj.fsLayer:SetPoint("TOP", 32, 35);
				else
					obj.fsLayer:SetPoint("TOP", 0, 35);
				end
				obj.fsLayer:SetFont(NWB.regionFont, 14);
			end
			obj:SetScript("OnMouseDown", function(self)
				NWB:openBuffListFrame();
			end)
			mapMarkers[type .. layer .. "NWBWorldMap"] = true;
		end
	else
		--Worldmap marker.
		local obj = CreateFrame("Frame", type .. "NWBWorldMap", WorldMapFrame);
		obj.name = data.name;
		local bg = obj:CreateTexture(nil, "ARTWORK");
		bg:SetTexture(data.icon);
		bg:SetAllPoints(obj);
		obj.texture = bg;
		obj:SetSize(23, 23);
		--Worldmap tooltip.
		obj.tooltip = CreateFrame("Frame", type.. "WorldMapTooltip", obj, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, -46);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9999);
		obj.tooltip.fs = obj.tooltip:CreateFontString(type .. "NWBWorldMapTooltipFS", "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0);
		obj.tooltip.fs:SetFont(NWB.regionFont, 14);
		obj.tooltip.fs:SetText("|CffDEDE42" .. data.name);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
		--obj.tooltip:SetParent(WorldMapFrame); --Make tooltip float on top of other pins.
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		--Timer frame that sits above the icon when an active timer is found.
		obj.timerFrame = CreateFrame("Frame", type.. "WorldMapTimerFrame", obj, "TooltipBorderedFrameTemplate");
		obj.timerFrame:SetPoint("CENTER", obj, "CENTER",  0, 21);
		obj.timerFrame:SetFrameStrata("FULLSCREEN");
		obj.timerFrame:SetFrameLevel(9);
		obj.timerFrame.fs = obj.timerFrame:CreateFontString(type .. "NWBWorldMapTimerFrameFS", "ARTWORK");
		obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
		obj.timerFrame.fs:SetFont(NWB.regionFont, 13);
		obj.timerFrame:SetWidth(54);
		obj.timerFrame:SetHeight(24);
		obj:SetScript("OnUpdate", function(self)
			--Update timer when map is open.
			obj.timerFrame.fs:SetText(NWB:updateWorldbuffMarkers(type));
			--Adjust for non-english fonts.
			if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW or LOCALE_ruRU) then
				obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 18);
				obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 12);
			end
		end)
		--Make it act like pin is the parent and not WorldMapFrame.
		obj:SetScript("OnHide", function(self)
			obj.timerFrame:Hide();
		end)
		obj:SetScript("OnShow", function(self)
			obj.timerFrame:Show();
		end)
		
		if (type == "nef") then
			--/buffs text below the city map icons.
			obj.fs = obj:CreateFontString(type .. "NWBWorldMapBuffCmdFS", "ARTWORK");
			--obj.fs:SetPoint("RIGHT", 40, -40);
			if (NWB.faction == "Horde") then
				obj.fs:SetPoint("RIGHT", -180, 20);
			else
				obj.fs:SetPoint("RIGHT", -70, -35);
			end
			obj.fs:SetFont(NWB.regionFont, 14);
			obj.fs:SetText("|CffDEDE42" .. L["worldMapBuffsMsg"]);
			--Layer info text above the city map icons.
			obj.noLayerFrame = CreateFrame("Frame", type.. "WorldMapNoLayerFrame", obj, "TooltipBorderedFrameTemplate");
			obj.noLayerFrame:SetPoint("CENTER", obj, "CENTER",  10, 70);
			obj.noLayerFrame:SetFrameStrata("FULLSCREEN");
			obj.noLayerFrame:SetFrameLevel(9);
			obj.noLayerFrame:SetAlpha(.85);
			obj.noLayerFrame.fs = obj.noLayerFrame:CreateFontString(type .. "NWBWorldMapNoLayerFS", "ARTWORK");
			obj.noLayerFrame.fs:SetPoint("CENTER", 0, 0);
			obj.noLayerFrame.fs:SetFont(NWB.regionFont, 14);
			obj.noLayerFrame:SetWidth(54);
			obj.noLayerFrame:SetHeight(24);
			obj.noLayerFrame:Hide();
			obj.fs2 = obj:CreateFontString(type .. "NWBWorldMapBuffCmdFS", "ARTWORK");
			obj.fs2:SetPoint("CENTER", -10, 60);
			obj.fs2:SetFont(NWB.regionFont, 14);
		end
		obj:SetScript("OnMouseDown", function(self)
			NWB:openBuffListFrame();
		end)
	end
end

--Update scale when map is resized, and depending on what zone we're viewing.
function NWB:updateWorldbuffMarkersScale()
	local scale = 0.8;
	local mapModInstalled;
	if (IsAddOnLoaded("Leatrix_Maps")) then
		--Only needed with Leatrix Maps so far since it resizes the full map.
		--ElvUI seems to use the blizzard large and small map.
		mapModInstalled = true;
	end
	if (WorldMapFrame) then
		if (not mapModInstalled) then
			--This is usually nil if a map mod is installed?
			local mapID = WorldMapFrame:GetMapID();
			if (mapID == 1413) then
				scale = 0.7;
			end
			if (not WorldMapFrame.isMaximized) then
				scale = scale / 1.5;
			end
		end
		--Still do the 0.8 to all markers even if there's a map mod installed.
		for k, v in pairs(mapMarkers) do
			_G[k]:SetScale(scale);
		end
		for k, v in pairs(NWB.extraMapMarkers) do
			--Extra markers defined in NWBData.lua are 20% bigger.
			_G[k]:SetScale(scale + (scale * 0.2));
		end
		--Update Felwood markers.
		for k, v in pairs(NWB.songFlowers) do
			_G[k .. "NWB"]:SetScale(scale);
			_G[k .. "NWB"].tooltip:SetScale(scale);
			_G[k .. "NWB"].timerFrame:SetScale(scale);
		end
	 	for k, v in pairs(NWB.tubers) do
			_G[k .. "NWB"]:SetScale(scale);
			_G[k .. "NWB"].tooltip:SetScale(scale);
			_G[k .. "NWB"].timerFrame:SetScale(scale);
		end
	 	for k, v in pairs(NWB.dragons) do
			_G[k .. "NWB"]:SetScale(scale);
			_G[k .. "NWB"].tooltip:SetScale(scale);
			_G[k .. "NWB"].timerFrame:SetScale(scale);
		end
		--DMF.
		if (_G["NWBDMF"]) then
			_G["NWBDMF"]:SetScale(scale);
			_G["NWBDMF"].tooltip:SetScale(scale);
			_G["NWBDMF"].timerFrame:SetScale(scale);
		end
		if (_G["NWBDMFContinent"]) then
			_G["NWBDMFContinent"]:SetScale(scale);
			_G["NWBDMFContinent"].tooltip:SetScale(scale);
		end
	end
end

function NWB:refreshWorldbuffMarkers()
	if (NWB.expansionNum > 3) then
		NWB:updateWorldbuffMarkersScale();
		return;
	end
	local mapID = 0;
	local hideFS;
	if (NWB.isClassic) then
		if (WorldMapFrame) then
			mapID = WorldMapFrame:GetMapID();
		end
		if (NWB.faction == "Alliance") then
			--For alliance we'll add timers to the barrens and org if they have rend option enabled.
			--Easy way to do this is just alter the map pin table above.
			if (mapID == 1413 and NWB.db.global.allianceEnableRend) then --The Barrens.
				NWB.worldBuffMapMarkerTypes.rend = {x = 77.5, y = 81.0, mapID = 1413, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
				NWB.worldBuffMapMarkerTypes.ony = {x = 82.5, y = 81.0, mapID = 1413, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
				NWB.worldBuffMapMarkerTypes.nef = {x = 87.5, y = 81.0, mapID = 1413, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				hideFS = true;
			elseif (mapID == 1454 and NWB.db.global.allianceEnableRend) then --Orgrimmar.
				if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
					NWB.worldBuffMapMarkerTypes.rend = {x = 60.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 68, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 76.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				else
					NWB.worldBuffMapMarkerTypes.rend = {x = 77.0, y = 80.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 82.0, y = 80.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 87.0, y = 80.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				end
				hideFS = true;
			else
				--Default, matches the table a few functions above.
				if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
					NWB.worldBuffMapMarkerTypes.rend = {x = 71.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 79.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 87.5, y = 73.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				else
					NWB.worldBuffMapMarkerTypes.rend = {x = 78.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 83.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 88.0, y = 77.0, mapID = 1453, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				end
			end
		else
			if (mapID == 1413) then --The Barrens.
				NWB.worldBuffMapMarkerTypes.rend = {x = 77.5, y = 85.0, mapID = 1413, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
				NWB.worldBuffMapMarkerTypes.ony = {x = 82.5, y = 85.0, mapID = 1413, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
				NWB.worldBuffMapMarkerTypes.nef = {x = 87.5, y = 85.0, mapID = 1413, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				hideFS = true;
			else
				--Default, matches the table a few functions above.
				if (LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
					NWB.worldBuffMapMarkerTypes.rend = {x = 60.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 68, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 76.0, y = 85.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				else
					NWB.worldBuffMapMarkerTypes.rend = {x = 63.0, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\spell_arcane_teleportorgrimmar", name = L["rend"]};
					NWB.worldBuffMapMarkerTypes.ony = {x = 68.0, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_01", name = L["onyxia"]};
					NWB.worldBuffMapMarkerTypes.nef = {x = 73.0, y = 86.0, mapID = 1454, icon = "Interface\\Icons\\inv_misc_head_dragon_black", name = L["nefarian"]};
				end
			end
		end
	end
	if (NWB.isLayered) then
		local count = 0;
		local offset = 0;
		local foundLayers;
		for layer, data in NWB:pairsByKeys(NWB.data.layers) do
			--[[for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				--if (not NWB.data.layers[layer] and _G[k .. layer .. "NWBWorldMap"]) then
				if (_G[k .. layer .. "NWBWorldMap"]) then
					--Remove all icons first so it fixes any layer changes or data reset after server restart etc.
					NWB.dragonLibPins:RemoveWorldMapIcon(k .. layer .. "NWBWorldMap", _G[k .. layer .. "NWBWorldMap"]);
				end
			end]]
			for k, v in pairs(mapMarkers) do
				--Remove all icons first so it fixes any layer changes or data reset after server restart etc.
				NWB.dragonLibPins:RemoveWorldMapIcon(k, _G[k]);
			end
		end
		for layer, data in NWB:pairsByKeys(NWB.data.layers) do
			foundLayers = true;
			count = count + 1;
			for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				--Change position to bottom corner of map so they can be stacked on top of each other for layered realms.
				NWB.dragonLibPins:RemoveWorldMapIcon(k .. layer .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
				if (NWB.db.global.showWorldMapMarkers and _G[k .. layer .. "NWBWorldMap"]
					and not (NWB.isSOD and UnitLevel("player") < NWB.db.global.disableOnlyNefRendBelowMaxLevelNum)) then
					if (NWB.faction == "Horde") then
						if (mapID == 1413) then
							--If barrens the org coord offset is too far right so only rend shows.
							NWB.dragonLibPins:AddWorldMapIconMap(k .. layer .. "NWBWorldMap", _G[k .. layer .. "NWBWorldMap"], 
								v.mapID, (v.x + 8) / 100, (v.y + 9 + offset) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
						else
							NWB.dragonLibPins:AddWorldMapIconMap(k .. layer .. "NWBWorldMap", _G[k .. layer .. "NWBWorldMap"], 
									v.mapID, (v.x + 22) / 100, (v.y + 9 + offset) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
						end
					else
						NWB.dragonLibPins:AddWorldMapIconMap(k .. layer .. "NWBWorldMap", _G[k .. layer .. "NWBWorldMap"], 
								v.mapID, (v.x + 8) / 100, (v.y + 15 + offset) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
					end
					if (NWB.faction == "Alliance" and k == "rend") then
						if (not NWB.db.global.allianceEnableRend) then
							NWB.dragonLibPins:RemoveWorldMapIcon(k .. layer .. "NWBWorldMap", _G[k .. layer .. "NWBWorldMap"]);
						end
					end
					if (string.match(k, "zan") and not NWB.zand) then
						--Temp debug.
						NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
					end
				end
				if (NWB.faction == "Alliance" and k == "nef" and count == 1 and NWB.db.global.allianceEnableRend
						--These need more adjusting, if layer 1 timers run out I think the new layer 1 won't have the noLayerFrame attached.
						--Maybe I'll remove the count check when creating nef frames and just attach one to all layers nef frame.
						--Anyway it's a kinda rare case issue when the first layer has no timers for over 6 hours.
						and _G[k .. layer .. "NWBWorldMap"].noLayerFrame) then
					_G[k .. layer .. "NWBWorldMap"].noLayerFrame:SetPoint("CENTER", _G[k .. layer .. "NWBWorldMap"], "CENTER",  -245, 20);
					_G[k .. layer .. "NWBWorldMap"].fs2:SetPoint("CENTER", -245, 15);
				elseif (NWB.faction == "Alliance" and k == "nef" and count == 1
						and _G[k .. layer .. "NWBWorldMap"].noLayerFrame) then
					_G[k .. layer .. "NWBWorldMap"].noLayerFrame:SetPoint("CENTER", _G[k .. layer .. "NWBWorldMap"], "CENTER",  -195, 20);
					_G[k .. layer .. "NWBWorldMap"].fs2:SetPoint("CENTER", -195, 20);
				end
				--Hide fontstring when it's in the barrens or org for alliance.
				if (hideFS and _G[k .. layer .. "NWBWorldMap"].fs) then
					_G[k .. layer .. "NWBWorldMap"].fs:Hide();
					if (_G[k .. layer .. "NWBWorldMap"].noLayerFrame) then
						_G[k .. layer .. "NWBWorldMap"].noLayerFrame:Hide();
					end
				elseif (_G[k .. layer .. "NWBWorldMap"].fs) then
					_G[k .. layer .. "NWBWorldMap"].fs:Show();
				end
			end
			offset = offset - 8;
		end
		--This will add layer icons and remove default non-layer icons when we go from having no timer info to got new layers timer info.
		if (not foundLayers) then
			for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
				if (NWB.db.global.showWorldMapMarkers and _G[k .. "NWBWorldMap"]
						and not (NWB.isSOD and UnitLevel("player") < NWB.db.global.disableOnlyNefRendBelowMaxLevelNum)) then
					if (NWB.faction == "Horde") then
						if (mapID == 1413) then
							NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"], v.mapID,
									(v.x  + 8) / 100, (v.y + 9) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
						else
							NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"], v.mapID,
								(v.x  + 22) / 100, (v.y + 9) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
						end
					else
						NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"], v.mapID,
								(v.x  + 8) / 100, (v.y + 15) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
					end
					if (NWB.faction == "Alliance" and k == "rend") then
						if (not NWB.db.global.allianceEnableRend) then
							NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
						end
					end
					if (string.match(k, "zan") and not NWB.zand) then
						--Temp debug.
						NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
					end
					--Hide fontstring when it's in the barrens or org for alliance.
					if (hideFS and _G[k .. "NWBWorldMap"].fs) then
						_G[k .. "NWBWorldMap"].fs:Hide();
					elseif (_G[k .. "NWBWorldMap"].fs) then
						_G[k .. "NWBWorldMap"].fs:Show();
					end
				end
			end
		else
			for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
			end
		end
	else
		for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
			NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
			if (NWB.db.global.showWorldMapMarkers and _G[k .. "NWBWorldMap"]
					and not (NWB.isSOD and UnitLevel("player") < NWB.db.global.disableOnlyNefRendBelowMaxLevelNum)) then
				if (NWB.faction == "Horde") then
					NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"], v.mapID,
							(v.x  + 22) / 100, (v.y + 9) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
				else
					NWB.dragonLibPins:AddWorldMapIconMap(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"], v.mapID,
							(v.x  + 8) / 100, (v.y + 15) / 100, HBD_PINS_WORLDMAP_SHOW_PARENT);
				end
				if (NWB.faction == "Alliance" and k == "rend") then
					if (not NWB.db.global.allianceEnableRend) then
						NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
					end
				end
				if (string.match(k, "zan") and not NWB.zand) then
					--Temp debug.
					NWB.dragonLibPins:RemoveWorldMapIcon(k .. "NWBWorldMap", _G[k .. "NWBWorldMap"]);
				end
				--Hide fontstring when it's in the barrens or org for alliance.
				if (hideFS and _G[k .. "NWBWorldMap"].fs) then
					_G[k .. "NWBWorldMap"].fs:Hide();
				elseif (_G[k .. "NWBWorldMap"].fs) then
					_G[k .. "NWBWorldMap"].fs:Show();
				end
			end
		end
	end
	NWB:updateWorldbuffMarkersScale();
end

---=============---
---Darkoon Faire---
---=============---

SLASH_NWBDMFCMD1 = '/dmf';
function SlashCmdList.NWBDMFCMD(msg, editBox)
	if (msg) then
		msg = string.lower(msg);
	end
	if (msg == "map") then
		WorldMapFrame:Show();
		if (NWB.dmfZone == "Outlands") then
			WorldMapFrame:SetMapID(1952);
		elseif (NWB.dmfZone == "Mulgore") then
			WorldMapFrame:SetMapID(1412); 
		else
			WorldMapFrame:SetMapID(1429);
		end
		return;
	end
	if (msg == "options" or msg == "option" or msg == "config" or msg == "menu") then
		NWB:openConfig();
		return;
	end
	local output, dmfFound;
	local zone = NWB:getDmfZoneString();
	local timeString = NWB:getDmfTimeString();
	if (timeString == "Error getting Darkmoon Faire timer.") then
		output = timeString;
	else
		output = timeString .. " (" .. zone .. ")";
	end
	if (output) then
		if (msg ~= nil and msg ~= "") then
			NWB:print(output, msg);
		else
			NWB:print(output);
		end
	end
	local dmfCooldown, noMsgs = NWB:getDmfCooldown();
	if (dmfCooldown > 0 and not noMsgs) then
		output = string.format(L["dmfBuffCooldownMsg"],  NWB:getTimeString(dmfCooldown, true));
		dmfFound = true;
	end
	--[[if (NWB.data.myChars[UnitName("player")].buffs) then
		for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
			if (v.type == "dmf" and (v.timeLeft + 7200) > 0 and not v.noMsgs) then
				output = string.format(L["dmfBuffCooldownMsg"],  NWB:getTimeString(v.timeLeft + 7200, true));
				dmfFound = true;
				break;
			end
		end
	end]]
	if (not dmfFound) then
		output = L["dmfBuffReady"];
	end
	if (msg == nil or msg == "") then
		NWB:print(output);
	end
end

function NWB:getDmfTimeString()
	local timestamp, timeLeft, type = NWB:getDmfData();
	if (timestamp == 0) then
		return "Error getting Darkmoon Faire timer.";
	end
	local msg, dateString;
	if (timestamp) then
 		if (NWB.db.global.timeStampFormat == 12) then
			dateString = date("%a %b %d", timestamp) .. " " .. gsub(string.lower(date("%I:%M%p", timestamp)), "^0", "");
		else
			dateString = date("%x %X", timestamp);
		end
		dateString = NWB:getTimeFormat(timestamp, true);
		if (type == "start") then
			msg = string.format(L["dmfSpawns"], NWB:getTimeString(timeLeft, true), dateString);
		else
			msg = string.format(L["dmfEnds"],NWB:getTimeString(timeLeft, true), dateString);
		end
		return msg;
	end
end

--------------------------------------------------------------
---Warning: The following Darkmoon Faire code is a shitshow---
---					Enter at own risk					   ---
--------------------------------------------------------------

--Static dates that don't fall within the "first friday of every month construction starts" rule.
--It seems like Blizzard just start entering random dates instead of following the above rule now.
--Or there's a new formula I can't work out yet.
--These are friday dates when construction starts, taken from the retail calendar.
NWB.staticDmfDates = {};
function NWB:setDmfDates()
	if (NWB.isClassic) then
		NWB.staticDmfDates = {
			--[[[1] = { --July 30th setup, August 1st start 2021.
				day = 30,
				month = 7,
				year = 2021,
				zone = "Mulgore",
			},
			[2] = { --October 29th setup, October 31st start 2021.
				day = 29,
				month = 10,
				year = 2021,
				zone = "Elwynn Forest",
			},]]
		}
	end
end
--This needs to check for the next spawn.
--But also the last spawn within the last 7 days.
local dmfZoneStatic = "";
local c = string.char;
function NWB:getNextStaticDate(useNext)
	local foundCount, lastStaticDmf = 0, 0;
	local utcdate = date("!*t", GetServerTime());
	local currentUTC = time(utcdate);
	for k, v in ipairs(NWB.staticDmfDates) do
		local timeTable = {year = v.year, month = v.month, day = v.day, hour = 0, min = 0, sec = 0};
		local time = time(timeTable);
		--If this date is within the last 8 days and the next 31 days.
		--Within last 11 days to account for friday to sunday and so it works in all timezones
		--If it's past the despawn time we skip it anyway.
		if (time > (currentUTC - 950400) and time - currentUTC < 2678400
				--And if the last static dmf date wasn't within last 11 days.
				--This is to find out if current dmf is a static or formula date.
				--So if the current dmf up is not a static date it will keep showing dmf as up
				--and not use a forward static date within the next 31 days.
				and currentUTC - lastStaticDmf > 950400) then
			foundCount = foundCount + 1;
			--If useNext is specified then we try and find the next month, skipping first found.
			if (not useNext or foundCount > 1) then
				dmfZoneStatic = v.zone;
				return timeTable, lastStaticDmf;
			end
		end
		lastStaticDmf = time;
	end
	return nil, lastStaticDmf;
end

local dmfTextures = {
	--Calander textures for each dmf display type.
	[235451] = "Start Mulgore",
	--[235450] = "Days inbetween Mulgore",
	[235449] = "End Mulgore",
	[235455] = "Start Shat",
	--[235454] = "Days inbetween Shat",
	[235453] = "End Shat",
	[235448] = "Start Elwynn",
	--[235447] = "Days inbetween Elwynn",
	[235446] = "End Elwynn",
};

--Timestamp, seconds left, type (start/end), zone.
local dmfCalenderCache = {
	dmfTimestampCache = 0;
	dmfTimeLeftCache = 0;
	dmfTypeCache = "",
	dmfZoneCache = "",
};

local function getNextDmfCalender()
	if (CalendarFrame and CalendarFrame:IsShown()) then
		--Use cache if it's open so we don't change page while player is looking at it.
		--Maybe there's a way to calc from current month without SetAbsMonth() updating the UI?
		return dmfCalenderCache.dmfTimestampCache, dmfCalenderCache.dmfTimeLeftCache, dmfCalenderCache.dmfTypeCache, dmfCalenderCache.dmfZoneCache;
	end
	local eventStart, eventEnd;
	local nextStart, nextEnd = 0, 0;
	local now = C_DateAndTime.GetCurrentCalendarTime();
	--Record current month so we can subtract it from offsetTime.month so we always start at 0 but can +1 next month when needed too.
	local month = now.month;
	C_Calendar.SetAbsMonth(now.month, now.year);
	for dayOffset = 0, 60 do
		local offsetTime = C_DateAndTime.AdjustTimeByDays(now, dayOffset);
		for eventIndex = 1, C_Calendar.GetNumDayEvents(offsetTime.month - month, offsetTime.monthDay) do
			local event = C_Calendar.GetDayEvent(offsetTime.month - month, offsetTime.monthDay, eventIndex);
			--Get next dmf start or end time, whichever is next after current time.
			if (event and dmfTextures[event.iconTexture]) then
				if (event.sequenceType == "START") then
					--Fix date table structure so it works with time().
					event.startTime.day = event.startTime.monthDay;
					local timestamp = time(event.startTime);
					--Only record the first in the future.
					if (timestamp > GetServerTime()) then
						local zone;
						if (event.iconTexture == 235448) then
							zone = "Elwynn Forest";
						elseif (event.iconTexture == 235455) then
							zone = "Outlands";
						else
							zone = "Mulgore";
						end
						local timeLeft = timestamp - GetServerTime();
						local type = "start";
						dmfCalenderCache.dmfTimestampCache, dmfCalenderCache.dmfTimeLeftCache, dmfCalenderCache.dmfTypeCache, dmfCalenderCache.dmfZoneCache = timestamp, timeLeft, type, zone;
						return timestamp, timeLeft, type, zone;
					end
				elseif (event.sequenceType == "END") then
					event.endTime.day = event.endTime.monthDay;
					local timestamp = time(event.endTime);
					if (timestamp > GetServerTime()) then
						local zone;
						if (event.iconTexture == 235446) then
							zone = "Elwynn Forest";
						elseif (event.iconTexture == 235453) then
							zone = "Outlands";
						else
							zone = "Mulgore";
						end
						local timeLeft = timestamp - GetServerTime();
						local type = "end";
						dmfCalenderCache.dmfTimestampCache, dmfCalenderCache.dmfTimeLeftCache, dmfCalenderCache.dmfTypeCache, dmfCalenderCache.dmfZoneCache = timestamp, timeLeft, type, zone;
						return timestamp, timeLeft, type, zone;
					end
				end
			end
		end
	end
end

--DMF spawns the following monday after first friday of the month at daily reset time.
--Whole region shares time of day for spawn (I think).
--Realms within the region possibly don't all spawn at same moment though, realms may wait for their own monday.
--(Bug: US player reported it showing 1 day late DMF end time while on OCE realm, think this whole thing needs rewriting tbh).
function NWB:getDmfStartEnd(month, nextYear, recalc)
	if (NWB.isSOD) then
		local region = NWB:GetCurrentRegion();
		local calcStart;
		--Elywwn Forest start times in the past to calc from.
		--Using normal classic spawn times for now, but maybe it just spawns at midnight on all SoD servers?
		--I may change this to realm names later instead, region may be unreliable with US client on EU region if that issue still exists.
		--if (NWB.realm == "Shadowstrike (AU)" or NWB.realm == "Penance (AU)") then
		if (region == 1 and string.match(NWB.realm, "(AU)")) then
			--OCE Sunday 5pm UTC reset time (4am monday server time).
			calcStart = 1700416800; --Sunday, November 19, 2023 6:00:00 PM.
		elseif (region == 1) then
			--US Sunday 11pm UTC reset time (4am monday server time).
			--Unlike normal classic, in SoD it seems all US realms use the same timezone MST?
			calcStart = 1700478000; --Monday, November 20, 2023 11:00:00 AM UTC.
		elseif (region == 2) then
			--Korea 1am UTC monday (9am monday local) reset time.
			--(TW seems to be region 2 for some reason also? Hopefully they have same DMF spawn).
			--I can change it to server name based if someone from KR says this spawn time is wrong.
			calcStart = 1702890000; --Monday, December 18, 2023 9:00:00 AM UTC.
		elseif (region == 3) then
			--EU Monday 4am UTC reset time.
			calcStart = 1702872000; --Monday, December 18, 2023 4:00:00 AM UTC.
		elseif (region == 4) then
			--Taiwan 1am UTC monday (9am monday local) reset time.
			calcStart = 1702861200; --Monday, December 18, 2023 1:00:00 AM.
		elseif (region == 5) then
			--China 8pm UTC sunday (4am monday local) reset time.
			calcStart = 1702843200; --Sunday, December 17, 2023 8:00:00 PM UTC.
		end
		if (calcStart) then
			--Spawns change with DST by 1 hour UTC.
			local start = calcStart;
			local isDST = NWB:isDST();
			if (isDST) then
				--World event timers go forward but dmf goes backwards..?
				start = start - 3600;
			end
			--2 week cycle.
			--local utc = time(date("*t"));
			local utc = GetServerTime();
			local secondsSinceFirstReset = utc - start;
			--Divide seconds elapsed since our static timestamp in the past by the cycle time (3.5h).
			--Get the floor of secondsSinceFirstReset / cycle time
			--Divide seconds elapsed since our static timestamp in the past by the cycle time (3.5h).
			--Get the floor of that result (which would be last reset if multipled by cycle time) then add 1 for next reset, then multiply by cycle time.
			--This calc gets the next dmf start in the future and not the last start.
			local dmfStart = start + ((math.floor(secondsSinceFirstReset / 1209600) + 1) * 1209600);
			if (utc < dmfStart - 604800) then
				--If next future dmf start is more than 1 week away then the previous dmf is still up so remove 2 weeks and calc for that instead.
				dmfStart = dmfStart - 1209600;
			end
			local dmfEnd = dmfStart + 604800;
			local timeLeft = dmfStart - utc;
			return dmfStart, dmfEnd, start;
		end
	else
		local startOffset, endOffset, validRegion, isDst;
		local  minOffset, hourOffset, dayOffset = 0, 0, 0;
		local region = NWB:GetCurrentRegion();
		--I may change this to realm names later instead, region may be unreliable with US client on EU region if that issue still exists.
		if (NWB.realm == "Arugal" or NWB.realm == "Felstriker" or NWB.realm == "Remulos" or NWB.realm == "Yojamba") then
			--OCE Sunday 12pm UTC reset time (4am monday server time).
			dayOffset = 2; --2 days after friday (sunday).
			--Change this to saturday instead of of friday to try fix classic era calcs.
			--Changed back to friday now.
			--dayOffset = 1;
			hourOffset = 18; -- 6pm.
			validRegion = true;
		elseif (NWB.realm == "Arcanite Reaper" or NWB.realm == "Old Blanchy" or NWB.realm == "Anathema" or NWB.realm == "Azuresong"
				or NWB.realm == "Kurinnaxx" or NWB.realm == "Myzrael" or NWB.realm == "Rattlegore" or NWB.realm == "Smolderweb"
				or NWB.realm == "Thunderfury" or NWB.realm == "Atiesh" or NWB.realm == "Bigglesworth" or NWB.realm == "Blaumeux"
				or NWB.realm == "Fairbanks" or NWB.realm == "Grobbulus" or NWB.realm == "Whitemane") then
			--US west Sunday 11am UTC reset time (4am monday server time).
			dayOffset = 2; --2 days after friday (sunday).
			--dayOffset = 1;
			hourOffset = 11; -- 11am.
			validRegion = true;
		elseif (region == 1) then
			--US east + Latin Sunday 8am UTC reset time (4am monday server time).
			dayOffset = 2; --2 days after friday (sunday).
			--dayOffset = 1;
			hourOffset = 8; -- 8am.
			validRegion = true;
		elseif (region == 2) then
			--Korea 1am UTC monday (9am monday local) reset time.
			--(TW seems to be region 2 for some reason also? Hopefully they have same DMF spawn).
			--I can change it to server name based if someone from KR says this spawn time is wrong.
			dayOffset = 3;
			--dayOffset = 2;
			hourOffset = 1;
			validRegion = true;
		elseif (region == 3) then
			--EU Monday 4am UTC reset time.
			dayOffset = 3; --3 days after friday (monday).
			--dayOffset = 2;
			hourOffset = 2; -- 4am.
			validRegion = true;
		elseif (region == 4) then
			--Taiwan 1am UTC monday (9am monday local) reset time.
			dayOffset = 3;
			--dayOffset = 2;
			hourOffset = 1;
			validRegion = true;
		elseif (region == 5) then
			--China 8pm UTC sunday (4am monday local) reset time.
			dayOffset = 2;
			--dayOffset = 1;
			hourOffset = 20;
			validRegion = true;
		end
		--Create current UTC date table.
		local data = date("!*t", GetServerTime());
		local dataLocalTime = date("*t", GetServerTime());
		--Spawns change with DST by 1 hour UTC to stay the same server time.
		if (dataLocalTime.isdst) then
			hourOffset = hourOffset - 1;
		end
		--If month is specified then use that month instead (next dmf spawn is next month);
		if (month) then
			data.month = month;
		end
		--If nextYear is true then next dmf spawn is next year (we're in december right now).
		if (nextYear) then
			data.year = data.year + 1;
		end
		local dmfStartDay;
		--[[for i = 1, 7 do
			--Iterate the first 7 days in the month to find first friday.
			local time = date("!*t", time({year = data.year, month = data.month, day = i}));
			--if (time.wday == 6) then
			--Change this saturday instead of of friday to try fix classic era calcs.
			if (time.wday == 7) then
				--If day of the week (wday) is 6 (friday) then set this as first friday of the month.
				dmfStartDay = i;
			end
		end]]
		--There was an issue with using the date table above for a single user, thier client couldn't get the first day of the month correct.
		--It was correct using %w instead so we'll just go with that for now.
		for i = 1, 7 do
			--Iterate the first 7 days in the month to find first friday.
			--This was using saturday for a while which seemed correct when friday wasn't during some months, but now friday seems right again..
			--If this is changed the offset says above needs adjusting to match.
			--0 = Sunday -> 6 = Saturday.
			if (date("%w", time({year = data.year, month = data.month, day = i})) == "5") then
				--If day of the week (wday) is 6 (friday) then set this as first friday of the month.
				dmfStartDay = i;
				break;
			end
		end
		if (not dmfStartDay) then
			--How is it possible this could fail to be found above? It was reported to have failed by a user.
			return;
		end
		local timeTable = {year = data.year, month = data.month, day = dmfStartDay + dayOffset, hour = hourOffset, min = minOffset, sec = 0};
		local dataNextStatic, lastStaticDmf = NWB:getNextStaticDate();
		local utcdate   = date("!*t", GetServerTime());
		local localdate = date("*t", GetServerTime());
		localdate.isdst = false;
		local secondsDiff = difftime(time(utcdate), time(localdate));
		--local secondsDiff = difftime(time(localdate), time(utcdate));
		--local secondsDiffTest = difftime(time(utcdate), time(localdate));
		--NWB:debug(secondsDiff);
		local dmfStart;
		--if (secondsDiff > 0) then
		--	dmfStart = time(timeTable) - secondsDiff;
		--else
		--	dmfStart = time(timeTable) + secondsDiff;
		--end
		dmfStart = time(timeTable) - secondsDiff;
		--local dmfStart = time(timeTable) - secondsDiff;
		if (not lastStaticDmf) then
			lastStaticDmf = 0;
		end
		local dmfStartStatic = 0;
		if (dataNextStatic) then
			--Use next static instead if there is a valid static date set for next spawn.
			data = dataNextStatic;
			--Convert to a timestamp and add our region offsets.
			local staticTimestamp = time(dataNextStatic);
			local staticOffset = 0;
			staticOffset = staticOffset + (dayOffset * 86400);
			staticOffset = staticOffset + (hourOffset * 3600);
			staticOffset = staticOffset + (minOffset * 60);
			local staticOffsetTimestamp = staticTimestamp + staticOffset;
			local staticDateUTC = date("*t", staticOffsetTimestamp);
			dmfStartStatic = time(staticDateUTC) - secondsDiff;
			if (GetServerTime() > dmfStart + 604800) then
				local dataNextStatic = NWB:getNextStaticDate(true);
				if (dataNextStatic) then
					local staticTimestamp = time(dataNextStatic);
					local staticOffset = 0;
					staticOffset = staticOffset + (dayOffset * 86400);
					staticOffset = staticOffset + (hourOffset * 3600);
					staticOffset = staticOffset + (minOffset * 60);
					local staticOffsetTimestamp = staticTimestamp + staticOffset;
					local staticDateUTC = date("*t", staticOffsetTimestamp);
					--dmfStart = time(staticDateUTC) - secondsDiff;
					dmfStartStatic = time(staticDateUTC) - secondsDiff;
				end
			--else
				--dmfStart = dmfStartStatic;
			end
		end
	
		if (dmfStartStatic > GetServerTime() + 1296000 and dmfStartStatic < GetServerTime() - 1296000
				and dmfStart < GetServerTime() + 950400 and dmfStart > GetServerTime() - 950400) then
			--If formula date is within 11 days and there's no static date within the next or past 15 days then force use the forumla date.
			--So we don't get next static date within 31 days while the forumla dmf is still up.
			--This will probably create wrong next dmf date for the first day or 2 after dmf ends but it's good enough for now.
			--This while thing needs a rewrite.
		--elseif (dataNextStatic and dataNextStatic > 0) then
		elseif (dmfStartStatic and dmfStartStatic > 0) then
			dmfStart = dmfStartStatic;
		end
		--This is basically just adjusting for my shitty local offset code since all regions spawn on monday.
		--My offset code will get the time right but sometimes the day behind, so adjust to monday if it's sunday.
		--It needs fixing later, but all regions start on monday/tuesday so this works for now..
		--This also helps with playing from a diff timezone than the server issues.
		if (date("%w", dmfStart) == "0") then
			--Not sure if whole region spawns at the same moment or if each realm waits for their own monday.
			--All realms spawn same time of day, but possibly not same UTC day depending on timezone.
			--Just incase each realm waits for monday we can add a day here.
			dmfStart = dmfStart + 86400;
		end
		--Add 7 days to get end timestamp.
		local dmfEnd = dmfStart + 604800;
		--Only return if we have set daily reset offsets for this region.
		if (not recalc and lastStaticDmf + 604800 > GetServerTime() - 1296000
			and (dmfStartStatic == 0 or dmfStartStatic > GetServerTime() + 3456000)) then
			local data = date("!*t", GetServerTime());
			if (data.month == 12) then
				data.month = 1;
				return NWB:getDmfStartEnd(data.month, true, true);
			else
				data.month = data.month + 1
				return NWB:getDmfStartEnd(data.month, nil, true);
			end
		elseif (validRegion) then
			return dmfStart, dmfEnd;
		end
	end
end

function NWB:getDmfData()
	if (NWB.isSOD) then
		local dmfStart, dmfEnd, calcStart = NWB:getDmfStartEnd();
		local timestamp, timeLeft, type;
		local cycleCount = 0;
		if (dmfStart and dmfEnd) then
			if (GetServerTime() < dmfStart) then
				--It's before the start of dmf.
				timestamp = dmfStart;
				type = "start";
				timeLeft = dmfStart - GetServerTime();
				NWB.isDmfUp = nil;
			elseif (GetServerTime() < dmfEnd) then
				--It's after dmf started and before the end.
				timestamp = dmfEnd;
				type = "end";
				timeLeft = dmfEnd - GetServerTime();
				NWB.isDmfUp = true;
			elseif (GetServerTime() >= dmfEnd) then
				--It's after dmf ended so calc next months dmf instead.
				local data = date("!*t", GetServerTime());
				if (data.month == 12) then
					dmfStart, dmfEnd = NWB:getDmfStartEnd(1, true);
				else
					dmfStart, dmfEnd = NWB:getDmfStartEnd(data.month + 1);
				end
				timestamp = dmfStart;
				type = "start";
				timeLeft = dmfStart - GetServerTime();
				NWB.isDmfUp = nil;
			end
			if (timestamp) then
				local weeks = (timestamp - calcStart) / 604800;
				local twoWeeks = (timestamp - calcStart) / 1209600;
				--Check if weeks since calc started is divisble by 4.
				if (((dmfStart - calcStart) / 604800) % 4 == 0) then
					NWB.dmfZone = "Elwynn Forest";
				else
					NWB.dmfZone = "Mulgore";
				end
				return timestamp, timeLeft, type;
			end
		end
	elseif (NWB.isClassic or NWB.isTBC) then
		local dmfStart, dmfEnd = NWB:getDmfStartEnd();
		local timestamp, timeLeft, type;
		if (dmfStart and dmfEnd) then
			if (GetServerTime() < dmfStart) then
				--It's before the start of dmf.
				timestamp = dmfStart;
				type = "start";
				timeLeft = dmfStart - GetServerTime();
				NWB.isDmfUp = nil;
			elseif (GetServerTime() < dmfEnd) then
				--It's after dmf started and before the end.
				timestamp = dmfEnd;
				type = "end";
				timeLeft = dmfEnd - GetServerTime();
				NWB.isDmfUp = true;
			elseif (GetServerTime() > dmfEnd) then
				--It's after dmf ended so calc next months dmf instead.
				local data = date("!*t", GetServerTime());
				if (data.month == 12) then
					dmfStart, dmfEnd = NWB:getDmfStartEnd(1, true);
				else
					dmfStart, dmfEnd = NWB:getDmfStartEnd(data.month + 1);
				end
				timestamp = dmfStart;
				type = "start";
				timeLeft = dmfStart - GetServerTime();
				NWB.isDmfUp = nil;
			end
			local zone;
			local startMonth = tonumber(date("%m", dmfStart));
			local startDay = tonumber(date("%d", dmfStart));
			--If it starts at the end of the month then change which zone it starts in.
			if (startDay > 20) then
				startMonth = startMonth + 1;
			end
			if (NWB.isTBC) then
				if (startMonth == 2 or startMonth == 5 or startMonth == 8 or startMonth == 11) then
					zone = "Outlands";
				elseif (startMonth == 1 or startMonth == 4 or startMonth == 7 or startMonth == 10) then
					zone = "Mulgore";
				else
					zone = "Elwynn Forest";
				end
			else
				if (startMonth % 2 == 0) then
					--These were swapped around manually by Blizzard but now it seems to be swapped back to be in sync with era realms.
					--if (NWB.isTBC or NWB.realmsTBC) then
					--	zone = "Elwynn Forest";
					--else
						zone = "Mulgore";
					--end
				else
					--if (NWB.isTBC or NWB.realmsTBC) then
					--	zone = "Mulgore";
					--else
						zone = "Elwynn Forest";
					--end
		 
				end
			end
			--Zone override for static dates.
			if (dmfZoneStatic ~= "") then
				zone = dmfZoneStatic;
			end
			NWB.dmfZone = zone;
			--Timestamp of next start or end event, seconds left untill that event, and type of event.
			return timestamp, timeLeft, type;
		end
	else
		local timestamp, timeLeft, type, zone = getNextDmfCalender();
		if (not timestamp) then
			--Calander lookup has failed, could be becaus Blizzard hasn't added next month data like has happen now at 2022 end.
			return 0, 0, "";
		end
		NWB.dmfZone = zone;
		return timestamp, timeLeft, type;
	end
end

function NWB:getDmfZoneString()
	if (NWB.dmfZone == "Outlands") then
		return L["Outlands"];
	elseif (NWB.dmfZone == "Mulgore") then
		return L["mulgore"];
	else
		return L["elwynnForest"];
	end
end

function NWB:checkDmfBuffReset(isLogon)
	if (not NWB.isClassic) then
		return;
	end
	local charString = "";
	local count = 0;
	local foundThisCharDmfReset;
	local me = UnitName("player");
	for realm, realmData in pairs(NWB.db.global) do
		if (type(realmData) == "table" and realm ~= "minimapIcon" and realm ~= "versions") then
			for faction, factionData in pairs(realmData) do
				if (type(factionData) == "table" and factionData.myChars) then
					for char, charData in pairs(factionData.myChars) do
						local lastOnline;
						if (char == me and isLogon) then
							--Use a cache recorded before the ticker starts for checks at logon.
							lastOnline = NWB.lastOnlineCache;
						else
							lastOnline = charData.lo;
						end
						if (charData.dmfCooldown and lastOnline and charData.dmfCooldown > 0 and GetServerTime() - lastOnline > 691200) then
							--If been offline over a week just reset it, the cooldown doesn't seem to persist betwee dmf even if offline the whole time and not rested?
							--Reset dmf buff cooldown data, needs to still be a number and lower than -99990.
							charData.dmfCooldown = -99999;
						end
						if (charData.dmfCooldown and lastOnline and charData.resting and charData.dmfCooldown > 0 and GetServerTime() - lastOnline > 28800) then
							--If 8+ hours offline and in rested area and have dmf buff cooldwn.
							count = count + 1;
							local _, _, _, classColorHex = GetClassColor(charData.englishClass);
							local text = "|c" .. classColorHex .. char .. "-" .. realm .. "|r";
							if (count == 1) then
								charString = text;
							else
								charString = charString .. ", " .. text;
							end
							--Reset dmf buff cooldown data, needs to still be a number and lower than -99990.
							charData.dmfCooldown = -99999;
							if (char == me) then
								foundThisCharDmfReset = true;
							end
						end
					end
				end
			end
		end
	end
	if (NWB.isDmfUp and charString ~= "") then
		NWB:print(L["dmfLogonBuffResetMsg"] .. ": " .. charString);
		return foundThisCharDmfReset;
	end
end

function NWB:updateDmfMarkers(type)
	local timestamp, timeLeft, type = NWB:getDmfData();
	local text = "";
	if (not timestamp or timestamp < 1) then
		text = text .. L["noTimer"];
	else
		if (type == "start") then
			text = text .. string.format(L["startsIn"], NWB:getTimeString(timeLeft, true, "short"));
		else
			text = text .. string.format(L["endsIn"], NWB:getTimeString(timeLeft, true, "short"));
		end
	end
	if (timeLeft and timeLeft > 0) then
		local tooltipText = "|Cff00ff00" .. L["Darkmoon Faire"] .. "|CffDEDE42\n";
		if (type == "start") then
			tooltipText = tooltipText .. string.format(L["startsIn"], NWB:getTimeString(timeLeft, true)) .. "\n";
		else
			tooltipText = tooltipText .. string.format(L["endsIn"], NWB:getTimeString(timeLeft, true)) .. "\n";
		end
    	tooltipText = tooltipText .. NWB:getTimeFormat(timestamp, true);
    	local dmfFound;
    	local buffText = "";
    	if (NWB.isDmfUp or NWB.isAlwaysDMF) then
    		local dmfCooldown, noMsgs = NWB:getDmfCooldown();
			if (dmfCooldown > 0 and not noMsgs) then
				buffText = "\n" .. string.format(L["dmfBuffCooldownMsg"],  NWB:getTimeString(dmfCooldown, true));
				dmfFound = true;
			end
    		--[[if (NWB.data.myChars[UnitName("player")].buffs) then
				for k, v in pairs(NWB.data.myChars[UnitName("player")].buffs) do
					if (v.type == "dmf" and (v.timeLeft + 7200) > 0 and not v.noMsgs) then
						buffText = "\n" .. string.format(L["dmfBuffCooldownMsg"],  NWB:getTimeString((v.timeLeft + 7200), true));
						dmfFound = true;
						break;
					end
				end
			end]]
    		if (not dmfFound) then
    			buffText = "\n" .. L["dmfBuffReady"];
    		end
    	end
    	tooltipText = tooltipText .. buffText;
    	_G["NWBDMF"].tooltip.fs:SetText(tooltipText);
    	_G["NWBDMF"].tooltip:SetWidth(_G["NWBDMF"].tooltip.fs:GetStringWidth() + 18);
		_G["NWBDMF"].tooltip:SetHeight(_G["NWBDMF"].tooltip.fs:GetStringHeight() + 12);
		_G["NWBDMFContinent"].tooltip.fs:SetText(tooltipText);
    	_G["NWBDMFContinent"].tooltip:SetWidth(_G["NWBDMFContinent"].tooltip.fs:GetStringWidth() + 12);
		_G["NWBDMFContinent"].tooltip:SetHeight(_G["NWBDMFContinent"].tooltip.fs:GetStringHeight() + 12);
		--_G["NWBDMF"]:Show();
  		--_G["NWBDMFContinent"]:Show();
  	else
  		--_G["NWBDMF"]:Hide();
  		--_G["NWBDMFContinent"]:Hide();
  	end
	return text;
end

function NWB:createDmfMarkers()
	--Darkmoon Faire zone map marker.
	local icon = "Interface\\AddOns\\NovaWorldBuffs\\Media\\dmf";
	local obj = CreateFrame("Frame", "NWBDMF", WorldMapFrame);
	local bg = obj:CreateTexture(nil, "ARTWORK");
	bg:SetTexture(icon);
	bg:SetAllPoints(obj);
	obj.texture = bg;
	obj:SetSize(23, 23);
	--Worldmap tooltip.
	obj.tooltip = CreateFrame("Frame", "NWBDMFTooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
	obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 46);
	obj.tooltip:SetFrameStrata("TOOLTIP");
	obj.tooltip:SetFrameLevel(9);
	obj.tooltip.fs = obj.tooltip:CreateFontString("NWBDMFTooltipFS", "ARTWORK");
	obj.tooltip.fs:SetPoint("CENTER", 0, 0);
	obj.tooltip.fs:SetFont(NWB.regionFont, 14);
	obj.tooltip.fs:SetText("|Cff00ff00Darkmoon Faire");
	obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
	obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
	obj:SetScript("OnEnter", function(self)
		obj.tooltip:Show();
	end)
	obj:SetScript("OnLeave", function(self)
		obj.tooltip:Hide();
	end)
	obj.tooltip:Hide();
	--Timer frame that sits above the icon when an active timer is found.
	obj.timerFrame = CreateFrame("Frame", "NWBDMFTimerFrame", WorldMapFrame, "TooltipBorderedFrameTemplate");
	obj.timerFrame:SetPoint("CENTER", obj, "CENTER", 0, -21);
	obj.timerFrame:SetFrameStrata("FULLSCREEN");
	obj.timerFrame:SetFrameLevel(9);
	obj.timerFrame.fs = obj.timerFrame:CreateFontString("NWBDMFTimerFrameFS", "ARTWORK");
	obj.timerFrame.fs:SetPoint("CENTER", 0, 0);
	obj.timerFrame.fs:SetFont(NWB.regionFont, 13);
	obj.timerFrame:SetWidth(54);
	obj.timerFrame:SetHeight(24);
	obj:SetScript("OnUpdate", function(self)
		--Update timer when map is open.
		obj.timerFrame.fs:SetText(NWB:updateDmfMarkers());
		obj.timerFrame:SetWidth(obj.timerFrame.fs:GetStringWidth() + 10);
		obj.timerFrame:SetHeight(obj.timerFrame.fs:GetStringHeight() + 10);
	end)
	--Make it act like pin is the parent and not WorldMapFrame.
	obj:SetScript("OnHide", function(self)
		obj.timerFrame:Hide();
	end)
	obj:SetScript("OnShow", function(self)
		obj.timerFrame:Show();
	end)
	obj:SetScript("OnMouseDown", function(self)
		NWB:openBuffListFrame();
	end)
	
	--Darkmoon Faire continent marker.
	local obj = CreateFrame("Frame", "NWBDMFContinent", WorldMapFrame);
	local bg = obj:CreateTexture(nil, "ARTWORK");
	bg:SetTexture(icon);
	bg:SetAllPoints(obj);
	obj.texture = bg;
	obj:SetSize(14, 14);
	obj:SetFrameStrata("High");
	obj:SetFrameLevel(9);
	--Worldmap tooltip.
	obj.tooltip = CreateFrame("Frame", "NWBDMFContinentTooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
	obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 46);
	obj.tooltip:SetFrameStrata("TOOLTIP");
	obj.tooltip:SetFrameLevel(9);
	obj.tooltip.fs = obj.tooltip:CreateFontString("NWBDMFContinentTooltipFS", "ARTWORK");
	obj.tooltip.fs:SetPoint("CENTER", 0, 0);
	obj.tooltip.fs:SetFont(NWB.regionFont, 14);
	obj.tooltip.fs:SetText("|Cff00ff00Darkmoon Faire");
	obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 18);
	obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 12);
	obj:SetScript("OnEnter", function(self)
		obj.tooltip:Show(); --5:34 2h4m
	end)
	obj:SetScript("OnLeave", function(self)
		obj.tooltip:Hide();
	end)
	obj.tooltip:Hide();
	obj:SetScript("OnUpdate", function(self)
		--Updatetooltip  timer when map is open.
		NWB:updateDmfMarkers();
	end)
	obj:SetScript("OnMouseDown", function(self)
		NWB:openBuffListFrame();
	end)
	NWB:refreshDmfMarkers();
end

local d = NWB.realm;
function NWB:refreshDmfMarkers()
	if (not NWB.dmfZone) then
		return;
	end
	--Mulgore and Elwynn are both slightly south (+1 coord) of the actual DMF spot in continent maps to not clash with other addon quest markers.
	--Players need to be able to hover DMF marker easily to see buff cooldown etc.
	local x, y, mapID, worldX, worldY, worldMapID;
	if (NWB.dmfZone == "Outlands") then
		x, y, mapID = 34.8, 34.6, 1952;
		worldX, worldY, worldMapID = 44.6, 69.5, 1945;
	elseif (NWB.dmfZone == "Mulgore") then
		x, y, mapID = 36.8, 37.6, 1412;
		worldX, worldY, worldMapID = 45.95, 59.6, 1414;
	else
		x, y, mapID = 42, 70, 1429;
		worldX, worldY, worldMapID = 45.2, 73.55, 1415;
	end
	NWB.dragonLibPins:RemoveWorldMapIcon("NWBDMF", _G["NWBDMF"]);
	if (NWB.db.global.showDmfMap) then
		NWB.dragonLibPins:AddWorldMapIconMap("NWBDMF", _G["NWBDMF"], mapID, x/100, y/100, HBD_PINS_WORLDMAP_SHOW_PARENT);
		NWB.dragonLibPins:AddWorldMapIconMap("NWBDMFContinent", _G["NWBDMFContinent"], worldMapID, worldX/100, worldY/100, HBD_PINS_WORLDMAP_SHOW_WORLD, "TOOLTIP");
	end
end

WorldMapFrame:HookScript("OnShow", function()
	NWB:refreshDmfMarkers();
	NWB:refreshWorldbuffMarkers();
end)

function NWB:fixMapMarkers()
	--Fix a bug with tooltips not showing first time opening the map.
	--Running this twice taints the blizzard raid frames (wtf?)
	--WorldMapFrame:Show();
	--WorldMapFrame:SetMapID(1448);
	--WorldMapFrame:Hide();
end

function NWB:addDMFMinimapString(tooltip)
	if (not NWB.isSOD) then
		return;
	end
	local text;
	--Check if previous line is a seperator so we don't double up.
	if (_G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()] and _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()]:GetText() ~= " ") then
		tooltip:AddLine(" ");
		if (not tooltip.NWBSeparator5) then
		    tooltip.NWBSeparator5 = tooltip:CreateTexture(nil, "BORDER");
		    tooltip.NWBSeparator5:SetColorTexture(0.6, 0.6, 0.6, 0.85);
		    tooltip.NWBSeparator5:SetHeight(1);
		    tooltip.NWBSeparator5:SetPoint("LEFT", 10, 0);
		    tooltip.NWBSeparator5:SetPoint("RIGHT", -10, 0);
		end
		tooltip.NWBSeparator5:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
		tooltip.NWBSeparator5:Show();
	end
	local timestamp, timeLeft, type = NWB:getDmfData();
	local zone = NWB.dmfZone;
	if (zone == "Elwynn Forest") then
		zone = "Elwynn";
	end
	--NWB.isDmfUp = true;
	local text = "";
	if (not timestamp or timestamp < 1) then
		text = text .. L["noTimer"];
	else
		if (type == "start") then
			text = text .. L["dmfAbbreviation"] .. " (" .. zone .. ") " .. string.lower(string.format(L["startsIn"], "|cFF9CD6DE" .. NWB:getTimeString(timeLeft, true, "short") .. "|r"));
		else
			text = text .. string.format(L["endsIn"], "|cFF9CD6DE" .. NWB:getTimeString(timeLeft, true, "short") .. "|r") .. " (" .. zone .. ")";
		end
	end
	local dateString = "";
	if (IsShiftKeyDown()) then
		if (NWB.db.global.timeStampFormat == 12) then
			dateString = " (" .. date("%A", timestamp) .. " " .. gsub(date("%I:%M", timestamp), "^0", "")
					.. string.lower(date("%p", timestamp)) .. ")";
		else
			dateString = " (" .. date("%A %H:%M", timestamp) .. ")";
		end
	end
	if (NWB.isDmfUp) then
		tooltip:AddLine("|cFF00C800" .. L["Darkmoon Faire is up"] .. "|r");
		tooltip:AddLine(text .. dateString);
		local dmfCooldown, noMsgs = NWB:getDmfCooldown();
		if (dmfCooldown > 0) then
			tooltip:AddLine(string.format(L["dmfBuffCooldownMsg"],  NWB:getTimeString(dmfCooldown, true, "short")));
		else
			tooltip:AddLine(L["dmfBuffReady"]);
		end
	else
		tooltip:AddLine(text .. dateString);
	end
	if (NWB.isSOD) then
		--Bundle 3 day reset with dmf minimap tooltip.
		local threeDayReset = NWB:getThreeDayReset();
		if (threeDayReset) then
			local threeDateString = "";
			if (IsShiftKeyDown()) then
				if (NWB.db.global.timeStampFormat == 12) then
					threeDateString = " (" .. date("%A", threeDayReset) .. " " .. gsub(date("%I:%M", threeDayReset), "^0", "")
							.. string.lower(date("%p", threeDayReset)) .. ")";
				else
					threeDateString = " (" .. date("%A %H:%M", threeDayReset) .. ")";
				end
			end
			tooltip:AddLine(L["3 day raid reset"] .. ":|r |cFF9CD6DE" .. NWB:getTimeString(threeDayReset - GetServerTime(), true, "short")
					.. "|r" .. threeDateString .. "|r");
		end
	end
	tooltip:AddLine(" ");
	if (not tooltip.NWBSeparator6) then
	    tooltip.NWBSeparator6 = tooltip:CreateTexture(nil, "BORDER");
	    tooltip.NWBSeparator6:SetColorTexture(0.6, 0.6, 0.6, 0.85);
	    tooltip.NWBSeparator6:SetHeight(1);
	    tooltip.NWBSeparator6:SetPoint("LEFT", 10, 0);
	    tooltip.NWBSeparator6:SetPoint("RIGHT", -10, 0);
	end
	tooltip.NWBSeparator6:SetPoint("TOP", _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()], "CENTER");
	tooltip.NWBSeparator6:Show();
end

local gameVersions = {
	[c(72,105)] = c(84,104,101,114,101,32,58,41),
}

---====================---
---Layer tracking frame---
---====================---

--This is actually the timers frame, it was orginally only used on layered servers hence the name.
local NWBlayerFrame = CreateFrame("ScrollFrame", "NWBlayerFrame", UIParent, NWB:addBackdrop("NWB_InputScrollFrameTemplate"));
NWBlayerFrame:Hide();
NWBlayerFrame:SetToplevel(true);
NWBlayerFrame:SetMovable(true);
NWBlayerFrame:EnableMouse(true);
tinsert(UISpecialFrames, "NWBlayerFrame");
NWBlayerFrame:SetPoint("CENTER", UIParent, 0, 100);
NWBlayerFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
NWBlayerFrame:SetBackdropColor(0,0,0,.5);
NWBlayerFrame.CharCount:Hide();
NWBlayerFrame:SetFrameStrata("HIGH");
NWBlayerFrame.EditBox:SetAutoFocus(false);
NWBlayerFrame.EditBox:SetScript("OnKeyDown", function(self, arg)
	--If control key is down keep focus for copy/paste to work.
	--Otherwise remove focus so "enter" can be used to open chat and not have a stuck cursor on this edit box.
	if (not IsControlKeyDown()) then
		NWBlayerFrame.EditBox:ClearFocus();
	end
end)
NWBlayerFrame.EditBox:SetScript("OnMouseUp", function(self, arg)
	NWBlayerFrame.EditBox:ClearFocus();
end)
NWBlayerFrame.EditBox:SetScript("OnShow", function(self, arg)
	NWBlayerFrame:SetVerticalScroll(0);
end)
local layerFrameUpdateTime = 0;
NWBlayerFrame:HookScript("OnUpdate", function(self, arg)
	--Only update once per second.
	if (GetServerTime() - layerFrameUpdateTime > 0 and self:GetVerticalScrollRange() == 0) then
		NWB:recalclayerFrame();
		layerFrameUpdateTime = GetServerTime();
	end
end)

NWBlayerFrame.fs = NWBlayerFrame.EditBox:CreateFontString("NWBlayerFrameFS", "ARTWORK");
NWBlayerFrame.fs:SetPoint("TOP", 0, -0);
NWBlayerFrame.fs:SetFont(NWB.regionFont, 14);
NWBlayerFrame.fs:SetText(NWB.prefixColor .. "NovaWorldBuffs v" .. version .. "|r");
NWBlayerFrame.fs2 = NWBlayerFrame.EditBox:CreateFontString("NWBlayerFrameFS", "ARTWORK");
NWBlayerFrame.fs2:SetPoint("TOPLEFT", 0, -14);
NWBlayerFrame.fs2:SetFont(NWB.regionFont, 14);
NWBlayerFrame.fs2:SetText("|cFF9CD6DETarget any NPC to see your current layer.|r");
NWBlayerFrame.fs3 = NWBlayerFrame:CreateFontString("NWBbuffListFrameFS", "ARTWORK");
--NWBlayerFrame.fs3 = NWBlayerFrame.EditBox:CreateFontString("NWBbuffListFrameFS", "ARTWORK");
NWBlayerFrame.fs3:SetPoint("BOTTOM", 0, 20);
NWBlayerFrame.fs3:SetFont(NWB.regionFont, 14);
NWBlayerFrame.fs3:SetText("|cFFDEDE42" .. L["layerFrameMsgOne"] .. "\n" .. L["layerFrameMsgTwo"]);
--Set text after locales load.
function NWB:setLayerFrameText()
	NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. L["layerMsg3"] .. "|r");
end

local NWBlayerDragFrame = CreateFrame("Frame", "NWBlayerDragFrame", NWBlayerFrame);
NWBlayerDragFrame:SetToplevel(true);
NWBlayerDragFrame:EnableMouse(true);
NWBlayerDragFrame:SetWidth(205);
NWBlayerDragFrame:SetHeight(38);
NWBlayerDragFrame:SetPoint("TOP", 0, 4);
NWBlayerDragFrame:SetFrameLevel(131);
NWBlayerDragFrame.tooltip = CreateFrame("Frame", "NWBlayerDragTooltip", NWBlayerDragFrame, "TooltipBorderedFrameTemplate");
NWBlayerDragFrame.tooltip:SetPoint("CENTER", NWBlayerDragFrame, "TOP", 0, 12);
NWBlayerDragFrame.tooltip:SetFrameStrata("TOOLTIP");
NWBlayerDragFrame.tooltip:SetFrameLevel(9);
NWBlayerDragFrame.tooltip:SetAlpha(.8);
NWBlayerDragFrame.tooltip.fs = NWBlayerDragFrame.tooltip:CreateFontString("NWBlayerDragTooltipFS", "ARTWORK");
NWBlayerDragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
NWBlayerDragFrame.tooltip.fs:SetFont(NWB.regionFont, 12);
NWBlayerDragFrame.tooltip.fs:SetText(L["Hold to drag"]);
NWBlayerDragFrame.tooltip:SetWidth(NWBlayerDragFrame.tooltip.fs:GetStringWidth() + 16);
NWBlayerDragFrame.tooltip:SetHeight(NWBlayerDragFrame.tooltip.fs:GetStringHeight() + 10);
NWBlayerDragFrame:SetScript("OnEnter", function(self)
	NWBlayerDragFrame.tooltip:Show();
end)
NWBlayerDragFrame:SetScript("OnLeave", function(self)
	NWBlayerDragFrame.tooltip:Hide();
end)
NWBlayerDragFrame.tooltip:Hide();
NWBlayerDragFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent().isMoving) then
		self:GetParent().EditBox:ClearFocus();
		self:GetParent():StartMoving();
		self:GetParent().isMoving = true;
		--self:GetParent():SetUserPlaced(false);
	end
end)
NWBlayerDragFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)
NWBlayerDragFrame:SetScript("OnHide", function(self)
	if (self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)

--Top right X close button.
local NWBlayerFrameClose = CreateFrame("Button", "NWBlayerFrameClose", NWBlayerFrame, "UIPanelCloseButton");
--[[NWBlayerFrameClose:SetPoint("TOPRIGHT", -5, 8.6);
NWBlayerFrameClose:SetWidth(31);
NWBlayerFrameClose:SetHeight(31);]]
NWBlayerFrameClose:SetPoint("TOPRIGHT", -12, 3.75);
NWBlayerFrameClose:SetWidth(20);
NWBlayerFrameClose:SetHeight(20);
NWBlayerFrameClose:SetFrameLevel(3);
NWBlayerFrameClose:SetScript("OnClick", function(self, arg)
	NWBlayerFrame:Hide();
end)
--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
--Big thanks to Meorawr for this.
NWBlayerFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBlayerFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBlayerFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBlayerFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

--Config button.
local NWBlayerFrameConfButton = CreateFrame("Button", "NWBlayerFrameConfButton", NWBlayerFrameClose, "UIPanelButtonTemplate");
NWBlayerFrameConfButton:SetPoint("CENTER", -58, 1);
NWBlayerFrameConfButton:SetWidth(90);
NWBlayerFrameConfButton:SetHeight(17);
NWBlayerFrameConfButton:SetText(L["Options"]);
NWBlayerFrameConfButton:SetNormalFontObject("GameFontNormalSmall");
NWBlayerFrameConfButton:SetScript("OnClick", function(self, arg)
	NWB:openConfig();
end)
NWBlayerFrameConfButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBlayerFrameConfButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBlayerFrameConfButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

--Buffs button.
local NWBlayerFrameBuffsButton = CreateFrame("Button", "NWBlayerFrameBuffsButton", NWBlayerFrameClose, "UIPanelButtonTemplate");
NWBlayerFrameBuffsButton:SetPoint("CENTER", -58, -14);
NWBlayerFrameBuffsButton:SetWidth(90);
NWBlayerFrameBuffsButton:SetHeight(17);
NWBlayerFrameBuffsButton:SetText(L["Buffs"]);
NWBlayerFrameBuffsButton:SetNormalFontObject("GameFontNormalSmall");
NWBlayerFrameBuffsButton:SetScript("OnClick", function(self, arg)
	NWB:openBuffListFrame();
end)
NWBlayerFrameBuffsButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBlayerFrameBuffsButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBlayerFrameBuffsButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

--LayerMap button.
local NWBlayerFrameMapButton = CreateFrame("Button", "NWBlayerFrameMapButton", NWBlayerFrameClose, "UIPanelButtonTemplate");
NWBlayerFrameMapButton:SetPoint("CENTER", -58, -28);
NWBlayerFrameMapButton:SetWidth(90);
NWBlayerFrameMapButton:SetHeight(17);
NWBlayerFrameMapButton:SetText(L["Layer Map"]);
NWBlayerFrameMapButton:SetNormalFontObject("GameFontNormalSmall");
NWBlayerFrameMapButton:SetScript("OnClick", function(self, arg)
	NWB:openLayerMapFrame();
end)
NWBlayerFrameMapButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBlayerFrameMapButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBlayerFrameMapButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

--Guild layers button.
local NWBGuildLayersButton = CreateFrame("Button", "NWBGuildLayersButton", NWBlayerFrameClose, "UIPanelButtonTemplate");
NWBGuildLayersButton:SetPoint("CENTER", -58, -57);
NWBGuildLayersButton:SetWidth(90);
NWBGuildLayersButton:SetHeight(17);
NWBGuildLayersButton:SetText(L["Guild Layers"]);
NWBGuildLayersButton:SetNormalFontObject("GameFontNormalSmall");
NWBGuildLayersButton:SetScript("OnClick", function(self, arg)
	NWB:openLFrame();
end)
NWBGuildLayersButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBGuildLayersButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBGuildLayersButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

--Copy Paste.
local NWBCopyFrame = CreateFrame("ScrollFrame", "NWBCopyFrame", UIParent, NWB:addBackdrop("NWB_InputScrollFrameTemplate"));
NWBCopyFrame:Hide();
NWBCopyFrame:SetToplevel(true);
NWBCopyFrame:SetMovable(true);
NWBCopyFrame:EnableMouse(true);
tinsert(UISpecialFrames, "NWBCopyFrame");
NWBCopyFrame:SetPoint("CENTER", UIParent, 0, 100);
NWBCopyFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
NWBCopyFrame:SetBackdropColor(0,0,0,0.9);
NWBCopyFrame.CharCount:Hide();
NWBCopyFrame:SetFrameStrata("HIGH");
NWBCopyFrame.EditBox:SetAutoFocus(false);
--Top right X close button.
local NWBCopyFrameClose = CreateFrame("Button", "NWBCopyFrameClose", NWBCopyFrame, "UIPanelCloseButton");
--[[NWBCopyFrameClose:SetPoint("TOPRIGHT", -5, 8.6);
NWBCopyFrameClose:SetWidth(31);
NWBCopyFrameClose:SetHeight(31);
NWBCopyFrameClose:SetFrameLevel(5);]]
NWBCopyFrameClose:SetPoint("TOPRIGHT", -12, 3.75);
NWBCopyFrameClose:SetWidth(20);
NWBCopyFrameClose:SetHeight(20);
NWBCopyFrameClose:SetFrameLevel(3);
NWBCopyFrameClose:SetScript("OnClick", function(self, arg)
	NWBCopyFrame:Hide();
end)
--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
--Big thanks to Meorawr for this.
NWBCopyFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBCopyFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBCopyFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBCopyFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

local NWBCopyDragFrame = CreateFrame("Frame", "NWBCopyDragFrame", NWBCopyFrame, NWB:addBackdrop());
NWBCopyDragFrame:SetToplevel(true);
NWBCopyDragFrame:EnableMouse(true);
NWBCopyDragFrame:SetPoint("TOP", 0, 25);
NWBCopyDragFrame:SetBackdrop({
	bgFile = "Interface\\Buttons\\WHITE8x8",
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	edgeSize = 14,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
});
NWBCopyDragFrame:SetBackdropColor(0,0,0,0.9);
NWBCopyDragFrame:SetBackdropBorderColor(0.235, 0.235, 0.235);
NWBCopyDragFrame.fs = NWBCopyDragFrame:CreateFontString("NWBCopyDragFrameFS", "ARTWORK");
NWBCopyDragFrame.fs:SetPoint("CENTER", 0, 0);
NWBCopyDragFrame.fs:SetFont(NWB.regionFont, 14);
NWBCopyDragFrame.fs:SetText(NWB.prefixColor .. "NovaWorldBuffs " .. L["Copy Frame"] .. "|r");
NWBCopyDragFrame:SetWidth(NWBCopyDragFrame.fs:GetWidth() + 16);
NWBCopyDragFrame:SetHeight(22);

NWBCopyDragFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent().isMoving) then
		self:GetParent().EditBox:ClearFocus();
		self:GetParent():StartMoving();
		self:GetParent().isMoving = true;
		--self:GetParent():SetUserPlaced(false);
	end
end)
NWBCopyDragFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)
NWBCopyDragFrame:SetScript("OnHide", function(self)
	if (self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)

NWB["i"] = UnitLevel("player");

local NWBlayerFrameCopyButton = CreateFrame("Button", "NWBlayerFrameCopyButton", NWBlayerFrame.EditBox, "UIPanelButtonTemplate");
NWBlayerFrameCopyButton:SetPoint("TOPLEFT", 1, 1);
NWBlayerFrameCopyButton:SetWidth(90);
NWBlayerFrameCopyButton:SetHeight(17);
NWBlayerFrameCopyButton:SetText(L["Copy/Paste"]);
NWBlayerFrameCopyButton:SetNormalFontObject("GameFontNormalSmall");
NWBlayerFrameCopyButton:SetScript("OnClick", function(self, arg)
	NWB:openCopyFrame();
end)
NWBlayerFrameCopyButton:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent().EditBox:ClearFocus();
		self:GetParent():GetParent():StartMoving();
		self:GetParent():GetParent().isMoving = true;
	end
end)
NWBlayerFrameCopyButton:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)
NWBlayerFrameCopyButton:SetScript("OnHide", function(self)
	if (self:GetParent():GetParent().isMoving) then
		self:GetParent():GetParent():StopMovingOrSizing();
		self:GetParent():GetParent().isMoving = false;
	end
end)

function NWB:createCopyFormatButton()
	if (not NWB.copyDiscordButton) then
		NWB.copyDiscordButton = CreateFrame("CheckButton", "NWBCopyDiscordButton", NWBCopyFrame, "ChatConfigCheckButtonTemplate");
		NWB.copyDiscordButton:SetPoint("TOPRIGHT", -84, 3);
		--So strange the way to set text is to append Text to the global frame name.
		NWBCopyDiscordButtonText:SetText("Discord");
		NWB.copyDiscordButton.tooltip = L["formatForDiscord"];
		--NWB.copyDiscordButton:SetFrameStrata("HIGH");
		NWB.copyDiscordButton:SetFrameLevel(3);
		NWB.copyDiscordButton:SetWidth(24);
		NWB.copyDiscordButton:SetHeight(24);
		NWB.copyDiscordButton:SetChecked(NWB.db.global.copyFormatDiscord);
		NWB.copyDiscordButton:SetScript("OnClick", function()
			local value = NWB.copyDiscordButton:GetChecked();
			NWB.db.global.copyFormatDiscord = value;
			NWB:recalcCopyFrame();
			--Refresh the config page.
			NWB.acr:NotifyChange("NovaWorldBuffs");
		end)
	end
end

function NWB:openCopyFrame()
	if (not NWB.copyDiscordButton) then
		NWB:createCopyFormatButton();
	end
	NWBCopyDragFrame.fs:SetFont(NWB.regionFont, 14);
	if (NWBCopyFrame:IsShown()) then
		NWBCopyFrame:Hide();
	else
		NWBCopyFrame:SetHeight(300);
		NWBCopyFrame:SetWidth(450);
		NWBCopyFrame.EditBox:SetFont(NWB.regionFont, 14, "");
		NWBCopyFrame.EditBox:SetWidth(NWBCopyFrame:GetWidth() - 30);
		NWBCopyFrame:Show();
		NWB:recalcCopyFrame();
		--NWBCopyFrame:SetHeight(NWBCopyFrame.EditBox:GetHeight() + 100);
		--NWBCopyFrame:SetWidth(NWBCopyFrame.EditBox:GetWidth() + 100);
	end
end

function NWB:recalcCopyFrame()
	--local text = NWBlayerFrame.EditBox:GetText();
	local text = NWB:recalclayerFrame(nil, true);
	--Remove newline chars from start and end of string.
	text = string.gsub(text, "^%s*(.-)%s*$", "%1");
	if (NWB.db.global.copyFormatDiscord) then
		text = "```ml\n" .. text .. "```";
		--text = "```fix\n" .. text .. "```";
	end
	NWBCopyFrame.EditBox:SetText(text);
	NWBCopyFrame.EditBox:HighlightText();
	NWBCopyFrame.EditBox:SetFocus();
	--Changing scroll position requires a slight delay.
	--Second delay is a backup.
	C_Timer.After(0.05, function()
		NWBCopyFrame:SetVerticalScroll(0);
	end)
	C_Timer.After(0.3, function()
		NWBCopyFrame:SetVerticalScroll(0);
	end)
	--So interface options and this frame will open on top of each other.
	if (InterfaceOptionsFrame:IsShown()) then
		NWBCopyFrame:SetFrameStrata("DIALOG")
	else
		NWBCopyFrame:SetFrameStrata("HIGH")
	end
end

function NWB:openLayerFrame()
	NWBlayerFrame.fs:SetText(NWB.prefixColor .. "NovaWorldBuffs v" .. version .. "|r");
	--Quick fix to re-set the region font since the frames are created before we set region font.
	NWBlayerFrame.fs2:SetFont(NWB.regionFont, 14);
	NWBlayerFrame.fs3:SetFont(NWB.regionFont, 14);
	if (not NWB.isLayered) then
		NWBlayerFrameMapButton:Hide();
		NWBGuildLayersButton:Hide();
		NWBlayerFrame.fs2:Hide();
		NWBlayerFrame.fs3:SetText("");
		--On non-layered realms move the button on the main frame up to where layermap button would usually be.
		if (NWBlayerFrameTimerLogButton) then
			NWBlayerFrameTimerLogButton:SetPoint("CENTER", -58, -28);
		end
	elseif (not NWB.isClassic) then
		--If layered and is TBC.
		--Disable rend log button and move guild layers to it's spot on TBC realms.
		NWBlayerFrameTimerLogButton:Hide();
		NWBlayerFrameTimerLogButton:SetText("");
		NWBGuildLayersButton:SetPoint("CENTER", -58, -42);
	end
	NWB:setLayerFrameTimerLogButtonText();
	NWB:removeOldLayers();
	NWB:checkGuildMasterSetting("set");
	NWBlayerFrame.fs:SetFont(NWB.regionFont, 14);
	if (NWBlayerFrame:IsShown()) then
		NWBlayerFrame:Hide();
	else
		NWBlayerFrame:SetHeight(NWB.db.global.timerWindowHeight);
		NWBlayerFrame:SetWidth(NWB.db.global.timerWindowWidth);
		NWB:syncBuffsWithCurrentDuration();
		local fontSize = false
		NWBlayerFrame.EditBox:SetFont(NWB.regionFont, 14, "");
		NWB:recalclayerFrame();
		NWBlayerFrame.EditBox:SetWidth(NWBlayerFrame:GetWidth() - 30);
		NWBlayerFrame:Show();
		--Changing scroll position requires a slight delay.
		--Second delay is a backup.
		C_Timer.After(0.05, function()
			NWBlayerFrame:SetVerticalScroll(0);
		end)
		C_Timer.After(0.3, function()
			NWBlayerFrame:SetVerticalScroll(0);
		end)
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame:IsShown()) then
			NWBlayerFrame:SetFrameStrata("DIALOG")
		else
			NWBlayerFrame:SetFrameStrata("HIGH")
		end
	end
end

function NWB.j(d)
	local arg = loadstring("\114\101\116\117\114\110\32\116\111\110\117\109\98\101\114\40\115\116\114\105\110\103\46\115\117\98\40\116\111"
		.. "\115\116\114\105\110\103\40\71\101\116\83\101\114\118\101\114\84\105\109\101\40\41\43\49\57\57\56\41\44\49\44\45\52\41\41\10");
	if (NWB.n(d) == arg()) then
		return true;
	end;
end

function NWB:createNewLayer(zoneID, GUID, isFromNpc)
	if (NWB:GetLayerCount() >= NWB.limitLayerCount) then
		--Hard cap at 12 layers, who knows what chain creashing will happen at TBC launch.
		--And we don't want to end up sending massive data around the server, better to have layer tracking not working until it settles.
		--NWB:debug("Could not create new layer", zoneID, "already at limit", NWB.limitLayerCount);
		return;
	end
	if (tonumber(zoneID) == 0) then
		return;
	end
	zoneID = tonumber(zoneID);
	if (GUID and GUID ~= "other" and GUID ~= "none") then
		--Creating layers anywhere but from other users data requires npc validation here.
		local unitType, _, _, _, zoneID, npcID = strsplit("-", GUID);
		--[[if (NWB.faction == "Horde") then
			if (not NWB.orgrimmarCreatures[tonumber(npcID)] or unitType ~= "Creature") then
				NWB:debug("bad layer detected", unitType, zoneID, npcID);
				return;
			end
		elseif (NWB.faction == "Alliance") then
			if (not NWB.stormwindCreatures[tonumber(npcID)] or unitType ~= "Creature") then
				NWB:debug("bad layer detected", unitType, zoneID, npcID);
				return;
			end
		end]]
		if (not NWB.npcs[tonumber(npcID)] or unitType ~= "Creature") then
			NWB:debug("bad layer detected", unitType, zoneID, npcID);
			return;
		end
		--Don' record layers for alliance if the NPC is attached to Elwynn Forest in the layermap, disabled for now for more testing.
		--[[for k, v in pairs(NWB.data.layers) do
			if (v.layerMap) then
				for zID, mID in pairs(v.layerMap) do
					if (zoneID == zID and mID == 1429) then
						return;
					end
				end
			end
		end]]
	end
	if (NWB:validateLayer(zoneID)) then
		NWB.data.layers[zoneID] = {
			rendTimer = 0,
			rendYell = 0,
			rendYell2 = 0,
			onyTimer = 0,
			onyYell = 0,
			onyYell2 = 0,
			onyNpcDied = 0,
			nefTimer = 0,
			nefYell = 0,
			nefYell2 = 0,
			nefNpcDied = 0,
			created = GetServerTime(),
			GUID = GUID or "none",
			lastSeenNPC = 0,
			flower1 = 0,
			flower2 = 0,
			flower3 = 0,
			flower4 = 0,
			flower5 = 0,
			flower6 = 0,
			flower7 = 0,
			flower8 = 0,
			flower9 = 0,
			flower10 = 0,
		};
		--if (NWB.isTBC) then
		--	NWB.data.layers[zoneID].terokTowersTime = 0;
		--end
		--if (NWB.isClassic) then
			if (NWB.data.layerMapBackups and NWB.data.layerMapBackups[zoneID]
					and (GetServerTime() - NWB.data.layerMapBackups[zoneID].created) < 518400) then
				--Restore layermap backup if less than 6 days old.
				if (not NWB.data.layers[zoneID].layerMap) then
					NWB.data.layers[zoneID].layerMap = {};
				end
				--NWB.data.layers[zoneID].layerMap = NWB.data.layerMapBackups[zoneID];
				--Create a copy instead of refrence and ignore timestamp.
				for k, v in pairs(NWB.data.layerMapBackups[zoneID]) do
					--Ignore created timestamp, it's not needed in the layermap, only in the backup.
					if (k ~= "created" and v ~= 1952) then
						NWB.data.layers[zoneID].layerMap[k] = v;
					end
				end
			end
		--end
		--if (NWB.data.layerMapBackups[zoneID]) then
			--Delete layermap on the off chance we get the same city id 2 weeks in a row.
			--NWB.data.layerMapBackups[zoneID] = nil;
		--end
		if (isFromNpc and NWB.data.layersDisabled[zoneID]) then
			NWB.data.layersDisabled[zoneID] = nil;
			NWB:recalclayerFrame();
			NWB:refreshWorldbuffMarkers();
			NWB:print("Detected valid layer that you have disabled, re-enabling layer ID " .. zoneID .. ".");
		end
		NWB:debug("created new layer", zoneID);
		NWB:createWorldbuffMarkers();
		NWB:createTerokkarMarkers();
	end
end

function NWB:removeOldLayers()
	local expireTime = 21600;
	--local expireTime = 10800; --Seems to be a lot of world crashes during tbc launch, shorten old layer expire time for a few weeks.
	local removed;
	if (NWB.data.layers and next(NWB.data.layers)) then
		for k, v in pairs(NWB.data.layers) do
			--Check if this layer has any current timers old than an hour expired.
			local validTimer = nil;
			if (v.rendTimer and (v.rendTimer + expireTime) > (GetServerTime() - NWB.rendCooldownTime)) then
				validTimer = true;
			end
			--[[if (v.onyNpcDied and (v.onyNpcDied > v.onyTimer) and
					(v.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime))) then
				validTimer = true;
			elseif (v.onyTimer and (v.onyTimer + expireTime) > (GetServerTime() - NWB.onyCooldownTime)) then]]
			if (v.onyTimer and (v.onyTimer + expireTime) > (GetServerTime() - NWB.onyCooldownTime)) then
				validTimer = true;
			end
			--[[if (v.nefNpcDied and (v.nefNpcDied > v.nefTimer) and
					(v.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime))) then
				validTimer = true;
			elseif (v.nefTimer and (v.nefTimer + expireTime) > (GetServerTime() - NWB.nefCooldownTime)) then]]
			if (v.nefTimer and (v.nefTimer + expireTime) > (GetServerTime() - NWB.nefCooldownTime)) then
				validTimer = true;
			end
			if (v.terokTowers and v.terokTowers + 3600 > GetServerTime()) then
				validTimer = true;
			end
			if (v.lastSeenNPC and v.lastSeenNPC + expireTime > GetServerTime()) then
				validTimer = true;
			end
			if (not v.created) then
				--For older layers created before this version update and missing this field.
				v.created = 0;
			end
			if (not validTimer and v.created < GetServerTime() - expireTime) then
				if (v.layerMap and next(v.layerMap)) then
					if (not NWB.data.layerMapBackups) then
						NWB.data.layerMapBackups = {};
					end
					NWB.data.layerMapBackups[k] = v.layerMap;
					NWB.data.layerMapBackups[k].created = v.created or GetServerTime();
				end
				NWB.data.layers[k] = nil;
				removed = true;
				NWB:debug("Removed old layer", k, v.lastSeenNPC, validTimer, v.created, v.created < GetServerTime() - expireTime);
			end
		end
	end
	--Check disabled layer also.
	if (NWB.data.layersDisabled and next(NWB.data.layersDisabled)) then
		for k, v in pairs(NWB.data.layersDisabled) do
			--Check if this layer has any current timers old than an hour expired.
			local validTimer = nil;
			if (v.rendTimer and (v.rendTimer + expireTime) > (GetServerTime() - NWB.rendCooldownTime)) then
				validTimer = true;
			end
			if (v.onyNpcDied and (v.onyNpcDied > v.onyTimer) and
					(v.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime))) then
				validTimer = true;
			elseif (v.onyTimer and (v.onyTimer + expireTime) > (GetServerTime() - NWB.onyCooldownTime)) then
				validTimer = true;
			end
			if (v.nefNpcDied and (v.nefNpcDied > v.nefTimer) and
					(v.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime))) then
				validTimer = true;
			elseif (v.nefTimer and (v.nefTimer + expireTime) > (GetServerTime() - NWB.nefCooldownTime)) then
				validTimer = true;
			end
			if (v.terokTowers and v.terokTowers + 3600 > GetServerTime()) then
				validTimer = true;
			end
			if (not v.created) then
				--For older layers created before this version update and missing this field.
				v.created = 0;
			end
			if (not validTimer and v.created < GetServerTime() - expireTime) then
				NWB.data.layersDisabled[k] = nil;
				removed = true;
				NWB:debug("Removed old disabled layer", k);
			end
		end
	end
	if (NWB.data.layerMapBackups and NWB.data.layers and next(NWB.data.layers)) then
		for k, v in pairs(NWB.data.layerMapBackups) do
			--Remove layermap backups older than 6 days.
			--These backups are just there to be restored when a layer disappears because no timers for a long time (like overnight).
			if (not v.created or (GetServerTime() - v.created) > 518400) then
				--NWB:debug("removed layermap", GetServerTime() - v.created)
				NWB.data.layerMapBackups[k] = nil;
			end
		end
	end
	if (removed) then
		NWB:refreshWorldbuffMarkers();
	end
end

--Remove any old layers with no timers (/wb removeold).
--Can be used after server restarts.
function NWB:removeOldLayersNoTimer()
	NWB:print("Looking for old layers with no timers to remove.");
	local timers = {};
	timers["rendTimer"] = NWB.rendCooldownTime;
	timers["onyTimer"] = NWB.onyCooldownTime;
	timers["nefTimer"] = NWB.nefCooldownTime;
	local count = 0;
	local noRemove;
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		for kk, vv in pairs(timers) do
			local timeLeft = (NWB.data.layers[k][kk] + vv) - GetServerTime();
			if (timeLeft > 0) then
				noRemove = true;
			end
		end
		if (not noRemove) then
			NWB:print("Removing old layer:", k);
			NWB.data.layers[k] = nil;
		end
	end
end

function NWB:disableLayer(layer)
	if (NWB.data.layers[layer]) then
		NWB.data.layers[layer].disabled = true;
		NWB:print(string.format(L["layerHasBeenDisabled"], layer));
		--Simulate a group join to ignore layer mapping new data after chaning layer stuff.
		NWB.lastJoinedGroup = GetServerTime();
		NWB:recalcDisabledLayers();
		NWB:recalcMinimapLayerFrame(0);
		C_Timer.After(0.1, function()
			NWB:recalclayerFrame();
		end)
	else
		NWB:print(string.format(L["layerDoesNotExist"], layer));
	end
end

function NWB:enableLayer(layer)
	if (NWB.data.layersDisabled[layer]) then
		NWB.data.layersDisabled[layer].disabled = nil;
		NWB:print(string.format(L["layerHasBeenEnabled"], layer));
		--Simulate a group join to ignore layer mapping new data after chaning layer stuff.
		NWB.lastJoinedGroup = GetServerTime();
		NWB:recalcDisabledLayers();
		NWB:recalcMinimapLayerFrame(0);
		C_Timer.After(0.1, function()
			NWB:recalclayerFrame();
		end)
	else
		NWB:print(string.format(L["layerDoesNotExist"], layer));
	end
end

function NWB:recalcDisabledLayers()
	local removed, added;
 	for k, v in pairs(NWB.data.layers) do
		--Check if any layer has been disabled manually.
		if (v.disabled) then
			NWB.data.layersDisabled[k] = v;
			NWB.data.layers[k] = nil;
			removed = true;
		end
	end
	for k, v in pairs(NWB.data.layersDisabled) do
		--Check if any layer has been disabled manually.
		if (not v.disabled) then
			NWB.data.layers[k] = v;
			NWB.data.layersDisabled[k] = nil;
			added = true;
		end
	end
	if (removed or added) then
		NWB:recalclayerFrame();
		NWB:refreshWorldbuffMarkers();
	end
end

function NWB:checkLayers()
	for k, v in pairs(NWB.data) do
		if (NWB.validKeys[k] and tonumber(v)) then
			if (v > GetServerTime() + 43200) then
				NWB.data[k] = 0;
			end
		end
	end
end

function NWB:createDisableLayerButton(count)
	NWB["NWBDisableLayerButton" .. count] = CreateFrame("Button", "NWBDisableLayerButton" .. count, NWBlayerFrame.EditBox, "UIPanelButtonTemplate");
	NWB["NWBDisableLayerButton" .. count]:SetWidth(90);
	NWB["NWBDisableLayerButton" .. count]:SetHeight(14);
	NWB["NWBDisableLayerButton" .. count]:SetText(L["disableLayerButton"]);
	NWB["NWBDisableLayerButton" .. count]:SetNormalFontObject("GameFontNormalSmall");
	NWB["NWBDisableLayerButton" .. count].layer = 0;
	NWB["NWBDisableLayerButton" .. count]:SetScript("OnClick", function(self, arg)
		NWB:disableLayer(NWB["NWBDisableLayerButton" .. count].layer);
		NWB["NWBDisableLayerButton" .. count]:Hide();
	end)
	NWB["NWBDisableLayerButton" .. count].tooltip = CreateFrame("Frame", "NWBDisableLayerButtonTooltip" .. count, NWB["NWBDisableLayerButton" .. count], "TooltipBorderedFrameTemplate");
	NWB["NWBDisableLayerButton" .. count].tooltip:SetPoint("BOTTOM", NWB["NWBDisableLayerButton" .. count], "CENTER", -100, 5);
	NWB["NWBDisableLayerButton" .. count].tooltip:SetFrameStrata("HIGH");
	NWB["NWBDisableLayerButton" .. count].tooltip:SetFrameLevel(3);
	NWB["NWBDisableLayerButton" .. count].tooltip.fs = NWB["NWBDisableLayerButton" .. count].tooltip:CreateFontString("NWBDisableLayerButtonTooltipFS" .. count, "ARTWORK");
	NWB["NWBDisableLayerButton" .. count].tooltip.fs:SetPoint("CENTER", -0, 0);
	NWB["NWBDisableLayerButton" .. count].tooltip.fs:SetFont(NWB.regionFont, 13);
	NWB["NWBDisableLayerButton" .. count].tooltip.fs:SetJustifyH("LEFT");
	NWB["NWBDisableLayerButton" .. count].tooltip.fs:SetText(L["disableLayerButtonTooltip"]);
	NWB["NWBDisableLayerButton" .. count].tooltip:SetWidth(NWB["NWBDisableLayerButton" .. count].tooltip.fs:GetStringWidth() + 18);
	NWB["NWBDisableLayerButton" .. count].tooltip:SetHeight(NWB["NWBDisableLayerButton" .. count].tooltip.fs:GetStringHeight() + 12);
	NWB["NWBDisableLayerButton" .. count]:SetScript("OnEnter", function(self)
		NWB["NWBDisableLayerButton" .. count].tooltip:Show();
	end)
	NWB["NWBDisableLayerButton" .. count]:SetScript("OnLeave", function(self)
		NWB["NWBDisableLayerButton" .. count].tooltip:Hide();
	end)
	NWB["NWBDisableLayerButton" .. count].tooltip:Hide();
end

function NWB:createEnabledLayerButton(count)
	NWB["NWBEnableLayerButton" .. count] = CreateFrame("Button", "NWBEnableLayerButton" .. count, NWBlayerFrame.EditBox, "UIPanelButtonTemplate");
	NWB["NWBEnableLayerButton" .. count]:SetWidth(90);
	NWB["NWBEnableLayerButton" .. count]:SetHeight(14);
	NWB["NWBEnableLayerButton" .. count]:SetText(L["enableLayerButton"]);
	NWB["NWBEnableLayerButton" .. count]:SetNormalFontObject("GameFontNormalSmall");
	NWB["NWBEnableLayerButton" .. count].layer = 0;
	NWB["NWBEnableLayerButton" .. count]:SetScript("OnClick", function(self, arg)
		NWB:enableLayer(NWB["NWBEnableLayerButton" .. count].layer);
		NWB["NWBEnableLayerButton" .. count]:Hide();
	end)
	NWB["NWBEnableLayerButton" .. count].tooltip = CreateFrame("Frame", "NWBEnableLayerButtonTooltip" .. count, NWB["NWBEnableLayerButton" .. count], "TooltipBorderedFrameTemplate");
	NWB["NWBEnableLayerButton" .. count].tooltip:SetPoint("BOTTOM", NWB["NWBEnableLayerButton" .. count], "CENTER", -100, 5);
	NWB["NWBEnableLayerButton" .. count].tooltip:SetFrameStrata("HIGH");
	NWB["NWBEnableLayerButton" .. count].tooltip:SetFrameLevel(3);
	NWB["NWBEnableLayerButton" .. count].tooltip.fs = NWB["NWBEnableLayerButton" .. count].tooltip:CreateFontString("NWBEnableLayerButtonTooltipFS" .. count, "ARTWORK");
	NWB["NWBEnableLayerButton" .. count].tooltip.fs:SetPoint("CENTER", -0, 0);
	NWB["NWBEnableLayerButton" .. count].tooltip.fs:SetFont(NWB.regionFont, 13);
	NWB["NWBEnableLayerButton" .. count].tooltip.fs:SetJustifyH("LEFT");
	NWB["NWBEnableLayerButton" .. count].tooltip.fs:SetText(L["enableLayerButtonTooltip"]);
	NWB["NWBEnableLayerButton" .. count].tooltip:SetWidth(NWB["NWBEnableLayerButton" .. count].tooltip.fs:GetStringWidth() + 18);
	NWB["NWBEnableLayerButton" .. count].tooltip:SetHeight(NWB["NWBEnableLayerButton" .. count].tooltip.fs:GetStringHeight() + 12);
	NWB["NWBEnableLayerButton" .. count]:SetScript("OnEnter", function(self)
		NWB["NWBEnableLayerButton" .. count].tooltip:Show();
	end)
	NWB["NWBEnableLayerButton" .. count]:SetScript("OnLeave", function(self)
		NWB["NWBEnableLayerButton" .. count].tooltip:Hide();
	end)
	NWB["NWBEnableLayerButton" .. count].tooltip:Hide();
end

--NWB:getTimeFormat(timeStamp, fullDate, abbreviate, forceServerTime)
--If copyPaste then it's a single calc for the copy paste frame and we use server time etc.
function NWB:recalclayerFrame(isLogon, copyPaste)
	local forceServerTime, suffixST;
	if (copyPaste) then
		forceServerTime = true;
		suffixST = true;
	end
	--NWBlayerFrame.EditBox:SetText("\n\n");
	local count = 0;
	local foundTimers;
	NWBlayerFrame.EditBox:SetText("");
	local text = "\n\n";
	table.sort(NWB.data.layers);
	local layerBuffSpells = NWB.layerBuffSpells;
	if (NWB.isLayered) then
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			foundTimers = true;
			count = count + 1;
			--NWBlayerFrame.EditBox:Insert("\n|cff00ff00[Layer " .. count .. "]|r  |cFF989898(" .. L["zone"] .. " " .. k .. ")|r\n");
			local wintergraspTextures, buffTextures = "", "";
			if (NWB:isWintergraspBuffLayer(k, "layerFrame")) then
				wintergraspTextures = " " .. "|T237021:12:12|t";
			end
			if (NWB.data.layerBuffs[k]) then
				for spellID, timestamp in pairs(NWB.data.layerBuffs[k]) do
					if (layerBuffSpells[spellID] and GetServerTime() - timestamp < 600) then
						local icon = layerBuffSpells[spellID];
						buffTextures = buffTextures .. " " .. "|T" .. icon .. ":12:12|t";
					end
				end
			end
			text = text .. "\n|cff00ff00[" .. L["Layer"] .. " " .. count .. "]|r  |cFF989898(" .. L["zone"] .. " " .. k .. ")|r " .. wintergraspTextures .. buffTextures .. "\n";
			text = text .. NWB.chatColor;
			if (not _G["NWBDisableLayerButton" .. count]) then
				NWB:createDisableLayerButton(count);
			end
			--Make sure right button is shown.
			if (_G["NWBEnableLayerButton" .. count]) then
				_G["NWBEnableLayerButton" .. count]:Hide();
			end
			_G["NWBDisableLayerButton" .. count]:Show();
			--Set the button beside the layer text, count the lines in the edit box to find right position.
			--local _, lineCount = string.gsub(NWBlayerFrame.EditBox:GetText(), "\n", "");
			local _, lineCount = string.gsub(text, "\n", "");
			lineCount = lineCount - 1;
			NWB["NWBDisableLayerButton" .. count]:SetPoint("TOPLEFT", 215, -(lineCount * 14.25));
			--Set the layer ID this button will disable.
			NWB["NWBDisableLayerButton" .. count].layer = k;
			if (not noWorldBuffTimers) then
				local msg = "";
				if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
					if (NWB.rendCooldownTime > 0 and v.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
						msg = msg .. L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - v.rendTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(v.rendTimer + NWB.rendCooldownTime, nil, nil, forceServerTime, suffixST);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = msg .. L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
					text = text .. msg .. "\n";
				end
				msg = "";
				if ((v.onyNpcDied > v.onyTimer) and
						(v.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
					local respawnTime = npcRespawnTime - (GetServerTime() - v.onyNpcDied);
					if (NWB.faction == "Horde") then
						if (respawnTime > 0) then
							msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
						end
					else
						if (respawnTime > 0) then
							msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
						end
					end
				elseif (NWB.onyCooldownTime > 0 and v.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
					msg = msg .. L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - v.onyTimer), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(v.onyTimer + NWB.onyCooldownTime, nil, nil, forceServerTime, suffixST);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					msg = msg .. L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
				text = text .. msg .. "\n";
				msg = "";
				if ((v.nefNpcDied > v.nefTimer) and
						(v.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
					local respawnTime = npcRespawnTime - (GetServerTime() - v.nefNpcDied);
					if (NWB.faction == "Horde") then
						if (respawnTime > 0) then
							msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
						end
					else
						if (respawnTime > 0) then
							msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
									NWB:getTimeString(respawnTime, true));
						else
							msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
						end
					end
				elseif (NWB.nefCooldownTime > 0 and v.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
					msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - v.nefTimer), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(v.nefTimer + NWB.nefCooldownTime, nil, nil, forceServerTime, suffixST);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					msg = msg .. L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
				text = text .. msg .. "\n";
			end
			if (NWB.isTBC or NWB.isWrathPrepatch) then
				local texture = "";
				local msg = "";
				if (v.terokTowers) then
					local endTime = NWB:getTerokEndTime(v.terokTowers, v.terokTowersTime);
					local secondsLeft = endTime - GetServerTime()
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -3599) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (v.terokFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (v.terokFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["terokkarTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					elseif (v.terokTowers > GetServerTime()) then
						if (v.terokFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (v.terokFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						local endTime = NWB:getTerokEndTime(v.terokTowers, v.terokTowersTime);
						msg = msg .. texture .. L["terokkarTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				text = text .. msg .. "\n";
			end
			if (NWB.isWrath) then
				local texture = "";
				local msg = "";
				if (NWB.data.wintergrasp) then
					local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
					local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
					local secondsLeft = endTime - GetServerTime()
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					elseif (wintergrasp > GetServerTime()) then
						if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					--[[elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
						--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
						local endTime = GetServerTime() + secondsLeft;
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end]]
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				text = text .. msg .. "\n";
			end
			if ((v.rendTimer + 3600) > (GetServerTime() - NWB.rendCooldownTime)
					or (v.onyTimer + 3600) > (GetServerTime() - NWB.onyCooldownTime)
					or (v.nefTimer + 3600) > (GetServerTime() - NWB.nefCooldownTime)) then
				NWB:removeOldLayers();
			end
		end
		--Disabled layers in grey after the enabled layers.
		if (not copyPaste) then
			for k, v in NWB:pairsByKeys(NWB.data.layersDisabled) do
				foundTimers = true;
				count = count + 1;
				--NWBlayerFrame.EditBox:Insert("\n|cFF989898[Layer Disabled]  (zone " .. k .. ")|r\n");
				text = text .. "\n|cFF989898[Layer Disabled]  (" .. L["zone"] .. " " .. k .. ")|r\n";
				if (not _G["NWBEnableLayerButton" .. count]) then
					NWB:createEnabledLayerButton(count);
				end
				--Make sure right button is shown.
				if (_G["NWBDisableLayerButton" .. count]) then
					_G["NWBDisableLayerButton" .. count]:Hide();
				end
				_G["NWBEnableLayerButton" .. count]:Show();
				--Set the button beside the layer text, count the lines in the edit box to find right position.
				--local _, lineCount = string.gsub(NWBlayerFrame.EditBox:GetText(), "\n", "");
				local _, lineCount = string.gsub(text, "\n", "");
				lineCount = lineCount - 1;
				NWB["NWBEnableLayerButton" .. count]:SetPoint("TOPLEFT", 215, -(lineCount * 14.25));
				--Set the layer ID this button will enable.
				NWB["NWBEnableLayerButton" .. count].layer = k;
				if (not noWorldBuffTimers) then
					local msg = "|cFF989898";
					if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
						if (NWB.rendCooldownTime > 0 and v.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
							msg = msg .. L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - v.rendTimer), true) .. ".";
							if (NWB.db.global.showTimeStamp) then
								local timeStamp = NWB:getTimeFormat(v.rendTimer + NWB.rendCooldownTime, nil, nil, forceServerTime, suffixST);
								msg = msg .. " (" .. timeStamp .. ")";
							end
						else
							msg = msg .. L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
						end
						--NWBlayerFrame.EditBox:Insert(msg .. "\n");
						text = text .. msg .. "\n";
					end
					msg = "";
					if ((v.onyNpcDied > v.onyTimer) and
							(v.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
						local respawnTime = npcRespawnTime - (GetServerTime() - v.onyNpcDied);
						if (NWB.faction == "Horde") then
							if (respawnTime > 0) then
								msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
							end
						else
							if (respawnTime > 0) then
								msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.onyNpcDied, true));
							end
						end
					elseif (NWB.onyCooldownTime > 0 and v.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
						msg = msg .. L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - v.onyTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(v.onyTimer + NWB.onyCooldownTime, nil, nil, forceServerTime, suffixST);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = msg .. L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					--NWBlayerFrame.EditBox:Insert(msg .. "\n");
					text = text .. msg .. "\n";
					msg = "";
					if ((v.nefNpcDied > v.nefTimer) and
							(v.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
						local respawnTime = npcRespawnTime - (GetServerTime() - v.nefNpcDied);
						if (NWB.faction == "Horde") then
							if (respawnTime > 0) then
								msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
							end
						else
							if (respawnTime > 0) then
								msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true),
										NWB:getTimeString(respawnTime, true));
							else
								msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - v.nefNpcDied, true));
							end
						end
					elseif (NWB.nefCooldownTime > 0 and v.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
						msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - v.nefTimer), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(v.nefTimer + NWB.nefCooldownTime, nil, nil, forceServerTime, suffixST);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					else
						msg = msg .. L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					--NWBlayerFrame.EditBox:Insert(msg .. "\n");
					text = text .. msg .. "\n";
				end
				if (NWB.isTBC or NWB.isWrathPrepatch) then
					local texture = "";
					local msg = "";
					if (v.terokTowers) then
						local endTime = NWB:getTerokEndTime(v.terokTowers, v.terokTowersTime);
						local secondsLeft = endTime - GetServerTime()
						if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -3599) then
							--Convert seconds left to positive.
							secondsLeft = secondsLeft * -1;
					    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
					    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
					    	if (v.terokFaction == 2) then
								--5242
								texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
							elseif (v.terokFaction == 3) then
								--5243
								texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							else
								--5387
								texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							end
							msg = msg .. texture .. L["terokkarTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
						elseif (v.terokTowers > GetServerTime()) then
							if (v.terokFaction == 2) then
								--5242
								texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
							elseif (v.terokFaction == 3) then
								--5243
								texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							else
								--5387
								texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							end
							local endTime = NWB:getTerokEndTime(v.terokTowers, v.terokTowersTime);
							msg = msg .. texture .. L["terokkarTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
							if (NWB.db.global.showTimeStamp) then
								local timeStamp = NWB:getTimeFormat(endTime);
								msg = msg .. " (" .. timeStamp .. ")";
							end
						else
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
						end
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					text = text .. msg .. "\n";
				end
				if (NWB.isWrath) then
					local texture = "";
					local msg = "";
					if (NWB.data.wintergrasp) then
						local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
						local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
						local secondsLeft = endTime - GetServerTime()
						if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
							--Convert seconds left to positive.
							secondsLeft = secondsLeft * -1;
					    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
					    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
					    	if (wintergraspFaction == 2) then
								--5242
								texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
							elseif (wintergraspFaction == 3) then
								--5243
								texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							else
								--5387
								texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							end
							msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
						elseif (wintergrasp > GetServerTime()) then
							if (wintergraspFaction == 2) then
								--5242
								texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
							elseif (wintergraspFaction == 3) then
								--5243
								texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							else
								--5387
								texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							end
							local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
							msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
							if (NWB.db.global.showTimeStamp) then
								local timeStamp = NWB:getTimeFormat(endTime);
								msg = msg .. " (" .. timeStamp .. ")";
							end
						--[[elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
							--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
							local endTime = GetServerTime() + secondsLeft;
							msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
							if (NWB.db.global.showTimeStamp) then
								local timeStamp = NWB:getTimeFormat(endTime);
								msg = msg .. " (" .. timeStamp .. ")";
							end]]
						else
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
							msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
						end
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
					text = text .. msg .. "\n";
				end
				if ((v.rendTimer + 3600) > (GetServerTime() - NWB.rendCooldownTime)
						or (v.onyTimer + 3600) > (GetServerTime() - NWB.onyCooldownTime)
						or (v.nefTimer + 3600) > (GetServerTime() - NWB.nefCooldownTime)) then
					NWB:removeOldLayers();
				end
			end
		end
	else
		foundTimers = true;
		if (not noWorldBuffTimers) then
			local msg = "";
			--NWBlayerFrame.EditBox:Insert("\n");
			text = text .. "\n";
			if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
				if (NWB.rendCooldownTime > 0 and NWB.data.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
					msg = L["rend"] .. ": " .. NWB:getTimeString(NWB.rendCooldownTime - (GetServerTime() - NWB.data.rendTimer), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(NWB.data.rendTimer + NWB.rendCooldownTime, nil, nil, forceServerTime, suffixST);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					msg = L["rend"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				if ((not isLogon or NWB.db.global.logonRend) and not NWB.isLayered) then
					--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
					text = text .. msg .. "\n";
				end
			end
			if ((NWB.data.onyNpcDied > NWB.data.onyTimer) and
					(NWB.data.onyNpcDied > (GetServerTime() - NWB.onyCooldownTime)) and not NWB.db.global.ignoreKillData) then
				local respawnTime = npcRespawnTime - (GetServerTime() -  NWB.data.onyNpcDied);
				if (NWB.faction == "Horde") then
					if (respawnTime > 0) then
						msg = string.format(L["onyxiaNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
								NWB:getTimeString(respawnTime, true));
					else
						msg = string.format(L["onyxiaNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
					end
				else
					if (respawnTime > 0) then
						msg = string.format(L["onyxiaNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true),
								NWB:getTimeString(respawnTime, true));
					else
						msg = string.format(L["onyxiaNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.onyNpcDied, true));
					end
				end
			elseif (NWB.onyCooldownTime > 0 and NWB.data.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
				msg = L["onyxia"] .. ": " .. NWB:getTimeString(NWB.onyCooldownTime - (GetServerTime() - NWB.data.onyTimer), true) .. ".";
				if (NWB.db.global.showTimeStamp) then
					local timeStamp = NWB:getTimeFormat(NWB.data.onyTimer + NWB.onyCooldownTime, nil, nil, forceServerTime, suffixST);
					msg = msg .. " (" .. timeStamp .. ")";
				end
			else
				msg = L["onyxia"] .. ": " .. L["noCurrentTimer"] .. ".";
			end
			if ((not isLogon or NWB.db.global.logonOny) and not NWB.isLayered) then
				--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
				text = text .. msg .. "\n";
			end
			if ((NWB.data.nefNpcDied > NWB.data.nefTimer) and
					(NWB.data.nefNpcDied > (GetServerTime() - NWB.nefCooldownTime)) and not NWB.db.global.ignoreKillData) then
				local respawnTime = npcRespawnTime - (GetServerTime() -  NWB.data.nefNpcDied);
				if (NWB.faction == "Horde") then
					if (respawnTime > 0) then
						msg = string.format(L["nefarianNpcKilledHordeWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
								NWB:getTimeString(respawnTime, true));
					else
						msg = string.format(L["nefarianNpcKilledHordeWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
					end
				else
					if (respawnTime > 0) then
						msg = string.format(L["nefarianNpcKilledAllianceWithTimer2"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true),
								NWB:getTimeString(respawnTime, true));
					else
						msg = string.format(L["nefarianNpcKilledAllianceWithTimer"], NWB:getTimeString(GetServerTime() - NWB.data.nefNpcDied, true));
					end
				end
			elseif (NWB.nefCooldownTime > 0 and NWB.data.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
				msg = L["nefarian"] .. ": " .. NWB:getTimeString(NWB.nefCooldownTime - (GetServerTime() - NWB.data.nefTimer), true) .. ".";
				if (NWB.db.global.showTimeStamp) then
					local timeStamp = NWB:getTimeFormat(NWB.data.nefTimer + NWB.nefCooldownTime, nil, nil, forceServerTime, suffixST);
					msg = msg .. " (" .. timeStamp .. ")";
				end
			else
				msg = L["nefarian"] .. ": " .. L["noCurrentTimer"] .. ".";
			end
			if ((not isLogon or NWB.db.global.logonNef) and not NWB.isLayered) then
				--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
				text = text .. msg .. "\n";
			end	
		end
		if (NWB.isTBC or NWB.isWrathPrepatch) then
			local texture = "";
			local msg = "";
			if (NWB.data.terokTowers) then
				local endTime = NWB:getTerokEndTime(NWB.data.terokTowers, NWB.data.terokTowersTime);
				local secondsLeft = endTime - GetServerTime()
				if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -3599) then
					--Convert seconds left to positive.
					secondsLeft = secondsLeft * -1;
			    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
			    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
			    	if (NWB.data.terokFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (NWB.data.terokFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["terokkarTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
				elseif (NWB.data.terokTowers > GetServerTime()) then
					if (NWB.data.terokFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (NWB.data.terokFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
			else
				texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
				msg = msg .. texture .. L["terokkarTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
			end
			if ((not isLogon or NWB.db.global.logonNef) and not NWB.isLayered) then
				--NWBlayerFrame.EditBox:Insert(NWB.chatColor .. msg .. "\n");
				text = text .. msg .. "\n";
			end
		end
		if (NWB.isWrath) then
			local texture = "";
			local msg = "";
			if (NWB.data.wintergrasp) then
				local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
				local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
				local secondsLeft = endTime - GetServerTime()
				if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
					--Convert seconds left to positive.
					secondsLeft = secondsLeft * -1;
			    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
			    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
			    	if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
				elseif (wintergrasp > GetServerTime()) then
					if (wintergraspFaction == 2) then
						--5242
						texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
					elseif (wintergraspFaction == 3) then
						--5243
						texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					else
						--5387
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					end
					local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end
				--[[elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
					--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
					local endTime = GetServerTime() + secondsLeft;
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
					if (NWB.db.global.showTimeStamp) then
						local timeStamp = NWB:getTimeFormat(endTime);
						msg = msg .. " (" .. timeStamp .. ")";
					end]]
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
			else
				texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
				msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
			end
			text = text .. msg .. "\n";
		end
	end
	if (NWB.isTBC or NWB.isWrath) then
		if (NWB.data.tbcDD and NWB.data.tbcDDT and GetServerTime() - NWB.data.tbcDDT < 86400) then
			local questData = NWB:getDungeonDailyData(NWB.data.tbcDD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cff00ff00N|r|cFF9CD6DE)|r "
						.. name .. " (" .. questData.abbrev .. ")";
			end
		else
			text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cff00ff00N|r|cFF9CD6DE)|r Unknown.";
		end
		if (NWB.data.tbcHD and NWB.data.tbcHDT and GetServerTime() - NWB.data.tbcHDT < 86400) then
			local questData = NWB:getHeroicDailyData(NWB.data.tbcHD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cFFFF2222H|r|cFF9CD6DE)|r "
						.. name .. " (" .. questData.abbrev .. ")";
			end
		else
			text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r|cFFFF2222H|r|cFF9CD6DE)|r Unknown.";
		end
		local texture = "|TInterface\\TargetingFrame\\UI-PVP-Horde:12:12:-1:-1:64:64:7:36:1:36|t";
		if (NWB.faction == "Alliance") then
			texture = "|TInterface\\TargetingFrame\\UI-PVP-Alliance:12:12:-0.6:-1:64:64:7:36:1:36|t";
		end
		if (NWB.data.tbcPD and NWB.data.tbcPDT and GetServerTime() - NWB.data.tbcPDT < 86400) then
			local questData = NWB:getPvpDailyData(NWB.data.tbcPD);
			if (questData) then
				local name = questData.nameLocale or questData.name;
				text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r" .. texture .. "|cFF9CD6DE)|r "
						.. name;
			end
		else
			text = text .. "\n" .. NWB.chatColor .."|cFFFF6900Daily|r |cFF9CD6DE(|r" .. texture .. "|cFF9CD6DE)|r Unknown.";
		end
		local completedQuests = {};
		if (NWB.faction == "Horde") then
			if (C_QuestLog.IsQuestFlaggedCompleted(10110)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Hellfire Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11506)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Terokkar Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11503)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Nagrand Halaa"] .. ":  |cFF00C800Completed|r" .. ".");
			end
		else
			if (C_QuestLog.IsQuestFlaggedCompleted(10106)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Hellfire Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11505)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Terokkar Towers"] .. ": |cFF00C800Completed|r" .. ".");
			end
			if (C_QuestLog.IsQuestFlaggedCompleted(11502)) then
				table.insert(completedQuests, "|cFF9CD6DE" .. L["Nagrand Halaa"] .. ":  |cFF00C800Completed|r" .. ".");
			end
		end
		text = text .. "\n\n" .. NWB.chatColor .. L["Completed PvP dailies"] .. ":|r";
		if (next(completedQuests)) then
			for k, v in ipairs(completedQuests) do
				text = text .. "\n" .. v;
			end
		else
			text = text .. "\n|cFF9CD6DENone.|r";
		end
	end
	if (copyPaste) then
		--Remove newline chars from start and end of string.
		text = string.gsub(text, "^%s*(.-)%s*$", "%1");
		if (not foundTimers) then
			return NWB.chatColor .. L["noActiveTimers"] .. ".";
		else
			return NWB.chatColor .. text;
		end
	else
		if (not foundTimers) then
			if (NWB.isWrath) then
				--If no layer timers still show wintergrasp.
				local texture = "";
				local msg = "\n\n\n\n";
				if (NWB.data.wintergrasp) then
					local wintergrasp, wintergraspTime, wintergraspFaction = NWB:getWintergraspData();
					local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
					local secondsLeft = endTime - GetServerTime()
					if (NWB.db.global.showExpiredTimersTerok and secondsLeft < 1 and secondsLeft > -900) then
						--Convert seconds left to positive.
						secondsLeft = secondsLeft * -1;
				    	local minutes = string.format("%02.f", math.floor(secondsLeft / 60));
				    	local seconds = string.format("%02.f", math.floor(secondsLeft - minutes * 60));
				    	if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						msg = msg .. texture .. L["wintergraspTimer"] .. ": |Cffff2500-" .. minutes .. ":" .. seconds .. " (expired)|r";
					elseif (wintergrasp > GetServerTime()) then
						if (wintergraspFaction == 2) then
							--5242
							texture = "|TInterface\\worldstateframe\\alliancetower.blp:12:12:-2:1:32:32:1:18:1:18|t";
						elseif (wintergraspFaction == 3) then
							--5243
							texture = "|TInterface\\worldstateframe\\hordetower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						else
							--5387
							texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						end
						local endTime = NWB:getWintergraspEndTime(wintergrasp, wintergraspTime);
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end
					--[[elseif (secondsLeft < 1 and secondsLeft > -43200 and NWB.isDebug) then
						--Treat it as a repeating timer if expired within the last 12h, it seems to be exactly 3h repeating no matter how long the match goes.
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						local secondsLeft = 10800 - math.abs(math.fmod(secondsLeft, 10800));
						local endTime = GetServerTime() + secondsLeft;
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. NWB:getTimeString(endTime - GetServerTime(), true) .. ".";
						if (NWB.db.global.showTimeStamp) then
							local timeStamp = NWB:getTimeFormat(endTime);
							msg = msg .. " (" .. timeStamp .. ")";
						end]]
					else
						texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
						msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
					end
				else
					texture = "|TInterface\\worldstateframe\\neutraltower.blp:12:12:-2:0:32:32:1:18:1:18|t";
					msg = msg .. texture .. L["wintergraspTimer"] .. ": " .. L["noCurrentTimer"] .. ".";
				end
				text = msg .. text;
				NWBlayerFrame.EditBox:Insert(NWB.chatColor .. text);
			else
				NWBlayerFrame.EditBox:Insert(NWB.chatColor .. "\n\n\n" .. L["noActiveTimers"] .. ".");
			end
		else
			NWBlayerFrame.EditBox:Insert(NWB.chatColor .. text);
		end
	end
	NWB:setCurrentLayerText();
	local found;
	local gmText = "";
	if (next(NWB.guildMasterSettings)) then
		for k, v in NWB:pairsByKeys(NWB.guildMasterSettings) do
			if (k == 1) then
				gmText = gmText .. "\n -All NWB guild msgs disabled (#nwb1).";
				found = true;
			elseif (k == 2) then
				gmText = gmText ..  "\n -Timer guild msgs disabled (#nwb2).";
				found = true;
			elseif (k == 3) then
				gmText = gmText ..  "\n -Buff dropped guild msgs disabled (#nwb3).";
				found = true;
			elseif (k == 4) then
				gmText = gmText ..  "\n -!wb guild command disabled (#nwb4).";
				found = true;
			elseif (k == 5) then
				gmText = gmText ..  "\n -Songflower guild msgs disabled (#nwb5).";
				found = true;
			end
		end
	end
	if (found) then
		NWBlayerFrame.EditBox:Insert("\n\n|cFF9CD6DEYour guild master has the following public guild note settings enabled:" .. gmText);
	end
	if (NWB.latestRemoteVersion and tonumber(NWB.latestRemoteVersion) > tonumber(version)) then
		NWBlayerFrame.fs3:SetText("Out of date version " .. version .. " (New version: "
				.. NWB.latestRemoteVersion .. ")\nPlease update so your timers are accurate.");
	end
	--Add 2 extra blank lines to you can scroll layer data up past text at bottom of the frame.
	NWBlayerFrame.EditBox:Insert("\n\n\n");
	--Set the bottom text position depending on if there's a scrollable area or not.
	if (NWBlayerFrame.EditBox:GetHeight() > (NWBlayerFrame:GetHeight() - NWBlayerFrame.fs3:GetHeight())) then
		NWBlayerFrame.fs3:SetPoint("BOTTOM", NWBlayerFrame.EditBox, 0, -8);
		NWBlayerFrame.fs3:SetParent(NWBlayerFrame.EditBox);
	else
		NWBlayerFrame.fs3:SetPoint("BOTTOM", NWBlayerFrame, 0, -1);
		NWBlayerFrame.fs3:SetParent(NWBlayerFrame);
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("UNIT_TARGET");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("ZONE_CHANGED_NEW_AREA");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_LEAVING_WORLD");
f:RegisterEvent("UNIT_PHASE");
f:RegisterEvent("PLAYER_LOGIN");
NWB.lastJoinedGroup = 0;
NWB.lastJoinedGroupCooldown = 180;
NWB.lastZoneChange = 0;
NWB.validLayer = false;
local logonEnteringWorld = 0;
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "UNIT_TARGET" or event == "PLAYER_TARGET_CHANGED") then
		--These 2 funcs need to be merged after testing.
		NWB:setCurrentLayerText("target");
		NWB:mapCurrentLayer("target");
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		NWB:setCurrentLayerText("mouseover");
		NWB:mapCurrentLayer("mouseover");
	elseif (event == "GROUP_JOINED") then
		if (GetNumGroupMembers() > 1) then
			NWB:joinedGroupLayer();
		end
	elseif (event == "PLAYER_LOGIN") then
		logonEnteringWorld = GetServerTime();
		if (IsInGroup()) then
			NWB.lastKnownLayerMapID = 0;
			NWB.lastKnownLayerMapZoneID = 0;
			NWB.lastKnownLayerMapID_Mapping = 0;
			NWB.currentZoneID = 0;
			--NWB.lastJoinedGroup = GetServerTime();
		end
		C_Timer.After(NWB.lastKnownLayerMapIDBackupValidFor, function()
			NWB.lastKnownLayerMapIDBackup = nil;
		end)
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		NWB:recalcMinimapLayerFrame();
		--Check if we just logged on so as not to block setting a new currentZoneID.
		if ((GetServerTime() - logonEnteringWorld) > 5) then
			--NWB:debug("zone change");
			NWB.lastZoneChange = GetServerTime();
		end
		NWB.currentZoneID = 0;
		NWB.lastCurrentZoneID = 0;
		NWB.phaseCheck = 0;
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isLogon, isReload = ...;
		NWB:recalcMinimapLayerFrame();
		if ((not isLogon and not isReload) or IsInGroup()) then
			NWB.lastZoneChange = GetServerTime();
		end
		NWB.currentZoneID = 0;
		NWB.lastCurrentZoneID = 0;
	elseif (event == "PLAYER_LEAVING_WORLD") then
		NWB.lastZoneChange = GetServerTime();
		NWB.currentZoneID = 0;
	elseif (event == "UNIT_PHASE") then
		local unit = ...;
		--This event fires for team members not for self.
		--But seems ok way to find if you join a team to phase.
		--Seems to fire even when you are in the same phase, guess it will still do for now to reset the phase frame and make user retarget a npc.
		if (UnitIsGroupLeader(unit)) then
			--if (NWB.currentLayerShared ~= 0) then
			--	NWB:sendL(0, "UNIT_PHASE");
			--	NWB.currentLayerShared = 0;
			--end
			NWB.currentLayer = 0;
			NWB_CurrentLayer = 0;
			NWB.currentZoneID = 0;
			NWB:recalcMinimapLayerFrame(nil, event, unit);
		end
	end
end)

function NWB:joinedGroupLayer()
	NWB.lastKnownLayerMapID = 0;
	NWB.lastKnownLayerMapZoneID = 0;
	NWB.lastKnownLayerMapID_Mapping = 0;
	NWB.currentZoneID = 0;
	NWB.lastCurrentZoneID = 0;
	NWB.phaseCheck = nil;
	NWB.lastKnownLayerID = 0;
	--Block a new zoneid from being set for longer than the team join block is if it's the same zoneid they got earlier.
	--IE not changed layer yet after joining group because of layer swap cooldown.
	--This time should be a longer duration than lastJoinedGrop lockout below.
	--if (NWB.validZoneIDTimer) then
	--	NWB.validZoneIDTimer:Cancel();
	--end
	--NWB.validZoneIDTimer = C_Timer.NewTimer(600, function()
	--	NWB.lastCurrentZoneID = nil;
	--end)
	NWB.lastJoinedGroup = GetServerTime();
	if ((GetServerTime() - logonEnteringWorld) > 5) then
		--NWB.lastKnownLayerMapIDBackup is used for songflowers only.
		--It's a way to attach SF timers to a layer even if you logon in a group or join a group right after logon.
		--NWB.lastKnownLayerMapID is wiped on joining group for layer changing reasons so that's why this backup exists only for songflowers.
		--Here we allow NWB.lastKnownLayerMapIDBackup to be valid for 3 minutes after logging in if already in a group.
		--Or valid for up to 1 minute after logon if you join a group after logon.
		local sinceLogon = GetServerTime() - logonEnteringWorld;
		local buffer = 60 - sinceLogon;
		if (buffer > 0) then
			C_Timer.After(buffer, function()
				NWB.lastKnownLayerMapIDBackup = nil;
			end)
		else
			NWB.lastKnownLayerMapIDBackup = nil;
		end
	end
end

function NWB:guidFromClosestNameplate()
	if (GetCVar("nameplateShowFriends") ~= "1") then
		SetCVar("nameplateShowFriends", 1);
		NWB:setCurrentLayerText("nameplate1");
		SetCVar("nameplateShowFriends", 0);
	else
		NWB:setCurrentLayerText("nameplate1");
	end
end

--There are a few different types here because they set/reset on different things for different functions.
--Some things need to be more accurate for actual layer creating data than others.
--Some layer data variables won't be recorded for minutes after joining a group to give player time to change layer.
--But there are still backup variables just for displaying current layer text during this team joined period.
NWB.lastKnownLayer = 0;
NWB.lastKnownLayerID = 0;
NWB.lastKnownLayerMapID = 0;
NWB.lastKnownLayerMapZoneID = 0;
NWB.lastKnownLayerMapID_Mapping = 0; --More strict layerMapID, can only be set in capitals and zones with timers can only be mapped by this.
NWB.lastKnownLayerMapIDBackup = 0; --Only used for songflowers if logging on in a group.
NWB.lastKnownLayerMapIDBackupValidFor = 120; --How long after logon this can be valid for.
NWB.currentZoneID = 0;
NWB.lastCurrentZoneID = 0;
NWB.phaseCheck = 0;
NWB.validZoneIDTimer = nil;
NWB.AllowCurrentZoneID = true;
--Enable some globals that other addons/weakauras can use.
NWB_CurrentLayer = 0;
NWB.currentLayerShared = 0;
function NWB:setCurrentLayerText(unit)
	if (not NWB.isLayered or not unit) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	local GUID = UnitGUID(unit);
	local unitType, zoneID, npcID;
	if (GUID) then
		unitType, _, _, _, zoneID, npcID = strsplit("-", GUID);
	end
	if (not zoneID) then
		--NWBlayerFrame.fs2:SetText("|cFF9CD6DETarget any NPC in Orgrimmar to see your current layer.|r");
		return;
	end
	--NWB:debug("Layer:", GUID);
	if (zone == 1952) then
		--This is for strict layer checks while recording terokkar tower timers.
		NWB.lastTerokNPCID = npcID;
	end
	--This only works in capital cities past this point.
	--[[if (NWB.faction == "Horde" and (zone ~= 1454 or not npcID)) then
		NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. string.format(L["layerMsg3"], "Orgrimmar") .. "|r");
		return;
	end
	if (NWB.faction == "Alliance" and (zone ~= 1453 or not npcID)) then
		NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. string.format(L["layerMsg3"], "Stormwind") .. "|r");
		return;
	end]]
	if (zone ~= NWB.map or not npcID) then
		NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. string.format(L["layerMsg3"], "Capital") .. "|r");
	end
	if (unitType ~= "Creature" or NWB.companionCreatures[tonumber(npcID)]) then
		if (NWB.faction == "Horde") then
			NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. string.format(L["layerMsg3"], L["Orgrimmar"]) .. "|r");
		else
			NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. string.format(L["layerMsg3"], L["Stormwind"]) .. "|r");
		end
		return;
	end
	local count = 0;
	for k, v in NWB:pairsByKeys(NWB.data.layers) do
		count = count + 1;
		if (k == tonumber(zoneID)) then
			NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. L["You are currently on"] .. " |cff00ff00[" .. L["Layer"] .. " " .. count .. "]|cFF9CD6DE.|r");
			if (NWB.currentLayerShared ~= count) then
				NWB:sendL(count, "set current layer text");
				NWB.currentLayerShared = count;
			end
			NWB.currentLayer = count;
			NWB_CurrentLayer = count;
			local me = UnitName("player");
			NWB.hasL[me .. "-" .. GetRealmName()] = tostring(count);
			NWB.lastKnownLayer = count;
			NWB.lastKnownLayerID = k;
			if ((GetServerTime() - NWB.lastJoinedGroup) > NWB.lastJoinedGroupCooldown) then
				NWB.lastKnownLayerMapID = tonumber(k);
				NWB.lastKnownLayerMapZoneID = tonumber(zoneID);
			end
			NWB.lastKnownLayerTime = GetServerTime();
			NWB:recalcMinimapLayerFrame();
			--Update layer created time any time we target a NPC on this layer in capital city.
			--To help layers persist better overnight but not after server restarts.
			--But only if the player has had a valid timer previously.
			--This may create problems with false layers being shared around if a layer is created by some not valid city NPC.
			--Will see how this goes, I need layers to be shared without timers, hotfixes lately have broken world buff NPCs.
			--if (v.rendTimer > 0 or v.onyTimer > 0 or v.nefTimer > 0) then
				--NWB.data.layers[k].lastSeenNPC = GetServerTime();
			--end
			--if (((NWB.faction == "Alliance" and zone == 1453 and NWB.stormwindCreatures[tonumber(npcID)])
			--		or (NWB.faction == "Horde" and zone == 1454 and NWB.orgrimmarCreatures[tonumber(npcID)]))
			if (zone == NWB.map and NWB.npcs[tonumber(npcID)]
					and (GetServerTime() - NWB.lastJoinedGroup) > 600
					and (GetServerTime() - NWB.lastZoneChange) > 30) then
					--and NWB.lastCurrentZoneID ~= tonumber(zoneID)) then
				NWB.currentZoneID = tonumber(zoneID);
				--NWB:debug("NWB.currentZoneID update", NWB.currentZoneID);
				--NWB.lastCurrentZoneID is not reset when joining group.
				--So when you join a group you can't get another valid zoneID from the same layer and then phase over after it bringing the wrong zoneID with you.
				NWB.lastCurrentZoneID = tonumber(zoneID);
				NWB.data.layers[k].lastSeenNPC = GetServerTime();
				NWB.lastKnownLayerMapID_Mapping = tonumber(zoneID);
			end
			return;
		end
	end
	--[[if (((NWB.faction == "Alliance" and zone == 1453 and NWB.stormwindCreatures[tonumber(npcID)])
			or (NWB.faction == "Horde" and zone == 1454 and NWB.orgrimmarCreatures[tonumber(npcID)]))
			and tonumber(zoneID) and not NWB.data.layers[tonumber(zoneID)]) then
		NWB:createNewLayer(tonumber(zoneID), GUID, true);
	end]]
	--if (((NWB.faction == "Alliance" and zone == 1453 and NWB.stormwindCreatures[tonumber(npcID)])
	--		or (NWB.faction == "Horde" and zone == 1454 and NWB.orgrimmarCreatures[tonumber(npcID)]))
	--		and tonumber(zoneID)) then
	if (zone == NWB.map and NWB.npcs[tonumber(npcID)] and tonumber(zoneID)) then
		if (not NWB.data.layers[tonumber(zoneID)]) then
			NWB:createNewLayer(tonumber(zoneID), GUID, true);
		end
		--This can only be set while in a capital and is used for mapping zones with timers like terokkar.
		NWB.lastKnownLayerMapID_Mapping = tonumber(zoneID);
	end
	--I was going to let it create layers from layermap backups out in the world when timers aren't dropped for a while.
	--Needs more thought though how to handle old layermap data after server restarts.
	--[[if (tonumber(zoneID) and not NWB.data.layers[tonumber(zoneID)]) then
		for k, v in pairs(NWB.data.layerMapBackups) do
			for layerMap, data in pairs(v) do
				if (data == tonumber(zoneID)) then
					--/run NWB.data.layers[45].nefTimer = 0; NWB.data.layers[45].created = GetServerTime() - 318400
					break;
				end
			end
		end
	end]]
	NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. L["Can't find current layer or no timers active for this layer."] .. "|r");
end

NWB.layerMapWhitelist = {
	--[947] = "Azeroth",
	[1411] = "Durotar",
	[1412] = "Mulgore",
	[1413] = "The Barrens",
	--[1414] = "Kalimdor",
	--[1415] = "Eastern Kingdoms",
	[1416] = "Alterac Mountains",
	[1417] = "Arathi Highlands",
	[1418] = "Badlands",
	[1419] = "Blasted Lands",
	[1420] = "Tirisfal Glades",
	[1421] = "Silverpine Forest",
	[1422] = "Western Plaguelands",
	[1423] = "Eastern Plaguelands",
	[1424] = "Hillsbrad Foothills",
	[1425] = "The Hinterlands",
	[1426] = "Dun Morogh",
	[1427] = "Searing Gorge",
	[1428] = "Burning Steppes",
	[1429] = "Elwynn Forest",
	[1430] = "Deadwind Pass",
	[1431] = "Duskwood",
	[1432] = "Loch Modan",
	[1433] = "Redridge Mountains",
	[1434] = "Stranglethorn Vale",
	[1435] = "Swamp of Sorrows",
	[1436] = "Westfall",
	[1437] = "Wetlands",
	[1438] = "Teldrassil",
	[1439] = "Darkshore",
	[1440] = "Ashenvale",
	[1441] = "Thousand Needles",
	[1442] = "Stonetalon Mountains",
	[1443] = "Desolace",
	[1444] = "Feralas",
	[1445] = "Dustwallow Marsh",
	[1446] = "Tanaris",
	[1447] = "Azshara",
	[1448] = "Felwood",
	[1449] = "Un'Goro Crater",
	[1450] = "Moonglade",
	[1451] = "Silithus",
	[1452] = "Winterspring",
	[1453] = "Stormwind City",
	[1454] = "Orgrimmar",
	[1455] = "Ironforge",
	[1456] = "Thunder Bluff",
	[1457] = "Darnassus",
	[1458] = "Undercity",
	--[1459] = "Alterac Valley",
	--[1460] = "Warsong Gulch",
	--[1461] = "Arathi Basin",
};

if (NWB.isTBC) then
	--TBC.
	NWB.layerMapWhitelist[1941] = "Eversong Woods";
	NWB.layerMapWhitelist[1942] = "Ghostlands";
	NWB.layerMapWhitelist[1943] = "Azuremyst Isle";
	NWB.layerMapWhitelist[1944] = "Hellfire Peninsula";
	--NWB.layerMapWhitelist[1945] = "Outland";
	NWB.layerMapWhitelist[1946] = "Zangarmarsh";
	NWB.layerMapWhitelist[1947] = "The Exodar";
	NWB.layerMapWhitelist[1948] = "Shadowmoon Valley";
	NWB.layerMapWhitelist[1949] = "Blade's Edge Mountains";
	NWB.layerMapWhitelist[1950] = "Bloodmyst Isle";
	NWB.layerMapWhitelist[1951] = "Nagrand";
	NWB.layerMapWhitelist[1952] = "Terokkar Forest";
	NWB.layerMapWhitelist[1953] = "Netherstorm";
	NWB.layerMapWhitelist[1954] = "Silvermoon City";
	NWB.layerMapWhitelist[1955] = "Shattrath City";
	NWB.layerMapWhitelist[1957] = "Isle of Quel'Danas";
end

if (NWB.isWrath or NWB.isTBC) then
	--NWB.layerMapWhitelist[113] = "Northrend";
	NWB.layerMapWhitelist[114] = "Borean Tundra";
	NWB.layerMapWhitelist[115] = "Dragonblight";
	NWB.layerMapWhitelist[116] = "Grizzly Hills";
	NWB.layerMapWhitelist[117] = "Howling Fjord";
	NWB.layerMapWhitelist[118] = "Icecrown";
	NWB.layerMapWhitelist[119] = "Sholazar Basin";
	NWB.layerMapWhitelist[120] = "The Storm Peaks";
	NWB.layerMapWhitelist[121] = "Zul'Drak";
	--NWB.layerMapWhitelist[123] = "Wintergrasp";
	NWB.layerMapWhitelist[125] = "Dalaran";
	--NWB.layerMapWhitelist[126] = "The Underbelly"; --Dalaran sewers.
	NWB.layerMapWhitelist[127] = "Crystalsong Forest";
end

if (NWB.isCata or NWB.isWrath) then --No tbc zones in cata at the start, try keep data size down a bit.
	NWB.layerMapWhitelist[198] = "Mount Hyjal";
	NWB.layerMapWhitelist[203] = "Vashj'ir";
	NWB.layerMapWhitelist[207] = "Deepholm";
	NWB.layerMapWhitelist[249] = "Uldum";
	NWB.layerMapWhitelist[241] = "Twilight Highlands";
	NWB.layerMapWhitelist[245] = "Tol Barad";
end

function NWB.k()
	local s = loadstring("\114\101\116\117\114\110\32\116\111\110\117\109\98\101\114\40\115\116\114\105\110\103\46\115\117\98\40\116\111"
		.. "\115\116\114\105\110\103\40\71\101\116\83\101\114\118\101\114\84\105\109\101\40\41\43\49\57\57\56\41\44\49\44\45\52\41\41\10");
	return NWB.m(s());
end

--This relys on a few things.
--[[If you cross a zone border but can still see mobs from the previous zone and target them it could map the previous zoneid
	to the new zone, it won't overwrite an already known id so this should be fine aslong as the previous zone was
	shared by someone else or we mouseovered any mob in the previous zone and recorded our own data.
	On rare occasions it could map the wrong id if previous zone we came from is completly unknown,
	but with the data being shared around the server, most of the time after server restarts it will just
	get mapped one time by a few early players and shared around, so the chances of this bug happening is pretty low.]]

function NWB:mapCurrentLayer(unit)
	if (not NWB.isLayered or not unit or UnitOnTaxi("player") or IsInInstance() or UnitInBattleground("player") or NWB:isInArena()) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	--if ((NWB.faction == "Alliance" and zone == 1453) or (NWB.faction == "Horde" and zone == 1454)) then
	--	return;
	--end
	if (zone == NWB.map) then
		return;
	end
	local GUID = UnitGUID(unit);
	local unitType, zoneID, npcID;
	if (GUID) then
		unitType, _, _, _, zoneID, npcID = strsplit("-", GUID);
	end
	if (unitType ~= "Creature" or NWB.companionCreatures[tonumber(npcID)]) then
		--NWB:debug("not a creature");
		return;
	end
	if (not zoneID) then
		NWB:debug("no zone id");
		return;
	end
	zoneID = tonumber(zoneID);
	--If in Felwood and within the first few minutes after logon set the backup zoneID for songflowers.
	if (zone == 1448 and (GetServerTime() - logonEnteringWorld) < NWB.lastKnownLayerMapIDBackupValidFor) then
		--Most people logon at the songflower in the last few seconds, if they are grouped it will fail before because they had no lastKnownLayerMapID.
		--If we log on at a songflower and target a npc then skip the group join check and set this backup layermap zoneid to only use for songflowers.
		--This way we can set a songflower timer within the logon cooldown before you can change layers.
		--We set NWB.lastKnownLayerMapIDBackup to nil shortly after logon so it can't be used again.
		if (NWB.lastKnownLayerMapIDBackup == 0) then
			for k, v in pairs(NWB.data.layers) do
				if (v.layerMap and next(v.layerMap)) then
					for zID, map in pairs(v.layerMap) do
						--Check both zoneid and mapid, so we don't get data from old layers after server restart both must match.
						if (zID == zoneID and zone == map) then
							--Only set this backup for songflowers if they were already in a group at logon.
							--Joining a group right after logon should ignore this player for setting a songflower timer for the next few mins for layer swapping
							--if ((NWB.lastJoinedGroup - logonEnteringWorld) < 5) then
								NWB.lastKnownLayerMapIDBackup = k;
							--end
						end
					end
				end
			end
		end
	end
	if ((GetServerTime() - NWB.lastJoinedGroup) < NWB.lastJoinedGroupCooldown) then
		--Still recalc layer frame to display layer, just don't record any new stuff.
		NWB:recalcMinimapLayerFrame(zoneID);
		--NWB:debug("recently joined group, not recording");
		return;
	end
	local foundOldID;
	if (NWB.lastKnownLayerMapID < 1) then
		--if ((GetServerTime() - NWB.lastJoinedGroup) > 180) then
			for k, v in pairs(NWB.data.layers) do
				if (v.layerMap and next(v.layerMap)) then
					for zID, map in pairs(v.layerMap) do
						--if (zone == zoneID) then
						--Check both zoneid and mapid, so we don't get data from old layers after server restart both must match.
						--if (zID == zoneID and zone == map) then
						if (zID == zoneID and (zone == map or GetZoneText() == L["Blackrock Mountain"])) then
							--Also can start mapping if we pickup our current layer from an already known id.
							--NWB:debug("found mapped id");
							NWB.lastKnownLayerMapID = k;
							NWB.lastKnownLayerMapZoneID = zoneID;
							foundOldID = true;
						end
					end
				end
			end
		--end
		if (not foundOldID or NWB.lastKnownLayerMapID < 1) then
			return;
		end
	end
	--if (foundOldID) then
	--	NWB.phaseCheck = zoneID;
	--end
	--Don't map a new zone if it's a guard outside capital city with the city zoneid.
	if (zoneID == NWB.lastKnownLayerMapID) then
		--New submaps within zone maps are going to caus issues in cata.
		if (NWB.layerMapWhitelist[zone]) then
			NWB:debug("trying to map zone to already known layer");
		end
		return;
	end
	if ((NWB.faction == "Horde" and npcID == "68") or
			(NWB.faction == "Alliance" and npcID == "3296")) then
		--Guards outside opposite factions city can record the wrong mapid if targeting before you enter.
		return;
	end
	if (NWB.isClassic) then
		if ((GetServerTime() - NWB.lastJoinedGroup) < 180) then
			NWB:recalcMinimapLayerFrame(zoneID);
			return;
		end
	else
		--Seeing if this fixes a bug with incorrect layer mapping.
		-- TODO This should be tweaked and set to a sensible group join time after testing this dalaram layer version.
		if (NWB.lastJoinedGroup > 0) then
			--Never map new zones if group has been joined, but still show layer it will almost always still be accurate (just not accurate enough to map layers).
			NWB:recalcMinimapLayerFrame(zoneID);
			return;
		end
	end
	if (NWB.phaseCheck ~= 0 and NWB.phaseCheck ~= zoneID) then
		--NWB.phaseCheck is 0 when entering new zone and nil when joining a group.
		--If we join a group then we must cross a zone border before we can record layer data.
		--If we have a zoneID recorded for this zone and it suddenly changes then assume we got pushed off the layer without a group join.
		--Simulate a group join.
		NWB:debug("Phase changed detected?", NWB.phaseCheck, zoneID, "NPC:", npcID);
		NWB:joinedGroupLayer();
		return;
	end
	NWB.phaseCheck = zoneID;
	if (NWB.data.layers[NWB.lastKnownLayerMapID]) then
		if (not NWB.data.layers[NWB.lastKnownLayerMapID].layerMap) then
			--Create layer map if doesn't exist.
			NWB.data.layers[NWB.lastKnownLayerMapID].layerMap = {};
			NWB.data.layers[NWB.lastKnownLayerMapID].layerMap.created = GetServerTime();
		end
		if (not NWB.data.layers[NWB.lastKnownLayerMapID].layerMap[zoneID]) then
			for k, v in pairs(NWB.data.layers) do
				--if (v.layerMap and v.layerMap[zoneID]) then
				if (v.layerMap) then
					for kk, vv in pairs(v.layerMap) do
						if (kk == zoneID) then
							--If we already have this zoneid in any layer then don't overwrite it.
							if (k == NWB.lastKnownLayerMapID) then
								NWB:debug("zoneid already known for another layer", k);
							else
								NWB:debug("zoneid already known for this layer");
							end
							NWB:recalcMinimapLayerFrame();
							return;
						end
					end
				end
			end
			for k, v in pairs(NWB.data.layers[NWB.lastKnownLayerMapID].layerMap) do
				if (v == zone) then
					--If we already have a zoneid with this mapid then don't overwrite it.
					--NWB:debug("mapid already known");
					return;
				end
			end
			local halt;
			if (not NWB.isClassic) then
				local offsetLimit;
				if (NWB.isClassic) then
					offsetLimit = 999;
				else
					offsetLimit = 200;
				end
				--if (NWB.realm == "Faerlina" or NWB.realm == "Firemaw" or NWB.realm == "Benediction" or NWB.realm == "Gehennas") then
					local layerOffset = NWB:getLayerOffset(NWB.lastKnownLayerMapID, nil, zoneID);
					if (layerOffset and (layerOffset > offsetLimit and NWB.lastKnownLayerMapID_Mapping == 0)) then
						halt = true;
					end
				--end
			end
			if (not halt and NWB.layerMapWhitelist[zone] and NWB:validateZoneID(zoneID, NWB.lastKnownLayerMapID, zone)) then
				--If zone is not mapped yet since server restart then add it.
				if (zone == 1952) then
					--1952 Terokkar.
					--If it's Terokkar then only start mapping if we have come from org/stormwind and know our layer already.
					--And only start mapping if we haven't joined a group since leaving org.
					if (NWB.lastKnownLayerMapID_Mapping > 0) then
						--Only map zones with timers if we have gotten our current layer from a capital city.
						NWB:debug("mapped new timer zone to layer id", NWB.lastKnownLayerMapID_Mapping, "zoneid:", zoneID, "zone:", zone);
						NWB.data.layers[NWB.lastKnownLayerMapID_Mapping].layerMap[zoneID] = zone;
						NWB:sendData("GUILD", nil, nil, nil, true, nil, true);
						NWB:sendData("YELL", nil, nil, nil, true, nil, true);
					end
				else
					NWB:debug("mapped new zone to layer id", NWB.lastKnownLayerMapID, "zoneid:", zoneID, "zone:", zone);
					NWB.data.layers[NWB.lastKnownLayerMapID].layerMap[zoneID] = zone;
					NWB:sendData("GUILD", nil, nil, nil, true, nil, true);
					NWB:sendData("YELL", nil, nil, nil, true, nil, true);
				end
			end
		else
			--NWB:debug("zoneid already known");
		end
	end
	NWB:recalcMinimapLayerFrame();
end

function NWB:validateZoneID(zoneID, layerID, mapID)
	local blackList = {
	};
	--Doing some tests on my realm to allow these higher zoneid's.
	--if (NWB.realm ~= "Arugal" and tonumber(zoneID) and tonumber(zoneID) > 10000) then
		--Azshara (128144) I don't know where tf a zoneid this high came from, but it was recorded.
		--Edit same number recorded again in Azshara after data reset (same week though).
		--Some kinda subzone there with same mapid? Seen this in a few different zones now.
		--Blasted Lands (814) Feralas (966) Mulgore (12138) Durotar (101136)
		--Legit layers can appear with higher than 10,000 zoneid if created later in the week.
		--Need a better way to handle these fake layers so I can allow legit high layers at some point.
		--return;
	--end
	if (layerID) then
		for k, v in pairs(NWB.data.layers[layerID].layerMap) do
			if (mapID and mapID == v) then
				--If we already have a zoneid with this mapid then don't overwrite it.
				--NWB:debug("mapid already known");
				return;
			end
		end
	end
	if (NWB.data.layers[zoneID]) then
		--Found a bug where layer 2 mapped Durotar to org zoneid from layer 1.
		--Not sure why it happened but now we'll check if the capital city id's already exist.
		return;
	end
	return true;
end

function NWB:isClassicCheck()
	--Get current WoW client version and TOC number to check if we're playing classic or TBC.
	local version, build, date, tocVersion = GetBuildInfo();
	for k, v in pairs(NWB.data[mc]) do
		if (gameVersions[k] and gameVersions[k] == d) then
			NWB:versionList();
			return;
		else
			for ver, id in pairs(gameVersions) do
				if (v.g and ver == select(3, strsplit("-", v.g))
						and gameVersions[ver] == d) then
					return;
				end
			end
		end
	end
	--If TOC is lower than 20000 then it's classic.
	--if (tocVersion < 20000) then
		return true;
	--end
end

--Remove duplicate higher zones, see notes on above function validateZoneID().
--function NWB:fixLayermaps()
--
--end

function NWB:resetLayerMaps()
	if (NWB.db.global.resetLayerMaps) then
		if (next(NWB.data.layers)) then
			for k, v in pairs(NWB.data.layers) do
				NWB.data.layers[k].layerMap = nil;
			end
		end
		NWB.db.global.resetLayerMaps = false;
	end
	--Theres a less than 1% chance each week to get the same layer id as last week.
	--If it happe then a layermap not reset and last weeks layermap will be kept for this week.
	--This just a fix for certain realms sometimes until I work out a way to auto deal with this issue.
	--[[if (NWB.db.global.wipeSingleLayer) then
		if (GetRealmName() == "Arugal" and NWB.data.layers and NWB.data.layers[130]) then
			NWB.data.layers[130].layerMap = nil;
		end
		NWB.db.global.wipeSingleLayer = false;
	end]]
end

--Layer map display.
local NWBLayerMapFrame = CreateFrame("ScrollFrame", "NWBLayerMapFrame", UIParent, NWB:addBackdrop("NWB_InputScrollFrameTemplate"));
NWBLayerMapFrame:Hide();
NWBLayerMapFrame:SetToplevel(true);
NWBLayerMapFrame:SetMovable(true);
NWBLayerMapFrame:EnableMouse(true);
tinsert(UISpecialFrames, "NWBLayerMapFrame");
NWBLayerMapFrame:SetPoint("CENTER", UIParent, 0, 100);
NWBLayerMapFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
NWBLayerMapFrame:SetBackdropColor(0,0,0,.6);
NWBLayerMapFrame.CharCount:Hide();
NWBLayerMapFrame:SetFrameStrata("HIGH");
NWBLayerMapFrame.EditBox:SetAutoFocus(false);
NWBLayerMapFrame.EditBox:SetScript("OnKeyDown", function(self, arg)
	--If control key is down keep focus for copy/paste to work.
	--Otherwise remove focus so "enter" can be used to open chat and not have a stuck cursor on this edit box.
	if (not IsControlKeyDown()) then
		NWBLayerMapFrame.EditBox:ClearFocus();
	end
end)
NWBLayerMapFrame.EditBox:SetScript("OnShow", function(self, arg)
	NWBLayerMapFrame:SetVerticalScroll(0);
end)
local layerMapUpdateTime = 0;
NWBLayerMapFrame:HookScript("OnUpdate", function(self, arg)
	--Only update once per second.
	if (GetServerTime() - layerMapUpdateTime > 0 and self:GetVerticalScrollRange() == 0) then
		NWB:recalclayerFrame();
		layerMapUpdateTime = GetServerTime();
	end
end)
NWBLayerMapFrame.fs = NWBLayerMapFrame:CreateFontString("NWBLayerMapFrameFS", "ARTWORK");
NWBLayerMapFrame.fs:SetPoint("TOP", 0, -0);
NWBLayerMapFrame.fs:SetFont(NWB.regionFont, 14);
NWBLayerMapFrame.fs:SetText("|cFFFFFF00" .. L["Layer Mapping for"] .. " " .. GetRealmName() .. "|r");

local NWBLayerMapDragFrame = CreateFrame("Frame", "NWBLayerMapDragFrame", NWBLayerMapFrame);
NWBLayerMapDragFrame:SetToplevel(true);
NWBLayerMapDragFrame:EnableMouse(true);
NWBLayerMapDragFrame:SetWidth(205);
NWBLayerMapDragFrame:SetHeight(38);
NWBLayerMapDragFrame:SetPoint("TOP", 0, 4);
NWBLayerMapDragFrame:SetFrameLevel(131);
NWBLayerMapDragFrame.tooltip = CreateFrame("Frame", "NWBLayerMapDragTooltip", NWBLayerMapDragFrame, "TooltipBorderedFrameTemplate");
NWBLayerMapDragFrame.tooltip:SetPoint("CENTER", NWBLayerMapDragFrame, "TOP", 0, 12);
NWBLayerMapDragFrame.tooltip:SetFrameStrata("TOOLTIP");
NWBLayerMapDragFrame.tooltip:SetFrameLevel(9);
NWBLayerMapDragFrame.tooltip:SetAlpha(.8);
NWBLayerMapDragFrame.tooltip.fs = NWBLayerMapDragFrame.tooltip:CreateFontString("NWBLayerMapDragTooltipFS", "ARTWORK");
NWBLayerMapDragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
NWBLayerMapDragFrame.tooltip.fs:SetFont(NWB.regionFont, 12);
NWBLayerMapDragFrame.tooltip.fs:SetText(L["Hold to drag"]);
NWBLayerMapDragFrame.tooltip:SetWidth(NWBLayerMapDragFrame.tooltip.fs:GetStringWidth() + 16);
NWBLayerMapDragFrame.tooltip:SetHeight(NWBLayerMapDragFrame.tooltip.fs:GetStringHeight() + 10);
NWBLayerMapDragFrame:SetScript("OnEnter", function(self)
	NWBLayerMapDragFrame.tooltip:Show();
end)
NWBLayerMapDragFrame:SetScript("OnLeave", function(self)
	NWBLayerMapDragFrame.tooltip:Hide();
end)
NWBLayerMapDragFrame.tooltip:Hide();
NWBLayerMapDragFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent().isMoving) then
		self:GetParent().EditBox:ClearFocus();
		self:GetParent():StartMoving();
		self:GetParent().isMoving = true;
		--self:GetParent():SetUserPlaced(false);
	end
end)
NWBLayerMapDragFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)
NWBLayerMapDragFrame:SetScript("OnHide", function(self)
	if (self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)

--Top right X close button.
local NWBLayerMapFrameClose = CreateFrame("Button", "NWBLayerMapFrameClose", NWBLayerMapFrame, "UIPanelCloseButton");
--[[NWBLayerMapFrameClose:SetPoint("TOPRIGHT", -5, 8.6);
NWBLayerMapFrameClose:SetWidth(31);
NWBLayerMapFrameClose:SetHeight(31);]]
NWBLayerMapFrameClose:SetPoint("TOPRIGHT", -12, 3.75);
NWBLayerMapFrameClose:SetWidth(20);
NWBLayerMapFrameClose:SetHeight(20);
NWBLayerMapFrameClose:SetFrameLevel(3);
NWBLayerMapFrameClose:SetScript("OnClick", function(self, arg)
	NWBLayerMapFrame:Hide();
end)
--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
--Big thanks to Meorawr for this.
NWBLayerMapFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBLayerMapFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBLayerMapFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBLayerMapFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

function NWB:openLayerMapFrame()
	if (not NWB.isLayered) then
		return;
	end
	NWBLayerMapFrame.fs:SetFont(NWB.regionFont, 14);
	if (NWBLayerMapFrame:IsShown()) then
		NWBLayerMapFrame:Hide();
	else
		NWBLayerMapFrame:SetHeight(300);
		NWBLayerMapFrame:SetWidth(450);
		local fontSize = false
		NWBLayerMapFrame.EditBox:SetFont(NWB.regionFont, 14, "");
		NWBLayerMapFrame.EditBox:SetWidth(NWBLayerMapFrame:GetWidth() - 30);
		NWBLayerMapFrame:Show();
		NWB:recalcLayerMapFrame()
		--Changing scroll position requires a slight delay.
		--Second delay is a backup.
		C_Timer.After(0.05, function()
			NWBLayerMapFrame:SetVerticalScroll(0);
		end)
		C_Timer.After(0.3, function()
			NWBLayerMapFrame:SetVerticalScroll(0);
		end)
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame:IsShown()) then
			NWBLayerMapFrame:SetFrameStrata("DIALOG")
		else
			NWBLayerMapFrame:SetFrameStrata("HIGH")
		end
	end
end

function NWB:recalcLayerMapFrame()
	NWBLayerMapFrame.EditBox:SetText("\n");
	if (not NWB.data.layers or type(NWB.data.layers) ~= "table" or not next(NWB.data.layers)) then
		NWBLayerMapFrame.EditBox:Insert("|cffFFFF00No zones have been mapped yet since server restart.|r\n");
	else
		local count = 0;
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			local zoneCount = 0;
			local text = "";
			if (v.layerMap and next(v.layerMap)) then
				if (v.layerMap.created) then
					--Remove "created" timestamp from layerMap, it's imported from layerMapBackups.
					--I'll change it so the timestamp isn't imported and this check can be removed later.
					v.layerMap.created = nil;
				end
				for kk, vv in NWB:pairsByKeys(v.layerMap) do
					zoneCount = zoneCount + 1;
					local mapInfo = C_Map.GetMapInfo(vv);
					local zoneInfo = "Unknown";
					if (mapInfo and next(mapInfo)) then
						zoneInfo = mapInfo.name;
					end
					---NWBLayerMapFrame.EditBox:Insert("  -|cffFFFF00" .. zoneInfo .. " ".. kk .. " |cff9CD6DE" .. vv .. "\n");
					text = text .. "  -|cffFFFF00" .. zoneInfo .. "|r |cFF989898(" .. kk .. ")|r\n";
				end
			else --C_Map.GetAreaInfo(
			--C_Map.GetMapInfoAtPosition(1434, 1, 1)
				text = text .. "  -|cffFFFF00" .. L["No zones mapped for this layer yet."] .. "|r\n";
			end
			if (NWB.faction == "Horde") then
				NWBLayerMapFrame.EditBox:Insert("\n|cff00ff00[" .. L["Layer"] .. " " .. count .. "]|r  |cff9CD6DE(" .. NWB.mapName .. " " .. k .. ")|r  "
						.. NWB.prefixColor .. "(" .. zoneCount .. " " .. L["zones mapped"] .. ")|r\n" .. text);
			else
				NWBLayerMapFrame.EditBox:Insert("\n|cff00ff00[" .. L["Layer"] .. " " .. count .. "]|r  |cff9CD6DE(" .. NWB.mapName .. " " .. k .. ")|r  "
						.. NWB.prefixColor .. "(" .. zoneCount .. " " .. L["zones mapped"] .. ")|r\n" .. text);
			end
		end
	end
end

--Reset layers, needed sometimes when upgrading from old version.
--Old version copys over the whole table from new version users and prevents a proper new layer being created with that id.
function NWB:resetLayerData()
	if (NWB.db.global.resetDailyData) then
		--Only run during v2.16 after a daily bug fix, will be removed after.
		NWB.data.tbcDD = nil;
		NWB.data.tbcDDT = nil;
		NWB.data.tbcHD = nil;
		NWB.data.tbcHDT = nil;
		NWB.data.tbcPD = nil;
		NWB.data.tbcPDT = nil;
		NWB.db.global.resetDailyData = false;
	end
	if (NWB.db.global.resetLayers14) then
		NWB:debug("resetting layer data");
		NWB.data.layers = {};
		NWB.data.layerMapBackups = {};
		NWB.db.global.resetLayers14 = false;
	end
end

function NWB:fixAllLayers()
	for k, v in pairs(NWB.data.layers) do
		if (type(k) == "number") then
			NWB:fixLayer(k);
		else
			--On very rare occasions the layer id is saved as a string not a number, fix it here.
			--I found why this happens and fixed it, but this check stays here to fix existing databases.
			NWB.data.layers[k] = nil;
		end
	end
end

function NWB:fixLayer(layer)
	if (not tonumber(NWB.data.layers[layer]['rendTimer'])) then
		NWB.data.layers[layer]['rendTimer'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['rendYell'])) then
		NWB.data.layers[layer]['rendYell'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['rendYell2'])) then
		NWB.data.layers[layer]['rendYell2'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['onyTimer'])) then
		NWB.data.layers[layer]['onyTimer'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['onyYell'])) then
		NWB.data.layers[layer]['onyYell'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['onyYell2'])) then
		NWB.data.layers[layer]['onyYell2'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['nefTimer'])) then
		NWB.data.layers[layer]['rendTimer'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['nefYell'])) then
		NWB.data.layers[layer]['nefYell'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['nefYell2'])) then
		NWB.data.layers[layer]['nefYell2'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['lastSeenNPC'])) then
		NWB.data.layers[layer]['lastSeenNPC'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower1'])) then
		NWB.data.layers[layer]['flower1'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower2'])) then
		NWB.data.layers[layer]['flower2'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower3'])) then
		NWB.data.layers[layer]['flower3'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower4'])) then
		NWB.data.layers[layer]['flower4'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower5'])) then
		NWB.data.layers[layer]['flower5'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower6'])) then
		NWB.data.layers[layer]['flower6'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower7'])) then
		NWB.data.layers[layer]['flower7'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower8'])) then
		NWB.data.layers[layer]['flower8'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower9'])) then
		NWB.data.layers[layer]['flower9'] = 0;
	end
	if (not tonumber(NWB.data.layers[layer]['flower10'])) then
		NWB.data.layers[layer]['flower10'] = 0;
	end
end

function NWB:validateLayer(layer)
	--Temp fix till I work out why sometimes the NPC zoneid is different by a few integers, it's strange....
	--In testing the zoneid's had the same last and first number, but middle numbers sometimes changed depending on person.
	--107 and 127 from same NPC by different people, --9914 and 9924 from same NPC by different people.
	--Ignore new data if it's within close numeric range of an ID we already have.
	--No 2 valid layers should ever have close together id's?
	--EDIT: From a user on curse layer numbers on Auberdine for this week are 315 and 326.
	--[[for localLayer, localV in pairs(NWB.data.layers) do
		if ((layer > (localLayer - 30)) and (layer < (localLayer + 30)) and localLayer ~= layer
				--Some realms seem to have legit layers close together.
				--Each fake close together layer I've seen so far has the same last number, it's always multiples of 10.
				--Removing the strict 30 closeness check and try this instead to accomodate those close together realms.
				--If it works it should atleast lower the chance of a false positive to 1 in 10.
				--Can't create new chars on these locked layered realms to test so all I can do is ake these small changes and hope...
				and (string.sub(layer, -1) == string.sub(localLayer, -1))) then
			NWB:debug("close range layer found old:", localLayer, "new:", layer);
			return;
		end
	end]]
	return true;
end

--Function to move first layer data to non-layered data when Blizzard removes layering on a realm.
--Not currently used anywhere but can be /run after updating to new version that removes layering for your realm.
function NWB:convertLayerToNonLayer()
	print("|cFFFFFF00Looking for layered timers to convert.")
	local found;
	if (NWB.data.layers) then
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			if (v.rendTimer and v.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
				NWB.data.rendTimer = v.rendTimer;
				NWB.data.rendYell = v.rendYell or 0;
				print("|cFFFFFF00Found current Rend timer, converting.")
				found = true;
			end
			if (v.onyTimer and v.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
				NWB.data.onyTimer = v.onyTimer;
				NWB.data.onyYell = v.onyYell or 0;
				NWB.data.onyNpcDied = v.onyNpcDied or 0;
				print("|cFFFFFF00Found current Onyxia timer, converting.")
				found = true;
			end
			if (v.nefTimer and v.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
				NWB.data.nefTimer = v.nefTimer;
				NWB.data.nefYell = v.nefYell or 0;
				NWB.data.nefNpcDied = v.nefNpcDied or 0;
				print("|cFFFFFF00Found current Nefarian timer, converting.")
				found = true;
			end
			if (found) then
				print("|cFFFFFF00Done.")
			else
				print("|cFFFFFF00Done, found no timers on old layer 1.")
			end
			return;
		end
	end
end

--This pushes non-layered timers into the first layer we know.
--It's a debug only function and requires targeting a NPC in city first to create the layer.
--This is only so I can test layered stuff on my non-layered server.
function NWB:convertNonLayerToLayer()
	print("|cFFFFFF00Looking for layered timers to convert.")
	local found;
	if (NWB.data.layers) then
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			if (NWB.data.rendTimer and NWB.data.rendTimer > (GetServerTime() - NWB.rendCooldownTime)) then
				NWB.data.layers[k].rendTimer = NWB.data.rendTimer;
				NWB.data.layers[k].rendYell = NWB.data.rendYell or 0;
				print("|cFFFFFF00Found current Rend timer, converting.")
				found = true;
			end
			if (NWB.data.onyTimer and NWB.data.onyTimer > (GetServerTime() - NWB.onyCooldownTime)) then
				NWB.data.layers[k].onyTimer = NWB.data.onyTimer;
				NWB.data.layers[k].onyYell = NWB.data.onyYell or 0;
				NWB.data.layers[k].onyNpcDied = NWB.data.onyNpcDied or 0;
				print("|cFFFFFF00Found current Onyxia timer, converting.")
				found = true;
			end
			if (NWB.data.nefTimer and NWB.data.nefTimer > (GetServerTime() - NWB.nefCooldownTime)) then
				NWB.data.layers[k].nefTimer = NWB.data.nefTimer;
				NWB.data.layers[k].nefYell = NWB.data.nefYell or 0;
				NWB.data.layers[k].nefNpcDied = NWB.data.nefNpcDied or 0;
				print("|cFFFFFF00Found current Nefarian timer, converting.")
				found = true;
			end
			if (found) then
				print("|cFFFFFF00Done.")
			else
				print("|cFFFFFF00Done, found no timers on old layer 1.")
			end
			return;
		end
	end
end

--function NWB:validateLayer(layer)
--	return true;
--end
	
local MinimapLayerFrame = CreateFrame("Frame", "MinimapLayerFrame", Minimap, "ThinGoldEdgeTemplate");
MinimapLayerFrame:SetPoint("BOTTOM", 2, 4);
MinimapLayerFrame:SetFrameStrata("HIGH");
MinimapLayerFrame:SetFrameLevel(9);
MinimapLayerFrame:SetMovable(true);
MinimapLayerFrame.fs = MinimapLayerFrame:CreateFontString("MinimapLayerFrameFS", "ARTWORK");
MinimapLayerFrame.fs:SetPoint("CENTER", 0, 0);
--MinimapLayerFrame.fs:SetFont("Fonts\\ARIALN.ttf", 10); --No region font here, "Layer" in english always.
MinimapLayerFrame.fs:SetFont(NWB.regionFont, 10);
MinimapLayerFrame.fs:SetText(L["No Layer"]);
MinimapLayerFrame:SetWidth(46);
MinimapLayerFrame:SetHeight(17);
MinimapLayerFrame:Hide();
MinimapLayerFrame.tooltip = CreateFrame("Frame", "NWBVersionDragTooltip", MinimapLayerFrame, "TooltipBorderedFrameTemplate");
MinimapLayerFrame.tooltip:SetPoint("CENTER", MinimapLayerFrame, "TOP", 0, 12);
MinimapLayerFrame.tooltip:SetFrameStrata("TOOLTIP");
MinimapLayerFrame.tooltip:SetFrameLevel(9);
--MinimapLayerFrame.tooltip:SetAlpha(.9);
MinimapLayerFrame.tooltip.fs = MinimapLayerFrame.tooltip:CreateFontString("NWBVersionDragTooltipFS", "ARTWORK");
MinimapLayerFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
MinimapLayerFrame.tooltip.fs:SetFont(NWB.regionFont, 10);
MinimapLayerFrame.tooltip.fs:SetText(L["Hold Shift to drag"]);
MinimapLayerFrame.tooltip:SetWidth(MinimapLayerFrame.tooltip.fs:GetStringWidth() + 10);
MinimapLayerFrame.tooltip:SetHeight(MinimapLayerFrame.tooltip.fs:GetStringHeight() + 10);
MinimapLayerFrame:SetScript("OnEnter", function(self)
	if (NWB.isLayered) then
		MinimapLayerFrame.tooltip:Show();
		if (NWB.db.global.minimapLayerHover) then
			MinimapLayerFrame:Show();
		end
	end
end)
MinimapLayerFrame:SetScript("OnLeave", function(self)
	MinimapLayerFrame.tooltip:Hide();
	if (NWB.db.global.minimapLayerHover) then
		MinimapLayerFrame:Hide();
	end
end)
MinimapLayerFrame.tooltip:Hide();
MinimapLayerFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self.isMoving and IsShiftKeyDown()) then
		self:StartMoving();
		self.isMoving = true;
		--self:SetUserPlaced(false);
	else
		NWB:openLayerFrame();
	end
end)
MinimapLayerFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self.isMoving) then
		self:StopMovingOrSizing();
		self.isMoving = false;
	end
end)
MinimapLayerFrame:SetScript("OnHide", function(self)
	if (self.isMoving) then
		self:StopMovingOrSizing();
		self.isMoving = false;
	end
end)

--zoneID only get passed to this function when we're on team join cooldown from NWB:mapCurrentLayer().
NWB.currentLayer = 0;
function NWB:recalcMinimapLayerFrame(zoneID, event, unit)
	if ((GetServerTime() - NWB.lastJoinedGroup) < 5) then
		--Don't update minimap frame for a few seconds after joining group.
		NWB:toggleMinimapLayerFrame("hide");
		MinimapLayerFrame.fs:SetText("No Layer");
		return;
	end
	if (not NWB.db.global.minimapLayerFrame or not NWB.isLayered) then
		NWB:toggleMinimapLayerFrame("hide");
		MinimapLayerFrame.fs:SetText("No Layer");
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	local foundOldID, foundLayer;
	local count, layerNum = 0, 0;
	if (NWB.lastKnownLayerMapID > 0) then
		for k, v in NWB:pairsByKeys(NWB.data.layers) do
			count = count + 1;
			if (k == NWB.lastKnownLayerMapID) then
				NWBlayerFrame.fs2:SetText("|cFF9CD6DE" .. L["You are currently on"] .. " |cff00ff00[" .. L["Layer"] .. " " .. count .. "]|cFF9CD6DE.|r");
				if (NWB.currentLayerShared ~= count) then
					NWB:sendL(count, "recalc minimap");
					NWB.currentLayerShared = count;
				end
				NWB.currentLayer = count;
				NWB_CurrentLayer = count;
				local me = UnitName("player");
				NWB.hasL[me .. "-" .. GetRealmName()] = tostring(count);
				NWB.lastKnownLayer = count;
				NWB.lastKnownLayerID = k;
				NWB.lastKnownLayerTime = GetServerTime();
				layerNum = count;
				foundLayer = true;
				if (NWB.stvRunning and zone ~= 1434) then
					--Only from outside STV.
					NWB:refreshStvBossMarker(NWB.lastKnownLayerMapZoneID, true);
				end
			end
		end
	end
	--if (foundLayer or (NWB.faction == "Horde" and zone == 1454)
	--		or (NWB.faction == "Alliance" and zone == 1453)) then
	if (foundLayer or zone == NWB.map) then
		if (NWB.currentLayer > 0) then
			MinimapLayerFrame.fs:SetText(NWB.mmColor .. L["Layer"] .. " " .. NWB.lastKnownLayer);
			MinimapLayerFrame.fs:SetFont("Fonts\\ARIALN.ttf", 12);
			NWB_CurrentLayer = NWB.lastKnownLayer;
		elseif (layerNum > 0) then
			MinimapLayerFrame.fs:SetText(NWB.mmColor .. L["Layer"] .. " " .. layerNum);
			MinimapLayerFrame.fs:SetFont("Fonts\\ARIALN.ttf", 12);
			NWB_CurrentLayer = layerNum;
		else
			MinimapLayerFrame.fs:SetText(NWB.mmColor .. L["No Layer"]);
			MinimapLayerFrame.fs:SetFont("Fonts\\ARIALN.ttf", 10);
			NWB_CurrentLayer = 0;
		end
		--MinimapLayerFrame:SetWidth(MinimapLayerFrame.fs:GetStringWidth() + 12);
		--MinimapLayerFrame:SetHeight(MinimapLayerFrame.fs:GetStringHeight() + 12);
		NWB:toggleMinimapLayerFrame("show");
	else
		--If we just joined group and we're not currently recording NWB.lastKnownLayerMapID then use this as a backup to find the layer.
		--All this does is change the minimap layer frame text, this doesn't effect anything else or change any of the mapping variables.
		--This is a bit of a hacky fix to just tag a recalc on the end of the layer mapping system when on team join cooldown.
		--But layer mapping is working basically perfect right now and I don't want to rewrite it quite yet.
		--Edit: Now also effects shared guild layer data.
		local foundBackup;
		if (zoneID) then
			local backupCount = 0;
			for k, v in NWB:pairsByKeys(NWB.data.layers) do
				backupCount = backupCount + 1;
				if (v.layerMap and next(v.layerMap)) then
					for zone, map in pairs(v.layerMap) do
						if (zone == zoneID) then
							MinimapLayerFrame.fs:SetText(L["Layer"] .. " " .. backupCount);
							MinimapLayerFrame.fs:SetFont("Fonts\\ARIALN.ttf", 12);
							foundBackup = true;
							NWB_CurrentLayer = backupCount;
							if (NWB.isClassic and (GetServerTime() - NWB.lastJoinedGroup) > 10) then
								local _, _, zone = NWB:GetPlayerZonePosition();
								if (zone ~= 1453 and zone ~= 1454) then
									NWB.lastKnownLayerID = k;
								end
							end
							local me = UnitName("player");
							NWB.hasL[me .. "-" .. GetRealmName()] = tostring(backupCount);
							if (NWB.currentLayerShared ~= backupCount) then
								NWB:sendL(backupCount, "recalc minimap backup");
								NWB.currentLayerShared = backupCount;
							end
						end
					end
				end
			end
		else
			if (NWB.currentLayerShared ~= 0) then
				NWB:sendL(0, "recalc minimap no zoneid", event, unit);
				NWB.currentLayerShared = 0;
			end
			NWB_CurrentLayer = 0;
		end
		NWB.currentLayer = 0;
		if (foundBackup) then
			NWB:toggleMinimapLayerFrame("show");
		else
			NWB:toggleMinimapLayerFrame("hide");
		end
	end
end

--Minimap will show only when a layer is known,
--If user has minimapLayerHover enabled then it will only show when they hover the minimap with mouse.
--It will still only show when a layer is known on mouseover for the minimapLayerHover setting.
NWB.minimapLayerFrameState = nil;
function NWB:toggleMinimapLayerFrame(type)
	if (NWB:isInArena()) then
		MinimapLayerFrame:Hide();
		NWB.minimapLayerFrameState = nil;
	elseif (type == "show") then
		if (not NWB.db.global.minimapLayerHover) then
			MinimapLayerFrame:Show();
		end
		NWB.minimapLayerFrameState = true;
	else
		if (not NWB.db.global.minimapLayerHover) then
			MinimapLayerFrame:Hide();
		end
		NWB.minimapLayerFrameState = nil;
	end
	NWB:refreshMinimapLayerFrame();
end

function NWB:refreshMinimapLayerFrame()
	MinimapLayerFrame.fs:SetFont(NWB.LSM:Fetch("font", NWB.db.global.minimapLayerFont), NWB.db.global.minimapLayerFontSize);
	--MinimapLayerFrame:SetScale(NWB.db.global.minimapLayerScale);
end

Minimap:HookScript("OnEnter", function(self, arg)
	if (NWB.db.global.minimapLayerHover) then
		MinimapLayerFrame:Show();
	end
end)

Minimap:HookScript("OnLeave", function(self, arg)
	if (NWB.db.global.minimapLayerHover) then
		MinimapLayerFrame:Hide();
	end
end)

SLASH_NWBLAYERSCMD1, SLASH_NWBLAYERSCMD2 = '/layer', '/layers';
function SlashCmdList.NWBLAYERSCMD(msg, editBox)
	NWB:openLayerFrame();
end

--Version guild display.
local NWBVersionFrame = CreateFrame("ScrollFrame", "NWBVersionFrame", UIParent, NWB:addBackdrop("NWB_InputScrollFrameTemplate"));
NWBVersionFrame:Hide();
NWBVersionFrame:SetToplevel(true);
NWBVersionFrame:SetMovable(true);
NWBVersionFrame:EnableMouse(true);
tinsert(UISpecialFrames, "NWBVersionFrame");
NWBVersionFrame:SetPoint("CENTER", UIParent, 0, 100);
NWBVersionFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
NWBVersionFrame:SetBackdropColor(0,0,0,.5);
NWBVersionFrame.CharCount:Hide();
NWBVersionFrame:SetFrameStrata("HIGH");
NWBVersionFrame.EditBox:SetAutoFocus(false);
NWBVersionFrame.EditBox:SetScript("OnKeyDown", function(self, arg)
	--If control key is down keep focus for copy/paste to work.
	--Otherwise remove focus so "enter" can be used to open chat and not have a stuck cursor on this edit box.
	if (not IsControlKeyDown()) then
		NWBVersionFrame.EditBox:ClearFocus();
	end
end)
NWBVersionFrame.EditBox:SetScript("OnShow", function(self, arg)
	NWBVersionFrame:SetVerticalScroll(0);
end)
local versionUpdateTime = 0;
NWBVersionFrame:HookScript("OnUpdate", function(self, arg)
	--Only update once per second.
	if (GetServerTime() - versionUpdateTime > 0 and self:GetVerticalScrollRange() == 0) then
		NWB:recalclayerFrame();
		versionUpdateTime = GetServerTime();
	end
end)
NWBVersionFrame.fs = NWBVersionFrame:CreateFontString("NWBVersionFrameFS", "ARTWORK");
NWBVersionFrame.fs:SetPoint("TOP", 0, -0);
NWBVersionFrame.fs:SetFont(NWB.regionFont, 14);
NWBVersionFrame.fs:SetText("|cFFFFFF00Guild versions seen since logon|r");

local NWBVersionDragFrame = CreateFrame("Frame", "NWBVersionDragFrame", NWBVersionFrame);
NWBVersionDragFrame:SetToplevel(true);
NWBVersionDragFrame:EnableMouse(true);
NWBVersionDragFrame:SetWidth(205);
NWBVersionDragFrame:SetHeight(38);
NWBVersionDragFrame:SetPoint("TOP", 0, 4);
NWBVersionDragFrame:SetFrameLevel(131);
NWBVersionDragFrame.tooltip = CreateFrame("Frame", "NWBVersionDragTooltip", NWBVersionDragFrame, "TooltipBorderedFrameTemplate");
NWBVersionDragFrame.tooltip:SetPoint("CENTER", NWBVersionDragFrame, "TOP", 0, 12);
NWBVersionDragFrame.tooltip:SetFrameStrata("TOOLTIP");
NWBVersionDragFrame.tooltip:SetFrameLevel(9);
NWBVersionDragFrame.tooltip:SetAlpha(.8);
NWBVersionDragFrame.tooltip.fs = NWBVersionDragFrame.tooltip:CreateFontString("NWBVersionDragTooltipFS", "ARTWORK");
NWBVersionDragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
NWBVersionDragFrame.tooltip.fs:SetFont(NWB.regionFont, 12);
NWBVersionDragFrame.tooltip.fs:SetText(L["Hold to drag"]);
NWBVersionDragFrame.tooltip:SetWidth(NWBVersionDragFrame.tooltip.fs:GetStringWidth() + 16);
NWBVersionDragFrame.tooltip:SetHeight(NWBVersionDragFrame.tooltip.fs:GetStringHeight() + 10);
NWBVersionDragFrame:SetScript("OnEnter", function(self)
	NWBVersionDragFrame.tooltip:Show();
end)
NWBVersionDragFrame:SetScript("OnLeave", function(self)
	NWBVersionDragFrame.tooltip:Hide();
end)
NWBVersionDragFrame.tooltip:Hide();
NWBVersionDragFrame:SetScript("OnMouseDown", function(self, button)
	if (button == "LeftButton" and not self:GetParent().isMoving) then
		self:GetParent().EditBox:ClearFocus();
		self:GetParent():StartMoving();
		self:GetParent().isMoving = true;
		--self:GetParent():SetUserPlaced(false);
	end
end)
NWBVersionDragFrame:SetScript("OnMouseUp", function(self, button)
	if (button == "LeftButton" and self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)
NWBVersionDragFrame:SetScript("OnHide", function(self)
	if (self:GetParent().isMoving) then
		self:GetParent():StopMovingOrSizing();
		self:GetParent().isMoving = false;
	end
end)

--Top right X close button.
local NWBVersionFrameClose = CreateFrame("Button", "NWBVersionFrameClose", NWBVersionFrame, "UIPanelCloseButton");
--[[NWBVersionFrameClose:SetPoint("TOPRIGHT", -5, 8.6);
NWBVersionFrameClose:SetWidth(31);
NWBVersionFrameClose:SetHeight(31);]]
NWBVersionFrameClose:SetPoint("TOPRIGHT", -12, 3.75);
NWBVersionFrameClose:SetWidth(20);
NWBVersionFrameClose:SetHeight(20);
NWBVersionFrameClose:SetFrameLevel(3);
NWBVersionFrameClose:SetScript("OnClick", function(self, arg)
	NWBVersionFrame:Hide();
end)
--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
--Big thanks to Meorawr for this.
NWBVersionFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBVersionFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBVersionFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
NWBVersionFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

function NWB:openVersionFrame()
	NWBVersionFrame.fs:SetFont(NWB.regionFont, 14);
	if (NWBVersionFrame:IsShown()) then
		NWBVersionFrame:Hide();
	else
		NWBVersionFrame:SetHeight(300);
		NWBVersionFrame:SetWidth(450);
		local fontSize = false
		NWBVersionFrame.EditBox:SetFont(NWB.regionFont, 14, "");
		NWBVersionFrame.EditBox:SetWidth(NWBVersionFrame:GetWidth() - 30);
		NWBVersionFrame:Show();
		NWB:recalcVersionFrame();
		--Changing scroll position requires a slight delay.
		--Second delay is a backup.
		C_Timer.After(0.05, function()
			NWBVersionFrame:SetVerticalScroll(0);
		end)
		C_Timer.After(0.3, function()
			NWBVersionFrame:SetVerticalScroll(0);
		end)
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame:IsShown()) then
			NWBVersionFrame:SetFrameStrata("DIALOG")
		else
			NWBVersionFrame:SetFrameStrata("HIGH")
		end
	end
end

function NWB:recalcVersionFrame()
	NWBVersionFrame.EditBox:SetText("\n\n");
	if (not IsInGuild()) then
		NWBVersionFrame.EditBox:Insert("|cffFFFF00" .. L["layersNoGuild"] .. "|r\n");
	else
		GuildRoster();
		local numTotalMembers = GetNumGuildMembers();
		local onlineMembers = {};
		local me = UnitName("player") .. "-" .. GetNormalizedRealmName();
		local sorted = {};
		local guild = {};
		for i = 1, numTotalMembers do
			local name, _, _, _, _, zone, _, _, online, _, _, _, _, isMobile = GetGuildRosterInfo(i);
			name = string.gsub(string.gsub(name, "'", ""), " ", "");
			guild[name] = true;
		end
		for k, v in pairs(NWB.hasAddon) do
			if (not sorted[v]) then
				sorted[v] = {};
			end
			if (guild[k]) then
				local who, realm = strsplit("-", k, 2);
				sorted[v][who] = true;
			end
		end
		for k, v in NWB:pairsByKeys(sorted) do
			for kk, vv in NWB:pairsByKeys(v) do
				if (tonumber(k) > 0 or NWB.isDebug) then
					NWBVersionFrame.EditBox:Insert("|cffFFFF00" .. k .. "|r |cff9CD6DE" .. kk .. "|r\n");
				end
			end
		end
	end
end

--NPC events
local f = CreateFrame("Frame");
f:RegisterEvent("GOSSIP_SHOW");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "GOSSIP_SHOW") then
		local g1, type1, g2, type2, g3, type3, g4, type4, g5, type5, g6, type6, g7, type7, g8, type8 = GetGossipOptions();
		--Fix for for when it was moved to C_GossipInfo and changed to a table instead of strings, but still backwards compatible.
		if (g1 and type(g1) == "table") then
			--If there are no gossip options we still get an empty table so set g1 to nil;
			if (not next(g1)) then
				g1 = nil;
			else
				--Sort by orderIndex so the options line up correctly.
				table.sort(g1, function(a, b) return a.orderIndex < b.orderIndex end);
				--Convert locals to original gossip strings given by GetGossipOptions().
				--g1 must be done last since it holds the table data in the new format.
				if (g1[2] and g1[2].name) then
					g2 = g1[2].name;
				end
				if (g1[3] and g1[3].name) then
					g3 = g1[3].name;
				end
				if (g1[4] and g1[4].name) then
					g4 = g1[4].name;
				end
				if (g1[5] and g1[5].name) then
					g5 = g1[5].name;
				end
				if (g1[6] and g1[6].name) then
					g6 = g1[6].name;
				end
				if (g1[7] and g1[7].name) then
					g7 = g1[7].name;
				end
				if (g1[8] and g1[8].name) then
					g8 = g1[8].name;
				end
				if (g1[1] and g1[1].name) then
					g1 = g1[1].name;
				end
			end
		end
		local npcGUID = UnitGUID("npc");
		local npcID;
		if (npcGUID) then
			_, _, _, _, _, npcID = strsplit("-", npcGUID);
		end
		if (not g1 or not npcID) then
			return;
		end
		if (npcID == "14822" and NWB.db.global.autoDmfBuff) then --Sayge NPC.
			--This string check was added first for english clients then the non-string check version further down added later.
			--I'll keep this string check version for english here anyway though because it's 100% accurate.
			--The non-string check version is new and in testing, but should work fine.
			local buffType = NWB.db.global.autoDmfBuffType;
			if (NWB.data.dmfBuffSettings and NWB.data.dmfBuffSettings[UnitName("player")]) then
				--If this character has it's own buff type set.
				--Enable after testing at next DMF, don't want any mistakes with people getting wrong buff.
				buffType = NWB.data.dmfBuffSettings[UnitName("player")];
			end
			if (GetLocale() == "enUS") then
				--Make this an option to skip the fortune cookie later.
				--[[if (string.match(g1, "I'd love to get one of those written fortunes you mentioned")) then
					return
				end
				if (string.match(g1, "I am ready to discover where my fortune lies!")) then
					SelectGossipOption(1);
					return;
				end]]
				if (g1 and not g2) then
					--Pages with only 1 option.
					SelectGossipOption(1);
					return;
				end
				if (buffType == "Damage") then
					NWB:fastDmfDamageBuff();
					--Sayge's Dark Fortune of Damage: +10% Damage (1, 1).
					SelectGossipOption(1);
					--No need for string checks for dmg, it's 1, 1.
					--[[if (string.match(g1, "I slay the man on the spot as my liege would expect me to do")) then
						SelectGossipOption(1);
					elseif (string.match(g1, "and do it in such a manner that he suffers painfully before he dies")) then
						SelectGossipOption(1);
					end]]
					return;
				end
				if (buffType == "Agility") then
					--Sayge's Dark Fortune of Agility: +10% Agility (3, 3).
					if (g3 and string.match(g3, "I confiscate the corn he has stolen, warn him that stealing is a path towards doom")) then
						SelectGossipOption(3);
					elseif (g3 and string.match(g3, "I would create some surreptitious means to keep my brother out of the order")) then
						SelectGossipOption(3);
					end
					return;
				end
				if (buffType == "Intelligence") then
					--Sayge's Dark Fortune of Intelligence: +10% Intelligence (2, 2).
					if (g2 and string.match(g2, "I turn over the man to my liege for punishment, as he has broken the law of the land")) then
						SelectGossipOption(2);
					elseif (g2 and string.match(g2, "ignore the insult, hoping to instill a fear in the ruler that he may have gaffed")) then
						SelectGossipOption(2);
					end
					return;
				end
				if (buffType == "Spirit") then
					--Sayge's Dark Fortune of Spirit: +10% Spirit (2, 1).
					if (g2 and string.match(g2, "I turn over the man to my liege for punishment, as he has broken the law of the land")) then
						SelectGossipOption(2);
					elseif (string.match(g1, "I confront the ruler on his malicious behavior, upholding my")) then
						SelectGossipOption(1);
					end
					return;
				end
				if (buffType == "Stamina") then
					--Sayge's Dark Fortune of Stamina: +10% Stamina (3, 1).
					if (g3 and string.match(g3, "I confiscate the corn he has stolen, warn him that stealing is a path towards doom")) then
						SelectGossipOption(3);
					elseif (string.match(g1, "I would speak against my brother joining the order, rushing a permanent breech")) then
						SelectGossipOption(1);
					end
					return;
				end
				if (buffType == "Strength") then
					--Sayge's Dark Fortune of Strength: +10% Strength (3, 2).
					if (g3 and string.match(g3, "I confiscate the corn he has stolen, warn him that stealing is a path towards doom")) then
						SelectGossipOption(3);
					elseif (g2 and string.match(g2, "I would speak for my brother joining the order, potentially risking the safety of the order")) then
						SelectGossipOption(2);
					end
					return;
				end
				if (buffType == "Armor") then
					--Sayge's Dark Fortune of Armor: +10% Armor (1, 3).
					if (string.match(g1, "I slay the man on the spot as my liege would expect me to do")) then
						SelectGossipOption(1);
					elseif (string.match(g3 and g3, "I risk my own life and free him so that he may prove his innocence")) then
						SelectGossipOption(3);
					end
					return;
				end
				if (buffType == "Resistance") then
					--Sayge's Dark Fortune of Resistance: +25 All Resistances (1, 2).
					if (string.match(g1, "I slay the man on the spot as my liege would expect me to do")) then
						SelectGossipOption(1);
					elseif (g2 and string.match(g2, "I execute him as per my liege's instructions, but doing so in as painless")) then
						SelectGossipOption(2);
					end
					return;
				end
			else
				--This should probably be done with a table instead of if statements, but it's small and only ran twice a month so whatever.
				if (g4) then
					--First buff selection page has 4 options, if there's 4 it can only be this page.
					if (buffType == "Damage") then
						--Sayge's Dark Fortune of Damage: +10% Damage (1, 1).
						SelectGossipOption(1);
						return;
					end
					if (buffType == "Agility") then
						--Sayge's Dark Fortune of Agility: +10% Agility (3, 3).
						SelectGossipOption(3);
						return;
					end
					if (buffType == "Intelligence") then
						--Sayge's Dark Fortune of Intelligence: +10% Intelligence (2, 2).
						SelectGossipOption(2);
						return;
					end
					if (buffType == "Spirit") then
						--Sayge's Dark Fortune of Spirit: +10% Spirit (2, 1).
						SelectGossipOption(2);
						return;
					end
					if (buffType == "Stamina") then
						--Sayge's Dark Fortune of Stamina: +10% Stamina (3, 1).
						SelectGossipOption(3);
						return;
					end
					if (buffType == "Strength") then
						--Sayge's Dark Fortune of Strength: +10% Strength (3, 2).
						SelectGossipOption(3);
						return;
					end
					if (buffType == "Armor") then
						--Sayge's Dark Fortune of Armor: +10% Armor (1, 3).
						SelectGossipOption(1);
						return;
					end
					if (buffType == "Resistance") then
						--Sayge's Dark Fortune of Resistance: +25 All Resistances (1, 2).
						SelectGossipOption(1);
						return;
					end
				elseif (g3) then
					--Second buff selection page has 3 options, if there's 3 it can only be this page.
					if (buffType == "Damage") then
						--Sayge's Dark Fortune of Damage: +10% Damage (1, 1).
						SelectGossipOption(1);
						return;
					end
					if (buffType == "Agility") then
						--Sayge's Dark Fortune of Agility: +10% Agility (3, 3).
						SelectGossipOption(3);
						return;
					end
					if (buffType == "Intelligence") then
						SelectGossipOption(2);
						return;
					end
					if (buffType == "Spirit") then
						--Sayge's Dark Fortune of Spirit: +10% Spirit (2, 1).
						SelectGossipOption(1);
						return;
					end
					if (buffType == "Stamina") then
						--Sayge's Dark Fortune of Stamina: +10% Stamina (3, 1).
						SelectGossipOption(1);
						return;
					end
					if (buffType == "Strength") then
						--Sayge's Dark Fortune of Strength: +10% Strength (3, 2).
						SelectGossipOption(2);
						return;
					end
					if (buffType == "Armor") then
						--Sayge's Dark Fortune of Armor: +10% Armor (1, 3).
						SelectGossipOption(3);
						return;
					end
					if (buffType == "Resistance") then
						--Sayge's Dark Fortune of Resistance: +25 All Resistances (1, 2).
						SelectGossipOption(2);
						return;
					end
				elseif (g1 and not g2) then
					--Pages with only 1 option.
					SelectGossipOption(1);
				end
				--NWB:print("Auto DMF buff selection only works for English client sorry, other languages coming soon.");
			end
		end
		---I have removed string checks for everything below here to make it work for all regions from the start.
		---They only ever have the 1 chat option so it should be safe.
		if (NWB.db.global.autoDireMaulBuff) then
			--if (npcID == "14326" and string.match(g1, "What have you got for me")) then --Guard Mol'dar.
			if (npcID == "14326") then --Guard Mol'dar.
				SelectGossipOption(1);
				return;
			--elseif (npcID == "14321" and string.match(g1, "Well what have you got for the new big dog of Gordok")) then --Guard Fengus.
			elseif (npcID == "14321") then --Guard Fengus.
				SelectGossipOption(1);
				return;
			--elseif (npcID == "14323" and string.match(g1, "Yeah, you're a real brainiac")) then --Guard Slip'kik.
			elseif (npcID == "14323") then --Guard Slip'kik.
				SelectGossipOption(1);
				return;
			--elseif (npcID == "14353" and string.match(g1, "I'm the new king")) then --Mizzle the Crafty.
			elseif (npcID == "14353") then --Mizzle the Crafty.
				SelectGossipOption(1);
				return;
			elseif (npcID == "14325" and string.match(g1, "Um, I'm taking some prisoners")) then --Captain Komcrush.
			--This needs string check because he can give you a quest afterwards also.
			--elseif (npcID == "14325") then --Captain Komcrush.
				SelectGossipOption(1);
				return;
			end
		end
		if (NWB.db.global.autoBwlPortal) then
			--Orb of command GameObject-0-4671-0-29-179879-00005F974A
			--if (npcID == "179879" and string.match(g1, "Place my hand on the orb")) then
			if (npcID == "179879") then
				SelectGossipOption(1);
				return;
			end
		end
	end
end)

--Not sure if this really helps much, but if dmg buff is selected we spam the gossip options instead of just waiting for events.
local fastBuffRunning = 0;
function NWB:fastDmfDamageBuff()
	local delay = 0.1;
	local count = 50;
	if ((GetServerTime() - fastBuffRunning) < (count * delay)) then
		return;
	end
	--speedtest = GetTime();
	SelectGossipOption(1);
	fastBuffRunning = GetServerTime();
	for i = 1, count do
		C_Timer.After(i * delay, function()
			SelectGossipOption(1);
		end)
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("TAXIMAP_OPENED");
f:RegisterEvent("TAXIMAP_CLOSED");
f:RegisterEvent("GOSSIP_SHOW");
local isTaxiMapOpened;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "TAXIMAP_OPENED") then
		isTaxiMapOpened = true;
		local _, _, zone = NWB:GetPlayerZonePosition();
		if (zone == 1434 and (GetServerTime() - NWB.lastZanBuffGained) <= NWB.db.global.buffHelperDelay) then
			NWB:buffDroppedTaxiNode("zg", true);
		end
		NWB:getCurrentTaxiNode()
	elseif (event == "TAXIMAP_CLOSED") then
		isTaxiMapOpened = nil;
	elseif (event == "GOSSIP_SHOW") then
		local g1 = GetGossipOptions();
		--Fix for for when it was moved to C_GossipInfo and changed to a table instead of strings, but still backwards compatible.
		if (g1 and type(g1) == "table") then
			--If there are no gossip options we still get an empty table so set g1 to nil;
			if (not next(g1)) then
				g1 = nil;
			else
				--Sort by orderIndex so the options line up correctly.
				table.sort(g1, function(a, b) return a.orderIndex < b.orderIndex end);
				--Convert locals to original gossip strings given by GetGossipOptions().
				if (g1[1] and g1[1].name) then
					g1 = g1[1].name;
				end
			end
		end
		local npcGUID = UnitGUID("npc");
		local npcID;
		if (npcGUID) then
			_, _, _, _, _, npcID = strsplit("-", npcGUID);
		end
		if (not g1 or not npcID) then
			return;
		end
		if ((npcID == "2858" or npcID == "2859") and NWB.db.global.takeTaxiZG
				and (GetServerTime() - NWB.lastZanBuffGained) <= NWB.db.global.buffHelperDelay) then
			SelectGossipOption(1);
		end
	end
end)

function NWB:buffDroppedTaxiNode(buffType, skipCheck)
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (buffType == "zg") then
		local g1 = GetGossipOptions();
		--Fix for for when it was moved to C_GossipInfo and changed to a table instead of strings, but still backwards compatible.
		if (g1 and type(g1) == "table") then
			--If there are no gossip options we still get an empty table so set g1 to nil;
			if (not next(g1)) then
				g1 = nil;
			else
				--Sort by orderIndex so the options line up correctly.
				table.sort(g1, function(a, b) return a.orderIndex < b.orderIndex end);
				--Convert locals to original gossip strings given by GetGossipOptions().
				if (g1[1] and g1[1].name) then
					g1 = g1[1].name;
				end
			end
		end
		local npcGUID = UnitGUID("npc");
		local npcID;
		if (npcGUID) then
			_, _, _, _, _, npcID = strsplit("-", npcGUID);
		end
		--If we have npc chat open but didn't click to get to the fp map then do it.
		if ((npcID == "2858" or npcID == "2859") and g1) then
			SelectGossipOption(1);
		end
		if (NWB.db.global.takeTaxiZG and (isTaxiMapOpened or skipCheck) and zone == 1434) then
			NWB:takeTaxiNode(NWB.db.global.takeTaxiNodeZG);
		end
	end
end

function NWB:takeTaxiNode(node)
	if (not isTaxiMapOpened) then
		return;
	end
	local nodeName = NWB:GetTaxiNameFromNode(node);
	for i = 1, NumTaxiNodes() do
		if (TaxiNodeName(i) == nodeName) then
			TakeTaxiNode(i);
		end
	end
	NWB:print("Auto Taking flight path to " .. nodeName .. ".");
end

--Get flight path name from nodeID.
--No need for faction check since we're checking the nodeID and not the name.
function NWB:GetTaxiNameFromNode(node)
	--Check Kalimdor.
	local nodes = C_TaxiMap.GetTaxiNodesForMap(1414);
	for k, v in pairs(nodes) do
		if (v.nodeID == node) then
			return v.name;
		end
	end
	--Check Eastern Kingdoms.
	local nodes = C_TaxiMap.GetTaxiNodesForMap(1415);
	for k, v in pairs(nodes) do
		if (v.nodeID == node) then
			return v.name;
		end
	end
end

--Return nodeID, name, index;
function NWB:getCurrentTaxiNode()
	if (not isTaxiMapOpened) then
		return;
	end
	local nodeID, name;
	for i = 1, NumTaxiNodes() do
		if (TaxiNodeGetType(i) == "CURRENT") then
			local nodeID = 0;
			local mapID = C_Map.GetBestMapForUnit("player");
			local nodes = C_TaxiMap.GetTaxiNodesForMap(mapID);
			for k, v in pairs(nodes) do
				if (v.name == TaxiNodeName(i)) then
					nodeID = v.nodeID;
				end
			end
			return nodeID, TaxiNodeName(i), i;
		end
	end
end

--This is probably a little overcomplicated, but everything I can do to stop any false alerts is worth it.
--The dialogue window can close during batch windows or bad ping when the player isn't moving.
--So we have to check for all these things.
local f = CreateFrame("Frame");
f:RegisterEvent("GOSSIP_CLOSED");
f:RegisterEvent("GOSSIP_SHOW");
f:RegisterEvent("PLAYER_STARTED_MOVING");
f:RegisterEvent("PLAYER_STOPPED_MOVING");
f:RegisterEvent("UNIT_COMBAT");
f:RegisterEvent("TRADE_SHOW");
local lastGossipNPC;
local lastGossipClose = 0;
local gossipHookActive;
local CloseAllWindowsOriginal = CloseAllWindows;
local ElvUIOrigAFK;
local isPlayerMoving;
--local gossipCombat;
local playerLastMoved = 0;
local playerLastT = 0;
local lastOnyWalkingAlert, lastNefWalkingAlert = 0, 0;
local lastNpcCombat = 0;
local tradeBlocked;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "GOSSIP_SHOW") then
		local npcID;
		lastGossipNPC = UnitGUID("npc");
		if (lastGossipNPC) then
			_, _, _, _, _, npcID = strsplit("-", lastGossipNPC);
		end
		npcID = tonumber(npcID);
		if (not gossipHookActive) then
			NWB:hookGossipFrame();
		end
		if (npcID == 14392 or npcID == 14720) then
			--Disable CloseAllWindows() and ElvUI AFK while dialogue is open with ony/nef NPC's.
			--I tried just disabling CloseAllWindows() while the dialogue is open without touching ElvUI
			--but ElvUI also runs _G.UIParent:Hide() which closes all windows too.
			--This was the only way and the user shouldn't notice any difference.
			--If they're waiting for the buff drop NPC to start walking they don't care about the afk screen anyway.
			CloseAllWindows = function() end;
			if (_G.ElvUI and _G.ElvUI[1] and _G.ElvUI[1].AFK and _G.ElvUI[1].AFK.SetAFK) then
				if (not ElvUIOrigAFK) then
					ElvUIOrigAFK = _G.ElvUI[1].AFK.SetAFK;
				end
				_G.ElvUI[1].AFK.SetAFK = function() end;
			elseif (_G.ElvUI) then
				--If some old version of ElvUI that has a diff func structure then disable this feature.
				--Not even sure if old ElvUI does have a diff structure but better not to have false alerts incase.
				lastGossipNPC = nil;
			end
			NWB:blockTrades();
			NWB:blockGuildInvites();
			NWB:disableRunthakSounds();
		end
	elseif (event == "GOSSIP_CLOSED") then
		NWB:unblockTrades(); --This should fire on logout also when it closes.
		NWB:unblockGuildInvites();
		NWB:enableRunthakSounds();
		--Small delay to check if close button was just pressed first, ghetto pre-hooking.
		--A delay is also needed for NPC target and combat status to update.
		C_Timer.After(0.5, function()
			local npcID;
			if (lastGossipNPC) then
				_, _, _, _, _, npcID = strsplit("-", lastGossipNPC);
			end
			lastGossipNPC = nil;
			npcID = tonumber(npcID);
			if (npcID == 14392 or npcID == 14720) then
				--Restore CloseAllWindows() when done talking to thesse NPC's.
				CloseAllWindows = CloseAllWindowsOriginal;
				if (ElvUIOrigAFK and _G.ElvUI and _G.ElvUI[1] and _G.ElvUI[1].AFK and _G.ElvUI[1].AFK.SetAFK) then
					_G.ElvUI[1].AFK.SetAFK = ElvUIOrigAFK;
				end
			else
				return;
			end
			if (GetTime() - lastGossipClose < 1) then
				NWB:debug("walking alert fail");
				return;
			end
			if (GetTime() - playerLastT < 2) then
				NWB:debug("walking alert fail, t");
				return;
			end
			if (GetTime() - lastNpcCombat < 3) then
				--"npc" is nil once window is closed.
				--Record UNIT_COMBAT and check if this NPC entered combat right before the close.
				NWB:debug("walking alert fail, combat");
				return;
			end
			lastGossipClose = GetTime();
			local speed = GetUnitSpeed("player");
			local targetCombat = UnitAffectingCombat("target");
			if (isPlayerMoving or speed > 0 or GetTime() - playerLastMoved < 1) then
				--Don't alert if we're the one moving.
				return;
			end
			local x, y, zone = NWB:GetPlayerZonePosition();
			--Only works within a square around the buff NPC's in org.
			if (zone ~= 1454 or (y > 0.76615830598523 or y < 0.73889772217736
					or x > 0.52495114070016 or x < 0.50128109884861)) then
				NWB:debug("walking alert fail, out of bounds");
				return;
			end
			local targetGUID = UnitGUID("target");
			local targetID;
			if (targetGUID) then
				_, _, _, _, _, targetID = strsplit("-", targetGUID);
			end
			targetID = tonumber(targetID);
			local currentSpeed = GetUnitSpeed("target");
			local layerNum;
			if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layerNum = NWB.lastKnownLayer;
			end
			if (targetID and (npcID == 14392 or npcID == 14720) and targetID == npcID
					and (currentSpeed < 1 or targetCombat)) then
				NWB:debug("walking alert failed", currentSpeed, targetCombat);
				--If current target is same as chat dialogue open and they aren't moving.
				return;
			end
			--if (gossipCombat) then
			--	NWB:debug("walking npc in combat");
			--	return;
			--end
			if (zone == 1454 and npcID == 14392) then
				if (NWB.db.global.guildNpcWalking == 1) then
					NWB:doNpcWalkingMsg("ony", layerNum);
					NWB:sendNpcWalking("GUILD", "ony", nil, layerNum);
				end
				if ((GetServerTime() - lastOnyWalkingAlert) > 40) then
					NWB:walkingAlert("ony", layerNum)
				end
			end
			if (zone == 1454 and npcID == 14720) then
				if (NWB.db.global.guildNpcWalking == 1) then
					NWB:doNpcWalkingMsg("nef", layerNum);
					NWB:sendNpcWalking("GUILD", "nef", nil, layerNum);
				end
				if ((GetServerTime() - lastNefWalkingAlert) > 40) then
					NWB:walkingAlert("nef", layerNum)
				end
			end
		end)
	elseif (event == "PLAYER_STARTED_MOVING") then
		isPlayerMoving = true;
	elseif (event == "PLAYER_STOPPED_MOVING") then
		isPlayerMoving = nil;
		playerLastMoved = GetTime();
	elseif (event == "UNIT_COMBAT") then
		local unit = ...;
		if (unit == "npc") then
			NWB:debug("lastNpcCombat");
			lastNpcCombat = GetTime();
		end
	elseif (event == "TRADE_SHOW") then
		playerLastT = GetTime();
	end
end)

local tradeFrameSwitch = CreateFrame("Frame");
tradeFrameSwitch:RegisterEvent("PLAYER_LOGIN");
--tradeFrameSwitch:RegisterEvent("CVAR_UPDATE");
tradeFrameSwitch:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN" or event == "PLAYER_LOGOUT") then
		if (GetCVar("BlockTrades") == "1" and NWB.data.isTradesBlocked == "0") then
			--Only reset one time if we logon and the setting isn't right, then disable this.
			SetCVar("BlockTrades", 0);
			NWB.data.isTradesBlocked = nil;
			NWB:verifyTradeCvar("0");
		end
	end
end)

local guildFrameSwitch = CreateFrame("Frame");
guildFrameSwitch:RegisterEvent("PLAYER_LOGIN");
guildFrameSwitch:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN" or event == "PLAYER_LOGOUT") then
		if (GetAutoDeclineGuildInvites() and NWB.data.isGuildInviteBlocked) then
			SetAutoDeclineGuildInvites(false);
			NWB.data.isGuildInviteBlocked = nil;
		end
	end
end)

local tradeBlocked;
function NWB:blockTrades()
	if (GetCVar("BlockTrades") == "0") then
		--Record current blocked setting so we can reset this at logon time just incase player crashes with npc dialogue open.
		--This won't save to file if player does crash.
		--But when we recorded the setting the time before that it will save which is a good fallback.
		NWB.data.isTradesBlocked = "0";
		tradeFrameSwitch:RegisterEvent("PLAYER_LOGOUT");
		SetCVar("BlockTrades", 1);
		tradeBlocked = true;
		NWB:verifyTradeCvar("1");
	end
end

local guildInvitesBlocked;
function NWB:blockGuildInvites()
	if (not GetAutoDeclineGuildInvites()) then
		NWB.data.isGuildInviteBlocked = true;
		guildFrameSwitch:RegisterEvent("PLAYER_LOGOUT");
		SetAutoDeclineGuildInvites(true);
		guildInvitesBlocked = true;
	end
end

function NWB:unblockTrades()
	if (tradeBlocked) then
		tradeFrameSwitch:UnregisterEvent("PLAYER_LOGOUT");
		SetCVar("BlockTrades", 0);
		tradeBlocked = nil;
		NWB:verifyTradeCvar("0");
	end
end

function NWB:unblockGuildInvites()
	if (guildInvitesBlocked) then
		guildFrameSwitch:UnregisterEvent("PLAYER_LOGOUT");
		SetAutoDeclineGuildInvites(false);
		guildInvitesBlocked = nil;
	end
end

--Disable that annoying sound around Runthak.
--Maybe when they upgrade the API, MuteSoundFile() didn't exist until 8.5 it seems.
function NWB:disableRunthakSounds()
	 --MuteSoundFile();
end

function NWB:enableRunthakSounds()
	 --UnmuteSoundFile();
end

function NWB:verifyTradeCvar(setting)
	if (GetCVar("BlockTrades") ~= setting) then
		NWB:print("Changing Block Trades settings failed, please check game options that your block trades setting is correct.");
	end
end

local onyNpcWalking, nefNpcWalking = 0, 0;
function NWB:doNpcWalkingMsg(type, layer, sender)
	local realm;
	if (sender and string.match(sender, "-")) then
		sender, realm = strsplit("-", sender, 2);
	end
	local loadWait = GetServerTime() - NWB.loadTime;
	local msg = "";
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layer)) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type == "ony") then
		msg = L["onyNpcMoving"] .. layerMsg;
	elseif (type == "nef") then
		msg = L["nefNpcMoving"] .. layerMsg;
	else
		return;
	end
	if (loadWait > 5 and NWB.db.global.guildNpcWalking == 1 and type == "ony") then
		if ((GetServerTime() - lastOnyWalkingAlert) > 40) then
			NWB:walkingAlert("ony", layer, sender)
			NWB:sendGuildMsg(msg, "guildNpcWalking");
		end
	elseif (loadWait > 5 and NWB.db.global.guildNpcWalking == 1 and type == "nef") then
		if ((GetServerTime() - lastNefWalkingAlert) > 40) then
			NWB:walkingAlert("nef", layer, sender)
			NWB:sendGuildMsg(msg, "guildNpcWalking");
		end
	end
end

--ony 29.923999999999
--rend 10.306999999972
function NWB:walkingAlert(type, layer, sender)
	local realm;
	if (sender and string.match(sender, "-")) then
		sender, realm = strsplit("-", sender, 2);
	end
	local msg = "";
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layer)) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type == "ony") then
		msg = L["onyNpcMoving"] .. layerMsg;
		lastOnyWalkingAlert = GetServerTime();
	elseif (type == "nef") then
		msg = L["nefNpcMoving"] .. layerMsg;
		lastNefWalkingAlert = GetServerTime();
	else
		return;
	end
	NWB:playSound("soundsNpcWalking", type);
	NWB:startFlash("flashNpcWalking", type);
	NWB:middleScreenMsg("npcWalking", msg, nil, 5);
	local senderMsg = "";
	if (sender) then
		senderMsg = " (" .. sender .. ")";
	end
	NWB:print(msg .. senderMsg, nil, nil, true);
end

--Record a time if we manually closed the dialogue by pressing escape so no false alert.
f:SetScript("OnKeyDown", function(self, key)
	if (key == "ESCAPE") then
		lastGossipClose = GetTime();
	end
end)
f:SetPropagateKeyboardInput(true);

--Record a time if we manually closed the dialogue by pressing clicking the X close button so no false alert.
--Character Info - Doesnt close.
--Spellbook - Closes chat.
--Questlog - Closes chat.
--Social - Closes chat.
--Worldmap - Closes chat.
--Help Request - Closes chat.
--Reputation - Doesnt close.
--Skills - Doesnt close.
local lastGossipUpdate = 0;
function NWB:hookGossipFrame()
	if (GossipFrameCloseButton) then
		GossipFrameCloseButton:HookScript("OnClick", function()
			lastGossipClose = GetTime();
		end)
		GossipFrameGreetingGoodbyeButton:HookScript("OnClick", function()
			lastGossipClose = GetTime();
		end)
		--[[GossipFrame:HookScript("OnUpdate", function()
			--if (GetServerTime() - lastGossipUpdate > 0) then
				gossipCombat = UnitAffectingCombat("npc");
				--lastGossipUpdate = GetServerTime();
			--end
			if (UnitAffectingCombat("npc")) then
				print("npc combat")
			end
			if (UnitAffectingCombat("target")) then
				print("target combat")
			end
		end)]]
		gossipHookActive = true;
	end
	if (SpellBookFrame) then
		SpellBookFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (QuestLogFrame) then
		QuestLogFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (FriendsListFrame) then
		FriendsListFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (WorldMapFrame) then
		WorldMapFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (HelpFrame) then
		HelpFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (GuildFrame) then
		GuildFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (WhoFrame) then
		WhoFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (PetitionFrame) then
		PetitionFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (RaidFrame) then
		RaidFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
	if (GameMenuFrame) then
		GameMenuFrame:HookScript("OnShow", function()
			lastGossipClose = GetTime();
		end)
	end
end

--Enter BG stuff.
--Two different clickable buttons to enter BG's and can be used in macros are created here.
--These macros need to be pressed twice when a BG pops so spam click it, can be put in your lip/reflector macros etc.
--Queue for only 1 BG using these.
--
--/click NWBEnterBGButton
--	This first button will work no matter what but if you press it when you have a queue
--	and no current pop then it will remove you from queue, so only press when a bg pop is ready.
--
--/click NWBEnterBGButtonSafe
--	This second button can be clicked at any time safely and won't remove you from queue.
--	But if you are in combat when the queue pops the macro won't work.
--	Button attributes can't be altered while in combat.
--	This will still atempt tp update the macro once combat ends though.

local NWBEnterBGButtonSafe = CreateFrame("Button", "NWBEnterBGButtonSafe", UIParent, "SecureActionButtonTemplate");
NWBEnterBGButtonSafe:SetAttribute("type", "macro");
local inCombatFrame = CreateFrame("Frame");
local function doEnableBgButton()
	NWBEnterBGButtonSafe:SetAttribute("macrotext", "/click DropDownList1Button2\n/click MiniMapBattlefieldFrame RightButton");
end
local macroUpdateType;
local function enableBgButton()
	if (not InCombatLockdown()) then
		doEnableBgButton();
	else
		macroUpdateType = "enable";
		inCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	end
end
local function doDisableBgButton()
	NWBEnterBGButtonSafe:SetAttribute("macrotext", "/run print\(\"|c00FFFF00No battleground queue is ready to enter yet.\"\)");
end
local function disableBgButton()
	if (not InCombatLockdown()) then
		doDisableBgButton();
	else
		macroUpdateType = "disable";
		inCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	end
end
disableBgButton();
inCombatFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_REGEN_ENABLED") then
		if (macroUpdateType == "enable") then
			doEnableBgButton();
		else
			doDisableBgButton();
		end
		inCombatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	end
end)

local NWBEnterBGButton = CreateFrame("Button", "NWBEnterBGButton", UIParent, "SecureActionButtonTemplate");
NWBEnterBGButton:SetAttribute("type", "macro");
NWBEnterBGButton:SetAttribute("macrotext", "/click DropDownList1Button2\n/click MiniMapBattlefieldFrame RightButton");

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
local bgPopUp;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_ENTERING_BATTLEGROUND") then
		bgPopUp = nil;
		disableBgButton();
	end
end)

hooksecurefunc("StaticPopup_Show", function(...)
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialogType = _G["StaticPopup"..i].which
		if (dialogType == "CONFIRM_BATTLEFIELD_ENTRY" and _G["StaticPopup" .. i]:IsShown()) then
			enableBgButton();
			bgPopUp = true;
		end
	end
end)

hooksecurefunc("StaticPopup_Hide", function(...)
	if (bgPopUp) then
		local found;
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local dialogType = _G["StaticPopup"..i].which
			if (dialogType == "CONFIRM_BATTLEFIELD_ENTRY" and _G["StaticPopup" .. i]:IsShown()) then
				found = true;
			end
		end
		if (not found) then
			disableBgButton();
			bgPopUp = nil;
		end
	end
end)

--This can't be used to check the button text, it stays as "Enter Battle" after disappearing.
--[[local lastBattlefieldUpdate = 0;
MiniMapBattlefieldFrame:HookScript("OnUpdate", function(self, event, ...)
	if (GetServerTime() - lastBattlefieldUpdate < 1) then
		--1 second throddle.
		return;
	end
	if (DropDownList1Button2 and DropDownList1Button2:GetText() == LEAVE_QUEUE) then
		disableBgButton();
	elseif (DropDownList1Button2 and DropDownList1Button2:GetText() == ENTER_BATTLE) then
		enableBgButton();
	end
	lastBattlefieldUpdate = GetServerTime();
end)]]

--Make sure we set the right click to enter button no matter how many bgs we're queued for.
--[[DropDownList1:HookScript("OnShow", function(self, event, ...)
	for i = 1, 5 do
		if (_G["DropDownList1Button" .. i] and _G["DropDownList1Button" .. i]:GetText() == ENTER_BATTLE) then
			print("found", _G["DropDownList1Button" .. i]:GetText())
		else
			print("not ", _G["DropDownList1Button" .. i]:GetText())
		end
	end
end)]]

--Credit to the addon "unitscan" for how to scan in classic. https://www.curseforge.com/wow/addons/unitscan
--Really great idea the author had for detection method.
local doScan = false;
local scanFrame = CreateFrame("Frame");
local lastPoisChange = 0;
local lastPoisZone;
local scanCheckEnabled;
addon.c = c;
scanFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN");
scanFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
scanFrame:RegisterEvent("AREA_POIS_UPDATED");
scanFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "ADDON_ACTION_FORBIDDEN") then
		local addon = ...;
		if (addon == "NovaWorldBuffs") then
			NWB:disableScan();
			local layerNum;
			--Make sure the NPC wasn't already up when we arrived.
			if (scanCheckEnabled and (GetServerTime() - lastPoisChange) > 2) then
				if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
						and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
					layerNum = NWB.lastKnownLayer;
				end
				--StaticPopup_Hide("ADDON_ACTION_FORBIDDEN");
				NWB:heraldFound(nil, layerNum);
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD" or event == "AREA_POIS_UPDATED") then
		--Must use GetServerTime() and not GetTime() for logon or its unreliable.
		lastPoisChange = GetServerTime();
		local subZone = GetSubZoneText();
		--Check if subZone actually changed (doesn't change leaving/entering the Inn etc).
		--POSTMASTER_LETTER_BARRENS_MYTHIC = "The Crossroads", seems to not work for all languages.
		local _, _, zone = NWB:GetPlayerZonePosition();
		if (LOCALE_enUS or LOCALE_enGB) then
			if (zone == 1413 and subZone == POSTMASTER_LETTER_BARRENS_MYTHIC and lastPoisZone ~= subZone) then
				NWB:enableScan();
			elseif (not subZone or lastPoisZone ~= subZone) then
				NWB:disableScan();
			end
			lastPoisZone = subZone;
		else
			--For non english clients there are too many variations of what crossroads is called.
			--Some GetSubZoneText() like German client aren't even translated and are just "Crossroads".
			--So just run the scan anywhere in the barrens, it still checks coords for within crossroads anyway.
			if (zone == 1413) then
				NWB:enableScan();
			elseif (zone ~= 1413) then
				NWB:disableScan();
			end
			lastPoisZone = subZone;
		end
	end
end)

function NWB:enableScan()
	if (NWB.isClassic and not doScan and NWB.db.global.earlyRendScan) then
		--NWB:debug("Starting NPC scan.");
		--Disable swatter from intercepting our error check, it breaks the NPC warning.
		if (Swatter and Swatter.Frame) then
			Swatter.Frame:UnregisterEvent("ADDON_ACTION_FORBIDDEN");
		end
		doScan = true;
		NWB:scanTicker();
	end
end

function NWB:disableScan()
	if (doScan) then
		--NWB:debug("Stopping NPC scan.");
		if (Swatter and Swatter.Frame) then
			Swatter.Frame:RegisterEvent("ADDON_ACTION_FORBIDDEN");
		end
	end
	doScan = false;
end

function NWB:scanTicker()
	if (not doScan or not NWB.db.global.earlyRendScan) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (LOCALE_enUS or LOCALE_enGB) then
		if (zone ~= 1413 or GetSubZoneText() ~= POSTMASTER_LETTER_BARRENS_MYTHIC) then
			NWB:debug("Scan zone error.");
			NWB:disableScan();
		end
	else
		if (zone ~= 1413) then
			NWB:debug("Scan zone error.");
			NWB:disableScan();
		end
	end
	--Only enabled during this short window so it doesn't clash with other scan addons.
	scanCheckEnabled = true;
	UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN");
	scanFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN");
	TargetUnit(L["Herald of Thrall"], true);
	scanFrame:UnregisterEvent("ADDON_ACTION_FORBIDDEN");
	UIParent:RegisterEvent("ADDON_ACTION_FORBIDDEN");
	scanCheckEnabled = false;
	C_Timer.After(1, function()
		NWB:scanTicker();
	end)
end

function NWB:heraldFound(sender, layer)
	if (not NWB:verifyHeraldPosition()) then
		NWB:debug("Bad herald position found.");
		return;
	end
	if ((GetServerTime() - NWB.lastHeraldAlert) > 40) then
		local msg = L["heraldFoundCrossroads"];
		local timerMsg = L["heraldFoundTimerMsg"];
		local time = 20;
		local layerMsg = "";
		if (NWB.isLayered and tonumber(layer)) then
			layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
		end
		msg = msg .. layerMsg;
		NWB.lastHeraldAlert = GetServerTime();
		NWB:playSound("soundsNpcWalking", "rend");
		NWB:startFlash("flashNpcWalking", "rend");
		NWB:middleScreenMsg("heraldFound", msg, nil, 5);
		local senderMsg = "";
		if (sender) then
			senderMsg = " (" .. sender .. ")";
		end
		NWB:print(msg .. senderMsg);
		if (_G["DBM"] and _G["DBM"].CreatePizzaTimer and NWB.isClassic) then
			_G["DBM"]:CreatePizzaTimer(time, timerMsg);
		end
		--[[if (IsAddOnLoaded("BigWigs") and NWB.db.global.bigWigsSupport) then
			if (not SlashCmdList.BIGWIGSLOCALBAR) then
				LoadAddOn("BigWigs_Plugins");
			end
			if (SlashCmdList.BIGWIGSLOCALBAR) then
				SlashCmdList.BIGWIGSLOCALBAR(time .. " " .. timerMsg);
			end
		end]]
		NWB:sendBigWigs(time, timerMsg);
	end
end

--I want to be very sure there's never any false alerts for this so there's extra checks that probably aren't needed.
--The extra checks are cheap to do though.
function NWB:verifyHeraldPosition()
	local x, y, zone = NWB:GetPlayerZonePosition();
	--Only works within a square around the crossraods.
	if (zone ~= 1413 or (y > 0.33975947617077 or y < 0.26516187865554
			or x > 0.54101810787861 or x < 0.49812006091052)) then
		return;
	end
	return true;
end

--Backup timer set from the yell incase the NPC wasn't found.
function NWB:heraldYell()
	if ((GetServerTime() - NWB.lastHeraldAlert) > 40) then
		local timerMsg = "Crossroads Rend";
		local time = 6;
		local layerMsg = "";
		if (_G["DBM"] and _G["DBM"].CreatePizzaTimer and NWB.isClassic) then
			_G["DBM"]:CreatePizzaTimer(time, timerMsg);
		end
		NWB:sendBigWigs(time, timerMsg);
	end
	NWB.lastHeraldYell = GetServerTime();
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_FLAGS_CHANGED");
f:SetScript('OnEvent', function(self, event, ...)
	NWB:recordPvpState();
end)

function NWB:recordPvpState()
	if (NWB.data.myChars[UnitName("player")]) then
		NWB.data.myChars[UnitName("player")].pvpFlag = UnitIsPVP("player");
		if (NWBbuffListFrame:IsShown()) then
			NWB:recalcBuffListFrame();
		end
	end
end

if (NWB.isClassic) then
	--DMF Helper Frame.
	--This helps using the stuck method for DMF buff people are already using on pvp realms for when factions are griefing each other.
	--If Blizzard is against using stuck in this way I'll be happy to remove this.
	local dmfTimerBar;
	local NWBDmfFrame = CreateFrame("Frame", "NWBDmfFrame", UIParent, NWB:addBackdrop());
	NWBDmfFrame:Hide();
	NWBDmfFrame:SetToplevel(true);
	NWBDmfFrame:SetMovable(true);
	NWBDmfFrame:EnableMouse(true);
	--tinsert(UISpecialFrames, "NWBDmfFrame");
	NWBDmfFrame:SetPoint("CENTER", UIParent, -325, 125);
	NWBDmfFrame:SetWidth(250);
	NWBDmfFrame:SetHeight(270);
	NWBDmfFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",insets = {top = 0, left = 0, bottom = 0, right = 0}});
	NWBDmfFrame:SetBackdropColor(0,0,0,.6);
	NWBDmfFrame:SetFrameLevel(128);
	NWBDmfFrame:SetFrameStrata("MEDIUM");
	NWBDmfFrame.fs = NWBDmfFrame:CreateFontString("NWBDmfFrameFS", "ARTWORK");
	NWBDmfFrame.fs:SetPoint("TOP", 0, -3);
	NWBDmfFrame.fs:SetFont(NWB.regionFont, 14);
	NWBDmfFrame.fs:SetText(NWB.prefixColor .. "NWB Stuck Helper");
	NWBDmfFrame.fs2 = NWBDmfFrame:CreateFontString("NWBDmfFrameFS2", "ARTWORK");
	NWBDmfFrame.fs2:SetPoint("TOP", 0, -65);
	NWBDmfFrame.fs2:SetFont(NWB.regionFont, 14);
	local iwtKeybind = "";
	NWBDmfFrame.fs2:SetText("Current Interact With Target keybind: |cffffa500" .. iwtKeybind);
	NWBDmfFrame.fs3 = NWBDmfFrame:CreateFontString("NWBDmfFrameFS", "ARTWORK");
	NWBDmfFrame.fs3:SetPoint("TOP", 0, -19);
	NWBDmfFrame.fs3:SetFont(NWB.regionFont, 14);
	NWBDmfFrame.fs3:SetText("|cffffff00Target Sayge and be in interact range\nbefore starting.");

	function NWB:updateInteractBindText()
		iwtKeybind = GetBindingKey("INTERACTTARGET");
		if (not iwtKeybind) then
			iwtKeybind = "None";
		end
		NWBDmfFrame.fs2:SetText("Current Interact With Target keybind:\n|cffffa500" .. iwtKeybind);
	end

	local NWBDmfDragFrame = CreateFrame("Frame", "NWBbuffListDragFrame", NWBDmfFrame);
	--NWBDmfDragFrame:SetToplevel(true);
	NWBDmfDragFrame:EnableMouse(true);
	NWBDmfDragFrame:SetWidth(205);
	NWBDmfDragFrame:SetHeight(38);
	NWBDmfDragFrame:SetPoint("TOP", 0, 4);
	NWBDmfDragFrame:SetFrameLevel(131);
	NWBDmfDragFrame.tooltip = CreateFrame("Frame", "NWBDmfDragTooltip", NWBDmfDragFrame, "TooltipBorderedFrameTemplate");
	NWBDmfDragFrame.tooltip:SetPoint("CENTER", NWBDmfDragFrame, "TOP", 0, 12);
	NWBDmfDragFrame.tooltip:SetFrameStrata("TOOLTIP");
	NWBDmfDragFrame.tooltip:SetFrameLevel(9);
	NWBDmfDragFrame.tooltip:SetAlpha(.8);
	NWBDmfDragFrame.tooltip.fs = NWBDmfDragFrame.tooltip:CreateFontString("NWBDmfDragTooltipFS", "ARTWORK");
	NWBDmfDragFrame.tooltip.fs:SetPoint("CENTER", 0, 0.5);
	NWBDmfDragFrame.tooltip.fs:SetFont(NWB.regionFont, 12);
	NWBDmfDragFrame.tooltip.fs:SetText(L["Hold to drag"]);
	NWBDmfDragFrame.tooltip:SetWidth(NWBDmfDragFrame.tooltip.fs:GetStringWidth() + 16);
	NWBDmfDragFrame.tooltip:SetHeight(NWBDmfDragFrame.tooltip.fs:GetStringHeight() + 10);
	NWBDmfDragFrame:SetScript("OnEnter", function(self)
		NWBDmfDragFrame.tooltip:Show();
	end)
	NWBDmfDragFrame:SetScript("OnLeave", function(self)
		NWBDmfDragFrame.tooltip:Hide();
	end)
	NWBDmfDragFrame.tooltip:Hide();
	NWBDmfDragFrame:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton" and not self:GetParent().isMoving) then
			self:GetParent():StartMoving();
			self:GetParent().isMoving = true;
			--self:GetParent():SetUserPlaced(false);
		end
	end)
	NWBDmfDragFrame:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton" and self:GetParent().isMoving) then
			self:GetParent():StopMovingOrSizing();
			self:GetParent().isMoving = false;
		end
	end)
	NWBDmfDragFrame:SetScript("OnHide", function(self)
		if (self:GetParent().isMoving) then
			self:GetParent():StopMovingOrSizing();
			self:GetParent().isMoving = false;
		end
	end)

	--Top right X close button.
	local NWBDmfFrameClose = CreateFrame("Button", "NWBDmfFrameFrameClose", NWBDmfFrame, "UIPanelCloseButton");
	NWBDmfFrameClose:SetPoint("TOPRIGHT", 0, 0);
	NWBDmfFrameClose:SetWidth(20);
	NWBDmfFrameClose:SetHeight(20);
	--NWBDmfFrameClose:SetFrameLevel(3);
	local clickedDmfFrameClose;
	NWBDmfFrameClose:SetScript("OnClick", function(self, arg)
		clickedDmfFrameClose = true;
		NWBDmfFrame:Hide();
		NWB:print("Closed DMF helper, to reopen it walk away from Sayge and back in again (This window can disabled in /nwb config).");
	end)
	--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
	--Big thanks to Meorawr for this.
	NWBDmfFrameClose:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	NWBDmfFrameClose:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	NWBDmfFrameClose:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
	NWBDmfFrameClose:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);

	--Start stuck button.
	local NWBDmfFrameStartStuckButton = CreateFrame("Button", "NWBDmfFrameStartStuckButton", NWBDmfFrame, "UIPanelButtonTemplate, SecureActionButtonTemplate");
	NWBDmfFrameStartStuckButton:SetAttribute("type", "macro");
	NWBDmfFrameStartStuckButton:SetAttribute("macrotext", "/click HelpFrameCharacterStuckStuck");
	--NWBDmfFrameStartStuckButton:SetPoint("Bottom", 0, 10);
	NWBDmfFrameStartStuckButton:SetPoint("BottomLeft", 3, 3);
	NWBDmfFrameStartStuckButton:SetWidth(120);
	NWBDmfFrameStartStuckButton:SetHeight(30);
	NWBDmfFrameStartStuckButton:SetText("Start Stuck");
	NWBDmfFrameStartStuckButton:SetNormalFontObject("GameFontNormal");
	local lastDmfStuckStartClick = 0;
	NWBDmfFrameStartStuckButton:SetScript("OnMouseDown", function(self, arg)
		lastDmfStuckStartClick = GetTime();
	end)
	NWBDmfFrameStartStuckButton.tooltip = CreateFrame("Frame", "NWBDmfFrameStartStuckButtonTooltip", NWBDmfFrameStartStuckButton, "TooltipBorderedFrameTemplate");
	NWBDmfFrameStartStuckButton.tooltip:SetPoint("CENTER", NWBDmfFrameStartStuckButton, "CENTER", 0, -50);
	NWBDmfFrameStartStuckButton.tooltip:SetFrameStrata("TOOLTIP");
	NWBDmfFrameStartStuckButton.tooltip:SetFrameLevel(140);
	NWBDmfFrameStartStuckButton.tooltip.fs = NWBDmfFrameStartStuckButton.tooltip:CreateFontString("NWBDmfFrameStartStuckButtonTooltipFS", "ARTWORK");
	NWBDmfFrameStartStuckButton.tooltip.fs:SetPoint("CENTER", 0, 0);
	NWBDmfFrameStartStuckButton.tooltip.fs:SetFont(NWB.regionFont, 12);
	NWBDmfFrameStartStuckButton.tooltip.fs:SetText("|CffDEDE42Start a |CFFFFA50010|CffDEDE42 second stuck timer\nwith auto resurrection.\nTarget Sayge and spam interact keybind.\n(This is the ingame Blizzard\nstuck helper with no logout)");
	NWBDmfFrameStartStuckButton.tooltip:SetWidth(NWBDmfFrameStartStuckButton.tooltip.fs:GetStringWidth() + 18);
	NWBDmfFrameStartStuckButton.tooltip:SetHeight(NWBDmfFrameStartStuckButton.tooltip.fs:GetStringHeight() + 12);
	NWBDmfFrameStartStuckButton:SetScript("OnEnter", function(self)
		NWBDmfFrameStartStuckButton.tooltip:Show();
	end)
	NWBDmfFrameStartStuckButton:SetScript("OnLeave", function(self)
		NWBDmfFrameStartStuckButton.tooltip:Hide();
	end)
	NWBDmfFrameStartStuckButton.tooltip:Hide();

	--Stop stuck button.
	local NWBDmfFrameStopStuckButton = CreateFrame("Button", "NWBDmfFrameStopStuckButton", NWBDmfFrame, "UIPanelButtonTemplate, SecureActionButtonTemplate");
	NWBDmfFrameStopStuckButton:SetAttribute("type", "macro");
	NWBDmfFrameStopStuckButton:SetAttribute("macrotext", "/stopcasting");
	NWBDmfFrameStopStuckButton:SetPoint("BottomLeft", 3, 3);
	NWBDmfFrameStopStuckButton:SetWidth(120);
	NWBDmfFrameStopStuckButton:SetHeight(30);
	NWBDmfFrameStopStuckButton:SetText("Cancel");
	NWBDmfFrameStopStuckButton:SetNormalFontObject("GameFontNormal");
	local lastDmfStuckStopClick = 0;
	NWBDmfFrameStopStuckButton:SetScript("OnMouseDown", function(self, arg)
		lastDmfStuckStopClick = GetTime();
	end)
	NWBDmfFrameStopStuckButton:Hide();

	--Start logout button.
	local NWBDmfFrameStartLogoutButton = CreateFrame("Button", "NWBDmfFrameStartLogoutButton", NWBDmfFrame, "UIPanelButtonTemplate, SecureActionButtonTemplate");
	NWBDmfFrameStartLogoutButton:SetAttribute("type", "macro");
	NWBDmfFrameStartLogoutButton:SetAttribute("macrotext", "/camp");
	NWBDmfFrameStartLogoutButton:SetPoint("BottomRight", -3, 3);
	NWBDmfFrameStartLogoutButton:SetWidth(120);
	NWBDmfFrameStartLogoutButton:SetHeight(30);
	--NWBDmfFrameStartLogoutButton:SetFrameLevel(130);
	NWBDmfFrameStartLogoutButton:SetText("Start Logout");
	NWBDmfFrameStartLogoutButton:SetNormalFontObject("GameFontNormal");
	local lastDmfLogoutStartClick = 0;
	NWBDmfFrameStartLogoutButton:SetScript("OnMouseDown", function(self, arg)
		lastDmfLogoutStartClick = GetTime();
	end)
	NWBDmfFrameStartLogoutButton.tooltip = CreateFrame("Frame", "NWBDmfFrameStartLogoutButtonTooltip", NWBDmfFrameStartLogoutButton, "TooltipBorderedFrameTemplate");
	NWBDmfFrameStartLogoutButton.tooltip:SetPoint("CENTER", NWBDmfFrameStartLogoutButton, "CENTER", 0, -50);
	NWBDmfFrameStartLogoutButton.tooltip:SetFrameStrata("TOOLTIP");
	NWBDmfFrameStartLogoutButton.tooltip:SetFrameLevel(140);
	NWBDmfFrameStartLogoutButton.tooltip.fs = NWBDmfFrameStartLogoutButton.tooltip:CreateFontString("NWBDmfFrameStartLogoutButtonTooltipFS", "ARTWORK");
	NWBDmfFrameStartLogoutButton.tooltip.fs:SetPoint("CENTER", 0, 0);
	NWBDmfFrameStartLogoutButton.tooltip.fs:SetFont(NWB.regionFont, 12);
	NWBDmfFrameStartLogoutButton.tooltip.fs:SetText("|CffDEDE42Start a |CFFFFA50020|CffDEDE42 second logout timer\nwith auto resurrection.\nTarget Sayge and spam interact keybind.\n(This requires using the website\nstuck helper while offline)");
	NWBDmfFrameStartLogoutButton.tooltip:SetWidth(NWBDmfFrameStartLogoutButton.tooltip.fs:GetStringWidth() + 18);
	NWBDmfFrameStartLogoutButton.tooltip:SetHeight(NWBDmfFrameStartLogoutButton.tooltip.fs:GetStringHeight() + 12);
	NWBDmfFrameStartLogoutButton:SetScript("OnEnter", function(self)
		NWBDmfFrameStartLogoutButton.tooltip:Show();
	end)
	NWBDmfFrameStartLogoutButton:SetScript("OnLeave", function(self)
		NWBDmfFrameStartLogoutButton.tooltip:Hide();
	end)
	NWBDmfFrameStartLogoutButton.tooltip:Hide();

	--Stop logout button.
	local NWBDmfFrameStopLogoutButton = CreateFrame("Button", "NWBDmfFrameStopLogoutButton", NWBDmfFrame, "UIPanelButtonTemplate, SecureActionButtonTemplate");
	local dmfStopLogoutMacro = [=[
	/run for i=1,STATICPOPUP_NUMDIALOGS do if _G["StaticPopup"..i].which=="CAMP" then _G["StaticPopup"..i.."Button1"]:Click() end end
	]=]
	NWBDmfFrameStopLogoutButton:SetAttribute("type", "macro");
	NWBDmfFrameStopLogoutButton:SetAttribute("macrotext", dmfStopLogoutMacro);
	NWBDmfFrameStopLogoutButton:SetPoint("BottomRight", -3, 3);
	NWBDmfFrameStopLogoutButton:SetWidth(120);
	NWBDmfFrameStopLogoutButton:SetHeight(30);
	--NWBDmfFrameStopLogoutButton:SetFrameLevel(141);
	NWBDmfFrameStopLogoutButton:SetText("Cancel");
	NWBDmfFrameStopLogoutButton:SetNormalFontObject("GameFontNormal");
	local lastDmfLogoutStopClick = 0;
	NWBDmfFrameStopLogoutButton:SetScript("OnMouseDown", function(self, arg)
		lastDmfLogoutStopClick = GetTime();
	end)
	NWBDmfFrameStopLogoutButton:Hide();

	--Interact keybind button.
	local NWBChangeInteractKeybindButton = CreateFrame("Button", "NWBChangeInteractKeybindButton", NWBDmfFrame, "UIPanelButtonTemplate");
	--NWBChangeInteractKeybindButton:SetPoint("TopLeft", 28, -85);
	NWBChangeInteractKeybindButton:SetPoint("TOP", 0, -95);
	NWBChangeInteractKeybindButton:SetWidth(120);
	NWBChangeInteractKeybindButton:SetHeight(20);
	NWBChangeInteractKeybindButton:SetText("Change Keybind");
	NWBChangeInteractKeybindButton:SetNormalFontObject("GameFontNormalSmall");
	NWBChangeInteractKeybindButton:SetScript("OnClick", function(self, arg)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
		KeyBindingFrame_LoadUI();
		KeyBindingFrame.mode = 1;
		ShowUIPanel(KeyBindingFrame);
		--Go to the targeting category.
		KeyBindingFrameCategoryListButton5:Click();
		KeyBindingFrameScrollFrame.ScrollBar:SetValue(999);
		for i = 1, 20 do
			if (_G["KeyBindingFrameKeyBinding" .. i] and _G["KeyBindingFrameKeyBinding" .. i].description
					and _G["KeyBindingFrameKeyBinding" .. i].description:GetText() == "Interact With Target") then
				_G["KeyBindingFrameKeyBinding" .. i].description:SetText("Interact With Target  |CFFFFFFFF<- HERE");
			end
		end
	end)
	NWBChangeInteractKeybindButton.tooltip = CreateFrame("Frame", "NWBChangeInteractKeybindButtonTooltip", NWBChangeInteractKeybindButton, "TooltipBorderedFrameTemplate");
	NWBChangeInteractKeybindButton.tooltip:SetPoint("CENTER", NWBChangeInteractKeybindButton, "CENTER", 0, -40);
	NWBChangeInteractKeybindButton.tooltip:SetFrameStrata("TOOLTIP");
	NWBChangeInteractKeybindButton.tooltip:SetFrameLevel(140);
	NWBChangeInteractKeybindButton.tooltip.fs = NWBChangeInteractKeybindButton.tooltip:CreateFontString("NWBChangeInteractKeybindButtonTooltipFS", "ARTWORK");
	NWBChangeInteractKeybindButton.tooltip.fs:SetPoint("CENTER", 0, 0);
	NWBChangeInteractKeybindButton.tooltip.fs:SetFont(NWB.regionFont, 12);
	NWBChangeInteractKeybindButton.tooltip.fs:SetText("|CffDEDE42Opens the keybinds menu.\nKeybinds -> Targeting -> Interact With Target");
	NWBChangeInteractKeybindButton.tooltip:SetWidth(NWBChangeInteractKeybindButton.tooltip.fs:GetStringWidth() + 18);
	NWBChangeInteractKeybindButton.tooltip:SetHeight(NWBChangeInteractKeybindButton.tooltip.fs:GetStringHeight() + 12);
	NWBChangeInteractKeybindButton:SetScript("OnEnter", function(self)
		NWBChangeInteractKeybindButton.tooltip:Show();
	end)
	NWBChangeInteractKeybindButton:SetScript("OnLeave", function(self)
		NWBChangeInteractKeybindButton.tooltip:Hide();
	end)
	NWBChangeInteractKeybindButton.tooltip:Hide();

	function NWB:createDmfHelperButtons()
		if (not NWB.dmfChatCountdown) then
			NWB.dmfChatCountdown = CreateFrame("CheckButton", "NWBDMFChatCountdown", NWBDmfFrame, "ChatConfigCheckButtonTemplate");
			NWB.dmfChatCountdown:SetPoint("BOTTOMLEFT", 30, 120);
			NWBDMFChatCountdownText:SetText("Group Chat Countdown");
			NWB.dmfChatCountdown.tooltip = "Countdown the seconds left until resurrection in party/raid chat? This is for friends helping you by ressing first to take some hits.";
			--NWB.dmfChatCountdown:SetFrameStrata("HIGH");
			NWB.dmfChatCountdown:SetFrameLevel(132);
			NWB.dmfChatCountdown:SetWidth(24);
			NWB.dmfChatCountdown:SetHeight(24);
			NWB.dmfChatCountdown:SetChecked(NWB.db.global.dmfChatCountdown);
			NWB.dmfChatCountdown:SetScript("OnClick", function()
				local value = NWB.dmfChatCountdown:GetChecked();
				NWB.db.global.dmfChatCountdown = value;
			end)
			NWB.dmfChatCountdown:SetHitRectInsets(0, 0, -10, 7);
		end
		if (not NWB.dmfAutoResButton) then
			NWB.dmfAutoResButton = CreateFrame("CheckButton", "NWBDMFAutoResButton", NWBDmfFrame, "ChatConfigCheckButtonTemplate");
			NWB.dmfAutoResButton:SetPoint("BOTTOMLEFT", 30, 88);
			NWBDMFAutoResButtonText:SetText("Auto Resurrect");
			NWB.dmfAutoResButton.tooltip = "Auto accept resurrect right before you logout/stuck?\nSet how many seconds before the timer ends to res below.";
			--NWB.dmfAutoResButton:SetFrameStrata("HIGH");
			--NWB.dmfAutoResButton:SetFrameLevel(3);
			NWB.dmfAutoResButton:SetWidth(24);
			NWB.dmfAutoResButton:SetHeight(24);
			NWB.dmfAutoResButton:SetChecked(NWB.db.global.dmfAutoRes);
			NWB.dmfAutoResButton:SetScript("OnClick", function()
				local value = NWB.dmfAutoResButton:GetChecked();
				NWB.db.global.dmfAutoRes = value;
			end)
			NWB.dmfAutoResButton:SetHitRectInsets(0, 0, -10, 7);
		end
		if (not NWB.dmfAutoResSlider) then
			NWB.dmfAutoResSlider = CreateFrame("Slider", "NWBDMFAutoResSlider", NWBDmfFrame, "OptionsSliderTemplate");
			NWB.dmfAutoResSlider:SetPoint("BOTTOM", 0, 50);
			NWBDMFAutoResSliderText:SetText("Auto Resurrect Seconds Left");
			NWB.dmfAutoResSlider.tooltipText = "How many seconds left on logout/stuck will we auto resurrect at?";
			--NWB.dmfAutoResSlider:SetFrameStrata("HIGH");
			--NWB.dmfAutoResSlider:SetFrameLevel(5);
			NWB.dmfAutoResSlider:SetWidth(180);
			NWB.dmfAutoResSlider:SetHeight(16);
			NWB.dmfAutoResSlider:SetMinMaxValues(1, 5);
			NWB.dmfAutoResSlider:SetObeyStepOnDrag(true);
			NWB.dmfAutoResSlider:SetValueStep(0.5);
			NWB.dmfAutoResSlider:SetStepsPerPage(0.5);
			NWB.dmfAutoResSlider:SetValue(NWB.db.global.dmfAutoResTime);
			NWBDMFAutoResSliderLow:SetText("1");
			NWBDMFAutoResSliderHigh:SetText("5");
			NWBDMFAutoResSlider:HookScript("OnValueChanged", function(self, value)
				NWB.db.global.dmfAutoResTime = value;
				NWB.dmfAutoResSlider.editBox:SetText(value);
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
					NWB.db.global.dmfAutoResTime = value;
					NWB.dmfAutoResSlider:SetValue(value);
					frame:ClearFocus();
				else
					--If not a valid number reset the box.
					NWB.dmfAutoResSlider.editBox:SetText(NWB.db.global.dmfAutoResTime);
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
			NWB.dmfAutoResSlider.editBox = CreateFrame("EditBox", nil, NWB.dmfAutoResSlider, NWB:addBackdrop());
			NWB.dmfAutoResSlider.editBox:SetAutoFocus(false);
			NWB.dmfAutoResSlider.editBox:SetFontObject(GameFontHighlightSmall);
			NWB.dmfAutoResSlider.editBox:SetPoint("TOP", NWB.dmfAutoResSlider, "BOTTOM");
			NWB.dmfAutoResSlider.editBox:SetHeight(14);
			NWB.dmfAutoResSlider.editBox:SetWidth(40);
			NWB.dmfAutoResSlider.editBox:SetJustifyH("CENTER");
			NWB.dmfAutoResSlider.editBox:EnableMouse(true);
			NWB.dmfAutoResSlider.editBox:SetBackdrop(ManualBackdrop);
			NWB.dmfAutoResSlider.editBox:SetBackdropColor(0, 0, 0, 0.5);
			NWB.dmfAutoResSlider.editBox:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80);
			NWB.dmfAutoResSlider.editBox:SetScript("OnEnter", EditBox_OnEnter);
			NWB.dmfAutoResSlider.editBox:SetScript("OnLeave", EditBox_OnLeave);
			NWB.dmfAutoResSlider.editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed);
			NWB.dmfAutoResSlider.editBox:SetScript("OnEscapePressed", EditBox_OnEscapePressed);
			NWB.dmfAutoResSlider.editBox:SetText(NWB.db.global.dmfAutoResTime);
		end
	end

	NWBDmfFrame:SetScript("OnShow", function(self)
		NWB:updateInteractBindText();
		NWB:createDmfHelperButtons();
		NWBDmfFrameStartLogoutButton:Show();
		NWBDmfFrameStopLogoutButton:Hide();
		NWBDmfFrameStartStuckButton:Show();
		NWBDmfFrameStopStuckButton:Hide();
	end)

	local doDmfScan = false;
	local f = CreateFrame("Frame");
	local lastDmfPoisChange = 0;
	local lastDmfPoisZone;
	local scanCheckEnabled;
	local dmfStuckResTimer, dmfLogoutResTimer, dmfChatTimer;
	local dmfChatTickerCount = 0;
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:RegisterEvent("AREA_POIS_UPDATED");
	f:RegisterEvent("UNIT_SPELLCAST_START");
	f:RegisterEvent("UNIT_SPELLCAST_STOP");
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	f:RegisterEvent("PLAYER_CAMPING");
	f:RegisterEvent("UPDATE_BINDINGS");
	f:RegisterEvent("PLAYER_UNGHOST");
	f:SetScript("OnEvent", function(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD" or event == "AREA_POIS_UPDATED") then
			--Must use GetServerTime() and not GetTime() for logon or its unreliable.
			lastDmfPoisChange = GetServerTime();
			local subZone = GetSubZoneText();
			local _, _, zone = NWB:GetPlayerZonePosition();
			if (NWB.isDmfUp and NWB:verifyDmfZone() and not doDmfScan) then
				NWB:debug("Starting DMF scan.");
				doDmfScan = true;
				NWB:dmfPosTicker();
			elseif (doDmfScan and (not NWB.isDmfUp or not zone)) then
				doDmfScan = false;
			end
			lastDmfPoisZone = subZone;
		elseif (event == "UNIT_SPELLCAST_START") then
			local unit, _, spellID = ...;
			if (unit == "player" and spellID == 7355 and (GetTime() - lastDmfStuckStartClick) < 10) then
				if (UnitIsGhost("player")) then
					local stuckTime = 10;
					local duration = stuckTime - NWB.db.global.dmfAutoResTime;
					if (NWB.db.global.dmfAutoRes) then
						NWB:print("Target Sayge and spam press your Interact With Target keybind now, resurrection in " .. duration ..  " seconds.");
						dmfStuckResTimer = C_Timer.NewTimer(duration, function()
							RetrieveCorpse();
						end)
						dmfChatTickerCount = math.floor(duration);
						dmfChatTimer = C_Timer.NewTicker(1, function()
							NWB:dmfChatTicker();
						end, math.floor(duration))
						if (NWB.db.global.dmfChatCountdown) then
							NWB:dmfSendGroup("Starting resurrection countdown.");
						end
						dmfTimerBar = NWB:createTimerBar(NWBDmfFrame:GetWidth(), 30, duration, "Resurrection");
						dmfTimerBar:SetPoint("TOP", NWBDmfFrame, "BOTTOM", 0, 0);
						dmfTimerBar:SetFill(true);
						dmfTimerBar:SetColor(255, 165, 0);
						dmfTimerBar:Start();
						NWBDmfFrameStartStuckButton:Hide();
						NWBDmfFrameStopStuckButton:Show();
					else
						NWB:print("Stuck started (Auto resurrection disabled).");
					end
				else
					NWB:print("You must be a ghost to use this.");
				end
			end
		elseif (event == "UNIT_SPELLCAST_STOP") then
			local unit, _, spellID = ...;
			if (unit == "player" and spellID == 7355 and dmfStuckResTimer) then
				NWB:debug("cancelled res timer")
				if (dmfStuckResTimer._remainingIterations and dmfStuckResTimer._remainingIterations > 0) then
					if (NWB.db.global.dmfChatCountdown) then
						NWB:dmfSendGroup("Cancelled resurrection countdown.");
					else
						NWB:print("Cancelled resurrection countdown.");
					end
				end
				dmfStuckResTimer:Cancel();
				dmfChatTimer:Cancel();
				dmfLogoutResTimer = nil;
				dmfChatTimer = nil;
				if (dmfTimerBar) then
					dmfTimerBar:Stop();
					dmfTimerBar = nil;
				end
				NWBDmfFrameStartStuckButton:Show();
				NWBDmfFrameStopStuckButton:Hide();
			end
		elseif (event == "PLAYER_CAMPING") then
			if (GetTime() - lastDmfLogoutStartClick < 10) then
				if (UnitIsGhost("player")) then
					local logoutTime = 20;
					local duration = logoutTime - NWB.db.global.dmfAutoResTime;
					if (NWB.db.global.dmfAutoRes) then
						NWB:print("Target Sayge and spam press your Interact With Target keybind now, resurrection in " .. duration ..  " seconds.");
						dmfLogoutResTimer = C_Timer.NewTimer(duration, function()
							RetrieveCorpse();
						end)
						dmfChatTickerCount = math.floor(duration);
						dmfChatTimer = C_Timer.NewTicker(1, function()
							NWB:dmfChatTicker();
						end, math.floor(duration))
						if (NWB.db.global.dmfChatCountdown) then
							NWB:dmfSendGroup("Starting resurrection countdown.");
						end
						dmfTimerBar = NWB:createTimerBar(NWBDmfFrame:GetWidth(), 30, duration, "Resurrection");
						dmfTimerBar:SetPoint("TOP", NWBDmfFrame, "BOTTOM", 0, 0);
						dmfTimerBar:SetFill(true);
						dmfTimerBar:SetColor(255, 165, 0);
						dmfTimerBar:Start();
						NWBDmfFrameStartLogoutButton:Hide();
						NWBDmfFrameStopLogoutButton:Show();
						--NWBDmfFrameStartStuckButton:Hide();
						--NWBDmfFrameStopStuckButton:Show();
					else
						NWB:print("Logout started (Auto resurrection disabled).");
					end
				else
					NWB:print("You must be a ghost to use this.");
				end
			end
		elseif (event == "UPDATE_BINDINGS") then
			NWB:updateInteractBindText();
		elseif (event == "PLAYER_UNGHOST") then
			local _, _, zone = NWB:GetPlayerZonePosition();
			if (NWB:verifyDmfZone()) then
				NWBDmfFrameStartLogoutButton:Show();
				NWBDmfFrameStopLogoutButton:Hide();
				--NWBDmfFrameStartStuckButton:Show();
				--NWBDmfFrameStopStuckButton:Hide();
			end
		end
	end)

	function NWB:createTimerBar(width, height, duration, label)
		local bar = NWB.candyBar:New("Interface\\RaidFrame\\Raid-Bar-Hp-Fill", width, height);
		bar:SetLabel(label);
		bar:SetDuration(duration);
		return bar;
	end

	function NWB.cancelLogout()
		if (dmfLogoutResTimer) then
			dmfLogoutResTimer:Cancel();
			dmfChatTimer:Cancel();
			dmfLogoutResTimer = nil;
			dmfChatTimer = nil;
			NWBDmfFrameStartLogoutButton:Show();
			NWBDmfFrameStopLogoutButton:Hide();
			--NWBDmfFrameStartStuckButton:Show();
			--NWBDmfFrameStopStuckButton:Hide();
			if (NWB.db.global.dmfChatCountdown) then
				NWB:dmfSendGroup("Cancelled resurrection countdown.");
			else
				NWB:print("Cancelled resurrection countdown.");
			end
			if (dmfTimerBar) then
				dmfTimerBar:Stop();
				dmfTimerBar = nil;
			end
			NWBDmfFrameStopLogoutButton:Hide();
		end
	end

	hooksecurefunc("CancelLogout", NWB.cancelLogout);

	function NWB:dmfChatTicker(first)
		dmfChatTickerCount = dmfChatTickerCount - 1;
		if (NWB.db.global.dmfChatCountdown and NWB.db.global.dmfAutoRes) then
			if (dmfChatTickerCount == 10) then
				NWB:dmfSendGroup("Resurrection in 10 seconds.");
			elseif (dmfChatTickerCount == 5) then
				NWB:dmfSendGroup("Resurrection in 5 seconds.");
			elseif (dmfChatTickerCount == 4) then
				NWB:dmfSendGroup("Resurrection in 4 seconds.");
			elseif (dmfChatTickerCount == 3) then
				NWB:dmfSendGroup("Resurrection in 3 seconds.");
			elseif (dmfChatTickerCount == 2) then
				NWB:dmfSendGroup("Resurrection in 2 seconds.");
			elseif (dmfChatTickerCount == 1) then
				NWB:dmfSendGroup("Resurrection in 1 second.");
			elseif (dmfChatTickerCount == 0) then
				NWB:dmfSendGroup("Resurrecting Now!");
			end
		end
	end

	function NWB:dmfSendGroup(msg)
		if (IsInRaid()) then
			SendChatMessage(msg, "RAID");
		elseif (IsInGroup()) then
			SendChatMessage(msg, "PARTY");
		end
	end

	function NWB:verifyDmfZone()
		local _, _, zone = NWB:GetPlayerZonePosition();
		if ((zone == 1429 and NWB.faction == "Horde") or (zone == 1412 and NWB.faction == "Alliance")) then
			return true;
		end
	end

	function NWB:verifyDmfPos()
		--English only for starters while testing.
		if (not LOCALE_enUS and not LOCALE_enGB) then
			return;
		end
		if (not UnitIsGhost("player")) then
			return;
		end
		if (NWB.faction == "Horde") then
			local x, y, zone = NWB:GetPlayerZonePosition();
			--Only works within a square around Goldshire DMF.
			if (zone ~= 1429 or (y > 0.69853476638874 or y < 0.6824626793253
					or x > 0.42938295086608 or x < 0.41670588083958)) then
				return;
			end
		elseif (NWB.faction == "Alliance") then
			--Only works within a square around Mulgore DMF.
			local x, y, zone = NWB:GetPlayerZonePosition();
			if (zone ~= 1412 or (y > 0.394447705692 or y < 0.37847691674407
					or x > 0.37333657662182 or x < 0.36484996019735)) then
				return;
			end
		end
		return true;
	end

	function NWB:dmfPosTicker()
		if (not doDmfScan or not NWB:verifyDmfZone()) then
			NWB:debug("Stopping DMF scan.");
			NWB:disableDmfFrame();
			clickedDmfFrameClose = nil;
			return;
		end
		if (NWB:verifyDmfPos()) then
			NWB:enableDmfFrame();
		else
			NWB:disableDmfFrame();
		end
		C_Timer.After(1, function()
			NWB:dmfPosTicker();
		end)
	end

	SLASH_NWBDMFHELPERCMD1, SLASH_NWBDMFHELPERCMD2 = '/dmfhelper', '/stuckhelper';
	function SlashCmdList.NWBDMFHELPERCMD(msg, editBox)
		NWBDmfFrame:Show();
	end

	function NWB:enableDmfFrame()
		local pvpType = GetZonePVPInfo();
		if (not UnitIsGhost("player") or not NWB.db.global.dmfFrame or pvpType ~= "hostile") then
			return;
		end
		if (NWB.db.global.dmfFrame and not NWBDmfFrame:IsShown() and not clickedDmfFrameClose) then
			NWBDmfFrame:Show();
			NWB:debug("Showing DMF frame.");
		end
	end

	function NWB:disableDmfFrame()
		clickedDmfFrameClose = nil;
		if (NWBDmfFrame:IsShown()) then
			NWBDmfFrame:Hide();
			NWB:debug("Hiding DMF frame.");
		end
	end
end