local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGLine=Create.PIGLine
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
---
local CommonInfo={}
addonTable.CommonInfo=CommonInfo
---
local Llist,LlistTabBut = PIGOptionsList(L["COMMON_TABNAME"],"TOP")
Llist:Show()
LlistTabBut:Selected()
local NR =Create.PIGOptionsList_RF(Llist,30)
CommonInfo.NR=NR
--==================================
addonTable.Common=function()
	for _,v in pairs(CommonInfo.Commonfun) do
		v()
	end
	for _,v in pairs(CommonInfo.Interactionfun) do
		v()
	end
	for _,v in pairs(CommonInfo.Otherfun) do
		v()
	end
end