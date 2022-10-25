------------------------------
---NovaRaidCompanion Classes--
------------------------------

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
if (NRC.isTBC or NRC.isClassic) then
	return;
end
local _, class = UnitClass("player");
local playerGUID = NRC.playerGUID;
local tricks, lastTricks, damage;
local hits, lastTricks, hitsDamage = {}, {}, {};
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local UnitGUID = UnitGUID;
local strfind = strfind;

local aoeSpells = {
	[13241] = "Goblin Sapper Charge",
	[30486] = "Super Sapper Charge",
	[56488] = "Global Thermal Sapper Charge";
	[56350] = "Saronite Bomb";
};

local ignoredDots = {
	--Ignore grouping certain periodic effects as dots and count them seperately.
};

local poisons = {
	--These are the spell damage IDs, not the coating a weapon spellID.
	[26688] = "Anesthetic Poison",
	[57981] = "Anesthetic Poison II",
	[2818] = "Deadly Poison",
	[2819] = "Deadly Poison II",
	[11353]= "Deadly Poison III",
	[11354] = "Deadly Poison IV",
	[25349] = "Deadly Poison V",
	[26968] = "Deadly Poison VI",
	[27187] = "Deadly Poison VII",
	[57969] = "Deadly Poison VIII",
	[57970] = "Deadly Poison IX",
	[8680] = "Instant Poison",
	[8685] = "Instant Poison II",
	[8689] = "Instant Poison III",
	[11335] = "Instant Poison IV",
	[11336] = "Instant Poison V",
	[11337] = "Instant Poison VI",
	[26890] = "Instant Poison VII",
	[57964] = "Instant Poison VIII",
	[57965]= "Instant Poison IX",
	[13218] = "Wound Poison",
	[13222] = "Wound Poison II",
	[13223] = "Wound Poison III",
	[13224] = "Wound Poison IV",
	[27189] = "Wound Poison V",
	[57974] = "Wound Poison VI",
	[57975] = "Wound Poison VII",
}

local function getThreatValue(unit, spellID, amount)
	local value = amount;
	return math.floor(value);
end

