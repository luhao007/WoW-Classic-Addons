local _, addonTable = ...;
---
local PigLayoutFun=addonTable.PigLayoutFun
function PigLayoutFun.Options_ActionBar(openxx)
if not openxx then return end
---
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGSlider = Create.PIGSlider
local PIGDownMenu=Create.PIGDownMenu
local PIGFontString=Create.PIGFontString
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
---
local Data=addonTable.Data
local Fun=addonTable.Fun
local PIGSetAtlas=Fun.PIGSetAtlas
local RTabFrame =PigLayoutFun.RTabFrame
--
local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,ACTIONBARS_LABEL..L["LIB_LAYOUT"],100)
--
fujiF.setF = PIGFrame(fujiF,{"TOP", fujiF, "TOP", 0, -10},{fujiF:GetWidth()-20, 160})
fujiF.setF:PIGSetBackdrop(0)
local function ActionBar_HideShijiu()
	if PIGA["PigLayout"]["ActionBar"]["HideShijiu"] then
		MainMenuBarRightEndCap:Hide();--隐藏右侧鹰标 
		MainMenuBarLeftEndCap:Hide();--隐藏左侧鹰标 
	else
		MainMenuBarRightEndCap:Show();
		MainMenuBarLeftEndCap:Show();
	end
end
ActionBar_HideShijiu()
fujiF.setF.HideShijiu=PIGCheckbutton(fujiF.setF,{"TOPLEFT",fujiF.setF,"TOPLEFT",10,-20},{"隐藏狮鹫图标","隐藏动作条两边的狮鹫图标"})
fujiF.setF.HideShijiu:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["HideShijiu"]=true;
	else
		PIGA["PigLayout"]["ActionBar"]["HideShijiu"]=false;
	end
	ActionBar_HideShijiu()
end)
local function ActionBar_HideBarBG()
	if PIGA["PigLayout"]["ActionBar"]["HideBarBG"] then
		MainMenuBarTexture0:Hide();MainMenuBarTexture1:Hide();
	else
		MainMenuBarTexture0:Show();MainMenuBarTexture1:Show();
	end
end
ActionBar_HideBarBG()
fujiF.setF.HideBarBG = PIGCheckbutton(fujiF.setF,{"LEFT",fujiF.setF.HideShijiu,"RIGHT",160,0},{"隐藏动作条1背景"})
fujiF.setF.HideBarBG:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["HideBarBG"]=true	
	else
		PIGA["PigLayout"]["ActionBar"]["HideBarBG"]=nil
	end
	ActionBar_HideBarBG()
end);
local function ActionBar_HideBarExpBG()
	if PIGA["PigLayout"]["ActionBar"]["HideBarExpBG"] then
		MainMenuXPBarTexture0:Hide();MainMenuXPBarTexture3:Hide();
		ReputationWatchBar.StatusBar.WatchBarTexture0:Hide();ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
		ReputationWatchBar.StatusBar.XPBarTexture0:Hide();ReputationWatchBar.StatusBar.XPBarTexture3:Hide()
	else
		MainMenuXPBarTexture0:Show();MainMenuXPBarTexture3:Show();
		ReputationWatchBar.StatusBar.WatchBarTexture0:Show();ReputationWatchBar.StatusBar.WatchBarTexture3:Show()
		ReputationWatchBar.StatusBar.XPBarTexture0:Show();ReputationWatchBar.StatusBar.XPBarTexture3:Show()
	end
end
ActionBar_HideBarExpBG()
fujiF.setF.HideBarExpBG = PIGCheckbutton(fujiF.setF,{"LEFT",fujiF.setF.HideBarBG,"RIGHT",160,0},{"隐藏经验/声望背景"})
fujiF.setF.HideBarExpBG:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["HideBarExpBG"]=true	
	else
		PIGA["PigLayout"]["ActionBar"]["HideBarExpBG"]=nil
	end
	ActionBar_HideBarExpBG()
end);
--主动作条缩放比例
local function ActionBar_Scale(ly)
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
ActionBar_Scale()
fujiF.setF.ActionBar_Scale = PIGCheckbutton(fujiF.setF,{"TOPLEFT",fujiF.setF.HideShijiu,"BOTTOMLEFT",0,-20},{"缩放动作条","启用缩放动作条,注意此设置和系统高级里面的UI缩放不同，只调整动作条比例"})
fujiF.setF.ActionBar_Scale:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["Scale"]=true	
	else
		PIGA["PigLayout"]["ActionBar"]["Scale"]=false
	end
	fujiF.setF.ActionBar_Scale.Slider:SetEnabled(PIGA["PigLayout"]["ActionBar"]["Scale"])
	ActionBar_Scale(true)
end);
-------
fujiF.setF.ActionBar_Scale.Slider = PIGSlider(fujiF.setF,{"LEFT",fujiF.setF.ActionBar_Scale,"RIGHT",96,0},{0.4, 1.8, 0.01,{["Right"]="%"}},200)
fujiF.setF.ActionBar_Scale.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ActionBar"]["ScaleV"]=arg1;
	ActionBar_Scale()
end)
--移动右边动作条
local function IS_bar34Show()
	local onoff = {}
	local ACTIONBAR_2,ACTIONBAR_3,ACTIONBAR_4,ACTIONBAR_5 = GetActionBarToggles()
	onoff[2]=ACTIONBAR_2
	onoff[3]=ACTIONBAR_3
	onoff[4]=ACTIONBAR_4
	onoff[5]=ACTIONBAR_5
	return onoff
