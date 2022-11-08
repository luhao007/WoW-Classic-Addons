--[[-----------------------------------------------------------------------------
Textarea Widget
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiTextarea", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]

-- handles clicking in the scrollframe but below the bounds of the editbox (which can't be sized to same as scrollframe)
local function scrollFrameMouseUp(self)
	local editbox = self.obj.editbox
	editbox:SetFocus()
	editbox:SetCursorPosition(editbox:GetNumLetters())
end

local function scrollFrameVerticalScroll(self, offset)
	local editbox = self.obj.editbox
	editbox:SetHitRectInsets(0, 0, offset, editbox:GetHeight() - offset - self:GetHeight())
end

local function editboxCursorChanged(self, _, y, _, cursorHeight)
	self, y = self.obj.scrollFrame, -y
	local offset = self:GetVerticalScroll()
	if y < offset then
		self:SetVerticalScroll(y)
	else
		y = y + cursorHeight - self:GetHeight()
		if y > offset then
			self:SetVerticalScroll(y)
		end
	end
end

local function editboxEditFocusLost(self)
	self:HighlightText(0, 0)
	self.obj:Fire("OnEditFocusLost")
end

local function editboxEditFocusGained(frame)
	AceGUI:SetFocus(frame.obj)
	frame.obj:Fire("OnEditFocusGained")
end

local function editboxTextChanged(self, userInput)
	if userInput then
		self = self.obj
		self:Fire("OnTextChanged", self.editbox:GetText())
	end
end

local function editboxTextSet(self)
	self:HighlightText()
	self:SetCursorPosition(self:GetNumLetters())
	self = self.obj
	self:Fire("OnTextSet", self.editbox:GetText())
end

local function editboxEnterPressed(self)
	self.obj:Fire("OnEnterPressed")
end

-- works for both the scrollframe and the editbox, handles e.g. dragging a spell link into the textarea
local function onReceiveDrag(self)
	local type, id, info = GetCursorInfo()
	if type == "spell" then
		info = GetSpellInfo(id, info)
	elseif type ~= "item" then
		return
	end
	ClearCursor()
	self = self.obj
	local editbox = self.editbox
	if not editbox:HasFocus() then
		editbox:SetFocus()
		editbox:SetCursorPosition(editbox:GetNumLetters())
	end
	editbox:Insert(info)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetWidth(200)
		self:SetHeight(24)
		self:SetMultiLine(true)
		self:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.Text))
		self:SetText("")
		self.frame:ClearAllPoints()
	end,

	["SetText"] = function(self, text)
		self.editbox:SetText(text)
	end,
	
	["GetText"] = function(self)
		return self.editbox:GetText()
	end,
	
	["SetFont"] = function(self, font)
		self.editbox:SetFontObject(font)
	end,
	
	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.editbox:Disable()
		else
			self.editbox:Enable()
		end
	end,
	
	["OnWidthSet"] = function(self, width)
		self.editbox:SetWidth(width)
	end,

	["OnHeightSet"] = function(self, height)
		self.editbox:SetHeight(height)
	end,
	
	["ClearFocus"] = function(self)
		self.editbox:ClearFocus()
		self.editbox:HighlightText(0, 0)
		self.frame:SetScript("OnShow", nil)
	end,
	
	["SetMultiLine"] = function(self, multi)
		self.editbox:SetMultiLine(multi)
	end,

	["SetFocus"] = function(self, highlight)
		self.editbox:SetFocus()
		if highlight then
			self.editbox:HighlightText()
		end
		if not self.frame:IsShown() then
			self.frame:SetScript("OnShow", function(frame)
				frame.obj.editbox:SetFocus()
				if highlight then
					self.editbox:HighlightText()
				end
				frame:SetScript("OnShow", nil)
			end)
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AmrUiTextarea" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("ScrollFrame", name, UIParent)
	frame:Hide()
	
	frame:SetScript("OnMouseUp", scrollFrameMouseUp)
	frame:SetScript("OnReceiveDrag", onReceiveDrag)
	frame:HookScript("OnVerticalScroll", scrollFrameVerticalScroll)
	
	local editbox = CreateFrame("EditBox", name .. "Edit", frame)
	editbox:SetAllPoints()
	editbox:EnableMouse(true)
	editbox:SetMultiLine(true)
	editbox:SetAutoFocus(false)
	editbox:SetCountInvisibleLetters(false)
	editbox:SetTextInsets(4, 4, 4, 4)
	
	editbox:SetScript("OnMouseDown", onReceiveDrag)
	editbox:SetScript("OnReceiveDrag", onReceiveDrag)
	
	editbox:SetScript("OnCursorChanged", editboxCursorChanged)
	editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
	editbox:SetScript("OnEnterPressed", editboxEnterPressed)
	editbox:SetScript("OnEditFocusLost", editboxEditFocusLost)
	editbox:SetScript("OnTextChanged", editboxTextChanged)
	editbox:SetScript("OnTextSet", editboxTextSet)
	editbox:SetScript("OnEditFocusGained", editboxEditFocusGained)
	
	frame:SetScrollChild(editbox)
	
	local border = frame:CreateTexture(nil, "BACKGROUND")
	border:SetColorTexture(Amr.Colors.BorderGray.R, Amr.Colors.BorderGray.G, Amr.Colors.BorderGray.B, 1)
	border:SetAllPoints(true)
	
	local bg = frame:CreateTexture(nil, "BORDER")
	bg:SetColorTexture(Amr.Colors.BgInput.R, Amr.Colors.BgInput.G, Amr.Colors.BgInput.B, 1)
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
	
	local widget = {
		editbox     = editbox,
		scrollFrame = frame,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	editbox.obj, frame.obj = widget, widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
