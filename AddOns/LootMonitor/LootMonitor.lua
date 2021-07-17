--[[
    LootMonitor 3.00+
    Special Thanks to 梦幻俏俏-希尔盖-CN for testing.

    3.23
    Can't move frame while in combat.

    3.22
    Add Minimap button.
    Can use ESC to close Set/Output Window.
    Other fix.

    What's New?
    Add Raid Instance Player Enter Announce.
    Use UNIT_FLAGS to flag who first opened monster's corpse.
    Add LootLog Function with Class color.
    Using ChatThrottleLib to send ChatAddonMessage.
    Add Self-Maintenance mod.
    Add Looter Class Dyeing and Boss Dyeing.

    LootMonitor 2.10
    Reduce info.

    LootMonitor 2.06
    Fix Bug.

    2.05
    Update toc.

    2.04
    Fix: Sometime Announce.Index isn't legal.

    2.03
    Add: Always Announcer the Looter Checkbox

    2.02
    Fix: CHAT_MSG_ADDON: LMPX, "end CorpseGUID NumQuality" instead "end CorpseGUID Num".
    Get Correct Quality Rank.

    2.01
    What's New?
    1. Rewrite Sync Function, use table replace single variables to store group's states, make code more readable.
    2. Make Addon work correct in party mode. Caused by Party Sequence, Only Announce Loots when Party Leader Installed this Addon.
    3. Compatible with older Version. (1.38, 1.39 and 1.40)
    4. Make GUI more pleasing to the eye. Now, Announcer in group will mark as Crimson, player who do not have this Addon will display as Grey.
    5. Add Single Disable Mode. You will not announce anything if all group member except you do not installed this Addon.
]]

local AddonName, Addon = ...

-- 主Frame（不可见）
Addon.Frame = CreateFrame("Frame")
-- 设置界面（界面逻辑放置于GUI.lua）
Addon.SetWindow = {}
Addon.GroupState = {} -- 40个状态栏
Addon.Output = {} --输出窗口
Addon.MinimapIcon = {} -- 小地图按钮
-- 本地化相关
local L = Addon.L

-- 相关变量
local Frame = Addon.Frame
local SetWindow = Addon.SetWindow
local Output = Addon.Output
local MinimapIcon = Addon.MinimapIcon
Frame:Hide() -- 隐藏Frame，避免Update开销
-- 版本号（不再读取toc文件，/reload后版本号立刻生效）
Addon.Version = "3.30"
local Version = tonumber(Addon.Version)
-- Addon MSG Prefix
local PrefixLM = "LMPX"
local Priority = {"BULK","NORMAL","ALERT"}
-- WOW API加速
-- 普通函数
local UnitName = UnitName
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsFeignDeath = UnitIsFeignDeath
local UnitIsPlayer = UnitIsPlayer
local UnitInRaid = UnitInRaid
local UnitIsAFK = UnitIsAFK
local UnitExists = UnitExists
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsInInstance = IsInInstance
local IsFishingLoot = IsFishingLoot
local UnitInBattleground = UnitInBattleground
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsConnected = UnitIsConnected
local UnitAffectingCombat = UnitAffectingCombat
local UnitPosition = UnitPosition
local UnitIsFriend = UnitIsFriend
local GetTime = GetTime
local GetNumGroupMembers = GetNumGroupMembers
local GetLootInfo = GetLootInfo
local GetLootSlotLink = GetLootSlotLink
local GetCVar = GetCVar
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetLootSourceInfo = GetLootSourceInfo
local SendChatMessage = SendChatMessage
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
-- Lua方法加速
local date = date
local time = time
local t_insert = table.insert
local t_remove = table.remove
local strsplit = strsplit
-- 同步相关函数
-- local SendAddonMessage = ChatThrottleLib.SendAddonMessage
local IsAddonMessagePrefixRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered
local RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
-- 延时函数
local After = C_Timer.After
-- 常量
local PlayerName = ""
local ItemQuality = {
    [1] = L[" Common+ Item(s)"],
    [2] = L[" Uncommon+ Item(s)"],
    [3] = L[" Rare+ Item(s)"],
    [4] = L[" Epic+ Item(s)"],
}

local RaidInstanceID = Addon.RaidInstanceID
local IsRaidBoss = Addon.IsRaidBoss

-- 控制变量
local Announce = {
    ["Rank"] = "NONE",
    ["Index"] = 0,
}
local ShowUpdateInfo = false
-- 数据库
-- 设置相关
Addon.Config = {
    ["Enabled"] = true, -- 插件开关
    ["OutputToRaidWarning"] = false,  -- 输出至Raid_Warning频道（向下兼容）
    ["Quality"] = 3, -- 默认通报物品等级：蓝色（3）
    ["EnteringCheck"] = true,
    ["BossOnly"] = false,
    ["ExpireDay"] = 14, -- 日志保存天数
	["ShowMinimapIcon"] = true,
	["MinimapIconAngle"] = 310,
    ["SetWindowPos"] = {"CENTER", nil, "CENTER", 210, 0},
    ["OutputPos"] = {"RIGHT", nil, "RIGHT", -20, 0},
}
local Config = Addon.Config
local LootLog = {}

-- 临时变量
local ItemIndex = 0
local CorpseInfo = {}
local GroupMemberStates = {}
local GroupFlagsStates = {}
local PlayerInInstance = {}

-- 通用功能函数
-- 更新Table（合并）
function Addon:UpdateTable(Target, Source)
    for k, v in pairs(Source) do
        if type(v) == "table" then
            if type(Target[k]) == "table" then
                self:UpdateTable(Target[k], v)
            else
                Target[k] = self:UpdateTable({}, v)
            end
        elseif type(Target[k]) ~= "table" then
            Target[k] = v
        end
    end
    return Target
end
-- 返回队伍Unit
function Addon:GetUnitPartyUnit(Name)
    if IsInGroup() and not IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local u = "party"..i
            if (UnitName(u)) == Name then
                return u
            end
        end
    end
    return nil
end
-- 返回某个GUID的名字
function Addon:GetMobNameFromGUID(TargetGUID)
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local u = "raid" .. i .. "target"
            if UnitExists(u) and UnitGUID(u) == TargetGUID then
                return (UnitName(u))
            end
        end
    elseif IsInGroup() then
        for i = 1, GetNumGroupMembers() do
            local u = "party" .. i .. "target"
            if UnitExists(u) and UnitGUID(u) == TargetGUID then
                return (UnitName(u))
            end
        end
    end
    return nil
