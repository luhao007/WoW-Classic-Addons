local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
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
local PIGTabBut=Create.PIGTabBut
local PIGDiyTex=Create.PIGDiyTex
---
local Mapfun={}
addonTable.Mapfun=Mapfun
local fuFrame = PIGOptionsList(L["MAP_TABNAME"],"TOP")
--
local DownY=30
local RTabFrame =Create.PIGOptionsList_RF(fuFrame,DownY)
--
local MiniMapF,MiniMaptabbut =PIGOptionsList_R(RTabFrame,L["MAP_TABNAME1"],70)
MiniMapF:Show()
MiniMaptabbut:Selected()
----------------------
function MiniMapF.PIGChecked()
	MiniMapF.Minimap_but:SetChecked(PIGA["Map"]["MinimapBut"])
	MiniMapF.Minimap_but_BS:SetEnabled(PIGA["Map"]["MinimapBut"])
	MiniMapF.Minimap_but_SN:SetEnabled(PIGA["Map"]["MinimapBut"])
	MiniMapF.Minimap_but_SN.Smeihangshu:SetEnabled(PIGA["Map"]["MinimapBut"])
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then
		MiniMapF.Minimap_but_BS:SetChecked(false)
		MiniMapF.Minimap_but_SN:SetChecked(true)
		MiniMapF.Minimap_but_SN.Smeihangshu:SetEnabled(true)
	elseif PIGA["Map"]["MiniButShouNa_YN"]==2 then
		MiniMapF.Minimap_but_BS:SetChecked(true)
		MiniMapF.Minimap_but_SN:SetChecked(false)
		MiniMapF.Minimap_but_SN.Smeihangshu:SetEnabled(false)
	end
end
MiniMapF.Minimap_but = PIGCheckbutton_R(MiniMapF,{L["MAP_NIMIBUT"],L["MAP_NIMIBUTTIPS"]})
MiniMapF.Minimap_but:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MinimapBut"]=true;
	else
		PIGA["Map"]["MinimapBut"]=false;
	end
	Pig_Options_RLtishi_UI:Show()
	MiniMapF.PIGChecked()
end)
-----------
MiniMapF.Minimap_but_BS = PIGCheckbutton_R(MiniMapF,{L["MAP_NIMIBUT_BS"],L["MAP_NIMIBUT_BSTIPS"]},true)
MiniMapF.Minimap_but_BS:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MiniButShouNa_YN"]=2;
	else
		PIGA["Map"]["MiniButShouNa_YN"]=1;
	end
	Pig_Options_RLtishi_UI:Show()
	MiniMapF.PIGChecked()
end);
--收纳功能
MiniMapF.Minimap_but_SN = PIGCheckbutton_R(MiniMapF,{L["MAP_NIMIBUT_SN"],L["MAP_NIMIBUT_SNTIPS"]},true)
MiniMapF.Minimap_but_SN:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["MiniButShouNa_YN"]=1;
	else
		PIGA["Map"]["MiniButShouNa_YN"]=2;
	end
	Pig_Options_RLtishi_UI:Show()
	MiniMapF.PIGChecked()
