-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMWoW = select(2, ...).LibTSMWoW
local TradeSkill = LibTSMWoW:Init("API.TradeSkill")
local Spell = LibTSMWoW:Include("API.Spell")
local SlotId = LibTSMWoW:Include("Type.SlotId")
local ClientInfo = LibTSMWoW:Include("Util.ClientInfo")
local EnumType = LibTSMWoW:From("LibTSMUtil"):Include("BaseType.EnumType")
local private = {
	buggedQuantityRangeSpells = {},
	inspirationDescPattern = nil,
	categorySkillLevelCache = {
		lastUpdate = 0,
	},
	iteratorContext = {},
	categoryInfoTemp = {},
	itemIdsTemp = {},
	itemLocation = ItemLocation:CreateEmpty(),
}
local TYPE = EnumType.New("TRADE_SKILL_TYPE", {
	PLAYER = EnumType.NewValue(),
	NPC = EnumType.NewValue(),
	GUILD = EnumType.NewValue(),
	LINKED = EnumType.NewValue(),
})
TradeSkill.TYPE = TYPE
local RECIPE_TYPE = EnumType.New("TRADE_SKILL_RECIPE_TYPE", {
	ITEM = EnumType.NewValue(),
	ENCHANT = EnumType.NewValue(),
	SALVAGE = EnumType.NewValue(),
	UNKNOWN = EnumType.NewValue()
})
TradeSkill.RECIPE_TYPE = RECIPE_TYPE
local RECIPE_DIFFICULTY = EnumType.New("TRADE_SKILL_RECIPE_DIFFICULTY", {
	OPTIMAL = EnumType.NewValue(),
	MEDIUM = EnumType.NewValue(),
	EASY = EnumType.NewValue(),
	TRIVIAL = EnumType.NewValue(),
})
TradeSkill.RECIPE_DIFFICULTY = RECIPE_DIFFICULTY
local MAT_TYPE = EnumType.New("TRADE_SKILL_MAT_TYPE", {
	REQUIRED = EnumType.NewValue(),
	QUALITY = EnumType.NewValue(),
	OPTIONAL = EnumType.NewValue(),
	FINISHING = EnumType.NewValue(),
})
TradeSkill.MAT_TYPE = MAT_TYPE
local NAMES = {
	ENCHANTING = Spell.GetInfo(7411),
	MINING = Spell.GetInfo(2575),
	SMELTING = Spell.GetInfo(2656),
	POISONS = Spell.GetInfo(2842),
}
TradeSkill.NAMES = NAMES
local EMPTY_TABLE = {}
local PROFESSION_NAME_MAP = {
	["Costura"] = "Sastrería",
	["Marroquinería"] = "Peletería",
	["Ingénierie"] = "Ingénieur",
	["Secourisme"] = "Premiers soins",
}
local CLASSIC_SUB_NAMES = {
	[APPRENTICE] = true,
	[JOURNEYMAN] = true,
	[EXPERT] = true,
	[ARTISAN] = true,
	[MASTER] = true,
	[GRAND_MASTER] = true,
	[ILLUSTRIOUS] = true,
	["大师级"] = true, -- zhCN ARTISAN
	["Мастеровой"] = true, -- ruRU ARTISAN
}
local BUGGED_QUANTITY_RANGE_SPELLS = {
	[169092] = {1, 1}, -- Temporal Crystal
	[210116] = {4, 4}, -- Yseralline
	[209664] = {42, 42}, -- Felwort (amount is variable but the values are conservative)
	[247861] = {4, 4}, -- Astral Glory (amount is variable but the values are conservative)
}



-- ============================================================================
-- Module Loading
-- ============================================================================

TradeSkill:OnModuleLoad(function()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		private.inspirationDescPattern = gsub(PROFESSIONS_CRAFTING_STAT_TT_CRIT_DESC, "%%d", "([0-9%.]+)")
		if private.inspirationDescPattern == PROFESSIONS_CRAFTING_STAT_TT_CRIT_DESC then
			-- This locale uses positional format specifiers, so we'll use a different mechanism to try to extract the inspiration
			private.inspirationDescPattern = nil
		end
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Returns whether or not a name is a classic trade skill sub name.
---@param name string The name
---@return boolean
function TradeSkill.IsClassicSubName(name)
	return CLASSIC_SUB_NAMES[name] or false
end

---Adds bugged quantity info.
---@param spells table<number,number[]> An table of the min/max quantity with the spell ID as the key
function TradeSkill.AddBuggedQuantityInfo(spellId, minQuantity, maxQuantity)
	assert(type(spellId) == "number" and minQuantity <= maxQuantity)
	private.buggedQuantityRangeSpells[spellId] = { minQuantity, maxQuantity }
end

---Loads the Blizzard Craft UI addon.
function TradeSkill.LoadBlizzardCraftUI()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) or C_AddOns.IsAddOnLoaded("Blizzard_CraftUI") then
		return
	end
	C_AddOns.LoadAddOn("Blizzard_CraftUI")
