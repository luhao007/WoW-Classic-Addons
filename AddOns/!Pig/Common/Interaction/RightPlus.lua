local addonName, addonTable = ...;
--------------------------------------------
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
----
local CommonInfo=addonTable.CommonInfo
local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
---
local listNameFun={
	[STATUS_TEXT_TARGET..INFO]=function(wanjiaName)
		if PIG_MaxTocversion() then
			C_FriendList.SendWho(WHO_TAG_EXACT..wanjiaName, Enum.SocialWhoOrigin.Item);
		else
			C_FriendList.SendWho(WHO_TAG_EXACT..wanjiaName, Enum.SocialWhoOrigin.ITEM);
		end
	end,
	[INVITE]=function(wanjiaName)
		PIG_InviteUnit(wanjiaName)
	end,
	[ADD_FRIEND]=function(wanjiaName)
		C_FriendList.AddFriend(wanjiaName)
	end,
	[INVITE..GUILD]=function(wanjiaName)
		GuildInvite(wanjiaName)
	end,
	[INVTYPE_RANGED..INSPECT]=function(wanjiaName)
		FasongYCqingqiu(wanjiaName)
	end,
	[CALENDAR_COPY_EVENT..NAME]=function(wanjiaName)
		local editBoxXX = ChatEdit_ChooseBoxForSend()
        local hasText = (editBoxXX:GetText() ~= "")
        ChatEdit_ActivateChat(editBoxXX)
		editBoxXX:Insert(wanjiaName)
        if (not hasText) then editBoxXX:HighlightText() end
	end,
	[IGNORE]=function(wanjiaName)
		C_FriendList.AddIgnore(wanjiaName)
	end,
	[BNET_REPORT..CHAT]=function(wanjiaName,mmsg)
		if wanjiaName and mmsg then
			local reportInfo = ReportInfo:CreateReportInfoFromType(Enum.ReportType.Chat);
			ReportFrame:InitiateReport(reportInfo, wanjiaName);
		end
	end,
}
addonTable.Fun.RightlistNameFun=listNameFun
--------------------
function CommonInfo.Interactionfun.RightPlus()
	if not PIGA["Interaction"]["RightPlus"] then return end
	if CommonInfo.RightPlusOpen then return end
	CommonInfo.RightPlusOpen=true
	if Menu and Menu.ModifyMenu then
		local function add_pigmenu(rootDescription, contextData,menulist)
		   	-- 在菜单末尾加入新按钮.
		   	local wanjiaName = contextData.name
			if contextData.server and PIG_OptionsUI.Realm~=contextData.server then
				wanjiaName = wanjiaName.."-"..contextData.server
			end
		    rootDescription:CreateDivider()
		    -- rootDescription:CreateTitle(addonName)
		    for i=1,#menulist do
		    	rootDescription:CreateButton(menulist[i], function() listNameFun[menulist[i]](wanjiaName) end)
		    end
		    -- 在菜单开始处加入按钮.
		    -- local title = MenuUtil.CreateTitle(addonName)
		    -- rootDescription:Insert(title, 1)
		    -- local button = MenuUtil.CreateButton("Inserted button", function() print("Clicked the inserted button!") end)
		    -- rootDescription:Insert(button, 6)
		    --local divider = MenuUtil.CreateDivider()
		    -- local divider = MenuUtil.GetDivider()
		   -- rootDescription:Insert(divider, 3)
	    end
	    local FRIEND_listName={INVTYPE_RANGED..INSPECT,STATUS_TEXT_TARGET..INFO,ADD_FRIEND,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME}
		Menu.ModifyMenu("MENU_UNIT_FRIEND", function(ownerRegion, rootDescription, contextData)
			add_pigmenu(rootDescription, contextData,FRIEND_listName)
		end)
		local SELF_listName={CALENDAR_COPY_EVENT..NAME}
		Menu.ModifyMenu("MENU_UNIT_SELF", function(ownerRegion, rootDescription, contextData)
		   	add_pigmenu(rootDescription, contextData,SELF_listName)
		end)
		local PLAYER_listName={INVTYPE_RANGED..INSPECT,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME}
		Menu.ModifyMenu("MENU_UNIT_PLAYER", function(ownerRegion, rootDescription, contextData)
		   	add_pigmenu(rootDescription, contextData,PLAYER_listName)
		end)
		Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", function(ownerRegion, rootDescription, contextData)
		   	add_pigmenu(rootDescription, contextData,PLAYER_listName)
		end)
		Menu.ModifyMenu("MENU_UNIT_PARTY", function(ownerRegion, rootDescription, contextData)
		   	add_pigmenu(rootDescription, contextData,PLAYER_listName)
		end)
		local TARGET_listName={CALENDAR_COPY_EVENT..NAME}
		Menu.ModifyMenu("MENU_UNIT_TARGET", function(ownerRegion, rootDescription, contextData)
			add_pigmenu(rootDescription, contextData,TARGET_listName)
		end)
		--/run Menu.PrintOpenMenuTags()
	else
		local caidanW,caidanH,zongHang=86,18,5
		local PigRightF=PIGFrame(UIParent,{"TOPLEFT",DropDownList1,"TOPRIGHT",0,-PIGA["Interaction"]["xiayijuli"]},{caidanW,caidanH*zongHang+16})
		PigRightF:SetFrameStrata("FULLSCREEN_DIALOG")
		PigRightF:Hide();
		if NDui then
			PigRightF:PIGSetBackdrop(0.7,nil,{0,0,0})
		elseif ElvUI then
			PigRightF:PIGSetBackdrop(0.7,nil,{0.06,0.06,0.06})
		else
			local bgFile=DropDownList1MenuBackdrop.NineSlice.Center:GetTexture()
			local beijing1,beijing2,beijing3,beijing4=DropDownList1MenuBackdrop.NineSlice.Center:GetVertexColor()
			local Biankuang1,Biankuang2,Biankuang3,Biankuang4=DropDownList1MenuBackdrop:GetBackdropBorderColor()
			PigRightF:SetBackdrop( { bgFile = bgFile,
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 14, 
				insets = { left = 4, right = 4, top = 4, bottom = 4 } });
			PigRightF:SetBackdropBorderColor(Biankuang1,Biankuang2,Biankuang3,Biankuang4);
			PigRightF:SetBackdropColor(beijing1,beijing2,beijing3,beijing4);
		end
		--
		local function ClickGongNeng(menuName,listName)
			local wanjiaName = UIDROPDOWNMENU_INIT_MENU.name
			--local unitX = UIDROPDOWNMENU_INIT_MENU.unit
			local serverX = UIDROPDOWNMENU_INIT_MENU.server
			if serverX and PIG_OptionsUI.Realm~=serverX then
				wanjiaName = wanjiaName.."-"..serverX
			end
			listNameFun[menuName](wanjiaName)
			PigRightF:Hide()
			CloseDropDownMenus()
		end
		-----------
		local function Show_RightF(listName)
			for i=1,zongHang do
				PigRightF.ButList[i]:Hide();
			end
			local num = #listName
			for i=1,num do
				PigRightF.ButList[i]:SetText(listName[i]);
				PigRightF.ButList[i]:Show();
			end
			PigRightF:SetHeight(caidanH*num+12);
			PigRightF:Show();
		end
		if PIG_MaxTocversion() then
			DropDownList1:HookScript("OnShow", function(self)
				Show_RightF(PigRightF.listName)
		    end)
			DropDownList1:HookScript("OnHide", function(self)
				PigRightF:Hide()
				DropDownList1.RF = nil;
		    end)
		    DropDownList1:SetScript("OnUpdate", function(self, elapsed)
		    		if ( self.shouldRefresh ) then
						UIDropDownMenu_RefreshDropDownSize(self);
						self.shouldRefresh = false;
					end
					if DropDownList1.RF then
						return;
					end
					if ( not self.showTimer or not self.isCounting ) then
						return;
					elseif ( self.showTimer < 0 ) then
						self:Hide();
						self.showTimer = nil;
						self.isCounting = nil;
					else
						self.showTimer = self.showTimer - elapsed;
					end
			end)
		    PigRightF:HookScript("OnEnter", function (self)
		    	DropDownList1.RF = true;
			end)
			PigRightF:HookScript("OnLeave", function (self)
				DropDownList1.RF = nil;
			end)
		else
			UIParent:HookScript("OnEvent", function(self,event,arg1)
				if event == "GLOBAL_MOUSE_DOWN" and (arg1 == "LeftButton" or arg1 == "RightButton") then
					if PigRightF:IsShown() and not PigRightF:IsMouseOver() then
						PigRightF:Hide()
					end
				end
			end); 
		end
		------
		PigRightF.listName={INVTYPE_RANGED..INSPECT,STATUS_TEXT_TARGET..INFO,ADD_FRIEND,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME}
		PigRightF.listName2={INVTYPE_RANGED..INSPECT,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME}
		PigRightF.ButList={}
		for i=1,zongHang do
			local tabhang = CreateFrame("Button", nil, PigRightF,"UIDropDownMenuButtonTemplate");
			PigRightF.ButList[i]=tabhang
			tabhang:SetSize(caidanW-8,caidanH);
			if i==1 then
				tabhang:SetPoint("TOPLEFT", PigRightF, "TOPLEFT", 4, -6);
			else
				tabhang:SetPoint("TOPLEFT", PigRightF.ButList[i-1], "BOTTOMLEFT", 0, 0);
			end
			-- _G["RightF_TAB_"..i.."NormalText"]:SetPoint("LEFT", tabhang, "LEFT", 4, 0);
			-- _G["RightF_TAB_"..i.."Check"]:Hide()
			-- _G["RightF_TAB_"..i.."UnCheck"]:Hide()
			tabhang:SetScript("OnEnter", function (self)
				self.Highlight:Show()
				if PIG_MaxTocversion() then DropDownList1.RF = true end
			end)
			tabhang:SetScript("OnLeave", function (self)
				self.Highlight:Hide()
				if PIG_MaxTocversion() then DropDownList1.RF = nil end
			end)
			tabhang:SetScript("OnClick", function(self)
				ClickGongNeng(self:GetText(),PigRightF)
			end);
		end
		hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
			--print(dropdownMenu:GetName())print(which)print(unit)print(name)print(userData)
	        if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
	        PigRightF:Hide()
	        if dropdownMenu:GetName() == "FriendsDropDown" then
		        if which == "FRIEND" or which == "CHAT_ROSTER" or which == "RAID" then
					Show_RightF(PigRightF.listName)
		        end
		    end
		    if which == "CHAT_ROSTER" then--聊天频道
	        	Show_RightF(PigRightF.listName)
	        end
		    if dropdownMenu:GetName() == "TargetFrameDropDown" or which == "TARGET" then--目标
		    	if UnitIsPlayer(unit) then
					Show_RightF(PigRightF.listName2)
				else
					Show_RightF({CALENDAR_COPY_EVENT..NAME})
				end
		    end
			if which == "PLAYER" or which == "PARTY" or which == "RAID_PLAYER" then--团队框架
				Show_RightF(PigRightF.listName2)
			end
	    end)
	end
end