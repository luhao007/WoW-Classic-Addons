BistooltipAddon = LibStub("AceAddon-3.0"):NewAddon("Bis-Tooltip")
--local AceAddon =

Bistooltip_char_equipment = {}

local function createEquipmentWatcher()
    local frame = CreateFrame("Frame")
    frame:Hide()

    frame:SetScript("OnEvent", frame.Show)
    frame:RegisterEvent("BAG_UPDATE")

    local flag = false

    frame:SetScript("OnUpdate", function(self)
        self:Hide()
        if flag == false then
            flag = true
            local collection = {}
            for bag = 0, NUM_BAG_SLOTS do
                for slot = 1, GetContainerNumSlots(bag) do
                    local itemID = GetContainerItemID(bag, slot)
                    if itemID ~= nil then
                        collection[itemID] = 1
                    end
                end
            end
            for i=0,18 do
                local itemID = GetInventoryItemID("player", i)
                if itemID ~= nil then
                    collection[itemID] = 1
                end
            end
            Bistooltip_char_equipment = collection
            flag = false
        end
    end)
end

function addMapIcon()

    local LDB = LibStub("LibDataBroker-1.1", true)
    local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)
    if LDB then
        local PC_MinimapBtn = LDB:NewDataObject("PoisonCharges", {
            type = "launcher",
			text = "PoisonCharges",
            icon = "interface/icons/inv_weapon_glave_01.blp",
            OnClick = function(_, button)
                if button == "LeftButton" then BistooltipAddon:createMainFrame() end
                if button == "RightButton" then BistooltipAddon:openConfigDialog() end
            end,
            OnTooltipShow = function(tt)
                tt:AddLine(BistooltipAddon.AddonNameAndVersion)
                tt:AddLine("|cffffff00Left click|r to open the BiS lists window")
                tt:AddLine("|cffffff00Right click|r to open addon configuration window")
            end,
        })
        if LDBIcon then
            LDBIcon:Register("PoisonCharges", PC_MinimapBtn, BistooltipAddon.db.char) -- PC_MinimapPos is a SavedVariable which is set to 90 as default
        end
    end
end

function BistooltipAddon:OnInitialize()
    createEquipmentWatcher()
    BistooltipAddon.AceAddonName = "Bis-Tooltip"
    BistooltipAddon.AddonNameAndVersion = "Bis-Tooltip v7.4"
    BistooltipAddon:initConfig()
    addMapIcon()
    BistooltipAddon:initBislists()
    BistooltipAddon:initBisTooltip()
end
