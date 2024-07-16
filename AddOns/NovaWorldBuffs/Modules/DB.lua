-------------------
---NovaWorldBuffs--
-------------------

--Slowly moving all settings and buff data in to this file so things are easier to change around and add new buffs as classic/sod keeps getting changes.

local addonName, addon = ...;
addon.a = LibStub("AceAddon-3.0"):NewAddon("NovaWorldBuffs", "AceComm-3.0");
local NWB = addon.a;
--local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");

NWB.yellPercent = 100; --Capital city logon chance to share data via yell, will be adjusted later when timer cooldown changes stabilize.
NWB.noWorldBuffTimers = true; --World cooldowns changed from 8h to 1 minute, don't track timers anymore.
NWB.noGuildBuffDroppedMsgs = true; --With no timers tracked the drops are alot more often and spammy, rmoved the 2nd msg "buff dropped" and just keep the drop in few seconds warning.
NWB.buffDropSpamCooldown = 180; --Spam control for buff drops, Might of Stormwind has it's own longer delay in WorldBuffs.lua
NWB.buffDropSpamCooldownSoD = 300; --Longer for the spammy SoD buff drops.