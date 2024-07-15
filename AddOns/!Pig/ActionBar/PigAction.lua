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

local anniugeshu,anniujiange=12,6;
ActionBarfun.anniugeshu=anniugeshu
ActionBarfun.anniujiange=anniujiange
local zongshu =4;
ActionBarfun.zongshu=zongshu
local barName ="Pigbar"
ActionBarfun.barName=barName
----------
local pailieName={"横向","竖向","6×2","2×6","4×3","3×4","取消"};
local pailieID={1,2,3,4,5,6};
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
	for x=1,#pailieID do
		if PIGA_Per["PigAction"]["Pailie"][index] == pailieID[x] then
			_G[barName..index.."_But"..id]:ClearAllPoints();
			_G[barName..index.."_But"..id]:SetPoint(pailieweizhi[x][id-1][1],_G[barName..index.."_But"..(id-pailieweizhi[x][id-1][5])],pailieweizhi[x][id-1][2],pailieweizhi[x][id-1][3],pailieweizhi[x][id-1][4])
		end
	end
end
-----------
local PigMacroEventCount =0;
local PigMacroDeleted = false;
local PigMacroCount=0
function ActionBarfun.ShowHideEvent(self,canshuV)
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
---add------------------
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
local Spell_bianxing = {768,783,5487,9634,24858,33947,40120,1066,13819,34767,34769,23214,5784,23161}
local Skill_zhuanye = {'烹饪', '急救', '裁缝', '熔炼', '工程学', '锻造', '制皮','剥皮', '炼金术',"珠宝加工","铭文"};
local ActionW = ActionButton1:GetWidth()
for index=1,zongshu do
	local Pig_bar=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",-200,-200+index*50},{0.01,ActionW-4},barName..index)
	Pig_bar:SetMovable(true)
	Pig_bar:SetUserPlaced(true)
	Pig_bar:SetClampedToScreen(true)
