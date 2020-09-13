-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inventory = TSM.MainUI.Ledger:NewPackage("Inventory")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Math = TSM.Include("Util.Math")
local Database = TSM.Include("Util.Database")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local BagTracking = TSM.Include("Service.BagTracking")
local GuildTracking = TSM.Include("Service.GuildTracking")
local AuctionTracking = TSM.Include("Service.AuctionTracking")
local MailTracking = TSM.Include("Service.MailTracking")
local AltTracking = TSM.Include("Service.AltTracking")
local InventoryService = TSM.Include("Service.Inventory")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	db = nil,
	query = nil,
	searchFilter = "",
	groupFilter = {},
	valuePriceSource = "dbmarket", -- luacheck: ignore 1005 - hidden modify via SetSettingInfo()
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inventory.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "mainUIContext", "ledgerInventoryScrollingTable")
	TSM.MainUI.Ledger.RegisterPage(L["Inventory"], private.DrawInventoryPage)
end

function Inventory.OnEnable()
	private.db = Database.NewSchema("LEDGER_INVENTORY")
		:AddUniqueStringField("itemString")
		:Commit()
	private.query = private.db:NewQuery()
		:VirtualField("bagQuantity", "number", BagTracking.GetBagsQuantityByBaseItemString, "itemString")
		:VirtualField("guildQuantity", "number", private.GuildQuantityVirtualField, "itemString")
		:VirtualField("auctionQuantity", "number", AuctionTracking.GetQuantityByBaseItemString, "itemString")
		:VirtualField("mailQuantity", "number", MailTracking.GetQuantityByBaseItemString, "itemString")
		:VirtualField("altQuantity", "number", AltTracking.GetQuantityByBaseItemString, "itemString")
		:VirtualField("totalQuantity", "number", private.TotalQuantityVirtualField)
		:VirtualField("totalValue", "number", private.TotalValueVirtualField)
		:VirtualField("totalBankQuantity", "number", private.GetTotalBankQuantity)
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:LeftJoin(TSM.Groups.GetItemDBForJoin(), "itemString")
		:OrderBy("name", true)
end



-- ============================================================================
-- Inventory UI
-- ============================================================================

