local addonName, addonTable = ...;
local L=addonTable.locale
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
local function GetBanChatFrame(pindaoid)
	local SetChatFrame = _G["ChatFrame"..pindaoid]
	if SetChatFrame then
		return SetChatFrame
	end
	return ChatFrame1
end
local function PIG_IsShow_Message(messageType)
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["Chat"]["QuickChat_Ban"],true)
	local pindaomulu = {GetChatWindowMessages(pindaoid)}
	for i=1,#pindaomulu do
		if ( pindaomulu[i] == messageType ) then
			return true;
		end
	end
	return false;
end
local function PIG_IsShow_CHANNEL(pdname)
	-- local channels = {GetChannelList()}
	-- for x=1,#channels,3 do
	-- 	local id, name, disabled=channels[x], channels[x+1], channels[x+2]
	-- end
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["Chat"]["QuickChat_Ban"],true)
	local channels = {GetChatWindowChannels(pindaoid)}
	for x=1,#channels,2 do
		if pdname==channels[x] then
			return true
		end
		if pdname==worldname then
			for x=1,ChatpindaoMAX do
				local newpindaoname = pdname..x
				if channels[x]==newpindaoname then
					return true
				end
			end
		end
	end
	return false
end
-------------
local function ADD_chatbut(fuF,pdtype,name,chatID,Color,pdname)
	if name and PIGA["Chat"]["QuickChat_ButHide"][name] then return end
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
		chatbut:SetScript("OnClick", function(self, button)
			local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["Chat"]["QuickChat_Ban"],true)
			--local chatFrame = SELECTED_DOCK_FRAME--当前选择聊天框架
			--local SetChatFrame = DEFAULT_CHAT_FRAME
			local SetChatFrame = GetBanChatFrame(pindaoid)
			if pdtype=="Mes" then	
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
					if PIG_IsShow_Message(pdname) then
						ChatFrame_RemoveMessageGroup(SetChatFrame, pdname);
						if pdname=="RAID" then
							ChatFrame_RemoveMessageGroup(SetChatFrame, "RAID_LEADER");
						end
						if pdname=="PARTY" then
							ChatFrame_RemoveMessageGroup(SetChatFrame, "PARTY_LEADER");
						end
						if pdname=="INSTANCE_CHAT" then
							ChatFrame_RemoveMessageGroup(SetChatFrame, "INSTANCE_CHAT_LEADER");
						end
						if pdname=="GUILD" then
							ChatFrame_RemoveMessageGroup(SetChatFrame, "OFFICER");
						end
						PIG_print(IGNORE.._G[pdname]..CHANNEL..INFO);
						self.X:Show();
					else
						ChatFrame_AddMessageGroup(SetChatFrame, pdname);
						if pdname=="RAID" then
							ChatFrame_AddMessageGroup(SetChatFrame, "RAID_LEADER");
						end
						if pdname=="PARTY" then
							ChatFrame_AddMessageGroup(SetChatFrame, "PARTY_LEADER");
						end
						if pdname=="INSTANCE_CHAT" then
							ChatFrame_AddMessageGroup(SetChatFrame, "INSTANCE_CHAT_LEADER");
						end
						if pdname=="GUILD" then
							ChatFrame_AddMessageGroup(SetChatFrame, "OFFICER");
						end
						PIG_print(IGNORE_REMOVE.._G[pdname]..CHANNEL..INFO);
						self.X:Hide();
					end
				end
			elseif pdtype=="CHANNEL" then
				self.pindaoID = GetPIGID(chatID)
				if button=="LeftButton" then
					if self.pindaoID==0 then
						--JoinPermanentChannel(chatID, nil, pindaoid, 1);
						JoinTemporaryChannel(chatID, nil, pindaoid, 1);
						ChatFrame_AddChannel(SetChatFrame, chatID)--订购一个聊天框以显示先前加入的聊天频道
						if GetPIGID(chatID)>0 then
							chatbut.X:Hide();
							PIG_print(CHAT_JOIN..chatID..CHANNEL.."，"..KEY_BUTTON2..IGNORE..CHANNEL..INFO);
						else
							PIG_print(CHAT_JOIN..chatID..CHANNEL..FAILED.."，请稍后再试");
						end
					else
						ChatFrame_AddChannel(SetChatFrame, chatID)
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
						if PIG_IsShow_CHANNEL(chatID) then
							if chatID==GENERAL then
								ChatFrame_RemoveChannel(SetChatFrame, FUWUPINDAONAME);
								ChatFrame_RemoveChannel(SetChatFrame, "本地防务");
								ChatFrame_RemoveChannel(SetChatFrame, "世界防务");
								PIG_print(IGNORE..chatID.."/"..FUWUPINDAONAME..CHANNEL..INFO);
							else
								PIG_print(IGNORE..chatID..CHANNEL..INFO);
							end
							ChatFrame_RemoveChannel(SetChatFrame, chatID);
							self.X:Show();
						else
							ChatFrame_AddChannel(SetChatFrame, chatID)
							if chatID==GENERAL then
								ChatFrame_AddChannel(SetChatFrame, FUWUPINDAONAME);
								ChatFrame_AddChannel(SetChatFrame, "本地防务");
								ChatFrame_AddChannel(SetChatFrame, "世界防务");
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
			end
		end);
	end
	return chatbut
