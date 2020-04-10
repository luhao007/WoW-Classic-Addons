gCalendarEventViewer_ShowScheduleEditor = false;
gCalendarEventViewer_Active = false;

gCalendarEventViewer_SelectedPlayerDatabase = nil;
gCalendarEventViewer_Database = nil;
gCalendarEventViewer_Event = nil;

gCalendarEventViewer_PanelFrames =
{
	"CalendarEventViewerEventFrame",
	"CalendarEventViewerAttendanceFrame",
};

gCalendarEventViewer_CurrentPanel = 1;

StaticPopupDialogs["CONFIRM_CALENDAR_VIEWER_EVENT_DELETE"] = {
	text = CalendarEventEditor_cConfirmDeleteMsg,
	button1 = CalendarEventEditor_cDelete,
	button2 = "CANCEL",
	OnAccept = function() CalendarEventViewer_DeleteEvent(); end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};

function CalendarEventViewer_ViewEvent(pDatabase, pEvent)
	gCalendarEventViewer_Database = pDatabase;
	gCalendarEventViewer_Event = pEvent;

	CalendarAttendanceList_SetEvent(CalendarEventViewerAttendance, pDatabase, pEvent);
	CalendarEventViewer_UpdateControlsFromEvent(gCalendarEventViewer_Event, false);
	
	ShowUIPanel(CalendarEventViewerFrame);
	
	CalendarEventTitle:SetFocus();
	CalendarEventTitle:HighlightText(0, 100);
	
	gCalendarEventViewer_ShowScheduleEditor = false;
	gCalendarEventViewer_Active = true;

	if gCalendarEventViewer_Event.mPrivate then
		CalendarEventViewerDeleteButton:Show();
	else
		CalendarEventViewerDeleteButton:Hide();
	end
end

function CalendarEventViewer_DoneViewing()
	if not gCalendarEventViewer_Active then
		return;
	end

	CalendarEventViewer_Save();

	CalendarEventViewer_Close(true);
end

function CalendarEventViewer_ScheduleChanged(pDate)
	if gCalendarEventViewer_Active
	and gCalendarEventViewer_Event.mDate == pDate then
		CalendarAttendanceList_EventChanged(CalendarEventViewerAttendance, gCalendarEventViewer_Database, gCalendarEventViewer_Event);
		CalendarEventViewer_UpdateControlsFromEvent(gCalendarEventViewer_Event, true);
	end
end

function CalendarEventViewer_MajorDatabaseChange()
	if gCalendarEventViewer_Active then
		CalendarAttendanceList_EventChanged(CalendarEventViewerAttendance, gCalendarEventViewer_Database, gCalendarEventViewer_Event);
		CalendarEventViewer_UpdateControlsFromEvent(gCalendarEventViewer_Event, true);
	end
end

