local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
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
	if PIGA["Map"]["MinimapBut"] then
		MiniMapF.Minimap_but_SN:Enable();
		MiniMapF.Minimap_but_BS:Enable();
	else
		MiniMapF.Minimap_but_SN:Disable();
		MiniMapF.Minimap_but_BS:Disable();
	end
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then
		MiniMapF.Minimap_but_SN:SetChecked(true)
		MiniMapF.Minimap_but_BS:SetChecked(false)
	elseif PIGA["Map"]["MiniButShouNa_YN"]==2 then
		MiniMapF.Minimap_but_BS:SetChecked(true)
		MiniMapF.Minimap_but_SN:SetChecked(false)
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
local meihangshuxiala = {1,2,3,4,5,6,7,8,9,10};
MiniMapF.Minimap_but_SN.Smeihangshu=PIGDownMenu(MiniMapF.Minimap_but_SN,{"TOPLEFT",MiniMapF.Minimap_but_SN,"BOTTOMLEFT",30,-6},{150,24})
function MiniMapF.Minimap_but_SN.Smeihangshu:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#meihangshuxiala,1 do
	    info.text, info.arg1 = meihangshuxiala[i].."个", meihangshuxiala[i]
	    info.checked = meihangshuxiala[i]==PIGA["Map"]["MiniButShouNa_hang"]
		MiniMapF.Minimap_but_SN.Smeihangshu:PIGDownMenu_AddButton(info)
	end 
end
function MiniMapF.Minimap_but_SN.Smeihangshu:PIGDownMenu_SetValue(value,arg1,arg2)
	MiniMapF.Minimap_but_SN.Smeihangshu:PIGDownMenu_SetText(L["MAP_NIMIBUT_HANGNUM"]..value)
	PIGA["Map"]["MiniButShouNa_hang"]=arg1
	MiniMapF.PIGChecked()
	PIGCloseDropDownMenus()
end
--按钮位置
MiniMapF.Minimap_but_Pointbiaoti=PIGFontString(MiniMapF,{"TOPLEFT",MiniMapF,"TOPLEFT",20,-200},"小地图按钮位置:")
local mapPointList = {"附着于小地图","自由模式(可随意拖动)","附着于系统菜单","附着于聊天框","ElvUI_小地图下方"};
MiniMapF.Minimap_but_Point=PIGDownMenu(MiniMapF,{"TOPLEFT",MiniMapF.Minimap_but_Pointbiaoti,"BOTTOMLEFT",30,-6},{180,24})
function MiniMapF.Minimap_but_Point:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#mapPointList,1 do
	    info.text, info.arg1 = mapPointList[i], i
	    info.checked = i==PIGA["Map"]["MinimapPoint"]
		MiniMapF.Minimap_but_Point:PIGDownMenu_AddButton(info)
	end 
end
function MiniMapF.Minimap_but_Point:PIGDownMenu_SetValue(value,arg1,arg2)
	MiniMapF.Minimap_but_Point:PIGDownMenu_SetText(value)
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
-----------
MiniMapF.MinimapButF.biaoti=PIGFontString(MiniMapF.MinimapButF,{"BOTTOMLEFT",MiniMapF.MinimapButF,"TOPLEFT",10,10},L["MAP_NIMIBUT_NOSN"])
MiniMapF.MinimapButF.biaoti:SetTextColor(0.7, 1, 0, 1);
-----
local hang_Height,hang_NUM  = 23, 18;
local Width = MiniMapF.MinimapButF:GetWidth();
local function gengxinMiniPaichu(self)
	for id = 1, hang_NUM do
		_G["MiniMapbuf_SN"..id]:Hide()
    end
	local data = PIGA["Map"]["MinimapBpaichu"]
	FauxScrollFrame_Update(self, #data, hang_NUM, hang_Height);
	local offset = FauxScrollFrame_GetOffset(self);
    for id = 1, hang_NUM do
    	local dangqian = id+offset;
    	if data[dangqian] then
			_G["MiniMapbuf_SN"..id]:Show();
			_G["MiniMapbuf_SN"..id].del:SetID(dangqian);
			_G["MiniMapbuf_SN"..id].name:SetText(data[dangqian]);
		end
	end
end
MiniMapF.MinimapButF.Scroll = CreateFrame("ScrollFrame",nil,MiniMapF.MinimapButF, "FauxScrollFrameTemplate");  
MiniMapF.MinimapButF.Scroll:SetPoint("TOPLEFT",MiniMapF.MinimapButF,"TOPLEFT",0,-2);
MiniMapF.MinimapButF.Scroll:SetPoint("BOTTOMRIGHT",MiniMapF.MinimapButF,"BOTTOMRIGHT",-27,2);
MiniMapF.MinimapButF.Scroll:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxinMiniPaichu)
end)
for id = 1, hang_NUM do
	local hang = CreateFrame("Frame", "MiniMapbuf_SN"..id, MiniMapF.MinimapButF);
	hang:SetSize(Width-27, hang_Height);
	if id==1 then
		hang:SetPoint("TOP",MiniMapF.MinimapButF.Scroll,"TOP",0,0);
	else
		hang:SetPoint("TOP",_G["MiniMapbuf_SN"..(id-1)],"BOTTOM",0,0);
	end
	if id~=hang_NUM then
		PIGLine(hang,"BOT",nil,nil,{-1,0})
	end
	hang.del = CreateFrame("Button",nil, hang, "TruncatedButtonTemplate");
	hang.del:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp")
	hang.del:SetSize(hang_Height,hang_Height-2);
	hang.del:SetPoint("LEFT", hang, "LEFT", 4,0);
	hang.del.Tex = hang.del:CreateTexture();
	hang.del.Tex:SetTexture("interface/common/voicechat-muted.blp");
	hang.del.Tex:SetPoint("CENTER");
	hang.del.Tex:SetSize(13,13);
	hang.del:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",1.5,-1.5);
	end);
	hang.del:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER");
	end);
	hang.del:SetScript("OnClick", function (self)
		MinimapADDFrameUI:Hide();
		MiniMapF.MinimapButF.DELF.hangID=self:GetID()
		MiniMapF.MinimapButF.DELF:Show();
	end);
	hang.name=PIGFontString(hang,{"LEFT", hang.del, "RIGHT", 4,0})
