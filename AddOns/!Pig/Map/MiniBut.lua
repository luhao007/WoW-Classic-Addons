local addonName, addonTable = ...;
local L=addonTable.locale
-------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
----
local Mapfun=addonTable.Mapfun
---小地图按钮
local ButW= 33
local MiniMapBut = CreateFrame("Button","PIG_MiniMapBut",UIParent);
Mapfun.MiniMapBut=MiniMapBut
MiniMapBut:SetMovable(true)
MiniMapBut:EnableMouse(true)
MiniMapBut:RegisterForClicks("LeftButtonUp","RightButtonUp")
MiniMapBut:RegisterForDrag("LeftButton")
MiniMapBut:SetFrameStrata("MEDIUM")
MiniMapBut:SetFrameLevel(MiniMapBut:GetFrameLevel()+1);
MiniMapBut.Border = MiniMapBut:CreateTexture(nil,"BORDER");
MiniMapBut.icon = MiniMapBut:CreateTexture(nil, "BACKGROUND");
MiniMapBut.icon:SetTexture("Interface/AddOns/"..addonName.."/Libs/logo32.blp");
MiniMapBut.icon:SetPoint("CENTER", 0, 0);
MiniMapBut.error = MiniMapBut:CreateTexture(nil, "BORDER");
MiniMapBut.error:SetTexture("interface/common/voicechat-muted.blp");
MiniMapBut.error:SetSize(18,18);
MiniMapBut.error:SetAlpha(0.7);
MiniMapBut.error:SetPoint("CENTER", 0, 0);
MiniMapBut.error:Hide();
function MiniMapBut.Showaddonstishi(self,laiyuan)
	GameTooltip:ClearLines();
	if laiyuan then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT",-2,16);
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT",-24,0);
	end
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..PIGGetAddOnMetadata(addonName, "Version"))
	GameTooltip:AddLine(self.TooltipV)
	GameTooltip:Show();
end	
MiniMapBut:SetScript("OnEnter", function(self)
	self.Showaddonstishi(self)
end);
MiniMapBut:SetScript("OnLeave", function()
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end);
local function YDButtonP(mode,xpos,ypos)
	if mode==1 or mode==3 then
		MiniMapBut:ClearAllPoints();
		if mode==1 then
			if PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then
				local xpos=xpos or PIGA["Map"]["MinimapPoint_NDui"][1]
				local ypos=ypos or PIGA["Map"]["MinimapPoint_NDui"][2]
				MiniMapBut:SetPoint("BOTTOMLEFT",Minimap,"BOTTOMLEFT",xpos,ypos)
				PIGA["Map"]["MinimapPoint_NDui"][1]=xpos
				PIGA["Map"]["MinimapPoint_NDui"][2]=ypos
			elseif PIG_OptionsUI.IsOpen_ElvUI() then
				local xpos=xpos or PIGA["Map"]["MinimapPoint_ElvUI"][1]
				local ypos=ypos or PIGA["Map"]["MinimapPoint_ElvUI"][2]
				MiniMapBut:SetPoint("BOTTOMLEFT",Minimap,"BOTTOMLEFT",xpos,ypos)
				PIGA["Map"]["MinimapPoint_ElvUI"][1]=xpos
				PIGA["Map"]["MinimapPoint_ElvUI"][2]=ypos
			else
				local xpos=xpos or PIGA["Map"]["MinimapPos"]
				local banjing = Minimap:GetWidth()*0.5+8
				local pianyi =MiniMapBut.pianyi
				MiniMapBut:SetPoint("TOPLEFT",Minimap,"TOPLEFT",pianyi-2-(banjing*cos(xpos)),(banjing*sin(xpos))-pianyi)
				PIGA["Map"]["MinimapPos"]=xpos
			end
		elseif mode==3 then
			if xpos and xpos then
				MiniMapBut:SetPoint("CENTER",UIParent,"CENTER",xpos,ypos)
				PIGA["Map"]["MinimapPointXY"][1]=xpos
				PIGA["Map"]["MinimapPointXY"][2]=ypos	
			else
				local xpos=PIGA["Map"]["MinimapPointXY"] and PIGA["Map"]["MinimapPointXY"][1] or addonTable.Default["Map"]["MinimapPointXY"][1]
				local ypos=PIGA["Map"]["MinimapPointXY"] and PIGA["Map"]["MinimapPointXY"][2] or addonTable.Default["Map"]["MinimapPointXY"][2]
				MiniMapBut:SetPoint("CENTER",UIParent,"CENTER",xpos,ypos)
			end
		end
	end
