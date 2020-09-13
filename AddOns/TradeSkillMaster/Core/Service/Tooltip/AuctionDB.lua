-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM.Tooltip:NewPackage("AuctionDB")
local L = TSM.Include("Locale").GetTable()
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local private = {}
local INFO = {
	{ key = "minBuyout", default = true, label = L["Min Buyout"] },
	{ key = "marketValue", default = true, label = L["Market Value"] },
	{ key = "historical", default = false, label = L["Historical Price"] },
	{ key = "regionMinBuyout", default = false, label = L["Region Min Buyout Avg"] },
	{ key = "regionMarketValue", default = true, label = L["Region Market Value Avg"] },
	{ key = "regionHistorical", default = false, label = L["Region Historical Price"] },
	{ key = "regionSale", default = true, label = L["Region Sale Avg"] },
	{ key = "regionSalePercent", default = true, label = L["Region Sale Rate"] },
	{ key = "regionSoldPerDay", default = true, label = L["Region Avg Daily Sold"] },
}
local DATA_OLD_THRESHOLD_SECONDS = 60 * 60 * 3



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnInitialize()
	local tooltipInfo = TSM.Tooltip.CreateInfo()
		:SetHeadings(L["TSM AuctionDB"], private.PopulateRightText)
		:SetSettingsModule("AuctionDB")
	for _, info in ipairs(INFO) do
		tooltipInfo:AddSettingEntry(info.key, info.default, private.PopulateLine, info)
	end
	TSM.Tooltip.Register(tooltipInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateLine(tooltip, itemString, info)
	local value = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		value = 11
	elseif strmatch(info.key, "^region") then
		value = TSM.AuctionDB.GetRegionItemData(itemString, info.key)
	else
		value = TSM.AuctionDB.GetRealmItemData(itemString, info.key)
	end
	if value then
		if info.key == "regionSalePercent" or info.key == "regionSoldPerDay" then
			tooltip:AddTextLine(info.label, format("%0.2f", value/100))
		else
			tooltip:AddItemValueLine(info.label, value)
		end
	end
end

function private.PopulateRightText(tooltip, itemString)
	local lastScan, numAuctions = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		lastScan = time() - 120
		numAuctions = 5
	else
		lastScan = TSM.AuctionDB.GetRealmItemData(itemString, "lastScan")
		numAuctions = TSM.AuctionDB.GetRealmItemData(itemString, "numAuctions") or 0
	end
	if lastScan then
		local timeColor = (time() - lastScan) > DATA_OLD_THRESHOLD_SECONDS and Theme.GetFeedbackColor("RED") or Theme.GetFeedbackColor("GREEN")
		local timeDiff = SecondsToTime(time() - lastScan)
		return tooltip:ApplyValueColor(format(L["%d auctions"], numAuctions)).." ("..timeColor:ColorText(format(L["%s ago"], timeDiff))..")"
	else
		return tooltip:ApplyValueColor(L["Not Scanned"])
	end
end
