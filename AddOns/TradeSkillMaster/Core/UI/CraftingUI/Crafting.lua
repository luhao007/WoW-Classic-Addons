-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.UI.CraftingUI:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local Delay = TSM.Include("Util.Delay")
local FSM = TSM.Include("Util.FSM")
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Wow = TSM.Include("Util.Wow")
local Theme = TSM.Include("Util.Theme")
local ItemString = TSM.Include("Util.ItemString")
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
}
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

function Crafting.GatherCraftNext(spellId, quantity)
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, quantity)
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
				:SetQuery(TSM.Crafting.CreateCraftsQuery()
					:IsNotNil("num")
					:GreaterThan("num", 0)
				)
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
				)
				:AddChild(UIElements.New("Texture", "line")
					:SetHeight(2)
					:SetTexture("ACTIVE_BG")
				)
				:AddChild(UIElements.New("Frame", "details")
					:SetLayout("HORIZONTAL")
					:SetHeight(120)
					:SetPadding(8, 0, 8, 8)
					:SetBackgroundColor("PRIMARY_BG_ALT")
					:AddChild(UIElements.New("Frame", "left")
						:SetLayout("VERTICAL")
						:SetWidth(234)
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
						:AddChild(UIElements.New("Frame", "cost")
							:SetLayout("HORIZONTAL")
							:SetHeight(20)
							:SetMargin(0, 0, 8, 0)
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
					)
					:AddChild(UIElements.New("Texture", "line")
						:SetWidth(2)
						:SetTexture("ACTIVE_BG")
					)
					:AddChild(UIElements.New("CraftingMatList", "matList")
						:SetBackgroundColor("PRIMARY_BG_ALT")
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
		:Select("spellId")

	for _, spellId in query:IteratorAndRelease() do
		local itemString = TSM.Crafting.GetItemString(spellId)
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
		CraftFrame_SetSelection(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(selection))
	end

	private.fsm:ProcessEvent("EV_RECIPE_SELECTION_CHANGED")
	if selection and IsShiftKeyDown() then
		local item = TSM.Crafting.ProfessionUtil.GetRecipeInfo(selection)
		ChatEdit_InsertLink(item)
	end
end

function private.QueueBtnOnClick(button)
	local value = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	private.fsm:ProcessEvent("EV_QUEUE_BUTTON_CLICKED", value)
end

function private.ItemOnClick(text)
	local spellId = tonumber(text:GetElement("__parent.name"):GetContext())
	if spellId then
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(GetCraftItemLink(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)))
			end
		else
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				if TSM.IsWowClassic() then
					ChatEdit_InsertLink(GetTradeSkillItemLink(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)))
				else
					ChatEdit_InsertLink(C_TradeSkillUI.GetRecipeItemLink(spellId))
				end
			end
		end
	else
		Wow.SafeItemRef(ItemInfo.GetLink(text:GetElement("__parent.name"):GetContext()))
	end
end

function private.CraftBtnOnMouseDown(button)
	local quantity = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", quantity)
end

function private.CraftBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local quantity = max(tonumber(button:GetElement("__parent.craftInput"):GetValue()), 1)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", quantity)
end

function private.CraftAllBtnOnMouseDown(button)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", math.huge)
end

function private.CraftAllBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", math.huge)
end

function private.QueueOnRowMouseDown(button, data, mouseButton)
	if not private.IsPlayerProfession() or mouseButton ~= "LeftButton" then
		return
	end
	local spellId = data:GetField("spellId")
	if TSM.Crafting.ProfessionScanner.HasSpellId(spellId) then
		TSM.Crafting.ProfessionUtil.PrepareToCraft(spellId, TSM.Crafting.Queue.GetNum(spellId))
	end
end

function private.QueueOnRowClick(button, data, mouseButton)
	if not private.IsPlayerProfession() then
		return
	end
	local spellId = data:GetField("spellId")
	if mouseButton == "RightButton" then
		private.fsm:ProcessEvent("EV_QUEUE_RIGHT_CLICKED", spellId)
	elseif TSM.Crafting.ProfessionScanner.HasSpellId(spellId) then
		private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, TSM.Crafting.Queue.GetNum(spellId))
	end
