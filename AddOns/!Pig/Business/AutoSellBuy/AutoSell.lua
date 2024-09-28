local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGEnter=Create.PIGEnter
local PIGLine=Create.PIGLine
local PIGFontString=Create.PIGFontString
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
function BusinessInfo.AutoSell()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"卖",50,"Left")
	local gongnengName = "Sell"
	BusinessInfo.ADDScroll(fujiF,"出售",gongnengName,17,{false,"AutoSellBuy",gongnengName.."_List"})
	local function IsFiltraLsit(data,id)
		for i=1,#data do
			if data[i][1]==id then
				return true
			end
		end
		return false
	end
	local function shoumailaji()
		if ( MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 ) then
			fujiF.shoumaiShuliang = 0;
			local dataX = PIGA["AutoSellBuy"][gongnengName.."_List"]
			local FiltradataX = PIGA["AutoSellBuy"][gongnengName.."_Lsit_Filtra"]
			for bag = 0, bagIDMax do
				for slot = 1, GetContainerNumSlots(bag) do
					local itemID, itemLink, icon, itemCount, quality, noValue = PIGGetContainerItemInfo(bag, slot)
					if itemID then
						if noValue==false then
								if quality==0 then
									if not IsFiltraLsit(FiltradataX,itemID) then
										local sellPrice= select(11, GetItemInfo(itemID))
										UseContainerItem(bag, slot);
										fujiF.shoumaiData[bag..slot]={itemLink,sellPrice*itemCount}
										fujiF.shoumaiShuliang = fujiF.shoumaiShuliang+1
									end
								end
								--非灰
								for i=1,#dataX do
									if itemID==dataX[i][1] then
										local sellPrice= select(11, GetItemInfo(itemID))
										UseContainerItem(bag, slot);
										fujiF.shoumaiData[bag..slot]={itemLink,sellPrice*itemCount}
										fujiF.shoumaiShuliang = fujiF.shoumaiShuliang+1
									end
								end
						end
					end
				end
			end
			if fujiF.shoumaiShuliang>0 then
				C_Timer.After(0.6,shoumailaji)
				return
			end
			if PIGA["AutoSellBuy"][gongnengName.."_Tishi"] then
				local fujiF_shoumaiData_G = 0
				for k,v in pairs(fujiF.shoumaiData) do
					print("|cFF7FFFAA出售|r: " ..v[1])
					fujiF_shoumaiData_G=fujiF_shoumaiData_G+v[2]
				end
				if fujiF_shoumaiData_G>0 then
					PIG_print("|cFF7FFFAA本次售卖获得:|r " .. GetCoinTextureString(fujiF_shoumaiData_G));
				end
			end
		end
	end
	--自动卖垃圾
	local function Sell_Open()
		MerchantFrame:HookScript("OnShow",function (self,event)
			if PIGA["AutoSellBuy"][gongnengName.."_Open"] then
				fujiF.shoumaiData = {};
				shoumailaji()
			end
		end);
	end
	if PIGA["AutoSellBuy"][gongnengName.."_Open"] then Sell_Open() end
	fujiF.Sell_Open = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{"自动出售", "打开商人界面自动售卖灰色物品和下方列表内的物品"})
	fujiF.Sell_Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][gongnengName.."_Open"]=true;
		else
			PIGA["AutoSellBuy"][gongnengName.."_Open"]=false;
		end
	end);
	---出售按钮
	local function Sell_But_Open()
		if MerchantFrame.Sell then
			if PIGA["AutoSellBuy"][gongnengName.."_But"] then
				MerchantFrame.Sell:Show()
			else
				MerchantFrame.Sell:Hide()
			end
		else
			MerchantFrame.Sell = PIGButton(MerchantFrame,{"TOPLEFT",MerchantFrame,"TOPLEFT",56,-30},{60,22},"出售");
			PIGEnter(MerchantFrame.Sell,KEY_BUTTON1.."-卖垃圾和预设出售物品\n"..KEY_BUTTON2.."-设置出售清单")  
			MerchantFrame.Sell:SetScript("OnClick", function (self,button)
				if button=="LeftButton" then
					shoumailaji()
				else
					AutoSellBuy_UI:Show()
					Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
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
	end
	if PIGA["AutoSellBuy"][gongnengName.."_But"] then Sell_But_Open() end
	fujiF.Sell_But = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{"出售按钮", "在商人界面增加一个出售按钮(可以点击出售灰色物品和下方列表内的物品)"})
	fujiF.Sell_But:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][gongnengName.."_But"]=true;	
		else
			PIGA["AutoSellBuy"][gongnengName.."_But"]=false;
		end
		Sell_But_Open();	
	end);
	fujiF.Sell_Tishi = PIGCheckbutton(fujiF,{"LEFT",fujiF.Sell_But,"RIGHT",110,0},{"出售记录", "在聊天栏显示出售记录"})
	fujiF.Sell_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][gongnengName.."_Tishi"]=true;
		else
			PIGA["AutoSellBuy"][gongnengName.."_Tishi"]=false;
		end
	end);
	--
	fujiF:HookScript("OnShow", function (self)
		self.Sell_Open:SetChecked(PIGA["AutoSellBuy"][gongnengName.."_Open"])
		self.Sell_Tishi:SetChecked(PIGA["AutoSellBuy"][gongnengName.."_Tishi"])
		self.Sell_But:SetChecked(PIGA["AutoSellBuy"][gongnengName.."_But"]);
	end);
end