local addonName, addonTable = ...;
local L=addonTable.locale
---
local Create=addonTable.Create
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
local NR =Create.PIGOptionsList_RF(Llist)
CommonInfo.Llist=Llist
CommonInfo.LlistTabBut=LlistTabBut
CommonInfo.NR=NR
--==================================
addonTable.Common=function()
	for _,v in pairs(CommonInfo.Commonfun) do
		v()
	end
	for _,v in pairs(CommonInfo.Interactionfun) do
		v()
	end
end