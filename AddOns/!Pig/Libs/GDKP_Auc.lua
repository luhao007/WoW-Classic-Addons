local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
local PIGEnter=Create.PIGEnter
---
local biaotou,auc_start,auc_end,auc_daoshu,auc_chujia="!Pig_Auc","auc_start","auc_end","auc_daoshu","auc_chujia";
addonTable.Data.GDKP_Auc={biaotou,auc_start,auc_end,auc_daoshu,auc_chujia}
local butww = 30
local GDKP_AucF = CreateFrame("Frame","GDKP_AucFUI",UIParent)
GDKP_AucF:SetSize(butww,butww);
GDKP_AucF:SetPoint("CENTER",UIParent,"CENTER",-100,-50);
GDKP_AucF:SetFrameStrata("HIGH")
GDKP_AucF:Hide()

GDKP_AucF.nr=PIGFrame(GDKP_AucF,{"TOPRIGHT",GDKP_AucF,"TOPRIGHT",0,0},{300, 220})
GDKP_AucF.nr:PIGSetBackdrop(0.8)
GDKP_AucF.nr:PIGSetMovable(GDKP_AucF)
GDKP_AucF.nr.aucplayer = PIGFontString(GDKP_AucF.nr,{"TOP", GDKP_AucF.nr, "TOP", -40,-4});
GDKP_AucF.nr.aucplayer:SetTextColor(1, 0, 1, 1)
GDKP_AucF.nr.biaoti = PIGFontString(GDKP_AucF.nr,{"LEFT", GDKP_AucF.nr.aucplayer, "RIGHT", 0,0},"正在拍卖");
GDKP_AucF.nr.aucitem1 = PIGFontString(GDKP_AucF.nr,{"TOP", GDKP_AucF.nr, "TOP", 0,-30},nil,nil,18);
GDKP_AucF.nr.aucitem2 = PIGFontString(GDKP_AucF.nr,{"TOP", GDKP_AucF.nr, "TOP", 0,-60});
GDKP_AucF.nr.aucitem2:SetTextColor(1, 1, 1, 1)
GDKP_AucF.nr.chujiaV = CreateFrame("EditBox", nil, GDKP_AucF.nr, "InputBoxInstructionsTemplate");
GDKP_AucF.nr.chujiaV:SetSize(94,22);
GDKP_AucF.nr.chujiaV:SetPoint("TOP", GDKP_AucF.nr, "TOP", 0,-100);
PIGSetFont(GDKP_AucF.nr.chujiaV,15,"OUTLINE")
GDKP_AucF.nr.chujiaV:SetJustifyH("CENTER")
GDKP_AucF.nr.chujiaV:SetMaxLetters(10)
GDKP_AucF.nr.chujiaV:SetNumeric(true)
GDKP_AucF.nr.chujiaV:SetAutoFocus(false)
GDKP_AucF.nr.chujiaV:SetScript("OnEscapePressed", function(self) 
	local xianjiaV=self:GetNumber()
	local qipaiV = tonumber(GDKP_AucF.nr.qipai)
	if xianjiaV<qipaiV then self:SetText(qipaiV) end
	self:ClearFocus() 
end);
GDKP_AucF.nr.chujiaV:SetScript("OnEnterPressed", function(self) 
	local xianjiaV=self:GetNumber()
	local qipaiV = tonumber(GDKP_AucF.nr.qipai)
	if xianjiaV<qipaiV then self:SetText(qipaiV) end
	self:ClearFocus() 
end);
local sub = _G.string.sub
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
GDKP_AucF.nr.chujiaV:SetScript("OnCursorChanged", function(self) 
	self.chujiadaxie:SetText(zhuanhuanjiaxie(self:GetText()))
end)
GDKP_AucF.nr.chujiaV.MinB = PIGButton(GDKP_AucF.nr.chujiaV,{"RIGHT",GDKP_AucF.nr.chujiaV,"LEFT",-16,0},{24,24},"_");
GDKP_AucF.nr.chujiaV.MinB.Text:SetPoint("CENTER", GDKP_AucF.nr.chujiaV.MinB, "CENTER", 1.4,14);
PIGSetFont(GDKP_AucF.nr.chujiaV.MinB.Text,30)
GDKP_AucF.nr.chujiaV.MinB:SetScript("OnMouseDown", function(self)
	if self:IsEnabled() then
		self.Text:SetPoint("CENTER", 2.9,12.5);
	end
end);
GDKP_AucF.nr.chujiaV.MinB:SetScript("OnMouseUp", function(self)
	if self:IsEnabled() then
		self.Text:SetPoint("CENTER", 1.4,14);
	end
end);
GDKP_AucF.nr.chujiaV.MaxB = PIGButton(GDKP_AucF.nr.chujiaV,{"LEFT",GDKP_AucF.nr.chujiaV,"RIGHT",12,0},{24,24},"+"); 
PIGSetFont(GDKP_AucF.nr.chujiaV.MaxB.Text,30)
GDKP_AucF.nr.chujiaV.MinB:SetScript("OnClick", function(self)
	local xianjiaV=GDKP_AucF.nr.chujiaV:GetNumber()
	local qipaiV = tonumber(GDKP_AucF.nr.qipai)
	local danciV = tonumber(GDKP_AucF.nr.danci)
	local NEWxianjiaV=xianjiaV-danciV
	if NEWxianjiaV<qipaiV then
		GDKP_AucF.nr.chujiaV:SetText(qipaiV);
	else
		GDKP_AucF.nr.chujiaV:SetText(NEWxianjiaV-danciV);
	end
end);
GDKP_AucF.nr.chujiaV.MaxB:SetScript("OnClick", function(self)
	local xianjiaV=GDKP_AucF.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKP_AucF.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV
	if string.len(NEWxianjiaV)<=9 then
		GDKP_AucF.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKP_AucF.nr.chujiaV.chujiadaxie = PIGFontString(GDKP_AucF.nr.chujiaV,{"TOP", GDKP_AucF.nr.chujiaV, "BOTTOM", 0,-2});
GDKP_AucF.nr.chujiabut10 = PIGButton(GDKP_AucF.nr,{"BOTTOM", GDKP_AucF.nr, "BOTTOM", -60,54},{80,24},"10倍加价");
GDKP_AucF.nr.chujiabut10:SetScript("OnClick", function(self)
	local xianjiaV=GDKP_AucF.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKP_AucF.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV*10
	if string.len(NEWxianjiaV)<=9 then
		GDKP_AucF.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKP_AucF.nr.chujiabut20 = PIGButton(GDKP_AucF.nr,{"BOTTOM", GDKP_AucF.nr, "BOTTOM", 60,54},{80,24},"20倍加价");
GDKP_AucF.nr.chujiabut20:SetScript("OnClick", function(self)
	local xianjiaV=GDKP_AucF.nr.chujiaV:GetNumber()
	local danciV = tonumber(GDKP_AucF.nr.danci)
	local NEWxianjiaV=xianjiaV+danciV*20
	if string.len(NEWxianjiaV)<=9 then
		GDKP_AucF.nr.chujiaV:SetText(NEWxianjiaV);
	end
end);
GDKP_AucF.nr.chujiabut = PIGButton(GDKP_AucF.nr,{"BOTTOM", GDKP_AucF.nr, "BOTTOM", 0,18},{80,24},"出价");
GDKP_AucF.nr.chujiabut.tishi = CreateFrame("Frame", nil, GDKP_AucF.nr.chujiabut);
GDKP_AucF.nr.chujiabut.tishi:SetSize(26,26);
GDKP_AucF.nr.chujiabut.tishi:SetPoint("LEFT", GDKP_AucF.nr.chujiabut, "RIGHT", 4,0);
GDKP_AucF.nr.chujiabut.tishi.Tex = GDKP_AucF.nr.chujiabut.tishi:CreateTexture(nil, "BORDER");
GDKP_AucF.nr.chujiabut.tishi.Tex:SetTexture("interface/helpframe/helpicon-reportabuse.blp");
GDKP_AucF.nr.chujiabut.tishi.Tex:SetAllPoints(GDKP_AucF.nr.chujiabut.tishi)
PIGEnter(GDKP_AucF.nr.chujiabut.tishi,"重要提示：","|cffFF0000请及早出价，以免网络延迟造成的出价失败|r")
GDKP_AucF.nr.chujiabut:SetScript("OnClick",function(self)
	local chujiajiaV=GDKP_AucF.nr.chujiaV:GetNumber()
	local chujiajianxie=zhuanhuanjiaxie(GDKP_AucF.nr.chujiaV:GetText())
	if chujiajiaV<10000 then
		PIGSendChatRaidParty("出价:"..chujiajiaV)
	else
		PIGSendChatRaidParty("出价:"..chujiajiaV.." ("..chujiajianxie..")")
	end
	PIGSendAddonRaidParty(biaotou,auc_chujia.."&"..chujiajiaV)
end)
GDKP_AucF.Min = CreateFrame("Button",nil,GDKP_AucF, "TruncatedButtonTemplate"); 
GDKP_AucF.Min:SetNormalTexture("interface/chatframe/ui-chaticon-minimize-up.blp");
GDKP_AucF.Min:SetPushedTexture("interface/chatframe/ui-chaticon-minimize-down.blp")
GDKP_AucF.Min:SetHighlightTexture("interface/buttons/ui-checkbox-highlight.blp");
GDKP_AucF.Min:SetSize(butww,butww);
GDKP_AucF.Min:SetPoint("TOPRIGHT",GDKP_AucF,"TOPRIGHT",0,0);
GDKP_AucF.Min:SetFrameLevel(10)
GDKP_AucF.Min:RegisterForDrag("LeftButton")
GDKP_AucF.Min:SetScript("OnDragStart",function()
	GDKP_AucF:StartMoving()
end)
GDKP_AucF.Min:SetScript("OnDragStop",function()
	GDKP_AucF:StopMovingOrSizing()
end)
GDKP_AucF.Min.Height = GDKP_AucF.Min:CreateTexture(nil, "OVERLAY");
GDKP_AucF.Min.Height:SetAtlas("bags-newitem")
GDKP_AucF.Min.Height:SetSize(butww-1,butww-1);
GDKP_AucF.Min.Height:SetPoint("CENTER",0,0);
GDKP_AucF.Min.Height:Hide()
GDKP_AucF.Min.ShowHide=false
GDKP_AucF.Min.xulie=0
local function tishishanshuo()
	if GDKP_AucF:IsShown() and not GDKP_AucF.nr:IsShown() then
		if GDKP_AucF.Min.xulie==1 then
			GDKP_AucF.Min.xulie=0
			GDKP_AucF.Min.Height:Hide()
		else
			GDKP_AucF.Min.xulie=1
			GDKP_AucF.Min.Height:Show()
		end
		if GDKP_AucF.Min.ShowHide then
			C_Timer.After(1,tishishanshuo)
		end
	end
end
local function HidepaimaiUI()
	GDKP_AucF.nr:Hide();
	GDKP_AucF.Min.Height:Show()
	GDKP_AucF.Min:SetNormalTexture("interface/chatframe/ui-chaticon-maximize-up.blp");
	GDKP_AucF.Min:SetPushedTexture("interface/chatframe/ui-chaticon-maximize-down.blp")
	if not GDKP_AucF.Min.ShowHide then
		GDKP_AucF.Min.ShowHide=true
		tishishanshuo()
	end
end
GDKP_AucF:SetScript("OnShow", function(self)
	tishishanshuo()
	C_Timer.After(300,function() self:Hide() end)
end);
GDKP_AucF.Min:SetScript("OnClick", function (self)
	if GDKP_AucF.nr:IsShown() then
		HidepaimaiUI()
	else
		GDKP_AucF.nr:Show();
		self.Height:Hide()
		GDKP_AucF.Min:SetNormalTexture("interface/chatframe/ui-chaticon-minimize-up.blp");
		GDKP_AucF.Min:SetPushedTexture("interface/chatframe/ui-chaticon-minimize-down.blp")
		GDKP_AucF.Min.ShowHide=false
	end	
end);
GDKP_AucF.nr.p = PIGButton(GDKP_AucF.nr,{"BOTTOMLEFT", GDKP_AucF.nr, "BOTTOMLEFT", 20,18},{24,24},"P");
GDKP_AucF.nr.p:SetScript("OnClick",function(self)
	PIGSendChatRaidParty("出价: P")
	HidepaimaiUI()
end)
---
C_ChatInfo.RegisterAddonMessagePrefix(biaotou)
GDKP_AucF:RegisterEvent("GROUP_ROSTER_UPDATE");
GDKP_AucF:RegisterEvent("CHAT_MSG_ADDON");
GDKP_AucF:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="GROUP_ROSTER_UPDATE" then
		C_Timer.After(1,function()
			if not IsInGroup() then self:Hide() end
		end)
	end
	if event=="CHAT_MSG_ADDON" and arg1 == biaotou then
		local kaishijieshu, neirong = strsplit("&", arg2);
		if kaishijieshu==auc_daoshu then--倒数结束
			if neirong=="0" then
				GDKP_AucF.nr.p:Disable()
				GDKP_AucF.nr.chujiabut:Disable()
				PlaySoundFile("Interface/AddOns/"..addonName.."/Libs/ogg/auc_end.ogg", "Master")
			end
		elseif kaishijieshu==auc_chujia then--拍卖出价
			GDKP_AucF.nr.chujiaV:SetText(neirong+GDKP_AucF.nr.danci)
		elseif kaishijieshu==auc_start then--拍卖开始
			PlaySoundFile("Interface/AddOns/"..addonName.."/Libs/ogg/auc_play.ogg", "Master")	
			self:Show()
			GDKP_AucF.nr.aucplayer:SetText(arg5)
			local itemlink,num,qipai,jiajia = strsplit("#", neirong);
			GDKP_AucF.nr.aucitem1:SetText(itemlink.."×"..num)
			GDKP_AucF.nr.aucitem2:SetText("起拍价:|cff00FFFF"..qipai.."|r\n最低加价:|cff00FFFF"..jiajia.."|r")
			GDKP_AucF.nr.chujiaV:SetText(qipai)
			GDKP_AucF.nr.qipai=qipai
			GDKP_AucF.nr.danci=jiajia
			GDKP_AucF.nr.p:Enable()
			GDKP_AucF.nr.chujiabut:Enable()
		elseif kaishijieshu==auc_end then--拍卖结束
			self:Hide()
		end
	end
end)