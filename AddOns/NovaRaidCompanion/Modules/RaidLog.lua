-------------------------------
---NovaRaidCompanion Raid Log--
-------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local raidLogFrame, raid, raidName, encounter, raidLogModelFrame, portableModelFrame, bossViewFrame;
local logRenameFrame, lootRenameFrame, tradeFilterFrame, exportFrame, tradeFilterString;
local lastEnteringWorld = 0;
local lastEncounterSuccess = {};
local badges = {};
local currentLootData = {};
local units = NRC.units;
local strmatch = strmatch;
local strfind = strfind;
local strsplit = strsplit;
local GetTime = GetTime;
local select = select;
local bitband = bit.band;
local tonumber = tonumber;
local tinsert = tinsert;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local GetServerTime = GetServerTime;
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local UnitName = UnitName;
	
local lastLooted = {};
function NRC:chatMsgLoot(...)
	if (not NRC.raid) then
		return;
	end
	local msg = ...;
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
				itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
    --Get itemlink by checking all possible matches for self loot msgs and other players loot msg.
    --Check multiple msgs first so you dont end up with item links with x2 on the end.
    --Self receive multiple loot "You receive loot: [Item]x2"
    local amount;
    local name = UnitName("Player");
    local otherPlayer;
    --Self loot multiple item "You receive loot: [Item]x2"
	local itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
	if (not itemLink) then
 		--Self receive single loot "You receive loot: [Item]"
    	itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
		if (not itemLink) then
			--Self receive multiple item "You receive item: [Item]x2"
			--itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
			--itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
			if (not itemLink) then
	 			--Self receive single item "You receive item: [Item]"
				--itemLink = msg:match(LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"));
			end
    	end
    end
    --If no matches for self loot then check other player loot msgs.
    if (not itemLink) then
    	otherPlayer = true;
    	--Other player receive multiple loot "Otherplayer receives loot: [Item]x2"
    	name, itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
    	if (not itemLink) then
    		--Other player receive single loot "Otherplayer receives loot: [Item]"
    		name, itemLink = msg:match("^" .. LOOT_ITEM:gsub("%%s", "(.+)"));
			if (not itemLink) then
				--Other player loot multiple item "Otherplayer receives item: [Item]x2"
				name, itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
				if (not itemLink) then
	 				--Other player receive single item "Otherplayer receives item: [Item]"
					name, itemLink = msg:match("^" .. LOOT_ITEM_PUSHED:gsub("%%s", "(.+)"));
				end
			end
    	end
    end
    if (not amount) then
    	amount = 1;
    end
    if (itemLink) then
    	itemName, _, itemRarity, itemLevel, itemMinLevel, itemType,
				itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(itemLink);
		--if ((itemClassID == 12 and bindType  == 4) or (itemClassID == "Trade Goods" and itemSubType == "Enchanting")) then
		if (itemClassID == 7 and itemSubClassID == 12) then
			--Enchanting items.
			--We don't need to exclude quest items because we don't track white items and we don't want to exlude mags head etc.
			return;
		end
		--Some addons change the payload of the chat loot event, extract the itemLink and reform it.
		local color, item = strmatch(itemLink, "|c(%w+)|H(.+)|h|r");
		if (color and item) then
			itemLink = "|c" .. color .. "|H" .. item .. "|h|r";
		end
    end
    if (itemLink and name) then
    	--local _, itemID = strsplit(":", itemLink);
    	local itemID = strmatch(itemLink, "item:(%d+)");
    	if (itemID) then
    		if (tonumber(itemID) == 29434) then --Badge of Justice.
    			badges[name] = tonumber(itemID);
    		end
    		if (NRC.ignoredLoot[tonumber(itemID)]) then
    			return;
    		end
    	end
		local _, _, itemRarity = GetItemInfo(itemLink);
		--0 	Poor 	Poor 	ITEM_QUALITY0_DESC
		--1 	Common 	Common 	ITEM_QUALITY1_DESC
		--2 	Uncommon 	Uncommon 	ITEM_QUALITY2_DESC
		--3 	Rare 	Rare 	ITEM_QUALITY3_DESC
		--4 	Epic 	Epic 	ITEM_QUALITY4_DESC
		--5 	Legendary 	Legendary 	ITEM_QUALITY5_DESC
		--6 	Artifact 	Artifact 	ITEM_QUALITY6_DESC
		--7 	Heirloom 	Heirloom 	ITEM_QUALITY7_DESC
		--8 	WoWToken 	WoW Token 	ITEM_QUALITY8_DESC
		if (itemRarity and itemRarity >= 2) then
			--If we're recording above a certain level
			NRC:addLoot(name, itemLink, amount, itemRarity);
		elseif (itemRarity and itemRarity >= 1) then
			--If we're recording all non-greys.
			--NRC:addLoot(name, itemLink, amount, itemRarity, time);
		end
		--NRC:sendCmd("lootAnnounce " .. data);
	end
end

local lastEncounterEnd = {};
function NRC:addLoot(name, itemLink, amount, itemRarity)
	--NRC:debug("Loot", name, itemLink, amount, itemRarity);
	--No need to store amount if it's only 1 for now.
	--Maybe if we're grouping items together later we'll need the amount.
	if (amount == 1) then
		amount = nil;
	end
	if (NRC.raid and itemLink) then
		local t = {
			name = name,
			itemLink = itemLink,
			itemRarity = itemRarity,
			time = GetServerTime(),
		};
		if (amount and tonumber(amount)) then
			t.amount = tonumber(amount);
		end
		--Attach an id if looted within 5mins of boss, just to improve some accuracy with item source.
		--Probably change this to just epics and green+ patterns later.
		if (lastEncounterEnd.time and GetServerTime() - lastEncounterEnd.time < 300 and itemRarity and itemRarity > 2) then
			t.lastEncounterID = lastEncounterEnd.encounterID;
		end
		tinsert(NRC.raid.loot, t);
	end
end

SLASH_NRCBADGESCMD1, SLASH_NRCBADGESCMD2 = '/badge', '/badges';
function SlashCmdList.NRCBADGESCMD(msg, editBox)
	if (NRC.isTBC) then
		local encounterNameText = "";
		if (lastEncounterSuccess and lastEncounterSuccess.encounterName) then
			encounterNameText = " for " .. lastEncounterSuccess.encounterName;
		end
		local header = "Unlooted Badges" .. encounterNameText .. ": ";
		local text = header;
		local count = 0;
		if (next(badges)) then
			for i = 1, GetNumGroupMembers() do
				local name, _, _, _, _, classEnglish = GetRaidRosterInfo(i);
				local _, _, _, classHex = GetClassColor(classEnglish);
				local colorizedName = "|c" .. classHex .. name .. "|r";
				local realm;
				if (name and not badges[name]) then
					count = count + 1;
					if (count == 1) then
						text = text .. colorizedName
					else
						text = text  .. ", " .. colorizedName;
					end
				end
			end
		end
		if (text == header) then
			NRC:print("No missing badges to display" .. encounterNameText .. ".");
		else
			msg = string.lower(msg);
			text = text .. ".";
			if (msg == "raid" or msg == "party" or msg == "group") then
				NRC:sendGroup("[NRC] " .. NRC:stripColors(text), true)
			elseif (msg == "guild") then
				if (IsInGuild()) then
					SendChatMessage("[NRC] " .. NRC:stripColors(text), "GUILD");
				else
					NRC:print(text);
				end
			else
				NRC:print(text)
			end
		end
	else
		NRC:print("This command only works in TBC, you can't see other people looting badges in Wrath because it's now a currency and not an item so the addon can't track it.");
	end
end

local function removeKtWeapons()
	local data = NRC.raid;
	if (not data) then
		return;
	end
	local ktWeapons = {
		[30312] = "Infinity Blade",
		[30311] = "Warp Slicer",
		[30317] = "Cosmic Infuser",
		[30316] = "Devastation",
		[30313] = "Staff of Disintegration",
		[30314] = "Phaseshift Bulwark",
		[30318] = "Netherstrand Longbow",
		[30319] = "Nether Spike",
	};
	local count = 0;
	local loot = data.loot;
	if (loot) then
		--Iterate backwards when removing elements.
		for i = #data.loot, 1, -1 do
			if (loot[i].itemLink) then
				--local _, itemID = strsplit(":", loot[i].itemLink);
				local itemID = strmatch(loot[i].itemLink, "item:(%d+)");
				if (itemID) then
					itemID = tonumber(itemID);
				end
				if (ktWeapons[itemID]) then
					count = count + 1;
					table.remove(data.loot, i);
				end
			end
		end
	end
end

local function addEncounterCount(encounterID, success)
	local char = UnitName("player");
	if (not NRC.data.myChars[char]) then
		NRC.data.myChars[char] = {};
	end
	if (not NRC.data.myChars[char].encounters) then
		NRC.data.myChars[char].encounters = {};
	end
	if (not NRC.data.myChars[char].encounters[encounterID]) then
		NRC.data.myChars[char].encounters[encounterID] = {};
		NRC.data.myChars[char].encounters[encounterID].kill = 0;
		NRC.data.myChars[char].encounters[encounterID].wipe = 0;
	end
	if (success == 1) then
		NRC.data.myChars[char].encounters[encounterID].kill = NRC.data.myChars[char].encounters[encounterID].kill + 1;
	else
		NRC.data.myChars[char].encounters[encounterID].wipe = NRC.data.myChars[char].encounters[encounterID].wipe + 1;
	end
end

local function removeEncounterKillCount(encounterID)
	local char = UnitName("player");
	local data = NRC.data.myChars[char];
	if (data and data.encounters and data.encounters[encounterID]
			and data.encounters[encounterID].kill and data.encounters[encounterID].kill > 0) then
		NRC.data.myChars[char].encounters[encounterID].kill = NRC.data.myChars[char].encounters[encounterID].kill - 1;
	end
end

local function removeEncounterWipeCount(encounterID)
	local char = UnitName("player");
	local data = NRC.data.myChars[char];
	if (data and data.encounters and data.encounters[encounterID]
			and data.encounters[encounterID].wipe and data.encounters[encounterID].wipe > 0) then
		NRC.data.myChars[char].encounters[encounterID].wipe = NRC.data.myChars[char].encounters[encounterID].wipe - 1;
	end
end

local function haveTalentsChanged()
	if (NRC.raid) then
		local lastRecorded, found;
		--Get last recorded talents.
		if (NRC.raid.encounters) then
			for k, v in ipairs(NRC.raid.encounters) do
				if (v.talentCache) then
					found = true;
					lastRecorded = v.talentCache;
				end
			end
		end
		if (not found) then
			--No talents recorded, must be first boss.
			return true;
		end
		--Compare our last recorded talents and our current talent cache for any changes.
		for k, v in pairs(NRC.talents) do
			if (not lastRecorded[k] or lastRecorded[k] ~= v) then
				return true;
			end
		end
	end
end

function NRC:encounterStartRD(...)
	local encounterID, encounterName, difficultyID, groupSize = ...;
	if (NRC.raid) then
		encounter = {
			encounterID = encounterID,
			encounterName = encounterName,
			difficultyID = difficultyID,
			groupSize = groupSize,
			auraCache = NRC:tableCopyAuras(NRC.auraCache),
			startTime = GetServerTime(),
			startGetTime = GetTime(),
		};
		if (NRC.isTBC or NRC.isClassic) then
			--No need to store this data for log lookup in wrath.
			encounter.resCache = NRC:tableCopy(NRC.resistances);
			encounter.weaponEnchantCache = NRC:tableCopy(NRC.weaponEnchants);
		end
		--Check if talents have changed and only record if they are different.
		--We don't want to record talent cache for every boss to save load times.
		--Encounters are saved in order so we can just check last recorded talents before the encounter for buff snapshot viewing.
		if (haveTalentsChanged()) then
			--Recording talent cache.
			--encounter.talentCache = NRC:tableCopy(NRC.talents);
			encounter.talentCache = NRC:copyRaidTalents();
		end
	end
	NRC:debug("Encounter start", ...);
end

function NRC:encounterEndRD(encounterID, encounterName, difficultyID, groupSize, success)
	if (NRC.raid) then
		if (encounter and GetServerTime() - encounter.startTime < 20) then
			encounter = nil;
			return;
		elseif (encounter) then
			encounter.success = success;
			encounter.endTime = GetServerTime();
			encounter.endGetTime = GetTime(),
			tinsert(NRC.raid.encounters, encounter);
			encounter = nil;
			lastEncounterEnd = {
				encounterID = encounterID,
				time = GetServerTime()
			};
			--We don't want to record legendary loot if we wiped on KT or data could get too big, only record for the kill.
			if (encounterID == 733 and not success) then
				removeKtWeapons();
			end
			addEncounterCount(encounterID, success);
		end
	end
	NRC:debug("Encounter end", encounterID, encounterName, difficultyID, groupSize, success);
	--Why does this fail to get data sometimes.
	C_Timer.After(3, function()
		NRC:recordLockoutData();
	end)
	--Retry as a backup.
	C_Timer.After(10, function()
		NRC:recordLockoutData();
	end)
	if (success == 1) then
		lastEncounterSuccess.encounterID = encounterID;
		lastEncounterSuccess.encounterName = encounterName;
		lastEncounterSuccess.success = success;
		lastEncounterSuccess.endTime = GetServerTime();
		badges = {};
	end
end

--Some items don't get a combat log event so we need this instead.
local castCache, feignCache = {}, {};
local function unitSpellcastSucceededRD(...)
	if (NRC.raid) then
		--guid is a spell cast guid not a player guid.
		local unit, _, spellID = ...;
		local guid = UnitGUID(unit);
		if (units[unit]) then
			if (NRC.trackedItems[spellID]) then
				--Use a cache to make sure we only record 1 item use when fired from multiple events.
				--We have to check multiple events because some spells/items only fire 1 type.
				if (not castCache[guid] or not castCache[guid][spellID] or GetTime() - castCache[guid][spellID] > 0.8) then
					NRC:addTrackedItem(guid, spellID);
				end
				if (not castCache[guid]) then
					castCache[guid] = {};
				end
				castCache[guid][spellID] = GetTime();
			end
			if (spellID == 5384) then
				local guid = UnitGUID(unit);
				if (guid) then
					feignCache[guid] = GetTime();
				end
			end
		end
	end
end

--Comabt log event only does certain spells, doesn't fire for spells cast from using items?
function NRC:addTrackedItem(guid, spellID)
	local raid = NRC.raid;
	if (not raid) then
		return;
	end
	local encounterID;
	if (encounter and encounter.encounterID) then
		encounterID = encounter.encounterID;
	end
	NRC:addToGroupData(nil, guid, true);
	local t = {
		timestamp = GetServerTime(),
		getTime = GetTime(),
		encounterID = encounterID,
	};
	if (not raid.group[guid].trackedItems[spellID]) then
		raid.group[guid].trackedItems[spellID] = {};
	end
	tinsert(raid.group[guid].trackedItems[spellID], t);
end

local overkillCache, deathCache = {}, {};
local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, spellID, spellName = ...;
	if (NRC.raid) then
		local raid = NRC.raid;
		if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE"
				or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "SPELL_BUILDING_DAMAGE"
				or subEvent == "ENVIRONMENTAL_DAMAGE") then
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
			if (subEvent == "SWING_DAMAGE") then
				amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...);
				spellID = 0;
				spellName = "Melee";
			elseif (subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "SPELL_BUILDING_DAMAGE"
					or subEvent == "RANGE_DAMAGE") then
				spellID, spellName, school, amount, overkill, school, resisted, blocked, absorbed, critical,
						glancing, crushing, isOffHand = select(12, ...);
			elseif (subEvent == "ENVIRONMENTAL_DAMAGE") then
				spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...);
				spellID = 0;
			else
				return;
			end
			--Overkill is 0 for environment and -1 for other?
			--if (strfind(destGUID, "Player") and overkill ~= -1) then
			if (strfind(destGUID, "Player")) then
			--if (strfind(destGUID, "Player") and overkill ~= -1 and overkill ~= 0) then
			--if (strfind(destGUID, "Player") and overkill ~= -1 and (overkill ~= 0 and subEvent == "ENVIRONMENTAL_DAMAGE")) then
			--if (strfind(destGUID, "Player")) then
				--print("overkill", overkill)
				--print(spellName, spellID, amount, overkill, resisted, blocked, absorbed, critical, glancing, crushing)
				overkillCache[destName] = {
					timestamp = timestamp,
					getTime = GetTime(),
					spellName = spellName,
					spellID = spellID,
					spellSchool = school,
					amount = amount,
					overkill = overkill,
					resisted = resisted,
					blocked = blocked,
					absorbed = absorbed,
					sourceName = sourceName,
				};
				--Record if a player was hostile (MC'd).
				if (bitband(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE) then
					overkillCache[destName].hostileDest = true;
				end
				if (strfind(sourceGUID, "Player") and bitband(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE) then
					overkillCache[destName].hostileSource = true;
				end
				if (critical) then
					overkillCache[destName].critical = true;
				end
				if (glancing) then
					overkillCache[destName].glancing = true;
				end
				if (crushing) then
					overkillCache[destName].crushing = true;
				end
			end
			--if (sourceGUID and strfind(sourceGUID, "Creature")) then
			--	NRC:parseGUIDRD(nil, sourceGUID, "combatlogSourceGUID");
			--elseif (destGUID and strfind(destGUID, "Creature")) then
			--	NRC:parseGUIDRD(nil, destGUID, "combatlogDestGUID");
			--end
		elseif (subEvent == "SPELL_CAST_SUCCESS") then
			if (NRC.trackedItems[spellID]) then
				if (NRC:inOurGroup(sourceGUID)) then
					if (not castCache[sourceGUID] or not castCache[sourceGUID][spellID] or GetTime() - castCache[sourceGUID][spellID] > 0.8) then
						NRC:addTrackedItem(sourceGUID, spellID);
					end
					if (not castCache[sourceGUID]) then
						castCache[sourceGUID] = {};
					end
					castCache[sourceGUID][spellID] = GetTime();
				end
			end
		elseif (subEvent == "UNIT_DIED") then
			local _, _, _, _, zoneID, npcID = strsplit("-", destGUID);
			zoneID = tonumber(zoneID);
			npcID = tonumber(npcID);
			local encounterID;
			if (encounter and encounter.encounterID) then
				encounterID = encounter.encounterID;
			end
			if (strfind(destGUID, "Player")) then
				local t = {
					timestamp = timestamp,
					encounterID = encounterID,
				};
				local lastDmgTime = 0;
				--Check if we saw them take dmg.
				if (overkillCache[destName]) then
					t.sourceName = overkillCache[destName].sourceName;
					t.spellID = overkillCache[destName].spellID;
					t.spellName = overkillCache[destName].spellName;
					t.spellSchool = overkillCache[destName].spellSchool;
					t.totalAmount = overkillCache[destName].amount;
					t.overkill = overkillCache[destName].overkill;
					t.resisted = overkillCache[destName].resisted;
					t.blocked = overkillCache[destName].blocked;
					t.absorbed = overkillCache[destName].absorbed;
					t.critical = overkillCache[destName].critical;
					t.glancing = overkillCache[destName].glancing;
					t.crushing = overkillCache[destName].crushing;
					t.hostileDest = overkillCache[destName].hostileDest;
					t.hostileSource = overkillCache[destName].hostileSource;
					if (overkillCache[destName]) then
						lastDmgTime = overkillCache[destName].getTime or 0;
					else
						lastDmgTime = 0;
					end
					overkillCache[destName] = nil;
				else
					--NRC:debug(destName, "died without dmg recorded")
				end
				local _, class = GetPlayerInfoByGUID(destGUID);
				if (class == "PRIEST" and deathCache[destGUID] and GetTime() - deathCache[destGUID] < 17) then
					--This is most likely spirit of redemption, I'll find a better way to rule this out later.
					--It's possible to legit die twice fast twice with a soulstone or bres.
					--Maybe check for auras and set a isSpiritOfRedemption state?
					--Or check for dmg taken since last death with overkillCache.
					--But we need to be sure we're covering all dmg type events there first.
					--if (class == "PRIEST" and not overkillCache[destName] or GetServerTime() - overkillCache[destName] > 4) then
					--But what if only the second death sends an event? Then it would fail if we're only checking dmg within the last few seconds.
				elseif (class == "HUNTER" and feignCache[destGUID] and GetTime() - feignCache[destGUID] < 1) then
					--If a hunter feigned death within the last second.
					--NRC:debug(destName, "hunter feigned, not recording death");
					overkillCache[destName] = nil;
				elseif (class == "HUNTER" and feignCache[destGUID] and GetTime() - lastDmgTime > 3) then
					--If dmg taken too long ago before death.
					--NRC:debug(destName, "hunter dmg taken too long ago, not recording death");
					overkillCache[destName] = nil;
				--elseif (GetTime() - lastDmgTime < 3) then
				else
					NRC:addToGroupData(nil, destGUID, true);
					tinsert(raid.group[destGUID].deaths, t);
					if (lastEnteringWorld < GetTime() - 5) then
						--Add scrolling raid event.
						local _, destClass  = GetPlayerInfoByGUID(destGUID);
						NRC:sreDeathEvent(destName, destClass)
					end
					--NRC:pushDeath(destGUID);
				end
				deathCache[destGUID] = GetTime();
				--NRC:addToGroupData(nil, destGUID, true);
				--tinsert(raid.group[destGUID].deaths, t);
			elseif (strfind(destGUID, "Creature")
					and bitband(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE) then
				if (not NRC.critterCreatures[npcID] and not NRC.companionCreatures[npcID] and not NRC.ignoredCreatures[npcID]) then
					if (not raid.npcDeaths[npcID]) then
						raid.npcDeaths[npcID] = {};
						raid.npcDeaths[npcID].name = destName;
						raid.npcDeaths[npcID].count = 1;
					else
						raid.npcDeaths[npcID].count = raid.npcDeaths[npcID].count + 1;
					end
					if (not raid.firstTrash) then
						raid.firstTrash = GetServerTime();
					end
				end
			end
			if (npcID == 21216) then
				--Hydross the Unstable has no encounter_end success event so add it manually.
				--Just incase it one day starts working add a check for success already there.
				--Not sure if encounter end fires first or death event fires first always in the same order.
				--So check if encounter still running first.
				--if (encounter and encounter.encounterID == 623) then
				--	encounter.success = 1;
				--elseif (raid) then
				if (raid) then
					--I think sometimes death fires before encounter_end and then encounter_end overwrites our success here with a failure.
					--So add a short delay.
					C_Timer.After(2, function()
						--Make sure Hydross was the last encounter and only update the last entry.
						local last;
						local count;
						for k, v in ipairs(raid.encounters) do
							last = v;
							count = k;
						end
						if (last.encounterID == 623) then
							if (raid.encounters[count].success ~= 1) then
								raid.encounters[count].success = 1;
								--Update kill stats for this boss.
								addEncounterCount(623, 1);
								removeEncounterWipeCount(623);
							end
						end
					end)
				end
			end
		end
	end
end

local function getEncounterData(id)
	if (NRC.encounters[id]) then
		return unpack(NRC.encounters[id]);
	end
end

local function getInstanceTextures(id)
	if (NRC.instanceTextures[id]) then
		return unpack(NRC.instanceTextures[id]);
	end
end

local function getDeathData(id)
	local data = NRC.db.global.instances[id];
	if (not data) then
		return;
	end
	local count, bossCount, trashCount = 0, 0, 0;
	local deathData = {};
	if (data.group) then
		for guid, playerData in pairs(data.group) do
			if (playerData.deaths) then
				for k, v in pairs(playerData.deaths) do
					count = count + 1;
					if (not deathData[playerData.name]) then
						deathData[playerData.name] = {};
					end
					v.class = playerData.class;
					tinsert(deathData[playerData.name], v);
					if (v.encounterID) then
						bossCount = bossCount + 1;
					else
						trashCount = trashCount + 1;
					end
				end
			end
		end
	end
	return count, bossCount, trashCount, deathData;
end

local function getDeathsByEncounter(id, encounterID)
	local data = NRC.db.global.instances[id];
	if (not data) then
		return;
	end
	local count = 0;
	local deathData = {};
	if (data.group) then
		for guid, playerData in pairs(data.group) do
			for k, v in pairs(playerData.deaths) do
				if (v.encounterID == encounterID) then
					count = count + 1;
					if (not data[playerData.name]) then
						deathData[playerData.name] = {};
					end
					tinsert(deathData[playerData.name], v);
				end
			end
		end
	end
	return count, deathData;
end

local function getConsumeData(id, encounterID, attemptID, guidOnly)
	local data = NRC.db.global.instances[id];
	if (not data) then
		return;
	end
	local consumeData = {};
	--Create a structure of item uses mapped to a name.
	--[[[name] = {
		[playerName] = {
			[1] = {
				spellID,
				itemID,
				icon,
				quality,
				timestamp,
				getTime,
				encounterID;
			},
		},
	};]]
	if (data.group) then
		local startTime, endTime;
		if (data.encounters and data.encounters[attemptID]) then
			if (data.encounters[attemptID].startGetTime) then
				startTime = data.encounters[attemptID].startGetTime;
			end
			if (data.encounters[attemptID].endGetTime) then
				endTime = data.encounters[attemptID].endGetTime;
			end
		end
		for guid, playerData in pairs(data.group) do
			if (playerData.trackedItems and (not guidOnly or guidOnly == guid)) then
				for spellID, itemUsage in pairs(playerData.trackedItems) do
					local enabled;
					local config = NRC.config;
					if (config.itemUseShowConsumes and (NRC.trackedConsumes[spellID] or NRC.flasks[spellID]
							or NRC.battleElixirs[spellID] or NRC.guardianElixirs[spellID])) then
						enabled = true;
					elseif (config.itemUseShowRacials and NRC.racials[spellID]) then
						enabled = true;
					elseif (config.itemUseShowScrolls and NRC.scrolls[spellID]) then
						enabled = true;
					elseif (config.itemUseShowInterrupts and NRC.interrupts[spellID]) then
						enabled = true;
					elseif (config.itemUseShowFood and NRC.foods[spellID]) then
						enabled = true;
					end
					if (enabled) then
						for usageID, usageData in pairs(itemUsage) do
							--If specific attempt specified get all within the start and end time.
							if (attemptID) then
								local itemDataLocal = NRC.trackedItems[spellID];
								if (itemDataLocal and startTime and endTime) then
									if (usageData.getTime and usageData.getTime > startTime and usageData.getTime < endTime) then
										if (not consumeData[playerData.name]) then
											consumeData[playerData.name] = {
												class = playerData.class;
											};
										end
										local t = {
											--itemID is not the same as spellID, spellIDs are the spell the item casts when used.
											spellID = spellID,
											itemID = itemDataLocal.itemID,
											icon = itemDataLocal.icon,
											itemIcon = itemDataLocal.itemIcon,
											quality = itemDataLocal.quality,
											timestamp = usageData.timestamp,
											getTime = usageData.getTime,
											encounterID = usageData.encounterID;
										};
										tinsert(consumeData[playerData.name], t);
									end
								end
							else
								local itemDataLocal = NRC.trackedItems[spellID];
								if (itemDataLocal) then
									if (not consumeData[playerData.name]) then
										consumeData[playerData.name] = {};
										consumeData[playerData.name].class = playerData.class;
									end
									local t = {
										--itemID is not the same as spellID, spellIDs are the spell the item casts when used.
										spellID = spellID,
										itemID = itemDataLocal.itemID,
										icon = itemDataLocal.icon,
										itemIcon = itemDataLocal.itemIcon,
										quality = itemDataLocal.quality,
										timestamp = usageData.timestamp,
										getTime = usageData.getTime,
										encounterID = usageData.encounterID;
									};
									tinsert(consumeData[playerData.name], t);
								end
							end
						end
					end
				end
			end
		end
	end
	return consumeData;
end

local function getTradeData(logID, raidID)
	local data;
	if (logID and raidID) then
		data = {};
		for k, v in ipairs(NRC.db.global.trades) do
			if (v.raidID == raidID) then
				tinsert(data, v);
			end
		end
	else
		data = NRC.db.global.trades;
	end
	if (tradeFilterString) then
		--local words = {};
		--for word in string.gmatch(tradeFilterString, "%w+") do
		--	tinsert(words, word);
		--end
		--for _, word in pairs(words) do
			local filter = tradeFilterString;
			local filterNum = tonumber(tradeFilterString);
			local t = {};
			for k, v in ipairs(data) do
				local found;
				if (filterNum) then
					if (v.playerMoney) then
						local gold = math.floor(v.playerMoney / 100 / 100);
						--local silver = math.floor((v.playerMoney / 100) % 100);
						--local copper = math.floor(v.playerMoney % 100);
						if (filterNum == gold) then
							tinsert(t, v);
							found = true;
						end
					end
					if (not found) then
						if (v.targetMoney) then
							local gold = math.floor(v.targetMoney / 100 / 100);
							--local silver = math.floor((v.targetMoney / 100) % 100);
							--local copper = math.floor(v.targetMoney % 100);
							if (filterNum == gold) then
								tinsert(t, v);
								found = true;
							end
						end
					end
				end
				if (not found) then
					if ((v.me and strfind(string.lower(v.me), filter))
							or (v.tradeWho and strfind(string.lower(v.tradeWho), filter))
							or (v.itemLink and strfind(string.lower(v.itemLink), filter))
							or (v.tradeWho and strfind(string.lower(v.tradeWho), filter))) then
						tinsert(t, v);
					elseif (v.playerItems and next(v.playerItems)) then
						for item, itemData in pairs(v.playerItems) do
							local name;
							if (itemData.itemLink) then
								name = strfind(itemData.itemLink, "%[.+%]");
							end
							if ((name and strfind(string.lower(name), filter))
								or (itemData.name and strfind(string.lower(itemData.name), filter))) then
								tinsert(t, v);
							end
						end
					elseif (v.targetItems and next(v.targetItems)) then
						for item, itemData in pairs(v.targetItems) do
							local name;
							if (itemData.itemLink) then
								name = strfind(itemData.itemLink, "%[.+%]");
							end
							if ((name and strfind(string.lower(name), filter))
								or (itemData.name and strfind(string.lower(itemData.name), filter))) then
								tinsert(t, v);
							end
						end
					elseif (v.playerItemsEnchant and next(v.playerItemsEnchant)) then
						for item, itemData in pairs(v.playerItemsEnchant) do
							local name;
							if (itemData.itemLink) then
								name = strfind(itemData.itemLink, "%[.+%]");
							end
							if ((name and strfind(string.lower(name), filter))
								or (itemData.name and strfind(string.lower(itemData.name), filter))
								or (itemData.enchant and strfind(string.lower(itemData.enchant), filter))) then
								tinsert(t, v);
							end
						end
					elseif (v.targetItemsEnchant and next(v.targetItemsEnchant)) then
						for item, itemData in pairs(v.targetItemsEnchant) do
							local name;
							if (itemData.itemLink) then
								name = strmatch(itemData.itemLink, "%[.+%]");
							end
							if ((name and strfind(string.lower(name), filter))
								or (itemData.name and strfind(string.lower(itemData.name), filter))
								or (itemData.enchant and strfind(string.lower(itemData.enchant), filter))) then
								tinsert(t, v);
							end
						end
					end
				end
			end
		--end
		return t;
	end
	return data;
end

function NRC:getTradeData(logID, raidID)
	return getTradeData(logID, raidID);
end

local function getLootData(logID, minQuality, exactQuality, showKtWeapons, encounterID, instanceID, ignoreTradeskill, mapToTrades)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return;
	end
	local ignoreList = {};
	if (not showKtWeapons) then
		--Create list to ignore.
		ignoreList = {
			[30312] = "Infinity Blade",
			[30311] = "Warp Slicer",
			[30317] = "Cosmic Infuser",
			[30316] = "Devastation",
			[30313] = "Staff of Disintegration",
			[30314] = "Phaseshift Bulwark",
			[30318] = "Netherstrand Longbow",
			[30319] = "Nether Spike",
		};
	end
	if (ignoreTradeskill) then
		ignoreList[32228] = "Empyrean Sapphire";
		ignoreList[32249] = "Seaspray Emerald";
		ignoreList[32231] = "Pyrestone";
		ignoreList[32230] = "Shadowsong Amethyst";
		ignoreList[32227] = "Crimson Spinel";
		ignoreList[32229] = "Lionseye";
		ignoreList[34664] = "Sunmote";
		ignoreList[32428] = "Heart of Darkness";
    end
	local count, bossCount, trashCount = 0, 0, 0;
	local lootData = {};
	if (data.loot) then
		for k, v in ipairs(data.loot) do
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				if (itemID) then
					itemID = tonumber(itemID);
				end
				if (not ignoreList[itemID]) then
					if (exactQuality) then
						if (not encounterID or NRC:isLootFromEncounter(itemID, encounterID)) then
							if (v.itemRarity and v.itemRarity == exactQuality) then
								count = count + 1;
								local t = NRC:tableCopy(v);
								t.lootID = k;
								tinsert(lootData, t);
								if (NRC:getBossFromLoot(itemID, instanceID)) then
									bossCount = bossCount + 1;
								else
									trashCount = trashCount + 1;
								end
							end
						end
					elseif (minQuality) then
						if (not encounterID) then
							if (v.itemRarity and v.itemRarity >= minQuality) then
								count = count + 1;
								local t = NRC:tableCopy(v);
								t.lootID = k;
								tinsert(lootData, t);
								if (NRC:getBossFromLoot(itemID, instanceID)) then
									bossCount = bossCount + 1;
								else
									trashCount = trashCount + 1;
								end
							end
						elseif (NRC:isLootFromEncounter(itemID, encounterID)) then
							if (v.itemRarity and v.itemRarity >= minQuality) then
								if (v.lastEncounterID and v.lastEncounterID == encounterID) then
									count = count + 1;
									local t = NRC:tableCopy(v);
									t.lootID = k;
									tinsert(lootData, t);
									if (NRC:getBossFromLoot(itemID, instanceID)) then
										bossCount = bossCount + 1;
									else
										trashCount = trashCount + 1;
									end
								end
							end
						end
					else
						if (not encounterID) then
							count = count + 1;
							local t = v;
							t.lootID = NRC:tableCopy(k);
							tinsert(lootData, t);
							if (NRC:getBossFromLoot(itemID, instanceID)) then
								bossCount = bossCount + 1;
							else
								trashCount = trashCount + 1;
							end
						elseif (NRC:isLootFromEncounter(itemID, encounterID)) then
							if (v.lastEncounterID and v.lastEncounterID == encounterID) then
								count = count + 1;
								local t = v;
								t.lootID = NRC:tableCopy(k);
								tinsert(lootData, t);
								if (NRC:getBossFromLoot(itemID, instanceID)) then
									bossCount = bossCount + 1;
								else
									trashCount = trashCount + 1;
								end
							end
						end
					end
				end
			end
		end
	end
	if (mapToTrades) then
		local trades = getTradeData(logID, data.raidID);
		for k, v in ipairs(lootData) do
			for tradeID, tradeData in ipairs(trades) do
				if (tradeData.playerItems) then
					for _, itemData in pairs(tradeData.playerItems) do
						if (v.itemLink == itemData.itemLink and not v.traded) then
							v.traded = tradeData.tradeWho;
							v.tradedClass = tradeData.tradeWhoClass;
							v.gold = tradeData.targetMoney;
							tremove(trades, tradeID);
						end
					end
				end
			end
		end
	end
	return count, bossCount, trashCount, lootData;
end

function NRC:getLootData(logID, minQuality, exactQuality, showKtWeapons, encounterID, instanceID, ignoreTradeskill, mapToTrades)
	return getLootData(logID, minQuality, exactQuality, showKtWeapons, encounterID, instanceID, ignoreTradeskill, mapToTrades);
end

local function getBossStats(id)
	local data = NRC.db.global.instances[id];
	if (not data) then
		return;
	end
	local bossKills, bossWipes = 0, 0;
	if (data.encounters) then
		for encounterID, encounterData in pairs(data.encounters) do
			if (encounterData.success == 1) then
				bossKills = bossKills + 1;
			else
				bossWipes = bossWipes + 1;
			end
		end
	end
	return bossKills, bossWipes;
end

local function getTrashCount(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return 0;
	end
	local trashCount, otherCount = 0, 0;
	if (next(data.npcDeaths)) then
		if (NRC.zones[data.instanceID] and NRC.zones[data.instanceID].trash and next(NRC.zones[data.instanceID].trash)) then
			--If we have a trash list set then split main trash mobs and other npcs.
			for k, v in pairs(data.npcDeaths) do
				if (NRC.zones[data.instanceID].trash[tonumber(k)]) then
					trashCount = trashCount + v.count;
				elseif (not NRC.zones[data.instanceID].bosses[tonumber(k)]) then
					otherCount = otherCount + v.count;
				end
			end
		else
			--Else add all npcs to the trash list.
			for k, v in pairs(data.npcDeaths) do
				trashCount = trashCount + v.count;
			end
		end
	end
	return trashCount, otherCount;
end

local function getTotalBossCount(zoneID)
	local count = 0;
	if (NRC.zones[zoneID]) then
		count = NRC.zones[zoneID].bossCount or 0;
	end
	return count;
end

--Duration from entered instance to left instance.
local function getRaidDuration(zoneID)
	
end

local logReqs = {
	--Mapped to instanceID, first mob/last mob/type.
	[0] = {
		[1] = 0,
		[2] = 0,
		[3] = L["First Leviathan to Illidan"],
	},
};

--Duration from first event needed for.
local function getRunDuration(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return 0;
	end
	local startTime, endTime;
	local type = "";
	local startEvent;
	--If start is recorded on trash start or some other event then use that as a start point.
	--Diff raids have diff start requirements on WCL, we can roughly match those but this isn't meant as a replacement lookup.
	if (NRC.zones[data.instanceID] and NRC.zones[data.instanceID].startType == "boss") then
		if (next(data.encounters)) then
			for k, v in ipairs(data.encounters) do
				if (not startTime) then
					startTime = v.startTime;
					type = L["Start of first boss to end of last boss"];
				end
				endTime = v.endTime;
			end
		end
	else
		--Look for first trash kill;
		startTime = data.firstTrash;
		if (startTime) then
			type = L["From first trash kill"];
		end
	end
	if (not startTime or not endTime) then
		--If no valid encounter data then use entered and left times.
		startTime = data.enteredTime;
		endTime = data.leftTime;
		type = "";
	end
	--An error occured recording data.
	if (not startTime or not endTime) then
		return 0, "";
	end
	if (logID == 1 and NRC.raid) then
		return GetServerTime() - startTime, type;
	else
		return endTime - startTime, type;
	end
end

--Get raid start time via first trash killed or fallback to entered instance time.
local function getRaidStartTime(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return 0;
	end
	if (data.firstTrash) then
		return data.firstTrash;
	end
	return data.enteredTime;
end

local function getEncounterNameFromID(encounterID, logID)
	--Check our raid log first to get a more accurate name.
	if (logID) then
		local data = NRC.db.global.instances[logID];
		if (data) then
			for k, v in pairs(data.encounters) do
				if (v.encounterID == encounterID) then
					return v.encounterName;
				end
			end
		end
	end
	--Fall back to our DB.
	if (NRC.encounters[encounterID]) then
		return NRC.encounters[encounterID][2];
	end
	return "Unknown Encounter";
end
NRC.getEncounterNameFromID = getEncounterNameFromID;

--Info can be name or guid.
--Only used for data specific to a certain logID.
local function getClass(who, logID)
	local class = "";
	if (logID) then
		local data = NRC.db.global.instances[logID];
		if (data) then
			for guid, playerData in pairs(data.group) do
				if (guid == who) then
					return playerData.class;
				end
				if (playerData.name == who) then
					return playerData.class;
				end
			end
		end
	end
end

--Fontstrings with a lot of itemlinks can easily exceed the char limit for a single fontstring.
--So split it up between multiple fontstrings and achor to the bottom of the previous fontstring.
--This is just for the raid log frame and uses fontstrings already built for it on that frame.
function NRC:splitAndAnchorFontstring(text, linesPerFS, frame, x, y)
	local lines = {strsplit("\n", text)};
	local lineCount = #lines;
	local s = "";
	local strings = {};
	local charCount = 0;
	--Join each line into a string < 3900 chars for each fontstring.
	for k, v in ipairs(lines) do
		local len = strlen(s);
		if (len + strlen(v) < 3900) then
			if (k == lineCount) then
				--End of text.
				s = s .. v;
				tinsert(strings, s);
				break;
			else
				s = s .. v .. "\n";
				charCount = charCount + len;
			end
		else
			tinsert(strings, s);
			--Start a new string;
			if (k == lineCount) then
				--Last iteration.
				s = v;
				tinsert(strings, s);
			else
				s = v .. "\n";
			end
			charCount = len;
		end
	end
	local fsTotal = #raidLogFrame.scrollChild.splitfs;
	local offset = y;
	for k, v in ipairs(strings) do
		v = gsub(v, "\n$", "");
		if (k == 1) then
			--First fontstring and set of lines.
			raidLogFrame.scrollChild.splitfs[k]:SetText(v);
			raidLogFrame.scrollChild.splitfs[k]:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y);
			raidLogFrame.scrollChild.splitfs[k]:Show();
		else
			offset = offset - raidLogFrame.scrollChild.splitfs[k - 1]:GetHeight();
			raidLogFrame.scrollChild.splitfs[k]:SetText(v);
			raidLogFrame.scrollChild.splitfs[k]:Show();
			raidLogFrame.scrollChild.splitfs[k]:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", x, offset);
			if (k == fsTotal) then
				return;
			end
		end
	end
end

-------------------
---Display Frame---
-------------------

local function setBottomText(data, logID)
	if (data) then
		local bottomText = "|cFFFFFF00" .. date("%a %b %d", data.enteredTime) .. " " .. date("%Y", data.enteredTime)
				.. " " .. NRC:getTimeFormat(data.enteredTime, nil, true) .. "|r (Log " .. logID .. ")";
		raidLogFrame.bottomfs:SetText(bottomText);
		raidLogFrame.bottomfs:Show();
	else
		raidLogFrame.bottomfs:SetText("");
		raidLogFrame.bottomfs:Hide();
	end
end

local function clearRaidLogFrame()
	raidLogFrame.scrollChild.exportButton:SetParent(raidLogFrame.scrollChild);
	local childFrames = {raidLogFrame.scrollChild:GetChildren()};
	for k, v in pairs(childFrames) do
		--Handle clearing the scrollchild in a neater way later, but for now during dev just hide them.
		v:Hide();
	end
	if (NRCRaidLogRenameFrame) then
		NRCRaidLogRenameFrame:Hide();
	end
	if (NRCRaidLootRenameFrame) then
		NRCRaidLootRenameFrame:Hide();
	end
	currentLootData = {};
	if (portableModelFrame) then
		portableModelFrame:Hide();
	end
	--These 2 types of displaying data in the log are swapped on different log pages.
	--But most are using the scrollChild do reset to that, functions that need the scrollingMessageFrame Show() it in the load func.
	raidLogFrame.scrollChild:SetSize(raidLogFrame.subFrame:GetWidth(), 1);
	raidLogFrame.scrollChild.fs:SetText("");
	raidLogFrame.scrollChild.fs2:SetText("");
	raidLogFrame.scrollChild.fs3:SetText("");
	raidLogFrame.scrollChild.fs4:SetText("");
	raidLogFrame.scrollChild.fs5:SetText("");
	raidLogFrame.scrollChild.rfs:SetText("");
	raidLogFrame.scrollChild.fs:SetFontObject(Game16Font);
	raidLogFrame.scrollChild.fs2:SetFont(NRC.regionFont, 14);
	raidLogFrame.scrollChild.fs3:SetFont(NRC.regionFont, 14);
	raidLogFrame.scrollChild.fs4:SetFont(NRC.regionFont, 14);
	raidLogFrame.scrollChild.fs5:SetFont(NRC.regionFont, 14);
	raidLogFrame.scrollChild.rfs:SetFont(NRC.regionFont, 14);
	raidLogFrame.scrollChild.fs:Hide();
	raidLogFrame.scrollChild.fs2:Hide();
	raidLogFrame.scrollChild.fs3:Hide();
	raidLogFrame.scrollChild.fs4:Hide();
	raidLogFrame.scrollChild.fs5:Hide();
	raidLogFrame.scrollChild.rfs:Hide();
	raidLogFrame.scrollChild.fs2:SetSpacing(0);
	for k, v in ipairs(raidLogFrame.scrollChild.splitfs) do
		v:Hide();
	end
	raidLogFrame.scrollChild.fs:SetJustifyH("LEFT");
	raidLogFrame.scrollChild.fs2:SetJustifyH("LEFT");
	setBottomText();
	raidLogFrame.hideAllTabs();
	raidLogFrame.hideAllSimpleLineFrames();
	raidLogFrame.modelFrame:Hide();
	raidLogFrame.button1:Hide();
	raidLogFrame.button2:Hide();
	raidLogFrame.button3:Hide();
	raidLogFrame.button4:Hide();
	raidLogFrame.button5:Hide();
	raidLogFrame.button6:Hide();
	if (raidLogFrame.instanceDisplay) then
		raidLogFrame.instanceDisplay:Hide();
	end
	raidLogFrame.titleText2.texture:SetTexture();
	raidLogFrame.titleText2:SetSize(1, 1);
	raidLogFrame.titleText2:ClearAllPoints();
	--raidLogFrame.titleText2:Hide();
	--raidLogFrame.titleText2.texture:Hide();
	raidLogFrame.hideAllExtraButtons();
	if (tradeFilterFrame) then
		tradeFilterFrame:Hide();
	end
	raidLogFrame.titleText3:SetText("");
end

local function updateFrames()
	--The main frame we're viewing.
	local frameType = raidLogFrame.frameType;
	if (frameType == "log") then
		raidLogFrame.Tabs[1]:Show();
		raidLogFrame.Tabs[2]:Show();
		raidLogFrame.Tabs[3]:Hide();
		raidLogFrame.Tabs[4]:Hide();
		--raidLogFrame.Tabs[5]:Hide();
		raidLogFrame.Tabs[1]:SetText(L["Log"]);
		raidLogFrame.Tabs[2]:SetText(L["Bosses"]);
		raidLogFrame.Tabs[3]:SetText("");
		raidLogFrame.Tabs[4]:SetText("");
		raidLogFrame.Tabs[5]:SetText("");
		raidLogFrame.handleTabClicks = function(tabID)
			if (tabID == 1) then
				NRC:recalcRaidLog(true);
			elseif (tabID == 2) then
				NRC:loadBossViewer();
			end
		end
		raidLogFrame.backButton:Disable();
		--raidLogFrame.hideAllExpandedFrames();
	elseif (frameType == "allTrades") then
		raidLogFrame.Tabs[1]:Hide();
		raidLogFrame.Tabs[2]:Hide();
		raidLogFrame.Tabs[3]:Hide();
		raidLogFrame.Tabs[4]:Hide();
		raidLogFrame.Tabs[5]:Hide();
		raidLogFrame.Tabs[1]:SetText("");
		raidLogFrame.Tabs[2]:SetText("");
		raidLogFrame.Tabs[3]:SetText("");
		raidLogFrame.Tabs[4]:SetText("");
		raidLogFrame.Tabs[5]:SetText("");
		raidLogFrame.handleTabClicks = function(tabID)
			if (tabID == 1) then
				NRC:recalcRaidLog(true);
			elseif (tabID == 2) then
				NRC:loadBossViewer();
			end
		end
		raidLogFrame.backButton:Enable();
		--raidLogFrame.hideAllExpandedFrames();
	elseif (frameType == "instance" or frameType == "loot" or frameType == "deaths" or frameType == "consumes" or frameType == "raidTrades"
			or frameType == "bossModel" or frameType == "bossLoot"  or frameType == "bossTalents" or frameType == "bossConsumes") then
		raidLogFrame.Tabs[1]:Show();
		raidLogFrame.Tabs[2]:Show();
		raidLogFrame.Tabs[3]:Show();
		raidLogFrame.Tabs[4]:Show();
		raidLogFrame.Tabs[5]:Show();
		raidLogFrame.Tabs[1]:SetText(L["Raid"]);
		raidLogFrame.Tabs[2]:SetText(L["Loot"]);
		raidLogFrame.Tabs[3]:SetText(L["Deaths"]);
		raidLogFrame.Tabs[4]:SetText(L["Trades"]);
		raidLogFrame.Tabs[5]:SetText(L["Consumes"]);
		raidLogFrame.handleTabClicks = function(tabID)
			if (tabID == 1) then
				NRC:loadRaidLogInstance(raidLogFrame.logID);
			elseif (tabID == 2) then
				NRC:loadRaidLogLoot(raidLogFrame.logID);
			elseif (tabID == 3) then
				NRC:loadRaidLogDeaths(raidLogFrame.logID);
			elseif (tabID == 4) then
				NRC:loadTrades(raidLogFrame.logID, raidLogFrame.raidID);
			elseif (tabID == 5) then
				NRC:loadRaidLogConsumes(raidLogFrame.logID, nil, nil, nil, nil, true);
			end
		end
		raidLogFrame.backButton:Enable();
		--raidLogFrame.hideAllExpandedFrames();
	elseif (frameType == "bossView") then
		raidLogFrame.Tabs[1]:Hide();
		raidLogFrame.Tabs[2]:Hide();
		raidLogFrame.Tabs[3]:Hide();
		raidLogFrame.Tabs[4]:Hide();
		raidLogFrame.Tabs[5]:Hide();
		raidLogFrame.Tabs[1]:SetText("");
		raidLogFrame.Tabs[2]:SetText("");
		raidLogFrame.Tabs[3]:SetText("");
		raidLogFrame.Tabs[4]:SetText("");
		raidLogFrame.Tabs[5]:SetText("");
		raidLogFrame.backButton:Enable();
	elseif (frameType == "bossJournal") then
		raidLogFrame.Tabs[1]:Show();
		raidLogFrame.Tabs[2]:Show();
		raidLogFrame.Tabs[3]:Show();
		raidLogFrame.Tabs[4]:Hide();
		raidLogFrame.Tabs[5]:Hide();
		raidLogFrame.Tabs[1]:SetText("Classic");
		raidLogFrame.Tabs[2]:SetText("TBC");
		raidLogFrame.Tabs[3]:SetText("Wrath");
		raidLogFrame.Tabs[4]:SetText("");
		raidLogFrame.Tabs[5]:SetText("");
		raidLogFrame.backButton:Enable();
	end
	if (frameType == "loot" or frameType == "bossLoot" or frameType == "consumes" or frameType == "bossConsumes") then
		raidLogFrame.updateAllSimpleLineFramesHyperlinkHandling(2);
	else
		raidLogFrame.updateAllSimpleLineFramesHyperlinkHandling(1);
	end
	raidLogFrame.hideAllExpandedFrames();
	raidLogFrame.scrollFrame:SetVerticalScroll(0);
end

function NRC:raidLogBackbuttonClicked()
	if (raidLogFrame.frameType == "instance" or raidLogFrame.frameType == "loot" or raidLogFrame.frameType == "deaths"
			or raidLogFrame.frameType == "consumes" or raidLogFrame.frameType == "bossView"
			or raidLogFrame.frameType == "raidTrades" or raidLogFrame.frameType == "allTrades") then
		raidLogFrame.frameType = "log";
		NRC:recalcRaidLog(true);
	elseif (raidLogFrame.frameType == "bossModel" or raidLogFrame.frameType == "bossLoot"
			 or raidLogFrame.frameType == "bossTalents" or raidLogFrame.frameType == "bossConsumes") then
		raidLogFrame.frameType = "instance";
		NRC:loadRaidLogInstance(raidLogFrame.logID);
	end
end

local openTabType;
function NRC:loadRaidLogFrames()
	if (not raidLogFrame) then
		raidLogFrame = NRC:createMainFrame("NRCRaidLogFrame", 824, 568, 0, 300, 5);
		raidLogFrame.modelFrame = NRC:createModelFrame("NRCRaidLogModelFrame", 1, 1, 0, 0);
		raidLogFrame.modelFrame:SetParent(raidLogFrame.scrollFrame);
		raidLogFrame.modelFrame:SetAllPoints();
		raidLogFrame.backButton:HookScript("OnHide", function(self, arg)
			if (logRenameFrame) then
				logRenameFrame:Hide();
			end
		end)
		--raidLogFrame.hideAllTabs();
		--raidLogFrame:SetBackdropColor(0, 0, 0, 0.9);
		--raidLogFrame:SetBackdropBorderColor(1, 1, 1, 0.2);
		--raidLogFrame.updateGridData(NRC:createRaidStatusData(true), true);
		raidLogFrame.onUpdateFunction = "recalcRaidLog";
		tinsert(UISpecialFrames, "NRCRaidLogFrame");
		raidLogFrame:SetClampedToScreen(true);
		raidLogFrame.backButton:SetScript("OnClick", function(self, arg)
			NRC:raidLogBackbuttonClicked();
		end)
		raidLogFrame.button1 = CreateFrame("Button", "NRCRaidLogButton", raidLogFrame, "NRC_EJButtonTemplate");
		raidLogFrame.button2 = CreateFrame("Button", "NRCRaidLogButton2", raidLogFrame, "NRC_EJButtonTemplate");
		raidLogFrame.button3 = CreateFrame("Button", "NRCRaidLogButton3", raidLogFrame, "NRC_EJButtonTemplate");
		raidLogFrame.button4 = CreateFrame("Button", "NRCRaidLogButton4", raidLogFrame, "NRC_EJButtonTemplate");
		raidLogFrame.button5 = CreateFrame("Button", "NRCRaidLogButton5", raidLogFrame, "NRC_EJButtonTemplate");
		raidLogFrame.button6 = CreateFrame("Button", "NRCRaidLogButton6", raidLogFrame, "NRC_EJButtonTemplate");
	end
	updateFrames();
	raidLogFrame:Hide();
end

function NRC:setRaidLogFrameHeader()
	local header = "Nova Raid Companion";
	if (not raidLogFrame.TitleText) then
		--This needs to be created in retail.
		raidLogFrame.TitleText = raidLogFrame.TitleContainer:CreateFontString("$parentFS", "OVERLAY");
		raidLogFrame.TitleText:SetPoint("TOP", -10, -5);
		--raidLogFrame.TitleText:SetPoint("LEFT", 60, 0);
		--raidLogFrame.TitleText:SetPoint("RIGHT", 0, -60);
		raidLogFrame.TitleText:SetFontObject(GameFontNormal);
	end
	raidLogFrame.TitleText:SetText(header);
	
end

function NRC:openRaidLogFrame()
	if (not raidLogFrame) then
		NRC:loadRaidLogFrames();
	end
	NRC:setRaidLogFrameHeader();
	--Set tab to the main instance log.
	raidLogFrame.frameType = "log";
	updateFrames();
	if (raidLogFrame:IsShown()) then
		raidLogFrame:Hide();
	else
		local fontSize = false;
		raidLogFrame:Show();
		raidLogFrame.scrollFrame:SetVerticalScroll(0);
		--So interface options and this frame will open on top of each other.
		if (InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()) then
			raidLogFrame:SetFrameStrata("DIALOG");
		else
			raidLogFrame:SetFrameStrata("MEDIUM");
		end
		NRC:recalcRaidLog(true);
	end
end

function NRC:recalcRaidLog(clearRaidLog)
	if (not raidLogFrame) then
		--Frame hasn't been opened since logon, no need to recalc.
		return;
	end
	if (clearRaidLog) then
		updateFrames();
		clearRaidLogFrame();
		--[[raidLogFrame.titleText2.fs:SetText(L["Raid Log"]);
		raidLogFrame.titleText2:ClearAllPoints();
		raidLogFrame.titleText2:SetPoint("TOP", raidLogFrame, "TOP", 0, -41);
		--Adjust frame width the instance name text sits on so it centers.
		raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
		raidLogFrame.titleText2:Show();
		raidLogFrame.titleText2.texture:Hide();]]
		raidLogFrame.titleText2:Hide();
		raidLogFrame.titleText2.texture:Hide();
		raidLogFrame.titleText3:SetText(L["Raid Log"]);
		raidLogFrame.titleText3:ClearAllPoints();
		raidLogFrame.titleText3:SetPoint("TOP", raidLogFrame, "TOP", 0, -30);
		--Adjust frame width the instance name text sits on so it centers.
		if (raidLogFrame.frameType == "log") then
			raidLogFrame.scrollFrame.selectedTab = 1;
			PanelTemplates_UpdateTabs(raidLogFrame.scrollFrame);
		end
	end
	local framesUsed = {};
	if (raidLogFrame.frameType == "log") then
		raidLogFrame.backButton:Disable();
		local count = 0;
		local found;
		local startOffset, padding, offset = 20, 40, 0;
		for k, v in ipairs(NRC.db.global.instances) do
			local frame = raidLogFrame.getLineFrame(k, v);
			if (frame) then
				found = true;
				local timeAgo = GetServerTime() - v.enteredTime;
				--if (v.leftTime and v.leftTime > 0) then
				--	timeAgo = GetServerTime() - v.leftTime;
				--end
				count = count + 1;
				if (count > NRC.db.global.maxRecordsShown) then
					if (frame) then
						frame:Hide();
					end
				else
					framesUsed[count] = true;
					frame:Show();
					frame:ClearAllPoints();
					if (k == 1) then
						offset = startOffset;
					else
						offset = offset + padding;
					end
					frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 3, -offset);
					frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -30, 0);
					frame:SetNormalTexture(frame.normalTex);
					frame:SetHighlightTexture(frame.highlightTex);
					frame.leftTexture:SetSize(50, 41);
					frame.leftTexture:SetScale(0.8);
					frame.leftTexture:Show();
					frame.tooltip.fs:SetText("|cFFFFFF00" .. string.format(L["logEntryTooltip"], "|cFFFF6900" .. count .. "|r"));
					frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
					frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
					--offset = offset + 14;
					local line, line2, line3, line4, line5 = NRC:buildRaidLogLineFrameString(v, count);
					if (count < 10) then
						--Offset the text for single digit numbers so the date comlumn lines up.
						frame.fs:SetPoint("LEFT", 12, 0);
					else
						frame.fs:SetPoint("LEFT", 5, 0);
					end
					frame.fs:SetText("|cFFFFFFFF" .. count .. ")|r");
					frame.fs2:SetPoint("LEFT", 85, 8);
					frame.fs2:SetText(line);
					frame.fs3:SetPoint("LEFT", 85, -8);
					frame.fs3:SetText(line2);
					frame.fs4:SetPoint("LEFT", frame.fs3, "RIGHT", 0, -1);
					frame.fs4:SetText(line3);
					frame.fs5:SetPoint("LEFT", frame.fs4, "RIGHT", 0, -1);
					frame.fs5:SetText(line4);
					frame.fs6:SetPoint("LEFT", frame.fs5, "RIGHT", 0, -1);
					if (NRC.isDebug) then
						if (not line5) then
							line5 = "";
						end
						line5 = line5 .. " |cFFA1A1A1(zone " .. (v.zoneID or "none") .. ")|r"
					end
					frame.fs6:SetText(line5);
					
					if (v.instanceID) then
						local name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID = getInstanceTextures(v.instanceID);
						if (loreImage) then
							frame.leftTexture:SetTexture(loreImage);
						else
							frame.leftTexture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
						end
					else
						frame.leftTexture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
					end
					frame.leftTexture:SetTexCoord(0, 0.76171875, 0.06, 0.60625);
					frame:SetHeight(38);
					frame.removeButton.count = count;
					frame.removeButton:SetScript("OnClick", function(self, arg)
						if (NRC.raid) then
							NRC:print(L["You can't delete log entries while inside an instance."]);
						else
							--Open delete confirmation box to delete table id (k), but display it as matching log number (count).
							StaticPopupDialogs["NRC_DELETE_CONFIRM"].text = string.format(L["deleteInstanceConfirm"], "|CffDEDE42" .. k .. "|r |cFF9CD6DE(" .. v.instanceName .. ")|r");
							StaticPopupDialogs["NRC_DELETE_CONFIRM"].OnAccept = function()
							     NRC:deleteInstance(k);
							end
							StaticPopup_Show("NRC_DELETE_CONFIRM");
						end
					end)
					frame.removeButton:Show();
					frame:SetScript("OnClick", function(self, button)
						if (button == "RightButton") then
							NRC:loadRenameLogFrame(k);
						else
							raidLogFrame.backButton:Enable();
							NRC:loadRaidLogInstance(k);
						end
					end)
					frame.id = k;
				end
			end
		end
		if (found) then
			raidLogFrame.scrollChild.fs:Hide();
		else
			raidLogFrame.scrollChild.fs:ClearAllPoints();
			raidLogFrame.scrollChild.fs:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 50, -30);
			raidLogFrame.scrollChild.fs:SetText("|cFF9CD6DE" .. L["noRaidsRecordedYet"]);
			raidLogFrame.scrollChild.fs:Show();
		end
		--raidLogFrame.button1:Show(); --Hidden until feature finished.
		raidLogFrame.button1:SetSize(70, 20);
		raidLogFrame.button1:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -120, -31);
		raidLogFrame.button1:SetText(L["Boss Journal"]);
		raidLogFrame.button1:SetScript("OnClick", function(self, arg)
			NRC:loadAllBossView();
		end)
		raidLogFrame.button2:Show();
		raidLogFrame.button2:SetSize(50, 18);
		raidLogFrame.button2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -35, -24);
		raidLogFrame.button2:SetText(L["Config"]);
		raidLogFrame.button2:SetScript("OnClick", function(self, arg)
			NRC:openConfig();
		end)
		raidLogFrame.button3:Show();
		raidLogFrame.button3:SetSize(50, 18);
		raidLogFrame.button3:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -115, -24);
		raidLogFrame.button3:SetText(L["Lockouts"]);
		raidLogFrame.button3:SetScript("OnClick", function(self, arg)
			NRC:openLockoutsFrame();
		end)
		raidLogFrame.button4:Show();
		raidLogFrame.button4:SetSize(50, 18);
		raidLogFrame.button4:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -115, -43);
		raidLogFrame.button4:SetText(L["Trades"]);
		raidLogFrame.button4:SetScript("OnClick", function(self, arg)
			NRC:loadTrades();
		end)
		--Hide any no longer in use lines frames from the bottom when instances are deleted.
		--for i = 1, NRC.db.global.maxRecordsShown do
		--	if (raidLogFrame.lineFrames[i] and not framesUsed[i]) then
		--		raidLogFrame.lineFrames[i]:Hide();
		--	end
		--end
	end
