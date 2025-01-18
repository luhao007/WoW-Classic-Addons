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
---------------------------------
local function Update_HPMAX(self) 
	local HPMAX = UnitHealthMax("player")
	self:SetMinMaxValues(0, HPMAX)
	if HPMPBar_UI.Showshuzhi then
		self.xiaxian:Show()
		self.maxV:Show()
		self.maxV:SetText(HPMAX);
	else
		self.xiaxian:Hide()
		self.maxV:Hide()
	end
end
local function Update_HP(self)
	local HP = UnitHealth("player")
	self:SetValue(HP);
	if HPMPBar_UI.Showshuzhi then
		self.xiaxian:Show()
		self.V:Show()
		self.V:SetText(HP);
	else
		self.xiaxian:Hide()
		self.V:Hide()
	end
end
local function Update_MPMAX(self)
	local MPMAX = UnitPowerMax("player")
	self:SetMinMaxValues(0, MPMAX)
	if HPMPBar_UI.Showshuzhi then
		self.xiaxian:Show()
		self.maxV:Show()
		self.maxV:SetText(MPMAX);
	else
		self.maxV:Hide()
		self.xiaxian:Hide()
	end
end
local function Update_MP(self)
	local MP = UnitPower("player")
	self:SetValue(MP);
	if HPMPBar_UI.Showshuzhi then
		self.xiaxian:Show()
		self.V:Show()
		self.V:SetText(MP);
	else
		self.V:Hide()
		self.xiaxian:Hide()
	end
end
local function Update_PowerType(self)
	local powerType = UnitPowerType("player")
	local info = PowerBarColor[powerType]
	self:SetStatusBarColor(info.r, info.g, info.b ,1)
end
local RuneTypeColor = {
	[1]={1,40/255,40/255},
	[2]={0,191/255,1},
	[3]={30/255,255/255,100/255},
	[4]={1,20/255,147/255},
}
local Runeindex = {1,2,5,6,3,4}
local function UpdateRuneType(index)
	local runeType = GetRuneType(index)
	HPMPBar_UI.Rune.Runebut[index]:SetStatusBarColor(RuneTypeColor[runeType][1],RuneTypeColor[runeType][2],RuneTypeColor[runeType][3],1);
end	
local function RuneButton_OnUpdate (self)
	local start, duration, runeReady = GetRuneCooldown(self:GetID())
	if start==nil or runeReady then
		self:SetValue(10);
		self:SetAlpha(1);
		self:SetScript("OnUpdate", nil);
	else
		self:SetValue(GetTime()-start);
	end
end
local function UpdateRuneCooldown(index,added)
	if added then
		HPMPBar_UI.Rune.Runebut[index]:SetAlpha(1);
		HPMPBar_UI.Rune.Runebut[index]:SetScript("OnUpdate", nil);
	else
		HPMPBar_UI.Rune.Runebut[index]:SetAlpha(0.7);
		HPMPBar_UI.Rune.Runebut[index]:SetScript("OnUpdate", RuneButton_OnUpdate);
	end
end
local function UpdateRunesAll()
	for index=1,6 do
		UpdateRuneType(index)
		UpdateRuneCooldown(index,false)
	end
end
---
local function SetCombatShow()
	if HPMPBar_UI then
		if PIGA["CombatPlus"]["HPMPBar"]["CombatShow"] then
			RegisterStateDriver(HPMPBar_UI, "combatYN", "[combat] show; hide");
		else
			RegisterStateDriver(HPMPBar_UI, "combatYN", "[] show; hide");
		end
	end
end
local BarTexList = {
	{TEXTURES_SUBHEADER.."1","interface/buttons/greyscaleramp64.blp"},
	{TEXTURES_SUBHEADER.."2","interface/targetingframe/ui-statusbar.blp"},
	{TEXTURES_SUBHEADER.."3","interface/targetingframe/ui-statusbar-glow.blp"},
	{TEXTURES_SUBHEADER.."4","interface/chatframe/chatframebackground.blp"},
};
local function Set_BarFont(fuji)
	fuji.xiaxian:SetFont(TextStatusBarText:GetFont(), PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
	fuji.V:SetFont(TextStatusBarText:GetFont(), PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
	fuji.maxV:SetFont(TextStatusBarText:GetFont(), PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
end
local function Set_StatusBarTex()
	if not HPMPBar_UI then return end
	if HPMPBar_UI.HPBar then HPMPBar_UI.HPBar:SetStatusBarTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2]) end
	if HPMPBar_UI.MPBar then HPMPBar_UI.MPBar:SetStatusBarTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2]) end
	if HPMPBar_UI.Rune then
		for index=1,6 do
			if HPMPBar_UI.Rune.butListID[index] then
				HPMPBar_UI.Rune.butListID[index].bar:SetStatusBarTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2])
			end
		end
	end
