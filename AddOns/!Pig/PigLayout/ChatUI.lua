local _, addonTable = ...;
---
local PigLayoutFun=addonTable.PigLayoutFun
function PigLayoutFun.Options_ChatUI(openxx)
if not openxx then return end
---
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
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
-----
local Fun=addonTable.Fun
local RTabFrame =PigLayoutFun.RTabFrame
local ChatF,ChatFBut =PIGOptionsList_R(RTabFrame,CHAT..L["CHAT_TABNAME4"],90)

--聊天窗口可以移动到屏幕边缘
ChatF.MarginF = PIGFrame(ChatF,{"TOP", ChatF, "TOP", 0, -10},{ChatF:GetWidth()-20, 123})
ChatF.MarginF:PIGSetBackdrop(0)
function ChatF.MarginF.Set_Fun()	
	for id = 1, NUM_CHAT_WINDOWS do
		local Frame=_G["ChatFrame"..id]
		if PIGA["PigLayout"]["ChatUI"]["Margin"] then
			local L,R,T,B = unpack(PIGA["PigLayout"]["ChatUI"]["MarginPoint"])
			Frame:SetClampRectInsets(-L,R,T,-B)
		else
			Frame:SetClampRectInsets(-35, 35, 26, -50);
		end
	end	
end
function ChatF.MarginF.Update_Checkbut()
	ChatF.MarginF.Margin_L:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	ChatF.MarginF.Margin_R:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	ChatF.MarginF.Margin_T:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	ChatF.MarginF.Margin_B:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
end
ChatF.MarginF.Open = PIGCheckbutton(ChatF.MarginF,{"TOPLEFT",ChatF.MarginF,"TOPLEFT",10,-10},{L["CHAT_MARGIN"],L["CHAT_MARGINTIPS"].."\n保存玩家移动后的聊天窗口位置，防止边距小于系统设定值被系统重置为系统默认边距"})
ChatF.MarginF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Margin"]=true;
	else
		PIGA["PigLayout"]["ChatUI"]["Margin"]=false;
	end
	ChatF.MarginF.Set_Fun()
	ChatF.MarginF.Update_Checkbut()
end);
ChatF.MarginF.cz = PIGButton(ChatF.MarginF,{"LEFT",ChatF.MarginF.Open,"RIGHT",480,0},{60,22},"重置");
ChatF.MarginF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["MarginPoint"]
	ChatF.MarginF:Hide()
	ChatF.MarginF:Show()
	ChatF.MarginF.Set_Fun()
end);
ChatF.MarginF.Margin_L = PIGSlider(ChatF.MarginF,{"TOPLEFT",ChatF.MarginF.Open,"BOTTOMLEFT",90,-4},{0,50,1})
ChatF.MarginF.Margin_L.bt = PIGFontString(ChatF.MarginF.Margin_L,{"RIGHT", ChatF.MarginF.Margin_L, "LEFT", -10, 0},"左边距")
ChatF.MarginF.Margin_L.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][1]=arg1;
	ChatF.MarginF.Set_Fun()
end)
ChatF.MarginF.Margin_R = PIGSlider(ChatF.MarginF,{"LEFT",ChatF.MarginF.Margin_L,"RIGHT",120,0},{0,50,1})
ChatF.MarginF.Margin_R.bt = PIGFontString(ChatF.MarginF.Margin_R,{"RIGHT", ChatF.MarginF.Margin_R, "LEFT", -10, 0},"右边距")
ChatF.MarginF.Margin_R.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][2]=arg1;
	ChatF.MarginF.Set_Fun()
end)
ChatF.MarginF.Margin_T = PIGSlider(ChatF.MarginF,{"TOPLEFT",ChatF.MarginF.Margin_L,"BOTTOMLEFT",0,-8},{0,50,1})
ChatF.MarginF.Margin_T.bt = PIGFontString(ChatF.MarginF.Margin_T,{"RIGHT", ChatF.MarginF.Margin_T, "LEFT", -10, 0},"上边距")
ChatF.MarginF.Margin_T.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][3]=arg1;
	ChatF.MarginF.Set_Fun()