end
local function Update_1_3(WidthX)
	local WidthXALL = (WidthX+6)*12
	MainMenuBar:SetWidth(WidthXALL+8);
	MainMenuBarTexture0:ClearAllPoints();
	MainMenuBarTexture1:ClearAllPoints();
	ActionBar_HideBarBG()
	if not PIGA["PigLayout"]["ActionBar"]["HideBarBG"] then
		MainMenuBarTexture0:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMLEFT", 1, 0);
		MainMenuBarTexture1:SetPoint("BOTTOMLEFT", MainMenuBarTexture0, "BOTTOMRIGHT", 0, 0);
	end
	MainMenuBarTexture2:Hide();MainMenuBarTexture3:Hide();MainMenuBarTextureExtender:Hide()
	MainMenuBarPageNumber:ClearAllPoints();
	MainMenuBarPageNumber:SetPoint("BOTTOM", ActionBarUpButton, "TOP", -3, -3);
	MainMenuExpBar:SetWidth(WidthXALL);
	MainMenuXPBarTexture0:SetWidth(WidthXALL*0.506);
	MainMenuXPBarTexture0:ClearAllPoints();
	MainMenuXPBarTexture0:SetPoint("LEFT", MainMenuExpBar, "LEFT", -3, 0);
	MainMenuXPBarTexture3:SetWidth(WidthXALL*0.506);
	MainMenuXPBarTexture3:ClearAllPoints();
	MainMenuXPBarTexture3:SetPoint("LEFT", MainMenuXPBarTexture0, "RIGHT", 0, 0);
	MainMenuXPBarTexture1:Hide()
	MainMenuXPBarTexture2:Hide()
	MainMenuMaxLevelBar0:Hide()
	MainMenuMaxLevelBar1:Hide()
	MainMenuMaxLevelBar2:Hide()
	MainMenuMaxLevelBar3:Hide()
	local function PIG_ReputationWatchBar()
		ReputationWatchBar:SetWidth(WidthXALL);
		ReputationWatchBar.StatusBar:SetWidth(WidthXALL);
		ReputationWatchBar.StatusBar.WatchBarTexture0:SetWidth(WidthXALL*0.506);
		ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints();
		ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint("LEFT", ReputationWatchBar.StatusBar, "LEFT", -2, 0);
		ReputationWatchBar.StatusBar.WatchBarTexture3:SetWidth(WidthXALL*0.506);
		ReputationWatchBar.StatusBar.WatchBarTexture3:ClearAllPoints();
		ReputationWatchBar.StatusBar.WatchBarTexture3:SetPoint("LEFT", ReputationWatchBar.StatusBar.WatchBarTexture0, "RIGHT", -2, 0);
		ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
		ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
		ReputationWatchBar.StatusBar.XPBarTexture0:SetWidth(WidthXALL*0.506);
		ReputationWatchBar.StatusBar.XPBarTexture0:ClearAllPoints();
		ReputationWatchBar.StatusBar.XPBarTexture0:SetPoint("LEFT", ReputationWatchBar.StatusBar, "LEFT", -2, 0);
		ReputationWatchBar.StatusBar.XPBarTexture3:SetWidth(WidthXALL*0.506);
		ReputationWatchBar.StatusBar.XPBarTexture3:ClearAllPoints();
		ReputationWatchBar.StatusBar.XPBarTexture3:SetPoint("LEFT", ReputationWatchBar.StatusBar.XPBarTexture0, "RIGHT", -2, 0);
		ReputationWatchBar.StatusBar.XPBarTexture1:Hide()
		ReputationWatchBar.StatusBar.XPBarTexture2:Hide()
		ActionBar_HideBarExpBG()
	end
	PIG_ReputationWatchBar()
	if ReputationWatchBar_Update then
		hooksecurefunc("ReputationWatchBar_Update", function(newLevel)
			PIG_ReputationWatchBar()
		end)
	else
		hooksecurefunc("MainMenuBar_UpdateExperienceBars", function(newLevel)
			PIG_ReputationWatchBar()
		end)
	end
	hooksecurefunc("MainMenuTrackingBar_Configure", function(newLevel)
		PIG_ReputationWatchBar()
	end)
	for i=1, 12 do
		_G["MultiBarBottomRightButton"..i]:ClearAllPoints();
		_G["MultiBarBottomRightButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomLeftButton"..i],"TOP",0,6);
	end
	MainMenuBarLeftEndCap:ClearAllPoints();
	MainMenuBarLeftEndCap:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, "BOTTOMLEFT", 34, 0);
	MainMenuBarRightEndCap:ClearAllPoints();
	MainMenuBarRightEndCap:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMRIGHT", -34, 0);
end
local function Update_Vertical(mode,WidthX)
	VerticalMultiBarsContainer:UnregisterEvent("PLAYER_REGEN_ENABLED");
	if mode==1 then
		VerticalMultiBarsContainer:SetWidth(1);
	elseif mode==2 then
		VerticalMultiBarsContainer:SetWidth(WidthX);
	end
end
local function ActionBar_Layout()
	if PIG_OptionsUI.IsOpen_ElvUI("actionbar","enable") then return end
	if PIG_OptionsUI.IsOpen_NDui("Actionbar","Enable") then return end
	if not PIGA["PigLayout"]["ActionBar"]["BarRight"] then return end
	local function Update_MultiBar()
		if InCombatLockdown() then
			VerticalMultiBarsContainer:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			local WidthX = ActionButton1:GetWidth()
			if PIGA["PigLayout"]["ActionBar"]["Layout"]==1 then
				for i=1, 12 do
					_G["MultiBarLeftButton"..i]:ClearAllPoints();
					_G["MultiBarLeftButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomLeftButton"..i],"TOP",0,6);
					_G["MultiBarRightButton"..i]:ClearAllPoints();
					_G["MultiBarRightButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomRightButton"..i],"TOP",0,6);
				end
				Update_Vertical(1,WidthX)
			elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==2 then
				Update_1_3(WidthX)
			elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==3 then
				Update_1_3(WidthX)
				Update_Vertical(2,WidthX)
				for i=1, 12 do
					_G["MultiBarLeftButton"..i]:ClearAllPoints();
					_G["MultiBarLeftButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomRightButton"..i],"TOP",0,6);
				end
			elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==4 then
				Update_1_3(WidthX)
				Update_Vertical(1,WidthX)
				for i=1, 12 do
					_G["MultiBarLeftButton"..i]:ClearAllPoints();
					_G["MultiBarLeftButton"..i]:SetPoint("BOTTOM",_G["MultiBarBottomRightButton"..i],"TOP",0,6);
					_G["MultiBarRightButton"..i]:ClearAllPoints();
					_G["MultiBarRightButton"..i]:SetPoint("BOTTOM",_G["MultiBarLeftButton"..i],"TOP",0,6);
				end
			elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==5 then
				Update_1_3(WidthX)
				Update_Vertical(1,WidthX)		
				for i=12, 1,-1 do
					if i==12 then
						_G["MultiBarLeftButton"..i]:ClearAllPoints();
						_G["MultiBarLeftButton"..i]:SetPoint("BOTTOMRIGHT",MainMenuBarArtFrame,"BOTTOMLEFT",-PIGA["PigLayout"]["ActionBar"]["LRInterval"],4);
						_G["MultiBarRightButton"..i]:ClearAllPoints();
						_G["MultiBarRightButton"..i]:SetPoint("BOTTOMLEFT",MainMenuBarArtFrame,"BOTTOMRIGHT",PIGA["PigLayout"]["ActionBar"]["LRInterval"],4);
					elseif i==8 or i==4 then
						_G["MultiBarLeftButton"..i]:ClearAllPoints();
						_G["MultiBarLeftButton"..i]:SetPoint("BOTTOMRIGHT",_G["MultiBarLeftButton"..(i+4)],"TOPRIGHT",0,6);
						_G["MultiBarRightButton"..i]:ClearAllPoints();
						_G["MultiBarRightButton"..i]:SetPoint("BOTTOMRIGHT",_G["MultiBarRightButton"..(i+4)],"TOPRIGHT",0,6);
					else
						_G["MultiBarLeftButton"..i]:ClearAllPoints();
						_G["MultiBarLeftButton"..i]:SetPoint("RIGHT",_G["MultiBarLeftButton"..(i+1)],"LEFT",-6,0);
						_G["MultiBarRightButton"..i]:ClearAllPoints();
						_G["MultiBarRightButton"..i]:SetPoint("LEFT",_G["MultiBarRightButton"..(i+1)],"RIGHT",6,0);
					end
				end
			end
		end
	end
	Update_MultiBar()
	VerticalMultiBarsContainer:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			Update_MultiBar()
		end
	end);
	local function Update_BarPoint(BarUI)
		local Xoffset= 10
		if BarUI==PetActionButton1 and StanceBarFrame:IsShown() then
			local sswww=StanceButton1:GetWidth()
			Xoffset= Xoffset+sswww*3+20
		end
		local barOpen = IS_bar34Show()
		if BarUI==MultiCastActionBarFrame then
			MultiCastActionBarFrame:SetMovable(true)
		end
		if PIGA["PigLayout"]["ActionBar"]["Layout"]==1 and barOpen[5] then
			BarUI:SetPoint("BOTTOMLEFT", MultiBarLeftButton1,"TOPLEFT", Xoffset, 6)
		elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==2 or PIGA["PigLayout"]["ActionBar"]["Layout"]==5 and barOpen[3] then
			BarUI:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1,"TOPLEFT", Xoffset, 6)
		elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==3 and barOpen[5] then
			BarUI:SetPoint("BOTTOMLEFT", MultiBarLeftButton1,"TOPLEFT", Xoffset, 6)
		elseif PIGA["PigLayout"]["ActionBar"]["Layout"]==4 and barOpen[4] and barOpen[5] then
			BarUI:SetPoint("BOTTOMLEFT", MultiBarRightButton1,"TOPLEFT", Xoffset, 6)
		end
		if BarUI==MultiCastActionBarFrame then
			MultiCastActionBarFrame:SetUserPlaced(true)
		end
	end
	--姿态条
	local function Update_StanceBar()
		if InCombatLockdown() then
			StanceBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			StanceBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
			Update_BarPoint(StanceButton1)
		end
	end
	Update_StanceBar()
	StanceBarFrame:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			Update_StanceBar()
		end
	end);
	--宠物动作条
	local function Update_PetBar()
		if InCombatLockdown() then
			PetActionBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			PetActionBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
			Update_BarPoint(PetActionButton1)
		end
	end
	Update_PetBar()
	if PetActionBarFrame.UpdatePositionValues then
		hooksecurefunc(PetActionBarFrame, "UpdatePositionValues", function()
			Update_PetBar()
		end)
	elseif ShowPetActionBar then
		hooksecurefunc("ShowPetActionBar", function()
			Update_PetBar()
		end)
	end
	PetActionBarFrame:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			Update_PetBar()
		end
	end);
	---图腾条
	local function Update_MultiCastBar()
		if not MultiCastActionBarFrame then return end
		if InCombatLockdown() then
			MultiCastActionBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			MultiCastActionBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
			Update_BarPoint(MultiCastActionBarFrame)
		end
	end
	if MultiCastActionBarFrame then
		Update_MultiCastBar()
		MultiCastActionBarFrame:HookScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				Update_MultiCastBar()
			elseif event=="PLAYER_REGEN_ENABLED" then
				Update_MultiCastBar()
			end
		end);
		UIParent:HookScript("OnShow", function(self)
			Update_MultiCastBar()
		end)
	end
	---整体
	hooksecurefunc("MainMenuBar_UpdateExperienceBars",function(newLevel)
		Update_StanceBar()
		Update_PetBar()
		Update_MultiCastBar()
	end);
	hooksecurefunc("MultiActionBar_Update",function()	
		Update_MultiBar()
		Update_StanceBar()
		Update_PetBar()
		Update_MultiCastBar()
	end);
