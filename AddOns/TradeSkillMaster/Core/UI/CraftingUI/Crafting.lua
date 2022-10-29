-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.UI.CraftingUI:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local CraftString = TSM.Include("Util.CraftString")
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Table = TSM.Include("Util.Table")
local Log = TSM.Include("Util.Log")
local Wow = TSM.Include("Util.Wow")
local Theme = TSM.Include("Util.Theme")
local ItemString = TSM.Include("Util.ItemString")
local RecipeString = TSM.Include("Util.RecipeString")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Settings = TSM.Include("Service.Settings")
local ItemLinked = TSM.Include("Service.ItemLinked")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	fsm = nil,
	professions = {},
	professionsKeys = {},
	groupSearch = "",
	showDelayFrame = 0,
	filterText = "",
	haveSkillUp = false,
	haveMaterials = false,
	professionFrame = nil,
	optionalMats = {},
	recipeLevels = {},
	recipeLevelsKeys = {},
}
local MAX_CRAFT_LEVEL = 4
local SHOW_DELAY_FRAMES = 2
local KEY_SEP = "\001"



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "craftingUIContext", "professionScrollingTable")
		:AddKey("global", "craftingUIContext", "professionDividedContainer")
		:AddKey("char", "craftingUIContext", "groupTree")
		:AddKey("factionrealm", "internalData", "isCraftFavorite")
	ItemLinked.RegisterCallback(private.ItemLinkedCallback)
	TSM.UI.CraftingUI.RegisterTopLevelPage(L["Crafting"], private.GetCraftingFrame)
	private.FSMCreate()
end



-- ============================================================================
-- Crafting UI
-- ============================================================================

function private.GetCraftingFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting")
	return UIElements.New("DividedContainer", "crafting")
		:SetMinWidth(400, 200)
		:SetBackgroundColor("PRIMARY_BG")
		:SetSettingsContext(private.settings, "professionDividedContainer")
		:SetLeftChild(UIElements.New("Frame", "left")
			:SetLayout("VERTICAL")
			:SetBackgroundColor("PRIMARY_BG_ALT")
			:AddChild(UIElements.New("ViewContainer", "viewContainer")
				:SetNavCallback(private.GetCraftingMainScreen)
				:AddPath("main", true)
			)
		)
		:SetRightChild(UIElements.New("Frame", "queue")
			:SetLayout("VERTICAL")
			:SetBackgroundColor("PRIMARY_BG")
			:AddChild(UIElements.New("Text", "title")
				:SetHeight(24)
				:SetMargin(8, 8, 6, 0)
				:SetFont("BODY_BODY1_BOLD")
				:SetText(format(L["Crafting Queue (%d)"], 0))
			)
			:AddChild(UIElements.New("Texture", "line")
				:SetHeight(2)
				:SetMargin(0, 0, 4, 4)
				:SetTexture("ACTIVE_BG")
			)
			:AddChild(UIElements.New("CraftingQueueList", "queueList")
				:SetQuery(TSM.Crafting.CreateQueueQuery())
				:SetScript("OnRowMouseDown", private.QueueOnRowMouseDown)
				:SetScript("OnRowClick", private.QueueOnRowClick)
			)
			:AddChild(UIElements.New("Texture", "line")
				:SetHeight(2)
				:SetTexture("ACTIVE_BG")
			)
			:AddChild(UIElements.New("Frame", "footer")
				:SetLayout("VERTICAL")
				:SetBackgroundColor("PRIMARY_BG_ALT")
				:AddChild(UIElements.New("Frame", "queueTime")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(8, 8, 8, 4)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetMargin(0, 4, 0, 0)
						:SetFont("BODY_BODY3_MEDIUM")
						:SetText(L["Time to Craft:"])
					)
					:AddChild(UIElements.New("Text", "text")
						:SetFont("TABLE_TABLE1")
						:SetJustifyH("RIGHT")
					)
				)
				:AddChild(UIElements.New("Frame", "queueCost")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(8, 8, 0, 4)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetMargin(0, 4, 0, 0)
						:SetFont("BODY_BODY3_MEDIUM")
						:SetText(L["Estimated Cost:"])
					)
					:AddChild(UIElements.New("Text", "text")
						:SetFont("TABLE_TABLE1")
						:SetJustifyH("RIGHT")
					)
				)
				:AddChild(UIElements.New("Frame", "queueProfit")
					:SetLayout("HORIZONTAL")
					:SetHeight(20)
					:SetMargin(8, 8, 0, 0)
					:AddChild(UIElements.New("Text", "label")
						:SetWidth("AUTO")
						:SetMargin(0, 4, 0, 0)
						:SetFont("BODY_BODY3_MEDIUM")
						:SetText(L["Estimated Profit:"])
					)
					:AddChild(UIElements.New("Text", "text")
						:SetFont("TABLE_TABLE1")
						:SetJustifyH("RIGHT")
					)
				)
				:AddChild(UIElements.New("Frame", "craft")
					:SetLayout("HORIZONTAL")
					:SetHeight(24)
					:SetMargin(8)
					:AddChild(UIElements.NewNamed("ActionButton", "craftNextBtn", "TSMCraftingBtn")
						:SetMargin(0, 8, 0, 0)
						:SetText(L["Craft Next"])
						:SetScript("OnClick", private.CraftNextOnClick)
					)
					:AddChild(UIElements.New("Button", "clearBtn")
						:SetWidth(70)
						:SetFont("BODY_BODY3_MEDIUM")
						:SetText(L["Clear All"])
						:SetScript("OnClick", private.ClearOnClick)
					)
				)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
end

function private.GetCraftingMainScreen(self, button)
	if button == "main" then
		return UIElements.New("Frame", "main")
			:SetLayout("VERTICAL")
			:SetPadding(0, 0, 6, 0)
			:AddChild(UIElements.New("TabGroup", "content")
				:SetNavCallback(private.GetCraftingElements)
				:AddPath(L["Crafting List"], true)
				:AddPath(L["TSM Groups"])
			)
	end
end