end)
ChatF.MarginF.Margin_B = PIGSlider(ChatF.MarginF,{"LEFT",ChatF.MarginF.Margin_T,"RIGHT",120,0},{0,50,1})
ChatF.MarginF.Margin_B.bt = PIGFontString(ChatF.MarginF.Margin_B,{"RIGHT", ChatF.MarginF.Margin_B, "LEFT", -10, 0},"下边距")
ChatF.MarginF.Margin_B.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][4]=arg1;
	ChatF.MarginF.Set_Fun()
end)
ChatF.MarginF:HookScript("OnShow", function (self)
	self.Update_Checkbut()
	self.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Margin"])
	local L,R,T,B = unpack(PIGA["PigLayout"]["ChatUI"]["MarginPoint"])
	self.Margin_L:PIGSetValue(L)
	self.Margin_R:PIGSetValue(R)
	self.Margin_T:PIGSetValue(T)
	self.Margin_B:PIGSetValue(B)
end);

--设置主聊天宽度
ChatF.zhuF = PIGFrame(ChatF,{"TOP", ChatF.MarginF, "BOTTOM", 0, -10},{ChatF:GetWidth()-20, 123})
ChatF.zhuF:PIGSetBackdrop(0)
function ChatF.zhuF.Set_Fun()
	if not PIGA["PigLayout"]["ChatUI"]["Zhu"] then return end
	local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["ZhuPoint"])
	local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight();
	local X,Y = X/screenWidth,Y/screenHeight
	SetChatWindowSavedPosition(1, "BOTTOMLEFT", X,Y);
	SetChatWindowSavedDimensions(1, W,H);
	FCF_RestorePositionAndDimensions(ChatFrame1)
end
function ChatF.zhuF.Update_Checkbut()
	ChatF.zhuF.Width:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	ChatF.zhuF.Height:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	ChatF.zhuF.X:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	ChatF.zhuF.Y:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
end
ChatF.zhuF.Open = PIGCheckbutton(ChatF.zhuF,{"TOPLEFT",ChatF.zhuF,"TOPLEFT",10,-10},{L["CHAT_ZHUCHATF"]})
ChatF.zhuF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Zhu"]=true;
		ChatF.zhuF.Set_Fun()
	else
		PIGA["PigLayout"]["ChatUI"]["Zhu"]=false;
	end
	ChatF.zhuF.Update_Checkbut()
end);
ChatF.zhuF.cz = PIGButton(ChatF.zhuF,{"LEFT",ChatF.zhuF.Open,"RIGHT",480,0},{60,22},"重置");
ChatF.zhuF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["ZhuPoint"]
	ChatF.zhuF:Hide()
	ChatF.zhuF:Show()
	ChatF.zhuF.Set_Fun()
end);
ChatF.zhuF.Width = PIGSlider(ChatF.zhuF,{"TOPLEFT",ChatF.zhuF.Open,"BOTTOMLEFT",90,-4},{150,800,1})
ChatF.zhuF.Width.bt = PIGFontString(ChatF.zhuF.Width,{"RIGHT", ChatF.zhuF.Width, "LEFT", -10, 0},L["CHAT_ZHUCHATFW"])
ChatF.zhuF.Width.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][1]=arg1;
	ChatF.zhuF.Set_Fun()
end)
ChatF.zhuF.Height = PIGSlider(ChatF.zhuF,{"LEFT",ChatF.zhuF.Width,"RIGHT",120,0},{120,500,1})
ChatF.zhuF.Height.bt = PIGFontString(ChatF.zhuF.Height,{"RIGHT", ChatF.zhuF.Height, "LEFT", -10, 0},L["CHAT_ZHUCHATFH"])
ChatF.zhuF.Height.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][2]=arg1;
	ChatF.zhuF.Set_Fun()