local function tallyTricks(name)
	if (not tricks or not next(hits[name])) then
		--We may have done this calc already if we're not waiting for aoe dmg.
		--Or tricks faded with no dmg.
		hits[name] = nil;
		if (not next(hits)) then
			tricks = nil;
		end
		return;
	end
	local inInstance = IsInInstance();
	local total = 0;
	local data = hits[name];
	--This is done a bit different from misdirection.
	--Check it was cast within last 12 seconds (10 secs glyphyed, allow 3 secs for lag) incase they go out of range and we don't see aura removed.
	--It would just overwrite itself in this case for next cast.
	if (not data.startTime or (GetTime() - data.startTime > 13)) then
		if (not data.startTime) then
			NRC:debug("Tricks startTime missing.", name);
		else
			NRC:debug("Tricks calced outside of 13 seconds since cast.", name);
		end
		return;
	end
	--NRC:debug("Tricks calced after", GetTime() - data.startTime, "seconds.", name);
	local unit = data.unit;
	local isMe;
	if (unit and UnitIsUnit(unit, "player")) then
		isMe = true;
	end
	if (not unit) then
		NRC:debug("No unit attached to tricks calc.");
		hits[name] = nil;
		if (not next(hits)) then
			--No tricks buffs currently up, disable combat log checking.
			tricks = nil;
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
	if (data.melee) then
		for k, v in ipairs(data.melee) do
			total = total + getThreatValue(unit, v.spellID, v.amount);
		end
	end
	if (data.poison) then
		for k, v in ipairs(data.poison) do
			total = total + getThreatValue(unit, v.spellID, v.amount);
		end
	end
	local countedAoes = {};
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
				if (NRC.config.tricksShowSpellsOther) then
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
				if ((NRC.config.tricksShowSpells and isMe) or NRC.config.tricksShowSpellsOther) then
					NRC:print(who .. msg, "[Tricks]");
				end
				found = true;
				--For wrath we count all hits not just 3.
				if (NRC.isTBC) then
					if (k + aoeCount > 2) then
						--If our reg hits + aoe hits are at 3+ then that's all the tricks used.
						break;
					end
				end
			end
		end
		if (data.dots and next(data.dots)) then
			--No dots would ever be recorded for TBC.
			local spellLink = "|cFF71D5FF[DoTs]|r";
			local who = "";
			if (NRC.config.tricksShowSpellsOther) then
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
			if ((NRC.config.tricksShowSpells and isMe) or NRC.config.tricksShowSpellsOther) then
				NRC:print(who .. msg, "[Tricks]");
			end
		end
		if (data.melee and next(data.melee)) then
			local spellLink = "|cFF71D5FF[Melee Swings]|r";
			local who = "";
			if (NRC.config.tricksShowSpellsOther) then
				who = "|cFFAAD372" .. name .. "|r ";
			end
			local msg = spellLink .. "|cFFDEDE42";
			local meleeCount, meleeTotal, meleeCrits = 0, 0, 0;
			for _, data in ipairs(data.melee) do
				meleeTotal = meleeTotal + getThreatValue(unit, data.spellID, data.amount);
				meleeCount = meleeCount + 1;
				if (data.critical) then
					meleeCrits = meleeCrits + 1;
				end
			end
			msg = msg .. " " .. meleeTotal .. " |cFFFFFFFF(" .. meleeCount .. " hits)|r";
			if (meleeCount > 1) then
				if (meleeCrits > 0) then
					msg = msg .. " (" .. meleeCrits .. " " .. L["Crits"] .. ")";
				end
			else
				if (meleeCrits == 1) then
					msg = msg .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL;
				end
			end
			if (not found) then
				spellsText = spellsText .. msg;
			else
				spellsText = spellsText .. ", " .. msg;
			end
			if ((NRC.config.tricksShowSpells and isMe) or NRC.config.tricksShowSpellsOther) then
				NRC:print(who .. msg, "[Tricks]");
			end
		end
		if (data.poison and next(data.poison)) then
			local spellLink = "|cFF71D5FF[Poisons]|r";
			local who = "";
			if (NRC.config.tricksShowSpellsOther) then
				who = "|cFFAAD372" .. name .. "|r ";
			end
			local msg = spellLink .. "|cFFDEDE42";
			local poisonCount, poisonTotal, poisonCrits = 0, 0, 0;
			for _, data in ipairs(data.poison) do
				poisonTotal = poisonTotal + getThreatValue(unit, data.spellID, data.amount);
				poisonCount = poisonCount + 1;
				if (data.critical) then
					poisonCrits = poisonCrits + 1;
				end
			end
			msg = msg .. " " .. poisonTotal .. " |cFFFFFFFF(" .. poisonCount .. " hits)|r";
			if (poisonCount > 1) then
				if (poisonCrits > 0) then
					msg = msg .. " (" .. poisonCrits .. " " .. L["Crits"] .. ")";
				end
			else
				if (poisonCrits == 1) then
					msg = msg .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL;
				end
			end
			if (not found) then
				spellsText = spellsText .. msg;
			else
				spellsText = spellsText .. ", " .. msg;
			end
			if ((NRC.config.tricksShowSpells and isMe) or NRC.config.tricksShowSpellsOther) then
				NRC:print(who .. msg, "[Tricks]");
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
			tinsert(lastTricks, t);
			--lastTricks[name] = spellsText;
		end
		local msg = "[NRC] " .. string.format(L["meTransferedThreatTricks"], NRC:commaValue(total), target) .. ".";
		local sent, sentMe;
		if (unitName == UnitName("player") or isMe) then
			if (NRC.config.tricksSendMyThreatGroup) then
				if (IsInGroup()) then
					local msg = "[NRC] " .. string.format(L["otherTransferedThreatTricks"], name, NRC:commaValue(total), target or "unknown");
					NRC:sendGroup(msg, 0.2);
				else
					sentMe = true;
					NRC:print(string.format(L["meTransferedThreatTricks"], "|cFF00C800" .. NRC:commaValue(total) .. "|r", target or "unknown"));
				end
			end
			if (NRC.config.tricksShowMySelf and not sentMe) then
				local targetString = target;
				if (data.targetClass) then
					local _, _, _, classHex = GetClassColor(data.targetClass);
					targetString = "|c" .. classHex .. target .. "|r";
				end
				NRC:print(string.format(L["meTransferedThreatTricks"], "|cFF00C800" .. NRC:commaValue(total) .. "|r", targetString or "unknown"));
			end
			if (inInstance and NRC.config.tricksSendMyThreatSay) then
				SendChatMessage("[NRC] " .. string.format(L["meTransferedThreatTricks"], NRC:commaValue(total), target or "unknown"), "SAY");
			end
			if (NRC.config.tricksSendTarget) then
				if (destGUID and strfind(destGUID, "Player")) then
					local msg = "[NRC] " .. string.format(L["meTransferedThreatTricks"], NRC:commaValue(total), "you") .. ".";
					SendChatMessage(msg, "WHISPER", nil, target);
				end
			end
		else
			if (NRC.config.tricksSendOthersThreatGroup) then
				--This can be merged in to only group check after testing new new settings check.
				if (IsInGroup()) then
					local msg = "[NRC] " .. string.format(L["otherTransferedThreatTricks"], name, NRC:commaValue(total), target or "unknown");
					--NRC:sendGroup(msg);
					NRC:sendGroupSettingsCheck(msg, "tricksSendOthersThreatGroup", "tricksSendMyThreatGroup", name);
				else
					sentMe = true;
					NRC:print(string.format(L["otherTransferedThreatTricks"], "|cFFAAD372" .. name .. "|r",
							"|cFF00C800" .. NRC:commaValue(total) .. "|r", target or "unknown"))
				end
			end
			if (NRC.config.tricksShowOthersSelf and not sentMe) then
				local targetString = target;
				if (data.targetClass) then
					local _, _, _, classHex = GetClassColor(data.targetClass);
					targetString = "|c" .. classHex .. target .. "|r";
				end
				NRC:print(string.format(L["otherTransferedThreatTricks"], "|cFFAAD372" .. name .. "|r",
						"|cFF00C800" .. NRC:commaValue(total) .. "|r", targetString or "unknown"))
			end
			if (inInstance and NRC.config.tricksSendOthersThreatSay) then
				SendChatMessage("[NRC] " .. string.format(L["otherTransferedThreatTricks"], name, NRC:commaValue(total), target or "unknown"), "SAY");
			end
		end
		if (NRC.config.sreShowMisdirection and NRC:sreIsSpellTracked(34477)) then
			NRC:sreTricksEvent(name, target, data.targetClass, total);
		end
	end
	hits[name] = nil;
	if (not next(hits)) then
		--No tricks buffs currently up, disable combat log checking.
		tricks = nil;
	end