function CalendarEventViewer_Save()
	-- Save attendance feedback
	if EventDatabase_EventTypeUsesAttendance(gCalendarEventViewer_Event.mType)
	and EventDatabase_PlayerIsQualifiedForEvent(gCalendarEventViewer_Event, gCalendarEventViewer_SelectedPlayerDatabase.PlayerLevel) 
	and (CalendarEventViewerYes:GetChecked() or CalendarEventViewerNo:GetChecked())
	then
		local pCharacter = gCalendarEventViewer_SelectedPlayerDatabase.UserName;
		local vNewComment = Calendar_EscapeString(CalendarEventViewerComment:GetText());
		local pRoleCode = EventDatabase_GetRoleCodeByRole(UIDropDownMenu_GetSelectedValue(CalendarEventViewerRoleMenu));

		local	vDate, vTime = EventDatabase_GetServerDateTime60Stamp();

		for DBindex, vPlayerDB in pairs (EventDatabase_GetPlayerDatabases()) do		
			if  pCharacter == vPlayerDB.UserName then	
				
				local OldRSVP = gCalendarEventViewer_Event.mAttendance[pCharacter];
				
				local RSVP = {};			
			
				RSVP.mName = pCharacter;
				RSVP.mRole = pRoleCode;
				RSVP.mDate = vDate;
				RSVP.mTime = vTime;
				if CalendarEventViewerYes:GetChecked() then
					if OldRSVP and OldRSVP.mStatus == "S" then
						RSVP.mStatus = "S";
					else
						RSVP.mStatus = "Y";
					end
				else
					RSVP.mStatus = "N";
				end
				RSVP.mComment = vNewComment;

				if not OldRSVP or not OldRSVP.mOriginalDate then
					RSVP.mOriginalDate = vDate;
					RSVP.mOriginalTime = vTime;
				else
					RSVP.mOriginalDate = OldRSVP.mOriginalDate;
					RSVP.mOriginalTime = OldRSVP.mOriginalTime;
				end
			
				RSVP.mClassCode = vPlayerDB.PlayerClassCode;
				RSVP.mRaceCode = vPlayerDB.PlayerRaceCode;
				RSVP.mLevel = vPlayerDB.PlayerLevel;
				RSVP.mGuildRank = vPlayerDB.GuildRank			

				gCalendarEventViewer_Event.mAttendance[pCharacter] = RSVP;
				CalendarNetwork_SendRSVPUpdate(gCalendarEventViewer_Event, RSVP, "ALERT");

				gCalendarEventViewer_SelectedPlayerDatabase.DefaultRole = pRoleCode;
			elseif CalendarEventViewerYes:GetChecked() then -- don't change other characters unless we said we were going
				local RSVP = gCalendarEventViewer_Event.mAttendance[vPlayerDB.UserName];
				if RSVP and (RSVP.mStatus == "Y" or RSVP.mStatus == "S") then
					RSVP.mStatus = "N";
					RSVP.mDate = vDate;
					RSVP.mTime = vTime;
					CalendarNetwork_SendRSVPUpdate(gCalendarEventViewer_Event, RSVP, "ALERT");
				end
			end		
		end
		
		CalendarAttendanceList_EventChanged(CalendarEventViewerAttendance, gCalendarEventViewer_Database, gCalendarEventViewer_Event);
		--CalendarEventViewer_UpdateControlsFromEvent(gCalendarEventViewer_Event, false);
		
	end
end

function CalendarEventViewer_Close(pShowScheduleEditor)
	gCalendarEventViewer_ShowScheduleEditor = pShowScheduleEditor;
	HideUIPanel(CalendarEventViewerFrame);
end

function CalendarEventViewer_OnLoad(frame)
	-- Tabs
	
	PanelTemplates_SetNumTabs(frame, table.getn(gCalendarEventViewer_PanelFrames));
	CalendarEventViewerFrame.selectedTab = gCalendarEventViewer_CurrentPanel;
	PanelTemplates_UpdateTabs(frame);
	
	CalendarEventViewerCharacterMenu.ChangedValueFunc = CalendarEventViewer_SelectedCharacterChanged;

end

function CalendarEventViewer_OnShow()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
	
	CalendarEventViewer_ShowPanel(1); -- Always switch to the event view when showing the window
end

function CalendarEventViewer_OnHide()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
	
	--CalendarEventViewer_Save();
	
	if not gCalendarEventViewer_ShowScheduleEditor then
		HideUIPanel(CalendarEditorFrame);
	end
	
	gCalendarEventViewer_Database = nil;
	gCalendarEventViewer_Event = nil;
	
	gCalendarEventViewer_Active = false;
end

function CalendarEventViewer_SelectedCharacterChanged(pMenuFrame, pValue)
	gCalendarEventViewer_SelectedPlayerDatabase = EventDatabase_GetPlayerDatabase(pValue);

	-- Check if they are eligible

	if EventDatabase_PlayerIsQualifiedForEvent(gCalendarEventViewer_Event, gCalendarEventViewer_SelectedPlayerDatabase.PlayerLevel) then
		CalendarEventViewerEventFrameLevels:SetTextColor(1.0, 0.82, 0);
	else
		CalendarEventViewerEventFrameLevels:SetTextColor(1.0, 0.2, 0.2);
	end

	CalendarEventViewer_UpdateEnabled();

end

