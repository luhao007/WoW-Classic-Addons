local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGEnter=Create.PIGEnter
local PIGLine=Create.PIGLine
local PIGCloseBut=Create.PIGCloseBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local Show_TabBut_R=Create.Show_TabBut_R
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
local UseContainerItem =C_Container.UseContainerItem
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
--
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.AutoBuy()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"购",60,"Left")
	local Width = fujiF:GetWidth()-20;
	BusinessInfo.ADDScroll(fujiF,"购买","Buy",17,PIGA_Per["AutoSellBuy"]["Buy_List"],{true,"AutoSellBuy","Buy_List"})
	--------------
	local function goumaihanshu(i, ii,xuyaogoumaishu,dataY)
		if xuyaogoumaishu>dataY[i][5] then
			BuyMerchantItem(ii,dataY[i][5])
			xuyaogoumaishu=xuyaogoumaishu-dataY[i][5]
			if xuyaogoumaishu>0 then
				goumaihanshu(i,ii,xuyaogoumaishu,dataY)
			end
		else
			BuyMerchantItem(ii, xuyaogoumaishu)
		end
	end
	--------------------------------
	local function jisuanBAGshuliang(QitemID)
		local zongjiBAGitemCount=0
		for bag = 0, bagIDMax do
			for slot = 1, GetContainerNumSlots(bag) do
				local itemID, itemLink, icon, itemCount = PIGGetContainerIDlink(bag, slot)
				if itemID then
					if QitemID==itemID then
						zongjiBAGitemCount=zongjiBAGitemCount+itemCount
					end
				end
			end
		end
		return zongjiBAGitemCount
	end
	---------------------------------
	local function Buy_item()
		if ( MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 ) then
			local dataY = PIGA_Per["AutoSellBuy"]["Buy_List"]
			local price_itempriceG=0
			for i=1,#dataY do
				local goumaiItem=dataY[i][1]
				local xuyaogoumaishu=dataY[i][4];--预设购买数
				local yiyoushuliang=jisuanBAGshuliang(goumaiItem);--已有数量
				local shijigoumai=xuyaogoumaishu-yiyoushuliang;--实际需要补货数量
				if shijigoumai>0 then
					local numItems = GetMerchantNumItems();
					for ii=1,numItems do
						if goumaiItem==GetMerchantItemID(ii) then
							local name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost= GetMerchantItemInfo(ii)
							price_itempriceG=price_itempriceG+price
							if numAvailable==(-1) then
								goumaihanshu(i,ii,shijigoumai,dataY)
								if PIGA["AutoSellBuy"]["Buy_Tishi"] then
									PIG_print("|cFF00ff00执行自动补货:|r "..PIGA_Per["AutoSellBuy"]["Buy_List"][i][2].." |cFF00ff00补货数量:|r"..shijigoumai);
								end
							else
								if shijigoumai>numAvailable then
									BuyMerchantItem(ii,numAvailable)
									if PIGA["AutoSellBuy"]["Buy_Tishi"] then
										PIG_print("|cFF00ff00商家物品限购:|r "..PIGA_Per["AutoSellBuy"]["Buy_List"][i][2].." |cFF00ff00抢购数量:|r"..numAvailable);
									end
								else
									goumaihanshu(i,ii,shijigoumai,dataY)
									if PIGA["AutoSellBuy"]["Buy_Tishi"] then
										PIG_print("|cFF00ff00执行自动补货:|r "..PIGA_Per["AutoSellBuy"]["Buy_List"][i][2].." |cFF00ff00补货数量:|r"..shijigoumai);
									end
								end
							end	
						end
					end
				end		
			end
			if price_itempriceG>0 then
				PIG_print("|cFF00ff00本次补货花费:|r "..GetMoneyString(price_itempriceG));
			end
		end
	end
	----
	local function Buy_Open()
		MerchantFrame:HookScript("OnShow",function (self)
			if fujiF.Buy_Open:GetChecked() then
				Buy_item()
			end
		end);
	end
	fujiF.Buy_Open = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{"自动购买下方列表物品|cff00FFFF(角色配置)|r", "打开商人界面自动购买下方列表物品"})
	fujiF.Buy_Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Buy_Open"]=true;
			Buy_Open()
		else
			PIGA["AutoSellBuy"]["Buy_Open"]=false;
		end
	end);
	if PIGA["AutoSellBuy"]["Buy_Open"] then
		fujiF.Buy_Open:SetChecked(true)
		Buy_Open()
	end
	--
	local function Buy_But_Open()
		if MerchantFrame.Buy then
			if PIGA["AutoSellBuy"]["Buy_But"] then
				MerchantFrame.Buy:Show()
			else
				MerchantFrame.Buy:Hide()
			end
		else
			MerchantFrame.Buy = PIGButton(MerchantFrame,{"TOPLEFT",MerchantFrame,"TOPLEFT",124,-30},{44,22},"购买")
			PIGEnter(MerchantFrame.Buy,KEY_BUTTON1.."-购买预设物资\n"..KEY_BUTTON2.."-设置购买清单")
			MerchantFrame.Buy:SetScript("OnClick", function (self,button)
				if button=="LeftButton" then
					Buy_item()
				else
					AutoSellBuy_UI:Show()
					Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
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
	end
	fujiF.Buy_But = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{"购买按钮", "在商人界面增加一个购买按钮(可以点击购买下方列表内的物品)"})
	fujiF.Buy_But:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Buy_But"]=true;	
		else
			PIGA["AutoSellBuy"]["Buy_But"]=false;
		end
		Buy_But_Open();	
	end);
	if PIGA["AutoSellBuy"]["Buy_But"] then
		fujiF.Buy_But:SetChecked(true);
		Buy_But_Open();
	end
	---
	fujiF.Buy_Tishi = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",140,-44},{"聊天栏购买记录", "在聊天栏显示购买记录"})
	fujiF.Buy_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Buy_Tishi"]=true;
		else
			PIGA["AutoSellBuy"]["Buy_Tishi"]=false;
		end
	end);
	fujiF.Buy_Tishi:SetChecked(PIGA["AutoSellBuy"]["Buy_Tishi"])
end