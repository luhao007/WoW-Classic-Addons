-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local ProfessionUtil = TSM.Crafting:NewPackage("ProfessionUtil")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local CraftString = TSM.Include("Util.CraftString")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local Delay = TSM.Include("Util.Delay")
local Table = TSM.Include("Util.Table")
local ItemString = TSM.Include("Util.ItemString")
local RecipeString = TSM.Include("Util.RecipeString")
local TempTable = TSM.Include("Util.TempTable")
local ItemInfo = TSM.Include("Service.ItemInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	craftQuantity = nil,
	craftString = nil,
	craftSpellId = nil,
	craftBaseString = nil,
	craftCallback = nil,
	craftName = nil,
	castingTimeout = nil,
	craftTimeout = nil,
	preparedSpellId = nil,
	preparedTime = 0,
	categoryInfoTemp = {},
	timeoutTimer = nil,
	resultQualityTemp = {},
	itemLocation = ItemLocation:CreateEmpty(),
}
local PROFESSION_LOOKUP = {
	["Costura"] = "Sastrería",
	["Marroquinería"] = "Peletería",
	["Ingénierie"] = "Ingénieur",
	["Secourisme"] = "Premiers soins",
}
local EMPTY_MATS_TABLE = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionUtil.OnInitialize()
	private.timeoutTimer = Delay.CreateTimer("PROFESSION_UTIL_TIMEOUT", private.CraftTimeoutMonitor)
	Event.Register("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if TSM.IsWowClassic() then
			if GetSpellInfo(spellId) ~= private.craftName then
				return
			end
		else
			local baseItemString = ItemString.GetBase(C_TradeSkillUI.GetRecipeItemLink(spellId)) or ""
			if spellId ~= private.craftSpellId and baseItemString ~= private.craftBaseString then
				return
			end
		end

		if not TSM.IsWowClassic() then
			-- check if we need to update bank quantity manually
			for _, itemString, quantity in TSM.Crafting.MatIterator(private.craftString) do
				local bagQuantity, bankQuantity, reagentBankQuantity = BagTracking.GetQuantities(itemString)
				local bankUsed = quantity - bagQuantity
				if bankUsed > 0 and bankUsed <= (bankQuantity + reagentBankQuantity) then
					Log.Info("Used %d from bank", bankUsed)
					BagTracking.ForceBankQuantityDeduction(itemString, bankUsed)
				end
			end
		end

		local callback = private.craftCallback
		assert(callback)
		private.craftQuantity = private.craftQuantity - 1
		private.DoCraftCallback(true, private.craftQuantity == 0)
		-- ignore profession updates from crafting something
		TSM.Crafting.ProfessionScanner.IgnoreNextProfessionUpdates()
		-- restart the timeout
	end)
	local function SpellCastFailedEventHandler(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if TSM.IsWowClassic() then
			if GetSpellInfo(spellId) ~= private.craftName then
				return
			end
		else
			local baseItemString = ItemString.GetBase(C_TradeSkillUI.GetRecipeItemLink(spellId)) or ""
			if spellId ~= private.craftSpellId and baseItemString ~= private.craftBaseString then
				return
			end
		end
		private.DoCraftCallback(false, true)
	end
	local function ClearCraftCast()
		private.craftQuantity = nil
		private.craftString = nil
		private.craftSpellId = nil
		private.craftBaseString = nil
		private.craftName = nil
		private.castingTimeout = nil
		private.craftTimeout = nil
	end
	Event.Register("UNIT_SPELLCAST_INTERRUPTED", SpellCastFailedEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED", SpellCastFailedEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED_QUIET", SpellCastFailedEventHandler)
	Event.Register("TRADE_SKILL_CLOSE", ClearCraftCast)
	if TSM.IsWowClassic() then
		Event.Register("CRAFT_CLOSE", ClearCraftCast)
	end
end

function ProfessionUtil.GetCurrentProfessionInfo()
	if TSM.IsWowClassic() then
		local name = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftSkillLine(1) or GetTradeSkillLine()
		return name
	else
		local info = C_TradeSkillUI.GetBaseProfessionInfo()
		return info.parentProfessionName or info.professionName, info.profession
	end
end

function ProfessionUtil.GetResultInfo(craftString)
	-- get the links
	local spellId = CraftString.GetSpellId(craftString)
	local resultItem = ProfessionUtil.GetRecipeResultItem(craftString)
	if not resultItem then
		return nil, nil, nil
	end
	if type(resultItem) == "table" then
		-- TODO: Update the caller to handle multiple result items
		local itemLink = resultItem[1]
		return TSM.UI.GetColoredItemName(itemLink), ItemString.Get(itemLink), ItemInfo.GetTexture(itemLink)
	elseif strfind(resultItem, "enchant:") then
		-- result of craft is not an item
		local indirectSpellId = nil
		if TSM.IsWowWrathClassic() then
			indirectSpellId = strmatch(resultItem, "enchant:(%d+)")
			indirectSpellId = indirectSpellId and tonumber(indirectSpellId)
			if not indirectSpellId then
				return true
			end
		else
			indirectSpellId = spellId
		end
		local itemString = ProfessionInfo.GetIndirectCraftResult(indirectSpellId)
		if type(itemString) == "table" then
			-- TODO: Update the caller to handle multiple result items
			itemString = itemString[1]
		end
		if itemString and (not TSM.IsWowClassic() or TSM.IsWowWrathClassic()) then
			return TSM.UI.GetColoredItemName(itemString), itemString, ItemInfo.GetTexture(itemString)
		elseif ProfessionInfo.IsEngineeringTinker(spellId) then
			local name, _, icon = GetSpellInfo(spellId)
			return name, nil, icon
		else
			if TSM.IsWowWrathClassic() then
				local name, _, icon = GetSpellInfo(indirectSpellId)
				return name, nil, icon
			else
				local name, _, icon = GetSpellInfo(TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftInfo(TSM.IsWowClassic() and TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId) or spellId)
				return name, nil, icon
			end
		end
	elseif strfind(resultItem, "item:") then
		-- result of craft is an item
		return TSM.UI.GetColoredItemName(resultItem), ItemString.Get(resultItem), ItemInfo.GetTexture(resultItem)
	else
		error("Invalid craft: "..tostring(spellId))
	end
end

function ProfessionUtil.GetPlayerMatQuantity(itemString)
	if TSM.IsWowClassic() then
		return BagTracking.GetBagQuantity(itemString)
	else
		return BagTracking.GetTotalQuantity(itemString)
	end
end

function ProfessionUtil.GetNumCraftable(craftString, level)
	local num, numAll = math.huge, math.huge
	local spellId = CraftString.GetSpellId(craftString)
	level = level or CraftString.GetLevel(craftString)
	for i = 1, ProfessionUtil.GetNumMats(spellId, level) do
		local itemString, _, _, quantity = ProfessionUtil.GetMatInfo(spellId, i, level)
		local totalQuantity = CustomPrice.GetItemPrice(itemString, "NumInventory") or 0
		if not itemString or not quantity or totalQuantity == 0 then
			return 0, 0
		end
		num = min(num, floor(ProfessionUtil.GetPlayerMatQuantity(itemString) / quantity))
		numAll = min(numAll, floor(totalQuantity / quantity))
	end
	if num == math.huge or numAll == math.huge then
		return 0, 0
	end
	return num, numAll
end

function ProfessionUtil.GetNumCraftableRecipeString(recipeString)
	local num, numAll = math.huge, math.huge
	local craftString = CraftString.FromRecipeString(recipeString)
	local spellId = RecipeString.GetSpellId(recipeString)
	local level = RecipeString.GetLevel(recipeString)
	for i = 1, ProfessionUtil.GetNumMats(spellId, level) do
		local itemString, _, _, quantity = ProfessionUtil.GetMatInfo(spellId, i, level)
		local totalQuantity = CustomPrice.GetItemPrice(itemString, "NumInventory") or 0
		if not itemString or not quantity or totalQuantity == 0 then
			return 0, 0
		end
		local bagQuantity = BagTracking.GetBagQuantity(itemString)
		if not TSM.IsWowClassic() then
			bagQuantity = bagQuantity + BagTracking.GetReagentBankQuantity(itemString) + BagTracking.GetBankQuantity(itemString)
		end
		num = min(num, floor(bagQuantity / quantity))
		numAll = min(numAll, floor(totalQuantity / quantity))
	end
	for _, _, itemId in RecipeString.OptionalMatIterator(recipeString) do
		local optionalMatItemString = ItemString.Get(itemId)
		local bagQuantity = BagTracking.GetBagQuantity(optionalMatItemString)
		local matQuantity = TSM.Crafting.GetOptionalMatQuantity(craftString, itemId)
		if not TSM.IsWowClassic() then
			bagQuantity = bagQuantity + BagTracking.GetReagentBankQuantity(optionalMatItemString) + BagTracking.GetBankQuantity(optionalMatItemString)
		end
		num = min(num, floor(bagQuantity / matQuantity))
	end
	if num == math.huge or numAll == math.huge then
		return 0, 0
	end
	return num, numAll
end

function ProfessionUtil.IsCraftable(craftString, level)
	local spellId = CraftString.GetSpellId(craftString)
	for i = 1, ProfessionUtil.GetNumMats(spellId, level) do
		local itemString, _, _, quantity = ProfessionUtil.GetMatInfo(spellId, i, level)
		if not itemString or not quantity then
			return false
		end
		if floor(ProfessionUtil.GetPlayerMatQuantity(itemString) / quantity) == 0 then
			return false
		end
	end
	return true
end

function ProfessionUtil.GetNumCraftableFromDB(craftString, optionalMats)
	local num = math.huge
	for _, itemString, quantity in TSM.Crafting.MatIterator(craftString) do
		num = min(num, floor(ProfessionUtil.GetPlayerMatQuantity(itemString) / quantity))
	end
	if optionalMats then
		for _, itemId in pairs(optionalMats) do
			num = min(num, ProfessionUtil.GetPlayerMatQuantity(ItemString.Get(itemId)))
		end
	end
	if num == math.huge then
		return 0
	end
	return num
end

function ProfessionUtil.GetNumCraftableFromDBRecipeString(recipeString)
	local num = math.huge
	local craftString = CraftString.FromRecipeString(recipeString)
	for _, itemString, quantity in TSM.Crafting.MatIterator(craftString) do
		num = min(num, floor(ProfessionUtil.GetPlayerMatQuantity(itemString) / quantity))
	end
	for _, _, itemId in RecipeString.OptionalMatIterator(recipeString) do
		num = min(num, floor(ProfessionUtil.GetPlayerMatQuantity(ItemString.Get(itemId)) / TSM.Crafting.GetOptionalMatQuantity(craftString, itemId)))
	end
	if num == math.huge then
		return 0
	end
	return num
end

function ProfessionUtil.IsEnchant(craftString)
	local spellId = CraftString.GetSpellId(craftString)
	local name = ProfessionUtil.GetCurrentProfessionInfo()
	if name ~= GetSpellInfo(7411) then
		return false
	end
	if TSM.IsWowClassic() then
		local itemLink = ProfessionUtil.GetRecipeResultItem(craftString)
		if not strfind(itemLink, "enchant:") then
			return false, false
		end
		return true, not TSM.IsWowVanillaClassic()
	else
		if not strfind(C_TradeSkillUI.GetRecipeItemLink(spellId), "enchant:") then
			return false, false
		end
		local recipeInfo = C_TradeSkillUI.GetRecipeInfo(spellId)
		return recipeInfo.isEnchantingRecipe, true
	end
end

function ProfessionUtil.OpenProfession(profession, skillId)
	if TSM.IsWowClassic() then
		if profession == ProfessionInfo.GetName("Mining") then
			-- mining needs to be opened as smelting
			profession = ProfessionInfo.GetName("Smelting")
		end
		if PROFESSION_LOOKUP[profession] then
			profession = PROFESSION_LOOKUP[profession]
		end
		CastSpellByName(profession)
	else
		C_TradeSkillUI.OpenTradeSkill(skillId)
	end
end

function ProfessionUtil.PrepareToCraft(craftString, recipeString, quantity, level)
	local spellId = CraftString.GetSpellId(craftString)
	if recipeString then
		quantity = min(quantity, ProfessionUtil.GetNumCraftableRecipeString(recipeString))
	else
		quantity = min(quantity, ProfessionUtil.GetNumCraftable(craftString, level))
	end
	if quantity == 0 then
		return
	end
	if ProfessionUtil.IsEnchant(craftString) or (recipeString and RecipeString.HasOptionalMats(recipeString)) then
		quantity = 1
	end
	private.preparedSpellId = spellId
	private.preparedTime = GetTime()
end

function ProfessionUtil.Craft(craftString, recipeId, quantity, useVellum, callback)
	local spellId = nil
	local level = nil
	local hasOptionalMats = false
	if type(recipeId) == "string" then
		spellId = RecipeString.GetSpellId(recipeId)
		level = RecipeString.GetLevel(recipeId)
		hasOptionalMats = RecipeString.HasOptionalMats(recipeId)
		quantity = min(quantity, ProfessionUtil.GetNumCraftableRecipeString(recipeId))
	else
		spellId = recipeId
		quantity = min(quantity, ProfessionUtil.GetNumCraftable(craftString, level))
	end
	assert(TSM.Crafting.ProfessionScanner.HasCraftString(craftString))
	if private.craftSpellId then
		private.craftCallback = callback
		private.DoCraftCallback(false, true)
		return 0
	end
	if quantity == 0 then
		return 0
	end
	local isEnchant, vellumable = ProfessionUtil.IsEnchant(craftString)
	if isEnchant or hasOptionalMats then
		quantity = 1
	elseif spellId ~= private.preparedSpellId or private.preparedTime == GetTime() then
		-- We can only craft one of this item due to a bug on Blizzard's end
		quantity = 1
	end
	local enchantItemLocation = nil
	if not TSM.IsWowClassic() and useVellum and isEnchant and vellumable then
		local bag, slot = BagTracking.CreateQueryBagsItem(ProfessionInfo.GetVellumItemString())
			:Select("bag", "slot")
			:GetFirstResultAndRelease()
		if not bag then
			return 0
		end
		private.itemLocation:Clear()
		private.itemLocation:SetBagAndSlot(bag, slot)
		enchantItemLocation = private.itemLocation
	end
	private.craftQuantity = quantity
	private.craftString = craftString
	private.craftSpellId = spellId
	private.craftBaseString = ItemString.GetBase(TSM.Crafting.GetItemString(craftString))
	private.craftCallback = callback
	if TSM.IsWowClassic() then
		local index = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			private.craftName = GetCraftInfo(index)
		else
			private.craftName = GetTradeSkillInfo(index)
			DoTradeSkill(index, quantity)
		end
	else
		local optionalMats = TempTable.Acquire()
		if type(recipeId) == "string" then
			for _, slotId, itemId in RecipeString.OptionalMatIterator(recipeId) do
				local info = TempTable.Acquire()
				info.itemID = itemId
				info.dataSlotIndex = slotId
				info.quantity = TSM.Crafting.GetOptionalMatQuantity(craftString, itemId)
				tinsert(optionalMats, info)
			end
		end
		if enchantItemLocation then
			C_TradeSkillUI.CraftEnchant(spellId, quantity, optionalMats, enchantItemLocation)
		else
			C_TradeSkillUI.CraftRecipe(spellId, quantity, optionalMats, level)
		end
		for _, info in pairs(optionalMats) do
			TempTable.Release(info)
		end
		TempTable.Release(optionalMats)
	end
	if TSM.IsWowClassic() and useVellum and isEnchant and vellumable then
		local indirectSpellId = nil
		if TSM.IsWowWrathClassic() then
			local itemLink = ProfessionUtil.GetRecipeResultItem(craftString)
			indirectSpellId = strmatch(itemLink, "enchant:(%d+)")
			indirectSpellId = indirectSpellId and tonumber(indirectSpellId)
		end
		UseItemByName(ItemInfo.GetName(ProfessionInfo.GetVellumItemString(indirectSpellId)))
	end
	private.castingTimeout = nil
	private.craftTimeout = nil
	private.timeoutTimer:RunForTime(0.5)
	return quantity
end

function ProfessionUtil.IsDataStable()
	return TSM.IsWowClassic() or (C_TradeSkillUI.IsTradeSkillReady() and not C_TradeSkillUI.IsDataSourceChanging())
end

function ProfessionUtil.HasCooldown(craftString)
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
		return GetTradeSkillCooldown(spellId) and true or false
	else
		return select(2, C_TradeSkillUI.GetRecipeCooldown(spellId)) and true or false
	end
end

function ProfessionUtil.GetRemainingCooldown(craftString)
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
		return GetTradeSkillCooldown(spellId)
	else
		return C_TradeSkillUI.GetRecipeCooldown(spellId)
	end
end

function ProfessionUtil.GetRecipeResultItem(craftString)
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		local index = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
		local itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftItemLink(index) or GetTradeSkillItemLink(index)
		local emptyLink = strfind(itemLink or "", "item::") and true or false
		itemLink = not emptyLink and itemLink or nil
		return itemLink or (TSM.IsWowWrathClassic() and GetTradeSkillRecipeLink(index)) or nil
	else
		local resultItems = C_TradeSkillUI.GetRecipeQualityItemIDs(spellId)
		if resultItems then
			wipe(private.resultQualityTemp)
			for i = 1, #resultItems do
				local itemId = resultItems[i]
				local itemString = "i:"..itemId
				local quality = C_TradeSkillUI.GetItemCraftedQualityByItemInfo(itemId) or C_TradeSkillUI.GetItemReagentQualityByItemInfo(itemId) or ItemInfo.GetCraftedQuality(itemString)
				if not quality then
					return
				end
				private.resultQualityTemp[itemId] = quality
			end
			Table.SortWithValueLookup(resultItems, private.resultQualityTemp)
			for i = 1, #resultItems do
				local link = ItemInfo.GetLink("i:"..resultItems[i])
				if not link then
					return
				end
				resultItems[i] = link
			end
			return resultItems
		else
			return C_TradeSkillUI.GetRecipeItemLink(spellId)
		end
	end
end

function ProfessionUtil.GetRecipeInfo(craftString)
	local lNum, hNum = nil, nil
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			lNum, hNum = 1, 1
		else
			local index = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
			lNum, hNum = GetTradeSkillNumMade(index)
		end
	else
		local quality = CraftString.GetQuality(craftString) or 0
		local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, quality)
		lNum, hNum = info.quantityMin, info.quantityMax
	end
	return lNum, hNum