end
ActionBar_Layout()
fujiF.setF.BarRight=PIGCheckbutton(fujiF.setF,{"TOPLEFT",fujiF.setF.ActionBar_Scale,"BOTTOMLEFT",0,-20},{"重设动作条布局"})
fujiF.setF.BarRight:SetScript("OnClick", function (self)
	if InCombatLockdown() then self:SetChecked(false) PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
	if self:GetChecked() then
		PIGA["PigLayout"]["ActionBar"]["BarRight"]=true
		ActionBar_Layout()
	else
		PIGA["PigLayout"]["ActionBar"]["BarRight"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
fujiF.setF.LayoutT = PIGFontString(fujiF.setF,{"LEFT", fujiF.setF.BarRight, "RIGHT", 140, 0},"布局模式")
fujiF.setF.Layout=PIGDownMenu(fujiF.setF,{"LEFT", fujiF.setF.LayoutT, "RIGHT", 2, 0},{240,nil})
local xyList = {"底部(左0+中3*2+右0)+右侧0","底部(左0+中3+右0)+右侧2","底部(左0+中4+右0)+右侧1","底部(左0+中5+右0)+右侧0","底部(左1+中3+右1)+右侧0"}
function fujiF.setF.Layout:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#xyList do
	 	info.text, info.arg1 = xyList[i], i
	 	info.checked = i == PIGA["PigLayout"]["ActionBar"]["Layout"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.setF.Layout:PIGDownMenu_SetValue(value,arg1)
	if InCombatLockdown() then PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
	self:PIGDownMenu_SetText(value)
	PIGA["PigLayout"]["ActionBar"]["Layout"]=arg1
	fujiF.setF.Update_Set()
	if PIGA["PigLayout"]["ActionBar"]["BarRight"] then PIG_OptionsUI.RLUI:Show() end
	PIGCloseDropDownMenus()
end
fujiF.setF.Layout.LRIntervalT = PIGFontString(fujiF.setF.Layout,{"TOPLEFT", fujiF.setF.LayoutT, "BOTTOMLEFT", 0, -18},"左右居中间距")
fujiF.setF.Layout.LRInterval = PIGSlider(fujiF.setF.Layout,{"LEFT", fujiF.setF.Layout.LRIntervalT, "LEFT", 100, 0},{0, 400, 1})
fujiF.setF.Layout.LRInterval.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ActionBar"]["LRInterval"]=arg1;
	ActionBar_Layout()
end)

function fujiF.setF.Update_Set()
	if PIGA["PigLayout"]["ActionBar"]["Layout"]==5 then
		fujiF.setF.Layout.LRIntervalT:Show()
		fujiF.setF.Layout.LRInterval:Show()
	else
		fujiF.setF.Layout.LRIntervalT:Hide()
		fujiF.setF.Layout.LRInterval:Hide()
	end
end
---
fujiF.setF:HookScript("OnShow", function(self)
	self.HideShijiu:SetChecked(PIGA["PigLayout"]["ActionBar"]["HideShijiu"])
	self.HideBarBG:SetChecked(PIGA["PigLayout"]["ActionBar"]["HideBarBG"])
	self.HideBarExpBG:SetChecked(PIGA["PigLayout"]["ActionBar"]["HideBarExpBG"])
	self.BarRight:SetChecked(PIGA["PigLayout"]["ActionBar"]["BarRight"])
	self.Layout:PIGDownMenu_SetText(xyList[PIGA["PigLayout"]["ActionBar"]["Layout"]])
	self.ActionBar_Scale:SetChecked(PIGA["PigLayout"]["ActionBar"]["Scale"]);
	self.ActionBar_Scale.Slider:SetEnabled(PIGA["PigLayout"]["ActionBar"]["Scale"])
	self.ActionBar_Scale.Slider:PIGSetValue(PIGA["PigLayout"]["ActionBar"]["ScaleV"])
	self.Layout.LRInterval:PIGSetValue(PIGA["PigLayout"]["ActionBar"]["LRInterval"])
	fujiF.setF.Update_Set()
end)
--=====
local WWW=26
local Old_MicroBut = PIGCopyTable(MICRO_BUTTONS)
local Diy_MicroBut = {"MacroMicroButton","AddonsMicroButton","MainMenuBarBackpackButton"}
if PIG_MaxTocversion(40000) then
	table.insert(Diy_MicroBut,1,"EJMicroButton")
end
--重建菜单列表
local GameMenu = {}
local PIG_MICRO_BUTTONS = {}
local New_PIG_MICRO_BUTTONS = {}
for i=1,#Old_MicroBut do
	--不要添加聊天和系统地图
	if Old_MicroBut[i]~="HelpMicroButton" and Old_MicroBut[i]~="WorldMapMicroButton" then
		local pigmname = Old_MicroBut[i]
		if Old_MicroBut[i]=="SocialsMicroButton" then
			pigmname="FriendsMicroButton"
		end
		table.insert(PIG_MICRO_BUTTONS,"PIG_"..pigmname)
		GameMenu["PIG_"..pigmname]=pigmname
		pigmname=nil
	end	
end
for i=1,#Diy_MicroBut do
	table.insert(PIG_MICRO_BUTTONS,"PIG_"..Diy_MicroBut[i])
	GameMenu["PIG_"..Diy_MicroBut[i]]=Diy_MicroBut[i]
end
local Old_MicroButNum=#PIG_MICRO_BUTTONS
--默认图标
local BlizzardIcon = {	
	["PIG_SpellbookMicroButton"]={Normal="hud-microbutton-Spellbook-Up",Pushed="hud-microbutton-Spellbook-Down",Disabled="hud-microbutton-Spellbook-Disabled"},
	["PIG_TalentMicroButton"]={Normal="hud-microbutton-Talents-Up",Pushed="hud-microbutton-Talents-Down",Disabled="hud-microbutton-Talents-Disabled"},
	["PIG_AchievementMicroButton"]={Normal="hud-microbutton-Achievement-Up",Pushed="hud-microbutton-Achievement-Down",Disabled="hud-microbutton-Achievement-Disabled"},
	["PIG_QuestLogMicroButton"]={Normal="hud-microbutton-Quest-Up",Pushed="hud-microbutton-Quest-Down",Disabled="hud-microbutton-Quest-Disabled"},
	["PIG_GuildMicroButton"]={Normal="hud-microbutton-Socials-Up",Pushed="hud-microbutton-Socials-Down",Disabled="hud-microbutton-Socials-Disabled"},
	["PIG_CollectionsMicroButton"]={Normal="hud-microbutton-Mounts-Up",Pushed="hud-microbutton-Mounts-Down",Disabled="hud-microbutton-Mounts-Disabled"},	
	["PIG_LFGMicroButton"]={Normal="hud-microbutton-LFG-Up",Pushed="hud-microbutton-LFG-Down",Disabled="hud-microbutton-LFG-Disabled"},
	["PIG_MainMenuMicroButton"]={Normal="hud-microbutton-MainMenu-Up",Pushed="hud-microbutton-MainMenu-Down",Disabled="hud-microbutton-MainMenu-Disabled"},
	["PIG_EJMicroButton"]={Normal="hud-microbutton-EJ-Up",Pushed="hud-microbutton-EJ-Down",Disabled="hud-microbutton-EJ-Disabled"},
	["PIG_StoreMicroButton"]={Normal="hud-microbutton-BStore-Up",Pushed="hud-microbutton-BStore-Down",Disabled="hud-microbutton-BStore-Disabled"},
	["PIG_CharacterMicroButton"]={Normal="hud-microbutton-Character-Up",Pushed="hud-microbutton-Character-Down",Disabled="",icon={"MicroButtonPortrait",{WWW*0.17,-WWW*0.16,-WWW*0.162,WWW*0.16},nil,"groupfinder-waitdot"}},
	["PIG_PVPMicroButton"]={Normal="hud-microbutton-Character-Up",Pushed="hud-microbutton-Character-Down",Disabled="",icon={"PVPMicroButtonTexture",{WWW*0.18,-WWW*0.23,-WWW*0.19,WWW*0.17},"communities-create-button-wow-alliance"}},
	["PIG_MacroMicroButton"]={Normal="hud-microbutton-Character-Up",Pushed="hud-microbutton-Character-Down",Disabled="",icon={"diy",{WWW*0.18,-WWW*0.26,-WWW*0.16,WWW*0.18},136377}},
	["PIG_AddonsMicroButton"]={Normal="hud-microbutton-Character-Up",Pushed="hud-microbutton-Character-Down",Disabled="",icon={"diy",{WWW*0.12,-WWW*0.18,-WWW*0.11,WWW*0.16},130781}},
	["PIG_MainMenuBarBackpackButton"]={Normal="hud-microbutton-Character-Up",Pushed="hud-microbutton-Character-Down",Disabled="",icon={"MainMenuBarBackpackButtonIconTexture",{WWW*0.12,-WWW*0.11,-WWW*0.11,WWW*0.11}}},
}
local BlizzardIconSet = {
	["PIG_FriendsMicroButton"]="socialqueuing-icon-group",
}
local function SetTextureAtlas(fujik,iconID)
	if type(iconID)=="number" then
		fujik:SetTexture(iconID)
	else
		fujik:SetAtlas(iconID)
	end
end
--
local tabname,topoffset = "微型"..SLASH_TEXTTOSPEECH_MENU,-180
fujiF.Open = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,topoffset},{"重新布局"..tabname.."/"..BAGSLOT,"开启后将重新布局"..NPE_MOVE..tabname.."/"..BAGSLOT.."的位置"})
fujiF.Open:SetScript("OnClick", function (self)
	if InCombatLockdown() then self:SetChecked(false) PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
	if self:GetChecked() then
		PIGA["PigLayout"]["MicroMenu"]["Open"]=true;
		fujiF.setMicroF:Show()
	else
		PIGA["PigLayout"]["MicroMenu"]["Open"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
	fujiF.add_MicroMenu()
end);
fujiF:HookScript("OnShow", function (self)
	self.Open:SetChecked(PIGA["PigLayout"]["MicroMenu"]["Open"])
	if PIGA["PigLayout"]["MicroMenu"]["Open"] then
		self.setMicroF:Show()
	else
		self.setMicroF:Hide()
	end
end);
fujiF.setMicroF = PIGFrame(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 10, topoffset-20})
fujiF.setMicroF:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -10, 10);
fujiF.setMicroF:PIGSetBackdrop(0)
fujiF.setMicroF.cz = PIGButton(fujiF.setMicroF,{"TOPRIGHT",fujiF.setMicroF,"TOPRIGHT",-20,-20},{60,22},"重置");
fujiF.setMicroF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["MicroMenu"]=addonTable.Default["PigLayout"]["MicroMenu"]
	PIGA["PigLayout"]["MicroMenu"]["Open"]=true;
	fujiF.UpdateUIScaleXY()
	fujiF.setMicroF:Hide()
	fujiF.setMicroF:Show()
