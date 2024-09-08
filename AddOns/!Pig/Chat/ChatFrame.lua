local _, addonTable = ...;
local L=addonTable.locale
---
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
local QuickChatfun=addonTable.QuickChatfun
local fuFrame =PIGOptionsList_R(QuickChatfun.RTabFrame,L["CHAT_TABNAME4"],110)
--=============================
local function Enable_Disable(ui,Booleans)
	if Booleans then
		ui:Enable()
		ui.Low:SetTextColor(1, 1, 1, 1);
		ui.High:SetTextColor(1, 1, 1, 1);
		ui.Text:SetTextColor(1, 1, 1, 1);
	else
		ui:Disable();
		ui.Low:SetTextColor(0.8, 0.8, 0.8, 0.5);
		ui.High:SetTextColor(0.8, 0.8, 0.8, 0.5);
		ui.Text:SetTextColor(0.8, 0.8, 0.8, 0.5);
	end
end
--聊天窗口可以移动到屏幕边缘
fuFrame.Bianju = PIGCheckbutton_R(fuFrame,{L["CHAT_BIANJU"],L["CHAT_BIANJUTIPS"]})
fuFrame.Bianju:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Frame"]["Bianju"]=true;
		fuFrame.Bianju_Fun()
	else
		PIGA["Chat"]["Frame"]["Bianju"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
fuFrame:HookScript("OnShow", function (self)
	self.Bianju:SetChecked(PIGA["Chat"]["Frame"]["Bianju"])
end);
function fuFrame.Bianju_Fun()
	if PIGA["Chat"]["Frame"]["Bianju"] then
		for i = 1, NUM_CHAT_WINDOWS do 
			_G["ChatFrame"..i]:SetClampRectInsets(-35, 0, 0, 0) --可拖动至紧贴屏幕边缘 
		end
		hooksecurefunc("FloatingChatFrame_UpdateBackgroundAnchors", function(self)
			if self==_G["ChatFrame2"] then
				self:SetClampRectInsets(-35, 0, 0, 0);
			end
		end)
	end
end
--输入框移动
local function Update_editBoxPoint()
	local weizhidata = {-5,-2,5,-2}
	if PIGA["Chat"]["QuickChat"] or PIGA["Chat"]["Frame"]["editMove"] then
		if PIGA["Chat"]["QuickChat_maodian"]==1 then

		elseif PIGA["Chat"]["QuickChat_maodian"]==2 then
			weizhidata[1]=-5
			weizhidata[2]=-23
			weizhidata[3]=5
			weizhidata[4]=-23
		end
		if PIGA["Chat"]["Frame"]["editMove"] then
			weizhidata[1]=weizhidata[1]+PIGA["Chat"]["Frame"]["editPoint_X"]
			weizhidata[2]=weizhidata[2]+PIGA["Chat"]["Frame"]["editPoint_Y"]
			weizhidata[3]=weizhidata[3]+PIGA["Chat"]["Frame"]["editPoint_X"]
			weizhidata[4]=weizhidata[4]+PIGA["Chat"]["Frame"]["editPoint_Y"]
		end
		for i=1,NUM_CHAT_WINDOWS do
			local fujichat = _G["ChatFrame"..i]
			fujichat.editBox:ClearAllPoints();
			fujichat.editBox:SetPoint("TOPLEFT",fujichat,"BOTTOMLEFT",weizhidata[1],weizhidata[2]);
			fujichat.editBox:SetPoint("TOPRIGHT",fujichat,"BOTTOMRIGHT",weizhidata[3],weizhidata[4]);
		end
	end
end
QuickChatfun.Update_editBoxPoint=Update_editBoxPoint
local function editF_Enable_Disable()
	Enable_Disable(fuFrame.editF.editPoint_X,PIGA["Chat"]["Frame"]["editMove"])
	Enable_Disable(fuFrame.editF.editPoint_Y,PIGA["Chat"]["Frame"]["editMove"])
end
fuFrame.editF = PIGFrame(fuFrame,{"TOP", fuFrame, "TOP", 0, -60},{fuFrame:GetWidth()-20, 90})
fuFrame.editF:PIGSetBackdrop()
fuFrame.editF.editMove = PIGCheckbutton(fuFrame.editF,{"TOPLEFT",fuFrame.editF,"TOPLEFT",10,-10},{"移动输入框位置","移动输入框位置"})
fuFrame.editF.editMove:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Frame"]["editMove"]=true
	else
		PIGA["Chat"]["Frame"]["editMove"]=false
	end
	editF_Enable_Disable()
	Update_editBoxPoint()
end);
local pianyiinfoX = {-200,200,1}
fuFrame.editF.editPoint_X = PIGSlider(fuFrame.editF,{"TOPLEFT",fuFrame.editF.editMove,"BOTTOMLEFT",70,-20},{100,14},pianyiinfoX)
fuFrame.editF.editPoint_X.bt = PIGFontString(fuFrame.editF.editPoint_X,{"RIGHT", fuFrame.editF.editPoint_X, "LEFT", -10, 0},"X偏移")
function fuFrame.editF.editPoint_X:OnValueFun()
	local valxxx = self:GetValue()
	PIGA["Chat"]["Frame"]["editPoint_X"]=valxxx;
	self.Text:SetText(PIGA["Chat"]["Frame"]["editPoint_X"]);
	Update_editBoxPoint()