end

function ProfessionUtil.GetRecipeQualityInfo(craftString)
	if TSM.IsWowClassic() then
		return
	end
	local spellId = CraftString.GetSpellId(craftString)
	-- TODO: Do we need this info?
	local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, 1)
	local isItem = info.recipeType == Enum.TradeskillRecipeType.Item
	local isEnchant = info.recipeType == Enum.TradeskillRecipeType.Enchant
	if not info.hasCraftingOperationInfo or info.hasGatheringOperationInfo then
		return
	elseif not isItem and not isEnchant then
		return
	elseif isItem and not info.outputItemID then
		return
	end
	local operationInfo = C_TradeSkillUI.GetCraftingOperationInfo(spellId, EMPTY_MATS_TABLE)
	if not operationInfo then
		return
	end
	if isItem and not ItemInfo.IsCommodity("i:"..info.outputItemID) and operationInfo.isQualityCraft then
		-- TODO: Support crafts where the quality results in higher item level gear
		return
	end
	return operationInfo.baseDifficulty, operationInfo.quality
end

function ProfessionUtil.GetRecipeToolInfo(craftString)
	local toolsStr, hasTools = nil, nil
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		local index = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			toolsStr, hasTools = GetCraftSpellFocus(index)
		else
			toolsStr, hasTools = GetTradeSkillTools(index)
		end
	else
		for _, requirement in ipairs(C_TradeSkillUI.GetRecipeRequirements(spellId)) do
			if requirement.type == Enum.RecipeRequirementType.Totem then
				toolsStr = requirement.name
				if not requirement.met then
					return toolsStr, false
				end
			end
		end
		hasTools = true
	end
	return toolsStr, hasTools
