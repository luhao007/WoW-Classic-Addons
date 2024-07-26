local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L= unpack(PIG)
local match = _G.string.match
------------------------
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGQuickBut=Create.PIGQuickBut
local PIGSetFont=Create.PIGSetFont
local PIGCloseBut=Create.PIGCloseBut
local FasongYCqingqiu=Fun.FasongYCqingqiu
-----------------
local TalentData=Data.TalentData
local GetTianfuIcon_YC=TalentData.GetTianfuIcon_YC
local tabheji = {}
local tabhejiNameth = {}
local function Getfenleidata(tab1,tab2)
	local cunzail = C_LFGList.GetAvailableCategories()
	if #cunzail==0 then
		C_Timer.After(0.6,function() Getfenleidata(tab1,tab2) end)
	else
		--系统活动类型(地下城2/团队114/任务和地图116/PVP118/自定义120)
		--local tabheji={{DUNGEONS,2},{GUILD_INTEREST_RAID,114},{OTHER,120}}--活动类型
		local baseFilters = LFGListFrame.baseFilters;
		for _,v in pairs(C_LFGList.GetAvailableCategories(baseFilters)) do
			local kkdfin= C_LFGList.GetLfgCategoryInfo(v)
			local renwuname=kkdfin.name:match(QUESTS_LABEL)
			if renwuname then
				tabhejiNameth[kkdfin.name]=QUESTS_LABEL
				kkdfin.name=QUESTS_LABEL
			end
			if kkdfin.name==CUSTOM then
				table.insert(tabheji,{118,"PVP"})
				table.insert(tabheji,{v,kkdfin.name})
			-- 	tabhejiNameth[kkdfin.name]=OTHER
			-- 	kkdfin.name=OTHER
			else
				table.insert(tabheji,{v,kkdfin.name})
			end
		end
		for i=1,#tabheji do
			if tabheji[i][1]==114 then
				table.remove(tabheji,i);
				table.insert(tabheji,1,{114,GUILD_INTEREST_RAID})
				break
			end
		end
		--tab1
		local tab1_1,tab1_2,tab1_3 = tab1[1],tab1[2],tab1[3]
		local xuanzehuodong=PIGFontString(tab1_1,{"TOPLEFT",tab1_1,"TOPLEFT",tab1_2,tab1_3},SEARCH)
		for i=1,#tabheji do
			local ckbut = PIGCheckbutton(tab1_1,nil,{tabheji[i][2],nil},nil,"Chedui_guolv"..i,tabheji[i][1])
			if i==1 then
				ckbut:SetPoint("LEFT",xuanzehuodong,"RIGHT",8,0)
			else
				ckbut:SetPoint("LEFT",_G["Chedui_guolv"..(i-1)].Text,"RIGHT",8,0)
			end
			ckbut:HookScript("OnClick", function (self)
				for ix=1,#tabheji do
					_G["Chedui_guolv"..ix]:SetChecked(false)
				end
				self:SetChecked(true)
				tab1_1.selectedCategory=self:GetID()
				tab1_1.GetBut:GetBut_Disable()
			end)
		end
		--tab2
		local tab2_1,tab2_2,tab2_3 = tab2[1],tab2[2],tab2[3]
		for i=1,#tabheji do
			local ckbut = PIGCheckbutton(tab2_1,nil,{tabheji[i][2],nil},nil,"ADD_Wodeche_guolv"..i,tabheji[i][1])
			if i==1 then
				ckbut:SetPoint("TOPLEFT",tab2_1,"TOPLEFT",tab2_2,tab2_3)
			elseif i==4 then
				ckbut:SetPoint("TOPLEFT",ADD_Wodeche_guolv1,"BOTTOMLEFT",0,-6)
			else
				ckbut:SetPoint("LEFT",_G["ADD_Wodeche_guolv"..(i-1)],"RIGHT",66,0)
			end
			ckbut:HookScript("OnClick", function (self)		
				local fujk = tab2_1:GetParent()
				tab2_1:PIG_Clear()
				self:SetChecked(true)
				fujk.selectedCategory=self:GetID()
				tab2_1:SetEditMode()
			end)
		end
	end
end
local function PIG_LFGListSearchEntry_UpdateExpiration(self)
	local duration = 0;
	local now = GetTime();
	if ( self.expiration and self.expiration > now ) then
		duration = self.expiration - now;
	end
	local minutes = math.floor(duration / 60);
	local seconds = duration % 60;
	self.caozuo.ExpirationTime:SetFormattedText("%d:%.2d", minutes, seconds);
