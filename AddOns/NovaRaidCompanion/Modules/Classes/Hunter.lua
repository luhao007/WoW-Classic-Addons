------------------------------
---NovaRaidCompanion Classes--
------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local _, class = UnitClass("player");
local playerGUID = NRC.playerGUID;
local misdirection, lastMD;
local hits, lastMD = {}, {};
local distractingShot = NRC.distractingShot;
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;

---This misdirection stuff looks messy but it's what's needed to work correctly for other peoples md.
---We need a combination of events to make it work right.

local aoeSpells = {
	[13812] = "Explosive Trap (Rank 1)", --"Explosive Trap Effect".
	[14314] = "Explosive Trap (Rank 2)",
	[14315] = "Explosive Trap (Rank 3)",
	[27026] = "Explosive Trap (Rank 4)",
	[49064] = "Explosive Trap (Rank 5)",
	[49065] = "Explosive Trap (Rank 6)",
	--[13812] = "Immolation Trap (Rank 1)", --Immolation trap takes a charge when it hits but does no initial dmg it seems, maybe the dot spell application has threat?
	[13241] = "Goblin Sapper Charge",
	[30486] = "Super Sapper Charge",
	[56488] = "Global Thermal Sapper Charge";
	[56350] = "Saronite Bomb";
};
if (not NRC.isClassic and not NRC.isTBC) then
	aoeSpells[42243] = "Volley (Rank 1)";
	aoeSpells[42244] = "Volley (Rank 2)";
	aoeSpells[42245] = "Volley (Rank 3)";
	aoeSpells[42234] = "Volley (Rank 4)";
	aoeSpells[58432] = "Volley (Rank 5)";
	aoeSpells[58433] = "Volley (Rank 6)";
end

local ignoredDots = {
	--Ignore grouping certain periodic effects as dots and count them seperately.
	[53301] = "Explosive Shot (Rank 1)",
	[60051] = "Explosive Shot (Rank 2)",
	[60052] = "Explosive Shot (Rank 3)",
	[60053] = "Explosive Shot (Rank 4)",
};

local function getThreatValue(unit, spellID, amount)
	local value = amount;
	if (distractingShot[spellID]) then
		value = distractingShot[spellID];
	end
	if (NRC.isTBC) then
		--Salv and greater salv.
		if (NRC:hasBuff(unit, 1038) or NRC:hasBuff(unit, 25895)) then
			value = value * 0.7;
		end
		--Tranquil air totem.
		if (NRC:hasBuff(unit, 25908)) then
			value = value * 0.8;
		end
	end
	return math.floor(value);
end

