local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGFontString=Create.PIGFontString
local BagBankFrame=Create.BagBankFrame
--====================================
local InvSlot=addonTable.Data.InvSlot
local bagData=addonTable.Data.bagData
local BagBankfun=addonTable.BagBankfun
----
local wwc,hhc = 24,24
local BagdangeW=30
------
local xuanzhuangsanjiao=BagBankfun.xuanzhuangsanjiao
local Bag_Item_lv=BagBankfun.Bag_Item_lv
local Bag_Item_Ranse=BagBankfun.Bag_Item_Ranse
local Bank_Item_lv=BagBankfun.Bank_Item_lv
local Bank_Item_ranse=BagBankfun.Bank_Item_ranse
local jisuanBANKzongshu=BagBankfun.jisuanBANKzongshu
local jisuanBANKkonmgyu=BagBankfun.jisuanBANKkonmgyu
local Update_BankFrame_Height=BagBankfun.Update_BankFrame_Height
local function UpdateP_BANK(frame, size, id)
	frame.TitleContainer:Hide();
	frame.PortraitContainer:Hide();
	frame.Bg:Hide();
	frame.CloseButton:Hide();
	frame.PortraitButton:Hide();
	frame:SetHeight(0);
	frame:SetToplevel(false)
	frame:SetParent(BankSlotsFrame);
	local name = frame:GetName();
	local shang_hang,shang_yushu=jisuanBANKkonmgyu(id)
	local NEWsize=size-shang_yushu
	local hangShu=math.ceil(NEWsize/BankFrame.meihang)
	local new_kongyu,new_hangshu=hangShu*BankFrame.meihang-NEWsize,hangShu+shang_hang
	for slot=1,size do
		local itemF = _G[name.."Item"..slot]
		itemF:ClearAllPoints();
		if slot==1 then
			itemF:SetPoint("TOPRIGHT", BankSlotsFrame, "TOPRIGHT", -new_kongyu*BagdangeW-15.8, -new_hangshu*BagdangeW-18);
			frame.PortraitButton:ClearAllPoints();
			frame.PortraitButton:SetPoint("TOPRIGHT", BankSlotsFrame, "TOPRIGHT", 40, -(42*(id-bagData["bankID"][2]+1))-8);
			frame.FilterIcon:ClearAllPoints();
			frame.FilterIcon:SetPoint("BOTTOMRIGHT", frame.PortraitButton, "BOTTOMRIGHT", 8, -4);
			if not frame.PortraitButton:IsShown() then frame.FilterIcon:Hide() end
		else
			local yushu=math.fmod((slot+new_kongyu-1),BankFrame.meihang)
			local itemFshang = _G[name.."Item"..(slot-1)]
			if yushu==0 then
				itemF:SetPoint("BOTTOMLEFT", itemFshang, "TOPLEFT", (BankFrame.meihang-1)*BagdangeW, 5);
			else
				itemF:SetPoint("RIGHT", itemFshang, "LEFT", -5, 0);
			end
		end
	end
	Update_BankFrame_Height(BagdangeW)
	Bag_Item_lv(frame, size, id)
	Bag_Item_Ranse(frame, size, id)