end

local function cancelTricks(name)
	hits[name] = nil;
	if (not next(hits)) then
		--No tricks buffs currently up, disable combat log checking.
		tricks = nil;
	end
end

local function tallyDamage(name)
	if (not next(hitsDamage[name])) then
		NRC:debug("Name not found in hitsDamage for tricks calc");
		--We may have done this calc already if we're not waiting for aoe dmg.
		--Or tricks faded with no dmg.
		hitsDamage[name] = nil;
		if (not next(hitsDamage)) then
			damage = nil;
		end
		return;
	end
	local inInstance = IsInInstance();
	local total = 0;
	local data = hitsDamage[name];
	if (not data.startTime or (GetTime() - data.startTime > 13)) then
		if (not data.startTime) then
			NRC:debug("Tricks damage startTime missing.", name);
		else
			NRC:debug("Tricks damage calced outside of 13 seconds since cast.", name);
		end
		return;
	end
	local source = data.source;
	local target = data.target;
	local targetGUID = data.targetGUID;
	local targetMe;
	if (target == UnitName("player")) then
		targetMe = true;
	end
	local sourceMe;
	if (source == UnitName("player")) then
		sourceMe = true;
	end
	--NRC:debug("Tricks damage calced after", GetTime() - data.startTime, "seconds.", name, source, target, sourceMe, targetMe);
	for k, v in ipairs(data) do
		local base = v.amount / 1.15;
		total = total + v.amount - base;
	end
	if (data.dots) then
		for k, v in ipairs(data.dots) do
			local base = v.amount / 1.15;
			total = total + v.amount - base;
		end
	end
	total = math.floor(total);
	local countedAoes = {};
	if (not NRC.config.tricksOnlyWhenDamage or total > 0) then
		local sent, sentMe, sentOtherGroup, printOther;
		if (NRC.config.tricksSendDamageGroup and sourceMe) then
			--Send my tricks damage given to group.
			if (IsInGroup()) then
				local msg = "[NRC] " .. string.format(L["otherTransferedDamageMyTricks"], name, NRC:commaValue(total));
				NRC:sendGroup(msg, 0.5);
			else
				local targetString = target;
				if (data.targetClass) then
					local _, _, _, classHex = GetClassColor(data.targetClass);
					targetString = "|c" .. classHex .. target .. "|r";
				end
				C_Timer.After(1, function()
					NRC:print(string.format(L["otherTransferedDamageMyTricks"], targetString, "|cFF00C800" .. NRC:commaValue(total) .. "|r"));
				end)
			end
			sentMe = true;
		end
		if (NRC.config.tricksSendDamagePrint and sourceMe and not sentMe) then
			local targetString = target;
			if (data.targetClass) then
				local _, _, _, classHex = GetClassColor(data.targetClass);
				targetString = "|c" .. classHex .. target .. "|r";
			end
			C_Timer.After(1, function()
				NRC:print(string.format(L["otherTransferedDamageMyTricks"], targetString, "|cFF00C800" .. NRC:commaValue(total) .. "|r"));
			end)
		end
		if (NRC.config.tricksSendDamageGroupOther and not sourceMe) then
			if (IsInGroup()) then
				local msg = "[NRC] " .. string.format(L["otherTransferedDamageOtherTricks"], target, NRC:commaValue(total), source);
				--NRC:sendGroup(msg, 1);
				C_Timer.After(0.5, function()
					NRC:sendGroupSettingsCheck(msg, "tricksSendDamageGroupOther", "tricksSendDamageGroup", source);
				end)
			else
				local targetString = target;
				if (data.targetClass) then
					local _, _, _, classHex = GetClassColor(data.targetClass);
					targetString = "|c" .. classHex .. target .. "|r";
				end
				C_Timer.After(1, function()
					NRC:print(string.format(L["otherTransferedDamageOtherTricks"], targetString, "|cFF00C800" .. NRC:commaValue(total) .. "|r", "|cFFFFF468" .. source .. "|r"));
				end)
			end
			sentOtherGroup = true;
		end
		if (NRC.config.tricksSendDamagePrintOther and not sourceMe and not sentOtherGroup) then
			printOther = true;
			local targetString = target;
			if (data.targetClass) then
				local _, _, _, classHex = GetClassColor(data.targetClass);
				targetString = "|c" .. classHex .. target .. "|r";
			end
			C_Timer.After(1, function()
				NRC:print(string.format(L["otherTransferedDamageOtherTricks"], targetString, "|cFF00C800" .. NRC:commaValue(total) .. "|r", "|cFFFFF468" .. source .. "|r"));
			end)
		end
		if (NRC.config.tricksSendDamageWhisper and sourceMe) then
			if (targetGUID and strfind(targetGUID, "Player")) then
				local msg = "[NRC] " .. string.format(L["meTransferedThreatTricksWhisper"], NRC:commaValue(total));
				SendChatMessage(msg, "WHISPER", nil, target);
			end
		end
		if (NRC.config.tricksOtherRoguesMineGained and targetMe and not sentOtherGroup and not printOther) then
			--Show how much damage other rogues gave to me.
			NRC:print(string.format(L["otherTransferedDamageTricksMine"], "|cFF00C800" .. NRC:commaValue(total) .. "|r", "|cFFFFF468" .. source .. "|r"));
		end
	end
	hitsDamage[name] = nil;
	if (not next(hitsDamage)) then
		--No tricks buffs currently up, disable combat log checking.
		damage = nil;
	end
