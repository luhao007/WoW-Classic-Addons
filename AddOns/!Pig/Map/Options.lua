local addonName, addonTable = ...;
local L=addonTable.locale
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
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
local PIGTabBut=Create.PIGTabBut
local PIGDiyTex=Create.PIGDiyTex
---
local Mapfun={}
addonTable.Mapfun=Mapfun
local fuFrame = PIGOptionsList(L["MAP_TABNAME"],"TOP")
--
local RTabFrame =Create.PIGOptionsList_RF(fuFrame)
--
local GeneralF,Generaltabbut =PIGOptionsList_R(RTabFrame,GENERAL,70)
GeneralF:Show()
Generaltabbut:Selected()
function GeneralF.PIGChecked()
	GeneralF.Minimap_but:SetChecked(PIGA["Map"]["MinimapBut"])
	GeneralF.Minimap_but_BS:SetEnabled(PIGA["Map"]["MinimapBut"])
	GeneralF.Minimap_but_SN:SetEnabled(PIGA["Map"]["MinimapBut"])
	GeneralF.Minimap_but_SN.Smeihangshu:SetEnabled(PIGA["Map"]["MinimapBut"])
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then
		GeneralF.Minimap_but_BS:SetChecked(false)
		GeneralF.Minimap_but_SN:SetChecked(true)
		GeneralF.Minimap_but_SN.Smeihangshu:SetEnabled(true)
	elseif PIGA["Map"]["MiniButShouNa_YN"]==2 then
		GeneralF.Minimap_but_BS:SetChecked(true)
		GeneralF.Minimap_but_SN:SetChecked(false)
		GeneralF.Minimap_but_SN.Smeihangshu:SetEnabled(false)
	end
end
GeneralF.Minimap_but = PIGCheckbutton_R(GeneralF,{L["MAP_NIMIBUT"],L["MAP_NIMIBUTTIPS"]},true)
GeneralF.Minimap_but:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MinimapBut"]=true;
	else
		PIGA["Map"]["MinimapBut"]=false;
	end
	PIG_OptionsUI.RLUI:Show()
	GeneralF.PIGChecked()
end)
-----------
GeneralF.Minimap_but_BS = PIGCheckbutton_R(GeneralF,{L["MAP_NIMIBUT_BS"],L["MAP_NIMIBUT_BSTIPS"]},true)
GeneralF.Minimap_but_BS:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MiniButShouNa_YN"]=2;
	else
		PIGA["Map"]["MiniButShouNa_YN"]=1;
	end
	PIG_OptionsUI.RLUI:Show()
	GeneralF.PIGChecked()
end);
--收纳功能
GeneralF.Minimap_but_SN = PIGCheckbutton_R(GeneralF,{L["MAP_NIMIBUT_SN"],L["MAP_NIMIBUT_SNTIPS"]},true)
GeneralF.Minimap_but_SN:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MiniButShouNa_YN"]=1;
	else
		PIGA["Map"]["MiniButShouNa_YN"]=2;
	end
	PIG_OptionsUI.RLUI:Show()
	GeneralF.PIGChecked()
end);
--收纳小地图按钮每行数目
GeneralF.Minimap_but_SN.SmeihangshuTXT = PIGFontString(GeneralF.Minimap_but_SN,{"TOPLEFT",GeneralF.Minimap_but_SN,"BOTTOMLEFT",20,-16},L["MAP_NIMIBUT_HANGNUM"])
local meihangshuxiala = {1,10,1}
GeneralF.Minimap_but_SN.Smeihangshu = PIGSlider(GeneralF.Minimap_but_SN,{"LEFT", GeneralF.Minimap_but_SN.SmeihangshuTXT,"RIGHT",4,0},meihangshuxiala)	
GeneralF.Minimap_but_SN.Smeihangshu.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Map"]["MiniButShouNa_hang"]=arg1
	addonTable.CollectMiniMapBut()
