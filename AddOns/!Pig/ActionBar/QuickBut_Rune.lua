local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
--------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGLine=Create.PIGLine
local PIGQuickBut=Create.PIGQuickBut
local PIGFontString=Create.PIGFontString
-- --==============================
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local EngravingSlot=Data.EngravingSlot
-----
QuickButUI.ButList[4]=function()
	if tocversion>20000 or not PIGA["QuickBut"]["Open"] or not PIGA["QuickBut"]["Rune"] then return end
	local GnUI = "QkBut_AutoRune"
	if _G[GnUI] then return end
	local Icon=134419
	local AutoRune=PIGQuickBut(GnUI,"",Icon)
	local fuwenNum,butW = 5,AutoRune:GetHeight()
	local AutoRuneList = PIGFrame(AutoRune,nil,nil,"AutoRuneListUI")
	AutoRuneList:Hide()
	AutoRuneList:HookScript("OnLeave", function(self)
		if not PIGA["QuickBut"]["RuneShow"] then AutoRuneList:Hide() end
		AutoRuneList.F:Hide()
	end)
	AutoRuneList:HookScript("OnEnter", function(self)
		self:Show()
		AutoRuneList.F:Show()
	end)
	AutoRuneList:PIGSetBackdrop()
	for Slot=1,19 do
		if EngravingSlot[Slot] then
			local RuneBut = CreateFrame("Button","QkBut_RuneSlot_"..Slot,AutoRuneList);
			RuneBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
			RuneBut:SetSize(butW,butW);
			RuneBut:SetNormalTexture(134419)
			RuneBut.biaoti = PIGFontString(RuneBut,{"BOTTOM", RuneBut, "BOTTOM", 1, 0},InvSlot.Name[Slot][2],"OUTLINE",10)
			RuneBut.biaoti:SetTextColor(0, 1, 1, 0.8)
			RuneBut:HookScript("OnLeave", function()
				GameTooltip:ClearLines();
				GameTooltip:Hide()
				if not PIGA["QuickBut"]["RuneShow"] then AutoRuneList:Hide() end
				AutoRuneList.F:Hide()
			end);
			RuneBut:HookScript("OnEnter", function (self)
				AutoRuneList:Show()
				AutoRuneList.F:Show()
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
				GameTooltip:Show();
			end);
		end				
	end
	AutoRuneList.F = PIGFrame(AutoRuneList)
	AutoRuneList.F:Hide()
	AutoRuneList.F:HookScript("OnLeave", function(self)
		if not PIGA["QuickBut"]["RuneShow"] then AutoRuneList:Hide() end
		self:Hide()
	end)
	AutoRuneList.F:HookScript("OnEnter", function(self)
		AutoRuneList:Show()
		self:Show()
	end)
	AutoRuneList.F:PIGSetBackdrop()
	for Slot=1,19 do
		if EngravingSlot[Slot] then
			for ir=1,fuwenNum do
				local RuneBut = CreateFrame("Button","QkBut_RuneSlot_but"..Slot..ir,AutoRuneList.F);
				RuneBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
				RuneBut:SetSize(butW,butW);
				RuneBut:SetNormalTexture(134419)
				RuneBut:HookScript("OnLeave", function()
					GameTooltip:ClearLines();
					GameTooltip:Hide()
					if not PIGA["QuickBut"]["RuneShow"] then AutoRuneList:Hide() end
					AutoRuneList.F:Hide()
				end);
				RuneBut:HookScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
					GameTooltip:SetEngravingRune(self.skillLineAbilityID);
					GameTooltip:Show();
					AutoRuneList:Show()
					AutoRuneList.F:Show()
				end);
				RuneBut:HookScript("OnClick", function(self)
					C_Engraving.CastRune(self.skillLineAbilityID)
					UseInventoryItem(Slot)
				end);
			end
		end				
	end

	local function Engraving_UpdateRuneList()
		for Slot=1,19 do
			if EngravingSlot[Slot] then
				local RuneSlot = _G["QkBut_RuneSlot_"..Slot]
				local engravingInfo = C_Engraving.GetRuneForEquipmentSlot(Slot);
				if engravingInfo then
					RuneSlot:SetNormalTexture(engravingInfo.iconTexture);
					RuneSlot.skillLineAbilityID=engravingInfo.skillLineAbilityID
				else
					RuneSlot:SetNormalTexture(134419);
					RuneSlot.skillLineAbilityID=nil
				end
			end
		end
		local categories = C_Engraving.GetRuneCategories(true, true);
		AutoRuneList.F.MaxXUHAO = 1
		for _, category in ipairs(categories) do
			local runes = C_Engraving.GetRunesForCategory(category, true);
			AutoRuneList.F.BUTxuhao = 0
			AutoRuneList.F.BUTxuhao_1 = 0
			for _, rune in ipairs(runes) do
				local engravingInfo = C_Engraving.GetRuneForEquipmentSlot(category);
				if not engravingInfo or engravingInfo and engravingInfo.skillLineAbilityID~=rune.skillLineAbilityID then
					AutoRuneList.F.BUTxuhao=AutoRuneList.F.BUTxuhao+1
					local RuneBut = _G["QkBut_RuneSlot_but"..rune.equipmentSlot..AutoRuneList.F.BUTxuhao]
					RuneBut:Show()
					RuneBut.skillLineAbilityID=rune.skillLineAbilityID
					RuneBut:SetNormalTexture(rune.iconTexture);
					if category==11 then
						AutoRuneList.F.BUTxuhao_1=AutoRuneList.F.BUTxuhao_1+1
						local RuneBut = _G["QkBut_RuneSlot_but12"..AutoRuneList.F.BUTxuhao_1]
						RuneBut:Show()
						RuneBut.skillLineAbilityID=rune.skillLineAbilityID
						RuneBut:SetNormalTexture(rune.iconTexture);
					end
				end
				if AutoRuneList.F.BUTxuhao>AutoRuneList.F.MaxXUHAO then
					AutoRuneList.F.MaxXUHAO=AutoRuneList.F.BUTxuhao
				end
			end
		end
		AutoRuneList.F:SetHeight(butW*AutoRuneList.F.MaxXUHAO+2)
	end
	AutoRuneList:HookScript("OnShow", function(self,event)
		for Slot=1,19 do
			if EngravingSlot[Slot] then
				for ir=1,fuwenNum do
					local RuneBut = _G["QkBut_RuneSlot_but"..Slot..ir]
					RuneBut:Hide()
				end
			end
		end
		Engraving_UpdateRuneList()
	end)
	AutoRuneList:RegisterEvent("RUNE_UPDATED");
	AutoRuneList:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	AutoRuneList:RegisterEvent("REPLACE_ENCHANT");
	AutoRuneList:HookScript("OnEvent", function(self,event)
		if self:IsVisible() then
			if event=="REPLACE_ENCHANT" then
				StaticPopup_OnClick(StaticPopup1, 1) 
				StaticPopup1:Hide()
			else
				Engraving_UpdateRuneList()
			end
		end
	end)
	function AutoRune:UpDatePoints(load)
		AutoRuneList.fuwenbuweiNUM = 0
		local WowHeight=GetScreenHeight();
		local offset1 = self:GetBottom();
		AutoRuneList:ClearAllPoints();
		AutoRuneList.F:ClearAllPoints();
		if offset1>(WowHeight*0.5) then
			AutoRuneList:SetPoint("TOPLEFT",QuickButUI.nr,"BOTTOMLEFT",0,0)
			AutoRuneList.F:SetPoint("TOPLEFT",AutoRuneList,"BOTTOMLEFT",0,0)
			for Slot=1,19 do
				if EngravingSlot[Slot] then
					AutoRuneList.fuwenbuweiNUM=AutoRuneList.fuwenbuweiNUM+1
					local RuneSlot = _G["QkBut_RuneSlot_"..Slot]
					RuneSlot:ClearAllPoints();
					RuneSlot.biaoti:ClearAllPoints();
					RuneSlot.biaoti:SetPoint("TOP",RuneSlot,"TOP",0,0)
					RuneSlot:SetPoint("TOPLEFT",AutoRuneList,"TOPLEFT",(AutoRuneList.fuwenbuweiNUM-1)*butW+1,1);
					for ir=1,fuwenNum do
						local RuneBut = _G["QkBut_RuneSlot_but"..Slot..ir]
						RuneBut:ClearAllPoints();
						if ir==1 then
							RuneBut:SetPoint("TOPLEFT",AutoRuneList.F,"TOPLEFT",(AutoRuneList.fuwenbuweiNUM-1)*butW+1,1);
						else
							RuneBut:SetPoint("TOP",_G["QkBut_RuneSlot_but"..Slot..(ir-1)],"BOTTOM",0,0);
						end
					end
				end
			end
		else
			AutoRuneList:SetPoint("BOTTOMLEFT",QuickButUI.nr,"TOPLEFT",0,-0.6)
			AutoRuneList.F:SetPoint("BOTTOMLEFT",AutoRuneList,"TOPLEFT",0,0)
			for Slot=1,19 do
				if EngravingSlot[Slot] then
					AutoRuneList.fuwenbuweiNUM=AutoRuneList.fuwenbuweiNUM+1
					local RuneSlot = _G["QkBut_RuneSlot_"..Slot]
					RuneSlot:ClearAllPoints();
					RuneSlot.biaoti:ClearAllPoints();
					RuneSlot.biaoti:SetPoint("BOTTOM",RuneSlot,"BOTTOM",0,0)
					RuneSlot:SetPoint("BOTTOMLEFT",AutoRuneList,"BOTTOMLEFT",(AutoRuneList.fuwenbuweiNUM-1)*butW+1,2);
					for ir=1,fuwenNum do
						local RuneBut = _G["QkBut_RuneSlot_but"..Slot..ir]
						RuneBut:ClearAllPoints();
						if ir==1 then
							RuneBut:SetPoint("BOTTOMLEFT",AutoRuneList.F,"BOTTOMLEFT",(AutoRuneList.fuwenbuweiNUM-1)*butW+1,1);
						else
							RuneBut:SetPoint("BOTTOM",_G["QkBut_RuneSlot_but"..Slot..(ir-1)],"TOP",0,0);
						end
					end
				end
			end
		end
		AutoRuneList:SetSize(AutoRuneList.fuwenbuweiNUM*butW+2,butW+3)
		AutoRuneList.F:SetWidth(AutoRuneList.fuwenbuweiNUM*butW+2)
		AutoRuneList:Show()
		if not load then AutoRuneList.F:Show() end
	end
	if PIGA["QuickBut"]["RuneShow"] then AutoRune:UpDatePoints(true) end
	AutoRune:HookScript("OnLeave", function(self)
		if not PIGA["QuickBut"]["RuneShow"] then AutoRuneList:Hide() end
		AutoRuneList.F:Hide()
	end)
	AutoRune:HookScript("OnEnter", function(self)
		self:UpDatePoints()
	end)
	AutoRune:HookScript("OnClick", function(self)
		QuickButUI:yidongRightBut()
	end);
end