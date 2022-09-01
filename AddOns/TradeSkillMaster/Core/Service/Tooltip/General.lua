-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local General = TSM.Tooltip:NewPackage("General")
local L = TSM.Include("Locale").GetTable()
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local TempTable = TSM.Include("Util.TempTable")
local String = TSM.Include("Util.String")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Conversions = TSM.Include("Service.Conversions")
local Inventory = TSM.Include("Service.Inventory")
local private = {
	tooltipInfo = nil,
	guildQuantityCache = {},
}
local DESTROY_INFO = {
	{ key = "deTooltip", method = Conversions.METHOD.DISENCHANT },
	{ key = "millTooltip", method = Conversions.METHOD.MILL },
	{ key = "prospectTooltip", method = Conversions.METHOD.PROSPECT },
	{ key = "transformTooltip", method = Conversions.METHOD.TRANSFORM },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function General.OnInitialize()
	local tooltipInfo = TSM.Tooltip.CreateInfo()
		:SetHeadings(L["TSM General Info"])
	private.tooltipInfo = tooltipInfo
	CustomPrice.RegisterCustomSourceCallback(private.UpdateCustomSources)

	-- group name
	tooltipInfo:AddSettingEntry("groupNameTooltip", nil, private.PopulateGroupLine)

	-- operations
	for _, moduleName in TSM.Operations.ModuleIterator() do
		tooltipInfo:AddSettingEntry("operationTooltips."..moduleName, false, private.PopulateOperationLine, moduleName)
	end

	-- destroy info
	for _, info in ipairs(DESTROY_INFO) do
		tooltipInfo:AddSettingEntry(info.key, nil, private.PopulateDestroyValueLine, info.method)
		tooltipInfo:AddSettingEntry("detailedDestroyTooltip", nil, private.PopulateDetailLines, info.method)
	end

	-- vendor prices
	tooltipInfo:AddSettingEntry("vendorBuyTooltip", nil, private.PopulateVendorBuyLine)
	tooltipInfo:AddSettingEntry("vendorSellTooltip", nil, private.PopulateVendorSellLine)

	-- custom sources
	private.UpdateCustomSources()

	-- inventory info
	tooltipInfo:AddSettingValueEntry("inventoryTooltipFormat", "full", "none", private.PopulateFullInventoryLines)
	tooltipInfo:AddSettingValueEntry("inventoryTooltipFormat", "simple", "none", private.PopulateSimpleInventoryLine)

	TSM.Tooltip.Register(tooltipInfo)
end

function private.UpdateCustomSources()
	private.tooltipInfo:DeleteSettingsByKeyMatch("^customPriceTooltips%.")
	local customPriceSources = TempTable.Acquire()
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		tinsert(customPriceSources, name)
	end
	sort(customPriceSources)
	for _, name in ipairs(customPriceSources) do
		private.tooltipInfo:AddSettingEntry("customPriceTooltips."..name, false, private.PopulateCustomPriceLine, name)
	end
	TempTable.Release(customPriceSources)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateGroupLine(tooltip, itemString)
	-- add group / operation info
	local groupPath, itemInGroup = nil, nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		groupPath = L["Example"]
		itemInGroup = true
	else
		groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath == TSM.CONST.ROOT_GROUP_PATH then
			groupPath = nil
		else
			itemInGroup = TSM.Groups.IsItemInGroup(itemString)
		end
	end
	if groupPath then
		local leftText = nil
		if itemInGroup then
			leftText = GROUP
		elseif ItemString.ParseLevel(TSM.Groups.TranslateItemString(itemString)) then
			leftText = GROUP.." ("..L["Item Level"]..")"
		else
			leftText = GROUP.." ("..L["Base Item"]..")"
		end
		tooltip:AddTextLine(leftText, TSM.Groups.Path.Format(groupPath))
	end
end

function private.PopulateOperationLine(tooltip, itemString, moduleName)
	assert(moduleName)
	local operations = TempTable.Acquire()
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		tinsert(operations, L["Example"])
	else
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath == TSM.CONST.ROOT_GROUP_PATH then
			groupPath = nil
		end
		if not groupPath then
			TempTable.Release(operations)
			return
		end
		for _, operationName in TSM.Operations.GroupOperationIterator(moduleName, groupPath) do
			tinsert(operations, operationName)
		end
	end
	if #operations > 0 then
		tooltip:AddLine(format(#operations == 1 and L["%s operation"] or L["%s operations"], TSM.Operations.GetLocalizedName(moduleName)), tooltip:ApplyValueColor(table.concat(operations, ", ")))
	end
	TempTable.Release(operations)
end

function private.PopulateDestroyValueLine(tooltip, itemString, method)
	local value = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		if method == Conversions.METHOD.DISENCHANT then
			value = 10
		elseif method == Conversions.METHOD.MILL then
			value = 50
		elseif method == Conversions.METHOD.PROSPECT then
			value = 20
		elseif method == Conversions.METHOD.TRANSFORM then
			value = 30
		else
			error("Invalid method: "..tostring(method))
		end
	else
		value = CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, method)
	end
	if not value then
		return
	end

	local label = nil
	if method == Conversions.METHOD.DISENCHANT then
		label = L["Disenchant Value"]
	elseif method == Conversions.METHOD.MILL then
		label = L["Mill Value"]
	elseif method == Conversions.METHOD.PROSPECT then
		label = L["Prospect Value"]
	elseif method == Conversions.METHOD.TRANSFORM then
		label = L["Transform Value"]
	else
		error("Invalid method: "..tostring(method))
	end
	tooltip:AddItemValueLine(label, value)
end

function private.PopulateDetailLines(tooltip, itemString, method)
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		tooltip:StartSection()
		if method == Conversions.METHOD.DISENCHANT then
			tooltip:AddSubItemValueLine(ItemString.GetPlaceholder(), 1, 10, 1, 1, 20)
		elseif method == Conversions.METHOD.MILL then
			tooltip:AddSubItemValueLine(ItemString.GetPlaceholder(), 5, 10, 1)
		elseif method == Conversions.METHOD.PROSPECT then
			tooltip:AddSubItemValueLine(ItemString.GetPlaceholder(), 2, 10, 1, 1, 20)
		elseif method == Conversions.METHOD.TRANSFORM then
			tooltip:AddSubItemValueLine(ItemString.GetPlaceholder(), 3, 10, 1)
		else
			error("Invalid method: "..tostring(method))
		end
		tooltip:EndSection()
		return
	elseif not CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, method) then
		return
	end

	tooltip:StartSection()
	if method == Conversions.METHOD.DISENCHANT then
		local quality = ItemInfo.GetQuality(itemString)
		local itemLevel = not TSM.IsWowClassic() and ItemInfo.GetItemLevel(itemString) or ItemInfo.GetItemLevel(ItemString.GetBase(itemString))
		local classId = ItemInfo.GetClassId(itemString)
		local expansion = not TSM.IsWowClassic() and ItemInfo.GetExpansion(itemString) or nil
		for targetItemString in DisenchantInfo.TargetItemIterator() do
			local amountOfMats, matRate, minAmount, maxAmount = DisenchantInfo.GetTargetItemSourceInfo(targetItemString, classId, quality, itemLevel, expansion)
			if amountOfMats then
				local matValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
				if matValue > 0 then
					tooltip:AddSubItemValueLine(targetItemString, matValue, amountOfMats, matRate, minAmount, maxAmount)
				end
			end
		end
	else
		for targetItemString, amountOfMats, matRate, minAmount, maxAmount in Conversions.TargetItemsByMethodIterator(itemString, method) do
			local matValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
			if matValue > 0 then
				tooltip:AddSubItemValueLine(targetItemString, matValue, amountOfMats, matRate, minAmount, maxAmount)
			end
		end
	end
	tooltip:EndSection()
end

function private.PopulateVendorBuyLine(tooltip, itemString)
	local value = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example item
		value = 50
	else
		value = ItemInfo.GetVendorBuy(itemString) or 0
	end
	if value > 0 then
		tooltip:AddItemValueLine(L["Vendor Buy Price"], value)
	end
end

function private.PopulateVendorSellLine(tooltip, itemString)
	local value = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example item
		value = 8
	else
		value = ItemInfo.GetVendorSell(itemString) or 0
	end
	if value > 0 then
		tooltip:AddItemValueLine(L["Vendor Sell Price"], value)
	end
end

function private.PopulateCustomPriceLine(tooltip, itemString, name)
	assert(name)
	if not TSM.db.global.userData.customPriceSources[name] then
		-- TODO: this custom price source has been removed (ideally shouldn't get here)
		return
	end
	local value = nil
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		value = 10
	else
		value = CustomPrice.GetValue(name, itemString) or 0
	end
	if value > 0 then
		tooltip:AddItemValueLine(L["Custom Source"].." ("..name..")", value)
	end
end

function private.PopulateFullInventoryLines(tooltip, itemString)
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		local totalNum = 0
		local playerName = UnitName("player")
		local bag, bank, auction, mail, guildQuantity = 5, 4, 4, 9, 1
		local playerTotal = bag + bank + auction + mail
		totalNum = totalNum + playerTotal
		tooltip:StartSection(L["Inventory"], format(L["%s total"], tooltip:ApplyValueColor(totalNum)))
		local classColor = RAID_CLASS_COLORS[TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(UnitName("player")), "internalData", "classKey")]
		local rightText = private.RightTextFormatHelper(tooltip, L["%s (%s bags, %s bank, %s AH, %s mail)"], playerTotal, bag, bank, auction, mail)
		if classColor then
			tooltip:AddLine("|c"..classColor.colorStr..playerName.."|r", rightText)
		else
			tooltip:AddLine(playerName, rightText)
		end
		totalNum = totalNum + guildQuantity
		tooltip:AddLine(L["Example"], format(L["%s in guild vault"], tooltip:ApplyValueColor(guildQuantity)))
		tooltip:EndSection()
		return
	end

	-- calculate the total number
	local totalNum = 0
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			local bag = Inventory.GetBagQuantity(itemString, character, factionrealm)
			local bank = Inventory.GetBankQuantity(itemString, character, factionrealm)
			local reagentBank = Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
			local auction = Inventory.GetAuctionQuantity(itemString, character, factionrealm)
			local mail = Inventory.GetMailQuantity(itemString, character, factionrealm)
			totalNum = totalNum + bag + bank + reagentBank + auction + mail
		end
	end
	wipe(private.guildQuantityCache)
	for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		local guildQuantity = Inventory.GetGuildQuantity(itemString, guildName)
		if guildQuantity > 0 then
			private.guildQuantityCache[guildName] = guildQuantity
			totalNum = totalNum + guildQuantity
		end
	end
	tooltip:StartSection(L["Inventory"], format(L["%s total"], tooltip:ApplyValueColor(totalNum)))

	-- add the lines
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			local realm = strmatch(factionrealm, "^.* "..String.Escape("-").." (.*)")
			if realm == GetRealmName() then
				realm = ""
			else
				realm = " - "..realm
			end
			local bag = Inventory.GetBagQuantity(itemString, character, factionrealm)
			local bank = Inventory.GetBankQuantity(itemString, character, factionrealm)
			local reagentBank = Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
			local auction = Inventory.GetAuctionQuantity(itemString, character, factionrealm)
			local mail = Inventory.GetMailQuantity(itemString, character, factionrealm)
			local playerTotal = bag + bank + reagentBank + auction + mail
			if playerTotal > 0 then
				local classColor = RAID_CLASS_COLORS[TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm), "internalData", "classKey")]
				local rightText = private.RightTextFormatHelper(tooltip, L["%s (%s bags, %s bank, %s AH, %s mail)"], playerTotal, bag, bank + reagentBank, auction, mail)
				if classColor then
					tooltip:AddLine("|c"..classColor.colorStr..character..realm.."|r", rightText)
				else
					tooltip:AddLine(character..realm, rightText)
				end
			end
		end
	end
	for guildName, guildQuantity in pairs(private.guildQuantityCache) do
		tooltip:AddLine(guildName, format(L["%s in guild vault"], tooltip:ApplyValueColor(guildQuantity)))
	end
	tooltip:EndSection()
