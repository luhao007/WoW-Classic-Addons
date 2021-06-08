local BtWQuestsDatabase = BtWQuestsDatabase
local BtWQuestsCharacters = BtWQuestsCharacters

local L = BtWQuests.L;

local INTERFACE_NUMBER = select(4, GetBuildInfo())

BINDING_HEADER_BTWQUESTS = "BtWQuests"
BINDING_NAME_TOGGLE_BTWQUESTS = L["TOGGLE_BTWQUESTS"]

local CreateFramePoolCollection = CreateFramePoolCollection or CreatePoolCollection
local GetLogIndexForQuestID = C_QuestLog and C_QuestLog.GetLogIndexForQuestID or GetQuestLogIndexByID
local IsQuestComplete = C_QuestLog and C_QuestLog.IsComplete or IsQuestComplete
local GetQuestIDForQuestIndex = C_QuestLog and C_QuestLog.GetInfo and function (questLogIndex)
    return C_QuestLog.GetInfo(questLogIndex).questID
end or function (questLogIndex)
    return (select(8, GetQuestLogTitle(questLogIndex)))
end
local GetQuestLogIsAutoComplete = C_QuestLog and C_QuestLog.GetInfo and function (questLogIndex)
    return C_QuestLog.GetInfo(questLogIndex).isAutoComplete
end or GetQuestLogIsAutoComplete or function () return false end
local ShowQuestDetails = QuestMapFrame_OpenToQuestDetails and function (questID)
    QuestMapFrame_OpenToQuestDetails(questID)

    return true
end or function (questID)
    local mapID
    local quest = BtWQuestsDatabase:GetQuestByID(questID)
    if IsQuestComplete(questID) then
        if BtWQuestSettingsData:GetValue("showMapTurnIns") and quest:HasTarget() then
            mapID = quest:GetTargetMapID()
        end
    elseif quest:HasObjectives() then
        if BtWQuestSettingsData:GetValue("showMapPOIs") then
            mapID = quest:GetCurrentObjectiveMapID()
        end
    end

    if mapID then
        ShowUIPanel(WorldMapFrame);
        MaximizeUIPanel(WorldMapFrame);
        WorldMapFrame:SetMapID(mapID)
    else
        ShowUIPanel(QuestLogFrame);
        QuestLog_SetSelection(GetQuestLogIndexByID(questID))
    end

    return true
end
local function CanCompleteQuest(questLogIndex)
    return IsQuestComplete(GetQuestIDForQuestIndex(questLogIndex)) and GetQuestLogIsAutoComplete(questLogIndex)
end

BtWQuestsFrameChainViewMixin = {}
function BtWQuestsFrameChainViewMixin:GetTooltip()
    return BtWQuestsFrame.Tooltip
end
function BtWQuestsFrameChainViewMixin:SelectFromLink(...)
    return BtWQuestsFrame:SelectFromLink(...)
end
function BtWQuestsFrameChainViewMixin:GetCharacter()
    return BtWQuestsFrame:GetCharacter()
end


BtWQuestSettingsData = {
    options = {
        {
            name = L["SHOW_MINIMAP_ICON"],
            value = "minimapShown",
            onChange = function (id, value)
                BtWQuestsMinimapButton:SetShown(value)
            end,
            default = false,
        },
        {
            name = L["SHOW_MAP_PINS"],
            value = "showMapPins",
            onChange = function (id, value)
                if value then
                    -- Trigger creation of map pins
                    BtWQuestsFrame:OnEvent("PLAYER_ENTERING_WORLD")
                end

                if WorldMapFrame:IsShown() then
                    WorldMapFrame:RefreshAllDataProviders()
                end
            end,
            default = true,
        },
        {
            name = L["SHOW_MAP_OBJECTIVES"],
            value = "showMapPOIs",
            onChange = function (id, value)
                if value then
                    -- Trigger creation of map pins
                    BtWQuestsFrame:OnEvent("PLAYER_ENTERING_WORLD")
                end

                if WorldMapFrame:IsShown() then
                    WorldMapFrame:RefreshAllDataProviders()
                end
            end,
            default = GetQuestPOIs == nil,
            visible = GetQuestPOIs == nil,
        },
        {
            name = L["SHOW_MAP_TURN_INS"],
            value = "showMapTurnIns",
            onChange = function (id, value)
                if value then
                    -- Trigger creation of map pins
                    BtWQuestsFrame:OnEvent("PLAYER_ENTERING_WORLD")
                end

                if WorldMapFrame:IsShown() then
                    WorldMapFrame:RefreshAllDataProviders()
                end
            end,
            default = GetQuestPOIs == nil,
            visible = GetQuestPOIs == nil,
        },
        {
            name = L["USE_SMALL_MAP_ICONS"],
            value = "smallMapPins",
            onChange = function (id, value)
                if WorldMapFrame:IsShown() then
                    WorldMapFrame:RefreshAllDataProviders()
                end
            end,
            default = false,
        },
        {
            name = L["SHOW_CATEGORY_AS_GRID"],
            value = "gridView",
            default = true,
        },
        {
            name = L["SHOW_CATEGORY_HEADERS"],
            value = "categoryHeaders",
            default = false,
        },
        {
            name = L["GROUP_COMPLETED"],
            value = "filterCompleted",
            default = false,
        },
        {
            name = L["GROUP_IGNORED"],
            value = "filterIgnored",
            default = false,
        },
        {
            name = L["SHOW_QUEST_CHAIN_TOOLTIP"],
            value = "showChainTooltip",
            default = true,
        },
        {
            name = L["SPOILER_FREE"],
            value = "hideSpoilers",
            default = false,
        },
        {
            name = L["USE_TOMTOM_WAYPOINTS"],
            value = "useTomTom",
            default = true,
        },
    },
    optionsByID = {},
    GetValue = function (self, id)
        if BtWQuests_Settings == nil then
            BtWQuests_Settings = {}
        end

        local value = BtWQuests_Settings[id]
        if value == nil then
            value = self.optionsByID[id].default
        end
        return value
    end,
    SetValue = function (self, id, value)
        if BtWQuests_Settings == nil then
            BtWQuests_Settings = {}
        end
        BtWQuests_Settings[id] = value

        local func = self.optionsByID[id].onChange
        if func then
            func(id, value)
        end
    end
}
for _,option in ipairs(BtWQuestSettingsData.options) do
    BtWQuestSettingsData.optionsByID[option.value] = option
