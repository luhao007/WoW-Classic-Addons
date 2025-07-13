local _, addonTable = ...;
---
local PigLayoutFun=addonTable.PigLayoutFun
function PigLayoutFun.Options_ChatUI(openxx)
if not openxx then return end
---
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
-----
local Fun=addonTable.Fun
local RTabFrame =PigLayoutFun.RTabFrame
local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,CHAT..L["LIB_LAYOUT"],90)

--聊天窗口可以移动到屏幕边缘
fujiF.MarginF = PIGFrame(fujiF,{"TOP", fujiF, "TOP", 0, -10},{fujiF:GetWidth()-20, 123})
fujiF.MarginF:PIGSetBackdrop(0)
function fujiF.MarginF.Set_Fun()	
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
function fujiF.MarginF.Update_Checkbut()
	fujiF.MarginF.Margin_L:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	fujiF.MarginF.Margin_R:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	fujiF.MarginF.Margin_T:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
	fujiF.MarginF.Margin_B:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Margin"])
end
fujiF.MarginF.Open = PIGCheckbutton(fujiF.MarginF,{"TOPLEFT",fujiF.MarginF,"TOPLEFT",10,-10},{L["CHAT_MARGIN"],L["CHAT_MARGINTIPS"].."\n保存玩家移动后的聊天窗口位置，防止边距小于系统设定值被系统重置为系统默认边距"})
fujiF.MarginF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Margin"]=true;
	else
		PIGA["PigLayout"]["ChatUI"]["Margin"]=false;
	end
	fujiF.MarginF.Set_Fun()
	fujiF.MarginF.Update_Checkbut()
end);
fujiF.MarginF.cz = PIGButton(fujiF.MarginF,{"LEFT",fujiF.MarginF.Open,"RIGHT",480,0},{60,22},"重置");
fujiF.MarginF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["MarginPoint"]
	fujiF.MarginF:Hide()
	fujiF.MarginF:Show()
	fujiF.MarginF.Set_Fun()
end);
fujiF.MarginF.Margin_L = PIGSlider(fujiF.MarginF,{"TOPLEFT",fujiF.MarginF.Open,"BOTTOMLEFT",90,-4},{0,50,1})
fujiF.MarginF.Margin_L.bt = PIGFontString(fujiF.MarginF.Margin_L,{"RIGHT", fujiF.MarginF.Margin_L, "LEFT", -10, 0},"左边距")
fujiF.MarginF.Margin_L.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][1]=arg1;
	fujiF.MarginF.Set_Fun()
end)
fujiF.MarginF.Margin_R = PIGSlider(fujiF.MarginF,{"LEFT",fujiF.MarginF.Margin_L,"RIGHT",120,0},{0,50,1})
fujiF.MarginF.Margin_R.bt = PIGFontString(fujiF.MarginF.Margin_R,{"RIGHT", fujiF.MarginF.Margin_R, "LEFT", -10, 0},"右边距")
fujiF.MarginF.Margin_R.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][2]=arg1;
	fujiF.MarginF.Set_Fun()
end)
fujiF.MarginF.Margin_T = PIGSlider(fujiF.MarginF,{"TOPLEFT",fujiF.MarginF.Margin_L,"BOTTOMLEFT",0,-8},{0,50,1})
fujiF.MarginF.Margin_T.bt = PIGFontString(fujiF.MarginF.Margin_T,{"RIGHT", fujiF.MarginF.Margin_T, "LEFT", -10, 0},"上边距")
fujiF.MarginF.Margin_T.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][3]=arg1;
	fujiF.MarginF.Set_Fun()
end)
fujiF.MarginF.Margin_B = PIGSlider(fujiF.MarginF,{"LEFT",fujiF.MarginF.Margin_T,"RIGHT",120,0},{0,50,1})
fujiF.MarginF.Margin_B.bt = PIGFontString(fujiF.MarginF.Margin_B,{"RIGHT", fujiF.MarginF.Margin_B, "LEFT", -10, 0},"下边距")
fujiF.MarginF.Margin_B.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["MarginPoint"][4]=arg1;
	fujiF.MarginF.Set_Fun()
end)
fujiF.MarginF:HookScript("OnShow", function (self)
	self.Update_Checkbut()
	self.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Margin"])
	local L,R,T,B = unpack(PIGA["PigLayout"]["ChatUI"]["MarginPoint"])
	self.Margin_L:PIGSetValue(L)
	self.Margin_R:PIGSetValue(R)
	self.Margin_T:PIGSetValue(T)
	self.Margin_B:PIGSetValue(B)
end);