end);
fujiF.setMicroF.ScaleT = PIGFontString(fujiF.setMicroF,{"TOPLEFT", fujiF.setMicroF, "TOPLEFT", 20, -20},"缩放")
fujiF.setMicroF.Scale = PIGSlider(fujiF.setMicroF,{"LEFT",fujiF.setMicroF.ScaleT,"LEFT",100,0},{0.6, 1.8, 0.01,{["Right"]="%"}})
fujiF.setMicroF.Scale.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["MicroMenu"]["Scale"]=arg1;
	fujiF.UpdateUIScaleXY()
end)
fujiF.setMicroF.IntervalT = PIGFontString(fujiF.setMicroF,{"TOPLEFT", fujiF.setMicroF, "TOPLEFT", 20, -60},"按钮间距")
fujiF.setMicroF.Interval = PIGSlider(fujiF.setMicroF,{"LEFT", fujiF.setMicroF.IntervalT, "LEFT", 100, 0},{-6, 30, 1})
fujiF.setMicroF.Interval.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["MicroMenu"]["Interval"]=arg1;
	fujiF.UpdateUIScaleXY()
end)
fujiF.setMicroF.AnchorPointT = PIGFontString(fujiF.setMicroF,{"TOPLEFT", fujiF.setMicroF, "TOPLEFT", 20, -100},"定位锚点")
fujiF.setMicroF.AnchorPoint=PIGDownMenu(fujiF.setMicroF,{"LEFT", fujiF.setMicroF.AnchorPointT, "LEFT", 106, 0},{120,nil})
local xyList = {"TOP","BOTTOM","TOPLEFT","TOPRIGHT","BOTTOMLEFT","BOTTOMRIGHT"}
local xyListName = {["TOP"]="顶部",["BOTTOM"]="底部",["TOPLEFT"]="左上角",["TOPRIGHT"]="右上角",["BOTTOMLEFT"]="左下角",["BOTTOMRIGHT"]="右下角"}
function fujiF.setMicroF.AnchorPoint:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#xyList do
	 	info.text, info.arg1 = xyListName[xyList[i]], xyList[i]
	 	info.checked = xyList[i] == PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.setMicroF.AnchorPoint:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=arg1
	PIGA["PigLayout"]["MicroMenu"]["AnchorPointX"]=0
	PIGA["PigLayout"]["MicroMenu"]["AnchorPointY"]=0
	fujiF.UpdateUIScaleXY()
	PIGCloseDropDownMenus()
