-- **************************************************************************
-- * Titan Raid Lockout
-- *
-- * By: Gamut - Nethergarde Keep EU
-- **************************************************************************
local addonName, addonTable = ...
local _G = getfenv()

-- **************************************************************************
--  Constants
-- **************************************************************************

local TITAN_RAIDLOCKOUT_ID = addonName
local VERSION = GetAddOnMetadata(GetAddOnInfo(TITAN_RAIDLOCKOUT_ID), "Version")
local COLOR = {
    ["white"] = "|cFFFFFFFF",
    ["grey"] = "|cFFA9A9A9",
    ["red"] = "|cFFDE1010",
    ["green"] = GREEN_FONT_COLOR_CODE,
    ["yellow"] = "|cFFFFF244",
    ["heroic"] = "|cFFFFB700",
    ["orange"] = "|cFFFF8C00",
    ["classic"] = "|cFFCE8731"
}
local PLAYER_NAME = UnitName("player")
local PLAYER_REALM = GetRealmName()

-- Init all heroic names
local LOCALIZED_TBC_HEROIC_NAMES = {
    ["BM"] = GetRealZoneText(269),
    ["TSH"] = GetRealZoneText(540),
    ["BF"] = GetRealZoneText(542),
    ["HR"] = GetRealZoneText(543),
    ["SV"] = GetRealZoneText(545),
    ["UB"] = GetRealZoneText(546),
    ["SP"] = GetRealZoneText(547),
    ["ARC"] = GetRealZoneText(552),
    ["BOT"] = GetRealZoneText(553),
    ["MECH"] = GetRealZoneText(554),
    ["SL"] = GetRealZoneText(555),
    ["SEH"] = GetRealZoneText(556),
    ["MT"] = GetRealZoneText(557),
    ["AC"] = GetRealZoneText(558),
    ["OHF"] = GetRealZoneText(560),
    ["MAT"] = GetRealZoneText(585)
}
local LOCALIZED_WOTLK_HEROIC_NAMES = {
    ["UK"] = GetRealZoneText(574),
    ["UP"] = GetRealZoneText(575),
    ["NEX"] = GetRealZoneText(576),
    ["OC"] = GetRealZoneText(578),
    ["CoS"] = GetRealZoneText(595),
    ["HoS"] = GetRealZoneText(599),
    ["DTK"] = GetRealZoneText(600),
    ["AN"] = GetRealZoneText(601),
    ["HoL"] = GetRealZoneText(602),
    ["GUN"] = GetRealZoneText(604),
    ["VH"] = GetRealZoneText(608),
    ["AK"] = GetRealZoneText(619),
    ["FoS"] = GetRealZoneText(632),
    ["ToC5"] = GetRealZoneText(650),
    ["PoS"] = GetRealZoneText(658),
    ["HoR"] = GetRealZoneText(668)
}

-- Init all raid names
local LOCALIZED_CLASSIC_RAID_NAMES = {
    ["ZG"] = GetRealZoneText(309),
    ["MC"] = GetRealZoneText(409),
    ["BWL"] = GetRealZoneText(469),
    ["AQ20"] = GetRealZoneText(509),
    ["AQ40"] = GetRealZoneText(531)
}
local LOCALIZED_TBC_RAID_NAMES = {
    ["KARA"] = GetRealZoneText(532),
    ["HY"] = GetRealZoneText(534),
    ["MAG"] = GetRealZoneText(544),
    ["SSC"] = GetRealZoneText(548),
    ["TK"] = GetRealZoneText(550),
    ["BT"] = GetRealZoneText(564),
    ["GRU"] = GetRealZoneText(565),
    ["ZA"] = GetRealZoneText(568),
    ["SUN"] = GetRealZoneText(580)
}
local LOCALIZED_WOTLK_RAID_NAMES = {
    ["ONY"] = GetRealZoneText(249),
    ["NAXX"] = GetRealZoneText(533),
    ["ULD"] = GetRealZoneText(603),
    ["OS"] = GetRealZoneText(615),
    ["EoE"] = GetRealZoneText(616),
    ["VoA"] = GetRealZoneText(624),
    ["ICC"] = GetRealZoneText(631),
    ["ToC"] = GetRealZoneText(649),
    ["RS"] = GetRealZoneText(724)
}

