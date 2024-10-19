local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create = addonTable.Create
local FontUrl=Create.FontUrl
local PIGSetFont=Create.PIGSetFont
-- local PIGButton = Create.PIGButton
-- local PIGDiyBut = Create.PIGDiyBut
-- local PIGDownMenu=Create.PIGDownMenu
-- local PIGSlider = Create.PIGSlider
-- local PIGCheckbutton=Create.PIGCheckbutton
-- local PIGCheckbutton_R=Create.PIGCheckbutton_R
-- local PIGOptionsList=Create.PIGOptionsList
-- local PIGOptionsList_RF=Create.PIGOptionsList_RF
-- local PIGOptionsList_R=Create.PIGOptionsList_R
-- local Show_TabBut_R=Create.Show_TabBut_R
-- local PIGQuickBut=Create.PIGQuickBut
-------------------
local BGColor={0.1, 0.1, 0.1, 0.8}
local BorderColor={0, 0, 0, 1}
local BorderColor_OnEnter={0, 0.8, 1, 0.9}
local TextColor={1, 0.843, 0, 1}
local dr, dg, db= GRAY_FONT_COLOR:GetRGB()
local TextColor_Disable={dr, dg, db, 1}
local function BackdropSet(self)
	self:SetBackdrop(Create.Backdropinfo)
	self:SetBackdropColor(BGColor[1],BGColor[2],BGColor[3],BGColor[4]);
	self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4]);
end
local function add_Button(MODE,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	local But
	if MODE then
		local Templatepig= "UIPanelButtonTemplate"
		-- if tocversion>110000 then
		-- 	Templatepig= "SharedButtonTemplate"
		-- end
		But = CreateFrame("Button",UIName,fuF,Templatepig ,id);
		
		But:SetText(Text);
		local buttonFont=But:GetFontString()
		But.Text=buttonFont
		function But:PIGHighlight()
			self.Highlight = self:CreateTexture(nil, "OVERLAY");
			self.Highlight:SetTexture(130724);
			self.Highlight:SetBlendMode("ADD");
			self.Highlight:SetPoint("TOPLEFT", self, "TOPLEFT", 1.2, -2);
			self.Highlight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1.6, 1);
			function But:Selected(bot)
				if bot then
					PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
					self.Text:SetTextColor(1, 1, 1, 1)
					self.Highlight:Show()
				else
					self.Text:SetTextColor(1, 0.843, 0, 1)
					self.Highlight:Hide()
				end
			end
		end
	else
		local TemplateP = TemplateP or "BackdropTemplate,"
		But = CreateFrame("Button", UIName, fuF,TemplateP,id);
		But:RegisterForClicks("LeftButtonUp","RightButtonUp")
		BackdropSet(But)
		function But:PIGSetBackdrop(BGAlpha,BorderAlpha)
			self:SetBackdropColor(BGColor[1],BGColor[2],BGColor[3], BGAlpha);
			self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderAlpha);
		end
		But:HookScript("OnEnter", function(self)
			if self:IsEnabled() then
				self:SetBackdropBorderColor(BorderColor_OnEnter[1], BorderColor_OnEnter[2], BorderColor_OnEnter[3], BorderColor_OnEnter[4]);
			end
		end);
		But:HookScript("OnLeave", function(self)
			if self:IsEnabled() then
				self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4]);
			end
		end);
		hooksecurefunc(But, "Enable", function(self)
			self.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4]);
		end)
		hooksecurefunc(But, "Disable", function(self)
			self.Text:SetTextColor(TextColor_Disable[1], TextColor_Disable[2], TextColor_Disable[3], TextColor_Disable[4]);
		end)
		hooksecurefunc(But, "SetEnabled", function(self,bool)
			if bool then
				self:Enable()
			else
				self:Disable()
			end
		end)
		But:HookScript("OnMouseDown", function(self)
			if self:IsEnabled() then
				self.Text:SetPoint("CENTER", 1.5, -1.5);
			end
		end);
		But:HookScript("OnMouseUp", function(self)
			if self:IsEnabled() then
				self.Text:SetPoint("CENTER", 0, 0);
			end
		end);
		function But:SetText(TextN)
			self.Text:SetText(TextN);
		end
		function But:GetText()
			return self.Text:GetText();
		end
		function But:Selected(bot)
			if bot then
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
				self.Text:SetTextColor(1, 1, 1, 1)
				self:SetBackdropColor(0.32,0.1647,0.0353, 0.8)
				self:SetBackdropBorderColor(1, 1, 0, 1)
			else
				self.Text:SetTextColor(1, 0.843, 0, 1)
				self:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
				self:SetBackdropBorderColor(0, 0, 0, 1)
			end
		end
		But:HookScript("PostClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
		end)
		But.Text = But:CreateFontString();
		But.Text:SetPoint("CENTER", 0, 0);
		PIGSetFont(But.Text,Zihao,Miaobian)
		But.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4]);
		But.Text:SetText(Text)
	end
	if WH then
		But:SetSize(WH[1],WH[2]);
	end
	if Point then
		But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	end
	return But
