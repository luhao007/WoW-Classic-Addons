-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Checkbox UI Element Class.
-- This is a simple checkbox element with an attached description text. It is a subclass of the @{Text} class.
-- @classmod Checkbox

local _, TSM = ...
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Theme = TSM.Include("Util.Theme")
local UIElements = TSM.Include("UI.UIElements")
local Checkbox = TSM.Include("LibTSMClass").DefineClass("Checkbox", TSM.UI.Text)
UIElements.Register(Checkbox)
TSM.UI.Checkbox = Checkbox
local private = {}
local THEME_TEXTURES = {
	RADIO = {
		checked = "iconPack.Misc/Radio/Checked",
		unchecked = "iconPack.Misc/Radio/Unchecked",
	},
	CHECK = {
		checked = "iconPack.Misc/Checkbox/Checked",
		unchecked = "iconPack.Misc/Checkbox/Unchecked",
	},
}
local CHECKBOX_SPACING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Checkbox.__init(self)
	local frame = UIElements.CreateFrame(self, "Button")
	self.__super:__init(frame)
	ScriptWrapper.Set(frame, "OnClick", private.FrameOnClick, self)

	-- create the text and check texture
	frame.text = UIElements.CreateFontString(self, frame)
	frame.text:SetJustifyV("MIDDLE")
	frame.check = frame:CreateTexture()

	self._position = "LEFT"
	self._theme = "CHECK"
	self._font = "BODY_BODY3"
	self._disabled = false
	self._value = false
	self._onValueChangedHandler = nil
	self._settingTable = nil
	self._settingKey = nil
end

function Checkbox.Release(self)
	self._position = "LEFT"
	self._theme = "CHECK"
	self._disabled = false
	self._value = false
	self._onValueChangedHandler = nil
	self._settingTable = nil
	self._settingKey = nil
	self.__super:Release()
	self._font = "BODY_BODY3"
end

--- Sets the position of the checkbox relative to the text.
-- This method can be used to set the checkbox to be either on the left or right side of the text.
-- @tparam Checkbox self The checkbox object
-- @tparam string position The position of the checkbox relative to the text
-- @treturn Checkbox The checkbox object
function Checkbox.SetCheckboxPosition(self, position)
	if position == "LEFT" or position == "RIGHT" then
		self._position = position
	else
		error("Invalid checkbox position: "..tostring(position))
	end
	return self
end

--- Sets the checkbox theme
-- @tparam Checkbox self The checkbox object
-- @tparam string theme Either "RADIO" or "CHECK"
-- @treturn Checkbox The checkbox object
function Checkbox.SetTheme(self, theme)
	assert(THEME_TEXTURES[theme])
	self._theme = theme
	return self
end

--- Sets whether or not the checkbox is disabled.
-- @tparam Checkbox self The checkbox object
-- @tparam boolean disabled Whether or not the checkbox is disabled
-- @treturn Checkbox The checkbox object
function Checkbox.SetDisabled(self, disabled)
	self._disabled = disabled
	return self
end

--- Sets the text string.
-- @tparam Checkbox self The checkbox object
-- @tparam string text The text string to be displayed
-- @treturn Checkbox The checkbox object
function Checkbox.SetText(self, text)
	self._textStr = text
	return self
end

--- Gets the text string.
-- @tparam Checkbox self The checkbox object
-- @treturn string The text string
function Checkbox.GetText(self)
	return self._textStr
end

--- Sets a formatted text string.
-- @tparam Checkbox self The checkbox object
-- @tparam vararg ... The format string and arguments
-- @treturn Checkbox The checkbox object
function Checkbox.SetFormattedText(self, ...)
	self._textStr = format(...)
	return self
end

--- Sets whether or not the checkbox is checked.
-- @tparam Checkbox self The checkbox object
-- @tparam boolean value Whether or not the checkbox is checked
-- @tparam[opt=false] boolean silent If true, will not trigger the `OnValueChanged` script
-- @treturn Checkbox The checkbox object
function Checkbox.SetChecked(self, value, silent)
	self._value = value and true or false
	if self._onValueChangedHandler and not silent then
		self:_onValueChangedHandler(value)
	end
	return self
end

--- Sets the setting info.
-- This method is used to have the state of the checkbox automatically correspond with the boolean state of a field in
-- a table. This is useful for checkboxes which are tied directly to settings.
-- @tparam Checkbox self The checkbox object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the checkbox state
-- @treturn Checkbox The checkbox object
function Checkbox.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	self:SetChecked(tbl[key])
	return self
end

--- Gets the checked state.
-- @tparam Checkbox self The checkbox object
-- @treturn boolean Whether or not the checkbox is checked
function Checkbox.IsChecked(self)
	return self._value
end

--- Registers a script handler.
-- @tparam Checkbox self The checkbox object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the checkbox object followed by any arguments
-- to the script
-- @treturn Checkbox The checkbox object
function Checkbox.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	elseif script == "OnEnter" or script == "OnLeave" then
		return self.__super:SetScript(script, handler)
	else
		error("Unknown Checkbox script: "..tostring(script))
	end
	return self
end

function Checkbox.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	if self._disabled then
		frame.text:SetTextColor(Theme.GetColor("TEXT_DISABLED"):GetFractionalRGBA())
	else
		frame.text:SetTextColor(self:_GetTextColor():GetFractionalRGBA())
	end
	TSM.UI.TexturePacks.SetTextureAndSize(frame.check, THEME_TEXTURES[self._theme][self._value and "checked" or "unchecked"])

	frame.text:ClearAllPoints()
	frame.check:ClearAllPoints()
	if self._position == "LEFT" then
		frame.check:SetPoint("LEFT")
		frame.text:SetJustifyH("LEFT")
		frame.text:SetPoint("LEFT", frame.check, "RIGHT", CHECKBOX_SPACING, 0)
		frame.text:SetPoint("TOPRIGHT")
		frame.text:SetPoint("BOTTOMRIGHT")
	elseif self._position == "RIGHT" then
		frame.check:SetPoint("RIGHT")
		frame.text:SetJustifyH("RIGHT")
		frame.text:SetPoint("BOTTOMLEFT")
		frame.text:SetPoint("TOPLEFT")
		frame.text:SetPoint("RIGHT", frame.check, "LEFT", -CHECKBOX_SPACING, 0)
	else
		error("Invalid position: "..tostring(self._position))
	end
	if self._disabled then
		frame.check:SetAlpha(0.3)
		self:_GetBaseFrame():Disable()
	else
		frame.check:SetAlpha(1)
		self:_GetBaseFrame():Enable()
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Checkbox._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self._autoWidth then
		local checkboxWidth = TSM.UI.TexturePacks.GetWidth(THEME_TEXTURES[self._theme].checked)
		return self:GetStringWidth() + CHECKBOX_SPACING + checkboxWidth, nil
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnClick(self)
	local value = not self._value

	if self._settingTable and self._settingKey then
		self._settingTable[self._settingKey] = value
	end

	self:SetChecked(value)
	self:Draw()
end
