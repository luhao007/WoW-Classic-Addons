local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.LFGCreation(FCTabF,EnterF)
	local Create, Data, Fun, L= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGButton = Create.PIGButton
	local PIGDownMenu=Create.PIGDownMenu
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local PIGDiyBut=Create.PIGDiyBut
	local FasongYCqingqiu=Fun.FasongYCqingqiu
	local PIG_GetCategories=Fun.PIG_GetCategories
	---------------
	local gsub = _G.string.gsub
	local TalentData=Data.TalentData
	local GetTianfuIcon_YC=TalentData.GetTianfuIcon_YC
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local RolesName=InvF.RolesName
	local UpdatehangEnter=InvF.UpdatehangEnter
	----
	FCTabF:HookScript("OnShow", function (self)
		self:UpdateEditMode()
	end);

	--创建车队
	FCTabF.ADD.Category_T=PIGFontString(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",20,-20},LFG_LIST_SELECT..CALENDAR_CREATE_EVENT..TYPE)
	FCTabF.ADD.CategorieButList={}
	function FCTabF.ADD:CategorieIsChecked(BOT)
		for i=1,#self.CategorieButList do
			self.CategorieButList[i]:SetChecked(BOT)
		end
	end
	function FCTabF.ADD:CategorieIsEnabled(BOT)
		for i=1,#self.CategorieButList do
			self.CategorieButList[i]:SetEnabled(BOT)
		end
	end
	function FCTabF.ADD:CategorieSetChecked(selectedCategory)
		for i=1,#self.CategorieButList do
			if selectedCategory==self.CategorieButList[i]:GetID() then
				self.CategorieButList[i]:SetChecked(true)
				return
			end
		end
	end
	FCTabF.ADD:HookScript("OnShow", function (self)
		if not self.tabList then
			self.tabList=PIG_GetCategories()
		end
		for i=1,#self.tabList do
			if not self.CategorieButList[i] then
				self.CategorieButList[i] = PIGCheckbutton(self)
				if i==1 then
					self.CategorieButList[i]:SetPoint("TOPLEFT",self,"TOPLEFT",20,-40)
				elseif i==5 then
					self.CategorieButList[i]:SetPoint("TOPLEFT",self.CategorieButList[1],"TOPLEFT",0,-30)
				else
					self.CategorieButList[i]:SetPoint("LEFT",self.CategorieButList[i-1].Text,"RIGHT",8,0)
				end
				self.CategorieButList[i]:HookScript("OnClick", function (self)
					FCTabF.ADD:Clear_Activity()
					self:SetChecked(true)
					FCTabF.selectedCategory=self:GetID()
					FCTabF.ADD:Update_Activity()
				end)
			end
			self.CategorieButList[i]:Show()
			self.CategorieButList[i].Text:SetText(FCTabF.tabList[i][2])
			self.CategorieButList[i]:SetID(FCTabF.tabList[i][1])
			self.CategorieButList[i]:UpdateHitRectInsets()
		end
	end);

	FCTabF.ADD.GroupDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.Category_T,"TOPLEFT",0,-106},{FCTabF.ADD.Width,nil})
	FCTabF.ADD.GroupDropDown:Hide()
	FCTabF.ADD.GroupDropDown.t=PIGFontString(FCTabF.ADD.GroupDropDown,{"BOTTOMLEFT",FCTabF.ADD.GroupDropDown,"TOPLEFT",0,4},"目的地")
	function FCTabF.ADD.GroupDropDown:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local GroupList,GroupData=Fun.PIG_GetGroups(FCTabF.selectedCategory)
		for ixx=1,#GroupList do
			info.text= GroupList[ixx][2]
			info.arg1=GroupList[ixx][1]
			info.checked = GroupList[ixx][1] == FCTabF.selectedGroup
			self:PIGDownMenu_AddButton(info)
		end
	end
	function FCTabF.ADD.GroupDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		FCTabF.selectedGroup=arg1
		FCTabF.selectedActivity=nil
		FCTabF.ADD:Update_Activity()
		PIGCloseDropDownMenus()
	end
	--
	FCTabF.ADD.ActivityDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.GroupDropDown,"BOTTOMLEFT",0,-8},{FCTabF.ADD.Width,nil})
	FCTabF.ADD.ActivityDropDown:Hide()
	function FCTabF.ADD.ActivityDropDown:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		if FCTabF.selectedGroup then
			local Activities = self.downData[FCTabF.selectedGroup]
			for acid=1, #Activities do
				info.text= Activities[acid][2]
				info.arg1= Activities[acid][1]
				info.checked = Activities[acid][1] == FCTabF.selectedActivity
				self:PIGDownMenu_AddButton(info, level,acid==#Activities)
			end
		else
			local Activities = self.downData
			for acid=1, #Activities do
				info.text= Activities[acid][2]
				info.arg1= Activities[acid][1]
				info.checked = Activities[acid][1] == FCTabF.selectedActivity
				self:PIGDownMenu_AddButton(info, level, acid==#Activities)
			end
		end
	end
	function FCTabF.ADD.ActivityDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		FCTabF.selectedActivity=arg1
		FCTabF.ADD:Update_Activity()
		PIGCloseDropDownMenus()
	end
	---
	local PlaystyleList={Enum.LFGEntryPlaystyle.Standard,Enum.LFGEntryPlaystyle.Casual, Enum.LFGEntryPlaystyle.Hardcore}
	FCTabF.ADD.PlayStyleDropdown =PIGDownMenu(FCTabF.ADD,{"TOPRIGHT",FCTabF.ADD.ActivityDropDown,"BOTTOMRIGHT",0,-8},{FCTabF.ADD.Width-66,nil})
	FCTabF.ADD.PlayStyleDropdown:Hide()
	FCTabF.ADD.PlayStyleLabel=PIGFontString(FCTabF.ADD,{"RIGHT",FCTabF.ADD.PlayStyleDropdown,"LEFT",-4,0})
	function FCTabF.ADD.PlayStyleDropdown:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local activityInfo = C_LFGList.GetActivityInfoTable(FCTabF.selectedActivity);
		for acid=1, #PlaystyleList do
			local text = C_LFGList.GetPlaystyleString(PlaystyleList[acid], activityInfo);
			info.text= text
			info.arg1= PlaystyleList[acid]
			info.checked = PlaystyleList[acid] == FCTabF.selectedPlaystyle
			self:PIGDownMenu_AddButton(info)
		end
	end
	function FCTabF.ADD.PlayStyleDropdown:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		FCTabF.selectedPlaystyle=arg1
		FCTabF.ADD:Update_Activity()
		PIGCloseDropDownMenus()
	end
	----
	local function SetEditBoxBG(eui,bgui)
		local BGx = eui.BG or bgui
		BGx:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
		eui:HookScript("OnEditFocusLost", function(self)
			BGx:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
		end)
		eui:HookScript("OnEditFocusGained", function(self)
			BGx:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
		end);
		eui:SetScript("OnEscapePressed", function(self) 
			self:ClearFocus()
		end);
		eui:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
		end);
	end
	FCTabF.ADD.ItemLevel=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.ActivityDropDown,"BOTTOMLEFT",0,-40},{FCTabF.ADD.Width,24})
	FCTabF.ADD.ItemLevel:Hide()
	FCTabF.ADD.ItemLevel.CheckButton = PIGCheckbutton(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel,"LEFT",0,0},{LFG_LIST_ITEM_LEVEL_REQ})
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
	FCTabF.ADD.ItemLevel.EditBox.BG:SetFrameLevel(FCTabF.ADD.ItemLevel.EditBox:GetFrameLevel()-1)
	SetEditBoxBG(FCTabF.ADD.ItemLevel.EditBox)
	FCTabF.ADD.ItemLevel.EditBox:SetScript("OnTextChanged", function(self)
		FCTabF.ADD:ListGroupButton_Update()
	end);
	FCTabF.ADD.ItemLevel.maxlvt=PIGFontString(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel.EditBox,"RIGHT",10,0},"当前")
	FCTabF.ADD.ItemLevel.maxlv=PIGFontString(FCTabF.ADD.ItemLevel,{"LEFT",FCTabF.ADD.ItemLevel.maxlvt,"RIGHT",0,0})

	--PVP相关
	FCTabF.ADD.PvpItemLevel=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.ActivityDropDown,"BOTTOMLEFT",0,-40},{FCTabF.ADD.Width,24})
	FCTabF.ADD.PvpItemLevel:Hide()
	FCTabF.ADD.PvpItemLevel.CheckButton = PIGCheckbutton(FCTabF.ADD.PvpItemLevel,{"LEFT",FCTabF.ADD.PvpItemLevel,"LEFT",0,0},{LFG_LIST_ITEM_LEVEL_PVP})
	FCTabF.ADD.PvpItemLevel.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.PvpItemLevel);
	FCTabF.ADD.PvpItemLevel.EditBox:SetPoint("LEFT", FCTabF.ADD.PvpItemLevel.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.PvpItemLevel.EditBox:SetPoint("RIGHT", FCTabF.ADD.PvpItemLevel, "RIGHT", -90,0);
	FCTabF.ADD.PvpItemLevel.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.PvpItemLevel.EditBox,14,"OUTLINE")
	FCTabF.ADD.PvpItemLevel.EditBox:SetMaxLetters(6)
	FCTabF.ADD.PvpItemLevel.EditBox:SetNumeric(true)
	FCTabF.ADD.PvpItemLevel.EditBox:SetAutoFocus(false)
	FCTabF.ADD.PvpItemLevel.EditBox.BG=PIGFrame(FCTabF.ADD.PvpItemLevel.EditBox,{"TOPLEFT", FCTabF.ADD.PvpItemLevel.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.PvpItemLevel.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.PvpItemLevel.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.PvpItemLevel.EditBox.BG:SetFrameLevel(FCTabF.ADD.PvpItemLevel.EditBox:GetFrameLevel()-1)
	SetEditBoxBG(FCTabF.ADD.PvpItemLevel.EditBox)
	FCTabF.ADD.PvpItemLevel.EditBox:SetScript("OnTextChanged", function(self)
		FCTabF.ADD:ListGroupButton_Update()
	end);
	FCTabF.ADD.PvpItemLevel.maxlvt=PIGFontString(FCTabF.ADD.PvpItemLevel,{"LEFT",FCTabF.ADD.PvpItemLevel.EditBox,"RIGHT",10,0},"当前")
	FCTabF.ADD.PvpItemLevel.maxlv=PIGFontString(FCTabF.ADD.PvpItemLevel,{"LEFT",FCTabF.ADD.PvpItemLevel.maxlvt,"RIGHT",0,0})

	FCTabF.ADD.PVPRating=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.PvpItemLevel,"BOTTOMLEFT",0,-10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.PVPRating:Hide()
	FCTabF.ADD.PVPRating.CheckButton = PIGCheckbutton(FCTabF.ADD.PVPRating,{"LEFT",FCTabF.ADD.PVPRating,"LEFT",0,0},{GROUP_FINDER_PVP_RATING_REQ_LABEL})
	FCTabF.ADD.PVPRating.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.PVPRating);
	FCTabF.ADD.PVPRating.EditBox:SetPoint("LEFT", FCTabF.ADD.PVPRating.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.PVPRating.EditBox:SetPoint("RIGHT", FCTabF.ADD.PVPRating, "RIGHT", -10,0);
	FCTabF.ADD.PVPRating.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.PVPRating.EditBox,14,"OUTLINE")
	FCTabF.ADD.PVPRating.EditBox:SetAutoFocus(false)
	FCTabF.ADD.PVPRating.EditBox.BG=PIGFrame(FCTabF.ADD.PVPRating.EditBox,{"TOPLEFT", FCTabF.ADD.PVPRating.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.PVPRating.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.PVPRating.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.PVPRating.EditBox.BG:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
	FCTabF.ADD.PVPRating.EditBox.BG:SetFrameLevel(FCTabF.ADD.PVPRating.EditBox:GetFrameLevel()-1)
	SetEditBoxBG(FCTabF.ADD.PVPRating.EditBox)
	FCTabF.ADD.PVPRating.EditBox:SetScript("OnTextChanged", function(self)
		FCTabF.ADD:ListGroupButton_Update()
	end);
	
	--史诗钥石
	FCTabF.ADD.MythicPlusRating=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.PvpItemLevel,"BOTTOMLEFT",0,-10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.MythicPlusRating:Hide()
	FCTabF.ADD.MythicPlusRating.CheckButton = PIGCheckbutton(FCTabF.ADD.MythicPlusRating,{"LEFT",FCTabF.ADD.MythicPlusRating,"LEFT",0,0},{GROUP_FINDER_MYTHIC_RATING_REQ_LABEL})
	FCTabF.ADD.MythicPlusRating.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.MythicPlusRating);
	FCTabF.ADD.MythicPlusRating.EditBox:SetPoint("LEFT", FCTabF.ADD.MythicPlusRating.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.MythicPlusRating.EditBox:SetPoint("RIGHT", FCTabF.ADD.MythicPlusRating, "RIGHT", -90,0);
	FCTabF.ADD.MythicPlusRating.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.MythicPlusRating.EditBox,14,"OUTLINE")
	FCTabF.ADD.MythicPlusRating.EditBox:SetMaxLetters(6)
	FCTabF.ADD.MythicPlusRating.EditBox:SetNumeric(true)
	FCTabF.ADD.MythicPlusRating.EditBox:SetAutoFocus(false)
	FCTabF.ADD.MythicPlusRating.EditBox.BG=PIGFrame(FCTabF.ADD.MythicPlusRating.EditBox,{"TOPLEFT", FCTabF.ADD.MythicPlusRating.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.MythicPlusRating.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.MythicPlusRating.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.MythicPlusRating.EditBox.BG:SetFrameLevel(FCTabF.ADD.MythicPlusRating.EditBox:GetFrameLevel()-1)
	SetEditBoxBG(FCTabF.ADD.MythicPlusRating.EditBox)
	FCTabF.ADD.MythicPlusRating.EditBox:SetScript("OnTextChanged", function(self)
		FCTabF.ADD:ListGroupButton_Update()
	end);
	---
	FCTabF.ADD.CrossFactionGroup=PIGFrame(FCTabF.ADD,{"BOTTOMLEFT",FCTabF.ADD,"BOTTOMLEFT",20,60},{FCTabF.ADD.Width*0.5,24})
	FCTabF.ADD.CrossFactionGroup:Hide()
	local _, localizedFaction = UnitFactionGroup("player");
	FCTabF.ADD.CrossFactionGroup.CheckButton = PIGCheckbutton(FCTabF.ADD.CrossFactionGroup,{"LEFT",FCTabF.ADD.CrossFactionGroup,"LEFT",0,0},{LFG_LIST_CROSS_FACTION:format(localizedFaction),LFG_LIST_CROSS_FACTION_TOOLTIP:format(localizedFaction)})
	
	FCTabF.ADD.PrivateGroup=PIGFrame(FCTabF.ADD,{"LEFT",FCTabF.ADD.CrossFactionGroup,"RIGHT",10,0},{FCTabF.ADD.Width*0.5,24})
	FCTabF.ADD.PrivateGroup:Hide()
	FCTabF.ADD.PrivateGroup.CheckButton = PIGCheckbutton(FCTabF.ADD.PrivateGroup,{"LEFT",FCTabF.ADD.PrivateGroup,"LEFT",0,0},{"仅对公会/好友可见",LFG_LIST_PRIVATE_TOOLTIP})

	FCTabF.ADD.VoiceChat=PIGFrame(FCTabF.ADD,{"BOTTOMLEFT",FCTabF.ADD.CrossFactionGroup,"TOPLEFT",0,10},{FCTabF.ADD.Width,24})
	FCTabF.ADD.VoiceChat:Hide()
	FCTabF.ADD.VoiceChat.CheckButton = PIGCheckbutton(FCTabF.ADD.VoiceChat,{"LEFT",FCTabF.ADD.VoiceChat,"LEFT",0,0},{LFG_LIST_VOICE_CHAT,LFG_LIST_VOICE_CHAT_INSTR})
	FCTabF.ADD.VoiceChat.CheckButton:Disable()
	FCTabF.ADD.VoiceChat.EditBox = CreateFrame("EditBox", nil, FCTabF.ADD.VoiceChat);
	FCTabF.ADD.VoiceChat.EditBox:SetPoint("LEFT", FCTabF.ADD.VoiceChat.CheckButton.Text, "RIGHT", 6,0);
	FCTabF.ADD.VoiceChat.EditBox:SetPoint("RIGHT", FCTabF.ADD.VoiceChat, "RIGHT", -10,0);
	FCTabF.ADD.VoiceChat.EditBox:SetHeight(20);
	PIGSetFont(FCTabF.ADD.VoiceChat.EditBox,14,"OUTLINE")
	FCTabF.ADD.VoiceChat.EditBox:SetAutoFocus(false)
	FCTabF.ADD.VoiceChat.EditBox.BG=PIGFrame(FCTabF.ADD.VoiceChat.EditBox,{"TOPLEFT", FCTabF.ADD.VoiceChat.EditBox, "TOPLEFT", -4,0})
	FCTabF.ADD.VoiceChat.EditBox.BG:SetPoint("BOTTOMRIGHT", FCTabF.ADD.VoiceChat.EditBox, "BOTTOMRIGHT", 4,0);
	FCTabF.ADD.VoiceChat.EditBox.BG:PIGSetBackdrop(0,0.8,nil,{0.5, 0.5, 0.5})
	FCTabF.ADD.VoiceChat.EditBox.BG:SetFrameLevel(FCTabF.ADD.VoiceChat.EditBox:GetFrameLevel()-1)
	SetEditBoxBG(FCTabF.ADD.VoiceChat.EditBox)

	--职责
	FCTabF.ADD.Role = InvF.addRoleSetBut(FCTabF.ADD,40,{"BOTTOMLEFT",FCTabF.ADD,"BOTTOMLEFT",50,10},3)
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
	--标题
	local NameBox = LFGListFrame.EntryCreation.Name
	NameBox:SetMultiLine(true)
	NameBox.Left:Hide()
    NameBox.Middle:Hide()
    NameBox.Right:Hide()
    NameBox:SetScript('OnTextChanged', function(self)
        InputBoxInstructions_OnTextChanged(self)
        FCTabF.ADD:ListGroupButton_Update()
    end)
	FCTabF.ADD.NameF=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",FCTabF.ADD.Width+100,-40},{400,40})
	FCTabF.ADD.NameF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	FCTabF.ADD.NameF:Hide()
	FCTabF.ADD.NameF.Label=PIGFontString(FCTabF.ADD.NameF,{"BOTTOMLEFT",FCTabF.ADD.NameF,"TOPLEFT",0,2},"标题")
	FCTabF.ADD.NameF:SetObject(NameBox, {4, -4, -4, 4})
   	FCTabF.ADD.Name=NameBox
   	SetEditBoxBG(NameBox,FCTabF.ADD.NameF)

    FCTabF.ADD.DescriptionF=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.NameF,"BOTTOMLEFT",0,-60},{400,180})
	FCTabF.ADD.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	FCTabF.ADD.DescriptionF:Hide()
	local DescriptionBox = LFGListFrame.EntryCreation.Description
	FCTabF.ADD.DescriptionF:SetObject(DescriptionBox, {4, -4, -4, 4})
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
	FCTabF.ADD.DescriptionF.t=PIGFontString(FCTabF.ADD.DescriptionF,{"BOTTOMLEFT",FCTabF.ADD.DescriptionF,"TOPLEFT",0,2},LFG_LIST_DETAILS)
	SetEditBoxBG(DescriptionBox.EditBox,FCTabF.ADD.DescriptionF)
	--
	FCTabF.ADD.WorkingCover=PIGFrame(FCTabF.ADD)
	FCTabF.ADD.WorkingCover:PIGSetBackdrop(1)
	FCTabF.ADD.WorkingCover:SetAllPoints(FCTabF.ADD)
	FCTabF.ADD.WorkingCover:SetFrameLevel(FCTabF.ADD:GetFrameLevel()+10)
	FCTabF.ADD.WorkingCover:Hide()
	FCTabF.ADD.WorkingCover.error=PIGFontString(FCTabF.ADD.WorkingCover,{"CENTER",FCTabF.ADD.WorkingCover,"CENTER",0,0},LFG_LIST_CREATING_ENTRY)
    --
	FCTabF.ADD.ListGroupButton=PIGButton(FCTabF.ADD,{"BOTTOMLEFT",FCTabF.ADD,"BOTTOMLEFT",FCTabF.ADD.Width+100,40},{100,30})
    FCTabF.ADD.ListGroupButton:Hide()
    FCTabF.ADD.ListGroupButton.error=PIGFontString(FCTabF.ADD.ListGroupButton,{"BOTTOMLEFT",FCTabF.ADD.ListGroupButton,"TOPLEFT",0,4})
	FCTabF.ADD.ListGroupButton.error:SetTextColor(1,0,0,1);
	FCTabF.ADD.ListGroupButton:SetScript("OnClick", function (self)
		FCTabF.ADD:LFGListEntryCreation_ListGroup()
	end);
	FCTabF.ADD.RemoveBut=PIGButton(FCTabF.ADD,{"LEFT",FCTabF.ADD.ListGroupButton,"RIGHT",80,0},{100,30},PET_DISMISS.."车队")
	FCTabF.ADD.RemoveBut:Hide()
	FCTabF.ADD.RemoveBut:HookScript("OnClick", function (self)
		C_LFGList.RemoveListing()
	end);
	local function IsEditBoxLVOK(eui,myItemLevel,selectedActivity)
		local eItemLevel = eui.EditBox:GetNumber();
		if myItemLevel=="Mythic" then
			if C_LFGList.ValidateRequiredDungeonScore(eItemLevel) then
				if eItemLevel>0 then
					eui.CheckButton:SetChecked(true)
				else
					eui.CheckButton:SetChecked(false)
				end
			else
				eui.CheckButton:SetChecked(false)
				return true
			end
		elseif myItemLevel=="Rating" then
			if C_LFGList.ValidateRequiredPvpRatingForActivity(selectedActivity, eItemLevel) then
				if eItemLevel>0 then
					eui.CheckButton:SetChecked(true)
				else
					eui.CheckButton:SetChecked(false)
				end
			else
				eui.CheckButton:SetChecked(false)
				return true
			end
		else
			if eItemLevel>myItemLevel or Mythic then
				eui.CheckButton:SetChecked(false)
				return true
			else
				if eItemLevel>0 then
					eui.CheckButton:SetChecked(true)
				else
					eui.CheckButton:SetChecked(false)
				end
			end
		end
	end
	function FCTabF.ADD:ListGroupButton_Update()
		if not self:IsVisible() then return end
		local isPartyLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME);
		if ( IsInGroup(LE_PARTY_CATEGORY_HOME) and not isPartyLeader ) then
			self.ListGroupButton:SetEnabled(false);
			self.ListGroupButton.error:SetText(LFG_LIST_NOT_LEADER)
		else
			local myItemLevel,_, avgItemLevelPvP = GetAverageItemLevel();
			self.ItemLevel.maxlv:SetText(floor(myItemLevel*100+5)*0.01)
			self.PvpItemLevel.maxlv:SetText(floor(avgItemLevelPvP*100+5)*0.01)

			local errorText;
			if PIG_MaxTocversion(50000) then--正式服根据天赋自动检测
				if ( ( self.Role.T:IsShown() and self.Role.T.checkButton:GetChecked())
					or ( self.Role.H:IsShown() and self.Role.H.checkButton:GetChecked())
					or ( self.Role.D:IsShown() and self.Role.D.checkButton:GetChecked()) ) then
					self.Role.warningText = nil;
				else
					self.Role.warningText = LFG_LIST_MUST_SELECT_ROLE;
				end
			else
				self.Role:Hide()
			end
			local activityInfo = C_LFGList.GetActivityInfoTable(FCTabF.selectedActivity)
			local maxNumPlayers = activityInfo and  activityInfo.maxNumPlayers or 0;
			local mythicPlusDisableActivity = not C_LFGList.IsPlayerAuthenticatedForLFG(activityInfo.categoryID) and (activityInfo.isMythicPlusActivity and not C_LFGList.GetKeystoneForActivity(FCTabF.selectedActivity));
			if ( maxNumPlayers > 0 and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) >= maxNumPlayers ) then
				errorText = string.format(LFG_LIST_TOO_MANY_FOR_ACTIVITY, maxNumPlayers);
			elseif (mythicPlusDisableActivity) then
				errorText = LFG_AUTHENTICATOR_BUTTON_MYTHIC_PLUS_TOOLTIP;
			elseif ( LFGListEntryCreation_GetSanitizedName(self) == "" ) then
				errorText = LFG_LIST_MUST_HAVE_NAME;
			elseif self.ItemLevel:IsShown() and IsEditBoxLVOK(self.ItemLevel,myItemLevel) then
				errorText = LFG_LIST_ILVL_ABOVE_YOURS
			elseif self.PvpItemLevel:IsShown() and IsEditBoxLVOK(self.PvpItemLevel,avgItemLevelPvP) then
				errorText = LFG_LIST_PVP_RATING_ABOVE_YOURS
			elseif self.MythicPlusRating:IsShown() and IsEditBoxLVOK(self.MythicPlusRating,"Mythic") then
				errorText =  LFG_LIST_DUNGEON_SCORE_ABOVE_YOURS
			elseif self.PVPRating:IsShown() and IsEditBoxLVOK(self.PVPRating,"Rating",FCTabF.selectedActivity) then
				errorText = LFG_LIST_PVP_RATING_ABOVE_YOURS;
			elseif self.Role.warningText then
				errorText=self.Role.warningText
			else
				errorText = LFGListUtil_GetActiveQueueMessage(false);
			end
			self.ListGroupButton:SetEnabled(not errorText and not mythicPlusDisableActivity);

			if activityInfo.isMythicPlusActivity and C_InstanceLeaver.IsPlayerLeaver() then
				if not errorText then
					errorText = RED_FONT_COLOR:WrapTextInColorCode(MYTHIC_PLUS_DESERTER_FLAGGED_SHORT);
				else
					errorText = errorText.."|n|n"..RED_FONT_COLOR:WrapTextInColorCode(MYTHIC_PLUS_DESERTER_FLAGGED_SHORT);
				end
			end
			self.ListGroupButton.error:SetText(errorText)
		end
	end
	local function _LFGListEntryCreation_ListGroupInternal(self, activityID, itemLevel, autoAccept, privateGroup, questID, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction)
		--print(activityID, itemLevel, autoAccept, privateGroup, questID, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction)
		local createData = {
			activityIDs = { activityID },
			questID = questID,
			isAutoAccept = autoAccept,
			isCrossFactionListing = isCrossFaction,
			isPrivateGroup = privateGroup,
			playstyle = selectedPlaystyle,
			requiredDungeonScore = mythicPlusRating,
			requiredItemLevel = itemLevel,
			requiredPvpRating = pvpRating,
		};
		
		if FCTabF.EditMode then
			FCTabF.EditMode=nil
			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			createData.isAutoAccept = activeEntryInfo.autoAccept;
			createData.questID = activeEntryInfo.questID;
			if activeEntryInfo.isCrossFactionListing == isCrossFaction then
				C_LFGList.UpdateListing(createData);
			else
				C_LFGList.RemoveListing();
				C_LFGList.CreateListing(createData);
			end
		else
			if(C_LFGList.CreateListing(createData)) then
				self.WorkingCover:Show();
			end
		end
	end
	function FCTabF.ADD:LFGListEntryCreation_ListGroup()
		local itemLevel;
		if(self.ItemLevel:IsShown()) then
			itemLevel = tonumber(self.ItemLevel.EditBox:GetText()) or 0;
		else
			itemLevel = tonumber(self.PvpItemLevel.EditBox:GetText()) or 0;
		end
		local pvpRating =  tonumber(self.PVPRating.EditBox:GetText()) or 0;
		local mythicPlusRating =  tonumber(self.MythicPlusRating.EditBox:GetText()) or 0;
		local autoAccept = false;
		local privateGroup = self.PrivateGroup.CheckButton:GetChecked();
		local isCrossFaction =  self.CrossFactionGroup:IsShown() and not self.CrossFactionGroup.CheckButton:GetChecked();
		local selectedPlaystyle = self.PlayStyleDropdown:IsShown() and FCTabF.selectedPlaystyle or nil;
		_LFGListEntryCreation_ListGroupInternal(self, FCTabF.selectedActivity, itemLevel, autoAccept, privateGroup, 0, mythicPlusRating, pvpRating, selectedPlaystyle, isCrossFaction);
	end
	function FCTabF.ADD:Update_ShownBut(bot,editMode)
		self.NameF:SetShown(bot)
		self.DescriptionF:SetShown(bot)
		self.VoiceChat:SetShown(bot)
		self.PrivateGroup:SetShown(bot)
		self.Role:SetShown(bot and PIG_MaxTocversion(50000))
		self.ListGroupButton:SetShown(bot)
		self.RemoveBut:SetShown(editMode)
	end
	function FCTabF.ADD:Clear_Activity()
		--C_LFGList.ClearCreationTextFields();
		FCTabF.editMode = nil
		FCTabF.selectedCategory = nil;
		FCTabF.selectedGroup = nil;
		FCTabF.selectedActivity = nil;
		self:CategorieIsChecked(false)
		self:CategorieIsEnabled(true)
		self.ItemLevel.CheckButton:SetChecked(false);
		self.PrivateGroup.CheckButton:SetChecked(false);
		self.CrossFactionGroup.CheckButton:SetChecked(false);
		self.ItemLevel.EditBox:SetText("");
		self.GroupDropDown:PIGDownMenu_SetText("")
		self.ActivityDropDown:PIGDownMenu_SetText("")
		self.ListGroupButton.error:SetText("");
		self:Update_ShownBut(false)
	end
	function FCTabF.ADD:Update_Activity()
		self:Show()
		if FCTabF.EditMode and C_LFGList.HasActiveEntryInfo() then
			self:Update_ShownBut(true,FCTabF.EditMode)
			self:CategorieIsEnabled(false)
			self.GroupDropDown:Disable()
			self.ActivityDropDown:Disable()
			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			local activityID=activeEntryInfo.activityIDs[1]
			FCTabF.selectedActivity=activityID
			local activityInfo = C_LFGList.GetActivityInfoTable(activityID);	
			FCTabF.selectedCategory=activityInfo.categoryID
			self:CategorieSetChecked(FCTabF.selectedCategory)
			self.ActivityDropDown:PIGDownMenu_SetText(activityInfo.fullName)
			local GroupList,GroupData=Fun.PIG_GetGroups(FCTabF.selectedCategory)
			if #GroupList>0 then
				self.GroupDropDown:PIGDownMenu_SetText(Fun.GetGroupName(FCTabF.selectedGroup,GroupList))
			else
				self.GroupDropDown:Hide()
			end
			self.ItemLevel.EditBox:SetText(activeEntryInfo.requiredItemLevel)
			self.PrivateGroup.CheckButton:SetChecked(activeEntryInfo.privateGroup);
			self.CrossFactionGroup.CheckButton:SetChecked(activeEntryInfo.allowCrossFaction)
			self.ListGroupButton:SetText("更新车队")
			self.RemoveBut:Show()
		else
			if FCTabF.selectedCategory then
				self:Update_ShownBut(true)
				self:CategorieIsEnabled(true)
				self.GroupDropDown:Enable()
				self.ActivityDropDown:Enable()
				self.ListGroupButton:SetText("创建车队")
				local GroupList,GroupData=Fun.PIG_GetGroups(FCTabF.selectedCategory)
				self.ActivityDropDown.downData= GroupData
				if #GroupList>0 then
					self.GroupDropDown:Show()
					self.ActivityDropDown:Show()
					FCTabF.selectedGroup=FCTabF.selectedGroup or GroupList[1][1]
					self.GroupDropDown:PIGDownMenu_SetText(Fun.GetGroupName(FCTabF.selectedGroup,GroupList))
					local activities=GroupData[FCTabF.selectedGroup]
					FCTabF.selectedActivity=FCTabF.selectedActivity or activities[1][1]
					self.ActivityDropDown:PIGDownMenu_SetText(Fun.GetactivityName(FCTabF.selectedActivity,activities))
				else
					self.GroupDropDown:Hide()
					self.ActivityDropDown:Show()
					FCTabF.selectedActivity=FCTabF.selectedActivity or GroupData[1][1]
					self.ActivityDropDown:PIGDownMenu_SetText(Fun.GetactivityName(FCTabF.selectedActivity,GroupData))
				end

				local activityInfo = C_LFGList.GetActivityInfoTable(FCTabF.selectedActivity);
				if activityInfo then
					self.ItemLevel:SetShown(not activityInfo.isPvpActivity);
					self.PvpItemLevel:SetShown(activityInfo.isPvpActivity);
					self.MythicPlusRating:SetShown(activityInfo.isMythicPlusActivity);
					self.PVPRating:SetShown(activityInfo.isRatedPvpActivity);
					local categoryInfo= C_LFGList.GetLfgCategoryInfo(FCTabF.selectedCategory)
					self.CrossFactionGroup:SetShown(categoryInfo.allowCrossFaction);
					local shouldShowPlayStyleDropdown = (categoryInfo.showPlaystyleDropdown) and (activityInfo.isMythicPlusActivity or activityInfo.isRatedPvpActivity or activityInfo.isCurrentRaidActivity or activityInfo.isMythicActivity);
					if(shouldShowPlayStyleDropdown) then
						FCTabF.selectedPlaystyle=FCTabF.selectedPlaystyle or 1
						local labelText;
						if(activityInfo.isRatedPvpActivity) then
							labelText = LFG_PLAYSTYLE_LABEL_PVP
						elseif (activityInfo.isMythicPlusActivity) then
							labelText = LFG_PLAYSTYLE_LABEL_PVE;
						else
							labelText = LFG_PLAYSTYLE_LABEL_PVE_MYTHICZERO;
						end
						self.PlayStyleLabel:SetText(labelText);
						local text = C_LFGList.GetPlaystyleString(FCTabF.selectedPlaystyle, activityInfo);
						self.PlayStyleDropdown:PIGDownMenu_SetText(text)
					else
						FCTabF.selectedPlaystyle = nil
					end
					self.PlayStyleLabel:SetShown(shouldShowPlayStyleDropdown);
					self.PlayStyleDropdown:SetShown(shouldShowPlayStyleDropdown);
				end
				self:ListGroupButton_Update()
			else
				self:Clear_Activity()
			end
		end
		--处理外服账号未绑定手机
		-- local isAccountSecured = C_LFGList.IsPlayerAuthenticatedForLFG(FCTabF.selectedActivity);
		-- self.Name.editBoxEnabled = isAccountSecured;
		-- self.Description.editBoxEnabled = isAccountSecured;
		-- self.Name:SetEnabled(isAccountSecured);
		-- self.Description.EditBox:SetEnabled(isAccountSecured);
		-- self.Name.LockButton:SetShown(not isAccountSecured);
		-- self.Description.LockButton:SetShown(not isAccountSecured);
		-- local descInstructions = nil;
		-- if isAccountSecured then
		-- 	self.NameF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
		-- 	self.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
		-- else
		-- 	self.NameF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
		-- 	self.DescriptionF:PIGSetBackdrop(0,0.6,nil,{0.3, 0.3, 0.3})
		-- 	descInstructions = LFG_AUTHENTICATOR_DESCRIPTION_BOX;
		-- end
		-- self.Description.EditBox.Instructions:SetText(descInstructions or DESCRIPTION_OF_YOUR_GROUP);
		-- if FCTabF.selectedCategory==118 then
		-- 	if(not isAccountSecured) then
		-- 		if not caozuo then
		-- 			C_LFGList.SetEntryTitle(1064, 0, FCTabF.selectedPlaystyle);
		-- 		end
		-- 	end
		-- elseif FCTabF.selectedCategory==GROUP_FINDER_CATEGORY_ID_DUNGEONS or FCTabF.selectedCategory==114 then
		-- 	if((activityInfo and activityInfo.isMythicPlusActivity) or not isAccountSecured) then
		-- 		if not caozuo then
		-- 			C_LFGList.SetEntryTitle(FCTabF.selectedActivity, FCTabF.selectedGroup, FCTabF.selectedPlaystyle);
		-- 		end
		-- 	end
		-- end
	end
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

	FCTabF.DQ.EntryName = PIGFrame(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Name_T,"BOTTOMLEFT",0,-24})
	FCTabF.DQ.EntryName:SetSize(FCTabF.DQ.Width-24,54)
	FCTabF.DQ.EntryName.T=PIGFontString(FCTabF.DQ.EntryName,{"TOPLEFT",FCTabF.DQ.EntryName,"TOPLEFT",0,0},"标题")
	FCTabF.DQ.EntryName.T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.EntryName.V=PIGFontString(FCTabF.DQ.EntryName,{"TOPLEFT",FCTabF.DQ.EntryName.T,"BOTTOMLEFT",0,0})
	FCTabF.DQ.EntryName.V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.EntryName.V:SetWidth(FCTabF.DQ.EntryName:GetWidth())
	FCTabF.DQ.EntryName.V:SetJustifyH("LEFT")
	FCTabF.DQ.EntryName.V:SetNonSpaceWrap(true)

	FCTabF.DQ.Description_T=PIGFontString(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.EntryName,"BOTTOMLEFT",0,-10},LFG_LIST_DETAILS)
	FCTabF.DQ.Description_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.DescriptionScroll = Create.PIGScrollFrame(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ.Description_T,"BOTTOMLEFT",0,-2},{FCTabF.DQ.Width-28,156})
	FCTabF.DQ.Description = PIGFrame(FCTabF.DQ.DescriptionScroll,nil,{FCTabF.DQ.DescriptionScroll:GetWidth()+2,20})
	FCTabF.DQ.Description.V=PIGFontString(FCTabF.DQ.Description,{"TOPLEFT",FCTabF.DQ.Description,"TOPLEFT",0,0})
	FCTabF.DQ.Description.V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.Description.V:SetWidth(FCTabF.DQ.Description:GetWidth())
	FCTabF.DQ.Description.V:SetJustifyH("LEFT")
	FCTabF.DQ.Description.V:SetNonSpaceWrap(true)
	FCTabF.DQ.DescriptionScroll:SetScrollChild(FCTabF.DQ.Description)

	FCTabF.DQ.ItemLevel_T=PIGFontString(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,100},LFG_LIST_ITEM_LEVEL_REQ)
	FCTabF.DQ.ItemLevel_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.ItemLevel_V=PIGFontString(FCTabF.DQ,{"LEFT",FCTabF.DQ.ItemLevel_T,"RIGHT",4,0},0)
	FCTabF.DQ.ItemLevel_V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.PvpItemLevel_T=PIGFontString(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,100},LFG_LIST_ITEM_LEVEL_PVP)
	FCTabF.DQ.PvpItemLevel_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.PvpItemLevel_V=PIGFontString(FCTabF.DQ,{"LEFT",FCTabF.DQ.PvpItemLevel_T,"RIGHT",4,0},0)
	FCTabF.DQ.PvpItemLevel_V:SetTextColor(0.9,0.9,0.9,1);

	FCTabF.DQ.PVPRating_T=PIGFontString(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,120},GROUP_FINDER_PVP_RATING_REQ_LABEL)
	FCTabF.DQ.PVPRating_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.PVPRating_V=PIGFontString(FCTabF.DQ,{"LEFT",FCTabF.DQ.PVPRating_T,"RIGHT",4,0},0)
	FCTabF.DQ.PVPRating_V:SetTextColor(0.9,0.9,0.9,1);
	FCTabF.DQ.MythicPlusRating_T=PIGFontString(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,120},GROUP_FINDER_MYTHIC_RATING_REQ_LABEL)
	FCTabF.DQ.MythicPlusRating_T:SetTextColor(0,0.98,0.6, 1);
	FCTabF.DQ.MythicPlusRating_V=PIGFontString(FCTabF.DQ,{"LEFT",FCTabF.DQ.MythicPlusRating_T,"RIGHT",4,0},0)
	FCTabF.DQ.MythicPlusRating_V:SetTextColor(0.9,0.9,0.9,1);
	

	local _, localizedFaction = UnitFactionGroup("player");
	FCTabF.DQ.CrossFactionGroup=PIGFrame(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,72},{200,20})
	FCTabF.DQ.CrossFactionGroup.CheckButton = PIGCheckbutton(FCTabF.DQ.CrossFactionGroup,{"LEFT",FCTabF.DQ.CrossFactionGroup,"LEFT",0,0},{LFG_LIST_CROSS_FACTION:format(localizedFaction),LFG_LIST_CROSS_FACTION_TOOLTIP:format(localizedFaction)},{16,16})
	FCTabF.DQ.CrossFactionGroup.CheckButton:Disable()
	FCTabF.DQ.PrivateGroup=PIGFrame(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,50},{200,20})
	FCTabF.DQ.PrivateGroup.CheckButton = PIGCheckbutton(FCTabF.DQ.PrivateGroup,{"LEFT",FCTabF.DQ.PrivateGroup,"LEFT",0,0},{"仅对公会/好友可见",LFG_LIST_PRIVATE_TOOLTIP},{16,16})
	FCTabF.DQ.PrivateGroup.CheckButton:Disable()

	FCTabF.DQ.EditButton=PIGButton(FCTabF.DQ,{"BOTTOMLEFT",FCTabF.DQ,"BOTTOMLEFT",10,18},{80,22},EDIT.."车队")
	FCTabF.DQ.EditButton:HookScript("OnClick", function (self)
		FCTabF.EditMode=true
		FCTabF:UpdateEditMode()
	end);

	FCTabF.DQ.RemoveEntryButton=PIGButton(FCTabF.DQ,{"LEFT",FCTabF.DQ.EditButton,"RIGHT",20,0},{80,22},PET_DISMISS.."车队")
	FCTabF.DQ.RemoveEntryButton:HookScript("OnClick", function (self)
		C_LFGList.RemoveListing()
	end);

	--申请界面
	FCTabF.DQ.Apply=PIGFrame(FCTabF.DQ,{"TOPLEFT",FCTabF.DQ,"TOPLEFT",FCTabF.DQ.Width,-34})
	FCTabF.DQ.Apply:SetPoint("BOTTOMRIGHT",FCTabF.DQ,"BOTTOMRIGHT",-16,2);
	FCTabF.DQ.Apply:PIGSetBackdrop(0)
	FCTabF.DQ.Apply.LFM_TITLE=PIGFontString(FCTabF.DQ.Apply,{"BOTTOMLEFT",FCTabF.DQ.Apply,"TOPLEFT",10,6},LOOKING..PLAYERS_IN_GROUP)
	FCTabF.DQ.Apply.LFM_TITLE:SetTextColor(0,1,0,1);
	FCTabF.DQ.Apply.RefreshButton = PIGButton(FCTabF.DQ.Apply,{"BOTTOMRIGHT",FCTabF.DQ.Apply,"TOPRIGHT",-180,4},{60,22},LFG_LIST_REFRESH)
	FCTabF.DQ.Apply.RefreshButton:HookScript("OnClick", function (self)
		C_LFGList.RefreshApplicants();
	end);
	FCTabF.DQ.Apply.AutoAcceptButton = PIGCheckbutton(FCTabF.DQ.Apply,{"BOTTOMRIGHT",FCTabF.DQ.Apply,"TOPRIGHT",-120,6},{LFG_LIST_AUTO_ACCEPT,CLUB_FINDER_COMMUNITY_AUTO_ACCEPT},{16,16})
	FCTabF.DQ.Apply.AutoAcceptButton:Disable()
	FCTabF.DQ.Apply.AutoAcceptButton:HookScript("OnClick", function (self)
		if ( self:GetChecked() ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
		LFGListUtil_SetAutoAccept(self:GetChecked());
	end);
	FCTabF.DQ.Apply.UnempoweredCover=PIGFrame(FCTabF.DQ.Apply,{"TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",0,0})
	FCTabF.DQ.Apply.UnempoweredCover:SetPoint("BOTTOMRIGHT",FCTabF.DQ.Apply,"BOTTOMRIGHT",0,0);
	FCTabF.DQ.Apply.UnempoweredCover:PIGSetBackdrop(1)
	FCTabF.DQ.Apply.UnempoweredCover:SetFrameLevel(FCTabF.DQ.Apply:GetFrameLevel()+5)
	FCTabF.DQ.Apply.UnempoweredCover.err = PIGFontString(FCTabF.DQ.Apply.UnempoweredCover,{"CENTER", FCTabF.DQ.Apply.UnempoweredCover, "CENTER",0, 40});
	FCTabF.DQ.Apply.UnempoweredCover.err:SetText(LFG_LIST_GROUP_FORMING);
	function FCTabF.DQ.Apply.UnempoweredCover:Update_Show(errtxt)
		self.err:SetText(errtxt)
		self:Show()
	end
	--成员显示模式
	InvF.addPlayerShowMode(FCTabF.DQ,{"LEFT", FCTabF.DQ.Apply.LFM_TITLE, "RIGHT", 4, 1},true)
	function FCTabF.DQ:Update_PlayerShowMode()
		if not self:IsVisible() then return end
		C_Timer.After(0.4,function()
			self:ShowMode_Restore()
			if not C_LFGList.HasActiveEntryInfo() then return end
			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			local activityID=activeEntryInfo.activityIDs[1]
			local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
			if activityInfo.displayType==Enum.LFGListDisplayType.RoleEnumerate then
				self.RoleEnumerate:Restore_But(0.2)
				self.RoleEnumerate:Update_But("ADD",false)
			else
				self.RoleCount:Restore_But()
				self.RoleCount:Update_But(GetGroupMemberCountsForDisplay(),false)
			end
		end)
	end
	--申请人
	local Apphang_Height,Apphang_NUM,Apphang_Width=25,15,FCTabF.DQ.Apply:GetWidth();
	local AppbiaotiName={{"申请人(|cffFF80FF点击"..L["CHAT_WHISPER"].."|r)",6},{"天赋",200},{"装等",300},{"申请留言",324},{"操作",584}}
	for i=1,#AppbiaotiName do
		local biaoti=PIGFontString(FCTabF.DQ.Apply,{"TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",AppbiaotiName[i][2],-5},AppbiaotiName[i][1])
		biaoti:SetTextColor(1,1,0, 0.9);
	end
	FCTabF.DQ.Apply.line = PIGLine(FCTabF.DQ.Apply,"TOP",-24,nil,nil,{0.2,0.2,0.2,0.5})

	FCTabF.DQ.Apply.Scroll = CreateFrame("Frame", nil, FCTabF.DQ.Apply)
	FCTabF.DQ.Apply.Scroll:SetPoint("TOPLEFT",FCTabF.DQ.Apply,"TOPLEFT",0,-24);
	FCTabF.DQ.Apply.Scroll:SetPoint("BOTTOMRIGHT",FCTabF.DQ.Apply,"BOTTOMRIGHT",0,0);
	FCTabF.DQ.Apply.Scroll.ScrollBox = CreateFrame("Frame", nil, FCTabF.DQ.Apply.Scroll, "WowScrollBoxList")
	FCTabF.DQ.Apply.Scroll.ScrollBar = CreateFrame("EventFrame", nil, FCTabF.DQ.Apply.Scroll, "MinimalScrollBar")
	FCTabF.DQ.Apply.Scroll.ScrollBar:SetPoint("TOPLEFT", FCTabF.DQ.Apply.Scroll.ScrollBox, "TOPRIGHT",4,0)
	FCTabF.DQ.Apply.Scroll.ScrollBar:SetPoint("BOTTOMLEFT", FCTabF.DQ.Apply.Scroll.ScrollBox, "BOTTOMRIGHT",4,0)
	local anchorsWithBar = {
        CreateAnchor("TOPLEFT", FCTabF.DQ.Apply.Scroll, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", FCTabF.DQ.Apply.Scroll, "BOTTOMRIGHT", 0, 1),
    }
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(FCTabF.DQ.Apply.Scroll.ScrollBox, FCTabF.DQ.Apply.Scroll.ScrollBar, anchorsWithBar, anchorsWithBar);
    local function UIEnterLeave(uix,highui)
    	uix:HookScript("OnEnter", function ()
			highui:Show()
		end);
		uix:HookScript("OnLeave", function ()
			highui:Hide()
		end);
    end
	local function CZ_tianfuShow_1(txt,tex,tisp)
		txt:SetText(" - - ");
		tex:SetTexture("interface/icons/ability_marksmanship.blp");
		tisp=nil
	end
	local function Clear_Showtianfu(uix)
		uix.getCount=0
		CZ_tianfuShow_1(uix.zhu,uix.zhutex,uix.tftisp1)
		CZ_tianfuShow_1(uix.fu,uix.futex,uix.tftisp2)
	end
	local function Update_Showtianfu(uix,class,nameX)
		if not uix:IsVisible() then return end
		if uix.name~=nameX then return end
		if class and nameX then
			local tfdd_1, tfdd_2=GetTianfuIcon_YC(class,nameX)
			if tfdd_1[1]=="--" and uix.getCount<5 then
				C_Timer.After(0.5,function()
					uix.getCount=uix.getCount+1
					Update_Showtianfu(uix,class,nameX)
				end)
			else
				if tfdd_1[1]~="--" then
					uix.tftisp1=tfdd_1
					uix.zhu:SetText(tfdd_1[1]);
					uix.zhutex:SetTexture(tfdd_1[2]);
				end
				if tfdd_2[1]~="--" then
					uix.tftisp2=tfdd_2
					uix.fu:SetText(tfdd_2[1]);
					uix.futex:SetTexture(tfdd_2[2]);
				end
			end
		end
	end
    local function UpdateApplicant_1(member, appID, memberIdx, applicationStatus)
		local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel = C_LFGList.GetApplicantMemberInfo(appID, memberIdx);
		member.allname=name
		member.tianfuF.name=name
		if applicationStatus=="applied" or applicationStatus== "invited" then
			FasongYCqingqiu(name,2)
			member:Updata_IsEnabled(false)
			local rPerc, gPerc, bPerc, argbHex = GetClassColor(class);
			member.nameF.name:SetTextColor(rPerc, gPerc, bPerc);
		else
			member:Updata_IsEnabled(true)
		end
		member.Role:SetAtlas(InvF.lfgroleNameIcon[assignedRole]);
		member.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
		member.nameF.name:SetText(name.."("..level..")");
		member.iLvl:SetText(floor(itemLevel));
		Clear_Showtianfu(member.tianfuF)
		member:Show();
		Update_Showtianfu(member.tianfuF,class,name)
	end
	local function add_MemberList(MemberBut)
		local frame=MemberBut:GetParent()
		local PF = CreateFrame("Frame",nil,MemberBut)
		PF:SetSize(MemberBut:GetWidth(),Apphang_Height);
		if #MemberBut.ListBut==0 then
			PF:SetPoint("TOPLEFT", MemberBut, "TOPLEFT",0, 0);
		else
			PF:SetPoint("TOPLEFT", MemberBut.ListBut[(#MemberBut.ListBut)], "BOTTOMLEFT",0, 0);
		end
		UIEnterLeave(PF,frame.highlight)
    	-- PF.Faction = PF:CreateTexture();
		-- PF.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		-- PF.Faction:SetPoint("LEFT", PF, "LEFT", 0,0);
		-- PF.Faction:SetSize(Apphang_Height-2,Apphang_Height-2);
   		PF.Role = PF:CreateTexture();
		PF.Role:SetPoint("LEFT", PF, "LEFT", 0,0);
		PF.Role:SetSize(Apphang_Height-2,Apphang_Height-2);
		PF.Role:SetAlpha(0.9);
		UIEnterLeave(PF.Role,frame.highlight)
		PF.Class = PF:CreateTexture();
		PF.Class:SetTexture("Interface/TargetingFrame/UI-Classes-Circles")
		PF.Class:SetPoint("LEFT", PF.Role, "RIGHT", 0,0);
		PF.Class:SetSize(Apphang_Height-4,Apphang_Height-4);
		PF.Class:SetAlpha(0.9);
		UIEnterLeave(PF.Class,frame.highlight)
		PF.nameF = PIGFrame(PF,{"LEFT", PF.Class, "RIGHT",1, 0},{120,Apphang_Height-4});
		UIEnterLeave(PF.nameF,frame.highlight)
		PF.nameF.name = PIGFontString(PF.nameF);
		PF.nameF.name:SetAllPoints(PF.nameF)
		PF.nameF.name:SetJustifyH("LEFT");
		PF.nameF:SetScript("OnMouseUp", function(self,button)
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
		PF.tianfuF = PIGFrame(PF,{"LEFT", PF, "LEFT",AppbiaotiName[2][2]-4, 0},{100,Apphang_Height-2});
		UIEnterLeave(PF.tianfuF,frame.highlight)
		PF.tianfuF:HookScript("OnEnter", function (self)
			if self.tftisp1 then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				local tishineirrr = "|T518449:13:13|t|T"..self.tftisp1[2]..":0|t"..self.tftisp1[1].." |cffFFFFFF"..self.tftisp1[3].."|r"
				if self.tftisp2 then
					tishineirrr =tishineirrr.."\n    |T"..self.tftisp2[2]..":0|t"..self.tftisp2[1].." |cffFFFFFF"..self.tftisp2[3].."|r"
				end
				GameTooltip:AddLine(tishineirrr)
				GameTooltip:Show();
			end
		end);
		PF.tianfuF:HookScript("OnLeave", function (self)
			GameTooltip:ClearLines();
			GameTooltip:Hide();
		end);
		PF.tianfuF.zhutex = PF.tianfuF:CreateTexture();
		PF.tianfuF.zhutex:SetSize(Apphang_Height-6,Apphang_Height-6);
		PF.tianfuF.zhutex:SetPoint("LEFT",PF.tianfuF, "LEFT",0, 0);
		PF.tianfuF.zhutex:SetAlpha(0.9);
		PF.tianfuF.zhu = PIGFontString(PF.tianfuF,{"LEFT",PF.tianfuF.zhutex, "RIGHT",0, 0});
		PF.tianfuF.zhu:SetJustifyH("LEFT");
		PF.tianfuF.futex = PF.tianfuF:CreateTexture();
		PF.tianfuF.futex:SetSize(Apphang_Height-6,Apphang_Height-6);
		PF.tianfuF.futex:SetPoint("LEFT",PF.tianfuF.zhu, "RIGHT",2, 0);
		PF.tianfuF.futex:SetAlpha(0.9);
		PF.tianfuF.fu = PIGFontString(PF.tianfuF,{"LEFT",PF.tianfuF.futex, "RIGHT",0, 0});
		PF.tianfuF.fu:SetJustifyH("LEFT");
		PF.item = PIGDiyBut(PF, {"LEFT", PF, "LEFT",AppbiaotiName[3][2]-2, 0},{Apphang_Height-4,Apphang_Height-4,nil,nil,133122})
		UIEnterLeave(PF.item,frame.highlight)
		PF.item:HookScript("OnClick", function(self,button)
			FasongYCqingqiu(self:GetParent().allname)
		end); 
		PF.iLvl = PIGFontString(PF,{"LEFT", PF.item, "RIGHT",1, 0});
		function PF:Updata_IsEnabled(Effective)
			PF.Role:SetDesaturated(Effective)
			PF.Class:SetDesaturated(Effective)
			PF.item:SetEnabled(not Effective)
			PF.item.icon:SetDesaturated(Effective)
			PF.tianfuF.zhutex:SetDesaturated(Effective)
			PF.tianfuF.futex:SetDesaturated(Effective)
			if Effective then
				PF.nameF.name:SetTextColor(0.5,0.5,0.5,1);
				PF.tianfuF.zhu:SetTextColor(0.5,0.5,0.5,1);
				PF.tianfuF.fu:SetTextColor(0.5,0.5,0.5,1);
				PF.iLvl:SetTextColor(0.5,0.5,0.5,1);
			else
				PF.tianfuF.zhu:SetTextColor(1,1,0,1);
				PF.tianfuF.fu:SetTextColor(1,1,0,1);
				PF.iLvl:SetTextColor(0,0.98,0.6, 1);
			end
		end
		return PF
	end
    function FCTabF.DQ.Apply.Scroll.add_hang(frame)
		if frame.bg then return end
		frame.bg = frame:CreateTexture();
		frame.bg:SetTexture("interface/characterframe/ui-party-background.blp");
		frame.bg:SetBlendMode("ADD")
		frame.bg:SetAllPoints(frame)
		frame.bg:SetColorTexture(0.1, 0.1, 0.1, 0.3)
		frame.highlight = frame:CreateTexture();
		frame.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		frame.highlight:SetBlendMode("ADD")
		frame.highlight:SetAllPoints(frame)
		frame.highlight:SetAlpha(0.2);
		frame.highlight:Hide()
		UIEnterLeave(frame,frame.highlight)
		frame.MemberBut=PIGFrame(frame,{"TOPLEFT", frame, "TOPLEFT",0, 0})
		frame.MemberBut:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0,0);
		frame.MemberBut:SetWidth(320);
		frame.MemberBut.ListBut={}
		function frame.MemberBut:UpdateApplicantMember(AppID,applicantInfo)
			for iG=1, #self.ListBut do
				self.ListBut[iG]:Hide();
			end
			for iG=1, applicantInfo.numMembers do
				if not self.ListBut[iG] then
					self.ListBut[iG]=add_MemberList(self,iG)
				end
				UpdateApplicant_1(self.ListBut[iG], AppID, iG, applicantInfo.applicationStatus);
			end
		end
		frame.caozuoF=PIGFrame(frame,{"TOPRIGHT", frame, "TOPRIGHT",0, 0})
		frame.caozuoF:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0,0);
		frame.caozuoF:SetWidth(70);
		UIEnterLeave(frame.caozuoF,frame.highlight)
		frame.caozuoF.Status= PIGFontString(frame.caozuoF,{"LEFT", frame.caozuoF, "LEFT",0, 0},"已取消",nil,13);
		frame.caozuoF.InviteButton = PIGButton(frame.caozuoF,{"LEFT", frame.caozuoF, "LEFT",1, 0},{44,Apphang_Height-6},INVITE)
		PIGSetFont(frame.caozuoF.InviteButton.Text,12)
		frame.caozuoF.InviteButton:SetBackdropColor(0.545, 0.137, 0.137,1)
		UIEnterLeave(frame.caozuoF.InviteButton,frame.highlight)
		frame.caozuoF.InviteButton:HookScript("OnClick", function(self)
			if ( not IsInRaid(LE_PARTY_CATEGORY_HOME) and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + self:GetParent().numMembers + C_LFGList.GetNumInvitedApplicantMembers() > MAX_PARTY_MEMBERS + 1 ) then
				local dialog = StaticPopup_Show("LFG_LIST_INVITING_CONVERT_TO_RAID");
				if ( dialog ) then
					dialog.data = self:GetParent():GetParent().applicantID;
				end
			else
				C_LFGList.InviteApplicant(self:GetParent():GetParent().applicantID);
			end
		end)
		frame.caozuoF.DeclineButton = PIGDiyBut(frame.caozuoF, {"LEFT", frame.caozuoF.InviteButton, "RIGHT", 6, 0},{16,16})
		UIEnterLeave(frame.caozuoF.DeclineButton,frame.highlight)
		frame.caozuoF.DeclineButton:HookScript("OnClick", function(self)
			if ( self.isAck ) then
				C_LFGList.RemoveApplicant(self:GetParent():GetParent().applicantID);
			else
				C_LFGList.DeclineApplicant(self:GetParent():GetParent().applicantID);
			end
		end)
		frame.jieshaoF=PIGFrame(frame,{"TOPLEFT", frame.MemberBut, "TOPRIGHT", 0, 0})
		frame.jieshaoF:SetPoint("BOTTOMRIGHT", frame.caozuoF, "BOTTOMLEFT", 0, 0);
		frame.jieshaoF.t = PIGFontString(frame.jieshaoF,{"LEFT", frame.jieshaoF, "LEFT",0, 0});
		frame.jieshaoF.t:SetAllPoints(frame.jieshaoF)
		frame.jieshaoF.t:SetJustifyH("LEFT");
		UIEnterLeave(frame.jieshaoF.t,frame.highlight)
		frame.jieshaoF:SetScript("OnEnter", function (self)
			if self.t:IsTruncated() then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				GameTooltip:AddLine(AppbiaotiName[4][1],1,1,0, 0.9)
				GameTooltip:AddLine(self.t:GetText(), 0.9,0.9,0.9, true)
				GameTooltipTextLeft2:SetNonSpaceWrap(true)
				GameTooltip:Show();
			end
		end);
		frame.jieshaoF:HookScript("OnLeave", function (self)
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		function frame:Updata_IsEnabled(Effective)
			if Effective then
				frame.jieshaoF.t:SetTextColor(0.5,0.5,0.5,1);
			else
				frame.jieshaoF.t:SetTextColor(0.9,0.9,0.9,1);
			end
		end
    end
    function FCTabF.DQ.Apply.Scroll:Update_hang(frame,AppID)
		frame:Updata_IsEnabled(true)
    	frame.applicantID=AppID
		local applicantInfo = C_LFGList.GetApplicantInfo(AppID);
		frame:SetHeight(applicantInfo.numMembers*Apphang_Height);
		frame.MemberBut:UpdateApplicantMember(AppID,applicantInfo)
		frame.jieshaoF.t:SetText(applicantInfo.comment);
		--更新邀请和拒绝
		--print(222,applicantInfo.applicationStatus)
		if ( applicantInfo.applicantInfo or applicantInfo.applicationStatus == "applied" ) then
			frame:Updata_IsEnabled(false)
			frame.caozuoF.Status:Hide();
		elseif ( applicantInfo.applicationStatus == "invited" ) then
			frame:Updata_IsEnabled(false)
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_INVITED);
			frame.caozuoF.Status:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "failed" or applicantInfo.applicationStatus == "cancelled" ) then
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_CANCELLED);
			frame.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "declined" or applicantInfo.applicationStatus == "declined_full" or applicantInfo.applicationStatus == "declined_delisted" ) then
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_DECLINED);
			frame.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "timedout" ) then
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_TIMED_OUT);
			frame.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "inviteaccepted" ) then
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_INVITE_ACCEPTED);
			frame.caozuoF.Status:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		elseif ( applicantInfo.applicationStatus == "invitedeclined" ) then
			frame.caozuoF.Status:Show();
			frame.caozuoF.Status:SetText(LFG_LIST_APP_INVITE_DECLINED);
			frame.caozuoF.Status:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
		frame.caozuoF.numMembers = applicantInfo.numMembers;
		local useSmallInviteButton = LFGApplicationViewerRatingColumnHeader:IsShown();
		frame.caozuoF.Status:ClearAllPoints()
		frame.caozuoF.InviteButton:SetShown(not useSmallInviteButton and not applicantInfo.applicantInfo and applicantInfo.applicationStatus == "applied" and LFGListUtil_IsEntryEmpowered());
		frame.caozuoF.DeclineButton:SetShown(not applicantInfo.applicantInfo and applicantInfo.applicationStatus ~= "invited" and LFGListUtil_IsEntryEmpowered());
		frame.caozuoF.DeclineButton.isAck = (applicantInfo.applicationStatus ~= "applied" and applicantInfo.applicationStatus ~= "invited");
		if(frame.caozuoF.DeclineButton:IsShown()) then
			frame.caozuoF.Status:SetPoint("RIGHT", frame.caozuoF.DeclineButton, "LEFT", -14, 0);
		else
			frame.caozuoF.Status:SetPoint("LEFT", frame.caozuoF, "LEFT", 4, 0);
		end
	end
    function FCTabF.DQ.Apply.Scroll:initialize()
		local view = CreateScrollBoxListLinearView()
	    view:SetElementExtent(Apphang_Height)
	    view:SetPadding(0,0,0,0,1)
	    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view)
        view:SetElementInitializer("Frame", function(frame, elementData)
        	FCTabF.DQ.Apply.Scroll.add_hang(frame)
        	FCTabF.DQ.Apply.Scroll:Update_hang(frame,elementData.AppID)
	    end)
	end
	FCTabF.DQ.Apply.Scroll:initialize()
	function FCTabF.DQ.Apply.Scroll:Update_list()
		if not self:IsVisible() then return end
		local view = self.ScrollBox:GetView()
		view:SetDataProvider(CreateDataProvider())
		local DataProvider = view:GetDataProvider();
		local applicants = C_LFGList.GetApplicants();
		if #applicants>0 then
			FCTabF.DQ.Apply.UnempoweredCover:Hide()
			LFGListUtil_SortApplicants(applicants);
			for index = 1, #applicants do
				DataProvider:Insert({index=index, AppID=applicants[index]});
			end
		end
	end
	function FCTabF.DQ.Apply:Update_Applylist()
		self.EditButton:SetEnabled(not IsRestrictedAccount())
		C_Timer.After(0.4,function()
			local Empowered=LFGListUtil_IsEntryEmpowered()
			FCTabF.DQ.RemoveEntryButton:SetShown(Empowered);
			FCTabF.DQ.EditButton:SetShown(Empowered);
			FCTabF.DQ.Apply.RefreshButton:SetEnabled(Empowered);
			if Empowered then
				FCTabF.DQ.Apply.UnempoweredCover:Update_Show(LFG_LIST_NO_APPLICANTS)
			else
				FCTabF.DQ.Apply.UnempoweredCover:Update_Show(LFG_LIST_GROUP_FORMING)
			end
			if not Empowered then return end
			self.Scroll:Update_list()
		end)
	end
	function FCTabF.DQ:Update_Activity()
		self:Show()
		local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
		local activityID=activeEntryInfo.activityIDs[1]
		local activityInfo = C_LFGList.GetActivityInfoTable(activityID);	
		local categoryInfo= C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID)
		self.Category_V:SetText(categoryInfo.name);
		self.Name_V:SetText(activityInfo.fullName);
		self.PvpItemLevel_T:SetShown(activityInfo.isPvpActivity);
		self.PvpItemLevel_V:SetShown(activityInfo.isPvpActivity);
		self.ItemLevel_T:SetShown(not activityInfo.isPvpActivity);
		self.ItemLevel_V:SetShown(not activityInfo.isPvpActivity);
		self.PvpItemLevel_V:SetText(activeEntryInfo.requiredItemLevel);
		self.ItemLevel_V:SetText(activeEntryInfo.requiredItemLevel);
		self.MythicPlusRating_T:SetShown(activityInfo.isMythicPlusActivity);
		self.MythicPlusRating_V:SetShown(activityInfo.isMythicPlusActivity);
		self.PVPRating_T:SetShown(activityInfo.isRatedPvpActivity);
		self.PVPRating_V:SetShown(activityInfo.isRatedPvpActivity);
		self.EntryName.V:SetText(activeEntryInfo.name);
		self.Description.V:SetText(activeEntryInfo.comment);
		self.CrossFactionGroup:SetShown(categoryInfo.allowCrossFaction);
		self.CrossFactionGroup.CheckButton:SetChecked(not activeEntryInfo.isCrossFactionListing)
		self.PrivateGroup.CheckButton:SetChecked(activeEntryInfo.privateGroup);
		self:Update_PlayerShowMode()
		self.Apply:Update_Applylist()
	end
	----
	function FCTabF:UpdateEditMode(Mode)
		if not self:IsVisible() then return end
		if not self.tabList then
			self.tabList=PIG_GetCategories()
		end
		self.ADD:Hide()
		self.DQ:Hide()
		if C_LFGList.HasActiveEntryInfo() and not self.EditMode then
			self.DQ:Update_Activity()
		else
			self.ADD:Update_Activity()
		end
	end
	----------
	FCTabF:RegisterEvent("LFG_LIST_APPLICANT_UPDATED");
	FCTabF:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED");
	FCTabF:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE");
	FCTabF:RegisterEvent("LFG_LIST_AVAILABILITY_UPDATE");
	FCTabF:RegisterEvent("LFG_LIST_ENTRY_CREATION_FAILED");
	FCTabF:RegisterEvent("GROUP_ROSTER_UPDATE");
	FCTabF:HookScript("OnEvent", function(self,event,arg1)
		--print(event,arg1)
		if event=="LFG_LIST_APPLICANT_UPDATED" then--來自申请人狀態改變
			if ( not LFGListUtil_IsEntryEmpowered() ) then--你不是队长则清除
				C_LFGList.RemoveApplicant(arg1);
			else
				local frame = self.DQ.Apply.Scroll.ScrollBox:FindFrameByPredicate(function(frame, elementData)
					return elementData.AppID == arg1;
				end);
				if frame then
					self.DQ.Apply.Scroll:Update_hang(frame, arg1)
				end
			end
		elseif event=="LFG_LIST_AVAILABILITY_UPDATE" then--列表可用性更新/职责变化
			self.DQ:Update_PlayerShowMode()
			self.DQ.Apply:Update_Applylist()
		elseif event=="GROUP_ROSTER_UPDATE" then--职责变化
			self.DQ:Update_PlayerShowMode()
		elseif event=="LFG_LIST_APPLICANT_LIST_UPDATED" then--申请人列表刷新
			self.DQ.Apply:Update_Applylist()
		elseif ( event == "LFG_LIST_ENTRY_CREATION_FAILED" ) then
			self.ADD.WorkingCover:Hide();
		elseif event=="LFG_LIST_ACTIVE_ENTRY_UPDATE" then--自己创建活动变动时Mode值(true新建/false编辑/nil取消)
			self.EditMode=nil
			self.ADD.WorkingCover:Hide();
			self:UpdateEditMode(arg1)
		end
	end);
end