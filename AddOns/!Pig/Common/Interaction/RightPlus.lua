local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
--------------------------------------------
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
----
local CommonInfo=addonTable.CommonInfo
local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
---
local function ClickGongNeng(menuName,PigRightF)
	local wanjiaName = UIDROPDOWNMENU_INIT_MENU.name
	--local unitX = UIDROPDOWNMENU_INIT_MENU.unit
	local serverX = UIDROPDOWNMENU_INIT_MENU.server
	if tocversion<100000 then
		if serverX and Pig_OptionsUI.Realm~=serverX then
			wanjiaName = wanjiaName.."-"..serverX
		end
	else
		local serverX = serverX or Pig_OptionsUI.Realm
		wanjiaName = wanjiaName.."-"..serverX
	end
	if menuName==PigRightF.listName[1] then
		C_FriendList.SendWho('n-'..'"'..wanjiaName..'"')
	end
	if menuName==PigRightF.listName[2] then
		C_FriendList.AddFriend(wanjiaName)
	end
	if menuName==PigRightF.listName[3] then
		GuildInvite(wanjiaName)
	end
	if menuName==PigRightF.listName[4] then
		local editBoxXX = ChatEdit_ChooseBoxForSend()
        local hasText = (editBoxXX:GetText() ~= "")
        ChatEdit_ActivateChat(editBoxXX)
		editBoxXX:Insert(wanjiaName)
        if (not hasText) then editBoxXX:HighlightText() end
	end
	if menuName==PigRightF.listName[5] then
		FasongYCqingqiu(wanjiaName)
	end
	Pig_RightFUI:Hide()
	CloseDropDownMenus()
end
-----------
local caidanW,caidanH,zongHang=86,18,5
local function Show_RightF(listName)
	for i=1,zongHang do
		_G["RightF_TAB_"..i]:Hide();
	end
	local num = #listName
	for i=1,num do
		_G["RightF_TAB_"..i].Title:SetText(listName[i]);
		_G["RightF_TAB_"..i]:Show();
	end
	Pig_RightFUI:SetHeight(caidanH*num+12);
	Pig_RightFUI:Show();
end
--------------------
function CommonInfo.Interactionfun.RightPlus()
	if not PIGA["Interaction"]["RightPlus"] then return end
	if Pig_RightFUI then return end
	if tocversion<110000 then
		local beijingico=DropDownList1MenuBackdrop.NineSlice.Center:GetTexture()
		local beijing1,beijing2,beijing3,beijing4=DropDownList1MenuBackdrop.NineSlice.Center:GetVertexColor()
		local Biankuang1,Biankuang2,Biankuang3,Biankuang4=DropDownList1MenuBackdrop:GetBackdropBorderColor()
		local PigRightF=PIGFrame(UIParent,{"TOPLEFT",DropDownList1,"TOPRIGHT",0,-PIGA["Interaction"]["xiayijuli"]},{caidanW,caidanH*zongHang+16},"Pig_RightFUI")
		PigRightF:SetFrameStrata("FULLSCREEN_DIALOG")
		PigRightF:Hide();
		if ElvUI or NDui then
			PigRightF:PIGSetBackdrop(0.8)
		else
			PigRightF:SetBackdrop( { bgFile = beijingico,
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 14, 
				insets = { left = 4, right = 4, top = 4, bottom = 4 } });
			PigRightF:SetBackdropBorderColor(Biankuang1,Biankuang2,Biankuang3,Biankuang4);
			PigRightF:SetBackdropColor(beijing1,beijing2,beijing3,beijing4);
		end
		--
		if tocversion<100000 then
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
						Pig_RightFUI:Hide()
					end
				end
			end); 
		end
		------
		PigRightF.listName={STATUS_TEXT_TARGET..INFO,ADD_FRIEND,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME,INVTYPE_RANGED..INSPECT}
		PigRightF.listName2={INVITE..GUILD,CALENDAR_COPY_EVENT..NAME,INVTYPE_RANGED..INSPECT}
		for i=1,zongHang do
			local PigRightF_TAB = CreateFrame("Button", "RightF_TAB_"..i, PigRightF);
			PigRightF_TAB:SetSize(caidanW-8,caidanH);
			if i==1 then
				PigRightF_TAB:SetPoint("TOPLEFT", PigRightF, "TOPLEFT", 4, -6);
			else
				PigRightF_TAB:SetPoint("TOPLEFT", _G["RightF_TAB_"..(i-1)], "BOTTOMLEFT", 0, 0);
			end
			PigRightF_TAB.Title = PIGFontString(PigRightF_TAB,{"LEFT", PigRightF_TAB, "LEFT", 6, 0},nil,"OUTLINE")
			PigRightF_TAB.Title:SetTextColor(1, 1, 1, 1)
			PigRightF_TAB.highlight1 = PigRightF_TAB:CreateTexture(nil, "BORDER");
			PigRightF_TAB.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
			PigRightF_TAB.highlight1:SetPoint("CENTER", PigRightF_TAB, "CENTER", 0,0);
			PigRightF_TAB.highlight1:SetSize(caidanW-8,caidanH);
			PigRightF_TAB.highlight1:SetAlpha(0.9);
			PigRightF_TAB.highlight1:Hide();
			PigRightF_TAB:HookScript("OnEnter", function (self)
				self.highlight1:Show()
				if tocversion<100000 then DropDownList1.RF = true end
			end)
			PigRightF_TAB:HookScript("OnLeave", function (self)
				self.highlight1:Hide()
				if tocversion<100000 then DropDownList1.RF = nil end
			end)
			PigRightF_TAB:SetScript("OnMouseDown", function(self)
				self.Title:SetPoint("LEFT", self, "LEFT", 7.4, -1.4);
			end);
			PigRightF_TAB:SetScript("OnMouseUp", function(self)
				self.Title:SetPoint("LEFT", self, "LEFT", 6, 0);
			end);
			PigRightF_TAB:SetScript("OnClick", function(self)
				ClickGongNeng(self.Title:GetText(),PigRightF)
			end);
		end
		hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
			--print(dropdownMenu:GetName())print(which)print(unit)print(name)print(userData)
	        if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
	        Pig_RightFUI:Hide()
	        if dropdownMenu:GetName() == "FriendsDropDown" then
		        if which == "FRIEND" or which == "CHAT_ROSTER" or which == "RAID" then
					Show_RightF(PigRightF.listName)
		        end
		    end
		    if which == "CHAT_ROSTER" then--聊天频道
	        	Show_RightF(PigRightF.listName)
	        end
		    if dropdownMenu:GetName() == "TargetFrameDropDown" then--目标
				Show_RightF(PigRightF.listName2)
		    end
			if which == "PLAYER" or which == "PARTY" or which == "RAID_PLAYER" then--团队框架
				Show_RightF(PigRightF.listName2)
			end
	    end)
	else
		Menu.ModifyMenu("MENU_UNIT_FRIEND", function(ownerRegion, rootDescription, contextData)
		    -- Append a new section to the end of the menu.
		    -- rootDescription:CreateDivider()
		    -- rootDescription:CreateTitle(addonName)
		    -- rootDescription:CreateButton("Appended button", function() print("Clicked the appended button!") end)

		    -- -- Insert a new section at the start of the menu.
		    -- local title = MenuUtil.CreateTitle(addonName)
		    -- rootDescription:Insert(title, 1)
		    -- local button = MenuUtil.CreateButton("Inserted button", function() print("Clicked the inserted button!") end)
		    -- rootDescription:Insert(button, 2)
		    -- local divider = MenuUtil.CreateDivider()
		    -- rootDescription:Insert(divider, 3)
		end)
	end
end