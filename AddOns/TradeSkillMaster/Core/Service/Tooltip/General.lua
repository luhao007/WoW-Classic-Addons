-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
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



-- ============================================================================
-- Module Functions
-- ============================================================================

function General.LoadTooltip(tooltip, itemString)
	-- add group / operation info
	if TSM.db.global.tooltipOptions.groupNameTooltip then
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			local leftText = nil
			if TSM.Groups.IsItemInGroup(itemString) then
				leftText = GROUP
			else
				leftText = GROUP.."("..L["Base Item"]..")"
			end
			tooltip:AddLine(leftText, "|cffffffff"..TSM.Groups.Path.Format(groupPath).."|r")
			for _, moduleName in TSM.Operations.ModuleIterator() do
				if TSM.db.global.tooltipOptions.operationTooltips[moduleName] then
					local operations = TempTable.Acquire()
					for _, operationName in TSM.Groups.OperationIterator(groupPath, moduleName) do
						tinsert(operations, operationName)
					end
					if #operations > 0 then
						tooltip:AddLine(format(#operations == 1 and L["%s operation"] or L["%s operations"], TSM.Operations.GetLocalizedName(moduleName)), "|cffffffff"..table.concat(operations, ", ").."|r")
					end
					TempTable.Release(operations)
				end
			end
		end
	end

	-- add disenchant value info
	if TSM.db.global.tooltipOptions.deTooltip then
		local value = CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, Conversions.METHOD.DISENCHANT)
		if value then
			tooltip:AddItemValueLine(L["Disenchant Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				local quality = ItemInfo.GetQuality(itemString)
				local ilvl = ItemInfo.GetItemLevel(ItemString.GetBase(itemString))
				local classId = ItemInfo.GetClassId(itemString)
				for targetItemString in DisenchantInfo.TargetItemIterator() do
					local amountOfMats, matRate, minAmount, maxAmount = DisenchantInfo.GetTargetItemSourceInfo(targetItemString, classId, quality, ilvl)
					if amountOfMats then
						local matValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
						if matValue > 0 then
							tooltip:AddSubItemValueLine(targetItemString, matValue, amountOfMats, matRate, minAmount, maxAmount)
						end
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add mill value info
	if TSM.db.global.tooltipOptions.millTooltip then
		local value = CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, Conversions.METHOD.MILL)
		if value then
			tooltip:AddItemValueLine(L["Mill Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for targetItemString, rate in Conversions.TargetItemsByMethodIterator(itemString, Conversions.METHOD.MILL) do
					local millValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
					if millValue > 0 then
						tooltip:AddSubItemValueLine(targetItemString, millValue, rate)
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add prospect value info
	if TSM.db.global.tooltipOptions.prospectTooltip then
		local value = CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, Conversions.METHOD.PROSPECT)
		if value then
			tooltip:AddItemValueLine(L["Prospect Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for targetItemString, rate in Conversions.TargetItemsByMethodIterator(itemString, Conversions.METHOD.PROSPECT) do
					local prospectValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
					if prospectValue > 0 then
						tooltip:AddSubItemValueLine(targetItemString, prospectValue, rate)
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add transform value info
	if TSM.db.global.tooltipOptions.transformTooltip then
		local value = CustomPrice.GetConversionsValue(itemString, TSM.db.global.coreOptions.destroyValueSource, Conversions.METHOD.TRANSFORM)
		if value then
			tooltip:AddItemValueLine(L["Transform Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for targetItemString, rate in Conversions.TargetItemsByMethodIterator(itemString, Conversions.METHOD.TRANSFORM) do
					local transformValue = CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItemString) or 0
					if transformValue > 0 then
						tooltip:AddSubItemValueLine(targetItemString, transformValue, rate)
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add vendor buy price
	if TSM.db.global.tooltipOptions.vendorBuyTooltip then
		local value = ItemInfo.GetVendorBuy(itemString) or 0
		if value > 0 then
			tooltip:AddItemValueLine(L["Vendor Buy Price"], value)
		end
	end

	-- add vendor sell price
	if TSM.db.global.tooltipOptions.vendorSellTooltip then
		local value = ItemInfo.GetVendorSell(itemString) or 0
		if value > 0 then
			tooltip:AddItemValueLine(L["Vendor Sell Price"], value)
		end
	end

	-- add custom price sources
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		if TSM.db.global.tooltipOptions.customPriceTooltips[name] then
			local price = CustomPrice.GetValue(name, itemString) or 0
			if price > 0 then
				tooltip:AddItemValueLine(L["Custom Price Source"].." '"..name.."'", price)
			end
		end
	end

	-- add inventory information
	if TSM.db.global.tooltipOptions.inventoryTooltipFormat == "full" then
		tooltip:StartSection()
		local totalNum = 0
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local realm = strmatch(factionrealm, "^.* "..String.Escape("-").." (.*)")
				if realm == GetRealmName() then
					realm = ""
				else
					realm = " - "..realm
				end
				local bag = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				local bank = TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				local reagentBank = TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				local auction = TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
				local mail = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
				local playerTotal = bag + bank + reagentBank + auction + mail
				if playerTotal > 0 then
					totalNum = totalNum + playerTotal
					local classColor = RAID_CLASS_COLORS[TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), "internalData", "classKey")]
					local rightText = format(L["%s (%s bags, %s bank, %s AH, %s mail)"], "|cffffffff"..playerTotal.."|r", "|cffffffff"..bag.."|r", "|cffffffff"..(bank+reagentBank).."|r", "|cffffffff"..auction.."|r", "|cffffffff"..mail.."|r")
					if classColor then
						tooltip:AddLine("|c"..classColor.colorStr..character..realm.."|r", rightText)
					else
						tooltip:AddLine(character..realm, rightText)
					end
				end
			end
		end
		for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
			local guildQuantity = TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guildName)
			if guildQuantity > 0 then
				totalNum = totalNum + guildQuantity
				tooltip:AddLine(guildName, format(L["%s in guild vault"], "|cffffffff"..guildQuantity.."|r"))
			end
		end
		tooltip:EndSection(L["Inventory"], format(L["%s total"], "|cffffffff"..totalNum.."|r"))
	elseif TSM.db.global.tooltipOptions.inventoryTooltipFormat == "simple" then
		local totalPlayer, totalAlt, totalGuild, totalAuction = 0, 0, 0, 0
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local bag = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				local bank = TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				local reagentBank = TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				local auction = TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
				local mail = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
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
			totalGuild = totalGuild + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guildName)
		end
		local totalNum = totalPlayer + totalAlt + totalGuild + totalAuction
		if totalNum > 0 then
			local rightText = nil
			if not TSM.IsWowClassic() then
				rightText = format(L["%s (%s player, %s alts, %s guild, %s AH)"], "|cffffffff"..totalNum.."|r", "|cffffffff"..totalPlayer.."|r", "|cffffffff"..totalAlt.."|r", "|cffffffff"..totalGuild.."|r", "|cffffffff"..totalAuction.."|r")
			else
				rightText = format(L["%s (%s player, %s alts, %s AH)"], "|cffffffff"..totalNum.."|r", "|cffffffff"..totalPlayer.."|r", "|cffffffff"..totalAlt.."|r", "|cffffffff"..totalAuction.."|r")
			end
			tooltip:AddLine(L["Inventory"], rightText)
		end
	end
end
