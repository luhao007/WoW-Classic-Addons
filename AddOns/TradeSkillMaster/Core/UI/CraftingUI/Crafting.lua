-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Crafting = TSM.UI.CraftingUI:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local CraftString = TSM.Include("Util.CraftString")
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Wow = TSM.Include("Util.Wow")
local Theme = TSM.Include("Util.Theme")
local TextureAtlas = TSM.Include("Util.TextureAtlas")
local ItemString = TSM.Include("Util.ItemString")
local RecipeString = TSM.Include("Util.RecipeString")
local Database = TSM.Include("Util.Database")
local SmartMap = TSM.Include("Util.SmartMap")
local Tooltip = TSM.Include("UI.Tooltip")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Settings = TSM.Include("Service.Settings")
local ItemLinked = TSM.Include("Service.ItemLinked")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	matsDB = nil,
	matsPlayerQuantitySmartMap = nil,
	fsm = nil,
	professions = {},
	professionsKeys = {},
	showDelayFrame = 0,
	filterText = "",
	haveSkillUp = false,
	haveMaterials = false,
	professionFrame = nil,
	optionalMats = {},
	optionalMatOrderTemp = {},
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
		:AddKey("global", "craftingUIContext", "professionDividedContainerBottom")
		:AddKey("char", "craftingUIContext", "groupTree")
		:AddKey("factionrealm", "internalData", "isCraftFavorite")
	ItemLinked.RegisterCallback(private.ItemLinkedCallback, true)
	TSM.UI.CraftingUI.RegisterTopLevelPage(L["Crafting"], private.GetCraftingFrame)
	private.matsDB = Database.NewSchema("CRAFTING_SELECTED_CRAFT_MATS")
		:AddStringField("itemString")
		:AddNumberField("neededQuantity")
		:Commit()
	private.matsPlayerQuantitySmartMap = SmartMap.New("string", "number", TSM.Crafting.ProfessionUtil.GetPlayerMatQuantity)
	BagTracking.RegisterCallback(function() private.matsPlayerQuantitySmartMap:Invalidate() end)
	private.FSMCreate()
end



-- ============================================================================
-- Crafting UI
-- ============================================================================