end

function NRC:buildRaidLogLineFrameString(v, logID)
	local player = v.playerName;
	--local data = NRC.db.global.instances[logID];
	local _, _, _, classColorHex = GetClassColor(v.classEnglish);
	--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
	if (not classColorHex and v.classEnglish == "SHAMAN") then
		classColorHex = "ff0070dd";
	elseif (not classColorHex) then
		classColorHex = "ffffffff";
	end
	local instance = v.instanceName;
	local time = NRC:getTimeFormat(v.enteredTime, true, true);
	instance = string.gsub(instance, "Hellfire Citadel: ", "");
	instance = string.gsub(instance, "Coilfang: ", "");
	instance = string.gsub(instance, "Auchindoun: ", "");
	instance = string.gsub(instance, "Tempest Keep: ", "");
	instance = string.gsub(instance, "Opening of the Dark Portal", "Black Morass");
	instance = NRC:addDiffcultyText(instance, v.difficultyName, v.difficultyID, " ");
	--if (v.difficultyID == 174) then
	--	instance = instance .. " (|cFFFF2222H|r)";
	--end
	if (v.logName) then
		--If the log entry has been renamed by user.
		instance = v.logName .. " (" .. instance .. ")";
	end
	if (logID == 1 and NRC.raid) then
		instance = instance .. " |cFF00C800(" .. L["Inside"] .. ")|r";
	end
	local bossKills, bossWipes = getBossStats(logID);
	local bossTotal = getTotalBossCount(v.instanceID);
	local trashKills, otherKills = getTrashCount(logID);
	local killsText, trashKillsText = "|cFF9CD6DE", "";
	local line3, line5;
	if (v.instanceType == "party") then
		killsText = killsText .. "  " .. L["Mobs"] .. ": ";
		line3 = "|cFF00C800" .. trashKills + otherKills;
	else
		if (bossTotal and bossTotal > 0) then
			if (bossKills == 0) then
				killsText = killsText .. "  " .. L["Bosses"] .. ": ";
				line3 = "|cFFFF3333" .. bossKills .. "|r/|cFF00C800" .. bossTotal .. "|r";
			elseif (bossKills < bossTotal) then
				killsText = killsText .. "  " .. L["Bosses"] .. ": ";
				line3 = "|cFFDEDE42" .. bossKills .. "|r/|cFF00C800" .. bossTotal .. "|r";
			else
				killsText = killsText .. "  " .. L["Bosses"] .. ": ";
				line3 = "|cFF00C800" .. bossKills .. "|r/|cFF00C800" .. bossTotal .. "|r";
			end
			local trashCount;
			if (trashKills > 0) then
				trashCount = trashKills;
			else
				trashCount = otherKills;
			end
			if (trashCount == 0) then
				trashCount = "|cFFFF3333" .. trashCount .. "|r";
			else
				trashCount = "|cFF00C800" .. trashCount .. "|r";
			end
			trashKillsText = "  |cFF9CD6DE" .. L["Trash"] .. ":|r ";
			line5 = trashCount ;
		end
	end
	--local line = "|cFFFFFF00" .. instance .. "\n|cFF9CD6DE" .. time .. "|r  |c" .. classColorHex .. player .. "|r" .. killsText;
	---local line = "|cFFFFFF00" .. instance .. "\n|cFF9CD6DE" .. time .. "|r" .. killsText .. "  |c" .. classColorHex .. player .. "|r";
	local line = "|cFFFFFF00" .. instance .. "|r";
	local line2 = "|cFF9CD6DE" .. time .. "|r  |c" .. classColorHex .. player .. "|r" .. killsText;
	local line4 = trashKillsText;
	--local line2 = "|c" .. classColorHex .. player .. "|r  |cFF9CD6DE" .. time .. "|r" .. killsText;
	return line, line2, line3, line4, line5;
