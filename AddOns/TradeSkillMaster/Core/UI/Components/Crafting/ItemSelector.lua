-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local MatString = TSM.Include("Util.MatString")
local SlotId = TSM.Include("Util.SlotId")
local Container = TSM.Include("Util.Container")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Rectangle = TSM.Include("UI.Rectangle")
local Tooltip = TSM.Include("UI.Tooltip")
local BagTracking = TSM.Include("Service.BagTracking")
local UIElements = TSM.Include("UI.UIElements")
local L = TSM.Include("Locale").GetTable()
local private = {}
local CORNER_RADIUS = 6



-- ============================================================================
-- Element Definition
-- ============================================================================

local ItemSelector = UIElements.Define("ItemSelector", "Button") ---@class ItemSelector: Button
ItemSelector:_ExtendStateSchema()
	:AddBooleanField("disabled", false)
	:AddBooleanField("mouseOver", false)
	:AddOptionalStringField("selection")
	:Commit()



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ItemSelector:__init(button)
	self.__super:__init(button)

	local frame = self:_GetBaseFrame()
	frame:TSMSetScript("OnMouseUp", self:__closure("_HandleClick"))
	frame:TSMSetScript("OnEnter", self:__closure("_HandleFrameEnter"))
	frame:TSMSetScript("OnLeave", self:__closure("_HandleFrameLeave"))

	self._background = Rectangle.New(frame)
	self._background:SetCornerRadius(CORNER_RADIUS)
	self._backgroundOverlay = Rectangle.New(frame, 1)
	self._backgroundOverlay:SetCornerRadius(CORNER_RADIUS)
	self._backgroundOverlay:SetInset(2)
	self._backgroundOverlay:SetColor("PRIMARY_BG_ALT")

	self._quality = UIElements.CreateFontString(self, frame)
	self._quality:SetSize(32, 32)
	self._quality:TSMSetFont("BODY_BODY1")
	self._quality:SetPoint("TOPLEFT", -2, 10)
	self._quality:SetJustifyH("LEFT")

	self._quantity = UIElements.CreateFontString(self, frame)
	self._quantity:SetHeight(16)
	self._quantity:TSMSetFont("TABLE_TABLE1_OUTLINE")
	self._quantity:SetPoint("BOTTOMLEFT", 1, 1)
	self._quantity:SetPoint("BOTTOMRIGHT", -1, 1)
	self._quantity:SetJustifyH("RIGHT")

	self._addIcon = UIElements.CreateTexture(self, frame, "ARTWORK")
	self._addIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	self._addIcon:TSMSetTextureAndSize("iconPack.14x14/Add/Default")

	self._items = {}
	self._selectionSlotId = nil
	self._requiredQty = nil
	self._onSelectionChanged = nil
end

function ItemSelector:Acquire()
	self.__super:Acquire()

	self:EnableRightClick()

	-- Set our own state
	self._state:PublisherForKeyChange("selection")
		:Share(2)
		:CallMethod(self, "SetTooltip")
		:CallMethod(self, "SetBackgroundWithItemHighlight")

	-- Set the background state
	self._state:Publisher()
		:IgnoreDuplicatesWithKeys("disabled", "mouseOver")
		:MapWithFunction(private.StateToBackgroundColorKey)
		:IgnoreDuplicates()
		:CallMethod(self._background, "SubscribeColor")

	self._state:PublisherForKeyChange("selection")
		:MapBooleanEquals(nil)
		:Share(3)
		:CallMethod(self._background, "SetShown")
		:CallMethod(self._backgroundOverlay, "SetShown")
		:CallMethod(self._addIcon, "SetShown")

	-- Set the quality state
	self._state:PublisherForKeyChange("selection")
		:MapWithFunction(private.SelectionToQualityText)
		:CallMethod(self._quality, "SetText")
end

function ItemSelector:Release()
	self.__super:Release()

	self._background:CancelAll()
	self._backgroundOverlay:CancelAll()

	wipe(self._items)
	self._selectionSlotId = nil
	self._requiredQty = nil
	self._onSelectionChanged = nil
end

---Sets the selectable items that can be picked.
---@param items string[] The indexed table that contains the possible selections
---@return ItemSelector
function ItemSelector:SetItems(items)
	wipe(self._items)
	self:SetDisabled(not next(items))
	for _, itemString in ipairs(items) do
		tinsert(self._items, itemString)
	end
	return self
end

---Sets the list of items from a mat string.
---@param matString string The mat string
---@param requiredQuantity? number The required stack size for this mat
---@return ItemSelector
function ItemSelector:SetMatString(matString, requiredQty)
	wipe(self._items)
	self._requiredQty = requiredQty
	if matString then
		for itemString in MatString.ItemIterator(matString) do
			if not requiredQty or private.GetBagSlotId(itemString, requiredQty) then
				tinsert(self._items, itemString)
			end
		end
	end
	self:SetDisabled(not next(self._items))
	self:SetSelection(self._state.selection, true)
	return self
end

---Get the currently selected item.
---@return The selected item
function ItemSelector:GetSelection()
	return self._state.selection
end

---Get the next targetable salvage slot id
---@return ItemLocation
function ItemSelector:GetNextSalvageSlotId()
	if not self._state.selection then
		return nil
	end
	return self:IsSelectionSlotValid() and self._selectionSlotId or private.GetBagSlotId(self._state.selection, self._requiredQty)
end

---Sets the current selection of the ItemSelector.
---@param selection? string The item to select or nil to clear the selection
---@return ItemSelector
function ItemSelector:SetSelection(selection, silent)
	self._state.selection = selection
	local slotId = self:IsSelectionSlotValid() and self._selectionSlotId or private.GetBagSlotId(self._state.selection, self._requiredQty)
	self._selectionSlotId = slotId
	self._quantity:SetText(slotId and BagTracking.GetQuantityBySlotId(slotId) or "")
	if not silent and self._onSelectionChanged then
		self:_onSelectionChanged(selection)
	end
	return self
