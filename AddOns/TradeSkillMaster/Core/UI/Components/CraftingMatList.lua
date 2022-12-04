-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Theme = TSM.Include("Util.Theme")
local TextureAtlas = TSM.Include("Util.TextureAtlas")
local UIElements = TSM.Include("UI.UIElements")
local Tooltip = TSM.Include("UI.Tooltip")
local ROW_HEIGHT = 20
local ICON_SIZE = 12
local ICON_SPACING = 4
local STATUS_CHECK_TEXTURE = "iconPack.12x12/Checkmark/Default"
local STATUS_X_TEXTURE = "iconPack.12x12/Close/Default"



-- ============================================================================
-- Element Definition
-- ============================================================================

local CraftingMatList = UIElements.Define("CraftingMatList", "List") ---@class CraftingMatList: List



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function CraftingMatList:__init()
	self.__super:__init()
	self._query = nil
	self._itemString = {}
	self._text = {}
	self._icon = {}
	self._quantity = {}
	self._playerQuantity = {}
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
	self.__super:Release()
	self._query:Release()
	self._query = nil
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

---Sets the query used to populate the list of materials.
---@param query DatabaseQuery The query to populate the list
---@return CraftingMatList
function CraftingMatList:SetQuery(query)
	assert(not self._query)
	self._query = query
	self:AddCancellable(query:Publisher()
		:CallMethod(self, "_HandleQueryUpdate")
	)
	return self
end

function CraftingMatList:SetScript(script)
	error("Unknown CraftingMatList script: "..tostring(script))
	return self
end



-- ============================================================================
-- Protected/Private Class Methods
-- ============================================================================

function CraftingMatList:_HandleQueryUpdate()
	wipe(self._itemString)
	wipe(self._text)
	wipe(self._icon)
	wipe(self._quantity)
	wipe(self._playerQuantity)

	for i, itemString, coloredItemName, texture, neededQuantity, playerQuantity in self._query:Iterator() do
		self._itemString[i] = itemString
		self._text[i] = coloredItemName
		self._icon[i] = texture
		self._quantity[i] = neededQuantity
		self._playerQuantity[i] = playerQuantity
	end

	self:_SetNumRows(#self._itemString)
	self:Draw()
	return self
end

function CraftingMatList.__protected:_HandleRowAcquired(row)
	row:DisableHighlight()

	-- Add the status texture
	local status = row:AddTexture("status")
	status:SetDrawLayer("ARTWORK", 1)
	TextureAtlas.SetTextureAndSize(status, STATUS_CHECK_TEXTURE)

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
	status:SetPoint("LEFT", Theme.GetColSpacing() / 2, 0)
	icon:SetPoint("LEFT", status, "RIGHT", ICON_SPACING, 0)
	item:SetPoint("LEFT", icon, "RIGHT", ICON_SPACING, 0)
	item:SetPoint("RIGHT", qty, "LEFT", -Theme.GetColSpacing() / 2, 0)
	qty:SetPoint("RIGHT", -Theme.GetColSpacing() / 2, 0)
end

function CraftingMatList.__protected:_HandleRowDraw(row)
	local dataIndex = row:GetDataIndex()
	self:_DrawRowItem(row, self._text[dataIndex], self._icon[dataIndex])
	self:_DrawRowQty(row, self._playerQuantity[dataIndex], self._quantity[dataIndex])
end

function CraftingMatList.__private:_DrawRowItem(row, text, icon)
	row:GetText("item"):SetText(text)
	row:GetTexture("icon"):SetTexture(icon)
end

function CraftingMatList.__private:_DrawRowQty(row, bagQuantity, quantity)
	local color = bagQuantity >= quantity and "FEEDBACK_GREEN" or "FEEDBACK_RED"
	local textureKey = TextureAtlas.GetColoredKey(bagQuantity >= quantity and STATUS_CHECK_TEXTURE or STATUS_X_TEXTURE, color)
	TextureAtlas.SetTexture(row:GetTexture("status"), textureKey)
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
	if mouseButton ~= "LeftButton" or (not IsShiftKeyDown() and not IsControlKeyDown()) then
		return
	end
	TSM.UI.HandleModifiedItemClick(self._itemString[row:GetDataIndex()])
end
