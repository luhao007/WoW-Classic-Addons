gDaysInMonth = {31, 28, 31, 30,  31,  30,  31,  31,  30,  31,  30,  31};
gDaysToMonth = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};

gCalendarDisplayStartDayOfWeek = 0;
gCalendarDisplayStartDate = 0;
gCalendarDisplayEndDate = 0;

gCalendarActualDate = -1;
gCalendarActualDateIndex = -1;

gCalendarSelectedDate = -1;
gCalendarSelectedDateIndex = -1;

gCalendarPlayerList_cNumVisibleEntries = 5;
gCalendarPlayerList_cItemHeight = 15;

gCalendarMinutesPerDay = 1440;
gCalendarSecondsPerDay = gCalendarMinutesPerDay * 60;

gCalendar_InitializedDebug = false;
gCalendar_DebugFrame = nil;

gGroupCalendar_PrimaryTradeskills =
{
	Herbalism =
	{
		name = GroupCalendar_cHerbalismSkillName,
		cooldownItems = {}
	},
	
	Alchemy =
	{
		name = GroupCalendar_cAlchemySkillName,
		
		cooldownItems =
		{
			GroupCalendar_cTransmuteMithrilToTruesilver,
			GroupCalendar_cTransmuteIronToGold,
			GroupCalendar_cTransmuteLifeToEarth,
			GroupCalendar_cTransmuteWaterToUndeath,
			GroupCalendar_cTransmuteWaterToAir,
			GroupCalendar_cTransmuteUndeathToWater,
			GroupCalendar_cTransmuteFireToEarth,
			GroupCalendar_cTransmuteEarthToLife,
			GroupCalendar_cTransmuteEarthToWater,
			GroupCalendar_cTransmuteAirToFire,
			GroupCalendar_cTransmuteArcanite,
		}
	},
	Enchanting =
	{
		name = GroupCalendar_cEnchantingSkillName,
		cooldownItems = {}
	},
	Engineering =
	{
		name = GroupCalendar_cEngineeringSkillName,
		cooldownItems = {}
	},
	Leatherworking =
	{
		name = GroupCalendar_cLeatherworkingSkillName,
		cooldownItems = {}
	},
	Blacksmithing =
	{
		name = GroupCalendar_cBlacksmithingSkillName,
		cooldownItems = {}
	},
	Tailoring =
	{
		name = GroupCalendar_cTailoringSkillName,
		cooldownItems =
		{
			GroupCalendar_cMooncloth,
		}
	},
	Mining =
	{
		name = GroupCalendar_cMiningSkillName,
		cooldownItems = {}
	},
	Skinning =
	{
		name = GroupCalendar_cSkinningSkillName,
		cooldownItems = {}
	},
};

function Calendar_InitDebugging()
	if gCalendar_InitializedDebug then
		return;
	end
	
	gCalendar_InitializedDebug = true;
	
	-- Find the debug frame if there is one
	
	for vChatIndex = 1, NUM_CHAT_WINDOWS do
		local	vFrameName = "ChatFrame"..vChatIndex;
		local	vChatFrame = getglobal(vFrameName);
		
		if vChatFrame
		and (vChatFrame:IsVisible() or vChatFrame.isDocked) then
			local	vTab = getglobal("ChatFrame"..vChatIndex.."Tab");
			local	vName = vTab:GetText();
			
			if vName == "Debug" then
				gCalendar_DebugFrame = vChatFrame;
				_ERRORMESSAGE = function(message) Calendar_DebugMessage(message); end;
			end
		end
	end
	
	if gCalendar_DebugFrame then
		Calendar_DebugMessage("Found debugging chat frame");
	end
end

function Calendar_DebugMessage(pMessage)
	if gGroupCalendar_Settings.Debug then
		if gCalendar_DebugFrame then
			gCalendar_DebugFrame:AddMessage("DEBUG: "..pMessage, 0.7, 0.3, 1.0);
		
			local vTabFlash = getglobal(gCalendar_DebugFrame:GetName().."TabFlash");
		
			vTabFlash:Show();
			UIFrameFlash(vTabFlash, 0.25, 0.25, 60, nil, 0.5, 0.5);
		else
			DEFAULT_CHAT_FRAME:AddMessage("DEBUG: "..pMessage, 0.7, 0.3, 1.0);
		end
	end
end

function Calendar_NoteMessage(pMessage)
	DEFAULT_CHAT_FRAME:AddMessage(pMessage, 0.8, 0.8, 0.5);
end

function Calendar_ErrorMessage(pMessage)
	DEFAULT_CHAT_FRAME:AddMessage(pMessage, 0.8, 0.3, 0.5);
end

function Calendar_TestMessage(pMessage)
	if gCalendar_DebugFrame then
		gCalendar_DebugFrame:AddMessage("TEST: "..pMessage, 0.7, 0.3, 1.0);
	else
		DEFAULT_CHAT_FRAME:AddMessage("TEST: "..pMessage, 0.7, 0.3, 1.0);
	end
end

function Calendar_DebugDate(pDate)
	local	vDateString = Calendar_GetLongDateString(pDate, true);
	
	Calendar_DebugMessage(vDateString);
end

function Calendar_GetCurrentYearMonthDayHourMinute()
	local	vDate = date("*t");
	
	return vDate.year, vDate.month, vDate.day, vDate.hour, vDate.min, vDate.sec;
end


function Calendar_GetCurrentLocalDateTime60()
	local	vDate = date("*t");
	
	return Calendar_ConvertMDYToDate(vDate.month, vDate.day, vDate.year), Calendar_ConvertHMSToTime60(vDate.hour, vDate.min, vDate.sec);
end

function Calendar_AddTime(vDate, vTime, vAddTime)
	-- This works with negative numbers too
	if vAddTime then		
		local vNewTime = vTime + vAddTime;
		local vDaysToAdd = math.floor(vNewTime / gCalendarMinutesPerDay);
		vNewTime = vNewTime - (vDaysToAdd * gCalendarMinutesPerDay);
			
		return Calendar_AddDays(vDate, vDaysToAdd), vNewTime;		
	else
		return vDate, vTime;
	end
end

function Calendar_AddTime60(vDate, vTime, vAddTime)
	-- This works with negative numbers too
	if vAddTime then		
		local vNewTime = vTime + vAddTime;
		local vDaysToAdd = math.floor(vNewTime / gCalendarSecondsPerDay);
		vNewTime = vNewTime - (vDaysToAdd * gCalendarSecondsPerDay);
			
		return Calendar_AddDays(vDate, vDaysToAdd), vNewTime;		
	else
		return vDate, vTime;
	end
end

function Calendar_AddDays(vDate, vDays)
	if vDate then
		local vMonth, vDay, vYear = Calendar_ConvertDateToMDY(vDate);
		
		if vMonth and vDay and vYear then
			if vDays > 0 then
				-- Adding days;
				local vRemaining = vDays;

				while vRemaining > 0 do

					local vDaysInMonth = Calendar_GetDaysInMonth(vMonth, vYear) - vDay;
				
					if vRemaining <= vDaysInMonth then
						vDay = vDay + vRemaining;
						vRemaining = 0;
					else
						vDay = 1;
						vRemaining = vRemaining - vDaysInMonth - 1;
						vMonth = vMonth + 1;
						if vMonth > 12 then
							vMonth = 1;
							vYear = vYear + 1;
						end
					end				
				end
			elseif vDays < 0 then
				-- Subtracting days;
				local vRemaining = vDays * -1;

				while vRemaining > 0 do

					local vDaysInMonth = vDay;
				
					if vRemaining < vDaysInMonth then
						vDay = vDay - vRemaining;
						vRemaining = 0;
					else
						vMonth = vMonth - 1;
						if vMonth < 1 then
							vMonth = 12;
							vYear = vYear - 1;
						end

						vDay = Calendar_GetDaysInMonth(vMonth, vYear);
						vRemaining = vRemaining - vDaysInMonth;				
					
					end				
				end
			
			end
		else
			return nil;
		end	 

		return Calendar_ConvertMDYToDate(vMonth, vDay, vYear);
	else
		return nil;
	end
end

function Calendar_GetCurrentLocalDateTime()
	local	vDate = date("*t");
	
	return Calendar_ConvertMDYToDate(vDate.month, vDate.day, vDate.year), Calendar_ConvertHMToTime(vDate.hour, vDate.min);
end

function Calendar_GetCurrentUTCDateTime()
	local	vDate = date("!*t");
	
	return Calendar_ConvertMDYToDate(vDate.month, vDate.day, vDate.year), Calendar_ConvertHMToTime(vDate.hour, vDate.min);
end

function Calendar_GetCurrentLocalDate()
	local	vDate = date("*t");
	
	return Calendar_ConvertMDYToDate(vDate.month, vDate.day, vDate.year);
end

function Calendar_GetCurrentLocalTime()
	local	vDate = date("*t");
	
	return Calendar_ConvertHMToTime(vDate.hour, vDate.min);
end

function Calendar_GetCurrentUTCDateTime()
	local	vDate = date("!*t");
	
	return Calendar_ConvertMDYToDate(vDate.month, vDate.day, vDate.year), Calendar_ConvertHMToTime(vDate.hour, vDate.min);
end

function Calendar_GetCurrentUTCTime()
	local	vDate = date("!*t");
	
	return Calendar_ConvertHMToTime(vDate.hour, vDate.min);
end

function Calendar_GetCurrentServerTime()
	return Calendar_ConvertHMToTime(GetGameTime());
end

function Calendar_GetCurrentServerDateTime()
	return Calendar_GetServerDateTimeFromLocalDateTime(Calendar_GetCurrentLocalDateTime());
end

function Calendar_SetCheckButtonEnable(pCheckButton, pEnabled)
	if pEnabled then
		pCheckButton:Enable();
		pCheckButton:SetAlpha(1.0);
		getglobal(pCheckButton:GetName().."Text"):SetAlpha(1.0);
	else
		pCheckButton:Disable();
		pCheckButton:SetAlpha(0.7);
		getglobal(pCheckButton:GetName().."Text"):SetAlpha(0.7);
	end