-- Collect separate heroics tables into one table
local LOCALIZED_ALL_HEROIC_NAMES = {}
for k, v in pairs(LOCALIZED_TBC_HEROIC_NAMES) do
    LOCALIZED_ALL_HEROIC_NAMES[k] = v
end
for k, v in pairs(LOCALIZED_WOTLK_HEROIC_NAMES) do
    LOCALIZED_ALL_HEROIC_NAMES[k] = v
end

-- Collect separate raids tables into one table
local LOCALIZED_ALL_RAID_NAMES = {}
for k, v in pairs(LOCALIZED_CLASSIC_RAID_NAMES) do
    LOCALIZED_ALL_RAID_NAMES[k] = v
end
for k, v in pairs(LOCALIZED_TBC_RAID_NAMES) do
    LOCALIZED_ALL_RAID_NAMES[k] = v
end
for k, v in pairs(LOCALIZED_WOTLK_RAID_NAMES) do
    LOCALIZED_ALL_RAID_NAMES[k] = v
end

local LOCKOUT_DATA = {}

local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

-- **************************************************************************
--  Addon setup and Titan Panel integration
-- **************************************************************************

function TRaidLockout_Init()
    if (myAddOnsFrame_Register) then
        myAddOnsFrame_Register({
            name = TITAN_RAIDLOCKOUT_ID,
            version = VERSION,
            category = MYADDONS_CATEGORY_PLUGINS
        })
    end
end

function TRaidLockout_OnLoad(self)
    self.registry = {
        id = TITAN_RAIDLOCKOUT_ID,
        menuText = "Raid Lockout",
        buttonTextFunction = "TRaidLockout_GetButtonText",
        tooltipTitle = "Raid Lockout",
        tooltipTextFunction = "TRaidLockout_GetTooltip",
        icon = "Interface\\Icons\\inv_misc_head_dragon_bronze",
        iconWidth = 16,
        iconButtonWidth = 16,
        category = "Information",
        version = VERSION,
        savedVariables = { -- Global for TitanPanel saves into "WTF/Account/[AccountName]/SavedVariables/TitanClassic.lua"
            ShowTooltipHeader = true,
            ShowAllCharacters = false,
            ShowUnlockedButton = false,
            ShowHeroicsButton = true,
            ShowUnlockedTooltip = false,
            ShowClassicRaidsInTooltip = true,
            ShowTBCRaidsInTooltip = true,
            ShowHeroicsInTooltip = true,
            ShowIcon = true,
            ShowColoredText = true,
            ShowLabelText = true
        }
    }
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UPDATE_INSTANCE_INFO")
end

function TRaidLockout_OnEvent(self, event, ...)
    if (event == "ADDON_LOADED") then
        TRaidLockout_Init()
        TRaidLockout_SetupSavedVariableTemplate()
    elseif (event == "UPDATE_INSTANCE_INFO") then
        TRaidLockout_UpdateLockoutData()
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    elseif (event == "PLAYER_ENTERING_WORLD") then
        TRaidLockout_ReadSavedVariableIntoLockoutData()
        TRaidLockout_UpdateLockoutData()
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    end
end

function TRaidLockout_SetupSavedVariableTemplate()
    if _G["SavedLockoutTable"] == nil or _G["SavedLockoutTable"]["Players"] == nil then
        _G["SavedLockoutTable"] = {
            ["Players"] = {}
        }
    end
    if _G["SavedLockoutTable"]["Players"][PLAYER_REALM] == nil then
        _G["SavedLockoutTable"]["Players"] = {
            [PLAYER_REALM] = {}
        }
    end
    if _G["SavedLockoutTable"]["Players"][PLAYER_REALM][PLAYER_NAME] == nil then
        _G["SavedLockoutTable"]["Players"][PLAYER_REALM][PLAYER_NAME] = {
            ["Lockouts"] = {},
            ["NumSaved"] = 0
        }
    end
