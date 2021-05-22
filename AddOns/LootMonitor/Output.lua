-- 输出窗口

local _, Addon = ...

local Output = Addon.Output
local L = Addon.L

local Config = Addon.Config

--初始化Export窗口
function Output:Initialize()
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
    f:SetPoint(Config.OutputPos[1], nil, Config.OutputPos[3], Config.OutputPos[4], Config.OutputPos[5])
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
        Config.OutputPos[1], _, Config.OutputPos[3], Config.OutputPos[4], Config.OutputPos[5] = f:GetPoint()
    end)
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
        t:SetText("")
        t:SetPoint("TOP", f.texture, 0, -14)
        self.title = t
    end
    do -- 保存时长EditBox
        local t1 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t1:SetText(L["Expired In "])
        local t2 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t2:SetText(L[" Day(s)"])

        local e = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        e:SetWidth(30)
        e:SetHeight(25)
        e:SetAutoFocus(false)
        e:SetMaxLetters(2)
        e:SetNumeric()
        e:SetScript("OnEnterPressed", function(self)
            if self:HasFocus() then
                if tonumber(self:GetText()) then
                    local Days = math.floor(tonumber(self:GetText()))
                    if Days >= 0 and Days <= 30 then
                        Config.ExpireDay = Days
                    end
                end
            end
            self:SetText(tostring(Config.ExpireDay))
            self:ClearFocus()
        end)
        e:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        e:SetScript("OnEscapePressed", function(self)
            self:SetText(tostring(Config.ExpireDay))
            self:ClearFocus()
        end)
        e:SetScript("OnShow", function(self) self:SetText(tostring(Config.ExpireDay)) end)
        e:SetPoint("BOTTOMLEFT", f, 90, 20)
        t1:SetPoint("RIGHT", e, "LEFT", -10, 0)
        t2:SetPoint("LEFT", e, "RIGHT", 5, 0)
        self.days = e
    end
    do -- 创建清理按钮
        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetWidth(80)
        b:SetHeight(25)
        b:SetPoint("BOTTOMLEFT", 160, 20)
        b:SetText(L["Clean"])
        b:SetScript("OnClick", function(self) Addon:CleanLootLogs() end)
    end
    do -- 创建关闭按钮
        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetWidth(80)
        b:SetHeight(25)
        b:SetPoint("BOTTOMLEFT", 250, 20)
        b:SetText(CLOSE)
        b:SetScript("OnClick", function(self) f:Hide() end)
	end
    do -- 带Scroll的可编辑输出窗口
        local t = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        t:SetPoint("TOPLEFT", f, 25, -40)
        t:SetWidth(290)
        t:SetHeight(420)

        local export = CreateFrame("EditBox", nil, t)
        export.cursorOffset = 0
        export:SetWidth(290)
        export:SetHeight(420)
        export:SetPoint("TOPLEFT", t, 15, 0)
        export:SetAutoFocus(false)
        export:EnableMouse(true)
        export:SetMaxLetters(99999999)
        export:SetMultiLine(true)
        export:SetFontObject(GameTooltipText)
        export:SetScript("OnTextChanged", function(self)
            ScrollingEdit_OnTextChanged(self, t)
        end)
        export:SetScript("OnCursorChanged", ScrollingEdit_OnCursorChanged)
        export:SetScript("OnEscapePressed", function() f:Hide() end)
        export:SetScript("OnEditFocusGained", function() export:HighlightText() end)
        export:Disable()

        export:SetScript("OnEnter", function()
            if not InCombatLockdown() then
                export:Enable()
            end
        end)
        export:SetScript("OnLeave", function() export:HighlightText(0, 0) export:Disable() end)

        self.export = export

        t:SetScrollChild(export)

        t:Hide()
    end
end
