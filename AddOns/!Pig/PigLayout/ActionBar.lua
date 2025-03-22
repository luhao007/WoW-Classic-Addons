local _, addonTable = ...;
---
local PigLayoutFun=addonTable.PigLayoutFun
function PigLayoutFun.Options_ActionBar(openxx)
if not openxx then return end
---
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
---
local RTabFrame =PigLayoutFun.RTabFrame
--
local ActionF,ActionFBut =PIGOptionsList_R(RTabFrame,ACTIONBARS_LABEL..L["CHAT_TABNAME4"],100)
ActionF:Show()
ActionFBut:Selected()
--
ActionF.Box_1 = PIGFrame(ActionF,{"TOP", ActionF, "TOP", 0, -10},{ActionF:GetWidth()-20, 100})
ActionF.Box_1:PIGSetBackdrop(0)
local function ActionBar_HideShijiu()
	if PIGA["PigLayout"]["ActionBar"]["HideShijiu"] then
		MainMenuBarRightEndCap:Hide();--隐藏右侧鹰标 
		MainMenuBarLeftEndCap:Hide();--隐藏左侧鹰标 
	else
		MainMenuBarRightEndCap:Show();
		MainMenuBarLeftEndCap:Show();
	end
end
ActionF.Box_1.HideShijiu=PIGCheckbutton(ActionF.Box_1,{"TOPLEFT",ActionF.Box_1,"TOPLEFT",10,-10},{"隐藏狮鹫图标","隐藏动作条两边的狮鹫图标"})
ActionF.Box_1.HideShijiu:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["HideShijiu"]=true;
	else
		PIGA["PigLayout"]["ActionBar"]["HideShijiu"]=false;
	end
	ActionBar_HideShijiu()
end)
--主动作条缩放比例
local function ActionBar_bili(ly)
	if PIGA["PigLayout"]["ActionBar"]["Scale"] then
		MainMenuBar:SetScale(PIGA["PigLayout"]["ActionBar"]["ScaleV"]);
		VerticalMultiBarsContainer:SetScale(PIGA["PigLayout"]["ActionBar"]["ScaleV"]);
		for i=1, 12 do
			_G["MultiBarLeftButton"..i]:SetScale(PIGA["PigLayout"]["ActionBar"]["ScaleV"])
			--_G["MultiBarRightButton"..i]:SetScale(PIGA["PigLayout"]["ActionBar"]["ScaleV"])
		end
	else
		if ly then
			MainMenuBar:SetScale(1);
			VerticalMultiBarsContainer:SetScale(1);
			for i=1, 12 do
				_G["MultiBarLeftButton"..i]:SetScale(1)
				--_G["MultiBarRightButton"..i]:SetScale(1)
			end
		end
	end
end
ActionF.Box_1.ActionBar_bili = PIGCheckbutton(ActionF.Box_1,{"LEFT",ActionF.Box_1.HideShijiu,"RIGHT",200,0},{"缩放动作条","启用缩放动作条,注意此设置和系统高级里面的UI缩放不同，只调整动作条比例"})
ActionF.Box_1.ActionBar_bili:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["Scale"]=true	
	else
		PIGA["PigLayout"]["ActionBar"]["Scale"]=false
	end
	ActionF.Box_1.ActionBar_bili.Slider:SetEnabled(PIGA["PigLayout"]["ActionBar"]["Scale"])
	ActionBar_bili(true)
end);
-------
ActionF.Box_1.ActionBar_bili.Slider = PIGSlider(ActionF.Box_1,{"LEFT",ActionF.Box_1.ActionBar_bili,"RIGHT",96,0},{0.6, 1.4, 0.01,{["Right"]="%"}})
ActionF.Box_1.ActionBar_bili.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ActionBar"]["ScaleV"]=arg1;
	ActionBar_bili()
end)
--移动右边动作条
local function IS_bar34Show()
	local ACTIONBAR_1,ACTIONBAR_2,ACTIONBAR_3,ACTIONBAR_4 = GetActionBarToggles()
	if ACTIONBAR_4 and ACTIONBAR_3 then
		return true
	end
	return false