end

-- 操作函数
-- 新建LootLog表
function Addon:NewRaid()
    local TempRaid = {
        ["Date"] = date("%Y-%m-%d"),
        ["Player"] = PlayerName,
        ["Class"] = (select(2, UnitClass("player"))),
        ["InstanceID"] = nil,
        ["InstanceName"] = nil,
        ["SavedID"] = nil,
        ["FirstPlayer"] = nil,
        ["FirstClass"] = nil,
        ["LootTable"] = {},
    }
    return TempRaid
end
-- 新建Loot表
function Addon:NewLoots()
    local TempMob = {
		["Date"] = date("%Y-%m-%d"),
        ["Time"] = date("%H:%M:%S"),
        ["Name"] = nil,
        ["GUID"] = nil,
        ["Looter"] = nil,
        ["Class"] = nil,
        ["Loots"] = {},
    }
    return TempMob
end
-- 升级
function Addon:DoUpdateCheck(VersionString)
    if tonumber(VersionString) > Version and not ShowUpdateInfo then
        print(L["<|cFFFF4500LM|r>Need Update your |cFFFF4500LootMonitor|r to newest one!"])
        print(L["|cFF4169E1Download Link|r https://www.curseforge.com/wow/addons/lootmonitor"])
        ShowUpdateInfo = true
    end
end
-- 检查
function Addon:DoCheck()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if IsInRaid() then
        ChatThrottleLib:SendAddonMessage(Priority[2], PrefixLM, "check " .. Addon.Version, "raid")
    elseif IsInGroup() then
        ChatThrottleLib:SendAddonMessage(Priority[2], PrefixLM, "check " .. Addon.Version, "party")
    end
    for i = 1, 40 do
        Addon.GroupState[i]:SetText("")
    end
end
-- 答复
function Addon:DoReply()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    local msg = Config.Enabled == true and Addon.Version or "0.01"
    if IsInRaid() then
        ChatThrottleLib:SendAddonMessage(Priority[2], PrefixLM, "reply " .. msg, "raid")
    elseif IsInGroup() then
        ChatThrottleLib:SendAddonMessage(Priority[2], PrefixLM, "reply " .. msg, "party")
    end
end
-- 初始化团队成员状态
function Addon:InitGroupFlags()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if IsInRaid() then
        for i = 1, 40 do
            local u = "raid"..i
            if (UnitName(u)) then
                if not GroupFlagsStates[u] then
                    GroupFlagsStates[u] = {
                        ["Name"] = (UnitName(u)),
                        -- ["Connected"] = UnitIsConnected(u),
                        -- ["DeadOrGhost"] = UnitIsDead(u) and "Dead" or (UnitIsGhost(u) and "Ghost" or "Alive"),
                        ["InCombat"] = UnitAffectingCombat(u),
                        ["IsAFK"] = UnitIsAFK(u),
                        ["FeignDeath"] = UnitIsFeignDeath(u) and 2 or 0,
                        -- ["Triggered"] = {},
                    }
                else
                    GroupFlagsStates[u].Name = (UnitName(u))
                    -- GroupFlagsStates[u].Connected = UnitIsConnected
                    -- GroupFlagsStates[u].DeadOrGhost = UnitIsDead(u) and "Dead" or (UnitIsGhost(u) and "Ghost" or "Alive")
                    GroupFlagsStates[u].InCombat = UnitAffectingCombat(u)
                    GroupFlagsStates[u].IsAFK = UnitIsAFK(u)
                    GroupFlagsStates[u].FeignDeath = UnitIsFeignDeath(u) and 2 or 0
                end
            else
                GroupFlagsStates[u] = nil
            end
        end
    elseif IsInGroup() then
        if not GroupFlagsStates["player"] then
            GroupFlagsStates["player"] = {
                ["Name"] = (UnitName("player")),
                -- ["Connected"] = true,
                -- ["DeadOrGhost"] = UnitIsDead("player") and "Dead" or (UnitIsGhost("player") and "Ghost" or "Alive"),
                ["InCombat"] = UnitAffectingCombat("player"),
                ["IsAFK"] = UnitIsAFK("player"),
                ["FeignDeath"] = UnitIsFeignDeath("player") and 2 or 0,
                -- ["Triggered"] = {},
            }
        else
            GroupFlagsStates["player"].Name = (UnitName("player"))
            -- GroupFlagsStates["player"].Connected = true
            -- GroupFlagsStates["player"].DeadOrGhost = UnitIsDead("player") and "Dead" or (UnitIsGhost("player") and "Ghost" or "Alive")
            GroupFlagsStates["player"].InCombat = UnitAffectingCombat("player")
            GroupFlagsStates["player"].IsAFK = UnitIsAFK("player")
            GroupFlagsStates["player"].FeignDeath = UnitIsFeignDeath("player") and 2 or 0
        end
        for i = 1, 4 do
            local u = "party"..i
            if (UnitName(u)) then
                if not GroupFlagsStates[u] then
                    GroupFlagsStates[u] = {
                        ["Name"] = (UnitName(u)),
                        -- ["Connected"] = UnitIsConnected(u),
                        -- ["DeadOrGhost"] = UnitIsDead(u) and "Dead" or (UnitIsGhost(u) and "Ghost" or "Alive"),
                        ["InCombat"] = UnitAffectingCombat(u),
                        ["IsAFK"] = UnitIsAFK(u),
                        ["FeignDeath"] = UnitIsFeignDeath(u) and 2 or 0,
                        -- ["Triggered"] = {},
                    }
                else
                    GroupFlagsStates[u].Name = (UnitName(u))
                    -- GroupFlagsStates[u].Connected = UnitIsConnected
                    -- GroupFlagsStates[u].DeadOrGhost = UnitIsDead(u) and "Dead" or (UnitIsGhost(u) and "Ghost" or "Alive")
                    GroupFlagsStates[u].InCombat = UnitAffectingCombat(u)
                    GroupFlagsStates[u].IsAFK = UnitIsAFK(u)
                    GroupFlagsStates[u].FeignDeath = UnitIsFeignDeath(u) and 2 or 0
                end
            end
        end
    else
        GroupFlagsStates = {}
    end
