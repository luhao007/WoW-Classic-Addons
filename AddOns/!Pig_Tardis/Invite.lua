local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Invite(Activate)
	if not PIGA["Tardis"]["Invite"]["Open"] then return end
	local Create, Data, Fun, L= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGEnter=Create.PIGEnter
	local PIGButton = Create.PIGButton
	local PIGDownMenu=Create.PIGDownMenu
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGFontString=Create.PIGFontString
	local PIGQuickBut=Create.PIGQuickBut
	local PIGSetFont=Create.PIGSetFont
	local PIGDiyBut=Create.PIGDiyBut
	local PigSetEditBoxData=Create.InitializeEditBox
	local IsEditBoxNumber=Create.IsEditBoxNumber
	------------------------
	local ConvertToParty=ConvertToParty or C_PartyInfo and C_PartyInfo.ConvertToParty
	local ConvertToRaid=ConvertToRaid or C_PartyInfo and C_PartyInfo.ConvertToRaid
	local GetContainerItemLink=GetContainerItemLink or C_Container and C_Container.GetContainerItemLink
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local gsub = _G.string.gsub
	local match = _G.string.match
	local GetPindaoList=Fun.GetPindaoList
	local GetYellPindao=Fun.GetYellPindao
	local Key_fenge=Fun.Key_fenge
	local Get_famsg=Fun.Get_famsg
	local cl_Name=Data.cl_Name
	local cl_Name_Role=Data.cl_Name_Role
	local ClassFile_Name=Data.ClassFile_Name
	local zhizeAtlas=Data.zhizeAtlas
	local MSGsuijizifu=Data.MSGsuijizifu
-- 	---
	local InvF=_G[GnUI]
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,GROUPS,80,"Bot")
	if Activate then fujiF:Show() fujiTabBut:Selected() end
