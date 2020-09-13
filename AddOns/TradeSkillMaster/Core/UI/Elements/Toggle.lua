-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Toggle UI Element Class.
-- A toggle element allows the user to select between a fixed set of options. It is a subclass of the @{Container} class.
-- @classmod Toggle

local _, TSM = ...
local Toggle = TSM.Include("LibTSMClass").DefineClass("Toggle", TSM.UI.Container)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Toggle)
TSM.UI.Toggle = Toggle
local private = {}
local BUTTON_PADDING = 16



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Toggle.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame")

	self.__super:__init(frame)

	self._optionsList = {}
	self._buttons = {}
	self._onValueChangedHandler = nil
	self._selectedOption = nil
	self._booleanKey = nil
	self._font = "BODY_BODY3"
end

function Toggle.Release(self)
	wipe(self._optionsList)
	wipe(self._buttons)
	self._onValueChangedHandler = nil
	self._selectedOption = nil
	self._booleanKey = nil
	self._font = "BODY_BODY3"

	self.__super:Release()
end

--- Add an option.
-- @tparam Toggle self The toggle object
-- @tparam string option The text that goes with the option
-- @tparam boolean setSelected Whether or not to set this as the selected option
-- @treturn Toggle The toggle object
function Toggle.AddOption(self, option, setSelected)
	tinsert(self._optionsList, option)
	if setSelected then
		self:SetOption(option)
	end
	return self
end

--- Sets the currently selected option.
-- @tparam Toggle self The toggle object
-- @tparam string option The selected option
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn Toggle The toggle object
function Toggle.SetOption(self, option, redraw)
	if option ~= self._selectedOption then
		self._selectedOption = option
		if self._onValueChangedHandler then
			self:_onValueChangedHandler(option)
		end
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Clears the currently selected option.
-- @tparam Toggle self The toggle object
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn Toggle The toggle object
function Toggle.ClearOption(self, redraw)
	self._selectedOption = nil
	if redraw then
		self:Draw()
	end
	return self
end

--- Sets whether or not the toggle is disabled.
-- @tparam Toggle self The toggle object
-- @tparam boolean disabled Whether or not the toggle is disabled
-- @treturn Toggle The toggle object
function Toggle.SetDisabled(self, disabled)
	self._disabled = disabled
	return self
end

--- Registers a script handler.
-- @tparam Toggle self The toggle object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the toggle object followed by any arguments to
-- the script
-- @treturn Toggle The toggle object
function Toggle.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	else
		error("Unknown Toggle script: "..tostring(script))
	end
	return self
end

function Toggle.SetFont(self, font)
	self._font = font
	return self
end

--- Get the selected option.
-- @tparam Toggle self The toggle object
-- @treturn string The selected option
function Toggle.GetValue(self)
	return self._selectedOption
end

function Toggle.Draw(self)
	self.__super.__super:Draw()
	-- add new buttons if necessary
	while #self._buttons < #self._optionsList do
		local num = #self._buttons + 1
		local button = UIElements.New("Checkbox", self._id.."_Button"..num)
			:SetFont(self._font)
			:SetScript("OnValueChanged", private.ButtonOnClick)
		self:AddChildNoLayout(button)
		tinsert(self._buttons, button)
	end

	local selectedPath = self._selectedOption
	local height = self:_GetDimension("HEIGHT")
	local buttonWidth = (self:_GetDimension("WIDTH") / #self._buttons) + BUTTON_PADDING
	local offsetX = 0
	for i, button in ipairs(self._buttons) do
		local buttonPath = self._optionsList[i]
		if i <= #self._optionsList then
			button:SetFont(self._font)
			button:SetWidth("AUTO")
			button:SetTheme("RADIO")
			button:SetCheckboxPosition("LEFT")
			button:SetText(buttonPath)
			button:SetSize(buttonWidth, height)
			button:SetDisabled(self._disabled)
			button:WipeAnchors()
			button:AddAnchor("TOPLEFT", offsetX, 0)
			offsetX = offsetX + buttonWidth
		else
			button:Hide()
		end

		if buttonPath == selectedPath then
			button:SetChecked(true, true)
		else
			button:SetChecked(false, true)
		end
	end

	self.__super:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ButtonOnClick(button)
	local self = button:GetParentElement()
	self:SetOption(button:GetText(), true)
end
