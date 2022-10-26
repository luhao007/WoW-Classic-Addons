-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Slider UI Element Class.
-- A slider allows for selecting a numerical range. It is a subclass of the @{Element} class.
-- @classmod Slider

local _, TSM = ...
local Math = TSM.Include("Util.Math")
local NineSlice = TSM.Include("Util.NineSlice")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Theme = TSM.Include("Util.Theme")
local Slider = TSM.Include("LibTSMClass").DefineClass("Slider", TSM.UI.Element)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Slider)
TSM.UI.Slider = Slider
local private = {}
local THUMB_WIDTH = 8
local INPUT_WIDTH = 50
local INPUT_AREA_SPACE = 128



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Slider.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame")
	frame:EnableMouse(true)
	ScriptWrapper.Set(frame, "OnMouseDown", private.FrameOnMouseDown, self)
	ScriptWrapper.Set(frame, "OnMouseUp", private.FrameOnMouseUp, self)
	ScriptWrapper.Set(frame, "OnUpdate", private.FrameOnUpdate, self)

	self.__super:__init(frame)

	-- create the textures
	frame.barTexture = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.activeBarTexture = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	frame.thumbTextureLeft = frame:CreateTexture(nil, "ARTWORK")
	frame.thumbTextureRight = frame:CreateTexture(nil, "ARTWORK")

	frame.inputLeft = CreateFrame("EditBox", nil, frame, nil)
	frame.inputLeft:SetJustifyH("CENTER")
	frame.inputLeft:SetWidth(INPUT_WIDTH)
	frame.inputLeft:SetHeight(24)
	frame.inputLeft:SetAutoFocus(false)
	frame.inputLeft:SetNumeric(true)
	ScriptWrapper.Set(frame.inputLeft, "OnEscapePressed", private.InputOnEscapePressed)
	ScriptWrapper.Set(frame.inputLeft, "OnEnterPressed", private.LeftInputOnEnterPressed, self)


	frame.dash = UIElements.CreateFontString(self, frame)
	frame.dash:SetJustifyH("CENTER")
	frame.dash:SetJustifyV("MIDDLE")
	frame.dash:SetWidth(12)

	frame.inputRight = CreateFrame("EditBox", nil, frame, nil)
	frame.inputRight:SetJustifyH("CENTER")
	frame.inputRight:SetWidth(INPUT_WIDTH)
	frame.inputRight:SetHeight(24)
	frame.inputRight:SetNumeric(true)
	frame.inputRight:SetAutoFocus(false)
	ScriptWrapper.Set(frame.inputRight, "OnEscapePressed", private.InputOnEscapePressed)
	ScriptWrapper.Set(frame.inputRight, "OnEnterPressed", private.RightInputOnEnterPressed, self)

	self._inputLeftNineSlice = NineSlice.New(frame.inputLeft)
	self._inputRightNineSlice = NineSlice.New(frame.inputRight)
	self._leftValue = nil
	self._rightValue = nil
	self._minValue = nil
	self._maxValue = nil
	self._dragging = nil
end

function Slider.Release(self)
	self._leftValue = nil
	self._rightValue = nil
	self._minValue = nil
	self._maxValue = nil
	self._dragging = nil
	self.__super:Release()
end

--- Set the extends of the possible range.
-- @tparam Slider self The slider object
-- @tparam number minValue The minimum value
-- @tparam number maxValue The maxmimum value
-- @treturn Slider The slider object
function Slider.SetRange(self, minValue, maxValue)
	self._minValue = minValue
	self._maxValue = maxValue
	self._leftValue = minValue
	self._rightValue = maxValue
	return self
end

--- Sets the current value.
-- @tparam Slider self The slider object
-- @tparam number leftValue The lower end of the range
-- @tparam number rightValue The upper end of the range
-- @treturn Slider The slider object
function Slider.SetValue(self, leftValue, rightValue)
	assert(leftValue < rightValue and leftValue >= self._minValue and rightValue <= self._maxValue)
	self._leftValue = leftValue
	self._rightValue = rightValue
	return self
end

--- Gets the current value
-- @tparam Slider self The slider object
-- @treturn number The lower end of the range
-- @treturn number The upper end of the range
function Slider.GetValue(self)
	return self._leftValue, self._rightValue
end