end
-- 初始化团队信息
function Addon:InitGroupInfo()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    GroupMemberStates = {}
    if IsInRaid() then -- 初始化Raid团队信息
        for i = 1, 40 do
            local u = "raid"..i
            local n = (UnitName(u))
            if n then
                local state = {
                    ["Index"] = u,
                    ["Name"] = n,
                    ["Rank"] = "NONE",
                    ["LootMonitor"] = "NONE",
                    ["Version"] = 0,
                }
                t_insert(GroupMemberStates, state)
            else
                break
            end
        end
    elseif IsInGroup() then -- 初始化队伍信息（Player放在最前）
        local PlayerRank = "NONE"
        if UnitIsGroupLeader("player") then
            PlayerRank = "LEADER"
            Announce.Rank = "LEADER"
        end
        local yourself = {
            ["Index"] = "player",
            ["Name"] = PlayerName,
            ["Rank"] = PlayerRank,
            ["LootMonitor"] = Config.Enabled == true and "ON" or "OFF",
            ["Version"] = Config.Enabled == true and Version or 0.01,
        }
        t_insert(GroupMemberStates, yourself)
        for i = 1, GetNumGroupMembers() do
            local u = "party"..i
            local n = (UnitName(u))
            if n then
                local state = {
                    ["Index"] = u,
                    ["Name"] = n,
                    ["Rank"] = "NONE",
                    ["LootMonitor"] = "NONE",
                    ["Version"] = 0,
                }
                t_insert(GroupMemberStates, state)
            else
                break
            end
        end
    end
end
-- 更新团队成员信息
function Addon:UpdateGroupInfo(Sender, REST)
    if IsInRaid() then
        local Index = UnitInRaid(Sender)
        if Index then
            if REST == "0.01" then
                GroupMemberStates[Index].LootMonitor = "OFF"
                GroupMemberStates[Index].Version = 0.01
            else
                GroupMemberStates[Index].LootMonitor = "ON"
                GroupMemberStates[Index].Version = tonumber(REST)
            end
            local SenderRank = "NONE"
            if UnitIsGroupLeader(Sender) and GroupMemberStates[Index].LootMonitor == "ON" then -- 信息发送者是团长
                SenderRank = "LEADER"
                Announce.Rank = "LEADER"
                Announce.Index = Index
            elseif UnitIsGroupAssistant(Sender) and GroupMemberStates[Index].LootMonitor == "ON" then -- 信息发送者是助理
                SenderRank = "ASSISTANT"
                if Announce.Rank == "NONE" then
                    Announce.Rank = "ASSISTANT"
                    Announce.Index = Index
                elseif Announce.Rank == "ASSISTANT" then
                    if Index < Announce.Index then
                        Announce.Index = Index
                    end
                end
            elseif GroupMemberStates[Index].LootMonitor == "ON" then -- 普通团员
                if Announce.Rank == "NONE" then
                    if Announce.Index == 0 then
                        Announce.Index = Index
                    elseif Index < Announce.Index then
                        Announce.Index = Index
                    end
                end
            end
            GroupMemberStates[Index].Rank = SenderRank
        end
    elseif IsInGroup() then
        local SenderRank = "NONE"
        if GroupMemberStates[1].LootMonitor == "ON" then
            Announce.Index = 1
        end
        if UnitIsGroupLeader(Sender) then
            SenderRank = "LEADER"
        end
        for i = 1, #GroupMemberStates do
            if GroupMemberStates[i].Name == Sender then
                if REST == "0.01" then
                    GroupMemberStates[i].LootMonitor = "OFF"
                    GroupMemberStates[i].Version = 0.01
                else
                    GroupMemberStates[i].LootMonitor = "ON"
                    GroupMemberStates[i].Version = tonumber(REST)
                end
                GroupMemberStates[i].Rank = SenderRank
                if GroupMemberStates[i].Rank == "LEADER" and GroupMemberStates[i].LootMonitor == "ON" then
                    Announce.Rank = "LEADER"
                    Announce.Index = i
                elseif Announce.Rank == "NONE" and GroupMemberStates[i].LootMonitor == "ON" and GroupMemberStates[i].Name ~= (UnitName("player")) then
                    if GroupMemberStates[i].Name < GroupMemberStates[Announce.Index].Name then
                        Announce.Index = i
                    end
                end
                break
            end
        end
    end
end
-- 显示版本及发言人状态
function Addon:DoShowState()
    if next(GroupMemberStates) == nil then
        return
    end
    local AnnouncerColorPrefix = "|cFFDC143C"
    local NoAddonColorPrefix = "|cFF606060"
    local MutedColorPrefix = "|cFF00BFFF"
    local ColorSuffix = "|r"
    for i = 1, #GroupMemberStates do
        if GroupMemberStates[i] then
            local msg = GroupMemberStates[i].Name
            if i == Announce.Index and GroupMemberStates[i].LootMonitor == "ON" then
                msg = AnnouncerColorPrefix .. msg .. ColorSuffix .. " (v" .. tostring(GroupMemberStates[i].Version) .. ")"
            elseif GroupMemberStates[i].LootMonitor == "OFF" then
                msg = MutedColorPrefix .. msg .. " (" .. L["Muted"] .. ")" .. ColorSuffix
            elseif GroupMemberStates[i].LootMonitor == "NONE" then
                msg = NoAddonColorPrefix .. msg .. " (" .. L["NoAddon"] .. ")" .. ColorSuffix
            else
                msg = msg.." (v"..tostring(GroupMemberStates[i].Version)..")"
            end
            Addon.GroupState[i]:SetText(msg)
        end
    end