--设置主聊天宽度
fujiF.zhuF = PIGFrame(fujiF,{"TOP", fujiF.MarginF, "BOTTOM", 0, -10},{fujiF:GetWidth()-20, 123})
fujiF.zhuF:PIGSetBackdrop(0)
function fujiF.zhuF.Set_Fun()
	if not PIGA["PigLayout"]["ChatUI"]["Zhu"] then return end
	local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["ZhuPoint"])
	local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight();
	local X,Y = X/screenWidth,Y/screenHeight
	SetChatWindowSavedPosition(1, "BOTTOMLEFT", X,Y);
	SetChatWindowSavedDimensions(1, W,H);
	FCF_RestorePositionAndDimensions(ChatFrame1)
end
function fujiF.zhuF.Update_Checkbut()
	fujiF.zhuF.Width:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	fujiF.zhuF.Height:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	fujiF.zhuF.X:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	fujiF.zhuF.Y:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Zhu"])
end
fujiF.zhuF.Open = PIGCheckbutton(fujiF.zhuF,{"TOPLEFT",fujiF.zhuF,"TOPLEFT",10,-10},{L["CHAT_ZHUCHATF"]})
fujiF.zhuF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Zhu"]=true;
		fujiF.zhuF.Set_Fun()
	else
		PIGA["PigLayout"]["ChatUI"]["Zhu"]=false;
	end
	fujiF.zhuF.Update_Checkbut()
end);
fujiF.zhuF.cz = PIGButton(fujiF.zhuF,{"LEFT",fujiF.zhuF.Open,"RIGHT",480,0},{60,22},"重置");
fujiF.zhuF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["ZhuPoint"]
	fujiF.zhuF:Hide()
	fujiF.zhuF:Show()
	fujiF.zhuF.Set_Fun()
end);
fujiF.zhuF.Width = PIGSlider(fujiF.zhuF,{"TOPLEFT",fujiF.zhuF.Open,"BOTTOMLEFT",90,-4},{150,800,1})
fujiF.zhuF.Width.bt = PIGFontString(fujiF.zhuF.Width,{"RIGHT", fujiF.zhuF.Width, "LEFT", -10, 0},L["LIB_WIDTH"])
fujiF.zhuF.Width.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][1]=arg1;
	fujiF.zhuF.Set_Fun()
end)
fujiF.zhuF.Height = PIGSlider(fujiF.zhuF,{"LEFT",fujiF.zhuF.Width,"RIGHT",120,0},{120,500,1})
fujiF.zhuF.Height.bt = PIGFontString(fujiF.zhuF.Height,{"RIGHT", fujiF.zhuF.Height, "LEFT", -10, 0},L["LIB_HEIGHT"])
fujiF.zhuF.Height.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][2]=arg1;
	fujiF.zhuF.Set_Fun()
end)
fujiF.zhuF.X = PIGSlider(fujiF.zhuF,{"TOPLEFT",fujiF.zhuF.Width,"BOTTOMLEFT",0,-8},{0,400,1})
fujiF.zhuF.X.bt = PIGFontString(fujiF.zhuF.X,{"RIGHT", fujiF.zhuF.X, "LEFT", -10, 0},"左边距")
fujiF.zhuF.X.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][3]=arg1;
	fujiF.zhuF.Set_Fun()
end)
fujiF.zhuF.Y = PIGSlider(fujiF.zhuF,{"LEFT",fujiF.zhuF.X,"RIGHT",120,0},{0,200,1})
fujiF.zhuF.Y.bt = PIGFontString(fujiF.zhuF.Y,{"RIGHT", fujiF.zhuF.Y, "LEFT", -10, 0},"下边距")
fujiF.zhuF.Y.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["ZhuPoint"][4]=arg1;
	fujiF.zhuF.Set_Fun()
end)
-----
fujiF.zhuF:HookScript("OnShow", function(self)
	self.Update_Checkbut()
	self.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Zhu"])
	local W,H,X,Y = unpack(PIGA["PigLayout"]["ChatUI"]["ZhuPoint"])
	self.Width:PIGSetValue(W)
	self.Height:PIGSetValue(H)
	self.X:PIGSetValue(X)
	self.Y:PIGSetValue(Y)
end)