function Slider.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	local inputColor = Theme.GetColor("ACTIVE_BG")
	self._inputLeftNineSlice:SetStyle("rounded")
	self._inputRightNineSlice:SetStyle("rounded")
	self._inputLeftNineSlice:SetVertexColor(inputColor:GetFractionalRGBA())
	self._inputRightNineSlice:SetVertexColor(inputColor:GetFractionalRGBA())

	local sliderHeight = self:_GetDimension("HEIGHT") / 2
	local width = self:_GetDimension("WIDTH") - INPUT_AREA_SPACE
	local leftPos = Math.Scale(self._leftValue, self._minValue, self._maxValue, 0, width - THUMB_WIDTH)
	local rightPos = Math.Scale(self._rightValue, self._minValue, self._maxValue, 0, width - THUMB_WIDTH)
	local fontPath, fontHeight = Theme.GetFont("BODY_BODY2"):GetWowFont()
	local textColor = Theme.GetColor("TEXT")

	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	frame.inputRight:SetFont(fontPath, fontHeight, "")
	frame.inputRight:SetTextColor(textColor:GetFractionalRGBA())
	frame.inputRight:SetPoint("RIGHT", 0)
	frame.inputRight:SetNumber(self._rightValue)

	frame.dash:SetFont(fontPath, fontHeight, "")
	frame.dash:SetTextColor(textColor:GetFractionalRGBA())
	frame.dash:SetText("-")
	frame.dash:SetPoint("RIGHT", frame.inputRight, "LEFT", 0, 0)

	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	frame.inputLeft:SetFont(fontPath, fontHeight, "")
	frame.inputLeft:SetTextColor(textColor:GetFractionalRGBA())
	frame.inputLeft:SetPoint("RIGHT", frame.dash, "LEFT", 0)
	frame.inputLeft:SetNumber(self._leftValue)

	frame.barTexture:ClearAllPoints()
	frame.barTexture:SetPoint("LEFT", 0, 0)
	frame.barTexture:SetPoint("RIGHT", frame.inputLeft, "LEFT", -16, 0)
	frame.barTexture:SetHeight(sliderHeight / 3)
	frame.barTexture:SetColorTexture(Theme.GetColor("FRAME_BG"):GetFractionalRGBA())

	TSM.UI.TexturePacks.SetTextureAndSize(frame.thumbTextureLeft, "iconPack.14x14/Circle")
	frame.thumbTextureLeft:SetPoint("LEFT", frame.barTexture, leftPos, 0)

	TSM.UI.TexturePacks.SetTextureAndSize(frame.thumbTextureRight, "iconPack.14x14/Circle")
	frame.thumbTextureRight:SetPoint("LEFT", frame.barTexture, rightPos, 0)

	frame.activeBarTexture:SetPoint("LEFT", frame.thumbTextureLeft, "CENTER")
	frame.activeBarTexture:SetPoint("RIGHT", frame.thumbTextureRight, "CENTER")
	frame.activeBarTexture:SetHeight(sliderHeight / 3)
	frame.activeBarTexture:SetColorTexture(Theme.GetColor("TEXT"):GetFractionalRGBA())
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Slider._GetCursorPositionValue(self)
	local frame = self:_GetBaseFrame()
	local x = GetCursorPosition() / frame:GetEffectiveScale()
	local left = frame:GetLeft() + THUMB_WIDTH / 2
	local right = frame:GetRight() - THUMB_WIDTH - INPUT_AREA_SPACE * 2 / 2
	x = min(max(x, left), right)
	local value = Math.Scale(x, left, right, self._minValue, self._maxValue)
	return min(max(Math.Round(value), self._minValue), self._maxValue)
end

function Slider._UpdateLeftValue(self, value)
	local newValue = max(min(value, self._rightValue), self._minValue)
	if newValue == self._leftValue then
		return
	end
	self._leftValue = newValue
	self:Draw()
end

function Slider._UpdateRightValue(self, value)
	local newValue = min(max(value, self._leftValue), self._maxValue)
	if newValue == self._rightValue then
		return
	end
	self._rightValue = newValue
	self:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.InputOnEscapePressed(input)
	input:ClearFocus()
end

function private.LeftInputOnEnterPressed(self)
	local input = self:_GetBaseFrame().inputLeft
	self:_UpdateLeftValue(input:GetNumber())
end

function private.RightInputOnEnterPressed(self)
	local input = self:_GetBaseFrame().inputRight
	self:_UpdateRightValue(input:GetNumber())
end

function private.FrameOnMouseDown(self)
	local frame = self:_GetBaseFrame()
	frame.inputLeft:ClearFocus()
	frame.inputRight:ClearFocus()
	local value = self:_GetCursorPositionValue()
	local leftDiff = abs(value - self._leftValue)
	local rightDiff = abs(value - self._rightValue)
	if value < self._leftValue then
		-- clicked to the left of the left thumb, so drag that
		self._dragging = "left"
	elseif value > self._rightValue then
		-- clicked to the right of the right thumb, so drag that
		self._dragging = "right"
	elseif self._leftValue == self._rightValue then
		-- just ignore this click since they clicked on both thumbs
	elseif leftDiff < rightDiff then
		-- clicked closer to the left thumb, so drag that
		self._dragging = "left"
	else
		-- clicked closer to the right thumb (or right in the middle), so drag that
		self._dragging = "right"
	end
end

function private.FrameOnMouseUp(self)
	self._dragging = nil
end

function private.FrameOnUpdate(self)
	if not self._dragging then
		return
	end
	if self._dragging == "left" then
		self:_UpdateLeftValue(self:_GetCursorPositionValue())
	elseif self._dragging == "right" then
		self:_UpdateRightValue(self:_GetCursorPositionValue())
	else
		error("Unexpected dragging: "..tostring(self._dragging))
	end
end