function private.DrawInventoryPage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "inventory")
	local items = TempTable.Acquire()
	for _, itemString in BagTracking.BaseItemIterator() do
		items[itemString] = true
	end
	for _, itemString in GuildTracking.BaseItemIterator() do
		items[itemString] = true
	end
	for _, itemString in AuctionTracking.BaseItemIterator() do
		items[itemString] = true
	end
	for _, itemString in MailTracking.BaseItemIterator() do
		items[itemString] = true
	end
	for _, itemString in AltTracking.BaseItemIterator() do
		items[itemString] = true
	end
	private.db:TruncateAndBulkInsertStart()
	for itemString in pairs(items) do
		private.db:BulkInsertNewRow(itemString)
	end
	private.db:BulkInsertEnd()
	TempTable.Release(items)
	private.UpdateQuery()

	return UIElements.New("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(UIElements.New("Frame", "row1")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(8)
			:AddChild(UIElements.New("Input", "filter")
				:SetMargin(0, 8, 0, 0)
				:SetIconTexture("iconPack.18x18/Search")
				:SetClearButtonEnabled(true)
				:AllowItemInsert()
				:SetHintText(L["Filter by keyword"])
				:SetValue(private.searchFilter)
				:SetScript("OnValueChanged", private.SearchFilterChanged)
			)
			:AddChild(UIElements.New("GroupSelector", "group")
				:SetWidth(240)
				:SetHintText(L["Filter by groups"])
				:SetScript("OnSelectionChanged", private.GroupFilterChanged)
			)
		)
		:AddChild(UIElements.New("Frame", "row2")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(8, 8, 0, 8)
			:AddChild(UIElements.New("Text", "label")
				:SetWidth("AUTO")
				:SetFont("BODY_BODY3")
				:SetText(L["Value Price Source"])
			)
			:AddChild(UIElements.New("Input", "input")
				:SetMargin(4, 8, 0, 0)
				:SetBackgroundColor("PRIMARY_BG_ALT")
				:SetBorderColor("ACTIVE_BG")
				:SetFont("TABLE_TABLE1")
				:SetValidateFunc("CUSTOM_PRICE")
				:SetSettingInfo(private, "valuePriceSource")
				:SetScript("OnValueChanged", private.FilterChangedCommon)
			)
			:AddChild(UIElements.New("Frame", "value")
				:SetLayout("HORIZONTAL")
				:SetWidth(240)
				:AddChild(UIElements.New("Spacer", "spacer"))
				:AddChild(UIElements.New("Text", "label")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY3")
					:SetMargin(0, 4, 0, 0)
					:SetText(L["Total Value"]..":")
				)
				:AddChild(UIElements.New("Text", "value")
					:SetWidth("AUTO")
					:SetFont("TABLE_TABLE1")
					:SetText(Money.ToString(private.GetTotalValue()))
				)
			)
		)
		:AddChild(UIElements.New("Frame", "accountingScrollingTableFrame")
			:SetLayout("VERTICAL")
			:AddChild(UIElements.New("QueryScrollingTable", "scrollingTable")
				:SetSettingsContext(private.settings, "ledgerInventoryScrollingTable")
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitle(L["Item"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:DisableHiding()
						:Commit()
					:NewColumn("totalItems")
						:SetTitle(L["Total"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalQuantity")
						:SetSortInfo("totalQuantity")
						:Commit()
					:NewColumn("bags")
						:SetTitle(L["Bags"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("bagQuantity")
						:SetSortInfo("bagQuantity")
						:Commit()
					:NewColumn("banks")
						:SetTitle(L["Banks"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalBankQuantity")
						:SetSortInfo("totalBankQuantity")
						:Commit()
					:NewColumn("mail")
						:SetTitle(L["Mail"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("mailQuantity")
						:SetSortInfo("mailQuantity")
						:Commit()
					:NewColumn("alts")
						:SetTitle(L["Alts"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("altQuantity")
						:SetSortInfo("altQuantity")
						:Commit()
					:NewColumn("guildVault")
						:SetTitle(L["GVault"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("guildQuantity")
						:SetSortInfo("guildQuantity")
						:Commit()
					:NewColumn("auctionHouse")
						:SetTitle(L["AH"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("auctionQuantity")
						:SetSortInfo("auctionQuantity")
						:Commit()
					:NewColumn("totalValue")
						:SetTitle(L["Value"])
						:SetFont("ITEM_BODY3")
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalValue", private.TableGetTotalValueText)
						:SetSortInfo("totalValue")
						:Commit()
					:Commit()
				:SetSelectionDisabled(true)
				:SetQuery(private.query)
			)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FilterChangedCommon(element)
	private.UpdateQuery()
	element:GetElement("__parent.__parent.accountingScrollingTableFrame.scrollingTable")
		:SetQuery(private.query, true)
	element:GetElement("__parent.__parent.row2.value.value")
		:SetText(Money.ToString(private.GetTotalValue()))
		:Draw()
end

function private.SearchFilterChanged(input)
	private.searchFilter = input:GetValue()
	private.FilterChangedCommon(input)
end

function private.GroupFilterChanged(groupSelector)
	wipe(private.groupFilter)
	for groupPath in groupSelector:SelectedGroupIterator() do
		private.groupFilter[groupPath] = true
	end
	private.FilterChangedCommon(groupSelector)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.TableGetTotalValueText(totalValue)
	return Math.IsNan(totalValue) and "" or Money.ToString(totalValue)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GuildQuantityVirtualField(itemString)
	local totalNum = 0
	for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		local guildQuantity = InventoryService.GetGuildQuantity(itemString, guildName)
		totalNum = totalNum + guildQuantity
	end
	return totalNum
end

function private.TotalQuantityVirtualField(row)
	local bagQuantity, totalBankQuantity, guildQuantity, auctionQuantity, mailQuantity, altQuantity = row:GetFields("bagQuantity", "totalBankQuantity", "guildQuantity", "auctionQuantity", "mailQuantity", "altQuantity")
	return bagQuantity + totalBankQuantity + guildQuantity + auctionQuantity + mailQuantity + altQuantity
end

function private.TotalValueVirtualField(row)
	local itemString, totalQuantity = row:GetFields("itemString", "totalQuantity")
	local price = CustomPrice.GetValue(private.valuePriceSource, itemString)
	if not price then
		return Math.GetNan()
	end
	return price * totalQuantity
end

function private.GetTotalBankQuantity(row)
	local itemString = row:GetField("itemString")
	local bankQuantity = BagTracking.GetBankQuantityByBaseItemString(itemString)
	local reagentBankQuantity = BagTracking.GetReagentBankQuantityByBaseItemString(itemString)
	return bankQuantity + reagentBankQuantity
end

function private.GetTotalValue()
	-- can't lookup the value of items while the query is iteratoring, so grab the list of items first
	local itemQuantities = TempTable.Acquire()
	for _, row in private.query:Iterator() do
		local itemString, total = row:GetFields("itemString", "totalQuantity")
		itemQuantities[itemString] = total
	end
	local totalValue = 0
	for itemString, total in pairs(itemQuantities) do
		local price = CustomPrice.GetValue(private.valuePriceSource, itemString)
		if price then
			totalValue = totalValue + price * total
		end
	end
	TempTable.Release(itemQuantities)
	return totalValue
end

function private.UpdateQuery()
	private.query:ResetFilters()
	if private.searchFilter ~= "" then
		private.query:Matches("name", String.Escape(private.searchFilter))
	end
	if next(private.groupFilter) then
		private.query:InTable("groupPath", private.groupFilter)
	end
end
