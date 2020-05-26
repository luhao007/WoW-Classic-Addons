
GroupCalendar_cTitle = string.format(GroupCalendar_cTitle, gGroupCalendar_VersionString);

gGroupCalendar_Settings =
{
	Debug = nil,
	ShowEventsInLocalTime = false,
	ShowMinimap = "ON",
	SquareMinimap = "OFF",
	MinimapTooltip = "ON",
	iconPos = -172,
	MondayFirstDOW = true,
	Use24HrTime = nil,
};

gGroupCalendar_PlayerSettings = nil;
--gGroupCalendar_RealmSettings = nil;

gGroupCalendar_PlayerName = nil;
gGroupCalendar_PlayerNameGUID = nil;
gGroupCalendar_PlayerGuild = nil;
gGroupCalendar_PlayerLevel = nil;
gGroupCalendar_PlayerFactionGroup = nil;
gGroupCalendar_PlayerGuildRank = nil;
gGroupCalendar_RealmName = GetRealmName();
gGroupCalendar_Initialized = false;

gGroupCalendar_ExternalApiSupport = true;

gGroupCalendar_InCombat = false;

gGroupCalendar_ServerTimeZoneOffset = 0; -- Offset that, when added to the server time yields the local time

gGroupCalendar_ActiveDialog = nil;

gGroupCalendar_CurrentPanel = 1;

gGroupCalendar_PanelFrames =
{
	"GroupCalendarCalendarFrame",
	"GroupCalendarTrustFrame",
	"GroupCalendarAboutFrame",
};

local EventFrame = CreateFrame("FRAME")
EventFrame:RegisterEvent("ADDON_LOADED")

local function EventFrame_OnEvent(frame, event, arg1, ...)
	if event == "ADDON_LOADED" then
		GroupCalendarMiniMapButton.Init();
		GroupCalendar_LoadSettingsFrame();
		EventFrame:UnregisterEvent("ADDON_LOADED");
	end
end
EventFrame:SetScript("OnEvent", EventFrame_OnEvent)

function GroupCalendar_OnLoad(frame)	
	
	SlashCmdList["CALENDAR"] = GroupCalendar_ExecuteCommand;
	
	SLASH_CALENDAR1 = "/calendar";
	
	tinsert(UISpecialFrames, "GroupCalendarFrame");
	
	UIPanelWindows["GroupCalendarFrame"] = {area = "left", pushable = 5, whileDead = 1};
	
	gGroupCalendar_PlayerName = UnitName("player");
	gGroupCalendar_PlayerLevel = UnitLevel("player");
	
	-- Register events
	
	GroupCalendar_RegisterEvent(frame, "VARIABLES_LOADED", GroupCalendar_VariablesLoaded);
	GroupCalendar_RegisterEvent(frame, "PLAYER_ENTERING_WORLD", GroupCalendar_PlayerEnteringWorld);
	
	-- For updating auto-config settings and guild trust
	-- values
	
	GroupCalendar_RegisterEvent(frame, "GUILD_ROSTER_UPDATE", GroupCalendar_GuildRosterUpdate);
	GroupCalendar_RegisterEvent(frame, "PLAYER_GUILD_UPDATE", GroupCalendar_PlayerGuildUpdate);
	
	-- For updating the enabled events when the players
	-- level changes
	
	GroupCalendar_RegisterEvent(frame, "PLAYER_LEVEL_UP", GroupCalendar_PlayerLevelUp);
	
	-- For monitoring the status of the chat channel	
	GroupCalendar_RegisterEvent(frame, "CHAT_MSG_ADDON", GroupCalendar_ChatMsgAddon);
	GroupCalendar_RegisterEvent(frame, "CHAT_MSG_WHISPER", GroupCalendar_ChatMsgWhisper);
		
	-- For monitoring tradeskill cooldowns
	
	GroupCalendar_RegisterEvent(frame, "TRADE_SKILL_UPDATE", EventDatabase_UpdateCurrentTradeskillCooldown);
	GroupCalendar_RegisterEvent(frame, "TRADE_SKILL_SHOW", EventDatabase_UpdateCurrentTradeskillCooldown);
	GroupCalendar_RegisterEvent(frame, "BAG_UPDATE_COOLDOWN", GroupCalendar_CheckItemCooldowns);
	GroupCalendar_RegisterEvent(frame, "BAG_UPDATE", GroupCalendar_CheckItemCooldowns);
	GroupCalendar_RegisterEvent(frame, "UPDATE_INSTANCE_INFO", EventDatabase_ScheduleSavedInstanceEvents);
	
	-- For managing group invites
	
	GroupCalendar_RegisterEvent(frame, "GROUP_ROSTER_UPDATE", CalendarGroupInvites_PartyMembersChanged);
	GroupCalendar_RegisterEvent(frame, "RAID_ROSTER_UPDATE", CalendarGroupInvites_PartyMembersChanged);
	GroupCalendar_RegisterEvent(frame, "PARTY_LOOT_METHOD_CHANGED", CalendarGroupInvites_PartyLootMethodChanged);
	
	GroupCalendar_RegisterEvent(frame, "PLAYER_REGEN_DISABLED", GroupCalendar_EnterCombat);
	GroupCalendar_RegisterEvent(frame, "PLAYER_REGEN_ENABLED", GroupCalendar_ExitCombat);
	-- For dragging the window
	
	GroupCalendarFrame:RegisterForDrag("LeftButton");
	
	-- Tabs
	PanelTemplates_SetNumTabs(frame, table.getn(gGroupCalendar_PanelFrames));
	GroupCalendarFrame.selectedTab = gGroupCalendar_CurrentPanel;
	PanelTemplates_UpdateTabs(frame);
	
	-- Done initializing
	
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(GroupCalendar_cLoadMessage, 0.8, 0.8, 0.2);
	end	
end

function GroupCalendar_EnterCombat(...)	
	gGroupCalendar_InCombat = true;
end

function GroupCalendar_ExitCombat(...)	
	gGroupCalendar_InCombat = false;
end

function GroupCalendar_RegisterEvent(frame, pEvent, pHandler)
	if not pHandler then
		Calendar_ErrorMessage("GroupCalendar: Attemping to install a nil handler for event "..pEvent);
		return;
	end
	
	if not frame.EventHandlers then
		frame.EventHandlers = {};
	end
	
	frame.EventHandlers[pEvent] = pHandler;
	frame:RegisterEvent(pEvent);
end

function GroupCalendar_UnregisterEvent(pFrame, pEvent)
	if pFrame.EventHandlers then
		pFrame.EventHandlers[pEvent] = nil;
	end
	
	pFrame:UnregisterEvent(pEvent);
