local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local FontUrl=Create.FontUrl
local PIGSetFont=Create.PIGSetFont
-------------------
local BGColor={0.1, 0.1, 0.1, 0.8}
local BorderColor={0, 0, 0, 1}
local BorderColor_OnEnter={0, 0.8, 1, 0.9}
local TextColor={1, 0.843, 0, 1}
local TextColor_Disable={0.5, 0.5, 0.5, 1}
local function BackdropSet(self)
	self:SetBackdrop(Create.Backdropinfo)
	self:SetBackdropColor(BGColor[1],BGColor[2],BGColor[3],BGColor[4]);
	self:SetBackdropBorderColor(BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4]);
end
local function add_ButtonUI(MODE,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	local But
	if MODE then
		But = CreateFrame("Button",UIName,fuF, "UIPanelButtonTemplate",id);
		But:SetText(Text);
		Point[5]=Point[5]-2
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
				self.Text:SetTextColor(TextColor[1], TextColor[2], TextColor[3], TextColor[4]);
			else
				self.Text:SetTextColor(TextColor_Disable[1], TextColor_Disable[2], TextColor_Disable[3], TextColor_Disable[4]);
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
function Create.PIGButton(fuF,Point,WH,Text,UIName,id,TemplateP,Zihao,Angle)--,nil,nil,nil,nil,0
	if Angle==0 then
		if ElvUI or NDui then
			return add_ButtonUI(false,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
		else
			return add_ButtonUI(true,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
		end
	elseif Angle==1 then
		return add_ButtonUI(true,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	else
		return add_ButtonUI(false,fuF,Point,WH,Text,UIName,id,TemplateP,Zihao)
	end
end
function Create.PIGCloseBut(fuF,Point,WH,UIName,TemplateP)
	local WH = WH or {22,22}
	local But = CreateFrame("Button",UIName,fuF,TemplateP);
	But:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp")
	But:SetSize(WH[1],WH[2])
	if Point then
		But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5])
	end
	But.Tex = But:CreateTexture(nil, "BORDER");
	But.Tex:SetTexture("interface/common/voicechat-muted.blp");
	But.Tex:SetSize(But:GetWidth()-8,But:GetHeight()-8);
	But.Tex:SetPoint("CENTER",0,0);
	But:HookScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",-1.5,-1.5);
	end);
	But:HookScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER");
	end);
	But:HookScript("PostClick", function (self)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
	end);
	return But
end
function Create.PIGTabBut(fuF,Point,WH,Text,UIName)
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
function Create.PIGSlider(fuF,Point,WH,minmaxSet,tooltip,UIName)
	local tooltip = tooltip or "拖动滑块或者用鼠标滚轮调整数值";
	local Slider = CreateFrame("Slider", UIName, fuF, "OptionsSliderTemplate")
	Slider:SetSize(WH[1],WH[2]);
	Slider:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	Slider.tooltipText = tooltip
	Slider.Low:SetFont(FontUrl,14)
	Slider.High:SetFont(FontUrl,14)
	Slider.Text:SetFont(FontUrl,14)
	Slider.Low:SetText(minmaxSet[1]);
	Slider.High:SetText(minmaxSet[2]);
	Slider:SetMinMaxValues(minmaxSet[1], minmaxSet[2]);
	Slider:SetValueStep(minmaxSet[3]);
	Slider:SetObeyStepOnDrag(true);
	Slider:EnableMouseWheel(true);
	Slider:HookScript("OnMouseWheel", function(self, arg1)
		if self:IsEnabled() then
			local Value = self:GetValue()
			--local val = floor(val*100+0.5)*0.01
			local step = minmaxSet[3] * arg1
			if step > 0 then
				self:SetValue(min(Value + step, minmaxSet[2]))
			else
				self:SetValue(max(Value + step, minmaxSet[1]))
			end
		end
	end)
	function Slider:PIGSetValue(chushiV,danweiT)
		local chushiV = chushiV or 1
		self:SetValue(chushiV);
		if danweiT then
			self.Text:SetText(chushiV..danweiT);
		else
			self.Text:SetText(chushiV);
		end
		self:SetScript("OnValueChanged", function(self)
			self:OnValueFun()
		end)
	end
	return Slider
