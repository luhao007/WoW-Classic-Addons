-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Theme = TSM.Include("Util.Theme")
local MatString = TSM.Include("Util.MatString")
local ItemString = TSM.Include("Util.ItemString")
local RecipeString = TSM.Include("Util.RecipeString")
local CraftString = TSM.Include("Util.CraftString")
local BagTracking = TSM.Include("Service.BagTracking")
local Profession = TSM.Include("Service.Profession")
local ItemInfo = TSM.Include("Service.ItemInfo")
local UIElements = TSM.Include("UI.UIElements")
local Tooltip = TSM.Include("UI.Tooltip")
local UIUtils = TSM.Include("UI.UIUtils")
local L = TSM.Include("Locale").GetTable()
local private = {
	optionalMatTemp = {},
}
local ROW_HEIGHT = 20
local ICON_SIZE = 12
local ICON_SPACING = 4



-- ============================================================================
-- Element Definition
-- ============================================================================

local CraftingMatList = UIElements.Define("CraftingMatList", "List") ---@class CraftingMatList: List



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function CraftingMatList:__init()
	self.__super:__init()
	BagTracking.RegisterQuantityCallback(self:__closure("_HandleBagUpdate"))
	self._recipeString = nil
	self._onMatQualityChanged = nil
	self._itemString = {}
	self._text = {}
	self._icon = {}
	self._quantity = {}
	self._playerQuantity = {}
	self._isQualityMat = {}
	self._matString = {}
end

function CraftingMatList:Acquire()
	self.__super:Acquire(ROW_HEIGHT)
end

