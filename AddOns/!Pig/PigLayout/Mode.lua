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
local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,L["LIB_LAYOUT"]..MODE,90)
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
fujiF:HookScript("OnShow", function (self)
	self.FontMiaobian:PIGDownMenu_SetText(PIGA["PigLayout"]["TopBar"]["FontMiaobian"] or "NORMAL")
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