end);
--收纳小地图按钮每行数目
MiniMapF.Minimap_but_SN.SmeihangshuTXT = PIGFontString(MiniMapF.Minimap_but_SN,{"TOPLEFT",MiniMapF.Minimap_but_SN,"BOTTOMLEFT",20,-16},L["MAP_NIMIBUT_HANGNUM"])
local meihangshuxiala = {1,10,1}
MiniMapF.Minimap_but_SN.Smeihangshu = PIGSlider(MiniMapF.Minimap_but_SN,{"LEFT", MiniMapF.Minimap_but_SN.SmeihangshuTXT,"RIGHT",4,0},meihangshuxiala)	
MiniMapF.Minimap_but_SN.Smeihangshu.Slider:HookScript("OnValueChanged", function(self, arg1)
	PIGA["Map"]["MiniButShouNa_hang"]=arg1
	MiniMapF.PIGChecked()
end)
--按钮位置
MiniMapF.Minimap_but_Pointbiaoti=PIGFontString(MiniMapF,{"TOPLEFT",MiniMapF,"TOPLEFT",20,-200},"小地图按钮位置:")
local mapPointList = {"附着于小地图","自由模式(可随意拖动)","附着于系统菜单","附着于聊天框","ElvUI_小地图下方"};
MiniMapF.Minimap_but_Point=PIGDownMenu(MiniMapF,{"TOPLEFT",MiniMapF.Minimap_but_Pointbiaoti,"BOTTOMLEFT",30,-6},{180,24})
function MiniMapF.Minimap_but_Point:PIGDownMenu_Update_But()
	if not ElvUI then mapPointList[5]=nil end
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#mapPointList,1 do
	    info.text, info.arg1 = mapPointList[i], i
	    info.checked = i==PIGA["Map"]["MinimapPoint"]
		self:PIGDownMenu_AddButton(info)
	end 
end
function MiniMapF.Minimap_but_Point:PIGDownMenu_SetValue(value,arg1,arg2)
	self:PIGDownMenu_SetText(value)
	PIGA["Map"]["MinimapPoint"]=arg1
	MiniMapF.PIGChecked()
	PIGCloseDropDownMenus()
	PigMinimapBut_UI:Point()
end
MiniMapF.CZinfo = PIGButton(MiniMapF,{"TOPLEFT",MiniMapF.Minimap_but_Point,"BOTTOMLEFT",10,-6},{100,24},"重置位置")
MiniMapF.CZinfo:SetScript("OnClick", function()
	PigMinimapBut_UI:CZMinimapInfo()
end);
--=======================================
MiniMapF.MinimapButF = PIGFrame(MiniMapF)
MiniMapF.MinimapButF:PIGSetBackdrop()
MiniMapF.MinimapButF:SetPoint("TOPLEFT", MiniMapF, "TOPLEFT", 306, -38)
MiniMapF.MinimapButF:SetPoint("BOTTOMRIGHT", MiniMapF, "BOTTOMRIGHT", -6, 6)
MiniMapF.MinimapButF.biaoti=PIGFontString(MiniMapF.MinimapButF,{"BOTTOMLEFT",MiniMapF.MinimapButF,"TOPLEFT",10,10},L["MAP_NIMIBUT_NOSN"])
MiniMapF.MinimapButF.biaoti:SetTextColor(0.7, 1, 0, 1);
--
local zongshuV,butWWHH,hang_NUM  = 150, 25, 10;
local hangshuV = math.ceil(zongshuV/hang_NUM)
MiniMapF.MinimapButF.butlist={}
local function IsNoDIYpaichu(uiname)
	local datax = PIGA["Map"]["MinimapBpaichu"]
	for x=1,#datax do
		if uiname:match(datax[x]) then
			return true;
		end
	end
	return false
end
Mapfun.IsNoDIYpaichu=IsNoDIYpaichu
local function UpdatePaichuButLsit()
	for i=1,#MiniMapF.MinimapButF.butlist do
		local butx = MiniMapF.MinimapButF.butlist[i]
		butx:Hide()
		PIGEnter(butx,"")
	end
	for i=1,#PigMinimapBut_UI.MiniList do
		local butx = MiniMapF.MinimapButF.butlist[i]
		butx:Show()
		butx.uiname=PigMinimapBut_UI.MiniList[i]
		local iconx = _G[PigMinimapBut_UI.MiniList[i]].icon and _G[PigMinimapBut_UI.MiniList[i]].icon:GetTexture() or _G[PigMinimapBut_UI.MiniList[i]].Icon and _G[PigMinimapBut_UI.MiniList[i]].Icon:GetTexture() or 134400
		butx:SetNormalTexture(iconx)
		PIGEnter(butx,butx.uiname)
		if IsNoDIYpaichu(butx.uiname) then
			butx.x:Show()
		else
			butx.x:Hide()
		end
	end