function CalendarEventViewer_UpdateEnabled()
	local vIsFuture = CalendarEventViewer_IsFutureEvent(gCalendarEventViewer_Event);
	if EventDatabase_PlayerIsQualifiedForEvent(gCalendarEventViewer_Event, gCalendarEventViewer_SelectedPlayerDatabase.PlayerLevel) and vIsFuture then
		CalendarEventViewer_SetAttendanceEnabled(true);	
		CalendarEventViewerDoneButton:Enable();
		Calendar_SetDropDownEnable(CalendarEventViewerRole, true);
	else
		CalendarEventViewer_SetAttendanceEnabled(false);
		CalendarEventViewerDoneButton:Disable();
		Calendar_SetDropDownEnable(CalendarEventViewerRole, false);
	end

	if vIsFuture then
		Calendar_SetDropDownEnable(CalendarEventViewerCharacter, true);
	else
		Calendar_SetDropDownEnable(CalendarEventViewerCharacter, false);
	end

end

function CalendarEventViewer_UpdateControlsFromEvent(pEvent, pSkipAttendanceFields)
	-- Update the title

	
	--CalendarDropDown_SetSelectedValue(CalendarEventViewerRoleMenu, gCalendarEventViewer_SelectedPlayerDatabase.DefaultRole);
	CalendarEventViewerEventFrameEventTitle:SetText(EventDatabase_GetEventDisplayName(pEvent));
	
	local vPlayerName, vRSVP;

	if EventDatabase_EventTypeUsesAttendance(pEvent.mType) then
		vPlayerName, vRSVP = EventDatabase_GetEventRSVP(pEvent);

		if vPlayerName then
			gCalendarEventViewer_SelectedPlayerDatabase = EventDatabase_GetPlayerDatabase(vPlayerName);
		else
			gCalendarEventViewer_SelectedPlayerDatabase = EventDatabase_GetPlayerDatabase(gGroupCalendar_PlayerName);
		end
	end

	-- Update the date and time
	
	if pEvent.mTime ~= nil then
		local		vTime;
		local		vDate = pEvent.mDate;
		
		if gGroupCalendar_Settings.ShowEventsInLocalTime then
			vDate, vTime = Calendar_GetLocalDateTimeFromServerDateTime(pEvent.mDate, pEvent.mTime);
		else
			vTime = pEvent.mTime;
		end
		
		-- Set the date
		
		CalendarEventViewerEventFrameDate:SetText(Calendar_GetLongDateString(vDate));
		
		--
		
		local		vTimeString;
		
		if pEvent.mDuration ~= nil
		and pEvent.mDuration ~= 0 then
			local	vEndTime = math.fmod(vTime + pEvent.mDuration, 1440);
			
			vTimeString = string.format(
								GroupCalendar_cTimeRangeFormat,
								Calendar_GetShortTimeString(vTime),
								Calendar_GetShortTimeString(vEndTime));
			
		else
			vTimeString = Calendar_GetShortTimeString(vTime);
		end

		CalendarEventViewerEventFrameTime:SetText(vTimeString);
		CalendarEventViewerEventFrameTime:Show();
	else
		CalendarEventViewerEventFrameDate:SetText(Calendar_GetLongDateString(pEvent.mDate));
		CalendarEventViewerEventFrameTime:Hide();
	end
	
	-- Update the level range
	
	if EventDatabase_EventTypeUsesLevelLimits(pEvent.mType) then
		if pEvent.mMinLevel ~= nil then
			if pEvent.mMaxLevel ~= nil then
				if pEvent.mMinLevel == pEvent.mMaxLevel then
					CalendarEventViewerEventFrameLevels:SetText(string.format(CalendarEventViewer_cSingleLevel, pEvent.mMinLevel));
				else
					CalendarEventViewerEventFrameLevels:SetText(string.format(CalendarEventViewer_cLevelRangeFormat, pEvent.mMinLevel, pEvent.mMaxLevel));
				end
			else
				if pEvent.mMinLevel == 60 then
					CalendarEventViewerEventFrameLevels:SetText(string.format(CalendarEventViewer_cSingleLevel, pEvent.mMinLevel));
				else
					CalendarEventViewerEventFrameLevels:SetText(string.format(CalendarEventViewer_cMinLevelFormat, pEvent.mMinLevel));
				end
			end
			
			CalendarEventViewerEventFrameLevels:Show();
		else
			if pEvent.mMaxLevel ~= nil then
				CalendarEventViewerEventFrameLevels:SetText(string.format(CalendarEventViewer_cMaxLevelFormat, pEvent.mMaxLevel));
			else
				CalendarEventViewerEventFrameLevels:SetText(CalendarEventViewer_cAllLevels);
			end
			
			CalendarEventViewerEventFrameLevels:Show();
		end
		
		

		if EventDatabase_PlayerIsQualifiedForEvent(gCalendarEventViewer_Event, gCalendarEventViewer_SelectedPlayerDatabase.PlayerLevel) then
			CalendarEventViewerEventFrameLevels:SetTextColor(1.0, 0.82, 0);
		else
			CalendarEventViewerEventFrameLevels:SetTextColor(1.0, 0.2, 0.2);
		end
	else
		CalendarEventViewerEventFrameLevels:Hide();
	end
	
	-- Update the description
	
	if pEvent.mDescription then
		CalendarEventViewerDescText:SetText(Calendar_UnescapeString(pEvent.mDescription));
		CalendarEventViewerDescText:Show();
	else
		CalendarEventViewerDescText:Hide();
	end
	
	-- Update the attendance
	
	if EventDatabase_EventTypeUsesAttendance(pEvent.mType) then
		local	vIsAttending = false;
		local	vIsNotAttending = false;
		local	vAttendanceComment = "";
		local	vRoleCode = "U";

		if gCalendarEventViewer_SelectedPlayerDatabase.DefaultRole then
			vRoleCode = gCalendarEventViewer_SelectedPlayerDatabase.DefaultRole;
		end
				
		CalendarEventViewer_SetAttendanceVisible(true);
				
		if not pSkipAttendanceFields then
			CalendarDropDown_SetSelectedValue(CalendarEventViewerCharacterMenu, gCalendarEventViewer_SelectedPlayerDatabase.UserName);
		end
		
		if EventDatabase_PlayerIsQualifiedForEvent(gCalendarEventViewer_Event, gCalendarEventViewer_SelectedPlayerDatabase.PlayerLevel) then
			--CalendarEventViewer_SetAttendanceEnabled(true);
			
			if vRSVP then
				vIsAttending = vRSVP.mStatus == "Y" or vRSVP.mStatus == "S";
				vIsNotAttending = not vIsAttending;
				vRoleCode = vRSVP.mRole;

				if vRSVP.mComment then
					vAttendanceComment = Calendar_UnescapeString(vRSVP.mComment);
				end
			end
			
			CalendarEventViewerEventFrameStatus:SetText(CalendarEventViewer_cResponseMessage[vStatus]);			
			
		--else
			--CalendarEventViewer_SetAttendanceEnabled(false);
		end
		
		if not pSkipAttendanceFields then
			CalendarEventViewerYes:SetChecked(vIsAttending);
			CalendarEventViewerNo:SetChecked(vIsNotAttending);
			CalendarEventViewerComment:SetText(vAttendanceComment);			
			CalendarEventViewer_UpdateCommentEnable();
		end

		CalendarDropDown_SetSelectedValue(CalendarEventViewerRoleMenu, EventDatabase_GetRoleByRoleCode(vRoleCode))
		
		CalendarEventViewer_UpdateEnabled();
	else
		CalendarEventViewer_SetAttendanceVisible(false);
	end
	
	if pEvent.mType ~= nil then
		CalendarEventViewerEventBackground:SetTexture(Calendar_GetEventTypeIconPath(pEvent.mType));
		if pEvent.mType == "Birth" then
			CalendarEventViewerEventBackground:SetVertexColor(1, 1, 1, 0.8);
		else
			CalendarEventViewerEventBackground:SetVertexColor(1, 1, 1, 0.19);
		end
	else
		CalendarEventViewerEventBackground:SetTexture("");
	end