--设置副聊天宽度
fujiF.fuF = PIGFrame(fujiF,{"TOP", fujiF.zhuF, "BOTTOM", 0, -10},{fujiF:GetWidth()-20, 160})
fujiF.fuF:PIGSetBackdrop(0)

fujiF.fuF.ChatUIList=PIGDownMenu(fujiF.fuF,{"TOPLEFT",fujiF.fuF,"TOPLEFT",10,-10},{120,nil})
function fujiF.fuF.ChatUIList:PIGDownMenu_Update_But()
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
function fujiF.fuF.ChatUIList:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["PigLayout"]["ChatUI"]["FuName"]=value
	fujiF.fuF.Set_Fun(true)
	fujiF.fuF.Update_Checkbut()
	PIGCloseDropDownMenus()
end
fujiF.fuF.ChatUIList.errtisp = PIGFontString(fujiF.fuF.ChatUIList,{"LEFT",fujiF.fuF.ChatUIList,"RIGHT",10,0})
fujiF.fuF.ChatUIList.errtisp:SetTextColor(1, 0, 0, 1);
fujiF.fuF.ChatUIList.fenli = PIGButton(fujiF.fuF.ChatUIList,{"LEFT",fujiF.fuF.ChatUIList.errtisp,"RIGHT",10,0},{60,24},"分离")
fujiF.fuF.ChatUIList.fenli:Hide()
fujiF.fuF.ChatUIList.fenli:SetScript("OnClick", function (self)
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	if pindaoid>0 then
		local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(pindaoid);
		if docked~=nil then
			FCF_UnDockFrame(_G["ChatFrame"..pindaoid]);
			fujiF.fuF.ChatUIList.errtisp:SetText("") 
			fujiF.fuF.ChatUIList.fenli:Hide()
			fujiF.fuF.Set_Fun(true)
			fujiF.fuF.Update_Checkbut()
			return
		end
	end
end);
fujiF.fuF.Open = PIGCheckbutton(fujiF.fuF,{"TOPLEFT",fujiF.fuF.ChatUIList,"BOTTOMLEFT",0,-10},{L["CHAT_LOOTCHATF"]})
fujiF.fuF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["PigLayout"]["ChatUI"]["Fu"]=true;
	else
		PIGA["PigLayout"]["ChatUI"]["Fu"]=false;
	end
	fujiF.fuF.Set_Fun(true)
	fujiF.fuF.Update_Checkbut()
end);
fujiF.fuF.cz = PIGButton(fujiF.fuF,{"LEFT",fujiF.fuF.Open,"RIGHT",480,0},{60,22},"重置");
fujiF.fuF.cz:SetScript("OnClick", function (self)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"]=addonTable.Default["PigLayout"]["ChatUI"]["FuPoint"]
	fujiF.fuF:Hide()
	fujiF.fuF:Show()
	fujiF.fuF.Set_Fun(true)
end);
fujiF.fuF.Width = PIGSlider(fujiF.fuF,{"TOPLEFT",fujiF.fuF.Open,"BOTTOMLEFT",90,-4},{150,800,1})
fujiF.fuF.Width.bt = PIGFontString(fujiF.fuF.Width,{"RIGHT", fujiF.fuF.Width, "LEFT", -10, 0},L["LIB_WIDTH"])
fujiF.fuF.Width.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][1]=arg1;
	fujiF.fuF.Set_Fun()
end)
fujiF.fuF.Height = PIGSlider(fujiF.fuF,{"LEFT",fujiF.fuF.Width,"RIGHT",120,0},{120,500,1})
fujiF.fuF.Height.bt = PIGFontString(fujiF.fuF.Height,{"RIGHT", fujiF.fuF.Height, "LEFT", -10, 0},L["LIB_HEIGHT"])
fujiF.fuF.Height.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][2]=arg1;
	fujiF.fuF.Set_Fun()
end)
fujiF.fuF.X = PIGSlider(fujiF.fuF,{"TOPLEFT",fujiF.fuF.Width,"BOTTOMLEFT",0,-8},{0,400,1})
fujiF.fuF.X.bt = PIGFontString(fujiF.fuF.X,{"RIGHT", fujiF.fuF.X, "LEFT", -10, 0},"右边距")
fujiF.fuF.X.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][3]=arg1;
	fujiF.fuF.Set_Fun()