end
local function Pig_BarRight()
	if Pig_OptionsUI.IsOpen_ElvUI("actionbar") then return end
	if Pig_OptionsUI.IsOpen_NDui("Actionbar") then return end
	if not PIGA["PigLayout"]["ActionBar"]["BarRight"] then return end
	local function Pig_MultiBar_Update()
		if InCombatLockdown() then
			VerticalMultiBarsContainer:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			for i=1, 12 do
				_G["MultiBarLeftButton"..i]:ClearAllPoints();
				_G["MultiBarLeftButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomLeftButton"..i],"TOP",0,6);
				_G["MultiBarRightButton"..i]:ClearAllPoints();
				_G["MultiBarRightButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomRightButton"..i],"TOP",0,6);
			end
			VerticalMultiBarsContainer:SetSize(1, 1);
			VerticalMultiBarsContainer:UnregisterEvent("PLAYER_REGEN_ENABLED");
		end
	end
	Pig_MultiBar_Update()
	VerticalMultiBarsContainer:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			Pig_MultiBar_Update()
		end
	end);
	--姿态条
	local function StanceBar_Update()
		if InCombatLockdown() then
			StanceBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			if IS_bar34Show() then
				StanceButton1:SetPoint("BOTTOMLEFT", MultiBarLeftButton1,"TOPLEFT", 60, 6)
			end
			StanceBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		end
	end
	StanceBar_Update()
	StanceBarFrame:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			StanceBar_Update()
		end
	end);
	---图腾条
	local function MultiCastBar_Point(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			if not ElvUI then
				self:SetMovable(true)
				self:ClearAllPoints();
				self:SetPoint("BOTTOMLEFT", self:GetParent(),"TOPLEFT", MULTICASTACTIONBAR_XPOS, MULTICASTACTIONBAR_YPOS+42)
				self:SetUserPlaced(true)
				self:UnregisterEvent("PLAYER_REGEN_ENABLED");
			end
		end 
	end
	local function MultiCastBar_Update(self)
		if IS_bar34Show() then
			MultiCastBar_Point(self)
		else
			self:SetMovable(true)
			self:SetUserPlaced(false)
			self:SetMovable(false)
		end
	end
	if MultiCastActionBarFrame then
		MultiCastBar_Update(MultiCastActionBarFrame)
		local function jiazaiMultiCast()
			MultiCastBar_Update(MultiCastActionBarFrame)
		end
		MultiCastActionBarFrame:HookScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				C_Timer.After(0.4,jiazaiMultiCast)
				C_Timer.After(1,jiazaiMultiCast)
				C_Timer.After(2,jiazaiMultiCast)
				C_Timer.After(5,jiazaiMultiCast)
			end
			if event=="PLAYER_REGEN_ENABLED" then
				MultiCastBar_Update(self)
			end
		end);
		UIParent:HookScript("OnShow", function(self)
			C_Timer.After(0.1,jiazaiMultiCast)
			C_Timer.After(0.2,jiazaiMultiCast)
		end)
	end
	--宠物动作条
	local function PetBar_Update()
		if InCombatLockdown() then
			PetActionBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			PetActionBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
			if IS_bar34Show() then
				if StanceBarFrame:IsShown() then
					PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarLeftButton1,"TOPLEFT", 260, 6)
				else
					PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarLeftButton1,"TOPLEFT", 60, 6)
				end	
			end
		end
	end
	PetBar_Update()
	if PetActionBarFrame.UpdatePositionValues then
		hooksecurefunc(PetActionBarFrame, "UpdatePositionValues", function()
			PetBar_Update()
		end)
	elseif ShowPetActionBar then
		hooksecurefunc("ShowPetActionBar", function()
			PetBar_Update()
		end)
	end
	PetActionBarFrame:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			PetBar_Update()
		end
	end);
	---整体
	hooksecurefunc("MainMenuBar_UpdateExperienceBars",function(newLevel)
		StanceBar_Update()
		PetBar_Update()
		if MultiCastActionBarFrame then
			MultiCastBar_Update(MultiCastActionBarFrame)
		end
	end);
	hooksecurefunc("MultiActionBar_Update",function()	
		Pig_MultiBar_Update()
		StanceBar_Update()
		PetBar_Update()
		if MultiCastActionBarFrame then
			MultiCastBar_Update(MultiCastActionBarFrame)
		end
	end);
end
ActionF.Box_1.BarRight=PIGCheckbutton(ActionF.Box_1,{"TOPLEFT",ActionF.Box_1.HideShijiu,"BOTTOMLEFT",0,-20},{"移动右边动作条到下方","移动右边竖向动作条到下方动作条之上"})
ActionF.Box_1.BarRight:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["BarRight"]=true
		Pig_BarRight()
	else
		PIGA["PigLayout"]["ActionBar"]["BarRight"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
---
ActionF.Box_1:HookScript("OnShow", function(self)
	self.HideShijiu:SetChecked(PIGA["PigLayout"]["ActionBar"]["HideShijiu"])
	self.BarRight:SetChecked(PIGA["PigLayout"]["ActionBar"]["BarRight"])
	self.ActionBar_bili:SetChecked(PIGA["PigLayout"]["ActionBar"]["Scale"]);
	self.ActionBar_bili.Slider:SetEnabled(PIGA["PigLayout"]["ActionBar"]["Scale"])
	self.ActionBar_bili.Slider:PIGSetValue(PIGA["PigLayout"]["ActionBar"]["ScaleV"])	
end)
----
ActionBar_HideShijiu()
Pig_BarRight()
ActionBar_bili()
end