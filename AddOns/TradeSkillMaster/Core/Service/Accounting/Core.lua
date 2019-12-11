-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Accounting = TSM:NewPackage("Accounting")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Math = TSM.Include("Util.Math")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Accounting.GetSummarySalesInfo(timeFilter, characterFilter)
	return private.GetSummaryInfoByType("sale", timeFilter, characterFilter)
end

function Accounting.GetSummaryExpensesInfo(timeFilter, characterFilter)
	return private.GetSummaryInfoByType("buy", timeFilter, characterFilter)
end

function Accounting.GetSummaryProfitTopItem(timeFilter, characterFilter)
	local query = TSM.Accounting.Transactions.CreateQuery()
		:Select("type", "itemString", "price", "quantity")
		:GreaterThan("time", private.DateFilter(timeFilter))
	if characterFilter then
		query:Or()
				:Equal("player", characterFilter)
				:Custom(private.GuildQueryFilter, characterFilter)
			:End()
	end

	local totalSalePrice = TempTable.Acquire()
	local numSales = TempTable.Acquire()
	local totalBuyPrice = TempTable.Acquire()
	local numBuys = TempTable.Acquire()
	for _, recordType, itemString, price, quantity in query:Iterator() do
		if recordType == "sale" then
			totalSalePrice[itemString] = (totalSalePrice[itemString] or 0) + price * quantity
			numSales[itemString] = (numSales[itemString] or 0) + quantity
		elseif recordType == "buy" then
			totalBuyPrice[itemString] = (totalBuyPrice[itemString] or 0) + price * quantity
			numBuys[itemString] = (numBuys[itemString] or 0) + quantity
		else
			error("Invalid recordType: "..tostring(recordType))
		end
	end
	query:Release()

	local topItemString, topItemProfit = nil, 0
	for itemString in pairs(numSales) do
		if numBuys[itemString] then
			local profit = (totalSalePrice[itemString] / numSales[itemString] - totalBuyPrice[itemString] / numBuys[itemString]) * min(numSales[itemString], numBuys[itemString])
			if profit > topItemProfit then
				topItemString = itemString
				topItemProfit = profit
			end
		end
	end
	TempTable.Release(totalSalePrice)
	TempTable.Release(numSales)
	TempTable.Release(totalBuyPrice)
	TempTable.Release(numBuys)

	return topItemString
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DateFilter(timePeriod)
	local dateFilter = 0
	if timePeriod == L["Past Year"] then
		dateFilter = time() - (60 * 60 * 24 * 30 * 12)
	elseif timePeriod == L["Past Month"] then
		dateFilter = time() - (60 * 60 * 24 * 30)
	elseif timePeriod == L["Past 7 Days"] then
		dateFilter = time() - (60 * 60 * 24 * 7)
	elseif timePeriod == L["Past Day"] then
		dateFilter = time() - (60 * 60 * 24)
	else
		error("Unknown Time Period")
	end
	return dateFilter
end

function private.GuildQueryFilter(row, guildFilter)
	return TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(row:GetField("player")) == guildFilter
end

function private.GetSummaryInfoByType(recordType, timeFilter, characterFilter)
	local query = TSM.Accounting.Transactions.CreateQuery()
		:Select("itemString", "price", "quantity", "time")
		:Equal("type", recordType)
		:GreaterThan("time", private.DateFilter(timeFilter))
	if characterFilter then
		query:Or()
				:Equal("player", characterFilter)
				:Custom(private.GuildQueryFilter, characterFilter)
			:End()
	end

	local numDays = 1
	local itemTotals = TempTable.Acquire()
	for _, itemString, price, quantity, timestamp in query:Iterator() do
		local daysAgo = floor((time() - timestamp) / (24 * 60 * 60))
		numDays = max(numDays, daysAgo)
		itemTotals[itemString] = (itemTotals[itemString] or 0) + price * quantity
	end
	query:Release()

	local topItemString = nil
	local topItemTotal = 0
	local total = 0
	for itemString, itemTotal in pairs(itemTotals) do
		total = total + itemTotal
		if itemTotal > topItemTotal then
			topItemString = itemString
			topItemTotal = itemTotal
		end
	end
	TempTable.Release(itemTotals)

	return total, Math.Round(total / numDays), topItemString
end
