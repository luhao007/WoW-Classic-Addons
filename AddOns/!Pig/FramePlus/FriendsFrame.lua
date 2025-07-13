local _, addonTable = ...;
local match = _G.string.match
local GetRaceClassTXT=addonTable.Fun.GetRaceClassTXT
local ClasseNameID=addonTable.Data.ClasseNameID
local PIGraceList=addonTable.Data.PIGraceList
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
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
    WOW_PROJECT_WRATH_CLASSIC=WOW_PROJECT_WRATH_CLASSIC or 11
    local function GetTisp_TXT(ProjectID,richPresence)
		if richPresence:match("-") then
			local ProjectName, realmName = strsplit("-", richPresence);
			local realmName=realmName or ""
			if ProjectID==WOW_PROJECT_CLASSIC then
				if ProjectName:match("专家") then
					return "(专家60-"..realmName
				elseif ProjectName:match("周年") then
					return "(周年60-"..realmName
				else
					return "(经典60-"..realmName
				end
			elseif ProjectID==WOW_PROJECT_WRATH_CLASSIC then
				return "(巫妖王-"..realmName
			elseif ProjectID==WOW_PROJECT_MAINLINE then
				return "(正式服-"..realmName
			end
		end
		return richPresence
	end
    local playerRealmID = PIG_OptionsUI.Realm
    local playerFactionGroup = UnitFactionGroup("player");
    local function Updata_hangList(button)
    	local Newtxt = {"","",iconH}
    	if button.pig_Data.Count>1 then
    		Newtxt[3]=iconH-3
    	end
		for i=1,button.pig_Data.Count do
			local gameAInfo =button.pig_Data.data[i]
			local _, _,_, _, sexBNET = GetPlayerInfoByGUID(gameAInfo.playerGuid)
			local raceX,classX = GetRaceClassTXT(Newtxt[3],texW,PIGraceList[gameAInfo.raceName],sexBNET or 2,ClasseNameID[gameAInfo.className])
			local Newnamex = raceX.." "..classX.." (Lv"..gameAInfo.characterLevel..") "..gameAInfo.characterName
			-- print(gameAInfo.className,ClasseNameID[gameAInfo.className])
			-- print(gameAInfo.raceName,PIGraceList[gameAInfo.raceName])
			local color = PIG_CLASS_COLORS[ClasseNameID[gameAInfo.className] or NONE]
			local allnameX=button.pig_Data.accname.." \124c"..color.colorStr..Newnamex.."\124r"
			if i>1 then
				Newtxt[1]=Newtxt[1].."\n"..allnameX
			else
				Newtxt[1]=allnameX
			end
			if i>1 then
				Newtxt[2]=Newtxt[2].."\n"
			end
			local NareaName=gameAInfo.areaName or ""
			if gameAInfo.wowProjectID==WOW_PROJECT_ID then
				if gameAInfo.realmName == playerRealmID then
					Newtxt[2]=Newtxt[2].."|cff00FFFF(本服)|r-"..NareaName
				else
					local Tisp_TXT=GetTisp_TXT(gameAInfo.wowProjectID,gameAInfo.richPresence)
					Newtxt[2]=Newtxt[2]..Tisp_TXT..") "..NareaName
				end
			else
				local Tisp_TXT=GetTisp_TXT(gameAInfo.wowProjectID,gameAInfo.richPresence)
				Newtxt[2]=Newtxt[2]..Tisp_TXT..") "..NareaName
			end
		end
		button.name:SetText(Newtxt[1]);
		button.info:SetText(Newtxt[2])
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
			id = button.id
			buttonType = button.buttonType
		end
		if buttonType == FRIENDS_BUTTON_TYPE_WOW then--WOW好友
			local info = C_FriendList.GetFriendInfoByIndex(id);
			if info and info.connected then
				local localizedClass, englishClass,localizedRace, englishRace, sex = GetPlayerInfoByGUID(info.guid)
				local color2 = PIG_CLASS_COLORS[englishClass];
				local color=color2 or {r=1,g=1,b=1}
				button.name:SetTextColor(color.r, color.g, color.b);
				local raceX,classX = GetRaceClassTXT(iconH,texW,englishRace,sex,englishClass)
				local raceXclass = raceX.." "..classX
				local Newtxt = raceXclass.." (Lv"..info.level..") "..info.name
				button.name:SetText(Newtxt);
			end
		elseif buttonType == FRIENDS_BUTTON_TYPE_BNET then--战网好友
			if C_BattleNet and C_BattleNet.GetFriendAccountInfo then
				local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(id);
				if numGameAccounts>0 then
					button.pig_Data={accname="",data={},Count=0}	
					for Accid=1,numGameAccounts do
						local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(id, Accid);
						if gameAccountInfo and gameAccountInfo.clientProgram==BNET_CLIENT_WOW then
							table.insert(button.pig_Data.data,gameAccountInfo)
							button.pig_Data.Count=button.pig_Data.Count+1
							if button.pig_Data.Count==2 then break end
						end
					end
					if button.pig_Data.Count>0 then
						local accountInfo = C_BattleNet.GetFriendAccountInfo(id);
						button.pig_Data.accname=accountInfo.accountName
						Updata_hangList(button)
					end
				end
			else
				local numGameAccounts = BNGetNumFriendGameAccounts(id);
				if numGameAccounts>0 then
					button.pig_Data={accname="",data={},Count=0}	
					for Accid=1,numGameAccounts do
						local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, zoneName, level, gameText, _, _, _, _, _, _, _, Guid, wowProjectID = BNGetFriendGameAccountInfo(id, Accid);
						if client and client==BNET_CLIENT_WOW then
							local gameAccountInfo={
								playerGuid=Guid,characterName=characterName,raceName=race,className=class,characterLevel=level,
								wowProjectID=wowProjectID,realmName=realmName,areaName=zoneName, richPresence=gameText
							}
							table.insert(button.pig_Data.data, gameAccountInfo)
							button.pig_Data.Count=button.pig_Data.Count+1
							if button.pig_Data.Count==2 then break end
						end
					end
					if button.pig_Data.Count>0 then
						local bnetIDAccount, accountName = BNGetFriendInfo(id);
						button.pig_Data.accname=accountName
						Updata_hangList(button)
					end
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
	if PIG_MaxTocversion() then
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
	if PIG_MaxTocversion() then
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
	if PIG_MaxTocversion() then
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
		if PIG_MaxTocversion(20000) then
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
	local RaidUIFRAME = CreateFrame("Frame")
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
    	if event=="ADDON_LOADED" then
    		if arg1=="Blizzard_RaidUI" then
	    		self:UnregisterEvent("ADDON_LOADED")
	    		if InCombatLockdown() then
					self:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					SETRaidUIFrame()
	    		end
	    	end
		elseif event=="PLAYER_REGEN_ENABLED" then
			SETRaidUIFrame()
			self:UnregisterEvent(event)
		end
    end)
end