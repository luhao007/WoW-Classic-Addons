--[[-----------------------------------------------------------------------------
Label Widget
Displays text.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiLabel", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent


--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

local function updateSize(self)
	if self.resizing then return end
	local frame = self.frame
	local width = frame.width or frame:GetWidth() or 0
	local label = self.label
	local height

	label:ClearAllPoints()
	label:SetPoint("TOPLEFT")
	label:SetWidth(width)
	height = label:GetHeight()
	
	self.resizing = true
	frame:SetHeight(height)
	frame.height = height
	self.resizing = nil
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

local function frameOnMouseDown(frame, ...)
	frame.obj:Fire("OnMouseDown", ...)
end

local function frameOnMouseUp(frame, ...)
	frame.obj:Fire("OnMouseUp", ...)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- set the flag to stop constant size updates
		self.resizing = true
		-- height is set dynamically by the text size
		self:SetWidth(200)
		self:SetText()
		self:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.Text))
		self:SetJustifyH("LEFT")
		self:SetJustifyV("MIDDLE")
		self:SetWordWrap(true)
		self:SetVisible(true)

		-- reset the flag
		self.resizing = nil
		-- run the update explicitly
		--updateSize(self)
	end,
	
	-- ["OnRelease"] = nil,

	["OnWidthSet"] = function(self, width)
		updateSize(self)
	end,
	
	["GetHeight"] = function(self)
		return self.frame:GetHeight()
	end,

	["SetText"] = function(self, text)
		self.label:SetText(text)
		updateSize(self)
	end,

	["SetFont"] = function(self, font)
		self.label:SetFontObject(font)
		updateSize(self)
	end,
	
	["SetJustifyV"] = function(self, val)
		self.label:SetJustifyV(val)
	end,
	
	["SetJustifyH"] = function(self, val)
		self.label:SetJustifyH(val)
	end,
	
	["SetWordWrap"] = function(self, enable)
		self.label:SetWordWrap(enable)
		updateSize(self)
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
	frame:Hide()

	frame:SetScript("OnEnter", frameOnEnter)
	frame:SetScript("OnLeave", frameOnLeave)
	frame:SetScript("OnMouseDown", frameOnMouseDown)
	frame:SetScript("OnMouseUp", frameOnMouseUp)

	local label = frame:CreateFontString(nil, "ARTWORK")
	label:SetPoint("TOPLEFT")
	label:SetFontObject(Amr.CreateFont("Regular", 16, Amr.Colors.Text))

	-- create widget
	local widget = {
		label = label,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
