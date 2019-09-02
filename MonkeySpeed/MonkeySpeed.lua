if (LibStub ~= nil) then
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if(ldb ~= nil) then
		MonkeySpeedLDB = ldb:NewDataObject("Broker_MonkeySpeed", {
			type	= "data source",
			icon    = "Interface\\Icons\\Ability_Rogue_Sprint.blp",
			label	= "MonkeySpeed",
			text	= MONKEYSPEED_showLDB_inactive
		})
		local Broker_MonkeySpeedFrame = CreateFrame("frame")

		Broker_MonkeySpeedFrame:SetScript("OnUpdate", function(self, elapsed)
			if(MonkeySpeedVars.showLDB == true) then
                if(MonkeySpeedFrame:IsVisible() == false) then
                    MonkeySpeed_OnUpdate(self, elapsed)
                end
			else
				MonkeySpeedLDB.text = MONKEYSPEED_showLDB_inactive
			end
		end)

		function MonkeySpeedLDB:OnClick(button)
			if (button == "LeftButton") then
				if (IsShiftKeyDown()) then
					if (MonkeySpeedVars.frameLocked == true) then
						MonkeySpeedVars.frameLocked = false
					else
						MonkeySpeedVars.frameLocked = true
					end
					MonkeySpeed_frameLocked_Changed()
				else
					if (MonkeySpeedVars.shown == false) then
						MonkeySpeedVars.shown = true
					elseif (MonkeySpeedVars.shown == true) then
						MonkeySpeedVars.shown = false
					end
					MonkeySpeed_shown_Changed()
				end
				MonkeySpeed_RefreshConfig()
			elseif (button == "RightButton") then
				InterfaceOptionsFrame_OpenToCategory("MonkeySpeed")
			end
		end

		function MonkeySpeedLDB:OnTooltipShow()
			self:AddLine("MonkeySpeed")
			self:AddLine(MONKEYSPEED_leftClickToggles_DESC)
			self:AddLine(MONKEYSPEED_shiftLeftClickLocks_DESC)
			self:AddLine(MONKEYSPEED_rightClickOpensConfig_DESC)
		end

		function MonkeySpeedLDB:OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			GameTooltip:ClearLines()
			MonkeySpeedLDB.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end
end
-- OnLoad Function
function MonkeySpeed_OnLoad(self)
	-- register events
	self:RegisterEvent("VARIABLES_LOADED")
    if (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE) then
        self:RegisterEvent("UNIT_ENTERED_VEHICLE")
        self:RegisterEvent("UNIT_EXITED_VEHICLE")
    end
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

-- OnEvent Function
function MonkeySpeed_OnEvent(self, event, ...)
	local arg1 = ...
	if (event == "VARIABLES_LOADED") then
		MonkeySpeed_Init()
		return
	end
	if (event == "UNIT_ENTERED_VEHICLE") then
		if arg1 == "player" then
			MonkeySpeedTemp.currentUnit = "vehicle"
		end
	end
	if (event == "UNIT_EXITED_VEHICLE") then
		if arg1 == "player" then
			MonkeySpeedTemp.currentUnit = "player"
		end
	end
    if (event == "ZONE_CHANGED_NEW_AREA") then
        MonkeySpeed.calibrate = true
	end
end