end


---Opens a trade skill.
---@param profession string|Enum.Profession The name of the profession (classic) or the profession enum value (retail)
function TradeSkill.OpenUI(profession)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		assert(type(profession) == "number")
		C_TradeSkillUI.OpenTradeSkill(profession)
	else
		assert(type(profession) == "string")
		-- Mining needs to be opened as smelting
		if profession == NAMES.MINING then
			profession = NAMES.SMELTING
		end
		local mappedName = PROFESSION_NAME_MAP[profession]
		if mappedName then
			profession = mappedName
		end
		CastSpellByName(profession)
	end
end

---Close the open trade skill.
---@param closeBoth boolean Whether to close both the craft and tradeskill on classic
function TradeSkill.CloseUI(closeBoth)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		C_TradeSkillUI.CloseTradeSkill()
		C_Garrison.CloseGarrisonTradeskillNPC()
	elseif closeBoth then
		CloseCraft()
		CloseTradeSkill()
	elseif TradeSkill.IsClassicCrafting() then
		CloseCraft()
	else
		CloseTradeSkill()
	end
end

---Gets the type of the current open trade skill.
---@return EnumValue
function TradeSkill.GetType()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		if C_TradeSkillUI.IsNPCCrafting() then
			return TYPE.NPC
		elseif C_TradeSkillUI.IsTradeSkillGuild() then
			return TYPE.GUILD
		elseif C_TradeSkillUI.IsTradeSkillLinked() then
			return TYPE.LINKED
		end
	elseif not LibTSMWoW.IsVanillaClassic() and IsTradeSkillLinked() then
		return TYPE.LINKED
	end
	return TYPE.PLAYER
end

---Returns whether or not the current trade skill is classic crafting.
function TradeSkill.IsClassicCrafting()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		return false
	end
	local name, _, maxLevel = GetTradeSkillLine()
	if name == "UNKNOWN" or maxLevel == 0 then
		return true
	else
		return false
	end
end

---Gets the name of the player who linked the current trade skill (for TYPE.LINKED).
---@return string?
function TradeSkill.GetLinkedPlayer()
	if LibTSMWoW.IsVanillaClassic() or ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		return nil
	end
	local _, playerName = IsTradeSkillLinked()
	return playerName
end

---Returns whether or not the trade skill data is ready.
---@return boolean
function TradeSkill.IsDataReady()
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		return true
	end
	return C_TradeSkillUI.IsTradeSkillReady() and not C_TradeSkillUI.IsDataSourceChanging()
end

---Gets the current trade skill's link.
---@return string?
function TradeSkill.GetLink()
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		return nil
	end
	return C_TradeSkillUI.GetTradeSkillListLink()
end

---Gets the name of the current profession (and the skillId on retail).
---@return string name
---@return Enum.Profession? skillId
function TradeSkill.GetName()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local info = C_TradeSkillUI.GetBaseProfessionInfo()
		return info.parentProfessionName or info.professionName, info.profession
	else
		local name = TradeSkill.IsClassicCrafting() and GetCraftSkillLine(1) or GetTradeSkillLine()
		return name
	end
end

