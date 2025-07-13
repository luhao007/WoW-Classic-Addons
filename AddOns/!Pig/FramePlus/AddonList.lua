local _, addonTable = ...;
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
local PIGDiyBut=Create.PIGDiyBut
local PIGDiyTex=Create.PIGDiyTex
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
----
local GetNumAddOns=GetNumAddOns or C_AddOns and C_AddOns.GetNumAddOns
local DisableAllAddOns=DisableAllAddOns or C_AddOns and C_AddOns.DisableAllAddOns
local EnableAddOn=EnableAddOn or C_AddOns and C_AddOns.EnableAddOn
local DisableAddOn=DisableAddOn or C_AddOns and C_AddOns.DisableAddOn
local FramePlusfun=addonTable.FramePlusfun
------
function FramePlusfun.AddonList()
	if not PIGA["FramePlus"]["AddonList"] then return end
	local maxsize,butnum = 90,10 
	local oldWww = AddonList:GetWidth()
	if AddonList.ScrollBox then
		AddonList.ForceLoad:SetPoint("TOP",AddonList,"TOP",20,-27);
		AddonList.SearchBox:SetWidth(146)
		hooksecurefunc("AddonList_InitAddon", function(button, elementData)
			button.Title:SetWidth(320+maxsize)
			-- button.Status:SetPoint("LEFT",button.Title,"RIGHT",10,0);
			-- button.Reload:SetPoint("LEFT",button.Title,"RIGHT",10,0);
			-- button.LoadAddonButton:SetPoint("LEFT",button.Title,"RIGHT",10,0);
		end)
	else
		for i=1, MAX_ADDONS_DISPLAYED do
			_G["AddonListEntry"..i.."Title"]:SetWidth(220+maxsize)
			_G["AddonListEntry"..i.."Status"]:SetPoint("LEFT",_G["AddonListEntry"..i.."Title"],"RIGHT",10,0);
			_G["AddonListEntry"..i.."Reload"]:SetPoint("LEFT",_G["AddonListEntry"..i.."Title"],"RIGHT",10,0);
			_G["AddonListEntry"..i.."Load"]:SetPoint("LEFT",_G["AddonListEntry"..i.."Title"],"RIGHT",10,0);
		end
	end

	local formattxt = "|cff00FF00选中后当进入%s提示你切换配置\n|r"
	local ConditionName = {
		["party"]=GUILD_INTEREST_DUNGEON,["raid"]=GUILD_INTEREST_RAID,["pvp"]=BATTLEFIELDS,["arena"]=ARENA,["all"]="账号通用",
	}
	local ConditionList = {
		{"party","Dungeon",GUILD_INTEREST_DUNGEON,string.format(formattxt,GUILD_INTEREST_DUNGEON)..GUILD_INTEREST_DUNGEON_TOOLTIP},
		{"raid","Raid",GUILD_INTEREST_RAID,string.format(formattxt,GUILD_INTEREST_RAID)..GUILD_INTEREST_RAID_TOOLTIP},
		{"pvp","BattleMaster",BATTLEFIELDS,string.format(formattxt,BATTLEFIELDS)..BONUS_BUTTON_RANDOM_BG_DESC},
		{"arena","CrossedFlags",ARENA,string.format(formattxt,ARENA)..ARENA_INFO},
		{"all","UI-ChatIcon-App","账号通用","|cff00FF00选中后配置为账号所有角色启用|r\n默认未选中时则针对单独角色启用"},
	}
	AddonList.pigSavebut = PIGButton(AddonList,{"TOPLEFT", AddonList, "TOPLEFT", 180, -28},{120,24},"保存启用状态",nil,nil,nil,nil,0)
	AddonList.pigSavebut:HookScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end);
	local function GetSetExist(newtxt)
		for i=1,#PIGA["FramePlus"]["AddonStatus"] do
			if newtxt==PIGA["FramePlus"]["AddonStatus"][i][1] then
				return i
			end
		end
		return nil
	end
	local function PIG_loadAddon_(id)
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
	AddonList.PIG_loadAddon_=PIG_loadAddon_
	AddonList.pigSavebut.F=PIGFrame(AddonList.pigSavebut,{"TOP",AddonList,"TOP",-10,-58},{240,280})
	AddonList.pigSavebut.F:PIGSetBackdrop(nil,nil,nil,nil,0)
	AddonList.pigSavebut.F:Hide()
	AddonList.pigSavebut.F:PIGClose()
	AddonList:HookScript("OnHide", function (self) self.pigSavebut.F:Hide() end);
	AddonList.pigSavebut.F.title = PIGFontString(AddonList.pigSavebut.F,{"TOP", AddonList.pigSavebut.F, "TOP", 0, -8},"插件状态名",nil,13.4)
	AddonList.pigSavebut.F.topline = PIGLine(AddonList.pigSavebut.F,"TOP",-26,nil,nil,{0.3,0.3,0.3,0.5})
	AddonList.pigSavebut.F.E = CreateFrame("EditBox", nil, AddonList.pigSavebut.F, "InputBoxInstructionsTemplate");
	AddonList.pigSavebut.F.E:SetSize(150,30);
	AddonList.pigSavebut.F.E:SetPoint("TOP",AddonList.pigSavebut.F,"TOP",0,-28);
	AddonList.pigSavebut.F.E:SetFontObject(ChatFontNormal);
	AddonList.pigSavebut.F.E:SetScript("OnEscapePressed", function(self) AddonList.pigSavebut.F:Hide() end)
	AddonList.pigSavebut.F.E:SetScript("OnTextChanged", function(self)
		local newtxt=self:GetText()
		if newtxt=="" or newtxt==" " then
			AddonList.pigSavebut.F.SaveBut:Disable();
			AddonList.pigSavebut.F.err:SetText("名称不能为空")
		else
			AddonList.pigSavebut.F.SaveBut:Enable();
			local oldID = GetSetExist(newtxt)
			if oldID then
				AddonList.pigSavebut.F.err:SetText("名称已经存在,将覆盖已有")
			else
				AddonList.pigSavebut.F.err:SetText("")
			end
		end
	end)
	AddonList.pigSavebut.F:HookScript("OnShow", function (self)
		AddonList.pigSavebut.F.E:SetText("")
		for i=1,#ConditionList do
			AddonList.pigSavebut.F.ConditionButList[ConditionList[i][1]]:SetChecked(false)
		end
	end);
	AddonList.pigSavebut.F.err = PIGFontString(AddonList.pigSavebut.F,{"TOP", AddonList.pigSavebut.F.E, "BOTTOM", 0, -2},"",nil,13.4)
	AddonList.pigSavebut.F.err:SetTextColor(1, 0, 0, 1);
	--
	AddonList.pigSavebut.F.ConditionButList={}
	for i=1,#ConditionList do
		local butxxx = PIGCheckbutton(AddonList.pigSavebut.F,nil,{ConditionList[i][3],ConditionList[i][4]},nil,nil,nil,0)
		AddonList.pigSavebut.F.ConditionButList[ConditionList[i][1]]=butxxx
		butxxx:SetPoint("TOPLEFT", AddonList.pigSavebut.F, "TOPLEFT", 60, -30*(i-1)-80)
		butxxx.tex=PIGDiyTex(butxxx,{"RIGHT",butxxx,"LEFT",0,0},{20,20,nil,nil,ConditionList[i][2]})
	end
	--
	AddonList.pigSavebut.F.SaveBut = PIGButton(AddonList.pigSavebut.F,nil,nil,nil,nil,nil,nil,nil,0);
	AddonList.pigSavebut.F.SaveBut:SetSize(80,24);
	AddonList.pigSavebut.F.SaveBut:SetPoint("BOTTOM", AddonList.pigSavebut.F, "BOTTOM", -50, 16);
	AddonList.pigSavebut.F.SaveBut:SetText(SAVE);
	AddonList.pigSavebut.F.SaveBut:Disable();
	AddonList.pigSavebut.F.SaveBut:HookScript("OnClick", function (self)
		if #PIGA["FramePlus"]["AddonStatus"]>=butnum then
			AddonList.pigSavebut.F.err:SetText("配置已满，请删除一些再试")
			return
		end
		local newtxt = AddonList.pigSavebut.F.E:GetText()
		local CheckedV = {}
		for i=1,#ConditionList do
			CheckedV[ConditionList[i][1]]=AddonList.pigSavebut.F.ConditionButList[ConditionList[i][1]]:GetChecked()
		end
		local AddonStatus = {}
		for id=1,GetNumAddOns() do
			local name, title, notes, loadable=PIGGetAddOnInfo(id)
			local loadablex = PIGGetAddOnEnableState(id, PIG_OptionsUI.Name)
			if loadablex>0 then
				AddonStatus[name]=true
			end
		end
		local oldID = GetSetExist(newtxt)
		if oldID then
			PIGA["FramePlus"]["AddonStatus"][oldID][2]=AddonStatus
			PIGA["FramePlus"]["AddonStatus"][oldID][3]=CheckedV
		else
			table.insert(PIGA["FramePlus"]["AddonStatus"],{newtxt,AddonStatus,CheckedV})
		end
		AddonList.L_List.Updata_List()
		AddonList.pigSavebut.F:Hide()
	end);
	AddonList.pigSavebut.F.Cancel = PIGButton(AddonList.pigSavebut.F,nil,nil,nil,nil,nil,nil,nil,0);
	AddonList.pigSavebut.F.Cancel:SetSize(80,24);
	AddonList.pigSavebut.F.Cancel:SetPoint("LEFT", AddonList.pigSavebut.F.SaveBut, "RIGHT", 10, 0);
	AddonList.pigSavebut.F.Cancel:SetText(CANCEL);
	AddonList.pigSavebut.F.Cancel:HookScript("OnClick", function (self)
		AddonList.pigSavebut.F:Hide()
	end);
	--
	AddonList.L_List=PIGFrame(AddonList,{"TOPRIGHT",AddonList,"TOPLEFT",0,0})
	AddonList.L_List:PIGSetBackdrop(nil,nil,nil,nil,0)
	AddonList.L_List:SetPoint("BOTTOMRIGHT",AddonList,"BOTTOMLEFT",0,0);
	AddonList.L_List:SetWidth(160);
	AddonList.L_List.title = PIGFontString(AddonList.L_List,{"TOP", AddonList.L_List, "TOP", 0, -4},"插件状态配置",nil,13.4)
	AddonList.L_List.topline = PIGLine(AddonList.L_List,"TOP",-22,nil,nil,{0.3,0.3,0.3,0.5})
	AddonList.L_List.butList={}
	for i=1,butnum do
		local cgbut = PIGButton(AddonList.L_List,nil,{130,24},"",nil,nil,nil,nil,0)
		cgbut.Text:ClearAllPoints();
		cgbut.Text:SetPoint("LEFT",cgbut,"LEFT",10,0);
		AddonList.L_List.butList[i]=cgbut
		if i==1 then
			cgbut:SetPoint("TOPLEFT",AddonList.L_List,"TOPLEFT",8,-40);
		else
			cgbut:SetPoint("TOP",AddonList.L_List.butList[i-1],"BOTTOM",0,-21);
		end
		cgbut:HookScript("OnClick", function (self)
			PIG_loadAddon_(self:GetID())
		end);
		for ix=1,#ConditionList do
			cgbut[ConditionList[ix][1]]=PIGDiyTex(cgbut,{"BOTTOMLEFT",cgbut,"TOPLEFT",21*(ix-1)+10,-8},{20,20,nil,nil,ConditionList[ix][2]})
		end
		cgbut.del=PIGDiyBut(cgbut,{"LEFT",cgbut,"RIGHT",0,0},{16,16})
		cgbut.del:HookScript("OnClick", function (self)
			table.remove(PIGA["FramePlus"]["AddonStatus"],self:GetParent():GetID())
			AddonList.L_List.Updata_List()
		end);
	end
	function AddonList.L_List.Updata_List()
		for i=1,butnum do
			AddonList.L_List.butList[i]:Hide()
			for ix=1,#ConditionList do
				AddonList.L_List.butList[i][ConditionList[ix][1]]:SetAlpha(0.6);
				AddonList.L_List.butList[i][ConditionList[ix][1]].icon:SetDesaturated(true)
			end
		end
		for i=1,#PIGA["FramePlus"]["AddonStatus"] do
			AddonList.L_List.butList[i]:SetID(i)
			AddonList.L_List.butList[i]:Show()
			AddonList.L_List.butList[i]:SetText(PIGA["FramePlus"]["AddonStatus"][i][1])
			for ix=1,#ConditionList do
				if PIGA["FramePlus"]["AddonStatus"][i][3][ConditionList[ix][1]] then
					AddonList.L_List.butList[i][ConditionList[ix][1]]:SetAlpha(1);
					AddonList.L_List.butList[i][ConditionList[ix][1]].icon:SetDesaturated(false)
				end
			end
		end
	end
	AddonList.L_List:HookScript("OnShow", function (self)
		AddonList.L_List.Updata_List()
	end);

	local TispUI=PIGFrame(UIParent,{"TOP",UIParent,"TOP",0,-100},{320,200},"PIG_AddonConfigUI",true)
	TispUI:PIGSetBackdrop(nil,nil,nil,nil,0)
	TispUI:Hide()
	TispUI:PIGClose()
	TispUI.title = PIGFontString(TispUI,{"TOP", TispUI, "TOP", 0, -10},"","OUTLINE")
	TispUI.butList={}
	for i=1,butnum do
		local cgbut = PIGButton(TispUI,nil,{130,24},"",nil,nil,nil,nil,0)
		TispUI.butList[i]=cgbut
		if i==1 then
			cgbut:SetPoint("TOP",TispUI,"TOP",0,-30);
		else
			cgbut:SetPoint("TOP",TispUI.butList[i-1],"BOTTOM",0,-6);
		end
		cgbut:HookScript("OnClick", function (self)
			PIG_loadAddon_(self:GetID())
		end);
	end
	function TispUI:UpdataList(instanceType,datax)
		for i=1,butnum do
			TispUI.butList[i]:Hide()
		end
		self.title:SetText("检测到<\124cffff0000"..ConditionName[instanceType].."\124r>配置，点击可启用")
		for i=1,#datax do
			TispUI.butList[i]:SetID(datax[i])
			TispUI.butList[i]:Show()
			TispUI.butList[i]:SetText(PIGA["FramePlus"]["AddonStatus"][datax[i]][1])
		end
		TispUI:SetHeight(#datax*30+50)
		self.daojishi=0
	 	self:Show()
	end 
	local function duibiaoneirong(tb1,tb2)
		local hejilist={}
		for k,v in pairs(tb1) do
			hejilist[k]=v
		end
		for k,v in pairs(tb2) do
			hejilist[k]=v
		end
		for k,v in pairs(hejilist) do
			if tb1[k] == nil then return false end
			if tb2[k] == nil then return false end
			if tb1[k]~=tb2[k] then
				return false 
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
			for i=1,#datax do
				if datax[i][3][instanceType] then
					table.insert(cunzaipeizhi,i)
				end
			end
			if #cunzaipeizhi>0 then
				local AddonStatus = {}
				for id=1,GetNumAddOns() do	
					local name, title, notes, loadable=PIGGetAddOnInfo(id)
					if loadable then
						AddonStatus[name]=loadable
					end
				end
				for i=1,#cunzaipeizhi do
					if duibiaoneirong(AddonStatus,PIGA["FramePlus"]["AddonStatus"][cunzaipeizhi[i]][2]) then
						return
					end
				end
				TispUI:UpdataList(instanceType,cunzaipeizhi)
			end
		end
	end);
end