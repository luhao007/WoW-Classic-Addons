-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BuyUtil = TSM.UI.AuctionUI:NewPackage("BuyUtil")
local L = TSM.Include("Locale").GetTable()
local Money = TSM.Include("Util.Money")
local Log = TSM.Include("Util.Log")
local Math = TSM.Include("Util.Math")
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	totalBuyout = nil,
	isBuy = nil,
	auctionScan = nil,
	subRow = nil,
	index = nil,
	noSeller = nil,
	baseFrame = nil,
	dialogFrame = nil,
	future = nil,
	prepareQuantity = nil,
	prepareSuccess = false,
	marketValueFunc = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function BuyUtil.ShowConfirmation(baseFrame, subRow, isBuy, auctionNum, numFound, maxQuantity, callback, auctionScan, index, noSeller, marketValueFunc)
	auctionNum = min(auctionNum, numFound)
	local buyout = subRow:GetBuyouts()
	if not isBuy then
		buyout = subRow:GetRequiredBid(subRow)
	end
	local quantity = subRow:GetQuantities()
	local itemString = subRow:GetItemString()
	local _, _, _, isHighBidder = subRow:GetBidInfo()
	local isCommodity = not TSM.IsWowClassic() and subRow:IsCommodity()
	local shouldConfirm = false
	if isCommodity then
		shouldConfirm = true
	elseif isBuy and isHighBidder then
		shouldConfirm = true
	elseif TSM.db.global.shoppingOptions.buyoutConfirm then
		shouldConfirm = ceil(buyout / quantity) >= (CustomPrice.GetValue(TSM.db.global.shoppingOptions.buyoutAlertSource, itemString) or 0)
	end
	if not shouldConfirm then
		return false
	end

	baseFrame = baseFrame:GetBaseElement()
	private.isBuy = isBuy
	private.auctionScan = auctionScan
	private.subRow = subRow
	private.index = index
	private.noSeller = noSeller
	private.baseFrame = baseFrame
	private.marketValueFunc = marketValueFunc
	if private.dialogFrame then
		return true
	end

	local defaultQuantity = isCommodity and numFound or 1
	assert(not isCommodity or isBuy)

	local displayItemBuyout, displayTotalBuyout = nil, nil
	if isCommodity then
		displayTotalBuyout = private.CommodityResultsByQuantity(itemString, defaultQuantity)
		displayItemBuyout = Math.Ceil(displayTotalBuyout / defaultQuantity, COPPER_PER_SILVER)
	else
		displayItemBuyout = ceil(buyout / quantity)
		displayTotalBuyout = TSM.IsWowClassic() and buyout or ceil(buyout / quantity)
	end

	private.dialogFrame = UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetSize(isCommodity and 600 or 326, isCommodity and 272 or 262)
		:SetPadding(12)
		:AddAnchor("CENTER")
		:SetContext(callback)
		:SetMouseEnabled(true)
		:SetBackgroundColor("FRAME_BG", true)
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, -4, 10)
			:AddChild(UIElements.New("Spacer", "spacer")
				:SetWidth(20)
			)
			:AddChild(UIElements.New("Text", "title")
				:SetJustifyH("CENTER")
				:SetFont("BODY_BODY1_BOLD")
				:SetText(isCommodity and L["Order Confirmation"] or L["Buyout"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.BuyoutConfirmCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("Frame", "content")
			:SetLayout("HORIZONTAL")
			:AddChild(UIElements.New("Frame", "left")
				:SetLayout("VERTICAL")
				:AddChild(UIElements.New("Frame", "item")
					:SetLayout("HORIZONTAL")
					:SetPadding(6)
					:SetMargin(0, 0, 0, 16)
					:SetBackgroundColor("PRIMARY_BG_ALT", true)
					:AddChild(UIElements.New("Button", "icon")
						:SetSize(36, 36)
						:SetMargin(0, 8, 0, 0)
						:SetBackground(ItemInfo.GetTexture(itemString))
						:SetTooltip(itemString)
					)
					:AddChild(UIElements.New("Text", "name")
						:SetHeight(36)
						:SetFont("ITEM_BODY1")
						:SetText(TSM.UI.GetColoredItemName(itemString))
					)
				)
				:AddChildIf(isCommodity, UIElements.New("Frame", "quantity")
					:SetLayout("HORIZONTAL")
					:SetHeight(24)
					:AddChild(UIElements.New("Text", "desc")
						:SetFont("BODY_BODY2")
						:SetText(L["Quantity"]..":")
					)
					:AddChild(UIElements.New("Input", "input")
						:SetWidth(140)
						:SetJustifyH("RIGHT")
						:SetBackgroundColor("PRIMARY_BG_ALT")
						:SetValidateFunc("NUMBER", "1:"..maxQuantity)
						:SetValue(tostring(defaultQuantity))
						:SetContext(maxQuantity)
						:SetScript("OnValueChanged", private.InputQtyOnValueChanged)
					)
				)
				:AddChildIf(not isCommodity, UIElements.New("Frame", "stacks")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(0, 0, 0, 10)
					:AddChild(UIElements.New("Text", "desc")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY2")
						:SetText(isBuy and L["Purchasing Auction"]..":" or L["Bidding Auction"]..":")
					)
					:AddChild(UIElements.New("Text", "number")
						:SetJustifyH("RIGHT")
						:SetFont("TABLE_TABLE1")
						:SetText(auctionNum.."/"..numFound)
					)
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
				:AddChild(UIElements.New("Frame", "price")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(0, 0, 0, 10)
					:AddChild(UIElements.New("Text", "desc")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY2")
						:SetText(L["Unit Price"]..":")
					)
					:AddChild(UIElements.New("Text", "money")
						:SetJustifyH("RIGHT")
						:SetFont("TABLE_TABLE1")
						:SetContext(displayItemBuyout)
						:SetText(private.GetUnitPriceMoneyStr(displayItemBuyout))
					)
				)
				:AddChild(UIElements.New("Frame", "total")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(0, 0, 0, 10)
					:AddChild(UIElements.New("Text", "desc")
						:SetWidth("AUTO")
						:SetFont("BODY_BODY2")
						:SetText(L["Total Price"]..":")
					)
					:AddChild(UIElements.New("Text", "money")
						:SetJustifyH("RIGHT")
						:SetFont("TABLE_TABLE1")
						:SetText(Money.ToString(displayTotalBuyout, nil, "OPT_83_NO_COPPER"))
					)
				)
				:AddChild(UIElements.New("Text", "warning")
					:SetHeight(20)
					:SetMargin(0, 0, 0, 10)
					:SetFont("BODY_BODY3")
					:SetJustifyH("CENTER")
					:SetTextColor(Theme.GetFeedbackColor("YELLOW"))
					:SetText("")
				)
				:AddChild(UIElements.NewNamed("ActionButton", "confirmBtn", "TSMBidBuyConfirmBtn")
					:SetHeight(24)
					:SetText(isCommodity and L["Buy Commodity"] or (isBuy and L["Buy Auction"] or L["Bid Auction"]))
					:SetContext(not isCommodity and quantity or nil)
					:SetDisabled(private.future and true or false)
					:SetScript("OnClick", private.ConfirmBtnOnClick)
				)
			)
			:AddChildIf(isCommodity, UIElements.New("Frame", "item")
				:SetLayout("HORIZONTAL")
				:SetWidth(266)
				:SetMargin(12, 0, 0, 0)
				:SetPadding(4, 4, 8, 8)
				:SetBackgroundColor("PRIMARY_BG_ALT", true)
				:AddChild(UIElements.New("CommodityList", "items")
					:SetBackgroundColor("PRIMARY_BG_ALT")
					:SetData(subRow:GetResultRow())
					:SetMarketValueFunction(marketValueFunc)
					:SetAlertThreshold(TSM.db.global.shoppingOptions.buyoutConfirm and (CustomPrice.GetValue(TSM.db.global.shoppingOptions.buyoutAlertSource, itemString) or 0) or nil)
					:SelectQuantity(defaultQuantity)
					:SetScript("OnRowClick", private.CommodityOnRowClick)
				)
			)
		)
		:SetScript("OnHide", private.DialogOnHide)
	baseFrame:ShowDialogFrame(private.dialogFrame)
	private.prepareQuantity = nil
	private.Prepare(defaultQuantity)
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DialogOnHide()
	if private.future then
		private.future:Cancel()
		private.future = nil
	end
	private.baseFrame = nil
	private.dialogFrame = nil
	private.isBuy = nil
	private.auctionScan = nil
	private.subRow = nil
	private.index = nil
	private.noSeller = nil
end

function private.BuyoutConfirmCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.EnableFutureOnDone()
	local result = private.future:GetValue()
	private.future = nil
	if not result or result ~= (private.subRow:IsCommodity() and private.totalBuyout or select(2, private.subRow:GetBuyouts())) then
		-- the unit price changed
		Log.PrintUser(L["Failed to buy auction."])
		private.baseFrame:HideDialog()
		return
	end
	local input = private.dialogFrame:GetElement("content.left.quantity.input")
	private.prepareSuccess = tonumber(input:GetValue()) == private.prepareQuantity
	private.UpdateConfirmButton()
end

function private.GetUnitPriceMoneyStr(itemBuyout)
	local priceStr = Money.ToString(itemBuyout, nil, "OPT_83_NO_COPPER")
	local marketValueStr = nil
	local marketValue = private.marketValueFunc(private.subRow)
	local pct = marketValue and marketValue > 0 and itemBuyout > 0 and Math.Round(100 * itemBuyout / marketValue) or nil
	if pct then
		local pctColor = Theme.GetAuctionPercentColor(pct)
		if pct > 999 then
			marketValueStr = pctColor:ColorText(">999%")
		else
			marketValueStr = pctColor:ColorText(pct.."%")
		end
	else
		marketValueStr = "---"
	end
	return format("%s (%s)", priceStr, marketValueStr)
end

function private.CommodityResultsByQuantity(itemString, quantity)
	local remainingQuantity = quantity
	local totalPrice, maxPrice = 0, 0
	for _, query in private.auctionScan:QueryIterator() do
		for _, subRow in query:ItemSubRowIterator(itemString) do
			if remainingQuantity > 0 then
				local _, itemBuyout = subRow:GetBuyouts()
				local _, numOwnerItems = subRow:GetOwnerInfo()
				local quantityAvailable = subRow:GetQuantities() - numOwnerItems
				local quantityToBuy = min(quantityAvailable, remainingQuantity)
				totalPrice = totalPrice + (itemBuyout * quantityToBuy)
				remainingQuantity = remainingQuantity - quantityToBuy
				maxPrice = max(maxPrice, itemBuyout)
			end
		end
	end
	return totalPrice, maxPrice
end

function private.InputQtyOnValueChanged(input, noListUpdate)
	local quantity = tonumber(input:GetValue())
	input:SetValue(quantity)
	local totalBuyout = private.subRow:IsCommodity() and private.CommodityResultsByQuantity(private.subRow:GetItemString(), quantity) or input:GetElement("__parent.__parent.price.money"):GetContext() * quantity
	local totalQuantity = quantity
	local itemBuyout = totalQuantity > 0 and Math.Ceil(totalBuyout / totalQuantity, COPPER_PER_SILVER) or 0
	input:GetElement("__parent.__parent.price.money")
		:SetContext(itemBuyout)
		:SetText(private.GetUnitPriceMoneyStr(itemBuyout))
		:Draw()
	input:GetElement("__parent.__parent.total.money")
		:SetText(Money.ToString(totalBuyout, nil, "OPT_83_NO_COPPER"))
		:Draw()
	if not noListUpdate then
		input:GetElement("__parent.__parent.__parent.item.items")
			:SelectQuantity(quantity)
	end
	if quantity ~= private.prepareQuantity then
		private.prepareSuccess = false
		private.prepareQuantity = nil
	end
	private.UpdateConfirmButton()
end

function private.CommodityOnRowClick(list, index)
	local input = list:GetElement("__parent.__parent.left.quantity.input")
	input:SetValue(list:GetTotalQuantity(index))
		:Draw()
	private.Prepare(tonumber(input:GetValue()))
	private.InputQtyOnValueChanged(input, true)
end

function private.ConfirmBtnOnClick(button)
	local inputQuantity = nil
	if not TSM.IsWowClassic() and private.subRow:IsCommodity() then
		local input = private.dialogFrame:GetElement("content.left.quantity.input")
		inputQuantity = tonumber(input:GetValue())
		if not private.prepareSuccess and not TSM.IsWowClassic() then
			-- this is a prepare click
			private.Prepare(inputQuantity)
			return
		end
		assert(private.prepareQuantity == inputQuantity)
	end

	local isBuy = private.isBuy
	local callbackQuantity = button:GetContext()
	if callbackQuantity == nil then
		assert(inputQuantity)
		callbackQuantity = inputQuantity
	end
	local callback = button:GetElement("__parent.__parent.__parent"):GetContext()
	button:GetBaseElement():HideDialog()
	callback(isBuy, callbackQuantity)
end

function private.UpdateConfirmButton()
	local confirmBtn = private.dialogFrame:GetElement("content.left.confirmBtn")
	local text, disabled, requireManualClick = nil, false, false
	if not TSM.IsWowClassic() and private.subRow:IsCommodity() then
		local input = confirmBtn:GetElement("__parent.quantity.input")
		local inputQuantity = tonumber(input:GetValue())
		local minQuantity = 1
		local maxQuantity = confirmBtn:GetElement("__parent.quantity.input"):GetContext()
		local itemString = private.subRow:GetItemString()
		local totalCost, maxCost = private.CommodityResultsByQuantity(itemString, inputQuantity)
		local alertThreshold = TSM.db.global.shoppingOptions.buyoutConfirm and (CustomPrice.GetValue(TSM.db.global.shoppingOptions.buyoutAlertSource, itemString) or 0) or math.huge
		if maxCost >= alertThreshold then
			requireManualClick = true
			confirmBtn:GetElement("__parent.warning")
				:SetText(L["Contains auctions above your alert threshold!"])
				:Draw()
		else
			confirmBtn:GetElement("__parent.warning")
				:SetText("")
				:Draw()
		end

		if GetMoney() < totalCost then
			text = L["Not Enough Money"]
			disabled = true
		elseif totalCost <= 0 or inputQuantity < minQuantity or inputQuantity > maxQuantity then
			text = L["Invalid Quantity"]
			disabled = true
		elseif private.prepareSuccess or TSM.IsWowClassic() then
			text = L["Buy Commodity"]
			disabled = false
		elseif private.prepareQuantity then
			text = L["Preparing..."]
			disabled = true
		else
			text = private.isBuy and L["Prepare Buy"] or L["Prepare Bid"]
			disabled = false
		end
	else
		if GetMoney() < confirmBtn:GetElement("__parent.price.money"):GetContext() then
			text = L["Not Enough Money"]
			disabled = true
		else
			text = private.isBuy and L["Buy Auction"] or L["Bid Auction"]
			disabled = false
		end
	end
	confirmBtn:SetText(text)
		:SetDisabled(disabled)
		:SetRequireManualClick(requireManualClick)
		:Draw()
end

function private.Prepare(quantity)
	if quantity == private.prepareQuantity then
		return
	end
	if private.future then
		private.future:Cancel()
		private.future = nil
	end
	private.prepareQuantity = quantity
	private.prepareSuccess = false
	local totalBuyout = not TSM.IsWowClassic() and private.subRow:IsCommodity() and private.CommodityResultsByQuantity(private.subRow:GetItemString(), quantity) or (select(2, private.subRow:GetBuyouts()))
	local totalQuantity = quantity
	private.totalBuyout = totalBuyout
	local itemBuyout = totalQuantity > 0 and Math.Ceil(totalBuyout / totalQuantity, COPPER_PER_SILVER)
	local result, future = private.auctionScan:PrepareForBidOrBuyout(private.index, private.subRow, private.noSeller, quantity, itemBuyout)
	if not result then
		private.prepareQuantity = nil
		return
	elseif future then
		private.future = future
		future:SetScript("OnDone", private.EnableFutureOnDone)
	end
	private.UpdateConfirmButton()
end
