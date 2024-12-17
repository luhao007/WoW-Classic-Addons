local _, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local sub = _G.string.sub
--
local Fun=addonTable.Fun
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
--
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local SendAddonMessage = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage;
local RegisterAddonMessagePrefix = C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix;
local CombatPlusfun=addonTable.CombatPlusfun
--------------------------
local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME1"],90)
CombatPlusF:Show()
CombatPlustabbut:Selected()
local function Show_OptionsUI()
	if Pig_OptionsUI:IsShown() then
		Pig_OptionsUI:Hide()
	else
		Pig_OptionsUI:Show()
		Create.Show_TabBut(CombatPlusfun.fuFrame,CombatPlusfun.fuFrameBut)
		Create.Show_TabBut_R(CombatPlusfun.RTabFrame,CombatPlusF,CombatPlustabbut)
	end
end
--------
local biaojiW = 22
local function updateiconDesaturated(uiname)
	uiname:GetNormalTexture():SetDesaturated(true)
end
local function updateicon(uiname,l,r,t,b)
	local l=l or 6
	local r=r or 6
	local t=t or 6
	local b=b or 6
	uiname:GetNormalTexture():SetPoint("TOPLEFT", uiname, "TOPLEFT",-l,t)
	uiname:GetNormalTexture():SetPoint("BOTTOMRIGHT", uiname, "BOTTOMRIGHT",r,-b)
end
local function updateiconall(uiname,l,r,t,b)
	updateiconDesaturated(uiname)
	updateicon(uiname,l,r,t,b)