end

function Calendar_SetEditBoxEnable(pEditBox, pEnabled)
	local	vText = getglobal(pEditBox:GetName().."Text");
	
	if pEnabled then
		pEditBox:SetAlpha(1.0);
		if vText then
			vText:SetAlpha(1.0);
		end
		pEditBox:EnableKeyboard(true);
		pEditBox:EnableMouse(true);
		
		pEditBox.isDisabled = false;
	else
		pEditBox:SetAlpha(0.7);
		if vText then
			vText:SetAlpha(0.7);
		end
		
		pEditBox:ClearFocus();
		pEditBox:EnableKeyboard(false);
		pEditBox:EnableMouse(false);

		pEditBox.isDisabled = true;
	end
end

function Calendar_SetDropDownEnable(pDropDown, pEnabled)
	if pEnabled then
		pDropDown:SetAlpha(1.0);
		local txt = _G[pDropDown:GetName().."Text"];
		if txt then
			txt:SetAlpha(1.0);
		end

		local btn = _G[pDropDown:GetName().."Button"];
		if btn then
			btn:EnableMouse(true);
		end

		--getglobal(pDropDown:GetName().."Text"):SetAlpha(1.0);
		--getglobal(pDropDown:GetName().."Button"):EnableMouse(true);
	else
		pDropDown:SetAlpha(0.7);

		local txt = _G[pDropDown:GetName().."Text"];
		if txt then
			txt:SetAlpha(0.7);
		end

		local btn = _G[pDropDown:GetName().."Button"];
		if btn then
			btn:EnableMouse(false);
		end

		--getglobal(pDropDown:GetName().."Text"):SetAlpha(0.7);
		--getglobal(pDropDown:GetName().."Button"):EnableMouse(false);
	end
end

function Calendar_SetButtonEnable(pButton, pEnabled)
	if pEnabled then
		pButton:Enable();
		pButton:SetAlpha(1.0);
		pButton:EnableMouse(true);
		--getglobal(pButton:GetName().."Text"):SetAlpha(1.0);
	else
		pButton:Disable();
		pButton:SetAlpha(0.7);
		pButton:EnableMouse(false);
		--getglobal(pButton:GetName().."Text"):SetAlpha(0.7);
	end
end

function CalendarDropDown_SetSelectedValue2(pDropDown, pValue)
	pDropDown.selectedName = nil;
	pDropDown.selectedID = nil;
	pDropDown.selectedValue = pValue;
end

function CalendarDropDown_SetSelectedValue(pDropDown, pValue)
	-- Just return if the value isn't changing
	
	if pDropDown.selectedValue == pValue then
		return;
	end
	
	--
	
	UIDropDownMenu_SetText(pDropDown, ""); -- Set to empty in case the selected value isn't there

	UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize);
	UIDropDownMenu_SetSelectedValue(pDropDown, pValue);
	
	-- All done if the item text got set successfully
	
	local	vItemText = UIDropDownMenu_GetText(pDropDown);
	if vItemText and vItemText ~= "" and vItemText ~= "Custom" then
		return;
	end
	
	-- Scan for submenus
	
	local	vRootListFrameName = "DropDownList1";
	local	vRootListFrame = getglobal(vRootListFrameName);
	local	vRootNumItems = vRootListFrame.numButtons;
	for vRootItemIndex = 1, vRootNumItems do
		local	vItem = getglobal(vRootListFrameName.."Button"..vRootItemIndex);		

		if vItem.hasArrow then
			local	vSubMenuFrame = getglobal("DropDownList2");
			
			UIDROPDOWNMENU_OPEN_MENU = pDropDown:GetName();
			UIDROPDOWNMENU_MENU_VALUE = vItem.value;
			UIDROPDOWNMENU_MENU_LEVEL = 2;
			
			UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize, nil, 2);
			UIDropDownMenu_SetSelectedValue(pDropDown, pValue);
			
			-- All done if the item text got set successfully
			
			local	vItemText = UIDropDownMenu_GetText(pDropDown);
			
			if vItemText and vItemText ~= "" then
				return;
			end
			
			-- Switch back to the root menu
			
			UIDROPDOWNMENU_OPEN_MENU = nil;
			UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize, nil, 1);
		end
	end
end

function Calendar_GetShortTimeString(pTime)
	if pTime == nil then
		return nil;
	end
	
	if gGroupCalendar_Settings.Use24HrTime then
		local	vHour, vMinute = Calendar_ConvertTimeToHM(pTime);
		
		return format(TIME_TWENTYFOURHOURS, vHour, vMinute);
	else
		local	vHour, vMinute, vAMPM = Calendar_ConvertTimeToHMAMPM(pTime);
		
		if vAMPM == 0 then
			return format(TIME_TWELVEHOURAM, vHour, vMinute);
		else
			return format(TIME_TWELVEHOURPM, vHour, vMinute);
		end
	end
end

function Calendar_ConvertTimeToHM(pTime)
	local	vMinute = math.fmod(pTime, 60);
	local	vHour = (pTime - vMinute) / 60;
	
	return vHour, vMinute;
end

function Calendar_ConvertHMToTime(pHour, pMinute)
	return pHour * 60 + pMinute;
end

function Calendar_ConvertHMSToTime60(pHour, pMinute, pSecond)
	return pHour * 3600 + pMinute * 60 + pSecond;
end

function Calendar_ConvertTimeToHMAMPM(pTime)
	local	vHour, vMinute = Calendar_ConvertTimeToHM(pTime);
	local	vAMPM;
	
	if vHour < 12 then
		vAMPM = 0;
		
		if vHour == 0 then
			vHour = 12;
		end
	else
		vAMPM = 1;

		if vHour > 12 then
			vHour = vHour - 12;
		end
	end

	return vHour, vMinute, vAMPM;
end

function Calendar_ConvertHMAMPMToTime(pHour, pMinute, pAMPM)
	local		vHour;
	
	if pAMPM == 0 then
		vHour = pHour;
		if vHour == 12 then
			vHour = 0;
		end
	else
		vHour = pHour + 12;
		if vHour == 24 then
			vHour = 12;
		end
	end
	
	return Calendar_ConvertHMToTime(vHour, pMinute);
end

function Calendar_GetLongDateString(pDate, pIncludeDayOfWeek)
	local	vFormat;
	
	if pIncludeDayOfWeek then
		vFormat = GroupCalendar_cLongDateFormatWithDayOfWeek;
	else
		vFormat = GroupCalendar_cLongDateFormat;
	end
	
	return Calendar_GetFormattedDateString(pDate, vFormat);
end

function Calendar_GetShortDateString(pDate, pIncludeDayOfWeek)
	return Calendar_GetFormattedDateString(pDate, GroupCalendar_cShortDateFormat);
end

function Calendar_FormatNamed(pFormat, pFields)
	return string.gsub(
					pFormat,
					"%$(%w+)", 
					function (pField)
						return pFields[pField];
					end);
end

function Calendar_GetFormattedDateString(pDate, pFormat)
	local	vMonth, vDay, vYear = Calendar_ConvertDateToMDY(pDate);

	local	vDate =
			{
				dow = GroupCalendar_cDayOfWeekNames[Calednar_get_day_of_week(vDay, vMonth, vYear)],
				month = GroupCalendar_cMonthNames[vMonth],
				monthNum = vMonth,
				day = vDay,
				year = vYear,
			};
	
	return Calendar_FormatNamed(pFormat, vDate);
end

function Calednar_get_day_of_week(dd, mm, yy) 

  local mmx = mm

  if (mm == 1) then  mmx = 13; yy = yy-1  end
  if (mm == 2) then  mmx = 14; yy = yy-1  end

  local val8 = dd + (mmx*2) +  math.floor(((mmx+1)*3)/5)   + yy + math.floor(yy/4)  - math.floor(yy/100)  + math.floor(yy/400) + 2
  local val9 = math.floor(val8/7)
  local dw = val8-(val9*7) 

  if (dw == 0) then
    dw = 7
  end

  return dw
end

function Calendar_SetDisplayDate(pStartDate)
	local		vMonth, vDay, vYear = Calendar_ConvertDateToMDY(pStartDate);
	local		vDaysInMonth = Calendar_GetDaysInMonth(vMonth, vYear);
	
	Calendar_SetCalendarRange(
			Calendar_GetDayOfWeek(vMonth, 1, vYear),
			vDaysInMonth);
	
	local	vCalendarTitle = getglobal("GroupCalendarMonthYearText");
	
	vCalendarTitle:SetText(GroupCalendar_cMonthNames[vMonth].." "..vYear);

	gCalendarDisplayStartDate = pStartDate;
	gCalendarDisplayEndDate = pStartDate + vDaysInMonth;
	
	Calendar_HiliteActualDate();
	Calendar_HiliteSelectedDate();
	
	Calendar_UpdateEventIcons();
end

function Calendar_SetActualDate(pDate)
	gCalendarActualDate= pDate;
	Calendar_HiliteActualDate();
end

function Calendar_HiliteActualDate()
	local	vDayButton;

	if gCalendarActualDateIndex >= 0 then
		
		vDayButton = getglobal("GroupCalendarDay"..gCalendarActualDateIndex.."SlotIcon");
		vDayButton:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled");

		vDayButtonText = getglobal("GroupCalendarDay"..gCalendarActualDateIndex.."Name");
		vDayButtonText:SetFontObject(GameFontHighlightSmallOutline);

		gCalendarActualDateIndex = -1;
		
		GroupCalendarTodayHighlight:Hide();
	end
	
	if gCalendarActualDate < gCalendarDisplayStartDate
	or gCalendarActualDate >= gCalendarDisplayEndDate then
		return;
	end
	
	gCalendarActualDateIndex = gCalendarActualDate - gCalendarDisplayStartDate + gCalendarDisplayStartDayOfWeek;
	
	if gCalendarActualDateIndex >= 0 then
		local	vDayButtonName = "GroupCalendarDay"..gCalendarActualDateIndex;
		local	vDayButtonIconName = vDayButtonName.."SlotIcon";
		local	vDayButtonDate = vDayButtonName.."Name";
		
		vDayButton = getglobal(vDayButtonIconName);
		vDayButton:SetTexture("Interface\\Buttons\\UI-EmptySlot");
		GroupCalendarTodayHighlight:SetPoint("CENTER", vDayButtonName, "CENTER", 0, -1);
		GroupCalendarTodayHighlight:Show();

		vDayButtonText = getglobal(vDayButtonDate);
		vDayButtonText:SetFontObject(GameFontGreenSmall);
	end