end)
ChatF.zhuF.X = PIGSlider(ChatF.zhuF,{"TOPLEFT",ChatF.zhuF.Width,"BOTTOMLEFT",0,-8},{0,400,1})
ChatF.zhuF.X.bt = PIGFontString(ChatF.zhuF.X,{"RIGHT", ChatF.zhuF.X, "LEFT", -10, 0},"左边距")
ChatF.zhuF.X.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][3]=arg1;
	ChatF.zhuF.Set_Fun()
end)
ChatF.zhuF.Y = PIGSlider(ChatF.zhuF,{"LEFT",ChatF.zhuF.X,"RIGHT",120,0},{0,200,1})
ChatF.zhuF.Y.bt = PIGFontString(ChatF.zhuF.Y,{"RIGHT", ChatF.zhuF.Y, "LEFT", -10, 0},"下边距")
ChatF.zhuF.Y.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][4]=arg1;
	ChatF.zhuF.Set_Fun()
end)
-----
ChatF.zhuF:HookScript("OnShow", function(self)
	self.Update_Checkbut()
	self.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["ZhuPoint"])
	self.Width:PIGSetValue(W)
	self.Height:PIGSetValue(H)
	self.X:PIGSetValue(X)
	self.Y:PIGSetValue(Y)
end)

--设置副聊天宽度
ChatF.fuF = PIGFrame(ChatF,{"TOP", ChatF.zhuF, "BOTTOM", 0, -10},{ChatF:GetWidth()-20, 160})
ChatF.fuF:PIGSetBackdrop(0)

ChatF.fuF.ChatUIList=PIGDownMenu(ChatF.fuF,{"TOPLEFT",ChatF.fuF,"TOPLEFT",10,-10},{120,nil})
function ChatF.fuF.ChatUIList:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	local chuangkoulist=Fun.GetpindaoList()
	for k,v in pairs(chuangkoulist) do
	 	info.text, info.arg1 = v, k
	 	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	 	info.checked = v == pindaoname
		self:PIGDownMenu_AddButton(info)
	end 
end
function ChatF.fuF.ChatUIList:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["PigLayout"]["ChatUI"]["FuName"]=value
	ChatF.fuF.Set_Fun(true)
	ChatF.fuF.Update_Checkbut()
	PIGCloseDropDownMenus()
end
ChatF.fuF.ChatUIList.errtisp = PIGFontString(ChatF.fuF.ChatUIList,{"LEFT",ChatF.fuF.ChatUIList,"RIGHT",10,0})
ChatF.fuF.ChatUIList.errtisp:SetTextColor(1, 0, 0, 1);
ChatF.fuF.ChatUIList.fenli = PIGButton(ChatF.fuF.ChatUIList,{"LEFT",ChatF.fuF.ChatUIList.errtisp,"RIGHT",10,0},{60,24},"分离")
ChatF.fuF.ChatUIList.fenli:Hide()
ChatF.fuF.ChatUIList.fenli:SetScript("OnClick", function (self)
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	if pindaoid>0 then
		local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(pindaoid);
		if docked~=nil then
			FCF_UnDockFrame(_G["ChatFrame"..pindaoid]);
			ChatF.fuF.ChatUIList.errtisp:SetText("") 
			ChatF.fuF.ChatUIList.fenli:Hide()
			ChatF.fuF.Set_Fun(true)
			ChatF.fuF.Update_Checkbut()
			return
		end
	end
end);
ChatF.fuF.Open = PIGCheckbutton(ChatF.fuF,{"TOPLEFT",ChatF.fuF.ChatUIList,"BOTTOMLEFT",0,-10},{L["CHAT_LOOTCHATF"]})
ChatF.fuF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Fu"]=true;
	else
		PIGA["PigLayout"]["ChatUI"]["Fu"]=false;
	end
	ChatF.fuF.Set_Fun(true)
	ChatF.fuF.Update_Checkbut()
