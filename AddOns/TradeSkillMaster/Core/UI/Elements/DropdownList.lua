-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local UIElements = TSM.Include("UI.UIElements")
local DropdownList = TSM.Include("LibTSMClass").DefineClass("DropdownList", TSM.UI.ScrollingTable)
UIElements.Register(DropdownList)
TSM.UI.DropdownList = DropdownList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function DropdownList.__init(self)
	self.__super:__init()
	self._selectedItems = {}
	self._multiselect = false
	self._onSelectionChangedHandler = nil
end

function DropdownList.Acquire(self)
	self._backgroundColor = "ACTIVE_BG"
	self._headerHidden = true
	self.__super:Acquire()
	self:SetSelectionDisabled(true)
	self:GetScrollingTableInfo()
		:NewColumn("text")
			:SetFont("BODY_BODY3")
			:SetJustifyH("LEFT")
			:SetTextFunction(private.GetText)
			:SetIconSize(12)
			:SetIconFunction(private.GetIcon)
			:DisableHiding()
			:Commit()
		:Commit()
end

function DropdownList.Release(self)
	wipe(self._selectedItems)
	self._multiselect = false
	self._onSelectionChangedHandler = nil
	self.__super:Release()
end

function DropdownList.SetMultiselect(self, multiselect)
	self._multiselect = multiselect
	return self
end

function DropdownList.SetItems(self, items, selection, redraw)
	wipe(self._data)
	for _, item in ipairs(items) do
		tinsert(self._data, item)
	end
	self:_SetSelectionHelper(selection)

	if redraw then
		self:Draw()
	end

	return self
end

function DropdownList.ItemIterator(self)
	return private.ItemIterator, self, 0
end

function DropdownList.SetSelection(self, selection)
	self:_SetSelectionHelper(selection)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(self._multiselect and self._selectedItems or selection)
	end
	return self
end

function DropdownList.GetSelection(self)
	if self._multiselect then
		return self._selectedItems
	else
		local selectedItem = next(self._selectedItems)
		return selectedItem
	end
end

function DropdownList.SelectAll(self)
	assert(self._multiselect)
	for _, data in ipairs(self._data) do
		self._selectedItems[data] = true
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(self._selectedItems)
	end
	self:Draw()
end

function DropdownList.DeselectAll(self)
	assert(self._multiselect)
	wipe(self._selectedItems)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(self._selectedItems)
	end
	self:Draw()
end

function DropdownList.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Invalid DropdownList script: "..tostring(script))
	end
	return self
end

function DropdownList.Draw(self)
	self.__super:Draw()

	local textColor = nil

	local color = Theme.GetColor(self._backgroundColor)
	-- the text color should have maximum contrast with the background color, so set it to white/black based on the background color
	if color:IsLight() then
		-- the background is light, so set the text to black
		textColor = Color.GetFullBlack()
	else
		-- the background is dark, so set the text to white
		textColor = Color.GetFullWhite()
	end
	for _, row in ipairs(self._rows) do
		row:SetTextColor(textColor)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function DropdownList._SetSelectionHelper(self, selection)
	wipe(self._selectedItems)
	if selection then
		if self._multiselect then
			assert(type(selection) == "table")
			for item, selected in pairs(selection) do
				self._selectedItems[item] = selected
			end
		else
			assert(type(selection) == "string" or type(selection) == "number")
			self._selectedItems[selection] = true
		end
	end
end

function DropdownList._HandleRowClick(self, data)
	if self._multiselect then
		self._selectedItems[data] = not self._selectedItems[data] or nil
		if self._onSelectionChangedHandler then
			self:_onSelectionChangedHandler(self._selectedItems)
		end
		self:Draw()
	else
		self:SetSelection(data)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.GetText(self, data)
	return data
end

function private.GetIcon(self, data)
	return self._multiselect and self._selectedItems[data] and "iconPack.12x12/Checkmark/Default" or ""
end

function private.ItemIterator(self, index)
	index = index + 1
	local item = self._data[index]
	if not item then
		return
	end
	return index, item, self._selectedItems[item]
end
