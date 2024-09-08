local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
local BagBankfun=addonTable.BagBankfun
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink=C_Container.GetContainerItemLink
local bagData=addonTable.Data.bagData
--刷新背包LV
local function Update_itemLV_(itemButton, id, slot)
	if itemButton.ZLV then
		if itemButton.ZLV then itemButton.ZLV:SetText("") end
		if tocversion<100000 then
			local itemLink = GetContainerItemLink(id, slot)
			if itemLink then
				local _,_,itemQuality,_,_,_,_,_,_,_,_,classID = GetItemInfo(itemLink);
				if itemQuality then
					if classID==2 or classID==4 then
						local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
						itemButton.ZLV:SetText(effectiveILvl);
						local r, g, b = GetItemQualityColor(itemQuality);
						itemButton.ZLV:SetTextColor(r, g, b, 1);
					end
				end
			end
		else
			local bagID = itemButton:GetBagID();
			local info = C_Container.GetContainerItemInfo(bagID, itemButton:GetID());
			if info and info.hyperlink then
				local quality = info.quality;
				local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subClassID = C_Item.GetItemInfoInstant(info.hyperlink)
				if quality and quality>1 and classID==2 or classID==4 then
					local actualItemLevel, previewLevel, sparseItemLevel = C_Item.GetDetailedItemLevelInfo(info.hyperlink)
					local colorRGBR, colorRGBG, colorRGBB, qualityString = C_Item.GetItemQualityColor(quality)
					if itemButton.ZLV then
						itemButton.ZLV:SetText(actualItemLevel);
						itemButton.ZLV:SetTextColor(colorRGBR, colorRGBG, colorRGBB, 1);
					end
				end
			end
		end
	end
end
local function Update_ranse(framef,id,slot)
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
--银行背包LV
function BagBankfun.Bag_Item_lv(frame, size, id)
	if not PIGA["BagBank"]["wupinLV"] then return end
	if id==-2 then return end
	if tocversion<100000 then
		if frame and size then
			local fujiFF=frame:GetName()
			for slot =1, size do
				local framef = _G[fujiFF.."Item"..size+1-slot]
				Update_itemLV_(framef, id, slot)
			end
		else
			local Fid=IsBagOpen(id)
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..Fid.."Item"..baogeshu+1-slot]
					Update_itemLV_(framef, id, slot)
				end
			end
		end
	else
		if frame then
			for i, itemButton in frame:EnumerateValidItems() do
				Update_itemLV_(itemButton)
			end
		else
			if id>bagData["bagIDMax"] then
				local Frameid=ContainerFrameUtil_GetShownFrameForID(id)
				if Frameid then
					for i, itemButton in Frameid:EnumerateValidItems() do
						Update_itemLV_(itemButton)
					end
				end	
			end
		end	
	end
end
--刷新背包染色
function BagBankfun.Bag_Item_Ranse(frame, size, id)
	if not PIGA["BagBank"]["wupinRanse"] then return end
	if tocversion<100000 then
		if id==-2 then return end
		if frame and size then
			local fujiFF=frame:GetName()
			for slot =1, size do
				local framef=_G[fujiFF.."Item"..size+1-slot]
				Update_ranse(framef,id,slot)
			end
		else
			local Fid=IsBagOpen(id)
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				for slot =1, baogeshu do
					local framef=_G["ContainerFrame"..Fid.."Item"..baogeshu+1-slot];
					Update_ranse(framef,id,slot)
				end
			end
		end
	else
		if frame and size==0 and id==0 then
			for bagi=1,#bagData["bagID"] do
				local baogeshu=GetContainerNumSlots(bagData["bagID"][bagi])
				if bagData["bagID"][bagi]==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..bagi.."Item"..(baogeshu+1-slot)]
					Update_ranse(framef,bagData["bagID"][bagi], slot)
				end
			end
		else
			local Fid=id+1
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				if id==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..Fid.."Item"..(baogeshu+1-slot)]
					Update_ranse(framef, id, slot)
				end
			end
		end
	end
end
---
function BagBankfun.xuanzhuangsanjiao(self,open)
	if open then
		self:SetRotation(-3.1415926, {x=0.4, y=0.5})
	else
		self:SetRotation(0, {x=0.4, y=0.5})
	end
end
----
local function jisuanBANKzongshu(id)
	local bankzongshu = bagData["bankmun"]
	if id>bagData["bankID"][2] then
		local qianzhibag = id-bagData["bankID"][2]
		for i=bagData["bankID"][2],id-1 do
			local shangnum = GetContainerNumSlots(i)
			bankzongshu=bankzongshu+shangnum
		end
	end
	return bankzongshu
end
function BagBankfun.jisuanBANKkonmgyu(id)
	local shang_allshu=jisuanBANKzongshu(id)
	local qishihang=ceil(bagData["bankmun"]/BankFrame.meihang)--行数
	local qishikongyu=qishihang*BankFrame.meihang-bagData["bankmun"]--空余
	if id==bagData["bankID"][2] then
		return qishihang,qishikongyu
	else
		local hangShu=ceil(shang_allshu/BankFrame.meihang)
		local kongyu=hangShu*BankFrame.meihang-shang_allshu
		return hangShu,kongyu
	end
end
--银行格子LV
function BagBankfun.Bank_Item_lv(frame, size, id)
	if not PIGA["BagBank"]["wupinLV"] then return end
	if id then
		if id<=bagData["bankmun"] then
			local framef=_G["BankFrameItem"..id];
			Update_itemLV_(framef, -1, id)
		end
	else
		for ig=1,bagData["bankmun"] do
			local framef=_G["BankFrameItem"..ig];
			Update_itemLV_(framef, -1, ig)
		end
	end