end

function ProfessionUtil.GetRecipeLink(craftString)
	local spellId = CraftString.GetSpellId(craftString)
	if TSM.IsWowClassic() then
		local index = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or spellId
		return TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftRecipeLink(index) or GetTradeSkillRecipeLink(index)
	else
		return C_TradeSkillUI.GetRecipeLink(spellId)
	end
end

function ProfessionUtil.GetNumMats(spellId, level)
	local numMats = nil
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(CraftString.Get(spellId)) or spellId
		numMats = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftNumReagents(spellId) or GetTradeSkillNumReagents(spellId)
	else
		local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
		local num = 0
		for _, data in pairs(info.reagentSlotSchematics) do
			if data.reagentType == Enum.CraftingReagentType.Basic then
				if data.dataSlotType == Enum.TradeskillSlotDataType.Reagent then
					num = num + 1
				elseif data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
					num = num + 1
				end
			end
		end
		numMats = num
	end
	return numMats
end

function ProfessionUtil.GetMatInfo(spellId, index, level, qualityIndex)
	local itemString, name, texture, quantity, isQualityMat = nil, nil, nil, nil, nil
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexByCraftString(CraftString.Get(spellId)) or spellId
		local itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftReagentItemLink(spellId, index) or GetTradeSkillReagentItemLink(spellId, index)
		itemString = ItemString.Get(itemLink)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			name, texture, quantity = GetCraftReagentInfo(spellId, index)
		else
			name, texture, quantity = GetTradeSkillReagentInfo(spellId, index)
		end
	else
		local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
		local reagentSlotInfo = info.reagentSlotSchematics[index]
		if reagentSlotInfo.reagentType == Enum.CraftingReagentType.Basic then
			if reagentSlotInfo.dataSlotType == Enum.TradeskillSlotDataType.Reagent then
				local itemLink = C_TradeSkillUI.GetRecipeFixedReagentItemLink(spellId, reagentSlotInfo.dataSlotIndex)
				itemString = ItemString.Get(itemLink)
				name, texture, quantity = ItemInfo.GetName(itemLink), ItemInfo.GetTexture(itemString), reagentSlotInfo.quantityRequired
			elseif reagentSlotInfo.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
				isQualityMat = true
				local reagentDataInfo = reagentSlotInfo.reagents[qualityIndex or 1]
				local itemLink = C_TradeSkillUI.GetRecipeQualityReagentItemLink(spellId, reagentSlotInfo.dataSlotIndex, qualityIndex or 1)
				-- NOTE: For some reason, the above API doesn't always work (i.e. with 'Handful of Serevite Bolts')
				itemString = itemLink and ItemString.Get(itemLink) or "i:"..reagentDataInfo.itemID
				itemLink = itemLink or ItemInfo.GetLink(reagentDataInfo.itemID)
				name, texture, quantity = ItemInfo.GetName(itemLink), ItemInfo.GetTexture(itemString), reagentSlotInfo.quantityRequired
			end
		end
	end
	return itemString, name, texture, quantity, isQualityMat
