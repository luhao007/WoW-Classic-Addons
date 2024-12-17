local addonName, addonTable = ...;
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
-------
local Mapfun=addonTable.Mapfun
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
	WorldMapScrollChild.zuobiaoXYFFFX = CreateFrame("Frame", nil, WorldMapScrollChild);
	local zuobiaoXYFFF,FontSize=WorldMapScrollChild.zuobiaoXYFFFX,11
	zuobiaoXYFFF:SetSize(600,32);
	zuobiaoXYFFF:SetPoint("BOTTOMLEFT",WorldMapScrollChild,"BOTTOMLEFT",10,0);
	zuobiaoXYFFF:SetFrameLevel(3000)
	zuobiaoXYFFF:SetIgnoreParentScale(true)
	zuobiaoXYFFF.zuobiaoX = PIGFontString(zuobiaoXYFFF,{"BOTTOMLEFT", zuobiaoXYFFF, "BOTTOMLEFT", 40, 2},"玩家 X:","OUTLINE",FontSize)
	zuobiaoXYFFF.zuobiaoX:SetTextColor(0, 1, 0, 1);
	zuobiaoXYFFF.zuobiaoXV = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.zuobiaoX, "RIGHT", 0, 0},"","OUTLINE",FontSize+1)
	zuobiaoXYFFF.zuobiaoXV:SetTextColor(1, 1, 0, 1);

	zuobiaoXYFFF.zuobiaoY = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.zuobiaoX, "RIGHT", 60, 0},"Y:","OUTLINE",FontSize)
	zuobiaoXYFFF.zuobiaoY:SetTextColor(0, 1, 0, 1);
	zuobiaoXYFFF.zuobiaoYV = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.zuobiaoY, "RIGHT", 0, 0},"","OUTLINE",FontSize+1)
	zuobiaoXYFFF.zuobiaoYV:SetTextColor(1, 1, 0, 1);

	zuobiaoXYFFF.shubiaoX = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.zuobiaoY, "RIGHT", 80, 0},"鼠标 X:","OUTLINE",FontSize)
	zuobiaoXYFFF.shubiaoX:SetTextColor(0, 1, 0, 1);
	zuobiaoXYFFF.shubiaoXV = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.shubiaoX, "RIGHT", 0, 0},"","OUTLINE",FontSize+1)
	zuobiaoXYFFF.shubiaoXV:SetTextColor(1, 1, 0, 1);

	zuobiaoXYFFF.shubiaoY = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.shubiaoX, "RIGHT", 60, 0},"Y:","OUTLINE",FontSize)
	zuobiaoXYFFF.shubiaoY:SetTextColor(0, 1, 0, 1);
	zuobiaoXYFFF.shubiaoYV = PIGFontString(zuobiaoXYFFF,{"LEFT", zuobiaoXYFFF.shubiaoY, "RIGHT", 0, 0},"","OUTLINE",FontSize+1)
	zuobiaoXYFFF.shubiaoYV:SetTextColor(1, 1, 0, 1);
	zuobiaoXYFFF:HookScript("OnUpdate", function(self)
		local mapinfo = C_Map.GetBestMapForUnit("player"); 
		if not mapinfo then return end
		local pos = C_Map.GetPlayerMapPosition(mapinfo,"player");
		if not pos then return end
		--local zuobiaoBB = C_Map.GetMapInfo(mapinfo).name, 
		local zuobiaoXX,zuobiaoYY = math.ceil(pos.x*10000)/100, math.ceil(pos.y*10000)/100
		zuobiaoXYFFF.zuobiaoXV:SetText(zuobiaoXX);
		zuobiaoXYFFF.zuobiaoYV:SetText(zuobiaoYY);
		local xxx, yyy = MouseXY()
		if xxx and yyy then
			local xxx =math.ceil(xxx*10000)/100
			local yyy =math.ceil(yyy*10000)/100
			self.shubiaoXV:SetText(xxx);
			self.shubiaoYV:SetText(yyy);
		end
	end);
end
---战争迷雾
-- local MapData=addonTable.MapData