local function tallyMisdirection(name)
	if (not misdirection or not next(hits[name])) then
		--We may have done this calc already if we're not waiting for aoe dmg.
		--Or md faded with no dmg.
		hits[name] = nil;
		if (not next(hits)) then
			misdirection = nil;
		end
		return;
	end
	local inInstance = IsInInstance();
	local total = 0;
	local data = hits[name];
	local unit = data.unit;
	local isMe;
	if (unit and UnitIsUnit(unit, "player")) then
		isMe = true;
	end
	if (not unit) then
		NRC:debug("No unit attached to misdirection calc.");
		hits[name] = nil;
		if (not next(hits)) then
			--No MD buffs currently up, disable combat log checking.
			misdirection = nil;
		end
		return;
	end
	local unitName = data.unitName;
	local target = data.target;
	local destGUID = data.destGUID;
	for k, v in ipairs(data) do
		total = total + getThreatValue(unit, v.spellID, v.amount);
	end
	if (data.dots) then
		for k, v in ipairs(data.dots) do
			total = total + getThreatValue(unit, v.spellID, v.amount);
		end
	end
	local countedAoes = {};
	if (NRC.isTBC and #data < 3) then
		--For some reason it sometimes only records 2 hits, looking at the data when this happens.
		--No damage from one hit even though a mana gain is registered from wisdom.
		--Example here about 12 seconds in: https://classic.warcraftlogs.com/reports/zaHG9QYqBbjDphtN/#fight=last&type=summary&source=8&view=events
		--NRC:debug("Less than 3 hits recorded during misdirection.");
		--NRC:debug(data);
	else
		if (total > 0) then
			local spellsText = "";
			local found;
			for k, v in ipairs(data) do
				--local spellName = GetSpellInfo(v.spellID);
				--if (v.spellID == 0) then
					--0 spellID is likely a melee hit, don't translate it via GetSpellInfo() and just print the recorded name.
					--spellName = v.spellName;
				--end
				if (not countedAoes[v.spellID]) then
					local spellName = v.spellName;
					local spellLink;
					if (not spellName or spellName == "") then
						spellLink = "|cFF71D5FF[Unknown]|r";
					else
						spellLink = GetSpellLink(v.spellID);
					end
					if (not spellLink or spellLink == "") then
						spellLink = "|cFF71D5FF[" .. spellName .. "]|r";
					end
					local who = "";
					if (NRC.config.mdShowSpellsOther) then
						who = "|cFFAAD372" .. name .. "|r ";
					end
					local msg = spellLink .. "|cFFDEDE42";
					local aoeCount, aoeTotal, aoeCrits = 0, 0, 0;
					if (aoeSpells[v.spellID]) then
						for who, data in ipairs(data) do
							if (v.spellID == data.spellID) then
								countedAoes[v.spellID] = true;
								aoeTotal = aoeTotal + getThreatValue(unit, data.spellID, data.amount);
								aoeCount = aoeCount + 1;
								if (data.critical) then
									aoeCrits = aoeCrits + 1;
								end
							end
						end
						msg = msg .. " " .. aoeTotal .. " |cFFFFFFFF(" .. aoeCount .. " hits)|r";
					else
						msg = msg .. " " .. getThreatValue(unit, v.spellID, v.amount);
					end
					if (aoeCount > 1) then
						if (aoeCrits > 0) then
							msg = msg .. " (" .. aoeCrits .. " " .. L["Crits"] .. ")";
						end
					else
						if (v.critical) then
							msg = msg .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL;
						end
						if (v.blocked) then
							msg = msg .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_BLOCK, v.blocked);
						end
						if (v.absorbed) then
							msg = msg .. " " .. string.format(TEXT_MODE_A_STRING_RESULT_ABSORB, v.absorbed);
						end
						if (v.glancing) then
							msg = msg .. " " .. TEXT_MODE_A_STRING_RESULT_GLANCING;
						end
					end
					if (k == 1) then
						spellsText = spellsText .. msg;
					else
						spellsText = spellsText .. ", " .. msg;
					end
					if ((NRC.config.mdShowSpells and isMe) or NRC.config.mdShowSpellsOther) then
						NRC:print(who .. msg, "[MD]");
					end
					found = true;
					--For wrath we count all hits not just 3.
					if (NRC.isTBC) then
						if (k + aoeCount > 2) then
							--If our reg hits + aoe hits are at 3+ then that's all the md used.
							break;
						end
					end
				end
			end
			if (data.dots and next(data.dots)) then
				--No dots would ever be recorded for TBC.
				local spellLink = "|cFF71D5FF[DoTs]|r";
				local who = "";
				if (NRC.config.mdShowSpellsOther) then
					who = "|cFFAAD372" .. name .. "|r ";
				end
				local msg = spellLink .. "|cFFDEDE42";
				local dotCount, dotTotal, dotCrits = 0, 0, 0;
				for _, data in ipairs(data.dots) do
					dotTotal = dotTotal + getThreatValue(unit, data.spellID, data.amount);
					dotCount = dotCount + 1;
					if (data.critical) then
						dotCrits = dotCrits + 1;
					end
				end
				msg = msg .. " " .. dotTotal .. " |cFFFFFFFF(" .. dotCount .. " hits)|r";
				if (dotCount > 1) then
					if (dotCrits > 0) then
						msg = msg .. " (" .. dotCrits .. " " .. L["Crits"] .. ")";
					end
				else
					if (dotCrits == 1) then
						msg = msg .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL;
					end
				end
				if (not found) then
					spellsText = spellsText .. msg;
				else
					spellsText = spellsText .. ", " .. msg;
				end
				if ((NRC.config.mdShowSpells and isMe) or NRC.config.mdShowSpellsOther) then
					NRC:print(who .. msg, "[MD]");
				end
			end
			if (spellsText ~= "") then
				local t = {
					name = name,
					target = target,
					text = spellsText;
					total = total,
					time = GetServerTime();
				};
				tinsert(lastMD, t);
				--lastMD[name] = spellsText;
			end
			local msg = "[NRC] " .. string.format(L["meTransferedThreatMD"], NRC:commaValue(total), target) .. ".";
			local sent, sentMe;
			if (unitName == UnitName("player") or isMe) then
				if (NRC.config.mdSendMyThreatGroup) then
					if (IsInGroup()) then
						local msg = "[NRC] " .. string.format(L["otherTransferedThreatMD"], name, NRC:commaValue(total), target or "unknown");
						NRC:sendGroup(msg, 0.2);
					else
						sentMe = true;
						NRC:print(string.format(L["meTransferedThreatMD"], "|cFF00C800" .. NRC:commaValue(total) .. "|r", target or "unknown"));
					end
				end
				if (NRC.config.mdShowMySelf and not sentMe) then
					local targetString = target;
					if (data.targetClass) then
						local _, _, _, classHex = GetClassColor(data.targetClass);
						targetString = "|c" .. classHex .. target .. "|r";
					end
					NRC:print(string.format(L["meTransferedThreatMD"], "|cFF00C800" .. NRC:commaValue(total) .. "|r", targetString or "unknown"));
				end
				if (inInstance and NRC.config.mdSendMyThreatSay) then
					SendChatMessage("[NRC] " .. string.format(L["meTransferedThreatMD"], NRC:commaValue(total), target or "unknown"), "SAY");
				end
				if (NRC.config.mdSendTarget) then
					if (destGUID and strfind(destGUID, "Player")) then
						local msg = "[NRC] " .. string.format(L["meTransferedThreatMD"], NRC:commaValue(total), "you") .. ".";
						SendChatMessage(msg, "WHISPER", nil, target);
					end
				end
			else
				if (NRC.config.mdSendOthersThreatGroup) then
					--This can be merged in to only group check after testing new new settings check.
					if (IsInGroup()) then
						local msg = "[NRC] " .. string.format(L["otherTransferedThreatMD"], name, NRC:commaValue(total), target or "unknown");
						--NRC:sendGroup(msg);
						NRC:sendGroupSettingsCheck(msg, "mdSendOthersThreatGroup", "mdSendMyThreatGroup", name);
					else
						sentMe = true;
						NRC:print(string.format(L["otherTransferedThreatMD"], "|cFFAAD372" .. name .. "|r",
								"|cFF00C800" .. NRC:commaValue(total) .. "|r", target or "unknown"))
					end
				end
				if (NRC.config.mdShowOthersSelf and not sentMe) then
					local targetString = target;
					if (data.targetClass) then
						local _, _, _, classHex = GetClassColor(data.targetClass);
						targetString = "|c" .. classHex .. target .. "|r";
					end
					NRC:print(string.format(L["otherTransferedThreatMD"], "|cFFAAD372" .. name .. "|r",
							"|cFF00C800" .. NRC:commaValue(total) .. "|r", targetString or "unknown"))
				end
				if (inInstance and NRC.config.mdSendOthersThreatSay) then
					SendChatMessage("[NRC] " .. string.format(L["otherTransferedThreatMD"], name, NRC:commaValue(total), target or "unknown"), "SAY");
				end
			end
			if (NRC.config.sreShowMisdirection and NRC:sreIsSpellTracked(34477)) then
				NRC:sreMisdirectionEvent(name, target, data.targetClass, total);
			end
		end
	end
	hits[name] = nil;
	if (not next(hits)) then
		--No MD buffs currently up, disable combat log checking.
		misdirection = nil;
	end