end)
fujiF.fuF.Y = PIGSlider(fujiF.fuF,{"LEFT",fujiF.fuF.X,"RIGHT",120,0},{0,200,1})
fujiF.fuF.Y.bt = PIGFontString(fujiF.fuF.Y,{"RIGHT", fujiF.fuF.Y, "LEFT", -10, 0},"下边距")
fujiF.fuF.Y.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["PigLayout"]["ChatUI"]["FuPoint"][4]=arg1;
	fujiF.fuF.Set_Fun()
end)
--
local function tishiTxt(errid)
	fujiF.fuF.ChatUIList.errtisp:SetText("") 
	fujiF.fuF.ChatUIList.fenli:Hide()
	if errid==1 then
		fujiF.fuF.Open:SetChecked(false) 
		fujiF.fuF.ChatUIList.errtisp:SetText("请先选择一个聊天窗口")
	elseif errid==2 then
		fujiF.fuF.Open:SetChecked(false)
		fujiF.fuF.ChatUIList.errtisp:SetText("此聊天窗口未分离，点击分离") 
		fujiF.fuF.ChatUIList.fenli:Show()
	end
end
function fujiF.fuF.Set_Fun(set)
	fujiF.fuF.pindaoname=false
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	if pindaoid>0 then
		local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(pindaoid);
		if docked~=nil then
			PIGA["PigLayout"]["ChatUI"]["Fu"]=false;
			if set then tishiTxt(2) end
			return
		end
		tishiTxt(errid)
		fujiF.fuF.pindaoname=true
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
function fujiF.fuF.Update_Checkbut()
	local pindaoid,pindaoname=Fun.GetSelectpindaoID(PIGA["PigLayout"]["ChatUI"]["FuName"])
	fujiF.fuF.ChatUIList:PIGDownMenu_SetText(pindaoname)
	fujiF.fuF.Open:SetChecked(PIGA["PigLayout"]["ChatUI"]["Fu"])
	if fujiF.fuF.pindaoname then
		fujiF.fuF.Open:SetEnabled(true)
		fujiF.fuF.Width:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		fujiF.fuF.Height:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		fujiF.fuF.X:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
		fujiF.fuF.Y:SetEnabled(PIGA["PigLayout"]["ChatUI"]["Fu"])
	else
		fujiF.fuF.Open:SetEnabled(false)
		fujiF.fuF.Width:SetEnabled(false)
		fujiF.fuF.Height:SetEnabled(false)
		fujiF.fuF.X:SetEnabled(false)
		fujiF.fuF.Y:SetEnabled(false)
	end	
