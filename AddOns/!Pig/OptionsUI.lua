local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
-------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGLine=Create.PIGLine
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont

--系统插件菜单======================
--PIG_SavedVars = {}
local frame = CreateFrame("Frame");
local category, layout = Settings.RegisterCanvasLayoutCategory(frame,addonName)
layout:AddAnchorPoint("TOPLEFT", 10, -10);
layout:AddAnchorPoint("BOTTOMRIGHT", -10, 10);
-- local function OnSettingChanged(setting, value)
-- 	-- This callback will be invoked whenever a setting is modified.
-- 	print("Setting changed:", setting:GetVariable(), value)
-- end

-- do 
-- 	-- RegisterAddOnSetting example. This will read/write the setting directly
-- 	-- to `PIG_SavedVars.toggle`.

--     local name = "Test Checkbox"
--     local variable = "MyAddOn_Toggle"
-- 	local variableKey = "toggle"
-- 	local variableTbl = PIG_SavedVars
--     local defaultValue = false

--     local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
-- 	--setting:SetValueChangedCallback(OnSettingChanged)

--     local tooltip = "This is a tooltip for the checkbox."
-- 	Settings.CreateCheckbox(category, setting, tooltip)
-- end

-- do
-- 	-- RegisterProxySetting example. This will run the GetValue and SetValue
-- 	-- callbacks whenever access to the setting is required.

-- 	local name = "Test Slider"
-- 	local variable = "MyAddOn_Slider"
--     local defaultValue = 180
--     local minValue = 90
--     local maxValue = 360
--     local step = 10

-- 	local function GetValue()
-- 		return PIG_SavedVars.slider or defaultValue
-- 	end

-- 	local function SetValue(value)
-- 		PIG_SavedVars.slider = value
-- 	end

-- 	local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
-- 	setting:SetValueChangedCallback(OnSettingChanged)

-- 	local tooltip = "This is a tooltip for the slider."
--     local options = Settings.CreateSliderOptions(minValue, maxValue, step)
--     options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
--     Settings.CreateSlider(category, setting, options, tooltip)
-- end

Settings.RegisterAddOnCategory(category)

-- local PIG_AddOn = {};
-- PIG_AddOn.panel = CreateFrame( "Frame", "PIG_AddOnPanel", UIParent );
-- PIG_AddOn.panel:Hide()
-- PIG_AddOn.panel.name = "!Pig";
-- InterfaceOptions_AddCategory(PIG_AddOn.panel);
-- --子页
-- -- PIG_AddOn.childpanel = CreateFrame( "Frame", "PIG_AddOnChild", PIG_AddOn.panel);
-- -- PIG_AddOn.childpanel.name = "About";
-- --指定归属父级
-- -- PIG_AddOn.childpanel.parent = PIG_AddOn.panel.name;
-- -- InterfaceOptions_AddCategory(PIG_AddOn.childpanel);
-- --系统设置面板
-- PIG_AddOnPanel.Openshezhi = PIGButton(PIG_AddOnPanel,{"TOPLEFT",PIG_AddOnPanel,"TOPLEFT",20,-20},{80,24},L["OPTUI_SET"])
-- PIG_AddOnPanel.Openshezhi:SetScript("OnClick", function ()
-- 	HideUIPanel(InterfaceOptionsFrame);
-- 	HideUIPanel(SettingsPanel);
-- 	HideUIPanel(GameMenuFrame);
-- 	Pig_OptionsUI:Show();
-- end)
-- PIGLine(PIG_AddOnPanel,"TOP",-60,1,{4,-4})
-- Create.About_Update(PIG_AddOnPanel,-80,"Panel")
-- --子页内容
-- PIGLine(PIG_AddOnPanel,"TOP",-300,1,{4,-4})
-- Create.About_Thanks(PIG_AddOnPanel,-320)
-- -- PIG_AddOnPanel.okay = function (self) SC_ChaChingPanel_Close(); end;
-- -- PIG_AddOnPanel.cancel = function (self) SC_ChaChingPanel_CancelOrLoad();  end;

