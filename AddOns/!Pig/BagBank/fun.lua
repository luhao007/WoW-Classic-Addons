local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
local BagBankfun=addonTable.BagBankfun
local GetContainerNumSlots =GetContainerNumSlots or C_Container and C_Container.GetContainerNumSlots
local GetContainerItemLink=GetContainerItemLink or C_Container and C_Container.GetContainerItemLink
local GetContainerItemID=GetContainerItemID or C_Container and C_Container.GetContainerItemID
local bagData=addonTable.Data.bagData
local gsub = _G.string.gsub
local match = _G.string.match
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
			local itemID, itemLink, icon, stackCount, quality=PIGGetContainerItemInfo(bagID, itemButton:GetID())
			if itemLink then
				local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subClassID = C_Item.GetItemInfoInstant(itemLink)
				if quality and quality>1 and classID==2 or classID==4 then
					local actualItemLevel, previewLevel, sparseItemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
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
		local numSlots,full = GetNumBankSlots();
		for vb=1,#baginfo.id do
			local fameXX = _G[uiname..vb]
			fameXX:SetShown(showV)
			fameXX.xitongbagF=baginfo.icon[vb]
			if showV then
				fameXX.Portrait:SetTexture(baginfo.icon[vb].icon:GetTexture());
				if fujiui==BankSlotsFrame then
					if ( vb <= numSlots ) then
						fameXX.Portrait:SetVertexColor(1.0,1.0,1.0);
					else
						fameXX.Portrait:SetVertexColor(1.0,0.1,0.1);
					end
				else
					local numFreeSlots= C_Container.GetContainerNumFreeSlots(baginfo.id[vb])
					if ( numFreeSlots>0 ) then
						fameXX.Portrait:SetVertexColor(1.0,1.0,1.0);
					else
						fameXX.Portrait:SetVertexColor(1.0,0.1,0.1);
					end
				end
			end
			fameXX:UpdateFilterIcon();
		end
	end
	local www,hhh,jiangeW = 26,26,3
	for vb=1,#baginfo.id do
		--local fameXX = _G["ContainerFrame"..vb.."PortraitButton"]
		local fameXX = CreateFrame("Frame",uiname..vb,fujiui);
		local ContainerFrameMixin=ContainerFrameMixin or {}
		local fameXX = Mixin(fameXX, ContainerFrameMixin)
		fameXX:SetSize(www,hhh);
		if fujiui==BAGheji_UI then
			fameXX:SetPoint("TOPLEFT", fujiui.fenlei, "TOPRIGHT", 8, -((www+jiangeW)*(vb-1)));
		else
			fameXX:SetPoint("LEFT", fujiui.fenlei, "RIGHT", ((www+jiangeW)*(vb-1))+2, 0);
		end
		fameXX:Hide()
		fameXX.BagID=baginfo.id[vb]
		function fameXX:GetBagID()
			return self.BagID
		end
		function fameXX:MatchesBagID(id)
			return self.BagID == id;
		end
		fameXX.Portrait = fameXX:CreateTexture(nil, "BORDER");
		fameXX.Portrait:SetAllPoints(fameXX)
		fameXX.FilterIcon = CreateFrame("Frame",nil,fameXX);
		fameXX.FilterIcon:SetSize(www*0.7,hhh*0.7);
		fameXX.FilterIcon:SetPoint("BOTTOMRIGHT",fameXX,"BOTTOMRIGHT",5,-4);
		fameXX.FilterIcon.Icon = fameXX.FilterIcon:CreateTexture(nil, "OVERLAY");
		fameXX.FilterIcon.Icon:SetAllPoints(fameXX.FilterIcon)

		local Templateinfo = C_XMLUtil.GetTemplateInfo("ContainerFramePortraitButtonTemplate")
		if Templateinfo then
			fameXX.PortraitButton = CreateFrame("DropdownButton","$parentPortraitButton",fameXX,"ContainerFramePortraitButtonTemplate");
		else
			fameXX.PortraitButton = CreateFrame("Button","$parentPortraitButton",fameXX);
			fameXX.PortraitButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		end
		fameXX.PortraitButton:SetAllPoints(fameXX)
		fameXX.PortraitButton:RegisterForDrag("LeftButton")
		local OLD_OnValueChanged=fameXX.PortraitButton:GetScript("OnEnter") or function() end
		fameXX.PortraitButton:SetScript("OnEnter", function (self)
			local BagID = self:GetParent():GetBagID()
			if tocversion<100000 then
				local frameID = IsBagOpen(BagID)
				if frameID then
					OLD_OnValueChanged(self)
					for slot = 1, MAX_CONTAINER_ITEMS do
						local famrr=_G["ContainerFrame"..frameID.."Item"..slot]
					 	famrr.BattlepayItemTexture:Show()
					end
				end
			else
				local frameID=ContainerFrameUtil_GetShownFrameForID(BagID)
				if frameID then
					OLD_OnValueChanged(self)
					for i, itemButton in frameID:EnumerateValidItems() do
						itemButton.BattlepayItemTexture:Show()
					end
				end
			end
		end);
		fameXX.PortraitButton:HookScript("OnLeave", function (self)
			local BagID = self:GetParent():GetBagID()
			if tocversion<100000 then
				local frameID = IsBagOpen(BagID)
				if frameID then
					for slot = 1, MAX_CONTAINER_ITEMS do
						local famrr=_G["ContainerFrame"..frameID.."Item"..slot]
					    famrr.BattlepayItemTexture:Hide()
					end
				end
			else
				local frameID=ContainerFrameUtil_GetShownFrameForID(BagID)
				if frameID then
					for i, itemButton in frameID:EnumerateValidItems() do
						itemButton.BattlepayItemTexture:Hide()
					end
				end
			end
		end);
		fameXX.PortraitButton.GetInventorySlot = function(self)
			local BagID = self:GetParent():GetBagID()
			local invID = C_Container.ContainerIDToInventoryID(BagID)
			return invID
		end
		fameXX.PortraitButton:HookScript("OnClick", function (self)
			if ( IsModifiedClick("PICKUPITEM") ) then
				BankFrameItemButtonBag_Pickup(self);
			else
				BankFrameItemButtonBag_OnClick(self, button);
			end
		end)
		fameXX.UpdateFilterIcon=fameXX.UpdateFilterIcon or function() end
		if fujiui==BAGheji_UI then	
			fameXX.PortraitButton:HookScript("OnDragStart", function (self, button)
				BagSlotButton_OnDrag(self:GetParent().xitongbagF, button);
			end);
			fameXX.PortraitButton:HookScript("OnReceiveDrag", function (self)
				BagSlotButton_OnClick(self:GetParent().xitongbagF);
			end);
		else
			fameXX.PortraitButton:HookScript("OnDragStart", function (self, button)
				BankFrameItemButtonBag_Pickup(self:GetParent().xitongbagF, button);
			end);
			fameXX.PortraitButton:HookScript("OnReceiveDrag", function (self)
				BankFrameItemButtonBag_OnClick(self:GetParent().xitongbagF);
			end);
			if Templateinfo then			
				local fameXX_xxx = CreateFrame("Button",nil,fameXX,"ContainerFramePortraitButtonRouterTemplate");
				local function AddButtons_BagFilters(description, bagID,bagframe)
					if not ContainerFrame_CanContainerUseFilterMenu(bagID) then
						return;
					end
					description:CreateTitle(BAG_FILTER_ASSIGN_TO);
					local function IsSelected(flag)
						return C_Container.GetBagSlotFlag(bagID, flag);
					end
					local function SetSelected(flag)
						local value = not IsSelected(flag);
						C_Container.SetBagSlotFlag(bagID, flag, value);
						if not ContainerFrameSettingsManager.filterFlags then
							ContainerFrameSettingsManager.filterFlags = {};
						end
						local currentFilters = ContainerFrameSettingsManager.filterFlags[bagID] or 0;
						ContainerFrameSettingsManager.filterFlags[bagID] = FlagsUtil.Combine(currentFilters, flag, value);
						bagframe:UpdateFilterIcon();
					end
					for i, flag in ContainerFrameUtil_EnumerateBagGearFilters() do
						local checkbox = description:CreateCheckbox(BAG_FILTER_LABELS[flag], IsSelected, SetSelected, flag);
						checkbox:SetResponse(MenuResponse.Close);
					end
				end
				fameXX.PortraitButton:SetupMenu(function(dropdown, rootDescription)
					local BagID = fameXX:GetBagID()
					local invID = C_Container.ContainerIDToInventoryID(BagID)
					local ItemLink = GetInventoryItemLink("player", invID)
					if not ItemLink then return end
					rootDescription:SetTag("MENU_CONTAINER_FRAME");
					local bagID = fameXX:GetBagID();
					if not bagID then return end
					AddButtons_BagFilters(rootDescription, bagID,fameXX);
				end);
			end
		end
	end
