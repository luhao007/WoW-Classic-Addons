-------------------
---NovaWorldBuffs--
-------------------

--Just starting to bring things over to this module, next step will be changing everything to spellIDs now they've been added to era.
--This is only half done and a huge mess atm.

local addonName, addon = ...;
local NWB = addon.a;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
local rendDropMsg, onyDropMsg, nefDropMsg = 0, 0, 0;
NWB.firstYells = {rend = 0, ony = 0, nef = 0, zan = 0}; --Npc yells, shared guild cooldown.
NWB.buffDrops = {rend = 0, ony = 0, nef = 0, zan = 0}; --Full duration buff applications, personal cooldown.
NWB.lastSets = {rend = 0, ony = 0, nef = 0, zan = 0}; --Buff drops actual being set in the addon, if it meets all checks after buff applications.

--5 second leeway for funcs sharing the same cooldown, this is for buff drops that have a 1 minute server cooldown anyway.
local function isOnCooldown(cooldownType, type)
	if (NWB[cooldownType] and (GetServerTime() - NWB[cooldownType][type] < NWB.buffDropSpamCooldown - 5)) then
		return true;
	end
end

--Adding a central place to control whether an event should fire, things are changing a lot recently in classic with buff cooldowns etc and this just make it easier to change things in one place.
function NWB:checkEventStatus(event, type, subEvent, channel)
	if (event == subEvent) then
		--Just incase I'm writing code half asleep one day...
		NWB:debug("ERROR: NWB:checkEventStatus() events could cause an endless loop. (" .. event .. ")");
		return;
	end
	local doAction;
	--All events attached to a buff type.
	--[[if (type == "rend") then
		--No matching atm.
	elseif (type == "ony") then
		--No matching atm.
	elseif (type == "nef") then
		--No matching atm.
	elseif (type == "zan") then
		--No matching atm.
	end]]
	--Other specific events.
	--NWB:debug("event check", event, type, subEvent, channel);
	if (event == "sendGuildMsg") then
		--NWB:debug("guild msg check", type, subEvent, channel);
		--Blanket match all guild chat events attached to a buff type.
		if (type == "rend") then
			if (NWB.isSOD) then --No rend msgs in sod it's been too spammy since the cooldown was removed.
				return;
			else
				return true;
			end
		elseif (type == "ony") then
			return true;
		elseif (type == "nef") then
			return true;
		elseif (type == "zan") then
			return true;
		end
		--Some of these guild msgs basically match the event types below that would send a guild msg.
		--This is so the sender can ignore those events ineeded even if the player that saw the event isn;t up to date with the addon version.
		--type here can also be used to pass a an extra arg for the "sendGuildMsg" event.
		if (subEvent == "timer1" or subEvent == "timer10") then
			return NWB:checkEventStatus("guildTimerMsg", type);
		elseif (subEvent == "guildCommand") then
			if (type == "!wb") then
				return true;
			elseif (type == "!dmf") then
				return true;
			else
				return true;
			end
		elseif (subEvent == "songflower") then
			return NWB:checkEventStatus(subEvent, type);
		elseif (subEvent == "guildNpcWalking") then
			return NWB:checkEventStatus(subEvent, type);
		elseif (subEvent == "firstYell") then
			return NWB:checkEventStatus(subEvent, type);
		elseif (subEvent == "guildNpcDialogue") then
			--Guild chat msg.
			--return NWB:checkEventStatus("firstYell", type);
		else
			return true;
		end
	elseif (event == "firstYell") then
		--When a buff is handed in and the NPC does it's first yell warning of a drop inc.
		if (NWB.isSOD and channel == "guild" and type == "rend") then
			--Disable rend guild msgs in SoD.
			return;
		end
		if (not isOnCooldown("firstYells", type)) then
			NWB.firstYells[type] = GetServerTime();
			return true;
		else
			return;
		end
	elseif (event == "buffDropMsg") then
		--When a buff actually drops.
		if (NWB.isSOD and channel == "guild" and type == "rend") then
			--Disable rend guild msgs in SoD.
			return;
		end
		if (not isOnCooldown("buffDrops", type)) then
			--NWB.buffDrops[type] = GetServerTime(); --Set in the drop func below.
			return true;
		else
			return;
		end
	elseif (event == "guildTimerMsg") then
		--Guild chat msg of x minutes left on cooldown.
		return true;
	elseif (event == "guildNpcWalking") then
		--Guild chat msg of x minutes left on cooldown.
		return true;
	elseif (event == "npcRespawnMsg") then
		return true;
	elseif (event == "songFlower") then
		return true;
	elseif (event == "startFlash") then
		if (NWB.isSOD and type == "rend") then --No rend flashes outside city in sod, there's also seperate setting in the flash func for all flashes in city only.
			if (NWB:isCapitalCityAction("rend")) then
				return true;
			else
				return;
			end
		end
		return true;
	elseif (event == "playSound") then
		if (NWB.isSOD and type == "rend" and subEvent == "soundsFirstYell") then
			return;
		end
		--These are checked in thier parent functions atm, like yell/buff drop etc.
		return true;
	else
		return true;
	end
end