end
fujiF.setMicroF.MoveTime = PIGCheckbutton(fujiF.setMicroF,{"LEFT",fujiF.setMicroF.AnchorPoint,"RIGHT",40,0},{"移动小地图时间到菜单中间"})
fujiF.setMicroF.MoveTime:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["MicroMenu"]["MoveTime"]=true;
	else
		PIGA["PigLayout"]["MicroMenu"]["MoveTime"]=nil
	end
	PIG_OptionsUI.RLUI:Show()
end);
fujiF.setMicroF.AnchorPointXT = PIGFontString(fujiF.setMicroF,{"TOPLEFT", fujiF.setMicroF, "TOPLEFT", 20, -140},"定位坐标X")
fujiF.setMicroF.AnchorPointX = PIGSlider(fujiF.setMicroF,{"LEFT", fujiF.setMicroF.AnchorPointXT, "LEFT", 100, 0},{-800, 800, 1},300)
fujiF.setMicroF.AnchorPointX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["MicroMenu"]["AnchorPointX"]=arg1;
	fujiF.UpdateUIScaleXY()
end)
fujiF.setMicroF.AnchorPointYT = PIGFontString(fujiF.setMicroF,{"TOPLEFT", fujiF.setMicroF, "TOPLEFT", 20, -180},"定位坐标Y")
fujiF.setMicroF.AnchorPointY = PIGSlider(fujiF.setMicroF,{"LEFT", fujiF.setMicroF.AnchorPointYT, "LEFT", 100, 0},{-600, 600, 1},300)
fujiF.setMicroF.AnchorPointY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["MicroMenu"]["AnchorPointY"]=arg1;
	fujiF.UpdateUIScaleXY()
end)
fujiF.setMicroF.ListBut={}
for i=1,Old_MicroButNum do
	local pindaol = PIGCheckbutton(fujiF.setMicroF,nil,{"点击显示或隐藏按钮"},nil,nil,i)
	pindaol.Text:SetText("")
	pindaol:SetHitRectInsets(0,-20,0,0);
	pindaol.icon = pindaol:CreateTexture();
	pindaol.icon:SetSize(20,20);
	pindaol.icon:SetPoint("LEFT",pindaol,"RIGHT",0,0);
	fujiF.setMicroF.ListBut[i]=pindaol
	if i==1 then
		pindaol:SetPoint("TOPLEFT",fujiF.setMicroF,"TOPLEFT",20,-220);
	elseif i==11 then
		pindaol:SetPoint("TOPLEFT",fujiF.setMicroF.ListBut[1],"BOTTOMLEFT",0,-10);
	else
		pindaol:SetPoint("LEFT", fujiF.setMicroF.ListBut[i-1], "RIGHT", 40, 0);
	end
	pindaol:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["PigLayout"]["MicroMenu"]["HideBut"][PIG_MICRO_BUTTONS[i]]=nil;
		else
			PIGA["PigLayout"]["MicroMenu"]["HideBut"][PIG_MICRO_BUTTONS[i]]=true;
		end
		PIG_OptionsUI.RLUI:Show()
	end);
	local diyicon = Data.DiyIcon and Data.DiyIcon[PIG_MICRO_BUTTONS[i]]
	if diyicon then
		local Atlasinfo = C_Texture.GetAtlasInfo(diyicon.icon)
		if Atlasinfo then
			pindaol.icon:SetAtlas(diyicon.icon)
		else
			if not PIGSetAtlas(pindaol.icon,diyicon.icon) then
				pindaol.icon:SetTexture(diyicon.icon)
			end
		end
	else
		local blizzardicon = BlizzardIcon[PIG_MICRO_BUTTONS[i]]
		if blizzardicon then
			if blizzardicon.icon then
				if blizzardicon.icon[1]=="diy" then
					SetTextureAtlas(pindaol.icon,blizzardicon.icon[3])
				else
					if blizzardicon.icon[3] then
						SetTextureAtlas(pindaol.icon,blizzardicon.icon[3])
					elseif blizzardicon.icon[4] then
						SetTextureAtlas(pindaol.icon,blizzardicon.icon[4])
					else
						SetTextureAtlas(pindaol.icon,_G[blizzardicon.icon[1]]:GetTexture())
					end
				end
			else
				pindaol.icon:SetAtlas(blizzardicon.Normal)
			end
		elseif BlizzardIconSet[PIG_MICRO_BUTTONS[i]] then
			pindaol.icon:SetAtlas(BlizzardIconSet[PIG_MICRO_BUTTONS[i]])
		end
	end
end
fujiF.setMicroF:HookScript("OnShow", function(self)
	self.Scale:PIGSetValue(PIGA["PigLayout"]["MicroMenu"]["Scale"])
	self.Interval:PIGSetValue(PIGA["PigLayout"]["MicroMenu"]["Interval"])
	self.AnchorPoint:PIGDownMenu_SetText(xyListName[PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]])
	self.AnchorPointX:PIGSetValue(PIGA["PigLayout"]["MicroMenu"]["AnchorPointX"])
	self.AnchorPointY:PIGSetValue(PIGA["PigLayout"]["MicroMenu"]["AnchorPointY"])
	self.MoveTime:SetChecked(PIGA["PigLayout"]["MicroMenu"]["MoveTime"])
	for i=1,Old_MicroButNum do
		fujiF.setMicroF.ListBut[i]:SetChecked(not PIGA["PigLayout"]["MicroMenu"]["HideBut"][PIG_MICRO_BUTTONS[i]])
	end
end)
----------
local function SetTextureXY(fujik,tex1,pointXY)
	if fujik and tex1 and pointXY then
		tex1:ClearAllPoints();
		tex1:SetPoint("TOPLEFT",fujik,"TOPLEFT",pointXY[1],pointXY[2]);
		tex1:SetPoint("BOTTOMRIGHT",fujik,"BOTTOMRIGHT",pointXY[3],pointXY[4]);
	end
