local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L= unpack(PIG)
---------------------------------
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGModbutton=Create.PIGModbutton
local PIGSetFont=Create.PIGSetFont
-----------
local GetPIGID=Fun.GetPIGID
local TardisInfo=addonTable.TardisInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
function TardisInfo.ADD_UI()
	if not PIGA["Tardis"]["Open"] then return end
	if _G[GnUI] then return end
	local ModBut = PIGModbutton(GnName,GnIcon,GnUI,FrameLevel)
	--
	local Width,Height  = 880, 505;
	local InvF=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{Width, Height},GnUI,true)
	InvF:PIGSetBackdrop()
	InvF:PIGClose()
	InvF:PIGSetMovable()
	InvF.hang_Height,InvF.hang_NUM=25,15
	InvF.pindao="PIG"
	InvF.biaoti = PIGFontString(InvF,{"TOP", InvF, "TOP", 0, -4},GnName)
	--必须加入PIG频道获取
	local function gengxinbut1()
		local PIGxulieID =GetPIGID(InvF.pindao)
		if PIGxulieID>0 then
			InvF.jiaruchazhaoqi:Disable()
			InvF.jiaruchazhaoqi:SetText(L["TARDIS_LFG_LEAVE"]);
		else
			InvF.jiaruchazhaoqi:Enable()
			InvF.jiaruchazhaoqi:SetText(L["TARDIS_LFG_JOIN"]);
		end
	end
	InvF.jiaruchazhaoqi = PIGButton(InvF, {"TOPLEFT",InvF,"TOPLEFT",10,-3.4},{110,16})
	PIGSetFont(InvF.jiaruchazhaoqi.Text,12)
	InvF.jiaruchazhaoqi:SetFrameLevel(InvF.jiaruchazhaoqi:GetFrameLevel()+6)
	InvF.jiaruchazhaoqi:Disable()
	InvF.jiaruchazhaoqi:HookScript("OnShow", function (self)
		gengxinbut1()
	end)
	InvF.jiaruchazhaoqi:SetScript("OnClick", function (self)
		--JoinPermanentChannel("PIG", nil, DEFAULT_CHAT_FRAME:GetID(), 1);
		JoinTemporaryChannel("PIG", nil, DEFAULT_CHAT_FRAME:GetID(), 1);
		ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "PIG")
		ChatFrame_RemoveMessageGroup(DEFAULT_CHAT_FRAME, "CHANNEL")
		gengxinbut1()
	end)
	
	--设置-----------------------------
	InvF.setbut = CreateFrame("Button",nil,InvF, "TruncatedButtonTemplate"); 
	InvF.setbut:SetNormalTexture("interface/gossipframe/healergossipicon.blp"); 
	InvF.setbut:SetHighlightTexture(130718);
	InvF.setbut:SetSize(18,18);
	InvF.setbut:SetPoint("TOPRIGHT",InvF,"TOPRIGHT",-60,-2.5);
	InvF.setbut.Down = InvF.setbut:CreateTexture(nil, "OVERLAY");
	InvF.setbut.Down:SetTexture(130839);
	InvF.setbut.Down:SetSize(18,18);
	InvF.setbut.Down:SetPoint("CENTER");
	InvF.setbut.Down:Hide();
	InvF.setbut:SetScript("OnMouseDown", function (self)
		self.Down:Show();
	end);
	InvF.setbut:SetScript("OnMouseUp", function (self)
		self.Down:Hide()
	end);
	InvF.setbut:HookScript("OnClick", function (self)
		if Pig_OptionsUI:IsShown() then
			Pig_OptionsUI:Hide()
		else
			Pig_OptionsUI:Show()
			Create.Show_TabBut(TardisInfo.fuFrame,TardisInfo.fuFrameBut)
		end
	end);
	--内容显示
	InvF.F=PIGOptionsList_RF(InvF,21,"Bot",{0,0,0})
	----
	-- TardisInfo.Houche()
	-- TardisInfo.Chedui()
	TardisInfo.Plane(true)
	TardisInfo.Yell()
end