NWB.lastHeraldYell = 0;
local buffDrops = {};
local function monsterYell(...)
	local layerNum;
	if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
			and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
		layerNum = NWB.lastKnownLayer;
	end
	--Skip strict string matching yell msgs for regions we haven't localized yet.
	--This could result in less accurate timers but better than no timers at all.
	local locale = GetLocale();
	local skipStringCheck;
	if (NWB.faction == "Horde") then
		if (locale == "ptBR" or locale == "esES" or locale == "esMX" or locale == "itIT") then
			skipStringCheck = true;
		end
	end
	if (NWB.faction == "Alliance") then
		if (locale == "ptBR" or locale == "esES" or locale == "esMX" or locale == "itIT"
				or locale == "zhCN") then
			skipStringCheck = true;
		end
	end
	local msg, name = ...;
	if (name == L["Field Marshal Stonebridge"]) then
		--Don't check yell string matches for the new NPC.
		--Any yell will do for now to set a timestamp until languages are done properly.
		
		skipStringCheck = true;
	end
	--if ((name == L["Thrall"] or (name == L["Herald of Thrall"] and (not NWB.isLayered or NWB.faction == "Alliance")))
	if ((name == L["Thrall"] or name == L["Herald of Thrall"])
			and (string.match(msg, L["Rend Blackhand, has fallen"]) or skipStringCheck)) then
		--6 seconds between first rend yell and buff applied.
		NWB.data.rendYell = GetServerTime();
		NWB:doFirstYell("rend", layerNum);
		--Send first yell msg to guild so people in org see it, needed because 1 person online only will send msg.
		local _, _, zone = NWB:GetPlayerZonePosition();
		NWB:sendYell("GUILD", "rend", nil, layerNum);
		if  (name == L["Herald of Thrall"]) then
			--If it was herald we may we in the barrens but not in crossraods to receive buff, set buff timer.
			if (not NWB.isLayered) then
				C_Timer.After(5, function()
					NWB:setRendBuff("self", UnitName("player"));
				end)
			--[[elseif (NWB.isLayered and zone == 1413 and NWB.faction == "Alliance") then
				--Testing tracking rend for alliance here by attaching it to the new layermap.
				if (NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0) then
					C_Timer.After(5, function()
						NWB:setRendBuff("self", UnitName("player"), NWB.lastKnownLayerMapID, nil, true);
					end)
				end]]
			end
		end
		if (NWB.isLayered and (zone == 1454 or zone == 1413) and NWB.faction == "Alliance") then
			--Testing tracking rend for alliance here by attaching it to the layermap.
			if (NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0) then
				C_Timer.After(5, function()
					NWB:setRendBuff("self", UnitName("player"), NWB.lastKnownLayerMapID, nil, true);
				end)
			end
		end
		if (tonumber(NWB.rendHandIn) and NWB.rendHandInTime > (GetServerTime() - 20)) then
			NWB:timerLog("q", GetServerTime(), NWB.rendHandIn, UnitName("player"));
			NWB:sendTimerLogData("YELL");
			NWB.rendHandIn = nil
			NWB.rendHandInTime = 0;
			--Send it again hopefully after they left Thrall room and are near more people.
			C_Timer.After(120, function()
				NWB:sendTimerLogData("YELL");
			end)
		end
		if (name == L["Herald of Thrall"]) then
			NWB:heraldYell();
		end
	elseif ((name == L["Thrall"] or (name == L["Herald of Thrall"] and (not NWB.isLayered or NWB.faction == "Alliance")))
			and string.match(msg, L["Be bathed in my power"])) then
		--Second yell right before drops "Be bathed in my power! Drink in my might! Battle for the glory of the Horde!".
		NWB.data.rendYell2 = GetServerTime();
		if (tonumber(NWB.rendHandIn) and NWB.rendHandInTime > (GetServerTime() - 20)) then
			NWB:timerLog("q", GetServerTime(), NWB.rendHandIn, UnitName("player"));
			NWB:sendTimerLogData("YELL");
			NWB.rendHandIn = nil
			NWB.rendHandInTime = 0;
			--Send it again hopefully after they left Thrall room and are near more people.
			C_Timer.After(120, function()
				NWB:sendTimerLogData("YELL");
			end)
		end
	elseif ((NWB.faction == "Horde" and name == L["Overlord Runthak"] and (string.match(msg, L["Onyxia, has been slain"]) or skipStringCheck))
			or (NWB.faction == "Alliance" and name == L["Major Mattingly"]
			and (string.match(msg, L["history has been made"]) or skipStringCheck))) then
		--14 seconds between first ony yell and buff applied.
		NWB.data.onyYell = GetServerTime();
		NWB:doFirstYell("ony", layerNum);
		--Send first yell msg to guild so people in org see it, needed because 1 person online only will send msg.
		NWB:sendYell("GUILD", "ony", nil, layerNum);
	elseif ((NWB.faction == "Horde" and name == L["Overlord Runthak"] and string.match(msg, L["Be lifted by the rallying cry"]))
			or (NWB.faction == "Alliance" and name == L["Major Mattingly"]
			and string.match(msg, L["Onyxia, hangs from the arches"]))) then
		--Second yell right before drops "Be lifted by the rallying cry of your dragon slayers".
		NWB.data.onyYell2 = GetServerTime();
	elseif ((NWB.faction == "Horde" and name == L["High Overlord Saurfang"] and (string.match(msg, L["NEFARIAN IS SLAIN"]) or skipStringCheck))
		 	or (NWB.faction == "Alliance" and (name == L["Field Marshal Afrasiabi"] or name == L["Field Marshal Stonebridge"])
		 	and (string.match(msg, L["the Lord of Blackrock is slain"]) or skipStringCheck))) then
		--15 seconds between first nef yell and buff applied.
		NWB.data.nefYell = GetServerTime();
		NWB:doFirstYell("nef", layerNum);
		--Send first yell msg to guild so people in org see it, needed because 1 person online only will send msg.
		NWB:sendYell("GUILD", "nef", nil, layerNum);
	elseif ((NWB.faction == "Horde" and name == L["High Overlord Saurfang"] and string.match(msg, L["Revel in his rallying cry"]))
			or (NWB.faction == "Alliance" and (name == L["Field Marshal Afrasiabi"] or name == L["Field Marshal Stonebridge"])
			and string.match(msg, L["Revel in the rallying cry"]))) then
		--Second yell right before drops "Be lifted by PlayerName's accomplishment! Revel in his rallying cry!".
		NWB.data.nefYell2 = GetServerTime();
	elseif ((name == L["Molthor"] or name == L["Zandalarian Emissary"])
			and (string.match(msg, L["Begin the ritual"]) or string.match(msg, L["The Blood God"]) or skipStringCheck)) then
		if (string.match(msg, L["Temple of Atal'Hakkar"])) then
			--They reused the same NPC and drop msg as ZF buff in SoD for the Sunken Temple buff.
			--So block it from announcing, 6 second drop time like the other buffs, no reason to announce.
			return;
		end
		--See the notes in NWB:doFirstYell() for exact buff drop timings info.
		--Booty Bay yell (Zandalarian Emissary yells: The Blood God, the Soulflayer, has been defeated!  We are imperiled no longer!)
		NWB.data.zanYell = GetServerTime();
		local delay;
		if (name == L["Zandalarian Emissary"]) then
			delay = "50";
		end
		NWB:doFirstYell("zan", layerNum, nil, nil, delay);
		NWB:sendYell("GUILD", "zan", nil, layerNum, delay);
		if (IsInRaid()) then
			NWB:sendYell("RAID", "zan", nil, layerNum, delay);
		elseif (IsInGroup()) then
			NWB:sendYell("PARTY", "zan", nil, layerNum, delay);
		end
	elseif ((name == L["Molthor"] or name == L["Zandalarian Emissary"]) and string.match(msg, L["slayer of Hakkar"])) then
		if (string.match(msg, L["Temple of Atal'Hakkar"])) then
			--They reused the same NPC and drop msg as ZF buff in SoD for the Sunken Temple buff.
			--So block it from announcing, 6 second drop time like the other buffs, no reason to announce.
			return;
		end
		--Second yell right before drops "All Hail <name>, slayer of Hakkar, and hero of Azeroth!".
		--Booty Bay yell (Zandalarian Emissary yells: All Hail <name>, slayer of Hakkar, and hero of Azeroth!)
		NWB.data.zanYell2 = GetServerTime();
	elseif ((NWB.faction == "Horde" and name == L["Nazgrel"] and string.match(msg, L["Hellfire Citadel is ours"]))
			or (NWB.faction == "Alliance" and name == L["Force Commander Danath Trollbane"]
			and string.match(msg, L["The feast of corruption is no more"]))) then
		--NWB:debug(...)
		if (NWB.isLayered) then
			local layer, layerNum;
			if (NWB.isLayered and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layer = NWB.lastKnownLayerMapID;
				layerNum = NWB.lastKnownLayer;
			end
			if (not layer or layer == 0) then
				layer = NWB.lastKnownLayerMapIDBackup;
			end
			if (layer and layer > 0) then
				NWB.data.layers[layer].hellfireRep = GetServerTime();
			end
		else
			NWB.data.hellfireRep = GetServerTime();
		end
	--elseif ((name == L["Dawnwatcher Selgorm"] or name == L["Bashana Runetotem"]) and string.match(msg, L["the dread beast Aku'mai has been slain"])) then
		--SoD Darnassus npc.
		--print("darn yell", GetServerTime())
		--This turned out to be only 6 seconds warning, probably not worth adding the yell to guild chat?
	end
end

local function monsterSay(...)
	local layerNum;
	if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
			and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
		layerNum = NWB.lastKnownLayer;
	end
	local msg, name = ...;
	--See the notes in NWB:doFirstYell() for exact buff drop timings info.
	--No need for a string check here, npc only ever says one thing in /say and it's the buff drop.
	--if (name == L["Molthor"] and string.match(msg, L["only one step remains to rid us"])) then
	if (name == L["Molthor"]) then
		NWB.data.zanYell = GetServerTime();
		local delay = "50";
		NWB:doFirstYell("zan", layerNum, nil, nil, delay);
		NWB:sendYell("GUILD", "zan", nil, layerNum, delay);
		if (IsInRaid()) then
			NWB:sendYell("RAID", "zan", nil, layerNum, delay);
		elseif (IsInGroup()) then
			NWB:sendYell("PARTY", "zan", nil, layerNum, delay);
		end
	end
end

--Buffs seem to have changed yet again, they no longer land with full duration.
--Now buffs are missing the lag duration from drop to land depending on aount of people in city.
--Basically is lands missing 10 or so seconds on my realm.
local yellOneOffset = 30;
local yellTwoOffset = 30;
local buffLag, dl1, dl2 = 15;
NWB.lastZanBuffGained = 0;
NWB.lastDmfBuffGained = 0;
NWB.lastHeraldAlert = 0;
--local speedtest = 0;
local lastRendHandIn, lastOnyHandIn, lastNefHandIn, lastZanHandIn = 0, 0, 0, 0;
NWB.lastBlackfathomBoon = 0;
NWB.lastSparkOfInspiration = 0;
NWB.lastFervorTempleExplorer = 0;
NWB.lastMightOfStormwind = 0;
local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, spellID, spellName = CombatLogGetCurrentEventInfo();
	if (subEvent == "UNIT_DIED") then
		local _, _, zone = NWB:GetPlayerZonePosition();
		local _, _, _, _, zoneID, npcID = strsplit("-", destGUID);
		zoneID = tonumber(zoneID);
		if ((zone == 1454 or zone == 1411) and destName == L["Overlord Runthak"] and NWB.faction == "Horde") then
			local layerNum;
			if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layerNum = NWB.lastKnownLayer;
			end
			--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
			zoneID = NWB:mapLayerToParent(zoneID);
			if (NWB.isLayered and not zoneID) then
				return;
			end
			if (NWB.isLayered and zoneID and NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].onyNpcDied = GetServerTime();
			end
			NWB.data.onyNpcDied = GetServerTime();
			dl1 = GetServerTime();
			NWB:doNpcKilledMsg("ony", layerNum);
			NWB:sendNpcKilled("GUILD", "ony", nil, layerNum);
			NWB:timerCleanup();
			C_Timer.After(1, function()
				NWB:sendData("GUILD");
				NWB:sendData("YELL"); --Yell is further than npc view range.
			end)
		elseif ((zone == 1454 or zone == 1411) and destName == L["High Overlord Saurfang"] and NWB.faction == "Horde") then
			local layerNum;
			if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layerNum = NWB.lastKnownLayer;
			end
			--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
			zoneID = NWB:mapLayerToParent(zoneID);
			if (NWB.isLayered and not zoneID) then
				return;
			end
			if (NWB.isLayered and zoneID and NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].nefNpcDied = GetServerTime();
			end
			NWB.data.nefNpcDied = GetServerTime();
			dl2 = GetServerTime();
			NWB:doNpcKilledMsg("nef", layerNum);
			NWB:sendNpcKilled("GUILD", "nef", nil, layerNum);
			NWB:timerCleanup();
			C_Timer.After(1, function()
				NWB:sendData("GUILD");
				NWB:sendData("YELL"); --Yell is further than npc view range.
			end)
		elseif ((zone == 1453 or zone == 1429) and destName == L["Major Mattingly"] and NWB.faction == "Alliance") then
			local layerNum;
			if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layerNum = NWB.lastKnownLayer;
			end
			--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
			zoneID = NWB:mapLayerToParent(zoneID);
			if (NWB.isLayered and not zoneID) then
				return;
			end
			if (NWB.isLayered and zoneID and NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].onyNpcDied = GetServerTime();
			end
			NWB.data.onyNpcDied = GetServerTime();
			dl1 = GetServerTime();
			NWB:doNpcKilledMsg("ony", layerNum);
			NWB:sendNpcKilled("GUILD", "ony", nil, layerNum);
			NWB:timerCleanup();
			C_Timer.After(1, function()
				NWB:sendData("GUILD");
				NWB:sendData("YELL"); --Yell is further than npc view range.
			end)
		elseif ((zone == 1453 or zone == 1429) and (destName == L["Field Marshal Afrasiabi"]
				or destName == L["Field Marshal Stonebridge"] or npcID == "14721") and NWB.faction == "Alliance") then
			local layerNum;
			if (NWB.isLayered and NWB:checkLayerCount() and NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0
					and NWB.lastKnownLayer and NWB.lastKnownLayer > 0) then
				layerNum = NWB.lastKnownLayer;
			end
			--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
			zoneID = NWB:mapLayerToParent(zoneID);
			if (NWB.isLayered and not zoneID) then
				return;
			end
			if (NWB.isLayered and zoneID and NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].nefNpcDied = GetServerTime();
			end
			NWB.data.nefNpcDied = GetServerTime();
			dl2 = GetServerTime();
			NWB:doNpcKilledMsg("nef", layerNum);
			NWB:sendNpcKilled("GUILD", "nef", nil, layerNum);
			NWB:timerCleanup();
			C_Timer.After(2, function()
				NWB:sendData("GUILD");
				NWB:sendData("YELL"); --Yell is further than npc view range.
			end)
		end
	elseif (subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH") then
		local unitType, _, _, _, zoneID, npcID = strsplit("-", sourceGUID);
		local destUnitType, _, _, _, destZoneID, destNpcID = strsplit("-", destGUID);
		zoneID = tonumber(zoneID);
		if (destName == UnitName("player")) then
			NWB:countDebuffs();
		end
		--[[if (NWB.isDebug) then
			local expirationTime = NWB:getBuffDuration(spellName);
			if (destName == UnitName("player") and (spellName == L["Rallying Cry of the Dragonslayer"] or spellName == L["Warchief's Blessing"])) then
				NWB:debug("buff", expirationTime, sourceGUID);
			end
			if (destName == UnitName("player") and spellName == L["Rallying Cry of the Dragonslayer"] and expirationTime >= (7199.5 - buffLag)) then
				NWB:debug("bufftest", spellName, unitType, zoneID, npcID, GetServerTime() - NWB.data.onyYell, expirationTime);
				NWB:debug("bufftest2 source", sourceGUID, "dest", destGUID);
				NWB:debug("ony yell", GetServerTime() - NWB.data.onyYell, "nef yell", GetServerTime() - NWB.data.nefYell);
			end
			if (destName == UnitName("player") and spellName == L["Warchief's Blessing"] and expirationTime >= (3599.5 - buffLag)) then
				NWB:debug("bufftest", spellName, unitType, zoneID, npcID, GetServerTime() - NWB.data.rendYell, expirationTime);
				NWB:debug("bufftest3 source", sourceGUID, "dest", destGUID);
				NWB:debug("rend yell", GetServerTime() - NWB.data.rendYell);
			end
		end]]
		if (destName == UnitName("player") and spellName == L["Warchief's Blessing"]) then
			--Getting duration fails if the target is mc'd.
			--Was this failing for the entirety of classic and I didn't know?
			--The backup set timer from the yell msgs was likely carrying the alliance rend timer.
			local expirationTime = NWB:getBuffDuration(L["Warchief's Blessing"], 1);
			local _, _, zone = NWB:GetPlayerZonePosition();
			--If layered then you must be in org to set the right layer id, the barrens is disabled.
			--if (expirationTime >= 3599.5 and (zone == 1454 or not NWB.isLayered) and unitType == "Creature") then
			--print(expirationTime, zone, unitType, NWB.data.rendYell, NWB.data.rendYell2, sourceGUID, destGUID, GetServerTime(), NWB.lastKnownLayerMapID)
			if (expirationTime >= (3599.5 - buffLag) and (zone == 1454 or (zone == 1413 and NWB.faction == "Alliance") or not NWB.isLayered) and unitType == "Creature"
					and ((GetServerTime() - NWB.data.rendYell2) < yellTwoOffset or (GetServerTime() - NWB.data.rendYell) < yellOneOffset)) then
				NWB:trackNewBuff(spellName, "rend", npcID);
				if (not NWB.buffDrops["rend"] or GetServerTime() - NWB.buffDrops["rend"] > NWB.buffDropSpamCooldown) then
					NWB:playSound("soundsRendDrop", "rend");
				end
				if (NWB.db.global.cityGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got Rend buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
				if (NWB.isLayered and zone ~= 1454) then
					--Testing tracking rend for alliance here by attaching it to the new layermap.
					if (NWB.lastKnownLayerMapID and NWB.lastKnownLayerMapID > 0) then
						if (NWB.faction == "Alliance") then
							NWB:setRendBuff("self", UnitName("player"), NWB.lastKnownLayerMapID, sourceGUID, true);
						end
					end
					return;
				end
				if (NWB.isLayered and (not npcID or npcID ~= "4949" or zone ~= 1454) and NWB.faction ~= "Alliance") then
					--Some parts on the edges of orgrimmar seem to give the buff from Herald instead of Thrall, even while on map 1454.
					--This creates a false 3rd layer with the barrens zoneid, took way too long to figure this out...
					NWB:debug("bad rend buff source on layered realm", sourceGUID);
					return;
				end
				if (NWB.isLayered and NWB.faction == "Alliance") then
					NWB:setRendBuff("self", UnitName("player"), zoneID, sourceGUID, true);
				else
					NWB:setRendBuff("self", UnitName("player"), zoneID, sourceGUID);
				end
				--NWB:debug("rend hand in delay", GetTime() - lastRendHandIn);
				--NWB:debug("rend herald found delay", GetServerTime() - NWB.lastHeraldAlert);
				--NWB:debug("rend herald yell delay", GetServerTime() - NWB.lastHeraldYell);
				NWB.buffDrops["rend"] = GetServerTime();
			else
				NWB:syncBuffsWithCurrentDuration();
			end
		elseif (destName == UnitName("player") and spellName == L["Spirit of Zandalar"] and (GetServerTime() - NWB.lastZanBuffGained) > 1) then
			--Zan buff has no sourceName or sourceGUID, not sure why.
			local expirationTime = NWB:getBuffDuration(L["Spirit of Zandalar"], 4);
			if (expirationTime >= 7199.5) then
				NWB:setZanBuff("self", UnitName("player"), zoneID, sourceGUID);
				NWB:trackNewBuff(spellName, "zan", npcID);
				--Not sure why this triggers 4 times on PTR, needs more testing once it's on live server but for now we do a 1 second cooldown.
				NWB.lastZanBuffGained = GetServerTime();
				--if (not NWB.buffDrops["zan"] or GetServerTime() - NWB.buffDrops["zan"] > NWB.buffDropSpamCooldown) then
					NWB:playSound("soundsZanDrop", "zan");
				--end
				NWB:buffDroppedTaxiNode("zg");
				if (NWB.db.global.zgGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got Zandalar buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
				--NWB.buffDrops["zan"] = GetServerTime();
			else
				NWB:syncBuffsWithCurrentDuration();
			end
		--[[elseif (((NWB.faction == "Horde" and npcID == "14720") or (NWB.faction == "Alliance" and npcID == "14721"))
				and destName == UnitName("player") and spellName == L["Rallying Cry of the Dragonslayer"]
				and ((GetServerTime() - NWB.data.nefYell2) < 60 or (GetServerTime() - NWB.data.nefYell) < 60)
				and unitType == "Creature") then]]
		elseif (((NWB.faction == "Horde" and (npcID == "14720" or npcID == "173758" or NWB.noGUID))
				or (NWB.faction == "Alliance" and (npcID == "14721" or npcID == "173754" or NWB.noGUID)))
				and destName == UnitName("player") and spellName == L["Rallying Cry of the Dragonslayer"]
				and ((GetServerTime() - NWB.data.nefYell2) < yellTwoOffset or (GetServerTime() - NWB.data.nefYell) < yellOneOffset)
				and (unitType == "Creature" or NWB.noGUID)) then
			--What a shitshow this is now, thanks Blizzard for removing the GUID for no good reason.
			local expirationTime = NWB:getBuffDuration(L["Rallying Cry of the Dragonslayer"], 2);
			local _, _, zone = NWB:GetPlayerZonePosition();
			if (expirationTime >= (7199.5  - buffLag)) then
				if (((not NWB.noGUID or NWB.currentZoneID > 0) and (zone == 1453 or zone == 1454))
						or not NWB.isLayered) then
					if (NWB.noGUID) then
						NWB:debug("bufftest4", "self", UnitName("player"), NWB.currentZoneID, "noSourceGUID");
						NWB:setNefBuff("self", UnitName("player"), NWB.currentZoneID, "noSourceGUID");
					elseif ((GetServerTime() - NWB.lastJoinedGroup) > 180) then
						NWB:setNefBuff("self", UnitName("player"), zoneID, sourceGUID);
					end
				end
				NWB:trackNewBuff(spellName, "nef", npcID);
				--Share cd with ony, same buff.
				if (not NWB.buffDrops["ony"] or GetServerTime() - NWB.buffDrops["ony"] > NWB.buffDropSpamCooldown) then
					NWB:playSound("soundsNefDrop", "nef");
				end
				if (NWB.db.global.cityGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got Nefarian buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
				--NWB:debug("nef hand in delay", GetTime() - lastNefHandIn);
				NWB.buffDrops["ony"] = GetServerTime();
				--NWB.buffDrops["nef"] = GetServerTime();
			else
				NWB:syncBuffsWithCurrentDuration()
			end
		--[[elseif (((NWB.faction == "Horde" and npcID == "14392") or (NWB.faction == "Alliance" and npcID == "14394"))
				and destName == UnitName("player") and spellName == L["Rallying Cry of the Dragonslayer"]
				and ((GetServerTime() - NWB.data.onyYell2) < 60 or (GetServerTime() - NWB.data.onyYell) < 60)
				and ((GetServerTime() - NWB.data.nefYell2) > 60)
				and unitType == "Creature") then]]
		elseif (((NWB.faction == "Horde" and (npcID == "14392" or npcID == "173758" or NWB.noGUID))
				or (NWB.faction == "Alliance" and (npcID == "14394" or npcID == "173754" or NWB.noGUID)))
				and destName == UnitName("player") and spellName == L["Rallying Cry of the Dragonslayer"]
				and ((GetServerTime() - NWB.data.onyYell2) < yellTwoOffset or (GetServerTime() - NWB.data.onyYell) < yellOneOffset)
				and ((GetServerTime() - NWB.data.nefYell2) > 30)
				and (unitType == "Creature" or NWB.noGUID)) then
			local expirationTime = NWB:getBuffDuration(L["Rallying Cry of the Dragonslayer"], 2);
			local _, _, zone = NWB:GetPlayerZonePosition();
			if (expirationTime >= (7199.5 - buffLag)) then
				if (((not NWB.noGUID or NWB.currentZoneID > 0) and (zone == 1453 or zone == 1454))
					or not NWB.isLayered) then
					if (NWB.noGUID) then
						NWB:debug("bufftest4", "self", UnitName("player"), NWB.currentZoneID, "noSourceGUID");
						NWB:setOnyBuff("self", UnitName("player"), NWB.currentZoneID, "noSourceGUID");
					elseif ((GetServerTime() - NWB.lastJoinedGroup) > 180) then
						NWB:setOnyBuff("self", UnitName("player"), zoneID, sourceGUID);
					end
				end
				NWB:trackNewBuff(spellName, "ony", npcID);
				if (not NWB.buffDrops["ony"] or GetServerTime() - NWB.buffDrops["ony"] > NWB.buffDropSpamCooldown) then
					NWB:playSound("soundsOnyDrop", "ony");
				end
				if (NWB.db.global.cityGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got Onyxia buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
				--NWB:debug("ony hand in delay", GetTime() - lastOnyHandIn);
				NWB.buffDrops["ony"] = GetServerTime();
			else
				NWB:syncBuffsWithCurrentDuration();
			end
		--[[elseif (((NWB.faction == "Horde" and destNpcID == "14392") or (NWB.faction == "Alliance" and destNpcID == "14394"))
				and spellName == L["Sap"] and ((GetServerTime() - NWB.data.onyYell2) < 30 or (GetServerTime() - NWB.data.onyYell) < 30)) then
			--Yell timestamp is only recorded to non-layered data (NWB.data.onyYell) first because there's is no GUID attached.
			--Then it's copied from there to the right layer once the buff drops in setOnyBuff().
			--For this reason we just check against the non-layered yell timestamp even for layered realms.
			--Using destGUID instead of sourceGUID for sap target instead of buff gained from source.
			--Sapping breaking the buff was fixed by blizzard.
			local unitType, _, _, _, zoneID, npcID = strsplit("-", destGUID);
			zoneID = tonumber(zoneID);
			local _, _, zone = NWB:GetPlayerZonePosition();
			if ((zone == 1453 or zone == 1454) or not NWB.isLayered) then
				NWB:debug("Onyxia buff NPC sapped by", sourceName, zoneID, destGUID);
				if (sourceName) then
					NWB:print("Onyxia buff NPC sapped by " .. sourceName .. ", setting backup timer.");
					if (not NWB.data.sapped) then
						NWB.data.sapped = {};
					end
					NWB.data.sapped[sourceName] = GetServerTime();
				else
					NWB:print("Onyxia buff NPC sapped, setting backup timer.");
				end
				NWB:setOnyBuff("self", UnitName("player"), zoneID, destGUID, true);
			end]]
		elseif (destName == UnitName("player") and (spellName == L["Sayge's Dark Fortune of Agility"]
				or spellName == L["Sayge's Dark Fortune of Spirit"] or spellName == L["Sayge's Dark Fortune of Stamina"]
				or spellName == L["Sayge's Dark Fortune of Strength"] or spellName == L["Sayge's Dark Fortune of Armor"]
				or spellName == L["Sayge's Dark Fortune of Resistance"] or spellName == L["Sayge's Dark Fortune of Damage"]
				 or spellName == L["Sayge's Dark Fortune of Intelligence"])) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (not NWB.isClassic and spellName == L["Sayge's Dark Fortune of Damage"]) then
				NWB.unitDamageFrame:RegisterEvent("UNIT_DAMAGE");
			end
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "dmf", npcID);
				NWB.lastDmfBuffGained = GetServerTime();
				--NWB:debug(GetTime() - speedtest);
				if (NWB.db.global.dmfGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got DMF buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
			end
		elseif (destName == UnitName("player") and npcID == "14822") then
			--Backup checking Sayge NPC ID until all localizations are done properly.
			--Maybe this is a better way of doing it overall but I have to test when DMF is actually up first.
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "dmf", npcID);
			end
		elseif ((NWB.noGUID or (npcID == "14720" or npcID == "14721" or npcID == "173758")) and destName == UnitName("player")
				and spellName == L["Rallying Cry of the Dragonslayer"]) then
			--Fallback ony/nef buff tracking incase no yell msgs seen abive.
			local expirationTime = NWB:getBuffDuration(L["Rallying Cry of the Dragonslayer"], 2);
			if (expirationTime >= 7199.5) then
				NWB:trackNewBuff(spellName, "ony", npcID);
			end
		end
		--Check new nef/ony buffs for tracking durations seperately than the buff timer checks with validation above.
		--This was used when the npc id's were different for the buffs, now we check above instead.
		--[[if ((NWB.noGUID or (npcID == "14720" or npcID == "14721")) and destName == UnitName("player")
				and spellName == L["Rallying Cry of the Dragonslayer"]) then
			local expirationTime = NWB:getBuffDuration(L["Rallying Cry of the Dragonslayer"], 2);
			if (expirationTime >= 7199.5) then
				NWB:trackNewBuff(spellName, "nef");
			end
		elseif ((NWB.noGUID or (npcID == "14392" or npcID == "14394")) and destName == UnitName("player")
				and spellName == L["Rallying Cry of the Dragonslayer"]) then
			local expirationTime = NWB:getBuffDuration(L["Rallying Cry of the Dragonslayer"], 2);
			if (expirationTime >= 7199.5) then
				NWB:trackNewBuff(spellName, "ony");
			end
		elseif (destName == UnitName("player") and spellName == L["Songflower Serenade"]) then]]
		if (destName == UnitName("player") and spellName == L["Songflower Serenade"]) then
			local expirationTime = NWB:getBuffDuration(L["Songflower Serenade"], 3);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "songflower");
				if (NWB.db.global.songflowerGotBuffSummon) then
					if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
						NWB.hideSummonPopup = true;
						NWB:print("Got Songflower buff, auto taking summon.");
					end
					NWB:acceptSummon();
				end
			end
		elseif (npcID == "14326" and destName == UnitName("player")) then
			--Mol'dar's Moxie.
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "moxie", npcID);
			end
		elseif (npcID == "14321" and destName == UnitName("player")) then
			--Fengus' Ferocity.
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "ferocity", npcID);
			end
		elseif (npcID == "14323" and destName == UnitName("player")) then
			--Slip'kik's Savvy.
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "savvy", npcID);
			end
		elseif (NWB.isDebugg and destName == UnitName("player") and spellName == "Ice Armor") then
			local expirationTime = NWB:getBuffDuration("Ice Armor", 0);
			if (expirationTime >= 1799) then
				NWB:trackNewBuff(spellName, "ice");
			end
		elseif (destName == UnitName("player")
				and (spellName == L["Flask of Supreme Power"] or spellName == L["Supreme Power"])) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "flaskPower");
			end
		elseif (destName == UnitName("player") and spellName == L["Flask of the Titans"]) then
			--This is the only flask spell with "Flask" in the name it seems.
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "flaskTitans");
			end
		elseif (destName == UnitName("player")
				and (spellName == L["Flask of Distilled Wisdom"] or spellName == L["Distilled Wisdom"])) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "flaskWisdom");
			end
		elseif (destName == UnitName("player")
				and (spellName == L["Flask of Chromatic Resistance"] or spellName == L["Chromatic Resistance"])) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "flaskResistance");
			end
		elseif (destName == UnitName("player") and spellName == L["Resist Fire"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "resistFire");
			end
		elseif (destName == UnitName("player") and spellName == L["Blessing of Blackfathom"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "blackfathom");
			end
		elseif (destName == UnitName("player") and spellName == L["Fire Festival Fortitude"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "festivalFortitude");
			end
		elseif (destName == UnitName("player") and spellName == L["Fire Festival Fury"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "festivalFury");
			end
		elseif (destName == UnitName("player") and spellName == L["Ribbon Dance"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599) then
				NWB:trackNewBuff(spellName, "ribbonDance");
			end
		elseif (destName == UnitName("player") and spellName == L["Traces of Silithyst"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 1799) then
				NWB:trackNewBuff(spellName, "silithyst");
			end
		elseif (destName == UnitName("player") and spellName == L["Sheen of Zanza"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "sheenZanza");
			end
		elseif (destName == UnitName("player") and spellName == L["Spirit of Zanza"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "spiritZanza");
			end
		elseif (destName == UnitName("player") and spellName == L["Swiftness of Zanza"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "swiftZanza");
			end
		--New SoD buffs, now that they allow spellIDs in classic this needs to all be changed to a hash table instead of this mess of elseif's in the future.
		elseif (destName == UnitName("player") and spellName == L["Boon of Blackfathom"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199 and UnitLevel("player") < 40) then
				NWB:trackNewBuff(spellName, "boonOfBlackfathom");
				if (GetServerTime() - NWB.lastBlackfathomBoon > NWB.buffDropSpamCooldownSoD) then
					NWB.lastBlackfathomBoon = GetServerTime();
					NWB:playSound("soundsBlackfathomBoon", "bob");
					NWB:print(string.format(L["specificBuffDropped"], L["Boon of Blackfathom"]));
				end
			end
		elseif (destName == UnitName("player") and spellName == L["Ashenvale Rallying Cry"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199) then
				NWB:trackNewBuff(spellName, "ashenvaleRallyingCry");
			end
		elseif (destName == UnitName("player") and spellName == L["Spark of Inspiration"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199 and UnitLevel("player") < 50) then
				NWB:trackNewBuff(spellName, "sparkOfInspiration");
				if (GetServerTime() - NWB.lastSparkOfInspiration > NWB.buffDropSpamCooldownSoD) then
					NWB.lastSparkOfInspiration = GetServerTime();
					NWB:playSound("soundsBlackfathomBoon", "bob"); --Shared blackfathom boon sound option.
					NWB:print(string.format(L["specificBuffDropped"], L["Spark of Inspiration"]));
				end
			end
		elseif (destName == UnitName("player") and spellName == L["Fervor of the Temple Explorer"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 7199 and UnitLevel("player") < 60) then
				NWB:trackNewBuff(spellName, "fervorTempleExplorer");
				if (GetServerTime() - NWB.lastFervorTempleExplorer > NWB.buffDropSpamCooldownSoD) then
					NWB.lastFervorTempleExplorer = GetServerTime();
					NWB:playSound("soundsBlackfathomBoon", "bob"); --Shared blackfathom boon sound option.
					NWB:print(string.format(L["specificBuffDropped"], L["Fervor of the Temple Explorer"]));
				end
			end
		elseif (destName == UnitName("player") and spellName == L["Might of Stormwind"]) then
			local expirationTime = NWB:getBuffDuration(spellName, 0);
			if (expirationTime >= 3599.9) then
				NWB:trackNewBuff(spellName, "mightOfStormwind");
				local _, _, zone = NWB:GetPlayerZonePosition();
				if (zone == 1453 or zone == 1429) then
					if (GetServerTime() - NWB.lastMightOfStormwind > 300) then
						NWB.lastMightOfStormwind = GetServerTime();
						NWB:playSound("soundsRendDrop", "rend");
						NWB:print(string.format(L["specificBuffDropped"], L["Might of Stormwind"] .. " (" .. L["Rend"] .. ")"));
					end
					if (NWB.db.global.cityGotBuffSummon) then
						if (not InCombatLockdown() and C_SummonInfo.GetSummonConfirmTimeLeft() > 0) then
							NWB.hideSummonPopup = true;
							NWB:print("Got Rend buff, auto taking summon.");
						end
						NWB:acceptSummon();
					end
				end
			else
				NWB:syncBuffsWithCurrentDuration();
			end
		elseif (destName == UnitName("player") and spellName == L["Stealth"]) then
			--Vanish is hidden from combat log even to ourself, use stealth instead as it fires when we vanish.
			NWB:doStealth();
		elseif (destName == UnitName("player") and spellName == L["Silithyst"]) then
			NWB:placeSilithystMarker();
		end
	elseif (subEvent == "SPELL_AURA_REMOVED") then
		if (destName == UnitName("player")) then
			NWB:untrackBuff(spellName);
			--There is no SPELL_AURA_APPLIED event for the Traces of Silithyst buff, kinda strange.
			--So we have to watch for the Silithyst buff you drop off at the camp instead, then do a resync right after.
			if (spellName == L["Silithyst"]) then
				NWB:removeSilithystMarker();
				NWB:syncBuffsWithCurrentDuration();
				C_Timer.After(2, function()
					NWB:syncBuffsWithCurrentDuration();
				end)
			end
		end
		if (spellID == 349863 and destName) then
			NWB.lastUnboon[destName] = GetTime();
		end
	elseif (subEvent == "SPELL_DISPEL") then
		if (not NWB.db.global.dispelsMine and not NWB.db.global.dispelsMineWBOnly
				and not NWB.db.global.dispelsAll and not NWB.db.global.dispelsAllWBOnly) then
			return;
		end
		for i = 1, 32 do
			local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i);
			if (spellID) then
				if (spellID == 436097) then
					--Don't spam dispel msgs during blood moon event.
					return;
				end
			else
				break;
			end
		end
		local _, _, zone = NWB:GetPlayerZonePosition();
		if (zone == 125 or zone == 126) then
			--No dispel spam from duelers in dalaran.
			return;
		end
		local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, _, spellName, _, _, extraSpellName, _, auraType = CombatLogGetCurrentEventInfo();
		local unitType, _, _, _, zoneID, npcID = strsplit("-", destGUID);
		if (tonumber(npcID) == 14392 or tonumber(npcID) == 14720 or tonumber(npcID) == 14394 or tonumber(npcID) == 14721) then
			if ((zone == 1454 or zone == 1453) and (extraSpellName == L["Mind Control"] or extraSpellName == L["Gnomish Mind Control Cap"])) then
				local _, sourceClass = GetPlayerInfoByGUID(sourceGUID);
				local _, _, _, sourceHex = GetClassColor(sourceClass);
				local sourceWho = "|c" .. sourceHex .. sourceName .. "|r"
				local _, _, _, destHex = GetClassColor("WARRIOR");
				local destWho = "|c" .. destHex .. destName .. "|r"
				local spell = "|cff71d5ff[" .. extraSpellName .. "]|r";
				NWB:print(sourceWho .. NWB.chatColor .. " dispelled " .. destWho .. " " .. spell .. NWB.chatColor .. ".");
				NWB:playSound("soundsDispelsAll", "dispelsAll");
			end
			return;
		end
		--if (auraType == "BUFF") then
			--NWB:debug(CombatLogGetCurrentEventInfo());
		--end
		if (not string.match(destGUID, "Player") or UnitInBattleground("player") or NWB:isInArena()
				or (not string.match(sourceGUID, "Player") and not string.match(sourceGUID, "Pet"))) then
			return;
		end
		if (auraType == "BUFF" and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE) then
			local dispellableWorldBuffs = {
				[L["Songflower Serenade"]] = true,
				[L["Resist Fire"]] = true,
				[L["Mol'dar's Moxie"]] = true,
				[L["Fengus' Ferocity"]] = true,
				[L["Slip'kik's Savvy"]] = true,
			}
			if (dispellableWorldBuffs[extraSpellName] and not NWB.cnRealms[NWB.realm] and not NWB.twRealms[NWB.realm]
					and not NWB.krRealms[NWB.realm] and not string.match(destGUID, "Pet")) then
				--Only record world buff dispels and not other buffs.
				--Disabled on high layer regions, don't want to add any extra data to sync there.
			end
			local _, sourceClass = GetPlayerInfoByGUID(sourceGUID);
			local _, _, _, sourceHex = GetClassColor(sourceClass);
			local sourceWho = "|c" .. sourceHex .. sourceName .. "|r"
			local _, destClass = GetPlayerInfoByGUID(destGUID);
			local _, _, _, destHex = GetClassColor(destClass);
			local destWho = "|c" .. destHex .. destName .. "|r"
			local spell = "|cff71d5ff[" .. extraSpellName .. "]|r";
			if (string.match(sourceGUID, "Pet")) then
				sourceWho = sourceName .. " (Pet)";
			end
			if (destName == UnitName("player")) then
				if (NWB.db.global.dispelsMine and NWB.db.global.dispelsMineWBOnly and dispellableWorldBuffs[spellName]) then
					NWB:print(sourceWho .. NWB.chatColor .. " dispelled your " .. spell .. NWB.chatColor .. ".");
					NWB:playSound("soundsDispelsMine", "dispelsMine");
				elseif (NWB.db.global.dispelsMine) then
					NWB:print(sourceWho .. NWB.chatColor .. " dispelled your " .. spell .. NWB.chatColor .. ".");
					NWB:playSound("soundsDispelsMine", "dispelsMine");
				end
			else
				if (NWB.db.global.dispelsAll and NWB.db.global.dispelsAllWBOnly and dispellableWorldBuffs[spellName]) then
					NWB:print(sourceWho .. NWB.chatColor .. " dispelled " .. destWho .. " " .. spell .. NWB.chatColor .. ".");
					NWB:playSound("soundsDispelsAll", "dispelsAll");
				elseif (NWB.db.global.dispelsAll) then
					NWB:print(sourceWho .. NWB.chatColor .. " dispelled " .. destWho .. " " .. spell .. NWB.chatColor .. ".");
					NWB:playSound("soundsDispelsAll", "dispelsAll");
				end
			end
			
		end
	--[[elseif (subEvent == "SPELL_CAST_SUCCESS") then
		if (spellID == 460939 or spellID == 460940) then
			local unitType, _, _, _, zoneID, npcID = strsplit("-", sourceGUID);
			if (unitType == "Creature" and npcID == 466) then
				NWB:debug("Might of stormwind (Rend) handed in by " .. destName .. ".");
			end
		end]]
	end
end

--local rendLastSet, onyLastSet, nefLastSet, zanLastSet = 0, 0, 0, 0;
function NWB:setRendBuff(source, sender, zoneID, GUID, isAllianceAndLayered)
	--Check if this addon has already set a timer a few seconds before another addon's comm.
	if (source ~= "self" and (GetServerTime() - NWB.data.rendTimer) < 10) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (NWB.faction == "Horde" and zone ~= 1454 and zone ~= 1413) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (NWB.faction == "Alliance" and zone ~= 1453 and zone ~= 1413 and zone ~= 1454) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (not NWB:validateNewTimer("rend", source)) then
		NWB:debug("failed rend timer validation", source);
		return;
	end
	local useSingleLayer = NWB:getSingleLayer();
	if (NWB.isLayered and NWB.faction == "Alliance" and useSingleLayer) then
		--Now that rend doesn't have a zoneID attached to what layer dropped it there's no need to even look for one.
		--Just set alliance timer to the single layer if there is only one existing.
		--Not doing ths for horde becaus it's still possible you can logon and not have the 2nd layer data that spawned while offline.
		--(But even then it still probably doesn't matter really, people on diff layers will create timers at the same time for multiple layers anyway).
		zoneID = useSingleLayer;
	end
	--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
	zoneID = NWB:mapLayerToParent(zoneID);
	if (NWB.isLayered and not zoneID) then
		return;
	end
	if (NWB.isLayered and tonumber(zoneID)) then
		local count = 0;
		for k, v in pairs(NWB.data.layers) do
			count = count + 1;
		end
		if (count <= NWB.limitLayerCount) then
			if (isAllianceAndLayered) then
				if (not NWB.data.layers[NWB.lastKnownLayerMapID] and not NWB.data.layers[zoneID]) then
					NWB:print("Got rend buff but no layer ID was found.");
					return;
				elseif (NWB.lastKnownLayerMapID > 0 or zoneID > 0) then
					if (useSingleLayer) then
						zoneID = useSingleLayer;
					else
						zoneID = NWB.lastKnownLayerMapID;
					end
					if (NWB.data.layers[zoneID]) then
						NWB.data.layers[zoneID].rendTimer = GetServerTime();
						NWB.data.layers[zoneID].rendTimerWho = sender;
						NWB.data.layers[zoneID].rendSource = source;
						NWB.data.layers[zoneID].rendYell = NWB.data.rendYell;
						NWB.data.layers[zoneID].rendYell2 = NWB.data.rendYell2;
						NWB:timerLog("rendTimer", GetServerTime(), zoneID);
					end
				else
					return;
				end
			else
				if (GUID) then
					if (not NWB.data.layers[zoneID]) then
						NWB:createNewLayer(zoneID, GUID);
					end
				end
				if (NWB.data.layers[zoneID]) then
					NWB.data.layers[zoneID].rendTimer = GetServerTime();
					NWB.data.layers[zoneID].rendTimerWho = sender;
					NWB.data.layers[zoneID].rendSource = source;
					NWB.data.layers[zoneID].rendYell = NWB.data.rendYell;
					NWB.data.layers[zoneID].rendYell2 = NWB.data.rendYell2;
					NWB:timerLog("rendTimer", GetServerTime(), zoneID);
				end
			end
		end
	end
	--Keep recording older non layered data for now.
	NWB.data.rendTimer = GetServerTime();
	NWB.data.rendTimerWho = sender;
	NWB.data.rendSource = source;
	NWB:resetWarningTimers("rend", zoneID);
	NWB:sendData("GUILD");
	if (not NWB.isLayered) then
		NWB:timerLog("rendTimer", GetServerTime());
	end
	local count = 0;
	--Once per drop one guild member will say in chat it dropped.
	--Throddle the drop msg for when we get multiple sources at the same drop time.
	if ((GetServerTime() - NWB.lastSets.rend) > 60) then
		if (NWB.db.global.guildBuffDropped == 1 and (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend)) then
			if (zoneID) then
				for k, v in NWB:pairsByKeys(NWB.data.layers) do
					count = count + 1;
					if (k == zoneID) then
						break;
					end
				end
			end
			--NWB:sendGuildMsg(L["rendBuffDropped"] .. layerMsg, "guildBuffDropped", "rend");
		end
		if (NWB.isLayered and count > 0) then
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "rend", nil, count);
				--NWB:doBuffDropMsg("rend " .. count);
				NWB:doBuffDropMsg("rend", count);
			end
		else
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "rend");
				NWB:doBuffDropMsg("rend");
			end
		end
	end
	NWB.lastSets.rend = GetServerTime();
	--NWB:debug("set rend buff", source);
	--NWB.data.myChars[UnitName("player")].rendCount = NWB.data.myChars[UnitName("player")].rendCount + 1;
	--NWB:debug("zoneid drop", zoneID, count, GUID);
end

function NWB:setZanBuff(source, sender, zoneID, GUID)
	--Disabled, there is no cooldown, will remove all the zand timer code at a later point.
	--[[if (not NWB.zand) then
		return;
	end
	NWB:debug("6");
	if (source ~= "self" and (GetServerTime() - NWB.data.zanTimer) < 10) then
		return;
	end
	if (not NWB:validateNewTimer("zan", source)) then
		NWB:debug("failed zan timer validation", source);
		return;
	end
	NWB:debug("7");
	NWB.data.zanTimer = GetServerTime();
	NWB.data.zanTimerWho = sender;
	NWB.data.zanSource = source;
	NWB:resetWarningTimers("zan", zoneID);
	NWB:sendData("GUILD");
	--Once per drop one guild member will say in chat it dropped.
	--Throddle the drop msg for when we get multiple sources at the same drop time.
	if ((GetServerTime() - NWB.lastSets.zan) > 120) then
		if (NWB.db.global.guildBuffDropped == 1) then
			NWB:sendGuildMsg(L["zanBuffDropped"], "guildBuffDropped", "zan");
		end
	end
	NWB.lastSets.zan = GetServerTime();
	NWB:debug("set zan buff", source);]]
	--NWB.data.myChars[UnitName("player")].zanCount = NWB.data.myChars[UnitName("player")].zanCount + 1;
	--NWB:debug("zoneid drop", zoneID, GUID);
end

function NWB:setOnyBuff(source, sender, zoneID, GUID, isSapped)
	--Ony and nef share a last set cooldown to prevent any bugs with both being set at once.
	if ((GetServerTime() - NWB.lastSets.nef) < 20) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (NWB.faction == "Horde" and zone ~= 1454 and zone ~= 1413) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (NWB.faction == "Alliance" and zone ~= 1453 and zone ~= 1413) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (source ~= "self" and (GetServerTime() - NWB.data.onyTimer) < 10) then
		return;
	end
	if (not NWB:validateNewTimer("ony", source)) then
		NWB:debug("failed ony timer validation", source);
		return;
	end
	--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
	zoneID = NWB:mapLayerToParent(zoneID);
	if (NWB.isLayered and not zoneID) then
		return;
	end
	if (NWB.isLayered and tonumber(zoneID)) then
		local count = 0;
		for k, v in pairs(NWB.data.layers) do
			count = count + 1;
		end
		if (count <= NWB.limitLayerCount) then
			if (not NWB.data.layers[zoneID]) then
				NWB:createNewLayer(zoneID, GUID);
			end
			if (NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].onyTimer = GetServerTime();
				NWB.data.layers[zoneID].onyTimerWho = sender;
				NWB.data.layers[zoneID].onyNpcDied = 0;
				NWB.data.layers[zoneID].onySource = source;
				NWB.data.layers[zoneID].onyYell = NWB.data.onyYell;
				NWB.data.layers[zoneID].onyYell2 = NWB.data.onyYell2;
				NWB:timerLog("onyTimer", GetServerTime(), zoneID);
			end
		end
	end
	NWB.data.onyTimer = GetServerTime();
	NWB.data.onyTimerWho = sender;
	NWB.data.onyNpcDied = 0;
	NWB.data.onySource = source;
	NWB:resetWarningTimers("ony", zoneID);
	NWB:sendData("GUILD");
	if (not NWB.isLayered) then
		NWB:timerLog("onyTimer", GetServerTime());
	end
	local count = 0;
	if ((GetServerTime() - NWB.lastSets.ony) > 60) then
		local count = 0;
		if (NWB.db.global.guildBuffDropped == 1) then
			if (zoneID) then
				for k, v in NWB:pairsByKeys(NWB.data.layers) do
					count = count + 1;
					if (k == zoneID) then
						break;
					end
				end
			end
			--NWB:sendGuildMsg(L["onyxiaBuffDropped"] .. layerMsg, "guildBuffDropped", "ony");
		end
		if (NWB.isLayered and count > 0 and not isSapped) then
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "ony", nil, count);
				--NWB:doBuffDropMsg("ony " .. count);
				NWB:doBuffDropMsg("ony", count);
			end
		elseif (not isSapped) then
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "ony");
				NWB:doBuffDropMsg("ony");
			end
		end
	end
	NWB.lastSets.ony = GetServerTime();
	--NWB:debug("set ony buff", source);
	--NWB.data.myChars[UnitName("player")].onyCount = NWB.data.myChars[UnitName("player")].onyCount + 1;
	--NWB:debug("zoneid drop", zoneID, count, GUID);
	if (isSapped) then
		NWB:sendData("YELL");
	end
end

function NWB:setNefBuff(source, sender, zoneID, GUID)
	--Ony and nef share a last set cooldown to prevent any bugs with both being set at once.
	if ((GetServerTime() - NWB.lastSets.ony) < 20) then
		return;
	end
	if (source ~= "self" and (GetServerTime() - NWB.data.nefTimer) < 10) then
		return;
	end
	local _, _, zone = NWB:GetPlayerZonePosition();
	if (NWB.faction == "Horde" and zone ~= 1454 and zone ~= 1413) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (NWB.faction == "Alliance" and zone ~= 1453 and zone ~= 1413) then
		NWB:debug("not in a valid zone to set rend timer");
		return;
	end
	if (not NWB:validateNewTimer("nef", source)) then
		NWB:debug("failed nef timer validation", source);
		return;
	end
	--If we're starting layer data from somewhere other than org/sw we need to get the right base zoneID.
	zoneID = NWB:mapLayerToParent(zoneID);
	if (NWB.isLayered and not zoneID) then
		return;
	end
	if (NWB.isLayered and tonumber(zoneID)) then
		local count = 0;
		for k, v in pairs(NWB.data.layers) do
			count = count + 1;
		end
		if (count <= NWB.limitLayerCount) then
			if (not NWB.data.layers[zoneID]) then
				NWB:createNewLayer(zoneID, GUID);
			end
			if (NWB.data.layers[zoneID]) then
				NWB.data.layers[zoneID].nefTimer = GetServerTime();
				NWB.data.layers[zoneID].nefTimerWho = sender;
				NWB.data.layers[zoneID].nefNpcDied = 0;
				NWB.data.layers[zoneID].nefSource = source;
				NWB.data.layers[zoneID].nefYell = NWB.data.nefYell;
				NWB.data.layers[zoneID].nefYell2 = NWB.data.nefYell2;
				NWB:timerLog("nefTimer", GetServerTime(), zoneID);
			end
		end
	end
	NWB.data.nefTimer = GetServerTime();
	NWB.data.nefTimerWho = sender;
	NWB.data.nefNpcDied = 0;
	NWB.data.nefSource = source;
	NWB:resetWarningTimers("nef", zoneID);
	NWB:sendData("GUILD");
	if (not NWB.isLayered) then
		NWB:timerLog("nefTimer", GetServerTime());
	end
	local count = 0;
	if ((GetServerTime() - NWB.lastSets.nef) > 60) then
		local count = 0;
		if (NWB.db.global.guildBuffDropped == 1) then
			if (zoneID) then
				for k, v in NWB:pairsByKeys(NWB.data.layers) do
					count = count + 1;
					if (k == zoneID) then
						break;
					end
				end
			end
			--NWB:sendGuildMsg(L["nefarianBuffDropped"] .. layerMsg, "guildBuffDropped", "nef");
		end
		if (NWB.isLayered and count > 0) then
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "nef", nil, count);
				--NWB:doBuffDropMsg("nef " .. count);
				NWB:doBuffDropMsg("nef", count);
			end
		else
			if (not NWB.noGuildBuffDroppedMsgs) then
				NWB:sendBuffDropped("GUILD", "nef");
				NWB:doBuffDropMsg("nef");
			end
		end
	end
	NWB.lastSets.nef = GetServerTime();
	--NWB:debug("set nef buff", source);
	--NWB.data.myChars[UnitName("player")].nefCount = NWB.data.myChars[UnitName("player")].nefCount + 1;
	--NWB:debug("zoneid drop", zoneID, count, GUID);
end

local f = CreateFrame("Frame");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("CHAT_MSG_MONSTER_YELL");
f:RegisterEvent("CHAT_MSG_MONSTER_SAY");
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(...);
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
		monsterYell(...);
	elseif (event == "CHAT_MSG_MONSTER_SAY") then
		monsterSay(...);
	end
end)

--Post first yell warning to guild chat, shared by all different addon comms so no overlap.
local rendFirstYell, onyFirstYell, nefFirstYell, zanFirstYell = 0, 0, 0, 0;
function NWB:doFirstYell(type, layer, source, distribution, arg)
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layer) and NWB.doLayerMsg and layer > 0) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type == "rend") then
		if ((GetServerTime() - rendFirstYell) > 40) then
			--6 seconds from rend first yell to buff drop.
			if (source == "self") then
				NWB.data.rendYell = GetServerTime();
			end
			if (NWB:checkEventStatus("firstYell", type)) then
				if (NWB.db.global.guildNpcDialogue == 1 and (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend)) then
					NWB:sendGuildMsg(L["rendFirstYellMsg"] .. layerMsg, "guildNpcDialogue", "rend");
				end
				if (NWB.faction == "Horde" or NWB.db.global.allianceEnableRend) then
					NWB:startFlash("flashFirstYell", type);
					if (NWB.db.global.middleBuffWarning and (not NWB.db.global.chatOnlyInCity or NWB:isCapitalCityAction(type))) then
						NWB:middleScreenMsg("rendFirstYell", L["rendFirstYellMsg"] .. layerMsg, nil, 5);
					end
				end
				NWB:playSound("soundsFirstYell", "rend");
				NWB:sendBigWigs(6, "[NWB] " .. L["rend"], type);
			end
			rendFirstYell = GetServerTime();
		end
	elseif (type == "ony") then
		if ((GetServerTime() - onyFirstYell) > 40) then
			--14 seconds from ony first yell to buff drop.
			if (source == "self") then
				NWB.data.onyYell = GetServerTime();
			end
			if (NWB:checkEventStatus("firstYell", type)) then
				if (NWB.db.global.guildNpcDialogue == 1 and NWB:checkEventStatus("firstYell", type, "guild")) then
					NWB:sendGuildMsg(L["onyxiaFirstYellMsg"] .. layerMsg, "guildNpcDialogue", "ony");
				end
				NWB:startFlash("flashFirstYell", type);
				if (NWB.db.global.middleBuffWarning and (not NWB.db.global.chatOnlyInCity or NWB:isCapitalCityAction(type))) then
					NWB:middleScreenMsg("onyFirstYell", L["onyxiaFirstYellMsg"] .. layerMsg, nil, 5);
				end
				NWB:playSound("soundsFirstYell", "ony");
				NWB:sendBigWigs(14, "[NWB] " .. L["Rallying Cry of the Dragonslayer"], type);
			end
			onyFirstYell = GetServerTime();
		end
	elseif (type == "nef") then
		if ((GetServerTime() - nefFirstYell) > 40) then
			--15 seconds from nef first yell to buff drop.
			if (source == "self") then
				NWB.data.nefYell = GetServerTime();
			end
			if (NWB:checkEventStatus("firstYell", type)) then
				if (NWB.db.global.guildNpcDialogue == 1 and NWB:checkEventStatus("firstYell", type, "guild")) then
					NWB:sendGuildMsg(L["nefarianFirstYellMsg"] .. layerMsg, "guildNpcDialogue", "nef");
				end
				NWB:startFlash("flashFirstYell", type);
				if (NWB.db.global.middleBuffWarning and (not NWB.db.global.chatOnlyInCity or NWB:isCapitalCityAction(type))) then
					NWB:middleScreenMsg("nefFirstYell", L["nefarianFirstYellMsg"] .. layerMsg, nil, 5);
				end
				NWB:playSound("soundsFirstYell", "nef");
				NWB:sendBigWigs(15, "[NWB] " .. L["Rallying Cry of the Dragonslayer"], type);
			end
			nefFirstYell = GetServerTime();
		end
	elseif (type == "zan") then
		--They reused the same NPC and drop msg as ZF buff in SoD for the Sunken Temple buff.
		--So block it from announcing during phase 3 until everyone updates the addon and it's blocked in yell detection.
		--6 second drop time like the other SoD buffs, no reason to announce.
		if (NWB.isSOD and NWB.sodPhase == 3) then
			return;
		end
		if ((GetServerTime() - zanFirstYell) > 60) then
			--I checked this on the test realm right before the Zandalar buff came out and the results were:
			--27ish seconds between first zan yell and buff applied if on island.
			--45ish seconds between first zan yell and buff applied if in booty bay.
			--So the chat msg we send has always just been 30 seconds until drop as a rough warning.
			--Now I have restested and rewritten the whole thing to give more specific warnings based on where the person
			--with the addon was standing when it dropped.
			--Order of events (average timings):
			--1600563364 Buff is handed in and Mothor speaks in /say around 50 seconds before drop.
			--1600563364 Booty bay does a first yell at the same time around 50 seconds before drop.
			--1600563385 Yojamba Island does a first yell 21 seconds later around 27-29 seconds before drop.
			--1600563414 Buff drops at exact same time on island and BB, unlike rend and org/crossraods which are different drop times.
			--These delays can be a little longer on occasion, probably based on amount of people around?
			--For neatness in the chat msgs we just call BB /yell and Island /say as 50 seconds, and island /yell as 30.
			local msg = string.format(L["zanFirstYellMsg"], "30");
			local timerDelay = 30;
			if (arg == "50") then
				msg = string.format(L["zanFirstYellMsg"], "50");
				timerDelay = 50;
			end
			if (source == "self") then
				NWB.data.zanYell = GetServerTime();
			end
			if (NWB:checkEventStatus("firstYell", "zan")) then
				if (NWB.db.global.chatZan) then
					NWB:print(msg, nil, nil, true);
				end
				if (NWB.db.global.guildZanDialogue == 1) then
					if (IsInGuild()) then
						if (NWB:checkEventStatus("firstYell", type, "guild")) then
							NWB:sendGuildMsg(msg .. layerMsg, "guildZanDialogue", "zan");
						end
					elseif (not NWB.db.global.chatZan) then
						--Fall back to a chat msg if guild msg is enabled but we have no guild, and chat msg wasn't already sent.
						NWB:print(msg, nil, nil, true);
					end
				end
				NWB:startFlash("flashFirstYellZan", type);
				if (NWB.db.global.middleBuffWarning and (not NWB.db.global.chatOnlyInCity or NWB:isCapitalCityAction(type))) then
					NWB:middleScreenMsg("zanFirstYell", msg .. layerMsg, nil, 5);
				end
				NWB:playSound("soundsFirstYell", "zan");
				if (distribution == "RAID" or distribution == "PARTY") then
					NWB:sendYell("GUILD", "zan");
				end
				NWB:sendBigWigs(timerDelay, "[NWB] " .. L["Spirit of Zandalar"], type);
			end
			zanFirstYell = GetServerTime();
		end
	end
end

--Post drop msg to guild chat, shared by all different addon comms so no overlap.
function NWB:doBuffDropMsg(type, layer)
	if (not NWB:checkEventStatus("buffDropMsg", type, "guild")) then
		return;
	end
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layer) and NWB.doLayerMsg) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	local cooldown = NWB.buffDropSpamCooldown > 39 and NWB.buffDropSpamCooldown or 40;
	if (type == "rend") then
		if ((GetServerTime() - rendDropMsg) > cooldown) then
			if (NWB.db.global.guildBuffDropped == 1) then
				NWB:sendGuildMsg(L["rendBuffDropped"] .. layerMsg, "guildBuffDropped", "rend");
			end
			rendDropMsg = GetServerTime();
		end
	elseif (type == "ony") then
		if ((GetServerTime() - onyDropMsg) > cooldown) then
			if (NWB.db.global.guildBuffDropped == 1) then
				NWB:sendGuildMsg(L["onyxiaBuffDropped"] .. layerMsg, "guildBuffDropped", "ony");
			end
			onyDropMsg = GetServerTime();
		end
	elseif (type == "nef") then
		if ((GetServerTime() - nefDropMsg) > cooldown) then
			if (NWB.db.global.guildBuffDropped == 1) then
				NWB:sendGuildMsg(L["nefarianBuffDropped"] .. layerMsg, "guildBuffDropped", "nef");
			end
			nefDropMsg = GetServerTime();
		end
	end
end

local onyNpcKill, nefNpcKill = 0, 0;
function NWB:doNpcKilledMsg(type, layer)
	if (not NWB:checkEventStatus("npcKilledMsg", type)) then
		return;
	end
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layer)) then
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type == "ony") then
		if ((GetServerTime() - onyNpcKill) > 40) then
			local msg = "";
			if (NWB.faction == "Horde") then
				msg = L["onyxiaNpcKilledHorde"] .. layerMsg;
			else
				msg = L["onyxiaNpcKilledAlliance"] .. layerMsg;
			end
			if (NWB.db.global.guildNpcKilled == 1) then
				NWB:sendGuildMsg(msg, "guildNpcKilled", "ony");
			end
			if (NWB.db.global.middleNpcKilled) then
				NWB:middleScreenMsg("onynNpcKilled", msg, nil, 5);
			end
			if (NWB.db.global.chatNpcKilled and GetServerTime() - NWB.loadTime > 30) then
				NWB:print(msg, nil, nil, true);
			end
			NWB:playSound("soundsNpcKilled", "timer");
			NWB:startFlash("flashNpcKilled", type);
			onyNpcKill = GetServerTime();
			NWB.receivedNpcDiedCooldown["onyNpcDied"] = GetServerTime();
		end
	elseif (type == "nef") then
		if ((GetServerTime() - nefNpcKill) > 40) then
			local msg = "";
			if (NWB.faction == "Horde") then
				msg = L["nefarianNpcKilledHorde"] .. layerMsg;
			else
				msg = L["nefarianNpcKilledAlliance"] .. layerMsg;
			end
			if (NWB.db.global.guildNpcKilled == 1) then
				NWB:sendGuildMsg(msg, "guildNpcKilled", "nef");
			end
			if (NWB.db.global.middleNpcKilled) then
				NWB:middleScreenMsg("onynNpcKilled", msg, nil, 5);
			end
			if (NWB.db.global.chatNpcKilled and GetServerTime() - NWB.loadTime > 30) then
				NWB:print(msg, nil, nil, true);
			end
			NWB:playSound("soundsNpcKilled", "timer");
			NWB:startFlash("flashNpcKilled", type);
			nefNpcKill = GetServerTime();
			NWB.receivedNpcDiedCooldown["nefNpcDied"] = GetServerTime();
		end
	end
