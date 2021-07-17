local _, namespace = ... 	--localization
local L = namespace.L 				--localization

local _, addon = ...
addon.duraMean = 0

local _, gdbprivate = ...

local ipairs = ipairs
local DCS_CharacterShirtSlot = CharacterShirtSlot
local getItemQualityColor = GetItemQualityColor

-- ---------------------------
-- -- DCS Durability Frames --
-- ---------------------------

local DCSITEM_SLOT_FRAMES = {
	CharacterHeadSlot,CharacterNeckSlot,CharacterShoulderSlot,CharacterBackSlot,CharacterChestSlot,CharacterWristSlot,
	CharacterHandsSlot,CharacterWaistSlot,CharacterLegsSlot,CharacterFeetSlot,
	CharacterFinger0Slot,CharacterFinger1Slot,CharacterTrinket0Slot,CharacterTrinket1Slot,
	CharacterMainHandSlot,CharacterSecondaryHandSlot,CharacterRangedSlot,
}

local DCSITEM_SLOT_FRAMES_RIGHT = {
	[CharacterHeadSlot]={},[CharacterShoulderSlot]={},[CharacterChestSlot]={},[CharacterWristSlot]={},
}

local DCSITEM_SLOT_NECK_BACK_SHIRT = {
	[CharacterNeckSlot]={},[CharacterBackSlot]={},[DCS_CharacterShirtSlot]={},
}

local DCSITEM_TWO_HANDED_WEAPONS = {
	"Bows","Crossbows","Guns","Fishing Poles","Polearms","Staves","Two-Handed Axes","Two-Handed Maces","Two-Handed Swords",
}

--local duraMean
local duraTotal
local duraMaxTotal
local duraFinite = 0

--------------------
-- Create Objects --
--------------------
local duraMeanFS = DCS_CharacterShirtSlot:CreateFontString("FontString","OVERLAY","GameTooltipText") --text for average durability on shirt
	duraMeanFS:SetPoint("CENTER",DCS_CharacterShirtSlot,"CENTER",1,-2) --poisiton will be influenced by DCS_Set_Dura_Item_Positions()
	duraMeanFS:SetFont("Fonts\\FRIZQT__.TTF", 15, "THINOUTLINE")
	duraMeanFS:SetFormattedText("")

local duraMeanTexture = DCS_CharacterShirtSlot:CreateTexture(nil,"ARTWORK") --bar for average durability on shirt

local duraDurabilityFrameFS = DurabilityFrame:CreateFontString("FontString","OVERLAY","GameTooltipText")
	duraDurabilityFrameFS:SetPoint("CENTER",DurabilityFrame,"CENTER",0,0)
	duraDurabilityFrameFS:SetFont("Fonts\\FRIZQT__.TTF", 16, "THINOUTLINE")
	duraDurabilityFrameFS:SetFormattedText("")

for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
	v.duratexture = v:CreateTexture(nil,"ARTWORK")

    v.durability = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.durability:SetFormattedText("")

    v.itemrepair = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.itemrepair:SetFormattedText("")

    v.ilevel = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.ilevel:SetFormattedText("")

    v.enchant = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
	v.enchant:SetFormattedText("")

	v.itemcolor = v:CreateTexture(nil,"ARTWORK")
	v.itemcolor:SetAllPoints(v)

	v.ItemFrameOutlineTexture = v:CreateTexture(nil,"OVERLAY",nil)
	v.ItemFrameOutlineTexture:SetPoint("TOPLEFT", v, "TOPLEFT", -2, 2);
	v.ItemFrameOutlineTexture:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", 2, -2);
	v.ItemFrameOutlineTexture:SetTexture("Interface\\Addons\\DejaClassicStats\\DCSArt\\WhiteIconFrame.blp")

	v.ItemFramehighlightTexture = v:CreateTexture(nil, "HIGHLIGHT",nil)
	v.ItemFramehighlightTexture:SetPoint("TOPLEFT", v, "TOPLEFT", -2, 2);
	v.ItemFramehighlightTexture:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", 2, -2);
	v.ItemFramehighlightTexture:SetTexture("Interface\\COMMON\\WhiteIconFrame.blp")
end

local function DCS_Set_Item_Quality_Color_Outlines()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		v.ItemFrameOutlineTexture:SetVertexColor(0, 0, 0, 0);
		v.ItemFramehighlightTexture:SetVertexColor(0, 0, 0, 0);
		local itemLink = GetInventoryItemLink("player", v:GetID())
		if (itemLink==nil) then
			local iLikeCake = true
		else
			local qualityBordersChecked = gdbprivate.gdb.gdbdefaults.DejaClassicStatsItemQualityBorders.ItemQualityBordersChecked
			local qualityBordersAlpha
			if qualityBordersChecked then
				qualityBordersAlpha = gdbprivate.gdb.gdbdefaults.QCOA_SetSliderValue.QCOA_SliderValue
			else
				qualityBordersAlpha = 0
			end
			local item = Item:CreateFromEquipmentSlot(v:GetID())
			local itemName, itemLink = GetItemInfo(itemLink)
			local r, g, b, hex = getItemQualityColor(C_Item.GetItemQualityByID(itemLink))
			v.ItemFrameOutlineTexture:SetVertexColor(r, g, b, qualityBordersAlpha);
			v.ItemFramehighlightTexture:SetVertexColor(r, g, b, qualityBordersAlpha);
		end
	end
end


gdbprivate.gdbdefaults.gdbdefaults.QCOA_SetSliderValue = {
	QCOA_SliderValue = 0.75,
}

-- Quality Color Outlines Alpha Slider:
local QCOA_Slider = CreateFrame("Slider", "QCOA_Slider", DejaClassicStatsPanel, "OptionsSliderTemplate")
	QCOA_Slider:RegisterEvent("PLAYER_LOGIN")
	QCOA_Slider:SetPoint("TOPLEFT", DejaClassicStatsPanel, "TOP", -25, -265)
	QCOA_Slider:SetWidth(200)
	QCOA_Slider:SetHeight(10)
	QCOA_Slider:SetOrientation('HORIZONTAL')
	QCOA_Slider:SetMinMaxValues(0.25, 1.0)
	QCOA_Slider.minValue, QCOA_Slider.maxValue = QCOA_Slider:GetMinMaxValues()
	QCOA_Slider:SetValueStep(0.05)
	QCOA_Slider:SetObeyStepOnDrag(true)

	QCOA_Slider.tooltipText = "Set the intensity (alpha) of your equipped items' quality colored border glow in increments or decrements of 5. Default is 75." --Creates a tooltip on mouseover.

	getglobal(QCOA_Slider:GetName() .. 'Low'):SetText(QCOA_Slider.minValue); --Sets the left-side slider text (default is "Low").
	getglobal(QCOA_Slider:GetName() .. 'High'):SetText(QCOA_Slider.maxValue); --Sets the right-side slider text (default is "High").

	QCOA_Slider:Show()

	QCOA_Slider:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
		local slideValue = gdbprivate.gdb.gdbdefaults.QCOA_SetSliderValue.QCOA_SliderValue
			self:SetValue(slideValue)
			getglobal(QCOA_Slider:GetName() .. 'Text'):SetFormattedText(L["Item Quality Glow"].." = (%.2f)", (slideValue)); --Sets the "title" text (top-centre of slider).
		end
	end)

	QCOA_Slider:SetScript("OnValueChanged", function(self, value)
	local slideValue = QCOA_Slider:GetValue()
		getglobal(QCOA_Slider:GetName() .. 'Text'):SetFormattedText(L["Item Quality Glow"].." = (%.2f)", (slideValue)); --Sets the "title" text (top-centre of slider).
		gdbprivate.gdb.gdbdefaults.QCOA_SetSliderValue.QCOA_SliderValue = slideValue
		if PaperDollFrame:IsVisible() then
			DCS_Set_Item_Quality_Color_Outlines() --Here to update on the events when PaperDoll is open.
		end
	end)

--TODO - setting of their values and checkbox states in frame meant for this purpose

local showavgdur --display of average durability on shirt
local showtextures --display of durability textures
local showdura --display of durability percentage on items
local showrepair --display of item repair cost
local showitemlevel --display of item's item level
local showenchant --display of item's enchant
local simpleitemcolor -- blacking out of item textures for easier seeing of info
local darkeritemcolor -- darkening but not blacking out of item textures for easier seeing of info
local otherinfoplacement --alternate display position of item repair cost, durability, and ilvl

