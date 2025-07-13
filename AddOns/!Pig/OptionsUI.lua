local addonName, addonTable = ...;
local L=addonTable.locale
-------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGLine=Create.PIGLine
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
---
--系统插件菜单======================
local PIG_SetF = CreateFrame("Frame");
PIG_SetF:Hide()
PIG_SetF.Openshezhi = PIGButton(PIG_SetF,{"TOPLEFT",PIG_SetF,"TOPLEFT",20,-20},{80,24},L["OPTUI_SET"],nil,nil,nil,nil,0)
PIG_SetF.Openshezhi:SetScript("OnClick", function ()
	HideUIPanel(InterfaceOptionsFrame);
	HideUIPanel(SettingsPanel);
	HideUIPanel(GameMenuFrame);
	PIG_OptionsUI:Show();
end)
-- function PIG_SetF:OnRefresh()
-- 	--PIG_SetF.EditBoxUI:Show()
-- 	--PIG_SetF.EditBoxUI:SetText("-------------")
-- end
if Settings and Settings.RegisterCanvasLayoutCategory then
	local category, layout = Settings.RegisterCanvasLayoutCategory(PIG_SetF,addonName)
	Settings.RegisterAddOnCategory(category)
elseif InterfaceOptions_AddCategory then
	PIG_SetF.name = addonName
	InterfaceOptions_AddCategory(PIG_SetF);
	--子页
	-- PIG_SetF.childpanel = CreateFrame( "Frame", nil, PIG_SetF);
	-- PIG_SetF.childpanel.name = "About";
	-- PIG_SetF.childpanel.parent = PIG_SetF.name--指定归属父级
	-- InterfaceOptions_AddCategory(PIG_SetF.childpanel);
	-- PIG_AddOnPanel.okay = function (self) SC_ChaChingPanel_Close(); end;
	-- PIG_AddOnPanel.cancel = function (self) SC_ChaChingPanel_CancelOrLoad();  end;
