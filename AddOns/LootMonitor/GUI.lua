--[[
    LootMonitor 2.01
]]

local _, Addon = ...

local Config = Addon.Config
local L = Addon.L

local SetWindow = Addon.SetWindow
local GroupState = Addon.GroupState


-- Local API提升效率
local IsInGroup = IsInGroup
local t_insert = table.insert

-- 初始化SetWindow
function SetWindow:Initialize()
    -- 创建SetWindow框体
    local f = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    f:SetWidth(360)
    f:SetHeight(510)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 8, right = 8, top = 10, bottom = 10}
    })
    f:SetBackdropColor(0, 0, 0)
    f:SetPoint(Config.SetWindowPos[1], nil, Config.SetWindowPos[3], Config.SetWindowPos[4], Config.SetWindowPos[5])
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        if not InCombatLockdown() then
            f:StartMoving()
        end
    end)
    f:SetScript("OnDragStop", function(self)
        f:StopMovingOrSizing()
        Config.SetWindowPos[1], _, Config.SetWindowPos[3], Config.SetWindowPos[4], Config.SetWindowPos[5] = f:GetPoint()
    end)
    f:SetScript("OnMouseDown", clearAllFocus)
    f:SetPropagateKeyboardInput(false)
    f:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            f:SetPropagateKeyboardInput(false)
            f:Hide()
        else
            f:SetPropagateKeyboardInput(true)
        end
    end)
    f:Hide()
    self.background = f
    do -- 创建框体标题栏纹理
        local t = f:CreateTexture(nil, "ARTWORK")
        t:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
        t:SetWidth(360)
        t:SetHeight(64)
        t:SetPoint("TOP", f, 0, 12)
        f.texture = t
    end
    do -- 创建框体标题
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(string.format(L["Loot Monitor v%s"], Addon.Version))
        t:SetPoint("TOP", f.texture, 0, -14)
    end
    do -- 创建关闭按钮
        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetWidth(120)
        b:SetHeight(25)
        b:SetPoint("BOTTOMLEFT", 220, 20)
        b:SetText(CLOSE)
        b:SetScript("OnClick", function() f:Hide() end)
    end
    do -- 插件开关
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
        t:SetText(L["Enabled"])
        local c = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        c:SetPoint("TOPLEFT", 15, -40)
        t:SetPoint("LEFT", c, "RIGHT", 5, 0)
        c:SetScript("OnShow", function(self) self:SetChecked(Config.Enabled) end)
        c:SetScript("OnClick", function(self) Config.Enabled = self:GetChecked() end)
    end
    do -- 输出至RW频道选择框
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
        t:SetText(L["Output to RW"])
        local c = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        c:SetPoint("TOPLEFT", 85, -40)
        t:SetPoint("LEFT", c, "RIGHT", 5, 0)
        c:SetScript("OnShow", function(self) self:SetChecked(Config.OutputToRaidWarning) end)
        c:SetScript("OnClick", function(self) Config.OutputToRaidWarning = self:GetChecked() end)
    end
    do -- 通报new本
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
        t:SetText(L["First Enterer"])
        local c = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        c:SetPoint("BOTTOMLEFT", 50, 20)
        t:SetPoint("LEFT", c, "RIGHT", 5, 0)
        c:SetScript("OnShow", function(self) self:SetChecked(Config.EnteringCheck) end)
        c:SetScript("OnClick", function(self)
            Config.EnteringCheck = self:GetChecked()
            if Config.EnteringCheck and not Addon.Frame:IsShown() then
                Addon.Frame:Show()
            end
        end)
    end
    do -- 小地图按钮
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
        t:SetText(L["Mini Btn"])
        local c = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        c:SetPoint("TOPLEFT", 15, -77)
        t:SetPoint("LEFT", c, "RIGHT", 5, 0)
        c:SetScript("OnShow", function(self) self:SetChecked(Config.MinimapIcon) end)
        c:SetScript("OnClick", function(self)
            Config.MinimapIcon = self:GetChecked()
            if Config.MinimapIcon and not Addon.MinimapIcon.Minimap:IsShown() then
                Addon.MinimapIcon.Minimap:Show()
            else
                Addon.MinimapIcon.Minimap:Hide()
            end
        end)
    end
    do -- 仅提示Boss
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
        t:SetText(L["Boss Only"])
        local c = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        c:SetPoint("TOPLEFT", 200, -40)
        t:SetPoint("LEFT", c, "RIGHT", 5, 0)
        c:SetScript("OnShow", function(self) self:SetChecked(Config.BossOnly) end)
        c:SetScript("OnClick", function(self) Config.BossOnly = self:GetChecked() end)
    end
    do -- 选择通报品质下拉菜单
        local d = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmallLeft")
        t:SetText(L["Quality"])
        t:SetPoint("LEFT", d, "LEFT", -60, 2)

        local value = {1, 2, 3, 4,}
        local text = {L["|cFFFFFFFFCommon|r"], L["|cFF1EFF00Uncommon|r"], L["|cFF0081FFRare|r"], L["|cFFC600FFEpic|r"],}
        UIDropDownMenu_Initialize(d, function(self)
            local info = UIDropDownMenu_CreateInfo()
            d.text = text
            for i = 1, 4 do
                info.text = text[i]
                info.value = value[i]
                info.func = function(v)
                    Config.Quality = v.value
                    UIDropDownMenu_SetText(d, text[v.value])
                    CloseDropDownMenus()
                end
                info.arg1, info.arg2 = d, value[i]
                UIDropDownMenu_AddButton(info)
            end
        end)
        d.SetValue = function(v) Config.Quality = v end
        d:SetScript("OnShow", function(self)
            UIDropDownMenu_SetText(self, self.text[Config.Quality])
        end)
        UIDropDownMenu_JustifyText(d, "CENTER")
        UIDropDownMenu_SetWidth(d, 120)
        UIDropDownMenu_SetButtonWidth(d, 120)
        d:SetPoint("TOPLEFT", 185, -75)
    end
    do -- Check Stats 和 Show Logs 按钮
        -- 显示框
        do
            for i = 1, 40 do
                local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
                t:SetWidth(150)
                t:SetHeight(25)
                t:SetText("")
                if math.fmod(i,2) == 1 then
                    t:SetPoint("TOPLEFT", f, 20, -145-math.modf((i-1)/2)*15)
                else
                    t:SetPoint("TOPLEFT", f, 190, -145-math.modf((i-1)/2)*15)
                end
                t_insert(GroupState, t)
            end
        end
        -- Check All Button
        local b1 = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b1:SetWidth(120)
        b1:SetHeight(25)
        b1:SetText(L["Check Stats"])
        b1:SetScript("OnClick", function()
            if IsInGroup() then
                Addon:DoCheck()
                print(L["<|cFFFF4500LM|r>Check |cFFFF4500LootMonitor|r Addon State."])
                C_Timer.After(1, function() Addon:DoShowState() end)
            else
                print(L["<|cFFFF4500LM|r>Not in a Group."])
            end
        end)
        -- Show State Button
        local b2 = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b2:SetWidth(120)
        b2:SetHeight(25)
        b2:SetText(L["Show Logs"])
        b2:SetScript("OnClick", function() Addon:PrintLootLog() end)
        b1:SetPoint("TOPLEFT", 90, -115)
        b2:SetPoint("TOPLEFT", 220, -115)
    end
end