end
--add倒计时
local PigPulldata={
	["morenCD"]=10,
	["BigGold"]  = {
		texture = "Interface\\Timer\\BigTimerNumbers", 
		w=256, h=170, texW=1024, texH=512,
		numberHalfWidths = {
			--0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
			35/128, 14/128, 33/128, 32/128, 36/128, 32/128, 33/128, 29/128, 31/128, 31/128,
		},
	},
}
local daojishiList = {[1]="暴雪1",[2]="暴雪2",[3]="XXX",[4]="XXXX"}
local function ADDDoCountdownUI()
	local timer=CreateFrame("Frame", "PIG_TimerTracker", UIParent)
	timer:SetAllPoints(UIParent)
	timer:Hide();
	local texCoW = PigPulldata.BigGold.w/PigPulldata.BigGold.texW;
	local texCoH = PigPulldata.BigGold.h/PigPulldata.BigGold.texH;
	local columns = floor(PigPulldata.BigGold.texW/PigPulldata.BigGold.w);
	for i=0,9 do
		local number = timer:CreateTexture("PIG_TimerTracker_"..i);
		local number1 = timer:CreateTexture("PIG_TimerTracker_1"..i);
		number:SetTexture(PigPulldata.BigGold.texture);
		number1:SetTexture(PigPulldata.BigGold.texture);
		local hw = PigPulldata.BigGold.numberHalfWidths[i+1]*PigPulldata.BigGold.w*0.5
		local l = mod(i, columns) * texCoW;
		local r = l + texCoW;
		local t = floor(i/columns) * texCoH;
		local b = t + texCoH;
		number:SetTexCoord(l,r,t,b);
		number1:SetTexCoord(l,r,t,b);
	end
	timer.Bar = CreateFrame("StatusBar", nil, timer);
	timer.Bar:SetStatusBarTexture("interface/chatframe/chatframebackground.blp")
	timer.Bar:SetStatusBarColor(1, 0.1, 0.1, 0.8);
	timer.Bar:SetSize(300,26);
	timer.Bar:SetPoint("CENTER", 0, 280);
	timer.Bar.Border = CreateFrame("Frame", nil, timer.Bar,"BackdropTemplate")
	timer.Bar.Border:SetBackdrop({edgeFile = Create.edgeFile, edgeSize = 8,})
	timer.Bar.Border:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	timer.Bar.Border:SetAllPoints(timer.Bar)
	timer.Bar.bg = timer.Bar:CreateTexture(nil, "BACKGROUND");
	timer.Bar.bg:SetTexture("interface/characterframe/ui-party-background.blp");
	timer.Bar.bg:SetPoint("TOPLEFT",timer.Bar,"TOPLEFT",0,0);
	timer.Bar.bg:SetPoint("BOTTOMRIGHT",timer.Bar,"BOTTOMRIGHT",0,0);
	timer.Bar.bg:SetAlpha(0.4)
	timer.Bar.t = PIGFontString(timer.Bar,{"CENTER", -10, 0},"开怪倒计: ","OUTLINE",16)
	timer.Bar.t:SetTextColor(1, 1, 1, 1);
	timer.Bar.V = PIGFontString(timer.Bar,{"LEFT",timer.Bar.t,"RIGHT", 0, 0},"","OUTLINE",18)
	timer.Bar.V:SetTextColor(1, 1, 1, 1);
	local function Hide_numbut()
		PIG_TimerTracker.Bar:Hide()
		for i=0,9 do
			_G["PIG_TimerTracker_"..i]:Hide()
			_G["PIG_TimerTracker_1"..i]:Hide()
		end
	end
	local function updatenumid(shid)
		if shid<10 then
			local numnut = _G["PIG_TimerTracker_"..shid]
			numnut:SetSize(PigPulldata.BigGold.w,PigPulldata.BigGold.h);
			numnut:SetPoint("CENTER", 0, 30);
			numnut:Show()
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
		elseif shid<31 then
			local shouid = tostring(shid):sub(1,1)
			local endid = tostring(shid):sub(2,2)
			local numnut = _G["PIG_TimerTracker_"..shouid]
			numnut:SetSize(PigPulldata.BigGold.w*0.5,PigPulldata.BigGold.h*0.5);
			numnut:SetPoint("CENTER", -24, 280);
			numnut:Show()
			local numnut = _G["PIG_TimerTracker_1"..endid]
			numnut:SetSize(PigPulldata.BigGold.w*0.5,PigPulldata.BigGold.h*0.5);
			numnut:SetPoint("CENTER", 24, 280);
			numnut:Show()
		end
	end
	local function StartTimer_BigNumberOnUpdate(self, elapsed)
		self.time = self.endTime - GetTime();
		if self.time>60 then
			self.Bar:SetValue(self.time);
			self.Bar.V:SetText(date("%M:%S",self.time))
			self.Bar:Show()
		elseif self.time>31 then
			self.Bar:SetValue(self.time);
			self.Bar.V:SetText(date("%S",self.time))
			self.Bar:Show()
		elseif self.time>1 then
			local seconds = floor(mod(self.time, 60));
			if self.updateTime>seconds then
				Hide_numbut()
				updatenumid(seconds)
				self.updateTime = seconds
			end
		else
			self:Hide()
			PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3);
		end
	end
	local function PIG_PULL(CDtime,ly)
		Hide_numbut()
		local CDtime = CDtime+1
		PIG_TimerTracker:SetScript("OnUpdate", nil);
		PIG_TimerTracker.updateTime=CDtime
		PIG_TimerTracker.endTime = GetTime() + CDtime;
		PIG_TimerTracker.Bar:SetMinMaxValues(0, CDtime)
		PIG_TimerTracker:SetScript("OnUpdate", StartTimer_BigNumberOnUpdate);
		PIG_TimerTracker:Show()
	end
	local function PIG_opentiem()
		timer.opentiem=true
		C_Timer.After(0.1,function()
			timer.opentiem=nil
		end)
	end
	local function DoCountdown(CDtime, arg1)
		if not SlashCmdList.DEADLYBOSSMODSPULL and not SlashCmdList.BIGWIGSPULL then
			PIG_opentiem()
			PIG_PULL(tonumber(CDtime),arg1)
		end
	end
	RegisterAddonMessagePrefix("D5")
	RegisterAddonMessagePrefix("BigWigs")
	timer:RegisterEvent("CHAT_MSG_ADDON")
	timer:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4)
		if self.opentiem then return end
		if arg1=="D5" then
			local fullname, SyncProtocol, prefix, CDtime, CurrentArea = strsplit("\t", arg2);
			if prefix=="PT" and CDtime then
				DoCountdown(CDtime, arg1)
			end
		elseif arg1=="BigWigs" then
			local SyncProtocol, prefix, CDtime = strsplit("^", arg2);
			if SyncProtocol=="P" and prefix=="Pull" and CDtime then
				if not SlashCmdList.BIGWIGSPULL and not SlashCmdList.DEADLYBOSSMODSPULL then
					DoCountdown(CDtime, arg1)
				end
			end
		end
	end)
	return function(CDtime)
		local CDtime = CDtime or PigPulldata.morenCD
		if IsInGroup() then
			local _, instanceType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
			if IsInRaid() then
				SendAddonMessage("D5", Pig_OptionsUI.AllName .. "\t1\t" .. "PT" .. "\t" .. CDtime .. "\t" .. mapID, "RAID")
				SendAddonMessage("BigWigs", "P^Pull^"..CDtime, "RAID")
			else
				SendAddonMessage("D5", Pig_OptionsUI.AllName .. "\t1\t" .. "PT" .. "\t" .. CDtime .. "\t" .. mapID, "PARTY")
				SendAddonMessage("BigWigs", "P^Pull^"..CDtime, "RAID")
			end
		else
			PIG_PULL(CDtime)
		end
	end
end
local function GetDoCountdownFun()
	if C_PartyInfo and C_PartyInfo.DoCountdown then
		return C_PartyInfo.DoCountdown
	else
		return ADDDoCountdownUI()
	end
end