end
---------------
local OptionsW,OptionsH,OptionsJG,BottomHHH = 800,600,14,40
local Pig_Options=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{OptionsW,OptionsH},"PIG_OptionsUI",true)
Pig_Options:PIGSetBackdrop()
Pig_Options:SetFrameStrata("HIGH")
--左侧内容
local OptionsLFW =160
Pig_Options.L = CreateFrame("Frame", nil, Pig_Options)
Pig_Options.L:SetWidth(OptionsLFW);
Pig_Options.L:SetPoint("TOPLEFT", Pig_Options, "TOPLEFT", 0, 0)
Pig_Options.L:SetPoint("BOTTOMLEFT", Pig_Options, "BOTTOMLEFT", 0, 0)
Pig_Options.L.top = PIGFrame(Pig_Options.L)
Pig_Options.L.top:SetHeight(50)
Pig_Options.L.top:SetPoint("TOPLEFT", Pig_Options.L, "TOPLEFT", 2, -2)
Pig_Options.L.top:SetPoint("TOPRIGHT", Pig_Options.L, "TOPRIGHT", 0, 0)
Pig_Options.L.top:PIGSetMovableNoSave(Pig_Options)
Pig_Options.L.top.title = PIGFontString(Pig_Options.L.top,{"LEFT", Pig_Options.L.top, "LEFT", 13, 6},addonName,nil, 36)
Pig_Options.L.top.title:SetTextColor(1, 69/255, 0, 1)
Pig_Options.L.top.title1 =PIGFontString(Pig_Options.L.top,{"BOTTOMLEFT", Pig_Options.L.top.title, "BOTTOMRIGHT", 10, 0},L["ADDON_NAME"],nil, 16)
Pig_Options.L.top.title1:SetTextColor(0, 1, 1, 1)
--菜单
Pig_Options.L.F = PIGFrame(Pig_Options.L)
Pig_Options.L.F:PIGSetBackdrop()
Pig_Options.L.F:SetPoint("TOPLEFT", Pig_Options.L.top, "BOTTOMLEFT", 0, 0)
Pig_Options.L.F:SetPoint("BOTTOMRIGHT", Pig_Options.L, "BOTTOMRIGHT", 0, BottomHHH)
Pig_Options.L.F.ListTOP = CreateFrame("Frame", nil, Pig_Options.L.F)
Pig_Options.L.F.ListTOP:SetPoint("TOPLEFT", Pig_Options.L.F, "TOPLEFT", 0, 0)
Pig_Options.L.F.ListTOP:SetPoint("BOTTOMRIGHT", Pig_Options.L.F, "BOTTOMRIGHT", 0, 120)
Pig_Options.L.F.ListEXT = CreateFrame("Frame", nil, Pig_Options.L.F)
Pig_Options.L.F.ListEXT:SetPoint("TOPLEFT", Pig_Options.L.F.ListTOP, "BOTTOMLEFT", 0, 0)
Pig_Options.L.F.ListEXT:SetPoint("BOTTOMRIGHT", Pig_Options.L.F, "BOTTOMRIGHT", 0, 0)
PIGLine(Pig_Options.L.F.ListEXT,"TOP",0,2.1,{1,-1},{1, 0.65, 0, 0.8})
Pig_Options.L.F.ListBOT = CreateFrame("Frame", nil, Pig_Options.L.F)
Pig_Options.L.F.ListBOT:SetPoint("TOPLEFT", Pig_Options.L.F, "BOTTOMLEFT", 0, 0)
Pig_Options.L.F.ListBOT:SetPoint("BOTTOMRIGHT", Pig_Options.L, "BOTTOMRIGHT", 0, 0)
--右侧
Pig_Options.R = CreateFrame("Frame", nil, Pig_Options)
Pig_Options.R:SetPoint("TOPLEFT", Pig_Options, "TOPLEFT", OptionsLFW+OptionsJG, 0)
Pig_Options.R:SetPoint("BOTTOMRIGHT", Pig_Options, "BOTTOMRIGHT", 0, BottomHHH)
--右侧顶部
Pig_Options.R.top = PIGFrame(Pig_Options.R)
Pig_Options.R.top:SetHeight(24)
Pig_Options.R.top:SetPoint("TOPLEFT", Pig_Options.R, "TOPLEFT", 0, -2)
Pig_Options.R.top:SetPoint("TOPRIGHT", Pig_Options.R, "TOPRIGHT", -2, 0)
Pig_Options.R.top:PIGSetBackdrop()
Pig_Options.R.top:PIGSetMovableNoSave(Pig_Options)
Pig_Options.R.top:PIGClose(25,25,Pig_Options)
Pig_Options.R.top.Ver = CreateFrame("Frame", nil, Pig_Options.R.top)
Pig_Options.R.top.Ver:SetPoint("TOPLEFT", Pig_Options.R.top, "TOPLEFT", 0, 0)
Pig_Options.R.top.Ver:SetPoint("BOTTOMRIGHT", Pig_Options.R.top, "BOTTOMRIGHT", -30, 0)
Pig_Options.VersionID=0
function Pig_Options:GetVer_NUM(EXTaddname,ly)
	if ly=="audio" then
		return Pig_Options.R.top.audioVer and Pig_Options.R.top.audioVer[EXTaddname].VersionID or 0
	else
		return Pig_Options.R.top.Ver and Pig_Options.R.top.Ver[EXTaddname].VersionID or 0
	end
end
function Pig_Options:GetVer_TXT(EXTaddname,ly)
	if ly=="audio" then
		return Pig_Options.R.top.audioVer and Pig_Options.R.top.audioVer[EXTaddname].VersionTXT or 0
	else
		return Pig_Options.R.top.Ver and Pig_Options.R.top.Ver[EXTaddname].VersionTXT or 0
	end
