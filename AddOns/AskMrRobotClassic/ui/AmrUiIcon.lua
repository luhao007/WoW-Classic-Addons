--[[-----------------------------------------------------------------------------
Icon Container
Simple container widget that is an icon, and can optionally contain children.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiIcon", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function setIconBorderWidth(frame, icon, width)
	icon:ClearAllPoints()
	icon:SetPoint("TOPLEFT", frame, "TOPLEFT", width, -width)
	icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -width, width)
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]

local function frameOnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function frameOnLeave(frame)
	frame.obj:Fire("OnLeave")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetAutoAdjustHeight(false)
		self:SetWidth(64)
		self:SetHeight(64)
		self:SetBorderWidth(2)
		self:HideIconBorder()
		self:SetIcon(nil)
		self:SetStrata("FULLSCREEN_DIALOG")
		self:SetLevel(0)
		self:SetVisible(true)
		self.frame:ClearAllPoints()
		self.icon:SetDesaturated(false)
	end,

	["SetIcon"] = function(self, icon)
		if not icon then
			self.icon:SetColorTexture(0, 0, 0, 0)
		else
			self.icon:SetTexture(icon)
		end
	end,
	
	["SetBorderWidth"] = function(self, width)
		setIconBorderWidth(self.frame, self.icon, width)
	end,
	
	["SetIconBorderColor"] = function(self, color, a)
		self.bg:SetColorTexture(color.R, color.G, color.B, a or 1)
	end,
	
	["HideIconBorder"] = function(self)
		self.bg:SetColorTexture(0, 0, 0, 0)
	end,
	
	["SetStrata"] = function(self, strata)
		self.frame:SetFrameStrata(strata)
	end,
	
	["SetLevel"] = function(self, level)
		self.frame:SetFrameLevel(level)
	end,

	
	["SetVisible"] = function(self, visible)
		if visible then
			self.frame:Show()
		else
			self.frame:Hide()
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	frame:SetScript("OnEnter", frameOnEnter)
	frame:SetScript("OnLeave", frameOnLeave)
	
	local bg = frame:CreateTexture(nil, "BORDER")
	bg:SetAllPoints()
	
	local icon = frame:CreateTexture(nil, "ARTWORK", nil, 1)
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	
	local borderTop = frame:CreateTexture(nil, "ARTWORK", nil, 2)
	borderTop:SetColorTexture(0, 0, 0, 1)
	borderTop:SetHeight(1)
	borderTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
	borderTop:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
	
	local borderRight = frame:CreateTexture(nil, "ARTWORK", nil, 2)
	borderRight:SetColorTexture(0, 0, 0, 1)
	borderRight:SetWidth(1)
	borderRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
	borderRight:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")
	
	local borderBottom = frame:CreateTexture(nil, "ARTWORK", nil, 2)
	borderBottom:SetColorTexture(0, 0, 0, 1)
	borderBottom:SetHeight(1)
	borderBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
	borderBottom:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")
	
	local borderLeft = frame:CreateTexture(nil, "ARTWORK", nil, 2)
	borderLeft:SetColorTexture(0, 0, 0, 1)
	borderLeft:SetWidth(1)
	borderLeft:SetPoint("TOPLEFT", icon, "TOPLEFT")
	borderLeft:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
	
	local widget = {
		bg        = bg,
		icon      = icon,
		frame     = frame,
		content   = frame,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
