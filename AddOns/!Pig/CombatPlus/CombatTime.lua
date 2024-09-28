local _, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
--
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
local PIGEnter=Create.PIGEnter
--
local CombatPlusfun=addonTable.CombatPlusfun
---------------
local WWW,HHH = 60,24
local CombatTimeweizhi={"TOP", UIParent, "TOP", 0, -70}
local PIGCombatTime = PIGFrame(UIParent,CombatTimeweizhi,{WWW,HHH},"PIGCombatTime_UI")
PIGCombatTime:PIGSetMovable()
PIGCombatTime:Hide()
PIGCombatTime.zongjishi = 0
PIGCombatTime.dangqian = 0
--
local caijie_B,caijie_R = {0,0.248,0.68,0.90},{0,0.248,0.40,0.63}
local function CZ_jisuqi()
	PIGCombatTime.zongjishi = 0
	PIGCombatTime.dangqian = 0
	PIGCombatTime.T0:SetText("00:00");
	PIGCombatTime.T1:SetText("00:00");
end
local ChatFrame_TimeBreakDown=ChatFrame_TimeBreakDown
local SetFormattedText=SetFormattedText
local function Update_Time(elapsed)
	PIGCombatTime.zongjishi  =  PIGCombatTime.zongjishi  +  elapsed
	local d, h, m, s = ChatFrame_TimeBreakDown(PIGCombatTime.zongjishi);
	PIGCombatTime.dangqian  =  PIGCombatTime.dangqian  +  elapsed
	local dd, dh, dm, ds = ChatFrame_TimeBreakDown(PIGCombatTime.dangqian);
	if PIGCombatTime.zongjishi>3600 then
		if PIGCombatTime.T0:IsShown() then
			PIGCombatTime:SetWidth((WWW+20)*2+10)
		else
			PIGCombatTime:SetWidth(WWW+24)
		end
		PIGCombatTime.T0:SetFormattedText("%02d:%02d:%02d", h, m, s);
		PIGCombatTime.T1:SetFormattedText("%02d:%02d:%02d", dh, dm, ds);
	else
		if PIGCombatTime.T0:IsShown() then
			PIGCombatTime:SetWidth(WWW*2+10)
		else
			PIGCombatTime:SetWidth(WWW)
		end
		PIGCombatTime.T0:SetFormattedText("%02d:%02d", m, s);
		PIGCombatTime.T1:SetFormattedText("%02d:%02d", dm, ds);
	end
end	
local function CZ_weizhi()
	local _, instanceType = GetInstanceInfo()
	if instanceType=="none" then
		PIGCombatTime.line:Hide()
		PIGCombatTime.T0:Hide()
		PIGCombatTime.T1:ClearAllPoints();
		PIGCombatTime.T1:SetPoint("CENTER",PIGCombatTime,"CENTER",0,0);
	else
		PIGCombatTime.line:Show()
		PIGCombatTime.T0:Show()
		PIGCombatTime.T1:ClearAllPoints();
		PIGCombatTime.T1:SetPoint("LEFT",PIGCombatTime,"CENTER",8,0);
	end
	CZ_jisuqi()
	Update_Time(0)
end
local function SetBGHide()
	if PIGA["CombatPlus"]["CombatTime"]["Beijing"]==1 then
		PIGCombatTime.bg:Show()
		PIGCombatTime:SetBackdropColor(0, 0, 0, 0);
		PIGCombatTime:SetBackdropBorderColor(0, 0, 0, 0);
	elseif PIGA["CombatPlus"]["CombatTime"]["Beijing"]==2 then
		PIGCombatTime.bg:Hide()
		local BackdropColor=Create.BackdropColor
		local BackdropBorderColor=Create.BackdropBorderColor
		PIGCombatTime:SetBackdropColor(BackdropColor[1], BackdropColor[2], BackdropColor[3], BackdropColor[4]);
		PIGCombatTime:SetBackdropBorderColor(BackdropBorderColor[1], BackdropBorderColor[2], BackdropBorderColor[3], BackdropBorderColor[4]);
	elseif PIGA["CombatPlus"]["CombatTime"]["Beijing"]==3 then
		PIGCombatTime.bg:Hide()
		PIGCombatTime:SetBackdropColor(0, 0, 0, 0);
		PIGCombatTime:SetBackdropBorderColor(0, 0, 0, 0);
	end
end
local function SetLock()
	if PIGA["CombatPlus"]["CombatTime"]["Lock"] then
		PIGCombatTime:RegisterForDrag("")
	else
		PIGCombatTime:RegisterForDrag("LeftButton")
	end