function private.GetCraftingFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting")
	private.filterText = ""
	local frame = UIElements.New("DividedContainer", "crafting")
		:SetMinWidth(200, TSM.IsWowClassic() and 147 or 189)
		:SetVertical()
		:HideDivider()
		:SetSettingsContext(private.settings, "professionDividedContainerBottom")
		:SetTopChild(UIElements.New("DividedContainer", "top")
			:SetMinWidth(400, 200)
			:HideDivider()
			:SetMargin(0, 0, 0, 2)
			:SetBackgroundColor("FRAME_BG")
			:SetSettingsContext(private.settings, "professionDividedContainer")
			:SetLeftChild(UIElements.New("Frame", "left")
				:SetLayout("VERTICAL")
				:SetMargin(0, 2, 0, 0)
				:AddChild(UIElements.New("Frame", "controls")
					:SetLayout("HORIZONTAL")
					:SetHeight(24)
					:SetMargin(0, 0, 0, 4)
					:AddChild(UIElements.New("SelectionDropdown", "professionDropdown")
						:SetWidth(205)
						:SetMargin(0, 4, 0, 0)
						:SetHintText(L["No Profession Opened"])
						:SetScript("OnSelectionChanged", private.ProfessionDropdownOnSelectionChanged)
					)
					:AddChild(UIElements.New("Input", "filterInput")
						:SetMargin(0, 4, 0, 0)
						:SetIconTexture("iconPack.18x18/Search")
						:SetClearButtonEnabled(true)
						:SetHintText(L["Search Patterns"])
						:SetScript("OnValueChanged", private.FilterInputOnValueChanged)
					)
					:AddChild(UIElements.New("Frame", "buttons")
						:SetLayout("HORIZONTAL")
						:SetSize(48, 24)
						:SetBackgroundColor("PRIMARY_BG_ALT", true)
						:AddChild(UIElements.New("Button", "groupsBtn")
							:SetMargin(4, 10, 0, 0)
							:SetBackgroundAndSize("iconPack.14x14/Groups")
							:SetScript("OnClick", private.CreateProfessionBtnOnClick)
							:SetTooltip(L["Create Profession Groups"])
						)
						:AddChild(UIElements.New("Button", "filterBtn")
							:SetBackgroundAndSize("iconPack.14x14/Filter")
							:SetHighlightLocked(private.haveSkillUp or private.haveMaterials)
							:SetScript("OnClick", private.FilterButtonOnClick)
						)
					)
				)
				:AddChild(UIElements.New("Frame", "content")
					:SetLayout("VERTICAL")
					:SetPadding(1)
					:SetBackgroundColor("PRIMARY_BG")
					:SetBorderColor("ACTIVE_BG", 1)
					:AddChild(UIElements.New("ProfessionScrollingTable", "recipeList")
						:SetFavoritesContext(private.settings.isCraftFavorite)
						:SetSettingsContext(private.settings, "professionScrollingTable")
						:SetScript("OnSelectionChanged", private.RecipeListOnSelectionChanged)
						:SetScript("OnRowClick", private.RecipeListOnRowClick)
					)
				)
			)
			:SetRightChild(UIElements.New("Frame", "right")
				:SetLayout("VERTICAL")
				:SetMargin(2, 0, 0, 0)
				:AddChild(UIElements.New("GroupSelector", "restock")
					:SetMargin(0, 0, 0, 4)
					:SetDialogInfo(364, 386, L["Restock Groups"], L["Restock Selected Groups"])
					:SetHeight(24)
					:SetText(L["Restock Groups"])
					:SetScript("OnSelectionChanged", private.RestockOnSelectionChanged)
				)
				:AddChild(UIElements.New("Frame", "queue")
					:SetLayout("VERTICAL")
					:SetBackgroundColor("PRIMARY_BG")
					:SetPadding(1)
					:SetBorderColor("ACTIVE_BG", 1)
					:AddChild(UIElements.New("Frame", "header")
						:SetLayout("HORIZONTAL")
						:SetHeight(20)
						:SetPadding(4, 4, 0, 0)
						:SetBackgroundColor("PRIMARY_BG_ALT")
						:AddChild(UIElements.New("Text", "title")
							:SetFont("BODY_BODY3_MEDIUM")
							:SetText(format(L["Queue (%d)"], 0))
						)
						:AddChild(UIElements.New("Spacer", "spacer"))
						:AddChild(UIElements.New("Button", "info")
							:SetSize(12, 12)
							:SetBackground("iconPack.12x12/Attention")
							:SetTooltip(private.QueueTooltipFunc)
						)
					)
					:AddChild(TSM.UI.Views.Line.NewHorizontal("line")
						:SetMargin(0, 0, 0, 4)
					)
					:AddChild(UIElements.New("CraftingQueueList", "queueList")
						:SetQuery(TSM.Crafting.CreateQueueQuery())
						:SetScript("OnRowMouseDown", private.QueueOnRowMouseDown)
						:SetScript("OnRowClick", private.QueueOnRowClick)
					)
					:AddChild(TSM.UI.Views.Line.NewHorizontal("line2"))
					:AddChild(UIElements.New("Frame", "footer")
						:SetLayout("HORIZONTAL")
						:SetHeight(24)
						:SetMargin(8, 8, 8, 8)
						:AddChild(UIElements.NewNamed("ActionButton", "craftNextBtn", "TSMCraftingBtn")
							:SetMargin(0, 8, 0, 0)
							:SetText(L["Craft Next"])
							:SetScript("OnClick", private.CraftNextOnClick)
						)
						:AddChild(UIElements.New("Button", "clearBtn")
							:SetWidth(70)
							:SetFont("BODY_BODY3_MEDIUM")
							:SetText(L["Clear All"])
							:SetTextColor("INDICATOR")
							:SetScript("OnClick", private.ClearOnClick)
						)
					)
				)
			)
		)
		:SetBottomChild(UIElements.New("Frame", "details")
			:SetLayout("VERTICAL")
			:SetMargin(0, 0, 2, 0)
			:SetPadding(5)
			:SetBorderColor("ACTIVE_BG", 1)
			:SetBackgroundColor("PRIMARY_BG", true)
			:AddChild(UIElements.New("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetHeight(28)
				:SetPadding(0, 0, 0, 4)
				:AddChild(UIElements.New("Button", "icon")
					:SetSize(20, 20)
					:SetMargin(8, 4, 0, 0)
					:SetScript("OnClick", private.ItemOnClick)
				)
				:AddChild(UIElements.New("Button", "name")
					:SetHeight(24)
					:SetWidth("AUTO")
					:SetFont("ITEM_BODY1")
					:SetJustifyH("LEFT")
					:SetScript("OnClick", private.ItemOnClick)
				)
				:AddChild(UIElements.New("Text", "craftNum")
					:SetMargin(4, 0, 0, 0)
					:SetWidth("AUTO")
					:SetFont("ITEM_BODY1")
					:SetTextColor("INDICATOR")
					:SetJustifyH("LEFT")
				)
				:AddChild(UIElements.New("SelectionDropdown", "rankDropdown")
					:SetSize(80, 20)
					:SetMargin(12, 0, 0, 0)
					:SetScript("OnSelectionChanged", private.RankDropdownOnSelectionChanged)
				)
				:AddChild(UIElements.New("Text", "rankText")
					:SetWidth("AUTO")
					:SetMargin(12, 0, 0, 0)
				)
				:AddChild(TSM.UI.Views.Line.NewVertical("line")
					:SetMargin(12, 12, 2, 2)
				)
				:AddChild(UIElements.New("Text", "craftingCostLabel")
					:SetWidth("AUTO")
					:SetMargin(0, 4, 0, 0)
					:SetFont("BODY_BODY3")
					:SetText(L["Crafting Cost"]..":")
				)
				:AddChild(UIElements.New("Text", "craftingCostText")
					:SetWidth("AUTO")
					:SetMargin(0, 0, 0, 0)
					:SetFont("TABLE_TABLE1")
				)
				:AddChild(TSM.UI.Views.Line.NewVertical("line")
					:SetMargin(12, 12, 2, 2)
				)
				:AddChild(UIElements.New("Text", "error")
					:SetWidth("AUTO")
					:SetFont("BODY_BODY3_MEDIUM")
					:SetTextColor("FEEDBACK_RED")
				)
				:AddChild(UIElements.New("Spacer", "spacer"))
			)
			:AddChild(TSM.UI.Views.Line.NewHorizontal("line"))
			:AddChild(UIElements.New("Frame", "content")
				:SetLayout("HORIZONTAL")
				:AddChild(UIElements.New("Frame", "mats")
					:SetLayout("VERTICAL")
					:SetMargin(8, 12, 4, 4)
					:AddChild(UIElements.New("CraftingMatList", "matList")
						:SetQuery(private.matsDB:NewQuery()
							:Select("itemString", "coloredItemName", "texture", "neededQuantity", "playerQuantity")
							:VirtualField("texture", "number", ItemInfo.GetTexture, "itemString", ItemInfo.GetTexture(ItemString.GetUnknown()))
							:VirtualSmartMapField("playerQuantity", private.matsPlayerQuantitySmartMap, "itemString")
							:VirtualField("coloredItemName", "string", TSM.UI.GetColoredItemName, "itemString", Theme.GetColor("FEEDBACK_RED"):ColorText("?"))
						)
					)
					:AddChild(UIElements.New("ActionButton", "optionalMatsBtn")
						:SetHeight(20)
						:SetMargin(0, 0, 4, 0)
						:SetText(L["Optional Reagents"])
						:SetFont("BODY_BODY3_MEDIUM")
						:SetScript("OnClick", private.OptionalMatsOnClick)
					)
				)
				:AddChild(UIElements.New("Frame", "buttons")
					:SetLayout("VERTICAL")
					:SetWidth(230)
					:SetMargin(12, 4, 4, 4)
					:AddChild(UIElements.New("Frame", "quantity")
						:SetLayout("HORIZONTAL")
						:AddChild(UIElements.New("ActionButton", "decrease")
							:SetWidth("AUTO")
							:SetMargin(0, 4, 0, 0)
							:SetText(TextureAtlas.GetTextureLink(TextureAtlas.GetFlippedHorizontallyKey("iconPack.18x18/Caret/Right")))
							:DisableClickCooldown()
							:SetScript("OnClick", private.QuantityDecreaseOnClick)
						)
						:AddChild(UIElements.New("Input", "input")
							:SetMargin(0, 4, 0, 0)
							:SetBackgroundColor("FRAME_BG")
							:SetFont("BODY_BODY2_BOLD")
							:SetJustifyH("CENTER")
							:SetValidateFunc("NUMBER", "1:9999")
							:SetValue(1)
						)
						:AddChild(UIElements.New("ActionButton", "increase")
							:SetWidth("AUTO")
							:SetMargin(0, 4, 0, 0)
							:SetText(TextureAtlas.GetTextureLink("iconPack.18x18/Caret/Right"))
							:DisableClickCooldown()
							:SetScript("OnClick", private.QuantityIncreaseOnClick)
						)
						:AddChild(UIElements.New("ActionButton", "maxBtn")
							:SetWidth("AUTO")
							:SetPadding(4, 4, 0, 0)
							:SetFont("BODY_BODY2_BOLD")
							:SetText(L["MAX"])
							:DisableClickCooldown()
							:SetScript("OnClick", private.MaxBtnOnClick)
						)
					)
					:AddChild(UIElements.New("Frame", "content")
						:SetLayout("HORIZONTAL")
						:SetMargin(0, 0, 6, 6)
						:AddChild(UIElements.New("ActionButton", "craftBtn")
							:SetWidth(80)
							:SetMargin(0, 6, 0, 0)
							:SetText(L["Craft"])
							:SetScript("OnMouseDown", private.CraftBtnOnMouseDown)
							:SetScript("OnClick", private.CraftBtnOnClick)
						)
						:AddChild(UIElements.New("ActionButton", "craftVellumBtn")
							:SetWidth(144)
							:SetMargin(0, 0, 0, 0)
							:SetText(L["Craft Vellum"])
							:SetScript("OnMouseDown", private.CraftVellumBtnOnMouseDown)
							:SetScript("OnClick", private.CraftVellumBtnOnClick)
						)
					)
					:AddChild(UIElements.New("ActionButton", "queueBtn")
						:SetText(L["Queue"])
						:DisableClickCooldown()
						:SetScript("OnClick", private.QueueBtnOnClick)
					)
				)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)

	private.professionFrame = frame
	return frame
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
	assert(private.professionFrame)
	private.professionFrame = nil
	private.showDelayFrame = 0
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.CreateProfessionBtnOnClick(button)
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
		if itemString and not TSM.Groups.IsItemInGroup(itemString) and not ItemInfo.IsSoulbound(itemString) and classId ~= Enum.ItemClass.Weapon and classId ~= Enum.ItemClass.Armor then
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

function private.RestockOnSelectionChanged(groupSelector)
	local groups = TempTable.Acquire()
	for groupPath in groupSelector:SelectedGroupIterator() do
		tinsert(groups, groupPath)
	end
	TSM.Crafting.Queue.RestockGroups(groups)
	TempTable.Release(groups)
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
	local value = max(tonumber(button:GetElement("__parent.quantity.input"):GetValue()), 1)
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

function private.QuantityDecreaseOnClick(button)
	local input = button:GetElement("__parent.input")
	input:Subtract()
end

function private.QuantityIncreaseOnClick(button)
	local input = button:GetElement("__parent.input")
	input:Add()
end

function private.OptionalMatsOnClick(button)
	button:GetBaseElement():ShowDialogFrame(UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetSize(478, 368)
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
	local level = viewContainer:GetContext():GetElement("__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
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
			if strmatch(matList, "^q:") then
				row:GetElement("title.removeBtn")
					:Hide()
			else
				row:GetElement("title.removeBtn")
					:Show()
			end
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
	local level = button:GetBaseElement():GetElement("content.crafting.details.header.rankDropdown"):GetSelectedItemKey()
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
	local slotId, matList = strmatch(viewContainer:GetParentElement():GetContext(), "^[qof]:(%d):(.+)")
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
				:SetBackgroundAndSize(TextureAtlas.GetFlippedHorizontallyKey("iconPack.18x18/Chevron/Right"))
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
			:SetHeight(274)
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

function private.MaxBtnOnClick(button)
	local selectedCraftString = button:GetContext()
	local spellId = CraftString.GetSpellId(selectedCraftString)
	local rank = CraftString.GetRank(selectedCraftString)
	local level = button:GetElement("__parent.__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
	local numCraft = TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, level))
	if numCraft < 1 then
		return
	end
	button:GetElement("__parent.input")
		:SetValue(numCraft)
		:Draw()
end

function private.CraftBtnOnMouseDown(button)
	local quantity = max(tonumber(button:GetElement("__parent.__parent.quantity.input"):GetValue()), 1)
	local level = button:GetElement("__parent.__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", quantity, level)
end

function private.CraftBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local quantity = max(tonumber(button:GetElement("__parent.__parent.quantity.input"):GetValue()), 1)
	local level = button:GetElement("__parent.__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", quantity, level)
end

function private.CraftVellumBtnOnMouseDown(button)
	local level = button:GetElement("__parent.__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", math.huge, level)
end

function private.CraftVellumBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local level = button:GetElement("__parent.__parent.__parent.__parent.header.rankDropdown"):GetSelectedItemKey()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", math.huge, level)
end

function private.QueueTooltipFunc()
	local tooltipLines = TempTable.Acquire()
	tinsert(tooltipLines, Theme.GetColor("INDICATOR"):ColorText(L["Queue Summary"]))
	local totalCost, totalProfit, totalCastTime = TSM.Crafting.Queue.GetTotals()
	local totalCostStr = totalCost and Money.ToString(totalCost, nil, "OPT_RETAIL_ROUND") or "---"
	local totalProfitStr =  totalProfit and Money.ToString(totalProfit, Theme.GetColor(totalProfit >= 0 and "FEEDBACK_GREEN" or "FEEDBACK_RED"):GetTextColorPrefix(), "OPT_RETAIL_ROUND") or "---"
	local totalCastTimeStr = totalCastTime and SecondsToTime(totalCastTime) or "---"
	tinsert(tooltipLines, L["Crafting Cost"]..":"..Tooltip.GetSepChar()..totalCostStr)
	tinsert(tooltipLines, L["Estimated Profit"]..":"..Tooltip.GetSepChar()..totalProfitStr)
	tinsert(tooltipLines, L["Estimated Time"]..":"..Tooltip.GetSepChar()..totalCastTimeStr)
	return strjoin("\n", TempTable.UnpackAndRelease(tooltipLines)), true, 16
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
	local recipeString = button:GetElement("__parent.__parent.queueList"):GetFirstData():GetField("recipeString")
	local craftString = CraftString.FromRecipeString(recipeString)
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", craftString, recipeString, TSM.Crafting.Queue.GetNum(recipeString))
end

function private.ClearOnClick(button)
	TSM.Crafting.Queue.Clear()
	button:GetElement("__parent.__parent.header.title")
		:SetText(format(L["Queue (%d)"], 0))
		:Draw()
	button:GetElement("__parent.craftNextBtn")
		:SetDisabled(true)
		:Draw()
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
	fsmPrivate.craftTimer = Delay.CreateTimer("CRAFTING_CRAFT", function()
		private.fsm:ProcessEvent("EV_SPELLCAST_COMPLETE", fsmPrivate.success, fsmPrivate.isDone)
		fsmPrivate.success = nil
		fsmPrivate.isDone = nil
	end)
	function fsmPrivate.UpdateMatsDB(context)
		local spellId = context.selectedCraftString and CraftString.GetSpellId(context.selectedCraftString)
		if not spellId then
			private.matsDB:Truncate()
			return
		end
		private.matsDB:TruncateAndBulkInsertStart()
		local numMats = TSM.Crafting.ProfessionUtil.GetNumMats(spellId, context.selectedCraftLevel)
		for i = 1, numMats do
			local itemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(spellId, i, context.selectedCraftLevel)
			local itemString = ItemString.Get(itemLink)
			private.matsDB:BulkInsertNewRow(itemString, quantity)
		end
		assert(not next(private.optionalMatOrderTemp))
		for slotId in pairs(private.optionalMats) do
			tinsert(private.optionalMatOrderTemp, slotId)
		end
		sort(private.optionalMatOrderTemp)
		for _, slotId in ipairs(private.optionalMatOrderTemp) do
			local itemString = "i:"..private.optionalMats[slotId]
			private.matsDB:BulkInsertNewRow(itemString, TSM.Crafting.GetOptionalMatQuantity(context.selectedCraftString, private.optionalMats[slotId]))
		end
		wipe(private.optionalMatOrderTemp)
		private.matsDB:BulkInsertEnd()
	end
	function fsmPrivate.CraftCallback(success, isDone)
		fsmPrivate.success = success
		fsmPrivate.isDone = isDone
		fsmPrivate.craftTimer:RunForFrames(1)
	end
	function fsmPrivate.QueueUpdateCallback()
		private.fsm:ProcessEvent("EV_QUEUE_UPDATE")
	end
	function fsmPrivate.SkillUpdateCallback()
		private.fsm:ProcessEvent("EV_SKILL_UPDATE")
	end
	function fsmPrivate.UpdateCraftCost(context)
		if context.selectedCraftString then
			local spellId = CraftString.GetSpellId(context.selectedCraftString)
			local rank = CraftString.GetRank(context.selectedCraftString)
			local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
			context.frame:GetElement("details.header.craftingCostLabel")
				:Show()
			context.frame:GetElement("details.header.craftingCostText")
				:SetText(Money.ToString(craftingCost, nil, "OPT_RETAIL_ROUND") or "")
				:Draw()
		end
	end
	function fsmPrivate.UpdateMaterials(context)
		context.frame:GetElement("top.left.content.recipeList")
			:UpdateData(true)
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

		context.frame:GetElement("top.left.controls.professionDropdown")
			:SetItems(private.professions, private.professionsKeys)
			:SetSelectedItemByKey(dropdownSelection, true)
			:Draw()
	end
	function fsmPrivate.UpdateSkills(context)
		fsmPrivate.UpdateProfessionsDropdown(context)
	end
	function fsmPrivate.UpdateFilter(context)
		context.frame:GetElement("top.left.controls.buttons.filterBtn"):SetHighlightLocked(private.haveSkillUp or private.haveMaterials, "INDICATOR")
			:Draw()
	end
	function fsmPrivate.UpdateRecipeTooltip(context)
		if not context.selectedCraftString then
			-- clicked on a category row
			return
		end
		local rank = CraftString.GetRank(context.selectedCraftString)
		local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(context.selectedCraftString, private.optionalMats, rank, context.selectedCraftLevel))
		context.frame:GetElement("details.header.icon")
			:SetTooltip(resultTooltip)
			:Draw()
		context.frame:GetElement("details.header.name")
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
		for _, itemString, dataSlotIndex in TSM.Crafting.QualityMatIterator(context.selectedCraftString) do
			local _, matList = strmatch(itemString, "q:(%d):(.+)")
			if not private.optionalMats[dataSlotIndex] then
				private.optionalMats[dataSlotIndex] = strmatch(matList, "^(%d+)")
			end
		end
		fsmPrivate.UpdateRecipeTooltip(context)
		local spellId = CraftString.GetSpellId(context.selectedCraftString)
		local rank = CraftString.GetRank(context.selectedCraftString)
		local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
		context.frame:GetElement("details.header.craftingCostLabel")
			:Show()
		context.frame:GetElement("details.header.craftingCostText")
			:SetText(Money.ToString(craftingCost, nil, "OPT_RETAIL_ROUND") or "")
			:Draw()
		fsmPrivate.UpdateMatsDB(context)
	end
	function fsmPrivate.UpdateContentPage(context)
		fsmPrivate.UpdateProfessionsDropdown(context)

		if not private.IsProfessionLoaded() then
			return
		end

		local recipeList = context.frame:GetElement("top.left.content.recipeList")
		recipeList:SetQuery(fsmContext.recipeQuery)
		context.selectedCraftString = recipeList:GetSelection()
		local buttonFrame = context.frame:GetElement("details.content.buttons")
		local headerFrame = context.frame:GetElement("details.header")
		local matsFrame = context.frame:GetElement("details.content.mats")
		if not context.selectedCraftString then
			buttonFrame:GetElement("content.craftBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.decrease")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.input")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.increase")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.maxBtn")
				:SetDisabled(true)
			buttonFrame:Draw()
			headerFrame:GetElement("icon")
				:Hide()
			headerFrame:GetElement("name")
				:SetText("")
				:SetContext(nil)
				:SetTooltip(nil)
			headerFrame:GetElement("rankText")
				:SetText("")
				:Hide()
			headerFrame:GetElement("craftingCostText")
				:SetText("")
			headerFrame:GetElement("craftingCostLabel")
				:Hide()
			-- detailsFrame:GetElement("left.craft.num")
			-- 	:SetText("")
			headerFrame:GetElement("error")
				:SetText(L["No receipe selected"])
			fsmPrivate.UpdateMatsDB(context)
			headerFrame:Draw()
			return
		end
		local resultName, resultItemString, resultTexture = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedCraftString)
		-- engineer tinkers can't be crafted, multi-crafted or queued
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		local isEnchant, vellumable = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedCraftString)
		if not resultItemString then
			buttonFrame:GetElement("content.craftBtn")
				:SetWidth(vellumable and 80 or 230)
				:SetText(isEnchant and L["Enchant"] or (currentProfession == GetSpellInfo(4036) and L["Tinker"] or L["Craft"]))
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.decrease")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.input")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.increase")
				:SetDisabled(true)
			buttonFrame:GetElement("quantity.maxBtn")
				:SetDisabled(true)
		else
			buttonFrame:GetElement("content.craftBtn")
				:SetWidth(vellumable and 80 or 230)
				:SetText(L["Craft"])
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(false)
			buttonFrame:GetElement("quantity.decrease")
				:SetDisabled(false)
			buttonFrame:GetElement("quantity.input")
				:SetDisabled(false)
			buttonFrame:GetElement("quantity.increase")
				:SetDisabled(false)
			buttonFrame:GetElement("quantity.maxBtn")
				:SetDisabled(false)
		end
		buttonFrame:GetElement("quantity.maxBtn")
			:SetContext(context.selectedCraftString)
		if TSM.Crafting.HasOptionalMats(context.selectedCraftString) then
			matsFrame:GetElement("optionalMatsBtn")
				:SetContext(context.selectedCraftString)
				:Show()
				:Draw()
		else
			matsFrame:GetElement("optionalMatsBtn")
				:Hide()
				:Draw()
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
			context.frame:GetElement("details.header.rankDropdown")
				:SetItems(private.recipeLevels, private.recipeLevelsKeys)
				:SetSelectedItemByKey(context.selectedCraftLevel)
				:Show()
				:Draw()
		else
			context.selectedCraftLevel = nil
			context.frame:GetElement("details.header.rankDropdown")
				:SetSelectedItemByKey(nil)
				:Hide()
				:Draw()
		end
		local rank = CraftString.GetRank(context.selectedCraftString)
		local resultTooltip = TSM.Crafting.ProfessionUtil.GetCraftResultTooltipFromRecipeString(RecipeString.FromCraftString(context.selectedCraftString, private.optionalMats, rank, context.selectedCraftLevel))
		headerFrame:GetElement("icon")
			:SetBackground(resultTexture)
			:SetTooltip(resultTooltip)
			:Show()
		headerFrame:GetElement("name")
			:SetText(resultName or "?")
			:SetContext(resultItemString or tostring(context.selectedCraftString))
			:SetTooltip(resultTooltip)
			:Show()
		local rankText = private.GetRankText(context.selectedCraftString)
		if rankText then
			headerFrame:GetElement("rankText")
				:SetText(rankText)
				:Show()
		else
			headerFrame:GetElement("rankText")
				:Hide()
		end
		local craftingCost = TSM.Crafting.Cost.GetCostsByRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel))
		headerFrame:GetElement("craftingCostLabel")
			:Show()
		headerFrame:GetElement("craftingCostText")
			:SetText(Money.ToString(craftingCost, nil, "OPT_RETAIL_ROUND") or "")
		local _, lNum, hNum = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedCraftString)
		if lNum == hNum then
			if lNum < 2 then
				headerFrame:GetElement("craftNum")
					:Hide()
			else
				headerFrame:GetElement("craftNum")
					:SetFormattedText("(%d)", lNum)
					:Show()
			end
		else
			headerFrame:GetElement("craftNum")
				:SetFormattedText("(%d-%d)", lNum, hNum)
				:Show()
		end
		local canCraft, errStr = false, nil
		local toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeToolInfo(context.selectedCraftString)
		if toolsStr and not hasTools then
			errStr = REQUIRES_LABEL.." "..toolsStr
		elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedCraftString) then
			errStr = L["On Cooldown"]
		elseif TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, level)) == 0 then
			errStr = L["Missing Materials"]
		else
			canCraft = true
		end
		headerFrame:GetElement("error")
			:SetText(errStr or "")
		buttonFrame:GetElement("content.craftBtn")
			:SetDisabled(not canCraft or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "craft")
		if vellumable then
			buttonFrame:GetElement("content.craftVellumBtn")
				:SetPressed(context.recipeString and context.craftingType == "all")
				:SetDisabled(not resultItemString or not canCraft or context.recipeString)
				:Show()
		else
			buttonFrame:GetElement("content.craftVellumBtn")
				:Hide()
		end
		fsmPrivate.UpdateMatsDB(context)
		headerFrame:Draw()
		buttonFrame:Draw()
		if TSM.Crafting.ProfessionState.IsClassicCrafting() and CraftCreateButton then
			CraftCreateButton:SetParent(buttonFrame:GetElement("content.craftBtn"):_GetBaseFrame())
			CraftCreateButton:ClearAllPoints()
			CraftCreateButton:SetAllPoints(buttonFrame:GetElement("content.craftBtn"):_GetBaseFrame())
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
		local queueFrame = context.frame:GetElement("top.right.queue")
		queueFrame:GetElement("header.title")
			:SetText(format(L["Queue (%d)"], TSM.Crafting.Queue.GetNumItems()))
		if not noDataUpdate then
			queueFrame:GetElement("queueList"):UpdateData()
		end

		local professionLoaded = private.IsProfessionLoaded()
		local nextCraftRecord = queueFrame:GetElement("queueList"):GetFirstData()
		local nextRecipeString = nextCraftRecord and nextCraftRecord:GetField("recipeString")
		local nextCraftString = nextCraftRecord and CraftString.FromRecipeString(nextRecipeString)
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasCraftString(nextCraftString) or TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(nextRecipeString) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		queueFrame:GetElement("footer.craftNextBtn")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.recipeString)
			:SetPressed(context.recipeString and context.craftingType == "queue")
		if nextCraftRecord and canCraftFromQueue then
			local level = CraftString.GetLevel(nextCraftString)
			TSM.Crafting.ProfessionUtil.PrepareToCraft(nextCraftString, nextRecipeString, nextCraftRecord:GetField("num"), level)
		end
		queueFrame:Draw()
	end
	function fsmPrivate.UpdateCraftButtons(context)
		if private.IsProfessionLoaded() and context.selectedCraftString then
			local toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeToolInfo(context.selectedCraftString)
			local detailsFrame = context.frame:GetElement("details")
			local headerFrame = detailsFrame:GetElement("header")
			local canCraft, errStr = false, nil
			local spellId = CraftString.GetSpellId(context.selectedCraftString)
			local rank = CraftString.GetRank(context.selectedCraftString)
			local level = detailsFrame:GetElement("header.rankDropdown"):GetSelectedItemKey()
			if toolsStr and not hasTools then
				errStr = REQUIRES_LABEL.." "..toolsStr
			elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedCraftString) then
				errStr = L["On Cooldown"]
			elseif TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(RecipeString.Get(spellId, private.optionalMats, rank, level)) == 0 then
				errStr = L["Missing Materials"]
			else
				canCraft = true
			end
			headerFrame:GetElement("error")
				:SetText(errStr or "")
			headerFrame:Draw()
			local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
			local isEnchant, vellumable = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedCraftString)
			local _, resultItemString = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedCraftString)
			detailsFrame:GetElement("content.buttons.content.craftBtn")
				:SetWidth(vellumable and 80 or 230)
				:SetText(isEnchant and L["Enchant"] or (currentProfession == GetSpellInfo(4036) and L["Tinker"] or L["Craft"]))
				:SetPressed(context.recipeString and context.craftingType == "craft")
				:SetDisabled(not canCraft or context.recipeString)
				:Draw()
			if vellumable then
				detailsFrame:GetElement("content.buttons.content.craftVellumBtn")
					:SetPressed(context.recipeString and context.craftingType == "all")
					:SetDisabled(not resultItemString or not canCraft or context.recipeString)
					:Show()
					:Draw()
			else
				detailsFrame:GetElement("content.buttons.content.craftVellumBtn")
					:Hide()
			end
			local craftString = context.recipeString and CraftString.FromRecipeString(context.recipeString)
			local input = detailsFrame:GetElement("content.buttons.quantity.input")
			if craftString and context.craftingQuantity and craftString == context.selectedCraftString then
				input:SetValue(context.craftingQuantity)
					:Draw()
			else
				input:SetValue(1)
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
		local nextCraftRecord = context.frame:GetElement("top.right.queue.queueList"):GetFirstData()
		local nextRecipeString = nextCraftRecord and nextCraftRecord:GetField("recipeString")
		local nextCraftString = nextCraftRecord and CraftString.FromRecipeString(nextRecipeString)
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasCraftString(nextCraftString) or TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(nextRecipeString) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		context.frame:GetElement("top.right.queue.footer.craftNextBtn")
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
				context.frame = nil
				context.recipeString = nil
				context.craftingQuantity = nil
				context.craftingType = nil
				context.selectedCraftString = nil
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
				context.frame:GetBaseElement():HideDialog()
				context.recipeString = nil
				context.craftingQuantity = nil
				context.craftingType = nil
				context.selectedCraftString = nil
				wipe(private.optionalMats)
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
				context.frame:GetElement("top.left.controls.filterInput")
					:SetValue("")
					:Draw()
				private.filterText = ""
				local recipeList = context.frame:GetElement("top.left.content.recipeList")
				recipeList:SetQuery(context.recipeQuery)
					:UpdateData(true)
				if context.selectedCraftString and TSM.Crafting.ProfessionScanner.GetIndexByCraftString(context.selectedCraftString) then
					recipeList:SetSelection(context.selectedCraftString)
				end
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateOptionalMaterials(context)
				fsmPrivate.UpdateCraftButtons(context)
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
				context.selectedCraftString = nil
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
				local recipeList = context.frame:GetElement("top.left.content.recipeList")
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
					context.recipeQuery:NotEqual("difficulty", TSM.IsWowClassic() and "trivial" or Enum.TradeskillRelativeDifficulty.Trivial)
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
			:AddEvent("EV_QUEUE_BUTTON_CLICKED", function(context, quantity)
				assert(context.selectedCraftString)
				local spellId = CraftString.GetSpellId(context.selectedCraftString)
				local rank = CraftString.GetRank(context.selectedCraftString)
				TSM.Crafting.Queue.Add(RecipeString.Get(spellId, private.optionalMats, rank, context.selectedCraftLevel), quantity)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
			:AddEvent("EV_QUEUE_RIGHT_CLICKED", function(context, craftString)
				if TSM.Crafting.GetProfession(craftString) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() then
					return
				end
				local recipeList = context.frame:GetElement("top.left.content.recipeList")
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
				fsmPrivate.UpdateCraftButtons(context)
			end)
			:AddEvent("EV_RECIPE_OPTIONAL_MATS_UPDATED", function(context)
				fsmPrivate.UpdateOptionalMaterials(context)
				fsmPrivate.UpdateCraftButtons(context)
			end)
			:AddEvent("EV_RECIPE_LEVEL_SELECTION_UPDATED", function(context, level)
				context.selectedCraftLevel = level
				fsmPrivate.UpdateOptionalMaterials(context)
				fsmPrivate.UpdateCraftCost(context)
				fsmPrivate.UpdateMatsDB(context)
				fsmPrivate.UpdateMaterials(context)
			end)
			:AddEvent("EV_BAG_UPDATE_DELAYED", function(context)
				fsmPrivate.UpdateQueueFrame(context)
				fsmPrivate.UpdateMaterials(context)
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
				local toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeToolInfo(craftString)
				if (toolsStr and not hasTools) or TSM.Crafting.ProfessionUtil.GetNumCraftableRecipeString(recipeString) == 0 or TSM.Crafting.ProfessionUtil.GetRemainingCooldown(craftString) then
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
	local input = private.professionFrame:GetElement("top.left.controls.filterInput")
	input:SetValue(ItemInfo.GetName(ItemString.GetBase(itemLink)))
		:SetFocused(false)
		:Draw()

	private.FilterInputOnValueChanged(input)
	return true
end

function private.GetRankText(craftString)
	local rank = CraftString.GetRank(craftString) or -1
	local level = CraftString.GetLevel(craftString) or -1
	if rank == -1 and level == -1 then
		return
	end
	if rank > 0 then
		local filled = TextureAtlas.GetTextureLink("iconPack.14x14/Star/Filled")
		local unfilled = TextureAtlas.GetTextureLink("iconPack.14x14/Star/Unfilled")
		assert(rank >= 1 and rank <= 3)
		return strrep(filled, rank)..strrep(unfilled, 3 - rank)
	end
	if level > 0 then
		local currExp = TSM.Crafting.ProfessionScanner.GetCurrentExpByCraftString(craftString)
		local nextExp = TSM.Crafting.ProfessionScanner.GetNextExpByCraftString(craftString)
		return currExp >= 0 and format("%s / %s", currExp, nextExp) or L["Max"]
	end
end
