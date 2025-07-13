local addonName, addonTable = ...;
if PIG_MaxTocversion(20000,true) then return end
local active = C_GameRules.IsHardcoreActive()
if not active then return end
---
local gsub = _G.string.gsub
local find = _G.string.find
local sub = _G.string.sub
local match = _G.string.match
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGSlider=Create.PIGSlider
local PIGFontString=Create.PIGFontString
local PIGButton=Create.PIGButton
local PIGDiyBut=Create.PIGDiyBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGSetFont=Create.PIGSetFont
local PIGDownMenu=Create.PIGDownMenu
local PIGOptionsList_R=Create.PIGOptionsList_R
--
local Data=addonTable.Data
local Fun=addonTable.Fun
local PIGGetRaceAtlas=Fun.PIGGetRaceAtlas
local FasongYCqingqiu=Fun.FasongYCqingqiu
----
local AudioData=addonTable.AudioList.Data
local CommonInfo=addonTable.CommonInfo
----
local UIname,Tooltip = "PIG_HardcoreUI",KEY_BUTTON1.."-|cff00FFFF"..UNWRAP..HARDCORE_DEATHS.."|r\r|r"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
---
local fujiF,fujiFBut =PIGOptionsList_R(CommonInfo.NR,"专家模式",80)
local HardcoreModeF=CreateFrame("Frame")
local Tooltip={"专家模式优化","|cffFFFF00启用后效果:|r\n|cff00FF001.休息区只显示任务NPC并恢复默认姓名大小\n2.非休息区显示所有姓名/增大姓名尺寸|r"}
fujiF.AutoCVars =PIGCheckbutton(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 20, -20},Tooltip)
fujiF.AutoCVars:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Hardcore"]["CVars"]["Open"]=true
    else
        PIGA["Hardcore"]["CVars"]["Open"]=false
    end
    CommonInfo.Commonfun.HardcoreCVarsFun(true)
end);
fujiF.AutoCVars.CZ=PIGButton(fujiF.AutoCVars,{"LEFT", fujiF.AutoCVars.Text, "RIGHT", 20, 0},{110,22},"恢复系统初始")
fujiF.AutoCVars.CZ:SetScript("OnClick", function (self)
    HardcoreModeF.defaultFun("0")
end);
local NameMininfo = {0,64,1}
fujiF.AutoCVars.NameMin = PIGSlider(fujiF.AutoCVars,{"TOPLEFT",fujiF.AutoCVars,"BOTTOMLEFT",20,-40},NameMininfo)
fujiF.AutoCVars.NameMin.T = PIGFontString(fujiF.AutoCVars.NameMin,{"BOTTOMLEFT",fujiF.AutoCVars.NameMin,"TOPLEFT",10,0},"休息区角色名尺寸")
fujiF.AutoCVars.NameMin.Slider:HookScript("OnValueChanged", function(self, arg1)
    PIGA["Hardcore"]["CVars"]["NameMinV"]=arg1;
    HardcoreModeF.NameMinV=arg1
end)

local NameSelectList={
	[1]={NPC_NAMES_DROPDOWN_TRACKED, NPC_NAMES_DROPDOWN_TRACKED_TOOLTIP},
	[2]={NPC_NAMES_DROPDOWN_HOSTILE, NPC_NAMES_DROPDOWN_HOSTILE_TOOLTIP},
	[3]={NPC_NAMES_DROPDOWN_INTERACTIVE, NPC_NAMES_DROPDOWN_INTERACTIVE_TOOLTIP},
	[4]={NPC_NAMES_DROPDOWN_ALL, NPC_NAMES_DROPDOWN_ALL_TOOLTIP},
	[5]={NPC_NAMES_DROPDOWN_NONE, NPC_NAMES_DROPDOWN_NONE_TOOLTIP},
}
local function NameGetValue()
	if GetCVarBool("UnitNameNPC") then
		return 4;
	else
		local specialNPCName = GetCVarBool("UnitNameFriendlySpecialNPCName");
		local hostileNPCName = GetCVarBool("UnitNameHostleNPC");
		local specialAndHostile = specialNPCName and hostileNPCName;
		if specialAndHostile and GetCVarBool("UnitNameInteractiveNPC") then
			return 3;
		elseif specialAndHostile then
			return 2;
		elseif specialNPCName then
			return 1;
		end
	end
	
	return 5;
end
local function NameSetValue(value)
	if value == 1 then
		SetCVar("UnitNameFriendlySpecialNPCName", "1");
		SetCVar("UnitNameNPC", "0");
		SetCVar("UnitNameHostleNPC", "0");
		SetCVar("UnitNameInteractiveNPC", "0");
		SetCVar("ShowQuestUnitCircles", "0");
	elseif value == 2 then
		SetCVar("UnitNameFriendlySpecialNPCName", "1");
		SetCVar("UnitNameHostleNPC", "1");
		SetCVar("UnitNameInteractiveNPC", "0");
		SetCVar("UnitNameNPC", "0");
		SetCVar("ShowQuestUnitCircles", "1");
	elseif value == 3 then
		SetCVar("UnitNameFriendlySpecialNPCName", "1");
		SetCVar("UnitNameHostleNPC", "1");
		SetCVar("UnitNameInteractiveNPC", "1");
		SetCVar("UnitNameNPC", "0");
		SetCVar("ShowQuestUnitCircles", "1");
	elseif value == 4 then
		SetCVar("UnitNameFriendlySpecialNPCName", "0");
		SetCVar("UnitNameHostleNPC", "0");
		SetCVar("UnitNameInteractiveNPC", "0");
		SetCVar("UnitNameNPC", "1");
		SetCVar("ShowQuestUnitCircles", "1");
	else
		SetCVar("UnitNameFriendlySpecialNPCName", "0");
		SetCVar("UnitNameHostleNPC", "0");
		SetCVar("UnitNameInteractiveNPC", "0");
		SetCVar("UnitNameNPC", "0");
		SetCVar("ShowQuestUnitCircles", "1");
	end
