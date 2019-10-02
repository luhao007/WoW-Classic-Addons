local addonName, addon = ...

local function addEventListeners(self)
    addon.core.frame:RegisterEvent("UI_ERROR_MESSAGE")
    addon.core.frame:RegisterEvent("TAXIMAP_OPENED")
end

local function onEvent(self, event, ...)
    local args = {...}
    
    if event == "UI_ERROR_MESSAGE" then
        local msg = args[2];
        local isMountErrorMessage = addon.utils.isMountErrorMessage(msg);
        local isShapeshiftErrorMessage = addon.utils.isShapeshiftErrorMessage(msg);

        if (isMountErrorMessage) then
            UIErrorsFrame:Clear();
            Dismount();
        end

        if (isShapeshiftErrorMessage) then
            if (addon.utils.cancelShapeshiftBuffs()) then
                UIErrorsFrame:Clear();
            end
        end;

        return;
    end

    if event == "TAXIMAP_OPENED" then
        addon.utils.cancelShapeshiftBuffs();
        Dismount();
        return;
    end
end

local function init()
    addon.core = {};
    addon.core.frame = CreateFrame("Frame");
    addon.core.frame:SetScript("OnEvent", onEvent);
    addEventListeners();
end

init();