end

function NRC:loadRenameLogFrame(logID)
	if (not logRenameFrame) then
		logRenameFrame = NRC:createTextInputFrame("NRCRaidLogRenameFrame", 250, 70, raidLogFrame);
		logRenameFrame.setButton:SetPoint("BOTTOM", logRenameFrame, "Bottom", -55, 5);
		logRenameFrame.setButton:SetText(L["Set"]);
		logRenameFrame.setButton:Show();
		logRenameFrame.resetButton:SetPoint("BOTTOM", logRenameFrame, "Bottom", 55, 5);
		logRenameFrame.resetButton:SetText(L["Clear"]);
		logRenameFrame.resetButton:Show();
		logRenameFrame.input:SetPoint("BOTTOM", 0, 30);
	end
	logRenameFrame.fs:SetText("|cFFFFFF00" .. string.format(L["logEntryFrameTitle"], "|cFFFF6900" .. logID .. "|r"))
	logRenameFrame.logID = logID;
	logRenameFrame:ClearAllPoints();
	--local scale, x, y = logRenameFrame:GetEffectiveScale(), GetCursorPosition();
	--logRenameFrame:SetPoint("RIGHT", UIParent, "BOTTOMLEFT", (x / scale) - 2, y / scale);
	logRenameFrame:SetPoint("CENTER", raidLogFrame.lineFrames[logID], "CENTER", 0, 0);
	logRenameFrame.input.OnEnterPressed = function()
		local text = logRenameFrame.input:GetText();
		if (text ~= "") then
			NRC.db.global.instances[logRenameFrame.logID].logName = text;
			logRenameFrame.input:SetText("");
			logRenameFrame.input:ClearFocus();
			NRC:print(string.format(L["renamedLogEntry"], "|cFFFF6900" .. logID .. "|r", text) .. ".");
			NRC:recalcRaidLog();
		else
			NRC.db.global.instances[logRenameFrame.logID].logName = nil;
			logRenameFrame.input:ClearFocus();
			NRC:print(string.format(L["clearedLogEntryName"], "|cFFFF6900" .. logID .. "|r") .. ".");
			NRC:recalcRaidLog();
		end
	end
	logRenameFrame.input:SetScript("OnEnterPressed", logRenameFrame.input.OnEnterPressed);
	logRenameFrame.setButton:SetScript("OnClick", function(self, arg)
		local text = logRenameFrame.input:GetText();
		if (text ~= "") then
			NRC.db.global.instances[logRenameFrame.logID].logName = text;
			logRenameFrame.input:SetText("");
			logRenameFrame.input:ClearFocus();
			NRC:print(string.format(L["renamedLogEntry"], "|cFFFF6900" .. logID .. "|r", text) .. ".");
			NRC:recalcRaidLog();
		else
			NRC.db.global.instances[logRenameFrame.logID].logName = nil;
			logRenameFrame.input:ClearFocus();
			NRC:print(string.format(L["clearedLogEntryName"], "|cFFFF6900" .. logID .. "|r") .. ".");
			NRC:recalcRaidLog();
		end
	end)
	logRenameFrame.resetButton:SetScript("OnClick", function(self, arg)
		NRC.db.global.instances[logRenameFrame.logID].logName = nil;
		logRenameFrame.input:ClearFocus();
		NRC:print(string.format(L["clearedLogEntryName"], "|cFFFF6900" .. logID .. "|r") .. ".");
		NRC:recalcRaidLog();
	end)
	logRenameFrame:Show();
	logRenameFrame.input:SetFocus();
end

function NRC:recalcRaidLogLineFramesTooltip(obj)
	
end

StaticPopupDialogs["NRC_DELETE_CONFIRM"] = {
	text = "Confirm deletion?",
	button1 = L["Delete"],
	button2 = L["Cancel"],
	OnAccept = function()
 
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
};

local function setInstanceTexture(logID)
	local data = NRC.db.global.instances[logID];
	if (data) then
		if (data.instanceID) then
			local name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID = getInstanceTextures(data.instanceID);
			raidLogFrame.titleText2.texture:SetTexture(loreImage);
		else
			raidLogFrame.titleText2.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
		end
	end
end

function NRC:loadRaidLogInstance(logID)
	clearRaidLogFrame();
	raidLogFrame.frameType = "instance";
	updateFrames();
	local data = NRC.db.global.instances[logID];
	raidLogFrame.logID = logID;
	raidLogFrame.raidID = data.raidID;
	local startOffset, padding, offset = 50, 70, 0;
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	setInstanceTexture(logID);
	raidLogFrame.titleText2:Show();
	raidLogFrame.titleText2.texture:Show();
	local lastBossFrame;
	if (next(data.encounters)) then
		for k, v in ipairs(data.encounters) do
			local frame = _G["NRCBossButton" .. k];
			if (not frame) then
				--Recreate EncounterBossButtonTemplate from retail.
				frame = CreateFrame("Button", "NRCBossButton" .. k, raidLogFrame.scrollChild);
				frame:SetSize(325, 55);
				
				frame.fs = frame:CreateFontString("$parentFS", "ARTWORK");
				frame.fs:SetPoint("LEFT", 115, 10);
				frame.fs:SetJustifyH("LEFT");
				frame.fs:SetFontObject(GameFontNormalMed3);
				frame.fs2 = frame:CreateFontString("$parentFS2", "ARTWORK");
				frame.fs2:SetPoint("LEFT", 115, -10);
				frame.fs2:SetJustifyH("LEFT");
				frame.fs2:SetFont(NRC.regionFont, 14);
				
				local creature = CreateFrame("Frame", "$parentCreature" .. k, frame);
				creature:SetSize(1, 1);
				creature:SetPoint("TOPLEFT", -4, 13);
				creature.texture = creature:CreateTexture("$parentTexture", "ARTWORK");
				creature.texture:SetSize(128, 64);
				creature.texture:SetPoint("TOPLEFT", 0, 0);
				creature.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-BOSS-Default");
				creature.texture:SetDrawLayer("ARTWORK", 6);
				frame.creature = creature;
				
				local normal = frame:CreateTexture("$parentNormalTexture", "ARTWORK");
				normal:SetAllPoints();
				--UI-EJ-BossButton-Up.
				normal:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
				normal:SetTexCoord(0.00195313, 0.63671875, 0.21386719, 0.26757813);
				frame:SetNormalTexture(normal);
				
				local pushed = frame:CreateTexture("$parentPushedTexture", "ARTWORK");
				pushed:SetAllPoints();
				--UI-EJ-BossButton-Down.
				pushed:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
				pushed:SetTexCoord(0.00195313, 0.63671875, 0.10253906, 0.15625000);
				frame:SetPushedTexture(pushed);
				
				local highlight = frame:CreateTexture("$parentHighlightTexture", "HIGHLIGHT");
				highlight:SetAllPoints();
				--UI-EJ-BossButton-Highlight.
				highlight:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
				highlight:SetTexCoord(0.00195313, 0.63671875, 0.15820313, 0.21191406);
				frame:SetHighlightTexture(highlight);
			end
			local attemptID = k;
			frame:SetScript("OnClick", function(self, arg)
				NRC:loadRaidLogModelFrame(v.encounterID, v.encounterName);
			end)
			if (not frame.button2) then
				frame.button2 = CreateFrame("Button", "NRCBossButton" .. k .. "Button2", frame, "NRC_EJButtonTemplate");
				frame.button2:SetSize(70, 27);
				frame.button2:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, -4);
				frame.button2:SetText(L["Buff Snapshot"]);
			end
			if (not frame.button3) then
				frame.button3 = CreateFrame("Button", "NRCBossButton" .. k .. "Button3", frame, "NRC_EJButtonTemplate");
				frame.button3:SetSize(70, 27);
				frame.button3:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 10, 0);
				frame.button3:SetText(L["Loot"]);
			end
			if (not frame.button4) then
				frame.button4 = CreateFrame("Button", "NRCBossButton" .. k .. "Button4", frame, "NRC_EJButtonTemplate");
				frame.button4:SetSize(70, 27);
				frame.button4:SetPoint("LEFT", frame.button2, "RIGHT", 23, 0);
				frame.button4:SetText(L["Talents"]);
			end
			if (not frame.button5) then
				frame.button5 = CreateFrame("Button", "NRCBossButton" .. k .. "Button5", frame, "NRC_EJButtonTemplate");
				frame.button5:SetSize(70, 27);
				frame.button5:SetPoint("LEFT", frame.button3, "RIGHT", 23, 0);
				frame.button5:SetText(L["Consumes"]);
			end
			frame.button2:Show();
			frame.button3:Show();
			frame.button4:Show();
			frame.button5:Show();
			frame.button2:SetScript("OnClick", function(self, arg)
				NRC.raidStatusCache = {};
				NRC.raidStatusCache.auraCache = v.auraCache;
				NRC.raidStatusCache.resCache = v.resCache;
				NRC.raidStatusCache.weaponEnchantCache = v.weaponEnchantCache;
				NRC.raidStatusCache.talentCache = v.talentCache;
				NRC.raidStatusCache.group = data.group;
				NRC.raidStatusCache.logID = logID;
				NRC.raidStatusCache.encounterID = v.encounterID;
				NRC.raidStatusCache.success = v.success;
				NRC:openRaidStatusFrame(true, true, attemptID);
			end)
			frame.button3:SetScript("OnClick", function(self, arg)
				NRC:loadRaidBossLoot(logID, v.encounterID, v.encounterName, attemptID);
			end)
			frame.button4:SetScript("OnClick", function(self, arg)
				NRC:loadRaidTalents(logID, v.encounterID, v.encounterName, attemptID);
			end)
			frame.button5:SetScript("OnClick", function(self, arg)
				NRC:loadRaidLogConsumes(logID, v.encounterID, v.encounterName, attemptID, nil, true);
			end)
			if (k == 1) then
				offset = startOffset;
			else
				offset = offset + padding;
			end
			frame:SetScale(0.85);
			frame:Show();
			frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 20, -offset);
			local id, name, description, displayInfo, iconImage, uiModelSceneID = getEncounterData(v.encounterID);
			if (iconImage) then
				--frame:UnlockHighlight();
				frame.creature.texture:SetTexture(iconImage);
			else
				frame.creature.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-BOSS-Default");
			end
			frame.fs:SetText(v.encounterName);
			
			local success = "|cFFFF6666" .. L["Wipe"];
			if (v.success == 1) then
				success = "|cFF00C800" .. L["Kill"];
			end
			local killTime = "0";
			if (v.endTime and v.startTime) then
				killTime = NRC:getShortTime(v.endTime - v.startTime, true);
			end
			frame.fs2:SetText(success .. " - " .. killTime .. "|r   |cFF9CD6DE(" .. NRC:getTimeFormat(v.startTime, nil, true) .. ")|r");
			lastBossFrame = frame;
		end
	else
		--No encounters yet.
		local k = 1;
		local frame = _G["NRCBossButton" .. k];
		if (not frame) then
			--Recreate EncounterBossButtonTemplate from retail.
			frame = CreateFrame("Button", "NRCBossButton" .. k, raidLogFrame.scrollChild);
			frame:SetSize(325, 55);
			
			frame.fs = frame:CreateFontString("$parentFS", "ARTWORK");
			frame.fs:SetPoint("LEFT", 115, 10);
			frame.fs:SetJustifyH("LEFT");
			--frame.fs:SetFont(NRC.regionFont, 14);
			frame.fs:SetFontObject(GameFontNormalMed3);
			frame.fs2 = frame:CreateFontString("$parentFS2", "ARTWORK");
			frame.fs2:SetPoint("LEFT", 115, -10);
			frame.fs2:SetJustifyH("LEFT");
			frame.fs2:SetFont(NRC.regionFont, 14);
			
			local creature = CreateFrame("Frame", "$parentCreature" .. k, frame);
			creature:SetSize(1, 1);
			creature:SetPoint("TOPLEFT", -4, 13);
			creature.texture = creature:CreateTexture("$parentTexture", "ARTWORK");
			creature.texture:SetSize(128, 64);
			creature.texture:SetPoint("TOPLEFT", 0, 0);
			creature.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-BOSS-Default");
			creature.texture:SetDrawLayer("ARTWORK", 6);
			frame.creature = creature;
			
			local normal = frame:CreateTexture("$parentNormalTexture", "ARTWORK");
			normal:SetAllPoints();
			--UI-EJ-BossButton-Up.
			normal:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
			normal:SetTexCoord(0.00195313, 0.63671875, 0.21386719, 0.26757813);
			frame:SetNormalTexture(normal);
			
			local pushed = frame:CreateTexture("$parentPushedTexture", "ARTWORK");
			pushed:SetAllPoints();
			--UI-EJ-BossButton-Down.
			pushed:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
			pushed:SetTexCoord(0.00195313, 0.63671875, 0.10253906, 0.15625000);
			frame:SetPushedTexture(pushed);
			
			local highlight = frame:CreateTexture("$parentHighlightTexture", "HIGHLIGHT");
			highlight:SetAllPoints();
			--UI-EJ-BossButton-Highlight.
			highlight:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-ENCOUNTERJOURNALTEXTURES");
			highlight:SetTexCoord(0.00195313, 0.63671875, 0.15820313, 0.21191406);
			frame:SetHighlightTexture(highlight);
			
			frame:SetScript("OnClick", function(self, arg)
				--Do nothing if there's no encounters yet.
			end)
		end
		if (k == 1) then
			offset = startOffset;
		else
			offset = offset + padding;
		end
		frame:SetScale(0.85);
		frame:Show();
		if (frame.button2) then
			frame.button2:Hide();
		end
		if (frame.button3) then
			frame.button3:Hide();
		end
		if (frame.button4) then
			frame.button4:Hide();
		end
		if (frame.button5) then
			frame.button5:Hide();
		end
		frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 20, -offset);
		frame.creature.texture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-BOSS-Default");
		frame.fs:SetText(L["No encounters recorded."]);
		frame.fs2:SetText("");
		lastBossFrame = frame;
	end
	--Display some instance stats.
	local text = "";
	text = text .. "|cFFFFFF00" .. date("%a %b %d", data.enteredTime) .. " " .. date("%Y", data.enteredTime) .. "|r";
	local raidDuration, raidDurationType = getRunDuration(logID);
	if (data.enteredTime) then
		text = text .. "\n|cFF9CD6DE" .. L["Entered"] .. ":|r |cFFFFFF00" .. NRC:getTimeFormat(data.enteredTime, nil, true) .. "|r";
	end
	if (data.firstTrash) then
		text = text .. "\n|cFF9CD6DE" .. L["First trash"] .. ":|r |cFFFFFF00" .. NRC:getTimeFormat(data.firstTrash, nil, true) .. "|r";
	end
	if (data.leftTime) then
		if (logID == 1 and NRC.raid) then
			text = text .. "\n|cFF9CD6DE" .. L["Left"] .. ":|r |cFFFFFF00" .. L["Still inside"] .. ".|r";
		else
			text = text .. "\n|cFF9CD6DE" .. L["Left"] .. ":|r |cFFFFFF00" .. NRC:getTimeFormat(data.leftTime, nil, true) .. "|r";
		end
	end
	--if (logID == 1 and NRC.raid) then
	--	text = text .. "\n|cFF9CD6DEDuration:|r |cFFFFFF00Still inside|r";
	--else
		text = text .. "\n|cFF9CD6DE" .. L["Duration"] .. ":|r |cFFFFFF00" .. NRC:getTimeString(raidDuration, true, "medium") .. ".|r";
	--end
	if (raidDurationType and raidDurationType ~= "") then
		text = text .. "\n|cFF9CD6DE(" .. raidDurationType .. ")|r";
	end
	if (data.combatTime) then
		text = text .. "\n|cFF9CD6DE" .. L["Time spent in combat"] .. ":|r |cFFFFFF00" .. NRC:getTimeString(math.floor(data.combatTime), true, "medium") .. ".|r";
	end
	text = text .. "\n\n|cFFFFFF00" .. L["Bosses"] .. "|r";
	local bossKills, bossWipes = getBossStats(logID);
	local bossTotal = getTotalBossCount(data.instanceID);
	local bossKillsText;
	if (bossKills == 0) then
		bossKillsText = "|cFFFF3333" .. bossKills .. "|r";
	elseif (bossKills < bossTotal) then
		bossKillsText = "|cFFDEDE42" .. bossKills .. "|r";
	else
		bossKillsText = "|cFF00C800" .. bossKills .. "|r";
	end
	if (bossTotal == 0) then
		--No boss data for this raid has been set in our db yet.
		text = text .. "\n|cFF9CD6DE" .. L["Kills"] .. ":|r |cFF00C800" .. bossKills .. "|r";
	else
		text = text .. "\n|cFF9CD6DE" .. L["Kills"] .. ":|r " .. bossKillsText .. " / |cFF00C800" .. bossTotal .. "|r";
	end
	local bossWipesText = "|cFFFF3333" .. bossWipes .. "|r";
	if (bossWipes == 0) then
		bossWipesText = "|cFF00C800" .. bossWipes .. "|r";
	end
	text = text .. "\n|cFF9CD6DE" .. L["Wipes"] .. ":|r " .. bossWipesText;
	text = text .. "\n\n|cFFFFFF00" .. L["Deaths"] .. "|r";
	local deaths, bossDeaths, trashDeaths, deathData = getDeathData(logID);
	if (deaths) then
		local deathsText = "|cFFFF3333" .. deaths .. "|r";
		if (deaths == 0) then
			deathsText = "|cFF00C800" .. deaths .. "|r";
		end
		text = text .. "\n|cFF9CD6DE" .. L["Total"] .. ":|r " .. deathsText;
		local bossDeathsText = "|cFFFF3333" .. bossDeaths .. "|r";
		if (bossDeaths == 0) then
			bossDeathsText = "|cFF00C800" .. bossDeaths .. "|r";
		end
		text = text .. "\n|cFF9CD6DE" .. L["During Bosses"] .. ":|r " .. bossDeathsText;
		local trashDeathsText = "|cFFFF3333" .. trashDeaths .. "|r";
		if (trashDeaths == 0) then
			trashDeathsText = "|cFF00C800" .. trashDeaths .. "|r";
		end
		text = text .. "\n|cFF9CD6DE" .. L["During Trash"] .. ":|r " .. trashDeathsText ;
	end
	if (data.rep and next(data.rep)) then
		text = text .. "\n\n|cFFFFFF00" .. L["Reputation"] .. "|r";
		for k, v in NRC:pairsByKeys(data.rep) do
			if (v > 0) then
				v = "+" .. NRC:commaValue(v);
			end
			text = text .. "\n|cFF9CD6DE" .. k .. ":|r " .. v;
		end
	end
	raidLogFrame.scrollChild.fs3:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 545, -30);
	raidLogFrame.scrollChild.fs3:Show();
	raidLogFrame.scrollChild.fs3:SetText(text);
	--Display trash mob data.
	local trash, trashCount = {}, 0;
	local other, otherCount = {}, 0;
	if (next(data.npcDeaths)) then
		if (NRC.zones[data.instanceID] and NRC.zones[data.instanceID].trash) then
			--If we have a trash list set then split main trash mobs and other npcs.
			for k, v in pairs(data.npcDeaths) do
				if (NRC.zones[data.instanceID].trash[tonumber(k)]) then
					trashCount = trashCount + v.count;
					tinsert(trash, v);
				elseif (not NRC.zones[data.instanceID].bosses[tonumber(k)]) then
					otherCount = otherCount+ v.count;
					tinsert(other, v);
				end
			end
		else
			--Else add all npcs to the trash list.
			for k, v in pairs(data.npcDeaths) do
				trashCount = trashCount + v.count;
				tinsert(trash, v);
			end
		end
		table.sort(trash, function(a, b) return a.name < b.name end);
		table.sort(other, function(a, b) return a.name < b.name end);
	end
	local text = "|cFFFFFF00" .. L["Trash"] .. " (" .. trashCount .. ")|r";
	if (next(trash)) then
		for k, v in pairs(trash) do
			text = text .. "\n|cFF9CD6DE" .. v.name .. ":|r " .. v.count;
		end
	else
		text = text .. "\n|cFF9CD6DE" .. L["None"] .. ".|r";
	end
	if (next(other)) then
		text = text .. "\n\n|cFFFFFF00" .. L["Other NPCs"] .. " (" .. otherCount .. ")|r";
		for k, v in pairs(other) do
			text = text .. "\n|cFF9CD6DE" .. v.name .. ":|r " .. v.count;
		end
	end
	raidLogFrame.scrollChild.fs2:SetPoint("TOPLEFT", lastBossFrame, "BOTTOMLEFT", 10, -30);
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.fs2:SetText(text);
	setBottomText(data, logID);
