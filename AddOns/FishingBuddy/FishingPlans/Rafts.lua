-- Items
--
-- Handle using items with complex requirements.

-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local FL = LibStub("LibFishing-1.0");

local GSB = FishingBuddy.GetSettingBool;
local PLANS = FishingBuddy.FishingPlans

local CurLoc = GetLocale();

local RAFT_RESET_TIME = 30
local RAFT_ID = 85500;
local BERG_ID = 107950;
local BOARD_ID = 166461;

local RaftItems = {};
RaftItems[RAFT_ID] = {
    ["enUS"] =  "Angler's Fishing Raft",
    spell = 124036,
    setting = "UseAnglersRaft",
    toy = 1,
};
RaftItems[BERG_ID] = {
    ["enUS"] = "Bipsi's Bobbing Berg",
    spell = 152421,
    setting = "UseBobbingBerg",
};
RaftItems[BOARD_ID] = {
    ["enUS"] = "Gnarlwood Waveboard",
    spell = 288758,
    setting = "UseWaveboard",
    toy = 1
}


local function HaveRaftBuff()
    return FL:HasBuff(RaftItems[RAFT_ID].spell);
end

local function HaveBergBuff()
    return FL:HasBuff(RaftItems[BERG_ID].spell);
end

local function HaveBoardBuff()
    return FL:HasBuff(RaftItems[BOARD_ID].spell);
end

local function HasRaftBuff()
    return HaveRaftBuff() or HaveBergBuff() or HaveBoardBuff()
end
FishingBuddy.HasRaftBuff = HasRaftBuff

-- have to check this because C_ToyBox.IsToyUsable(RAFT_ID) also
-- checks for revered, which is only necesssar to buy the raft.
local function HasPandarianFishing()
    local skill, _, _, _ = FL:GetContinentSkill(FBConstants.PANDARIA);
    return skill > 0;
end

local function HaveRaft()
    return PlayerHasToy(RAFT_ID) and HasPandarianFishing();
end

local function HaveWaveboard()
    return PlayerHasToy(BOARD_ID);
end

local function HaveBerg()
    return GetItemCount(BERG_ID) > 0;
end

local function HaveRafts()
    local haveRaft = HaveRaft();
    local haveBoard = HaveWaveboard();
    local haveBerg = HaveBerg();
    return (haveRaft or haveBerg or haveBoard), haveRaft, haveBoard, haveBerg
end
FishingBuddy.HaveRafts = HaveRafts

local function SetupRaftOptions()
    local haveAny = HaveRafts();
    local options = {};
    -- if we have both, be smarter about rafts
    options["UseRaft"] = {
        ["tooltip"] = FBConstants.CONFIG_USERAFTS_INFO,
        ["tooltipd"] = FBConstants.CONFIG_USERAFTS_INFOD,
        ["text"] = FBConstants.CONFIG_USERAFTS_ONOFF,
        ["enabled"] = HaveRafts;
        ["v"] = 1,
        ["default"] = true
    };

    options["BergMaintainOnly"] = {
        ["text"] = FBConstants.CONFIG_MAINTAINRAFTBERG_ONOFF,
        ["tooltip"] = FBConstants.CONFIG_MAINTAINRAFT_INFO,
        ["default"] = true,
        ["v"] = 1,
        ["parents"] = { ["UseRaft"] = "d", }
    };
    options["OverWalking"] = {
        ["text"] = FBConstants.CONFIG_OVERWALKING_ONOFF,
        ["tooltip"] = FBConstants.CONFIG_OVERWALKING_INFO,
        ["default"] = false,
        ["v"] = 1,
        ["parents"] = { ["UseRaft"] = "d", }
    };

    return options
end

-- Don't cast the angler's raft if we're doing Scavenger Hunt or on Inkgill Mere
local function RaftBergUsable()
    if (not GSB("UseRaft") or IsMounted()) then
        return false
    elseif FL:HasBuff(201944) then
        -- Surface Tension
        return GSB("OverWalking");
    else
        -- Raft quests
        return not (FL:HasBuff(116032) or FL:HasBuff(119700));
    end
end

local function RaftingPlan(queue)
    local haveAny, haveRaft, haveBoard, haveBerg = HaveRafts()
    if (haveAny and RaftBergUsable()) then
        local hasraftbuff = HasRaftBuff();

        local need = not hasraftbuff;

        -- if we need it, but we're maintaining only, skip it
        if (GSB("BergMaintainOnly") and need) then
            return;
        end

        local buff, itemid, name;
        buff = nil
        if (haveBerg) then
            itemid = BERG_ID;
        elseif (haveBoard and haveRaft) then
            if math.random(100) < 50 then
                itemid = BOARD_ID;
            else
                itemid = RAFT_ID;
            end
        elseif (haveBoard) then
            itemid = BOARD_ID;
        elseif (haveRaft) then
            itemid = RAFT_ID;
        end
        buff = RaftItems[itemid].spell;
        name = RaftItems[itemid][CurLoc];
        if RaftItems[itemid].toy then
            _, itemid = C_ToyBox.GetToyInfo(BOARD_ID)
        end
        if buff then
            local _, et = FL:HasAnyBuff(RaftItems)
            et = (et or 0) - GetTime();
            if (need or et <= RAFT_RESET_TIME) then
                PLANS:AddEntry(itemid, name)
            end
        end
    end
end

local RaftEvents = {}
RaftEvents[FBConstants.FIRST_UPDATE_EVT] = function()
    FishingBuddy.SetupSpecialItems(RaftItems, false, true, true)
    local options = SetupRaftOptions();
    FishingBuddy.raftoptions = options
    if options then
        FishingBuddy.AddFluffOptions(options);
        PLANS:RegisterPlan(RaftingPlan)
    end
end

FishingBuddy.RegisterHandlers(RaftEvents);

FishingBuddy.Commands["raft"] = {};
FishingBuddy.Commands["raft"].func =
    function()
        local skill, _, _, _ = FL:GetContinentSkill(FBConstants.PANDARIA);
        FishingBuddy_Info["RaftDebug"] = {
            ["RaftOption"] = GSB("UseRaft"),
            ["RaftQuests"] = {
                ["116032"] = FL:HasBuff(116032),
                ["119700"] = FL:HasBuff(119700),
            },
            ["SurfaceTension"] = GSB("OverWalking"),
            ["HaveRaft"] = PlayerHasToy(RAFT_ID),
            ["UseableRaft"] = C_ToyBox.IsToyUsable(RAFT_ID),
            ["RaftInfo"] = C_ToyBox.GetToyInfo(RAFT_ID),
            ["BergCount"] = GetItemCount(BERG_ID),
            ["Maintain"] = GSB("BergMaintainOnly"),
            ["UseBerg"] = GSB("UseBobbingBerg"),
            ["PandarenSkill"] = skill
        };
        return true;
    end