end

function GroupCalendar_DispatchEvent(pFrame, pEvent, ...)
	if not pFrame.EventHandlers then	
		return false;
	end
	
	local	vEventHandler = pFrame.EventHandlers[pEvent];
	
	if not vEventHandler then
		Calendar_ErrorMessage("GroupCalendar: No event handler for "..pEvent);
		return false;
	end
	
	vEventHandler(pEvent, ...);
	return true;
end

function GroupCalendar_VariablesLoaded()
	gGroupCalendar_MinimumEventDate = Calendar_AddDays(Calendar_GetCurrentLocalDate(), -1 * gGroupCalendar_MaximumEventAge);
	gGroupCalendar_MinimumSyncEventDate = Calendar_AddDays(Calendar_GetCurrentLocalDate(), -1 * gGroupCalendar_MaximumEventAge);
	
	EventDatabase_SetUserName(gGroupCalendar_PlayerName);
	EventDatabase_PlayerLevelChanged(gGroupCalendar_PlayerLevel);
	CalendarNetwork_CheckPlayerGuild();
	
	EventDatabase_Initialize();
	
	

	CalendarNetwork_CalendarLoaded();	
end

function GroupCalendar_LoadSettingsFrame()
	local settingsPanel = CreateFrame( "Frame", "GroupCalendarSettingsPanel", UIParent );
	 -- Register in the Interface Addon Options GUI
	 -- Set the name for the Category for the Options Panel
	 settingsPanel.name = BINDING_HEADER_GROUPCALENDAR_TITLE;
	 -- Add the panel to the Interface Options
	 InterfaceOptions_AddCategory(settingsPanel);

	  -- Debug Option
	 ShowDebugCheckButton = CreateFrame("CheckButton", "GroupCalendarShowDebugChk", settingsPanel, "ChatConfigCheckButtonTemplate");
	 ShowDebugCheckButton:SetPoint("TOPLEFT", 50, -45);
	 getglobal(ShowDebugCheckButton:GetName() .. 'Text'):SetText(GroupCalendar_Settings_ShowDebug);
	 ShowDebugCheckButton.tooltip = GroupCalendar_Settings_ShowDebugTip;
	 if gGroupCalendar_Settings.Debug then
		ShowDebugCheckButton:SetChecked(true)
	 else
		ShowDebugCheckButton:SetChecked(false)
	 end

	 ShowDebugCheckButton:SetScript("OnClick", 
		  function()
			if ShowDebugCheckButton:GetChecked()  then
				gGroupCalendar_Settings.Debug = true;
			else
				gGroupCalendar_Settings.Debug = false;
			end
		  end);

	 -- Show Minimap Option
	 ShowMinimapCheckButton = CreateFrame("CheckButton", "GroupCalendarShowMinimapChk", settingsPanel, "ChatConfigCheckButtonTemplate");
	 ShowMinimapCheckButton:SetPoint("TOPLEFT", 50, -65);
	 getglobal(ShowMinimapCheckButton:GetName() .. 'Text'):SetText(GroupCalendar_Settings_ShowMinimap);
	 ShowMinimapCheckButton.tooltip = GroupCalendar_Settings_ShowMinimapTip;
	 if not gGroupCalendar_MiniMapSettings.hide then
		ShowMinimapCheckButton:SetChecked(true)
	 else
		ShowMinimapCheckButton:SetChecked(false)
	 end

	 ShowMinimapCheckButton:SetScript("OnClick", 
		  function()
			gGroupCalendar_MiniMapSettings.shown = ShowMinimapCheckButton:GetChecked();
			gGroupCalendar_MiniMapSettings.hide = not ShowMinimapCheckButton:GetChecked();		
			GroupCalendarMiniMapButton:ApplySettings();
			
		  end);	 

	-- First DOW Option
	 MonFirstDOWCheckButton = CreateFrame("CheckButton", "GroupCalendarMonFirstDOWChk", settingsPanel, "ChatConfigCheckButtonTemplate");
	 MonFirstDOWCheckButton:SetPoint("TOPLEFT", 50, -85);
	 getglobal(MonFirstDOWCheckButton:GetName() .. 'Text'):SetText(GroupCalendar_Settings_MondayFirstDay);
	 MonFirstDOWCheckButton.tooltip = GroupCalendar_Settings_MondayFirstDayTip;
	 if gGroupCalendar_Settings.MondayFirstDOW then
		MonFirstDOWCheckButton:SetChecked(true)
	 else
		MonFirstDOWCheckButton:SetChecked(false)
	 end

	 MonFirstDOWCheckButton:SetScript("OnClick", 
		  function()
			gGroupCalendar_Settings.MondayFirstDOW = MonFirstDOWCheckButton:GetChecked();			
			GroupCalendar_OnShow();
		  end);	 

	-- 24Hr time Option
	 Use24HrTimeCheckButton = CreateFrame("CheckButton", "GroupCalendarUse24HrTimeChk", settingsPanel, "ChatConfigCheckButtonTemplate");
	 Use24HrTimeCheckButton:SetPoint("TOPLEFT", 50, -105);
	 getglobal(Use24HrTimeCheckButton:GetName() .. 'Text'):SetText(GroupCalendar_Settings_Use24HrTime);
	 Use24HrTimeCheckButton.tooltip = GroupCalendar_Settings_Use24HrTimeTip;
	 if gGroupCalendar_Settings.Use24HrTime then
		Use24HrTimeCheckButton:SetChecked(true)
	 else
		Use24HrTimeCheckButton:SetChecked(false)
	 end

	 Use24HrTimeCheckButton:SetScript("OnClick", 
		  function()
			gGroupCalendar_Settings.Use24HrTime = Use24HrTimeCheckButton:GetChecked();	
			GroupCalendar_OnShow();
		  end);	 

end

function GroupCalendar_Reset()
	CalendarNetwork_Reset();
	
	-- Wipe the database
	
	gGroupCalendar_Database =
	{
		Format = GroupCalendar_cDatabaseFormat,
		Databases = {},
	};
	
	-- Reinitialize
	
	GroupCalendar_VariablesLoaded();
end

