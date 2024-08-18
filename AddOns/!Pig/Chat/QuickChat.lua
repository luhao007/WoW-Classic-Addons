local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
------------
local Fun=addonTable.Fun
local GetPIGID=Fun.GetPIGID
local biaoqingData=Fun.biaoqingData
local TihuanBiaoqing=Fun.TihuanBiaoqing
--
local QuickChatfun=addonTable.QuickChatfun
local Create=addonTable.Create
local PIGFontString=Create.PIGFontString
---
local jiangejuli,hangshu = 0,10;
local ChatpindaoMAX = addonTable.Fun.ChatpindaoMAX
--local locale1 = GetAvailableLocales()
local locale1 = GetLocale()
local worldname="大脚世界频道"
local FUWUPINDAONAME = "服务"
if locale1 == "zhTW" then
	--worldname="世界"
	FUWUPINDAONAME = "服務"
elseif locale1 == "enUS" then
	worldname="WORLD"
end

--/////聊天快捷按钮--------
--local function GetWindSizeFont(chatf)
	-- local fontSize = 14
	-- for i = 1, NUM_CHAT_WINDOWS do
	-- 	if ( i ~= 2 ) then
	-- 		if chatf==_G["ChatFrame"..i] then
	-- 			local _,fontSize = GetChatWindowInfo(i);
	-- 			if fontSize>0 then
	-- 				return fontSize
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- return fontSize
-- 	return 0
-- end
-- QuickChatfun.GetWindSizeFont=GetWindSizeFont
local function TihuanBQfun(self,event,arg1,...)
	local arg1 = TihuanBiaoqing(arg1)
	return false, arg1, ...
end
--判断频道信息显示与否
local function PIGIsListeningForMessageType(messageType)
	-- print(IsRestrictedAccount())	
	local pindaomulu = {GetChatWindowMessages(1)}
	for i=1,#pindaomulu do
		if ( pindaomulu[i] == messageType ) then
			return true;
		end
	end
	return false;
end
local function PIGIsIsCHANNELJoin(pdname)
	local Showchatmulu = {GetChatWindowChannels(1)}
	for ii=1,#Showchatmulu do
		if pdname==Showchatmulu[ii] then
			return true
		end
		if pdname=="PIG" or pdname==worldname then
			for x=1,ChatpindaoMAX do
				local newpindaoname = pdname..x
				if Showchatmulu[ii]==newpindaoname then
					return true
				end
			end
		end
	end
	return false
