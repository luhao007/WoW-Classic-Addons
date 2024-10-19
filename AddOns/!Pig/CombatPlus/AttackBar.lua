local _, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local match = _G.string.match
local floor=floor
--
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGSlider = Create.PIGSlider
local PIGFontString=Create.PIGFontString
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
----
local CombatPlusfun=addonTable.CombatPlusfun
---------------------------------
local IsCurrentSpell = IsCurrentSpell or C_Spell and C_Spell.IsCurrentSpell
local IsAutoRepeatSpell = IsAutoRepeatSpell or C_Spell and C_Spell.IsAutoRepeatSpell

local function SetScaleXY()
	if AttackBar_UI then
		AttackBar_UI:SetScale(PIGA["CombatPlus"]["AttackBar"]["Scale"])
		AttackBar_UI:SetPoint("BOTTOM", AttackBar_UI.PointfujiUI, "TOP", PIGA["CombatPlus"]["AttackBar"]["Xpianyi"], PIGA["CombatPlus"]["AttackBar"]["Ypianyi"]);
	end
end
function CombatPlusfun.AttackBar(open)
	if not PIGA["CombatPlus"]["AttackBar"]["Open"] then return end
	if AttackBar_UI then return end
	local PointfujiUI={PlayerCastingBarFrame,"CastingBarFrameTemplate, UIParentBottomManagedFrameTemplate, EditModeCastBarSystemTemplate"}
	if tocversion<50000 then
		PointfujiUI={CastingBarFrame,"CastingBarFrameTemplate"}
	end
	local AttackBar = CreateFrame("StatusBar", "AttackBar_UI", UIParent, PointfujiUI[2])
	AttackBar:SetFrameStrata("HIGH")
	AttackBar:SetSize(195,13);
	AttackBar:SetToplevel(true);
	AttackBar:SetPoint("BOTTOM",PointfujiUI[1],"TOP",0,14);
	AttackBar.PointfujiUI=PointfujiUI[1]
	AttackBar.Icon:Hide();
	AttackBar.Flash:Hide();
	AttackBar:Hide()
	AttackBar.zhu=true
	AttackBar.unit = "player";
	AttackBar.Showshuzhi=PIGA["CombatPlus"]["AttackBar"]["Showshuzhi"]
	AttackBar:SetScript("OnShow", nil)
	AttackBar.fubar = CreateFrame("StatusBar", nil, AttackBar, "CastingBarFrameTemplate")
	AttackBar.fubar:SetSize(195,13);
	AttackBar.fubar:SetPoint("BOTTOM",AttackBar,"TOP",0,14);
	AttackBar.fubar.Icon:Hide();
	AttackBar.fubar.Flash:Hide();
	AttackBar.fubar:Hide()
	AttackBar.fubar:SetScript("OnShow", nil)
	AttackBar.fubar.zhu=false
	AttackBar.fubar.SLOTname = PIGFontString(AttackBar.fubar,{"LEFT", AttackBar.fubar, "LEFT", 6, 2},SECONDARYHANDSLOT,"OUTLINE",12)
	local function GetSpeed(self)
		if IsCurrentSpell(6603) then
			return self.maxValue
		elseif IsAutoRepeatSpell(75) or IsAutoRepeatSpell(5019) then
			return self.maxValueranged
		end
		return 0
	end
	local function GetAttackSpeedTime(self,JIXU)
		self.NewmaxValue=GetSpeed(self)
		self.old_maxValue=self.NewmaxValue
		self:SetMinMaxValues(0, self.NewmaxValue);
		if not JIXU then
			self:SetValue(0);
			self.value = 0
		end
	end
	local function AttackBar_OnUpdate(self, elapsed)
		if self.NewmaxValue==0 then self:Hide() return end
		if GetSpeed(self)~=self.old_maxValue then GetAttackSpeedTime(self,true) end
		self.value = self.value + elapsed;
		if ( self.value > self.NewmaxValue ) then
			self:SetValue(self.NewmaxValue);
			return;
		end
		if AttackBar_UI.Showshuzhi then
			if self.zhu then
				self.Text:SetText((floor(self.value*10+0.5)*0.1).."/"..floor(self.NewmaxValue*10+0.5)*0.1);
			else
				self.Text:SetText((floor(self.value*10+0.5)*0.1).."/"..floor(self.NewmaxValue*10+0.5)*0.1);
			end
		else
			self.Text:SetText("");
		end
		self:SetValue(self.value);
		if ( self.Spark ) then
			local sparkPosition = (self.value / self.NewmaxValue) * self:GetWidth();
			self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY or 2);
		end
	end
	function AttackBar:jiazaichushiV()
		local mainSpeed, offSpeed = UnitAttackSpeed(self.unit)
		local rangedAttackSpeed = UnitRangedDamage(self.unit);
		self.maxValue = mainSpeed
		self.maxValueranged = rangedAttackSpeed
		if offSpeed then
			self.fubar.maxValue = offSpeed
		else
			self.fubar.maxValue = 0
			self.fubar:Hide()
		end
	end
	if open then AttackBar:jiazaichushiV() end
	AttackBar:SetScript("OnUpdate", AttackBar_OnUpdate)
	AttackBar.fubar:SetScript("OnUpdate", AttackBar_OnUpdate)
	local GUID = UnitGUID("player")
	AttackBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	AttackBar:RegisterEvent("PLAYER_ENTERING_WORLD");
	AttackBar:RegisterEvent("PLAYER_REGEN_ENABLED")
	AttackBar:RegisterUnitEvent("UNIT_ATTACK_SPEED","player");--当您的攻击速度受到影响时触发
	--AttackBar:RegisterUnitEvent("PLAYER_TARGET_SET_ATTACKING","target");
	AttackBar:SetScript("OnEvent", function (self,event,arg1,arg2)
		if event=="PLAYER_ENTERING_WORLD" or event=="UNIT_ATTACK_SPEED" then
			self:jiazaichushiV()
			if event=="UNIT_ATTACK_SPEED" then
				GetAttackSpeedTime(self)
				GetAttackSpeedTime(self.fubar)
			end
		elseif event=="PLAYER_REGEN_ENABLED" then
			self:Hide()
		elseif event=="COMBAT_LOG_EVENT_UNFILTERED" then
			local Combat1,Combat2,Combat3,Combat4,Combat5,Combat6,Combat7,Combat8,Combat9,Combat10,Combat11,Combat12,Combat13,Combat14,Combat15,Combat16,Combat17,Combat18,Combat19,Combat20,Combat21= CombatLogGetCurrentEventInfo();
			if Combat4 ~= GUID then return end
			--print(select(1, CombatLogGetCurrentEventInfo()))
			if Combat2=="SPELL_CAST_SUCCESS" then
				GetAttackSpeedTime(self)
				self:Show()
			elseif Combat2:match("SWING") then
				local zhufushou = Combat21
				if zhufushou==nil then
					zhufushou=Combat13
				end
				if zhufushou then 
					GetAttackSpeedTime(self.fubar)
					self.fubar:Show()
				else
					GetAttackSpeedTime(self)
					self:Show()
				end
			end
		end
	end)