end
for id = 1, zongshuV do
	local but = CreateFrame("Button", nil, MiniMapF.MinimapButF);
	but:SetSize(butWWHH, butWWHH);
	but:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	but:SetNormalTexture(132311)
	MiniMapF.MinimapButF.butlist[id]=but
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
				Pig_Options_RLtishi_UI:Show()
				return
			end
		end
		self.x:Show()
		table.insert(datax,self.uiname)
		Pig_Options_RLtishi_UI:Show()
	end);
end
for hangID=1, hangshuV,1 do
	if hangID==1 then
		for xxxx=1, hangID*hang_NUM, 1 do
			if xxxx==1 then
				MiniMapF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",MiniMapF.MinimapButF, "TOPLEFT", 8, -8)
			else
				MiniMapF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",MiniMapF.MinimapButF, "TOPLEFT", (butWWHH+4)*(xxxx-1)+8, -8)
			end
		end
	else
		for xxxx=(hangID-1)*hang_NUM+1, hangID*hang_NUM, 1 do
			if xxxx-(hangID-1)*hang_NUM==1 then
				MiniMapF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",MiniMapF.MinimapButF, "TOPLEFT", 8, -(butWWHH+4)*(hangID-1)-8)
			else
				if MiniMapF.MinimapButF.butlist[xxxx] then
					MiniMapF.MinimapButF.butlist[xxxx]:SetPoint("TOPLEFT",MiniMapF.MinimapButF, "TOPLEFT", (butWWHH+4)*(xxxx-(hangID-1)*hang_NUM-1)+8, -(butWWHH+4)*(hangID-1)-8)
				end
			end
		end
	end
end
----
MiniMapF:HookScript("OnShow", function (self)
	UpdatePaichuButLsit();
	self.Minimap_but_SN.Smeihangshu:PIGSetValue(PIGA["Map"]["MiniButShouNa_hang"])
	self.Minimap_but_Point:PIGDownMenu_SetText(mapPointList[PIGA["Map"]["MinimapPoint"]])
	MiniMapF.PIGChecked()
end);


--WorldMap================
local WorldMapF =PIGOptionsList_R(RTabFrame,L["MAP_TABNAME2"],90)
--
WorldMapF.WorldMapXY = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDXY"],L["MAP_WORDXYTIPS"]},true)
WorldMapF.WorldMapXY:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Map"]["WorldMapXY"]=true;
		Mapfun.WorldMap_XY()
	else
		PIGA["Map"]["WorldMapXY"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end);
if tocversion<100000 then
	WorldMapF.WorldMapWind = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDWIND"],L["MAP_WORDWINDTIPS"]},true)
	WorldMapF.WorldMapWind:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapWind"]=true;
			Mapfun.WorldMap_Wind()
		else
			PIGA["Map"]["WorldMapWind"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	WorldMapF.WorldMapLV = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDLV"],L["MAP_WORDLVTIPS"]},true)
	WorldMapF.WorldMapLV:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapLV"]=true;
			Mapfun.WorldMap_LVSkill()
		else
			PIGA["Map"]["WorldMapLV"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	WorldMapF.WorldMapSkill = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDSKILL"],L["MAP_WORDSKILLTIPS"]},true)
	WorldMapF.WorldMapSkill:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapSkill"]=true;
			Mapfun.WorldMap_LVSkill()
		else
			PIGA["Map"]["WorldMapSkill"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	WorldMapF.WorldMapMiwu = PIGCheckbutton_R(WorldMapF,{L["MAP_WORDMIWU"],L["MAP_WORDMIWUTIPS"]},true)
	WorldMapF.WorldMapMiwu:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Map"]["WorldMapMiwu"]=true;
			Mapfun.WorldMap_Miwu()
		else
			PIGA["Map"]["WorldMapMiwu"]=false;
			Pig_Options_RLtishi_UI:Show()
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
	if tocversion<100000 then
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
	Mapfun.WorldMap_XY()
	if tocversion<100000 then
		Mapfun.WorldMap_Wind()
		Mapfun.WorldMap_LVSkill()
		Mapfun.WorldMap_Miwu()
	end
end