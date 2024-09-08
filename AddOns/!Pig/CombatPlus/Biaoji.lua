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
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
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
	{0.25,0.5,0,0.25},{0,0.25,0,0.25},
	
}
local tuNum=#iconIdCoord
local iconqita = {
	{"Interface/Buttons/UI-GroupLoot-Pass-Up"},
	{"interface/raidframe/readycheck-waiting.blp"},--{"Interface/LFGFrame/UILFGPrompts",},--{"UI-LFG-RoleIcon-Leader","Atlas"},--{"interface/targetingframe/ui-raidtargetingicons",{0.50,0.75,0.75,0.96}},
	{"interface/raidframe/readycheck-ready.blp"},--"interface/pvpframe/icons/prestige-icon-3.blp",
	{"interface/helpframe/helpicon-reportlag.blp",{0.13,0.87,0.13,0.87}},
}
local tuNum1=#iconqita
local tuNumall=tuNum+tuNum1
local biaojiweizhi={"TOP", UIParent, "TOP", 0, -30}
local PIGbiaoji = PIGFrame(UIParent,biaojiweizhi,{(biaojiW+3)*tuNumall+5,biaojiW+4},"PIGbiaoji_UI")
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
PIGbiaoji.morendaojiTime=5
local function daojishikaiguaiFun()
	if HasLFGRestrictions() then
		if PIGbiaoji.kaiguaidaojishi==0 then
			PIGinfotip:TryDisplayMessage("***开始攻击***");
			SendChatMessage("***开始攻击***", "INSTANCE_CHAT", nil);
		else
			PIGinfotip:TryDisplayMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***");
			SendChatMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***", "INSTANCE_CHAT", nil);
		end
	elseif IsInRaid() then
		if PIGbiaoji.kaiguaidaojishi==0 then
			SendChatMessage("***开始攻击***", "RAID_WARNING", nil);
		else
			SendChatMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***", "RAID_WARNING", nil);
		end
	elseif IsInGroup() then
		if PIGbiaoji.kaiguaidaojishi==0 then
			PIGinfotip:TryDisplayMessage("***开始攻击***");
			SendChatMessage("***开始攻击***", "PARTY", nil);
		else
			PIGinfotip:TryDisplayMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***");
			SendChatMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***", "PARTY", nil);
		end
	else
		if PIGbiaoji.kaiguaidaojishi==0 then
			PIGinfotip:TryDisplayMessage("***开始攻击***");
		else
			PIGinfotip:TryDisplayMessage("***开怪倒计时："..PIGbiaoji.kaiguaidaojishi.." ***");
		end
	end
	PIGbiaoji.kaiguaidaojishi=PIGbiaoji.kaiguaidaojishi-1
end
local function PIG_PULL(butui)
	if butui.daoshuTicker  then
		butui.daoshuTicker:Cancel()
	end
	PIGbiaoji.kaiguaidaojishi=PIGbiaoji.morendaojiTime
	butui.daoshuTicker = C_Timer.NewTicker(1, daojishikaiguaiFun, PIGbiaoji.morendaojiTime+1)
end
local function Set_Pmacrotext(but,id)
	PIGbiaoji.morendaojiTime=PIGA["CombatPlus"]["Biaoji"]["daojishiTime"]
	if PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]==1 then
		but:SetScript("OnClick", function(self)
			PIG_PULL(self)
		end)
	elseif PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]==2 and C_PartyInfo and C_PartyInfo.DoCountdown then
		but:SetScript("OnClick", function(self) C_PartyInfo.DoCountdown(PIGbiaoji.morendaojiTime) end)
	elseif PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]==3 then
		but:SetScript("OnClick", function(self) 
			if IsAddOnLoaded("DBM-Core") then 
				SlashCmdList.DEADLYBOSSMODSPULL(PIGbiaoji.morendaojiTime) 
			else
				PIGinfotip:TryDisplayMessage("你的倒计时程序设置为DBM，但没有安装DBM")
			end 
		end)
	elseif PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]==4 then
		but:SetScript("OnClick", function(self) 
			if IsAddOnLoaded("BigWigs") then 
				SlashCmdList.BIGWIGSPULL(PIGbiaoji.morendaojiTime)  
			else
				PIGinfotip:TryDisplayMessage("你的倒计时程序设置为BigWigs，但没有安装BigWigs")
			end	
		end)
	end
