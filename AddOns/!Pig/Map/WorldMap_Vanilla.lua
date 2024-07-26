local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
local Mapfun=addonTable.Mapfun

----------
local WorldMapScrollChild = WorldMapFrame.ScrollContainer.Child
local function MouseXY()
	local left, top = WorldMapScrollChild:GetLeft(), WorldMapScrollChild:GetTop()
	local width, height = WorldMapScrollChild:GetWidth(), WorldMapScrollChild:GetHeight()
	local scale = WorldMapScrollChild:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end
	return cx, cy
end
function Mapfun.WorldMap_XY()
	if not PIGA["Map"]["WorldMapXY"] then return end
	WorldMapFrame.zuobiaoX = PIGFontString(WorldMapFrame,nil,"玩家 X:","OUTLINE")
	if tocversion<30000 then
		WorldMapFrame.zuobiaoX:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM", -200, 9);
	else
		WorldMapFrame.zuobiaoX:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 120, 9);
	end
	WorldMapFrame.zuobiaoX:SetTextColor(0, 1, 0, 1);
	WorldMapFrame.zuobiaoXV = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.zuobiaoX, "RIGHT", 0, 0},"","OUTLINE")
	WorldMapFrame.zuobiaoXV:SetTextColor(1, 1, 0, 1);

	WorldMapFrame.zuobiaoY = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.zuobiaoX, "RIGHT", 40, 0},"Y:","OUTLINE")
	WorldMapFrame.zuobiaoY:SetTextColor(0, 1, 0, 1);
	WorldMapFrame.zuobiaoYV = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.zuobiaoY, "RIGHT", 0, 0},"","OUTLINE")
	WorldMapFrame.zuobiaoYV:SetTextColor(1, 1, 0, 1);

	WorldMapFrame.shubiaoX = PIGFontString(WorldMapFrame,nil,"鼠标 X:","OUTLINE")
	if tocversion<30000 then
		WorldMapFrame.shubiaoX:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM", 100, 9);
	else
		WorldMapFrame.shubiaoX:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 280, 9);
	end
	WorldMapFrame.shubiaoX:SetTextColor(0, 1, 0, 1);
	WorldMapFrame.shubiaoXV = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.shubiaoX, "RIGHT", 0, 0},"","OUTLINE")
	WorldMapFrame.shubiaoXV:SetTextColor(1, 1, 0, 1);

	WorldMapFrame.shubiaoY = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.shubiaoX, "RIGHT", 40, 0},"Y:","OUTLINE")
	WorldMapFrame.shubiaoY:SetTextColor(0, 1, 0, 1);
	WorldMapFrame.shubiaoYV = PIGFontString(WorldMapFrame,{"LEFT", WorldMapFrame.shubiaoY, "RIGHT", 0, 0},"","OUTLINE")
	WorldMapFrame.shubiaoYV:SetTextColor(1, 1, 0, 1);
	
	WorldMapFrame:HookScript("OnUpdate", function(self)
		local mapinfo = C_Map.GetBestMapForUnit("player"); 
		if not mapinfo then return end
		local pos = C_Map.GetPlayerMapPosition(mapinfo,"player");
		if not pos then return end
		--local zuobiaoBB = C_Map.GetMapInfo(mapinfo).name, 
		local zuobiaoXX,zuobiaoYY = math.ceil(pos.x*10000)/100, math.ceil(pos.y*10000)/100
		self.zuobiaoXV:SetText(zuobiaoXX);
		self.zuobiaoYV:SetText(zuobiaoYY);
		local xxx, yyy = MouseXY()
		if xxx and yyy then
			local xxx =math.ceil(xxx*10000)/100
			local yyy =math.ceil(yyy*10000)/100
			self.shubiaoXV:SetText(xxx);
			self.shubiaoYV:SetText(yyy);
		end
	end);
