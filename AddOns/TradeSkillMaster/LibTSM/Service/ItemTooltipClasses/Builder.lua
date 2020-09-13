-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Builder = TSM.Init("Service.ItemTooltipClasses.Builder")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Math = TSM.Include("Util.Math")
local Money = TSM.Include("Util.Money")
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local LibTSMClass = TSM.Include("LibTSMClass")
local TooltipBuilder = LibTSMClass.DefineClass("TooltipBuilder")
local private = {}
local TOOLTIP_CACHE_TIME = 5
local LINE_PART_SEP = "\t"
local DISABLED_TINT = -30



-- ============================================================================
-- TooltipBuilder - Class Meta Methods
-- ============================================================================

function Builder.Create()
	return TooltipBuilder()
end



-- ============================================================================
-- TooltipBuilder - Class Meta Methods
-- ============================================================================

function TooltipBuilder.__init(self)
	self._lines = {}
	self._lineColors = {}
	self._level = 0
	self._levelNumLines = {}
	self._levelHasHeading = {}
	self._lastUpdate = 0
	self._modifier = nil
	self._inCombat = false
	self._itemString = nil
	self._quantity = nil
	self._disabled = nil
end



-- ============================================================================
-- TooltipBuilder - Public Methods
-- ============================================================================

function TooltipBuilder.ApplyValueColor(self, text)
	local color = Theme.GetColor("TEXT")
	if self._disabled then
		color = color:GetTint(DISABLED_TINT)
	end
	return color:ColorText(text)
end

function TooltipBuilder.FormatMoney(self, value, color)
	color = color or Theme.GetColor("TEXT")
	if self._disabled then
		color = color:GetTint(DISABLED_TINT)
	end
	if not value then
		return self:ApplyValueColor("---")
	end
	return Money.ToString(value, color:GetTextColorPrefix(), TSM.db.global.tooltipOptions.tooltipPriceFormat == "icon" and "OPT_ICON" or nil, self._disabled and "OPT_DISABLE" or nil)
end

function TooltipBuilder.AddLine(self, lineLeft, lineRight, color)
	if lineRight then
		lineLeft = strjoin(LINE_PART_SEP, lineLeft, lineRight)
	end
	local line = strrep("  ", self._level)..lineLeft
	color = color or Theme.GetColor("INDICATOR_ALT")
	if self._disabled then
		color = color:GetTint(DISABLED_TINT)
	end
	assert(not self._lineColors[line] or self._lineColors[line] == color)
	self._lineColors[line] = color
	tinsert(self._lines, line)
	self._levelNumLines[self._level] = self._levelNumLines[self._level] + 1
end

function TooltipBuilder.AddTextLine(self, label, text, ...)
	if select("#", ...) == 0 then
		self:AddLine(label, self:ApplyValueColor(text))
	else
		self:AddLine(label, self:ApplyValueColor(text).." ("..self:_TextsToStr(...)..")")
	end
end

function TooltipBuilder.AddValueLine(self, label, ...)
	self:AddLine(label, self:_ValuesToStr(...))
end

function TooltipBuilder.AddItemValueLine(self, label, value)
	if self._quantity > 1 then
		label = label.." x"..self._quantity
		value = value * self._quantity
	end
	self:AddLine(label, self:FormatMoney(value))
end

function TooltipBuilder.AddQuantityValueLine(self, label, quantity, ...)
	self:AddLine(label, self:ApplyValueColor(quantity).." ("..self:_ValuesToStr(...)..")")
end

function TooltipBuilder.AddSubItemValueLine(self, itemString, value, multiplier, matRate, minAmount, maxAmount)
	local name = ItemInfo.GetName(itemString)
	local color = ItemInfo.GetQualityColor(itemString)
	if not name or not color then
		return
	end
	multiplier = Math.Round(multiplier * self._quantity, 0.001)
	matRate = matRate and matRate * 100
	matRate = matRate and matRate.."% " or ""
	local range = (minAmount and maxAmount) and (minAmount ~= maxAmount and "|cffffff00 ["..minAmount.."-"..maxAmount.."]|r" or "|cffffff00 ["..minAmount.."]|r") or ""
	value = value and (value * multiplier) or nil
	self:AddLine(color..matRate..name.." x"..multiplier.."|r"..range, self:FormatMoney(value))
