-------------------
---NovaWorldBuffs--
-------------------

local addonName, addon = ...;
local NWB = addon.a;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs");

function NWB:createNaxxMarkers()
	--This icon was part of the original art Blizzard released with the 1.11 patch.
	--This exact cut of this image was linked to me and I think is from warcraft logs.
	local iconLocation = "Interface\\AddOns\\NovaWorldBuffs\\Media\\Naxx.tga";
	--Worldmap marker.
	local obj = CreateFrame("Frame", "NWBNaxxMarker", WorldMapFrame);
	local bg = obj:CreateTexture(nil, "ARTWORK");
	bg:SetTexture(iconLocation);
	bg:SetAllPoints(obj);
	obj.texture = bg;
	obj:SetSize(15, 15);
	--World map tooltip.
	obj.tooltip = CreateFrame("Frame", "NWBNaxxMarkerTooltip", WorldMapFrame, "TooltipBorderedFrameTemplate");
	obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 22);
	obj.tooltip:SetFrameStrata("TOOLTIP");
	obj.tooltip:SetFrameLevel(9);
	obj.tooltip.fs = obj.tooltip:CreateFontString("NWBNaxxMarkerTooltipFS", "ARTWORK");
	obj.tooltip.fs:SetPoint("CENTER", 0, 0);
	obj.tooltip.fs:SetFont(NWB.regionFont, 11.5);
	obj.tooltip.fs:SetText("|CffDEDE42Naxxramas");
	obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 14);
	obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
	obj:SetScript("OnEnter", function(self)
		obj.tooltip:Show();
	end)
	obj:SetScript("OnLeave", function(self)
		obj.tooltip:Hide();
	end)
	obj.tooltip:Hide();
	
	--Minimap marker.
	local obj = CreateFrame("FRAME", "NWBNaxxMarkerMini");
	local bg = obj:CreateTexture(nil, "ARTWORK");
	bg:SetTexture(iconLocation);
	bg:SetAllPoints(obj);
	obj.texture = bg;
	obj:SetSize(13, 13);
	--Minimap tooltip.
	obj.tooltip = CreateFrame("Frame", "NWBNaxxMarkerMiniTooltip", MinimMapFrame, "TooltipBorderedFrameTemplate");
	obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 12);
	obj.tooltip:SetFrameStrata("TOOLTIP");
	obj.tooltip:SetFrameLevel(9);
	obj.tooltip.fs = obj.tooltip:CreateFontString("NWBNaxxMarkerMiniTooltipFS", "ARTWORK");
	obj.tooltip.fs:SetPoint("CENTER", 0, 0.5);
	obj.tooltip.fs:SetFont(NWB.regionFont, 8);
	obj.tooltip.fs:SetText("|CffDEDE42Naxxramas");
	obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 10);
	obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
	obj:SetScript("OnEnter", function(self)
		obj.tooltip:Show();
	end)
	obj:SetScript("OnLeave", function(self)
		obj.tooltip:Hide();
	end)
	obj.tooltip:Hide();
	NWB:refreshNaxxMarkers();
end

local showNaxxArrow;
function NWB:refreshNaxxMarkers()
	NWB.dragonLibPins:RemoveWorldMapIcon("NWBNaxxMarker", _G["NWBNaxxMarker"]);
	NWB.dragonLibPins:RemoveMinimapIcon("NWBNaxxMarkerMini", _G["NWBNaxxMarkerMini"]);
	if (NWB.db.global.showNaxxWorldmapMarkers) then
		NWB.dragonLibPins:AddWorldMapIconMap("NWBNaxxMarker", _G["NWBNaxxMarker"], 1423, 0.39939300906494, 0.25840189134418);
	end
	if (NWB.db.global.showNaxxMinimapMarkers) then
		NWB.dragonLibPins:AddMinimapIconMap("NWBNaxxMarkerMini", _G["NWBNaxxMarkerMini"], 1423, 0.39939300906494, 0.25840189134418, nil, showNaxxArrow);
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_DEAD");
f:RegisterEvent("PLAYER_UNGHOST");
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_DEAD") then
		local _, _, _, _, _, _, _, instanceID = GetInstanceInfo();
		if (instanceID == 533) then
			showNaxxArrow = true;
			NWB:refreshNaxxMarkers();
		end
	elseif (event == "PLAYER_UNGHOST") then
		if (showNaxxArrow) then
			showNaxxArrow = nil;
			NWB:refreshNaxxMarkers();
		end
	end