end

function Calendar_SetSelectedDate(pDate)
	gCalendarSelectedDate = pDate;
	
	Calendar_HiliteSelectedDate();
end

function Calendar_ClearSelectedDate()
	gCalendarSelectedDate = -1;
	Calendar_HiliteSelectedDate();
end

function Calendar_SetSelectedDateIndexWithToggle(pIndex)
	GroupCalendar_SelectDateWithToggle(
			gCalendarDisplayStartDate + pIndex - gCalendarDisplayStartDayOfWeek);
end

function Calendar_SetSelectedDateIndex(pIndex)
	GroupCalendar_SelectDate(
			gCalendarDisplayStartDate + pIndex - gCalendarDisplayStartDayOfWeek);
end

function Calendar_HiliteSelectedDate()
	local	vDayButton;
	
	if gCalendarSelectedDateIndex >= 0 then
		vDayButton = getglobal("GroupCalendarDay"..gCalendarSelectedDateIndex);
		vDayButton:SetChecked(nil);
		gCalendarSelectedDateIndex = -1;
	end
	
	if gCalendarSelectedDate < gCalendarDisplayStartDate
	or gCalendarSelectedDate >= gCalendarDisplayEndDate then
		return;
	end
	
	gCalendarSelectedDateIndex = gCalendarSelectedDate - gCalendarDisplayStartDate + gCalendarDisplayStartDayOfWeek;
	
	if gCalendarSelectedDateIndex >= 0 then
		vDayButton = getglobal("GroupCalendarDay"..gCalendarSelectedDateIndex);
		vDayButton:SetChecked(true);
	end
end

function Calendar_GetEventTypeIconPath(pEventType)
	local	vIconSuffix;

	if EventDatabase_IsResetEventType(pEventType) then
		local	vIsSystemIcon;
		
		vIconSuffix, vIsSystemIcon = EventDatabase_GetResetEventLargeIconPath(pEventType);
		
		if not vIconSuffix then
			return "";
		end
		
		if vIsSystemIcon then
			return vIconSuffix;
		end
	else
		if EventDatabase_GetEventNameByID(pEventType) then -- Don't attempt to show icons for event types we don't recognize
			vIconSuffix = pEventType;
		else
			vIconSuffix = "Unknown";
		end
	end
	
	local path = "Interface\\AddOns\\GroupCalendar\\Textures\\Icon-"..vIconSuffix;
	return path;
end

function Calendar_UpdateCompiledEventIcon(pDate, pCompiledSchedule, pCutoffServerDate, pCutoffServerTime)
	if pDate < gCalendarDisplayStartDate or pDate >= gCalendarDisplayEndDate then
		return;
	end
	
	local		vIndex = pDate - gCalendarDisplayStartDate + gCalendarDisplayStartDayOfWeek;
	local		vDayIcon = getglobal("GroupCalendarDay"..vIndex.."Icon");
	local		vOverlayIcon = getglobal("GroupCalendarDay"..vIndex.."OverlayIcon");
	local		vCircledDate = getglobal("GroupCalendarDay"..vIndex.."CircledDate");
	local		vDogEarIcon = getglobal("GroupCalendarDay"..vIndex.."DogEarIcon");
	
	vOverlayIcon:Hide();
	
	if pCompiledSchedule then
		local		vDayIconType = nil;
		local		vUnqualifiedDayIconType = nil;
		local		vExpiredDayIconType = nil;
		local		vExpiredUnqualifiedDayIconType = nil;
		local		vResetEventType = nil;
		local		vExpiredResetEventType = nil;
		
		local		vShowBirthdayIcon = false;
		local		vHasAppointment = false;
		local		vAppointmentIsDimmed = false;
		local		vGotDogEarEvent = false;
		
		for vEventIndex, vCompiledEvent in pairs(pCompiledSchedule) do
			local	vPlayerIsQualified = EventDatabase_PlayerIsQualifiedForEvent(vCompiledEvent, gGroupCalendar_PlayerLevel);
			
			if vCompiledEvent.mType then
				-- Determine if the event is expired
				
				local	vEventIsExpired = false;
				
				if pCutoffServerDate
				and pCutoffServerTime
				and vCompiledEvent.mTime
				and vCompiledEvent.mDuration then
					local	vEventEndDate, vEventEndTime = Calendar_AddTime(vCompiledEvent.mDate, vCompiledEvent.mTime, vCompiledEvent.mDuration);
					
					if vEventEndDate < pCutoffServerDate 
						or (vEventEndDate == pCutoffServerDate and vEventEndTime < pCutoffServerTime) then

						vEventIsExpired = true;
					end
				end
				
				-- Check for birthday events
				
				if vCompiledEvent.mType == "Birth" then
					vShowBirthdayIcon = true;
				
				-- Check for cooldown/reset events
				
				elseif EventDatabase_IsResetEventType(vCompiledEvent.mType) then
				
					if vEventIsExpired then
						if not vExpiredResetEventType then
							vExpiredResetEventType = vCompiledEvent.mType;
						end
					else
						if not vResetEventType then
							vResetEventType = vCompiledEvent.mType;
						end
					end
					
				-- Check for ordinary events
					
				else
					local	vIconPath = Calendar_GetEventTypeIconPath(vCompiledEvent.mType);
					
					if not vPlayerIsQualified then
						if vEventIsExpired then
							if not vExpiredUnqualifiedDayIconType then
								vExpiredUnqualifiedDayIconType = vIconPath;
							end
						else
							if not vUnqualifiedDayIconType then
								vUnqualifiedDayIconType = vIconPath;
							end
						end
					else
						if vEventIsExpired then
							if not vExpiredDayIconType then
								vExpiredDayIconType = vIconPath;
							end
						else
							if not vDayIconType then
								vDayIconType = vIconPath;
							end
						end
					end
				end -- else Birth
			end -- if mType
			
			if (not vHasAppointment
			or (vAppointmentIsDimmed and vPlayerIsQualified))
			and EventDatabase_PlayerIsAttendingEvent(gGroupCalendar_PlayerName , vCompiledEvent) then
				vHasAppointment = true;
				vAppointmentIsDimmed = not vPlayerIsQualified;
			end
		end -- for vEventIndex
		
		-- Update the day icon
		
		if vDayIconType then
			vDayIcon:SetTexture(vDayIconType);
			vDayIcon:SetAlpha(1.0);
			vDayIcon:Show();
		elseif vUnqualifiedDayIconType then
			vDayIcon:SetTexture(vUnqualifiedDayIconType);
			vDayIcon:SetAlpha(0.25);
			vDayIcon:Show();
		elseif vExpiredDayIconType then
			vDayIcon:SetTexture(vExpiredDayIconType);
			vDayIcon:SetAlpha(1.0);
			vDayIcon:Show();
		elseif vExpiredUnqualifiedDayIconType then
			vDayIcon:SetTexture(vExpiredUnqualifiedDayIconType);
			vDayIcon:SetAlpha(0.25);
			vDayIcon:Show();
		else
			vDayIcon:SetTexture(nil);
			vDayIcon:Hide();
		end
		
		-- Show or hide the birthday icon
		
		if vShowBirthdayIcon then
			vOverlayIcon:SetTexture(Calendar_GetEventTypeIconPath("Birth"));
			vOverlayIcon:Show();
		else
			vOverlayIcon:Hide();
		end
		
		-- Circle the date if necessary
		
		if vHasAppointment then
			if vAppointmentIsDimmed then
				-- Show dimmed
				
				vCircledDate:Show();
				vCircledDate:SetAlpha(0.4);
			else
				-- Show full brightness
				
				vCircledDate:Show();
				vCircledDate:SetAlpha(1.0);
			end
		else
			vCircledDate:Hide();
		end
		
		-- Show the dog ear
		
		if vResetEventType
		or vExpiredResetEventType then
			if not vResetEventType then
				vResetEventType = vExpiredResetEventType;
			end
			
			local	vIconCoords = EventDatabase_GetResetIconCoords(vResetEventType);
			
			if vIconCoords then
				vDogEarIcon:SetTexCoord(vIconCoords.left, vIconCoords.right, vIconCoords.top, vIconCoords.bottom);
				vDogEarIcon:Show();
			else
				vDogEarIcon:Hide();
			end
		else
			vDogEarIcon:Hide();
		end
		
	else -- if pCompiledSchedule
		vDayIcon:SetTexture(nil);
		vDayIcon:Hide();
	end
end

function Calendar_GetCurrentCutoffDateTime()
	local		vCurrentDate, vCurrentTime;
	
	if gGroupCalendar_Settings.ShowEventsInLocalTime then
		local	vServerDate, vServerTime;
		
		vCurrentDate, vCurrentTime = Calendar_GetCurrentLocalDateTime();
		vServerDate, vServerTime = Calendar_GetServerDateTimeFromLocalDateTime(vCurrentDate, vCurrentTime);
	else
		vCurrentDate, vCurrentTime = Calendar_GetCurrentServerDateTime();
	end
	
	return vCurrentDate, vCurrentTime
end

function Calendar_UpdateEventIcons()
	local		vIndex = gCalendarDisplayStartDayOfWeek;
	local		vCurrentDate, vCurrentTime = Calendar_GetCurrentCutoffDateTime();

	for vDate = gCalendarDisplayStartDate, gCalendarDisplayEndDate - 1 do
		local	vCompiledSchedule = EventDatabase_GetCompiledSchedule(vDate);
		local	vCutoffDate, vCutoffTime;
		
		if vDate == vCurrentDate then
			vCutoffDate = vCurrentDate;
			vCutoffTime = vCurrentTime;
		end
		
		Calendar_UpdateCompiledEventIcon(vDate, vCompiledSchedule, vCutoffDate, vCutoffTime);
		
		vIndex = vIndex + 1;
	end
