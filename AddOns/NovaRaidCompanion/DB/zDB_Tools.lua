local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

--Map bosses to encounters and handle encounters with more than one boss.
--[[function NRC:getBossFromEncounter(encounterID)
	local data = {};
	--local npcs = {};
	--Check multiple boss encounters first.
	--if (encounterID == 727) then
		--Eredar Twins 25165 and 25166.
		--npcs = {25165, 25166}
	--end
	--if (next(npcs)) then
	--	for k, v in pairs(npcs) do
	--		
	--	end
	--else
		for k, v in pairs(NRC.npcs) do
			if (v.encounterID == encounterID) then
				table.insert(data, v);
			end
		end
	--end
	return data;
end]]

function NRC:convertBossName(name)
	if (name == "Grand Warlock Alythess" or name == "Lady Sacrolash") then
		return "The Eredar Twins";
	end
	return name;
end

--Get which boss drops a certain item.
--Supply a logID and timestamp to chek for multiple bosses.
--checkMultipleBosses is just a backup thing that's not used atm for the backup check further down.
function NRC:getBossFromLoot(itemID, instanceID, logID, timestamp, checkMultipleBosses)
	if (logID and timestamp) then
		local bossData;
		--If multiple bosses drop this item then we need to get closest timestamp encounter that matches the loot.
		local data = NRC.db.global.instances[logID];
		if (data) then
			local bosses = {};
			for k, v in pairs(NRC.npcs) do
				if (v.loot and v.loot[itemID]) then
					bosses[k] = v;
				end
			end
			local encounters = data.encounters;
			local diff = 9999999999;
			local lootEncounterID;
			--Get the closest encounterID boss kill time to our loot time.
			for encounter, encounterData in pairs(encounters) do
				local d = math.abs(timestamp - (encounterData.endTime or encounterData.startTime))
				if (d < diff) then
					lootEncounterID = encounterData.encounterID;
					diff = d;
				end
			end
			--Match our lootEncounterID to the right boss loot.
			for k, v in pairs(bosses) do
				if (lootEncounterID and lootEncounterID == v.encounterID) then
					bossData = v;
				end
			end
		end
		if (bossData) then
			bossData.name = NRC:convertBossName(bossData.name);
			return bossData;
		end
	end
	--Fallback if nothing found.
	if (not checkMultipleBosses) then
		if (instanceID) then
			for k, v in pairs(NRC.npcs) do
				if (v.loot and v.loot[itemID]) then
					return v;
				end
			end
		else
			for k, v in pairs(NRC.npcs) do
				--Some loot drops in 2 diff instances like tier so we need to get the right boss for the current instance log.
				if (v.loot and v.loot[itemID] and v.instanceID == instanceID) then
					return v;
				end
			end
		end
	else
		local bosses = {};
		local count = 0;
		if (instanceID) then
			for k, v in pairs(NRC.npcs) do
				if (v.loot and v.loot[itemID]) then
					bosses[v] = v;
					count = count + 1;
				end
			end
		else
			for k, v in pairs(NRC.npcs) do
				--Some loot drops in 2 diff instances like tier so we need to get the right boss for the current instance log.
				if (v.loot and v.loot[itemID] and v.instanceID == instanceID) then
					bosses[v] = v;
					count = count + 1;
				end
			end
		end
		if (next(bosses)) then
			if (count == 1) then
				return next(bosses);
			else
				local data = next(bosses)
				data.name = L["Multiple Boss Drop"];
				return data;
			end
		end
	end
end

function NRC:getBossFromEncounter(encounterID)
	for k, v in pairs(NRC.npcs) do
		if (v.encounterID == encounterID) then
			return v;
		end
	end
end

function NRC:isLootFromEncounter(itemID, encounterID)
	for k, v in pairs(NRC.npcs) do
		if (v.encounterID == encounterID) then
			if (v.loot[itemID]) then
				return true;
			end
		end
	end
end

--If a boss HP or creature type doesn't match our local db then record and save the data to use as an override.
--Incase of buff/nef or whatever else might change it.
if (NRC.isDebug) then
	local invalidTypes = {
		["Not specified"] = true,
	};
	local f = CreateFrame("Frame");
	f:RegisterEvent("PLAYER_TARGET_CHANGED");
	f:SetScript('OnEvent', function(self, event, ...)
		if (not NRC.isDebug) then
			return;
		end
		if (event == "PLAYER_TARGET_CHANGED") then
			local guid = UnitGUID("target");
			if (guid) then
				local _, _, _, _, _, npcID = strsplit("-", guid);
				npcID = tonumber(npcID);
				--if (((NRC.raid and UnitClassification("target") == "worldboss") or NRC.npcs[npcID]) and not UnitInBattleground("player")) then
				if ((UnitClassification("target") == "worldboss" or NRC.npcs[npcID]) and not UnitInBattleground("player")) then
					local db = NRC.db.global.npcData;
					local dbLocal = NRC.npcs[npcID];
					local hpDB, hpLocal, typeDB, typeLocal, armorDB, armorLocal;
					if (db[npcID]) then
						hpDB = db[npcID].hp;
						typeDB = db[npcID].type;
						armorDB = db[npcID].armor;
					end
					if (dbLocal) then
						hpLocal = dbLocal.hp;
						typeLocal = dbLocal.type;
						armorLocal = dbLocal.armor;
					end
					if (npcID ~= 23577) then --Halazzi, multi phase hp changing boss.
						local hp = UnitHealthMax("target");
						if (hp and hp > 0 and hp ~= hpDB and hp ~= hpLocal) then
							if (not db[npcID]) then
								db[npcID] = {};
							end
							NRC:debug("Recording npc HP", UnitName("target"), hp, hpDB, hpLocal);
							db[npcID].hp = hp;
						end
					end
					local type = UnitCreatureType("target");
					if (type and type ~= "" and not invalidTypes[type] and type ~= typeDB and type ~= typeLocal) then
						if (not db[npcID]) then
							db[npcID] = {};
						end
						NRC:debug("Recording npc creature type", UnitName("target"), type, typeDB, typeLocal);
						db[npcID].type = type;
					end
					--[[if (NRC.isDebug) then
						local baseArmor = UnitArmor("target");
						if (baseArmor and baseArmor ~= armorDB and baseArmor ~= armorLocal) then
							if (not db[npcID]) then
								db[npcID] = {};
							end
							NRC:debug("Recording npc armor", UnitName("target"), baseArmor, armorDB, armorLocal);
	
							db[npcID].armor = baseArmor;
						end
					end]]
				end
			end
		end
	end)
end