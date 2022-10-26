-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ProfessionScrollingTable UI Element Class.
-- This is used to display the crafts within the currently-selected profession in the CraftingUI. It is a subclass of
-- the @{ScrollingTable} class.
-- @classmod ProfessionScrollingTable

local _, TSM = ...
local L = TSM.Include("Locale").GetTable()
local CraftString = TSM.Include("Util.CraftString")
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local Theme = TSM.Include("Util.Theme")
local Log = TSM.Include("Util.Log")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Event = TSM.Include("Util.Event")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Tooltip = TSM.Include("UI.Tooltip")
local ProfessionScrollingTable = TSM.Include("LibTSMClass").DefineClass("ProfessionScrollingTable", TSM.UI.ScrollingTable)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(ProfessionScrollingTable)
TSM.UI.ProfessionScrollingTable = ProfessionScrollingTable
local private = {
	activeElements = {},
	categoryInfoCache = {
		parent = {},
		numIndents = {},
		name = {},
		currentSkillLevel = {},
		maxSkillLevel = {},
	},
	costsCache = {
		updateTime = 0,
		isCached = {},
		craftingCost = {},
		itemValue = {},
		profit = {},
	},
}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ProfessionScrollingTable.__init(self)
	self.__super:__init()
	self._query = nil
	self._isCraftString = {}
	self._favoritesContextTable = nil
	if TSM.IsWowClassic() then
		TSM.Crafting.ProfessionState.RegisterUpdateCallback(function()
			wipe(private.categoryInfoCache.numIndents)
		end)
	end
end

function ProfessionScrollingTable.Acquire(self)
	self.__super:Acquire()
	self:GetScrollingTableInfo()
		:SetMenuInfo(private.MenuIterator, private.MenuClickHandler)
		:NewColumn("name")
			:SetTitle(L["Recipe Name"])
			:SetFont("ITEM_BODY3")
			:SetJustifyH("LEFT")
			:SetTextFunction(private.GetNameCellText)
			:SetExpanderStateFunction(private.GetExpanderState)
			:SetActionIconInfo(1, 14, private.GetFavoriteIcon, true)
			:SetActionIconClickHandler(private.OnFavoriteIconClick)
			:DisableHiding()
			:Commit()
		:NewColumn("qty")
			:SetTitle(L["Craft"])
			:SetFont("BODY_BODY3_MEDIUM")
			:SetJustifyH("CENTER")
			:SetTextFunction(private.GetQtyCellText)
			:Commit()
	if not TSM.IsWowClassic() then
		self:GetScrollingTableInfo()
			:NewColumn("rank")
				:SetTitle(RANK)
				:SetFont("BODY_BODY3_MEDIUM")
				:SetJustifyH("CENTER")
				:SetTextFunction(private.GetRankCellText)
				:Commit()
	end
	self:GetScrollingTableInfo()
		:NewColumn("craftingCost")
			:SetTitle(L["Crafting Cost"])
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetCraftingCostCellText)
			:Commit()
		:NewColumn("itemValue")
			:SetTitle(L["Item Value"])
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetItemValueCellIndex)
			:Commit()
		:NewColumn("profit")
			:SetTitle(L["Profit"])
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetProfitCellText)
			:Commit()
		:NewColumn("profitPct")
			:SetTitle("%")
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetProfitPctCellText)
			:Commit()
		:NewColumn("saleRate")
			:SetTitleIcon("iconPack.14x14/SaleRate")
			:SetFont("TABLE_TABLE1")
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetSaleRateCellText)
			:Commit()
		:Commit()
	if not next(private.activeElements) then
		Event.Register("CHAT_MSG_SKILL", private.OnChatMsgSkill)
	end
	private.activeElements[self] = true
end