end

function NRC:loadRaidLogDeaths(logID)
	clearRaidLogFrame();
	raidLogFrame.frameType = "deaths";
	updateFrames();
	setInstanceTexture(logID);
	--raidLogFrame.showAllTabs();
	local data = NRC.db.global.instances[logID];
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -14);
	raidLogFrame.scrollChild.fs2:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.rfs:ClearAllPoints();
	raidLogFrame.scrollChild.rfs:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPLEFT", 143, -70);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.rfs:Show();
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	local text = "|cFFFFFF00" .. L["Total Deaths"] .. ": ";
	local text2 = "";
	local text3 = "";
	local rText = "|cFF9CD6DE";
	local deaths, bossDeaths, trashDeaths, deathData = getDeathData(logID);
	if (deaths) then
		local deathsText = "|cFFFF3333" .. deaths .. "|r";
		if (deaths == 0) then
			deathsText = "|cFF00C800" .. deaths .. "|r";
		end
		text = text .. deathsText;
		local bossDeathsText = "|cFFFF3333" .. bossDeaths .. "|r";
		if (bossDeaths == 0) then
			bossDeathsText = "|cFF00C800" .. bossDeaths .. "|r";
		end
		text2 = text2 .. "\n|cFF9CD6DE" .. L["On Bosses"] .. ":|r " .. bossDeathsText;
		local trashDeathsText = "|cFFFF3333" .. trashDeaths .. "|r";
		if (trashDeaths == 0) then
			trashDeathsText = "|cFF00C800" .. trashDeaths .. "|r";
		end
		text2 = text2 .. "\n|cFF9CD6DE" .. L["On Trash"] .. ":|r " .. trashDeathsText;
	else
		text = text .. "0";
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	end
	--Insert change the table so it can be sorted by time.
	local d = {};
	for player, playerDeaths in pairs(deathData) do
		for k, v in pairs(playerDeaths) do
			local t = {
				name = player,
				class = v.class,
				timestamp = v.timestamp,
				encounterID = v.encounterID,
				sourceName = v.sourceName;
				spellID = v.spellID;
				spellName = v.spellName;
				spellSchool = v.spellSchool;
				totalAmount = v.totalAmount;
				overkill = v.overkill;
				resisted = v.resisted;
				blocked = v.blocked;
				absorbed = v.absorbed;
				critical = v.critical;
				glancing = v.glancing;
				crushing = v.crushing;
			};
			tinsert(d, t);
		end
	end
	NRC:sortByKey(d, "timestamp");
	for k, v in ipairs(d) do
		local encounterText = "";
		if (v.encounterID) then
			encounterText = strsub(getEncounterNameFromID(v.encounterID, logID), 1, 22);
		else
			encounterText = L["Trash"];
		end
		local dmgText = "- ";
		if (v.sourceName) then
			if (v.hostileSource) then
				dmgText = dmgText .. v.sourceName .. "(MC) ";
			else
				dmgText = dmgText .. v.sourceName .. " ";
			end
		end
		if (v.spellName) then
			if (v.sourceName) then
				dmgText = dmgText .. "|cFFFF1313" .. v.spellName .. "|r";
			else
				dmgText = v.spellName;
			end
		end
		if (v.totalAmount) then
			if (v.spellName) then
				dmgText = dmgText .. " ";
			end
			dmgText = dmgText .. L["hit"] .. " |cFFFF1313" .. v.totalAmount .. "|r";
			if (v.spellSchool) then
				dmgText = dmgText .. " " ..  GetSchoolString(v.spellSchool);
			end
			if (v.overkill) then
				dmgText = dmgText .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_OVERKILLING, v.overkill);
			end
			if (v.resisted) then
				dmgText = dmgText .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_RESIST, v.resisted);
			end
			if (v.blocked) then
				dmgText = dmgText .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_BLOCK, v.blocked);
			end
			if (v.absorbed) then
				dmgText = dmgText .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_ABSORB, v.absorbed);
			end
			if (v.critical) then
				dmgText = dmgText .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL;
			end
			if (v.glancing) then
				dmgText = dmgText .. " " .. TEXT_MODE_A_STRING_RESULT_GLANCING;
			end
			if (v.crushing) then
				dmgText = dmgText .. " " .. TEXT_MODE_A_STRING_RESULT_CRUSHING;
			end
		end
		local _, _, _, classColorHex = GetClassColor(v.class);
		--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
		if (not classColorHex and v.class == "SHAMAN") then
			classColorHex = "ff0070dd";
		elseif (not classColorHex) then
			classColorHex = "ffffffff";
		end
		if (dmgText == "" or dmgText == "- ") then
			dmgText = "-  (Unknown Damage)";
		end
		if (v.hostileDest) then
			v.name = v.name .. "(MC)";
		end
		text3 = text3 .. "\n|cFFA1A1A1" .. NRC:getTimeFormat(v.timestamp, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. dmgText .. "|r";
		rText = rText .. "\n" .. encounterText;
	end
	raidLogFrame.scrollChild.fs:SetText(text);
	raidLogFrame.scrollChild.fs2:SetText(text2);
	NRC:splitAndAnchorFontstring(text3, 50, raidLogFrame.scrollChild, 148, -70);
	raidLogFrame.scrollChild.rfs:SetText(rText);
	setBottomText(data, logID);
end

local lootStartOffset, lootPadding, lootOffset = 45, 18, 0;
local usedLootFrameCount = 0;
local currentLootData = {}; --Mapped to lineFrameCount;
local function setLootText(logID, lootID, lineFrameCount, displayNum, text, lootData, isHeader, isSpacer, updateTextOnly)
	local frame = raidLogFrame.getSimpleLineFrame(lineFrameCount)
	if (frame) then
		if (not updateTextOnly) then
			if (lineFrameCount == 1) then
				lootOffset = lootStartOffset;
			else
				lootOffset = lootOffset + lootPadding;
			end
			frame:ClearAllPoints();
			frame:SetHeight(18);
			frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 3, -lootOffset);
			frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -30, 0);
		end
		if (lootData) then
			currentLootData[lineFrameCount] = lootData;
		end
		if (displayNum < 10) then
			--Offset the text for single digit numbers so the date comlumn lines up.
			frame.fs:SetPoint("LEFT", 12, 0);
		else
			frame.fs:SetPoint("LEFT", 5, 0);
		end
		if (displayNum > 0) then
			--Only display number if not a header or spacer;
			frame.fs:SetText("|cFF9CD6DE" .. displayNum .. ")|r");
			frame.fs2:SetPoint("LEFT", 28, 0);
			frame.fs2:SetText(text);
			frame.borderFrame:Show();
			frame:EnableMouse(true);
		else
			frame.fs:SetText(text);
			frame.fs2:SetText("");
			frame.borderFrame:Hide();
			frame:EnableMouse(false);
		end
		if (not isHeader and not isSpacer) then
			frame:SetScript("OnClick", function(self, button)
				if (button == "RightButton") then
					NRC:loadRenameLootFrame(logID, lootID, lineFrameCount, displayNum, frame);
				else
					
				end
			end)
		else
			frame:SetScript("OnClick", function(self, button)
			end)
		end
		frame:Show();
	end
end

function NRC:loadRenameLootFrame(logID, lootID, lineFrameCount, displayNum, frame)
	if (not lootRenameFrame) then
		lootRenameFrame = NRC:createTextInputFrameLoot("NRCRaidLootRenameFrame", 300, 95, raidLogFrame);
		lootRenameFrame.setButton:SetPoint("BOTTOM", lootRenameFrame, "Bottom", -55, 5);
		lootRenameFrame.setButton:SetText(L["Set"]);
		lootRenameFrame.setButton:Show();
		lootRenameFrame.resetButton:SetPoint("BOTTOM", lootRenameFrame, "Bottom", 55, 5);
		lootRenameFrame.resetButton:SetText(L["Clear"]);
		lootRenameFrame.resetButton:Show();
	end
	local data = NRC.db.global.instances[logID];
	local looter = data.loot[lootID].name;
	lootRenameFrame.dropdownMenu.initialize = function(dropdown)
		if (data and next(data.group)) then
			local first;
			local options = {};
			for guid, charData in pairs(data.group) do
				local t = {
					guid = guid,
					name = charData.name,
					class = charData.class,
				};
				tinsert(options, t);
			end
			table.sort(options, function(a, b)
				return a.class < b.class
					or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
			end)
			for k, v in ipairs(options) do
				local _, _, _, classHex = GetClassColor(v.class);
				local name = "|c" .. classHex .. v.name .. "|r";
				local info = NRC.DDM:UIDropDownMenu_CreateInfo();
				info.text = name;
				info.nrcClass = v.class;
				info.checked = false;
				info.value = {
					name = v.name,
					class = v.class,
				}
				first = v.name;
				info.func = function(self)
					NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value);
				end
				NRC.DDM:UIDropDownMenu_AddButton(info);
			end
			local text = "Select Character";
			if (data.loot[lootID].override) then
				local _, _, _, classHex = GetClassColor(data.loot[lootID].overrideClass);
				text = "|c" .. classHex .. data.loot[lootID].override;
			elseif (looter) then
				for k, v in ipairs(options) do
					if (looter == v.name) then
						local _, _, _, classHex = GetClassColor(v.class);
						text = "|c" .. classHex .. v.name;
					end
				end
			end
			NRC.DDM:UIDropDownMenu_SetText(lootRenameFrame.dropdownMenu, text);
		else
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "No group found";
			info.checked = false;
			info.value = "No group found";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			NRC.DDM:UIDropDownMenu_SetText(lootRenameFrame.dropdownMenu, "No group found");
		end
	end
	NRC.DDM:UIDropDownMenu_Initialize(lootRenameFrame.dropdownMenu, lootRenameFrame.dropdownMenu.initialize);
	lootRenameFrame.dropdownMenu:Show();
	
	lootRenameFrame.logID = logID;
	lootRenameFrame.lootID = lootID;
	local itemLink = data.loot[lootID].itemLink;
	lootRenameFrame.fs:SetText("|cFFFFFF00" .. string.format(L["changeLootEntry"], "|cFFFF6900" .. displayNum .. "|r"));
	lootRenameFrame.fs2:SetText(itemLink);
	lootRenameFrame:ClearAllPoints();
	--lootRenameFrame:SetPoint("CENTER", frame, "CENTER", -150, 0);
	lootRenameFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 70, 0);
	lootRenameFrame.setButton:SetScript("OnClick", function(self, arg)
		local text = NRC.DDM:UIDropDownMenu_GetText(lootRenameFrame.dropdownMenu);
		local data = NRC.DDM:UIDropDownMenu_GetSelectedValue(lootRenameFrame.dropdownMenu);
		if (text ~= "No group found" and text ~= "Select Character") then
			local name = data.name;
			local class = data.class;
			NRC.db.global.instances[lootRenameFrame.logID].loot[lootRenameFrame.lootID].override = name;
			NRC.db.global.instances[lootRenameFrame.logID].loot[lootRenameFrame.lootID].overrideClass = class;
			currentLootData[lineFrameCount].override = name;
			currentLootData[lineFrameCount].overrideClass = class;
			--lootRenameFrame.input:SetText("");
			--lootRenameFrame.input:ClearFocus();
			local _, _, _, classHex = GetClassColor(class);
			NRC:print(string.format(L["renamedLootEntry"], "|cFF9CD6DE" .. displayNum .. "|r", "|c" .. classHex .. name .. "|r", itemLink) .. ".");
			local encounterText = "";
			local lootText = "";
			local v = currentLootData[lineFrameCount];
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				local boss;
				if (itemID) then
					boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
				end
				if (boss) then
					encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
				else
					--encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
				end
				lootText = lootText .. v.itemLink;
				if (v.amount and tonumber(v.amount) > 0) then
					lootText = lootText .. "x" .. v.amount;
				end
			end
			local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and getClass(v.name, logID) == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local text;
			local goldString = "";
			if (v.gold and v.gold > 0) then
				goldString = "  " .. NRC:getCoinString(v.gold, 10);
			end
			if (v.override) then
				if (v.overrideClass) then
					_, _, _, classColorHex = GetClassColor(v.overrideClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.overrideClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				goldString = ""
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.override .. "|r|cFF00C800*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			elseif (v.traded) then
				if (v.tradedClass) then
					_, _, _, classColorHex = GetClassColor(v.tradedClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.tradedClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.traded .. "|r|cFFFF5100*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;	
			else
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			end
			setLootText(logID, lootID, lineFrameCount, displayNum, text, nil, nil, nil, true);
			if (NRCExportFrame and NRCExportFrame:IsShown()) then
				NRC:loadLootExportFrame(logID, true);
			end
			lootRenameFrame:Hide();
		else
			NRC:print("No valid character set for loot entry.");
		end
		--[[local text = NRC.DDM:UIDropDownMenu_GetSelectedValue(lootRenameFrame.dropdownMenu);
		if (text ~= "No group found" and text ~= "Select Character") then
			NRC.db.global.instances[lootRenameFrame.logID].loot[lootRenameFrame.lootID].override = text;
			NRC.db.global.instances[lootRenameFrame.logID].loot[lootRenameFrame.lootID].overrideClass = text;
			--lootRenameFrame.input:SetText("");
			--lootRenameFrame.input:ClearFocus();
			NRC:print(string.format(L["renamedLogEntry"], "|cFFFF6900" .. displayNum .. "|r", text) .. ".");
			NRC:loadRaidLogLoot(logID);
			lootRenameFrame:Hide();
		else
			NRC:print("No valid character set for loot entry.");
		end]]
	end)
	lootRenameFrame.resetButton:SetScript("OnClick", function(self, arg)
		NRC.db.global.instances[lootRenameFrame.logID].loot[lootRenameFrame.lootID].override = nil;
		--lootRenameFrame.input:ClearFocus();
		NRC:print(string.format(L["clearedLootEntry"], "|cFF9CD6DE" .. displayNum.. "|r") .. ".");
		NRC:loadRaidLogLoot(logID);
		if (NRCExportFrame and NRCExportFrame:IsShown()) then
			NRC:loadLootExportFrame(logID, true);
		end
	end)
	lootRenameFrame:Show();
	--lootRenameFrame.input:SetFocus();
end

function NRC:loadRaidLogLoot(logID)
	clearRaidLogFrame();
	raidLogFrame.frameType = "loot";
	updateFrames();
	setInstanceTexture(logID);
	local data = NRC.db.global.instances[logID];
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 10, -14);
	raidLogFrame.scrollChild.fs2:SetText("|cFF9CD6DERight click an entry to change looter.|r");
	raidLogFrame.scrollChild.fs3:ClearAllPoints();
	raidLogFrame.scrollChild.fs3:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 633, -21);
	raidLogFrame.scrollChild.fs3:SetText("|cFFA1A1A1|cFFFF5100*|r = Mapped to trade\n|cFF00C800*|r = Right click edited|r");
	raidLogFrame.scrollChild.rfs:ClearAllPoints();
	raidLogFrame.scrollChild.rfs:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPLEFT", 143, -30);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.fs3:Show();
	raidLogFrame.scrollChild.rfs:Show();
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	raidLogFrame.scrollChild.exportButton:ClearAllPoints();
	raidLogFrame.scrollChild.exportButton:SetPoint("TOPRIGHT", -200, -5);
	raidLogFrame.scrollChild.exportButton:SetSize(110, 25);
	raidLogFrame.scrollChild.exportButton:SetText(L["Export"]);
	raidLogFrame.scrollChild.exportButton:SetScript("OnClick", function(self, arg)
		NRC:loadLootExportFrame(logID);
	end)
	raidLogFrame.scrollChild.exportButton:Show();
	raidLogFrame.scrollChild.checkbox.Text:SetText("|cFF9CD6DE" .. L["Map loot to trades"]);
	raidLogFrame.scrollChild.checkbox.tooltip2.fs:SetText("|Cffffd000" .. L["mapTradesToLootTooltip"]);
	raidLogFrame.scrollChild.checkbox:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -150, -1);
	raidLogFrame.scrollChild.checkbox:SetChecked(NRC.config.mapLootDisplayToTrades);
	raidLogFrame.scrollChild.checkbox:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox:GetChecked();
		NRC.config.mapLootDisplayToTrades = value;
		NRC:loadRaidLogLoot(logID);
		if (NRCExportFrame and NRCExportFrame:IsShown()) then
			NRC:loadLootExportFrame(logID, true);
		end
	end)
	raidLogFrame.scrollChild.checkbox:Show();
	--0 	Poor 	Poor 	ITEM_QUALITY0_DESC
	--1 	Common 	Common 	ITEM_QUALITY1_DESC
	--2 	Uncommon 	Uncommon 	ITEM_QUALITY2_DESC
	--3 	Rare 	Rare 	ITEM_QUALITY3_DESC
	--4 	Epic 	Epic 	ITEM_QUALITY4_DESC
	--5 	Legendary 	Legendary 	ITEM_QUALITY5_DESC
	--6 	Artifact 	Artifact 	ITEM_QUALITY6_DESC
	--7 	Heirloom 	Heirloom 	ITEM_QUALITY7_DESC
	--8 	WoWToken 	WoW Token 	ITEM_QUALITY8_DESC
	local text = "|cFFFFFF00" .. L["Total Loot"] .. ":|r ";
	local text2 = "";
	local text3 = "";
	local rText = "";
	local minQuality = 4;
	--If quality is all/main then show purple+ first and then greens.
	--Create a dropdown menu for showing other stuff? Do we even bother recording lower than green quality loot?
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, 2);
	if (loot) then
		text = "|cFFFFFF00" .. L["Total Loot"] .. ":|r |cFFFFFFFF" .. loot;
	else
		text = "|cFFFFFF00" .. L["Total Loot"] .. ":|r 0";
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	end
	local lineFrameCount = 0;
	local textCount = 0;
	currentLootData = {};
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	--Legendaries and higher.
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, 5, nil, nil, nil, nil, nil, mapToTrades);
	if (lootData and next(lootData)) then
		local text = "|c" .. select(4, GetItemQualityColor(5)) .. ITEM_QUALITY5_DESC .. ":|r |cFFFFFF00(" .. loot .. ")|r";
		local text2 = "";
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, text, nil, true);
		for k, v in ipairs(lootData) do
			local encounterText = "";
			local lootText = "";
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				local boss;
				if (itemID) then
					boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
				end
				if (boss) then
					encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
				else
					--encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
				end
				lootText = lootText .. v.itemLink;
				if (v.amount and tonumber(v.amount) > 0) then
					lootText = lootText .. "x" .. v.amount;
				end
			end
			local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and getClass(v.name, logID) == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local text;
			local goldString = "";
			if (v.gold and v.gold > 0) then
				goldString = "  " .. NRC:getCoinString(v.gold, 10);
			end
			if (v.override) then
				if (v.overrideClass) then
					_, _, _, classColorHex = GetClassColor(v.overrideClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.overrideClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				goldString = ""
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.override .. "|r|cFF00C800*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			elseif (v.traded) then
				if (v.tradedClass) then
					_, _, _, classColorHex = GetClassColor(v.tradedClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.tradedClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.traded .. "|r|cFFFF5100*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;	
			else
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			end
			lineFrameCount = lineFrameCount + 1;
			textCount = textCount + 1;
			setLootText(logID, v.lootID, lineFrameCount, textCount, text, v);
		end
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, "", nil, nil, true);
	end
	--Epics.
	textCount = 0;
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, nil, 4, nil, nil, nil, nil, mapToTrades);
	if (lootData and next(lootData)) then
		local text = "|c" .. select(4, GetItemQualityColor(4)) .. ITEM_QUALITY4_DESC .. ":|r |cFFFFFF00(" .. loot .. ")|r";
		local text2 = "";
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, text, nil, true);
		for k, v in ipairs(lootData) do
			local encounterText = "";
			local lootText = "";
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				local boss;
				if (itemID) then
					boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
				end
				if (boss) then
					encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
				else
					--encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
				end
				lootText = lootText .. v.itemLink;
				if (v.amount and tonumber(v.amount) > 0) then
					lootText = lootText .. "x" .. v.amount;
				end
			end
			local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and getClass(v.name, logID) == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local text;
			local goldString = "";
			if (v.gold and v.gold > 0) then
				goldString = "  " .. NRC:getCoinString(v.gold, 10);
			end
			if (v.override) then
				if (v.overrideClass) then
					_, _, _, classColorHex = GetClassColor(v.overrideClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.overrideClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				goldString = ""
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.override .. "|r|cFF00C800*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;	
			elseif (v.traded) then
				if (v.tradedClass) then
					_, _, _, classColorHex = GetClassColor(v.tradedClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.tradedClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.traded .. "|r|cFFFF5100*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;	
			else
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			end
			lineFrameCount = lineFrameCount + 1;
			textCount = textCount + 1;
			setLootText(logID, v.lootID, lineFrameCount, textCount, text, v);
		end
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, "", nil, nil, true);
	end
	--Blues.
	textCount = 0;
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, nil, 3, nil, nil, nil, nil, mapToTrades);
	if (lootData and next(lootData)) then
		local text = "|c" .. select(4, GetItemQualityColor(3)) .. ITEM_QUALITY3_DESC .. ":|r |cFFFFFF00(" .. loot .. ")|r";
		local text2 = "";
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, text, nil, true);
		for k, v in ipairs(lootData) do
			local encounterText = "";
			local lootText = "";
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				local boss;
				if (itemID) then
					boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
				end
				if (boss) then
					encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
				else
					--encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
				end
				lootText = lootText .. v.itemLink;
				if (v.amount and tonumber(v.amount) > 0) then
					lootText = lootText .. "x" .. v.amount;
				end
			end
			local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and getClass(v.name, logID) == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local text;
			local goldString = "";
			if (v.gold and v.gold > 0) then
				goldString = "  " .. NRC:getCoinString(v.gold, 10);
			end
			if (v.override) then
				if (v.overrideClass) then
					_, _, _, classColorHex = GetClassColor(v.overrideClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.overrideClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				goldString = ""
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.override .. "|r|cFF00C800*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			elseif (v.traded) then
				if (v.tradedClass) then
					_, _, _, classColorHex = GetClassColor(v.tradedClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.tradedClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.traded .. "|r|cFFFF5100*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;	
			else
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r " .. encounterText .. goldString;
			end
			lineFrameCount = lineFrameCount + 1;
			textCount = textCount + 1;
			setLootText(logID, v.lootID, lineFrameCount, textCount, text, v);
		end
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, "", nil, nil, true);
	end
	--Greens.
	textCount = 0;
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, nil, 2, nil, nil, nil, nil, mapToTrades);
	if (lootData and next(lootData)) then
		local text = "|c" .. select(4, GetItemQualityColor(2)) .. ITEM_QUALITY2_DESC .. ":|r |cFFFFFF00(" .. loot .. ")|r";
		local text2 = "";
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, text, nil, true);
		for k, v in ipairs(lootData) do
			local encounterText = "";
			local lootText = "";
			if (v.itemLink) then
				--local _, itemID = strsplit(":", v.itemLink);
				local itemID = strmatch(v.itemLink, "item:(%d+)");
				local boss;
				if (itemID) then
					boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
				end
				if (boss) then
					encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
				else
					--encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
				end
				lootText = lootText .. v.itemLink;
				if (v.amount and tonumber(v.amount) > 0) then
					lootText = lootText .. "x" .. v.amount;
				end
			end
			local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and GetClassColor(getClass(v.name, logID)) == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local text;
			local goldString = "";
			if (v.gold and v.gold > 0) then
				goldString = "  " .. NRC:getCoinString(v.gold, 10);
			end
			if (v.override) then
				if (v.overrideClass) then
					_, _, _, classColorHex = GetClassColor(v.overrideClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.overrideClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				goldString = ""
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.override .. "|r|cFF00C800*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText;
			elseif (v.traded) then
				if (v.tradedClass) then
					_, _, _, classColorHex = GetClassColor(v.tradedClass);
					--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
					if (not classColorHex and v.tradedClass == "SHAMAN") then
						classColorHex = "ff0070dd";
					elseif (not classColorHex) then
						classColorHex = "ffffffff";
					end
				end
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.traded .. "|r|cFFFF5100*|r  |cFFcccccc" .. lootText .. "|r " .. encounterText;	
			else
				text = "|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r " .. encounterText;
			end
			lineFrameCount = lineFrameCount + 1;
			textCount = textCount + 1;
			setLootText(logID, v.lootID, lineFrameCount, textCount, text, v);
		end
		lineFrameCount = lineFrameCount + 1;
		setLootText(logID, nil, lineFrameCount, 0, "", nil, nil, true);
	end
	raidLogFrame.scrollChild.fs:SetText(text);
	--NRC:splitAndAnchorFontstring(text3, 50, raidLogFrame.scrollChild, 148, -30);
	--raidLogFrame.scrollChild.rfs:SetText(rText);
	setBottomText(data, logID);
	lootStartOffset, lootPadding, lootOffset = 45, 18, 0;
end

function NRC:loadRaidBossLoot(logID, encounterID, encounterName, attemptID)
	clearRaidLogFrame();
	raidLogFrame.frameType = "bossLoot";
	updateFrames();
	setInstanceTexture(logID);
	local data = NRC.db.global.instances[logID];
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 30, -24);
	raidLogFrame.scrollChild.fs3:ClearAllPoints();
	raidLogFrame.scrollChild.fs3:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 218, -70);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.fs3:Show();
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	local model = NRC:getPortableModelFrame(encounterID, encounterName);
	if (model) then
		model:ClearAllPoints();
		model:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 0, 0);
		model:SetSize(200, 200);
		model:Show();
	else
		NRC:debug("Missing model info for:", encounterID, encounterName);
	end
	local text = "|cFFFFFF00" .. encounterName .. " " .. L["Loot"] .. ":|r ";
	local text2 = "";
	local text3 = "";
	--local rText = "";
	local minQuality = 1;
	--If quality is all/main then show purple+ first and then greens.
	--Create a dropdown menu for showing other stuff? Do we even bother recording lower than green quality loot?
	local loot, bossLoot, trashLoot, lootData = getLootData(logID, minQuality, nil, nil, encounterID);
	if (data.encounters and data.encounters[attemptID] and data.encounters[attemptID].success ~= 1) then
		text = text .. L["None found"] .. " (Wipe).";
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	elseif (loot and encounterID) then
		text = "|cFFFFFF00" .. encounterName .. " " .. L["Loot"] .. ":|r " .. loot;
	else
		text = text .. L["None found"] .. ".";
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	end
	for k, v in ipairs(lootData) do
		local encounterText = "";
		local lootText = "";
		if (v.itemLink) then
			--local _, itemID = strsplit(":", v.itemLink);
			local itemID = strmatch(v.itemLink, "item:(%d+)");
			local boss;
			if (itemID) then
				boss = NRC:getBossFromLoot(tonumber(itemID), data.instanceID, logID, v.time or v.timer);
			end
			if (boss) then
				encounterText = "|cFF9CD6DE(" .. strsub(boss.name, 1, 22) .. ")|r";
			else
				encounterText = "|cFF9CD6DE(" .. L["Trash"] .. ")|r";
			end
			lootText = lootText .. v.itemLink;
			if (v.amount and tonumber(v.amount) > 0) then
				lootText = lootText .. "x" .. v.amount;
			end
		end
		local _, _, _, classColorHex = GetClassColor(getClass(v.name, logID));
		--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
		if (not classColorHex and getClass(v.name, logID) == "SHAMAN") then
			classColorHex = "ff0070dd";
		elseif (not classColorHex) then
			classColorHex = "ffffffff";
		end
		text3 = text3 .. "\n|cFFA1A1A1" .. NRC:getTimeFormat(v.time or v.timer, nil, true, true, true) .. "|r  |c" .. classColorHex .. v.name .. "|r  |cFFcccccc" .. lootText .. "|r";
		--rText = rText .. "\n" .. encounterText;
	end
	raidLogFrame.scrollChild.fs:SetText(text);
	raidLogFrame.scrollChild.fs2:SetText(text2);
	raidLogFrame.scrollChild.fs3:SetText(text3);
	--raidLogFrame.scrollChild.rfs:SetText(rText);
	setBottomText(data, logID);
end

