local addonName, addonTable = ...;
local L=addonTable.locale
local find = _G.string.find
local ceil = math.ceil
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink=C_Container.GetContainerItemLink
--
local Create=addonTable.Create
local PIGFontString=Create.PIGFontString
local BagBankFrame=Create.BagBankFrame
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local bagData=Data.bagData
local BagBankfun=addonTable.BagBankfun
--==================
local zhengliIcon="interface/containerframe/bags.blp"
local BagdangeW=ContainerFrame1Item1:GetWidth()+5
local wwc,hhc = 24,24
------
local xuanzhuangsanjiao=BagBankfun.xuanzhuangsanjiao
local Bag_Item_lv=BagBankfun.Bag_Item_lv
local Bag_Item_Ranse=BagBankfun.Bag_Item_Ranse
local Bank_Item_lv=BagBankfun.Bank_Item_lv
local Bank_Item_ranse=BagBankfun.Bank_Item_ranse
local jisuanBANKzongshu=BagBankfun.jisuanBANKzongshu
local jisuanBANKkonmgyu=BagBankfun.jisuanBANKkonmgyu
local Update_BankFrame_Height=BagBankfun.Update_BankFrame_Height
--刷新背包LV
local function shuaxin_LV(framef, id, slot)
	if not framef.ZLV then return end
	framef.ZLV:SetText();
	local itemLink = GetContainerItemLink(id, slot)
	if itemLink then
		local _,_,itemQuality,_,_,_,_,_,_,_,_,classID = GetItemInfo(itemLink);
		if itemQuality then
			if classID==2 or classID==4 then
				local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
				framef.ZLV:SetText(effectiveILvl);
				local r, g, b = GetItemQualityColor(itemQuality);
				framef.ZLV:SetTextColor(r, g, b, 1);
			end
		end
	end
end
local function shuaxin_ranse(framef,id,slot)
	if not framef.ranse then return end
	framef.ranse:Hide()
	local itemLink = GetContainerItemLink(id, slot)
	if itemLink then
		local _,_,itemQuality,_,_,_,_,_,_,_,_,classID = GetItemInfo(itemLink);
		if itemQuality and itemQuality>1 then
			if classID==2 or classID==4 then
           		local r, g, b = GetItemQualityColor(itemQuality);
	            framef.ranse:SetVertexColor(r, g, b);
				framef.ranse:Show()
			end
		end
	end
end
---
local function Update_BAGFrame_WidthHeight(new_hangshu)
	_G[BagBankfun.BagUIName]:SetScale(_G[BagBankfun.BagUIName].suofang);
	_G[BagBankfun.BagUIName]:SetWidth(BagdangeW*_G[BagBankfun.BagUIName].meihang+28)
	if new_hangshu then
		_G[BagBankfun.BagUIName]:SetHeight(BagdangeW*new_hangshu+102-_G[BagBankfun.BagUIName].pianyiliangV);
	end
end
local function UpdateP_KEY(frame, size, id)
	local name = frame:GetName();
	frame.Portrait:Show();
	_G[name.."CloseButton"]:Show();
	frame:SetParent(UIParent);
	frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -560, 300);
end
local function jisuanBAGzongshu(id)
	local bagzongshu = 0
	if id>0 then
		for i=1,id do
			local shangnum = GetContainerNumSlots(i-1)
			bagzongshu=bagzongshu+shangnum
		end
	end
	return bagzongshu
end
local function jisuanBAGkonmgyu(id,zongshu)
	local baghangShu,bagkongyu=0,0
	baghangShu,bagkongyu=0,0
	if id>0 then
		baghangShu=ceil(zongshu/_G[BagBankfun.BagUIName].meihang)
		bagkongyu=baghangShu*_G[BagBankfun.BagUIName].meihang-zongshu
	end
	return baghangShu,bagkongyu