end

function ProfessionUtil.CloseTradeSkill(closeBoth)
	if TSM.IsWowClassic() then
		if closeBoth then
			CloseCraft()
			CloseTradeSkill()
		else
			if TSM.Crafting.ProfessionState.IsClassicCrafting() then
				CloseCraft()
			else
				CloseTradeSkill()
			end
		end
	else
		C_TradeSkillUI.CloseTradeSkill()
		C_Garrison.CloseGarrisonTradeskillNPC()
	end
end

function ProfessionUtil.IsNPCProfession()
	return not TSM.IsWowClassic() and C_TradeSkillUI.IsNPCCrafting()
end

function ProfessionUtil.IsLinkedProfession()
	if TSM.IsWowVanillaClassic() then
		return nil, nil
	elseif TSM.IsWowWrathClassic() then
		return IsTradeSkillLinked()
	else
		return C_TradeSkillUI.IsTradeSkillLinked()
	end
end

function ProfessionUtil.IsGuildProfession()
	return not TSM.IsWowClassic() and C_TradeSkillUI.IsTradeSkillGuild()
end

function ProfessionUtil.GetCategoryInfo(categoryId)
	local name, numIndents, parentCategoryId, currentSkillLevel, maxSkillLevel = nil, nil, nil, nil, nil
	if TSM.IsWowClassic() then
		name = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftDisplaySkillLine() or (categoryId and GetTradeSkillInfo(categoryId) or nil)
		numIndents = 0
		parentCategoryId = nil
	else
		C_TradeSkillUI.GetCategoryInfo(categoryId, private.categoryInfoTemp)
		name = private.categoryInfoTemp.name
		parentCategoryId = private.categoryInfoTemp.numIndents ~= 0 and private.categoryInfoTemp.parentCategoryID or nil
		currentSkillLevel = private.categoryInfoTemp.skillLineCurrentLevel
		maxSkillLevel = private.categoryInfoTemp.skillLineMaxLevel
		if parentCategoryId then
			C_TradeSkillUI.GetCategoryInfo(parentCategoryId, private.categoryInfoTemp)
			if private.categoryInfoTemp.type == "subheader" then
				numIndents = parentCategoryId == private.categoryInfoTemp.parentCategoryID and 0 or 1
			end
		else
			numIndents = 0
		end
		wipe(private.categoryInfoTemp)
	end
	return name, numIndents, parentCategoryId, currentSkillLevel, maxSkillLevel