function ProfessionScrollingTable.Release(self)
	private.activeElements[self] = nil
	if not next(private.activeElements) then
		Event.Unregister("CHAT_MSG_SKILL", private.OnChatMsgSkill)
	end
	if self._query then
		self._query:SetUpdateCallback()
		self._query = nil
	end
	wipe(self._isCraftString)
	self._favoritesContextTable = nil
	for _, row in ipairs(self._rows) do
		ScriptWrapper.Clear(row._frame, "OnDoubleClick")
	end
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Sets the @{DatabaseQuery} source for this table.
-- This query is used to populate the entries in the profession scrolling table.
-- @tparam ProfessionScrollingTable self The profession scrolling table object
-- @tparam DatabaseQuery query The query object
-- @tparam[opt=false] bool redraw Whether or not to redraw the scrolling table
-- @treturn ProfessionScrollingTable The profession scrolling table object
function ProfessionScrollingTable.SetQuery(self, query, redraw)
	if query == self._query and not redraw then
		return self
	end
	if self._query then
		self._query:SetUpdateCallback()
	end
	self._query = query
	self._query:SetUpdateCallback(private.QueryUpdateCallback, self)

	self:_ForceLastDataUpdate()
	self:UpdateData(redraw)
	return self
end

--- Sets the context table to use to store favorite craft information.
-- @tparam ProfessionScrollingTable self The profession scrolling table object
-- @tparam table tbl The context table
-- @treturn ProfessionScrollingTable The profession scrolling table object
function ProfessionScrollingTable.SetFavoritesContext(self, tbl)
	assert(type(tbl) == "table")
	self._favoritesContextTable = tbl
	return self
end

--- Sets the context table.
-- @tparam ProfessionScrollingTable self The profession scrolling table object
-- @tparam table tbl The context table
-- @tparam table defaultTbl The default table (required fields: `colWidth`, `colHidden`, `collapsed`)
-- @treturn ProfessionScrollingTable The profession scrolling table object
function ProfessionScrollingTable.SetContextTable(self, tbl, defaultTbl)
	assert(type(defaultTbl.collapsed) == "table")
	tbl.collapsed = tbl.collapsed or CopyTable(defaultTbl.collapsed)
	self.__super:SetContextTable(tbl, defaultTbl)
	return self
end

function ProfessionScrollingTable.IsCraftStringVisible(self, craftString)
	if not self._isCraftString[craftString] then
		-- this craft string isn't included in the query
		return false
	end
	local categoryId = TSM.Crafting.ProfessionScanner.GetCategoryIdByCraftString(craftString)
	return not self:_IsCategoryHidden(categoryId) and not self._contextTable.collapsed[categoryId]
end

function ProfessionScrollingTable.Draw(self)
	if self._lastDataUpdate == nil then
		self:_IgnoreLastDataUpdate()
	end
	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ProfessionScrollingTable._ToggleCollapsed(self, categoryId)
	self._contextTable.collapsed[categoryId] = not self._contextTable.collapsed[categoryId] or nil
	if self._selection and not self:IsCraftStringVisible(self._selection) then
		self:SetSelection(nil, true)
	end
end

function ProfessionScrollingTable._GetTableRow(self, isHeader)
	local row = self.__super:_GetTableRow(isHeader)
	if not isHeader then
		ScriptWrapper.Set(row._frame, "OnClick", private.RowOnClick, row)
		ScriptWrapper.Set(row._frame, "OnDoubleClick", private.RowOnClick, row)
		local rankBtn = row:_GetButton()
		rankBtn:SetAllPoints(row._texts.rank)
		ScriptWrapper.SetPropagate(rankBtn, "OnClick")
		ScriptWrapper.Set(rankBtn, "OnEnter", private.RankOnEnter, row)
		ScriptWrapper.Set(rankBtn, "OnLeave", private.RankOnLeave, row)
		row._buttons.rank = rankBtn
	end
	return row
end