end
---设置
function BagBankfun.addSetbut(fujiui,point,Rneirong,tabbut)
	local setbut = CreateFrame("Button",nil,fujiui, "TruncatedButtonTemplate"); 
	setbut:SetNormalTexture("interface/gossipframe/bindergossipicon.blp"); 
	setbut:SetHighlightTexture(130718);
	setbut:SetSize(20,20);
	setbut:SetPoint(unpack(point));
	setbut.Down = setbut:CreateTexture(nil, "OVERLAY");
	setbut.Down:SetTexture(130839);
	setbut.Down:SetAllPoints(setbut)
	setbut.Down:Hide();
	setbut:SetScript("OnMouseDown", function (self)
		self.Down:Show();
	end);
	setbut:SetScript("OnMouseUp", function (self)
		self.Down:Hide();
	end);
	setbut:SetScript("OnClick", function (self)
		PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
		if Pig_OptionsUI:IsShown() then
			Pig_OptionsUI:Hide()
		else
			Pig_OptionsUI:Show()
			Create.Show_TabBut(Rneirong,tabbut)
		end
	end);
	return shezhi
end
--装备管理显示
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
local find = _G.string.find
local sub = _G.string.sub
local eizhiguanKEY = {["keyeqlist"]=EQUIPSET_EQUIP}
local kaishi,jiehshu=EQUIPMENT_SETS:find(":")
if kaishi then
	local keyeqlist=EQUIPMENT_SETS:sub(1,kaishi-1)
	if keyeqlist then
		eizhiguanKEY.keyeqlist=keyeqlist
	end