end
local function CZPoints(fujik,uix)
	if not fujik or not uix then return end
	uix:SetParent(fujik)
    uix:ClearAllPoints()
    uix:SetPoint('TOPLEFT', fujik, 'TOPLEFT', 0, 0)
    uix:SetPoint('BOTTOMRIGHT', fujik, 'BOTTOMRIGHT', 0, 0)
    uix:SetHitRectInsets(0,0,0,0);
end
local function SetEnableDisable(bizbut)
	local playerLevel = UnitLevel("player");
	bizbut.minLevel=bizbut.minLevel or 10
	if PIG_MaxTocversion(50000) and playerLevel < bizbut.minLevel or C_SpecializationInfo and C_SpecializationInfo.CanPlayerUseTalentSpecUI and not C_SpecializationInfo.CanPlayerUseTalentSpecUI() then
		bizbut:Disable();
		if bizbut and bizbut.icon then
			bizbut.icon:SetDesaturated(true)
		end
	else
		bizbut:Enable();
		if bizbut and bizbut.icon then
			bizbut.icon:SetDesaturated(false)
		end
	end
end
local function Update_TalentMicroButtonAlert()
	if not TalentMicroButtonAlert then return end
	TalentMicroButtonAlert:ClearAllPoints()
	if PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=="TOP" then
		TalentMicroButtonAlert:SetPoint('TOP', TalentMicroButton, 'BOTTOM', 0, 0)
	else
		TalentMicroButtonAlert:SetPoint('BOTTOM', TalentMicroButton, 'TOP', 0, 10)
	end
end
local UpdateMicroButFun = {
	["PIG_TalentMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_TalentMicroButton"]]
		bizbut:Show()
		SetEnableDisable(bizbut)
	end,
	["PIG_GuildMicroButton"]=function(but)
		local bizbut = _G[GameMenu["PIG_GuildMicroButton"]]
		bizbut:Show()
		bizbut:SetHighlightTexture("hud-microbutton-highlight")
		if IsInGuild() then
			bizbut:Enable();
			if but and but.icon then
				but.icon:SetDesaturated(false)
			end
			if ( CommunitiesFrame and CommunitiesFrame:IsShown() ) or ( GuildFrame and GuildFrame:IsShown() and FriendsFrame:IsShown()) then
				bizbut:SetButtonState("PUSHED", true);
			else
				bizbut:SetButtonState("NORMAL");
			end
		else
			bizbut:Disable();
			if but and but.icon then
				but.icon:SetDesaturated(true)
			end
		end
	end,
	["PIG_MainMenuMicroButton"]=function()
		if GameMenuFrame and GameMenuFrame:IsShown() then
			MainMenuMicroButton:SetButtonState("PUSHED", true);
			MainMenuMicroButton_SetPushed();
		else
			MainMenuMicroButton:SetButtonState("NORMAL");
			MainMenuMicroButton_SetNormal();
		end
		MainMenuMicroButton:ClearAllPoints()
	    MainMenuMicroButton:SetPoint('TOPLEFT', PIG_MainMenuMicroButton, 'TOPLEFT', 0, 0)
	    MainMenuMicroButton:SetPoint('BOTTOMRIGHT', PIG_MainMenuMicroButton, 'BOTTOMRIGHT', 0, 0)
	    MainMenuMicroButton:SetHitRectInsets(0,0,0,0);
	end,
	["PIG_PVPMicroButton"]=function(self)
		local bizbut = _G[GameMenu["PIG_PVPMicroButton"]]
		SetEnableDisable(bizbut)
	end,
	["PIG_LFGMicroButton"]=function(self)
		local bizbut = _G[GameMenu["PIG_LFGMicroButton"]]
		SetEnableDisable(bizbut)
	end,
}
local MicroButLoad = {
	["PIG_FriendsMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_FriendsMicroButton"]]
		bizbut.TextureXY={-WWW*0.02,-WWW*0.05,WWW*0.1,WWW*0.05}
		SetTextureXY(bizbut,bizbut:GetNormalTexture(),bizbut.TextureXY)
		SetTextureXY(bizbut,bizbut:GetPushedTexture(),bizbut.TextureXY)
		SetTextureXY(bizbut,bizbut:GetDisabledTexture(),bizbut.TextureXY)
	end,
	["PIG_GuildMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_GuildMicroButton"]]
		bizbut:HookScript("OnEnter", function(self)
			if not IsInGuild() then
				if ( CommunitiesFrame_IsEnabled() ) then
					bizbut.tooltipText = MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB");
				elseif ( IsInGuild() ) then
					bizbut.tooltipText = MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB");
				else
					bizbut.tooltipText = MicroButtonTooltipText(LOOKINGFORGUILD, "TOGGLEGUILDTAB");
				end
				bizbut.newbieText = NEWBIE_TOOLTIP_GUILDTAB;
				GameTooltip_SetDefaultAnchor(GameTooltip, self);
				GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
				GameTooltip:AddLine(ERR_GUILD_PLAYER_NOT_IN_GUILD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
				GameTooltip:Show();
			end
		end)
	end,
	["PIG_EJMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_EJMicroButton"]]
		bizbut.openui= _G["AtlasLoot_GUI-Frame"]
		bizbut.tooltipText = MicroButtonTooltipText(VIEW..ITEMS..BATTLE_PET_SOURCE_1,"");
		bizbut.newbieText = VIEW..ITEMS.."("..TRANSMOG_SOURCE_1.."/"..TRANSMOG_SOURCE_2..CONTRIBUTION_REWARD_TOOLTIP_TITLE.."/"..TRANSMOG_SOURCE_3.."/"..TRANSMOG_SOURCE_4.."/"..TRANSMOG_SOURCE_5..CONTRIBUTION_REWARD_TOOLTIP_TITLE.."/"..TRANSMOG_SOURCE_6..CREATE_PROFESSION..")";
		bizbut:HookScript("OnEnter", function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
			if not self.openui then
				GameTooltip:AddLine("没有安装AtlasLoot", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
				GameTooltip:Show();
			end
		end)
		bizbut:HookScript("OnClick", function (self,button)
			if self.openui then
				local uidaq = QF_AtlasLootUI or self.openui
				if uidaq:IsShown() then
					uidaq:Hide()
				else
					uidaq:Show()
				end
			else
				PIG_OptionsUI:ErrorMsg("没有安装AtlasLoot", "R")
			end
		end);
	end,
	["PIG_MacroMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_MacroMicroButton"]]
		bizbut.tooltipText = MicroButtonTooltipText(MACROS,"");
		bizbut.newbieText = MACRO_HELP_TEXT_LINE3;
		bizbut:HookScript("OnEnter", function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
		end)
		bizbut:SetAttribute("type", "macro")
		bizbut:SetAttribute("macrotext", "/macro")
	end,
	["PIG_AddonsMicroButton"]=function()
		local bizbut = _G[GameMenu["PIG_AddonsMicroButton"]]
		bizbut.tooltipText = MicroButtonTooltipText(ADDONS..L["CONFIG_TABNAME"],"");
		bizbut.newbieText = "载入你已保存的插件状态配置";
		bizbut:HookScript("OnEnter", function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
		end)
		bizbut:SetupMenu(function(dropdown, rootDescription)
			rootDescription:SetTag("PIG_MENU_ADDONSMICROBUT");
			for adi=1,#PIGA["FramePlus"]["AddonStatus"] do
				rootDescription:CreateButton(string.format(GUILDBANK_NAME_CONFIG,LOAD_ADDON)..PIGA["FramePlus"]["AddonStatus"][adi][1],function() AddonList.PIG_loadAddon_(adi) end);
			end
			rootDescription:CreateButton(RELOADUI,function() ReloadUI(); end);
			rootDescription:CreateButton(EDIT..ADDONS..L["CONFIG_TABNAME"],function() if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end ShowUIPanel(AddonList) end);
		end);
	end,
}
local factionGroup = UnitFactionGroup("player")
if factionGroup=="Horde" then
	BlizzardIcon.PIG_PVPMicroButton.icon[2],BlizzardIcon.PIG_PVPMicroButton.icon[3]={WWW*0.18,-WWW*0.23,-WWW*0.19,WWW*0.17},"communities-create-button-wow-horde"
