-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local UIElements = TSM.Include("UI.UIElements")
local Rectangle = TSM.Include("UI.Rectangle")
local ItemInfo = TSM.Include("Service.ItemInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local private = {}
local CORNER_RADIUS = 2
local HIGHLIGHT_TEXTURE = 130718



-- ============================================================================
-- Element Definition
-- ============================================================================

---@class ItemButton: Element
---@field __private ItemButton
local ItemButton = UIElements.Define("ItemButton", "Element")
ItemButton:_ExtendStateSchema()
	:AddOptionalStringField("itemString")
	:AddBooleanField("selected", false)
	:Commit()



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ItemButton:__init()
	local frame = UIElements.CreateFrame(self, "Button")
	self.__super:__init(frame)

	BagTracking.RegisterQuantityCallback(self:__closure("_HandleBagUpdate"))

	self._highlight = UIElements.CreateTexture(self, frame, "HIGHLIGHT")
	self._highlight:SetAllPoints()
	self._highlight:TSMSetTextureAndCoord(HIGHLIGHT_TEXTURE)
	frame:SetHighlightTexture(self._highlight)

	self._background = Rectangle.New(frame)
	self._background:SetCornerRadius(CORNER_RADIUS)
	self._background:SetColor("INDICATOR")

	self._icon = UIElements.CreateTexture(self, frame, "ARTWORK")
	self._icon:SetPoint("TOPLEFT", frame, 1, -1)
	self._icon:SetPoint("BOTTOMRIGHT", frame, -1, 1)
	self._icon:TSMSubscribeColorTexture("INDICATOR_ALT")

	self._quality = UIElements.CreateFontString(self, frame)
	self._quality:SetSize(20, 20)
	self._quality:TSMSetFont("BODY_BODY2")
	self._quality:SetPoint("TOPLEFT", -2, 2)
	self._quality:SetJustifyH("LEFT")

	self._quantity = UIElements.CreateFontString(self, frame)
	self._quantity:SetHeight(16)
	self._quantity:TSMSetFont("TABLE_TABLE1_OUTLINE")
	self._quantity:SetPoint("BOTTOMLEFT", 1, 1)
	self._quantity:SetPoint("BOTTOMRIGHT", -1, 1)
	self._quantity:SetJustifyH("RIGHT")
end

function ItemButton:Acquire()
	self.__super:Acquire()

	-- Set the background state
	self._state:PublisherForKeyChange("selected")
		:CallMethod(self._background, "SetShown")

	-- Set the icon texture
	self._state:PublisherForKeyChange("itemString")
		:MapWithFunction(ItemInfo.GetTexture)
		:CallMethod(self._icon, "TSMSetTextureAndCoord")

	-- Set the quality state
	self._state:PublisherForKeyChange("itemString")
		:IgnoreNil()
		:MapWithFunction(ItemInfo.GetCraftedQuality)
		:MapWithFunction(private.CraftedQualityToTexture)
		:CallMethod(self._quality, "SetText")

	-- Set the quantity state
	self._state:PublisherForKeyChange("itemString")
		:IgnoreNil()
		:MapWithFunction(BagTracking.GetBagQuantity)
		:CallMethod(self._quantity, "SetText")
end

---Sets the item displayed by the button.
---@param items string The item to display
---@return ItemButton
function ItemButton:SetItem(itemString)
	self._state.itemString = itemString
	self:SetTooltip(itemString)
	return self
end

---Sets whether or not the button is selected.
---@param selected boolean The selected state
---@return ItemButton
function ItemButton:SetSelected(selected)
	self._state.selected = selected
	return self
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function ItemButton.__private:_HandleBagUpdate(itemsChanged)
	local itemString = self._acquired and self._state.itemString
	if not itemString or not itemsChanged[self._state.itemString] then
		return
	end
	self._quantity:SetText(BagTracking.GetBagQuantity(itemString))
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CraftedQualityToTexture(itemQuality)
	if not itemQuality or itemQuality <= 0 then
		return ""
	end
	return Professions.GetChatIconMarkupForQuality(itemQuality, true)
end