end
--银行格子染色
function BagBankfun.Bank_Item_ranse(frame, size, id)
	if not PIGA["BagBank"]["wupinRanse"] then return end
	if id then
		if id<=bagData["bankmun"] then
			local framef=_G["BankFrameItem"..id];
			Update_ranse(framef, -1, id)
		end
	else
		for ig=1,bagData["bankmun"] do
			local framef=_G["BankFrameItem"..ig];
			Update_ranse(framef, -1, ig)
		end
	end
end
function BagBankfun.Update_BankFrame_Height(BagdangeW)
	local banbagzongshu=bagData["bankmun"]
	for i=2,#bagData["bankID"] do
		banbagzongshu=banbagzongshu+GetContainerNumSlots(bagData["bankID"][i])
	end
	local hangShuALL=ceil(banbagzongshu/BankFrame.meihang)
	local hangallgao=hangShuALL*BagdangeW
	if tocversion<100000 then
		BankFrame:SetWidth(BagdangeW*BankFrame.meihang+36)
		BankFrame:SetHeight(hangallgao+106);
	else
		if hangallgao+106>BANK_PANELS[1].size.y then
			BankFrame:SetHeight(hangallgao+106);
		else
			BankFrame:SetHeight(BANK_PANELS[1].size.y);
		end
	end
	if ElvUI then
		BankFrame.backdrop:SetPoint("BOTTOMRIGHT", BankFrame, "BOTTOMRIGHT", 10.17, 0);	
	end
end
-------
function BagBankfun.add_Itemslot_ZLV_ranse(famrr,BagdangeW)		
	if not famrr.ZLV then
		famrr.ZLV = PIGFontString(famrr,{"TOPRIGHT", famrr, "TOPRIGHT", -1, -1},nil,"OUTLINE",15)
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
function BagBankfun.addfenleibagbut(fujiui,uiname)
	local baginfo={
		["id"]=bagData["bagID"],
		["icon"]={
			MainMenuBarBackpackButton,
			CharacterBag0Slot,
			CharacterBag1Slot,
			CharacterBag2Slot,
			CharacterBag3Slot,
		},
	}
	if fujiui==BankSlotsFrame then
		local newbankID = {}
		for i=2,#bagData["bankID"] do
			table.insert(newbankID,bagData["bankID"][i])
		end
		baginfo.id=newbankID
		local bankicon={
			BankSlotsFrame.Bag1,
			BankSlotsFrame.Bag2,
			BankSlotsFrame.Bag3,
			BankSlotsFrame.Bag4,
			BankSlotsFrame.Bag5,
			BankSlotsFrame.Bag6,
		}
		if tocversion>19999 then
			table.insert(bankicon, BankSlotsFrame.Bag7);
		end
		baginfo.icon=bankicon
	end
	function fujiui:Show_Hide_but(showV)
		for vb=1,#baginfo.id do
			local fameXX = _G[uiname..vb]
			fameXX:SetShown(showV)
			fameXX.xitongbagF=baginfo.icon[vb]
			if showV then
				fameXX.ICONpig:SetTexture(baginfo.icon[vb].icon:GetTexture());
			end
		end
	end
	for vb=1,#baginfo.id do
		local fameXX = CreateFrame("Button",uiname..vb,fujiui,nil,baginfo.id[vb]);
		fameXX:SetSize(34,34);
		fameXX:SetPoint("TOPLEFT", fujiui, "TOPRIGHT", 0, -(45*vb)-20);
		fameXX:Hide()
		fameXX:RegisterForDrag("LeftButton")
		--local fameXX = _G["ContainerFrame"..vb.."PortraitButton"]
		fameXX.ICONpig = fameXX:CreateTexture(nil, "BORDER");
		fameXX.ICONpig:SetSize(26,26);
		fameXX.ICONpig:SetPoint("TOPLEFT",fameXX,"TOPLEFT",5,-5);
		if NDui or ElvUI then
		else
			fameXX.BGpig = fameXX:CreateTexture(nil, "ARTWORK");
			fameXX.BGpig:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
			fameXX.BGpig:SetSize(66,66);
			fameXX.BGpig:SetPoint("TOPLEFT",fameXX,"TOPLEFT",-2,1);
		end
		fameXX:HookScript("OnEnter", function (self)
			if tocversion<100000 then
				local frameID = IsBagOpen(self:GetID())
				if frameID then
					for slot = 1, MAX_CONTAINER_ITEMS do
						local famrr=_G["ContainerFrame"..frameID.."Item"..slot]
					 	famrr.BattlepayItemTexture:Show()
					end
				end
			else
				local frameID=ContainerFrameUtil_GetShownFrameForID(self:GetID())
				if frameID then
					for i, itemButton in frameID:EnumerateValidItems() do
						itemButton.BattlepayItemTexture:Show()
					end
				end
			end
		end);
		fameXX:HookScript("OnLeave", function (self)
			if tocversion<100000 then
				local frameID = IsBagOpen(self:GetID())
				if frameID then
					for slot = 1, MAX_CONTAINER_ITEMS do
						local famrr=_G["ContainerFrame"..frameID.."Item"..slot]
					    famrr.BattlepayItemTexture:Hide()
					end
				end
			else
				local frameID=ContainerFrameUtil_GetShownFrameForID(self:GetID())
				if frameID then
					for i, itemButton in frameID:EnumerateValidItems() do
						itemButton.BattlepayItemTexture:Hide()
					end
				end
			end
		end);
		if fujiui==BAGheji_UI then
			fameXX:HookScript("OnDragStart", function (self, button)
				BagSlotButton_OnDrag(self.xitongbagF, button);
			end);
			fameXX:HookScript("OnReceiveDrag", function (self)
				BagSlotButton_OnClick(self.xitongbagF);
			end);
		end
	end
end