end)
--按钮位置
GeneralF.Minimap_but_Pointbiaoti=PIGFontString(GeneralF,{"TOPLEFT",GeneralF,"TOPLEFT",20,-200},"小地图按钮位置:")
local mapPointList = {"附着于小地图","附着于聊天框","自由模式(可随意拖动)"};
GeneralF.Minimap_but_Point=PIGDownMenu(GeneralF,{"TOPLEFT",GeneralF.Minimap_but_Pointbiaoti,"BOTTOMLEFT",20,-6},{250})
function GeneralF.Minimap_but_Point:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#mapPointList,1 do
	    info.text, info.arg1 = mapPointList[i], i
	    info.checked = i==PIGA["Map"]["MinimapPointMode"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function GeneralF.Minimap_but_Point:PIGDownMenu_SetValue(value,arg1,arg2)
	self:PIGDownMenu_SetText(value)
	PIGA["Map"]["MinimapPointMode"]=arg1
	GeneralF.PIGChecked()
	addonTable.UpdateMiniButPoint()
	PIGCloseDropDownMenus()
end
GeneralF.CZinfo = PIGButton(GeneralF,{"TOPLEFT",GeneralF.Minimap_but_Point,"BOTTOMLEFT",10,-6},{100,24},"重置位置")
GeneralF.CZinfo:SetScript("OnClick", function()
	Mapfun.MiniMapBut:CZMinimapInfo()
end);
--=======================================
GeneralF.MinimapButF = PIGFrame(GeneralF)
GeneralF.MinimapButF:PIGSetBackdrop()
GeneralF.MinimapButF:SetPoint("TOPLEFT", GeneralF, "TOPLEFT", 306, -38)
GeneralF.MinimapButF:SetPoint("BOTTOMRIGHT", GeneralF, "BOTTOMRIGHT", -6, 6)
GeneralF.MinimapButF.biaoti=PIGFontString(GeneralF.MinimapButF,{"BOTTOMLEFT",GeneralF.MinimapButF,"TOPLEFT",10,10},L["MAP_NIMIBUT_NOSN"])
GeneralF.MinimapButF.biaoti:SetTextColor(0.7, 1, 0, 1);
--
GeneralF.MinimapButF.butlist={}
local zongshuV,butWWHH,hang_NUM  = 150, 25, 10;
local hangshuV = math.ceil(zongshuV/hang_NUM)
local function UpdatePaichuButLsit()
	for i=1,#GeneralF.MinimapButF.butlist do
		local butx = GeneralF.MinimapButF.butlist[i]
		butx:Hide()
		PIGEnter(butx,"")
	end
	for i=1,#Mapfun.MiniBoxList do
		local butx = GeneralF.MinimapButF.butlist[i]
		butx:Show()
		butx.uiname=Mapfun.MiniBoxList[i]
		local iconx = _G[Mapfun.MiniBoxList[i]].icon and _G[Mapfun.MiniBoxList[i]].icon:GetTexture() or _G[Mapfun.MiniBoxList[i]].Icon and _G[Mapfun.MiniBoxList[i]].Icon:GetTexture() or 134400
		butx:SetNormalTexture(iconx)
		PIGEnter(butx,butx.uiname)
		if Mapfun.IsNoDIYExclude(butx.uiname) then
			butx.x:Show()
		else
			butx.x:Hide()
		end
	end
end
for id = 1, zongshuV do
	local but = CreateFrame("Button", nil, GeneralF.MinimapButF);
	but:SetSize(butWWHH, butWWHH);
	but:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	but:SetNormalTexture(132311)
	GeneralF.MinimapButF.butlist[id]=but
	but.Down = but:CreateTexture(nil, "OVERLAY");
	but.Down:SetTexture(130839);
	but.Down:SetAllPoints(but)
	but.Down:Hide();
	but:SetScript("OnMouseDown", function (self)
		self.Down:Show();
	end);
	but:SetScript("OnMouseUp", function (self)
		self.Down:Hide();
	end);
	but.x=PIGDiyTex(but,{"BOTTOMRIGHT",but, "BOTTOMRIGHT", 0, 0},{16})
	but.x:SetAlpha(0.9)
	but:SetScript("OnClick", function (self)
		local datax = PIGA["Map"]["MinimapBpaichu"]
		for i=#datax,1,-1 do
			if datax[i]==self.uiname then
				self.x:Hide()
				table.remove(datax,i)
				PIG_OptionsUI.RLUI:Show()
				return
			end
		end
		self.x:Show()
		table.insert(datax,self.uiname)
		PIG_OptionsUI.RLUI:Show()
	end);
end
for hangID=1, hangshuV,1 do
	if hangID==1 then
		for xxxx=1, hangID*hang_NUM, 1 do
			if xxxx==1 then
				GeneralF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",GeneralF.MinimapButF, "TOPLEFT", 8, -8)
			else
				GeneralF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",GeneralF.MinimapButF, "TOPLEFT", (butWWHH+4)*(xxxx-1)+8, -8)
			end
		end
	else
		for xxxx=(hangID-1)*hang_NUM+1, hangID*hang_NUM, 1 do
			if xxxx-(hangID-1)*hang_NUM==1 then
				GeneralF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",GeneralF.MinimapButF, "TOPLEFT", 8, -(butWWHH+4)*(hangID-1)-8)
			else
				if GeneralF.MinimapButF.butlist[xxxx] then
					GeneralF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",GeneralF.MinimapButF, "TOPLEFT", (butWWHH+4)*(xxxx-(hangID-1)*hang_NUM-1)+8, -(butWWHH+4)*(hangID-1)-8)
				end
			end
		end
	end
end
----
GeneralF:HookScript("OnShow", function (self)
	UpdatePaichuButLsit();
	self.Minimap_but_SN.Smeihangshu:PIGSetValue(PIGA["Map"]["MiniButShouNa_hang"])
	if Mapfun.MiniMapBut.DiyMiniMapFun then
		self.Minimap_but_Point:Disable();
		self.CZinfo:Disable();
		self.Minimap_but_Point:PIGDownMenu_SetText("被外部插件"..Mapfun.MiniMapBut.EXaddonName.."控制")
	elseif PIG_OptionsUI.IsOpen_ElvUI() then
		self.Minimap_but_Point:Disable();
		self.CZinfo:Disable();
		self.Minimap_but_Point:PIGDownMenu_SetText("ElvUI模式")
	else
		self.Minimap_but_Point:PIGDownMenu_SetText(mapPointList[PIGA["Map"]["MinimapPointMode"]])
	end
	self.PIGChecked()
end);

---minimap
local MiniMapF,MiniMaptabbut =PIGOptionsList_R(RTabFrame,L["MAP_TABNAME1"],70)
MiniMapF.MinimapXY = PIGCheckbutton_R(MiniMapF,{L["MAP_WORDXY"],L["MAP_WORDXYTIPS"]},true)
MiniMapF.MinimapXY:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MinimapXY"]=true;
	else
		PIGA["Map"]["MinimapXY"]=false;
	end
	Mapfun.Minimap_XY()
end);
MiniMapF.MinimapHide = PIGCheckbutton_R(MiniMapF,{HIDE..MINIMAP_LABEL},true)
MiniMapF.MinimapHide:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MinimapHide"]=true;
	else
		PIGA["Map"]["MinimapHide"]=false;
	end
	PIG_OptionsUI.RLUI:Show()