end
local function ADD_ActionBar(index)
	local Pig_bar=_G[barName..index]
	if Pig_bar.yidong then return end
	-- Pig_bar:SetAttribute("type", "actionbar");
	-- Pig_bar:SetAttribute("actionbar", index+100);
	if PIGA['ActionBar']['ActionBar_bili'] then
		Pig_bar:SetScale(PIGA['ActionBar']['ActionBar_bili_value']);
	end
	Pig_bar.yidong = PIGFrame(Pig_bar)
	Pig_bar.yidong:PIGSetBackdrop()
	Pig_bar.yidong:SetSize(10, ActionW-4)
	Pig_bar.yidong:SetPoint("LEFT",Pig_bar,"LEFT",0,0);
	Pig_bar.yidong:EnableMouse(true)
	Pig_bar.yidong:RegisterForDrag("LeftButton")
	if PIGA_Per["PigAction"]["Lock"][index] then Pig_bar.yidong:Hide() end
	Pig_bar.yidong.title = PIGFontString(Pig_bar.yidong,nil,index,nil,11)
	Pig_bar.yidong.title:SetAllPoints(Pig_bar.yidong)
	Pig_bar.yidong.title:SetTextColor(0.6, 0.6, 0.6, 1)
	Pig_bar.yidong:SetScript("OnDragStart",function()
		Pig_bar:StartMoving()
	end)
	Pig_bar.yidong:SetScript("OnDragStop",function()
		Pig_bar:StopMovingOrSizing()
	end)
	---------------
	local painum = #pailieName
	local RightCWW,RightCHH = 64,14
	Pig_bar.yidong.RightC = PIGFrame(Pig_bar.yidong,{"RIGHT",Pig_bar.yidong,"LEFT",0,-0},{RightCWW,(RightCHH+4)*painum+6},"Action_RightC"..index,true)
	Pig_bar.yidong.RightC:PIGSetBackdrop()
	Pig_bar.yidong.RightC:EnableMouse(true)
	Pig_bar.yidong.RightC:SetFrameStrata("DIALOG")
	for b=1,painum do
		local RightC_C = CreateFrame("CheckButton", "RightC_"..index.."_"..b, Pig_bar.yidong.RightC,"UIRadioButtonTemplate",index);
		RightC_C:SetSize(RightCHH,RightCHH);
		RightC_C:SetHitRectInsets(0,-52,-2,-2);
		if b==1 then
			RightC_C:SetPoint("TOPLEFT",Pig_bar.yidong.RightC,"TOPLEFT",4,-4);
		else
			RightC_C:SetPoint("TOPLEFT",_G["RightC_"..index.."_"..(b-1)],"BOTTOMLEFT",0,-4);
		end
		_G["RightC_"..index.."_"..b.."Text"]:SetText(pailieName[b]);
		RightC_C:SetScript("OnClick", function (self)
			if b~=painum then
				for q=1,painum do
					_G["RightC_"..index.."_"..q]:SetChecked(false);
				end
				self:SetChecked(true);
				PIGA_Per["PigAction"]["Pailie"][index]=pailieID[b]
				for id=2,anniugeshu do
					PailieFun(self:GetID(),id)
				end
			else
				self:SetChecked(false);
			end
			Pig_bar.yidong.RightC:Hide()
		end)
	end

	Pig_bar.yidong:SetScript("OnMouseUp", function (self,Button)
		if Button=="RightButton" then
			if self.RightC:IsShown() then
				self.RightC:Hide()
			else
				for f=1,zongshu do
					if _G["Action_RightC"..f] then _G["Action_RightC"..f]:Hide() end
				end
				self.RightC:Show()
				for l=1,#pailieID do
					if PIGA_Per["PigAction"]["Pailie"][index] == pailieID[l] then
						_G["RightC_"..index.."_"..l]:SetChecked(true);
					end
				end
			end
		end
	end)
	--------
	for id=1,anniugeshu do
		--local piganniu = CreateFrame("CheckButton", "$parent_But"..id, Pig_bar, "ActionButtonTemplate",0)
		local piganniu = CreateFrame("CheckButton", "$parent_But"..id, Pig_bar, "SecureActionButtonTemplate,ActionButtonTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate,SecureHandlerStateTemplate,SecureHandlerBaseTemplate")
		piganniu:SetSize(ActionW, ActionW)
		piganniu.NormalTexture:SetAlpha(0.4);
		piganniu.cooldown:SetSwipeColor(0, 0, 0, 0.8);
		if id==1 then
			piganniu:SetPoint("LEFT",Pig_bar.yidong,"RIGHT",2,0)
		else
			PailieFun(index,id)
		end
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
			GameTooltip:SetOwner(self, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-100,140);
			Update_OnEnter(self,'PigAction')
		end)
		piganniu:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		--------------------
		ActionBarfun.ShowHideEvent(piganniu,PIGA_Per['PigAction']['ShowTJ'][index])
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
		piganniu:RegisterUnitEvent("UNIT_AURA","player");
		piganniu:RegisterEvent("BAG_UPDATE");
		piganniu:RegisterEvent("AREA_POIS_UPDATED");
		piganniu:RegisterEvent("EQUIPMENT_SETS_CHANGED");
		piganniu:RegisterEvent("PLAYER_ENTERING_WORLD");
		piganniu:HookScript("OnEvent", function(self,event,arg1,arg2,arg3)
			if event=="ACTIONBAR_SHOWGRID" then
				if InCombatLockdown() then return end
				self:Show();
			end
			if event=="ACTIONBAR_HIDEGRID" then
				if InCombatLockdown() then
					self:RegisterEvent("PLAYER_REGEN_ENABLED");
					return 
				end
				local Showvalue = GetCVar("alwaysShowActionBars")
				if Showvalue=="0" then
					if not self.Type then
						self:Hide();
					end
				end
			end
			if event=="CVAR_UPDATE" then
				if arg1=="ActionButtonUseKeyDown" then
					PIGUseKeyDown(self)
				end
				if InCombatLockdown() then
					self:RegisterEvent("PLAYER_REGEN_ENABLED");
					return 
				end
				if arg1=="ALWAYS_SHOW_MULTIBARS_TEXT" then
					if arg2=="0" then
						if not self.Type then
							self:Hide();
						end
					elseif arg2=="1" then
						self:Show();
					end
				end	
			end
			if event=="PLAYER_REGEN_ENABLED" then
				local Showvalue = GetCVar("alwaysShowActionBars")
				if Showvalue=="0" then
					if not self.Type then
						self:Hide();
					end
				elseif Showvalue=="1" then
					self:Show();
				end
				self:UnregisterEvent("PLAYER_REGEN_ENABLED");
			end
			if event=="BAG_UPDATE" then
				Update_Count(self)
				Update_bukeyong(self)
			end
			if event=="ACTIONBAR_UPDATE_COOLDOWN" then
				Update_Cooldown(self)
				Update_bukeyong(self)
			end
			if event=="ACTIONBAR_UPDATE_STATE" or event=="TRADE_SKILL_CLOSE" or event=="CRAFT_CLOSE" or event=="UNIT_AURA" or event=="EXECUTE_CHAT_LINE" then
				Update_State(self)
				Update_Icon(self)
			end
			if event=="PLAYER_REGEN_ENABLED" or event=="PLAYER_ENTERING_WORLD" then
				if self.Type=="macro" then
					Update_Macro(self,PigMacroDeleted,PigMacroCount,"PigAction")
				end
				Update_Icon(self)
				Update_Count(self)
				Update_State(self)
			end
			if event=="UPDATE_MACROS" then
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
			if event=="EQUIPMENT_SETS_CHANGED" or event=="PLAYER_REGEN_ENABLED" then
				Update_Equipment(self,"PigAction")
			end
			if event=="AREA_POIS_UPDATED" then
				Update_bukeyong(self)
			end
		end)
	end