function private.GetCraftingElements(self, button)
	if button == L["Crafting List"] then
		private.filterText = ""
		private.professionFrame = UIElements.New("Frame", "profession")
			:SetLayout("VERTICAL")
			:AddChild(UIElements.New("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:SetMargin(8)
				:AddChild(UIElements.New("SelectionDropdown", "professionDropdown")
					:SetMargin(0, 8, 0, 0)
					:SetHintText(L["No Profession Opened"])
					:SetScript("OnSelectionChanged", private.ProfessionDropdownOnSelectionChanged)
				)
				:AddChild(UIElements.New("Input", "filterInput")
					:SetHeight(24)
					:SetMargin(0, 8, 0, 0)
					:SetIconTexture("iconPack.18x18/Search")
					:SetClearButtonEnabled(true)
					:SetHintText(L["Search Patterns"])
					:SetScript("OnValueChanged", private.FilterInputOnValueChanged)
				)
				:AddChild(UIElements.New("ActionButton", "filterBtn", "FILTER")
					:SetSize(24, 24)
					:SetIcon("iconPack.18x18/Filter")
					:SetDefaultNoBackground()
					:DisableClickCooldown()
					:SetHighlightLocked(private.haveSkillUp or private.haveMaterials, "INDICATOR")
					:SetScript("OnClick", private.FilterButtonOnClick)
				)
			)
			:AddChild(UIElements.New("Frame", "recipeContent")
				:SetLayout("VERTICAL")
				:SetMargin(0, 0, 0, 1)
				:AddChild(UIElements.New("ProfessionScrollingTable", "recipeList")
					:SetFavoritesContext(private.settings.isCraftFavorite)
					:SetSettingsContext(private.settings, "professionScrollingTable")
					:SetScript("OnSelectionChanged", private.RecipeListOnSelectionChanged)
					:SetScript("OnRowClick", private.RecipeListOnRowClick)
				)
				:AddChild(UIElements.New("Texture", "line")
					:SetHeight(2)
					:SetTexture("ACTIVE_BG")
				)
				:AddChild(UIElements.New("Frame", "details")
					:SetLayout("HORIZONTAL")
					:SetHeight(120)
					:SetPadding(8, 0, 8, 0)
					:SetBackgroundColor("PRIMARY_BG_ALT")
					:AddChild(UIElements.New("Frame", "left")
						:SetLayout("VERTICAL")
						:SetWidth(238)
						:SetMargin(0, 8, 0, 0)
						:AddChild(UIElements.New("Frame", "content")
							:SetLayout("HORIZONTAL")
							:AddChild(UIElements.New("Button", "icon")
								:SetSize(20, 20)
								:SetMargin(0, 8, 0, 0)
								:SetScript("OnClick", private.ItemOnClick)
							)
							:AddChild(UIElements.New("Button", "name")
								:SetHeight(24)
								:SetFont("ITEM_BODY1")
								:SetJustifyH("LEFT")
								:SetScript("OnClick", private.ItemOnClick)
							)
						)
						:AddChild(UIElements.New("Frame", "craft")
							:SetLayout("HORIZONTAL")
							:SetHeight(20)
							:AddChild(UIElements.New("Text", "num")
								:SetWidth("AUTO")
								:SetFont("BODY_BODY3")
							)
							:AddChild(UIElements.New("Text", "error")
								:SetFont("BODY_BODY3")
								:SetTextColor(Theme.GetFeedbackColor("RED"))
							)
						)
						:AddChild(UIElements.New("Spacer", "spacer"))
						:AddChild(UIElements.New("SelectionDropdown", "rankDropdown")
							:SetHeight(24)
							:SetScript("OnSelectionChanged", private.RankDropdownOnSelectionChanged)
						)
						:AddChild(UIElements.New("Frame", "optional")
							:SetLayout("HORIZONTAL")
							:SetHeight(20)
							:SetMargin(2, 0, 4, 0)
							:AddChild(UIElements.New("Button", "button")
								:SetWidth("AUTO")
								:SetIcon("iconPack.12x12/Add/Circle", "LEFT")
								:SetText(L["Add Optional Reagents"])
								:SetFont("BODY_BODY3_MEDIUM")
								:SetTextColor("INDICATOR")
								:SetScript("OnClick", private.OptionalMatsOnClick)
							)
							:AddChild(UIElements.New("Spacer", "spacer"))
						)
					)
					:AddChild(UIElements.New("Texture", "line")
						:SetWidth(2)
						:SetTexture("ACTIVE_BG")
					)
					:AddChild(UIElements.New("Frame", "content")
						:SetLayout("VERTICAL")
						:SetMargin(4, 8, 0, 0)
						:AddChild(UIElements.New("CraftingMatList", "matList")
							:SetBackgroundColor("PRIMARY_BG_ALT")
						)
						:AddChild(UIElements.New("Texture", "line")
							:SetHeight(2)
							:SetTexture("ACTIVE_BG")
						)
						:AddChild(UIElements.New("Frame", "cost")
							:SetLayout("HORIZONTAL")
							:SetHeight(20)
							:AddChild(UIElements.New("Text", "label")
								:SetWidth("AUTO")
								:SetMargin(0, 4, 0, 0)
								:SetFont("BODY_BODY3")
								:SetText(L["Crafting Cost"]..":")
							)
							:AddChild(UIElements.New("Text", "text")
								:SetFont("TABLE_TABLE1")
							)
						)
					)
				)
			)
			:AddChild(UIElements.New("Frame", "buttons")
				:SetLayout("HORIZONTAL")
				:SetHeight(40)
				:SetPadding(8)
				:AddChild(UIElements.New("ActionButton", "craftAllBtn")
					:SetWidth(155)
					:SetMargin(0, 8, 0, 0)
					:SetText(L["Craft All"])
					:SetScript("OnMouseDown", private.CraftAllBtnOnMouseDown)
					:SetScript("OnClick", private.CraftAllBtnOnClick)
				)
				:AddChild(UIElements.New("Input", "craftInput")
					:SetWidth(75)
					:SetMargin(0, 8, 0, 0)
					:SetBackgroundColor("ACTIVE_BG")
					:SetJustifyH("CENTER")
					:SetSubAddEnabled(true)
					:SetValidateFunc("NUMBER", "1:9999")
					:SetValue(1)
				)
				:AddChild(UIElements.New("ActionButton", "craftBtn")
					:SetHeight(24)
					:SetMargin(0, 8, 0, 0)
					:SetText(L["Craft"])
					:SetScript("OnMouseDown", private.CraftBtnOnMouseDown)
					:SetScript("OnClick", private.CraftBtnOnClick)
				)
				:AddChild(UIElements.New("ActionButton", "queueBtn")
					:SetHeight(24)
					:SetText(L["Queue"])
					:SetScript("OnClick", private.QueueBtnOnClick)
				)
			)
			:AddChild(UIElements.New("Text", "recipeListLoadingText")
				:SetJustifyH("CENTER")
				:SetFont("HEADING_H5")
				:SetText(L["Loading..."])
			)
			:SetScript("OnUpdate", private.ProfessionFrameOnUpdate)
			:SetScript("OnHide", private.ProfessionFrameOnHide)
		private.professionFrame:GetElement("recipeContent"):Hide()
		private.professionFrame:GetElement("buttons"):Hide()
		return private.professionFrame
	elseif button == L["TSM Groups"] then
		local frame = UIElements.New("Frame", "group")
			:SetLayout("VERTICAL")
			:AddChild(UIElements.New("Frame", "search")
				:SetLayout("HORIZONTAL")
				:SetHeight(24)
				:SetMargin(8)
				:AddChild(UIElements.New("Input", "input")
					:SetIconTexture("iconPack.18x18/Search")
					:AllowItemInsert(true)
					:SetClearButtonEnabled(true)
					:SetValue(private.groupSearch)
					:SetHintText(L["Search Groups"])
					:SetScript("OnValueChanged", private.GroupSearchOnValueChanged)
				)
				:AddChild(UIElements.New("Button", "expandAllBtn")
					:SetSize(24, 24)
					:SetMargin(8, 4, 0, 0)
					:SetBackground("iconPack.18x18/Expand All")
					:SetScript("OnClick", private.ExpandAllGroupsOnClick)
					:SetTooltip(L["Expand / Collapse All Groups"])
				)
				:AddChild(UIElements.New("Button", "selectAllBtn")
					:SetSize(24, 24)
					:SetMargin(0, 4, 0, 0)
					:SetBackground("iconPack.18x18/Select All")
					:SetScript("OnClick", private.SelectAllGroupsOnClick)
					:SetTooltip(L["Select / Deselect All Groups"])
				)
				:AddChild(UIElements.New("Button", "groupsBtn")
					:SetSize(24, 24)
					:SetBackground("iconPack.18x18/Groups")
					:SetScript("OnClick", private.CreateProfessionBtnOnClick)
					:SetTooltip(L["Create Profession Groups"])
				)
			)
			:AddChild(UIElements.New("Texture", "lineTop")
				:SetHeight(2)
				:SetTexture("ACTIVE_BG")
			)
			:AddChild(UIElements.New("ApplicationGroupTree", "groupTree")
				:SetSettingsContext(private.settings, "groupTree")
				:SetQuery(TSM.Groups.CreateQuery(), "Crafting")
				:SetSearchString(private.groupSearch)
				:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
			)
			:AddChild(UIElements.New("Texture", "lineBottom")
				:SetHeight(2)
				:SetTexture("ACTIVE_BG")
			)
			:AddChild(UIElements.New("ActionButton", "addBtn")
				:SetHeight(24)
				:SetMargin(6, 6, 8, 8)
				:SetText(L["Restock Selected Groups"])
				:SetScript("OnClick", private.QueueAddBtnOnClick)
			)
			:SetScript("OnUpdate", private.GroupFrameOnUpdate)
		frame:GetElement("addBtn"):SetDisabled(frame:GetElement("groupTree"):IsSelectionCleared())
		return frame
	else
		error("Unexpected button: "..tostring(button))
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	-- delay the FSM event by a few frames to give textures a chance to load
	if private.showDelayFrame == SHOW_DELAY_FRAMES then
		frame:SetScript("OnUpdate", nil)
		private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
	else
		private.showDelayFrame = private.showDelayFrame + 1
	end
end

function private.FrameOnHide()
	private.showDelayFrame = 0
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.ProfessionFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting", "profession")
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", "profession")
	private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
end

function private.ProfessionFrameOnHide(frame)
	assert(private.professionFrame == frame)
	private.professionFrame = nil
end

function private.GroupFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting", "group")
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", "group")
end

function private.GroupSearchOnValueChanged(input)
	private.groupSearch = strlower(input:GetValue())
	input:GetElement("__parent.__parent.groupTree")
		:SetSearchString(private.groupSearch)
		:Draw()
end

function private.ExpandAllGroupsOnClick(button)
	button:GetElement("__parent.__parent.groupTree")
		:ToggleExpandAll()
end

function private.SelectAllGroupsOnClick(button)
	button:GetElement("__parent.__parent.groupTree")
		:ToggleSelectAll()
end

function private.CreateProfessionBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	local profName = TSM.Crafting.ProfessionState.GetCurrentProfession()
	if not profName then
		Log.PrintUser(L["There is currently no profession open, so cannot create profession groups."])
		return
	end
	local items = profName..TSM.CONST.GROUP_SEP..L["Items"]
	local mats = profName..TSM.CONST.GROUP_SEP..L["Materials"]
	if TSM.Groups.Exists(profName) then
		if not TSM.Groups.Exists(items) then
			TSM.Groups.Create(items)
		end
		if not TSM.Groups.Exists(mats) then
			TSM.Groups.Create(mats)
		end
	else
		TSM.Groups.Create(profName)
		TSM.Groups.Create(items)
		TSM.Groups.Create(mats)
	end

	local numMats, numItems = 0, 0
	local query = TSM.Crafting.CreateRawMatItemQuery()
		:Matches("professions", profName)
		:Select("itemString")

	for _, itemString in query:IteratorAndRelease() do
		local classId = ItemInfo.GetClassId(itemString)
		if itemString and not TSM.Groups.IsItemInGroup(itemString) and not ItemInfo.IsSoulbound(itemString) and classId ~= LE_ITEM_CLASS_WEAPON and classId ~= LE_ITEM_CLASS_ARMOR then
			TSM.Groups.SetItemGroup(itemString, mats)
			numMats = numMats + 1
		end
	end

	query = TSM.Crafting.ProfessionScanner.CreateQuery()
		:Select("craftString")

	for _, craftString in query:IteratorAndRelease() do
		local itemString = TSM.Crafting.GetItemString(craftString)
		if itemString and not TSM.Groups.IsItemInGroup(itemString) and not ItemInfo.IsSoulbound(itemString) then
			TSM.Groups.SetItemGroup(itemString, items)
			numItems = numItems + 1
		end
	end

	if numMats > 0 or numItems > 0 then
		Log.PrintfUser(L["%s group updated with %d items and %d materials."], profName, numItems, numMats)
	else
		Log.PrintfUser(L["%s group is already up to date."], profName)
	end

	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):UpdateData(true)
	baseFrame:HideDialog()
