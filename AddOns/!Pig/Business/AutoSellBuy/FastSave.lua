local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGButton = Create.PIGButton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGEnter=Create.PIGEnter
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
local PIGSlider = Create.PIGSlider
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
local UseContainerItem =C_Container.UseContainerItem
-- 
local Data=addonTable.Data
local bagID=Data.bagData["bagID"]
local bankID=Data.bagData["bankID"]
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.FastSave()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"存",50,"Left")

	local GNNameSaveE = "Save"
	if tocversion<50000 then
		fujiF.cunGV =PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},"|cff00FFFF(设置为单个角色独享)|r")
	else
		fujiF.cunGV =PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},MAXIMUM..BANK_DEPOSIT_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."|cff00FFFF(设置为单个角色独享)|r")
		fujiF.cunGVSlider = PIGSlider(fujiF,{"TOPLEFT",fujiF.cunGV,"BOTTOMLEFT",0,0},{0, 1000000000, 1000000,{["Right"]=GetMoneyString}},200)
		fujiF.cunGVSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
			PIGA_Per["AutoSellBuy"][GNNameSaveE.."_Money"]=arg1
		end)
		fujiF:HookScript("OnShow", function (self)
			self.cunGVSlider:PIGSetValue(PIGA_Per["AutoSellBuy"][GNNameSaveE.."_Money"])
		end)
	end
	BusinessInfo.ADDScroll(fujiF,"存储",GNNameSaveE,18,{true,"AutoSellBuy",GNNameSaveE.."_List"})
	--取
	local fujiF_Take,fujiTabBut_Take=PIGOptionsList_R(AutoSellBuy_UI.F,"取",50,"Left")
	local GNNameTakeE = "Take"
	if tocversion<50000 then
		fujiF_Take.tiquGV =PIGFontString(fujiF_Take,{"TOPLEFT",fujiF_Take,"TOPLEFT",10,-9},"|cff00FFFF(设置为单个角色独享)|r")
	else
		fujiF_Take.tiquGV =PIGFontString(fujiF_Take,{"TOPLEFT",fujiF_Take,"TOPLEFT",10,-9},MAXIMUM..BANK_WITHDRAW_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."|cff00FFFF(设置为单个角色独享)|r")
		fujiF_Take.tiquGVSlider = PIGSlider(fujiF_Take,{"TOPLEFT",fujiF_Take.tiquGV,"BOTTOMLEFT",0,0},{0, 1000000000, 1000000,{["Right"]=GetMoneyString}},200)
		fujiF_Take.tiquGVSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
			PIGA_Per["AutoSellBuy"][GNNameTakeE.."_Money"]=arg1
		end)
		fujiF_Take:HookScript("OnShow", function (self)
			self.tiquGVSlider:PIGSetValue(PIGA_Per["AutoSellBuy"][GNNameTakeE.."_Money"])
		end)
	end
	BusinessInfo.ADDScroll(fujiF_Take,"取出",GNNameTakeE,18,{true,"AutoSellBuy",GNNameTakeE.."_List"})
	-- for i=1,20 do
	-- 	local name = GetItemClassInfo(i)
	-- 	--print(name)
	-- 	-- local Subname = GetItemSubClassInfo(7, i)
	-- 	-- print(i,Subname)
	-- end
	local www,hhh = 25,25
	local ItemTypeLsit = {
		{133784,"G",CUSTOM},
		{133971,{{0,5}}},--消耗品/食物
		{134071,{{7,4},{3}}},--商品/珠宝加工
		{136249,{{7,5}}},--商品/布料
		{133611,{{7,6}}},--商品/皮革
		{136248,{{7,7}}},--商品/金属矿石
		{133970,{{7,8}}},--商品/肉类
		{133939,{{7,9}}},--商品/草药
		{136244,{{7,12}}},--商品/附魔
		{135860,"diy",CUSTOM},
	}
	for iv=1,#ItemTypeLsit do
		if ItemTypeLsit[iv][2]~="diy" and ItemTypeLsit[iv][2]~="G" then
			local Subname = GetItemSubClassInfo(ItemTypeLsit[iv][2][1][1],ItemTypeLsit[iv][2][1][2])
			ItemTypeLsit[iv][3]=Subname or NONE
		end
	end
	local function SavezhixingFun(typeid,itemID,bag,slot,cfvv)
		if itemID then
			local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemID) 
			--local itemName,itemLink = GetItemInfo(itemID) 
			--print(itemLink,itemType, itemSubType, classID, subclassID)
			if ItemTypeLsit[typeid][2]=="diy" then
				for ib=1,#cfvv do
					if itemID==cfvv[ib][1] then
						UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType() or nil, BankFrame:IsShown() and BankFrame.selectedTab == 2);
					end
				end
			else
				for ib=1,#ItemTypeLsit[typeid][2] do
					if ItemTypeLsit[typeid][2][ib][2] then
						if classID==ItemTypeLsit[typeid][2][ib][1] and subclassID==ItemTypeLsit[typeid][2][ib][2] then
							if tocversion<20000 then
								UseContainerItem(bag,slot,nil, nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
							else
								UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType(), BankFrame:IsShown() and BankFrame.selectedTab == 2);
							end
						end
					else
						if classID==ItemTypeLsit[typeid][2][ib][1] then
							if tocversion<20000 then
								UseContainerItem(bag,slot,nil, nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
							else
								UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType(), BankFrame:IsShown() and BankFrame.selectedTab == 2);
							end
						end
					end
				end
			end
		end
	end
	local function PIGRunUseItem(button,typeid,data)
		if tocversion<20000 then PIGTopMsg:add("功能正在修复...") return end
		local shujudata={{},{}}
		if button=="LeftButton" then
			if ItemTypeLsit[typeid][2]=="G" then
				C_Bank.DepositMoney(BankFrame:GetActiveBankType(), PIGA_Per["AutoSellBuy"][GNNameSaveE.."_Money"])
			else
				shujudata[2]=PIGA_Per["AutoSellBuy"][GNNameSaveE.."_List"]
				for bag=1,#bagID do
					local bganum=GetContainerNumSlots(bagID[bag])
					for slot=1,bganum do
						local itemID=GetContainerItemID(bagID[bag], slot)
						SavezhixingFun(typeid,itemID,bagID[bag], slot, shujudata[2])
					end
				end
			end
		else
			if ItemTypeLsit[typeid][2]=="G" then
				C_Bank.WithdrawMoney(BankFrame:GetActiveBankType(), PIGA_Per["AutoSellBuy"][GNNameTakeE.."_Money"]);
			else
				shujudata[2]=PIGA_Per["AutoSellBuy"][GNNameTakeE.."_List"]
				if BankFrame.activeTabIndex==1 then
					for bag=1,#bankID do
						local bganum=GetContainerNumSlots(bankID[bag])
						for slot=1,bganum do
							local itemID=GetContainerItemID(bankID[bag], slot)
							SavezhixingFun(typeid,itemID,bankID[bag], slot, shujudata[2])
						end
					end
				elseif BankFrame.activeTabIndex==2 then
					for slot=1, GetContainerNumSlots(REAGENTBANK_CONTAINER) do--ReagentBankFrame.size
						local itemID=GetContainerItemID(REAGENTBANK_CONTAINER, slot)
						SavezhixingFun(typeid,itemID,REAGENTBANK_CONTAINER, slot, shujudata[2])
					end
				elseif BankFrame.activeTabIndex==3 then
					for slot = 1, GetContainerNumSlots(AccountBankPanel.selectedTabID) do
						local itemID=GetContainerItemID(AccountBankPanel.selectedTabID, slot)
						SavezhixingFun(typeid,itemID,AccountBankPanel.selectedTabID, slot, shujudata[2])
					end
				end
			end
		end
	end
	---
	local fujiUI=BankFrame
	local typenum = #ItemTypeLsit
	BankFrame.typeList={}
	for ib=typenum,1,-1 do
		local savebut = CreateFrame("Button",nil,fujiUI, "TruncatedButtonTemplate",ib);
		savebut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		savebut:SetNormalTexture(ItemTypeLsit[ib][1])
		savebut:SetSize(www,hhh);
		BankFrame.typeList[ib]=savebut
		if ib==#ItemTypeLsit then
			if tocversion<50000 then
				savebut:SetPoint("TOPRIGHT",fujiUI,"TOPRIGHT",-56,-40);
			else
				savebut:SetPoint("TOPRIGHT",fujiUI,"TOPRIGHT",-50,-29);
			end
			PIGEnter(savebut,savebut,KEY_BUTTON1.." \124cff00FF00一键存"..ItemTypeLsit[ib][3].."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..ItemTypeLsit[ib][3].."\124r","SHIFT+"..KEY_BUTTON1.."-\124cff00FFFF"..ItemTypeLsit[ib][3].."存储物品\124r\n".."SHIFT+"..KEY_BUTTON2.."-\124cff00FFFF"..ItemTypeLsit[ib][3].."取出物品\124r")
		else
			savebut:SetPoint("RIGHT",BankFrame.typeList[ib+1],"LEFT",-2,0);
			if ib==1 and fujiF_Take.tiquGVSlider then
				local txt1 = KEY_BUTTON1.." \124cff00FF00一键存"..BONUS_ROLL_REWARD_MONEY.."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..BONUS_ROLL_REWARD_MONEY.."\124r"
				local txt2 = "SHIFT+"..KEY_BUTTON1.."-\124cff00FFFF"..ItemTypeLsit[ib][3]..MAXIMUM..BANK_DEPOSIT_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."\124r\n".."SHIFT+"..KEY_BUTTON2.."-\124cff00FFFF"..ItemTypeLsit[ib][3]..MAXIMUM..BANK_WITHDRAW_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."\124r"
				PIGEnter(savebut,savebut,txt1,txt2)
			else
				PIGEnter(savebut,KEY_BUTTON1.." \124cff00FF00一键存"..ItemTypeLsit[ib][3].."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..ItemTypeLsit[ib][3].."\124r")
			end
		end
		savebut:RegisterForClicks("LeftButtonUp","RightButtonUp")
		savebut.Down = savebut:CreateTexture(nil, "OVERLAY");
		savebut.Down:SetTexture(130839);
		savebut.Down:SetAllPoints(savebut)
		savebut.Down:Hide();
		savebut:SetScript("OnMouseDown", function (self)
			self.Down:Show();
		end);
		savebut:SetScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		savebut:SetScript("OnClick", function (self,button)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			if ib==#ItemTypeLsit and IsShiftKeyDown() then 
				if button=="LeftButton" then
					AutoSellBuy_UI:Show()
					Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
				else
					AutoSellBuy_UI:Show()
					Show_TabBut_R(AutoSellBuy_UI.F,fujiF_Take,fujiTabBut_Take)
				end
				return
			end
			local typeid = self:GetID()
			PIGRunUseItem(button,typeid)
		end);
	end
	local function Show_TabButtype(tabid)
		BankFrame.typeList[1]:Hide()
		BankFrame.typeList[2]:Hide()
		if tabid==1 then
			BankFrame.typeList[2]:Show()
		elseif tabid==3 then
			BankFrame.typeList[1]:Show()
			BankFrame.typeList[2]:Show()
		end
	end
	BankFrame:HookScript("OnShow", function(self,event,arg1)
		Show_TabButtype(1)
	end); 
	for tabid=1,3 do
		local tab=_G["BankFrameTab"..tabid]
		if tab then
			tab:HookScript("OnClick", function(self)
				Show_TabButtype(tabid)
			end);
		end
	end
end