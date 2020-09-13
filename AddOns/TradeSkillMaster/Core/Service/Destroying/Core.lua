-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Destroying = TSM:NewPackage("Destroying")
local Database = TSM.Include("Util.Database")
local Event = TSM.Include("Util.Event")
local SlotId = TSM.Include("Util.SlotId")
local TempTable = TSM.Include("Util.TempTable")
local ItemString = TSM.Include("Util.ItemString")
local Future = TSM.Include("Util.Future")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Conversions = TSM.Include("Service.Conversions")
local BagTracking = TSM.Include("Service.BagTracking")
local Settings = TSM.Include("Service.Settings")
local private = {
	combineThread = nil,
	destroyThread = nil,
	destroyThreadRunning = false,
	settings = nil,
	canDestroyCache = {},
	destroyQuantityCache = {},
	pendingCombines = {},
	newBagUpdate = false,
	bagUpdateCallback = nil,
	pendingSpellId = nil,
	ignoreDB = nil,
	destroyInfoDB = nil,
	combineFuture = Future.New("DESTROYING_COMBINE_FUTURE"),
	destroyFuture = Future.New("DESTROYING_DESTROY_FUTURE"),
}
local SPELL_IDS = {
	milling = 51005,
	prospect = 31252,
	disenchant = 13262,
}
local ITEM_SUB_CLASS_METAL_AND_STONE = 7
local ITEM_SUB_CLASS_HERB = 9
local TARGET_SLOT_ID_MULTIPLIER = 1000000
local GEM_CHIPS = {
	["i:129099"] = "i:129100",
	["i:130200"] = "i:129100",
	["i:130201"] = "i:129100",
	["i:130202"] = "i:129100",
	["i:130203"] = "i:129100",
	["i:130204"] = "i:129100",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Destroying.OnInitialize()
	private.combineThread = Threading.New("COMBINE_STACKS", private.CombineThread)
	Threading.SetCallback(private.combineThread, private.CombineThreadDone)
	private.destroyThread = Threading.New("DESTROY", private.DestroyThread)
	Threading.SetCallback(private.destroyThread, private.DestroyThreadDone)
	BagTracking.RegisterCallback(private.UpdateBagDB)

	private.settings = Settings.NewView()
		:AddKey("global", "internalData", "destroyingHistory")
		:AddKey("global", "destroyingOptions", "deAbovePrice")
		:AddKey("global", "destroyingOptions", "deMaxQuality")
		:AddKey("global", "destroyingOptions", "includeSoulbound")
		:AddKey("global", "userData", "destroyingIgnore")
		:RegisterCallback("deAbovePrice", private.UpdateBagDB)
		:RegisterCallback("deMaxQuality", private.UpdateBagDB)
		:RegisterCallback("includeSoulbound", private.UpdateBagDB)

	private.ignoreDB = Database.NewSchema("DESTROYING_IGNORE")
		:AddUniqueStringField("itemString")
		:AddBooleanField("ignoreSession")
		:AddBooleanField("ignorePermanent")
		:Commit()
	private.ignoreDB:BulkInsertStart()
	local used = TempTable.Acquire()
	for itemString in pairs(private.settings.destroyingIgnore) do
		itemString = ItemString.Get(itemString)
		if not used[itemString] then
			used[itemString] = true
			private.ignoreDB:BulkInsertNewRow(itemString, false, true)
		end
	end
	TempTable.Release(used)
	private.ignoreDB:BulkInsertEnd()

	private.destroyInfoDB = Database.NewSchema("DESTROYING_INFO")
		:AddUniqueStringField("itemString")
		:AddNumberField("minQuantity")
		:AddNumberField("spellId")
		:Commit()

	Event.Register("LOOT_CLOSED", private.SendEventToThread)
	Event.Register("BAG_UPDATE_DELAYED", private.SendEventToThread)
	Event.Register("UNIT_SPELLCAST_START", private.SpellCastEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED", private.SpellCastEventHandler)
	Event.Register("UNIT_SPELLCAST_FAILED_QUIET", private.SpellCastEventHandler)
	Event.Register("UNIT_SPELLCAST_INTERRUPTED", private.SpellCastEventHandler)
	Event.Register("UNIT_SPELLCAST_SUCCEEDED", private.SpellCastEventHandler)

	private.destroyFuture:SetScript("OnCleanup", function()
		private.destroyThreadRunning = false
		Threading.Kill(private.destroyThread)
	end)
	private.combineFuture:SetScript("OnCleanup", function()
		Threading.Kill(private.combineThread)
	end)
end

function Destroying.SetBagUpdateCallback(callback)
	assert(not private.bagUpdateCallback)
	private.bagUpdateCallback = callback
end

function Destroying.CreateBagQuery()
	return BagTracking.CreateQueryBags()
		:LeftJoin(private.ignoreDB, "itemString")
		:InnerJoin(private.destroyInfoDB, "itemString")
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:NotEqual("ignoreSession", true)
		:NotEqual("ignorePermanent", true)
		:GreaterThanOrEqual("quantity", Database.OtherFieldQueryParam("minQuantity"))
end

function Destroying.CanCombine()
	return #private.pendingCombines > 0
end

function Destroying.StartCombine()
	private.combineFuture:Start()
	Threading.Start(private.combineThread)
	return private.combineFuture
end

function Destroying.StartDestroy(button, row, callback)
	private.destroyFuture:Start()
	private.destroyThreadRunning = true
	Threading.Start(private.destroyThread, button, row)
	-- we need the thread to run now so send it a sync message
	Threading.SendSyncMessage(private.destroyThread)
	return private.destroyFuture
end

function Destroying.IgnoreItemSession(itemString)
	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignoreSession"))
		row:SetField("ignoreSession", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", true)
			:SetField("ignorePermanent", false)
			:Create()
	end
end

function Destroying.IgnoreItemPermanent(itemString)
	assert(not private.settings.destroyingIgnore[itemString])
	private.settings.destroyingIgnore[itemString] = true

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignorePermanent"))
		row:SetField("ignorePermanent", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", false)
			:SetField("ignorePermanent", true)
			:Create()
	end
end

function Destroying.ForgetIgnoreItemPermanent(itemString)
	assert(private.settings.destroyingIgnore[itemString])
	private.settings.destroyingIgnore[itemString] = nil

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	assert(row and row:GetField("ignorePermanent"))
	if row:GetField("ignoreSession") then
		row:SetField("ignorePermanent", false)
		row:Update()
	else
		private.ignoreDB:DeleteRow(row)
	end
	row:Release()
end

function Destroying.CreateIgnoreQuery()
	return private.ignoreDB:NewQuery()
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:Equal("ignorePermanent", true)
		:OrderBy("name", true)
end



-- ============================================================================
-- Combine Stacks Thread
-- ============================================================================

function private.CombineThread()
	while Destroying.CanCombine() do
		for _, combineSlotId in ipairs(private.pendingCombines) do
			local sourceBag, sourceSlot, targetBag, targetSlot = private.CombineSlotIdToBagSlot(combineSlotId)
			PickupContainerItem(sourceBag, sourceSlot)
			PickupContainerItem(targetBag, targetSlot)
		end
		-- wait for the bagDB to change
		private.newBagUpdate = false
		Threading.WaitForFunction(private.HasNewBagUpdate)
	end
end

function private.CombineSlotIdToBagSlot(combineSlotId)
	local sourceSlotId = combineSlotId % TARGET_SLOT_ID_MULTIPLIER
	local targetSlotId = floor(combineSlotId / TARGET_SLOT_ID_MULTIPLIER)
	local sourceBag, sourceSlot = SlotId.Split(sourceSlotId)
	local targetBag, targetSlot = SlotId.Split(targetSlotId)
	return sourceBag, sourceSlot, targetBag, targetSlot
end

function private.HasNewBagUpdate()
	return private.newBagUpdate
end

function private.CombineThreadDone(result)
	private.combineFuture:Done(result)
end



-- ============================================================================
-- Destroy Thread
-- ============================================================================

function private.DestroyThread(button, row)
	-- we get sent a sync message so we run right away
	Threading.ReceiveMessage()

	local itemString, spellId, bag, slot = row:GetFields("itemString", "spellId", "bag", "slot")
	local spellName = GetSpellInfo(spellId)
	button:SetMacroText(format("/cast %s;\n/use %d %d", spellName, bag, slot))

	-- wait for the spell cast to start or fail
	private.pendingSpellId = spellId
	local event = Threading.ReceiveMessage()
	if event ~= "UNIT_SPELLCAST_START" then
		-- the spell cast failed for some reason
		ClearCursor()
		return false
	end

	-- discard any other messages
	Threading.Yield(true)
	while Threading.HasPendingMessage() do
		Threading.ReceiveMessage()
	end

	-- wait for the spell cast to finish
	event = Threading.ReceiveMessage()
	if event ~= "UNIT_SPELLCAST_SUCCEEDED" then
		-- the spell cast was interrupted
		return false
	end

	-- wait for the loot window to open
	Threading.WaitForEvent("LOOT_READY")

	-- add to the log
	local newEntry = {
		item = itemString,
		time = time(),
		result = {},
	}
	assert(GetNumLootItems() > 0)
	for i = 1, GetNumLootItems() do
		local lootItemString = ItemString.Get(GetLootSlotLink(i))
		local _, _, quantity = GetLootSlotInfo(i)
		if lootItemString and (quantity or 0) > 0 then
			lootItemString = GEM_CHIPS[lootItemString] or lootItemString
			newEntry.result[lootItemString] = quantity
		end
	end
	private.settings.destroyingHistory[spellName] = private.settings.destroyingHistory[spellName] or {}
	tinsert(private.settings.destroyingHistory[spellName], newEntry)

	-- wait for the loot window to close
	local hasLootClosed, hasBagUpdateDelayed = false, false
	while not hasLootClosed or not hasBagUpdateDelayed do
		event = Threading.ReceiveMessage()
		if event == "LOOT_CLOSED" then
			hasLootClosed = true
		elseif event == "BAG_UPDATE_DELAYED" then
			hasBagUpdateDelayed = true
		end
	end

	-- we're done
	return true
end

function private.SendEventToThread(event)
	if not private.destroyThreadRunning then
		return
	end
	Threading.SendMessage(private.destroyThread, event)
end

function private.SpellCastEventHandler(event, unit, _, spellId)
	if unit ~= "player" or spellId ~= private.pendingSpellId then
		return
	end
	private.SendEventToThread(event)
end

function private.DestroyThreadDone(result)
	private.destroyThreadRunning = false
	private.destroyFuture:Done(result)
end



-- ============================================================================
-- Bag Update Functions
-- ============================================================================

function private.UpdateBagDB()
	wipe(private.pendingCombines)
	private.destroyInfoDB:TruncateAndBulkInsertStart()
	local itemPrevSlotId = TempTable.Acquire()
	local checkedItem = TempTable.Acquire()
	local query = BagTracking.CreateQueryBags()
		:OrderBy("slotId", true)
		:Select("slotId", "itemString", "quantity")
	if not private.settings.includeSoulbound then
		query:Equal("isBoP", false)
			:Equal("isBoA", false)
	end
	for _, slotId, itemString, quantity in query:Iterator() do
		local minQuantity = nil
		if checkedItem[itemString] then
			minQuantity = private.destroyInfoDB:GetUniqueRowField("itemString", itemString, "minQuantity")
		else
			checkedItem[itemString] = true
			local spellId = nil
			minQuantity, spellId = private.ProcessBagItem(itemString)
			if minQuantity then
				private.destroyInfoDB:BulkInsertNewRow(itemString, minQuantity, spellId)
			end
		end
		if minQuantity and quantity % minQuantity ~= 0 then
			if itemPrevSlotId[itemString] then
				-- we can combine this with the previous partial stack
				tinsert(private.pendingCombines, itemPrevSlotId[itemString] * TARGET_SLOT_ID_MULTIPLIER + slotId)
				itemPrevSlotId[itemString] = nil
			else
				itemPrevSlotId[itemString] = slotId
			end
		end
	end
	query:Release()
	TempTable.Release(checkedItem)
	TempTable.Release(itemPrevSlotId)
	private.destroyInfoDB:BulkInsertEnd()

	private.newBagUpdate = true
	if private.bagUpdateCallback then
		private.bagUpdateCallback()
	end
end

function private.ProcessBagItem(itemString)
	if private.ignoreDB:HasUniqueRow("itemString", itemString) then
		return
	end

	local spellId, minQuantity = private.IsDestroyable(itemString)
	if not spellId then
		return
	elseif spellId == SPELL_IDS.disenchant then
		local deAbovePrice = CustomPrice.GetValue(private.settings.deAbovePrice, itemString) or 0
		local deValue = CustomPrice.GetValue("Destroy", itemString) or math.huge
		if deValue < deAbovePrice then
			return
		end
	end
	return minQuantity, spellId
end

function private.IsDestroyable(itemString)
	if private.destroyQuantityCache[itemString] then
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	-- disenchanting
	local quality = ItemInfo.GetQuality(itemString)
	if ItemInfo.IsDisenchantable(itemString) and quality <= private.settings.deMaxQuality then
		private.canDestroyCache[itemString] = IsSpellKnown(SPELL_IDS.disenchant) and SPELL_IDS.disenchant
		private.destroyQuantityCache[itemString] = 1
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	local conversionMethod, destroySpellId = nil, nil
	local classId = ItemInfo.GetClassId(itemString)
	local subClassId = ItemInfo.GetSubClassId(itemString)
	if classId == LE_ITEM_CLASS_TRADEGOODS and subClassId == ITEM_SUB_CLASS_HERB then
		conversionMethod = Conversions.METHOD.MILL
		destroySpellId = SPELL_IDS.milling
	elseif classId == LE_ITEM_CLASS_TRADEGOODS and subClassId == ITEM_SUB_CLASS_METAL_AND_STONE then
		conversionMethod = Conversions.METHOD.PROSPECT
		destroySpellId = SPELL_IDS.prospect
	else
		private.canDestroyCache[itemString] = false
		private.destroyQuantityCache[itemString] = nil
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	local hasSourceItem = false
	for _ in Conversions.TargetItemsByMethodIterator(itemString, conversionMethod) do
		hasSourceItem = true
	end
	if hasSourceItem then
		private.canDestroyCache[itemString] = IsSpellKnown(destroySpellId) and destroySpellId
		private.destroyQuantityCache[itemString] = 5
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
end