end

function Calendar_ScheduleChanged(pDate, pSchedule)
	if not GroupCalendarFrame:IsVisible() then
		return;
	end
	
	local		vCompiledSchedule = EventDatabase_GetCompiledSchedule(pDate);
	local		vCurrentDate, vCurrentTime = Calendar_GetCurrentCutoffDateTime();
	local		vCutoffDate, vCutoffTime;
	
	if pDate == vCurrentDate then
		vCutoffDate = vCurrentDate;
		vCutoffTime = vCurrentTime;
	end
	
	Calendar_UpdateCompiledEventIcon(pDate, vCompiledSchedule, vCutoffDate, vCutoffTime);
end

function Calendar_MajorDatabaseChange()
	if not GroupCalendarFrame:IsVisible() then
		return;
	end
	
	Calendar_UpdateEventIcons();
end

function Calendar_NextMonth()
	local	vMonth, vDay, vYear = Calendar_ConvertDateToMDY(gCalendarDisplayStartDate);
	
	vMonth = vMonth + 1;
	
	if vMonth == 13 then
		vMonth = 1;
		vYear = vYear + 1;
	end
	
	Calendar_SetDisplayDate(Calendar_ConvertMDYToDate(vMonth, 1, vYear));
end

function Calendar_PreviousMonth()
	local	vMonth, vDay, vYear = Calendar_ConvertDateToMDY(gCalendarDisplayStartDate);
	
	vMonth = vMonth - 1;
	
	if vMonth == 0 then
		vMonth = 12;
		vYear = vYear - 1;
	end
	
	Calendar_SetDisplayDate(Calendar_ConvertMDYToDate(vMonth, 1, vYear));
end

function Calendar_Today()
	local	vMonth, vDay, vYear = Calendar_ConvertDateToMDY(gCalendarActualDate);
	
	Calendar_SetDisplayDate(Calendar_ConvertMDYToDate(vMonth, 1, vYear));
	GroupCalendar_SelectDateWithToggle(gCalendarActualDate);
end

function Calendar_SetCalendarRange(pStartDay, pNumDays)
	-- Hide days before the start day
	
	gCalendarDisplayStartDayOfWeek = pStartDay;
	
	for vIndex = 0, pStartDay - 1 do
		local	vDayButton = getglobal("GroupCalendarDay"..vIndex);
		vDayButton:Hide();
	end
	
	-- Set the text of the days
	
	for vIndex = pStartDay, pStartDay + pNumDays - 1 do
		local	vDayNumber = vIndex - pStartDay + 1;
		
		local	vDayButton = getglobal("GroupCalendarDay"..vIndex);
		local	vDayIcon = getglobal("GroupCalendarDay"..vIndex.."Icon");
		local	vDayText = getglobal("GroupCalendarDay"..vIndex.."Name");
		
		vDayButton:Show();
		vDayText:SetText(vDayNumber);
	end
	
	-- Hide the days after the end day
	
	for vIndex = pStartDay + pNumDays, 36 do
		local	vDayButton = getglobal("GroupCalendarDay"..vIndex);
		vDayButton:Hide();
	end
end

function Calendar_GetDaysInMonth(pMonth, pYear)
	if pMonth == 2 and Calendar_IsLeapYear(pYear) then
		return gDaysInMonth[pMonth] + 1;
	else
		return gDaysInMonth[pMonth];
	end
end

function Calendar_GetDaysToMonth(pMonth, pYear)
	if pMonth > 2 and Calendar_IsLeapYear(pYear) then
		return gDaysToMonth[pMonth] + 1;
	elseif pMonth == 2 then
		return gDaysToMonth[pMonth];
	else
		return 0;
	end
end

function Calendar_GetDaysInYear(pYear)
	if Calendar_IsLeapYear(pYear) then
		return 366;
	else
		return 365;
	end
end

function Calendar_IsLeapYear(pYear)
	return (math.fmod(pYear, 400) == 0)
	   or ((math.fmod(pYear, 4) == 0) and (math.fmod(pYear, 100) ~= 0));
end

function Calendar_GetDaysToDate(pMonth, pDay, pYear)
	local	vDays;
	
	vDays = gDaysToMonth[pMonth] + pDay - 1;
	
	if Calendar_IsLeapYear(pYear) and pMonth > 2 then
		vDays = vDays + 1;
	end
	
	return vDays;
end

function Calendar_ConvertMDYToDate(pMonth, pDay, pYear)
	return tonumber(tostring(pYear) .. string.format("%02d", pMonth) .. string.format("%02d", pDay));
end

function Calendar_ConvertMDYToDate_old(pMonth, pDay, pYear)
	local		vDays = 0;
	
	for vYear = 2000, pYear - 1 do
		vDays = vDays + Calendar_GetDaysInYear(vYear);
	end
	
	return vDays + Calendar_GetDaysToDate(pMonth, pDay, pYear);
end

function Calendar_ConvertDateToMDY(pDate)
	
	local str = tostring(pDate);
	local yearstr = strsub(str, 1, 4);
	local monthstr = strsub(str, 5, 6);
	local daystr = strsub(str, 7, 8);
	return tonumber(monthstr), tonumber(daystr), tonumber(yearstr);
end

function Calendar_ConvertOldDateToNewDate(pDate)
	if pDate then
		local m, d, y = Calendar_ConvertDateToMDY_old(pDate);
		return Calendar_ConvertMDYToDate(m, d, y);
	else
		return nil;
	end
end

function Calendar_ConvertDateToMDY_old(pDate)
	local		vDays = pDate;
	local		vYear = 2000;
	local		vDaysInYear = Calendar_GetDaysInYear(vYear);
	
	while vDays >= vDaysInYear do
		vDays = vDays - vDaysInYear;

		vYear = vYear + 1;
		vDaysInYear = Calendar_GetDaysInYear(vYear);
	end
	
	local		vIsLeapYear = Calendar_IsLeapYear(vYear);
	
	for vMonth = 1, 12 do
		local vDaysInMonth = gDaysInMonth[vMonth];
		
		if vMonth == 2 and vIsLeapYear then
			vDaysInMonth = vDaysInMonth + 1;
		end
		
		if vDays < vDaysInMonth then
			return vMonth, vDays + 1, vYear;
		end
		
		vDays = vDays - vDaysInMonth;
	end
	
	-- error
	
	Calendar_DebugMessage("Calendar_ConvertDateToMDY: Failed: "..vDays.." unaccounted for in year "..vYear);

	return 0, 0, 0;
end

function Calendar_GetDayOfWeek(pMonth, pDay, pYear)
	local	vDayOfWeek = 6; -- January 1, 2000 is a Saturday
	
	for vYear = 2000, pYear - 1 do
		if Calendar_IsLeapYear(vYear) then
			vDayOfWeek = vDayOfWeek + 2;
		else
			vDayOfWeek = vDayOfWeek + 1;
		end
	end
	
	vDayOfWeek = vDayOfWeek + Calendar_GetDaysToDate(pMonth, pDay, pYear);
	
	local DOW = math.fmod(vDayOfWeek, 7);

	if gGroupCalendar_Settings.MondayFirstDOW then
		DOW = DOW - 1;
		if DOW < 0 then DOW = 6 end
	end
		
	return DOW;
	
end

function CalendarAutoSelectionDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarAutoSelectionDropDown_Initialize);
	--UIDropDownMenu_SetWidth(frame, 42);
	--UIDropDownMenu_Refresh(frame);
end

function CalendarHourDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarHourDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 42);
	UIDropDownMenu_Refresh(frame);
end

function CalendarMinuteDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarMinuteDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 43);
	UIDropDownMenu_Refresh(frame);
end

function CalendarAMPMDropDown_OnLoad(frame)
	if gGroupCalendar_Settings.Use24HrTime then
		self:Hide();
	else
		UIDropDownMenu_Initialize(frame, CalendarAMPMDropDown_Initialize);
		UIDropDownMenu_SetWidth(frame, 48);
		UIDropDownMenu_Refresh(frame);
	end
end

function CalendarDurationDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarDurationDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 120);
	UIDropDownMenu_Refresh(frame);
end

function CalendarEventTypeDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarEventTypeDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 150);
	UIDropDownMenu_Refresh(frame);
end

function CalendarGuildRank_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarGuildRankDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 100);
	UIDropDownMenu_Refresh(frame);
end

function CalendarTrustGroup_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarTrustGroupDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 220);
	UIDropDownMenu_Refresh(frame);
end

function CalendarPartySizeDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarPartySizeDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 130);
	UIDropDownMenu_Refresh(frame);
end

function CalendarPriorityDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarPriorityDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 130);
	UIDropDownMenu_Refresh(frame);
end

function CalendarCharactersDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarCharactersDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 110);
	UIDropDownMenu_Refresh(frame);
end

function CalendarRolesDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarRolesDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 110);
	UIDropDownMenu_Refresh(frame);
end

function CalendarAttendanceDropDown_OnLoad(frame)
	--UIDropDownMenu_SetAnchor(frame, -1, 4, frame, "TOPLEFT", frame:GetName(), "TOPRIGHT");
	UIDropDownMenu_Initialize(frame, CalendarAttendanceDropDown_Initialize);
	--UIDropDownMenu_Refresh(self); -- Don't refresh on menus which don't have a text portion
end

function CalendarClassDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarClassDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 110);
	UIDropDownMenu_Refresh(frame);
end

function CalendarRaceDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarRaceDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 110);
	UIDropDownMenu_Refresh(frame);
end

function CalendarStatusDropDown_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, CalendarStatusDropDown_Initialize);
	UIDropDownMenu_SetWidth(frame, 110);
	UIDropDownMenu_Refresh(frame);
end

function GroupCalendarViewMenu_OnLoad(frame)
	UIDropDownMenu_Initialize(frame, GroupCalendarViewMenu_Initialize);
	UIDropDownMenu_SetWidth(frame, 100);
	UIDropDownMenu_Refresh(frame);
