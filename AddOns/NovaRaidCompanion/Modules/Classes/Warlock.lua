------------------------------
---NovaRaidCompanion Classes--
------------------------------

local addonName, NRC = ...;
if (NRC.class ~= "WARLOCK") then
	return;
end
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
local _, class = UnitClass("player");
local targetCurse, focusCurse = {}, {};
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local UnitGUID = UnitGUID;
local IsInInstance = IsInInstance;
local curses = {
	--[[[27218] = {
		name = "Curse of Agony",
		icon = 136139,
	},]]
	[27228] = {
		name = "Curse of the Elements",
		icon = 136130,
	},
	[47865] = {
		name = "Curse of the Elements",
		icon = 136130,
	},
	[1490] = { --Cata reverts back to rank 1 only.
		name = "Curse of the Elements",
		icon = 136130,
	},
	[27226] = { --Removed in wrath.
		name = "Curse of Recklessness",
		icon = 136225,
	},
	[11719] = {
		name = "Curse of Tongues",
		icon = 136140,
	},
	[30909] = {
		name = "Curse of Weakness",
		icon = 136138,
	},
	[50511] = {
		name = "Curse of Weakness",
		icon = 136138,
	},
	[30910] = {
		name = "Curse of Doom",
		icon = 136122,
	},
	[47867] = {
		name = "Curse of Doom",
		icon = 136122,
	},
};

--Spell ID's.
local soulstoneIDs = {
	--Cata uses same ID as rank 1.
	[20707] = "Minor Soulstone", --Rank 1.
	[20762] = "Lesser Soulstone", --Rank 2.
	[20763] = "Soulstone", --Rank 3.
	[20764] = "Greater Soulstone", --Rank 4.
	[20765] = "Major Soulstone", --Rank 5.
	[27239] = "Master Soulstone", --Rank 6.
	[47883] = "Master Soulstone", --Rank 6.
};

--Spellid => icon
local healthstoneSpellIDs = {
	--Items.
	--[[[5512] = 100,
	[5511] = 250,
	[19008] = 550,
	[5510] = 800,
	[9421] = 1200,
	[22103] = 2080,
	[36889] = 3500,
	[36892] = 4280,]]
	--Ritual spells
	[29893] = 2080,
	--[] = 3500,
	[58887] = 4280,
};

local function unitSpellcastChanellStart(...)
	local unit, castGUID, spellID = ...;
	if (unit == "player") then
		if (healthstoneSpellIDs[spellID]) then
			if (NRC.config.healthstoneMsg and NRC.expansionNum > 1) then
				if (IsInInstance()) then
					if (NRC.expansionNum > 3) then
						SendChatMessage(L["Healthstones"] .. ".", "SAY");
					else
						local _, _, _, _, chosen = GetTalentInfo(2, 1);
						if (chosen) then
							local hp = healthstoneSpellIDs[spellID] * tonumber(string.format("%.1f", "1." .. chosen));
							SendChatMessage(chosen .. "/2 " .. L["Healthstones"] .. " (" .. hp .. " hp).", "SAY");
						end
					end
				end
			end
		end
	end
end

--[[local function unitSpellcastSucceeded(...)
	local unit, castGUID, spellID = ...;
	if (unit == "player") then
		if (soulstoneIDs[spellID]) then
			if (NRC.config.soulstoneMsg and (NRC.isTBC or NRC.isWrath)) then
				if (IsInInstance()) then
					local reaction = UnitReaction("target", "player");
					if (UnitName("target") and reaction > 5) then
						SendChatMessage(soulstoneIDs[spellID] .. " cast on " .. UnitName("target") .. ".", "SAY");
					else
						SendChatMessage(soulstoneIDs[spellID] .. " cast on " .. UnitName("player") .. ".", "SAY");
					end
				end
			end
		end
	end
end]]

