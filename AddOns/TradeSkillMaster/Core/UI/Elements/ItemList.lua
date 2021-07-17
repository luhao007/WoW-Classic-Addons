-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ItemList UI Element Class.
-- This element is used for the item lists in the group UI. It is a subclass of the @{ScrollingTable} class.
-- @classmod ItemList

local _, TSM = ...
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local DragContext = TSM.Include("Util.DragContext")
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local ItemInfo = TSM.Include("Service.ItemInfo")
local ItemList = TSM.Include("LibTSMClass").DefineClass("ItemList", TSM.UI.ScrollingTable)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(ItemList)
TSM.UI.ItemList = ItemList
local private = {}
local MOVE_FRAME_PADDING = 8



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ItemList.__init(self)
	self.__super:__init()

	self._moveFrame = nil
	self._rightClickToggle = true
	self._allData = {}
	self._selectedItems = {}
	self._dragItems = {}
	self._category = {}
	self._categoryCollapsed = {}
	self._filterFunc = nil
	self._onSelectionChangedHandler = nil
end

function ItemList.Acquire(self)
	self._headerHidden = true

	self._moveFrame = UIElements.New("Frame", self._id.."_MoveFrame")
		:SetLayout("VERTICAL")
		:SetHeight(20)
		:SetStrata("TOOLTIP")
		:SetBackgroundColor("PRIMARY_BG_ALT", true)
		:SetBorderColor("INDICATOR")
		:SetContext(self)
		:AddChild(UIElements.New("Text", "text")
			:SetFont("BODY_BODY3")
			:SetJustifyH("CENTER")
		)
	self._moveFrame:SetParent(self:_GetBaseFrame())
	self._moveFrame:Hide()
	self._moveFrame:SetScript("OnUpdate", private.MoveFrameOnUpdate)

	self.__super:Acquire()
	self:SetSelectionDisabled(true)
	self:GetScrollingTableInfo()
		:NewColumn("item")
			:SetFont("ITEM_BODY3")
			:SetJustifyH("LEFT")
			:SetIconSize(12)
			:SetExpanderStateFunction(private.GetExpanderState)
			:SetCheckStateFunction(private.GetCheckState)
			:SetIconFunction(private.GetItemIcon)
			:SetTextFunction(private.GetItemText)
			:SetTooltipFunction(private.GetItemTooltip)
			:Commit()
		:Commit()
end

function ItemList.Release(self)
	wipe(self._allData)
	wipe(self._selectedItems)
	wipe(self._dragItems)
	wipe(self._category)
	wipe(self._categoryCollapsed)
	self._filterFunc = nil
	self._onSelectionChangedHandler = nil
	self._moveFrame:Release()
	self._moveFrame = nil
	for _, row in ipairs(self._rows) do
		row._frame:RegisterForDrag()
		ScriptWrapper.Clear(row._frame, "OnDragStart")
		ScriptWrapper.Clear(row._frame, "OnDragStop")
		for _, button in pairs(row._buttons) do
			button:RegisterForDrag()
			ScriptWrapper.Clear(button, "OnDragStart")
			ScriptWrapper.Clear(button, "OnDragStop")
		end
		ScriptWrapper.Clear(row._frame, "OnDoubleClick")
	end
	self.__super:Release()
end

--- Sets the items.
-- @tparam ItemList self The item list object
-- @tparam table items Either a list of items or list of tables with a `header` field and sub-list of items
-- @tparam boolean redraw Whether or not to redraw the item list
-- @treturn ItemList The item list object
function ItemList.SetItems(self, items, redraw)
	wipe(self._allData)
	wipe(self._category)
	wipe(self._categoryCollapsed)

	for _, item in ipairs(items) do
		if type(item) == "table" and next(item) then
			assert(item.header)
			tinsert(self._allData, item.header)
			for _, subItem in ipairs(item) do
				tinsert(self._allData, subItem)
				self._category[subItem] = item.header
			end
		elseif type(item) ~= "table" then
			tinsert(self._allData, item)
			self._category[item] = ""
		end
	end
	self:_UpdateData()

	wipe(self._selectedItems)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end

	if redraw then
		-- scroll up to the top
		self._vScrollbar:SetValue(0)
		self:Draw()
	end

	return self
end

--- Sets a filter function.
-- @tparam ItemList self The item list object
-- @tparam function func A function which is passed an item and returns true if it should be filtered (not shown)
-- @treturn ItemList The item list object
function ItemList.SetFilterFunction(self, func)
	self._filterFunc = func
	self:_UpdateData()
	return self
end

--- Gets whether or not an item is selected.
-- @tparam ItemList self The item list object
-- @tparam string item The item
-- @treturn boolean Whether or not the item is selected
function ItemList.IsItemSelected(self, item)
	return tContains(self._data, item) and self._selectedItems[item]
end

--- Selects all items.
-- @tparam ItemList self The item list object
function ItemList.SelectAll(self)
	for _, item in ipairs(self._data) do
		if self._category[item] then
			self._selectedItems[item] = true
		end
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	self:Draw()
end