end

function CalendarAutoSelectionDropDown_Initialize(vFrame, level, menuList)
	
	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = GroupCalendar_cAttending;
	vItem.arg1 = 1;
	vItem.value = 1;
	--vItem.owner = vFrame;
	vItem.func = CalendarGroupInvites_AutoSelectApprovedPlayers;
	UIDropDownMenu_AddButton(vItem);	

	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = GroupCalendar_cStandby;
	vItem.arg1 = 2;
	vItem.value = 2;
	--vItem.owner = vFrame;
	vItem.func = CalendarGroupInvites_AutoSelectStandbyPlayers;
	UIDropDownMenu_AddButton(vItem);

	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = GroupCalendar_cAll;
	vItem.arg1 = 3;
	vItem.value = 3;
	--vItem.owner = vFrame;
	vItem.func = CalendarGroupInvites_AutoSelectAllPlayers;
	UIDropDownMenu_AddButton(vItem);

	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = GroupCalendar_cClearSelected;
	vItem.arg1 = 4;
	vItem.value = 4;
	--vItem.owner = vFrame;
	vItem.func = CalendarGroupInvites_AutoSelectDeselectAllPlayers;
	UIDropDownMenu_AddButton(vItem);
end

function CalendarHourDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local	vStartHour, vEndHour;
	
	if gGroupCalendar_Settings.Use24HrTime then
		vStartHour = 0;
		vEndHour = 23;
	else
		vStartHour = 1;
		vEndHour = 12;
	end
	
	for vIndex = vStartHour, vEndHour do
		vItem = UIDropDownMenu_CreateInfo();
		vItem.text = ""..vIndex;
		vItem.arg1 = vIndex;
		vItem.value = vIndex;
		vItem.owner = vFrame;
		vItem.func = CalendarDropDown_OnClick;
		UIDropDownMenu_AddButton(vItem);
	end
end

function CalendarMinuteDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	for vIndex = 0, 59, 5 do
		vItem = UIDropDownMenu_CreateInfo();
		if vIndex < 10 then
			vItem.text = "0"..vIndex;
		else
			vItem.text = ""..vIndex;
		end
		
		vItem.value = vIndex;
		vItem.owner = vFrame;
		vItem.func = CalendarDropDown_OnClick;
		
		UIDropDownMenu_AddButton(vItem);
	end
end

function CalendarAMPMDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	--
	
	local	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = "AM";
	vItem.value = 0;
	vItem.owner = vFrame;
	vItem.func = CalendarDropDown_OnClick;

	UIDropDownMenu_AddButton(vItem);
	
	--
	
	local	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = "PM";
	vItem.value = 1;
	vItem.owner = vFrame;
	vItem.func = CalendarDropDown_OnClick;

	UIDropDownMenu_AddButton(vItem);
end

function CalendarDurationDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	--
	
	local	vDurations = {15, 30, 60, 90, 120, 150, 180, 240, 300, 360};

	for _, vDuration in pairs(vDurations) do
		local	vItem = UIDropDownMenu_CreateInfo();

		local	vMinutes = math.fmod(vDuration, 60);
		local	vHours = (vDuration - vMinutes) / 60;

		if vHours == 0 then
			vItem.text = format(GroupCalendar_cPluralMinutesFormat, vMinutes);
		else
			if vMinutes ~= 0 then
				if vHours == 1 then
					vItem.text = format(GroupCalendar_cSingularHourPluralMinutes, vHours, vMinutes);
				else
					vItem.text = format(GroupCalendar_cPluralHourPluralMinutes, vHours, vMinutes);
				end
			else
				if vHours == 1 then
					vItem.text = format(GroupCalendar_cSingularHourFormat, vHours);
				elseif vHours > 0 then
					vItem.text = format(GroupCalendar_cPluralHourFormat, vHours);
				end
			end
		end
		
		vItem.value = vDuration;
		vItem.owner = vFrame;
		vItem.func = CalendarDropDown_OnClick;

		UIDropDownMenu_AddButton(vItem);
	end
end

function Calendar_AddDividerMenuItem(vFrame)
	local	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = " ";
	vItem.notCheckable = true;
	vItem.owner = vFrame;
	vItem.notClickable = true;
	UIDropDownMenu_AddButton(vItem);
end

function Calendar_AddCategoryMenuItem(vFrame, pName)
	local	vItem = UIDropDownMenu_CreateInfo();
	vItem.text = pName;
	vItem.notCheckable = true;
	vItem.owner = vFrame;
	vItem.notClickable = true;
	UIDropDownMenu_AddButton(vItem);
end

function Calendar_AddMenuItem(pFrame, pName, pValue, pChecked, pLevel)
	UIDropDownMenu_AddButton({text = pName, value = pValue, owner = pFrame, checked = pChecked, func = CalendarDropDown_OnClick, textR = NORMAL_FONT_COLOR.r, textG = NORMAL_FONT_COLOR.g, textB = NORMAL_FONT_COLOR.b}, pLevel);
end

function Calendar_AddMenuItem2(pFrame, pName, pValue, pChecked, pLevel)
	UIDropDownMenu_AddButton({text = pName, value = pValue, owner = pFrame, checked = pChecked, func = CalendarDropDown_OnClick2, textR = NORMAL_FONT_COLOR.r, textG = NORMAL_FONT_COLOR.g, textB = NORMAL_FONT_COLOR.b}, pLevel);
end

function CalendarEventTypeDropDown_AddEventGroupSubMenu(pFrame, pEventGroupName)
	local	vEventTypes = gGroupCalendar_EventTypes[pEventGroupName];
	
	local	vItem = UIDropDownMenu_CreateInfo();

	vItem.text = vEventTypes.Title;
	vItem.owner = pFrame;
	vItem.hasArrow = true;
	vItem.notCheckable = true;
	vItem.value = pEventGroupName;
	vItem.func = nil;

	UIDropDownMenu_AddButton(vItem);
end

function CalendarEventTypeDropDown_AddEventTypes(pFrame, pEventGroupName, pMenuLevel)
	local	vEventTypes = gGroupCalendar_EventTypes[pEventGroupName];
	
	for vIndex, vEventItem in pairs(vEventTypes.Events) do
		local	vItem = UIDropDownMenu_CreateInfo();

		vItem.text = vEventItem.name;
		vItem.value = vEventItem.id;
		vItem.owner = pFrame;
		vItem.func = CalendarDropDown_OnClick;

		UIDropDownMenu_AddButton(vItem, pMenuLevel);
	end
end

function CalendarEventTypeDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		CalendarEventTypeDropDown_AddEventTypes(vFrame, UIDROPDOWNMENU_MENU_VALUE, UIDROPDOWNMENU_MENU_LEVEL);
	else
		-- Populate the root menu items
		
		CalendarEventTypeDropDown_AddEventTypes(vFrame, "General");
		Calendar_AddDividerMenuItem(vFrame);
		CalendarEventTypeDropDown_AddEventGroupSubMenu(vFrame, "Raid");
		CalendarEventTypeDropDown_AddEventGroupSubMenu(vFrame, "Dungeon");
		CalendarEventTypeDropDown_AddEventGroupSubMenu(vFrame, "Battleground");
	end
end

function CalendarGuildRankDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	if IsInGuild() then
		local	vNumRanks = GuildControlGetNumRanks();
	
		for vIndex = 1, vNumRanks do
			local	vRankName = GuildControlGetRankName(vIndex);
			local	vItem = UIDropDownMenu_CreateInfo();

			vItem.text = vRankName;
			vItem.value = vIndex - 1;
			vItem.owner = vFrame;
			vItem.func = CalendarDropDown_OnClick;

			UIDropDownMenu_AddButton(vItem);
		end
	end
end

function CalendarTrustGroupDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	for vIndex, vText in pairs(GroupCalendar_cTrustGroups) do
		if vIndex ~= 2
		or IsInGuild() then
			local	vItem = UIDropDownMenu_CreateInfo();
			
			vItem.text = vText;
			vItem.value = vIndex;
			vItem.owner = vFrame;
			vItem.func = CalendarDropDown_OnClick;

			UIDropDownMenu_AddButton(vItem);
		end
	end
end

function CalendarPartySizeDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local	vSizes = {0, 5, 10, 15, 20, 40};
	
	for vIndex, vSize in pairs(vSizes) do
		local	vText = vSize;
		
		if vText == 0 then
			vText = GroupCalendar_cNoMaximum;
		else
			vText = format(GroupCalendar_cPartySizeFormat, vSize);
		end
		
		UIDropDownMenu_AddButton({text = vText, value = vSize, owner = vFrame, func = CalendarDropDown_OnClick});
	end
end

function CalendarPriorityDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	Calendar_AddMenuItem(vFrame, GroupCalendar_cPriorityDate, "Date")
	Calendar_AddMenuItem(vFrame, GroupCalendar_cPriorityRank, "Rank")
	Calendar_AddMenuItem(vFrame, GroupCalendar_cPriorityClass, "Class")
end

function CalendarCharactersDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local	vOwnedDatabases = EventDatabase_GetPlayerDatabases();
	
	for vIndex, vDatabase in pairs(vOwnedDatabases) do
		local	vItem = UIDropDownMenu_CreateInfo();

		vItem.text = vDatabase.UserName;
		vItem.value = vDatabase.UserName;
		vItem.owner = vFrame;
		vItem.func = CalendarDropDown_OnClick;

		UIDropDownMenu_AddButton(vItem);
	end
end

