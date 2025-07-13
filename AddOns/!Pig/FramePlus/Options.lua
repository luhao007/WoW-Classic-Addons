local addonName, addonTable = ...;
local L=addonTable.locale
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
--
local Fun=addonTable.Fun
local Data=addonTable.Data
---
local fuFrame = PIGOptionsList(L["FRAMEP_TABNAME"],"TOP")
--
local RTabFrame =Create.PIGOptionsList_RF(fuFrame)
--
local FramePlusfun={}
addonTable.FramePlusfun=FramePlusfun
--
local FramePlusF,FramePlustabbut =PIGOptionsList_R(RTabFrame,L["COMMON_TABNAME"],90)
FramePlusF:Show()
FramePlustabbut:Selected()
----------------------
FramePlusF.BuffTime = PIGCheckbutton_R(FramePlusF,{"优化BUFF时间显示","精确显示自身BUFF/DEBUFF时间"})
FramePlusF.BuffTime:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["BuffTime"]=true;
		FramePlusfun.BuffTime()
	else
		PIGA["FramePlus"]["BuffTime"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
----
FramePlusF.Skill_QKbut = PIGCheckbutton_R(FramePlusF,{"专业界面快速切换按钮","在专业界面显示便捷切换专业按钮"})
FramePlusF.Skill_QKbut:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Skill_QKbut"]=true;
		FramePlusfun.Skill_QKbut()
	else
		PIGA["FramePlus"]["Skill_QKbut"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);

------
FramePlusF.AddonList = PIGCheckbutton_R(FramePlusF,{"增强插件列表(插件启用状态保存)","增强插件列表，让你可以按需开启插件"})
FramePlusF.AddonList:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["AddonList"]=true;
		FramePlusfun.AddonList()
	else
		PIGA["FramePlus"]["AddonList"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
if PIG_MaxTocversion(20000) then
	local tooltip = "整合追踪类技能，点击小地图追踪技能按钮选择其他追踪技能！";
	FramePlusF.Tracking = PIGCheckbutton_R(FramePlusF,{"整合追踪技能",tooltip})
	FramePlusF.Tracking:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Tracking"]=true
			FramePlusfun.Tracking()
		else
			PIGA["FramePlus"]["Tracking"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end)
end

-------
FramePlusF.yidong = PIGFrame(FramePlusF,{"BOTTOMLEFT",FramePlusF,"BOTTOMLEFT",0,0})
FramePlusF.yidong:PIGSetBackdrop(0)
FramePlusF.yidong:SetHeight(60)
FramePlusF.yidong:SetPoint("BOTTOMRIGHT",FramePlusF,"BOTTOMRIGHT",0,0);

FramePlusF.yidong.BlizzardUI_Move = PIGCheckbutton(FramePlusF.yidong,{"LEFT",FramePlusF.yidong,"LEFT",20,0},{"解锁(移动)系统界面","解锁系统界面，使其可以:\n1.移动:拖动界面标题栏移动\n2.缩放:在需要缩放界面按住Ctrl+Alt滚动鼠标滚轮"})
FramePlusF.yidong.BlizzardUI_Move:SetScript("OnClick", function (self)
	if InCombatLockdown() then self:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move"]) PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
	if self:GetChecked() then
		PIGA["FramePlus"]["BlizzardUI_Move"]=true;
		FramePlusfun.BlizzardUI_Move()
	else
		PIGA["FramePlus"]["BlizzardUI_Move"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
FramePlusF.yidong.BlizzardUI_Move.Save = PIGCheckbutton(FramePlusF.yidong,{"LEFT",FramePlusF.yidong.BlizzardUI_Move.Text,"RIGHT",40,0},{"保存移动后位置","保存移动后位置"})
FramePlusF.yidong.BlizzardUI_Move.Save:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["BlizzardUI_Move_Save"]=true	
	else
		PIGA["FramePlus"]["BlizzardUI_Move_Save"]=false
	end
end);

FramePlusF.UIWidget = PIGFrame(FramePlusF,{"BOTTOMLEFT",FramePlusF.yidong,"TOPLEFT",0,-1})
FramePlusF.UIWidget:PIGSetBackdrop(0)
FramePlusF.UIWidget:SetHeight(60)
FramePlusF.UIWidget:SetPoint("BOTTOMRIGHT",FramePlusF.yidong,"TOPRIGHT",0,-1);
FramePlusF.UIWidget.Open = PIGCheckbutton(FramePlusF.UIWidget,{"LEFT",FramePlusF.UIWidget,"LEFT",20,0},{"移动小部件","移动屏幕中上部的小部件(占塔/战场积分面板)"})
FramePlusF.UIWidget.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["UIWidget"]=true;
		FramePlusfun.UIWidget()
	else
		PIGA["FramePlus"]["UIWidget"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
FramePlusF.UIWidget.pianyiX = PIGSlider(FramePlusF.UIWidget,{"LEFT",FramePlusF.UIWidget.Open.Text,"RIGHT",10,0},{-700,700,1,{["Right"]="X偏移%s"}})
FramePlusF.UIWidget.pianyiX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["FramePlus"]["UIWidgetPointX"]=arg1;
	FramePlusfun.UIWidget()
end)
FramePlusF.UIWidget.pianyiY = PIGSlider(FramePlusF.UIWidget,{"LEFT",FramePlusF.UIWidget.pianyiX,"RIGHT",80,0},{-500,15,1,{["Right"]="Y偏移%s"}})
FramePlusF.UIWidget.pianyiY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["FramePlus"]["UIWidgetPointY"]=arg1
	FramePlusfun.UIWidget()
end)
function FramePlusfun.UIWidget()
	if not PIGA["FramePlus"]["UIWidget"] then return end
	UIWidgetTopCenterContainerFrame:SetPoint("TOP", 0+PIGA["FramePlus"]["UIWidgetPointX"], -15+PIGA["FramePlus"]["UIWidgetPointY"]);
end
--
FramePlusF:HookScript("OnShow", function(self)
	self.BuffTime:SetChecked(PIGA["FramePlus"]["BuffTime"])
	self.Skill_QKbut:SetChecked(PIGA["FramePlus"]["Skill_QKbut"])
	self.UIWidget.Open:SetChecked(PIGA["FramePlus"]["UIWidget"])
	self.UIWidget.pianyiX:PIGSetValue(PIGA["FramePlus"]["UIWidgetPointX"])
	self.UIWidget.pianyiY:PIGSetValue(PIGA["FramePlus"]["UIWidgetPointY"])
	self.AddonList:SetChecked(PIGA["FramePlus"]["AddonList"])
	if self.Tracking then self.Tracking:SetChecked(PIGA["FramePlus"]["Tracking"]) end
	self.yidong.BlizzardUI_Move:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move"])
	self.yidong.BlizzardUI_Move.Save:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move_Save"])
end)

---界面扩展-------------
local FrameExtF =PIGOptionsList_R(RTabFrame,L["FRAMEP_TABNAME2"],90)
FrameExtF.Merchant = PIGCheckbutton_R(FrameExtF,{"商人界面扩展","扩展商人界面为两列"})
FrameExtF.Merchant:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Merchant"]=true;
		FramePlusfun.Merchant()
	else
		PIGA["FramePlus"]["Merchant"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
FrameExtF.Friends = PIGCheckbutton_R(FrameExtF,{FRIEND.."界面扩展","扩展"..FRIEND.."界面为两列"})
FrameExtF.Friends:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Friends"]=true;
		FramePlusfun.Friends()
	else
		PIGA["FramePlus"]["Friends"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
FrameExtF.Macro = PIGCheckbutton_R(FrameExtF,{MACRO.."界面扩展","扩展"..MACRO.."界面为两列"})
FrameExtF.Macro:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Macro"]=true;
	else
		PIGA["FramePlus"]["Macro"]=false
	end
	PIG_OptionsUI.RLUI:Show()
end)
---
if PIG_MaxTocversion() then
	FrameExtF.Quest = PIGCheckbutton_R(FrameExtF,{"任务界面扩展",""})
	if PIG_MaxTocversion(30000) then
		FrameExtF.Quest.tooltip= "扩展任务界面为两列,左边任务列表，右边任务详情,显示任务等级";
	else
		FrameExtF.Quest.tooltip= "任务列表显示任务等级";
	end
	FrameExtF.Quest:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Quest"]=true;
			FramePlusfun.Quest()
		else
			PIGA["FramePlus"]["Quest"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	--
	FrameExtF.Skill = PIGCheckbutton_R(FrameExtF,{"专业界面扩展","扩展专业技能界面为两列；左边配方列表，右边配方详情"})
	FrameExtF.Skill:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Skill"]=true;
			FramePlusfun.Skill()
		else
			PIGA["FramePlus"]["Skill"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end)
	
	FrameExtF.Talent = PIGCheckbutton_R(FrameExtF,{"天赋界面扩展"," "})
	if PIG_MaxTocversion(30000) then
		FrameExtF.Talent.tooltip= "在一页显示三系天赋";
	else
		FrameExtF.Talent.tooltip= "在一页显示三系天赋和雕文";
	end
	FrameExtF.Talent:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Talent"]=true;
			FramePlusfun.Talent()
		else
			PIGA["FramePlus"]["Talent"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end)
end
FrameExtF:HookScript("OnShow", function(self)
	self.Merchant:SetChecked(PIGA["FramePlus"]["Merchant"])
	self.Friends:SetChecked(PIGA["FramePlus"]["Friends"])
	self.Macro:SetChecked(PIGA["FramePlus"]["Macro"])
	if self.Quest then self.Quest:SetChecked(PIGA["FramePlus"]["Quest"]) end
	if self.Skill then self.Skill:SetChecked(PIGA["FramePlus"]["Skill"]) end
	if self.Talent then self.Talent:SetChecked(PIGA["FramePlus"]["Talent"]) end
end)

--角色信息界面
local CharacterF =PIGOptionsList_R(RTabFrame,CHARACTER_BUTTON,90)
---
CharacterF.Character_Durability = PIGCheckbutton_R(CharacterF,{DISPLAY..EQUIPSET_EQUIP..DURABILITY,CHARACTER_BUTTON.."界面显示装备耐久剩余值"})
CharacterF.Character_Durability:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_Durability"]=true;
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_Durability"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
CharacterF.Character_ItemLevel = PIGCheckbutton_R(CharacterF,{DISPLAY..STAT_AVERAGE_ITEM_LEVEL,DISPLAY..STAT_AVERAGE_ITEM_LEVEL.."，背包银行物品需要显示装等请在背包内设置"})
CharacterF.Character_ItemLevel:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemLevel"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemLevel"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
CharacterF.Character_ItemColor = PIGCheckbutton_R(CharacterF,{DISPLAY_BORDERS..PET_BATTLE_STAT_QUALITY,"根据品质染色装备边框"})
CharacterF.Character_ItemColor:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemColor"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemColor"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
CharacterF.Character_ItemList = PIGCheckbutton_R(CharacterF,{DISPLAY.."装备列表",CHARACTER_BUTTON.."界面右侧显示装备列表"})
CharacterF.Character_ItemList:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemList"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemList"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)

--角色信息UI扩展
local newText=Fun.Delmaohaobiaodain(REPAIR_COST)
if PIG_MaxTocversion(30000) then
	CharacterF.Shuxingtishi=CHARACTER_INFO.."扩展("..PAPERDOLL_SIDEBAR_STATS.."/"..EQUIPMENT_MANAGER.."/"..newText.."/"..COMBAT_RATING_NAME6.."说明"..")"
elseif PIG_MaxTocversion(40000) then
	CharacterF.Shuxingtishi=CHARACTER_INFO.."扩展("..EQUIPMENT_MANAGER.."/"..newText.."/"..COMBAT_RATING_NAME6.."说明"..")"
elseif PIG_MaxTocversion() then
	CharacterF.Shuxingtishi="常驻"..DISPLAY..PAPERDOLL_SIDEBAR_STATS
else
	CharacterF.Shuxingtishi=CHARACTER_INFO..DISPLAY..newText
end
CharacterF.Character_Shuxing = PIGCheckbutton_R(CharacterF,{CharacterF.Shuxingtishi})
CharacterF.Character_Shuxing:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_Shuxing"]=true
		FramePlusfun.Character_Shuxing()
	else
		PIGA["FramePlus"]["Character_Shuxing"]=false
		PIG_OptionsUI.RLUI:Show()
	end
	_G[Data.QuickButUIname].ButList[5]()
end)
CharacterF:HookScript("OnShow", function(self)
	self.Character_Durability:SetChecked(PIGA["FramePlus"]["Character_Durability"])
	self.Character_ItemLevel:SetChecked(PIGA["FramePlus"]["Character_ItemLevel"])
	self.Character_ItemColor:SetChecked(PIGA["FramePlus"]["Character_ItemColor"])
	self.Character_ItemList:SetChecked(PIGA["FramePlus"]["Character_ItemList"])
	self.Character_Shuxing:SetChecked(PIGA["FramePlus"]["Character_Shuxing"])
end)
local LootRollF =PIGOptionsList_R(RTabFrame,LOOT,90)
LootRollF.Loot = PIGCheckbutton_R( LootRollF,{SLASH_TEXTTOSPEECH_LOOT..UIOPTIONS_MENU.."扩展",SLASH_TEXTTOSPEECH_LOOT..UIOPTIONS_MENU.."物品显示在一页，并且可以通报"},true)
LootRollF.Loot:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Loot"]=true;
		 FramePlusfun.Loot()
	else
		PIGA["FramePlus"]["Loot"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end)
---
function FramePlusfun.LootMasterErr() end
if PIG_MaxTocversion() then
	--修复队长分配错误
	function FramePlusfun.LootMasterErr()
		if PIGA["FramePlus"]["LootMasterErr"] then
			local old_MasterLooterFrame_Show=MasterLooterFrame_Show
			MasterLooterFrame_Show=function(selectedLootButton)
				MasterLooterFrame:ClearAllPoints();
				old_MasterLooterFrame_Show(selectedLootButton)
			end
		end
	end
	LootRollF.Loot.LootMasterErr = PIGCheckbutton(LootRollF.Loot,{"LEFT",LootRollF.Loot.Text,"RIGHT",100,0},{"修复队长分配错误"})
	LootRollF.Loot.LootMasterErr:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["LootMasterErr"]=true;
			 FramePlusfun.LootMasterErr()
		else
			PIGA["FramePlus"]["LootMasterErr"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end)
	LootRollF.Roll = PIGCheckbutton_R( LootRollF,{LOOT_ROLL..UIOPTIONS_MENU.."扩展","合并"..LOOT_ROLL.."物品到一起，并且可以移动"},true)
	LootRollF.Roll:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Roll"]=true;
			 FramePlusfun.Roll()
		else
			PIGA["FramePlus"]["Roll"]=false
			PIG_OptionsUI.RLUI:Show()
		end
	end)
	local Scaleinfo = {0.8,2,0.01,{["Right"]="%"}}
	local function ISopenUI(Funx)
		if _G[FramePlusfun.RollListUIname] then Funx() end
	end
	LootRollF.Roll.SliderT = PIGFontString( LootRollF.Roll,{"LEFT", LootRollF.Roll.Text,"RIGHT",20,0},"缩放")
	LootRollF.Roll.Slider = PIGSlider(LootRollF.Roll,{"LEFT", LootRollF.Roll.SliderT,"RIGHT",4,0},Scaleinfo)	
	LootRollF.Roll.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT) return end
		PIGA["FramePlus"]["RollScale"]=arg1;
		ISopenUI(FramePlusfun.RollDebugUI)
	end)
	LootRollF.Debug = PIGButton(LootRollF,{"LEFT", LootRollF.Roll.Slider,"RIGHT",80,0},{50,22},"测试")
	LootRollF.Debug:SetScript("OnClick", function (self)
		ISopenUI(FramePlusfun.RollDebugUI)
	end)
	LootRollF.CZ = PIGButton(LootRollF,{"LEFT", LootRollF.Debug,"RIGHT",40,0},{50,22},"重置")
	LootRollF.CZ:SetScript("OnClick", function (self)
		PIGA["FramePlus"]["RollScale"]=addonTable.Default["FramePlus"]["RollScale"]
		LootRollF.Roll.Slider:PIGSetValue(PIGA["FramePlus"]["RollScale"])
		ISopenUI(FramePlusfun.RollCZ)
	end)
end
LootRollF:HookScript("OnShow", function(self)
	self.Loot:SetChecked(PIGA["FramePlus"]["Loot"])
	if self.Roll then
		if self.Loot.LootMasterErr then self.Loot.LootMasterErr:SetChecked(PIGA["FramePlus"]["LootMasterErr"]) end
		self.Roll:SetChecked(PIGA["FramePlus"]["Roll"])  self.Roll.Slider:PIGSetValue(PIGA["FramePlus"]["RollScale"]) 
	end
end)
--==================================
addonTable.FramePlus = function()
	FramePlusfun.BuffTime()
	FramePlusfun.Skill_QKbut()
	FramePlusfun.UIWidget()
	FramePlusfun.Tracking()
	FramePlusfun.AddonList()
	FramePlusfun.Loot()
	FramePlusfun.LootMasterErr()
	FramePlusfun.Roll()
	FramePlusfun.Merchant()
	FramePlusfun.Friends()
	FramePlusfun.Macro()
	FramePlusfun.Quest()
	FramePlusfun.Skill()
	FramePlusfun.BlizzardUI_Move()
	FramePlusfun.Character_ADD()
	FramePlusfun.Talent()
	FramePlusfun.Character_Shuxing()
end