--- Deselects all items.
-- @tparam ItemList self The item list object
function ItemList.ClearSelection(self)
	wipe(self._selectedItems)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	self:Draw()
end

--- Toggle the selection state of the item list.
-- @tparam ItemList self The item list object
-- @treturn ItemList The item list object
function ItemList.ToggleSelectAll(self)
	if self:GetNumSelected() == 0 then
		self:SelectAll()
	else
		self:ClearSelection()
	end
	return self
end

--- Registers a script handler.
-- @tparam ItemList self The item list object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`)
-- @tparam function handler The script handler which will be called with the item list object followed by any arguments
-- to the script
-- @treturn ItemList The item list object
function ItemList.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Unknown ItemList script: "..tostring(script))
	end
	return self
end

--- Gets the number of selected items.
-- @tparam ItemList self The item list object
-- @treturn number The number of selected items
function ItemList.GetNumSelected(self)
	local num = 0
	for _, item in ipairs(self._data) do
		if self._selectedItems[item] then
			num = num + 1
		end
	end
	return num
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ItemList._UpdateData(self)
	wipe(self._data)
	for _, data in ipairs(self._allData) do
		if not self:_IsDataHidden(data) then
			tinsert(self._data, data)
		end
	end
end

function ItemList._IsDataHidden(self, data)
	if not self._category[data] then
		return false
	end
	if self._categoryCollapsed[self._category[data]] then
		return true
	end
	if self._filterFunc then
		return self._filterFunc(data)
	end
	return false
end

function ItemList._GetTableRow(self, isHeader)
	local row = self.__super:_GetTableRow(isHeader)
	if not isHeader then
		row._frame:RegisterForDrag("LeftButton")
		ScriptWrapper.Set(row._frame, "OnDragStart", private.RowOnDragStart, row)
		ScriptWrapper.Set(row._frame, "OnDragStop", private.RowOnDragStop, row)
		for _, button in pairs(row._buttons) do
			button:RegisterForDrag("LeftButton")
			ScriptWrapper.Set(button, "OnDragStart", private.RowOnDragStart, row)
			ScriptWrapper.Set(button, "OnDragStop", private.RowOnDragStop, row)
		end
		ScriptWrapper.Set(row._frame, "OnDoubleClick", private.RowOnDoubleClick, row)
	end
	return row
end

function ItemList._HandleRowClick(self, data, button)
	if self._category[data] then
		if button ~= "LeftButton" then
			return
		end
		self._selectedItems[data] = not self._selectedItems[data]
	else
		if IsMouseButtonDown("RightButton") then
			return
		end
		self._categoryCollapsed[data] = not self._categoryCollapsed[data]
		self:_UpdateData()
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	self:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.GetExpanderState(self, data)
	local isHeading = not self._category[data]
	return isHeading, not self._categoryCollapsed[data], isHeading and 0 or 1
end

function private.GetCheckState(self, data)
	return self._category[data] and self._selectedItems[data]
end

function private.GetItemIcon(self, data)
	if not self._category[data] then
		return
	end
	return ItemInfo.GetTexture(data)
end

function private.GetItemText(self, data)
	if self._category[data] then
		return TSM.UI.GetColoredItemName(data) or Theme.GetFeedbackColor("RED"):ColorText("?")
	else
		return data
	end
end

function private.GetItemTooltip(self, data)
	if not self._category[data] then
		return nil
	end
	return data
end

function private.MoveFrameOnUpdate(frame)
	local uiScale = UIParent:GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / uiScale
	y = y / uiScale
	frame:_GetBaseFrame():SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end

function private.RowOnDragStart(row)
	local self = row._scrollingTable
	self._moveFrame:Show()
	self._moveFrame:SetHeight(self._rowHeight)
	local moveFrameText = self._moveFrame:GetElement("text")
	moveFrameText:SetText(self:GetNumSelected() == 0 and TSM.UI.GetColoredItemName(row:GetData()) or format(L["Multiple Items (%d)"], self:GetNumSelected()))
	moveFrameText:SetWidth(1000)
	moveFrameText:Draw()
	self._moveFrame:SetWidth(moveFrameText:GetStringWidth() + MOVE_FRAME_PADDING * 2)
	self._moveFrame:Draw()
	wipe(self._dragItems)
	if self:GetNumSelected() == 0 then
		tinsert(self._dragItems, ItemString.Get(row:GetData()))
	else
		for item in pairs(self._selectedItems) do
			if self._selectedItems[item] then
				tinsert(self._dragItems, ItemString.Get(item))
			end
		end
	end
	DragContext.Set(self._dragItems)
end

function private.RowOnDragStop(row)
	local self = row._scrollingTable
	self._moveFrame:Hide()
	Delay.AfterFrame("DRAG_CONTEXT_CLEAR", 1, DragContext.Clear)
end

function private.RowOnDoubleClick(row, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local self = row._scrollingTable
	self:_HandleRowClick(row:GetData())
end
