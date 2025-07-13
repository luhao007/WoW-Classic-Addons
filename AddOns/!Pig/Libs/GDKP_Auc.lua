local addonName, addonTable = ...;
local L=addonTable.locale
---
local sub = _G.string.sub
local Data = addonTable.Data
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
local PIGEnter=Create.PIGEnter
---
local AudioData=addonTable.AudioList.Data
local biaotou,auc_start,auc_end,auc_daoshu,auc_chujia="!Pig_Auc","auc_start","auc_end","auc_daoshu","auc_chujia";
Data.GDKP_Auc={biaotou,auc_start,auc_end,auc_daoshu,auc_chujia}
local UIname,butww = "PIG_GDKPAucUI",30
Data.UILayout[UIname]={"CENTER","CENTER",-100,-50}
local GDKPAuc = CreateFrame("Frame",UIname,UIParent)
GDKPAuc:SetSize(butww,butww);
GDKPAuc:SetFrameStrata("HIGH")
GDKPAuc:Hide()

GDKPAuc.nr=PIGFrame(GDKPAuc,{"TOPRIGHT",GDKPAuc,"TOPRIGHT",0,0},{300, 220})
GDKPAuc.nr:PIGSetBackdrop(0.8)
GDKPAuc.nr:PIGSetMovable(GDKPAuc)
GDKPAuc.nr.aucplayer = PIGFontString(GDKPAuc.nr,{"TOP", GDKPAuc.nr, "TOP", -40,-4});
GDKPAuc.nr.aucplayer:SetTextColor(1, 0, 1, 1)
GDKPAuc.nr.biaoti = PIGFontString(GDKPAuc.nr,{"LEFT", GDKPAuc.nr.aucplayer, "RIGHT", 0,0},"正在拍卖");
GDKPAuc.nr.aucitem1 = PIGFontString(GDKPAuc.nr,{"TOP", GDKPAuc.nr, "TOP", 0,-30},nil,nil,18);
GDKPAuc.nr.aucitem2 = PIGFontString(GDKPAuc.nr,{"TOP", GDKPAuc.nr, "TOP", 0,-60});
GDKPAuc.nr.aucitem2:SetTextColor(1, 1, 1, 1)
GDKPAuc.nr.chujiaV = CreateFrame("EditBox", nil, GDKPAuc.nr, "InputBoxInstructionsTemplate");
GDKPAuc.nr.chujiaV:SetSize(94,22);
GDKPAuc.nr.chujiaV:SetPoint("TOP", GDKPAuc.nr, "TOP", 0,-100);
PIGSetFont(GDKPAuc.nr.chujiaV,15,"OUTLINE")
GDKPAuc.nr.chujiaV:SetJustifyH("CENTER")
GDKPAuc.nr.chujiaV:SetMaxLetters(10)
GDKPAuc.nr.chujiaV:SetNumeric(true)
GDKPAuc.nr.chujiaV:SetAutoFocus(false)
GDKPAuc.nr.chujiaV:SetScript("OnEscapePressed", function(self) 
	local xianjiaV=self:GetNumber()
	local qipaiV = tonumber(GDKPAuc.nr.qipai)
	if xianjiaV<qipaiV then self:SetText(qipaiV) end
	self:ClearFocus() 
end);
GDKPAuc.nr.chujiaV:SetScript("OnEnterPressed", function(self) 
	local xianjiaV=self:GetNumber()
	local qipaiV = tonumber(GDKPAuc.nr.qipai)
	if xianjiaV<qipaiV then self:SetText(qipaiV) end
	self:ClearFocus() 
end);
local function jisuanxiaoshudian(danwei,ge,shi,bai,qian)
	local geshihuazhiVV=danwei
	if ge~="0" then
		geshihuazhiVV="."..qian..bai..shi..ge..danwei
	elseif shi~="0" then
		geshihuazhiVV="."..qian..bai..shi..danwei
	elseif bai~="0" then
		geshihuazhiVV="."..qian..bai..danwei
	elseif qian~="0" then
		geshihuazhiVV="."..qian..danwei
	end
	return geshihuazhiVV