end
local function YDButtonP_OnUpdate()	
	local mode = PIGA["Map"]["MinimapPointMode"]
	local UIScale = UIParent:GetEffectiveScale()
	local xpos,ypos = GetCursorPosition()
	local xpos = xpos/UIScale
	local ypos = ypos/UIScale
	local left, bottom, width, height = Minimap:GetScaledRect()
	local left = left/UIScale
    local bottom = bottom/UIScale
    local width = width/UIScale
    local height = height/UIScale
	local Pigleft, Pigbottom, Pigwidth, Pigheight  = MiniMapBut:GetScaledRect()
	local Pigleft = Pigleft/UIScale
    local Pigbottom = Pigbottom/UIScale
    local Pigwidth = Pigwidth/UIScale
    local Pigheight = Pigheight/UIScale
	local Pigwidth2 = Pigwidth*0.5
	local Pigheight2 = Pigheight*0.5
	if mode==3 then
		local MinibutW3 = Pigwidth2-4
		local WowWidth2=GetScreenWidth()*0.5;
		local WowHeight2=GetScreenHeight()*0.5;
		local xpos = xpos-WowWidth2
		local ypos = ypos-WowHeight2
		if xpos>WowWidth2-MinibutW3 then xpos=WowWidth2-MinibutW3 end
		if xpos<-WowWidth2+MinibutW3 then xpos=-WowWidth2+MinibutW3 end
		if ypos>WowHeight2-MinibutW3 then ypos=WowHeight2-MinibutW3 end
		if ypos<-WowHeight2+MinibutW3 then ypos=-WowHeight2+MinibutW3 end
		YDButtonP(mode,xpos,ypos)
		MiniMapBut.Box:ClearAllPoints();
		local Pointinfo = {"RIGHT", "LEFT", "TOP", "BOTTOM", -2, 25}
		if xpos<0 then
			Pointinfo[1]="LEFT"
			Pointinfo[2]="RIGHT"
		end
		if ypos<0 then
			Pointinfo[3]="BOTTOM"
			Pointinfo[4]="TOP"
			Pointinfo[6]=0
		end
		MiniMapBut.Box:SetPoint(Pointinfo[3]..Pointinfo[1], MiniMapBut, Pointinfo[4]..Pointinfo[2], Pointinfo[5], Pointinfo[6]);
	else
		if PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") or PIG_OptionsUI.IsOpen_ElvUI() then
			local xpos = xpos-left-Pigwidth2
			local ypos = ypos-bottom-Pigheight2
			if xpos<0 then xpos=0 end--X左边
			local rightbianp = width-Pigwidth
			if xpos>rightbianp then--X右边
				xpos=rightbianp
			end
			if ypos<0 then ypos=0 end--下
			local topbianp = height-Pigheight
			if ypos>topbianp then
				ypos=topbianp
			end
			YDButtonP(mode,xpos,ypos)
		else
			local xpos = left-xpos+width*0.5
			local ypos = ypos-bottom-width*0.5
			YDButtonP(mode,math.deg(math.atan2(ypos,xpos)))
		end
	end
end
function MiniMapBut:ClickShowSet()
	if PIG_OptionsUI:IsShown() then	
		PIG_OptionsUI:Hide();
	else
		self.Box:Hide();
		PIG_OptionsUI:Show();
	end
end
function MiniMapBut:ClickShowSNF()
	if self.Box:IsShown() then	
		self.Box:Hide();
	else
		PIG_OptionsUI:Hide();
		self.Box:Show();
		self.Box.xiaoshidaojishi = 1.5;
		self.Box.zhengzaixianshi = true;
	end
