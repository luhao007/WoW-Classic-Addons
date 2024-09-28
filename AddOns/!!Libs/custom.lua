-- 添加材质

local media = LibStub("LibSharedMedia-3.0")

media:Register("statusbar", "Atlas", "Interface\\AddOns\\!!Libs\\textures\\Atlas")
media:Register("statusbar", "Delicate", "Interface\\AddOns\\!!Libs\\textures\\Delicate")
media:Register("statusbar", "Dirty Fog", "Interface\\AddOns\\!!Libs\\textures\\Dirty Fog")
media:Register("statusbar", "eXpresso", "Interface\\AddOns\\!!Libs\\textures\\eXpresso")
media:Register("statusbar", "Petrol", "Interface\\AddOns\\!!Libs\\textures\\Petrol")
media:Register("statusbar", "Portrait", "Interface\\AddOns\\!!Libs\\textures\\Portrait")
media:Register("statusbar", "Relay", "Interface\\AddOns\\!!Libs\\textures\\Relay")
media:Register("statusbar", "Sublime Light", "Interface\\AddOns\\!!Libs\\textures\\Sublime Light")
media:Register("statusbar", "Ultra Voilet", "Interface\\AddOns\\!!Libs\\textures\\Ultra Voilet")

media:Register("statusbar", "SmokAugbar", "Interface\\AddOns\\!!Libs\\textures\\SmokAugbar")
media:Register("statusbar", "SmokObjectiveTracker", "Interface\\AddOns\\!!Libs\\textures\\SmokObjectiveTracker")
media:Register("statusbar", "SmokOnePixelBackground", "Interface\\AddOns\\!!Libs\\textures\\SmokOnePixelBackground")
media:Register("statusbar", "SmokOnePixelbar", "Interface\\AddOns\\!!Libs\\textures\\SmokOnePixelbar")


-- 显示装等

-- local GetInventoryItemID,GetItemInfo = GetInventoryItemID,GetItemInfo

-- local function gr(unit)
--     sum = 0
--     for i = 1, 18 do
-- 		if (i == 4) then
-- 			gear = 0
-- 		else
-- 			local slot = GetInventoryItemID(unit,i)
-- 			if (slot == nil) then
-- 				gear = 0
-- 			else
-- 				gear = select(4,GetItemInfo(slot)) or 0
-- 			end
-- 		end
--         sum = sum + gear
--     end

--     --判断是否双手武器
--     if (GetInventoryItemID(unit,17)) then
--         num = 17
--     else
--         num = 16
--     end

--     return string.format("%.1f",(sum/num))
-- end

-- local f = CreateFrame("frame",nil,CharacterModelFrame)
-- f:SetPoint("CENTER",0,150)
-- f:SetSize(60,20)

-- local g = f:CreateFontString()
-- g:SetAllPoints(f)
-- g:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
-- g:SetJustifyH("RIGHT")

-- hooksecurefunc("PaperDollFrame_UpdateStats", function()g:SetText("|cFFFFcF00iLvl "..gr("player").."|r");end)


-- -- 精确BUFF时间

-- local function formatTime(time)
-- 	local seconds = floor(mod(time, 60))
-- 	local minutes = floor(time / 60)

-- 	if (minutes > 0 and seconds < 10) then
-- 	    seconds = 0 .. seconds
-- 	end

-- 	if minutes >= 1 then
-- 	    return minutes .. "|cff".."69ccf0".."m|r"
-- 	else
-- 	    return seconds .. "|cff".."69ccf0".."s|r"
-- 	end
-- end

-- local function DurationUpdate(aura, time)
-- 	local duration = getglobal(aura:GetName().."Duration" )
-- 	if (time) then
-- 	    duration:SetText("|cff".."ffffff"..formatTime(time).."|r")
-- 	    duration:Show()
-- 	else
-- 	    duration:Hide()
-- 	end
-- end

-- local function AuraUpdate(auraSlot, index, filter)
-- 	local auraName = auraSlot..index
-- 	local aura = getglobal(auraName)
-- 	local auraDuration = getglobal(auraName.."Duration")

-- 	if not auraDuration then
-- 	    return
-- 	end

-- 	local name, _, _, _, _, expirationTime = UnitAura("player", index, filter)
-- 	if (name and expirationTime > 0) then
-- 	    auraDuration:Show()
-- 	else
-- 	    auraDuration:Hide()
-- 	end
-- end

-- hooksecurefunc("AuraButton_Update", AuraUpdate)
-- hooksecurefunc("AuraButton_UpdateDuration", DurationUpdate)