function NRC:loadRaidTalents(logID, encounterID, encounterName, attemptID)
	clearRaidLogFrame();
	raidLogFrame.frameType = "bossTalents";
	updateFrames();
	setInstanceTexture(logID);
	local data = NRC.db.global.instances[logID];
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -34);
	raidLogFrame.scrollChild.fs3:ClearAllPoints();
	raidLogFrame.scrollChild.fs3:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 318, -70);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.fs3:Show();
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	local model = NRC:getPortableModelFrame(encounterID, encounterName);
	if (model) then
		model:ClearAllPoints();
		model:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 0, 0);
		model:SetSize(200, 200);
		model:Show();
	else
		NRC:debug("Missing model info for:", encounterID, encounterName);
	end
	local text = "|cFFFFFF00" .. L["Talent Snapshot for"] .. " " .. encounterName .. "|r";
	local text2 = "";
	local talents = NRC:getAllTalentsFromEncounter(logID, encounterID, attemptID);
	if (not talents) then
		text2 = text2 .. "|cFFFFFFFF" .. L["No talents found"] .. ".";
		raidLogFrame.scrollChild.fs:SetText(text);
		raidLogFrame.scrollChild.fs2:SetText(text2);
		return;
	end
	text2 = text2 .. "|cFFFFFFFF" .. L["Click to view talents"];
	local count = 0;
	local offset = 20;
	for k, talentString in NRC:pairsByKeys(talents) do
		count = count + 1;
		local classID, trees = strsplit("-", talentString, 2);
		classID = tonumber(classID);
		local class, classEnglish = GetClassInfo(classID);
		local specID, talentCount, specName, specIcon, specIconPath, treeData = NRC:getSpecFromTalentString(talentString);
		trees = {strsplit("-", trees, 4)};
		local _, _, _, classHex = GetClassColor(classEnglish);
		local colorizedName = "|c" .. classHex .. k .. "|r";
		local icon = "|T" .. specIconPath .. ":17:17:0:-1|t";
		local treeString = "|cFF9CD6DE(" .. treeData[1] .. "/" .. treeData[2] .. "/" .. treeData[3] .. ")|r";
		local text3 = colorizedName .. "  " .. treeString .. "  |cFF9CD6DE" .. specName .. "|r";
		local button = raidLogFrame.getExtraButton(count);
		button:SetSize(280, 20);
		button.fs2:SetText(text3);
		button.fs3:SetText(icon);
		--button:SetPoint("TOPRIGHT", raidLogFrame.scrollChild.fs3, "TOPLEFT", -15, -(offset * count));
		button:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -(40 + (offset * count)));
		button:SetScript("OnClick", function(self, arg)
			NRC:openTalentFrame(k, talentString);
		end)
		button:Show();
	end
	raidLogFrame.scrollChild.fs:SetText(text);
	raidLogFrame.scrollChild.fs2:SetText(text2);
	setBottomText(data, logID);
end

local trackedItemsFrame;
local function openTrackedItemsList()
	if (not trackedItemsFrame) then
		trackedItemsFrame = NRC:createSimpleScrollFrame("NRCTrackedItemsFrame", 450, 400, 0, 100);
		trackedItemsFrame.scrollChild.fs:SetFont(NRC.regionFont, 14);
		trackedItemsFrame.scrollChild.fs2:SetFont(NRC.regionFont, 14);
		trackedItemsFrame.scrollChild.fs2:SetSpacing(1);
		--trackedItemsFrame.scrollChild.fs2:SetPoint("TOPLEFT", 10, -24);
		trackedItemsFrame.scrollChild.fs:SetText("|cFFFFFF00" .. L["Tracked Items"] .. "|r");
		--trackedItemsFrame.EditBox:SetFont(NRC.regionFont, 13, ");
		--trackedItemsFrame.EditBox:SetWidth(trackedItemsFrame:GetWidth() - 10);
	end
	local d = {};
	for k, v in pairs(NRC.trackedItems) do
		v.spellID = k;
		tinsert(d, v);
	end
	--NRC:sortByKey(d, "name");
	table.sort(d, function(a, b)
		return a.name < b.name
	    	or a.name == b.name and a.spellID < b.spellID;
	    --return a.name < b.name;
	end)
	--NRC:debug(d)
	local text = "";
	--Non-foods first.
	for k, v in ipairs(d) do
		if (not NRC.foods[v.spellID] and not NRC.scrolls[v.spellID]
				and not NRC.interrupts[v.spellID] and not NRC.racials[v.spellID]) then
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.itemID .. ")|cFFA1A1A1";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--local rank = GetSpellSubtext(v.spellID);
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.spellID .. ")|r";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			--if (v.desc and NRC.foods[v.spellID]) then
			--	item = item .. " |cFFDEDE42" .. v.desc .. ".|r";
			--end
			if (v.icon) then
				icon = "|T" .. v.icon .. ":13:13|t";
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:13:13|t";
			end
			text = text .. icon .. " " .. item .. "\n";
		end
	end
	--Interrupts.
	for k, v in ipairs(d) do
		if (NRC.interrupts[v.spellID]) then
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.itemID .. ")|cFFA1A1A1";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--local rank = GetSpellSubtext(v.spellID);
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.spellID .. ")|r";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			if (v.icon) then
				icon = "|T" .. v.icon .. ":13:13|t";
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:13:13|t";
			end
			text = text .. icon .. " " .. item .. "\n";
		end
	end
	--Racials.
	for k, v in ipairs(d) do
		if (NRC.racials[v.spellID]) then
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.itemID .. ")|cFFA1A1A1";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--local rank = GetSpellSubtext(v.spellID);
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.spellID .. ")|r";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			if (v.icon) then
				icon = "|T" .. v.icon .. ":13:13|t";
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:13:13|t";
			end
			text = text .. icon .. " " .. item .. "\n";
		end
	end
	--Scrolls.
	for k, v in ipairs(d) do
		if (NRC.scrolls[v.spellID]) then
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.itemID .. ")|cFFA1A1A1";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--local rank = GetSpellSubtext(v.spellID);
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.spellID .. ")|r";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			if (v.desc) then
				item = item .. " |cFFDEDE42" .. v.desc .. ".|r";
			end
			if (v.icon) then
				icon = "|T" .. v.icon .. ":13:13|t";
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:13:13|t";
			end
			text = text .. icon .. " " .. item .. "\n";
		end
	end
	--Foods at the end for neatness.
	for k, v in ipairs(d) do
		if (NRC.foods[v.spellID]) then
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.itemID .. ")|cFFA1A1A1";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--local rank = GetSpellSubtext(v.spellID);
				if (v.rank) then
					item = item .. " |cFF9CD6DE(Rank" .. v.rank .. ")|r";
				end
				--item = item .. " |cFFA1A1A1(" .. v.spellID .. ")|r";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			if (v.desc) then
				item = item .. " |cFFDEDE42" .. v.desc .. ".|r";
			end
			if (v.icon) then
				icon = "|T" .. v.icon .. ":13:13|t";
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:13:13|t";
			end
			text = text .. icon .. " " .. item .. "\n";
		end
	end
	trackedItemsFrame.scrollChild.fs2:SetText(text);
	if (not trackedItemsFrame:IsShown()) then
		trackedItemsFrame:Show();
	else
		trackedItemsFrame:Hide();
	end
end

function NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID, guid, resetDropdowns)
	clearRaidLogFrame();
	if (attemptID) then
		raidLogFrame.frameType = "bossConsumes";
	else
		raidLogFrame.frameType = "consumes";
	end
	updateFrames();
	setInstanceTexture(logID);
	local data = NRC.db.global.instances[logID];
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 10, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("LEFT");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -30);
	raidLogFrame.scrollChild.fs2:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.rfs:ClearAllPoints();
	raidLogFrame.scrollChild.rfs:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPLEFT", 143, -70);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.rfs:Show();
	--Remove prefix from certain instance names.
	local instanceName = string.gsub(data.instanceName, ".+: ", "");
	instanceName = NRC:addDiffcultyText(instanceName, data.difficultyName, data.difficultyID);
	raidLogFrame.titleText2.fs:SetText(instanceName);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	raidLogFrame.scrollChild.dropdownMenu:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPRIGHT", -15, -1);
	raidLogFrame.scrollChild.dropdownMenu.tooltip.fs:SetText("|Cffffd000" .. L["consumesEncounterTooltip"]);
	raidLogFrame.scrollChild.dropdownMenu.tooltip:SetWidth(raidLogFrame.scrollChild.dropdownMenu.tooltip.fs:GetStringWidth() + 18);
	raidLogFrame.scrollChild.dropdownMenu.tooltip:SetHeight(raidLogFrame.scrollChild.dropdownMenu.tooltip.fs:GetStringHeight() + 12);
	NRC.DDM:UIDropDownMenu_SetWidth(raidLogFrame.scrollChild.dropdownMenu, 200);
	raidLogFrame.scrollChild.dropdownMenu.initialize = function(dropdown)
		local info = NRC.DDM:UIDropDownMenu_CreateInfo()
		info.text = "|cFF9CD6DE" .. L["All Bosses and Trash"];
		info.checked = false;
		info.value = "all";
		info.func = function(self)
			NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
			NRC:loadRaidLogConsumes(logID, nil, nil, nil);
		end
		NRC.DDM:UIDropDownMenu_AddButton(info);
		local info = NRC.DDM:UIDropDownMenu_CreateInfo()
		info.text = "|cFF9CD6DE" .. L["Last Boss Encounter"];
		info.checked = false;
		info.value = "last";
		info.func = function(self)
			NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
			local last, lastEncounterID, lastEncounterName = 1, 0, "";
			if (data and data.encounters) then
				for k, v in ipairs(data.encounters) do
					last = k;
					lastEncounterID = v.encounterID;
					lastEncounterName = v.encounterName;
				end
			end
			NRC:loadRaidLogConsumes(logID, lastEncounterID, lastEncounterName, last);
		end
		NRC.DDM:UIDropDownMenu_AddButton(info);
		NRC.DDM:UIDropDownMenu_AddSeparator();
		if (data and data.encounters) then
			for k, v in ipairs(data.encounters) do
				local starttTime = v.startTime;
				local startGetTime = v.startGetTime;
				local endGetTime = v.endGetTime;
				local success = v.success;
				local duration = "";
				if (startGetTime and endGetTime) then
					duration = " |cFFA1A1A1(" .. NRC:getTimeString(math.floor(endGetTime - startGetTime), true, "short") .. ")|r";
				end
				local success = " |cFFFF3333Wipe|r";
				if (v.success == 1) then
					success = " |cFF00C800Kill|r";
				end
				local info = NRC.DDM:UIDropDownMenu_CreateInfo()
				info.text = "|cFFDEDE42" .. v.encounterName .. "|r" .. duration .. success;
				info.checked = false;
				info.value = k;
				info.func = function(self)
					NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
					NRC:loadRaidLogConsumes(logID, v.encounterID, v.encounterName, k);
				end
				NRC.DDM:UIDropDownMenu_AddButton(info);
			end
		end
		if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(raidLogFrame.scrollChild.dropdownMenu)) then
			--If no value set then it's first load, set saved db value.
			NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu, "all");
		end
	end
	NRC.DDM:UIDropDownMenu_Initialize(raidLogFrame.scrollChild.dropdownMenu, raidLogFrame.scrollChild.dropdownMenu.initialize);
	--raidLogFrame.scrollChild.dropdownMenu:HookScript("OnShow", function() NRC.DDM:UIDropDownMenu_Initialize(raidLogFrame.scrollChild.dropdownMenu) end);
	--If we reopen then reset the dropdowns.
	if (resetDropdowns) then
		NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu, "all");
	end
	raidLogFrame.scrollChild.dropdownMenu:Show();
	
	local encounterData = NRC.db.global.instances[logID].encounters[attemptID];
	if (encounterData and not encounterID) then
		encounterID = encounterData.encounterID;
	end
	if (encounterData and not encounterName) then
		encounterName = encounterData.encounterName;
	end
	
	raidLogFrame.scrollChild.dropdownMenu2:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -140, -27);
	raidLogFrame.scrollChild.dropdownMenu2.tooltip.fs:SetText("|Cffffd000" .. L["consumesPlayersTooltip"]);
	raidLogFrame.scrollChild.dropdownMenu2.tooltip:SetWidth(raidLogFrame.scrollChild.dropdownMenu2.tooltip.fs:GetStringWidth() + 18);
	raidLogFrame.scrollChild.dropdownMenu2.tooltip:SetHeight(raidLogFrame.scrollChild.dropdownMenu2.tooltip.fs:GetStringHeight() + 12);
	raidLogFrame.scrollChild.dropdownMenu2.initialize = function(dropdown)
		local info = NRC.DDM:UIDropDownMenu_CreateInfo()
		info.text = "|cFF9CD6DE" .. L["All Players"];
		info.checked = false;
		info.value = "all";
		info.func = function(self)
			NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
			NRC:loadRaidLogConsumes(logID, nil, nil, nil);
		end
		NRC.DDM:UIDropDownMenu_AddButton(info);
		NRC.DDM:UIDropDownMenu_AddSeparator();
		if (data and data.group) then
			local options = {};
			for guid, charData in pairs(data.group) do
				local t = {
					guid = guid,
					name = charData.name,
					class = charData.class,
				};
				tinsert(options, t);
			end
			table.sort(options, function(a, b)
				return a.class < b.class
					or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
			end)
			for k, v in ipairs(options) do
				local _, _, _, classHex = GetClassColor(v.class);
				local name = "|c" .. classHex .. v.name .. "|r";
				local info = NRC.DDM:UIDropDownMenu_CreateInfo()
				info.text = name;
				info.checked = false;
				info.value = v.guid;
				info.func = function(self)
					NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
					NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID, v.guid);
				end
				NRC.DDM:UIDropDownMenu_AddButton(info);
			end
		end
		if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(raidLogFrame.scrollChild.dropdownMenu2)) then
			--If no value set then it's first load, set saved db value.
			NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu2, "all");
		end
	end
	NRC.DDM:UIDropDownMenu_Initialize(raidLogFrame.scrollChild.dropdownMenu2, raidLogFrame.scrollChild.dropdownMenu2.initialize);
	--If we reopen then reset the dropdowns.
	if (resetDropdowns) then
		NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu2, "all");
	end
	raidLogFrame.scrollChild.dropdownMenu2:Show();
	
	raidLogFrame.scrollChild.dropdownMenu3:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -140, -54);
	raidLogFrame.scrollChild.dropdownMenu3.tooltip.fs:SetText("|Cffffd000" .. L["consumesViewTooltip"]);
	raidLogFrame.scrollChild.dropdownMenu3.tooltip:SetWidth(raidLogFrame.scrollChild.dropdownMenu3.tooltip.fs:GetStringWidth() + 18);
	raidLogFrame.scrollChild.dropdownMenu3.tooltip:SetHeight(raidLogFrame.scrollChild.dropdownMenu3.tooltip.fs:GetStringHeight() + 12);
	raidLogFrame.scrollChild.dropdownMenu3.initialize = function(dropdown)
		local options = {
			["|cFF9CD6DE" .. L["Count View"]] = 1,
			["|cFF9CD6DE" .. L["Timeline View"]] = 2,
		};
		for k, v in NRC:pairsByKeys(options) do
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = k;
			info.checked = false;
			info.value = v;
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.consumesViewType = v;
				NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
		end
		if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(raidLogFrame.scrollChild.dropdownMenu3)) then
			--If no value set then it's first load, set saved db value.
			NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu3, NRC.config.consumesViewType);
		end
	end
	NRC.DDM:UIDropDownMenu_Initialize(raidLogFrame.scrollChild.dropdownMenu3, raidLogFrame.scrollChild.dropdownMenu3.initialize);
	--If we reopen then reset the dropdowns.
	if (resetDropdowns) then
		NRC.DDM:UIDropDownMenu_SetSelectedValue(raidLogFrame.scrollChild.dropdownMenu3, NRC.config.consumesViewType);
	end
	raidLogFrame.scrollChild.dropdownMenu3:Show();
	
	--If a dropdown value is set then make sure it's used.
	if (not attemptID) then
		local value = NRC.DDM:UIDropDownMenu_GetSelectedValue(raidLogFrame.scrollChild.dropdownMenu);
		--All is shown by default, no need to set it.
		if (value == "last") then
			if (data and data.encounters) then
				for k, v in ipairs(data.encounters) do
					attemptID = k;
				end
			end
		elseif (value ~= "all") then
			attemptID = value;
		end
	end
	if (not guid) then
		local value = NRC.DDM:UIDropDownMenu_GetSelectedValue(raidLogFrame.scrollChild.dropdownMenu2);
		if (value ~= "all") then
			guid = value;
		end
	end
	
	raidLogFrame.scrollChild.normalButton:SetSize(132, 18);
	--raidLogFrame.scrollChild.normalButton:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPRIGHT", -31, -54);
	--raidLogFrame.scrollChild.normalButton:SetPoint("TOPRIGHT", raidLogFrame.scrollChild.dropdownMenu, "TOPLEFT", -5, 0);
	raidLogFrame.scrollChild.normalButton:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, "TOPRIGHT", -31, -159);
	raidLogFrame.scrollChild.normalButton:SetText(L["Tracked Items List"]);
	raidLogFrame.scrollChild.normalButton:SetScript("OnClick", function(self, arg)
		openTrackedItemsList();
	end)
	raidLogFrame.scrollChild.normalButton:Show();
	
	raidLogFrame.scrollChild.checkbox.Text:SetText("|cFF9CD6DE" .. L["Consumes"]);
	raidLogFrame.scrollChild.checkbox.tooltip2.fs:SetText("|Cffffd000" .. L["itemUseShowConsumesTooltip"]);
	raidLogFrame.scrollChild.checkbox:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -100, -80);
	raidLogFrame.scrollChild.checkbox:SetChecked(NRC.config.itemUseShowConsumes);
	raidLogFrame.scrollChild.checkbox:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox:GetChecked();
		NRC.config.itemUseShowConsumes = value;
		NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
	end)
	raidLogFrame.scrollChild.checkbox:Show();
	
	raidLogFrame.scrollChild.checkbox2.Text:SetText("|cFF9CD6DE" .. L["Scrolls"]);
	raidLogFrame.scrollChild.checkbox2.tooltip2.fs:SetText("|Cffffd000" .. L["itemUseShowScrollsTooltip"]);
	raidLogFrame.scrollChild.checkbox2:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox2:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -100, -97);
	raidLogFrame.scrollChild.checkbox2:SetChecked(NRC.config.itemUseShowScrolls);
	raidLogFrame.scrollChild.checkbox2:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox2:GetChecked();
		NRC.config.itemUseShowScrolls = value;
		NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
	end)
	raidLogFrame.scrollChild.checkbox2:Show();
	
	raidLogFrame.scrollChild.checkbox3.Text:SetText("|cFF9CD6DE" .. L["Interrupts"]);
	raidLogFrame.scrollChild.checkbox3.tooltip2.fs:SetText("|Cffffd000" .. L["itemUseShowInterruptsTooltip"]);
	raidLogFrame.scrollChild.checkbox3:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox3:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -100, -114);
	raidLogFrame.scrollChild.checkbox3:SetChecked(NRC.config.itemUseShowInterrupts);
	raidLogFrame.scrollChild.checkbox3:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox3:GetChecked();
		NRC.config.itemUseShowInterrupts = value;
		NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
	end)
	raidLogFrame.scrollChild.checkbox3:Show();
	
	raidLogFrame.scrollChild.checkbox4.Text:SetText("|cFF9CD6DE" .. L["Racials"]);
	raidLogFrame.scrollChild.checkbox4.tooltip2.fs:SetText("|Cffffd000" .. L["itemUseShowRacialsTooltip"]);
	raidLogFrame.scrollChild.checkbox4:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox4:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -100, -131);
	raidLogFrame.scrollChild.checkbox4:SetChecked(NRC.config.itemUseShowRacials);
	raidLogFrame.scrollChild.checkbox4:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox4:GetChecked();
		NRC.config.itemUseShowRacials = value;
		NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
	end)
	raidLogFrame.scrollChild.checkbox4:Show();
	
	--[[raidLogFrame.scrollChild.checkbox5.Text:SetText("|cFF9CD6DE" .. L["Food"]);
	raidLogFrame.scrollChild.checkbox5.tooltip2.fs:SetText("|Cffffd000" .. L["itemUseShowFoodTooltip"]);
	raidLogFrame.scrollChild.checkbox5:ClearAllPoints();
	raidLogFrame.scrollChild.checkbox5:SetPoint("TOPRIGHT", raidLogFrame.scrollChild, -100, -141);
	raidLogFrame.scrollChild.checkbox5:SetChecked(NRC.config.itemUseShowFood);
	raidLogFrame.scrollChild.checkbox5:SetScript("OnClick", function()
		local value = raidLogFrame.scrollChild.checkbox5:GetChecked();
		NRC.config.itemUseShowFood = value;
		NRC:loadRaidLogConsumes(logID, encounterID, encounterName, attemptID);
	end)
	raidLogFrame.scrollChild.checkbox5:Show();]]
	--local text2 = "";
	local text3 = "";
	local rText = "|cFF9CD6DE";
	--local text = "|cFFFFFF00" .. L["Total"] .. " " .. L["Raid"] .. " " .. L["Consumes"] .. "|r";
	local text = "|cFFFFFF00" .. L["All Bosses and Trash"] .. "|r";
	if (encounterName) then
		text = "|cFFFFFF00" .. L["Item Usage"] .. " for " .. encounterName .. "|r";
		if (encounterData) then
			local startTime = encounterData.startTime;
			local startGetTime = encounterData.startGetTime;
			local endGetTime = encounterData.endGetTime;
			local success = encounterData.success;
			local duration = "";
			local time = "|cFF9CD6DE" .. NRC:getTimeFormat(startTime, nil, true);
			--local success = " |cFFFF7F7F" .. L["Wipe"] .. "|r";
			local success = " |cFFff3333" .. L["Wipe"] .. "|r";
			if (encounterData.success == 1) then
				success = " |cFF00C800" .. L["Kill"] .. "|r";
			end
			if (startGetTime and endGetTime) then
				duration = " |cFFA1A1A1(" .. NRC:getTimeString(math.floor(endGetTime - startGetTime), true, "short") .. ")|r";
			end
			raidLogFrame.scrollChild.fs4:ClearAllPoints();
			raidLogFrame.scrollChild.fs4:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 10, -30);
			raidLogFrame.scrollChild.fs4:SetJustifyH("LEFT");
			raidLogFrame.scrollChild.fs4:SetText(time .. duration .. success);
			raidLogFrame.scrollChild.fs4:Show();
		end
	end
	local consumeData = getConsumeData(logID, encounterID, attemptID, guid);
	--Ignore recorded data before this version, it wasn't recording properly.
	--Remove this in a month or so.
	if (NRC.db.global.versions[1.12] and tonumber(NRC.db.global.versions[1.12])
			and ((data.enteredTime and data.enteredTime > 0 and data.enteredTime < NRC.db.global.versions[1.12])
			or (data.leftTime and data.leftTime > 0 and data.leftTime < NRC.db.global.versions[1.12]))) then
		raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -44);
		raidLogFrame.scrollChild.fs2:SetText("Recording started for raids after this version 1.12 was installed.");
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	end
	if (not consumeData or not next(consumeData)) then
		raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -44);
		raidLogFrame.scrollChild.fs2:SetText("None recorded.");
		raidLogFrame.scrollChild.fs:SetText(text);
		return;
	end
	local includeRacials = NRC.config.includeRacials;
	local viewType = NRC.config.consumesViewType;
	if (viewType == 2) then
		--List view type.
		local d = {};
		for player, consumes in pairs(consumeData) do
			for k, v in ipairs(consumes) do
				local t = {
					name = player,
					class = consumes.class,
					icon = v.icon,
					itemIcon = v.itemIcon,
					timestamp = v.timestamp,
					getTime = v.getTime,
					encounterID = v.encounterID,
					itemID = v.itemID;
					spellID = v.spellID;
					quality = v.quality,
				};
				tinsert(d, t);
				if (#d > 5000) then
					break;
				end
			end
		end
		local sortType;
		--We need to make sure getTime exists for encounter specific consumes, old data does't have it.
		if (attemptID and d[1] and d[1].getTime) then
			NRC:sortByKey(d, "getTime");
			sortType = "getTime";
		else
			NRC:sortByKey(d, "timestamp");
			sortType = "timestamp";
		end
		for k, v in ipairs(d) do
			local encounterText = "";
			if (v.encounterID) then
				encounterText = strsub(getEncounterNameFromID(v.encounterID, logID), 1, 22);
			else
				encounterText = L["Trash"];
			end
			local _, _, _, classColorHex = GetClassColor(v.class);
			--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and v.class == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			local item, icon;
			if (v.itemID) then
				local itemName, itemLink, itemQuality = GetItemInfo(v.itemID);
				if (itemLink and itemLink ~= "") then
					item = itemLink;
				elseif (itemName) then
					if (itemQuality) then
						item = "|c" .. select(4, GetItemQualityColor(itemQuality)) .. "[" .. itemName .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				else
					local itemData = NRC.trackedItems[v.spellID];
					if (itemData) then
						item = "|c" .. select(4, GetItemQualityColor(itemData.quality)) .. "[" .. itemData.name .. "]|r";
					else
						item = "|cFFFFFFFF[Unknown Item]|r";
					end
				end
				--item = item .. " (" .. v.itemID .. ")";
			elseif (v.spellID) then
				local spellLink = GetSpellLink(v.spellID);
				if (spellLink) then
					item = spellLink;
				else
					local spellName = GetSpellInfo(v.spellID);
					local itemData = NRC.trackedItems[v.spellID];
					if (spellName) then
						item = "|cFF71D5FF[" .. spellName .. "]|r";
					elseif(itemData) then
						item = "|cFF71D5FF[" .. itemData.name .. "]|r";
					else
						item = "|cFF71D5FF[Unknown Spell]|r";
					end
				end
				--item = item .. " (" .. v.spellID .. ")";
			else
				item = "|cFFFFFFFF[Unknown Tracked Item]|r";
			end
			if (v.icon) then
				if (v.itemIcon) then
					icon = "|T" .. v.itemIcon .. ":12:12|t";
				else
					icon = "|T" .. v.icon .. ":12:12|t";
				end
			else
				icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:12:12|t";
			end
			local itemText = icon .. " |c" .. classColorHex .. v.name .. "|r - " .. item;
			--local itemText = " |c" .. classColorHex .. v.name .. "|r - " .. item;
			local timeString;
			if (sortType == "getTime") then
				if (v.getTime and encounterData.startGetTime) then
					timeString = NRC:getShortTime(math.floor(v.getTime - encounterData.startGetTime));
				else
					timeString = "";
				end
			else
				timeString = NRC:getTimeFormat(v.timestamp, nil, true, true, true);
			end
			text3 = text3 .. "\n|cFFA1A1A1" .. timeString .. "  " .. itemText .. "|r";
			rText = rText .. "\n" .. encounterText;
		end
		if (strlen(text3)> 100000) then
			raidLogFrame.scrollChild.fs2:SetText("|cFFA1A1A1Timeline view of entire raid might be laggy to scroll.\n"
					.. "You may want to view each encounter seperately instead.");
		end
	else
		local countData = {};
		for char, charData in pairs(consumeData) do
			local t = {};
			t.name = char;
			t.class = charData.class;
			t.usageData = {};
			if (charData[1]) then
				for usageID, item in pairs(charData) do
					--If no spellID then it's the class data.
					local spellID = item.spellID;
					local itemID = item.itemID;
					local itemIcon = item.itemIcon;
					if (spellID) then
						--Merge 0/2 and 1/2 healthstones int 2/2.
						--Save a bit of space on the display.
						if (spellID == 27235 or spellID == 27236) then
							spellID = 27237;
							itemID = 22105;
						end
						if (not t.usageData[spellID]) then
							t.usageData[spellID] = {
								count = 0;
							};
						end
						local data = t.usageData[spellID];
						data.count = data.count + 1;
						data.icon = item.icon;
						data.itemID = itemID;
						data.itemIcon = itemIcon;
					end
				end
			end
			if (next(t.usageData)) then
				tinsert(countData, t);
			end
		end
		table.sort(countData, function(a, b)
			return a.class < b.class
				or a.class == b.class and strcmputf8i(a.name, b.name) < 0;
		end)
		local startOffset, padding, offset = 65, 22, 0;
		local count = 0;
		local text = "";
		for id, charData in NRC:pairsByKeys(countData) do
			text = "";
			count = count + 1;
			local _, _, _, classColorHex = GetClassColor(charData.class);
				--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
			if (not classColorHex and charData.class == "SHAMAN") then
				classColorHex = "ff0070dd";
			elseif (not classColorHex) then
				classColorHex = "ffffffff";
			end
			text = text .. "|c" .. classColorHex .. charData.name .. ":|r";
			if (charData.usageData and next(charData.usageData)) then
				local consumesString = "  ";
				for k, v in NRC:pairsByKeys(charData.usageData) do
					local icon;
					if (v.icon) then
						if (v.itemID) then
							if (v.itemIcon) then
								icon = "|HNRCItem:" .. v.itemID .. "|h|T" .. v.itemIcon .. ":14:14|t|h";
							else
								icon = "|HNRCItem:" .. v.itemID .. "|h|T" .. v.icon .. ":14:14|t|h";
							end
						else
							icon = "|HNRCSpell:" .. k .. "|h|T" .. v.icon .. ":14:14|t|h";
						end
					else
						icon = "|TInterface\\Icons\\INV_MISC_QUESTIONMARK:14:14|t";
					end
					consumesString = consumesString .. "" .. icon .. "|cFF9CD6DEx" .. v.count .. "|r ";
				end
				text = text .. consumesString;
			else
				text = text .. "  |cFF9CD6DENone recorded.|r";
			end
			local frame = raidLogFrame.getSimpleLineFrame(count);
			if (frame) then
				frame:Show();
				frame:ClearAllPoints();
				if (count == 1) then
					offset = startOffset;
				else
					offset = offset + padding;
				end
				frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 3, -offset);
				frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -170, 0);
				--frame:SetNormalTexture(frame.normalTex);
				--frame:SetHighlightTexture(frame.highlightTex);
				--frame.leftTexture:SetSize(50, 41);
				--frame.leftTexture:SetScale(0.8);
				--frame.leftTexture:Show();
				--frame.fs:SetText("|cFFFFFFFF" .. count .. ")|r");
				frame.fs:SetText("");
				frame.fs2:SetPoint("LEFT", 20, 0);
				frame.fs2:SetText(text);
				frame:SetHeight(22);
				frame:SetScript("OnClick", function(self, arg)
					--raidLogFrame.backButton:Enable();	
				end)
				frame.updateTooltip(nil);
			end
		end
		if (text == "") then
			raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -44);
			raidLogFrame.scrollChild.fs2:SetText("None recorded.");
		--[[else
			raidLogFrame.scrollChild.fs2:ClearAllPoints();
			raidLogFrame.scrollChild.fs2:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 30, -39);
			raidLogFrame.scrollChild.fs2:SetJustifyH("LEFT");
			raidLogFrame.scrollChild.fs2:SetFont(NRC.regionFont, 14);
			--raidLogFrame.scrollChild.fs2:SetText(text);
			raidLogFrame.scrollChild.fs2:SetSpacing(1);]]
		end
	end
	raidLogFrame.scrollChild.fs:SetText(text);
	--raidLogFrame.scrollChild.fs2:SetText(text2);
	NRC:splitAndAnchorFontstring(text3, 50, raidLogFrame.scrollChild, 148, -70);
	raidLogFrame.scrollChild.rfs:SetText(rText);
	setBottomText(data, logID);