end
function CombatPlusfun.CombatTime()
	if not PIGA["CombatPlus"]["CombatTime"]["Open"] then return end
	if PIGCombatTime.yizairu then return end
	PIGCombatTime:SetFrameStrata("LOW")
	PIGCombatTime:Show()
	PIGCombatTime:PIGSetBackdrop()
	PIGCombatTime.bg = PIGCombatTime:CreateTexture(nil, "BORDER");
	PIGCombatTime.bg:SetTexture("interface/helpframe/cs_helptextures.blp");--	interface/helpframe/helpbuttons.blp
	PIGCombatTime.bg:SetTexCoord(caijie_B[1],caijie_B[2],caijie_B[3],caijie_B[4]);--blue
	PIGCombatTime.bg:SetPoint("TOPLEFT",PIGCombatTime,"TOPLEFT",-8,4);
	PIGCombatTime.bg:SetPoint("BOTTOMRIGHT",PIGCombatTime,"BOTTOMRIGHT",8,-4);
	PIGCombatTime.bg:SetAlpha(0.6);
	PIGCombatTime:SetScale(PIGA["CombatPlus"]["CombatTime"]["Scale"])
	SetBGHide()
	SetLock()
	PIGCombatTime.line = PIGLine(PIGCombatTime,"C")
	PIGCombatTime.line:SetAlpha(0.3)
	PIGCombatTime.line:Hide()
	PIGCombatTime.T0 = PIGFontString(PIGCombatTime,{"RIGHT",PIGCombatTime,"CENTER",-8,0},"00:00",PIGA["CombatPlus"]["CombatTime"]["Miaobian"],16)
	PIGCombatTime.T0:SetTextColor(0, 1, 0, 0.8);
	PIGCombatTime.T0:Hide()
	PIGCombatTime.T1 = PIGFontString(PIGCombatTime,{"RIGHT",PIGCombatTime,"CENTER",-8,0},"00:00",PIGA["CombatPlus"]["CombatTime"]["Miaobian"],16)
	PIGCombatTime.T1:SetTextColor(0, 1, 0, 0.8);
	PIGEnter(PIGCombatTime,KEY_BUTTON1.."拖动,"..KEY_BUTTON2.."重置计时")

	PIGCombatTime.UpdateUI = CreateFrame("Frame")
	PIGCombatTime.UpdateUI:Hide()
	PIGCombatTime.UpdateUI:HookScript("OnUpdate", function (self,elapsed)
		Update_Time(elapsed)
	end)
	PIGCombatTime:SetScript("OnMouseUp", function(self,button)
		if button=="RightButton" then
			CZ_jisuqi()
		end
	end)
	PIGCombatTime:HookScript("OnEvent", function (self,event,arg1,arg2)
		if event=="PLAYER_REGEN_DISABLED" then
			self.UpdateUI:Show()
			self.bg:SetTexCoord(caijie_R[1],caijie_R[2],caijie_R[3],caijie_R[4]);--red
			self.T0:SetTextColor(1, 1, 0, 0.8);
			self.T1:SetTextColor(1, 1, 0, 0.8);
		end
		if event=="PLAYER_REGEN_ENABLED" then
			self.UpdateUI:Hide()
			self.bg:SetTexCoord(caijie_B[1],caijie_B[2],caijie_B[3],caijie_B[4]);--blue
			self.T0:SetTextColor(0, 1, 0, 0.8);
			self.T1:SetTextColor(0, 1, 0, 0.8);
			self.dangqian = 0
		end
		if event=="PLAYER_ENTERING_WORLD" then
			self.UpdateUI:Hide() 
			if arg1 or arg2 then

			else
				CZ_weizhi()
			end
		end		
	end)
	CZ_weizhi()
	PIGCombatTime:RegisterEvent("PLAYER_REGEN_DISABLED")
	PIGCombatTime:RegisterEvent("PLAYER_REGEN_ENABLED")
	PIGCombatTime:RegisterEvent("PLAYER_ENTERING_WORLD")
	if InCombatLockdown() then PIGCombatTime.UpdateUI:Show() PIGCombatTime.Texture:SetTexCoord(0,0.248,0.40,0.63);end
	PIGCombatTime.yizairu=true
end
--------------------------
local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME2"],90)

local BGtooltip = "在游戏界面上方中间显示战斗时间\n|cff00FF00副本内：\n左边本次进本的战斗总用时，右边为本次战斗用时。|r\n|cff00FF00副本外：\n只显示本次战斗用时。|r";
CombatPlusF.Open = PIGCheckbutton_R(CombatPlusF,{"启用战斗时间",BGtooltip})
CombatPlusF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["CombatTime"]["Open"]=true;
		CombatPlusF.SetF:Show()
	else
		PIGA["CombatPlus"]["CombatTime"]["Open"]=false;
		CombatPlusF.SetF:Hide()
		Pig_Options_RLtishi_UI:Show()
	end
	CombatPlusfun.CombatTime()
