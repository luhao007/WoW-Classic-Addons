-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Builder = TSM.Init("Service.ItemTooltipClasses.Builder")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Math = TSM.Include("Util.Math")
local Money = TSM.Include("Util.Money")
local ItemInfo = TSM.Include("Service.ItemInfo")
local LibTSMClass = TSM.Include("LibTSMClass")
local TooltipBuilder = LibTSMClass.DefineClass("TooltipBuilder")
local private = {
	registeredCallbacks = {},
	registeredHeadingTextLefts = {},
	registeredContexts = {},
}
local HEADING_COLOR_STR = "|cffffff00"
local TOOLTIP_CACHE_TIME = 5
local LINE_PART_SEP = "\t"




-- ============================================================================
-- TooltipBuilder - Class Meta Methods
-- ============================================================================

function Builder.Create()
	return TooltipBuilder()
end

function Builder.RegisterInfo(callback, headingTextLeft, context)
	assert(type(callback) == "function" and type(headingTextLeft) == "string")
	tinsert(private.registeredCallbacks, callback)
	local index = #private.registeredCallbacks
	private.registeredHeadingTextLefts[index] = headingTextLeft
	private.registeredContexts[index] = context
end



-- ============================================================================
-- TooltipBuilder - Class Meta Methods
-- ============================================================================

function TooltipBuilder.__init(self)
	self._rootLines = {}
	self._currentLines = self._rootLines
	self._lastUpdate = 0
	self._modifier = nil
	self._inCombat = false
	self._itemString = nil
	self._quantity = nil
end



-- ============================================================================
-- TooltipBuilder - Public Methods
-- ============================================================================

function TooltipBuilder.FormatMoney(self, value, color)
	color = color or "|cffffffff"
	if TSM.db.global.tooltipOptions.tooltipPriceFormat == "icon" then
		return Money.ToString(value, color, "OPT_ICON")
	else
		return Money.ToString(value, color)
	end
end

function TooltipBuilder.AddLine(self, lineLeft, lineRight)
	local indent = self:_GetIndent()
	if lineRight then
		lineLeft = strjoin(LINE_PART_SEP, lineLeft, lineRight)
	end
	tinsert(self._currentLines, strrep("  ", indent)..lineLeft)
end

function TooltipBuilder.AddItemValueLine(self, label, value)
	if self._quantity > 1 then
		label = label.." x"..self._quantity
		value = value * self._quantity
	end
	self:AddLine(label, self:FormatMoney(value))
end

function TooltipBuilder.AddSubItemValueLine(self, itemString, value, multiplier, matRate, minAmount, maxAmount)
	local name = ItemInfo.GetName(itemString)
	local quality = ItemInfo.GetQuality(itemString)
	if not name or not quality then
		return
	end
	multiplier = Math.Round(multiplier * self._quantity, 0.001)
	matRate = matRate and matRate * 100
	matRate = matRate and matRate.."% " or ""
	local range = (minAmount and maxAmount) and (minAmount ~= maxAmount and "|cffffff00 ["..minAmount.."-"..maxAmount.."]|r" or "|cffffff00 ["..minAmount.."]|r") or ""
	value = value * multiplier
	self:AddLine("|c"..select(4, GetItemQualityColor(quality))..matRate..name.." x"..multiplier.."|r"..range, self:FormatMoney(value))
end

function TooltipBuilder.StartSection(self)
	local lines = TempTable.Acquire()
	lines._parent = self._currentLines
	self._currentLines = lines
end

function TooltipBuilder.EndSection(self, headingTextLeft, headingTextRight)
	local lines = self._currentLines
	assert(lines ~= self._rootLines)
	self._currentLines = lines._parent
	if #lines > 0 then
		if headingTextLeft and self._currentLines == self._rootLines then
			headingTextLeft = HEADING_COLOR_STR..headingTextLeft.."|r"
		end
		if headingTextRight then
			self:AddLine(headingTextLeft, headingTextRight)
		elseif headingTextLeft then
			self:AddLine(headingTextLeft)
		end
		for _, line in ipairs(lines) do
			self:AddLine(line)
		end
	end
	TempTable.Release(lines)
end



-- ============================================================================
-- TooltipBuilder - Private Methods
-- ============================================================================

function TooltipBuilder._GetIndent(self)
	local indent = 0
	local tbl = self._currentLines
	while tbl._parent do
		indent = indent + 1
		tbl = tbl._parent
	end
	assert(tbl == self._rootLines)
	return indent
end

function TooltipBuilder._GetModifierHash(self)
	return (IsShiftKeyDown() and 4 or 0) + (IsAltKeyDown() and 2 or 0) + (IsControlKeyDown() and 1 or 0)
end

function TooltipBuilder._IsCached(self, itemString, quantity)
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

function TooltipBuilder._Populate(self, itemString, quantity)
	if self:_IsCached(itemString, quantity) then
		-- have the lines cached already
		return
	end

	assert(self._currentLines == self._rootLines)
	wipe(self._rootLines)
	self._lastUpdate = GetTime()
	self._modifier = self:_GetModifierHash()
	self._inCombat = InCombatLockdown()
	self._itemString = itemString
	self._quantity = quantity

	if InCombatLockdown() then
		self:AddLine(L["Can't load TSM tooltip while in combat"])
	else
		-- insert lines
		for i = 1, #private.registeredCallbacks do
			self:StartSection()
			local headingTextRight = private.registeredCallbacks[i](self, itemString, private.registeredContexts[i])
			self:EndSection(private.registeredHeadingTextLefts[i], headingTextRight)
		end
	end
end

function TooltipBuilder._IsEmpty(self)
	assert(self._currentLines == self._rootLines)
	return #self._rootLines == 0
end

function TooltipBuilder._LineIterator(self)
	return private.LineIteratorHelper, self, -1
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LineIteratorHelper(builder, index)
	index = index + 1
	if index == 0 or index == #builder._rootLines + 1 then
		return index, " "
	elseif index > #builder._rootLines then
		return
	end
	return index, strsplit(LINE_PART_SEP, builder._rootLines[index])
end
