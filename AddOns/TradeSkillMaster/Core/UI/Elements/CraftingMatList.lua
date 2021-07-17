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
local ItemInfo = TSM.Include("Service.ItemInfo")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(CraftingMatList)
TSM.UI.CraftingMatList = CraftingMatList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CraftingMatList.__init(self)
	self.__super:__init()
	self._optionalMats = {}
	self._optionalIndexMap = {}
	self._spellId = nil
	self._level = nil
	self._rowHoverEnabled = false
end

function CraftingMatList.Acquire(self)
	wipe(self._optionalMats)
	wipe(self._optionalIndexMap)
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
	wipe(self._optionalMats)
	wipe(self._optionalIndexMap)
	self._spellId = nil
	self._level = nil
	self.__super:Release()
end

function CraftingMatList.SetScript(self, script, handler)
	error("Unknown CraftingMatList script: "..tostring(script))
	return self
end

--- Sets the crafting recipe to display additional optional materials.
-- @tparam CraftingMatList self The crafting mat list object
-- @tparam table optionalMats The optional material table
-- @treturn CraftingMatList The crafting mat list object
function CraftingMatList.SetOptionalMats(self, optionalMats)
	wipe(self._optionalMats)
	wipe(self._optionalIndexMap)
	if not optionalMats then
		self:_UpdateData()
		return self
	end
	for k, v in pairs(optionalMats) do
		self._optionalMats[k] = v
	end
	self:_UpdateData()
	return self
end

--- Sets the crafting recipe to display additional optional materials.
-- @tparam CraftingMatList self The crafting mat list object
-- @tparam number level The selected level of the recipe
-- @treturn CraftingMatList The crafting mat list object
function CraftingMatList.SetLevel(self, level)
	self._level = level
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
	for i = 1, TSM.Crafting.ProfessionUtil.GetNumMats(self._spellId, self._level) do
		tinsert(self._data, i)
	end
	for k, v in pairs(self._optionalMats) do
		if v then
			self._optionalIndexMap[#self._data + 1] = k
			tinsert(self._data, #self._data + 1)
		end
	end
end

function CraftingMatList._IsOptionalMaterial(self, index)
	return self._optionalIndexMap[index]
end

function CraftingMatList._GetOptionalMatString(self, index)
	return "i:"..self._optionalMats[self._optionalIndexMap[index]]
end


-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetCheck(self, index)
	local quantity, itemString, bagQuantity = nil, nil, nil
	if self:_IsOptionalMaterial(index) then
		itemString = self:_GetOptionalMatString(index)
		quantity = 1
		bagQuantity = Inventory.GetBagQuantity(itemString)
	else
		local itemLink, _ = nil, nil
		itemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index, self._level)
		itemString = ItemString.Get(itemLink)
		bagQuantity = Inventory.GetBagQuantity(itemString)
	end
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
	local texture = nil
	if self:_IsOptionalMaterial(index) then
		texture = ItemInfo.GetTexture(self:_GetOptionalMatString(index))
	else
		local _
		_, _, texture = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index, self._level)
	end
	return texture
end

function private.GetItemText(self, index)
	local itemString = nil
	if self:_IsOptionalMaterial(index) then
		itemString = self:_GetOptionalMatString(index)
	else
		local itemLink = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index, self._level)
		itemString = ItemString.Get(itemLink)
	end
	return TSM.UI.GetColoredItemName(itemString) or Theme.GetFeedbackColor("RED"):ColorText("?")
end

function private.GetItemTooltip(self, index)
	local itemLink = nil
	if self:_IsOptionalMaterial(index) then
		itemLink = self:_GetOptionalMatString(index)
	else
		itemLink = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index, self._level)
	end
	return ItemString.Get(itemLink)
end

function private.GetQty(self, index)
	local quantity, itemString, bagQuantity = nil, nil, nil
	if self:_IsOptionalMaterial(index) then
		itemString = self:_GetOptionalMatString(index)
		quantity = 1
		bagQuantity = Inventory.GetBagQuantity(itemString)
	else
		local itemLink, _ = nil, nil
		itemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(self._spellId, index, self._level)
		itemString = ItemString.Get(itemLink)
		bagQuantity = Inventory.GetBagQuantity(itemString)
	end
	if not TSM.IsWowClassic() then
		bagQuantity = bagQuantity + Inventory.GetReagentBankQuantity(itemString) + Inventory.GetBankQuantity(itemString)
	end
	local color = bagQuantity >= quantity and Theme.GetFeedbackColor("GREEN") or Theme.GetFeedbackColor("RED")
	return color:ColorText(format("%d / %d", bagQuantity, quantity))
end