end
--Y偏移
local pianyiinfoY = {-30,500,1}
fuFrame.editF.editPoint_Y = PIGSlider(fuFrame.editF,{"LEFT",fuFrame.editF.editPoint_X,"RIGHT",100,0},{100,14},pianyiinfoY)
fuFrame.editF.editPoint_Y.bt = PIGFontString(fuFrame.editF.editPoint_Y,{"RIGHT", fuFrame.editF.editPoint_Y, "LEFT", -10, 0},"Y偏移")
function fuFrame.editF.editPoint_Y:OnValueFun()
	local valxxx = self:GetValue()
	PIGA["Chat"]["Frame"]["editPoint_Y"]=valxxx;
	self.Text:SetText(PIGA["Chat"]["Frame"]["editPoint_Y"]);
	Update_editBoxPoint()
end
fuFrame.editF:HookScript("OnShow", function(self)
	editF_Enable_Disable()
	self.editMove:SetChecked(PIGA["Chat"]["Frame"]["editMove"]);
	self.editPoint_X:PIGSetValue(PIGA["Chat"]["Frame"]["editPoint_X"])
	self.editPoint_Y:PIGSetValue(PIGA["Chat"]["Frame"]["editPoint_Y"])
end)
-----------------------------
fuFrame.zhuF = PIGFrame(fuFrame,{"TOP", fuFrame, "TOP", 0, -270},{fuFrame:GetWidth()-20, 140})
fuFrame.zhuF:PIGSetBackdrop()
fuFrame.zhuF.bt = PIGFontString(fuFrame.zhuF,{"TOPLEFT", fuFrame.zhuF, "TOPLEFT", 6, -6},L["CHAT_ZHUCHATF"])
--设置主聊天宽度
local function zhu_SetWHPointXY()
	if PIGA["Chat"]["Frame"]["Width"] then
		ChatFrame1:SetWidth(PIGA["Chat"]["Frame"]["Width_value"]);
	end
	if PIGA["Chat"]["Frame"]["Height"] then
		ChatFrame1:SetHeight(PIGA["Chat"]["Frame"]["Height_value"]);
	end
	if PIGA["Chat"]["Frame"]["Point"] then
		local XXX,YYY = PIGA["Chat"]["Frame"]["Point_X"],PIGA["Chat"]["Frame"]["Point_Y"]
		if YYY<50 then
			for i = 1, NUM_CHAT_WINDOWS do 
				_G["ChatFrame"..i]:SetClampRectInsets(-35, 0, 0, 0) --可拖动至紧贴屏幕边缘 
			end
		end
		ChatFrame1:ClearAllPoints();
		ChatFrame1:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",XXX,YYY);
	end
end
local function Zhu_Enable_Disable()
	Enable_Disable(fuFrame.zhuF.Width.Slider,PIGA["Chat"]["Frame"]["Width"])
	Enable_Disable(fuFrame.zhuF.Height.Slider,PIGA["Chat"]["Frame"]["Height"])
	Enable_Disable(fuFrame.zhuF.Point.Slider_X,PIGA["Chat"]["Frame"]["Point"])
	Enable_Disable(fuFrame.zhuF.Point.Slider_Y,PIGA["Chat"]["Frame"]["Point"])
