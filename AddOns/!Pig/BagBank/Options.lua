local addonName, addonTable = ...;
local L=addonTable.locale
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
---
local BagBankfun={}
BagBankfun.BagUIName="PIG_CombinedBag"
addonTable.BagBankfun=BagBankfun
local GetSortBagsRightToLeft=GetSortBagsRightToLeft or C_Container and C_Container.GetSortBagsRightToLeft
local GetInsertItemsLeftToRight=GetInsertItemsLeftToRight or C_Container and C_Container.GetInsertItemsLeftToRight
local SetSortBagsRightToLeft=SetSortBagsRightToLeft or C_Container and C_Container.SetSortBagsRightToLeft
local SetInsertItemsLeftToRight=SetInsertItemsLeftToRight or C_Container and C_Container.SetInsertItemsLeftToRight
local BagBankF,BagBankFTabBut = PIGOptionsList(L["BAGBANK_TABNAME"],"TOP")
BagBankF.error = PIGFontString(BagBankF,{"CENTER", BagBankF, "CENTER",0, 50})
BagBankF.error:SetTextColor(1, 0, 0, 1)
BagBankF.czrl = PIGButton(BagBankF,{"TOP",BagBankF.error,"BOTTOM",0,-10},{280,24})
BagBankF.czrl:SetScript("OnClick", function(self)
	if self.qitaName=="NDui" then
		NDuiDB["Bags"]=NDuiDB["Bags"] or {}
		NDuiDB["Bags"]["Enable"]=false
	elseif self.qitaName=="ElvUI" then
		local peizName=ElvPrivateDB["profileKeys"][PIG_OptionsUI.AllNameElvUI]
		if peizName then
			local peizData=ElvPrivateDB["profiles"][peizName]
			if peizData then
				peizData["bags"]=peizData["bags"] or {}
				peizData["bags"]["enable"]=false
			end
		end
	else
		C_AddOns.DisableAddOn(self.qitaName)
	end
	ReloadUI();
end)
----------
local BagaddList = {"Bagnon","Combuctor","Baganator"};
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local function Other_bag()
	for i = 1, #BagaddList do
		local loadedOrLoading, loaded = IsAddOnLoaded(BagaddList[i])
		if loaded then return true,BagaddList[i],"插件"..BagaddList[i] end
	end
	if PIG_OptionsUI.IsOpen_NDui("Bags","Enable") then
		return true,"NDui","NDui背包功能"
	elseif PIG_OptionsUI.IsOpen_ElvUI() and PIG_OptionsUI.IsOpen_ElvUI("bags","enable") then 
		return true,"ElvUI","ElvUI背包功能"
	end
	return false
end
local function Other_bagErrtishi()
	local open,addname,txt=Other_bag()
	if open then
		BagBankF.error:SetText("检测到"..txt.."开启，已禁用"..addonName.."背包功能")
		BagBankF.czrl:SetText("禁用"..txt.."，启用"..addonName.."背包功能")
		BagBankF.czrl.qitaName=addname
		return true
	end
	return false
end
---
BagBankfun.BAGmeihangshu=0
if PIG_MaxTocversion(40000) then
	BagBankfun.BAGmeihangshu=BagBankfun.BAGmeihangshu+2
else
	BagBankfun.BAGmeihangshu=BagBankfun.BAGmeihangshu+4
end
BagBankF.Zhenghe = PIGCheckbutton(BagBankF,{"TOPLEFT",BagBankF,"TOPLEFT",20,-20},{"启用背包/银行整合","整合背包/银行包裹到一个界面"})
BagBankF.Zhenghe:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["BagBank"]["Zhenghe"]=true
		BagBankF.SetListF:Show()
		BagBankfun.Zhenghe(BagBankF,BagBankFTabBut)		
	else
		PIGA["BagBank"]["Zhenghe"]=false
		BagBankF.SetListF:Hide()
		PIG_OptionsUI.RLUI:Show()
	end	
end);
--背包剩余-------------
local function gengxinbeibaoshengyugeshu()
	if MainMenuBarBackpackButton.freeSlots<10 then
		MainMenuBarBackpackButton.Count:SetTextColor(1, 0, 0, 1);
	else
		MainMenuBarBackpackButton.Count:SetTextColor(0, 1, 0, 1);
	end