end

function CalendarEventViewer_IsFutureEvent(pEvent)
	if pEvent.mDate and pEvent.mTime and pEvent.mDuration then
		local vEndDate, vEndTime = Calendar_AddTime(pEvent.mDate, pEvent.mTime, pEvent.mDuration);
		local vDate, vTime = Calendar_GetCurrentServerDateTime();

		if vDate > vEndDate or (vDate == vEndDate and vTime > vEndTime) then				
			return false;
		else
			return true;
		end
	else
		return true;
	end
end

function CalendarEventViewer_UpdateCommentEnable()
	local	vEnable = CalendarEventViewerYes:GetChecked() or CalendarEventViewerNo:GetChecked();
	
	Calendar_SetEditBoxEnable(CalendarEventViewerComment, vEnable);
end

function CalendarEventViewer_SetAttendanceEnabled(pEnable)
	Calendar_SetCheckButtonEnable(CalendarEventViewerYes, pEnable);
	Calendar_SetCheckButtonEnable(CalendarEventViewerNo, pEnable);
	Calendar_SetEditBoxEnable(CalendarEventViewerComment, pEnable);
	
	if pEnable then
		CalendarEventViewerEventFrameStatus:Show();
	else
		CalendarEventViewerEventFrameStatus:Hide();
	end