-- --坐标，延迟，帧数,重置，宏
-- FramerateFrame.Label:SetText("FPS:")
-- hooksecurefunc(FramerateFrame, "UpdatePosition", function()
-- 	FramerateFrame:ClearAllPoints();
-- 	FramerateFrame:SetPoint("TOP",UIParent, "TOP", 5, -90);
-- end)
-- FramerateFrame:Show()
-- FramerateFrame:SetScript("OnUpdate", function(self,elapsed)
-- 	local timeLeft = self.fpsTime - elapsed
-- 	if timeLeft <= 0 then
-- 		self.fpsTime = FRAMERATE_FREQUENCY;
-- 		self.FramerateText:SetFormattedText("%.0f", GetFramerate());
-- 		self:Layout();
-- 	else
-- 		self.fpsTime = timeLeft;
-- 	end
-- end); 
local function updateicon_Difficulty(button)
	local difficulty = GetDungeonDifficultyID();
	local isAssist = UnitIsGroupAssistant("player");
	local atlas = nil; 
	local inStoryRaid = DifficultyUtil.InStoryRaid();
	if (difficulty == DifficultyUtil.ID.DungeonNormal) or inStoryRaid then
		atlas = isAssist and "GM-icon-difficulty-normalAssist" or "GM-icon-difficulty-normal";
	elseif difficulty == DifficultyUtil.ID.DungeonHeroic then
		atlas = isAssist and "GM-icon-difficulty-heroicAssist" or "GM-icon-difficulty-heroic";
	else
		atlas = isAssist and "GM-icon-difficulty-mythicAssist" or "GM-icon-difficulty-mythic";
	end
	button:GetNormalTexture():SetAtlas(atlas, TextureKitConstants.IgnoreAtlasSize);
end
local ConvertToParty=ConvertToParty or C_PartyInfo and C_PartyInfo.ConvertToParty
local ConvertToRaid=ConvertToRaid or C_PartyInfo and C_PartyInfo.ConvertToRaid
local function ToPartyToRaid()
	if IsInRaid(LE_PARTY_CATEGORY_HOME) then
		ConvertToParty() 
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		ConvertToRaid()
	end
end
--转换队伍
--QuestSharing-QuestLog-Active--plunderstorm-glues-queueselector-duo-selected--trios-icon-bubble-active
--groupfinder-waitdot--个人转换--GM-icon-assist
--Ping_SpotGlw_Assist_In
--NecrolordAssaults-64x64
--groupfinder-icon-class-color-monk
local MenuiconList = {}
if tocversion>100000 then
	table.insert(MenuiconList,1,{{"Atlas","common-icon-rotateleft"},{"离开队伍","离开副本队伍"},{updateiconall,-1,-3,-1,-1},function(self,button) if button=="LeftButton" then C_PartyInfo.LeaveParty() else ConfirmOrLeaveLFGParty() end end})
	table.insert(MenuiconList,2,{{"Atlas","GM-icon-assist"},{"切换小队/团队"},{updateicon},ToPartyToRaid})
	table.insert(MenuiconList,3,{{"Atlas","GM-raidMarker-reset"},{"重置副本"},{updateiconDesaturated},function() StaticPopup_Show("CONFIRM_RESET_INSTANCES"); end})
	table.insert(MenuiconList,4,{{"Atlas","GM-icon-difficulty-normalSelected"},{"副本难度"},{updateicon}, updateicon_Difficulty})
	table.insert(MenuiconList,5,{{"Atlas","Ping_SpotGlw_Assist_In"},{COMBATLOGDISABLED},{updateicon,-2,-2,-1,-2},function() end})
	table.insert(MenuiconList,6,{{"Atlas","GM-icon-roles"},{"职责检查"},{updateicon,4,4,4,4},function() InitiateRolePoll() end})
	table.insert(MenuiconList,7,{{"Atlas","GM-icon-readyCheck"},{"就位确认"},{updateicon,6,6,5,7},function() DoReadyCheck() end})
	table.insert(MenuiconList,{{"Atlas","GM-icon-countdown"},{"倒计时","设置倒数秒"},{updateicon},GetDoCountdownFun()})
else
	--interface/raidframe/readycheck-notready.blp
	-- {"Atlas","UI-LFG-PendingMark"},
	-- {"Atlas","UI-LFG-ReadyMark"},
	-- {"Atlas","UI-LFG-DeclineMark"},
	table.insert(MenuiconList,1,{{"Atlas","common-icon-rotateleft"},{"离开队伍","离开副本队伍"},{updateicon,0,-1,-1,0},function(self,button) if button=="LeftButton" then LeaveParty() else ConfirmOrLeaveLFGParty() end end})
	table.insert(MenuiconList,2,{{"Atlas","groupfinder-waitdot"},{"切换小队/团队"},{updateicon,-3,-3,-3,-2.4},ToPartyToRaid})--UI-ChatIcon-App/socialqueuing-icon-group
	table.insert(MenuiconList,3,{{"Atlas","common-icon-undo"},{"重置副本"},{updateicon,-1,-1,-1,-1},function() StaticPopup_Show("CONFIRM_RESET_INSTANCES"); end})
	table.insert(MenuiconList,4,{{"Tex","interface/common/indicator-green.blp"},{COMBATLOGDISABLED},nil,function() end})
	table.insert(MenuiconList,5,{{"Tex","interface/raidframe/readycheck-waiting.blp"},{"职责检查"},nil,function() InitiateRolePoll() end})
	table.insert(MenuiconList,6,{{"Tex","interface/raidframe/readycheck-ready.blp"},{"就位确认"},nil,function() DoReadyCheck() end})
	table.insert(MenuiconList,{{"Tex","interface/helpframe/helpicon-reportlag.blp",{0.13,0.87,0.13,0.87}},{"倒计时","设置倒数秒"},nil,GetDoCountdownFun()})