function ProfessionScrollingTable._UpdateData(self)
	local currentCategoryPath = TempTable.Acquire()
	local foundSelection = false
	-- populate the data
	wipe(self._data)
	wipe(self._isCraftString)
	for _, craftString in self._query:Iterator() do
		local spellId = CraftString.GetSpellId(craftString)
		if self._favoritesContextTable[spellId] then
			local categoryId = -1
			if categoryId ~= currentCategoryPath[#currentCategoryPath] then
				-- this is a new category
				local newCategoryPath = TempTable.Acquire()
				tinsert(newCategoryPath, 1, categoryId)
				-- create new category headers
				if currentCategoryPath[1] ~= categoryId then
					if not self:_IsCategoryHidden(categoryId) then
						tinsert(self._data, categoryId)
					end
				end
				TempTable.Release(currentCategoryPath)
				currentCategoryPath = newCategoryPath
			end
			foundSelection = foundSelection or craftString == self:GetSelection()
			if not self._contextTable.collapsed[categoryId] and not self:_IsCategoryHidden(categoryId) then
				tinsert(self._data, craftString)
				self._isCraftString[craftString] = true
			end
		end
	end
	for _, craftString, categoryId in self._query:Iterator() do
		local spellId = CraftString.GetSpellId(craftString)
		if not self._favoritesContextTable[spellId] then
			if categoryId ~= currentCategoryPath[#currentCategoryPath] then
				-- this is a new category
				local newCategoryPath = TempTable.Acquire()
				local currentCategoryId = categoryId
				while currentCategoryId do
					tinsert(newCategoryPath, 1, currentCategoryId)
					currentCategoryId = private.CategoryGetParentCategoryId(currentCategoryId)
				end
				-- create new category headers
				for i = 1, #newCategoryPath do
					local newCategoryId = newCategoryPath[i]
					if currentCategoryPath[i] ~= newCategoryId then
						if not self:_IsCategoryHidden(newCategoryId) and private.CategoryGetName(newCategoryId) then
							tinsert(self._data, newCategoryId)
						end
					end
				end
				TempTable.Release(currentCategoryPath)
				currentCategoryPath = newCategoryPath
			end
			foundSelection = foundSelection or craftString == self:GetSelection()
			if not self._contextTable.collapsed[categoryId] and not self:_IsCategoryHidden(categoryId) then
				tinsert(self._data, craftString)
				self._isCraftString[craftString] = true
			end
		end
	end
	TempTable.Release(currentCategoryPath)
	if not foundSelection then
		-- try to select the first visible craft string
		local newSelection = nil
		for _, data in ipairs(self._data) do
			if not newSelection and self._isCraftString[data] then
				newSelection = data
			end
		end
		self:SetSelection(newSelection, true)
	end
end

function ProfessionScrollingTable._IsCategoryHidden(self, categoryId)
	if private.IsFavoriteCategory(categoryId) then
		return false
	end
	local parent = private.CategoryGetParentCategoryId(categoryId)
	while parent do
		if self._contextTable.collapsed[parent] then
			return true
		end
		parent = private.CategoryGetParentCategoryId(parent)
	end
	return false
end

function ProfessionScrollingTable._SetRowData(self, row, data)
	local rank = self._isCraftString[data] and CraftString.GetRank(data) or -1
	local level = self._isCraftString[data] and CraftString.GetLevel(data) or -1
	if rank == -1 and level == -1 then
		row._buttons.rank:Hide()
	else
		row._buttons.rank:Show()
	end
	self.__super:_SetRowData(row, data)
end

function ProfessionScrollingTable._ToggleSort(self, id)
	-- do nothing
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateCategoryInfoCache(categoryId)
	-- numIndents always gets set, so use that to know whether or not this category is already cached
	if not private.categoryInfoCache.numIndents[categoryId] then
		local name, numIndents, parentCategoryId, currentSkillLevel, maxSkillLevel = TSM.Crafting.ProfessionUtil.GetCategoryInfo(categoryId)
		private.categoryInfoCache.name[categoryId] = name
		private.categoryInfoCache.numIndents[categoryId] = numIndents
		private.categoryInfoCache.parent[categoryId] = parentCategoryId
		private.categoryInfoCache.currentSkillLevel[categoryId] = currentSkillLevel
		private.categoryInfoCache.maxSkillLevel[categoryId] = maxSkillLevel
	end
end

function private.CategoryGetParentCategoryId(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.parent[categoryId]
end

function private.CategoryGetNumIndents(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.numIndents[categoryId]
end

function private.CategoryGetName(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.name[categoryId]
end

function private.CategoryGetSkillLevel(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.currentSkillLevel[categoryId], private.categoryInfoCache.maxSkillLevel[categoryId]
end

function private.IsFavoriteCategory(categoryId)
	return categoryId == -1
end

function private.QueryUpdateCallback(_, _, self)
	self:_ForceLastDataUpdate()
	self:UpdateData(true)
end

function private.MenuIterator(self, prevIndex)
	if prevIndex == "CREATE_GROUPS" then
		-- we're done
		return
	else
		return "CREATE_GROUPS", L["Create Groups from Table"]
	end
end

function private.MenuClickHandler(self, index1, index2)
	if index1 == "CREATE_GROUPS" then
		assert(not index2)
		self:GetBaseElement():HideDialog()
		local numCreated, numAdded = 0, 0
		for _, spellId in self._query:Iterator() do
			local itemString = TSM.Crafting.GetItemString(spellId)
			if itemString then
				local groupPath = private.GetCategoryGroupPath(TSM.Crafting.ProfessionScanner.GetCategoryIdByCraftString(spellId))
				if not TSM.Groups.Exists(groupPath) then
					TSM.Groups.Create(groupPath)
					numCreated = numCreated + 1
				end
				if not TSM.Groups.IsItemInGroup(itemString) and not ItemInfo.IsSoulbound(itemString) then
					TSM.Groups.SetItemGroup(itemString, groupPath)
					numAdded = numAdded + 1
				end
			end
		end
		Log.PrintfUser(L["%d groups were created and %d items were added from the table."], numCreated, numAdded)
	else
		error("Unexpected index1: "..tostring(index1))
	end
end

function private.GetCategoryGroupPath(categoryId)
	local parts = TempTable.Acquire()
	while categoryId do
		tinsert(parts, 1, private.categoryInfoCache.name[categoryId])
		categoryId = private.categoryInfoCache.parent[categoryId]
	end
	local name = TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()
	tinsert(parts, 1, name)
	return TSM.Groups.Path.Join(TempTable.UnpackAndRelease(parts))
end

function private.GetNameCellText(self, data)
	if self._isCraftString[data] then
		local name = TSM.Crafting.ProfessionScanner.GetNameByCraftString(data)
		local color = nil
		if TSM.Crafting.ProfessionUtil.IsGuildProfession() then
			color = Theme.GetProfessionDifficultyColor("easy")
		elseif TSM.Crafting.ProfessionUtil.IsNPCProfession() then
			color = Theme.GetProfessionDifficultyColor("nodifficulty")
		else
			local difficulty = TSM.Crafting.ProfessionScanner.GetDifficultyByCraftString(data)
			color = Theme.GetProfessionDifficultyColor(difficulty)
		end
		return color:ColorText(name)
	else
		-- this is a category
		local name = nil
		if private.IsFavoriteCategory(data) then
			name = L["Favorited Patterns"]
		else
			local currentSkillLevel, maxSkillLevel = private.CategoryGetSkillLevel(data)
			name = private.CategoryGetName(data)
			if name and currentSkillLevel and maxSkillLevel then
				name = name.." ("..currentSkillLevel.."/"..maxSkillLevel..")"
			end
		end
		if not name then
			-- happens if we're switching to another profession
			return "?"
		end
		if private.IsFavoriteCategory(data) or private.CategoryGetNumIndents(data) == 0 then
			return Theme.GetColor("INDICATOR"):ColorText(name)
		else
			return Theme.GetColor("INDICATOR_ALT"):ColorText(name)
		end
	end
end

function private.GetExpanderState(self, data)
	local indentLevel = 0
	if self._isCraftString[data] then
		indentLevel = 2
	elseif not private.IsFavoriteCategory(data) then
		indentLevel = private.CategoryGetNumIndents(data) * 2
	end
	return not self._isCraftString[data], not self._contextTable.collapsed[data], -indentLevel
end

function private.GetFavoriteIcon(self, data, iconIndex, isMouseOver)
	if iconIndex == 1 then
		if not self._isCraftString[data] then
			return false, nil, true
		else
			local spellId = CraftString.GetSpellId(data)
			return true, self._favoritesContextTable[spellId] and "iconPack.12x12/Star/Filled" or "iconPack.12x12/Star/Unfilled", true
		end
	else
		error("Invalid index: "..tostring(iconIndex))
	end
end

function private.OnFavoriteIconClick(self, data, iconIndex)
	if iconIndex == 1 then
		if self._isCraftString[data] and private.IsPlayerProfession() then
			local spellId = CraftString.GetSpellId(data)
			self._favoritesContextTable[spellId] = not self._favoritesContextTable[spellId] or nil
			self:_ForceLastDataUpdate()
			self:UpdateData(true)
		end
	else
		error("Invalid index: "..tostring(iconIndex))
	end
end

function private.GetQtyCellText(self, data)
	if not self._isCraftString[data] then
		return ""
	end
	local num, numAll = TSM.Crafting.ProfessionUtil.GetNumCraftable(data)
	if num == numAll then
		if num > 0 then
			return Theme.GetFeedbackColor("GREEN"):ColorText(num)
		end
		return tostring(num)
	else
		if num > 0 then
			return Theme.GetFeedbackColor("GREEN"):ColorText(num.."-"..numAll)
		elseif numAll > 0 then
			return Theme.GetFeedbackColor("YELLOW"):ColorText(num.."-"..numAll)
		else
			return num.."-"..numAll
		end
	end
end

function private.GetRankCellText(self, data)
	local rank = self._isCraftString[data] and CraftString.GetRank(data) or -1
	local level = self._isCraftString[data] and CraftString.GetLevel(data) or -1
	if rank == -1 and level == -1 then
		return ""
	end
	if rank > 0 then
		local filled = TSM.UI.TexturePacks.GetTextureLink("iconPack.14x14/Star/Filled")
		local unfilled = TSM.UI.TexturePacks.GetTextureLink("iconPack.14x14/Star/Unfilled")
		assert(rank >= 1 and rank <= 3)
		return strrep(filled, rank)..strrep(unfilled, 3 - rank)
	end
	if level > 0 then
		local currExp = TSM.Crafting.ProfessionScanner.GetCurrentExpByCraftString(data)
		local nextExp = TSM.Crafting.ProfessionScanner.GetNextExpByCraftString(data)
		return currExp >= 0 and format("%s / %s", currExp, nextExp) or L["Max"]
	end
end

function private.GetCraftingCostCellText(self, data)
	if not self._isCraftString[data] then
		return ""
	end
	local craftingCost = private.GetCostsByCraftString(data)
	return craftingCost and Money.ToString(craftingCost) or ""
end

function private.GetItemValueCellIndex(self, data)
	if not self._isCraftString[data] then
		return ""
	end
	local _, craftedItemValue = private.GetCostsByCraftString(data)
	return craftedItemValue and Money.ToString(craftedItemValue) or ""
end

function private.GetProfitCellText(self, data, currentTitleIndex)
	if not self._isCraftString[data] then
		return ""
	end
	local _, _, profit = private.GetCostsByCraftString(data)
	local color = profit and Theme.GetFeedbackColor(profit >= 0 and "GREEN" or "RED")
	return profit and Money.ToString(profit, color:GetTextColorPrefix()) or ""
end

function private.GetProfitPctCellText(self, data, currentTitleIndex)
	if not self._isCraftString[data] then
		return ""
	end
	local craftingCost, _, profit = private.GetCostsByCraftString(data)
	local color = profit and Theme.GetFeedbackColor(profit >= 0 and "GREEN" or "RED")
	return profit and color:ColorText(floor(profit * 100 / craftingCost).."%") or ""
end

function private.GetSaleRateCellText(self, data)
	return self._isCraftString[data] and TSM.Crafting.Cost.GetSaleRateByCraftString(data) or ""
end

function private.GetCostsByCraftString(craftString)
	if private.costsCache.updateTime ~= GetTime() then
		wipe(private.costsCache.isCached)
		wipe(private.costsCache.craftingCost)
		wipe(private.costsCache.itemValue)
		wipe(private.costsCache.profit)
		private.costsCache.updateTime = GetTime()
	end
	if not private.costsCache.isCached[craftString] then
		local craftingCost, itemValue, profit = TSM.Crafting.Cost.GetCostsByCraftString(craftString)
		private.costsCache.isCached[craftString] = true
		private.costsCache.craftingCost[craftString] = craftingCost
		private.costsCache.itemValue[craftString] = itemValue
		private.costsCache.profit[craftString] = profit
	end
	return private.costsCache.craftingCost[craftString], private.costsCache.itemValue[craftString], private.costsCache.profit[craftString]
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(row, mouseButton)
	local scrollingTable = row._scrollingTable
	local data = row:GetData()
	if mouseButton == "LeftButton" then
		if scrollingTable._isCraftString[data] then
			scrollingTable:SetSelection(data)
		else
			scrollingTable:_ToggleCollapsed(data)
		end
		scrollingTable:UpdateData(true)

		if scrollingTable._isCraftString[data] then
			row:SetHighlightState("selectedHover")
		else
			row:SetHighlightState("hover")
		end
	end
	if scrollingTable._isCraftString[data] then
		scrollingTable:_HandleRowClick(data, mouseButton)
	end
end

function private.RankOnEnter(row)
	local data = row:GetData()
	local rank = CraftString.GetRank(data)
	if rank and rank > 0 then
		assert(not Tooltip.IsVisible())
		local spellId = CraftString.GetSpellId(data)
		GameTooltip:SetOwner(row._buttons.rank, "ANCHOR_PRESERVE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("LEFT", row._buttons.rank, "RIGHT")
		GameTooltip:SetRecipeRankInfo(spellId, rank)
		GameTooltip:Show()
	end
	local level = CraftString.GetLevel(data)
	if level and level > 0 then
		assert(not Tooltip.IsVisible())
		local currExp = TSM.Crafting.ProfessionScanner.GetCurrentExpByCraftString(data)
		local nextExp = TSM.Crafting.ProfessionScanner.GetNextExpByCraftString(data)
		GameTooltip:SetOwner(row._buttons.rank, "ANCHOR_PRESERVE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("LEFT", row._buttons.rank, "RIGHT")
		if currExp == -1 then
			GameTooltip_SetTitle(GameTooltip, TRADESKILL_RECIPE_LEVEL_TOOLTIP_HIGHEST_RANK, NORMAL_FONT_COLOR)
			GameTooltip_AddColoredLine(GameTooltip, TRADESKILL_RECIPE_LEVEL_TOOLTIP_HIGHEST_RANK_EXPLANATION, GREEN_FONT_COLOR)
		else
			local stepExp = TSM.Crafting.ProfessionScanner.GetStepExpByCraftString(data)
			local experiencePercent = math.floor((currExp / nextExp) * 100)
			GameTooltip_SetTitle(GameTooltip, TRADESKILL_RECIPE_LEVEL_TOOLTIP_RANK_FORMAT:format(level), NORMAL_FONT_COLOR)
			GameTooltip_AddHighlightLine(GameTooltip, TRADESKILL_RECIPE_LEVEL_TOOLTIP_EXPERIENCE_FORMAT:format(currExp, nextExp, experiencePercent))
			GameTooltip_AddColoredLine(GameTooltip, TRADESKILL_RECIPE_LEVEL_TOOLTIP_LEVELING_FORMAT:format(level + 1), GREEN_FONT_COLOR)
			GameTooltip:AddLine(format(L["Experience earned: %d"], stepExp))
		end
		GameTooltip:Show()
	end
	row._frame:GetScript("OnEnter")(row._frame)
end

function private.RankOnLeave(row)
	Tooltip.Hide()
	row._frame:GetScript("OnLeave")(row._frame)
end

function private.IsPlayerProfession()
	return not (TSM.Crafting.ProfessionUtil.IsNPCProfession() or TSM.Crafting.ProfessionUtil.IsLinkedProfession() or TSM.Crafting.ProfessionUtil.IsGuildProfession())
end

function private.OnChatMsgSkill(_, msg)
	local name = TSM.Crafting.ProfessionUtil.GetCurrentProfessionInfo()
	if not strmatch(msg, name) then
		return
	end
	for self in pairs(private.activeElements) do
		wipe(private.categoryInfoCache.numIndents)
		self:_ForceLastDataUpdate()
		self:_UpdateData(true)
	end
end