end
----
function Mapfun.WorldMap_Wind()
	if not PIGA["Map"]["WorldMapWind"] then return end
	if tocversion<40000 then
		---SetCVar("miniWorldMap", 0)
		UIPanelWindows["WorldMapFrame"] = nil
		WorldMapFrame:SetIgnoreParentScale(false)
		--WorldMapFrame:SetScale(0.9)
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
		    local x,y = MapCanvasScrollControllerMixin.GetCursorPosition(f);
		    --local s = WorldMapFrame:GetScale();
		    local s = WorldMapFrame:GetScale() * UIParent:GetScale()
		    return x/s, y/s;
		end
		hooksecurefunc(WorldMapFrame.BlackoutFrame, "Show", function()
			WorldMapFrame.BlackoutFrame:Hide()
		end)
		hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", function(self)
			if self:IsMaximized() then
				if self.QuestLog:IsShown() then
					if PIGA["WowUI"]["WorldMapFrame"] and PIGA["WowUI"]["WorldMapFrame"]["Point"] then
						local point, relativeTo, relativePoint, offsetX, offsetY=unpack(PIGA["WowUI"]["WorldMapFrame"]["Point"])
						self:ClearAllPoints();
						self:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
					end
				end
			else
				if WorldMapTrackQuest then
					WorldMapTrackQuest:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 10, 99994);
				end
			end
			self:OnFrameSizeChanged();
		end)
	else

	end
end

---
function Mapfun.WorldMap_LVSkill()
	if not PIGA["Map"]["WorldMapLV"] and not PIGA["Map"]["WorldMapSkill"] then return end
	local floor = math.floor
	local format = string.format
	local zoneData=addonTable.Mapfun.zoneData
	local AreaLabel_OnUpdate = function(self)
		self:SetScale(0.6)
		self:ClearLabel(MAP_AREA_LABEL_TYPE.AREA_NAME)
		local map = self.dataProvider:GetMap()
		if (map:IsCanvasMouseFocus()) then
			local name, description
			local mapID = map:GetMapID()
			local normalizedCursorX, normalizedCursorY = MouseXY()
			if mapID and normalizedCursorX and normalizedCursorY then
				local positionMapInfo = C_Map.GetMapInfoAtPosition(mapID, normalizedCursorX, normalizedCursorY)	
				if (positionMapInfo and (positionMapInfo.mapID ~= mapID)) then
					name = positionMapInfo.name
					local playerMinLevel, playerMaxLevel, playerminFish, playerFaction
					--local playerMinLevel, playerMaxLevel, petMinLevel, petMaxLevel = C_Map.GetMapLevels(positionMapInfo.mapID)
					if (zoneData[positionMapInfo.mapID]) then
						playerMinLevel = zoneData[positionMapInfo.mapID].min
						playerMaxLevel = zoneData[positionMapInfo.mapID].max
						playerminFish = zoneData[positionMapInfo.mapID].minFish
						playerFaction = zoneData[positionMapInfo.mapID].faction
					end
					if (playerFaction) then 
						local englishFaction, localizedFaction = UnitFactionGroup("player")
						if (playerFaction == "Alliance") then 
							description = format(FACTION_CONTROLLED_TERRITORY, FACTION_ALLIANCE) 
						elseif (playerFaction == "Horde") then 
							description = format(FACTION_CONTROLLED_TERRITORY, FACTION_HORDE) 
						end 
						if (englishFaction == playerFaction) then 
							description = "|cff00FF00" .. description .. "|r"
						else
							description = "|cffFF0000" .. description .. "|r"
						end 
					end
					if (name and playerMinLevel and playerMaxLevel and (playerMinLevel > 0) and (playerMaxLevel > 0)) then
						local playerLevel = UnitLevel("player")
						local colorbb="|cffFFFF00"
						if (playerLevel < playerMinLevel) then
							colorbb="|cffFF0000"
						elseif (playerLevel > playerMaxLevel+2) then
							colorbb="|cff808080"
						elseif (playerLevel > playerMaxLevel) then
							colorbb="|cff00FF00"
						end
						if PIGA["Map"]["WorldMapLV"] then
							name = name..colorbb.." ("..playerMinLevel.."-"..playerMaxLevel..")|r"
						end
						if PIGA["Map"]["WorldMapSkill"] then
							if playerminFish then
								name = name.."\n渔点|cff00FFFF("..playerminFish..")|r"
							end
						end
					end
				else
					name = MapUtil.FindBestAreaNameAtMouse(mapID, normalizedCursorX, normalizedCursorY)
				end
				if name then
					self:SetLabel(MAP_AREA_LABEL_TYPE.AREA_NAME, name, description)
				end
			end
		end
		self:EvaluateLabels()
	end
	for provider in next, WorldMapFrame.dataProviders do
		if provider.setAreaLabelCallback then
			provider.Label:HookScript("OnUpdate", AreaLabel_OnUpdate)
		end
	end