end
-------------
local function ADD_chatbut(fuF,pdtype,name,chatID,Color,pdname)
	if name and not PIGA["Chat"]["QuickChat_ButList"][name] then return end
	local Width=fuF.Width
	local PIGTemplate={nil,"NORMAL"}
	if PIGA["Chat"]["QuickChat_style"]==1 then
		PIGTemplate[1]=nil
		PIGTemplate[2]="OUTLINE"
	elseif PIGA["Chat"]["QuickChat_style"]==2 then
		PIGTemplate[1]="UIMenuButtonStretchTemplate"
		PIGTemplate[2]="NORMAL"
	elseif PIGA["Chat"]["QuickChat_style"]==3 then
		PIGTemplate[2]="NORMAL"
	end
	local ziframe = {fuF:GetChildren()}
	local chatbut = CreateFrame("Button",nil,fuF, PIGTemplate[1]);  
	chatbut:SetSize(Width,Width);
	chatbut:SetPoint("LEFT",fuF,"LEFT",#ziframe*Width,0);
	chatbut:SetFrameStrata("LOW")
	chatbut:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	chatbut:SetScript("OnEnter", function (self)	
		if pdtype=="CHANNEL" then
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
			GameTooltip:SetText("|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..CHAT_JOIN.."/"..VOICE_TALKING.."\n|cff00FFff"..KEY_BUTTON2.."-|r|cffFFFF00"..SWITCH..IGNORE.."/"..IGNORE_REMOVE.."|r");
			GameTooltip:Show();
			GameTooltip:FadeOut()
		end
		fuF:PIGEnterAlpha()
	end);
	chatbut:SetScript("OnLeave", function (self)
		if pdtype=="CHANNEL" then
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end
		fuF:PIGLeaveAlpha()
	end);
	if pdtype=="bq" then
		chatbut.Tex = chatbut:CreateTexture(nil, "BORDER");
		chatbut.Tex:SetTexture("Interface/AddOns/"..addonName.."/Chat/icon/happy.tga");
		chatbut.Tex:SetPoint("CENTER",0,0);
		chatbut.Tex:SetSize(Width-10,Width-10);
		chatbut:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",1,-1);
		end);
		chatbut:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER",0,0);
		end);
		chatbut:SetScript("OnClick", function(self)
			if self.F:IsShown() then
				self.F:Hide()
			else
				self.F:Show()
				self.F.xiaoshidaojishi = 1.5;
				self.F.zhengzaixianshi = true;
			end
		end);
	elseif pdtype=="Mes" or pdtype=="CHANNEL" then
		chatbut.X = chatbut:CreateTexture(nil, "OVERLAY");
		chatbut.X:SetTexture("interface/common/voicechat-muted.blp");
		chatbut.X:SetSize(Width-9,Width-9);
		chatbut.X:SetAlpha(0.7);
		chatbut.X:SetPoint("CENTER",0,0);
		chatbut.X:Hide()
		chatbut.Text = PIGFontString(chatbut,{"CENTER",chatbut,"CENTER",0,0},name,PIGTemplate[2]);
		chatbut.Text:SetTextColor(Color[1], Color[2], Color[3], 1);
		chatbut:SetScript("OnMouseDown", function (self)
			self.Text:SetPoint("CENTER",1,-1);
		end);
		chatbut:SetScript("OnMouseUp", function (self)
			self.Text:SetPoint("CENTER",0,0);
		end);
		--
		if pdtype=="Mes" then	
			chatbut:SetScript("OnClick", function(self, button)
				if button=="LeftButton" then
					AddChatWindowMessages(1, pdname)
					local editBox = ChatEdit_ChooseBoxForSend();
					local hasText = editBox:GetText()
					if editBox:HasFocus() then
						editBox:SetText("/"..chatID.." " .. hasText);
					else
						ChatEdit_ActivateChat(editBox)
						editBox:SetText("/"..chatID.." " .. hasText);
					end
				else
					if PIGIsListeningForMessageType(pdname) then
						ChatFrame_RemoveMessageGroup(ChatFrame1, pdname);
						if pdname=="RAID" then
							ChatFrame_RemoveMessageGroup(ChatFrame1, "RAID_LEADER");
						end
						if pdname=="PARTY" then
							ChatFrame_RemoveMessageGroup(ChatFrame1, "PARTY_LEADER");
						end
						if pdname=="INSTANCE_CHAT" then
							ChatFrame_RemoveMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER");
						end
						if pdname=="GUILD" then
							ChatFrame_RemoveMessageGroup(ChatFrame1, "OFFICER");
						end
						PIG_print(IGNORE.._G[pdname]..CHANNEL..INFO);
						self.X:Show();
					else
						ChatFrame_AddMessageGroup(ChatFrame1, pdname);
						if pdname=="RAID" then
							ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER");
						end
						if pdname=="PARTY" then
							ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER");
						end
						if pdname=="INSTANCE_CHAT" then
							ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER");
						end
						if pdname=="GUILD" then
							ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER");
						end
						PIG_print(IGNORE_REMOVE.._G[pdname]..CHANNEL..INFO);
						self.X:Hide();
					end
				end
			end);
		elseif pdtype=="CHANNEL" then
			chatbut:SetScript("OnClick", function(self, button)
				self.pindaoID = GetPIGID(chatID)
				--local chatFrame = SELECTED_DOCK_FRAME--当前选择聊天框架
				if button=="LeftButton" then
					if self.pindaoID==0 then
						--JoinPermanentChannel(chatID, nil, DEFAULT_CHAT_FRAME:GetID(), 1);
						JoinTemporaryChannel(chatID, nil, DEFAULT_CHAT_FRAME:GetID(), 1);
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chatID)--订购一个聊天框以显示先前加入的聊天频道
						if GetPIGID(chatID)>0 then
							chatbut.X:Hide();
							PIG_print(CHAT_JOIN..chatID..CHANNEL.."，"..KEY_BUTTON2..IGNORE..CHANNEL..INFO);
						else
							PIG_print(CHAT_JOIN..chatID..CHANNEL..FAILED.."，请稍后再试");
						end
					else
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chatID)
						local editBox = ChatEdit_ChooseBoxForSend();
						local hasText = editBox:GetText()
						if editBox:HasFocus() then
							editBox:SetText("/"..self.pindaoID.." " ..hasText);
						else
							ChatEdit_ActivateChat(editBox)
							editBox:SetText("/"..self.pindaoID.." " ..hasText);
						end
					end		
				else
					if self.pindaoID>0 then
						if PIGIsIsCHANNELJoin(chatID) then
							if chatID==GENERAL then
								ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, FUWUPINDAONAME);
								ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "本地防务");
								ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "世界防务");
								PIG_print(IGNORE..chatID.."/"..FUWUPINDAONAME..CHANNEL..INFO);
							else
								PIG_print(IGNORE..chatID..CHANNEL..INFO);
							end
							ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, chatID);
							self.X:Show();
						else
							ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chatID)
							if chatID==GENERAL then
								ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, FUWUPINDAONAME);
								ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "本地防务");
								ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "世界防务");
								PIG_print(IGNORE_REMOVE..chatID.."/"..FUWUPINDAONAME..CHANNEL..INFO);
							else
								PIG_print(IGNORE_REMOVE..chatID..CHANNEL..INFO);
							end
							self.X:Hide();
						end
					else
						PIG_print("尚未"..CHAT_JOIN..chatID..CHANNEL);
					end
				end
			end);
		end
	end
	return chatbut