function CalendarRolesDropDown_Initialize(vFrame, level, menuList)
	local	vItem_Tank = UIDropDownMenu_CreateInfo();
	vItem_Tank.text = GroupCalendar_cTankLabel;
	vItem_Tank.value = GroupCalendar_cTankLabel;
	vItem_Tank.owner = vFrame;
	vItem_Tank.func = CalendarDropDown_OnClick;
	UIDropDownMenu_AddButton(vItem_Tank);

	local	vItem_Healer = UIDropDownMenu_CreateInfo();
	vItem_Healer.text = GroupCalendar_cHealerLabel;
	vItem_Healer.value = GroupCalendar_cHealerLabel;
	vItem_Healer.owner = vFrame;
	vItem_Healer.func = CalendarDropDown_OnClick;
	UIDropDownMenu_AddButton(vItem_Healer);

	local	vItem_DPS = UIDropDownMenu_CreateInfo();
	vItem_DPS.text = GroupCalendar_cDpsLabel;
	vItem_DPS.value = GroupCalendar_cDpsLabel;
	vItem_DPS.owner = vFrame;
	vItem_DPS.func = CalendarDropDown_OnClick;
	UIDropDownMenu_AddButton(vItem_DPS);

	local	vItem_Unknown = UIDropDownMenu_CreateInfo();
	vItem_Unknown.text = GroupCalendar_cUnknownRoleLabel;
	vItem_Unknown.value = GroupCalendar_cUnknownRoleLabel;
	vItem_Unknown.owner = vFrame;
	vItem_Unknown.func = CalendarDropDown_OnClick;
	UIDropDownMenu_AddButton(vItem_Unknown);

end

function CalendarAttendanceDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local	vAttendanceItem = vFrame:GetParent();
	local	vItem = vAttendanceItem.Item;
	
	if vItem then
		if vItem.mType == "Whisper" then
			Calendar_AddCategoryMenuItem(vFrame, vItem.mName);
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cAddPlayerEllipses, "ADD");
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cRemove, "DELETE");
		else
			Calendar_AddCategoryMenuItem(vFrame, vItem.mName);
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cEditPlayer, "EDIT");
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cRemove, "DELETE");
			Calendar_AddCategoryMenuItem(vFrame, GroupCalendar_cStatus);
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cConfirmed, "Y");
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cStandby, "S");
			Calendar_AddMenuItem2(vFrame, GroupCalendar_cDeclined, "N");
		end
	end
	
	vFrame:SetHeight(20);
end

function CalendarClassDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	local	vItem = UIDropDownMenu_CreateInfo();

	vItem.text = GroupCalendar_cUnknown;
	vItem.value = "?";
	vItem.owner = vFrame;
	vItem.func = CalendarDropDown_OnClick;

	UIDropDownMenu_AddButton(vItem);
	
	for vClassCode, vClassInfo in pairs(gGroupCalendar_ClassInfoByClassCode) do
		if not vClassInfo.faction
		or vClassInfo.faction == gGroupCalendar_PlayerFactionGroup then
			local	vItem = UIDropDownMenu_CreateInfo();

			vItem.text = vClassInfo.name;
			vItem.value = vClassCode;
			vItem.owner = vFrame;
			vItem.func = CalendarDropDown_OnClick;

			UIDropDownMenu_AddButton(vItem);
		end
	end
end

function CalendarRaceDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	local	vItem = UIDropDownMenu_CreateInfo();

	vItem.text = GroupCalendar_cUnknown;
	vItem.value = "?";
	vItem.owner = vFrame;
	vItem.func = CalendarDropDown_OnClick;

	UIDropDownMenu_AddButton(vItem);
	
	for vRaceCode, vRaceInfo in pairs(gGroupCalendar_RaceNamesByRaceCode) do
		if vRaceInfo.faction == gGroupCalendar_PlayerFactionGroup then
			local	vItem = UIDropDownMenu_CreateInfo();

			vItem.text = vRaceInfo.name;
			vItem.value = vRaceCode;
			vItem.owner = vFrame;
			vItem.func = CalendarDropDown_OnClick;

			UIDropDownMenu_AddButton(vItem);
		end
	end
end

function CalendarStatusDropDown_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	vItem = {text = GroupCalendar_cConfirmed, value = "Y", owner = vFrame, func = CalendarDropDown_OnClick};
	UIDropDownMenu_AddButton(vItem);
	
	vItem = {text = GroupCalendar_cStandby, value = "S", owner = vFrame, func = CalendarDropDown_OnClick};
	UIDropDownMenu_AddButton(vItem);

	vItem = {text = GroupCalendar_cDeclined, value = "N", owner = vFrame, func = CalendarDropDown_OnClick};
	UIDropDownMenu_AddButton(vItem);
end

function GroupCalendarViewMenu_Initialize(vFrame, level, menuList)
	--local	vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	
	UIDropDownMenu_AddButton({text = GroupCalendar_cViewByDate, value = "Date", owner = vFrame, func = CalendarDropDown_OnClick});
	UIDropDownMenu_AddButton({text = GroupCalendar_cViewByRank, value = "Rank", owner = vFrame, func = CalendarDropDown_OnClick});
	UIDropDownMenu_AddButton({text = GroupCalendar_cViewByName, value = "Name", owner = vFrame, func = CalendarDropDown_OnClick});
	UIDropDownMenu_AddButton({text = GroupCalendar_cViewByClass, value = "Class", owner = vFrame, func = CalendarDropDown_OnClick});
end

function CalendarDropDown_OnClick(data)	
	UIDropDownMenu_SetSelectedValue(data.owner, data.value);
	CalendarDropDown_OnClick2(data);
end

function CalendarDropDown_OnClick2(data)
	if data.owner.ChangedValueFunc then
		data.owner.ChangedValueFunc(data.owner, data.value);
	end
	
	CloseDropDownMenus();
end

function Calendar_SetEditBoxAutoCompleteText(pEditBox, pText)
	local	vEditBoxText = strupper(pEditBox:GetText());
	local	vEditBoxTextLength = strlen(vEditBoxText);
	
	pEditBox:SetText(pText);
	pEditBox:HighlightText(vEditBoxTextLength, -1);
end

function Calendar_AutoCompletePlayerName(pEditBox)
	if Calendar_AutoCompleteFriend(pEditBox) then
		return true;
	end
	
	return Calendar_AutoCompleteGuildMember(pEditBox);
end

function Calendar_AutoCompleteFriend(pEditBox)
	local	vNumFriends = C_FriendList.GetNumFriends();
	
	if vNumFriends == 0 then
		return false;
	end
	
	local	vEditBoxText = strupper(pEditBox:GetText());
	local	vEditBoxTextLength = strlen(vEditBoxText);
	
	for vIndex = 1, vNumFriends do
		local  f = C_FriendList.GetFriendInfoByIndex(vIndex);
		local	vName = f.name;
		
		if strfind(strupper(vName), "^"..vEditBoxText) then
			Calendar_SetEditBoxAutoCompleteText(pEditBox, vName);
			return true;
		end
	end
	
	return false;
end

function Calendar_AutoCompleteGuildMember(pEditBox)
	if IsInGuild() then
		local	vNumMembers = GetNumGuildMembers(true);
	
		if vNumMembers == 0 then
			return false;
		end
	
		local	vEditBoxText = strupper(pEditBox:GetText());
		local	vEditBoxTextLength = strlen(vEditBoxText);
	
		for vIndex = 1, vNumMembers do
			local	vName = GetGuildRosterInfo(vIndex);
			vName = GroupCalendar_RemoveRealmName(vName);
			if strfind(strupper(vName), "^"..vEditBoxText) then
				Calendar_SetEditBoxAutoCompleteText(pEditBox, vName);
				return true;
			end
		end
	end
	
	return false;
end

function Calendar_InputFrameSizeChanged(pInputFrame)
	local	vName = pInputFrame:GetName();
	local	vWidth = pInputFrame:GetWidth();
	local	vHeight = pInputFrame:GetHeight();
	
	local	vTopLeft = getglobal(vName.."TopLeft");
	local	vTop = getglobal(vName.."Top");
	local	vTopRight = getglobal(vName.."TopRight");

	local	vLeft = getglobal(vName.."Left");
	local	vCenter = getglobal(vName.."Center");
	local	vRight = getglobal(vName.."Right");

	local	vBottomLeft = getglobal(vName.."BottomLeft");
	local	vBottom = getglobal(vName.."Bottom");
	local	vBottomRight = getglobal(vName.."BottomRight");
	
	local	vInnerWidth = vWidth - 12;
	local	vInnerHeight = vHeight - 12;
	
	vTopLeft:SetWidth(6); vTopLeft:SetHeight(6);
	vTop:SetWidth(vInnerWidth); vTop:SetHeight(6);
	vTopRight:SetWidth(6); vTopRight:SetHeight(6);
	
	vLeft:SetWidth(6); vLeft:SetHeight(vInnerHeight);
	vCenter:SetWidth(vInnerWidth); vCenter:SetHeight(vInnerHeight);
	vRight:SetWidth(6); vRight:SetHeight(vInnerHeight);
		
	vBottomLeft:SetWidth(6); vBottomLeft:SetHeight(6);
	vBottom:SetWidth(vInnerWidth); vBottom:SetHeight(6);
	vBottomRight:SetWidth(6); vBottomRight:SetHeight(6);
end

function CalendarPlayerList_OnLoad()
	self.ItemFunction = CalendarPlayerList_NullItemFunction;
	self.SelectedIndex = 0;
end

function CalendarPlayerList_OnShow(frame)
	CalendarPlayerList_Update(frame);
end

function CalendarPlayerList_SetItemFunction(pPlayerListControl, pItemFunction)
	pPlayerListControl.ItemFunction = pItemFunction;
end

function CalendarPlayerList_SetSelectionChangedFunction(pPlayerListControl, pSelectionChangedFunction)
	pPlayerListControl.SelectionChangedFunction = pSelectionChangedFunction;
end

function CalendarPlayerList_SetColor(pPlayerListControl, pRed, pGreen, pBlue)
	local	vControlName = pPlayerListControl:GetName();
	local	vHighlightFrameTextureName = vControlName.."HighlightFrameTexture";
	local	vHighlightFrameTexture = getglobal(vHighlightFrameTextureName);
	
	pPlayerListControl.r = pRed; pPlayerListControl.g = pGreen; pPlayerListControl.b = pBlue;
	
	for vIndex = 0, 4 do
		CalendarPlayerList_SetIndexedItemFrameColor(pPlayerListControl, vIndex, pRed, pGreen, pBlue);
	end
	
	vHighlightFrameTexture:SetVertexColor(pRed, pGreen, pBlue);
