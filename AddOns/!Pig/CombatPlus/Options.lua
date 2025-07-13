local addonName, addonTable = ...;
local L=addonTable.locale
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
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,30)
CombatPlusfun.RTabFrame=RTabFrame
--==================================
addonTable.CombatPlus = function()
	CombatPlusfun.Marker()
	CombatPlusfun.HPMPBar()
	CombatPlusfun.AttackBar()
	CombatPlusfun.BabySitter()
end