local _, addonTable = ...;
---
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGDownMenu=Create.PIGDownMenu
local PIGFontString=Create.PIGFontString
local PIGButton = Create.PIGButton
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
---
local PigLayoutFun=addonTable.PigLayoutFun
local RTabFrame =PigLayoutFun.RTabFrame

----
local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,GENERAL,90)
fujiF:Show()
fujiBut:Selected()
----
function PigLayoutFun.Options_Mode()
fujiF.FontMiaobianT = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-20},"PIG布局元素字体效果");
local MiaobianList={"NORMAL","OUTLINE","THICKOUTLINE","MONOCHROME","MONOCHROMEOUTLINE"}
fujiF.FontMiaobian=PIGDownMenu(fujiF,{"LEFT",fujiF.FontMiaobianT,"RIGHT",4,0},{210})
function fujiF.FontMiaobian:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#MiaobianList,1 do
	    info.text, info.arg1 = MiaobianList[i], MiaobianList[i]
	    if MiaobianList[i]=="NORMAL" and not PIGA["PigLayout"]["TopBar"]["FontMiaobian"] then
			info.checked =true
	    else
	    	info.checked = MiaobianList[i]==PIGA["PigLayout"]["TopBar"]["FontMiaobian"]
	    end
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.FontMiaobian:PIGDownMenu_SetValue(value,arg1,arg2)
	self:PIGDownMenu_SetText(value)
	if value=="NORMAL" then
		PIGA["PigLayout"]["TopBar"]["FontMiaobian"]=nil
	else
		PIGA["PigLayout"]["TopBar"]["FontMiaobian"]=value
	end
	PIGCloseDropDownMenus()
	PIG_OptionsUI.RLUI:Show()
end
----
fujiF.MoveF = PIGFrame(fujiF,{"BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,60})
fujiF.MoveF:PIGSetBackdrop(0)
fujiF.MoveF:SetHeight(60)
fujiF.MoveF:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
fujiF.MoveF.BlizzardUI_Move = PIGCheckbutton(fujiF.MoveF,{"LEFT",fujiF.MoveF,"LEFT",20,0},{"解锁(移动)系统界面","解锁系统界面，使其可以:\n1.移动:拖动界面标题栏移动\n2.缩放:在需要缩放界面按住Ctrl+Alt滚动鼠标滚轮"})
fujiF.MoveF.BlizzardUI_Move:SetScript("OnClick", function (self)
	if InCombatLockdown() then self:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move"]) PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT,"R") return end
	if self:GetChecked() then
		PIGA["FramePlus"]["BlizzardUI_Move"]=true;
		fujiFun.BlizzardUI_Move()
	else
		PIGA["FramePlus"]["BlizzardUI_Move"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
fujiF.MoveF.BlizzardUI_Move.Save = PIGCheckbutton(fujiF.MoveF,{"LEFT",fujiF.MoveF.BlizzardUI_Move.Text,"RIGHT",40,0},{"保存移动后位置","保存移动后位置"})
fujiF.MoveF.BlizzardUI_Move.Save:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["BlizzardUI_Move_Save"]=true	
	else
		PIGA["FramePlus"]["BlizzardUI_Move_Save"]=false
	end
end);
PigLayoutFun.BlizzardUI_Move()
--
fujiF.UIWidget = PIGFrame(fujiF,{"BOTTOMLEFT",fujiF.MoveF,"TOPLEFT",0,-1})
fujiF.UIWidget:PIGSetBackdrop(0)
fujiF.UIWidget:SetHeight(60)
fujiF.UIWidget:SetPoint("BOTTOMRIGHT",fujiF,"TOPRIGHT",0,-1);
fujiF.UIWidget.Open = PIGCheckbutton(fujiF.UIWidget,{"LEFT",fujiF.UIWidget,"LEFT",20,0},{"移动小部件","移动屏幕中上部的小部件(占塔/战场积分面板)"})
fujiF.UIWidget.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["FramePlus"]["UIWidget"]=true;
		fujiFun.UIWidget()
	else
		PIGA["FramePlus"]["UIWidget"]=false
		PIG_OptionsUI.RLUI:Show()
	end
end);
fujiF.UIWidget.pianyiX = PIGSlider(fujiF.UIWidget,{"LEFT",fujiF.UIWidget.Open.Text,"RIGHT",10,0},{-700,700,1,{["Right"]="X偏移%s"}})
fujiF.UIWidget.pianyiX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["FramePlus"]["UIWidgetPointX"]=arg1;
	fujiFun.UIWidget()
end)
fujiF.UIWidget.pianyiY = PIGSlider(fujiF.UIWidget,{"LEFT",fujiF.UIWidget.pianyiX,"RIGHT",80,0},{-500,15,1,{["Right"]="Y偏移%s"}})
fujiF.UIWidget.pianyiY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["FramePlus"]["UIWidgetPointY"]=arg1
	PigLayoutFun.UIWidget()
end)
function PigLayoutFun.UIWidget()
	if not PIGA["FramePlus"]["UIWidget"] then return end
	UIWidgetTopCenterContainerFrame:SetPoint("TOP", 0+PIGA["FramePlus"]["UIWidgetPointX"], -15+PIGA["FramePlus"]["UIWidgetPointY"]);
end
PigLayoutFun.UIWidget()
--
fujiF:HookScript("OnShow", function (self)
	self.FontMiaobian:PIGDownMenu_SetText(PIGA["PigLayout"]["TopBar"]["FontMiaobian"] or "NORMAL")
	self.MoveF.BlizzardUI_Move:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move"])
	self.MoveF.BlizzardUI_Move.Save:SetChecked(PIGA["FramePlus"]["BlizzardUI_Move_Save"])
	self.UIWidget.Open:SetChecked(PIGA["FramePlus"]["UIWidget"])
	self.UIWidget.pianyiX:PIGSetValue(PIGA["FramePlus"]["UIWidgetPointX"])
	self.UIWidget.pianyiY:PIGSetValue(PIGA["FramePlus"]["UIWidgetPointY"])
end);
--

fujiF.CZ = PIGButton(fujiF,{"BOTTOMLEFT",fujiF,"BOTTOMLEFT",20,20},{140,24},"重置桌面元素位置")
fujiF.CZ:SetScript("OnClick", function ()
	PIGA["Pig_UI"]=addonTable.Default["Pig_UI"]
	PIGA["Blizzard_UI"]=addonTable.Default["Blizzard_UI"]
	PIGA_Per["Pig_UI"]=addonTable.Default_Per["Pig_UI"]
	Create.PIG_SetPointALL()
	PIG_print("已重置桌面元素位置和缩放数据")
end);
end