-- FishingBuddy
--
-- Manage the fishing macro
--
-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local FL = LibStub("LibFishing-1.0");
local LO = LibStub("LibOptionsFrame-1.0");

local MACRO_EDITOR_NAME = "FishingBuddyOption_MacroEditor"
local GSB = FishingBuddy.GetSettingBool;

local MacroOptions = {
	["CreateMacro"] = {
		["text"] = FBConstants.CONFIG_CREATEMACRO_ONOFF,
		["tooltip"] = FBConstants.CONFIG_CREATEMACRO_INFO,
		["v"] = 1,
		["global"] = 1,
        ["default"] = false,
    },
    ["MacroName"] = {
        ["button"] = MACRO_EDITOR_NAME,
        ["alone"] = 1,
        ["v"] = 1,
        ["global"] = 1,
        ["setup"] = function(self)
            self:FixSizes()
        end,
        ["default"] = FBConstants.MACRONAME,
        ["parents"] = { ["CreateMacro"] = "h" },
    },
	["PreventRecast"] = {
		["text"] = FBConstants.CONFIG_PREVENTRECAST_ONOFF,
		["tooltip"] = FBConstants.CONFIG_PREVENTRECAST_INFO,
		["v"] = 1,
		["global"] = 1,
		["default"] = false,
        ["parents"] = { ["CreateMacro"] = "d" },
    },
	["ToonMacro"] = {
		["text"] = FBConstants.CONFIG_TOONMACRO_ONOFF,
		["tooltip"] = FBConstants.CONFIG_TOONMACRO_INFO,
		["v"] = 1,
		["global"] = 1,
		["default"] = false,
        ["parents"] = { ["CreateMacro"] = "d" },
    },
};


local MacroEditBox =
{
    ["name"] = "FB_MacroEditBox",
    ["rightextra"] = 32,
    ["label"] = NAME,
    ["setting"] = "MacroName"
};

-- Move a macro from global to perchar, or vice versa
local function GetMacroIndex(macroname)
    for idx = 1, _G.MAX_ACCOUNT_MACROS + _G.MAX_CHARACTER_MACROS do
        local name, icon, body = GetMacroInfo(idx)
        if (name and macroname == name) then
            return idx;
        end
    end
end

local function CreateOrUpdateMacro(name, icon, body, perchar)
    if not FishingBuddy.CheckCombat() then
        if name and icon and body then
            local exists = GetMacroIndex(name);
            if (exists) then
                local isglobal = (exists <= _G.MAX_ACCOUNT_MACROS);
                if ((perchar and isglobal) or (not perchar and not isglobal)) then
                    -- switch per char and global
                    DeleteMacro(name);
                    exists = nil;
                end
            end

            if (exists) then
                EditMacro(name, nil, icon, body, 1, perchar);
            else
                CreateMacro(name, icon, body, perchar);
            end
        end
    end
end

local function BuildFishingMacro()
    local _, fishing = FL:GetFishingSpellInfo();
    local update, id, name = FishingBuddy.GetUpdateLure();
    local bag, slot;
    if (update) then
        bag, slot = FL:FindThisItem(id);
    end

    local action = "";
    if (slot) then
        action = "/stopcasting\n/use "
        if (bag) then
            action = action..bag
        end
        action = action.." "..slot.."\n";
    else
        action = "/cast ";
        if (GSB("PreventRecast")) then
            action = action.." [nochanneling:"..fishing.."] ";
        else
            action = "/stopcasting\n"..action;
        end
        action = action..fishing
    end
    return "#showtooltip Fishing\n/fb macro\n"..action
end

local function FishingMacro()
    local macrotext = BuildFishingMacro();
    local macro_name = FishingBuddy.GetSetting("MacroName");
    CreateOrUpdateMacro(macro_name, "INV_Fishingpole_02", macrotext, GSB("ToonMacro"));
end
FishingBuddy.FishingMacro = FishingMacro;

local function SetupMacroKeyBinding()
    local key1, key2 = GetBindingKey("FISHINGBUDDY_GOFISHING");
    if key1 or key2 then
        local macro_set;
        local GSB = FishingBuddy.GetSettingBool;
        if GSB("ToonMacro") then
            macro_set = CHARACTER_BINDINGS;
        else
            macro_set = ACCOUNT_BINDINGS;
        end
        local macro_name = FishingBuddy.GetSetting("MacroName");
        local command = "MACRO "..macro_name;
        if key1 then
            SetOverrideBinding(FishingBuddyFrame, true, key1, command, macro_set);
        end
        if key2 then
            SetOverrideBinding(FishingBuddyFrame, true, key2, command, macro_set);
        end
        return true
    else
        ClearOverrideBindings(FishingBuddyFrame);
    end
    return false
end
FishingBuddy.SetupMacroKeyBinding = SetupMacroKeyBinding

local function CreateFishingMacro()
    local numglobal,numperchar = GetNumMacros();
    local perchar = nil;
    local fullup;
    if (GSB("ToonMacro")) then
        if (numperchar >= _G.MAX_CHARACTER_MACROS) then
            fullup = FBConstants.NOCREATEMACROPER;
        end
    else
        if (numglobal >= _G.MAX_ACCOUNT_MACROS) then
            fullup = FBConstants.NOCREATEMACROGLOB;
        end
    end

    if (fullup) then
        local macro_name = FishingBuddy.GetSetting("MacroName");
        FishingBuddy.Message(fullup.."\""..macro_name.."\"", 1, 0, 0);
        return false;
    end
    FishingMacro();
    return true;
end
FishingBuddy.CreateFishingMacro = CreateFishingMacro

local function PrepareEditBox()
    MacroEditBox['getter'] = FishingBuddy.GetSetting;
    MacroEditBox['setter'] = FishingBuddy.SetSetting;
    local editbox = LO:CreateEditBox(MacroEditBox)
    local holder = FishingBuddy.CreateLabeledThing(MACRO_EDITOR_NAME, NAME, editbox)
    holder.button = CreateFrame("Button", nil, holder, "UIPanelButtonTemplate");
    holder.button:SetScript("OnClick", CreateFishingMacro)
    holder.button:ClearAllPoints()
    holder.button:SetPoint("CENTER", holder, "CENTER");
    holder.button:SetPoint("TOP", holder.thing, "BOTTOM", 0, -8);
    holder.button:SetHeight(21);
    holder.button.Text:SetText(CREATE_PROFESSION)
    holder.button:SetWidth(holder.button.Text:GetWidth() + 32)
    holder.height_adjust = holder.button:GetHeight() + 16;
    holder:FixSizes();
end

local MacroEvents = {}
MacroEvents["VARIABLES_LOADED"] = function(started)
    PrepareEditBox()
    FishingBuddy.OptionsFrame.HandleOptions(MACROS, "Interface\\Icons\\INV_Misc_PaperBundle04a", MacroOptions);
end

MacroEvents[FBConstants.OPT_UPDATE_EVT] = function()
    local macro_name = FishingBuddy.GetSetting("MacroName");
    if GetMacroIndex(macro_name) then
        SetupMacroKeyBinding();
    end

    if (false) then
    -- make sure we have the Macro globals
        if (not IsAddOnLoaded("Blizzard_MacroUI")) then
            LoadAddOn("Blizzard_MacroUI");
        end
    end
end

FishingBuddy.RegisterHandlers(MacroEvents);