local function puttop(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("LEFT",slot,"RIGHT",6,0)
		else
			fontstring:SetPoint("TOPRIGHT",slot,"TOPLEFT",-6,-2)
		end
		if (slot == CharacterMainHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("RIGHT",slot,"LEFT",-2,-2)
		end
		if (slot == CharacterSecondaryHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("BOTTOMLEFT",slot,"TOPLEFT",-6,15)
		end
		if (slot == CharacterRangedSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("BOTTOMLEFT",slot,"TOPRIGHT",4,-8)
		end
	else
		fontstring:SetPoint("TOP",slot,"TOP",3,-2)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function putcenter(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("LEFT",slot,"RIGHT",10,-2)
		else
			fontstring:SetPoint("RIGHT",slot,"LEFT",-10,-2)
		end
		if (slot == CharacterMainHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("RIGHT",slot,"LEFT",-2,-6)
		end
		if (slot == CharacterSecondaryHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("CENTER",slot,"CENTER",1,-2)
		end
		if (slot == CharacterRangedSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPLEFT",slot,"BOTTOMRIGHT",8,0)
		end
	else
		fontstring:SetPoint("CENTER",slot,"CENTER",1,-2)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function putbottom(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("BOTTOMLEFT",slot,"BOTTOMRIGHT",6,2)
		else
			fontstring:SetPoint("RIGHT",slot,"LEFT",-6,0)
		end
		if (slot == CharacterMainHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("BOTTOMRIGHT",slot,"BOTTOMLEFT",-2,0)
		end
		if (slot == CharacterRangedSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("BOTTOMLEFT",slot,"BOTTOMRIGHT",4,-2)
		end
		if (slot == CharacterSecondaryHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("BOTTOMRIGHT",slot,"TOPRIGHT",20,15)
		end
	else
		fontstring:SetPoint("BOTTOM",slot,"BOTTOM",1,0)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function putothercenter(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("LEFT",slot,"RIGHT",6,-4)
		else
			fontstring:SetPoint("TOPRIGHT",slot,"TOPLEFT",-6,-9)
		end
		if (slot == CharacterMainHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPRIGHT",slot,"TOPRIGHT",8,16)
		end
		if (slot == CharacterSecondaryHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPRIGHT",slot,"TOPRIGHT",8,16)
		end
		if (slot == CharacterRangedSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPRIGHT",slot,"TOPRIGHT",8,16)
		end
	else
		fontstring:SetPoint("TOP",slot,"TOP",3,-2)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

function putenchant(fontstring,slot,size)
	if showenchant then
		ShowDefaultStats = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDefaultStats.ShowDefaultStatsChecked
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("TOPLEFT",slot,"TOPRIGHT",6,-2)
		else
			fontstring:SetPoint("BOTTOMRIGHT",slot,"BOTTOMLEFT",-6,2)
		end
		if (slot == CharacterMainHandSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPRIGHT",slot,"BOTTOMRIGHT",4,4)
		end
		if (slot == CharacterRangedSlot) then
			fontstring:ClearAllPoints()
			fontstring:SetPoint("TOPLEFT",slot,"BOTTOMLEFT",-4,4)
		end
		if ShowDefaultStats then
			if (slot == CharacterSecondaryHandSlot) then
				fontstring:ClearAllPoints()
				fontstring:SetPoint("BOTTOMLEFT",slot,"TOPLEFT",-6,2)
			end
			if (slot == CharacterWristSlot) then
				fontstring:SetPoint("TOPLEFT",slot,"TOPRIGHT",6,-10)
			end
		else
			if (slot == CharacterSecondaryHandSlot) then
				fontstring:ClearAllPoints()
				fontstring:SetPoint("BOTTOMLEFT",slot,"TOPLEFT",-6,6)
			end
		end
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function putilevel(fontstring,slot,size)
	fontstring:SetPoint("CENTER",slot,"CENTER",1,-2)
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function DCS_Set_Dura_Item_Positions()
	--It encompasses item repair, durability and, indirectly, durability bars.
	--making it work with local to DCSDuraRepair.lua variable
	local showdura = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraChecked.ShowDuraSetChecked
	local showrepair = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemRepairChecked.ShowItemRepairSetChecked
	local showenchant = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowEnchantChecked.ShowEnchantSetChecked
	local abbrevEnchants = gdbprivate.gdb.gdbdefaults.DejaClassicStatsAbbrevEnchantsChecked.AbbrevEnchantsSetChecked
	local otherinfoplacement = gdbprivate.gdb.gdbdefaults.DejaClassicStatsAlternateInfoPlacement.AlternateInfoPlacementChecked
	--print("called DCS_Set_Dura_Item_Positions") --debug for later
	duraMeanFS:ClearAllPoints()

	putcenter(duraMeanFS,DCS_CharacterShirtSlot,15)
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		v.durability:ClearAllPoints()
		v.itemrepair:ClearAllPoints()
		v.ilevel:ClearAllPoints()
		v.enchant:ClearAllPoints()
		if showitemlevel then
			if showdura then
				if showrepair then
					puttop(v.durability,v,11)
					putbottom(v.itemrepair,v,11)
				else --not showrepair
					if otherinfoplacement then
						putothercenter(v.durability,v,15)
					else
						puttop(v.durability,v,11)
					end
				end
			else --not showdura
				if showrepair then
					if otherinfoplacement then
						putothercenter(v.itemrepair,v,15)
					else
						putbottom(v.itemrepair,v,11)
					end
				end
			end
			if otherinfoplacement then
				putilevel(v.ilevel,v,16)
			else
				if not (showdura or showrepair) then
					putilevel(v.ilevel,v,16)
				else
					putilevel(v.ilevel,v,14)
				end
			end
		else
			if showdura then
				if showrepair then
					puttop(v.durability,v,11)
					putbottom(v.itemrepair,v,11)
				else --not showrepair
					if otherinfoplacement then
						putothercenter(v.durability,v,15)
					else
						putcenter(v.durability,v,15)
					end
				end
			else --not showdura
				if showrepair then
					if otherinfoplacement then
						putothercenter(v.itemrepair,v,15)
					else
						putcenter(v.itemrepair,v,15)
					end
				end
			end
		end
		if showenchant then
			putenchant(v.enchant,v,11)
		end
	end
end

---------------------------------
-- Durability Mean Calculation --
---------------------------------
function DCS_Mean_DurabilityCalc()
	addon.duraMean = 0
	duraTotal = 0
	duraMaxTotal = 0
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)
		-- --------------------------
		-- -- Mean Durability Calc --
		-- --------------------------
		if durCur == nil then durCur = 0 end
		if durMax == nil then durMax = 0 end

		duraTotal = duraTotal + durCur
		duraMaxTotal = duraMaxTotal + durMax
	end
	if duraMaxTotal == 0 then
		duraMaxTotal = 1
		duraTotal = 1 --if nothing to break then durability should be 100%
	end --puting outside of for loop
	addon.duraMean = ((duraTotal/duraMaxTotal)*100)
end

-----------------------------------
-- Durability Frame Mean Display --
-----------------------------------
local function DCS_Durability_Frame_Mean_Display()
	--DCS_Mean_DurabilityCalc() -- DCS_Mean_DurabilityCalc called already before
	duraDurabilityFrameFS:SetFormattedText("%.0f%%", addon.duraMean)
	duraDurabilityFrameFS:Show()
--	print(addon.duraMean)
	if addon.duraMean == 100 then --If mean is 100 hide text % display
		duraDurabilityFrameFS:Hide()
	elseif addon.duraMean >= 80 then --If mean is 80% or greater color the text off-white.
		duraDurabilityFrameFS:SetTextColor(0.753, 0.753, 0.753)
	elseif addon.duraMean > 66 then --If mean is 66% or greater then color the text green.
		duraDurabilityFrameFS:SetTextColor(0, 1, 0)
	elseif addon.duraMean > 33 then --If mean is 33% or greater then color the text yellow.
		duraDurabilityFrameFS:SetTextColor(1, 1, 0)
	elseif addon.duraMean >= 0 then --If mean is 0% or greater then color the text red. Is this check needed?
		duraDurabilityFrameFS:SetTextColor(1, 0, 0)
	end
end

-----------------------------------
-- Mean Durability Shirt Display --
-----------------------------------
local function DCS_Mean_Durability()
	DCS_Mean_DurabilityCalc()
    if addon.duraMean < 10 then
		duraMeanFS:SetTextColor(1, 0, 0)
	elseif addon.duraMean < 33 then
		duraMeanFS:SetTextColor(1, 0, 0)
	elseif addon.duraMean < 66 then
	    duraMeanFS:SetTextColor(1, 1, 0)
	elseif addon.duraMean < 80 then
		duraMeanFS:SetTextColor(0, 1, 0)
	elseif addon.duraMean < 100 then
		duraMeanFS:SetTextColor(0.753, 0.753, 0.753)
	end
	if DurabilityFrame:IsVisible() then
		DCS_Durability_Frame_Mean_Display()
	end
end

----------------------------
-- Item Durability Colors --
----------------------------
local function DCS_Item_DurabilityTop()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)
		--if durCur == nil or durMax == nil then
		--	v.duratexture:SetColorTexture(0, 0, 0, 0)
		--	v.durability:SetFormattedText("")
		--elseif ( durCur == durMax ) then
		if ( durCur == durMax ) then
			--v.duratexture:SetColorTexture(0, 0, 0, 0) --moving texture stuff to textures
			v.durability:SetFormattedText("")
		else --if ( durCur ~= durMax ) then -- no need to check, can remain as comment for easier understanding
			duraFinite = ((durCur/durMax)*100)
			--print(duraFinite)
		    v.durability:SetFormattedText("%.0f%%", duraFinite)
			--if duraFinite == 100 then --this should be covered by durCur == durMax
			--	v.duratexture:SetColorTexture(0,  0, 0, 0)
			--	v.durability:SetTextColor(0, 0, 0, 0)
			--	print ("what is this")
			--elseif duraFinite > 66 then
			if duraFinite > 66 then
				--v.duratexture:SetColorTexture(0, 1, 0)
				v.durability:SetTextColor(0, 1, 0)
			elseif duraFinite > 33 then
				--v.duratexture:SetColorTexture(1, 1, 0)
				v.durability:SetTextColor(1, 1, 0)
			elseif duraFinite > 10 then
				--v.duratexture:SetColorTexture(1, 0, 0)
				v.durability:SetTextColor(1, 0, 0)
			else --if duraFinite <= 10 then -- no need to check, can remain as comment for easier understanding
				--v.duratexture:SetAllPoints(v) -Removed so green boxes do not appear when durability is at zero.
				--v.duratexture:SetColorTexture(1, 0, 0, 0.10)
				v.durability:SetTextColor(1, 0, 0)
			end
		end
		--DCS_Mean_DurabilityCalc() -- moving outside for loop
	end
	--DCS_Mean_DurabilityCalc() -- seems like it gets called even before this
end

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowDuraChecked = {
	ShowDuraSetChecked = false,
}

local DCS_ShowDuraCheck = CreateFrame("CheckButton", "DCS_ShowDuraCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowDuraCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowDuraCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowDuraCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowDuraCheck:ClearAllPoints()
	DCS_ShowDuraCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -75)
	DCS_ShowDuraCheck:SetScale(1)
	DCS_ShowDuraCheck.tooltipText = L["Displays each equipped item's durability."] --Creates a tooltip on mouseover.
	_G[DCS_ShowDuraCheck:GetName() .. "Text"]:SetText(L["Item Durability"])

local event	--TODO: delete second variable event that might appear after merging
DCS_ShowDuraCheck:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		showdura = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraChecked.ShowDuraSetChecked
		self:SetChecked(showdura)
		DCS_Set_Dura_Item_Positions()
	end
	if PaperDollFrame:IsVisible() then
		if showdura then
			DCS_Item_DurabilityTop()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.durability:SetFormattedText("")
			end
		end
		local checked = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraChecked.ShowDuraSetChecked
		self:SetChecked(checked)
		DCS_Set_Dura_Item_Positions()
		if checked then
			DCS_Item_DurabilityTop()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.durability:SetFormattedText("")
			end
		end
	end
end)

DCS_ShowDuraCheck:SetScript("OnClick", function(self)
	showdura = not showdura
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraChecked.ShowDuraSetChecked = showdura
	DCS_Set_Dura_Item_Positions() --same line irrespectfully of the condtition
	if showdura then
		DCS_Item_DurabilityTop()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.durability:SetFormattedText("")
		end
	end
	local checked = self:GetChecked()
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraChecked.ShowDuraSetChecked = checked
	DCS_Set_Dura_Item_Positions() --same line irrespectfully of the condtition
	if checked then
		DCS_Item_DurabilityTop()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.durability:SetFormattedText("")
		end
	end
end)

--------------------------------------
-- Durability Bar Textures Creation --
--------------------------------------
local function DCS_Durability_Bar_Textures()
	-- I see really similar loop in DCS_Item_DurabilityTop(), can't they be merged (of course, need to check whether they get called within the same condition)
	duraTotal = 0 --calculation of average for shirt bar is also here
	duraMaxTotal = 0
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)
		if durCur == nil then durCur = 0 end
		if durMax == nil then durMax = 0 end
		duraTotal = duraTotal + durCur
		duraMaxTotal = duraMaxTotal + durMax
		if ( durCur == durMax ) then
			v.duratexture:SetColorTexture(0, 0, 0, 0)
		else --if ( durCur ~= durMax ) then -- no need to check, can remain as comment for easier understanding
			duraFinite = durCur/durMax
            if duraFinite > 0.66 then
	            v.duratexture:SetColorTexture(0, 1, 0)
		    elseif duraFinite > 0.33 then
				v.duratexture:SetColorTexture(1, 1, 0)
			elseif duraFinite > 0.10 then
				v.duratexture:SetColorTexture(1, 0, 0)
			else --if duraFinite <= 0.10 then -- no need to check, can remain as comment for easier understanding
				v.duratexture:SetColorTexture(1, 0, 0, 0.10)
			end
		    if DCSITEM_SLOT_FRAMES_RIGHT[v] then
		        v.duratexture:SetPoint("BOTTOMLEFT",v,"BOTTOMRIGHT",1,3)
			    v.duratexture:SetSize(4, (31*duraFinite))
			else
                v.duratexture:SetPoint("BOTTOMRIGHT",v,"BOTTOMLEFT",-2,3)
				v.duratexture:SetSize(3, (31*duraFinite))
			end
		    v.duratexture:Show()
		end
	end
	if duraMaxTotal == 0 then
		duraMaxTotal = 1
		duraTotal = 1 --if nothing to break then durability should be 100%
	end
	local duraMean = duraTotal/duraMaxTotal
	duraMeanTexture:SetSize(4, 31*duraMean)
	if duraMean == 1 then
		duraMeanTexture:SetColorTexture(0, 0, 0, 0)
	elseif duraMean < 0.10 then
		--duraMeanTexture:SetColorTexture(1, 0, 0)
		duraMeanTexture:SetColorTexture(1, 0, 0, 0.15)
	elseif duraMean < 0.33 then
		duraMeanTexture:SetColorTexture(1, 0, 0)
	elseif duraMean < 0.66 then
		duraMeanTexture:SetColorTexture(1, 1, 0)
	elseif duraMean < 0.80 then
		duraMeanTexture:SetColorTexture(0, 1, 0)
	else --if duraMean < 1 then -- no need to check, can remain as comment for easier understanding
		duraMeanTexture:SetColorTexture(0.753, 0.753, 0.753)
	end
	duraMeanTexture:ClearAllPoints()
	if duraMean > 0.10 then
		duraMeanTexture:SetPoint("BOTTOMLEFT",DCS_CharacterShirtSlot,"BOTTOMRIGHT",1,3)
	else --if duraMean <= 0.10 then -- no need to check, can remain as comment for easier understanding
		duraMeanTexture:SetAllPoints(DCS_CharacterShirtSlot)
	end
end

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowDuraTextureChecked = {
	ShowDuraTextureSetChecked = true,
}

local DCS_ShowDuraTextureCheck = CreateFrame("CheckButton", "DCS_ShowDuraTextureCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowDuraTextureCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowDuraTextureCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowDuraTextureCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowDuraTextureCheck:ClearAllPoints()
	DCS_ShowDuraTextureCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -35)
	DCS_ShowDuraTextureCheck:SetScale(1)
	DCS_ShowDuraTextureCheck.tooltipText = L["Displays a durability bar next to each item."] --Creates a tooltip on mouseover.
	_G[DCS_ShowDuraTextureCheck:GetName() .. "Text"]:SetText(L["Durability Bars"])

DCS_ShowDuraTextureCheck:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		showtextures = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraTextureChecked.ShowDuraTextureSetChecked
		self:SetChecked(showtextures)
	end
	--print("DCS_ShowDuraTextureCheck:SetScript(OnEvent)")
	if PaperDollFrame:IsVisible() then
		--print("PaperDollFrame:IsVisible()")
		if showtextures then
			--print("showtextures")
			DCS_Durability_Bar_Textures()
			--DCS_Mean_Durability() --average durability for bar near shirt should be in DCS_Durability_Bar_Textures()
			--DCS_Item_DurabilityTop() --all single item durability stuff should be in DCS_Durability_Bar_Textures()
			duraMeanTexture:Show()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.duratexture:Hide()
			end
			duraMeanTexture:Hide()
		end
		local checked = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraTextureChecked.ShowDuraTextureSetChecked
		self:SetChecked(checked)
		if checked then
			DCS_Durability_Bar_Textures()
			DCS_Mean_Durability()
			DCS_Item_DurabilityTop()
			duraMeanTexture:Show()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.duratexture:Hide()
			end
			duraMeanTexture:Hide()
		end
	end
end)

DCS_ShowDuraTextureCheck:SetScript("OnClick", function(self)
	showtextures = not showtextures
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraTextureChecked.ShowDuraTextureSetChecked = showtextures
	if showtextures then
		DCS_Durability_Bar_Textures()
		--DCS_Mean_Durability() --average durability for bar near shirt should be in DCS_Durability_Bar_Textures()
		--DCS_Item_DurabilityTop() --all single item durability stuff should be in DCS_Durability_Bar_Textures()
		duraMeanTexture:Show()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.duratexture:Hide()
		end
		duraMeanTexture:Hide()
	end
	local checked = self:GetChecked()
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowDuraTextureChecked.ShowDuraTextureSetChecked = checked
	if checked then
		DCS_Durability_Bar_Textures()
		DCS_Mean_Durability()
		DCS_Item_DurabilityTop()
		duraMeanTexture:Show()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.duratexture:Hide()
		end
		duraMeanTexture:Hide()
	end
end)

------------------------
-- Average Durability --
------------------------

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowAverageRepairChecked = {
	ShowAverageRepairSetChecked = true,
}

local DCS_ShowAverageDuraCheck = CreateFrame("CheckButton", "DCS_ShowAverageDuraCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowAverageDuraCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowAverageDuraCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowAverageDuraCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowAverageDuraCheck:ClearAllPoints()
	DCS_ShowAverageDuraCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -55)
	DCS_ShowAverageDuraCheck:SetScale(1)
	DCS_ShowAverageDuraCheck.tooltipText = L["Displays average item durability on the character shirt slot and durability frames."] --Creates a tooltip on mouseover.
	_G[DCS_ShowAverageDuraCheck:GetName() .. "Text"]:SetText(L["Average Durability"])

	DCS_ShowAverageDuraCheck:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			showavgdur = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowAverageRepairChecked.ShowAverageRepairSetChecked
			self:SetChecked(showavgdur)
		end
		--print(..., DurabilityFrame:IsVisible(),DurabilityFrame:IsShown())
		if showavgdur and (DurabilityFrame:IsVisible() or PaperDollFrame:IsVisible()) then
			DCS_Mean_Durability()
			if addon.duraMean == 100 then --check after calculation
				duraMeanFS:SetFormattedText("")
			else
				duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
			end
		else
			duraMeanFS:SetFormattedText("")
			duraDurabilityFrameFS:Hide()
		end
	end)

	DCS_ShowAverageDuraCheck:SetScript("OnClick", function(self)
		showavgdur = not showavgdur
		gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowAverageRepairChecked.ShowAverageRepairSetChecked = showavgdur
		if showavgdur then
			DCS_Mean_Durability()
			if addon.duraMean == 100 then --check after calculation
				duraMeanFS:SetFormattedText("")
			else
				duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
			end
		else
			duraMeanFS:SetFormattedText("")
			duraDurabilityFrameFS:Hide()
		end
	end)

----------------------
-- Item Repair Cost --
----------------------
local function DCS_Item_RepairCostBottom()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local scanTool = CreateFrame("GameTooltip")
			scanTool:ClearLines()
		local repairitemCost = select(3, scanTool:SetInventoryItem("player", slotId))
		if (repairitemCost<=0) then
			v.itemrepair:SetFormattedText("")
		elseif (repairitemCost>999999) then -- 99G 99s 99c
			v.itemrepair:SetTextColor(1, 0.843, 0)
			v.itemrepair:SetFormattedText("%.0fg", (repairitemCost/10000))
		elseif (repairitemCost>9999) then -- 99s 99c
			v.itemrepair:SetTextColor(1, 0.843, 0)
			v.itemrepair:SetFormattedText("%.2fg", (repairitemCost/10000))
		elseif (repairitemCost>99) then -- 99c
			v.itemrepair:SetTextColor(0.753, 0.753, 0.753)
			v.itemrepair:SetFormattedText("%.2fs", (repairitemCost/100))
		else
			v.itemrepair:SetTextColor(0.722, 0.451, 0.200)
			v.itemrepair:SetFormattedText("%.0fc", repairitemCost)
		end
	end
end


gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowItemRepairChecked = {
	ShowItemRepairSetChecked = false,
}

local DCS_ShowItemRepairCheck = CreateFrame("CheckButton", "DCS_ShowItemRepairCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowItemRepairCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ShowItemRepairCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowItemRepairCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowItemRepairCheck:RegisterEvent("MERCHANT_SHOW")
	DCS_ShowItemRepairCheck:RegisterEvent("MERCHANT_CLOSED") --without this event repair cost should remain unchanged from the last vendor
	DCS_ShowItemRepairCheck:ClearAllPoints()
	DCS_ShowItemRepairCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -95)
	DCS_ShowItemRepairCheck:SetScale(1)
	DCS_ShowItemRepairCheck.tooltipText = L["Displays each equipped item's repair cost."] --Creates a tooltip on mouseover.
	_G[DCS_ShowItemRepairCheck:GetName() .. "Text"]:SetText(L["Item Repair Cost"])

DCS_ShowItemRepairCheck:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		-- print(self:GetChecked())
		showrepair = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemRepairChecked.ShowItemRepairSetChecked
		self:SetChecked(showrepair)
		DCS_Set_Dura_Item_Positions()
	end
	--print("want to recalculate repairs")
	if PaperDollFrame:IsVisible() then
		--print("recalculating repairs")
		if showrepair then
			DCS_Item_RepairCostBottom()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.itemrepair:SetFormattedText("")
			end
		end
		local checked = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemRepairChecked.ShowItemRepairSetChecked
		self:SetChecked(checked)
		DCS_Set_Dura_Item_Positions()
		if checked then
			DCS_Item_RepairCostBottom()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.itemrepair:SetFormattedText("")
			end
		end
	end
end)

DCS_ShowItemRepairCheck:SetScript("OnClick", function(self)
	showrepair = not showrepair
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemRepairChecked.ShowItemRepairSetChecked = showrepair
	DCS_Set_Dura_Item_Positions()
	if showrepair then
		DCS_Item_RepairCostBottom()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.itemrepair:SetFormattedText("")
		end
	end
	local checked = self:GetChecked()
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemRepairChecked.ShowItemRepairSetChecked = checked
	DCS_Set_Dura_Item_Positions()
	if checked then
		DCS_Item_RepairCostBottom()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.itemrepair:SetFormattedText("")
		end
	end
end)

local function attempt_ilvl(v,attempts)
	if attempts > 0 then
		local item = Item:CreateFromEquipmentSlot(v:GetID())
		local value = item:GetCurrentItemLevel()
		if value then --ilvl of nil probably indicates that there's no tem in that slot
			if value > 0 then --ilvl of 0 probably indicates that item is not fully loaded
				v.ilevel:SetTextColor(getItemQualityColor(item:GetItemQuality())) --upvalue call
				v.ilevel:SetText(value)
			else
				C_Timer.After(0.2, function() attempt_ilvl(v,attempts-1) end)
			end
		else
			v.ilevel:SetText("")
		end
	end
end

local function DCS_Item_Level_Center()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		attempt_ilvl(v,20)
	end
end

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowItemLevelChecked = {
	ShowItemLevelSetChecked = false,
}

local DCS_ShowItemLevelCheck = CreateFrame("CheckButton", "DCS_ShowItemLevelCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowItemLevelCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ShowItemLevelCheck:ClearAllPoints()
	DCS_ShowItemLevelCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -15)
	DCS_ShowItemLevelCheck:SetScale(1)
	DCS_ShowItemLevelCheck.tooltipText = L["Displays the item level of each equipped item. Caveat; Item level is relatively meaningless in Classic."] --Creates a tooltip on mouseover.
	_G[DCS_ShowItemLevelCheck:GetName() .. "Text"]:SetText(L["Item Level"])

DCS_ShowItemLevelCheck:SetScript("OnEvent", function(self, event, ...)
	showitemlevel = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemLevelChecked.ShowItemLevelSetChecked
	self:SetChecked(showitemlevel)
	DCS_Set_Dura_Item_Positions()
	DCS_Item_Level_Center() --why it is called
end)

DCS_ShowItemLevelCheck:SetScript("OnClick", function(self)
	showitemlevel = not showitemlevel
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowItemLevelChecked.ShowItemLevelSetChecked = showitemlevel
	DCS_Set_Dura_Item_Positions() --is this call needed? (Yes, it is -Deja)
	if showitemlevel then --TODO: rewrite of DCS_Item_Level_Center because in 3 places the same code
		DCS_Item_Level_Center()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.ilevel:SetFormattedText("")
		end
	end
end)

local DCS_ShowItemLevelChange = CreateFrame("Frame", "DCS_ShowItemLevelChange", UIParent)
	DCS_ShowItemLevelChange:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

DCS_ShowItemLevelChange:SetScript("OnEvent", function(self, event, ...)
	if PaperDollFrame:IsVisible() then
		--print("PaperDollFrame:IsVisible")
		if showitemlevel then
		--print("showitemlevel")
			C_Timer.After(0.25, DCS_Item_Level_Center) --Event fires before Artifact changes so we have to wait a fraction of a second.
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.ilevel:SetFormattedText("")
			end
		end
	end
end)

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsSimpleItemColorChecked = {
	SimpleItemColorChecked = false,
	DarkerItemColorChecked = false,
}

local function paintblack()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		if simpleitemcolor then
			v.itemcolor:SetColorTexture(0, 0, 0, 1)
			v.itemcolor:Show()
		elseif darkeritemcolor then
			v.itemcolor:SetColorTexture(0, 0, 0, 0.6)
			v.itemcolor:Show()
		else
			v.itemcolor:Hide()
		end
	end
end

local DCS_SimpleItemColorCheck = CreateFrame("CheckButton", "DCS_SimpleItemColorCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_SimpleItemColorCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_SimpleItemColorCheck:ClearAllPoints()
	DCS_SimpleItemColorCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -135)
	DCS_SimpleItemColorCheck:SetScale(1)
	DCS_SimpleItemColorCheck.tooltipText = L["Black item icons to make text more visible."] --Creates a tooltip on mouseover.
	_G[DCS_SimpleItemColorCheck:GetName() .. "Text"]:SetText(L["Black Item Icons"])

local DCS_DarkerItemColorCheck = CreateFrame("CheckButton", "DCS_DarkerItemColorCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_DarkerItemColorCheck:ClearAllPoints()
	DCS_DarkerItemColorCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -115)
	DCS_DarkerItemColorCheck:SetScale(1)
	DCS_DarkerItemColorCheck.tooltipText = L["Darken item icons to make text more visible."] --Creates a tooltip on mouseover.
	_G[DCS_DarkerItemColorCheck:GetName() .. "Text"]:SetText(L["Darken Item Icons"])

DCS_SimpleItemColorCheck:SetScript("OnEvent", function(self, event, ...)
	simpleitemcolor = gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.SimpleItemColorChecked
	darkeritemcolor = gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.DarkerItemColorChecked
	self:SetChecked(simpleitemcolor)
	DCS_DarkerItemColorCheck:SetChecked(darkeritemcolor)
	paintblack()
end)

DCS_SimpleItemColorCheck:SetScript("OnClick", function(self)
	simpleitemcolor = not simpleitemcolor
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.SimpleItemColorChecked = simpleitemcolor
	if simpleitemcolor then
		DCS_DarkerItemColorCheck:SetChecked(false)
		gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.DarkerItemColorChecked = false
		darkeritemcolor = false
	end
	paintblack()
end)

DCS_DarkerItemColorCheck:SetScript("OnClick", function(self)
	darkeritemcolor = not darkeritemcolor
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.DarkerItemColorChecked = darkeritemcolor
	if darkeritemcolor then
		DCS_SimpleItemColorCheck:SetChecked(false)
		gdbprivate.gdb.gdbdefaults.DejaClassicStatsSimpleItemColorChecked.SimpleItemColorChecked = false
		simpleitemcolor = false
	end
	paintblack()
end)

-- local DCS_SimpleItemColor = CreateFrame("Frame", "DCS_SimpleItemColor", UIParent) --Needed? Doesn't seem so.
-- 	DCS_SimpleItemColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- 	DCS_SimpleItemColor:SetScript("OnEvent", function(self, event, ...)
-- 		if PaperDollFrame:IsVisible() then
-- 			paintblack()
-- 		end
-- 	end)

local DCS_ENCHANT_IDS = {
	[1] = "Rockbiter 3",
	[2] = "Frostbrand 1",
	[3] = "Flametongue 3",
	[4] = "Flametongue 2",
	[5] = "Flametongue 1",
	[6] = "Rockbiter 2",
	[7] = "Deadly Poison",
	[8] = "Deadly Poison II",
	[9] = "Poison (15 Dmg)",
	[10] = "Poison (20 Dmg)",
	[11] = "Poison (25 Dmg)",
	[12] = "Frostbrand 2",
	[13] = "Sharpened (+3 Damage)",
	[14] = "Sharpened (+4 Damage)",
	[15] = "Reinforced (+8 Armor)",
	[16] = "Reinforced (+16 Armor)",
	[17] = "Reinforced (+24 Armor)",
	[18] = "Reinforced (+32 Armor)",
	[19] = "Weighted (+2 Damage)",
	[20] = "Weighted (+3 Damage)",
	[21] = "Weighted (+4 Damage)",
	[22] = "Crippling Poison",
	[23] = "Mind-numbing Poison II",
	[24] = "+5 Mana",
	[25] = "Shadow Oil",
	[26] = "Frost Oil",
	[27] = "Sundered",
	[28] = "+4 All Resistances",
	[29] = "Rockbiter 1",
	[30] = "Scope (+1 Damage)",
	[31] = "+4 Beastslaying",
	[32] = "Scope (+2 Damage)",
	[33] = "Scope (+3 Damage)",
	[34] = "Counterweight (+20 Haste Rating)",
	[35] = "Mind Numbing Poison",
	[36] = "Enchant: Fiery Blaze",
	[37] = "Steel Weapon Chain",
	[38] = "+5 Defense Rating",
	[39] = "Sharpened (+1 Damage)",
	[40] = "Sharpened (+2 Damage)",
	[41] = "+5 Health",
	[42] = "Poison (Instant 20)",
	[43] = "Iron Spike (8-12)",
	[44] = "Absorption (10)",
	[63] = "Absorption (25)",
	[64] = "+3 Spirit",
	[65] = "+1 All Resistances",
	[66] = "+1 Stamina",
	[67] = "+1 Damage",
	[68] = "+1 Strength",
	[69] = "+2 Strength",
	[70] = "+3 Strength",
	[71] = "+1 Stamina",
	[72] = "+2 Stamina",
	[73] = "+3 Stamina",
	[74] = "+1 Agility",
	[75] = "+2 Agility",
	[76] = "+3 Agility",
	[77] = "+2 Damage",
	[78] = "+3 Damage",
	[79] = "+1 Intellect",
	[80] = "+2 Intellect",
	[81] = "+3 Intellect",
	[82] = "+1 Spirit",
	[83] = "+2 Spirit",
	[84] = "+3 Spirit",
	[85] = "+3 Armor",
	[86] = "+8 Armor",
	[87] = "+12 Armor",
	[88] = "",
	[89] = "+16 Armor",
	[90] = "+4 Agility",
	[91] = "+5 Agility",
	[92] = "+6 Agility",
	[93] = "+7 Agility",
	[94] = "+4 Intellect",
	[95] = "+5 Intellect",
	[96] = "+6 Intellect",
	[97] = "+7 Intellect",
	[98] = "+4 Spirit",
	[99] = "+5 Spirit",
	[100] = "+6 Spirit",
	[101] = "+7 Spirit",
	[102] = "+4 Stamina",
	[103] = "+5 Stamina",
	[104] = "+6 Stamina",
	[105] = "+7 Stamina",
	[106] = "+4 Strength",
	[107] = "+5 Strength",
	[108] = "+6 Strength",
	[109] = "+7 Strength",
	[110] = "+1 Defense Rating",
	[111] = "+2 Defense Rating",
	[112] = "+3 Defense Rating",
	[113] = "+4 Defense Rating",
	[114] = "+5 Defense Rating",
	[115] = "+6 Defense Rating",
	[116] = "+7 Defense Rating",
	[117] = "+4 Damage",
	[118] = "+5 Damage",
	[119] = "+6 Damage",
	[120] = "+7 Damage",
	[121] = "+20 Armor",
	[122] = "+24 Armor",
	[123] = "+28 Armor",
	[124] = "Flametongue Totem 1",
	[125] = "+1 Sword Skill",
	[126] = "+2 Sword Skill",
	[127] = "+3 Sword Skill",
	[128] = "+4 Sword Skill",
	[129] = "+5 Sword Skill",
	[130] = "+6 Sword Skill",
	[131] = "+7 Sword Skill",
	[132] = "+1 Two-Handed Sword Skill",
	[133] = "+2 Two-Handed Sword Skill",
	[134] = "+3 Two-Handed Sword Skill",
	[135] = "+4 Two-Handed Sword Skill",
	[136] = "+5 Two-Handed Sword Skill",
	[137] = "+6 Two-Handed Sword Skill",
	[138] = "+7 Two-Handed Sword Skill",
	[139] = "+1 Mace Skill",
	[140] = "+2 Mace Skill",
	[141] = "+3 Mace Skill",
	[142] = "+4 Mace Skill",
	[143] = "+5 Mace Skill",
	[144] = "+6 Mace Skill",
	[145] = "+7 Mace Skill",
	[146] = "+1 Two-Handed Mace Skill",
	[147] = "+2 Two-Handed Mace Skill",
	[148] = "+3 Two-Handed Mace Skill",
	[149] = "+4 Two-Handed Mace Skill",
	[150] = "+5 Two-Handed Mace Skill",
	[151] = "+6 Two-Handed Mace Skill",
	[152] = "+7 Two-Handed Mace Skill",
	[153] = "+1 Axe Skill",
	[154] = "+2 Axe Skill",
	[155] = "+3 Axe Skill",
	[156] = "+4 Axe Skill",
	[157] = "+5 Axe Skill",
	[158] = "+6 Ase Skill",
	[159] = "+7 Axe Skill",
	[160] = "+1 Two-Handed Axe Skill",
	[161] = "+2 Two-Handed Axe Skill",
	[162] = "+3 Two-Handed Axe Skill",
	[163] = "+4 Two-Handed Axe Skill",
	[164] = "+5 Two-Handed Axe Skill",
	[165] = "+6 Two-Handed Axe Skill",
	[166] = "+7 Two-Handed Axe Skill",
	[167] = "+1 Dagger Skill",
	[168] = "+2 Dagger Skill",
	[169] = "+3 Dagger Skill",
	[170] = "+4 Dagger Skill",
	[171] = "+5 Dagger Skill",
	[172] = "+6 Dagger Skill",
	[173] = "+7 Dagger Skill",
	[174] = "+1 Gun Skill",
	[175] = "+2 Gun Skill",
	[176] = "+3 Gun Skill",
	[177] = "+4 Gun Skill",
	[178] = "+5 Gun Skill",
	[179] = "+6 Gun Skill",
	[180] = "+7 Gun Skill",
	[181] = "+1 Bow Skill",
	[182] = "+2 Bow Skill",
	[183] = "+3 Bow Skill",
	[184] = "+4 Bow Skill",
	[185] = "+5 Bow Skill",
	[186] = "+6 Bow Skill",
	[187] = "+7 Bow Skill",
	[188] = "+2 Beast Slaying",
	[189] = "+4 Beast Slaying",
	[190] = "+6 Beast Slaying",
	[191] = "+8 Beast Slaying",
	[192] = "+10 Beast Slaying",
	[193] = "+12 Beast Slaying",
	[194] = "+14 Beast Slaying",
	[195] = "+14 Critical Strike Rating",
	[196] = "+28 Critical Strike Rating",
	[197] = "+42 Critical Strike Rating",
	[198] = "+56 Critical Strike Rating",
	[199] = "10% On Get Hit: Shadow Bolt (10 Damage)",
	[200] = "10% On Get Hit: Shadow Bolt (20 Damage)",
	[201] = "10% On Get Hit: Shadow Bolt (30 Damage)",
	[202] = "10% On Get Hit: Shadow Bolt (40 Damage)",
	[203] = "10% On Get Hit: Shadow Bolt (50 Damage)",
	[204] = "10% On Get Hit: Shadow Bolt (60 Damage)",
	[205] = "10% On Get Hit: Shadow Bolt (70 Damage)",
	[206] = "+2 Healing",
	[207] = "+4 Healing",
	[208] = "+7 Healing",
	[209] = "+9 Healing",
	[210] = "+11 Healing",
	[211] = "+13 Healing",
	[212] = "+15 Healing",
	[213] = "+1 Fire Spell Damage",
	[214] = "+3 Fire Spell Damage",
	[215] = "+4 Fire Spell Damage",
	[216] = "+6 Fire Spell Damage",
	[217] = "+7 Fire Spell Damage",
	[218] = "+9 Fire Spell Damage",
	[219] = "+10 Fire Spell Damage",
	[220] = "+1 Nature Spell Damage",
	[221] = "+3 Nature Spell Damage",
	[222] = "+4 Nature Spell Damage",
	[223] = "+6 Nature Spell Damage",
	[224] = "+7 Nature Spell Damage",
	[225] = "+9 Nature Spell Damage",
	[226] = "+10 Nature Spell Damage",
	[227] = "+1 Frost Spell Damage",
	[228] = "+3 Frost Spell Damage",
	[229] = "+4 Frost Spell Damage",
	[230] = "+6 Frost Spell Damage",
	[231] = "+7 Frost Spell Damage",
	[232] = "+9 Frost Spell Damage",
	[233] = "+10 Frost Spell Damage",
	[234] = "+1 Shadow Spell Damage",
	[235] = "+3 Shadow Spell Damage",
	[236] = "+4 Shadow Spell Damage",
	[237] = "+6 Shadow Spell Damage",
	[238] = "+7 Shadow Spell Damage",
	[239] = "+9 Shadow Spell Damage",
	[240] = "+10 Shadow Spell Damage",
	[241] = "+2 Weapon Damage",
	[242] = "+15 Health",
	[243] = "+1 Spirit",
	[244] = "+4 Intellect",
	[245] = "+5 Armor",
	[246] = "+20 Mana",
	[247] = "+1 Agility",
	[248] = "+1 Strength",
	[249] = "+2 Beastslaying",
	[250] = "+1  Weapon Damage",
	[251] = "+1 Intellect",
	[252] = "+6 Spirit",
	[253] = "Absorption (50)",
	[254] = "+25 Health",
	[255] = "+3 Spirit",
	[256] = "+5 Fire Resistance",
	[257] = "+10 Armor",
	[263] = "Fishing Lure (+25 Fishing Skill)",
	[264] = "Fishing Lure (+50 Fishing Skill)",
	[265] = "Fishing Lure (+75 Fishing Skill)",
	[266] = "Fishing Lure (+100 Fishing Skill)",
	[283] = "Windfury 1",
	[284] = "Windfury 2",
	[285] = "Flametongue Totem 2",
	[286] = "+2 Weapon Fire Damage",
	[287] = "+4 Weapon Fire Damage",
	[288] = "+6 Weapon Fire Damage",
	[289] = "+8 Weapon Fire Damage",
	[290] = "+10 Weapon Fire Damage",
	[291] = "+12 Weapon Fire Damage",
	[292] = "+14 Weapon Fire Damage",
	[303] = "Orb of Fire",
	[323] = "Instant Poison",
	[324] = "Instant Poison II",
	[325] = "Instant Poison III",
	[343] = "+8 Agility",
	[344] = "+32 Armor",
	[345] = "+40 Armor",
	[346] = "+36 Armor",
	[347] = "+44 Armor",
	[348] = "+48 Armor",
	[349] = "+9 Agility",
	[350] = "+8 Intellect",
	[351] = "+8 Spirit",
	[352] = "+8 Strength",
	[353] = "+8 Stamina",
	[354] = "+9 Intellect",
	[355] = "+9 Spirit",
	[356] = "+9 Stamina",
	[357] = "+9 Strength",
	[358] = "+10 Agility",
	[359] = "+10 Intellect",
	[360] = "+10 Spirit",
	[361] = "+10 Stamina",
	[362] = "+10 Strength",
	[363] = "+11 Agility",
	[364] = "+11 Intellect",
	[365] = "+11 Spirit",
	[366] = "+11 Stamina",
	[367] = "+11 Strength",
	[368] = "+12 Agility",
	[369] = "+12 Intellect",
	[370] = "+12 Spirit",
	[371] = "+12 Stamina",
	[372] = "+12 Strength",
	[383] = "+52 Armor",
	[384] = "+56 Armor",
	[385] = "+60 Armor",
	[386] = "+16 Armor",
	[387] = "+17 Armor",
	[388] = "+18 Armor",
	[389] = "+19 Armor",
	[403] = "+13 Agility",
	[404] = "+14 Agility",
	[405] = "+13 Intellect",
	[406] = "+14 Intellect",
	[407] = "+13 Spirit",
	[408] = "+14 Spirit",
	[409] = "+13 Stamina",
	[410] = "+13 Strength",
	[411] = "+14 Stamina",
	[412] = "+14 Strength",
	[423] = "+1 Healing and Spell Damage",
	[424] = "+2 Healing and Spell Damage",
	[425] = "ZZOLD +4 Healing and Spell Damage",
	[426] = "+5 Healing and Spell Damage",
	[427] = "+6 Healing and Spell Damage",
	[428] = "+7 Healing and Spell Damage",
	[429] = "+8 Healing and Spell Damage",
	[430] = "+9 Healing and Spell Damage",
	[431] = "+11 Healing and Spell Damage",
	[432] = "+12 Healing and Spell Damage",
	[433] = "+11 Fire Spell Damage",
	[434] = "+13 Fire Spell Damage",
	[435] = "+14 Fire Spell Damage",
	[436] = "+70 Critical Strike Rating",
	[437] = "+11 Frost Spell Damage",
	[438] = "+13 Frost Spell Damage",
	[439] = "+14 Frost Spell Damage",
	[440] = "+12 Healing",
	[441] = "+20 Healing and +7 Spell Damage",
	[442] = "+22 Healing",
	[443] = "+11 Nature Spell Damage",
	[444] = "+13 Nature Spell Damage",
	[445] = "+14 Nature Spell Damage",
	[446] = "+11 Shadow Spell Damage",
	[447] = "+13 Shadow Spell Damage",
	[448] = "+14 Shadow Spell Damage",
	[463] = "Mithril Spike (16-20)",
	[464] = "+4% Mount Speed",
	[483] = "Sharpened (+6 Damage)",
	[484] = "Weighted (+6 Damage)",
	[503] = "Rockbiter 4",
	[504] = "+80 Rockbiter",
	[523] = "Flametongue 4",
	[524] = "Frostbrand 3",
	[525] = "Windfury 3",
	[543] = "Flametongue Totem 3",
	[563] = "Windfury Totem 2",
	[564] = "Windfury Totem 3",
	[583] = "+1 Agility / +1 Spirit",
	[584] = "+1 Agility / +1 Intellect",
	[585] = "+1 Agility / +1 Stamina",
	[586] = "+1 Agility / +1 Strength",
	[587] = "+1 Intellect / +1 Spirit",
	[588] = "+1 Intellect / +1 Stamina",
	[589] = "+1 Intellect / +1 Strength",
	[590] = "+1 Spirit / +1 Stamina",
	[591] = "+1 Spirit / +1 Strength",
	[592] = "+1 Stamina / +1 Strength",
	[603] = "Crippling Poison II",
	[623] = "Instant Poison IV",
	[624] = "Instant Poison V",
	[625] = "Instant Poison VI",
	[626] = "Deadly Poison III",
	[627] = "Deadly Poison IV",
	[643] = "Mind-Numbing Poison III",
	[663] = "Scope (+5 Damage)",
	[664] = "Scope (+7 Damage)",
	[683] = "Rockbiter 6",
	[684] = "+15 Strength",
	[703] = "Wound Poison",
	[704] = "Wound Poison II",
	[705] = "Wound Poison III",
	[706] = "Wound Poison IV",
	[723] = "+3 Intellect",
	[724] = "+3 Stamina",
	[743] = "+2 Stealth",
	[744] = "+20 Armor",
	[763] = "+5 Shield Block Rating",
	[783] = "+10 Armor",
	[803] = "Fiery Weapon",
	[804] = "+10 Shadow Resistance",
	[805] = "+4 Weapon Damage",
	[823] = "+3 Strength",
	[843] = "+30 Mana",
	[844] = "+2 Mining",
	[845] = "+2 Herbalism",
	[846] = "+2 Fishing",
	[847] = "+1 All Stats",
	[848] = "+30 Armor",
	[849] = "+3 Agility",
	[850] = "+35 Health",
	[851] = "+5 Spirit",
	[852] = "+5 Stamina",
	[853] = "+6 Beastslaying",
	[854] = "+6 Elemental Slayer",
	[855] = "+5 Fire Resistance",
	[856] = "+5 Strength",
	[857] = "+50 Mana",
	[863] = "+10 Shield Block Rating",
	[864] = "+4 Weapon Damage",
	[865] = "+5 Skinning",
	[866] = "+2 All Stats",
	[883] = "+15 Agility",
	[884] = "+50 Armor",
	[903] = "+3 All Resistances",
	[904] = "+5 Agility",
	[905] = "+5 Intellect",
	[906] = "+5 Mining",
	[907] = "+7 Spirit",
	[908] = "+50 Health",
	[909] = "+5 Herbalism",
	[910] = "Increased Stealth",
	[911] = "Minor Speed Increase",
	[912] = "Demonslaying",
	[913] = "+65 Mana",
	[923] = "+5 Defense Rating",
	[924] = "+2 Defense Rating",
	[925] = "+3 Defense Rating",
	[926] = "+8 Frost Resistance",
	[927] = "+7 Strength",
	[928] = "+3 All Stats",
	[929] = "+7 Stamina",
	[930] = "+2% Mount Speed",
	[931] = "+10 Haste Rating",
	[943] = "+3 Weapon Damage",
	[963] = "+7 Weapon Damage",
	[983] = "+16 Agility",
	[1003] = "Venomhide Poison",
	[1023] = "Feedback 1",
	[1043] = "+16 Strength",
	[1044] = "+17 Strength",
	[1045] = "+18 Strength",
	[1046] = "+19 Strength",
	[1047] = "+20 Strength",
	[1048] = "+21 Strength",
	[1049] = "+22 Strength",
	[1050] = "+23 Strength",
	[1051] = "+24 Strength",
	[1052] = "+25 Strength",
	[1053] = "+26 Strength",
	[1054] = "+27 Strength",
	[1055] = "+28 Strength",
	[1056] = "+29 Strength",
	[1057] = "+30 Strength",
	[1058] = "+31 Strength",
	[1059] = "+32 Strength",
	[1060] = "+33 Strength",
	[1061] = "+34 Strength",
	[1062] = "+35 Strength",
	[1063] = "+36 Strength",
	[1064] = "+37 Strength",
	[1065] = "+38 Strength",
	[1066] = "+39 Strength",
	[1067] = "+40 Strength",
	[1068] = "+15 Stamina",
	[1069] = "+16 Stamina",
	[1070] = "+17 Stamina",
	[1071] = "+18 Stamina",
	[1072] = "+19 Stamina",
	[1073] = "+20 Stamina",
	[1074] = "+21 Stamina",
	[1075] = "+22 Stamina",
	[1076] = "+23 Stamina",
	[1077] = "+24 Stamina",
	[1078] = "+25 Stamina",
	[1079] = "+26 Stamina",
	[1080] = "+27 Stamina",
	[1081] = "+28 Stamina",
	[1082] = "+29 Stamina",
	[1083] = "+30 Stamina",
	[1084] = "+31 Stamina",
	[1085] = "+32 Stamina",
	[1086] = "+33 Stamina",
	[1087] = "+34 Stamina",
	[1088] = "+35 Stamina",
	[1089] = "+36 Stamina",
	[1090] = "+37 Stamina",
	[1091] = "+38 Stamina",
	[1092] = "+39 Stamina",
	[1093] = "+40 Stamina",
	[1094] = "+17 Agility",
	[1095] = "+18 Agility",
	[1096] = "+19 Agility",
	[1097] = "+20 Agility",
	[1098] = "+21 Agility",
	[1099] = "+22 Agility",
	[1100] = "+23 Agility",
	[1101] = "+24 Agility",
	[1102] = "+25 Agility",
	[1103] = "+26 Agility",
	[1104] = "+27 Agility",
	[1105] = "+28 Agility",
	[1106] = "+29 Agility",
	[1107] = "+30 Agility",
	[1108] = "+31 Agility",
	[1109] = "+32 Agility",
	[1110] = "+33 Agility",
	[1111] = "+34 Agility",
	[1112] = "+35 Agility",
	[1113] = "+36 Agility",
	[1114] = "+37 Agility",
	[1115] = "+38 Agility",
	[1116] = "+39 Agility",
	[1117] = "+40 Agility",
	[1118] = "+15 Intellect",
	[1119] = "+16 Intellect",
	[1120] = "+17 Intellect",
	[1121] = "+18 Intellect",
	[1122] = "+19 Intellect",
	[1123] = "+20 Intellect",
	[1124] = "+21 Intellect",
	[1125] = "+22 Intellect",
	[1126] = "+23 Intellect",
	[1127] = "+24 Intellect",
	[1128] = "+25 Intellect",
	[1129] = "+26 Intellect",
	[1130] = "+27 Intellect",
	[1131] = "+28 Intellect",
	[1132] = "+29 Intellect",
	[1133] = "+30 Intellect",
	[1134] = "+31 Intellect",
	[1135] = "+32 Intellect",
	[1136] = "+33 Intellect",
	[1137] = "+34 Intellect",
	[1138] = "+35 Intellect",
	[1139] = "+36 Intellect",
	[1140] = "+37 Intellect",
	[1141] = "+38 Intellect",
	[1142] = "+39 Intellect",
	[1143] = "+40 Intellect",
	[1144] = "+15 Spirit",
	[1145] = "+16 Spirit",
	[1146] = "+17 Spirit",
	[1147] = "+18 Spirit",
	[1148] = "+19 Spirit",
	[1149] = "+20 Spirit",
	[1150] = "+21 Spirit",
	[1151] = "+22 Spirit",
	[1152] = "+23 Spirit",
	[1153] = "+24 Spirit",
	[1154] = "+25 Spirit",
	[1155] = "+26 Spirit",
	[1156] = "+27 Spirit",
	[1157] = "+28 Spirit",
	[1158] = "+29 Spirit",
	[1159] = "+30 Spirit",
	[1160] = "+31 Spirit",
	[1161] = "+32 Spirit",
	[1162] = "+33 Spirit",
	[1163] = "+34 Spirit",
	[1164] = "+36 Spirit",
	[1165] = "+37 Spirit",
	[1166] = "+38 Spirit",
	[1167] = "+39 Spirit",
	[1168] = "+40 Spirit",
	[1183] = "+35 Spirit",
	[1203] = "+41 Strength",
	[1204] = "+42 Strength",
	[1205] = "+43 Strength",
	[1206] = "+44 Strength",
	[1207] = "+45 Strength",
	[1208] = "+46 Strength",
	[1209] = "+41 Stamina",
	[1210] = "+42 Stamina",
	[1211] = "+43 Stamina",
	[1212] = "+44 Stamina",
	[1213] = "+45 Stamina",
	[1214] = "+46 Stamina",
	[1215] = "+41 Agility",
	[1216] = "+42 Agility",
	[1217] = "+43 Agility",
	[1218] = "+44 Agility",
	[1219] = "+45 Agility",
	[1220] = "+46 Agility",
	[1221] = "+41 Intellect",
	[1222] = "+42 Intellect",
	[1223] = "+43 Intellect",
	[1224] = "+44 Intellect",
	[1225] = "+45 Intellect",
	[1226] = "+46 Intellect",
	[1227] = "+41 Spirit",
	[1228] = "+42 Spirit",
	[1229] = "+43 Spirit",
	[1230] = "+44 Spirit",
	[1231] = "+45 Spirit",
	[1232] = "+46 Spirit",
	[1243] = "+1 Arcane Resistance",
	[1244] = "+2 Arcane Resistance",
	[1245] = "+3 Arcane Resistance",
	[1246] = "+4 Arcane Resistance",
	[1247] = "+5 Arcane Resistance",
	[1248] = "+6 Arcane Resistance",
	[1249] = "+7 Arcane Resistance",
	[1250] = "+8 Arcane Resistance",
	[1251] = "+9 Arcane Resistance",
	[1252] = "+10 Arcane Resistance",
	[1253] = "+11 Arcane Resistance",
	[1254] = "+12 Arcane Resistance",
	[1255] = "+13 Arcane Resistance",
	[1256] = "+14 Arcane Resistance",
	[1257] = "+15 Arcane Resistance",
	[1258] = "+16 Arcane Resistance",
	[1259] = "+17 Arcane Resistance",
	[1260] = "+18 Arcane Resistance",
	[1261] = "+19 Arcane Resistance",
	[1262] = "+20 Arcane Resistance",
	[1263] = "+21 Arcane Resistance",
	[1264] = "+22 Arcane Resistance",
	[1265] = "+23 Arcane Resistance",
	[1266] = "+24 Arcane Resistance",
	[1267] = "+25 Arcane Resistance",
	[1268] = "+26 Arcane Resistance",
	[1269] = "+27 Arcane Resistance",
	[1270] = "+28 Arcane Resistance",
	[1271] = "+29 Arcane Resistance",
	[1272] = "+30 Arcane Resistance",
	[1273] = "+31 Arcane Resistance",
	[1274] = "+32 Arcane Resistance",
	[1275] = "+33 Arcane Resistance",
	[1276] = "+34 Arcane Resistance",
	[1277] = "+35 Arcane Resistance",
	[1278] = "+36 Arcane Resistance",
	[1279] = "+37 Arcane Resistance",
	[1280] = "+38 Arcane Resistance",
	[1281] = "+39 Arcane Resistance",
	[1282] = "+40 Arcane Resistance",
	[1283] = "+41 Arcane Resistance",
	[1284] = "+42 Arcane Resistance",
	[1285] = "+43 Arcane Resistance",
	[1286] = "+44 Arcane Resistance",
	[1287] = "+45 Arcane Resistance",
	[1288] = "+46 Arcane Resistance",
	[1289] = "+1 Frost Resistance",
	[1290] = "+2 Frost Resistance",
	[1291] = "+3 Frost Resistance",
	[1292] = "+4 Frost Resistance",
	[1293] = "+5 Frost Resistance",
	[1294] = "+6 Frost Resistance",
	[1295] = "+7 Frost Resistance",
	[1296] = "+8 Frost Resistance",
	[1297] = "+9 Frost Resistance",
	[1298] = "+10 Frost Resistance",
	[1299] = "+11 Frost Resistance",
	[1300] = "+12 Frost Resistance",
	[1301] = "+13 Frost Resistance",
	[1302] = "+14 Frost Resistance",
	[1303] = "+15 Frost Resistance",
	[1304] = "+16 Frost Resistance",
	[1305] = "+17 Frost Resistance",
	[1306] = "+18 Frost Resistance",
	[1307] = "+19 Frost Resistance",
	[1308] = "+20 Frost Resistance",
	[1309] = "+21 Frost Resistance",
	[1310] = "+22 Frost Resistance",
	[1311] = "+23 Frost Resistance",
	[1312] = "+24 Frost Resistance",
	[1313] = "+25 Frost Resistance",
	[1314] = "+26 Frost Resistance",
	[1315] = "+27 Frost Resistance",
	[1316] = "+28 Frost Resistance",
	[1317] = "+29 Frost Resistance",
	[1318] = "+30 Frost Resistance",
	[1319] = "+31 Frost Resistance",
	[1320] = "+32 Frost Resistance",
	[1321] = "+33 Frost Resistance",
	[1322] = "+34 Frost Resistance",
	[1323] = "+35 Frost Resistance",
	[1324] = "+36 Frost Resistance",
	[1325] = "+37 Frost Resistance",
	[1326] = "+38 Frost Resistance",
	[1327] = "+39 Frost Resistance",
	[1328] = "+40 Frost Resistance",
	[1329] = "+41 Frost Resistance",
	[1330] = "+42 Frost Resistance",
	[1331] = "+43 Frost Resistance",
	[1332] = "+44 Frost Resistance",
	[1333] = "+45 Frost Resistance",
	[1334] = "+46 Frost Resistance",
	[1335] = "+1 Fire Resistance",
	[1336] = "+2 Fire Resistance",
	[1337] = "+3 Fire Resistance",
	[1338] = "+4 Fire Resistance",
	[1339] = "+5 Fire Resistance",
	[1340] = "+6 Fire Resistance",
	[1341] = "+7 Fire Resistance",
	[1342] = "+8 Fire Resistance",
	[1343] = "+9 Fire Resistance",
	[1344] = "+10 Fire Resistance",
	[1345] = "+11 Fire Resistance",
	[1346] = "+12 Fire Resistance",
	[1347] = "+13 Fire Resistance",
	[1348] = "+14 Fire Resistance",
	[1349] = "+15 Fire Resistance",
	[1350] = "+16 Fire Resistance",
	[1351] = "+17 Fire Resistance",
	[1352] = "+18 Fire Resistance",
	[1353] = "+19 Fire Resistance",
	[1354] = "+20 Fire Resistance",
	[1355] = "+21 Fire Resistance",
	[1356] = "+22 Fire Resistance",
	[1357] = "+23 Fire Resistance",
	[1358] = "+24 Fire Resistance",
	[1359] = "+25 Fire Resistance",
	[1360] = "+26 Fire Resistance",
	[1361] = "+27 Fire Resistance",
	[1362] = "+28 Fire Resistance",
	[1363] = "+29 Fire Resistance",
	[1364] = "+30 Fire Resistance",
	[1365] = "+31 Fire Resistance",
	[1366] = "+32 Fire Resistance",
	[1367] = "+33 Fire Resistance",
	[1368] = "+34 Fire Resistance",
	[1369] = "+35 Fire Resistance",
	[1370] = "+36 Fire Resistance",
	[1371] = "+37 Fire Resistance",
	[1372] = "+38 Fire Resistance",
	[1373] = "+39 Fire Resistance",
	[1374] = "+40 Fire Resistance",
	[1375] = "+41 Fire Resistance",
	[1376] = "+42 Fire Resistance",
	[1377] = "+43 Fire Resistance",
	[1378] = "+44 Fire Resistance",
	[1379] = "+45 Fire Resistance",
	[1380] = "+46 Fire Resistance",
	[1381] = "+1 Nature Resistance",
	[1382] = "+2 Nature Resistance",
	[1383] = "+3 Nature Resistance",
	[1384] = "+4 Nature Resistance",
	[1385] = "+5 Nature Resistance",
	[1386] = "+6 Nature Resistance",
	[1387] = "+7 Nature Resistance",
	[1388] = "+8 Nature Resistance",
	[1389] = "+9 Nature Resistance",
	[1390] = "+10 Nature Resistance",
	[1391] = "+11 Nature Resistance",
	[1392] = "+12 Nature Resistance",
	[1393] = "+13 Nature Resistance",
	[1394] = "+14 Nature Resistance",
	[1395] = "+15 Nature Resistance",
	[1396] = "+16 Nature Resistance",
	[1397] = "+17 Nature Resistance",
	[1398] = "+18 Nature Resistance",
	[1399] = "+19 Nature Resistance",
	[1400] = "+20 Nature Resistance",
	[1401] = "+21 Nature Resistance",
	[1402] = "+22 Nature Resistance",
	[1403] = "+23 Nature Resistance",
	[1404] = "+24 Nature Resistance",
	[1405] = "+25 Nature Resistance",
	[1406] = "+26 Nature Resistance",
	[1407] = "+27 Nature Resistance",
	[1408] = "+28 Nature Resistance",
	[1409] = "+29 Nature Resistance",
	[1410] = "+30 Nature Resistance",
	[1411] = "+31 Nature Resistance",
	[1412] = "+32 Nature Resistance",
	[1413] = "+33 Nature Resistance",
	[1414] = "+34 Nature Resistance",
	[1415] = "+35 Nature Resistance",
	[1416] = "+36 Nature Resistance",
	[1417] = "+37 Nature Resistance",
	[1418] = "+38 Nature Resistance",
	[1419] = "+39 Nature Resistance",
	[1420] = "+40 Nature Resistance",
	[1421] = "+41 Nature Resistance",
	[1422] = "+42 Nature Resistance",
	[1423] = "+43 Nature Resistance",
	[1424] = "+44 Nature Resistance",
	[1425] = "+45 Nature Resistance",
	[1426] = "+46 Nature Resistance",
	[1427] = "+1 Shadow Resistance",
	[1428] = "+2 Shadow Resistance",
	[1429] = "+3 Shadow Resistance",
	[1430] = "+4 Shadow Resistance",
	[1431] = "+5 Shadow Resistance",
	[1432] = "+6 Shadow Resistance",
	[1433] = "+7 Shadow Resistance",
	[1434] = "+8 Shadow Resistance",
	[1435] = "+9 Shadow Resistance",
	[1436] = "+10 Shadow Resistance",
	[1437] = "+11 Shadow Resistance",
	[1438] = "+12 Shadow Resistance",
	[1439] = "+13 Shadow Resistance",
	[1440] = "+14 Shadow Resistance",
	[1441] = "+15 Shadow Resistance",
	[1442] = "+16 Shadow Resistance",
	[1443] = "+17 Shadow Resistance",
	[1444] = "+18 Shadow Resistance",
	[1445] = "+19 Shadow Resistance",
	[1446] = "+20 Shadow Resistance",
	[1447] = "+21 Shadow Resistance",
	[1448] = "+22 Shadow Resistance",
	[1449] = "+23 Shadow Resistance",
	[1450] = "+24 Shadow Resistance",
	[1451] = "+25 Shadow Resistance",
	[1452] = "+26 Resist Shadow",
	[1453] = "+27 Shadow Resistance",
	[1454] = "+28 Shadow Resistance",
	[1455] = "+29 Shadow Resistance",
	[1456] = "+30 Shadow Resistance",
	[1457] = "+31 Shadow Resistance",
	[1458] = "+32 Shadow Resistance",
	[1459] = "+33 Shadow Resistance",
	[1460] = "+34 Shadow Resistance",
	[1461] = "+35 Shadow Resistance",
	[1462] = "+36 Shadow Resistance",
	[1463] = "+37 Shadow Resistance",
	[1464] = "+38 Shadow Resistance",
	[1465] = "+39 Shadow Resistance",
	[1466] = "+40 Shadow Resistance",
	[1467] = "+41 Shadow Resistance",
	[1468] = "+42 Shadow Resistance",
	[1469] = "+43 Shadow Resistance",
	[1470] = "+44 Shadow Resistance",
	[1471] = "+45 Shadow Resistance",
	[1472] = "+46 Shadow Resistance",
	[1483] = "+150 Mana",
	[1503] = "+100 HP",
	[1504] = "+125 Armor",
	[1505] = "+20 Fire Resistance",
	[1506] = "+8 Strength",
	[1507] = "+8 Stamina",
	[1508] = "+8 Agility",
	[1509] = "+8 Intellect",
	[1510] = "+8 Spirit",
	[1523] = "+85/14 MANA/FR",
	[1524] = "+75/14 HP/FR",
	[1525] = "+110/14 AC/FR",
	[1526] = "+10/14 STR/FR",
	[1527] = "+10/14 STA/FR",
	[1528] = "+10/14 AGI/FR",
	[1529] = "+10/14 INT/FR",
	[1530] = "+10/14 SPI/FR",
	[1531] = "+10/10 STR/STA",
	[1532] = "+10/10/110/15 STR/STA/AC/FR",
	[1543] = "+10/10/100/15 INT/SPI/MANA/FR",
	[1563] = "+2 Attack Power",
	[1583] = "+4 Attack Power",
	[1584] = "+6 Attack Power",
	[1585] = "+8 Attack Power",
	[1586] = "+10 Attack Power",
	[1587] = "+12 Attack Power",
	[1588] = "+14 Attack Power",
	[1589] = "+16 Attack Power",
	[1590] = "+18 Attack Power",
	[1591] = "+20 Attack Power",
	[1592] = "+22 Attack Power",
	[1593] = "+24 Attack Power",
	[1594] = "+26 Attack Power",
	[1595] = "+28 Attack Power",
	[1596] = "+30 Attack Power",
	[1597] = "+32 Attack Power",
	[1598] = "+34 Attack Power",
	[1599] = "+36 Attack Power",
	[1600] = "+38 Attack Power",
	[1601] = "+40 Attack Power",
	[1602] = "+42 Attack Power",
	[1603] = "+44 Attack Power",
	[1604] = "+46 Attack Power",
	[1605] = "+48 Attack Power",
	[1606] = "+50 Attack Power",
	[1607] = "+52 Attack Power",
	[1608] = "+54 Attack Power",
	[1609] = "+56 Attack Power",
	[1610] = "+58 Attack Power",
	[1611] = "+60 Attack Power",
	[1612] = "+62 Attack Power",
	[1613] = "+64 Attack Power",
	[1614] = "+66 Attack Power",
	[1615] = "+68 Attack Power",
	[1616] = "+70 Attack Power",
	[1617] = "+72 Attack Power",
	[1618] = "+74 Attack Power",
	[1619] = "+76 Attack Power",
	[1620] = "+78 Attack Power",
	[1621] = "+80 Attack Power",
	[1622] = "+82 Attack Power",
	[1623] = "+84 Attack Power",
	[1624] = "+86 Attack Power",
	[1625] = "+88 Attack Power",
	[1626] = "+90 Attack Power",
	[1627] = "+92 Attack Power",
	[1643] = "Sharpened (+8 Damage)",
	[1663] = "Rockbiter 5",
	[1664] = "Rockbiter 7",
	[1665] = "Flametongue 5",
	[1666] = "Flametongue 6",
	[1667] = "Frostbrand 4",
	[1668] = "Frostbrand 5",
	[1669] = "Windfury 4",
	[1683] = "Flametongue Totem 4",
	[1703] = "Weighted (+8 Damage)",
	[1704] = "Thorium Spike (20-30)",
	[1723] = "Omen of Clarity",
	[1743] = "MHTest02",
	[1763] = "Cold Blood",
	[1783] = "Windfury Totem 1",
	[1803] = "Firestone 1",
	[1823] = "Firestone 2",
	[1824] = "Firestone 3",
	[1825] = "Firestone 4",
	[1843] = "Reinforced (+40 Armor)",
	[1863] = "Feedback 2",
	[1864] = "Feedback 3",
	[1865] = "Feedback 4",
	[1866] = "Feedback 5",
	[1883] = "+7 Intellect",
	[1884] = "+9 Spirit",
	[1885] = "+9 Strength",
	[1886] = "+9 Stamina",
	[1887] = "+7 Agility",
	[1888] = "+5 All Resistances",
	[1889] = "+70 Armor",
	[1890] = "+9 Spirit",
	[1891] = "+4 All Stats",
	[1892] = "+100 Health",
	[1893] = "+100 Mana",
	[1894] = "Icy Weapon",
	[1895] = "+9 Damage",
	[1896] = "+9 Weapon Damage",
	[1897] = "+5 Weapon Damage",
	[1898] = "Lifestealing",
	[1899] = "Unholy Weapon",
	[1900] = "Crusader",
	[1901] = "+9 Intellect",
	[1903] = "+9 Spirit",
	[1904] = "+9 Intellect",
	[1923] = "+3 Fire Resistance",
	[1943] = "+12 Defense Rating",
	[1944] = "+8 Defense Rating",
	[1945] = "+9 Defense Rating",
	[1946] = "+10 Defense Rating",
	[1947] = "+11 Defense Rating",
	[1948] = "+13 Defense Rating",
	[1949] = "+14 Defense Rating",
	[1950] = "+15 Defense Rating",
	[1951] = "+16 Defense Rating",
	[1952] = "+20 Defense Rating",
	[1953] = "+22 Defense Rating",
	[1954] = "+25 Defense Rating",
	[1955] = "+32 Defense Rating",
	[1956] = "+17 Defense Rating",
	[1957] = "+18 Defense Rating",
	[1958] = "+19 Defense Rating",
	[1959] = "+21 Defense Rating",
	[1960] = "+23 Defense Rating",
	[1961] = "+24 Defense Rating",
	[1962] = "+26 Defense Rating",
	[1963] = "+27 Defense Rating",
	[1964] = "+28 Defense Rating",
	[1965] = "+29 Defense Rating",
	[1966] = "+30 Defense Rating",
	[1967] = "+31 Defense Rating",
	[1968] = "+33 Defense Rating",
	[1969] = "+34 Defense Rating",
	[1970] = "+35 Defense Rating",
	[1971] = "+36 Defense Rating",
	[1972] = "+37 Defense Rating",
	[1973] = "+38 Defense Rating",
	[1983] = "+5 Block Rating",
	[1984] = "+10 Block Rating",
	[1985] = "+15 Block Rating",
	[1986] = "+20 Block Rating",
	[1987] = "Block Level 14",
	[1988] = "Block Level 15",
	[1989] = "Block Level 16",
	[1990] = "Block Level 17",
	[1991] = "Block Level 18",
	[1992] = "Block Level 19",
	[1993] = "Block Level 20",
	[1994] = "Block Level 21",
	[1995] = "Block Level 22",
	[1996] = "Block Level 23",
	[1997] = "Block Level 24",
	[1998] = "Block Level 25",
	[1999] = "Block Level 26",
	[2000] = "Block Level 27",
	[2001] = "Block Level 28",
	[2002] = "Block Level 29",
	[2003] = "Block Level 30",
	[2004] = "Block Level 31",
	[2005] = "Block Level 32",
	[2006] = "Block Level 33",
	[2007] = "Block Level 34",
	[2008] = "Block Level 35",
	[2009] = "Block Level 36",
	[2010] = "Block Level 37",
	[2011] = "Block Level 38",
	[2012] = "Block Level 39",
	[2013] = "Block Level 40",
	[2014] = "Block Level 41",
	[2015] = "Block Level 42",
	[2016] = "Block Level 43",
	[2017] = "Block Level 44",
	[2018] = "Block Level 45",
	[2019] = "Block Level 46",
	[2020] = "Block Level 47",
	[2021] = "Block Level 48",
	[2022] = "Block Level 49",
	[2023] = "Block Level 50",
	[2024] = "Block Level 51",
	[2025] = "Block Level 52",
	[2026] = "Block Level 53",
	[2027] = "Block Level 54",
	[2028] = "Block Level 55",
	[2029] = "Block Level 56",
	[2030] = "Block Level 57",
	[2031] = "Block Level 58",
	[2032] = "Block Level 59",
	[2033] = "Block Level 60",
	[2034] = "Block Level 61",
	[2035] = "Block Level 62",
	[2036] = "Block Level 63",
	[2037] = "Block Level 64",
	[2038] = "Block Level 65",
	[2039] = "Block Level 66",
	[2040] = "+2 Ranged Attack Power",
	[2041] = "+5 Ranged Attack Power",
	[2042] = "+7 Ranged Attack Power",
	[2043] = "+10 Ranged Attack Power",
	[2044] = "+12 Ranged Attack Power",
	[2045] = "+14 Ranged Attack Power",
	[2046] = "+17 Ranged Attack Power",
	[2047] = "+19 Ranged Attack Power",
	[2048] = "+22 Ranged Attack Power",
	[2049] = "+24 Ranged Attack Power",
	[2050] = "+26 Ranged Attack Power",
	[2051] = "+29 Ranged Attack Power",
	[2052] = "+31 Ranged Attack Power",
	[2053] = "+34 Ranged Attack Power",
	[2054] = "+36 Ranged Attack Power",
	[2055] = "+38 Ranged Attack Power",
	[2056] = "+41 Ranged Attack Power",
	[2057] = "+43 Ranged Attack Power",
	[2058] = "+46 Ranged Attack Power",
	[2059] = "+48 Ranged Attack Power",
	[2060] = "+50 Ranged Attack Power",
	[2061] = "+53 Ranged Attack Power",
	[2062] = "+55 Ranged Attack Power",
	[2063] = "+58 Ranged Attack Power",
	[2064] = "+60 Ranged Attack Power",
	[2065] = "+62 Ranged Attack Power",
	[2066] = "+65 Ranged Attack Power",
	[2067] = "+67 Ranged Attack Power",
	[2068] = "+70 Ranged Attack Power",
	[2069] = "+72 Ranged Attack Power",
	[2070] = "+74 Ranged Attack Power",
	[2071] = "+77 Ranged Attack Power",
	[2072] = "+79 Ranged Attack Power",
	[2073] = "+82 Ranged Attack Power",
	[2074] = "+84 Ranged Attack Power",
	[2075] = "+86 Ranged Attack Power",
	[2076] = "+89 Ranged Attack Power",
	[2077] = "+91 Ranged Attack Power",
	[2078] = "+12 Dodge Rating",
	[2079] = "+1 Arcane Spell Damage",
	[2080] = "+3 Arcane Spell Damage",
	[2081] = "+4 Arcane Spell Damage",
	[2082] = "+6 Arcane Spell Damage",
	[2083] = "+7 Arcane Spell Damage",
	[2084] = "+9 Arcane Spell Damage",
	[2085] = "+10 Arcane Spell Damage",
	[2086] = "+11 Arcane Spell Damage",
	[2087] = "+13 Arcane Spell Damage",
	[2088] = "+14 Arcane Spell Damage",
	[2089] = "+16 Arcane Spell Damage",
	[2090] = "+17 Arcane Spell Damage",
	[2091] = "+19 Arcane Spell Damage",
	[2092] = "+20 Arcane Spell Damage",
	[2093] = "+21 Arcane Spell Damage",
	[2094] = "+23 Arcane Spell Damage",
	[2095] = "+24 Arcane Spell Damage",
	[2096] = "+26 Arcane Spell Damage",
	[2097] = "+27 Arcane Spell Damage",
	[2098] = "+29 Arcane Spell Damage",
	[2099] = "+30 Arcane Spell Damage",
	[2100] = "+31 Arcane Spell Damage",
	[2101] = "+33 Arcane Spell Damage",
	[2102] = "+34 Arcane Spell Damage",
	[2103] = "+36 Arcane Spell Damage",
	[2104] = "+37 Arcane Spell Damage",
	[2105] = "+39 Arcane Spell Damage",
	[2106] = "+40 Arcane Spell Damage",
	[2107] = "+41 Arcane Spell Damage",
	[2108] = "+43 Arcane Spell Damage",
	[2109] = "+44 Arcane Spell Damage",
	[2110] = "+46 Arcane Spell Damage",
	[2111] = "+47 Arcane Spell Damage",
	[2112] = "+49 Arcane Spell Damage",
	[2113] = "+50 Arcane Spell Damage",
	[2114] = "+51 Arcane Spell Damage",
	[2115] = "+53 Arcane Spell Damage",
	[2116] = "+54 Arcane Spell Damage",
	[2117] = "+1 Shadow Spell Damage",
	[2118] = "+3 Shadow Spell Damage",
	[2119] = "+4 Shadow Spell Damage",
	[2120] = "+6 Shadow Spell Damage",
	[2121] = "+7 Shadow Spell Damage",
	[2122] = "+9 Shadow Spell Damage",
	[2123] = "+10 Shadow Spell Damage",
	[2124] = "+11 Shadow Spell Damage",
	[2125] = "+13 Shadow Spell Damage",
	[2126] = "+14 Shadow Spell Damage",
	[2127] = "+16 Shadow Spell Damage",
	[2128] = "+17 Shadow Spell Damage",
	[2129] = "+19 Shadow Spell Damage",
	[2130] = "+20 Shadow Spell Damage",
	[2131] = "+21 Shadow Spell Damage",
	[2132] = "+23 Shadow Spell Damage",
	[2133] = "+24 Shadow Spell Damage",
	[2134] = "+26 Shadow Spell Damage",
	[2135] = "+27 Shadow Spell Damage",
	[2136] = "+29 Shadow Spell Damage",
	[2137] = "+30 Shadow Spell Damage",
	[2138] = "+31 Shadow Spell Damage",
	[2139] = "+33 Shadow Spell Damage",
	[2140] = "+34 Shadow Spell Damage",
	[2141] = "+36 Shadow Spell Damage",
	[2142] = "+37 Shadow Spell Damage",
	[2143] = "+39 Shadow Spell Damage",
	[2144] = "+40 Shadow Spell Damage",
	[2145] = "+41 Shadow Spell Damage",
	[2146] = "+43 Shadow Spell Damage",
	[2147] = "+44 Shadow Spell Damage",
	[2148] = "+46 Shadow Spell Damage",
	[2149] = "+47 Shadow Spell Damage",
	[2150] = "+49 Shadow Spell Damage",
	[2151] = "+50 Shadow Spell Damage",
	[2152] = "+51 Shadow Spell Damage",
	[2153] = "+53 Shadow Spell Damage",
	[2154] = "+54 Shadow Spell Damage",
	[2155] = "+1 Fire Spell Damage",
	[2156] = "+3 Fire Spell Damage",
	[2157] = "+4 Fire Spell Damage",
	[2158] = "+6 Fire Spell Damage",
	[2159] = "+7 Fire Spell Damage",
	[2160] = "+9 Fire Spell Damage",
	[2161] = "+10 Fire Spell Damage",
	[2162] = "+11 Fire Spell Damage",
	[2163] = "+13 Fire Spell Damage",
	[2164] = "+14 Fire Spell Damage",
	[2165] = "+16 Fire Spell Damage",
	[2166] = "+17 Fire Spell Damage",
	[2167] = "+19 Fire Spell Damage",
	[2168] = "+20 Fire Spell Damage",
	[2169] = "+21 Fire Spell Damage",
	[2170] = "+23 Fire Spell Damage",
	[2171] = "+24 Fire Spell Damage",
	[2172] = "+26 Fire Spell Damage",
	[2173] = "+27 Fire Spell Damage",
	[2174] = "+29 Fire Spell Damage",
	[2175] = "+30 Fire Spell Damage",
	[2176] = "+31 Fire Spell Damage",
	[2177] = "+33 Fire Spell Damage",
	[2178] = "+34 Fire Spell Damage",
	[2179] = "+36 Fire Spell Damage",
	[2180] = "+37 Fire Spell Damage",
	[2181] = "+39 Fire Spell Damage",
	[2182] = "+40 Fire Spell Damage",
	[2183] = "+41 Fire Spell Damage",
	[2184] = "+43 Fire Spell Damage",
	[2185] = "+44 Fire Spell Damage",
	[2186] = "+46 Fire Spell Damage",
	[2187] = "+47 Fire Spell Damage",
	[2188] = "+49 Fire Spell Damage",
	[2189] = "+50 Fire Spell Damage",
	[2190] = "+51 Fire Spell Damage",
	[2191] = "+53 Fire Spell Damage",
	[2192] = "+54 Fire Spell Damage",
	[2193] = "+1 Holy Spell Damage",
	[2194] = "+3 Holy Spell Damage",
	[2195] = "+4 Holy Spell Damage",
	[2196] = "+6 Holy Spell Damage",
	[2197] = "+7 Holy Spell Damage",
	[2198] = "+9 Holy Spell Damage",
	[2199] = "+10 Holy Spell Damage",
	[2200] = "+11 Holy Spell Damage",
	[2201] = "+13 Holy Spell Damage",
	[2202] = "+14 Holy Spell Damage",
	[2203] = "+16 Holy Spell Damage",
	[2204] = "+17 Holy Spell Damage",
	[2205] = "+19 Holy Spell Damage",
	[2206] = "+20 Holy Spell Damage",
	[2207] = "+21 Holy Spell Damage",
	[2208] = "+23 Holy Spell Damage",
	[2209] = "+24 Holy Spell Damage",
	[2210] = "+26 Holy Spell Damage",
	[2211] = "+27 Holy Spell Damage",
	[2212] = "+29 Holy Spell Damage",
	[2213] = "+30 Holy Spell Damage",
	[2214] = "+31 Holy Spell Damage",
	[2215] = "+33 Holy Spell Damage",
	[2216] = "+34 Holy Spell Damage",
	[2217] = "+36 Holy Spell Damage",
	[2218] = "+37 Holy Spell Damage",
	[2219] = "+39 Holy Spell Damage",
	[2220] = "+40 Holy Spell Damage",
	[2221] = "+41 Holy Spell Damage",
	[2222] = "+43 Holy Spell Damage",
	[2223] = "+44 Holy Spell Damage",
	[2224] = "+46 Holy Spell Damage",
	[2225] = "+47 Holy Spell Damage",
	[2226] = "+49 Holy Spell Damage",
	[2227] = "+50 Holy Spell Damage",
	[2228] = "+51 Holy Spell Damage",
	[2229] = "+53 Holy Spell Damage",
	[2230] = "+54 Holy Spell Damage",
	[2231] = "+1 Frost Spell Damage",
	[2232] = "+3 Frost Spell Damage",
	[2233] = "+4 Frost Spell Damage",
	[2234] = "+6 Frost Spell Damage",
	[2235] = "+7 Frost Spell Damage",
	[2236] = "+9 Frost Spell Damage",
	[2237] = "+10 Frost Spell Damage",
	[2238] = "+11 Frost Spell Damage",
	[2239] = "+13 Frost Spell Damage",
	[2240] = "+14 Frost Spell Damage",
	[2241] = "+16 Frost Spell Damage",
	[2242] = "+17 Frost Spell Damage",
	[2243] = "+19 Frost Spell Damage",
	[2244] = "+20 Frost Spell Damage",
	[2245] = "+21 Frost Spell Damage",
	[2246] = "+23 Frost Spell Damage",
	[2247] = "+24 Frost Spell Damage",
	[2248] = "+26 Frost Spell Damage",
	[2249] = "+27 Frost Spell Damage",
	[2250] = "+29 Frost Spell Damage",
	[2251] = "+30 Frost Spell Damage",
	[2252] = "+31 Frost Spell Damage",
	[2253] = "+33 Frost Spell Damage",
	[2254] = "+34 Frost Spell Damage",
	[2255] = "+36 Frost Spell Damage",
	[2256] = "+37 Frost Spell Damage",
	[2257] = "+39 Frost Spell Damage",
	[2258] = "+40 Frost Spell Damage",
	[2259] = "+41 Frost Spell Damage",
	[2260] = "+43 Frost Spell Damage",
	[2261] = "+44 Frost Spell Damage",
	[2262] = "+46 Frost Spell Damage",
	[2263] = "+47 Frost Spell Damage",
	[2264] = "+49 Frost Spell Damage",
	[2265] = "+50 Frost Spell Damage",
	[2266] = "+51 Frost Spell Damage",
	[2267] = "+53 Frost Spell Damage",
	[2268] = "+54 Frost Spell Damage",
	[2269] = "+1 Nature Spell Damage",
	[2270] = "+3 Nature Spell Damage",
	[2271] = "+4 Nature Spell Damage",
	[2272] = "+6 Nature Spell Damage",
	[2273] = "+7 Nature Spell Damage",
	[2274] = "+9 Nature Spell Damage",
	[2275] = "+10 Nature Spell Damage",
	[2276] = "+11 Nature Spell Damage",
	[2277] = "+13 Nature Spell Damage",
	[2278] = "+14 Nature Spell Damage",
	[2279] = "+16 Nature Spell Damage",
	[2280] = "+17 Nature Spell Damage",
	[2281] = "+19 Nature Spell Damage",
	[2282] = "+20 Nature Spell Damage",
	[2283] = "+21 Nature Spell Damage",
	[2284] = "+23 Nature Spell Damage",
	[2285] = "+24 Nature Spell Damage",
	[2286] = "+26 Nature Spell Damage",
	[2287] = "+27 Nature Spell Damage",
	[2288] = "+29 Nature Spell Damage",
	[2289] = "+30 Nature Spell Damage",
	[2290] = "+31 Nature Spell Damage",
	[2291] = "+33 Nature Spell Damage",
	[2292] = "+34 Nature Spell Damage",
	[2293] = "+36 Nature Spell Damage",
	[2294] = "+37 Nature Spell Damage",
	[2295] = "+39 Nature Spell Damage",
	[2296] = "+40 Nature Spell Damage",
	[2297] = "+41 Nature Spell Damage",
	[2298] = "+43 Nature Spell Damage",
	[2299] = "+44 Nature Spell Damage",
	[2300] = "+46 Nature Spell Damage",
	[2301] = "+47 Nature Spell Damage",
	[2302] = "+49 Nature Spell Damage",
	[2303] = "+50 Nature Spell Damage",
	[2304] = "+51 Nature Spell Damage",
	[2305] = "+53 Nature Spell Damage",
	[2306] = "+54 Nature Spell Damage",
	[2307] = "+2 Healing Spells and +1 Damage Spells",
	[2308] = "+4 Healing Spells and +2 Damage Spells",
	[2309] = "+7 Healing Spells and +3 Damage Spells",
	[2310] = "+9 Healing Spells and +3 Damage Spells",
	[2311] = "+11 Healing Spells and +4 Damage Spells",
	[2312] = "+13 Healing Spells and +5 Damage Spells",
	[2313] = "+15 Healing Spells and +5 Damage Spells",
	[2314] = "+18 Healing Spells and +6 Damage Spells",
	[2315] = "+20 Healing Spells and +7 Damage Spells",
	[2316] = "+22 Healing Spells and +8 Damage Spells",
	[2317] = "+24 Healing Spells and +8 Damage Spells",
	[2318] = "+26 Healing Spells and +9 Damage Spells",
	[2319] = "+29 Healing Spells and +10 Damage Spells",
	[2320] = "+31 Healing Spells and +11 Damage Spells",
	[2321] = "+33 Healing Spells and +11 Damage Spells",
	[2322] = "+35 Healing Spells and +12 Damage Spells",
	[2323] = "+37 Healing Spells and +13 Damage Spells",
	[2324] = "+40 Healing Spells and +14 Damage Spells",
	[2325] = "+42 Healing Spells and +14 Damage Spells",
	[2326] = "+44 Healing Spells and +15 Damage Spells",
	[2327] = "+46 Healing Spells and +16 Damage Spells",
	[2328] = "+48 Healing Spells and +16 Damage Spells",
	[2329] = "+51 Healing Spells and +17 Damage Spells",
	[2330] = "+53 Healing Spells and +18 Damage Spells",
	[2331] = "+55 Healing Spells and +19 Damage Spells",
	[2332] = "+57 Healing Spells and +19 Damage Spells",
	[2333] = "+59 Healing Spells and +20 Damage Spells",
	[2334] = "+62 Healing Spells and +21 Damage Spells",
	[2335] = "+64 Healing Spells and +22 Damage Spells",
	[2336] = "+66 Healing Spells and +22 Damage Spells",
	[2337] = "+68 Healing Spells and +23 Damage Spells",
	[2338] = "+70 Healing Spells and +24 Damage Spells",
	[2339] = "+73 Healing Spells and +25 Damage Spells",
	[2340] = "+75 Healing Spells and +25 Damage Spells",
	[2341] = "+77 Healing Spells and +26 Damage Spells",
	[2342] = "+79 Healing Spells and +27 Damage Spells",
	[2343] = "+81 Healing Spells and +27 Damage Spells",
	[2344] = "+84 Healing Spells and +28 Damage Spells",
	[2363] = "+1 mana every 5 sec.",
	[2364] = "+1 mana every 5 sec.",
	[2365] = "+1 mana every 5 sec.",
	[2366] = "+2 mana every 5 sec.",
	[2367] = "+2 mana every 5 sec.",
	[2368] = "+2 mana every 5 sec.",
	[2369] = "+3 mana every 5 sec.",
	[2370] = "+3 mana every 5 sec.",
	[2371] = "+4 mana every 5 sec.",
	[2372] = "+4 mana every 5 sec.",
	[2373] = "+4 mana every 5 sec.",
	[2374] = "+5 mana every 5 sec.",
	[2375] = "+5 mana every 5 sec.",
	[2376] = "+6 mana every 5 sec.",
	[2377] = "+6 mana every 5 sec.",
	[2378] = "+6 mana every 5 sec.",
	[2379] = "+7 mana every 5 sec.",
	[2380] = "+7 mana every 5 sec.",
	[2381] = "+8 mana every 5 sec.",
	[2382] = "+8 mana every 5 sec.",
	[2383] = "+8 mana every 5 sec.",
	[2384] = "+9 mana every 5 sec.",
	[2385] = "+9 mana every 5 sec.",
	[2386] = "+10 mana every 5 sec.",
	[2387] = "+10 mana every 5 sec.",
	[2388] = "+10 mana every 5 sec.",
	[2389] = "+11 mana every 5 sec.",
	[2390] = "+11 mana every 5 sec.",
	[2391] = "+12 mana every 5 sec.",
	[2392] = "+12 mana every 5 sec.",
	[2393] = "+12 mana every 5 sec.",
	[2394] = "+13 mana every 5 sec.",
	[2395] = "+13 mana every 5 sec.",
	[2396] = "+14 mana every 5 sec.",
	[2397] = "+14 mana every 5 sec.",
	[2398] = "+14 mana every 5 sec.",
	[2399] = "+15 mana every 5 sec.",
	[2400] = "+15 mana every 5 sec.",
	[2401] = "+1 health every 5 sec.",
	[2402] = "+1 health every 5 sec.",
	[2403] = "+1 health every 5 sec.",
	[2404] = "+1 health every 5 sec.",
	[2405] = "+1 health every 5 sec.",
	[2406] = "+2 health every 5 sec.",
	[2407] = "+2 health every 5 sec.",
	[2408] = "+2 health every 5 sec.",
	[2409] = "+2 health every 5 sec.",
	[2410] = "+3 health every 5 sec.",
	[2411] = "+3 health every 5 sec.",
	[2412] = "+3 health every 5 sec.",
	[2413] = "+3 health every 5 sec.",
	[2414] = "+4 health every 5 sec.",
	[2415] = "+4 health every 5 sec.",
	[2416] = "+4 health every 5 sec.",
	[2417] = "+4 health every 5 sec.",
	[2418] = "+5 health every 5 sec.",
	[2419] = "+5 health every 5 sec.",
	[2420] = "+5 health every 5 sec.",
	[2421] = "+5 health every 5 sec.",
	[2422] = "+6 health every 5 sec.",
	[2423] = "+6 health every 5 sec.",
	[2424] = "+6 health every 5 sec.",
	[2425] = "+6 health every 5 sec.",
	[2426] = "+7 health every 5 sec.",
	[2427] = "+7 health every 5 sec.",
	[2428] = "+7 health every 5 sec.",
	[2429] = "+7 health every 5 sec.",
	[2430] = "+8 health every 5 sec.",
	[2431] = "+8 health every 5 sec.",
	[2432] = "+8 health every 5 sec.",
	[2433] = "+8 health every 5 sec.",
	[2434] = "+9 health every 5 sec.",
	[2435] = "+9 health every 5 sec.",
	[2436] = "+9 health every 5 sec.",
	[2437] = "+9 health every 5 sec.",
	[2438] = "+10 health every 5 sec.",
	[2443] = "+7 Frost Spell Damage",
	[2463] = "+7 Fire Resistance",
	[2483] = "+5 Fire Resistance",
	[2484] = "+5 Frost Resistance",
	[2485] = "+5 Arcane Resistance",
	[2486] = "+5 Nature Resistance",
	[2487] = "+5 Shadow Resistance",
	[2488] = "+5 All Resistances",
	[2503] = "+5 Defense Rating",
	[2504] = "+30 Spell Damage",
	[2505] = "+55 Healing and +19 Spell Damage",
	[2506] = "+28 Critical Rating",
	[2523] = "+30 Hit Rating",
	[2543] = "+10 Haste Rating",
	[2544] = "+8 Healing and Spell Damage",
	[2545] = "+12 Dodge Rating",
	[2563] = "+15 Strength",
	[2564] = "+15 Agility",
	[2565] = "Mana Regen 4 per 5 sec.",
	[2566] = "+24 Healing and +8 Spell Damage",
	[2567] = "+20 Spirit",
	[2568] = "+22 Intellect",
	[2583] = "+10 Defense Rating/+10 Stamina/+15 Block Value",
	[2584] = "+7 Defense/+10 Stamina/+24 Healing Spells",
	[2585] = "+28 Attack Power/+12 Dodge Rating",
	[2586] = "+24 Ranged Attack Power/+10 Stamina/+10 Hit Rating",
	[2587] = "+13 Healing and Spell Damage/+15 Intellect",
	[2588] = "+18 Healing and Spell Damage/+8 Spell Hit",
	[2589] = "+18 Healing and Spell Damage/+10 Stamina",
	[2590] = "+4 Mana Regen/+10 Stamina/+24 Healing Spells",
	[2591] = "+10 Intellect/+10 Stamina/+24 Healing Spells",
	[2603] = "Eternium Line",
	[2604] = "+33 Healing Spells and +11 Damage Spells",
	[2605] = "+18 Spell Damage and Healing",
	[2606] = "+30 Attack Power",
	[2607] = "+12 Damage and Healing Spells",
	[2608] = "+13 Damage and Healing Spells",
	[2609] = "+15 Damage and Healing Spells",
	[2610] = "+14 Damage and Healing Spells",
	[2611] = "REUSE Random - 15 Spells All",
	[2612] = "+18 Damage and Healing Spells",
	[2613] = "+2% Threat",
	[2614] = "+20 Shadow Spell Damage",
	[2615] = "+20 Frost Spell Damage",
	[2616] = "+20 Fire Spell Damage",
	[2617] = "+30 Healing and +10 Spell Damage",
	[2618] = "+15 Agility",
	[2619] = "+15 Fire Resistance",
	[2620] = "+15 Nature Resistance",
	[2621] = "Subtlety",
	[2622] = "+12 Dodge Rating",
	[2623] = "Minor Wizard Oil",
	[2624] = "Minor Mana Oil",
	[2625] = "Lesser Mana Oil",
	[2626] = "Lesser Wizard Oil",
	[2627] = "Wizard Oil",
	[2628] = "Brilliant Wizard Oil",
	[2629] = "Brilliant Mana Oil",
	[2630] = "Deadly Poison V",
	[2631] = "Feedback 6",
	[2632] = "Rockbiter 8",
	[2633] = "Rockbiter 9",
	[2634] = "Flametongue 7",
	[2635] = "Frostbrand 6",
	[2636] = "Windfury 5",
	[2637] = "Flametongue Totem 5",
	[2638] = "Windfury Totem 4",
	[2639] = "Windfury Totem 5",
	[2640] = "Anesthetic Poison",
	[2641] = "Instant Poison VII",
	[2642] = "Deadly Poison VI",
	[2643] = "Deadly Poison VII",
	[2644] = "Wound Poison V",
	[2645] = "Firestone 5",
	[2646] = "+25 Agility",
	[2647] = "+12 Strength",
	[2648] = "+12 Defense Rating",
	[2649] = "+12 Stamina",
	[2650] = "+15 Spell Damage",
	[2651] = "+12 Spell Damage",
	[2652] = "+20 Healing and +7 Spell Damage",
	[2653] = "+18 Block Value",
	[2654] = "+12 Intellect",
	[2655] = "+15 Shield Block Rating",
	[2656] = "Vitality",
	[2657] = "+12 Agility",
	[2658] = "Surefooted",
	[2659] = "+150 Health",
	[2660] = "+150 Mana",
	[2661] = "+6 All Stats",
	[2662] = "+120 Armor",
	[2663] = "+7 Resist All",
	[2664] = "+7 Resist All",
	[2665] = "+35 Spirit",
	[2666] = "+30 Intellect",
	[2667] = "Savagery",
	[2668] = "+20 Strength",
	[2669] = "+40 Spell Damage",
	[2670] = "+35 Agility",
	[2671] = "Sunfire",
	[2672] = "Soulfrost",
	[2673] = "Mongoose",
	[2674] = "Spellsurge",
	[2675] = "Battlemaster",
	[2676] = "Superior Mana Oil",
	[2677] = "Superior Mana Oil",
	[2678] = "Superior Wizard Oil",
	[2679] = "6 Mana per 5 Sec.",
	[2680] = "+7 Resist All",
	[2681] = "+10 Nature Resistance",
	[2682] = "+10 Frost Resistance",
	[2683] = "+10 Shadow Resistance",
	[2684] = "+100 Attack Power vs Undead",
	[2685] = "+60 Spell Damage vs Undead",
	[2686] = "+8 Strength",
	[2687] = "+8 Agility",
	[2688] = "+8 Stamina",
	[2689] = "+8 mana every 5 sec.",
	[2690] = "+13 Healing and +5 Spell Damage",
	[2691] = "+6 Strength",
	[2692] = "+7 Spell Damage",
	[2693] = "+6 Agility",
	[2694] = "+6 Intellect",
	[2695] = "+6 Spell Critical Rating",
	[2696] = "+6 Defense Rating",
	[2697] = "+6 Hit Rating",
	[2698] = "+9 Stamina",
	[2699] = "+6 Spirit",
	[2700] = "+8 Spell Penetration",
	[2701] = "+2 Mana every 5 seconds",
	[2702] = "+12 Agility (2 Red Gems)",
	[2703] = "+4 Agility per different colored gem",
	[2704] = "+12 Strength if 4 blue gems equipped",
	[2705] = "+7 Healing +3 Spell Damage and +3 Intellect",
	[2706] = "+3 Defense Rating and +4 Stamina",
	[2707] = "+1 Mana every 5 Sec and +3 Intellect",
	[2708] = "+4 Spell Damage and +4 Stamina",
	[2709] = "+7 Healing +3 Spell Damage and +1 Mana per 5 Seconds",
	[2710] = "+3 Agility and +4 Stamina",
	[2711] = "+3 Strength and +4 Stamina",
	[2712] = "Sharpened (+12 Damage)",
	[2713] = "Sharpened (+14 Crit Rating and +12 Damage)",
	[2714] = "Felsteel Spike (26-38)",
	[2715] = "+31 Healing +11 Spell Damage and 5 mana per 5 sec.",
	[2716] = "+16 Stamina and +100 Armor",
	[2717] = "+26 Attack Power and +14 Critical Strike Rating",
	[2718] = "Lesser Rune of Warding",
	[2719] = "Lesser Ward of Shielding",
	[2720] = "Greater Ward of Shielding",
	[2721] = "+15 Spell Damage and +14 Spell Critical Rating",
	[2722] = "Scope (+10 Damage)",
	[2723] = "Scope (+12 Damage)",
	[2724] = "Scope (+28 Critical Strike Rating)",
	[2725] = "+8 Strength",
	[2726] = "+8 Agility",
	[2727] = "+18 Healing and +6 Spell Damage",
	[2728] = "+9 Spell Damage",
	[2729] = "+16 Attack Power",
	[2730] = "+8 Dodge Rating",
	[2731] = "+12 Stamina",
	[2732] = "+8 Spirit",
	[2733] = "+3 Mana every 5 seconds",
	[2734] = "+8 Intellect",
	[2735] = "+8 Critical Strike Rating",
	[2736] = "+8 Spell Critical Rating",
	[2737] = "+8 Defense Rating",
	[2738] = "+4 Strength and +6 Stamina",
	[2739] = "+4 Agility and +6 Stamina",
	[2740] = "+5 Spell Damage and +6 Stamina",
	[2741] = "+9 Healing +3 Spell Damage and +2 Mana every 5 seconds",
	[2742] = "+9 Healing +3 Spell Damage and +4 Intellect",
	[2743] = "+4 Defense Rating and +6 Stamina",
	[2744] = "+4 Intellect and +2 Mana every 5 seconds",
	[2745] = "+46 Healing +16 Spell Damage and +15 Stamina",
	[2746] = "+66 Healing +22 Spell Damage and +20 Stamina",
	[2747] = "+25 Spell Damage and +15 Stamina",
	[2748] = "+35 Spell Damage and +20 Stamina",
	[2749] = "+12 Intellect",
	[2750] = "6 mana per 5 sec.",
	[2751] = "+14 Critical Rating",
	[2752] = "+3 Critical Strike Rating and +3 Strength",
	[2753] = "+4 Critical Strike Rating and +4 Strength",
	[2754] = "+8 Parry Rating",
	[2755] = "+3 Hit Rating and +3 Agility",
	[2756] = "+4 Hit Rating and +4 Agility",
	[2757] = "+3 Critical Strike Rating and +4 Stamina",
	[2758] = "+4 Critical Strike Rating and +6 Stamina",
	[2759] = "+8 Resilience Rating",
	[2760] = "+3 Spell Critical Rating and +4 Spell Damage ",
	[2761] = "+4 Spell Critical Rating and +5 Spell Damage",
	[2762] = "+3 Spell Critical Rating and +4 Spell Penetration",
	[2763] = "+4 Spell Critical Rating and +5 Spell Penetration",
	[2764] = "+8 Hit Rating",
	[2765] = "+10 Spell Penetration",
	[2766] = "+8 Intellect",
	[2767] = "+8 Spell Hit Rating",
	[2768] = "+16 Spell Damage and Healing",
	[2769] = "+11 Hit Rating",
	[2770] = "+7 Spell Damage and Healing",
	[2771] = "+8 Spell Critical Strike Rating",
	[2772] = "+14 Critical Strike Rating",
	[2773] = "+16 Critical Strike Rating",
	[2774] = "+11 Intellect",
	[2775] = "+11 Spell Critical Rating",
	[2776] = "+3 Mana every 5 seconds",
	[2777] = "+13 Spirit",
	[2778] = "+13 Spell Penetration",
	[2779] = "+16 Spirit",
	[2780] = "+20 Spell Penetration",
	[2781] = "+19 Stamina",
	[2782] = "+10 Agility",
	[2783] = "+14 Hit Rating",
	[2784] = "+12 Hit Rating",
	[2785] = "+13 Hit Rating",
	[2786] = "+7 Hit Rating",
	[2787] = "+8 Critical Strike Rating",
	[2788] = "+9 Resilience",
	[2789] = "+15 Resilience",
	[2790] = "ZZOLDLesser Rune of Warding",
	[2791] = "Greater Rune of Warding",
	[2792] = "+8 Stamina",
	[2793] = "+8 Defense Rating",
	[2794] = "+3 Mana restored per 5 seconds",
	[2795] = "Comfortable Insoles",
	[2796] = "+15 Dodge Rating",
	[2797] = "+9 Dodge Rating",
	[2798] = "+$i Intellect (+$n/+$f)",
	[2799] = "+$i Stamina (+$n/+$f)",
	[2800] = "+$i Armor (+$n/+$f)",
	[2801] = "+8 Resilience",
	[2802] = "+$i Agility",
	[2803] = "+$i Stamina",
	[2804] = "+$i Intellect",
	[2805] = "+$i Strength",
	[2806] = "+$i Spirit",
	[2807] = "+$i Arcane Damage",
	[2808] = "+$i Fire Damage",
	[2809] = "+$i Nature Damage",
	[2810] = "+$i Frost Damage",
	[2811] = "+$i Shadow Damage",
	[2812] = "+$i Healing",
	[2813] = "+$i Defense Rating",
	[2814] = "+$i Health per 5 sec.",
	[2815] = "+$i Dodge Rating",
	[2816] = "+$i Mana Per 5 sec.",
	[2817] = "+$i Arcane Resistance",
	[2818] = "+$i Fire Resistance",
	[2819] = "+$i Frost Resistance",
	[2820] = "+$i Nature Resistance",
	[2821] = "+$i Shadow Resistance",
	[2822] = "+$i Spell Critical Strike Rating",
	[2823] = "+$i Critical Strike Rating",
	[2824] = "+$i Spell Damage and Healing",
	[2825] = "+$i Attack Power",
	[2826] = "+$i Block Rating",
	[2827] = "+14 Spell Crit Rating and 1% Spell Reflect",
	[2828] = "Chance to Increase Spell Cast Speed",
	[2829] = "+24 Attack Power and Minor Run Speed Increase",
	[2830] = "+12 Critical Strike Rating & 5% Snare and Root Resist",
	[2831] = "+18 Stamina & 5% Stun Resist",
	[2832] = "+26 Healing +9 Spell Damage and 2% Reduced Threat",
	[2833] = "+12 Defense Rating & Chance to Restore Health on hit",
	[2834] = "+3 Melee Damage & Chance to Stun Target",
	[2835] = "+12 Intellect & Chance to restore mana on spellcast",
	[2836] = "3 mana per 5 sec.",
	[2837] = "+7 Spirit",
	[2838] = "+7 Spell Critical Strike Rating",
	[2839] = "+14 Spell Critical Strike Rating",
	[2840] = "+21 Stamina",
	[2841] = "+10 Stamina",
	[2842] = "+8 Spirit",
	[2843] = "+8 Spell Critical Strike Rating",
	[2844] = "+8 Hit Rating",
	[2845] = "+11 Hit Rating",
	[2846] = "4 mana per 5 sec.",
	[2847] = "4 mana per 5 sec.",
	[2848] = "5 mana per 5 sec.",
	[2849] = "+7 Dodge Rating",
	[2850] = "+13 Spell Critical Strike Rating",
	[2851] = "+19 Stamina",
	[2852] = "7 mana per 5 sec",
	[2853] = "8 mana per 5 sec",
	[2854] = "3 mana per 5 sec",
	[2855] = "5 mana per 5 sec.",
	[2856] = "+4 Resilience Rating",
	[2857] = "+2 Critical Strike Rating",
	[2858] = "+2 Critical Strike Rating",
	[2859] = "+3 Resilience Rating",
	[2860] = "+3 Hit Rating",
	[2861] = "+3 Defense Rating",
	[2862] = "+3 Resilience Rating",
	[2863] = "+3 Intellect",
	[2864] = "+4 Spell Critical Strike Rating",
	[2865] = "2 mana per 5 sec.",
	[2866] = "+3 Spirit",
	[2867] = "+2 Resilience Rating",
	[2868] = "+6 Stamina",
	[2869] = "+4 Intellect",
	[2870] = "+3 Parry Rating",
	[2871] = "+4 Dodge Rating",
	[2872] = "+9 Healing and +3 Spell Damage",
	[2873] = "+4 Hit Rating",
	[2874] = "+4 Critical Strike Rating",
	[2875] = "+3 Spell Critical Strike Rating",
	[2876] = "+3 Dodge Rating",
	[2877] = "+4 Agility",
	[2878] = "+4 Resilience Rating",
	[2879] = "+3 Strength",
	[2880] = "+3 Spell Hit Rating",
	[2881] = "1 Mana per 5 sec.",
	[2882] = "+6 Stamina",
	[2883] = "+4 Stamina",
	[2884] = "+2 Spell Critical Strike Rating",
	[2885] = "+2 Critical Strike Rating",
	[2886] = "+2 Hit Rating",
	[2887] = "+3 Critical Strike Rating",
	[2888] = "+6 Block Value",
	[2889] = "+5 Spell Damage and Healing",
	[2890] = "+4 Spirit",
	[2891] = "+10 Resilience Rating",
	[2892] = "+4 Strength",
	[2893] = "+3 Agility",
	[2894] = "+7 Strength",
	[2895] = "+4 Stamina",
	[2896] = "+8 Spell Damage",
	[2897] = "+3 Stamina, +4 Crit Rating",
	[2898] = "+3 Stamina, +4 Spell Critical Strike Rating",
	[2899] = "+3 Stamina, +4 Critical Strike Rating",
	[2900] = "+4 Spell Damage and Healing",
	[2901] = "+2 Damage and Healing Spells",
	[2902] = "+2 Critical Strike Rating",
	[2906] = "+$i Stamina and +$i Intellect",
	[2907] = "+2 Parry Rating",
	[2908] = "+4 Spell Hit Rating",
	[2909] = "+2 Spell Hit Rating",
	[2910] = "+3 Healing and Spell Damage",
	[2911] = "+10 Strength",
	[2912] = "+12 Spell Damage",
	[2913] = "+10 Critical Strike Rating",
	[2914] = "+10 Spell Critical Strike Rating",
	[2915] = "+5 Strength, +5 Crit Rating",
	[2916] = "+6 Spell Damage, +5 Spell Crit Rating",
	[2917] = "gem test enchantment",
	[2918] = "+3 Stamina, +4 Crit Rating",
	[2919] = "+7 Strength",
	[2921] = "+3 Stamina, +4 Critical Strike Rating",
	[2922] = "+7 Strength",
	[2923] = "+3 Stamina, +4 Spell Critical Strike Rating",
	[2924] = "+8 Spell Damage",
	[2925] = "+3 Stamina",
	[2926] = "+2 Dodge Rating",
	[2927] = "+4 Strength",
	[2928] = "+12 Spell Damage",
	[2929] = "+2 Weapon Damage",
	[2930] = "+20 Healing and +7 Spell Damage",
	[2931] = "+4 All Stats",
	[2932] = "+4 Defense Rating",
	[2933] = "+15 Resilience Rating",
	[2934] = "+10 Spell Critical Strike Rating",
	[2935] = "+15 Spell Hit Rating",
	[2936] = "+8 Attack Power",
	[2937] = "+20 Spell Damage",
	[2938] = "+20 Spell Penetration",
	[2939] = "Minor Speed and +6 Agility",
	[2940] = "Minor Speed and +9 Stamina",
	[2941] = "+2 Hit Rating",
	[2942] = "+6 Critical Strike Rating",
	[2943] = "+14 Attack Power",
	[2944] = "+14 Attack Power",
	[2945] = "+20 Attack Power",
	[2946] = "+10 Attack Power, +5 Critical Strike Rating",
	[2947] = "+3 Resist All",
	[2948] = "+4 Resist All",
	[2949] = "+20 Attack Power",
	[2950] = "+10 Critical Strike Rating",
	[2951] = "+4 Spell Critical Strike Rating",
	[2952] = "+4 Critical Strike Rating",
	[2953] = "+2 Spell Damage",
	[2954] = "Weighted (+12 Damage)",
	[2955] = "Weighted (+14 Crit Rating and +12 Damage)",
	[2956] = "+4 Strength",
	[2957] = "+4 Agility",
	[2958] = "+9 Healing and +3 Spell Damage",
	[2959] = "+5 Spell Damage",
	[2960] = "+8 Attack Power",
	[2961] = "+6 Stamina",
	[2962] = "+4 Spirit",
	[2963] = "+1 Mana every 5 seconds",
	[2964] = "+4 Intellect",
	[2965] = "+4 Critical Strike Rating",
	[2966] = "+4 Hit Rating",
	[2967] = "+4 Spell Critical Rating",
	[2968] = "+4 Defense Rating",
	[2969] = "+20 Attack Power and Minor Run Speed Increase",
	[2970] = "+12 Spell Damage and Minor Run Speed Increase",
	[2971] = "+12 Attack Power",
	[2972] = "+4 Block Rating",
	[2973] = "+6 Attack Power",
	[2974] = "+7 Healing +3 Spell Damage",
	[2975] = "+5 Block Value",
	[2976] = "+2 Defense Rating",
	[2977] = "+13 Dodge Rating",
	[2978] = "+15 Dodge Rating and +10 Defense Rating",
	[2979] = "+29 Healing and +10 Spell Damage",
	[2980] = "+33 Healing and +11 Spell Damage and +4 Mana Regen",
	[2981] = "+15 Spell Power",
	[2982] = "+18 Spell Power and +10 Spell Critical Strike Rating",
	[2983] = "+26 Attack Power",
	[2984] = "+8 Shadow Resist",
	[2985] = "+8 Fire Resist",
	[2986] = "+30 Attack Power and +10 Critical Strike Rating",
	[2987] = "+8 Frost Resist",
	[2988] = "+8 Nature Resist",
	[2989] = "+8 Arcane Resist",
	[2990] = "+13 Defense Rating",
	[2991] = "+15 Defense Rating and +10 Dodge Rating",
	[2992] = "+5 Mana Regen",
	[2993] = "+6 Mana Regen and +22 Healing",
	[2994] = "+13 Spell Critical Strike Rating",
	[2995] = "+15 Spell Critical Strike Rating and +12 Spell Damage and Healing",
	[2996] = "+13 Critical Strike Rating",
	[2997] = "+15 Critical Strike Rating and +20 Attack Power",
	[2998] = "+7 All Resistances",
	[2999] = "+16 Defense Rating and +17 Dodge Rating",
	[3000] = "+18 Stamina, +12 Dodge Rating, and +12 Resilience Rating",
	[3001] = "+35 Healing +12 Spell Damage and 7 Mana Per 5 sec.",
	[3002] = "+22 Spell Power and +14 Spell Hit Rating",
	[3003] = "+34 Attack Power and +16 Hit Rating",
	[3004] = "+18 Stamina and +20 Resilience Rating",
	[3005] = "+20 Nature Resistance",
	[3006] = "+20 Arcane Resistance",
	[3007] = "+20 Fire Resistance",
	[3008] = "+20 Frost Resistance",
	[3009] = "+20 Shadow Resistance",
	[3010] = "+40 Attack Power and +10 Critical Strike Rating",
	[3011] = "+30 Stamina and +10 Agility",
	[3012] = "+50 Attack Power and +12 Critical Strike Rating",
	[3013] = "+40 Stamina and +12 Agility",
	[3014] = "Windfury Totem 5 (L70 Testing)",
	[3015] = "+2 Strength",
	[3016] = "+2 Intellect",
	[3017] = "+3 Block Rating",
	[3018] = "Rockbiter 9",
	[3019] = "Rockbiter 9",
	[3020] = "Rockbiter 9",
	[3021] = "Rockbiter 1",
	[3022] = "Rockbiter 1",
	[3023] = "Rockbiter 1",
	[3024] = "Rockbiter 2",
	[3025] = "Rockbiter 2",
	[3026] = "Rockbiter 2",
	[3027] = "Rockbiter 3",
	[3028] = "Rockbiter 3",
	[3029] = "Rockbiter 3",
	[3030] = "Rockbiter 4",
	[3031] = "Rockbiter 4",
	[3032] = "Rockbiter 4",
	[3033] = "Rockbiter 5",
	[3034] = "Rockbiter 5",
	[3035] = "Rockbiter 5",
	[3036] = "Rockbiter 6",
	[3037] = "Rockbiter 6",
	[3038] = "Rockbiter 6",
	[3039] = "Rockbiter 7",
	[3040] = "Rockbiter 7",
	[3041] = "Rockbiter 7",
	[3042] = "Rockbiter 8",
	[3043] = "Rockbiter 8",
	[3044] = "Rockbiter 8",
	[3045] = "+5 Strength and +6 Stamina ",
	[3046] = "+11 Healing +4 Spell Damage and +4 Intellect",
	[3047] = "+6 Stamina and +5 Spell Crit Rating",
	[3048] = "+5 Agility and +6 Stamina",
	[3049] = "+5 Critical Strike Rating and +2 mana per 5 sec.",
	[3050] = "+6 Spell Damage and +4 Intellect ",
	[3051] = "+11 Healing +4 Spell Damage and +6 Stamina",
	[3052] = "+10 Attack Power and +4 Hit Rating",
	[3053] = "+5 Defense Rating and +4 Dodge Rating",
	[3054] = "+6 Spell Damage and +6 Stamina",
	[3055] = "+5 Agility and +4 Hit Rating",
	[3056] = "+5 Parry Rating and +4 Defense Rating",
	[3057] = "+5 Strength and +4 Hit Rating",
	[3058] = "+5 Spell Critical Rating and 2 mana per 5 sec.",
	[3059] = "Spell Critical Rating +5 and 2 mana per 5 sec.",
	[3060] = "+5 Dodge Rating and +6 Stamina",
	[3061] = "+6 Spell Damage and +5 Spell Hit Rating",
	[3062] = "+6 Critical Rating and +5 Dodge Rating",
	[3063] = "+5 Parry Rating and +6 Stamina",
	[3064] = "+5 Spirit and +9 Healing +3 Spell Damage",
	[3065] = "+8 Strength",
	[3066] = "+6 Spell Damage and +5 Spell Penetration",
	[3067] = "+10 Attack Power and +6 Stamina",
	[3068] = "+5 Dodge Rating and +4 Hit Rating",
	[3069] = "+11 Healing +4 Spell Damage and +4 Resilience Rating",
	[3070] = "+8 Attack Power and +5 Critical Rating",
	[3071] = "+5 Intellect and +6 Stamina",
	[3072] = "+5 Strength and +4 Critical Rating",
	[3073] = "+4 Agility and +5 Defense Rating",
	[3074] = "+4 Intellect and +5 Spirit",
	[3075] = "+5 Strength and +4 Defense Rating",
	[3076] = "+6 Spell Damage and +4 Spell Critical Rating",
	[3077] = "+5 Intellect and 2 mana per 5 sec.",
	[3078] = "+6 Stamina and +5 Defense Rating",
	[3079] = "+8 Attack Power and +5 Resilience Rating",
	[3080] = "+6 Stamina and +5 Resilience Rating",
	[3081] = "+11 Healing +4 Spell Damage and +4 Spell Critical Rating",
	[3082] = "+5 Defense Rating and 2 mana per 5 sec.",
	[3083] = "+6 Spell Damage and +4 Spirit",
	[3084] = "+5 Dodge Rating and +4 Resilience Rating",
	[3085] = "+6 Stamina and +5 Crit Rating",
	[3086] = "+11 Healing +4 Spell Damage and 2 mana per 5 sec.",
	[3087] = "+5 Strength and +4 Resilience Rating",
	[3088] = "+5 Spell Hit Rating and +6 Stamina",
	[3089] = "+5 Spell Hit Rating and 2 mana per 5 sec.",
	[3090] = "+5 Parry Rating and +4 Resilience Rating",
	[3091] = "+5 Spell Critical Rating and +5 Spell Penetration",
	[3092] = "+3 Critical Strike Rating",
	[3093] = "+150 Attack Power vs Undead and Demons",
	[3094] = "+4 Expertise Rating",
	[3095] = "+8 Resist All",
	[3096] = "+17 Strength and +16 Intellect",
	[3097] = "+2 Spirit",
	[3098] = "+4 Healing +2 Spell Damage",
	[3099] = "+6 Spell Damage and +6 Stamina",
	[3100] = "+11 Healing +4 Spell Damage and +6 Stamina",
	[3101] = "+10 Attack Power and +6 Stamina",
	[3102] = "Poison",
	[3103] = "+8 Strength",
	[3104] = "+6 Spell Hit Rating",
	[3105] = "+8 Spell Hit Rating",
	[3106] = "+6 Attack Power and +4 Stamina",
	[3107] = "+8 Attack Power and +6 Stamina",
	[3108] = "+6 Attack Power & +1 Mana per 5 Seconds",
	[3109] = "+8 Attack Power and +2 Mana every 5 seconds",
	[3110] = "+3 Spell Hit Rating and +4 Spell Damage ",
	[3111] = "+4 Spell Hit Rating and +5 Spell Damage",
	[3112] = "+4 Critical Strike Rating and +8 Attack Power",
	[3113] = "+3 Critical Strike Rating and +6 Attack Power",
	[3114] = "+4 Attack Power",
	[3115] = "+10 Strength",
	[3116] = "+10 Agility",
	[3117] = "+22 Healing and +8 Spell Damage",
	[3118] = "+12 Spell Damage",
	[3119] = "+20 Attack Power",
	[3120] = "+10 Dodge Rating",
	[3121] = "+10 Parry Rating",
	[3122] = "+15 Stamina",
	[3123] = "+10 Spirit",
	[3124] = "+4 Mana every 5 seconds",
	[3125] = "+13 Spell Penetration",
	[3126] = "+10 Intellect",
	[3127] = "+10 Critical Strike Rating",
	[3128] = "+10 Hit Rating",
	[3129] = "+10 Spell Critical Rating",
	[3130] = "+10 Defense Rating",
	[3131] = "+10 Resilience Rating",
	[3132] = "+10 Spell Hit Rating",
	[3133] = "+5 Strength and +7 Stamina",
	[3134] = "+5 Agility and +7 Stamina",
	[3135] = "+10 Attack Power and +7 Stamina",
	[3136] = "+10 Attack Power & +2 Mana per 5 Seconds",
	[3137] = "+6 Spell Damage and +7 Stamina",
	[3138] = "+11 Healing +4 Spell Damage and +2 Mana every 5 seconds",
	[3139] = "+5 Critical Strike Rating and +5 Strength",
	[3140] = "+5 Spell Critical Rating and +6 Spell Damage",
	[3141] = "+11 Healing +4 Spell Damage and +5 Intellect",
	[3142] = "+5 Hit Rating and +5 Agility",
	[3143] = "+5 Spell Hit Rating and +6 Spell Damage",
	[3144] = "+5 Critical Strike Rating and +10 Attack Power",
	[3145] = "+5 Defense Rating and +7 Stamina",
	[3146] = "+5 Spell Critical Rating and +6 Spell Penetration",
	[3147] = "+5 Intellect and +2 Mana every 5 seconds",
	[3148] = "+5 Critical Strike Rating and +7 Stamina",
	[3149] = "+2 Agility",
	[3150] = "+6 mana every 5 sec.",
	[3151] = "+4 Healing +2 Spell Damage",
	[3152] = "+2 Spell Critical Strike Rating",
	[3153] = "+2 Spell Damage and Healing",
	[3154] = "+12 Agility & 3% Increased Critical Damage",
	[3155] = "Chance to Increase Melee/Ranged Attack Speed ",
	[3156] = "+8 Attack Power and +6 Stamina",
	[3157] = "+4 Intellect and +6 Stamina",
	[3158] = "+9 Healing +3 Spell Damage and +4 Spirit",
	[3159] = "+8 Attack Power and +4 Critical Rating",
	[3160] = "+5 Spell Damage and +4 Intellect",
	[3161] = "+4 Stamina and +4 Spell Critical Strike Rating",
	[3162] = "+24 Attack Power and 5% Stun Resistance",
	[3163] = "+14 Spell Damage & 5% Stun Resistance",
	[3164] = "+3 Stamina",
	[3197] = "+20 Attack Power",
	[3198] = "+5 Spell Damage and Healing",
	[3199] = "+170 Armor",
	[3200] = "+4 Spirit and +9 Healing",
	[3201] = "+7 Healing +3 Spell Damage and +3 Spirit",
	[3202] = "+9 Healing +3 Spell Damage and +4 Spirit",
	[3204] = "+3 Spell Critical Strike Rating",
	[3205] = "+3 Critical Strike Rating",
	[3206] = "+8 Agility",
	[3207] = "+12 Strength",
	[3208] = "+24 Attack Power",
	[3209] = "+12 Agility",
	[3210] = "+14 Spell Damage",
	[3211] = "+26 Healing and +9 Spell Damage",
	[3212] = "+18 Stamina",
	[3213] = "+5 Mana every 5 seconds",
	[3214] = "+12 Spirit",
	[3215] = "+12 Resilience Rating",
	[3216] = "+12 Intellect",
	[3217] = "+12 Spell Critical Rating",
	[3218] = "+12 Spell Hit Rating",
	[3219] = "+12 Hit Rating",
	[3220] = "+12 Critical Strike Rating",
	[3221] = "+12 Defense Rating",
	[3222] = "+20 Agility",
	[3223] = "Adamantite Weapon Chain",
	[3224] = "+6 Agility",
	[3225] = "Executioner",
	[3226] = "+4 Resilience Rating and +6 Stamina",
	[3229] = "+12 Resilience Rating",
	[3260] = "+240 Armor",
	[3261] = "+12 Spell Critical & 3% Increased Critical Damage",
	[3262] = "+15 Stamina",
	[3263] = "+4 Critical Strike Rating",
	[3264] = "+150 Armor, -10% Speed",
	[3265] = "Blessed Weapon Coating",
	[3266] = "Righteous Weapon Coating",
	[3267] = "+4 Haste Rating",
	[3268] = "+15 Stamina",
	[3269] = "Truesilver Line",
	[3270] = "+8 Spell Haste Rating",
	[3271] = "+4 Spell Haste Rating and +5 Spell Damage",
	[3272] = "+4 Spell Haste Rating and +6 Stamina",
	[3273] = "Deathfrost",
	[3274] = "+12 Defense Rating & +10% Shield Block Value",
	[3275] = "+14 Spell Damage & +2% Intellect",
	[3280] = "+4 Dodge Rating and +6 Stamina",
	[3281] = "+20 Attack Power",
	[3282] = "+12 Spell Damage",
	[3283] = "+22 Healing and +8 Spell Damage",
	[3284] = "+5 Resilience Rating and +7 Stamina",
	[3285] = "+5 Spell Haste Rating and +7 Stamina",
	[3286] = "+5 Spell Haste Rating and +6 Spell Damage",
	[3287] = "+10 Spell Haste Rating",
	[3289] = "+10% Mount Speed",
	[3315] = "+3% Mount Speed",
	[3318] = "+11 Healing +4 Spell Damage and +5 Spirit",
	[3335] = "+20 Attack Power",
	[3336] = "+10 Spell Critical Strike Rating",
	[3337] = "+10 Attack Power, +5 Critical Strike Rating",
	[3338] = "+6 Spell Damage, +5 Spell Crit Rating",
	[3339] = "+12 Spell Damage",
	[3340] = "+10 Critical Strike Rating",
	[3726] = "+$i Haste",
}

local DCS_ABBREV_ENCHANT_IDS = {
	[1] = "RB 3",
	[2] = "FB 1",
	[3] = "FT 3",
	[4] = "FT 2",
	[5] = "FT 1",
	[6] = "RB 2",
	[7] = "D Psn",
	[8] = "D Psn 2",
	[9] = "Psn 15 Dmg",
	[10] = "Psn 20 Dmg",
	[11] = "Psn 25 Dmg",
	[12] = "FB 2",
	[13] = "SS +3 Dmg",
	[14] = "SS +4 Dmg",
	[15] = "+8 AC",
	[16] = "+16 AC",
	[17] = "+24 AC",
	[18] = "+32 AC",
	[19] = "WS +2 Dmg",
	[20] = "WS +3 Dmg",
	[21] = "WS +4 Dmg",
	[22] = "C Psn",
	[23] = "MN Psn 2",
	[24] = "+5 Mana",
	[25] = "Shd Oil",
	[26] = "Fst Oil",
	[27] = "Sundered",
	[28] = "+4 Res All",
	[29] = "RB 1",
	[30] = "Scp +1 Dmg",
	[31] = "+4 Bst Sly",
	[32] = "Scp +2 Dmg",
	[33] = "Scp +3 Dmg",
	[34] = "CW +20 Hst Rt",
	[35] = "MN Psn",
	[36] = "Fiery Blaze",
	[37] = "Stl Wpn Chn",
	[38] = "+5 Def Rt",
	[39] = "SS +1 Dmg",
	[40] = "SS +2 Dmg",
	[41] = "+5 Health",
	[42] = "Inst Psn 20",
	[43] = "Iron Spk 8-12",
	[44] = "Absorb 10",
	[63] = "Absorb 25",
	[64] = "+3 Spi",
	[65] = "+1 Res All",
	[66] = "+1 Stam",
	[67] = "+1 Dmg",
	[68] = "+1 Str",
	[69] = "+2 Str",
	[70] = "+3 Str",
	[71] = "+1 Stam",
	[72] = "+2 Stam",
	[73] = "+3 Stam",
	[74] = "+1 Agi",
	[75] = "+2 Agi",
	[76] = "+3 Agi",
	[77] = "+2 Dmg",
	[78] = "+3 Dmg",
	[79] = "+1 Int",
	[80] = "+2 Int",
	[81] = "+3 Int",
	[82] = "+1 Spi",
	[83] = "+2 Spi",
	[84] = "+3 Spi",
	[85] = "+3 AC",
	[86] = "+8 AC",
	[87] = "+12 AC",
	[88] = "",
	[89] = "+16 AC",
	[90] = "+4 Agi",
	[91] = "+5 Agi",
	[92] = "+6 Agi",
	[93] = "+7 Agi",
	[94] = "+4 Int",
	[95] = "+5 Int",
	[96] = "+6 Int",
	[97] = "+7 Int",
	[98] = "+4 Spi",
	[99] = "+5 Spi",
	[100] = "+6 Spi",
	[101] = "+7 Spi",
	[102] = "+4 Stam",
	[103] = "+5 Stam",
	[104] = "+6 Stam",
	[105] = "+7 Stam",
	[106] = "+4 Str",
	[107] = "+5 Str",
	[108] = "+6 Str",
	[109] = "+7 Str",
	[110] = "+1 Def Rt",
	[111] = "+2 Def Rt",
	[112] = "+3 Def Rt",
	[113] = "+4 Def Rt",
	[114] = "+5 Def Rt",
	[115] = "+6 Def Rt",
	[116] = "+7 Def Rt",
	[117] = "+4 Dmg",
	[118] = "+5 Dmg",
	[119] = "+6 Dmg",
	[120] = "+7 Dmg",
	[121] = "+20 AC",
	[122] = "+24 AC",
	[123] = "+28 AC",
	[124] = "FT Tot 1",
	[125] = "+1 Swd Skl",
	[126] = "+2 Swd Skl",
	[127] = "+3 Swd Skl",
	[128] = "+4 Swd Skl",
	[129] = "+5 Swd Skl",
	[130] = "+6 Swd Skl",
	[131] = "+7 Swd Skl",
	[132] = "+1 2-Hand Swd Skl",
	[133] = "+2 2-Hand Swd Skl",
	[134] = "+3 2-Hand Swd Skl",
	[135] = "+4 2-Hand Swd Skl",
	[136] = "+5 2-Hand Swd Skl",
	[137] = "+6 2-Hand Swd Skl",
	[138] = "+7 2-Hand Swd Skl",
	[139] = "+1 Mace Skl",
	[140] = "+2 Mace Skl",
	[141] = "+3 Mace Skl",
	[142] = "+4 Mace Skl",
	[143] = "+5 Mace Skl",
	[144] = "+6 Mace Skl",
	[145] = "+7 Mace Skl",
	[146] = "+1 2-Hand Mace Skl",
	[147] = "+2 2-Hand Mace Skl",
	[148] = "+3 2-Hand Mace Skl",
	[149] = "+4 2-Hand Mace Skl",
	[150] = "+5 2-Hand Mace Skl",
	[151] = "+6 2-Hand Mace Skl",
	[152] = "+7 2-Hand Mace Skl",
	[153] = "+1 Axe Skl",
	[154] = "+2 Axe Skl",
	[155] = "+3 Axe Skl",
	[156] = "+4 Axe Skl",
	[157] = "+5 Axe Skl",
	[158] = "+6 Ase Skl",
	[159] = "+7 Axe Skl",
	[160] = "+1 2-Hand Axe Skl",
	[161] = "+2 2-Hand Axe Skl",
	[162] = "+3 2-Hand Axe Skl",
	[163] = "+4 2-Hand Axe Skl",
	[164] = "+5 2-Hand Axe Skl",
	[165] = "+6 2-Hand Axe Skl",
	[166] = "+7 2-Hand Axe Skl",
	[167] = "+1 Dag Skl",
	[168] = "+2 Dag Skl",
	[169] = "+3 Dag Skl",
	[170] = "+4 Dag Skl",
	[171] = "+5 Dag Skl",
	[172] = "+6 Dag Skl",
	[173] = "+7 Dag Skl",
	[174] = "+1 Gun Skl",
	[175] = "+2 Gun Skl",
	[176] = "+3 Gun Skl",
	[177] = "+4 Gun Skl",
	[178] = "+5 Gun Skl",
	[179] = "+6 Gun Skl",
	[180] = "+7 Gun Skl",
	[181] = "+1 Bow Skl",
	[182] = "+2 Bow Skl",
	[183] = "+3 Bow Skl",
	[184] = "+4 Bow Skl",
	[185] = "+5 Bow Skl",
	[186] = "+6 Bow Skl",
	[187] = "+7 Bow Skl",
	[188] = "+2 Bst Sly",
	[189] = "+4 Bst Sly",
	[190] = "+6 Bst Sly",
	[191] = "+8 Bst Sly",
	[192] = "+10 Bst Sly",
	[193] = "+12 Bst Sly",
	[194] = "+14 Bst Sly",
	[195] = "+14 Crit Rt",
	[196] = "+28 Crit Rt",
	[197] = "+42 Crit Rt",
	[198] = "+56 Crit Rt",
	[199] = "10% OnHit Shd Blt 10 Dmg",
	[200] = "10% OnHit Shd Blt 20 Dmg",
	[201] = "10% OnHit Shd Blt 30 Dmg",
	[202] = "10% OnHit Shd Blt 40 Dmg",
	[203] = "10% OnHit Shd Blt 50 Dmg",
	[204] = "10% OnHit Shd Blt 60 Dmg",
	[205] = "10% OnHit Shd Blt 70 Dmg",
	[206] = "+2 Heal",
	[207] = "+4 Heal",
	[208] = "+7 Heal",
	[209] = "+9 Heal",
	[210] = "+11 Heal",
	[211] = "+13 Heal",
	[212] = "+15 Heal",
	[213] = "+1 Fire SP",
	[214] = "+3 Fire SP",
	[215] = "+4 Fire SP",
	[216] = "+6 Fire SP",
	[217] = "+7 Fire SP",
	[218] = "+9 Fire SP",
	[219] = "+10 Fire SP",
	[220] = "+1 Nat SP",
	[221] = "+3 Nat SP",
	[222] = "+4 Nat SP",
	[223] = "+6 Nat SP",
	[224] = "+7 Nat SP",
	[225] = "+9 Nat SP",
	[226] = "+10 Nat SP",
	[227] = "+1 Fst SP",
	[228] = "+3 Fst SP",
	[229] = "+4 Fst SP",
	[230] = "+6 Fst SP",
	[231] = "+7 Fst SP",
	[232] = "+9 Fst SP",
	[233] = "+10 Fst SP",
	[234] = "+1 Shd SP",
	[235] = "+3 Shd SP",
	[236] = "+4 Shd SP",
	[237] = "+6 Shd SP",
	[238] = "+7 Shd SP",
	[239] = "+9 Shd SP",
	[240] = "+10 Shd SP",
	[241] = "+2 Wpn Dmg",
	[242] = "+15 Health",
	[243] = "+1 Spi",
	[244] = "+4 Int",
	[245] = "+5 AC",
	[246] = "+20 Mana",
	[247] = "+1 Agi",
	[248] = "+1 Str",
	[249] = "+2 BstSly",
	[250] = "+1  Wpn Dmg",
	[251] = "+1 Int",
	[252] = "+6 Spi",
	[253] = "Absorb 50",
	[254] = "+25 Health",
	[255] = "+3 Spi",
	[256] = "+5 Fire Rst",
	[257] = "+10 AC",
	[263] = "Fsh Lr +25 Fsh Skl",
	[264] = "Fsh Lr +50 Fsh Skl",
	[265] = "Fsh Lr +75 Fsh Skl",
	[266] = "Fsh Lr +100 Fsh Skl",
	[283] = "WTF 1",
	[284] = "WTF 2",
	[285] = "FT Tot 2",
	[286] = "+2 Wpn Fire Dmg",
	[287] = "+4 Wpn Fire Dmg",
	[288] = "+6 Wpn Fire Dmg",
	[289] = "+8 Wpn Fire Dmg",
	[290] = "+10 Wpn Fire Dmg",
	[291] = "+12 Wpn Fire Dmg",
	[292] = "+14 Wpn Fire Dmg",
	[303] = "Orb of Fire",
	[323] = "Inst Psn",
	[324] = "Inst Psn 2",
	[325] = "Inst Psn 3",
	[343] = "+8 Agi",
	[344] = "+32 AC",
	[345] = "+40 AC",
	[346] = "+36 AC",
	[347] = "+44 AC",
	[348] = "+48 AC",
	[349] = "+9 Agi",
	[350] = "+8 Int",
	[351] = "+8 Spi",
	[352] = "+8 Str",
	[353] = "+8 Stam",
	[354] = "+9 Int",
	[355] = "+9 Spi",
	[356] = "+9 Stam",
	[357] = "+9 Str",
	[358] = "+10 Agi",
	[359] = "+10 Int",
	[360] = "+10 Spi",
	[361] = "+10 Stam",
	[362] = "+10 Str",
	[363] = "+11 Agi",
	[364] = "+11 Int",
	[365] = "+11 Spi",
	[366] = "+11 Stam",
	[367] = "+11 Str",
	[368] = "+12 Agi",
	[369] = "+12 Int",
	[370] = "+12 Spi",
	[371] = "+12 Stam",
	[372] = "+12 Str",
	[383] = "+52 AC",
	[384] = "+56 AC",
	[385] = "+60 AC",
	[386] = "+16 AC",
	[387] = "+17 AC",
	[388] = "+18 AC",
	[389] = "+19 AC",
	[403] = "+13 Agi",
	[404] = "+14 Agi",
	[405] = "+13 Int",
	[406] = "+14 Int",
	[407] = "+13 Spi",
	[408] = "+14 Spi",
	[409] = "+13 Stam",
	[410] = "+13 Str",
	[411] = "+14 Stam",
	[412] = "+14 Str",
	[423] = "+1 Heal & SP",
	[424] = "+2 Heal & SP",
	[425] = "ZZOLD +4 Heal & SP",
	[426] = "+5 Heal & SP",
	[427] = "+6 Heal & SP",
	[428] = "+7 Heal & SP",
	[429] = "+8 Heal & SP",
	[430] = "+9 Heal & SP",
	[431] = "+11 Heal & SP",
	[432] = "+12 Heal & SP",
	[433] = "+11 Fire SP",
	[434] = "+13 Fire SP",
	[435] = "+14 Fire SP",
	[436] = "+70 Crit Rt",
	[437] = "+11 Fst SP",
	[438] = "+13 Fst SP",
	[439] = "+14 Fst SP",
	[440] = "+12 Heal",
	[441] = "+20 Heal &\n +7 SP",
	[442] = "+22 Heal",
	[443] = "+11 Nat SP",
	[444] = "+13 Nat SP",
	[445] = "+14 Nat SP",
	[446] = "+11 Shd SP",
	[447] = "+13 Shd SP",
	[448] = "+14 Shd SP",
	[463] = "Mth Spk 16-20",
	[464] = "+4% Mnt Spd",
	[483] = "SS +6 Dmg",
	[484] = "WS +6 Dmg",
	[503] = "RB 4",
	[504] = "+80 RB",
	[523] = "FT 4",
	[524] = "FB 3",
	[525] = "WTF 3",
	[543] = "FT Tot 3",
	[563] = "WTF Tot 2",
	[564] = "WTF Tot 3",
	[583] = "+1 Agi /\n +1 Spi",
	[584] = "+1 Agi /\n +1 Int",
	[585] = "+1 Agi /\n +1 Stam",
	[586] = "+1 Agi /\n +1 Str",
	[587] = "+1 Int /\n +1 Spi",
	[588] = "+1 Int /\n +1 Stam",
	[589] = "+1 Int /\n +1 Str",
	[590] = "+1 Spi /\n +1 Stam",
	[591] = "+1 Spi /\n +1 Str",
	[592] = "+1 Stam /\n +1 Str",
	[603] = "C Psn 2",
	[623] = "Inst Psn 4",
	[624] = "Inst Psn 5",
	[625] = "Inst Psn 6",
	[626] = "D Psn 3",
	[627] = "D Psn 4",
	[643] = "MN Psn 3",
	[663] = "Scp +5 Dmg",
	[664] = "Scp +7 Dmg",
	[683] = "RB 6",
	[684] = "+15 Str",
	[703] = "Wnd Psn",
	[704] = "Wnd Psn 2",
	[705] = "Wnd Psn 3",
	[706] = "Wnd Psn 4",
	[723] = "+3 Int",
	[724] = "+3 Stam",
	[743] = "+2 Stealth",
	[744] = "+20 AC",
	[763] = "+5 Shd Blk Rt",
	[783] = "+10 AC",
	[803] = "Fiery Wpn",
	[804] = "+10 Shd Rst",
	[805] = "+4 Wpn Dmg",
	[823] = "+3 Str",
	[843] = "+30 Mana",
	[844] = "+2 Mine",
	[845] = "+2 Herb",
	[846] = "+2 Fsh",
	[847] = "+1 Stats",
	[848] = "+30 AC",
	[849] = "+3 Agi",
	[850] = "+35 Health",
	[851] = "+5 Spi",
	[852] = "+5 Stam",
	[853] = "+6 BstSly",
	[854] = "+6 Ele Sly",
	[855] = "+5 Fire Rst",
	[856] = "+5 Str",
	[857] = "+50 Mana",
	[863] = "+10 Shd Blk Rt",
	[864] = "+4 Wpn Dmg",
	[865] = "+5 Skin",
	[866] = "+2 Stats",
	[883] = "+15 Agi",
	[884] = "+50 AC",
	[903] = "+3 Res All",
	[904] = "+5 Agi",
	[905] = "+5 Int",
	[906] = "+5 Mine",
	[907] = "+7 Spi",
	[908] = "+50 Health",
	[909] = "+5 Herb",
	[910] = "Inc Stealth",
	[911] = "Min Spd Inc",
	[912] = "Dmn Sly",
	[913] = "+65 Mana",
	[923] = "+5 Def Rt",
	[924] = "+2 Def Rt",
	[925] = "+3 Def Rt",
	[926] = "+8 Fst Rst",
	[927] = "+7 Str",
	[928] = "+3 Stats",
	[929] = "+7 Stam",
	[930] = "+2% Mnt Spd",
	[931] = "+10 Hst Rt",
	[943] = "+3 Wpn Dmg",
	[963] = "+7 Wpn Dmg",
	[983] = "+16 Agi",
	[1003] = "VH Psn",
	[1023] = "Fdb 1",
	[1043] = "+16 Str",
	[1044] = "+17 Str",
	[1045] = "+18 Str",
	[1046] = "+19 Str",
	[1047] = "+20 Str",
	[1048] = "+21 Str",
	[1049] = "+22 Str",
	[1050] = "+23 Str",
	[1051] = "+24 Str",
	[1052] = "+25 Str",
	[1053] = "+26 Str",
	[1054] = "+27 Str",
	[1055] = "+28 Str",
	[1056] = "+29 Str",
	[1057] = "+30 Str",
	[1058] = "+31 Str",
	[1059] = "+32 Str",
	[1060] = "+33 Str",
	[1061] = "+34 Str",
	[1062] = "+35 Str",
	[1063] = "+36 Str",
	[1064] = "+37 Str",
	[1065] = "+38 Str",
	[1066] = "+39 Str",
	[1067] = "+40 Str",
	[1068] = "+15 Stam",
	[1069] = "+16 Stam",
	[1070] = "+17 Stam",
	[1071] = "+18 Stam",
	[1072] = "+19 Stam",
	[1073] = "+20 Stam",
	[1074] = "+21 Stam",
	[1075] = "+22 Stam",
	[1076] = "+23 Stam",
	[1077] = "+24 Stam",
	[1078] = "+25 Stam",
	[1079] = "+26 Stam",
	[1080] = "+27 Stam",
	[1081] = "+28 Stam",
	[1082] = "+29 Stam",
	[1083] = "+30 Stam",
	[1084] = "+31 Stam",
	[1085] = "+32 Stam",
	[1086] = "+33 Stam",
	[1087] = "+34 Stam",
	[1088] = "+35 Stam",
	[1089] = "+36 Stam",
	[1090] = "+37 Stam",
	[1091] = "+38 Stam",
	[1092] = "+39 Stam",
	[1093] = "+40 Stam",
	[1094] = "+17 Agi",
	[1095] = "+18 Agi",
	[1096] = "+19 Agi",
	[1097] = "+20 Agi",
	[1098] = "+21 Agi",
	[1099] = "+22 Agi",
	[1100] = "+23 Agi",
	[1101] = "+24 Agi",
	[1102] = "+25 Agi",
	[1103] = "+26 Agi",
	[1104] = "+27 Agi",
	[1105] = "+28 Agi",
	[1106] = "+29 Agi",
	[1107] = "+30 Agi",
	[1108] = "+31 Agi",
	[1109] = "+32 Agi",
	[1110] = "+33 Agi",
	[1111] = "+34 Agi",
	[1112] = "+35 Agi",
	[1113] = "+36 Agi",
	[1114] = "+37 Agi",
	[1115] = "+38 Agi",
	[1116] = "+39 Agi",
	[1117] = "+40 Agi",
	[1118] = "+15 Int",
	[1119] = "+16 Int",
	[1120] = "+17 Int",
	[1121] = "+18 Int",
	[1122] = "+19 Int",
	[1123] = "+20 Int",
	[1124] = "+21 Int",
	[1125] = "+22 Int",
	[1126] = "+23 Int",
	[1127] = "+24 Int",
	[1128] = "+25 Int",
	[1129] = "+26 Int",
	[1130] = "+27 Int",
	[1131] = "+28 Int",
	[1132] = "+29 Int",
	[1133] = "+30 Int",
	[1134] = "+31 Int",
	[1135] = "+32 Int",
	[1136] = "+33 Int",
	[1137] = "+34 Int",
	[1138] = "+35 Int",
	[1139] = "+36 Int",
	[1140] = "+37 Int",
	[1141] = "+38 Int",
	[1142] = "+39 Int",
	[1143] = "+40 Int",
	[1144] = "+15 Spi",
	[1145] = "+16 Spi",
	[1146] = "+17 Spi",
	[1147] = "+18 Spi",
	[1148] = "+19 Spi",
	[1149] = "+20 Spi",
	[1150] = "+21 Spi",
	[1151] = "+22 Spi",
	[1152] = "+23 Spi",
	[1153] = "+24 Spi",
	[1154] = "+25 Spi",
	[1155] = "+26 Spi",
	[1156] = "+27 Spi",
	[1157] = "+28 Spi",
	[1158] = "+29 Spi",
	[1159] = "+30 Spi",
	[1160] = "+31 Spi",
	[1161] = "+32 Spi",
	[1162] = "+33 Spi",
	[1163] = "+34 Spi",
	[1164] = "+36 Spi",
	[1165] = "+37 Spi",
	[1166] = "+38 Spi",
	[1167] = "+39 Spi",
	[1168] = "+40 Spi",
	[1183] = "+35 Spi",
	[1203] = "+41 Str",
	[1204] = "+42 Str",
	[1205] = "+43 Str",
	[1206] = "+44 Str",
	[1207] = "+45 Str",
	[1208] = "+46 Str",
	[1209] = "+41 Stam",
	[1210] = "+42 Stam",
	[1211] = "+43 Stam",
	[1212] = "+44 Stam",
	[1213] = "+45 Stam",
	[1214] = "+46 Stam",
	[1215] = "+41 Agi",
	[1216] = "+42 Agi",
	[1217] = "+43 Agi",
	[1218] = "+44 Agi",
	[1219] = "+45 Agi",
	[1220] = "+46 Agi",
	[1221] = "+41 Int",
	[1222] = "+42 Int",
	[1223] = "+43 Int",
	[1224] = "+44 Int",
	[1225] = "+45 Int",
	[1226] = "+46 Int",
	[1227] = "+41 Spi",
	[1228] = "+42 Spi",
	[1229] = "+43 Spi",
	[1230] = "+44 Spi",
	[1231] = "+45 Spi",
	[1232] = "+46 Spi",
	[1243] = "+1 Arc Rst",
	[1244] = "+2 Arc Rst",
	[1245] = "+3 Arc Rst",
	[1246] = "+4 Arc Rst",
	[1247] = "+5 Arc Rst",
	[1248] = "+6 Arc Rst",
	[1249] = "+7 Arc Rst",
	[1250] = "+8 Arc Rst",
	[1251] = "+9 Arc Rst",
	[1252] = "+10 Arc Rst",
	[1253] = "+11 Arc Rst",
	[1254] = "+12 Arc Rst",
	[1255] = "+13 Arc Rst",
	[1256] = "+14 Arc Rst",
	[1257] = "+15 Arc Rst",
	[1258] = "+16 Arc Rst",
	[1259] = "+17 Arc Rst",
	[1260] = "+18 Arc Rst",
	[1261] = "+19 Arc Rst",
	[1262] = "+20 Arc Rst",
	[1263] = "+21 Arc Rst",
	[1264] = "+22 Arc Rst",
	[1265] = "+23 Arc Rst",
	[1266] = "+24 Arc Rst",
	[1267] = "+25 Arc Rst",
	[1268] = "+26 Arc Rst",
	[1269] = "+27 Arc Rst",
	[1270] = "+28 Arc Rst",
	[1271] = "+29 Arc Rst",
	[1272] = "+30 Arc Rst",
	[1273] = "+31 Arc Rst",
	[1274] = "+32 Arc Rst",
	[1275] = "+33 Arc Rst",
	[1276] = "+34 Arc Rst",
	[1277] = "+35 Arc Rst",
	[1278] = "+36 Arc Rst",
	[1279] = "+37 Arc Rst",
	[1280] = "+38 Arc Rst",
	[1281] = "+39 Arc Rst",
	[1282] = "+40 Arc Rst",
	[1283] = "+41 Arc Rst",
	[1284] = "+42 Arc Rst",
	[1285] = "+43 Arc Rst",
	[1286] = "+44 Arc Rst",
	[1287] = "+45 Arc Rst",
	[1288] = "+46 Arc Rst",
	[1289] = "+1 Fst Rst",
	[1290] = "+2 Fst Rst",
	[1291] = "+3 Fst Rst",
	[1292] = "+4 Fst Rst",
	[1293] = "+5 Fst Rst",
	[1294] = "+6 Fst Rst",
	[1295] = "+7 Fst Rst",
	[1296] = "+8 Fst Rst",
	[1297] = "+9 Fst Rst",
	[1298] = "+10 Fst Rst",
	[1299] = "+11 Fst Rst",
	[1300] = "+12 Fst Rst",
	[1301] = "+13 Fst Rst",
	[1302] = "+14 Fst Rst",
	[1303] = "+15 Fst Rst",
	[1304] = "+16 Fst Rst",
	[1305] = "+17 Fst Rst",
	[1306] = "+18 Fst Rst",
	[1307] = "+19 Fst Rst",
	[1308] = "+20 Fst Rst",
	[1309] = "+21 Fst Rst",
	[1310] = "+22 Fst Rst",
	[1311] = "+23 Fst Rst",
	[1312] = "+24 Fst Rst",
	[1313] = "+25 Fst Rst",
	[1314] = "+26 Fst Rst",
	[1315] = "+27 Fst Rst",
	[1316] = "+28 Fst Rst",
	[1317] = "+29 Fst Rst",
	[1318] = "+30 Fst Rst",
	[1319] = "+31 Fst Rst",
	[1320] = "+32 Fst Rst",
	[1321] = "+33 Fst Rst",
	[1322] = "+34 Fst Rst",
	[1323] = "+35 Fst Rst",
	[1324] = "+36 Fst Rst",
	[1325] = "+37 Fst Rst",
	[1326] = "+38 Fst Rst",
	[1327] = "+39 Fst Rst",
	[1328] = "+40 Fst Rst",
	[1329] = "+41 Fst Rst",
	[1330] = "+42 Fst Rst",
	[1331] = "+43 Fst Rst",
	[1332] = "+44 Fst Rst",
	[1333] = "+45 Fst Rst",
	[1334] = "+46 Fst Rst",
	[1335] = "+1 Fire Rst",
	[1336] = "+2 Fire Rst",
	[1337] = "+3 Fire Rst",
	[1338] = "+4 Fire Rst",
	[1339] = "+5 Fire Rst",
	[1340] = "+6 Fire Rst",
	[1341] = "+7 Fire Rst",
	[1342] = "+8 Fire Rst",
	[1343] = "+9 Fire Rst",
	[1344] = "+10 Fire Rst",
	[1345] = "+11 Fire Rst",
	[1346] = "+12 Fire Rst",
	[1347] = "+13 Fire Rst",
	[1348] = "+14 Fire Rst",
	[1349] = "+15 Fire Rst",
	[1350] = "+16 Fire Rst",
	[1351] = "+17 Fire Rst",
	[1352] = "+18 Fire Rst",
	[1353] = "+19 Fire Rst",
	[1354] = "+20 Fire Rst",
	[1355] = "+21 Fire Rst",
	[1356] = "+22 Fire Rst",
	[1357] = "+23 Fire Rst",
	[1358] = "+24 Fire Rst",
	[1359] = "+25 Fire Rst",
	[1360] = "+26 Fire Rst",
	[1361] = "+27 Fire Rst",
	[1362] = "+28 Fire Rst",
	[1363] = "+29 Fire Rst",
	[1364] = "+30 Fire Rst",
	[1365] = "+31 Fire Rst",
	[1366] = "+32 Fire Rst",
	[1367] = "+33 Fire Rst",
	[1368] = "+34 Fire Rst",
	[1369] = "+35 Fire Rst",
	[1370] = "+36 Fire Rst",
	[1371] = "+37 Fire Rst",
	[1372] = "+38 Fire Rst",
	[1373] = "+39 Fire Rst",
	[1374] = "+40 Fire Rst",
	[1375] = "+41 Fire Rst",
	[1376] = "+42 Fire Rst",
	[1377] = "+43 Fire Rst",
	[1378] = "+44 Fire Rst",
	[1379] = "+45 Fire Rst",
	[1380] = "+46 Fire Rst",
	[1381] = "+1 Nat Rst",
	[1382] = "+2 Nat Rst",
	[1383] = "+3 Nat Rst",
	[1384] = "+4 Nat Rst",
	[1385] = "+5 Nat Rst",
	[1386] = "+6 Nat Rst",
	[1387] = "+7 Nat Rst",
	[1388] = "+8 Nat Rst",
	[1389] = "+9 Nat Rst",
	[1390] = "+10 Nat Rst",
	[1391] = "+11 Nat Rst",
	[1392] = "+12 Nat Rst",
	[1393] = "+13 Nat Rst",
	[1394] = "+14 Nat Rst",
	[1395] = "+15 Nat Rst",
	[1396] = "+16 Nat Rst",
	[1397] = "+17 Nat Rst",
	[1398] = "+18 Nat Rst",
	[1399] = "+19 Nat Rst",
	[1400] = "+20 Nat Rst",
	[1401] = "+21 Nat Rst",
	[1402] = "+22 Nat Rst",
	[1403] = "+23 Nat Rst",
	[1404] = "+24 Nat Rst",
	[1405] = "+25 Nat Rst",
	[1406] = "+26 Nat Rst",
	[1407] = "+27 Nat Rst",
	[1408] = "+28 Nat Rst",
	[1409] = "+29 Nat Rst",
	[1410] = "+30 Nat Rst",
	[1411] = "+31 Nat Rst",
	[1412] = "+32 Nat Rst",
	[1413] = "+33 Nat Rst",
	[1414] = "+34 Nat Rst",
	[1415] = "+35 Nat Rst",
	[1416] = "+36 Nat Rst",
	[1417] = "+37 Nat Rst",
	[1418] = "+38 Nat Rst",
	[1419] = "+39 Nat Rst",
	[1420] = "+40 Nat Rst",
	[1421] = "+41 Nat Rst",
	[1422] = "+42 Nat Rst",
	[1423] = "+43 Nat Rst",
	[1424] = "+44 Nat Rst",
	[1425] = "+45 Nat Rst",
	[1426] = "+46 Nat Rst",
	[1427] = "+1 Shd Rst",
	[1428] = "+2 Shd Rst",
	[1429] = "+3 Shd Rst",
	[1430] = "+4 Shd Rst",
	[1431] = "+5 Shd Rst",
	[1432] = "+6 Shd Rst",
	[1433] = "+7 Shd Rst",
	[1434] = "+8 Shd Rst",
	[1435] = "+9 Shd Rst",
	[1436] = "+10 Shd Rst",
	[1437] = "+11 Shd Rst",
	[1438] = "+12 Shd Rst",
	[1439] = "+13 Shd Rst",
	[1440] = "+14 Shd Rst",
	[1441] = "+15 Shd Rst",
	[1442] = "+16 Shd Rst",
	[1443] = "+17 Shd Rst",
	[1444] = "+18 Shd Rst",
	[1445] = "+19 Shd Rst",
	[1446] = "+20 Shd Rst",
	[1447] = "+21 Shd Rst",
	[1448] = "+22 Shd Rst",
	[1449] = "+23 Shd Rst",
	[1450] = "+24 Shd Rst",
	[1451] = "+25 Shd Rst",
	[1452] = "+26 Shd Rst",
	[1453] = "+27 Shd Rst",
	[1454] = "+28 Shd Rst",
	[1455] = "+29 Shd Rst",
	[1456] = "+30 Shd Rst",
	[1457] = "+31 Shd Rst",
	[1458] = "+32 Shd Rst",
	[1459] = "+33 Shd Rst",
	[1460] = "+34 Shd Rst",
	[1461] = "+35 Shd Rst",
	[1462] = "+36 Shd Rst",
	[1463] = "+37 Shd Rst",
	[1464] = "+38 Shd Rst",
	[1465] = "+39 Shd Rst",
	[1466] = "+40 Shd Rst",
	[1467] = "+41 Shd Rst",
	[1468] = "+42 Shd Rst",
	[1469] = "+43 Shd Rst",
	[1470] = "+44 Shd Rst",
	[1471] = "+45 Shd Rst",
	[1472] = "+46 Shd Rst",
	[1483] = "+150 Mana",
	[1503] = "+100 HP",
	[1504] = "+125 AC",
	[1505] = "+20 Fire Rst",
	[1506] = "+8 Str",
	[1507] = "+8 Stam",
	[1508] = "+8 Agi",
	[1509] = "+8 Int",
	[1510] = "+8 Spi",
	[1523] = "+85/\n14 MANA/\nFR",
	[1524] = "+75/\n14 HP/\nFR",
	[1525] = "+110/\n14 AC/\nFR",
	[1526] = "+10/\n14 STR/\nFR",
	[1527] = "+10/\n14 STA/\nFR",
	[1528] = "+10/\n14 AGI/\nFR",
	[1529] = "+10/\n14 INT/\nFR",
	[1530] = "+10/\n14 SPI/\nFR",
	[1531] = "+10/\n10 STR/\nSTA",
	[1532] = "+10/\n10/\n110/\n15 STR/\nSTA/\nAC/\nFR",
	[1543] = "+10/\n10/\n100/\n15 INT/\nSPI/\nMANA/\nFR",
	[1563] = "+2 AP",
	[1583] = "+4 AP",
	[1584] = "+6 AP",
	[1585] = "+8 AP",
	[1586] = "+10 AP",
	[1587] = "+12 AP",
	[1588] = "+14 AP",
	[1589] = "+16 AP",
	[1590] = "+18 AP",
	[1591] = "+20 AP",
	[1592] = "+22 AP",
	[1593] = "+24 AP",
	[1594] = "+26 AP",
	[1595] = "+28 AP",
	[1596] = "+30 AP",
	[1597] = "+32 AP",
	[1598] = "+34 AP",
	[1599] = "+36 AP",
	[1600] = "+38 AP",
	[1601] = "+40 AP",
	[1602] = "+42 AP",
	[1603] = "+44 AP",
	[1604] = "+46 AP",
	[1605] = "+48 AP",
	[1606] = "+50 AP",
	[1607] = "+52 AP",
	[1608] = "+54 AP",
	[1609] = "+56 AP",
	[1610] = "+58 AP",
	[1611] = "+60 AP",
	[1612] = "+62 AP",
	[1613] = "+64 AP",
	[1614] = "+66 AP",
	[1615] = "+68 AP",
	[1616] = "+70 AP",
	[1617] = "+72 AP",
	[1618] = "+74 AP",
	[1619] = "+76 AP",
	[1620] = "+78 AP",
	[1621] = "+80 AP",
	[1622] = "+82 AP",
	[1623] = "+84 AP",
	[1624] = "+86 AP",
	[1625] = "+88 AP",
	[1626] = "+90 AP",
	[1627] = "+92 AP",
	[1643] = "SS +8 Dmg",
	[1663] = "RB 5",
	[1664] = "RB 7",
	[1665] = "FT 5",
	[1666] = "FT 6",
	[1667] = "FB 4",
	[1668] = "FB 5",
	[1669] = "WTF 4",
	[1683] = "FT Tot 4",
	[1703] = "WS +8 Dmg",
	[1704] = "Thor Spk 20-30",
	[1723] = "OOC",
	[1743] = "MHTest02",
	[1763] = "Cold Blood",
	[1783] = "WTF Tot 1",
	[1803] = "Firestone 1",
	[1823] = "Firestone 2",
	[1824] = "Firestone 3",
	[1825] = "Firestone 4",
	[1843] = "+40 AC",
	[1863] = "Fdb 2",
	[1864] = "Fdb 3",
	[1865] = "Fdb 4",
	[1866] = "Fdb 5",
	[1883] = "+7 Int",
	[1884] = "+9 Spi",
	[1885] = "+9 Str",
	[1886] = "+9 Stam",
	[1887] = "+7 Agi",
	[1888] = "+5 Res All",
	[1889] = "+70 AC",
	[1890] = "+9 Spi",
	[1891] = "+4 Stats",
	[1892] = "+100 Health",
	[1893] = "+100 Mana",
	[1894] = "Icy Wpn",
	[1895] = "+9 Dmg",
	[1896] = "+9 Wpn Dmg",
	[1897] = "+5 Wpn Dmg",
	[1898] = "Lifestealing",
	[1899] = "Unholy",
	[1900] = "Crusader",
	[1901] = "+9 Int",
	[1903] = "+9 Spi",
	[1904] = "+9 Int",
	[1923] = "+3 Fire Rst",
	[1943] = "+12 Def Rt",
	[1944] = "+8 Def Rt",
	[1945] = "+9 Def Rt",
	[1946] = "+10 Def Rt",
	[1947] = "+11 Def Rt",
	[1948] = "+13 Def Rt",
	[1949] = "+14 Def Rt",
	[1950] = "+15 Def Rt",
	[1951] = "+16 Def Rt",
	[1952] = "+20 Def Rt",
	[1953] = "+22 Def Rt",
	[1954] = "+25 Def Rt",
	[1955] = "+32 Def Rt",
	[1956] = "+17 Def Rt",
	[1957] = "+18 Def Rt",
	[1958] = "+19 Def Rt",
	[1959] = "+21 Def Rt",
	[1960] = "+23 Def Rt",
	[1961] = "+24 Def Rt",
	[1962] = "+26 Def Rt",
	[1963] = "+27 Def Rt",
	[1964] = "+28 Def Rt",
	[1965] = "+29 Def Rt",
	[1966] = "+30 Def Rt",
	[1967] = "+31 Def Rt",
	[1968] = "+33 Def Rt",
	[1969] = "+34 Def Rt",
	[1970] = "+35 Def Rt",
	[1971] = "+36 Def Rt",
	[1972] = "+37 Def Rt",
	[1973] = "+38 Def Rt",
	[1983] = "+5 Blk Rt",
	[1984] = "+10 Blk Rt",
	[1985] = "+15 Blk Rt",
	[1986] = "+20 Blk Rt",
	[1987] = "Block 14",
	[1988] = "Block 15",
	[1989] = "Block 16",
	[1990] = "Block 17",
	[1991] = "Block 18",
	[1992] = "Block 19",
	[1993] = "Block 20",
	[1994] = "Block 21",
	[1995] = "Block 22",
	[1996] = "Block 23",
	[1997] = "Block 24",
	[1998] = "Block 25",
	[1999] = "Block 26",
	[2000] = "Block 27",
	[2001] = "Block 28",
	[2002] = "Block 29",
	[2003] = "Block 30",
	[2004] = "Block 31",
	[2005] = "Block 32",
	[2006] = "Block 33",
	[2007] = "Block 34",
	[2008] = "Block 35",
	[2009] = "Block 36",
	[2010] = "Block 37",
	[2011] = "Block 38",
	[2012] = "Block 39",
	[2013] = "Block 40",
	[2014] = "Block 41",
	[2015] = "Block 42",
	[2016] = "Block 43",
	[2017] = "Block 44",
	[2018] = "Block 45",
	[2019] = "Block 46",
	[2020] = "Block 47",
	[2021] = "Block 48",
	[2022] = "Block 49",
	[2023] = "Block 50",
	[2024] = "Block 51",
	[2025] = "Block 52",
	[2026] = "Block 53",
	[2027] = "Block 54",
	[2028] = "Block 55",
	[2029] = "Block 56",
	[2030] = "Block 57",
	[2031] = "Block 58",
	[2032] = "Block 59",
	[2033] = "Block 60",
	[2034] = "Block 61",
	[2035] = "Block 62",
	[2036] = "Block 63",
	[2037] = "Block 64",
	[2038] = "Block 65",
	[2039] = "Block 66",
	[2040] = "+2 Rng AP",
	[2041] = "+5 Rng AP",
	[2042] = "+7 Rng AP",
	[2043] = "+10 Rng AP",
	[2044] = "+12 Rng AP",
	[2045] = "+14 Rng AP",
	[2046] = "+17 Rng AP",
	[2047] = "+19 Rng AP",
	[2048] = "+22 Rng AP",
	[2049] = "+24 Rng AP",
	[2050] = "+26 Rng AP",
	[2051] = "+29 Rng AP",
	[2052] = "+31 Rng AP",
	[2053] = "+34 Rng AP",
	[2054] = "+36 Rng AP",
	[2055] = "+38 Rng AP",
	[2056] = "+41 Rng AP",
	[2057] = "+43 Rng AP",
	[2058] = "+46 Rng AP",
	[2059] = "+48 Rng AP",
	[2060] = "+50 Rng AP",
	[2061] = "+53 Rng AP",
	[2062] = "+55 Rng AP",
	[2063] = "+58 Rng AP",
	[2064] = "+60 Rng AP",
	[2065] = "+62 Rng AP",
	[2066] = "+65 Rng AP",
	[2067] = "+67 Rng AP",
	[2068] = "+70 Rng AP",
	[2069] = "+72 Rng AP",
	[2070] = "+74 Rng AP",
	[2071] = "+77 Rng AP",
	[2072] = "+79 Rng AP",
	[2073] = "+82 Rng AP",
	[2074] = "+84 Rng AP",
	[2075] = "+86 Rng AP",
	[2076] = "+89 Rng AP",
	[2077] = "+91 Rng AP",
	[2078] = "+12 Ddg Rt",
	[2079] = "+1 Arc SP",
	[2080] = "+3 Arc SP",
	[2081] = "+4 Arc SP",
	[2082] = "+6 Arc SP",
	[2083] = "+7 Arc SP",
	[2084] = "+9 Arc SP",
	[2085] = "+10 Arc SP",
	[2086] = "+11 Arc SP",
	[2087] = "+13 Arc SP",
	[2088] = "+14 Arc SP",
	[2089] = "+16 Arc SP",
	[2090] = "+17 Arc SP",
	[2091] = "+19 Arc SP",
	[2092] = "+20 Arc SP",
	[2093] = "+21 Arc SP",
	[2094] = "+23 Arc SP",
	[2095] = "+24 Arc SP",
	[2096] = "+26 Arc SP",
	[2097] = "+27 Arc SP",
	[2098] = "+29 Arc SP",
	[2099] = "+30 Arc SP",
	[2100] = "+31 Arc SP",
	[2101] = "+33 Arc SP",
	[2102] = "+34 Arc SP",
	[2103] = "+36 Arc SP",
	[2104] = "+37 Arc SP",
	[2105] = "+39 Arc SP",
	[2106] = "+40 Arc SP",
	[2107] = "+41 Arc SP",
	[2108] = "+43 Arc SP",
	[2109] = "+44 Arc SP",
	[2110] = "+46 Arc SP",
	[2111] = "+47 Arc SP",
	[2112] = "+49 Arc SP",
	[2113] = "+50 Arc SP",
	[2114] = "+51 Arc SP",
	[2115] = "+53 Arc SP",
	[2116] = "+54 Arc SP",
	[2117] = "+1 Shd SP",
	[2118] = "+3 Shd SP",
	[2119] = "+4 Shd SP",
	[2120] = "+6 Shd SP",
	[2121] = "+7 Shd SP",
	[2122] = "+9 Shd SP",
	[2123] = "+10 Shd SP",
	[2124] = "+11 Shd SP",
	[2125] = "+13 Shd SP",
	[2126] = "+14 Shd SP",
	[2127] = "+16 Shd SP",
	[2128] = "+17 Shd SP",
	[2129] = "+19 Shd SP",
	[2130] = "+20 Shd SP",
	[2131] = "+21 Shd SP",
	[2132] = "+23 Shd SP",
	[2133] = "+24 Shd SP",
	[2134] = "+26 Shd SP",
	[2135] = "+27 Shd SP",
	[2136] = "+29 Shd SP",
	[2137] = "+30 Shd SP",
	[2138] = "+31 Shd SP",
	[2139] = "+33 Shd SP",
	[2140] = "+34 Shd SP",
	[2141] = "+36 Shd SP",
	[2142] = "+37 Shd SP",
	[2143] = "+39 Shd SP",
	[2144] = "+40 Shd SP",
	[2145] = "+41 Shd SP",
	[2146] = "+43 Shd SP",
	[2147] = "+44 Shd SP",
	[2148] = "+46 Shd SP",
	[2149] = "+47 Shd SP",
	[2150] = "+49 Shd SP",
	[2151] = "+50 Shd SP",
	[2152] = "+51 Shd SP",
	[2153] = "+53 Shd SP",
	[2154] = "+54 Shd SP",
	[2155] = "+1 Fire SP",
	[2156] = "+3 Fire SP",
	[2157] = "+4 Fire SP",
	[2158] = "+6 Fire SP",
	[2159] = "+7 Fire SP",
	[2160] = "+9 Fire SP",
	[2161] = "+10 Fire SP",
	[2162] = "+11 Fire SP",
	[2163] = "+13 Fire SP",
	[2164] = "+14 Fire SP",
	[2165] = "+16 Fire SP",
	[2166] = "+17 Fire SP",
	[2167] = "+19 Fire SP",
	[2168] = "+20 Fire SP",
	[2169] = "+21 Fire SP",
	[2170] = "+23 Fire SP",
	[2171] = "+24 Fire SP",
	[2172] = "+26 Fire SP",
	[2173] = "+27 Fire SP",
	[2174] = "+29 Fire SP",
	[2175] = "+30 Fire SP",
	[2176] = "+31 Fire SP",
	[2177] = "+33 Fire SP",
	[2178] = "+34 Fire SP",
	[2179] = "+36 Fire SP",
	[2180] = "+37 Fire SP",
	[2181] = "+39 Fire SP",
	[2182] = "+40 Fire SP",
	[2183] = "+41 Fire SP",
	[2184] = "+43 Fire SP",
	[2185] = "+44 Fire SP",
	[2186] = "+46 Fire SP",
	[2187] = "+47 Fire SP",
	[2188] = "+49 Fire SP",
	[2189] = "+50 Fire SP",
	[2190] = "+51 Fire SP",
	[2191] = "+53 Fire SP",
	[2192] = "+54 Fire SP",
	[2193] = "+1 Holy SP",
	[2194] = "+3 Holy SP",
	[2195] = "+4 Holy SP",
	[2196] = "+6 Holy SP",
	[2197] = "+7 Holy SP",
	[2198] = "+9 Holy SP",
	[2199] = "+10 Holy SP",
	[2200] = "+11 Holy SP",
	[2201] = "+13 Holy SP",
	[2202] = "+14 Holy SP",
	[2203] = "+16 Holy SP",
	[2204] = "+17 Holy SP",
	[2205] = "+19 Holy SP",
	[2206] = "+20 Holy SP",
	[2207] = "+21 Holy SP",
	[2208] = "+23 Holy SP",
	[2209] = "+24 Holy SP",
	[2210] = "+26 Holy SP",
	[2211] = "+27 Holy SP",
	[2212] = "+29 Holy SP",
	[2213] = "+30 Holy SP",
	[2214] = "+31 Holy SP",
	[2215] = "+33 Holy SP",
	[2216] = "+34 Holy SP",
	[2217] = "+36 Holy SP",
	[2218] = "+37 Holy SP",
	[2219] = "+39 Holy SP",
	[2220] = "+40 Holy SP",
	[2221] = "+41 Holy SP",
	[2222] = "+43 Holy SP",
	[2223] = "+44 Holy SP",
	[2224] = "+46 Holy SP",
	[2225] = "+47 Holy SP",
	[2226] = "+49 Holy SP",
	[2227] = "+50 Holy SP",
	[2228] = "+51 Holy SP",
	[2229] = "+53 Holy SP",
	[2230] = "+54 Holy SP",
	[2231] = "+1 Fst SP",
	[2232] = "+3 Fst SP",
	[2233] = "+4 Fst SP",
	[2234] = "+6 Fst SP",
	[2235] = "+7 Fst SP",
	[2236] = "+9 Fst SP",
	[2237] = "+10 Fst SP",
	[2238] = "+11 Fst SP",
	[2239] = "+13 Fst SP",
	[2240] = "+14 Fst SP",
	[2241] = "+16 Fst SP",
	[2242] = "+17 Fst SP",
	[2243] = "+19 Fst SP",
	[2244] = "+20 Fst SP",
	[2245] = "+21 Fst SP",
	[2246] = "+23 Fst SP",
	[2247] = "+24 Fst SP",
	[2248] = "+26 Fst SP",
	[2249] = "+27 Fst SP",
	[2250] = "+29 Fst SP",
	[2251] = "+30 Fst SP",
	[2252] = "+31 Fst SP",
	[2253] = "+33 Fst SP",
	[2254] = "+34 Fst SP",
	[2255] = "+36 Fst SP",
	[2256] = "+37 Fst SP",
	[2257] = "+39 Fst SP",
	[2258] = "+40 Fst SP",
	[2259] = "+41 Fst SP",
	[2260] = "+43 Fst SP",
	[2261] = "+44 Fst SP",
	[2262] = "+46 Fst SP",
	[2263] = "+47 Fst SP",
	[2264] = "+49 Fst SP",
	[2265] = "+50 Fst SP",
	[2266] = "+51 Fst SP",
	[2267] = "+53 Fst SP",
	[2268] = "+54 Fst SP",
	[2269] = "+1 Nat SP",
	[2270] = "+3 Nat SP",
	[2271] = "+4 Nat SP",
	[2272] = "+6 Nat SP",
	[2273] = "+7 Nat SP",
	[2274] = "+9 Nat SP",
	[2275] = "+10 Nat SP",
	[2276] = "+11 Nat SP",
	[2277] = "+13 Nat SP",
	[2278] = "+14 Nat SP",
	[2279] = "+16 Nat SP",
	[2280] = "+17 Nat SP",
	[2281] = "+19 Nat SP",
	[2282] = "+20 Nat SP",
	[2283] = "+21 Nat SP",
	[2284] = "+23 Nat SP",
	[2285] = "+24 Nat SP",
	[2286] = "+26 Nat SP",
	[2287] = "+27 Nat SP",
	[2288] = "+29 Nat SP",
	[2289] = "+30 Nat SP",
	[2290] = "+31 Nat SP",
	[2291] = "+33 Nat SP",
	[2292] = "+34 Nat SP",
	[2293] = "+36 Nat SP",
	[2294] = "+37 Nat SP",
	[2295] = "+39 Nat SP",
	[2296] = "+40 Nat SP",
	[2297] = "+41 Nat SP",
	[2298] = "+43 Nat SP",
	[2299] = "+44 Nat SP",
	[2300] = "+46 Nat SP",
	[2301] = "+47 Nat SP",
	[2302] = "+49 Nat SP",
	[2303] = "+50 Nat SP",
	[2304] = "+51 Nat SP",
	[2305] = "+53 Nat SP",
	[2306] = "+54 Nat SP",
	[2307] = "+2 Heal Spls &\n +1 Dmg Spls",
	[2308] = "+4 Heal Spls &\n +2 Dmg Spls",
	[2309] = "+7 Heal Spls &\n +3 Dmg Spls",
	[2310] = "+9 Heal Spls &\n +3 Dmg Spls",
	[2311] = "+11 Heal Spls &\n +4 Dmg Spls",
	[2312] = "+13 Heal Spls &\n +5 Dmg Spls",
	[2313] = "+15 Heal Spls &\n +5 Dmg Spls",
	[2314] = "+18 Heal Spls &\n +6 Dmg Spls",
	[2315] = "+20 Heal Spls &\n +7 Dmg Spls",
	[2316] = "+22 Heal Spls &\n +8 Dmg Spls",
	[2317] = "+24 Heal Spls &\n +8 Dmg Spls",
	[2318] = "+26 Heal Spls &\n +9 Dmg Spls",
	[2319] = "+29 Heal Spls &\n +10 Dmg Spls",
	[2320] = "+31 Heal Spls &\n +11 Dmg Spls",
	[2321] = "+33 Heal Spls &\n +11 Dmg Spls",
	[2322] = "+35 Heal Spls &\n +12 Dmg Spls",
	[2323] = "+37 Heal Spls &\n +13 Dmg Spls",
	[2324] = "+40 Heal Spls &\n +14 Dmg Spls",
	[2325] = "+42 Heal Spls &\n +14 Dmg Spls",
	[2326] = "+44 Heal Spls &\n +15 Dmg Spls",
	[2327] = "+46 Heal Spls &\n +16 Dmg Spls",
	[2328] = "+48 Heal Spls &\n +16 Dmg Spls",
	[2329] = "+51 Heal Spls &\n +17 Dmg Spls",
	[2330] = "+53 Heal Spls &\n +18 Dmg Spls",
	[2331] = "+55 Heal Spls &\n +19 Dmg Spls",
	[2332] = "+57 Heal Spls &\n +19 Dmg Spls",
	[2333] = "+59 Heal Spls &\n +20 Dmg Spls",
	[2334] = "+62 Heal Spls &\n +21 Dmg Spls",
	[2335] = "+64 Heal Spls &\n +22 Dmg Spls",
	[2336] = "+66 Heal Spls &\n +22 Dmg Spls",
	[2337] = "+68 Heal Spls &\n +23 Dmg Spls",
	[2338] = "+70 Heal Spls &\n +24 Dmg Spls",
	[2339] = "+73 Heal Spls &\n +25 Dmg Spls",
	[2340] = "+75 Heal Spls &\n +25 Dmg Spls",
	[2341] = "+77 Heal Spls &\n +26 Dmg Spls",
	[2342] = "+79 Heal Spls &\n +27 Dmg Spls",
	[2343] = "+81 Heal Spls &\n +27 Dmg Spls",
	[2344] = "+84 Heal Spls &\n +28 Dmg Spls",
	[2363] = "+1 MP5",
	[2364] = "+1 MP5",
	[2365] = "+1 MP5",
	[2366] = "+2 MP5",
	[2367] = "+2 MP5",
	[2368] = "+2 MP5",
	[2369] = "+3 MP5",
	[2370] = "+3 MP5",
	[2371] = "+4 MP5",
	[2372] = "+4 MP5",
	[2373] = "+4 MP5",
	[2374] = "+5 MP5",
	[2375] = "+5 MP5",
	[2376] = "+6 MP5",
	[2377] = "+6 MP5",
	[2378] = "+6 MP5",
	[2379] = "+7 MP5",
	[2380] = "+7 MP5",
	[2381] = "+8 MP5",
	[2382] = "+8 MP5",
	[2383] = "+8 MP5",
	[2384] = "+9 MP5",
	[2385] = "+9 MP5",
	[2386] = "+10 MP5",
	[2387] = "+10 MP5",
	[2388] = "+10 MP5",
	[2389] = "+11 MP5",
	[2390] = "+11 MP5",
	[2391] = "+12 MP5",
	[2392] = "+12 MP5",
	[2393] = "+12 MP5",
	[2394] = "+13 MP5",
	[2395] = "+13 MP5",
	[2396] = "+14 MP5",
	[2397] = "+14 MP5",
	[2398] = "+14 MP5",
	[2399] = "+15 MP5",
	[2400] = "+15 MP5",
	[2401] = "+1 HP5",
	[2402] = "+1 HP5",
	[2403] = "+1 HP5",
	[2404] = "+1 HP5",
	[2405] = "+1 HP5",
	[2406] = "+2 HP5",
	[2407] = "+2 HP5",
	[2408] = "+2 HP5",
	[2409] = "+2 HP5",
	[2410] = "+3 HP5",
	[2411] = "+3 HP5",
	[2412] = "+3 HP5",
	[2413] = "+3 HP5",
	[2414] = "+4 HP5",
	[2415] = "+4 HP5",
	[2416] = "+4 HP5",
	[2417] = "+4 HP5",
	[2418] = "+5 HP5",
	[2419] = "+5 HP5",
	[2420] = "+5 HP5",
	[2421] = "+5 HP5",
	[2422] = "+6 HP5",
	[2423] = "+6 HP5",
	[2424] = "+6 HP5",
	[2425] = "+6 HP5",
	[2426] = "+7 HP5",
	[2427] = "+7 HP5",
	[2428] = "+7 HP5",
	[2429] = "+7 HP5",
	[2430] = "+8 HP5",
	[2431] = "+8 HP5",
	[2432] = "+8 HP5",
	[2433] = "+8 HP5",
	[2434] = "+9 HP5",
	[2435] = "+9 HP5",
	[2436] = "+9 HP5",
	[2437] = "+9 HP5",
	[2438] = "+10 HP5",
	[2443] = "+7 Fst SP",
	[2463] = "+7 Fire Rst",
	[2483] = "+5 Fire Rst",
	[2484] = "+5 Fst Rst",
	[2485] = "+5 Arc Rst",
	[2486] = "+5 Nat Rst",
	[2487] = "+5 Shd Rst",
	[2488] = "+5 Res All",
	[2503] = "+5 Def Rt",
	[2504] = "+30 SP",
	[2505] = "+55 Heal &\n +19 SP",
	[2506] = "+28 Crit Rt",
	[2523] = "+30 Hit Rt",
	[2543] = "+10 Hst Rt",
	[2544] = "+8 Heal & SP",
	[2545] = "+12 Ddg Rt",
	[2563] = "+15 Str",
	[2564] = "+15 Agi",
	[2565] = "+4 MP5",
	[2566] = "+24 Heal &\n +8 SP",
	[2567] = "+20 Spi",
	[2568] = "+22 Int",
	[2583] = "+10 Def Rt/\n+10 Stam/\n+15 Blk Val",
	[2584] = "+7 Def/\n+10 Stam/\n+24 Heal Spls",
	[2585] = "+28 AP/\n+12 Ddg Rt",
	[2586] = "+24 Rng AP/\n+10 Stam/\n+10 Hit Rt",
	[2587] = "+13 Heal &\n SP/\n+15 Int",
	[2588] = "+18 Heal &\n SP/\n+8 Spl Hit",
	[2589] = "+18 Heal &\n SP/\n+10 Stam",
	[2590] = "+4 Mana Regen/\n+10 Stam/\n+24 Heal Spls",
	[2591] = "+10 Int/\n+10 Stam/\n+24 Heal Spls",
	[2603] = "Eternium Line",
	[2604] = "+33 Heal Spls &\n +11 Dmg Spls",
	[2605] = "+18 SP & Heal",
	[2606] = "+30 AP",
	[2607] = "+12 Dmg & Heal Spls",
	[2608] = "+13 Dmg & Heal Spls",
	[2609] = "+15 Dmg & Heal Spls",
	[2610] = "+14 Dmg & Heal Spls",
	[2611] = "REUSE R&om - 15 Spls All",
	[2612] = "+18 Dmg & Heal Spls",
	[2613] = "+2% Threat",
	[2614] = "+20 Shd SP",
	[2615] = "+20 Fst SP",
	[2616] = "+20 Fire SP",
	[2617] = "+30 Heal &\n +10 SP",
	[2618] = "+15 Agi",
	[2619] = "+15 Fire Rst",
	[2620] = "+15 Nat Rst",
	[2621] = "Subtlety",
	[2622] = "+12 Ddg Rt",
	[2623] = "Min Wiz Oil",
	[2624] = "Min Mana Oil",
	[2625] = "Les Mana Oil",
	[2626] = "Les Wiz Oil",
	[2627] = "Wiz Oil",
	[2628] = "Bril Wiz Oil",
	[2629] = "Bril Mana Oil",
	[2630] = "D Psn 5",
	[2631] = "Fdb 6",
	[2632] = "RB 8",
	[2633] = "RB 9",
	[2634] = "FT 7",
	[2635] = "FB 6",
	[2636] = "WTF 5",
	[2637] = "FT Tot 5",
	[2638] = "WTF Tot 4",
	[2639] = "WTF Tot 5",
	[2640] = "Anes Psn",
	[2641] = "Inst Psn 6I",
	[2642] = "D Psn 6",
	[2643] = "D Psn 6I",
	[2644] = "Wnd Psn 5",
	[2645] = "Firestone 5",
	[2646] = "+25 Agi",
	[2647] = "+12 Str",
	[2648] = "+12 Def Rt",
	[2649] = "+12 Stam",
	[2650] = "+15 SP",
	[2651] = "+12 SP",
	[2652] = "+20 Heal &\n +7 SP",
	[2653] = "+18 Blk Val",
	[2654] = "+12 Int",
	[2655] = "+15 Shd Blk Rt",
	[2656] = "Vitality",
	[2657] = "+12 Agi",
	[2658] = "Surefooted",
	[2659] = "+150 Health",
	[2660] = "+150 Mana",
	[2661] = "+6 Stats",
	[2662] = "+120 AC",
	[2663] = "+7 Rst All",
	[2664] = "+7 Rst All",
	[2665] = "+35 Spi",
	[2666] = "+30 Int",
	[2667] = "Savagery",
	[2668] = "+20 Str",
	[2669] = "+40 SP",
	[2670] = "+35 Agi",
	[2671] = "Sunfire",
	[2672] = "Soulfrost",
	[2673] = "Mongoose",
	[2674] = "Spellsurge",
	[2675] = "Battlemaster",
	[2676] = "Sup Mana Oil",
	[2677] = "Sup Mana Oil",
	[2678] = "Sup Wiz Oil",
	[2679] = "6 MP5",
	[2680] = "+7 Rst All",
	[2681] = "+10 Nat Rst",
	[2682] = "+10 Fst Rst",
	[2683] = "+10 Shd Rst",
	[2684] = "+100 AP vs UD",
	[2685] = "+60 SP vs UD",
	[2686] = "+8 Str",
	[2687] = "+8 Agi",
	[2688] = "+8 Stam",
	[2689] = "+8 MP5",
	[2690] = "+13 Heal &\n +5 SP",
	[2691] = "+6 Str",
	[2692] = "+7 SP",
	[2693] = "+6 Agi",
	[2694] = "+6 Int",
	[2695] = "+6 Spl Crit Rt",
	[2696] = "+6 Def Rt",
	[2697] = "+6 Hit Rt",
	[2698] = "+9 Stam",
	[2699] = "+6 Spi",
	[2700] = "+8 Spl Pen",
	[2701] = "+2 MP5",
	[2702] = "+12 Agi 2 Red",
	[2703] = "+4 Agi Per Color",
	[2704] = "+12 Str 4 Blue",
	[2705] = "+7 Heal +3 SP &\n +3 Int",
	[2706] = "+3 Def Rt &\n +4 Stam",
	[2707] = "+1 MP5 &\n +3 Int",
	[2708] = "+4 SP &\n +4 Stam",
	[2709] = "+7 Heal +3 SP &\n +1 MP5",
	[2710] = "+3 Agi &\n +4 Stam",
	[2711] = "+3 Str &\n +4 Stam",
	[2712] = "SS +12 Dmg",
	[2713] = "SS +14 Crit Rt &\n +12 Dmg",
	[2714] = "Felsteel Spk 26-38",
	[2715] = "+31 Heal +11 SP & 5 MP5",
	[2716] = "+16 Stam &\n +100 AC",
	[2717] = "+26 AP &\n +14 Crit Rt",
	[2718] = "Les Rn of Ward",
	[2719] = "Les Ward of Shd",
	[2720] = "Grt Ward of Shd",
	[2721] = "+15 SP &\n +14 Spl Crit Rt",
	[2722] = "Scp +10 Dmg",
	[2723] = "Scp +12 Dmg",
	[2724] = "Scp +28 Crit Rt",
	[2725] = "+8 Str",
	[2726] = "+8 Agi",
	[2727] = "+18 Heal &\n +6 SP",
	[2728] = "+9 SP",
	[2729] = "+16 AP",
	[2730] = "+8 Ddg Rt",
	[2731] = "+12 Stam",
	[2732] = "+8 Spi",
	[2733] = "+3 MP5",
	[2734] = "+8 Int",
	[2735] = "+8 Crit Rt",
	[2736] = "+8 Spl Crit Rt",
	[2737] = "+8 Def Rt",
	[2738] = "+4 Str &\n +6 Stam",
	[2739] = "+4 Agi &\n +6 Stam",
	[2740] = "+5 SP &\n +6 Stam",
	[2741] = "+9 Heal +3 SP &\n +2 MP5",
	[2742] = "+9 Heal +3 SP &\n +4 Int",
	[2743] = "+4 Def Rt &\n +6 Stam",
	[2744] = "+4 Int &\n +2 MP5",
	[2745] = "+46 Heal +16 SP &\n +15 Stam",
	[2746] = "+66 Heal +22 SP &\n +20 Stam",
	[2747] = "+25 SP &\n +15 Stam",
	[2748] = "+35 SP &\n +20 Stam",
	[2749] = "+12 Int",
	[2750] = "6 MP5",
	[2751] = "+14 Crit Rt",
	[2752] = "+3 Crit Rt &\n +3 Str",
	[2753] = "+4 Crit Rt &\n +4 Str",
	[2754] = "+8 Parry Rt",
	[2755] = "+3 Hit Rt &\n +3 Agi",
	[2756] = "+4 Hit Rt &\n +4 Agi",
	[2757] = "+3 Crit Rt &\n +4 Stam",
	[2758] = "+4 Crit Rt &\n +6 Stam",
	[2759] = "+8 Rsl Rt",
	[2760] = "+3 Spl Crit Rt &\n +4 SP ",
	[2761] = "+4 Spl Crit Rt &\n +5 SP",
	[2762] = "+3 Spl Crit Rt &\n +4 Spl Pen",
	[2763] = "+4 Spl Crit Rt &\n +5 Spl Pen",
	[2764] = "+8 Hit Rt",
	[2765] = "+10 Spl Pen",
	[2766] = "+8 Int",
	[2767] = "+8 Spl Hit Rt",
	[2768] = "+16 SP & Heal",
	[2769] = "+11 Hit Rt",
	[2770] = "+7 SP & Heal",
	[2771] = "+8 Spl Crit Rt",
	[2772] = "+14 Crit Rt",
	[2773] = "+16 Crit Rt",
	[2774] = "+11 Int",
	[2775] = "+11 Spl Crit Rt",
	[2776] = "+3 MP5",
	[2777] = "+13 Spi",
	[2778] = "+13 Spl Pen",
	[2779] = "+16 Spi",
	[2780] = "+20 Spl Pen",
	[2781] = "+19 Stam",
	[2782] = "+10 Agi",
	[2783] = "+14 Hit Rt",
	[2784] = "+12 Hit Rt",
	[2785] = "+13 Hit Rt",
	[2786] = "+7 Hit Rt",
	[2787] = "+8 Crit Rt",
	[2788] = "+9 Rsl",
	[2789] = "+15 Rsl",
	[2790] = "ZZOLDLes Rn of Ward",
	[2791] = "Grt Rn of Ward",
	[2792] = "+8 Stam",
	[2793] = "+8 Def Rt",
	[2794] = "+3 MP5",
	[2795] = "Comfortable Insoles",
	[2796] = "+15 Ddg Rt",
	[2797] = "+9 Ddg Rt",
	[2798] = "+$i Int +$n/\n+$f",
	[2799] = "+$i Stam +$n/\n+$f",
	[2800] = "+$i AC +$n/\n+$f",
	[2801] = "+8 Rsl",
	[2802] = "+$i Agi",
	[2803] = "+$i Stam",
	[2804] = "+$i Int",
	[2805] = "+$i Str",
	[2806] = "+$i Spi",
	[2807] = "+$i Arc Dmg",
	[2808] = "+$i Fire Dmg",
	[2809] = "+$i Nat Dmg",
	[2810] = "+$i Fst Dmg",
	[2811] = "+$i Shd Dmg",
	[2812] = "+$i Heal",
	[2813] = "+$i Def Rt",
	[2814] = "+$i Health per 5 sec.",
	[2815] = "+$i Ddg Rt",
	[2816] = "+$i MP5",
	[2817] = "+$i Arc Rst",
	[2818] = "+$i Fire Rst",
	[2819] = "+$i Fst Rst",
	[2820] = "+$i Nat Rst",
	[2821] = "+$i Shd Rst",
	[2822] = "+$i Spl Crit Rt",
	[2823] = "+$i Crit Rt",
	[2824] = "+$i SP & Heal",
	[2825] = "+$i AP",
	[2826] = "+$i Blk Rt",
	[2827] = "+14 Spl Crit Rt &\n 1% Spl Reflect",
	[2828] = "Cast Spd Chance",
	[2829] = "+24 AP & Min Run Spd",
	[2830] = "+12 Crit Rt &\n 5% Snare &\n Root Rst",
	[2831] = "+18 Stam &\n 5% Stun Rst",
	[2832] = "+26 Heal +9 SP &\n 2% Reduced Threat",
	[2833] = "+12 Def Rt &\n Chance to Restore Health on hit",
	[2834] = "+3 Melee Dmg &\n Chance to Stun Target",
	[2835] = "+12 Int &\n Chance to restore mana on Splcast",
	[2836] = "3 MP5",
	[2837] = "+7 Spi",
	[2838] = "+7 Spl Crit Rt",
	[2839] = "+14 Spl Crit Rt",
	[2840] = "+21 Stam",
	[2841] = "+10 Stam",
	[2842] = "+8 Spi",
	[2843] = "+8 Spl Crit Rt",
	[2844] = "+8 Hit Rt",
	[2845] = "+11 Hit Rt",
	[2846] = "4 MP5",
	[2847] = "4 MP5",
	[2848] = "5 MP5",
	[2849] = "+7 Ddg Rt",
	[2850] = "+13 Spl Crit Rt",
	[2851] = "+19 Stam",
	[2852] = "7 mana per 5 sec",
	[2853] = "8 mana per 5 sec",
	[2854] = "3 mana per 5 sec",
	[2855] = "5 MP5",
	[2856] = "+4 Rsl Rt",
	[2857] = "+2 Crit Rt",
	[2858] = "+2 Crit Rt",
	[2859] = "+3 Rsl Rt",
	[2860] = "+3 Hit Rt",
	[2861] = "+3 Def Rt",
	[2862] = "+3 Rsl Rt",
	[2863] = "+3 Int",
	[2864] = "+4 Spl Crit Rt",
	[2865] = "2 MP5",
	[2866] = "+3 Spi",
	[2867] = "+2 Rsl Rt",
	[2868] = "+6 Stam",
	[2869] = "+4 Int",
	[2870] = "+3 Parry Rt",
	[2871] = "+4 Ddg Rt",
	[2872] = "+9 Heal &\n +3 SP",
	[2873] = "+4 Hit Rt",
	[2874] = "+4 Crit Rt",
	[2875] = "+3 Spl Crit Rt",
	[2876] = "+3 Ddg Rt",
	[2877] = "+4 Agi",
	[2878] = "+4 Rsl Rt",
	[2879] = "+3 Str",
	[2880] = "+3 Spl Hit Rt",
	[2881] = "1 MP5",
	[2882] = "+6 Stam",
	[2883] = "+4 Stam",
	[2884] = "+2 Spl Crit Rt",
	[2885] = "+2 Crit Rt",
	[2886] = "+2 Hit Rt",
	[2887] = "+3 Crit Rt",
	[2888] = "+6 Blk Val",
	[2889] = "+5 SP & Heal",
	[2890] = "+4 Spi",
	[2891] = "+10 Rsl Rt",
	[2892] = "+4 Str",
	[2893] = "+3 Agi",
	[2894] = "+7 Str",
	[2895] = "+4 Stam",
	[2896] = "+8 SP",
	[2897] = "+3 Stam, +4 Crit Rt",
	[2898] = "+3 Stam, +4 Spl Crit Rt",
	[2899] = "+3 Stam, +4 Crit Rt",
	[2900] = "+4 SP & Heal",
	[2901] = "+2 Dmg & Heal Spls",
	[2902] = "+2 Crit Rt",
	[2906] = "+$i Stam &\n +$i Int",
	[2907] = "+2 Parry Rt",
	[2908] = "+4 Spl Hit Rt",
	[2909] = "+2 Spl Hit Rt",
	[2910] = "+3 Heal & SP",
	[2911] = "+10 Str",
	[2912] = "+12 SP",
	[2913] = "+10 Crit Rt",
	[2914] = "+10 Spl Crit Rt",
	[2915] = "+5 Str, +5 Crit Rt",
	[2916] = "+6 SP, +5 Spl Crit Rt",
	[2917] = "gem test enchantment",
	[2918] = "+3 Stam, +4 Crit Rt",
	[2919] = "+7 Str",
	[2921] = "+3 Stam, +4 Crit Rt",
	[2922] = "+7 Str",
	[2923] = "+3 Stam, +4 Spl Crit Rt",
	[2924] = "+8 SP",
	[2925] = "+3 Stam",
	[2926] = "+2 Ddg Rt",
	[2927] = "+4 Str",
	[2928] = "+12 SP",
	[2929] = "+2 Wpn Dmg",
	[2930] = "+20 Heal &\n +7 SP",
	[2931] = "+4 Stats",
	[2932] = "+4 Def Rt",
	[2933] = "+15 Rsl Rt",
	[2934] = "+10 Spl Crit Rt",
	[2935] = "+15 Spl Hit Rt",
	[2936] = "+8 AP",
	[2937] = "+20 SP",
	[2938] = "+20 Spl Pen",
	[2939] = "Min Spd &\n +6 Agi",
	[2940] = "Min Spd &\n +9 Stam",
	[2941] = "+2 Hit Rt",
	[2942] = "+6 Crit Rt",
	[2943] = "+14 AP",
	[2944] = "+14 AP",
	[2945] = "+20 AP",
	[2946] = "+10 AP, +5 Crit Rt",
	[2947] = "+3 Rst All",
	[2948] = "+4 Rst All",
	[2949] = "+20 AP",
	[2950] = "+10 Crit Rt",
	[2951] = "+4 Spl Crit Rt",
	[2952] = "+4 Crit Rt",
	[2953] = "+2 SP",
	[2954] = "WS +12 Dmg",
	[2955] = "WS +14 Crit Rt &\n +12 Dmg",
	[2956] = "+4 Str",
	[2957] = "+4 Agi",
	[2958] = "+9 Heal &\n +3 SP",
	[2959] = "+5 SP",
	[2960] = "+8 AP",
	[2961] = "+6 Stam",
	[2962] = "+4 Spi",
	[2963] = "+1 MP5",
	[2964] = "+4 Int",
	[2965] = "+4 Crit Rt",
	[2966] = "+4 Hit Rt",
	[2967] = "+4 Spl Crit Rt",
	[2968] = "+4 Def Rt",
	[2969] = "+20 AP & Min Run Spd Inc",
	[2970] = "+12 SP & Min Run Spd Inc",
	[2971] = "+12 AP",
	[2972] = "+4 Blk Rt",
	[2973] = "+6 AP",
	[2974] = "+7 Heal +3 SP",
	[2975] = "+5 Blk Val",
	[2976] = "+2 Def Rt",
	[2977] = "+13 Ddg Rt",
	[2978] = "+15 Ddg Rt &\n +10 Def Rt",
	[2979] = "+29 Heal &\n +10 SP",
	[2980] = "+33 Heal &\n +11 SP &\n +4 Mana Regen",
	[2981] = "+15 Spl Power",
	[2982] = "+18 Spl Power &\n +10 Spl Crit Rt",
	[2983] = "+26 AP",
	[2984] = "+8 Shd Rst",
	[2985] = "+8 Fire Rst",
	[2986] = "+30 AP &\n +10 Crit Rt",
	[2987] = "+8 Fst Rst",
	[2988] = "+8 Nat Rst",
	[2989] = "+8 Arc Rst",
	[2990] = "+13 Def Rt",
	[2991] = "+15 Def Rt &\n +10 Ddg Rt",
	[2992] = "+5 Mana Regen",
	[2993] = "+6 Mana Regen &\n +22 Heal",
	[2994] = "+13 Spl Crit Rt",
	[2995] = "+15 Spl Crit Rt &\n +12 SP &\n Heal",
	[2996] = "+13 Crit Rt",
	[2997] = "+15 Crit Rt &\n +20 AP",
	[2998] = "+7 Res All",
	[2999] = "+16 Def Rt &\n +17 Ddg Rt",
	[3000] = "+18 Stam, +12 Ddg Rt, &\n +12 Rsl Rt",
	[3001] = "+35 Heal +12 SP & 7 MP5",
	[3002] = "+22 Spl Power &\n +14 Spl Hit Rt",
	[3003] = "+34 AP &\n +16 Hit Rt",
	[3004] = "+18 Stam &\n +20 Rsl Rt",
	[3005] = "+20 Nat Rst",
	[3006] = "+20 Arc Rst",
	[3007] = "+20 Fire Rst",
	[3008] = "+20 Fst Rst",
	[3009] = "+20 Shd Rst",
	[3010] = "+40 AP &\n +10 Crit Rt",
	[3011] = "+30 Stam &\n +10 Agi",
	[3012] = "+50 AP &\n +12 Crit Rt",
	[3013] = "+40 Stam &\n +12 Agi",
	[3014] = "WTF Tot 5 L70 Testing",
	[3015] = "+2 Str",
	[3016] = "+2 Int",
	[3017] = "+3 Blk Rt",
	[3018] = "RB 9",
	[3019] = "RB 9",
	[3020] = "RB 9",
	[3021] = "RB 1",
	[3022] = "RB 1",
	[3023] = "RB 1",
	[3024] = "RB 2",
	[3025] = "RB 2",
	[3026] = "RB 2",
	[3027] = "RB 3",
	[3028] = "RB 3",
	[3029] = "RB 3",
	[3030] = "RB 4",
	[3031] = "RB 4",
	[3032] = "RB 4",
	[3033] = "RB 5",
	[3034] = "RB 5",
	[3035] = "RB 5",
	[3036] = "RB 6",
	[3037] = "RB 6",
	[3038] = "RB 6",
	[3039] = "RB 7",
	[3040] = "RB 7",
	[3041] = "RB 7",
	[3042] = "RB 8",
	[3043] = "RB 8",
	[3044] = "RB 8",
	[3045] = "+5 Str &\n +6 Stam ",
	[3046] = "+11 Heal +4 SP &\n +4 Int",
	[3047] = "+6 Stam &\n +5 Spl Crit Rt",
	[3048] = "+5 Agi &\n +6 Stam",
	[3049] = "+5 Crit Rt &\n +2 MP5",
	[3050] = "+6 SP &\n +4 Int ",
	[3051] = "+11 Heal +4 SP &\n +6 Stam",
	[3052] = "+10 AP &\n +4 Hit Rt",
	[3053] = "+5 Def Rt &\n +4 Ddg Rt",
	[3054] = "+6 SP &\n +6 Stam",
	[3055] = "+5 Agi &\n +4 Hit Rt",
	[3056] = "+5 Parry Rt &\n +4 Def Rt",
	[3057] = "+5 Str &\n +4 Hit Rt",
	[3058] = "+5 Spl Crit Rt &\n 2 MP5",
	[3059] = "Spl Crit Rt +5 &\n 2 MP5",
	[3060] = "+5 Ddg Rt &\n +6 Stam",
	[3061] = "+6 SP &\n +5 Spl Hit Rt",
	[3062] = "+6 Crit Rt &\n +5 Ddg Rt",
	[3063] = "+5 Parry Rt &\n +6 Stam",
	[3064] = "+5 Spi &\n +9 Heal +3 SP",
	[3065] = "+8 Str",
	[3066] = "+6 SP &\n +5 Spl Pen",
	[3067] = "+10 AP &\n +6 Stam",
	[3068] = "+5 Ddg Rt &\n +4 Hit Rt",
	[3069] = "+11 Heal +4 SP &\n +4 Rsl Rt",
	[3070] = "+8 AP &\n +5 Crit Rt",
	[3071] = "+5 Int &\n +6 Stam",
	[3072] = "+5 Str &\n +4 Crit Rt",
	[3073] = "+4 Agi &\n +5 Def Rt",
	[3074] = "+4 Int &\n +5 Spi",
	[3075] = "+5 Str &\n +4 Def Rt",
	[3076] = "+6 SP &\n +4 Spl Crit Rt",
	[3077] = "+5 Int &\n 2 MP5",
	[3078] = "+6 Stam &\n +5 Def Rt",
	[3079] = "+8 AP &\n +5 Rsl Rt",
	[3080] = "+6 Stam &\n +5 Rsl Rt",
	[3081] = "+11 Heal +4 SP &\n +4 Spl Crit Rt",
	[3082] = "+5 Def Rt &\n 2 MP5",
	[3083] = "+6 SP &\n +4 Spi",
	[3084] = "+5 Ddg Rt &\n +4 Rsl Rt",
	[3085] = "+6 Stam &\n +5 Crit Rt",
	[3086] = "+11 Heal +4 SP &\n 2 MP5",
	[3087] = "+5 Str &\n +4 Rsl Rt",
	[3088] = "+5 Spl Hit Rt &\n +6 Stam",
	[3089] = "+5 Spl Hit Rt &\n 2 MP5",
	[3090] = "+5 Parry Rt &\n +4 Rsl Rt",
	[3091] = "+5 Spl Crit Rt &\n +5 Spl Pen",
	[3092] = "+3 Crit Rt",
	[3093] = "+150 AP vs UD & Dmns",
	[3094] = "+4 Expertise Rt",
	[3095] = "+8 Rst All",
	[3096] = "+17 Str &\n +16 Int",
	[3097] = "+2 Spi",
	[3098] = "+4 Heal +2 SP",
	[3099] = "+6 SP &\n +6 Stam",
	[3100] = "+11 Heal +4 SP &\n +6 Stam",
	[3101] = "+10 AP &\n +6 Stam",
	[3102] = "Psn",
	[3103] = "+8 Str",
	[3104] = "+6 Spl Hit Rt",
	[3105] = "+8 Spl Hit Rt",
	[3106] = "+6 AP &\n +4 Stam",
	[3107] = "+8 AP &\n +6 Stam",
	[3108] = "+6 AP &\n +1 MP5",
	[3109] = "+8 AP &\n +2 MP5",
	[3110] = "+3 Spl Hit Rt &\n +4 SP ",
	[3111] = "+4 Spl Hit Rt &\n +5 SP",
	[3112] = "+4 Crit Rt &\n +8 AP",
	[3113] = "+3 Crit Rt &\n +6 AP",
	[3114] = "+4 AP",
	[3115] = "+10 Str",
	[3116] = "+10 Agi",
	[3117] = "+22 Heal &\n +8 SP",
	[3118] = "+12 SP",
	[3119] = "+20 AP",
	[3120] = "+10 Ddg Rt",
	[3121] = "+10 Parry Rt",
	[3122] = "+15 Stam",
	[3123] = "+10 Spi",
	[3124] = "+4 MP5",
	[3125] = "+13 Spl Pen",
	[3126] = "+10 Int",
	[3127] = "+10 Crit Rt",
	[3128] = "+10 Hit Rt",
	[3129] = "+10 Spl Crit Rt",
	[3130] = "+10 Def Rt",
	[3131] = "+10 Rsl Rt",
	[3132] = "+10 Spl Hit Rt",
	[3133] = "+5 Str &\n +7 Stam",
	[3134] = "+5 Agi &\n +7 Stam",
	[3135] = "+10 AP &\n +7 Stam",
	[3136] = "+10 AP &\n +2 MP5",
	[3137] = "+6 SP &\n +7 Stam",
	[3138] = "+11 Heal +4 SP &\n +2 MP5",
	[3139] = "+5 Crit Rt &\n +5 Str",
	[3140] = "+5 Spl Crit Rt &\n +6 SP",
	[3141] = "+11 Heal +4 SP &\n +5 Int",
	[3142] = "+5 Hit Rt &\n +5 Agi",
	[3143] = "+5 Spl Hit Rt &\n +6 SP",
	[3144] = "+5 Crit Rt &\n +10 AP",
	[3145] = "+5 Def Rt &\n +7 Stam",
	[3146] = "+5 Spl Crit Rt &\n +6 Spl Pen",
	[3147] = "+5 Int &\n +2 MP5",
	[3148] = "+5 Crit Rt &\n +7 Stam",
	[3149] = "+2 Agi",
	[3150] = "+6 MP5",
	[3151] = "+4 Heal +2 SP",
	[3152] = "+2 Spl Crit Rt",
	[3153] = "+2 SP & Heal",
	[3154] = "+12 Agi &\n 3% Inc Crit Dmg",
	[3155] = "Chance to Inc Melee/\nRng Atk Spd ",
	[3156] = "+8 AP &\n +6 Stam",
	[3157] = "+4 Int &\n +6 Stam",
	[3158] = "+9 Heal +3 SP &\n +4 Spi",
	[3159] = "+8 AP &\n +4 Crit Rt",
	[3160] = "+5 SP &\n +4 Int",
	[3161] = "+4 Stam &\n +4 Spl Crit Rt",
	[3162] = "+24 AP &\n 5% Stun Rst",
	[3163] = "+14 SP &\n 5% Stun Rst",
	[3164] = "+3 Stam",
	[3197] = "+20 AP",
	[3198] = "+5 SP & Heal",
	[3199] = "+170 AC",
	[3200] = "+4 Spi &\n +9 Heal",
	[3201] = "+7 Heal +3 SP &\n +3 Spi",
	[3202] = "+9 Heal +3 SP &\n +4 Spi",
	[3204] = "+3 Spl Crit Rt",
	[3205] = "+3 Crit Rt",
	[3206] = "+8 Agi",
	[3207] = "+12 Str",
	[3208] = "+24 AP",
	[3209] = "+12 Agi",
	[3210] = "+14 SP",
	[3211] = "+26 Heal &\n +9 SP",
	[3212] = "+18 Stam",
	[3213] = "+5 MP5",
	[3214] = "+12 Spi",
	[3215] = "+12 Rsl Rt",
	[3216] = "+12 Int",
	[3217] = "+12 Spl Crit Rt",
	[3218] = "+12 Spl Hit Rt",
	[3219] = "+12 Hit Rt",
	[3220] = "+12 Crit Rt",
	[3221] = "+12 Def Rt",
	[3222] = "+20 Agi",
	[3223] = "Admt Wpn Chn",
	[3224] = "+6 Agi",
	[3225] = "Executioner",
	[3226] = "+4 Rsl Rt &\n +6 Stam",
	[3229] = "+12 Rsl Rt",
	[3260] = "+240 AC",
	[3261] = "+12 Spl Crit &\n 3% Inc Crit Dmg",
	[3262] = "+15 Stam",
	[3263] = "+4 Crit Rt",
	[3264] = "+150 AC, -10% Spd",
	[3265] = "Blessed Wpn Coating",
	[3266] = "Righteous Wpn Coating",
	[3267] = "+4 Hst Rt",
	[3268] = "+15 Stam",
	[3269] = "Truesilver Line",
	[3270] = "+8 Spl Hst Rt",
	[3271] = "+4 Spl Hst Rt &\n +5 SP",
	[3272] = "+4 Spl Hst Rt &\n +6 Stam",
	[3273] = "DeathFst",
	[3274] = "+12 Def Rt &\n +10% Shd Blk Val",
	[3275] = "+14 SP &\n +2% Int",
	[3280] = "+4 Ddg Rt &\n +6 Stam",
	[3281] = "+20 AP",
	[3282] = "+12 SP",
	[3283] = "+22 Heal &\n +8 SP",
	[3284] = "+5 Rsl Rt &\n +7 Stam",
	[3285] = "+5 Spl Hst Rt &\n +7 Stam",
	[3286] = "+5 Spl Hst Rt &\n +6 SP",
	[3287] = "+10 Spl Hst Rt",
	[3289] = "+10% Mnt Spd",
	[3315] = "+3% Mnt Spd",
	[3318] = "+11 Heal +4 SP &\n +5 Spi",
	[3335] = "+20 AP",
	[3336] = "+10 Spl Crit Rt",
	[3337] = "+10 AP, +5 Crit Rt",
	[3338] = "+6 SP, +5 Spl Crit Rt",
	[3339] = "+12 SP",
	[3340] = "+10 Crit Rt",
	[3726] = "+$i Hst",
}

--------------------------
-- Item Enchant Display --
--------------------------
addon.hasBiznicks = false

local function DCS_Item_Enchant_GetText()
	local MATCH_ENCHANT = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)')
	local ENCHANT_PATTERN = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)') --moving outside of the function might not be warranted but moving outside of for loop is
	local tooltip = CreateFrame("GameTooltip", "DCSScanTooltip", nil, "GameTooltipTemplate") --TODO: use the same frame for both repairs and itemlevel
	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		v.enchant:SetText("")
		-- local slotId, textureName = GetInventorySlotInfo(v) --Call for string parsing instead of table lookup, bleh.
		local item = Item:CreateFromEquipmentSlot(v:GetID())
		local itemLink = GetInventoryItemLink("player", v:GetID())
		if itemLink then
			local itemName, itemStringLink = GetItemInfo(itemLink)
			if itemStringLink then
				local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemStringLink,
				"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
				-- print(Enchant) --Enchant ID...because, ya know, let's not be logical, Blizzard...
				-- if (slot == CharacterHandsSlot) then
				-- 	if
				if (Enchant == "2523") then
					addon.hasBiznicks = true
				end
				if showenchant then
					v.enchant:SetTextColor(getItemQualityColor(item:GetItemQuality())) --upvalue call
					if abbrevEnchants then
						v.enchant:SetText(DCS_ABBREV_ENCHANT_IDS[tonumber(""..Enchant.."")])
					else
						v.enchant:SetText(DCS_ENCHANT_IDS[tonumber(""..Enchant.."")])
					end
				else
					v.enchant:SetText("")
				end
			end
			tooltip:ClearLines()
			tooltip:SetHyperlink(itemLink)
		end
	end
end

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowEnchantChecked = {
	ShowEnchantSetChecked = false,
}

local DCS_ShowEnchantCheck = CreateFrame("CheckButton", "DCS_ShowEnchantCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
DCS_ShowEnchantCheck:RegisterEvent("PLAYER_LOGIN")
DCS_ShowEnchantCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
DCS_ShowEnchantCheck:RegisterEvent("UNIT_STATS")

DCS_ShowEnchantCheck:ClearAllPoints()
	DCS_ShowEnchantCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -175)
	DCS_ShowEnchantCheck:SetScale(1)
	DCS_ShowEnchantCheck.tooltipText = L["Displays each equipped item's enchantment."].."\n\n\"Enchantment? Enchantment!\" -Sandal Feddic" --Creates a tooltip on mouseover.
	_G[DCS_ShowEnchantCheck:GetName() .. "Text"]:SetText(L["Enchants"])

DCS_ShowEnchantCheck:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		showenchant = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowEnchantChecked.ShowEnchantSetChecked
		self:SetChecked(showenchant)
	end
	if PaperDollFrame:IsVisible() then
		DCS_Set_Dura_Item_Positions()
		DCS_Item_Enchant_GetText() --Shouldn't be needed as there is never a time when the paperdoll wont have to be opened to display this.
		DCS_Set_Item_Quality_Color_Outlines() --Here to update on the events when PaperDoll is open.
	end
end)

DCS_ShowEnchantCheck:SetScript("OnClick", function(self)
	showenchant = not showenchant
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowEnchantChecked.ShowEnchantSetChecked = showenchant
	DCS_Set_Dura_Item_Positions() --is this call needed? (Yes, it is -Deja)
	DCS_Item_Enchant_GetText()
end)

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsAbbrevEnchantsChecked = {
	AbbrevEnchantsSetChecked = true,
}

local DCS_AbbrevEnchantsCheck = CreateFrame("CheckButton", "DCS_AbbrevEnchantsCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
DCS_AbbrevEnchantsCheck:RegisterEvent("PLAYER_LOGIN")
DCS_AbbrevEnchantsCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
DCS_AbbrevEnchantsCheck:RegisterEvent("UNIT_STATS")

DCS_AbbrevEnchantsCheck:ClearAllPoints()
	DCS_AbbrevEnchantsCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -195)
	DCS_AbbrevEnchantsCheck:SetScale(1)
	DCS_AbbrevEnchantsCheck.tooltipText = L["Displays an abbreviated label of each equipped item's enchantment."] --Creates a tooltip on mouseover.
	_G[DCS_AbbrevEnchantsCheck:GetName() .. "Text"]:SetText(L["Abbreviated Enchant Labels"])

DCS_AbbrevEnchantsCheck:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		abbrevEnchants = gdbprivate.gdb.gdbdefaults.DejaClassicStatsAbbrevEnchantsChecked.AbbrevEnchantsSetChecked
		self:SetChecked(abbrevEnchants)
	end
	if PaperDollFrame:IsVisible() then
		DCS_Set_Dura_Item_Positions()
		DCS_Item_Enchant_GetText() --Shouldn't be needed as there is never a time when the paperdoll wont have to be opened to display this.
		DCS_Set_Item_Quality_Color_Outlines() --Here to update on the events when PaperDoll is open.
	end
end)

DCS_AbbrevEnchantsCheck:SetScript("OnClick", function(self)
	abbrevEnchants = not abbrevEnchants
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsAbbrevEnchantsChecked.AbbrevEnchantsSetChecked = abbrevEnchants
	DCS_Set_Dura_Item_Positions() --is this call needed? (Yes, it is -Deja)
	DCS_Item_Enchant_GetText()
end)

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsAlternateInfoPlacement = {
	AlternateInfoPlacementChecked = false,
}

PaperDollFrame:HookScript("OnShow", function(self)
	if showitemlevel then
		DCS_Item_Level_Center()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.ilevel:SetFormattedText("")
		end
	end
	if showrepair then
		DCS_Item_RepairCostBottom()
		DCS_Set_Dura_Item_Positions()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.itemrepair:SetFormattedText("")
		end
	end
	if showavgdur then
		DCS_Mean_Durability()
		if addon.duraMean == 100 then --check after calculation
			duraMeanFS:SetFormattedText("")
		else
			duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
		end
	else
		duraMeanFS:SetFormattedText("")
		duraDurabilityFrameFS:Hide()
	end
	if showdura then
		DCS_Item_DurabilityTop()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.durability:SetFormattedText("")
		end
	end
	if showtextures then
		DCS_Durability_Bar_Textures()
		duraMeanTexture:Show()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.duratexture:Hide()
		end
		duraMeanTexture:Hide()
	end
	if showenchant then
		DCS_Item_Enchant_GetText()
	end
	DCS_Set_Item_Quality_Color_Outlines()
end)


-- local tempEnchantID = {
-- 	[256] = 600, -- (+75)
-- 	[263] = 600, -- (+25)
-- 	[264] = 600, -- (+50)
-- 	[265] = 600, -- (+75)
-- 	[266] = 600, -- (+100)
-- 	[3868] = 3600, -- (+100)
-- 	[4225] = 900, -- (+150)
-- 	[4264] = 600, -- (+15)
-- 	[4919] = 600, -- (+150)
-- 	[5386] = 600, -- (+200)
-- }

-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
-- itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
-- 	GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")

-- local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
-- print()
-- local duration = tempEnchantID[mainHandEnchantID] or 3600

local DCS_AlternateInfoPlacementCheck = CreateFrame("CheckButton", "DCS_AlternateInfoPlacementCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_AlternateInfoPlacementCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_AlternateInfoPlacementCheck:ClearAllPoints()
	--DCS_AlternateInfoPlacementCheck:SetPoint("TOPLEFT", 30, -255)
	DCS_AlternateInfoPlacementCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -155)
	DCS_AlternateInfoPlacementCheck:SetScale(1)
	DCS_AlternateInfoPlacementCheck.tooltipText = L["Displays the item's info beside each item's slot."] --Creates a tooltip on mouseover.
	_G[DCS_AlternateInfoPlacementCheck:GetName() .. "Text"]:SetText(L["Display Info Beside Items"])

DCS_AlternateInfoPlacementCheck:SetScript("OnEvent", function(self, event, ...)
	otherinfoplacement = gdbprivate.gdb.gdbdefaults.DejaClassicStatsAlternateInfoPlacement.AlternateInfoPlacementChecked
	self:SetChecked(otherinfoplacement)
	DCS_Set_Dura_Item_Positions()
	DCS_Item_Level_Center()
	DCS_Item_Enchant_GetText()
end)

DCS_AlternateInfoPlacementCheck:SetScript("OnClick", function(self)
	otherinfoplacement = not otherinfoplacement
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsAlternateInfoPlacement.AlternateInfoPlacementChecked = otherinfoplacement
	DCS_Set_Dura_Item_Positions()
end)

gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsItemQualityBorders = {
	ItemQualityBordersChecked = true,
}

local DCS_ItemQualityBordersCheck = CreateFrame("CheckButton", "DCS_ItemQualityBordersCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ItemQualityBordersCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ItemQualityBordersCheck:ClearAllPoints()
	--DCS_ItemQualityBordersCheck:SetPoint("TOPLEFT", 30, -255)
	DCS_ItemQualityBordersCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -215)
	DCS_ItemQualityBordersCheck:SetScale(1)
	DCS_ItemQualityBordersCheck.tooltipText = L["Displays a colored border around each item's slot indicating its quality."] --Creates a tooltip on mouseover.
	_G[DCS_ItemQualityBordersCheck:GetName() .. "Text"]:SetText(L["Item Quality Borders"])

DCS_ItemQualityBordersCheck:SetScript("OnEvent", function(self, event, ...)
	qualityBordersChecked = gdbprivate.gdb.gdbdefaults.DejaClassicStatsItemQualityBorders.ItemQualityBordersChecked
	self:SetChecked(qualityBordersChecked)
	-- DCS_Set_Item_Quality_Color_Outlines() -- Don't use at login (only set check) as items are not cached until paperdoll has been opened thus error occurs as all item info is nil
end)

DCS_ItemQualityBordersCheck:SetScript("OnClick", function(self)
	qualityBordersChecked = not qualityBordersChecked
	gdbprivate.gdb.gdbdefaults.DejaClassicStatsItemQualityBorders.ItemQualityBordersChecked = qualityBordersChecked
	DCS_Set_Item_Quality_Color_Outlines()
end)