end
---更新按钮的屏蔽状态
function QuickChatfun.Update_ChatBut_icon()
	if QuickChatFFF_UI then
		local changuipindaoX = {
			{QuickChatFFF_UI.SAY,"SAY"},
			{QuickChatFFF_UI.YELL,"YELL"},
			{QuickChatFFF_UI.PARTY,"PARTY"},
			{QuickChatFFF_UI.GUILD,"GUILD"},
			{QuickChatFFF_UI.RAID,"RAID"},
			{QuickChatFFF_UI.RAID_WARNING,"RAID_WARNING"},
			{QuickChatFFF_UI.INSTANCE_CHAT,"INSTANCE_CHAT"},
		}
		local changuipindao = {}
		for i=1,#changuipindaoX do
			if changuipindaoX[i][1] then
				table.insert(changuipindao,{changuipindaoX[i][1].X,changuipindaoX[i][2]})
			end
		end
		for i=1,#changuipindao do
			if PIGIsListeningForMessageType(changuipindao[i][2]) then
				changuipindao[i][1]:Hide();
			else
				changuipindao[i][1]:Show();
			end
		end
		---
		local chaozhaopindaoX = {
			{"CHANNEL_1",GENERAL},
			{"CHANNEL_2",TRADE},
			{"CHANNEL_3",LOOK_FOR_GROUP},
			{"CHANNEL_4","PIG"},
			{"CHANNEL_5",worldname},
		}
		for i=1,#chaozhaopindaoX do
			if QuickChatFFF_UI[chaozhaopindaoX[i][1]] then
				if PIGIsIsCHANNELJoin(chaozhaopindaoX[i][2]) then
					QuickChatFFF_UI[chaozhaopindaoX[i][1]].X:Hide();
				else
					QuickChatFFF_UI[chaozhaopindaoX[i][1]].X:Show();
				end
			end
		end
	end
end
---快捷切换频道按钮位置=======	
function QuickChatfun.Update_QuickChatPoint(arg1)
	local arg1=arg1 or PIGA["Chat"]["QuickChat_maodian"]
	if QuickChatFFF_UI then
		QuickChatFFF_UI:ClearAllPoints();	
		if arg1==1 then	
			QuickChatFFF_UI:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",0+PIGA["Chat"]["QuickChat_pianyiX"],28+PIGA["Chat"]["QuickChat_pianyiY"]);
		elseif arg1==2 then
			QuickChatFFF_UI:SetPoint("TOPLEFT",ChatFrame1,"BOTTOMLEFT",-2+PIGA["Chat"]["QuickChat_pianyiX"],-4+PIGA["Chat"]["QuickChat_pianyiY"]);
		end	
		QuickChatfun.Update_editBoxPoint()
	end