end
---更新按钮的屏蔽状态
function QuickChatfun.Update_ChatBut_icon()
	if QuickChatfun.TabButUI then
		local changuipindaoX = {
			{QuickChatfun.TabButUI.SAY,"SAY"},
			{QuickChatfun.TabButUI.YELL,"YELL"},
			{QuickChatfun.TabButUI.PARTY,"PARTY"},
			{QuickChatfun.TabButUI.GUILD,"GUILD"},
			{QuickChatfun.TabButUI.RAID,"RAID"},
			{QuickChatfun.TabButUI.RAID_WARNING,"RAID_WARNING"},
			{QuickChatfun.TabButUI.INSTANCE_CHAT,"INSTANCE_CHAT"},
		}
		local changuipindao = {}
		for i=1,#changuipindaoX do
			if changuipindaoX[i][1] then
				table.insert(changuipindao,{changuipindaoX[i][1].X,changuipindaoX[i][2]})
			end
		end
		for i=1,#changuipindao do
			if PIG_IsShow_Message(changuipindao[i][2]) then
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
			{"CHANNEL_4",worldname},
		}
		for i=1,#chaozhaopindaoX do
			if QuickChatfun.TabButUI[chaozhaopindaoX[i][1]] then
				if PIG_IsShow_CHANNEL(chaozhaopindaoX[i][2]) then
					QuickChatfun.TabButUI[chaozhaopindaoX[i][1]].X:Hide();
				else
					QuickChatfun.TabButUI[chaozhaopindaoX[i][1]].X:Show();
				end
			end
		end
	end
end
---快捷切换频道按钮位置=======	
function QuickChatfun.Update_QuickChatPoint(arg1)
	local arg1=arg1 or PIGA["Chat"]["QuickChat_maodian"]
	if QuickChatfun.TabButUI then
		QuickChatfun.TabButUI:ClearAllPoints();	
		if arg1==1 then	
			QuickChatfun.TabButUI:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",0+PIGA["Chat"]["QuickChat_pianyiX"],28+PIGA["Chat"]["QuickChat_pianyiY"]);
		elseif arg1==2 then
			QuickChatfun.TabButUI:SetPoint("TOPLEFT",ChatFrame1,"BOTTOMLEFT",-2+PIGA["Chat"]["QuickChat_pianyiX"],-4+PIGA["Chat"]["QuickChat_pianyiY"]);
		end	
		addonTable.QuickChatfun.Update_editBoxPoint()
	end