end);
ChatF.fuF.cz = PIGButton(ChatF.fuF,{"LEFT",ChatF.fuF.Open,"RIGHT",480,0},{60,22},"重置");
ChatF.fuF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["FuPoint"]
	ChatF.fuF:Hide()
	ChatF.fuF:Show()
	ChatF.fuF.Set_Fun(true)
end);
ChatF.fuF.Width = PIGSlider(ChatF.fuF,{"TOPLEFT",ChatF.fuF.Open,"BOTTOMLEFT",90,-4},{150,800,1})
ChatF.fuF.Width.bt = PIGFontString(ChatF.fuF.Width,{"RIGHT", ChatF.fuF.Width, "LEFT", -10, 0},L["CHAT_ZHUCHATFW"])
ChatF.fuF.Width.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][1]=arg1;
	ChatF.fuF.Set_Fun()
end)
ChatF.fuF.Height = PIGSlider(ChatF.fuF,{"LEFT",ChatF.fuF.Width,"RIGHT",120,0},{120,500,1})
ChatF.fuF.Height.bt = PIGFontString(ChatF.fuF.Height,{"RIGHT", ChatF.fuF.Height, "LEFT", -10, 0},L["CHAT_ZHUCHATFH"])
ChatF.fuF.Height.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][2]=arg1;
	ChatF.fuF.Set_Fun()
end)
ChatF.fuF.X = PIGSlider(ChatF.fuF,{"TOPLEFT",ChatF.fuF.Width,"BOTTOMLEFT",0,-8},{0,400,1})
ChatF.fuF.X.bt = PIGFontString(ChatF.fuF.X,{"RIGHT", ChatF.fuF.X, "LEFT", -10, 0},"右边距")
ChatF.fuF.X.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][3]=arg1;
	ChatF.fuF.Set_Fun()
end)
ChatF.fuF.Y = PIGSlider(ChatF.fuF,{"LEFT",ChatF.fuF.X,"RIGHT",120,0},{0,200,1})
ChatF.fuF.Y.bt = PIGFontString(ChatF.fuF.Y,{"RIGHT", ChatF.fuF.Y, "LEFT", -10, 0},"下边距")
ChatF.fuF.Y.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][4]=arg1;
	ChatF.fuF.Set_Fun()
end)
--
local function tishiTxt(errid)
	ChatF.fuF.ChatUIList.errtisp:SetText("") 
	ChatF.fuF.ChatUIList.fenli:Hide()
	if errid==1 then
		ChatF.fuF.Open:SetChecked(false) 
		ChatF.fuF.ChatUIList.errtisp:SetText("请先选择一个聊天窗口")
	elseif errid==2 then
		ChatF.fuF.Open:SetChecked(false)
		ChatF.fuF.ChatUIList.errtisp:SetText("此聊天窗口未分离，点击分离") 
		ChatF.fuF.ChatUIList.fenli:Show()
	end
end
function ChatF.fuF.Set_Fun(set)
	ChatF.fuF.pindaoname=false
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	if pindaoid>0 then
		local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(pindaoid);
		if docked~=nil then
			PIGA["PigLayout"]["ChatUI"]["Fu"]=false;
			if set then tishiTxt(2) end
			return
		end
		tishiTxt(errid)
		ChatF.fuF.pindaoname=true
		if PIGA["PigLayout"]["ChatUI"]["Fu"] then
			local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["FuPoint"])
			local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight();
			local X,Y = X/screenWidth,Y/screenHeight
			SetChatWindowSavedPosition(pindaoid, "BOTTOMRIGHT", -X,Y);
			SetChatWindowSavedDimensions(pindaoid, W,H);
			FCF_RestorePositionAndDimensions(_G["ChatFrame"..pindaoid])
			FCF_UpdateButtonSide(_G["ChatFrame"..pindaoid]);
	 	end
	else
		PIGA["PigLayout"]["ChatUI"]["Fu"]=false;
		if set then tishiTxt(1) end
	end
