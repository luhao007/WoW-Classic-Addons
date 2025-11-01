local addonName, addonTable = ...;
local L=addonTable.locale
----------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGDiyBut=Create.PIGDiyBut
local PIGButton=Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGQuickBut=Create.PIGQuickBut
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--------------
local Fun=addonTable.Fun
local ActionFun=Fun.ActionFun
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
----
local Data=addonTable.Data
local bagData=Data.bagData
local bagID=Data.bagData["bagID"]
---
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID=GetContainerItemID or C_Container and C_Container.GetContainerItemID
local GetItemInfoInstant= GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetItemInfo=GetItemInfo or C_Item and C_Item.GetItemInfo
local GetItemCount=GetItemCount or C_Item and C_Item.GetItemCount
local GetItemSpell=GetItemSpell or C_Item and C_Item.GetItemSpell
local GetItemIcon=GetItemIcon or C_Item and C_Item.GetItemIconByID
local IsUsableSpell=IsUsableSpell or C_Spell and C_Spell.IsSpellUsable
local GetItemCooldown=C_Container.GetItemCooldown
local PIGbookType=PIG_GetSpellBookType()
---功能动作条===========
local QuickButUIname=Data.QuickButUIname
local QuickButUI=_G[QuickButUIname]
local ActionBarfun=addonTable.ActionBarfun
local fuFrame=ActionBarfun.fuFrame
local fuFrameBut=ActionBarfun.fuFrameBut
local RTabFrame=ActionBarfun.RTabFrame
local QuickButF,QuickButTabBut =PIGOptionsList_R(RTabFrame,L["ACTION_TABNAME2"],100)
ActionBarfun.QuickButF=QuickButF
--
QuickButF.Open=PIGCheckbutton_R(QuickButF,{L["ACTION_TABNAME2"],"在屏幕上创建一条"..L["ACTION_TABNAME2"].."，以便快捷使用某些功能。\n你可以自定义需要显示的按钮"})
QuickButF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Open"]=true;
		QuickButUI:Add()
	else
		PIGA["QuickBut"]["Open"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
--
local function QuickButFLock()
	if QuickButUI.yidong then
		if PIGA["QuickBut"]["Lock"] then
			QuickButUI.yidong:Hide()
		else
			QuickButUI.yidong:Show()
		end
	end
end
QuickButF.Lock=PIGCheckbutton(QuickButF,{"LEFT",QuickButF.Open,"RIGHT",120,0},{LOCK_FRAME,LOCK_FOCUS_FRAME})
QuickButF.Lock:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Lock"]=true
	else
		PIGA["QuickBut"]["Lock"]=false;
	end
	QuickButFLock()
end)
--
QuickButF.suofang_t = PIGFontString(QuickButF,{"LEFT",QuickButF.Lock,"RIGHT",90,0},"缩放:")
local xiayiinfo = {0.8,1.4,0.01,{["Right"]="%"}}
QuickButF.suofang = PIGSlider(QuickButF,{"LEFT",QuickButF.suofang_t,"RIGHT",10,0},xiayiinfo)
QuickButF.suofang.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["QuickBut"]["bili"]=arg1;
	QuickButUI:SetScale(arg1);
end)
--
QuickButF.CZBUT = PIGButton(QuickButF,{"LEFT",QuickButF.suofang,"RIGHT",60,0},{80,24},"重置位置")
QuickButF.CZBUT:SetScript("OnClick", function ()
	Create.PIG_ResPoint(QuickButUIname)
end)
QuickButF:HookScript("OnShow", function(self)
	self.Open:SetChecked(PIGA["QuickBut"]["Open"])
	self.Lock:SetChecked(PIGA["QuickBut"]["Lock"])
	self.suofang:PIGSetValue(PIGA["QuickBut"]["bili"])
end)
--
QuickButF.Modline = PIGLine(QuickButF,"TOP",-66)
QuickButF.ModF = PIGFrame(QuickButF)
QuickButF.ModF:SetPoint("TOPLEFT",QuickButF.Modline,"BOTTOMLEFT",0,0);
QuickButF.ModF:SetPoint("BOTTOMRIGHT",QuickButF,"BOTTOMRIGHT",0,30);
local BGbroadcast_tooltip = {string.format(L["ACTION_ADDQUICKBUT"],BATTLEFIELDS..BATTLENET_BROADCAST),string.format(L["ACTION_ADDQUICKBUTTIS"],BATTLEFIELDS..BATTLENET_BROADCAST).."\n注意:战况广播按钮战场外不显示"}
QuickButF.ModF.BGbroadcast=PIGCheckbutton_R(QuickButF.ModF,BGbroadcast_tooltip,true)
QuickButF.ModF.BGbroadcast:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["BGbroadcast"]=true;
		QuickButUI.ButList[2]()
	else
		PIGA["QuickBut"]["BGbroadcast"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
--饰品
local newText=Fun.Delmaohaobiaodain(MODIFIERS_COLON)
local tishineiQKButTrinket = INVTYPE_TRINKET..newText
QuickButF.ModF.QKButTrinket = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],tishineiQKButTrinket),string.format(L["ACTION_ADDQUICKBUTTIS"],tishineiQKButTrinket)},true)
QuickButF.ModF.QKButTrinket:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Trinket"]=true
		QuickButUI.ButList[3]()
	else
		PIGA["QuickBut"]["Trinket"]=false
		PIG_OptionsUI.RLUI:Show();
	end