-- OnUpdate Function
function MonkeySpeed_OnUpdate(self, elapsed)
	-- how long since the last update?
	MonkeySpeedTemp.deltaTime = MonkeySpeedTemp.deltaTime + elapsed
    
    -- update the speed calculation
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then
		local mapPos = C_Map.GetPlayerMapPosition(mapID, "player")
	
		if mapPos then
			MonkeySpeed.m_vCurrPos.x, MonkeySpeed.m_vCurrPos.y = mapPos:GetXY()
		else
			MonkeySpeed.m_vCurrPos.x = 0
			MonkeySpeed.m_vCurrPos.y = 0
		end
	else
		MonkeySpeed.m_vCurrPos.x = 0
		MonkeySpeed.m_vCurrPos.y = 0
	end

	MonkeySpeed.m_vCurrPos.x = MonkeySpeed.m_vCurrPos.x + 0.0;
	MonkeySpeed.m_vCurrPos.y = MonkeySpeed.m_vCurrPos.y + 0.0;
    
    local dist = math.sqrt(
        ((MonkeySpeed.m_vLastPos.x - MonkeySpeed.m_vCurrPos.x) * (MonkeySpeed.m_vLastPos.x - MonkeySpeed.m_vCurrPos.x) * 2.25 ) +
        ((MonkeySpeed.m_vLastPos.y - MonkeySpeed.m_vCurrPos.y) * (MonkeySpeed.m_vLastPos.y - MonkeySpeed.m_vCurrPos.y)));
		
	MonkeySpeed.m_fSpeedDist = MonkeySpeed.m_fSpeedDist + dist;
    
	if (MonkeySpeedTemp.deltaTime >= .2) then
    
		local iSpeed, groundSpeed, flightSpeed, swimSpeed = GetUnitSpeed(MonkeySpeedTemp.currentUnit)
		if groundSpeed and groundSpeed > 0 then
			local maxSpeed
			if (IsSwimming()) then
				maxSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(swimSpeed/7 * 100)))
			elseif (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE) then
                if (IsFlying()) then
                    maxSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(flightSpeed/7 * 100)))
                else
                    maxSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(groundSpeed/7 * 100)))
                end
			else
				maxSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(groundSpeed/7 * 100)))
			end
            
            local isSwimmingOrFlying
            if (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE) then
                isSwimmingOrFlying = IsSwimming() or IsFlying()
            else
                isSwimmingOrFlying = IsSwimming()
            end
            
            if MonkeySpeed.calibrate == true and dist > 0.0 then
                MonkeySpeed.rate = (MonkeySpeed.m_fSpeedDist / MonkeySpeedTemp.deltaTime) / maxSpeed
                MonkeySpeed.calibrate = false
            end
            
            if MonkeySpeedVars.autoCalibration and isSwimmingOrFlying and dist > 0.0 then
                MonkeySpeedTemp.currentSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(((MonkeySpeed.m_fSpeedDist/MonkeySpeedTemp.deltaTime)/MonkeySpeed.rate))))
            else
                MonkeySpeedTemp.currentSpeed = tonumber(format("%." .. MonkeySpeedVars.precision .. "f", MonkeySpeed_Round(iSpeed/7 * 100)))
            end
            
            MonkeySpeedTemp.deltaTime = 0.0
            MonkeySpeed.m_fSpeedDist = 0.0
            
            if isSwimmingOrFlying and (MonkeySpeedTemp.currentSpeed > maxSpeed or MonkeySpeedTemp.currentSpeed < (maxSpeed / 50.0)) and dist > 0.0 then
                MonkeySpeed.m_vLastPos.x = MonkeySpeed.m_vCurrPos.x;
                MonkeySpeed.m_vLastPos.y = MonkeySpeed.m_vCurrPos.y;
                MonkeySpeed.m_vLastPos.z = MonkeySpeed.m_vCurrPos.z;
                MonkeySpeed.calibrate = true
                return
            end
            
			if (MonkeySpeedVars.showPercent == true) then
				-- Set the text for the speedometer
				if (MonkeySpeedTemp.currentSpeed == maxSpeed) or (MonkeySpeedVars.maximumSpeed == false) then
					MonkeySpeedText:SetText(MonkeySpeedTemp.currentSpeed .. "%")
				else
					MonkeySpeedText:SetText(MonkeySpeedTemp.currentSpeed .. "% / " .. maxSpeed .. "%")
				end
			end
			if (MonkeySpeedVars.showBar == true or MonkeySpeedVars.showLDB == true) then
				-- Set the colour of the bar
				local var = MonkeySpeedVars
				local formatString = "|cff%02x%02x%02x%s%%"
				if (MonkeySpeedTemp.currentSpeed == maxSpeed) or (MonkeySpeedVars.maximumSpeed == false) then
					MonkeySpeedTemp.currentColorSpeedLDB = MonkeySpeedTemp.currentSpeed
				else
					MonkeySpeedTemp.currentColorSpeedLDB = MonkeySpeedTemp.currentSpeed .. "% / " .. maxSpeed
				end
				if (MonkeySpeedTemp.currentSpeed == 0.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour1.r, var.speedColour1.g, var.speedColour1.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour1.r*255, var.speedColour1.g*255, var.speedColour1.b*255, MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed < 100.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour2.r, var.speedColour2.g, var.speedColour2.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour2.r*255,  var.speedColour2.g*255, var.speedColour2.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed == 100.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour3.r, var.speedColour3.g, var.speedColour3.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour3.r*255,  var.speedColour3.g*255, var.speedColour3.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed < 200.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour4.r, var.speedColour4.g, var.speedColour4.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour4.r*255,  var.speedColour4.g*255, var.speedColour4.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed == 200.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour5.r, var.speedColour5.g, var.speedColour5.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour5.r*255,  var.speedColour5.g*255, var.speedColour5.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed < 380.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour6.r, var.speedColour6.g, var.speedColour6.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour6.r*255,  var.speedColour6.g*255, var.speedColour6.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed == 380.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour7.r, var.speedColour7.g, var.speedColour7.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour7.r*255,  var.speedColour7.g*255, var.speedColour7.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed < 410.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour8.r, var.speedColour8.g, var.speedColour8.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour8.r*255,  var.speedColour8.g*255, var.speedColour8.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				elseif (MonkeySpeedTemp.currentSpeed == 410.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour9.r, var.speedColour9.g, var.speedColour9.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour9.r*255,  var.speedColour9.g*255, var.speedColour9.b*255,  MonkeySpeedTemp.currentColorSpeedLDB)
				else
					MonkeySpeedBar:SetVertexColor(var.speedColour10.r, var.speedColour10.g, var.speedColour10.b)
					MonkeySpeedTemp.currentColorSpeedLDB = format(formatString, var.speedColour10.r*255,  var.speedColour10.g*255, var.speedColour10.b*255, MonkeySpeedTemp.currentColorSpeedLDB)
				end
				if(MonkeySpeedLDB and MonkeySpeedVars.showLDB == true) then
					MonkeySpeedLDB.text = MonkeySpeedTemp.currentColorSpeedLDB
				end
			end
		else
			-- Vehicle exit event wasn't triggered
			MonkeySpeedTemp.currentUnit = "player"
		end
	end
    MonkeySpeed.m_vLastPos.x = MonkeySpeed.m_vCurrPos.x;
    MonkeySpeed.m_vLastPos.y = MonkeySpeed.m_vCurrPos.y;
    MonkeySpeed.m_vLastPos.z = MonkeySpeed.m_vCurrPos.z;
end

function MonkeySpeed_OnMouseDown(self, button)
	if (button == "LeftButton" and MonkeySpeedVars.frameLocked == false) then
		MonkeySpeedFrame:StartMoving()
		return
	end
	-- right button on the title or frame opens up the Blizzard Options
	if (button == "RightButton") then
		if (MonkeySpeedVars.rightClickOpensConfig == true) then
			InterfaceOptionsFrame_OpenToCategory("MonkeySpeed")
			InterfaceOptionsFrame_OpenToCategory("MonkeySpeed")
		end
	end
end

function MonkeySpeed_OnMouseUp(self, button)
	if (button == "LeftButton") then
		MonkeySpeedFrame:StopMovingOrSizing()
	end
    if (button == "MiddleButton") then
        MonkeySpeed.calibrate = true
	end
end

function MonkeySpeed_Round(x)
	local precision = (10^MonkeySpeedVars.precision)
	local y = x * precision
	if(y - floor(y) > 0.5) then
		y = y + 0.5
	end
	return y / precision
end

function MonkeySpeed_shown_Changed()
	if (MonkeySpeedVars.shown == false) then
		MonkeySpeedFrame:Hide()
	else
		local var = MonkeySpeedVars.frameColour
		MonkeySpeedFrame:SetBackdropColor(var.r, var.g, var.b, var.a)
		MonkeySpeedFrame:Show()
	end
end

function MonkeySpeed_frameColour_Changed(prevColour)
	local var = MonkeySpeedVars.frameColour
	if (MonkeySpeedOptions) then
		if (prevColour) then
			var.r = prevColour.r
			var.g = prevColour.g
			var.b = prevColour.b
		else
			var.a = OpacitySliderFrame:GetValue()
			var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
		end
		_G["MonkeySpeedC1_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
		MonkeySpeedFrame:SetBackdropColor(var.r, var.g, var.b, var.a)
	end
end

function MonkeySpeed_showBorder_Changed()
	local var = MonkeySpeedVars.borderColour
	if (MonkeySpeedVars.showBorder == false) then
		MonkeySpeedFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)
	else
		MonkeySpeedFrame:SetBackdropBorderColor(var.r, var.g, var.b)
	end
end

function MonkeySpeed_borderColour_Changed(prevColour)
	local var = MonkeySpeedVars.borderColour
	if (MonkeySpeedOptions) then
		if (prevColour) then
			var.r = prevColour.r
			var.g = prevColour.g
			var.b = prevColour.b
		else
			var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
		end
		MonkeySpeedVars.showBorder = true
		MonkeySpeedCB2:SetChecked(MonkeySpeedVars.showBorder)
		_G["MonkeySpeedC2_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
		MonkeySpeedFrame:SetBackdropBorderColor(var.r, var.g, var.b)
	end
end

function MonkeySpeed_frameLocked_Changed()
	if (MonkeySpeedVars.frameLocked == false and MonkeySpeedFrame:IsVisible()) then
		MonkeySpeedFrame:Hide()
		MonkeySpeedResizerBtn:Show()
		MonkeySpeedFrame:Show()
	elseif (MonkeySpeedVars.frameLocked == false) then
		MonkeySpeedResizerBtn:Show()
	elseif (MonkeySpeedVars.frameLocked == true) then
		MonkeySpeedResizerBtn:Hide()
	end
end

function MonkeySpeed_showPercent_Changed()
	if (MonkeySpeedVars.showPercent == false) then
		MonkeySpeedText:Hide()
	else
		MonkeySpeedText:Show()
	end
end

function MonkeySpeed_showBar_Changed()
	if (MonkeySpeedVars.showBar == false) then
		MonkeySpeedBar:Hide()
	else
		MonkeySpeedBar:Show()
	end
end

function MonkeySpeed_speedColour1_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour1
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC3_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour2_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour2
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC4_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour3_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour3
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC5_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour4_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour4
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC6_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour5_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour5
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC7_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour6_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour6
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC8_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour7_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour7
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC9_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour8_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour8
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC10_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour9_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour9
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC11_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour10_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour10
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	_G["MonkeySpeedC12_ColourBnt_SwatchTexture"]:SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeedResizerBtn_OnMouseDown(self, button)
	if (button == "LeftButton") then
		self:GetParent():StartSizing()
	end
end

function MonkeySpeedResizerBtn_OnMouseUp(self, button)
	if (button == "LeftButton") then
		self:GetParent():StopMovingOrSizing()
	end
end
