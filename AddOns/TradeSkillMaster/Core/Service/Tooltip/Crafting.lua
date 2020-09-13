-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.Tooltip:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.Tooltip.Register(TSM.Tooltip.CreateInfo()
		:SetHeadings(L["TSM Crafting"])
		:SetSettingsModule("Crafting")
		:AddSettingEntry("craftingCost", true, private.PopulateCostLine)
		:AddSettingEntry("detailedMats", false, private.PopulateDetailedMatsLines)
		:AddSettingEntry("matPrice", false, private.PopulateMatPriceLine)
	)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateCostLine(tooltip, itemString)
	itemString = itemString and ItemString.GetBaseFast(itemString)
	assert(itemString)
	local cost, profit = nil, nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		cost = 55
		profit = 20
	elseif not TSM.Crafting.CanCraftItem(itemString) then
		return
	else
		cost = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
		local buyout = cost and TSM.Crafting.Cost.GetCraftedItemValue(itemString) or nil
		profit = buyout and (buyout - cost) or nil
	end

	local costText = tooltip:FormatMoney(cost)
	local profitText = tooltip:FormatMoney(profit, profit and Theme.GetFeedbackColor(profit >= 0 and "GREEN" or "RED") or nil)
	tooltip:AddLine(L["Crafting Cost"], format(L["%s (%s profit)"], costText, profitText))
end

function private.PopulateDetailedMatsLines(tooltip, itemString)
	itemString = itemString and ItemString.GetBaseFast(itemString)
	assert(itemString)
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		tooltip:StartSection()
		tooltip:AddSubItemValueLine(ItemString.GetPlaceholder(), 11, 5)
		tooltip:EndSection()
		return
	elseif not TSM.Crafting.CanCraftItem(itemString) then
		return
	end

	local _, spellId = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
	if not spellId then
		return
	end

	tooltip:StartSection()
	local numResult = TSM.Crafting.GetNumResult(spellId)
	for _, matItemString, matQuantity in TSM.Crafting.MatIterator(spellId) do
		tooltip:AddSubItemValueLine(matItemString, TSM.Crafting.Cost.GetMatCost(matItemString), matQuantity / numResult)
	end
	tooltip:EndSection()
end

function private.PopulateMatPriceLine(tooltip, itemString)
	itemString = itemString and ItemString.GetBase(itemString) or nil
	local matCost = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		matCost = 17
	else
		matCost = TSM.Crafting.Cost.GetMatCost(itemString)
	end
	if matCost then
		tooltip:AddItemValueLine(L["Material Cost"], matCost)
	end
end