end

---Set whether or not the item selector is disabled.
---@param disabled boolean Whether or not the item selector should be disabled
---@return ItemSelector
function ItemSelector:SetDisabled(disabled)
	self._state.disabled = disabled and true or false
	return self
end

---Registers a script handler.
---@param script "OnSelectionChanged"
---@param handler fun(itemSelector: ItemSelector, ...: any) The handler
---@return ItemSelector
function ItemSelector:SetScript(script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChanged = handler
	else
		self.__super:SetScript(script, handler)
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ItemSelector.__private:_HandleClick(_, mouseButton)
	if not self._acquired or self._state.disabled then
		return
	end

	if mouseButton == "RightButton" then
		self:SetSelection(nil)
		Tooltip.Hide()
		return
	end

	self._opened = not self._opened
	if not self._opened then
		return
	end

	self:GetBaseElement():ShowDialogFrame(UIElements.New("Frame", "frame")
		:SetSize(130, 168)
		:SetLayout("VERTICAL")
		:SetPadding(2)
		:AddAnchor("TOPLEFT", self:_GetBaseFrame(), "TOPRIGHT", 4, 0)
		:SetRoundedBackgroundColor("FRAME_BG")
		:SetMouseEnabled(true)
		:SetScript("OnHide", self:__closure("_HandleFrameOnHide"))
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetStrata("HIGH")
			:SetRoundedBackgroundColor("ACTIVE_BG")
			:AddChild(UIElements.New("Text", "title")
				:SetMargin(18, 8, -4, 0)
				:SetFont("BODY_BODY3")
				:SetJustifyH("CENTER")
				:SetText(L["Item Selection"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, 2, -4, 0)
				:SetBackgroundAndSize("iconPack.14x14/Close/Default")
				:SetScript("OnClick", self:__closure("_HandleFrameOnHide"))
			)
		)
		:AddChild(UIElements.New("Frame", "scroll")
			:SetLayout("HORIZONTAL")
			:SetMargin(0, 0, -4, 0)
			:SetStrata("DIALOG")
			:SetHeight(144)
			:SetBackgroundColor("FRAME_BG")
			:AddChild(UIElements.New("ScrollFrame", "scroll")
				:SetPadding(12, 8, 4, 4)
				:AddChild(UIElements.New("Frame", "items")
					:SetLayout("FLOW")
					:AddChildrenWithFunction(self:__closure("_CreateItems"))
				)
			)
		)
	)
end

function ItemSelector.__private:_HandleFrameOnHide()
	self._opened = false
	self:GetBaseElement():HideDialog()
end

function ItemSelector.__private:_HandleFrameEnter()
	self._state.mouseOver = true
end

function ItemSelector.__private:_HandleFrameLeave()
	self._state.mouseOver = false
end

function ItemSelector.__private:_HandleButtonOnClick(button)
	self:SetSelection(button:GetContext())
	self:GetBaseElement():HideDialog()
end

function ItemSelector.__private:_CreateItems(frame)
	for _, itemString in ipairs(self._items) do
		local craftQuality = ItemInfo.GetCraftedQuality(itemString)
		frame:AddChild(UIElements.New("Frame", "content")
			:SetLayout("HORIZONTAL")
			:AddChild(UIElements.New("Button", itemString.."Icon")
				:SetSize(30, 30)
				:SetPadding(0, 0, 0, 0)
				:SetMargin(2, 2, 2, 2)
				:SetContext(itemString)
				:SetBackgroundWithItemHighlight(itemString)
				:SetTooltip(itemString)
				:SetScript("OnClick", self:__closure("_HandleButtonOnClick"))
			)
			:AddChildNoLayout(UIElements.New("Text", itemString.."Quality")
				:SetSize(30, 30)
				:AddAnchor("TOPLEFT", 0, 8)
				:SetShown(craftQuality and true or false)
				:SetText(craftQuality and Professions.GetChatIconMarkupForQuality(craftQuality, true) or "")
			)
		)
	end
end

function ItemSelector.__private:IsSelectionSlotValid()
	if not self._state.selection or not self._selectionSlotId then
		return false
	end
	local bag, slot = SlotId.Split(self._selectionSlotId)
	if self._state.selection ~= ItemString.Get(Container.GetItemId(bag, slot)) then
		return false
	end
	local selectionQuantity = BagTracking.GetQuantityBySlotId(self._selectionSlotId)
	local salvageItemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
	return pcall(C_Item.DoesItemExist, salvageItemLocation) and self._requiredQty and selectionQuantity and selectionQuantity >= self._requiredQty
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.StateToBackgroundColorKey(state)
	if state.disabled then
		return "ACTIVE_BG"
	else
		if state.mouseOver then
			return "TEXT_ALT+HOVER"
		else
			return "TEXT_ALT"
		end
	end
end

function private.SelectionToQualityText(selection)
	local itemQuality = selection and ItemInfo.GetCraftedQuality(selection)
	if not itemQuality then
		return ""
	end
	return Professions.GetChatIconMarkupForQuality(itemQuality, true)
end

function private.GetBagSlotId(itemString, requiredQuantity)
	if not itemString or not requiredQuantity then
		return nil
	end
	return BagTracking.CreateQueryBagsBank()
		:Select("slotId")
		:GreaterThanOrEqual("quantity", requiredQuantity)
		:Equal("itemString", itemString)
		:OrderBy("quantity", false)
		:GetFirstResultAndRelease()
end