end

BtWQuestsOptionsMenuMixin = {}
function BtWQuestsOptionsMenuMixin:OnLoad()
	self.displayMode = "MENU"
end
function BtWQuestsOptionsMenuMixin:Initialize()
    local function Select (button)
        BtWQuestSettingsData:SetValue(button.value, not button.checked)
        if BtWQuestsFrame:IsShown() then
            BtWQuestsFrame:Refresh()
        end
    end

    local info = self:CreateInfo();
    info.isNotRadio = true
    -- info.keepShownOnClick = true

    for _,option in ipairs(BtWQuestSettingsData.options) do
        if option.visible ~= false then
            info.text = option.name
            info.value = option.value
            info.checked = BtWQuests_Settings[option.value]
            info.func = Select
            if info.checked == nil then
                info.checked = option.default
            end
            self:AddButton(info)
        end
    end
end

BtWQuestsMixin = {}
function BtWQuestsMixin:GetCharacter()
    if not self.Character then
        self:SelectCharacter(BtWQuestsCharacters:GetPlayer());
    end
    return self.Character
end
function BtWQuestsMixin:SelectCharacter(name, realm)
    local character
    if type(name) == "table" then
        character = name;
    else
        local key
        if realm == nil then
            key = name
        else
            key = name .. "-" .. realm
        end

        character = BtWQuestsCharacters:GetCharacter(key)
    end
    if character ~= nil then
        self.Character = character
        UIDropDownMenu_SetText(self.CharacterDropDown, character:GetDisplayName())

        if self:IsShown() then
            self:Refresh()
        end
    end
end

function BtWQuestsMixin:GetExpansion()
    return self.expansionID
end
function BtWQuestsMixin:SetExpansion(id)
    self.expansionID = tonumber(id)
    self.categoryID = nil
    self.chainID = nil
end
function BtWQuestsMixin:SelectExpansion(id, scrollTo, noHistory)
    if not noHistory then
        self:UpdateCurrentHistory()
    end

    self:SetExpansion(id)

    if id == nil then
        self.navBar:Reset()
    else
        self.navBar:SetExpansion(id)
    end

    local expansion = self:GetExpansion()
    if expansion and BtWQuestsDatabase:HasExpansion(expansion) then
        self.ExpansionDropDown:SetText(BtWQuestsDatabase:GetExpansionByID(expansion));
    end

    if expansion == nil then
        self:DisplayExpansionList(scrollTo)
    else
        self:DisplayCurrentExpansion(scrollTo)
    end

    if not noHistory then
        self:AddCurrentToHistory()
    end
end

function BtWQuestsMixin:GetCategory()
    return self.categoryID
end
function BtWQuestsMixin:SetCategory(id)
    if id == nil then
        self.categoryID = nil
        self.chainID = nil
    else
        self.categoryID = tonumber(id)
        self.chainID = nil
        self.expansionID = select(4, BtWQuestsDatabase:GetCategoryByID(self.categoryID, self:GetCharacter()))
    end
end
function BtWQuestsMixin:SelectCategory(id, scrollTo, noHistory)
    if not noHistory then
        self:UpdateCurrentHistory()
    end

    local character = self:GetCharacter();
    local category = BtWQuestsDatabase:GetCategoryByID(id)
    if not category then
        category = BtWQuestsDatabase:LoadCategory(id)
    end
    assert(category, L["Failed to find request category"])
    if not category:IsValidForCharacter(character) then
        id = category:GetAlternative(character) or id
    end

    self:SetCategory(id)
    self.navBar:SetCategory(id)

    self:DisplayCurrentCategory(scrollTo)

    if not noHistory then
        self:AddCurrentToHistory()
    end
end

function BtWQuestsMixin:GetChain()
    return self.chainID
end
function BtWQuestsMixin:SetChain(id)
    self.chainID = tonumber(id)
    self.expansionID, self.categoryID = select(4, BtWQuestsDatabase:GetChainByID(self.chainID, self:GetCharacter()))
end
function BtWQuestsMixin:SelectChain(id, scrollTo, noHistory)
    if not noHistory then
        self:UpdateCurrentHistory()
    end

    local character = self:GetCharacter();
    local chain = BtWQuestsDatabase:GetChainByID(id)
    if not chain then
        chain = BtWQuestsDatabase:LoadChain(id)
    end
    assert(chain, L["Failed to find request chain"])
    if not chain:IsValidForCharacter(character) then
        id = chain:GetAlternative(character) or id
    end

    self:SetChain(id)
    self.navBar:SetChain(id)

    self:DisplayCurrentChain(scrollTo)

    if not noHistory then
        self:AddCurrentToHistory()
    end