end
---战争迷雾
function Mapfun.WorldMap_Miwu()
	if not PIGA["Map"]["WorldMapMiwu"] then return end
	local Reveal=addonTable.Mapfun.Reveal
	local overlayTextures = {}

	local function MapExplorationPin_RefreshOverlays(pin, fullUpdate)
		overlayTextures = {}
		local mapID = WorldMapFrame.mapID; if not mapID then return end
		local artID = C_Map.GetMapArtID(mapID); if not artID or not Reveal[artID] then return end
		local LeaMapsZone = Reveal[artID]

		local TileExists = {}
		local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
		if exploredMapTextures then
			for i, exploredTextureInfo in ipairs(exploredMapTextures) do
				local key = exploredTextureInfo.textureWidth .. ":" .. exploredTextureInfo.textureHeight .. ":" .. exploredTextureInfo.offsetX .. ":" .. exploredTextureInfo.offsetY
				TileExists[key] = true
			end
		end

		pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
		local layers = C_Map.GetMapArtLayers(mapID)
		local layerInfo = layers and layers[pin.layerIndex]
		if not layerInfo then return end
		local TILE_SIZE_WIDTH = layerInfo.tileWidth
		local TILE_SIZE_HEIGHT = layerInfo.tileHeight

		for key, files in pairs(LeaMapsZone) do
			if not TileExists[key] then
				local width, height, offsetX, offsetY = strsplit(":", key)
				local fileDataIDs = { strsplit(",", files) }
				local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
				local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
				local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
				for j = 1, numTexturesTall do
					if ( j < numTexturesTall ) then
						texturePixelHeight = TILE_SIZE_HEIGHT
						textureFileHeight = TILE_SIZE_HEIGHT
					else
						texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
						if ( texturePixelHeight == 0 ) then
							texturePixelHeight = TILE_SIZE_HEIGHT
						end
						textureFileHeight = 16
						while(textureFileHeight < texturePixelHeight) do
							textureFileHeight = textureFileHeight * 2
						end
					end
					for k = 1, numTexturesWide do
						local texture = pin.overlayTexturePool:Acquire()
						if ( k < numTexturesWide ) then
							texturePixelWidth = TILE_SIZE_WIDTH
							textureFileWidth = TILE_SIZE_WIDTH
						else
							texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
							if ( texturePixelWidth == 0 ) then
								texturePixelWidth = TILE_SIZE_WIDTH
							end
							textureFileWidth = 16
							while(textureFileWidth < texturePixelWidth) do
								textureFileWidth = textureFileWidth * 2
							end
						end
						texture:SetSize(texturePixelWidth, texturePixelHeight)
						texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
						texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
						texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
						texture:SetDrawLayer("ARTWORK", -1)
						texture:Show()
						if fullUpdate then
							pin.textureLoadGroup:AddTexture(texture)
						end
						texture:SetVertexColor(0, 1, 0.1, 1)
						tinsert(overlayTextures, texture)
					end
				end
			end
		end
	end

	local function TexturePool_ResetVertexColor(pool, texture)
		texture:SetVertexColor(1, 1, 1)
		texture:SetAlpha(1)
		return TexturePool_HideAndClearAnchors(pool, texture)
	end

	for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		hooksecurefunc(pin, "RefreshOverlays", MapExplorationPin_RefreshOverlays)
		pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
	end
end