end
local function SetScaleBarWH()
	if not HPMPBar_UI then return end
	local www = PIGA["CombatPlus"]["HPMPBar"]["BarW"] or www
	HPMPBar_UI:SetWidth(www);
	local hhh = PIGA["CombatPlus"]["HPMPBar"]["BarH"] or hhh
	local ziframe = {HPMPBar_UI:GetChildren()}
	for k,v in pairs(ziframe) do
		v:SetHeight(hhh)
	end
	if HPMPBar_UI.Rune then
		local Runewww=www/6
		for index=1,6 do
			if HPMPBar_UI.Rune.butListID[index] then
				HPMPBar_UI.Rune.butListID[index]:SetHeight(hhh);
				if index==1 then
					HPMPBar_UI.Rune.butListID[index]:SetWidth(Runewww);
				else
					HPMPBar_UI.Rune.butListID[index]:SetWidth(Runewww+1);
				end
			end
		end
	end
end
local function add_Bar(fuji)
	local BarHT = CreateFrame("StatusBar", nil, fuji);
	BarHT:SetStatusBarTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2])
	BarHT:SetStatusBarColor(0, 1, 0 ,1);
	if fuji.next then
		BarHT:SetPoint("TOPLEFT",fuji.next,"BOTTOMLEFT",0,0);
		BarHT:SetPoint("TOPRIGHT",fuji.next,"BOTTOMRIGHT",0,0);
	else
		BarHT:SetPoint("TOPLEFT",fuji,"TOPLEFT",0,0);
		BarHT:SetPoint("TOPRIGHT",fuji,"TOPRIGHT",0,0);
	end
	BarHT.bg = BarHT:CreateTexture(nil, "BACKGROUND");
	BarHT.bg:SetTexture("interface/characterframe/ui-party-background.blp");
	BarHT.bg:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
	BarHT.bg:SetPoint("BOTTOMRIGHT",BarHT,"BOTTOMRIGHT",0,0);
	BarHT.bg:SetAlpha(0.6)
	BarHT.xiaxian = BarHT:CreateFontString();
	BarHT.xiaxian:SetPoint("CENTER",BarHT,"CENTER",0,0);
	BarHT.V = BarHT:CreateFontString();
	BarHT.V:SetPoint("RIGHT",BarHT.xiaxian,"LEFT",0,0);
	BarHT.maxV = BarHT:CreateFontString();
	BarHT.maxV:SetPoint("LEFT",BarHT.xiaxian,"RIGHT",0,0);
	Set_BarFont(BarHT)
	BarHT.xiaxian:SetText("/")
	BarHT:RegisterEvent("PLAYER_ENTERING_WORLD");
	fuji.next=BarHT
	return BarHT