end

function ProfessionUtil.StoreOptionalMatText(matList, text)
	TSM.db.global.internalData.optionalMatTextLookup[matList] = TSM.db.global.internalData.optionalMatTextLookup[matList] or text
end

function ProfessionUtil.GetOptionalMatText(matList)
	return TSM.db.global.internalData.optionalMatTextLookup[matList] or OPTIONAL_REAGENT_POSTFIX
end

function ProfessionUtil.GetCraftResultTooltipFromRecipeString(recipeString)
	local craftString = CraftString.FromRecipeString(recipeString)
	local _, itemString, texture = ProfessionUtil.GetResultInfo(craftString)
	local tooltip = nil
	itemString = itemString or TSM.Crafting.GetItemString(craftString)
	if not itemString or itemString == "" then
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			tooltip = "craft:"..(TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString) or craftString)
		else
			local spellId = RecipeString.GetSpellId(recipeString)
			tooltip = "enchant:"..spellId
		end
	else
		texture = ItemInfo.GetTexture(itemString) or texture
		local level = RecipeString.GetLevel(recipeString)
		local rank = RecipeString.GetRank(recipeString)
		if level or rank or RecipeString.HasOptionalMats(recipeString) then
			local levelItemString = level and TSM.Crafting.Cost.GetLevelItemString(recipeString)
			tooltip = levelItemString or recipeString
		else
			tooltip = itemString
		end
	end
	return tooltip, texture
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DoCraftCallback(result, isDone)
	local callback = private.craftCallback
	assert(callback)
	-- reset timeouts
	private.castingTimeout = nil
	private.craftTimeout = nil
	if isDone then
		private.craftQuantity = nil
		private.craftString = nil
		private.craftSpellId = nil
		private.craftBaseString = nil
		private.craftCallback = nil
		private.craftName = nil
		private.timeoutTimer:Cancel()
	end
	callback(result, isDone)