end
local function Zhu_Width_Height_XY()
	Zhu_Enable_Disable()
	zhu_SetWHPointXY()
end
fuFrame.zhuF.Width = PIGCheckbutton(fuFrame.zhuF,{"TOPLEFT",fuFrame.zhuF,"TOPLEFT",10,-30},{L["CHAT_ZHUCHATFW"],L["CHAT_ZHUCHATFWTIPS"]})
fuFrame.zhuF.Width:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Frame"]["Width"]=true
	else
		PIGA["Chat"]["Frame"]["Width"]=false
		Pig_Options_RLtishi_UI:Show()
	end
	Zhu_Width_Height_XY()
end);
local xiayiinfoW = {150,800,1}
fuFrame.zhuF.Width.Slider = PIGSlider(fuFrame.zhuF,{"LEFT",fuFrame.zhuF.Width.Text,"RIGHT",6,0},{100,14},xiayiinfoW)
function fuFrame.zhuF.Width.Slider:OnValueFun()
	local valxxx = self:GetValue()
	self.Text:SetText(valxxx)
	PIGA["Chat"]["Frame"]["Width_value"]=valxxx;
	Zhu_Width_Height_XY()
end
--设置主聊天窗口高度
fuFrame.zhuF.Height = PIGCheckbutton(fuFrame.zhuF,{"LEFT",fuFrame.zhuF.Width.Slider,"RIGHT",100,0},{L["CHAT_ZHUCHATFH"],L["CHAT_ZHUCHATFHTIPS"]})
fuFrame.zhuF.Height:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Frame"]["Height"]=true;
	else
		PIGA["Chat"]["Frame"]["Height"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
	Zhu_Width_Height_XY()
end);
-----------------------------------
local xiayiinfoH = {120,500,1}
fuFrame.zhuF.Height.Slider = PIGSlider(fuFrame.zhuF,{"LEFT",fuFrame.zhuF.Height.Text,"RIGHT",6,0},{100,14},xiayiinfoH)
function fuFrame.zhuF.Height.Slider:OnValueFun()
	local valxxx = self:GetValue()
	self.Text:SetText(valxxx)
	PIGA["Chat"]["Frame"]["Height_value"]=valxxx;
	Zhu_Width_Height_XY()
end
--主聊天窗口X位置====
fuFrame.zhuF.Point = PIGCheckbutton(fuFrame.zhuF,{"TOPLEFT",fuFrame.zhuF.Width,"BOTTOMLEFT",0,-30},{L["CHAT_ZHUCHATFXY"],L["CHAT_ZHUCHATFXYTIPS"]})
fuFrame.zhuF.Point:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Chat"]["Frame"]["Point"]=true;
	else
		PIGA["Chat"]["Frame"]["Point"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
	Zhu_Width_Height_XY()
end);
local xiayiinfoX = {35,floor(GetScreenWidth()),1}
fuFrame.zhuF.Point.Slider_X = PIGSlider(fuFrame.zhuF,{"LEFT",fuFrame.zhuF.Point.Text,"RIGHT",8,0},{100,14},xiayiinfoX)
function fuFrame.zhuF.Point.Slider_X:OnValueFun()
	local valxxx = self:GetValue()
	self.Text:SetText(valxxx)
	PIGA["Chat"]["Frame"]["Point_X"]=valxxx;
	Zhu_Width_Height_XY()
end
local xiayiinfoY = {0,floor(GetScreenHeight()),1}
fuFrame.zhuF.Point.Slider_Y = PIGSlider(fuFrame.zhuF,{"LEFT",fuFrame.zhuF.Point.Slider_X,"RIGHT",48,0},{100,14},xiayiinfoY)
function fuFrame.zhuF.Point.Slider_Y:OnValueFun()
	local valxxx = self:GetValue()
	self.Text:SetText(valxxx)
	PIGA["Chat"]["Frame"]["Point_Y"]=valxxx;
	Zhu_Width_Height_XY()