---------------
local OptionsW,OptionsH,OptionsJG,BottomHHH = 800,600,14,40
local Pig_Options=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{OptionsW,OptionsH},"Pig_OptionsUI",true)
Pig_Options:PIGSetBackdrop()
Pig_Options:SetFrameStrata("HIGH")
--左侧内容
local OptionsLFW =160
Pig_Options.L = CreateFrame("Frame", nil, Pig_Options)
Pig_Options.L:SetWidth(OptionsLFW);
Pig_Options.L:SetPoint("TOPLEFT", Pig_Options, "TOPLEFT", 0, 0)
Pig_Options.L:SetPoint("BOTTOMLEFT", Pig_Options, "BOTTOMLEFT", 0, 0)
Pig_Options.L.top = PIGFrame(Pig_Options.L)
--Pig_Options.L.top:PIGSetBackdrop()
Pig_Options.L.top:SetHeight(50)
Pig_Options.L.top:SetPoint("TOPLEFT", Pig_Options.L, "TOPLEFT", 2, -2)
Pig_Options.L.top:SetPoint("TOPRIGHT", Pig_Options.L, "TOPRIGHT", 0, 0)
Pig_Options.L.top:PIGSetMovable(Pig_Options)
Pig_Options.L.top.title = PIGFontString(Pig_Options.L.top,{"LEFT", Pig_Options.L.top, "LEFT", 13, 6},"!Pig",nil, 36)
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
Pig_Options.L.F.ListTOP:SetPoint("BOTTOMRIGHT", Pig_Options.L.F, "BOTTOMRIGHT", 0, 150)
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
Pig_Options.R.top:PIGSetMovable(Pig_Options)
Pig_Options.R.top:PIGClose(25,25,Pig_Options)
Pig_Options.R.top.Ver = CreateFrame("Frame", nil, Pig_Options.R.top)
Pig_Options.R.top.Ver:SetPoint("TOPLEFT", Pig_Options.R.top, "TOPLEFT", 0, 0)
Pig_Options.R.top.Ver:SetPoint("BOTTOMRIGHT", Pig_Options.R.top, "BOTTOMRIGHT", -30, 0)
function Pig_Options:SetVer()
	local VersionTXT=GetAddOnMetadata(addonName, "Version")
	local VersionID=tonumber(VersionTXT)
	Pig_Options.VersionID=VersionID
	local benjibanbenhaoTXT="|cffFFD700"..GAME_VERSION_LABEL..":|r |cff00FF00"..VersionTXT.."|r"
	PIGFontString(Pig_OptionsUI.R.top.Ver,{"LEFT", Pig_OptionsUI.R.top.Ver, "LEFT", 6, 0},benjibanbenhaoTXT)