end
------------------
local function zhegnheBANK()
	BankItemSearchBox:SetPoint("TOPRIGHT",BankFrame,"TOPRIGHT",-200,-33);
	BankFramePurchaseButton:SetWidth(90)
	BankFramePurchaseButton:ClearAllPoints();
	BankFramePurchaseButton:SetPoint("TOPLEFT", BankFrame, "TOPLEFT", 280, -28);
	BankFramePurchaseButtonText:SetPoint("RIGHT", BankFramePurchaseButton, "RIGHT", -8, 0);
	BankFrameDetailMoneyFrame:ClearAllPoints();
	BankFrameDetailMoneyFrame:SetPoint("RIGHT", BankFramePurchaseButtonText, "LEFT", 6, -1);
	local BKregions1 = {BankFramePurchaseInfo:GetRegions()}
	for i=1,#BKregions1 do
		BKregions1[i]:Hide()
	end
	local BankSlotsFrameReg = {BankSlotsFrame:GetRegions()}
	for i=1,#BankSlotsFrameReg do
		BankSlotsFrameReg[i]:SetAlpha(0)
	end
	for i=1,bagData["bankbag"] do
		BankSlotsFrame["Bag"..i]:SetScale(0.76);
		if i==1 then
			BankSlotsFrame["Bag"..i]:SetPoint("TOPLEFT", BankFrameItem1, "BOTTOMLEFT", 70, 92);
		else
			BankSlotsFrame["Bag"..i]:SetPoint("TOPLEFT", BankSlotsFrame["Bag"..(i-1)], "TOPRIGHT", 0, 0);
		end
	end
	for i = 1, bagData["bankmun"] do
		_G["BankFrameItem"..i]:ClearAllPoints();
		if i==1 then
			_G["BankFrameItem"..i]:SetPoint("TOPLEFT", BankSlotsFrame, "TOPLEFT", 13, -60);
		else
			local yushu=math.fmod(i-1,BankFrame.meihang)
			if yushu==0 then
				_G["BankFrameItem"..i]:SetPoint("TOPLEFT", _G["BankFrameItem"..(i-BankFrame.meihang)], "BOTTOMLEFT", 0, -5);
			else
				_G["BankFrameItem"..i]:SetPoint("LEFT", _G["BankFrameItem"..(i-1)], "RIGHT", 5, 0);
			end
		end
	end
	BankFrame:SetWidth(738)
	BANK_PANELS[1].size.x=738
	Bank_Item_lv()
	Bank_Item_ranse()
