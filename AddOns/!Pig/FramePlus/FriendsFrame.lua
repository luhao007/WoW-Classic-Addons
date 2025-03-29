local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local GetRaceClassTXT=addonTable.Fun.GetRaceClassTXT
local ClasseNameID=addonTable.Data.ClasseNameID
local PIGraceList=addonTable.Data.PIGraceList
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
-------------
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Friends()
	if not PIGA["FramePlus"]["Friends"] then return end
	FriendsFrame:Hide()
	local www = FriendsFrame:GetWidth()
	local butWidth_2 = www*2
	local butWidth = www*2-40
	FriendsFrame:SetWidth(butWidth_2)
	local hangH,iconH,texW = 28,16,500
	--在线状态
	local FriendsFrameStatusDropdown=FriendsFrameStatusDropdown or FriendsFrameStatusDropDown
	local wwwdd = FriendsFrameStatusDropdown:GetWidth()
	FriendsFrameStatusDropdown:SetWidth(wwwdd+6)
	--好友列表
	if FriendsFrameFriendsScrollFrame then
		FriendsFrameFriendsScrollFrame:SetWidth(butWidth)
		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		local buttons = FriendsFrameFriendsScrollFrame.buttons
		for ix=1,#buttons do
			local xuio = _G["FriendsFrameFriendsScrollFrameButton"..ix]
			xuio:SetWidth(butWidth)
			xuio.info:SetWidth(www-90)
		end
	else
		FriendsListFrame.ScrollBox:SetWidth(butWidth)
	end
    ----  
    local playerRealmID = Pig_OptionsUI.Realm
    local playerFactionGroup = UnitFactionGroup("player");
    local function Show_jueseinfo(acc_data,button,accountName)
     	if not acc_data[1] and not acc_data[2] then return end
     	local _pig_iconH_1=iconH
		if acc_data[2] then	
			_pig_iconH_1=iconH-3
		end
		local _, _,_, _, sexBNET = acc_data[1][1] and GetPlayerInfoByGUID(acc_data[1][1])
		local raceX,classX = GetRaceClassTXT(_pig_iconH_1,texW,PIGraceList[acc_data[1][3]],sexBNET or 2,ClasseNameID[acc_data[1][4]])
		local Newtxt = raceX.." "..classX.." (Lv"..acc_data[1][5]..") "..acc_data[1][2]
		local color = PIG_CLASS_COLORS[ClasseNameID[acc_data[1][4]]]
		local argbHex=color and color.colorStr or "ffffffff"
		local zhu_TXT=accountName.." \124c"..argbHex..Newtxt.."\124r"
		local zhu_TXT_info=button.info:GetText() or UNKNOWN
		if acc_data[1][6] == WOW_PROJECT_MAINLINE then--正式服
			if acc_data[1][7] ~= playerRealmID then
				zhu_TXT_info=acc_data[1][9]
			end
		elseif acc_data[1][6] == WOW_PROJECT_CLASSIC then--60
			if acc_data[1][7] ~= playerRealmID then
				if acc_data[1][8] and acc_data[1][8] ~= "" then
					zhu_TXT_info=zhu_TXT_info.." "..acc_data[1][8]
				end
			end
		elseif acc_data[1][6] == 11 then--80
			if acc_data[1][7] ~= playerRealmID then
				if acc_data[1][8] and acc_data[1][8] ~= "" then
					zhu_TXT_info=zhu_TXT_info.." "..acc_data[1][8]
				end
			end
		end
		if acc_data[2] then
			button.name:SetHeight(iconH*2);
			local _, _,_, _, sexBNET = acc_data[2][1] and GetPlayerInfoByGUID(acc_data[2][1])
			local raceX,classX = GetRaceClassTXT(_pig_iconH_1,texW,PIGraceList[acc_data[2][3]],sexBNET or 2,ClasseNameID[acc_data[2][4]])
			local Newtxt = raceX.." "..classX.." (Lv"..acc_data[2][5]..") "..acc_data[2][2]
			local color = PIG_CLASS_COLORS[ClasseNameID[acc_data[2][4]]]
			local argbHex=color and color.colorStr or "ffffffff"
			zhu_TXT=zhu_TXT.."\n"..accountName.." \124c"..argbHex..Newtxt.."\124r"
			if acc_data[2][6] == WOW_PROJECT_MAINLINE then--正式服
				if acc_data[2][7] ~= playerRealmID then
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][9]
				else
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][8]
				end
			elseif acc_data[2][6] == WOW_PROJECT_CLASSIC then--60
				if acc_data[2][7] ~= playerRealmID then
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][9]..acc_data[2][8]
				else
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][8]
				end
			elseif acc_data[2][6] == 11 then--80

				if acc_data[2][7] ~= playerRealmID then
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][9]..acc_data[2][8]
				else
					zhu_TXT_info=zhu_TXT_info.."\n"..acc_data[2][8]
				end
			end
		end
		button.name:SetText(zhu_TXT);
		button.info:SetText(zhu_TXT_info);
	end
    local function PIGUpdateFriendButton(button, elementData)
    	if not button.status then return end
		button.status:ClearAllPoints();
		button.status:SetPoint("LEFT",button,"LEFT",4,0);
		button.name:ClearAllPoints();
		button.name:SetPoint("LEFT",button,"LEFT",20,0);
		button.name:SetSize(www-20,button:GetHeight())
		button.info:ClearAllPoints();
		button.info:SetPoint("LEFT",button.name,"RIGHT",0,0);
		button.info:SetSize(www-20,button:GetHeight())
		button.gameIcon:ClearAllPoints();
		button.gameIcon:SetPoint("RIGHT",button,"RIGHT",-28,0);
		button.gameIcon:SetSize(20,20);
		button.travelPassButton:ClearAllPoints();
		button.travelPassButton:SetPoint("RIGHT",button,"RIGHT",-1,0);
		button.travelPassButton:SetSize(24,hangH-2);
		if button.Favorite then 
			button.Favorite:ClearAllPoints();
			button.Favorite:SetPoint("RIGHT",button.name,"RIGHT",0,0);
		end
		local id,buttonType
		if elementData then
			id = elementData.id;
			buttonType = elementData.buttonType;
		else
			buttonType = button.buttonType
			id = button.id
		end
		if buttonType == FRIENDS_BUTTON_TYPE_WOW then
			local info = C_FriendList.GetFriendInfoByIndex(id);
			if ( info.connected ) then
				local localizedClass, englishClass,localizedRace, englishRace, sex = GetPlayerInfoByGUID(info.guid)
				local color2 = PIG_CLASS_COLORS[englishClass];
				local color=color2 or {r=1,g=1,b=1}
				button.name:SetTextColor(color.r, color.g, color.b);
				local raceX,classX = GetRaceClassTXT(iconH,texW,englishRace,sex,englishClass)
				local raceXclass = raceX.." "..classX
				local Newtxt = raceXclass.." (Lv"..info.level..") "..info.name
				button.name:SetText(Newtxt);
			end
		elseif buttonType == FRIENDS_BUTTON_TYPE_BNET then
			if C_BattleNet and C_BattleNet.GetFriendAccountInfo then
				local accountInfo = C_BattleNet.GetFriendAccountInfo(id);
				if accountInfo then
					if accountInfo.gameAccountInfo.isOnline then
						local piginfo_acc={nil,nil}
						local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(id);
						for Accid=1,numGameAccounts do
						    local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(id, Accid);
							if gameAccountInfo and gameAccountInfo.clientProgram==BNET_CLIENT_WOW then
								local juese_AccountInfo = {
									gameAccountInfo.playerGuid,gameAccountInfo.characterName,gameAccountInfo.raceName,gameAccountInfo.className,
									gameAccountInfo.characterLevel,gameAccountInfo.wowProjectID,gameAccountInfo.realmName,gameAccountInfo.areaName, gameAccountInfo.richPresence
								}
								if not piginfo_acc[1] then
									piginfo_acc[1]=juese_AccountInfo
								elseif not piginfo_acc[2] then
									piginfo_acc[2]=juese_AccountInfo
								end
								if piginfo_acc[1] and piginfo_acc[2] then
									break
								end
							end
						end
						Show_jueseinfo(piginfo_acc,button,accountInfo.accountName)
					end
				end
			else
				local bnetIDAccount, accountName, _, _, _, _, _, isOnline = BNGetFriendInfo(id);
				if accountName and isOnline then
					local piginfo_acc={nil,nil}
					local numGameAccounts = BNGetNumFriendGameAccounts(id);
					for Accid=1,numGameAccounts do
						local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, zoneName, level, gameText, _, _, _, _, _, _, _, Guid, wowProjectID = BNGetFriendGameAccountInfo(id, Accid);
						if client==BNET_CLIENT_WOW then--BNET_CLIENT_APP
							local juese_AccountInfo = {Guid,characterName,race,class,level,wowProjectID,realmName,zoneName, gameText}
							if not piginfo_acc[1] then
								piginfo_acc[1]=juese_AccountInfo
							elseif not piginfo_acc[2] then
								piginfo_acc[2]=juese_AccountInfo
							end
							if piginfo_acc[1] and piginfo_acc[2] then
								break
							end
						end
					end
					Show_jueseinfo(piginfo_acc,button,accountName)
				end
			end
		end
	end
	local function PIGUpdateFriendFrame()
		local buttons = FriendsFrameFriendsScrollFrame.buttons
		for i = 1, #buttons do
			PIGUpdateFriendButton(buttons[i])
		end
	end
	-- 
	if FriendsFrameFriendsScrollFrame then
		hooksecurefunc("FriendsList_Update", function(forceUpdate)
			PIGUpdateFriendFrame()
		end)
		hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", function(self)
			PIGUpdateFriendFrame()
		end)
		-- FriendsFrameFriendsScrollFrame:HookScript("OnMouseWheel", function()
		--    	local buttons = FriendsFrameFriendsScrollFrame.buttons
		-- 	for i = 1, #buttons do
		-- 		buttons[i].name:SetHeight(buttons[i]:GetHeight())
		-- 		buttons[i].info:SetHeight(buttons[i]:GetHeight())
		-- 	end
		-- end)
	else
		hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button, elementData)
			PIGUpdateFriendButton(button, elementData)	
		end)
		if NDui then
			hooksecurefunc(FriendsListFrame.ScrollBox, "Update", function(self)
				for i = 1, self.ScrollTarget:GetNumChildren() do
					local button = select(i, self.ScrollTarget:GetChildren())
					PIGUpdateFriendButton(button)	
				end
			end)
		end
	end

	--屏蔽页
	if tocversion>100000 and tocversion<110000 then

	elseif tocversion<50000 then
		FriendsFrameIgnoreScrollFrame:SetWidth(butWidth)
		for i = 1, IGNORES_TO_DISPLAY, 1 do
			local button = _G["FriendsFrameIgnoreButton"..i]
			button:SetWidth(butWidth)
			button.name:SetWidth(butWidth-10)
		end
	end

	--招募页
	if RecruitAFriendFrame then
		local anchorsWithBar = {--有滚动没出现时的定位
	        CreateAnchor("TOPLEFT", RecruitAFriendFrame.RecruitList, "TOPLEFT", 8, -87),
	        CreateAnchor("BOTTOMRIGHT", RecruitAFriendFrame.RecruitList, "BOTTOMRIGHT", -28, 29),
	    }
	    local anchorsWithoutBar = {--没滚动没出现时的定位
	        CreateAnchor("TOPLEFT", RecruitAFriendFrame.RecruitList, "TOPLEFT", 8, -87),
	        CreateAnchor("BOTTOMRIGHT", RecruitAFriendFrame.RecruitList, "BOTTOMRIGHT", -10, 29),
	    } 
	    ScrollUtil.AddManagedScrollBarVisibilityBehavior(RecruitAFriendFrame.RecruitList.ScrollBox, RecruitAFriendFrame.RecruitList.ScrollBar, anchorsWithBar, anchorsWithoutBar)
		RecruitAFriendFrame.RecruitList.Header:SetPoint("TOPRIGHT",RecruitAFriendFrame.RecruitList,"TOPRIGHT",0,0);
		RecruitAFriendFrame.RecruitList.Header.Background:ClearAllPoints();
		RecruitAFriendFrame.RecruitList.Header.Background:SetHeight(20)
		RecruitAFriendFrame.RecruitList.Header.Background:SetPoint("TOPLEFT",RecruitAFriendFrame.RecruitList.Header,"TOPLEFT",-3,0);
		RecruitAFriendFrame.RecruitList.Header.Background:SetPoint("TOPRIGHT",RecruitAFriendFrame.RecruitList.Header,"TOPRIGHT",0,0);
		RecruitAFriendFrame.RewardClaiming.Background:ClearAllPoints();
		RecruitAFriendFrame.RewardClaiming.Background:SetPoint("TOPLEFT",RecruitAFriendFrame.RewardClaiming,"TOPLEFT",0,-5);
		RecruitAFriendFrame.RewardClaiming.Background:SetPoint("TOPRIGHT",RecruitAFriendFrame.RewardClaiming,"TOPRIGHT",0,0);
	end

	--查询页
	local WhohangH,WhoiconH=17.2,14
	local WhoFrameHeaderP={24,24,24,190,188,200}
	if tocversion>100000 and tocversion<110000 then

	elseif tocversion<50000 then
		if NDui then
			WhoFrameHeaderP={26,26,26,190,180,200}
		else
			WhoFrameHeaderP={26,26,26,190,180,200}
		end
	end
	WhoFrameEditBox:SetHeight(32);
	WhoFrameEditBox:ClearAllPoints();
	WhoFrameTotals:SetPoint("BOTTOM",WhoFrameListInset,"BOTTOM",-80,-39)
	WhoFrameEditBox:SetPoint("BOTTOMLEFT",WhoFrame,"BOTTOMLEFT",10,20);
	WhoFrameEditBox:SetPoint("BOTTOMRIGHT",WhoFrame,"BOTTOMRIGHT",-10,20);
	if ElvUI then
		local E= unpack(ElvUI)
		if E.private.skins.blizzard.enable and E.private.skins.blizzard.friends then
			WhoFrameEditBox:SetPoint("BOTTOMLEFT",WhoFrame,"BOTTOMLEFT",10,30);
			WhoFrameEditBox:SetPoint("BOTTOMRIGHT",WhoFrame,"BOTTOMRIGHT",-10,28);
		end
	end
	local ColumnHeader0 = CreateFrame("Button","WhoFrameColumnHeader0",WhoFrame, "WhoFrameColumnHeaderTemplate")
	ColumnHeader0:SetText("*")
	ColumnHeader0:SetPoint("TOPLEFT",WhoFrame,"TOPLEFT",7,-60);
	ColumnHeader0:SetScript("OnClick", function(self)
		C_FriendList.SortWho("race");
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end)
	WhoFrameColumnHeader2:SetText(ZONE)
	WhoFrameColumnHeader2:SetScript("OnClick", function(self)
		C_FriendList.SortWho("zone");
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end)
	WhoFrameColumnHeader4:SetText("*")
	WhoFrameColumnHeader4:ClearAllPoints();
	WhoFrameColumnHeader4:SetPoint("LEFT",WhoFrameColumnHeader0,"RIGHT",-2,0);
	WhoFrameColumnHeader3:SetText("*")
	WhoFrameColumnHeader3:ClearAllPoints();
	WhoFrameColumnHeader3:SetPoint("LEFT",WhoFrameColumnHeader4,"RIGHT",-2,0);
	WhoFrameColumnHeader1:ClearAllPoints();
	WhoFrameColumnHeader1:SetPoint("LEFT",WhoFrameColumnHeader3,"RIGHT",-2,0);
	local ColumnHeader9 = CreateFrame("Button","WhoFrameColumnHeader9",WhoFrame, "WhoFrameColumnHeaderTemplate")
	ColumnHeader9:SetText(GUILD)
	ColumnHeader9:SetPoint("LEFT",WhoFrameColumnHeader2,"RIGHT",-2,0);
	ColumnHeader9:SetScript("OnClick", function(self)
		C_FriendList.SortWho("guild");
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end)			
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader0, WhoFrameHeaderP[1])
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader4, WhoFrameHeaderP[2])
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader3, WhoFrameHeaderP[3])
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader1, WhoFrameHeaderP[4])
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader2, WhoFrameHeaderP[5])
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader9, WhoFrameHeaderP[6])
	local WhoFrameDropDown=WhoFrameDropDown or WhoFrameDropdown
	WhoFrameDropDown:Hide()
	local function Hide_Header()
		WhoFrameColumnHeader0.Left:Hide()
		WhoFrameColumnHeader0.Right:Hide()
		WhoFrameColumnHeader0.Middle:Hide()
		WhoFrameColumnHeader9.Left:Hide()
		WhoFrameColumnHeader9.Right:Hide()
		WhoFrameColumnHeader9.Middle:Hide()
	end
	if NDui then
		Hide_Header()
	elseif ElvUI then
		local E= unpack(ElvUI)
		if E.private.skins.blizzard.enable and E.private.skins.blizzard.friends then
			Hide_Header()
		end
	end
	if WhoListScrollFrame then
		local function PIGWhoList_But(elvuiopen)
			WhoFrameColumn_SetWidth(WhoFrameColumnHeader1, WhoFrameHeaderP[4]-10)
			WhoFrameColumnHeader4:SetWidth(26)
			WhoFrameColumnHeader4:ClearAllPoints();
			WhoFrameColumnHeader4:SetPoint("LEFT",WhoFrameColumnHeader0,"RIGHT",-2,0);
			WhoFrameColumnHeader3:ClearAllPoints();
			WhoFrameColumnHeader3:SetPoint("LEFT",WhoFrameColumnHeader4,"RIGHT",-2,0);
			WhoFrameColumnHeader1:ClearAllPoints();
			WhoFrameColumnHeader1:SetPoint("LEFT",WhoFrameColumnHeader3,"RIGHT",-2,0);
			for i=1, WHOS_TO_DISPLAY, 1 do
				local button = _G["WhoFrameButton"..i];
				button:SetWidth(butWidth)
				button:SetHeight(WhohangH)
				local highlightTTT=button.highlightGradient or button:GetHighlightTexture()
				if highlightTTT then highlightTTT:SetAllPoints(button) end
				local ClassText = _G["WhoFrameButton"..i.."Class"];
				local LevelText = _G["WhoFrameButton"..i.."Level"];
				local NameText = _G["WhoFrameButton"..i.."Name"];
				local variableText = _G["WhoFrameButton"..i.."Variable"];
				ClassText:ClearAllPoints();
				if elvuiopen then
					ClassText:SetPoint("LEFT", button, "LEFT", -6, 0);
					if button.icon then button.icon:SetAlpha(0) end
					if button.backdrop then button.backdrop:SetAlpha(0) end
				elseif NDui then
					ClassText:SetPoint("LEFT", button, "LEFT", 4, 0);
				else
					ClassText:SetPoint("LEFT", button, "LEFT", 6, 0);
				end
				ClassText:SetJustifyH("CENTER")
				ClassText:SetWidth(WhoFrameHeaderP[2]+WhoFrameHeaderP[3])
				LevelText:ClearAllPoints();
				if NDui then
					LevelText:SetPoint("LEFT", ClassText, "RIGHT", 0, 0);
				elseif elvuiopen then
					LevelText:SetPoint("LEFT", ClassText, "RIGHT", -13, 0);
				else
					LevelText:SetPoint("LEFT", ClassText, "RIGHT", -8, 0);
				end
				LevelText:SetWidth(WhoFrameHeaderP[3])
				LevelText:SetJustifyH("RIGHT")
				NameText:ClearAllPoints();
				if NDui then
					NameText:SetPoint("LEFT", LevelText, "RIGHT", -6, 0);
				else
					NameText:SetPoint("LEFT", LevelText, "RIGHT", 6, 0);
				end
				NameText:SetWidth(WhoFrameHeaderP[4]-6)
				variableText:SetWidth(WhoFrameHeaderP[5])
				button.Guild = PIGFontString(button,{"LEFT", _G["WhoFrameButton"..i.."Variable"], "RIGHT", 0, 0})
				button.Guild:SetSize(WhoFrameHeaderP[6]-2,WhoiconH)
				button.Guild:SetJustifyH("LEFT")
				button.Guild:SetFont(NameText:GetFont())
			end
		end
		WhoListScrollFrame:SetWidth(butWidth)
		if ElvUI then
			local E= unpack(ElvUI)
			if E.private.skins.blizzard.enable and E.private.skins.blizzard.friends then
				C_Timer.After(1,function()
					PIGWhoList_But(true)
				end)	
			end
		else
			PIGWhoList_But()
		end
		hooksecurefunc("WhoList_Update", function()
			WhoFrameColumnHeader2:SetWidth(WhoFrameHeaderP[5]);
			local name = WhoFrameColumnHeader2:GetName().."Middle";
			local middleFrame = _G[name];
			if middleFrame then
				middleFrame:SetWidth(WhoFrameHeaderP[5] - 9);
			end
			local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame);
			for i=1, WHOS_TO_DISPLAY, 1 do
				whoIndex = whoOffset + i;
				local button = _G["WhoFrameButton"..i];
				button.tooltip1 = nil;
				button.tooltip2 = nil;
				local NameText = _G["WhoFrameButton"..i.."Name"];
				local ClassText = _G["WhoFrameButton"..i.."Class"];
				local LevelText = _G["WhoFrameButton"..i.."Level"];
				local variableText = _G["WhoFrameButton"..i.."Variable"];
				variableText:SetWidth(WhoFrameHeaderP[5])
				NameText:ClearAllPoints();
				if NDui then
					NameText:SetPoint("LEFT", LevelText, "RIGHT", -6, 0);
				else
					NameText:SetPoint("LEFT", LevelText, "RIGHT", 6, 0);
				end
				if ElvUI and FriendsFrame.backdrop then
					C_Timer.After(0.001,function()
						ClassText:Show()
						if button.icon then button.icon:Hide() end
						if button.backdrop then button.backdrop:Hide() end
					end)
				end
				--
				local info = C_FriendList.GetWhoInfo(whoIndex);
				if info then
					variableText:SetText(info.area)
					button.Guild:SetText(info.fullGuildName)
					local color2 = PIG_CLASS_COLORS[info.filename];
					local color=color2 or {r=1,g=1,b=1}
					NameText:SetTextColor(color.r, color.g, color.b);
					LevelText:SetTextColor(color.r, color.g, color.b);
					variableText:SetTextColor(color.r, color.g, color.b);
					button.Guild:SetTextColor(color.r, color.g, color.b);
					local raceX,classX = GetRaceClassTXT(WhoiconH,texW,PIGraceList[info.raceStr],info.gender,info.filename)
					local kogngeW = " "
					if NDui then
						kogngeW= " "
					elseif ElvUI and FriendsFrame.backdrop then
						kogngeW= "  "
					end
					ClassText:SetText(raceX..kogngeW..classX);
					if variableText:IsTruncated() or button.Guild:IsTruncated() then
						button.tooltip1 = info.fullName.." - "..info.area;
						button.tooltip2 = info.fullGuildName;
					end
				end
				if WhoFrame.senmsg then WhoFrame.senmsg.listUpdate(button) end
			end
		end)
	else
		WhoFrame.ScrollBox:SetPoint("BOTTOMRIGHT",FriendsFrameInset,"BOTTOMRIGHT",-22,22);
		WhoFrame.ScrollBar:SetPoint("BOTTOMLEFT",WhoFrame.ScrollBox,"BOTTOMRIGHT",5,2);
		WhoFrame.ScrollBox.view:SetElementExtent(WhohangH)
		hooksecurefunc("WhoList_InitButton", function(button, elementData)
			button.tooltip1 = nil;
			button.tooltip2 = nil;
			if not button.Guild then 
				local Fontname,FontSize=button.Name:GetFont()
				button.Guild = PIGFontString(button,{"LEFT", button.Variable, "RIGHT", 0, 0})
				button.Guild:SetSize(WhoFrameHeaderP[6]-2,WhoiconH)
				button.Guild:SetJustifyH("LEFT")
				button.Guild:SetFont(Fontname,FontSize)
			end
			button.Class:ClearAllPoints();
			button.Class:SetPoint("LEFT", button, "LEFT", 0, 0);
			button.Class:SetJustifyH("CENTER")
			button.Class:SetWidth(WhoFrameHeaderP[1]+WhoFrameHeaderP[2])
			button.Level:ClearAllPoints();
			button.Level:SetPoint("LEFT", button.Class, "RIGHT", 0, 0);
			button.Level:SetWidth(WhoFrameHeaderP[3]-2)
			button.Level:SetJustifyH("CENTER")
			button.Name:ClearAllPoints();
			button.Name:SetPoint("LEFT", button.Level, "RIGHT", 4, 0);
			button.Name:SetWidth(WhoFrameHeaderP[4]-6)
			button.Variable:SetWidth(WhoFrameHeaderP[5])
			------
			local HighlightTex = button:GetHighlightTexture()
			HighlightTex:SetAllPoints(button)
			local info = elementData.info;
			local color2 = PIG_CLASS_COLORS[info.filename];
			local color=color2 or {r=1,g=1,b=1}
			button.Level:SetTextColor(color.r, color.g, color.b);
			button.Name:SetTextColor(color.r, color.g, color.b);
			button.Variable:SetTextColor(color.r, color.g, color.b);
			button.Variable:SetText(info.area);
			button.Guild:SetText(info.fullGuildName);
			button.Guild:SetTextColor(color.r, color.g, color.b);
			local raceX,classX = GetRaceClassTXT(WhoiconH,texW,PIGraceList[info.raceStr],info.gender,info.filename)
			button.Class:SetText(raceX.." "..classX);
			if button.Variable:IsTruncated() or button.Guild:IsTruncated() then
				button.tooltip1 = info.fullName.." - "..info.area;
				button.tooltip2 = info.fullGuildName;
			end
			WhoFrame.senmsg.listUpdate(button)
		end)
	end

	--公会
	if tocversion<40000 then
		local GuildFrameHeaderP={24,24,24,120,140,90,150}
		local function PIGGuildList_But(elvuiopen)
			GuildFrameTotals:SetPoint("LEFT",GuildFrame,"LEFT",70,174);
			GuildFrameGuildListToggleButton:Hide()
			GuildListScrollFrame:SetWidth(butWidth)
			GuildFrameNotesText:SetWidth(butWidth+10)
			local GuildColumnHeader0 = CreateFrame("Button","GuildFrameColumnHeader0",GuildPlayerStatusFrame, "GuildFrameColumnHeaderTemplate")
			GuildColumnHeader0:SetText("*")
			GuildColumnHeader0:SetPoint("TOPLEFT",GuildPlayerStatusFrame,"TOPLEFT",7,-57);
			GuildColumnHeader0:SetScript("OnClick", function(self) end)
			if NDui or elvuiopen then
				GuildFrameColumnHeader0Left:Hide()
				GuildFrameColumnHeader0Right:Hide()
				GuildFrameColumnHeader0Middle:Hide()
			end

			GuildFrameColumnHeader4:SetText("*")
			GuildFrameColumnHeader4:ClearAllPoints();
			GuildFrameColumnHeader4:SetPoint("LEFT",GuildColumnHeader0,"RIGHT",-2,0);
			GuildFrameColumnHeader3:SetText("*")
			GuildFrameColumnHeader3:ClearAllPoints();
			GuildFrameColumnHeader3:SetPoint("LEFT",GuildFrameColumnHeader4,"RIGHT",-2,0);
			GuildFrameColumnHeader1:ClearAllPoints();
			GuildFrameColumnHeader1:SetPoint("LEFT",GuildFrameColumnHeader3,"RIGHT",-2,0);	
			GuildFrameGuildStatusColumnHeader2:ClearAllPoints();
			GuildFrameGuildStatusColumnHeader2:SetPoint("LEFT",GuildFrameColumnHeader2,"RIGHT",-2,0);
			GuildFrameGuildStatusColumnHeader1:Hide()

			WhoFrameColumn_SetWidth(GuildFrameColumnHeader0, GuildFrameHeaderP[1]);
			WhoFrameColumn_SetWidth(GuildFrameColumnHeader4, GuildFrameHeaderP[2]);
			WhoFrameColumn_SetWidth(GuildFrameColumnHeader3, GuildFrameHeaderP[3]);
			WhoFrameColumn_SetWidth(GuildFrameColumnHeader1, GuildFrameHeaderP[4]);
			WhoFrameColumn_SetWidth(GuildFrameColumnHeader2, GuildFrameHeaderP[5]);
			WhoFrameColumn_SetWidth(GuildFrameGuildStatusColumnHeader2, GuildFrameHeaderP[6]);
			for i=1,GUILDMEMBERS_TO_DISPLAY do
				local button = _G["GuildFrameButton"..i]
				button:SetWidth(butWidth)
				button:SetHeight(FRIENDS_FRAME_GUILD_HEIGHT+4.5)
				local highlightTTT=button.highlightGradient or button:GetHighlightTexture()
				if highlightTTT then highlightTTT:SetAllPoints(button) end
				local NameText = _G["GuildFrameButton"..i.."Name"];
				local ClassText = _G["GuildFrameButton"..i.."Class"];
				local LevelText = _G["GuildFrameButton"..i.."Level"];
				local ZoneText = _G["GuildFrameButton"..i.."Zone"]
				ClassText:ClearAllPoints();
				if elvuiopen then
					ClassText:SetPoint("LEFT", button, "LEFT", -2, 0);
				elseif NDui then
					ClassText:SetPoint("LEFT", button, "LEFT", 2, 0);
				else
					ClassText:SetPoint("LEFT", button, "LEFT", 0, 0);
				end
				ClassText:SetJustifyH("RIGHT")
				ClassText:SetWidth(GuildFrameHeaderP[1]+GuildFrameHeaderP[2])
				LevelText:ClearAllPoints();
				if elvuiopen then
					LevelText:SetPoint("LEFT", ClassText, "RIGHT", -4, 0);
				else
					LevelText:SetPoint("LEFT", ClassText, "RIGHT", -2, 0);
				end
				LevelText:SetWidth(GuildFrameHeaderP[3]+4)
				NameText:ClearAllPoints();
				NameText:SetPoint("LEFT", LevelText, "RIGHT", 0, 0);
				NameText:SetWidth(GuildFrameHeaderP[4]-6)
				ZoneText:SetPoint("LEFT", NameText, "RIGHT", 2, 0);
				ZoneText:SetWidth(GuildFrameHeaderP[5]-6)
				local RankText = _G["GuildFrameGuildStatusButton"..i.."Rank"]
				RankText:ClearAllPoints();
				RankText:SetPoint("LEFT",ZoneText,"RIGHT",2,0);
				RankText:SetWidth(GuildFrameHeaderP[6]-2)
				local NoteText = _G["GuildFrameGuildStatusButton"..i.."Note"]
				NoteText:ClearAllPoints();
				NoteText:SetPoint("LEFT",RankText,"RIGHT",2,0);
				NoteText:SetWidth(GuildFrameHeaderP[7]-6)
			end
		end
		if ElvUI then
			local E= unpack(ElvUI)
			if E.private.skins.blizzard.enable and E.private.skins.blizzard.friends then
				C_Timer.After(1,function()
					PIGGuildList_But(true)
				end)	
			end
		else
			PIGGuildList_But()
		end
		---
		local function englishRace_Get(button,icoord)
			local class, _, _, _, _, _, guid=select(11, GetGuildRosterInfo(button.guildIndex))
			local englishRace, sexGuild = select(4, GetPlayerInfoByGUID(guid))
			if not class and not englishRace or not sexGuild then
				C_Timer.After(0.01,function ()
					englishRace_Get(button,icoord)
				end)
			end
			local raceX,classX = GetRaceClassTXT(WhoiconH,texW,englishRace,sexGuild,class,icoord)
			local kogngeW = " "
			if NDui then
				kogngeW= " "
			elseif ElvUI and FriendsFrame.backdrop then
				kogngeW= "  "
			end
			local ClassText = _G[button:GetName().."Class"];
			ClassText:SetText(raceX..kogngeW..classX);
		end
		hooksecurefunc("GuildStatus_Update", function()
			GuildStatusFrame:Show();
			WhoFrameColumn_SetWidth(GuildFrameColumnHeader2, GuildFrameHeaderP[5]);
			WhoFrameColumn_SetWidth(GuildFrameGuildStatusColumnHeader3, GuildFrameHeaderP[7]);
			local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers();
			local numGuildMembers = 0;
			local showOffline = GetGuildRosterShowOffline();
			if (showOffline) then
				numGuildMembers = totalMembers;
			else
				numGuildMembers = onlineMembers;
			end
			for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
				local button = _G["GuildFrameButton"..i]
				local ClassText = _G["GuildFrameButton"..i.."Class"];
				local LevelText = _G["GuildFrameButton"..i.."Level"];
				local NameText = _G["GuildFrameButton"..i.."Name"];
				local ZoneText = _G["GuildFrameButton"..i.."Zone"]
				ClassText:SetWidth(GuildFrameHeaderP[1]+GuildFrameHeaderP[2])
				ZoneText:SetWidth(GuildFrameHeaderP[5]-6)
				if ElvUI and FriendsFrame.backdrop then
					ClassText:Show()
					if button.icon then button.icon:Hide() end
					if button.backdrop then button.backdrop:Hide() end
				end
				local Statusbutton = _G["GuildFrameGuildStatusButton"..i]
				local RankText = _G["GuildFrameGuildStatusButton"..i.."Rank"]
				local NoteText = _G["GuildFrameGuildStatusButton"..i.."Note"]
				local OnlineText = _G["GuildFrameGuildStatusButton"..i.."Online"]
				local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(button.guildIndex);
				if name then
					local color = PIG_CLASS_COLORS[class];
					RankText:SetText(rankName);
					NoteText:SetText(publicNote);
					local iconcoord = ""
					if ( isOnline ) then
						if ( status == 2 ) then
							OnlineText:SetText(CHAT_FLAG_DND);
						elseif ( status == 1 ) then
							OnlineText:SetText(CHAT_FLAG_AFK);
						else
							OnlineText:SetText(GUILD_ONLINE_LABEL);
						end
						LevelText:SetTextColor(color.r, color.g, color.b,1);
						NameText:SetTextColor(color.r, color.g, color.b,1);
						ZoneText:SetTextColor(color.r, color.g, color.b,1);
						RankText:SetTextColor(color.r, color.g, color.b,1);
						NoteText:SetTextColor(color.r, color.g, color.b,1);
						OnlineText:SetTextColor(color.r, color.g, color.b,1);
					else
						iconcoord=":100:100:100"
						OnlineText:SetText(GuildFrame_GetLastOnline(button.guildIndex));
						NameText:SetTextColor(0.5, 0.5, 0.5);
						RankText:SetTextColor(0.5, 0.5, 0.5);
						NoteText:SetTextColor(0.5, 0.5, 0.5);
						OnlineText:SetTextColor(0.5, 0.5, 0.5);
					end
					englishRace_Get(button,iconcoord)
				else
					RankText:SetText("");
					NoteText:SetText("");
					OnlineText:SetText("");
				end
				if ( button.guildIndex > numGuildMembers ) then
					button:Hide();
					Statusbutton:Hide();
				else
					button:Show();
					Statusbutton:Show();
				end
			end
		end)
	end

	--团队==============
	RaidFrameRaidDescription:SetWidth(butWidth+10)
	local function SETRaidUIFrame()
		for i=1,8 do
			local uix = _G["RaidGroup"..i]
			uix:SetWidth(www-6)
			local regions = {uix:GetRegions()}
			regions[1]:SetAllPoints(uix)
			for ii=1,5 do
				local Slots = _G["RaidGroup"..i.."Slot"..ii]
				Slots:SetWidth(www-10)
			end
		end
		for i=1,40 do
			local But = _G["RaidGroupButton"..i]
			But:SetWidth(www-10)
			local Name = _G["RaidGroupButton"..i.."Name"]
			Name:SetWidth(www*0.45)
			Name:SetPoint("LEFT", But, "LEFT", 50, 0);
			_G["RaidGroupButton"..i.."Class"]:SetWidth(76)
			if _G["RaidGroupButton"..i.."Class"].text then
				_G["RaidGroupButton"..i.."Class"].text:SetWidth(76)
			end
			_G["RaidGroupButton"..i.."Level"]:SetWidth(40)
		end
		if tocversion<20000 then
			if PIGA["Common"]["SHAMAN_Color"] then
				hooksecurefunc("RaidGroupFrame_Update", function()
					for i=1,40 do
						local But = _G["RaidGroupButton"..i]
						if But.class then
							if But.class=="SHAMAN" then
								local name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
								if online and not dead then
									local color = But.class and PIG_CLASS_COLORS[But.class]
									local rPerc, gPerc, bPerc = color.r, color.g, color.b
									_G["RaidGroupButton"..i.."Name"]:SetTextColor(rPerc, gPerc, bPerc,1);
									_G["RaidGroupButton"..i.."Level"]:SetTextColor(rPerc, gPerc, bPerc,1);
									_G["RaidGroupButton"..i.."Class"].text:SetTextColor(rPerc, gPerc, bPerc,1);
								end
							end
						end 
					end
				end)
			end
		end
	end
	local RaidUIFRAME = CreateFrame("FRAME")
	if IsAddOnLoaded("Blizzard_RaidUI") then
		if InCombatLockdown() then
			RaidUIFRAME:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			SETRaidUIFrame()
		end
    else
        RaidUIFRAME:RegisterEvent("ADDON_LOADED")
    end
	RaidUIFRAME:SetScript("OnEvent", function(self, event, arg1)
    	if event=="ADDON_LOADED" and arg1=="Blizzard_RaidUI" then
    		if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			else
				SETRaidUIFrame()
    		end
    		self:UnregisterEvent("ADDON_LOADED")
		end
		if event=="PLAYER_REGEN_ENABLED" then
			SETRaidUIFrame()
			self:UnregisterEvent(event)
		end
    end)
end