end

function NRC:updateTradeFrame(allTrades, open, noFrameUpdate)
	if (open) then
		NRC:loadRaidLogFrames();
		raidLogFrame:Show();
	end
	if (raidLogFrame and raidLogFrame:IsShown()) then
		if (allTrades or raidLogFrame.frameType == "allTrades") then
			NRC:loadTrades(nil, nil, open, noFrameUpdate);
		elseif (raidLogFrame.frameType == "raidTrades") then
			if (raidLogFrame.logID and raidLogFrame.raidID) then
				NRC:loadTrades(raidLogFrame.logID, raidLogFrame.raidID, open, noFrameUpdate)
			end
		end
	end
end

local function loadTradeFilter(logID, raidID)
	if (not tradeFilterFrame) then
		tradeFilterFrame = NRC:createTextInputOnly("NRCRaidLogTradeFilterFrame", 150, 70, raidLogFrame);
		tradeFilterFrame.resetButton:SetPoint("LEFT", tradeFilterFrame, "RIGHT", 15, -1);
		tradeFilterFrame.resetButton:SetSize(55, 18);
		tradeFilterFrame.resetButton:SetText(L["Reset"] .. " " .. L["Filter"]);
		tradeFilterFrame.resetButton:Show();
		--tradeFilterFrame.fs:SetText("|cFFFFFF00" .. string.format(L["logEntryFrameTitle"], "|cFFFF6900" .. logID .. "|r"))
		tradeFilterFrame.logID = logID;
		tradeFilterFrame.raidID = raidID;
		tradeFilterFrame:ClearAllPoints();
		tradeFilterFrame.tooltip:SetPoint("BOTTOM", tradeFilterFrame, "TOP", 20, -20);
		--local scale, x, y = tradeFilterFrame:GetEffectiveScale(), GetCursorPosition();
		--tradeFilterFrame:SetPoint("RIGHT", UIParent, "BOTTOMLEFT", (x / scale) - 2, y / scale);
		--tradeFilterFrame:SetPoint("TOPLEFT", 75, -15);
		tradeFilterFrame.OnEnterPressed = function()
			local text = tradeFilterFrame:GetText();
			if (text ~= "") then
				tradeFilterString = string.lower(text);
				--tradeFilterFrame:SetText("");
				tradeFilterFrame:ClearFocus();
				tradeFilterFrame.fs:Hide();
				NRC:updateTradeFrame(nil, nil, true);
			else
				tradeFilterString = nil;
				tradeFilterFrame:ClearFocus();
				tradeFilterFrame.fs:Show();
				NRC:updateTradeFrame(nil, nil, true);
			end
		end
		tradeFilterFrame:SetScript("OnEnterPressed", tradeFilterFrame.OnEnterPressed);
		tradeFilterFrame.OnTextChanged = function()
			local text = tradeFilterFrame:GetText();
			if (text ~= "") then
				tradeFilterString = string.lower(text);
				tradeFilterFrame.fs:Hide();
				NRC:updateTradeFrame(nil, nil, true);
			else
				tradeFilterString = nil;
				tradeFilterFrame.fs:Show();
				NRC:updateTradeFrame(nil, nil, true);
			end
		end
		tradeFilterFrame:SetScript("OnTextChanged", tradeFilterFrame.OnTextChanged);
		tradeFilterFrame.resetButton:SetScript("OnClick", function(self, arg)
			tradeFilterString = nil;
			tradeFilterFrame:SetText("");
			tradeFilterFrame:ClearFocus();
			tradeFilterFrame.fs:Show();
			NRC:updateTradeFrame(nil, nil, true);
		end)
		--[[if (not LOCALE_koKR and not LOCALE_zhCN and not LOCALE_zhTW and not LOCALE_ruRU) then
			tradeFilterFrame.fs:SetText("F");
			tradeFilterFrame.fs2:SetText("i");
			tradeFilterFrame.fs3:SetText("l");
			tradeFilterFrame.fs4:SetText("t");
			tradeFilterFrame.fs5:SetText("e");
			tradeFilterFrame.fs6:SetText("r");
			tradeFilterFrame.fs:Show();
			tradeFilterFrame.fs2:Show();
			tradeFilterFrame.fs3:Show();
			tradeFilterFrame.fs4:Show();
			tradeFilterFrame.fs5:Show();
			tradeFilterFrame.fs6:Show();
		else]]
			tradeFilterFrame.fs:SetText(L["Filter"]);
			tradeFilterFrame.fs:Show();
		--end
		--tradeFilterFrame:Show();
		tradeFilterFrame.tooltipText = L["tradeFilterTooltip"];
	end
	if not (tradeFilterFrame:IsShown()) then
		tradeFilterFrame:Show();
	end
	if (logID and raidID) then
		tradeFilterFrame:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 5, 22);
		tradeFilterFrame.resetButton:Hide();
	else
		tradeFilterFrame:SetPoint("TOPLEFT", raidLogFrame, "TOPLEFT", 75, -13);
		tradeFilterFrame.resetButton:Show();
	end
	--tradeFilterFrame:SetFocus();
end

function NRC:loadTrades(logID, raidID, open, filterUpdate)
	if (open and raidLogFrame) then
		raidLogFrame:Show();
	end
	if (not filterUpdate) then
		clearRaidLogFrame();
		updateFrames();
	else
		raidLogFrame.hideAllSimpleLineFrames();
	end
	setInstanceTexture(logID);
	local text, data;
	local startOffset, padding, offset = 25, 18, 0;
	if (logID and raidID) then
		raidLogFrame.frameType = "raidTrades";
		raidLogFrame.logID = logID;
		local instanceName = "Error (Unknown Log)";
		local instanceData = NRC.db.global.instances[logID];
		local instanceID;
		if (instanceData) then
			instanceName = instanceData.instanceName;
			instanceID = instanceData.instanceID;
		end
		text = "|cFF9CD6DE" .. string.format(L["tradesForSingleRaid"], instanceName, logID) .. "|r";
		--text = text .. " |cFF9CD6DE(" .. NRC:getTimeString(instanceData.startTime, true) .. " " .. L["ago"] .. ")|r";
		startOffset = 50;
		loadTradeFilter(logID, raidID);
		--Remove prefix from certain instance names.
		local instanceName = string.gsub(instanceData.instanceName, ".+: ", "");
		instanceName = NRC:addDiffcultyText(instanceName, instanceData.difficultyName, instanceData.difficultyID);
		raidLogFrame.titleText2.fs:SetText(instanceName);
		raidLogFrame.titleText2:ClearAllPoints();
		raidLogFrame.titleText2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -92, -41);
		--Adjust frame width the instance name text sits on so it centers.
		raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
		raidLogFrame.scrollChild.exportButton:SetParent(raidLogFrame.scrollChild);
		raidLogFrame.scrollChild.exportButton:ClearAllPoints();
		raidLogFrame.scrollChild.exportButton:SetPoint("TOPRIGHT", -40, -5);
		raidLogFrame.scrollChild.exportButton:SetSize(90, 22);
		raidLogFrame.scrollChild.exportButton:SetText(L["Export"]);
		raidLogFrame.scrollChild.exportButton:SetScript("OnClick", function(self, arg)
			NRC:loadTradesExportFrame(logID, raidID);
		end)
		raidLogFrame.scrollChild.exportButton:Show();
	else
		raidLogFrame.titleText2.fs:SetText(L["All Trades"]);
		raidLogFrame.titleText2:ClearAllPoints();
		raidLogFrame.titleText2:SetPoint("TOP", raidLogFrame, "TOP", 0, -41);
		raidLogFrame.titleText2:Show();
		raidLogFrame.frameType = "allTrades";
		raidLogFrame.button2:Show();
		raidLogFrame.button2:SetSize(50, 18);
		raidLogFrame.button2:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -35, -24);
		raidLogFrame.button2:SetText(L["Config"]);
		raidLogFrame.button2:SetScript("OnClick", function(self, arg)
			NRC:openConfig();
		end)
		raidLogFrame.button3:Show();
		raidLogFrame.button3:SetSize(50, 18);
		raidLogFrame.button3:SetPoint("TOPRIGHT", raidLogFrame, "TOPRIGHT", -115, -24);
		raidLogFrame.button3:SetText(L["Lockouts"]);
		raidLogFrame.button3:SetScript("OnClick", function(self, arg)
			NRC:openLockoutsFrame();
		end)
		loadTradeFilter();
		raidLogFrame.scrollChild.exportButton:SetParent(raidLogFrame);
		raidLogFrame.scrollChild.exportButton:ClearAllPoints();
		--raidLogFrame.scrollChild.exportButton:SetPoint("TOP", raidLogFrame.titleText2, "TOP", 160, -32);
		raidLogFrame.scrollChild.exportButton:SetPoint("LEFT", raidLogFrame.titleText2.fs, "RIGHT", 20, 0);
		--raidLogFrame.scrollChild.exportButton:SetPoint("TOPRIGHT", -200, -1);
		raidLogFrame.scrollChild.exportButton:SetSize(90, 22);
		raidLogFrame.scrollChild.exportButton:SetText(L["Export"]);
		raidLogFrame.scrollChild.exportButton:SetScript("OnClick", function(self, arg)
			NRC:loadTradesExportFrame(logID);
		end)
		raidLogFrame.scrollChild.exportButton:Show();
	end
	local data = getTradeData(logID, raidID);
	raidLogFrame.raidID = raidID;
	updateFrames();
	raidLogFrame.scrollChild.fs:ClearAllPoints();
	raidLogFrame.scrollChild.fs:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -10);
	raidLogFrame.scrollChild.fs:SetJustifyH("CENTER");
	raidLogFrame.scrollChild.fs2:ClearAllPoints();
	raidLogFrame.scrollChild.fs2:SetPoint("TOP", raidLogFrame.scrollChild, "TOP", 0, -34);
	raidLogFrame.scrollChild.fs3:ClearAllPoints();
	raidLogFrame.scrollChild.fs3:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 318, -70);
	raidLogFrame.scrollChild.fs:Show();
	raidLogFrame.scrollChild.fs2:Show();
	raidLogFrame.scrollChild.fs3:Show();
	local count = 0;
	local found;
	local framesUsed = {};
	for k, v in ipairs(data) do
		local frame = raidLogFrame.getSimpleLineFrame(k, v);
		if (frame) then
			local goldFound, itemsFound, enchantsFound;
			count = count + 1;
			if (count > NRC.db.global.maxTradesKept) then
				if (frame) then
					frame:Hide();
				end
			else
				framesUsed[count] = true;
				frame:Show();
				frame:ClearAllPoints();
				if (k == 1) then
					offset = startOffset;
				else
					offset = offset + padding;
				end
				frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 3, -offset);
				frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -30, 0);
				--frame:SetNormalTexture(frame.normalTex);
				--frame:SetHighlightTexture(frame.highlightTex);
				frame.leftTexture:SetSize(50, 41);
				frame.leftTexture:SetScale(0.8);
				frame.leftTexture:Show();
				
				local msg = "";
				local tooltip = "|cFF9CD6DE";
				local _, _, _, classColorHex = GetClassColor(v.tradeWhoClass);
				--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
				if (not classColorHex and v.tradeWhoClass == "SHAMAN") then
					classColorHex = "ff0070dd";
				elseif (not classColorHex) then
					classColorHex = "ffffffff";
				end
				local _, _, _, classColorHexMe = GetClassColor(v.meClass);
				if (not classColorHexMe and v.meClass == "SHAMAN") then
					classColorHexMe = "ff0070dd";
				elseif (not classColorHexMe) then
					classColorHexMe = "ffffffff";
				end
				local time = NRC:getTimeFormat(v.time, true, true);
				--local timeAgo = GetServerTime() - v.time;
				msg = msg .. "[|cFFDEDE42" .. time .. "|r]";
				tooltip = tooltip .. "|c" .. classColorHexMe .. v.me .. "|r " .. L["traded with"] .. " |c" .. classColorHex .. v.tradeWho .. "|r";
				tooltip = tooltip .. "\n[|cFFDEDE42" .. time .. "|r] " .. L["in"] .. " " .. v.where .. "";
				if (v.playerMoney and v.playerMoney > 0) then
					msg = msg .. " |cFFFFAE42" .. L["Gave"] .. "|r "
							.. NRC:getCoinString(v.playerMoney, 10) .. "|r |cFF9CD6DE" .. L["to"] .. "|r |c"
							.. classColorHex .. v.tradeWho .. "|r";
					tooltip = tooltip .. "\n" .. L["Gave"] .. " " .. NRC:getCoinString(v.playerMoney, 10) .. "|r";
					goldFound = true;
					found = true;
				end
				if (v.targetMoney and v.targetMoney > 0) then
					msg = msg .. " |cFF00C800" .. L["Received"] .. "|r "
							.. NRC:getCoinString(v.targetMoney, 10) .. "|r |cFF9CD6DE" .. L["from"] .. "|r |c"
							.. classColorHex .. v.tradeWho .. "|r";
					tooltip = tooltip .. "\n" .. L["Received"] .. " " .. NRC:getCoinString(v.targetMoney, 10) .. "|r";
					goldFound = true;
					found = true;
				end
				
				if (v.playerItems and next(v.playerItems)) then
					if (not goldFound) then
						msg = msg .. " |cFFFFAE42" .. L["Gave"] .. " " .. L["Items"] .. "|r |c" .. classColorHex .. v.tradeWho .. "|r";
					else
						msg = msg .. " |cFFFFAE42" .. L["Gave"] .. " " .. L["Items"] .. "|r";
					end
					local itemsTooltip = "";
					for _, itemData in pairs(v.playerItems) do
						local countString = "";
						if (itemData.count and itemData.count > 1) then
							countString = "x|cFFFFFFFF" .. itemData.count .. "|r";
						end
						if (itemData.itemLink) then
							msg = msg .. " " .. itemData.itemLink .. countString;
							itemsTooltip = itemsTooltip .. "\n" .. itemData.itemLink .. countString;
						elseif (itemData.name) then
							if (itemData.quality and ITEM_QUALITY_COLORS[itemData.quality]) then
								msg = msg .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r" .. countString;
								itemsTooltip = itemsTooltip .. "\n" .. ITEM_QUALITY_COLORS[itemData.quality].hex .. "[" .. itemData.name .. "]|r" .. countString;
							else
								msg = msg .. " |cFFFFFFFF[" .. itemData.name .. "]|r" .. countString;
								itemsTooltip = itemsTooltip .. "\n|cFFFFFFFF[" .. itemData.name .. "]|r" .. countString;
							end
						else
							msg = msg .. " |CFFFFFFFF[Unknown Item]|r" .. countString;
							itemsTooltip = itemsTooltip .. "\n|cFFFFFFFF[Unknown Item]|r" .. countString;
						end
					end
					if (itemsTooltip) then
						tooltip = tooltip .. "\n\n|cFFFFAE42" .. L["Gave"] .. " " .. L["Items"] .. ":|r";
						tooltip = tooltip .. itemsTooltip;
					end
					itemsFound = true;
					found = true;
				end
				if (v.playerItemsEnchant and next(v.playerItemsEnchant)) then
					if (not goldFound and not itemsFound) then
						msg = msg .. " |cFFFFD200" .. L["Received"] .. " " .. L["Enchant"] .. "|r |cFF9CD6DE"
								.. L["from"] .. "|r |c" .. classColorHex .. v.tradeWho .. "|r";
					else
						msg = msg .. " |cFFFFD200" .. L["Received"] .. " " .. L["Enchant"] .. "|r";
					end
					local itemsTooltip = "";
					for _, itemData in pairs(v.playerItemsEnchant) do
						local enchantString = "";
						if (itemData.enchant and type(itemData.enchant) ~= "boolean") then
							enchantString = " |cFFFFD200[" .. itemData.enchant .. "]|r";
						end
						if (itemData.itemLink) then
							msg = msg .. enchantString  .. " " .. L["on"] .. " " .. itemData.itemLink;
							itemsTooltip = itemsTooltip .. "\n" .. enchantString  .. " " .. L["on"] .. " " .. itemData.itemLink;
						elseif (itemData.name) then
							if (itemData.quality and ITEM_QUALITY_COLORS[itemData.quality]) then
								msg = msg .. enchantString .. " " .. L["on"] .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r";
								itemsTooltip = itemsTooltip .. "\n" .. enchantString .. " " .. L["on"] .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r";
							else
								msg = msg .. enchantString .. " " .. L["on"] .. " |cFFFFFFFF" .. itemData.name .. "|r";
								itemsTooltip = itemsTooltip .. "\n" .. enchantString .. " " .. L["on"] .. " |cFFFFFFFF[" .. itemData.name .. "]|r";
							end
						else
							msg = msg .. enchantString .. " " .. L["on"] .. " |CFFFFFFFF[Unknown Item]|r";
							itemsTooltip = itemsTooltip .. "\n" .. enchantString .. " " .. L["on"] .. " |CFFFFFFFF[Unknown Item]|r";
						end
					end
					if (itemsTooltip) then
						tooltip = tooltip .. "\n\n|cFFFFD200" .. L["Received"] .. " " .. L["Enchant"] .. ":|r";
						tooltip = tooltip .. itemsTooltip;
					end
					enchantsFound = true;
					found = true;
				end
				
				itemsFound, enchantsFound = false, false, false;
				if (v.targetItems and next(v.targetItems)) then
					if (not goldFound) then
						msg = msg .. " |cFF00C800" .. L["Received"] .. " " .. L["Items"] .. "|r |c" .. classColorHex .. v.tradeWho .. "|r";
					else
						msg = msg .. " |cFF00C800" .. L["Received"] .. " " .. L["Items"] .. "|r";
					end
					local itemsTooltip = "";
					for _, itemData in pairs(v.targetItems) do
						local countString = "";
						if (itemData.count and itemData.count > 1) then
							countString = "x|cFFFFFFFF" .. itemData.count .. "|r";
						end
						if (itemData.itemLink) then
							msg = msg .. " " .. itemData.itemLink .. countString;
							itemsTooltip = itemsTooltip .. "\n" .. itemData.itemLink .. countString;
						elseif (itemData.name) then
							if (itemData.quality and ITEM_QUALITY_COLORS[itemData.quality]) then
								msg = msg .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r" .. countString;
								itemsTooltip = itemsTooltip .. "\n" .. ITEM_QUALITY_COLORS[itemData.quality].hex .. "[" .. itemData.name .. "]|r" .. countString;
							else
								msg = msg .. " |cFFFFFFFF[" .. itemData.name .. "]|r" .. countString;
								itemsTooltip = itemsTooltip .. "\n|cFFFFFFFF[" .. itemData.name .. "]|r" .. countString;
							end
						else
							msg = msg .. " |CFFFFFFFF[Unknown Item]|r" .. countString;
							itemsTooltip = itemsTooltip .. "\n|cFFFFFFFF[Unknown Item]|r" .. countString;
						end
					end
					if (itemsTooltip) then
						tooltip = tooltip .. "\n\n|cFF00C800" .. L["Received"] .. " " .. L["Items"] .. ":|r";
						tooltip = tooltip .. itemsTooltip;
					end
					itemsFound = true;
					found = true;
				end
				if (v.targetItemsEnchant and next(v.targetItemsEnchant)) then
					if (not goldFound and not itemsFound) then
						msg = msg .. " |cFFFFD200" .. L["Enchanted"] .. "|r |cFF9CD6DE"
								.. L["for"] .. "|r |c" .. classColorHex .. v.tradeWho .. "|r";
					else
						msg = msg .. " |cFFFFD200" .. L["Enchanted"] .. "|r";
					end
					local itemsTooltip = "";
					for _, itemData in pairs(v.targetItemsEnchant) do
						local enchantString = "";
						if (itemData.enchant and type(itemData.enchant) ~= "boolean") then
							enchantString = " " .. L["with"] .. " |cFFFFD200[" .. itemData.enchant .. "]|r";
						end
						if (itemData.itemLink) then
							msg = msg .. " " .. itemData.itemLink  .. enchantString;
							itemsTooltip = itemsTooltip .. "\n" .. itemData.itemLink  .. enchantString;
						elseif (itemData.name) then
							if (itemData.quality and ITEM_QUALITY_COLORS[itemData.quality]) then
								msg = msg .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r" .. enchantString;
								itemsTooltip = itemsTooltip .. "\n" .. ITEM_QUALITY_COLORS[itemData.quality].hex .. " [" .. itemData.name .. "]|r" .. enchantString;
							else
								msg = msg .. " |cFFFFFFFF[" .. itemData.name .. "]|r" .. enchantString;
								itemsTooltip = itemsTooltip .. "\n|cFFFFFFFF[" .. itemData.name .. "]|r" .. enchantString;
							end
						else
							msg = msg .. " |CFFFFFFFF[Unknown Item]|r" .. enchantString;
							itemsTooltip = itemsTooltip .. "\n|CFFFFFFFF[Unknown Item]|r" .. enchantString;
						end
					end
					if (itemsTooltip) then
						tooltip = tooltip .. "\n\n|cFFFFD200" .. L["Gave"] .. " " .. L["Enchant"] .. ":|r";
						tooltip = tooltip .. itemsTooltip;
					end
					enchantsFound = true;
					found = true;
				end
				if (count < 10) then
					--Offset the text for single digit numbers so the date comlumn lines up.
					frame.fs:SetPoint("LEFT", 12, 0);
				else
					frame.fs:SetPoint("LEFT", 5, 0);
				end
				frame.fs:SetText("|cFFFFFFFF" .. count .. ")|r");
				frame.fs2:SetPoint("LEFT", 28, 0);
				frame.fs2:SetText(msg);
				--[[if (v.instanceID) then
					local name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID = getInstanceTextures(v.instanceID);
					frame.leftTexture:SetTexture(loreImage);
				else
					frame.leftTexture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
				end
				frame.leftTexture:SetTexCoord(0, 0.76171875, 0.06, 0.60625);]]
				frame:SetHeight(18);
				frame:SetScript("OnClick", function(self, arg)
					--raidLogFrame.backButton:Enable();
					
				end)
				frame.updateTooltip(tooltip);
				frame.id = k;
			end
		end
	end
	if (found) then
		raidLogFrame.scrollChild.fs:Hide();
		raidLogFrame.scrollChild.fs2:Hide();
	else
		raidLogFrame.scrollChild.fs2:ClearAllPoints();
		raidLogFrame.scrollChild.fs2:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 50, -30);
		if (tradeFilterString) then
			raidLogFrame.scrollChild.fs2:SetText("|cFF9CD6DE" .. L["No trades matching current filter"] .. ".");
		else
			raidLogFrame.scrollChild.fs2:SetText("|cFF9CD6DE" .. L["No trades recorded yet"] .. ".");
		end
		raidLogFrame.scrollChild.fs2:Show();
	end
	if (logID) then
		raidLogFrame.scrollChild.fs:Show();
		setBottomText(NRC.db.global.instances[logID], logID);
	end
	if (text) then
		raidLogFrame.scrollChild.fs:SetText(text);
	end
	--for i = 1, NRC.db.global.maxTradesKept do
	--	if (raidLogFrame.simpleLineFrames[i] and not framesUsed[i]) then
			--raidLogFrame.lineFrames[i]:Hide();
	--	end
	--end
end

function NRC:loadEncounterList(logID, encounterID)

end

local modelFrame;
--[[function loadTestModelFrame()
	if (not modelFrame) then
		--local frame = CreateFrame("PlayerModel", "TestModelFrame", UIParent, "BackdropTemplate,ModelWithControlsTemplate");
		local frame = CreateFrame("ModelScene", name, UIParent, "BackdropTemplate,ModelWithControlsTemplate,ModelSceneMixinTemplate");
		frame.creature = frame:CreateActor("creature");
		--Move the control panel with zoom/rotate etc.
		--_G["TestModelFrameControlFrame"]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, 0);
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},]]
			--edgeFile = [[Interface/Buttons/WHITE8X8]], 
			--[[edgeSize = 1,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		--frame:SetToplevel(true);
		--frame:SetMovable(true);
		--frame:EnableMouse(true);
		--tinsert(UISpecialFrames, frame);
		frame:SetPoint("CENTER", UIParent, 0, 200);
		frame:SetSize(777, 473);
		frame:SetFrameStrata("MEDIUM");
		frame.closeButton = CreateFrame("Button", "$parentClose", frame, "UIPanelCloseButton");
		frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		frame.closeButton:SetWidth(20);
		frame.closeButton:SetHeight(20);
		frame.closeButton:SetFrameLevel(3);
		frame.closeButton:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
		frame.closeButton:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.fs = frame:CreateFontString("$parentFS", "ARTWORK");
		frame.fs:SetJustifyH("LEFT");
		frame.fs:SetFont("Fonts\\FRIZQT__.TTF", 13);
		frame.fs:SetPoint("TOPLEFT", 20, -30);
		--Model_SetDefaultRotation(frame, 0.61);
		modelFrame = frame;
	end
	--Data taken from retail EJ_GetCreatureInfo(), he files are in TBC client though.
	--Tall NPC.
	local id, name, description, displayInfo, iconImage, uiModelSceneID = "3782", "Maiden of Virtue", "", 16198, 1378997, 67;
	--Normal size NPC.
	--local id, name, description, displayInfo, iconImage, uiModelSceneID = "3781", "Moroes", "", 16540, 1378999, 9;
	if (displayInfo) then
		modelFrame.fs:SetText("|cFFFFFF00" .. name);
		--modelFrame:SetDisplayInfo(displayInfo);
		--modelFrame:SetModel(displayInfo);
		--modelFrame:SetFromModelSceneID(uiModelSceneID);
		modelFrame.creature:SetModelByCreatureDisplayID(displayInfo);
		--modelFrame.creature:SetScale(0.5);
		--modelFrame:SetCamera(0);
		--modelFrame:SetCameraDistance(10);
		--local creature = modelFrame:GetActorByTag("creature");
		--if creature then
			--raidLogFrame.modelFrame.creature:SetModelByCreatureDisplayID(displayInfo);
			--raidLogFrame.modelFrame:SetFromModelSceneID(uiModelSceneID, true);
		--end
		--raidLogFrame.modelFrame.creature:Show();
	else
		modelFrame.fs:SetText("Boss model not found.")
	end
	--modelFrame.rotation = 0;
	modelFrame.creature:SetYaw(3.7);
	--modelFrame:SetCamera(2);
	--modelFrame:SetCameraPosition(10, 10, 10);
	--local scale = UIParent:GetEffectiveScale();
	--local hypotenuse = ( ( GetScreenWidth() * scale ) ^ 2 + ( GetScreenHeight() * scale ) ^ 2 ) ^ 0.5;
	 
	--local coordRight = ( modelFrame:GetRight() - modelFrame:GetLeft() ) / hypotenuse; -- X
	--local coordTop = ( modelFrame:GetTop() - modelFrame:GetBottom() ) / hypotenuse; -- Y
	--modelFrame:SetPosition(coordRight, coordTop, 0)
	--modelFrame:SetPosition(0, 2, 0);
	--modelFrame:SetCamDistanceScale(1.1)
	--modelFrame:SetCameraPosition(-5, 0, -0.9)
	modelFrame:Show();
	--print(modelFrame:GetRight(), modelFrame:GetLeft())
	C_Timer.After(0.1, function()
		local xMin, yMin, zMin, xMax, yMax, zMax = modelFrame.creature:GetActiveBoundingBox();
		local halfHeight = (zMax - zMin) / 2;
		local radius = math.max(xMax - xMin, math.max(yMax - yMin, zMax - zMin));
		local fov = modelFrame:GetCameraFieldOfView();
		local dist = radius * 2;
		modelFrame:SetCameraPosition(-(dist + 1), 0, halfHeight)
	end)
end]]

