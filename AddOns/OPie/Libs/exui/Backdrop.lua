local _, T = ...
local XU = T.exUI
local assert, getWidgetData, _newWidgetData, setWidgetData = XU:GetImpl()

local edgeSlices = {
	{"TOPLEFT", 0, -1, "BOTTOMRIGHT", "BOTTOMLEFT", 1, 1}, -- L
	{"TOPRIGHT", 0, -1, "BOTTOMLEFT", "BOTTOMRIGHT", -1, 1}, -- R
	{"TOPLEFT", 1, 0, "BOTTOMRIGHT", "TOPRIGHT", -1, -1, ccw=true}, -- T
	{"BOTTOMLEFT", 1, 0, "TOPRIGHT", "BOTTOMRIGHT", -1, 1, ccw=true}, -- B
	{"TOPLEFT", 0, 0, "BOTTOMRIGHT", "TOPLEFT", 1, -1},
	{"TOPRIGHT", 0, 0, "BOTTOMLEFT", "TOPRIGHT", -1, -1},
	{"BOTTOMLEFT", 0, 0, "TOPRIGHT", "BOTTOMLEFT", 1, 1},
	{"BOTTOMRIGHT", 0, 0, "TOPLEFT", "BOTTOMRIGHT", -1, 1}
}
local function unpackColor(c)
	local c0, c1, c2 = c % 2^8, c % 2^16, c % 2^24
	return (c2 - c1) / (2^16 * 255), (c1 - c0) / (2^8 * 255), c0 / 255, c > c2 and (c - c2) / (2^24 * 255) or 1
end

local Backdrop, BackdropData = {}, {}
function Backdrop:SetBackdrop(info)
	local d = assert(getWidgetData(self, BackdropData), "Invalid object type")
	assert(type(info) == "table", 'Syntax: Backdrop:SetBackdrop(props)')
	if info.bgFile then
		local bg, insets = d.bg or d.host:CreateTexture(), info.insets
		local tileH, tileV = not not (info.tileH == nil and info.tile or info.tileH), not not (info.tileV == nil and info.tile or info.tileV)
		bg:SetDrawLayer("BACKGROUND", info.bgSubLevel or info.subLevel or -7)
		bg:SetTexture(info.bgFile, tileH, tileV)
		bg:SetHorizTile(tileH)
		bg:SetVertTile(tileV)
		bg:SetPoint("TOPLEFT", (insets and insets.left or 0), -(insets and insets.top or 0))
		bg:SetPoint("BOTTOMRIGHT", -(insets and insets.right or 0), (insets and insets.bottom or 0))
		bg:SetVertexColor(unpackColor(info.bgColor or 0xffffff))
		bg:Show()
		d.bg = bg
	elseif d.bg then
		d.bg:Hide()
	end
	if info.edgeFile then
		local ed, esz = d.edge, info.edgeSize or 39
		for i=1,#edgeSlices do
			local t, s = ed[i] or d.host:CreateTexture(), edgeSlices[i]
			ed[i] = t
			t:SetDrawLayer("BORDER", info.edgeSubLevel or info.subLevel or -7)
			t:SetTexture(info.edgeFile)
			t:SetPoint(s[1], s[2]*esz, s[3]*esz)
			t:SetPoint(s[4], d.host, s[5], s[6]*esz, s[7]*esz)
			local x1, x2, y1, y2 = 1/128+(i-1)/8, i/8-1/128, 0.0625, 1-0.0625
			if s.ccw then
				t:SetTexCoord(x1,y2, x2,y2, x1,y1, x2,y1)
			else
				t:SetTexCoord(x1, x2, y1, y2)
			end
		end
		ed:SetVertexColor(unpackColor(info.edgeColor or 0xffffff))
	elseif d.edge[1] then
		d.edge:Hide()
	end
end

local backdrop_mt = {__index=Backdrop}
local function CreateBackdrop(f, info)
	assert(type(f) == "table" and type(f.IsObjectType) == "function" and f:IsObjectType("Frame")
	       and (info == nil or type(info) == "table"), 'Syntax: Create("Backdrop", parent[, props])')
	local r = setmetatable({[0]=newproxy()}, backdrop_mt)
	setWidgetData(r, BackdropData, {self=r, host=f, edge=XU:Create("ObjectGroup")})
	if info then r:SetBackdrop(info) end
	return r
end
XU:RegisterFactory("Backdrop", CreateBackdrop)