end
local function zhuanhuanjiaxie(xianjiaV)
	local ge=xianjiaV:sub(-1,-1)--个
	local shi=xianjiaV:sub(-2,-2)--十
	local bai=xianjiaV:sub(-3,-3)--百
	local qian=xianjiaV:sub(-4,-4)--千
	local wan=xianjiaV:sub(-5,-5)--万
	local shiwan=xianjiaV:sub(-6,-6)--十万
	local baiwan=xianjiaV:sub(-7,-7)--百万
	local qianwan=xianjiaV:sub(-8,-8)--千万
	local yiji=xianjiaV:sub(-9,-9)--亿
	local shiyiji=xianjiaV:sub(-10,-10)--十亿
	local baiyiji=xianjiaV:sub(-11,-11)--百亿
	local geshihuazhiVV = ""
	local wan_xiaoshudian=jisuanxiaoshudian("万",ge,shi,bai,qian)
	local yi_xiaoshudian=jisuanxiaoshudian("亿",wan,shiwan,baiwan,qianwan)
	if baiyiji~="" then
		geshihuazhiVV=baiyiji..shiyiji..yiji..yi_xiaoshudian
	elseif shiyiji~="" then
		geshihuazhiVV=shiyiji..yiji..yi_xiaoshudian
	elseif yiji~="" then
		geshihuazhiVV=yiji..yi_xiaoshudian
	elseif qianwan~="" then
		geshihuazhiVV=qianwan..baiwan..shiwan..wan..wan_xiaoshudian
	elseif baiwan~="" then
		geshihuazhiVV=baiwan..shiwan..wan..wan_xiaoshudian
	elseif shiwan~="" then
		geshihuazhiVV=shiwan..wan..wan_xiaoshudian
	elseif wan~="" then
		geshihuazhiVV=wan..wan_xiaoshudian
	end
	return geshihuazhiVV