end
function ChatF.fuF.Update_Checkbut()
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	ChatF.fuF.ChatUIList:PIGDownMenu_SetText(pindaoname)
	ChatF.fuF.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Fu"])
	if ChatF.fuF.pindaoname then
		ChatF.fuF.Open:SetEnabled(true)
		ChatF.fuF.Width:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		ChatF.fuF.Height:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		ChatF.fuF.X:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		ChatF.fuF.Y:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
	else
		ChatF.fuF.Open:SetEnabled(false)
		ChatF.fuF.Width:SetEnabled(false)
		ChatF.fuF.Height:SetEnabled(false)
		ChatF.fuF.X:SetEnabled(false)
		ChatF.fuF.Y:SetEnabled(false)
	end	
end
-----
ChatF.fuF:HookScript("OnShow", function(self)
	self.Update_Checkbut()
	local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["FuPoint"])
	self.Width:PIGSetValue(W)
	self.Height:PIGSetValue(H)
	self.X:PIGSetValue(X)
	self.Y:PIGSetValue(Y)
end)

-- --LOOT=======================================
-- --FCF_ResetChatWindows();--恢复聊天设置为默认
-- --FCF_ResetChatWindows(); -- 重置聊天设置
-- --FCF_SetLocked(_G.ChatFrame1, 1) --锁定聊天窗口移动
-- --FCF_DockFrame(_G.ChatFrame2,3)  --设置窗口是否停靠参数2为停靠位置
-- --FCF_UnDockFrame(_G["ChatFrame"..NewWindow_ID]); --分离窗口
-- --FCF_NewChatWindow(L["CHAT_LOOTFNAME"])--用户手动创建新窗口
-- --FCF_OpenNewWindow(L["CHAT_LOOTFNAME"]);--创建聊天窗口 
-- --FCF_SetWindowName(_G.ChatFrame2, "记录");
-- --FCF_UpdateButtonSide(_G["ChatFrame"..id]);--刷新按钮位置