end

function private.PopulateSimpleInventoryLine(tooltip, itemString)
	if itemString == ItemString.GetPlaceholder() then
		-- example tooltip
		local totalPlayer, totalAlt, totalGuild, totalAuction = 18, 0, 1, 4
		local totalNum2 = totalPlayer + totalAlt + totalGuild + totalAuction
		local rightText2 = nil
		if not TSM.IsWowVanillaClassic() then
			rightText2 = private.RightTextFormatHelper(tooltip, L["%s (%s player, %s alts, %s guild, %s AH)"], totalNum2, totalPlayer, totalAlt, totalGuild, totalAuction)
		else
			rightText2 = private.RightTextFormatHelper(tooltip, L["%s (%s player, %s alts, %s AH)"], totalNum2, totalPlayer, totalAlt, totalAuction)
		end
		tooltip:AddLine(L["Inventory"], rightText2)
	end

	local totalPlayer, totalAlt, totalGuild, totalAuction = 0, 0, 0, 0
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			local bag = Inventory.GetBagQuantity(itemString, character, factionrealm)
			local bank = Inventory.GetBankQuantity(itemString, character, factionrealm)
			local reagentBank = Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
			local auction = Inventory.GetAuctionQuantity(itemString, character, factionrealm)
			local mail = Inventory.GetMailQuantity(itemString, character, factionrealm)
			if character == UnitName("player") then
				totalPlayer = totalPlayer + bag + bank + reagentBank + mail
				totalAuction = totalAuction + auction
			else
				totalAlt = totalAlt + bag + bank + reagentBank + mail
				totalAuction = totalAuction + auction
			end
		end
	end
	for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		totalGuild = totalGuild + Inventory.GetGuildQuantity(itemString, guildName)
	end
	local totalNum = totalPlayer + totalAlt + totalGuild + totalAuction
	if totalNum > 0 then
		local rightText = nil
		if not TSM.IsWowVanillaClassic() then
			rightText = private.RightTextFormatHelper(tooltip, L["%s (%s player, %s alts, %s guild, %s AH)"], totalNum, totalPlayer, totalAlt, totalGuild, totalAuction)
		else
			rightText = private.RightTextFormatHelper(tooltip, L["%s (%s player, %s alts, %s AH)"], totalNum, totalPlayer, totalAlt, totalAuction)
		end
		tooltip:AddLine(L["Inventory"], rightText)
	end
end

function private.RightTextFormatHelper(tooltip, fmtStr, ...)
	local parts = TempTable.Acquire(...)
	for i = 1, #parts do
		parts[i] = tooltip:ApplyValueColor(parts[i])
	end
	local result = format(fmtStr, unpack(parts))
	TempTable.Release(parts)
	return result
end