end
function QuickChatfun.Open()
	if not PIGA["Chat"]["QuickChat"] then return end
	if QuickChatFFF_UI then return end
	for i=1,#L["CHAT_QUKBUTNAME"]-1 do
		if PIGA["Chat"]["QuickChat_ButList"][L["CHAT_QUKBUTNAME"][i]]==nil then
			PIGA["Chat"]["QuickChat_ButList"][L["CHAT_QUKBUTNAME"][i]]=true
		end
	end
	PIGA["Chat"]["QuickChat_ButList"]["P"]=false
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", TihuanBQfun)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", TihuanBQfun)
	-----------------------
	local Width = 25
	local QuickChatFFF = CreateFrame("Frame", "QuickChatFFF_UI", UIParent);
	QuickChatFFF.Width=Width
	QuickChatFFF:SetSize(Width,Width);
	QuickChatFFF:SetFrameStrata("LOW")
	local function Hidebeijing(editBox)
		if ( editBox.disableActivate or ( GetCVar("chatStyle") == "classic" and not editBox.isGM ) ) then	
		else
			if ( not editBox.isGM ) then
				editBox:SetAlpha(0.1);
			end
		end
	end
	hooksecurefunc("ChatEdit_DeactivateChat", function(editBox)
		Hidebeijing(editBox)
	end)
	hooksecurefunc("ChatEdit_SetLastActiveWindow", function(editBox)
		Hidebeijing(editBox)
	end)
	function QuickChatFFF:PIGEnterAlpha()
		self:SetAlpha(1)
	end
	function QuickChatFFF:PIGLeaveAlpha()
		if PIGA["Chat"]["QuickChat_jianyin"] then self:SetAlpha(0.06) end
	end
	local function SetEnterLeave(fuix)
		fuix:HookScript("OnEnter", function (self)	
			QuickChatFFF:PIGEnterAlpha()
		end);
		fuix:HookScript("OnLeave", function (self)
			QuickChatFFF:PIGLeaveAlpha()
		end);
	end
	for i = 1, NUM_CHAT_WINDOWS do
		local chatF = _G["ChatFrame"..i]
		SetEnterLeave(chatF)
		local chatTab = _G["ChatFrame"..i.."Tab"]
		SetEnterLeave(chatTab)
	end
	-------
	QuickChatFFF.biaoqing = ADD_chatbut(QuickChatFFF,"bq")
	QuickChatFFF.biaoqing.F = CreateFrame("Frame", nil, QuickChatFFF.biaoqing,"BackdropTemplate");
	QuickChatFFF.biaoqing.F:SetBackdrop( { 
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",tile = false, tileSize = 0,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 8, 
		insets = { left = 2, right = 2, top = 2, bottom = 2 }});
	QuickChatFFF.biaoqing.F:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
	QuickChatFFF.biaoqing.F:SetBackdropColor(0.5, 0.5, 0.5, 0.8);
	QuickChatFFF.biaoqing.F:SetSize((Width+2)*hangshu+10,Width*6+20);
	QuickChatFFF.biaoqing.F:SetPoint("BOTTOMLEFT",QuickChatFFF.biaoqing,"TOPLEFT", 0, 0);
	QuickChatFFF.biaoqing.F:Hide()
	QuickChatFFF.biaoqing.F:SetFrameStrata("HIGH")
	QuickChatFFF.biaoqing.F.xiaoshidaojishi = 0;
	QuickChatFFF.biaoqing.F.zhengzaixianshi = nil;
	QuickChatFFF.biaoqing.F:SetScript("OnUpdate", function(self, ssss)
		if self.zhengzaixianshi==nil then
			return;
		else
			if self.zhengzaixianshi==true then
				if self.xiaoshidaojishi<= 0 then
					self:Hide();
					self.zhengzaixianshi = nil;
				else
					self.xiaoshidaojishi = self.xiaoshidaojishi - ssss;	
				end
			end
		end
	end)
	QuickChatFFF.biaoqing.F:SetScript("OnEnter", function(self)
		self.zhengzaixianshi = nil;
	end)
	QuickChatFFF.biaoqing.F:SetScript("OnLeave", function(self)
		self.xiaoshidaojishi = 1.5;
		self.zhengzaixianshi = true;
	end)
	for i=1,#biaoqingData do
		local biaoqinglist = CreateFrame("Button","biaoqing_list"..i,QuickChatFFF.biaoqing.F,nil,i);
		biaoqinglist:SetSize(Width,Width);
		if i==1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickChatFFF.biaoqing.F,"TOPLEFT", 5, -5);
		elseif i<hangshu+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		elseif i==hangshu+1 then
			biaoqinglist:SetPoint("TOPLEFT",_G["biaoqing_list1"],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*2+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		elseif i==hangshu*2+1 then
			biaoqinglist:SetPoint("TOPLEFT",_G["biaoqing_list11"],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*3+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		elseif i==hangshu*3+1 then
			biaoqinglist:SetPoint("TOPLEFT",_G["biaoqing_list21"],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*4+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		elseif i==hangshu*4+1 then
			biaoqinglist:SetPoint("TOPLEFT",_G["biaoqing_list31"],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*5+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		elseif i==hangshu*5+1 then
			biaoqinglist:SetPoint("TOPLEFT",_G["biaoqing_list41"],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*6+1 then
			biaoqinglist:SetPoint("LEFT",_G["biaoqing_list"..(i-1)],"RIGHT", 2, 0);
		end
		biaoqinglist.Tex = biaoqinglist:CreateTexture();
		biaoqinglist.Tex:SetTexture(biaoqingData[i][2]);
		biaoqinglist.Tex:SetPoint("CENTER",0,0);
		biaoqinglist.Tex:SetSize(Width,Width);
		biaoqinglist:SetScript("OnEnter", function()
			QuickChatFFF.biaoqing.F.zhengzaixianshi=nil
		end)
		biaoqinglist:SetScript("OnLeave", function()
			QuickChatFFF.biaoqing.F.xiaoshidaojishi = 1.5;
			QuickChatFFF.biaoqing.F.zhengzaixianshi = true;
		end)
		biaoqinglist:SetScript("OnClick", function(self)
			local editBox = ChatEdit_ChooseBoxForSend();
			local hasText = editBox:GetText()..biaoqingData[self:GetID()][1]
			if editBox:HasFocus() then
				editBox:SetText(hasText);
			else
				ChatEdit_ActivateChat(editBox)
				editBox:SetText(hasText);
			end
			QuickChatFFF.biaoqing.F:Hide();
		end)
	end
	--说--
	QuickChatFFF.SAY = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][1],"s",{1, 1, 1},"SAY")
	--喊--
	QuickChatFFF.YELL = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][2],"y",{1, 0.25, 0.25},"YELL")
	--队伍--
	QuickChatFFF.PARTY = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][3],"p",{0.6667, 0.6667, 1},"PARTY")
	--公会--
	QuickChatFFF.GUILD = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][4],"g",{0.25, 1, 0.25},"GUILD")
	--团队--
	QuickChatFFF.RAID = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][5],"ra",{1, 0.498, 0},"RAID")
	--团队通知--
	QuickChatFFF.RAID_WARNING = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][6],"rw",{1, 0.282, 0},"RAID_WARNING")
	--战场/副本--
	if tocversion<30000 then
		QuickChatFFF.INSTANCE_CHAT = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][7],"bg",{1, 0.498, 0},"INSTANCE_CHAT")
	else
		QuickChatFFF.INSTANCE_CHAT = ADD_chatbut(QuickChatFFF,"Mes",L["CHAT_QUKBUTNAME"][7],"i",{1, 0.498, 0},"INSTANCE_CHAT")
	end
	--CHANNEL--
	QuickChatFFF.CHANNEL_1 = ADD_chatbut(QuickChatFFF,"CHANNEL",L["CHAT_QUKBUTNAME"][8],GENERAL,{0.888, 0.668, 0.668})
	QuickChatFFF.CHANNEL_2 = ADD_chatbut(QuickChatFFF,"CHANNEL",L["CHAT_QUKBUTNAME"][9],TRADE,{0.888, 0.668, 0.668})
	QuickChatFFF.CHANNEL_3 = ADD_chatbut(QuickChatFFF,"CHANNEL",L["CHAT_QUKBUTNAME"][10],LOOK_FOR_GROUP,{0.888, 0.668, 0.668})
	QuickChatFFF.CHANNEL_4 = ADD_chatbut(QuickChatFFF,"CHANNEL",L["CHAT_QUKBUTNAME"][11],"PIG",{0.4,1,0.8})
	QuickChatFFF.CHANNEL_5 = ADD_chatbut(QuickChatFFF,"CHANNEL",L["CHAT_QUKBUTNAME"][12],worldname,{0.888, 0.668, 0.668})
	--
	QuickChatfun.QuickBut_Keyword()
	QuickChatfun.QuickBut_Roll()
	QuickChatfun.QuickBut_Stats()
	QuickChatfun.QuickBut_Jilu()
	QuickChatfun.QuickBut_jiuwei()
	QuickChatfun.Update_QuickChatPoint(PIGA["Chat"]["QuickChat_maodian"])
	C_Timer.After(3,QuickChatfun.Update_ChatBut_icon)
	C_Timer.After(5,QuickChatfun.Update_ChatBut_icon)
	C_Timer.After(10,QuickChatfun.Update_ChatBut_icon)
	--更新尺寸
	function QuickChatFFF:suofang()
		QuickChatFFF:SetScale(PIGA["Chat"]["QuickChat_suofang"]);
		QuickChatfun.Update_QuickChatPoint()
	end
	QuickChatFFF:suofang()
end