end

function private.GroupTreeOnGroupSelectionChanged(groupTree)
	local addBtn = groupTree:GetElement("__parent.addBtn")
	addBtn:SetDisabled(groupTree:IsSelectionCleared())
	addBtn:Draw()
end

function private.ProfessionDropdownOnSelectionChanged(dropdown)
	local key = dropdown:GetSelectedItemKey()
	if not key then
		-- nothing selected
		return
	end
	local player, profession, skillId = strsplit(KEY_SEP, key)
	if not profession then
		-- the current linked / guild / NPC profession was re-selected, so just ignore this change
		return
	end
	-- TODO: support showing of other player's professions?
	assert(player == UnitName("player"))
	TSM.Crafting.ProfessionUtil.OpenProfession(profession, skillId)
end

function private.FilterInputOnValueChanged(input)
	local text = input:GetValue()
	if text == private.filterText then
		return
	end
	private.filterText = text

	private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
end

function private.RecipeListOnSelectionChanged(list)
	local selection = list:GetSelection()
	if selection and CraftFrame_SetSelection and TSM.Crafting.ProfessionState.IsClassicCrafting() then
		CraftFrame_SetSelection(TSM.Crafting.ProfessionScanner.GetIndexByCraftString(selection))
	end

	private.fsm:ProcessEvent("EV_RECIPE_SELECTION_CHANGED")
end

function private.RecipeListOnRowClick(list, data, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	if IsShiftKeyDown() then
		ChatEdit_InsertLink(TSM.Crafting.ProfessionUtil.GetRecipeLink(data))
	end
end

function private.QueueBtnOnClick(button)
	local value = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	private.fsm:ProcessEvent("EV_QUEUE_BUTTON_CLICKED", value)
end

function private.ItemOnClick(text)
	local craftString = tonumber(text:GetElement("__parent.name"):GetContext())
	if craftString then
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(GetCraftItemLink(TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString)))
			end
		else
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				if TSM.IsWowClassic() then
					ChatEdit_InsertLink(GetTradeSkillItemLink(TSM.Crafting.ProfessionScanner.GetIndexByCraftString(craftString)))
				else
					ChatEdit_InsertLink(C_TradeSkillUI.GetRecipeItemLink(craftString))
				end
			end
		end
	else
		Wow.SafeItemRef(ItemInfo.GetLink(text:GetElement("__parent.name"):GetContext()))
	end
end

function private.OptionalMatsOnClick(button)
	button:GetBaseElement():ShowDialogFrame(UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetSize(478, 308)
		:SetPadding(12)
		:AddAnchor("CENTER")
		:SetMouseEnabled(true)
		:SetBackgroundColor("FRAME_BG", true)
		:AddChild(UIElements.New("ViewContainer", "view")
			:SetNavCallback(private.GetViewContentFrame)
			:SetContext(button)
			:AddPath("list", true)
			:AddPath("selection")
		)
	)
end

function private.RankDropdownOnSelectionChanged(dropdown)
	private.fsm:ProcessEvent("EV_RECIPE_LEVEL_SELECTION_UPDATED", dropdown:GetSelectedItemKey())
end

function private.GetViewContentFrame(viewContainer, path)
	if path == "list" then
		return private.GetOptionalReagentList(viewContainer)
	elseif path == "selection" then
		return private.GetOptionalReagentSelection(viewContainer)
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetOptionalReagentList(viewContainer)
	local selectedCraftString = viewContainer:GetContext():GetContext()
	local level = viewContainer:GetContext():GetElement("__parent.__parent.rankDropdown"):GetSelectedItemKey()
	local rank = CraftString.GetRank(selectedCraftString)
	selectedCraftString = CraftString.Get(CraftString.GetSpellId(selectedCraftString), rank, level)
	local _, resultItemString = TSM.Crafting.ProfessionUtil.GetResultInfo(selectedCraftString)
	local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(selectedCraftString, private.optionalMats, rank, level))
	return UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
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
				:SetText(L["Add Optional Reagents"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.CloseDialog)
			)
		)
		:AddChild(UIElements.New("Frame", "item")
			:SetLayout("HORIZONTAL")
			:SetPadding(6)
			:SetMargin(0, 0, 0, 10)
			:SetBackgroundColor("PRIMARY_BG_ALT", true)
			:AddChild(UIElements.New("Button", "icon")
				:SetSize(36, 36)
				:SetMargin(0, 8, 0, 0)
				:SetBackground(ItemInfo.GetTexture(resultItemString))
				:SetTooltip(resultTooltip)
			)
			:AddChild(UIElements.New("Text", "name")
				:SetHeight(36)
				:SetFont("ITEM_BODY1")
				:SetText(TSM.UI.GetColoredItemName(resultItemString))
			)
		)
		:AddChild(UIElements.New("Text", "label")
			:SetHeight(20)
			:SetJustifyH("LEFT")
			:SetFont("BODY_BODY2_MEDIUM")
			:SetText(L["Optional Reagents"])
		)
		:AddChildrenWithFunction(private.AddOptionalRows, selectedCraftString)
		:AddChild(UIElements.New("Frame", "spacer"))
		:AddChild(UIElements.New("ActionButton", "addReagents")
			:SetHeight(24)
			:SetText(L["Add Reagent(s)"])
			:SetScript("OnClick", private.CloseDialog)
		)