else
	local kaishi,jiehshu=EQUIPMENT_SETS:find("：")
	if kaishi then
		local keyeqlist=EQUIPMENT_SETS:sub(1,kaishi-1)
		if keyeqlist then
			eizhiguanKEY.keyeqlist=keyeqlist
		end
	end
end
local Plisttip = CreateFrame("GameTooltip", "Plisttip_UI", UIParent, "GameTooltipTemplate")
Plisttip:SetOwner(UIParent, "ANCHOR_NONE")
local function add_Eqicon(fujiui)
	if fujiui.Eqicon then return end
	local BagdangeW=fujiui:GetWidth()*0.5
	fujiui.Eqicon = fujiui:CreateTexture();
	fujiui.Eqicon:SetSize(BagdangeW,BagdangeW);
	fujiui.Eqicon:SetPoint("BOTTOMLEFT", 0, -1);
	fujiui.Eqicon1 = fujiui:CreateTexture();
	fujiui.Eqicon1:SetSize(BagdangeW,BagdangeW);
	fujiui.Eqicon1:SetPoint("LEFT",fujiui.Eqicon,"RIGHT", 0, 0);
	-- fujiui.Eqname = fujiui:CreateFontString();
	-- fujiui.Eqname:SetPoint("LEFT", fujiui.Eqicon, "RIGHT", 0, 0);
	-- fujiui.Eqname:SetFont(ChatFontNormal:GetFont(), 14, "OUTLINE")
	fujiui:HookScript("OnHide", function(self)
		self.Eqicon:Hide()
		self.Eqicon1:Hide()
		--self.Eqname:Hide()
	end);
end
local function HideEqiconEqname(self)
	self.Eqicon:Hide()
	self.Eqicon1:Hide()
	--self.Eqname:Hide()
end
local function GetBagIDFun(self)
	if self.GetBagID then
		return self:GetBagID()
	else
		return self:GetParent():GetID()
	end