end
fujiF.AutoCVars.NameMinSelect=PIGDownMenu(fujiF.AutoCVars,{"LEFT",fujiF.AutoCVars.NameMin,"RIGHT",100,0},{220,24})
fujiF.AutoCVars.NameMinSelect.T = PIGFontString(fujiF.AutoCVars.NameMinSelect,{"BOTTOMLEFT",fujiF.AutoCVars.NameMinSelect,"TOPLEFT",10,4},"休息区角色名显示")
function fujiF.AutoCVars.NameMinSelect:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,5,1 do
	    info.text, info.arg1 = NameSelectList[i][1], i
	    info.checked = i==PIGA["Hardcore"]["CVars"]["NameMinSelect"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.AutoCVars.NameMinSelect:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["Hardcore"]["CVars"]["NameMinSelect"]=arg1
	HardcoreModeF.NameMinSelect=arg1
	PIGCloseDropDownMenus()
end
local NameMaxinfo = {0,64,1}
fujiF.AutoCVars.NameMax = PIGSlider(fujiF.AutoCVars,{"TOPLEFT",fujiF.AutoCVars,"BOTTOMLEFT",20,-100},NameMaxinfo)
fujiF.AutoCVars.NameMax.T = PIGFontString(fujiF.AutoCVars.NameMax,{"BOTTOMLEFT",fujiF.AutoCVars.NameMax,"TOPLEFT",10,0},"非休息区角色名尺寸")
fujiF.AutoCVars.NameMax.Slider:HookScript("OnValueChanged", function(self, arg1)
    PIGA["Hardcore"]["CVars"]["NameMaxV"]=arg1;
    HardcoreModeF.NameMaxV=arg1
end)
fujiF.AutoCVars.NameMaxSelect=PIGDownMenu(fujiF.AutoCVars,{"LEFT",fujiF.AutoCVars.NameMax,"RIGHT",100,0},{220,24})
fujiF.AutoCVars.NameMaxSelect.T = PIGFontString(fujiF.AutoCVars.NameMaxSelect,{"BOTTOMLEFT",fujiF.AutoCVars.NameMaxSelect,"TOPLEFT",10,4},"非休息区角色名显示")
function fujiF.AutoCVars.NameMaxSelect:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,5,1 do
	    info.text, info.arg1 = NameSelectList[i][1], i
	    info.checked = i==PIGA["Hardcore"]["CVars"]["NameMaxSelect"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.AutoCVars.NameMaxSelect:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["Hardcore"]["CVars"]["NameMaxSelect"]=arg1
	HardcoreModeF.NameMaxSelect=arg1
	PIGCloseDropDownMenus()
end
function HardcoreModeF.defaultFun(Size)
    SetCVar("UnitNameFriendlySpecialNPCName", "1");
    SetCVar("UnitNameHostleNPC", "1");
    SetCVar("UnitNameInteractiveNPC", "0");
    SetCVar("UnitNameNPC", "0");
    SetCVar("ShowQuestUnitCircles", "1");
    SetCVar("WorldTextMinSize", Size)
    NameSetValue(HardcoreModeF.NameMinSelect)
end
local function event_Script()
    if IsResting() then
        HardcoreModeF.defaultFun(HardcoreModeF.NameMinV)
    else
        SetCVar("UnitNameFriendlySpecialNPCName", "0");
        SetCVar("UnitNameHostleNPC", "0");
        SetCVar("UnitNameInteractiveNPC", "0");
        SetCVar("UnitNameNPC", "1");
        SetCVar("ShowQuestUnitCircles", "1");
        SetCVar("WorldTextMinSize", HardcoreModeF.NameMaxV)
        NameSetValue(HardcoreModeF.NameMaxSelect)
    end
end
HardcoreModeF:HookScript("OnEvent", function(self,event)
    if event=="PLAYER_ENTERING_WORLD" then
        HardcoreModeF.NameMinV=PIGA["Hardcore"]["CVars"]["NameMinV"]
        HardcoreModeF.NameMaxV=PIGA["Hardcore"]["CVars"]["NameMaxV"]
        HardcoreModeF.NameMinSelect=PIGA["Hardcore"]["CVars"]["NameMinSelect"]
        HardcoreModeF.NameMaxSelect=PIGA["Hardcore"]["CVars"]["NameMaxSelect"]
    end
	if InCombatLockdown() then return end
	C_Timer.After(0.4,event_Script)
end)
function CommonInfo.Commonfun.HardcoreCVarsFun(ly)
    local active = C_GameRules and C_GameRules.IsHardcoreActive and C_GameRules.IsHardcoreActive()
    if active then
    	if PIGA["Hardcore"]["CVars"]["Open"] then
    		if ly then
		        HardcoreModeF.NameMinV=PIGA["Hardcore"]["CVars"]["NameMinV"]
		        HardcoreModeF.NameMaxV=PIGA["Hardcore"]["CVars"]["NameMaxV"]
		    end
    		C_Timer.After(0.4,event_Script)
       		HardcoreModeF:RegisterEvent("PLAYER_ENTERING_WORLD")
			HardcoreModeF:RegisterEvent("PLAYER_UPDATE_RESTING");
    	else
    		HardcoreModeF:UnregisterEvent("PLAYER_ENTERING_WORLD")
			HardcoreModeF:UnregisterEvent("PLAYER_UPDATE_RESTING");
		end
    end
end
--吃席
fujiF.Deaths =PIGCheckbutton(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 20, -200},{UNWRAP..HARDCORE_DEATHS})
fujiF.Deaths:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Hardcore"]["Deaths"]["Open"]=true
    else
        PIGA["Hardcore"]["Deaths"]["Open"]=false
    end
    CommonInfo.Commonfun.HardcoreDeaths()
    fujiF.Deaths.SetONOFF(true)
end);

