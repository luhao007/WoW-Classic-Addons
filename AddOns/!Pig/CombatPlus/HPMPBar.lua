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
local www,hhh = 130,24
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
local function SetCombatShow()
	if HPMPBar_UI then
		if PIGA["CombatPlus"]["HPMPBar"]["CombatShow"] then
			HPMPBar_UI:RegisterEvent("PLAYER_REGEN_DISABLED");
			HPMPBar_UI:RegisterEvent("PLAYER_REGEN_ENABLED");
			if not InCombatLockdown() then
				HPMPBar_UI:Hide()
			end
		else
			HPMPBar_UI:UnregisterEvent("PLAYER_REGEN_DISABLED");
			HPMPBar_UI:UnregisterEvent("PLAYER_REGEN_ENABLED");
			HPMPBar_UI:Show()
		end
	end
end

local function SetFuziyuan()

end

function CombatPlusfun.HPMPBar()
	if tocversion>70000 then return end
	if not PIGA["CombatPlus"]["HPMPBar"]["Open"] then return end
	if HPMPBar_UI then return end
	local HPMPBar = CreateFrame("Button", "HPMPBar_UI", UIParent, "SecureUnitButtonTemplate")
	HPMPBar:SetSize(www,hhh);
	HPMPBar_UI:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
	HPMPBar:EnableMouse(false)
	HPMPBar:SetScale(PIGA["CombatPlus"]["HPMPBar"]["Scale"])
	--HPMPBar.unit = "player";
	HPMPBar.bg = HPMPBar:CreateTexture(nil, "BACKGROUND");
	HPMPBar.bg:SetTexture("interface/characterframe/ui-party-background.blp");
	HPMPBar.bg:SetPoint("TOPLEFT",HPMPBar,"TOPLEFT",0,0);
	HPMPBar.bg:SetPoint("BOTTOMRIGHT",HPMPBar,"BOTTOMRIGHT",0,0);
	HPMPBar.bg:SetAlpha(0.6)

	HPMPBar.HPBar = CreateFrame("StatusBar", nil, HPMPBar);
	HPMPBar.HPBar:SetStatusBarTexture("interface/targetingframe/ui-statusbar.blp")
	HPMPBar.HPBar:SetStatusBarColor(0, 1, 0 ,1);
	HPMPBar.HPBar:SetPoint("TOPLEFT",HPMPBar,"TOPLEFT",0.5,-0.5);
	HPMPBar.HPBar:SetPoint("BOTTOMRIGHT",HPMPBar,"BOTTOMRIGHT",-0.5,hhh*0.5);
	HPMPBar.HPBar.xiaxian = HPMPBar.HPBar:CreateFontString();
	HPMPBar.HPBar.xiaxian:SetPoint("CENTER",HPMPBar.HPBar,"CENTER",0,0);
	HPMPBar.HPBar.xiaxian:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")
	HPMPBar.HPBar.xiaxian:SetText("/")
	HPMPBar.HPBar.V = HPMPBar.HPBar:CreateFontString();
	HPMPBar.HPBar.V:SetPoint("RIGHT",HPMPBar.HPBar.xiaxian,"LEFT",0,0);
	HPMPBar.HPBar.V:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")
	HPMPBar.HPBar.maxV = HPMPBar.HPBar:CreateFontString();
	HPMPBar.HPBar.maxV:SetPoint("LEFT",HPMPBar.HPBar.xiaxian,"RIGHT",0,0);
	HPMPBar.HPBar.maxV:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")

	HPMPBar.MPBar = CreateFrame("StatusBar", nil, HPMPBar);
	HPMPBar.MPBar:SetStatusBarTexture("interface/targetingframe/ui-statusbar.blp")
	HPMPBar.MPBar:SetStatusBarColor(0, 1, 0 ,1);
	HPMPBar.MPBar:SetPoint("TOPLEFT",HPMPBar,"TOPLEFT",0.5,-hhh*0.5-0.5);
	HPMPBar.MPBar:SetPoint("BOTTOMRIGHT",HPMPBar,"BOTTOMRIGHT",-0.5,0.8);
	HPMPBar.MPBar.xiaxian = HPMPBar.MPBar:CreateFontString();
	HPMPBar.MPBar.xiaxian:SetPoint("CENTER",HPMPBar.MPBar,"CENTER",0,0);
	HPMPBar.MPBar.xiaxian:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")
	HPMPBar.MPBar.xiaxian:SetText("/")
	HPMPBar.MPBar.V = HPMPBar.MPBar:CreateFontString();
	HPMPBar.MPBar.V:SetPoint("RIGHT",HPMPBar.MPBar.xiaxian,"LEFT",0,0);
	HPMPBar.MPBar.V:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")
	HPMPBar.MPBar.maxV = HPMPBar.MPBar:CreateFontString();
	HPMPBar.MPBar.maxV:SetPoint("LEFT",HPMPBar.MPBar.xiaxian,"RIGHT",0,0);
	HPMPBar.MPBar.maxV:SetFont(TextStatusBarText:GetFont(), 10,"OUTLINE")
	--	
	-- HPMPBar.Rune = CreateFrame("Frame", nil, HPMPBar)
	-- HPMPBar.Rune:SetSize(www,hhh);
	-- HPMPBar.Rune:SetPoint("TOP",HPMPBar,"BOTTOM",0,-2);
	-- local Runehhh = hhh-3
	-- for i=6,1,-1 do
	-- 	local RuneBut = CreateFrame("Frame", "PIG_Rune"..i, HPMPBar.Rune, "RuneButtonIndividualTemplate",i)
	-- 	RuneBut:SetSize(Runehhh,Runehhh);
	-- 	RuneBut:SetPoint("RIGHT",HPMPBar.Rune,"RIGHT",-(i*Runehhh)+Runehhh-1.6,0);
	-- end
	-- HPMPBar.Rune:RegisterEvent("RUNE_POWER_UPDATE");
	-- HPMPBar.Rune:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
	-- HPMPBar.Rune:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- HPMPBar.Rune:HookScript("OnEvent", function(self, event)
	-- 	if ( event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" ) then
	-- 		UpdateRunes(self,true);
	-- 	elseif ( event == "RUNE_POWER_UPDATE") then
	-- 		UpdateRunes(self);
	-- 	end
	-- end)
	--
	if PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"] then
		HPMPBar.Showshuzhi=true
	end
	if tocversion<90000 then
		HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH_FREQUENT","player");
	else
		HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH","player");
	end
	HPMPBar.HPBar:RegisterUnitEvent("UNIT_MAXHEALTH","player");
	HPMPBar.HPBar:SetScript("OnEvent", function (self,event)
		if event=="UNIT_MAXHEALTH" then
			Update_HPMAX(self)
		end
		if event=="UNIT_HEALTH_FREQUENT" or event=="UNIT_HEALTH" then
			Update_HP(self)
		end
	end)

	HPMPBar.MPBar:RegisterUnitEvent("UNIT_POWER_FREQUENT","player");
	HPMPBar.MPBar:RegisterUnitEvent("UNIT_MAXPOWER","player");
	HPMPBar.MPBar:SetScript("OnEvent", function (self,event)
		if event=="UNIT_MAXPOWER" then
			Update_MPMAX(self)
		end
		if event=="UNIT_POWER_FREQUENT" then
			Update_MP(self)
		end
	end)

	HPMPBar:RegisterEvent("PLAYER_ENTERING_WORLD");
	HPMPBar:SetScript("OnEvent", function (self,event, ...)
		if event=="PLAYER_REGEN_DISABLED" then
			self:Show()
		end
		if event=="PLAYER_REGEN_ENABLED" then
			self:Hide()
		end
		if ( event == "UNIT_DISPLAYPOWER" or event == "PLAYER_ENTERING_WORLD" ) then
			Update_HPMAX(self.HPBar)
			Update_HP(self.HPBar)
			Update_MPMAX(self.MPBar)
			Update_MP(self.MPBar)
			Update_PowerType(self.MPBar)
			SetCombatShow()
			SetFuziyuan()
		end
	end)
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

	CombatPlusF.SetF.Showshuzhi =PIGCheckbutton_R(CombatPlusF.SetF,{"显示数值","显示血量/资源数值"})
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
	CombatPlusF.SetF.CombatShow =PIGCheckbutton_R(CombatPlusF.SetF,{"脱战后隐藏","脱战后隐藏血量资源条"})
	CombatPlusF.SetF.CombatShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=false;
		end
		SetCombatShow()
	end);
	-- CombatPlusF.SetF.Fuziyuan =PIGCheckbutton_R(CombatPlusF.SetF,{"显示特殊资源条","显示系统特殊资源条到个人资源条之下"})
	-- CombatPlusF.SetF.Fuziyuan:SetScript("OnClick", function (self)
	-- 	if InCombatLockdown() then self:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]) return end
	-- 	if self:GetChecked() then
	-- 		PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=true;
	-- 	else
	-- 		PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=false;
	-- 	end
	-- 	SetFuziyuan()
	-- end);
	--
	local function SetScaleXY()
		if HPMPBar_UI then
			HPMPBar_UI:SetScale(PIGA["CombatPlus"]["HPMPBar"]["Scale"])
			HPMPBar_UI:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
		end
	end
	local xiayiinfo = {0.6,2,0.01,{["Right"]="%"}}
	CombatPlusF.SetF.Slider = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",70,-80},xiayiinfo)
	CombatPlusF.SetF.Slider.T = PIGFontString(CombatPlusF.SetF.Slider,{"RIGHT",CombatPlusF.SetF.Slider,"LEFT",-10,0},"缩放")
	CombatPlusF.SetF.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Scale"]=arg1;
		SetScaleXY()
	end)
	local WowWidth=floor(GetScreenWidth()*0.5);
	local xiayiinfo = {-WowWidth,WowWidth,1}
	CombatPlusF.SetF.SliderX = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",70,-140},xiayiinfo)
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

	CombatPlusF.SetF.CZBUT = PIGButton(CombatPlusF.SetF.Slider,{"LEFT",CombatPlusF.SetF.SliderY,"RIGHT",60,0},{80,24},"重置位置")
	CombatPlusF.SetF.CZBUT:SetScript("OnClick", function ()
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Xpianyi"]
		PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Ypianyi"]
		CombatPlusF.SetF.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		CombatPlusF.SetF.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
		SetScaleXY()
	end)
	--
	CombatPlusF:HookScript("OnShow", function (self)
		self.Open:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Open"]);
		self.SetF.Showshuzhi:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]);
		self.SetF.CombatShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]);
		--self.SetF.Fuziyuan:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]);
		self.SetF.Slider:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Scale"])
		self.SetF.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		self.SetF.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
	end);
end