function CraftingMatList:Release()
	wipe(self._itemString)
	wipe(self._text)
	wipe(self._icon)
	wipe(self._quantity)
	wipe(self._playerQuantity)
	wipe(self._isQualityMat)
	wipe(self._matString)
	self._recipeString = nil
	self._onMatQualityChanged = nil
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CraftingMatList:SetRecipeString(recipeString)
	wipe(self._itemString)
	wipe(self._text)
	wipe(self._icon)
	wipe(self._quantity)
	wipe(self._playerQuantity)
	wipe(self._isQualityMat)
	wipe(self._matString)

	if recipeString then
		local craftString = CraftString.FromRecipeString(recipeString)
		assert(not next(private.optionalMatTemp))
		for _, matString, quantity in Profession.MatIterator(craftString) do
			local matType = MatString.GetType(matString)
			if matType == MatString.TYPE.NORMAL then
				self:_AddMaterial(matString, quantity, matString)
			elseif matType == MatString.TYPE.QUALITY then
				local itemString = "i:"..RecipeString.GetOptionalMat(recipeString, MatString.GetSlotId(matString))
				self:_AddMaterial(itemString, quantity, matString)
			else
				local slotId = MatString.GetSlotId(matString)
				if RecipeString.GetOptionalMat(recipeString, slotId) then
					tinsert(private.optionalMatTemp, slotId)
					private.optionalMatTemp["_"..slotId] = matString
				end
			end
		end
		sort(private.optionalMatTemp)
		for _, slotId in ipairs(private.optionalMatTemp) do
			local matString = private.optionalMatTemp["_"..slotId]
			local itemId = RecipeString.GetOptionalMat(recipeString, slotId)
			local itemString = "i:"..itemId
			self:_AddMaterial(itemString, Profession.GetMatQuantity(craftString, itemId), matString)
		end
		wipe(private.optionalMatTemp)
	end
	self._recipeString = recipeString

	self:_SetNumRows(#self._itemString)
	self:Draw()
end

---Registers a script handler.
---@param script "OnMatQualityChanged"
---@param handler fun(craftingMatList: CraftingMatList, ...: any) The handler
---@return CraftingMatList
function CraftingMatList:SetScript(script, handler)
	if script == "OnMatQualityChanged" then
		self._onMatQualityChanged = handler
	else
		error("Invalid script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Protected/Private Class Methods
-- ============================================================================

function CraftingMatList.__private:_HandleBagUpdate(itemsChanged)
	for i, itemString in ipairs(self._itemString) do
		if itemsChanged[itemString] then
			self._playerQuantity[i] = BagTracking.GetCraftingMatQuantity(itemString)
			local row = self:_GetRow(i)
			if row then
				self:_DrawRowQty(row, self._playerQuantity[i], self._quantity[i])
			end
		end
	end
end

function CraftingMatList.__private:_AddMaterial(itemString, quantity, matString)
	tinsert(self._itemString, itemString)
	tinsert(self._text, UIUtils.GetDisplayItemName(itemString) or Theme.GetColor("FEEDBACK_RED"):ColorText("?"))
	tinsert(self._icon, ItemInfo.GetTexture(itemString) or ItemInfo.GetTexture(ItemString.GetUnknown()))
	tinsert(self._quantity, quantity)
	tinsert(self._playerQuantity, BagTracking.GetCraftingMatQuantity(itemString))
	local matType = MatString.GetType(matString)
	tinsert(self._isQualityMat, matType == MatString.TYPE.QUALITY or matType == MatString.TYPE.REQUIRED)
	tinsert(self._matString, matString)
end

function CraftingMatList.__protected:_HandleRowAcquired(row)
	-- Add the icon
	local icon = row:AddTexture("icon")
	icon:SetDrawLayer("ARTWORK", 1)
	icon:SetWidth(ICON_SIZE)
	icon:SetHeight(ICON_SIZE)

	-- Add the item text
	local item = row:AddText("item")
	item:SetHeight(ROW_HEIGHT)
	item:SetFont(Theme.GetFont("ITEM_BODY3"):GetWowFont())
	item:SetJustifyH("LEFT")

	-- Add the quantity text
	local qty = row:AddText("qty")
	qty:SetHeight(ROW_HEIGHT)
	qty:SetFont(Theme.GetFont("TABLE_TABLE1"):GetWowFont())
	qty:SetJustifyH("RIGHT")

	-- Layout the elements
	icon:SetPoint("LEFT", Theme.GetColSpacing() / 2, 0)
	item:SetPoint("LEFT", icon, "RIGHT", ICON_SPACING, 0)
	item:SetPoint("RIGHT", qty, "LEFT", -Theme.GetColSpacing() / 2, 0)
	qty:SetPoint("RIGHT", -Theme.GetColSpacing() / 2, 0)
end

function CraftingMatList.__protected:_HandleRowDraw(row)
	local dataIndex = row:GetDataIndex()
	row:SetHighlightEnabled(self._isQualityMat[dataIndex])
	self:_DrawRowItem(row, self._text[dataIndex], self._icon[dataIndex])
	self:_DrawRowQty(row, self._playerQuantity[dataIndex], self._quantity[dataIndex])
end

function CraftingMatList.__private:_DrawRowItem(row, text, icon)
	row:GetText("item"):SetText(text)
	row:GetTexture("icon"):SetTexture(icon)
end

function CraftingMatList.__private:_DrawRowQty(row, bagQuantity, quantity)
	local color = bagQuantity >= quantity and "FEEDBACK_GREEN" or "FEEDBACK_RED"
	local qty = row:GetText("qty")
	qty:SetText(Theme.GetColor(color):ColorText(format("%d / %d", bagQuantity, quantity)))
	-- Adjust the width of the qty text to fit the text string
	qty:SetWidth(10000)
	qty:SetWidth(qty:GetStringWidth())
end

function CraftingMatList.__protected:_HandleRowEnter(row)
	local itemString = self._itemString[row:GetDataIndex()]
	if not itemString then
		return
	end
	row:ShowTooltip(itemString)
end

function CraftingMatList.__protected:_HandleRowLeave(row)
	-- The data might not exist anymore, so just hide the tooltip to be safe
	Tooltip.Hide()
end

function CraftingMatList.__protected:_HandleRowClick(row, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	elseif IsShiftKeyDown() or IsControlKeyDown() then
		UIUtils.HandleModifiedItemClick(self._itemString[row:GetDataIndex()])
	elseif self._isQualityMat[row:GetDataIndex()] then
		self:_ShowQualityDialog(row:GetDataIndex())
	end
end

function CraftingMatList.__protected:_ShowQualityDialog(dataIndex)
	local matString = self._matString[dataIndex]
	local itemString = self._itemString[dataIndex]
	self:GetBaseElement():ShowDialogFrame(UIElements.New("Frame", "frame")
		:SetSize(180, 84)
		:AddAnchor("CENTER", self:_GetBaseFrame())
		:SetLayout("VERTICAL")
		:SetRoundedBackgroundColor("PRIMARY_BG_ALT")
		:SetBorderColor("ACTIVE_BG")
		:SetMouseEnabled(true)
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(20)
			:SetRoundedBackgroundColor("ACTIVE_BG")
			:SetPadding(4, 4, 0, 0)
			:AddChild(UIElements.New("Text", "title")
				:SetMargin(18, 4, 0, 0)
				:SetFont("BODY_BODY3")
				:SetJustifyH("CENTER")
				:SetText(L["Reagent Quality"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetBackgroundAndSize("iconPack.14x14/Close/Default")
				:SetScript("OnClick", self:__closure("_CloseDialog"))
			)
		)
		:AddChild(UIElements.New("HorizontalLine", "line")
			:SetHeight(2)
			:SetMargin(0, 0, -2, 0)
		)
		:AddChild(UIElements.New("Frame", "content")
			:SetLayout("HORIZONTAL")
			:SetMargin(0, 0, 16, 8)
			:SetHeight(40)
			:SetContext(matString)
			:AddChild(UIElements.New("Spacer", "spacer1"))
			:AddChildrenWithFunction(self:__closure("_GetQualityDialogOptions"), matString, itemString)
			:AddChild(UIElements.New("Spacer", "spacer2"))
		)
	)
end

function CraftingMatList.__private:_GetQualityDialogOptions(frame, matString, selectedItemString)
	for itemString in MatString.ItemIterator(matString) do
		frame:AddChild(UIElements.New("ItemButton", "itemButton_"..itemString)
			:SetSize(40, 40)
			:SetMargin(8, 8, 0, 0)
			:SetContext(itemString)
			:SetItem(itemString)
			:SetSelected(itemString == selectedItemString)
			:SetScript("OnClick", self:__closure("_HandleQualityDialogOptionClick"))
		)
	end
end

function CraftingMatList.__private:_HandleQualityDialogOptionClick(button)
	local itemString = button:GetContext()
	local matString = button:GetParentElement():GetContext()
	self:_CloseDialog()

	assert(not next(private.optionalMatTemp))
	RecipeString.GetOptionalMats(self._recipeString, private.optionalMatTemp)
	private.optionalMatTemp[MatString.GetSlotId(matString)] = ItemString.ToId(itemString)
	local newRecipeString = RecipeString.SetOptionalMats(self._recipeString, private.optionalMatTemp)
	wipe(private.optionalMatTemp)
	self:_onMatQualityChanged(newRecipeString)
end

function CraftingMatList.__private:_CloseDialog()
	self:GetBaseElement():HideDialog()
end
