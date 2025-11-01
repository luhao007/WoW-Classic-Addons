local addonName, addonTable = ...;
local L=addonTable.locale
local Data = addonTable.Data
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter

--功能动作条
local UIname="PIG_QuickButUI"
Data.QuickButUIname=UIname
local QuickPData = {ActionButton1:GetWidth(),200,200}
if PIG_MaxTocversion() then
	QuickPData[1]=QuickPData[1]-10
else
	QuickPData[1]=QuickPData[1]-16
	QuickPData[2]=0
	QuickPData[3]=290
end
Data.UILayout[UIname]={"BOTTOM","BOTTOM",QuickPData[2],QuickPData[3]}
local QuickBut=PIGFrame(UIParent,nil,{QuickPData[1]+14,QuickPData[1]},UIname)
QuickBut:Hide()
QuickBut.ButList={}
function QuickBut:UpdateWidth()
	if self.nr then
		local butW = self.nr:GetHeight()
		local Children1 = {self.nr:GetChildren()};
		local yincangshunum=0
		for i=1,#Children1 do
			if Children1[i].yincang then
				Children1[i]:SetWidth(0.0001)
				yincangshunum=yincangshunum+1
			else
				local addW = Children1[i].addW or 0
				Children1[i]:SetWidth(butW-2+addW)
			end
		end
		local geshu1 = #Children1-yincangshunum
		if geshu1>0 then 
			self:Show()
			local NewWidth = butW*geshu1+2
			self:SetWidth(NewWidth+self.yidong:GetWidth())
		end
	end
end
function QuickBut:Add()
	QuickBut.ButList[1]()--[1]总开关
	-- [2]战场通报[3]饰品管理[4]符文管理[5]装备管理[6]插件管理
	-- [7]炉石/专业[8]职业辅助技能[9]角色信息统计
	-- [10]售卖助手丢弃[11]售卖助手开[12]售卖助手分[13]售卖助手选矿
	-- [19]AFK
	for i=2,19 do
		if self.ButList[i] then
			self.ButList[i]()
		end
	end
	-------
	-- [20]时空之门[21]时空之门喊话
	-- [30]开团助手
	-- [40]带本助手
	self:UpdateWidth()
end
--创建功能动作条按钮
local WowHeight=GetScreenHeight();
function Create.PIGQuickBut(QkButUI,Tooltip,Icon,ShowGnUI,FrameLevel,Template)
	local nr = QuickBut.nr
	local butW = nr:GetHeight()
	local Children = {nr:GetChildren()};
	local geshu = #Children;
	local But = CreateFrame("Button", QkButUI, nr, Template);
	But:RegisterForClicks("LeftButtonUp","RightButtonUp")
	if type(Icon)=="number" then
		But:SetNormalTexture(Icon)
	else
		But:SetNormalAtlas(Icon)
	end
	if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() then
		But:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	else
		But._BACKGROUND = But:CreateTexture(nil, "BACKGROUND");
		But._BACKGROUND:SetAtlas("search-iconframe-large");
		But._BACKGROUND:SetPoint("TOPLEFT", But, "TOPLEFT", -0.8, 0.8);
		But._BACKGROUND:SetPoint("BOTTOMRIGHT", But, "BOTTOMRIGHT", 0.8, -0.8);
	end
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
		PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
	end);
	But.Height = But:CreateTexture(nil, "OVERLAY");
	But.Height:SetTexture(130724);
	But.Height:SetBlendMode("ADD");
	But.Height:SetAllPoints(But)
	But.Height:Hide()
	if ShowGnUI then
		But:HookScript("OnClick", function(self,button)
			if button=="LeftButton" then
				if _G[ShowGnUI]:IsShown() then
					_G[ShowGnUI]:Hide();
				else
					_G[ShowGnUI]:SetFrameLevel(FrameLevel)
					_G[ShowGnUI]:Show();
				end
			end
		end)
	end
	QuickBut:UpdateWidth()
	return But
end
--创建功能开启选项+添加功能条按钮
function Create.PIGModCheckbutton(fuF,text,Point)
	local But = Create.PIGCheckbutton(fuF,nil,text)
	But:SetPoint(unpack(Point))
	local text1 = {string.format(L["ACTION_ADDQUICKBUT"],text[1]),string.format(L["ACTION_ADDQUICKBUTTIS"],text[1])}
	But.QKBut = Create.PIGCheckbutton(But,{"LEFT",But,"RIGHT",220,0},text1)
	return But
end
--创建侧面功能按钮
function Create.PIGModbutton(GnTooltip,GnIcon,GnUI,FrameLevel)
	local nr = PIG_OptionsUI.ListFun
	local butW = nr:GetWidth()
	local But = CreateFrame("Button", nil, nr);
	if type(GnIcon)=="number" then
		But:SetNormalTexture(GnIcon)
	else
		But:SetNormalAtlas(GnIcon)
	end
	But:GetNormalTexture():SetTexCoord(0.07,0.93,0.07,0.93);
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
		PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
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
				PIG_OptionsUI:Hide()
				_G[GnUI]:SetFrameLevel(FrameLevel)
				_G[GnUI]:Show();
			end
		end)
	end
	return But
end