end

function CalendarPlayerList_SetIndexedItemFrameColor(pPlayerListControl, pIndex, pRed, pGreen, pBlue)
	local	vControlName = pPlayerListControl:GetName();
	local	vItemFrameName = vControlName.."Item"..pIndex;
	local	vItemFrame = getglobal(vItemFrameName);
	local	vTextItem = getglobal(vItemFrameName.."Text");
	
	vItemFrame.r = pRed;
	vItemFrame.g = pGreen;
	vItemFrame.b = pBlue;
	
	vTextItem:SetTextColor(pRed, pGreen, pBlue);
end

gCalendarPlayerList_ActiveList = nil;

function CalendarPlayerList_ScrollUpdate()
	CalendarPlayerList_Update(gCalendarPlayerList_ActiveList);
end

function CalendarPlayerList_Update(pPlayerListControl)
	local	vControlName = pPlayerListControl:GetName();
	local	vScrollFrame = getglobal(vControlName.."ScrollFrame");
	local	vHighlightFrame = getglobal(vControlName.."HighlightFrame");
	
	local	vNumItems = pPlayerListControl.ItemFunction(0);
	
	for vIndex = 0, 4 do
		local	vItemName = vControlName.."Item"..vIndex;
		local	vItemFrame = getglobal(vItemName);
		
		if vIndex < vNumItems then
			vItemFrame:Show();
		else
			vItemFrame:Hide();
		end
	end

	FauxScrollFrame_Update(
			vScrollFrame,
			vNumItems,
			gCalendarPlayerList_cNumVisibleEntries,
			gCalendarPlayerList_cItemHeight,
			nil,
			nil,
			nil,
			vHighlightFrame,
			130,
			130);
	
	CalendarPlayerList_UpdateItems(pPlayerListControl);
end

function CalendarPlayerList_UpdateItems(pPlayerListControl)
	local	vControlName = pPlayerListControl:GetName();
	local	vScrollFrame = getglobal(vControlName.."ScrollFrame");
	local	vFirstItemOffset = FauxScrollFrame_GetOffset(vScrollFrame);
	
	for vIndex = 0, 4 do
		local	vItem = pPlayerListControl.ItemFunction(vIndex + vFirstItemOffset + 1);
		local	vItemName = vControlName.."Item"..vIndex;
		local	vTextItem = getglobal(vItemName.."Text");
		
		vTextItem:SetText(vItem.Text);
	end
end

function CalendarPlayerList_NullItemFunction(pIndex)
	if pIndex == 0 then
		return 10;
	end
	
	return
	{
		Text = "Null item "..pIndex,
	};
end

function CalendarPlayerListItem_OnClick(self)
	local	vPlayerListControl = self:GetParent();
	
	local	vControlName = vPlayerListControl:GetName();
	local	vScrollFrame = getglobal(vControlName.."ScrollFrame");
	local	vFirstItemOffset = FauxScrollFrame_GetOffset(vScrollFrame);
	
	local	vPlayerIndex = self:GetID() + vFirstItemOffset + 1;
	
	CalendarPlayerList_SelectIndexedPlayer(vPlayerListControl, vPlayerIndex);
end

function CalendarPlayerList_SelectIndexedPlayer(pPlayerListControl, pIndex)
	local	vControlName = pPlayerListControl:GetName();
	local	vScrollFrame = getglobal(vControlName.."ScrollFrame");
	local	vHighlightFrame = getglobal(vControlName.."HighlightFrame");
	
	-- Remove the old highlighting
	
	if pPlayerListControl.SelectedIndex then
		local	vItemFrameIndex = pPlayerListControl.SelectedIndex - FauxScrollFrame_GetOffset(vScrollFrame) - 1;
		
		CalendarPlayerList_SetIndexedItemFrameColor(pPlayerListControl, vItemFrameIndex, pPlayerListControl.r, pPlayerListControl.g, pPlayerListControl.b);
	end
	
	-- Show the new highlighting
	
	if pIndex > 0 then
		local	vItemFrameIndex = pIndex - FauxScrollFrame_GetOffset(vScrollFrame) - 1;
		local	vItemFrameName = vControlName.."Item"..vItemFrameIndex;
		
		vHighlightFrame:SetPoint("TOPLEFT", vItemFrameName, "TOPLEFT", 5, 0);
	
		vHighlightFrame:Show();
		
		CalendarPlayerList_SetIndexedItemFrameColor(pPlayerListControl, vItemFrameIndex, 1.0, 1.0, 1.0);
		pPlayerListControl.SelectedIndex = pIndex;
	else
		vHighlightFrame:Hide();
		pPlayerListControl.SelectedIndex = nil;
	end
	
	if pPlayerListControl.SelectionChangedFunction then
		pPlayerListControl.SelectionChangedFunction(pIndex);
	end
end

function Calendar_GetChangedFieldList(pOldTable, pNewTable)
	local	vChangedFields = {};
	
	for vIndex, vNewValue in pairs(pNewTable) do
		local	vOldValue = pOldTable[vIndex];
		
		if vOldValue == nil then -- New field
			vChangedFields[vIndex] = "NEW";
		elseif vOldValue ~= vNewValue then -- Changed field
			vChangedFields[vIndex] = "UPD";
		end
	end

	for vIndex, vOldValue in pairs(pOldTable) do
		local	vNewValue = pNewTable[vIndex];
		
		if vNewValue == nil then -- Deleted field
			vChangedFields[vIndex] = "DEL";
		end
	end
	
	return vChangedFields;
end

function Calendar_DumpArray(pPrefixString, pArray)
	if not pArray then
		Calendar_DebugMessage(pPrefixString.." is nil");
		return;
	end
	
	local	vFoundElement = false;
	
	for vIndex, vElement in pairs(pArray) do
		vFoundElement = true;
		
		local	vType = type(vElement);
		local	vPrefix;
		
		if type(vIndex) == "number" then
			vPrefix = pPrefixString.."["..vIndex.."]";
		else
			vPrefix = pPrefixString.."."..vIndex;
		end
		
		if vType == "number" then
			Calendar_DebugMessage(vPrefix.." = "..vElement);
		elseif vType == "string" then
			Calendar_DebugMessage(vPrefix.." = \""..vElement.."\"");
		elseif vType == "boolean" then
			if vElement then
				Calendar_DebugMessage(vPrefix.." = true");
			else
				Calendar_DebugMessage(vPrefix.." = false");
			end
		elseif vType == "table" then
			Calendar_DumpArray(vPrefix, vElement);
		else
			Calendar_DebugMessage(vPrefix.." "..vType);
		end
	end
	
	if not vFoundElement then
		Calendar_DebugMessage(pPrefixString.." is empty");
	end
end

-- NOTE: If any of LUA's "magic" characters ever need to be escaped they will
--       need to be coded properly with a % preceeding them in the cSpecialChars
--       string.  Currently the "magic" characters are: ^$()%.[]*+-?

gGroupCalendar_cSpecialChars = ",/:;&|\n";

gGroupCalendar_cSpecialCharMap =
{
	c = ",",
	s = "/",
	cn = ":",
	sc = ";",
	a = "&",
	b = "|",
	n = "\n",
};

function Calendar_EscapeString(pString)
	return string.gsub(
					pString,
					"(["..gGroupCalendar_cSpecialChars.."])",
					function (pField)
						for vName, vChar in pairs(gGroupCalendar_cSpecialCharMap) do
							if vChar == pField then
								return "&"..vName..";";
							end
						end
						
						return "";
					end);
end

function Calendar_UnescapeString(pString)
	return string.gsub(
					pString,
					"&(%w+);", 
					function (pField)
						local	vChar = gGroupCalendar_cSpecialCharMap[pField];
						
						if vChar ~= nil then
							return vChar;
						else
							return pField;
						end
					end);
end

function Calendar_GetLocalTimeFromServerTime(pServerTime)
	if not pServerTime then
		return nil;
	end
	
	local	vLocalTime = pServerTime + gGroupCalendar_ServerTimeZoneOffset;

	if vLocalTime < 0 then
		vLocalTime = vLocalTime + gCalendarMinutesPerDay;
	elseif vLocalTime >= gCalendarMinutesPerDay then
		vLocalTime = vLocalTime - gCalendarMinutesPerDay;
	end
	
	return vLocalTime;
end

function Calendar_GetServerTimeFromLocalTime(pLocalTime)
	local	vServerTime = pLocalTime - gGroupCalendar_ServerTimeZoneOffset;

	if vServerTime < 0 then
		vServerTime = vServerTime + gCalendarMinutesPerDay;
	elseif vServerTime >= gCalendarMinutesPerDay then
		vServerTime = vServerTime - gCalendarMinutesPerDay;
	end
	
	return vServerTime;
end

function Calendar_GetLocalDateTimeFromServerDateTime(pServerDate, pServerTime)
	if not pServerTime then
		return pServerDate, nil;
	end
	
	local	vLocalTime = pServerTime + gGroupCalendar_ServerTimeZoneOffset;
	local	vLocalDate = pServerDate;
	
	if vLocalTime < 0 then
		vLocalTime = vLocalTime + gCalendarMinutesPerDay;
		vLocalDate = Calendar_AddDays(vLocalDate, -1);
	elseif vLocalTime >= gCalendarMinutesPerDay then
		vLocalTime = vLocalTime - gCalendarMinutesPerDay;
		vLocalDate = Calendar_AddDays(vLocalDate, 1);
	end
	
	return vLocalDate, vLocalTime;
end

function Calendar_GetServerDateTimeFromLocalDateTime(pLocalDate, pLocalTime)
	if not pLocalTime then
		return pLocalDate, nil;
	end
	
	local	vServerTime = pLocalTime - gGroupCalendar_ServerTimeZoneOffset;
	local	vServerDate = pLocalDate;
	
	if vServerTime < 0 then
		vServerTime = vServerTime + gCalendarMinutesPerDay;
		vServerDate = Calendar_AddDays(vServerDate, -1);
	elseif vServerTime >= gCalendarMinutesPerDay then
		vServerTime = vServerTime - gCalendarMinutesPerDay;
		vServerDate = Calendar_AddDays(vServerDate, 1);
	end
	
	return vServerDate, vServerTime;