end
--=====================================================
function ActionBarfun.Pig_Action()
	if tocversion<100000 then
		for index=1,zongshu do
			if PIGA_Per["PigAction"]["Open"][index] then
				ADD_ActionBar(index)
			end
		end
		--处理绑定
		-- local function shuaxinbangding()
		-- 	for index=1,zongshu do
		-- 		for id=1,anniugeshu do
		-- 			if _G["piganniu_"..index.."_"..id] then
		-- 				local key1, key2 = GetBindingKey("CLICK piganniu_"..index.."_"..id..":LeftButton")
		-- 				if key1 then
		-- 					_G["piganniu_"..index.."_"..id].HotKey:SetText(key1)
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
		-- local dongzuotiaoshijian = CreateFrame("Frame"); 
		-- dongzuotiaoshijian:RegisterEvent("UPDATE_BINDINGS");
		-- dongzuotiaoshijian:HookScript("OnEvent",function (self,event)
		-- 	shuaxinbangding()
		-- end)
		for index=1,zongshu do
			for id=1,anniugeshu do
				_G["BINDING_NAME_CLICK "..barName..index.."_But"..id..":LeftButton"]= "PIG"..ACTIONBARS_LABEL..index.." "..SETTINGS_KEYBINDINGS_LABEL..id
			end
		end
	end
