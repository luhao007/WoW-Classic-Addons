local addonName, addonTable = ...;
local Data=addonTable.Data
--------
local QuickButUI=_G[Data.QuickButUIname]
QuickButUI.ButList[6]=function()
	if not PIGA["QuickBut"]["Open"] or not PIGA["QuickBut"]["AddonList"] then return end
	if QuickButUI.AddonList then return end
	QuickButUI.AddonList=true
	local L=addonTable.locale
	local Create = addonTable.Create
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGEnter=Create.PIGEnter
	local PIGButton=Create.PIGButton
	local PIGDiyBut=Create.PIGDiyBut
	local PIGDiyTex=Create.PIGDiyTex
	local PIGTabBut=Create.PIGTabBut
	local PIGQuickBut=Create.PIGQuickBut
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGFontString=Create.PIGFontString

	local GetNumAddOns=GetNumAddOns or C_AddOns and C_AddOns.GetNumAddOns
	local DisableAllAddOns=DisableAllAddOns or C_AddOns and C_AddOns.DisableAllAddOns
	local EnableAddOn=EnableAddOn or C_AddOns and C_AddOns.EnableAddOn
	local DisableAddOn=DisableAddOn or C_AddOns and C_AddOns.DisableAddOn
	local GetAddOnDependencies=GetAddOnDependencies or C_AddOns and C_AddOns.GetAddOnDependencies
	----
	local formattxt = "|cff00FF00选中后当进入%s提示你切换插件方案\n|r"
	local ConditionName = {
		["party"]=GUILD_INTEREST_DUNGEON,["raid"]=GUILD_INTEREST_RAID,["pvp"]=BATTLEFIELDS,["arena"]=ARENA,["all"]="账号通用",
	}
	local ConditionList = {
		{"party","Dungeon",GUILD_INTEREST_DUNGEON,string.format(formattxt,GUILD_INTEREST_DUNGEON)..GUILD_INTEREST_DUNGEON_TOOLTIP},
		{"raid","Raid",GUILD_INTEREST_RAID,string.format(formattxt,GUILD_INTEREST_RAID)..GUILD_INTEREST_RAID_TOOLTIP},
		{"pvp","BattleMaster",BATTLEFIELDS,string.format(formattxt,BATTLEFIELDS)..BONUS_BUTTON_RANDOM_BG_DESC},
		{"arena","CrossedFlags",ARENA,string.format(formattxt,ARENA)..ARENA_INFO},
		{"all","UI-ChatIcon-App","账号通用","|cff00FF00选中后方案为账号所有角色启用|r\n默认未选中时则针对单独角色启用"},
	}
	local addonsNotesList={
		[addonName]="/pig设置",
		["AtlasLootClassic"]="/al设置",
		["TextureAtlasViewer"]="Texture Atlas Viewer是一个开发者工具，可以帮助作者在纹理文件中找到地图集。"..
		"纹理将被显示，地图集将被标记在其上。点击其中一个将显示其名称，坐标和其他可用的信息，可以复制。用户可以搜索图集名称或文件，缩放和移动纹理。"..
		"您可以使用/tav或/textureatlasviewer斜杠命令打开窗口。"
	}
	local function GetSetExist(newtxt)
		for i=1,#PIGA["FramePlus"]["AddonStatus"] do
			if newtxt==PIGA["FramePlus"]["AddonStatus"][i][1] then
				return i
			end
		end
		return nil
	end
	local function PIG_loadAddon_(id)
		if id=="RL" then ReloadUI() return end
		local addondata = PIGA["FramePlus"]["AddonStatus"][id]
		local allcharacter = addondata[3].all
		if allcharacter then
			DisableAllAddOns()
		else
			DisableAllAddOns(PIG_OptionsUI.Name)
		end			
		for k,v in pairs(addondata[2]) do
			if v then
				if allcharacter then
					EnableAddOn(k)
				else
					EnableAddOn(k,PIG_OptionsUI.Name)
				end
			else
				if allcharacter then
					DisableAddOn(k)
				else
					DisableAddOn(k,PIG_OptionsUI.Name)
				end
			end
		end
		ReloadUI();
	end
	AddonList_HasOutOfDate()
	local GnUI,Icon,GnName,FrameLevel="PIG_AddonListUI","Mobile-BonusIcon",ADDONS..CHAT_MODERATE,55----Mobile-BonusIcon--Forge-Lock--StreamCinematic-DownloadIcon
	local QkBut=PIGQuickBut(nil,nil,Icon,nil,FrameLevel)
	--展开页
	local Height,anniushu,NumTexCoord  = QuickButUI.nr:GetHeight(), 10, QuickButUI.EquipmentPIG["NumTexCoord"]
	local ButNum=anniushu+1
	local ButNumC=22
	local ConfigList = PIGFrame(QkBut,{"BOTTOM",QkBut,"TOP",0,0},{Height, (Height-4)*ButNum+2})
	ConfigList:SetFrameLevel(23)
	ConfigList:Hide()
	ConfigList:HookScript("OnEnter", function(self)
		self:Show()
	end)
	ConfigList:HookScript("OnLeave", function(self)
		self:Hide()
	end)
	QkBut:HookScript("OnClick", function(self,button)
		if button=="LeftButton" then
			if _G[GnUI]:IsShown() then
				_G[GnUI]:Hide()
			else
				_G[GnUI]:Show()
			end
		else
			ShowUIPanel(AddonList);
		end
		ConfigList:Hide()
	end);
	ConfigList.ButList={}
	for i=1,ButNum do
		local cfBut = PIGFrame(ConfigList,nil,{Height, Height-4})
		ConfigList.ButList[i]=cfBut
		cfBut:PIGSetBackdrop(0.2,0.2)
		if i>1 then
			local ni=i-1
			cfBut.NormalTex = cfBut:CreateTexture(nil, "OVERLAY");
			cfBut.NormalTex:SetTexture("interface/timer/bigtimernumbers.blp");
			cfBut.NormalTex:SetTexCoord(NumTexCoord[ni][1],NumTexCoord[ni][2],NumTexCoord[ni][3],NumTexCoord[ni][4]);
			cfBut.NormalTex:SetAllPoints(cfBut)
		end
		cfBut.Highlight = cfBut:CreateTexture(nil, "Highlight");
		cfBut.Highlight:SetTexture(130718);
		cfBut.Highlight:SetAllPoints(cfBut)
		cfBut.Highlight:SetBlendMode("ADD")
		cfBut.Down = cfBut:CreateTexture(nil, "OVERLAY");
		cfBut.Down:SetTexture(130839);
		cfBut.Down:SetAllPoints(cfBut)
		cfBut.Down:Hide();

		cfBut.name = PIGFontString(cfBut,{"LEFT", cfBut, "RIGHT", 0, 0},nil,"OUTLINE")
		cfBut.name:SetTextColor(1, 1, 1, 1)
		if i==1 then
			cfBut.butID="RL"
			cfBut.name:SetText(RELOADUI)
			cfBut.buttxt = PIGFontString(cfBut,{"CENTER", 2, 0},"RL","OUTLINE",21)
			cfBut.buttxt:SetTextColor(0, 1, 1, 1)
		end
		cfBut:HookScript("OnEnter", function (self)
			ConfigList:Show()
			if i==1 then return end
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",20,0);
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFFF点击切换插件方案|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r")
			GameTooltip:Show();
		end);
		cfBut:HookScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			ConfigList:Hide()
		end);
		cfBut:HookScript("OnMouseDown", function (self)
			self.Down:Show();
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		cfBut:HookScript("OnMouseUp", function (self,button)
			self.Down:Hide();
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
			if button=="LeftButton" then
				PIG_loadAddon_(self.butID)
			else
				if _G[GnUI]:IsShown() then
					_G[GnUI]:Hide()
				else
					_G[GnUI]:Show()
				end
			end
			ConfigList:Hide()
		end);
	end
	------
	function QkBut:UpDatePoints()
		local WowHeight=GetScreenHeight();
		local offset1 = self:GetBottom();
		ConfigList:ClearAllPoints();
		if offset1>(WowHeight*0.5) then
			for i=1,ButNum do
				local fujikj = ConfigList.ButList[i]
				fujikj:ClearAllPoints();
				if i==1 then
					fujikj:SetPoint("TOPRIGHT",ConfigList,"TOPRIGHT",0,-2);
				else
					fujikj:Hide()
					fujikj:SetPoint("TOPRIGHT",ConfigList.ButList[i-1],"BOTTOMRIGHT",0,0);
				end
			end
			ConfigList:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",0,0);
		else
			for i=1,ButNum do
				local fujikj = ConfigList.ButList[i]
				fujikj:ClearAllPoints();
				if i==1 then
					fujikj:SetPoint("BOTTOMRIGHT",ConfigList,"BOTTOMRIGHT",0,2);
				else
					fujikj:Hide()
					fujikj:SetPoint("BOTTOMRIGHT",ConfigList.ButList[i-1],"TOPRIGHT",0,0);
				end
			end
			ConfigList:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",0,0);
		end
		for i=1,#PIGA["FramePlus"]["AddonStatus"] do
			if PIGA["FramePlus"]["AddonStatus"][i] then
				local fujikj = ConfigList.ButList[i+1]
				fujikj:Show()
				fujikj.butID=i
				fujikj.name:SetText(PIGA["FramePlus"]["AddonStatus"][i][1])
			end
		end
		ConfigList:Show()
	end
	QkBut:SetScript("OnEnter", function(self)
		self:UpDatePoints()
	end)
	QkBut:HookScript("OnLeave", function(self)
		ConfigList:Hide()
	end)
	--设置页
	local biaotiH,hangH = 21,20
	local AdminF=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{860,530},GnUI,true)
	AdminF:PIGSetBackdrop()
	AdminF:SetFrameLevel(FrameLevel)
	AdminF:PIGClose()
	AdminF:PIGSetMovableNoSave()
	AdminF.biaoti = PIGFontString(AdminF,{"TOP", AdminF, "TOP", 0, -4},GnName,"OUTLINE")
	AdminF.SelectLID=0
	AdminF.List_L=PIGFrame(AdminF,{"TOPLEFT",AdminF,"TOPLEFT",0,-biaotiH})
	AdminF.List_L:SetPoint("BOTTOMLEFT",AdminF,"BOTTOMLEFT",0,0);
	AdminF.List_L:SetWidth(160);
	AdminF.List_L:PIGSetBackdrop(0)
	AdminF.List_L.DQAddons = PIGTabBut(AdminF.List_L,{"TOPLEFT",AdminF.List_L,"TOPLEFT",4,-4},{150,hangH},"当前插件方案")
	AdminF.List_L.DQAddons:Selected()
	AdminF.List_L.DQAddons:HookScript("OnClick", function (self)
		for xvb=1, #AdminF.List_L.butList, 1 do
			AdminF.List_L.butList[xvb]:NotSelected()
		end
		self:Selected()
		AdminF.SelectLID=0
		AdminF.List_C.Updata_List()
	end);
	AdminF.List_L.butList={}
	for i=1,anniushu do
		local cgbut = PIGTabBut(AdminF.List_L,nil,{150,hangH},"")
		cgbut.Text:ClearAllPoints();
		cgbut.Text:SetPoint("LEFT",cgbut,"LEFT",10,0);
		AdminF.List_L.butList[i]=cgbut
		if i==1 then
			cgbut:SetPoint("TOPLEFT",AdminF.List_L,"TOPLEFT",4,-hangH*2.4);
		else
			cgbut:SetPoint("TOP",AdminF.List_L.butList[i-1],"BOTTOM",0,-hangH*1.4);
		end
		cgbut:HookScript("OnClick", function (self)
			AdminF.List_L.DQAddons:NotSelected()
			for xvb=1, #AdminF.List_L.butList, 1 do
				AdminF.List_L.butList[xvb]:NotSelected()
			end
			AdminF.List_R:Clear_info()
			self:Selected()
			AdminF.SelectLID=i
			AdminF.List_C.Updata_List()
		end);
		for ix=1,#ConditionList do
			cgbut[ConditionList[ix][1]]=PIGDiyTex(cgbut,{"BOTTOMLEFT",cgbut,"TOPLEFT",hangH*(ix-1)+10,-4},{20,20,nil,nil,ConditionList[ix][2]})
		end
	end
	function AdminF.List_L.Updata_List()
		for i=1,anniushu do
			ConfigList.ButList[i+1]:Hide()
			AdminF.List_L.butList[i]:Hide()
			AdminF.List_L.butList[i]:NotSelected()
			for ix=1,#ConditionList do
				AdminF.List_L.butList[i][ConditionList[ix][1]]:SetAlpha(0.6);
				AdminF.List_L.butList[i][ConditionList[ix][1]].icon:SetDesaturated(true)
			end
		end
		if AdminF.SelectLID==0 then
			AdminF.List_L.DQAddons:Click()
		end
		for i=1,#PIGA["FramePlus"]["AddonStatus"] do
			local fujikj = ConfigList.ButList[i+1]
			fujikj.butID=i
			fujikj:Show()
			fujikj.name:SetText(PIGA["FramePlus"]["AddonStatus"][i][1])
			AdminF.List_L.butList[i]:SetID(i)
			AdminF.List_L.butList[i]:Show()
			AdminF.List_L.butList[i]:SetText(PIGA["FramePlus"]["AddonStatus"][i][1])
			if AdminF.SelectLID>0 and AdminF.SelectLID==i then
				AdminF.List_L.butList[i]:Click()
			end
			for ix=1,#ConditionList do
				if PIGA["FramePlus"]["AddonStatus"][i][3][ConditionList[ix][1]] then
					AdminF.List_L.butList[i][ConditionList[ix][1]]:SetAlpha(1);
					AdminF.List_L.butList[i][ConditionList[ix][1]].icon:SetDesaturated(false)
				end
			end
		end
	end
	--右边
	AdminF.List_R=PIGFrame(AdminF,{"TOPRIGHT",AdminF,"TOPRIGHT",0,-biaotiH})
	AdminF.List_R:SetPoint("BOTTOMRIGHT",AdminF,"BOTTOMRIGHT",0,0);
	AdminF.List_R:SetWidth(230);
	AdminF.List_R:PIGSetBackdrop(0)
	AdminF.List_R.namet = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R, "TOPLEFT", 4, -4},ADDONS..AUCTION_HOUSE_BROWSE_HEADER_NAME,"OUTLINE")
	AdminF.List_R.name = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R.namet, "BOTTOMLEFT", 0, -4},"","OUTLINE")
	AdminF.List_R.name:SetTextColor(1, 1, 1, 1)
	AdminF.List_R.notest = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R, "TOPLEFT", 4, -50},ADDONS..COMMUNITIES_CHANNEL_SUBJECT_LABEL,"OUTLINE")
	AdminF.List_R.notes = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R.notest, "BOTTOMLEFT", 0, -4},"","OUTLINE")
	AdminF.List_R.notes:SetTextColor(1, 1, 1, 1)
	AdminF.List_R.notes:SetWidth(AdminF.List_R:GetWidth()-4);
	AdminF.List_R.notes:SetJustifyH("LEFT")
	AdminF.List_R.notes_pigt = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R, "TOPLEFT", 4, -200},addonName..NOTE_COLON,"OUTLINE")
	AdminF.List_R.notes_pig = PIGFontString(AdminF.List_R,{"TOPLEFT", AdminF.List_R.notes_pigt, "BOTTOMLEFT", 0, -4},"","OUTLINE")
	AdminF.List_R.notes_pig:SetTextColor(1, 1, 1, 1)
	AdminF.List_R.notes_pig:SetWidth(AdminF.List_R:GetWidth()-4);
	AdminF.List_R.notes_pig:SetJustifyH("LEFT")
	function AdminF.List_R:Clear_info()
		self.name:SetText("")
		self.notes:SetText("")
		self.notes_pig:SetText("")
	end
	function AdminF.List_R:Update_info(index)
		local name, title, notes, loadable=PIGGetAddOnInfo(index)
		self.name:SetText(title)
		self.notes:SetText(notes)
		self.notes_pig:SetText(addonsNotesList[name] or NONE)
	end
	--中间
	AdminF.List_C=PIGFrame(AdminF,{"TOPLEFT",AdminF.List_L,"TOPRIGHT",4,0})
	AdminF.List_C:SetPoint("BOTTOMRIGHT",AdminF.List_R,"BOTTOMLEFT",-4,0);
	AdminF.List_C:PIGSetBackdrop(0)
	AdminF.List_C.Savebut = PIGButton(AdminF.List_C,nil,{136,20},SAVE..REFORGE_CURRENT.."插件方案")	
	AdminF.List_C.Savebut:HookScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end);
	AdminF.List_C.Savebut.F=PIGFrame(AdminF.List_C.Savebut,{"TOP",AddonList,"TOP",-10,-58},{240,280})
	AdminF.List_C.Savebut.F:PIGSetBackdrop()
	AdminF.List_C.Savebut.F:Hide()
	AdminF.List_C.Savebut.F:PIGClose()
	AdminF.List_C.Savebut.F.title = PIGFontString(AdminF.List_C.Savebut.F,{"TOP", AdminF.List_C.Savebut.F, "TOP", 0, -6},"插件方案名")
	AdminF.List_C.Savebut.F.topline = PIGLine(AdminF.List_C.Savebut.F,"TOP",-26,nil,nil,{0.3,0.3,0.3,0.5})
	AdminF.List_C.Savebut.F.E = CreateFrame("EditBox", nil, AdminF.List_C.Savebut.F, "InputBoxInstructionsTemplate");
	AdminF.List_C.Savebut.F.E:SetSize(150,30);
	AdminF.List_C.Savebut.F.E:SetPoint("TOP",AdminF.List_C.Savebut.F,"TOP",0,-28);
	AdminF.List_C.Savebut.F.E:SetFontObject(ChatFontNormal);
	AdminF.List_C.Savebut.F.E:SetScript("OnEscapePressed", function(self) AdminF.List_C.Savebut.F:Hide() end)
	AdminF.List_C.Savebut.F.E:SetScript("OnTextChanged", function(self)
		local newtxt=self:GetText()
		if newtxt=="" or newtxt==" " then
			AdminF.List_C.Savebut.F.SaveBut:Disable();
			AdminF.List_C.Savebut.F.err:SetText("名称不能为空")
		else
			AdminF.List_C.Savebut.F.SaveBut:Enable();
			local oldID = GetSetExist(newtxt)
			if oldID then
				AdminF.List_C.Savebut.F.err:SetText("名称已经存在,将覆盖已有")
			else
				AdminF.List_C.Savebut.F.err:SetText("")
			end
		end
	end)
	AdminF.List_C.Savebut.F:HookScript("OnShow", function (self)
		AdminF.List_C.Savebut.F.E:SetText("")
		for i=1,#ConditionList do
			AdminF.List_C.Savebut.F.ConditionButList[ConditionList[i][1]]:SetChecked(false)
		end
	end);
	AdminF.List_C.Savebut.F.err = PIGFontString(AdminF.List_C.Savebut.F,{"TOP", AdminF.List_C.Savebut.F.E, "BOTTOM", 0, 0},"")
	AdminF.List_C.Savebut.F.err:SetTextColor(1, 0, 0, 1);
	--
	AdminF.List_C.Savebut.F.ConditionButList={}
	for i=1,#ConditionList do
		local butxxx = PIGCheckbutton(AdminF.List_C.Savebut.F,nil,{ConditionList[i][3],ConditionList[i][4]},{16,16})
		AdminF.List_C.Savebut.F.ConditionButList[ConditionList[i][1]]=butxxx
		butxxx:SetPoint("TOPLEFT", AdminF.List_C.Savebut.F, "TOPLEFT", 60, -30*(i-1)-80)
		butxxx.tex=PIGDiyTex(butxxx,{"RIGHT",butxxx,"LEFT",0,0},{20,20,nil,nil,ConditionList[i][2]})
	end
	--
	AdminF.List_C.Savebut.F.SaveBut = PIGButton(AdminF.List_C.Savebut.F,{"BOTTOM", AdminF.List_C.Savebut.F, "BOTTOM", -50, 16},{80,24},SAVE);
	AdminF.List_C.Savebut.F.SaveBut:Disable();
	AdminF.List_C.Savebut.F.SaveBut:HookScript("OnClick", function (self)
		if #PIGA["FramePlus"]["AddonStatus"]>=anniushu then
			AdminF.List_C.Savebut.F.err:SetText("插件方案已满，请删除一些再试")
			return
		end
		local newtxt = AdminF.List_C.Savebut.F.E:GetText()
		local CheckedV = {}
		for i=1,#ConditionList do
			CheckedV[ConditionList[i][1]]=AdminF.List_C.Savebut.F.ConditionButList[ConditionList[i][1]]:GetChecked()
		end
		local NewAddonStatus = {}
		for id=1,GetNumAddOns() do
			local name, title, notes, loadable=PIGGetAddOnInfo(id)
			local loadablex = PIGGetAddOnEnableState(id, PIG_OptionsUI.Name)
			if loadablex>0 then
				NewAddonStatus[name]=true
			end
		end
		local oldID = GetSetExist(newtxt)
		if oldID then
			PIGA["FramePlus"]["AddonStatus"][oldID][2]=NewAddonStatus
			PIGA["FramePlus"]["AddonStatus"][oldID][3]=CheckedV
		else
			table.insert(PIGA["FramePlus"]["AddonStatus"],{newtxt,NewAddonStatus,CheckedV})
		end
		AdminF.List_L.Updata_List()
		AdminF.List_C.Savebut.F:Hide()
	end);
	AdminF.List_C.Savebut.F.Cancel = PIGButton(AdminF.List_C.Savebut.F,{"LEFT", AdminF.List_C.Savebut.F.SaveBut, "RIGHT", 10, 0},{80,24},CANCEL);
	AdminF.List_C.Savebut.F.Cancel:HookScript("OnClick", function (self)
		AdminF.List_C.Savebut.F:Hide()
	end);

	AdminF.List_C.Delbut = PIGButton(AdminF.List_C,nil,{40,20},DELETE)
	AdminF.List_C.Delbut.Text:SetTextColor(1, 0, 0, 1);
	AdminF.List_C.Delbut:HookScript("OnClick", function (self)
		table.remove(PIGA["FramePlus"]["AddonStatus"],AdminF.SelectLID)
		if AdminF.SelectLID>0 then AdminF.SelectLID=AdminF.SelectLID-1 end
		AdminF.List_L.Updata_List()
	end);
	AdminF.List_C.Delbut.load = PIGButton(AdminF.List_C.Delbut,{"RIGHT",AdminF.List_C.Delbut,"LEFT",-4,0},{40,20},"载入")
	AdminF.List_C.Delbut.load:HookScript("OnClick", function (self)
		PIG_loadAddon_(AdminF.SelectLID)
	end);
	AdminF.List_C.RLbut = PIGButton(AdminF.List_C,nil,{90,20},RELOADUI)
	AdminF.List_C.RLbut:Hide()
	AdminF.List_C.RLbut.Text:SetTextColor(1,0,0,1)
	AdminF.List_C.RLbut.flicker = AdminF.List_C.RLbut:CreateTexture()
	AdminF.List_C.RLbut.flicker:SetAtlas("GarrMission_FollowerListButton-Select")
	AdminF.List_C.RLbut.flicker:SetPoint("TOPLEFT", AdminF.List_C.RLbut, "TOPLEFT", -1, 1);
	AdminF.List_C.RLbut.flicker:SetPoint("BOTTOMRIGHT",AdminF.List_C.RLbut,"BOTTOMRIGHT",1,-1);
	AdminF.List_C.RLbut:HookScript("OnClick", function (self)
		ReloadUI();
	end);
	AdminF.List_C.RLbut.timel=0
	AdminF.List_C.RLbut:HookScript("OnUpdate", function (self, elapsed)
		self.timel=self.timel+elapsed
		if self.timel>0.6 then
			self.flicker:Show()
		end
		if self.timel>1.2 then
			self.flicker:Hide()
			self.timel=0
		end
	end);
	local hangLWW,hangLHH = AdminF.List_C:GetWidth()-16,22
	local function UpdatehangEnter(uix,fujie)
		local fujie=fujie or uix
		uix:HookScript("OnEnter", function ()
			fujie:SetBackdropColor(0.4, 0.4, 0.4, 0.4);
		end);
		uix:HookScript("OnLeave", function ()
			fujie:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		end);
	end
	AdminF.List_C.CondbutList={}
	for i=1,#ConditionList do
		local butxxx = PIGDiyBut(AdminF.List_C,nil,{22,22,nil,nil,ConditionList[i][2]})
		AdminF.List_C.CondbutList[ConditionList[i][1]]=butxxx
		if i==1 then
			butxxx:SetPoint("TOPLEFT", AdminF.List_C, "TOPLEFT", 2, -4)
		else
			butxxx:SetPoint("LEFT", AdminF.List_C.CondbutList[ConditionList[i-1][1]].Name, "RIGHT", 6, 0)
		end
		butxxx.Name = PIGFontString(butxxx,{"LEFT", butxxx, "RIGHT", -2, 0},ConditionList[i][3])
		local wrappedWidth = butxxx.Name:GetWrappedWidth()
		butxxx:SetHitRectInsets(0,-wrappedWidth,0,0)
		PIGEnter(butxxx,ConditionList[i][4])
		butxxx:HookScript("OnClick", function (self)
			if PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID][3][ConditionList[i][1]] then
				PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID][3][ConditionList[i][1]]=false
			else
				PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID][3][ConditionList[i][1]]=true
			end
			AdminF.List_C.Updata_List()
			AdminF.List_L.Updata_List()
		end);
		function butxxx.Updata_CondbutList(offon)
			butxxx.icon:SetDesaturated(not offon)
			if offon then
				butxxx.Name:SetTextColor(1, 0.843, 0, 1)
			else
				butxxx.Name:SetTextColor(0.5, 0.5, 0.5, 1)
			end
		end
	end
	AdminF.List_C.Scroll = Create.PIGScrollFrame(AdminF.List_C,{2,-24,-16,2})
	AdminF.List_C.Scroll:HookScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hangLHH, AdminF.List_C.Updata_List)
	end)
	AdminF.List_C.butList={}
	for i=1,ButNumC do
		local hangL = CreateFrame("Button", nil, AdminF.List_C,"BackdropTemplate");
		AdminF.List_C.butList[i]=hangL
		hangL:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hangL:SetSize(hangLWW,hangLHH);
		hangL:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		if i==1 then
			hangL:SetPoint("TOPLEFT",AdminF.List_C,"TOPLEFT",1,-28);
		else
			hangL:SetPoint("TOP",AdminF.List_C.butList[i-1],"BOTTOM",0,0);
		end
		UpdatehangEnter(hangL)
		hangL.Check = PIGCheckbutton(hangL,{"LEFT",hangL,"LEFT",6,0},nil,{16,16})
		hangL.Check:HookScript("OnClick", function(self)
		    local parent = self:GetParent()
		    local index = parent.indexid
		    local name = PIGGetAddOnInfo(index)
		    if not name then return end
		    if AdminF.SelectLID==0 then
			    local currentState = PIGGetAddOnEnableState(index, PIG_OptionsUI.Name)
			    local newState = self:GetChecked() and 1 or 0
			    if currentState ~= newState then
			        local enable = newState == 1
			        if enable then
			            EnableAddOn(name)
			        else
			            DisableAddOn(name)
			        end
			    end
			    if AddonList_HasAnyChanged() then
					AdminF.List_C.RLbut:Show()
					AdminF.List_C.shouldReload = true
				else
					AdminF.List_C.RLbut:Hide()
					AdminF.List_C.shouldReload = false
				end
			else
				if self:GetChecked() then
					PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID][2][name]=true
				else
					PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID][2][name]=nil
				end
			end
			AdminF.List_C.Updata_List()
		end)
		UpdatehangEnter(hangL.Check,hangL)
		hangL.Name = PIGFontString(hangL,{"LEFT", hangL.Check, "RIGHT", 2, 0})
		hangL.selectX = hangL:CreateTexture();
		hangL.selectX:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		hangL.selectX:SetBlendMode("ADD")
		hangL.selectX:SetAllPoints(hangL)
		hangL.selectX:SetAlpha(0.6);
		hangL.selectX:Hide();
		hangL:HookScript("OnClick", function (self)
			for ix=1,ButNumC do
				AdminF.List_C.butList[ix].selectX:Hide();
			end
			self.selectX:Show();
			AdminF.List_R:Update_info(self.indexid)
		end);
	end
	--查找是否有依赖并全部启用
	local function IsDepEnabled(yilaiD,onoff,name)
		for k,v in pairs(yilaiD[name]) do
			if not onoff[v] then return false end
			if yilaiD[v] then--"查找上级依赖"
				for kk,vv in pairs(yilaiD[v]) do
					if not onoff[vv] then
						return false
					end
				end
			end
		end
		return true
	end
	function AdminF.List_C:GetDepEnabled(yilailist,onoff,name)
		--未勾选直接返回false
		if not onoff[name] then return false end
		--已勾选/没有依赖直接返回true
		if not yilailist[name] then return true end
		return IsDepEnabled(yilailist,onoff,name)
	end
	function AdminF.List_C:BuildAddonTree()
		local TotalNum = GetNumAddOns()
	    local list_1 = {}--一级插件
	    local list_2 = {}--插件下级
		local list_deps = {}--插件的全部依赖
	    for i = 1, TotalNum do
	    	local name = select(1, PIGGetAddOnInfo(i)) 
            local deps = { GetAddOnDependencies(i) }
            if #deps>0 then
            	list_2[deps[1]]=list_2[deps[1]] or {}
            	tinsert(list_2[deps[1]], {i,name})
				list_deps[name]=deps
	        else
	        	tinsert(list_1, {i,name})
	        end
	    end
	    return list_1,list_2,list_deps
	end
	function AdminF.List_C.Updata_List()
		AdminF.List_C.Savebut.F:Hide()
	    for i = 1, ButNumC do
	        local hangL = AdminF.List_C.butList[i]
	        hangL:Hide()
	        hangL.selectX:Hide()
	    end
	    AdminF.List_C.Savebut:SetPoint("TOPLEFT",AdminF.List_C,"TOPLEFT",-99999999,-2)
	    AdminF.List_C.RLbut:SetPoint("TOPRIGHT",AdminF.List_C,"TOPRIGHT",-999999996,-2)
	    AdminF.List_C.Delbut:SetPoint("TOPRIGHT",AdminF.List_C,"TOPRIGHT",-99999996,-2)
	    for i = 1, #ConditionList do
	        AdminF.List_C.CondbutList[ConditionList[i][1]]:SetShown(AdminF.SelectLID ~= 0)
	    end
	    local datax = PIGA["FramePlus"]["AddonStatus"][AdminF.SelectLID]
	    if AdminF.SelectLID == 0 then
	    	AdminF.List_C.Savebut:SetPoint("TOPLEFT",AdminF.List_C,"TOPLEFT",10,-2)
			AdminF.List_C.RLbut:SetPoint("TOPRIGHT",AdminF.List_C,"TOPRIGHT",-4,-2)
	    else
	    	AdminF.List_C.Delbut:SetPoint("TOPRIGHT",AdminF.List_C,"TOPRIGHT",-4,-2)
	        for i = 1, #ConditionList do
	            local k = ConditionList[i][1]
	            local v = datax[3][k]
	            AdminF.List_C.CondbutList[k].Updata_CondbutList(v)
	        end
	    end
	    local treeList1,treeList2,list_deps = AdminF.List_C:BuildAddonTree()
	    local NewData={}
	    local NewData_1={}
	    for i = 1, #treeList1 do
	    	tinsert(NewData, {treeList1[i][1],treeList1[i][2],1})
	    	if treeList2[treeList1[i][2]] then
		    	for ii=1,#treeList2[treeList1[i][2]] do
					tinsert(NewData, {treeList2[treeList1[i][2]][ii][1],treeList2[treeList1[i][2]][ii][2],2})
		    		if treeList2[treeList2[treeList1[i][2]][ii][2]] then
				    	for iii=1,#treeList2[treeList2[treeList1[i][2]][ii][2]] do
				    		tinsert(NewData, {treeList2[treeList2[treeList1[i][2]][ii][2]][iii][1],treeList2[treeList2[treeList1[i][2]][ii][2]][iii][2],3})
				    	end
				    end
		    	end
		    end
	    end
	   	local TotalNum = #NewData
	    local ScrollUI = AdminF.List_C.Scroll
	    FauxScrollFrame_Update(ScrollUI, TotalNum, ButNumC, hangLHH)
	    ScrollUI:UpdateThumbTexture(TotalNum, ButNumC, hangLHH)
	    local offset = FauxScrollFrame_GetOffset(ScrollUI)
	    for i = 1, ButNumC do
	        local dataIndex = i + offset
	        if NewData[dataIndex] then
	        	local hangL = AdminF.List_C.butList[i]
	        	hangL:Show()
	            local index = NewData[dataIndex][1]
	            hangL.indexid = index
	            -- 
				local indent = NewData[dataIndex][3] * 20-20
	            hangL.Check:ClearAllPoints()
	            hangL.Check:SetPoint("LEFT", hangL, "LEFT", 6 + indent, 0)
				hangL.Name:SetText(NewData[dataIndex][2])
	   			local isEnabled

				if AdminF.SelectLID == 0 then
				    isEnabled = (PIGGetAddOnEnableState(index, PIG_OptionsUI.Name) > 0)
				else
				    isEnabled = (datax[2][NewData[dataIndex][2]] == true)
				end
				hangL.Check:SetChecked(isEnabled)
				NewData_1[NewData[dataIndex][2]]=isEnabled
				local depsOK = AdminF.List_C:GetDepEnabled(list_deps, NewData_1, NewData[dataIndex][2])
				if depsOK then
				    hangL.Name:SetTextColor(1, 0.843, 0, 1)
				else
				    hangL.Name:SetTextColor(0.5, 0.5, 0.5, 1)
				end
	        end
	    end
	end
	AdminF.List_L:HookScript("OnShow", function (self)
		AdminF.List_L.Updata_List()
	end);


	--场景提示
	local TispUI=PIGFrame(UIParent,{"TOP",UIParent,"TOP",0,-100},{320,200},"PIG_AddonConfigUI",true,nil,{["ElvUI"]={0,0,0,0},["NDui"]={0,0,0,0}})
	TispUI:PIGSetBackdrop()
	TispUI:Hide()
	TispUI:PIGClose()
	TispUI.title = PIGFontString(TispUI,{"TOP", TispUI, "TOP", 0, -10},"","OUTLINE")
	TispUI.butList={}
	for i=1,anniushu do
		local LoadBut = PIGButton(TispUI,nil,{240,24},"载入",nil,nil,nil,nil,0)
		TispUI.butList[i]=LoadBut
		if i==1 then
			LoadBut:SetPoint("TOP",TispUI,"TOP",0,-30);
		else
			LoadBut:SetPoint("TOP",TispUI.butList[i-1],"BOTTOM",0,-6);
		end
		LoadBut:HookScript("OnClick", function (self)
			PIG_loadAddon_(self:GetID())
		end);
	end
	function TispUI:UpdataList(instanceType,datax)
		for i=1,anniushu do
			TispUI.butList[i]:Hide()
		end
		self.title:SetText("检测到<\124cffff0000"..ConditionName[instanceType].."\124r>插件方案，点击可载入")
		for i=1,#datax do
			TispUI.butList[i]:Show()
			TispUI.butList[i]:SetID(datax[i])
			TispUI.butList[i]:SetText(PIGA["FramePlus"]["AddonStatus"][datax[i]][1])
		end
		TispUI:SetHeight(#datax*30+60)
		self.daojishi=0
	 	self:Show()
	end 
	local function duibiaoneirong(New,old)
		--判断配置开启插件是否在当前开启
		for k,v in pairs(old) do
			if v then
				if not New[k] then
					--print(k,v,New[k])
					return false
				end
			end
		end
		--如果配置都在当前开启，则判断当前开启是否在配置开启
		for k,v in pairs(New) do
			if v then
				if not old[k] then
					--print(k,v,old[k])
					return false
				end
			end
		end
		return true
	end
	TispUI.daojiT = PIGFontString(TispUI,{"BOTTOM", TispUI, "BOTTOM", 4, 8},"秒后关闭","OUTLINE")
	TispUI.daojiV = PIGFontString(TispUI,{"RIGHT", TispUI.daojiT, "LEFT", 0, 0},10,"OUTLINE")
	TispUI.daojiV:SetTextColor(1, 0, 0, 1);
	TispUI:SetScript("OnUpdate",function (self,sss)
		self.daojishi=self.daojishi+sss
		TispUI.daojiV:SetText(10-floor(self.daojishi+0.5))
		if self.daojishi>=10 then self:Hide() end
	end)
	TispUI:RegisterEvent("PLAYER_ENTERING_WORLD");
	TispUI:SetScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		local inInstance, instanceType =IsInInstance()
		if instanceType=="raid" or instanceType=="party" or instanceType=="pvp" or instanceType=="arena" then
			local cunzaipeizhi = {}
			local datax = PIGA["FramePlus"]["AddonStatus"]
			for ic=1,#datax do
				if datax[ic][3][instanceType] then
					table.insert(cunzaipeizhi,ic)
				end
			end
			if #cunzaipeizhi>0 then
				local CurrentStatus = {}
				for id=1,GetNumAddOns() do	
					local name, title, notes, loadable=PIGGetAddOnInfo(id)
					local loadablex = PIGGetAddOnEnableState(id, PIG_OptionsUI.Name)
					if loadablex>0 then
						CurrentStatus[name]=true
					end
				end
				for ic=1,#cunzaipeizhi do
					if duibiaoneirong(CurrentStatus,PIGA["FramePlus"]["AddonStatus"][cunzaipeizhi[ic]][2]) then
						return
					end
				end
				TispUI:UpdataList(instanceType,cunzaipeizhi)
			end
		end
	end);
end