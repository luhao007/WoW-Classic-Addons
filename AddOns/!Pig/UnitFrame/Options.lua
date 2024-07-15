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
---
local UnitFramefun={}
addonTable.UnitFramefun=UnitFramefun
local fuFrame = PIGOptionsList(L["UNIT_TABNAME"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
--
local zishenF,zishentabbut =PIGOptionsList_R(RTabFrame,L["UNIT_TABNAME1"],90)
zishenF:Show()
zishentabbut:Selected()
--------
zishenF.Plus=PIGCheckbutton_R(zishenF,{"耐久/移速","在系统默认头像上增加耐久/移速提示！"})
zishenF.Plus:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PlayerFrame"]["Plus"]=true;
		UnitFramefun.Zishen()
	else
		PIGA["UnitFrame"]["PlayerFrame"]["Plus"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
zishenF.Loot=PIGCheckbutton_R(zishenF,{"拾取方式","在系统默认头像上增加拾取方式提示！"})
zishenF.Loot:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PlayerFrame"]["Loot"]=true;
		UnitFramefun.Zishen()
	else
		PIGA["UnitFrame"]["PlayerFrame"]["Loot"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
zishenF.HPFF=PIGCheckbutton_R(zishenF,{"额外血量框架","在自身头像右侧显示额外血量框架.\n额外血量框架可能会和目标头像框架重叠，开启此选项后可能会右移目标头像"})
zishenF.HPFF:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PlayerFrame"]["HPFF"]=true;
		UnitFramefun.Zishen()
	else
		PIGA["UnitFrame"]["PlayerFrame"]["HPFF"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
zishenF:HookScript("OnShow", function(self)
	self.Plus:SetChecked(PIGA["UnitFrame"]["PlayerFrame"]["Plus"])
	self.Loot:SetChecked(PIGA["UnitFrame"]["PlayerFrame"]["Loot"])
	self.HPFF:SetChecked(PIGA["UnitFrame"]["PlayerFrame"]["HPFF"])
end)
----------------------
local duiyouF =PIGOptionsList_R(RTabFrame,L["UNIT_TABNAME2"],90)
duiyouF.Plus=PIGCheckbutton_R(duiyouF,{"职业图标/等级","在队友头像上显示职业图标/等级\r|cff00FFFF小提示：|r\r队友职业图标可以点击，"..KEY_BUTTON1.."观察/"..KEY_BUTTON2.."交易。"})
duiyouF.Plus:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PartyMemberFrame"]["Plus"]=true;
		UnitFramefun.Duiyou()
	else
		PIGA["UnitFrame"]["PartyMemberFrame"]["Plus"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
duiyouF.HPFF=PIGCheckbutton_R(duiyouF,{"额外血量框架","在队友头像上显示额外血量框架"})
duiyouF.HPFF:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PartyMemberFrame"]["HPFF"]=true;
		UnitFramefun.Duiyou()
	else
		PIGA["UnitFrame"]["PartyMemberFrame"]["HPFF"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
duiyouF.Buff=PIGCheckbutton_R(duiyouF,{"常驻显示BUFF","在队友头像上常驻显示队友BUFF"})
duiyouF.Buff:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PartyMemberFrame"]["Buff"]=true;
		UnitFramefun.Duiyou()
	else
		PIGA["UnitFrame"]["PartyMemberFrame"]["Buff"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
duiyouF.ToToT=PIGCheckbutton_R(duiyouF,{"显示队友目标","在队友头像上显示队友目标"})
duiyouF.ToToT:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["PartyMemberFrame"]["ToToT"]=true;
		UnitFramefun.Duiyou()
	else
		PIGA["UnitFrame"]["PartyMemberFrame"]["ToToT"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
duiyouF:HookScript("OnShow", function(self)
	self.Plus:SetChecked(PIGA["UnitFrame"]["PartyMemberFrame"]["Plus"])
	self.HPFF:SetChecked(PIGA["UnitFrame"]["PartyMemberFrame"]["HPFF"])
	self.Buff:SetChecked(PIGA["UnitFrame"]["PartyMemberFrame"]["Buff"])
	self.ToToT:SetChecked(PIGA["UnitFrame"]["PartyMemberFrame"]["ToToT"])
end)
-------------------
local mubiaoF =PIGOptionsList_R(RTabFrame,L["UNIT_TABNAME3"],90)
mubiaoF.PlusText = {"血量百分比/职业/种族","显示目标血量百分比/职业/种族！\r|cff00FFFF小提示：|r\r目标职业图标可以点击，"..KEY_BUTTON1.."观察/"..KEY_BUTTON2.."交易"}
if tocversion<30000 then
	mubiaoF.PlusText= {"血量/血量百分比/职业/种族","显示目标血量/血量百分比/职业/种族！\r|cff00FFFF小提示：|r\r目标职业图标可以点击，"..KEY_BUTTON1.."观察/"..KEY_BUTTON2.."交易"}
end
mubiaoF.Plus=PIGCheckbutton_R(mubiaoF,mubiaoF.PlusText)
mubiaoF.Plus:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["TargetFrame"]["Plus"]=true;
		UnitFramefun.Mubiao()
	else
		PIGA["UnitFrame"]["TargetFrame"]["Plus"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
if tocversion<50000 then
	mubiaoF.Chouhen=PIGCheckbutton_R(mubiaoF,{"仇恨值/仇恨高亮/仇恨目录","显示目标的仇恨值/仇恨高亮/仇恨目录"})
	mubiaoF.Chouhen:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["UnitFrame"]["TargetFrame"]["Chouhen"]=true;
			UnitFramefun.Mubiao()
		else
			PIGA["UnitFrame"]["TargetFrame"]["Chouhen"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
end
mubiaoF.ToToToT=PIGCheckbutton_R(mubiaoF,{"显示目标的目标的目标","显示目标的目标的目标（注意：请先打开系统的目标的目标）"})
mubiaoF.ToToToT:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["TargetFrame"]["ToToToT"]=true;
		UnitFramefun.Mubiao()
	else
		PIGA["UnitFrame"]["TargetFrame"]["ToToToT"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
mubiaoF.Yisu=PIGCheckbutton_R(mubiaoF,{"显示移动速度","显示目标移动速度"})
mubiaoF.Yisu:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["TargetFrame"]["Yisu"]=true;
		UnitFramefun.Mubiao()
	else
		PIGA["UnitFrame"]["TargetFrame"]["Yisu"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
local function BigDebuff()
	if PIGA["UnitFrame"]["TargetFrame"]["BigDebuff"] then
		if tocversion<50000 then
			TargetFrameToT:SetPoint("BOTTOMRIGHT", TargetFrame, "BOTTOMRIGHT", -4, -12);
			hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(self, debuffName, index)
				local buff = _G[debuffName..index];
				local _, _, _, _, _, _, caster = UnitDebuff(self.unit, index)
				if caster == "player" then
					buff:SetSize(30,30)
				end
			end)
		else
			hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, buff)
				local auraInstanceID = buff.auraInstanceID
				local UnitP = C_UnitAuras.GetAuraDataByAuraInstanceID("target", auraInstanceID)
				if UnitP["sourceUnit"] == "player" then
					buff:SetSize(30,30)
				end
			end)
		end
	end
end
mubiaoF.BigDebuff=PIGCheckbutton_R(mubiaoF,{"增大自身释放的DEBUFF","增大自身释放的DEBUFF图标"})
mubiaoF.BigDebuff:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["UnitFrame"]["TargetFrame"]["BigDebuff"]=true;
		BigDebuff()
	else
		PIGA["UnitFrame"]["TargetFrame"]["BigDebuff"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
mubiaoF:HookScript("OnShow", function(self)
	self.Plus:SetChecked(PIGA["UnitFrame"]["TargetFrame"]["Plus"])
	if self.Chouhen then
		self.Chouhen:SetChecked(PIGA["UnitFrame"]["TargetFrame"]["Chouhen"])
	end
	self.ToToToT:SetChecked(PIGA["UnitFrame"]["TargetFrame"]["ToToToT"])
	self.Yisu:SetChecked(PIGA["UnitFrame"]["TargetFrame"]["Yisu"])
	self.BigDebuff:SetChecked(PIGA["UnitFrame"]["TargetFrame"]["BigDebuff"])
end)
--==================================
addonTable.UnitFrame = function()
	UnitFramefun.Zishen()
	UnitFramefun.Duiyou()
	UnitFramefun.Mubiao()
	BigDebuff()
end