end
--------------------------
local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,"普攻进度条",100)
CombatPlusF.Open = PIGCheckbutton_R(CombatPlusF,{"启用普攻进度条","在屏幕上显示普攻进度条"})
CombatPlusF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		CombatPlusF.SetF:Show()
		PIGA["CombatPlus"]["AttackBar"]["Open"]=true;
	else
		PIGA["CombatPlus"]["AttackBar"]["Open"]=false;
		CombatPlusF.SetF:Hide()
		Pig_Options_RLtishi_UI:Show()
	end
	CombatPlusfun.AttackBar(true)
end)
--
local CombatLine1=PIGLine(CombatPlusF,"TOP",-70)
CombatPlusF.SetF = PIGFrame(CombatPlusF,{"TOPLEFT", CombatLine1, "BOTTOMLEFT", 0, 0})
CombatPlusF.SetF:SetPoint("BOTTOMRIGHT",CombatPlusF,"BOTTOMRIGHT",0,0);
CombatPlusF.SetF:Hide()
CombatPlusF.SetF.Showshuzhi =PIGCheckbutton_R(CombatPlusF.SetF,{"显示数值","显示进度数值"})
CombatPlusF.SetF.Showshuzhi:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["AttackBar"]["Showshuzhi"]=true;
		if AttackBar_UI then
			AttackBar_UI.Showshuzhi=true
		end
	else
		PIGA["CombatPlus"]["AttackBar"]["Showshuzhi"]=false;
		if AttackBar_UI then
			AttackBar_UI.Showshuzhi=false
		end
	end