local Tgminlevelinfo = {1,59,1,{["Right"]="%s级"}}
fujiF.Deaths.Tgminlevel = PIGSlider(fujiF.Deaths,{"TOPLEFT",fujiF.Deaths,"BOTTOMLEFT",20,-40},Tgminlevelinfo)
fujiF.Deaths.Tgminlevel.T = PIGFontString(fujiF.Deaths.Tgminlevel,{"BOTTOMLEFT",fujiF.Deaths.Tgminlevel,"TOPLEFT",10,0},"桌面提示最低等级")
fujiF.Deaths.Tgminlevel.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Hardcore"]["Deaths"]["Tgminlevel"]=arg1;
	fujiF.Deaths.Set_config()
end)
local UIScaleinfo = {0.8,2,0.1,{["Right"]="%"}}
fujiF.Deaths.UIScale = PIGSlider(fujiF.Deaths,{"LEFT",fujiF.Deaths.Tgminlevel,"RIGHT",60,0},UIScaleinfo)
fujiF.Deaths.UIScale.T = PIGFontString(fujiF.Deaths.UIScale,{"BOTTOMLEFT",fujiF.Deaths.UIScale,"TOPLEFT",10,0},"桌面提示缩放")
fujiF.Deaths.UIScale.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Hardcore"]["Deaths"]["UIScale"]=arg1;
	fujiF.Deaths.Set_config(true)
end)
fujiF.Deaths.tipsmap = PIGCheckbutton(fujiF.Deaths,{"LEFT",fujiF.Deaths.UIScale,"RIGHT",60,0},{"桌面提示死亡地区","桌面提示显示名字+死亡地区"})
fujiF.Deaths.tipsmap:HookScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Hardcore"]["Deaths"]["tipsmap"]=true	
	else
		PIGA["Hardcore"]["Deaths"]["tipsmap"]=false
	end
	fujiF.Deaths.Set_config()
end);

local BigTgminlevelinfo = {30,60,1,{["Right"]="%s级"}}
fujiF.Deaths.BigTgminlevel = PIGSlider(fujiF.Deaths,{"TOPLEFT",fujiF.Deaths.Tgminlevel,"BOTTOMLEFT",0,-40},BigTgminlevelinfo)
fujiF.Deaths.BigTgminlevel.T = PIGFontString(fujiF.Deaths.BigTgminlevel,{"BOTTOMLEFT",fujiF.Deaths.BigTgminlevel,"TOPLEFT",10,0},"大席提示最低等级")
fujiF.Deaths.BigTgminlevel.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Hardcore"]["Deaths"]["BigTgminlevel"]=arg1;
	fujiF.Deaths.Set_config()
end)
fujiF.Deaths.xiala=PIGDownMenu(fujiF.Deaths,{"LEFT",fujiF.Deaths.BigTgminlevel,"RIGHT",100,0},{150,24})
fujiF.Deaths.xiala.T = PIGFontString(fujiF.Deaths.xiala,{"BOTTOMLEFT",fujiF.Deaths.xiala,"TOPLEFT",10,4},"大席语音")
function fujiF.Deaths.xiala:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#AudioData.HardcoreDeaths,1 do
	    info.text, info.arg1 = AudioData.HardcoreDeaths[i][1], i
	    info.checked = i==PIGA["Hardcore"]["Deaths"]["VoiceID"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.Deaths.xiala:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["Hardcore"]["Deaths"]["VoiceID"]=arg1
	fujiF.Deaths.Set_config()
	PIGCloseDropDownMenus()
end
fujiF.Deaths.PlayBut =PIGDiyBut(fujiF.Deaths,{"LEFT",fujiF.Deaths.xiala,"RIGHT",8,0},{24,24,nil,nil,"chatframe-button-icon-speaker-on",130757});
fujiF.Deaths.PlayBut:HookScript("OnClick", function()
	PIG_PlaySoundFile(AudioData.HardcoreDeaths[_G[UIname].AudioID])
end)

local savedaysinfo = {1,7,1,{["Right"]="%s天"}}
fujiF.Deaths.savedays = PIGSlider(fujiF.Deaths,{"TOPLEFT",fujiF.Deaths.BigTgminlevel,"BOTTOMLEFT",0,-40},savedaysinfo)
fujiF.Deaths.savedays.T = PIGFontString(fujiF.Deaths.savedays,{"BOTTOMLEFT",fujiF.Deaths.savedays,"TOPLEFT",10,0},"保存时间")
fujiF.Deaths.savedays.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Hardcore"]["Deaths"]["savedays"]=arg1;
end)

