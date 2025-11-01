local _, addonTable = ...;
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.AutoBuy()
	local L=addonTable.locale
	local Create=addonTable.Create
	local PIGButton = Create.PIGButton
	local PIGEnter=Create.PIGEnter
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local Show_TabBut_R=Create.Show_TabBut_R
	--
	local GetContainerNumSlots = C_Container.GetContainerNumSlots
	local GetContainerItemID=GetContainerItemID or C_Container and C_Container.GetContainerItemID
	local GetContainerItemLink = C_Container.GetContainerItemLink
	local PickupContainerItem =C_Container.PickupContainerItem
	local UseContainerItem =C_Container.UseContainerItem
	local bagIDMax= addonTable.Data.bagData["bagIDMax"]
	---
	local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
	local _GN,_GNE = "购买","Buy"
	local fujiF,fujiTabBut=PIGOptionsList_R(_G[GnUI].F,"购",50,"Left")
	BusinessInfo.ADDScroll(fujiF,_GN,_GNE,17,{true,"AutoSellBuy",_GNE.."_List"})
	-----------
	local function GetBagItemCount(QitemID)
		local zongjiBAGitemCount=0
		for bag = 0, bagIDMax do
			for slot = 1, GetContainerNumSlots(bag) do
				local itemID, itemLink, icon, itemCount = PIGGetContainerItemInfo(bag, slot)
				if itemID then
					if QitemID==itemID then
						zongjiBAGitemCount=zongjiBAGitemCount+itemCount
					end
				end
			end
		end
		return zongjiBAGitemCount
	end
	local function ExecuteBuyFun(datax)
		if datax[8]>datax[4] then
			BuyMerchantItem(datax[2],datax[4])
			datax[8]=datax[8]-datax[4]
		else
			BuyMerchantItem(datax[2],datax[8])
			datax[8]=0
		end
		C_Timer.After(0.5,function()
			if datax[8]>0 then
				ExecuteBuyFun(datax)
			else
				if PIGA["AutoSellBuy"][_GNE.."_Tishi"] then
					if datax[1] then
						PIG_print("|cFF00ff00抢购:|r "..datax[7].." |cFF00ff00数量:|r"..datax[3].."|cFF00ff00花费:|r"..GetMoneyString(datax[6]*datax[3]));
					else
						PIG_print("|cFF00ff00补货:|r "..datax[7].." |cFF00ff00数量:|r"..datax[3].."|cFF00ff00花费:|r"..GetMoneyString(datax[6]*datax[3]));
					end
				end
			end
		end)
	end
	local function StartBuyItem()
		if not MerchantFrame:IsVisible() or MerchantFrame.selectedTab ~= 1 then return end
		local Buydata = PIGA_Per["AutoSellBuy"][_GNE.."_List"]
		if #Buydata==0 then return end
		local BuyAllData={cost=0,Data={}}
		for i=1,#Buydata do
			local BuyItemID=Buydata[i][1]--ID
			local SetMaxNum=Buydata[i][4]--设置库存数
			local duidieNum=Buydata[i][5]--堆叠数
			for ii=1,GetMerchantNumItems() do
				if BuyItemID==GetMerchantItemID(ii) then
					local oldbagNum=GetBagItemCount(BuyItemID);
					local buyNum=SetMaxNum-oldbagNum;--需要补货数量
					if buyNum>0 then
						local link = GetMerchantItemLink(ii)
						local name, texture, price, quantity, numAvailable= GetMerchantItemInfo(ii)
						local itemcostG=price/quantity
						if numAvailable==(-1) then
							table.insert(BuyAllData.Data,{false,ii,buyNum,duidieNum,BuyItemID,itemcostG,link,buyNum})
						else
							if buyNum>numAvailable then
								table.insert(BuyAllData.Data,{true,ii,numAvailable,duidieNum,BuyItemID,itemcostG,link,numAvailable})
							else
								table.insert(BuyAllData.Data,{false,ii,buyNum,duidieNum,BuyItemID,itemcostG,link,buyNum})
							end
						end
					end
				end
			end	
		end
		for i=1,#BuyAllData.Data do
			ExecuteBuyFun(BuyAllData.Data[i])
		end
	end
	local function StartBuyItem_After()
		if MerchantFrame.pigfuusell then
			C_Timer.After(0.1,StartBuyItem_After)
		else
			StartBuyItem()
		end
	end
	MerchantFrame:HookScript("OnShow",function (self)
		if PIGA["AutoSellBuy"][_GNE.."_Open"] then
			StartBuyItem_After()
		end
	end);
	fujiF.Buy_Open = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{"自动".._GN.."|cff00FFFF(角色)|r", "打开商人界面自动".._GN.."下方列表物品|cff00FFFF(设置为单个角色独享)|r"})
	fujiF.Buy_Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_Open"]=true;
		else
			PIGA["AutoSellBuy"][_GNE.."_Open"]=false;
		end
	end);
	--
	local function Add_MerchantBut()
		if PIGA["AutoSellBuy"][_GNE.."_But"] and not MerchantFrame.Buy then 
			MerchantFrame.Buy = PIGButton(MerchantFrame,{"TOPLEFT",MerchantFrame,"TOPLEFT",120,-30},{50,24},_GN,nil,nil,nil,nil,0)
			PIGEnter(MerchantFrame.Buy,KEY_BUTTON1.."-".._GN.."预设物资\n"..KEY_BUTTON2.."-设置".._GN.."清单")
			MerchantFrame.Buy:SetScript("OnClick", function (self,button)
				if button=="LeftButton" then
					StartBuyItem()
				else
					_G[GnUI]:Show()
					Show_TabBut_R(_G[GnUI].F,fujiF,fujiTabBut)
				end
			end)
			hooksecurefunc("PanelTemplates_SetTab", function(frame, id)
				if id==1 then
					MerchantFrame.Buy:Show()
				else
					MerchantFrame.Buy:Hide()
				end
			end)
		end
		if MerchantFrame.Buy then
			MerchantFrame.Buy:SetShown(PIGA["AutoSellBuy"][_GNE.."_But"])
		end
	end
	Add_MerchantBut()
	fujiF.Buy_But = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{_GN.."按钮", "在商人界面增加一个".._GN.."按钮(可以点击".._GN.."下方列表内的物品)"})
	fujiF.Buy_But:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_But"]=true;	
		else
			PIGA["AutoSellBuy"][_GNE.."_But"]=false;
		end
		Add_MerchantBut();	
	end);
	fujiF.Buy_Tishi = PIGCheckbutton(fujiF,{"LEFT",fujiF.Buy_But,"RIGHT",110,0},{_GN.."记录", "在聊天栏显示".._GN.."记录"})
	fujiF.Buy_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_Tishi"]=true;
		else
			PIGA["AutoSellBuy"][_GNE.."_Tishi"]=false;
		end
	end);
	---	
	fujiF:HookScript("OnShow", function (self)
		self.Buy_Open:SetChecked(PIGA["AutoSellBuy"][_GNE.."_Open"])
		self.Buy_But:SetChecked(PIGA["AutoSellBuy"][_GNE.."_But"]);
		self.Buy_Tishi:SetChecked(PIGA["AutoSellBuy"][_GNE.."_Tishi"])
	end);
end