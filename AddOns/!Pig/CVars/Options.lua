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
local PIGSetFont=Create.PIGSetFont
---
local fuFrame = PIGOptionsList(L["CVAR_TABNAME"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
--
local CVarsF,CVarstabbut =PIGOptionsList_R(RTabFrame,L["CVAR_TABNAME1"],70)
CVarsF:Show()
CVarstabbut:Selected()
----------------------
local function ADD_tishi(fujiF,CVarsV,pianyiX,pianyiY)
	fujiF.tishi = CreateFrame("Frame", nil, fujiF);
	fujiF.tishi:SetSize(28,28);
	fujiF.tishi:SetPoint("LEFT", fujiF.Text, "RIGHT", pianyiX,pianyiY);
	fujiF.tishi.Texture = fujiF.tishi:CreateTexture(nil, "BORDER");
	fujiF.tishi.Texture:SetTexture("interface/common/help-i.blp");
	fujiF.tishi.Texture:SetAllPoints(fujiF.tishi)
	fujiF.tishi:SetScript("OnEnter", function (self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		GameTooltip:AddLine(L["LIB_TIPS"]..": ")
		if CVarsV=="反河蟹" then
			GameTooltip:AddLine("\124cff00ff00此设置需退出战网和WOW客户端重新进入生效!\124r")
		else
			GameTooltip:AddLine("\124cff00ff00此设置需重载界面才能生效!\124r")
		end
		GameTooltip:Show();
	end);
	fujiF.tishi:SetScript("OnLeave", function ()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
end
local function ADD_DownMenu(fujik,min,max,menu,CVarsV,CVarsN,Point,W,rl)
	local xialaibut=PIGDownMenu(fujik,Point,{W,nil})
	xialaibut.t = PIGFontString(xialaibut,{"RIGHT",xialaibut,"LEFT",-4,0},CVarsN);
	function xialaibut:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=min,max,1 do
			local i = tostring(i)
		    info.text, info.arg1 = menu[i], i
		    info.checked = i==GetCVar(CVarsV)
			xialaibut:PIGDownMenu_AddButton(info)
		end 
	end
	function xialaibut:PIGDownMenu_SetValue(value,arg1,arg2)
		xialaibut:PIGDownMenu_SetText(value)
		SetCVar(CVarsV, arg1)
		PIGCloseDropDownMenus()
	end
	xialaibut:HookScript("OnShow", function (self)
		self:PIGDownMenu_SetText(menu[GetCVar(CVarsV)])
	end);
	if rl then
		ADD_tishi(xialaibut,nil,22,0)
	end
	return xialaibut
end
----------
local chaoyuanshijuVVV = {"cameraDistanceMaxZoomFactor","2.6"}
if tocversion<80000 then
	chaoyuanshijuVVV = {"cameraDistanceMaxZoomFactor","4"}
end
local CVarsList1 = {
	--{"常驻显示角色信息","characterFrameCollapsed","1","0","开启后常驻显示角色信息",false},
	{"自动比较装备","alwaysCompareItems","1","0","开启后在查看装备时会自动和身上装备对比",false},
	--{"聊天栏显示职业颜色","chatClassColorOverride","0","1","聊天框发言的玩家姓名会根据职业染色",false},
	{SHOW_BUFF_DURATION_TEXT,"buffDurations","1","0",OPTION_TOOLTIP_SHOW_BUFF_DURATION,false},
	{SHOW_ALL_ENEMY_DEBUFFS_TEXT,"noBuffDebuffFilterOnTarget","1","0",SHOW_ALL_ENEMY_DEBUFFS_TEXT,false},
	{"显示预估治疗量","predictedHealth","1","0","在血量框架上显示预估治疗量",false},
	---
	{MAX_FOLLOW_DIST,chaoyuanshijuVVV[1],chaoyuanshijuVVV[2],GetCVarDefault(chaoyuanshijuVVV[1]),MAX_FOLLOW_DIST,false},
	{ACTION_BUTTON_USE_KEY_DOWN,"ActionButtonUseKeyDown","1","0",OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN,false},
	{FULL_SCREEN_GLOW,"ffxGlow","1","0",OPTION_TOOLTIP_FULL_SCREEN_GLOW,false},
	{DEATH_EFFECT,"ffxDeath","1","0",OPTION_TOOLTIP_DEATH_EFFECT,false},
	{"新版TAB","TargetNearestUseNew","1","0","使用7.2版后的TAB选取目标功能,战斗中不会Tab到战斗外目标,不会Tab到你的角色或镜头看不到的目标。\n关闭后将启用旧版的选取最近目标。",false},
	{"反河蟹","overrideArchive","0","1","恢复某些模型的和谐之前的样子，例如骷髅药水不再是长肉的骷髅",true},
}
if tocversion>100000 then
	table.insert(CVarsList1,9,{CAMERA_FOV,"cameraFov","90",GetCVarDefault("cameraFov"),"启用最大镜头视野范围",false})
end
for i=1,#CVarsList1 do
	local CVarsCB = PIGCheckbutton_R(CVarsF,{CVarsList1[i][1],CVarsList1[i][5]},true,6)
	if CVarsList1[i][6] then
		ADD_tishi(CVarsCB,CVarsList1[i][1],-2,0)
	end
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			SetCVar(CVarsList1[i][2], CVarsList1[i][3])
			if CVarsList1[i][2]==chaoyuanshijuVVV[1] then
				PIGA["CVars"]["MaxZoom"]=true
			end
		else
			SetCVar(CVarsList1[i][2], CVarsList1[i][4])
			if CVarsList1[i][2]==chaoyuanshijuVVV[1] then
				PIGA["CVars"]["MaxZoom"]=false
			end
		end
		if CVarsList1[i][6] then
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	CVarsCB:HookScript("OnShow", function (self)
		if GetCVar(CVarsList1[i][2])==CVarsList1[i][3] then
			self:SetChecked(true);
		end
	end)
end
------
ADD_DownMenu(CVarsF,1,3,{["1"]="默认",["2"]="所有PVP目标",["3"]="仅限玩家"},"TargetPriorityPvp","TAB优先级",{"TOPLEFT",CVarsF,"TOPLEFT",100,-360},130)
---
local tianqiName = {["0"]="小雨",["1"]="中雨",["2"]="大雨",["3"]="暴雨"}
ADD_DownMenu(CVarsF,0,3,tianqiName,"weatherDensity","天气效果",{"TOPLEFT",CVarsF,"TOPLEFT",400,-360},100)
---
local xueyeLVName = {["0"]="无",["1"]="略微",["2"]="少量",["3"]="普通",["4"]="暴力",["5"]="很暴力"}
ADD_DownMenu(CVarsF,0,5,xueyeLVName,"violenceLevel","血液效果",{"TOPLEFT",CVarsF,"TOPLEFT",400,-400},100,true)

---浮动战斗信息====================
local combattextF =PIGOptionsList_R(RTabFrame,FLOATING_COMBATTEXT_LABEL,100)
local combattext1 = {
	{OPTION_TOOLTIP_SHOW_COMBAT_HEALING,"floatingCombatTextCombatHealing","1","0",OPTION_TOOLTIP_SHOW_COMBAT_HEALING,false},
	{OPTION_TOOLTIP_SHOW_DAMAGE,"floatingCombatTextCombatDamage","1","0",OPTION_TOOLTIP_SHOW_DAMAGE,false},
	{"目标伤害旧版弹出方式","floatingCombatTextCombatDamageDirectionalScale","0","1","开启后伤害弹出数字将会从目标上方弹出，而不是发散样式",false},
}
for i=1,#combattext1 do
	local CVarsCB = PIGCheckbutton_R(combattextF,{combattext1[i][1],combattext1[i][5]})
	if combattext1[i][6] then
		ADD_tishi(CVarsCB,combattext1[i][1],-2,0)
	end
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			SetCVar(combattext1[i][2], combattext1[i][3])
			if combattext1[i][2]==chaoyuanshijuVVV[1] then
				PIGA["CVars"]["MaxZoom"]=true
			end
		else
			SetCVar(combattext1[i][2], combattext1[i][4])
			if combattext1[i][2]==chaoyuanshijuVVV[1] then
				PIGA["CVars"]["MaxZoom"]=false
			end
		end
		if combattext1[i][6] then
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	CVarsCB:HookScript("OnShow", function (self)
		if GetCVar(combattext1[i][2])==combattext1[i][3] then
			self:SetChecked(true);
		end
	end)
end
local combattext2 = {
	{HIDE..COMBAT_SELF..FLOATING_COMBATTEXT_LABEL,nil,"HitIndicator",false,},
}
for i=1,#combattext2 do
	local CVarsCB = PIGCheckbutton_R(combattextF,{combattext2[i][1],combattext2[i][2] or combattext2[i][1]})
	if combattext2[i][6] then
		ADD_tishi(CVarsCB,combattext2[i][1],-2,0)
	end
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CVars"][combattext2[i][3]]=true
			combattextF.HitIndicatorHide=true
		else
			PIGA["CVars"][combattext2[i][3]]=false
			combattextF.HitIndicatorHide=false
		end
		if combattext2[i][4] then
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	CVarsCB:HookScript("OnShow", function (self)
		self:SetChecked(PIGA["CVars"][combattext2[i][3]]);
	end)
end
hooksecurefunc("CombatFeedback_OnCombatEvent", function(self)
	if combattextF.HitIndicatorHide then
		self.feedbackText:Hide()
	end
end)
combattextF.RF=PIGFrame(combattextF,{"TOPLEFT",combattextF,"TOPLEFT",0,-260})
combattextF.RF:SetPoint("BOTTOMRIGHT",combattextF,"BOTTOMRIGHT",0,0);
combattextF.RF.OPENcombattext = PIGCheckbutton(combattextF.RF,{"TOPLEFT",combattextF.RF,"TOPLEFT",20,-20},{SHOW_COMBAT_TEXT_TEXT,OPTION_TOOLTIP_SHOW_COMBAT_TEXT})
combattextF.RF.OPENcombattext:SetScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("enableFloatingCombatText", "1")
	else
		SetCVar("enableFloatingCombatText", "0")
	end
end)
--浮动方式
local fudongModeName = {["1"]=COMBAT_TEXT_SCROLL_UP,["2"]=COMBAT_TEXT_SCROLL_DOWN,["3"]=COMBAT_TEXT_SCROLL_ARC}
ADD_DownMenu(combattextF.RF,1,3,fudongModeName,"floatingCombatTextFloatMode",COMBAT_TEXT_FLOAT_MODE_LABEL,{"TOPLEFT",combattextF.RF,"TOPLEFT",170,-60},100)
---
combattextF.RF.fudongScale = PIGSlider(combattextF.RF,{"TOPLEFT",combattextF.RF,"TOPLEFT",170,-100},{1,3,0.1,{["Right"]="%"}})
combattextF.RF.fudongScale.t = PIGFontString(combattextF.RF.fudongScale,{"RIGHT",combattextF.RF.fudongScale,"LEFT",-4,0},FLOATING_COMBATTEXT_LABEL.."缩放");
combattextF.RF.fudongScale.Slider:HookScript("OnValueChanged", function(self, arg1)
	SetCVar("WorldTextScale",arg1)
end)
combattextF.RF:HookScript("OnShow", function (self)
	self.fudongScale:PIGSetValue(GetCVar("WorldTextScale"))
	self.OPENcombattext:SetChecked(GetCVar("enableFloatingCombatText")=="1");
end);
---姓名板
local xingmingbanF =PIGOptionsList_R(RTabFrame,L["CVAR_TABNAME2"],70)
local xingmingList = {
	{SHOW..SHOW_TARGET_CASTBAR_IN_V_KEY,"nameplateShowOnlyNames","0","1",nil,true},
	{UNIT_NAME_FRIENDLY..SHOW_TARGET_CASTBAR_IN_V_KEY..SHOW_CLASS_COLOR,"ShowClassColorInFriendlyNameplate","1","0",nil,true},
	{COMBATLOG_FILTER_STRING_HOSTILE_PLAYERS..SHOW_TARGET_CASTBAR_IN_V_KEY..SHOW_CLASS_COLOR,"ShowClassColorInNameplate","1","0",nil,true},
	{TARGET..SHOW_TARGET_CASTBAR_IN_V_KEY..LOCK.."在屏幕内","clampTargetNameplateToScreen","1","0",nil,false},
}
for i=1,#xingmingList do
	local CVarsCB = PIGCheckbutton_R(xingmingbanF,{xingmingList[i][1],xingmingList[i][5] or xingmingList[i][1]},true)
	if xingmingList[i][6] then
		ADD_tishi(CVarsCB,xingmingList[i][1],-2,0)
	end
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			SetCVar(xingmingList[i][2], xingmingList[i][3])
		else
			SetCVar(xingmingList[i][2], xingmingList[i][4])
		end
		if xingmingList[i][6] then
			Pig_Options_RLtishi_UI:Show()
		end
	end)
	CVarsCB:HookScript("OnShow", function (self)
		if GetCVar(xingmingList[i][2])==xingmingList[i][3] then
			self:SetChecked(true);
		end
	end)
end
xingmingbanF.nameplatebiaoti = PIGFontString(xingmingbanF,{"TOPLEFT",xingmingbanF,"TOPLEFT",40,-170},"姓名板锁定在屏幕内显示距离");
xingmingbanF.nameplateTop=PIGSlider(xingmingbanF,{"TOPLEFT",xingmingbanF.nameplatebiaoti,"BOTTOMLEFT",70,-10},{0,0.2,0.01,{["Right"]="%d%%屏幕尺寸"}})
xingmingbanF.nameplateTop.t = PIGFontString(xingmingbanF,{"RIGHT",xingmingbanF.nameplateTop,"LEFT",-4,0},"顶部距离");
xingmingbanF.nameplateTop.Slider:HookScript("OnValueChanged", function(self, arg1)
	SetCVar("nameplateOtherTopInset",arg1)
end)
xingmingbanF.nameplateTop:HookScript("OnShow", function (self)
	self:PIGSetValue(GetCVar("nameplateOtherTopInset"))
end);
xingmingbanF.nameplateBottom=PIGSlider(xingmingbanF,{"TOPLEFT",xingmingbanF.nameplateTop,"BOTTOMLEFT",0,0},{0,0.2,0.01,{["Right"]="%d%%屏幕尺寸"}})
xingmingbanF.nameplateBottom.t = PIGFontString(xingmingbanF,{"RIGHT",xingmingbanF.nameplateBottom,"LEFT",-4,0},"底部距离");
xingmingbanF.nameplateBottom.Slider:HookScript("OnValueChanged", function(self, arg1)
	SetCVar("nameplateOtherBottomInset",arg1)
end)
xingmingbanF.nameplateBottom:HookScript("OnShow", function (self)
	self:PIGSetValue(GetCVar("nameplateOtherBottomInset"))
end);

--自身高亮
local gaoliangF =PIGOptionsList_R(RTabFrame,L["CVAR_TABNAME3"],90)
local gaoliangmoshiName = {["-1"]=CLOSE,["0"]=SELF_HIGHLIGHT_MODE_CIRCLE,["1"]=SELF_HIGHLIGHT_MODE_CIRCLE_AND_OUTLINE,["2"]=SELF_HIGHLIGHT_MODE_OUTLINE}
ADD_DownMenu(gaoliangF,-1,2,gaoliangmoshiName,"findYourselfMode","高亮模式",{"TOPLEFT",gaoliangF,"TOPLEFT",90,-20},150)
---
local gaoliangList = {
	{SELF_HIGHLIGHT_ON,"findYourselfAnywhere","1","0",SELF_HIGHLIGHT_ON},
	{OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG_COMBAT,"findYourselfAnywhereOnlyInCombat","1","0",OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG_COMBAT},
	{OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_RAID,"findYourselfInRaid","1","0",OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_RAID},
	{OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_RAID_COMBAT,"findYourselfInRaidOnlyInCombat","1","0",OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_RAID_COMBAT},
	{OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG,"findYourselfInBG","1","0",OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG},
	{OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG_COMBAT,"findYourselfInBGOnlyInCombat","1","0",OPTION_TOOLTIP_SELF_HIGHLIGHT_IN_BG_COMBAT},	
}
for i=1,#gaoliangList do
	local CVarsCB = PIGCheckbutton(gaoliangF,nil,{gaoliangList[i][1],gaoliangList[i][5]})
	if i==1 then
		CVarsCB:SetPoint("TOPLEFT",gaoliangF,"TOPLEFT",50,-60);
	else
		if i==4 or i==6 then
			CVarsCB:SetPoint("TOPLEFT",gaoliangF,"TOPLEFT",50+40,-40*i-20);
		else
			CVarsCB:SetPoint("TOPLEFT",gaoliangF,"TOPLEFT",50+20,-40*i-20);
		end
	end
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			SetCVar(gaoliangList[i][2], gaoliangList[i][3])
		else
			SetCVar(gaoliangList[i][2], gaoliangList[i][4])
		end
	end);
	CVarsCB:HookScript("OnShow", function (self)
		if GetCVar(gaoliangList[i][2])==gaoliangList[i][3] then
			self:SetChecked(true);
		end
	end);
end
-----
local gaojiF =PIGOptionsList_R(RTabFrame,L["CVAR_TABNAME4"],60)
local gaojiList = {
	{"同步设置到服务器","synchronizeSettings","1","0",false},--即将删除
	{"同步宏到服务器","synchronizeMacros","1","0",false},--即将删除
	{"同步键位到服务器","synchronizeBindings","1","0",true},
	{"同步CVar到服务器","synchronizeConfig","1","0",true},
	{"同步聊天布局到服务器","synchronizeChatFrames","1","0",true},
}
for i=1,#gaojiList do
	local CVarsCB = PIGCheckbutton_R(gaojiF,{gaojiList[i][1],gaojiList[i][1]},true)
	CVarsCB:SetScript("OnClick", function (self)
		if self:GetChecked() then
			SetCVar(gaojiList[i][2], gaojiList[i][3])
		else
			SetCVar(gaojiList[i][2], gaojiList[i][4])
		end
	end);
	CVarsCB:HookScript("OnShow", function (self)
		if GetCVar(gaojiList[i][2])==gaojiList[i][3] then
			self:SetChecked(true);
		else
			self:SetChecked(false);
		end
	end);
	if not gaojiList[i][5] then
		CVarsCB.deltxt = Create.PIGFontString(CVarsCB,{"LEFT",CVarsCB.Text,"RIGHT",20,0},"此CVars将在后续版本被删除")
	end
end
gaojiF.CZCVarsSET = CreateFrame("EditBox", nil, gaojiF, "InputBoxInstructionsTemplate");
gaojiF.CZCVarsSET.txt = Create.PIGFontString(gaojiF.CZCVarsSET,{"RIGHT",gaojiF.CZCVarsSET,"LEFT",-6,0},RESET.."CVars","OUTLINE",15)
gaojiF.CZCVarsSET:SetSize(200,30);
gaojiF.CZCVarsSET:SetPoint("BOTTOMLEFT",gaojiF,"BOTTOMLEFT",100,20);
PIGSetFont(gaojiF.CZCVarsSET, 16, "OUTLINE")
gaojiF.CZCVarsSET:SetAutoFocus(false);
gaojiF.CZCVarsSET:SetText("/console cvar_default");
function gaojiF.CZCVarsSET:SetTextpig()
	self:SetText("/console cvar_default");
end
gaojiF.CZCVarsSET:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
gaojiF.CZCVarsSET:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
--==============================
addonTable.CVars = function()
	local function chaoyuanshijujihuo()
		SetCVar(chaoyuanshijuVVV[1], chaoyuanshijuVVV[2])
	end
	if PIGA["CVars"]["MaxZoom"] then
		C_Timer.After(3, chaoyuanshijujihuo)
	end
	combattextF.HitIndicatorHide=PIGA["CVars"]["HitIndicator"]
end