end

function CalendarEventViewer_SetAttendanceVisible(pVisible)
	if pVisible then
		CalendarEventViewerCharacter:Show();
		CalendarEventViewerRole:Show();
		CalendarEventViewerYes:Show();
		CalendarEventViewerNo:Show();
		CalendarEventViewerComment:Show();
		CalendarEventViewerEventFrameStatus:Show();
		CalendarEventViewerFrameTab2:Show();
	else
		CalendarEventViewerCharacter:Hide();
		CalendarEventViewerRole:Hide();
		CalendarEventViewerYes:Hide();
		CalendarEventViewerNo:Hide();
		CalendarEventViewerComment:Hide();
		CalendarEventViewerEventFrameStatus:Hide();
		CalendarEventViewerFrameTab2:Hide();
	end
end

function CalendarEventViewer_CalculateResponseStatus(pPendingRSVP, pEventRSVP)
	if (pEventRSVP and pEventRSVP.mStatus == "-") then
		return 6; -- Banned
	elseif pPendingRSVP then
		return 2; -- Pending
	elseif pEventRSVP then
		if pEventRSVP.mStatus == "Y" then
			return 3;
		elseif pEventRSVP.mStatus == "S" then
			return 4;
		elseif pEventRSVP.mStatus == "N" then
			return 5;
		end
	else
		return 1;
	end
end

function CalendarEventViewer_ShowPanel(pPanelIndex)
	if gCalendarEventViewer_CurrentPanel > 0
	and gCalendarEventViewer_CurrentPanel ~= pPanelIndex then
		CalendarEventViewer_HidePanel(gCalendarEventViewer_CurrentPanel);
	end
	
	-- NOTE: Don't check for redundant calls since self function
	-- will be called to reset the field values as well as to 
	-- actuall show the panel when it's hidden
	
	gCalendarEventViewer_CurrentPanel = pPanelIndex;
	
	-- Update the control values
	
	if pPanelIndex == 1 then
		-- Event panel

		CalendarEventViewerParchment:Show();
		
	elseif pPanelIndex == 2 then
		-- Attendance panel
		
		CalendarEventViewerParchment:Hide();
		
		if EventDatabase_IsQuestingEventType(gCalendarEventViewer_Event.mType) then
			CalendarAttendanceList_SetClassTotalsVisible(CalendarEventViewerAttendance, true, false);
		else
			CalendarAttendanceList_SetClassTotalsVisible(CalendarEventViewerAttendance, false, false);
		end
	else
		Calendar_DebugMessage("CalendarEventViewer_ShowPanel: Unknown index ("..pPanelIndex..")");
	end
	
	getglobal(gCalendarEventViewer_PanelFrames[pPanelIndex]):Show();
	
	PanelTemplates_SetTab(CalendarEventViewerFrame, pPanelIndex);
end

function CalendarEventViewer_HidePanel(pFrameIndex)
	if gCalendarEventViewer_CurrentPanel ~= pFrameIndex then
		return;
	end
	
	--CalendarEventViewer_Save();
	
	getglobal(gCalendarEventViewer_PanelFrames[pFrameIndex]):Hide();
	gCalendarEventViewer_CurrentPanel = 0;
end

function CalendarEventViewer_AskDeleteEvent()
	-- If it's new just kill it without asking
	
	if gCalendarEventViewer_Event.mPrivate then		
		StaticPopup_Show("CONFIRM_CALENDAR_VIEWER_EVENT_DELETE", EventDatabase_GetEventDisplayName(gCalendarEventViewer_Event));
	end
end


function CalendarEventViewer_DeleteEvent()
	
	EventDatabase_DeleteEvent(gCalendarEventViewer_Database, gCalendarEventViewer_Event);	
	CalendarEventViewer_Close(true);
end