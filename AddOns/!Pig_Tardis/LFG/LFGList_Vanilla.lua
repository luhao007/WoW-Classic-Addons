local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.LFGList_Vanilla(TabF,EnterF,baseFilters)
	local Create, Data, Fun, L= unpack(PIG)
	local match = _G.string.match
	---------------------
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGEnter=Create.PIGEnter
	local PIGButton = Create.PIGButton
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local PIGDiyBut=Create.PIGDiyBut
	local PIGDownMenu=Create.PIGDownMenu
	local FasongYCqingqiu=Fun.FasongYCqingqiu
	local PIG_GetCategories=Fun.PIG_GetCategories
	------
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local hang_Height,hang_NUM=InvF.hang_Height,InvF.hang_NUM-1
	local UpdatehangEnter=InvF.UpdatehangEnter
	local addRoleSetBut=InvF.addRoleSetBut
	local SetEditBoxBG=InvF.SetEditBoxBG
	local RolesName=InvF.RolesName
	local RolesNameIcon=InvF.RolesNameIcon
	-----
	TabF.WhisperInvite={}--已密语/邀请
	function TabF.AddInvitePlayer(resultID)
		TabF.WhisperInvite[resultID]=TabF.WhisperInvite[resultID] or {}
		TabF.WhisperInvite[resultID]["Invite"]=true
		TabF.GetHangBut(resultID)
	end
	function TabF.IsInvitePlayer(resultID)
		if TabF.WhisperInvite[resultID] and TabF.WhisperInvite[resultID]["Invite"] then
			return true
		end
		return false
	end
	function TabF.AddWhisperPlayer(resultID)
		TabF.WhisperInvite[resultID]=TabF.WhisperInvite[resultID] or {}
		TabF.WhisperInvite[resultID]["Whisper"]=true
		TabF.GetHangBut(resultID)
	end
	function TabF.IsWhisperPlayer(resultID)
		if TabF.WhisperInvite[resultID] and TabF.WhisperInvite[resultID]["Whisper"] then
			return true
		end
		return false
	end

	TabF.CategorieButList={}
	TabF.ActTypeFilters={}
	TabF.FilterData3={}
	function TabF:Enabled_Categorie(BOT)
		for i=1,#TabF.CategorieButList do
			TabF.CategorieButList[i]:SetEnabled(BOT)
		end
	end
	TabF:HookScript("OnShow", function (self)
		if not TabF.tabList then
			TabF.tabList=PIG_GetCategories(baseFilters)
			for i=1,#TabF.tabList do
				TabF.ActTypeFilters[TabF.tabList[i][1]]={ALL,L["TARDIS_CHEDUI_1"],L["TARDIS_CHEDUI_2"]}
				---90001-欢迎新手90002-适合当前级别
				TabF.FilterData3[TabF.tabList[i][1]]={{"符合"..LEVEL,90001},{LFG_LIST_NEW_PLAYER_FRIENDLY_HEADER,90002}}
			end
		end
		for i=1,#TabF.tabList do
			if not TabF.CategorieButList[i] then
				TabF.CategorieButList[i] = PIGCheckbutton(TabF,nil,nil,nil,nil,nil,nil,1)
				if i==1 then
					TabF.CategorieButList[i]:SetPoint("TOPLEFT",TabF,"TOPLEFT",10,-10)
				else
					TabF.CategorieButList[i]:SetPoint("LEFT",TabF.CategorieButList[i-1].Text,"RIGHT",8,0)
				end
				TabF.CategorieButList[i]:HookScript("OnClick", function (self)
					for ix=1,#TabF.CategorieButList do
						TabF.CategorieButList[ix]:SetChecked(false)
					end
					self:SetChecked(true)
					TabF.selectedCategory=self:GetID()
					TabF.ResetFilters()	
					TabF:Update_Search()
				end)
			end
			TabF.CategorieButList[i]:Hide()
			TabF.CategorieButList[i]:Show()
			TabF.CategorieButList[i].Text:SetText(TabF.tabList[i][2])
			TabF.CategorieButList[i]:SetID(TabF.tabList[i][1])
			TabF.CategorieButList[i]:UpdateHitRectInsets()
		end
		TabF.Update_HangALL()
	end);
	--找队员还是找队伍
	TabF.ActTypeList={}
	TabF.selectActType=0
	function TabF:Shown_ActType(BOT)
		for i=1,#TabF.ActTypeList do
			TabF.ActTypeList[i]:SetShown(BOT)
		end
	end
	function TabF:GetNextCategorie()
		for ibut=#TabF.CategorieButList,1,-1 do
			if TabF.CategorieButList[ibut]:IsShown() then
				return ibut
			end
		end
		return 0
	end
	function TabF:Update_ActType()
		self:Shown_ActType(false)
		self.selectActType=self.selectActType or 0
		if TabF.ActTypeFilters[self.selectedCategory] then
			for i=1,#TabF.ActTypeFilters[self.selectedCategory] do
				if not self.ActTypeList[i] then
					self.ActTypeList[i] = PIGCheckbutton(TabF,nil,nil,nil,nil,nil,nil,1)
					if i==1 then
						self.ActTypeList[i].fenge = self.ActTypeList[i]:CreateTexture();
						self.ActTypeList[i].fenge:SetAtlas("GreenCross")
						self.ActTypeList[i].fenge:SetSize(26,26);
						self.ActTypeList[i].fenge:SetPoint("RIGHT",self.ActTypeList[i],"LEFT",-2, 0);
					else
						self.ActTypeList[i]:SetPoint("LEFT",TabF.ActTypeList[i-1].Text,"RIGHT",8,0)
					end
					self.ActTypeList[i]:HookScript("OnClick", function (self)
						for ix=1,#TabF.ActTypeList do
							TabF.ActTypeList[ix]:SetChecked(false)
						end
						self:SetChecked(true)
						TabF.selectActType=self.ActTypeID
						TabF.Update_HangALL(nil,true)
					end)
				end
				if i==1 then
					self.ActTypeList[i]:ClearAllPoints();
					local nexbutID=TabF:GetNextCategorie()
					if nexbutID>0 then
						self.ActTypeList[i]:SetPoint("LEFT",TabF.CategorieButList[nexbutID].Text,"RIGHT",30,0)
					else
						self.ActTypeList[i]:SetPoint("TOPLEFT",TabF,"TOPLEFT",10,-40)
					end
				end
				self.ActTypeList[i].ActTypeID=i-1
				self.ActTypeList[i]:Show()
				self.ActTypeList[i]:SetChecked(i==1 or false)
				self.ActTypeList[i].Text:SetText(TabF.ActTypeFilters[self.selectedCategory][i])
				self.ActTypeList[i]:UpdateHitRectInsets()
			end
		end
	end
	--难度过滤
	TabF.DifficultyButList={}
	TabF.selectDifficulty=0
	function TabF:Shown_Difficulty(BOT)
		for i=1,#TabF.DifficultyButList do
			TabF.DifficultyButList[i]:SetShown(BOT)
		end
	end
	function TabF:Update_Difficulty()
		TabF:Shown_Difficulty(false)
		self.selectDifficulty=self.selectDifficulty or 0
		local GroupList,GroupData,DifficultyD=Fun.PIG_GetGroups(self.selectedCategory,baseFilters)
		if #DifficultyD>1 then
			for i=1,#DifficultyD do
				if not TabF.DifficultyButList[i] then
					self.DifficultyButList[i] = PIGCheckbutton(TabF,nil,nil,nil,nil,nil,nil,1)
					self.DifficultyButList[i]:Hide()
					if i==1 then
						self.DifficultyButList[i]:SetPoint("TOPLEFT",TabF,"TOPLEFT",10,-40)
					else
						self.DifficultyButList[i]:SetPoint("LEFT",TabF.DifficultyButList[i-1].Text,"RIGHT",8,0)
					end
					self.DifficultyButList[i]:HookScript("OnClick", function (self)
						for ix=1,#TabF.DifficultyButList do
							TabF.DifficultyButList[ix]:SetChecked(false)
						end
						self:SetChecked(true)
						TabF.selectDifficulty=self.DifficuIDs
						TabF.Update_HangALL(nil,true)
					end)
				end
				self.DifficultyButList[i]:Show()
				self.DifficultyButList[i].DifficuIDs=DifficultyD[i][1]
				self.DifficultyButList[i]:SetChecked(self.selectDifficulty==DifficultyD[i][1])
				self.DifficultyButList[i].Text:SetText(DifficultyD[i][2])
				self.DifficultyButList[i]:UpdateHitRectInsets()
			end
		end
	end
	function TabF:GetNextbutpnim()
		for ibut=#TabF.DifficultyButList,1,-1 do
			if TabF.DifficultyButList[ibut]:IsShown() then
				return ibut
			end
		end
		return 0
	end
	--三级过滤
	TabF.FilterData3List={}
	TabF.selectFilterData3={}
	function TabF:Shown_FilterData3(BOT)
		for i=1,#TabF.FilterData3List do
			TabF.FilterData3List[i]:SetShown(BOT)
		end
	end
	function TabF:Update_FilterData3()
		TabF:Shown_FilterData3(false)
		if TabF.FilterData3[self.selectedCategory] then
			for i=1,#TabF.FilterData3[self.selectedCategory] do
				if not self.FilterData3List[i] then
					self.FilterData3List[i] = PIGCheckbutton(TabF)
					if i==1 then
						self.FilterData3List[i].fenge = self.FilterData3List[i]:CreateTexture();
						self.FilterData3List[i].fenge:SetAtlas("GreenCross")
						self.FilterData3List[i].fenge:SetSize(26,26);
						self.FilterData3List[i].fenge:SetPoint("RIGHT",self.FilterData3List[i],"LEFT",-2, 0);
					else
						self.FilterData3List[i]:SetPoint("LEFT",TabF.FilterData3List[i-1].Text,"RIGHT",8,0)
					end
					self.FilterData3List[i]:HookScript("OnClick", function (self)
						if TabF.selectFilterData3[self.FilterData3ID] then
							TabF.selectFilterData3[self.FilterData3ID]=nil
						else
							TabF.selectFilterData3[self.FilterData3ID]=true
						end
						self:SetChecked(TabF.selectFilterData3[self.FilterData3ID])
						TabF.Update_HangALL(nil,true)
					end)
				end
				if i==1 then
					self.FilterData3List[i]:ClearAllPoints();
					local nexbutID=TabF:GetNextbutpnim()
					if nexbutID>0 then
						self.FilterData3List[i].fenge:Show()
						self.FilterData3List[i]:SetPoint("LEFT",TabF.DifficultyButList[nexbutID].Text,"RIGHT",30,0)
					else
						self.FilterData3List[i].fenge:Hide()
						self.FilterData3List[i]:SetPoint("TOPLEFT",TabF,"TOPLEFT",10,-40)
					end
				end
				self.selectFilterData3[TabF.FilterData3[self.selectedCategory][i][2]]=nil
				self.FilterData3List[i].FilterData3ID=TabF.FilterData3[self.selectedCategory][i][2]
				self.FilterData3List[i]:Show()
				self.FilterData3List[i]:SetChecked(false)
				self.FilterData3List[i].Text:SetText(TabF.FilterData3[self.selectedCategory][i][1])
				self.FilterData3List[i]:UpdateHitRectInsets()
			end
		end
	end
	--搜索
	TabF.SearchBoxBG=PIGFrame(TabF,{"TOPRIGHT",TabF,"TOPRIGHT",-110,-6},{120,18})
	TabF.SearchBoxBG:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
	TabF.SearchBoxBG:Hide()
	TabF.SearchBox = CreateFrame("EditBox", nil, TabF.SearchBoxBG, "SearchBoxTemplate");
	TabF.SearchBox:SetPoint("TOPLEFT",TabF.SearchBoxBG,"TOPLEFT",3,-1);
	TabF.SearchBox:SetPoint("BOTTOMRIGHT",TabF.SearchBoxBG,"BOTTOMRIGHT",0,1);
	TabF.SearchBox.Left:Hide()
    TabF.SearchBox.Middle:Hide()
    TabF.SearchBox.Right:Hide()
    TabF.SearchBox:HookScript("OnEditFocusLost", function(self)
		TabF.SearchBoxBG:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
	end)
	TabF.SearchBox:HookScript("OnEditFocusGained", function(self)
		TabF.SearchBoxBG:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	end);
	TabF.SearchBox:HookScript("OnTextChanged", function(self)
    	TabF.IsSearchFilter()
	end)
	TabF.SearchBox:HookScript("OnEnterPressed", function(self)
		TabF:Update_Search()
	end);
	--选择具体副本
	TabF.FilterFBData={}
	TabF.selectedFBData={}
	TabF.FilterFB=PIGDownMenu(TabF,{"TOPRIGHT",TabF.SearchBoxBG,"BOTTOMRIGHT",0,-8},{90,22})
	TabF.FilterFB:PIGDownMenu_SetText(FILTER)
	TabF.FilterFB:Hide()
	function TabF.FilterFB:PIGDownMenu_Update_But(level,menuList)
		if not TabF.selectedCategory then return end
		local info = {}
		if (level or 1) == 1 then
			local GroupList,GroupData=Fun.PIG_GetGroups(TabF.selectedCategory,baseFilters)
			if #GroupList>1 then
				info.func = nil
				info.isNotRadio=true
				local CategoryInfo= C_LFGList.GetLfgCategoryInfo(TabF.selectedCategory)
				for ixx=1,#GroupList do
					info.text= GroupList[ixx][2]
					info.menuList, info.hasArrow = GroupData[GroupList[ixx][1]], true
					info.checked = Fun.IsAvailGroups(TabF.selectedFBData,GroupData[GroupList[ixx][1]],true)
					self:PIGDownMenu_AddButton(info)
				end
			else
				info.func = self.PIGDownMenu_SetValue
				info.isNotRadio=true
				if #GroupList==1 then
					GroupData=GroupData[GroupList[1][1]]
				end
				for ixx=1,#GroupData do
					info.text= InvF.UpdateLevelColor(nil,GroupData[ixx][3],GroupData[ixx][4],GroupData[ixx][2].."("..GroupData[ixx][3].."-"..GroupData[ixx][4]..")")
					info.arg1= GroupData[ixx][1]
					info.checked = TabF.selectedFBData[GroupData[ixx][1]]
					self:PIGDownMenu_AddButton(info)
				end
			end
		else
			info.func = self.PIGDownMenu_SetValue
			info.isNotRadio=true
			for acid=1, #menuList do
				info.text= InvF.UpdateLevelColor(nil,menuList[acid][3],menuList[acid][4],menuList[acid][2])
				info.arg1= menuList[acid][1]
				info.checked = TabF.selectedFBData[menuList[acid][1]]
				self:PIGDownMenu_AddButton(info, level,acid==#menuList)
			end
		end
	end
	function TabF.FilterFB:PIGDownMenu_SetValue(value,arg1,arg2,checked)
		if checked then
			TabF.selectedFBData[arg1]=true
		else
			TabF.selectedFBData[arg1]=nil
		end
		TabF.Update_HangALL(nil,true)
		PIGCloseDropDownMenus()
	end
	--收藏团长
	TabF.selectFavorite=0
	TabF.FavoriteBut = CreateFrame("CheckButton", nil, TabF);
	TabF.FavoriteBut:SetSize(22,22);
	TabF.FavoriteBut:SetPoint("RIGHT",TabF.FilterFB,"LEFT",-38,0);
	TabF.FavoriteBut:SetHitRectInsets(0,-34,0,0);
	TabF.FavoriteBut:SetMotionScriptsWhileDisabled(true)
	TabF.FavoriteBut:Hide()
	TabF.FavoriteBut.Text=PIGFontString(TabF.FavoriteBut,{"LEFT",TabF.FavoriteBut,"RIGHT",0,0},"收藏")
	TabF.FavoriteBut.Text:SetTextColor(1, 0.1, 1, 1);
	PIGEnter(TabF.FavoriteBut,"只显示收藏的团长")
	TabF.FavoriteBut.TexC = TabF.FavoriteBut:CreateTexture(nil, "BORDER");
	TabF.FavoriteBut.TexC:SetTexture("interface/common/friendship-heart.blp");
	--TabF.FavoriteBut.TexC:SetAtlas("auctionhouse-icon-favorite")
	TabF.FavoriteBut.TexC:SetSize(34,32);
	if PIG_MaxTocversion(50000) then
		TabF.FavoriteBut.TexC:SetPoint("CENTER",TabF.FavoriteBut,"CENTER",0,-3);
	else
		TabF.FavoriteBut.TexC:SetPoint("CENTER",TabF.FavoriteBut,"CENTER",0,0);
	end
	TabF.FavoriteBut:SetScript("OnClick", function (self)
		if TabF.selectFavorite==0 then
			TabF.selectFavorite=1
		elseif TabF.selectFavorite==1 then
			TabF.selectFavorite=0
		end
		TabF:Enabled_Favorite(TabF.selectFavorite==1)
		TabF.Update_HangALL(nil,true)
	end);
	function TabF:Enabled_Favorite(BOT)
		TabF.FavoriteBut.TexC:SetDesaturated(not BOT)
		if BOT then
			TabF.FavoriteBut.Text:SetTextColor(1, 0.1, 1, 1);
		else
			TabF.FavoriteBut.Text:SetTextColor(0.5, 0.5, 0.5, 1);
		end
	end
	function TabF:Update_Favorite()
		self.FavoriteBut:Show()
		self.selectFavorite=self.selectFavorite or 0
		self:Enabled_Favorite(TabF.selectFavorite==1)
	end
	--
	function TabF.ResetFilters()
		TabF.selectActType=0
		TabF.selectFavorite=0 
		TabF.selectDifficulty=0 
		wipe(TabF.selectFilterData3)
		wipe(TabF.selectedFBData)
		TabF.SearchBox:SetText("")
		--C_LFGList.ClearSearchResults();
		C_LFGList.ClearSearchTextFields();
	end
	function TabF.IsSearchFilter()
		if TabF.selectActType~=0 or TabF.selectDifficulty~=0 or TabF.selectFavorite~=0 or next(TabF.selectFilterData3)~=nil or next(TabF.selectedFBData)~=nil or
			TabF.SearchBox:GetText() ~= "" then
			TabF.ResetBut:Enable()
		else
			TabF.ResetBut:Disable()
		end
	end
	function TabF.ResetSearchFilter()
		TabF.ResetBut:Disable()
		TabF.ResetFilters()
		TabF:Update_Favorite()
		TabF:Update_Difficulty()
		TabF:Update_ActType()
		TabF:Update_FilterData3()
		TabF.Update_HangALL(nil,true)
	end
	function TabF:DelayUpdateButEnable()
		TabF.RefreshBut:SetText(REFRESH)
		TabF.RefreshBut:Enable()
		TabF.ResetBut:Show()
		TabF.SearchBoxBG:Show()
		TabF.FilterFB:Show()
		TabF.FavoriteBut:Show()
		TabF:Enabled_Categorie(true)
		TabF:Update_Favorite()
		TabF:Update_Difficulty(true)
		TabF:Update_ActType(true)
		TabF:Update_FilterData3(true)
	end
	function TabF:Update_Search()
		TabF.Returned=false
		TabF.RefreshBut:SetText(SEARCHING)
		TabF.RefreshBut:Disable()
		TabF.ResetBut:Hide()
		TabF.SearchBoxBG:Hide()
		TabF.FilterFB:Hide()
		TabF.FavoriteBut:Hide()
		TabF:Enabled_Categorie(false)
		TabF:Shown_Difficulty(false)
		TabF:Shown_FilterData3(false)
		TabF:Shown_ActType(false)
		TabF.Reset_HangALL()
		local languages = C_LFGList.GetLanguageSearchFilter();
		C_LFGList.Search(TabF.selectedCategory, 0, 0, languages);--[1大分类][2小分类(5疑似自己建立队伍)][1推荐,2不推荐,4PVE,8PVP][语言过滤]
		C_Timer.After(2,function()
			if not TabF.Returned then TabF:DelayUpdateButEnable() end 
		end)
	end

	----
	TabF.F=PIGFrame(TabF,{"TOPLEFT",TabF,"TOPLEFT",0,-66})
	TabF.F:SetPoint("BOTTOMRIGHT",TabF,"BOTTOMRIGHT",0,0);
	TabF.F:PIGSetBackdrop()
	--
	local biaotiName={{"目的地",2},{"司机(|cffFF80FF"..L["CHAT_WHISPER"].."/"..SLASH_TEXTTOSPEECH_MENU.."|r)",260},{MEMBERS,394},{"详情",510},{"操作",800}}
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
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, TabF.Update_HangALL)
	end)
	local old_UpdatehangEnter=UpdatehangEnter
	UpdatehangEnter=function(uix,fujie)
		local fujie=fujie or uix
		old_UpdatehangEnter(uix,fujie)
		uix:HookScript("OnEnter", function ()
			if C_LFGList.HasActiveEntryInfo() then
				fujie.caozuo.Whisper:Hide()
			else
				if fujie.caozuo.Apply:IsShown() and fujie.inviteFunc then
					fujie.caozuo.Whisper:Show()
				end
			end
		end);
		uix:HookScript("OnLeave", function ()
			fujie.caozuo.Whisper:Hide()
		end);
	end
	TabF.CheduiListBut={}
	for i=1, hang_NUM, 1 do
		local hangL = CreateFrame("Button", nil, TabF.F,"BackdropTemplate");
		TabF.CheduiListBut[i]=hangL
		hangL:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hangL:SetSize(hang_Width-2,hang_Height);
		hangL:SetBackdropColor(0.2, 0.2, 0.2, 0.2);
		if i==1 then
			hangL:SetPoint("TOPLEFT", TabF.F.Scroll, "TOPLEFT", 0, -1);
		else
			hangL:SetPoint("TOPLEFT", TabF.CheduiListBut[i-1], "BOTTOMLEFT", 0, -1);
		end
		UpdatehangEnter(hangL)
		hangL.resultIDT=PIGFontString(hangL,{"RIGHT", hangL, "LEFT", -10,0},0,"OUTLINE");
		hangL.resultIDT:Hide()
		hangL.mudidi = PIGFontString(hangL,{"LEFT", hangL, "LEFT",biaotiName[1][2], 0},nil,nil,nil,nil,nil,true);
		hangL.mudidi:SetTextColor(0,0.98,0.6, 1);
		hangL.mudidi:SetSize(biaotiName[2][2]-biaotiName[1][2]-4,hang_Height-4);
		hangL.mudidi:SetJustifyH("LEFT");
		hangL.mudidi.biaoti=biaotiName[1][1]
		UpdatehangEnter(hangL.mudidi,hangL)
		hangL.chetou = CreateFrame("Frame", nil, hangL);
		hangL.chetou:SetSize(120,hang_Height);
		hangL.chetou:SetPoint("LEFT", hangL, "LEFT", biaotiName[2][2], 0);
		UpdatehangEnter(hangL.chetou,hangL)
		hangL.chetou.Class = hangL.chetou:CreateTexture(nil, "BORDER");
		hangL.chetou.Class:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
		hangL.chetou.Class:SetSize(hang_Height*0.8,hang_Height*0.8);
		hangL.chetou.Class:SetPoint("BOTTOMLEFT", hangL.chetou, "BOTTOMLEFT", 0, 0);
		hangL.chetou.Role = hangL.chetou:CreateTexture(nil,"ARTWORK");
		hangL.chetou.Role:SetSize(hang_Height*0.6,hang_Height*0.6);
		hangL.chetou.Role:SetPoint("TOPLEFT", hangL.chetou.Class, "TOPLEFT", -3,6);
		hangL.chetou.Favorite = hangL.chetou:CreateTexture(nil,"ARTWORK");
		hangL.chetou.Favorite:SetTexture("interface/common/friendship-heart.blp");
		hangL.chetou.Favorite:SetSize(hang_Height*1,hang_Height*0.8);
		hangL.chetou.Favorite:SetPoint("BOTTOMRIGHT", hangL.chetou.Class, "BOTTOMLEFT", 5,-5);
		hangL.chetou.new = hangL.chetou:CreateTexture(nil,"ARTWORK");
		hangL.chetou.new:SetSize(hang_Height*0.6,hang_Height*0.56);
		hangL.chetou.new:SetAtlas("newplayerchat-chaticon-newcomer")
		hangL.chetou.new:SetPoint("BOTTOM", hangL.chetou.Favorite, "TOP", 0.6,-5);
		hangL.chetou.level = PIGFontString(hangL.chetou,{"LEFT", hangL.chetou.Role, "RIGHT", -3,2},99,"OUTLINE",11);
		hangL.chetou.name = PIGFontString(hangL.chetou,{"LEFT", hangL.chetou, "LEFT", hang_Height*0.8, 0});
		hangL.chetou:SetScript("OnMouseUp", function(self,button)
			local allname = self:GetParent().allname
			if allname==UNKNOWNOBJECT then return end
			if button=="LeftButton" then
				local editBox = ChatEdit_ChooseBoxForSend();
				local hasText = editBox:GetText()
				if editBox:HasFocus() then
					editBox:SetText("/WHISPER " ..allname.." ".. hasText);
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText("/WHISPER " ..allname.." ".. hasText);
				end
			elseif button=="RightButton" then
				InvF.RGN:ClearAllPoints();
				InvF.RGN:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,0);
				InvF.RGN.name:SetText(allname);
				local wrappedWidth = InvF.RGN.name:GetWrappedWidth()
				if wrappedWidth>150 then
					InvF.RGN:SetWidth(wrappedWidth+8)
				else
					InvF.RGN:SetWidth(150)
				end
				InvF.RGN.name.X=allname;
				InvF.RGN.FavoriteIcon=self.Favorite
				InvF.RGN.xiaoshidaojishi = 1.5;
				InvF.RGN.zhengzaixianshi = true;
				InvF.RGN:Show()
			end
		end)
		--成员显示模式
		InvF.addPlayerShowMode(hangL,biaotiName[3][2]-4)

		hangL.commentF=PIGFrame(hangL,{"LEFT", hangL, "LEFT",biaotiName[4][2], 0},{biaotiName[5][2]-biaotiName[4][2]-4,hang_Height-4})
		UpdatehangEnter(hangL.commentF,hangL)
		hangL.commentF.t = PIGFontString(hangL.commentF,{"LEFT", hangL.commentF, "LEFT", 0, 0},nil,nil,nil,nil,nil,true);
		hangL.commentF.t:SetTextColor(0.9,0.9,0.9,0.9);
		hangL.commentF.t:SetAllPoints(hangL.commentF)
		hangL.commentF.t:SetJustifyH("LEFT");
		hangL.commentF.t.biaoti=biaotiName[4][1]
		UpdatehangEnter(hangL.commentF.t,hangL)

		hangL.caozuo=PIGFrame(hangL,{"LEFT", hangL, "LEFT", biaotiName[5][2], 0},{54,hang_Height})
		UpdatehangEnter(hangL.caozuo,hangL)
		hangL.caozuo.Apply = PIGButton(hangL.caozuo, {"LEFT", hangL.caozuo, "LEFT", 0, 0},{46,18},SIGN_UP);
		UpdatehangEnter(hangL.caozuo.Apply,hangL)
		PIGSetFont(hangL.caozuo.Apply.Text,12)
		hangL.caozuo.Apply.Text:SetTextColor(0.9,0.9,0.9,1);
		hangL.caozuo.Apply:HookScript("OnClick", function(self)
			local dqhang=self:GetParent():GetParent()
			if dqhang.inviteFunc then
				local allname = dqhang.allname
				if allname~=UNKNOWNOBJECT then
					if C_LFGList.HasActiveEntryInfo() then
						local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
						local activityNames=""
						for acid=1,#activeEntryInfo.activityIDs do
							local activityID=activeEntryInfo.activityIDs[acid]
							local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
							activityNames=activityNames..activityInfo.fullName..", "
						end
						SendChatMessage(activityNames.."来吗？", "WHISPER", nil, allname);
					end
					dqhang.inviteFunc()
					TabF.AddInvitePlayer(dqhang.resultID)
				end
			else
				TabF.Update_ApplyDialog(dqhang.resultID)
			end
		end)
		hangL.caozuo.Whisper = PIGButton(hangL.caozuo, {"RIGHT", hangL.caozuo.Apply, "LEFT", -2, 0},{40,18},SIGN_UP);
		UpdatehangEnter(hangL.caozuo.Whisper,hangL)
		PIGSetFont(hangL.caozuo.Whisper.Text,12)
		hangL.caozuo.Whisper.Text:SetTextColor(0.9,0.9,0.9,1);
		hangL.caozuo.Whisper:HookScript("OnClick", function(self)
			TabF.Update_ApplyDialog(self:GetParent():GetParent().resultID)
		end)
		function hangL:Updata_MudidiLvCom(searchResultInfo,inviteFunc)
			self.commentF.t:SetText(searchResultInfo.comment)
			local activityNames=""
			for acid=1,#searchResultInfo.activityIDs do
				local activityID=searchResultInfo.activityIDs[acid]
				local activityName = C_LFGList.GetActivityFullName(activityID, nil, searchResultInfo.isWarMode);
				if acid==#searchResultInfo.activityIDs then
					activityNames=activityNames..activityName
				else
					activityNames=activityNames..activityName..", "
				end
			end
			self.mudidi:SetText(activityNames);	
			if searchResultInfo.isDelisted then
				self.mudidi:SetTextColor(0.5,0.5,0.5,1);
				self.commentF.t:SetTextColor(0.5,0.5,0.5,1);
			else
				self.mudidi:SetTextColor(0,0.98,0.6, 1);
				self.commentF.t:SetTextColor(0.9,0.9,0.9,0.9);
			end
		end
		function hangL:Updata_LeaderChengke(searchResultInfo,inviteFunc,bestDisplayType)
			local resultID=self.resultID
			local leaderInfo = C_LFGList.GetSearchResultLeaderInfo(resultID);
			local nameColor = NORMAL_FONT_COLOR;
			if leaderInfo then
				if leaderInfo.classFilename then
					self.chetou.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[leaderInfo.classFilename]));
					nameColor = RAID_CLASS_COLORS[leaderInfo.classFilename];
				end
				self.chetou.Class:SetDesaturated(searchResultInfo.isDelisted);
				self.chetou.Favorite:SetDesaturated(searchResultInfo.isDelisted)
				self.chetou.new:SetDesaturated(searchResultInfo.isDelisted)
				self.chetou.Role:SetDesaturated(searchResultInfo.isDelisted)
				self.chetou.Role:SetAtlas(InvF.RolesNameIcon[leaderInfo.assignedRole])
				self.chetou.level:SetText(leaderInfo.level);
				if leaderInfo.level==GetMaxPlayerLevel() then
					self.chetou.level:Hide()
				else
					self.chetou.level:Show()
				end
			end
			self.chetou.Favorite:SetShown(PIGA["Tardis"]["Chedui"]["Favorite_Siji"][searchResultInfo.leaderName])
			self.chetou.new:SetShown(searchResultInfo.newPlayerFriendly)
			local allname=searchResultInfo.leaderName or UNKNOWNOBJECT
			self.allname=allname
			local wjName, fuwiqi = strsplit("-", allname);
			if fuwiqi then
				self.chetou.name:SetText(wjName.."(*)");
			else
				self.chetou.name:SetText(allname);
			end
			if not searchResultInfo.isDelisted then
				self.chetou.level:SetTextColor(1, 0.843, 0, 1);
				self.chetou.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b);	
			else
				self.chetou.level:SetTextColor(0.5,0.5,0.5,1);
				self.chetou.name:SetTextColor(0.5,0.5,0.5,1);
			end
			self:ShowMode_Restore()
			if not inviteFunc then
				local displayData = C_LFGList.GetSearchResultMemberCounts(resultID);
				if bestDisplayType==Enum.LFGListDisplayType.RoleEnumerate then
					self.RoleEnumerate:Restore_But(0.2)
					self.RoleEnumerate:Update_But(displayData,searchResultInfo.isDelisted)
				else
					self.RoleCount:Restore_But()
					self.RoleCount:Update_But(displayData,searchResultInfo.isDelisted)
				end
			end
		end
		function hangL:Updata_Caozuo(searchResultInfo,inviteFunc)
			self.caozuo.Apply:SetShown(false)
			self.caozuo.Whisper:SetShown(false)
			if not searchResultInfo.isDelisted then
				self.inviteFunc = inviteFunc;
				self.caozuo:Show()
				self.caozuo.Apply:Show()
				if inviteFunc then
					if TabF.IsInvitePlayer(self.resultID) then
						self.caozuo.Apply:SetBackdropColor(0.5, 0.5, 0.5,1)
						self.caozuo.Apply.Text:SetText(CALENDAR_STATUS_INVITED);
						self.caozuo.Whisper:SetBackdropColor(0.5, 0.5, 0.5,1)
					else
						self.caozuo.Apply:SetBackdropColor(0.22, 0.5, 0.08,1)
						self.caozuo.Apply.Text:SetText(INVITE);
						self.caozuo.Whisper:SetBackdropColor(0.545, 0.137, 0.137,0.8)
					end
				else
					if TabF.IsWhisperPlayer(self.resultID) then
						self.caozuo.Apply:SetBackdropColor(0.5, 0.5, 0.5,1)
						self.caozuo.Apply.Text:SetText("已"..SIGN_UP);
					else
						self.caozuo.Apply:SetBackdropColor(0.545, 0.137, 0.137,1)
						self.caozuo.Apply.Text:SetText(SIGN_UP);
					end
				end
			end
		end
	end
	--申请界面
	TabF.F.ApplyDialog=PIGFrame(TabF.F,{"TOPRIGHT",TabF.F,"TOPRIGHT",-100,-20},{320,250})
	TabF.F.ApplyDialog:PIGSetBackdrop(1)
	TabF.F.ApplyDialog:SetFrameLevel(TabF.F:GetFrameLevel()+6)
	TabF.F.ApplyDialog:Hide()
	TabF.F.ApplyDialog.biaoti=PIGFontString(TabF.F.ApplyDialog,{"TOP",TabF.F.ApplyDialog,"TOP",0,-4},LFG_LIST_CHOOSE_YOUR_ROLES)
	TabF.F.ApplyDialog.RoleF = addRoleSetBut(TabF.F.ApplyDialog,36,{"TOPLEFT",TabF.F.ApplyDialog,"TOPLEFT",28,-20},4)
	TabF.F.ApplyDialog.Description=PIGFrame(TabF.F.ApplyDialog,{"TOPLEFT", TabF.F.ApplyDialog, "TOPLEFT", 10,-80})
	TabF.F.ApplyDialog.Description:SetPoint("TOPRIGHT", TabF.F.ApplyDialog, "TOPRIGHT", -10,-80);
	TabF.F.ApplyDialog.Description:SetHeight(80);
	TabF.F.ApplyDialog.Description.E = CreateFrame("EditBox", nil, TabF.F.ApplyDialog.Description);
	TabF.F.ApplyDialog.Description.E:SetPoint("TOPLEFT", TabF.F.ApplyDialog.Description, "TOPLEFT", 4,-4);
	TabF.F.ApplyDialog.Description.E:SetPoint("BOTTOMRIGHT", TabF.F.ApplyDialog.Description, "BOTTOMRIGHT", -4,4);
	PIGSetFont(TabF.F.ApplyDialog.Description.E,14,"OUTLINE")
	TabF.F.ApplyDialog.Description.E:SetMaxLetters(100)
	TabF.F.ApplyDialog.Description.E:SetAutoFocus(false)
	TabF.F.ApplyDialog.Description.E:SetMultiLine(true)
	SetEditBoxBG(TabF.F.ApplyDialog.Description.E,TabF.F.ApplyDialog.Description)
	TabF.F.ApplyDialog.error = PIGFontString(TabF.F.ApplyDialog,{"TOP", TabF.F.ApplyDialog.Description, "BOTTOM", 0,-2},"", "OUTLINE");
	TabF.F.ApplyDialog.error:SetTextColor(1, 0, 0, 1)
	TabF.F.ApplyDialog.Remember = PIGCheckbutton(TabF.F.ApplyDialog,{"BOTTOM", TabF.F.ApplyDialog, "BOTTOM", -40, 50},{"记住本次设置"},{16,16})
	TabF.F.ApplyDialog.Remember:HookScript("OnClick", function(self)
		TabF.F.ApplyDialog.RememberSet=true
	end)
	TabF.F.ApplyDialog.Apply = PIGButton(TabF.F.ApplyDialog, {"BOTTOM", TabF.F.ApplyDialog, "BOTTOM", -60, 20},{60,22},SIGN_UP);
	TabF.F.ApplyDialog.Apply:HookScript("OnClick", function(self)
		local searchResultInfo=C_LFGList.GetSearchResultInfo(self:GetParent().resultID)
		if searchResultInfo then
			if not searchResultInfo.isDelisted then
				self.msgt="["..L["TARDIS_TABNAME"].."] "
				local allname=searchResultInfo.leaderName or UNKNOWNOBJECT
				if allname==UNKNOWNOBJECT then PIG_OptionsUI:ErrorMsg(UNKNOWNOBJECT, "R") return end
				local roles = C_LFGListRoles.GetSavedRoles();
				if roles.tank then self.msgt=self.msgt.._G[RolesName[1]] end
				if roles.healer then self.msgt=self.msgt.._G[RolesName[2]] end
				if roles.dps then self.msgt=self.msgt.._G[RolesName[3]] end
				local className = UnitClass("player")
				local level = UnitLevel("player") or 1
				self.msgt=self.msgt.."-"..string.format(CHALLENGE_MODE_POWER_LEVEL,level)..className.."-"..TabF.F.ApplyDialog.Description.E:GetText()
				SendChatMessage(self.msgt, "WHISPER", nil, allname);
				TabF.AddWhisperPlayer(self:GetParent().resultID)
				TabF.F.ApplyDialog:Hide()
				return
			end
			PIG_OptionsUI:ErrorMsg(CALENDAR_ERROR_EVENT_TIME_PASSED, "R")
		end
	end)
	TabF.F.ApplyDialog.Cancel = PIGButton(TabF.F.ApplyDialog, {"BOTTOM", TabF.F.ApplyDialog, "BOTTOM", 60, 20},{60,22},CANCEL);
	TabF.F.ApplyDialog.Cancel:HookScript("OnClick", function(self)
		TabF.F.ApplyDialog:Hide()
	end)
	function TabF.F.ApplyDialog:ListGroupButton_errorText()
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			return LFG_LIST_JOINED_GROUP_NOTICE;
		end
		if ( ( self.RoleF.T:IsShown() and self.RoleF.T.checkButton:GetChecked())
			or ( self.RoleF.H:IsShown() and self.RoleF.H.checkButton:GetChecked())
			or ( self.RoleF.D:IsShown() and self.RoleF.D.checkButton:GetChecked()) ) then
		else
			return ERR_LFG_NO_ROLES_SELECTED;
		end
	end
	function TabF.F.ApplyDialog:ListGroupButton_Update()
		if not self:IsVisible() then return end
		local errorText=self:ListGroupButton_errorText()
		self.error:SetText(errorText)
		self.Apply:SetEnabled(not errorText and not mythicPlusDisableActivity);
	end
	--申请模板
	TabF.F.ApplyDialog.Description.ApplyTemp=PIGDownMenu(TabF.F.ApplyDialog.Description,{"BOTTOMRIGHT", TabF.F.ApplyDialog.Description, "TOPRIGHT", 0, 2},{100,22})
	TabF.F.ApplyDialog.Description.ApplyTemp:PIGDownMenu_SetText(SIGN_UP.."模板")
	function TabF.F.ApplyDialog.Description.ApplyTemp:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for ixx=1,#PIGA["Tardis"]["Chedui"]["ApplyTemp"] do
			info.text, info.arg1 = PIGA["Tardis"]["Chedui"]["ApplyTemp"][ixx][1], PIGA["Tardis"]["Chedui"]["ApplyTemp"][ixx][2]
		    info.notCheckable = true;
		    self:PIGDownMenu_AddButton(info)
		end
	end
	function TabF.F.ApplyDialog.Description.ApplyTemp:PIGDownMenu_SetValue(value,arg1,arg2,checked,button)
		if button=="LeftButton" then
			TabF.F.ApplyDialog.Description.E:SetText(arg1)
		else
			for ixx=#PIGA["Tardis"]["Chedui"]["ApplyTemp"],1,-1 do
				if value == PIGA["Tardis"]["Chedui"]["ApplyTemp"][ixx][1] then
					table.remove(PIGA["Tardis"]["Chedui"]["ApplyTemp"],ixx)
					break
			   	end
			end
		end
		PIGCloseDropDownMenus()
	end
	TabF.F.ApplyDialog.Description.ApplyLog = PIGButton(TabF.F.ApplyDialog.Description,{"BOTTOMRIGHT", TabF.F.ApplyDialog.Description.ApplyTemp, "TOPRIGHT", 0, 2},{100,22},"保存为模板");
	TabF.F.ApplyDialog.Description.ApplyLog:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end)
	TabF.F.ApplyDialog.Description.ApplyLog.F = PIGFrame(TabF.F.ApplyDialog.Description.ApplyLog,{"TOP",TabF.F.ApplyDialog.Description,"TOP",0,10});
	TabF.F.ApplyDialog.Description.ApplyLog.F:SetSize(250,160)
	TabF.F.ApplyDialog.Description.ApplyLog.F:PIGSetBackdrop(1)
	TabF.F.ApplyDialog.Description.ApplyLog.F:SetFrameLevel(TabF.F.ApplyDialog.Description.ApplyLog.F:GetFrameLevel()+5)
	TabF.F.ApplyDialog.Description.ApplyLog.F:Hide()
	TabF.F.ApplyDialog.Description.ApplyLog.F.TT = PIGFontString(TabF.F.ApplyDialog.Description.ApplyLog.F,{"TOP", TabF.F.ApplyDialog.Description.ApplyLog.F, "TOP", 0,-6},"保存当前申请为模板", "OUTLINE");
	TabF.F.ApplyDialog.Description.ApplyLog.F.Name = PIGFontString(TabF.F.ApplyDialog.Description.ApplyLog.F,{"TOPLEFT", TabF.F.ApplyDialog.Description.ApplyLog.F, "TOPLEFT", 6,-50},"模版名:", "OUTLINE");
	TabF.F.ApplyDialog.Description.ApplyLog.F.E = CreateFrame("EditBox", nil, TabF.F.ApplyDialog.Description.ApplyLog.F, "InputBoxInstructionsTemplate");
	TabF.F.ApplyDialog.Description.ApplyLog.F.E:SetSize(180,20);
	TabF.F.ApplyDialog.Description.ApplyLog.F.E:SetMaxLetters(20)
	TabF.F.ApplyDialog.Description.ApplyLog.F.E:SetPoint("LEFT", TabF.F.ApplyDialog.Description.ApplyLog.F.Name, "RIGHT", 4,0);
	PIGSetFont(TabF.F.ApplyDialog.Description.ApplyLog.F.E,14,"OUTLINE")
	TabF.F.ApplyDialog.Description.ApplyLog.F.E:HookScript("OnShow", function()
		Create.Update_SaveTempF(TabF.F.ApplyDialog.Description.ApplyLog.F,TabF.F.ApplyDialog.Description.E:GetText():gsub(" ", ""))
	end)
	TabF.F.ApplyDialog.Description.ApplyLog.F.E:HookScript("OnTextChanged", function()
		Create.Update_SaveTempF(TabF.F.ApplyDialog.Description.ApplyLog.F,TabF.F.ApplyDialog.Description.E:GetText():gsub(" ", ""))
	end)
	TabF.F.ApplyDialog.Description.ApplyLog.F.error = PIGFontString(TabF.F.ApplyDialog.Description.ApplyLog.F,{"TOPLEFT", TabF.F.ApplyDialog.Description.ApplyLog.F.E, "BOTTOMLEFT", 6,-2},"", "OUTLINE");
	TabF.F.ApplyDialog.Description.ApplyLog.F.error:SetTextColor(1, 0, 0, 1)
	TabF.F.ApplyDialog.Description.ApplyLog.F.SaveBut=PIGButton(TabF.F.ApplyDialog.Description.ApplyLog.F,{"BOTTOM",TabF.F.ApplyDialog.Description.ApplyLog.F,"BOTTOM", -50,30},{50,24},"保存")
	TabF.F.ApplyDialog.Description.ApplyLog.F.SaveBut:SetScript("OnClick", function (self)
		for ixx=1,#PIGA["Tardis"]["Chedui"]["ApplyTemp"] do
			if PIGA["Tardis"]["Chedui"]["ApplyTemp"][ixx][1]==TabF.F.ApplyDialog.Description.ApplyLog.F.E:GetText() then
				PIGA["Tardis"]["Chedui"]["ApplyTemp"][ixx][2]=TabF.F.ApplyDialog.Description.E:GetText()
				TabF.F.ApplyDialog.Description.ApplyLog.F:Hide()
				return
			end
		end
		table.insert(PIGA["Tardis"]["Chedui"]["ApplyTemp"],{TabF.F.ApplyDialog.Description.ApplyLog.F.E:GetText(),TabF.F.ApplyDialog.Description.E:GetText()})
		TabF.F.ApplyDialog.Description.ApplyLog.F:Hide()
	end)
	TabF.F.ApplyDialog.Description.ApplyLog.F.OffBut=PIGButton(TabF.F.ApplyDialog.Description.ApplyLog.F,{"BOTTOM",TabF.F.ApplyDialog.Description.ApplyLog.F,"BOTTOM", 50,30},{50,24},CANCEL)
	TabF.F.ApplyDialog.Description.ApplyLog.F.OffBut:SetScript("OnClick", function (self)
		TabF.F.ApplyDialog.Description.ApplyLog.F:Hide()
	end)
	function TabF.F.ApplyDialog:Update_ApplyCreation()	
		local roles = C_LFGListRoles.GetSavedRoles();
		self.RoleF.T.CheckButton:SetChecked(roles.tank);
		self.RoleF.H.CheckButton:SetChecked(roles.healer);
		self.RoleF.D.CheckButton:SetChecked(roles.dps);
		if ( ( self.RoleF.T:IsShown() and self.RoleF.T.CheckButton:GetChecked())
			or ( self.RoleF.H:IsShown() and self.RoleF.H.CheckButton:GetChecked())
			or ( self.RoleF.D:IsShown() and self.RoleF.D.CheckButton:GetChecked()) ) then
			self.error:SetText("")
		else
			self.error:SetText(LFG_LIST_MUST_SELECT_ROLE)
		end
		self.Apply:SetEnabled(roles.tank or roles.healer or roles.dps)
	end
	function TabF.Update_ApplyDialog(resultID)
		TabF.F.ApplyDialog.resultID=resultID
		TabF.F.ApplyDialog:Show()
		TabF.F.ApplyDialog:Update_ApplyCreation()
	end
	---
	TabF.JieshouInfoList={}
	TabF.JieshouInfoList_Filte={}
	function TabF.Reset_HangALL()
		for i=1,#TabF.CheduiListBut do
			TabF.CheduiListBut[i]:Hide()
			TabF.CheduiListBut[i].resultID=nil
		end
	end
	TabF.Reset_HangALL()
	--过滤难度
	local function IsShowDifficulty(difficultyID)
		if TabF.selectDifficulty==0 then
			return true
		end
		if type(TabF.selectDifficulty)=="table" then
			for i=1,#TabF.selectDifficulty do
				if TabF.selectDifficulty==TabF.selectDifficulty[i] then
					return true
				end
			end
		else
			if TabF.selectDifficulty==difficultyID then
				return true
			end
		end
		return false
	end
	--过滤搜索字符
	local function IsShowSearchData(keyList,key)
		if not key or key == "" then
			return true
		end
		if keyList:match(key) then
			return true
		end
		return false
	end
	--过滤收藏司机
	local function IsShowFavorite(searchResultInfo)
		if TabF.selectFavorite==0 then
			if not PIGA["Tardis"]["Chedui"]["Ban_Siji"][searchResultInfo.leaderName] then
				return true
			end
		elseif TabF.selectFavorite==1 then
			if PIGA["Tardis"]["Chedui"]["Favorite_Siji"][searchResultInfo.leaderName] then
				return true
			end
		elseif TabF.selectFavorite==2 then
			if PIGA["Tardis"]["Chedui"]["Ban_Siji"][searchResultInfo.leaderName] then
				return true
			end
		end
		return false
	end
	--过滤队伍还是队员
	local function IsShowActType(searchResultInfo)
		if TabF.selectActType==0 then
			return true
		elseif TabF.selectActType==1 and searchResultInfo.numMembers>1 then
			return true
		elseif TabF.selectActType==2 and searchResultInfo.numMembers==1 then
			return true
		end
		return false
	end
	--3级过滤
	local function IsFilterData3(minlv,maxlv,newPlayerFriendly)
		if next(TabF.selectFilterData3) then
			for k,v in pairs(TabF.selectFilterData3) do
				if v then
					if k==90001 then
						local Level = UnitLevel("player");
						if Level<minlv or Level>maxlv then
							return false
						end
					elseif k==90002 then
						if not newPlayerFriendly then
							return false
						end
					end
				end
			end
			return true
		else
			return true
		end
	end
	local function IsShowFBData(activityID)
		if next(TabF.selectedFBData) then
			for k,v in pairs(TabF.selectedFBData) do
				if v and k==activityID then
					return true
				end
			end
			return false
		else
			return true
		end
	end
	function TabF.PIGGetSearchResults()
		TabF.Returned=true
		wipe(TabF.JieshouInfoList)
		C_Timer.After(1,function() TabF:DelayUpdateButEnable() end)
		local totalResultsFound, results = C_LFGList.GetSearchResults()
		for i=1,totalResultsFound do
			table.insert(TabF.JieshouInfoList,results[i])
		end
	end
	function TabF.FilteredSearchData()
		wipe(TabF.JieshouInfoList_Filte)
		local searchText = TabF.SearchBox:GetText()
		for i=1,#TabF.JieshouInfoList do
			local searchResultInfo=C_LFGList.GetSearchResultInfo(TabF.JieshouInfoList[i])
			if not searchResultInfo.isDelisted then
				for acid=1,#searchResultInfo.activityIDs do
					local activityID=searchResultInfo.activityIDs[acid]
					local ActivityInfo= C_LFGList.GetActivityInfoTable(activityID)
					local activityName = C_LFGList.GetActivityFullName(activityID, nil, searchResultInfo.isWarMode);
					if IsShowDifficulty(ActivityInfo.difficultyID or -1) and IsShowActType(searchResultInfo) and IsShowFavorite(searchResultInfo) and
						IsFilterData3(ActivityInfo.minLevelSuggestion,ActivityInfo.maxLevelSuggestion,searchResultInfo.newPlayerFriendly) and
						IsShowFBData(activityID) and IsShowSearchData(activityName or "",searchText) then
							table.insert(TabF.JieshouInfoList_Filte,TabF.JieshouInfoList[i])
							break
					end
				end
			end
		end
	end
	function TabF.GetHangBut(resultID)
		for But = 1, hang_NUM do
			if TabF.CheduiListBut[But].resultID==resultID then
				return TabF.Update_Hang(TabF.CheduiListBut[But])
			end
		end
	end
	function TabF.Update_Hang(hangL)
		local searchResultInfo=C_LFGList.GetSearchResultInfo(hangL.resultID)
		hangL.resultIDT:SetText(hangL.resultID);
		if searchResultInfo then
			local bestDisplayType, maxNumPlayers=LFGBrowseUtil_GetBestDisplayTypeForActivityIDs(searchResultInfo.activityIDs)
			local inviteText, inviteFunc = LFGBrowseUtil_GetInviteActionForResult(hangL.resultID)
			hangL:Updata_MudidiLvCom(searchResultInfo,inviteFunc,bestDisplayType)
			hangL:Updata_LeaderChengke(searchResultInfo,inviteFunc,bestDisplayType)
			hangL:Updata_Caozuo(searchResultInfo,inviteFunc,bestDisplayType)
		end
	end
	function TabF.Update_HangALL(self,Filtered)
		if not TabF:IsVisible() then return end
		TabF.Reset_HangALL()
		TabF.IsSearchFilter()
		if Filtered then TabF.FilteredSearchData() end
		local TotalNum=#TabF.JieshouInfoList_Filte
		local ScrollUI = self or TabF.F.Scroll
		FauxScrollFrame_Update(ScrollUI, TotalNum, hang_NUM, hang_Height);
    	local offset = FauxScrollFrame_GetOffset(ScrollUI);
    	for But = 1, hang_NUM do
			local dangqian = But+offset;
			if TabF.JieshouInfoList_Filte[dangqian] then
				TabF.CheduiListBut[But]:Show()
				TabF.CheduiListBut[But].resultID=TabF.JieshouInfoList_Filte[dangqian]
				TabF.Update_Hang(TabF.CheduiListBut[But])
			end
		end
	end
	TabF:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");--搜索结束
	TabF:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED");--条目已经更新
	TabF:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED");--申请后事件结果
	TabF:HookScript("OnEvent", function(self,event,searchResultID, newStatus, oldStatus, groupName,arg5)
		if self:IsShown() then
			if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
				self.PIGGetSearchResults()
				self.Update_HangALL(nil,true)
			elseif event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
				self.GetHangBut(searchResultID)
			elseif event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
				self.GetHangBut(searchResultID)
			end
		end
	end);
end