end
local function IseizhiguanKEYFun(framef,text)
	if text:match(eizhiguanKEY.keyeqlist) then
		local newtet = text:gsub(eizhiguanKEY.keyeqlist,"")
		local newtet = newtet:gsub(":","")
		local newtet = newtet:gsub("：","")
		local newtet = newtet:gsub("|cFF%w%w%w%w%w%w","")
		local newtet = newtet:gsub("|r","")
		local newtet = newtet:gsub("|","||")
		local newtet = newtet:gsub(" ","")
		local newtet = newtet:gsub("，",",")
		if newtet then
			framef.Eqicon:Show()
			local namelist = {strsplit(",", newtet)};
			local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(namelist[1])
			local name, iconFileID = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID)
			framef.Eqicon:SetTexture(iconFileID)
			if #namelist>1 then
				local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(namelist[2])
				local name, iconFileID = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID)
				framef.Eqicon1:Show()
				framef.Eqicon1:SetTexture(iconFileID)
			-- 	framef.Eqname:Show()
			-- 	framef.Eqname:SetText(#namelist)
			end
		end
		return true
	end
end
local function update_iconname(framef)
	HideEqiconEqname(framef)
	local slotID = framef:GetID()
	if slotID>0 then
		local BagID,slotID = GetBagIDFun(framef),framef:GetID()
		local itemID=GetContainerItemID(BagID,slotID)
		if itemID then
			local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemID) 
			if classID==2 or classID==4 then
				if tocversion<50000 then
					Plisttip:ClearLines();
					Plisttip:SetBagItem(BagID,slotID);
				    local hangname = Plisttip:GetName()
				    local txtNum = Plisttip:NumLines()
				    if txtNum then
				    	for g = 2, txtNum do
					    	local text = _G[hangname.."TextLeft" .. g]:GetText() or ""
					    	if IseizhiguanKEYFun(framef,text) then
								return
					    	end
					    end
					end
				else
					local tooltipData = C_TooltipInfo.GetBagItem(BagID,slotID)
					for _, line in ipairs(tooltipData.lines) do
						if IseizhiguanKEYFun(framef,line.leftText) then
							return
				    	end
					end
				end
			end
		end
	end
end
local function fun_bagitems(setfun)
	if GetCVar("combinedBags")=="1" and ContainerFrameCombinedBags then
		local butnum =#ContainerFrameCombinedBags.Items
		for ff=1,butnum do
			local framef = ContainerFrameCombinedBags.Items[ff]
			setfun(framef)
		end
	else
		for bagx=1,NUM_CONTAINER_FRAMES do
			local ContainerF = _G["ContainerFrame"..bagx]
			if ContainerF then
				if ContainerF.Items then
					local butnum =#ContainerF.Items
					for ff=1,butnum do
						local framef = ContainerF.Items[ff]
						setfun(framef)
					end
				else
					for solt=1,MAX_CONTAINER_ITEMS do
						local framef=_G["ContainerFrame"..bagx.."Item"..solt]
						if framef then
							setfun(framef)
						end
					end
				end
			end
		end
	end
end
function BagBankfun.addEquipmentbut(fujiui,point)
	local eqbut = CreateFrame("Button",nil,fujiui, "TruncatedButtonTemplate");
	-- eqbut:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");
	-- eqbut:SetSize(20,20);
	-- eqbut:SetPoint(unpack(point));
	-- eqbut.Tex = eqbut:CreateTexture();
	-- eqbut.Tex:SetTexture(255350);
	-- eqbut.Tex:SetPoint("TOPLEFT",eqbut,"TOPLEFT",-1.4,-2);
	-- eqbut.Tex:SetPoint("BOTTOMRIGHT",eqbut,"BOTTOMRIGHT",1.4,0);
	-- eqbut.Tex1 = eqbut:CreateTexture();
	-- eqbut.Tex1:SetTexture(293755);
	-- eqbut.Tex1:SetPoint("TOPLEFT",eqbut,"TOPLEFT",-1.4,-2);
	-- eqbut.Tex1:SetPoint("BOTTOMRIGHT",eqbut,"BOTTOMRIGHT",1.4,0);
	-- eqbut.Tex1:Hide();
	-- eqbut:SetScript("OnMouseDown", function (self)
	-- 	self.Tex:Hide();
	-- 	self.Tex1:Show();
	-- end);
	-- eqbut:SetScript("OnMouseUp", function (self)
	-- 	self.Tex:Show();
	-- 	self.Tex1:Hide();
	-- end);
	-- fujiui:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- fujiui:HookScript("OnEvent", function(self,event)
	-- 	if event=="BAG_UPDATE" then
	-- 		if self:IsShown() then
	-- 			fun_bagitems(HideEqiconEqname)
	-- 		end
	-- 	end
	-- end);
	-- eqbut:SetScript("OnClick",  function (self)
	-- 	PlaySoundFile(567463, "Master")
	-- 	fun_bagitems(add_Eqicon)
	-- 	fun_bagitems(update_iconname)
	-- end)
	return eqbut
end