end
local function UpdateP_BAG(frame, size, id)
	frame:SetHeight(100);
	frame:SetToplevel(false)
	frame:SetParent(_G[BagBankfun.BagUIName])
	frame.Portrait:Hide();
	local name = frame:GetName();
	_G[name.."Portrait"]:Hide();
	_G[name.."PortraitButton"]:Hide();
	_G[name.."BackgroundTop"]:Hide();
	_G[name.."BackgroundMiddle1"]:Hide();
	_G[name.."BackgroundMiddle2"]:Hide();
	_G[name.."BackgroundBottom"]:Hide();
	_G[name.."Background1Slot"]:Hide();
	_G[name.."Name"]:Hide();
	_G[name.."CloseButton"]:Hide();
	if id==0 then
		paishuID,kongbuID=0,0
		_G[name.."MoneyFrame"]:Show()
		_G[name.."MoneyFrame"]:ClearAllPoints();
		_G[name.."MoneyFrame"]:SetPoint("RIGHT", _G[BagBankfun.BagUIName].moneyframe, "RIGHT", 4, -1);
		_G[name.."MoneyFrame"]:SetParent(_G[BagBankfun.BagUIName]);
	else
		_G[name.."MoneyFrame"]:Hide()
	end
	local shang_allshu=jisuanBAGzongshu(id)
	local shang_hang,shang_yushu=jisuanBAGkonmgyu(id,shang_allshu)
	local NEWsize=size-shang_yushu
	local hangShu=ceil(NEWsize/_G[BagBankfun.BagUIName].meihang)
	local new_kongyu,new_hangshu=hangShu*_G[BagBankfun.BagUIName].meihang-NEWsize,hangShu+shang_hang
	for slot=1,size do
		local itemF = _G[name.."Item"..slot]
		itemF:ClearAllPoints();
		if slot==1 then
			itemF:SetPoint("TOPRIGHT", _G[BagBankfun.BagUIName].wupin, "TOPRIGHT", -(new_kongyu*BagdangeW)-5-_G[BagBankfun.BagUIName].pianyiliangV, -(new_hangshu*BagdangeW)+36);
		else
			local yushu=math.fmod((slot+new_kongyu-1),_G[BagBankfun.BagUIName].meihang)
			local itemFshang = _G[name.."Item"..(slot-1)]
			if yushu==0 then
				itemF:SetPoint("BOTTOMLEFT", itemFshang, "TOPLEFT", (_G[BagBankfun.BagUIName].meihang-1)*BagdangeW, 5);
			else
				itemF:SetPoint("RIGHT", itemFshang, "LEFT", -5, 0);
			end
		end
	end
	Update_BAGFrame_WidthHeight(new_hangshu)
	Bag_Item_lv(frame, size, id)
	Bag_Item_Ranse(frame, size, id)
