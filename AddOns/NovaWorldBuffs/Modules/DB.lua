-------------------
---NovaWorldBuffs--
-------------------

--Slowly moving all settings and buff data in to this file so things are easier to change around and add new buffs as classic/sod keeps getting changes.

local addonName, addon = ...;
addon.a = LibStub("AceAddon-3.0"):NewAddon("NovaWorldBuffs", "AceComm-3.0");
local NWB = addon.a;
--local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");
NWB.expansionNum = 1;
if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
	NWB.isClassic = true;
elseif (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	NWB.isTBC = true;
	NWB.expansionNum = 2;
elseif (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
	NWB.isWrath = true;
	NWB.expansionNum = 3;
elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
	if (GetRealmName() ~= "Classic Beta PvE" and GetServerTime() < 1716127200) then --Sun May 19 2024 14:00:00 GMT;
		NWB.isPrepatch = true;
		NWB.isCataPrepatch = true;
	end
	NWB.isCata = true;
	NWB.expansionNum = 4;
elseif (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC) then
	NWB.isMOP = true; --Later expansion project id's will likely need updating once Blizzard decides on the names.
	NWB.expansionNum = 5;
elseif (WOW_PROJECT_ID == WOW_PROJECT_WARLORDS_CLASSIC) then
	NWB.isWOD = true;
	NWB.expansionNum = 6;
elseif (WOW_PROJECT_ID == WOW_PROJECT_LEGION_CLASSIC) then
	NWB.isLegion = true;
	NWB.expansionNum = 7;
elseif (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
	NWB.isRetail = true;
	NWB.expansionNum = 10;
end
if (NWB.isClassic and C_Engraving and C_Engraving.IsEngravingEnabled()) then
	NWB.isSOD = true;
end
--Temporary until actual launch.
--if (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	--This basically meant prepatch, some things were still enabled.
--	NWB.realmsTBC = true;
--end

NWB.rendCooldownTime = 10800;
NWB.onyCooldownTime = 21600;
NWB.nefCooldownTime = 28800;
NWB.zanCooldownTime = 28800; --Not used but left here so some older stuff doesn't break.
--NWB.noWorldBuffTimers = false; --Hides timers on certain frames and minimap button tooltip, should be used if all rend/ony/nef cooldown times are set to 0 like in SoD.
NWB.yellPercent = 100; --Capital city logon chance to share data via yell, will be adjusted later when timer cooldown changes stabilize.
NWB.buffDropSpamCooldown = 0; --Spam control for buff drops, Might of Stormwind has it's own longer delay in WorldBuffs.lua
NWB.buffDropSpamCooldownSoD = 300; --Longer cooldown for the spammy SoD buff drops (Boon of Blackfathom, Ashenvale Rallying Cry, Fervor of the Temple Explorer).

if (NWB.isSOD) then
	NWB.noWorldBuffTimers = true; --Hides timers on certain frames and minimap button tooltip, should be used if all rend/ony/nef cooldown times are set to 0 like in SoD.
	NWB.noGuildBuffDroppedMsgs = true; --With no timers tracked the drops are alot more often and spammy, this removes the 2nd msg "buff dropped" and just keep the drop in few seconds warning.
	NWB.buffDropSpamCooldown = 600; --Spam control cooldown time between msgs for buff drops, might of stormwind has it's own longer delay in WorldBuffs.lua (as of now might of stormwind never sends a msg becaus no need)
	NWB.rendCooldownTime = 0;
	NWB.onyCooldownTime = 0;
	NWB.nefCooldownTime = 0;
elseif (NWB.isClassic) then
	NWB.nefCooldownTime = 0;
end