local addonName, addonTable = ...;
local L=addonTable.locale
local find = _G.string.find
local ceil = math.ceil
local _, _, _, tocversion = GetBuildInfo()
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink=C_Container.GetContainerItemLink
--
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGFontString=Create.PIGFontString
local BagBankFrame=Create.BagBankFrame
--=====================
local InvSlot=addonTable.Data.InvSlot
local bagData=addonTable.Data.bagData
local BagBankfun=addonTable.BagBankfun
--==================
local ADD_BagBankBGtex=addonTable.ADD_BagBankBGtex
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
	BAGheji_UI:SetScale(BAGheji_UI.suofang);
	BAGheji_UI:SetWidth(BagdangeW*BAGheji_UI.meihang+28)
	if new_hangshu then
		BAGheji_UI:SetHeight(BagdangeW*new_hangshu+102);
	end
end
local function UpdateP_KEY(frame, size, id)
	local name = frame:GetName();
	frame.PortraitButton:Hide();
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
		baghangShu=ceil(zongshu/BAGheji_UI.meihang)
		bagkongyu=baghangShu*BAGheji_UI.meihang-zongshu
	end
	return baghangShu,bagkongyu
end
local function UpdateP_BAG(frame, size, id)
	frame:SetHeight(100);
	frame:SetToplevel(false)
	frame:SetParent(BAGheji_UI)
	frame.PortraitButton:Hide();
	frame.Portrait:Hide();
	local name = frame:GetName();
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
		_G[name.."MoneyFrame"]:SetPoint("RIGHT", BAGheji_UI.moneyframe, "RIGHT", 4, -1);
		_G[name.."MoneyFrame"]:SetParent(BAGheji_UI);
	else
		_G[name.."MoneyFrame"]:Hide()
	end
	local shang_allshu=jisuanBAGzongshu(id)
	local shang_hang,shang_yushu=jisuanBAGkonmgyu(id,shang_allshu)
	local NEWsize=size-shang_yushu
	local hangShu=ceil(NEWsize/BAGheji_UI.meihang)
	local new_kongyu,new_hangshu=hangShu*BAGheji_UI.meihang-NEWsize,hangShu+shang_hang
	for slot=1,size do
		local itemF = _G[name.."Item"..slot]
		itemF:ClearAllPoints();
		if slot==1 then
			itemF:SetPoint("TOPRIGHT", BAGheji_UI.wupin, "TOPRIGHT", -(new_kongyu*BagdangeW)-5, -(new_hangshu*BagdangeW)+36);
			_G[name.."PortraitButton"]:ClearAllPoints();
			_G[name.."PortraitButton"]:SetPoint("TOPLEFT", BAGheji_UI, "TOPRIGHT", 0, -(42*id)-60);
		else
			local yushu=math.fmod((slot+new_kongyu-1),BAGheji_UI.meihang)
			local itemFshang = _G[name.."Item"..(slot-1)]
			if yushu==0 then
				itemF:SetPoint("BOTTOMLEFT", itemFshang, "TOPLEFT", (BAGheji_UI.meihang-1)*BagdangeW, 5);
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
	frame.PortraitButton:Hide();
	frame.Portrait:Hide();
	local name = frame:GetName();
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
			_G[name.."PortraitButton"]:ClearAllPoints();
			_G[name.."PortraitButton"]:SetPoint("TOPLEFT", BankSlotsFrame, "TOPRIGHT", 0, -(42*(id-4))-18);
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
		BankSlotsFrame["Bag"..i]:SetScale(0.76);
		BankSlotsFrame["Bag"..i]:ClearAllPoints();
		if i==1 then
			BankSlotsFrame["Bag"..i]:SetPoint("TOPLEFT", BankFrameItem1, "BOTTOMLEFT", 80, 100);
		else
			BankSlotsFrame["Bag"..i]:SetPoint("LEFT", BankSlotsFrame["Bag"..(i-1)], "RIGHT", 0, 0);
		end
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
	BankFramePurchaseButton:SetPoint("TOPLEFT", BankSlotsFrame, "TOPLEFT", 300, -42);
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

	if NDui or ElvUI then
	else
		hooksecurefunc("ContainerFrame_Update", function(frame)
			if not PIGA["BagBank"]["JunkShow"] then return end
			local id = frame:GetID();
			local name = frame:GetName();
			for i=1, frame.size, 1 do
				local itemButton = _G[name.."Item"..i];
				local ItemInfo= C_Container.GetContainerItemInfo(id,itemButton:GetID());
				if ItemInfo and ItemInfo.quality==0 then
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
			["meihang"]=PIGA["BagBank"]["BAGmeihangshu"],
			["suofang"]=PIGA["BagBank"]["BAGsuofangBili"],
		}
		if tocversion>19999 then
			uidata.meihang=PIGA["BagBank"]["BAGmeihangshu_WLK"]
		end
		local BAGheji=BagBankFrame(UIParent,{"CENTER",UIParent,"CENTER",420,-10},"BAGheji_UI",uidata)
		BAGheji:SetToplevel(true)
		BAGheji:HookScript("OnHide",function(self)
			CloseAllBags()
		end)
		SetPortraitTexture(BAGheji.portrait, "player")
		BAGheji.biaoti = PIGFontString(BAGheji,{"TOP", BAGheji, "TOP",10, -14},Pig_OptionsUI.AllName)
		BAGheji.Close:HookScript("OnClick",  function (self)
			CloseAllBags()
		end);
		BAGheji.Search = CreateFrame("EditBox", nil, BAGheji, "BagSearchBoxTemplate");
		BAGheji.Search:SetSize(120,hhc);
		BAGheji.Search:SetPoint("TOPLEFT",BAGheji,"TOPLEFT",78,-37);

		BAGheji.AutoSort = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate");
		BAGheji.AutoSort:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");
		BAGheji.AutoSort:SetSize(wwc,hhc);
		BAGheji.AutoSort:SetPoint("TOPRIGHT",BAGheji,"TOPRIGHT",-54,-38);
		BAGheji.AutoSort.Tex = BAGheji.AutoSort:CreateTexture(nil, "BORDER");
		BAGheji.AutoSort.Tex:SetTexture(zhengliIcon);
		BAGheji.AutoSort.Tex:SetTexCoord(0.168,0.27,0.837,0.934);
		BAGheji.AutoSort.Tex:SetAllPoints(BAGheji.AutoSort)
		BAGheji.AutoSort.Tex1 = BAGheji.AutoSort:CreateTexture(nil, "BORDER");
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

		BAGheji.shezhi = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate"); 
		BAGheji.shezhi:SetNormalTexture("interface/gossipframe/bindergossipicon.blp"); 
		BAGheji.shezhi:SetHighlightTexture(130718);
		BAGheji.shezhi:SetSize(wwc-4,hhc-4);
		BAGheji.shezhi:SetPoint("TOPLEFT",BAGheji,"TOPLEFT",250,-39);
		BAGheji.shezhi.Down = BAGheji.shezhi:CreateTexture(nil, "OVERLAY");
		BAGheji.shezhi.Down:SetTexture(130839);
		BAGheji.shezhi.Down:SetAllPoints(BAGheji.shezhi)
		BAGheji.shezhi.Down:Hide();
		BAGheji.shezhi:SetScript("OnMouseDown", function (self)
			self.Down:Show();
		end);
		BAGheji.shezhi:SetScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		BAGheji.shezhi:SetScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			if Pig_OptionsUI:IsShown() then
				Pig_OptionsUI:Hide()
			else
				Pig_OptionsUI:Show()
				Create.Show_TabBut(Rneirong,tabbut)
			end
		end);
		--分类设置
		for vb=1,NUM_CONTAINER_FRAMES do
			local fameXX = _G["ContainerFrame"..vb.."PortraitButton"]
			fameXX.ICONpig = fameXX:CreateTexture(nil, "BORDER");
			fameXX.ICONpig:SetTexture();
			fameXX.ICONpig:SetSize(25,25);
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
						local cunzai = Vname:find("Item")
						if cunzai then
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
						local cunzai = Vname:find("Item")
						if cunzai then
							v.BattlepayItemTexture:Hide()
						end
					end
				end
			end);
		end
		BAGheji.fenlei = CreateFrame("Button",nil,BAGheji, "TruncatedButtonTemplate");
		BAGheji.fenlei:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		BAGheji.fenlei:SetSize(18,18);
		BAGheji.fenlei:SetPoint("TOPRIGHT",BAGheji,"TOPRIGHT",-6,-42);
		BAGheji.fenlei.Tex = BAGheji.fenlei:CreateTexture(nil, "BORDER");
		BAGheji.fenlei.Tex:SetTexture("interface/chatframe/chatframeexpandarrow.blp");
		BAGheji.fenlei.Tex:SetSize(18,18);
		BAGheji.fenlei.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",2,0);
		BAGheji.fenlei:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",3,-1);
		end);
		BAGheji.fenlei:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER",BAGheji.fenlei,"CENTER",2,0);
		end);
		BAGheji.fenlei.show=false
		BAGheji.fenlei:SetScript("OnClick",  function (self)
			if BAGheji.fenlei.show then
				BAGheji.fenlei.show=false
				xuanzhuangsanjiao(self.Tex,false)
				for vb=1,#bagData["bagID"] do
					local Fid=IsBagOpen(bagData["bagID"][vb])
					if Fid then
						_G["ContainerFrame"..Fid.."PortraitButton"]:Hide()
					end
				end
			else
				BAGheji.fenlei.show=true
				xuanzhuangsanjiao(self.Tex,true)
				local bagicon={
					133633,
					CharacterBag0SlotIconTexture:GetTexture(),
					CharacterBag1SlotIconTexture:GetTexture(),
					CharacterBag2SlotIconTexture:GetTexture(),
					CharacterBag3SlotIconTexture:GetTexture(),
				}
				for vb=1,#bagData["bagID"] do
					local Fid=IsBagOpen(bagData["bagID"][vb])
					if Fid then
						local fameXX = _G["ContainerFrame"..Fid.."PortraitButton"]
						fameXX.ICONpig:SetTexture(bagicon[bagData["bagID"][vb]+1]);
						fameXX:Show()
					end
				end
			end
		end);
		---=====================
		if tocversion>30000 then
			hooksecurefunc("ManageBackpackTokenFrame", function(backpack)
				BackpackTokenFrame:ClearAllPoints();
				BackpackTokenFrame:SetPoint("TOPRIGHT", BAGheji_UI.moneyframe, "TOPLEFT", -4, 5);
				BackpackTokenFrame:SetParent(BAGheji_UI);
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
			BAGheji.fenlei.show=false
			xuanzhuangsanjiao(BAGheji.fenlei.Tex,false)
		end);
		UIParent:HookScript("OnHide", function(self)
			BAGheji:Hide()
		end)
		-------------------
		BAGheji:RegisterEvent("PLAYER_ENTERING_WORLD");
		BAGheji:RegisterEvent("BAG_UPDATE_DELAYED")
		BAGheji:RegisterEvent("AUCTION_HOUSE_SHOW")
		BAGheji:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE","player")
		BAGheji:HookScript("OnEvent", function(self,event,arg1,arg2)
			if event=="PLAYER_ENTERING_WORLD" then
				if arg1 or arg2 then
					if self.portrait then
						SetPortraitTexture(self.portrait, "player")
					end
					C_Timer.After(3,function()
						self:RegisterEvent("BAG_UPDATE")
					end)
				end
			end
			if event=="AUCTION_HOUSE_SHOW" then
				if PIGA["BagBank"]["AHOpen"] then
					if(UnitExists("NPC"))then
						OpenAllBags()
					end
				end
			end		
			if event=="BAG_UPDATE_DELAYED" then
				if self:IsShown() then
					CloseAllBags()
					OpenAllBags()
				end
			end
			if event=="UNIT_PORTRAIT_UPDATE" then
				if self.portrait then
					SetPortraitTexture(BAGheji_UI.portrait, "player")
				end
			end
			if event=="BAG_UPDATE" then
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
		BankFrame.AutoSort:SetPoint("TOPRIGHT",BankFrame,"TOPRIGHT",-180,-41);
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
		BankSlotsFrame.fenlei:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		BankSlotsFrame.fenlei:SetSize(18,18);
		BankSlotsFrame.fenlei:SetPoint("TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-12,-44);
		BankSlotsFrame.fenlei.Tex = BankSlotsFrame.fenlei:CreateTexture(nil, "BORDER");
		BankSlotsFrame.fenlei.Tex:SetTexture("interface/chatframe/chatframeexpandarrow.blp");
		BankSlotsFrame.fenlei.Tex:SetSize(18,18);
		BankSlotsFrame.fenlei.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",2,0);
		BankSlotsFrame.fenlei:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",3,-1);
		end);
		BankSlotsFrame.fenlei:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER",BankSlotsFrame.fenlei,"CENTER",2,0);
		end);
		BankSlotsFrame.fenlei.show=false
		local bagicon={BankSlotsFrame.Bag1.icon,BankSlotsFrame.Bag2.icon,BankSlotsFrame.Bag3.icon,BankSlotsFrame.Bag4.icon,BankSlotsFrame.Bag5.icon,BankSlotsFrame.Bag6.icon,}
		if tocversion>19999 then
			table.insert(bagicon, BankSlotsFrame.Bag7.icon);
		end
		BankSlotsFrame.fenlei:SetScript("OnClick",  function (self)
			if BankSlotsFrame.fenlei.show then
				BankSlotsFrame.fenlei.show=false
				xuanzhuangsanjiao(self.Tex,false)
				for vb=2,#bagData["bankID"] do
					local Fid=IsBagOpen(bagData["bankID"][vb])
					if Fid then
						_G["ContainerFrame"..Fid.."PortraitButton"]:Hide()
					end
				end
			else
				BankSlotsFrame.fenlei.show=true
				xuanzhuangsanjiao(self.Tex,true)
				for vb=2,#bagData["bankID"] do
					local Fid=IsBagOpen(bagData["bankID"][vb])
					if Fid then
						local fameXX = _G["ContainerFrame"..Fid.."PortraitButton"]
						fameXX.ICONpig:SetTexture(bagicon[bagData["bankID"][vb]-4]:GetTexture());
						fameXX:Show()
					end
				end
			end
		end);
		BankSlotsFrame:HookScript("OnHide", function(self)
			self.fenlei.show=false
			xuanzhuangsanjiao(self.fenlei.Tex,false)
		end);
		Create.BagBankBG(BankFrame,"BankFrame_PigBG")
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
			end
			if event=="PLAYERBANKSLOTS_CHANGED" then
				Bank_Item_lv(nil,nil,arg1)
				Bank_Item_ranse(nil,nil,arg1)
			end
		-- 	if event=="BAG_UPDATE_DELAYED" then
		-- 		if BankFrame:IsShown() then
		-- 			for banki=2,#bagData["bankID"] do
				-- 	OpenBag(bagData["bankID"][banki])
				-- end
		-- 		end
		-- 	end
		end)
		-----清空位置设置让系统自行设置
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
				if id>=0 and id<=(bagData["bagIDMax"]-1) then
					UpdateP_BAG(frame, size, id)
				else
					UpdateP_BANK(frame, size, id)
				end
			end
		end)
		----
	end
	----
end