end
function MiniMapBut:minimapButClickFun(button)
	GameTooltip:Hide()
	if button=="LeftButton" then
		if IsControlKeyDown() then
			PIG_BugcollectUI:Show()
			self.error:Hide();
		elseif IsShiftKeyDown() then
			ReloadUI()
		else
			if PIGA["Map"]["MiniButShouNa_YN"]==1 then
				self:ClickShowSNF()
			else
				self:ClickShowSet()
			end
		end
	elseif button=="RightButton" then
		self:ClickShowSet()
	end
end
MiniMapBut:SetScript("OnClick", function(self, button)
	PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
	self:minimapButClickFun(button)
end)
local MiniMapButYD = CreateFrame("Frame")
MiniMapButYD:Hide();
function MiniMapBut.RegistrationEvent(ONOFF)
	if ONOFF then
		MiniMapButYD:SetScript("OnUpdate",YDButtonP_OnUpdate)
		MiniMapBut:SetScript("OnDragStart", function(self)
			self:LockHighlight();MiniMapButYD:Show();
		end)
		MiniMapBut:SetScript("OnDragStop", function(self)
			self:UnlockHighlight();MiniMapButYD:Hide();
		end)
	else
		MiniMapButYD:SetScript("OnUpdate",nil)
		MiniMapBut:SetScript("OnDragStart",nil)
		MiniMapBut:SetScript("OnDragStop",nil)
	end
end
function MiniMapBut:CZMinimapInfo()
	PIGA["Map"]["MinimapPos"]=addonTable.Default["Map"]["MinimapPos"]
	PIGA["Map"]["MinimapPointXY"]=nil
	PIGA["Map"]["MinimapPoint_NDui"]=addonTable.Default["Map"]["MinimapPoint_NDui"]
	PIGA["Map"]["MinimapPoint_ElvUI"]=addonTable.Default["Map"]["MinimapPoint_ElvUI"]
	YDButtonP(PIGA["Map"]["MinimapPointMode"]);