end
----------
function CombatPlusfun.HPMPBar()
	if tocversion>70000 then return end
	if not PIGA["CombatPlus"]["HPMPBar"]["Open"] then return end
	if HPMPBar_UI then return end
	local HPMPBar = CreateFrame("Button", "HPMPBar_UI", UIParent, "SecureUnitButtonTemplate,SecureHandlerStateTemplate")
	HPMPBar:SetHeight(0.00001);
	HPMPBar_UI:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
	HPMPBar:EnableMouse(false)
	HPMPBar:SetAttribute("_onstate-combatYN","if newstate == 'show' then self:Show(); else self:Hide(); end")

	if PIGA["CombatPlus"]["HPMPBar"]["HpShow"] then
		HPMPBar.HPBar=add_Bar(HPMPBar)
		if tocversion<90000 then
			HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH_FREQUENT","player");
		else
			HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH","player");
		end
		HPMPBar.HPBar:RegisterUnitEvent("UNIT_MAXHEALTH","player");
		HPMPBar.HPBar:SetScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				Update_HPMAX(self)
				Update_HP(self)
			elseif event=="UNIT_MAXHEALTH" then
				Update_HPMAX(self)
			elseif event=="UNIT_HEALTH_FREQUENT" or event=="UNIT_HEALTH" then
				Update_HP(self)
			end
		end)
	end
	if PIGA["CombatPlus"]["HPMPBar"]["MpShow"] then
		HPMPBar.MPBar=add_Bar(HPMPBar)
		HPMPBar.MPBar:RegisterEvent("UNIT_DISPLAYPOWER");
		HPMPBar.MPBar:RegisterUnitEvent("UNIT_POWER_FREQUENT","player");
		HPMPBar.MPBar:RegisterUnitEvent("UNIT_MAXPOWER","player");
		HPMPBar.MPBar:SetScript("OnEvent", function (self,event)
			if event=="UNIT_MAXPOWER" then
				Update_MPMAX(self)
			elseif event=="UNIT_POWER_FREQUENT" then
				Update_MP(self)
			elseif event == "UNIT_DISPLAYPOWER" then
				Update_PowerType(self)
				Update_MPMAX(self)
			elseif event=="PLAYER_ENTERING_WORLD" then
				Update_MPMAX(self)
				Update_MP(self)
				Update_PowerType(self)
			end
		end)
	end
	if PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"] then
		local _, class = UnitClass("player");
		if ( class== "DEATHKNIGHT" ) then
			HPMPBar.Rune = CreateFrame("Frame", nil, HPMPBar)
			if HPMPBar.next then
				HPMPBar.Rune:SetPoint("TOPLEFT",HPMPBar.next,"BOTTOMLEFT",0,0);
				HPMPBar.Rune:SetPoint("TOPRIGHT",HPMPBar.next,"BOTTOMRIGHT",0,0);
			else
				HPMPBar.Rune:SetPoint("TOPLEFT",HPMPBar,"TOPLEFT",0,0);
				HPMPBar.Rune:SetPoint("TOPRIGHT",HPMPBar,"TOPRIGHT",0,0);
			end
			HPMPBar.Rune.bg = HPMPBar.Rune:CreateTexture(nil, "BACKGROUND");
			HPMPBar.Rune.bg:SetTexture("interface/characterframe/ui-party-background.blp");
			HPMPBar.Rune.bg:SetPoint("TOPLEFT",HPMPBar.Rune,"TOPLEFT",0,0);
			HPMPBar.Rune.bg:SetPoint("BOTTOMRIGHT",HPMPBar.Rune,"BOTTOMRIGHT",0,0);
			HPMPBar.Rune.bg:SetAlpha(0.6)
			HPMPBar.Rune.butListID={}
			HPMPBar.Rune.Runebut={}
			for index=1,6,1 do
				local RuneBut = CreateFrame("Frame", nil, HPMPBar.Rune,"BackdropTemplate")
				RuneBut:SetBackdrop({edgeFile = Create.edgeFile, edgeSize = 8,})
				RuneBut:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.9)
				if index==1 then
					RuneBut:SetPoint("LEFT",HPMPBar.Rune,"LEFT",0,0);
				else
					RuneBut:SetPoint("LEFT",HPMPBar.Rune.butListID[index-1],"RIGHT",-1,0);
				end
				HPMPBar.Rune.butListID[index]=RuneBut
				RuneBut.bar = CreateFrame("StatusBar", nil, RuneBut,nil,Runeindex[index]);
				RuneBut.bar:SetStatusBarTexture("interface/chatframe/chatframebackground.blp")
				RuneBut.bar:SetPoint("TOPLEFT",RuneBut,"TOPLEFT",0,0);
				RuneBut.bar:SetPoint("BOTTOMRIGHT",RuneBut,"BOTTOMRIGHT",0,0);
				RuneBut.bar:SetFrameLevel(RuneBut:GetFrameLevel()-1)
				RuneBut.bar:SetMinMaxValues(0, 10)
				HPMPBar.Rune.Runebut[Runeindex[index]]=RuneBut.bar
			end
			HPMPBar.Rune:RegisterEvent("PLAYER_ENTERING_WORLD");
			HPMPBar.Rune:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
			HPMPBar.Rune:RegisterEvent("RUNE_TYPE_UPDATE");
			HPMPBar.Rune:RegisterEvent("RUNE_POWER_UPDATE");
			HPMPBar.Rune:HookScript("OnEvent", function(self, event, arg1, arg2)
				if ( event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" ) then
					UpdateRunesAll();
				elseif ( event == "RUNE_TYPE_UPDATE") then
					UpdateRuneType(arg1)
				elseif ( event == "RUNE_POWER_UPDATE") then
					UpdateRuneCooldown(arg1, arg2);
				end
			end)
		end
	end
	--
	HPMPBar.Showshuzhi=PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]
	SetCombatShow()
	Set_StatusBarTex()
	SetScaleBarWH()
