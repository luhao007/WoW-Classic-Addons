local _, addonTable = ...;
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.FastSave()
	local L=addonTable.locale
	local Create=addonTable.Create
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGEnter=Create.PIGEnter
	local Show_TabBut_R=Create.Show_TabBut_R
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGFontString=Create.PIGFontString
	local PIGSlider = Create.PIGSlider
	--
	local GetContainerNumSlots = C_Container.GetContainerNumSlots
	local GetContainerItemID = C_Container.GetContainerItemID
	local GetContainerItemLink = C_Container.GetContainerItemLink
	local PickupContainerItem =C_Container.PickupContainerItem
	local UseContainerItem =UseContainerItem or C_Container and C_Container.UseContainerItem
	local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
	-- 
	local Data=addonTable.Data
	local bagID=Data.bagData["bagID"]
	local bankID=Data.bagData["bankID"]
	--
	local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
	local _GN,_GNE = "存储","Save"
	local fujiF,fujiTabBut=PIGOptionsList_R(_G[GnUI].F,"存",50,"Left")
	if PIG_MaxTocversion() then
		fujiF.cunGV =PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},"|cff00FFFF(设置为单个角色独享)|r")
	else
		fujiF.cunGV =PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},MAXIMUM..BANK_DEPOSIT_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."|cff00FFFF(设置为单个角色独享)|r")
		fujiF.cunGVSlider = PIGSlider(fujiF,{"TOPLEFT",fujiF.cunGV,"BOTTOMLEFT",0,0},{0, 1000000000, 1000000,{["Right"]=GetMoneyString}},200)
		fujiF.cunGVSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
			PIGA_Per["AutoSellBuy"][_GNE.."_Money"]=arg1
		end)
		fujiF:HookScript("OnShow", function (self)
			self.cunGVSlider:PIGSetValue(PIGA_Per["AutoSellBuy"][_GNE.."_Money"])
		end)
	end
	BusinessInfo.ADDScroll(fujiF,_GN,_GNE,18,{true,"AutoSellBuy",_GNE.."_List"})
	--取
	local fujiF_Take,fujiTabBut_Take=PIGOptionsList_R(_G[GnUI].F,"取",50,"Left")
	local _GN_Take,_GNE_Take = "取出","Take"
	if PIG_MaxTocversion() then
		fujiF_Take.tiquGV =PIGFontString(fujiF_Take,{"TOPLEFT",fujiF_Take,"TOPLEFT",10,-9},"|cff00FFFF(设置为单个角色独享)|r")
	else
		fujiF_Take.tiquGV =PIGFontString(fujiF_Take,{"TOPLEFT",fujiF_Take,"TOPLEFT",10,-9},MAXIMUM..BANK_WITHDRAW_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."|cff00FFFF(设置为单个角色独享)|r")
		fujiF_Take.tiquGVSlider = PIGSlider(fujiF_Take,{"TOPLEFT",fujiF_Take.tiquGV,"BOTTOMLEFT",0,0},{0, 1000000000, 1000000,{["Right"]=GetMoneyString}},200)
		fujiF_Take.tiquGVSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
			PIGA_Per["AutoSellBuy"][_GNE_Take.."_Money"]=arg1
		end)
		fujiF_Take:HookScript("OnShow", function (self)
			self.tiquGVSlider:PIGSetValue(PIGA_Per["AutoSellBuy"][_GNE_Take.."_Money"])
		end)
	end
	BusinessInfo.ADDScroll(fujiF_Take,_GN_Take,_GNE_Take,18,{true,"AutoSellBuy",_GNE_Take.."_List"})
	--
	local www,hhh = 25,25
	local NewItemTypeLsit = PIGCopyTable(Data.ItemTypeLsit)
	table.insert(NewItemTypeLsit,1,{133784,"G",CUSTOM})
	table.insert(NewItemTypeLsit,{135860,"diy",CUSTOM})
	local function SavezhixingFun(typeid,itemID,bag,slot,cfvv)
		if itemID then
			local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemID) 
			-- local itemID, itemLink, icon, stackCount, quality=PIGGetContainerItemInfo(bag,slot)
			-- print(itemLink,classID, subclassID,itemType, itemSubType)
			if NewItemTypeLsit[typeid][2]=="diy" then
				for ib=1,#cfvv do
					if itemID==cfvv[ib][1] then
						UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType() or nil, false);
					end
				end
			else
				for ib=1,#NewItemTypeLsit[typeid][2] do
					if NewItemTypeLsit[typeid][2][ib][2] then
						if classID==NewItemTypeLsit[typeid][2][ib][1] and subclassID==NewItemTypeLsit[typeid][2][ib][2] then
							if PIG_MaxTocversion(20000) then
								UseContainerItem(bag,slot,nil, nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
							else
								UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType(), false);
							end
						end
					else
						if classID==NewItemTypeLsit[typeid][2][ib][1] then
							if PIG_MaxTocversion(20000) then
								UseContainerItem(bag,slot,nil, nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
							else
								UseContainerItem(bag,slot,nil, BankFrame.GetActiveBankType and BankFrame:GetActiveBankType(), false);
							end
						end
					end
				end
			end
		end
	end
	local function PIGRunUseItem(button,typeid,data)
		if PIG_MaxTocversion(20000) then PIG_OptionsUI:ErrorMsg("经典版物品子分类异常，功能受限...") return end
		local shujudata={{},{}}
		if button=="LeftButton" then
			if NewItemTypeLsit[typeid][2]=="G" then
				C_Bank.DepositMoney(BankFrame:GetActiveBankType(), PIGA_Per["AutoSellBuy"][_GNE.."_Money"])
			else
				shujudata[2]=PIGA_Per["AutoSellBuy"][_GNE.."_List"]
				for bag=1,#bagID do
					local bganum=GetContainerNumSlots(bagID[bag])
					for slot=1,bganum do
						local itemID=GetContainerItemID(bagID[bag], slot)
						SavezhixingFun(typeid,itemID,bagID[bag], slot, shujudata[2])
					end
				end
			end
		else
			if NewItemTypeLsit[typeid][2]=="G" then
				C_Bank.WithdrawMoney(BankFrame:GetActiveBankType(), PIGA_Per["AutoSellBuy"][_GNE_Take.."_Money"]);
			else
				shujudata[2]=PIGA_Per["AutoSellBuy"][_GNE_Take.."_List"]
				local BankFrameBankType=BankFrame:GetActiveBankType()
				if BankFrameBankType==0 then
					for bagid=6,11 do
						local bganum=GetContainerNumSlots(bagid)
						for slot=1,bganum do
							local itemID=GetContainerItemID(bagid, slot)
							SavezhixingFun(typeid,itemID,bagid, slot, shujudata[2])
						end
					end
				elseif BankFrameBankType==2 then
					for bagid=12,17 do
						local bganum=GetContainerNumSlots(bagid)
						for slot=1,bganum do
							local itemID=GetContainerItemID(bagid, slot)
							SavezhixingFun(typeid,itemID,bagid, slot, shujudata[2])
						end
					end
				end
			end
		end
	end
	---
	local fujiUI=BankFrame
	local typenum = #NewItemTypeLsit
	BankFrame.typeList={}
	for ib=typenum,1,-1 do
		local savebut = CreateFrame("Button",nil,fujiUI, "TruncatedButtonTemplate",ib);
		savebut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		savebut:SetNormalTexture(NewItemTypeLsit[ib][1])
		if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() then
			savebut:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
		end
		savebut:SetSize(www,hhh);
		BankFrame.typeList[ib]=savebut
		if ib==#NewItemTypeLsit then
			if PIG_MaxTocversion() then
				savebut:SetPoint("TOPRIGHT",fujiUI,"TOPRIGHT",-56,-40);
			else
				savebut:SetPoint("BOTTOMRIGHT", BankPanel.NineSlice, "BOTTOMRIGHT", -24, 10);
			end
			PIGEnter(savebut,savebut,KEY_BUTTON1.." \124cff00FF00一键存"..NewItemTypeLsit[ib][3].."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..NewItemTypeLsit[ib][3].."\124r","SHIFT+"..KEY_BUTTON1.."-\124cff00FFFF"..NewItemTypeLsit[ib][3].._GN.."物品\124r\n".."SHIFT+"..KEY_BUTTON2.."-\124cff00FFFF"..NewItemTypeLsit[ib][3].._GN_Take.."物品\124r")
		else
			savebut:SetPoint("RIGHT",BankFrame.typeList[ib+1],"LEFT",-2,0);
			if ib==1 and fujiF_Take.tiquGVSlider then
				local txt1 = KEY_BUTTON1.." \124cff00FF00一键存"..BONUS_ROLL_REWARD_MONEY.."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..BONUS_ROLL_REWARD_MONEY.."\124r"
				local txt2 = "SHIFT+"..KEY_BUTTON1.."-\124cff00FFFF"..NewItemTypeLsit[ib][3]..MAXIMUM..BANK_DEPOSIT_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."\124r\n".."SHIFT+"..KEY_BUTTON2.."-\124cff00FFFF"..NewItemTypeLsit[ib][3]..MAXIMUM..BANK_WITHDRAW_MONEY_BUTTON_LABEL..BONUS_ROLL_REWARD_MONEY.."\124r"
				PIGEnter(savebut,savebut,txt1,txt2)
			else
				PIGEnter(savebut,KEY_BUTTON1.." \124cff00FF00一键存"..NewItemTypeLsit[ib][3].."\124r\n"..KEY_BUTTON2.." \124cff00FF00一键取"..NewItemTypeLsit[ib][3].."\124r")
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
			if ib==#NewItemTypeLsit and IsShiftKeyDown() then 
				if button=="LeftButton" then
					_G[GnUI]:Show()
					Show_TabBut_R(_G[GnUI].F,fujiF,fujiTabBut)
				else
					_G[GnUI]:Show()
					Show_TabBut_R(_G[GnUI].F,fujiF_Take,fujiTabBut_Take)
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