function GroupCalendar_OnShow()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
		
	if not gGroupCalendar_Settings.MondayFirstDOW then
		WeekdayLabel0:SetText(GroupCalendar_cSun);
		WeekdayLabel1:SetText(GroupCalendar_cMon);
		WeekdayLabel2:SetText(GroupCalendar_cTue);
		WeekdayLabel3:SetText(GroupCalendar_cWed);
		WeekdayLabel4:SetText(GroupCalendar_cThu);
		WeekdayLabel5:SetText(GroupCalendar_cFri);
		WeekdayLabel6:SetText(GroupCalendar_cSat);
	else
		WeekdayLabel0:SetText(GroupCalendar_cMon);
		WeekdayLabel1:SetText(GroupCalendar_cTue);
		WeekdayLabel2:SetText(GroupCalendar_cWed);
		WeekdayLabel3:SetText(GroupCalendar_cThu);
		WeekdayLabel4:SetText(GroupCalendar_cFri);
		WeekdayLabel5:SetText(GroupCalendar_cSat);
		WeekdayLabel6:SetText(GroupCalendar_cSun);
	end

	local	vYear, vMonth, vDay, vHour, vMinute = Calendar_GetCurrentYearMonthDayHourMinute();
	local	vMonthStartDate = Calendar_ConvertMDYToDate(vMonth, 1, vYear);
	-- Update the guild roster
	
	if IsInGuild() and GetNumGuildMembers() == 0 then
		GuildRoster();
	end
	Calendar_SetDisplayDate(vMonthStartDate);
	Calendar_SetActualDate(vMonthStartDate + vDay - 1);
	GroupCalendar_ShowPanel(1); -- Always switch  back to the Calendar view when showing the window
	
	GroupCalendarUseServerTime:SetChecked(not gGroupCalendar_Settings.ShowEventsInLocalTime);
end

function GroupCalendar_OnHide()
	PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);
	CalendarEventEditor_DoneEditing();
	CalendarEventViewer_DoneViewing();
	CalendarEditor_Close();
	GroupCalendarDatabasesList_Close();
end

function GroupCalendar_OnEvent(frame, pEvent, ...)
	local	vLatencyStartTime;
	
	if gGroupCalendar_Settings.DebugLatency then
		vLatencyStartTime = GetTime();
	end
	
	local arg1 = select(1, ...)

	if GroupCalendar_DispatchEvent(frame, pEvent, ...) then
		
		-- Handled
		
	elseif pEvent == "CHAT_MSG_SYSTEM" then
		CalendarNetwork_SystemMessage(arg1);
		CalendarGroupInvites_SystemMessage(arg1);
		
	elseif pEvent == "GUILD_ROSTER_UPDATE" then
		-- Ignore the update if we're not initialized yet
		
		if not gGroupCalendar_Initialized then
			return;
		end
		
		CalendarGroupInvites_GuildRosterChanged();
		
	elseif pEvent == "PLAYER_GUILD_UPDATE" then
		CalendarNetwork_CheckPlayerGuild();

		-- Ignore the update if we're not initialized yet
		
		if not gGroupCalendar_Initialized then
			return;
		end
		
		GroupCalendar_UpdateEnabledControls();
		
	elseif pEvent == "PLAYER_LEVEL_UP" then
		gGroupCalendar_PlayerLevel = tonumber(arg1);
		EventDatabase_PlayerLevelChanged(gGroupCalendar_PlayerLevel);
		GroupCalendar_MajorDatabaseChange();
	end
	
	--
	
	if gGroupCalendar_Settings.DebugLatency then
		local	vElapsed = GetTime() - vLatencyStartTime;
		
		if vElapsed > 0.1 then
			Calendar_DebugMessage("Event "..pEvent.." took "..vElapsed.."s to execute");
		end
	end
end

function GroupCalendar_PlayerEnteringWorld(pEvent)
	Calendar_InitDebugging();
	
	gGroupCalendar_PlayerSettings = GroupCalendar_GetPlayerSettings(gGroupCalendar_PlayerName, GetRealmName());
	--gGroupCalendar_RealmSettings = GroupCalendar_GetRealmSettings(GetRealmName());
	
	gGroupCalendar_PlayerLevel = UnitLevel("player");
	gGroupCalendar_PlayerFactionGroup = UnitFactionGroup("player");
	gGroupCalendar_PlayerSettings = GroupCalendar_GetPlayerSettings(gGroupCalendar_PlayerName, GetRealmName());
	--gGroupCalendar_RealmSettings = GroupCalendar_GetRealmSettings(GetRealmName());
	CalendarNetwork_CheckPlayerGuild();

	EventDatabase_PlayerLevelChanged(gGroupCalendar_PlayerLevel);
	GroupCalendar_CalculateTimeZoneOffset();
	GroupCalendar_MajorDatabaseChange();


	gGroupCalendar_Settings.ShowMinimap = gGroupCalendar_Settings.ShowMinimap or "ON"
	gGroupCalendar_Settings.SquareMinimap = gGroupCalendar_Settings.SquareMinimap or "OFF"
	gGroupCalendar_Settings.IconPos = gGroupCalendar_Settings.IconPos or -172

	if not gGroupCalendar_Settings.Use24HrTime then
		local locale = GetLocale();
		if locale == "enUS"  
			or locale == "enGB" then
			gGroupCalendar_Settings.Use24HrTime = false;
		else
			gGroupCalendar_Settings.Use24HrTime = true;
		end
	end

	--GroupCalendar_MoveMinimap();
	--GroupCalendarMiniMapButton.Init();

	CalendarNetwork_QueueTask(
			CalendarNetwork_LoadGuildRoster, nil,
			3, "LOADGUILDROSTER");
	
end

function GroupCalendar_RemoveRealmName(pName)
	local pHyphon = string.find(pName, "-");

	if pHyphon and pHyphon > 0 then
		pName = string.sub(pName, 1, pHyphon - 1)
	end

	return pName;
end