end
function Pig_Options:SetVer_EXT(EXTaddname,ly)
	local VersionTXT=PIGGetAddOnMetadata(EXTaddname, "Version")
	local VersionID=tonumber(VersionTXT)
	if ly=="audio" then
		Pig_Options.R.top.audioVer=Pig_Options.R.top.audioVer or{}
		Pig_Options.R.top.audioVer[EXTaddname]=Pig_Options.R.top.audioVer[EXTaddname] or {}
		Pig_Options.R.top.audioVer[EXTaddname].VersionID=VersionID
		Pig_Options.R.top.audioVer[EXTaddname].VersionTXT=VersionTXT
	else
		local name, title, notes, loadable = PIGGetAddOnInfo(EXTaddname)
		local ziframe = {Pig_Options.R.top.Ver:GetChildren()}
		local verF = PIGFrame(Pig_Options.R.top.Ver,nil,{0.0001,20})
		Pig_Options.R.top.Ver[EXTaddname]=verF
		if #ziframe==0 then
			verF:SetPoint("LEFT", Pig_Options.R.top.Ver, "LEFT", 4, -2)
		else
			verF:SetPoint("LEFT", ziframe[#ziframe].txt, "RIGHT", 0, 0)
		end
		verF.txt = PIGFontString(verF,{"LEFT", verF, "LEFT", 0, 0})
		verF.New = verF:CreateTexture();
		verF.New:SetAtlas("loottoast-arrow-purple");
		verF.New:SetSize(14,15);
		verF.New:SetPoint("BOTTOMLEFT", verF.txt, "TOPRIGHT", -6, -11);
		verF.New:Hide()
		verF.VersionTXT=VersionTXT
		verF.VersionID=VersionID
	end
end
Pig_Options:HookScript("OnShow", function (self)
	for EXTaddname,v in pairs(L["PIGaddonList"]) do
		if self.R.top.Ver[EXTaddname] then
			local verF = Pig_Options.R.top.Ver[EXTaddname]
			local VerTXT = "|cffFFD700%s:|r|cff00FF00%s|r"
			if EXTaddname==addonName then
				verF.txt:SetText(string.format(VerTXT,GAME_VERSION_LABEL,verF.VersionTXT))
			else
				verF.txt:SetText("|cff00FFFF + |r"..string.format(VerTXT,L["PIGaddonList"][EXTaddname],verF.VersionTXT))
			end
			if PIGA["Ver"][EXTaddname] and verF.VersionID<PIGA["Ver"][EXTaddname] then
				verF.New:Show()
				if EXTaddname==addonName then
					self.UpdateVer:Show()
				end
			end
		end
	end
end);
--右侧内容
Pig_Options.R.F = PIGFrame(Pig_Options.R)
Pig_Options.R.F:PIGSetBackdrop()
Pig_Options.R.F:SetPoint("TOPLEFT", Pig_Options.R, "TOPLEFT", 0, -34)
Pig_Options.R.F:SetPoint("BOTTOMRIGHT", Pig_Options.R, "BOTTOMRIGHT", -2, 0)
Pig_Options.R.F.NR = CreateFrame("Frame", nil, Pig_Options.R.F)
Pig_Options.R.F.NR:SetAllPoints(Pig_Options.R.F)
--侧面功能按钮区域
Pig_Options.ListFun = PIGFrame(Pig_Options)
Pig_Options.ListFun:PIGSetBackdrop()
Pig_Options.ListFun:SetPoint("TOPLEFT", Pig_Options.R.F, "TOPRIGHT", 4, 0)
Pig_Options.ListFun:SetPoint("BOTTOMRIGHT", Pig_Options, "BOTTOMRIGHT", 40, 0)

--RLUI
Pig_Options.RLUI = CreateFrame("Frame", nil, Pig_Options)
Pig_Options.RLUI:SetSize(520, 28)
Pig_Options.RLUI:SetPoint("BOTTOM", Pig_Options, "BOTTOM", 80, 8)
Pig_Options.RLUI:Hide()
Pig_Options.RLUI.txt = PIGFontString(Pig_Options.RLUI,{"CENTER", Pig_Options.RLUI, "CENTER", -20, -2},L["OPTUI_RLUITIPS"],"OUTLINE")
Pig_Options.RLUI.txt:SetTextColor(1, 0, 0, 1);
Pig_Options.RLUI.Tex = Pig_Options.RLUI:CreateTexture(nil, "BORDER");
Pig_Options.RLUI.Tex:SetTexture("interface/helpframe/helpicon-reportabuse.blp");
Pig_Options.RLUI.Tex:SetSize(32,32);
Pig_Options.RLUI.Tex:SetPoint("RIGHT",Pig_Options.RLUI.txt,"LEFT", 0, 0);
Pig_Options.RLUI.Button = PIGButton(Pig_Options.RLUI,{"LEFT",Pig_Options.RLUI.txt,"RIGHT",4,0},{76,25},L["OPTUI_RLUI"])
Pig_Options.RLUI.Button:SetScript("OnClick", function ()
	ReloadUI();
end);
Pig_Options.UpdateTXT=ADDONS..LFG_LIST_APP_TIMED_OUT..", "..string.format(LOCKED_WITH_ITEM,UPDATE).."!!!"
Pig_Options.UpdateVer=Create.PIGFontString(Pig_Options,{"BOTTOM", Pig_Options, "BOTTOM", 80, 12},addonName..Pig_Options.UpdateTXT,"OUTLINE",16);
Pig_Options.UpdateVer:SetTextColor(1, 0, 0, 1);
Pig_Options.UpdateVer:Hide()
Pig_Options.RLUI:HookScript("OnShow", function ()
	Pig_Options.UpdateVer:Hide()
end);
--PIG_OptionsUI.RLUI:Show()
--作者
Pig_Options.lianxizuozhe=PIGFrame(Pig_Options,{"CENTER",Pig_Options,"CENTER",80,20},{320,320})
Pig_Options.lianxizuozhe:PIGSetBackdrop(1)
Pig_Options.lianxizuozhe:PIGClose()
Pig_Options.lianxizuozhe:Hide()
Pig_Options.lianxizuozhe:SetFrameLevel(20)
PIGFontString(Pig_Options.lianxizuozhe,{"TOP", Pig_Options.lianxizuozhe, "TOP", 0, -10},L["ADDON_AUTHOR"])
Pig_Options.lianxizuozhe.wx = Pig_Options.lianxizuozhe:CreateTexture()
Pig_Options.lianxizuozhe.wx:SetTexture("Interface\\AddOns\\"..addonName.."\\Libs\\wx.blp");
Pig_Options.lianxizuozhe.wx:SetSize(240,240);
Pig_Options.lianxizuozhe.wx:SetPoint("CENTER",Pig_Options.lianxizuozhe,"CENTER", 0, 0);
Pig_Options:HookScript("OnHide", function (self)
	self.lianxizuozhe:Hide()
end)
function Pig_Options:ShowAuthor()
	local zuozheF = self.lianxizuozhe
	if zuozheF:IsShown() then
		zuozheF:Hide()
	else
		zuozheF:Show()
	end
end
--PIG屏幕提示信息栏
local infotip = CreateFrame("MessageFrame", nil, UIParent);
infotip:SetSize(512,60);
infotip:SetPoint("TOP",UIParent,"TOP",0,-182);
infotip:SetFrameStrata("DIALOG")
infotip:SetTimeVisible(2)
infotip:SetFadeDuration(0.5)
PIGSetFont(infotip,16,"OUTLINE")
function Pig_Options:ErrorMsg(message, Color)
	local r, g, b
	if Color=="G" then
		r, g, b = 0, 1, 0
	elseif Color=="W" then
		r, g, b=nil,nil,nil
	elseif Color=="R" then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 0
	end	
	infotip:AddMessage(message, r, g, b, 1);
	PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
end
---小地图按钮
local MiniMapBut = CreateFrame("Button","PIG_MiniMapBut",UIParent);
Pig_Options.MiniMapBut=MiniMapBut
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
local function Showaddonstishi(self,laiyuan)
	GameTooltip:ClearLines();
	if laiyuan then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT",-2,16);
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT",-24,0);
	end
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..PIGGetAddOnMetadata(addonName, "Version"))
	if PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then
		GameTooltip:AddLine(L["MAP_NIMIBUT_TIPS2"])
	else
		GameTooltip:AddLine(L["MAP_NIMIBUT_TIPS1"])
	end
	GameTooltip:Show();
end	
MiniMapBut:SetScript("OnEnter", function(self)
	Showaddonstishi(self)
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
			local xpos=xpos or PIGA["Map"]["MinimapPointXY"][1]
			local ypos=ypos or PIGA["Map"]["MinimapPointXY"][2]
			MiniMapBut:SetPoint("CENTER",UIParent,"CENTER",xpos,ypos)
			PIGA["Map"]["MinimapPointXY"][1]=xpos
			PIGA["Map"]["MinimapPointXY"][2]=ypos
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
		MiniMapBut.Snf:ClearAllPoints();
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
		MiniMapBut.Snf:SetPoint(Pointinfo[3]..Pointinfo[1], MiniMapBut, Pointinfo[4]..Pointinfo[2], Pointinfo[5], Pointinfo[6]);
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
local function ClickShowSet()
	if PIG_OptionsUI:IsShown() then	
		PIG_OptionsUI:Hide();
	else
		MiniMapBut.Snf:Hide();
		PIG_OptionsUI:Show();
	end
end
local function addonsClick(button)
	GameTooltip:Hide()
	if button=="RightButton" or PIGA["Map"]["MiniButShouNa_YN"]==2 and button=="LeftButton" then
		ClickShowSet()
	else
		if IsControlKeyDown() then
			PIG_BugcollectUI:Show()
			MiniMapBut.error:Hide();
		elseif IsShiftKeyDown() then
			ReloadUI()
		else
			if PIGA["Map"]["MiniButShouNa_YN"]==1 then
				if PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") and RecycleBinToggleButton then
					ClickShowSet()
				else
					MiniMapBut.Snf.tishi:Hide();
					if MiniMapBut.Snf:IsShown() then	
						MiniMapBut.Snf:Hide();
					else
						PIG_OptionsUI:Hide();
						MiniMapBut.Snf:Show();
						MiniMapBut.Snf.xiaoshidaojishi = 1.5;
						MiniMapBut.Snf.zhengzaixianshi = true;
					end
				end
			else	
				MiniMapBut.Snf.tishi:Show();
				if MiniMapBut.Snf:IsShown() then
					MiniMapBut.Snf:Hide();
				else
					MiniMapBut.Snf:Show();
				end
			end
		end
	end
end
MiniMapBut:SetScript("OnClick", function(event, button)
	PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
	addonsClick(button)
end)
local MiniMapButYD = CreateFrame("Frame", nil);
MiniMapButYD:Hide();
function MiniMapBut.zhucetuodong(ONOFF)
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
	PIGA["Map"]["MinimapPointXY"]=addonTable.Default["Map"]["MinimapPointXY"]
	PIGA["Map"]["MinimapPoint_NDui"]=addonTable.Default["Map"]["MinimapPoint_NDui"]
	PIGA["Map"]["MinimapPoint_ElvUI"]=addonTable.Default["Map"]["MinimapPoint_ElvUI"]
	YDButtonP(PIGA["Map"]["MinimapPointMode"]);
end
local www,hhh = 33,33
function MiniMapBut:ButPoint()
	if PIG_OptionsUI.MiniMapBut.DiyMiniMap then
		PIG_OptionsUI.MiniMapBut:DiyMiniMap()
		return
	end
	if PIG_OptionsUI.IsOpen_ElvUI() then
		local function ElvUIPoint()
			if MinimapPanel and MinimapPanel:IsVisible() then
				MiniMapBut:ClearAllPoints();	
				MiniMapBut:SetPoint("TOPLEFT",MinimapPanel,"TOPLEFT",0.8,-0.6)
				MiniMapBut:SetPoint("BOTTOMLEFT",MinimapPanel,"BOTTOMLEFT",0,0.6)
				local hhhh = MinimapPanel:GetHeight()	
				MiniMapBut:SetWidth(hhhh-1.2);
				MiniMapBut.icon:SetAllPoints(MiniMapBut)
				local wwww = MinimapPanel:GetWidth()	
				local DataTextwww = (wwww-hhhh-2)*0.5
				if MinimapPanel_DataText1 then
					MinimapPanel_DataText1:SetWidth(DataTextwww)
					MinimapPanel_DataText1:SetPoint("LEFT",MinimapPanel,"LEFT",hhhh,0)
					MinimapPanel_DataText2:SetWidth(DataTextwww)
				end
				MiniMapBut.Snf:SetPoint("TOPRIGHT", MiniMapBut, "BOTTOMLEFT", -2, 20);
				MiniMapBut.icon:SetTexCoord(0.1,0.88,0.1,0.9)
				return
			else
				C_Timer.After(0.2,ElvUIPoint)
			end
		end
		C_Timer.After(0.2,ElvUIPoint)
	end
	local mode = PIGA["Map"]["MinimapPointMode"]
	local ButpingXY = {["W"]=www,["H"]=hhh,["iconW"]=www-10,["iconH"]=hhh-10}
	PIGA["Map"]["MinimapPointXY"]=PIGA["Map"]["MinimapPointXY"] or addonTable.Default["Map"]["MinimapPointXY"]
	PIGA["Map"]["MinimapPoint_NDui"]=PIGA["Map"]["MinimapPoint_NDui"] or addonTable.Default["Map"]["MinimapPoint_NDui"]
	PIGA["Map"]["MinimapPoint_ElvUI"]=PIGA["Map"]["MinimapPoint_ElvUI"] or addonTable.Default["Map"]["MinimapPoint_ElvUI"]
	MiniMapBut.Snf:ClearAllPoints();
	MiniMapBut:ClearNormalTexture()
	MiniMapBut:ClearPushedTexture()
	MiniMapBut.zhucetuodong(false)
	if mode == 1 or mode == 3 then
		MiniMapBut.pianyi = 0
		MiniMapBut.zhucetuodong(true)
		if mode == 1 then--小地图
			if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then
				if PIG_OptionsUI.IsOpen_ElvUI() then
					ButpingXY.W,ButpingXY.H=www-14,hhh-14
					ButpingXY.iconW,ButpingXY.iconH=www-14,hhh-14
				elseif PIG_OptionsUI.IsOpen_NDui() then
					ButpingXY.W,ButpingXY.H=www-12,hhh-12
					ButpingXY.iconW,ButpingXY.iconH=www-12,hhh-12
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
		MiniMapBut.Snf:SetPoint("TOPRIGHT", MiniMapBut, "BOTTOMLEFT", -2, 20);
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
		MiniMapBut.Snf:SetPoint("BOTTOMLEFT", MiniMapBut, "TOPRIGHT", 2, 2);
	end
	if PIG_OptionsUI.IsOpen_ElvUI() or PIG_OptionsUI.IsOpen_NDui() and not PIG_OptionsUI.IsOpen_NDui("Map","DisableMinimap") then MiniMapBut.icon:SetTexCoord(0.1,0.88,0.1,0.9) end
	MiniMapBut:SetSize(ButpingXY.W,ButpingXY.H);
	MiniMapBut.icon:SetSize(ButpingXY.iconW,ButpingXY.iconH);	
end
MiniMapBut.Snf = PIGFrame(MiniMapBut,nil,{200, 100});
MiniMapBut.Snf:PIGSetBackdrop()
MiniMapBut.Snf:Hide();
MiniMapBut.Snf:SetFrameLevel(1)
MiniMapBut.Snf.tishi = PIGFontString(MiniMapBut.Snf,nil,L["MAP_NIMIBUT_TIPS3"])
MiniMapBut.Snf.tishi:SetPoint("TOPLEFT", MiniMapBut.Snf, "TOPLEFT", 6, -6);
MiniMapBut.Snf.tishi:SetPoint("BOTTOMRIGHT", MiniMapBut.Snf, "BOTTOMRIGHT", -6, 6);
MiniMapBut.Snf.tishi:Hide();
MiniMapBut.Snf:SetScript("OnUpdate", function(self, ssss)
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
MiniMapBut.Snf:SetScript("OnEnter", function(self)
	self.zhengzaixianshi = nil;
end)
MiniMapBut.Snf:SetScript("OnLeave", function(self)
	self.xiaoshidaojishi = 1.5;
	self.zhengzaixianshi = true;
end)
--正式服系统地图部分插件下拉列表
function PIGCompartmentClick(addonName, buttonName, menuButtonFrame)
    addonsClick(buttonName)
end
function PIGCompartmentEnter(addonName, menuButtonFrame)
	Showaddonstishi(menuButtonFrame,true)	
end
function PIGCompartmentLeave(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end