fujiF.Deaths.Clear = PIGButton(fujiF.Deaths,{"LEFT",fujiF.Deaths.savedays,"RIGHT",100,0},{80,20},"清空记录")
fujiF.Deaths.Clear:HookScript("OnClick", function ()
	PIGA["Hardcore"]["Deaths"]["List"]={}
	PIGA["Hardcore"]["Deaths"]["Player"]={}
	HardcoreDeaths.Update_List()
end);
fujiF:HookScript("OnShow", function(self)
	self.AutoCVars:SetChecked(PIGA["Hardcore"]["CVars"]["Open"])
	self.AutoCVars.NameMin:PIGSetValue(PIGA["Hardcore"]["CVars"]["NameMinV"])
	self.AutoCVars.NameMax:PIGSetValue(PIGA["Hardcore"]["CVars"]["NameMaxV"])
    self.AutoCVars.NameMinSelect:PIGDownMenu_SetText(NameSelectList[PIGA["Hardcore"]["CVars"]["NameMinSelect"]][1])
    self.AutoCVars.NameMaxSelect:PIGDownMenu_SetText(NameSelectList[PIGA["Hardcore"]["CVars"]["NameMaxSelect"]][1])
    self.Deaths:SetChecked(PIGA["Hardcore"]["Deaths"]["Open"])
	self.Deaths.tipsmap:SetChecked(PIGA["Hardcore"]["Deaths"]["tipsmap"])
	self.Deaths.Tgminlevel:PIGSetValue(PIGA["Hardcore"]["Deaths"]["Tgminlevel"])
	self.Deaths.UIScale:PIGSetValue(PIGA["Hardcore"]["Deaths"]["UIScale"])
	self.Deaths.BigTgminlevel:PIGSetValue(PIGA["Hardcore"]["Deaths"]["BigTgminlevel"])
	self.Deaths.savedays:PIGSetValue(PIGA["Hardcore"]["Deaths"]["savedays"])
	self.Deaths.xiala:PIGDownMenu_SetText(AudioData.HardcoreDeaths[PIGA["Hardcore"]["Deaths"]["VoiceID"]][1])
end)
local Quality = addonTable.Data.Quality
local minmaxlist = {{1,9},{10,19},{20,29},{30,39},{40,49},{50,59}}
local function getColor(value)
	local value=tonumber(value)
    if value >= minmaxlist[1][1] and value <= minmaxlist[1][2] then
        return Quality[0]["HEX"]
    elseif value >= minmaxlist[2][1] and value <= minmaxlist[2][2] then
        return Quality[1]["HEX"]
    elseif value >= minmaxlist[3][1] and value <= minmaxlist[3][2] then
        return Quality[2]["HEX"]
    elseif value >= minmaxlist[4][1] and value <= minmaxlist[4][2] then
        return Quality[3]["HEX"]
    elseif value >= minmaxlist[5][1] and value <= minmaxlist[5][2] then
        return Quality[4]["HEX"]
    elseif value >= minmaxlist[6][1] and value <= minmaxlist[6][2] then
        return Quality[5]["HEX"]
    else
       	return "ffFF0000"
    end
end
local function IslevelOK(value)	
	if not value then return false end
	if value=="" then return false end
	local value=tonumber(value)
	if value == 60 then
		return true
	end
	for i=1,#minmaxlist do
		if not PIGA["Hardcore"]["Deaths"]["level"][i] then
			if value >= minmaxlist[i][1] and value <= minmaxlist[i][2] then
        		return true
        	end
		end
	end
	return false
end
function PIG_OptionsUI.Join_hardcoredeaths()
	if PIGA["Hardcore"]["Deaths"]["Open"] then
		JoinTemporaryChannel("hardcoredeaths", nil, DEFAULT_CHAT_FRAME:GetID(), 1);
		ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "hardcoredeaths");
		--ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "hardcoredeaths");
		JoinTemporaryChannel("专家死亡", nil, DEFAULT_CHAT_FRAME:GetID(), 1);
		ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "专家死亡");
	end
end
function fujiF.Deaths.SetONOFF(ly)
	if PIGA["Hardcore"]["Deaths"]["Open"] then
		if ly then PIG_OptionsUI.Join_hardcoredeaths() end
		SetCVar("hardcoreDeathAlertType","2")
		_G[UIname]:RegisterEvent("HARDCORE_DEATHS");
		RaidWarningFrame:UnregisterEvent("HARDCORE_DEATHS");
		_G[UIname]:Show()
	else
		_G[UIname]:UnregisterEvent("HARDCORE_DEATHS");
		RaidWarningFrame:RegisterEvent("HARDCORE_DEATHS");
		_G[UIname]:Hide()
	end
end
function fujiF.Deaths.Set_config(ly)
	if _G[UIname] then _G[UIname]:Initial_config(ly) end
