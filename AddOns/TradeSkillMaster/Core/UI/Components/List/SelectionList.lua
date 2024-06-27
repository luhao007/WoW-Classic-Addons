-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Theme = TSM.Include("Util.Theme")
local UIElements = TSM.Include("UI.UIElements")
local ROW_HEIGHT = 20



-- ============================================================================
-- Element Definition
-- ============================================================================

local SelectionList = UIElements.Define("SelectionList", "List") ---@class SelectionList: List



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SelectionList:__init()
	self.__super:__init()
	self._entries = {}
	self._selectedEntry = nil
	self._onEntrySelectedHandler = nil
end

function SelectionList:Acquire()
	self.__super:Acquire(ROW_HEIGHT)
end

function SelectionList:Release()
	wipe(self._entries)
	self._selectedEntry = nil
	self._onEntrySelectedHandler = nil
	self.__super:Release()
end

---Sets the entries.
---@param entries string[] A list of entries
---@param selectedEntry string The selected entry
---@return SelectionList
function SelectionList:SetEntries(entries, selectedEntry)
	wipe(self._entries)
	for _, entry in ipairs(entries) do
		tinsert(self._entries, entry)
	end
	self._selectedEntry = selectedEntry
	self:_SetNumRows(#self._entries)
	return self
end

---Registers a script handler.
---@param script "OnEntrySelected"
---@param handler fun(selectionList: SelectionList, ...: any) The handler
---@return SelectionList
function SelectionList:SetScript(script, handler)
	if script == "OnEntrySelected" then
		self._onEntrySelectedHandler = handler
	else
		error("Unknown SelectionList script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Protected/Private Class Methods
-- ============================================================================

function SelectionList.__protected:_HandleRowAcquired(row)
	local text = row:AddText("item")
	text:SetHeight(ROW_HEIGHT)
	text:SetFont(Theme.GetFont("BODY_BODY2"):GetWowFont())
	text:SetJustifyH("LEFT")
	text:SetPoint("LEFT", Theme.GetColSpacing() / 2, 0)
	text:SetPoint("RIGHT", -Theme.GetColSpacing() / 2, 0)
end

function SelectionList.__protected:_HandleRowDraw(row)
	local dataIndex = row:GetDataIndex()
	local entry = self._entries[dataIndex]
	local color = entry == self._selectedEntry and "INDICATOR" or "TEXT"
	row:GetText("item"):SetText(Theme.GetColor(color):ColorText(entry))
end

function SelectionList.__protected:_HandleRowClick(row)
	if self._onEntrySelectedHandler then
		self:_onEntrySelectedHandler(self._entries[row:GetDataIndex()])
	end
end
