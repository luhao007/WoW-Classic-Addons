-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inventory = TSM.MainUI.Ledger:NewPackage("Inventory")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Database = TSM.Include("Util.Database")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local BagTracking = TSM.Include("Service.BagTracking")
local GuildTracking = TSM.Include("Service.GuildTracking")
local AuctionTracking = TSM.Include("Service.AuctionTracking")
local MailTracking = TSM.Include("Service.MailTracking")
local AltTracking = TSM.Include("Service.AltTracking")
local private = {
	db = nil,
	query = nil,
	searchFilter = "",
	groupList = {},
	groupFilter = ALL,
	valuePriceSource = "dbmarket",
}
local NAN = math.huge * 0
local NAN_STR = tostring(NAN)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inventory.OnInitialize()
	TSM.MainUI.Ledger.RegisterPage(L["Inventory"], private.DrawInventoryPage)
end

function Inventory.OnEnable()
	private.db = Database.NewSchema("LEDGER_INVENTORY")
		:AddUniqueStringField("itemString")
		:Commit()
	private.query = private.db:NewQuery()
		:VirtualField("bagQuantity", "number", private.BagQuantityVirtualField)
		:VirtualField("guildQuantity", "number", private.GuildQuantityVirtualField)
		:VirtualField("auctionQuantity", "number", private.AuctionQuantityVirtualField)
		:VirtualField("mailQuantity", "number", private.MailQuantityVirtualField)
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

	wipe(private.groupList)
	tinsert(private.groupList, ALL)
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(private.groupList, groupPath)
	end

	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row1Labels")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "search")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["ITEM SEARCH"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "group")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(GROUP))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row1")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "searchInput")
				:SetStyle("margin.right", 16)
				:SetStyle("hintTextColor", "#e2e2e2")
				:SetStyle("hintJustifyH", "LEFT")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetHintText(L["Filter by Keyword"])
				:SetText(private.searchFilter)
				:SetScript("OnEnterPressed", private.SearchFilterChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "groupDropdown")
				:SetHintText(ALL)
				:SetItems(private.groupList)
				:SetScript("OnSelectionChanged", private.GroupDropdownOnSelectionChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row2")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "search")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["VALUE PRICE SOURCE"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row2")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetSettingInfo(private, "valuePriceSource", private.CheckCustomPrice)
				:SetScript("OnEnterPressed", private.ValuePriceSourceInputOnEnterPressed)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "totalValueRow")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 22)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("autoWidth", true)
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 16)
				:SetText(L["Total Value of All Items"]..":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "value")
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 14)
				:SetText(Money.ToString(private.GetTotalValue()))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "accountingScrollingTableFrame")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "scrollingTable")
				:SetStyle("headerBackground", "#404040")
				:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("headerFontHeight", 14)
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitles(L["Item"])
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", ItemInfo.GetLink)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("totalItems")
						:SetTitles(L["Total"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalQuantity")
						:SetSortInfo("totalQuantity")
						:Commit()
					:NewColumn("bags")
						:SetTitles(L["Bags"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("bagQuantity")
						:SetSortInfo("bagQuantity")
						:Commit()
					:NewColumn("banks")
						:SetTitles(L["Banks"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalBankQuantity")
						:SetSortInfo("totalBankQuantity")
						:Commit()
					:NewColumn("mail")
						:SetTitles(L["Mail"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("mailQuantity")
						:SetSortInfo("mailQuantity")
						:Commit()
					:NewColumn("guildVault")
						:SetTitles(L["GVault"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("guildQuantity")
						:SetSortInfo("guildQuantity")
						:Commit()
					:NewColumn("auctionHouse")
						:SetTitles(L["AH"])
						:SetWidth(60)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("auctionQuantity")
						:SetSortInfo("auctionQuantity")
						:Commit()
					:NewColumn("totalValue")
						:SetTitles(L["Total Value"])
						:SetWidth(120)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
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
	element:GetElement("__parent.__parent.totalValueRow.value")
		:SetText(Money.ToString(private.GetTotalValue()))
		:Draw()
end

function private.SearchFilterChanged(input)
	private.searchFilter = strtrim(input:GetText())
	private.FilterChangedCommon(input)
end

function private.GroupDropdownOnSelectionChanged(dropdown)
	private.groupFilter = dropdown:GetSelectedItem()
	private.FilterChangedCommon(dropdown)
end

function private.ValuePriceSourceInputOnEnterPressed(input)
	private.FilterChangedCommon(input)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.TableGetTotalValueText(totalValue)
	return tostring(totalValue) == NAN_STR and "" or Money.ToString(totalValue)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CheckCustomPrice(value)
	local isValid, err = CustomPrice.Validate(value)
	if isValid then
		return true
	else
		Log.PrintUser(L["Invalid custom price."].." "..err)
		return false
	end
end

function private.BagQuantityVirtualField(row)
	return BagTracking.GetBagsQuantityByBaseItemString(row:GetField("itemString"))
end

function private.GuildQuantityVirtualField(row)
	return GuildTracking.GetQuantityByBaseItemString(row:GetField("itemString"))
end

function private.AuctionQuantityVirtualField(row)
	return AuctionTracking.GetQuantityByBaseItemString(row:GetField("itemString"))
end

function private.MailQuantityVirtualField(row)
	return MailTracking.GetQuantityByBaseItemString(row:GetField("itemString"))
end

function private.TotalQuantityVirtualField(row)
	local itemString = row:GetField("itemString")
	local bankQuantity = BagTracking.GetBankQuantityByBaseItemString(itemString)
	local reagentBankQuantity = BagTracking.GetReagentBankQuantityByBaseItemString(itemString)
	local altQuantity = AltTracking.GetQuantityByBaseItemString(itemString)
	local bagQuantity, guildQuantity, auctionQuantity, mailQuantity = row:GetFields("bagQuantity", "guildQuantity", "auctionQuantity", "mailQuantity")
	return bagQuantity + bankQuantity + reagentBankQuantity + guildQuantity + auctionQuantity + mailQuantity + altQuantity
end

function private.TotalValueVirtualField(row)
	local itemString, totalQuantity = row:GetFields("itemString", "totalQuantity")
	local price = CustomPrice.GetValue(private.valuePriceSource, itemString)
	if not price then
		return NAN
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
	if private.groupFilter ~= ALL then
		private.query:IsNotNil("groupPath")
		private.query:Matches("groupPath", private.groupFilter)
	end
end