end
MiniMapBut.Box = PIGFrame(MiniMapBut,nil,{200, 100});
MiniMapBut.Box:PIGSetBackdrop()
MiniMapBut.Box:Hide();
MiniMapBut.Box.tishi = PIGFontString(MiniMapBut.Box,nil,L["MAP_NIMIBUT_TIPS3"])
MiniMapBut.Box.tishi:SetPoint("TOPLEFT", MiniMapBut.Box, "TOPLEFT", 6, -6);
MiniMapBut.Box.tishi:SetPoint("BOTTOMRIGHT", MiniMapBut.Box, "BOTTOMRIGHT", -6, 6);
MiniMapBut.Box.tishi:Hide();
MiniMapBut.Box:SetScript("OnUpdate", function(self, ssss)
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
MiniMapBut.Box:SetScript("OnEnter", function(self)
	self.zhengzaixianshi = nil;
end)
MiniMapBut.Box:SetScript("OnLeave", function(self)
	self.xiaoshidaojishi = 1.5;
	self.zhengzaixianshi = true;
end)
--刷新按钮位置
function addonTable.UpdateMiniButPoint()
	if not PIGA["Map"]["MinimapBut"] then MiniMapBut:Hide() return end
	--存在外部控制函数
	for adname,adDB in pairs(addonTable.ShareDB) do	
		if adDB.DiyMiniMapBut then Mapfun.MiniMapBut.DiyMiniMapFun=adDB.DiyMiniMapBut break end
	end
	if PIGA["Map"]["MiniButShouNa_YN"]==2 then
		MiniMapBut:SetParent(Minimap)
		MiniMapBut:SetFrameStrata("MEDIUM")
	elseif PIGA["Map"]["MiniButShouNa_YN"]==1 then
		MiniMapBut:SetParent(UIParent)		
	end
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then 
		MiniMapBut.TooltipV=L["MAP_NIMIBUT_TIPS1"]
	else
		MiniMapBut.TooltipV=L["MAP_NIMIBUT_TIPS2"]
	end
	if PIG_OptionsUI.IsOpen_ElvUI() then
		local function ElvUIPoint()
			if MinimapPanel and MinimapPanel:IsVisible() then
				MiniMapBut.Box:SetPoint("TOPRIGHT", MiniMapBut, "BOTTOMLEFT", -2, 20);
				MiniMapBut.icon:SetTexCoord(0.1,0.88,0.2,0.8)
				MiniMapBut.icon:SetAllPoints(MiniMapBut)
				local PanelH = MinimapPanel:GetHeight()
				local PanelW = MinimapPanel:GetWidth()	
				local DataTextwww = (PanelW-PanelH-2)*0.5
				MinimapPanel:SetPoint("TOPLEFT",Minimap,"BOTTOMLEFT",PanelH-2,0)
				MinimapPanel:SetWidth(DataTextwww)
				--
				MiniMapBut:SetSize(PanelH,PanelH);
				MiniMapBut:ClearAllPoints();
				MiniMapBut:SetPoint("RIGHT",MinimapPanel,"LEFT",2,0)
				return
			else
				C_Timer.After(2,ElvUIPoint)
			end
		end
		C_Timer.After(2,ElvUIPoint)
	end
	local mode = PIGA["Map"]["MinimapPointMode"]
	local ButpingXY = {["W"]=ButW,["H"]=ButW,["iconW"]=ButW-10,["iconH"]=ButW-10}
	PIGA["Map"]["MinimapPointXY"]=PIGA["Map"]["MinimapPointXY"] or addonTable.Default["Map"]["MinimapPointXY"]
	PIGA["Map"]["MinimapPoint_NDui"]=PIGA["Map"]["MinimapPoint_NDui"] or addonTable.Default["Map"]["MinimapPoint_NDui"]
	PIGA["Map"]["MinimapPoint_ElvUI"]=PIGA["Map"]["MinimapPoint_ElvUI"] or addonTable.Default["Map"]["MinimapPoint_ElvUI"]
	MiniMapBut.Box:ClearAllPoints();
	MiniMapBut:ClearNormalTexture()
	MiniMapBut:ClearPushedTexture()
	MiniMapBut.RegistrationEvent(false)
	if mode == 1 or mode == 3 then
		MiniMapBut.pianyi = 0
		MiniMapBut.RegistrationEvent(true)
		if mode == 1 then--小地图
			if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then
				if PIG_OptionsUI.IsOpen_ElvUI() then
					ButpingXY.W,ButpingXY.H=ButW-14,ButW-14
					ButpingXY.iconW,ButpingXY.iconH=ButW-14,ButW-14
				elseif PIG_OptionsUI.IsOpen_NDui() then
					ButpingXY.W,ButpingXY.H=ButW-12,ButW-12
					ButpingXY.iconW,ButpingXY.iconH=ButW-12,ButW-12
				end
				MiniMapBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
				MiniMapBut.Border:Hide()
			else
				MiniMapBut:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight");
				MiniMapBut.Border:SetDrawLayer("BORDER",1)
				MiniMapBut.icon:SetDrawLayer("BACKGROUND",1)
				--MiniMapBut.Border:SetAtlas("ui-lfg-roleicon-incentive")
				MiniMapBut.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
				MiniMapBut.Border:SetSize(56,56);
				MiniMapBut.Border:ClearAllPoints();	
				MiniMapBut.Border:SetPoint("TOPLEFT", -1, 0);
				MiniMapBut.Border:Show()
				if PIG_MaxTocversion() then
					MiniMapBut.pianyi = 56
				else
					MiniMapBut.pianyi = 82
				end
			end
		elseif mode == 3 then--自由
			MiniMapBut.Border:Hide()
			MiniMapBut:SetHighlightAtlas("chatframe-button-highlight");
		end
		MiniMapBut.Box:SetPoint("TOPRIGHT", MiniMapBut, "BOTTOMLEFT", -2, 20);
		YDButtonP(mode);
	elseif mode == 2 then--聊天框
		MiniMapBut.Border:Hide()
		MiniMapBut:ClearAllPoints();	
		if PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then
			ButpingXY.W,ButpingXY.H=21,21
			ButpingXY.iconW,ButpingXY.iconH=20,20
			MiniMapBut:SetPoint("TOP",ChatFrameChannelButton,"BOTTOM",0,-1);
			MiniMapBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		elseif PIG_OptionsUI.IsOpen_ElvUI() then
			ButpingXY.W,ButpingXY.H=21,21
			ButpingXY.iconW,ButpingXY.iconH=20,20
			MiniMapBut:SetPoint("RIGHT",ChatFrameChannelButton,"LEFT",0,0);
			MiniMapBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		else
			ButpingXY.W,ButpingXY.H=27,26
			ButpingXY.iconW,ButpingXY.iconH=17,17
			MiniMapBut:SetPoint("BOTTOM",ChatFrameChannelButton,"TOP",0,2);
			MiniMapBut:SetNormalAtlas("chatframe-button-up")
			MiniMapBut:SetPushedAtlas("chatframe-button-down")
			MiniMapBut:SetHighlightAtlas("chatframe-button-highlight");
		end
		MiniMapBut.icon:SetDrawLayer("ARTWORK",1)
		MiniMapBut.Box:SetPoint("BOTTOMLEFT", MiniMapBut, "TOPRIGHT", 2, 2);
	end
	if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then MiniMapBut.icon:SetTexCoord(0.1,0.88,0.1,0.9) end
	MiniMapBut:SetSize(ButpingXY.W,ButpingXY.H);
	MiniMapBut.icon:SetSize(ButpingXY.iconW,ButpingXY.iconH);
end
--收纳功能
local ExcludeButlist = {
	"MiniMapTrackingFrame",
	"MiniMapMeetingStoneFrame",
	"MiniMapMailFrame",
	"MiniMapBattlefieldFrame",
	"MiniMapWorldMapButton",
	"MiniMapPing",
	"MinimapBackdrop",
	"MinimapZoomIn",
	"MinimapZoomOut",
	"BookOfTracksFrame",
	"GatherNote",
	"FishingExtravaganzaMini",
	"MiniNotePOI",
	"RecipeRadarMinimapIcon",
	"FWGMinimapPOI",
	"CartographerNotesPOI",
	"MBB_MinimapButtonFrame",
	"EnhancedFrameMinimapButton",
	"GFW_TrackMenuFrame",
	"GFW_TrackMenuButton",
	"TDial_TrackingIcon",
	"TDial_TrackButton",
	"MiniMapTracking",
	"GatherMatePin",
	"HandyNotesPin",
	"TimeManagerClockButton",
	"GameTimeFrame",
	"DA_Minimap",
	"ElvConfigToggle",
	"MiniMapInstanceDifficulty",
	"MinimapZoneTextButton",
	"GuildInstanceDifficulty",
	"MiniMapVoiceChatFrame",
	"MiniMapRecordingButton",
	"QueueStatusMinimapButton",
	"GatherArchNote",
	"ZGVMarker",
	"QuestPointerPOI",
	"poiMinimap",
	"MiniMapLFGFrame",
	"PremadeFilter_MinimapButton",
	"QuestieFrame",
	"Guidelime",
	"MiniMapBattlefieldFrame",
	"PIG_OptionsUI.MiniMapBut",
	"MinimapLayerFrame",
	"NWBNaxxMarkerMini",
	"NWBMini",
	"SexyMapCustomBackdrop",
	"SexyMapCoordFrame",
	"SexyMapPingFrame",
	"SexyMapZoneTextButton",
	"ElvUI_MinimapHolder",
	"QueueStatusButton",
	"MinimapPanel",
	"RecycleBinToggleButton",
	"BFGPSButton",
	"LibDBIcon10_HandyNotes_NPCs",
	--"EA_MinimapOption",--EventAlertMod
	--"LibDBIcon10_DetailsStreamer",
}
for i=1,10 do
	table.insert(ExcludeButlist,"GatherLite"..i)
end
for i=1,10 do
	table.insert(ExcludeButlist,"Spy_MapNoteList_mini"..i)
end
Mapfun.MiniBoxList={};
Mapfun.MiniBoxList_Show={};
local function IsNoExclude(uiname)
	for x=1,#ExcludeButlist do
		if uiname:match(ExcludeButlist[x]) then
			return false;
		end
	end
	return true
end
local function IsNoDIYExclude(uiname)
	local datax = PIGA["Map"]["MinimapBpaichu"]
	for x=1,#datax do
		if uiname:match(datax[x]) then
			return true;
		end
	end
	return false
end
Mapfun.IsNoDIYExclude=IsNoDIYExclude
local function InsertButToBox(data,uiname)
	for x=1,#data do
		if uiname==data[x] then
			return
		end
	end
	table.insert(data,uiname)
end
local function UpdateCollectBut()
	local children = {Minimap:GetChildren()};
	for i=1,#children do
		local uiname = children[i]:GetName()
		if uiname then
			if IsNoExclude(uiname) then
				InsertButToBox(Mapfun.MiniBoxList,uiname)
				if not IsNoDIYExclude(uiname) then
					InsertButToBox(Mapfun.MiniBoxList_Show,uiname)
				end
			end
		end
	end
	MiniMapBut.Box.tishi:Show();
	local meipaishu=PIGA["Map"]["MiniButShouNa_hang"];--每排按钮数
	local ButListNum=#Mapfun.MiniBoxList_Show
	if ButListNum>0 then
		MiniMapBut.Box.tishi:Hide()
		local hangshuV = math.ceil(ButListNum/meipaishu)
		MiniMapBut.Box:SetSize(meipaishu*35+30, hangshuV*35+30)
		for i=1, ButListNum,1 do
			_G[Mapfun.MiniBoxList_Show[i]]:Show()
			_G[Mapfun.MiniBoxList_Show[i]]:SetParent(MiniMapBut.Box)
			_G[Mapfun.MiniBoxList_Show[i]]:HookScript("OnEnter", function()
				MiniMapBut.Box.zhengzaixianshi = nil;
			end)
			_G[Mapfun.MiniBoxList_Show[i]]:HookScript("OnLeave", function()
				MiniMapBut.Box.xiaoshidaojishi = 1.5;
				MiniMapBut.Box.zhengzaixianshi = true;
			end)
			-- _G[Mapfun.MiniBoxList_Show[i]]:HookScript("PostClick", function ()
			-- 	MiniMapBut.Box:Hide();
			-- end);
		end	
		for iiii=1, hangshuV,1 do
			if iiii==1 then
				for xxxx=1, iiii*meipaishu, 1 do
					if xxxx==1 then
						_G[Mapfun.MiniBoxList_Show[xxxx]]:ClearAllPoints();
						_G[Mapfun.MiniBoxList_Show[xxxx]]:SetPoint("TOPLEFT", MiniMapBut.Box, "TOPLEFT", 15, -15)
					else
						if _G[Mapfun.MiniBoxList_Show[xxxx]] then
							_G[Mapfun.MiniBoxList_Show[xxxx]]:ClearAllPoints();
							_G[Mapfun.MiniBoxList_Show[xxxx]]:SetPoint("TOPLEFT", MiniMapBut.Box, "TOPLEFT", 35*(xxxx-1)+15, -15)
						end
					end
				end
			else
				for xxxx=(iiii-1)*meipaishu+1, iiii*meipaishu, 1 do
					if xxxx-(iiii-1)*meipaishu==1 then
						_G[Mapfun.MiniBoxList_Show[xxxx]]:ClearAllPoints();
						_G[Mapfun.MiniBoxList_Show[xxxx]]:SetPoint("TOPLEFT", MiniMapBut.Box, "TOPLEFT", 15, -35*(iiii-1)-15)
					else
						if _G[Mapfun.MiniBoxList_Show[xxxx]] then
							_G[Mapfun.MiniBoxList_Show[xxxx]]:ClearAllPoints();
							_G[Mapfun.MiniBoxList_Show[xxxx]]:SetPoint("TOPLEFT", MiniMapBut.Box, "TOPLEFT", 35*(xxxx-(iiii-1)*meipaishu-1)+15, -35*(iiii-1)-15)
						end
					end
				end
			end
		end
	end
end
function addonTable.CollectMiniMapBut()
	if RecycleBinToggleButton then--如果玩家NDui收纳功能启用
		MiniMapBut.Box.tishi:SetText("|cffFF0000NDui收纳功能启用,已禁用"..addonName.."收纳功能|r")
		MiniMapBut.Box.tishi:Show();
		return 
	end
	if PIGA["Error"]["ErrorTishi"] then
		table.insert(ExcludeButlist,"LibDBIcon10_BugSack")
	end
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then
		C_Timer.After(0.1, UpdateCollectBut);
		C_Timer.After(1, UpdateCollectBut);
		C_Timer.After(6, UpdateCollectBut);
		C_Timer.After(14, UpdateCollectBut);
	end
end