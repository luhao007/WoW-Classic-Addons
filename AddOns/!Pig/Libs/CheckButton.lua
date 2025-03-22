local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local FontUrl=Create.FontUrl
local PIGSetFont=Create.PIGSetFont
-------------------
local morenColor = {
	{0.1,0.1,0.1},
	{1, 0.6, 0, 1},
	{1,0.7,0},
}
local er, eg, eb = 1,1,1 or NORMAL_FONT_COLOR:GetRGB()
local dr, dg, db = GRAY_FONT_COLOR:GetRGB()
local function add_Checkbutton(mode,fuF,Point,Text,WH,UIName,id)
	local WH = WH or {18,18}
	WH[2] = WH[2] or WH[1]
	local But = CreateFrame("CheckButton", UIName, fuF,"BackdropTemplate",id);
	if mode then
		But:SetNormalAtlas("checkbox-minimal")
		But:SetCheckedTexture("checkmark-minimal")
		But:SetDisabledCheckedTexture("checkmark-minimal-disabled")
		But:SetSize(WH[1]+2,WH[2]+2)
	else
		But:SetBackdrop({bgFile = Create.bgFile,edgeFile = Create.edgeFile, edgeSize = 8,insets = { left = 0.4, right = 0.4, top = 0.4, bottom = 0.4 }})
		But:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
		But:SetBackdropBorderColor(unpack(morenColor[2]));
		But:SetSize(WH[1],WH[2])
	end
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
		But.tooltip = Text[2] or Text[1]
	end
	local wrappedWidth = But.Text:GetWrappedWidth()
	But:SetHitRectInsets(0,-wrappedWidth,0,0)
	hooksecurefunc(But, "SetChecked", function(self,bool)
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
		self.Text:SetTextColor(er, eg, eb, 1);
	end)
	hooksecurefunc(But, "Disable", function(self)
		if self:GetChecked() then
			self:SetBackdropColor(morenColor[3][1],morenColor[3][2],morenColor[3][3],0.5);
		else
			self:SetBackdropColor(morenColor[1][1],morenColor[1][2],morenColor[1][3],1);
		end
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1);
		self.Text:SetTextColor(dr, dg, db, 1)
	end)
	hooksecurefunc(But, "SetEnabled", function(self,bool)
		if bool then
			self:Enable()
		else
			self:Disable();
		end
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
function Create.PIGCheckbutton(fuF,Point,Text,WH,UIName,id,mode)--,nil,nil,nil,nil,0
	if mode==0 then
		if ElvUI or NDui then
			return add_Checkbutton(false,fuF,Point,Text,WH,UIName,id)
		else
			return add_Checkbutton(true,fuF,Point,Text,WH,UIName,id)
		end
	elseif mode==1 then
		return add_Checkbutton(true,fuF,Point,Text,WH,UIName,id)
	else
		return add_Checkbutton(false,fuF,Point,Text,WH,UIName,id)
	end
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