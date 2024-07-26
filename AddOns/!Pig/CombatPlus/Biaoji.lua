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
--
local CombatPlusfun=addonTable.CombatPlusfun
-- /click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
-- /click DropDownList1Button5
-- 光标宏是
-- /wm 1-8
-- 清除是
-- /cwm 1-8
-- 清除全部
-- /cwm 0
-- 鼠标指向技能是
-- /cast [@cursor] 照明弹

----快速标记按钮------
local biaojiW=22
local biaoji_icon = "interface\\targetingframe\\ui-raidtargetingicons"
local iconIdCoord = {
	{0.75,1,0.25,0.5},{0.5,0.75,0.25,0.5},{0.25,0.5,0.25,0.5},
	{0,0.25,0.25,0.5},{0.75,1,0,0.25},{0.5,0.75,0,0.25},
	{0.25,0.5,0,0.25},{0,0.25,0,0.25},{0.75,1,0.75,1}
}
local tuNum=#iconIdCoord
local biaojiweizhi={"TOP", UIParent, "TOP", 0, -30}
local PIGbiaoji = PIGFrame(UIParent,biaojiweizhi,{(biaojiW+3)*tuNum+5,biaojiW+4},"PIGbiaoji_UI")
PIGbiaoji:PIGSetMovable()
PIGbiaoji:Hide()
local function SetBGHide()
	if PIGA["CombatPlus"]["Biaoji"]["BGHide"] then
		PIGbiaoji:SetBackdropColor(0, 0, 0, 0);
		PIGbiaoji:SetBackdropBorderColor(0, 0, 0, 0);
	else
		local BackdropColor=Create.BackdropColor
		local BackdropBorderColor=Create.BackdropBorderColor
		PIGbiaoji:SetBackdropColor(BackdropColor[1], BackdropColor[2], BackdropColor[3], BackdropColor[4]);
		PIGbiaoji:SetBackdropBorderColor(BackdropBorderColor[1], BackdropBorderColor[2], BackdropBorderColor[3], BackdropBorderColor[4]);
	end
end
local function SetLock()
	local ziframe = {PIGbiaoji:GetChildren()}
	if PIGA["CombatPlus"]["Biaoji"]["Lock"] then
		PIGbiaoji:RegisterForDrag("")
		for i=1,#ziframe do
			ziframe[i]:RegisterForDrag("")
		end
	else
		PIGbiaoji:RegisterForDrag("LeftButton")
		for i=1,#ziframe do
			ziframe[i]:RegisterForDrag("LeftButton")
		end
	end
end
local function SetAutoShowFun(self)
	self.ShowHide=true
	if self.NOtargetHide and not UnitExists("target") then
		self.ShowHide=false
	end
	if self.AutoShow and not CanBeRaidTarget("target") then
		self.ShowHide=false
	end
	self:SetShown(self.ShowHide)
end
local function SetAutoShow()
	if PIGA["CombatPlus"]["Biaoji"]["AutoShow"] then
		PIGbiaoji.AutoShow=true
	else
		PIGbiaoji.AutoShow=false
	end
	if PIGA["CombatPlus"]["Biaoji"]["NOtargetHide"] then
		PIGbiaoji.NOtargetHide=true
	else
		PIGbiaoji.NOtargetHide=false
	end
	SetAutoShowFun(PIGbiaoji)
end
function CombatPlusfun.biaoji()
	if not PIGA["CombatPlus"]["Biaoji"]["Open"] then return end
	if PIGbiaoji.yizairu then return end
	PIGbiaoji:Show()
	PIGbiaoji:PIGSetBackdrop()
	for i=1,tuNum do
		local listbut = CreateFrame("Button", nil, PIGbiaoji)
		listbut:SetScript("OnDragStart",function(self)
			PIGbiaoji:StartMoving()
		end)
		listbut:SetScript("OnDragStop",function(self)
			PIGbiaoji:StopMovingOrSizing()
		end)
		listbut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		if i==tuNum then
			listbut:SetSize(biaojiW,biaojiW)
			listbut:SetPoint("LEFT", PIGbiaoji, "LEFT",i*(biaojiW+3)-biaojiW+4,0)
			listbut:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Pass-Up")
		else
			listbut:SetSize(biaojiW,biaojiW)
			listbut:SetPoint("LEFT", PIGbiaoji, "LEFT",i*(biaojiW+3)-biaojiW,0)
			listbut:SetNormalTexture(biaoji_icon)
			listbut:GetNormalTexture():SetTexCoord(iconIdCoord[i][1],iconIdCoord[i][2],iconIdCoord[i][3],iconIdCoord[i][4])
		end
		listbut:SetScript("OnClick", function(self) 
			--SetRaidTargetIcon("target", tuNum-i) 
			SetRaidTarget("target", tuNum-i)
		end)
	end
	PIGbiaoji:SetScale(PIGA["CombatPlus"]["Biaoji"]["Scale"])
	SetLock()
	SetBGHide()
	SetAutoShow()
	--
	PIGbiaoji:RegisterEvent("PLAYER_ENTERING_WORLD")
	PIGbiaoji:RegisterEvent("RAID_TARGET_UPDATE")
	PIGbiaoji:RegisterEvent("PLAYER_TARGET_CHANGED")
	PIGbiaoji:SetScript("OnEvent", function(self,event)
		SetAutoShowFun(self)
	end);
	PIGbiaoji.yizairu=true
