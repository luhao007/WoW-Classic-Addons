-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.Operations:NewPackage("Auctioning")
local private = {}
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local OPERATION_INFO = {
	-- general
	blacklist = { type = "string", default = "" },
	ignoreLowDuration = { type = "number", default = 0 },
	-- post
	postCap = { type = "number", default = 5 },
	keepQuantity = { type = "number", default = 0 },
	keepQtySources = { type = "table", default = {} },
	maxExpires = { type = "number", default = 0 },
	duration = { type = "number", default = 2, customSanitizeFunction = nil },
	bidPercent = { type = "number", default = 1 },
	undercut = { type = "string", default = "0c" },
	minPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(0.25*avg(crafting,dbmarket,dbregionmarketavg),1.5*vendorsell))" },
	maxPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(5*avg(crafting,dbmarket,dbregionmarketavg),30*vendorsell))" },
	normalPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(2*avg(crafting,dbmarket,dbregionmarketavg),12*vendorsell))" },
	priceReset = { type = "string", default = "none" },
	aboveMax = { type = "string", default = "normalPrice" },
	-- cancel
	cancelUndercut = { type = "boolean", default = true },
	keepPosted = { type = "number", default = 0 },
	cancelRepost = { type = "boolean", default = true },
	cancelRepostThreshold = { type = "string", default = "1g" },
}
local OPERATION_VALUE_LIMITS = {
	postCap = { min = 0, max = 5000 },
	keepQuantity = { min = 0, max = 5000 },
	maxExpires = { min = 0, max = 5000 },
	keepPosted = { min = 0, max = 5000 },
}
if not TSM.IsWow83() then
	OPERATION_INFO.undercut.default = "1c"
	OPERATION_INFO.matchStackSize = { type = "boolean", default = false }
	OPERATION_INFO.stackSize = { type = "number", default = 1 }
	OPERATION_INFO.stackSizeIsCap = { type = "boolean", default = false }
	OPERATION_VALUE_LIMITS.stackSize = { min = 1, max = 200 }
	OPERATION_VALUE_LIMITS.postCap.max = 200
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	OPERATION_INFO.duration.customSanitizeFunction = private.SanitizeDuration
	TSM.Operations.Register("Auctioning", L["Auctioning"], OPERATION_INFO, 20, private.GetOperationInfo, private.OperationSanitize)
end

function Auctioning.GetMinMaxValues(key)
	local info = OPERATION_VALUE_LIMITS[key]
	return info and info.min or -math.huge, info and info.max or math.huge
end

function Auctioning.GetMinPrice(itemString)
	return private.GetOperationValueHelper(itemString, "minPrice")
end

function Auctioning.GetMaxPrice(itemString)
	return private.GetOperationValueHelper(itemString, "maxPrice")
end

function Auctioning.GetNormalPrice(itemString)
	return private.GetOperationValueHelper(itemString, "normalPrice")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OperationSanitize(operation)
	if TSM.IsWow83() then
		if operation.stackSize then
			operation.postCap = operation.postCap * operation.stackSize
		end
		if (Money.FromString(operation.undercut) or math.huge) < 50 then
			operation.undercut = "0c"
		end
	end
end

function private.SanitizeDuration(value)
	-- convert from 12/24/48 durations to 1/2/3 API values
	if value == 12 then
		return 1
	elseif value == 24 then
		return 2
	elseif value == 48 then
		return 3
	else
		return value
	end
end

function private.GetOperationValueHelper(itemString, key)
	itemString = TSM.Groups.TranslateItemString(itemString)
	local operationName, operationSettings = TSM.Operations.GetFirstOperationByItem("Auctioning", itemString)
	if not operationName then
		return
	end
	return TSM.Auctioning.Util.GetPrice(key, operationSettings, itemString)
end

function private.GetOperationInfo(operationSettings)
	local parts = TempTable.Acquire()

	-- get the post string
	if operationSettings.postCap == 0 then
		tinsert(parts, L["No posting."])
	else
		tinsert(parts, format(L["Posting %d stack(s) of %d for %d hours."], operationSettings.postCap, operationSettings.stackSize, operationSettings.duration))
	end

	-- get the cancel string
	if operationSettings.cancelUndercut and operationSettings.cancelRepost then
		tinsert(parts, format(L["Canceling undercut auctions and to repost higher."]))
	elseif operationSettings.cancelUndercut then
		tinsert(parts, format(L["Canceling undercut auctions."]))
	elseif operationSettings.cancelRepost then
		tinsert(parts, format(L["Canceling to repost higher."]))
	else
		tinsert(parts, L["Not canceling."])
	end

	local result = table.concat(parts, " ")
	TempTable.Release(parts)
	return result
end
