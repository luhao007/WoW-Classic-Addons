local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGQuickBut=Create.PIGQuickBut
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local Backdropinfo=Create.Backdropinfo
--=======================================
local ActionBarfun=addonTable.ActionBarfun
local RTabFrame=ActionBarfun.RTabFrame
local fuFrame=ActionBarfun.fuFrame
local fuFrameBut=ActionBarfun.fuFrameBut
------
local barName, zongshu, anniugeshu, anniujiange="Pigbar",4,12,6;
local Showtiaojian = {ALWAYS..SHOW,LEAVING_COMBAT..HIDE,BATTLEFIELD_JOIN..HIDE,SPELL_FAILED_BAD_IMPLICIT_TARGETS..HIDE,};
---排列方式
local pailieName={"横向","竖向","6×2","2×6","4×3","3×4"};
local paiNum = #pailieName
local pailieweizhi={
	{
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
	},
	{
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
		{"TOP","BOTTOM",0,-anniujiange,1},
	},
	{
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,6},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
	},
	{
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,2},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,2},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,2},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,2},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,2},
		{"LEFT","RIGHT",anniujiange,0,1},
	},
	{
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,4},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,4},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
	},
	{
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,3},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,3},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"TOPLEFT","BOTTOMLEFT",0,-anniujiange,3},
		{"LEFT","RIGHT",anniujiange,0,1},
		{"LEFT","RIGHT",anniujiange,0,1},
	},
};
local function PailieFun(index,id)
	for x=1,paiNum do
		if PIGA_Per["PigAction"]["Pailie"][index] == x then
			_G[barName..index.."_But"..id]:ClearAllPoints();
			_G[barName..index.."_But"..id]:SetPoint(pailieweizhi[x][id-1][1],_G[barName..index.."_But"..(id-pailieweizhi[x][id-1][5])],pailieweizhi[x][id-1][2],pailieweizhi[x][id-1][3],pailieweizhi[x][id-1][4])
		end
	end
end

local function ShowHideNumFun(self,CVarV,tuodong)
	if tuodong then self:SetAnniuNumFun() return end
	local CVarV = CVarV or GetCVar("alwaysShowActionBars")
	if CVarV=="0" then
		if not self.Type then
			self:Hide()
		end
	elseif CVarV=="1" then
		self:SetAnniuNumFun()
	end
end
-----------
local function ShowHideEvent(self,canshuV)
	if canshuV==1 then
		RegisterStateDriver(self, "combatYN", "[] show; hide");--一直显示
	elseif canshuV==2 then
		RegisterStateDriver(self, "combatYN", "[combat] show; hide");--脱战后隐藏
	elseif canshuV==3 then
		RegisterStateDriver(self, "combatYN", "[nocombat] show; hide");--进战斗隐藏
	elseif canshuV==4 then
		RegisterStateDriver(self, "combatYN", "[exists] show; hide");--无目标隐藏
	end