end
----
local function UpdateP_BANK(frame, size, id)
	frame.Portrait:Hide();
	local name = frame:GetName();
	_G[name.."Portrait"]:Hide();
	_G[name.."PortraitButton"]:Hide();
	_G[name.."MoneyFrame"]:Hide()
	_G[name.."BackgroundTop"]:Hide();
	_G[name.."BackgroundMiddle1"]:Hide();
	_G[name.."BackgroundMiddle2"]:Hide();
	_G[name.."BackgroundBottom"]:Hide();
	_G[name.."Background1Slot"]:Hide();
	_G[name.."Name"]:Hide();
	_G[name.."CloseButton"]:Hide();
	frame:SetHeight(0);
	frame:SetToplevel(false)
	frame:SetParent(BankSlotsFrame);
	local shang_hang,shang_yushu=jisuanBANKkonmgyu(id)
	local NEWsize=size-shang_yushu
	local hangShu=ceil(NEWsize/BankFrame.meihang)
	local new_kongyu,new_hangshu=hangShu*BankFrame.meihang-NEWsize,hangShu+shang_hang
	for slot=1,size do
		local itemF = _G[name.."Item"..slot]
		itemF:ClearAllPoints();
		if slot==1 then
			itemF:SetPoint("TOPRIGHT", BankSlotsFrame, "TOPRIGHT", -new_kongyu*BagdangeW-15, -new_hangshu*BagdangeW-33);
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
local function zhegnheBANK()
	local BKregions = {BankFrame:GetRegions()}
	for i=1,#BKregions do
		if not BKregions[i]:GetName() then
			BKregions[i]:Hide()
		end
	end
	local BKregions0 = {BankSlotsFrame:GetRegions()}
	for i=1,#BKregions0 do
		BKregions0[i]:SetAlpha(0)
	end
	local BKregions1 = {BankFramePurchaseInfo:GetRegions()}
	for i=1,#BKregions1 do
		BKregions1[i]:Hide()
	end
	for i=1,bagData["bankbag"] do
		BankSlotsFrame["Bag"..i]:Hide();
		--BankSlotsFrame["Bag"..i]:SetScale(0.76);
		--BankSlotsFrame["Bag"..i]:ClearAllPoints();
		-- if i==1 then
		-- 	BankSlotsFrame["Bag"..i]:SetPoint("TOPLEFT", BankFrameItem1, "BOTTOMLEFT", 70, 100);
		-- else
		-- 	BankSlotsFrame["Bag"..i]:SetPoint("LEFT", BankSlotsFrame["Bag"..(i-1)], "RIGHT", 0, 0);
		-- end
	end
	for i = 1, bagData["bankmun"] do
		_G["BankFrameItem"..i]:ClearAllPoints();
		if i==1 then
			_G["BankFrameItem"..i]:SetPoint("TOPLEFT", BankSlotsFrame, "TOPLEFT", 26, -76);
		else
			local yushu=math.fmod(i-1,BankFrame.meihang)
			if yushu==0 then
				_G["BankFrameItem"..i]:SetPoint("TOPLEFT", _G["BankFrameItem"..(i-BankFrame.meihang)], "BOTTOMLEFT", 0, -4);
			else
				_G["BankFrameItem"..i]:SetPoint("LEFT", _G["BankFrameItem"..(i-1)], "RIGHT", 5, 0);
			end
		end
	end
	BankFrameTitleText:ClearAllPoints();
	BankFrameTitleText:SetPoint("TOP", BankFrame, "TOP", 0, -15);
	BankFramePurchaseButton:SetWidth(90)
	BankFramePurchaseButton:ClearAllPoints();
	BankFramePurchaseButton:SetPoint("TOPLEFT", BankSlotsFrame, "TOPLEFT", 69, -11.6);
	BankFramePurchaseButtonText:SetPoint("RIGHT", BankFramePurchaseButton, "RIGHT", -8, 0);
	BankFrameDetailMoneyFrame:ClearAllPoints();
	BankFrameDetailMoneyFrame:SetPoint("RIGHT", BankFramePurchaseButtonText, "LEFT", 6, -1);
	BankCloseButton:SetPoint("CENTER", BankFrame, "TOPRIGHT", -11, -22);
	BankFrameMoneyFrame:SetPoint("BOTTOMRIGHT", BankFrame, "BOTTOMRIGHT", -10, 11);
	Update_BankFrame_Height(BagdangeW)
	Bank_Item_lv()
	Bank_Item_ranse()
end
-------
local function add_Itemslot_ZLV_ranse(famrr)		
	if not famrr.ZLV then
		famrr.ZLV = PIGFontString(famrr,{"TOPLEFT", famrr, "TOPLEFT", -1, -1},nil,"OUTLINE",15)
		famrr.ZLV:SetDrawLayer("OVERLAY", 7)
	end
	if not famrr.ranse then
		famrr.ranse = famrr:CreateTexture(nil, "OVERLAY");
	    famrr.ranse:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
	    famrr.ranse:SetBlendMode("ADD");
	    famrr.ranse:SetSize(BagdangeW*1.63, BagdangeW*1.63);
	    famrr.ranse:SetPoint("CENTER", famrr, "CENTER", 0, 0);
	    famrr.ranse:Hide()
	end