---Clears all trade skill filters and returns whether or not filters were previously set.
---@return boolean
function TradeSkill.ClearFilters()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local hadFilter = false
		if C_TradeSkillUI.GetShowUnlearned() then
			C_TradeSkillUI.SetShowLearned(true)
			C_TradeSkillUI.SetShowUnlearned(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowMakeableRecipes() then
			C_TradeSkillUI.SetOnlyShowMakeableRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowSkillUpRecipes() then
			C_TradeSkillUI.SetOnlyShowSkillUpRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.AnyRecipeCategoriesFiltered() then
			C_TradeSkillUI.ClearRecipeCategoryFilter()
			hadFilter = true
		end
		if C_TradeSkillUI.AreAnyInventorySlotsFiltered() then
			C_TradeSkillUI.ClearInventorySlotFilter()
			hadFilter = true
		end
		for i = 1, C_PetJournal.GetNumPetSources() do
			if C_TradeSkillUI.IsAnyRecipeFromSource(i) and C_TradeSkillUI.IsRecipeSourceTypeFiltered(i) then
				C_TradeSkillUI.ClearRecipeSourceTypeFilter()
				hadFilter = true
				break
			end
		end
		if C_TradeSkillUI.GetRecipeItemNameFilter() ~= "" then
			C_TradeSkillUI.SetRecipeItemNameFilter(nil)
			hadFilter = true
		end
		local minItemLevel, maxItemLevel = C_TradeSkillUI.GetRecipeItemLevelFilter()
		if minItemLevel ~= 0 or maxItemLevel ~= 0 then
			C_TradeSkillUI.SetRecipeItemLevelFilter(0, 0)
			hadFilter = true
		end
		return hadFilter
	else
		-- TODO
		return false
	end
end

---Gets the result item(s) of a recipe.
---@param spellId number The recipe spell ID
---@return string|number[] items
---@return number? indirectSpellId
---@return number? indirectResultId
function TradeSkill.GetResult(spellId)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		return C_TradeSkillUI.GetRecipeQualityItemIDs(spellId) or C_TradeSkillUI.GetRecipeItemLink(spellId)
	else
		local itemLink = TradeSkill.IsClassicCrafting() and GetCraftItemLink(spellId) or GetTradeSkillItemLink(spellId)
		local indirectResultId = nil
		-- Filter out invalid item links
		itemLink = not strfind(itemLink or "", "item::") and itemLink or nil
		if LibTSMWoW.IsCataClassic() then
			itemLink = itemLink or GetTradeSkillRecipeLink(spellId)
		end
		local indirectSpellId = strmatch(itemLink, "enchant:(%d+)")
		if not indirectSpellId then
			indirectResultId = strmatch(itemLink, "item:(%d+)") or strmatch(itemLink, "spell:(%d+)")
		end
		indirectSpellId = indirectSpellId and tonumber(indirectSpellId)
		indirectResultId = indirectResultId and tonumber(indirectResultId)
		return itemLink, indirectSpellId, indirectSpellId or indirectResultId
	end
end

---Returns whether or not a recipe is an enchant.
---@param spellId number The recipe spell ID
---@return boolean
function TradeSkill.IsEnchant(spellId)
	if TradeSkill.GetName() ~= NAMES.ENCHANTING then
		return false
	end
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		if not strfind(C_TradeSkillUI.GetRecipeItemLink(spellId), "enchant:") then
			return false
		end
		return C_TradeSkillUI.GetRecipeInfo(spellId).isEnchantingRecipe
	else
		local _, indirectSpellId = TradeSkill.GetResult(spellId)
		return indirectSpellId and true or false
	end
end

---Gets cooldown info for a recipe.
---@param spellId number The recipe spell ID
---@return boolean isDailyCooldown
---@return number? remainingCooldown
function TradeSkill.GetCooldownInfo(spellId)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local cooldown, isDailyCooldown, charges, maxCharges = C_TradeSkillUI.GetRecipeCooldown(spellId)
		if (maxCharges or 0) > 0 and charges and (charges > 0 or not cooldown) then
			return isDailyCooldown, nil
		end
		return isDailyCooldown, cooldown and floor(cooldown) or nil
	else
		local cooldown = GetTradeSkillCooldown(spellId)
		return cooldown and true or false, cooldown and floor(cooldown) or nil
	end
end

---Gets the icon texture for a recipe (classic-only).
---@param index number The recipe index
---@return number
function TradeSkill.GetIcon(index)
	assert(not ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	if TradeSkill.IsClassicCrafting() then
		return GetCraftIcon(index)
	else
		return GetTradeSkillIcon(index)
	end
end

---Gets the crafted quality of an item.
---@param itemId number The item ID
---@return number?
function TradeSkill.GetItemCraftedQuality(itemId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	return C_TradeSkillUI.GetItemCraftedQualityByItemInfo(itemId) or C_TradeSkillUI.GetItemReagentQualityByItemInfo(itemId)
end

---Gets the chat icon for a given crafted quality.
---@param craftedQuality number The crafted quality
---@param large? boolean Get the large version of the icon
---@return string
function TradeSkill.GetCraftedQualityChatIcon(craftedQuality, large)
	return Professions.GetChatIconMarkupForQuality(craftedQuality, not large)
end

---Gets the item level bonuses produced by different qualities of the recipe.
---@param spellId number The recipe spell ID
---@return number[]? qualityIlvlBonuses
function TradeSkill.GetItemLevelBonuses(spellId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	return C_TradeSkillUI.GetRecipeInfo(spellId).qualityIlvlBonuses
end

---Gets the range of quantities crafted by a recipe.
---@param spellId number The recipe spell ID
---@return number
---@return number
function TradeSkill.GetNumMade(spellId)
	if TradeSkill.IsEnchant(spellId) then
		return 1, 1
	elseif BUGGED_QUANTITY_RANGE_SPELLS[spellId] then
		return unpack(BUGGED_QUANTITY_RANGE_SPELLS[spellId])
	elseif private.buggedQuantityRangeSpells[spellId] then
		return unpack(private.buggedQuantityRangeSpells[spellId])
	elseif ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false)
		return info.quantityMin, info.quantityMax
	elseif TradeSkill.IsClassicCrafting() then
		return 1, 1
	else
		return GetTradeSkillNumMade(spellId)
	end
end

---Iterates over the available trade skill recipes (must be run to completion).
---@return fun(): number, string?, number?, EnumValue?, TradeSkillRecipeInfo? @Iterator with fields: `index`, `name`, `categoryId`, `difficulty`, `info`
function TradeSkill.RecipeIterator()
	assert(not next(private.iteratorContext))
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		assert(C_TradeSkillUI.GetFilteredRecipeIDs(private.iteratorContext) == private.iteratorContext)
	else
		private.iteratorContext.lastHeaderIndex = 0
	end
	return private.RecipeIterator, private.iteratorContext, 0
end

---Extracts fields from the `info` value of `TradeSkill.RecipeInfo`.
---@param info TradeSkillRecipeInfo
---@return number numSkillUps
---@return EnumValue difficulty
function TradeSkill.ExtractInfo(info)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	local numSkillUps = info.relativeDifficulty == Enum.TradeskillRelativeDifficulty.Optimal and info.numSkillUps or 1
	local difficulty = private.MapDifficulty(info.relativeDifficulty)
	return numSkillUps, difficulty
end

---Gets the description for a recipe.
---@param spellId number The recipe spell ID
---@return string
function TradeSkill.GetRecipeDescription(spellId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	return C_TradeSkillUI.GetRecipeDescription(spellId, EMPTY_TABLE)
end

---Returns the recipe type.
---@param spellId number The recipe spell ID
---@return EnumValue recipeType
function TradeSkill.GetRecipeType(spellId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	return private.MapRecipeType(C_TradeSkillUI.GetRecipeSchematic(spellId, false).recipeType)
end

---Gets salvage recipe info.
---@param spellId number The recipe spell ID
---@param level? number The recipe level
---@return number[]? itemIds
---@return number? quantityMin
function TradeSkill.GetSalvagaeInfo(spellId, level)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
	if private.MapRecipeType(info.recipeType) ~= RECIPE_TYPE.SALVAGE then
		return nil, nil
	end
	return C_TradeSkillUI.GetSalvagableItemIDs(spellId), info.quantityMin
end

---Gets quality info for a recipe.
---@param spellId number The recipe spell ID
---@return number? baseDifficulty
---@return number? quality
---@return boolean? hasQualityMats
---@return number? inspirationAmount
---@return number? inspirationChance
function TradeSkill.GetRecipeQualityInfo(spellId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, 1)
	local recipeType = private.MapRecipeType(info.recipeType)
	if not info.hasCraftingOperationInfo or info.hasGatheringOperationInfo then
		return nil, nil, nil, nil, nil
	elseif recipeType == RECIPE_TYPE.UNKNOWN then
		return nil, nil, nil, nil, nil
	elseif recipeType == RECIPE_TYPE.ITEM and not info.outputItemID then
		return nil, nil, nil, nil, nil
	end
	local operationInfo = C_TradeSkillUI.GetCraftingOperationInfo(spellId, EMPTY_TABLE, nil, false)
	if not operationInfo then
		return nil, nil, nil, nil, nil
	end
	local inspirationChance, inspirationAmount = 0, 0
	for _, statInfo in ipairs(operationInfo.bonusStats) do
		if statInfo.bonusStatName == PROFESSIONS_CRAFTING_STAT_TT_CRIT_HEADER then
			if private.inspirationDescPattern then
				inspirationChance, inspirationAmount = strmatch(statInfo.ratingDescription, private.inspirationDescPattern)
			end
			if not inspirationChance or inspirationChance == 0 then
				-- Try another way to parse the chance / amount
				inspirationChance = strmatch(statInfo.ratingDescription, "([0-9%.]+)%%")
				inspirationAmount = strmatch(statInfo.ratingDescription, "([0-9]+)[^%%%.,]") or strmatch(statInfo.ratingDescription, "([0-9]+)%.$")
			end
			inspirationChance = tonumber(inspirationChance) / 100
			inspirationAmount = tonumber(inspirationAmount)
			assert(inspirationChance and inspirationAmount)
			break
		end
	end
	local hasQualityMats = false
	for _, data in ipairs(info.reagentSlotSchematics) do
		if data.reagentType == Enum.CraftingReagentType.Basic and data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
			hasQualityMats = true
			break
		end
	end
	return operationInfo.baseDifficulty, operationInfo.quality, hasQualityMats, inspirationAmount, inspirationChance
end

---Gets the item IDs which can be used with a salvage recipe.
---@param spellId number The recipe spell ID
---@return number[]
function TradeSkill.GetSalvageItems(spellId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	return C_TradeSkillUI.GetSalvagableItemIDs(spellId)
end

---Get information on a trade skill category.
---@param categoryId? number The category ID
---@return string? name
---@return number numIndents
---@return number? parentCategoryId
---@return number? skillLevel
---@return number? maxSkillLevel
function TradeSkill.CategoryInfo(categoryId)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		C_TradeSkillUI.GetCategoryInfo(categoryId, private.categoryInfoTemp)
		local name = private.categoryInfoTemp.name
		local parentCategoryId = private.categoryInfoTemp.numIndents ~= 0 and private.categoryInfoTemp.parentCategoryID or nil
		local currentSkillLevel = private.categoryInfoTemp.skillLineCurrentLevel
		local maxSkillLevel = private.categoryInfoTemp.skillLineMaxLevel
		local numIndents = 0
		if parentCategoryId then
			C_TradeSkillUI.GetCategoryInfo(parentCategoryId, private.categoryInfoTemp)
			if private.categoryInfoTemp.type == "subheader" then
				numIndents = parentCategoryId == private.categoryInfoTemp.parentCategoryID and 0 or 1
			end
		else
			numIndents = 0
		end
		wipe(private.categoryInfoTemp)
		return name, numIndents, parentCategoryId, currentSkillLevel, maxSkillLevel
	else
		local name = TradeSkill.IsClassicCrafting() and GetCraftDisplaySkillLine() or (categoryId and GetTradeSkillInfo(categoryId) or nil)
		return name, 0, nil, nil, nil
	end
end

---Gets the current skill level of a category.
---@param categoryId number The category ID
---@return number
function TradeSkill.GetCurrentCategorySkillLevel(categoryId)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	if private.categorySkillLevelCache.lastUpdate ~= GetTime() then
		wipe(private.categorySkillLevelCache)
		private.categorySkillLevelCache.lastUpdate = GetTime()
	end
	if not private.categorySkillLevelCache[categoryId] then
		local categoryInfo = C_TradeSkillUI.GetCategoryInfo(categoryId)
		while not categoryInfo.skillLineCurrentLevel and categoryInfo.parentCategoryID do
			categoryInfo = C_TradeSkillUI.GetCategoryInfo(categoryInfo.parentCategoryID)
		end
		private.categorySkillLevelCache[categoryId] = categoryInfo.skillLineCurrentLevel or 0
	end
	return private.categorySkillLevelCache[categoryId]
end

---Gets the name of the required tool for the recipe.
---@param spellId number The recipe spell ID
---@return string?
function TradeSkill.GetRequiredTool(spellId)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		for _, requirement in ipairs(C_TradeSkillUI.GetRecipeRequirements(spellId)) do
			if requirement.type == Enum.RecipeRequirementType.Totem and not requirement.met then
				return requirement.name
			end
		end
		return nil
	else
		local toolsStr, hasTools = nil, nil
		if TradeSkill.IsClassicCrafting() then
			toolsStr, hasTools = GetCraftSpellFocus(spellId)
		else
			toolsStr, hasTools = GetTradeSkillTools(spellId)
		end
		return not hasTools and toolsStr or nil
	end
end

---Gets the number of materials for a recipe.
---@param spellId number The recipe spell ID
---@param level? number The recipe level
---@return number
function TradeSkill.GetNumMats(spellId, level)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local num = 0
		for _, data in ipairs(C_TradeSkillUI.GetRecipeSchematic(spellId, false, level).reagentSlotSchematics) do
			if private.IsRegularMat(data) then
				num = num + 1
			end
		end
		return num
	elseif TradeSkill.IsClassicCrafting() then
		return GetCraftNumReagents(spellId)
	else
		return GetTradeSkillNumReagents(spellId)
	end
end

---Gets info on a material by its data slot index.
---@param spellId number The recipe spell ID
---@param dataSlotIndex number The material data slot index
---@return number quantityRequired
---@return string itemLink
function TradeSkill.GetMatInfoByDataSlotId(spellId, dataSlotIndex)
	local itemLink = C_TradeSkillUI.GetRecipeFixedReagentItemLink(spellId, dataSlotIndex)
	for _, reagentInfo in ipairs(C_TradeSkillUI.GetRecipeSchematic(spellId, false).reagentSlotSchematics) do
		if reagentInfo.dataSlotIndex == dataSlotIndex then
			return reagentInfo.quantityRequired, itemLink
		end
	end
	return 1, itemLink
end

---Gets info on a trade skill recipe material.
---@param spellId number The recipe spell ID
---@param level? number The recipe level
---@param index number The material index.
---@return string|number item
---@return string? name
---@return number quantity
---@return boolean isModifiedReagent
function TradeSkill.GetMatInfo(spellId, level, index)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
		local reagentSlotInfo = nil
		local reagentOffset = index - 1
		for _, data in ipairs(info.reagentSlotSchematics) do
			if private.IsRegularMat(data) then
				if reagentOffset == 0 then
					reagentSlotInfo = data
					break
				else
					reagentOffset = reagentOffset - 1
				end
			end
		end
		assert(reagentSlotInfo)
		local item, isModifiedReagent = nil, nil
		if reagentSlotInfo.reagentType == Enum.CraftingReagentType.Modifying and reagentSlotInfo.required then
			item = C_TradeSkillUI.GetRecipeQualityReagentItemLink(spellId, reagentSlotInfo.dataSlotIndex, 1)
			isModifiedReagent = true
		elseif reagentSlotInfo.reagentType == Enum.CraftingReagentType.Basic and reagentSlotInfo.dataSlotType == Enum.TradeskillSlotDataType.Reagent then
			item = C_TradeSkillUI.GetRecipeFixedReagentItemLink(spellId, reagentSlotInfo.dataSlotIndex)
			isModifiedReagent = false
		elseif reagentSlotInfo.reagentType == Enum.CraftingReagentType.Basic and reagentSlotInfo.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
			item = C_TradeSkillUI.GetRecipeQualityReagentItemLink(spellId, reagentSlotInfo.dataSlotIndex, 1)
			-- NOTE: For some reason, the above API doesn't always work (i.e. with 'Handful of Serevite Bolts')
			item = item or reagentSlotInfo.reagents[1].itemID
			isModifiedReagent = true
		else
			error("Invalid mat: %s, %s", tostring(spellId), tostring(index))
		end
		return item, nil, reagentSlotInfo.quantityRequired, isModifiedReagent
	elseif TradeSkill.IsClassicCrafting() then
		local itemLink = GetCraftReagentItemLink(spellId, index)
		local name, _, quantity = GetCraftReagentInfo(spellId, index)
		return itemLink, name, quantity, false
	else
		local itemLink = GetTradeSkillReagentItemLink(spellId, index)
		local name, _, quantity = GetTradeSkillReagentInfo(spellId, index)
		return itemLink, name, quantity, false
	end
end

---Gets info on a recipe material slot.
---@param data any The reagent data
---@return EnumValue matType
---@return string|number slotTextOrItemId
function TradeSkill.GetMatSlotInfo(data)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	if data.reagentType == Enum.CraftingReagentType.Basic and data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
		return MAT_TYPE.QUALITY, data.reagents[1].itemID
	elseif data.reagentType == Enum.CraftingReagentType.Optional or data.reagentType == Enum.CraftingReagentType.Modifying then
		if data.required then
			return MAT_TYPE.REQUIRED, data.slotInfo.slotText or REQUIRED_REAGENT_TOOLTIP_CLICK_TO_ADD
		else
			return MAT_TYPE.OPTIONAL, data.slotInfo.slotText or OPTIONAL_REAGENT_POSTFIX
		end
	elseif data.reagentType == Enum.CraftingReagentType.Finishing then
		return MAT_TYPE.FINISHING, data.slotInfo.slotText or OPTIONAL_REAGENT_POSTFIX
	else
		error("Unexpected optional mat type: "..tostring(data.reagentType)..", "..tostring(data.dataSlotType))
	end
end

---Iterates over special recipe materials.
---@param spellId number The recipe spell ID
---@param level? number The recipe level
---@param categorySkillLevel number The category skill level for filtering mats with required skill
---@return fun(): number, EnumValue, number, number, string|number, CraftingReagent[] @Iterator with fields: `index`, `matType`, `quantityRequired`, `dataSlotIndex`, `slotTextOrId`, `reagents`
function TradeSkill.SpecialMatIterator(spellId, level, categorySkillLevel)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
	local mats = info.reagentSlotSchematics
	mats.categorySkillLevel = categorySkillLevel
	return private.SpecialMatIterator, mats, 0
end

---Gets basic info on a recipe from its spell ID.
---@param spellId number The recipe spell ID
---@return string name
---@return number icon
function TradeSkill.GetBasicInfo(spellId)
	if TradeSkill.IsClassicCrafting() then
		spellId = GetCraftInfo(spellId) or spellId
	end
	local name, icon = Spell.GetInfo(spellId)
	return name, icon
end

---Crafts a recipe.
---@param spellId number The recipe spell ID
---@param quantity number The quantity to craft
---@param optionalMats CraftingReagentInfo[]? Optional material information
---@param level? number The recipe level
---@param enchantSlotId? number The slotId of the item to enchant
---@param salvageSlotId? number The slotId of the item to salvage
---@return string?
function TradeSkill.Craft(spellId, quantity, optionalMats, level, enchantSlotId, salvageSlotId)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		if enchantSlotId then
			assert(not level and not next(optionalMats) and not salvageSlotId)
			private.itemLocation:Clear()
			private.itemLocation:SetBagAndSlot(SlotId.Split(enchantSlotId))
			C_TradeSkillUI.CraftEnchant(spellId, quantity, optionalMats, private.itemLocation)
		elseif salvageSlotId then
			assert(not level and not next(optionalMats))
			if TradeSkill.IsValiMatSlotId(salvageSlotId) then
				private.itemLocation:Clear()
				private.itemLocation:SetBagAndSlot(SlotId.Split(salvageSlotId))
				C_TradeSkillUI.CraftSalvage(spellId, quantity, private.itemLocation)
			end
		else
			C_TradeSkillUI.CraftRecipe(spellId, quantity, optionalMats, level)
		end
		return nil
	else
		assert(not level and not optionalMats and not enchantSlotId and not salvageSlotId)
		local craftName = nil
		if TradeSkill.IsClassicCrafting() then
			assert(quantity == 1)
			craftName = GetCraftInfo(spellId)
			DoCraft(spellId)
		else
			craftName = GetTradeSkillInfo(spellId)
			DoTradeSkill(spellId, quantity)
		end
		return craftName
	end
end

---Checks if the specified slot ID Is a valid salvage target.
---@param slotId number
---@return boolean
function TradeSkill.IsValiMatSlotId(slotId)
	private.itemLocation:Clear()
	private.itemLocation:SetBagAndSlot(SlotId.Split(slotId))
	local success = pcall(C_Item.DoesItemExist, private.itemLocation)
	return success
end

---Securely hook the CraftSalvage API.
---@param func fun(spellId: number, numCasts: number, target: ItemLocationMixin) The function to call
function TradeSkill.SecureHookCraftSalvage(func)
	assert(ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI))
	hooksecurefunc(C_TradeSkillUI, "CraftSalvage", func)
end

---Links a recipe into the chat window.
---@param spellId number The recipe spell ID
function TradeSkill.LinkRecipe(spellId)
	local link = nil
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		link = C_TradeSkillUI.GetRecipeLink(spellId)
	else
		if TradeSkill.IsClassicCrafting() then
			link = GetCraftRecipeLink(spellId)
		else
			link = GetTradeSkillRecipeLink(spellId)
		end
	end
	ChatEdit_InsertLink(link)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MapRecipeType(recipeType)
	if recipeType == Enum.TradeskillRecipeType.Item then
		return RECIPE_TYPE.ITEM
	elseif recipeType == Enum.TradeskillRecipeType.Enchant then
		return RECIPE_TYPE.ENCHANT
	elseif recipeType == Enum.TradeskillRecipeType.Salvage then
		return RECIPE_TYPE.SALVAGE
	else
		return RECIPE_TYPE.UNKNOWN
	end
end

function private.IsRegularMat(data)
	if data.reagentType == Enum.CraftingReagentType.Modifying and data.required then
		return true
	end
	if data.reagentType ~= Enum.CraftingReagentType.Basic then
		return false
	end
	return data.dataSlotType == Enum.TradeskillSlotDataType.Reagent or data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent
end

function private.RecipeIterator(context, index)
	while true do
		index = index + 1
		if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
			if index > #context then
				wipe(context)
				return
			end
			local spellId = context[index]
			local info = C_TradeSkillUI.GetRecipeInfo(spellId)
			assert(info.recipeID == spellId)
			return index, nil, nil, nil, info
		else
			local name, skillType = nil, nil
			if TradeSkill.IsClassicCrafting() then
				if index > GetNumCrafts() then
					wipe(context)
					return
				end
				local _
				name, _, skillType = GetCraftInfo(index)
			else
				if index > GetNumTradeSkills() then
					wipe(context)
					return
				end
				name, skillType = GetTradeSkillInfo(index)
			end
			if skillType == "header" then
				context.lastHeaderIndex = index
			elseif name then
				return index, name, context.lastHeaderIndex, private.MapDifficulty(skillType)
			end
		end
	end
end

function private.SpecialMatIterator(mats, index)
	while true do
		index = index + 1
		if index > #mats then
			return
		end
		local data = mats[index] ---@type CraftingReagentSlotSchematic
		if private.IsValidSpecialMat(data, mats.categorySkillLevel) then
			wipe(private.itemIdsTemp)
			local matType, slotText = nil, nil
			if data.reagentType == Enum.CraftingReagentType.Basic and data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
				matType = MAT_TYPE.QUALITY
				slotText = data.reagents[1].itemID
			elseif data.reagentType == Enum.CraftingReagentType.Optional or data.reagentType == Enum.CraftingReagentType.Modifying then
				if data.required then
					matType = MAT_TYPE.REQUIRED
					slotText = data.slotInfo.slotText or REQUIRED_REAGENT_TOOLTIP_CLICK_TO_ADD
				else
					matType = MAT_TYPE.OPTIONAL
					slotText = data.slotInfo.slotText or OPTIONAL_REAGENT_POSTFIX
				end
			elseif data.reagentType == Enum.CraftingReagentType.Finishing then
				matType = MAT_TYPE.FINISHING
				slotText = data.slotInfo.slotText or OPTIONAL_REAGENT_POSTFIX
			else
				error("Unexpected optional mat type: "..tostring(data.reagentType)..", "..tostring(data.dataSlotType))
			end
			return index, matType, data.quantityRequired, data.dataSlotIndex, slotText, data.reagents
		end
	end
end

function private.IsValidSpecialMat(data, categorySkillLevel)
	if data.reagentType == Enum.CraftingReagentType.Modifying and data.required then
		return true
	end
	if data.reagentType == Enum.CraftingReagentType.Basic and data.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
		-- Pass
	elseif data.reagentType == Enum.CraftingReagentType.Optional or data.reagentType == Enum.CraftingReagentType.Modifying or data.reagentType == Enum.CraftingReagentType.Finishing then
		-- Pass
	else
		return false
	end
	return data.slotInfo.requiredSkillRank <= categorySkillLevel
end

function private.MapDifficulty(value)
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_TRADE_SKILL_UI) then
		if value == Enum.TradeskillRelativeDifficulty.Optimal then
			return RECIPE_DIFFICULTY.OPTIMAL
		elseif value == Enum.TradeskillRelativeDifficulty.Medium then
			return RECIPE_DIFFICULTY.MEDIUM
		elseif value == Enum.TradeskillRelativeDifficulty.Easy then
			return RECIPE_DIFFICULTY.EASY
		elseif value == Enum.TradeskillRelativeDifficulty.Trivial then
			return RECIPE_DIFFICULTY.TRIVIAL
		else
			error("Unknown difficulty: "..tostring(value))
		end
	else
		if value == "optimal" then
			return RECIPE_DIFFICULTY.OPTIMAL
		elseif value == "medium" then
			return RECIPE_DIFFICULTY.MEDIUM
		elseif value == "easy" then
			return RECIPE_DIFFICULTY.EASY
		elseif value == "trivial" then
			return RECIPE_DIFFICULTY.TRIVIAL
		else
			error("Unknown difficulty: "..tostring(value))
		end
	end
end
