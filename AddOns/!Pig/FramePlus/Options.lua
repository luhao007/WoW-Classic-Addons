local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
local PIGModCheckbutton=Create.PIGModCheckbutton
--
local Fun=addonTable.Fun
---
local fuFrame = PIGOptionsList(L["FRAMEP_TABNAME"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
--
local FramePlusfun={}
addonTable.FramePlusfun=FramePlusfun
--
local FramePlusF,FramePlustabbut =PIGOptionsList_R(RTabFrame,L["FRAMEP_TABNAME1"],90)
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
		Pig_Options_RLtishi_UI:Show()
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
		Pig_Options_RLtishi_UI:Show()
	end
end);
FramePlusF.Merchant = PIGCheckbutton_R(FramePlusF,{"商人界面扩展","扩展商人界面为两列"})
FramePlusF.Merchant:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Merchant"]=true;
		FramePlusfun.Merchant()
	else
		PIGA["FramePlus"]["Merchant"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
FramePlusF.Friends = PIGCheckbutton_R(FramePlusF,{"好友界面扩展","扩展好友界面为两列"})
FramePlusF.Friends:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Friends"]=true;
		FramePlusfun.Friends()
	else
		PIGA["FramePlus"]["Friends"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
FramePlusF.Loot = PIGCheckbutton_R(FramePlusF,{SLASH_TEXTTOSPEECH_LOOT..UIOPTIONS_MENU.."扩展",SLASH_TEXTTOSPEECH_LOOT..UIOPTIONS_MENU.."物品显示在一页，并且可以通报"})
FramePlusF.Loot:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Loot"]=true;
		FramePlusfun.Loot()
	else
		PIGA["FramePlus"]["Loot"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
FramePlusF.Roll = PIGCheckbutton_R(FramePlusF,{LOOT_ROLL..UIOPTIONS_MENU.."扩展","合并"..LOOT_ROLL.."物品到一起，并且可以移动"})
FramePlusF.Roll:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Roll"]=true;
		FramePlusfun.Roll()
	else
		PIGA["FramePlus"]["Roll"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
---
if tocversion<100000 then
	FramePlusF.Quest = PIGCheckbutton_R(FramePlusF,{"任务界面扩展",""})
	if tocversion<30000 then
		FramePlusF.Quest.tooltip= "扩展任务界面为两列,左边任务列表，右边任务详情,显示任务等级";
	else
		FramePlusF.Quest.tooltip= "任务列表显示任务等级";
	end
	FramePlusF.Quest:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Quest"]=true;
			FramePlusfun.Quest()
		else
			PIGA["FramePlus"]["Quest"]=false
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	--
	FramePlusF.Skill = PIGCheckbutton_R(FramePlusF,{"专业界面扩展","扩展专业技能界面为两列；左边配方列表，右边配方详情"})
	FramePlusF.Skill:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Skill"]=true;
			FramePlusfun.Skill()
		else
			PIGA["FramePlus"]["Skill"]=false
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	
	FramePlusF.Talent = PIGCheckbutton_R(FramePlusF,{"天赋界面扩展"," "})
	if tocversion<30000 then
		FramePlusF.Talent.tooltip= "在一页显示三系天赋";
	else
		FramePlusF.Talent.tooltip= "在一页显示三系天赋和雕文";
	end
	FramePlusF.Talent:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["FramePlus"]["Talent"]=true;
			FramePlusfun.Talent()
		else
			PIGA["FramePlus"]["Talent"]=false
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	if tocversion<20000 then
		local tooltip = "整合追踪类技能，点击小地图追踪技能按钮选择其他追踪技能！";
		FramePlusF.Zhuizong = PIGCheckbutton_R(FramePlusF,{"整合追踪技能",tooltip})
		FramePlusF.Zhuizong:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["FramePlus"]["Zhuizong"]=true
				FramePlusfun.Zhuizong()
			else
				PIGA["FramePlus"]["Zhuizong"]=false
				Pig_Options_RLtishi_UI:Show()
			end
		end)
	end
end
--
FramePlusF.yidong = PIGFrame(FramePlusF,{"BOTTOMLEFT",FramePlusF,"BOTTOMLEFT",0,0})
FramePlusF.yidong:PIGSetBackdrop()
FramePlusF.yidong:SetHeight(40)
FramePlusF.yidong:SetPoint("BOTTOMRIGHT",FramePlusF,"BOTTOMRIGHT",0,0);

FramePlusF.yidong.BlizzardUI_Move = PIGCheckbutton(FramePlusF.yidong,{"LEFT",FramePlusF.yidong,"LEFT",20,0},{"解锁(移动)系统界面","解锁系统界面，使其可以:\n1.移动:拖动界面标题栏移动\n2.缩放:在需要缩放界面按住Ctrl+Alt滚动鼠标滚轮"})
FramePlusF.yidong.BlizzardUI_Move:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["BlizzardUI_Move"]=true;
		FramePlusF.yidongun.BlizzardUI_Move()
	else
		PIGA["FramePlus"]["BlizzardUI_Move"]=false
		Pig_Options_RLtishi_UI:Show()
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
FramePlusF.yidong.BlizzardUI_Move.CZ = PIGButton(FramePlusF.yidong,{"LEFT",FramePlusF.yidong.BlizzardUI_Move.Save.Text,"RIGHT",40,0},{90,22},"重置UI数据")
FramePlusF.yidong.BlizzardUI_Move.CZ:SetScript("OnClick", function ()
	PIGA["WowUI"]={}
	PIG_print("已重置UI位置和缩放比例数据")
end);
--
FramePlusF:HookScript("OnShow", function(self)
	self.Loot:SetChecked(PIGA["FramePlus"]["Loot"])
	self.Roll:SetChecked(PIGA["FramePlus"]["Roll"])
	self.BuffTime:SetChecked(PIGA["FramePlus"]["BuffTime"])
	self.Skill_QKbut:SetChecked(PIGA["FramePlus"]["Skill_QKbut"])
	self.Merchant:SetChecked(PIGA["FramePlus"]["Merchant"])
	self.Friends:SetChecked(PIGA["FramePlus"]["Friends"])
	if tocversion<100000 then
		self.Quest:SetChecked(PIGA["FramePlus"]["Quest"])
		self.Skill:SetChecked(PIGA["FramePlus"]["Skill"])
		self.Talent:SetChecked(PIGA["FramePlus"]["Talent"])
	end
	self.yidong.BlizzardUI_Move:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move"])
	self.yidong.BlizzardUI_Move.Save:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move_Save"])
	if tocversion<20000 then
		self.Zhuizong:SetChecked(PIGA["FramePlus"]["Zhuizong"])
	end
end)
--角色信息界面
local CharacterF =PIGOptionsList_R(RTabFrame,L["FRAMEP_TABNAME2"],90)
---
CharacterF.Character_naijiu = PIGCheckbutton_R(CharacterF,{DISPLAY..EQUIPSET_EQUIP..DURABILITY,"角色界面显示装备耐久剩余值"})
CharacterF.Character_naijiu:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_naijiu"]=true;
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_naijiu"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
CharacterF.Character_ItemLevel = PIGCheckbutton_R(CharacterF,{DISPLAY..STAT_AVERAGE_ITEM_LEVEL,DISPLAY..STAT_AVERAGE_ITEM_LEVEL.."，背包银行物品需要显示装等请在背包内设置"})
CharacterF.Character_ItemLevel:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemLevel"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemLevel"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
CharacterF.Character_ItemColor = PIGCheckbutton_R(CharacterF,{DISPLAY_BORDERS..PET_BATTLE_STAT_QUALITY,"根据品质染色装备边框"})
CharacterF.Character_ItemColor:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemColor"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemColor"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)
CharacterF.Character_ItemList = PIGCheckbutton_R(CharacterF,{DISPLAY.."装备列表","在角色信息界面右侧显示装备列表"})
CharacterF.Character_ItemList:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["Character_ItemList"]=true
		FramePlusfun.Character_ADD()
	else
		PIGA["FramePlus"]["Character_ItemList"]=false
		Pig_Options_RLtishi_UI:Show()
	end
end)

--角色信息UI扩展
local newText=Fun.Delmaohaobiaodain(REPAIR_COST)
if tocversion<40000 then
	CharacterF.Shuxingtishi=CHARACTER_INFO.."扩展("..PAPERDOLL_SIDEBAR_STATS.."/"..EQUIPMENT_MANAGER.."/"..newText.."/"..COMBAT_RATING_NAME6.."说明"..")"
elseif tocversion<50000 then
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
		Pig_Options_RLtishi_UI:Show()
	end
	QuickButUI.ButList[5]()
end)
CharacterF:HookScript("OnShow", function(self)
	self.Character_naijiu:SetChecked(PIGA["FramePlus"]["Character_naijiu"])
	self.Character_ItemLevel:SetChecked(PIGA["FramePlus"]["Character_ItemLevel"])
	self.Character_ItemColor:SetChecked(PIGA["FramePlus"]["Character_ItemColor"])
	self.Character_ItemList:SetChecked(PIGA["FramePlus"]["Character_ItemList"])
	self.Character_Shuxing:SetChecked(PIGA["FramePlus"]["Character_Shuxing"])
end)
--
local TooltipF =PIGOptionsList_R(RTabFrame,L["FRAMEP_TABNAME3"],90)
local ItemLeveltishi = {"显示物品等级","在鼠标提示上显示物品的物品等级"}
TooltipF.ItemLevel = PIGCheckbutton_R(TooltipF,ItemLeveltishi)
TooltipF.ItemLevel:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Tooltip"]["ItemLevel"]=true;			
	else
		PIGA["Tooltip"]["ItemLevel"]=false;
	end
end);
TooltipF.ItemMaxCount = PIGCheckbutton_R(TooltipF,{"显示物品最大堆叠数","在鼠标提示上显示物品最大堆叠数"})
TooltipF.ItemMaxCount:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Tooltip"]["ItemMaxCount"]=true;			
	else
		PIGA["Tooltip"]["ItemMaxCount"]=false;
	end