end
function Create.PIGButton(fuF,Point,WH,Text,UIName,id,TemplateP,Zihao,mode)--,nil,nil,nil,nil,0
	if mode==0 then
		if ElvUI or NDui then
			return add_Button(false,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
		else
			return add_Button(true,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
		end
	elseif mode==1 then
		return add_Button(true,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	else
		return add_Button(false,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	end
end
---自定义材质按钮
function Create.PIGDiyBut(fuF,Point,WH,UIName,TemplateP)
	local Www = WH and WH[1] or 22
	local Hhh = WH and WH[2] or Www
	local WwwTex = WH and WH[3] or Www-8
	local HhhTex = WH and WH[4] or WwwTex
	local icontex = WH and WH[5] or 130976
	local But = CreateFrame("Button",UIName,fuF,TemplateP);
	But:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	But:SetSize(Www,Hhh)
	if Point then
		But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5])
	end
	But.icon = But:CreateTexture(nil, "BORDER");
	if type(icontex)=="number" then
		But.icon:SetTexture(icontex);
	else
		But.icon:SetAtlas(icontex)
	end
	But.icon:SetPoint("CENTER",0,0);
	if ElvUI or NDui then
		But.icon:SetSize(WwwTex-2,HhhTex-2);
		But.icon:SetTexCoord(0.17,0.83,0.17,0.83);
	else
		But.icon:SetSize(WwwTex,HhhTex);
	end
	hooksecurefunc(But, "Enable", function(self)
		self.icon:SetDesaturated(false)
	end)
	hooksecurefunc(But, "Disable", function(self)
		self.icon:SetDesaturated(true)
	end)
	hooksecurefunc(But, "SetEnabled", function(self,bool)
		if bool then
			self:Enable()
		else
			self:Disable()
		end
	end)
	But:HookScript("OnMouseDown", function (self)
		if self:IsEnabled() then
			self.icon:SetPoint("CENTER",-1.5,-1.5);
		end
	end);
	But:HookScript("OnMouseUp", function (self)
		self.icon:SetPoint("CENTER");
	end);
	But:HookScript("PostClick", function (self)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
	end);
	return But
end
local function PIGTabBut(fuF,Point,WH,Text,UIName)
	local But = CreateFrame("Button", UIName, fuF,"BackdropTemplate")
	But.Show=false;
	BackdropSet(But)
	if WH then But:SetSize(WH[1],WH[2]) end
	if Point then
		But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5])
	end
	hooksecurefunc(But, "Enable", function(self)
		self.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4])
	end)
	hooksecurefunc(But, "Disable", function(self)
		self.Text:SetTextColor(TextColor_Disable[1], TextColor_Disable[2], TextColor_Disable[3], TextColor_Disable[4])
	end)
	hooksecurefunc(But, "SetEnabled", function(self,bool)
		if bool then
			self:Enable()
		else
			self:Disable()
		end
	end)
	But:HookScript("OnEnter", function(self)
		if self:IsEnabled() and not self.Show then
			self:SetBackdropBorderColor(BorderColor_OnEnter[1], BorderColor_OnEnter[2], BorderColor_OnEnter[3], BorderColor_OnEnter[4])
		end
	end);
	But:HookScript("OnLeave", function(self)
		if self:IsEnabled() and not self.Show then
			self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4])
		end
	end);
	But:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() and not self.Show then
			self.Text:SetPoint("CENTER", 1.5, -1.5)
		end
	end);
	But:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() and not self.Show then
			self.Text:SetPoint("CENTER", 0, 0)
		end
	end);
	But.Text = But:CreateFontString()
	But.Text:SetPoint("CENTER", 0, 0)
	PIGSetFont(But.Text,Zihao,Miaobian)
	But.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4])
	But.Text:SetText(Text);
	
	function But:Selected()
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
		self.Show=true;
		self.Text:SetTextColor(1, 1, 1, 1)
		--self:SetBackdropColor(0.3098,0.262745,0.0353, 1)
		self:SetBackdropColor(0.32,0.1647,0.0353, BGColor[4])
		self:SetBackdropBorderColor(1, 1, 0, 1)	
	end
	function But:NotSelected()
		self.Show=false
		self.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4])
		self:SetBackdropColor(BGColor[1],BGColor[2],BGColor[3],BGColor[4])
		self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4])
	end
	return But