end
MiniMapF.MinimapButF.DELF = PIGFrame(MiniMapF.MinimapButF,{"TOP",MiniMapF.MinimapButF,"TOP",0,-20},{270,120},"MiniMapbuf_SN_DEL",true)
MiniMapF.MinimapButF.DELF:PIGSetBackdrop(1)
MiniMapF.MinimapButF.DELF:PIGClose()
MiniMapF.MinimapButF.DELF:SetFrameLevel(MiniMapF.MinimapButF:GetFrameLevel()+10);
MiniMapF.MinimapButF.DELF:Hide();
MiniMapF.MinimapButF.DELF.text1=PIGFontString(MiniMapF.MinimapButF.DELF,{"TOP", MiniMapF.MinimapButF.DELF, "TOP", 0,-28},L["MAP_NIMIBUT_DELTIPS"])
MiniMapF.MinimapButF.DELF.YES = PIGButton(MiniMapF.MinimapButF.DELF,{"TOP",MiniMapF.MinimapButF.DELF,"TOP",-50,-70},{60,24},OKAY)
MiniMapF.MinimapButF.DELF.YES:SetScript("OnClick", function ()
	table.remove(PIGA["Map"]["MinimapBpaichu"], MiniMapF.MinimapButF.DELF.hangID);
	gengxinMiniPaichu(MiniMapF.MinimapButF.Scroll);
	MiniMapF.MinimapButF.DELF:Hide();
end);
MiniMapF.MinimapButF.DELF.NO = PIGButton(MiniMapF.MinimapButF.DELF,{"TOP",MiniMapF.MinimapButF.DELF,"TOP",50,-70},{60,24},CANCEL)
MiniMapF.MinimapButF.DELF.NO:SetScript("OnClick", function ()
	MiniMapF.MinimapButF.DELF:Hide();
end);
---ADD
MiniMapF.MinimapButF.ADD = PIGButton(MiniMapF,{"LEFT",MiniMapF.MinimapButF.biaoti,"RIGHT",10,1},{30,18},"+")
MiniMapF.MinimapButF.ADD:SetScript("OnClick", function ()
	MiniMapF.MinimapButF.DELF:Hide();
	if MinimapADDFrameUI:IsShown() then
		MinimapADDFrameUI:Hide();
	else
		MinimapADDFrameUI:Show();
	end
end);
MiniMapF.MinimapButF.ADDFrame = PIGFrame(MiniMapF.MinimapButF,{"TOP",MiniMapF.MinimapButF,"TOP",0,-20},{270,160},"MinimapADDFrameUI",true)
MiniMapF.MinimapButF.ADDFrame:PIGSetBackdrop(1)
MiniMapF.MinimapButF.ADDFrame:PIGClose()
MiniMapF.MinimapButF.ADDFrame:SetFrameLevel(MiniMapF.MinimapButF:GetFrameLevel()+10);
MiniMapF.MinimapButF.ADDFrame:Hide();
MiniMapF.MinimapButF.ADDFrame.text1 = PIGFontString(MiniMapF.MinimapButF.ADDFrame,{"TOP", MiniMapF.MinimapButF.ADDFrame, "TOP", 0,-14},L["MAP_NIMIBUT_ADDTIPS"])
----
MiniMapF.MinimapButF.ADDFrame.E = CreateFrame('EditBox', nil, MiniMapF.MinimapButF.ADDFrame, "InputBoxInstructionsTemplate");
MiniMapF.MinimapButF.ADDFrame.E:SetSize(220,hang_Height);
MiniMapF.MinimapButF.ADDFrame.E:SetPoint("TOP",MiniMapF.MinimapButF.ADDFrame,"TOP",0,-62);
MiniMapF.MinimapButF.ADDFrame.E:SetFontObject(ChatFontNormal);
MiniMapF.MinimapButF.ADDFrame.E:SetMaxLetters(50)
MiniMapF.MinimapButF.ADDFrame.E:SetScript("OnEscapePressed", function(self) 
	self:ClearFocus() 
	MiniMapF.MinimapButF.ADDFrame:Hide();
end);
MiniMapF.MinimapButF.ADDFrame.E:SetScript("OnHide", function(self)
	self:SetText("")
	MiniMapF.MinimapButF.ADDFrame.err:SetText("");
end);
MiniMapF.MinimapButF.ADDFrame.err=PIGFontString(MiniMapF.MinimapButF.DELF,{"TOP",MiniMapF.MinimapButF.ADDFrame,"TOP",0,-94})
MiniMapF.MinimapButF.ADDFrame.err:SetTextColor(1, 0, 0, 1);
------
MiniMapF.MinimapButF.ADDFrame.YES = PIGButton(MiniMapF.MinimapButF.ADDFrame,{"TOP",MiniMapF.MinimapButF.ADDFrame,"TOP",-50,-116},{60,24},L["MAP_NIMIBUT_ADD"])
MiniMapF.MinimapButF.ADDFrame.YES:SetScript("OnClick", function ()
	local delIDHAPxx=MiniMapF.MinimapButF.ADDFrame.E:GetText();
	if delIDHAPxx=="" or delIDHAPxx==" " then
		MiniMapF.MinimapButF.ADDFrame.err:SetText(L["MAP_NIMIBUT_ADDERR1"]);	
	else
		for h=1,#PIGA["Map"]["MinimapBpaichu"] do
			if delIDHAPxx==PIGA["Map"]["MinimapBpaichu"][h] then
				MiniMapF.MinimapButF.ADDFrame.err:SetText(L["MAP_NIMIBUT_ADDERR2"]);
				return
			end
		end
		table.insert(PIGA["Map"]["MinimapBpaichu"], delIDHAPxx);
		gengxinMiniPaichu(MiniMapF.MinimapButF.Scroll);
		MiniMapF.MinimapButF.ADDFrame:Hide();
	end
end);
MiniMapF.MinimapButF.ADDFrame.NO = PIGButton(MiniMapF.MinimapButF.ADDFrame,{"TOP",MiniMapF.MinimapButF.ADDFrame,"TOP",50,-116},{60,24},CANCEL)
MiniMapF.MinimapButF.ADDFrame.NO:SetScript("OnClick", function ()
	MiniMapF.MinimapButF.ADDFrame:Hide();
end);
----
MiniMapF:HookScript("OnShow", function (self)
	gengxinMiniPaichu(MiniMapF.MinimapButF.Scroll);
	self.Minimap_but_SN.Smeihangshu:PIGDownMenu_SetText(L["MAP_NIMIBUT_HANGNUM"]..PIGA["Map"]["MiniButShouNa_hang"].."个")
	self.Minimap_but_Point:PIGDownMenu_SetText(mapPointList[PIGA["Map"]["MinimapPoint"]])
	MiniMapF.PIGChecked()
end);
--WorldMap
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
end
WorldMapF:HookScript("OnShow", function (self)
	WorldMapF.WorldMapXY:SetChecked(PIGA["Map"]["WorldMapXY"])
	if tocversion<100000 then
		WorldMapF.WorldMapWind:SetChecked(PIGA["Map"]["WorldMapWind"])
		WorldMapF.WorldMapLV:SetChecked(PIGA["Map"]["WorldMapLV"])
		WorldMapF.WorldMapSkill:SetChecked(PIGA["Map"]["WorldMapSkill"])
		WorldMapF.WorldMapMiwu:SetChecked(PIGA["Map"]["WorldMapMiwu"])
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