local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
--------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGLine=Create.PIGLine
local PIGQuickBut=Create.PIGQuickBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGFontString=Create.PIGFontString
--==============================
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local ActionBarfun=addonTable.ActionBarfun
local QuickButF=ActionBarfun.QuickButF
local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local PickupContainerItem =C_Container.PickupContainerItem
-----
QuickButUI.ButList[5]=function()
	if not PIGA["QuickBut"]["Open"] or not PIGA["QuickBut"]["Equip"] then return end
	local GnUI = "QkBut_AutoEquip"
	if _G[GnUI] then return end
	if tocversion<30000 and not _G["PIG_PaperDollSidebarTab2"] then return end
	---1装备按钮
	local PIG_EquipmentData = {
		["anniushu"]=MAX_EQUIPMENT_SETS_PER_PLAYER,
		["zhuangbeixilieID"]=Data.InvSlot.Name,
		["NumTexCoord"]=QuickButUI.EquipmentPIG["NumTexCoord"],
		["Equip_Save"]=QuickButUI.EquipmentPIG["Equip_Save"],
		["Equip_Use"]=QuickButUI.EquipmentPIG["Equip_Use"],
	};
	-------
	local Icon=255350
	local ClickTooltip ="《"..CHARACTER_INFO.."C键》界面管理配装"
	local Tooltip = KEY_BUTTON1.."-|cff00FFFF展开切换按钮|r\n"..KEY_BUTTON2.."-|cff00FFFF卸下身上有耐久装备|r"
	local AutoEquip=PIGQuickBut(GnUI,Tooltip,Icon)
	local butW = AutoEquip:GetHeight()
	AutoEquip:GetNormalTexture():SetPoint("TOPLEFT", -3, 0);
	AutoEquip:GetNormalTexture():SetPoint("BOTTOMRIGHT", 3, 0);
	AutoEquip.tips = PIGFontString(AutoEquip,nil,"你没有已保存的配装，\n"..ClickTooltip,"OUTLINE");
	AutoEquip.tips:SetJustifyH("RIGHT")
	AutoEquip.tips:SetTextColor(1, 0, 0, 1)
	--
	local butW = QuickButUI.nr:GetHeight()
	local AutoEquipList = PIGFrame(AutoEquip,{"BOTTOM",AutoEquip,"TOP",0,0},{butW, (butW+2)*PIG_EquipmentData.anniushu+2})
	AutoEquipList:SetFrameLevel(23)
	AutoEquipList:HookScript("OnEnter", function(self,button)
		if AutoRuneListUI and AutoRuneListUI:IsShown() then AutoEquip.xuyaoShow=true;AutoRuneListUI:Hide() end
		AutoEquipList:Show()
	end)
	AutoEquipList:HookScript("OnLeave", function(self,button)
		AutoEquipList:Hide()
	end)
	for i=1,PIG_EquipmentData.anniushu do
		local EquipBut = CreateFrame("Button", "QkBut_AutoEquip_but"..i, AutoEquipList,nil,i)
		EquipBut:SetHighlightTexture(130718);
		EquipBut:SetSize(butW, butW)
		EquipBut.BGtex = PIGFrame(EquipBut,{"CENTER",EquipBut,"CENTER",0, 0},{butW, butW})
		EquipBut.BGtex:PIGSetBackdrop(0.2,0.2)
		EquipBut.BGtex:SetFrameLevel(EquipBut:GetFrameLevel()-1)
		if tocversion<20000 then
			EquipBut:SetNormalTexture("interface/timer/bigtimernumbers.blp");
			EquipBut:GetNormalTexture():SetTexCoord(PIG_EquipmentData.NumTexCoord[i][1],PIG_EquipmentData.NumTexCoord[i][2],PIG_EquipmentData.NumTexCoord[i][3],PIG_EquipmentData.NumTexCoord[i][4]);
		end
		EquipBut.name = PIGFontString(EquipBut,{"LEFT", EquipBut, "RIGHT", 0, 0},nil,"OUTLINE",12)
		EquipBut.name:SetTextColor(1, 1, 1, 1)
		EquipBut:RegisterForClicks("AnyUp");
		EquipBut.Down = EquipBut:CreateTexture(nil, "OVERLAY");
		EquipBut.Down:SetTexture(130839);
		EquipBut.Down:SetAllPoints(EquipBut)
		EquipBut.Down:Hide();
		EquipBut:HookScript("OnMouseDown", function (self)
			self.Down:Show();
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		EquipBut:HookScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		EquipBut:HookScript("OnEnter", function (self)
			if AutoRuneListUI and AutoRuneListUI:IsShown() then AutoEquip.xuyaoShow=true;AutoRuneListUI:Hide() end
			AutoEquipList:Show()
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",20,0);
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFFF切换配装|r\n"..KEY_BUTTON2.."-|cff00FFFF保存配装|r")
			GameTooltip:Show();
		end);
		EquipBut:HookScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			AutoEquipList:Hide()
		end);
		EquipBut:HookScript("OnClick", function(self,button)
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
			if tocversion<30000 then
				if button=="LeftButton" then
					PIG_EquipmentData.Equip_Use(self:GetID())
				else
					PIG_EquipmentData.Equip_Save(self:GetID())
				end
			else
				local erqid = self.id
				if erqid and erqid>=0 then
					local name = C_EquipmentSet.GetEquipmentSetInfo(erqid)
					if button=="LeftButton" then
						if InCombatLockdown() then PIGinfotip:TryDisplayMessage(CANNOT_UNEQUIP_COMBAT) return end
						C_EquipmentSet.UseEquipmentSet(erqid)
						PIGinfotip:TryDisplayMessage("更换<"..name..">配装成功")
						-- if IsShiftKeyDown() then
						-- 	if tocversion<50000 then
						-- 		GearManagerDialog_Update();	
						-- 		local bianjibutid
						-- 		for ixx=1,PIG_EquipmentData.anniushu do
						-- 			local xxfuji = _G["GearSetButton"..ixx]
						-- 			if xxfuji.id==erqid then
						-- 				bianjibutid=ixx
						-- 				break
						-- 			end
						-- 		end
						-- 		if bianjibutid and bianjibutid>=0 then
						-- 			ShowUIPanel(CharacterFrame);
						-- 			local xxfuji = _G["GearSetButton"..bianjibutid]
						-- 			GearManagerDialog.selectedSetName = xxfuji.name;
						-- 			GearManagerDialog.selectedSetIcon = xxfuji.icon:GetTexture();
						-- 			GearManagerDialog:Show();
						-- 			GearManagerDialogSaveSet_OnClick()
						-- 		end
						-- 	else
						-- 		ShowUIPanel(CharacterFrame);
						-- 		PaperDollFrame_SetSidebar(self, 3);
						-- 		GearManagerPopupFrame.mode=2;
						-- 		PaperDollFrame.EquipmentManagerPane.selectedSetID = erqid;
						-- 		GearManagerPopupFrame.setID=erqid;
						-- 		local name = C_EquipmentSet.GetEquipmentSetInfo(erqid);
						-- 		GearManagerPopupFrame.origName = name
						-- 		PaperDollFrame_ClearIgnoredSlots();
						-- 		PaperDollFrame_IgnoreSlotsForSet(erqid);
						-- 		PaperDollEquipmentManagerPane_Update();
						-- 		GearManagerPopupFrame:Show();
						-- 		GearManagerPopupFrame:Update()
						-- 		StaticPopup_Hide("CONFIRM_SAVE_EQUIPMENT_SET");
						-- 		StaticPopup_Hide("CONFIRM_OVERWRITE_EQUIPMENT_SET");
						-- 	end
						-- end
					else
						--C_EquipmentSet.UnassignEquipmentSetSpec(i-1)
						C_EquipmentSet.SaveEquipmentSet(erqid)
						PIGinfotip:TryDisplayMessage("当前装备已保存到<"..name..">配装")
					end
				else
					if InCombatLockdown() then
						PIGinfotip:TryDisplayMessage(CANNOT_UNEQUIP_COMBAT)
					else
						ShowUIPanel(CharacterFrame);
						if tocversion<50000 then
							GearManagerDialog:Show();
							GearManagerDialogSaveSet_OnClick()
						else
							PaperDollFrame_SetSidebar(self, 3);
							GearManagerPopupFrame.mode=1;
							PaperDollFrame.EquipmentManagerPane.selectedSetID = nil;
							--GearManagerPopupFrame.setID=erqid;
							PaperDollFrame_ClearIgnoredSlots();
							PaperDollEquipmentManagerPane_Update();
							PaperDollFrame_IgnoreSlot(4);
							PaperDollFrame_IgnoreSlot(19);
							GearManagerPopupFrame:Show();
							GearManagerPopupFrame:Update()
						end
					end
				end
			end
			AutoEquipList:Hide()
		end)
	end
	--
	function AutoEquip:UpDatePoints()
		local WowHeight=GetScreenHeight();
		local offset1 = self:GetBottom();
		AutoEquipList:ClearAllPoints();
		AutoEquip.tips:ClearAllPoints();
		if offset1>(WowHeight*0.5) then
			for i=1,PIG_EquipmentData.anniushu do
				local fujikj = _G["QkBut_AutoEquip_but"..i]
				fujikj:ClearAllPoints();
				if i==1 then
					fujikj:SetPoint("TOPRIGHT",AutoEquipList,"TOPRIGHT",0,-2);
				else
					local fujikj_1 = _G["QkBut_AutoEquip_but"..(i-1)]
					fujikj:SetPoint("TOPRIGHT",fujikj_1,"BOTTOMRIGHT",0,-2);
				end
			end
			AutoEquipList:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",0,0);
			AutoEquip.tips:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",10,0);
		else
			for i=1,PIG_EquipmentData.anniushu do
				local fujikj = _G["QkBut_AutoEquip_but"..i]
				fujikj:ClearAllPoints();
				if i==1 then
					fujikj:SetPoint("BOTTOMRIGHT",AutoEquipList,"BOTTOMRIGHT",0,2);
				else
					local fujikj_1 = _G["QkBut_AutoEquip_but"..(i-1)]
					fujikj:SetPoint("BOTTOMRIGHT",fujikj_1,"TOPRIGHT",0,2);
				end
			end
			AutoEquipList:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",0,0);
			AutoEquip.tips:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",10,0);
		end
		AutoEquipList:Show()
	end
	AutoEquip:HookScript("OnLeave", function(self)
		AutoEquipList:Hide()
		self.tips:Hide()
	end)
	AutoEquipList:HookScript("OnHide", function(self)
		if AutoEquip.xuyaoShow then AutoRuneListUI:Show() end
	end)
	AutoEquip:SetScript("OnEnter", function(self)
		self.tips:Hide()
		self.cunzainum=0
		if AutoRuneListUI and AutoRuneListUI:IsShown() then AutoEquip.xuyaoShow=true;AutoRuneListUI:Hide() end
		if tocversion<30000 then
			for id = 1, PIG_EquipmentData.anniushu do
				local fujikj = _G["QkBut_AutoEquip_but"..id]
				fujikj.name:SetTextColor(0.8, 0.8, 0.8, 0.8);
				fujikj.name:SetText(EMPTY);
				local hangitem = PIGA_Per["QuickBut"]["EquipList"][id]
				if hangitem then
					self.cunzainum=self.cunzainum+1
					fujikj:Show()
					if hangitem[1] then
						fujikj.name:SetText(hangitem[1]);
					end
					if hangitem[2] then
						fujikj.name:SetTextColor(1, 1, 1, 1);
						fujikj.name:SetText(hangitem[1]);
					end
				else
					fujikj:Hide()
				end
			end
		else
			local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
			for id = 1, PIG_EquipmentData.anniushu do
				local fujikj = _G["QkBut_AutoEquip_but"..id]
				if equipmentSetIDs[id] then
					fujikj:Show()
					fujikj.id=equipmentSetIDs[id]
					local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[id])
					fujikj:SetNormalTexture(iconFileID);
					fujikj.name:SetText(name);
				else
					fujikj:Hide()
					fujikj.id=nil
					fujikj:SetNormalTexture("");
					fujikj.name:SetText("");
				end
			end
		end
		if self.cunzainum==0 then
			self.tips:Show()
		end
		self:UpDatePoints()
	end)
	AutoEquip:HookScript("OnClick", function(self,button)
		if button=="LeftButton" then
			PIGinfotip:TryDisplayMessage("右键卸下全部有耐久装备\n"..ClickTooltip)
		else
			if InCombatLockdown() then PIGinfotip:TryDisplayMessage(CANNOT_UNEQUIP_COMBAT) return end
			PIG_EquipmentData.InventoryNum={}
			for inv = 1, 19 do
				if PIG_EquipmentData.zhuangbeixilieID[inv][4] then
					if GetInventoryItemID("player",inv) then
						table.insert(PIG_EquipmentData.InventoryNum,inv)
					end
				end
			end
			PIG_EquipmentData.konggelist={}
			for bagID=0,4 do
				local numberOfFreeSlots, bagType = GetContainerNumFreeSlots(bagID)
				if numberOfFreeSlots>0 and bagType==0 then
					for ff=1,GetContainerNumSlots(bagID) do
						if GetContainerItemID(bagID, ff) then
						else
							table.insert(PIG_EquipmentData.konggelist,{bagID,ff})
							if #PIG_EquipmentData.konggelist>=#PIG_EquipmentData.InventoryNum then
								break
							end
						end
					end
				end
				if #PIG_EquipmentData.konggelist>=#PIG_EquipmentData.InventoryNum then
					break
				end
			end
			for xuhao = 1, #PIG_EquipmentData.konggelist do
				local invv = PIG_EquipmentData.InventoryNum[xuhao]
				local isLocked2 = IsInventoryItemLocked(invv)
				if not isLocked2 then
					PickupInventoryItem(invv)
					PickupContainerItem(PIG_EquipmentData.konggelist[xuhao][1], PIG_EquipmentData.konggelist[xuhao][2])
				end
			end
			if #PIG_EquipmentData.konggelist<#PIG_EquipmentData.InventoryNum then
				PIGinfotip:TryDisplayMessage(ERR_EQUIPMENT_MANAGER_BAGS_FULL)
			else
				PIGinfotip:TryDisplayMessage("已卸下全部有耐久装备")
			end
			AutoEquipList:Hide()
		end
	end);
end