local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, spellID, spellName = CombatLogGetCurrentEventInfo();
	--local raid = NRC.raid;
	if (subEvent == "SPELL_CAST_SUCCESS") then
		if (sourceGUID == UnitGUID("player") and IsInInstance()) then
			--if (soulstoneIDs[spellID] and (NRC.isTBC or NRC.isWrath)) then
			if (soulstoneIDs[spellID]) then
				--local msg = soulstoneIDs[spellID] .. " cast on " .. destName .. ".";
				local msg = L["Soulstone"] .. " " .. L["cast on"] .. " " .. destName .. ".";
				if (NRC.config.soulstoneMsgSay) then
					SendChatMessage(msg, "SAY");
				end
				if (NRC.config.soulstoneMsgGroup) then
					NRC:sendGroup(msg);
				end
			end
			--if (curses[spellID]) then
			
			--end
		end
		if (sourceGUID == UnitGUID("player")) then
			if (curses[spellID]) then
				if (UnitGUID("target") == destGUID) then
					--if (UnitClassification("target") == "worldboss") then
						targetCurse = {
							spellName = spellName,
							spellID = spellID,
							destName = destName,
							destGUID = destGUID,
							--time = GetTime(),
						};
					--end
				elseif (UnitGUID("focus") == destGUID) then
					--if (UnitClassification("focus") == "worldboss") then
						focusCurse = {
							spellName = spellName,
							spellID = spellID,
							destName = destName,
							destGUID = destGUID,
						};
					--end
				end
			end
		end
	elseif (subEvent == "SPELL_AURA_REMOVED") then
		if (sourceGUID == UnitGUID("player")) then
			--Unfinished warlock curse reminder, planned for next version.
			if (curses[spellID]) then
				C_Timer.After(0.5, function()
					if (targetCurse.destGUID and destGUID == targetCurse.destGUID) then
						if (NRC.config.warlockCurseReminder) then
							--NRC:debug("Target curse down", targetCurse.spellName);
							NRC:startMiddleIcon(curses[spellID].icon, 1.5, nil, "Down");
						end
						targetCurse = {};
					elseif (focusCurse.destGUID and destGUID == focusCurse.destGUID) then
						if (NRC.config.warlockCurseReminder) then
							--NRC:debug("Focus curse down", focusCurse.spellName);
							NRC:startMiddleIcon(curses[spellID].icon, 1.5, nil, "Focus Down");
						end
						focusCurse = {};
					end
				end)
			end
		end
	elseif (subEvent == "UNIT_DIED") then
		if (targetCurse.destGUID and destGUID == targetCurse.destGUID) then
			--NRC:debug("Target curse died.");
			targetCurse = {};
		elseif (focusCurse.destGUID and destGUID == focusCurse.destGUID) then
			--NRC:debug("Focus curse died.");
			focusCurse = {};
		end
	elseif (subEvent == "SPELL_CAST_START") then
		if (sourceGUID == UnitGUID("player")) then
			if (spellID == 698) then
				if (NRC.config.summonMsg) then
					if (WeakAuras and WeakAuras.GetData("Nova Summon Announcer (Summoning stones and warlock)")) then
						--print("wa installed")
						--return;
					end
					local arg = GetSubZoneText();
					if (not arg or arg == "") then
						arg = GetZoneText();
					end
					local msg;
					if (arg) then
						msg = L["Summoning"] .. " {rt1}" .. UnitName("target") .. "{rt1} to " .. arg .. ", " .. L["click!"];
					else
						msg = L["Summoning"] .. " {rt1}" .. UnitName("target") .. "{rt1}, " .. L["click!"];
				    end
				    NRC:sendGroup(msg);
				end
			end
		end
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
--f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
--f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(...);
	elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
		unitSpellcastChanellStart(...);
	--elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
	--	unitSpellcastSucceeded(...);
	elseif (event == "ENCOUNTER_END") then
		targetCurse, focusCurse = {}, {};
	end
end)