end
local MenuiconNum=#MenuiconList
---
local biaoji_icon = "interface/targetingframe/ui-raidtargetingicons"
local RiconList = {
	{biaoji_icon,{0.75,1,0.25,0.5}},
	{biaoji_icon,{0.5,0.75,0.25,0.5}},
	{biaoji_icon,{0.25,0.5,0.25,0.5}},
	{biaoji_icon,{0,0.25,0.25,0.5}},
	{biaoji_icon,{0.75,1,0,0.25}},
	{biaoji_icon,{0.5,0.75,0,0.25}},
	{biaoji_icon,{0.25,0.5,0,0.25}},
	{biaoji_icon,{0,0.25,0,0.25}},
	{"Interface/Buttons/UI-GroupLoot-Pass-Up"},
}
local RiconNum=#RiconList
---
local WmarkerIndex={
	[1]={8,1,1,1},
	[2]={4,1,60/255,60/255},
	[3]={1,0,191/255,1},
	[4]={7,135/255,180/255,200/255},
	[5]={2,30/255,255/255,100/255},
	[6]={3,240/255,60/255,1},
	[7]={6,1,165/255,0},
	[8]={5,1,1,50/255},
	[9]={0,1,40/255,40/255},
}
-----
local GNLsitsName={"topMenu","markerR","markerW"}
local GNLsits={
	["topMenu"]={["yes"]=true,["name"]="快捷菜单",["barHH"]=biaojiW-2,["iconNum"]=MenuiconNum,["topbutui"]=-1,["OptionsTop"]=0},
	["markerR"]={["yes"]=true,["name"]="目标标记",["barHH"]=biaojiW,["iconNum"]=RiconNum,["topbutui"]=-30,["OptionsTop"]=210},
	["markerW"]={["yes"]=PlaceRaidMarker,["name"]="地面标记",["barHH"]=biaojiW-8,["iconNum"]=RiconNum,["topbutui"]=-36-biaojiW,["OptionsTop"]=350},
}
local function add_barUI(peizhiT,SizeHH,listNum,topbutui)
	local biaojiUIx = PIGFrame(UIParent,{"TOP", UIParent, "TOP", 0, topbutui},{(biaojiW+3)*listNum+5,SizeHH+4},"PIG"..peizhiT.."_UI",nil,Template)
	biaojiUIx:PIGSetBackdrop(0.4,0.9,nil,{0.3,0.3,0.3})
	biaojiUIx:PIGSetMovable()
	biaojiUIx:Hide()
	biaojiUIx.yidong = PIGFrame(biaojiUIx)
	biaojiUIx.yidong:PIGSetBackdrop(0.4,0.9,nil,{0.3,0.3,0.3})
	biaojiUIx.yidong:SetSize(12, SizeHH+4)
	biaojiUIx.yidong:SetPoint("RIGHT",biaojiUIx,"LEFT",1,0);
	Create.PIGSetMovable(biaojiUIx.yidong,biaojiUIx)
	biaojiUIx.yidong:SetScript("OnEnter", function (self)
		self:SetBackdropBorderColor(0,0.8,1,0.9);
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",12,0);
		GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..TUTORIAL_TITLE2.."|r\n"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r")	
		GameTooltip:Show();
	end);
	biaojiUIx.yidong:SetScript("OnLeave", function (self)
		self:SetBackdropBorderColor(0.3,0.3,0.3,0.9);
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end)
	biaojiUIx.yidong:SetScript("OnMouseUp", function (self,Button)

		Show_OptionsUI()
	end);
	return biaojiUIx
end
local function SetBGHide(peizhiT,pigui)
	if PIGA["CombatPlus"][peizhiT]["BGHide"] then
		pigui:SetBackdropColor(0, 0, 0, 0);
		pigui:SetBackdropBorderColor(0, 0, 0, 0);
	else
		pigui:SetBackdropColor(0.08, 0.08, 0.08, 0.4);
		pigui:SetBackdropBorderColor(0.3,0.3,0.3,0.9);
	end