end
-- function Create.PIGSlider(fuF,Point,WH,minmaxSet,tooltip,UIName)
-- 	local tooltip = tooltip or "拖动滑块或者用鼠标滚轮调整数值";
-- 	local Slider = CreateFrame("Slider", UIName, fuF, "MinimalSliderWithSteppersTemplate")--"OptionsSliderTemplate"
-- 	--Slider:SetSize(WH[1],WH[2]);
-- 	Slider.Slider:SetWidth(WH[1]+100);
-- 	Slider.Slider:SetHeight(WH[2]-14);
-- 	Slider:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
-- 	-- Slider.tooltipText = tooltip
-- 	-- -- Slider.TopText:SetFont(FontUrl,14)
-- 	-- -- Slider.TopText:SetText(minmaxSet[2]);
-- 	-- -- Slider.TopText:Show();
-- 	-- -- Slider.LeftText:SetFont(FontUrl,14)
-- 	-- -- Slider.LeftText:SetText(minmaxSet[1]);
-- 	-- -- Slider.LeftText:Show();
-- 	-- Slider.RightText:SetFont(FontUrl,14)
-- 	-- Slider.RightText:SetText(minmaxSet[2]);
-- 	-- --Slider.RightText:Show();
-- 	-- -- Slider.High:SetFont(FontUrl,14)
-- 	-- -- Slider.Text:SetFont(FontUrl,14)
-- 	-- -- Slider.High:SetText(minmaxSet[2]);
-- 	-- Slider:SetMinMaxValues(minmaxSet[1], minmaxSet[2]);
-- 	-- Slider:SetValueStep(minmaxSet[3]);
-- 	Slider:SetObeyStepOnDrag(true);
-- 	-- Slider:EnableMouseWheel(true);
-- 	-- Slider:SetEnabled(true)
-- 	-- -- hooksecurefunc(Slider, "Enable", function(self)
-- 	-- -- 	self.Low:SetTextColor(1, 1, 1, 1);
-- 	-- -- 	self.High:SetTextColor(1, 1, 1, 1);
-- 	-- -- 	--self.Text:SetTextColor(1, 1, 1, 1);
-- 	-- -- end)
-- 	-- -- hooksecurefunc(Slider, "Disable", function(self)
-- 	-- -- 	self.Low:SetTextColor(0.2, 0.2, 0.2, 1);
-- 	-- -- 	self.High:SetTextColor(0.2, 0.2, 0.2, 1);
-- 	-- -- 	--self.Text:SetTextColor(0.2, 0.2, 0.2, 1);
-- 	-- -- end)
-- 	-- Slider:Init(value, minValue, maxValue, steps, formatters)
-- 	-- Slider:HookScript("OnMouseWheel", function(self, arg1)
-- 	-- 	if self:IsEnabled() then
-- 	-- 		local Value = self:GetValue()
-- 	-- 		--local val = floor(val*100+0.5)*0.01
-- 	-- 		local step = minmaxSet[3] * arg1
-- 	-- 		if step > 0 then
-- 	-- 			self:SetValue(min(Value + step, minmaxSet[2]))
-- 	-- 		else
-- 	-- 			self:SetValue(max(Value + step, minmaxSet[1]))
-- 	-- 		end
-- 	-- 	end
-- 	-- end)
-- 	function Slider:PIGSetValue(chushiV,danweiT)
-- 		-- local chushiV = chushiV or 1
-- 		-- self:SetValue(chushiV);
-- 		-- if danweiT then
-- 		-- 	self.RightText:SetText(chushiV..danweiT);
-- 		-- else
-- 		-- 	self.RightText:SetText(chushiV);
-- 		-- end
-- 		-- self:SetScript("OnValueChanged", function(self)
-- 		-- 	self:OnValueFun()
-- 		-- end)
-- 	end
-- 	return Slider
-- end
local morenColor = {
	{0.1,0.1,0.1},
	{BorderColor[1], BorderColor[2], BorderColor[3], BorderColor[4]},
	{1,0.7,0},
}
function Create.PIGCheckbutton(fuF,Point,Text,WH,UIName,id)
	local WH = WH or {18,18}
	local But = CreateFrame("CheckButton", UIName, fuF,"BackdropTemplate",id);
	But:SetBackdrop({bgFile = Create.bgFile,edgeFile = Create.edgeFile, edgeSize = 8,insets = { left = 0.4, right = 0.4, top = 0.4, bottom = 0.4 }})
	But:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
	But:SetBackdropBorderColor(unpack(morenColor[2]));
	But:SetSize(WH[1],WH[2])
	if Point then
		But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5])
	end
	But:SetMotionScriptsWhileDisabled(true)

	But.Hilight = But:CreateTexture(nil, "HIGHLIGHT");
	But.Hilight:SetTexture("Interface/Buttons/ButtonHilight-Square");
	But.Hilight:SetPoint("TOPLEFT",But,"TOPLEFT", 1, -1)
	But.Hilight:SetPoint("BOTTOMRIGHT",But,"BOTTOMRIGHT", -1, 1)
	But.Hilight:SetBlendMode("ADD")
	But.Text = But:CreateFontString()
	But.Text:SetPoint("LEFT",But,"RIGHT", 2, 0)
	PIGSetFont(But.Text,Zihao,Miaobian)
	if Text then
		But.Text:SetText(Text[1]);
		But.tooltip = Text[2]
	end
	local wrappedWidth = But.Text:GetWrappedWidth()
	But:SetHitRectInsets(0,-wrappedWidth,0,0)
	hooksecurefunc(But, "SetChecked", function(self,bool)
		--if bool and self:IsEnabled() then
		if bool then
			self:SetBackdropColor(morenColor[3][1],morenColor[3][2],morenColor[3][3],1);
		else
			self:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
		end
	end)
	hooksecurefunc(But, "Enable", function(self)
		if self:GetChecked() then
			self:SetBackdropColor(morenColor[3][1],morenColor[3][2],morenColor[3][3],1);
		else
			self:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
		end
		self:SetBackdropBorderColor(unpack(morenColor[2]));
		self.Text:SetTextColor(1, 1, 1, 1);
	end)
	hooksecurefunc(But, "Disable", function(self)
		if self:GetChecked() then
			self:SetBackdropColor(morenColor[3][1],morenColor[3][2],morenColor[3][3],0.5);
		else
			self:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
		end
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1);
		self.Text:SetTextColor(TextColor_Disable[1], TextColor_Disable[2], TextColor_Disable[3], TextColor_Disable[4])
	end)
	But:HookScript("OnEnter", function(self)
		if ( self.tooltip ) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true);
			GameTooltip:Show();
		end
	end);
	But:HookScript("OnLeave", function(self)
		GameTooltip:ClearLines();
		GameTooltip:Hide()
	end);
	But:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(1, 1, 0, 1)
			--self.Text:SetPoint("LEFT",self,"RIGHT", 3, -1)
		end
	end);
	But:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(unpack(morenColor[2]))
			--self.Text:SetPoint("LEFT",self,"RIGHT", 2, 0)	
		end
	end);
	But:SetScript("PostClick",  function (self)
		if self:GetChecked() then
			self:SetBackdropColor(morenColor[3][1],morenColor[3][2],morenColor[3][3],1);
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			self:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
	end);
	return But