end
Create.PIGTabBut=PIGTabBut
--左边主菜单
function Create.Show_TabBut(Rneirong,tabbut)---选择主菜单
	local PigUI=Rneirong:GetParent():GetParent():GetParent():GetParent()
	--local PigUI=fujiUI or Pig_OptionsUI
	local ListTOP = {PigUI.L.F.ListTOP:GetChildren()}
	for x=1, #ListTOP, 1 do
		ListTOP[x]:NotSelected()
	end
	if PigUI.L.F.ListEXT then
		local ListEXT = {PigUI.L.F.ListEXT:GetChildren()}
		for x=1, #ListEXT, 1 do
			ListEXT[x]:NotSelected()
		end
	end
	if PigUI.L.F.ListBOT then
		local ListBOT = {PigUI.L.F.ListBOT:GetChildren()}
		for x=1, #ListBOT, 1 do
			ListBOT[x]:NotSelected()
		end
	end
	local RNR = {PigUI.R.F.NR:GetChildren()}
	for x=1, #RNR, 1 do
		RNR[x]:Hide()
	end
	tabbut:Selected()
	Rneirong:Show()
end
function Create.PIGOptionsList(GnName,weizhi,fujiUI)
	local PigUI=fujiUI or Pig_OptionsUI
	local fuUI=PigUI.L.F.ListTOP
	local tabbutWW = fuUI:GetWidth()-6.8
	if weizhi=="EXT" then
		fuUI=PigUI.L.F.ListEXT
	elseif weizhi=="BOT" then
		fuUI=PigUI.L.F.ListBOT
		tabbutWW = 60
	end
	local List_ButH,jiange = 26,4
	local ziframe = {fuUI:GetChildren()}
	local zinum = #ziframe
	local TabBut = PIGTabBut(fuUI,nil,{tabbutWW,List_ButH},GnName)
	if weizhi=="BOT" then
		if zinum==0 then
			TabBut:SetPoint("LEFT", fuUI, "LEFT", 10, 0);
		else
			TabBut:SetPoint("LEFT", fuUI, "LEFT", (zinum*(tabbutWW+16)+10), 0);
		end
	else
		if zinum==0 then
			TabBut:SetPoint("TOP", fuUI, "TOP", 0, -jiange);
		else
			TabBut:SetPoint("TOP", fuUI, "TOP", 0, -(zinum*(List_ButH+2)+jiange));
		end
	end
	--内容页
	local Rneirong = CreateFrame("Frame", nil, PigUI.R.F.NR)
	Rneirong:SetAllPoints(PigUI.R.F.NR)
	Rneirong:Hide()
	if weizhi=="EXT" then
		Rneirong.UpdateVer = CreateFrame("Frame", nil, Rneirong)
		Rneirong.UpdateVer:SetSize(300,30);
		Rneirong.UpdateVer:SetPoint("CENTER", Rneirong, "CENTER", 0, 0);
		Rneirong.UpdateVer:SetFrameLevel(12)
		Rneirong.UpdateVer:Hide()
		Rneirong.UpdateVer.T=Create.PIGFontString(Rneirong.UpdateVer,{"CENTER",Rneirong.UpdateVer,"CENTER",0,0},GnName..Pig_OptionsUI.UpdateTXT,"OUTLINE",16);
		Rneirong.UpdateVer.T:SetTextColor(1,0,0,1)
	end
	---
	TabBut:HookScript("OnClick", function(self)
		Create.Show_TabBut(Rneirong,self)
	end)
	return Rneirong,TabBut
