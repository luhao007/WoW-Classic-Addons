local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
-----------
local Mapfun=addonTable.Mapfun
--
function Mapfun.Minimap_XY()
	if Minimap.PIG_XY then
		Minimap.PIG_XY:SetShown(PIGA["Map"]["MinimapXY"]) 
		return
	end
	if not PIGA["Map"]["MinimapXY"] then return end
	Minimap.PIG_XY = CreateFrame("Frame", nil, Minimap);
	Minimap.PIG_XY:SetSize(60,16);
	if PIG_MaxTocversion(60000) then
		Minimap.PIG_XY:SetPoint("TOP",Minimap,"TOP",0,0);
	else
		Minimap.PIG_XY:SetPoint("TOP",Minimap,"TOP",60,12);
	end
	Minimap.PIG_XY.zuobiaoX = PIGFontString(Minimap.PIG_XY,{"TOP", Minimap.PIG_XY, "TOP", 0, 0},"","OUTLINE")
	Minimap.PIG_XY.zuobiaoX:SetTextColor(1, 1, 0, 1);
	Minimap.PIG_XY:RegisterEvent("PLAYER_ENTERING_WORLD")
	Minimap.PIG_XY:HookScript("OnEvent", function (self,event,arg1)
		if event=="PLAYER_ENTERING_WORLD" then
			local inInstance, instanceType =IsInInstance()
			self.inInstance=inInstance
		end		
	end)
	Minimap.PIG_XY.fpsTime = 0;
	Minimap.PIG_XY:SetScript("OnUpdate", function (self,elapsed)
		if self.inInstance then
			self.zuobiaoX:SetText("--    --");
		else
			local timeLeft = self.fpsTime - elapsed
			if timeLeft <= 0 then
				self.fpsTime = 0.25;
				local mapinfo = C_Map.GetBestMapForUnit("player"); 
				if not mapinfo then return end
				local pos = C_Map.GetPlayerMapPosition(mapinfo,"player");
				if not pos then return end
				self.zuobiaoX:SetText(format("%.1f",pos.x*100).."   "..format("%.1f",pos.y*100));
			else
				self.fpsTime = timeLeft;
			end
		end
	end)
end
function Mapfun.Minimap_Hide()
	if not PIGA["Map"]["MinimapHide"] then return end
	MinimapCluster:SetSize(34,192);
	MinimapCluster:UnregisterAllEvents();
	local ziframe = {MinimapCluster:GetChildren()}
	for k,v in pairs(ziframe) do
		v:ClearAllPoints();
		v:Hide()
	end
	local regions = {MinimapCluster:GetRegions()} 
	for k,v in pairs(regions) do
		v:ClearAllPoints();
		v:Hide()
	end
end
--移动小地图
function Mapfun.Minimap_Move()
	if PIGA["Map"]["MinimapHide"] then return end
	if not PIGA["Map"]["MinimapMove"] then return end
	if Mapfun.Moveopen then return end
	Mapfun.Moveopen=true
	function Mapfun.Minimap_MoveUpdate()
		if not PIGA["Map"]["MinimapMove"] then return end
		MinimapCluster:SetSize(34,192);
		GameTimeFrame:SetSize(34,34);
		GameTimeFrame:ClearAllPoints();
		GameTimeFrame:SetPoint("TOPRIGHT",MinimapCluster,"TOPRIGHT",4,0);
		Minimap:ClearAllPoints();
		Minimap:SetPoint(PIGA["Map"]["MinimapAnchor"],UIParent,PIGA["Map"]["MinimapAnchor"],PIGA["Map"]["MinimapPointX"],PIGA["Map"]["MinimapPointY"]-22);
	end
	Mapfun.Minimap_MoveUpdate()
	if not Mapfun.MiniMapBut.DiyMiniMapFun then
		MinimapBackdrop:ClearAllPoints();
		MinimapBackdrop:SetPoint("CENTER",Minimap,"CENTER",-8,-22);
		local BorderTop=MinimapBorderTop or MinimapCluster.BorderTop
		BorderTop:ClearAllPoints();
		BorderTop:SetPoint("TOP",Minimap,"TOP",-6,24);
		if MinimapZoneTextButton then
			MinimapZoneTextButton:ClearAllPoints();
			MinimapZoneTextButton:SetPoint("TOP",Minimap,"TOP",0,17);
		end
		if MinimapToggleButton then
			MinimapToggleButton:ClearAllPoints();
			MinimapToggleButton:SetPoint("TOPRIGHT",MinimapBorderTop,"TOPRIGHT",-2,-2);
		end
	end
end