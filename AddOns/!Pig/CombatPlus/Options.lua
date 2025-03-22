local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
---
local CombatPlusfun={}
addonTable.CombatPlusfun=CombatPlusfun

local fuFrame,fuFrameBut = PIGOptionsList(L["COMBAT_TABNAME"],"TOP")
CombatPlusfun.fuFrame=fuFrame
CombatPlusfun.fuFrameBut=fuFrameBut
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
CombatPlusfun.RTabFrame=RTabFrame
--==================================
addonTable.CombatPlus = function()
	CombatPlusfun.Marker()
	CombatPlusfun.CombatTime()
	CombatPlusfun.HPMPBar()
	CombatPlusfun.AttackBar()
	CombatPlusfun.BabySitter()
end