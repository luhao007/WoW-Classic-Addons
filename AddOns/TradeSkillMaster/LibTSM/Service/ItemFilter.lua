-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ItemFilter = TSM.Init("Service.ItemFilter")
local LibTSMClass = TSM.Include("LibTSMClass")
local L = TSM.Include("Locale").GetTable()
local Filter = LibTSMClass.DefineClass("ItemFilter")
local ItemClass = TSM.Include("Data.ItemClass")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Vararg = TSM.Include("Util.Vararg")
local Log = TSM.Include("Util.Log")
local ItemInfo = TSM.Include("Service.ItemInfo")



-- ============================================================================
-- Module Functions
-- ============================================================================

function ItemFilter.New()
	return Filter()
end



-- ============================================================================
-- Filter Class
-- ============================================================================

function Filter.__init(self)
	self._isValid = nil
	self._str = nil
	self._escapedStr = nil
	self._class = nil
	self._subClass = nil
	self._invSlotId = nil
	self._minQuality = nil
	self._maxQuality = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._maxQuantity = nil
	self._uncollected = nil
	self._usable = nil
	self._upgrades = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exactOnly = nil
	self._crafting = nil
	self._disenchant = nil
	self._item = nil

	self:_Reset()
end

function Filter._Reset(self)
	self._isValid = nil
	self._str = ""
	self._escapedStr = ""
	self._class = nil
	self._subClass = nil
	self._invSlotId = nil
	self._minQuality = -math.huge
	self._maxQuality = math.huge
	self._minLevel = 0
	self._maxLevel = math.huge
	self._minItemLevel = 0
	self._maxItemLevel = math.huge
	self._minPrice = 0
	self._maxPrice = math.huge
	self._maxQuantity = math.huge
	self._uncollected = nil
	self._usable = nil
	self._upgrades = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exactOnly = nil
	self._crafting = nil
	self._disenchant = nil
	self._item = nil
end

function Filter._ItemQualityToIndex(self, str)
	for i = 0, 7 do
		local text = _G["ITEM_QUALITY"..i.."_DESC"]
		if strlower(str) == strlower(text) then
			return i
		end
	end
end

function Filter.ParseStr(self, str)
	self:_Reset()
	local errMsg = nil
	local numLevelParts, numItemLevelParts, numPriceParts, numQualityParts = 0, 0, 0, 0
	self._isValid = nil
	local hasNonCraftingPart = false
	for i, part in Vararg.Iterator(strsplit("/", strtrim(str))) do
		part = strtrim(part)
		if self._isValid ~= nil then
			-- already done iterating, but can't break / return out of a VarargIterator
			if strmatch(part, "^[ip]:[0-9]+") then
				-- request item info in case we failed due to not having it (for next time)
				ItemInfo.FetchInfo(part)
			end
		elseif i == 1 then
			-- first part must be a filter string or an item
			if strmatch(part, "^[ip]:[0-9]+") then
				local name = ItemInfo.GetName(part)
				local level = ItemInfo.GetMinLevel(part)
				local quality = ItemInfo.GetQuality(part)
				if not name or not level or not quality then
					errMsg = L["The specified item was not found."]
					self._isValid = false
				else
					self._exactOnly = true
					self._item = part
					self._str = strlower(name)
					self._escapedStr = String.Escape(self._str)
					self._minQuality = quality
					self._maxQuality = quality
					self._minLevel = level
					self._maxLevel = level
					self._class = ItemInfo.GetClassId(self._item) or 0
					self._subClass = ItemInfo.GetSubClassId(self._item) or 0
				end
			else
				self._str = strlower(part)
				self._escapedStr = String.Escape(self._str)
			end
		elseif part == "" then
			-- ignore an empty part
		elseif tonumber(part) then
			if numLevelParts == 0 then
				self._minLevel = tonumber(part)
			elseif numLevelParts == 1 then
				self._maxLevel = tonumber(part)
			else
				-- already have min / max level
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			numLevelParts = numLevelParts + 1
			hasNonCraftingPart = true
		elseif tonumber(strmatch(part, "^i(%d+)$")) then
			if numItemLevelParts == 0 then
				self._minItemLevel = tonumber(strmatch(part, "^i(%d+)$"))
			elseif numItemLevelParts == 1 then
				self._maxItemLevel = tonumber(strmatch(part, "^i(%d+)$"))
			else
				-- already have min / max item level
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			numItemLevelParts = numItemLevelParts + 1
			hasNonCraftingPart = true
		elseif ItemClass.GetClassIdFromClassString(part) then
			self._class = ItemClass.GetClassIdFromClassString(part)
			hasNonCraftingPart = true
		elseif self._class and ItemClass.GetSubClassIdFromSubClassString(part, self._class) then
			self._subClass = ItemClass.GetSubClassIdFromSubClassString(part, self._class)
			hasNonCraftingPart = true
		elseif ItemClass.GetInventorySlotIdFromInventorySlotString(part) then
			self._invSlotId = ItemClass.GetInventorySlotIdFromInventorySlotString(part)
			hasNonCraftingPart = true
		elseif self:_ItemQualityToIndex(part) then
			if numQualityParts == 0 then
				self._minQuality = self:_ItemQualityToIndex(part)
			elseif numQualityParts == 1 then
				self._maxQuality = self:_ItemQualityToIndex(part)
			else
				-- already have min / max quality
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			numQualityParts = numQualityParts + 1
			hasNonCraftingPart = true
		elseif Money.FromString(part) then
			if numPriceParts == 0 then
				self._maxPrice = Money.FromString(part)
			elseif numPriceParts == 1 then
				self._minPrice = self._maxPrice
				self._maxPrice = Money.FromString(part)
			else
				-- already have min / max price
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			numPriceParts = numPriceParts + 1
			hasNonCraftingPart = true
		elseif not TSM.IsWowClassic() and strlower(part) == "uncollected" then
			if self._uncollected then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._uncollected = true
			hasNonCraftingPart = true
		elseif strlower(part) == "usable" then
			if self._usable then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._usable = true
			hasNonCraftingPart = true
		elseif not TSM.IsWowClassic() and strlower(part) == "upgrades" then
			if self._upgrades then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._upgrades = true
			hasNonCraftingPart = true
		elseif strlower(part) == "unlearned" then
			if self._unlearned then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			if CanIMogIt and CanIMogIt.PlayerKnowsTransmog then
				self._unlearned = true
			else
				Log.PrintUser(L["The unlearned filter was ignored because the CanIMogIt addon was not found."])
			end
			hasNonCraftingPart = true
		elseif strlower(part) == "canlearn" then
			if self._canlearn then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			if CanIMogIt and CanIMogIt.CharacterCanLearnTransmog then
				self._canlearn = true
			else
				Log.PrintUser(L["The canlearn filter was ignored because the CanIMogIt addon was not found."])
			end
			hasNonCraftingPart = true
		elseif strlower(part) == "exact" then
			if self._exactOnly then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._exactOnly = true
			hasNonCraftingPart = true
		elseif tonumber(strmatch(part, "^x(%d+)$")) then
			self._maxQuantity = tonumber(strmatch(part, "^x(%d+)$"))
			if self._maxQuantity == 0 then
				errMsg = L["The max quantity cannot be zero."]
				self._isValid = false
			end
		elseif strlower(part) == "crafting" then
			if self._crafting or self._disenchant then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._crafting = true
		elseif strlower(part) == "disenchant" then
			if self._disenchant or self._crafting then
				errMsg = L["The same filter was specified multiple times."]
				self._isValid = false
			end
			self._disenchant = true
		else
			-- invalid part
			errMsg = format(L["Unknown word (%s)."], part)
			self._isValid = false
		end
	end

	if (self._crafting or self._disenchant) and hasNonCraftingPart then
		errMsg = L["Cannot use additional filters with /crafting or /disenchant."]
		self._isValid = false
	end

	if self._isValid == nil then
		self._isValid = true
	end
	return self._isValid, errMsg