end
local function SetAutoShowFun(pigui)
	if pigui==_G["PIGmarkerW_UI"] and InCombatLockdown() then
		pigui.nextfun=function()
			SetAutoShowFun(pigui)
		end
		return
	end
	pigui.ShowHide=true
	if pigui.NoGroup and not IsInGroup() then
		pigui.ShowHide=false
	else
		if pigui==_G["PIGmarkerR_UI"] then
			if pigui.NoTarget and not UnitExists("target") then
				pigui.ShowHide=false
			elseif pigui.AutoShow and IsInGroup() and not CanBeRaidTarget("player") then--
				pigui.ShowHide=false
			end
		elseif pigui==_G["PIGmarkerW_UI"] then
			if pigui.AutoShow and not IsInGroup() or pigui.AutoShow and UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false then
				pigui.ShowHide=false
			end
		end
	end
	pigui:SetShown(pigui.ShowHide)
end
local function SetAutoShow(peizhiT,pigui)
	pigui.NoGroup=PIGA["CombatPlus"][peizhiT]["NoGroup"]
	pigui.AutoShow=PIGA["CombatPlus"][peizhiT]["AutoShow"]
	pigui.NoTarget=PIGA["CombatPlus"][peizhiT]["NoTarget"]
	if pigui==PIGworldmarker and InCombatLockdown() then PIGinfotip:TryDisplayMessage("更改将在脱战后执行") end
	SetAutoShowFun(pigui)
