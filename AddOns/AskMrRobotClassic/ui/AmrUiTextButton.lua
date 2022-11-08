--[[-----------------------------------------------------------------------------
Text Button Widget
Based on the AceGUI button, but a custom look that just shows text.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiTextButton", 1
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
-- to facilitate some use cases, we have click fired on PostClick for this widget
--[[local function buttonOnClick(frame, ...)
	AceGUI:ClearFocus()
	--PlaySound("igMainMenuOption")
	frame.obj:Fire("OnClick", ...)
end]]

local function buttonPreClick(frame, ...)
	frame.obj:Fire("PreClick", ...)
end

local function buttonPostClick(frame, ...)
	frame.obj:Fire("OnClick", ...)
end

local function buttonOnEnter(frame)
	frame.obj.bg:Hide()
	frame.obj.hover:Show()
	frame.obj:Fire("OnEnter")
end

local function buttonOnLeave(frame)
	frame.obj.bg:Show()
	frame.obj.hover:Hide()
	frame.obj:Fire("OnLeave")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetBackgroundColor(Amr.Colors.Black, 0)
		self:SetHoverBackgroundColor(Amr.Colors.Black, 0)
		self:SetDisabled(false)

		self:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.Text))
		self:SetHoverFont(Amr.CreateFont("Regular", 16, Amr.Colors.TextHover))
		self:SetText("")
		self:SetWordWrap(true)
		self:SetJustifyH("CENTER")
		self:SetJustifyV("MIDDLE")
		self:SetTextPadding()
		
		self:SetSubtextFont(Amr.CreateFont("Regular", 16, Amr.Colors.Text))
		self:SetSubtext()
		self:SetSubtextWordWrap(true)
		self:SetSubtextJustifyH("CENTER")
		self:SetSubtextJustifyV("MIDDLE")
		self:SetSubtextPadding()
		
		self.frame:ClearAllPoints()
		self.bg:Show()
		self.hover:Hide()
	end,
	
	["OnWidthSet"] = function(self, width)
		self.frame:GetFontString():SetWidth(width)
	end,
	
	["OnHeightSet"] = function(self, height)
		self.frame:GetFontString():SetHeight(height)
	end,
	
	["SetBackgroundColor"] = function(self, color, alpha)
		self.bg:SetColorTexture(color.R, color.G, color.B, alpha)
	end,
	
	["SetBackgroundImage"] = function(self, image)
		self.bg:SetTexture(image)
		self.bg:SetDesaturated(false)
	end,
	
	["SetHoverBackgroundColor"] = function(self, color, alpha)
		self.hover:SetColorTexture(color.R, color.G, color.B, alpha)
	end,
	
	["SetHoverBackgroundImage"] = function(self, image)
		self.hover:SetTexture(image)
	end,

	["SetText"] = function(self, text)
		self.frame:SetText(text)
	end,
	
	["SetWordWrap"] = function(self, enable)
		self.frame:GetFontString():SetWordWrap(enable)
	end,
	
	["SetJustifyH"] = function(self, val)
		self.frame:GetFontString():SetJustifyH(val)
	end,
	
	["SetJustifyV"] = function(self, val)
		self.frame:GetFontString():SetJustifyV(val)
	end,
	
	["SetTextPadding"] = function(self, top, right, bottom, left)
		local f = self.frame:GetFontString()
		f:ClearAllPoints()
		
		if not top and not right and not bottom and not left then
			f:SetPoint("CENTER")
		end
		
		if top then f:SetPoint("TOP", self.frame, "TOP", 0, -top) end
		if right then f:SetPoint("RIGHT", self.frame, "RIGHT", -right, 0) end
		if bottom then f:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, bottom) end
		if left then f:SetPoint("LEFT", self.frame, "LEFT", left, 0) end
	end,
	
	["SetFont"] = function(self, font)
		self.frame:SetNormalFontObject(font)
	end,
	
	["SetHoverFont"] = function(self, font)
		self.frame:SetHighlightFontObject(font)
	end,
	
	["SetSubtext"] = function(self, text)
		self.subtxt:SetText(text)
		if text then
			self.subtxt:Show()
		else
			self.subtxt:Hide()
		end
	end,
	
	["SetSubtextWordWrap"] = function(self, enable)
		self.subtxt:SetWordWrap(enable)
	end,
	
	["SetSubtextJustifyH"] = function(self, val)
		self.subtxt:SetJustifyH(val)
	end,
	
	["SetSubtextJustifyV"] = function(self, val)
		self.subtxt:SetJustifyV(val)
	end,
	
	["SetSubtextPadding"] = function(self, top, right, bottom, left)
		local f = self.subtxt
		f:ClearAllPoints()
		if top then f:SetPoint("TOP", self.frame, "TOP", 0, -top) end
		if right then f:SetPoint("RIGHT", self.frame, "RIGHT", -right, 0) end
		if bottom then f:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, bottom) end
		if left then f:SetPoint("LEFT", self.frame, "LEFT", left, 0) end
	end,
	
	["SetSubtextFont"] = function(self, font)
		self.subtxt:SetFontObject(font)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end,
	
	["SetVisible"] = function(self, visible)
		if visible then
			self.frame:Show()
		else
			self.frame:Hide()
		end
	end,

	--
	-- If text is specified, turns this into a button that calls a macro
	--
	["SetMacroText"] = function(self, text)
		if text then
			self.frame:SetAttribute("type", "macro")
			self.frame:SetAttribute("macrotext", text)
		else
			self.frame:SetAttribute("type", nil)
			self.frame:SetAttribute("macrotext", nil)
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AmrUiTextButton" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
	frame:Hide()
	
	local txt = frame:CreateFontString()
	frame:SetFontString(txt)
	
	local subtxt = frame:CreateFontString()
	subtxt:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", buttonOnEnter)
	frame:SetScript("OnLeave", buttonOnLeave)
	--frame:SetScript("OnClick", buttonOnClick)
	frame:SetScript("PreClick", buttonPreClick)
	frame:SetScript("PostClick", buttonPostClick)
	
	local bg = frame:CreateTexture()
	bg:SetAllPoints()
	
	local hover = frame:CreateTexture()
	hover:SetAllPoints()
	
	local widget = {
		bg        = bg,
		subtxt    = subtxt,
		hover     = hover,
		frame     = frame,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
