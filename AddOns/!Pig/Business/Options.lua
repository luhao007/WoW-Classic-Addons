local addonName, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local PIGOptionsList=Create.PIGOptionsList
------
local BusinessInfo = {}
addonTable.BusinessInfo=BusinessInfo
------------
local fuFrame,fuFrameBut = PIGOptionsList(L["BUSINESS_TABNAME"],"TOP")
fuFrame.GNNUM=0
fuFrame.dangeH=50
BusinessInfo.fuFrame,BusinessInfo.fuFrameBut=fuFrame,fuFrameBut
--===================================
addonTable.Business=function()
	BusinessInfo.AHPlusOptions()
	BusinessInfo.StatsInfoOptions()
	BusinessInfo.MailPlusOptions()
	BusinessInfo.AutoSellBuyOptions() 
end