end
local function add_buttonList(peizhiT,listNum)
	local pigui=_G["PIG"..peizhiT.."_UI"]
	if not pigui or not PIGA["CombatPlus"][peizhiT]["Open"] then return end
	if pigui.yizairu then return end
	local PIGUseKeyDown=Fun.PIGUseKeyDown
	for i=1,listNum do
		local listbut
		if pigui==_G["PIGmarkerR_UI"] then
			listbut = CreateFrame("Button", nil, pigui)
			listbut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
			listbut:SetSize(biaojiW,biaojiW)	
			listbut:SetPoint("LEFT", pigui, "LEFT",i*(biaojiW+3)-biaojiW,0)
			listbut:SetNormalTexture(RiconList[i][1])
			if RiconList[i][2] then
				listbut:GetNormalTexture():SetTexCoord(RiconList[i][2][1],RiconList[i][2][2],RiconList[i][2][3],RiconList[i][2][4])
			end
			listbut:SetScript("OnClick", function(self) 
				--SetRaidTargetIcon("target", listNum-i) 
				SetRaidTarget("target", listNum-i)
			end)
		elseif pigui==_G["PIGmarkerW_UI"] then
			listbut = CreateFrame("CheckButton", "$parent_But"..i, pigui,"SecureActionButtonTemplate")
			PIGUseKeyDown(listbut)
			listbut:SetSize(biaojiW,biaojiW-10)
			listbut:SetPoint("LEFT", pigui, "LEFT",i*(biaojiW+3)-biaojiW,0)
			listbut.bgX = CreateFrame("Frame", nil, listbut,"BackdropTemplate")
			listbut.bgX:SetBackdrop(Create.Backdropinfo);
			listbut.bgX:SetBackdropColor(WmarkerIndex[i][2], WmarkerIndex[i][3], WmarkerIndex[i][4], 1);
			listbut.bgX:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
			listbut.bgX:SetAllPoints(listbut)
			listbut:SetScript("OnEnter", function (self)
				self.bgX:SetBackdropBorderColor(0, 1, 1, 1);
			end);
			listbut:SetScript("OnLeave", function (self)
				self.bgX:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
			end)
			listbut:SetAttribute("type1","worldmarker")
			listbut:SetAttribute("marker1",WmarkerIndex[i][1])
			if i<9 then
				listbut:SetAttribute("action1","set")
			else
				listbut:SetAttribute("action1","clear")
			end
			listbut:SetAttribute("type2","worldmarker")
			listbut:SetAttribute("marker2",WmarkerIndex[i][1])
			listbut:SetAttribute("action2","clear")
		else
			local frameType="Button"
			if MenuiconList[i][2][1]=="副本难度" then frameType="DropdownButton" end
			listbut = CreateFrame(frameType, nil, pigui)
			listbut:RegisterForClicks("LeftButtonUp","RightButtonUp")
			listbut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
			listbut:SetSize(biaojiW,biaojiW)	
			listbut:SetPoint("LEFT", pigui, "LEFT",i*(biaojiW+3)-biaojiW,0)
			if MenuiconList[i][1][1]=="Atlas" then
				listbut:SetNormalAtlas(MenuiconList[i][1][2])
			elseif MenuiconList[i][1][1]=="Tex" then
				listbut:SetNormalTexture(MenuiconList[i][1][2])
				if MenuiconList[i][1][3] then
					listbut:GetNormalTexture():SetTexCoord(MenuiconList[i][1][3][1],MenuiconList[i][1][3][2],MenuiconList[i][1][3][3],MenuiconList[i][1][3][4])
				end
			end
			if MenuiconList[i][3] then
				MenuiconList[i][3][1](listbut,MenuiconList[i][3][2],MenuiconList[i][3][3],MenuiconList[i][3][4],MenuiconList[i][3][5])
			end
			listbut.Tooltip=MenuiconList[i][2][1]
			listbut.Tooltip1=MenuiconList[i][2][2]
			listbut:SetScript("OnEnter", function (self)
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT",0,0);
				if frameType=="DropdownButton" then
					if self.disabledTooltipText then
						local tooltipText = RED_FONT_COLOR:WrapTextInColorCode(self.disabledTooltipText);
						GameTooltip_SetTitle(GameTooltip, tooltipText);
					else
						GameTooltip_SetTitle(GameTooltip, MenuiconList[i][2][1]);
					end
				else
					if self.Tooltip1 then
						GameTooltip:AddLine(KEY_BUTTON1.."-|cffFFFFff"..self.Tooltip.."|r\n"..KEY_BUTTON2.."-|cffFFFFff"..self.Tooltip1.."|r")
					else
						GameTooltip:AddLine("|cffFFFFff"..self.Tooltip.."|r")
					end
				end
				GameTooltip:Show();
			end);
			if frameType=="DropdownButton" then
				listbut:SetupMenu(function(dropdown, rootDescription)
					rootDescription:SetTag("MENU_RAID_FRAME_DIFFICULTY");
					local function IsSelected(difficultyID)
						return GetDungeonDifficultyID() == difficultyID;
					end
					local function SetSelected(difficultyID)
						SetDungeonDifficultyID(difficultyID);
					end
					rootDescription:CreateRadio(PLAYER_DIFFICULTY1, IsSelected, SetSelected, 1);
					rootDescription:CreateRadio(PLAYER_DIFFICULTY2, IsSelected, SetSelected, 2);
					rootDescription:CreateRadio(PLAYER_DIFFICULTY6, IsSelected, SetSelected, 23);
				end);
				local enabled = not DifficultyUtil.InStoryRaid();
				listbut:SetEnabled(enabled);
				listbut:SetAlpha(enabled and 1.0 or .3);
				if enabled then
					listbut.disabledTooltipText = nil;
				else
					listbut.disabledTooltipText = DIFFICULTY_LOCKED_REASON_STORY_RAID;
				end
				MenuiconList[i][4](listbut)
				listbut:SetScript("OnMouseDown", function (self)
					MenuiconList[i][4](self)
				end)
				listbut:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
				listbut:SetScript("OnEvent", function(self,event)
					MenuiconList[i][4](self)
				end)
			end
			if MenuiconList[i][2][1]==COMBATLOGDISABLED then pigui.WCL=listbut end
			listbut:SetScript("OnLeave", function (self)
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end)
			listbut:SetScript("OnClick", function(self,button)
				if i==listNum then
					if button=="LeftButton" then
						MenuiconList[i][4](PigPulldata.morenCD)
					else
						Show_OptionsUI()
					end
				else
					MenuiconList[i][4](self,button)
				end
			end)
		end
		listbut:HookScript("OnClick", function(self) 
			if i~=listNum then
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			end
		end)
	end
	pigui:SetScale(PIGA["CombatPlus"][peizhiT]["Scale"])
	pigui.yidong:SetShown(not PIGA["CombatPlus"][peizhiT]["Lock"])
	SetBGHide(peizhiT,pigui)
	SetAutoShow(peizhiT,pigui)
	pigui:RegisterEvent("GROUP_ROSTER_UPDATE")
	pigui:RegisterEvent("RAID_ROSTER_UPDATE")
	pigui:RegisterEvent("PLAYER_REGEN_ENABLED")
	pigui:RegisterEvent("PLAYER_ENTERING_WORLD")
	pigui:RegisterEvent("RAID_TARGET_UPDATE")
	pigui:RegisterEvent("PLAYER_TARGET_CHANGED")
	pigui:SetScript("OnEvent", function(self,event)
		if event=="PLAYER_REGEN_ENABLED" then
			if pigui.nextfun then
				pigui.nextfun()
				pigui.nextfun=nil
			end
		else
			SetAutoShowFun(self) 
		end
	end);
	pigui.yizairu=true