end
--次级菜单====
function Create.PIGOptionsList_RF(fuF,DownY,Mode,bianjuV)
	local TabF = Create.PIGFrame(fuF)
	TabF:PIGSetBackdrop()
	local bianjuV = bianjuV or {6,6,6}
	if Mode=="Left" then bianjuV = {0,0,0} end
	local DownY=DownY or 30
	TabF:SetPoint("TOPLEFT", fuF, "TOPLEFT", bianjuV[1], -DownY)
	TabF:SetPoint("BOTTOMRIGHT", fuF, "BOTTOMRIGHT", -bianjuV[2], bianjuV[3])
	TabF.Top = Create.PIGFrame(TabF)
	if Mode=="Left" then
		TabF.Top:SetWidth(1)
		TabF.Top:SetPoint("TOPRIGHT", TabF, "TOPLEFT", 0, 0)
		TabF.Top:SetPoint("BOTTOMLEFT", TabF, "BOTTOMLEFT", -30, 0)
	elseif Mode=="Bot" then
		TabF.Top:SetHeight(1)
		TabF.Top:SetPoint("TOPLEFT", TabF, "BOTTOMLEFT", 0, 0)
		TabF.Top:SetPoint("TOPRIGHT", TabF, "BOTTOMRIGHT", 0, -30)
	else
		TabF.Top:SetHeight(1)
		TabF.Top:SetPoint("BOTTOMLEFT", TabF, "TOPLEFT", 0, 0)
		TabF.Top:SetPoint("BOTTOMRIGHT", TabF, "TOPRIGHT", 0, 30)
	end
	TabF.Bot = Create.PIGFrame(TabF)
	TabF.Bot:SetPoint("TOPLEFT", TabF, "TOPLEFT", 0, 0)
	TabF.Bot:SetPoint("BOTTOMRIGHT", TabF, "BOTTOMRIGHT", 0, 0)
	return TabF
end
function Create.Show_TabBut_R(fuF,Rneirong,tabbut)---选择子菜单
	local RNR = {fuF.Bot:GetChildren()}
	for x=1, #RNR, 1 do
		RNR[x]:Hide()
	end
	local ListBOT = {fuF.Top:GetChildren()}
	for x=1, #ListBOT, 1 do
		ListBOT[x]:NotSelected()
	end
	tabbut:Selected()
	Rneirong:Show()
end
function Create.PIGOptionsList_R(fuF,tabname,W,Mode,UIName)
	local TAB_F = Create.PIGFrame(fuF.Bot,nil,nil,UIName)
	TAB_F:SetPoint("TOPLEFT", fuF.Bot, "TOPLEFT", 0, 0)
	TAB_F:SetPoint("BOTTOMRIGHT", fuF.Bot, "BOTTOMRIGHT", 0, 0)
	TAB_F:Hide()
	local ziframe = {fuF.Top:GetChildren()}
	local newWH = {W,24}
	if Mode=="Left" then newWH={24,W} end
	fuF.Top.tabbut = PIGTabBut(fuF.Top,nil,{newWH[1],newWH[2]},tabname)
	if Mode=="Left" then
		if #ziframe==0 then
			fuF.Top.tabbut:SetPoint("TOPRIGHT", fuF.Top, "TOPRIGHT", 1, -10);
		else
			fuF.Top.tabbut:SetPoint("TOP", ziframe[#ziframe], "BOTTOM", 0, -10);
		end
	elseif Mode=="Bot" then
		if #ziframe==0 then
			fuF.Top.tabbut:SetPoint("TOPLEFT", fuF.Top, "TOPLEFT", 10, 1);
		else
			fuF.Top.tabbut:SetPoint("LEFT", ziframe[#ziframe], "RIGHT", 10, 0);
		end
	else
		if #ziframe==0 then
			fuF.Top.tabbut:SetPoint("BOTTOMLEFT", fuF.Top, "BOTTOMLEFT", 10, -1);
		else
			fuF.Top.tabbut:SetPoint("LEFT", ziframe[#ziframe], "RIGHT", 10, 0);
		end
	end
	fuF.Top.tabbut:HookScript("OnClick", function(self)
		Create.Show_TabBut_R(fuF,TAB_F,self)
	end)
	return TAB_F,fuF.Top.tabbut
end