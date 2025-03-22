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
-----------------
local FasongYCqingqiu=Fun.FasongYCqingqiu
local GetRuneTXT=Fun.GetRuneTXT
local TalentData=Data.TalentData
local GetTianfuIcon_YC=TalentData.GetTianfuIcon_YC
---------
local greenTexture = "interface/common/indicator-green.blp"
local xuanzhongBG = {{0.2, 0.2, 0.2, 0.2},{0.4, 0.8, 0.8, 0.2}}
local tabheji = {}
local tabhejiNameth = {}
local zhizenameID = {["1"]="DAMAGER",["2"]="TANK",["3"]="HEALER"}
local function panduancunzaitongName(heji,name1)--剔除相同名
	for i=1,#heji do
		if heji[i][1]==name1 then
			return false
		end
	end
	return true
end
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
				if not C_Engraving.IsEngravingEnabled() then
					table.insert(tabheji,1,{114,GUILD_INTEREST_RAID})
				end
				break
			end
		end
		--tab1
		local tab1_1,tab1_2,tab1_3 = tab1[1],tab1[2],tab1[3]
		local xuanzehuodong=PIGFontString(tab1_1,{"TOPLEFT",tab1_1,"TOPLEFT",tab1_2,tab1_3}," ")
		for i=1,#tabheji do
			local ckbut = PIGCheckbutton(tab1_1,nil,{tabheji[i][2],nil},nil,"Houche_guolv"..i,tabheji[i][1])
			if i==1 then
				ckbut:SetPoint("LEFT",xuanzehuodong,"RIGHT",8,0)
			else
				ckbut:SetPoint("LEFT",_G["Houche_guolv"..(i-1)].Text,"RIGHT",8,0)
			end
			ckbut:HookScript("OnClick", function (self)
				for ix=1,#tabheji do
					_G["Houche_guolv"..ix]:SetChecked(false)
				end
				self:SetChecked(true)
				tab1_1.selectedCategory=self:GetID()
				if tab1_1.selectedCategory==120 then
					tab1_1.selectedGroup = 0;
					tab1_1.GroupDropDown:Hide()
				else
					local ActivityGroups = C_LFGList.GetAvailableActivityGroups(tab1_1.selectedCategory)
					if #ActivityGroups>0 then
						tab1_1.selectedGroup = ActivityGroups[1];
						local Groupname = C_LFGList.GetActivityGroupInfo(tab1_1.selectedGroup);
						tab1_1.GroupDropDown:PIGDownMenu_SetText(Groupname)
						tab1_1.GroupDropDown:Show()
					else
						tab1_1.selectedGroup = 0;
						tab1_1.GroupDropDown:Hide()
					end
				end
				tab1_1.selectedActivity = 0
				tab1_1.ActivityDropDown:PIGDownMenu_SetText("全部")
				tab1_1.ActivityDropDown:Show()
				tab1_1.GetBut:Show()
				--tab1_1.GetBut:GetBut_Disable()
			end)
		end
		tab1_1.GroupDropDown =PIGDownMenu(tab1_1,{"LEFT",_G["Houche_guolv"..#tabheji].Text,"RIGHT",10,0},{160,nil})
		tab1_1.GroupDropDown:Hide()
		function tab1_1.GroupDropDown:PIGDownMenu_Update_But(self)
			local info = {}
			info.func = self.PIGDownMenu_SetValue
			local ActivityGroups = C_LFGList.GetAvailableActivityGroups(tab1_1.selectedCategory)
			for i=1,#ActivityGroups,1 do
				local groupID = ActivityGroups[i];
				local name = C_LFGList.GetActivityGroupInfo(groupID);
			    info.text, info.arg1, info.arg2 = name, groupID, "group";
			    info.checked = groupID == tab1_1.selectedGroup
				self:PIGDownMenu_AddButton(info)
			end 
		end
		function tab1_1.GroupDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
			self:PIGDownMenu_SetText(value)
			tab1_1.selectedGroup=arg1
			tab1_1.selectedActivity= 0
			tab1_1.ActivityDropDown:PIGDownMenu_SetText("全部")
			PIGCloseDropDownMenus()
		end
		tab1_1.ActivityDropDown =PIGDownMenu(tab1_1,{"LEFT",_G["Houche_guolv"..#tabheji].Text,"RIGHT",180,0},{150,nil})
		tab1_1.ActivityDropDown:PIGDownMenu_SetText("全部")
		tab1_1.ActivityDropDown:Hide()
		function tab1_1.ActivityDropDown:PIGDownMenu_Update_But(self)
			local info = {}
			info.func = self.PIGDownMenu_SetValue
			local Activities = C_LFGList.GetAvailableActivities(tab1_1.selectedCategory,tab1_1.selectedGroup)
			local newActivities = {}
			table.insert(newActivities,{"全部",0})
			if #Activities==0 then
				for index = 1, GetNumBattlegroundTypes() do
					local localizedName, canEnter, isHoliday, isRandom, battleGroundID = GetBattlegroundInfo(index);
					if localizedName and canEnter then
						table.insert(newActivities,{localizedName,battleGroundID})
					end
				end
			else
				for i=1,#Activities,1 do
					local ActivityInfo= C_LFGList.GetActivityInfoTable(Activities[i])
					if tab1_1.selectedGroup==300 then--处理战场重名
						if panduancunzaitongName(newActivities,ActivityInfo.fullName) then
							table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
						end
					else
						table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
					end
				end
			end
			for i=1,#newActivities,1 do
			    info.text, info.arg1, info.arg2 = newActivities[i][1], newActivities[i][2], "activity";
			    info.checked = newActivities[i][2] == tab1_1.selectedActivity
				tab1_1.ActivityDropDown:PIGDownMenu_AddButton(info)
			end 
		end
		function tab1_1.ActivityDropDown:PIGDownMenu_SetValue(value,arg1,arg2)
			self:PIGDownMenu_SetText(value)
			tab1_1.selectedActivity=arg1
			--tab1_1.GetBut:GetBut_Disable()
			PIGCloseDropDownMenus()
		end
		function tab1_1:yanchiEnable()
		 	for ix=1,#tabheji do
				_G["Houche_guolv"..ix]:Enable()
			end
			tab1_1.GroupDropDown:Enable()
			tab1_1.ActivityDropDown:Enable()
		end
		--tab2
		local tab2_1,tab2_2,tab2_3 = tab2[1],tab2[2],tab2[3]
		for i=1,#tabheji do
			local ckbut = PIGCheckbutton(tab2_1,nil,{tabheji[i][2],nil},nil,"ADD_Houche_guolv"..i,tabheji[i][1])
			if i==1 then
				ckbut:SetPoint("TOPLEFT",tab2_1,"TOPLEFT",tab2_2,tab2_3)
			elseif i==4 then
				ckbut:SetPoint("TOPLEFT",ADD_Houche_guolv1,"BOTTOMLEFT",0,-6)
			else
				ckbut:SetPoint("LEFT",_G["ADD_Houche_guolv"..(i-1)],"RIGHT",66,0)
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
---------
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Houche(Activate)
	if not PIGA["Tardis"]["Houche"]["Open"] then return end
	local GetPIGID=Fun.GetPIGID
	local disp_time=Fun.disp_time
	local Biaotou=Data.Tardis.Prefix
	local gnindexID=2
	local GetInfoMsg=Data.Tardis.GetMsg[gnindexID]

	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local pindao=InvF.pindao
	local hang_Height,hang_NUM=InvF.hang_Height,InvF.hang_NUM
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_HOUCHE"],80,"Bot")
	if Activate then
		fujiF:Show()
		fujiTabBut:Selected()
	end
	---
	fujiF.F=PIGOptionsList_RF(fujiF,28,nil,{4,4,4})
	fujiF.F:PIGSetBackdrop()
	--
	local TabF,TabBut=PIGOptionsList_R(fujiF.F,"大厅",70)
	TabF:Show()
	TabBut:Selected()
	TabF.JieshouInfoList={};
	TabF.GetBut=TardisInfo.GetInfoBut(TabF,{"TOPLEFT",TabF,"TOPLEFT",176,-6},10,2)
	TabF.GetBut:Hide()
	local function GetChegnkeInfo(self)
		self.PIGID=GetPIGID(pindao)
		if self.PIGID==0 then
			self.err:SetText("请先加入"..pindao.."频道");
			return
		end
		if tocversion<80000 then
			SendChatMessage(GetInfoMsg..TabF.selectedCategory..TabF.selectedGroup..TabF.selectedActivity,"CHANNEL",nil,self.PIGID)
		else
			PIGSendAddonMessage(Biaotou,GetInfoMsg..TabF.selectedCategory..TabF.selectedGroup..TabF.selectedActivity,"CHANNEL",self.PIGID)
		end
		self:CZdaojishi()
		PIGA["Tardis"]["Houche"]["DaojishiCD"]=GetServerTime();
		TabF.JieshouInfoList={};
	end
	TabF.GetBut:HookScript("OnClick", function()
		TabF.GetBut:GetBut_Disable()
	end);
	TabF.GetBut.daojishiJG=PIGA["Tardis"]["Houche"]["DaojishiCD"]
	function TabF.GetBut:GetBut_Disable()
		for ix=1,#tabheji do
			_G["Houche_guolv"..ix]:Disable()
		end
		TabF.GroupDropDown:Disable()
		TabF.ActivityDropDown:Disable()
		GetChegnkeInfo(self)
	end
	function TabF.GetBut.gengxin_hang()
		TabF.gengxinhang(TabF.F.Scroll)
	end
	----
	TabF.F=PIGFrame(TabF,{"TOPLEFT",TabF,"TOPLEFT",0,-32})
	TabF.F:SetPoint("BOTTOMRIGHT",TabF,"BOTTOMRIGHT",0,0);
	TabF.F:PIGSetBackdrop()
	--
	local biaotiName={{"目的地",6},{"乘客(|cffFF80FF点击"..L["CHAT_WHISPER"].."|r)",180},{"天赋",356},{"装等",466},{"乘客留言",520},{"操作",800}}
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
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, TabF.gengxinhang)
	end)
	for i=1, hang_NUM, 1 do
		local hangL = CreateFrame("Button", "HoucheList_"..i, TabF.F,"BackdropTemplate");
		hangL:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hangL:SetSize(hang_Width-2,hang_Height);
		hangL:SetBackdropColor(unpack(xuanzhongBG[1]));
		hangL:Hide()
		if i==1 then
			hangL:SetPoint("TOPLEFT", TabF.F.Scroll, "TOPLEFT", 0, -1);
		else
			hangL:SetPoint("TOPLEFT", _G["HoucheList_"..(i-1)], "BOTTOMLEFT", 0, -1);
		end
		hangL:HookScript("OnEnter", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangL:HookScript("OnLeave", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		hangL.mudidi = PIGFontString(hangL,{"LEFT", hangL, "LEFT",biaotiName[1][2], 0});
		hangL.mudidi:SetTextColor(0,0.98,0.6, 1);
		hangL.mudidi:SetJustifyH("LEFT");

		hangL.nameF = PIGFrame(hangL,{"LEFT", hangL, "LEFT",biaotiName[2][2]-3, 0},{168,hang_Height-4});
		hangL.nameF:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangL.nameF:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		hangL.nameF.Role = hangL.nameF:CreateTexture();
		hangL.nameF.Role:SetSize(hang_Height-4,hang_Height-4);
		hangL.nameF.Role:SetPoint("LEFT", hangL.nameF, "LEFT", 0, 0);
		hangL.nameF.Role:SetAlpha(0.9);
		hangL.nameF.Classe = hangL.nameF:CreateTexture();
		hangL.nameF.Classe:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
		hangL.nameF.Classe:SetSize(hang_Height-6,hang_Height-6);
		hangL.nameF.Classe:SetPoint("LEFT", hangL.nameF.Role, "RIGHT", 0,0);
		hangL.nameF.Classe:SetAlpha(0.9);
		hangL.nameF.LV = hangL.nameF:CreateTexture();
		hangL.nameF.LV:SetSize(hang_Height-3,hang_Height-3);
		hangL.nameF.LV:SetPoint("LEFT", hangL.nameF.Classe, "RIGHT", 0,0);
		hangL.nameF.LV:SetAlpha(0.4);
		hangL.nameF.LV:SetAtlas("UI-LFG-RoleIcon-Incentive");
		hangL.nameF.LVT = PIGFontString(hangL.nameF,{"TOPLEFT", hangL.nameF.LV, "TOPLEFT", -1, 1},1,nil,13);
		hangL.nameF.LVT:SetPoint("BOTTOMRIGHT", hangL.nameF.LV, "BOTTOMRIGHT", 0,0);
		hangL.nameF.name = PIGFontString(hangL.nameF,{"LEFT", hangL.nameF.LV, "RIGHT", 0,0});
		hangL.nameF.name:SetJustifyH("LEFT");
		hangL.nameF:SetScript("OnMouseUp", function(self)
			local wjName = self:GetParent().allname
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
		hangL.tianfuF = PIGFrame(hangL,{"LEFT", hangL, "LEFT",biaotiName[3][2]-2, 0},{100,hang_Height});
		hangL.tianfuF:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
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
		hangL.tianfuF:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
			GameTooltip:ClearLines();
			GameTooltip:Hide();
		end);
		hangL.tianfuF.zhutex = hangL.tianfuF:CreateTexture();
		hangL.tianfuF.zhutex:SetSize(hang_Height-6,hang_Height-6);
		hangL.tianfuF.zhutex:SetPoint("LEFT",hangL.tianfuF, "LEFT",0, 0);
		hangL.tianfuF.zhutex:SetAlpha(0.9);
		hangL.tianfuF.zhu = PIGFontString(hangL.tianfuF,{"LEFT",hangL.tianfuF.zhutex, "RIGHT",0, 0});
		hangL.tianfuF.zhu:SetJustifyH("LEFT");
		hangL.tianfuF.futex = hangL.tianfuF:CreateTexture();
		hangL.tianfuF.futex:SetSize(hang_Height-6,hang_Height-6);
		hangL.tianfuF.futex:SetPoint("LEFT",hangL.tianfuF.zhu, "RIGHT",2, 0);
		hangL.tianfuF.futex:SetAlpha(0.9);
		hangL.tianfuF.fu = PIGFontString(hangL.tianfuF,{"LEFT",hangL.tianfuF.futex, "RIGHT",0, 0});
		hangL.tianfuF.fu:SetJustifyH("LEFT");

		hangL.item = CreateFrame("Button",nil,hangL, "TruncatedButtonTemplate");
		hangL.item:SetPoint("LEFT", hangL, "LEFT",biaotiName[4][2]-2, 0);
		hangL.item:SetSize(hang_Height-6,hang_Height-6);
		hangL.item:SetNormalTexture(133122);
		hangL.item:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		hangL.item:HookScript("OnMouseDown", function(self,button)
			self:SetPoint("LEFT", self:GetParent(), "LEFT",biaotiName[4][2]-0.5, -1.5);
		end); 
		hangL.item:HookScript("OnMouseUp", function(self,button)
			self:SetPoint("LEFT", self:GetParent(), "LEFT",biaotiName[4][2]-2, 0);
		end); 
		hangL.item:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangL.item:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		hangL.item:HookScript("OnClick", function(self,button)
			FasongYCqingqiu(self:GetParent().allname)
		end); 
		hangL.ilv = PIGFontString(hangL,{"LEFT", hangL.item, "RIGHT", 2, 0});
		hangL.ilv:SetTextColor(0,0.98,0.6, 1);

		hangL.commentF=PIGFrame(hangL,{"LEFT", hangL, "LEFT",biaotiName[5][2]-2, 0})
		hangL.commentF:SetSize(280,hang_Height-4);
		hangL.commentF:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangL.commentF:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		hangL.commentF.t = PIGFontString(hangL.commentF,{"LEFT", hangL.commentF, "LEFT", 0, 0});
		hangL.commentF.t:SetTextColor(0.9,0.9,0.9,0.9);
		hangL.commentF.t:SetAllPoints(hangL.commentF)
		hangL.commentF.t:SetJustifyH("LEFT");
		hangL.commentF:HookScript("OnEnter", function (self)
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
		hangL.caozuo = PIGButton(hangL, {"LEFT", hangL, "LEFT", biaotiName[6][2], 0},{46,18},INVITE);
		PIGSetFont(hangL.caozuo.Text,12)
		hangL.caozuo:SetBackdropColor(0.545, 0.137, 0.137,1)
		hangL.caozuo:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangL.caozuo:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		hangL.caozuo:HookScript("OnClick", function(self)
			local wjName = self:GetParent().allname
			if wjName==UNKNOWNOBJECT then return end
			PIG_InviteUnit(wjName)
			TabF.JieshouInfoList[self:GetID()][3]=true
			TabF.gengxinhang(TabF.F.Scroll)
		end)
	end
	local function Show_JJtianfu(uix,zhiye,nameX,tianfuData)
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
			local tfdd_1, tfdd_2=GetTianfuIcon_YC(zhiye,nameX,"Houche",tianfuData)
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
	function TabF.gengxinhang(self)
		TabF:yanchiEnable()
		TabF.GetBut.jindutishi:SetText("上次获取:刚刚");
		for i = 1, hang_NUM do
			_G["HoucheList_"..i]:Hide()	
		end
		local ItemsNum = #TabF.JieshouInfoList;
		if ItemsNum>0 then
			TabF.GetBut.err:SetText("");
			FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
			for i = 1, hang_NUM do
				local dangqian = i+offset;
				if TabF.JieshouInfoList[dangqian] then
					local hangL = _G["HoucheList_"..i]	
					hangL:Show()
					local allname = TabF.JieshouInfoList[dangqian][2]
					hangL.allname=allname
					local playerData,tianfuData,assignedRole,ActivityID,commentT = strsplit("#", TabF.JieshouInfoList[dangqian][1]);
					local activityInfo = C_LFGList.GetActivityInfoTable(ActivityID)
					hangL.mudidi:SetText(activityInfo.fullName)
					local classId,raceID,level,ItemLevel = strsplit("-", playerData);
					hangL.nameF.Role:SetAtlas(PIGGetIconForRole(zhizenameID[assignedRole], false));
					local className, classFile, classID = PIGGetClassInfo(classId)
					hangL.nameF.Classe:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					hangL.nameF.LVT:SetText(level)
					local wjName, servername = strsplit("-", allname)
					if servername then 
						hangL.nameF.name:SetText(wjName.."(*)");
					else
						hangL.nameF.name:SetText(allname);
					end
					local color = PIG_CLASS_COLORS[classFile];
					hangL.nameF.name:SetTextColor(color.r, color.g, color.b, 1);
					if tonumber(ItemLevel)<100 then
						hangL.ilv:SetText(floor(ItemLevel*10)/10);
					else
						hangL.ilv:SetText(floor(ItemLevel+0.5));
					end
					hangL.commentF.t:SetText(commentT);
					hangL.caozuo:SetID(dangqian)
					if TabF.JieshouInfoList[dangqian][3] then
						hangL.caozuo:Disable()
						hangL.caozuo:SetText("已"..INVITE);
						hangL.caozuo:SetBackdropColor(0.3, 0.3, 0.3,0.8)
					else
						hangL.caozuo:Enable()
						hangL.caozuo:SetText(INVITE);
						hangL.caozuo:SetBackdropColor(0.545, 0.137, 0.137,1)
					end
					if allname == Pig_OptionsUI.Name or allname == Pig_OptionsUI.AllName then
						hangL.caozuo:Disable()
						hangL.caozuo:SetText(UNIT_YOU_DEST);
						hangL.caozuo:SetBackdropColor(0.3, 0.3, 0.3,0.8)
					end
					Show_JJtianfu(hangL.tianfuF,classFile,TabF.JieshouInfoList[dangqian][2],tianfuData)
				end
			end
		else
			TabF.GetBut.err:SetText("未获取到"..L["TARDIS_HOUCHE_1"].."信息，请稍后再试!");
		end
	end
	
	---我的
	local FCTabF,FCTabBut=PIGOptionsList_R(fujiF.F,"购票",70)

	FCTabF.ADD=PIGFrame(FCTabF,{"TOPLEFT",FCTabF,"TOPLEFT",0,0})
	FCTabF.ADD:SetPoint("BOTTOMRIGHT",FCTabF,"BOTTOMRIGHT",0,0);
	FCTabF.ADD.Width=280
	FCTabF.ADD.Category_T=PIGFontString(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",20,-20},"选择购票类型")
	C_Timer.After(0.6,function() Getfenleidata({TabF,266,-10},{FCTabF.ADD,20,-50}) end)
	--
	FCTabF.ADD.GroupDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.Category_T,"TOPLEFT",0,-110},{FCTabF.ADD.Width-20,nil})
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
	FCTabF.ADD.ActivityDropDown =PIGDownMenu(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.GroupDropDown,"BOTTOMLEFT",0,-20},{FCTabF.ADD.Width-20,nil})
	FCTabF.ADD.ActivityDropDown:Hide()
	function FCTabF.ADD.ActivityDropDown:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local newActivities = {}
		local Activities = C_LFGList.GetAvailableActivities(FCTabF.selectedCategory,FCTabF.selectedGroup)
		if #Activities==0 then
			for index = 1, GetNumBattlegroundTypes() do
				local localizedName, canEnter, isHoliday, isRandom, battleGroundID = GetBattlegroundInfo(index);
				if localizedName and canEnter then
					table.insert(newActivities,{localizedName,battleGroundID})
				end
			end
		else
			for i=1,#Activities,1 do
				local ActivityInfo= C_LFGList.GetActivityInfoTable(Activities[i])
				if FCTabF.selectedGroup==300 then--处理战场重名
					if panduancunzaitongName(newActivities,ActivityInfo.fullName) then
						table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
					end
				else
					table.insert(newActivities,{ActivityInfo.fullName,Activities[i]})
				end
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

	FCTabF.ADD.Role=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD.ActivityDropDown,"BOTTOMLEFT",0,-100},{FCTabF.ADD.Width,42})
	FCTabF.ADD.Role:Hide()
	FCTabF.ADD.Role.biao=PIGFontString(FCTabF.ADD.Role,{"LEFT",FCTabF.ADD.Role,"LEFT",0,0},"职\n责")
	local function PIG_Set_Role()
		local _, tank, healer, dps = GetLFGRoles();
		if dps then
			FCTabF.roleID=1
		elseif tank then
			FCTabF.roleID=2
		elseif healer then
			FCTabF.roleID=3
		end
		FCTabF.ADD.Role.T.checkButton:SetChecked(tank);
		FCTabF.ADD.Role.H.checkButton:SetChecked(healer);
		FCTabF.ADD.Role.D.checkButton:SetChecked(dps);
		FCTabF.ADD:ListGroupButton_Update()
	end
	local function PIG_Show_Role(shenqingz)
		if shenqingz then
			local _, tank, healer, dps = GetLFGRoles();
			FCTabF.ADD.Role.D:SetShown(dps);
			FCTabF.ADD.Role.T:SetShown(tank);
			FCTabF.ADD.Role.H:SetShown(healer);
		else
			FCTabF.ADD.Role.D:SetShown(true);
			FCTabF.ADD.Role.T:SetShown(true);
			FCTabF.ADD.Role.H:SetShown(true);
		end
	end
	function FCTabF.ADD.Role_checkButton(self)
		if ( self:GetChecked() ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
		local roleFf = self:GetParent()
		local setDPS,setTank,setHealer  = false;
		if roleFf.roleID == 1 then
			setDPS = true;
		elseif roleFf.roleID == 2 then
			setTank = true;
		elseif roleFf.roleID == 3 then
			setHealer = true;
		end
		SetLFGRoles(leader, setTank, setHealer, setDPS);
		PIG_Set_Role()
	end
	FCTabF.ADD.Role.T = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",2);
	FCTabF.ADD.Role.T:SetPoint("LEFT",FCTabF.ADD.Role.biao,"RIGHT",10,0);
	FCTabF.ADD.Role.T:SetSize(40,40);
	FCTabF.ADD.Role.T.role="TANK";
	FCTabF.ADD.Role.T.roleID=2;
	FCTabF.ADD.Role.T:SetNormalAtlas(PIGGetIconForRole(FCTabF.ADD.Role.T.role, false));
	FCTabF.ADD.Role.T.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	FCTabF.ADD.Role.H = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",3);
	FCTabF.ADD.Role.H:SetPoint("LEFT",FCTabF.ADD.Role.T,"RIGHT",20,0);
	FCTabF.ADD.Role.H:SetSize(40,40);
	FCTabF.ADD.Role.H.role="HEALER";
	FCTabF.ADD.Role.H.roleID=3;
	FCTabF.ADD.Role.H.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	FCTabF.ADD.Role.H:SetNormalAtlas(PIGGetIconForRole(FCTabF.ADD.Role.H.role, false));
	FCTabF.ADD.Role.D = CreateFrame("Button",nil,FCTabF.ADD.Role,"LFGRoleButtonWithBackgroundAndRewardTemplate",1);
	FCTabF.ADD.Role.D:SetPoint("LEFT",FCTabF.ADD.Role.H,"RIGHT",20,0);
	FCTabF.ADD.Role.D:SetSize(40,40);
	FCTabF.ADD.Role.D.role="DAMAGER";
	FCTabF.ADD.Role.D.roleID=1;
	FCTabF.ADD.Role.D:SetNormalAtlas(PIGGetIconForRole(FCTabF.ADD.Role.D.role, false));
	FCTabF.ADD.Role.D.checkButton:SetScript("OnClick", FCTabF.ADD.Role_checkButton)
	local function PIG_UpdateAvailableRoleButton(button, canBeRole)
		if (canBeRole) then
			LFG_EnableRoleButton(button);
			button.permDisabledTip = nil;
		else
			LFG_PermanentlyDisableRoleButton(button);
			button.permDisabledTip = YOUR_CLASS_MAY_NOT_PERFORM_ROLE;
		end
	end
	FCTabF.ADD.Role:SetScript("OnShow", function(self)
		local classTank, classHealer, classDPS = UnitGetAvailableRoles("player");
		PIG_UpdateAvailableRoleButton(FCTabF.ADD.Role.T, classTank);
		PIG_UpdateAvailableRoleButton(FCTabF.ADD.Role.H, classHealer);
		PIG_UpdateAvailableRoleButton(FCTabF.ADD.Role.D, classDPS);
		PIG_Set_Role()
	end)

    FCTabF.ADD.DescriptionF=PIGFrame(FCTabF.ADD,{"TOPLEFT",FCTabF.ADD,"TOPLEFT",FCTabF.ADD.Width+100,-40})
	FCTabF.ADD.DescriptionF:SetSize(400,100);
	FCTabF.ADD.DescriptionF:PIGSetBackdrop(0,0.8,nil,{0, 1, 1})
	FCTabF.ADD.DescriptionF:Hide()
	FCTabF.ADD.DescriptionF.t=PIGFontString(FCTabF.ADD.DescriptionF,{"BOTTOMLEFT",FCTabF.ADD.DescriptionF,"TOPLEFT",0,2},"购票申请")
	FCTabF.ADD.DescriptionF.E = CreateFrame("EditBox", nil, FCTabF.ADD.DescriptionF)
	FCTabF.ADD.DescriptionF.E:SetPoint("TOPLEFT",FCTabF.ADD.DescriptionF,"TOPLEFT",6,-2);
	FCTabF.ADD.DescriptionF.E:SetPoint("BOTTOMRIGHT",FCTabF.ADD.DescriptionF,"BOTTOMRIGHT",-4,0);
	FCTabF.ADD.DescriptionF.E:SetWidth(FCTabF.ADD.DescriptionF:GetWidth()-24)
	FCTabF.ADD.DescriptionF.E:SetFont(ChatFontNormal:GetFont(), 14,"OUTLINE")
	PIGSetFont(FCTabF.ADD.DescriptionF.E,14,"OUTLINE")
	FCTabF.ADD.DescriptionF.E:SetTextColor(0.6, 0.6, 0.6, 1)
	FCTabF.ADD.DescriptionF.E:SetAutoFocus(false)
	FCTabF.ADD.DescriptionF.E:SetMultiLine(true)
	FCTabF.ADD.DescriptionF.E:SetMaxLetters(50)
	FCTabF.ADD.DescriptionF.E:EnableMouse(true)
	FCTabF.ADD.DescriptionF.E.tishi = PIGFontString(FCTabF.ADD.DescriptionF.E,{"TOPLEFT",FCTabF.ADD.DescriptionF.E,"TOPLEFT",2,-0},"告诉车头你的特长及优势");
	FCTabF.ADD.DescriptionF.E.tishi:SetTextColor(0.8, 0.8, 0.8, 0.8);
	FCTabF.ADD.DescriptionF.E:SetScript("OnTextChanged", function(self)
		local txtv = self:GetText()
		if txtv=="" or txtv==" " then
			self.tishi:Show()
		else
			self.tishi:Hide()
		end
	end);
	local function DescriptionClearFocus()
		FCTabF.ADD.DescriptionF.E:SetTextColor(0.6, 0.6, 0.6, 1)
		FCTabF.ADD.DescriptionF.E:ClearFocus()
	end
	FCTabF.ADD.DescriptionF.E:SetScript("OnShow", function(self)
		self:SetText(PIGA["Tardis"]["Houche"]["Description"])
		FCTabF.Description=PIGA["Tardis"]["Houche"]["Description"]
	end);
	FCTabF.ADD.DescriptionF.E:SetScript("OnEscapePressed", function(self)
		DescriptionClearFocus()
	end);
	FCTabF.ADD.DescriptionF.E:SetScript("OnEditFocusGained", function(self)
		self:SetTextColor(1, 1, 1, 1)
	end);
	FCTabF.ADD.DescriptionF.E:SetScript("OnEnterPressed", function(self)
		local txtv = FCTabF.ADD.DescriptionF.E:GetText()
		FCTabF.Description=txtv
		PIGA["Tardis"]["Houche"]["Description"]=txtv
		DescriptionClearFocus()
	end);
    --
    FCTabF.ADD.ListGroupButton=PIGButton(FCTabF.ADD,{"BOTTOM",FCTabF.ADD,"BOTTOM",0,80},{100,30})
    FCTabF.ADD.ListGroupButton:Hide()
	FCTabF.ADD.ListGroupButton:HookScript("OnClick", function (self)
		local txtv = FCTabF.ADD.DescriptionF.E:GetText()
		FCTabF.Description=txtv
		PIGA["Tardis"]["Houche"]["Description"]=txtv
		if FCTabF.invOpen then
			FCTabF.invOpen=nil
			FCTabF.ADD:SetEditMode()
		else
			FCTabF.invOpen=true
			FCTabF.ADD:SetEditMode()
		end
	end);
	FCTabF.ADD.adderr=PIGFontString(FCTabF.ADD,{"BOTTOMLEFT",FCTabF.ADD.ListGroupButton,"TOPLEFT",0,4})
	FCTabF.ADD.adderr:SetTextColor(1,0,0,1);

	FCTabF.ADD.RemoveBut=PIGButton(FCTabF.ADD,{"LEFT",FCTabF.ADD.ListGroupButton,"RIGHT",200,0},{60,30},"退票")
	FCTabF.ADD.RemoveBut:Hide()
	FCTabF.ADD.RemoveBut:HookScript("OnClick", function (self)
		FCTabF.ADD:PIG_Clear()
		FCTabF.invOpen=nil
	end);
	function FCTabF.ADD:ListGroupButton_Update()
		DescriptionClearFocus()
		local errorText;
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			errorText = "你已经在一个队伍中了";
		end
		if self.Role.T.checkButton:GetChecked() or self.Role.H.checkButton:GetChecked() or self.Role.D.checkButton:GetChecked() then
			errorText = nil;
		else
			errorText = LFG_LIST_MUST_SELECT_ROLE;
		end
		self.adderr:SetText(errorText)
		self.ListGroupButton:SetEnabled(not errorText);
	end
	function FCTabF.ADD:PIG_Clear()
		FCTabF.ADD.ActivityDropDown:Hide()
		local fujk = self:GetParent()
		fujk.selectedCategory = nil;
		fujk.selectedGroup = nil;
		fujk.selectedActivity = nil;
		for ix=1,#tabheji do
			_G["ADD_Houche_guolv"..ix]:Enable()
			_G["ADD_Houche_guolv"..ix]:SetChecked(false)
		end
		self.GroupDropDown:Hide()
		self.ActivityDropDown:Hide()
		self.ActivityDropDown:PIGDownMenu_SetText("")
		self.Role:Hide()
		self.DescriptionF:Hide()
		self.ListGroupButton:Hide()
		self.RemoveBut:Hide()
	end
	function FCTabF.ADD:SetEditMode()
		if not FCTabF.ADD:IsVisible() then return end
		local fujk = self:GetParent()
		local ActivityGroups = C_LFGList.GetAvailableActivityGroups(FCTabF.selectedCategory)
		if fujk.selectedCategory~=120 and #ActivityGroups>0 then self.GroupDropDown:Show() end
		self.ActivityDropDown:Show()
		self.Role:Show()
		self.DescriptionF:Show()
		self.ListGroupButton:Show()
		PIG_Show_Role(FCTabF.invOpen)
		if FCTabF.invOpen then
			self.RemoveBut:Show()
			for ix=1,#tabheji do
				_G["ADD_Houche_guolv"..ix]:Disable()
			end
			self.GroupDropDown:Disable()
			self.ActivityDropDown:Disable()
			self.DescriptionF.E:Disable()
			self.DescriptionF:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
			self.ListGroupButton:SetText("改签")
		else
			self.RemoveBut:Hide()
			for ix=1,#tabheji do
				_G["ADD_Houche_guolv"..ix]:Enable()
			end
			self.GroupDropDown:Enable()
			self.ActivityDropDown:Enable()
			self.DescriptionF.E:Enable()
			self.DescriptionF:SetBackdropBorderColor(0, 1, 1, 1);
			self.ListGroupButton:SetText("购票")
			local activityGroups = C_LFGList.GetAvailableActivityGroups(fujk.selectedCategory)
			if #activityGroups==0 then
				fujk.selectedGroup=0 
			else
				fujk.selectedGroup=fujk.selectedGroup or activityGroups[1] or 0
				local Groupname = C_LFGList.GetActivityGroupInfo(fujk.selectedGroup)
				self.GroupDropDown:PIGDownMenu_SetText(Groupname)
			end
			local activities = C_LFGList.GetAvailableActivities(fujk.selectedCategory,fujk.selectedGroup)
			if #activities==0 then
				if fujk.selectedActivity then
					fujk.selectedActivity=fujk.selectedActivity
				else
					local _, _, _, _, battleGroundID = GetBattlegroundInfo(1);
					fujk.selectedActivity=battleGroundID or 0
				end
				for index = 1, GetNumBattlegroundTypes() do
					local localizedName, canEnter, isHoliday, isRandom, battleGroundID = GetBattlegroundInfo(index);
					if fujk.selectedActivity==battleGroundID then
						self.ActivityDropDown:PIGDownMenu_SetText(localizedName)
						break
					end
				end
			else
				fujk.selectedActivity=fujk.selectedActivity or activities[1] or 0
				local activityInfo = C_LFGList.GetActivityInfoTable(fujk.selectedActivity)
				self.ActivityDropDown:PIGDownMenu_SetText(activityInfo.fullName)
			end
		end
		self:ListGroupButton_Update()
	end
	----------
	local function fasongBendiMsg(waname)
		local Player =TalentData.SAVE_Player()
		local Tianfu =TalentData.GetTianfuTXT()
		local infoall = "!H"..Player.."#"..Tianfu.."#"..FCTabF.roleID.."#"..FCTabF.selectedActivity.."#"..FCTabF.Description
		PIGSendAddonMessage(Biaotou,infoall,"WHISPER",waname)
	end
	TabF:RegisterEvent("CHAT_MSG_CHANNEL");
	TabF:RegisterEvent("CHAT_MSG_ADDON");
	TabF:RegisterEvent("GROUP_ROSTER_UPDATE");
	TabF:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5,_,arg7,arg8,arg9)
		if event=="GROUP_ROSTER_UPDATE" and FCTabF.invOpen then
			C_Timer.After(1,function()
				if IsInGroup(LE_PARTY_CATEGORY_HOME) then
					FCTabF.invOpen=nil
				end
				FCTabF.ADD:SetEditMode()
			end)
		end
		if event=="CHAT_MSG_CHANNEL" then
			if FCTabF.invOpen then
				if arg9~=pindao then return end
				if arg1==GetInfoMsg..FCTabF.selectedCategory..FCTabF.selectedGroup..FCTabF.selectedActivity or arg1==GetInfoMsg..FCTabF.selectedCategory..FCTabF.selectedGroup.."0" then
					local waname = arg2
					if tocversion<40000 then
						waname = arg5
					end
					fasongBendiMsg(waname)
				end
			end
		end
		if event=="CHAT_MSG_ADDON" and arg1 == Biaotou then
			if arg3=="CHANNEL" then
				if FCTabF.invOpen then
					if arg8~=pindao then return end
					if arg2==GetInfoMsg..FCTabF.selectedCategory..FCTabF.selectedGroup..FCTabF.selectedActivity or arg2==GetInfoMsg..FCTabF.selectedCategory..FCTabF.selectedGroup.."0" then
						fasongBendiMsg(arg4)
					end
				end
			elseif arg3 == "WHISPER" then
				local qianzhui = arg2:sub(1,2)
				if qianzhui=="!H" then
					local waname = arg4
					if tocversion<40000 then
						waname = arg5
					end
					local houzhui = arg2:sub(3,-1)
					table.insert(TabF.JieshouInfoList, {houzhui,waname})
				end
			end
		end
	end)

end