end
function CommonInfo.Commonfun.HardcoreDeaths()
	if not PIGA["Hardcore"]["Deaths"]["Open"] then end
	if _G[UIname] then return end
	table.insert(AudioData.HardcoreDeaths,{NONE,""})
	----
	local maxtime = PIGA["Hardcore"]["Deaths"]["savedays"]*3600*24
	local datax = PIGA["Hardcore"]["Deaths"]["List"]
	for i=#datax,1,-1 do
		if GetServerTime()-datax[i][1]>maxtime then
			PIGA["Hardcore"]["Deaths"]["Player"][datax[i][2]]=nil
			table.remove(datax,i)			
		end
	end
	----------
	Data.UILayout[UIname]={"TOPRIGHT","TOPRIGHT",-350,-174}
	local ButUI=PIGDiyBut(UIParent,nil,{30,31,nil,nil,"BossBanner-SkullCircle"},"PIG_HardcoreUI")
	Create.PIG_SetPoint(UIname)
	Create.PIGSetMovable(ButUI)
	ButUI:SetFrameStrata("LOW")
	ButUI:SetHighlightAtlas("ChallengeMode-Runes-CircleGlow")
	ButUI:RegisterForClicks("AnyUp")
	PIGEnter(ButUI,Tooltip)
	ButUI:SetScale(PIGA["Hardcore"]["Deaths"]["UIScale"]);
	ButUI.icon:SetDrawLayer("BORDER", 7)
	ButUI.msghangH =17
	ButUI.msg = CreateFrame("Frame", nil, ButUI);
	ButUI.msg:SetSize(150,ButUI.msghangH);
	ButUI.msg:SetPoint("TOP", ButUI, "BOTTOM", -0.6, 0);
	ButUI.msg.list={}
	ButUI.msg.list[1] = PIGFontString(ButUI.msg,{"TOP", 0, 0},"","OUTLINE",15)
	ButUI.msg.list[1]:SetSize(300,ButUI.msghangH);
	ButUI.msg.list[2] = PIGFontString(ButUI.msg,{"TOP", 0, -ButUI.msghangH},"","OUTLINE",15)
	ButUI.msg.list[2]:SetSize(300,ButUI.msghangH);
	ButUI.msg.list[3] = PIGFontString(ButUI.msg,{"TOP", 0, -ButUI.msghangH*2},"","OUTLINE",15)
	ButUI.msg.list[3]:SetSize(300,ButUI.msghangH);
	ButUI.msg.msglist={[1]=nil,[2]=nil,[3]=nil}
	ButUI.msg.msgcount=0
	function ButUI.msg:msgSetHeight(vcc)
		self:SetHeight(ButUI.msghangH*vcc);
	end
	function ButUI.msg:Update_msgList()
		for i=1,3 do
			self.list[i]:SetText("")
		end
		for ix=1,3 do
			if self.msglist[ix] then
				if GetTime()-self.msglist[ix][2]>13 then
					self.msglist[1]=self.msglist[2]
					self.msglist[2]=self.msglist[3]
					self.msglist[3]=nil
					self.msgcount=self.msgcount-1
				end
			end
		end
		for ix=1,3 do
			if self.msglist[ix] then
				self.list[ix]:SetText(self.msglist[ix][1])
			end
		end
		self:msgSetHeight(self.msgcount)
	end
	function ButUI.msg:AddMessage(msg)
		for i=1,3 do
			self.list[i]:SetText("")
		end
		local Time=GetTime()
		if self.msgcount==3 then
			self.msglist[1]=self.msglist[2]
			self.msglist[2]=self.msglist[3]
			self.msglist[3]={msg,Time}
		else
			if self.msgcount==2 then
				self.msglist[3]={msg,Time}
			elseif self.msgcount==1 then
				self.msglist[2]={msg,Time}
			else
				self.msglist[1]={msg,Time}
			end
		end
		if self.msgcount<3 then
			self.msgcount=self.msgcount+1
		end
		self:msgSetHeight(self.msgcount)
		for ix=1,3 do
			if self.msglist[ix] then
				self.list[ix]:SetText(self.msglist[ix][1])
			end
		end
	end
	ButUI.msg.oldtime=0
	local function Update_msg(self,sss)
		self.oldtime=self.oldtime+sss
		if self.oldtime>4 then
			self.oldtime=0
			self:Update_msgList()
		end
	end
	ButUI.msg:HookScript("OnUpdate", Update_msg);
	ButUI:HookScript("OnDragStop",function(self)
		self.icon:SetPoint("CENTER");
	end)
	fujiF.Deaths.SetONOFF()
	function ButUI:Initial_config(ly)
		ButUI.AudioID=PIGA["Hardcore"]["Deaths"]["VoiceID"]
		ButUI.Tgminlevel=PIGA["Hardcore"]["Deaths"]["Tgminlevel"]
		ButUI.tipsmap=PIGA["Hardcore"]["Deaths"]["tipsmap"]
		ButUI.BigTgminlevel=PIGA["Hardcore"]["Deaths"]["BigTgminlevel"]
		if ly then ButUI:SetScale(PIGA["Hardcore"]["Deaths"]["UIScale"]); end
	end
	ButUI:Initial_config()		
	PIGA["Hardcore"]["Deaths"]["VoiceID"]=Fun.IsAudioNumMaxV(ButUI.AudioID,AudioData.HardcoreDeaths)
	ButUI.AudioID=PIGA["Hardcore"]["Deaths"]["VoiceID"]
	ButUI.texbg = ButUI:CreateTexture(nil, "BORDER");
	ButUI.texbg:SetPoint("TOPLEFT", ButUI.msg, "TOPLEFT", -14,6);
	ButUI.texbg:SetPoint("BOTTOMRIGHT", ButUI.msg, "BOTTOMRIGHT", 14,-3);
	ButUI.texbg:SetAtlas("BossBanner-BgBanner-Mid")
	ButUI.texToplin = ButUI:CreateTexture(nil, "BORDER");
	ButUI.texToplin:SetPoint("TOPLEFT", ButUI.texbg, "TOPLEFT", 0,28);
	ButUI.texToplin:SetPoint("TOPRIGHT", ButUI.texbg, "TOPRIGHT", 0,28);
	ButUI.texToplin:SetHeight(100);
	ButUI.texToplin:SetAtlas("BossBanner-BgBanner-Top")
	ButUI.texBotlin = ButUI:CreateTexture(nil, "BORDER");
	ButUI.texBotlin:SetPoint("BOTTOMLEFT", ButUI.texbg, "BOTTOMLEFT", 0,-24);
	ButUI.texBotlin:SetPoint("BOTTOMRIGHT", ButUI.texbg, "BOTTOMRIGHT", 0,-24);
	ButUI.texBotlin:SetHeight(100);
	ButUI.texBotlin:SetAtlas("BossBanner-BgBanner-Bottom")
	ButUI.texTop = ButUI:CreateTexture(nil, "BORDER");
	ButUI.texTop:SetSize(110,47);
	ButUI.texTop:SetPoint("BOTTOM", ButUI.texToplin, "TOP", 0,-38);
	ButUI.texTop:SetAtlas("BossBanner-TopFillagree")
	ButUI.texBot = ButUI:CreateTexture(nil, "BORDER");
	ButUI.texBot:SetPoint("TOP", ButUI.texBotlin, "BOTTOM", 0,28);
	ButUI.texBot:SetSize(44,16);
	ButUI.texBot:SetAtlas("BossBanner-BottomFillagree")

	ButUI.icon.animationGroup = ButUI.icon:CreateAnimationGroup()
	ButUI.icon.animationGroup.scale1 = ButUI.icon.animationGroup:CreateAnimation("Scale")
	ButUI.icon.animationGroup.scale1:SetOrder(1)
	ButUI.icon.animationGroup.scale1:SetScaleFrom(1,1)
	ButUI.icon.animationGroup.scale1:SetScaleTo(2,2)
	ButUI.icon.animationGroup.scale1:SetDuration(0.3)
	ButUI.icon.animationGroup.scale1:SetEndDelay(0.1)
	ButUI.icon.animationGroup.scale2 = ButUI.icon.animationGroup:CreateAnimation("Scale")
	ButUI.icon.animationGroup.scale2:SetOrder(2)
	ButUI.icon.animationGroup.scale2:SetScaleFrom(1,1)
	ButUI.icon.animationGroup.scale2:SetScaleTo(0.5,0.5)
	ButUI.icon.animationGroup.scale2:SetDuration(0.3)
	-- 
	ButUI:HookScript("OnClick", function (self,button)
		if button=="LeftButton" then
			if HardcoreDeaths_UI:IsShown() then
				HardcoreDeaths_UI:Hide()
			else
				HardcoreDeaths_UI:Show()
			end
		else
			if PIG_OptionsUI:IsShown() then
				PIG_OptionsUI:Hide()
			else
				PIG_OptionsUI:Show()
				Create.Show_TabBut(CommonInfo.Llist,CommonInfo.LlistTabBut)
				Create.Show_TabBut_R(CommonInfo.NR,fujiF,fujiFBut)
			end
		end
	end);
	------
	local itemhangW,itemhangH,hangnum,hang_Height = 520,500,16,24
	local HardcoreDeaths = PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{itemhangW,itemhangH},"HardcoreDeaths_UI",true)
	HardcoreDeaths:PIGSetBackdrop(0.8)
	HardcoreDeaths:PIGSetMovable()
	HardcoreDeaths:PIGClose()
	HardcoreDeaths.biaoti = PIGFontString(HardcoreDeaths,{"TOP", 0, -2},HARDCORE_DEATHS)
	HardcoreDeaths.Seting_L = PIGFrame(HardcoreDeaths,{"TOPRIGHT",HardcoreDeaths,"TOPLEFT",-2,0},{200,itemhangH})
	HardcoreDeaths.Seting_L:PIGSetBackdrop(0.8)
	HardcoreDeaths.Seting_L:PIGClose()
	HardcoreDeaths.Seting_L:Hide()
	HardcoreDeaths.Seting_L:HookScript("OnShow", function ()
		for idx = 1, hangnum do
			HardcoreDeaths.butList[idx].time:Show()
			HardcoreDeaths.butList[idx].indexID:Show()
		end
		HardcoreDeaths.NR.timeF.Tex:SetRotation(-3.1415926, {x=0.6, y=0.5})
	end);
	HardcoreDeaths.Seting_L:HookScript("OnHide", function ()
		for idx = 1, hangnum do
			HardcoreDeaths.butList[idx].time:Hide()
			HardcoreDeaths.butList[idx].indexID:Hide()
		end
		HardcoreDeaths.NR.timeF.Tex:SetRotation(0, {x=0.6, y=0.5})
	end);
	HardcoreDeaths:HookScript("OnHide", function (self)
		self.Seting_L:Hide()
	end);
	HardcoreDeaths.Update = PIGButton(HardcoreDeaths,{"TOPLEFT",HardcoreDeaths,"TOPLEFT",10,-30},{50,20},"刷新")
	HardcoreDeaths.Update:HookScript("OnClick", function ()
		HardcoreDeaths.Update_List()
	end);
	HardcoreDeaths.CheckbutList={}
	for i=1,#minmaxlist do
		local Checkbut = PIGCheckbutton(HardcoreDeaths,nil,{minmaxlist[i][1].."-"..minmaxlist[i][2]})
		HardcoreDeaths.CheckbutList[i]=Checkbut
		if i==1 then
			Checkbut:SetPoint("LEFT",HardcoreDeaths.Update,"RIGHT",20,0);
		else
			Checkbut:SetPoint("LEFT",HardcoreDeaths.CheckbutList[i-1].Text,"RIGHT",15,0);
		end
		Checkbut.Text:SetTextColor(Quality[i-1]["RGB"][1],Quality[i-1]["RGB"][2],Quality[i-1]["RGB"][3],1)
		Checkbut:HookScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["Hardcore"]["Deaths"]["level"][i]=nil
			else
				PIGA["Hardcore"]["Deaths"]["level"][i]=true
			end
			HardcoreDeaths.Update_List()
		end);
	end
	local function Play_tex(level,wanjiaName,maptxt)
		if level>=_G[UIname].Tgminlevel then
			if _G[UIname].tipsmap then
				ButUI.msg:AddMessage("[|c"..getColor(level)..level.."|r]"..wanjiaName.."|cff00FF00+|r"..maptxt)
			else
				ButUI.msg:AddMessage("[|c"..getColor(level)..level.."|r]"..wanjiaName)
			end
			if level>=_G[UIname].BigTgminlevel then--大席
				ButUI.icon.animationGroup:Stop()
				ButUI.icon.animationGroup:Play()
				PIG_PlaySoundFile(AudioData.HardcoreDeaths[_G[UIname].AudioID])
			end
		end
	end
	--
	HardcoreDeaths.butList={}
	HardcoreDeaths.NR = PIGFrame(HardcoreDeaths,{"TOPLEFT", HardcoreDeaths, "TOPLEFT", 4, -80})
	HardcoreDeaths.NR:SetPoint("BOTTOMRIGHT", HardcoreDeaths, "BOTTOMRIGHT", -4, 4);
	HardcoreDeaths.NR:PIGSetBackdrop(0,1)
	local biaotiLsit = {{ID,-190},{TIME_LABEL,-144},{LEVEL,50},{CALENDAR_PLAYER_NAME,92},{"击杀者",210},{DEAD..FLOOR,350},}
	local biaotiSetingLF = {19,70}
	for i=1,#biaotiLsit do
		if i<3 then
			local biaoti = PIGFontString(HardcoreDeaths.Seting_L,{"TOPLEFT", HardcoreDeaths.Seting_L, "TOPLEFT", biaotiSetingLF[i], -66},biaotiLsit[i][1])
			biaoti:SetTextColor(0, 1, 0.9, 0.8);
		else
			local biaoti = PIGFontString(HardcoreDeaths.NR,{"BOTTOMLEFT", HardcoreDeaths.NR, "TOPLEFT", biaotiLsit[i][2], 2},biaotiLsit[i][1])
			biaoti:SetTextColor(0, 1, 0.9, 0.8);
		end
	end
	local wwc,hhc = 24,24
	HardcoreDeaths.NR.timeF = CreateFrame("Button",nil,HardcoreDeaths.NR, "TruncatedButtonTemplate");
	HardcoreDeaths.NR.timeF:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	HardcoreDeaths.NR.timeF:SetSize(wwc-8,hhc-6);
	HardcoreDeaths.NR.timeF:SetPoint("BOTTOMLEFT",HardcoreDeaths.NR,"TOPLEFT",0,0);
	HardcoreDeaths.NR.timeF.Tex = HardcoreDeaths.NR.timeF:CreateTexture(nil, "BORDER");
	HardcoreDeaths.NR.timeF.Tex:SetAtlas("common-icon-backarrow")
	HardcoreDeaths.NR.timeF.Tex:SetSize(wwc-4,wwc-7);
	HardcoreDeaths.NR.timeF.Tex:SetPoint("CENTER",HardcoreDeaths.NR.timeF,"CENTER",-2,0);
	HardcoreDeaths.NR.timeF:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",HardcoreDeaths.NR.timeF,"CENTER",-0.5,-1);
	end);
	HardcoreDeaths.NR.timeF:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",HardcoreDeaths.NR.timeF,"CENTER",-2,0);
	end);
	HardcoreDeaths.NR.timeF:SetScript("OnClick",  function (self)
		if HardcoreDeaths.Seting_L:IsShown() then
			HardcoreDeaths.Seting_L:Hide()
		else
			HardcoreDeaths.Seting_L:Show()
		end
	end);
	HardcoreDeaths.NR.Scroll = CreateFrame("ScrollFrame",nil,HardcoreDeaths.NR, "FauxScrollFrameTemplate");  
	HardcoreDeaths.NR.Scroll:SetPoint("TOPLEFT",HardcoreDeaths.NR,"TOPLEFT",0,-1);
	HardcoreDeaths.NR.Scroll:SetPoint("BOTTOMRIGHT",HardcoreDeaths.NR,"BOTTOMRIGHT",-23,1);
	HardcoreDeaths.NR.Scroll:HookScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, HardcoreDeaths.Update_List)
	end)
	for id = 1, hangnum do
		local hang = CreateFrame("Button", nil, HardcoreDeaths.NR,"BackdropTemplate");
		HardcoreDeaths.butList[id]=hang
		hang:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hang:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		hang:SetSize(itemhangW-26, hang_Height);
		hang:HookScript("OnEnter", function (self)
			self:SetBackdropColor(0.8, 0.8, 0.8, 0.2);
		end);
		hang:HookScript("OnLeave", function (self)
			self:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		end);
		if id==1 then
			hang:SetPoint("TOPLEFT",HardcoreDeaths.NR.Scroll,"TOPLEFT",1,0);
		else
			hang:SetPoint("TOP",HardcoreDeaths.butList[id-1],"BOTTOM",0,-2);
		end
		hang.indexID = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[1][2]-2,0})
		hang.indexID:Hide()
		hang.indexID:SetTextColor(0.8, 0.8, 0.8, 1);
		hang.time = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[2][2]-2,0})
		hang.time:Hide()
		hang.time:SetTextColor(0.8, 0.8, 0.8, 1);

		hang.Race = hang:CreateTexture();
		hang.Race:SetPoint("LEFT", hang, "LEFT", 1,0);
		hang.Race:SetSize(hang_Height-2,hang_Height-2);
		hang.Class=PIGDiyBut(hang,{"LEFT", hang.Race, "RIGHT", 1,0},{hang_Height-2,hang_Height-2,nil,nil,131146})
		hang.Class:HookScript("OnClick", function(self,button)
			local nameX = self:GetParent().name:GetText()
			FasongYCqingqiu(nameX)
		end)

		hang.level = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[3][2]+4, 0},1)
		--
		hang.name = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[4][2],0})
		hang.nameF = CreateFrame("Frame", nil, hang);
		hang.nameF:SetHeight(hang_Height-2);
		hang.nameF:SetPoint("LEFT",hang.name,"LEFT",0,0);
		hang.nameF:SetPoint("RIGHT",hang.name,"RIGHT",0,0);
		hang.nameF:HookScript("OnMouseUp", function(self,button)
			local nameX = self:GetParent().name:GetText()
			if button=="LeftButton" then
				ChatFrame_SendTell(nameX.." ".. ChatEdit_ChooseBoxForSend():GetText(), DEFAULT_CHAT_FRAME);
			else
				SendChatMessage("你如星辰，虽已陨落，但光芒永存，照亮我们前行的道路", "WHISPER", nil, nameX);
			end
		end)
		hang.NPC = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[5][2],0})
		hang.map = PIGFontString(hang,{"LEFT", hang, "LEFT", biaotiLsit[6][2],0})
	end
	function HardcoreDeaths.Update_List()
		if not HardcoreDeaths:IsShown() then return end
		for id = 1, hangnum do
			local hang = HardcoreDeaths.butList[id]
			hang:Hide()
			hang.name:SetTextColor(1, 0.843, 0, 0.9);
			hang.NPC:SetTextColor(1, 0.843, 0, 0.9);
			hang.map:SetTextColor(1, 0.843, 0, 0.9);
			hang.Race:Hide()
			hang.Class.icon:SetTexCoord(0,1,0,1);
			hang.Class.icon:SetAtlas("common-search-magnifyingglass")
			hang.Class.icon:SetSize(hang_Height-7,hang_Height-7);
		end
		local players = PIGA["Hardcore"]["Deaths"]["List"]
		local newdata = {}
		for i=1,#players do
			if IslevelOK(players[i][3]) then
				table.insert(newdata,players[i])
			end
		end
		local playersNum = #newdata
	    FauxScrollFrame_Update(HardcoreDeaths.NR.Scroll, playersNum, hangnum, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(HardcoreDeaths.NR.Scroll);
	    for id = 1, hangnum do
			local dangqianID = (playersNum+1)-id-offset
			if newdata[dangqianID] then
				local hang = HardcoreDeaths.butList[id]
				hang:Show()
				hang.indexID:SetText(dangqianID)
				hang.time:SetText(date("%Y-%m-%d %H:%M:%S",newdata[dangqianID][1]))
				hang.level:SetText("|c"..getColor(newdata[dangqianID][3])..newdata[dangqianID][3].."|r")
				hang.name:SetText(newdata[dangqianID][2])
				hang.NPC:SetText(newdata[dangqianID][4])
				hang.map:SetText(newdata[dangqianID][5])
				local datatxt = PIGA["Hardcore"]["Deaths"]["Player"][newdata[dangqianID][2]]
				if datatxt then
					local class,race,gender = datatxt[1],datatxt[2],datatxt[3]
					local className, classFile, classID = PIGGetClassInfo(class)
					hang.Class.icon:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
					hang.Class.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					hang.Class.icon:SetSize(hang_Height-2,hang_Height-2);
					local color = PIG_CLASS_COLORS[classFile];
					hang.name:SetTextColor(color.r, color.g, color.b, 1);
					hang.NPC:SetTextColor(color.r, color.g, color.b, 1);
					hang.map:SetTextColor(color.r, color.g, color.b, 1);
					if tonumber(race)>0 then
						hang.Race:Show()
						local gender=gender or 2
						local raceInfo = C_CreatureInfo.GetRaceInfo(race)
						local race_icon = PIGGetRaceAtlas(raceInfo.clientFileString,gender)
						hang.Race:SetAtlas(race_icon);
					end
				end
			end
		end
	end
	HardcoreDeaths:HookScript("OnShow", function(self)
		for i=1,#minmaxlist do
			HardcoreDeaths.CheckbutList[i]:SetChecked(not PIGA["Hardcore"]["Deaths"]["level"][i])
		end
		self.Update_List()
	end);
	function HardcoreDeaths.Save_playerdata(fullnameX,class,race,gender)
		PIGA["Hardcore"]["Deaths"]["Player"][fullnameX]={class,race,gender}
		HardcoreDeaths.Update_List()
	end
	-----
	HardcoreDeaths.auto=false
	ButUI:HookScript("OnEvent", function(self,event,arg1,arg2,arg3,arg4,arg5)
		if event == "HARDCORE_DEATHS" then
			local kaishi, jieshu, wanjiaName = arg1:find("%[(.-)%]");
			if wanjiaName and wanjiaName~="" then
				local info = {GetServerTime(),wanjiaName,1,"","","",}
				local newmsg = arg1:sub(jieshu+1);
				local level= newmsg:match("等级为(%d+)级");
				info[3]=level or 1
				local NPC = newmsg:match("被一个(.+)消灭了");
				local map = newmsg:match("地点位于(.+)！");
				if NPC and map then
					info[4]=NPC or NONE
					info[5]=map or NONE
				else
					local map, NPC = newmsg:match("在(.+)被(.+)消灭了");
					if NPC and map then
						info[4]=NPC or NONE
						info[5]=map or NONE
					else
						if newmsg:match("失足摔死") then
							info[4] = "失足摔死"
							local map = newmsg:match("在(.+)失足摔死");
							info[5]=map or NONE
						elseif newmsg:match("意外溺毙") then
							info[4] = "意外溺毙"
							local map = newmsg:match("在(.+)意外溺毙");
							info[5]=map or NONE
						elseif newmsg:match("疲劳而死") then
							info[4] = "疲劳而死"
							local map = newmsg:match("在(.+)疲劳而死");
							info[5]=map or NONE
						elseif newmsg:match("外焦里嫩") then
							local map, NPC = newmsg:match("在(.+)被(.+)烤的外焦里嫩");
							info[4]=NPC or NONE
							info[5]=map or NONE
						else
							print("未记录死亡事件，请提供给插件作者: ",arg1)
						end
					end
				end
				table.insert(PIGA["Hardcore"]["Deaths"]["List"],info)
				Play_tex(tonumber(level),wanjiaName,info[5])
				if HardcoreDeaths.auto then HardcoreDeaths.Update_List() end
			end
		end
	end); 
end