end);
MiniMapF.MinimapMove = PIGCheckbutton_R(MiniMapF,{NPE_MOVE..MINIMAP_LABEL},true)
MiniMapF.MinimapMove:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MinimapMove"]=true;
		Mapfun.Minimap_Move()
	else
		PIGA["Map"]["MinimapMove"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
	MiniMapF:Update_Checked()
end);
MiniMapF.AnchorPointT = PIGFontString(MiniMapF,{"LEFT", MiniMapF.MinimapMove.Text, "RIGHT", 4, 0},"定位锚点")
MiniMapF.AnchorPoint=PIGDownMenu(MiniMapF,{"LEFT", MiniMapF.AnchorPointT, "RIGHT", 4, 0},{120,nil})
local xyList = {"TOP","BOTTOM","TOPLEFT","TOPRIGHT","BOTTOMLEFT","BOTTOMRIGHT"}
local xyListName = {["TOP"]="顶部",["BOTTOM"]="底部",["TOPLEFT"]="左上角",["TOPRIGHT"]="右上角",["BOTTOMLEFT"]="左下角",["BOTTOMRIGHT"]="右下角"}
function MiniMapF.AnchorPoint:PIGDownMenu_Update_But()
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#xyList do
	 	info.text, info.arg1 = xyListName[xyList[i]], xyList[i]
	 	info.checked = xyList[i] == PIGA["Map"]["MinimapAnchor"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function MiniMapF.AnchorPoint:PIGDownMenu_SetValue(value,arg1)
	self:PIGDownMenu_SetText(value)
	PIGA["Map"]["MinimapAnchor"]=arg1
	PIGA["Map"]["MinimapPointX"]=0
	PIGA["Map"]["MinimapPointY"]=0
	MiniMapF:Update_Checked()
	Mapfun.Minimap_MoveUpdate()
	PIGCloseDropDownMenus()
end
MiniMapF.AnchorPointXT = PIGFontString(MiniMapF,{"TOPLEFT", MiniMapF.MinimapMove.Text, "BOTTOMLEFT", 10, -22},"定位坐标X")
MiniMapF.AnchorPointX = PIGSlider(MiniMapF,{"LEFT", MiniMapF.AnchorPointXT, "LEFT", 100, 0},{-800, 800, 1},300)
MiniMapF.AnchorPointX.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Map"]["MinimapPointX"]=arg1;
	Mapfun.Minimap_MoveUpdate()
end)
MiniMapF.AnchorPointYT = PIGFontString(MiniMapF,{"TOPLEFT", MiniMapF.AnchorPointXT, "BOTTOMLEFT", 0, -22},"定位坐标Y")
MiniMapF.AnchorPointY = PIGSlider(MiniMapF,{"LEFT", MiniMapF.AnchorPointYT, "LEFT", 100, 0},{-600, 600, 1},300)
MiniMapF.AnchorPointY.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Map"]["MinimapPointY"]=arg1;
	Mapfun.Minimap_MoveUpdate()