end
local function BagKongyu()
	if PIGA["BagBank"]["BagKongyu"] then
		MainMenuBarBackpackButton.pigbagkongyu=true
		SetCVar("displayFreeBagSlots", "1")
		MainMenuBarBackpackButton.Count:Show()
		MainMenuBarBackpackButton.Count:SetTextScale(18/14);
		gengxinbeibaoshengyugeshu()
	else
		SetCVar("displayFreeBagSlots", "0")
		MainMenuBarBackpackButton.Count:Hide()
	end
end
----
BagBankF.SetListline = PIGLine(BagBankF,"TOP",-60)
BagBankF.SetListF = PIGFrame(BagBankF)
BagBankF.SetListF:SetPoint("TOPLEFT",BagBankF.SetListline,"BOTTOMLEFT",0,0);
BagBankF.SetListF:SetPoint("BOTTOMRIGHT",BagBankF,"BOTTOMRIGHT",0,30);
MainMenuBarBackpackButton:HookScript("OnEvent", function(self,event,arg1)
	if event=="PLAYER_ENTERING_WORLD" then
		BagKongyu()
	elseif event=="BAG_UPDATE" then
		if self.pigbagkongyu then
			gengxinbeibaoshengyugeshu()
		end
	end
end)
BagBankF.SetListF.BagKongyu = PIGCheckbutton_R(BagBankF.SetListF,{"显示背包剩余空间","在行囊显示背包剩余空间(大于等于10显示绿色,小于10显示红色)"})
BagBankF.SetListF.BagKongyu:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["BagBank"]["BagKongyu"]=true;			
	else
		PIGA["BagBank"]["BagKongyu"]=false;
	end
	BagKongyu()
end)
function BagBankfun.GetSortBagsRightToLeft()
	if GetSortBagsRightToLeft then
		return GetSortBagsRightToLeft()
	else
		return PIGA["BagBank"]["SortBag_Config"]
	end
end
function BagBankfun.SetSortBagsRightToLeft(enabled)
	if SetSortBagsRightToLeft then
		SetSortBagsRightToLeft(enabled)
	else
		PIGA["BagBank"]["SortBag_Config"] = enabled
	end
end
local BAG_SetList = {
	{"交易时打开背包","jiaoyiOpen",false},
	{"拍卖时打开背包","AHOpen",false},
	{"显示装备等级","wupinLV",true},
	{"垃圾物品提示","JunkShow",true},
	{"战利品放入左边包",GetInsertItemsLeftToRight,false},
	{"反向整理",BagBankfun.GetSortBagsRightToLeft,false},
}
if PIG_MaxTocversion() then
	table.insert(BAG_SetList,4,{"根据品质染色装备边框","wupinRanse",true})
	table.insert(BAG_SetList,5,{"新物品提示","NewItem",false})
end
for i=1,#BAG_SetList do
	local tishi = BAG_SetList[i][4] or BAG_SetList[i][1]
	local BagBankSet = PIGCheckbutton_R(BagBankF.SetListF,{BAG_SetList[i][1],tishi},nil,nil,nil,nil,"BAG_SetList"..i)
	BagBankSet:SetScript("OnClick", function (self)
		if self:GetChecked() then
			if BAG_SetList[i][1]=="反向整理" then
				BagBankfun.SetSortBagsRightToLeft(false)
			elseif BAG_SetList[i][1]=="战利品放入左边包" then
				SetInsertItemsLeftToRight(true)
			else
				PIGA["BagBank"][BAG_SetList[i][2]]=true
				CloseAllBags()OpenAllBags()
			end		
		else
			if BAG_SetList[i][1]=="反向整理" then
				BagBankfun.SetSortBagsRightToLeft(true)
			elseif BAG_SetList[i][1]=="战利品放入左边包" then
				SetInsertItemsLeftToRight(false)
			else
				PIGA["BagBank"][BAG_SetList[i][2]]=false
			end
			if BAG_SetList[i][3] then
				PIG_OptionsUI.RLUI:Show()
			end
		end
	end)