end

function private.AddOptionalRows(frame, selectedCraftString)
	for _, matList, slotId, text in TSM.Crafting.OptionalMatIterator(selectedCraftString) do
		local row = UIElements.New("Frame", "optional"..slotId)
			:SetLayout("HORIZONTAL")
			:SetHeight(28)
			:SetMargin(8, 0, 4, 0)
			:SetContext(slotId)
			:AddChild(UIElements.New("Text", "slotId")
				:SetWidth(20)
				:SetMargin(2, 8, 0, 0)
				:SetFont("BODY_BODY1_BOLD")
				:SetText(slotId)
			)
			:AddChild(UIElements.New("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetPadding(0, 8, 0, 0)
				:SetBackgroundColor("ACTIVE_BG", true)
				:SetContext(matList)
				:SetMouseEnabled(true)
				:AddChild(UIElements.New("Button", "icon")
					:SetSize(20, 20)
					:SetMargin(8, 0, 0, 0)
					:SetBackground(private.optionalMats[slotId] and ItemInfo.GetTexture("i:"..private.optionalMats[slotId]) or nil)
					:SetTooltip(private.optionalMats[slotId] and "i:"..private.optionalMats[slotId] or nil)
				)
				:AddChild(UIElements.New("Button", "name")
					:SetWidth(300)
					:SetMargin(8, 0, 0, 0)
					:SetFont("BODY_BODY2")
					:SetJustifyH("LEFT")
					:SetContext(text)
					:PropagateScript("OnMouseUp")
					:SetText(private.optionalMats[slotId] and TSM.UI.GetColoredItemName("i:"..private.optionalMats[slotId]) or text)
				)
				:AddChild(UIElements.New("Frame", "spacer"))
				:AddChild(UIElements.New("Button", "removeBtn")
					:SetMargin(4, 4, 0, 0)
					:SetContext(slotId)
					:SetBackgroundAndSize("iconPack.18x18/Delete")
					:SetScript("OnClick", private.OptionalReagentRemoveOnClick)
				)
				:AddChild(UIElements.New("Texture", "addBtn")
					:SetMargin(4, 0, 0, 0)
					:SetTextureAndSize("iconPack.18x18/Chevron/Right")
				)
				:SetScript("OnMouseUp", private.OptionalReagentAddOnMouseUp)
			)
		if not private.optionalMats[slotId] then
			row:GetElement("title.icon")
				:Hide()
			row:GetElement("title.removeBtn")
				:Hide()
		else
			row:GetElement("title.icon")
				:Show()
			row:GetElement("title.removeBtn")
				:Show()
		end
		row:GetElement("title")
			:Draw()
		frame:AddChild(row)
	end
end

function private.OptionalReagentRemoveOnClick(button)
	local slotId = button:GetContext()
	private.optionalMats[slotId] = nil
	button:GetElement("__parent.icon")
		:SetBackground(nil)
		:SetTooltip(nil)
		:Hide()
	button:GetElement("__parent.name")
		:SetText(button:GetElement("__parent.name"):GetContext())
	button:GetElement("__parent.removeBtn")
		:Hide()
	button:GetElement("__parent")
		:Draw()
	local selectedCraftString = button:GetElement("__parent.__parent.__parent.__parent"):GetContext():GetContext()
	local level = button:GetBaseElement():GetElement("content.crafting.left.viewContainer.main.content.profession.recipeContent.details.left.rankDropdown"):GetSelectedItemKey()
	local rank = CraftString.GetRank(selectedCraftString)
	local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(selectedCraftString, private.optionalMats, rank, level))
	button:GetElement("__parent.__parent.__parent.item.icon")
		:SetTooltip(resultTooltip)
		:Draw()

	private.fsm:ProcessEvent("EV_RECIPE_OPTIONAL_MATS_UPDATED")
end

function private.OptionalReagentAddOnMouseUp(button)
	button:GetElement("__parent.__parent.__parent.__parent")
		:SetContext(button:GetContext())
	button:GetElement("__parent.__parent.__parent")
		:SetPath("selection", true)
end

function private.GetOptionalReagentSelection(viewContainer)
	local matTable = TempTable.Acquire()
	local slotId, matList = strmatch(viewContainer:GetParentElement():GetContext(), "o:(%d):(.+)")
	slotId = tonumber(slotId)
	for itemId in String.SplitIterator(matList, ",") do
		tinsert(matTable, ItemInfo.GetLink("i:"..itemId))
	end
	local frame = UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, -4, 10)
			:AddChild(UIElements.New("Button", "backBtn")
				:SetMargin(2, 0, 0, 0)
				:SetBackgroundAndSize("iconPack.18x18/Chevron/Right@180")
				:SetScript("OnClick", private.BackOnClick)
			)
			:AddChild(UIElements.New("Text", "title")
				:SetJustifyH("CENTER")
				:SetFont("BODY_BODY1_BOLD")
				:SetText(TSM.Crafting.ProfessionUtil.GetOptionalMatText(matList))
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.CloseDialog)
			)
		)
		:AddChild(UIElements.New("Frame", "container")
			:SetLayout("VERTICAL")
			:SetHeight(214)
			:SetBackgroundColor("PRIMARY_BG_ALT", true)
			:AddChild(UIElements.New("SelectionList", "list")
				:SetMargin(0, 0, 10, 10)
				:SetBackgroundColor("PRIMARY_BG_ALT")
				:SetContext(slotId)
				:SetEntries(matTable)
				:SetTooltipEnabled(true)
				:SetScript("OnEntrySelected", private.OptionalReagentOnEntrySelected)
			)
		)
	TempTable.Release(matTable)
	return frame
end

function private.OptionalReagentOnEntrySelected(list, selection)
	local slotId = list:GetContext()
	local itemId = ItemString.ToId(ItemString.Get(selection))
	for k, v in pairs(private.optionalMats) do
		if k ~= slotId and v == itemId then
			private.optionalMats[k] = nil
		end
	end
	private.optionalMats[slotId] = itemId
	list:GetBaseElement():HideDialog()

	private.fsm:ProcessEvent("EV_RECIPE_OPTIONAL_MATS_UPDATED")
end

function private.BackOnClick(button)
	button:GetElement("__parent.__parent.__parent.__parent")
		:SetContext(nil)
	button:GetElement("__parent.__parent.__parent")
		:SetPath("list", true)
end

function private.CloseDialog(button)
	button:GetBaseElement():HideDialog()
	private.fsm:ProcessEvent("EV_RECIPE_OPTIONAL_MATS_UPDATED")
end

function private.CraftBtnOnMouseDown(button)
	local quantity = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	local level = button:GetElement("__parent.__parent.recipeContent.details.left.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", quantity, level)
end

function private.CraftBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local quantity = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	local level = button:GetElement("__parent.__parent.recipeContent.details.left.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", quantity, level)
end

function private.CraftAllBtnOnMouseDown(button)
	local level = button:GetElement("__parent.__parent.recipeContent.details.left.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", math.huge, level)
end

function private.CraftAllBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local level = button:GetElement("__parent.__parent.recipeContent.details.left.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", math.huge, level)
end