end
function CombatPlusfun.biaoji()
	if not PIGA["CombatPlus"]["Biaoji"]["Open"] then return end
	if PIGbiaoji.yizairu then return end
	PIGbiaoji:Show()
	PIGbiaoji:PIGSetBackdrop()
	for i=1,tuNumall do
		local listbut = CreateFrame("Button", nil, PIGbiaoji)
		listbut:SetScript("OnDragStart",function(self)
			PIGbiaoji:StartMoving()
		end)
		listbut:SetScript("OnDragStop",function(self)
			PIGbiaoji:StopMovingOrSizing()
		end)
		listbut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		listbut:SetSize(biaojiW,biaojiW)	
		if i<=tuNum then
			listbut:SetPoint("LEFT", PIGbiaoji, "LEFT",i*(biaojiW+3)-biaojiW,0)
			listbut:SetNormalTexture(biaoji_icon)
			listbut:GetNormalTexture():SetTexCoord(iconIdCoord[i][1],iconIdCoord[i][2],iconIdCoord[i][3],iconIdCoord[i][4])
			listbut:SetScript("OnClick", function(self) 
				--SetRaidTargetIcon("target", tuNum+1-i) 
				SetRaidTarget("target", tuNum+1-i)
			end)
		else
			local xianzaidi = i-tuNum
			if xianzaidi==1 then
				listbut:SetPoint("LEFT", PIGbiaoji, "LEFT",i*(biaojiW+3)-biaojiW+4,0)
				listbut:SetScript("OnClick", function(self)
					SetRaidTarget("target", 0)
				end)
			else
				listbut:SetPoint("LEFT", PIGbiaoji, "LEFT",i*(biaojiW+3)-biaojiW+10,0)
				if xianzaidi==2 then 
					listbut:SetScript("OnClick", function(self)
						-- if tocversion<20000 then
						-- 	--LFGListingRolePollButton_OnClick(self, button)
						-- elseif tocversion<40000 then
						-- 	LFGListingRolePollButton_OnClick(self, button)
						-- else
							InitiateRolePoll()
						--end
					end) 
				elseif xianzaidi==3 then 
					listbut:SetScript("OnClick", function(self) DoReadyCheck() end)
				elseif xianzaidi==4 then 
					PIGbiaoji.daojishiBUT=listbut
					Set_Pmacrotext(PIGbiaoji.daojishiBUT,PIGA["CombatPlus"]["Biaoji"]["daojishiFun"])
				end
			end
			listbut:SetNormalTexture(iconqita[xianzaidi][1])
			if iconqita[xianzaidi][2] then
				if iconqita[xianzaidi][2]=="Atlas" then
					listbut:SetNormalAtlas(iconqita[xianzaidi][2]);
					listbut:SetSize(biaojiW+2,biaojiW+2)
				else
					listbut:GetNormalTexture():SetTexCoord(unpack(iconqita[xianzaidi][2]))
				end
			end
		end
		listbut:HookScript("OnClick", function(self) 
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
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
local daojishiFun = {[1]="PIG",[2]="暴雪(正式服)",[3]="DBM",[4]="BigWigs"}
CombatPlusF.SetF.Daojishi=PIGDownMenu(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",100,-200},{140,nil})
CombatPlusF.SetF.Daojishi.t = PIGFontString(CombatPlusF.SetF.Daojishi,{"RIGHT",CombatPlusF.SetF.Daojishi,"LEFT",-4,0},"倒计时程序");
function CombatPlusF.SetF.Daojishi:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,4,1 do
	    info.text, info.arg1 = daojishiFun[i], i
	    info.checked = i==PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]
		CombatPlusF.SetF.Daojishi:PIGDownMenu_AddButton(info)
	end 
end
function CombatPlusF.SetF.Daojishi:PIGDownMenu_SetValue(value,arg1,arg2)
	CombatPlusF.SetF.Daojishi:PIGDownMenu_SetText(value)
	PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]=arg1
	Set_Pmacrotext(PIGbiaoji.daojishiBUT,arg1)
	PIGCloseDropDownMenus()
end
local xiayiinfoTime = {3,30,1}
CombatPlusF.SetF.daojishiTime = PIGSlider(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.Daojishi,"RIGHT",100,0},{100,14},xiayiinfoTime)
CombatPlusF.SetF.daojishiTime.T = PIGFontString(CombatPlusF.SetF.daojishiTime,{"RIGHT",CombatPlusF.SetF.daojishiTime,"LEFT",-10,0},"倒计延迟(秒)")
function CombatPlusF.SetF.daojishiTime:OnValueFun()
	local Value = self:GetValue()
	PIGbiaoji.morendaojiTime=Value
	PIGA["CombatPlus"]["Biaoji"]["daojishiTime"]=Value;
	self.Text:SetText(Value);
end

--
CombatPlusF:HookScript("OnShow", function (self)
	self.Open:SetChecked(PIGA["CombatPlus"]["Biaoji"]["Open"]);
	self.SetF.Lock:SetChecked(PIGA["CombatPlus"]["Biaoji"]["Lock"]);
	self.SetF.BGHide:SetChecked(PIGA["CombatPlus"]["Biaoji"]["BGHide"]);
	self.SetF.NOtargetHide:SetChecked(PIGA["CombatPlus"]["Biaoji"]["NOtargetHide"]);
	self.SetF.AutoShow:SetChecked(PIGA["CombatPlus"]["Biaoji"]["AutoShow"]);
	self.SetF.Slider:PIGSetValue(PIGA["CombatPlus"]["Biaoji"]["Scale"])
	self.SetF.Daojishi:PIGDownMenu_SetText(daojishiFun[PIGA["CombatPlus"]["Biaoji"]["daojishiFun"]])
	self.SetF.daojishiTime:PIGSetValue(PIGA["CombatPlus"]["Biaoji"]["daojishiTime"])
end);