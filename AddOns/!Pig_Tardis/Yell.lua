local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L= unpack(PIG)
------------------------
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGQuickBut=Create.PIGQuickBut
local PIGSetFont=Create.PIGSetFont
-- ------------------
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Yell(Activate)
	if not PIGA["Tardis"]["Yell"]["Open"] then return end
	local InviteUnit=InviteUnit or C_PartyInfo and C_PartyInfo.InviteUnit
	local ConvertToParty=ConvertToParty or C_PartyInfo and C_PartyInfo.ConvertToParty
	local ConvertToRaid=ConvertToRaid or C_PartyInfo and C_PartyInfo.ConvertToRaid
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local sub = _G.string.sub
	local gsub = _G.string.gsub
	local match = _G.string.match
	local GetPindaoList=Fun.GetPindaoList
	local GetYellPindao=Fun.GetYellPindao
	local Key_fenge=Fun.Key_fenge
	local Get_famsg=Fun.Get_famsg
	local cl_Name=Data.cl_Name
	local cl_Name_Role=Data.cl_Name_Role
	local zhizeIcon=Data.zhizeIcon
	local MSGsuijizifu=Data.MSGsuijizifu
	---
	local InvF=_G[GnUI]
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_YELL"],80,"Bot")
	if Activate then
		fujiF:Show()
		fujiTabBut:Selected()
	end
	fujiF.hanhuajiange=10
	fujiF.PindaoList={}
	--=====================
	local Roles = {"TANK", "HEALER","DAMAGER"}
	local RolesXulie = {["TANK"]=1, ["HEALER"]=2,["DAMAGER"]=3}
	local Roles_List={{},{},{}};
	
	local zhiye_F_H,zhiye_but_H=90,20
	--提取职业职责信息
	local function tiquzhize(id)
		for i=1,#cl_Name do
			local zhize = cl_Name[i][2]
			for ii=1,#zhize do
				if Roles[id]==zhize[ii] then
					table.insert(Roles_List[id],{cl_Name[i][1],cl_Name[i][3]})
				end
			end
		end
	end
	tiquzhize(1)
	tiquzhize(2)
	tiquzhize(3)
	---
	local fubenMoshi ={10,15,20,25,40};
	local fubenMoshi_peizhi = {}
	if tocversion<20000 then
		local englishFaction = UnitFactionGroup("player")
		if englishFaction=="Alliance" then
			for id=1,#Roles_List do
				for ix=#Roles_List[id],1,-1 do
					if Roles_List[id][ix][1]=="SHAMAN" then
						table.remove(Roles_List[id],ix)
					end
				end
			end
			fubenMoshi_peizhi ={
				[10]={
					[1]={2},
					[2]={1,0,1},
					[3]={0,1,1,2,2},
				},
				[15]={
					[1]={2},
					[2]={1,1,1},
					[3]={2,2,2,2,2},
				},
				[20]={
					[1]={2},
					[2]={2,1,1},
					[3]={4,2,3,3,2},
				},
				[25]={
					[1]={1,1,1},
					[2]={2,2,2},
					[3]={1,5,2,3,4,1},
				},
				[40]={
					[1]={4},
					[2]={4,2,3},
					[3]={8,4,6,6,3},
				},
			}
		elseif englishFaction=="Horde" then
			for id=1,#Roles_List do
				for ix=#Roles_List[id],1,-1 do
					if Roles_List[id][ix][1]=="PALADIN" then
						table.remove(Roles_List[id],ix)
					end
				end
			end
			fubenMoshi_peizhi ={
				[10]={
					[1]={1,1},
					[2]={1,0,1},
					[3]={0,2,1,2,1},
				},
				[15]={
					[1]={2},
					[2]={1,1,1},
					[3]={2,2,2,2,2},
				},
				[20]={
					[1]={2},
					[2]={2,1,1},
					[3]={4,2,3,3,2},
				},
				[25]={
					[1]={2,1},
					[2]={2,2,2},
					[3]={1,5,2,3,4,1},
				},
				[40]={
					[1]={4},
					[2]={4,2,3},
					[3]={8,4,6,6,3},
				},
			}
		end
	else
		fubenMoshi_peizhi ={
			[10]={
				[1]={1,1},
				[2]={1,1,1},
				[3]={0,1,1,2,1},
			},
			[15]={
				[1]={1,1},
				[2]={1,1,1,1},
				[3]={1,1,2,2,1,2},
			},
			[20]={
				[1]={1,1},
				[2]={1,1,1,1},
				[3]={4,2,3,3,2},
			},
			[25]={
				[1]={1,1,1},
				[2]={2,1,1,1},
				[3]={1,5,3,3,4,1},
			},
			[40]={
				[1]={2,1,1},
				[2]={2,2,2,2},
				[3]={6,6,6,4,4,2},
			},
		}
	end
	---顶部设置===================
	fujiF.topF = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",4,-4});
	fujiF.topF:SetPoint("TOPRIGHT", fujiF, "TOPRIGHT", -4, -4);
	fujiF.topF:SetHeight(320)
	fujiF.topF:PIGSetBackdrop(0)

	----职业限制内容
	fujiF.topF.zhiyeXZ = PIGFrame(fujiF.topF);
	fujiF.topF.zhiyeXZ:SetAllPoints(fujiF.topF)
	fujiF.topF.zhiyeXZ:Hide()
	---
	local function ADD_Roles_Frame(xulie)
		local zhizeF=PIGFrame(fujiF.topF.zhiyeXZ,nil,nil,"zhize_F_"..xulie)
		zhizeF:SetHeight(zhiye_F_H)
		zhizeF:PIGSetBackdrop()
		if xulie==1 then
			zhizeF:SetPoint("TOPLEFT",fujiF.topF.zhiyeXZ,"TOPLEFT",4,-4);
			zhizeF:SetPoint("TOPRIGHT", fujiF.topF.zhiyeXZ, "TOPRIGHT", -4, 4);
		else
			zhizeF:SetPoint("TOPLEFT",_G["zhize_F_"..(xulie-1)],"BOTTOMLEFT",0,-6);
			zhizeF:SetPoint("TOPRIGHT",_G["zhize_F_"..(xulie-1)],"BOTTOMRIGHT",0,-6);
		end
		zhizeF.Tex = zhizeF:CreateTexture(nil, "BORDER");
		zhizeF.Tex:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
		zhizeF.Tex:SetTexCoord(zhizeIcon[xulie][1],zhizeIcon[xulie][2],zhizeIcon[xulie][3],zhizeIcon[xulie][4]);
		zhizeF.Tex:SetSize(zhiye_but_H*3,zhiye_but_H*3);
		zhizeF.Tex:SetPoint("LEFT", zhizeF, "LEFT", 10,0);
		--
		zhizeF.mubiaoAll = PIGFontString(zhizeF,{"LEFT", zhizeF, "LEFT", 70,8},"目标人数", "OUTLINE");
		zhizeF.mubiaoAll_V = PIGFontString(zhizeF,{"LEFT", zhizeF.mubiaoAll, "RIGHT", 2,0},0, "OUTLINE");
		zhizeF.mubiaoAll_V:SetTextColor(1,1,1,1);
		zhizeF.dangqianAll = PIGFontString(zhizeF,{"LEFT", zhizeF, "LEFT", 70,-16},"已组人数", "OUTLINE");
		zhizeF.dangqianAll_V = PIGFontString(zhizeF,{"LEFT", zhizeF.dangqianAll, "RIGHT", 2,0},0, "OUTLINE");
		zhizeF.dangqianAll_V:SetTextColor(1,1,1,1);
		
		for id=1,#Roles_List[xulie] do
			local EditBox = CreateFrame("EditBox", "zhize_mubiao_E"..xulie.."_"..id, zhizeF, "InputBoxInstructionsTemplate");
			EditBox:SetSize(zhiye_but_H+4,zhiye_but_H);
			if id==1 then
				EditBox:SetPoint("LEFT", zhizeF.mubiaoAll, "LEFT", 110,0);
			else
				EditBox:SetPoint("LEFT",_G["zhize_mubiao_E"..xulie.."_"..(id-1)],"RIGHT",30,0);
			end
			PIGSetFont(EditBox,14,"OUTLINE")
			EditBox:SetJustifyH("CENTER")
			EditBox:SetNumeric(true)
			EditBox:SetMaxLetters(2)
			EditBox:SetAutoFocus(false)
			EditBox:SetTextColor(0.6, 0.6, 0.6, 0.94)
			EditBox:SetScript("OnEditFocusLost", function(self)
				self:SetTextColor(0.6, 0.6, 0.6, 0.94)
			end);
			EditBox:SetScript("OnEditFocusGained", function(self) 
				self:SetTextColor(1, 1, 1, 1)
			end)
			EditBox:SetScript("OnEscapePressed", function(self) 
				self:ClearFocus() 
			end);
			EditBox:SetScript("OnEnterPressed", function(self) 
				self:ClearFocus() 
				PIGA["Tardis"]["Yell"]["mubiaoNum"][xulie][id]=self:GetNumber();
				fujiF.GetRaidMubiao()
			end);
			EditBox.Icon=PIGFrame(EditBox,{"BOTTOM", EditBox, "TOP", -1,2},{zhiye_but_H+2,zhiye_but_H+2})
			EditBox.Icon.tex = EditBox.Icon:CreateTexture();
			EditBox.Icon.tex:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
			EditBox.Icon.tex:SetAllPoints(EditBox.Icon)
			local coords = CLASS_ICON_TCOORDS[Roles_List[xulie][id][1]]
			EditBox.Icon.tex:SetTexCoord(unpack(coords));
			-- EditBox.Icon:SetScript("OnMouseUp", function(self)
			-- 	if fujiF.topF.zhiyeXZ.xiugaiRF:IsShown() then
			-- 		fujiF.topF.zhiyeXZ.xiugaiRF:Hide()
			-- 	else
			-- 		fujiF.topF.zhiyeXZ.xiugaiRF:Show()
			-- 		xianshixiugaiUI(EditBox.Icon,xulie,id)
			-- 	end
			-- end)

			EditBox.yizu = PIGFontString(EditBox,{"TOP", EditBox, "BOTTOM", -1,-8},nil,"OUTLINE");
			EditBox.wancheng = EditBox:CreateTexture();
			EditBox.wancheng:SetSize(zhiye_but_H,zhiye_but_H-4);
			EditBox.wancheng:SetPoint("TOP", EditBox.yizu, "BOTTOM", 0,-2);
		end
	end
	ADD_Roles_Frame(1)
	ADD_Roles_Frame(2)
	ADD_Roles_Frame(3)
	---
	--手动设置玩家职责
	--fujiF.Datas_DQList={}--自定义职责
	-- fujiF.xiugaiRF=PIGFrame(fujiF,nil,{260,300})
	-- fujiF.xiugaiRF:PIGSetBackdrop(1)
	-- fujiF.xiugaiRF:PIGClose()
	-- fujiF.xiugaiRF:Hide()
	-- fujiF.xiugaiRF:SetFrameLevel(fujiF.xiugaiRF:GetFrameLevel()+10)
	-- fujiF.xiugaiRF.biaoti = PIGFontString(fujiF.xiugaiRF,{"TOP", fujiF.xiugaiRF, "TOP", 0,-3},"", "OUTLINE");
	-- local shezhiWH = 24
	-- for i=1,MAX_RAID_MEMBERS do
	-- 	local pbut = CreateFrame("Button","Zuidui_xigairzhizeUI_"..i,fujiF.xiugaiRF)
	-- 	pbut:SetSize(shezhiWH,shezhiWH);
	-- 	if i==1 then
	-- 		pbut:SetPoint("TOPLEFT", fujiF.xiugaiRF, "TOPLEFT", 10,-24);
	-- 	elseif i==21 then
	-- 		pbut:SetPoint("TOPLEFT", fujiF.xiugaiRF, "TOPLEFT", 290,-24);
	-- 	else
	-- 		pbut:SetPoint("TOP",_G["Zuidui_xigairzhizeUI_"..(i-1)],"BOTTOM",0,-3);
	-- 	end
	-- 	pbut.Tex = pbut:CreateTexture();
	-- 	pbut.Tex:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	-- 	pbut.Tex:SetTexCoord(zhizeIcon[1][1],zhizeIcon[1][2],zhizeIcon[1][3],zhizeIcon[1][4]);
	-- 	pbut.Tex:SetSize(shezhiWH,shezhiWH);
	-- 	pbut.Tex:SetPoint("CENTER", pbut, "CENTER", 0,0);
	-- 	pbut:SetScript("OnMouseDown", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut, "CENTER", 1.5,-1.5);
	-- 	end);
	-- 	pbut:SetScript("OnMouseUp", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut, "CENTER", 0,0);
	-- 	end);
	-- 	pbut:HookScript("OnClick", function (self)
	-- 		local wanjname = self.name:GetText()
	-- 		for p=1,MAX_RAID_MEMBERS do
	-- 			local name = GetRaidRosterInfo(p);
	-- 			if name then
	-- 				if name==wanjname then
	-- 					UnitSetRole(riad..p, "TANK")--"NONE"
	-- 					break
	-- 				end
	-- 			end
	-- 		end
	-- 		fujiF.xiugaiRF:Hide()
	-- 	end);
	-- 	pbut.zhize2 = CreateFrame("Button",nil,pbut)
	-- 	pbut.zhize2:SetSize(shezhiWH,shezhiWH);
	-- 	pbut.zhize2:SetPoint("LEFT", pbut, "RIGHT", 4,0);
	-- 	pbut.zhize2.Tex = pbut.zhize2:CreateTexture();
	-- 	pbut.zhize2.Tex:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	-- 	pbut.zhize2.Tex:SetTexCoord(zhizeIcon[2][1],zhizeIcon[2][2],zhizeIcon[2][3],zhizeIcon[2][4]);
	-- 	pbut.zhize2.Tex:SetSize(shezhiWH,shezhiWH);
	-- 	pbut.zhize2.Tex:SetPoint("CENTER", pbut.zhize2, "CENTER", 0,0);
	-- 	pbut.zhize2:SetScript("OnMouseDown", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut.zhize2, "CENTER", 1.5,-1.5);
	-- 	end);
	-- 	pbut.zhize2:SetScript("OnMouseUp", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut.zhize2, "CENTER", 0,0);
	-- 	end);
	-- 	pbut.zhize2:HookScript("OnClick", function (self)
	-- 		local fujiku = self:GetParent()
	-- 		local wanjname = fujiku.name:GetText()
	-- 		for p=1,MAX_RAID_MEMBERS do
	-- 			local name = GetRaidRosterInfo(p);
	-- 			if name then
	-- 				if name==wanjname then
	-- 					UnitSetRole(riad..p, "HEALER")
	-- 					break
	-- 				end
	-- 			end
	-- 		end
	-- 		fujiF.xiugaiRF:Hide()
	-- 	end);
	-- 	pbut.zhize3 = CreateFrame("Button",nil,pbut)
	-- 	pbut.zhize3:SetSize(shezhiWH,shezhiWH);
	-- 	pbut.zhize3:SetPoint("LEFT", pbut.zhize2, "RIGHT", 4,0);
	-- 	pbut.zhize3.Tex = pbut.zhize3:CreateTexture();
	-- 	pbut.zhize3.Tex:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	-- 	pbut.zhize3.Tex:SetTexCoord(zhizeIcon[3][1],zhizeIcon[3][2],zhizeIcon[3][3],zhizeIcon[3][4]);
	-- 	pbut.zhize3.Tex:SetSize(shezhiWH,shezhiWH);
	-- 	pbut.zhize3.Tex:SetPoint("CENTER", pbut.zhize3, "CENTER", 0,0);
	-- 	pbut.zhize3:SetScript("OnMouseDown", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut.zhize3, "CENTER", 1.5,-1.5);
	-- 	end);
	-- 	pbut.zhize3:SetScript("OnMouseUp", function (self)
	-- 		self.Tex:SetPoint("CENTER", pbut.zhize3, "CENTER", 0,0);
	-- 	end);
	-- 	pbut.zhize3:HookScript("OnClick", function (self)
	-- 		local fujiku = self:GetParent()
	-- 		local wanjname = fujiku.name:GetText()
	-- 		for p=1,MAX_RAID_MEMBERS do
	-- 			local name = GetRaidRosterInfo(p);
	-- 			if name then
	-- 				if name==wanjname then
	-- 					UnitSetRole(riad..p, "DAMAGER")
	-- 					break
	-- 				end
	-- 			end
	-- 		end
	-- 		fujiF.xiugaiRF:Hide()
	-- 	end);
	-- 	pbut.name = PIGFontString(pbut,{"LEFT", pbut.zhize3, "RIGHT", 4,0},"", "OUTLINE");
	-- end
	-- local function xianshixiugaiUI(self,rid,ZID)
	-- 	fujiF.xiugaiRF:SetPoint("TOP", self, "BOTTOM", 0,-4);
	-- 	fujiF.xiugaiRF.biaoti:SetText(_G[Roles[rid]].."-"..Roles_List[rid][ZID][2])
	-- 	for p=1,MAX_RAID_MEMBERS do
	-- 		local xuanzeli = _G["Zuidui_xigairzhizeUI_"..p]
	-- 		xuanzeli:Hide()
	-- 		if fujiF.Datas_DQList[p] then
	-- 			if fujiF.Datas_DQList[p][3]==Roles[rid] then
	-- 				xuanzeli:Show()
	-- 				xuanzeli.name:SetText(fujiF.Datas_DQList[p][1])
	-- 			end
	-- 		end
	-- 	end
	-- end
	fujiF.topF.zhiyeXZ.playerNum = PIGFontString(fujiF.topF.zhiyeXZ,{"BOTTOMLEFT",fujiF.topF.zhiyeXZ,"BOTTOMLEFT", 10,10},"总人数:");
	fujiF.topF.zhiyeXZ.playerNumV = PIGFontString(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.playerNum,"RIGHT",4,0});
	fujiF.topF.zhiyeXZ.playerNumV:SetTextColor(0, 1, 0, 1);
	fujiF.topF.zhiyeXZ.playerNumxie = PIGFontString(fujiF.topF.zhiyeXZ,{"LEFT", fujiF.topF.zhiyeXZ.playerNumV, "RIGHT", 2,0},"/");
	fujiF.topF.zhiyeXZ.playerNumV_max = PIGFontString(fujiF.topF.zhiyeXZ,{"LEFT", fujiF.topF.zhiyeXZ.playerNumxie, "RIGHT", 2,0});
	fujiF.topF.zhiyeXZ.playerNumV_max:SetTextColor(1, 0, 0, 1)
	--载入默认人数配置
	fujiF.topF.zhiyeXZ.daoruMoren=PIGDownMenu(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.playerNum,"RIGHT", 50,0},{124,24})
	fujiF.topF.zhiyeXZ.daoruMoren:PIGDownMenu_SetText("导入预设人数")
	function fujiF.topF.zhiyeXZ.daoruMoren:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#fubenMoshi,1 do
		    info.text, info.arg1 = "导入"..fubenMoshi[i].."人预设人数", fubenMoshi[i]
		    info.notCheckable = true;
			fujiF.topF.zhiyeXZ.daoruMoren:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.topF.zhiyeXZ.daoruMoren:PIGDownMenu_SetValue(value,arg1)
		PIGA["Tardis"]["Yell"]["mubiaoNum"]=fubenMoshi_peizhi[arg1]
		PIGinfotip:TryDisplayMessage("已导入|cffFFFFFF"..arg1.."|r人预设人数");
		PIGCloseDropDownMenus()
		fujiF.GetRaidMubiao()
		fujiF.topF.zhiyeXZ.ShowPlayersList()
	end
	---转换团队/小队
	fujiF.topF.zhiyeXZ.zhuanhuanPR=PIGButton(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.daoruMoren,"RIGHT", 30,0},{120,20},"转换团队/小队")
	fujiF.topF.zhiyeXZ.zhuanhuanPR:SetScript("OnClick", function (self)
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			ConvertToParty() 
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			ConvertToRaid()
		end
	end)
	---职责确认
	fujiF.topF.zhiyeXZ.RolesJC=PIGButton(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.zhuanhuanPR,"RIGHT", 30,0},{100,20},"职责确认")
	fujiF.topF.zhiyeXZ.RolesJC:SetScript("OnClick", function (self)
		if tocversion<20000 then
			--LFGListingRolePollButton_OnClick(self, button)
		elseif tocversion<30000 then
			LFGListingRolePollButton_OnClick(self, button)
		else
			InitiateRolePoll()
		end
	end)
	---就位确认
	fujiF.topF.zhiyeXZ.jiuwei=PIGButton(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.RolesJC,"RIGHT", 30,0},{100,20},"就位确认")
	fujiF.topF.zhiyeXZ.jiuwei:SetScript("OnClick", function (self)
		DoReadyCheck()
	end)
	---刷新
	fujiF.topF.zhiyeXZ.shuaxinP=PIGButton(fujiF.topF.zhiyeXZ,{"LEFT",fujiF.topF.zhiyeXZ.jiuwei,"RIGHT", 30,0},{120,20},"刷新成员信息")
	fujiF.topF.zhiyeXZ.shuaxinP:SetScript("OnClick", function (self)
		fujiF.GetRaidMubiao()
		fujiF.GetNumRaidPlayers()
		fujiF.topF.zhiyeXZ.ShowPlayersList()
	end)
	fujiF.topF.zhiyeXZ:HookScript("OnShow", function(self)
		fujiF.GetRaidMubiao()
		fujiF.GetNumRaidPlayers()
		self.ShowPlayersList()
	end);
	local initialNumRaid={["All"]=0,["Xulie"]={0,0,0},["Xulie_MB"]={{},{},{}}};
	fujiF.Datas_MB=PIGCopyTable(initialNumRaid)
	fujiF.Datas_DQ=PIGCopyTable(initialNumRaid)
	--更新人数显示
	function fujiF.topF.zhiyeXZ.ShowPlayersList()
		if not fujiF.topF.zhiyeXZ:IsVisible() then return end
		local renyuanD = fujiF.Datas_MB
		for xulie=1,#Roles_List do
			for id=1,#Roles_List[xulie] do
				_G["zhize_mubiao_E"..xulie.."_"..id]:SetText(fujiF.Datas_MB.Xulie_MB[xulie][id])
			end
			_G["zhize_F_"..xulie].mubiaoAll_V:SetText(fujiF.Datas_MB.Xulie[xulie])
		end
		for xulie=1,#Roles_List do
			for id=1,#Roles_List[xulie] do
				local fujiku = _G["zhize_mubiao_E"..xulie.."_"..id]
				fujiku.wancheng:Hide()
				if fujiF.Datas_DQ.Xulie_MB[xulie][id]==fujiF.Datas_MB.Xulie_MB[xulie][id] then
					fujiku.wancheng:Show()
					fujiku.wancheng:SetTexture("interface/raidframe/readycheck-ready.blp");
				elseif fujiF.Datas_DQ.Xulie_MB[xulie][id]>fujiF.Datas_MB.Xulie_MB[xulie][id] then
					fujiku.wancheng:Show()
					fujiku.wancheng:SetTexture("interface/raidframe/readycheck-notready.blp");--X号
				end
				fujiku.yizu:SetText(fujiF.Datas_DQ.Xulie_MB[xulie][id])
			end
			_G["zhize_F_"..xulie].dangqianAll_V:SetText(fujiF.Datas_DQ.Xulie[xulie])
		end
		fujiF.topF.zhiyeXZ.playerNumV:SetText(GetNumGroupMembers(LE_PARTY_CATEGORY_HOME))
		fujiF.topF.zhiyeXZ.playerNumV_max:SetText(fujiF.Datas_MB.All)
	end

	---自定义条件=====================================
	fujiF.topF.autoHF = PIGFrame(fujiF.topF);
	fujiF.topF.autoHF:SetAllPoints(fujiF.topF)
	fujiF.topF.autoHF:Hide()
	--人数限制
	fujiF.topF.autoHF.playerNum = PIGFontString(fujiF.topF.autoHF,{"BOTTOMLEFT",fujiF.topF.autoHF,"BOTTOMLEFT", 10,10},"总人数:");
	fujiF.topF.autoHF.playerNumV = PIGFontString(fujiF.topF.autoHF,{"LEFT",fujiF.topF.autoHF.playerNum,"RIGHT",4,0});
	fujiF.topF.autoHF.playerNumV:SetTextColor(0, 1, 0, 1);
	fujiF.topF.autoHF.playerNumxie = PIGFontString(fujiF.topF.autoHF,{"LEFT", fujiF.topF.autoHF.playerNumV, "RIGHT", 2,0},"/");

	fujiF.topF.autoHF.playerNumV_max = CreateFrame("EditBox", nil, fujiF.topF.autoHF,"InputBoxInstructionsTemplate");
	fujiF.topF.autoHF.playerNumV_max:SetSize(40,26);
	fujiF.topF.autoHF.playerNumV_max:SetPoint("LEFT",fujiF.topF.autoHF.playerNumxie,"RIGHT",6,0);
	fujiF.topF.autoHF.playerNumV_max:SetFontObject(ChatFontNormal);
	fujiF.topF.autoHF.playerNumV_max:SetMaxLetters(2)
	fujiF.topF.autoHF.playerNumV_max:SetAutoFocus(false);
	fujiF.topF.autoHF.playerNumV_max:SetNumeric(true)
	fujiF.topF.autoHF.playerNumV_max:SetTextColor(0.7, 0.7, 0.7, 1);
	PIGEnter(fujiF.topF.autoHF.playerNumV_max,"1.限制最大邀请人数\n2.到达指定人数后将关闭自动邀请")
	fujiF.topF.autoHF.playerNumV_max:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	fujiF.topF.autoHF.playerNumV_max:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.7, 0.7, 0.7, 1);
		self:SetText(PIGA["Tardis"]["Yell"]["MaxPlayerNum"])
	end);
	fujiF.topF.autoHF.playerNumV_max:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
	end);
	fujiF.topF.autoHF.playerNumV_max:SetScript("OnEnterPressed", function(self) 
		PIGA["Tardis"]["Yell"]["MaxPlayerNum"]=self:GetNumber();
		self:ClearFocus()
	end);
	fujiF.topF.autoHF.tishitxt1 = PIGFontString(fujiF.topF.autoHF,{"LEFT",fujiF.topF.autoHF.playerNumV_max,"RIGHT",20,0},"|cff00FF00提示: 输入完成回车保存。触发优先级从上到下，同时触发2条以上规则优先执行上方规则|r");
	---条件
	local tiaojianNUM = 5
	local function add_ModeUI(fujiK,modeID,autoInv)
		PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]=PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID] or {["Open"]=false,["TJ"]="",["HF"]=""}
		if modeID==1 then
			modeUI = PIGCheckbutton(fujiK,{"TOPLEFT",fujiK,"TOPLEFT",10,-10},{modeID..".密语为进组暗号则: |cff00FF00邀请入队|r","无额外限制，密语内容为进组暗号直接邀请"})
			modeUI:SetScript("OnClick", function(self)
				if self:GetChecked() then
					PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["Open"]=true;
				else
					PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["Open"]=false;
				end
				fujiF.topF.autoHF:SetXZ_mode()
			end);
			return modeUI
		end
		local tishityxy = "当检测到密语包含特定关键字，则回复预设内容"
		if autoInv then
			tishityxy = "当检测到密语包含特定关键字，则邀请对方加入队伍"
		end
		modeUI = PIGCheckbutton(fujiK,{"TOPLEFT",fujiK,"TOPLEFT",10,-60*modeID+70},{modeID..".如果密语包含:",tishityxy})
		modeUI:SetScript("OnClick", function(self)
			if self:GetChecked() then
				PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["Open"]=true;
			else
				PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["Open"]=false;
			end
			fujiK:SetXZ_mode()
		end);
		modeUI.TJ = CreateFrame("EditBox", nil, modeUI,"InputBoxInstructionsTemplate");
		modeUI.TJ:SetHeight(26);
		modeUI.TJ:SetPoint("LEFT",modeUI.Text,"RIGHT",10,0);
		modeUI.TJ:SetPoint("RIGHT",fujiK,"RIGHT",-10,0);
		modeUI.TJ:SetFontObject(ChatFontNormal);
		modeUI.TJ:SetMaxLetters(200)
		modeUI.TJ:SetAutoFocus(false);
		modeUI.TJ:SetTextColor(0.7, 0.7, 0.7, 1);
		modeUI.TJ.Instructions:SetText(L["CHAT_KEYWORD_TI"]);
		modeUI.TJ:SetScript("OnEditFocusGained", function(self) 
			self:SetTextColor(1, 1, 1, 1);
		end);
		modeUI.TJ:SetScript("OnEditFocusLost", function(self)
			self:SetTextColor(0.7, 0.7, 0.7, 1);
			self:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["TJ"])
		end);
		modeUI.TJ:SetScript("OnEscapePressed", function(self) 
			self:ClearFocus()
		end);
		modeUI.TJ:SetScript("OnEnterPressed", function(self) 
			PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["TJ"]=self:GetText();
			fujiK:SetXZ_mode()
			self:ClearFocus()
		end);
		if autoInv then
			modeUI.zhixingt = PIGFontString(modeUI,{"TOPLEFT",modeUI,"BOTTOMLEFT",20,-8},"则: |cff00FF00邀请入队|r");
		else
			modeUI.zhixingt = PIGFontString(modeUI,{"TOPLEFT",modeUI,"BOTTOMLEFT",20,-8},"则: |cff00FF00回复|r");
			modeUI.HF = CreateFrame("EditBox", nil, modeUI,"InputBoxInstructionsTemplate");
			modeUI.HF:SetHeight(26);
			modeUI.HF:SetPoint("LEFT",modeUI.zhixingt,"RIGHT",10,0);
			modeUI.HF:SetPoint("RIGHT",fujiK,"RIGHT",-10,0);
			modeUI.HF:SetFontObject(ChatFontNormal);
			modeUI.HF:SetMaxLetters(200)
			modeUI.HF:SetAutoFocus(false)
			modeUI.HF:SetTextColor(0.7, 0.7, 0.7, 1);
			modeUI.HF.Instructions:SetText("输入回复内容");
			modeUI.HF:SetScript("OnEditFocusGained", function(self) 
				self:SetTextColor(1, 1, 1, 1);
			end);
			modeUI.HF:SetScript("OnEditFocusLost", function(self)
				self:SetTextColor(0.7, 0.7, 0.7, 1);
				self:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["HF"])
			end);
			modeUI.HF:SetScript("OnEscapePressed", function(self) 
				self:ClearFocus()
			end);
			modeUI.HF:SetScript("OnEnterPressed", function(self) 
				PIGA["Tardis"]["Yell"]["InvMode1_Info"][modeID]["HF"]=self:GetText();
				fujiK:SetXZ_mode()
				self:ClearFocus()
			end);
		end
		return modeUI
	end
	fujiF.topF.autoHF.XZ_mode1=add_ModeUI(fujiF.topF.autoHF,1,true)
	fujiF.topF.autoHF.XZ_mode2=add_ModeUI(fujiF.topF.autoHF,2,true)
	fujiF.topF.autoHF.XZ_mode3=add_ModeUI(fujiF.topF.autoHF,3,false)
	fujiF.topF.autoHF.XZ_mode4=add_ModeUI(fujiF.topF.autoHF,4,false)
	fujiF.topF.autoHF.XZ_mode5=add_ModeUI(fujiF.topF.autoHF,5,false)
	---
	function fujiF.topF.autoHF:zairuKeyList()
		self.keydata={}
		for i=1,tiaojianNUM do
			self.keydata[i]={["TJ"]={},["HF"]={}}
			if i>1 then
				local keyslist = PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["TJ"]:gsub("，", ",")
				local fengelistTJ = Key_fenge(keyslist, ",", true)
				self.keydata[i]["TJ"]=fengelistTJ
				if i>2 then
					self.keydata[i]["HF"]=PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["HF"]
				end
			end
		end
	end
	fujiF.topF.autoHF:zairuKeyList()
	function fujiF.topF.autoHF:SetXZ_mode()
		self.keydata={}
		for i=1,tiaojianNUM do
			self.keydata[i]={["TJ"]={},["HF"]={}}
			self["XZ_mode"..i]:SetChecked(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["Open"])
			if i>1 then
				self["XZ_mode"..i].TJ:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["TJ"])
				self["XZ_mode"..i].TJ:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["TJ"])
				self["XZ_mode"..i].TJ:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["TJ"])
				self["XZ_mode"..i].TJ:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["TJ"])
				if i>2 then
					self["XZ_mode"..i].HF:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["HF"])
					self["XZ_mode"..i].HF:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["HF"])
					self["XZ_mode"..i].HF:SetText(PIGA["Tardis"]["Yell"]["InvMode1_Info"][i]["HF"])
				end
			end
		end
		self:zairuKeyList()
	end
	--更新人数显示
	function fujiF.topF.autoHF.ShowPlayersList()
		if not fujiF.topF.autoHF:IsVisible() then return end
		fujiF.topF.autoHF.playerNumV:SetText(GetNumGroupMembers(LE_PARTY_CATEGORY_HOME))
		fujiF.topF.autoHF.playerNumV_max:SetText(fujiF.Datas_MB.All)
	end
	----
	fujiF.topF.autoHF:HookScript("OnShow", function(self)
		fujiF.GetRaidMubiao()
		fujiF.GetNumRaidPlayers()
		self.ShowPlayersList()
		self:SetXZ_mode()
	end);

	---底部设置===================
	fujiF.botF_L = PIGFrame(fujiF,{"TOPLEFT",fujiF.topF,"BOTTOMLEFT",0,-4});
	fujiF.botF_L:SetPoint("BOTTOMLEFT", fujiF, "BOTTOMLEFT", 4, 4);
	fujiF.botF_L:SetWidth(540)
	fujiF.botF_L:PIGSetBackdrop(0)
	--喊话内容
	fujiF.botF_L.Yell_NR = PIGFrame(fujiF.botF_L,{"TOPLEFT", fujiF.botF_L, "TOPLEFT", 4,-22});
	fujiF.botF_L.Yell_NR:SetPoint("BOTTOMRIGHT", fujiF.botF_L, "BOTTOMRIGHT", -200, 4);
	fujiF.botF_L.Yell_NR:PIGSetBackdrop()
	fujiF.botF_L.Yell_NR.biaoti = PIGFontString(fujiF.botF_L.Yell_NR,{"BOTTOMLEFT", fujiF.botF_L.Yell_NR, "TOPLEFT", 2,4},"喊话内容");
	fujiF.botF_L.Yell_NR.biaoti:SetTextColor(0, 1, 0, 1);
	fujiF.botF_L.Yell_NR.zifulen = PIGFontString(fujiF.botF_L.Yell_NR,{"BOTTOMLEFT", fujiF.botF_L.Yell_NR.biaoti, "BOTTOMRIGHT", 0,0},"(当前字符数",nil,12);
	fujiF.botF_L.Yell_NR.zifulen:SetTextColor(0, 1, 1, 1);
	fujiF.botF_L.Yell_NR.zifulenV = PIGFontString(fujiF.botF_L.Yell_NR,{"LEFT", fujiF.botF_L.Yell_NR.zifulen, "RIGHT", 0,0},0,nil,12);
	fujiF.botF_L.Yell_NR.zifulenV:SetTextColor(0, 1, 0, 1);
	fujiF.botF_L.Yell_NR.zifulenend = PIGFontString(fujiF.botF_L.Yell_NR,{"LEFT", fujiF.botF_L.Yell_NR.zifulenV, "RIGHT", 0,0},"/250):",nil,12);
	fujiF.botF_L.Yell_NR.zifulenend:SetTextColor(0, 1, 1, 1);
	fujiF.botF_L.Yell_NR.E = CreateFrame("EditBox", nil, fujiF.botF_L.Yell_NR);
	fujiF.botF_L.Yell_NR.E:SetPoint("TOPLEFT", fujiF.botF_L.Yell_NR, "TOPLEFT", 2,-2);
	fujiF.botF_L.Yell_NR.E:SetPoint("BOTTOMRIGHT", fujiF.botF_L.Yell_NR, "BOTTOMRIGHT", -2,2);
	fujiF.botF_L.Yell_NR.E:SetFontObject(ChatFontNormal);
	fujiF.botF_L.Yell_NR.E:SetAutoFocus(false);
	fujiF.botF_L.Yell_NR.E:SetMultiLine(true)
	fujiF.botF_L.Yell_NR.E:SetMaxLetters(200);
	fujiF.botF_L.Yell_NR.E:SetTextColor(0.7, 0.7, 0.7, 1);
	fujiF.botF_L.Yell_NR.E:SetText(PIGA["Tardis"]["Yell"]["Yell_NR"])
	fujiF.botF_L.Yell_NR.E:SetScript("OnEditFocusGained", function(self) 
		fujiF.botF_L.Yell_NR.SAVEBUT:Show();
		self:SetTextColor(1, 1, 1, 1);
	end);
	fujiF.botF_L.Yell_NR.E:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.7, 0.7, 0.7, 1);
		self:SetText(PIGA["Tardis"]["Yell"]["Yell_NR"])
	end);
	fujiF.botF_L.Yell_NR.E:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
		fujiF.botF_L.Yell_NR.SAVEBUT:Hide();
	end);
	local function EditBox_panduan(Newtxt)
		local famsg = Get_famsg("yell",Newtxt,PIGA["Tardis"]["Yell"]["jinzuCMD"],PIGA["Tardis"]["Yell"]["jinzuCMD_inv"])
		local msglen = strlen(famsg)
		if msglen>250 then
			fujiF.botF_L.Yell_NR.zifulenV:SetText(msglen)
			fujiF.botF_L.Yell_NR.zifulenV:SetTextColor(1, 0, 0, 1);
			PIGinfotip:TryDisplayMessage("超过最大字符数!!!", 1,0,0);
			return true,msglen
		else
			fujiF.botF_L.Yell_NR.zifulenV:SetText(msglen)
			fujiF.botF_L.Yell_NR.zifulenV:SetTextColor(1, 1, 0, 1);
		end
		return false,msglen
	end
	fujiF.botF_L.Yell_NR.E:SetScript("OnCursorChanged", function(self)
		EditBox_panduan(fujiF.botF_L.Yell_NR.E:GetText())
	end);
	fujiF.botF_L.Yell_NR.SAVEBUT = PIGButton(fujiF.botF_L.Yell_NR,{"BOTTOMRIGHT",fujiF.botF_L.Yell_NR,"TOPRIGHT",0,2},{60,18},"保存");
	fujiF.botF_L.Yell_NR.SAVEBUT:Hide()
	fujiF.botF_L.Yell_NR.SAVEBUT:SetScript("OnClick", function(self)
		local Newtxt = fujiF.botF_L.Yell_NR.E:GetText()
		if not EditBox_panduan(Newtxt) then
			PIGA["Tardis"]["Yell"]["Yell_NR"]=Newtxt
			fujiF.Updata_Macro()
			fujiF.botF_L.Yell_NR.E:ClearFocus()
			fujiF.botF_L.Yell_NR.SAVEBUT:Hide()
		end
	end);
	--喊话模板
	fujiF.botF_L.changyong = PIGButton(fujiF.botF_L,{"TOPLEFT",fujiF.botF_L.Yell_NR,"TOPRIGHT",10,12},{80,22},"喊话模板");
	fujiF.botF_L.changyong:Disable()
	--喊话宏-----
	local pigzhTWmac = MACRO
	if GetLocale() == "zhTW" then
		pigzhTWmac = MACRO:sub(1,6)
	end
	local suijizuoqi = "/s "..PIGA["Tardis"]["Yell"]["Yell_NR"]
	local YELL_BUT_HONG = CreateFrame("Button","YELL_BUT_HONG",UIParent, "SecureActionButtonTemplate,ActionButtonTemplate");
	YELL_BUT_HONG:SetAttribute("type", "macro")
	YELL_BUT_HONG:SetAttribute("macrotext", suijizuoqi)
	-- YELL_BUT_HONG:SetPoint("CENTER",UIParent,"CENTER",0,0);
	-- YELL_BUT_HONG:SetSize(50,50);
	local hanhuaHongName = {"PIGyell",NEW..L["TARDIS_YELL"]..pigzhTWmac, UPDATE..L["TARDIS_YELL"]..pigzhTWmac}
	if GetLocale() == "zhTW" then
		hanhuaHongName[2],hanhuaHongName[3]=NEW..L["TARDIS_YELL"]..pigzhTWmac, UPDATE..L["TARDIS_YELL"]..pigzhTWmac
	end
	fujiF.botF_L.Yell_hong = PIGButton(fujiF.botF_L,{"TOPLEFT",fujiF.botF_L.changyong,"TOPRIGHT",10,0},{92,22},hanhuaHongName[2]); 
	PIGEnter(fujiF.botF_L.Yell_hong,"非战斗状态任何修改插件会自动更新喊话宏,\n如果战斗中更改过喊话内容或者其他选项请手动更新喊话宏")
	fujiF.botF_L.Yell_hong:HookScript("OnShow", function (self)
		local macroSlot = GetMacroIndexByName(hanhuaHongName[1])
		if macroSlot>0 then
			self:SetText(hanhuaHongName[3]);
		else
			self:SetText(hanhuaHongName[2]);
		end
	end)
	fujiF.botF_L.Yell_hong:SetScript("OnClick", function (self)
		local macroSlot = GetMacroIndexByName(hanhuaHongName[1])
		if macroSlot>0 then
			fujiF.Updata_Macro()
		else
			local global = GetNumMacros()
			if global<120 then
				StaticPopup_Show ("CHUANGJIANHONGPIG");
			else
				PIGinfotip:TryDisplayMessage(L["LIB_MACROERR"]);
			end
		end
	end)
	StaticPopupDialogs["CHUANGJIANHONGPIG"] = {
		text = "将创建一个名为<"..hanhuaHongName[1]..">喊话宏\n请拖拽到动作条使用\n确定创建吗？\n\n",
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			fujiF.Updata_Macro("add")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	local function gengxinhongtxt()
		fujiF.PindaoList=GetPindaoList()
		local yellpindaolist =GetYellPindao(fujiF.PindaoList,PIGA["Tardis"]["Yell"]["Yell_CHANNEL"])
		local keyongshu = #yellpindaolist
		local hanhuabuthongNR=""
		if keyongshu>0 then
			local famsg =Get_famsg("yell",PIGA["Tardis"]["Yell"]["Yell_NR"],PIGA["Tardis"]["Yell"]["jinzuCMD"],PIGA["Tardis"]["Yell"]["jinzuCMD_inv"])
			for x=1,#yellpindaolist do
				local suijishu=random(1, 8)
				local  famsg= famsg..MSGsuijizifu[suijishu]
				if yellpindaolist[x][1]=="CHANNEL" then
					hanhuabuthongNR=hanhuabuthongNR.."/"..yellpindaolist[x][2].." "..famsg.."\r"
				else
					hanhuabuthongNR=hanhuabuthongNR.."/"..yellpindaolist[x][1].." "..famsg.."\r"
				end
			end
		end
		--print(hanhuabuthongNR)
		if not InCombatLockdown() then
			YELL_BUT_HONG:SetAttribute("macrotext", hanhuabuthongNR)
		end
	end
	function fujiF.Updata_Macro(add)
		if InCombatLockdown() then PIGinfotip:TryDisplayMessage("请战斗结束后手动更新喊话宏",1,0,0) return end
		local UseKeyDown =GetCVar("ActionButtonUseKeyDown")
		local YELL_BUT_HONG_txt = "/click YELL_BUT_HONG"
		if UseKeyDown=="0" then
			YELL_BUT_HONG_txt = [=[/click YELL_BUT_HONG LeftButton 0]=]
		elseif UseKeyDown=="1" then
			YELL_BUT_HONG_txt = [=[/click YELL_BUT_HONG LeftButton 1]=]
		end
		if add=="add" then
			CreateMacro(hanhuaHongName[1], 135451, YELL_BUT_HONG_txt, nil)
			gengxinhongtxt()
			PIGinfotip:TryDisplayMessage("已创建喊话宏")
			fujiF.botF_L.Yell_hong:SetText(hanhuaHongName[3]);
		else
			local macroSlot = GetMacroIndexByName(hanhuaHongName[1])
			if macroSlot>0 then
				--print(GetMacroInfo(macroSlot))
				EditMacro(macroSlot, nil, 135451, YELL_BUT_HONG_txt)
				gengxinhongtxt()
				if add~="OPEN" then
					PIGinfotip:TryDisplayMessage("已更新喊话宏")
				end
			end
		end
	end
	--指令邀请
	fujiF.botF_L.jinzuCMD_inv = PIGCheckbutton(fujiF.botF_L,{"TOPLEFT",fujiF.botF_L.changyong,"BOTTOMLEFT",0,-10},{"喊话附加进组暗号","喊话内容附加进组暗号，玩家回复暗号可执行预设指令\n|cffFF0000需开启《自动回复/邀请》|r"})
	fujiF.botF_L.jinzuCMD_inv:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Yell"]["jinzuCMD_inv"]=true;
		else
			PIGA["Tardis"]["Yell"]["jinzuCMD_inv"]=false;
		end
		if not EditBox_panduan(fujiF.botF_L.Yell_NR.E:GetText()) then
			fujiF.Updata_Macro()
		end
	end);
	--主屏幕快捷按钮===
	fujiF.botF_L.ShowDesktopBut = PIGCheckbutton(fujiF.botF_L,{"TOPLEFT",fujiF.botF_L.jinzuCMD_inv,"BOTTOMLEFT",0,-10},{"功能动作条按钮","添加喊话按钮到功能动作条\n此功能需要先开启功能动作条"})
	fujiF.botF_L.ShowDesktopBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Yell"]["ShowDesktopBut"]=true;
		else
			PIGA["Tardis"]["Yell"]["ShowDesktopBut"]=false;
		end
		QuickButUI.ButList[14]()
	end);
	local QkButUI,WWHH = "QkBut_Invite_Yell",24
	QuickButUI.ButList[14]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["Tardis"]["Open"] then
			if PIGA["Tardis"]["Yell"]["ShowDesktopBut"] then
				if _G[QkButUI] then
					_G[QkButUI].yincang=nil
					local fujiww = QuickButUI.nr:GetHeight()
					_G[QkButUI]:Show()
					_G[QkButUI]:SetWidth(fujiww)
					QuickButUI:GengxinWidth()
					return 
				end
				local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..L["TARDIS_YELL"].."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
				local QkBut=PIGQuickBut(QkButUI,QuickTooltip,132333)
				QkBut.Cooldown = CreateFrame("Cooldown",nil, QkBut, "CooldownFrameTemplate")
				QkBut.Cooldown:SetAllPoints()
				QkBut:HookScript("OnClick", function (self,button)
					if button=="LeftButton" then
						if self.Cooldown:GetCooldownDuration()>0 then
							PIGinfotip:TryDisplayMessage(ERR_CHAT_THROTTLED);
						else
							fujiF.Kaishi_Yell(self)
						end	
					else
						if InvF:IsShown() then
							InvF:Hide()
						else
							InvF:Show()
							Create.Show_TabBut_R(InvF.F,fujiF,fujiTabBut)
						end
					end
				end);
				local WowHeight=GetScreenHeight();
				local function YaoqingSetPoint(self)		
					local offset1 = QkBut:GetBottom();
					self:ClearAllPoints();
					if offset1>(WowHeight*0.5) then
						self:SetPoint("TOP",QkBut,"BOTTOM",0,-2);
					else
						self:SetPoint("BOTTOM",QkBut,"TOP",0,2);
					end
				end
				QkBut.AutoYaoqing = CreateFrame("Button",nil,QkBut);
				QuickButUI.yidong:HookScript("OnDragStop",function(self)
					YaoqingSetPoint(QkBut.AutoYaoqing)	
				end)
				YaoqingSetPoint(QkBut.AutoYaoqing)	
				QkBut.AutoYaoqing:SetSize(WWHH,WWHH);
				QkBut.AutoYaoqing.Tex = QkBut.AutoYaoqing:CreateTexture(nil, "BORDER");
				if Pig_OptionsUI.autoInvite_shikong then
					QkBut.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp");
				else
					QkBut.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
				end
				QkBut.AutoYaoqing.Tex:SetPoint("CENTER",0,-1);
				QkBut.AutoYaoqing.Tex:SetSize(WWHH,WWHH);
				QkBut.AutoYaoqing:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					local offset1 = QkBut:GetBottom();
					if offset1>(WowHeight*0.5) then
						GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",-20,0);
					else
						GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
					end
					if Pig_OptionsUI.autoInvite_shikong then
						GameTooltip:AddLine("自动回复/邀请:|cff00ff00"..ENABLE.."|r")
						GameTooltip:AddLine("|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..CLOSE.."|r")
					else
						GameTooltip:AddLine("自动回复/邀请:|cffff0000"..CLOSE.."|r")
						GameTooltip:AddLine("|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..ENABLE.."|r")
					end
					GameTooltip:Show();
				end);
				QkBut.AutoYaoqing:SetScript("OnLeave", function ()
					GameTooltip:ClearLines();
					GameTooltip:Hide() 
				end);
				QkBut.AutoYaoqing:SetScript("OnClick", function (self)
					PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
					fujiF.Auto_FunOpen()
					GameTooltip:Hide() 
				end)
			else
				if _G[QkButUI] then
					_G[QkButUI]:Hide()
					_G[QkButUI]:SetWidth(0.01)
					_G[QkButUI].yincang=true
					QuickButUI:GengxinWidth(1)
				end
			end
		end
	end
	--喊话按钮
	fujiF.botF_L.yellbut = PIGButton(fujiF.botF_L,{"BOTTOMLEFT",fujiF.botF_L.Yell_NR,"BOTTOMRIGHT",10,10},{100,25},SEND_LABEL..L["TARDIS_YELL"]);
	fujiF.botF_L.yellbut:SetScript("OnClick", function (self)
		fujiF.Kaishi_Yell(QkBut_Invite_Yell)
	end);
	--喊话频道
	fujiF.botF_L.Yell_CHANNEL=PIGDownMenu(fujiF.botF_L,{"LEFT",fujiF.botF_L.yellbut,"RIGHT",10,0},{70,25})
	fujiF.botF_L.Yell_CHANNEL:PIGDownMenu_SetText(CHANNEL)
	function fujiF.botF_L.Yell_CHANNEL:PIGDownMenu_Update_But(self)
		fujiF.PindaoList=GetPindaoList()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#fujiF.PindaoList,1 do
		    info.text, info.arg1 = fujiF.PindaoList[i][1], fujiF.PindaoList[i][2]
		    info.checked = PIGA["Tardis"]["Yell"]["Yell_CHANNEL"][fujiF.PindaoList[i][2]]
		    info.isNotRadio=true
			fujiF.botF_L.Yell_CHANNEL:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.botF_L.Yell_CHANNEL:PIGDownMenu_SetValue(value,arg1,arg2,checked)
		PIGA["Tardis"]["Yell"]["Yell_CHANNEL"][arg1]=checked
		fujiF.Updata_Macro()
		PIGCloseDropDownMenus()
	end
	---
	fujiF.botF_L:HookScript("OnShow", function(self)
		self.Yell_NR.E:SetText(PIGA["Tardis"]["Yell"]["Yell_NR"])
		self.jinzuCMD_inv:SetChecked(PIGA["Tardis"]["Yell"]["jinzuCMD_inv"])
		self.ShowDesktopBut:SetChecked(PIGA["Tardis"]["Yell"]["ShowDesktopBut"])
	end);

	--=邀请条件====================
	fujiF.botF_R = PIGFrame(fujiF,{"TOPLEFT",fujiF.botF_L,"TOPRIGHT",4,0});
	fujiF.botF_R:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -4, 4);
	fujiF.botF_R:PIGSetBackdrop(0)
	local function SetInvModeFun()
		fujiF.botF_R.AutoHuifu:SetChecked(false)
		fujiF.botF_R.XZ_zhiye:SetChecked(false)
		fujiF.topF.zhiyeXZ:Hide()
		fujiF.topF.autoHF:Hide()
		if PIGA["Tardis"]["Yell"]["InvMode"]==1 then
			fujiF.botF_R.AutoHuifu:SetChecked(true)
			fujiF.topF.autoHF:Show()
		elseif PIGA["Tardis"]["Yell"]["InvMode"]==2 then
			fujiF.botF_R.XZ_zhiye:SetChecked(true)
			fujiF.topF.zhiyeXZ:Show()
		end
	end
	---自定义回复
	fujiF.botF_R.AutoHuifu = PIGCheckbutton(fujiF.botF_R,{"TOPLEFT",fujiF.botF_R,"TOPLEFT",10,-10},{"自定义回复/邀请","根据自定义触发词自动回复/邀请"})
	fujiF.botF_R.AutoHuifu:SetScript("OnClick", function (self)
		PIGA["Tardis"]["Yell"]["InvMode"]=1;
		SetInvModeFun()
	end);
	---职业职责限制
	fujiF.botF_R.XZ_zhiye = PIGCheckbutton(fujiF.botF_R,{"TOPLEFT",fujiF.botF_R.AutoHuifu,"BOTTOMLEFT",0,-10},{"根据职业回复/邀请","检测到进组暗号后自动询问职业职责，符合预设条件即邀请，达到预设人数将停止邀请"})
	fujiF.botF_R.XZ_zhiye:SetScript("OnClick", function (self)
		PIGA["Tardis"]["Yell"]["InvMode"]=2;
		SetInvModeFun()
	end);
	----自动邀请
	fujiF.botF_R.AutoYaoqing = PIGButton(fujiF.botF_R,{"BOTTOMLEFT",fujiF.botF_R,"BOTTOMLEFT",10,6},{130,24},"自动回复/邀请");  
	fujiF.botF_R.AutoYaoqing.Text:SetPoint("CENTER",fujiF.botF_R.AutoYaoqing,"CENTER",8,0);
	fujiF.botF_R.AutoYaoqing.Text:SetTextColor(0, 1, 1, 1);
	fujiF.botF_R.AutoYaoqing.Tex = fujiF.botF_R.AutoYaoqing:CreateTexture(nil, "BORDER");
	fujiF.botF_R.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
	fujiF.botF_R.AutoYaoqing.Tex:SetPoint("RIGHT",fujiF.botF_R.AutoYaoqing.Text,"LEFT",0,-1);
	fujiF.botF_R.AutoYaoqing.Tex:SetSize(23,23);
	fujiF.botF_R.AutoYaoqing:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF_R.AutoYaoqing,"CENTER",9.5,-1.5);
		end
	end);
	fujiF.botF_R.AutoYaoqing:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF_R.AutoYaoqing,"CENTER",8,0);
		end
	end);
	fujiF.botF_R.AutoYaoqing:SetScript("OnClick", function (self)
		fujiF.Auto_FunOpen()
	end)
	--进组指令
	fujiF.botF_R.jinzuCMDE_T = PIGFontString(fujiF.botF_R,{"LEFT",fujiF.botF_R.AutoYaoqing,"RIGHT",20,0},"进组暗号:");
	fujiF.botF_R.jinzuCMDE = CreateFrame("EditBox", nil, fujiF.botF_R,"InputBoxInstructionsTemplate");
	fujiF.botF_R.jinzuCMDE:SetSize(60,26);
	fujiF.botF_R.jinzuCMDE:SetPoint("LEFT",fujiF.botF_R.jinzuCMDE_T,"RIGHT",6,0);
	fujiF.botF_R.jinzuCMDE:SetFontObject(ChatFontNormal);
	fujiF.botF_R.jinzuCMDE:SetMaxLetters(6)
	fujiF.botF_R.jinzuCMDE:SetAutoFocus(false);
	fujiF.botF_R.jinzuCMDE:SetTextColor(0.7, 0.7, 0.7, 1);
	fujiF.botF_R.jinzuCMDE:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	fujiF.botF_R.jinzuCMDE:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.7, 0.7, 0.7, 1);
		self:SetText(PIGA["Tardis"]["Yell"]["jinzuCMD"])
	end);
	fujiF.botF_R.jinzuCMDE:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
	end);
	fujiF.botF_R.jinzuCMDE:SetScript("OnEnterPressed", function(self) 
		PIGA["Tardis"]["Yell"]["jinzuCMD"]=self:GetText();
		self:ClearFocus()
		fujiF.Updata_Macro()
	end);
	----
	fujiF.botF_R:HookScript("OnShow", function(self)
		SetInvModeFun()
		self.jinzuCMDE:SetText(PIGA["Tardis"]["Yell"]["jinzuCMD"]);
	end);

	--根据指令邀请
	local function OFF_autoInvite(msg)
		Pig_OptionsUI.autoInvite_shikong=false;
		fujiF.botF_R.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
		if QkBut_Invite_Yell then QkBut_Invite_Yell.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");end
		if fujiF.botF_R.hanhuaOpen then fujiF.botF_R.hanhuaOpen.Tex:SetTexture("interface/common/indicator-gray.blp");end
		fujiF:UnregisterEvent("CHAT_MSG_WHISPER");
		fujiF:UnregisterEvent("CHAT_MSG_SYSTEM");
		PIGinfotip:TryDisplayMessage(msg);
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
	--获取目标人数
	function fujiF.GetRaidMubiao()
		fujiF.Datas_MB=PIGCopyTable(initialNumRaid)
		if PIGA["Tardis"]["Yell"]["InvMode"]==1 then
			fujiF.Datas_MB.All=PIGA["Tardis"]["Yell"]["MaxPlayerNum"]
		elseif PIGA["Tardis"]["Yell"]["InvMode"]==2 then
			local renyuanD = PIGA["Tardis"]["Yell"]["mubiaoNum"]
			for xulie=1,#Roles_List do
				for id=1,#Roles_List[xulie] do
					local mubiaoS = renyuanD[xulie][id] or 0
					fujiF.Datas_MB.All=fujiF.Datas_MB.All+mubiaoS
					fujiF.Datas_MB.Xulie[xulie]=fujiF.Datas_MB.Xulie[xulie]+mubiaoS
					local ZhiyeS = fujiF.Datas_MB.Xulie_MB[xulie][id] or 0
					fujiF.Datas_MB.Xulie_MB[xulie][id]=ZhiyeS+mubiaoS
				end
			end
		end
	end
	fujiF.GetRaidMubiao()
	--获取当前人员/人数
	function fujiF.GetNumRaidPlayers()
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if PIGA["Tardis"]["Yell"]["InvMode"]==1 then

		elseif PIGA["Tardis"]["Yell"]["InvMode"]==2 then
			local NewZhiyeData={};
			if numGroupMembers>0 then
				for p=1,MAX_RAID_MEMBERS do
					local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(p);
					if name then
						--print(name,fileName,combatRole)
						NewZhiyeData[name]={fileName,combatRole}
					end
				end
			end
			---如果没有职责信息根据玩家回复设置
			-- for x=1,#NewZhiyeData do
			-- 	for p=1,#fujiF.Datas_DQList do		
			-- 		if NewZhiyeData[x][1]==fujiF.Datas_DQList[p][1] then
			-- 			--NewZhiyeData[x][3]=fujiF.Datas_DQ[p][3]
			-- 		end
			-- 	end
			-- end
			-- fujiF.Datas_DQList=NewZhiyeData;
			fujiF.Datas_DQ=PIGCopyTable(initialNumRaid)
			local renyuanNew = NewZhiyeData
			for xulie=1,#Roles_List do
				for id=1,#Roles_List[xulie] do
					fujiF.Datas_DQ.Xulie_MB[xulie][id]=fujiF.Datas_DQ.Xulie_MB[xulie][id] or 0
					for k,v in pairs(renyuanNew) do
						fujiF.Datas_DQ.All=fujiF.Datas_DQ.All+1
						if v[1]==Roles_List[xulie][id][1] then
							if v[2]==Roles[xulie] then
								fujiF.Datas_DQ.Xulie[xulie]=fujiF.Datas_DQ.Xulie[xulie]+1
								fujiF.Datas_DQ.Xulie_MB[xulie][id]=fujiF.Datas_DQ.Xulie_MB[xulie][id]+1
							end
						end
					end
				end
			end
		end	
	end
	function fujiF.Is_RaidNumOK(laiyuan)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		local mubiaornshu = 40
		if PIGA["Tardis"]["Yell"]["InvMode"]==1 then
			mubiaornshu = PIGA["Tardis"]["Yell"]["MaxPlayerNum"]
		elseif PIGA["Tardis"]["Yell"]["InvMode"]==2 then
			mubiaornshu = fujiF.Datas_MB.All
		end
		if numGroupMembers>=mubiaornshu then
			if laiyuan~="event" then
				OFF_autoInvite("已达目标人数,自动邀请已关闭")
			end
			return false
		end
		return true,numGroupMembers
	end
	function fujiF.Auto_FunOpen()
		if Pig_OptionsUI.autoInvite_daiben then
			PIGinfotip:TryDisplayMessage("带本助手自动邀请处于开启状态，请先关闭");
		else
			if Pig_OptionsUI.autoInvite_shikong then
				OFF_autoInvite("已|cffFF0000关闭|r自动邀请")
			else
				if not EditBox_panduan(PIGA["Tardis"]["Yell"]["Yell_NR"]) and fujiF.Is_GroupLeader() and fujiF.Is_RaidNumOK() then
					Pig_OptionsUI.autoInvite_shikong=true
					fujiF.botF_R.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp");
					if QkBut_Invite_Yell then QkBut_Invite_Yell.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp"); end
					fujiF:RegisterEvent("CHAT_MSG_WHISPER");
					fujiF:RegisterEvent("CHAT_MSG_SYSTEM")
					fujiF.Updata_Macro("OPEN")
					PIGinfotip:TryDisplayMessage("已|cff00FF00开启|r自动邀请");
				end
			end
		end
	end
	--------
	local function hanhuadaojishiTime()
		if fujiF.hanhuadaojishi>0 then
			fujiF.botF_L.yellbut:SetText(ON_COOLDOWN.."("..fujiF.hanhuadaojishi..")");
			C_Timer.After(1,hanhuadaojishiTime)
			fujiF.hanhuadaojishi=fujiF.hanhuadaojishi-1
		else
			fujiF.botF_L.yellbut:Enable() 
			fujiF.botF_L.yellbut:SetText(SEND_LABEL..L["TARDIS_YELL"]);
		end
	end
	function fujiF.Kaishi_Yell(self)
		if EditBox_panduan(PIGA["Tardis"]["Yell"]["Yell_NR"]) then return end
		local yellpindaolist =GetYellPindao(fujiF.PindaoList,PIGA["Tardis"]["Yell"]["Yell_CHANNEL"])
		local keyongshu = #yellpindaolist
		if keyongshu>0 then
			local famsg =Get_famsg("yell",PIGA["Tardis"]["Yell"]["Yell_NR"],PIGA["Tardis"]["Yell"]["jinzuCMD"],PIGA["Tardis"]["Yell"]["jinzuCMD_inv"])
			for x=1,#yellpindaolist do
				local suijishu=random(1, 8)
				local famsg = famsg..MSGsuijizifu[suijishu]
				SendChatMessage(famsg,yellpindaolist[x][1],nil,yellpindaolist[x][2])
			end
			fujiF.hanhuadaojishi=fujiF.hanhuajiange*keyongshu
			fujiF.botF_L.yellbut:Disable();
			fujiF.botF_L.yellbut:SetText(L["TARDIS_YELL"].."("..fujiF.hanhuadaojishi..")");
			if self then self.Cooldown:SetCooldown(GetTime(), fujiF.hanhuajiange*keyongshu) end
			hanhuadaojishiTime()
		else
			PIGinfotip:TryDisplayMessage("请先选择喊话频道");
		end
	end
	--===================================
	local yizuduiERR=ERR_ALREADY_IN_GROUP_S:gsub("%%s","")
	--local zhiyeweizhiNameQ={"坦克","治疗","输出"}
	local zhiyeweizhiKey={{"T","坦","熊","防骑","FQ"},{"N","奶","治疗"},{"DPS", "dps","伤害","输出","KBZ", "kbz", "狂暴","惩戒","电萨","鸟德","鸟D"}}
	--执行邀请
	local function PIG_Invite_Fun(Pname)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers==5 and not IsInRaid(LE_PARTY_CATEGORY_HOME) then
			ConvertToRaid()
		end
		InviteUnit(Pname)
	end
	fujiF.lishiwanjiaxinxi={};
	function fujiF.Is_Oldmiyu(Pname)
		for i=1,#fujiF.lishiwanjiaxinxi do
			if Pname == fujiF.lishiwanjiaxinxi[i][2] then
				return true
			end
		end
		return false
	end
	function fujiF.GetKeyXulieID(arg1)					
		for Keyxulie=1,#zhiyeweizhiKey do
			for Keytxt=1,#zhiyeweizhiKey[Keyxulie] do
				if arg1:match(zhiyeweizhiKey[Keyxulie][Keytxt]) then
					return Keyxulie
				end
			end
		end
		return false
	end
	----------
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:RegisterEvent("GROUP_ROSTER_UPDATE")
	fujiF:HookScript("OnEvent",function(self,event,arg1,arg2,_,_,arg5,_,_,_,_,_,_,arg12)
		if event=="PLAYER_ENTERING_WORLD" then
			C_Timer.After(3,gengxinhongtxt)
		elseif event=="GROUP_ROSTER_UPDATE" then
			C_Timer.After(0.6,function()
				self.GetNumRaidPlayers()
				self.Is_GroupLeader("event")
				self.Is_RaidNumOK("event")
			end)
		else
			if not Pig_OptionsUI.autoInvite_shikong then return end
			if arg1:match("[!Pig]") then return end
			if event=="CHAT_MSG_SYSTEM" then
				if arg1:match(yizuduiERR) then
					local wanjianameXXk=arg1:gsub(yizuduiERR,"")
					SendChatMessage("[!Pig] 你已有队伍，请退组后再M", "WHISPER", nil, wanjianameXXk);
				end
			end
			if event=="CHAT_MSG_WHISPER" then
					for ih=#fujiF.lishiwanjiaxinxi,1,-1 do
						if (GetServerTime()-fujiF.lishiwanjiaxinxi[ih][1])>60 then
							table.remove(fujiF.lishiwanjiaxinxi, ih);
						end
					end
					local localizedClass, englishClass= GetPlayerInfoByGUID(arg12)
					if PIGA["Tardis"]["Yell"]["InvMode"]==1 then--根据自定义内容判断
						for tjID=1,tiaojianNUM do
							if PIGA["Tardis"]["Yell"]["InvMode1_Info"][tjID]["Open"] then
								if tjID==1 then
									if arg1==PIGA["Tardis"]["Yell"]["jinzuCMD"] then
										PIG_Invite_Fun(arg2)
										return
									end
								elseif tjID==2 then
									local tiaojianTXT = fujiF.topF.autoHF.keydata[tjID]["TJ"]
									for tjtxt=1,#tiaojianTXT do
										if arg1:match(tiaojianTXT[tjtxt]) then
											PIG_Invite_Fun(arg2)
											return
										end
									end
								else
									local tiaojianTXT = fujiF.topF.autoHF.keydata[tjID]["TJ"]
									for tjtxt=1,#tiaojianTXT do
										if arg1:match(tiaojianTXT[tjtxt]) then
											local huifuTXT = fujiF.topF.autoHF.keydata[tjID]["HF"]
											SendChatMessage("[!Pig] "..huifuTXT, "WHISPER", nil, arg2);
											return
										end
									end
								end
							end
						end
					elseif PIGA["Tardis"]["Yell"]["InvMode"]==2 then--判断职业职责
						if arg1==PIGA["Tardis"]["Yell"]["jinzuCMD"] then
							local zhizeNum = #cl_Name_Role[englishClass]
							if zhizeNum==1 then
								local xulieID = RolesXulie[cl_Name_Role[englishClass][1]]
								local zhizezhiyeList = Roles_List[xulieID]
								for id=1,#zhizezhiyeList do
									if zhizezhiyeList[id][1]==englishClass then
										if fujiF.Datas_DQ.Xulie_MB[xulieID][id]<fujiF.Datas_MB.Xulie_MB[xulieID][id] then
											PIG_Invite_Fun(arg2)
										else
											SendChatMessage("[!Pig] "..localizedClass .. "已满，可换其他职业，感谢支持", "WHISPER", nil, arg2);
										end
										break
									end	
								end
							elseif zhizeNum>1 then
								local xuqiuzhizeInfo = {}
								local xulieIDList = cl_Name_Role[englishClass]
								for xu=1,#xulieIDList do
									local xulieID = RolesXulie[xulieIDList[xu]]
									xuqiuzhizeInfo[xulieIDList[xu]]=0
									local zhizezhiyeList = Roles_List[xulieID]
									for id=1,#zhizezhiyeList do
										if zhizezhiyeList[id][1]==englishClass then
											if fujiF.Datas_DQ.Xulie_MB[xulieID][id]<fujiF.Datas_MB.Xulie_MB[xulieID][id] then
												table.insert(xuqiuzhizeInfo,xulieIDList[xu])
											end
										end	
									end
								end
								if #xuqiuzhizeInfo>0 then
									local zuduizhushou_MSG=localizedClass.."尚缺:";
									for img=1,#xuqiuzhizeInfo do
										zuduizhushou_MSG=zuduizhushou_MSG.._G[xuqiuzhizeInfo[img]]..","
									end
									SendChatMessage("[!Pig] "..zuduizhushou_MSG.."请回复职责", "WHISPER", nil, arg2);
									table.insert(fujiF.lishiwanjiaxinxi,{GetServerTime(),arg2,chazhiyefenlai})
								end
							end
						else
							if fujiF.Is_Oldmiyu(arg2) then
								local Keyxulie = fujiF.GetKeyXulieID(arg1)
								if Keyxulie then
									local xulieID = Keyxulie
									local zhizezhiyeList = Roles_List[xulieID]
									for id=1,#zhizezhiyeList do
										if zhizezhiyeList[id][1]==englishClass then
											if fujiF.Datas_DQ.Xulie_MB[xulieID][id]<fujiF.Datas_MB.Xulie_MB[xulieID][id] then
												PIG_Invite_Fun(arg2)
											else
												SendChatMessage("[!Pig] ".._G[Roles[Keyxulie]]..localizedClass .. "已满，可换其他职业或天赋，感谢支持", "WHISPER", nil, arg2);
											end
											break
										end	
									end
								end
							end
							-----
						end
					end
			------------
			end
		end
	end)
end