function private.QueueOnRowMouseDown(button, data, mouseButton)
	if not private.IsPlayerProfession() or mouseButton ~= "LeftButton" then
		return
	end
	local recipeString = data:GetField("recipeString")
	local craftString = CraftString.FromRecipeString(recipeString)
	local level = CraftString.GetLevel(craftString)
	if TSM.Crafting.ProfessionScanner.HasCraftString(craftString) then
		TSM.Crafting.ProfessionUtil.PrepareToCraft(craftString, recipeString, TSM.Crafting.Queue.GetNum(recipeString), level)
	end
end

function private.QueueOnRowClick(button, data, mouseButton)
	if not private.IsPlayerProfession() then
		return
	end
	local recipeString = data:GetField("recipeString")
	local craftString = CraftString.FromRecipeString(recipeString)
	if mouseButton == "RightButton" then
		private.fsm:ProcessEvent("EV_QUEUE_RIGHT_CLICKED", craftString)
	elseif TSM.Crafting.ProfessionScanner.HasCraftString(craftString) then
		private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", craftString, recipeString, TSM.Crafting.Queue.GetNum(recipeString))
	end
end

function private.CraftNextOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local recipeString = button:GetElement("__parent.__parent.__parent.queueList"):GetFirstData():GetField("recipeString")
	local craftString = CraftString.FromRecipeString(recipeString)
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", craftString, recipeString, TSM.Crafting.Queue.GetNum(recipeString))
end

function private.ClearOnClick(button)
	TSM.Crafting.Queue.Clear()
	button:GetElement("__parent.__parent.__parent.title")
		:SetText(format(L["Crafting Queue (%d)"], 0))
		:Draw()
	button:GetElement("__parent.__parent.queueTime.text")
		:SetText("")
		:Draw()
	button:GetElement("__parent.__parent.queueCost.text")
		:SetText("")
		:Draw()
	button:GetElement("__parent.__parent.queueProfit.text")
		:SetText("")
		:Draw()
	button:GetElement("__parent.craftNextBtn")
		:SetDisabled(true)
		:Draw()
end

function private.QueueAddBtnOnClick(button)
	local groups = TempTable.Acquire()
	for _, groupPath in button:GetElement("__parent.groupTree"):SelectedGroupsIterator() do
		tinsert(groups, groupPath)
	end
	TSM.Crafting.Queue.RestockGroups(groups)
	TempTable.Release(groups)
end

function private.FilterButtonOnClick(button)
	button:GetBaseElement():ShowMenuDialog(button._frame, private.FilterDialogIterator, button:GetBaseElement(), private.FilterDialogButtonOnClick, true)
end

function private.FilterDialogButtonOnClick(button, self, index1, index2, extra)
	assert(not extra and index1)
	if index1 == "SKILLUP" then
		private.haveSkillUp = not private.haveSkillUp
		button:SetText(Theme.GetColor(private.haveSkillUp and "TEXT" or "TEXT+DISABLED"):ColorText(L["Have Skill Ups"]))
			:Draw()
		private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
	elseif index1 == "MATS" then
		private.haveMaterials = not private.haveMaterials
		button:SetText(Theme.GetColor(private.haveMaterials and "TEXT" or "TEXT+DISABLED"):ColorText(L["Have Mats"]))
			:Draw()
		private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
	elseif index1 == "RESET" then
		self:GetBaseElement():HideDialog()
		private.haveSkillUp = false
		private.haveMaterials = false
		private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
	else
		error("Unexpected index1: "..tostring(index1))
	end
end