end)

if (not NWB.isSOD) then
	return;
end
function NWB:createExtraDungMarkers()
	local markers = {
		[1] = {
			icon = "Interface\\Icons\\Ability_mount_drake_azure",
			tooltip = "Azuregos",
			zone = 1447,
			x = 0.43610526270177,
			y = 0.83763884877542,
		},
		[2] = {
			icon = "Interface\\Icons\\Achievement_boss_kiljaedan",
			tooltip = "Lord Kazzak",
			zone = 1419,
			x = 0.47189059380033,
			y = 0.54758248379708,
		},
	};
	for k, v in pairs(markers) do
		--Worldmap marker.
		local obj = CreateFrame("Frame", "NWBExtraDungMarker" .. k, WorldMapFrame);
		obj.texture = obj:CreateTexture(nil, "ARTWORK");
		obj.texture:SetTexture(v.icon);
		obj.texture:SetAllPoints(obj);
		obj:SetSize(15, 15);
		--World map tooltip.
		obj.tooltip = CreateFrame("Frame", "NWBExtraDungMarkerTooltip" .. k, WorldMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 22);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString("NWBExtraDungMarkerTooltipFS" .. k, "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 1);
		obj.tooltip.fs:SetFont(NWB.regionFont, 11.5);
		obj.tooltip.fs:SetText("|CffDEDE42" .. v.tooltip);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 16);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 11);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		
		--Minimap marker.
		local obj = CreateFrame("FRAME", "NWBExtraDungMarkerMini" .. k);
		obj.texture = obj:CreateTexture(nil, "ARTWORK");
		obj.texture:SetTexture(v.icon);
		obj.texture:SetAllPoints(obj);
		obj:SetSize(13, 13);
		--Minimap tooltip.
		obj.tooltip = CreateFrame("Frame", "NWBExtraDungMarkerMiniTooltip" .. k, MinimMapFrame, "TooltipBorderedFrameTemplate");
		obj.tooltip:SetPoint("CENTER", obj, "CENTER", 0, 12);
		obj.tooltip:SetFrameStrata("TOOLTIP");
		obj.tooltip:SetFrameLevel(9);
		obj.tooltip.fs = obj.tooltip:CreateFontString("NWBExtraDungMarkerMiniTooltipFS" .. k, "ARTWORK");
		obj.tooltip.fs:SetPoint("CENTER", 0, 0.5);
		obj.tooltip.fs:SetFont(NWB.regionFont, 8);
		obj.tooltip.fs:SetText("|CffDEDE42" .. v.tooltip);
		obj.tooltip:SetWidth(obj.tooltip.fs:GetStringWidth() + 10);
		obj.tooltip:SetHeight(obj.tooltip.fs:GetStringHeight() + 9);
		obj:SetScript("OnEnter", function(self)
			obj.tooltip:Show();
		end)
		obj:SetScript("OnLeave", function(self)
			obj.tooltip:Hide();
		end)
		obj.tooltip:Hide();
		NWB.dragonLibPins:RemoveWorldMapIcon("NWBExtraDungMarker" .. k, _G["NWBExtraDungMarker" .. k]);
		NWB.dragonLibPins:RemoveMinimapIcon("NWBExtraDungMarkerMini" .. k, _G["NWBExtraDungMarkerMini" .. k]);
		if (NWB.db.global.showNaxxWorldmapMarkers) then
			NWB.dragonLibPins:AddWorldMapIconMap("NWBExtraDungMarker" .. k, _G["NWBExtraDungMarker" .. k], v.zone, v.x, v.y);
		end
		if (NWB.db.global.showNaxxMinimapMarkers) then
			NWB.dragonLibPins:AddMinimapIconMap("NWBExtraDungMarkerMini" .. k, _G["NWBExtraDungMarkerMini" .. k], v.zone, v.x, v.y);
		end
	end
end