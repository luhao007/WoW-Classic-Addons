-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Group Selector UI Element Class.
-- A group selector is an element which can be used to prompt the user to select a list of groups, usually for
-- filtering. It is a subclass of the @{Element} class.
-- @classmod GroupSelector

local _, TSM = ...
local L = TSM.Include("Locale").GetTable()
local Table = TSM.Include("Util.Table")
local Analytics = TSM.Include("Util.Analytics")
local Theme = TSM.Include("Util.Theme")
local TextureAtlas = TSM.Include("Util.TextureAtlas")
local Rectangle = TSM.Include("UI.Rectangle")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local UIElements = TSM.Include("UI.UIElements")
local GroupSelector = UIElements.Define("GroupSelector", "Element")
local private = {}
local TEXT_MARGIN = 8
local ICON_MARGIN = 4
local CORNER_RADIUS = 4
local DEFAULT_CONTEXT = { selected = {}, collapsed = {} }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function GroupSelector.__init(self)
	local frame = UIElements.CreateFrame(self, "Button")
	ScriptWrapper.Set(frame, "OnClick", private.OnClick, self)
	self.__super:__init(frame)

	frame.text = UIElements.CreateFontString(self, frame)
	frame.text:SetFont(Theme.GetFont("BODY_BODY2_MEDIUM"):GetWowFont())
	frame.text:SetPoint("TOPLEFT", TEXT_MARGIN, 0)
	frame.text:SetPoint("BOTTOMRIGHT", -TEXT_MARGIN, 0)
	frame.text:SetJustifyH("CENTER")
	frame.text:SetJustifyV("MIDDLE")

	frame.hintText = UIElements.CreateFontString(self, frame)
	frame.hintText:SetFont(Theme.GetFont("BODY_BODY2"):GetWowFont())
	frame.hintText:SetPoint("TOPLEFT", TEXT_MARGIN, 0)
	frame.hintText:SetPoint("BOTTOMRIGHT", -ICON_MARGIN - TextureAtlas.GetWidth("iconPack.18x18/Add/Default") - TEXT_MARGIN, 0)
	frame.hintText:SetJustifyH("LEFT")
	frame.hintText:SetJustifyV("MIDDLE")

	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetPoint("RIGHT", -ICON_MARGIN, 0)

	frame.iconBtn = CreateFrame("Button", nil, frame)
	frame.iconBtn:SetAllPoints(frame.icon)
	ScriptWrapper.Set(frame.iconBtn, "OnClick", private.OnIconClick, self)

	self._backgroundTexture = Rectangle.New(frame)
	self._backgroundTexture:SetCornerRadius(CORNER_RADIUS)

	self._groupTreeContext = CopyTable(DEFAULT_CONTEXT)
	self._text = ""
	self._hintText = ""
	self._selectedText = L["%d groups"]
	self._dialogWidth = 464
	self._dialogHeight = 500
	self._dialogTitleText = nil
	self._dialogButtonText = nil
	self._singleSelection = nil
	self._onSelectionChanged = nil
	self._customQueryFunc = nil
	self._showCreateNew = false
end

function GroupSelector.Release(self)
	wipe(self._groupTreeContext.collapsed)
	wipe(self._groupTreeContext.selected)
	self._text = ""
	self._hintText = ""
	self._selectedText = L["%d groups"]
	self._dialogWidth = 464
	self._dialogHeight = 500
	self._dialogTitleText = nil
	self._dialogButtonText = nil
	self._singleSelection = nil
	self._onSelectionChanged = nil
	self._customQueryFunc = nil
	self._showCreateNew = false
	self.__super:Release()
end

--- Sets the text.
-- @tparam GroupSelector self The group selector object
-- @tparam string text The text
-- @treturn GroupSelector The group selector object
function GroupSelector.SetText(self, text)
	assert(type(text) == "string")
	self._text = text
	self._hintText = ""
	return self
end

--- Sets the hint text.
-- @tparam GroupSelector self The group selector object
-- @tparam string text The hint text
-- @treturn GroupSelector The group selector object
function GroupSelector.SetHintText(self, text)
	assert(type(text) == "string")
	self._hintText = text
	self._text = ""
	return self
end

--- Sets the selected text.
-- @tparam GroupSelector self The group selector object
-- @tparam string text The selected text (with a %d formatter for the number of groups)
-- @treturn GroupSelector The group selector object
function GroupSelector.SetSelectedText(self, text)
	assert(type(text) == "string" and strmatch(text, "%%d"))
	self._selectedText = text
	return self
