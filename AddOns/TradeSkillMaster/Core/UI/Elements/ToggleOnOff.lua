-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ToggleOnOff UI Element Class.
-- This is a simple on/off toggle which uses different textures for the different states. It is a subclass of the
-- @{Container} class.
-- @classmod ToggleOnOff

local _, TSM = ...
local ToggleOnOff = TSM.Include("LibTSMClass").DefineClass("ToggleOnOff", TSM.UI.Container)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(ToggleOnOff)
TSM.UI.ToggleOnOff = ToggleOnOff
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ToggleOnOff.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame")

	self.__super:__init(frame)

	self._value = false
	self._disabled = false
	self._settingTable = nil
	self._settingKey = nil
	self._onValueChangedHandler = nil
end

function ToggleOnOff.Acquire(self)
	local frame = self:_GetBaseFrame()
	self:AddChildNoLayout(UIElements.New("Frame", "toggle")
		:SetLayout("HORIZONTAL")
		:AddAnchor("TOPLEFT", frame)
		:AddAnchor("BOTTOMRIGHT", frame)
		:SetContext(self)
		:AddChild(UIElements.New("Checkbox", "yes")
			:SetWidth("AUTO")
			:SetTheme("RADIO")
			:SetFont("BODY_BODY2")
			:SetText(YES)
			:SetCheckboxPosition("LEFT")
			:SetScript("OnValueChanged", private.OnYesClickHandler)
		)
		:AddChild(UIElements.New("Checkbox", "no")
			:SetWidth("AUTO")
			:SetTheme("RADIO")
			:SetFont("BODY_BODY2")
			:SetMargin(8, 0, 0, 0)
			:SetText(NO)
			:SetCheckboxPosition("LEFT")
			:SetScript("OnValueChanged", private.OnNoClickHandler)
		)
		:AddChild(UIElements.New("Spacer", "spacer"))
	)

	self.__super:Acquire()
end

function ToggleOnOff.Release(self)
	self._value = false
	self._disabled = false
	self._settingTable = nil
	self._settingKey = nil
	self._onValueChangedHandler = nil
	--self:_GetBaseFrame():Enable()

	self.__super:Release()
end

--- Sets the setting info.
-- This method is used to have the value of the toggle automatically correspond with the value of a field in a table.
-- This is useful for toggles which are tied directly to settings.
-- @tparam ToggleOnOff self The toggles object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the toggle's state
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	self._value = tbl[key]
	return self
end

--- Sets whether or not the toggle is disabled.
-- @tparam ToggleOnOff self The toggles object
-- @tparam boolean disabled Whether or not the toggle is disabled
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetDisabled(self, disabled, redraw)
	self._disabled = disabled
	if disabled then
		self:GetElement("toggle.yes"):SetDisabled(true)
		self:GetElement("toggle.no"):SetDisabled(true)
	else
		self:GetElement("toggle.yes"):SetDisabled(false)
		self:GetElement("toggle.no"):SetDisabled(false)
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Set the value of the toggle.
-- @tparam ToggleOnOff self The toggles object
-- @tparam boolean value Whether the value is on (true) or off (false)
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetValue(self, value, redraw)
	if value ~= self._value then
		self._value = value
		if self._settingTable then
			self._settingTable[self._settingKey] = value
		end
		if self._onValueChangedHandler then
			self:_onValueChangedHandler(value)
		end
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Registers a script handler.
-- @tparam ToggleOnOff self The toggles object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the toggles object followed by any
-- arguments to the script
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	else
		error("Unknown ToggleOnOff script: "..tostring(script))
	end
	return self
end

--- Get the value of the toggle.
-- @tparam ToggleOnOff self The toggles object
-- @treturn boolean The value of the toggle
function ToggleOnOff.GetValue(self)
	return self._value
end

function ToggleOnOff.Draw(self)
	if self._value then
		self:GetElement("toggle.yes"):SetChecked(true, true)
		self:GetElement("toggle.no"):SetChecked(false, true)
	else
		self:GetElement("toggle.yes"):SetChecked(false, true)
		self:GetElement("toggle.no"):SetChecked(true, true)
	end

	if self._disabled then
		self:GetElement("toggle.yes"):SetDisabled(true)
		self:GetElement("toggle.no"):SetDisabled(true)
	else
		self:GetElement("toggle.yes"):SetDisabled(false)
		self:GetElement("toggle.no"):SetDisabled(false)
	end

	self.__super:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnYesClickHandler(button)
	if not button:IsChecked() then
		button:SetChecked(true, true)
		return
	end
	local self = button:GetParentElement():GetContext()
	self:SetValue(true, true)
end

function private.OnNoClickHandler(button)
	if not button:IsChecked() then
		button:SetChecked(true, true)
		return
	end
	local self = button:GetParentElement():GetContext()
	self:SetValue(false, true)
end
