local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local PIGEnter=Create.PIGEnter
--创建功能动作条按钮
local WowHeight=GetScreenHeight();
function Create.PIGQuickBut(QkButUI,Tooltip,Icon,GnUI,FrameLevel,Template)
	local fuji = QuickButUI
	local nr = fuji.nr
	local butW = nr:GetHeight()
	local Children = {nr:GetChildren()};
	local geshu = #Children;
	local But = CreateFrame("Button", QkButUI, nr, Template);
	But:RegisterForClicks("LeftButtonUp","RightButtonUp")
	But:SetNormalTexture(Icon)
	But:SetHighlightTexture(130718);
	But:SetSize(butW-2,butW-2);
	if geshu==0 then
		But:SetPoint("LEFT",nr,"LEFT",0,0);
	else
		But:SetPoint("LEFT",Children[geshu],"RIGHT",2,0);
	end
	But:HookScript("OnEnter", function(self)
		GameTooltip:ClearLines();
		local offset1 = But:GetBottom();
		if offset1>(WowHeight*0.5) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",-20,0);
		else
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		end
		GameTooltip:AddLine(Tooltip, nil, nil, nil, true)
		GameTooltip:Show();
	end);
	But:HookScript("OnLeave", function()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
	But.Down = But:CreateTexture(nil, "OVERLAY");
	But.Down:SetTexture(130839);
	But.Down:SetAllPoints(But)
	But.Down:Hide();
	But:HookScript("OnMouseDown", function (self)
		self.Down:Show();
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
	But:HookScript("OnMouseUp", function (self)
		self.Down:Hide();
	end);
	But.Height = But:CreateTexture(nil, "OVERLAY");
	But.Height:SetTexture(130724);
	But.Height:SetBlendMode("ADD");
	But.Height:SetAllPoints(But)
	But.Height:Hide()
	if GnUI then
		But:HookScript("OnClick", function(self,button)
			if button=="LeftButton" then
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
				if _G[GnUI]:IsShown() then
					_G[GnUI]:Hide();
				else
					_G[GnUI]:SetFrameLevel(FrameLevel)
					_G[GnUI]:Show();
				end
			end
		end)
	end
	fuji:GengxinWidth()
	return But
end
--创建侧面功能按钮
function Create.PIGModbutton(GnTooltip,GnIcon,GnUI,FrameLevel)
	local nr = Pig_OptionsUI.ListFun
	local butW = nr:GetWidth()
	local But = CreateFrame("Button", nil, nr);
	But:SetNormalTexture(GnIcon)
	But:SetHighlightTexture(130718);
	But:SetSize(butW-10,butW-10);
	local Children = {nr:GetChildren()};
	local geshu = #Children;
	But:SetPoint("TOP",nr,"TOP",0,-((geshu-1)*(butW)+8));
	PIGEnter(But,GnTooltip)
	But.Down = But:CreateTexture(nil, "OVERLAY");
	But.Down:SetTexture(130839);
	But.Down:SetAllPoints(But)
	But.Down:Hide();
	But:HookScript("OnMouseDown", function (self)
		self.Down:Show();
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
	But:HookScript("OnMouseUp", function (self)
		self.Down:Hide();
	end);
	But.Height = But:CreateTexture(nil, "OVERLAY");
	But.Height:SetTexture(130724);
	But.Height:SetBlendMode("ADD");
	But.Height:SetAllPoints(But)
	But.Height:Hide()
	if GnUI then
		But:HookScript("OnClick", function(self,button)
			if _G[GnUI]:IsShown() then
				_G[GnUI]:Hide();
			else
				Pig_OptionsUI:Hide()
				_G[GnUI]:SetFrameLevel(FrameLevel)
				_G[GnUI]:Show();
			end
		end)
	end
	return But
end
--创建选项按钮
function Create.PIGModCheckbutton(fuF,text,Point)
	local But = Create.PIGCheckbutton(fuF,nil,text)
	But:SetPoint(unpack(Point))
	local text1 = {string.format(L["ACTION_ADDQUICKBUT"],text[1]),string.format(L["ACTION_ADDQUICKBUTTIS"],text[1])}
	But.QKBut = Create.PIGCheckbutton(But,{"LEFT",But,"RIGHT",220,0},text1)
	return But
end