end)
if PIG_MaxTocversion(20000) and C_Engraving and C_Engraving.IsEngravingEnabled() then
	QuickButF.ModF.QKButRune = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],RUNES..newText),string.format(L["ACTION_ADDQUICKBUTTIS"],RUNES..newText)},true)
	QuickButF.ModF.QKButRune:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["QuickBut"]["Rune"]=true
			QuickButUI.ButList[4]()
		else
			PIGA["QuickBut"]["Rune"]=false
			PIG_OptionsUI.RLUI:Show();
		end
	end)
	QuickButF.ModF.QKButRune.RuneShow = PIGCheckbutton(QuickButF.ModF.QKButRune,{"LEFT",QuickButF.ModF.QKButRune.Text,"RIGHT",20,0},{SHOW.."当前使用的符文"})
	QuickButF.ModF.QKButRune.RuneShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["QuickBut"]["RuneShow"]=true
			if AutoRuneListUI then AutoRuneListUI:GetParent():UpDatePoints(true) end
		else
			PIGA["QuickBut"]["RuneShow"]=false
			if AutoRuneListUI then AutoRuneListUI:Hide() end
		end
	end)
end
----
QuickButF.ModF.QKButEquip = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],EQUIPMENT_MANAGER),string.format(L["ACTION_ADDQUICKBUTTIS"],EQUIPMENT_MANAGER)},true)
QuickButF.ModF.QKButEquip.errt = PIGFontString(QuickButF.ModF.QKButEquip,{"LEFT", QuickButF.ModF.QKButEquip.Text, "RIGHT", 2, 0},"需打开界面优化/角色信息/人物信息扩展功能","OUTLINE")
QuickButF.ModF.QKButEquip.errt:SetTextColor(1, 0, 0); 
QuickButF.ModF.QKButEquip.errt:Hide()
QuickButF.ModF.QKButEquip:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Equip"]=true
		QuickButUI.ButList[5]()
	else
		PIGA["QuickBut"]["Equip"]=false
		PIG_OptionsUI.RLUI:Show();
	end
end)
QuickButF.ModF.AddonList = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],ADDONS..CHAT_MODERATE)},true)
QuickButF.ModF.AddonList:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["AddonList"]=true
		QuickButUI.ButList[6]()
	else
		PIGA["QuickBut"]["AddonList"]=false
		PIG_OptionsUI.RLUI:Show();
	end
