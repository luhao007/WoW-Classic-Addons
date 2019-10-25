local addonName, addon = ...

local UI_ERROR_MESSAGES_FOR_MOUNTED = { 
    ERR_ATTACK_MOUNTED,
    ERR_NOT_WHILE_MOUNTED,
    ERR_TAXIPLAYERALREADYMOUNTED,
    SPELL_FAILED_NOT_MOUNTED
};

local UI_ERROR_MESSAGES_FOR_SHAPESHIFTED = {
    ERR_EMBLEMERROR_NOTABARDGEOSET,
    ERR_CANT_INTERACT_SHAPESHIFTED,
    ERR_MOUNT_SHAPESHIFTED,
    ERR_NO_ITEMS_WHILE_SHAPESHIFTED,
    ERR_NOT_WHILE_SHAPESHIFTED,
    ERR_TAXIPLAYERSHAPESHIFTED,
    SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED,
    SPELL_FAILED_NOT_SHAPESHIFT,
    SPELL_NOT_SHAPESHIFTED,
    SPELL_NOT_SHAPESHIFTED_NOSPACE,
};

local GHOST_WOLF_ID = 2645;
local DIRE_BEAR_FORM_ID = 9634;
local TRAVEL_FORM_ID = 783;
local CAT_FORM_ID = 768;
local BEAR_FORM_ID = 5487;
local AQUATIC_FORM_ID = 1066;

local SHAPE_SHIFT_BUFFS = {
    GHOST_WOLF_ID,
    DIRE_BEAR_FORM_ID,
    TRAVEL_FORM_ID,
    CAT_FORM_ID,
    BEAR_FORM_ID,
    AQUATIC_FORM_ID,
};

addon.utils = {};

addon.utils.isMountErrorMessage = function(msg)
    return tContains(UI_ERROR_MESSAGES_FOR_MOUNTED, msg);
end

addon.utils.isShapeshiftErrorMessage = function(msg)
    return tContains(UI_ERROR_MESSAGES_FOR_SHAPESHIFTED, msg);
end

addon.utils.cancelShapeshiftBuffs = function()
    local removedBuff = false;
    for i = 1, 40 do
        local buffId = select(10, UnitBuff("player", i));
        if (tContains(SHAPE_SHIFT_BUFFS, buffId)) then
            removedBuff = true;
            CancelUnitBuff("player", i);
        end
    end
    return removedBuff;
end

addon.utils.printMsg = function(msg)
    print("|cff78a1ffDismounter:|r " .. msg);
end
