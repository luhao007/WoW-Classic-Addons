--[[-----------------------------------------------------------------------------
Button Widget
Based on the AceGUI button, but with a custom look for AMR.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local CreateFrame, UIParent = CreateFrame, UIParent


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function buttonOnClick(frame, ...)
	AceGUI:ClearFocus()
	--PlaySound("igMainMenuOption")
	frame.obj:Fire("OnClick", ...)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetText()
		self:SetBackgroundColor({R = 0, G = 0, B = 0})
		self:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.White))
		self.frame:ClearAllPoints()
	end,

	["SetText"] = function(self, text)
		self.frame:SetText(text)
	end,
	
	["SetFont"] = function(self, font)
		self.frame:SetNormalFontObject(font)
	end,
	
	-- color is an object with R, G, B
	["SetBackgroundColor"] = function(self, color)
		self.texNormal:SetColorTexture(color.R, color.G, color.B, 1)
		self.texPush:SetColorTexture(color.R, color.G, color.B, 1)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.frame:SetAlpha(0.2)
		else
			self.frame:Enable()
			self.frame:SetAlpha(1)
		end
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
	local name = "AmrUiButton" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnClick", buttonOnClick)
	
	Amr.DropShadow(frame)
	
	-- normal bg color, can be set with SetBackgroundColor
	local texNormal = frame:CreateTexture(nil, "BORDER")
	texNormal:SetAllPoints(true)
	frame:SetNormalTexture(texNormal)
	
	-- gives a 1px down+right animation on press
	local texPush = frame:CreateTexture(nil, "BORDER")
	texPush:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
	texPush:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
	frame:SetPushedTexture(texPush)
	
	-- not perfect, but more or less achieves the effect of lightening the bg color slightly on hover
	local texHigh = frame:CreateTexture(nil, "BORDER")
	texHigh:SetColorTexture(1, 1, 1, 0.1)
	texHigh:SetAllPoints(true)
	frame:SetHighlightTexture(texHigh)

	local widget = {
		texNormal = texNormal,
		texPush   = texPush,
		frame     = frame,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