end

function Filter.GetStr(self)
	return self._str ~= "" and self._str or nil
end

function Filter.GetItem(self)
	return self._item
end

function Filter.GetMinQuality(self)
	return self._minQuality ~= -math.huge and self._minQuality or nil
end

function Filter.GetMaxQuality(self)
	return self._maxQuality ~= math.huge and self._maxQuality or nil
end

function Filter.GetClass(self)
	return self._class
end

function Filter.GetSubClass(self)
	return self._subClass
end

function Filter.GetInvSlotId(self)
	return self._invSlotId
end

function Filter.GetMinLevel(self)
	return self._minLevel ~= 0 and self._minLevel or nil
end

function Filter.GetMaxLevel(self)
	return self._maxLevel ~= math.huge and self._maxLevel or nil
end

function Filter.GetMinItemLevel(self)
	return self._minItemLevel ~= 0 and self._minItemLevel or nil
end

function Filter.GetMaxItemLevel(self)
	return self._maxItemLevel ~= math.huge and self._maxItemLevel or nil
end

function Filter.GetUncollected(self)
	return self._uncollected
end

function Filter.GetUsableOnly(self)
	return self._usable
end

function Filter.GetUpgrades(self)
	return self._upgrades
end

function Filter.GetUnlearned(self)
	return self._unlearned
end

function Filter.GetCanLearn(self)
	return self._canlearn
end

function Filter.GetExactOnly(self)
	return self._exactOnly
end

function Filter.GetMaxQuantity(self)
	return self._maxQuantity ~= math.huge and self._maxQuantity or nil
end

function Filter.GetMinPrice(self)
	return self._minPrice ~= 0 and self._minPrice or nil
end

function Filter.GetMaxPrice(self)
	return self._maxPrice ~= math.huge and self._maxPrice or nil
end

function Filter.GetCrafting(self)
	return self._crafting
end

function Filter.GetDisenchant(self)
	return self._disenchant
end

function Filter.Matches(self, item, price)
	if not self._isValid then
		return false
	end

	-- check the name
	local name = ItemInfo.GetName(item)
	name = name and strlower(name)
	if not name or not strfind(name, self._escapedStr) or (self._exactOnly and name ~= self._str) then
		return false
	end

	-- check the quality
	local quality = ItemInfo.GetQuality(item)
	if not quality or quality < self._minQuality or quality > self._maxQuality then
		return false
	end

	-- check the item level
	local itemLevel = ItemInfo.GetItemLevel(item)
	if not itemLevel or itemLevel < self._minItemLevel or itemLevel > self._maxItemLevel then
		return false
	end

	-- check the required level
	local level = ItemInfo.GetMinLevel(item)
	if not level or level < self._minLevel or level > self._maxLevel then
		return false
	end

	-- check the item class
	if self._class and ItemInfo.GetClassId(item) ~= self._class then
		return false
	end

	-- check the item subclass
	if self._subClass and ItemInfo.GetSubClassId(item) ~= self._subClass then
		return false
	end

	-- check the inventory slot
	if self._invSlotId and ItemInfo.GetInvSlotId(item) ~= self._invSlotId then
		return false
	end

	-- check unlearned
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(ItemInfo.GetLink(item)) then
		return false
	end

	-- check canlearn
	if self._canlearn and CanIMogIt:CharacterCanLearnTransmog(ItemInfo.GetLink(item)) then
		return false
	end

	-- check the price
	price = price or 0
	if price < self._minPrice or price > self._maxPrice then
		return false
	end

	-- it passed!
	return true
end