end

--This only worked for our md.
--[[local function unitSpellcastSent(...)
	local unit, target, castGUID, spellID = ...;
	if (spellID == 34477 and unit == "player") then
		local spellName = GetSpellInfo(spellID);
		if (not spellName or spellName == "") then
			spellName = "Misdirection";
		end
		local spellLink;
		if (not NRC.isClassic) then
			spellLink = GetSpellLink(spellID)
		end
		local msg = string.format(L["spellCastOn"], spellLink or spellName, target) .. ".";
		if (NRC.config.mdSendMyCastGroup) then
			if (IsInRaid()) then
				SendChatMessage(msg, "RAID");
			elseif (IsInGroup()) then
				SendChatMessage(msg, "PARTY");
			end
		end
		local inInstance = IsInInstance();
		if (inInstance and NRC.config.mdSendMyCastGroup) then
			SendChatMessage(msg, "SAY");
		end
	end
end]]

--Create a md table for this player if it doesn't exist, so both needed events can add their data no matter the event fire order.
--Our 2 needed events don't always fire in same order.
local function misdirectionStarted(name, target, inOurGroup, destGUID)
	if (NRC:isMe(name) or (inOurGroup or NRC:inOurGroup(name))) then
		if (not hits[name]) then
			hits[name] = {
				dots = {},
			};
			misdirection = true;
		end
		if (target) then
			hits[name].target = target;
		end
		if (destGUID) then
			hits[name].destGUID = destGUID;
			local _, classEnglish  = GetPlayerInfoByGUID(destGUID);
			hits[name].targetClass = classEnglish;
		end
	end