end)
---
local CombatLine1=PIGLine(CombatPlusF,"TOP",-70)
CombatPlusF.SetF = PIGFrame(CombatPlusF,{"TOPLEFT", CombatLine1, "BOTTOMLEFT", 0, 0})
CombatPlusF.SetF:SetPoint("BOTTOMRIGHT",CombatPlusF,"BOTTOMRIGHT",0,0);
--
CombatPlusF.SetF.Lock =PIGCheckbutton_R(CombatPlusF.SetF,{LOCK_FRAME,LOCK_FOCUS_FRAME})
CombatPlusF.SetF.Lock:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["CombatTime"]["Lock"]=true;
	else
		PIGA["CombatPlus"]["CombatTime"]["Lock"]=false;
	end
	SetLock()
end);
CombatPlusF.SetF.Lock.CZBUT = PIGButton(CombatPlusF.SetF.Lock,{"LEFT",CombatPlusF.SetF.Lock,"RIGHT",100,0},{80,24},"重置位置")
CombatPlusF.SetF.Lock.CZBUT:SetScript("OnClick", function ()
	PIGCombatTime:PIGResPoint(CombatTimeweizhi)
end)
local FontMiaobiaoList = {"NORMAL","OUTLINE","THICKOUTLINE","MONOCHROME","MONOCHROMEOUTLINE"};
CombatPlusF.SetF.Miaobian=PIGDownMenu(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",90,-60},{150,24})
CombatPlusF.SetF.Miaobian.T = PIGFontString(CombatPlusF.SetF.Miaobian,{"RIGHT",CombatPlusF.SetF.Miaobian,"LEFT",-4,0},"字体描边")
function CombatPlusF.SetF.Miaobian:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#FontMiaobiaoList,1 do
	    info.text, info.arg1 = FontMiaobiaoList[i], FontMiaobiaoList[i]
	    info.checked = FontMiaobiaoList[i]==PIGA["CombatPlus"]["CombatTime"]["Miaobian"]
		CombatPlusF.SetF.Miaobian:PIGDownMenu_AddButton(info)
	end 
end
function CombatPlusF.SetF.Miaobian:PIGDownMenu_SetValue(value,arg1,arg2)
	CombatPlusF.SetF.Miaobian:PIGDownMenu_SetText(value)
	PIGA["CombatPlus"]["CombatTime"]["Miaobian"]=arg1
	local ziti,zihao = PIGCombatTime.T0:GetFont()
	PIGCombatTime.T0:SetFont(ziti,zihao, arg1)
	PIGCombatTime.T1:SetFont(ziti,zihao, arg1)
	PIGCloseDropDownMenus()
end
--
local BGList={"背景1","背景2","无背景"}
CombatPlusF.SetF.Beijing=PIGDownMenu(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",390,-60},{100,24})
CombatPlusF.SetF.Beijing.T = PIGFontString(CombatPlusF.SetF.Beijing,{"RIGHT",CombatPlusF.SetF.Beijing,"LEFT",-4,0},"背景")
function CombatPlusF.SetF.Beijing:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#BGList,1 do
	    info.text, info.arg1 = BGList[i], i
	    info.checked = i==PIGA["CombatPlus"]["CombatTime"]["Beijing"]
		CombatPlusF.SetF.Beijing:PIGDownMenu_AddButton(info)
	end 
end
function CombatPlusF.SetF.Beijing:PIGDownMenu_SetValue(value,arg1,arg2)
	CombatPlusF.SetF.Beijing:PIGDownMenu_SetText(value)
	PIGA["CombatPlus"]["CombatTime"]["Beijing"]=arg1
	SetBGHide()
	PIGCloseDropDownMenus()
end
local xiayiinfo = {0.6,2,0.01,{["Right"]="%"}}
CombatPlusF.SetF.Slider = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",70,-140},xiayiinfo)
CombatPlusF.SetF.Slider.T = PIGFontString(CombatPlusF.SetF.Slider,{"RIGHT",CombatPlusF.SetF.Slider,"LEFT",-10,0},"缩放")
CombatPlusF.SetF.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["CombatPlus"]["CombatTime"]["Scale"]=arg1;
	PIGCombatTime:SetScale(arg1)
end)
--
CombatPlusF:HookScript("OnShow", function (self)
	self.Open:SetChecked(PIGA["CombatPlus"]["CombatTime"]["Open"]);
	self.SetF.Lock:SetChecked(PIGA["CombatPlus"]["CombatTime"]["Lock"]);
	self.SetF.Miaobian:PIGDownMenu_SetText(PIGA["CombatPlus"]["CombatTime"]["Miaobian"])
	self.SetF.Beijing:PIGDownMenu_SetText(BGList[PIGA["CombatPlus"]["CombatTime"]["Beijing"]])
	self.SetF.Slider:PIGSetValue(PIGA["CombatPlus"]["CombatTime"]["Scale"])
end);