end
--------------------------
local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME1"],90)
CombatPlusF:Show()
CombatPlustabbut:Selected()

CombatPlusF.Open = PIGCheckbutton_R(CombatPlusF,{"启用标记按钮","在屏幕上显示快速标记按钮"})
CombatPlusF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		CombatPlusfun.biaoji()
		CombatPlusF.SetF:Show()
		PIGA["CombatPlus"]["Biaoji"]["Open"]=true;
	else
		PIGA["CombatPlus"]["Biaoji"]["Open"]=false;
		CombatPlusF.SetF:Hide()
		Pig_Options_RLtishi_UI:Show()
	end
end)
---
local CombatLine1=PIGLine(CombatPlusF,"TOP",-70)
CombatPlusF.SetF = PIGFrame(CombatPlusF,{"TOPLEFT", CombatLine1, "BOTTOMLEFT", 0, 0})
CombatPlusF.SetF:SetPoint("BOTTOMRIGHT",CombatPlusF,"BOTTOMRIGHT",0,0);

CombatPlusF.SetF.Lock =PIGCheckbutton_R(CombatPlusF.SetF,{LOCK_FRAME,LOCK_FOCUS_FRAME})
CombatPlusF.SetF.Lock:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["Biaoji"]["Lock"]=true;
	else
		PIGA["CombatPlus"]["Biaoji"]["Lock"]=false;
	end
	SetLock()
end);
CombatPlusF.SetF.Lock.CZBUT = PIGButton(CombatPlusF.SetF.Lock,{"LEFT",CombatPlusF.SetF.Lock,"RIGHT",100,0},{80,24},"重置位置")
CombatPlusF.SetF.Lock.CZBUT:SetScript("OnClick", function ()
	PIGbiaoji:PIGResPoint(biaojiweizhi)
end)
CombatPlusF.SetF.BGHide= PIGCheckbutton_R(CombatPlusF.SetF,{"隐藏背景","隐藏标记按钮背景"})
CombatPlusF.SetF.BGHide:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["Biaoji"]["BGHide"]=true;
	else
		PIGA["CombatPlus"]["Biaoji"]["BGHide"]=false;
	end
	SetBGHide()
end);
CombatPlusF.SetF.NOtargetHide= PIGCheckbutton_R(CombatPlusF.SetF,{"无目标隐藏","当你没有目标时隐藏标记按钮"})
CombatPlusF.SetF.NOtargetHide:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["Biaoji"]["NOtargetHide"]=true;
	else
		PIGA["CombatPlus"]["Biaoji"]["NOtargetHide"]=false;
	end
	SetAutoShow()
end);
CombatPlusF.SetF.AutoShow= PIGCheckbutton_R(CombatPlusF.SetF,{"智能显示/隐藏","当你没有标记权限时隐藏标记按钮"})
CombatPlusF.SetF.AutoShow:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["Biaoji"]["AutoShow"]=true;
	else
		PIGA["CombatPlus"]["Biaoji"]["AutoShow"]=false;
	end
	SetAutoShow()
end);

local xiayiinfo = {0.6,2,0.1}
CombatPlusF.SetF.Slider = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",64,-120},{100,14},xiayiinfo)
CombatPlusF.SetF.Slider.T = PIGFontString(CombatPlusF.SetF.Slider,{"RIGHT",CombatPlusF.SetF.Slider,"LEFT",-10,0},"缩放")
function CombatPlusF.SetF.Slider:OnValueFun()
	local Value = (floor(self:GetValue()*10+0.5))/10
	PIGA["CombatPlus"]["Biaoji"]["Scale"]=Value;
	self.Text:SetText(Value);
	PIGbiaoji_UI:SetScale(Value)
end
--
CombatPlusF:HookScript("OnShow", function (self)
	self.Open:SetChecked(PIGA["CombatPlus"]["Biaoji"]["Open"]);
	self.SetF.Lock:SetChecked(PIGA["CombatPlus"]["Biaoji"]["Lock"]);
	self.SetF.BGHide:SetChecked(PIGA["CombatPlus"]["Biaoji"]["BGHide"]);
	self.SetF.NOtargetHide:SetChecked(PIGA["CombatPlus"]["Biaoji"]["NOtargetHide"]);
	self.SetF.AutoShow:SetChecked(PIGA["CombatPlus"]["Biaoji"]["AutoShow"]);
	self.SetF.Slider:PIGSetValue(PIGA["CombatPlus"]["Biaoji"]["Scale"])
end);