end
------------
local Action_plusF,Action_plusTabBut =PIGOptionsList_R(RTabFrame,L["ACTION_TABNAME3"],100)
for index=1,zongshu do
	local tishixinx = "PIG"..ACTIONBAR_LABEL.."|cff00FF00"..index.."|r"
	local Checkbut = PIGCheckbutton(Action_plusF, nil,{tishixinx,tishixinx}, nil, "PigBarOptionsCheckbut"..index);
	if index==1 then
		Checkbut:SetPoint("TOPLEFT",Action_plusF,"TOPLEFT",20,-20);
	else
		Checkbut:SetPoint("TOPLEFT",_G["PigBarOptionsCheckbut"..(index-1)],"BOTTOMLEFT",0,-76);
	end
	Checkbut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA_Per["PigAction"]["Open"][index]=true
			ActionBarfun.Pig_Action()
		else
			PIGA_Per["PigAction"]["Open"][index]=false
			Pig_Options_RLtishi_UI:Show()
		end
		Action_plusF:OnShow_ope()
	end);
	Checkbut.ShowHide=PIGDownMenu(Checkbut,{"LEFT",Checkbut.Text,"RIGHT",20,0},{130,24})
	function Checkbut.ShowHide:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#Showtiaojian,1 do
		    info.text, info.arg1 = Showtiaojian[i], i
		    info.checked = i==PIGA_Per["PigAction"]["ShowTJ"][index]
			Checkbut.ShowHide:PIGDownMenu_AddButton(info)
		end 
	end
	function Checkbut.ShowHide:PIGDownMenu_SetValue(value,arg1,arg2)
		if InCombatLockdown()  then 
			PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT)
			return 
		end
		Checkbut.ShowHide:PIGDownMenu_SetText(value)
		PIGA_Per["PigAction"]["ShowTJ"][index] = arg1;
		if PIGA_Per["PigAction"]["Open"][index] then
			local max=PIGA_Per["PigAction"]["AnniuNum"][index]
			for id=1,anniugeshu do
				if id<=max then
					ShowHideEvent(_G[barName..index.."_But"..id],arg1)
				end
			end
		end
		PIGCloseDropDownMenus()
	end
	Checkbut.Lockdongzuotiao = PIGCheckbutton(Checkbut, {"LEFT",Checkbut.ShowHide,"RIGHT",30,0},{LOCK_FRAME,LOCK_FOCUS_FRAME..", "..HIDE..MOVE_FRAME..EMBLEM_SYMBOL});
	Checkbut.Lockdongzuotiao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA_Per["PigAction"]["Lock"][index]=true
		else
			PIGA_Per["PigAction"]["Lock"][index]=false
		end
		if _G[barName..index] then
			if PIGA_Per["PigAction"]["Lock"][index] then
				_G[barName..index].yidong:Hide()
			else
				_G[barName..index].yidong:Show()
			end
		end
	end);
	Checkbut.Bindings = PIGButton(Checkbut,{"LEFT",Checkbut.Lockdongzuotiao.Text,"RIGHT",30,0},{76,20},KEY_BINDING);
	Checkbut.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	Checkbut.CZBUT = PIGButton(Checkbut,{"LEFT",Checkbut.Bindings,"RIGHT",40,0},{76,20},"重置位置");  
	Checkbut.CZBUT:SetScript("OnClick", function (self)
		local ckfame=_G[barName..index]
		ckfame:ClearAllPoints();
		ckfame:SetPoint("CENTER",UIParent,"CENTER",-200,-200+index*50)
	end);
	Checkbut.PailieT = PIGFontString(Checkbut,{"TOPLEFT",Checkbut,"BOTTOMLEFT",20,-16},"排列方式")
	Checkbut.Pailie=PIGDownMenu(Checkbut,{"LEFT",Checkbut.PailieT,"RIGHT",2,0},{80,24})
	function Checkbut.Pailie:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,paiNum,1 do
		    info.text, info.arg1 = pailieName[i], i
		    info.checked = i==PIGA_Per["PigAction"]["Pailie"][index]
			Checkbut.Pailie:PIGDownMenu_AddButton(info)
		end 
	end
	function Checkbut.Pailie:PIGDownMenu_SetValue(value,arg1,arg2)
		if InCombatLockdown()  then 
			PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT)
			return 
		end
		self:PIGDownMenu_SetText(value)
		PIGA_Per["PigAction"]["Pailie"][index] = arg1;
		for id=2,anniugeshu do
			PailieFun(index,id)
		end
		PIGCloseDropDownMenus()
	end
	Checkbut.AnniuNumT = PIGFontString(Checkbut,{"LEFT",Checkbut.Pailie,"RIGHT",20,0},"按钮数")
	Checkbut.AnniuNum=PIGDownMenu(Checkbut,{"LEFT",Checkbut.AnniuNumT,"RIGHT",2,0},{60,24})
	function Checkbut.AnniuNum:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,12,1 do
		    info.text, info.arg1 = i, i
		    info.checked = i ==PIGA_Per["PigAction"]["AnniuNum"][index]
			Checkbut.AnniuNum:PIGDownMenu_AddButton(info)
		end 
	end
	function Checkbut.AnniuNum:PIGDownMenu_SetValue(value,arg1,arg2)
		if InCombatLockdown()  then 
			PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT)
			return 
		end
		self:PIGDownMenu_SetText(value)
		PIGA_Per["PigAction"]["AnniuNum"][index] = arg1;
		for idx=1,anniugeshu do
			_G[barName..index.."_But"..idx]:SetAnniuNumFun(arg1)
		end
		PIGCloseDropDownMenus()
	end
	Checkbut.suofang_t = PIGFontString(Checkbut,{"LEFT",Checkbut.AnniuNum,"RIGHT",30,-2},"缩放:")
	local xiayiinfo = {0.6,1.4,0.01,{["Right"]="%"}}
	Checkbut.suofang = PIGSlider(Checkbut,{"LEFT",Checkbut.suofang_t,"RIGHT",10,0},xiayiinfo)
	Checkbut.suofang.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown()  then 
			PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT)
			return 
		end
		PIGA_Per["PigAction"]["Scale"][index]=arg1;
		_G[barName..index]:SetScale(arg1);
	end)
	PIGLine(Action_plusF,"TOP",-94*index)
	function Checkbut:ShowOpenFun()
		self:SetChecked(PIGA_Per["PigAction"]["Open"][index])
		if PIGA_Per["PigAction"]["Open"][index] then
			self.Lockdongzuotiao:SetChecked(PIGA_Per["PigAction"]["Lock"][index])
			self.ShowHide:PIGDownMenu_SetText(Showtiaojian[PIGA_Per["PigAction"]["ShowTJ"][index]])
			self.Pailie:PIGDownMenu_SetText(pailieName[PIGA_Per["PigAction"]["Pailie"][index]])
			self.AnniuNum:PIGDownMenu_SetText(PIGA_Per["PigAction"]["AnniuNum"][index])
			self.suofang:PIGSetValue(PIGA_Per["PigAction"]["Scale"][index])
		end
		self.Lockdongzuotiao:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.ShowHide:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.PailieT:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.Pailie:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.AnniuNumT:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.AnniuNum:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.suofang_t:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.suofang:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.Bindings:SetShown(PIGA_Per["PigAction"]["Open"][index])
		self.CZBUT:SetShown(PIGA_Per["PigAction"]["Open"][index])
	end