end

local function cancelDamage(name)
	NRC:debug("Cancelled ticks damage calc", name);
	hitsDamage[name] = nil;
	if (not next(hitsDamage)) then
		--No tricks buffs currently up, disable combat log checking.
		damage = nil;
	end
end

--Create a tricks table for this player if it doesn't exist, so both needed events can add their data no matter the event fire order.
--Our 2 needed events don't always fire in same order.
local function tricksStarted(name, target, inOurGroup, destGUID)
	if (NRC:isMe(name) or (inOurGroup or NRC:inOurGroup(name))) then
		if (not hits[name]) then
			hits[name] = {
				dots = {},
				melee = {},
				poison = {},
			};
			tricks = true;
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

local function damageStarted(source, target, targetGUID, inOurGroup)
	if (NRC:isMe(target) or (inOurGroup or NRC:inOurGroup(target))) then
		if (targetGUID) then
			local _, classEnglish  = GetPlayerInfoByGUID(targetGUID);
			hitsDamage[target] = {
				dots = {},
				source = source,
				target = target,
				targetGUID = targetGUID,
				targetClass = classEnglish;
				startTime = GetTime(),
			};
			damage = true;
		end
	end
end

--We use this event to set the unit for buff checking later, it's more efficient to use this event than scan the group for unit in combat log.
--All this relies on UNIT_SPELLCAST_SUCCEEDED being run before COMBAT_LOG_EVENT_UNFILTERED spell cast, seems this way always so far.
local function unitSpellcastSucceeded(...)
	local unit, castGUID, spellID = ...;
	if (spellID == 57934) then
		if (unit == "player" or (IsInGroup() and (strfind(unit, "party") or strfind(unit, "raid")))) then
			local name, realm = UnitName(unit);
			if (realm and realm ~= "" and realm ~= NRC.realm) then
				--Add realm if not our realm so it matches combat log sourceName.
				name = name .. "-" .. realm;
			end
			tricksStarted(name)
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
	if (tricks) then
		--Only run checks when a tricks is active for efficiency.
		if (hits[sourceName] and strfind(sourceGUID, "Player")) then
			if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (subEvent == "SWING_DAMAGE") then
					amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...);
					spellID = 0;
					spellName = "Melee";
				elseif (subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
					spellID, spellName, school, amount, overkill, school, resisted, blocked, absorbed, critical,
							glancing, crushing, isOffHand = select(12, ...);
				end
				local tableID = #hits[sourceName] + 1;
				if (amount and amount > 0) then
					if (subEvent == "SPELL_PERIODIC_DAMAGE" and not ignoredDots[spellID] and not poisons[spellID]) then
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
					elseif (subEvent == "SWING_DAMAGE") then
						local tableID = #hits[sourceName].melee + 1;
						hits[sourceName].melee[tableID] = {
							spellID = spellID,
							spellName = spellName,
							amount = amount,
							destName = destName,
						};
						if (critical) then
							hits[sourceName].melee[tableID].critical = true;
						end
						if (blocked) then
							hits[sourceName].melee[tableID].blocked = blocked;
						end
						if (absorbed) then
							hits[sourceName].melee[tableID].absorbed = absorbed;
						end
						if (glancing) then
							hits[sourceName].melee[tableID].glancing = glancing;
						end
					elseif (poisons[spellID]) then
						local tableID = #hits[sourceName].poison + 1;
						hits[sourceName].poison[tableID] = {
							spellID = spellID,
							spellName = spellName,
							amount = amount,
							destName = destName,
						};
						if (critical) then
							hits[sourceName].poison[tableID].critical = true;
						end
						if (blocked) then
							hits[sourceName].poison[tableID].blocked = blocked;
						end
						if (absorbed) then
							hits[sourceName].poison[tableID].absorbed = absorbed;
						end
						if (glancing) then
							hits[sourceName].poison[tableID].glancing = glancing;
						end
					else
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
					end
					if (tableID > 500) then
						--Safeguard incase it ever keeps recording because the end of tricks wasn't detected.
						cancelTricks(sourceName);
					end
				end
			end
		end
	end
	if (damage) then
		if (hitsDamage[sourceName] and strfind(sourceGUID, "Player")) then
			if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (subEvent == "SWING_DAMAGE") then
					amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...);
					spellID = 0;
					spellName = "Melee";
				elseif (subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE") then
					spellID, spellName, school, amount, overkill, school, resisted, blocked, absorbed, critical,
							glancing, crushing, isOffHand = select(12, ...);
				end
				local tableID = #hitsDamage[sourceName] + 1;
				if (amount and amount > 0) then
					if (subEvent == "SPELL_PERIODIC_DAMAGE" and not ignoredDots[spellID]) then
						--This will never trigger in TBC.
						local tableID = #hitsDamage[sourceName].dots + 1;
						hitsDamage[sourceName].dots[tableID] = {
							spellID = spellID,
							spellName = spellName,
							amount = amount,
							destName = destName,
						};
						if (critical) then
							hitsDamage[sourceName].dots[tableID].critical = true;
						end
						if (blocked) then
							hitsDamage[sourceName].dots[tableID].blocked = blocked;
						end
						if (absorbed) then
							hitsDamage[sourceName].dots[tableID].absorbed = absorbed;
						end
						if (glancing) then
							hitsDamage[sourceName].dots[tableID].glancing = glancing;
						end
					else
						hitsDamage[sourceName][tableID] = {
							spellID = spellID,
							spellName = spellName,
							amount = amount,
							destName = destName,
						};
						if (critical) then
							hitsDamage[sourceName][tableID].critical = true;
						end
						if (blocked) then
							hitsDamage[sourceName][tableID].blocked = blocked;
						end
						if (absorbed) then
							hitsDamage[sourceName][tableID].absorbed = absorbed;
						end
						if (glancing) then
							hitsDamage[sourceName][tableID].glancing = glancing;
						end
					end
					if (tableID > 500) then
						--Safeguard incase it ever keeps recording because the end of tricks wasn't detected.
						cancelDamage(sourceName);
					end
				end
			end
		end
	end
	if (subEvent == "SPELL_CAST_SUCCESS") then
		if (spellID == 57934) then
			local inOurGroup = NRC:inOurGroup(sourceName);
			tricksStarted(sourceName, destName, inOurGroup, destGUID);
			if (sourceGUID == UnitGUID("player")) then
				local spellName = GetSpellInfo(spellID);
				if ((not LOCALE_koKR and not LOCALE_zhCN and not LOCALE_zhTW and not LOCALE_ruRU)
   		 				or (not spellName or spellName == "")) then
					spellName = L["Tricks"];
				end
				local spellLink;
				if (not NRC.isClassic) then
					spellLink = GetSpellLink(spellID)
				end
				local msg = string.format(L["spellCastOn"], spellLink or spellName, destName) .. ".";
				if (NRC.config.tricksSendMyCastGroup) then
					NRC:sendGroup(msg);
				end
				local inInstance = IsInInstance();
				if (inInstance and NRC.config.tricksSendMyCastGroup) then
					SendChatMessage(msg, "SAY");
				end
			elseif (inOurGroup) then
				local spellLink;
				if (not NRC.isClassic) then
					spellLink = GetSpellLink(spellID)
				end
				local msg = string.format(L["otherCastSpellOn"], sourceName, spellLink or spellName, destName) .. ".";
				if (NRC.config.tricksSendOtherCastGroup) then
					--Send via group settings check to eliminate duplicate spam.
					NRC:sendGroupSettingsCheck(msg, "tricksSendOtherCastGroup", "tricksSendMyCastGroup", sourceName);
				end
			end
		end
	elseif (subEvent == "SPELL_AURA_REMOVED") then
		--If tricks was up and has now faded then do the calc.
		--59628 is spellID for buff the rogue gets on first hit.
		--But I think there will be cancel threat macros.
		--Maybe don't show threat if they cancel early?
		if (spellID == 59628) then
			--NRC:debug("Tricks threat calc from rogue buff removed", sourceName);
			--If it's wrath then we calc after the 4 second duration is up.
			if (hits[sourceName]) then
				tallyTricks(sourceName);
			end
		end
		--57933 spellID for buff the target gets, here we calc how much dmg we boosted them by.
		if (spellID == 57933) then
			--NRC:debug("Tricks damage calc from target buff removed", destName);
			--If it's wrath then we calc after the 4 second duration is up.
			if (hitsDamage[destName]) then
				tallyDamage(destName);
			end
		end
	elseif (subEvent == "SPELL_AURA_APPLIED") then
		--[[if (spellID == 35079 and not NRC.isTBC) then
			if (hits[sourceName]) then
				--If tricks buff isn't seen ending within 12 seconds then wipe the data.
				--They must have gone out of range.
				C_Timer.After(12, function()
					if (hits[sourceName]) then
						NRC:debug("Didn't see tricks buff fade", sourceName);
						wipeTricks(sourceName);
					end
				end)
			end
		end]]
		if (spellID == 59628) then
			if (hits[sourceName]) then
				hits[sourceName].startTime = GetTime();
			end
		end
		--Start recording damage from tricks target.
		if (spellID == 57933) then
			damageStarted(sourceName, destName, destGUID);
			if (NRC.config.tricksShowMiddleIcon and destName == UnitName("player")) then
				--Unfinished stuff.
				NRC:startMiddleIcon(236283, 1.5, nil, "15% Damage Started");
			end
		end
	end
end

function NRC:parseTricksCommand(msg)
	if (msg and string.lower(msg) == "list") then
		local t = {};
		NRC:print("Last tricks list:");
		for k, v in ipairs(lastTricks) do
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
			for k, v in ipairs(lastTricks) do
				if (string.lower(msg) == string.lower(v.name)) then
					last = v;
				end
			end
		else
			for k, v in ipairs(lastTricks) do
				last = v;
			end
		end
		if (last) then
			text = "(" .. NRC:commaValue(last.total) .. ") " .. last.name .. " last tricks: " .. last.text;
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
				print("No last tricks data found for player " .. msg .. ".");
			else
				print("No last tricks data found.");
			end
		end
	end
end

SLASH_LASTTOTCMD1, SLASH_LASTTOTCMD2, SLASH_LASTTOTCMD3, SLASH_LASTTOTCMD4 = '/lasttricks', 'lasttrick', '/trickslast', 'tricklast';
function SlashCmdList.LASTTOTCMD(msg, editBox)
	NRC:parseTricksCommand(msg);
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

--Tricks tracking can be used by any class so we load everything before here for any class, functions before here are for tricks only.
--if (NRC.class ~= "ROGUE") then
--	return;
--end