end
--================
local XWidth, XHeight =CharacterHeadSlot:GetWidth(),CharacterHeadSlot:GetHeight()
function BagBankfun.Zhenghe(Rneirong,tabbut)
	if not PIGA["BagBank"]["Zhenghe"] or BagBankfun.yizhixingjiazai then return end
	BagBankfun.yizhixingjiazai=true
	--交易打开
	hooksecurefunc("TradeFrame_OnShow", function(self)
		if PIGA["BagBank"]["jiaoyiOpen"] then
			if(UnitExists("NPC"))then OpenAllBags() end
		end
	end);
	if NDui or ElvUI then
	else
		if ContainerFrameCombinedBags:IsShown() then CloseAllBags() end
		if GetCVar("combinedBags")=="0" then SetCVar("combinedBags","1") end
		ContainerFrameCombinedBags.meihang=PIGA["BagBank"]["BAGmeihangshu_retail"]
		ContainerFrameCombinedBags.suofang=PIGA["BagBank"]["BAGsuofangBili"]
		if PIGA["BagBank"]["JunkShow"] then
			for f=1,13 do
				for ff=1,36 do
					local framef = _G["ContainerFrame"..f.."Item"..ff]
					hooksecurefunc(framef, "UpdateJunkItem", function(self,quality, noValue)	
						self.JunkIcon:Hide();
						if quality and quality==0 then
							self.JunkIcon:Show();
						end
					end)
				end
			end
		end
		--背包/银行包裹格子
		for bagui = 1, NUM_CONTAINER_FRAMES do
			for slot = 1, MAX_CONTAINER_ITEMS do
				local famrr=_G["ContainerFrame"..bagui.."Item"..slot]
			    BagBankfun.add_Itemslot_ZLV_ranse(famrr,BagdangeW)
			end
		end
		--银行默认格子
		for slot = 1, bagData["bankmun"] do
			local famrr=_G["BankFrameItem"..slot]
			BagBankfun.add_Itemslot_ZLV_ranse(famrr,BagdangeW)
		end
		--银行打开时关闭背包不关闭银行的背包
		hooksecurefunc("ToggleAllBags", function()
			if PIGA["BagBank"]["Zhenghe"] then
				if BankFrame:IsShown() then
					for i = NUM_TOTAL_BAG_FRAMES + 1, NUM_CONTAINER_FRAMES do
						OpenBag(i)
					end
				end
			end
		end)
		function ContainerFrameCombinedBags:GetColumns()
			if self:IsCombinedBagContainer() then
				return self.meihang
			else
				return 4;
			end
		end
		--缩放
		hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
			ContainerFrameCombinedBags:SetScale(ContainerFrameCombinedBags.suofang)
		end)
		ContainerFrameCombinedBags:RegisterForDrag("LeftButton")
		ContainerFrameCombinedBags:SetMovable(true)
		ContainerFrameCombinedBags:SetClampedToScreen(true)
		ContainerFrameCombinedBags:SetScript("OnDragStart",function(self)
		    self:StartMoving();
		    self:SetUserPlaced(false)
		end)
		ContainerFrameCombinedBags:SetScript("OnDragStop",function(self)
		    self:StopMovingOrSizing()
		    self:SetUserPlaced(false)
		end)
		--调整系统整合背包搜索框
		hooksecurefunc(ContainerFrameCombinedBags, "SetSearchBoxPoint", function()
			BagItemSearchBox:SetWidth(160);
			BagItemSearchBox:SetPoint("TOPLEFT",ContainerFrameCombinedBags,"TOPLEFT",40,-37);
		end)
		--
		ContainerFrameCombinedBags.shezhi = CreateFrame("Button",nil,ContainerFrameCombinedBags, "TruncatedButtonTemplate"); 
		ContainerFrameCombinedBags.shezhi:SetNormalTexture("interface/gossipframe/bindergossipicon.blp"); 
		ContainerFrameCombinedBags.shezhi:SetHighlightTexture(130718);
		ContainerFrameCombinedBags.shezhi:SetSize(wwc-4,hhc-4);
		ContainerFrameCombinedBags.shezhi:SetPoint("TOPLEFT",ContainerFrameCombinedBags,"TOPLEFT",260,-38);
		ContainerFrameCombinedBags.shezhi.Down = ContainerFrameCombinedBags.shezhi:CreateTexture(nil, "OVERLAY");
		ContainerFrameCombinedBags.shezhi.Down:SetTexture(130839);
		ContainerFrameCombinedBags.shezhi.Down:SetAllPoints(ContainerFrameCombinedBags.shezhi)
		ContainerFrameCombinedBags.shezhi.Down:Hide();
		ContainerFrameCombinedBags.shezhi:SetScript("OnMouseDown", function (self)
			self.Down:Show();
		end);
		ContainerFrameCombinedBags.shezhi:SetScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		ContainerFrameCombinedBags.shezhi:SetScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			if Pig_OptionsUI:IsShown() then
				Pig_OptionsUI:Hide()
			else
				Pig_OptionsUI:Show()
				Create.Show_TabBut(Rneirong,tabbut)
			end
		end);
	
		ContainerFrameCombinedBags:RegisterEvent("AUCTION_HOUSE_SHOW")
		ContainerFrameCombinedBags:HookScript("OnEvent", function(self,event,arg1)
			if event=="AUCTION_HOUSE_SHOW" then
				if PIGA["BagBank"]["AHOpen"] then
					if (UnitExists("NPC")) then
						OpenAllBags()
					end
				end
			end
			if event=="BAG_UPDATE" then
				if arg1>=0 and arg1<=bagData["bagIDMax"] then
					if self:IsVisible() then
						Bag_Item_lv(nil, nil, arg1)
						Bag_Item_Ranse(nil, nil, arg1)
					end
				else
					if BankFrame:IsVisible() then
						Bag_Item_lv(nil, nil, arg1)
						Bag_Item_Ranse(nil, nil, arg1)
					end
				end
			end
		end)

		hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
			if id>=0 and id<=(bagData["bagIDMax"]-1) then
				Bag_Item_lv(frame, size, id)
				Bag_Item_Ranse(frame, size, id)
			else
				UpdateP_BANK(frame, size, id)
			end
		end)

		---系统银行========================
		BankFrame.meihang=17 or PIGA["BagBank"]["BANKmeihangshu_retail"]
		BankFrame.suofang=1 or PIGA["BagBank"]["BANKsuofangBili"]
		---可移动
		BankFrame:RegisterForDrag("LeftButton")
		BankFrame:SetMovable(true)
		BankFrame:SetClampedToScreen(true)
		BankFrame:SetScript("OnDragStart",function(self)
		    self:StartMoving();
		    self:SetUserPlaced(false)
		end)
		BankFrame:SetScript("OnDragStop",function(self)
		    self:StopMovingOrSizing()
		    self:SetUserPlaced(false)
		end)
		--分类设置
		for vb=bagData["bagIDMax"]+1,#bagData["bankID"]+1 do
			local fameXX = _G["ContainerFrame"..vb.."PortraitButton"]
			fameXX.ICONpig = fameXX:CreateTexture(nil, "BORDER");
			fameXX.ICONpig:SetTexture();
			fameXX.ICONpig:SetSize(28,28);
			fameXX.ICONpig:SetPoint("TOPLEFT",fameXX,"TOPLEFT",7,-7);
			fameXX.BGpig = fameXX:CreateTexture(nil, "ARTWORK");
			fameXX.BGpig:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
			fameXX.BGpig:SetSize(70,70);
			fameXX.BGpig:SetPoint("TOPLEFT",fameXX,"TOPLEFT",0,0);
			fameXX:SetScript("OnEnter", function (self)
				local fujikj = self:GetParent()
				local hh = {fujikj:GetChildren()} 
				for _,v in pairs(hh) do
					local Vname = v:GetName()
					if Vname then
						if Vname:match("Item") then
							v.BattlepayItemTexture:Show()
						end
					end
				end
			end);
			fameXX:SetScript("OnLeave", function (self)
				local fujikj = self:GetParent()
				local hh = {fujikj:GetChildren()} 
				for _,v in pairs(hh) do
					local Vname = v:GetName()
					if Vname then
						if Vname:match("Item") then
							v.BattlepayItemTexture:Hide()
						end
					end
				end
			end);
		end
		BankSlotsFrame.fenlei = CreateFrame("Button",nil,BankSlotsFrame, "TruncatedButtonTemplate");
		BankSlotsFrame.fenlei:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		BankSlotsFrame.fenlei:SetSize(20,20);
		BankSlotsFrame.fenlei:SetPoint("TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-10,-30);
		BankSlotsFrame.fenlei.Tex = BankSlotsFrame.fenlei:CreateTexture(nil, "BORDER");
		BankSlotsFrame.fenlei.Tex:SetTexture("interface/chatframe/chatframeexpandarrow.blp");
		BankSlotsFrame.fenlei.Tex:SetRotation(0)
		BankSlotsFrame.fenlei.Tex:SetSize(20,20);
		BankSlotsFrame.fenlei.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",2,0);
		BankSlotsFrame.fenlei:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",3,-1);
		end);
		BankSlotsFrame.fenlei:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",2,0);
		end);
		BankSlotsFrame.fenlei.show=false
		BankSlotsFrame.fenlei:SetScript("OnClick",  function (self)
			if BankSlotsFrame.fenlei.show then
				BankSlotsFrame.fenlei.show=false
				xuanzhuangsanjiao(self.Tex,false)
				for vb=2,#bagData["bankID"] do
					local containerFrame, containerShowing = ContainerFrameUtil_GetShownFrameForID(bagData["bankID"][vb]);
					if containerFrame then
						containerFrame.PortraitButton:Hide()
						containerFrame.FilterIcon:Hide()
					end
				end
			else
				BankSlotsFrame.fenlei.show=true
				xuanzhuangsanjiao(self.Tex,true)
				local bagicon={BankSlotsFrame.Bag1.icon:GetTexture(),BankSlotsFrame.Bag2.icon:GetTexture(),BankSlotsFrame.Bag3.icon:GetTexture(),
				BankSlotsFrame.Bag4.icon:GetTexture(),BankSlotsFrame.Bag5.icon:GetTexture(),BankSlotsFrame.Bag6.icon:GetTexture(),BankSlotsFrame.Bag7.icon:GetTexture()}
				for vb=2,#bagData["bankID"] do
					local containerFrame, containerShowing = ContainerFrameUtil_GetShownFrameForID(bagData["bankID"][vb]);
					if containerFrame then
						containerFrame.PortraitButton.ICONpig:SetTexture(bagicon[bagData["bankID"][vb]-5]);
						containerFrame.PortraitButton:Show()
						for k,v in pairs(Enum.BagSlotFlags) do
							local isSet = C_Container.GetBagSlotFlag(bagData["bankID"][vb], v)
							if isSet then
								containerFrame.FilterIcon:Show();
								break;
							end
						end
					end
				end
			end
		end);
		BankSlotsFrame:HookScript("OnHide", function(self)
			self.fenlei.show=false
			xuanzhuangsanjiao(self.fenlei.Tex,false)
		end);
		------
		BankFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
		BankFrame:HookScript("OnEvent", function (self,event,arg1)
			if event=="PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
				zhegnheBANK()
				for i=2,#bagData["bankID"] do
					OpenBag(bagData["bankID"][i])
				end
			end
			if event=="PLAYERBANKSLOTS_CHANGED" then
				Bank_Item_lv(nil,nil,arg1)
				Bank_Item_ranse(nil,nil,arg1)
			end
		end)
	end	
end