end
GDKPAuc.nr.chujiaV:SetScript("OnCursorChanged", function(self) 
	self.chujiadaxie:SetText(zhuanhuanjiaxie(self:GetText()))
end)
GDKPAuc.nr.chujiaV.MinB = PIGButton(GDKPAuc.nr.chujiaV,{"RIGHT",GDKPAuc.nr.chujiaV,"LEFT",-16,0},{24,24},"_");
GDKPAuc.nr.chujiaV.MinB.Text:SetPoint("CENTER", GDKPAuc.nr.chujiaV.MinB, "CENTER", 1.4,14);
PIGSetFont(GDKPAuc.nr.chujiaV.MinB.Text,30)
GDKPAuc.nr.chujiaV.MinB:SetScript("OnMouseDown", function(self)
	if self:IsEnabled() then
		self.Text:SetPoint("CENTER", 2.9,12.5);
	end
end);
GDKPAuc.nr.chujiaV.MinB:SetScript("OnMouseUp", function(self)
	if self:IsEnabled() then
		self.Text:SetPoint("CENTER", 1.4,14);
	end
end);
GDKPAuc.nr.chujiaV.MaxB = PIGButton(GDKPAuc.nr.chujiaV,{"LEFT",GDKPAuc.nr.chujiaV,"RIGHT",12,0},{24,24},"+"); 
PIGSetFont(GDKPAuc.nr.chujiaV.MaxB.Text,30)
GDKPAuc.nr.chujiaV.MinB:SetScript("OnClick", function(self)
	local xianjiaV=GDKPAuc.nr.chujiaV:GetNumber()
	local qipaiV = tonumber(GDKPAuc.nr.qipai)
	local danciV = tonumber(GDKPAuc.nr.danci)
	local NEWxianjiaV=xianjiaV-danciV
	if NEWxianjiaV<qipaiV then
		GDKPAuc.nr.chujiaV:SetText(qipaiV);
	else
		GDKPAuc.nr.chujiaV:SetText(NEWxianjiaV-danciV);
	end
end);
GDKPAuc.nr.chujiaV.MaxB:SetScript("OnClick", function(self)
	local xianjiaV=GDKPAuc.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKPAuc.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV
	if string.len(NEWxianjiaV)<=9 then
		GDKPAuc.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKPAuc.nr.chujiaV.chujiadaxie = PIGFontString(GDKPAuc.nr.chujiaV,{"TOP", GDKPAuc.nr.chujiaV, "BOTTOM", 0,-2});
GDKPAuc.nr.chujiabut10 = PIGButton(GDKPAuc.nr,{"BOTTOM", GDKPAuc.nr, "BOTTOM", -60,54},{80,24},"10倍加价");
GDKPAuc.nr.chujiabut10:SetScript("OnClick", function(self)
	local xianjiaV=GDKPAuc.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKPAuc.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV*10
	if string.len(NEWxianjiaV)<=9 then
		GDKPAuc.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKPAuc.nr.chujiabut20 = PIGButton(GDKPAuc.nr,{"BOTTOM", GDKPAuc.nr, "BOTTOM", 60,54},{80,24},"20倍加价");
GDKPAuc.nr.chujiabut20:SetScript("OnClick", function(self)
	local xianjiaV=GDKPAuc.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKPAuc.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV*20
	if string.len(NEWxianjiaV)<=9 then
		GDKPAuc.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKPAuc.nr.chujiabut = PIGButton(GDKPAuc.nr,{"BOTTOM", GDKPAuc.nr, "BOTTOM", 0,18},{80,24},"出价");
GDKPAuc.nr.chujiabut.tishi = CreateFrame("Frame", nil, GDKPAuc.nr.chujiabut);
GDKPAuc.nr.chujiabut.tishi:SetSize(26,26);
GDKPAuc.nr.chujiabut.tishi:SetPoint("LEFT", GDKPAuc.nr.chujiabut, "RIGHT", 4,0);
GDKPAuc.nr.chujiabut.tishi.Tex = GDKPAuc.nr.chujiabut.tishi:CreateTexture(nil, "BORDER");
GDKPAuc.nr.chujiabut.tishi.Tex:SetTexture("interface/helpframe/helpicon-reportabuse.blp");
GDKPAuc.nr.chujiabut.tishi.Tex:SetAllPoints(GDKPAuc.nr.chujiabut.tishi)
PIGEnter(GDKPAuc.nr.chujiabut.tishi,"重要提示：","|cffFF0000请及早出价，以免网络延迟造成的出价失败|r")
GDKPAuc.nr.chujiabut:SetScript("OnClick",function(self)
	local chujiajiaV=GDKPAuc.nr.chujiaV:GetNumber()
	local chujiajianxie=zhuanhuanjiaxie(GDKPAuc.nr.chujiaV:GetText())
	if chujiajiaV<10000 then
		PIGSendChatRaidParty("出价:"..chujiajiaV)
	else
		PIGSendChatRaidParty("出价:"..chujiajiaV.." ("..chujiajianxie..")")
	end
	PIGSendAddonRaidParty(biaotou,auc_chujia.."&"..chujiajiaV)
end)
GDKPAuc.Min = CreateFrame("Button",nil,GDKPAuc, "TruncatedButtonTemplate"); 
GDKPAuc.Min:SetNormalTexture("interface/chatframe/ui-chaticon-minimize-up.blp");
GDKPAuc.Min:SetPushedTexture("interface/chatframe/ui-chaticon-minimize-down.blp")
GDKPAuc.Min:SetHighlightTexture("interface/buttons/ui-checkbox-highlight.blp");
GDKPAuc.Min:SetSize(butww,butww);
GDKPAuc.Min:SetPoint("TOPRIGHT",GDKPAuc,"TOPRIGHT",0,0);
GDKPAuc.Min:SetFrameLevel(10)
GDKPAuc.Min:RegisterForDrag("LeftButton")
GDKPAuc.Min:SetScript("OnDragStart",function()
	GDKPAuc:StartMoving()
end)
GDKPAuc.Min:SetScript("OnDragStop",function()
	GDKPAuc:StopMovingOrSizing()
end)
GDKPAuc.Min.Height = GDKPAuc.Min:CreateTexture(nil, "OVERLAY");
GDKPAuc.Min.Height:SetAtlas("bags-newitem")
GDKPAuc.Min.Height:SetSize(butww-1,butww-1);
GDKPAuc.Min.Height:SetPoint("CENTER",0,0);
GDKPAuc.Min.Height:Hide()
GDKPAuc.Min.Height.animationGroup = GDKPAuc.Min.Height:CreateAnimationGroup()
GDKPAuc.Min.Height.animationGroup:SetLooping("REPEAT")
local fade = GDKPAuc.Min.Height.animationGroup:CreateAnimation("Alpha")
fade:SetFromAlpha(1)
fade:SetToAlpha(0)
fade:SetDuration(0.1)
fade:SetStartDelay(0.5)
fade:SetEndDelay(0.5)
function GDKPAuc:PlayAnimation()
	if GDKPAuc.nr:IsShown() then
		GDKPAuc.Min.Height:Hide()
		GDKPAuc.Min.Height.animationGroup:Stop()
		GDKPAuc.Min:SetNormalTexture("interface/chatframe/ui-chaticon-minimize-up.blp");
		GDKPAuc.Min:SetPushedTexture("interface/chatframe/ui-chaticon-minimize-down.blp")
	else
		GDKPAuc.Min.Height:Show()
		GDKPAuc.Min.Height.animationGroup:Play()
		GDKPAuc.Min:SetNormalTexture("interface/chatframe/ui-chaticon-maximize-up.blp");
		GDKPAuc.Min:SetPushedTexture("interface/chatframe/ui-chaticon-maximize-down.blp")
	end
end
GDKPAuc:SetScript("OnShow", function(self)
	if self.OffUItime then self.OffUItime:Cancel() end
	self.OffUItime=C_Timer.NewTimer(300,function() self:Hide() end)
	GDKPAuc:PlayAnimation()
end);
GDKPAuc.Min:SetScript("OnClick", function (self)
	if GDKPAuc.nr:IsShown() then
		GDKPAuc.nr:Hide();
	else
		GDKPAuc.nr:Show();
	end
	GDKPAuc:PlayAnimation()
end);
GDKPAuc.nr.p = PIGButton(GDKPAuc.nr,{"BOTTOMLEFT", GDKPAuc.nr, "BOTTOMLEFT", 20,18},{24,24},"P");
GDKPAuc.nr.p:SetScript("OnClick",function(self)
	PIGSendChatRaidParty("出价: P")
end)
---
C_ChatInfo.RegisterAddonMessagePrefix(biaotou)
GDKPAuc:RegisterEvent("PLAYER_LOGIN")
GDKPAuc:RegisterEvent("GROUP_ROSTER_UPDATE");
GDKPAuc:RegisterEvent("CHAT_MSG_ADDON");
GDKPAuc:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="PLAYER_LOGIN" then
		Create.PIG_SetPoint(UIname)
	elseif event=="GROUP_ROSTER_UPDATE" then
		C_Timer.After(1,function()
			if not IsInGroup() then self:Hide() end
		end)
	elseif event=="CHAT_MSG_ADDON" and arg1 == biaotou then
		local kaishijieshu, neirong = strsplit("&", arg2);
		if kaishijieshu==auc_daoshu then--倒数结束
			if neirong=="0" then
				GDKPAuc.nr.p:Disable()
				GDKPAuc.nr.chujiabut:Disable()
				PIG_PlaySoundFile(AudioData.GDKP_End[1])
			end
		elseif kaishijieshu==auc_chujia then--拍卖出价
			GDKPAuc.nr.chujiaV:SetText(neirong+GDKPAuc.nr.danci)
		elseif kaishijieshu==auc_start then--拍卖开始
			PIG_PlaySoundFile(AudioData.GDKP_Start[1])
			self:Show()
			GDKPAuc.nr.aucplayer:SetText(arg5)
			local itemlink,num,qipai,jiajia = strsplit("#", neirong);
			GDKPAuc.nr.aucitem1:SetText(itemlink.."×"..num)
			GDKPAuc.nr.aucitem2:SetText("起拍价:|cff00FFFF"..qipai.."|r\n最低加价:|cff00FFFF"..jiajia.."|r")
			GDKPAuc.nr.chujiaV:SetText(qipai)
			GDKPAuc.nr.qipai=qipai
			GDKPAuc.nr.danci=jiajia
			GDKPAuc.nr.p:Enable()
			GDKPAuc.nr.chujiabut:Enable()
		elseif kaishijieshu==auc_end then--拍卖结束
			self:Hide()
		end
	end
end)