end

function Calendar_AddOffsetToDateTime(pDate, pTime, pOffset)
	local	vNewTime = pTime + pOffset;
	local vNewDate = Calendar_AddDays(pDate, math.floor(vNewTime / gCalendarMinutesPerDay));
	vNewTime = math.fmod(vNewTime, gCalendarMinutesPerDay);

	return vNewDate, vNewTime;
end

function Calendar_AddOffsetToDateTime60(pDate, pTime60, pOffset60)
	local vNewSeconds = pTime60 + pOffset60;
	local vNewDate = Calendar_AddDays(pDate, math.floor(vNewSeconds / gCalendarSecondsPerDay));
	vNewSeconds = math.fmod(vNewSeconds, gCalendarSecondsPerDay);

	return vNewDate, vNewSeconds;
end

function Calendar_GetServerDateTimeFromSecondsOffset(pSeconds)
	-- Calculate the local date and time of the reset (this is done in
	-- local date/time since it has a higher resolution)

	local	vLocalDate, vLocalTime60 = Calendar_GetCurrentLocalDateTime60();
	
	vLocalDate, vLocalTime60 = Calendar_AddOffsetToDateTime60(vLocalDate, vLocalTime60, pSeconds);
	
	local	vLocalTime = math.floor(vLocalTime60 / 60);

	-- Convert to server date/time

	return Calendar_GetServerDateTimeFromLocalDateTime(vLocalDate, vLocalTime);
end

function Calendar_ArrayIsEmpty(pArray)
	if not pArray then
		return true;
	end
	
	for vIndex, vValue in pairs(pArray) do
		return false;
	end
	
	return true;
end




function Calendar_LookupTradeskillIDByName(pName)
	for vTradeskillID, vTradeskillInfo in pairs(gGroupCalendar_PrimaryTradeskills) do		
		if vTradeskillInfo.name == pName then
			return vTradeskillID;
		end
	end
	
	return nil;
end

function Calendar_GetPrimaryTradeskills()
	local	vNumSkillLines = GetNumSkillLines();
	local	vFoundSkillHeader = false;
	local	vTradeskillIDs = {};
	
	for vSkillLineIndex = 1, vNumSkillLines do
		local	vSkillName, vHeader, vIsExpanded, vSkillRank, vNumTempPoints, vSkillModifier,
				vSkillMaxRank, vIsAbandonable, vStepCost, vRankCost, vMinLevel, vSkillCostType,
				vSkillDescription = GetSkillLineInfo(vSkillLineIndex);
		
		if vHeader then
			if vFoundSkillHeader then
				return vTradeskillIDs;
			end
			
			if vSkillName == TRADE_SKILLS then
				vFoundSkillHeader = true;
			end
		elseif vFoundSkillHeader then
			local	vTradeskillID = Calendar_LookupTradeskillIDByName(vSkillName);
			
			if vTradeskillID then
				table.insert(vTradeskillIDs, vTradeskillID);
			else
				Calendar_DebugMessage("GroupCalendar: Unknown primary profession: "..vSkillName);
			end
		end
	end
	
	return vTradeskillIDs;
end

function Calendar_IsCooldownItem(pCooldownItems, pItemName)
	for vIndex, vItemName in pairs(pCooldownItems) do
		if vItemName == pItemName then
			return true;
		end
	end
	
	return false;
end

function Calendar_GetTradeskillCooldown(pTradeskillID)
	local	vNumSkills = GetNumTradeSkills();
	local	vCooldownItems = gGroupCalendar_PrimaryTradeskills[pTradeskillID].cooldownItems;
	
	if not vCooldownItems then
		return nil;
	end
	
	for vSkillIndex = 1, vNumSkills do
		local	vSkillName, vSkillType, vNumAvailable, vIsExpanded = GetTradeSkillInfo(vSkillIndex);
		
		if Calendar_IsCooldownItem(vCooldownItems, vSkillName) then
			local	vCooldown = GetTradeSkillCooldown(vSkillIndex);
			
			return vCooldown;
		end
	end
	
	return nil;
end

function CalendarInputBox_OnLoad(frame, pChildDepth)
	if not pChildDepth then
		pChildDepth = 0;
	end
	
	local	vParent = frame:GetParent();
	
	for vDepthIndex = 1, pChildDepth do
		vParent = vParent:GetParent();
	end
	
	if vParent.lastEditBox then
		frame.prevEditBox = vParent.lastEditBox;
		frame.nextEditBox = vParent.lastEditBox.nextEditBox;
		
		frame.prevEditBox.nextEditBox = frame;
		frame.nextEditBox.prevEditBox = frame;
	else
		frame.prevEditBox = frame;
		frame.nextEditBox = frame;
	end

	vParent.lastEditBox = frame;
end

function CalendarInputBox_TabPressed(self)
	local		vReverse = IsShiftKeyDown();
	local		vEditBox = self;
	
	for vIndex = 1, 50 do
		local	vNextEditBox;
			
		if vReverse then
			vNextEditBox = vEditBox.prevEditBox;
		else
			vNextEditBox = vEditBox.nextEditBox;
		end
		
		if vNextEditBox:IsVisible()
		and not vNextEditBox.isDisabled then
			vNextEditBox:SetFocus();
			return;
		end
		
		vEditBox = vNextEditBox;
	end
end

function GroupCalendarSidePanel_Show(pDesc)
	-- Hide an existing panel
	
	GroupCalendarSidePanel_Hide();
	
	-- Show the new state
	
	GroupCalendarSidePanel.Desc = pDesc;
	
	GroupCalendarSidePanelTitle:SetText(GroupCalendarSidePanel.Desc.Title);
	GroupCalendarSidePanelButton:SetText(GroupCalendarSidePanel.Desc.ButtonTitle);
	
	GroupCalendarSidePanel:Show();
end

function GroupCalendarSidePanel_Hide()
	GroupCalendarSidePanel:Hide();
	
	GroupCalendarSidePanel.Desc = nil;
end

function GroupCalendarSidePanel_OnHide()
	if GroupCalendarSidePanel.Desc.CloseFunc then
		GroupCalendarSidePanel.Desc.CloseFunc();
	end
end

function GroupCalendarSideList_Show(pDesc)
	GroupCalendarSidePanel_Show(pDesc);
	GroupCalendarSideList:Show();
	
	GroupCalendarSideList.Desc = pDesc;
	
	GroupCalendarSideList.Desc.ListItems:Show();
	GroupCalendarSideList.Desc.ListItems:UpdateItems();
end

function GroupCalendarSideList_Hide()
	GroupCalendarSideList:Hide();
	
	if GroupCalendarSideList.Desc then
		GroupCalendarSideList.Desc.ListItems:Hide();
		GroupCalendarSideList.Desc = nil;
	end
	
	GroupCalendarSidePanel_Hide();
end

function GroupCalendarSideList_OnVerticalScroll()
	GroupCalendarSideList.Desc.ListItems:UpdateItems();
end

function GroupCalendarSideList_GetFirstItem()
	return FauxScrollFrame_GetOffset(GroupCalendarSideListScrollFrame) + 1;
end

function GroupCalendarSideList_SetNumItems(pNumItems)
	FauxScrollFrame_Update(
			GroupCalendarSideListScrollFrame,
			pNumItems,
			gGroupCalendar_cNumPlainAttendanceItems,
			gGroupCalendar_cAttendanceItemHeight,
			nil,
			nil,
			nil,
			nil,
			293, 316);
	
	-- Update visible items
	
	local	vListName = GroupCalendarSideList.Desc.ListItems:GetName();
	local	vLastItemIndex = pNumItems - 1;
	
	if vLastItemIndex >= gGroupCalendar_cNumPlainAttendanceItems then
		vLastItemIndex = gGroupCalendar_cNumPlainAttendanceItems - 1;
	end
	
	local	vFirstItemIndex = GroupCalendarSideList_GetFirstItem();
	
	for vItemIndex = 0, vLastItemIndex do
		local	vItemName = vListName.."Item"..vItemIndex;
		local	vItem = getglobal(vItemName);
		
		GroupCalendarSideList.Desc.ListItems:UpdateItem(vItemIndex + vFirstItemIndex, vItem, vItemName, vItemIndex);
		vItem:Show();
	end
	
	-- Hide unused items
	
	if pNumItems < gGroupCalendar_cNumPlainAttendanceItems then
		for vIndex = pNumItems, gGroupCalendar_cNumPlainAttendanceItems - 1 do
			local	vItemName = vListName.."Item"..vIndex;
			
			getglobal(vItemName):Hide();
		end
	end
end

local	gCalendarDisplay_FlashingRemder =
{
	Enabled = false,
	OnDuration = 0.4,
	OffDuration = 0.2,
	FadeDuration = 0.5,
	FlashDuration = 60 * 60,
};

function CalendarDisplay_StartFlashingReminder(pIcon)
	if pIcon then
		GroupCalendarNotifyIconLeft:SetTexture(pIcon);
		GroupCalendarNotifyIconMiddle:SetTexture(pIcon);
		GroupCalendarNotifyIconRight:SetTexture(pIcon);
	end
	
	gCalendarDisplay_FlashingRemder.Enabled = true;
	
	GroupCalendarNotifyIconHighlight:Show();
	
	UIFrameFlash(
			GroupCalendarNotifyIconHighlight,
			gCalendarDisplay_FlashingRemder.FadeDuration,
			gCalendarDisplay_FlashingRemder.FadeDuration,
			gCalendarDisplay_FlashingRemder.FlashDuration,
			false,
			gCalendarDisplay_FlashingRemder.OffDuration,
			gCalendarDisplay_FlashingRemder.OnDuration);
end

function CalendarDisplay_StopFlashingReminder()
	UIFrameFlashRemoveFrame(GroupCalendarNotifyIconHighlight);
	GroupCalendarNotifyIconHighlight:Hide();
	gCalendarDisplay_FlashingRemder.Enabled = false;
end
