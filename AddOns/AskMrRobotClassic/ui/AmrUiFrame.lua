--[[-----------------------------------------------------------------------------
AmrUiFrame container
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiFrame", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

-- width of the frame border
local _borderWidth = 1


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function buttonOnClick(frame)
	--PlaySound("gsTitleOptionExit")
	frame.obj:Hide()
end

local function frameOnClose(frame)
	frame.obj:Fire("OnClose")
end

local function frameOnMouseDown(frame)
	AceGUI:ClearFocus()
end

local function titleOnMouseDown(frame)
	frame.obj:StartMove()
end

local function titleOnMouseUp(frame)
	frame.obj:EndMove()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetAutoAdjustHeight(false)
		self.frame:SetParent(UIParent)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self.frame:SetScale(1)
		self:ApplyStatus()
		self:Show()
	end,

	["OnRelease"] = function(self)
		self.status = nil
		wipe(self.localstatus)
	end,
	
	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,

	-- called to set an external table to store status in
	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
		self:ApplyStatus()
	end,

	["ApplyStatus"] = function(self)
		local status = self.status or self.localstatus
		local frame = self.frame
		frame:ClearAllPoints()
		if status.top and status.left then
			frame:SetPoint("TOP", UIParent, "BOTTOM", 0, status.top)
			frame:SetPoint("LEFT", UIParent, "LEFT", status.left, 0)
		else
			frame:SetPoint("CENTER")
		end
	end,
	
	-- color is an object with R, G, B
	["SetBackgroundColor"] = function(self, color)
		self.bg:SetColorTexture(color.R, color.G, color.B, 1)
	end,
	
	["SetBorderColor"] = function(self, color)
		self.border:SetColorTexture(color.R, color.G, color.B, 1)
	end,
	
	["Raise"] = function(self)
		self.frame:Raise()
	end,
	
	["StartMove"] = function(self)
		self.frame:StartMoving()
		AceGUI:ClearFocus()
	end,
	
	["EndMove"] = function(self)
		self.frame:StopMovingOrSizing()
		local status = self.status or self.localstatus
		status.top = self.frame:GetTop()
		status.left = self.frame:GetLeft()
	end,
	
	["OnWidthSet"] = function(self, width)
		local content = self.content
		content.width = width
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		content.height = height
	end,
	
	["SetScale"] = function(self, scale)
		self.frame:SetScale(scale)
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", "AmrUiFrame" .. num, UIParent)
	frame:Hide()
	
	-- make escape key close this window
	table.insert(UISpecialFrames, frame:GetName())
	
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(false)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetToplevel(true)
	frame:SetScript("OnHide", frameOnClose)
	frame:SetScript("OnMouseDown", frameOnMouseDown)
	
	Amr.DropShadow(frame)
	
	local border = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	border:SetAllPoints(true)
	
	local bg = frame:CreateTexture(nil, "BORDER")
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", _borderWidth, -_borderWidth)
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -_borderWidth, _borderWidth)

	local btnClose = CreateFrame("Button", nil, frame)
	btnClose:SetNormalTexture("Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\IconClose")
	btnClose:SetHighlightTexture("Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\IconCloseOver")
	
	--btnClose:SetNormalFontObject(Amr.CreateFont("Bold", 16, Amr.Colors.White))
	--btnClose:SetText("x")
	btnClose:SetWidth(22)
	btnClose:SetHeight(22)
	btnClose:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
	btnClose:SetScript("OnClick", buttonOnClick)

	--local lbl = btnClose:GetFontString()
	--lbl:ClearAllPoints()
	--lbl:SetPoint("TOP", btnClose, "TOP", -1, -2)
	
	-- style the button similar to AmrUiButton
	--[[
	Amr.DropShadow(btnClose)

	local tex = Amr.CreateTexture(btnClose, Amr.Colors.Red)
	tex:SetAllPoints(true)
	btnClose:SetNormalTexture(tex)
	
	tex = Amr.CreateTexture(btnClose, Amr.Colors.Red)
	tex:SetPoint("TOPLEFT", btnClose, "TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", btnClose, "BOTTOMRIGHT", 1, -1)
	btnClose:SetPushedTexture(tex)
	
	tex = Amr.CreateTexture(btnClose, Amr.Colors.White, 0.1)
	tex:SetAllPoints(true)
	btnClose:SetHighlightTexture(tex)
	]]
	
	-- title
	local titleFrame = CreateFrame("Frame", nil, frame)
	titleFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	titleFrame:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -40)
	titleFrame:EnableMouse(true)
	titleFrame:SetScript("OnMouseDown", titleOnMouseDown)
	titleFrame:SetScript("OnMouseUp", titleOnMouseUp)

	--Container Support
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", titleFrame, "BOTTOMLEFT", 20, 0)
	content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 20)
	
	local widget = {
		localstatus = {},
		border      = border,
		bg          = bg,
		content     = content,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	btnClose.obj, titleFrame.obj = widget, widget

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