end
function BtWQuestsMixin:SelectFromLink(link, scrollTo)
    local _, _, color, type, text, name = string.find(link, "|cff(%x*)|H([^:]+):([^|]+)|h%[([^%[%]]*)%]|h|r")
    if not color then
        _, _, type, text = string.find(link, "([^:]+):(.+)")
    end

    assert(type == "quest" or type == "btwquests")

    self.SearchBox:ClearFocus()

    if type == "quest" then
        local _, _, id = string.find(text, "^(%d+):")

        id = tonumber(id)

        local questLogIndex = GetLogIndexForQuestID(id);
        if questLogIndex and questLogIndex > 0 then
            if CanCompleteQuest(questLogIndex) then
                AutoQuestPopupTracker_RemovePopUp(id);
                ShowQuestComplete(questLogIndex);

                return true
            else
                ShowQuestDetails(id)

                return true
            end
        end
    elseif type == "btwquests" then
        local _, _, subtype, id = string.find(text, "^([^:]*):(%d+)")

        assert(subtype == "expansion" or subtype == "category" or subtype == "chain")

        if subtype == "expansion" then
            self:SelectExpansion(id, scrollTo)

            return true
        elseif subtype == "category" then
            self:SelectCategory(id, scrollTo)

            return true
        elseif subtype == "chain" then
            self:SelectChain(id, scrollTo)

            return true
        end
    end

    return false
end
function BtWQuestsMixin:SelectItem(item, scrollTo)
    if item.type == "expansion" then
        self:SelectExpansion(item.id, scrollTo or item.scrollTo)
    elseif item.type == "category" then
        self:SelectCategory(item.id, scrollTo or item.scrollTo)
    elseif item.type == "chain" then
        self:SelectChain(item.id, scrollTo or item.scrollTo)
    end
end

function BtWQuestsMixin:SelectFromHistory()
    local item = self.History[self.HistoryIndex]

    if item.type == "chain" then
        self:SelectChain(item.id, item.scrollTo, true)
    elseif item.type == "category" then
        self:SelectCategory(item.id, item.scrollTo, true)
    elseif item.type == "expansion" then
        self:SelectExpansion(item.id, item.scrollTo, true)
    end
end
function BtWQuestsMixin:Back()
    if self.HistoryIndex > 1 then
        self:UpdateCurrentHistory()

        self.HistoryIndex = self.HistoryIndex - 1

        self:SelectFromHistory()

        self:UpdateHistoryButtons()
    end
end
function BtWQuestsMixin:Forward()
    if self.HistoryIndex < #self.History then
        self:UpdateCurrentHistory()

        self.HistoryIndex = self.HistoryIndex + 1

        self:SelectFromHistory()

        self:UpdateHistoryButtons()
    end
end
function BtWQuestsMixin:Here()
    local item = BtWQuestsDatabase:GetMapItemByID(C_Map.GetBestMapForUnit("player"), self:GetCharacter())

    if item == nil then
        self.NavHere:Disable()
    else
        self:SelectItem(item)
    end
end
function BtWQuestsMixin:ZoomOut()
    self:Back()

    self.Tooltip:Hide();
end
function BtWQuestsMixin:GetCurrentView()
    if self.Chain:IsShown() then
        return {
            type = "chain",
            id = self:GetChain(),
            scrollTo = {
                type = "coords",
                x = self.Chain.Scroll:GetHorizontalScroll(),
                y = self.Chain.Scroll:GetVerticalScroll(),
            }
        };
    elseif self:GetCategory() ~= nil then
        return {
            type = "category",
            id = self:GetCategory(),
            scrollTo = {
                type = "coords",
                x = self.Category.Scroll:GetHorizontalScroll(),
                y = self.Category.Scroll:GetVerticalScroll(),
            }
        };
    else
        return {
            type = "expansion",
            id = self:GetExpansion(),
            scrollTo = {
                type = "coords",
                x = self.Category.Scroll:GetHorizontalScroll(),
                y = self.Category.Scroll:GetVerticalScroll(),
            }
        };
    end
end
function BtWQuestsMixin:AddCurrentToHistory()
    local last = self.History[self.HistoryIndex]
    local current = self:GetCurrentView()

    if last == nil or current.type ~= last.type or current.id ~= last.id then
        self.HistoryIndex = self.HistoryIndex + 1

        while self.History[self.HistoryIndex] do
            table.remove(self.History, self.HistoryIndex)
        end

        table.insert(self.History, current);
    end

    self:UpdateHistoryButtons()
end
function BtWQuestsMixin:UpdateCurrentHistory()
    self.History[self.HistoryIndex] = self:GetCurrentView();