end
-----------
if tocversion<100000 then
	local Action_plusF =PIGOptionsList_R(RTabFrame,L["ACTION_TABNAME3"],100)
	--------
	local anniugeshu,anniujiange=ActionBarfun.anniugeshu,ActionBarfun.anniujiange
	local zongshu =ActionBarfun.zongshu
	local barName =ActionBarfun.barName
	local Showtiaojian = {ALWAYS..SHOW,LEAVING_COMBAT..HIDE,BATTLEFIELD_JOIN..HIDE,SPELL_FAILED_BAD_IMPLICIT_TARGETS..HIDE,};
	for index=1,zongshu do
		local kaiqiewaidongzuotiao = PIGCheckbutton(Action_plusF, nil,{ENABLE.."PIG"..ACTIONBAR_LABEL..index,ENABLE..L["ACTION_TABNAME3"]..index}, nil, "kaiqiewaidongzuotiao"..index);
		if index==1 then
			kaiqiewaidongzuotiao:SetPoint("TOPLEFT",Action_plusF,"TOPLEFT",20,-20);
		else
			local zheng,yushu =math.modf(index/2)
			if yushu==0 then
				kaiqiewaidongzuotiao:SetPoint("LEFT",_G["kaiqiewaidongzuotiao"..(index-1)],"RIGHT",252,0);
			else
				kaiqiewaidongzuotiao:SetPoint("TOPLEFT",_G["kaiqiewaidongzuotiao"..(index-2)],"BOTTOMLEFT",0,-80);
			end
		end
		kaiqiewaidongzuotiao:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA_Per["PigAction"]["Open"][index]=true
				ActionBarfun.Pig_Action()
			else
				PIGA_Per["PigAction"]["Open"][index]=false
				Pig_Options_RLtishi_UI:Show()
			end
		end);
		kaiqiewaidongzuotiao.Lockdongzuotiao = PIGCheckbutton(kaiqiewaidongzuotiao, {"TOPLEFT",kaiqiewaidongzuotiao,"BOTTOMLEFT",30,-4},{LOCK_FRAME,LOCK_FOCUS_FRAME..", "..HIDE..MOVE_FRAME..EMBLEM_SYMBOL});
		kaiqiewaidongzuotiao.Lockdongzuotiao:SetScript("OnClick", function (self)
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
		kaiqiewaidongzuotiao.ShowHide=PIGDownMenu(kaiqiewaidongzuotiao,{"TOPLEFT",kaiqiewaidongzuotiao.Lockdongzuotiao,"BOTTOMLEFT",0,-4},{120,24})
		function kaiqiewaidongzuotiao.ShowHide:PIGDownMenu_Update_But(self)
			local info = {}
			info.func = self.PIGDownMenu_SetValue
			for i=1,#Showtiaojian,1 do
			    info.text, info.arg1 = Showtiaojian[i], i
			    info.checked = i==PIGA_Per["PigAction"]["ShowTJ"][index]
				kaiqiewaidongzuotiao.ShowHide:PIGDownMenu_AddButton(info)
			end 
		end
		function kaiqiewaidongzuotiao.ShowHide:PIGDownMenu_SetValue(value,arg1,arg2)
			if InCombatLockdown()  then 
				PIGinfotip:TryDisplayMessage("请在脱战后改变隐藏条件")
				return 
			end
			kaiqiewaidongzuotiao.ShowHide:PIGDownMenu_SetText(value)
			PIGA_Per["PigAction"]["ShowTJ"][index] = arg1;
			if PIGA_Per["PigAction"]["Open"][index] then
				for id=1,anniugeshu do
					ActionBarfun.ShowHideEvent(_G[barName..index.."_But"..id],arg1)
				end
			end
			PIGCloseDropDownMenus()
		end
	end
	Action_plusF.dongzuotxian = PIGLine(Action_plusF,"TOP",-250)
	Action_plusF.title = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",20,-20},L["LIB_TIPS"]);
	Action_plusF.title1 = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",40,-50},"|cff00ff001.可"..KEY_BUTTON2.."拖拽按钮变换动作条排列方式|r")
	Action_plusF.title2 = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",40,-80},"|cff00ff002.此"..L["ACTION_TABNAME3"].."非大脚那种调用系统预留给其他姿态(例如鸟德暗牧)的动作条，\n而是完全独立的动作条，不会占用角色其他形态的动作条按钮。|r")
	Action_plusF.title2:SetJustifyH("LEFT");

	---
	Action_plusF.CZ = PIGFontString(Action_plusF,{"TOPLEFT",Action_plusF.dongzuotxian,"TOPLEFT",40,-140},"|cffFFff00动作条异常点此：|r");
	Action_plusF.CZBUT = PIGButton(Action_plusF,{"LEFT",Action_plusF.CZ,"RIGHT",10,0},{76,20},"重置配置");  
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
			local ckfame=_G["kaiqiewaidongzuotiao"..index]
			ckfame:SetChecked(PIGA_Per["PigAction"]["Open"][index])
			ckfame.Lockdongzuotiao:SetChecked(PIGA_Per["PigAction"]["Lock"][index])
			ckfame.ShowHide:PIGDownMenu_SetText(Showtiaojian[PIGA_Per["PigAction"]["ShowTJ"][index]])
		end
	end)
end