function private.FilterDialogIterator(self, prevIndex)
	if prevIndex == nil then
		return "SKILLUP", Theme.GetColor(private.haveSkillUp and "TEXT" or "TEXT+DISABLED"):ColorText(L["Have Skill Ups"])
	elseif prevIndex == "SKILLUP" then
		return "MATS", Theme.GetColor(private.haveMaterials and "TEXT" or "TEXT+DISABLED"):ColorText(L["Have Mats"])
	elseif prevIndex == "MATS" then
		return "RESET", L["Reset Filters"]
	end
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		recipeQuery = nil,
		professionQuery = nil,
		page = "profession",
		selectedCraftString = nil,
		selectedCraftLevel = nil,
		queueQuery = nil,
		recipeString = nil,
		craftingType = nil,
		craftingQuantity = nil,
	}

	TSM.Crafting.ProfessionState.RegisterUpdateCallback(function()
		private.fsm:ProcessEvent("EV_PROFESSION_STATE_UPDATE")
	end)
	TSM.Crafting.ProfessionScanner.RegisterHasScannedCallback(function()
		private.fsm:ProcessEvent("EV_PROFESSION_STATE_UPDATE")
	end)

	local fsmPrivate = {
		success = nil,
		isDone = nil,
	}
	local function BagTrackingCallback()
		private.fsm:ProcessEvent("EV_BAG_UPDATE_DELAYED")
	end
	BagTracking.RegisterCallback(BagTrackingCallback)
	local function CraftCallback()
		private.fsm:ProcessEvent("EV_SPELLCAST_COMPLETE", fsmPrivate.success, fsmPrivate.isDone)
		fsmPrivate.success = nil
		fsmPrivate.isDone = nil
	end
	function fsmPrivate.CraftCallback(success, isDone)
		fsmPrivate.success = success
		fsmPrivate.isDone = isDone
		Delay.AfterFrame(1, CraftCallback)
	end
	function fsmPrivate.QueueUpdateCallback()
		private.fsm:ProcessEvent("EV_QUEUE_UPDATE")
	end
	function fsmPrivate.SkillUpdateCallback()
		private.fsm:ProcessEvent("EV_SKILL_UPDATE")
	end
	function fsmPrivate.UpdateCraftCost(context)
		if context.page == "profession" and context.selectedCraftString then
			local spellId = CraftString.GetSpellId(context.selectedCraftString)
			local rank = CraftString.GetRank(context.selectedCraftString)
			local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.cost.label")
				:Show()
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.cost.text")
				:SetText(Money.ToString(craftingCost) or "")
				:Draw()
		end
	end
	function fsmPrivate.UpdateMaterials(context)
		if context.page == "profession" then
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
				:UpdateData(true)
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.matList")
				:SetLevel(context.selectedCraftLevel)
				:UpdateData(true)
		end
		fsmPrivate.UpdateCraftButtons(context)
	end
	function fsmPrivate.UpdateProfessionsDropdown(context)
		-- update the professions dropdown info
		local dropdownSelection = nil
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		local isCurrentProfessionPlayer = private.IsPlayerProfession()
		wipe(private.professions)
		wipe(private.professionsKeys)
		if currentProfession and not isCurrentProfessionPlayer then
			assert(not TSM.IsWowVanillaClassic())
			local playerName = nil
			local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
			if linked then
				playerName = linkedName or "?"
			elseif TSM.Crafting.ProfessionUtil.IsNPCProfession() then
				playerName = L["NPC"]
			elseif TSM.Crafting.ProfessionUtil.IsGuildProfession() then
				playerName = L["Guild"]
			end
			assert(playerName)
			tinsert(private.professions, currentProfession)
			local key = currentProfession
			tinsert(private.professionsKeys, key)
			dropdownSelection = key
		end

		for _, player, profession, skillId, level, maxLevel in TSM.Crafting.PlayerProfessions.Iterator() do
			if player == UnitName("player") then
				tinsert(private.professions, format("%s (%d/%d)", profession, level, maxLevel))
				local key = player..KEY_SEP..profession..KEY_SEP..skillId
				tinsert(private.professionsKeys, key)
				if isCurrentProfessionPlayer and profession == currentProfession then
					assert(not dropdownSelection)
					dropdownSelection = key
				end
			end
		end

		context.frame:GetElement("left.viewContainer.main.content.profession.header.professionDropdown")
			:SetItems(private.professions, private.professionsKeys)
			:SetSelectedItemByKey(dropdownSelection, true)
			:Draw()
	end
	function fsmPrivate.UpdateSkills(context)
		if context.page ~= "profession" then
			return
		end

		fsmPrivate.UpdateProfessionsDropdown(context)
	end
	function fsmPrivate.UpdateFilter(context)
		if context.frame:GetElement("left.viewContainer.main.content"):GetPath() ~= L["Crafting List"] then
			return
		end
		context.frame:GetElement("left.viewContainer.main.content.profession.header.filterBtn"):SetHighlightLocked(private.haveSkillUp or private.haveMaterials, "INDICATOR")
			:Draw()
	end
	function fsmPrivate.UpdateRecipeTooltip(context)
		if not context.selectedCraftString then
			-- clicked on a category row
			return
		end
		local rank = CraftString.GetRank(context.selectedCraftString)
		local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(context.selectedCraftString, private.optionalMats, rank, context.selectedCraftLevel))
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.left.content.icon")
			:SetTooltip(resultTooltip)
			:Draw()
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.left.content.name")
			:SetTooltip(resultTooltip)
			:Draw()
	end
	function fsmPrivate.UpdateOptionalMaterials(context)
		if not context.selectedCraftString then
			-- clicked on a category row
			return
		end
		for k, itemId in pairs(private.optionalMats) do
			local levelTable = ProfessionInfo.GetRequiredLevelByOptionalMat(ItemString.Get(itemId))
			if levelTable and not levelTable[context.selectedCraftLevel] then
				-- this optional material can't be used with the selected craft level
				private.optionalMats[k] = nil
			end
		end
		fsmPrivate.UpdateRecipeTooltip(context)
		local spellId = CraftString.GetSpellId(context.selectedCraftString)
		local rank = CraftString.GetRank(context.selectedCraftString)
		local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.cost.label")
			:Show()
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.cost.text")
			:SetText(Money.ToString(craftingCost) or "")
			:Draw()
		local count = Table.Count(private.optionalMats)
		local suffix = count > 0 and " ("..count..")" or ""
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.left.optional.button")
			:SetText(L["Add Optional Reagents"]..suffix)
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.left.optional")
			:Draw()
		context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.content.matList")
			:SetOptionalMats(private.optionalMats)
			:SetLevel(context.selectedCraftLevel)
			:UpdateData(true)
	end
	function fsmPrivate.UpdateContentPage(context)
		if context.page ~= "profession" and context.page ~= "filters" then
			-- nothing to update
			return
		end

		fsmPrivate.UpdateProfessionsDropdown(context)

		local craftingContentFrame = context.frame:GetElement("left.viewContainer.main.content.profession")
		if not private.IsProfessionLoaded() then
			local text = nil
			if private.IsProfessionClosed() then
				text = L["No Profession Selected"]
			elseif private.IsProfessionLoadedNoSkills() then
				text = L["No Crafts"]
			else
				text = L["Loading..."]
			end
			craftingContentFrame:GetElement("recipeContent"):Hide()
			craftingContentFrame:GetElement("buttons"):Hide()
			craftingContentFrame:GetElement("recipeListLoadingText")
				:SetText(text)
				:Show()
			craftingContentFrame:Draw()
			return
		end

		local recipeContent = craftingContentFrame:GetElement("recipeContent")
		craftingContentFrame:GetElement("buttons"):Show()
		local recipeList = recipeContent:GetElement("recipeList")
		recipeContent:Show()
		craftingContentFrame:GetElement("recipeListLoadingText"):Hide()

		recipeList:SetQuery(fsmContext.recipeQuery)
		context.selectedCraftString = recipeList:GetSelection()
		local buttonFrame = recipeContent:GetElement("__parent.buttons")
		local detailsFrame = recipeContent:GetElement("details")
		if not context.selectedCraftString then
			buttonFrame:GetElement("craftBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("craftInput")
				:Hide()
			buttonFrame:Draw()
			detailsFrame:GetElement("left.content.icon")
				:Hide()
			detailsFrame:GetElement("left.content.name")
				:SetText("")
				:SetContext(nil)
				:SetTooltip(nil)
			detailsFrame:GetElement("content.cost.text")
				:SetText("")
			detailsFrame:GetElement("content.cost.label")
				:Hide()
			detailsFrame:GetElement("left.craft.num")
				:SetText("")
			detailsFrame:GetElement("left.craft.error")
				:SetText(L["No receipe selected"])
			buttonFrame:GetElement("craftAllBtn")
				:SetDisabled(true)
			detailsFrame:GetElement("content.matList")
				:SetRecipe(nil)
				:SetOptionalMats(nil)
				:SetLevel(nil)
			craftingContentFrame:Draw()
			return
		end
		local resultName, resultItemString, resultTexture = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedCraftString)
		-- engineer tinkers can't be crafted, multi-crafted or queued
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		local isEnchant, vellumable = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedCraftString)
		if not resultItemString then
			buttonFrame:GetElement("craftBtn")
				:SetText(currentProfession == GetSpellInfo(7411) and L["Enchant"] or (currentProfession == GetSpellInfo(4036) and L["Tinker"] or L["Craft"]))
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("craftInput")
				:Hide()
		else
			detailsFrame:GetElement("left.optional.button")
				:SetContext(context.selectedCraftString)
			buttonFrame:GetElement("craftBtn")
				:SetText(L["Craft"])
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(false)
			buttonFrame:GetElement("craftInput")
				:Show()
		end
		if TSM.Crafting.HasOptionalMats(context.selectedCraftString) then
			detailsFrame:GetElement("left.optional")
				:Show()
		else
			detailsFrame:GetElement("left.optional")
				:Hide()
		end
		local spellId = CraftString.GetSpellId(context.selectedCraftString)
		local level = CraftString.GetLevel(context.selectedCraftString)
		if level and level > 0 then
			wipe(private.recipeLevels)
			wipe(private.recipeLevelsKeys)
			for i = 1, MAX_CRAFT_LEVEL do
				if TSM.Crafting.ProfessionScanner.GetIndexByCraftString(CraftString.Get(spellId, nil, i)) then
					tinsert(private.recipeLevels, format(L["Rank %d"], i))
					tinsert(private.recipeLevelsKeys, i)
					context.selectedCraftLevel = i
				else
					break
				end
			end
			detailsFrame:GetElement("left.rankDropdown")
				:SetItems(private.recipeLevels, private.recipeLevelsKeys)
				:SetSelectedItemByKey(context.selectedCraftLevel)
				:Show()
				:Draw()
		else
			context.selectedCraftLevel = nil
			detailsFrame:GetElement("left.rankDropdown")
				:SetSelectedItemByKey(nil)
				:Hide()
				:Draw()
		end
		local rank = CraftString.GetRank(context.selectedCraftString)
		local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(context.selectedCraftString, private.optionalMats, rank, context.selectedCraftLevel))
		detailsFrame:GetElement("left.content.icon")
			:SetBackground(resultTexture)
			:SetTooltip(resultTooltip)
			:Show()
		detailsFrame:GetElement("left.content.name")
			:SetText(resultName or "?")
			:SetContext(resultItemString or tostring(context.selectedCraftString))
			:SetTooltip(resultTooltip)
		local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
		detailsFrame:GetElement("content.cost.label")
			:Show()
		detailsFrame:GetElement("content.cost.text")
			:SetText(Money.ToString(craftingCost) or "")
		local _, lNum, hNum, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedCraftString)
		if lNum == hNum then
			detailsFrame:GetElement("left.craft.num")
				:SetFormattedText(L["Crafts %d"], lNum)
		else
			detailsFrame:GetElement("left.craft.num")
				:SetFormattedText(L["Crafts %d - %d"], lNum, hNum)
		end
		local errorText = detailsFrame:GetElement("left.craft.error")
		local canCraft, errStr = false, nil
		if toolsStr and not hasTools then
			errStr = REQUIRES_LABEL.." "..toolsStr
		elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedCraftString) then
			errStr = L["On Cooldown"]
		elseif TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedCraftString, context.selectedCraftLevel) == 0 then
			errStr = L["Missing Materials"]
		else
			canCraft = true
		end
		errorText:SetText(errStr and "("..errStr..")" or "")
		buttonFrame:GetElement("craftBtn")
			:SetText(isEnchant and L["Enchant"] or L["Craft"])
			:SetDisabled(not canCraft or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "craft")
		buttonFrame:GetElement("craftAllBtn")
			:SetText((isEnchant and vellumable) and L["Enchant Vellum"] or L["Craft All"])
			:SetDisabled(not resultItemString or not canCraft or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "all")
		detailsFrame:GetElement("content.matList")
			:SetRecipe(CraftString.GetSpellId(context.selectedCraftString))
			:SetOptionalMats(nil)
			:SetLevel(nil)
		craftingContentFrame:Draw()
		if TSM.Crafting.ProfessionState.IsClassicCrafting() and CraftCreateButton then
			CraftCreateButton:SetParent(buttonFrame:GetElement("craftBtn"):_GetBaseFrame())
			CraftCreateButton:ClearAllPoints()
			CraftCreateButton:SetAllPoints(buttonFrame:GetElement("craftBtn"):_GetBaseFrame())
			CraftCreateButton:SetFrameLevel(200)
			CraftCreateButton:DisableDrawLayer("BACKGROUND")
			CraftCreateButton:DisableDrawLayer("ARTWORK")
			CraftCreateButton:SetHighlightTexture(nil)
			if canCraft then
				CraftCreateButton:Enable()
			else
				CraftCreateButton:Disable()
			end
		end
	end
	function fsmPrivate.UpdateQueueFrame(context, noDataUpdate)
		local queueFrame = context.frame:GetElement("queue")
		local totalCost, totalProfit, totalCastTime, totalNumQueued = TSM.Crafting.Queue.GetTotals()
		queueFrame:GetElement("title"):SetText(format(L["Crafting Queue (%d)"], totalNumQueued))
		queueFrame:GetElement("footer.queueTime.text"):SetText(totalCastTime and SecondsToTime(totalCastTime) or "")
		queueFrame:GetElement("footer.queueCost.text"):SetText(totalCost and Money.ToString(totalCost) or "")
		local color = totalProfit and (totalProfit >= 0 and Theme.GetFeedbackColor("GREEN") or Theme.GetFeedbackColor("RED")) or nil
		local totalProfitText = totalProfit and Money.ToString(totalProfit, color:GetTextColorPrefix()) or ""
		queueFrame:GetElement("footer.queueProfit.text"):SetText(totalProfitText)
		if not noDataUpdate then
			queueFrame:GetElement("queueList"):UpdateData()
		end

		local professionLoaded = private.IsProfessionLoaded()
		local nextCraftRecord = queueFrame:GetElement("queueList"):GetFirstData()
		local nextRecipeString = nextCraftRecord and nextCraftRecord:GetField("recipeString")
		local nextCraftString = nextCraftRecord and CraftString.FromRecipeString(nextRecipeString)
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasCraftString(nextCraftString) or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftString) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		queueFrame:GetElement("footer.craft.craftNextBtn")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "queue")
		if nextCraftRecord and canCraftFromQueue then
			local level = CraftString.GetLevel(nextCraftString)
			TSM.Crafting.ProfessionUtil.PrepareToCraft(nextCraftString, nextRecipeString, nextCraftRecord:GetField("num"), level)
		end
		queueFrame:Draw()
	end
	function fsmPrivate.UpdateCraftButtons(context)
		if context.page == "profession" and private.IsProfessionLoaded() and context.selectedCraftString then
			local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedCraftString)
			local detailsFrame = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details")
			local errorText = detailsFrame:GetElement("left.craft.error")
			local canCraft, errStr = false, nil
			if toolsStr and not hasTools then
				errStr = REQUIRES_LABEL.." "..toolsStr
			elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedCraftString) then
				errStr = L["On Cooldown"]
			-- TODO: handle missing optional mats to disable craft buttons
			elseif TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedCraftString, context.selectedCraftLevel) == 0 then
				errStr = L["Missing Materials"]
			else
				canCraft = true
			end
			errorText:SetText(errStr and "("..errStr..")" or "")
				:Draw()
			local isEnchant, vellumable = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedCraftString)
			local _, resultItemString = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedCraftString)
			detailsFrame:GetElement("__parent.__parent.buttons.craftBtn")
				:SetText(isEnchant and L["Enchant"] or L["Craft"])
				:SetPressed(context.recipeString and context.craftingType == "craft")
				:SetDisabled(not canCraft or context.recipeString)
				:Draw()
			detailsFrame:GetElement("__parent.__parent.buttons.craftAllBtn")
				:SetText((isEnchant and vellumable) and L["Enchant Vellum"] or L["Craft All"])
				:SetPressed(context.recipeString and context.craftingType == "all")
				:SetDisabled(not resultItemString or not canCraft or context.recipeString)
				:Draw()
			local craftString = context.recipeString and CraftString.FromRecipeString(context.recipeString)
			if craftString and context.craftingQuantity and craftString == context.selectedCraftString then
				detailsFrame:GetElement("__parent.__parent.buttons.craftInput")
					:SetValue(context.craftingQuantity)
					:Draw()
			end
			if TSM.IsWowClassic() and CraftCreateButton then
				if canCraft then
					CraftCreateButton:Enable()
				else
					CraftCreateButton:Disable()
				end
			end
		end

		local professionLoaded = private.IsProfessionLoaded()
		local nextCraftRecord = context.frame:GetElement("queue.queueList"):GetFirstData()
		local nextRecipeString = nextCraftRecord and nextCraftRecord:GetField("recipeString")
		local nextCraftString = nextCraftRecord and CraftString.FromRecipeString(nextRecipeString)
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasCraftString(nextCraftString) or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftString) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		context.frame:GetElement("queue.footer.craft.craftNextBtn")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "queue")
			:Draw()
	end
	function fsmPrivate.StartCraft(context, recipeString, quantity)
		local craftString = CraftString.FromRecipeString(recipeString)
		local numCrafted = TSM.Crafting.ProfessionUtil.Craft(craftString, recipeString, quantity, context.craftingType ~= "craft", fsmPrivate.CraftCallback)
		Log.Info("Crafting %d (requested %s) of %s", numCrafted, quantity == math.huge and "all" or quantity, recipeString)
		if numCrafted == 0 then
			return
		end
		context.recipeString = recipeString
		context.craftingQuantity = numCrafted
		fsmPrivate.UpdateCraftButtons(context)
	end

	private.fsm = FSM.New("CRAFTING_UI_CRAFTING")
		:AddState(FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				wipe(private.optionalMats)
				context.page = "profession"
				context.frame = nil
				context.recipeString = nil
				context.craftingQuantity = nil
				context.craftingType = nil
			end)
			:AddTransition("ST_FRAME_CLOSED")
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_OPEN_WITH_PROFESSION")
			:AddEvent("EV_FRAME_SHOW", function(context, frame)
				context.frame = frame
				if private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_WITH_PROFESSION"
				else
					return "ST_FRAME_OPEN_NO_PROFESSION"
				end
			end)
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN_NO_PROFESSION")
			:SetOnEnter(function(context)
				context.recipeString = nil
				context.craftingQuantity = nil
				context.craftingType = nil
				if not context.queueQuery then
					context.queueQuery = TSM.Crafting.Queue.CreateQuery()
					context.queueQuery:SetUpdateCallback(fsmPrivate.QueueUpdateCallback)
				end
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_OPEN_WITH_PROFESSION")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_PROFESSION_STATE_UPDATE", function(context)
				if private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_WITH_PROFESSION"
				end
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_PAGE_CHANGED", function(context, page)
				context.page = page
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_QUEUE_UPDATE", function(context)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
		)
		:AddState(FSM.NewState("ST_FRAME_OPEN_WITH_PROFESSION")
			:SetOnEnter(function(context)
				context.recipeQuery = TSM.Crafting.ProfessionScanner.CreateQuery()
					:Select("craftString", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "craftString")
					:Equal("level", 1)
				context.professionQuery = TSM.Crafting.PlayerProfessions.CreateQuery()
				context.professionQuery:SetUpdateCallback(fsmPrivate.SkillUpdateCallback)
				if context.page == "profession" then
					context.frame:GetElement("left.viewContainer.main.content.profession.header.filterInput")
						:SetValue("")
						:Draw()
					private.filterText = ""
				end
				if context.page == "profession" then
					local recipeList = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
					recipeList:SetQuery(context.recipeQuery)
						:UpdateData(true)
					if context.selectedCraftString and TSM.Crafting.ProfessionScanner.GetIndexByCraftString(context.selectedCraftString) then
						recipeList:SetSelection(context.selectedCraftString)
					end
				end
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateFilter(context)
				fsmPrivate.UpdateQueueFrame(context)
				if not context.queueQuery then
					context.queueQuery = TSM.Crafting.Queue.CreateQuery()
					context.queueQuery:SetUpdateCallback(fsmPrivate.QueueUpdateCallback)
				end
			end)
			:SetOnExit(function(context)
				private.haveSkillUp = false
				private.haveMaterials = false
				context.recipeQuery:Release()
				context.recipeQuery = nil
				context.professionQuery:Release()
				context.professionQuery = nil
			end)
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_PROFESSION_STATE_UPDATE", function(context)
				if not private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_NO_PROFESSION"
				end
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_RECIPE_FILTER_CHANGED", function(context, filter)
				local recipeList = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
				local prevSelection = recipeList:GetSelection()
				context.recipeQuery:Reset()
					:Select("craftString", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "craftString")
					:Equal("level", 1)
				if filter ~= "" then
					filter = String.Escape(filter)
					context.recipeQuery
						:Or()
							:Matches("name", filter)
							:Matches("matNames", filter)
						:End()
				end
				if private.haveSkillUp then
					context.recipeQuery:NotEqual("difficulty", "trivial")
				end
				if private.haveMaterials then
					context.recipeQuery:Custom(private.HaveMaterialsFilterHelper)
				end
				recipeList:UpdateData(true)
				fsmPrivate.UpdateFilter(context)
				if recipeList:GetSelection() ~= prevSelection then
					fsmPrivate.UpdateContentPage(context)
				end
			end)
			:AddEvent("EV_PAGE_CHANGED", function(context, page)
				context.recipeQuery:ResetFilters()
					:Equal("level", 1)
				context.page = page
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_QUEUE_BUTTON_CLICKED", function(context, quantity)
				assert(context.selectedCraftString)
				local spellId = CraftString.GetSpellId(context.selectedCraftString)
				local rank = CraftString.GetRank(context.selectedCraftString)
				TSM.Crafting.Queue.Add(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel), quantity)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
			:AddEvent("EV_QUEUE_RIGHT_CLICKED", function(context, craftString)
				if context.page ~= "profession" or TSM.Crafting.GetProfession(craftString) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() then
					return
				end
				local recipeList = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
				if not recipeList:IsCraftStringVisible(craftString) then
					return
				end
				recipeList:SetSelection(craftString)
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_RECIPE_SELECTION_CHANGED", function(context)
				wipe(private.optionalMats)
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateOptionalMaterials(context)
			end)
			:AddEvent("EV_RECIPE_OPTIONAL_MATS_UPDATED", function(context)
				fsmPrivate.UpdateOptionalMaterials(context)
			end)
			:AddEvent("EV_RECIPE_LEVEL_SELECTION_UPDATED", function(context, level)
				context.selectedCraftLevel = level
				fsmPrivate.UpdateOptionalMaterials(context)
				fsmPrivate.UpdateCraftCost(context)
				fsmPrivate.UpdateMaterials(context)
			end)
			:AddEvent("EV_BAG_UPDATE_DELAYED", function(context)
				fsmPrivate.UpdateMaterials(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:AddEvent("EV_QUEUE_UPDATE", function(context)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
			:AddEvent("EV_SKILL_UPDATE", function(context)
				fsmPrivate.UpdateSkills(context)
			end)
			:AddEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", function(context, quantity, level)
				context.craftingType = quantity == math.huge and "all" or "craft"
				local spellId = CraftString.GetSpellId(context.selectedCraftString)
				local rank = CraftString.GetRank(context.selectedCraftString)
				local recipeString = RecipeString.Get(spellId, private.optionalMats, rank, level)
				TSM.Crafting.ProfessionUtil.PrepareToCraft(context.selectedCraftString, recipeString, quantity, level)
			end)
			:AddEvent("EV_CRAFT_BUTTON_CLICKED", function(context, quantity, level)
				context.craftingType = quantity == math.huge and "all" or "craft"
				local spellId = CraftString.GetSpellId(context.selectedCraftString)
				local rank = CraftString.GetRank(context.selectedCraftString)
				local recipeString = RecipeString.Get(spellId, private.optionalMats, rank, level)
				fsmPrivate.StartCraft(context, recipeString, quantity)
			end)
			:AddEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", function(context, craftString, recipeString, quantity)
				if context.recipeString then
					-- already crafting something
					return
				end
				local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(craftString)
				if (toolsStr and not hasTools) or TSM.Crafting.ProfessionUtil.GetNumCraftable(craftString) == 0 or TSM.Crafting.ProfessionUtil.GetRemainingCooldown(craftString) then
					-- can't craft this
					return
				end
				context.craftingType = "queue"
				fsmPrivate.StartCraft(context, recipeString, quantity)
			end)
			:AddEvent("EV_SPELLCAST_COMPLETE", function(context, success, isDone)
				if success and context.recipeString then
					Log.Info("Crafted %s", context.recipeString)
					TSM.Crafting.Queue.Remove(context.recipeString, 1)
					context.craftingQuantity = context.craftingQuantity - 1
					assert(context.craftingQuantity >= 0)
					if context.craftingQuantity == 0 then
						assert(isDone)
						context.recipeString = nil
						context.craftingQuantity = nil
						context.craftingType = nil
					end
				else
					context.recipeString = nil
					context.craftingQuantity = nil
					context.craftingType = nil
				end
				fsmPrivate.UpdateCraftButtons(context)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
		)
		:AddDefaultEventTransition("EV_FRAME_HIDE", "ST_FRAME_CLOSED")
		:Init("ST_FRAME_CLOSED", fsmContext)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IsProfessionClosed()
	return TSM.Crafting.ProfessionState.GetIsClosed()
end

function private.IsProfessionLoadedNoSkills()
	return not private.IsProfessionClosed() and TSM.Crafting.ProfessionState.GetCurrentProfession() and TSM.Crafting.ProfessionScanner.HasScanned() and not TSM.Crafting.ProfessionScanner.HasSkills()
end

function private.IsProfessionLoaded()
	return not private.IsProfessionClosed() and TSM.Crafting.ProfessionState.GetCurrentProfession() and TSM.Crafting.ProfessionScanner.HasScanned() and TSM.Crafting.ProfessionScanner.HasSkills()
end

function private.IsPlayerProfession()
	return not (TSM.Crafting.ProfessionUtil.IsNPCProfession() or TSM.Crafting.ProfessionUtil.IsLinkedProfession() or TSM.Crafting.ProfessionUtil.IsGuildProfession())
end

function private.HaveMaterialsFilterHelper(row)
	return TSM.Crafting.ProfessionUtil.IsCraftable(row:GetField("craftString"))
end

function private.ItemLinkedCallback(name, itemLink)
	if not private.professionFrame then
		return
	end
	local input = private.professionFrame:GetElement("header.filterInput")
	input:SetValue(ItemInfo.GetName(ItemString.GetBase(itemLink)))
		:SetFocused(false)
		:Draw()

	private.FilterInputOnValueChanged(input)
	return true
end