end
-- 输出LootLog
function Addon:PrintLootLog()
	Output.title:SetText(L["Loot Logs"])
	Output.background:Show()
	Output.export:GetParent():Show()
	-- 清理不合法LootLog
	for i = #LootLog, 1, -1 do
		if not LootLog[i].Date or not LootLog[i].InstanceName or not LootLog[i].Player then
			t_remove(LootLog, i)
        end
        if #LootLog[i].LootTable == 0 then
            t_remove(LootLog, i)
        end
        for j = #LootLog[i].LootTable, 1, -1 do
            if #LootLog[i].LootTable[j].Loots == 0 then
                t_remove(LootLog[i].LootTable, j)
            end
        end
    end
	if #LootLog == 0 then
		Output.export:SetText(L["<|cFFBA55D3LootMonitor|r>No Loot Log!"].."\n")
		return
    end
    local ClassColor = {
        ["WARRIOR"] = "|cFFC69B6D",
        ["PALADIN"] = "|cFFF48CBA",
        ["HUNTER"] = "|cFFAAD372",
        ["ROGUE"] = "|cFFFFF468",
        ["PRIEST"] = "|cFFF0EBE0",
        ["DRUID"] = "|cFFFF7C0A",
        ["SHAMAN"] = "|cFF2359FF",
        ["MAGE"] = "|cFF68CCEF",
        ["WARLOCK"] = "|cFF9382C9",
        ["UNKNOWN"] = "|cFF606060",
    }
    local msg = ""
    for i = 1, #LootLog do
        msg = msg .. string.format(L["[|cFFFFFF00%s|r]  |cFFFF69B4Raid Instance:|r <|cFFDC143C%s|r>\n    |cFF00BFFFAlt in Raid:|r [%s|r]\n    |cFFFFA07AInstance ID:|r |cFFFFD700%s|r\n    |cFFDA70D6First Entered Player:|r [%s|r]\n"], LootLog[i].Date, LootLog[i].InstanceName, (LootLog[i].Class and ClassColor[LootLog[i].Class] or ClassColor["UNKNOWN"]) .. LootLog[i].Player, LootLog[i].SavedID or L["UNKNOWN"], (LootLog[i].FirstClass and ClassColor[LootLog[i].FirstClass] or ClassColor["UNKNOWN"]) .. LootLog[i].FirstPlayer)
        if #LootLog[i].LootTable > 0 then
            for j = 1, #LootLog[i].LootTable do
                if IsRaidBoss[(select(6, strsplit("-", LootLog[i].LootTable[j].GUID)))] then
                    msg = msg .. string.format("        [%s|r] -> [|cFFFFD700%s|r]\n", (LootLog[i].LootTable[j].Class and ClassColor[LootLog[i].LootTable[j].Class] or ClassColor["UNKNOWN"]) .. LootLog[i].LootTable[j].Looter, LootLog[i].LootTable[j].Name)
                else
                    msg = msg .. string.format("        [%s|r] -> [|cFF778899%s|r]\n", (LootLog[i].LootTable[j].Class and ClassColor[LootLog[i].LootTable[j].Class] or ClassColor["UNKNOWN"]) .. LootLog[i].LootTable[j].Looter, LootLog[i].LootTable[j].Name)
                end
                for k = 1, #LootLog[i].LootTable[j].Loots do
                    msg = msg .. "          [|cFF808080" .. k .. "|r] " .. LootLog[i].LootTable[j].Loots[k] .. "\n"
                end
            end
        end
        msg = msg .. "\n"
    end

    msg = string.sub(msg, 1, #msg - 2)
    Output.export:SetText(msg)
    Output.export:Disable()
end
-- 清空LootLog
function Addon:CleanLootLogs()
    if #LootLog > 0 then
        for i = #LootLog, 1, -1 do
            t_remove(LootLog, i)
        end
    end
    self:PrintLootLog()
end

-- 注册事件
Frame:RegisterEvent("ADDON_LOADED")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:RegisterEvent("PLAYER_LOGOUT")
Frame:RegisterEvent("LOOT_OPENED")
Frame:RegisterEvent("CHAT_MSG_ADDON")
-- Frame:RegisterEvent("ZONE_CHANGED")
Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
Frame:RegisterEvent("UNIT_FLAGS")
-- Frame:RegisterEvent("UNIT_TARGET")
Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

-- New本检查
do
    local LastScan = 0

    local function OnUpdate(self, lastupdate)
        if not Config.EnteringCheck or not IsInRaid() then
            Frame:Hide()
            return
        end
        local NowScan = math.floor(GetTime())
        if NowScan == LastScan then
            return
        end
        LastScan = NowScan
        for i = 1, GetNumGroupMembers() do
            local InstanceID = select(4, UnitPosition("raid"..i))
            if RaidInstanceID[InstanceID] then
                if not PlayerInInstance[InstanceID] then
                    PlayerInInstance[InstanceID] = {
                        ["FirstPlayer"] = nil,
                        ["Announced"] = false,
                        ["PlayerList"] = {},
                    }
                    local Name = (UnitName("raid"..i))
                    t_insert(PlayerInInstance[InstanceID].PlayerList, Name)
                else
                    local Name = (UnitName("raid"..i))
                    local IsExist = false
                    for j = 1, #PlayerInInstance[InstanceID].PlayerList do
                        if Name == PlayerInInstance[InstanceID].PlayerList[j] then
                            IsExist = true
                        end
                    end
                    if not IsExist then
                        t_insert(PlayerInInstance[InstanceID].PlayerList, Name)
                    end
                end
            end
        end
        if (next(PlayerInInstance)) then
            for k in pairs(PlayerInInstance) do
                if k ~= 249 then
                    if not PlayerInInstance[k].Announced then
                        if #PlayerInInstance[k].PlayerList == 1 then
                            PlayerInInstance[k].FirstPlayer = PlayerInInstance[k].PlayerList[1]
                            ChatThrottleLib:SendAddonMessage(Priority[2], PrefixLM, "enter " .. tostring(k) .. " " .. PlayerInInstance[k].FirstPlayer, "raid")
                        elseif #PlayerInInstance[k].PlayerList > 1 and not PlayerInInstance[k].FirstPlayer then
                            PlayerInInstance[k].FirstPlayer = L["UNKNOWN"]
                            PlayerInInstance[k].Announced = true
                        end
                    end
                end
            end
        end
    end

    Frame:SetScript("OnUpdate", OnUpdate)
end

-- 事件分配
Frame:SetScript("OnEvent", function(self, event, ...)
    if type(self[event]) == "function" then
        return self[event](self, ...)
    end
end)

-- 事件处理
-- 加载处理
function Frame:ADDON_LOADED(Name)
    if Name ~= AddonName then
        return
    end
    -- 反注册ADDON_LOADED事件
    self:UnregisterEvent("ADDON_LOADED")
    -- 读取存档资料，如果没有LootMonitorDB.Config则新建
    if not LootMonitorDB then
        LootMonitorDB = {
            ["Config"] = {},
            ["LootLog"] = {},
        }
    end
    if not LootMonitorDB.Config then
        LootMonitorDB.Config = {}
    end
    if not LootMonitorDB.LootLog then
        LootMonitorDB.LootLog = {}
    end
    -- 用存档文件数据更新Config表
    Addon:UpdateTable(Config, LootMonitorDB.Config)
    Addon:UpdateTable(LootLog, LootMonitorDB.LootLog)
    -- 注册Prefix
    if not IsAddonMessagePrefixRegistered(PrefixLM) then
        RegisterAddonMessagePrefix(PrefixLM)
    end
    -- 反和谐相关
    if GetCVar("portal") == "CN" then
        ConsoleExec("portal KR")
        ConsoleExec("profanityFilter 0")
        ConsoleExec("overrideArchive 0")
    end
    -- 初始化常量
    PlayerName = UnitName("player")
    -- 初始化设定窗口
    SetWindow:Initialize()
   	-- 初始化Output窗口
	Output:Initialize()
    -- 初始化团队成员版本信息表
    Addon:InitGroupInfo()
    -- 初始化团队成员状态表
    Addon:InitGroupFlags()
    -- 进入检测
    if Config.EnteringCheck then
        Frame:Show()
    else
        Frame:Hide()
    end
	-- 清理过期TradeLog
	local Today = {}
	Today.year, Today.month, Today.day = strsplit("-", date("%Y-%m-%d"))
	local LogDay = {}
	if #LootLog > 0 then
		for i = #LootLog, 1, -1 do
			if LootLog[i].Date then
				LogDay.year, LogDay.month, LogDay.day = strsplit("-", LootLog[i].Date)
			else
				t_remove(LootLog, i)
			end
			if (time(Today) - time(LogDay)) / (3600 * 24) > Config.ExpireDay then
				t_remove(LootLog, i)
			end
		end
	end
end
-- 进入世界
function Frame:PLAYER_ENTERING_WORLD()
	if Addon.LDB and Addon.LDBIcon and ((IsAddOnLoaded("TitanClassic")) or (IsAddOnLoaded("Titan"))) then
		MinimapIcon:InitBroker()
	else
        -- 初始化小地图按钮
        MinimapIcon:Initialize()
        -- 小地图按钮
        if Config.ShowMinimapIcon then
            Addon:UpdatePosition(Config.MinimapIconAngle)
            MinimapIcon.Minimap:Show()
        else
            MinimapIcon.Minimap:Hide()
        end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
-- 退出处理（包括/reload）
function Frame:PLAYER_LOGOUT()
   	-- 清理不合法LootLog
    if #LootLog > 0 then
        for i = #LootLog, 1, -1 do
            if not LootLog[i].Date or not LootLog[i].InstanceName or not LootLog[i].Player then
                t_remove(LootLog, i)
            end
            if #LootLog[i].LootTable == 0 then
                t_remove(LootLog, i)
            end
            for j = #LootLog[i].LootTable, 1, -1 do
                if #LootLog[i].LootTable[j].Loots == 0 then
                    t_remove(LootLog[i].LootTable, j)
                end
            end
        end
    end
   	-- 存儲窗口位置
    Config.SetWindowPos[1], _, Config.SetWindowPos[3], Config.SetWindowPos[4], Config.SetWindowPos[5] = SetWindow.background:GetPoint()
    Config.OutputPos[1], _, Config.OutputPos[3], Config.OutputPos[4], Config.OutputPos[5] = Output.background:GetPoint()
    LootMonitorDB = {
        ["Config"] = {},
        ["LootLog"] = {},
    }
    -- 用当前Config覆盖LootMonitorDB
    Addon:UpdateTable(LootMonitorDB.Config, Config)
    Addon:UpdateTable(LootMonitorDB.LootLog, LootLog)
    -- 释放变量
    CorpseInfo = nil
    GroupMemberStates = nil
    GroupFlagsStates = nil
    PlayerInInstance = nil
end
-- ADDON频道信息处理
function Frame:CHAT_MSG_ADDON(...)
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if not IsInGroup() then -- 非组队情况下退出
        return
    end
    -- 获取事件信息
    local arg = {...}
    -- 团队和小队处理模式一致
    if arg[1] == PrefixLM then
        -- 切分信息，以空格为界
        local CMD, REST = arg[2]:match("(%S+)%s+(.-)$")
        -- 确定输出频道
        local OutputChannel = "party"
        if IsInRaid() then
            OutputChannel = "raid"
            if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
                if Config.OutputToRaidWarning then
                    OutputChannel = "raid_warning"
                end
            end
        end
        if CMD:lower() == "check" then -- 收到检查命令，返回reply信息
            -- 进行答复
            Addon:DoReply()
            -- 比较版本号，提示更新
            if REST then
                Addon:DoUpdateCheck(REST)
            end
        elseif CMD:lower() == "reply" or CMD:lower() == "start" then
            if arg[5] and REST then
                Addon:UpdateGroupInfo(arg[5], REST) -- 更新团队插件信息
                -- 比较版本号，提示更新
                if REST ~= "0.01" then
                    Addon:DoUpdateCheck(REST)
                end
            end
        elseif CMD:lower() == "target" then
            local TargetName, TargetGUID = REST:match("(%S+)%s(.-)$")
            if TargetGUID and Announce.Index ~= 0 then
                if not CorpseInfo[TargetGUID] then
                    CorpseInfo[TargetGUID] = {
                        ["TargetName"] = TargetName,
                        ["LooterName"] = nil,
                        ["Sender"] = arg[5],
                        ["LootAnnounced"] = false,
                        ["Time"] = GetTime(),
                    }
                elseif not CorpseInfo[TargetGUID].Sender then
                    CorpseInfo[TargetGUID].Sender = arg[5]
                else
                    return
                end

                -- 兼容旧版本
                local SenderVersion = nil
                for i = 1, #GroupMemberStates do
                    if GroupMemberStates[i].Name == arg[5] then
                        SenderVersion = GroupMemberStates[i].Version
                        break
                    end
                end
                if SenderVersion and SenderVersion < 3.06 then
                    if not CorpseInfo[TargetGUID].LooterName then
                        CorpseInfo[TargetGUID].LooterName = arg[5]
                    end
                    if not CorpseInfo[TargetGUID].LootAnnounced then
                        CorpseInfo[TargetGUID].LootAnnounced = true
                        ItemIndex = 1
                        if Config.BossOnly and IsRaidBoss[(select(6, strsplit("-", TargetGUID)))] or not Config.BossOnly then
                            if GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName and (IsInInstance()) then
                                SendChatMessage(string.format(L["<LM><%s> has Looted <%s>'s Corpse"], CorpseInfo[TargetGUID].LooterName, CorpseInfo[TargetGUID].TargetName), OutputChannel)
                            elseif GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName then
                                SendChatMessage(string.format(L["<LM><%s>'s Corpse Opened"], CorpseInfo[TargetGUID].TargetName), OutputChannel)
                            end
                        end
                        -- 记录信息
                        local InstanceID = select(4, UnitPosition("player"))
                        if RaidInstanceID[InstanceID] then
                            if #LootLog >= 1 then
                                if LootLog[#LootLog].InstanceID == InstanceID and LootLog[#LootLog].Player == PlayerName then
                                    local Loots = Addon:NewLoots()
                                    Loots.Name = CorpseInfo[TargetGUID].TargetName
                                    Loots.GUID = TargetGUID
                                    Loots.Looter = CorpseInfo[TargetGUID].LooterName
                                    Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                                    t_insert(LootLog[#LootLog].LootTable, Loots)
                                    if not LootLog[#LootLog].SavedID then
                                        local SavedRaidID = nil
                                        for i = 1, GetNumSavedInstances() do
                                            if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                                SavedRaidID = (select(2, GetSavedInstanceInfo(i)))
                                                break
                                            end
                                        end
                                        LootLog[#LootLog].SavedID = SavedRaidID
                                    end
                                else
                                    local SavedRaidID = nil
                                    for i = 1, GetNumSavedInstances() do
                                        if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                            SavedRaidID = (select(2, GetSavedInstanceInfo(i)))
                                            break
                                        end
                                    end
                                    local NewRaid = Addon:NewRaid()
                                    NewRaid.InstanceID = InstanceID
                                    NewRaid.InstanceName = RaidInstanceID[InstanceID]
                                    NewRaid.SavedID = SavedRaidID
                                    NewRaid.FirstPlayer = RaidInstanceID[InstanceID] and PlayerInInstance[InstanceID].FirstPlayer or L["UNKNOWN"]
                                    NewRaid.FirstClass = (select(2, UnitClass(NewRaid.FirstPlayer))) or "UNKNOWN"
                                    t_insert(LootLog, NewRaid)
                                    local Loots = Addon:NewLoots()
                                    Loots.Name = CorpseInfo[TargetGUID].TargetName
                                    Loots.GUID = TargetGUID
                                    Loots.Looter = CorpseInfo[TargetGUID].LooterName
                                    Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                                    t_insert(LootLog[#LootLog].LootTable, Loots)
                                end
                            elseif RaidInstanceID[InstanceID] then
                                local SavedRaidID = nil
                                for i = 1, GetNumSavedInstances() do
                                    if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                        SavedRaidID = (select(2,GetSavedInstanceInfo(i)))
                                        break
                                    end
                                end
                                local NewRaid = Addon:NewRaid()
                                NewRaid.InstanceID = InstanceID
                                NewRaid.InstanceName = RaidInstanceID[InstanceID]
                                NewRaid.SavedID = SavedRaidID
                                NewRaid.FirstPlayer = RaidInstanceID[InstanceID] and PlayerInInstance[InstanceID].FirstPlayer or L["UNKNOWN"]
                                NewRaid.FirstClass = (select(2, UnitClass(NewRaid.FirstPlayer))) or "UNKNOWN"
                                t_insert(LootLog, NewRaid)
                                local Loots = Addon:NewLoots()
                                Loots.Name = CorpseInfo[TargetGUID].TargetName
                                Loots.GUID = TargetGUID
                                Loots.Looter = CorpseInfo[TargetGUID].LooterName
                                Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                                t_insert(LootLog[#LootLog].LootTable, Loots)
                            end
                        end
                    end
                end
            end
        elseif CMD:lower() == "looter" then
            local TargetGUID, Looter = REST:match("(%S+)%s(.-)$")
            if arg[5] == CorpseInfo[TargetGUID].Sender and Announce.Index ~= 0 then
                CorpseInfo[TargetGUID].LooterName = Looter
                if not CorpseInfo[TargetGUID].LootAnnounced then
                    CorpseInfo[TargetGUID].LootAnnounced = true
                    ItemIndex = 1
                    if Config.BossOnly and IsRaidBoss[(select(6, strsplit("-", TargetGUID)))] or not Config.BossOnly then
                        if GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName and (IsInInstance()) then
                            SendChatMessage(string.format(L["<LM><%s> has Looted <%s>'s Corpse"], CorpseInfo[TargetGUID].LooterName, CorpseInfo[TargetGUID].TargetName), OutputChannel)
                        elseif GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName then
                            SendChatMessage(string.format(L["<LM><%s>'s Corpse Opened"], CorpseInfo[TargetGUID].TargetName), OutputChannel)
                        end
                    end
                    -- 记录Loot信息
                    local InstanceID = select(4, UnitPosition("player"))
                    if RaidInstanceID[InstanceID] then
                        if #LootLog >= 1 then
                            if LootLog[#LootLog].InstanceID == InstanceID and LootLog[#LootLog].Player == PlayerName then
                                local Loots = Addon:NewLoots()
                                Loots.Name = CorpseInfo[TargetGUID].TargetName
                                Loots.GUID = TargetGUID
                                Loots.Looter = CorpseInfo[TargetGUID].LooterName
                                Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                                t_insert(LootLog[#LootLog].LootTable, Loots)
                                if not LootLog[#LootLog].SavedID then
                                    local SavedRaidID = nil
                                    for i = 1, GetNumSavedInstances() do
                                        if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                            SavedRaidID = (select(2, GetSavedInstanceInfo(i)))
                                            break
                                        end
                                    end
                                    LootLog[#LootLog].SavedID = SavedRaidID
                                end
                            else
                                local SavedRaidID = nil
                                for i = 1, GetNumSavedInstances() do
                                    if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                        SavedRaidID = (select(2, GetSavedInstanceInfo(i)))
                                        break
                                    end
                                end
                                local TempRaid = Addon:NewRaid()
                                TempRaid.InstanceID = InstanceID
                                TempRaid.InstanceName = RaidInstanceID[InstanceID]
                                TempRaid.SavedID = SavedRaidID
                                TempRaid.FirstPlayer = RaidInstanceID[InstanceID] and PlayerInInstance[InstanceID].FirstPlayer or L["UNKNOWN"]
                                TempRaid.FirstClass = (select(2, UnitClass(TempRaid.FirstPlayer))) or "UNKNOWN"
                                t_insert(LootLog, TempRaid)
                                local Loots = Addon:NewLoots()
                                Loots.Name = CorpseInfo[TargetGUID].TargetName
                                Loots.GUID = TargetGUID
                                Loots.Looter = CorpseInfo[TargetGUID].LooterName
                                Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                                t_insert(LootLog[#LootLog].LootTable, Loots)
                            end
                        elseif RaidInstanceID[InstanceID] then
                            local SavedRaidID = nil
                            for i = 1, GetNumSavedInstances() do
                                if (GetSavedInstanceInfo(i)) == RaidInstanceID[select(4, UnitPosition("player"))] then
                                    SavedRaidID = (select(2,GetSavedInstanceInfo(i)))
                                    break
                                end
                            end
                            local TempRaid = Addon:NewRaid()
                            TempRaid.InstanceID = InstanceID
                            TempRaid.InstanceName = RaidInstanceID[InstanceID]
                            TempRaid.SavedID = SavedRaidID
                            TempRaid.FirstPlayer = RaidInstanceID[InstanceID] and PlayerInInstance[InstanceID].FirstPlayer or L["UNKNOWN"]
                            TempRaid.FirstClass = (select(2, UnitClass(TempRaid.FirstPlayer))) or "UNKNOWN"
                            t_insert(LootLog, TempRaid)
                            local Loots = Addon:NewLoots()
                            Loots.Name = CorpseInfo[TargetGUID].TargetName
                            Loots.GUID = TargetGUID
                            Loots.Looter = CorpseInfo[TargetGUID].LooterName
                            Loots.Class = (select(2, UnitClass(Loots.Looter))) or "UNKNOWN"
                            t_insert(LootLog[#LootLog].LootTable, Loots)
                        end
                    end
                end
            end
        elseif CMD:lower() == "loot" and ItemIndex ~= 0 then
            local TargetGUID, LootLink = REST:match("(%S+)%s+(.-)$")
            if arg[5] == CorpseInfo[TargetGUID].Sender and Announce.Index ~= 0 then
                if Config.BossOnly and IsRaidBoss[(select(6, strsplit("-", TargetGUID)))] or not Config.BossOnly then
                    if GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName then
                        SendChatMessage(string.format("%d: %s", ItemIndex, LootLink), OutputChannel)
                    end
                end
                local InstanceID = select(4, UnitPosition("player"))
                if #LootLog > 0 and LootLog[#LootLog].InstanceID == InstanceID and LootLog[#LootLog].Player == PlayerName then
                    LootLog[#LootLog].LootTable[#LootLog[#LootLog].LootTable].Loots[ItemIndex] = LootLink
                end
                ItemIndex = ItemIndex + 1
            end
        elseif CMD:lower() == "end" and ItemIndex ~= 0 then
            local TargetGUID, LootsNum = REST:match("(%S+)%s+(.-)$")
            if arg[5] == CorpseInfo[TargetGUID].Sender and Announce.Index ~= 0 then
                if Config.BossOnly and IsRaidBoss[(select(6, strsplit("-", TargetGUID)))] or not Config.BossOnly then
                    if GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName then
                        SendChatMessage(L["<LM>Total "]..LootsNum, OutputChannel)
                    end
                end
                ItemIndex = 0
            end
        elseif CMD:lower() == "enter" then
            local ID, Name = REST:match("(%S+)%s+(.-)$")
            ID = tonumber(ID)
            if not PlayerInInstance[ID] then
                PlayerInInstance[ID] = {
                    ["FirstPlayer"] = Name,
                    ["Announced"] = true,
                    ["PlayerList"] = {
                        [1] = Name,
                    },
                }
            elseif not PlayerInInstance[ID].Announced then
                PlayerInInstance[ID].FirstPlayer = Name
                PlayerInInstance[ID].Announced = true
                PlayerInInstance[ID].PlayerList = {
                    [1] = Name,
                }
            elseif PlayerInInstance[ID].Announced then
                return
            end
            if GroupMemberStates[Announce.Index] and GroupMemberStates[Announce.Index].Name == PlayerName then
                local msg = string.format(L["<LM>The first player who entered <%s> Raid Instance is <%s>."], RaidInstanceID[ID], PlayerInInstance[ID].FirstPlayer)
                SendChatMessage(msg, "raid")
            end
        end
    end
end
-- 队伍调整后重新初始化团队信息，并发送状态
function Frame:GROUP_ROSTER_UPDATE()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    -- 初始化Announce表
    Announce.Rank = "NONE"
    Announce.Index = 0
    -- 初始化GroupMemberStates表
    Addon:InitGroupInfo()
    -- 初始化团队成员状态表
    Addon:InitGroupFlags()
    -- 同步版本信息
    if IsInRaid() then
        Addon:DoReply()
        if not Frame:IsShown() then
            Frame:Show()
        end
    elseif IsInGroup() then
        Addon:DoReply()
        Frame:Hide()
    else
        Frame:Hide()
        for k in pairs(CorpseInfo) do
            CorpseInfo[k] = nil
        end
        for k in pairs(PlayerInInstance) do
            PlayerInInstance[k] = nil
        end
    end
end
-- 处理Flags事件
function Frame:UNIT_FLAGS(Unit)
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if not IsInGroup() then -- 非组队状态禁用
        return
    end
    if not UnitIsConnected(Unit) then -- 第一层过滤网，不是掉线
        return
    end
    if not UnitIsPlayer(Unit) then -- 第二层过滤网，过滤非玩家Unit（Mob、Pet out）
        return
    end
    if not UnitIsFriend("player", Unit) then -- 第三层过滤网，按关系过滤（非友方Unit，out）
        return
    end
    if UnitIsDeadOrGhost(Unit) and not UnitIsFeignDeath(Unit) then -- 第四层过滤网，按状态过滤（死亡含假死 out)
        return
    end
    if IsInRaid() and string.find(Unit, "raid") or IsInGroup() and not IsInRaid() and (string.find(Unit, "party") or Unit == "player") then -- 假死处理
        if (select(2, UnitClass(Unit))) == "HUNTER" then
            GroupFlagsStates[Unit].FeignDeath = UnitIsFeignDeath(Unit) and 2 or (GroupFlagsStates[Unit].FeignDeath > 1 and 1 or 0)
        end
    end
    if not UnitExists(Unit.."target") or UnitIsPlayer(Unit.."target") or not UnitIsDead(Unit.."target") then -- 第四层过滤网，按目标状态（无目标、是玩家、没死 out）
        return
    end
    if IsInRaid() and string.find(Unit, "raid") then
        if GroupFlagsStates[Unit].InCombat ~= UnitAffectingCombat(Unit) then
            GroupFlagsStates[Unit].InCombat = UnitAffectingCombat(Unit)
        elseif GroupFlagsStates[Unit].IsAFK ~= UnitIsAFK(Unit) then
            GroupFlagsStates[Unit].IsAFK = UnitIsAFK(Unit)
        elseif GroupFlagsStates[Unit].FeignDeath == 0 then
            local TargetGUID = UnitGUID(Unit.."target")
            local NowTime = GetTime()
            if not CorpseInfo[TargetGUID] then
                CorpseInfo[TargetGUID] = {
                    ["TargetName"] = (UnitName(Unit.."target")),
                    ["LooterName"] = (UnitName(Unit)),
                    ["Sender"] = nil,
                    ["LootAnnounced"] = false,
                    ["Time"] = NowTime,
                }
            elseif NowTime - CorpseInfo[TargetGUID].Time > 0.1 and not CorpseInfo[TargetGUID].LooterName then
                CorpseInfo[TargetGUID].LooterName = (UnitName(Unit))
            end
        end
    elseif IsInGroup() and not IsInRaid() and (string.find(Unit, "party") or Unit == "player") then
        if GroupFlagsStates[Unit].InCombat ~= UnitAffectingCombat(Unit) then
            GroupFlagsStates[Unit].InCombat = UnitAffectingCombat(Unit)
        elseif GroupFlagsStates[Unit].IsAFK ~= UnitIsAFK(Unit) then
            GroupFlagsStates[Unit].IsAFK = UnitIsAFK(Unit)
        elseif GroupFlagsStates[Unit].FeignDeath == 0 then
            local TargetGUID = UnitGUID(Unit.."target")
            local NowTime = GetTime()
            if not CorpseInfo[TargetGUID] then
                CorpseInfo[TargetGUID] = {
                    ["TargetName"] = (UnitName(Unit.."target")),
                    ["LooterName"] = (UnitName(Unit)),
                    ["Sender"] = nil,
                    ["LootAnnounced"] = false,
                    ["Time"] = NowTime,
                }
            elseif NowTime - CorpseInfo[TargetGUID].Time > 0.1 and not CorpseInfo[TargetGUID].LooterName then
                CorpseInfo[TargetGUID].LooterName = (UnitName(Unit))
            end
        end
    end
end

-- 发送Loot信息
function Frame:LOOT_OPENED(...)
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if not IsInGroup() then -- 非组队状态禁用
        return
    end
    if IsFishingLoot() then
        return
    end

    local Loots = GetLootInfo() -- 获取Loot信息
    local LootLink = {} -- 初始化需要发送的Loot信息表
    local TargetGUID = nil
    -- 根据设定的物品等级，填充物品信息表
    if #Loots > 0 then
        for i = 1, #Loots do
            if not TargetGUID then
                TargetGUID = (GetLootSourceInfo(i))
            end
            if Loots[i].quantity ~= 0 then
                if Loots[i].quality >= Config.Quality then
                    t_insert(LootLink, GetLootSlotLink(i))
                end
            end
        end
    else
        return
    end
    -- 无尸体信息
    if TargetGUID then
        local TargetName = (UnitExists("target") and UnitGUID("target") == TargetGUID) and (UnitName("target")) or Addon:GetMobNameFromGUID(TargetGUID)
        if not CorpseInfo[TargetGUID] then
            CorpseInfo[TargetGUID] = {
                ["TargetName"] = TargetName,
                ["LooterName"] = nil,
                ["Sender"] = nil,
                ["LootAnnounced"] = false,
                ["Time"] = GetTime(),
            }
        end
        -- 填充Looter信息
        if not CorpseInfo[TargetGUID].LooterName then
            CorpseInfo[TargetGUID].LooterName = PlayerName
        end

        -- 设置发送频道
        local channel = "party"
        if IsInRaid() then
            channel = "raid"
        end
        -- 发送物品信息
        if not CorpseInfo[TargetGUID].LootAnnounced and TargetName then
            if #LootLink > 0 then
                ChatThrottleLib:SendAddonMessage(Priority[1], PrefixLM, "target " .. CorpseInfo[TargetGUID].TargetName .. " " .. TargetGUID, channel)
                After(0.14, function() ChatThrottleLib:SendAddonMessage(Priority[1], PrefixLM, "looter " .. TargetGUID .. " " .. CorpseInfo[TargetGUID].LooterName, channel) end)
                for i = 1, #LootLink do
                    After((i + 1) * 0.14, function() ChatThrottleLib:SendAddonMessage(Priority[1], PrefixLM, "loot " .. TargetGUID .. " " .. LootLink[i], channel) end)
                end
                After((#LootLink + 2) * 0.14, function() ChatThrottleLib:SendAddonMessage(Priority[1], PrefixLM, "end " .. TargetGUID .. " " .. tostring(#LootLink)..ItemQuality[Config.Quality], channel) end)
            end
        end
    end
end

-- 死亡记录
function Frame:COMBAT_LOG_EVENT_UNFILTERED()
    if UnitInBattleground("player") then -- 战场禁用
        return
    end
    if not IsInGroup() then -- 非组队状态禁用
        return
    end

    local arg = {CombatLogGetCurrentEventInfo()} --COMBAT_LOG_EVENT_UNFILTERED 事件参数Payload

    if arg[2] == "UNIT_DIED" then
        local Type = (strsplit("-", arg[8] or ""))
        if Type == "Creature" then
            if not CorpseInfo[arg[8]] then
                CorpseInfo[arg[8]] = {
                    ["TargetName"] = arg[9],
                    ["LooterName"] = nil,
                    ["Sender"] = nil,
                    ["LootAnnounced"] = false,
                    ["Time"] = GetTime(),
                }
            else
                CorpseInfo[arg[8]].TargetName = arg[9]
                CorpseInfo[arg[8]].Time = GetTime()
            end
        end
    end
end




-- 注册slash命令
SLASH_LMC1 = "/lootmonitor"
SLASH_LMC2 = "/lm"
-- 处理slash命令
SlashCmdList["LMC"] = function(Command)
    if Command == "" then
        if Addon.SetWindow.background:IsShown() then
            Addon.SetWindow.background:Hide()
        else
            Addon.SetWindow.background:Show()
        end
    elseif Command:lower() == "lootlog" or Command:lower() == "ll" then
        Addon:PrintLootLog()
    else 
        print(L["|cFFBA55D3LootMonitor|r Tips: Use |cFF00BFFF/lootmonitor|r or |cFF00BFFF/lm|r open GUI, Use |cFF00BFFF/lootmonitor|r |cFFFF9000lootlog|r or |cFF00BFFF/lm|r |cFFFF9000ll|r open Loots Logs."])
    end
end