end)
local Lushi_tooltip = {string.format(L["ACTION_ADDQUICKBUT"],TUTORIAL_TITLE31.."/"..TRADE_SKILLS),string.format(L["ACTION_ADDQUICKBUTTIS"],TUTORIAL_TITLE31.."/"..TRADE_SKILLS)}
QuickButF.ModF.Lushi=PIGCheckbutton_R(QuickButF.ModF,Lushi_tooltip,true)
QuickButF.ModF.Lushi:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Lushi"]=true;
		QuickButUI.ButList[7]()
	else
		PIGA["QuickBut"]["Lushi"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
QuickButF.ModF.Spell=PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],CLASS..BINDING_HEADER_ACTIONBAR),string.format(L["ACTION_ADDQUICKBUTTIS"],CLASS..BINDING_HEADER_ACTIONBAR)},true)
QuickButF.ModF.Spell:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Spell"]=true;
		QuickButUI.ButList[8]()
	else
		PIGA["QuickBut"]["Spell"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
QuickButF.ModF:HookScript("OnShow", function(self)
	self.Lushi:SetChecked(PIGA["QuickBut"]["Lushi"])
	self.Spell:SetChecked(PIGA["QuickBut"]["Spell"])
	self.BGbroadcast:SetChecked(PIGA["QuickBut"]["BGbroadcast"])
	self.QKButTrinket:SetChecked(PIGA["QuickBut"]["Trinket"])
	if self.QKButRune then
		self.QKButRune:SetChecked(PIGA["QuickBut"]["Rune"])
		self.QKButRune.RuneShow:SetChecked(PIGA["QuickBut"]["RuneShow"])
	end
	self.QKButEquip:SetChecked(PIGA["QuickBut"]["Equip"])
	self.AddonList:SetChecked(PIGA["QuickBut"]["AddonList"])
	if PIG_MaxTocversion(20000) then
		self.QKButEquip:SetEnabled(PIGA["FramePlus"]["Character_Shuxing"])
		self.QKButEquip.errt:SetShown(not PIGA["FramePlus"]["Character_Shuxing"])
	end
end)
QuickButF.ModF.CZBUT = PIGButton(QuickButF.ModF,{"BOTTOMLEFT",QuickButF.ModF,"BOTTOMLEFT",20,-20},{76,20},"重置配置");  
QuickButF.ModF.CZBUT:SetScript("OnClick", function ()
	StaticPopup_Show ("CHONGZHI_QUICKBUT");
end);
StaticPopupDialogs["CHONGZHI_QUICKBUT"] = {
	text = "此操作将|cffff0000重置|r"..L["ACTION_TABNAME2"].."配置。\n确定重置?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		PIGA["QuickBut"] = addonTable.Default["QuickBut"];
		PIGA_Per["QuickBut"] = addonTable.Default_Per["QuickBut"];
		PIG_OptionsUI.RLUI:Show()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
---
QuickButUI.ButList[1]=function()
	if not PIGA["QuickBut"]["Open"] or QuickButUI.yidong then return end
	Create.PIG_SetPoint(QuickButUIname)
	QuickButUI:SetScale(PIGA["QuickBut"]["bili"]);
	QuickButUI.yidong=PIGFrame(QuickButUI,{"TOPLEFT",QuickButUI,"TOPLEFT",0,0})
	QuickButUI.yidong:SetPoint("BOTTOMLEFT", QuickButUI, "BOTTOMLEFT", 0, 0);
	QuickButUI.yidong:SetWidth(13);
	if PIGA["QuickBut"]["Lock"] then QuickButUI.yidong:Hide() end
	QuickButUI.yidong:PIGSetBackdrop()
	QuickButUI.yidong:PIGSetMovable(QuickButUI,nil,nil,true)
	QuickButUI.yidong:HookScript("OnMouseUp", function (self,Button)
		if Button=="RightButton" then
			if PIG_OptionsUI:IsShown() then
				PIG_OptionsUI:Hide()
			else
				PIG_OptionsUI:Show()
				Create.Show_TabBut(fuFrame,fuFrameBut)
				Create.Show_TabBut_R(RTabFrame,QuickButF,QuickButTabBut)
			end
		end
	end);
	QuickButUI.yidong:HookScript("OnEnter", function (self)
		self:SetBackdropBorderColor(0,0.8,1, 0.9);
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		GameTooltip:AddLine(L["LIB_TIPS"])
		GameTooltip:AddLine(KEY_BUTTON1.."拖拽-|cff00FFff"..TUTORIAL_TITLE2.."|r\n"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r")	
		GameTooltip:Show();
	end);
	QuickButUI.yidong:HookScript("OnLeave", function (self)
		self:SetBackdropBorderColor(0, 0, 0, 1);
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end)
	QuickButUI.yidong.t = PIGFontString(QuickButUI.yidong,{"CENTER",QuickButUI.yidong,"CENTER",0,0},"拖\n动",nil,9)
	QuickButUI.yidong.t:SetTextColor(0.8, 0.8, 0.8, 0.8)
	QuickButUI.nr=PIGFrame(QuickButUI,{"TOPLEFT",QuickButUI.yidong,"TOPRIGHT",1,0})
	QuickButUI.nr:SetPoint("BOTTOMRIGHT", QuickButUI, "BOTTOMRIGHT", 0, 0);
	QuickButUI.nr:PIGSetBackdrop()
end
--战场通告
QuickButUI.ButList[2]=function()
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["BGbroadcast"] then
		if QuickButUI.BGbroadcastOpen then return end
		QuickButUI.BGbroadcastOpen=true
		local GnIcon=130704
		local englishFaction = UnitFactionGroup("player")
		if englishFaction=="Horde" then
			GnIcon=130705
		end
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF通报当前位置来犯人,(来几人就点几次)\r|r"..KEY_BUTTON2.."-|cff00FFFF报告位置安全|r"
		local BGanniu=PIGQuickBut(nil,Tooltip,GnIcon)
		local function Update_ShowFun()
			local inInstance, instanceType =IsInInstance()
			if instanceType=="pvp" then
				BGanniu.yincang=nil
			else
				BGanniu.yincang=true
			end
			QuickButUI:UpdateWidth()
		end
		Update_ShowFun()
		BGanniu:RegisterEvent("PLAYER_ENTERING_WORLD")
		BGanniu:HookScript("OnEvent", function (self, event)
			if event=="PLAYER_ENTERING_WORLD" then
				Update_ShowFun()
			end
		end)
		BGanniu:SetScript("OnClick", function (self, event)
			local inInstance, instanceType = IsInInstance();
			if instanceType=="pvp" then
				if event=="RightButton" then
					SendChatMessage(GetMinimapZoneText().."已安全，机动人员请机动支援！", "instance_chat") 
				else
					if not direnshuliangpig or not hanhuaTimejiange or GetTime()-hanhuaTimejiange>10 then
						direnshuliangpig=0;
					end;
					hanhuaTimejiange=GetTime(); direnshuliangpig=direnshuliangpig+1; SendChatMessage(GetMinimapZoneText().."有"..direnshuliangpig.."个敌人来袭，请求支援！", "instance_chat"); 
				end
			else
				PIG_OptionsUI:ErrorMsg("请在战场内使用")
			end
		end);
	end
end
--炉石专业按钮----
QuickButUI.ButList[7]=function()
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["Lushi"] then
		if QuickButUI.LushiOpen then return end
		QuickButUI.LushiOpen=true
		local Icon=134414
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF使用炉石|r\rShift+"..KEY_BUTTON1.."-|cff00FFFF选择炉石\r|r"..KEY_BUTTON2.."-|cff00FFFF专业技能|r"
		local General=PIGQuickBut(nil,Tooltip,Icon,nil,nil,"SecureActionButtonTemplate")
		PIGUseKeyDown(General)
		General.Cooldown = CreateFrame("Frame", nil, General);
		General.Cooldown:SetAllPoints()
		General.Cooldown.N = CreateFrame("Cooldown", nil, General.Cooldown, "CooldownFrameTemplate")
		General.Cooldown.N:SetAllPoints()

		General.START = General:CreateTexture(nil, "OVERLAY");
		General.START:SetTexture(130724);
		General.START:SetBlendMode("ADD");
		General.START:SetAllPoints(General)
		General.START:Hide();

		General.arrow = General:CreateTexture(nil,"ARTWORK");
		General.arrow:SetDrawLayer("ARTWORK", 7)
		General.arrow.chushijiaodu=0
		General.arrow.jieshujiaodu=180
		if PIG_MaxTocversion() then
			General.arrow:SetAtlas("bag-arrow")
			General.arrow:SetSize(11,16);
			General.arrow:SetPoint("TOP",0,1);
			General.arrow.chushijiaodu=270
			General.arrow.jieshujiaodu=90
		else
			General.arrow:SetAtlas("UI-HUD-ActionBar-Flyout-Mouseover");
			General.arrow:SetSize(16,8);
			General.arrow:SetPoint("TOP",0,0);
		end
		SetClampedTextureRotation(General.arrow,General.arrow.chushijiaodu);

		local function gengxinlushiCD()
			if General.lushiitemID then
				local start, duration= GetItemCooldown(General.lushiitemID)
				if start and duration then
		 			General.Cooldown.N:SetCooldown(start, duration);
		 		end
		 	end
	 	end
		--玩具
		local ToyList = {}
		local ToyList_Retail = {
			168907,--数字化全息炉石
			162973,--冬天爷爷的炉石
			166746,--吞火者的炉石
			165802,--复活节的炉石
			165802,--复活节的炉石
			165670,--小匹德菲特的可爱炉石
			208704,--幽邃住民的土灵炉石
			190196,--开悟者的炉石
			228940,--恶名丝线炉石
			163045,--无头骑士的炉石
			193588,--时光旅行者的炉石
			165669,
			184353,
			200630,
			172179,
			180290,
			209035,
			166747,
			188952,
			110560,--要塞炉石
			140192,--达拉然炉石
			182773,
			212337,--炉之石
			93672,--黑暗之门
			64488,--旅店老板的女儿
		}
		local BagList = {
			6948,--炉石
			46874,--银色北伐军战袍
		}
		if PIG_MaxTocversion(110000,true) then
			for k,v in pairs(ToyList_Retail) do
				table.insert(ToyList,v)
			end
		elseif PIG_MaxTocversion(20000,true) then
			table.insert(ToyList,184871)--黑暗之门
			table.insert(BagList,28585)--红宝石靴子
		else

		end
		local listall={}
		local function BAGIsitemID(duibiID)
			for bag=1,#bagData["bagID"] do
				for slot=1,GetContainerNumSlots(bagData["bagID"][bag]) do
					local ItemID = GetContainerItemID(bagData["bagID"][bag], slot)
					if ItemID and ItemID==duibiID then
						return true
					end
				end
			end
			return false
		end
		local function jiazaiHasToy()
			for i=1,#ToyList do
				local HasToy = PlayerHasToy(ToyList[i])
				if HasToy then
					table.insert(listall,{ToyList[i],true})
				else
					table.insert(listall,{ToyList[i],false})
				end
			end
			for i=1,#BagList do
				local HasToy = BAGIsitemID(BagList[i])
				if HasToy then
					table.insert(listall,{BagList[i],true})
				else
					table.insert(listall,{BagList[i],false})
				end
			end
		end
		jiazaiHasToy()
		local function UpdateIconAttribute(itemID)
			local itemID=itemID or PIGA_Per["QuickBut"]["LushiID"]
			local lushiName, SpellID = GetItemSpell(itemID)
			if not lushiName and General.lushijisuqi<5 then
				General.lushijisuqi=General.lushijisuqi+1
				return C_Timer.After(0.2, UpdateIconAttribute);
			end
			if lushiName and SpellID then
				--local itemName = GetItemInfo(itemID)
				General.lushiitemID=itemID
				General.lushiSpellID=SpellID
				General:SetAttribute("type1", "item");
				General:SetAttribute("item", lushiName);
				General:SetNormalTexture(GetItemIcon(itemID))
				gengxinlushiCD()
			end
		end	
		local function Skill_Button_Genxin()
			if InCombatLockdown() then return end
	 		local Skill_List = Data.Get_Skill_Info(true)
			if #Skill_List.top>0 then
				General:SetAttribute("type2", "spell");
				General:SetAttribute("spell", Skill_List.top[1][2]);
			end
		end
		General.lushijisuqi=0
		UpdateIconAttribute()
		Skill_Button_Genxin()
		General:RegisterEvent("PLAYER_ENTERING_WORLD")
		General:RegisterUnitEvent("UNIT_SPELLCAST_START","player");
		General:RegisterUnitEvent("UNIT_SPELLCAST_STOP","player");
		General:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		General:SetScript("OnEvent", function(self,event,arg1,_,arg3)
			if event=="PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent("PLAYER_ENTERING_WORLD")
				General.lushijisuqi=0
				UpdateIconAttribute()
				Skill_Button_Genxin()
			elseif event=="SPELL_UPDATE_COOLDOWN" then
				C_Timer.After(0.01, gengxinlushiCD);
			else
				if arg3==self.lushiSpellID then 
					if event=="UNIT_SPELLCAST_START" then
				 		self.START:Show();
				 	end
				 	if event=="UNIT_SPELLCAST_STOP" then
				 		self.START:Hide();
					end
				end
			end
		end)
		--内容页
		local butW = ActionButton1:GetWidth()
		local gaoNum,kuanNum = 5,6
		local General_List = PIGFrame(General, nil, {(butW+6)*kuanNum+6,(butW+6)*gaoNum+6},"PIG_QuickBut_General",true);
		General_List:PIGSetBackdrop()
		General_List:SetScale(PIGA["QuickBut"]["bili"]);
		General_List:SetFrameLevel(33)
		General_List:SetScale(0.8)
		General_List:HookScript("OnShow",function(self)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
			SetClampedTextureRotation(General.arrow,General.arrow.jieshujiaodu);
			for i=1,#listall do
				if listall[i][1]==PIGA_Per["QuickBut"]["LushiID"] then
					General_List.ButList[i].Select:Show();
				else
					General_List.ButList[i].Select:Hide();
				end
			end
		end)
		General_List:HookScript("OnHide",function(self)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
			SetClampedTextureRotation(General.arrow,General.arrow.chushijiaodu);
		end)
		General_List.Close=PIGDiyBut(General_List,{"BOTTOM",General_List,"TOP",0,0},{26})
		General_List.Close:HookScript("OnClick",function(self)
			General_List:Hide();
		end)
		local WowHeight=GetScreenHeight();
		General:HookScript("OnClick",function(self,button)
			if button == "LeftButton" and IsShiftKeyDown() then
				if General_List:IsShown() then
					General_List:Hide();
				else
					local offset = QuickButUI:GetBottom();
					General_List:ClearAllPoints()
					if offset>(WowHeight*0.5) then
						General_List:SetPoint("TOP", General, "BOTTOM", 0, -4);
					else
						General_List:SetPoint("BOTTOM", General, "TOP", 0, 4);
					end
					General_List:Show();
				end
			end
		end)
		General_List.ButList={}
		for i=1,gaoNum*kuanNum do
			if listall[i] then
				local butitem = CreateFrame("Button", nil, General_List)
				General_List.ButList[i]=butitem
				butitem:SetHighlightTexture(130839)
				butitem:SetSize(butW, butW)
				if i==1 then
					butitem:SetPoint("BOTTOMLEFT",General_List,"BOTTOMLEFT",6,6);
				else
					local num1,num2=math.modf(i/(kuanNum))
					if num2==0 then
						butitem.huanhang=true
					end
					if General_List.ButList[i-1].huanhang then
						butitem:SetPoint("BOTTOMLEFT",General_List.ButList[i-kuanNum],"TOPLEFT",0,6);
					else
						butitem:SetPoint("LEFT",General_List.ButList[i-1],"RIGHT",6,0);
					end	
				end
				butitem.Select = butitem:CreateTexture(nil, "OVERLAY");
				butitem.Select:SetTexture(130724);
				butitem.Select:SetBlendMode("ADD");
				butitem.Select:SetAllPoints(butitem)
				butitem.Select:Hide();
				local itemicon=C_Item.GetItemIconByID(listall[i][1])
				butitem:SetNormalTexture(itemicon);
				if listall[i][2] then
					if listall[i][1]==PIGA_Per["QuickBut"]["LushiID"] then
						butitem.Select:Show();
					end
				else
					butitem:GetNormalTexture():SetDesaturated(true)
				end
				butitem:HookScript("OnClick", function(self)
					if listall[i][2] then
						if InCombatLockdown() then
							PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT)
						else
							PIGA_Per["QuickBut"]["LushiID"]=listall[i][1]
							UpdateIconAttribute(listall[i][1]) General_List:Hide();
						end
					end
				end);
				butitem:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
					GameTooltip:SetItemByID(listall[i][1])
					GameTooltip:Show();
				end)
				butitem:SetScript("OnLeave", function ()
					GameTooltip:ClearLines();
					GameTooltip:Hide() 
				end);
			end
		end
	end
end
--职业技能----
local Item_Spell_List ={{},{}}
if PIG_MaxTocversion() then
	Item_Spell_List[1] ={18984,18986,7148,18587,18232,18660};--空间撕裂器-永望镇/安全传送器-加基森/起搏器/起搏器XL
	local _, classId = UnitClassBase("player");--1战士/2圣骑士/3猎人/4盗贼/5牧师/6死亡骑士/7萨满祭司/8法师/9术士/10武僧/11德鲁伊/12恶魔猎手
	if classId==3 then --3猎人
		Item_Spell_List[2] ={1002,6197,982,2641,1462,1515,883};
		if PIG_MaxTocversion(30000,true) then
			table.insert(Item_Spell_List[2],62757);	
		else
			table.insert(Item_Spell_List[2],5149);
			table.insert(Item_Spell_List[2],6991);
		end
	elseif classId==4 then--盗贼
		Item_Spell_List[2] ={2842};
	elseif classId==6 then
		Item_Spell_List[2] ={53428,50977};
	elseif classId==8 then --法师
		local englishFaction, _ = UnitFactionGroup("player")
		if englishFaction=="Alliance" then
			Item_Spell_List[2] ={3561,10059,3562,11416,3565,11419};			
		elseif englishFaction=="Horde" then
			Item_Spell_List[2] ={3567,11417,3566,11420,3563,11418};
		end
		if PIG_MaxTocversion(20000,true) then
			if englishFaction=="Alliance" then
				local tbcchuansong = {32271,32266,49359,49360,33690,33691};	
				for ik=1,#tbcchuansong do
					table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
				end
			elseif englishFaction=="Horde" then
				local tbcchuansong = {32272,32267,49358,49361,35715,35717};
				for ik=1,#tbcchuansong do
					table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
				end
			end
		end
		if PIG_MaxTocversion(30000,true) then
			local tbcchuansong ={53140,53142};
			for ik=1,#tbcchuansong do
				table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
			end			
		end
	else

	end
	for i=1,#Item_Spell_List[1] do
		local item = Item:CreateFromItemID(Item_Spell_List[1][i])
		item:ContinueOnItemLoad(function()
			local Link = item:GetItemLink()
		end)
	end
end
QuickButUI.ButList[8]=function()
	local PigMacroEventCount_QK =0;
	local PigMacroDeleted_QK = false;
	local PigMacroCount_QK=0
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["Spell"] then
		if QuickButUI.SpellOpen then return end
		QuickButUI.SpellOpen=true
		local Icon,ActionID=131146, 400
		local wupinlinrongqi = {}
		local wupinlinrongqicishunum = 0
		local function GetItemInfo_xa_1()
			for i=1,#Item_Spell_List[1] do
				local itemName,itemLink = GetItemInfo(Item_Spell_List[1][i])
				wupinlinrongqi[i]=itemLink
			end
		end
		local function GetItemInfo_xa_2()
			for i=1,#wupinlinrongqi do
				local butid = ActionID+i
				local itemLink=wupinlinrongqi[i]
				if itemLink and not PIGA_Per["QuickBut"]["ActionData"][butid] then
					PIGA_Per["QuickBut"]["ActionData"][butid]={"item",itemLink,Item_Spell_List[1][i]}
				end
			end
		end
		local function GetItemInfo_xa()
			GetItemInfo_xa_1()
			for i=1,#wupinlinrongqi do
				if not wupinlinrongqi[i] and wupinlinrongqicishunum<10 then
					wupinlinrongqicishunum=wupinlinrongqicishunum+1
					return C_Timer.After(0.1,GetItemInfo_xa_1)
				end
			end
			if not InCombatLockdown() then GetItemInfo_xa_2() end
		end
		GetItemInfo_xa()
		local Itemnum = #Item_Spell_List[1]
		for i=1,#Item_Spell_List[2] do
			local butid = ActionID+i+Itemnum
			if not PIGA_Per["QuickBut"]["ActionData"][butid] then
				PIGA_Per["QuickBut"]["ActionData"][butid]={"spell",Item_Spell_List[2][i]}
			end
		end
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF随机使用坐骑|r\nShift+"..KEY_BUTTON1.."-|cff00FFFF打开Recount/Details插件记录面板|r\n"..KEY_BUTTON2.."-|cff00FFFF展开职业辅助技能栏|r"
		local Zhushou=PIGQuickBut(nil,Tooltip,Icon,nil,nil,"SecureHandlerClickTemplate")
		local IconTEX=Zhushou:GetNormalTexture()
		local IconCoord = CLASS_ICON_TCOORDS[PIG_OptionsUI.ClassData.classFile];
		if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() then
			local left, right, top, bottom = unpack(IconCoord);
			local left   = left+0.02;
			local right  = right  - 0.02;
			local top    = top+0.02;
			local bottom = bottom - 0.02;
			IconTEX:SetTexCoord(left, right, top, bottom);
		else
			IconTEX:SetTexCoord(unpack(IconCoord));
		end
		Zhushou.arrow = Zhushou:CreateTexture(nil,"ARTWORK");
		Zhushou.arrow:SetDrawLayer("ARTWORK", 7)
		Zhushou.arrow.chushijiaodu=0
		Zhushou.arrow.jieshujiaodu=180
		if PIG_MaxTocversion() then
			Zhushou.arrow:SetAtlas("bag-arrow")
			Zhushou.arrow:SetSize(11,16);
			Zhushou.arrow:SetPoint("TOP",0,1);
			Zhushou.arrow.chushijiaodu=270
			Zhushou.arrow.jieshujiaodu=90
		else
			Zhushou.arrow:SetAtlas("UI-HUD-ActionBar-Flyout-Mouseover");
			Zhushou.arrow:SetSize(16,8);
			Zhushou.arrow:SetPoint("TOP",0,0);
		end
		SetClampedTextureRotation(Zhushou.arrow,Zhushou.arrow.chushijiaodu);
		---内容页----
		local butW = ActionButton1:GetWidth()
		local gaoNum,kuanNum = 10,2
		local Zhushou_List = CreateFrame("Frame", nil, Zhushou,"BackdropTemplate,SecureHandlerShowHideTemplate");
		Zhushou_List:SetBackdrop(Create.Backdropinfo)
		Zhushou_List:SetBackdropColor(Create.BackdropColor[1], Create.BackdropColor[2], Create.BackdropColor[3], Create.BackdropColor[4]);
		Zhushou_List:SetBackdropBorderColor(Create.BackdropBorderColor[1], Create.BackdropBorderColor[2], Create.BackdropBorderColor[3], Create.BackdropBorderColor[4]);
		Zhushou_List:SetSize((butW+6)*kuanNum+6,(butW+6)*gaoNum+6);
		Zhushou_List:SetScale(PIGA["QuickBut"]["bili"]);
		Zhushou_List:Hide();
		Zhushou_List:SetFrameLevel(33)
		Zhushou_List:SetScale(0.8)
		--
		local WowHeight=GetScreenHeight();
		local offset = Zhushou:GetBottom();
		Zhushou_List:ClearAllPoints()
		if offset>(WowHeight*0.5) then
			Zhushou_List:SetPoint("TOP", Zhushou, "BOTTOM", 0, -4);
		else
			Zhushou_List:SetPoint("BOTTOM", Zhushou, "TOP", 0, 4);
		end
		--
		Zhushou_List:HookScript("OnShow",function(self)
			SetClampedTextureRotation(Zhushou.arrow,Zhushou.arrow.jieshujiaodu);
		end)
		Zhushou_List:HookScript("OnHide",function(self)
			SetClampedTextureRotation(Zhushou.arrow,Zhushou.arrow.chushijiaodu);
		end)
		PIGUseKeyDown(Zhushou)
		Zhushou:RegisterForClicks("AnyUp");
		Zhushou:SetAttribute("_onclick",[=[
			if button == "RightButton" then
				local ref=self:GetFrameRef("frame1")
				if ref:IsShown() then
					ref:Hide();
				else
					ref:Show();
				end
			end
		]=])
		Zhushou:SetFrameRef("frame1", Zhushou_List);
		Zhushou:HookScript("OnClick",function(self,button)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
			if button == "LeftButton" then
				if IsShiftKeyDown() then
					if Recount then
						if Recount.MainWindow:IsShown() then
							Recount.MainWindow:Hide()
						else
							Recount.MainWindow:Show()
							Recount:RefreshMainWindow()
						end
					elseif DetailsBaseFrame1 then
						for i=1,10 do
							if not _G["DetailsBaseFrame"..i] then break end
							if _G["DetailsBaseFrame"..i]:IsShown() then
								_G["DetailsBaseFrame"..i]:Hide()
							else
								_G["DetailsBaseFrame"..i]:Show()
							end
						end
					else
						PIG_OptionsUI:ErrorMsg("未安装Recount/Details");
					end
				else
					C_MountJournal.SummonByID(0)
				end
			end
		end)
		Zhushou.START = Zhushou:CreateTexture(nil, "OVERLAY");
		Zhushou.START:SetTexture(130724);
		Zhushou.START:SetBlendMode("ADD");
		Zhushou.START:SetAllPoints(Zhushou)
		Zhushou.START:Hide();
		Zhushou:RegisterEvent("PLAYER_ENTERING_WORLD");
		Zhushou:RegisterEvent("ZONE_CHANGED_INDOORS");
		Zhushou:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
		Zhushou:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED");
		Zhushou:RegisterUnitEvent("UNIT_SPELLCAST_START","player");
		Zhushou:RegisterUnitEvent("UNIT_SPELLCAST_STOP","player");
		Zhushou:SetScript("OnEvent", function(self,event,arg1,_,arg3)
			if event=="UNIT_SPELLCAST_START" or event=="UNIT_SPELLCAST_STOP" then
				local mountID = C_MountJournal.GetMountFromSpell(arg3)
				if mountID then 
					-- local name, spellID= C_MountJournal.GetMountInfoByID(mountID)
					-- if arg3==spellID then
					if event=="UNIT_SPELLCAST_START" then
				 		self.START:Show();
				 	end
				 	if event=="UNIT_SPELLCAST_STOP" then
				 		self.START:Hide();
					end
				end
			elseif event=="PLAYER_ENTERING_WORLD" or event=="ACTIONBAR_UPDATE_USABLE" or event=="MOUNT_JOURNAL_USABILITY_CHANGED" then
				if IsIndoors() then
					self:GetNormalTexture():SetVertexColor(0.5, 0.5, 0.5)
				else
					self:GetNormalTexture():SetVertexColor(1, 1, 1);
				end
			end
		end)
		---
		Zhushou_List.Close=PIGDiyBut(Zhushou_List,{"BOTTOMRIGHT",Zhushou_List,"TOPRIGHT",0,0},{26},nil,"SecureHandlerClickTemplate")
		Zhushou_List.Close:SetAttribute("_onclick",[=[
			if button == "LeftButton" then
				local ref=self:GetFrameRef("frame1")
				if ref:IsShown() then
					ref:Hide();
				else
					ref:Show();
				end
			end
		]=])
		Zhushou_List.Close:SetFrameRef("frame1", Zhushou_List);
		Zhushou_List.ClickClose = PIGCheckbutton(Zhushou_List,{"RIGHT",Zhushou_List.Close,"LEFT",-butW*0.4,0},{"","按钮点击使用后关闭界面"});
		Zhushou_List.ClickClose:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["QuickBut"]["SpellClose"]=true;
			else
				PIGA["QuickBut"]["SpellClose"]=false;
			end
		end)
		Zhushou_List.ClickClose:SetScript("OnShow", function (self)
			self:SetChecked(PIGA["QuickBut"]["SpellClose"])
		end)
		Zhushou_List.Reset = PIGDiyBut(Zhushou_List,{"RIGHT",Zhushou_List.ClickClose,"LEFT",-4,0},{21,nil,21,nil,"common-icon-undo"})
		Zhushou_List.Reset:SetScript("OnClick", function (self)
			StaticPopup_Show ("ZHUSHOU_LISTRESET");
		end)
		StaticPopupDialogs["ZHUSHOU_LISTRESET"] = {
			text = "|cffff0000重置|r"..CLASS..BINDING_HEADER_ACTIONBAR.."为默认(需要重载界面)\n确定重置?",
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				PIGA_Per["QuickBut"]["ActionData"]={}
				ReloadUI();
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		Zhushou_List.ButList={}
		for i=1,gaoNum*kuanNum do
			local zhushoubut
			if PIG_MaxTocversion(40000) then
				zhushoubut = CreateFrame("CheckButton", nil, Zhushou_List, "SecureActionButtonTemplate,ActionButtonTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate")
				zhushoubut.NormalTexture:SetAlpha(0.4);
				zhushoubut.cooldown:SetSwipeColor(0, 0, 0, 0.8);
			else
				zhushoubut = CreateFrame("CheckButton", nil, Zhushou_List, "SecureActionButtonTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate")
				zhushoubut.Height = zhushoubut:CreateTexture(nil, "HIGHLIGHT");
				zhushoubut.Height:SetAtlas("UI-HUD-ActionBar-IconFrame-Mouseover")
				zhushoubut.Height:SetBlendMode("ADD");
				zhushoubut.Height:SetAllPoints(zhushoubut)
				zhushoubut.NormalTexture = zhushoubut:CreateTexture()
				zhushoubut.NormalTexture:SetAllPoints(zhushoubut)
				zhushoubut.NormalTexture:SetAtlas("UI-HUD-ActionBar-IconFrame")
				zhushoubut.icon = zhushoubut:CreateTexture()
				zhushoubut.icon:SetAllPoints(zhushoubut)
				zhushoubut.cooldownF = CreateFrame("Frame", nil, zhushoubut);
				zhushoubut.cooldownF:SetAllPoints()
				zhushoubut.cooldown = CreateFrame("Cooldown", nil, zhushoubut.cooldownF, "CooldownFrameTemplate")
				zhushoubut.cooldown:SetAllPoints()
				zhushoubut.Name = PIGFontString(zhushoubut,{"BOTTOM",zhushoubut,"BOTTOM",0,0})
				zhushoubut.Count = PIGFontString(zhushoubut,{"BOTTOMRIGHT",zhushoubut,"BOTTOMRIGHT",0,0})
			end
			Zhushou_List.ButList[i]=zhushoubut
			zhushoubut:SetSize(butW, butW)
			if i==1 then
				zhushoubut:SetPoint("BOTTOMLEFT",Zhushou_List,"BOTTOMLEFT",6,6);
			else
				local num1,num2=math.modf(i/kuanNum)
				if num2~=0 then
					zhushoubut:SetPoint("BOTTOMLEFT",Zhushou_List.ButList[i-kuanNum],"TOPLEFT",0,6);
				else
					zhushoubut:SetPoint("LEFT",Zhushou_List.ButList[i-1],"RIGHT",6,0);
				end
			end
	 		local ActionID = ActionID+i
	 		zhushoubut.action=ActionID
			zhushoubut:SetAttribute("action", ActionID)
			--
			PIGUseKeyDown(zhushoubut)
			loadingButInfo(zhushoubut,"QuickBut")
			--
			zhushoubut:HookScript("PostClick", function(self)
				Update_PostClick(self)
				if PIGA["QuickBut"]["SpellClose"] and not InCombatLockdown() then Zhushou_List:Hide() end
			end);
			zhushoubut:SetAttribute("_ondragstart",[=[
				self:SetAttribute("type", nil)
			]=])
			zhushoubut:HookScript("OnShow", function (self)
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
				Update_bukeyong(self)
			end)
			--
			zhushoubut:HookScript("OnMouseUp", function (self)
				Cursor_Fun(self,"OnMouseUp","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end);
			----
			zhushoubut:SetAttribute("_ondragstart",[=[
				self:SetAttribute("type", nil)
			]=])
			zhushoubut:HookScript("OnDragStart", function (self)
				Cursor_Fun(self,"OnDragStart","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end)
			--
			zhushoubut:SetAttribute("_onreceivedrag",[=[
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
			zhushoubut:HookScript("OnReceiveDrag", function (self)
				Cursor_Fun(self,"OnReceiveDrag","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end);
			----
			zhushoubut:SetScript("OnEnter", function (self)
				GameTooltip:ClearLines();
				GameTooltip_SetDefaultAnchor(GameTooltip, self)
				Update_OnEnter(self,"QuickBut")
			end)
			zhushoubut:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
			--
			zhushoubut:RegisterEvent("TRADE_SKILL_CLOSE")
			if PIG_MaxTocversion() then
				zhushoubut:RegisterEvent("CRAFT_CLOSE")
			end
			PIGUseKeyDown(zhushoubut)
			zhushoubut:RegisterEvent("UPDATE_MACROS");
			--zhushoubut:RegisterEvent("EXECUTE_CHAT_LINE");
			zhushoubut:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
			zhushoubut:RegisterEvent("ACTIONBAR_UPDATE_STATE");
			zhushoubut:RegisterUnitEvent("UNIT_AURA","player");
			zhushoubut:RegisterEvent("BAG_UPDATE");
			zhushoubut:RegisterEvent("PLAYER_UPDATE_RESTING");
			zhushoubut:HookScript("OnEvent", function(self,event,arg1,arg2,arg3)
				if Zhushou_List:IsShown() then
					if event=="PLAYER_REGEN_ENABLED" then
						PigMacroDeleted_QK,PigMacroCount_QK=Update_Macro(self,PigMacroDeleted_QK,PigMacroCount_QK,"QuickBut")
						self:UnregisterEvent("PLAYER_REGEN_ENABLED");
					elseif event=="BAG_UPDATE" then
						Update_Count(self)
					elseif event=="ACTIONBAR_UPDATE_COOLDOWN" then
						Update_Cooldown(self)
						Update_bukeyong(self)
					elseif event=="ACTIONBAR_UPDATE_STATE" or event=="TRADE_SKILL_CLOSE" or event=="CRAFT_CLOSE" or event=="UNIT_AURA" or event=="EXECUTE_CHAT_LINE" then
						Update_State(self)
						Update_Icon(self)
					elseif event=="UPDATE_MACROS" or event=="PLAYER_REGEN_ENABLED" then
						PigMacroEventCount_QK=PigMacroEventCount_QK+1;
						if self.Type=="macro" then
							if PigMacroEventCount_QK>5 then
								local AccMacros, CharMacros = GetNumMacros();
								if PigMacroCount_QK==0 then
									PigMacroCount_QK = AccMacros + CharMacros;
								elseif (PigMacroCount_QK > AccMacros + CharMacros) then
									PigMacroDeleted_QK = true;
								end
								PigMacroDeleted_QK,PigMacroCount_QK=Update_Macro(self,PigMacroDeleted_QK,PigMacroCount_QK,"QuickBut")
							end
						end
						Update_Icon(self)
						Update_Count(self)
					elseif event=="PLAYER_UPDATE_RESTING" then
						Update_bukeyong(self)
					end
				end
			end)
		end
	end
end