end

local onyNpcRespawn, nefNpcRespawn = 0, 0;
function NWB:doNpcRespawnMsg(type, layerID)
	if (not NWB:checkEventStatus("npcRespawnMsg", type)) then
		return;
	end
	local layerMsg = "";
	if (NWB.isLayered and tonumber(layerID)) then
		local layer = NWB:GetLayerNum(layerID);
		layerMsg = " (" .. L["Layer"] .. " " .. layer .. ")";
	end
	if (type == "ony") then
		if ((GetServerTime() - onyNpcRespawn) > 40) then
			local msg = "";
			if (NWB.faction == "Horde") then
				msg = L["onyxiaNpcRespawnHorde"] .. layerMsg;
			else
				msg = L["onyxiaNpcRespawnAlliance"] .. layerMsg;
			end
			if (NWB.db.global.chatNpcKilled and not NWB.db.global.ignoreKillData) then
				NWB:print(msg, nil, nil, true);
			end
			onyNpcRespawn = GetServerTime();
		end
	elseif (type == "nef") then
		if ((GetServerTime() - nefNpcRespawn) > 40) then
			local msg = "";
			if (NWB.faction == "Horde") then
				msg = L["nefarianNpcRespawnHorde"] .. layerMsg;
			else
				msg = L["nefarianNpcRespawnAlliance"] .. layerMsg;
			end
			if (NWB.db.global.chatNpcKilled and not NWB.db.global.ignoreKillData) then
				NWB:print(msg, nil, nil, true);
			end
			nefNpcRespawn = GetServerTime();
		end
	end