end
function BtWQuestsMixin:UpdateHistoryButtons()
    self.NavBack:SetEnabled(self.HistoryIndex > 1)
    self.NavForward:SetEnabled(self.HistoryIndex < #self.History)
end
function BtWQuestsMixin:UpdateHereButton()
    self.NavHere:SetEnabled(BtWQuestsDatabase:GetMapItemByID(C_Map.GetBestMapForUnit("player"), self:GetCharacter()) ~= nil)
end

function BtWQuestsMixin:LoadExpansion(id)
    BtWQuestsDatabase:GetExpansionByID(id):Load()
    self:Refresh()
end
function BtWQuestsMixin:DisplayExpansionList(scrollTo)
	self.Chain:Hide()
	self.Category:Hide()
    self.ExpansionList:Show()

    local character = self:GetCharacter();
    local items = BtWQuestsDatabase:GetExpansionList()

    if self.ExpansionScroll == nil then
        self.ExpansionScroll = #items - 2
    end

    if self.ExpansionScroll > #items - 2 then
        self.ExpansionScroll = #items - 2
    end
    if self.ExpansionScroll < 1 then
        self.ExpansionScroll = 1
    end

    self.ExpansionList.Left:SetEnabled(not (self.ExpansionScroll == 1))
    self.ExpansionList.Right:SetEnabled(not (self.ExpansionScroll == #items - 2))

    for i=1,3 do
        local item = items[self.ExpansionScroll - 1 + i]
        local expansion = self.ExpansionList.Expansions[i]
        if item ~= nil then
            expansion:Set(item, character)
            expansion:Show()
        else
            expansion:Hide()
        end
    end

    local source = self.ExpansionList.Expansions[1]
    if #items == 1 then
        source:ClearAllPoints()
        source:SetPoint("BOTTOM", 0, 7)
    elseif #items == 2 then
        source:ClearAllPoints()
        source:SetPoint("BOTTOMRIGHT", self.ExpansionList, "BOTTOM", 0, 7)
    else
        source:ClearAllPoints()
        source:SetPoint("BOTTOMLEFT", 48, 7)
    end
end
function BtWQuestsMixin:DisplayItemList(items, scrollTo)
    local gridView = BtWQuestSettingsData:GetValue("gridView")

	self.categoryItemPool:ReleaseAll();
    local questSelect = self.Category;

    local character = self:GetCharacter()
    self.Tooltip.character = character

	self.Chain:Hide();
    self.ExpansionList:Hide()
	questSelect:Show();

	local scrollFrame = questSelect.Scroll.Child;
    local scrollToButton

    local startX = 12
    local startY = -10
	local i = 1;
    local index = 1;
    local gridIndex = 1
    local previousButton = nil

    local categoryButton
    for _,item in ipairs(items) do
        if item:GetType() == "header" then
            categoryButton = self.categoryItemPool:Acquire("BtWQuestsCategoryHeaderTemplate")
            if previousButton then
                categoryButton:SetPoint("TOP", previousButton, "BOTTOM", 0, -15)
                categoryButton:SetPoint("LEFT", 5, 0)
            else
                categoryButton:SetPoint("TOPLEFT", 5, -5)
            end
            gridIndex = 1
        elseif gridView then
            categoryButton = self.categoryItemPool:Acquire("BtWQuestsCategoryGridItemTemplate")
            if previousButton then
                if (gridIndex - 1) % 4 == 0 then
                    categoryButton:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
                    categoryButton:SetPoint("LEFT", 5, 0)
                else
                    categoryButton:SetPoint("LEFT", previousButton, "RIGHT", 0, 0)
                end
            else
                categoryButton:SetPoint("TOPLEFT", 5, -5)
            end
            gridIndex = gridIndex + 1
        else
            categoryButton = self.categoryItemPool:Acquire("BtWQuestsCategoryListItemTemplate")

            if previousButton then
                categoryButton:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
            else
                categoryButton:SetPoint("TOPLEFT", 5, -5)
            end
        end

        categoryButton:Set(item, character)
        categoryButton:Show()

        if type(scrollTo) == "number" and index == scrollTo then
            scrollToButton = categoryButton
        elseif type(scrollTo) == "table" and item:EqualsItem(scrollTo) then
            scrollToButton = categoryButton
        end

        previousButton = categoryButton
        index = index + 1
    end

    if type(scrollTo) == "table" and scrollTo.type == "coords" then
        questSelect.Scroll:UpdateScrollChildRect()
        -- questSelect.Scroll:SetHorizontalScroll(scrollTo.x)
        questSelect.Scroll:SetVerticalScroll(scrollTo.y)
    elseif scrollTo ~= false then
        if scrollToButton then
            questSelect.Scroll:UpdateScrollChildRect()
            questSelect.Scroll:SetVerticalScroll(-select(5, scrollToButton:GetPoint("TOP")) - (questSelect.Scroll:GetHeight()/2) + 24)
        else
            questSelect.Scroll:SetVerticalScroll(0)
        end
    end

    self:Show();
end
function BtWQuestsMixin:DisplayCurrentExpansion(scrollTo)
    local categoryHeaders = BtWQuestSettingsData:GetValue("categoryHeaders")
    local filterCompleted = BtWQuestSettingsData:GetValue("filterCompleted")
    local filterIgnored = BtWQuestSettingsData:GetValue("filterIgnored")

    local expansion = BtWQuestsDatabase:GetExpansionByID(self:GetExpansion());
    if expansion == nil then
        print(L["BTWQUESTS_NO_EXPANSION_ERROR"])
        return;
    end
    expansion:Load()
    local items = expansion:GetItemList(self:GetCharacter(), not categoryHeaders, filterCompleted, filterIgnored)
    if #items == 0 then -- Somehow selected an empty expansion, probably means all the BtWQuests modules are disabled
        print(L["BTWQUESTS_NO_EXPANSION_ERROR"])
    end
    self:DisplayItemList(items, scrollTo)
end
function BtWQuestsMixin:DisplayCurrentCategory(scrollTo)
    local categoryHeaders = BtWQuestSettingsData:GetValue("categoryHeaders")
    local filterCompleted = BtWQuestSettingsData:GetValue("filterCompleted")
    local filterIgnored = BtWQuestSettingsData:GetValue("filterIgnored")

    local category = BtWQuestsDatabase:GetCategoryByID(self:GetCategory())
    local items = category:GetItemList(self:GetCharacter(), not categoryHeaders, filterCompleted, filterIgnored)
    self:DisplayItemList(items, scrollTo)
end
function BtWQuestsMixin:DisplayCurrentChain(scrollTo, zoom)
	local chain = self.Chain;

	self.Category:Hide();
    self.ExpansionList:Hide()
    chain:Show();

    -- chain.Scroll:SetCharacter(self:GetCharacter())
    chain.Scroll:SetHideSpoilers(BtWQuestSettingsData:GetValue("hideSpoilers"))
    chain.Scroll:SetChain(self:GetChain(), scrollTo, zoom)

    if BtWQuestSettingsData:GetValue("showChainTooltip") then
        chain.Tooltip:ClearAllPoints()
        chain.Tooltip:SetPoint("TOPLEFT", chain, "TOPRIGHT", 5, -3)
        chain.Tooltip:SetOwner(chain, "ANCHOR_PRESERVE")
        chain.Tooltip:SetChain(self:GetChain(), self:GetCharacter())

        if chain:GetRight() > chain.Tooltip:GetLeft() then
            chain.Tooltip:ClearAllPoints()
            chain.Tooltip:SetPoint("TOPRIGHT", chain, "TOPLEFT", -5, -3)
        end
    else
        chain.Tooltip:Hide() -- Just incase it was already visible
    end

    self:Show();
end
function BtWQuestsMixin:UpdateCurrentChain()
    local chain = self.Chain

    if chain:IsShown() then
        chain.Scroll:Update()

        if BtWQuestSettingsData:GetValue("showChainTooltip") then
            chain.Tooltip:SetOwner(chain, "ANCHOR_PRESERVE")
            chain.Tooltip:SetChain(self:GetChain(), self:GetCharacter())
        else
            chain.Tooltip:Hide() -- Just incase it was already visible
        end
    end
end

local function ChainItemPool_HideAndClearAnchors(framePool, frame)
    FramePool_HideAndClearAnchors(framePool, frame)

    if frame.backgroundLinePool then
        frame.backgroundLinePool:ReleaseAll();
    end
end

function BtWQuestsMixin:OnLoad()
    tinsert(UISpecialFrames, self:GetName());

    self:RegisterForDrag("LeftButton")

    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    if C_QuestSession then
        self:RegisterEvent("QUEST_SESSION_JOINED")
        self:RegisterEvent("QUEST_SESSION_LEFT")
    end

    self:RegisterEvent("MODIFIER_STATE_CHANGED")

	self.TitleText:SetText(L["BTWQUESTS_QUEST_JOURNAL"]);
    SetPortraitToTexture(self.portrait, "Interface\\QuestFrame\\UI-QuestLog-BookIcon");

    if self.NineSlice then
        -- Updated the NineSlice frame for our extra buttons
        self.NineSlice.TopLeftCorner:SetTexture("Interface\\Addons\\BtWQuests\\UI-Frame-Metal")
        self.NineSlice.TopLeftCorner:SetWidth(196)
        self.NineSlice.TopLeftCorner:SetTexCoord(0, 0.3828125, 0, 0.2578125)

        self.NineSlice.TopRightCorner:SetTexture("Interface\\Addons\\BtWQuests\\UI-Frame-Metal")
        self.NineSlice.TopRightCorner:SetTexCoord(0, 0.51171875, 0.2578125, 0.515625)
        self.NineSlice.TopRightCorner:SetWidth(262)
    end

    self.categoryItemPool = CreateFramePoolCollection()--CreateFramePool("BUTTON", self.Category.Scroll.Child, "BtWQuestsCategoryButtonTemplate");
	self.categoryItemPool:CreatePool("BUTTON", self.Category.Scroll.Child, "BtWQuestsCategoryHeaderTemplate");
    self.categoryItemPool:CreatePool("BUTTON", self.Category.Scroll.Child, "BtWQuestsCategoryListItemTemplate");
	self.categoryItemPool:CreatePool("BUTTON", self.Category.Scroll.Child, "BtWQuestsCategoryGridItemTemplate");

    self.chainItemPool = CreateFramePool("BUTTON", self.Chain.Scroll.Child, "BtWQuestsChainItemButtonTemplate", ChainItemPool_HideAndClearAnchors);

    self.ExpansionScroll = nil
    self.HistoryIndex = 1
    self.History = {}

	-- LDB launcher
	local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
	if LDB then
		BtWQuestsLauncher = LDB:NewDataObject("BtWQuests", {
			type = "launcher",
            label = "BtWQuests",
			icon = "Interface\\QuestFrame\\UI-QuestLog-BookIcon",
			OnClick = function(clickedframe, button)
                if BtWQuestsFrame:IsShown() then
                    BtWQuestsFrame:Hide()
                else
                    BtWQuestsFrame:Show()
                end
			end,
		})
	end
end
function BtWQuestsMixin:OnEvent(event, ...)
    if event == "ADDON_LOADED" then
        if ... == "BtWQuests" then
            BtWQuests_AutoLoad = BtWQuests_AutoLoad or {}

            for i=1,GetNumAddOns() do
                if GetAddOnMetadata(i, "X-BtWQuests") and IsAddOnLoadOnDemand(i) and GetAddOnEnableState((UnitName("player")), i) ~= 0 then -- One of our child addons
                    local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(i)
                    local id = tonumber(GetAddOnMetadata(name, "X-BtWQuests-Expansion"))

                    if id then
                        if BtWQuests_AutoLoad[name] == nil then
                            BtWQuests_AutoLoad[name] = GetAddOnMetadata(name, "X-BtWQuests-AutoLoad") == "1"
                        end

                        local expansion = BtWQuestsDatabase:GetExpansionByID(id)
                        if not expansion then
                            local image = GetAddOnMetadata(name, "X-BtWQuests-Expansion-Image")
                            if image then
                                local image, left, right, top, bottom = strsplit(" ", GetAddOnMetadata(name, "X-BtWQuests-Expansion-Image"))
                                expansion = BtWQuestsDatabase:AddExpansion(id, {
                                    image = {
                                        texture = string.format("Interface\\AddOns\\%s\\%s", name, image),
                                        texCoords = {0, 0.90625, 0, 0.8125}
                                    },
                                })
                            else
                                expansion = BtWQuestsDatabase:AddExpansion(id, {})
                            end
                        end

                        local autoload = false
                        expansion.addons = expansion.addons or {}
                        expansion.addons[name] = GetAddOnMetadata(i, "X-BtWQuests")
                        for name in pairs(expansion.addons) do
                            autoload = BtWQuests_AutoLoad[name] or autoload
                        end

                        do
                            local ranges = GetAddOnMetadata(name, "X-BtWQuests-Category-Range")
                            if ranges then
                                BtWQuestsDatabase:AddCategoryRanges(ranges, id)
                            end
                        end
                        do
                            local ranges = GetAddOnMetadata(name, "X-BtWQuests-Chain-Range")
                            if ranges then
                                BtWQuestsDatabase:AddChainRanges(ranges, id)
                            end
                        end

                        if autoload then
                            for name in pairs(expansion.addons) do
                                BtWQuests_AutoLoad[name] = true
                                LoadAddOn(name)
                            end
                        end
                    end
                end
            end

            if not BtWQuestsDatabase:HasMultipleExpansion() then
                BtWQuestsDatabase:GetFirstExpansion():Load()
            end

            -- hooksecurefunc("QuestObjectiveTracker_OnOpenDropDown", function (self)
            --     BtWQuests_AddOpenChainMenuItem(self, self.activeFrame.id)
            -- end)
            -- hooksecurefunc(QuestMapQuestOptionsDropDown, "initialize", function (self)
            --     BtWQuests_AddOpenChainMenuItem(self, self.questID)
            -- end)

            if select(5, GetAddOnInfo("BtWQuestsEditor")) == "DEMAND_LOADED" then
                local option = {
                    name = "Enable Editor (reload on disable)",
                    value = "enableEditor",
                    default = false,
                    onChange = function(id, value)
                        if value then
                            LoadAddOn("BtWQuestsEditor")
                        else
                            ReloadUI() -- Gotta reload to disable an addon
                        end
                    end
                };
                BtWQuestSettingsData.optionsByID[option.value] = option
                BtWQuestSettingsData.options[#BtWQuestSettingsData.options+1] = option;

                if BtWQuestSettingsData:GetValue("enableEditor") then
                    LoadAddOn("BtWQuestsEditor")
                end
            end
        elseif (...):sub(1, 9) == "BtWQuests" then
            if self:IsShown() then
                self:UpdateHereButton()
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if not self.addedQuestDataProviders and (BtWQuestSettingsData:GetValue("showMapPins") or BtWQuestSettingsData:GetValue("showMapPOIs") or BtWQuestSettingsData:GetValue("showMapTurnIns")) then
            self.addedQuestDataProviders = true
            LibMapPinHandler[WorldMapFrame]:AddDataProvider(CreateFromMixins(BtWQuestsQuestDataProviderMixin));
            if not GetQuestPOIs then
                LibMapPinHandler[WorldMapFrame]:AddDataProvider(CreateFromMixins(BtWQuestsQuestPOIDataProviderMixin));
            end
        end
    elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
        if self:IsShown() then
            self:UpdateHereButton()
        end
    elseif event == "QUEST_SESSION_JOINED" or event == "QUEST_SESSION_LEFT" then
        -- Both the current character and party sync are considered "the player"
        if self:GetCharacter():IsPlayer() then
            self.Character = nil;
            self:GetCharacter();
        end
    elseif event == "MODIFIER_STATE_CHANGED" then
        if ... == "LSHIFT" or ... == "RSHIFT" then
            -- Update tooltips
            local chain = self.Chain
            if chain:IsShown() and BtWQuestSettingsData:GetValue("showChainTooltip") then
                chain.Tooltip:SetOwner(chain, "ANCHOR_PRESERVE")
                chain.Tooltip:SetChain(self:GetChain(), self:GetCharacter())
            end

            local tooltip = self.Tooltip
            if tooltip:IsShown() then
                local button = GetMouseFocus()
                if button.OnEnter then
                    button:OnEnter()
                end
                -- tooltip:SetOwner(tooltip, "ANCHOR_PRESERVE")
                -- tooltip:SetChain(self:GetChain(), self:GetCharacter())
            end
        end
    end
end
function BtWQuestsMixin:OnDragStart()
    if self.Chain.Tooltip:IsVisible() then
        self:SetScript("OnUpdate", function (self)
            local chain = self.Chain;
            local point = chain.Tooltip:GetPoint()
            if point == "TOPRIGHT" then
                if chain:GetRight() + chain.Tooltip:GetWidth() + 5 < UIParent:GetWidth() then
                    chain.Tooltip:ClearAllPoints()
                    chain.Tooltip:SetPoint("TOPLEFT", chain, "TOPRIGHT", 5, -3)
                end
            else
                if chain:GetRight() + chain.Tooltip:GetWidth() + 5 > UIParent:GetWidth() then
                    chain.Tooltip:ClearAllPoints()
                    chain.Tooltip:SetPoint("TOPRIGHT", chain, "TOPLEFT", -5, -3)
                end
            end
        end);
    end
    self:StartMoving();
end
function BtWQuestsMixin:OnDragStop()
    self:StopMovingOrSizing();
    self:SetScript("OnUpdate", nil);
end
function BtWQuestsMixin:Refresh()
    if self:GetChain() ~= nil then
        self:SelectChain(self:GetChain(), nil, true)
    elseif self:GetCategory() ~= nil then
        self:SelectCategory(self:GetCategory(), nil, true)
        -- self.navBar:SetCategory(self:GetCategory())
        -- self:DisplayCurrentCategory(false)
    elseif self:GetExpansion() ~= nil then
        self:SelectExpansion(self:GetExpansion(), nil, true)
        -- self.navBar:SetExpansion(self:GetExpansion())
        -- self:DisplayCurrentExpansion(false)
    else
        self.navBar:Reset()
        self:DisplayExpansionList(false)
    end
end
function BtWQuestsMixin:OnShow()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);

    self:UpdateHereButton()

    if not self.initialized then
        self:SelectCharacter(BtWQuestsCharacters:GetPlayer())

        self.navBar:EnableExpansions(BtWQuestsDatabase:HasMultipleExpansion())

        if self:GetExpansion() == nil then -- Not guessed/set an expansion yet
            local expansion = BtWQuestsDatabase:GetLoadedExpansion()
            if expansion then
                self:SelectExpansion(expansion:GetID(), nil, true)
            elseif not BtWQuestsDatabase:HasMultipleExpansion() then
                self:SelectExpansion(BtWQuestsDatabase:GetFirstExpansion():GetID(), nil, true)
            end
        end

        -- Quick fix for AddOnSkins issue
        if self.Chain.Scroll.ScrollBar.ThumbTexture and self.Chain.Scroll.ScrollBar.ThumbTexture.Backdrop then
            self.Chain.Scroll.ScrollBar.ThumbTexture.Backdrop:SetFrameLevel(self.Chain.Scroll.ScrollBar.Backdrop:GetFrameLevel())
            self.Category.Scroll.ScrollBar.ThumbTexture.Backdrop:SetFrameLevel(self.Category.Scroll.ScrollBar.Backdrop:GetFrameLevel())
        end

        self.initialized = true
    else
        if self:GetChain() ~= nil then
            self:UpdateCurrentChain()
        elseif self:GetCategory() ~= nil then
            self:DisplayCurrentCategory()
        elseif self:GetExpansion() ~= nil then
            self:DisplayCurrentExpansion()
        else
            self:DisplayExpansionList()
        end
    end
end
function BtWQuestsMixin:OnHide(self)
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
end

function BtWQuestsChainFrame_OnShow(self)
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("QUEST_AUTOCOMPLETE")
    self:RegisterEvent("QUEST_COMPLETE")
    self:RegisterEvent("QUEST_FINISHED")
    self:RegisterEvent("QUEST_TURNED_IN")
    if INTERFACE_NUMBER >= 70200 then
        self:RegisterEvent("QUEST_LOG_CRITERIA_UPDATE")
    end
    self:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
    self:RegisterEvent("QUEST_WATCH_UPDATE")
end
function BtWQuestsChainFrame_OnHide(self)
    self:UnregisterAllEvents()
end
function BtWQuestsChainFrame_OnEvent(self, ...)
    self:GetParent():UpdateCurrentChain()
end
function BtWQuestsChainFrameScrollFrame_OnUpdate(self)
    local mouseX, mouseY = GetCursorPosition()
    local scale = self:GetEffectiveScale()
    mouseX, mouseY = mouseX / scale, mouseY / scale

    local maxXScroll, maxYScroll = self:GetHorizontalScrollRange(), self:GetVerticalScrollRange()

    mouseX = min(max(mouseX - self.mouseX + self.scrollX, 0), maxXScroll)
    mouseY = min(max(mouseY - self.mouseY + self.scrollY, 0), maxYScroll)

    self:SetHorizontalScroll(mouseX)
    self:SetVerticalScroll(mouseY)
end

function BtWQuestsMixin:ShowFullSearch()
    self.SearchBox:ShowFullSearch()
end

-- [[ Compatibility functions ]]
-- These functions use the character from BtWQuestsFrame
function BtWQuests_GetQuestName(id)
    return BtWQuestsDatabase:GetQuestName(id)
end
function BtWQuests_IsQuestCompleted(id)
    return BtWQuestsFrame:GetCharacter():IsQuestCompleted(id)
end
function BtWQuests_IsQuestActive(id)
    return BtWQuestsFrame:GetCharacter():IsQuestActive(id)
end

function BtWQuests_GetChainName(id)
    return BtWQuestsDatabase:GetChainName(id, BtWQuestsFrame:GetCharacter())
end
function BtWQuests_IsChainCompleted(id)
    return BtWQuestsFrame:GetCharacter():IsChainCompleted(id)
end
function BtWQuests_IsChainActive(id)
    return BtWQuestsFrame:GetCharacter():IsChainCompleted(id)
end

function BtWQuests_GetCategoryName(id)
    return BtWQuestsDatabase:GetCategoryName(id, BtWQuestsFrame:GetCharacter())
end
function BtWQuests_IsCategoryCompleted(id)
    return BtWQuestsFrame:GetCharacter():IsCategoryCompleted(id)
end
function BtWQuests_IsCategoryActive(id)
    return BtWQuestsFrame:GetCharacter():IsCategoryCompleted(id)
end

-- [[ Waypoint ]]
function BtWQuests_AddWaypoint(mapId, x, y, name)
    if BtWQuestSettingsData:GetValue("useTomTom") and TomTom and TomTom.AddWaypoint then
        TomTom:AddWaypoint(mapId, x, y, {
            title = name,
        })
    elseif BtWQuests.Guide then
        BtWQuests.Guide:AddWayPoint(mapId, x, y, name)
    end
end
function BtWQuests_ShowMapWithWaypoint(mapId, x, y, name)
    BtWQuests_AddWaypoint(mapId, x, y, name)

    if not IsModifiedClick("CHATLINK") then
        ShowUIPanel(WorldMapFrame);
        if INTERFACE_NUMBER < 90000 then
            MaximizeUIPanel(WorldMapFrame);
        end
        WorldMapFrame:SetMapID(mapId);
    end
end

-- [[ Quest To Chain ]]
function BtWQuests_AddOpenChainMenuItem(self, questID)
    local item = BtWQuestsDatabase:GetQuestItem(questID, BtWQuestsCharacters:GetPlayer())
    if item then
        local info = UIDropDownMenu_CreateInfo()
        info.text = L["BTWQUESTS_OPEN_QUEST_CHAIN"]
        info.func = function(self, questID, item)
            BtWQuestsFrame:SelectCharacter(UnitName("player"), GetRealmName())
            BtWQuestsFrame:SelectItem(item.item)
        end
        info.arg1 = questID
        info.arg2 = item
        info.notCheckable = 1;
        info.checked = false;
        info.noClickSound = 1;
        UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL)
    end
end

-- [[ Slash Command ]]
SLASH_BTWQUESTS1 = "/btwquests"
SlashCmdList["BTWQUESTS"] = function(msg)
    if msg == "minimap" then
        BtWQuestsMinimapButton_Toggle()
    else
        if BtWQuestsFrame:IsShown() then
            BtWQuestsFrame:Hide()
        else
            BtWQuestsFrame:Show()
        end
    end
end


-- [[ Hyperlink Handling ]]

local function ChatFrame_Filter(self, event, msg, ...)
    msg = msg:gsub("%[btwquests:([^:]+):(%d+):([^:]+):([^%]]+)%]","|c%3|Hbtwquests:%1:%2|h[%4]|h|r"):gsub("https://www.btwquests.com/([^/]+)/(%d+)[-%w]*","|cffffff00|Hbtwquests:%1:%2|h[%0]|h|r")

	return false, msg, ...;
end

local events = {
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_BN_INLINE_TOAST_BROADCAST",
	"CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_COMMUNITIES_CHANNEL",
};

for i, event in ipairs(events) do
	ChatFrame_AddMessageEventFilter(event, ChatFrame_Filter);
end

-- Convert our links to something valid for blizzard to send
hooksecurefunc("ChatEdit_ParseText", function (editBox, send, parseIfNoSpaces)
    if send == 1 then
        local text = editBox:GetText()
        text = text:gsub("|c(%x*)|Hbtwquests:([^|]+)|h%[([^%[%]]*)%]|h|r", function (color,str,name)
            return string.format("[btwquests:%s:%s:%s]", str, color,name)
        end):gsub("|Hbtwquests:([^|]+)|h%[([^%[%]]*)%]|h", function (str,name)
            return string.format("[btwquests:%s:%s:%s]", str, "ffffff00",name)
        end)
        editBox:SetText(text)
    end
end)

-- Handles shift clicking btwquests links
local original_HandleModifiedItemClick = HandleModifiedItemClick
function HandleModifiedItemClick(link)
    if link and link:find("Hbtwquests") then
        if IsModifiedClick("CHATLINK") then
			ChatEdit_InsertLink(link)
		else
            BtWQuestsFrame:SelectFromLink(link)
		end
    else
        return original_HandleModifiedItemClick(link)
    end
end

-- Handles clicking btwquests links
local original_SetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(link)
    if link:find("^btwquests") then
        if IsModifiedClick("CHATLINK") then
			ChatEdit_InsertLink(link)
        else
            local success, err = pcall(function ()
                BtWQuestsFrame:SelectFromLink(link)
            end)
            if not success then
                print(L["Error viewing link"])
            end
		end
	else
		original_SetHyperlink(self, link);
	end
end