function TardisInfo.GetInfoBut(fuF,Point,daojiCDtime,jinduS,butTXT,jindutiaoW,GetButW)
	local GetButTXT = butTXT or L["DEBUG_REFRESH"]
	local GetButW=GetButW or {80,21}
	local GetBut = PIGButton(fuF,{Point[1],Point[2],Point[3],Point[4],Point[5]},{GetButW[1],GetButW[2]},GetButTXT);
	GetBut.daojiCDtime=daojiCDtime;
	---
	local jindutiaoW=jindutiaoW or {160,20}
	GetBut.jindutiao = CreateFrame("Frame", nil, GetBut);
	GetBut.jindutiao:SetSize(jindutiaoW[1],jindutiaoW[2]);
	GetBut.jindutiao:SetPoint("RIGHT",GetBut,"LEFT",-10,0);
	GetBut.jindutiao:Hide();
	GetBut.jindutiao.jinduS=jinduS
	GetBut.jindutiao.tex = GetBut.jindutiao:CreateTexture();
	GetBut.jindutiao.tex:SetTexture("interface/raidframe/raid-bar-hp-fill.blp");
	GetBut.jindutiao.tex:SetColorTexture(0.3, 0.7, 0.1, 0.9)
	GetBut.jindutiao.tex:SetSize(jindutiaoW[1],jindutiaoW[2]-1);
	GetBut.jindutiao.tex:SetPoint("LEFT",GetBut.jindutiao,"LEFT",0,0);
	GetBut.jindutiao.edg = CreateFrame("Frame", nil, GetBut.jindutiao, "BackdropTemplate");
	GetBut.jindutiao.edg:SetBackdrop( { edgeFile = "Interface/AddOns/"..addonName.."/Libs/Pig_Border.blp",edgeSize = 8});
	GetBut.jindutiao.edg:SetBackdropBorderColor(0, 1, 1, 0.9);
	GetBut.jindutiao.edg:SetAllPoints(GetBut.jindutiao)
	GetBut.jindutiao.edg.t = PIGFontString(GetBut.jindutiao.edg,{"CENTER",GetBut.jindutiao.edg,"CENTER",0,0},L["TARDIS_RECEIVEDATA"],"OUTLINE",12);
	GetBut.jindutishi = PIGFontString(GetBut,{"RIGHT",GetBut,"LEFT",-10,0},"","OUTLINE");
	GetBut.jindutishi:SetTextColor(0, 0.9, 0, 1);
	GetBut.err = PIGFontString(GetBut,{"BOTTOMLEFT",GetBut,"TOPLEFT",0,6},"","OUTLINE");
	GetBut.err:SetTextColor(1, 0, 0, 1);
	------
	GetBut.daojishiJG = 0
	function GetBut:CZdaojishi()
		self:Disable();
		self.err:SetText("")
		self.jindutishi:SetText("")
		self.daojishiJG = GetServerTime()
		self.jindutiao.time = 0
		self.jindutiao:Show()
	end
	function GetBut.daojishiCDFUN(self)
		local chazhiV = self.daojiCDtime-(GetServerTime()-self.daojishiJG)
		if chazhiV>0 then
			self:Disable()
			self:SetText("冷却中("..chazhiV..")");
		else
			self:Enable()
			self:SetText(GetButTXT);
		end
		if self:IsVisible() then
			C_Timer.After(1,function()
				self.daojishiCDFUN(self)
			end)
		end
	end
	GetBut:HookScript("OnShow", function(self)
		if self.daojishiJG==0 then
			self.jindutishi:SetText("上次获取:未知");
		else
			local yiguoqu = GetServerTime()-self.daojishiJG
			if yiguoqu>3600 then
				self.jindutishi:SetText("上次获取:一小时之前");
			elseif yiguoqu>1800 then
				self.jindutishi:SetText("上次获取:半小时之前");
			elseif yiguoqu>600 then
				self.jindutishi:SetText("上次获取:10分钟之前");
			elseif yiguoqu>300 then
				self.jindutishi:SetText("上次获取:5分钟之前");
			else
				self.jindutishi:SetText("上次获取:刚刚");
			end
		end
		self.daojishiCDFUN(self)
	end);
	GetBut.jindutiao.time = 0
	GetBut.jindutiao:SetScript("OnUpdate", function(self,sss)
		self.time=self.time+sss
		if self.time<jinduS then
			self.tex:SetWidth(jindutiaoW[1]*(self.time*0.5))
			self:Show();
		else
			self:Hide()
			GetBut:gengxin_hang(GetBut)
		end
	end);
	------
	return GetBut
end