end

function TRaidLockout_GetButtonText()
    TRaidLockout_SetButtonText()
    return buttonLabel, buttonText
end

function TRaidLockout_GetTooltip()
    TRaidLockout_SetTooltip()
    return tooltipText
end

function TRaidLockoutButton_OnClick(self, button)
    if button == "LeftButton" then
        ToggleFriendsFrame(4)
        RaidInfoFrame:Show()
    end
end

function TitanPanelRightClickMenu_PrepareTitanRaidLockoutMenu()

    local info

    -- Level 2
    if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
        if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "PanelOptions" then
            TitanPanelRightClickMenu_AddTitle(L["PanelOptions"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"])

            info = {};
            info.text = L["ShowAllRaids"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
                TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"])

            info = {};
            info.text = L["ShowLockedHeroics"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsButton")
                TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsButton")
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"])

        end

        if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "TooltipOptions" then
            TitanPanelRightClickMenu_AddTitle(L["TooltipOptions"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

            info = {};
            info.text = L["ShowLayoutHint"]
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"])

            info = {};
            info.text = L["ShowNonLockedCharacters"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowAllCharacters")
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowAllCharacters");
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

            info = {};
            info.text = L["TooltipShowClassicRaids"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowClassicRaidsInTooltip")
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowClassicRaidsInTooltip")
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

            info = {};
            info.text = L["TooltipShowTBCRaids"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowTBCRaidsInTooltip")
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTBCRaidsInTooltip")
            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

            info = {};
            info.text = L["TooltipShowHeroics"];
            info.func = function()
                TitanToggleVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsInTooltip")
            end
            info.checked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsInTooltip")

            L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"])
        end

        return
    end

    -- Level 1
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RAIDLOCKOUT_ID].menuText);

    info = {};
    info.notCheckable = true
    info.text = L["PanelOptions"];
    info.value = "PanelOptions"
    info.hasArrow = 1;
    L_UIDropDownMenu_AddButton(info);

    info = {};
    info.notCheckable = true
    info.text = L["TooltipOptions"];
    info.value = "TooltipOptions"
    info.hasArrow = 1;
    L_UIDropDownMenu_AddButton(info);

    TitanPanelRightClickMenu_AddSpacer()
    TitanPanelRightClickMenu_AddToggleIcon(TITAN_RAIDLOCKOUT_ID);
    TitanPanelRightClickMenu_AddToggleColoredText(TITAN_RAIDLOCKOUT_ID)
    TitanPanelRightClickMenu_AddToggleLabelText(TITAN_RAIDLOCKOUT_ID)
    TitanPanelRightClickMenu_AddSpacer()
    TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_RAIDLOCKOUT_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TRaidLockout_UNIXTimeToDateTimeString(unixTime)
    unixTime = unixTime + 5 -- add 5 sec for leeway
    local dateTable = date("*t", unixTime)
    return date("%a %d/%m %H:%M", time(dateTable))
end

-- **************************************************************************
--  Lockout save data handling
-- **************************************************************************
function TRaidLockout_ReadSavedVariableIntoLockoutData()
    LOCKOUT_DATA = _G["SavedLockoutTable"]
end

function TRaidLockout_WriteLockoutDataToSavedVariable()
    _G["SavedLockoutTable"] = LOCKOUT_DATA
end

function TRaidLockout_RemoveExpiredLockoutData()

    -- Find any rows with expired lockouts that need to be deleted
    local toRemove = {}
    for realm, realmData in pairs(LOCKOUT_DATA["Players"]) do
        for player, playerData in pairs(realmData) do
            local numSaved = playerData["NumSaved"]
            if playerData["Lockouts"] ~= nil then
                for instanceName, instanceData in pairs(playerData["Lockouts"]) do
                    if GetServerTime() > instanceData["Reset"] then
                        table.insert(toRemove, {realm, player, instanceName})
                    end
                end
            end
        end
    end

    -- Delete found rows from data table
    if toRemove ~= nil then
        for count, removeRow in pairs(toRemove) do
            local server = removeRow[1]
            local char = removeRow[2]
            local instance = removeRow[3]
            LOCKOUT_DATA["Players"][server][char]["Lockouts"][instance] = nil
            LOCKOUT_DATA["Players"][server][char]["NumSaved"] = LOCKOUT_DATA["Players"][server][char]["NumSaved"] - 1
        end
    end

end

function TRaidLockout_UpdateLockoutData()
    local numSaved = GetNumSavedInstances()

    -- If client gives no lockouts; Clear any saved data for character, and exit function
    if numSaved == 0 then
        LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["Lockouts"] = {}
        LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["NumSaved"] = 0
        TRaidLockout_RemoveExpiredLockoutData()
        return -- Exit
    end

    -- Save character data
    LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["NumSaved"] = GetNumSavedInstances()
    for savedIndex = 1, numSaved do
        local name, _, reset, _, _, _, _, _, _, _, numEncounters, encounterProgress, _ =
            GetSavedInstanceInfo(savedIndex)

        LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["Lockouts"][name] = {
            ["Reset"] = reset + GetServerTime(),
            ["Progress"] = encounterProgress,
            ["Encounters"] = numEncounters
        }
    end

    -- Update SavedVariable (to be written on the next loadscreen/relog/game exit)
    TRaidLockout_WriteLockoutDataToSavedVariable()
end

-- **************************************************************************
--  Panel button text
-- **************************************************************************
function TRaidLockout_SetButtonText()

    local numSaved = GetNumSavedInstances()
    local coloredText = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowColoredText")
    local showUnlocked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    local showHeroics = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsButton")
    buttonLabel = L["Lockout: "]
    buttonText = TitanUtils_Ternary(coloredText, COLOR.orange, COLOR.white)

    local heroicsTableWoTLK = {
        -- key, subTable{ localized abbr, is locked }
        ["UK"] = {L["UK"], false},
        ["UP"] = {L["UP"], false},
        ["NEX"] = {L["NEX"], false},
        ["OC"] = {L["OC"], false},
        ["CoS"] = {L["CoS"], false},
        ["HoS"] = {L["HoS"], false},
        ["DTK"] = {L["DTK"], false},
        ["AN"] = {L["AN"], false},
        ["HoL"] = {L["HoL"], false},
        ["GUN"] = {L["GUN"], false},
        ["VH"] = {L["VH"], false},
        ["AK"] = {L["AK"], false},
        ["FoS"] = {L["FoS"], false},
        ["ToC5"] = {L["ToC5"], false},
        ["PoS"] = {L["PoS"], false},
        ["HoR"] = {L["HoR"], false}
    }

    local raidsTableWoTLK = {
        -- key, subTable{ localized abbr, is locked }
        ["ONY"] = {L["ONY"], false},
        ["NAXX"] = {L["NAXX"], false},
        ["ULD"] = {L["ULD"], false},
        ["OS"] = {L["OS"], false},
        ["EoE"] = {L["EoE"], false},
        ["VoA"] = {L["VoA"], false},
        ["ICC"] = {L["ICC"], false},
        ["TOC"] = {L["TOC"], false},
        ["RS"] = {L["RS"], false}
    }

    if showUnlocked then -- Show green abbr

        if numSaved > 0 then
            -- Loop thru all saved instances, check if this instance in the loop is a Heroic Dungeon
            if showHeroics then
                for savedIndex = 1, numSaved do
                    local name = GetSavedInstanceInfo(savedIndex)
                    if TitanUtils_TableContainsValue(LOCALIZED_WOTLK_HEROIC_NAMES, name) then

                        for key, subTable in pairs(heroicsTableWoTLK) do
                            if name == LOCALIZED_WOTLK_HEROIC_NAMES[key] then
                                buttonText = buttonText .. " " .. subTable[1]
                                subTable[2] = true
                            end
                        end

                    end
                end
            end

            if coloredText then
                buttonText = buttonText .. COLOR.red
            end
            -- Loop again and check if this instance in the loop is a Raid
            for savedIndex = 1, numSaved do
                local name = GetSavedInstanceInfo(savedIndex)
                if TitanUtils_TableContainsValue(LOCALIZED_ALL_RAID_NAMES, name) then

                    for key, subTable in pairs(raidsTableWoTLK) do
                        if name == LOCALIZED_ALL_RAID_NAMES[key] then
                            buttonText = buttonText .. " " .. subTable[1]
                            subTable[2] = true
                        end
                    end

                end
            end
        end

        buttonText = buttonText .. COLOR.white

        buttonText = buttonText .. TitanUtils_Ternary(coloredText, COLOR.green, " |")

        for index, subTable in pairs(raidsTableWoTLK) do
            if not subTable[2] then
                buttonText = buttonText .. " " .. subTable[1]
            end
        end

    else -- Don't show green abbr
        if numSaved > 0 then
            -- Loop thru all saved instances, check if this instance in the loop is a Heroic Dungeon
            if showHeroics then
                for savedIndex = 1, numSaved do
                    local name = GetSavedInstanceInfo(savedIndex)
                    if TitanUtils_TableContainsValue(LOCALIZED_WOTLK_HEROIC_NAMES, name) then
                        for key, subTable in pairs(heroicsTableWoTLK) do
                            if name == LOCALIZED_WOTLK_HEROIC_NAMES[key] then
                                buttonText = buttonText .. " " .. subTable[1]
                            end
                        end
                    end
                end
            end

            if coloredText then
                buttonText = buttonText .. COLOR.red
            end
            -- Loop again and check if this instance in the loop is a Raid
            for savedIndex = 1, numSaved do
                local name = GetSavedInstanceInfo(savedIndex)
                if TitanUtils_TableContainsValue(LOCALIZED_ALL_RAID_NAMES, name) then
                    for key, subTable in pairs(raidsTableWoTLK) do
                        if name == LOCALIZED_ALL_RAID_NAMES[key] then
                            buttonText = buttonText .. " " .. subTable[1]
                        end
                    end
                end
            end
        end
    end

end

-- **************************************************************************
--  Panel tooltip
-- **************************************************************************
function TRaidLockout_ToolTip_InstanceDataLoop(localizedInstanceTable, charData, raidNameColor)

    local resultText = ""

    for instanceName, instanceData in pairs(charData) do

        if TitanUtils_TableContainsValue(localizedInstanceTable, instanceName) then

            local dateToReset = TRaidLockout_UNIXTimeToDateTimeString(instanceData["Reset"])
            local encounterProgress = instanceData["Progress"]
            local numEncounters = instanceData["Encounters"]

            local progress = ""
            if (encounterProgress < numEncounters) then
                progress = progress .. COLOR.green .. encounterProgress
            else
                progress = progress .. COLOR.yellow .. encounterProgress
            end

            resultText = resultText .. raidNameColor .. " - " .. instanceName .. COLOR.white .. " [" .. progress ..
                             COLOR.yellow .. "/" .. numEncounters .. COLOR.white .. "]" .. COLOR.yellow .. " \t " ..
                             dateToReset .. "\n"
        end

    end

    return resultText

end

function TRaidLockout_ToolTip_StringFormat_PlayerCharLockouts(isPlayerChar, showAllChars, numSaved, charData)

    local resultText = ""
    local showClassicRaids = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowClassicRaidsInTooltip")
    local showTBCRaids = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTBCRaidsInTooltip")
    local showHeroicsTooltip = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowHeroicsInTooltip")

    if isPlayerChar and numSaved < 1 or showAllChars and numSaved < 1 then
        resultText = COLOR.green .. " - " .. L["All raids and heroics are unlocked"] .. COLOR.white .. "\n"
    else
        -- Show any heroics first
        local heroicsResultsText = TitanUtils_Ternary(showHeroicsTooltip, TRaidLockout_ToolTip_InstanceDataLoop(
            LOCALIZED_ALL_HEROIC_NAMES, charData, COLOR.heroic), "")

        -- Then show any classic raids
        local classicResultsText = TitanUtils_Ternary(showClassicRaids, TRaidLockout_ToolTip_InstanceDataLoop(
            LOCALIZED_CLASSIC_RAID_NAMES, charData, COLOR.classic), "")

        -- Then show any tbc raids
        local tbcResultsText = TitanUtils_Ternary(showClassicRaids, TRaidLockout_ToolTip_InstanceDataLoop(
            LOCALIZED_TBC_RAID_NAMES, charData, COLOR.classic), "")

        -- Then show any wotlk raids
        local wotlkResultsText = TRaidLockout_ToolTip_InstanceDataLoop(LOCALIZED_WOTLK_RAID_NAMES, charData,
            COLOR.orange)

        resultText = resultText .. heroicsResultsText .. classicResultsText .. tbcResultsText .. wotlkResultsText
    end

    return resultText

end

function TRaidLockout_ToolTip_StringFormat_AnyCharLockouts(charServer, charName, numSaved, charData)

    local showAllChars = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowAllCharacters")

    -- Check if this is the current character
    if charServer == PLAYER_REALM and charName == PLAYER_NAME then
        return ""
    else
        if numSaved == 0 and not showAllChars then
            return ""
        else
            if charServer == PLAYER_REALM then
                return "\n" .. COLOR.yellow .. charName .. "\n" ..
                           TRaidLockout_ToolTip_StringFormat_PlayerCharLockouts(false, showAllChars, numSaved, charData)
            else
                return "\n" .. COLOR.yellow .. charName .. "-" .. charServer .. "\n" ..
                           TRaidLockout_ToolTip_StringFormat_PlayerCharLockouts(false, showAllChars, numSaved, charData)
            end
        end
    end

end

function TRaidLockout_SetTooltip()

    TRaidLockout_RemoveExpiredLockoutData()

    tooltipText = ""
    local numSaved = GetNumSavedInstances()
    local showHeader = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    local headerText = ""

    if showHeader then
        headerText = headerText .. COLOR.grey .. L["Instance Name [Bosses]"] .. "\t" .. COLOR.grey .. L["Reset Time"] ..
                         "\n"
    end

    tooltipText = tooltipText .. headerText

    -- :: Loop thru LOCKOUT_DATA for ToolTip in certain order for to get ordered output ::

    -- 1. output THIS player
    tooltipText = tooltipText .. "\n" .. COLOR.green .. PLAYER_NAME .. COLOR.yellow .. "\n" ..
                      TRaidLockout_ToolTip_StringFormat_PlayerCharLockouts(true, false,
            LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["NumSaved"],
            LOCKOUT_DATA["Players"][PLAYER_REALM][PLAYER_NAME]["Lockouts"])

    -- 2. loop thru THIS server, skipping the player char since it's already been output
    for charName, charData in pairs(LOCKOUT_DATA["Players"][PLAYER_REALM]) do
        if charData["Lockouts"] ~= nil then
            tooltipText = tooltipText ..
                              TRaidLockout_ToolTip_StringFormat_AnyCharLockouts(PLAYER_REALM, charName,
                    charData["NumSaved"], charData["Lockouts"])
        end
    end

    -- 3. loop thru all servers and SKIP THIS server since it's already been output
    for serverName, character in pairs(LOCKOUT_DATA["Players"]) do
        if serverName ~= PLAYER_REALM then
            for charName, charData in pairs(character) do
                if charData["Lockouts"] ~= nil then
                    tooltipText = tooltipText ..
                                      TRaidLockout_ToolTip_StringFormat_AnyCharLockouts(serverName, charName,
                            charData["NumSaved"], charData["Lockouts"])
                end
            end
        end
    end

end