end

function private.CraftNextOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local spellId = button:GetElement("__parent.__parent.__parent.queueList"):GetFirstData():GetField("spellId")
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, TSM.Crafting.Queue.GetNum(spellId))
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
		selectedRecipeSpellId = nil,
		queueQuery = nil,
		craftingSpellId = nil,
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
	function fsmPrivate.UpdateMaterials(context)
		if context.page == "profession" then
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList"):UpdateData(true)
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.matList"):UpdateData(true)
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
			assert(not TSM.IsWowClassic())
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
		context.selectedRecipeSpellId = recipeList:GetSelection()
		local buttonFrame = recipeContent:GetElement("__parent.buttons")
		local detailsFrame = recipeContent:GetElement("details")
		if not context.selectedRecipeSpellId then
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
			detailsFrame:GetElement("left.cost.text")
				:SetText("")
			detailsFrame:GetElement("left.cost.label")
				:Hide()
			detailsFrame:GetElement("left.craft.num")
				:SetText("")
			detailsFrame:GetElement("left.craft.error")
				:SetText(L["No receipe selected"])
			buttonFrame:GetElement("craftAllBtn")
				:SetDisabled(true)
			detailsFrame:GetElement("matList")
				:SetRecipe(nil)
				:SetContext(nil)
			craftingContentFrame:Draw()
			return
		end
		local resultName, resultItemString, resultTexture = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedRecipeSpellId)
		-- engineer tinkers can't be crafted, multi-crafted or queued
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		if not resultItemString then
			buttonFrame:GetElement("craftBtn")
				:SetText(currentProfession == GetSpellInfo(7411) and L["Enchant"] or L["Tinker"])
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(true)
			buttonFrame:GetElement("craftInput")
				:Hide()
		else
			buttonFrame:GetElement("craftBtn")
				:SetText(L["Craft"])
			buttonFrame:GetElement("queueBtn")
				:SetDisabled(false)
			buttonFrame:GetElement("craftInput")
				:Show()
		end
		local nameTooltip = resultItemString
		if not nameTooltip then
			if TSM.Crafting.ProfessionState.IsClassicCrafting() then
				nameTooltip = "craft:"..(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(context.selectedRecipeSpellId) or context.selectedRecipeSpellId)
			else
				nameTooltip = "enchant:"..context.selectedRecipeSpellId
			end
		end
		detailsFrame:GetElement("left.content.icon")
			:SetBackground(resultTexture)
			:SetTooltip(nameTooltip)
			:Show()
		detailsFrame:GetElement("left.content.name")
			:SetText(resultName or "?")
			:SetContext(resultItemString or tostring(context.selectedRecipeSpellId))
			:SetTooltip(nameTooltip)
		local craftingCost = TSM.Crafting.Cost.GetCostsBySpellId(context.selectedRecipeSpellId)
		detailsFrame:GetElement("left.cost.label")
			:Show()
		detailsFrame:GetElement("left.cost.text")
			:SetText(Money.ToString(craftingCost) or "")
		detailsFrame:GetElement("left.craft.num")
			:SetFormattedText(L["Crafts %d"], TSM.Crafting.GetNumResult(context.selectedRecipeSpellId))
		local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedRecipeSpellId)
		local errorText = detailsFrame:GetElement("left.craft.error")
		local canCraft, errStr = false, nil
		if toolsStr and not hasTools then
			errStr = REQUIRES_LABEL.." "..toolsStr
		elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedRecipeSpellId) then
			errStr = L["On Cooldown"]
		elseif TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedRecipeSpellId) == 0 then
			errStr = L["Missing Materials"]
		else
			canCraft = true
		end
		errorText:SetText(errStr and "("..errStr..")" or "")
		local isEnchant = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedRecipeSpellId)
		buttonFrame:GetElement("craftBtn")
			:SetDisabled(not canCraft or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "craft")
		buttonFrame:GetElement("craftAllBtn")
			:SetText(isEnchant and L["Enchant Vellum"] or L["Craft All"])
			:SetDisabled(not resultItemString or not canCraft or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "all")
		detailsFrame:GetElement("matList")
			:SetRecipe(context.selectedRecipeSpellId)
			:SetContext(context.selectedRecipeSpellId)
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
		local nextCraftSpellId = nextCraftRecord and nextCraftRecord:GetField("spellId")
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasSpellId(nextCraftSpellId) or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftSpellId) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		queueFrame:GetElement("footer.craft.craftNextBtn")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "queue")
		if nextCraftRecord and canCraftFromQueue then
			TSM.Crafting.ProfessionUtil.PrepareToCraft(nextCraftSpellId, nextCraftRecord:GetField("num"))
		end
		queueFrame:Draw()
	end
	function fsmPrivate.UpdateCraftButtons(context)
		if context.page == "profession" and private.IsProfessionLoaded() and context.selectedRecipeSpellId then
			local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedRecipeSpellId)
			local detailsFrame = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details")
			local errorText = detailsFrame:GetElement("left.craft.error")
			local canCraft, errStr = false, nil
			if toolsStr and not hasTools then
				errStr = REQUIRES_LABEL.." "..toolsStr
			elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedRecipeSpellId) then
				errStr = L["On Cooldown"]
			elseif TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedRecipeSpellId) == 0 then
				errStr = L["Missing Materials"]
			else
				canCraft = true
			end
			errorText:SetText(errStr and "("..errStr..")" or "")
				:Draw()
			local isEnchant = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedRecipeSpellId)
			local _, resultItemString = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedRecipeSpellId)
			detailsFrame:GetElement("__parent.__parent.buttons.craftBtn")
				:SetPressed(context.craftingSpellId and context.craftingType == "craft")
				:SetDisabled(not canCraft or context.craftingSpellId)
				:Draw()
			detailsFrame:GetElement("__parent.__parent.buttons.craftAllBtn")
				:SetText(isEnchant and L["Enchant Vellum"] or L["Craft All"])
				:SetPressed(context.craftingSpellId and context.craftingType == "all")
				:SetDisabled(not resultItemString or not canCraft or context.craftingSpellId)
				:Draw()
			if context.craftingQuantity and context.craftingSpellId == context.selectedRecipeSpellId then
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

		local nextCraftRecord = context.frame:GetElement("queue.queueList"):GetFirstData()
		if nextCraftRecord and (TSM.Crafting.GetProfession(nextCraftRecord:GetField("spellId")) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftRecord:GetField("spellId")) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = private.IsProfessionLoaded() and private.IsPlayerProfession()
		context.frame:GetElement("queue.footer.craft.craftNextBtn")
			:SetPressed(context.craftingSpellId and context.craftingType == "queue")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.craftingSpellId)
			:Draw()
	end
	function fsmPrivate.StartCraft(context, spellId, quantity)
		local numCrafted = TSM.Crafting.ProfessionUtil.Craft(spellId, quantity, context.craftingType ~= "craft", fsmPrivate.CraftCallback)
		Log.Info("Crafting %d (requested %s) of %d", numCrafted, quantity == math.huge and "all" or quantity, spellId)
		if numCrafted == 0 then
			return
		end
		context.craftingSpellId = spellId
		context.craftingQuantity = numCrafted
		fsmPrivate.UpdateCraftButtons(context)
	end

	private.fsm = FSM.New("CRAFTING_UI_CRAFTING")
		:AddState(FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				context.page = "profession"
				context.frame = nil
				context.craftingSpellId = nil
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
				context.craftingSpellId = nil
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
					:Select("spellId", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "spellId")
				context.professionQuery = TSM.Crafting.PlayerProfessions.CreateQuery()
				context.professionQuery:SetUpdateCallback(fsmPrivate.SkillUpdateCallback)
				if context.page == "profession" then
					context.frame:GetElement("left.viewContainer.main.content.profession.header.filterInput")
						:SetValue("")
						:Draw()
					private.filterText = ""
				end
				if context.selectedRecipeSpellId and context.page == "profession" then
					local recipeList = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
					recipeList:SetQuery(context.recipeQuery)
					if TSM.Crafting.ProfessionScanner.GetIndexBySpellId(context.selectedRecipeSpellId) then
						recipeList:SetSelection(context.selectedRecipeSpellId)
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
					:Select("spellId", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "spellId")
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
				context.page = page
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_QUEUE_BUTTON_CLICKED", function(context, quantity)
				assert(context.selectedRecipeSpellId)
				TSM.Crafting.Queue.Add(context.selectedRecipeSpellId, quantity)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
			:AddEvent("EV_QUEUE_RIGHT_CLICKED", function(context, spellId)
				if context.page ~= "profession" or TSM.Crafting.GetProfession(spellId) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() then
					return
				end
				local recipeList = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList")
				if not recipeList:IsSpellIdVisible(spellId) then
					return
				end
				recipeList:SetSelection(spellId)
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_RECIPE_SELECTION_CHANGED", function(context)
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_BAG_UPDATE_DELAYED", function(context)
				fsmPrivate.UpdateMaterials(context)
				fsmPrivate.UpdateQueueFrame(context)
				local professionLoaded = private.IsProfessionLoaded()
				local nextCraftRecord = context.frame:GetElement("queue.queueList"):GetFirstData()
				local nextCraftSpellId = nextCraftRecord and nextCraftRecord:GetField("spellId")
				if nextCraftRecord and professionLoaded and TSM.Crafting.ProfessionScanner.HasSpellId(nextCraftSpellId) and TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftSpellId) > 0 and private.IsPlayerProfession() then
					TSM.Crafting.ProfessionUtil.PrepareToCraft(nextCraftSpellId, nextCraftRecord:GetField("num"))
				end
			end)
			:AddEvent("EV_QUEUE_UPDATE", function(context)
				fsmPrivate.UpdateQueueFrame(context, true)
			end)
			:AddEvent("EV_SKILL_UPDATE", function(context)
				fsmPrivate.UpdateSkills(context)
			end)
			:AddEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", function(context, quantity)
				context.craftingType = quantity == math.huge and "all" or "craft"
				TSM.Crafting.ProfessionUtil.PrepareToCraft(context.selectedRecipeSpellId, quantity)
			end)
			:AddEvent("EV_CRAFT_BUTTON_CLICKED", function(context, quantity)
				context.craftingType = quantity == math.huge and "all" or "craft"
				fsmPrivate.StartCraft(context, context.selectedRecipeSpellId, quantity)
			end)
			:AddEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", function(context, spellId, quantity)
				if context.craftingSpellId then
					-- already crafting something
					return
				end
				local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(spellId)
				if (toolsStr and not hasTools) or TSM.Crafting.ProfessionUtil.GetNumCraftable(spellId) == 0 or TSM.Crafting.ProfessionUtil.GetRemainingCooldown(spellId) then
					-- can't craft this
					return
				end
				context.craftingType = "queue"
				fsmPrivate.StartCraft(context, spellId, quantity)
			end)
			:AddEvent("EV_SPELLCAST_COMPLETE", function(context, success, isDone)
				if success and context.craftingSpellId then
					Log.Info("Crafted %d", context.craftingSpellId)
					TSM.Crafting.Queue.Remove(context.craftingSpellId, 1)
					context.craftingQuantity = context.craftingQuantity - 1
					assert(context.craftingQuantity >= 0)
					if context.craftingQuantity == 0 then
						assert(isDone)
						context.craftingSpellId = nil
						context.craftingQuantity = nil
						context.craftingType = nil
					end
				else
					context.craftingSpellId = nil
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
	return TSM.Crafting.ProfessionUtil.IsCraftable(row:GetField("spellId"))
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