end
local function add_Options(peizhiT,topHV,nameGN,pigui)
	local checkbutOpen = PIGCheckbutton(CombatPlusF,{"TOPLEFT",CombatPlusF,"TOPLEFT",20,-topHV-20},{"启用"..nameGN.."按钮","在屏幕上显示"..nameGN.."快速标记按钮"})
	checkbutOpen:SetScript("OnClick", function (self)
		if pigui==_G["PIGmarkerW_UI"] and InCombatLockdown() then self:SetChecked(PIGA["CombatPlus"][peizhiT]["Open"]) PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
		if self:GetChecked() then
			PIGA["CombatPlus"][peizhiT]["Open"]=true;
			self.F:Show()
		else
			PIGA["CombatPlus"][peizhiT]["Open"]=false;
			self.F:Hide()
			Pig_Options_RLtishi_UI:Show()
		end
		add_buttonList(peizhiT,GNLsits[peizhiT].iconNum)
	end)
	---
	checkbutOpen.F = PIGFrame(checkbutOpen,{"TOPLEFT",checkbutOpen,"BOTTOMLEFT",20,-20},{1,1})
	checkbutOpen.F:Hide()

	checkbutOpen.F.Lock =PIGCheckbutton(checkbutOpen.F,{"TOPLEFT",checkbutOpen.F,"TOPLEFT",0,0},{LOCK_FRAME,LOCK_FOCUS_FRAME})
	checkbutOpen.F.Lock:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"][peizhiT]["Lock"]=true;
		else
			PIGA["CombatPlus"][peizhiT]["Lock"]=false;
		end
		pigui.yidong:SetShown(not PIGA["CombatPlus"][peizhiT]["Lock"])
	end);
	local xiayiinfo = {0.6,2,0.01,{["Right"]="%"}}
	checkbutOpen.F.Slider = PIGSlider(checkbutOpen.F,{"LEFT",checkbutOpen.F.Lock,"RIGHT",190,0},xiayiinfo)
	checkbutOpen.F.Slider.T = PIGFontString(checkbutOpen.F.Slider,{"RIGHT",checkbutOpen.F.Slider,"LEFT",-10,0},"缩放")
	checkbutOpen.F.Slider.Slider:HookScript("OnValueChanged", function(self, arg1)
		PIGA["CombatPlus"][peizhiT]["Scale"]=arg1;
		pigui:SetScale(arg1)
	end)
	checkbutOpen.F.Lock.CZBUT = PIGButton(checkbutOpen.F.Lock,{"LEFT",checkbutOpen.F.Slider,"RIGHT",100,0},{80,24},"重置位置")
	checkbutOpen.F.Lock.CZBUT:SetScript("OnClick", function ()
		pigui:PIGResPoint({"TOP", UIParent, "TOP", 0, GNLsits[peizhiT].topbutui})
	end)
	checkbutOpen.F.BGHide= PIGCheckbutton(checkbutOpen.F,{"TOPLEFT",checkbutOpen.F,"TOPLEFT",0,-40},{"隐藏背景","隐藏标记按钮背景"})
	checkbutOpen.F.BGHide:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"][peizhiT]["BGHide"]=true;
		else
			PIGA["CombatPlus"][peizhiT]["BGHide"]=false;
		end
		SetBGHide(peizhiT,pigui)
	end);
	if pigui==_G["PIGmarkerR_UI"] or pigui==_G["PIGmarkerW_UI"] then
		checkbutOpen.F.AutoShow= PIGCheckbutton(checkbutOpen.F,{"LEFT",checkbutOpen.F.BGHide,"RIGHT",120,0},{"无权限隐藏","当你没有标记权限时隐藏标记按钮"})
		checkbutOpen.F.AutoShow:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["CombatPlus"][peizhiT]["AutoShow"]=true;
			else
				PIGA["CombatPlus"][peizhiT]["AutoShow"]=false;
			end
			SetAutoShow(peizhiT,pigui)
		end);
		if pigui==_G["PIGmarkerR_UI"] then
			checkbutOpen.F.NoTarget= PIGCheckbutton(checkbutOpen.F,{"LEFT",checkbutOpen.F.AutoShow,"RIGHT",120,0},{"无目标隐藏","当你没有目标时隐藏标记按钮"})
			checkbutOpen.F.NoTarget:SetScript("OnClick", function (self)
				if self:GetChecked() then
					PIGA["CombatPlus"][peizhiT]["NoTarget"]=true;
				else
					PIGA["CombatPlus"][peizhiT]["NoTarget"]=false;
				end
				SetAutoShow(peizhiT,pigui)
			end);
			checkbutOpen.F.NoGroup= PIGCheckbutton(checkbutOpen.F,{"LEFT",checkbutOpen.F.NoTarget,"RIGHT",120,0},{"单人时隐藏","当你单人时隐藏标记按钮"})
			checkbutOpen.F.NoGroup:SetScript("OnClick", function (self)
				if self:GetChecked() then
					PIGA["CombatPlus"][peizhiT]["NoGroup"]=true;
				else
					PIGA["CombatPlus"][peizhiT]["NoGroup"]=false;
				end
				SetAutoShow(peizhiT,pigui)
			end);
		end
	else
		local xiayiinfoTime = {3,180,1}
		checkbutOpen.F.daojishiTime = PIGSlider(checkbutOpen.F,{"LEFT",checkbutOpen.F.BGHide,"RIGHT",200,0},xiayiinfoTime)
		checkbutOpen.F.daojishiTime.T = PIGFontString(checkbutOpen.F.daojishiTime,{"RIGHT",checkbutOpen.F.daojishiTime,"LEFT",0,0},"倒数(秒)")
		checkbutOpen.F.daojishiTime.Slider:HookScript("OnValueChanged", function(self, arg1)
			PigPulldata.morenCD=arg1
			PIGA["CombatPlus"][peizhiT]["daojishiTime"]=arg1;
		end)
		checkbutOpen.F.PIGPULLSHOW= PIGCheckbutton(checkbutOpen.F,{"TOPLEFT",checkbutOpen.F,"TOPLEFT",0,-80},{"始终启用","正常情况下在开启DBM/BigWigs插件时禁用PIG倒计时功能\n开启后在存在DBM/BigWigs插件时也使用PIG倒计时"})
		checkbutOpen.F.PIGPULLSHOW:Disable()
		checkbutOpen.F.PIGPULLSHOW:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["CombatPlus"][peizhiT]["PIGPULLSHOW"]=true;
			else
				PIGA["CombatPlus"][peizhiT]["PIGPULLSHOW"]=false;
			end
			SetBGHide(peizhiT,pigui)
		end);
		checkbutOpen.F.Daojishi=PIGDownMenu(checkbutOpen.F,{"LEFT",checkbutOpen.F.PIGPULLSHOW,"RIGHT",260,0},{180})
		checkbutOpen.F.Daojishi:Disable()
		checkbutOpen.F.Daojishi.t = PIGFontString(checkbutOpen.F.Daojishi,{"RIGHT",checkbutOpen.F.Daojishi,"LEFT",-4,0},"倒计结束音效");
		function checkbutOpen.F.Daojishi:PIGDownMenu_Update_But(self)
			local info = {}
			info.func = self.PIGDownMenu_SetValue
			for i=1,4,1 do
			    info.text, info.arg1 = daojishiList[i], i
			    info.checked = i==PIGA["CombatPlus"][peizhiT]["daojishiFun"]
				checkbutOpen.F.Daojishi:PIGDownMenu_AddButton(info)
			end 
		end
		function checkbutOpen.F.Daojishi:PIGDownMenu_SetValue(value,arg1,arg2)
			checkbutOpen.F.Daojishi:PIGDownMenu_SetText(value)
			PIGA["CombatPlus"][peizhiT]["daojishiFun"]=arg1
			PIGCloseDropDownMenus()
		end
		
	end
	--
	checkbutOpen.F:HookScript("OnShow", function (self)
		self.Lock:SetChecked(PIGA["CombatPlus"][peizhiT]["Lock"]);
		self.BGHide:SetChecked(PIGA["CombatPlus"][peizhiT]["BGHide"]);
		self.Slider:PIGSetValue(PIGA["CombatPlus"][peizhiT]["Scale"])
		if self.AutoShow then self.AutoShow:SetChecked(PIGA["CombatPlus"][peizhiT]["AutoShow"]);end
		if self.NoGroup then self.NoGroup:SetChecked(PIGA["CombatPlus"][peizhiT]["NoGroup"]);end
		if self.NoTarget then self.NoTarget:SetChecked(PIGA["CombatPlus"][peizhiT]["NoTarget"]);end
		if self.Daojishi then self.Daojishi:PIGDownMenu_SetText(daojishiList[PIGA["CombatPlus"][peizhiT]["daojishiFun"]]);end
		if self.daojishiTime then self.daojishiTime:PIGSetValue(PIGA["CombatPlus"][peizhiT]["daojishiTime"]);end
	end);
	CombatPlusF:HookScript("OnShow", function ()
		checkbutOpen:SetChecked(PIGA["CombatPlus"][peizhiT]["Open"]);
		if PIGA["CombatPlus"][peizhiT]["Open"] then checkbutOpen.F:Show() end
	end);
	return checkbutOpen
end
for i=1,#GNLsitsName do
	if GNLsits[GNLsitsName[i]].yes then
		local PIGtopbar=add_barUI(GNLsitsName[i],GNLsits[GNLsitsName[i]].barHH,GNLsits[GNLsitsName[i]].iconNum,GNLsits[GNLsitsName[i]].topbutui)
		if i>1 then PIGLine(CombatPlusF,"TOP",-GNLsits[GNLsitsName[i]].OptionsTop) end
		add_Options(GNLsitsName[i],GNLsits[GNLsitsName[i]].OptionsTop,GNLsits[GNLsitsName[i]].name,PIGtopbar)
	end
end
function CombatPlusfun.Marker()
	PigPulldata.morenCD=PIGA["CombatPlus"]["topMenu"]["daojishiTime"]
	for i=1,#GNLsitsName do
		if GNLsits[GNLsitsName[i]].yes then
			add_buttonList(GNLsitsName[i],GNLsits[GNLsitsName[i]].iconNum)
		end
	end
end