


--
local tTexture;
function VUHDO_threatIndicatorsBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName)

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if VUHDO_INDICATOR_CONFIG[VUHDO_BUTTON_CACHE[tButton]]["BOUQUETS"]["THREAT_MARK"] == aBouquetName then
			tTexture = VUHDO_getAggroTexture(VUHDO_getHealthBar(tButton, 1));

			if anIsActive then
				tTexture:SetAllPoints();
				tTexture:SetVertexColor(VUHDO_backColorWithFallback(aColor));

				tTexture:Show();

				VUHDO_UIFrameFlash(tTexture, 0.2, 0.5, 3.2, true, 0, 0);
			else
				VUHDO_UIFrameFlashStop(tTexture);

				tTexture:Hide();
			end
		end
	end

end



--
local tBar;
local tQuota;
function VUHDO_threatBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)

	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0 or (aMaxValue or 0) > 1 and aCurrValue / aMaxValue or 0;

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if VUHDO_INDICATOR_CONFIG[VUHDO_BUTTON_CACHE[tButton]]["BOUQUETS"]["THREAT_BAR"] == aBouquetName then
			if tQuota > 0 then
				tBar = VUHDO_getHealthBar(tButton, 7);

				tBar:SetValue(tQuota);
				tBar:SetVuhDoColor(aColor);
			else
				VUHDO_getHealthBar(tButton, 7):SetValue(0);
			end
		end
	end

end



function VUHDO_threatBarTextCallback(...)
	VUHDO_indicatorTextCallback(7, ...);
end