end

--We use this event to set the unit for buff checking later, it's more efficient to use this event than scan the group for unit in combat log.
--All this relies on UNIT_SPELLCAST_SUCCEEDED being run before COMBAT_LOG_EVENT_UNFILTERED spell cast, seems this way always so far.
local function unitSpellcastSucceeded(...)
	local unit, castGUID, spellID = ...;
	if (spellID == 34477) then
		if (unit == "player" or (IsInGroup() and (strfind(unit, "party") or strfind(unit, "raid")))) then
			local name, realm = UnitName(unit);
			if (realm and realm ~= "" and realm ~= NRC.realm) then
				--Add realm if not our realm so it matches combat log sourceName.
				name = name .. "-" .. realm;
			end
			misdirectionStarted(name)
			if (hits[name]) then
				hits[name].unit = unit;
				hits[name].unitName = UnitName(unit);
			end
		end
	end
end

local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, spellID, spellName = ...;
	if (subEvent == "SPELL_CAST_SUCCESS") then
		if (spellID == 34477) then
			local inOurGroup = NRC:inOurGroup(sourceName);
			misdirectionStarted(sourceName, destName, inOurGroup, destGUID);
			if (sourceGUID == UnitGUID("player")) then
				local spellName = GetSpellInfo(spellID);
				if (not spellName or spellName == "") then
					spellName = "Misdirection";
				end
				local spellLink;
				if (not NRC.isClassic) then
					spellLink = GetSpellLink(spellID)
				end
				local msg = string.format(L["spellCastOn"], spellLink or spellName, destName) .. ".";
				if (NRC.config.mdSendMyCastGroup) then
					NRC:sendGroup(msg);
				end
				local inInstance = IsInInstance();
				if (inInstance and NRC.config.mdSendMyCastSay) then
					SendChatMessage(msg, "SAY");
				end
			elseif (inOurGroup) then
				local spellLink;
				if (not NRC.isClassic) then
					spellLink = GetSpellLink(spellID)
				end
				local msg = string.format(L["otherCastSpellOn"], sourceName, spellLink or spellName, destName) .. ".";
				if (NRC.config.mdSendOtherCastGroup) then
					--Send via group settings check to eliminate duplicate spam.
					NRC:sendGroupSettingsCheck(msg, "mdSendOtherCastGroup", "mdSendMyCastGroup", sourceName);
				end
			end
		elseif (spellID == 20736) then
			if (sourceGUID == UnitGUID("player")) then
				local inInstance = IsInInstance();
				if (not inInstance) then
					return;
				end
				local target = destName;
				if (not target or target == "") then
					target = "Unknown";
				end
				local spellLink;
				if (not NRC.isClassic) then
					spellLink = GetSpellLink(spellID);
				end
				local msg = (spellLink or spellName) .. " on " .. target .. " (6 seconds).";
				if (NRC.config.hunterDistractingShotGroup) then
					NRC:sendGroup(msg);
				end
				if (NRC.config.hunterDistractingShotYell) then
					SendChatMessage(msg, "YELL");
				elseif (NRC.config.hunterDistractingShotSay) then
					SendChatMessage(msg, "SAY");
				end
			end
		elseif (misdirection and hits[sourceName] and distractingShot[spellID]) then
			local tableID = #hits[sourceName] + 1;
			--Distracting shot has no dmg.
			hits[sourceName][tableID] = {
				spellID = spellID,
				spellName = spellName,
				amount = distractingShot[spellID],
				destName = destName,
			};
			if (NRC.isTBC and tableID >= 3) then
				tallyMisdirection(sourceName);
			end
		end
	--Only run checks when a md is active for efficiency.
	elseif (misdirection and hits[sourceName] and strfind(sourceGUID, "Player")) then
		if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
			if (subEvent == "SPELL_PERIODIC_DAMAGE" and NRC.isTBC) then
				--No dot md dmg for bc.
				return;
			end
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
			if (subEvent == "SWING_DAMAGE") then
				amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...);
				spellID = 0;
				spellName = "Melee";
			elseif (subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
				spellID, spellName, school, amount, overkill, school, resisted, blocked, absorbed, critical,
						glancing, crushing, isOffHand = select(12, ...);
			end
			--If it's an aoe spell like sapper then keep counting and wait for misdirect to fall off before calcing.
			--Otherwise we're counting dmg hits and calc after 3 are recorded.
			local tableID = #hits[sourceName] + 1;
			if (NRC.isTBC and aoeSpells[spellID]) then
				--Exceed the 3 hit cap if it's an aoe spell (for wrath we just record all hits within the 4 second buff).
				--Player may do 2 regular hits and then a multi shot, bombs etc.
				--Aura faded timer will do the calc in this case.
				local lastTableID = tableID - 1;
				local lastAoe;
				--If we're past 3 hits and it's not the same aoe spellID as last.
				--Then this might be the 0.5 second gap between waiting for aoe and doing the calc so we need to ignore this damaage.
				if (tableID < 3 and hits[sourceName] and hits[sourceName][lastTableID] and hits[sourceName][lastTableID].aoe) then
					lastAoe = hits[sourceName][lastTableID].aoe;
				end
				if (not lastAoe or spellID == lastAoe) then
					hits[sourceName][tableID] = {
						spellID = spellID,
						spellName = spellName,
						amount = amount,
						destName = destName,
					};
					if (critical) then
						hits[sourceName][tableID].critical = true;
					end
					if (blocked) then
						hits[sourceName][tableID].blocked = blocked;
					end
					if (absorbed) then
						hits[sourceName][tableID].absorbed = absorbed;
					end
					if (glancing) then
						hits[sourceName][tableID].glancing = glancing;
					end
					--If this is the 3rd hit and it's aoe then add a flag so we don't record any other type of dmg while we wait for calculation timer.
					if (#hits[sourceName] > 2) then
						hits[sourceName][tableID].aoe = spellID;
					end
				end
			elseif ((tableID < 4 or not NRC.isTBC) and amount and amount > 0) then
				if (subEvent == "SPELL_PERIODIC_DAMAGE" and not ignoredDots[spellID]) then
					--This will never trigger in TBC.
					local tableID = #hits[sourceName].dots + 1;
					hits[sourceName].dots[tableID] = {
						spellID = spellID,
						spellName = spellName,
						amount = amount,
						destName = destName,
					};
					if (critical) then
						hits[sourceName].dots[tableID].critical = true;
					end
					if (blocked) then
						hits[sourceName].dots[tableID].blocked = blocked;
					end
					if (absorbed) then
						hits[sourceName].dots[tableID].absorbed = absorbed;
					end
					if (glancing) then
						hits[sourceName].dots[tableID].glancing = glancing;
					end
				else
					--Use 3 swings if it's normal dmg (if TBC).
					hits[sourceName][tableID] = {
						spellID = spellID,
						spellName = spellName,
						amount = amount,
						destName = destName,
					};
					if (critical) then
						hits[sourceName][tableID].critical = true;
					end
					if (blocked) then
						hits[sourceName][tableID].blocked = blocked;
					end
					if (absorbed) then
						hits[sourceName][tableID].absorbed = absorbed;
					end
					if (glancing) then
						hits[sourceName][tableID].glancing = glancing;
					end
					if (NRC.isTBC and tableID >= 3) then
						tallyMisdirection(sourceName);
					end
				end
			end
		end
		if (subEvent == "SPELL_AURA_REMOVED") then
			--If misdirection was still up and has now faded then do the calc.
			--This will only fire here if md times out or we're using an aoeSpell like sapper and not checking the 3 hit count.
			if (spellID == 34477) then
				if (NRC.isWrath) then
					--If it fades without being used run the calc but leave enough time incase it faded from proper use.
					C_Timer.After(6, function()
						if (hits[sourceName]) then
							tallyMisdirection(sourceName);
						end
					end)
				elseif (NRC.isTBC) then
					if (hits[sourceName]) then
						--Create a ticking timer to wait for 3 hits to be filled.
						--Sometimes aura can drop off before the 3rd hit registers, specially with long range travel time.
						--If no 3rd hit by timer end then assume it was aoe dmg like an engi bomb and do the calc.
						hits[sourceName].calcTimerTicks = 0;
						hits[sourceName].calcTimer = C_Timer.NewTicker(0.3, function()
							local data = hits[sourceName];
							if (data) then
								hits[sourceName].calcTimerTicks = hits[sourceName].calcTimerTicks + 1;
								if (hits[sourceName] and #hits[sourceName] > 2) then
									hits[sourceName].calcTimer:Cancel();
									tallyMisdirection(sourceName);
								elseif (hits[sourceName].calcTimerTicks >= 10) then
									tallyMisdirection(sourceName);
								end
							end
						end, 10);
					end
				end
			elseif (spellID == 35079) then
				--NRC:debug("MD calc from 4 second buff", sourceName);
				--If it's wrath then we calc after the 4 second duration is up.
				if (not NRC.isTBC) then
					if (hits[sourceName]) then
						tallyMisdirection(sourceName);
					end
				end
			end
		end
	end
	if (subEvent == "SPELL_AURA_APPLIED") then
		if (spellID == 35079 and not NRC.isTBC) then
			if (hits[sourceName]) then
				--If wrath and the 4 second md buff is gained by a hunter.
				--Create a 5 second timer as a backup incase target goes out of range and we don't see the 4 second md buff drop.
				--The calc will do nothing it was already calced 1 second earlier.
				C_Timer.After(5, function()
					if (hits[sourceName]) then
						NRC:debug("MD calc from 4 second buff", sourceName);
						tallyMisdirection(sourceName);
					end
				end)
			end
		end
	end
end

function NRC:parseMdCommand(msg)
	if (msg and string.lower(msg) == "list") then
		local t = {};
		NRC:print("Last MD list:");
		for k, v in ipairs(lastMD) do
			t[v.name] = v.total;
		end
		if (next(t)) then
			for k, v in NRC:pairsByKeys(t) do
				print("|cFFAAD372" .. k .. "|r", "|cFFDEDE42" .. v);
			end
		else
			print("None recorded yet.");
		end
	else
		local last, text;
		if (msg and msg ~= "") then
			for k, v in ipairs(lastMD) do
				if (string.lower(msg) == string.lower(v.name)) then
					last = v;
				end
			end
		else
			for k, v in ipairs(lastMD) do
				last = v;
			end
		end
		if (last) then
			text = "(" .. NRC:commaValue(last.total) .. ") " .. last.name .. " last MD: " .. last.text;
		end
		if (text) then
			if (IsInRaid()) then
				SendChatMessage(NRC:stripColors(text), "RAID");
			elseif (IsInGroup()) then
				SendChatMessage(NRC:stripColors(text), "PARTY");
			else
				NRC:print(text)
			end
		else
			if (msg and msg ~= "") then
				print("No last misdirection data found for player " .. msg .. ".");
			else
				print("No last misdirection data found.");
			end
		end
	end
end

SLASH_LASTMDCMD1, SLASH_LASTMDCMD2, SLASH_LASTMDCMD3, SLASH_LASTMDCMD4 = '/lastmd', 'lastmds', '/mdlast', 'mdslast';
function SlashCmdList.LASTMDCMD(msg, editBox)
	NRC:parseMdCommand(msg);
end

local f = CreateFrame("Frame");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(CombatLogGetCurrentEventInfo());
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		unitSpellcastSucceeded(...);
	end
end)

--MD tracking can be used by any class so we load everything before here for any class, functions before here are for md only.
if (NRC.class ~= "HUNTER") then
	return;
end

function NRC:getAmmoCount()
	local slotID = GetInventorySlotInfo("AmmoSlot");
	if (slotID) then
		local itemID = GetInventoryItemID("player", slotID);
		if (itemID) then
			local ammoCount = GetItemCount(itemID);
			if (ammoCount) then
				return ammoCount, itemID;
			end
		end
	end
	return;
end

local lastAmmoWarning = 0;
function NRC:checkAmmo()
	if (NRC.config.lowAmmoCheck) then
		local ammoCount, ammoID = NRC:getAmmoCount();
		if (ammoCount and ammoCount < NRC.config.lowAmmoCheckThreshold) then
			if (GetTime() - lastAmmoWarning > 900) then
				local ammo = ammoCount .. " left";
				if (ammoID) then
					local _, itemLink = GetItemInfo(ammoID);
					if (itemLink) then
						ammo = itemLink .. "|cFFFFFFFF " .. ammoCount .. "|r";
					end
				end
				lastAmmoWarning = GetTime();
				NRC:sendWarning(string.format(L["lowAmmoWarning"], ammo));
			end
		end
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("BAG_UPDATE");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "BAG_UPDATE" or event == "PLAYER_ENTERING_WORLD") then
		if (NRC.config.lowAmmoCheck) then
			NRC:throddleEventByFunc(event, 15, "checkAmmo", ...);
		end
	end
end)