end
---------
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Chedui(Activate)
	if not PIGA["Tardis"]["Chedui"]["Open"] then return end
	local zhizeIcon=Data.zhizeIcon
	local cl_Name=Data.cl_Name
	local zhizename = {"TANK","HEALER", "DAMAGER"}
	local zhiyename = {}
	for i=1,#cl_Name do
		table.insert(zhiyename,cl_Name[i][1])
	end
	local InviteUnit=InviteUnit or C_PartyInfo and C_PartyInfo.InviteUnit
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local hang_Height,hang_NUM=InvF.hang_Height,InvF.hang_NUM
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_CHEDUI"],80,"Bot")
	if Activate then
		fujiF:Show()
		fujiTabBut:Selected()
	end
	fujiF.F=PIGOptionsList_RF(fujiF,28,nil,{4,4,4})
	fujiF.F:PIGSetBackdrop()

	--人员详情提示
	local tishikWW,tishikHH,biaotiH = 350,80,20
	fujiF.F.EnterF = PIGFrame(fujiF.F);
	fujiF.F.EnterF:PIGSetBackdrop(1)
	fujiF.F.EnterF:SetSize(tishikWW,tishikHH*3+biaotiH);
	fujiF.F.EnterF:SetFrameLevel(fujiF.F:GetFrameLevel()+10)	
	fujiF.F.EnterF:Hide()
	PIGFontString(fujiF.F.EnterF,{"TOPLEFT", fujiF.F.EnterF, "TOPLEFT", 4,-2},MEMBERS..INFO,"OUTLINE");
	fujiF.F.EnterF.errtishi=PIGFontString(fujiF.F.EnterF,{"CENTER", fujiF.F.EnterF, "CENTER", 0,0},LFG_LIST_ENTRY_DELISTED,"OUTLINE");
	fujiF.F.EnterF.errtishi:SetTextColor(1,0,0,1);
	fujiF.F.EnterF.errtishi:Hide();
	for ix=1,#zhizename do
		local tishiui = CreateFrame("Frame", "Chedui_tishi_"..zhizename[ix], fujiF.F.EnterF);
		tishiui:SetSize(tishikWW,tishikHH);
		if ix==1 then
			tishiui:SetPoint("TOPLEFT", fujiF.F.EnterF, "TOPLEFT", 0, -biaotiH);
		else
			PIGLine(tishiui,"TOP",-0,nil,nil,{0.2,0.2,0.2,0.5})
			tishiui:SetPoint("TOPLEFT", _G["Chedui_tishi_"..zhizename[ix-1]], "BOTTOMLEFT", 0, 0);
		end
		tishiui.ICON = tishiui:CreateTexture();
		tishiui.ICON:SetAtlas(GetIconForRole(zhizename[ix], false), TextureKitConstants.IgnoreAtlasSize);
		tishiui.ICON:SetSize(hang_Height+8,hang_Height+8);
		tishiui.ICON:SetPoint("LEFT", tishiui, "LEFT", 2,10);
		tishiui.heji = PIGFontString(tishiui,{"TOP", tishiui.ICON, "BOTTOM",0, 0},0,"OUTLINE");
		for class=1,#zhiyename do
			local tishizhiye = CreateFrame("Frame", "Chedui_tishi_"..zhizename[ix].."_"..class, tishiui);
			tishizhiye:SetSize(1,hang_Height-4);
			if class<8 then
				if class==1 then
					tishizhiye:SetPoint("TOPLEFT", tishiui, "TOPLEFT", 44*class+38,-12);
				else
					tishizhiye:SetPoint("TOPLEFT", tishiui, "TOPLEFT", 44*class+38,-12);
				end
			else
				tishizhiye:SetPoint("TOPLEFT", tishiui, "TOPLEFT", 44*(class-7)+38,-42);
			end
			tishizhiye.icon = tishizhiye:CreateTexture();
			tishizhiye.icon:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
			tishizhiye.icon:SetSize(hang_Height-4,hang_Height-4);
			tishizhiye.icon:SetPoint("RIGHT", tishizhiye, "RIGHT", 0,0);
			tishizhiye.heji = PIGFontString(tishizhiye,{"RIGHT", tishizhiye.icon, "LEFT",0, 0},0,"OUTLINE");
			tishizhiye.heji:SetTextColor(1, 1, 1, 1);
		end
	end	
	function fujiF.F.EnterF:ShowTishi(hangUI,laiyu)
		local hangF=hangUI:GetParent() 
		self:ClearAllPoints();
		self:SetPoint("RIGHT", hangUI, "LEFT", 0,0);
		self:Show()
		self.errtishi:Hide();
		for ix=1,#zhizename do
			_G["Chedui_tishi_"..zhizename[ix]]:Hide()
			for class=1,#zhiyename do
				_G["Chedui_tishi_"..zhizename[ix].."_"..class]:Hide()
			end
		end
		local chengyuaninfo = {	
			["TANK"] = {0,{}},
			["HEALER"] = {0,{}},
			["DAMAGER"] = {0,{}},
		}
		if laiyu then
			if not C_LFGList.HasActiveEntryInfo() then return end
			local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
			if numGroupMembers>0 then
				for p=1,MAX_RAID_MEMBERS do
					local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(p);
					if name then
						if chengyuaninfo[combatRole][2][fileName] then
							chengyuaninfo[combatRole][2][fileName]=chengyuaninfo[combatRole][2][fileName]+1
						else
							chengyuaninfo[combatRole][2][fileName]=1
						end
					end
				end
			end
		else
			local resultID=hangF.resultID
			local searchResultInfo=C_LFGList.GetSearchResultInfo(resultID)
			if searchResultInfo.isDelisted then
				self.errtishi:Show();
			else	
				for ix=1, searchResultInfo.numMembers do
					local role, class, classLocalized, specLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, ix);
					chengyuaninfo[role][1]=chengyuaninfo[role][1]+1
					if chengyuaninfo[role][2][class] then
						chengyuaninfo[role][2][class]=chengyuaninfo[role][2][class]+1
					else
						chengyuaninfo[role][2][class]=1
					end
				end
			end
		end
		for ix=1,#zhizename do
			local zhiyocin = _G["Chedui_tishi_"..zhizename[ix]]
			zhiyocin:Show()
			zhiyocin.heji:SetText(chengyuaninfo[zhizename[ix]][1])
			local zhizezhiyeNum = {}
			for class=1,#zhiyename do
				if chengyuaninfo[zhizename[ix]][2][zhiyename[class]] then
					table.insert(zhizezhiyeNum,{zhiyename[class],chengyuaninfo[zhizename[ix]][2][zhiyename[class]]})
				end
			end
			for uiid=1,#zhizezhiyeNum do
				local zzzyui = _G["Chedui_tishi_"..zhizename[ix].."_"..uiid]
				zzzyui:Show()
				zzzyui.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[zhizezhiyeNum[uiid][1]]));
				zzzyui.heji:SetText(zhizezhiyeNum[uiid][2])
			end
		end
	end

	--申请界面
	--local SQUI = LFGListApplicationDialogDescription
	-- local jilubutww,jiluhangNum = 500,7
	-- SQUI:SetPoint("BOTTOM",-20,55);
	-- SQUI.ApplyMode = PIGButton(SQUI, {"LEFT", SQUI, "RIGHT", 10, 0},{38,36},SIGN_UP.."\n"..GUILD_BANK_LOG);
	-- SQUI.ApplyMode.F=PIGFrame(SQUI.ApplyMode,{"RIGHT",SQUI.ApplyMode,"LEFT",0,30})
	-- SQUI.ApplyMode.F:SetSize(jilubutww,200);
	-- SQUI.ApplyMode.F:PIGSetBackdrop(1)
	-- SQUI.ApplyMode.F:PIGClose()
	-- SQUI.ApplyMode.F:Hide()
	-- SQUI.ApplyMode:HookScript("OnClick", function(self)
	-- 	if self.F:IsShown() then
	-- 		self.F:Hide()
	-- 	else
	-- 		self.F:Show()
	-- 		for i=1,jiluhangNum do
	-- 			 _G["ApplyModeList_"..i].t:SetText(SIGN_UP..GUILD_BANK_LOG)
	-- 		end
	-- 	end
	-- end)
	-- SQUI.ApplyMode.F.biaoti=PIGFontString(SQUI.ApplyMode.F,{"TOP",SQUI.ApplyMode.F,"TOP",0,-4},SIGN_UP..GUILD_BANK_LOG)
	-- SQUI.ApplyMode.F.line = PIGLine(SQUI.ApplyMode.F,"TOP",-24,nil,nil,{0.2,0.2,0.2,0.5})
	-- --申请自动填主副天赋
	-- for i=1,jiluhangNum do
	-- 	local hangL = CreateFrame("Button", "ApplyModeList_"..i, SQUI.ApplyMode.F,"BackdropTemplate");
	-- 	hangL:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
	-- 	hangL:SetSize(jilubutww-2,24);
	-- 	hangL:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
	-- 	if i==1 then
	-- 		hangL:SetPoint("TOPLEFT", SQUI.ApplyMode.F, "TOPLEFT", 0, -25);
	-- 	else
	-- 		hangL:SetPoint("TOPLEFT", _G["ApplyModeList_"..(i-1)], "BOTTOMLEFT", 0, -1);
	-- 	end
	-- 	hangL:HookScript("OnEnter", function (self)
	-- 		self:SetBackdropColor(0.4, 0.4, 0.4, 0.2);
	-- 	end);
	-- 	hangL:HookScript("OnLeave", function (self)
	-- 		self:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
	-- 	end);
	-- 	hangL:HookScript("OnClick", function (self)
	-- 		LFGListApplicationDialog.Description.EditBox:SetText(self.t:GetText());
	-- 	end);
	-- 	hangL.t=PIGFontString(hangL,{"LEFT",hangL,"LEFT",0,0})
	-- 	hangL.t:SetTextColor(0.9,0.9,0.9, 1);
	-- end
	---
	local TabF,TabBut=PIGOptionsList_R(fujiF.F,"找车队",70)
	TabBut:HookScript("OnClick", function (self)
		TabF.Hang_Clear()
	end);

	TabF.GetBut=PIGButton(TabF,{"TOPLEFT",TabF,"TOPLEFT",520,-6},{80,21},L["DEBUG_REFRESH"])
	TabF.GetBut:Hide()
	function TabF.GetBut:GetBut_Enable()
		self:Show()
		for ix=1,#tabheji do
			_G["Chedui_guolv"..ix]:Enable()
		end
	end
	function TabF.GetBut:GetBut_Disable()
		TabF.yihuifu=false
		C_Timer.After(2,function()
			if not TabF.yihuifu then TabF.GetBut:GetBut_Enable() end 
		end)
		self:Hide()
		for ix=1,#tabheji do
			_G["Chedui_guolv"..ix]:Disable()
		end
		TabF.Hang_Clear()
		local languages = C_LFGList.GetLanguageSearchFilter();
		C_LFGList.Search(TabF.selectedCategory, 0, 0, languages);--[1大分类][2小分类(5疑似自己建立队伍)][1推荐,2不推荐,4PVE,8PVP][语言过滤]
	end
	TabF.GetBut:HookScript("OnClick", function (self)
		self:GetBut_Disable()
	end);
	----
	TabF.F=PIGFrame(TabF,{"TOPLEFT",TabF,"TOPLEFT",0,-32})
	TabF.F:SetPoint("BOTTOMRIGHT",TabF,"BOTTOMRIGHT",0,0);
	TabF.F:PIGSetBackdrop()
	--
	local biaotiName={{"目的地",6},{"司机(|cffFF80FF点击"..L["CHAT_WHISPER"].."|r)",200},{"乘客",320},{"装等",440},{"乘车须知",490},{"操作",800}}
	for i=1,#biaotiName do
		local biaoti=PIGFontString(TabF.F,{"TOPLEFT",TabF.F,"TOPLEFT",biaotiName[i][2],-5},biaotiName[i][1])
		biaoti:SetTextColor(1,1,0, 0.9);
	end
	TabF.F.line = PIGLine(TabF.F,"TOP",-24,nil,nil,{0.2,0.2,0.2,0.5})
	local hang_Width = TabF.F:GetWidth();
	TabF.F.Scroll = CreateFrame("ScrollFrame",nil,TabF.F, "FauxScrollFrameTemplate");  
	TabF.F.Scroll:SetPoint("TOPLEFT",TabF.F,"TOPLEFT",2,-24);
	TabF.F.Scroll:SetPoint("BOTTOMRIGHT",TabF.F,"BOTTOMRIGHT",-20,2);
	TabF.F.Scroll.ScrollBar:SetScale(0.8);
	TabF.F.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, TabF.Hang_Gengxin)
	end)
	for i=1, hang_NUM, 1 do
		local hangL = CreateFrame("Button", "CheduiList_"..i, TabF.F,"BackdropTemplate");
		hangL:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hangL:SetSize(hang_Width-2,hang_Height);
		hangL:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		if i==1 then
			hangL:SetPoint("TOPLEFT", TabF.F.Scroll, "TOPLEFT", 0, -1);
		else
			hangL:SetPoint("TOPLEFT", _G["CheduiList_"..(i-1)], "BOTTOMLEFT", 0, -1);
		end
		hangL:HookScript("OnEnter", function (self)
			self:SetBackdropColor(0.4, 0.4, 0.4, 0.2);
		end);
		hangL:HookScript("OnLeave", function (self)
			self:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		end);
		hangL.resultIDT=PIGFontString(hangL,{"RIGHT", hangL, "LEFT", -10,0},0,"OUTLINE");
		hangL.resultIDT:Hide()
		hangL.mudidi = PIGFontString(hangL,{"LEFT", hangL, "LEFT",biaotiName[1][2], 0});
		hangL.mudidi:SetTextColor(0,0.98,0.6, 1);
		hangL.mudidi:SetJustifyH("LEFT");
		function hangL:mudidi_UpdataData(searchResultInfo,SetcategoryID)
			local activityName = C_LFGList.GetActivityFullName(searchResultInfo.activityID, nil, searchResultInfo.isWarMode);
			if SetcategoryID==2 then
				hangL.mudidi:SetText(activityName);
			elseif SetcategoryID==114 then
				hangL.mudidi:SetText(activityName);
			elseif SetcategoryID==116 then
				hangL.mudidi:SetText(activityName.."("..searchResultInfo.name..")");
			elseif SetcategoryID==118 then
				hangL.mudidi:SetText(activityName);
			elseif SetcategoryID==120 then
				hangL.mudidi:SetText(searchResultInfo.name);
			end
		end
		hangL.chetou = CreateFrame("Frame", nil, hangL);
		hangL.chetou:SetSize(120,hang_Height);
		hangL.chetou:SetPoint("LEFT", hangL, "LEFT", biaotiName[2][2], 0);
		hangL.chetou.T = PIGFontString(hangL,{"LEFT", hangL.chetou, "LEFT", 0, 0});
		hangL.chetou:SetScript("OnMouseUp", function(self,button)
			local wjName = self.allname
			if wjName==UNKNOWNOBJECT then return end
			local editBox = ChatEdit_ChooseBoxForSend();
			local hasText = editBox:GetText()
			if editBox:HasFocus() then
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			else
				ChatEdit_ActivateChat(editBox)
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			end
		end)
		--五人本人员显示模式
		hangL.RoleEnumerate = CreateFrame("Frame", nil, hangL);
		hangL.RoleEnumerate:SetSize(120,hang_Height);
		hangL.RoleEnumerate:SetPoint("LEFT", hangL, "LEFT", biaotiName[3][2]-12, 0);
		hangL.RoleEnumerate.Higt = hangL.RoleEnumerate:CreateTexture(nil,"HIGHLIGHT");
		hangL.RoleEnumerate.Higt:SetTexture("interface/buttons/ui-common-mousehilight.blp");
		hangL.RoleEnumerate.Higt:SetAllPoints(hangL.RoleEnumerate)
		hangL.RoleEnumerate.Higt:SetBlendMode("ADD")
		hangL.RoleEnumerate.Higt:SetAlpha(0.4)
		hangL.RoleEnumerate.T = hangL.RoleEnumerate:CreateTexture(nil, "BORDER");
		hangL.RoleEnumerate.T:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleEnumerate.T:SetPoint("LEFT", hangL.RoleEnumerate, "LEFT", 2,-1);
		hangL.RoleEnumerate.T:SetAlpha(0.9);
		hangL.RoleEnumerate.Tjiao = hangL.RoleEnumerate:CreateTexture(nil,"ARTWORK");
		hangL.RoleEnumerate.Tjiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
		hangL.RoleEnumerate.Tjiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[1]));
		hangL.RoleEnumerate.Tjiao:SetSize(hang_Height-10,hang_Height-10);
		hangL.RoleEnumerate.Tjiao:SetPoint("BOTTOMLEFT", hangL.RoleEnumerate.T, "TOPRIGHT", -10,-10);
		hangL.RoleEnumerate.Tjiao:SetAlpha(0.7);

		hangL.RoleEnumerate.H = hangL.RoleEnumerate:CreateTexture(nil, "BORDER");
		hangL.RoleEnumerate.H:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleEnumerate.H:SetPoint("LEFT", hangL.RoleEnumerate.T, "RIGHT", 2,0);
		hangL.RoleEnumerate.H:SetAlpha(0.9);
		hangL.RoleEnumerate.Hjiao = hangL.RoleEnumerate:CreateTexture(nil,"ARTWORK");
		hangL.RoleEnumerate.Hjiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
		hangL.RoleEnumerate.Hjiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[2]));
		hangL.RoleEnumerate.Hjiao:SetSize(hang_Height-10,hang_Height-10);
		hangL.RoleEnumerate.Hjiao:SetPoint("BOTTOMLEFT", hangL.RoleEnumerate.H, "TOPRIGHT", -10,-10);
		hangL.RoleEnumerate.Hjiao:SetAlpha(0.7);

		hangL.RoleEnumerate.D = hangL.RoleEnumerate:CreateTexture(nil, "BORDER");
		hangL.RoleEnumerate.D:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleEnumerate.D:SetPoint("LEFT", hangL.RoleEnumerate.H, "RIGHT", 2,0);
		hangL.RoleEnumerate.D:SetAlpha(0.9);
		hangL.RoleEnumerate.Djiao = hangL.RoleEnumerate:CreateTexture(nil,"ARTWORK");
		hangL.RoleEnumerate.Djiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
		hangL.RoleEnumerate.Djiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
		hangL.RoleEnumerate.Djiao:SetSize(hang_Height-10,hang_Height-10);
		hangL.RoleEnumerate.Djiao:SetPoint("BOTTOMLEFT", hangL.RoleEnumerate.D, "TOPRIGHT", -10,-10);
		hangL.RoleEnumerate.Djiao:SetAlpha(0.7);
		hangL.RoleEnumerate.D1 = hangL.RoleEnumerate:CreateTexture(nil, "BORDER");
		hangL.RoleEnumerate.D1:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleEnumerate.D1:SetPoint("LEFT", hangL.RoleEnumerate.D, "RIGHT", 2,0);
		hangL.RoleEnumerate.D1:SetAlpha(0.9);
		hangL.RoleEnumerate.D1jiao = hangL.RoleEnumerate:CreateTexture(nil,"ARTWORK");
		hangL.RoleEnumerate.D1jiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
		hangL.RoleEnumerate.D1jiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
		hangL.RoleEnumerate.D1jiao:SetSize(hang_Height-10,hang_Height-10);
		hangL.RoleEnumerate.D1jiao:SetPoint("BOTTOMLEFT", hangL.RoleEnumerate.D1, "TOPRIGHT", -10,-10);
		hangL.RoleEnumerate.D1jiao:SetAlpha(0.7);
		hangL.RoleEnumerate.D2 = hangL.RoleEnumerate:CreateTexture(nil, "BORDER");
		hangL.RoleEnumerate.D2:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleEnumerate.D2:SetPoint("LEFT", hangL.RoleEnumerate.D1, "RIGHT", 2,0);
		hangL.RoleEnumerate.D2:SetAlpha(0.9);
		hangL.RoleEnumerate.D2jiao = hangL.RoleEnumerate:CreateTexture(nil,"ARTWORK");
		hangL.RoleEnumerate.D2jiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
		hangL.RoleEnumerate.D2jiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
		hangL.RoleEnumerate.D2jiao:SetSize(hang_Height-10,hang_Height-10);
		hangL.RoleEnumerate.D2jiao:SetPoint("BOTTOMLEFT", hangL.RoleEnumerate.D2, "TOPRIGHT", -10,-10);
		hangL.RoleEnumerate.D2jiao:SetAlpha(0.7);
		hangL.RoleEnumerate:HookScript("OnEnter", function (self)
			fujiF.F.EnterF:ShowTishi(self)
		end);
		hangL.RoleEnumerate:HookScript("OnLeave", function (self)
			fujiF.F.EnterF:Hide()
		end);
		--其他人员显示模式
		hangL.RoleCount = CreateFrame("Frame", nil, hangL);
		hangL.RoleCount:SetSize(120,hang_Height);
		hangL.RoleCount:SetPoint("LEFT", hangL, "LEFT", biaotiName[3][2]-12, 0);
		hangL.RoleCount.Higt = hangL.RoleCount:CreateTexture(nil,"HIGHLIGHT");
		hangL.RoleCount.Higt:SetTexture("interface/buttons/ui-common-mousehilight.blp");
		hangL.RoleCount.Higt:SetAllPoints(hangL.RoleCount)
		hangL.RoleCount.Higt:SetBlendMode("ADD")
		hangL.RoleCount.Higt:SetAlpha(0.4)
		hangL.RoleCount.T = hangL.RoleCount:CreateTexture();
		hangL.RoleCount.T:SetAtlas(GetIconForRole(zhizename[1], false), TextureKitConstants.IgnoreAtlasSize);
		hangL.RoleCount.T:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleCount.T:SetPoint("LEFT", hangL.RoleCount, "LEFT", 19,0);
		hangL.RoleCount.T:SetAlpha(0.9);
		hangL.RoleCount.TNum = PIGFontString(hangL.RoleCount,{"RIGHT", hangL.RoleCount.T, "LEFT", 2,0},0,"OUTLINE");
		hangL.RoleCount.TNum:SetTextColor(1, 1, 1, 1);
		hangL.RoleCount.H = hangL.RoleCount:CreateTexture();
		hangL.RoleCount.H:SetAtlas(GetIconForRole(zhizename[2], false), TextureKitConstants.IgnoreAtlasSize);
		hangL.RoleCount.H:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleCount.H:SetPoint("LEFT", hangL.RoleCount.T, "RIGHT", 19,0);
		hangL.RoleCount.H:SetAlpha(0.9);
		hangL.RoleCount.HNum = PIGFontString(hangL.RoleCount,{"RIGHT", hangL.RoleCount.H, "LEFT", 2,0},0,"OUTLINE");
		hangL.RoleCount.HNum:SetTextColor(1, 1, 1, 1);
		hangL.RoleCount.D = hangL.RoleCount:CreateTexture();
		hangL.RoleCount.D:SetAtlas(GetIconForRole(zhizename[3], false), TextureKitConstants.IgnoreAtlasSize);
		hangL.RoleCount.D:SetSize(hang_Height-4,hang_Height-4);
		hangL.RoleCount.D:SetPoint("LEFT", hangL.RoleCount.H, "RIGHT", 19,0);
		hangL.RoleCount.D:SetAlpha(0.9);
		hangL.RoleCount.DNum = PIGFontString(hangL.RoleCount,{"RIGHT", hangL.RoleCount.D, "LEFT", 2,0},0,"OUTLINE");
		hangL.RoleCount.DNum:SetTextColor(1, 1, 1, 1);
		hangL.RoleCount:HookScript("OnEnter", function (self)
			fujiF.F.EnterF:ShowTishi(self)
		end);
		hangL.RoleCount:HookScript("OnLeave", function (self)
			fujiF.F.EnterF:Hide()
		end);
		function hangL:isDelisted(Delisted)
			if Delisted then
				self.mudidi:SetTextColor(0.6,0.6,0.6,0.8);
				self.chetou.T:SetTextColor(0.6,0.6,0.6,0.8);
				self.ilv:SetTextColor(0.6,0.6,0.6,0.8);
				self.commentF.t:SetTextColor(0.6,0.6,0.6,0.8);
				self.caozuo.Apply:Hide()
				self.caozuo.CancelButton:Hide()
				self.caozuo.PendingLabel:Hide()
				self.caozuo.ExpirationTime:Hide()
				self.RoleCount.T:SetDesaturated(true)
				self.RoleCount.H:SetDesaturated(true)
				self.RoleCount.D:SetDesaturated(true)
				self.RoleCount.TNum:SetTextColor(0.6, 0.6, 0.6, 0.8);
				self.RoleCount.HNum:SetTextColor(0.6, 0.6, 0.6, 0.8);
				self.RoleCount.DNum:SetTextColor(0.6, 0.6, 0.6, 0.8);
				self.RoleEnumerate.T:SetDesaturated(true)
				self.RoleEnumerate.H:SetDesaturated(true)
				self.RoleEnumerate.D:SetDesaturated(true)
				self.RoleEnumerate.D1:SetDesaturated(true)
				self.RoleEnumerate.D2:SetDesaturated(true)
			else
				self.mudidi:SetTextColor(0,0.98,0.6, 1);
				self.chetou.T:SetTextColor(1,1,1,1);
				self.commentF.t:SetTextColor(0.9,0.9,0.9,0.9);
				self.RoleCount.T:SetDesaturated(false)
				self.RoleCount.H:SetDesaturated(false)
				self.RoleCount.D:SetDesaturated(false)
				self.RoleCount.TNum:SetTextColor(1, 1, 1, 1);
				self.RoleCount.HNum:SetTextColor(1, 1, 1, 1);
				self.RoleCount.DNum:SetTextColor(1, 1, 1, 1);
				self.RoleEnumerate.T:SetDesaturated(false)
				self.RoleEnumerate.H:SetDesaturated(false)
				self.RoleEnumerate.D:SetDesaturated(false)
				self.RoleEnumerate.D1:SetDesaturated(false)
				self.RoleEnumerate.D2:SetDesaturated(false)
			end
		end
		function hangL:Chengke_UpdataData(searchResultInfo,SetcategoryID)
			self.RoleCount:Hide()
			self.RoleEnumerate:Hide()
			local resultID=self.resultID
			local ActivityInfo= C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)
			if ActivityInfo.displayType==Enum.LFGListDisplayType.RoleEnumerate then
				self.RoleEnumerate:Show()
				self.RoleEnumerate.T:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
				self.RoleEnumerate.T:SetTexCoord(0.1,0.9,0.1,0.9);
				self.RoleEnumerate.H:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
				self.RoleEnumerate.H:SetTexCoord(0.1,0.9,0.1,0.9);
				self.RoleEnumerate.D:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
				self.RoleEnumerate.D:SetTexCoord(0.1,0.9,0.1,0.9);
				self.RoleEnumerate.D1:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
				self.RoleEnumerate.D1:SetTexCoord(0.1,0.9,0.1,0.9);
				self.RoleEnumerate.D2:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
				self.RoleEnumerate.D2:SetTexCoord(0.1,0.9,0.1,0.9);
				local dixiacinfo = {}
				for ix=1,#zhizename do
					dixiacinfo[zhizename[ix]]={}
				end
				for ix=1, searchResultInfo.numMembers do
					local role, class, classLocalized, specLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, ix);
					table.insert(dixiacinfo[role],class)
				end
				if #dixiacinfo[zhizename[1]]>0 then
					self.RoleEnumerate.T:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
					self.RoleEnumerate.T:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[1]][1]]));
				end
				if #dixiacinfo[zhizename[2]]>0 then
					self.RoleEnumerate.H:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
					self.RoleEnumerate.H:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[2]][1]]));
				end
				if #dixiacinfo[zhizename[3]]>0 then
					self.RoleEnumerate.D:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
					self.RoleEnumerate.D:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][1]]));
					if dixiacinfo[zhizename[3]][2] then
						self.RoleEnumerate.D1:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
						self.RoleEnumerate.D1:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][2]]));
					end
					if dixiacinfo[zhizename[3]][3] then
						self.RoleEnumerate.D2:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
						self.RoleEnumerate.D2:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][3]]));
					end
				end
			else
				self.RoleCount:Show()
				local displayData = C_LFGList.GetSearchResultMemberCounts(resultID);			
				self.RoleCount.TNum:SetText(displayData.TANK);
				self.RoleCount.HNum:SetText(displayData.HEALER);
				self.RoleCount.DNum:SetText(displayData.DAMAGER);
			end
		end

		hangL.ilv = PIGFontString(hangL,{"LEFT", hangL, "LEFT", biaotiName[4][2]-6, 0});
		hangL.ilv:SetJustifyH("RIGHT");
		hangL.ilv:SetWidth(34)

		hangL.commentF=PIGFrame(hangL,{"LEFT", hangL, "LEFT",biaotiName[5][2], 0})
		hangL.commentF:SetSize(310,hang_Height-4);
		hangL.commentF.t = PIGFontString(hangL.commentF,{"LEFT", hangL.commentF, "LEFT", 0, 0});
		hangL.commentF.t:SetTextColor(0.9,0.9,0.9,0.9);
		hangL.commentF.t:SetAllPoints(hangL.commentF)
		hangL.commentF.t:SetJustifyH("LEFT");
		hangL.commentF:SetScript("OnEnter", function (self)
			if self.t:IsTruncated() then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				GameTooltip:AddLine(biaotiName[5][1],1,1,0, 0.9)
				GameTooltip:AddLine(self.t:GetText(), 0.9,0.9,0.9, true)
				GameTooltipTextLeft2:SetNonSpaceWrap(true)
				GameTooltip:Show();
			end
		end);
		hangL.commentF:HookScript("OnLeave", function (self)
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);

		hangL.caozuo=PIGFrame(hangL,{"LEFT", hangL, "LEFT", biaotiName[6][2], 0},{54,hang_Height})
		hangL.caozuo.Apply = PIGButton(hangL.caozuo, {"LEFT", hangL.caozuo, "LEFT", 0, 0},{46,18},SIGN_UP);
		PIGSetFont(hangL.caozuo.Apply.Text,12)
		hangL.caozuo.Apply:SetBackdropColor(0.545, 0.137, 0.137,1)
		hangL.caozuo.Apply:HookScript("OnClick", function(self)
			--C_LFGList.ApplyToGroup(self.resultID)
			LFGListApplicationDialog_Show(LFGListApplicationDialog, self:GetParent():GetParent().resultID);
		end)
		hangL.caozuo.CancelButton = PIGCloseBut(hangL.caozuo, {"RIGHT", hangL.caozuo, "RIGHT", 2, 0})
		hangL.caozuo.CancelButton:HookScript("OnClick", function(self)
			C_LFGList.CancelApplication(self:GetParent():GetParent().resultID);
		end)
		hangL.caozuo.PendingLabel = PIGFontString(hangL.caozuo,{"RIGHT", hangL.caozuo.CancelButton, "LEFT", 0, 5.6},"","OUTLINE",12);
		hangL.caozuo.ExpirationTime = PIGFontString(hangL.caozuo,{"RIGHT", hangL.caozuo.CancelButton, "LEFT", -2, -5.6},"","OUTLINE",12);
		hangL.caozuo.ExpirationTime:SetTextColor(0, 1, 0);
		function hangL:caozuo_Updata()
			if C_LFGList.HasActiveEntryInfo() then
				self.caozuo:Hide()
				return
			end
			self.caozuo:Show()
			local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(self.resultID);
			--print(_, appStatus, pendingStatus, appDuration)
			-- pendingStatus/appStatus可能的值
			-- applied - 已提交申请
			-- invited - 申请后被邀请加入小组
			-- inviterejected - 您拒绝了邀请
			-- inviteaccepted - 您接受了邀请
			-- cancelled - 您取消了申请
			-- timedout - 应用程序超时
			-- rejected - 您的申请被拒绝
			-- declined_full - 组现已满员
			-- declined_delisted - 活动已移除
			-- none - 无
			local isApplication = (appStatus ~= "none" or pendingStatus);
			if ( pendingStatus == "applied" and C_LFGList.GetRoleCheckInfo() ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_ROLE_CHECK);
				self.caozuo.PendingLabel:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( pendingStatus == "cancelled" or appStatus == "cancelled" or appStatus == "failed" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_APP_CANCELLED);
				self.caozuo.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( appStatus == "declined" or appStatus == "declined_full" or appStatus == "declined_delisted" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText((appStatus == "declined_full") and LFG_LIST_APP_FULL or LFG_LIST_APP_DECLINED);
				self.caozuo.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( appStatus == "timedout" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_APP_TIMED_OUT);
				self.caozuo.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( appStatus == "invited" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_APP_INVITED);
				self.caozuo.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( appStatus == "inviteaccepted" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_APP_INVITE_ACCEPTED);
				self.caozuo.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( appStatus == "invitedeclined" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_APP_INVITE_DECLINED);
				self.caozuo.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
			elseif ( isApplication and pendingStatus ~= "applied" ) then
				self.caozuo.Apply:Hide()
				self.caozuo.PendingLabel:SetText(LFG_LIST_PENDING);
				self.caozuo.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
				self.caozuo.PendingLabel:Show();
				self.caozuo.ExpirationTime:Show();
				self.caozuo.CancelButton:Show();
			else
				self.caozuo.PendingLabel:Hide();
				self.caozuo.ExpirationTime:Hide();
				self.caozuo.CancelButton:Hide();
				self.caozuo.Apply:Show()
			end
			if ( self.caozuo.ExpirationTime:IsShown() ) then
				self.caozuo.PendingLabel:SetPoint("RIGHT", hangL.caozuo.CancelButton, "LEFT", 0, 5.6);
			else
				self.caozuo.PendingLabel:SetPoint("RIGHT", hangL.caozuo.CancelButton, "LEFT", 4, 0);
			end
			self.expiration = GetTime() + appDuration;
			if ( isApplication ) then
				self:SetScript("OnUpdate", PIG_LFGListSearchEntry_UpdateExpiration);
				PIG_LFGListSearchEntry_UpdateExpiration(self);
			else
				self:SetScript("OnUpdate", nil);
			end
		end
	end
	---清除数据
	function TabF.Hang_Clear()
		TabF.JieshouInfoList={}
		C_LFGList.ClearSearchResults();
		C_LFGList.ClearSearchTextFields();
		for i=1, hang_NUM, 1 do
			local hangL = _G["CheduiList_"..i]
			hangL.resultID=nil
			hangL:Hide()
		end
	end
	TabF.Hang_Clear()
	function TabF.Hang_Gengxin()
		TabF.yihuifu=true
		C_Timer.After(0.6,function() TabF.GetBut:GetBut_Enable() end)
		local totalResultsFound, results = C_LFGList.GetSearchResults()
		-- local totalResultsFound, results = C_LFGList.GetFilteredSearchResults()--根据自己等级筛选过的列表
		-- print(totalResultsFound, results)
		table.sort(results)
		local resultsNum = #results
		if totalResultsFound>0 then
			local ScrollUI = TabF.F.Scroll
			FauxScrollFrame_Update(ScrollUI, resultsNum, hang_NUM, hang_Height);
	    	local offset = FauxScrollFrame_GetOffset(ScrollUI);
	    	for ic = 1, hang_NUM do
				local dangqian = ic+offset;
				if results[dangqian] then
					TabF.JieshouInfoList[results[dangqian]]=ic
					TabF.Hang_Gengxin_H(results[dangqian])
				end
			end
		end
	end
	function TabF.Hang_Gengxin_H(resultID)
		if TabF.JieshouInfoList[resultID] then
			local hangL = _G["CheduiList_"..TabF.JieshouInfoList[resultID]]
			hangL:Show()
			hangL.resultID=resultID
			local searchResultInfo=C_LFGList.GetSearchResultInfo(resultID)
			hangL:isDelisted(searchResultInfo.isDelisted)
			if not searchResultInfo.isDelisted then
				hangL.resultIDT:SetText(resultID);
				local ActivityInfo= C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)				
				local allname=searchResultInfo.leaderName or UNKNOWNOBJECT
				hangL.chetou.allname=allname
				local wjName, fuwiqi = strsplit("-", allname);
				if fuwiqi then
					hangL.chetou.T:SetText(wjName.."(*)");
				else
					hangL.chetou.T:SetText(allname);
				end
				hangL.ilv:SetText(searchResultInfo.requiredItemLevel);
				local myItemLevel = GetAverageItemLevel();
				if myItemLevel>=searchResultInfo.requiredItemLevel then
					hangL.ilv:SetTextColor(0,1,0,1);
				else
					hangL.ilv:SetTextColor(1,0,0,1);
				end
				hangL.commentF.t:SetText(searchResultInfo.comment)
				hangL:mudidi_UpdataData(searchResultInfo,ActivityInfo.categoryID)
				hangL:Chengke_UpdataData(searchResultInfo,ActivityInfo.categoryID)
				hangL:caozuo_Updata()
			end
		end
	end
	TabF:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");--搜索结束
	TabF:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED");--条目已经更新
	TabF:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED");--申请后事件结果
	TabF:HookScript("OnEvent", function(self,event,...)
		local searchResultID, newStatus, oldStatus, groupName=...
		if self:IsShown() then
			if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
				self.Hang_Gengxin()
			end
			if event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
				self.Hang_Gengxin_H(searchResultID)
			end
			if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
				self.Hang_Gengxin_H(searchResultID)
			end
		end	
	end);

	---我的车队
	local FCTabF,FCTabBut=PIGOptionsList_R(fujiF.F,"我的车队",80)
	--显示/申请界面
	FCTabF.DQ=PIGFrame(FCTabF,{"TOPLEFT",FCTabF,"TOPLEFT",0,0})
	FCTabF.DQ:SetPoint("BOTTOMRIGHT",FCTabF,"BOTTOMRIGHT",0,0);
	FCTabF.DQ.Width=200
	FCTabF.DQ:Hide()
	--当前活动
	FCTabF.DQ.Category_T=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ,"TOPLEFT",10,-10},"车队类型")
	FCTabF.DQ.Category_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.Category_V=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Category_T,"BOTTOMLEFT",0,-2},"")
	FCTabF.DQ.Category_V:SetTextColor(0.9,0.9,0.9,1);

	FCTabF.DQ.Name_T=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Category_T,"BOTTOMLEFT",0,-24},"目的地")
	FCTabF.DQ.Name_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.Name_V=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Name_T,"BOTTOMLEFT",0,-2},"")
	FCTabF.DQ.Name_V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.Name_V:SetWidth(FCTabF.DQ.Width-8);
	FCTabF.DQ.Name_V:SetJustifyH("LEFT")

	FCTabF.DQ.ItemLevel_T=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Name_T,"BOTTOMLEFT",0,-34},LFG_LIST_ITEM_LEVEL_REQ)
	FCTabF.DQ.ItemLevel_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.ItemLevel_V=PIGFontString(FCTabF.DQ,{"LEFT",FCTabF.DQ.ItemLevel_T,"RIGHT",4,0},0)
	FCTabF.DQ.ItemLevel_V:SetTextColor(0.9,0.9,0.9,1);

	FCTabF.DQ.EntryName = PIGFrame(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.ItemLevel_T,"BOTTOMLEFT",0,-10})
	FCTabF.DQ.EntryName:SetSize(FCTabF.DQ.Width-24,54)
	FCTabF.DQ.EntryName.T=PIGFontString(FCTabF.DQ.EntryName,{"TOPLEFT",FCTabF.DQ.EntryName,"TOPLEFT",0,0},"标题")
	FCTabF.DQ.EntryName.T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.EntryName.V=PIGFontString(FCTabF.DQ.EntryName,{"TOPLEFT",FCTabF.DQ.EntryName.T,"BOTTOMLEFT",0,0})
	FCTabF.DQ.EntryName.V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.EntryName.V:SetWidth(FCTabF.DQ.EntryName:GetWidth())
	FCTabF.DQ.EntryName.V:SetJustifyH("LEFT")
	FCTabF.DQ.EntryName.V:SetNonSpaceWrap(true)

	FCTabF.DQ.Description_T=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.EntryName,"BOTTOMLEFT",0,-4},LFG_LIST_DETAILS)
	FCTabF.DQ.Description_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.DescriptionScroll = CreateFrame("ScrollFrame",nil,FCTabF.DQ, "UIPanelScrollFrameTemplate"); 
	FCTabF.DQ.DescriptionScroll:SetPoint("TOPLEFT",FCTabF.DQ.Description_T,"BOTTOMLEFT",0,-2);
	FCTabF.DQ.DescriptionScroll:SetSize(FCTabF.DQ.Width-28,156)
	FCTabF.DQ.DescriptionScroll.ScrollBar:SetScale(0.7);
	FCTabF.DQ.Description = PIGFrame(FCTabF.DQ.DescriptionScroll,nil,{FCTabF.DQ.DescriptionScroll:GetWidth()+4,20})
	FCTabF.DQ.Description.V=PIGFontString(FCTabF.DQ.Description,{"TOPLEFT",FCTabF.DQ.Description,"TOPLEFT",0,0})
	FCTabF.DQ.Description.V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.Description.V:SetWidth(FCTabF.DQ.Description:GetWidth())
	FCTabF.DQ.Description.V:SetJustifyH("LEFT")
	FCTabF.DQ.Description.V:SetNonSpaceWrap(true)
	FCTabF.DQ.DescriptionScroll:SetScrollChild(FCTabF.DQ.Description)

	local _, localizedFaction = UnitFactionGroup("player");
	FCTabF.DQ.CrossFactionGroup=PIGFrame(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,72},{200,20})
	FCTabF.DQ.CrossFactionGroup.CheckButton = PIGCheckbutton(FCTabF.DQ.CrossFactionGroup,{"LEFT",FCTabF.DQ.CrossFactionGroup,"LEFT",0,0},{LFG_LIST_CROSS_FACTION:format(localizedFaction),LFG_LIST_CROSS_FACTION_TOOLTIP:format(localizedFaction)},{16,16})
	FCTabF.DQ.CrossFactionGroup.CheckButton:Hide()
	FCTabF.DQ.PrivateGroup=PIGFrame(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,50},{200,20})
	FCTabF.DQ.PrivateGroup.CheckButton = PIGCheckbutton(FCTabF.DQ.PrivateGroup,{"LEFT",FCTabF.DQ.PrivateGroup,"LEFT",0,0},{"仅对公会/好友可见",LFG_LIST_PRIVATE_TOOLTIP},{16,16})
	FCTabF.DQ.PrivateGroup.CheckButton:Disable()

	FCTabF.DQ.EditButton=PIGButton(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,18},{80,22},EDIT.."车队")
	FCTabF.DQ.EditButton:HookScript("OnClick", function (self)
		FCTabF.ADD:SetEditMode(true)
	end);

	FCTabF.DQ.RemoveEntryButton=PIGButton(FCTabF.DQ,{"LEFT",FCTabF.DQ.EditButton,"RIGHT",20,0},{80,22},PET_DISMISS.."车队")
	FCTabF.DQ.RemoveEntryButton:HookScript("OnClick", function (self)
		FCTabF.ADD:PIG_Clear()
		C_LFGList.RemoveListing()
	end);
	--申请界面
	FCTabF.DQ.Apply=PIGFrame(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ,"TOPLEFT",FCTabF.DQ.Width,-34})
	FCTabF.DQ.Apply:SetPoint("BOTTOMRIGHT",FCTabF.DQ,"BOTTOMRIGHT",-18,2);
	FCTabF.DQ.Apply:PIGSetBackdrop(0)
	FCTabF.DQ.Apply.LFM_TITLE=PIGFontString(FCTabF.DQ.Apply,{"BOTTOMLEFT",FCTabF.DQ.Apply,"TOPLEFT",10,6},"正在"..LFM_TITLE)
	FCTabF.DQ.Apply.LFM_TITLE:SetTextColor(0,1,0,1);
	FCTabF.DQ.Apply.RefreshButton = PIGButton(FCTabF.DQ.Apply,{"BOTTOMRIGHT",FCTabF.DQ.Apply,"TOPRIGHT",-180,4},{60,22},LFG_LIST_REFRESH)
	FCTabF.DQ.Apply.RefreshButton:HookScript("OnClick", function (self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		C_LFGList.RefreshApplicants();
	end);
	FCTabF.DQ.Apply.AutoAcceptButton = PIGCheckbutton(FCTabF.DQ.Apply,{"BOTTOMRIGHT",FCTabF.DQ.Apply,"TOPRIGHT",-80,6},{LFG_LIST_AUTO_ACCEPT,nil},{16,16})
	FCTabF.DQ.Apply.AutoAcceptButton:HookScript("OnClick", function (self)
		if ( self:GetChecked() ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
		LFGListUtil_SetAutoAccept(self:GetChecked());
	end);
	FCTabF.DQ.Apply.AutoAcceptButton:Disable()

	FCTabF.DQ.Apply.UnempoweredCover=PIGFrame(FCTabF.DQ.Apply,{"TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",0,0})
	FCTabF.DQ.Apply.UnempoweredCover:SetPoint("BOTTOMRIGHT",FCTabF.DQ.Apply,"BOTTOMRIGHT",0,0);
	FCTabF.DQ.Apply.UnempoweredCover:PIGSetBackdrop(1)
	FCTabF.DQ.Apply.UnempoweredCover:Hide()
	FCTabF.DQ.Apply.UnempoweredCover.err = PIGFontString(FCTabF.DQ.Apply.UnempoweredCover,{"CENTER", FCTabF.DQ.Apply.UnempoweredCover, "CENTER",0, 40});
	FCTabF.DQ.Apply.UnempoweredCover.err:SetText(LFG_LIST_GROUP_FORMING);
	
	--五人本人员显示模式
	FCTabF.DQ.Apply.RoleEnumerate = CreateFrame("Frame", nil, FCTabF.DQ.Apply);
	FCTabF.DQ.Apply.RoleEnumerate:SetSize(120,hang_Height);
	FCTabF.DQ.Apply.RoleEnumerate:SetPoint("LEFT", FCTabF.DQ.Apply.LFM_TITLE, "RIGHT", 2, 1);
	FCTabF.DQ.Apply.RoleEnumerate.Higt = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"HIGHLIGHT");
	FCTabF.DQ.Apply.RoleEnumerate.Higt:SetTexture("interface/buttons/ui-common-mousehilight.blp");
	FCTabF.DQ.Apply.RoleEnumerate.Higt:SetAllPoints(FCTabF.DQ.Apply.RoleEnumerate)
	FCTabF.DQ.Apply.RoleEnumerate.Higt:SetBlendMode("ADD")
	FCTabF.DQ.Apply.RoleEnumerate.Higt:SetAlpha(0.4)
	FCTabF.DQ.Apply.RoleEnumerate.T = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil, "BORDER");
	FCTabF.DQ.Apply.RoleEnumerate.T:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleEnumerate.T:SetPoint("LEFT", FCTabF.DQ.Apply.RoleEnumerate, "LEFT", 2,-1);
	FCTabF.DQ.Apply.RoleEnumerate.T:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"ARTWORK");
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[1]));
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao:SetSize(hang_Height-10,hang_Height-10);
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.RoleEnumerate.T, "TOPRIGHT", -10,-10);
	FCTabF.DQ.Apply.RoleEnumerate.Tjiao:SetAlpha(0.7);

	FCTabF.DQ.Apply.RoleEnumerate.H = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil, "BORDER");
	FCTabF.DQ.Apply.RoleEnumerate.H:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleEnumerate.H:SetPoint("LEFT", FCTabF.DQ.Apply.RoleEnumerate.T, "RIGHT", 2,0);
	FCTabF.DQ.Apply.RoleEnumerate.H:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"ARTWORK");
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[2]));
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao:SetSize(hang_Height-10,hang_Height-10);
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.RoleEnumerate.H, "TOPRIGHT", -10,-10);
	FCTabF.DQ.Apply.RoleEnumerate.Hjiao:SetAlpha(0.7);

	FCTabF.DQ.Apply.RoleEnumerate.D = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil, "BORDER");
	FCTabF.DQ.Apply.RoleEnumerate.D:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleEnumerate.D:SetPoint("LEFT", FCTabF.DQ.Apply.RoleEnumerate.H, "RIGHT", 2,0);
	FCTabF.DQ.Apply.RoleEnumerate.D:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleEnumerate.Djiao = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"ARTWORK");
	FCTabF.DQ.Apply.RoleEnumerate.Djiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
	FCTabF.DQ.Apply.RoleEnumerate.Djiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
	FCTabF.DQ.Apply.RoleEnumerate.Djiao:SetSize(hang_Height-10,hang_Height-10);
	FCTabF.DQ.Apply.RoleEnumerate.Djiao:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.RoleEnumerate.D, "TOPRIGHT", -10,-10);
	FCTabF.DQ.Apply.RoleEnumerate.Djiao:SetAlpha(0.7);
	FCTabF.DQ.Apply.RoleEnumerate.D1 = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil, "BORDER");
	FCTabF.DQ.Apply.RoleEnumerate.D1:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleEnumerate.D1:SetPoint("LEFT", FCTabF.DQ.Apply.RoleEnumerate.D, "RIGHT", 2,0);
	FCTabF.DQ.Apply.RoleEnumerate.D1:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"ARTWORK");
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao:SetSize(hang_Height-10,hang_Height-10);
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.RoleEnumerate.D1, "TOPRIGHT", -10,-10);
	FCTabF.DQ.Apply.RoleEnumerate.D1jiao:SetAlpha(0.7);
	FCTabF.DQ.Apply.RoleEnumerate.D2 = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil, "BORDER");
	FCTabF.DQ.Apply.RoleEnumerate.D2:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleEnumerate.D2:SetPoint("LEFT", FCTabF.DQ.Apply.RoleEnumerate.D1, "RIGHT", 2,0);
	FCTabF.DQ.Apply.RoleEnumerate.D2:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao = FCTabF.DQ.Apply.RoleEnumerate:CreateTexture(nil,"ARTWORK");
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao:SetTexture("interface/lfgframe/ui-lfg-icon-portraitroles.blp");
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao:SetTexCoord(GetTexCoordsForRoleSmallCircle(zhizename[3]));
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao:SetSize(hang_Height-10,hang_Height-10);
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.RoleEnumerate.D2, "TOPRIGHT", -10,-10);
	FCTabF.DQ.Apply.RoleEnumerate.D2jiao:SetAlpha(0.7);
	FCTabF.DQ.Apply.RoleEnumerate:HookScript("OnEnter", function (self)
		fujiF.F.EnterF:ShowTishi(self,true)
	end);
	FCTabF.DQ.Apply.RoleEnumerate:HookScript("OnLeave", function (self)
		fujiF.F.EnterF:Hide()
	end);
	--其他人员显示模式
	FCTabF.DQ.Apply.RoleCount = CreateFrame("Frame", nil, FCTabF.DQ.Apply);
	FCTabF.DQ.Apply.RoleCount:SetSize(120,hang_Height);
	FCTabF.DQ.Apply.RoleCount:SetPoint("LEFT", FCTabF.DQ.Apply.LFM_TITLE, "RIGHT", 2, 1);
	FCTabF.DQ.Apply.RoleCount.Higt = FCTabF.DQ.Apply.RoleCount:CreateTexture(nil,"HIGHLIGHT");
	FCTabF.DQ.Apply.RoleCount.Higt:SetTexture("interface/buttons/ui-common-mousehilight.blp");
	FCTabF.DQ.Apply.RoleCount.Higt:SetAllPoints(FCTabF.DQ.Apply.RoleCount)
	FCTabF.DQ.Apply.RoleCount.Higt:SetBlendMode("ADD")
	FCTabF.DQ.Apply.RoleCount.Higt:SetAlpha(0.4)
	FCTabF.DQ.Apply.RoleCount.T = FCTabF.DQ.Apply.RoleCount:CreateTexture();
	FCTabF.DQ.Apply.RoleCount.T:SetAtlas(GetIconForRole(zhizename[1], false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.DQ.Apply.RoleCount.T:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleCount.T:SetPoint("LEFT", FCTabF.DQ.Apply.RoleCount, "LEFT", 19,0);
	FCTabF.DQ.Apply.RoleCount.T:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleCount.TNum = PIGFontString(FCTabF.DQ.Apply.RoleCount,{"RIGHT", FCTabF.DQ.Apply.RoleCount.T, "LEFT", 2,0},0,"OUTLINE");
	FCTabF.DQ.Apply.RoleCount.TNum:SetTextColor(1, 1, 1, 1);
	FCTabF.DQ.Apply.RoleCount.H = FCTabF.DQ.Apply.RoleCount:CreateTexture();
	FCTabF.DQ.Apply.RoleCount.H:SetAtlas(GetIconForRole(zhizename[2], false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.DQ.Apply.RoleCount.H:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleCount.H:SetPoint("LEFT", FCTabF.DQ.Apply.RoleCount.T, "RIGHT", 19,0);
	FCTabF.DQ.Apply.RoleCount.H:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleCount.HNum = PIGFontString(FCTabF.DQ.Apply.RoleCount,{"RIGHT", FCTabF.DQ.Apply.RoleCount.H, "LEFT", 2,0},0,"OUTLINE");
	FCTabF.DQ.Apply.RoleCount.HNum:SetTextColor(1, 1, 1, 1);
	FCTabF.DQ.Apply.RoleCount.D = FCTabF.DQ.Apply.RoleCount:CreateTexture();
	FCTabF.DQ.Apply.RoleCount.D:SetAtlas(GetIconForRole(zhizename[3], false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.DQ.Apply.RoleCount.D:SetSize(hang_Height-4,hang_Height-4);
	FCTabF.DQ.Apply.RoleCount.D:SetPoint("LEFT", FCTabF.DQ.Apply.RoleCount.H, "RIGHT", 19,0);
	FCTabF.DQ.Apply.RoleCount.D:SetAlpha(0.9);
	FCTabF.DQ.Apply.RoleCount.DNum = PIGFontString(FCTabF.DQ.Apply.RoleCount,{"RIGHT", FCTabF.DQ.Apply.RoleCount.D, "LEFT", 2,0},0,"OUTLINE");
	FCTabF.DQ.Apply.RoleCount.DNum:SetTextColor(1, 1, 1, 1);
	FCTabF.DQ.Apply.RoleCount:HookScript("OnEnter", function (self)
		fujiF.F.EnterF:ShowTishi(self,true)
	end);
	FCTabF.DQ.Apply.RoleCount:HookScript("OnLeave", function (self)
		fujiF.F.EnterF:Hide()
	end);
	function FCTabF.DQ.Apply:Update_Players()
		if not self:IsVisible() then return end
		if ( UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) ) then
			self:GetParent().RemoveEntryButton:Show();
			self:GetParent().EditButton:Show();
		else
			self:GetParent().RemoveEntryButton:Hide();
			self:GetParent().EditButton:Hide();
		end
		if ( IsRestrictedAccount() ) then
			self:GetParent().EditButton:Disable();
		else
			self:GetParent().EditButton:Enable();
		end
		local empowered = LFGListUtil_IsEntryEmpowered();
		self.UnempoweredCover:SetShown(not empowered);
		self.RoleEnumerate:Hide()
		self.RoleCount:Hide()
		if not C_LFGList.HasActiveEntryInfo() then return end
		local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
		local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID);
		local dixiacinfo = {}
		for ix=1,#zhizename do
			dixiacinfo[zhizename[ix]]={}
		end	
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers>0 then
			for p=1,MAX_RAID_MEMBERS do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(p);
				if name then
					if not combatRole then
						SetLFGRoles(false, false, false, true);
					end
					table.insert(dixiacinfo[combatRole],fileName)
				end
			end
		end
		if activityInfo.displayType == Enum.LFGListDisplayType.RoleEnumerate then
			self.RoleEnumerate:Show()
			self.RoleEnumerate.T:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
			self.RoleEnumerate.T:SetTexCoord(0.1,0.9,0.1,0.9);
			self.RoleEnumerate.H:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
			self.RoleEnumerate.H:SetTexCoord(0.1,0.9,0.1,0.9);
			self.RoleEnumerate.D:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
			self.RoleEnumerate.D:SetTexCoord(0.1,0.9,0.1,0.9);
			self.RoleEnumerate.D1:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
			self.RoleEnumerate.D1:SetTexCoord(0.1,0.9,0.1,0.9);
			self.RoleEnumerate.D2:SetTexture("interface/spellbook/ui-glyphframe-locked.blp");
			self.RoleEnumerate.D2:SetTexCoord(0.1,0.9,0.1,0.9);
			if #dixiacinfo[zhizename[1]]>0 then
				self.RoleEnumerate.T:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
				self.RoleEnumerate.T:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[1]][1]]));
			end
			if #dixiacinfo[zhizename[2]]>0 then
				self.RoleEnumerate.H:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
				self.RoleEnumerate.H:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[2]][1]]));
			end
			if #dixiacinfo[zhizename[3]]>0 then
				self.RoleEnumerate.D:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
				self.RoleEnumerate.D:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][1]]));
				if dixiacinfo[zhizename[3]][2] then
					self.RoleEnumerate.D1:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
					self.RoleEnumerate.D1:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][2]]));
				end
				if dixiacinfo[zhizename[3]][3] then
					self.RoleEnumerate.D2:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
					self.RoleEnumerate.D2:SetTexCoord(unpack(CLASS_ICON_TCOORDS[dixiacinfo[zhizename[3]][3]]));
				end
			end
		else
			self.RoleCount:Show()		
			self.RoleCount.TNum:SetText(#dixiacinfo[zhizename[1]]);
			self.RoleCount.HNum:SetText(#dixiacinfo[zhizename[2]]);
			self.RoleCount.DNum:SetText(#dixiacinfo[zhizename[3]]);
		end
	end
	--申请人
	local AppbiaotiName={{"申请人(|cffFF80FF点击"..L["CHAT_WHISPER"].."|r)",6},{"天赋",164},{"装等",272},{"申请留言",324},{"操作",584}}
	for i=1,#AppbiaotiName do
		local biaoti=PIGFontString(FCTabF.DQ.Apply,{"TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",AppbiaotiName[i][2],-5},AppbiaotiName[i][1])
		biaoti:SetTextColor(1,1,0, 0.9);
	end
	FCTabF.DQ.Apply.line = PIGLine(FCTabF.DQ.Apply,"TOP",-24,nil,nil,{0.2,0.2,0.2,0.5})
	local Apphang_Height,Apphang_NUM=25,15
	local Apphang_Width = FCTabF.DQ.Apply:GetWidth();
	C_PartyInfo=C_PartyInfo or {}
	C_PartyInfo.ConfirmConvertToRaid=C_PartyInfo.ConfirmConvertToRaid or ConvertToRaid	
	--格式化行
	PIGApplistbutMixin = {}
	local greenTexture = "interface/common/indicator-green.blp"
	local xuanzhongBG = {{0.2, 0.2, 0.2, 0.2},{0.4, 0.8, 0.8, 0.2}}
	local function GetButtonHeight(numApplicants)
		return Apphang_Height * numApplicants + 6;
	end
	local function add_MemberList(self,add)
		local F = PIGFrame(self,nil,{100,Apphang_Height});
		if add then
			F:SetPoint("TOPLEFT", self.Members[(#self.Members)], "BOTTOMLEFT",0, 0);
		else
			F:SetPoint("TOPLEFT", self, "TOPLEFT",0, -3);
		end
		F:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		F:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		F.Role = F:CreateTexture();
		F.Role:SetSize(Apphang_Height-4,Apphang_Height-4);
		F.Role:SetPoint("LEFT", F, "LEFT", 2,0);
		F.Role:SetAlpha(0.9);
		F.Classe = F:CreateTexture();
		F.Classe:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
		F.Classe:SetSize(Apphang_Height-6,Apphang_Height-6);
		F.Classe:SetPoint("LEFT", F.Role, "RIGHT", 0,0);
		F.Classe:SetAlpha(0.9);
		F.nameF = PIGFrame(F,{"LEFT", F.Classe, "RIGHT",1, 0},{120,Apphang_Height-4});
		F.nameF:HookScript("OnEnter", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		F.nameF:HookScript("OnLeave", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		F.nameF.name = PIGFontString(F.nameF);
		F.nameF.name:SetAllPoints(F.nameF)
		F.nameF.name:SetJustifyH("LEFT");
		F.nameF:SetScript("OnMouseUp", function(self,button)
			local wjName = self:GetParent().allname
			local editBox = ChatEdit_ChooseBoxForSend();
			local hasText = editBox:GetText()
			if editBox:HasFocus() then
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			else
				ChatEdit_ActivateChat(editBox)
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			end
		end)
		F.tianfuF = PIGFrame(F,{"LEFT", F, "LEFT",AppbiaotiName[2][2]-4, 0},{100,Apphang_Height});
		F.tianfuF:HookScript("OnEnter", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
			if self.tftisp1 then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				local tishineirrr = "|T"..greenTexture..":13:13|t|T"..self.tftisp1[2]..":0|t"..self.tftisp1[1].." |cffFFFFFF"..self.tftisp1[3].."|r"
				if self.tftisp2 then
					tishineirrr =tishineirrr.."\n    |T"..self.tftisp2[2]..":0|t"..self.tftisp2[1].." |cffFFFFFF"..self.tftisp2[3].."|r"
				end
				GameTooltip:AddLine(tishineirrr)
				GameTooltip:Show();
			end
		end);
		F.tianfuF:HookScript("OnLeave", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
			GameTooltip:ClearLines();
			GameTooltip:Hide();
		end);
		F.tianfuF.zhutex = F.tianfuF:CreateTexture();
		F.tianfuF.zhutex:SetSize(Apphang_Height-6,Apphang_Height-6);
		F.tianfuF.zhutex:SetPoint("LEFT",F.tianfuF, "LEFT",0, 0);
		F.tianfuF.zhutex:SetAlpha(0.9);
		F.tianfuF.zhu = PIGFontString(F.tianfuF,{"LEFT",F.tianfuF.zhutex, "RIGHT",0, 0});
		F.tianfuF.zhu:SetJustifyH("LEFT");
		F.tianfuF.futex = F.tianfuF:CreateTexture();
		F.tianfuF.futex:SetSize(Apphang_Height-6,Apphang_Height-6);
		F.tianfuF.futex:SetPoint("LEFT",F.tianfuF.zhu, "RIGHT",2, 0);
		F.tianfuF.futex:SetAlpha(0.9);
		F.tianfuF.fu = PIGFontString(F.tianfuF,{"LEFT",F.tianfuF.futex, "RIGHT",0, 0});
		F.tianfuF.fu:SetJustifyH("LEFT");

		F.item = CreateFrame("Button",nil,F, "TruncatedButtonTemplate");
		F.item:SetPoint("LEFT", F, "LEFT",AppbiaotiName[3][2]-2, 0);
		F.item:SetSize(Apphang_Height-6,Apphang_Height-6);
		F.item:SetNormalTexture(133122);
		F.item:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		F.item:HookScript("OnMouseDown", function(self,button)
			self:SetPoint("LEFT", self:GetParent(), "LEFT",AppbiaotiName[3][2]-0.5, -1.5);
		end); 
		F.item:HookScript("OnMouseUp", function(self,button)
			self:SetPoint("LEFT", self:GetParent(), "LEFT",AppbiaotiName[3][2]-2, 0);
		end); 
		F.item:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		F.item:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		F.item:HookScript("OnClick", function(self,button)
			FasongYCqingqiu(self:GetParent().allname)
		end); 
		F.iLvl = PIGFontString(F,{"LEFT", F.item, "RIGHT",1, 0});
		F.iLvl:SetTextColor(0,0.98,0.6, 1);
		return F
	end
	function PIGApplistbutMixin:OnLoad()
		self.Members={}
		self:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		self:SetBackdropColor(unpack(xuanzhongBG[1]));
		self:HookScript("OnEnter", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		self:HookScript("OnLeave", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		self.Members[1] = add_MemberList(self)
		self.caozuoF=PIGFrame(self,{"RIGHT", self, "RIGHT",0, 0},{70,Apphang_Height})
		self.caozuoF:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		self.caozuoF:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		self.caozuoF.Status= PIGFontString(self.caozuoF,{"LEFT", self.caozuoF, "LEFT",0, 0},"已取消",nil,13);
		self.caozuoF.InviteButton = PIGButton(self.caozuoF,{"LEFT", self.caozuoF, "LEFT",0, 0},{44,Apphang_Height-6},INVITE)
		PIGSetFont(self.caozuoF.InviteButton.Text,12)
		self.caozuoF.InviteButton:HookScript("OnEnter", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		self.caozuoF.InviteButton:HookScript("OnLeave", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		self.caozuoF.InviteButton:HookScript("OnClick", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			if ( not IsInRaid(LE_PARTY_CATEGORY_HOME) and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + self:GetParent().numMembers + C_LFGList.GetNumInvitedApplicantMembers() > MAX_PARTY_MEMBERS + 1 ) then
				local dialog = StaticPopup_Show("LFG_LIST_INVITING_CONVERT_TO_RAID");
				if ( dialog ) then
					dialog.data = self:GetParent():GetParent().applicantID;
				end
			else
				C_LFGList.InviteApplicant(self:GetParent():GetParent().applicantID);
			end
		end)
		self.caozuoF.DeclineButton = PIGCloseBut(self.caozuoF, {"LEFT", self.caozuoF.InviteButton, "RIGHT", 4, 0})
		self.caozuoF.DeclineButton:HookScript("OnEnter", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		self.caozuoF.DeclineButton:HookScript("OnLeave", function (self)
			self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		self.caozuoF.DeclineButton:HookScript("OnClick", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			if ( self.isAck ) then
				C_LFGList.RemoveApplicant(self:GetParent():GetParent().applicantID);
			else
				C_LFGList.DeclineApplicant(self:GetParent():GetParent().applicantID);
			end
		end)

		self.jieshaoF=PIGFrame(self,{"LEFT", self, "LEFT",AppbiaotiName[4][2]-1, 0})
		self.jieshaoF:SetPoint("RIGHT", self.caozuoF, "LEFT", -6,0);
		self.jieshaoF:SetHeight(Apphang_Height-4);
		self.jieshaoF.t = PIGFontString(self.jieshaoF,{"LEFT", self.jieshaoF, "LEFT",0, 0});
		self.jieshaoF.t:SetTextColor(0.9,0.9,0.9, 1);
		self.jieshaoF.t:SetAllPoints(self.jieshaoF)
		self.jieshaoF.t:SetJustifyH("LEFT");
		self.jieshaoF:SetScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
			if self.t:IsTruncated() then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				GameTooltip:AddLine(AppbiaotiName[4][1],1,1,0, 0.9)
				GameTooltip:AddLine(self.t:GetText(), 0.9,0.9,0.9, true)
				GameTooltipTextLeft2:SetNonSpaceWrap(true)
				GameTooltip:Show();
			end
		end);
		self.jieshaoF:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
	end
	local function tiquIconName(tfdd_x)
		local maxD = {0,0}
		local tfjiheji = {strsplit("-", tfdd_x)};
		for ic=1,#tfjiheji do
			local xxuel = tonumber(tfjiheji[ic])
			if xxuel>maxD[2] then
				maxD[1]=ic
				maxD[2]=xxuel
			end
		end
		return maxD[1]
	end
	local function Show_JJtianfu(uix,zhiye,nameX)
		if uix.name~=nameX then return end
		uix.zhu:SetTextColor(0.6,0.6,0.6);
		uix.fu:SetTextColor(0.6,0.6,0.6);
		uix.fu:SetText(UNKNOWN);
		uix.zhu:SetText(UNKNOWN);
		uix.fu:SetText(UNKNOWN);
		uix.zhutex:SetDesaturated(true)
		uix.futex:SetDesaturated(true)
		uix.zhutex:SetTexture("interface/icons/ability_marksmanship.blp");
		uix.futex:SetTexture("interface/icons/ability_marksmanship.blp");
		uix.tftisp1=nil
		uix.tftisp2=nil	
		if zhiye and nameX then
			local tfdd_1, tfdd_2=GetTianfuIcon_YC(zhiye,nameX)
			if tfdd_1[1]~="--" then
				uix.tftisp1=tfdd_1
				uix.zhu:SetTextColor(1,1,0);
				uix.zhutex:SetDesaturated(false)		
				uix.zhu:SetText(tfdd_1[1]);
				uix.zhutex:SetTexture(tfdd_1[2]);
			end
			if tfdd_2[1]~="--" then
				uix.tftisp2=tfdd_2
				uix.fu:SetTextColor(1,1,0);
				uix.futex:SetDesaturated(false)
				uix.fu:SetText(tfdd_2[1]);
				uix.futex:SetTexture(tfdd_2[2]);
			end
		end
	end
	local function UpdateApplicantMember(member, appID, memberIdx, applicantInfo)
		local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel = C_LFGList.GetApplicantMemberInfo(appID, memberIdx);
		member.Role:SetAtlas(GetIconForRole(assignedRole, false), TextureKitConstants.IgnoreAtlasSize);
		member.Classe:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
		member.nameF.name:SetText(name.."("..level..")");
		member.allname=name
		local rPerc, gPerc, bPerc, argbHex = GetClassColor(class);
		member.nameF.name:SetTextColor(rPerc, gPerc, bPerc);
		member.iLvl:SetText(floor(itemLevel));
		member.tianfuF.name=name
		if applicantInfo.applicationStatus=="applied" then
			FasongYCqingqiu(name,2)
			Show_JJtianfu(member.tianfuF,class,name)
			C_Timer.After(0.5,function()
				Show_JJtianfu(member.tianfuF,class,name)
			end)
			C_Timer.After(1,function()
				Show_JJtianfu(member.tianfuF,class,name)
			end)
			C_Timer.After(2,function()
				Show_JJtianfu(member.tianfuF,class,name)
			end)
		end
	end
	local function UpdateApplicant(button, id)
		local applicantInfo = C_LFGList.GetApplicantInfo(id);
		button:SetHeight(GetButtonHeight(applicantInfo.numMembers));
		--更新申请组内单个玩家
		for iG=1, applicantInfo.numMembers do
			local member = button.Members[iG];
			if ( not member ) then
				member=add_MemberList(button,true)
				button.Members[iG] = member;
			end
			UpdateApplicantMember(member, id, iG, applicantInfo);
			member:Show();
		end
		--隐藏空白按钮
		for iG=applicantInfo.numMembers+1, #button.Members do
			button.Members[iG]:Hide();
		end
		button.jieshaoF:SetHeight(GetButtonHeight(applicantInfo.numMembers)-6);
		button.jieshaoF.t:SetText(applicantInfo.comment);
		-- 更新邀请和拒绝按
		button.caozuoF.DeclineButton:SetHeight(GetButtonHeight(applicantInfo.numMembers)-10);
		button.caozuoF.InviteButton:SetHeight(GetButtonHeight(applicantInfo.numMembers)-10);

		if ( applicantInfo.applicantInfo or applicantInfo.applicationStatus == "applied" ) then
			button.caozuoF.Status:Hide();
		elseif ( applicantInfo.applicationStatus == "invited" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_INVITED);
			button.caozuoF.Status:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "failed" or applicantInfo.applicationStatus == "cancelled" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_CANCELLED);
			button.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "declined" or applicantInfo.applicationStatus == "declined_full" or applicantInfo.applicationStatus == "declined_delisted" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_DECLINED);
			button.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "timedout" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_TIMED_OUT);
			button.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "inviteaccepted" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_INVITE_ACCEPTED);
			button.caozuoF.Status:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "invitedeclined" ) then
			button.caozuoF.Status:Show();
			button.caozuoF.Status:SetText(LFG_LIST_APP_INVITE_DECLINED);
			button.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
		button.caozuoF.numMembers = applicantInfo.numMembers;
		local useSmallInviteButton = LFGApplicationViewerRatingColumnHeader:IsShown();
		button.caozuoF.Status:ClearAllPoints()
		button.caozuoF.InviteButton:SetShown(not useSmallInviteButton and not applicantInfo.applicantInfo and applicantInfo.applicationStatus == "applied" and LFGListUtil_IsEntryEmpowered());
		button.caozuoF.DeclineButton:SetShown(not applicantInfo.applicantInfo and applicantInfo.applicationStatus ~= "invited" and LFGListUtil_IsEntryEmpowered());
		button.caozuoF.DeclineButton.isAck = (applicantInfo.applicationStatus ~= "applied" and applicantInfo.applicationStatus ~= "invited");
		if(button.caozuoF.DeclineButton:IsShown()) then
			button.caozuoF.Status:SetPoint("RIGHT", button.caozuoF.DeclineButton, "LEFT", -14, 0);
		else
			button.caozuoF.Status:SetPoint("CENTER", button, "RIGHT", -37, 0);
		end
	end
	function PIGApplistbutMixin:Init(elementData)
		local button=self
		local id = elementData.id;
		local index = elementData.index;
		button.applicantID = id;
		UpdateApplicant(button, id);
	end

	FCTabF.DQ.Apply.applist = CreateFrame("Frame",nil,FCTabF.DQ.Apply); 
	FCTabF.DQ.Apply.applist:SetPoint("TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",0,-24);
	FCTabF.DQ.Apply.applist:SetPoint("BOTTOMRIGHT",FCTabF.DQ.Apply,"BOTTOMRIGHT",0,0);
	FCTabF.DQ.Apply.applist.ScrollBox = CreateFrame("Frame",nil,FCTabF.DQ.Apply.applist, "WowScrollBoxList");
	FCTabF.DQ.Apply.applist.ScrollBar = CreateFrame("EventFrame",nil,FCTabF.DQ.Apply.applist, "MinimalScrollBar");  
	FCTabF.DQ.Apply.applist.ScrollBar:SetPoint("TOPRIGHT",FCTabF.DQ.Apply.applist,"TOPRIGHT",13,0);
	FCTabF.DQ.Apply.applist.ScrollBar:SetPoint("BOTTOMRIGHT",FCTabF.DQ.Apply.applist,"BOTTOMRIGHT",13,0);
	function FCTabF.DQ.Apply.applist:initialize()
		FCTabF.DQ.Apply.applist.DataProvider = CreateDataProvider()
	    FCTabF.DQ.Apply.applist.ScrollView = CreateScrollBoxListLinearView()
	    FCTabF.DQ.Apply.applist.ScrollView:SetDataProvider(FCTabF.DQ.Apply.applist.DataProvider)
	    --FCTabF.DQ.Apply.applist.ScrollView:SetElementExtent(Apphang_Height)--行高度
	    FCTabF.DQ.Apply.applist.ScrollView:SetElementExtentCalculator(function(dataIndex, elementData)
			return GetButtonHeight(elementData.numMembers);
		end);
	    FCTabF.DQ.Apply.applist.ScrollView:SetElementInitializer("PIGApplistbutTemplate", function(frame, elementData)
	        frame:Init(elementData)
	    end)
	    local paddingT,paddingB,paddingL,paddingR,spacing = 0,0,0,0,1
	    FCTabF.DQ.Apply.applist.ScrollView:SetPadding(paddingT, paddingB, paddingL, paddingR, spacing)--行内边距/间距
	    --初始化滚动区域列表和滚动条
	    ScrollUtil.InitScrollBoxListWithScrollBar(FCTabF.DQ.Apply.applist.ScrollBox, FCTabF.DQ.Apply.applist.ScrollBar, FCTabF.DQ.Apply.applist.ScrollView)
	    --设置滚动条显示状态
	    local anchorsWithBar = {--有滚动没出现时的定位
	        CreateAnchor("TOPLEFT", FCTabF.DQ.Apply.applist, "TOPLEFT", 1, 0),
	        CreateAnchor("BOTTOMRIGHT", FCTabF.DQ.Apply.applist, "BOTTOMRIGHT", -1, 0),
	    }
	    local anchorsWithoutBar = {--没滚动没出现时的定位
	        CreateAnchor("TOPLEFT", FCTabF.DQ.Apply.applist, "TOPLEFT", 1, 0),
	        CreateAnchor("BOTTOMRIGHT", FCTabF.DQ.Apply.applist, "BOTTOMRIGHT", -1, 0),
	    } 
	    ScrollUtil.AddManagedScrollBarVisibilityBehavior(FCTabF.DQ.Apply.applist.ScrollBox, FCTabF.DQ.Apply.applist.ScrollBar, anchorsWithBar, anchorsWithoutBar)
	end
	FCTabF.DQ.Apply.applist:initialize()

	-- function FCTabF.DQ.Apply.applist:RemoveListItem()--删除单行
	--     local lastIndex = self.DataProvider:GetSize()
	--     print(lastIndex)
	--     for ix=lastIndex,1,-1 do
	--     	self.DataProvider:RemoveIndex(ix)
	--     end 
	-- end
	function FCTabF.DQ.Apply.Update_AppList(self)
		if not self:IsVisible() then return end
		self.applist.ScrollBox:RemoveDataProvider();--删除全部数据
		self.applicants = C_LFGList.GetApplicants();
		local applicantsNum = #self.applicants
		if applicantsNum>0 then
			LFGListUtil_SortApplicants(self.applicants);
			local dataProvider = CreateDataProvider();
			for index = 1, #self.applicants do
				local id = self.applicants[index];
				local info = C_LFGList.GetApplicantInfo(id);
				local numMembers = info.numMembers;
				dataProvider:Insert({index=index, id=id, numMembers=numMembers});
			end
			--self.applist.ScrollBox:ScrollToEnd(ScrollBoxConstants.NoScrollInterpolation)--设置默认显示最底部
			self.applist.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);--参数2设置是否保留滚动位置
    	end
	end

	--创建界面
	FCTabF.ADD=PIGFrame(FCTabF,{"TOPLEFT",FCTabF,"TOPLEFT",0,0})
	FCTabF.ADD:SetPoint("BOTTOMRIGHT",FCTabF,"BOTTOMRIGHT",0,0);
	FCTabF.ADD.Width=280
	FCTabF.ADD:Hide()
	FCTabF.ADD.Category_T=PIGFontString(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",20,-20},"选择要创建车队类型")
	C_Timer.After(0.6,function() Getfenleidata({TabF,10,-10},{FCTabF.ADD,20,-50}) end)
	FCTabF.ADD.GroupDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.Category_T,"TOPLEFT",0,-110},{FCTabF.ADD.Width,nil})
	FCTabF.ADD.GroupDropDown:Hide()
	FCTabF.ADD.GroupDropDown.t=PIGFontString(FCTabF.ADD.GroupDropDown,{"BOTTOMLEFT",FCTabF.ADD.GroupDropDown,"TOPLEFT",0,4},"目的地")
	function FCTabF.ADD.GroupDropDown:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local ActivityGroups = C_LFGList.GetAvailableActivityGroups(FCTabF.selectedCategory)
		for i=1,#ActivityGroups,1 do
			local groupID = ActivityGroups[i];
			local name = C_LFGList.GetActivityGroupInfo(groupID);
		    info.text, info.arg1, info.arg2 = name, groupID, "group";
		    info.checked = groupID == FCTabF.selectedGroup
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function FCTabF.ADD.GroupDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		FCTabF.selectedGroup=arg1
		local activities = C_LFGList.GetAvailableActivities(FCTabF.selectedCategory,FCTabF.selectedGroup)
		FCTabF.selectedActivity=activities[1] or 0
		FCTabF.ADD:SetEditMode()
		PIGCloseDropDownMenus()
	end
	--
	FCTabF.ADD.ActivityDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.GroupDropDown,"BOTTOMLEFT",0,-8},{FCTabF.ADD.Width,nil})
	FCTabF.ADD.ActivityDropDown:Hide()
	local function panduancunzaitongName(heji,name1)
		for i=1,#heji do
			if heji[i][1]==name1 then
				return false
			end
		end
		return true
	end
	function FCTabF.ADD.ActivityDropDown:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local Activities = C_LFGList.GetAvailableActivities(FCTabF.selectedCategory,FCTabF.selectedGroup)
		local newActivities = {}
		for i=1,#Activities,1 do
			local ActivityInfo= C_LFGList.GetActivityInfoTable(Activities[i])
			if FCTabF.selectedGroup==300 then
				if panduancunzaitongName(newActivities,ActivityInfo.fullName) then
					table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
				end
			else
				table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
			end
		end
		for i=1,#newActivities,1 do
		    info.text, info.arg1, info.arg2 = newActivities[i][1], newActivities[i][2], "activity";
		    info.checked = newActivities[i][2] == FCTabF.selectedActivity
			FCTabF.ADD.ActivityDropDown:PIGDownMenu_AddButton(info)
		end 
	end
	function FCTabF.ADD.ActivityDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		FCTabF.selectedActivity=arg1
		FCTabF.ADD:SetEditMode()
		PIGCloseDropDownMenus()
	end

	FCTabF.ADD.ItemLevel=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.ActivityDropDown,"BOTTOMLEFT",0,-40},{FCTabF.ADD.Width,24})
	FCTabF.ADD.ItemLevel:Hide()
	FCTabF.ADD.ItemLevel.CheckButton = PIGCheckbutton(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel,"LEFT",0,0},{LFG_LIST_ITEM_LEVEL_REQ,LFG_LIST_ITEM_LEVEL_REQ})
	FCTabF.ADD.ItemLevel.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.ItemLevel);
	FCTabF.ADD.ItemLevel.EditBox:SetPoint("LEFT", FCTabF.ADD.ItemLevel.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.ItemLevel.EditBox:SetPoint("RIGHT", FCTabF.ADD.ItemLevel, "RIGHT", -90,0);
	FCTabF.ADD.ItemLevel.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.ItemLevel.EditBox,14,"OUTLINE")
	FCTabF.ADD.ItemLevel.EditBox:SetMaxLetters(6)
	FCTabF.ADD.ItemLevel.EditBox:SetNumeric(true)
	FCTabF.ADD.ItemLevel.EditBox:SetAutoFocus(false)
	FCTabF.ADD.ItemLevel.EditBox.BG=PIGFrame(FCTabF.ADD.ItemLevel.EditBox,{"TOPLEFT", FCTabF.ADD.ItemLevel.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.ItemLevel.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.ItemLevel.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.ItemLevel.EditBox.BG:PIGSetBackdrop(0,0.6,nil,{0, 1, 1})
	FCTabF.ADD.ItemLevel.EditBox.BG:SetFrameLevel(FCTabF.ADD.ItemLevel.EditBox:GetFrameLevel()-1)
	FCTabF.ADD.ItemLevel.EditBox:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
	end);
	FCTabF.ADD.ItemLevel.EditBox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end);
	FCTabF.ADD.ItemLevel.EditBox:SetScript("OnTextChanged", function(self)
		FCTabF.ADD:ListGroupButton_Update(self)
	end);
	FCTabF.ADD.ItemLevel.maxlvt=PIGFontString(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel.EditBox,"RIGHT",10,0},"当前")
	FCTabF.ADD.ItemLevel.maxlv=PIGFontString(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel.maxlvt,"RIGHT",0,0})

	FCTabF.ADD.VoiceChat=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.ItemLevel,"BOTTOMLEFT",0,-10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.VoiceChat:Hide()
	FCTabF.ADD.VoiceChat.CheckButton = PIGCheckbutton(FCTabF.ADD.VoiceChat,{"LEFT",FCTabF.ADD.VoiceChat,"LEFT",0,0},{LFG_LIST_VOICE_CHAT,LFG_LIST_VOICE_CHAT_INSTR})
	FCTabF.ADD.VoiceChat.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.VoiceChat);
	FCTabF.ADD.VoiceChat.EditBox:SetPoint("LEFT", FCTabF.ADD.VoiceChat.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.VoiceChat.EditBox:SetPoint("RIGHT", FCTabF.ADD.VoiceChat, "RIGHT", -10,0);
	FCTabF.ADD.VoiceChat.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.VoiceChat.EditBox,14,"OUTLINE")
	FCTabF.ADD.VoiceChat.EditBox:SetAutoFocus(false)
	FCTabF.ADD.VoiceChat.EditBox.BG=PIGFrame(FCTabF.ADD.VoiceChat.EditBox,{"TOPLEFT", FCTabF.ADD.VoiceChat.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.VoiceChat.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.VoiceChat.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.VoiceChat.EditBox.BG:PIGSetBackdrop(0,0.6,nil,{0, 1, 1})
	FCTabF.ADD.VoiceChat.EditBox.BG:SetFrameLevel(FCTabF.ADD.VoiceChat.EditBox:GetFrameLevel()-1)
	---
	FCTabF.ADD.CrossFactionGroup=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.VoiceChat,"BOTTOMLEFT",0,-10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.CrossFactionGroup:Hide()
	local _, localizedFaction = UnitFactionGroup("player");
	FCTabF.ADD.CrossFactionGroup.CheckButton = PIGCheckbutton(FCTabF.ADD.CrossFactionGroup,{"LEFT",FCTabF.ADD.CrossFactionGroup,"LEFT",0,0},{LFG_LIST_CROSS_FACTION:format(localizedFaction),LFG_LIST_CROSS_FACTION_TOOLTIP:format(localizedFaction)})
	FCTabF.ADD.CrossFactionGroup.CheckButton:Disable()
	
	FCTabF.ADD.PrivateGroup=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.CrossFactionGroup,"BOTTOMLEFT",0,-10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.PrivateGroup:Hide()
	FCTabF.ADD.PrivateGroup.CheckButton = PIGCheckbutton(FCTabF.ADD.PrivateGroup,{"LEFT",FCTabF.ADD.PrivateGroup,"LEFT",0,0},{"仅对公会/好友可见",LFG_LIST_PRIVATE_TOOLTIP})

	FCTabF.ADD.Role=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.PrivateGroup,"BOTTOMLEFT",0,-18},{FCTabF.ADD.Width,42})
	FCTabF.ADD.Role:Hide()
	function FCTabF.ADD.Role_checkButton(self)
		local roleFf = self:GetParent()
		if ( self:GetChecked() ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
		local leader, tank, healer, dps = GetLFGRoles();
		local dialog = LFGListCreateRoleDialog
		if dialog.exclusive then
			local setDPS = false;
			local setTank = false;
			local setHealer = false;
			if roleFf:GetID() == 1 then
				setDPS = true;
			elseif roleFf:GetID() == 2 then
				setTank = true;
			elseif roleFf:GetID() == 3 then
				setHealer = true;
			end
			SetLFGRoles(leader, setTank, setHealer, setDPS);
			local _, tank, healer, dps = GetLFGRoles();
			local roleFff = roleFf:GetParent()
			roleFff.T.checkButton:SetChecked(tank);
			roleFff.H.checkButton:SetChecked(healer);
			roleFff.D.checkButton:SetChecked(dps);
			FCTabF.ADD:ListGroupButton_Update()
		end
	end
	FCTabF.ADD.Role.biao=PIGFontString(FCTabF.ADD.Role,{"LEFT",FCTabF.ADD.Role,"LEFT",0,0},"职\n责")
	FCTabF.ADD.Role.T = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",2);
	FCTabF.ADD.Role.T:SetPoint("LEFT",FCTabF.ADD.Role.biao,"RIGHT",10,0);
	FCTabF.ADD.Role.T:SetSize(40,40);
	FCTabF.ADD.Role.T.role="TANK";
	FCTabF.ADD.Role.T.roleID=2;
	FCTabF.ADD.Role.T:SetNormalAtlas(GetIconForRole(FCTabF.ADD.Role.T.role, false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.ADD.Role.T.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	FCTabF.ADD.Role.H = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",3);
	FCTabF.ADD.Role.H:SetPoint("LEFT",FCTabF.ADD.Role.T,"RIGHT",20,0);
	FCTabF.ADD.Role.H:SetSize(40,40);
	FCTabF.ADD.Role.H.role="HEALER";
	FCTabF.ADD.Role.H.roleID=3;
	FCTabF.ADD.Role.H.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	FCTabF.ADD.Role.H:SetNormalAtlas(GetIconForRole(FCTabF.ADD.Role.H.role, false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.ADD.Role.D = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",1);
	FCTabF.ADD.Role.D:SetPoint("LEFT",FCTabF.ADD.Role.H,"RIGHT",20,0);
	FCTabF.ADD.Role.D:SetSize(40,40);
	FCTabF.ADD.Role.D.role="DAMAGER";
	FCTabF.ADD.Role.D.roleID=1;
	FCTabF.ADD.Role.D:SetNormalAtlas(GetIconForRole(FCTabF.ADD.Role.D.role, false), TextureKitConstants.IgnoreAtlasSize);
	FCTabF.ADD.Role.D.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	FCTabF.ADD.Role:SetScript("OnShow", function(self)
		local availTank, availHealer, availDPS = C_LFGList.GetAvailableRoles();
		self.T:SetShown(availTank);
		self.H:SetShown(availHealer);
		self.D:SetShown(availDPS);
		local _, tank, healer, dps = GetLFGRoles();
		self.T.checkButton:SetChecked(tank);
		self.H.checkButton:SetChecked(healer);
		self.D.checkButton:SetChecked(dps);
	end)
	-- 未启用
	-- FCTabF.ADD.PVPRating=PIGFrame(FCTabF.ADD)
	-- FCTabF.ADD.PVPRating.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.PVPRating);
	-- FCTabF.ADD.PVPRating.EditBox:SetAutoFocus(false)
	-- FCTabF.ADD.PVPRating.CheckButton = PIGCheckbutton(FCTabF.ADD.PVPRating)
	-- FCTabF.ADD.PvpItemLevel=PIGFrame(FCTabF.ADD)
	-- FCTabF.ADD.PvpItemLevel.CheckButton = PIGCheckbutton(FCTabF.ADD.PvpItemLevel)
	-- FCTabF.ADD.PvpItemLevel.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.PvpItemLevel);
	-- FCTabF.ADD.PvpItemLevel.EditBox:SetAutoFocus(false)
	-- FCTabF.ADD.MythicPlusRating=PIGFrame(FCTabF.ADD)
	-- FCTabF.ADD.MythicPlusRating.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.MythicPlusRating);
	-- FCTabF.ADD.MythicPlusRating.EditBox:SetAutoFocus(false)
	-- FCTabF.ADD.MythicPlusRating.CheckButton = PIGCheckbutton(FCTabF.ADD.MythicPlusRating)
	---R
	--标题
	FCTabF.ADD.NameF=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",FCTabF.ADD.Width+100,-40})
	FCTabF.ADD.NameF:SetSize(400,40);
	FCTabF.ADD.NameF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	FCTabF.ADD.NameF:Hide()
	local NameBox = LFGListFrame.EntryCreation.Name
	NameBox:SetMultiLine(true)
	FCTabF.ADD.NameF.Label=PIGFontString(FCTabF.ADD.NameF,{"BOTTOMLEFT",FCTabF.ADD.NameF,"TOPLEFT",0,2},"标题")
	FCTabF.ADD.NameF:SetScript('OnShow', function(self)
        self:SetObject(NameBox, self, {4, -4, -4, 4})
        NameBox.Left:Hide()
        NameBox.Middle:Hide()
        NameBox.Right:Hide()
    end)
   	FCTabF.ADD.Name=NameBox
    NameBox:SetScript('OnTextChanged', function(self)
        InputBoxInstructions_OnTextChanged(self)
        FCTabF.ADD:ListGroupButton_Update()
    end)

    FCTabF.ADD.DescriptionF=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.NameF,"BOTTOMLEFT",0,-60})
	FCTabF.ADD.DescriptionF:SetSize(400,180);
	FCTabF.ADD.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	FCTabF.ADD.DescriptionF:Hide()
	local DescriptionBox = LFGListFrame.EntryCreation.Description
	FCTabF.ADD.DescriptionF.t=PIGFontString(FCTabF.ADD.DescriptionF,{"BOTTOMLEFT",FCTabF.ADD.DescriptionF,"TOPLEFT",0,2},LFG_LIST_DETAILS)
	FCTabF.ADD.DescriptionF:SetScript('OnShow', function(self)
        self:SetObject(DescriptionBox, self, {4, -4, -4, 4})
		DescriptionBox.EditBox:SetWidth(DescriptionBox:GetWidth())
        DescriptionBox.TopTex:Hide()
        DescriptionBox.TopLeftTex:Hide()
        DescriptionBox.TopRightTex:Hide()
        DescriptionBox.LeftTex:Hide()
        DescriptionBox.MiddleTex:Hide()
        DescriptionBox.RightTex:Hide()
        DescriptionBox.BottomTex:Hide()
        DescriptionBox.BottomLeftTex:Hide()
        DescriptionBox.BottomRightTex:Hide()
    end)
    FCTabF.ADD.Description=DescriptionBox
    --
    FCTabF.ADD.ListGroupButton=PIGButton(FCTabF.ADD,{"BOTTOM",FCTabF.ADD,"BOTTOM",0,40},{100,30})
    FCTabF.ADD.ListGroupButton:Hide()
	FCTabF.ADD.ListGroupButton:SetScript("OnClick", function (self)
		local fujiF = self:GetParent()
		local itemLevel = tonumber(fujiF.ItemLevel.EditBox:GetText()) or 0;
		local privateGroup = fujiF.PrivateGroup.CheckButton:GetChecked();
		local chosenRole;
		if fujiF.Role.T.checkButton:GetChecked() then
			chosenRole = "TANK";
		elseif fujiF.Role.H.checkButton:GetChecked() then
			chosenRole = "HEALER";
		elseif fujiF.Role.D.checkButton:GetChecked() then
			chosenRole = "DAMAGER";
		end
		local honorLevel = 0;
		local autoAccept=false
		local questID=0
		local mythicPlusRating=0
		local pvpRating=0
		local selectedPlaystyle=nil
		local isCrossFaction=false
		if fujiF.editMode then
			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			if activeEntryInfo.isCrossFactionListing == isCrossFaction then
				C_LFGList.UpdateListing(fujiF:GetParent().selectedActivity, itemLevel, honorLevel, activeEntryInfo.autoAccept, privateGroup, activeEntryInfo.questID, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction, chosenRole);
			else
				C_LFGList.RemoveListing();
				C_LFGList.CreateListing(fujiF:GetParent().selectedActivity, itemLevel, honorLevel, activeEntryInfo.autoAccept, privateGroup, activeEntryInfo.questID, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction, chosenRole);
			end
		else
			C_LFGList.CreateListing(fujiF:GetParent().selectedActivity, itemLevel, honorLevel, autoAccept, privateGroup, questID, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction, chosenRole)
		end
	end);
	FCTabF.ADD.adderr=PIGFontString(FCTabF.ADD,{"BOTTOMLEFT",FCTabF.ADD.ListGroupButton,"TOPLEFT",0,4})
	FCTabF.ADD.adderr:SetTextColor(1,0,0,1);

	FCTabF.ADD.RemoveBut=PIGButton(FCTabF.ADD,{"BOTTOM",FCTabF.ADD,"BOTTOM",280,40},{100,30},PET_DISMISS.."车队")
	FCTabF.ADD.RemoveBut:Hide()
	FCTabF.ADD.RemoveBut:HookScript("OnClick", function (self)
		FCTabF.ADD:PIG_Clear()
		C_LFGList.RemoveListing()
	end);

	function FCTabF.ADD:ListGroupButton_Update()
		local fujk = self:GetParent()
		local errorText;
		local isPartyLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME);
		if ( IsInGroup(LE_PARTY_CATEGORY_HOME) and not isPartyLeader ) then
			errorText = LFG_LIST_NOT_LEADER;
		else
			local myItemLevel = GetAverageItemLevel();
			self.ItemLevel.maxlv:SetText(myItemLevel)
			local eItemLevel = self.ItemLevel.EditBox:GetNumber();
			if eItemLevel>myItemLevel then
				self.ItemLevel.CheckButton:SetChecked(false)
				self.ItemLevel.warningText = LFG_LIST_ILVL_ABOVE_YOURS
			else
				self.ItemLevel.warningText = nil
				if eItemLevel>0 then
					self.ItemLevel.CheckButton:SetChecked(true)
				else
					self.ItemLevel.CheckButton:SetChecked(false)
				end
			end
			if ( ( self.Role.T:IsShown() and self.Role.T.checkButton:GetChecked())
				or ( self.Role.H:IsShown() and self.Role.H.checkButton:GetChecked())
				or ( self.Role.D:IsShown() and self.Role.D.checkButton:GetChecked()) ) then
				self.Role.warningText = nil;
			else
				self.Role.warningText = LFG_LIST_MUST_SELECT_ROLE;
			end
			fujk.selectedActivity=fujk.selectedActivity or LFGListFrame.EntryCreation.selectedActivity or 0
			local activityInfo = C_LFGList.GetActivityInfoTable(fujk.selectedActivity) or {}
			local maxNumPlayers = activityInfo and  activityInfo.maxNumPlayers or 0;
			local mythicPlusDisableActivity = not C_LFGList.IsPlayerAuthenticatedForLFG(fujk.selectedActivity) and (activityInfo.isMythicPlusActivity and not C_LFGList.GetKeystoneForActivity(fujk.selectedActivity));
			if ( maxNumPlayers > 0 and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) >= maxNumPlayers ) then
				errorText = string.format(LFG_LIST_TOO_MANY_FOR_ACTIVITY, maxNumPlayers);
			elseif (mythicPlusDisableActivity) then
				errorText = LFG_AUTHENTICATOR_BUTTON_MYTHIC_PLUS_TOOLTIP;
			elseif (LFGListEntryCreation_GetSanitizedName(self) == "") then
				errorText = LFG_LIST_MUST_HAVE_NAME;
			elseif self.ItemLevel.warningText then
				errorText = self.ItemLevel.warningText
			elseif self.Role.warningText then
				errorText = self.Role.warningText
			else
				errorText = LFGListUtil_GetActiveQueueMessage(false);
			end
		end
		self.adderr:SetText(errorText)
		self.ListGroupButton:SetEnabled(not errorText and not mythicPlusDisableActivity);
	end
	function FCTabF.ADD:PIG_Clear()
		local fujk = self:GetParent()
		fujk.selectedCategory = nil;
		fujk.selectedGroup = nil;
		fujk.selectedActivity = nil;
		C_LFGList.ClearCreationTextFields();
		self.editMode = nil
		for ix=1,#tabheji do
			_G["ADD_Wodeche_guolv"..ix]:SetChecked(false)
		end
		self.ItemLevel.CheckButton:SetChecked(false);
		self.ItemLevel.EditBox:SetText("");
		self.PrivateGroup.CheckButton:SetChecked(false);
		self.CrossFactionGroup.CheckButton:SetChecked(false);
		self.GroupDropDown:PIGDownMenu_SetText("")
		self.ActivityDropDown:PIGDownMenu_SetText("")
		self.GroupDropDown:Hide()
		self.ActivityDropDown:Hide()
		self.ItemLevel:Hide()
		self.NameF:Hide()
		self.DescriptionF:Hide()
		self.VoiceChat:Hide()
		self.CrossFactionGroup:Hide()
		self.PrivateGroup:Hide()
		self.Role:Hide()
		self.ListGroupButton:Hide()
		self.RemoveBut:Hide()
	end
	function FCTabF.ADD:SetEditMode(editMode,caozuo)
		self.editMode = editMode;
		self:Show()
		local fujk = self:GetParent()
		local EntryInfo = C_LFGList.HasActiveEntryInfo()
		if editMode and EntryInfo then
			fujk.DQ:Hide()
			for ix=1,#tabheji do
				_G["ADD_Wodeche_guolv"..ix]:Disable()
			end
			self.GroupDropDown:Disable()
			self.ActivityDropDown:Disable()

			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			fujk.selectedActivity=activeEntryInfo.activityID
			local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID)
			self.ActivityDropDown:PIGDownMenu_SetText(activityInfo.fullName)
			fujk.selectedCategory=activityInfo.categoryID
			fujk.selectedGroup=activityInfo.groupFinderActivityGroupID
			if fujk.selectedCategory==118 then
				if not caozuo then
					C_LFGList.SetEntryTitle(1064, 0, fujk.selectedPlaystyle);
				end
			else
				C_LFGList.CopyActiveEntryInfoToCreationFields();
			end
			local categoryInfo = C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID);
			for ixx=1,#tabheji do
				local kjih = _G["ADD_Wodeche_guolv"..ixx]
				if activityInfo.categoryID==kjih:GetID() then
					kjih:SetChecked(true)
					break
				end
			end
			self.GroupDropDown:SetShown(not categoryInfo.autoChooseActivity);
			self.ActivityDropDown:SetShown(not categoryInfo.autoChooseActivity);
			local name = C_LFGList.GetActivityGroupInfo(activityInfo.groupFinderActivityGroupID)
			self.GroupDropDown:PIGDownMenu_SetText(name)
			local isAccountSecured = C_LFGList.IsPlayerAuthenticatedForLFG(activeEntryInfo.activityID);
			if isAccountSecured then
				self.NameF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
				self.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
			else
				self.NameF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
				self.DescriptionF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
			end
			self.ItemLevel.EditBox:SetText(activeEntryInfo.requiredItemLevel)
			self.PrivateGroup.CheckButton:SetChecked(activeEntryInfo.privateGroup);
			self.CrossFactionGroup.CheckButton:SetChecked(activeEntryInfo.allowCrossFaction)
			self.ItemLevel:Show()
			--self.CrossFactionGroup:Show()
			self.PrivateGroup:Show()
			self.NameF:Show()
			self.DescriptionF:Show()
			self.ListGroupButton:Show()
			self.Role:Show()
			self.ListGroupButton:Show()
			self.ListGroupButton:SetText("更新车队")
			self.RemoveBut:Show()
		else
			for ix=1,#tabheji do
				_G["ADD_Wodeche_guolv"..ix]:Enable()
			end
			if not fujk.selectedCategory then return end
			self.ListGroupButton:Show()
			self.ListGroupButton:SetText("创建车队")
			self.GroupDropDown:Enable()
			self.ActivityDropDown:Enable()
			self.ItemLevel:Show()
			--self.CrossFactionGroup:Show()
			self.PrivateGroup:Show()
			self.NameF:Show()
			self.DescriptionF:Show()
			self.ListGroupButton:Show()
			self.Role:Show()
			fujk.selectedPlaystyle=1
			local categoryInfo = C_LFGList.GetLfgCategoryInfo(fujk.selectedCategory);
			self.GroupDropDown:SetShown(not categoryInfo.autoChooseActivity);
			self.ActivityDropDown:SetShown(not categoryInfo.autoChooseActivity);
			local activityGroups = C_LFGList.GetAvailableActivityGroups(fujk.selectedCategory)
			fujk.selectedGroup=fujk.selectedGroup or activityGroups[1] or 0
			local name = C_LFGList.GetActivityGroupInfo(fujk.selectedGroup)
			self.GroupDropDown:PIGDownMenu_SetText(name)
			--
			local activities = C_LFGList.GetAvailableActivities(fujk.selectedCategory,fujk.selectedGroup)
			fujk.selectedActivity=fujk.selectedActivity or activities[1] or 0
			local activityInfo = C_LFGList.GetActivityInfoTable(fujk.selectedActivity)
			self.ActivityDropDown:PIGDownMenu_SetText(activityInfo.fullName)
			local isAccountSecured = C_LFGList.IsPlayerAuthenticatedForLFG(fujk.selectedActivity);
			self.Name.editBoxEnabled = isAccountSecured;
			self.Description.editBoxEnabled = isAccountSecured;
			self.Name:SetEnabled(isAccountSecured);
			self.Description.EditBox:SetEnabled(isAccountSecured);
			self.Name.LockButton:SetShown(not isAccountSecured);
			self.Description.LockButton:SetShown(not isAccountSecured);
			local descInstructions = nil;
			if isAccountSecured then
				self.NameF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
				self.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
			else
				self.NameF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
				self.DescriptionF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
				descInstructions = LFG_AUTHENTICATOR_DESCRIPTION_BOX;
			end
			self.Description.EditBox.Instructions:SetText(descInstructions or DESCRIPTION_OF_YOUR_GROUP);
			--
			if fujk.selectedCategory==118 then
				if(not isAccountSecured) then
					if not caozuo then
						C_LFGList.SetEntryTitle(1064, 0, fujk.selectedPlaystyle);
					end
				end
			elseif fujk.selectedCategory==GROUP_FINDER_CATEGORY_ID_DUNGEONS or fujk.selectedCategory==114 then
				if((activityInfo and activityInfo.isMythicPlusActivity) or not isAccountSecured) then
					if not caozuo then
						C_LFGList.SetEntryTitle(fujk.selectedActivity, fujk.selectedGroup, fujk.selectedPlaystyle);
					end
				end
			end
		end
		self:ListGroupButton_Update()
	end
	-----------
	function FCTabF.DQ:ShowData()
		self:Show()
		C_LFGList.RefreshApplicants();
		local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
		local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID);	
		local categoryInfo= C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID)
		local huodongname=tabhejiNameth[categoryInfo.name] or categoryInfo.name
		self.Category_V:SetText(huodongname);
		self.Name_V:SetText(activityInfo.fullName);
		self.ItemLevel_V:SetText(activeEntryInfo.requiredItemLevel);
		self.EntryName.V:SetText(activeEntryInfo.name);
		self.Description.V:SetText(activeEntryInfo.comment);
		local shouldDisableCrossFactionToggle = (categoryInfo.allowCrossFaction) and not (activityInfo.allowCrossFaction);
		self.CrossFactionGroup.CheckButton:SetChecked(shouldDisableCrossFactionToggle)
		self.PrivateGroup.CheckButton:SetChecked(activeEntryInfo.privateGroup);
		self.Apply.AutoAcceptButton:SetChecked(activeEntryInfo.autoAccept);
		self.Apply:Update_Players()
	end
	function FCTabF:ShowData(caozuo)
		if self:IsShown() then
			self.DQ:Hide()
			self.ADD:Hide()
			local EntryInfo = C_LFGList.HasActiveEntryInfo()
			if EntryInfo then
				self.DQ:ShowData(caozuo)
			else
				self.ADD:SetEditMode(nil,caozuo)
			end
		end
	end
	FCTabBut:HookScript("OnClick", function (self)
		FCTabF:ShowData()
	end);		
	fujiF.F:HookScript("OnShow", function (self)
		local EntryInfo = C_LFGList.HasActiveEntryInfo()
		if EntryInfo then
			TabF:Hide()
			TabBut:NotSelected()
			FCTabF:Show()
			FCTabF:ShowData()
			FCTabBut:Selected()
		else
			FCTabF:Hide()
			FCTabBut:NotSelected()
			TabF:Show()
			TabBut:Selected()
		end
	end);
	MiniMapLFGFrame:SetScript("OnClick", function (self,button)
		if ( button == "RightButton" ) then
			QueueStatusDropDown_Show(self.DropDown, self:GetName());
		else
			local mode = GetLFGMode(LE_LFG_CATEGORY_LFD);
			if ( mode == "queued" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
				PVEFrame_ToggleFrame()
			else
				if InvF:IsShown() then
					InvF:Hide()
				else
					InvF:Show()
					Create.Show_TabBut_R(InvF.F,fujiF,fujiTabBut)
				end
			end
		end
	end);
	-----------
	FCTabF:RegisterEvent("LFG_LIST_APPLICANT_UPDATED");--來自申请人狀態改變
	FCTabF:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED");--列表刷新
	FCTabF:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE");--活动变动时
	FCTabF:RegisterEvent("LFG_LIST_AVAILABILITY_UPDATE");--列表可用性更新
	FCTabF:RegisterEvent("GROUP_ROSTER_UPDATE");
	FCTabF:HookScript("OnEvent", function(self,event,arg1)
		--print(event,arg1)
		if event=="LFG_LIST_APPLICANT_UPDATED" then
			if ( not LFGListUtil_IsEntryEmpowered() ) then
				C_LFGList.RemoveApplicant(arg1);
			else
				local frame = FCTabF.DQ.Apply.applist.ScrollBox:FindFrameByPredicate(function(frame, elementData)
					return elementData.id == arg1;
				end);
				if frame then
					UpdateApplicant(frame, arg1);
				end
			end
		end
		if event=="LFG_LIST_APPLICANT_LIST_UPDATED" or event=="LFG_LIST_AVAILABILITY_UPDATE" then
			self.DQ.Apply.Update_AppList(self.DQ.Apply)
		end
		if event=="GROUP_ROSTER_UPDATE" then
			if self.ADD.ListGroupButton:IsShown() then
				self.ADD:ListGroupButton_Update()
			end
			self.DQ.Apply:Update_Players()
		end
		--Mode值(true新建/false编辑/nil取消)
		if event=="LFG_LIST_ACTIVE_ENTRY_UPDATE" then
			if arg1==true then
				self:ShowData("New")
			elseif arg1==false then
				self:ShowData("Edit")
			elseif arg1==nil then
				self:ShowData("Rem")
			end
		end
	end);
end