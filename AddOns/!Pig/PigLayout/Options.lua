local _, addonTable = ...;
local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
---
local PigLayoutFun={}
addonTable.PigLayoutFun=PigLayoutFun
local fuFrame = PIGOptionsList(BUG_CATEGORY5..L["CHAT_TABNAME4"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
PigLayoutFun.RTabFrame=RTabFrame
--=====================
addonTable.PigLayout = function()
	local Vtocversion=50000
	PigLayoutFun.Options_ActionBar(tocversion<Vtocversion)
	PigLayoutFun.Options_ChatUI(tocversion<Vtocversion)
	PigLayoutFun.Options_TopBar(tocversion<Vtocversion)
end