end

function private.CraftTimeoutMonitor()
	private.timeoutTimer:RunForTime(0.5)
	if not private.craftSpellId then
		Log.Info("No longer crafting")
		private.castingTimeout = nil
		private.craftTimeout = nil
		private.timeoutTimer:Cancel()
		return
	end
	local _, _, _, _, castEndTimeMs, _, _, _, spellId = private.GetPlayerCastingInfo()
	if spellId then
		private.castingTimeout = nil
	else
		private.craftTimeout = nil
	end
	if not spellId then
		-- no active cast
		if GetTime() > (private.castingTimeout or math.huge) then
			Log.Err("Craft timed out (%s)", private.craftSpellId)
			private.DoCraftCallback(false, true)
			return
		end
		-- set the casting timeout to 1 second from now
		private.castingTimeout = GetTime() + 1
		return
	elseif private.craftSpellId ~= spellId then
		Log.Err("Crafting something else (%s, %s)", private.craftSpellId, spellId)
		private.castingTimeout = nil
		private.craftTimeout = nil
		private.timeoutTimer:Cancel()
		return
	end

	if GetTime() > (private.craftTimeout or math.huge) then
		Log.Err("Craft timed out (%s)", private.craftSpellId)
		private.DoCraftCallback(false, true)
		return
	end
	-- set the timeout to 1 second after the end time
	private.craftTimeout = castEndTimeMs / 1000 + 1
end

function private.GetPlayerCastingInfo()
	if TSM.IsWowClassic() then
		return CastingInfo()
	else
		return UnitCastingInfo("player")
	end
end