end
---底部
Action_plusF.dongzuotxian = PIGLine(Action_plusF,"TOP",-380)
Action_plusF.title = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",20,-10},L["LIB_TIPS"]..": ");
Action_plusF.title1 = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",40,-30},"|cff00ff001.此"..L["ACTION_TABNAME3"].."非其他插件调用系统预留给其他姿态(例如鸟德暗牧)的动作条，\n而是完全独立的动作条，不会占用角色其他形态的动作条按钮。|r")
Action_plusF.title1:SetJustifyH("LEFT");
---
Action_plusF.CZ = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",40,-80},"|cffFFff00动作条异常点此：|r");
Action_plusF.CZBUT = PIGButton(Action_plusF,{"LEFT",Action_plusF.CZ,"RIGHT",10,0},{76,20},"重置");  
Action_plusF.CZBUT:SetScript("OnClick", function ()
	StaticPopup_Show ("CHONGZHI_EWAIDONGZUO");
end);
StaticPopupDialogs["CHONGZHI_EWAIDONGZUO"] = {
	text = "此操作将|cffff0000重置|r"..L["ACTION_TABNAME3"].."配置。\n确定重置?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		PIGA_Per["PigAction"] = addonTable.Default_Per["PigAction"];
		Pig_Options_RLtishi_UI:Show()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
Action_plusF:HookScript("OnShow", function(self)
	for index=1,zongshu do
		local Checkbut=_G["PigBarOptionsCheckbut"..index]
		Checkbut:ShowOpenFun()
	end
end)
---add------------------
local PigMacroEventCount =0;
local PigMacroDeleted = false;
local PigMacroCount=0
local ActionFun=addonTable.Fun.ActionFun
local PIGUseKeyDown=ActionFun.PIGUseKeyDown
local Update_Attribute=ActionFun.Update_Attribute
local Update_Icon=ActionFun.Update_Icon
local Update_Cooldown=ActionFun.Update_Cooldown
local Update_Count=ActionFun.Update_Count
local Update_bukeyong=ActionFun.Update_bukeyong
local Update_State=ActionFun.Update_State
local Update_PostClick=ActionFun.Update_PostClick
local loadingButInfo=ActionFun.loadingButInfo
local Update_OnEnter=ActionFun.Update_OnEnter
local Cursor_Fun=ActionFun.Cursor_Fun
local Update_Macro=ActionFun.Update_Macro
local Update_Equipment=ActionFun.Update_Equipment

local ActionW = ActionButton1:GetWidth()
for index=1,zongshu do
	local Pig_bar=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",-200,-200+index*50},{0.01,ActionW-4},barName..index)
	Pig_bar:SetMovable(true)
	Pig_bar:SetUserPlaced(true)
	Pig_bar:SetClampedToScreen(true)
end
local function ADD_ActionBar(index)
	if not PIGA_Per["PigAction"]["Open"][index] then return end
	local Pig_bar=_G[barName..index]
	if Pig_bar.yidong then return end
	-- Pig_bar:SetAttribute("type", "actionbar");
	-- Pig_bar:SetAttribute("actionbar", index+100);
	if PIGA['ActionBar']['ActionBar_bili'] then
		Pig_bar:SetScale(PIGA['ActionBar']['ActionBar_bili_value']);
	end
	Pig_bar:SetScale(PIGA_Per["PigAction"]["Scale"][index]);
	Pig_bar.yidong = PIGFrame(Pig_bar)
	Pig_bar.yidong:PIGSetBackdrop()
	Pig_bar.yidong:SetSize(12, ActionW-4)
	Pig_bar.yidong:SetPoint("LEFT",Pig_bar,"LEFT",0,0);
	Pig_bar.yidong:EnableMouse(true)
	Pig_bar.yidong:RegisterForDrag("LeftButton")
	if PIGA_Per["PigAction"]["Lock"][index] then Pig_bar.yidong:Hide() end
	Pig_bar.yidong.title = PIGFontString(Pig_bar.yidong,nil,index,"OUTLINE",12)
	Pig_bar.yidong.title:SetAllPoints(Pig_bar.yidong)
	Pig_bar.yidong.title:SetTextColor(1, 1, 0.1, 1)
	Pig_bar.yidong:SetScript("OnDragStart",function()
		Pig_bar:StartMoving()
	end)
	Pig_bar.yidong:SetScript("OnDragStop",function()
		Pig_bar:StopMovingOrSizing()
	end)
	Pig_bar.yidong:SetScript("OnEnter", function (self)
		self:SetBackdropBorderColor(0,0.8,1, 0.9);
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..TUTORIAL_TITLE2.."|r\n"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r")	
		GameTooltip:Show();
	end);
	Pig_bar.yidong:SetScript("OnLeave", function (self)
		self:SetBackdropBorderColor(0, 0, 0, 1);
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end)
	Pig_bar.yidong:SetScript("OnMouseUp", function (self,Button)
		if Button=="RightButton" then
			if Pig_OptionsUI:IsShown() then
				Pig_OptionsUI:Hide()
			else
				Pig_OptionsUI:Show()
				Create.Show_TabBut(fuFrame,fuFrameBut)
				Create.Show_TabBut_R(RTabFrame,Action_plusF,Action_plusTabBut)
			end
		end
	end)
	-----
	for id=1,anniugeshu do
		--local piganniu = CreateFrame("CheckButton", "$parent_But"..id, Pig_bar, "ActionButtonTemplate",0)
		local piganniu = CreateFrame("CheckButton", "$parent_But"..id, Pig_bar, "SecureActionButtonTemplate,ActionButtonTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate,SecureHandlerStateTemplate,SecureHandlerBaseTemplate")
		piganniu:SetSize(ActionW, ActionW)
		piganniu.NormalTexture:SetAlpha(0.4);
		piganniu.cooldown:SetSwipeColor(0, 0, 0, 0.8);
		piganniu.INDEX=index
		piganniu.ID=id
		if id==1 then
			piganniu:SetPoint("LEFT",Pig_bar.yidong,"RIGHT",2,0)
		else
			PailieFun(index,id)
		end
		function piganniu:SetAnniuNumFun(max,all)
			local index=self.INDEX
			local max=max or PIGA_Per["PigAction"]["AnniuNum"][index]
			local id=self.ID
			if id>max then
				self:Hide()
				return
			end
			self:Show()
		end
		piganniu:SetAnniuNumFun()
		piganniu.BGtex = piganniu:CreateTexture(nil, "BACKGROUND", nil, -1);
		piganniu.BGtex:SetTexture("Interface/Buttons/UI-Quickslot");
		piganniu.BGtex:SetAlpha(0.4);
		piganniu.BGtex:SetPoint("TOPLEFT", -15, 15);
		piganniu.BGtex:SetPoint("BOTTOMRIGHT", 15, -15);
		-------------
	 	-- piganniu:SetAttribute("checkfocuscast", true);--使用系统焦点施法按键
	 	-- piganniu:SetAttribute("checkselfcast", true);--可以使用自我施法按键
	 	-- piganniu.flashing = 0;
	 	-- piganniu.flashtime = 0;
	 	if index==1 then 
	 		local ActionID = 500+id
	 		piganniu.action=ActionID
			piganniu:SetAttribute("action", ActionID)
		else
			local ActionID = 500+(index-1)*12+id
			piganniu.action=ActionID
			piganniu:SetAttribute("action", ActionID)
		end
		---
		PIGUseKeyDown(piganniu)
		loadingButInfo(piganniu,"PigAction")
		---
		piganniu:HookScript("PostClick", function(self)
			Update_PostClick(self)
		end);
		--
		piganniu:HookScript("OnMouseUp", function (self)
			Cursor_Fun(self,"OnMouseUp","PigAction")
			Update_Icon(self)
			Update_Cooldown(self)
			Update_Count(self)
			Update_bukeyong(self)
		end);
		----
		piganniu:HookScript("OnDragStart", function (self)
			if InCombatLockdown() then return end
			local lockvalue = GetCVar("lockActionBars")
			if lockvalue=="0" then
				self:SetAttribute("type", nil)
				Cursor_Fun(self,"OnDragStart","PigAction")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
				Update_State(self)
			elseif lockvalue=="1" then
				if IsShiftKeyDown() then
					self:SetAttribute("type", nil)
					Cursor_Fun(self,"OnDragStart","PigAction")
					Update_Icon(self)
					Update_Cooldown(self)
					Update_Count(self)
					Update_State(self)
				end
			end
		end)
		----
		piganniu:SetAttribute("_onreceivedrag",[=[
			local leibie, spellID = ...
			if kind=="spell" then
				self:SetAttribute("type", kind)
				self:SetAttribute(kind, spellID)
			elseif kind=="item" then
				self:SetAttribute("type", kind)
				self:SetAttribute(kind, leibie)
			elseif kind=="macro" then
				self:SetAttribute("type", kind)
				self:SetAttribute(kind, value)
			end
		]=])
		piganniu:HookScript("OnReceiveDrag", function (self)
			Cursor_Fun(self,"OnReceiveDrag","PigAction")
			Update_Icon(self)
			Update_Cooldown(self)
			Update_Count(self)
			Update_bukeyong(self)
		end);
		----
		piganniu:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
			Update_OnEnter(self,'PigAction')
		end)
		piganniu:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);

		--------------------
		ShowHideEvent(piganniu,PIGA_Per['PigAction']['ShowTJ'][index])
		piganniu:SetAttribute("_onstate-combatYN","if newstate == 'show' then self:Show(); else self:Hide(); end")

		-- piganniu:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	 	-- piganniu:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
		piganniu:RegisterEvent("ACTIONBAR_SHOWGRID");
		piganniu:RegisterEvent("ACTIONBAR_HIDEGRID");
		piganniu:RegisterEvent("TRADE_SKILL_CLOSE")
		if tocversion>90000 then
		else
			piganniu:RegisterEvent("CRAFT_CLOSE")
		end
		piganniu:RegisterEvent("CVAR_UPDATE");
		piganniu:RegisterEvent("UPDATE_MACROS");
		--piganniu:RegisterEvent("EXECUTE_CHAT_LINE");
		piganniu:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
		piganniu:RegisterEvent("ACTIONBAR_UPDATE_STATE");
		piganniu:RegisterEvent("BAG_UPDATE");
		piganniu:RegisterEvent("AREA_POIS_UPDATED");
		piganniu:RegisterEvent("EQUIPMENT_SETS_CHANGED");
		piganniu:RegisterEvent("PLAYER_ENTERING_WORLD");
		piganniu:RegisterEvent("PLAYER_REGEN_DISABLED")
		piganniu:RegisterEvent("PLAYER_REGEN_ENABLED");
		piganniu:RegisterUnitEvent("UNIT_AURA","player");
		piganniu:RegisterUnitEvent("UNIT_PET","player");
		piganniu:HookScript("OnEvent", function(self,event,arg1,arg2,arg3)
			if event=="ACTIONBAR_SHOWGRID" then
				if InCombatLockdown() then return end
				ShowHideNumFun(self,nil,true)
			elseif event=="ACTIONBAR_HIDEGRID" then
				if InCombatLockdown() then
					self.always_show=true
				else
					ShowHideNumFun(self)
				end
			elseif event=="CVAR_UPDATE" then
				if arg1=="ActionButtonUseKeyDown" then
					PIGUseKeyDown(self)
				elseif arg1=="alwaysShowActionBars" then
					if InCombatLockdown() then
						self.always_show=true
					else
						ShowHideNumFun(self,arg2)
					end
				end
			elseif event=="BAG_UPDATE" then
				Update_Count(self)
				Update_bukeyong(self)
			elseif event=="ACTIONBAR_UPDATE_COOLDOWN" then
				Update_Cooldown(self)
				Update_bukeyong(self)
				Update_Icon(self)
			elseif event=="UNIT_PET" then
				
			elseif event=="ACTIONBAR_UPDATE_STATE" or event=="TRADE_SKILL_CLOSE" or event=="CRAFT_CLOSE" or event=="UNIT_AURA" or event=="EXECUTE_CHAT_LINE" then
				Update_State(self)
				Update_Icon(self)
			elseif event=="AREA_POIS_UPDATED" then
				Update_bukeyong(self)
			elseif event=="EQUIPMENT_SETS_CHANGED" then
				Update_Equipment(self,"PigAction")
			elseif event=="PLAYER_REGEN_ENABLED" then
				Update_bukeyong(self)
				Update_Equipment(self,"PigAction")
				ShowHideNumFun(self)
				self.always_show=nil
			elseif event=="PLAYER_REGEN_DISABLED" then
				Update_bukeyong(self)
			elseif event=="PLAYER_ENTERING_WORLD" then
				if self.Type=="macro" then
					Update_Macro(self,PigMacroDeleted,PigMacroCount,"PigAction")
				end
				Update_Icon(self)
				Update_Count(self)
				Update_State(self)
			elseif event=="UPDATE_MACROS" then
				PigMacroEventCount=PigMacroEventCount+1;
				if self.Type=="macro" then
					if PigMacroEventCount>5 then
						local AccMacros, CharMacros = GetNumMacros();
						if PigMacroCount==0 then
							PigMacroCount = AccMacros + CharMacros;
						elseif (PigMacroCount > AccMacros + CharMacros) then
							PigMacroDeleted = true;
						end
						PigMacroDeleted,PigMacroCount=Update_Macro(self,PigMacroDeleted,PigMacroCount,"PigAction")
					end
				end
				Update_Icon(self)
				Update_Count(self)
				Update_State(self)
			end
		end)
	end
end
--=====================================================
function ActionBarfun.Pig_Action()
	for index=1,zongshu do
		ADD_ActionBar(index)
	end
	--处理绑定
	for index=1,zongshu do
		for id=1,anniugeshu do
			_G["BINDING_NAME_CLICK "..barName..index.."_But"..id..":LeftButton"]= "PIG"..ACTIONBARS_LABEL..index.." "..SETTINGS_KEYBINDINGS_LABEL..id
		end
	end
end