end);
TooltipF.IDinfo = PIGCheckbutton_R(TooltipF,{"显示物品/技能ID","在鼠标提示上显示物品/技能ID,版本归属/BUFF来源"})
TooltipF.IDinfo:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Tooltip"]["IDinfo"]=true;			
	else
		PIGA["Tooltip"]["IDinfo"]=false;
	end
end);
TooltipF.ItemSell = PIGCheckbutton_R(TooltipF,{"显示物品售价","在鼠标提示上显示物品售价"})
TooltipF.ItemSell:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Tooltip"]["ItemSell"]=true;			
	else
		PIGA["Tooltip"]["ItemSell"]=false;
	end
	FramePlusfun.Tooltip_ItemSell()
end);
TooltipF:HookScript("OnShow", function(self)
	self.ItemLevel:SetChecked(PIGA["Tooltip"]["ItemLevel"])
	self.ItemMaxCount:SetChecked(PIGA["Tooltip"]["ItemMaxCount"])
	self.IDinfo:SetChecked(PIGA["Tooltip"]["IDinfo"])
	self.ItemSell:SetChecked(PIGA["Tooltip"]["ItemSell"])
end)
--==================================
addonTable.FramePlus = function()
	FramePlusfun.BuffTime()
	FramePlusfun.Loot()
	FramePlusfun.Roll()
	FramePlusfun.Merchant()
	FramePlusfun.Friends()
	FramePlusfun.Quest()
	FramePlusfun.Skill_QKbut()
	FramePlusfun.Skill()
	FramePlusfun.BlizzardUI_Move()
	FramePlusfun.Character_ADD()
	if tocversion<40000 then
		FramePlusfun.Talent()
	end
	FramePlusfun.Character_Shuxing()
	if tocversion<20000 then
		FramePlusfun.Zhuizong()
	end
	FramePlusfun.Tooltip()
end