end

function NWB:doHandIn(id, layer, sender)
	if (NWB.db.global.handInMsg) then
		local realm, onCooldown;
		if (sender and string.match(sender, "-")) then
			sender, realm = strsplit("-", sender, 2);
		end
		local msg, type, questType = "", "", "";
		if (id == "4974") then
			type = "rend";
			msg = "Rend";
		elseif (id == "7491") then
			type = "ony";
			msg = "Onyxia";
		elseif (id == "7784") then
			type = "nef";
			msg = "Nefarian";
		elseif (id == "7496") then
			type = "ony";
			msg = "Onyxia";
		elseif (id == "7782") then
			type = "nef";
			msg = "Nefarian";
		elseif (id == "8183") then
			type = "zan";
			msg = "Zandalar";
		else
			return;
		end
		if (type == "rend" or type == "ony" or type == "nef") then
			local time = (NWB.data[type .. "Timer"] + NWB[type .. "CooldownTime"]) - GetServerTime();
			if (time > 0) then
				onCooldown = true;
			end
		end
		if ((type == "rend" and (GetTime() - lastRendHandIn) < 120)
				or (type == "ony" and type == "ony" and (GetTime() - lastOnyHandIn) < 120)
				or (type == "nef" and (GetTime() - lastNefHandIn) < 120)
				or (type == "zan" and (GetTime() - lastZanHandIn) < 60)) then
			return;
		end
		if (id == "4974") then
			lastRendHandIn = GetTime();
		elseif (id == "7491") then
			lastOnyHandIn = GetTime();
		elseif (id == "7784") then
			lastNefHandIn = GetTime();
		elseif (id == "7496") then
			lastOnyHandIn = GetTime();
		elseif (id == "7782") then
			lastNefHandIn = GetTime();
		elseif (id == "8183") then
			lastZanHandIn = GetTime();
		end
		msg = msg .. " quest handed in by " .. sender .. ".";
		if (NWB.db.global.middleHandInMsg) then
			if (NWB.db.global.middleHandInMsgWhenOnCooldown or not onCooldown) then
				NWB:middleScreenMsg("questHandIn", msg, nil, 5);
			end
		end
		NWB:print(msg);
	end
end

--/run NWB:sendBigWigs(14, "[NWB] Rallying Cry of the Dragonslayer", "ony");