--[[-----------------------------------------------------------------------------
Panel Container
Simple container widget that is just a panel that can have a background color
and contains other widgets.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiPanel", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent


--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetAutoAdjustHeight(false)
		self:SetWidth(300)
		self:SetHeight(100)
		self:SetBackgroundColor(Amr.Colors.Black)
		self:SetStrata("FULLSCREEN_DIALOG")
		self:SetLevel(0)
		self:SetAlpha(1)
		self:SetVisible(true)
		self:EnableMouse(false)
		self.frame:ClearAllPoints()
	end,

	["SetBackgroundColor"] = function(self, color, a)
		self.bg:SetColorTexture(color.R, color.G, color.B, a or 1)
	end,
	
	-- set a transparent bg to make this panel invisible
	["SetTransparent"] = function(self)
		self:SetBackgroundColor(Amr.Colors.Black, 0)
	end,
	
	["SetStrata"] = function(self, strata)
		self.frame:SetFrameStrata(strata)
	end,
	
	["SetLevel"] = function(self, level)
		self.frame:SetFrameLevel(level)
	end,
	
	["SetAlpha"] = function(self, a)
		self.frame:SetAlpha(a)
	end,
	
	["EnableMouse"] = function(self, enable)
		self.frame:EnableMouse(enable)
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

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	
	local widget = {
		bg        = bg,
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
