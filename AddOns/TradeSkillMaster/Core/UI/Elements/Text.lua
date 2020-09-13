-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Text UI Element Class.
-- A text element simply holds a text string. It is a subclass of the @{Element} class.
-- @classmod Text

local _, TSM = ...
local Text = TSM.Include("LibTSMClass").DefineClass("Text", TSM.UI.Element)
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Text)
TSM.UI.Text = Text
local STRING_RIGHT_PADDING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Text.__init(self, frame)
	frame = frame or UIElements.CreateFrame(self, "Frame")
	self.__super:__init(frame)
	frame.text = UIElements.CreateFontString(self, frame)

	self._textStr = ""
	self._autoWidth = false
	self._textColor = "TEXT"
	self._font = nil
	self._justifyH = "LEFT"
	self._justifyV = "MIDDLE"
end

function Text.Release(self)
	self._textStr = ""
	self._autoWidth = false
	self._textColor = "TEXT"
	self._font = nil
	self._justifyH = "LEFT"
	self._justifyV = "MIDDLE"
	self:_GetBaseFrame().text:SetSpacing(0)
	self.__super:Release()
end

--- Sets the width of the text.
-- @tparam Text self The text object
-- @tparam ?number|string width The width of the text, "AUTO" to set the width based on the length
-- of the text, or nil to have an undefined width
-- @treturn Text The text object
function Text.SetWidth(self, width)
	if width == "AUTO" then
		self._autoWidth = true
	else
		self._autoWidth = false
		self.__super:SetWidth(width)
	end
	return self
end

--- Sets the font.
-- @tparam Text self The text object
-- @tparam string font The font key
-- @treturn Text The text object
function Text.SetFont(self, font)
	assert(Theme.GetFont(font))
	self._font = font
	return self
end

--- Sets the color of the text.
-- @tparam Text self The text object
-- @tparam Color|string color The text color as a Color object or a theme color key
-- @treturn Text The text object
function Text.SetTextColor(self, color)
	assert((type(color) == "string" and Theme.GetColor(color)) or Color.IsInstance(color))
	self._textColor = color
	return self
end

--- Sets the horizontal justification of the text.
-- @tparam Text self The text object
-- @tparam string justifyH The horizontal justification (either "LEFT", "CENTER" or "RIGHT")
-- @treturn Text The text object
function Text.SetJustifyH(self, justifyH)
	assert(justifyH == "LEFT" or justifyH == "CENTER" or justifyH == "RIGHT")
	self._justifyH = justifyH
	return self
end

--- Sets the vertical justification of the text.
-- @tparam Text self The text object
-- @tparam string justifyV The vertical justification (either "TOP", "MIDDLE" or "BOTTOM")
-- @treturn Text The text object
function Text.SetJustifyV(self, justifyV)
	assert(justifyV == "TOP" or justifyV == "MIDDLE" or justifyV == "BOTTOM")
	self._justifyV = justifyV
	return self
end

--- Set the text.
-- @tparam Text self The text object
-- @tparam ?string|number text The text
-- @treturn Text The text object
function Text.SetText(self, text)
	if type(text) == "number" then
		text = tostring(text)
	end
	assert(type(text) == "string")
	self._textStr = text
	return self
end

--- Set formatted text.
-- @tparam Text self The text object
-- @tparam vararg ... The format string and parameters
-- @treturn Text The text object
function Text.SetFormattedText(self, ...)
	self:SetText(format(...))
	return self
end

--- Gets the text string.
-- @tparam Text self The text object
-- @treturn string The text string
function Text.GetText(self)
	return self._textStr
end

--- Get the rendered text string width.
-- @tparam Text self The text object
-- @treturn number The rendered text string width
function Text.GetStringWidth(self)
	local text = self:_GetBaseFrame().text
	self:_ApplyFont()
	text:SetText(self._textStr)
	return text:GetStringWidth()
end

--- Get the rendered text string height.
-- @tparam Text self The text object
-- @treturn number The rendered text string height
function Text.GetStringHeight(self)
	local text = self:_GetBaseFrame().text
	self:_ApplyFont()
	text:SetText(self._textStr)
	return text:GetStringHeight()
end

function Text.Draw(self)
	self.__super:Draw()

	local text = self:_GetBaseFrame().text
	text:ClearAllPoints()
	text:SetAllPoints()

	-- set the font
	self:_ApplyFont()

	-- set the justification
	text:SetJustifyH(self._justifyH)
	text:SetJustifyV(self._justifyV)

	-- set the text color
	text:SetTextColor(self:_GetTextColor():GetFractionalRGBA())

	-- set the text
	text:SetText(self._textStr)
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Text._GetTextColor(self)
	if type(self._textColor) == "string" then
		return Theme.GetColor(self._textColor)
	else
		assert(Color.IsInstance(self._textColor))
		return self._textColor
	end
end

function Text._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self._autoWidth then
		return 0, self._width == nil
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end

function Text._GetPreferredDimension(self, dimension)
	if dimension == "WIDTH" and self._autoWidth then
		return self:GetStringWidth() + STRING_RIGHT_PADDING
	else
		return self.__super:_GetPreferredDimension(dimension)
	end
end

function Text._ApplyFont(self)
	local text = self:_GetBaseFrame().text
	local font = Theme.GetFont(self._font)
	text:SetFont(font:GetWowFont())
	-- There's a Blizzard bug where spacing incorrectly gets applied to embedded textures, so just set it to 0 in that case
	-- TODO: come up with a better fix if we need multi-line text with embedded textures
	if strfind(self._textStr, "\124T") then
		text:SetSpacing(0)
	else
		text:SetSpacing(font:GetSpacing())
	end
end