end
function QuickChatfun.TabBut()
	if not PIGA["Chat"]["QuickChat"] then return end
	if QuickChatfun.TabButUI then return end
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
	local QuickTabBut = CreateFrame("Frame", nil, UIParent);
	QuickChatfun.TabButUI=QuickTabBut
	QuickTabBut.Width=Width
	QuickTabBut:SetSize(Width,Width);
	QuickTabBut:SetFrameStrata("LOW")
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
	function QuickTabBut:PIGEnterAlpha()
		self:SetAlpha(1)
	end
	function QuickTabBut:PIGLeaveAlpha()
		if PIGA["Chat"]["QuickChat_jianyin"] then self:SetAlpha(0.06) end
	end
	local function SetEnterLeave(fuix)
		fuix:HookScript("OnEnter", function (self)	
			QuickTabBut:PIGEnterAlpha()
		end);
		fuix:HookScript("OnLeave", function (self)
			QuickTabBut:PIGLeaveAlpha()
		end);
	end
	for i = 1, NUM_CHAT_WINDOWS do
		local chatF = _G["ChatFrame"..i]
		SetEnterLeave(chatF)
		local chatTab = _G["ChatFrame"..i.."Tab"]
		SetEnterLeave(chatTab)
	end
	-------
	QuickTabBut.biaoqing = ADD_chatbut(QuickTabBut,"bq")
	QuickTabBut.biaoqing.F = CreateFrame("Frame", nil, QuickTabBut.biaoqing,"BackdropTemplate");
	QuickTabBut.biaoqing.F:SetBackdrop( { 
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",tile = false, tileSize = 0,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 8, 
		insets = { left = 2, right = 2, top = 2, bottom = 2 }});
	QuickTabBut.biaoqing.F:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
	QuickTabBut.biaoqing.F:SetBackdropColor(0.5, 0.5, 0.5, 0.8);
	QuickTabBut.biaoqing.F:SetSize((Width+2)*hangshu+10,Width*6+20);
	QuickTabBut.biaoqing.F:SetPoint("BOTTOMLEFT",QuickTabBut.biaoqing,"TOPLEFT", 0, 0);
	QuickTabBut.biaoqing.F:Hide()
	QuickTabBut.biaoqing.F:SetFrameStrata("HIGH")
	QuickTabBut.biaoqing.F.xiaoshidaojishi = 0;
	QuickTabBut.biaoqing.F.zhengzaixianshi = nil;
	QuickTabBut.biaoqing.F:SetScript("OnUpdate", function(self, ssss)
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
	QuickTabBut.biaoqing.F:SetScript("OnEnter", function(self)
		self.zhengzaixianshi = nil;
	end)
	QuickTabBut.biaoqing.F:SetScript("OnLeave", function(self)
		self.xiaoshidaojishi = 1.5;
		self.zhengzaixianshi = true;
	end)
	QuickTabBut.biaoqing.F.ButList={}
	for i=1,#biaoqingData do
		local biaoqinglist = CreateFrame("Button",nil,QuickTabBut.biaoqing.F,nil,i);
		QuickTabBut.biaoqing.F.ButList[i]=biaoqinglist
		biaoqinglist:SetSize(Width,Width);
		if i==1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F,"TOPLEFT", 5, -5);
		elseif i<hangshu+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		elseif i==hangshu+1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F.ButList[1],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*2+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		elseif i==hangshu*2+1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F.ButList[11],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*3+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		elseif i==hangshu*3+1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F.ButList[21],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*4+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		elseif i==hangshu*4+1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F.ButList[31],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*5+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		elseif i==hangshu*5+1 then
			biaoqinglist:SetPoint("TOPLEFT",QuickTabBut.biaoqing.F.ButList[41],"BOTTOMLEFT", 0, -2);
		elseif i<hangshu*6+1 then
			biaoqinglist:SetPoint("LEFT",QuickTabBut.biaoqing.F.ButList[i-1],"RIGHT", 2, 0);
		end
		biaoqinglist.Tex = biaoqinglist:CreateTexture();
		biaoqinglist.Tex:SetTexture(biaoqingData[i][2]);
		biaoqinglist.Tex:SetPoint("CENTER",0,0);
		biaoqinglist.Tex:SetSize(Width,Width);
		biaoqinglist:SetScript("OnEnter", function()
			QuickTabBut.biaoqing.F.zhengzaixianshi=nil
		end)
		biaoqinglist:SetScript("OnLeave", function()
			QuickTabBut.biaoqing.F.xiaoshidaojishi = 1.5;
			QuickTabBut.biaoqing.F.zhengzaixianshi = true;
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
			QuickTabBut.biaoqing.F:Hide();
		end)
	end
	--说--
	QuickTabBut.SAY = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][1],"s",{1, 1, 1},"SAY")
	--喊--
	QuickTabBut.YELL = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][2],"y",{1, 0.25, 0.25},"YELL")
	--队伍--
	QuickTabBut.PARTY = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][3],"p",{0.6667, 0.6667, 1},"PARTY")
	--公会--
	QuickTabBut.GUILD = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][4],"g",{0.25, 1, 0.25},"GUILD")
	--团队--
	QuickTabBut.RAID = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][5],"ra",{1, 0.498, 0},"RAID")
	--团队通知--
	QuickTabBut.RAID_WARNING = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][6],"rw",{1, 0.282, 0},"RAID_WARNING")
	--战场/副本--
	if PIG_MaxTocversion(30000) then
		QuickTabBut.INSTANCE_CHAT = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][7],"bg",{1, 0.498, 0},"INSTANCE_CHAT")
	else
		QuickTabBut.INSTANCE_CHAT = ADD_chatbut(QuickTabBut,"Mes",L["CHAT_QUKBUTNAME"][7],"i",{1, 0.498, 0},"INSTANCE_CHAT")
	end
	--CHANNEL--
	QuickTabBut.CHANNEL_1 = ADD_chatbut(QuickTabBut,"CHANNEL",L["CHAT_QUKBUTNAME"][8],GENERAL,{0.888, 0.668, 0.668})
	QuickTabBut.CHANNEL_2 = ADD_chatbut(QuickTabBut,"CHANNEL",L["CHAT_QUKBUTNAME"][9],TRADE,{0.888, 0.668, 0.668})
	QuickTabBut.CHANNEL_3 = ADD_chatbut(QuickTabBut,"CHANNEL",L["CHAT_QUKBUTNAME"][10],LOOK_FOR_GROUP,{0.888, 0.668, 0.668})
	QuickTabBut.CHANNEL_4 = ADD_chatbut(QuickTabBut,"CHANNEL",L["CHAT_QUKBUTNAME"][11],worldname,{0.888, 0.668, 0.668})
	--
	QuickChatfun.QuickBut_Keyword()
	QuickChatfun.QuickBut_Roll()
	QuickChatfun.QuickBut_Stats()
	QuickChatfun.QuickBut_Jilu()
	QuickChatfun.Update_QuickChatPoint(PIGA["Chat"]["QuickChat_maodian"])
	C_Timer.After(3,QuickChatfun.Update_ChatBut_icon)
	C_Timer.After(5,QuickChatfun.Update_ChatBut_icon)
	C_Timer.After(10,QuickChatfun.Update_ChatBut_icon)
	--更新尺寸
	function QuickTabBut:PIGScale()
		QuickTabBut:SetScale(PIGA["Chat"]["QuickChat_suofang"]);
		QuickChatfun.Update_QuickChatPoint()
	end
	QuickTabBut:PIGScale()
	QuickTabBut:PIGLeaveAlpha()
end