end
----
fuFrame.zhuF:HookScript("OnShow", function(self)
	Zhu_Enable_Disable()
	self.Width:SetChecked(PIGA["Chat"]["Frame"]["Width"]);
	self.Height:SetChecked(PIGA["Chat"]["Frame"]["Height"]);
	self.Point:SetChecked(PIGA["Chat"]["Frame"]["Point"]);
	self.Width.Slider:PIGSetValue(PIGA["Chat"]["Frame"]["Width_value"])
	self.Height.Slider:PIGSetValue(PIGA["Chat"]["Frame"]["Height_value"])
	self.Point.Slider_X:PIGSetValue(PIGA["Chat"]["Frame"]["Point_X"])
	self.Point.Slider_Y:PIGSetValue(PIGA["Chat"]["Frame"]["Point_Y"])
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

-- fuFrame.LOOTF = PIGFrame(fuFrame,{"TOP", fuFrame, "TOP", 0, -250},{fuFrame:GetWidth()-20, 150})
-- fuFrame.LOOTF:PIGSetBackdrop()
-- fuFrame.LOOTF.add = PIGButton(fuFrame.LOOTF,{"TOPLEFT",fuFrame.LOOTF,"TOPLEFT",4,-8},{150,22},L["CHAT_LOOTFADD"]);
-- --重设窗口显示内容
-- local function ShowChannelFun()
-- 	--综合
-- 	if fuFrame.Chatloot and PIGA["Chat"]["Frame"]["ShowChannel"] then
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
-- fuFrame.LOOTF.ShowChannel = PIGCheckbutton(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.add,"RIGHT",60,-2},tishims)
-- fuFrame.LOOTF.ShowChannel:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Frame"]["ShowChannel"]=true;
-- 	else
-- 		PIGA["Chat"]["Frame"]["ShowChannel"]=false;
-- 	end
-- 	ShowChannelFun()
-- end);
-- --提示
-- fuFrame.LOOTF.tishi = CreateFrame("Frame", nil, fuFrame.LOOTF);
-- fuFrame.LOOTF.tishi:SetSize(30,30);
-- fuFrame.LOOTF.tishi:SetPoint("LEFT",fuFrame.LOOTF.add,"RIGHT",0,0);
-- fuFrame.LOOTF.tishi.Texture = fuFrame.LOOTF.tishi:CreateTexture(nil, "BORDER");
-- fuFrame.LOOTF.tishi.Texture:SetTexture("interface/common/help-i.blp");
-- fuFrame.LOOTF.tishi.Texture:SetAllPoints(fuFrame.LOOTF.tishi)
-- PIGEnter(fuFrame.LOOTF.tishi,L["LIB_TIPS"]..": ",L["CHAT_LOOTFTIPS"])
-- fuFrame.LOOTF.ShowlootF = PIGButton(fuFrame.LOOTF,{"TOPLEFT",fuFrame.LOOTF,"TOPLEFT",410,-8},{150,22},L["CHAT_LOOTFFENLI"]);
-- fuFrame.LOOTF.ShowlootF:SetScript("OnClick", function (self)
-- 	if fuFrame.ChatlootID then
-- 		local lotofa = _G["ChatFrame"..fuFrame.ChatlootID]
-- 		local lotofaTab = _G["ChatFrame"..fuFrame.ChatlootID.."Tab"]
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
-- --设置拾取窗口------------------------
-- local function LOOT_Width_Heigh_Point_XY()
-- 	if fuFrame.Chatloot then
-- 		fuFrame.LOOTF.add:Disable()
-- 		fuFrame.LOOTF.add:SetText(L["CHAT_LOOTFYES"])
-- 		fuFrame.LOOTF.ShowlootF:Enable()
-- 		fuFrame.LOOTF.ShowChannel:Enable()
-- 		fuFrame.LOOTF.Width:Enable()
-- 		fuFrame.LOOTF.Height:Enable()
-- 		fuFrame.LOOTF.Point:Enable()
-- 	else
-- 		fuFrame.LOOTF.add:Enable()
-- 		fuFrame.LOOTF.add:SetText(L["CHAT_LOOTFADD"])
-- 		fuFrame.LOOTF.ShowlootF:Disable()
-- 		fuFrame.LOOTF.ShowChannel:Disable()
-- 		fuFrame.LOOTF.Width:Disable()
-- 		fuFrame.LOOTF.Height:Disable()
-- 		fuFrame.LOOTF.Point:Disable()
-- 	end
-- 	Enable_Disable(fuFrame.LOOTF.Width.Slider,fuFrame.Chatloot)
-- 	Enable_Disable(fuFrame.LOOTF.Height.Slider,fuFrame.Chatloot)
-- 	Enable_Disable(fuFrame.LOOTF.Point.Slider_X,fuFrame.Chatloot)
-- 	Enable_Disable(fuFrame.LOOTF.Point.Slider_Y,fuFrame.Chatloot)
-- end
-- local function Loot_Point_XY()
-- 	if fuFrame.Chatloot then
-- 		local fghh = _G["ChatFrame"..fuFrame.ChatlootID]
-- 		if PIGA["Chat"]["Frame"]["Loot_Point_Y"]<50 then
-- 			fghh:SetClampRectInsets(-35, 0, 0, 0) --可拖动至紧贴屏幕边缘 
-- 		end
-- 		FCF_UnDockFrame(fghh);
-- 		fghh:ClearAllPoints();
-- 		fghh:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-PIGA["Chat"]["Frame"]["Loot_Point_X"],PIGA["Chat"]["Frame"]["Loot_Point_Y"]);
-- 		_G["ChatFrame"..fuFrame.ChatlootID.."Tab"]:ClearAllPoints();
-- 		_G["ChatFrame"..fuFrame.ChatlootID.."Tab"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..fuFrame.ChatlootID.."Background"], "TOPLEFT", 2, 0);
-- 		FCF_UpdateButtonSide(fghh);--刷新按钮位置
-- 	end
-- end
-- --拾取窗口位置
-- fuFrame.Chatloot = false
-- fuFrame.ChatlootNum=0
-- local function LOOT_cunzai()
-- 	if NUM_CHAT_WINDOWS~=nil then
-- 		for id=1,NUM_CHAT_WINDOWS,1 do
-- 			local name, __ = GetChatWindowInfo(id);
-- 			if name==L["CHAT_LOOTFNAME"] then
-- 				--print(name)
-- 				fuFrame.Chatloot = true
-- 				fuFrame.ChatlootID = id
-- 				return id
-- 			end
-- 		end
-- 	end
-- end
-- local function LOOT_SetValueText()
-- 	LOOT_cunzai()
-- 	if fuFrame.Chatloot then
-- 		ShowChannelFun()
-- 		if PIGA["Chat"]["Frame"]["Loot_Width"] then
-- 			fuFrame.LOOTF.Width.Slider.Text:SetText(PIGA["Chat"]["Frame"]["Loot_Width_value"]);
-- 			fuFrame.LOOTF.Width.Slider:SetValue(PIGA["Chat"]["Frame"]["Loot_Width_value"]);
-- 		end
-- 		if PIGA["Chat"]["Frame"]["Loot_Height"] then
-- 			fuFrame.LOOTF.Height.Slider.Text:SetText(PIGA["Chat"]["Frame"]["Loot_Height_value"]);
-- 			fuFrame.LOOTF.Height.Slider:SetValue(PIGA["Chat"]["Frame"]["Loot_Height_value"]);
-- 		end
-- 		if PIGA["Chat"]["Frame"]["Loot_Point"] then
-- 			fuFrame.LOOTF.Point.Slider_X.Text:SetText("X:"..PIGA["Chat"]["Frame"]["Loot_Point_X"]);
-- 			fuFrame.LOOTF.Point.Slider_X:SetValue(PIGA["Chat"]["Frame"]["Loot_Point_X"]);
-- 			fuFrame.LOOTF.Point.Slider_Y.Text:SetText("Y:"..PIGA["Chat"]["Frame"]["Loot_Point_Y"]);
-- 			fuFrame.LOOTF.Point.Slider_Y:SetValue(PIGA["Chat"]["Frame"]["Loot_Point_Y"]);
-- 		end
-- 	else
-- 		if fuFrame.ChatlootNum<10 then
-- 			C_Timer.After(1, LOOT_SetValueText)
-- 			fuFrame.ChatlootNum=fuFrame.ChatlootNum+1
-- 		end
-- 	end
-- end
-- fuFrame.LOOTF.Width = PIGCheckbutton(fuFrame.LOOTF,{"TOPLEFT",fuFrame.LOOTF,"TOPLEFT",10,-44},{L["CHAT_LOOTFW"],L["CHAT_LOOTFWTIPS"]})
-- fuFrame.LOOTF.Width:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Frame"]["Loot_Width"]=true;	
-- 	else
-- 		PIGA["Chat"]["Frame"]["Loot_Width"]=false;
-- 		Pig_Options_RLtishi_UI:Show()
-- 	end
-- 	LOOT_Width_Heigh_Point_XY()
-- 	LOOT_SetValueText()
-- end);
-- local xiayiinfo = {150,800,1}
-- fuFrame.LOOTF.Width.Slider = PIGSlider(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.Width.Text,"RIGHT",6,0},{100,14},xiayiinfo)
-- function fuFrame.LOOTF.Width.Slider:OnValueFun()
-- 	local valxxx = self:GetValue()
-- 	PIGA["Chat"]["Frame"]["Loot_Width_value"]=valxxx;
-- 	if fuFrame.Chatloot then
-- 		if PIGA["Chat"]["Frame"]["Loot_Width_value"]<50 then
-- 			_G["ChatFrame"..fuFrame.ChatlootID]:SetClampRectInsets(-35, 0, 0, 0) --可拖动至紧贴屏幕边缘 
-- 		end
-- 		FCF_UnDockFrame(_G["ChatFrame"..fuFrame.ChatlootID]);
-- 		_G["ChatFrame"..fuFrame.ChatlootID]:SetWidth(PIGA["Chat"]["Frame"]["Loot_Width_value"]);
-- 		FCF_UpdateButtonSide(_G["ChatFrame"..fuFrame.ChatlootID]);
-- 	end
-- end
-- ------
-- fuFrame.LOOTF.Height = PIGCheckbutton(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.Width.Slider,"RIGHT",100,0},{L["CHAT_LOOTFH"],L["CHAT_LOOTFHTIPS"]})
-- fuFrame.LOOTF.Height:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Frame"]["Loot_Height"]=true;
-- 	else
-- 		PIGA["Chat"]["Frame"]["Loot_Height"]=false;
-- 		Pig_Options_RLtishi_UI:Show()
-- 	end
-- 	LOOT_Width_Heigh_Point_XY()
-- 	LOOT_SetValueText()
-- end);
-- ------------------------------
-- local xiayiinfo = {120,500,1}
-- fuFrame.LOOTF.Height.Slider = PIGSlider(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.Height.Text,"RIGHT",6,0},{100,14},xiayiinfo)
-- function fuFrame.LOOTF.Height.Slider:OnValueFun()
-- 	local Hval = self:GetValue()
-- 	PIGA["Chat"]["Frame"]["Loot_Height_value"]=Hval;
-- 	if fuFrame.Chatloot then
-- 		FCF_UnDockFrame(_G["ChatFrame"..fuFrame.ChatlootID]);
-- 		_G["ChatFrame"..fuFrame.ChatlootID]:SetHeight(PIGA["Chat"]["Frame"]["Loot_Height_value"]);
-- 		FCF_UpdateButtonSide(_G["ChatFrame"..fuFrame.ChatlootID]);
-- 	end
-- end
-- ---------
-- fuFrame.LOOTF.Point = PIGCheckbutton(fuFrame.LOOTF,{"TOPLEFT",fuFrame.LOOTF.Width,"BOTTOMLEFT",0,-20},{L["CHAT_LOOTFXY"],L["CHAT_LOOTFXYTIPS"]})
-- fuFrame.LOOTF.Point:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Frame"]["Loot_Point"]=true;
-- 	else
-- 		PIGA["Chat"]["Frame"]["Loot_Point"]=false;
-- 		Pig_Options_RLtishi_UI:Show()
-- 	end
-- 	LOOT_Width_Heigh_Point_XY()
-- 	LOOT_SetValueText()
-- end);
-- local xiayiinfo = {26,floor(GetScreenWidth()),1}
-- fuFrame.LOOTF.Point.Slider_X = PIGSlider(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.Point.Text,"RIGHT",6,0},{100,14},xiayiinfo)
-- function fuFrame.LOOTF.Point.Slider_X:OnValueFun()
-- 	local valxxx = self:GetValue()
-- 	PIGA["Chat"]["Frame"]["Loot_Point_X"]=valxxx;
-- 	Loot_Point_XY()
-- end
-- local xiayiinfo = {8,floor(GetScreenHeight()),1}
-- fuFrame.LOOTF.Point.Slider_Y = PIGSlider(fuFrame.LOOTF,{"LEFT",fuFrame.LOOTF.Point.Slider_X,"RIGHT",48,0},{100,14},xiayiinfo)
-- function fuFrame.LOOTF.Point.Slider_Y:OnValueFun()
-- 	local valxxx = self:GetValue()
-- 	PIGA["Chat"]["Frame"]["Loot_Point_Y"]=valxxx;
-- 	Loot_Point_XY()
-- end
-- --创建拾取聊天窗口
-- fuFrame.LOOTF.add:SetScript("OnClick", function ()
-- 	if fuFrame.Chatloot then return end
-- 	if GetScreenWidth()<1024 then PIGinfotip:TryDisplayMessage(L["CHAT_LOOTFADDERR1"]) end
-- 	if FCF_GetNumActiveChatFrames()>=10 then PIGinfotip:TryDisplayMessage(L["CHAT_LOOTFADDERR2"]) end
-- 	FCF_OpenNewWindow(L["CHAT_LOOTFNAME"]);
-- 	ShowChannelFun()
-- 	local nEWid=LOOT_cunzai()
-- 	local chfff = _G["ChatFrame"..nEWid]
-- 	FCF_UnDockFrame(chfff);
-- 	chfff:ClearAllPoints();
-- 	chfff:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-PIGA["Chat"]["Frame"]["Loot_Point_X"],PIGA["Chat"]["Frame"]["Loot_Point_Y"]);
-- 	_G["ChatFrame"..nEWid.."Tab"]:ClearAllPoints();
-- 	_G["ChatFrame"..nEWid.."Tab"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..nEWid.."Background"], "TOPLEFT", 2, 0);
-- 	FCF_UpdateButtonSide(chfff);--刷新按钮位置
-- 	LOOT_Width_Heigh_Point_XY()
-- end)
-- ----
-- fuFrame.LOOTF:HookScript("OnShow", function(self)
-- 	LOOT_Width_Heigh_Point_XY()
-- 	fuFrame.LOOTF.ShowChannel:SetChecked(PIGA["Chat"]["Frame"]["ShowChannel"])
-- 	fuFrame.LOOTF.Width:SetChecked(PIGA["Chat"]["Frame"]["Loot_Width"]);
-- 	fuFrame.LOOTF.Height:SetChecked(PIGA["Chat"]["Frame"]["Loot_Height"]);
-- 	fuFrame.LOOTF.Point:SetChecked(PIGA["Chat"]["Frame"]["Loot_Point"]);
-- end)
-- ---重置聊天设置
-- fuFrame.ReChatBut = PIGButton(fuFrame,{"BOTTOMLEFT",fuFrame,"BOTTOMLEFT",14,14},{120,24},L["CHAT_RECHATBUT"]);
-- fuFrame.ReChatBut:SetScript("OnClick", function ()
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
-- function ChatF.daoruqitaSet:PIGDownMenu_Update_But(self)
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
-- 	print(value,arg1)	
-- 	PIGA["Chat"]["ChatSetSave"][PIG_renwuming]=arg1
-- 	PIGCloseDropDownMenus()
-- end
-- ChatF.daoruqitaSet:PIGDownMenu_SetText(L["CHAT_DAORUQITASET"])
-----------
function QuickChatfun.FrameUI()
	fuFrame.Bianju_Fun()
	Update_editBoxPoint()
	zhu_SetWHPointXY()
	-- LOOT_SetValueText()
end