end
function fujiF.add_MicroMenu()
	if not PIGA["PigLayout"]["MicroMenu"]["Open"] then return end
	if fujiF.openok then return end
	fujiF.openok=true
	--处理系统原生
	if not PIGA["PigLayout"]["MicroMenu"]["HideBut"]["PIG_FriendsMicroButton"] then
		FriendsMicroButtonCount:SetTextColor(0, 1, 0, 1);
		FriendsMicroButtonCount:SetFont(ChatFontNormal:GetFont(), 14,"OUTLINE")
		FriendsMicroButtonCount:ClearAllPoints();
		FriendsMicroButtonCount:SetPoint("BOTTOMRIGHT",FriendsMicroButton,"BOTTOMRIGHT",0,3);
	end
	if not PIGA["PigLayout"]["MicroMenu"]["HideBut"]["PIG_MainMenuBarBackpackButton"] then
		local regions = {MainMenuBarBackpackButton:GetRegions()}
		for _,v1 in pairs(regions) do
			if v1~=MainMenuBarBackpackButtonIconTexture and v1~=MainMenuBarBackpackButtonCount then
				v1:ClearAllPoints()
			end
		end
		MainMenuBarBackpackButtonIconTexture:SetDrawLayer("OVERLAY", 5)
		MainMenuBarBackpackButtonCount:SetDrawLayer("OVERLAY", 7)
		MainMenuBarBackpackButtonCount:ClearAllPoints();
		MainMenuBarBackpackButtonCount:SetPoint("BOTTOMRIGHT",MainMenuBarBackpackButton,"BOTTOMRIGHT",0,3);
		hooksecurefunc("MainMenuBarBackpackButton_UpdateFreeSlots", function()
			MainMenuBarBackpackButton.Count:SetText(MainMenuBarBackpackButton.freeSlots);
		end)
		MainMenuBarBackpackButton.Count:SetText(MainMenuBarBackpackButton.freeSlots);
	else
		MainMenuBarBackpackButton:SetParent(UIParent)
		MainMenuBarBackpackButton:SetScale(PIGA["PigLayout"]["MicroMenu"]["Scale"])
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-1,1);
	end
	if PIG_MaxTocversion(30000) then
		MinimapToggleButton:SetSize(28,28);
		MinimapToggleButton:SetPoint("CENTER",MinimapCluster,"TOPRIGHT",-16,-16);
		MinimapToggleButton:SetNormalTexture("orderhall-commandbar-mapbutton-up")
		MinimapToggleButton:SetPushedTexture("orderhall-commandbar-mapbutton-down")
		MinimapToggleButton:SetScript("OnClick", function(self)
			ToggleWorldMap();
		end)
		MainMenuMicroButton:SetScript("OnUpdate",nil)
	end
	--MainMenuBarPerformanceBar延迟颜色
	local HideList = {SocialsMicroButton,WorldMapMicroButton,HelpMicroButton,CharacterBag0Slot,CharacterBag1Slot,
		CharacterBag2Slot,CharacterBag3Slot,KeyRingButton,MainMenuBarPerformanceBar,MainMenuBarPerformanceBarFrameButton}
	for i=1,#HideList do
		if HideList[i] then
			HideList[i]:ClearAllPoints();
			HideList[i]:Hide()
		end
	end
	if KeyRingButton then
		hooksecurefunc("MainMenuBar_UpdateKeyRing", function()
			KeyRingButton:Hide()
		end)
	end
	for i=1,#Old_MicroBut do
		_G[Old_MicroBut[i]]:ClearAllPoints();
		if _G[Old_MicroBut[i].."Flash"] then
			_G[Old_MicroBut[i].."Flash"]:ClearAllPoints();
			_G[Old_MicroBut[i].."Flash"]:SetPoint("TOPLEFT",_G[Old_MicroBut[i]],"TOPLEFT",-WWW*0.11,WWW*0.12);
			_G[Old_MicroBut[i].."Flash"]:SetPoint("BOTTOMRIGHT",_G[Old_MicroBut[i]],"BOTTOMRIGHT",WWW*1.23,-WWW*0.84);
		end
	end
	hooksecurefunc("UpdateMicroButtons", function()
		for i=1,Old_MicroButNum do
			if UpdateMicroButFun[PIG_MICRO_BUTTONS[i]] then
				UpdateMicroButFun[PIG_MICRO_BUTTONS[i]]()
		    end
		end
	end)
	hooksecurefunc("MoveMicroButtons", function()
		CZPoints(PIG_CharacterMicroButton,CharacterMicroButton)
		CZPoints(PIG_PVPMicroButton,PVPMicroButton)
	end)
	for i=1,Old_MicroButNum do
		if not PIGA["PigLayout"]["MicroMenu"]["HideBut"][PIG_MICRO_BUTTONS[i]] then
			table.insert(New_PIG_MICRO_BUTTONS,PIG_MICRO_BUTTONS[i])
		end
	end
	--移动小地图时间
	local TimeManagerWWW = 50
	if PIGA["PigLayout"]["MicroMenu"]["MoveTime"] then
		local Butyiban=floor(#New_PIG_MICRO_BUTTONS*0.5)
		table.insert(New_PIG_MICRO_BUTTONS,Butyiban+1,"TimeManagerClockButton")
		EventUtil.ContinueOnAddOnLoaded("Blizzard_TimeManager", function()
			TimeManagerClockButton:SetParent(UIParent)
			TimeManagerClockButton:SetFrameStrata("MEDIUM")
			TimeManagerClockButton:ClearAllPoints()
			TimeManagerClockButton:SetPoint("TOP", UIParent, "TOP", 0, 0)
			local regions = {TimeManagerClockButton:GetRegions()}
			for k,v in pairs(regions) do
				if not v:GetName() then
					v:Hide()
				end
			end
			TimeManagerClockButton:SetSize(TimeManagerWWW,22);
			Create.PIGSetFont(TimeManagerClockTicker,16,PIGA["PigLayout"]["TopBar"]["FontMiaobian"])
			TimeManagerClockTicker:ClearAllPoints()
			TimeManagerClockTicker:SetAllPoints(TimeManagerClockButton)
		end)
	end
	for i=1,#New_PIG_MICRO_BUTTONS do
		local MicroBut=CreateFrame("Frame", New_PIG_MICRO_BUTTONS[i], UIParent);
		MicroBut:SetSize(WWW,WWW*1.14);
		local BlizzardName = GameMenu[New_PIG_MICRO_BUTTONS[i]]
		local BlizzardBut = _G[BlizzardName]
		if BlizzardBut then
			BlizzardBut:SetParent(MicroBut)
			BlizzardBut:Show()
		else
			local MicroButType = {"Button",nil}--"SecureHandlerClickTemplate"
			if New_PIG_MICRO_BUTTONS[i]=="PIG_MacroMicroButton" then
				MicroButType[2]="SecureActionButtonTemplate"
			elseif New_PIG_MICRO_BUTTONS[i]=="PIG_AddonsMicroButton" then
				MicroButType[1]="DropdownButton"
			end
			BlizzardBut = CreateFrame(MicroButType[1],BlizzardName,MicroBut, MicroButType[2]);
			BlizzardBut:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
		end
		BlizzardBut:ClearAllPoints()
	    BlizzardBut:SetPoint('TOPLEFT', MicroBut, 'TOPLEFT', 0, 0)
	    BlizzardBut:SetPoint('BOTTOMRIGHT', MicroBut, 'BOTTOMRIGHT', 0, 0)
	    BlizzardBut:SetHitRectInsets(0,0,0,0);
		if MicroButLoad[New_PIG_MICRO_BUTTONS[i]] then
			MicroButLoad[New_PIG_MICRO_BUTTONS[i]]()
	    end
	    if UpdateMicroButFun[New_PIG_MICRO_BUTTONS[i]] then
			UpdateMicroButFun[New_PIG_MICRO_BUTTONS[i]]()
	    end
		--icon
		local diyicon = Data.DiyIcon and Data.DiyIcon[New_PIG_MICRO_BUTTONS[i]]
		if diyicon then
			local regions = {BlizzardBut:GetRegions()}
		    for _,v1 in pairs(regions) do
		    	if v1~=FriendsMicroButtonCount and v1~=MainMenuBarBackpackButtonIconTexture and v1~=MainMenuBarBackpackButtonCount then
		    		v1:ClearAllPoints()
		    	end
		    end
		    BlizzardBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		    if not BlizzardBut.icon then
	    		BlizzardBut.icon = BlizzardBut:CreateTexture()
			end
			local Atlasinfo = C_Texture.GetAtlasInfo(diyicon.icon)
			if Atlasinfo then
				BlizzardBut.icon:SetAtlas(diyicon.icon)
			else
				if not PIGSetAtlas(BlizzardBut.icon,diyicon.icon) then
					BlizzardBut.icon:SetTexture(diyicon.icon)
				end
			end
			if diyicon.point then
				SetTextureXY(BlizzardBut,BlizzardBut.icon,{diyicon.point[1],diyicon.point[2],diyicon.point[3],diyicon.point[4]})
				BlizzardBut.XY={diyicon.point[1],diyicon.point[2],diyicon.point[3],diyicon.point[4]}
			else
				SetTextureXY(BlizzardBut,BlizzardBut.icon,{0,0,0,0})
				BlizzardBut.XY={0,0,0,0}
			end
		else
			BlizzardBut:SetHighlightTexture("hud-microbutton-highlight")
			local blizzardicon = BlizzardIcon[New_PIG_MICRO_BUTTONS[i]]
			if blizzardicon then
				if blizzardicon.Normal then BlizzardBut:SetNormalAtlas(blizzardicon.Normal) end
				if blizzardicon.Pushed then BlizzardBut:SetPushedAtlas(blizzardicon.Pushed) end
				if blizzardicon.Disabled then BlizzardBut:SetDisabledAtlas(blizzardicon.Disabled) end
				if blizzardicon.icon then
					if blizzardicon.icon[1]=="diy" then
						BlizzardBut.icon = BlizzardBut:CreateTexture(nil,"OVERLAY")
						SetTextureAtlas(BlizzardBut.icon,blizzardicon.icon[3])
						SetTextureXY(BlizzardBut,BlizzardBut.icon,{blizzardicon.icon[2][1],blizzardicon.icon[2][2],blizzardicon.icon[2][3],blizzardicon.icon[2][4]})
						BlizzardBut.XY={blizzardicon.icon[2][1],blizzardicon.icon[2][2],blizzardicon.icon[2][3],blizzardicon.icon[2][4]}
					else
						BlizzardBut.icon=_G[blizzardicon.icon[1]]
						SetTextureXY(BlizzardBut,_G[blizzardicon.icon[1]],{blizzardicon.icon[2][1],blizzardicon.icon[2][2],blizzardicon.icon[2][3],blizzardicon.icon[2][4]})
						BlizzardBut.XY={blizzardicon.icon[2][1],blizzardicon.icon[2][2],blizzardicon.icon[2][3],blizzardicon.icon[2][4]}
						if blizzardicon.icon[3] then
							SetTextureAtlas(BlizzardBut.icon,blizzardicon.icon[3])
						end
					end	
				end
			end
		end
		BlizzardBut:HookScript("OnMouseDown", function(self)
			if self:IsEnabled() and self.icon then
				self.icon:SetPoint("TOPLEFT",self,"TOPLEFT",BlizzardBut.XY[1]-1.5,BlizzardBut.XY[2]-1.5);
				self.icon:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",BlizzardBut.XY[3]-1.5,BlizzardBut.XY[4]-1.5);
			end
		end);
		BlizzardBut:HookScript("OnMouseUp", function(self)
			if self:IsEnabled() and self.icon then
				self.icon:SetPoint("TOPLEFT",self,"TOPLEFT",BlizzardBut.XY[1],BlizzardBut.XY[2]);
				self.icon:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",BlizzardBut.XY[3],BlizzardBut.XY[4]);
			end
		end);
	end
	function fujiF.UpdateUIScaleXY()
		if InCombatLockdown() then PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
		local New_num =#New_PIG_MICRO_BUTTONS
		for i=1,New_num do
			if not PIGA["PigLayout"]["MicroMenu"]["HideBut"][New_PIG_MICRO_BUTTONS[i]] then
				local MicroBut = _G[New_PIG_MICRO_BUTTONS[i]]
				MicroBut:ClearAllPoints();
				if i==1 then
					local ewaixex=0
					if PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=="TOP" or PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=="BOTTOM" then
						ewaixex =-(New_num-1)*0.5*(WWW+PIGA["PigLayout"]["MicroMenu"]["Interval"])
						if PIGA["PigLayout"]["MicroMenu"]["MoveTime"] then
							ewaixex =ewaixex-(TimeManagerWWW-WWW)*0.5
						end
					elseif PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=="TOPRIGHT" or PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"]=="BOTTOMRIGHT" then
						ewaixex =-(New_num-1)*(WWW+PIGA["PigLayout"]["MicroMenu"]["Interval"])
					end
					MicroBut:SetPoint(PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"],UIParent,PIGA["PigLayout"]["MicroMenu"]["AnchorPoint"],ewaixex+PIGA["PigLayout"]["MicroMenu"]["AnchorPointX"],PIGA["PigLayout"]["MicroMenu"]["AnchorPointY"]);
				else
					MicroBut:SetPoint("LEFT",_G[New_PIG_MICRO_BUTTONS[i-1]],"RIGHT",PIGA["PigLayout"]["MicroMenu"]["Interval"],0);
				end
				MicroBut:SetScale(PIGA["PigLayout"]["MicroMenu"]["Scale"])
			end
		end
		Update_TalentMicroButtonAlert()
	end
	fujiF.UpdateUIScaleXY()
end
fujiF.add_MicroMenu()
end