-- 	--=====================
	local Roles = {"TANK", "HEALER","DAMAGER"}
	local RolesXulie = {["TANK"]=1, ["HEALER"]=2,["DAMAGER"]=3}
	local Roles_List={{},{},{}};
	--提取职业职责信息
	local function GetClassRoles(id)
		for i=1,#cl_Name do
			local zhize = cl_Name[i][2]
			for ii=1,#zhize do
				if Roles[id]==zhize[ii] then
					table.insert(Roles_List[id],{cl_Name[i][1],cl_Name[i][3]})
				end
			end
		end
	end
	GetClassRoles(1)
	GetClassRoles(2)
	GetClassRoles(3)
	if PIG_MaxTocversion(20000) then
		local englishFaction = UnitFactionGroup("player")
		if englishFaction=="Alliance" then
			for id=1,#Roles_List do
				for ix=#Roles_List[id],1,-1 do
					if Roles_List[id][ix][1]=="SHAMAN" then
						table.remove(Roles_List[id],ix)
					end
				end
			end
		elseif englishFaction=="Horde" then
			for id=1,#Roles_List do
				for ix=#Roles_List[id],1,-1 do
					if Roles_List[id][ix][1]=="PALADIN" then
						table.remove(Roles_List[id],ix)
					end
				end
			end
		end
	end
	local function InitializationData(DQMubiao,mb)
		local datax={}
		for xulie=1,#Roles_List do
			datax[xulie]={}
			for id=1,#Roles_List[xulie] do
				if mb then
					datax[xulie][id]=DQMubiao and DQMubiao[xulie] and DQMubiao[xulie][id] or 0
				else
					datax[xulie][id]= 0
				end
			end
		end
		return datax
	end
	----职业人数显示
	fujiF.topF = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,0});
	fujiF.topF:SetPoint("TOPRIGHT", fujiF, "TOPRIGHT", 0, 0);
	fujiF.topF:SetHeight(320)

	local zhiye_F_H,zhiye_but_H=90,20
	fujiF.topF.RoleButList={}
	local function ADD_Roles_Frame(xulie)
		local zhizeF=PIGFrame(fujiF.topF)
		fujiF.topF.RoleButList[xulie]=zhizeF
		zhizeF:SetHeight(zhiye_F_H)
		zhizeF:PIGSetBackdrop()
		if xulie==1 then
			zhizeF:SetPoint("TOPLEFT",fujiF.topF,"TOPLEFT",4,-4);
			zhizeF:SetPoint("TOPRIGHT", fujiF.topF, "TOPRIGHT", -4, 4);
		else
			zhizeF:SetPoint("TOPLEFT",fujiF.topF.RoleButList[xulie-1],"BOTTOMLEFT",0,-6);
			zhizeF:SetPoint("TOPRIGHT",fujiF.topF.RoleButList[xulie-1],"BOTTOMRIGHT",0,-6);
		end
		zhizeF.Tex = zhizeF:CreateTexture(nil, "BORDER");
		zhizeF.Tex:SetAtlas(zhizeAtlas[xulie]);
		zhizeF.Tex:SetSize(zhiye_but_H*3,zhiye_but_H*3);
		zhizeF.Tex:SetPoint("LEFT", zhizeF, "LEFT", 10,0);
		--
		zhizeF.mubiaoAll = PIGFontString(zhizeF,{"LEFT", zhizeF, "LEFT", 70,8},"目标人数", "OUTLINE");
		zhizeF.mubiaoAll_V = PIGFontString(zhizeF,{"LEFT", zhizeF.mubiaoAll, "RIGHT", 2,0},0, "OUTLINE");
		zhizeF.mubiaoAll_V:SetTextColor(1,1,1,1);
		zhizeF.dangqianAll = PIGFontString(zhizeF,{"LEFT", zhizeF, "LEFT", 70,-16},"已组人数", "OUTLINE");
		zhizeF.dangqianAll_V = PIGFontString(zhizeF,{"LEFT", zhizeF.dangqianAll, "RIGHT", 2,0},0, "OUTLINE");
		zhizeF.dangqianAll_V:SetTextColor(1,1,1,1);
		zhizeF.mubiao_EBut={}
		for id=1,#Roles_List[xulie] do
			local fileName=Roles_List[xulie][id][1]
			local EBox = CreateFrame("EditBox", nil, zhizeF, "InputBoxInstructionsTemplate");
			zhizeF.mubiao_EBut[id]=EBox
			EBox:SetSize(24,zhiye_but_H);
			if id==1 then
				EBox:SetPoint("LEFT", zhizeF.mubiaoAll, "LEFT", 110,0);
			else
				EBox:SetPoint("LEFT",zhizeF.mubiao_EBut[id-1],"RIGHT",30,0);
			end
			PIGSetFont(EBox,14,"OUTLINE")
			EBox:SetNumeric(true)
			EBox:SetMaxLetters(2)
			EBox:SetAutoFocus(false)
			PigSetEditBoxData(EBox)
			EBox:HookScript("OnEditFocusGained", function(self) 
				self:HighlightText()
			end);
			EBox:HookScript("OnTextChanged", function(self)
				fujiF.Datas_MB[xulie][id]=self:GetNumber();
				PIGA["Tardis"]["Invite"]["DQMubiao"]=fujiF.Datas_MB
				fujiF:Update_ShowList()
			end);
			EBox.Icon=PIGFrame(EBox,{"BOTTOM", EBox, "TOP", -1,2},{zhiye_but_H,zhiye_but_H-2})
			EBox.Icon.tex = EBox.Icon:CreateTexture();
			EBox.Icon.tex:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
			EBox.Icon.tex:SetAllPoints(EBox.Icon)
			local coords = CLASS_ICON_TCOORDS[fileName]
			EBox.Icon.tex:SetTexCoord(unpack(coords));
			EBox.Icon:SetScript("OnEnter", function(self)
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				GameTooltip:AddLine(_G[Roles[xulie]]..ClassFile_Name[fileName]..":")
				for ic=1,#fujiF.Datas_DQName[xulie][id] do
					GameTooltip:AddLine("|c"..PIG_CLASS_COLORS[fileName].colorStr..fujiF.Datas_DQName[xulie][id][ic][1].."|r")
				end
				GameTooltip:Show();
			end)
			EBox.Icon:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
			EBox.Icon:SetScript("OnMouseUp", function(self)
				fujiF.SetRoleF:Update_UI(self,xulie,id,_G[Roles[xulie]]..ClassFile_Name[fileName])
			end)
			EBox.yizu = PIGFontString(EBox,{"TOP", EBox, "BOTTOM", -1,-8},nil,"OUTLINE");
			EBox.wancheng = EBox:CreateTexture();
			EBox.wancheng:SetSize(zhiye_but_H,zhiye_but_H-4);
			EBox.wancheng:SetPoint("TOP", EBox.yizu, "BOTTOM", 0,-2);
		end
	end
	ADD_Roles_Frame(1)
	ADD_Roles_Frame(2)
	ADD_Roles_Frame(3)

	--手动通知玩家改职责
	local shezhiW,shezhiH = 520,24
	fujiF.SetRoleF=PIGFrame(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 180,-6},{shezhiW,420})
	fujiF.SetRoleF:PIGSetBackdrop(1)
	fujiF.SetRoleF:PIGClose()
	fujiF.SetRoleF:Hide()
	fujiF.SetRoleF:SetFrameLevel(fujiF.SetRoleF:GetFrameLevel()+10)
	fujiF.SetRoleF.biaoti = PIGFontString(fujiF.SetRoleF,{"TOP", fujiF.SetRoleF, "TOP", 0,-3},"", "OUTLINE");	
	fujiF.SetRoleF.ButList={}
	for i=1,MAX_RAID_MEMBERS do
		local pbut = CreateFrame("Frame",nil,fujiF.SetRoleF)
		fujiF.SetRoleF.ButList[i]=pbut
		pbut:SetSize(shezhiW*0.46,shezhiH);
		if i == 1 then
	        pbut:SetPoint("TOPLEFT", fujiF.SetRoleF, "TOPLEFT", 2, -20)
	    else
			local row = math.floor((i - 1) / 2)
		    if i % 2 == 1 then     
	            local prevLeftIndex = i - 2
	            if fujiF.SetRoleF.ButList[prevLeftIndex] then
	                pbut:SetPoint("TOP", fujiF.SetRoleF.ButList[prevLeftIndex], "BOTTOM", 0, -2)
	            end
		    else
		        local leftPartner = i - 1
		        if fujiF.SetRoleF.ButList[leftPartner] then
		            pbut:SetPoint("LEFT", fujiF.SetRoleF.ButList[leftPartner], "RIGHT", 4, 0)
		        end
		    end
		end
		pbut.role1 = PIGDiyBut(pbut,{"LEFT",pbut,"LEFT",1,0},{shezhiH,nil,shezhiH,nil,"ui-lfg-roleicon-dps"})
		PIGEnter(pbut.role1,"通知修改职责")
		pbut.role1:HookScript("OnClick", function (self)
			local wanjname = self:GetParent().name:GetText()
			SendChatMessage("[!Pig] 团长通知你修改职责为：".._G[Roles[self.eid]], "WHISPER", nil, wanjname);
			fujiF.SetRoleF:Hide()
		end);
		pbut.role2 = PIGDiyBut(pbut,{"LEFT",pbut.role1,"RIGHT",1,0},{shezhiH,nil,shezhiH,nil,"ui-lfg-roleicon-dps"})
		PIGEnter(pbut.role2,"通知修改职责")
		pbut.role2:HookScript("OnClick", function (self)
			local wanjname = self:GetParent().name:GetText()
			SendChatMessage("[!Pig] 团长通知你修改职责为：".._G[Roles[self.eid]], "WHISPER", nil, wanjname);
			fujiF.SetRoleF:Hide()
		end);
		pbut.name = PIGFontString(pbut,{"LEFT", pbut.role2, "RIGHT", 4,0},i.."一二三四五六-计划经济", "OUTLINE");
	end
	function fujiF.SetRoleF:Update_UI(butui,xulie,id,btxt)
		if self:IsShown() then
			self:Hide()
		else
			for ic=1,MAX_RAID_MEMBERS do
				fujiF.SetRoleF.ButList[ic]:Hide()
			end
			self.biaoti:SetText(btxt)
			for ic=1,#fujiF.Datas_DQName[xulie][id] do
				if xulie==1 then
					fujiF.SetRoleF.ButList[ic].role1.eid=2
					fujiF.SetRoleF.ButList[ic].role2.eid=3
					fujiF.SetRoleF.ButList[ic].role1.icon:SetAtlas("ui-lfg-roleicon-healer")
					fujiF.SetRoleF.ButList[ic].role2.icon:SetAtlas("ui-lfg-roleicon-dps")
				elseif xulie==2 then
					fujiF.SetRoleF.ButList[ic].role1.eid=1
					fujiF.SetRoleF.ButList[ic].role2.eid=3
					fujiF.SetRoleF.ButList[ic].role1.icon:SetAtlas("ui-lfg-roleicon-tank")
					fujiF.SetRoleF.ButList[ic].role2.icon:SetAtlas("ui-lfg-roleicon-dps")
				elseif xulie==3 then
					fujiF.SetRoleF.ButList[ic].role1.eid=1
					fujiF.SetRoleF.ButList[ic].role2.eid=2
					fujiF.SetRoleF.ButList[ic].role1.icon:SetAtlas("ui-lfg-roleicon-tank")
					fujiF.SetRoleF.ButList[ic].role2.icon:SetAtlas("ui-lfg-roleicon-healer")
				end
				fujiF.SetRoleF.ButList[ic]:Show()
				fujiF.SetRoleF.ButList[ic].name:SetText(fujiF.Datas_DQName[xulie][id][ic][1])
			end
			self:Show()
		end
	end
	fujiF.topF.playerNum = PIGFontString(fujiF.topF,{"BOTTOMLEFT",fujiF.topF,"BOTTOMLEFT", 10,10},"总人数:");
	fujiF.topF.playerNumV = PIGFontString(fujiF.topF,{"LEFT",fujiF.topF.playerNum,"RIGHT",4,0});
	fujiF.topF.playerNumV:SetTextColor(0, 1, 0, 1);
	fujiF.topF.playerNumxie = PIGFontString(fujiF.topF,{"LEFT", fujiF.topF.playerNumV, "RIGHT", 2,0},"/");
	fujiF.topF.playerNumV_max = PIGFontString(fujiF.topF,{"LEFT", fujiF.topF.playerNumxie, "RIGHT", 2,0});
	fujiF.topF.playerNumV_max:SetTextColor(1, 0, 0, 1)
	--载入开团模板
	fujiF.topF.daoruMoren=PIGDownMenu(fujiF.topF,{"LEFT",fujiF.topF.playerNum,"RIGHT", 50,0},{124,22})
	fujiF.topF.daoruMoren:PIGDownMenu_SetText("导入开团模板")
	function fujiF.topF.daoruMoren:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for ixx=1,#PIGA["Tardis"]["Invite"]["Template"] do
			info.text, info.arg1 = PIGA["Tardis"]["Invite"]["Template"][ixx][1], PIGA["Tardis"]["Invite"]["Template"][ixx][2]
		    info.notCheckable = true;
		    self:PIGDownMenu_AddButton(info)
		end
	end
	function fujiF.topF.daoruMoren:PIGDownMenu_SetValue(value,arg1,arg2,checked,button)
		if button=="LeftButton" then
			PIGA["Tardis"]["Invite"]["DQMubiao"]=arg1
			fujiF.Datas_MB=InitializationData(PIGA["Tardis"]["Invite"]["DQMubiao"],true)
			fujiF:Update_ShowList()
			PIG_OptionsUI:ErrorMsg("已导入|cffFFFFFF"..value.."|r开团模板");
		else
			for ixx=#PIGA["Tardis"]["Invite"]["Template"],1,-1 do
				if value == PIGA["Tardis"]["Invite"]["Template"][ixx][1] then
					table.remove(PIGA["Tardis"]["Invite"]["Template"],ixx)
					break
			   	end
			end
		end
		PIGCloseDropDownMenus()
	end
	fujiF.topF.SaveTemplate=PIGButton(fujiF.topF,{"LEFT",fujiF.topF.daoruMoren,"RIGHT", 2,0},{50,20},"保存")
	fujiF.topF.SaveTemplate:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end)
	fujiF.topF.SaveTemplate.F = PIGFrame(fujiF.topF.SaveTemplate,{"BOTTOM",fujiF.topF.SaveTemplate,"TOP",0,1});
	fujiF.topF.SaveTemplate.F:SetSize(250,160)
	fujiF.topF.SaveTemplate.F:PIGSetBackdrop(1)
	fujiF.topF.SaveTemplate.F:SetFrameLevel(fujiF.topF.SaveTemplate.F:GetFrameLevel()+5)
	fujiF.topF.SaveTemplate.F:Hide()
	fujiF.topF.SaveTemplate.F.TT = PIGFontString(fujiF.topF.SaveTemplate.F,{"TOP", fujiF.topF.SaveTemplate.F, "TOP", 0,-6},"保存目标人数为模板", "OUTLINE");
	fujiF.topF.SaveTemplate.F.Name = PIGFontString(fujiF.topF.SaveTemplate.F,{"TOPLEFT", fujiF.topF.SaveTemplate.F, "TOPLEFT", 6,-50},"模版名:", "OUTLINE");
	fujiF.topF.SaveTemplate.F.E = CreateFrame("EditBox", nil, fujiF.topF.SaveTemplate.F, "InputBoxInstructionsTemplate");
	fujiF.topF.SaveTemplate.F.E:SetSize(180,zhiye_but_H);
	fujiF.topF.SaveTemplate.F.E:SetPoint("LEFT", fujiF.topF.SaveTemplate.F.Name, "RIGHT", 4,0);
	fujiF.topF.SaveTemplate.F.E:SetMaxLetters(20)
	PIGSetFont(fujiF.topF.SaveTemplate.F.E,14,"OUTLINE")
	fujiF.topF.SaveTemplate.F.E:HookScript("OnShow", function(self)
		Create.Update_SaveTempF(fujiF.topF.SaveTemplate.F)
	end)
	fujiF.topF.SaveTemplate.F.E:HookScript("OnTextChanged", function(self)
		Create.Update_SaveTempF(fujiF.topF.SaveTemplate.F)
	end)
	fujiF.topF.SaveTemplate.F.error = PIGFontString(fujiF.topF.SaveTemplate.F,{"TOPLEFT", fujiF.topF.SaveTemplate.F.E, "BOTTOMLEFT", 6,-2},"", "OUTLINE");
	fujiF.topF.SaveTemplate.F.error:SetTextColor(1, 0, 0, 1)
	fujiF.topF.SaveTemplate.F.SaveBut=PIGButton(fujiF.topF.SaveTemplate.F,{"BOTTOM",fujiF.topF.SaveTemplate.F,"BOTTOM", -50,30},{50,24},"保存")
	fujiF.topF.SaveTemplate.F.SaveBut:SetScript("OnClick", function (self)
		for ixx=1,#PIGA["Tardis"]["Invite"]["Template"] do
			if PIGA["Tardis"]["Invite"]["Template"][ixx][1]==fujiF.topF.SaveTemplate.F.E:GetText() then
				PIGA["Tardis"]["Invite"]["Template"][ixx][2]=fujiF.Datas_MB
				fujiF.topF.SaveTemplate.F:Hide()
				return
			end
		end
		table.insert(PIGA["Tardis"]["Invite"]["Template"],{fujiF.topF.SaveTemplate.F.E:GetText(),fujiF.Datas_MB})
		fujiF.topF.SaveTemplate.F:Hide()
	end)
	fujiF.topF.SaveTemplate.F.OffBut=PIGButton(fujiF.topF.SaveTemplate.F,{"BOTTOM",fujiF.topF.SaveTemplate.F,"BOTTOM", 50,30},{50,24},"取消")
	fujiF.topF.SaveTemplate.F.OffBut:SetScript("OnClick", function (self)
		fujiF.topF.SaveTemplate.F:Hide()
	end)
	---转换团队/小队
	fujiF.topF.zhuanhuanPR=PIGButton(fujiF.topF,{"LEFT",fujiF.topF.SaveTemplate,"RIGHT", 30,0},{80,20},"转为团队")
	fujiF.topF.zhuanhuanPR:SetScript("OnClick", function (self)
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			ConvertToParty() 
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			ConvertToRaid()
		end
	end)
	function fujiF.topF.zhuanhuanPR:Update_ButText()
		if fujiF.topF.zhuanhuanPR:IsShown() then
			if IsInRaid(LE_PARTY_CATEGORY_HOME) then
				self:SetText("转为小队")
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				self:SetText("转为团队")
			end
		end
	end
	---职责确认
	fujiF.topF.RolesJC=PIGButton(fujiF.topF,{"LEFT",fujiF.topF.zhuanhuanPR,"RIGHT", 30,0},{90,20},"职责确认")
	fujiF.topF.RolesJC:SetScript("OnClick", function (self)
		if PIG_MaxTocversion(20000) then
			LFGListingRolePollButton_OnClick(self, button)
		elseif PIG_MaxTocversion(30000) then
			LFGListingRolePollButton_OnClick(self, button)
		else
			InitiateRolePoll()
		end
	end)
	---就位确认
	fujiF.topF.jiuwei=PIGButton(fujiF.topF,{"LEFT",fujiF.topF.RolesJC,"RIGHT", 30,0},{90,20},"就位确认")
	fujiF.topF.jiuwei:SetScript("OnClick", function (self)
		DoReadyCheck()
	end)
	---刷新
	fujiF.topF.shuaxinP=PIGButton(fujiF.topF,{"LEFT",fujiF.topF.jiuwei,"RIGHT", 30,0},{110,20},"刷新成员信息")
	fujiF.topF.shuaxinP:SetScript("OnClick", function (self)
		fujiF:_GetNumGroupMembers()
		fujiF:Update_ShowList()
	end)
	fujiF.topF:HookScript("OnShow", function(self)
		fujiF:_GetNumGroupMembers()
		fujiF:Update_ShowList()
	end);
	------
	fujiF.Datas_MB=InitializationData(PIGA["Tardis"]["Invite"]["DQMubiao"],true)
	fujiF.Datas_DQ=InitializationData()
	fujiF.Datas_DQName={}
	fujiF.PlayerNum_MB={["All"]=0,["Role"]={}};
	fujiF.PlayerNum_DQ={["All"]=0,["Role"]={}};
	--更新人数显示
	function fujiF:Update_Data()
		self.PlayerNum_MB.All=0
		wipe(self.PlayerNum_MB.Role)
		for xulie=1,#Roles_List do
			self.PlayerNum_MB.Role[xulie]=0
			for id=1,#Roles_List[xulie] do
				self.PlayerNum_MB.All=self.PlayerNum_MB.All+self.Datas_MB[xulie][id]
				self.PlayerNum_MB.Role[xulie]=self.PlayerNum_MB.Role[xulie]+self.Datas_MB[xulie][id]
			end
		end
		---
		self.PlayerNum_DQ.All=0
		wipe(self.PlayerNum_DQ.Role)
		for xulie=1,#Roles_List do
			self.PlayerNum_DQ.Role[xulie]=0
			for id=1,#Roles_List[xulie] do
				self.PlayerNum_DQ.All=self.PlayerNum_DQ.All+self.Datas_DQ[xulie][id]
				self.PlayerNum_DQ.Role[xulie]=self.PlayerNum_DQ.Role[xulie]+self.Datas_DQ[xulie][id]
			end
		end
	end
	function fujiF:Update_ShowList()
		self:Update_Data()
		if not self.topF:IsVisible() then return end
		for xulie=1,#Roles_List do
			for id=1,#Roles_List[xulie] do
				self.topF.RoleButList[xulie].mubiao_EBut[id]:SetText(self.Datas_MB[xulie][id])
			end
			self.topF.RoleButList[xulie].mubiaoAll_V:SetText(self.PlayerNum_MB.Role[xulie])
		end
		self.topF.playerNumV_max:SetText(self.PlayerNum_MB.All)
		---
		for xulie=1,#Roles_List do
			for id=1,#Roles_List[xulie] do
				local fujiku = self.topF.RoleButList[xulie].mubiao_EBut[id]
				fujiku.yizu:SetText(self.Datas_DQ[xulie][id])
				fujiku.wancheng:Hide()
				if self.Datas_DQ[xulie][id]==self.Datas_MB[xulie][id] then
					fujiku.wancheng:Show()
					fujiku.wancheng:SetTexture("interface/raidframe/readycheck-ready.blp");
				elseif self.Datas_DQ[xulie][id]<self.Datas_MB[xulie][id] then
					fujiku.wancheng:Show()
					fujiku.wancheng:SetTexture("interface/raidframe/readycheck-notready.blp");
				elseif self.Datas_DQ[xulie][id]>self.Datas_MB[xulie][id] then
					fujiku.wancheng:Show()
					fujiku.wancheng:SetTexture(136815);
				end	
			end
			self.topF.RoleButList[xulie].dangqianAll_V:SetText(self.PlayerNum_DQ.Role[xulie])
		end
		self.topF.playerNumV:SetText(self.PlayerNum_DQ.All)
	end
	--获取当前人员/人数
	function fujiF:_GetNumGroupMembers()
		for xulie=1,#Roles_List do
			for id=1,#Roles_List[xulie] do
				self.Datas_DQ[xulie][id]=0
			end
		end
		wipe(self.Datas_DQName)
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			self.topF.zhuanhuanPR:Enable()
			self.topF.RolesJC:Enable()
			self.topF.jiuwei:Enable()
			self.topF.shuaxinP:Enable()
		else
			self.topF.zhuanhuanPR:Disable()
			self.topF.RolesJC:Disable()
			self.topF.jiuwei:Disable()
			self.topF.shuaxinP:Disable()
		end
		self.topF.zhuanhuanPR:Update_ButText()
		local NewZhiyeData={};
		for p=1,MAX_RAID_MEMBERS do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(p);
			if name then
				NewZhiyeData[name]={fileName,combatRole}
			end
		end
		for xulie=1,#Roles_List do
			self.Datas_DQName[xulie]={}
			for id=1,#Roles_List[xulie] do
				self.Datas_DQName[xulie][id]={}
				for k,v in pairs(NewZhiyeData) do
					if v[1]==Roles_List[xulie][id][1] then
						if v[2]==Roles[xulie] then
							self.Datas_DQ[xulie][id]=self.Datas_DQ[xulie][id]+1
							table.insert(self.Datas_DQName[xulie][id],{k,fileName})
						end
					end
				end
			end
		end
		self:Update_ShowList()
	end
	---底部设置===================
	fujiF.botF = PIGFrame(fujiF,{"TOPLEFT",fujiF.topF,"BOTTOMLEFT",4,0});
	fujiF.botF:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -4, 4);
	fujiF.botF:PIGSetBackdrop(0)
	--喊话内容
	fujiF.botF.YellF = PIGFrame(fujiF.botF,{"TOPLEFT", fujiF.botF, "TOPLEFT", 4,-22});
	fujiF.botF.YellF:SetPoint("BOTTOMLEFT", fujiF.botF, "BOTTOMLEFT", -200, 4);
	fujiF.botF.YellF:SetWidth(300)
	fujiF.botF.YellF:PIGSetBackdrop()
	fujiF.botF.YellF.biaoti = PIGFontString(fujiF.botF.YellF,{"BOTTOMLEFT", fujiF.botF.YellF, "TOPLEFT", 2,4},"喊话内容");
	fujiF.botF.YellF.biaoti:SetTextColor(0, 1, 0, 1);
	fujiF.botF.YellF.zifulenNum = PIGFontString(fujiF.botF.YellF,{"BOTTOMLEFT", fujiF.botF.YellF.biaoti, "BOTTOMRIGHT", 4,0});
	fujiF.botF.YellF.zifulenErr = PIGFontString(fujiF.botF.YellF,{"LEFT", fujiF.botF.YellF.zifulenNum, "RIGHT", 0,0});
	fujiF.botF.YellF.Instruction = PIGFontString(fujiF.botF.YellF,{"TOPLEFT", fujiF.botF.YellF, "TOPLEFT", 2,-2},"在此输入喊话内容");
	fujiF.botF.YellF.Instruction:SetTextColor(0.4, 0.4, 0.4, 1);
	fujiF.botF.YellF.E = CreateFrame("EditBox", nil, fujiF.botF.YellF);
	fujiF.botF.YellF.E:SetPoint("TOPLEFT", fujiF.botF.YellF, "TOPLEFT", 4,-2);
	fujiF.botF.YellF.E:SetPoint("BOTTOMRIGHT", fujiF.botF.YellF, "BOTTOMRIGHT", -4,2);
	fujiF.botF.YellF.E:SetFontObject(ChatFontNormal);
	fujiF.botF.YellF.E:SetAutoFocus(false);
	fujiF.botF.YellF.E:SetMultiLine(true)
	fujiF.botF.YellF.E:SetMaxLetters(255);
	PigSetEditBoxData(fujiF.botF.YellF.E,PIGA["Tardis"]["Invite"]["YellMsg"])
	fujiF.botF.YellF.E:HookScript("OnTextChanged", function(self)
		if #self:GetText()>0 then
			fujiF.botF.YellF.Instruction:Hide()
		else
			fujiF.botF.YellF.Instruction:Show()
		end
		local famsg,msglen = Get_famsg("yell",self:GetText(),PIGA["Tardis"]["Invite"]["CMD_Msg"],PIGA["Tardis"]["Invite"]["CMD"])
		if IsEditBoxNumber(famsg,msglen,fujiF.botF.YellF.zifulenNum,fujiF.botF.YellF.zifulenErr,fujiF.botF.YellF.SaveYellTemp) then
			PIGA["Tardis"]["Invite"]["YellMsg"]=self:GetText()
		end
	end);
	if ContainerFrameItemButton_OnModifiedClick then
		hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
			if button=="LeftButton" and IsShiftKeyDown() then
		        local itemLink = GetContainerItemLink(self:GetParent():GetID(), self:GetID())
		        if itemLink and fujiF.botF.YellF.E:IsVisible() then
		            fujiF.botF.YellF.E:Insert(itemLink)
		        end
			end
		end)
	else
		hooksecurefunc(ContainerFrameItemButtonMixin, "OnClick", function(self,button)
			if button=="LeftButton" and IsShiftKeyDown() then
		        local itemLink = GetContainerItemLink(self:GetParent():GetID(), self:GetID())
		        if itemLink and fujiF.botF.YellF.E:IsVisible() then
		            fujiF.botF.YellF.E:Insert(itemLink)
		        end
			end
		end)	
	end
	fujiF.botF.YellF.SaveYellTemp = PIGButton(fujiF.botF.YellF,{"TOPRIGHT",fujiF.botF.YellF,"TOPRIGHT",110,0.4},{100,19},"保存为模板");
	fujiF.botF.YellF.SaveYellTemp:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end)
	fujiF.botF.YellF.SaveYellTemp.F = PIGFrame(fujiF.botF.YellF.SaveYellTemp,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp,"TOP",0,1});
	fujiF.botF.YellF.SaveYellTemp.F:SetSize(250,160)
	fujiF.botF.YellF.SaveYellTemp.F:PIGSetBackdrop(1)
	fujiF.botF.YellF.SaveYellTemp.F:SetFrameLevel(fujiF.botF.YellF.SaveYellTemp.F:GetFrameLevel()+5)
	fujiF.botF.YellF.SaveYellTemp.F:Hide()
	fujiF.botF.YellF.SaveYellTemp.F.TT = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOP", fujiF.botF.YellF.SaveYellTemp.F, "TOP", 0,-6},"保存当前喊话为模板", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.Name = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOPLEFT", fujiF.botF.YellF.SaveYellTemp.F, "TOPLEFT", 6,-50},"模版名:", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.E = CreateFrame("EditBox", nil, fujiF.botF.YellF.SaveYellTemp.F, "InputBoxInstructionsTemplate");
	fujiF.botF.YellF.SaveYellTemp.F.E:SetSize(180,zhiye_but_H);
	fujiF.botF.YellF.SaveYellTemp.F.E:SetMaxLetters(20)
	fujiF.botF.YellF.SaveYellTemp.F.E:SetPoint("LEFT", fujiF.botF.YellF.SaveYellTemp.F.Name, "RIGHT", 4,0);
	PIGSetFont(fujiF.botF.YellF.SaveYellTemp.F.E,14,"OUTLINE")
	fujiF.botF.YellF.SaveYellTemp.F.E:HookScript("OnShow", function(self)
		Create.Update_SaveTempF(fujiF.botF.YellF.SaveYellTemp.F,fujiF.botF.YellF.E:GetText():gsub(" ", ""))
	end)
	fujiF.botF.YellF.SaveYellTemp.F.E:HookScript("OnTextChanged", function(self)
		Create.Update_SaveTempF(fujiF.botF.YellF.SaveYellTemp.F,fujiF.botF.YellF.E:GetText():gsub(" ", ""))
	end)
	fujiF.botF.YellF.SaveYellTemp.F.error = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOPLEFT", fujiF.botF.YellF.SaveYellTemp.F.E, "BOTTOMLEFT", 6,-2},"", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.error:SetTextColor(1, 0, 0, 1)
	fujiF.botF.YellF.SaveYellTemp.F.SaveBut=PIGButton(fujiF.botF.YellF.SaveYellTemp.F,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp.F,"BOTTOM", -50,30},{50,24},"保存")
	fujiF.botF.YellF.SaveYellTemp.F.SaveBut:SetScript("OnClick", function (self)
		for ixx=1,#PIGA["Tardis"]["Invite"]["YellTemp"] do
			if PIGA["Tardis"]["Invite"]["YellTemp"][ixx][1]==fujiF.botF.YellF.SaveYellTemp.F.E:GetText() then
				PIGA["Tardis"]["Invite"]["YellTemp"][ixx][2]=fujiF.botF.YellF.E:GetText()
				fujiF.botF.YellF.SaveYellTemp.F:Hide()
				return
			end
		end
		table.insert(PIGA["Tardis"]["Invite"]["YellTemp"],{fujiF.botF.YellF.SaveYellTemp.F.E:GetText(),fujiF.botF.YellF.E:GetText()})
		fujiF.botF.YellF.SaveYellTemp.F:Hide()
	end)
	fujiF.botF.YellF.SaveYellTemp.F.OffBut=PIGButton(fujiF.botF.YellF.SaveYellTemp.F,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp.F,"BOTTOM", 50,30},{50,24},"取消")
	fujiF.botF.YellF.SaveYellTemp.F.OffBut:SetScript("OnClick", function (self)
		fujiF.botF.YellF.SaveYellTemp.F:Hide()
	end)
	--喊话模板
	fujiF.botF.YellF.YellTemp=PIGDownMenu(fujiF.botF.YellF,{"TOPLEFT",fujiF.botF.YellF.SaveYellTemp,"BOTTOMLEFT",0,-4},{100,22})
	fujiF.botF.YellF.YellTemp:PIGDownMenu_SetText("喊话模板")
	function fujiF.botF.YellF.YellTemp:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for ixx=1,#PIGA["Tardis"]["Invite"]["YellTemp"] do
			info.text, info.arg1 = PIGA["Tardis"]["Invite"]["YellTemp"][ixx][1], PIGA["Tardis"]["Invite"]["YellTemp"][ixx][2]
		    info.notCheckable = true;
		    self:PIGDownMenu_AddButton(info)
		end
	end
	function fujiF.botF.YellF.YellTemp:PIGDownMenu_SetValue(value,arg1,arg2,checked,button)
		if button=="LeftButton" then
			fujiF.botF.YellF.E:SetText(arg1)
		else
			for ixx=#PIGA["Tardis"]["Invite"]["YellTemp"],1,-1 do
				if value == PIGA["Tardis"]["Invite"]["YellTemp"][ixx][1] then
					table.remove(PIGA["Tardis"]["Invite"]["YellTemp"],ixx)
					break
			   	end
			end
		end
		PIGCloseDropDownMenus()
	end
	--指令邀请
	local invtisp = "喊话内容附加进组暗号，玩家回复暗号将触发自动回复\n|cffFF0000需开启《自动回复/邀请》|r"
	fujiF.botF.jinzuCMD_inv = PIGCheckbutton(fujiF.botF,{"TOPLEFT",fujiF.botF.YellF.YellTemp,"BOTTOMLEFT",0,-8},{"喊话",invtisp})
	fujiF.botF.jinzuCMD_inv:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Invite"]["CMD_Msg"]=true;
		else
			PIGA["Tardis"]["Invite"]["CMD_Msg"]=false;
		end
		local famsg,msglen = Get_famsg("yell",fujiF.botF.YellF.E:GetText(),PIGA["Tardis"]["Invite"]["CMD_Msg"],PIGA["Tardis"]["Invite"]["CMD"])
		IsEditBoxNumber(famsg,msglen,fujiF.botF.YellF.zifulenNum,fujiF.botF.YellF.zifulenErr,fujiF.botF.YellF.SaveYellTemp)
	end);
	--进组指令
	fujiF.botF.jinzuCMDE_T = PIGFontString(fujiF.botF,{"LEFT",fujiF.botF.jinzuCMD_inv.Text,"RIGHT",0,0},"进组暗号");
	fujiF.botF.jinzuCMDE = CreateFrame("EditBox", nil, fujiF.botF,"InputBoxInstructionsTemplate");
	fujiF.botF.jinzuCMDE:SetSize(60,26);
	fujiF.botF.jinzuCMDE:SetPoint("LEFT",fujiF.botF.jinzuCMDE_T,"RIGHT",6,0);
	fujiF.botF.jinzuCMDE:SetFontObject(ChatFontNormal);
	fujiF.botF.jinzuCMDE:SetMaxLetters(6)
	fujiF.botF.jinzuCMDE:SetAutoFocus(false);
	PigSetEditBoxData(fujiF.botF.jinzuCMDE,PIGA["Tardis"]["Invite"]["CMD"])
	fujiF.botF.jinzuCMDE:HookScript("OnEditFocusGained", function(self) 
		self:HighlightText()
	end);
	fujiF.botF.jinzuCMDE:HookScript("OnTextChanged", function(self)
		PIGA["Tardis"]["Invite"]["CMD"]=self:GetText()
	end);

	--喊话按钮
	fujiF.botF.yellbut = PIGButton(fujiF.botF,{"BOTTOMLEFT",fujiF.botF.YellF,"BOTTOMRIGHT",4,10},{100,25},SEND_LABEL..L["TARDIS_YELL"]);
	fujiF.botF.yellbut:SetScript("OnClick", function (self)
		fujiF.Kaishi_Yell()
	end);
	--喊话频道
	fujiF.botF.Yell_CHANNEL=PIGDownMenu(fujiF.botF,{"LEFT",fujiF.botF.yellbut,"RIGHT",4,0},{70,25})
	fujiF.botF.Yell_CHANNEL:PIGDownMenu_SetText(CHANNEL)
	function fujiF.botF.Yell_CHANNEL:PIGDownMenu_Update_But()
		fujiF.PindaoList=GetPindaoList()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#fujiF.PindaoList,1 do
		    info.text, info.arg1 = fujiF.PindaoList[i][1], fujiF.PindaoList[i][2]
		    info.checked = PIGA["Tardis"]["Invite"]["Yell_CHANNEL"][fujiF.PindaoList[i][2]]
		    info.isNotRadio=true
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.botF.Yell_CHANNEL:PIGDownMenu_SetValue(value,arg1,arg2,checked)
		PIGA["Tardis"]["Invite"]["Yell_CHANNEL"][arg1]=checked
		PIGCloseDropDownMenus()
	end
	fujiF.botF:HookScript("OnShow", function(self)
		self.YellF.E:SetText(PIGA["Tardis"]["Invite"]["YellMsg"])
		self.jinzuCMD_inv:SetChecked(PIGA["Tardis"]["Invite"]["CMD_Msg"])
	end);
	fujiF.Yell_CD=10
	fujiF.PindaoList={}
	local function hanhuadaojishiTime()
		if fujiF.hanhuadaojishi>0 then
			fujiF.botF.yellbut:SetText(ON_COOLDOWN.."("..fujiF.hanhuadaojishi..")");
			C_Timer.After(1,hanhuadaojishiTime)
			fujiF.hanhuadaojishi=fujiF.hanhuadaojishi-1
		else
			fujiF.botF.yellbut:Enable() 
			fujiF.botF.yellbut:SetText(SEND_LABEL..L["TARDIS_YELL"]);
		end
	end
	function fujiF.Kaishi_Yell(DesktopUI)
		local yellpindaolist =GetYellPindao(fujiF.PindaoList,PIGA["Tardis"]["Invite"]["Yell_CHANNEL"])
		local keyongshu = #yellpindaolist
		if keyongshu>0 then
			local famsg =Get_famsg("yell",PIGA["Tardis"]["Invite"]["YellMsg"],PIGA["Tardis"]["Invite"]["CMD_Msg"],PIGA["Tardis"]["Invite"]["CMD"])
			for x=1,#yellpindaolist do
				local suijishu=random(1, 8)
				local famsg = famsg..MSGsuijizifu[suijishu]
				SendChatMessage(famsg,yellpindaolist[x][1],nil,yellpindaolist[x][2])
			end
			fujiF.hanhuadaojishi=fujiF.Yell_CD*keyongshu
			fujiF.botF.yellbut:Disable();
			fujiF.botF.yellbut:SetText(L["TARDIS_YELL"].."("..fujiF.hanhuadaojishi..")");
			fujiF.DesktopUI.Cooldown:SetCooldown(GetTime(), fujiF.Yell_CD*keyongshu)
			hanhuadaojishiTime()
		else
			PIG_OptionsUI:ErrorMsg("请先选择喊话频道");
		end
	end

	----自动邀请
	local roleKeyList={
		"T,坦,熊,防骑,FQ",
		"N,奶,治疗",
		"DPS,dps,伤害,输出,KBZ,kbz,狂暴,惩戒,电萨,鸟德,鸟D",
	}
	fujiF.roleKeyTable={{},{},{}}
	local function GetroleKeyTable(roleID)
		local keyslist=PIGA["Tardis"]["Invite"] and PIGA["Tardis"]["Invite"][Roles[roleID]] or roleKeyList[roleID]
		fujiF.roleKeyTable[roleID] = Key_fenge(keyslist, ",", true)
	end
	local function SaveKeyTXT(Newtxt,roleID)
		local Newtxt = Newtxt:gsub(" ", "")
		local Newtxt = Newtxt:gsub("，", ",")
		if Newtxt=="" or Newtxt==roleKeyList[roleID] then
			PIGA["Tardis"]["Invite"][Roles[roleID]]=nil
		else
			PIGA["Tardis"]["Invite"][Roles[roleID]]=self:GetText()
		end
		GetroleKeyTable(roleID)
	end
	--职责判断关键则
	local function ADD_KeyEditBox(roleID)
		GetroleKeyTable(roleID)
		local KeyF=PIGFrame(fujiF.botF)
		KeyF:PIGSetBackdrop(0,0.6,nil,{1, 1, 0})
		KeyF.biaoti = PIGFontString(KeyF,{"BOTTOMLEFT", KeyF, "TOPLEFT", 4,4},_G[Roles[roleID]].."判断(用,分隔):","OUTLINE");
		KeyF.biaoti:SetTextColor(0,1,0,1)
		KeyF.E = CreateFrame("EditBox", nil, KeyF);
		KeyF.E:SetPoint("TOPLEFT", KeyF, "TOPLEFT", 2,-1);
		KeyF.E:SetPoint("BOTTOMRIGHT", KeyF, "BOTTOMRIGHT", -2,1);
		KeyF.E:SetFontObject(ChatFontNormal);
		KeyF.E:SetAutoFocus(false);
		KeyF.E:SetMaxLetters(40);
		if roleID==3 then KeyF.E:SetMultiLine(true) end
		KeyF.E:SetTextColor(0.7, 0.7, 0.7, 1);
		KeyF.E:SetScript("OnShow", function(self) 
			self:SetText(PIGA["Tardis"]["Invite"] and PIGA["Tardis"]["Invite"][Roles[roleID]] or roleKeyList[roleID]);
		end);
		KeyF.E:SetScript("OnEditFocusGained", function(self) 
			self:SetTextColor(1, 1, 1, 1);
		end);
		KeyF.E:SetScript("OnEditFocusLost", function(self)
			self:SetTextColor(0.5, 0.5, 0.5, 1);
		end);
		KeyF.E:SetScript("OnEscapePressed", function(self) 
			self:ClearFocus()
		end);
		KeyF.E:HookScript("OnTextChanged", function(self)
			SaveKeyTXT(self:GetText(),roleID)
		end)
		KeyF.E:SetScript("OnEnterPressed", function(self) 
			self:ClearFocus()
		end);
		return KeyF
	end
	fujiF.botF[Roles[1]]=ADD_KeyEditBox(1)
	fujiF.botF[Roles[1]]:SetSize(170,22)
	fujiF.botF[Roles[1]]:SetPoint("TOPLEFT", fujiF.botF, "TOPLEFT", 510,-22);
	fujiF.botF[Roles[2]]=ADD_KeyEditBox(2)
	fujiF.botF[Roles[2]]:SetSize(170,22)
	fujiF.botF[Roles[2]]:SetPoint("LEFT", fujiF.botF[Roles[1]], "RIGHT", 10,0);
	fujiF.botF[Roles[3]]=ADD_KeyEditBox(3)
	fujiF.botF[Roles[3]]:SetSize(350,42)
	fujiF.botF[Roles[3]]:SetPoint("TOPLEFT", fujiF.botF[Roles[1]], "TOPLEFT", 0,-42);
	---
	fujiF.botF.AutoYaoqing = PIGButton(fujiF.botF,{"BOTTOMLEFT",fujiF.botF,"BOTTOMLEFT",520,15},{130,24},"自动回复/邀请"); 
	PIGEnter(fujiF.botF.AutoYaoqing,"检测到进组暗号后自动询问职业职责，符合预设条件即邀请进组，达到预设人数将停止邀请")
	fujiF.botF.AutoYaoqing.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",8,0);
	fujiF.botF.AutoYaoqing.Text:SetTextColor(0, 1, 1, 1);
	fujiF.botF.AutoYaoqing.Tex = fujiF.botF.AutoYaoqing:CreateTexture(nil, "BORDER");
	fujiF.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
	fujiF.botF.AutoYaoqing.Tex:SetPoint("RIGHT",fujiF.botF.AutoYaoqing.Text,"LEFT",0,-1);
	fujiF.botF.AutoYaoqing.Tex:SetSize(23,23);
	fujiF.botF.AutoYaoqing:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",9.5,-1.5);
		end
	end);
	fujiF.botF.AutoYaoqing:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",8,0);
		end
	end);
	fujiF.botF.AutoYaoqing:SetScript("OnClick", function (self)
		fujiF:StartAutoInviteFun()
	end)
	--桌面提示
	local LFGIW = 40
	local LFGIconUI = CreateFrame("Button", nil, UIParent);
	LFGIconUI:SetSize(LFGIW,LFGIW);
	LFGIconUI:SetPoint("TOP",UIParent,"TOP",0,-70);
	LFGIconUI:Hide()
	LFGIconUI:RegisterForClicks("LeftButtonUp","RightButtonUp")
	fujiF.DesktopUI=LFGIconUI
	LFGIconUI.Cooldown = CreateFrame("Cooldown", nil, LFGIconUI, "CooldownFrameTemplate")
	LFGIconUI.Cooldown:SetAllPoints()
	LFGIconUI.Texture = LFGIconUI:CreateTexture()
	LFGIconUI.Texture:SetTexture(136317);
	LFGIconUI.Texture:SetSize(LFGIW*1.3,LFGIW*1.3);
	LFGIconUI.Texture:SetPoint("CENTER", 0, 0);
	local EyeTemplate_OnUpdate= EyeTemplate_OnUpdate or function(self, elapsed)
		local textureInfo = LFG_EYE_TEXTURES[self.queueType or "default"];
		AnimateTexCoords(self.Texture, textureInfo.width, textureInfo.height, textureInfo.iconSize, textureInfo.iconSize, textureInfo.frames, elapsed, textureInfo.delay)
	end
	local EyeTemplate_StartAnimating= EyeTemplate_StartAnimating or function(eye)
		eye:SetScript("OnUpdate", EyeTemplate_OnUpdate);
	end
	local EyeTemplate_StopAnimating= EyeTemplate_StopAnimating or function(eye)
		eye:SetScript("OnUpdate", nil);
		local textureInfo = LFG_EYE_TEXTURES[eye.queueType or "default"];
		eye.Texture:SetTexCoord(0, textureInfo.iconSize / textureInfo.width, 0, textureInfo.iconSize / textureInfo.height);
	end
	LFGIconUI:HookScript("OnClick", function(self,button)
		if button=="LeftButton" then
			if self.Cooldown:GetCooldownDuration()>0 then
				PIG_OptionsUI:ErrorMsg(ERR_CHAT_THROTTLED);
			else
				fujiF.Kaishi_Yell()
			end	
		else
			if _G[GnUI]:IsShown() then
				_G[GnUI]:Hide()
			else
				_G[GnUI]:Show()
				Create.Show_TabBut_R(InvF.F,fujiF,fujiTabBut)
			end
		end
	end);
	--根据指令邀请
	local function OFF_autoInvite(msg)
		PIG_OptionsUI.AutoInvite.Invite=nil;
		fujiF.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
		fujiF:UnregisterEvent("CHAT_MSG_WHISPER");
		fujiF:UnregisterEvent("CHAT_MSG_SYSTEM");
		PIG_OptionsUI:ErrorMsg(msg);
		EyeTemplate_StopAnimating(LFGIconUI)
		LFGIconUI:Hide()
	end
	--判断是否是队长/团长/助理
	function fujiF.Is_GroupLeader(laiyuan)
		if IsInGroup() then
			local isLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME);
			local isTrue = UnitIsGroupAssistant("player", LE_PARTY_CATEGORY_HOME);
			if not isLeader and not isTrue then
				if laiyuan~="event" then
					OFF_autoInvite("你不是队长/团长/助理,自动邀请已关闭")
				end
				return false
			end
		end
		return true
	end
	function fujiF.Is_RaidNumOK(laiyuan)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers>=fujiF.PlayerNum_MB.All then
			if laiyuan~="event" then
				OFF_autoInvite("已达目标人数,自动邀请已关闭")
			end
			return false
		end
		return true,numGroupMembers
	end
	function fujiF:StartAutoInviteFun()
		if PIG_OptionsUI:IsAutoInviteOpen("Invite") then
			return	
		end
		if PIG_OptionsUI.AutoInvite.Invite then
			OFF_autoInvite("已|cffFF0000关闭|r自动邀请")
		else
			if self.Is_GroupLeader() and self.Is_RaidNumOK() then
				PIG_OptionsUI.AutoInvite.Invite=true
				self.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp");
				self:RegisterEvent("CHAT_MSG_WHISPER");
				self:RegisterEvent("CHAT_MSG_SYSTEM")
				PIG_OptionsUI:ErrorMsg("已|cff00FF00开启|r自动邀请");
				LFGIconUI:Show()

				EyeTemplate_StartAnimating(LFGIconUI)
			end
		end
	end
	--------
	local function PIG_Invite_Fun(Pname)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers==5 and not IsInRaid(LE_PARTY_CATEGORY_HOME) then
			ConvertToRaid()
		end
		PIG_InviteUnit(Pname)
	end
	function fujiF.IsRoleKeys(arg1)		
		for roldid=1,#fujiF.roleKeyTable do
			for Keytxt=1,#fujiF.roleKeyTable[roldid] do
				if arg1:match(fujiF.roleKeyTable[roldid][Keytxt]) then
					return roldid
				end
			end
		end
		return false
	end
	--添加临时会话人，60秒后无沟通则删除
	function fujiF:AddCommunication(name)
	    self.TemporaryPlayer[name] = GetTime()
	    if self.PlayerTimers[name] then
	        self.PlayerTimers[name]:Cancel()
	    end
	    self.PlayerTimers[name] = C_Timer.NewTimer(60, function()
	        if self.TemporaryPlayer[name] then
	           self.TemporaryPlayer[name] = nil
	        end
	    end)
	end
	--
	local Err_already=ERR_ALREADY_IN_GROUP_S:gsub("%%s","")
	fujiF.TemporaryPlayer={};
	fujiF.PlayerTimers = {}
	fujiF.MultiRoles = {{},""}
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")	
	fujiF:HookScript("OnEvent",function(self,event,arg1,arg2,_,_,arg5,_,_,_,_,_,_,arg12)
		if event=="PLAYER_ENTERING_WORLD" then
			self:_GetNumGroupMembers()
			self:RegisterEvent("GROUP_ROSTER_UPDATE")
			C_Timer.After(3,function()
				self.PindaoList=GetPindaoList()
			end)
		elseif event=="GROUP_ROSTER_UPDATE" then
			C_Timer.After(0.4,function()
				self:_GetNumGroupMembers()
				self.Is_GroupLeader("event")
				self.Is_RaidNumOK("event")
			end)
		elseif PIG_OptionsUI.AutoInvite.Invite then
			if arg1:match("[!Pig]") then return end
			if event=="CHAT_MSG_SYSTEM" then
				if arg1:match(Err_already) then
					local errPlayer=arg1:gsub(Err_already,"")
					if errPlayer and errPlayer~="" then
						SendChatMessage("[!Pig] 你已有队伍，请退组后再M", "WHISPER", nil, errPlayer);
					end
				end
			elseif event=="CHAT_MSG_WHISPER" then
				local localizedClass, englishClass= GetPlayerInfoByGUID(arg12)
				if arg1==PIGA["Tardis"]["Invite"]["CMD"] then
					local xulieIDList = cl_Name_Role[englishClass]
					local zhizeNum = #xulieIDList
					if zhizeNum==1 then--玩家职业只有一个职责，直接判断职业缺数
						local RoleIndex = RolesXulie[cl_Name_Role[englishClass][1]]
						local ClassRoleKeyList = Roles_List[RoleIndex]
						for id=1,#ClassRoleKeyList do
							if ClassRoleKeyList[id][1]==englishClass then
								if self.Datas_DQ[RoleIndex][id]<self.Datas_MB[RoleIndex][id] then
									SendChatMessage("[!Pig] 邀请你入队，你得职责：".._G[Roles[RoleIndex]], "WHISPER", nil, arg2);
									PIG_Invite_Fun(arg2)
								else
									SendChatMessage("[!Pig] "..localizedClass .. "已满，请换其他职业，感谢支持", "WHISPER", nil, arg2);
								end
								break
							end	
						end
					elseif zhizeNum>1 then--玩家职业多个职责
						wipe(self.MultiRoles[1])	
						for xu=1,#xulieIDList do
							local RolesName = xulieIDList[xu]
							local RoleIndex = RolesXulie[RolesName]
							local RoleClassList = Roles_List[RoleIndex]
							for idc=1,#RoleClassList do				
								if RoleClassList[idc][1]==englishClass then
									if self.Datas_DQ[RoleIndex][idc]<self.Datas_MB[RoleIndex][idc] then
										table.insert(self.MultiRoles[1],RolesName)
									end
								end	
							end
						end
						if #self.MultiRoles[1]>0 then
							self.MultiRoles[2]=localizedClass.."尚缺:";
							for img=1,#self.MultiRoles[1] do
								self.MultiRoles[2]=self.MultiRoles[2].._G[self.MultiRoles[1][img]]..","
							end
							SendChatMessage("[!Pig] "..self.MultiRoles[2].."请回复职责", "WHISPER", nil, arg2);
							self:AddCommunication(arg2)
						end
					end
				else
					if self.TemporaryPlayer[arg2] then--已经激活过暗号
						local RoleIndex = self.IsRoleKeys(arg1)--获取聊天内容包含职责序列
						if RoleIndex then
							local ClassRoleKeyList = Roles_List[RoleIndex]
							for idc=1,#ClassRoleKeyList do
								if ClassRoleKeyList[idc][1]==englishClass then
									if self.Datas_DQ[RoleIndex][idc]<self.Datas_MB[RoleIndex][idc] then
										SendChatMessage("[!Pig] 邀请你入队，你得职责：".._G[Roles[RoleIndex]], "WHISPER", nil, arg2);
										PIG_Invite_Fun(arg2)
									else
										SendChatMessage("[!Pig] ".._G[Roles[RoleIndex]]..localizedClass .. "已满，可换天赋或其他职业，感谢支持", "WHISPER", nil, arg2);
									end
									break
								end	
							end
						end
					end
				end
			end
		end
	end)
end