end
---
function BagBankfun.Zhenghe(Rneirong,tabbut)
	if not PIGA["BagBank"]["Zhenghe"] or BagBankfun.yizhixingjiazai then return end
	BagBankfun.yizhixingjiazai=true
	BagBankfun.qiyongzidongzhengli()
	--交易打开
	hooksecurefunc("TradeFrame_OnShow", function(self)
		if PIGA["BagBank"]["jiaoyiOpen"] then
			if(UnitExists("NPC"))then OpenAllBags() end
		end
	end);
	hooksecurefunc("ContainerFrame_Update", function(frame)
		if not PIGA["BagBank"]["JunkShow"] then return end
		local id = frame:GetID();
		local name = frame:GetName();
		for i=1, frame.size, 1 do
			local itemButton = _G[name.."Item"..i];
			local itemID, itemLink, icon, stackCount, quality=PIGGetContainerItemInfo(id,itemButton:GetID())
			if quality and quality==0 then
				itemButton.JunkIcon:Show();
			end
		end
	end)
	--背包/银行包裹格子
	for bagui = 1, NUM_CONTAINER_FRAMES do
		for slot = 1, MAX_CONTAINER_ITEMS do
			local famrr=_G["ContainerFrame"..bagui.."Item"..slot]
		    add_Itemslot_ZLV_ranse(famrr)
		end
	end
	--银行默认格子
	for slot = 1, bagData["bankmun"] do
		local famrr=_G["BankFrameItem"..slot]
		add_Itemslot_ZLV_ranse(famrr)
	end
	-----
	local uidata = {
		["ButW"]=BagdangeW,
		["meihang"]=PIGA["BagBank"]["BAGmeihangshu"]+BagBankfun.BAGmeihangshu,
		["suofang"]=PIGA["BagBank"]["BAGsuofangBili"],
	}
	Data.UILayout[BagBankfun.BagUIName]={"CENTER","CENTER",420,-10}
	local BAGheji=BagBankFrame(UIParent,nil,BagBankfun.BagUIName,uidata)
	Create.PIG_SetPoint(BagBankfun.BagUIName)
	BAGheji:SetToplevel(true)
	BAGheji:HookScript("OnHide",function(self)
		CloseAllBags()
	end)
	BAGheji.pianyiliangV=0
	if NDui or ElvUI then
		BAGheji.pianyiliangV=8
	end
	if BAGheji.portrait then SetPortraitTexture(BAGheji.portrait, "player") end
	BAGheji.biaoti = PIGFontString(BAGheji,{"TOP", BAGheji, "TOP",10, -14+BAGheji.pianyiliangV},PIG_OptionsUI.AllName)
	BAGheji.Close:HookScript("OnClick",  function (self)
		CloseAllBags()
	end);
	BAGheji.Search = CreateFrame("EditBox", nil, BAGheji, "BagSearchBoxTemplate");
	BAGheji.Search:SetSize(120,hhc);
	BAGheji.Search:SetPoint("TOPLEFT",BAGheji,"TOPLEFT",78,-37+BAGheji.pianyiliangV);

	BAGheji.AutoSort = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate");
	BAGheji.AutoSort:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");
	BAGheji.AutoSort:SetSize(wwc-2,hhc-2);
	BAGheji.AutoSort:SetPoint("TOPRIGHT",BAGheji,"TOPRIGHT",-40,-38+BAGheji.pianyiliangV);
	BAGheji.AutoSort.Tex = BAGheji.AutoSort:CreateTexture();
	BAGheji.AutoSort.Tex:SetTexture(zhengliIcon);
	BAGheji.AutoSort.Tex:SetTexCoord(0.168,0.27,0.837,0.934);
	BAGheji.AutoSort.Tex:SetAllPoints(BAGheji.AutoSort)
	BAGheji.AutoSort.Tex1 = BAGheji.AutoSort:CreateTexture();
	BAGheji.AutoSort.Tex1:SetTexture(zhengliIcon);
	BAGheji.AutoSort.Tex1:SetTexCoord(0.008,0.11,0.86,0.958);
	BAGheji.AutoSort.Tex1:SetAllPoints(BAGheji.AutoSort)
	BAGheji.AutoSort.Tex1:Hide();
	BAGheji.AutoSort:SetScript("OnMouseDown", function (self)
		self.Tex:Hide();
		self.Tex1:Show();
	end);
	BAGheji.AutoSort:SetScript("OnMouseUp", function (self)
		self.Tex:Show();
		self.Tex1:Hide();
	end);
	BAGheji.AutoSort:SetScript("OnClick",  function (self)
		PlaySoundFile(567463, "Master")
		BagBankfun.SortBags()
	end);
	---
	BAGheji.EqBut = BagBankfun.addEquipmentbut(BAGheji,{"TOPRIGHT",BAGheji,"TOPRIGHT",-74,-39+BAGheji.pianyiliangV})
	---
	BAGheji.Setings = BagBankfun.addSetbut(BAGheji,{"TOPRIGHT",BAGheji,"TOPRIGHT",-104,-39+BAGheji.pianyiliangV},Rneirong,tabbut)
	
	--分类设置
	BAGheji.fenlei = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate");
	BAGheji.fenlei:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	BAGheji.fenlei:SetSize(wwc-8,hhc-6);
	BAGheji.fenlei:SetPoint("TOPRIGHT",BAGheji,"TOPRIGHT",-6,-42+BAGheji.pianyiliangV);
	BAGheji.fenlei.Tex = BAGheji.fenlei:CreateTexture(nil, "BORDER");
	BAGheji.fenlei.Tex:SetAtlas("common-icon-forwardarrow")
	BAGheji.fenlei.Tex:SetSize(wwc-4,wwc-7);
	BAGheji.fenlei.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",2,0);
	BAGheji.fenlei:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",3,-1);
	end);
	BAGheji.fenlei:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",2,0);
	end);
	BAGheji.fenlei.show=false
	BAGheji.fenlei:SetScript("OnClick",  function (self)
		if self.show then
			self.show=false
		else
			self.show=true
		end
		xuanzhuangsanjiao(self.Tex,self.show)
		BAGheji:Show_Hide_but(self.show)
	end);
	BagBankfun.addfenleibagbut(BAGheji,"PIG_CharacterBag_")
	--钥匙
	BAGheji.key = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate");
	BAGheji.key:SetNormalTexture("interface/buttons/ui-button-keyring.blp"); 
	BAGheji.key:SetPushedTexture("interface/buttons/ui-button-keyring-down.blp")
	BAGheji.key:SetHighlightTexture("interface/buttons/ui-button-keyring-highlight.blp");
	BAGheji.key:GetNormalTexture():SetTexCoord(0,0.5625,0,0.609375)
	BAGheji.key:GetPushedTexture():SetTexCoord(0,0.5625,0,0.609375)
	BAGheji.key:GetHighlightTexture():SetTexCoord(0,0.5625,0,0.609375)
	BAGheji.key:GetNormalTexture():SetRotation(math.rad(90), {x=0.5, y=0.5})
	BAGheji.key:GetPushedTexture():SetRotation(math.rad(90), {x=0.5, y=0.5})
	BAGheji.key:GetHighlightTexture():SetRotation(math.rad(90), {x=0.5, y=0.5})
	BAGheji.key:SetSize(wwc-7,hhc+10);
	BAGheji.key:SetPoint("BOTTOMLEFT",BAGheji,"BOTTOMLEFT",30,1);
	BAGheji.key:SetHitRectInsets(-8,-8,5,5);
	BAGheji.key:SetScript("OnClick",  function (self)
		if (CursorHasItem()) then
			PutKeyInKeyRing();
		else
			ToggleBag(KEYRING_CONTAINER);
		end
	end);
	---=====================
	if PIG_MaxTocversion(30000,true) then
		hooksecurefunc("ManageBackpackTokenFrame", function(backpack)
			BackpackTokenFrame:ClearAllPoints();
			BackpackTokenFrame:SetPoint("TOPRIGHT", _G[BagBankfun.BagUIName].moneyframe, "TOPLEFT", -4, 5);
			BackpackTokenFrame:SetParent(_G[BagBankfun.BagUIName]);
			local regions = { BackpackTokenFrame:GetRegions() }
			for gg=1,#regions do
				regions[gg]:Hide()
				--regions[gg]:SetTexCoord(0.05,0.8,0,0.74);
			end	
			if (not backpack) then
				backpack = GetBackpackFrame();
			end
			if backpack then
				backpack:SetHeight(0);
			end
		end)
	end
	local old_ToggleAllBags=ToggleAllBags
	ToggleAllBags=function()
		if ( not UIParent:IsShown() ) then
			return;
		end
		if ( IsBagOpen(0) ) then	
			CloseAllBags()
		else
			if IsBagOpen(-2) then  _G["ContainerFrame"..IsBagOpen(-2)]:Hide() end
			for f=1,#bagData["bagID"] do
				OpenBag(bagData["bagID"][f])
			end
			BAGheji:Show()
		end
	end
	local function PIGIsBagOpen()
		for f=1,#bagData["bagID"] do
			if ( IsBagOpen(bagData["bagID"][f]) ) then
				return true
			end
		end
		return false
	end
	hooksecurefunc("ToggleBackpack", function()--B按键打开行囊
		if IsBagOpen(-2) then  _G["ContainerFrame"..IsBagOpen(-2)]:Hide() end
		if IsBagOpen(0) then
			for f=2,#bagData["bagID"] do
				OpenBag(bagData["bagID"][f])
			end
			BAGheji:Show()
		else
			CloseAllBags()
			if BankFrame:IsShown() then
				for f=2,#bagData["bankID"] do
					OpenBag(bagData["bankID"][f])
				end
			end
		end
	end);
	hooksecurefunc("ToggleBag", function(id)--单个背包按键或点击打开
		if id>0 and id<=bagData["bagID"][#bagData["bagID"]] then
			if IsBagOpen(-2) then  _G["ContainerFrame"..IsBagOpen(-2)]:Hide() end
			if IsBagOpen(id) then
				CloseAllBags()
				OpenAllBags()
				BAGheji:Show()
			else
				CloseAllBags()
			end
		end
	end);
	--行囊关闭时追加关闭背景
	hooksecurefunc("CloseBackpack", function()
		BAGheji:Hide()
	end);
	UIParent:HookScript("OnHide", function(self)
		BAGheji:Hide()
	end)
	-------------------
	local function _ContainerFrame_Update(frame)
		local id = frame:GetID();
		local name = frame:GetName();
		local itemButton,quality
		for i=1, frame.size, 1 do
			itemButton = _G[name.."Item"..i];
			local info = C_Container.GetContainerItemInfo(id, itemButton:GetID());
			quality = info and info.quality;
			local isNewItem = C_NewItems.IsNewItem(id, itemButton:GetID());
			newItemTexture = _G[name.."Item"..i].NewItemTexture;
			flash = _G[name.."Item"..i].flashAnim;
			newItemAnim = _G[name.."Item"..i].newitemglowAnim;
			if ( isNewItem ) then
				if (quality and NEW_ITEM_ATLAS_BY_QUALITY[quality]) then
					newItemTexture:SetAtlas(NEW_ITEM_ATLAS_BY_QUALITY[quality]);
				else
					newItemTexture:SetAtlas("bags-glow-white");
				end
				newItemTexture:Show();
				if (not flash:IsPlaying() and not newItemAnim:IsPlaying()) then
					flash:Play();
					newItemAnim:Play();
				end
			else
				newItemTexture:Hide();
				if (flash:IsPlaying() or newItemAnim:IsPlaying()) then
					flash:Stop();
					newItemAnim:Stop();
				end
			end
		end
	end
	BAGheji:HookScript("OnShow",function(self)
		if not PIGA['BagBank']["NewItem"] then return end
		for i = 1, NUM_CONTAINER_FRAMES, 1 do
			local frame = _G["ContainerFrame"..i];
			if (frame:IsShown()) then
				_ContainerFrame_Update(frame);
			end
		end
	end)
	-----
	BAGheji:RegisterEvent("PLAYER_ENTERING_WORLD");
	--BAGheji:RegisterEvent("BAG_UPDATE_DELAYED")
	BAGheji:RegisterEvent("AUCTION_HOUSE_SHOW")
	BAGheji:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	BAGheji:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE","player")
	BAGheji:HookScript("OnEvent", function(self,event,arg1,arg2)
		if event=="PLAYER_ENTERING_WORLD" then
			if arg1 or arg2 then
				if self.portrait then
					SetPortraitTexture(self.portrait, "player")
				end
				C_Timer.After(3,function()
					self:RegisterEvent("BAG_UPDATE")
					self:RegisterEvent("BAG_CONTAINER_UPDATE")
					self:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
				end)
			end
		elseif event=="BAG_CONTAINER_UPDATE" or event=="PLAYERBANKBAGSLOTS_CHANGED" then
			self:Show_Hide_but(self.fenlei.show)
			if BankSlotsFrame:IsShown() then
				BankSlotsFrame:Show_Hide_but(BankSlotsFrame.fenlei.show)
				for banki=2,#bagData["bankID"] do
					OpenBag(bagData["bankID"][banki])
				end
			end
		elseif event=="PLAYERBANKBAGSLOTS_CHANGED" then
			if BankSlotsFrame:IsShown() then
				BankSlotsFrame:Show_Hide_but(BankSlotsFrame.fenlei.show)
			end
		elseif event=="BAG_UPDATE_DELAYED" then
			if self:IsShown() then
				CloseAllBags()
				OpenAllBags()
			end
		elseif event=="AUCTION_HOUSE_SHOW" then
			if PIGA["BagBank"]["AHOpen"] then
				if(UnitExists("NPC"))then
					OpenAllBags()
				end
			end
		elseif event=="UNIT_PORTRAIT_UPDATE" then
			if self.portrait then
				SetPortraitTexture(_G[BagBankfun.BagUIName].portrait, "player")
			end
		elseif event=="BAG_UPDATE" then
			if arg1~=-2 then
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
		end
	end)
	---系统银行处理===========
	BankFrame.suofang=PIGA["BagBank"]["BANKsuofangBili"]
	BankFrame.meihang=PIGA["BagBank"]["BANKmeihangshu"]
	----
	BankFrame.AutoSort = CreateFrame("Button",nil,BankFrame, "TruncatedButtonTemplate");
	BankFrame.AutoSort:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");
	BankFrame.AutoSort:SetSize(24,24);
	BankFrame.AutoSort:SetPoint("TOPRIGHT",BankFrame,"TOPRIGHT",-10,-41);
	BankFrame.AutoSort.Tex = BankFrame.AutoSort:CreateTexture(nil, "BORDER");
	BankFrame.AutoSort.Tex:SetTexture(zhengliIcon);
	BankFrame.AutoSort.Tex:SetTexCoord(0.168,0.27,0.837,0.934);
	BankFrame.AutoSort.Tex:SetAllPoints(BankFrame.AutoSort)
	BankFrame.AutoSort.Tex1 = BankFrame.AutoSort:CreateTexture(nil, "BORDER");
	BankFrame.AutoSort.Tex1:SetTexture(zhengliIcon);
	BankFrame.AutoSort.Tex1:SetTexCoord(0.008,0.11,0.86,0.958);
	BankFrame.AutoSort.Tex1:SetAllPoints(BankFrame.AutoSort)
	BankFrame.AutoSort.Tex1:Hide();
	BankFrame.AutoSort:SetScript("OnMouseDown", function (self)
		self.Tex:Hide();
		self.Tex1:Show();
	end);
	BankFrame.AutoSort:SetScript("OnMouseUp", function (self)
		self.Tex:Show();
		self.Tex1:Hide();
	end);
	BankFrame.AutoSort:SetScript("OnClick",  function (self)
		PlaySoundFile(567463, "Master")
		BagBankfun.SortBankBags()
	end);
	--分类设置
	BankSlotsFrame.fenlei = CreateFrame("Button",nil,BankSlotsFrame, "TruncatedButtonTemplate");
	BankSlotsFrame.fenlei:SetHighlightTexture(136477);
	BankSlotsFrame.fenlei:SetSize(20,24);
	BankSlotsFrame.fenlei:SetPoint("TOPLEFT",BankSlotsFrame,"TOPLEFT",70,-40);
	BankSlotsFrame.fenlei.Tex = BankSlotsFrame.fenlei:CreateTexture(nil, "BORDER");
	BankSlotsFrame.fenlei.Tex:SetAtlas("common-icon-forwardarrow")
	BankSlotsFrame.fenlei.Tex:SetSize(22,20);
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
	Create.BagBankFrameBG(BankFrame,true)
	--物品显示区域
	BankSlotsFrame.wupin = CreateFrame("Frame", nil, BankSlotsFrame,"BackdropTemplate")
	BankSlotsFrame.wupin:SetPoint("TOPLEFT", BankSlotsFrame, "TOPLEFT",21, -70);
	BankSlotsFrame.wupin:SetPoint("BOTTOMRIGHT", BankSlotsFrame, "BOTTOMRIGHT", -10, 30);
	BankSlotsFrame.wupin:EnableMouse(true)
	BankSlotsFrame.wupin:SetBackdrop( { bgFile = "interface/framegeneral/ui-background-marble.blp" });
	-- -----------
	BankFrame:HookScript("OnEvent", function (self,event,arg1)
		if event=="BANKFRAME_OPENED" then
			zhegnheBANK()
			for banki=2,#bagData["bankID"] do
				OpenBag(bagData["bankID"][banki])
			end
		elseif event=="PLAYERBANKSLOTS_CHANGED" then
			Bank_Item_lv(nil,nil,arg1)
			Bank_Item_ranse(nil,nil,arg1)
		end
	end)
	---清空位置让系统自行设置
	local Old_ContainerFrame_GenerateFrame=ContainerFrame_GenerateFrame
	ContainerFrame_GenerateFrame= function(frame, size, id)
		local name = frame:GetName();
		_G[name.."MoneyFrame"]:ClearAllPoints();
		for i=1,size do
			_G[name.."Item"..i]:ClearAllPoints();
		end
		return Old_ContainerFrame_GenerateFrame(frame, size, id);
	end
	--背包显示代币部件事件
	hooksecurefunc("ManageBackpackTokenFrame", function(backpack)
		if ( not backpack ) then
			backpack = GetBackpackFrame();
		end
		if backpack then backpack:SetHeight(0) end
	end)
	hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
		--print(frame, size, id)
		if id==-2 then
			UpdateP_KEY(frame)
		else
			if id>=0 and id<=(bagData["bagIDMax"]) then
				UpdateP_BAG(frame, size, id)
			else
				UpdateP_BANK(frame, size, id)
			end
		end
	end)
end