-- ChatF.LOOTF = PIGFrame(ChatF,{"TOP", ChatF, "TOP", 0, -250},{ChatF:GetWidth()-20, 150})
-- ChatF.LOOTF:PIGSetBackdrop()
-- ChatF.LOOTF.add = PIGButton(ChatF.LOOTF,{"TOPLEFT",ChatF.LOOTF,"TOPLEFT",4,-8},{150,22},L["CHAT_LOOTFADD"]);
-- --重设窗口显示内容
-- local function ShowChannelFun()
-- 	--综合
-- 	if ChatF.Chatloot and PIGA["PigLayout"]["ChatUI"]["ShowChannel"] then
-- 		local chatGroup1 = { "SYSTEM", "CHANNEL", "SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "ERRORS", "AFK", "DND", "IGNORED", "BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL", "ACHIEVEMENT", "GUILD_ACHIEVEMENT", "BN_WHISPER", "BN_INLINE_TOAST_ALERT","TARGETICONS" }
-- 		ChatFrame_RemoveAllMessageGroups(DEFAULT_CHAT_FRAME)
-- 		for _, v in ipairs(chatGroup1) do
-- 			ChatFrame_AddMessageGroup(DEFAULT_CHAT_FRAME, v)
-- 		end
-- 		--拾取窗口
-- 		local chatGroup3 = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "MONEY", "LOOT", "TRADESKILLS", "OPENING", "PET_INFO", "COMBAT_MISC_INFO" }
-- 		for id=1,NUM_CHAT_WINDOWS,1 do
-- 			local name, __ = GetChatWindowInfo(id);
-- 			if name==L["CHAT_LOOTFNAME"] then
-- 				ChatFrame_RemoveAllMessageGroups(_G["ChatFrame"..id])
-- 				for _, v in ipairs(chatGroup3) do
-- 					ChatFrame_AddMessageGroup(_G["ChatFrame"..id], v)
-- 				end
-- 				break
-- 			end
-- 		end
-- 		for id=1,NUM_CHAT_WINDOWS,1 do
-- 			local name, __ = GetChatWindowInfo(id);
-- 			if name==COMBAT_LOG then
-- 				FCF_SetWindowName(_G["ChatFrame"..id], COMBAT_LABEL);
-- 				break
-- 			end
-- 		end
-- 	end
-- end
-- local tishims = {L["CHAT_LOOTFNRSET"],L["CHAT_LOOTFNRSETTIPS"]}
-- ChatF.LOOTF.ShowChannel = PIGCheckbutton(ChatF.LOOTF,{"LEFT",ChatF.LOOTF.add,"RIGHT",60,-2},tishims)
-- ChatF.LOOTF.ShowChannel:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["PigLayout"]["ChatUI"]["ShowChannel"]=true;
-- 	else
-- 		PIGA["PigLayout"]["ChatUI"]["ShowChannel"]=false;
-- 	end
-- 	ShowChannelFun()
-- end);
-- --提示
-- ChatF.LOOTF.tishi = CreateFrame("Frame", nil, ChatF.LOOTF);
-- ChatF.LOOTF.tishi:SetSize(30,30);
-- ChatF.LOOTF.tishi:SetPoint("LEFT",ChatF.LOOTF.add,"RIGHT",0,0);
-- ChatF.LOOTF.tishi.Texture = ChatF.LOOTF.tishi:CreateTexture(nil, "BORDER");
-- ChatF.LOOTF.tishi.Texture:SetTexture("interface/common/help-i.blp");
-- ChatF.LOOTF.tishi.Texture:SetAllPoints(ChatF.LOOTF.tishi)
-- PIGEnter(ChatF.LOOTF.tishi,L["LIB_TIPS"]..": ",L["CHAT_LOOTFTIPS"])
-- ChatF.LOOTF.ShowlootF = PIGButton(ChatF.LOOTF,{"TOPLEFT",ChatF.LOOTF,"TOPLEFT",410,-8},{150,22},L["CHAT_LOOTFFENLI"]);
-- ChatF.LOOTF.ShowlootF:SetScript("OnClick", function (self)
-- 	if ChatF.ChatlootID then
-- 		local lotofa = _G["ChatFrame"..ChatF.ChatlootID]
-- 		local lotofaTab = _G["ChatFrame"..ChatF.ChatlootID.."Tab"]
-- 		if lotofa:IsShown() then
-- 			lotofa:Hide()
-- 			lotofaTab:Hide()
-- 		else
-- 			--FCF_SetLocked(lotofa, 2)
-- 			FCF_UnDockFrame(lotofa);
-- 			lotofa:Show()
-- 			lotofaTab:Show()
-- 		end
-- 	end
-- end);
-- end
-- --拾取窗口位置
-- ChatF.Chatloot = false
-- ChatF.ChatlootNum=0
-- local function LOOT_cunzai()
-- 	if NUM_CHAT_WINDOWS~=nil then
-- 		for id=1,NUM_CHAT_WINDOWS,1 do
-- 			local name, __ = GetChatWindowInfo(id);
-- 			if name==L["CHAT_LOOTFNAME"] then
-- 				--print(name)
-- 				ChatF.Chatloot = true
-- 				ChatF.ChatlootID = id
-- 				return id
-- 			end
-- 		end
-- 	end
-- end
-- local function LOOT_SetValueText()
-- 	LOOT_cunzai()
-- 	if ChatF.Chatloot then
-- 		ShowChannelFun()

