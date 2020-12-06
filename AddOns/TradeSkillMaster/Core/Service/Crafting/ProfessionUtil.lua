-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ProfessionUtil = TSM.Crafting:NewPackage("ProfessionUtil")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local Delay = TSM.Include("Util.Delay")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local Inventory = TSM.Include("Service.Inventory")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	craftQuantity = nil,
	craftSpellId = nil,
	craftCallback = nil,
	craftName = nil,
	castingTimeout = nil,
	craftTimeout = nil,
	preparedSpellId = nil,
	preparedTime = 0,
	categoryInfoTemp = {},
}
local PROFESSION_LOOKUP = {
	["Costura"] = "Sastrería",
	["Marroquinería"] = "Peletería",
	["Ingénierie"] = "Ingénieur",
	["Secourisme"] = "Premiers soins",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionUtil.OnInitialize()
	Event.Register("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if (TSM.IsWowClassic() and GetSpellInfo(spellId) ~= private.craftName) or (not TSM.IsWowClassic() and spellId ~= private.craftSpellId) then
			return
		end

		-- check if we need to update bank quantity manually
		for _, itemString, quantity in TSM.Crafting.MatIterator(private.craftSpellId) do
			local bankUsed = quantity - (Inventory.GetBagQuantity(itemString) + Inventory.GetReagentBankQuantity(itemString))
			if bankUsed > 0 and bankUsed <= Inventory.GetBankQuantity(itemString) then
				Log.Info("Used %d from bank", bankUsed)
				BagTracking.ForceBankQuantityDeduction(itemString, bankUsed)
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
	local function SpellcastFailedEventHandler(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if (TSM.IsWowClassic() and GetSpellInfo(spellId) ~= private.craftName) or (not TSM.IsWowClassic() and spellId ~= private.craftSpellId) then
			return
		end
		private.DoCraftCallback(false, true)
	end
	local function ClearCraftCast()
		private.craftQuantity = nil
		private.craftSpellId = nil
		private.craftName = nil
		private.castingTimeout = nil
		private.craftTimeout = nil
	end
	Event.Register("UNIT_SPELLCAST_INTERRUPTED", SpellcastFailedEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED", SpellcastFailedEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED_QUIET", SpellcastFailedEventHandler)
	Event.Register("TRADE_SKILL_CLOSE", ClearCraftCast)
	if TSM.IsWowClassic() then
		Event.Register("CRAFT_CLOSE", ClearCraftCast)
	end
end

function ProfessionUtil.GetCurrentProfessionName()
	if TSM.IsWowClassic() then
		local name = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftSkillLine(1) or GetTradeSkillLine()
		return name
	else
		local _, name, _, _, _, _, parentName = C_TradeSkillUI.GetTradeSkillLine()
		return parentName or name
	end
end

function ProfessionUtil.GetResultInfo(spellId)
	-- get the links
	local itemLink = ProfessionUtil.GetRecipeInfo(spellId)
	assert(itemLink, "Invalid craft: "..tostring(spellId))

	if strfind(itemLink, "enchant:") then
		-- result of craft is not an item
		local itemString = ProfessionInfo.GetIndirectCraftResult(spellId)
		if itemString and not TSM.IsWowClassic() then
			return TSM.UI.GetColoredItemName(itemString), itemString, ItemInfo.GetTexture(itemString)
		elseif ProfessionInfo.IsEngineeringTinker(spellId) then
			local name, _, icon = GetSpellInfo(spellId)
			return name, nil, icon
		else
			local name, _, icon = GetSpellInfo(TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftInfo(TSM.IsWowClassic() and TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId) or spellId)
			return name, nil, icon
		end
	elseif strfind(itemLink, "item:") then
		-- result of craft is an item
		return TSM.UI.GetColoredItemName(itemLink), ItemString.Get(itemLink), ItemInfo.GetTexture(itemLink)
	else
		error("Invalid craft: "..tostring(spellId))
	end
end

function ProfessionUtil.GetNumCraftable(spellId)
	local num, numAll = math.huge, math.huge
	for i = 1, ProfessionUtil.GetNumMats(spellId) do
		local matItemLink, _, _, quantity = ProfessionUtil.GetMatInfo(spellId, i)
		local itemString = ItemString.Get(matItemLink)
		local totalQuantity = CustomPrice.GetItemPrice(itemString, "NumInventory") or 0
		if not itemString or not quantity or totalQuantity == 0 then
			return 0, 0
		end
		local bagQuantity = Inventory.GetBagQuantity(itemString)
		if not TSM.IsWowClassic() then
			bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
		end
		num = min(num, floor(bagQuantity / quantity))
		numAll = min(numAll, floor(totalQuantity / quantity))
	end
	if num == math.huge or numAll == math.huge then
		return 0, 0
	end
	return num, numAll
end

function ProfessionUtil.IsCraftable(spellId)
	for i = 1, ProfessionUtil.GetNumMats(spellId) do
		local matItemLink, _, _, quantity = ProfessionUtil.GetMatInfo(spellId, i)
		local itemString = ItemString.Get(matItemLink)
		if not itemString or not quantity then
			return false
		end
		local bagQuantity = Inventory.GetBagQuantity(itemString)
		if not TSM.IsWowClassic() then
			bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
		end
		if floor(bagQuantity / quantity) == 0 then
			return false
		end
	end
	return true
end

function ProfessionUtil.GetNumCraftableFromDB(spellId)
	local num = math.huge
	for _, itemString, quantity in TSM.Crafting.MatIterator(spellId) do
		local bagQuantity = Inventory.GetBagQuantity(itemString)
		if not TSM.IsWowClassic() then
			bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
		end
		num = min(num, floor(bagQuantity / quantity))
	end
	if num == math.huge then
		return 0
	end
	return num
end

function ProfessionUtil.IsEnchant(spellId)
	local name = ProfessionUtil.GetCurrentProfessionName()
	if name ~= GetSpellInfo(7411) or TSM.IsWowClassic() then
		return false
	end
	if not strfind(C_TradeSkillUI.GetRecipeItemLink(spellId), "enchant:") then
		return false
	end
	local recipeInfo = C_TradeSkillUI.GetRecipeInfo(spellId)
	local altVerb = recipeInfo.alternateVerb
	return altVerb and true or false
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

function ProfessionUtil.PrepareToCraft(spellId, quantity)
	quantity = min(quantity, ProfessionUtil.GetNumCraftable(spellId))
	if quantity == 0 then
		return
	end
	if ProfessionUtil.IsEnchant(spellId) then
		quantity = 1
	end

	if not TSM.IsWowClassic() then
		C_TradeSkillUI.SetRecipeRepeatCount(spellId, quantity)
	end
	private.preparedSpellId = spellId
	private.preparedTime = GetTime()
end

function ProfessionUtil.Craft(spellId, quantity, useVellum, callback)
	assert(TSM.Crafting.ProfessionScanner.HasSpellId(spellId))
	if private.craftSpellId then
		private.craftCallback = callback
		private.DoCraftCallback(false, true)
		return 0
	end
	quantity = min(quantity, ProfessionUtil.GetNumCraftable(spellId))
	if quantity == 0 then
		return 0
	end
	local isEnchant = ProfessionUtil.IsEnchant(spellId)
	if isEnchant then
		quantity = 1
	elseif spellId ~= private.preparedSpellId or private.preparedTime == GetTime() then
		-- We can only craft one of this item due to a bug on Blizzard's end
		quantity = 1
	end
	private.craftQuantity = quantity
	private.craftSpellId = spellId
	private.craftCallback = callback
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			private.craftName = GetCraftInfo(spellId)
		else
			private.craftName = GetTradeSkillInfo(spellId)
			DoTradeSkill(spellId, quantity)
		end
	else
		C_TradeSkillUI.CraftRecipe(spellId, quantity)
	end
	if useVellum and isEnchant then
		UseItemByName(ItemInfo.GetName(ProfessionInfo.GetVellumItemString()))
	end
	private.castingTimeout = nil
	private.craftTimeout = nil
	Delay.AfterTime("PROFESSION_CRAFT_TIMEOUT_MONITOR", 0.5, private.CraftTimeoutMonitor, 0.5)
	return quantity
end

function ProfessionUtil.IsDataStable()
	return TSM.IsWowClassic() or (C_TradeSkillUI.IsTradeSkillReady() and not C_TradeSkillUI.IsDataSourceChanging())
end

function ProfessionUtil.HasCooldown(spellId)
	if TSM.IsWowClassic() then
		return GetTradeSkillCooldown(spellId) and true or false
	else
		return select(2, C_TradeSkillUI.GetRecipeCooldown(spellId)) and true or false
	end
end

function ProfessionUtil.GetRemainingCooldown(spellId)
	if TSM.IsWowClassic() then
		return GetTradeSkillCooldown(spellId)
	else
		return C_TradeSkillUI.GetRecipeCooldown(spellId)
	end
end

function ProfessionUtil.GetRecipeInfo(spellId)
	local itemLink, lNum, hNum, toolsStr, hasTools = nil, nil, nil, nil, nil
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftItemLink(spellId) or GetTradeSkillItemLink(spellId)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			lNum, hNum = 1, 1
			toolsStr, hasTools = GetCraftSpellFocus(spellId)
		else
			lNum, hNum = GetTradeSkillNumMade(spellId)
			toolsStr, hasTools = GetTradeSkillTools(spellId)
		end
	else
		itemLink = C_TradeSkillUI.GetRecipeItemLink(spellId)
		lNum, hNum = C_TradeSkillUI.GetRecipeNumItemsProduced(spellId)
		toolsStr, hasTools = C_TradeSkillUI.GetRecipeTools(spellId)
	end
	return itemLink, lNum, hNum, toolsStr, hasTools
end

function ProfessionUtil.GetNumMats(spellId)
	local numMats = nil
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		numMats = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftNumReagents(spellId) or GetTradeSkillNumReagents(spellId)
	else
		numMats = C_TradeSkillUI.GetRecipeNumReagents(spellId)
	end
	return numMats
end

function ProfessionUtil.GetMatInfo(spellId, index)
	local itemLink, name, texture, quantity = nil, nil, nil, nil
	if TSM.IsWowClassic() then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftReagentItemLink(spellId, index) or GetTradeSkillReagentItemLink(spellId, index)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			name, texture, quantity = GetCraftReagentInfo(spellId, index)
		else
			name, texture, quantity = GetTradeSkillReagentInfo(spellId, index)
		end
	else
		itemLink = C_TradeSkillUI.GetRecipeReagentItemLink(spellId, index)
		name, texture, quantity = C_TradeSkillUI.GetRecipeReagentInfo(spellId, index)
		if itemLink then
			name = name or ItemInfo.GetName(itemLink)
			texture = texture or ItemInfo.GetTexture(itemLink)
		end
	end
	return itemLink, name, texture, quantity
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
	if TSM.IsWowClassic() then
		return nil, nil
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
		assert(private.categoryInfoTemp.numIndents)
		name = private.categoryInfoTemp.name
		numIndents = private.categoryInfoTemp.numIndents
		parentCategoryId = private.categoryInfoTemp.numIndents ~= 0 and private.categoryInfoTemp.parentCategoryID or nil
		currentSkillLevel = private.categoryInfoTemp.skillLineCurrentLevel
		maxSkillLevel = private.categoryInfoTemp.skillLineMaxLevel
		wipe(private.categoryInfoTemp)
	end
	return name, numIndents, parentCategoryId, currentSkillLevel, maxSkillLevel
end

function ProfessionUtil.StoreOptionalMatText(matList, text)
	TSM.db.global.internalData.optionalMatTextLookup[matList] = TSM.db.global.internalData.optionalMatTextLookup[matList] or text
end

function ProfessionUtil.GetOptionalMatText(matList)
	return TSM.db.global.internalData.optionalMatTextLookup[matList]
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
		private.craftSpellId = nil
		private.craftCallback = nil
		private.craftName = nil
		Delay.Cancel("PROFESSION_CRAFT_TIMEOUT_MONITOR")
	end
	callback(result, isDone)
end

function private.CraftTimeoutMonitor()
	if not private.craftSpellId then
		Log.Info("No longer crafting")
		private.castingTimeout = nil
		private.craftTimeout = nil
		Delay.Cancel("PROFESSION_CRAFT_TIMEOUT_MONITOR")
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
		Delay.Cancel("PROFESSION_CRAFT_TIMEOUT_MONITOR")
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