--[[function loadTestModelFrame()
	if (not modelFrame) then
		local frame = CreateFrame("PlayerModel", "TestModelFrame", UIParent, "BackdropTemplate,ModelWithControlsTemplate,ModelSceneMixinTemplate");
		frame.scene = CreateFrame("ModelScene", "TestModelSceneFrame", frame, "BackdropTemplate,ModelSceneMixinTemplate");
		frame.scene:SetSize(390, 423);
		frame.scene:SetPoint("BOTTOMRIGHT", -3, 1);
		frame.scene.creature = frame.scene:CreateActor("creature");
		--Move the control panel with zoom/rotate etc.
		--_G["TestModelFrameControlFrame"]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, 0);
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},]]
			--edgeFile = [[Interface/Buttons/WHITE8X8]],
			--[[edgeSize = 1,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		--frame:SetToplevel(true);
		--frame:SetMovable(true);
		--frame:EnableMouse(true);
		--tinsert(UISpecialFrames, frame);
		frame:SetPoint("CENTER", UIParent, 0, 200);
		frame:SetSize(777, 473);
		frame:SetFrameStrata("MEDIUM");
		frame.closeButton = CreateFrame("Button", "$parentClose", frame, "UIPanelCloseButton");
		frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		frame.closeButton:SetWidth(20);
		frame.closeButton:SetHeight(20);
		frame.closeButton:SetFrameLevel(3);
		frame.closeButton:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
		frame.closeButton:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.fs = frame:CreateFontString("$parentFS", "ARTWORK");
		frame.fs:SetJustifyH("LEFT");
		frame.fs:SetFont("Fonts\\FRIZQT__.TTF", 13);
		frame.fs:SetPoint("TOPLEFT", 20, -30);
		modelFrame = frame;
	end
	--Data taken from retail EJ_GetCreatureInfo(), the files are in TBC client though.
	--Tall NPC.
	local id, name, description, displayInfo, iconImage, uiModelSceneID = "3782", "Maiden of Virtue", "", 16198, 1378997, 67;
	--local id, name, description, displayInfo, iconImage, uiModelSceneID = "3803", "The Lurker Below", "", 20216, 1385768, 88;
	--Normal size NPC.
	local id, name, description, displayInfo, iconImage, uiModelSceneID = "3781", "Moroes", "", 16540, 1378999, 9;
	if (displayInfo) then
		local modelSceneType, modelCameraIDs, modelActorsIDs = C_ModelInfo.GetModelSceneInfoByID(uiModelSceneID);
		modelFrame.fs:SetText("|cFFFFFF00" .. name);
		--modelFrame:SetDisplayInfo(displayInfo);
		--Model_ApplyUICamera(model, model.uiCameraID);
		--modelFrame:SetCreature(16457);
		--modelFrame:SetModel(displayInfo);
		--modelFrame:SetFromModelSceneID(uiModelSceneID);
		--modelFrame:TransitionToModelSceneID(uiModelSceneID);
		--modelFrame:SetCamera(71);
		--modelFrame:SetCameraDistance(10);
		local creature = modelFrame.scene:GetActorByTag("creature");
		--if (creature) then
			modelFrame.scene:SetFromModelSceneID(uiModelSceneID, true);
			modelFrame.scene.creature:SetModelByCreatureDisplayID(displayInfo);
			--modelFrame:RefreshCamera();
		--end
		--raidLogFrame.modelFrame.creature:Show();
	else
		modelFrame.fs:SetText("Boss model not found.")
	end
	--modelFrame:SetCamera(2);
	--modelFrame:SetCameraPosition(10, 10, 10);
	--local scale = UIParent:GetEffectiveScale();
	--local hypotenuse = ( ( GetScreenWidth() * scale ) ^ 2 + ( GetScreenHeight() * scale ) ^ 2 ) ^ 0.5;
	 
	--local coordRight = ( modelFrame:GetRight() - modelFrame:GetLeft() ) / hypotenuse; -- X
	--local coordTop = ( modelFrame:GetTop() - modelFrame:GetBottom() ) / hypotenuse; -- Y
	--modelFrame:SetPosition(coordRight, coordTop, 0)
	--modelFrame:SetPosition(-5, 0, -0.95)
	modelFrame:Show();
	--print(modelFrame:GetRight(), modelFrame:GetLeft())
end]]
--loadTestModelFrame()

--[[function loadTestModelFrame()
	if (not modelFrame) then
		local frame = CreateFrame("PlayerModel", "TestModelFrame", UIParent, "BackdropTemplate,ModelWithControlsTemplate");
		--local frame = CreateFrame("ModelScene", name, UIParent, "ModelSceneMixinTemplate");
		--frame.creature = frame:CreateActor("creature");
		--Move the control panel with zoom/rotate etc.
		_G["TestModelFrameControlFrame"]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, 0);
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 0, left = 0, bottom = 0, right = 0},]]
			--edgeFile = [[Interface/Buttons/WHITE8X8]], 
			--[[edgeSize = 1,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.2);
		--frame:SetToplevel(true);
		--frame:SetMovable(true);
		--frame:EnableMouse(true);
		--tinsert(UISpecialFrames, frame);
		frame:SetPoint("CENTER", UIParent, 0, 200);
		frame:SetSize(777, 473);
		frame:SetFrameStrata("MEDIUM");
		frame.closeButton = CreateFrame("Button", "$parentClose", frame, "UIPanelCloseButton");
		frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		frame.closeButton:SetWidth(20);
		frame.closeButton:SetHeight(20);
		frame.closeButton:SetFrameLevel(3);
		frame.closeButton:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		--Adjust the X texture so it fits the entire frame and remove the empty clickable space around the close button.
		frame.closeButton:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.closeButton:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.fs = frame:CreateFontString("$parentFS", "ARTWORK");
		frame.fs:SetJustifyH("LEFT");
		frame.fs:SetFont("Fonts\\FRIZQT__.TTF", 13);
		frame.fs:SetPoint("TOPLEFT", 20, -30);
		modelFrame = frame;
	end
	--Data taken from retail EJ_GetCreatureInfo(), he files are in TBC client though.
	--Tall NPC.
	local id, name, description, displayInfo, iconImage, uiModelSceneID = "3782", "Maiden of Virtue", "", 16198, 1378997, 67;
	--Normal size NPC.
	--local id, name, description, displayInfo, iconImage, uiModelSceneID = "3781", "Moroes", "", 16540, 1378999, 9;
	if (displayInfo) then
		modelFrame.fs:SetText("|cFFFFFF00" .. name);
		modelFrame:SetDisplayInfo(displayInfo);
		--modelFrame:SetModel(displayInfo);
		--modelFrame:SetFromModelSceneID(uiModelSceneID);
		--modelFrame:SetCamera(0);
		--modelFrame:SetCameraDistance(10);
		--local creature = modelFrame:GetActorByTag("creature");
		--if creature then
			--raidLogFrame.modelFrame.creature:SetModelByCreatureDisplayID(displayInfo);
			--raidLogFrame.modelFrame:SetFromModelSceneID(uiModelSceneID, true);
		--end
		--raidLogFrame.modelFrame.creature:Show();
	else
		modelFrame.fs:SetText("Boss model not found.")
	end
	--modelFrame:SetCamera(2);
	--modelFrame:SetCameraPosition(10, 10, 10);
	--local scale = UIParent:GetEffectiveScale();
	--local hypotenuse = ( ( GetScreenWidth() * scale ) ^ 2 + ( GetScreenHeight() * scale ) ^ 2 ) ^ 0.5;
	 
	--local coordRight = ( modelFrame:GetRight() - modelFrame:GetLeft() ) / hypotenuse; -- X
	--local coordTop = ( modelFrame:GetTop() - modelFrame:GetBottom() ) / hypotenuse; -- Y
	--modelFrame:SetPosition(coordRight, coordTop, 0)
	modelFrame:SetPosition(-5, 0, -0.9)
	modelFrame:Show();
	print(modelFrame:GetRight(), modelFrame:GetLeft())
end]]

--Credit to Dee for making this to center and scale models and Ketho for showing it to me.
local function centerCreatureModule(frame)
	local xMin, yMin, zMin, xMax, yMax, zMax = frame.creature:GetActiveBoundingBox();
	if (xMin) then
		local halfHeight = (zMax - zMin) / 2;
		local radius = math.max(xMax - xMin, math.max(yMax - yMin, zMax - zMin));
		local fov = frame:GetCameraFieldOfView();
		local dist = radius * 2;
		frame:SetCameraPosition(-(dist + 1), 0, halfHeight)
	else
		--GetActiveBoundingBox() can delay returning info so try a few times if the first fails.
		C_Timer.After(0.01, function()
			local xMin, yMin, zMin, xMax, yMax, zMax = frame.creature:GetActiveBoundingBox();
			if (xMin) then
				local halfHeight = (zMax - zMin) / 2;
				local radius = math.max(xMax - xMin, math.max(yMax - yMin, zMax - zMin));
				local fov = frame:GetCameraFieldOfView();
				local dist = radius * 2;
				frame:SetCameraPosition(-(dist + 1), 0, halfHeight)
			else
				C_Timer.After(0.04, function()
					local xMin, yMin, zMin, xMax, yMax, zMax = frame.creature:GetActiveBoundingBox();
					if (xMin) then
						local halfHeight = (zMax - zMin) / 2;
						local radius = math.max(xMax - xMin, math.max(yMax - yMin, zMax - zMin));
						local fov = frame:GetCameraFieldOfView();
						local dist = radius * 2;
						frame:SetCameraPosition(-(dist + 1), 0, halfHeight)
					else
						local xMin, yMin, zMin, xMax, yMax, zMax = frame.creature:GetActiveBoundingBox();
						if (xMin) then
							C_Timer.After(0.04, function()
								local xMin, yMin, zMin, xMax, yMax, zMax = frame.creature:GetActiveBoundingBox();
								local halfHeight = (zMax - zMin) / 2;
								local radius = math.max(xMax - xMin, math.max(yMax - yMin, zMax - zMin));
								local fov = frame:GetCameraFieldOfView();
								local dist = radius * 2;
								frame:SetCameraPosition(-(dist + 1), 0, halfHeight)
							end)
						end
					end
				end)
			end
		end)
	end
end

function NRC:loadRaidLogModelFrame(encounterID, encounterName)
	clearRaidLogFrame();
	raidLogFrame.frameType = "bossModel";
	updateFrames();
	local data = NRC.db.global.instances[raidLogFrame.logID];
	if (data) then
		setBottomText(data, raidLogFrame.logID);
	end
	raidLogFrame.modelFrame.creature:ClearModel();
	local id, name, description, displayInfo, iconImage, uiModelSceneID = getEncounterData(encounterID);
	if (displayInfo) then
		raidLogFrame.modelFrame.fs:SetText("|cFFFFFF00" .. name);
		raidLogFrame.modelFrame.creature:SetModelByCreatureDisplayID(displayInfo);
	else
		raidLogFrame.modelFrame.fs:SetPoint("TOPLEFT", raidLogFrame.modelFrame, "TOPLEFT", 20, -30);
		raidLogFrame.modelFrame.fs:Show();
		raidLogFrame.modelFrame.fs:SetText(L["Boss model not found"] .. ".");
		raidLogFrame.modelFrame:Show();
		return;
	end
	raidLogFrame.modelFrame.fs:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 20, -30);
	raidLogFrame.modelFrame.fs:Show();
	local text = "";
	local npcID;
	for k, v in pairs(NRC.zones) do
		if (v.bosses) then
			for id, bossName in pairs(v.bosses) do
				if (encounterName == bossName) then
					npcID = id;
				end
			end
		end
	end
	--Some temp hacks until I work out a better way to track event bosses.
	if (not npcID) then
		local tempName = "";
		if (encounterName == "Opera Hall") then
			tempName = "The Big Bad Wolf";
		end
		for k, v in pairs(NRC.zones) do
			if (v.bosses) then
				for id, bossName in pairs(v.bosses) do
					if (tempName == bossName) then
						npcID = id;
					end
				end
			end
		end
	end
	if (npcID and NRC.db.global.npcData[npcID] and NRC.db.global.npcData[npcID].class and NRC.db.global.npcData[npcID].class ~= "") then
		text = text .. "|cFF9CD6DE" .. L["Class"] .. ":|r " .. NRC.db.global.npcData[npcID].class .. "\n";
	elseif (npcID and NRC.npcs[npcID] and NRC.npcs[npcID].class and NRC.npcs[npcID].class ~= "") then
		text = text .. "|cFF9CD6DE" .. L["Class"] .. ":|r " .. NRC.npcs[npcID].class .. "\n";
	end
	if (npcID and NRC.db.global.npcData[npcID] and NRC.db.global.npcData[npcID].hp) then
		text = text .. "|cFF9CD6DE" .. L["Health"] .. ":|r " .. NRC:commaValue(NRC.db.global.npcData[npcID].hp) .. "\n";
	elseif (npcID and NRC.npcs[npcID] and NRC.npcs[npcID].hp and NRC.npcs[npcID].hp > 0) then
		text = text .. "|cFF9CD6DE" .. L["Health"] .. ":|r " .. NRC:commaValue(NRC.npcs[npcID].hp) .. "\n";
	end
	if (npcID and NRC.db.global.npcData[npcID] and NRC.db.global.npcData[npcID].type and NRC.db.global.npcData[npcID].type ~= "") then
		text = text .. "|cFF9CD6DE" .. L["Type"] .. ":|r " .. NRC.db.global.npcData[npcID].type .. "\n";
	elseif (npcID and NRC.npcs[npcID] and NRC.npcs[npcID].type and NRC.npcs[npcID].type ~= "") then
		text = text .. "|cFF9CD6DE" .. L["Type"] .. ":|r " .. NRC.npcs[npcID].type .. "\n";
	end
	raidLogFrame.modelFrame.fs2:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 20, -50);
	raidLogFrame.modelFrame.fs2:Show();
	raidLogFrame.modelFrame.fs2:SetText(text);
	PanelTemplates_SetTab(raidLogFrame.scrollFrame, 0);
	--raidLogFrame.modelFrame:SetPosition(-5, 0, -0.9);
	--raidLogFrame.modelFrame:SetCamDistanceScale(1.1);
	raidLogFrame.modelFrame.creature:SetYaw(3.7);
	--raidLogFrame.modelFrame:RefreshCamera();
	centerCreatureModule(raidLogFrame.modelFrame);
	raidLogFrame.modelFrame:Show();
end

function NRC:getPortableModelFrame(encounterID, encounterName)
	if (not portableModelFrame) then
		portableModelFrame = NRC:createModelFrame("NRCPortableModelFrame", 1, 1, 0, 0, nil, true);
		portableModelFrame:SetParent(raidLogFrame.scrollFrame);
	end
	local id, name, description, displayInfo, iconImage, uiModelSceneID = getEncounterData(encounterID);
	if (displayInfo) then
		portableModelFrame.creature:SetModelByCreatureDisplayID(displayInfo);
	else
		return;
	end
	portableModelFrame.creature:SetYaw(3.7);
	centerCreatureModule(portableModelFrame);
	return portableModelFrame;
end

local bossData;
local function createBossData()
	bossData = {};
	--2 expansions, 1 = classic, 2 = tbc.
	for i = 1, 2 do
		bossData[i] = {};
		for instanceID, instanceData in NRC:pairsByKeys(NRC.instanceTextures) do
			local bosses = {};
			for encounterID, encounterData in NRC:pairsByKeys(NRC.encounters) do
				if (instanceID == encounterData[8] and i == encounterData[7]) then
					--[[if (not bossData[i][instanceID]) then
						bossData[i][instanceID] = {
							name = instanceData[1],
							desc = instanceData[2],
							bosses = {},
						};
					end
					bossData[i][instanceID].bosses[npcID] = {
						icon = encounterData[5],
						model = encounterData[4],
					};]]
					local boss = {
						name = encounterData[2],
						icon = encounterData[5],
						model = encounterData[4],
					};
					tinsert(bosses, boss);
				end
			end
			if (next(bosses)) then
				--NRC:sortByKey(bosses, "order");
				local t = {
					name = instanceData[1],
					desc = instanceData[2],
					order = instanceData[8],
					bosses = bosses,
				}
				tinsert(bossData[i], t);
			end
		end
		NRC:sortByKey(bossData[i], "order");
	end
end

function NRC:loadAllBossView()
	clearRaidLogFrame();
	raidLogFrame.frameType = "bossView";
	updateFrames();
	raidLogFrame.titleText2.fs:SetText(L["Boss Journal"]);
	raidLogFrame.titleText2:ClearAllPoints();
	raidLogFrame.titleText2:SetPoint("TOP", raidLogFrame, "TOP", 0, -41);
	--Adjust frame width the instance name text sits on so it centers.
	raidLogFrame.titleText2:SetWidth(raidLogFrame.titleText2.fs:GetStringWidth());
	raidLogFrame.titleText2:Show();
	raidLogFrame.titleText2.texture:Hide();
	--raidLogFrame.scrollChild.fs:SetPoint("TOPLEFT", raidLogFrame.scrollChild, "TOPLEFT", 50, -30);
	--raidLogFrame.scrollChild.fs:Show();
	--raidLogFrame.scrollChild.fs:SetText("Coming soon.");
	if (not bossData) then
		createBossData();
	end
	--NRC:debug(bossData);
	local count = 0;
	local framesUsed = {};
	local startOffset, padding, offset = 20, 30, 0;
	for expansionNum, expansionData in ipairs(bossData) do
		count = count + 1;
		local frame = raidLogFrame.getLineFrame(count, expansionData);
		if (frame) then
			framesUsed[count] = true;
			frame:ClearAllPoints();
			if (count == 1) then
				offset = startOffset;
			else
				offset = offset + padding;
			end
			frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 3, -offset);
			frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -300, 0);
			frame:Show();
			local text = "";
			if (expansionNum == 1) then
				text = "Classic";
			elseif (expansionNum == 2) then
				text = "The Burning Crusade";
			else
				text = expansionNum;
			end
			if (count < 10) then
				frame.fs:SetPoint("LEFT", 12, 0);
			else
				frame.fs:SetPoint("LEFT", 5, 0);
			end
			if (frame.ClearNormalTexture) then
				frame:ClearNormalTexture();
			else
				frame:SetNormalTexture(nil);
			end
			frame:SetHighlightTexture(nil);
			frame.leftTexture:SetSize(5, 5);
			frame.leftTexture:SetScale(0.8);
			frame.leftTexture:Hide();
			frame:SetHeight(14);
			--frame.tooltip.fs:SetText("|CffDEDE42Click to view Boss");
			frame.tooltip.fs:SetText("");
			frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
			frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
			--frame.fs:SetText("|cFFFFFFFF" .. count .. ")|r");
			frame.fs2:SetPoint("LEFT", 85, 0);
			frame.fs2:SetText(text);
			frame.expandedButton:ClearAllPoints();
			frame.expandedButton:SetPoint("LEFT", frame, "LEFT", 10, 0);
			frame.collapsedButton:ClearAllPoints();
			frame.collapsedButton:SetPoint("LEFT", frame, "LEFT", 10, 0);
			if (expansionData.expanded) then
				frame.expandedButton:Show();
				frame.collapsedButton:Hide();
			else
				frame.expandedButton:Hide();
				frame.collapsedButton:Show();
			end
			if (expansionData.instanceID) then
				local name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID = getInstanceTextures(v.instanceID);
				frame.leftTexture:SetTexture(loreImage);
			else
				frame.leftTexture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
			end
			frame.leftTexture:SetTexCoord(0, 0.76171875, 0.06, 0.60625);
			frame.removeButton:Hide();
			frame:SetScript("OnClick", function(self, arg)
				if (not expansionData.expanded) then
					expansionData.expanded = true;
				else
					expansionData.expanded = false;
				end
				NRC:loadAllBossView();
			end)
			frame.id = count;
			if (expansionData.expanded) then
				for instanceNum, instanceData in pairs(expansionData) do
					if (type(instanceData) == "table") then
						count = count + 1;
						local frame = raidLogFrame.getLineFrame(count, instanceData);
						if (frame) then
							framesUsed[count] = true;
							frame:ClearAllPoints();
							if (count == 1) then
								offset = startOffset;
							else
								offset = offset + padding;
							end
							frame:SetPoint("LEFT", raidLogFrame.scrollChild, "TOPLEFT", 50, -offset);
							frame:SetPoint("RIGHT", raidLogFrame.scrollChild, "RIGHT", -300, 0);
							frame:Show();
							local text = instanceNum .. " " .. instanceData.name;
							if (count < 10) then
								frame.fs:SetPoint("LEFT", 12, 0);
							else
								frame.fs:SetPoint("LEFT", 5, 0);
							end
							if (frame.ClearNormalTexture) then
								frame:ClearNormalTexture();
							else
								frame:SetNormalTexture(nil);
							end
							frame:SetHighlightTexture(nil);
							frame.leftTexture:SetSize(5, 5);
							frame.leftTexture:SetScale(0.8);
							frame.leftTexture:Hide();
							frame:SetHeight(14);
							--frame.tooltip.fs:SetText("|CffDEDE42Click to view Boss");
							frame.tooltip.fs:SetText("");
							frame.tooltip:SetWidth(frame.tooltip.fs:GetStringWidth() + 18);
							frame.tooltip:SetHeight(frame.tooltip.fs:GetStringHeight() + 12);
							--frame.fs:SetText("|cFFFFFFFF" .. count .. ")|r");
							frame.fs2:SetPoint("LEFT", 85, 0);
							frame.fs2:SetText(text);
							frame.expandedButton:ClearAllPoints();
							frame.expandedButton:SetPoint("LEFT", frame, "LEFT", 10, 0);
							frame.collapsedButton:ClearAllPoints();
							frame.collapsedButton:SetPoint("LEFT", frame, "LEFT", 10, 0);
							if (instanceData.expanded) then
								frame.expandedButton:Show();
								frame.collapsedButton:Hide();
							else
								frame.expandedButton:Hide();
								frame.collapsedButton:Show();
							end
							if (instanceData.instanceID) then
								local name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID = getInstanceTextures(v.instanceID);
								frame.leftTexture:SetTexture(loreImage);
							else
								frame.leftTexture:SetTexture("Interface\\Addons\\NovaRaidCompanion\\Media\\Blizzard\\UI-EJ-LOREBG-Default");
							end
							frame.leftTexture:SetTexCoord(0, 0.76171875, 0.06, 0.60625);
							frame.removeButton:Hide();
							frame:SetScript("OnClick", function(self, arg)
								if (not instanceData.expanded) then
									instanceData.expanded = true;
								else
									instanceData.expanded = false;
								end
								NRC:loadAllBossView();
							end)
							frame.id = count;
						end
					end
				end
			end
		end
	end
	--raidLogFrame.updateExpandedFrames();
	--Hide any no longer in use lines frames from the bottom when instances are deleted.
	for i = 1, NRC.db.global.maxRecordsShown do
		if (raidLogFrame.lineFrames[i] and not framesUsed[i]) then
			raidLogFrame.lineFrames[i]:Hide();
		end
	end
end

local lockoutsFrame;
local lockoutsFrameWidth = 100;
function NRC:openLockoutsFrame()
	if (not lockoutsFrame) then
		--lockoutsFrame = NRC:createSimpleInputScrollFrame("NRCLockoutsFrame", 200, 400, 0, 100);
		lockoutsFrame = NRC:createSimpleTextFrame("NRCLockoutsFrame", lockoutsFrameWidth, 100, 0, 330, 3)
		lockoutsFrame.onUpdateFunction = "recalcLockoutsFrame";
		lockoutsFrame.fs:SetText("|cFFFFFF00" .. L["Raid Lockouts (Including Alts)"] .. "|r");
		lockoutsFrame.closeButton:SetPoint("TOPRIGHT", 3.45, 3.2);
		lockoutsFrame.closeButton:SetWidth(28);
		lockoutsFrame.closeButton:SetHeight(28);
	end
	if (not lockoutsFrame:IsShown()) then
		lockoutsFrame:Show();
	else
		lockoutsFrame:Hide();
	end
end

function NRC:recalcLockoutsFrame()
	local me = UnitName("player");
	local found;
	local text = "";
	for k, v in pairs(NRC.data) do
		if (type(v) == "table") then
			if (k == "myChars") then
				for char, charData in pairs(v) do
					local found2;
					local _, _, _, classColorHex = GetClassColor(charData.englishClass);
					local text2 = "\n|c" .. classColorHex .. char .. "|r";
					if (charData.savedInstances) then
						for instance, instanceData in pairs(charData.savedInstances) do
							if (instanceData.locked and instanceData.resetTime and instanceData.resetTime > GetServerTime()) then
								local timeString = "(" .. NRC:getTimeString(instanceData.resetTime - GetServerTime(), true, NRC.db.global.timeStringType) .. ")";
								local name = instanceData.name;
								if (instanceData.name and instanceData.difficultyName) then
									name = NRC:addDiffcultyText(instanceData.name, instanceData.difficultyName, nil, "", "|cFFFFFF00");
								end
								text2 = text2 .. "\n  |cFFFFFF00-|r|cFFFFAE42" .. name .. "|r |cFF9CD6DE" .. timeString .. "|r";
								found = true;
								found2 = true;
							end
						end
					end
					if (found2) then
						text = text .. text2;
					end
				end
			end
		end
	end
	if (not found) then
		text = L["noCurrentRaidLockouts"];
	end
	local threeDayReset = NRC:getThreeDayReset();
	local weeklyReset = NRC:getWeeklyReset();
	if (threeDayReset) then
		local threeDateString, weeklyDateString = "", "";
		if (NRC.db.global.timeStampFormat == 12) then
			threeDateString = " (" .. date("%A", threeDayReset) .. " " .. gsub(date("%I:%M", threeDayReset), "^0", "")
					.. string.lower(date("%p", threeDayReset)) .. ")";
			weeklyDateString = " (" .. date("%A", weeklyReset) .. " " .. gsub(date("%I:%M", weeklyReset), "^0", "")
					.. string.lower(date("%p", weeklyReset)) .. ")";
		else
			threeDateString = " (" .. date("%A %H:%M", threeDayReset) .. ")";
			weeklyDateString = " (" .. date("%A %H:%M", weeklyReset) .. ")";
		end
		text = text .. "\n\n\n|cFF00C8003day reset (ZA):|r |cFF9CD6DE" .. NRC:getTimeString(threeDayReset - GetServerTime(), true, "medium")
				.. threeDateString .. "|r";
		text = text .. "\n|cFF00C800Weekly reset:|r |cFF9CD6DE" .. NRC:getTimeString(weeklyReset - GetServerTime(), true, "medium")
				.. weeklyDateString .. "|r";
	end
	lockoutsFrame.fs2:SetText(text);
	local width = lockoutsFrame.fs2:GetStringWidth();
	if (width < 200) then
		width = 200;
	end
	if (width > lockoutsFrameWidth) then
		lockoutsFrameWidth = width;
		lockoutsFrame:SetWidth(width + 18);
	end
	lockoutsFrame:SetHeight(lockoutsFrame.fs2:GetStringHeight() + 40);
end

function NRC:equipDurabilityCheck()
	if (NRC.config.duraWarning) then
		local percent, broken = NRC.dura.GetDurability();
		if (percent and percent < 50) then
			local color = "|cFF00C800";
			if (percent < 31) then
				color = "|cFFFF2222";
			elseif (percent < 70) then
				color = "|cFFDEDE42";
			end
			local coloredDura = color .. math.floor(percent) .. "%|r";
			C_Timer.After(2, function()
				NRC:print(NRC.prefixColor .. L["Warning"] .. ":|r |cFF0096FF" .. L["Your durability is at"] .. " " .. coloredDura .. ".");
			end)
		end
	end
end

local combatTime;
function NRC:startCombatTime()
	if (NRC.raid) then
		combatTime = GetTime();
	end
end

function NRC:stopCombatTime()
	if (NRC.raid and combatTime) then
		local elapsed = GetTime() - combatTime;
		NRC.raid.combatTime = NRC.raid.combatTime + elapsed;
	end
	combatTime = nil;