end

--- Registers a script handler.
-- @tparam GroupSelector self The group selector object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`)
-- @tparam function handler The script handler which will be called with the group selector object followed by any
-- arguments to the script
-- @treturn GroupSelector The group selector object
function GroupSelector.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChanged = handler
	else
		error("Unknown GroupSelector script: "..tostring(script))
	end
	return self
end

--- Sets a function to generate a custom query to use for the group tree.
-- @tparam GroupSelector self The group selector object
-- @tparam function func A function to call to create the custom query (gets auto-released by the GroupTree)
-- @treturn GroupSelector The group selector object
function GroupSelector.SetCustomQueryFunc(self, func)
	self._customQueryFunc = func
	return self
end

--- Adds the "Create New Group" option to the group tree
-- @tparam GroupSelector self The group selector object
-- @treturn GroupSelector The group selector object
function GroupSelector.AddCreateNew(self)
	self._showCreateNew = true
	return self
end

--- Sets the selection to only handle single selection.
-- @tparam GroupSelector self The group selector object
-- @tparam boolean enabled The state of the single selection
-- @treturn GroupSelector The group selector object
function GroupSelector.SetSingleSelection(self, enabled)
	self._singleSelection = enabled
	return self
end

--- Returns the single selected group path.
-- @tparam GroupSelector self The group selector object
function GroupSelector.GetSelection(self)
	assert(self._singleSelection)
	return next(self._groupTreeContext.selected)
end

--- Sets the single selected group path.
-- @tparam GroupSelector self The group selector object
-- @tparam string|table selection The selected group(s) or nil if nothing should be selected
-- @treturn GroupSelector The group selector object
function GroupSelector.SetSelection(self, selection)
	wipe(self._groupTreeContext.selected)
	if not selection then
		return self
	end
	if self._singleSelection then
		self._groupTreeContext.selected[selection] = true
	else
		for groupPath in pairs(selection) do
			self._groupTreeContext.selected[groupPath] = true
		end
	end
	return self
end

--- Returns an iterator for all selected groups.
-- @tparam GroupSelector self The group selector object
-- @return An iterator which iterates over the selected groups and has the following values: `groupPath`
function GroupSelector.SelectedGroupIterator(self)
	return pairs(self._groupTreeContext.selected)
end

--- Clears all selected groups.
-- @tparam GroupSelector self The group selector object
-- @tparam boolean silent Don't call the selection changed callback
-- @treturn GroupSelector The group selector object
function GroupSelector.ClearSelectedGroups(self, silent)
	wipe(self._groupTreeContext.selected)
	if not silent and self._onSelectionChanged then
		self:_onSelectionChanged()
	end
	return self
end

--- Sets the dialog size opened by the group selector.
-- @tparam GroupSelector self The group selector object
-- @tparam number width The width for the dialog
-- @tparam number height The height for the dialog
-- @tparam string titleText The text for the dialog title
-- @tparam string buttonText The text for the dialog button
-- @treturn GroupSelector The group selector object
function GroupSelector.SetDialogInfo(self, width, height, titleText, buttonText)
	self._dialogWidth = width
	self._dialogHeight = height
	self._dialogTitleText = titleText
	self._dialogButtonText = buttonText
	return self
end

function GroupSelector.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	if self._text ~= "" then
		frame.hintText:Hide()
		frame.icon:Hide()
		frame.iconBtn:Hide()

		frame.text:SetText(self._text)
		frame.text:Show()
	else
		frame.text:Hide()

		local numGroups = Table.Count(self._groupTreeContext.selected)
		frame.hintText:SetText(numGroups == 0 and self._hintText or (self._singleSelection and TSM.Groups.Path.Format(next(self._groupTreeContext.selected)) or format(self._selectedText, numGroups)))

		TextureAtlas.SetTextureAndSize(frame.icon, numGroups == 0 and "iconPack.18x18/Add/Default" or "iconPack.18x18/Close/Default")
		frame.hintText:Show()
		frame.icon:Show()
		frame.iconBtn:Show()
	end

	self._backgroundTexture:SetColor(Theme.GetColor("ACTIVE_BG"))
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function GroupSelector._CreateQuery(self)
	local query = nil
	if self._customQueryFunc then
		query = self._customQueryFunc()
	else
		query = TSM.Groups.CreateQuery()
	end
	if self._singleSelection then
		query:NotEqual("groupPath", TSM.CONST.ROOT_GROUP_PATH)
	end
	return query
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnClick(self)
	self:GetBaseElement():ShowDialogFrame(UIElements.New("Frame", "frame", "DIALOG")
		:SetLayout("VERTICAL")
		:SetSize(self._dialogWidth, self._dialogHeight)
		:SetPadding(8)
		:AddAnchor("CENTER")
		:SetBackgroundColor("FRAME_BG", true)
		:SetMouseEnabled(true)
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, 0, 8)
			:AddChild(UIElements.New("Text", "title")
				:SetMargin(32, 8, 0, 0)
				:SetFont("BODY_BODY1_BOLD")
				:SetJustifyH("CENTER")
				:SetText(self._dialogTitleText or L["Select Group"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("Frame", "container")
			:SetLayout("VERTICAL")
			:SetPadding(2)
			:SetBackgroundColor("PRIMARY_BG")
			:SetBorderColor("ACTIVE_BG")
			:AddChild(UIElements.New("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:SetMargin(8)
				:AddChild(UIElements.New("Input", "input")
					:AllowItemInsert(true)
					:SetIconTexture("iconPack.18x18/Search")
					:SetClearButtonEnabled(true)
					:SetHintText(L["Search Groups"])
					:SetScript("OnValueChanged", private.DialogFilterOnValueChanged)
				)
				:AddChild(UIElements.New("Button", "expandAllBtn")
					:SetSize(24, 24)
					:SetMargin(8, 0, 0, 0)
					:SetBackground("iconPack.18x18/Expand All")
					:SetScript("OnClick", private.ExpandAllGroupsOnClick)
					:SetTooltip(L["Expand / Collapse All Groups"])
				)
				:AddChildIf(not self._singleSelection, UIElements.New("Button", "selectAllBtn")
					:SetSize(24, 24)
					:SetMargin(8, 0, 0, 0)
					:SetBackground("iconPack.18x18/Select All")
					:SetScript("OnClick", private.SelectAllGroupsOnClick)
					:SetTooltip(L["Select / Deselect All Groups"])
				)
			)
			:AddChildIf(self._showCreateNew, UIElements.New("Button", "createGroup")
				:SetHeight(24)
				:SetMargin(8, 8, 0, 0)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetJustifyH("LEFT")
				:SetIcon("iconPack.14x14/Add/Circle", "LEFT")
				:SetText(L["Create New Group"])
				:SetScript("OnClick", private.CreateGroupOnClick)
			)
			:AddChild(UIElements.New(self._singleSelection and "SelectionGroupTree" or "ApplicationGroupTree", "groupTree")
				:SetContext(self)
				:SetContextTable(self._groupTreeContext, DEFAULT_CONTEXT)
				:SetQuery(self:_CreateQuery())
			)
		)
		:AddChild(UIElements.New("ActionButton", "groupBtn")
			:SetHeight(24)
			:SetMargin(0, 0, 8, 0)
			:SetContext(self)
			:SetText(self._dialogButtonText or L["Select Group"])
			:SetScript("OnClick", private.DialogSelectOnClick)
		)
	)
end

function private.OnIconClick(self)
	if Table.Count(self._groupTreeContext.selected) > 0 then
		self:ClearSelectedGroups()
		self:Draw()
		if self._onSelectionChanged then
			self:_onSelectionChanged()
		end
	else
		private.OnClick(self)
	end
end

function private.DialogCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.DialogFilterOnValueChanged(input)
	input:GetElement("__parent.__parent.groupTree")
		:SetSearchString(strlower(input:GetValue()))
		:Draw()
end

function private.ExpandAllGroupsOnClick(button)
	button:GetElement("__parent.__parent.groupTree")
		:ToggleExpandAll()
end

function private.SelectAllGroupsOnClick(button)
	button:GetElement("__parent.__parent.groupTree")
		:ToggleSelectAll()
end

function private.DialogSelectOnClick(button)
	local self = button:GetContext()
	button:GetBaseElement():HideDialog()
	self:Draw()
	if self._onSelectionChanged then
		self:_onSelectionChanged()
	end
end

function private.CreateGroupOnClick(button)
	local newGroupPath = L["New Group"]
	if TSM.Groups.Exists(newGroupPath) then
		local num = 1
		while TSM.Groups.Exists(newGroupPath.." "..num) do
			num = num + 1
		end
		newGroupPath = newGroupPath.." "..num
	end
	TSM.Groups.Create(newGroupPath)
	Analytics.Action("CREATED_GROUP", newGroupPath)
	button:GetElement("__parent.groupTree")
		:UpdateData()
		:SetSelection(newGroupPath)
		:Draw()
end