end

--自动排列选择框
function Create.PIGCheckbutton_R(fuF,text,vertical,lienum,Vjiange,WH,UIName)
	local lienum=lienum or 11
	local Vjiange=Vjiange or 40
	local fujiinfo = {fuF:GetChildren()}
	local yiyoushu = #fujiinfo
	local Checkbutton = Create.PIGCheckbutton(fuF,Point,text,WH,UIName)
	if yiyoushu==0 then
		Checkbutton:SetPoint("TOPLEFT",fuF,"TOPLEFT",20,-20);
	else
		if vertical then
			local tmp1,tmp2 = math.modf(yiyoushu/lienum)
			if tmp2==0 then
				Checkbutton:SetPoint("TOPLEFT",fujiinfo[1],"TOPLEFT",300,0);
			else
				Checkbutton:SetPoint("TOPLEFT",fujiinfo[yiyoushu],"TOPLEFT",0,-Vjiange);
			end
		else
			local tmp1,tmp2 = math.modf(yiyoushu/2)
			if tmp2==0 then
				Checkbutton:SetPoint("TOPLEFT",fujiinfo[yiyoushu-1],"TOPLEFT",0,-Vjiange);
			else 
				Checkbutton:SetPoint("TOPLEFT",fujiinfo[yiyoushu],"TOPLEFT",300,0);
			end
		end
	end
	return Checkbutton
end
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
	local TabBut = Create.PIGTabBut(fuUI,nil,{tabbutWW,List_ButH},GnName)
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
--右边子菜单
function Create.PIGOptionsList_RF(fuF,DownY,Mode,bianjuV)
	local TabF = Create.PIGFrame(fuF)
	TabF:PIGSetBackdrop()
	local bianjuV = bianjuV or {6,6,6}
	if Mode=="Left" then bianjuV = {0,0,0} end
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
	fuF.Top.tabbut = Create.PIGTabBut(fuF.Top,nil,{newWH[1],newWH[2]},tabname)
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