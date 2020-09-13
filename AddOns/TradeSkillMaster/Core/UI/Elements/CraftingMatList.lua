-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Crafting Mat List UI Element Class.
-- The element used to show the mats for a specific craft in the Crafting UI. It is a subclass of the @{ScrollingTable} class.
-- @classmod CraftingMatList

local _, TSM = ...
local CraftingMatList = TSM.Include("LibTSMClass").DefineClass("CraftingMatList", TSM.UI.ScrollingTable)
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local Inventory = TSM.Include("Service.Inventory")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(CraftingMatList)
TSM.UI.CraftingMatList = CraftingMatList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CraftingMatList.__init(self)
	self.__super:__init()
	self._spellId = nil
	self._rowHoverEnabled = false
end

function CraftingMatList.Acquire(self)
	self._headerHidden = true
	self.__super:Acquire()
	self:SetSelectionDisabled(true)
	self:GetScrollingTableInfo()
		:NewColumn("check")
			:SetWidth(14)
			:SetIconSize(14)
			:SetIconFunction(private.GetCheck)
			:Commit()
		:NewColumn("item")
			:SetFont("ITEM_BODY3")
			:SetJustifyH("LEFT")
			:SetIconSize(12)
			:SetIconFunction(private.GetItemIcon)
			:SetTextFunction(private.GetItemText)
			:SetTooltipFunction(private.GetItemTooltip)
			:Commit()
		:NewColumn("qty")
			:SetAutoWidth()
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("CENTER")
			:SetTextFunction(private.GetQty)
			:Commit()
		:Commit()
end

function CraftingMatList.Release(self)
	self._spellId = nil
	self.__super:Release()
end

function CraftingMatList.SetScript(self, script, handler)
	error("Unknown CraftingMatList script: "..tostring(script))
	return self
end

--- Sets the crafting recipe to display materials for.
-- @tparam CraftingMatList self The crafting mat list object
-- @tparam number spellId The spellId for the recipe
-- @treturn CraftingMatList The crafting mat list object
function CraftingMatList.SetRecipe(self, spellId)
	self._spellId = spellId
	self:_UpdateData()
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function CraftingMatList._UpdateData(self)
	wipe(self._data)
	if not self._spellId then
		return
	end
	for i = 1, TSM.Crafting.ProfessionUtil.GetNumMats(self._spellId) do
		tinsert(self._data, i)
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetCheck(self, index)
	local itemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index)
	local itemString = ItemString.Get(itemLink)
	local bagQuantity = Inventory.GetBagQuantity(itemString)
	if not TSM.IsWowClassic() then
		bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
	end
	if bagQuantity >= quantity then
		return TSM.UI.TexturePacks.GetColoredKey("iconPack.14x14/Checkmark/Default", Theme.GetFeedbackColor("GREEN"))
	else
		return TSM.UI.TexturePacks.GetColoredKey("iconPack.14x14/Close/Default", Theme.GetFeedbackColor("RED"))
	end
end

function private.GetItemIcon(self, index)
	local _, _, texture = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index)
	return texture
end

function private.GetItemText(self, index)
	local itemLink = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index)
	local itemString = ItemString.Get(itemLink)
	return TSM.UI.GetColoredItemName(itemString) or Theme.GetFeedbackColor("RED"):ColorText("?")
end

function private.GetItemTooltip(self, index)
	local itemLink = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index)
	return ItemString.Get(itemLink)
end

function private.GetQty(self, index)
	local itemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index)
	local itemString = ItemString.Get(itemLink)
	local bagQuantity = Inventory.GetBagQuantity(itemString)
	if not TSM.IsWowClassic() then
		bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
	end
	local color = bagQuantity >= quantity and Theme.GetFeedbackColor("GREEN") or Theme.GetFeedbackColor("RED")
	return color:ColorText(format("%d / %d", bagQuantity, quantity))
end