end)
----
function MiniMapF:Update_Checked()
	self.AnchorPoint:SetEnabled(PIGA["Map"]["MinimapMove"] and not PIGA["Map"]["MinimapHide"])
	self.AnchorPointX:SetEnabled(PIGA["Map"]["MinimapMove"] and not PIGA["Map"]["MinimapHide"])
	self.AnchorPointY:SetEnabled(PIGA["Map"]["MinimapMove"] and not PIGA["Map"]["MinimapHide"])
	self.AnchorPoint:PIGDownMenu_SetText(xyListName[PIGA["Map"]["MinimapAnchor"]])
	self.AnchorPointX:PIGSetValue(PIGA["Map"]["MinimapPointX"])
	self.AnchorPointY:PIGSetValue(PIGA["Map"]["MinimapPointY"])
end
MiniMapF:HookScript("OnShow", function (self)
	self.MinimapXY:SetChecked(PIGA["Map"]["MinimapXY"])
	self.MinimapHide:SetChecked(PIGA["Map"]["MinimapHide"])
	self.MinimapMove:SetChecked(PIGA["Map"]["MinimapMove"])
	self.MinimapMove:SetEnabled(not PIGA["Map"]["MinimapHide"])
	MiniMapF:Update_Checked()
end);

--WorldMap================
local WorldMapF =PIGOptionsList_R(RTabFrame,L["MAP_TABNAME2"],90)
WorldMapF.WorldMapXY = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDXY"],L["MAP_WORDXYTIPS"]},true)
WorldMapF.WorldMapXY:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["WorldMapXY"]=true;
		Mapfun.WorldMap_XY()
	else
		PIGA["Map"]["WorldMapXY"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end);