-- 	else
-- 		if ChatF.ChatlootNum<10 then
-- 			C_Timer.After(1, LOOT_SetValueText)
-- 			ChatF.ChatlootNum=ChatF.ChatlootNum+1
-- 		end
-- 	end
-- end
-- --创建拾取聊天窗口
-- ChatF.LOOTF.add:SetScript("OnClick", function ()
-- 	if ChatF.Chatloot then return end
-- 	if GetScreenWidth()<1024 then PIGTopMsg:add(L["CHAT_LOOTFADDERR1"]) end
-- 	if FCF_GetNumActiveChatFrames()>=10 then PIGTopMsg:add(L["CHAT_LOOTFADDERR2"]) end
-- 	FCF_OpenNewWindow(L["CHAT_LOOTFNAME"]);
-- 	ShowChannelFun()
-- 	local nEWid=LOOT_cunzai()
-- 	local chfff = _G["ChatFrame"..nEWid]
-- 	FCF_UnDockFrame(chfff);
-- 	chfff:ClearAllPoints();
-- 	chfff:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-PIGA["PigLayout"]["ChatUI"]["Loot_Point_X"],PIGA["PigLayout"]["ChatUI"]["Loot_Point_Y"]);
-- 	_G["ChatFrame"..nEWid.."Tab"]:ClearAllPoints();
-- 	_G["ChatFrame"..nEWid.."Tab"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..nEWid.."Background"], "TOPLEFT", 2, 0);
-- 	FCF_UpdateButtonSide(chfff);--刷新按钮位置
-- 	LOOT_Width_Heigh_Point_XY()
-- end)
-- ----
-- ChatF.LOOTF:HookScript("OnShow", function(self)
-- 	LOOT_Width_Heigh_Point_XY()
-- 	ChatF.LOOTF.ShowChannel:SetChecked(PIGA["PigLayout"]["ChatUI"]["ShowChannel"])
-- end)
-- ---重置聊天设置
-- ChatF.ReChatBut = PIGButton(ChatF,{"BOTTOMLEFT",ChatF,"BOTTOMLEFT",14,14},{120,24},L["CHAT_RECHATBUT"]);
-- ChatF.ReChatBut:SetScript("OnClick", function ()
-- 	FCF_ResetChatWindows();
-- end)
--导入其他角色聊天设置
local function SavedangqianSet()--保存当前设置
	-- local PIG_renwuming = Pig_OptionsUI.AllName
	-- local dangqianChatSET={}
	-- --for id=1,MAX_WOW_CHAT_CHANNELS do
	-- for id=1,3 do
	-- 	local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(id);
	-- 	--local name, __ = GetChatWindowInfo(id);
	-- 	print(name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable)
	-- 	local type1 = {GetChatWindowMessages(id)}
	-- 	for i=1,#type1 do
	-- 		print(type1[i])
	-- 	end
	-- 	print("++=====")
	-- 	local name1 = {GetChatWindowChannels(id)}
	-- 	for i=1,#name1 do
	-- 		print(name1[i])
	-- 	end
	-- end

	-- PIGA["Chat"]["ChatSetSave"][PIG_renwuming]=dangqianChatSET
end
-- ChatF.daoruqitaSet =PIGDownMenu(ChatF,{"BOTTOMLEFT",ChatF,"BOTTOMLEFT",20,14},{200,nil})
-- function ChatF.daoruqitaSet:PIGDownMenu_Update_But()
-- 	local Setinfo =PIGA["Chat"]["ChatSetSave"]
-- 	local info = {}
-- 	info.func = self.PIGDownMenu_SetValue
-- 	for k,v in pairs(Setinfo) do
-- 		print(k,v)
-- 		info.text, info.arg1 = L["CONFIG_DAORU"].."<"..k..">"..L["CONFIG_TABNAME"],v
-- 		self:PIGDownMenu_AddButton(info)
-- 	end
-- end
-- function ChatF.daoruqitaSet:PIGDownMenu_SetValue(value,arg1)
-- 	self:PIGDownMenu_SetText(L["CHAT_DAORUQITASET"])
-- 	print(value,arg1)	
-- 	PIGA["Chat"]["ChatSetSave"][PIG_renwuming]=arg1
-- 	PIGCloseDropDownMenus()
-- end
-- ChatF.daoruqitaSet:PIGDownMenu_SetText(L["CHAT_DAORUQITASET"])
-----------
ChatF.MarginF.Set_Fun()
ChatF.zhuF.Set_Fun()
ChatF.fuF.Set_Fun(set)
C_Timer.After(1,function() ChatF.fuF.Set_Fun(set) end)
end