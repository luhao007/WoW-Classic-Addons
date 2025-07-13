local _, addonTable = ...;
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.AutoSell()
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
	local _GN,_GNE = "出售","Sell"
	local fujiF,fujiTabBut=PIGOptionsList_R(_G[GnUI].F,"售",50,"Left")
	BusinessInfo.ADDScroll(fujiF,_GN,_GNE,17,{false,"AutoSellBuy",_GNE.."_List"})
	local function IsFiltraLsit(data,id)
		for i=1,#data do
			if data[i][1]==id then
				return true
			end
		end
		return false
	end
	local function ExecuteSellFun(data,numall)
		for i=1,#data do
			UseContainerItem(data[i][1], data[i][2]);
		end
		C_Timer.After(0.8,function()
			if not MerchantFrame:IsVisible() or MerchantFrame.selectedTab ~= 1 then return end
			for i=1,#data do
				if not GetContainerItemID(data[i][1], data[i][2]) and data[i][5]==false then
					numall=numall-1
					data[i][5]=true
				end
			end
			if numall>0 then
				ExecuteSellFun(data,numall)
			else
				local sellALLG = 0
				for i=1,#data do
					sellALLG=sellALLG+data[i][4]
					PIG_print("|cFF7FFFAA".._GN.."|r: "..data[i][3])
				end
				if sellALLG>0 then
					PIG_print("|cFF7FFFAA本次".._GN..#data.."件获得:|r " .. GetCoinTextureString(sellALLG));
				end
				MerchantFrame.pigfuusell=nil
			end
		end)
	end
	local function StartSellItem()
		if not MerchantFrame:IsVisible() or MerchantFrame.selectedTab ~= 1 then return end
		local bagSellD = {}
		local Selldata = PIGA["AutoSellBuy"][_GNE.."_List"]
		local FiltradataX = PIGA["AutoSellBuy"][_GNE.."_Lsit_Filtra"]
		for bag = 0, bagIDMax do
			for slot = 1, GetContainerNumSlots(bag) do
				local itemID, itemLink, icon, itemCount, quality, noValue = PIGGetContainerItemInfo(bag, slot)
				if itemID then
					if noValue==false then
						if quality==0 then
							if not IsFiltraLsit(FiltradataX,itemID) then
								local sellPrice= select(11, GetItemInfo(itemID))
								table.insert(bagSellD,{bag, slot,itemLink,sellPrice*itemCount,false})
							end
						end
						--非灰
						for i=1,#Selldata do
							if itemID==Selldata[i][1] then
								local sellPrice= select(11, GetItemInfo(itemID))
								table.insert(bagSellD,{bag, slot,itemLink,sellPrice*itemCount,false})
							end
						end
					end
				end
			end
		end
		ExecuteSellFun(bagSellD,#bagSellD)
	end
	MerchantFrame:HookScript("OnShow",function (self)
		if PIGA["AutoSellBuy"][_GNE.."_Open"] then
			self.pigfuusell=true
			StartSellItem()
		end
	end);
	MerchantFrame:HookScript("OnHide",function (self)
		MerchantFrame.pigfuusell=nil
	end);
	fujiF.Sell_Open = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{"自动".._GN, "打开商人界面自动".._GN.."灰色物品和下方列表内的物品"})
	fujiF.Sell_Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_Open"]=true;
		else
			PIGA["AutoSellBuy"][_GNE.."_Open"]=false;
		end
	end);
	---
	local function  Add_MerchantBut()
		if PIGA["AutoSellBuy"][_GNE.."_But"] and not MerchantFrame.Sell then 
			MerchantFrame.Sell = PIGButton(MerchantFrame,{"TOPLEFT",MerchantFrame,"TOPLEFT",56,-30},{50,24},_GN,nil,nil,nil,nil,0);
			PIGEnter(MerchantFrame.Sell,KEY_BUTTON1.."-卖垃圾和预设".._GN.."物品\n"..KEY_BUTTON2.."-设置".._GN.."清单")  
			MerchantFrame.Sell:SetScript("OnClick", function (self,button)
				if button=="LeftButton" then
					StartSellItem()
				else
					_G[GnUI]:Show()
					Show_TabBut_R(_G[GnUI].F,fujiF,fujiTabBut)
				end
			end)
			hooksecurefunc("PanelTemplates_SetTab", function(frame, id)
				if id==1 then
					MerchantFrame.Sell:Show()
				else
					MerchantFrame.Sell:Hide()
				end
			end)
		end
		if MerchantFrame.Sell then
			MerchantFrame.Sell:SetShown(PIGA["AutoSellBuy"][_GNE.."_But"])
		end
	end
	Add_MerchantBut()
	fujiF.Sell_But = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{_GN.."按钮", "在商人界面增加一个".._GN.."按钮(可以点击".._GN.."灰色物品和下方列表内的物品)"})
	fujiF.Sell_But:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_But"]=true;	
		else
			PIGA["AutoSellBuy"][_GNE.."_But"]=false;
		end
		 Add_MerchantBut();	
	end);
	fujiF.Sell_Tishi = PIGCheckbutton(fujiF,{"LEFT",fujiF.Sell_But,"RIGHT",110,0},{_GN.."记录", "在聊天栏显示".._GN.."记录"})
	fujiF.Sell_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_Tishi"]=true;
		else
			PIGA["AutoSellBuy"][_GNE.."_Tishi"]=false;
		end
	end);
	--
	fujiF:HookScript("OnShow", function (self)
		self.Sell_Open:SetChecked(PIGA["AutoSellBuy"][_GNE.."_Open"])
		self.Sell_Tishi:SetChecked(PIGA["AutoSellBuy"][_GNE.."_Tishi"])
		self.Sell_But:SetChecked(PIGA["AutoSellBuy"][_GNE.."_But"]);
	end);
end