end
--每行格数
BagBankF.SetListF.hangNUMTXT = PIGFontString(BagBankF.SetListF,{"TOPLEFT",BagBankF.SetListF,"TOPLEFT",20,-220},"背包每行格数")
local BagmeihangN= {8,16,1}
BagBankF.SetListF.hangNUM = PIGSlider(BagBankF.SetListF,{"LEFT", BagBankF.SetListF.hangNUMTXT,"RIGHT",4,0},BagmeihangN)	
BagBankF.SetListF.hangNUM.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["BagBank"]["BAGmeihangshu"] = arg1-BagBankfun.BAGmeihangshu
	if PIG_MaxTocversion() then
		if _G[BagBankfun.BagUIName] then _G[BagBankfun.BagUIName].meihang=arg1 end
	else
		ContainerFrameCombinedBags.meihang=arg1
	end
	if _G[BagBankfun.BagUIName] and _G[BagBankfun.BagUIName]:IsShown() or ContainerFrameCombinedBags and ContainerFrameCombinedBags:IsShown() then
		CloseAllBags()
		OpenAllBags()
	end
end)
--缩放
BagBankF.SetListF.suofangTXT = PIGFontString(BagBankF.SetListF,{"TOPLEFT",BagBankF.SetListF.hangNUMTXT,"BOTTOMLEFT",0,-20},"背包缩放比例")
local BAGsuofangbili = {0.8,1.4,0.01,{["Right"]="%"}}
BagBankF.SetListF.suofang = PIGSlider(BagBankF.SetListF,{"LEFT", BagBankF.SetListF.suofangTXT,"RIGHT",4,0},BAGsuofangbili)	
BagBankF.SetListF.suofang.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["BagBank"]["BAGsuofangBili"] = arg1;
	if PIG_MaxTocversion() then
		if _G[BagBankfun.BagUIName] then _G[BagBankfun.BagUIName].suofang=arg1 end
	else
		ContainerFrameCombinedBags.suofang=arg1
	end
	if _G[BagBankfun.BagUIName] and _G[BagBankfun.BagUIName]:IsShown() or ContainerFrameCombinedBags and ContainerFrameCombinedBags:IsShown() then
		CloseAllBags()
		OpenAllBags()
	end
end)

BagBankF.SetListF.CZpeizhi = PIGButton(BagBankF.SetListF,{"BOTTOMLEFT",BagBankF.SetListF,"BOTTOMLEFT",20,6},{150,24},"背包异常点此重置");
BagBankF.SetListF.CZpeizhi:SetScript("OnClick", function(self, button)
	StaticPopup_Show ("HUIFU_DEFAULT_BEIBAOZHENGHE");
end)
StaticPopupDialogs["HUIFU_DEFAULT_BEIBAOZHENGHE"] = {
	text = "此操作将\124cffff0000重置\124r背包/银行整合所有数据和配置，\n需重载界面。确定重置?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		PIGA["BagBank"]=addonTable.Default["BagBank"]
		PIGA["BagBank"]["Zhenghe"]=true
		PIGA["BagBank"]["SortBag_Config"]=true
		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
BagBankF.SetListF:HookScript("OnShow", function(self)
	self.BagKongyu:SetChecked(PIGA["BagBank"]["BagKongyu"])
	for i=1,#BAG_SetList do
		if BAG_SetList[i][1]=="反向整理" then
			_G["BAG_SetList"..i]:SetChecked(not BagBankfun.GetSortBagsRightToLeft())
		elseif BAG_SetList[i][1]=="战利品放入左边包" then
			_G["BAG_SetList"..i]:SetChecked(BAG_SetList[i][2]())
		else
			_G["BAG_SetList"..i]:SetChecked(PIGA["BagBank"][BAG_SetList[i][2]])
		end
	end
	self.suofang:PIGSetValue(PIGA["BagBank"]["BAGsuofangBili"])
	self.hangNUM:PIGSetValue(PIGA["BagBank"]["BAGmeihangshu"]+BagBankfun.BAGmeihangshu)
end)
BagBankF:HookScript("OnShow", function(self)
	self.SetListF:Hide()
	self.czrl:Hide()
	self.Zhenghe:SetChecked(PIGA["BagBank"]["Zhenghe"])
	if PIGA["BagBank"]["Zhenghe"] then
		if Other_bagErrtishi() then
			self.czrl:Show()
		else
			self.error:SetText("")
			self.SetListF:Show()
		end
	end
end)
--==================================
addonTable.BagBank = function()
	if not Other_bag() then
		BagBankfun.Zhenghe(BagBankF,BagBankFTabBut)
	end
end