end);

local xiayiinfo = {0.6,2,0.01,{["Right"]="%"}}
CombatPlusF.SetF.Slider = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",70,-80},xiayiinfo)
CombatPlusF.SetF.Slider.T = PIGFontString(CombatPlusF.SetF.Slider,{"RIGHT",CombatPlusF.SetF.Slider,"LEFT",-10,0},"缩放")
CombatPlusF.SetF.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["CombatPlus"]["AttackBar"]["Scale"]=arg1;
	SetScaleXY()
end)
local WowWidth=floor(GetScreenWidth()*0.5);
local xiayiinfo = {-WowWidth,WowWidth,1}
CombatPlusF.SetF.SliderX = PIGSlider(CombatPlusF.SetF,{"TOPLEFT",CombatPlusF.SetF,"TOPLEFT",70,-140},xiayiinfo)
CombatPlusF.SetF.SliderX.T = PIGFontString(CombatPlusF.SetF.SliderX,{"RIGHT",CombatPlusF.SetF.SliderX,"LEFT",0,0},"X偏移")
CombatPlusF.SetF.SliderX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["CombatPlus"]["AttackBar"]["Xpianyi"]=arg1;
	SetScaleXY()
end)
local WowHeight=floor(GetScreenHeight()*0.5);
local xiayiinfo = {-WowHeight,WowHeight,1}
CombatPlusF.SetF.SliderY = PIGSlider(CombatPlusF.SetF,{"LEFT",CombatPlusF.SetF.SliderX,"RIGHT",100,0},xiayiinfo)
CombatPlusF.SetF.SliderY.T = PIGFontString(CombatPlusF.SetF.SliderY,{"RIGHT",CombatPlusF.SetF.SliderY,"LEFT",0,0},"Y偏移")
CombatPlusF.SetF.SliderY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["CombatPlus"]["AttackBar"]["Ypianyi"]=arg1;
	SetScaleXY()
end)

CombatPlusF.SetF.CZBUT = PIGButton(CombatPlusF.SetF.Slider,{"LEFT",CombatPlusF.SetF.SliderY,"RIGHT",60,0},{80,24},"重置位置")
CombatPlusF.SetF.CZBUT:SetScript("OnClick", function ()
	PIGA["CombatPlus"]["AttackBar"]["Xpianyi"]=addonTable.Default["CombatPlus"]["AttackBar"]["Xpianyi"]
	PIGA["CombatPlus"]["AttackBar"]["Ypianyi"]=addonTable.Default["CombatPlus"]["AttackBar"]["Ypianyi"]
	CombatPlusF.SetF.SliderX:PIGSetValue(PIGA["CombatPlus"]["AttackBar"]["Xpianyi"])
	CombatPlusF.SetF.SliderY:PIGSetValue(PIGA["CombatPlus"]["AttackBar"]["Ypianyi"])
	SetScaleXY()
end)
CombatPlusF:HookScript("OnShow", function (self)
	self.Open:SetChecked(PIGA["CombatPlus"]["AttackBar"]["Open"]);
	if PIGA["CombatPlus"]["AttackBar"]["Open"] then
		self.SetF:Show()
	end
end);
CombatPlusF.SetF:HookScript("OnShow", function (self)
	self.Showshuzhi:SetChecked(PIGA["CombatPlus"]["AttackBar"]["Showshuzhi"]);
	self.Slider:PIGSetValue(PIGA["CombatPlus"]["AttackBar"]["Scale"])
	self.SliderX:PIGSetValue(PIGA["CombatPlus"]["AttackBar"]["Xpianyi"])
	self.SliderY:PIGSetValue(PIGA["CombatPlus"]["AttackBar"]["Ypianyi"])
end);