function GroupCalendar_ChatMsgAddon(pEvent, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	
	if prefix == gGroupCalendar_MessagePrefix0 and channel == "GUILD" then
		
		local author = GroupCalendar_RemoveRealmName(sender);	
		--print (author..":".. text);
		if author == gGroupCalendar_PlayerName then
			-- Ignore messages from ourselves
			if not gGroupCalendar_Settings.Debug then		
				return;
			end
			
			-- Special debugging case: allow self-send of messages starting with '!'			
			if strsub(text, 1, 1) ~= "!" then
				return;
			end
			
			text = strsub(text, 2);
		end
		
		CalendarNetwork_ChannelMessageReceived(author, text);
		
	end
end

function GroupCalendar_ChatMsgWhisper(pEvent, arg1, arg2)
	local author = GroupCalendar_RemoveRealmName(arg2); -- string.sub(arg2, 1, string.len(arg2) - string.len(gGroupCalendar_RealmName) - 1)
	CalendarWhisperLog_AddWhisper(author, arg1);
end

function GroupCalendar_ChatMsgSystem(pEvent, arg1)
	CalendarNetwork_SystemMessage(arg1);
	CalendarGroupInvites_SystemMessage(arg1);
end

function GroupCalendar_GuildRosterUpdate(pEvent)
	-- Ignore the update if we're not initialized yet

	if not gGroupCalendar_Initialized then
		return;
	end
	CalendarGroupInvites_GuildRosterChanged();
end

function GroupCalendar_PlayerGuildUpdate(pEvent)
	CalendarNetwork_CheckPlayerGuild();

	-- Ignore the update if we're not initialized yet
	
	if not gGroupCalendar_Initialized then
		return;
	end
	
	GroupCalendar_UpdateEnabledControls();
end

function GroupCalendar_PlayerLevelUp(pEvent, arg1)
	gGroupCalendar_PlayerLevel = tonumber(arg1);
	EventDatabase_PlayerLevelChanged(gGroupCalendar_PlayerLevel);
	GroupCalendar_MajorDatabaseChange();
end

GroupCalendar_cCooldownItemInfo =
{
	[15846] = {EventID = "Leatherworking"}, -- Salt Shaker
	[17716] = {EventID = "Snowmaster"}, -- Snowmaster 9000
	[18986] = {EventID = "Engineering"}, -- Ultrasafe Transporter: Gadgetzan
};

function GroupCalendar_CheckItemCooldowns()	
	-- Remove the existing saved info	
	EventDatabase_RemoveSavedInstanceEvents(gGroupCalendar_UserDatabase, vCurrentServerDate, vCurrentServerTime);

	for vBagIndex = 0, NUM_BAG_SLOTS do
		local	vNumBagSlots = GetContainerNumSlots(vBagIndex);
		
		for vBagSlotIndex = 1, vNumBagSlots do
			local	vItemLink = GetContainerItemLink(vBagIndex, vBagSlotIndex);

			if vItemLink then
				
				--local	vStartIndex, vEndIndex, vLinkColor, vItemCode, vItemEnchantCode, vItemSubCode, vUnknownCode, vItemName = strfind(vItemLink, "|(%x+)|Hitem:(%d+):(%d+):(%d+):(%d+)|h%[([^%]]+)%]|h|r");
				local	_, _, vItemCode = strfind(vItemLink, "(item:%d+)");			

				if vItemCode then
					local _, _, vItemID = strfind(vItemCode, "(%d+)");

					if vItemID then						
						vItemID = tonumber(vItemID);

						local	vCooldownItemInfo = GroupCalendar_cCooldownItemInfo[vItemID];
					
						if vCooldownItemInfo then

							local vStart, vDuration, vEnable = GetContainerItemCooldown(vBagIndex, vBagSlotIndex);

							-- local	texture, itemCount, locked, quality, readable = GetContainerItemInfo(vBagIndex, vBagSlotIndex);
							-- Calendar_TestMessage(vItemName..": "..texture);

							if vEnable > 0 and vDuration > 60 then -- ignore cooldowns shorter than 60sec (just as equiping cooldown)
								vRemainingTime = vDuration - (GetTime() - vStart);
							
								if vRemainingTime > 0 then
									EventDatabase_ScheduleTradeskillCooldownEvent(gGroupCalendar_UserDatabase, vCooldownItemInfo.EventID, vRemainingTime);
								end
							end
						end
					end
				end
			end
		end
	end
end

function GroupCalendar_UpdateEnabledControls()
	if GroupCalendarFrame.selectedTab == 1 then
		-- Update the calendar display	
		
	elseif GroupCalendarFrame.selectedTab == 2 then
		-- Update the trust frame
		
		if gGroupCalendar_PlayerGuildRank == nil or gGroupCalendar_PlayerGuild == nil or gGroupCalendar_PlayerGuildRank > 0 then -- Must be guild leader to modify trust
			Calendar_SetDropDownEnable(GroupCalendarTrustGroup, false);
			Calendar_SetDropDownEnable(GroupCalendarTrustMinRank, false);
			GroupCalendarAddTrusted:EnableMouse(false);
			GroupCalendarAddExcluded:EnableMouse(false);
			GroupCalendarRemoveTrusted:EnableMouse(false);
			CalendarTrustedPlayerName:EnableMouse(false);
		else
			GroupCalendar_SaveTrustGroup();
			
			Calendar_SetDropDownEnable(GroupCalendarTrustGroup, true);
			Calendar_SetDropDownEnable(GroupCalendarTrustMinRank, UIDropDownMenu_GetSelectedValue(GroupCalendarTrustGroup) == 2);
			GroupCalendarAddTrusted:EnableMouse(true);
			GroupCalendarAddExcluded:EnableMouse(true);
			GroupCalendarRemoveTrusted:EnableMouse(true);
			CalendarTrustedPlayerName:EnableMouse(true);
		end
		
		if UIDropDownMenu_GetSelectedValue(GroupCalendarTrustGroup) == 2 then
			GroupCalendarTrustMinRank:Show();
		else
			GroupCalendarTrustMinRank:Hide();
		end
		
	elseif GroupCalendarFrame.selectedTab == 3 then
		-- Update the ignore frame
	
	end
end

function GroupCalendar_SavePanel(pIndex)
	if pIndex == 2 then		
		GroupCalendar_SaveTrustGroup();		
	end
	
	GroupCalendar_UpdateEnabledControls();
end

function GroupCalendar_SaveTrustGroup()
	local	vTrustGroup = UIDropDownMenu_GetSelectedValue(GroupCalendarTrustGroup);
	local	vChanged = false;
	
	if vTrustGroup == 1
	and not gGroupCalendar_PlayerSettings.Security.TrustAnyone then
		gGroupCalendar_PlayerSettings.Security.TrustAnyone = true;
		gGroupCalendar_PlayerSettings.Security.TrustGuildies = false;
		vChanged = true;
	elseif vTrustGroup == 2 then
		if not gGroupCalendar_PlayerSettings.Security.TrustGuildies then
			gGroupCalendar_PlayerSettings.Security.TrustAnyone = false;
			gGroupCalendar_PlayerSettings.Security.TrustGuildies = true;
			vChanged = true;
		end
		
		local	vMinTrustedRank = UIDropDownMenu_GetSelectedValue(GroupCalendarTrustMinRank);
		
		if not vMinTrustedRank then
			vMinTrustedRank = 1;
			CalendarDropDown_SetSelectedValue(GroupCalendarTrustMinRank, vMinTrustedRank);
		end
		
		if vMinTrustedRank ~= gGroupCalendar_PlayerSettings.Security.MinTrustedRank then
			gGroupCalendar_PlayerSettings.Security.MinTrustedRank = vMinTrustedRank;
			vChanged = true;
		end
	elseif vTrustGroup == 3
	and (gGroupCalendar_PlayerSettings.Security.TrustAnyone
	or gGroupCalendar_PlayerSettings.Security.TrustGuildies) then
		gGroupCalendar_PlayerSettings.Security.TrustAnyone = false;
		gGroupCalendar_PlayerSettings.Security.TrustGuildies = false;
		vChanged = true;
	end
	
	if vChanged then		
		CalendarTrust_TrustSettingsChanged();
	end
end

function GroupCalendar_ShowPanel(pPanelIndex)
	if gGroupCalendar_CurrentPanel > 0
	and gGroupCalendar_CurrentPanel ~= pPanelIndex then
		GroupCalendar_HidePanel(gGroupCalendar_CurrentPanel);
	end
	
	-- NOTE: Don't check for redundant calls since self function
	-- will be called to reset the field values as well as to 
	-- actuall show the panel when it's hidden
	
	gGroupCalendar_CurrentPanel = pPanelIndex;
	
	-- Hide the event editor/viewer if the calendar panel is being hidden
	
	if pPanelIndex ~= 1 then
		CalendarEventEditor_DoneEditing();
		CalendarEventViewer_DoneViewing();
		CalendarEditor_Close();
	end
	
	if pPanelIndex ~= 3 then
		GroupCalendarDatabasesList_Close();
	end

	-- Update the control values
	
	if pPanelIndex == 1 then			
	elseif pPanelIndex == 2 then
		-- Trust panel
		
		GroupCalendarTrustGroup.ChangedValueFunc = GroupCalendar_UpdateEnabledControls;
		
		if gGroupCalendar_PlayerSettings.Security.TrustGuildies
		and not IsInGuild() then
			gGroupCalendar_PlayerSettings.Security.TrustGuildies = false;
		end
		
		if gGroupCalendar_PlayerSettings.Security.TrustAnyone then
			CalendarDropDown_SetSelectedValue(GroupCalendarTrustGroup, 1);
		elseif gGroupCalendar_PlayerSettings.Security.TrustGuildies then
			CalendarDropDown_SetSelectedValue(GroupCalendarTrustGroup, 2);
		else
			CalendarDropDown_SetSelectedValue(GroupCalendarTrustGroup, 3);
		end
		
		if gGroupCalendar_PlayerSettings.Security.TrustGuildies then
			GroupCalendarTrustMinRank:Show();
			
			if gGroupCalendar_PlayerSettings.Security.MinTrustedRank ~= nil then
				CalendarDropDown_SetSelectedValue(GroupCalendarTrustMinRank, gGroupCalendar_PlayerSettings.Security.MinTrustedRank);
			else
				UIDropDownMenu_SetText("", GroupCalendarTrustMinRank); -- In case the value doesn't exist
			end
		else
			GroupCalendarTrustMinRank:Hide();
		end
		
		CalendarPlayerList_SetItemFunction(CalendarTrustedPlayersList, GroupCalendar_GetIndexedTrustedPlayer);
		CalendarPlayerList_SetSelectionChangedFunction(CalendarTrustedPlayersList, GroupCalendar_TrustedPlayerSelected);
		
		CalendarPlayerList_SetItemFunction(CalendarExcludedPlayersList, GroupCalendar_GetIndexedExcludedPlayer);
		CalendarPlayerList_SetSelectionChangedFunction(CalendarExcludedPlayersList, GroupCalendar_ExcludedPlayerSelected);
	elseif pPanelIndex == 3 then
	end
	
	GroupCalendar_UpdateEnabledControls();
	
	getglobal(gGroupCalendar_PanelFrames[pPanelIndex]):Show();
	
	PanelTemplates_SetTab(GroupCalendarFrame, pPanelIndex);
end

function GroupCalendar_HidePanel(pFrameIndex)
	if gGroupCalendar_CurrentPanel ~= pFrameIndex then
		return;
	end
	
	GroupCalendar_SavePanel(pFrameIndex);
	
	getglobal(gGroupCalendar_PanelFrames[pFrameIndex]):Hide();
	gGroupCalendar_CurrentPanel = 0;
end

function GroupCalendar_UpdateChannelStatus()
	local	vChannelStatus = CalendarNetwork_GetChannelStatus();
	local	vStatusText = GroupCalendar_cChannelStatus[vChannelStatus];
	
	GroupCalendarChannelStatus:SetText(string.format(vStatusText.mText, gGroupCalendar_Channel.StatusMessage));
	GroupCalendarChannelStatus:SetTextColor(vStatusText.mColor.r, vStatusText.mColor.g, vStatusText.mColor.b);		
end

function GroupCalendar_FixPlayerName(pName)
	if pName == nil
	or pName == "" then
		return nil;
	end
	
	local	vFirstChar = string.sub(pName, 1, 1);
	
	if (vFirstChar >= "a" and vFirstChar <= "z")
	or (vFirstChar >= "A" and vFirstChar <= "Z") then
		return string.upper(vFirstChar)..string.lower(string.sub(pName, 2));
	else
		return pName;
	end
end

function GroupCalendar_AddTrustedPlayer(pPlayerName)
	local	vPlayerName = GroupCalendar_FixPlayerName(pPlayerName);
	
	if vPlayerName == nil then
		return;
	end
	
	gGroupCalendar_PlayerSettings.Security.Player[vPlayerName] = 1;
	GroupCalendar_UpdateTrustedPlayerList();
	CalendarTrust_TrustSettingsChanged();
end

function GroupCalendar_AddExcludedPlayer(pPlayerName)
	local	vPlayerName = GroupCalendar_FixPlayerName(pPlayerName);

	if vPlayerName == nil then
		return;
	end
	
	gGroupCalendar_PlayerSettings.Security.Player[vPlayerName] = 2;
	GroupCalendar_UpdateTrustedPlayerList();
	CalendarTrust_TrustSettingsChanged();
end

function GroupCalendar_RemoveTrustedPlayer(pPlayerName)
	local	vPlayerName = GroupCalendar_FixPlayerName(pPlayerName);

	if vPlayerName == nil then
		return;
	end
	
	gGroupCalendar_PlayerSettings.Security.Player[vPlayerName] = nil;
	
	GroupCalendar_UpdateTrustedPlayerList();
	
	CalendarPlayerList_SelectIndexedPlayer(CalendarTrustedPlayersList, 0);
	CalendarPlayerList_SelectIndexedPlayer(CalendarExcludedPlayersList, 0);
	
	CalendarTrust_TrustSettingsChanged();
end

function GroupCalendar_UpdateTrustedPlayerList()
	CalendarPlayerList_Update(CalendarTrustedPlayersList);
	CalendarPlayerList_Update(CalendarExcludedPlayersList);
end

function GroupCalendar_GetIndexedTrustedPlayer(pIndex)
	if pIndex == 0 then
		return CalendarTrust_GetNumTrustedPlayers(1);
	end
	
	return
	{
		Text = CalendarTrust_GetIndexedTrustedPlayers(1, pIndex);
	};
end

function GroupCalendar_GetIndexedExcludedPlayer(pIndex)
	if pIndex == 0 then
		return CalendarTrust_GetNumTrustedPlayers(2);
	end
	
	return
	{
		Text = CalendarTrust_GetIndexedTrustedPlayers(2, pIndex);
	};
end

function GroupCalendar_TrustedPlayerSelected(pIndex)
	if pIndex == 0 then
		return;
	end
	
	CalendarPlayerList_SelectIndexedPlayer(CalendarExcludedPlayersList, 0);
	
	local	vName = CalendarTrust_GetIndexedTrustedPlayers(1, pIndex);
	
	if vName then
		CalendarTrustedPlayerName:SetText(vName);
		CalendarTrustedPlayerName:HighlightText();
		CalendarTrustedPlayerName:SetFocus();
	end
end

function GroupCalendar_ExcludedPlayerSelected(pIndex)
	if pIndex == 0 then
		return;
	end
	
	CalendarPlayerList_SelectIndexedPlayer(CalendarTrustedPlayersList, 0);
	
	local	vName = CalendarTrust_GetIndexedTrustedPlayers(2, pIndex);
	
	if vName then
		CalendarTrustedPlayerName:SetText(vName);
		CalendarTrustedPlayerName:HighlightText();
		CalendarTrustedPlayerName:SetFocus();
	end
end

function GroupCalendar_SelectDateWithToggle(pDate)
	if CalendarEditor_IsOpen()
	and gCalendarEditor_SelectedDate == pDate then
		CalendarEditor_Close();
	else
		GroupCalendar_SelectDate(pDate);
	end
end

function GroupCalendar_SelectDate(pDate)
	Calendar_SetSelectedDate(pDate);
	
	local	vCompiledSchedule = EventDatabase_GetCompiledSchedule(pDate);
	
	CalendarEditor_ShowCompiledSchedule(pDate, vCompiledSchedule);
end

function GroupCalendar_EditorClosed()
	Calendar_ClearSelectedDate();
end

function GroupCalendar_EventChanged(pDatabase, pEvent, pChangedFields)
	GroupCalendar_ScheduleChanged(pDatabase, pEvent.mDate);
	CalendarEventEditor_EventChanged(pEvent);
end

function GroupCalendar_ScheduleChanged(pDatabase, pDate)
	GroupCalendar_ScheduleChanged2(pDatabase, pDate);
	
	if gGroupCalendar_Settings.ShowEventsInLocalTime then
		if gGroupCalendar_ServerTimeZoneOffset < 0 then
			GroupCalendar_ScheduleChanged2(pDatabase, pDate - 1);
		elseif gGroupCalendar_ServerTimeZoneOffset > 0 then
			GroupCalendar_ScheduleChanged2(pDatabase, pDate + 1);
		end
	end
end

function GroupCalendar_ScheduleChanged2(pDatabase, pDate)
	local	vSchedule = pDatabase.Events[pDate];
	
	CalendarEditor_ScheduleChanged(pDate, pSchedule);
	Calendar_ScheduleChanged(pDate, pSchedule);
	CalendarEventViewer_ScheduleChanged(pDate);
end

function GroupCalendar_AddedNewEvent(pDatabase, pEvent)
	-- CalendarDisplay_StartFlashingReminder();
end

function GroupCalendar_MajorDatabaseChange()
	CalendarEditor_MajorDatabaseChange();
	CalendarEventViewer_MajorDatabaseChange();
	CalendarEventEditor_MajorDatabaseChange();
	Calendar_MajorDatabaseChange();
end

gGroupCalendar_QueueElapsedTime = 0;
gGroupCalendar_ExpiredEventsTime = 0;

function GroupCalendar_Update(self, pElapsed)
	
	gGroupCalendar_ExpiredEventsTime = gGroupCalendar_ExpiredEventsTime + pElapsed;

	if gGroupCalendar_ExpiredEventsTime >= 10 then
		gGroupCalendar_ExpiredEventsTime = 0;
		
		-- Remove the existing saved info	
		EventDatabase_RemoveSavedInstanceEvents(gGroupCalendar_UserDatabase);

	end

	--GroupCalendar_OnUpdate(self, pElapsed)
	local	vLatencyStartTime;
	
	-- Process invites
	
	if gGroupCalendar_Settings.DebugLatency then
		vLatencyStartTime = GetTime();
	end
	
	CalendarGroupInvites_Update(pElapsed);
	
	if gGroupCalendar_Settings.DebugLatency then
		local	vElapsed = GetTime() - vLatencyStartTime;
		
		if vElapsed > 0.1 then
			Calendar_DebugMessage("CalendarGroupInvites_Update took "..vElapsed.."s to execute");
		end
		
		vLatencyStartTime = GetTime();
	end

	-- Process the event queues if it's time
	
	gGroupCalendar_QueueElapsedTime = gGroupCalendar_QueueElapsedTime + pElapsed;
	
	if gGroupCalendar_QueueElapsedTime > 0.1 then
		
		CalendarNetwork_ProcessQueues(gGroupCalendar_QueueElapsedTime);
		
		gGroupCalendar_QueueElapsedTime = 0;
	end
	
	if gGroupCalendar_Settings.DebugLatency then
		local	vElapsed = GetTime() - vLatencyStartTime;
		
		if vElapsed > 0.1 then
			Calendar_DebugMessage("CalendarNetwork_ProcessQueues took "..vElapsed.."s to execute");
		end
		
		vLatencyStartTime = GetTime();
	end
	
	-- Stop the timer if it isn't needed
	
	if not CalendarNetwork_NeedsUpdateTimer()
	and not CalendarGroupInvites_NeedsUpdateTimer() then
		if gGroupCalendar_Settings.DebugTimer then
			Calendar_DebugMessage("GroupCalendar_Update: Stopping timer");
		end
		
		GroupCalendarUpdateFrame:Hide();
	end

	if gGroupCalendar_Settings.DebugLatency then
		local	vElapsed = GetTime() - vLatencyStartTime;
		
		if vElapsed > 0.1 then
			Calendar_DebugMessage("NeedsUpdateTimer took "..vElapsed.."s to execute");
		end
	end
end

function GroupCalendar_StartUpdateTimer()
	if GroupCalendarUpdateFrame:IsVisible() then
		return;
	end
	
	if gGroupCalendar_Settings.DebugTimer then
		Calendar_DebugMessage("GroupCalendar_StartUpdateTimer()");
	end
	GroupCalendarUpdateFrame:Show();
end

function GroupCalendar_StartMoving()
	if not gGroupCalendar_PlayerSettings.UI.LockWindow then
		GroupCalendarFrame:StartMoving();
	end
end

function GroupCalendar_GetPlayerSettings(pPlayerName, pRealmName)
	-- Wipe the settings if they're the alpha version
	
	if not gGroupCalendar_Settings.Format then
		gGroupCalendar_Settings =
		{
			Debug = false,
			Format = 1,
		};
	end
	
	local	vSettings = gGroupCalendar_Settings[pRealmName.."_"..pPlayerName];
	
	if vSettings == nil then
		vSettings =
		{
			Security =
			{
				TrustAnyone = false,
				TrustGuildies = true,
				MinTrustedRank = 0,
				Player = {},
				Version = nil,
				Guild = nil,
			},			
			UI =
			{
				LockWindow = false,
			},
		};
		
		gGroupCalendar_Settings[pRealmName.."_"..pPlayerName] = vSettings;
	end
	
	-- Reset settings if not in a guild or the guild changes
	if not vSettings.Security.Version then
		vSettings.Security.TrustAnyone = false;
		vSettings.Security.TrustGuildies = true;
		vSettings.Security.MinTrustedRank = 0;
		vSettings.Security.Player = {};
		vSettings.Security.Version = 0;
		vSettings.Security.Guild = nil
	end

	return vSettings;
end

function GroupCalendar_GetRealmSettings(pRealmName)
	local	vSettings = gGroupCalendar_Settings[pRealmName];
	
	if vSettings == nil then
		vSettings = {};
		gGroupCalendar_Settings[pRealmName] = vSettings;
	end
	
	return vSettings;
end

function GroupCalendar_RoundTimeOffsetToNearest30(pOffset)
	local	vNegativeOffset;
	local	vOffset;
	
	if pOffset < 0 then
		vNegativeOffset = true;
		vOffset = -pOffset;
	else
		vNegativeOffset = false;
		vOffset = pOffset;
	end
	
	vOffset = vOffset - (math.fmod(vOffset + 15, 30) - 15);
	
	if vNegativeOffset then
		return -vOffset;
	else
		return vOffset;
	end
end

function GroupCalendar_CalculateTimeZoneOffset()
	local	vServerTime = Calendar_ConvertHMToTime(GetGameTime());
	local	vLocalDate, vLocalTime = Calendar_GetCurrentLocalDateTime();
	local	vUTCDate, vUTCTime = Calendar_GetCurrentUTCDateTime();
	
	local	vLocalDateTime = vLocalDate * 1440 + vLocalTime;
	local	vUTCDateTime = vUTCDate * 1440 + vUTCTime;
	
	local	vLocalUTCDelta = GroupCalendar_RoundTimeOffsetToNearest30(vLocalDateTime - vUTCDateTime);
	local	vLocalServerDelta = GroupCalendar_RoundTimeOffsetToNearest30(vLocalTime - vServerTime);
	local	vServerUTCDelta = vLocalUTCDelta - vLocalServerDelta;
	
	if vServerUTCDelta < (-12 * 60) then
		vServerUTCDelta = vServerUTCDelta + (24 * 60);
	elseif vServerUTCDelta > (12 * 60) then
		vServerUTCDelta = vServerUTCDelta - (24 * 60);
	end
	
	vLocalServerDelta = vLocalUTCDelta - vServerUTCDelta;
	
	if vLocalServerDelta ~= gGroupCalendar_ServerTimeZoneOffset then
		gGroupCalendar_ServerTimeZoneOffset = vLocalServerDelta;
		
		-- Time zone changed
		
		if gGroupCalendar_ServerTimeZoneOffset == 0 then
			GroupCalendarUseServerTime:Hide();
		else
			GroupCalendarUseServerTime:Show();
		end
	end
end

function GroupCalendar_UpdateTimeTooltip()
	local	vServerTime = Calendar_ConvertHMToTime(GetGameTime());
	local	vLocalDate = Calendar_GetCurrentLocalDate();
	
	local	vServerTimeString = Calendar_GetShortTimeString(vServerTime);
	local	vLocalDateString = Calendar_GetLongDateString(vLocalDate, true);

	GroupCalendarTooltip:AddLine(vLocalDateString);
	GroupCalendarTooltip:AddLine(vServerTimeString);
	
	if gGroupCalendar_ServerTimeZoneOffset ~= 0 then
		local	vLocalTime = Calendar_GetLocalTimeFromServerTime(vServerTime);
		local	vLocalTimeString = Calendar_GetShortTimeString(vLocalTime);
		
		GroupCalendarTooltip:AddLine(string.format(GroupCalendar_cLocalTimeNote, vLocalTimeString));
	end
	
	GroupCalendarTooltip:Show();
end

function GroupCalendar_GetLocalizedStrings(pLocale)
	local	vStrings = {};
	
	-- Initialize the strings with copies form the enUS set
	
	for vIndex, vString in pairs(gCalendarLocalizedStrings.enUS) do
		vStrings[vIndex] = vString;
	end
	
	-- Select a set to use for overwriting
	
	local	vLocalizedStrings = gCalendarLocalizedStrings[pLocale];
	
	if not vLocalizedStrings then
		-- There's not a fit for the exact language/country specified, so just match the language
		
		local	vLanguageCode = string.sub(pLocale, 1, 2);
		
		vLocalizedStrings = GroupCalendar_SelectLanguage(vLanguageCode);
		
		if not vLocalizedStrings then
			return vStrings;
		end
	end
	
	-- Overwrise the english strings with translated strings
	
	for vIndex, vString in pairs(vLocalizedStrings) do
		vStrings[vIndex] = vString;
	end
	
	return vStrings;
end

function GroupCalendar_SelectLanguage(pLanguageCode)
	-- There's not a fit for the exact language/country specified, so just match the language

	local	vLanguageCode = string.sub(pLocale, 1, 2);

	for vLocale, vLocalizedStrings in gCalendarLocalizedStrings do
		if pLanguageCode == string.sub(vLocale, 1, 2) then
			return vLocalizedStrings;
		end
	end
	
	-- No luck, hope they know english!
	
	return nil;
end

function GroupCalendar_ToggleCalendarDisplay()
	if GroupCalendarFrame:IsVisible() then
		HideUIPanel(GroupCalendarFrame);
	else
		ShowUIPanel(GroupCalendarFrame);
	end
end

function GroupCalendar_SetUseServerDateTime(pUseServerDateTime)
	gGroupCalendar_Settings.ShowEventsInLocalTime = not pUseServerDateTime;
	
	GroupCalendarUseServerTime:SetChecked(pUseServerDateTime);
	
	GroupCalendar_MajorDatabaseChange(); -- Force the display to update
end

function GroupCalendar_BeginModalDialog(pDialogFrame)
	if gGroupCalendar_ActiveDialog then
		GroupCalendar_EndModalDialog(gGroupCalendar_ActiveDialog);
	end
	
	gGroupCalendar_ActiveDialog = pDialogFrame;
end

function GroupCalendar_EndModalDialog(pDialogFrame)
	if pDialogFrame ~= gGroupCalendar_ActiveDialog then
		return;
	end
	
	gGroupCalendar_ActiveDialog = nil;
	
	pDialogFrame:Hide();
end

function GroupCalendar_ExecuteCommand(pCommandString)
	local	vStartIndex, vEndIndex, vCommand, vParameter = string.find(pCommandString, "(%w+) ?(.*)");
	
	if not vCommand then
		ShowUIPanel(GroupCalendarFrame);
		return;
	end
	
	local	vCommandTable =
	{
		["help"] = {func = GroupCalendar_ShowCommandHelp},
		["versions"] = {func = GroupCalendar_DumpUserVersions},
	};
	
	local	vCommandInfo = vCommandTable[strlower(vCommand)];
	
	if not vCommandInfo then
		GroupCalendar_ShowCommandHelp();
		return;
	end
	
	vCommandInfo.func(vParameter);
end

function GroupCalendar_ShowCommandHelp()
	Calendar_NoteMessage("GroupCalendar commands:");
	Calendar_NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/calendar help"..NORMAL_FONT_COLOR_CODE..": Shows self list of commands");
	Calendar_NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/calendar versions"..NORMAL_FONT_COLOR_CODE..": Displays the last known versions of GroupCalendar each user was running");
end

function GroupCalendar_GetUserVersionsList()
	local	vVersions = {};

	for vUsername, vVersionData in pairs(gGroupCalendar_PlayerVersions) do
		table.insert(vVersions, {UserName = vVersionData.UserName, Version = vVersionData.Version});
	end

	table.sort(vVersions, GroupCalendar_CompareUserNameFields);
	
	return vVersions;
end

function GroupCalendar_DumpUserVersions()
	local	vVersions = GroupCalendar_GetUserVersionsList();
	
	for _, vVersion in pairs(vVersions) do
		Calendar_NoteMessage(HIGHLIGHT_FONT_COLOR_CODE..vVersion.UserName..NORMAL_FONT_COLOR_CODE..": "..vVersion.Version);
	end
end


function GroupCalendar_CompareUserNameFields(pValue1, pValue2)
	return pValue1.UserName < pValue2.UserName;
end

function GroupCalendarDatabasesList_Open()
	local	vDesc =
	{
		Title = CalendarDatabases_cTitle,
		CloseFunc = GroupCalendarDatabasesList_Close,
		ButtonTitle = CalendarDatabases_cRefresh,
		ButtonDescription = CalendarDatabases_cRefreshDescription,
		ButtonFunc = GroupCalendarDatabasesList_Refresh,
		ListItems = GroupCalendarDatabasesList,
	};
	
	GroupCalendarDatabasesList.UpdateItems = GroupCalendarDatabasesList_UpdateItems;
	GroupCalendarDatabasesList.UpdateItem = GroupCalendarDatabasesList_UpdateItem;
	
	GroupCalendarDatabasesList.Versions = GroupCalendar_GetUserVersionsList();
	GroupCalendarSideList_Show(vDesc);
end

function GroupCalendarDatabasesList_Close()
	GroupCalendarSideList_Hide();
end

function GroupCalendarDatabasesList_Refresh()
	CalendarNetwork_QueueVersionRequest();
end

function GroupCalendarDatabasesList_UpdateItems(pListItems)
	GroupCalendarSideList_SetNumItems(table.getn(GroupCalendarDatabasesList.Versions));
end

function GroupCalendarDatabasesList_UpdateItem(pListItems, pIndex, pItem, pItemName, pItemIndex)
	local	vLabelText = getglobal(pItemName.."Label");
	local	vValueText = getglobal(pItemName.."Value");
	local	vVersionInfo = pListItems.Versions[pIndex];
	
	vLabelText:SetText(vVersionInfo.UserName);
	vValueText:SetText(string.format(GroupCalendar_cShortVersionFormat, vVersionInfo.Version));
	
	pItem.VersionInfo = vVersionInfo;
	pItem.UpdateTooltip = GroupCalendarDatabasesList_UpdateTooltip;
end

--function GameTooltip_AddNewbieTip(frame, normalText, r, g, b, newbieText, noNormalText)
	--if not noNormalText then
	--	GroupCalendarTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	--	GameTooltip_SetTitle(GroupCalendarTooltip, normalText);
	--end
--end

--function GroupCalendarDatabasesList_UpdateTooltip(frame, pItem)
function GroupCalendarDatabasesList_UpdateTooltip(pItem)
	
	GroupCalendarTooltip:SetOwner(pItem, "ANCHOR_RIGHT");
	GroupCalendarTooltip:AddLine(pItem.VersionInfo.UserName);
	
	GroupCalendarTooltip:AddLine(string.format(GroupCalendar_cVersionFormat, pItem.VersionInfo.Version), 1, 1, 1, 1);
		
	GroupCalendarTooltip:Show();
end

function GroupCalendar_VersionDataChanged()
	if GroupCalendarDatabasesList:IsShown() then
		GroupCalendarDatabasesList.Versions = GroupCalendar_GetUserVersionsList();
		GroupCalendarDatabasesList:UpdateItems();
	end
end

function GroupCalendar_ToggleVersionsFrame()
	if GroupCalendarDatabasesList:IsShown() then
		GroupCalendarDatabasesList_Close();
	else
		GroupCalendarDatabasesList_Open();
	end
end