end
function Pig_Options:SetVer_EXT(EXTaddname,uifff)
	local VersionTXT=GetAddOnMetadata(EXTaddname, "Version")
	local VersionID=tonumber(VersionTXT)
	uifff.VersionID=VersionID
	local name, title, notes, loadable = GetAddOnInfo(EXTaddname)
	local ziframe = {Pig_OptionsUI.R.top.Ver:GetRegions()}
	local VerTXT = "|cff00FFFF + |r|cffFFD700"..L["PIGaddonList"][EXTaddname]..":|r |cff00FF00"..VersionTXT.."|r"
	Pig_OptionsUI.R.top.Ver.Vert = Create.PIGFontString(Pig_OptionsUI.R.top.Ver,{"LEFT", ziframe[#ziframe], "RIGHT", 0, 0},VerTXT)
end
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
Pig_Options.tishi = CreateFrame("Frame", "Pig_Options_RLtishi_UI", Pig_Options)
Pig_Options.tishi:SetSize(520, 28)
Pig_Options.tishi:SetPoint("BOTTOM", Pig_Options, "BOTTOM", 80, 8)
Pig_Options.tishi:Hide()
Pig_Options.tishi.txt = PIGFontString(Pig_Options.tishi,{"CENTER", Pig_Options.tishi, "CENTER", -20, -2},L["OPTUI_RLUITIPS"],"OUTLINE")
Pig_Options.tishi.txt:SetTextColor(1, 0, 0, 1);
Pig_Options.tishi.Tex = Pig_Options.tishi:CreateTexture(nil, "BORDER");
Pig_Options.tishi.Tex:SetTexture("interface/helpframe/helpicon-reportabuse.blp");
Pig_Options.tishi.Tex:SetSize(32,32);
Pig_Options.tishi.Tex:SetPoint("RIGHT",Pig_Options.tishi.txt,"LEFT", 0, 0);
Pig_Options.tishi.Button = PIGButton(Pig_Options.tishi,{"LEFT",Pig_Options.tishi.txt,"RIGHT",4,0},{76,25},L["OPTUI_RLUI"])
Pig_Options.tishi.Button:SetScript("OnClick", function ()
	ReloadUI();
end);
Pig_Options.UpdateTXT=ADDONS..LFG_LIST_APP_TIMED_OUT..", "..string.format(LOCKED_WITH_ITEM,UPDATE).."!!!"
Pig_Options.UpdateVer=Create.PIGFontString(Pig_Options,{"BOTTOM", Pig_Options, "BOTTOM", 80, 12},addonName..Pig_Options.UpdateTXT,"OUTLINE",16);
Pig_Options.UpdateVer:SetTextColor(1, 0, 0, 1);
Pig_Options.UpdateVer:Hide()
Pig_Options.tishi:HookScript("OnShow", function ()
	Pig_Options.UpdateVer:Hide()
end);
Pig_Options:HookScript("OnShow", function (self)
	if PIGA["Ver"][addonName]>self.VersionID then
		self.UpdateVer:Show()
	end
end);

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
Pig_Options.lianxizuozhe.wx:SetPoint("TOP",Pig_Options.lianxizuozhe,"TOP", 0, -35);
Pig_Options.lianxizuozhe.tishi = PIGFontString(Pig_Options.lianxizuozhe,{"BOTTOM", Pig_Options.lianxizuozhe, "BOTTOM", 0, 12},L["CONFIG_DIYTIPS"])
Pig_Options.lianxizuozhe.tishi:SetTextColor(0, 1, 0.6, 1);
Pig_Options.lianxizuozhe.tishi:SetWidth(310);
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
---小地图按钮
local www,hhh = 33,33
local PigMinimapBut = CreateFrame("Button","PigMinimapBut_UI",UIParent); 
PigMinimapBut:SetSize(www,hhh);
PigMinimapBut:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0);
PigMinimapBut:SetMovable(true)
PigMinimapBut:EnableMouse(true)
PigMinimapBut:RegisterForClicks("LeftButtonUp","RightButtonUp")
PigMinimapBut:RegisterForDrag("LeftButton")
PigMinimapBut:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight");
PigMinimapBut:SetFrameStrata("MEDIUM")
PigMinimapBut:SetFrameLevel(PigMinimapBut:GetFrameLevel()+10);
PigMinimapBut.Border = PigMinimapBut:CreateTexture(nil,"BORDER");
PigMinimapBut.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
PigMinimapBut.Border:SetSize(56,56);
PigMinimapBut.Border:SetPoint("TOPLEFT", 0, 0);
PigMinimapBut.Icon = PigMinimapBut:CreateTexture(nil, "BACKGROUND");
PigMinimapBut.Icon:SetTexture("interface/icons/ability_seal.blp");
if tocversion<100000 then
	PigMinimapBut.Icon:SetSize(www-10,hhh-10);
	PigMinimapBut.Icon:SetPoint("CENTER", 0, 1);
else
	PigMinimapBut.Icon:SetSize(www-11,hhh-11);
	PigMinimapBut.Icon:SetPoint("CENTER", 0.94, -0.4);
end
PigMinimapBut.error = PigMinimapBut:CreateTexture(nil, "BORDER");
PigMinimapBut.error:SetTexture("interface/common/voicechat-muted.blp");
PigMinimapBut.error:SetSize(18,18);
PigMinimapBut.error:SetAlpha(0.7);
PigMinimapBut.error:SetPoint("CENTER", 0, 0);
PigMinimapBut.error:Hide();
local function Showaddonstishi(self,laiyuan)
	GameTooltip:ClearLines();
	if laiyuan then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT",-2,16);
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT",-24,0);
	end
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..GetAddOnMetadata(addonName, "Version"))
	if NDui then
		GameTooltip:AddLine(L["MAP_NIMIBUT_TIPS2"])
	else
		GameTooltip:AddLine(L["MAP_NIMIBUT_TIPS1"])
	end
	GameTooltip:Show();
end	
PigMinimapBut:SetScript("OnEnter", function(self)
	Showaddonstishi(self)
end);
PigMinimapBut:SetScript("OnLeave", function()
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end);
local function YDButtonP(weizhiXY)
	local banjing = PigMinimapBut.banjing
	local pianyi =PigMinimapBut.pianyi
	PigMinimapBut:ClearAllPoints();
	PigMinimapBut:SetPoint("TOPLEFT",Minimap,"TOPLEFT",pianyi-2-(banjing*cos(weizhiXY)),(banjing*sin(weizhiXY))-pianyi)
	PIGA["Map"]["MinimapPos"]=weizhiXY
end
local function YDButtonP_ElvUI(xpos,ypos)
	PigMinimapBut:ClearAllPoints();	
	PigMinimapBut:SetPoint("TOPLEFT",Minimap,"TOPLEFT",xpos,ypos)
	PIGA["Map"]["MinimapPos_ElvUI"]={xpos,ypos}
end
local function YDButtonP_OnUpdate()	
	local banjing = PigMinimapBut.banjing
	local xpos,ypos = GetCursorPosition()
	local UIScale = UIParent:GetScale()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
	if ElvUI then
		local xpos = xpos/UIScale-xmin
		local ypos = ypos/UIScale-ymin
		local MinimapWidth = PigMinimapBut:GetWidth()
		local wwwvvv = -MinimapWidth*0.5+11		
		if xpos<wwwvvv then
			xpos=wwwvvv
		end
		local banjingX = banjing-MinimapWidth*0.5-12
		if xpos>banjingX then
			xpos=banjingX
		end
		local MinimapHeight = PigMinimapBut:GetHeight()
		local hhhvvv = MinimapHeight*0.5+10
		if ypos<hhhvvv then
			ypos=hhhvvv
		end
		local banjingY = banjing-MinimapHeight*0.5+10
		if ypos>banjingY then
			ypos=banjingY
		end
		local ypos = ypos-banjing
		YDButtonP_ElvUI(xpos,ypos)
	else
		local xpos = xmin-xpos/UIScale+banjing
		local ypos = ypos/UIScale-ymin-banjing
		YDButtonP(math.deg(math.atan2(ypos,xpos)))
	end
end
local function addonsClick(button)
	GameTooltip:Hide()
	if button=="LeftButton" then
		if IsControlKeyDown() then
			Bugcollect_UI:Show()
			PigMinimapBut_UI.error:Hide();
		elseif IsShiftKeyDown() then
			ReloadUI()
		else
			if NDui then 
				if Pig_OptionsUI:IsShown() then	
					Pig_OptionsUI:Hide();
				else
					PigMinimapBut.Snf:Hide();
					Pig_OptionsUI:Show();
				end 
			else
				if PIGA["Map"]["MiniButShouNa_YN"]==1 then
					PigMinimapBut.Snf.tishi:Hide();
					if PigMinimapBut.Snf:IsShown() then	
						PigMinimapBut.Snf:Hide();
					else
						Pig_OptionsUI:Hide();
						PigMinimapBut.Snf:Show();
						PigMinimapBut.Snf.xiaoshidaojishi = 1.5;
						PigMinimapBut.Snf.zhengzaixianshi = true;
					end
				else
					PigMinimapBut.Snf.tishi:Show();
					if PigMinimapBut.Snf:IsShown() then
						PigMinimapBut.Snf:Hide();
					else
						PigMinimapBut.Snf:Show();
					end
				end
			end
		end
	else
		if Pig_OptionsUI:IsShown() then	
			Pig_OptionsUI:Hide();
		else
			PigMinimapBut.Snf:Hide();
			Pig_OptionsUI:Show();
		end
	end
end
PigMinimapBut:SetScript("OnClick", function(event, button)
	addonsClick(button)
end)
local PigMinimapButYD = CreateFrame("Frame", nil);
PigMinimapButYD:Hide();
function PigMinimapBut.zhucetuodong()
	PigMinimapButYD:SetScript("OnUpdate",YDButtonP_OnUpdate)
	PigMinimapBut:SetScript("OnDragStart", function(self)
		self:LockHighlight();PigMinimapButYD:Show();
	end)
	PigMinimapBut:SetScript("OnDragStop", function(self)
		self:UnlockHighlight();PigMinimapButYD:Hide();
	end)
end
function PigMinimapBut:Point()
	if ElvUI then
		PigMinimapBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
		PigMinimapBut.Border:Hide()
		PigMinimapBut.Icon:SetTexCoord(0.08,0.92,0.08,0.92)
		local mode = 1
		if mode == 1 then--固定位置
			local function ElvUIPoint()
				if MinimapPanel then
					PigMinimapBut:ClearAllPoints();	
					PigMinimapBut:SetPoint("TOPLEFT",MinimapPanel,"TOPLEFT",0.8,-0.6)
					PigMinimapBut:SetPoint("BOTTOMLEFT",MinimapPanel,"BOTTOMLEFT",0,0.6)
					local hhhh = MinimapPanel:GetHeight()	
					PigMinimapBut:SetWidth(hhhh-1.2);
					PigMinimapBut.Icon:SetAllPoints(PigMinimapBut)
					local wwww = MinimapPanel:GetWidth()	
					local DataTextwww = (wwww-hhhh-2)*0.5
					if MinimapPanel_DataText1 then
						MinimapPanel_DataText1:SetWidth(DataTextwww)
						MinimapPanel_DataText1:SetPoint("LEFT",MinimapPanel,"LEFT",hhhh,0)
						MinimapPanel_DataText2:SetWidth(DataTextwww)
					end
				end
			end
			C_Timer.After(0.1,ElvUIPoint)
			C_Timer.After(1,ElvUIPoint)
		elseif mode == 2 then--拖动模式
			PigMinimapBut.zhucetuodong()
			PigMinimapBut:SetSize(www-10,hhh-10);
			PigMinimapBut.Icon:SetSize(www-10,hhh-10);	
			if tocversion<20000 then
				PIGA["Map"]["MinimapPos_ElvUI"]=PIGA["Map"]["MinimapPos_ElvUI"] or {32.63,-152}
			elseif tocversion<40000 then
				PIGA["Map"]["MinimapPos_ElvUI"]=PIGA["Map"]["MinimapPos_ElvUI"] or {32.63,-197.76}
			else
				PIGA["Map"]["MinimapPos_ElvUI"]=PIGA["Map"]["MinimapPos_ElvUI"] or {32.63,-152}
			end
			local banjing = Minimap:GetWidth()
			PigMinimapBut.banjing=banjing
			YDButtonP_ElvUI(PIGA["Map"]["MinimapPos_ElvUI"][1],PIGA["Map"]["MinimapPos_ElvUI"][2])
		end
	else
		PigMinimapBut.zhucetuodong()
		if tocversion<100000 then
			PigMinimapBut.pianyi = 56
		else
			PigMinimapBut.pianyi = 82
		end
		local banjing = Minimap:GetWidth()*0.5+8
		PigMinimapBut.banjing=banjing
		YDButtonP(PIGA["Map"]["MinimapPos"]);
	end
end
PigMinimapBut.Snf = PIGFrame(PigMinimapBut,{"TOPRIGHT", PigMinimapBut_UI, "BOTTOMLEFT", -2, 25},{200, 100});
PigMinimapBut.Snf:PIGSetBackdrop()
PigMinimapBut.Snf:Hide();
PigMinimapBut.Snf:SetFrameLevel(1)
PigMinimapBut.Snf.tishi = PIGFontString(PigMinimapBut.Snf,nil,L["MAP_NIMIBUT_TIPS3"])
PigMinimapBut.Snf.tishi:SetPoint("TOPLEFT", PigMinimapBut.Snf, "TOPLEFT", 6, -6);
PigMinimapBut.Snf.tishi:SetPoint("BOTTOMRIGHT", PigMinimapBut.Snf, "BOTTOMRIGHT", -6, 6);
PigMinimapBut.Snf.tishi:Hide();
PigMinimapBut.Snf:SetScript("OnUpdate", function(self, ssss)
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
PigMinimapBut.Snf:SetScript("OnEnter", function(self)
	self.zhengzaixianshi = nil;
end)
PigMinimapBut.Snf:SetScript("OnLeave", function(self)
	self.xiaoshidaojishi = 1.5;
	self.zhengzaixianshi = true;
end)
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
--PIG屏幕提示信息栏
local infotip = CreateFrame("MessageFrame", "PIGinfotip", UIParent);
infotip:SetSize(512,60);
infotip:SetPoint("TOP",UIParent,"TOP",0,-182);
infotip:SetFrameStrata("DIALOG")
infotip:SetTimeVisible(2)
infotip:SetFadeDuration(0.5)
PIGSetFont(infotip,16,"OUTLINE")
function infotip:TryDisplayMessage(message, r, g, b)
	local r, g, b = r or 1, g or 1, b or 0
	self:AddMessage(message, r, g, b, 1);
	PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
end
--功能动作条
Pig_Options.qiege=16
local _, _, _, tocversion = GetBuildInfo()
if tocversion<100000 then
	Pig_Options.qiege=10
end
local ActionW = ActionButton1:GetWidth()-Pig_Options.qiege
local QuickBut=PIGFrame(UIParent,nil,{ActionW+14,ActionW},"QuickButUI")
QuickBut:PIGSetMovable()
QuickBut:Hide()
QuickBut.ButList={
	[1]=function() end,--总开关
	[2]=function() end,--战场通报
	[3]=function() end,--饰品管理
	[4]=function() end,--符文管理
	[5]=function() end,--装备管理
	[6]=function() end,--炉石/专业
	[7]=function() end,--职业辅助技能
	[8]=function() end,--角色信息统计
	[9]=function() end,--售卖助手丢弃
	[10]=function() end,--售卖助手开
	[11]=function() end,--售卖助手分
	[12]=function() end,--时空之门
	[13]=function() end,--喊话
	[14]=function() end,
	[15]=function() end,--开团助手
	[16]=function() end,--带本助手
	[17]=function() end,
	[18]=function() end,
	[19]=function() end,--AFK
}
function QuickBut:GengxinWidth()
	if self.nr then
		local nr = self.nr
		local butW = nr:GetHeight()
		local Children1 = {nr:GetChildren()};
		local yincangshunum=0
		for i=1,#Children1 do
			if Children1[i].yincang then
				Children1[i]:SetWidth(0.0001)
				yincangshunum=yincangshunum+1
			else
				Children1[i]:SetWidth(butW-2)
			end
		end
		local geshu1 = #Children1-yincangshunum
		if geshu1>0 then 
			self:Show()
			local NewWidth = butW*geshu1+2
			self:SetWidth(NewWidth+self.yidong:GetWidth())
		end
	end
end
function QuickBut:Add()
	for i=1,19 do
		self.ButList[i]()
	end
	self:GengxinWidth()
end
-- local ButtoSDn = CreateFrame("Button",nil,UIParent, "UIPanelButtonTemplate,SecureActionButtonTemplate");
-- ButtoSDn:SetSize(76,25);
-- ButtoSDn:SetPoint("CENTER",UIParent,"CENTER",4,0);
-- ButtoSDn:SetText("ASDADA");
-- ButtoSDn:SetScript("OnClick", function ()
-- 	-- PIGA["tianfuID_CTM"]={}
-- 	-- PIGA["tianfuID_CTM_ICON"]={}
-- 	InspectUnit("target")
-- 	C_Timer.After(1,kaishiguoqutianfu)
-- end);