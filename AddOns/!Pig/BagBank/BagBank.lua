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
local BagdangeW=bagData.ItemWH
------
local xuanzhuangsanjiao=BagBankfun.xuanzhuangsanjiao
local Bag_Item_lv=BagBankfun.Bag_Item_lv
local Bank_Item_lv=BagBankfun.Bank_Item_lv
local jisuanBANKzongshu=BagBankfun.jisuanBANKzongshu
local jisuanBANKkonmgyu=BagBankfun.jisuanBANKkonmgyu
local Update_BankFrame_Height=BagBankfun.Update_BankFrame_Height
local function UpdateP_BANK(frame, size, id)
	frame.TitleContainer:Hide();
	frame.PortraitContainer:Hide();
	frame.Bg:Hide();
	frame.CloseButton:Hide();
	frame:SetHeight(0);
	frame:SetToplevel(false)
	frame:SetParent(BankSlotsFrame);
	local name = frame:GetName();
	local shang_hang,shang_yushu=jisuanBANKkonmgyu(id)
	local NEWsize=size-shang_yushu
	local hangShu=math.ceil(NEWsize/BankFrame.meihang)
	local new_kongyu,new_hangshu=hangShu*BankFrame.meihang-NEWsize,hangShu+shang_hang
	local buthejiL = {}
	for i, itemButton in frame:EnumerateValidItems() do
		buthejiL[i]=itemButton
	end
	for slot=1,#buthejiL do
		local itemButton = buthejiL[slot]
		itemButton:ClearAllPoints();
		if slot==1 then
			itemButton:SetPoint("TOPRIGHT", BankSlotsFrame, "TOPRIGHT", -new_kongyu*BagdangeW-15.8, -new_hangshu*BagdangeW-18);
		else
			local yushu=math.fmod((slot+new_kongyu-1),BankFrame.meihang)
			local itemFshang = buthejiL[slot-1]
			if yushu==0 then
				itemButton:SetPoint("BOTTOMLEFT", itemFshang, "TOPLEFT", (BankFrame.meihang-1)*BagdangeW, 5);
			else
				itemButton:SetPoint("RIGHT", itemFshang, "LEFT", -5, 0);
			end
		end
	end
	-- 
	Update_BankFrame_Height(BagdangeW)
	Bag_Item_lv(frame, size, id)
end
------------------
local function zhegnheBANK()
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
		hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", function()	
			for i, itemButton in ContainerFrameCombinedBags:EnumerateValidItems() do
				BagBankfun.add_Itemslot_ZLV_ranse(itemButton,BagdangeW)--背包/银行包裹格子
				if PIGA["BagBank"]["JunkShow"] then
					local bagID = itemButton:GetBagID();
					local info = C_Container.GetContainerItemInfo(bagID, itemButton:GetID());
					local quality = info and info.quality;
					itemButton.JunkIcon:Hide();
					if quality and quality==0 then
						itemButton.JunkIcon:Show();
					end
				end
			end
		end)
		for i=1,bagData["bankbag"] do
			local xframe = bagData["bagIDMax"]+i+1
			local framef=_G["ContainerFrame"..xframe];
			hooksecurefunc(framef, "UpdateItems", function()	
				for i, itemButton in framef:EnumerateValidItems() do
					BagBankfun.add_Itemslot_ZLV_ranse(itemButton,BagdangeW)--银行包裹格子
					if PIGA["BagBank"]["JunkShow"] then
						local bagID = itemButton:GetBagID();
						local info = C_Container.GetContainerItemInfo(bagID, itemButton:GetID());
						local quality = info and info.quality;
						itemButton.JunkIcon:Hide();
						if quality and quality==0 then
							itemButton.JunkIcon:Show();
						end
					end
				end
			end)
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
					for i = bagData["bagIDMax"] + 1, NUM_CONTAINER_FRAMES do
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
				if arg1>bagData["bagIDMax"] then
					if BankFrame:IsVisible() then
						Bag_Item_lv(nil, nil, arg1)
					end
				else
					if self:IsVisible() then
						Bag_Item_lv(ContainerFrameCombinedBags, nil, arg1)
					end
				end
			end
		end)

		hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
			if id>bagData["bagIDMax"] then
				UpdateP_BANK(frame, size, id)
			else
				Bag_Item_lv(frame, size, id)
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
		BankFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
		BankFrame:HookScript("OnEvent", function (self,event,arg1)
			if event=="PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
				zhegnheBANK()
				for i=2,#bagData["bankID"] do
					OpenBag(bagData["bankID"][i])
				end
			end
			if event=="PLAYERBANKSLOTS_CHANGED" then
				Bank_Item_lv(BankFrame,nil,arg1)
			end
		end)
		--分类设置
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
			if self.show then
				self.show=false
			else
				self.show=true
			end
			xuanzhuangsanjiao(self.Tex,self.show)
			BankSlotsFrame:Show_Hide_but(self.show)	
		end);
		BagBankfun.addfenleibagbut(BankSlotsFrame,"PIG_CharacterBANK_")
	end	
end