end
--------------------------
if tocversion<50000 then
	local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME3"],100)

	CombatPlusF.Open = PIGCheckbutton_R(CombatPlusF,{"启用个人资源条","在屏幕上显示个人资源条"})
	CombatPlusF.Open:SetScript("OnClick", function (self)
		if self:GetChecked() then			
			PIGA["CombatPlus"]["HPMPBar"]["Open"]=true;
			CombatPlusF.SetF:Show()
		else
			PIGA["CombatPlus"]["HPMPBar"]["Open"]=false;
			CombatPlusF.SetF:Hide()
			Pig_Options_RLtishi_UI:Show()
		end
		CombatPlusfun.HPMPBar()
	end)
	--
	local CombatLine1=PIGLine(CombatPlusF,"TOP",-70)
	CombatPlusF.SetF = PIGFrame(CombatPlusF,{"TOPLEFT", CombatLine1, "BOTTOMLEFT", 0, 0})
	CombatPlusF.SetF:SetPoint("BOTTOMRIGHT",CombatPlusF,"BOTTOMRIGHT",0,0);
	CombatPlusF.SetF:Hide()
	----
	CombatPlusF.SetF.BarTex=PIGDownMenu(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",60,-20},{150,24})
	CombatPlusF.SetF.BarTex.T = PIGFontString(CombatPlusF.SetF.BarTex,{"RIGHT",CombatPlusF.SetF.BarTex,"LEFT",-4,0},TEXTURES_SUBHEADER)
	function CombatPlusF.SetF.BarTex:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#BarTexList,1 do
		    info.text, info.arg1 = BarTexList[i][1], i
		    info.checked = i==PIGA["CombatPlus"]["HPMPBar"]["BarTex"]
			CombatPlusF.SetF.BarTex:PIGDownMenu_AddButton(info)
		end 
	end
	function CombatPlusF.SetF.BarTex:PIGDownMenu_SetValue(value,arg1,arg2)
		CombatPlusF.SetF.BarTex:PIGDownMenu_SetText(value)
		PIGA["CombatPlus"]["HPMPBar"]["BarTex"]=arg1
		Set_StatusBarTex()
		PIGCloseDropDownMenus()
	end
	CombatPlusF.SetF.CombatShow =PIGCheckbutton(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.BarTex,"LEFT",200,0},{"脱战后隐藏","脱战后隐藏血量资源条"})
	CombatPlusF.SetF.CombatShow:SetScript("OnClick", function (self)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=false;
		end
		SetCombatShow()
	end);
	--
	local function SetScaleXY()
		if HPMPBar_UI then
			HPMPBar_UI:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
		end
	end
	local WowWidth=floor(GetScreenWidth()*0.5);
	local xiayiinfo = {-WowWidth,WowWidth,1}
	CombatPlusF.SetF.SliderX = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",60,-70},xiayiinfo)
	CombatPlusF.SetF.SliderX.T = PIGFontString(CombatPlusF.SetF.SliderX,{"RIGHT",CombatPlusF.SetF.SliderX,"LEFT",0,0},"X偏移")
	CombatPlusF.SetF.SliderX.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"]=arg1;
		SetScaleXY()
	end)
	local WowHeight=floor(GetScreenHeight()*0.5);
	local xiayiinfo = {-WowHeight,WowHeight,1}
	CombatPlusF.SetF.SliderY = PIGSlider(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.SliderX,"RIGHT",100,0},xiayiinfo)
	CombatPlusF.SetF.SliderY.T = PIGFontString(CombatPlusF.SetF.SliderY,{"RIGHT",CombatPlusF.SetF.SliderY,"LEFT",0,0},"Y偏移")
	CombatPlusF.SetF.SliderY.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]=arg1;
		SetScaleXY()
	end)

	CombatPlusF.SetF.CZBUT = PIGButton(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.SliderY,"RIGHT",60,0},{80,24},"重置位置")
	CombatPlusF.SetF.CZBUT:SetScript("OnClick", function ()
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Xpianyi"]
		PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Ypianyi"]
		CombatPlusF.SetF.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		CombatPlusF.SetF.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
		SetScaleXY()
	end)

	local xiayiinfo = {100,400,1}
	CombatPlusF.SetF.BarW = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",60,-140},xiayiinfo)
	CombatPlusF.SetF.BarW.T = PIGFontString(CombatPlusF.SetF.BarW,{"RIGHT",CombatPlusF.SetF.BarW,"LEFT",0,0},"宽度")
	CombatPlusF.SetF.BarW.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarW"]=arg1;
		SetScaleBarWH()
	end)
	local xiayiinfo = {10,60,1}
	CombatPlusF.SetF.BarH = PIGSlider(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.BarW,"RIGHT",100,0},xiayiinfo)
	CombatPlusF.SetF.BarH.T = PIGFontString(CombatPlusF.SetF.BarH,{"RIGHT",CombatPlusF.SetF.BarH,"LEFT",0,0},"高度")
	CombatPlusF.SetF.BarH.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarH"]=arg1;
		SetScaleBarWH()
	end)
	CombatPlusF.SetF.CZSize = PIGButton(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.BarH,"RIGHT",60,0},{80,24},"默认大小")
	CombatPlusF.SetF.CZSize:SetScript("OnClick", function ()
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarW"]=addonTable.Default["CombatPlus"]["HPMPBar"]["BarW"]
		PIGA["CombatPlus"]["HPMPBar"]["BarH"]=addonTable.Default["CombatPlus"]["HPMPBar"]["BarH"]
		CombatPlusF.SetF.BarW:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarW"])
		CombatPlusF.SetF.BarH:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarH"])
		SetScaleBarWH()
	end)
	CombatPlusF.SetF.Showshuzhi =PIGCheckbutton(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",20,-240},{"显示数值","显示血量/资源数值"})
	CombatPlusF.SetF.Showshuzhi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]=true;
			if HPMPBar_UI then
				HPMPBar_UI.Showshuzhi=true
			end
		else
			PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]=false;
			if HPMPBar_UI then
				HPMPBar_UI.Showshuzhi=false
			end
		end
		if HPMPBar_UI then
			Update_HPMAX(HPMPBar_UI.HPBar)
			Update_HP(HPMPBar_UI.HPBar)
			Update_MPMAX(HPMPBar_UI.MPBar)
			Update_MP(HPMPBar_UI.MPBar)
		end
	end);
	local xiayiinfo = {10,26,1}
	CombatPlusF.SetF.FontSize = PIGSlider(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.Showshuzhi,"LEFT",210,0},xiayiinfo)
	CombatPlusF.SetF.FontSize.T = PIGFontString(CombatPlusF.SetF.FontSize,{"RIGHT",CombatPlusF.SetF.FontSize,"LEFT",-10,0},"字体大小")
	CombatPlusF.SetF.FontSize.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["FontSize"]=arg1;
		if HPMPBar_UI then
			Set_BarFont(HPMPBar_UI.HPBar)
			Set_BarFont(HPMPBar_UI.MPBar)
		end
	end)

	CombatPlusF.SetF.HpShow =PIGCheckbutton(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF.Showshuzhi,"TOPLEFT",0,-40},{"显示血量条","个人资源条显示血量"})
	CombatPlusF.SetF.HpShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["HpShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["HpShow"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
	CombatPlusF.SetF.MpShow =PIGCheckbutton(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF.HpShow,"TOPLEFT",0,-40},{"显示资源条","个人资源条显示资源"})
	CombatPlusF.SetF.MpShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["MpShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["MpShow"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
	CombatPlusF.SetF.Fuziyuan =PIGCheckbutton(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF.MpShow,"TOPLEFT",0,-40},{"显示特殊资源条","个人资源条显示特殊资源"})
	CombatPlusF.SetF.Fuziyuan:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
	--
	CombatPlusF:HookScript("OnShow", function (self)
		self.Open:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Open"]);
		if PIGA["CombatPlus"]["HPMPBar"]["Open"] then
			self.SetF:Show()
		end
	end);
	CombatPlusF.SetF:HookScript("OnShow", function (self)
		self.Showshuzhi:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]);
		self.CombatShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]);
		self.FontSize:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["FontSize"])
		self.BarW:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarW"])
		self.BarH:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarH"])
		self.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		self.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
		self.BarTex:PIGDownMenu_SetText(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][1])
		self.HpShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["HpShow"]);
		self.MpShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["MpShow"]);
		self.Fuziyuan:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]);
	end);
end