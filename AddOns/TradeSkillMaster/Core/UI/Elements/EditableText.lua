-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- EditableText UI Element Class.
-- A text element which has an editing state. It is a subclass of the @{Text} class.
-- @classmod EditableText

local _, TSM = ...
local Theme = TSM.Include("Util.Theme")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local ItemLinked = TSM.Include("Service.ItemLinked")
local UIElements = TSM.Include("UI.UIElements")
local EditableText = TSM.Include("LibTSMClass").DefineClass("EditableText", TSM.UI.Text)
UIElements.Register(EditableText)
TSM.UI.EditableText = EditableText
local private = {}
local STRING_RIGHT_PADDING = 16



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function EditableText.__init(self)
	local frame = UIElements.CreateFrame(self, "EditBox")

	self.__super:__init(frame)

	frame:SetShadowColor(0, 0, 0, 0)
	frame:SetAutoFocus(false)
	ScriptWrapper.Set(frame, "OnEscapePressed", private.OnEscapePressed, self)
	ScriptWrapper.Set(frame, "OnEnterPressed", private.OnEnterPressed, self)
	ScriptWrapper.Set(frame, "OnEditFocusLost", private.OnEditFocusLost, self)

	frame.text = UIElements.CreateFontString(self, frame)
	frame.text:SetAllPoints()


	local function ItemLinkedCallback(name, link)
		if self._allowItemInsert == nil or not self:IsVisible() or not self._editing then
			return
		end
		if self._allowItemInsert == true then
			frame:Insert(link)
		else
			frame:Insert(name)
		end
		return true
	end
	ItemLinked.RegisterCallback(ItemLinkedCallback, -1)

	self._editing = false
	self._allowItemInsert = nil
	self._onValueChangedHandler = nil
	self._onEditingChangedHandler = nil
end

function EditableText.Release(self)
	self:_GetBaseFrame():ClearFocus()
	self:_GetBaseFrame():Disable()
	self._editing = false
	self._allowItemInsert = nil
	self._onValueChangedHandler = nil
	self._onEditingChangedHandler = nil
	self.__super:Release()
end

--- Registers a script handler.
-- @tparam EditableText self The editable text object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`, `OnEditingChanged`)
-- @tparam function handler The script handler which will be called with the editable text object followed by any
-- arguments to the script
-- @treturn EditableText The editable text object
function EditableText.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	elseif script == "OnEditingChanged" then
		self._onEditingChangedHandler = handler
	elseif script == "OnEnter" or script == "OnLeave" or script == "OnMouseDown" then
		self.__super:SetScript(script, handler)
	else
		error("Unknown EditableText script: "..tostring(script))
	end
	return self
end

--- Sets whether or not the text is currently being edited.
-- @tparam EditableText self The editable text object
-- @tparam boolean editing The editing state to set
-- @treturn EditableText The editable text object
function EditableText.SetEditing(self, editing)
	self._editing = editing
	if self._onEditingChangedHandler then
		self:_onEditingChangedHandler(editing)
	end
	if self._autoWidth then
		self:GetParentElement():Draw()
	else
		self:Draw()
	end
	return self
end

--- Allows inserting an item into the editable text by linking it while the editable text has focus.
-- @tparam EditableText self The editable text object
-- @tparam[opt=false] boolean insertLink Insert the link instead of the item name
-- @treturn EditableText The editable text object
function EditableText.AllowItemInsert(self, insertLink)
	assert(insertLink == true or insertLink == false or insertLink == nil)
	self._allowItemInsert = insertLink or false
	return self
end

function EditableText.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	-- set the editbox font
	frame:SetFont(Theme.GetFont(self._font):GetWowFont())

	-- set the justification
	frame:SetJustifyH(self._justifyH)
	frame:SetJustifyV(self._justifyV)

	-- set the text color
	frame:SetTextColor(self:_GetTextColor():GetFractionalRGBA())

	if self._editing then
		frame:Enable()
		frame:SetText(self._textStr)
		frame:SetFocus()
		frame:HighlightText(0, -1)
		frame.text:Hide()
	else
		frame:SetText("")
		frame:ClearFocus()
		frame:HighlightText(0, 0)
		frame:Disable()
		frame.text:Show()
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function EditableText._GetPreferredDimension(self, dimension)
	if dimension == "WIDTH" and self._autoWidth and not self._editing then
		return self:GetStringWidth() + STRING_RIGHT_PADDING
	else
		return self.__super.__super:_GetPreferredDimension(dimension)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnEscapePressed(self)
	self:SetEditing(false)
end

function private.OnEnterPressed(self)
	local newText = self:_GetBaseFrame():GetText()
	self:SetEditing(false)
	self:_onValueChangedHandler(newText)
end

function private.OnEditFocusLost(self)
	self:SetEditing(false)
end