end

function TooltipBuilder.StartSection(self, headingTextLeft, headingTextRight)
	if self._level == 0 then
		headingTextLeft = Theme.GetColor("INDICATOR"):ColorText(headingTextLeft)
	end
	if headingTextRight then
		self:AddLine(headingTextLeft, headingTextRight)
	elseif headingTextLeft then
		self:AddLine(headingTextLeft)
	end
	self._level = self._level + 1
	self._levelHasHeading[self._level] = headingTextLeft and true or false
	self._levelNumLines[self._level] = 0
end

function TooltipBuilder.EndSection(self)
	if self._levelNumLines[self._level] == 0 and self._levelHasHeading[self._level] then
		-- remove the previous heading line
		local headingLine = tremove(self._lines)
		assert(headingLine)
		self._lineColors[headingLine] = nil
		self._levelNumLines[self._level - 1] = self._levelNumLines[self._level - 1] - 1
	end
	self._level = self._level - 1
	assert(self._level >= 0)
end

function TooltipBuilder.SetDisabled(self, disabled)
	self._disabled = disabled
end

function TooltipBuilder.GetNumLines(self)
	return #self._lines
end

function TooltipBuilder.GetLine(self, index)
	local line = self._lines[index]
	local left, right = strsplit(LINE_PART_SEP, line)
	return left, right, self._lineColors[line]
end



-- ============================================================================
-- TooltipBuilder - Private Methods
-- ============================================================================

function TooltipBuilder._GetModifierHash(self)
	return (IsShiftKeyDown() and 4 or 0) + (IsAltKeyDown() and 2 or 0) + (IsControlKeyDown() and 1 or 0)
end

function TooltipBuilder._IsCached(self, itemString, quantity)
	if itemString == ItemString.GetPlaceholder() then
		return false
	end
	if self:_GetModifierHash() ~= self._modifier then
		return false
	end
	if self._itemString ~= itemString or self._quantity ~= quantity then
		return false
	end
	if GetTime() - self._lastUpdate >= TOOLTIP_CACHE_TIME then
		return false
	end
	if InCombatLockdown() ~= self._inCombat then
		return false
	end
	return true
end

function TooltipBuilder._Prepare(self, itemString, quantity)
	if self:_IsCached(itemString, quantity) then
		-- have the lines cached already
		return true
	end

	wipe(self._lines)
	wipe(self._lineColors)
	wipe(self._levelNumLines)
	wipe(self._levelHasHeading)
	self._level = 0
	self._levelNumLines[self._level] = 0
	self._lastUpdate = GetTime()
	self._modifier = self:_GetModifierHash()
	self._inCombat = InCombatLockdown()
	self._itemString = itemString
	self._quantity = quantity
	self._disabled = false

	if InCombatLockdown() and itemString ~= ItemString.GetPlaceholder() then
		self:AddLine(L["Can't load TSM tooltip while in combat"])
		return true
	else
		return false
	end
end

function TooltipBuilder._IsEmpty(self)
	assert(self._level == 0)
	return #self._lines == 0
end

function TooltipBuilder._LineIterator(self)
	return private.LineIteratorHelper, self, 0
end

function TooltipBuilder._TextsToStr(self, ...)
	local valueParts = TempTable.Acquire(...)
	for i = 1, #valueParts do
		valueParts[i] = self:ApplyValueColor(valueParts[i])
	end
	local result = table.concat(valueParts, " / ")
	TempTable.Release(valueParts)
	return result
end

function TooltipBuilder._ValuesToStr(self, ...)
	-- can't just build the table with the vararg as there may be nils
	local valueParts = TempTable.Acquire()
	for i = 1, select("#", ...) do
		local value = select(i, ...)
		valueParts[i] = self:FormatMoney(value)
	end
	local result = table.concat(valueParts, " / ")
	TempTable.Release(valueParts)
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LineIteratorHelper(self, index)
	index = index + 1
	if index > #self._lines then
		return
	end
	return index, self:GetLine(index)
end