end

SLASH_NRCGHECMD1 = '/ghetto';
function SlashCmdList.NRCGHECMD(msg, editBox)
	if (IsInInstance() and not IsInGroup()) then
		InviteUnit("1");
		C_Timer.After(1,function()
			LeaveParty();
		end)
	else
		NRC:print("This only works inside an instance and while not in a group.");
	end
end

-----------------------------------------------------------
---Raid detection (mostly taken from my other addon NIT)---
-----------------------------------------------------------

local doGUID;
local f = CreateFrame("Frame", "NRCRaidLog2");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ADDONS_UNLOADING");
f:RegisterEvent("UNIT_TARGET");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
f:RegisterEvent("NAME_PLATE_UNIT_ADDED");
f:RegisterEvent("PLAYER_CAMPING");
f:RegisterEvent("PLAYER_LOGOUT");
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("GROUP_LEFT");
f:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
f:RegisterEvent("UPDATE_INSTANCE_INFO");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "NAME_PLATE_UNIT_ADDED") then
		NRC:parseGUIDRD("nameplate1", nil, "nameplate");
	elseif (event == "PLAYER_ENTERING_WORLD" ) then
		lastEnteringWorld = GetTime();
		local isLogon, isReload = ...;
		NRC:playerEnteringWorldRD(...);
		--Noticed on rare occasions it won't record lockouts properly, adding a couple more checks.
		C_Timer.After(1, function()
			NRC:recordLockoutData();
		end)
		C_Timer.After(10, function()
			NRC:recordLockoutData();
		end)
		combatTime = nil;
	elseif (event == "ADDONS_UNLOADING" ) then
		NRC:playerLogoutRD(...);
	elseif (event == "UNIT_TARGET" or event == "PLAYER_TARGET_CHANGED") then
		NRC:parseGUIDRD("target", nil, "target");
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		NRC:parseGUIDRD("mouseover", nil, "mouseover");
	elseif (event == "PLAYER_CAMPING") then
		--Print stats if logging out inside an instance for an offline reset.
		if (NRC.inInstance) then
			NRC.raid.leftTime = GetServerTime();
		end
		NRC:recordLockoutData();
	elseif (event == "PLAYER_LOGOUT") then
		NRC:recordLockoutData();
	elseif (event == "GROUP_JOINED") then
		if (NRC.raid) then
			--Rejoined group while inside raid.
			NRC.lastRaidGroupInstanceID = NRC.raid.instanceID;
			NRC.lastRaidID = NRC.raid.raidID;
		end
		badges = {};
	elseif (event == "GROUP_LEFT") then
		NRC.lastRaidGroupInstanceID = nil;
		NRC.lastRaidID = nil;
	elseif (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
		NRC:chatMsgCombatFactionChange(...);
	elseif (event == "UPDATE_INSTANCE_INFO" ) then
		C_Timer.After(1, function()
			NRC:recordLockoutData();
		end)
	end
end)

--This frame is only used for same instance detection and disabled after first event after entering.
--Changed to it's own frame for disabling to see if it makes a performance difference.
local instanceDetectionFrame = CreateFrame("Frame");
instanceDetectionFrame:SetScript('OnEvent', function(self, event, ...)
	local _, subEvent, _, sourceGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo();
	if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE") then
		if (sourceGUID and strfind(sourceGUID, "Creature")) then
			NRC:parseGUIDRD(nil, sourceGUID, "combatlogSourceGUID");
			instanceDetectionFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		elseif (destGUID and strfind(destGUID, "Creature")) then
			NRC:parseGUIDRD(nil, destGUID, "combatlogDestGUID");
			instanceDetectionFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
	end
end)

local checkRaidLocks;
hooksecurefunc("StaticPopup_Show", function(...)
	local found;
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialogType = _G["StaticPopup"..i].which
		if (dialogType == "INSTANCE_LOCK" and _G["StaticPopup" .. i]:IsShown()) then
			checkRaidLocks = true;
			return;
		end
	end
end)

--There doesn't seem to be any instance lock event so we check data after boss kills and after the instance_lock popup has closed.
--Seems like when you click accept OnHide doesn't trigger until the timer finishes counting down in the background?
hooksecurefunc("StaticPopup_Hide", function(...)
	local found;
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialogType = _G["StaticPopup"..i].which
		if (dialogType == "INSTANCE_LOCK" and checkRaidLocks) then
			C_Timer.After(3, function()
				NRC:recordLockoutData();
			end)
			checkRaidLocks = nil;
			return;
		end
	end
end)

--Trim records to maxRecordsKept, can set records shown to max 500 in options, 100 is default.
function NRC:trimDatabase()
	local max = NRC.db.global.maxRecordsKept;
	if (max > 50) then
		max = 50;
	end
	--for i, v in pairs(NRC.db.global.instances) do
	for i = #NRC.db.global.instances, 1, -1 do
		if (i > max) then
			table.remove(NRC.db.global.instances, i);
		end
	end
end

function NRC:playerEnteringWorldRD(...)
	local isLogon, isReload = ...;
	--On rare occasions you PLAYER_ENTERING_WORLD as a ghost still instead of unghosting beforehand.
	local isInstance, instanceType = IsInInstance();
	if (isInstance) then
		if (isReload) then
			C_Timer.After(0.2, function()
				NRC:enteredInstanceRD(true);
			end)
		elseif (isLogon) then
			C_Timer.After(0.2, function()
				NRC:enteredInstanceRD(nil, true);
			end)
		else
			C_Timer.After(0.2, function()
				if (isInstance) then
					NRC:enteredInstanceRD();
				end
			end)
		end
	elseif (NRC.inInstance and not isReload) then
		NRC:leftInstanceRD();
	end
end

function NRC:playerLogoutRD(...)
	if (NRC.inInstance) then
		NRC:leftInstanceRD();
	end
end

function NRC:getNewRaidID()
	NRC.db.global.raidID = NRC.db.global.raidID + 1;
	local raidID = NRC.db.global.raidID;
	return raidID;
end

local function doubleCheckRaidDifficuly()
	NRC:debug("Rechecking instance difficulty.");
	if (NRC.inInstance) then
		local _, _, difficultyID, difficultyName = GetInstanceInfo();
		if (difficultyID and difficultyID > 0 and difficultyName and difficultyName ~= "") then
			NRC.db.global.instances[1].difficultyID = difficultyID;
			NRC.db.global.instances[1].difficultyName = difficultyName;
			NRC:debug("Updated instance difficulty data.");
		end
	end
end

local isGhost = false;
NRC.lastInstanceName = "(Unknown Instance)";
function NRC:enteredInstanceRD(isReload, isLogon)
	doGUID = true;
	local instance, instanceType = IsInInstance();
	--if (instanceType ~= "raid") then
		--return;
	--end
	local type;
	if (NRC.isTBC) then
		if (NRC:isInArena()) then
			type = "arena";
			return;
		elseif (UnitInBattleground("player")) then
			type = "bg";
			return;
		end
	end
	local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty,
				isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo();
	if (NRC.zones[instanceID] and NRC.zones[instanceID].type == "raid") then
		--Override if we have the instance set as a raid in db, used for sod raids.
		instanceType = "raid";
	end
	--if (instance == true and (instanceType == "raid" or NRC.config.logDungeons) and type ~= "arena" and type ~= "bg") then
	if (instance == true and ((instanceType == "raid" and NRC.config.logRaids) or (instanceType == "party" and NRC.config.logDungeons))
			and type ~= "arena" and type ~= "bg") then
		if (NRC.inInstance and NRC.lastInstanceName ~= instanceName) then
			--If we zone from one instance into another instance and the instance name if different (UBRS to BWL etc).
			--Close out the old instance data before starting a new.
			NRC:leftInstanceRD();
		end
		NRC.lastInstanceName = instanceName;
		if (not instanceName) then
			instanceName = "(Instance Name Not Found)";
		end
		local instanceNameMsg = instanceName;
		local raidID;
		if (not isReload) then
			--Increment new unique raidID.
			raidID = NRC:getNewRaidID();
			local class, classEnglish = UnitClass("player");
			local t = {
				raidID = raidID,
				playerName = UnitName("player"),
				class = class,
				classEnglish = classEnglish,
				instanceName = instanceName,
				instanceID = instanceID,
				instanceType = instanceType,
				difficultyID = difficultyID,
				difficultyName = difficultyName,
				type = type,
				enteredTime = GetServerTime(),
				leftTime = 0,
				combatTime = 0,
				group = {},
				encounters = {},
				npcDeaths = {},
				loot = {},
				rep = {},
				--playerDeaths = {},
				--trackItems = {},
			};
			--Insert as first row, instances are stored newest first in the data table.
			tinsert(NRC.db.global.instances, 1, t);
		else
			--If it's a reload then use last raidID.
			raidID = NRC.db.global.raidID;
		end
		--This is cleared on group leave.
		NRC.lastRaidGroupInstanceID = instanceID;
		NRC.lastRaidID = raidID;
		NRC.raid = NRC.db.global.instances[1];
		NRC:equipDurabilityCheck();
		C_Timer.After(0.5, function()
			NRC.inInstance = GetServerTime();
		end)
		NRC:trimDatabase();
		NRC:addInstanceCount(instanceID);
		C_Timer.After(1, function()
			NRC:recordGroupInfo();
		end)
		C_Timer.After(30, function()
			NRC:recordGroupInfo();
		end)
		--Sometimes difficulyID isn't known when entering, bug on Blizzards end? Seems to happen a lot at Malygos.
		if (difficultyID and difficultyID < 1) then
			C_Timer.After(2, function()
				doubleCheckRaidDifficuly();
			end)
		end
		instanceDetectionFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
	if (instanceType == "raid" and NRC.config.autoCombatLog) then
		C_Timer.After(1, function()
			NRC:startCombatLogging(true);
		end)
	end
end

function NRC:leftInstanceRD()
	if (NRC.inInstance and NRC.raid) then
		NRC.raid.leftTime = GetServerTime();
	end
	NRC:recordLockoutData();
	NRC.raid = nil;
	NRC.inInstance = nil;
	NRC.lastNpcID = 999999999;
	NRC.lastInstanceName = "(Unknown Instance)";
end

NRC.lastNpcID = 999999999;
NRC.lastMerge = 0;
function NRC:parseGUIDRD(unit, GUID, source)
	--Don't merge pvp instances, zoneids can come from temporary pets with a creature guid.
	if (NRC.raid and NRC.raid.isPvp) then
		return;
	end
	if (not GUID) then
		GUID = UnitGUID(unit);
	end
	if (GUID and doGUID and NRC.inInstance and (not strfind(source, "combatlog") or GetServerTime() - NRC.inInstance > 2)) then
		local unitType, _, _, _, zoneID, npcID = strsplit("-", GUID);
		local zoneID = tonumber(zoneID);
		if (unitType ~= "Creature" or NRC.companionCreatures[tonumber(npcID)]) then
			--NRC:debug("not a creature");
			return;
		end
		--[[if (NRC.isDebug) then
			if (not NRC.raid.GUIDList) then
				NRC.raid.GUIDList = {};
			end
			local data = (GUID or "nil");
			NRC.raid.GUIDList[data] = true;
		end]]
		NRC.lastNpcID = npcID;
		if (zoneID and zoneID > 0 and NRC.raid) then
			local instances = NRC.db.global.instances;
			local merged;
			--Check the last 4 instances incase we leave/join without getting a zoneID.
			for i = 2, 5 do
				local ins = instances[i];
				if (ins and ins.zoneID == zoneID) then
					NRC:mergeInstancesRD(1, i, GUID, source);
				end
			end
			if (NRC.lastNpcID == npcID or (not NRC.raid.zoneID or NRC.raid.zoneID < 1)) then
				--Set new zoneID if we get the same zoneid from 2 mobs in a row the same or one isn't set yet.
				NRC.raid.zoneID = zoneID;
				NRC.raid.GUID = GUID;
				NRC.raid.GUIDSource = unit or "combatLog";
			end
			--Only merge if current GUID isn't set (first GUID of the instance).
			--[[if (NRC.db.global.instances[2] and NRC.db.global.instances[2]["zoneID"] and NRC.db.global.instances[2]["zoneID"] == zoneID
					and not NRC.raid.zoneID) then
				if (NRC.db.global.detectSameInstance) then
					--NRC:debug("OldGUID:", NRC.db.global.instances[2].GUID, "NewGUID:", GUID, source);
					--NRC:debug("OldZoneID:", NRC.db.global.instances[2]["zoneID"], "NewZoneID:", zoneID, source);
					--Merge instances data and then delete last.
					NRC.raid.zoneID = zoneID;
					NRC.raid.GUID = GUID;
					NRC:mergeLastInstancesRD(GUID, source);
					NRC:debug("same instance detected");
				end
			elseif (NRC.lastNpcID == npcID or (not NRC.raid.zoneID or NRC.raid.zoneID < 1)) then
				--Set new zoneID if we get the same zoneid from 2 mobs in a row the same or one isn't set yet.
				NRC.raid.zoneID = zoneID;
				NRC.raid.GUID = GUID;
				NRC.raid.GUIDSource = unit or "combatLog";
			end]]
		end
	end
end

--[[function NRC:mergeLastInstancesRD(GUID, source)
	local instanceOne = NRC.db.global.instances[1];
	if (instanceOne) then
		local zoneID = instanceOne.zoneID;
		if (zoneID) then
			for i = 2, 5 do
				local instanceTwo = NRC.db.global.instances[i];
				if (instanceTwo.zoneID and zoneID == instanceTwo.zoneID) then
					NRC:mergeInstancesRD(1, i, GUID, source);
				end
			end
		end
	end
end]]

--Merged countable instance data when deleting duplicate instance.
--instanceOne must be the instance that was entered after instanceTwo.
function NRC:mergeInstancesRD(instanceOne, instanceTwo, GUID, source)
	local class, classEnglish = UnitClass("player");
	NRC.db.global.instances[instanceTwo].playerName = UnitName("player");
	NRC.db.global.instances[instanceTwo].class = class;
	NRC.db.global.instances[instanceTwo].classEnglish = classEnglish;
	--if (NRC.db.global.instances[instanceOne].zoneID) then
	--	NRC.db.global.instances[instanceTwo].oldZoneID = NRC.db.global.instances[instanceOne].zoneID;
	--end
	NRC.db.global.instances[instanceTwo].lastEnteredTime = GetServerTime();
	NRC.db.global.instances[instanceTwo].combatTime = (NRC.db.global.instances[instanceTwo].combatTime or 0)
			+ (NRC.db.global.instances[instanceOne].combatTime or 0);
	if (GUID) then
		NRC.db.global.instances[instanceTwo].mergeGUID = GUID;
	end
	if (source) then
		NRC.db.global.instances[instanceTwo].mergeSource = source;
	end
	local data = NRC.db.global.instances[instanceOne];
	if (not data) then
		NRC:debug("Missing instance " .. instanceOne .. " data while merging.");
	end
	if (data.instanceID) then
		NRC:removeInstanceCount(data.instanceID);
	end
	--Merge npc deaths, npc death could be the first event seen that triggers merge.
	for k, v in pairs(data.npcDeaths) do
		if (not NRC.db.global.instances[instanceTwo].npcDeaths[k]) then
			NRC.db.global.instances[instanceTwo].npcDeaths[k] = v;
		elseif (NRC.db.global.instances[instanceTwo].npcDeaths and NRC.db.global.instances[instanceTwo].npcDeaths[k]
				and NRC.db.global.instances[instanceTwo].npcDeaths[k].count and v.count) then
			NRC.db.global.instances[instanceTwo].npcDeaths[k].count = NRC.db.global.instances[instanceTwo].npcDeaths[k].count + v.count;
		end
	end
	--Merge encounters, insert encounters from the later instance to the first entered instance.
	for tableID, encounter in ipairs(data.encounters) do
		tinsert(NRC.db.global.instances[instanceTwo].encounters, encounter);
	end
	--Merge group data.
	for guid, playerData in pairs(data.group) do
		if (not NRC.db.global.instances[instanceTwo].group[guid]) then
			--If this player isn't in the previous instance data then just copy entire data over.
			NRC.db.global.instances[instanceTwo].group[guid] = playerData;
		else
			for deaths, deathData in ipairs(playerData.deaths) do
				--Previous instance data was added first (if any) so we can simply insert this instance data to the end of the table.
				tinsert(NRC.db.global.instances[instanceTwo].group[guid].deaths, deathData);
			end
			for trackedItem, trackedItemData in pairs(playerData.trackedItems) do
				--NRC.db.global.instances[instanceTwo].group[guid].trackedItems[trackedItem] = trackedItemData;
				if (not NRC.db.global.instances[instanceTwo].group[guid].trackedItems[trackedItem]) then
					NRC.db.global.instances[instanceTwo].group[guid].trackedItems[trackedItem] = {};
				end
				for itemID, itemUsage in pairs(trackedItemData) do
					tinsert(NRC.db.global.instances[instanceTwo].group[guid].trackedItems[trackedItem], itemUsage);
				end
			end
		end
	end
	for k, v in pairs(data.loot) do
		--If any loot was added as we're running back after a wipe but we haven't seed a guid yet to merge.
		tinsert(NRC.db.global.instances[instanceTwo].loot, v);
	end
	NRC.lastMerge = GetServerTime();
	--Swap table indexes and deleted the old table, we want the new data in the instanceOne index.
	NRC.db.global.instances[instanceOne], NRC.db.global.instances[instanceTwo]
			= NRC.db.global.instances[instanceTwo], NRC.db.global.instances[instanceOne];
	table.remove(NRC.db.global.instances, instanceTwo);
	--Check if any instances inbetween the 2 merged logs are just ones we likely popped into for a second and left without getting a zoneID.
	--Check there was an instance between and ifthese 2 id's are next to each other or it may delete the first instance.
	--Check 4 instances back only.
	if (instanceOne == 1 and instanceOne ~= instanceTwo - 1) then
		local count = 0;
		local delete = {};
		for i = instanceOne + 1, instanceTwo - 1 do
			count = count + 1;
			local ins = NRC.db.global.instances[i];
			if (ins) then
				if (not ins.zoneID) then
					--Just a safeguard incase I mess something up...
					if (i ~= instanceOne and i ~= instanceTwo) then
						tinsert(delete, i);
					end
				end
			end
			if (count > 3) then
				break;
			end
		end
		if (next(delete)) then
			--Iterate backwards to remove entries.
			for i = #delete, 1, -1 do
				--Get number of log to delete.
				local del = delete[i];
				local encounters = #NRC.db.global.instances[i].encounters;
				local instanceID = NRC.db.global.instances[1].instanceID;
				local instanceIDTwo = NRC.db.global.instances[i].instanceID;
				local npcDeaths = 0;
				for k, v in pairs(NRC.db.global.instances[i].npcDeaths) do
					npcDeaths = npcDeaths + v.count;
				end
				if (encounters == 0 and npcDeaths == 0 and instanceIDTwo == instanceID) then
					NRC:debug("Removing empty instance log ID " .. del .. " between 2 of the same zoneID (Encounters " .. encounters
							.. ") (Trash " .. npcDeaths .. ").");
				    table.remove(NRC.db.global.instances, del);
			    end
			end
		end
	end
	if (NRC.raid and instanceOne == 1) then
		NRC.raid = NRC.db.global.instances[1];
		NRC.lastRaidGroupInstanceID = NRC.raid.instanceID;
		NRC.lastRaidID = NRC.raid.raidID;
	end
end

function NRC:addInstanceCount(instanceID)
	local char = UnitName("player");
	if (not NRC.data.myChars[char]) then
		NRC.data.myChars[char] = {};
	end
	if (not NRC.data.myChars[char].instances) then
		NRC.data.myChars[char].instances = {};
	end
	if (not NRC.data.myChars[char].instances[instanceID]) then
		NRC.data.myChars[char].instances[instanceID] = 0;
	end
	NRC.data.myChars[char].instances[instanceID] = NRC.data.myChars[char].instances[instanceID] + 1;
end

function NRC:removeInstanceCount(instanceID)
	local char = UnitName("player");
	if (NRC.data.myChars[char] and NRC.data.myChars[char].instances and NRC.data.myChars[char].instances[instanceID]
			and NRC.data.myChars[char].instances[instanceID] > 0) then
		NRC.data.myChars[char].instances[instanceID] = NRC.data.myChars[char].instances[instanceID] - 1;
	end
end

local recordGroupInfoThroddle = 0;
function NRC:recordGroupInfo()
	if (not NRC.inInstance or not NRC.raid) then
		return;
	end
	if ((GetServerTime() - recordGroupInfoThroddle) < 2) then
		--Throddle to only run this once every 2 seconds because it can be called from a few different things.
		return;
	end
	if (not NRC.raid.group) then
		NRC.raid.group = {};
	end
	recordGroupInfoThroddle = GetServerTime();
	if (IsInRaid()) then
		for i = 1, 40 do
			local guid = UnitGUID("raid" .. i);
			if (guid) then
				NRC:addToGroupData(nil, guid);
			end
		end
	elseif (IsInGroup()) then
		for i = 1, 5 do
			local guid = UnitGUID("party" .. i);
			if (guid) then
				NRC:addToGroupData(nil, guid);
			end
		end
	else
		return;
	end
	NRC:addToGroupData("player");
end

--Can accept both unit/guid or only one.
function NRC:addToGroupData(unit, guid, checkExists)
	if (not guid) then
		guid = UnitGUID(unit);
		if (not guid) then
			return;
		end
	end
	if (checkExists) then
		--If this player exists in group db already then return.
		if (NRC.raid and NRC.raid.group[guid]) then
			return;
		end
	end
	local class, race, name, realm, level, guildName, guildRankName, guildRankIndex;
	--Only record english class/race tokens.
	_, class, _, race, _, name, realm = GetPlayerInfoByGUID(guid);
	if (unit) then
		level = UnitLevel(unit);
		guildName, guildRankName, guildRankIndex = GetGuildInfo(unit);
	end
	--if (name == "Unknown") then
		--Sometimes the game can't get info from a group member.
	--	return;
	--end
	if (guid and name) then
		if (not NRC.raid.group[guid]) then
			NRC.raid.group[guid] = {};
		end
		if (not NRC.raid.group[guid].name) then
			NRC.raid.group[guid].name = name;
		end
		--Only overwrite things if they are valid and not player out of range.
		if (realm and not NRC.raid.group[guid].realm) then
			NRC.raid.group[guid].realm = realm;
		end
		if (level and (not NRC.raid.group[guid].level or level > 0)) then
			NRC.raid.group[guid].level = level;
		end
		if (class and (not NRC.raid.group[guid].class or class ~= "")) then
			NRC.raid.group[guid].class = class;
		end
		if (race and (not NRC.raid.group[guid].race or race ~= "")) then
			NRC.raid.group[guid].race = race;
		end
		if (guildName and (not NRC.raid.group[guid].guildName or guildName ~= "")) then
			NRC.raid.group[guid].guildName = guildName;
		end
		if (not NRC.raid.group[guid].trackedItems) then
			NRC.raid.group[guid].trackedItems = {};
		end
		if (not NRC.raid.group[guid].deaths) then
			NRC.raid.group[guid].deaths = {};
		end
	end
end

--Delete instance by number, called by confirmation popup.
function NRC:deleteInstance(num)
	local data = NRC.db.global.instances[num];
	if (data) then
		if (data.instanceID) then
			NRC:removeInstanceCount(data.instanceID);
		end
		NRC:print(string.format(L["deleteInstance"], num, data.instanceName));
		table.remove(NRC.db.global.instances, num);
		NRC:recalcRaidLog(true);
	else
		NRC:print(string.format(L["deleteInstanceError"], num));
	end
end

function NRC:recordLockoutData()
	local char = UnitName("player");
	if (not NRC.data.myChars[char]) then
		NRC.data.myChars[char] = {};
	end
	if (not NRC.data.myChars[char].savedInstances) then
		NRC.data.myChars[char].savedInstances = {};
	end
	local data = {};
	for i = 1, GetNumSavedInstances() do
		local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers,
				difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		local resetTime = GetServerTime() + reset;
		if (tonumber(id)) then
			NRC.data.myChars[char].savedInstances[tonumber(id)] = {
				name = name,
				resetTime = resetTime,
				difficultyName = difficultyName,
				locked = locked,
			};
		end
	end
end

function NRC:resetOldLockouts()
	for char, charData in pairs(NRC.data.myChars) do
		if (charData.savedInstances) then
			for k, v in pairs(charData.savedInstances) do
				if (v.resetTime and v.resetTime < GetServerTime()) then
					NRC.data.myChars[char].savedInstances[k] = nil;
				end
			end
		end
	end
end

function NRC:chatMsgCombatFactionChange(...)
	if (not NRC.raid) then
		return;
	end
	if (not NRC.raid.rep) then
		NRC.raid.rep = {};
	end
	local text = ...;
	local repName, repAmount, decrease;
	--Your %s reputation has increased by %d.
	local repName, repAmount = strmatch(text, string.gsub(string.gsub(FACTION_STANDING_INCREASED, "%%s", "(.+)"), "%%d", "(%%d+)"));
	--The above line doesn't work on RU clients due to declensions.
	if (LOCALE_ruRU and not repName or not repAmount) then
		--With declension.
		--Отношение |3-7(%s) к вам улучшилось на %d.
		repName, repAmount = strmatch(text, "Отношение |3%-7%((.+)%) к вам улучшилось на (%d+).");
		if (LOCALE_ruRU and not repName or not repAmount) then
			--Without declension as a backup just incase.
			repName, repAmount = strmatch(text, "Отношение (.+) к вам улучшилось на (%d+).");
		end
	end
	--Faction decrease.
	if (not repName or not repAmount) then
		repName, repAmount = strmatch(text, string.gsub(string.gsub(FACTION_STANDING_DECREASED, "%%s", "(.+)"), "%%d", "(%%d+)"));
		decrease = true;
		if (LOCALE_ruRU and not repName or not repAmount) then
			--With Declension.
			--Отношение |3-7(%s) к вам ухудшилось на %d.
			repName, repAmount = strmatch(text, "Отношение |3%-7%((.+)%) к вам ухудшилось на (%d+).");
			if (LOCALE_ruRU and not repName or not repAmount) then
				--Without Declension as a backup just incase.
				repName, repAmount = strmatch(text, "Отношение (.+) к вам ухудшилось на (%d+).");
			end
		end
	end
	if (not repName or not repAmount) then
		NRC:debug("Faction error:", text);
		return;
	end
	if (not NRC.raid.rep[repName]) then
		NRC.raid.rep[repName] = 0
	end
	if (decrease) then
		NRC.raid.rep[repName] = NRC.raid.rep[repName] - repAmount;
	else
		NRC.raid.rep[repName] = NRC.raid.rep[repName] + repAmount;
	end
end

function NRC:chatMsgWhisper(...)
	if (NRC.config.autoInv) then
		local msg, name = ...;
		local keyword = NRC.config.autoInvKeyword;
		if (keyword and type(keyword) == "string") then
			if (strlower(msg) == strlower(keyword)) then
				InviteUnit(name);
			end
		end
	end
end

local f = CreateFrame("Frame", "NRCRaidLog");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("CHAT_MSG_LOOT");
f:RegisterEvent("CHAT_MSG_WHISPER");
f:RegisterEvent("PLAYER_REGEN_DISABLED");
f:RegisterEvent("PLAYER_REGEN_ENABLED");
f:RegisterEvent("PLAYER_LEAVING_WORLD");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(CombatLogGetCurrentEventInfo());
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		unitSpellcastSucceededRD(...);
	elseif (event == "ENCOUNTER_START") then
		NRC:encounterStartRD(...);
	elseif (event == "ENCOUNTER_END" ) then
		local encounterID, encounterName, difficultyID, groupSize, success = ...;
		NRC:encounterEndRD(encounterID, encounterName, difficultyID, groupSize, success);
		NRC:throddleEventByFunc(event, 2, "recordGroupInfo", ...);
		RequestRaidInfo();
	elseif (event == "GROUP_ROSTER_UPDATE") then
		NRC:recordGroupInfo();
	elseif (event == "CHAT_MSG_LOOT") then
		NRC:chatMsgLoot(...);
	elseif (event == "CHAT_MSG_WHISPER") then
		NRC:chatMsgWhisper(...);
	elseif (event == "PLAYER_REGEN_DISABLED") then
		NRC:startCombatTime();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		NRC:stopCombatTime();
	elseif (event == "PLAYER_LEAVING_WORLD") then
		if (NRC.raid and encounter) then
			NRC:debug("Likely released corpse while encounter still running.");
			--Release 99% of the time means a wipe, end the encounter.
			local encounterID = encounter.encounterID;
			local encounterName = encounter.encounterName;
			local difficultyID = encounter.difficultyID; 
			local groupSize = encounter.groupSize;
			NRC:encounterEndRD(encounterID, encounterName, difficultyID, groupSize, 0);
		end
	end
end)