if PIG_MaxTocversion() then
	WorldMapF.WorldMapWind = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDWIND"],L["MAP_WORDWINDTIPS"]},true)
	WorldMapF.WorldMapWind:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapWind"]=true;
			Mapfun.WorldMap_Wind()
		else
			PIGA["Map"]["WorldMapWind"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	WorldMapF.WorldMapLV = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDLV"],L["MAP_WORDLVTIPS"]},true)
	WorldMapF.WorldMapLV:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapLV"]=true;
			Mapfun.WorldMap_LVSkill()
		else
			PIGA["Map"]["WorldMapLV"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	WorldMapF.WorldMapSkill = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDSKILL"],L["MAP_WORDSKILLTIPS"]},true)
	WorldMapF.WorldMapSkill:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapSkill"]=true;
			Mapfun.WorldMap_LVSkill()
		else
			PIGA["Map"]["WorldMapSkill"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	WorldMapF.WorldMapMiwu = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDMIWU"],L["MAP_WORDMIWUTIPS"]},true)
	WorldMapF.WorldMapMiwu:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapMiwu"]=true;
			Mapfun.WorldMap_Miwu()
		else
			PIGA["Map"]["WorldMapMiwu"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	WorldMapF.WorldMapMiwu.Color = Create.ColorBut(WorldMapF.WorldMapMiwu,{"LEFT",WorldMapF.WorldMapMiwu.Text,"RIGHT",10,0},{18,18})
	WorldMapF.WorldMapMiwu.Color.morenColor={0, 1, 0.1, 0.8}
	function WorldMapF.WorldMapMiwu.Color:PIGinitialize()
		self.pezhiV=PIGA["Map"]["WorldMapMiwuColor"]
	end
	function WorldMapF.WorldMapMiwu.Color:PIGSetValue(newR, newG, newB, newA)
		PIGA["Map"]["WorldMapMiwuColor"]={newR, newG, newB, newA}
		Mapfun.SetmiwuColor({newR, newG, newB, newA})
	end
	Mapfun.WorldMapMiwumorenColor=WorldMapF.WorldMapMiwu.Color.morenColor
end
WorldMapF:HookScript("OnShow", function (self)
	WorldMapF.WorldMapXY:SetChecked(PIGA["Map"]["WorldMapXY"])
	if PIG_MaxTocversion() then
		WorldMapF.WorldMapWind:SetChecked(PIGA["Map"]["WorldMapWind"])
		WorldMapF.WorldMapLV:SetChecked(PIGA["Map"]["WorldMapLV"])
		WorldMapF.WorldMapSkill:SetChecked(PIGA["Map"]["WorldMapSkill"])
		WorldMapF.WorldMapMiwu:SetChecked(PIGA["Map"]["WorldMapMiwu"])
		local miyumorenColor=PIGA["Map"]["WorldMapMiwuColor"] or WorldMapF.WorldMapMiwu.Color.morenColor
		WorldMapF.WorldMapMiwu.Color:ShowButColor(unpack(miyumorenColor))
	end
end);
--==================================
addonTable.Map = function()
	Mapfun.Minimap_Hide()
	Mapfun.Minimap_XY()
	Mapfun.Minimap_Move()
	Mapfun.WorldMap_XY()
	if PIG_MaxTocversion() then
		Mapfun.WorldMap_Wind()
		Mapfun.WorldMap_LVSkill()
		Mapfun.WorldMap_Miwu()
	end
	if Mapfun.MiniMapBut.DiyMiniMapFun then Mapfun.MiniMapBut.DiyMiniMapFun(Mapfun.MiniMapBut) end
end