end
-----
fujiF.fuF:HookScript("OnShow", function(self)
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

-- fujiF.LOOTF = PIGFrame(fujiF,{"TOP", fujiF, "TOP", 0, -250},{fujiF:GetWidth()-20, 150})
-- fujiF.LOOTF:PIGSetBackdrop()
-- fujiF.LOOTF.add = PIGButton(fujiF.LOOTF,{"TOPLEFT",fujiF.LOOTF,"TOPLEFT",4,-8},{150,22},L["CHAT_LOOTFADD"]);
-- --重设窗口显示内容
-- local function ShowChannelFun()
-- 	--综合
-- 	if fujiF.Chatloot and PIGA["PigLayout"]["ChatUI"]["ShowChannel"] then
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
-- fujiF.LOOTF.ShowChannel = PIGCheckbutton(fujiF.LOOTF,{"LEFT",fujiF.LOOTF.add,"RIGHT",60,-2},tishims)
-- fujiF.LOOTF.ShowChannel:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["PigLayout"]["ChatUI"]["ShowChannel"]=true;
-- 	else
-- 		PIGA["PigLayout"]["ChatUI"]["ShowChannel"]=false;
-- 	end
-- 	ShowChannelFun()
-- end);
-- --提示
-- fujiF.LOOTF.tishi = CreateFrame("Frame", nil, fujiF.LOOTF);
-- fujiF.LOOTF.tishi:SetSize(30,30);
-- fujiF.LOOTF.tishi:SetPoint("LEFT",fujiF.LOOTF.add,"RIGHT",0,0);
-- fujiF.LOOTF.tishi.Texture = fujiF.LOOTF.tishi:CreateTexture(nil, "BORDER");
-- fujiF.LOOTF.tishi.Texture:SetTexture("interface/common/help-i.blp");
-- fujiF.LOOTF.tishi.Texture:SetAllPoints(fujiF.LOOTF.tishi)
-- PIGEnter(fujiF.LOOTF.tishi,L["LIB_TIPS"]..": ",L["CHAT_LOOTFTIPS"])
-- fujiF.LOOTF.ShowlootF = PIGButton(fujiF.LOOTF,{"TOPLEFT",fujiF.LOOTF,"TOPLEFT",410,-8},{150,22},L["CHAT_LOOTFFENLI"]);
-- fujiF.LOOTF.ShowlootF:SetScript("OnClick", function (self)
-- 	if fujiF.ChatlootID then
-- 		local lotofa = _G["ChatFrame"..fujiF.ChatlootID]
-- 		local lotofaTab = _G["ChatFrame"..fujiF.ChatlootID.."Tab"]
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
-- fujiF.Chatloot = false
-- fujiF.ChatlootNum=0
-- local function LOOT_cunzai()
-- 	if NUM_CHAT_WINDOWS~=nil then
-- 		for id=1,NUM_CHAT_WINDOWS,1 do
-- 			local name, __ = GetChatWindowInfo(id);
-- 			if name==L["CHAT_LOOTFNAME"] then
-- 				--print(name)
-- 				fujiF.Chatloot = true
-- 				fujiF.ChatlootID = id
-- 				return id
-- 			end
-- 		end
-- 	end
-- end
-- local function LOOT_SetValueText()
-- 	LOOT_cunzai()
-- 	if fujiF.Chatloot then
-- 		ShowChannelFun()

-- 	else
-- 		if fujiF.ChatlootNum<10 then
-- 			C_Timer.After(1, LOOT_SetValueText)
-- 			fujiF.ChatlootNum=fujiF.ChatlootNum+1
-- 		end
-- 	end
-- end
-- --创建拾取聊天窗口
-- fujiF.LOOTF.add:SetScript("OnClick", function ()
-- 	if fujiF.Chatloot then return end
-- 	if GetScreenWidth()<1024 then PIG_OptionsUI:ErrorMsg(L["CHAT_LOOTFADDERR1"]) end
-- 	if FCF_GetNumActiveChatFrames()>=10 then PIG_OptionsUI:ErrorMsg(L["CHAT_LOOTFADDERR2"]) end
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
-- fujiF.LOOTF:HookScript("OnShow", function(self)
-- 	LOOT_Width_Heigh_Point_XY()
-- 	fujiF.LOOTF.ShowChannel:SetChecked(PIGA["PigLayout"]["ChatUI"]["ShowChannel"])
-- end)
-- ---重置聊天设置
-- fujiF.ReChatBut = PIGButton(fujiF,{"BOTTOMLEFT",fujiF,"BOTTOMLEFT",14,14},{120,24},L["CHAT_RECHATBUT"]);
-- fujiF.ReChatBut:SetScript("OnClick", function ()
-- 	FCF_ResetChatWindows();
-- end)
--导入其他角色聊天设置
local function SavedangqianSet()--保存当前设置
	-- local PIG_renwuming = PIG_OptionsUI.AllName
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
-- fujiF.daoruqitaSet =PIGDownMenu(fujiF,{"BOTTOMLEFT",fujiF,"BOTTOMLEFT",20,14},{200,nil})
-- function fujiF.daoruqitaSet:PIGDownMenu_Update_But()
-- 	local Setinfo =PIGA["Chat"]["ChatSetSave"]
-- 	local info = {}
-- 	info.func = self.PIGDownMenu_SetValue
-- 	for k,v in pairs(Setinfo) do
-- 		print(k,v)
-- 		info.text, info.arg1 = L["CONFIG_DAORU"].."<"..k..">"..L["CONFIG_TABNAME"],v
-- 		self:PIGDownMenu_AddButton(info)
-- 	end
-- end
-- function fujiF.daoruqitaSet:PIGDownMenu_SetValue(value,arg1)
-- 	self:PIGDownMenu_SetText(L["CHAT_DAORUQITASET"])
-- 	print(value,arg1)	
-- 	PIGA["Chat"]["ChatSetSave"][PIG_renwuming]=arg1
-- 	PIGCloseDropDownMenus()
-- end
-- fujiF.daoruqitaSet:PIGDownMenu_SetText(L["CHAT_DAORUQITASET"])
-----------
fujiF.MarginF.Set_Fun()
fujiF.zhuF.Set_Fun()
fujiF.fuF.Set_Fun()
C_Timer.After(1,function() fujiF.fuF.Set_Fun() end)
end